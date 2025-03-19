var newTaskCaptionPM = "Nueva Tarea";

// Inicializa una nueva instancia del tipo 'ProcessData'.
// Representa le conjunto de datos asociados a un proceso en particular.
function ProcessData(position)
{
	this.src = '';
	this.position = position;
	this.external = false;
	// Se almacenan referencias a los controles solicitados desde el paso
	this.declaredControls = null;
	this.controls = null;
}

function History()
{
	this.position = 0;
	this.length = 0;
}

function pMForward()
{
	if (this.current >= 0)
	{
		//En caso de ser un sitio externo se utiiliza el 'history' del navegador
		if (this.mapIdToPos[this.mapPosToId[this.current]].external)
		{
			if (this.history.position < this.history.length - 1)
			{
				this.history.position++;
				if (this.list[this.current].contentWindow.fowardExternal != null)
					this.list[this.current].contentWindow.fowardExternal();
			}
		}
		else
		{
			if (this.list[this.current].contentWindow.forward != null)
				this.list[this.current].contentWindow.forward();
		}
	}
}

function pMBack()
{
	if (this.current >= 0)
	{
		// En caso de ser un sitio externo se utiliza el 'history' del navegador
		if (this.mapIdToPos[this.mapPosToId[this.current]].external)
		{
			if (this.history.position > 0)
			{
				this.history.position--;
				if (this.list[this.current].contentWindow.backExternal != null)
					this.list[this.current].contentWindow.backExternal();
			}
		}
		else
		{
			if (this.list[this.current].contentWindow.back != null)
				this.list[this.current].contentWindow.back();
		}
	}
}

function pMResetCurrent(src, name)
{
	var iframe;
	
	if (this.list[this.current] != null)
	{
 		// Se elimina el 'history'
		resetHistoryPM(this);

		// Se agrega el nu'mero de proceso que es calculado en el cliente como "id + 1" (se evita el 0 porque 
		// es el valor por defecto de los nume'ricos)
		this.mapIdToPos[this.mapPosToId[this.current]].src = src + (this.mapPosToId[this.current] + 1);
		this.mapIdToPos[this.mapPosToId[this.current]].external = false;
		this.mapIdToPos[this.mapPosToId[this.current]].declaredControls = null;
		this.mapIdToPos[this.mapPosToId[this.current]].controls = null;

		// En caso de tener un proceso previo cargado se resetea para reutilizar los pasos
		if (this.list[this.current].contentWindow.resetAll != null)
			this.list[this.current].contentWindow.resetAll();
		else
		{
			// En caso que la funcio'n "this.list[this.current].contentWindow.resetAll" no este' definida quiere decir
			// que au'n no se termino' de cargar el "processIndex.html" correspondiente al espacio de trabajo que se quiere
			// resetear. Esto puede provocar problemas porque si se quita este IFRAME del DOM y luego se recibe el "processIndex.html"
			// se va a estar ejecutando co'digo (innceseario) en una parte que no pertenece al a'rbol, en particular los IFRAMES creados
			// alli' nunca tendra'n su "contentWindow" definido. Por lo tanto, para poder reutilizar este IFRAME como "cover" del nuevo
			// espacio de trabajo se asigna una direccio'n vaci'a de forma de abortar el pedido viejo al "processIndex.html"
			this.list[this.current].contentWindow.location.replace("about:blank");

			// Se crea un nuevo 'iframe' de manera de evitar el parpadeo. El actual (que esta' vaci'o)
			// pasa a ser la tapa de e'ste iframe. Dicha tapa se removera' al terminar de cargar la
			// pa'gina 'processIndex.html' evitando asi' el parpadeo.
			
			if ((iframe = this.pool.pop()) != null)
			{
				iframe.style.visibility = 'hidden';
				iframe.id = this.mapPosToId[this.current];
			}
			else
				iframe = document.createElement("<IFRAME ONLOAD='if (this.contentWindow.initialize != null) {this.contentWindow.initialize(this.id);}' ID='" + this.mapPosToId[this.current] + "' FRAMEBORDER='0' ONFOCUS='this.hideFocus = true;pageMousedown(event)' STYLE='position:absolute; left: 0px; margin-left: 0px; visibility: hidden;' HEIGHT='100%' WIDTH='100%' SCROLLING='no' SRC='javascript:\"\"'>");

			this.container.appendChild(iframe);
			
			// Se borra el contenido anterior
			iframe.contentWindow.document.write('');
			iframe.contentWindow.document.close();
			
			this.covers[this.current] = this.list[this.current];
			this.list[this.current] = iframe;
			
			iframe.contentWindow.location.replace('processIndex.html');
		}

		// Se actualiza la estructura de leng'u'etas
		this.tabManager.setCaption(this.current, name);
	}
}

// 'initial' indica si es se trata de la pa'gina inicial configurada para el usuario, en cuyo caso se evitara' cerrar el menu' la primera vez
// para mejorar la usabilidad si el usuario va enseguida a navegar el menu' sin importarle le pa'gina inicial.
function pMStartNew(src, name, initial)
{
	var iframe, id;

	if ((typeof(initial) == "undefined") || (initial == null))
		initial = false;

 	// Se elimina el 'history'
	resetHistoryPM(this);
	
	// Se oculta el 'iframe' anterior en caso de existir
	if (this.current > -1)
	{
		this.list[this.current].style.visibility = 'hidden';
		if (this.list[this.current].contentWindow.makeInvisible != null)
			this.list[this.current].contentWindow.makeInvisible();
	}

	// Se actualiza la estructura de leng'u'etas
	this.tabManager.enqueueTab();
	this.tabManager.setCaption(this.size, name);

	id = this.nextFreePos;

	// Se busca la pro'xima posicio'n libre para uso futuro
	for (i = id + 1; i < this.mapIdToPos.length; i++)
	{
		if ((this.mapIdToPos[i] == null) || (this.mapIdToPos[i].position == -1))
		{
			this.nextFreePos = i;
			break;
		}
	}

	if (this.nextFreePos == id)
	{
		this.nextFreePos = this.mapIdToPos.length;
		this.mapIdToPos[this.mapIdToPos.length] = new ProcessData(-1);
	}

	if ((iframe = this.pool.pop()) != null)
	{
		iframe.style.visibility = 'hidden';
		iframe.id = id;
	}
	else
	{
		iframe = document.createElement("<IFRAME ONLOAD='if (this.contentWindow.initialize != null) {this.contentWindow.initialize(this.id);}' ID='" + id + "' FRAMEBORDER='0' ONACTIVATE='this.hideFocus=true;if(!this.firstTime){pageMousedown(event);}else{this.firstTime=false;}' STYLE='position:absolute; left: 0px; margin-left: 0px; visibility: hidden;' HEIGHT='100%' WIDTH='100%' SCROLLING='no' SRC='javascript:\"\"'>");
		iframe.firstTime = initial;
	}

	this.current = this.size;

	// Se almacena la informacio'n de la aplicacio'n actual
	if (this.mapIdToPos[id] == null)
		this.mapIdToPos[id] = new ProcessData(this.size);
	else
	{
		this.mapIdToPos[id].src = '';
		this.mapIdToPos[id].external = false;
		this.mapIdToPos[id].position = this.size;
		this.mapIdToPos[id].declaredControls = null;
		this.mapIdToPos[id].controls = null;
	}

	this.mapPosToId[this.size] = id;
	this.list[this.size++] = iframe;

	this.container.appendChild(iframe);

	// Se borra el contenido anterior
	iframe.contentWindow.document.write('');
	iframe.contentWindow.document.close();

	// Se agrega el nu'mero de proceso que es calculado en el cliente como "id + 1" (se evita el 0 porque 
	// es el valor por defecto de los nume'ricos)
	this.mapIdToPos[this.mapPosToId[this.current]].src = src + (this.mapPosToId[this.current] + 1);

	iframe.contentWindow.location.replace('processIndex.html');
}

function pMCloseCurrent(makeVisible)
{
    makeVisible = typeof(makeVisible) == 'undefined' || makeVisible;
	var id, iframe;
	
	// Se elimina el 'history'
	resetHistoryPM(this);
	
	if (this.list[this.current] != null)
	{
		iframe = this.list[this.current];

		// Se libera el identificador acutual y se actuliza el pro'ximo libre en caso de ser necesario
		this.mapIdToPos[this.mapPosToId[this.current]].position = -1;
		if (this.nextFreePos > this.mapPosToId[this.current])
			this.nextFreePos = this.mapPosToId[this.current];

		// Se corren hacia la izquierda los procesos que se encontraban luego
		for (i = this.current; i < this.size - 1; i++)
		{
			this.mapIdToPos[this.mapPosToId[i + 1]].position = i;
			this.mapPosToId[i] = this.mapPosToId[i + 1];
			this.list[i] = this.list[i + 1];
		}

		this.tabManager.removeTabAt(this.current);

		this.size--;

		if (this.current == this.size)
			this.current--;

		// Se oculta para evitar parpadeos
		iframe.style.visibility = 'hidden';

		if (this.size == 0)
			this.startEmpty();
		else
		{
			this.goTo(this.current, makeVisible);
			if (makeVisible)
			    this.tabManager.select(this.current);
		}
		
		// Se eliminan todos los 'popups' que hubiesen dentro del proceso eliminado
		iframe.contentWindow.removeAllPopups();

		// Se remueve al final para evitar parpadeos
		this.container.removeChild(iframe);
		this.pool.push(iframe);
	}
}

function pMStartEmpty()
{
	var iframe, id;
				 
	// Se elimina el 'history'
	resetHistoryPM(this);
	
	// Se oculta el 'iframe' anterior en caso de existir
	if (this.current > -1)
	{
		this.list[this.current].style.visibility = 'hidden';
		if (this.list[this.current].contentWindow.makeInvisible != null)
			this.list[this.current].contentWindow.makeInvisible();
	}

	// Se actualiza la estructura de leng'u'etas
	this.tabManager.enqueueTab();
	this.tabManager.setCaption(this.size, newTaskCaptionPM);

	id = this.nextFreePos;

	// Se busca la pro'xima posicio'n libre para uso futuro
	for (i = id + 1; i < this.mapIdToPos.length; i++)
	{
		if ((this.mapIdToPos[i] == null) || (this.mapIdToPos[i].position == -1))
		{
			this.nextFreePos = i;
			break;
		}
	}

	if (this.nextFreePos == id)
	{
		this.nextFreePos = this.mapIdToPos.length;
		this.mapIdToPos[this.mapIdToPos.length] = new ProcessData(-1);
	}

	if ((iframe = this.pool.pop()) != null)
	{
		iframe.style.visibility = 'hidden';
		iframe.id = id;
	}
	else
		iframe = document.createElement("<IFRAME ONLOAD='if (this.contentWindow.initialize != null) {this.contentWindow.initialize(this.id);}' ID='" + id + "' FRAMEBORDER='0' ONFOCUS='this.hideFocus = true;pageMousedown(event)' STYLE='position:absolute; left: 0px; margin-left: 0px; visibility: hidden;' HEIGHT='100%' WIDTH='100%' SCROLLING='no' SRC='javascript:\"\"'>");

	this.current = this.size;

	// Se almacena la informacio'n de la aplicacio'n actual
	if (this.mapIdToPos[id] == null)
		this.mapIdToPos[id] = new ProcessData(this.size);
	else
	{
		this.mapIdToPos[id].src = '';
		this.mapIdToPos[id].external = false;
		this.mapIdToPos[id].position = this.size;
		this.mapIdToPos[id].declaredControls = null;
		this.mapIdToPos[id].controls = null;
	}

	this.mapPosToId[this.size] = id;
	this.list[this.size++] = iframe;

	this.container.appendChild(iframe);

	// Se borra el contenido anterior
	iframe.contentWindow.document.write('');
	iframe.contentWindow.document.close();

	iframe.contentWindow.location.replace('processIndex.html');
}

function pMGoTo(index, makeVisible)
{
    makeVisible = typeof(makeVisible) == 'undefined' || makeVisible;
	var lastPos;

	if ((index < this.size) && (index > -1))
	{
		lastPos = this.current;
		
		this.current = index;
		
		eval(this.callBack);

		if (lastPos != this.current)
		{
			// Se elimina el 'history'
			resetHistoryPM(this);

			if (lastPos > -1 && makeVisible)
			{		
				this.list[lastPos].style.visibility = 'hidden';
				if (this.list[lastPos].contentWindow.makeInvisible != null)
					this.list[lastPos].contentWindow.makeInvisible();
			}
		}

        if (makeVisible)
        {
		    this.list[this.current].style.visibility = 'visible';
		    if (this.list[this.current].contentWindow.makeVisible != null)
			    this.list[this.current].contentWindow.makeVisible();
			
			this.tabManager.select(this.current);
        }
        
		return true;
	}

	return false;
}

function pMNotifyLoadEnd(processId, advice)
{
	var loadPos;

	if ((this.mapIdToPos[processId] != null) && (this.mapIdToPos[processId].position != -1))
	{					 
		// Se elimina el 'history'
		resetHistoryPM(this);
		
		loadPos = this.mapIdToPos[processId].position;
		
		if (loadPos != this.current)
		{
			if (advice)
				this.tabManager.adviceAt(loadPos);
			return false;
		}
		else
		{
			eval(this.callBack);
			return true;
		}
	}
	
	return false;
}

// Notifica la finalizacio'n de la carga de la pa'gina principal del proceso indicado.
// Sirve para remover la tapa de dicho proceso evitando parpadeos.
function pMNotifyIndexLoadEnd(processId)
{
	var loadPos;

	if ((this.mapIdToPos[processId] != null) && (this.mapIdToPos[processId].position != -1))
	{	  
		// Se elimina el 'history'
		resetHistoryPM(this);
	
		loadPos = this.mapIdToPos[processId].position;
		
		if (this.covers[loadPos] != null)
		{
			this.pool.push(this.covers[loadPos]);
			this.container.removeChild(this.covers[loadPos]);
			this.covers[loadPos] = null;
		}
		
		if (loadPos == this.current)
		{
			this.list[this.current].style.visibility = 'visible';
			eval(this.callBack);
		}
	}
}

// Ajusta el tamaño del 'iframe' correspondiente al proceso actual en caso de existir.
// 'newHeight' -> nueva altura del 'iframe' correspondiente al proceso actual.
// 'newTop' -> nuevo distancia del 'iframe' correspondiente al proceso actual hacia el el borde superior de la pantalla.
// 'newWidth' -> nuevo ancho del 'iframe' correspondiente al proceso actual.
function pMResizeCurrent(newHeight, newTop, newWidth)
{
	if (this.current > -1)
	{
		this.list[this.current].height = newHeight;
		this.list[this.current].top = newTop;
		this.list[this.current].width = newWidth;
		if ((this.list[this.current].contentWindow != null) && (this.list[this.current].contentWindow.pageResize != null))
			this.list[this.current].contentWindow.pageResize();
	}
}

function pMGetSrc(processId)
{
	if ((this.mapIdToPos[processId] != null) && (this.mapIdToPos[processId].position != -1))
		return this.mapIdToPos[processId].src;
	
	return null;
}

function pMCloseAll()
{
    while (this.size > 1)
    {
        this.goTo(this.current);
	    this.closeCurrent(false);
    }
	if (!procManager.currentIsEmpty())
	{
		this.closeCurrent();
	}
}

function pMCloseProcess(processId)
{
	if ((this.mapIdToPos[processId] != null) && (this.mapIdToPos[processId].position != -1))
	{
		var c = this.current;
		this.current = this.mapIdToPos[processId].position;

		if (this.current == c)
			this.closeCurrent();
		else
		{
			if (this.current < c)
				c--;
			this.closeCurrent();
			this.current = c;
			this.goTo(this.current);
			this.tabManager.select(this.current);
		}
	}
}

// 'resetContent' indica si se debe reiniciar la pa'gina contenida o no
function pMResetProcess(processId, resetContent)
{
	if ((this.mapIdToPos[processId] != null) && (this.mapIdToPos[processId].position != -1))
	{
		// Se elimina el 'history'
		resetHistoryPM(this);
		
		pos = this.mapIdToPos[processId].position;
		
		this.mapIdToPos[processId].src = '';
		this.mapIdToPos[processId].external = false;
		this.mapIdToPos[processId].declaredControls = null;
		this.mapIdToPos[processId].controls = null;

		// Se resetea para reutilizar los pasos
		if ((resetContent) && (this.list[pos].contentWindow.clearAll != null))
			this.list[pos].contentWindow.clearAll();

		// Se actualiza la estructura de leng'u'etas
		this.tabManager.setCaption(pos, newTaskCaptionPM);
	}
}

function pMRefreshCurrent()
{
	if ((this.current >= 0) && (this.list[this.current].contentWindow.refresh != null))
	{
		// El refresh no esta' disponible para pa'ginas externas
		if (!this.mapIdToPos[this.mapPosToId[this.current]].external)
			this.list[this.current].contentWindow.refresh();
	}
}

function pMCurrentIsEmpty()
{
	if (this.current < 0)
		return true;

	return this.list[this.current].contentWindow.getNumberOfSteps() == 0;
}

function pMFocusOnCurrent()
{
	if ((this.current >= 0) && (this.list[this.current].contentWindow.refresh != null))
	{
		// El refresh no esta' disponible para pa'ginas externas
		if (!this.mapIdToPos[this.mapPosToId[this.current]].external)
			this.list[this.current].contentWindow.focus();
	}
}

function pMPrintCurrent()
{
	if ((this.current >= 0) && (this.list[this.current].contentWindow.printContent != null))
		this.list[this.current].contentWindow.printContent();
}

// Devuelve el nombre del programa actual
function pMGetCurrentPgm()
{
	if (this.current != -1)
		if (this.list[this.current].contentWindow.getCurrentPgm != null)
			return this.list[this.current].contentWindow.getCurrentPgm();
	
	return "";
}

function pMIsCurrentMark(mark)
{
	if ((this.current > -1) && 
	  (typeof(this.list[this.current].contentWindow.isCurrentMark) != "undefined") && 
	  (this.list[this.current].contentWindow.isCurrentMark != null))
		return this.list[this.current].contentWindow.isCurrentMark(mark);

	return false;
}

function pMNotifyExternalWorkSpace(processId)
{
	if ((this.mapIdToPos[processId] != null) && (this.mapIdToPos[processId].position != -1))
	{
		// Se elimina el 'history'
		resetHistoryPM(this);
	
		this.mapIdToPos[processId].external = true;
	}
}

function pMNotifyExternalChange(processId)
{
	if ((this.mapIdToPos[processId] != null) && (this.mapIdToPos[processId].position != -1))
	{
		if (this.mapIdToPos[processId].position != this.current)
		{
			// Se elimina el 'history'
			resetHistoryPM(this);
		}

		this.history.position++;
		this.history.length = this.history.position + 1;
	}
}

function pMNextWorkspace()
{
	var index;

	if (this.current < this.size -1)
		index = this.current + 1;
	else
		index = 0;

	this.goTo(index);
	this.tabManager.select(index);
}

function pMPrevWorkspace()
{
	var index;

	if (this.current > 0)
		index = this.current - 1;
	else
		index = this.size - 1;

	this.goTo(index);
	this.tabManager.select(index);
}

function pMGetElements(tagName)
{
	if (this.current >= 0)
		return this.list[this.current].contentWindow.getElements(tagName);
	else
		return null;
}

function pMGetScrollTop()
{
	if (this.current >= 0)
		return this.list[this.current].contentWindow.getScrollTop();
	else
		return 0;
}

// Intenta setear el foco en algu'n espacio de trbajo que contenga un paso con la marca indicada.
function pMSetMarkedFocus(mark)
{
	var step;
	
	for (var i = 0; i < this.size; i++)
	{
		if ((step = this.list[i].contentWindow.hasMarkedStep(mark)) != -1)
		{
			// Se setea el foco en el paso indicado
			this.list[i].contentWindow.selectStep(step);

			// Se define el espacio 'i' como actual
			this.goTo(i);
			this.tabManager.select(i);
			
			return true;
		}
	}
	
	return false;
}

// Para'metros:
//   "workSpaceId"  -> Espacio de trabajo que declara los controles.
//   "controls" -> Informacio'n del conjunto de controles a declarar. Es un vector de vectores, donde cada vector interno contiene 3 componentes.
//                 El primero es el nombre de la instancia, el segundo es el nombre de la clase, y el tercero es la lista de descripciones de controles
//                 de la clase indicada diponibles en el sistema.
// Devuelve un vector con las clases de controles no definidas.
function pMDeclareControls(workSpaceId, controls)
{
	var idToPos = this.mapIdToPos[workSpaceId];
	var result = null;
	var controlsToDeclare = null;

	if ((controls == null) || (controls.length == 0))
		return null;

	controlsToDeclare = new Array();

	if ((idToPos != null) && (idToPos.position != -1))
	{
		for (var i in controls)
		{
			// El control no esta' definido, por lo tanto en la componente 0 esta' la clase del mismo
			if (controls[i][1] == null)
			{
				if (result == null)
					result = new Array();
				
				result.push(controls[i][0]);
			}
			else
				controlsToDeclare.push(controls[i]);
		}
	
		// Se guardan asociadas al espacio de trabajo las declaraciones de forma de que cuando realmente se necesiten las
		// mismas se puedan instanciar
		if (idToPos.declaredControls == null)
			idToPos.declaredControls = controlsToDeclare;
		else
			// Si ya habi'a alguna declaracio'n, simplemente se agregan las nuevas
			idToPos.declaredControls = controlsToDeclare.concat(idToPos.declaredControls);
	}
	
	return result;
}

function pMInvokeCommand(workSpaceId, instanceName, methodName, params, resultReceiver)
{
	var i, map = this.mapIdToPos[workSpaceId];

	if ((map != null) && (map.position != -1))
	{
		// Se analiza si el control realmente fue inicializado
		for (i in map.controls)
		{
			if (map.controls[i][0] == instanceName)
			{
				// El control ya estaba instanciado, se invoca el comando
				map.controls[i][1].invoke(methodName, params, resultReceiver);
				return true;
			}
		}
		
		// Si no se econtro' el control instanciado, se busca en los declarados para instanciarlo
		for (i in map.declaredControls)
		{
			if (map.declaredControls[i][0] == instanceName)
			{
				// Se encontro' la declaracio'n, por lo tanto se instancia
				var instance = top.controlFactoryInstance.getInstance(map.declaredControls[i][1], map.declaredControls[i][2]);
				
				if (map.controls == null)
					map.controls = new Array();
				map.controls.push([map.declaredControls[i][0], instance]);

				// Se incova el comando indicado
				instance.invoke(methodName, params, resultReceiver);
				return true;
			}
		}
	}

	return false;
}

function pMIsExternal()
{
	try
	{
		if (this.current >= 0)
			return this.list[this.current].contentWindow.isExternalStep();
		else
			return false;
	}
	catch (e)
	{
		return true;
	}
}

function pMGetScrollTop()
{
	if (this.current >= 0)
	{
		var method = this.list[this.current].contentWindow.getScrollTop;
		if ((typeof(method) != "undefined") && (method != null))
			return method();
	}

	return 0;
}

function pMGetScrollLeft()
{
	if (this.current >= 0)
	{
		var method = this.list[this.current].contentWindow.getScrollLeft;
		if ((typeof(method) != "undefined") && (method != null))
			return method();
	}
	else
		return 0;
}

function pMIsControlReady(workSpaceId, instanceName, callBack, params)
{
	var i, map = this.mapIdToPos[workSpaceId];
	
	if ((map != null) && (map.position != -1))
	{
		// Se analiza si el control realmente fue inicializado
		for (i in map.controls)
		{
			if (map.controls[i][0] == instanceName)
			{
				// El control ya estaba instanciado, se invoca el comando
				return map.controls[i][1].executionEnd(callBack, params);
			}
		}
	}

	return true;
}

function pMGetCount()
{
	return this.size;
}

// Inicializa una nueva instancia de tipo 'ProcessManager'.
// 'container' -> es el elemento que contandri' las aplicaciones.
// 'tabContainer' -> es el elemento que conendra' los 'tabs'.
// 'currentChangeCallBack' -> co'digo de notificacio'n a ejectutar cuando cambie la aplicacio'n actual por 
//                            una accio'n interna, o por una notificacio'n de carga terminada.
function ProcessManager(container, tabContainer, currentChangeCallBack, TabManager)
{
	this.list = new Array();
	this.pool = new Array();
	this.covers = new Array();
	this.mapPosToId = new Array(10);
	this.mapIdToPos = new Array(10);
	this.nextFreePos = 0;
	this.current = -1;
	this.size = 0;
	this.container = container;
	this.callBack = currentChangeCallBack;
	this.tabManager = TabManager;
	this.printArea = null;
	this.pText = new Array();
	this.history = new History();
}

// Propiedades comunes a todos los objetos de tipo 'ProcessManager'
ProcessManager.prototype.back = pMBack;
ProcessManager.prototype.forward = pMForward;
ProcessManager.prototype.startEmpty = pMStartEmpty;
ProcessManager.prototype.closeCurrent = pMCloseCurrent;
ProcessManager.prototype.currentIsEmpty = pMCurrentIsEmpty;
ProcessManager.prototype.resetCurrent = pMResetCurrent;
ProcessManager.prototype.refreshCurrent = pMRefreshCurrent;
ProcessManager.prototype.focusOnCurrent = pMFocusOnCurrent;
ProcessManager.prototype.printCurrent = pMPrintCurrent;
ProcessManager.prototype.resizeCurrent = pMResizeCurrent;
ProcessManager.prototype.notifyLoadEnd = pMNotifyLoadEnd;
ProcessManager.prototype.getSrc = pMGetSrc;
ProcessManager.prototype.goTo = pMGoTo;
ProcessManager.prototype.notifyIndexLoadEnd = pMNotifyIndexLoadEnd;
ProcessManager.prototype.startNew = pMStartNew;
ProcessManager.prototype.getCurrentPgm = pMGetCurrentPgm;
ProcessManager.prototype.resetProcess = pMResetProcess;
ProcessManager.prototype.closeProcess = pMCloseProcess;
ProcessManager.prototype.closeAll = pMCloseAll;
ProcessManager.prototype.notifyExternalWorkSpace = pMNotifyExternalWorkSpace;
ProcessManager.prototype.notifyExternalChange = pMNotifyExternalChange;
ProcessManager.prototype.nextWorkspace = pMNextWorkspace;
ProcessManager.prototype.prevWorkspace = pMPrevWorkspace;
ProcessManager.prototype.getElements = pMGetElements;
ProcessManager.prototype.getScrollTop = pMGetScrollTop;
ProcessManager.prototype.setMarkedFocus = pMSetMarkedFocus;
ProcessManager.prototype.isExternal = pMIsExternal;
ProcessManager.prototype.getScrollTop = pMGetScrollTop;
ProcessManager.prototype.getScrollLeft = pMGetScrollLeft;
ProcessManager.prototype.isCurrentMark = pMIsCurrentMark;
ProcessManager.prototype.getCount = pMGetCount;
// Controles de cliente
ProcessManager.prototype.declareControls = pMDeclareControls;
ProcessManager.prototype.invokeCommand = pMInvokeCommand;
ProcessManager.prototype.isControlReady = pMIsControlReady;

function resetHistoryPM(procManager)
{
	procManager.history.length = 0;
	procManager.history.position = 0;
}
