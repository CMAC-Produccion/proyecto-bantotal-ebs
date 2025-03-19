var popCount = 0;

// CONTENEDOR DE 'POPUPS'
function pUMChangeAllVisibility(visibility)
{
	var value = visibility ? "inline" : "none";

	for (var i = 0; i < this.list.length; i++)
		if (this.list[i] != null)
			this.list[i].style.display = value;
}

function pUMAdd(parentId, url, width, height, title, isPrompt)
{
	var id = this.nextFreePos;
	var panel;

	// Se busca la próxima posición libre para uso futuro
	for (i = id + 1; i < this.list.length; i++)
	{
		if (this.list[i] == null)
		{
			this.nextFreePos = i;
			break;
		}
	}

	// Se reutiliza o construye un nuevo 'popup'
	if ((panel = popupManager.getPopupFromPool()) != null)
	{
		panel.lastChild.popupId = id;
		panel.lastChild.parentId = parentId;
		// Se oculta el 'iframe'
		panel.lastChild.style.display = "none";
	}
	else
		panel = this.createPanel(parentId, id, width, height, title, isPrompt);

	this.list[id] = panel;

	if (this.nextFreePos == id)
	{
		this.nextFreePos = this.list.length;
		this.list[this.nextFreePos] = null;
	}

	document.body.appendChild(panel);

	// Se borra el contenido anterior y se setea la nueva URL
	this.setURL(panel, url);

	return id;
}

function pUMRemove(popupId)
{
	var pop;
	
	if ((pop = this.list[popupId]) != null)
	{
		// En caso de haberse liberado una posición anterior a la próxima libre se modifica la próxmia libre
		if (this.nextFreePos > popupId)
			this.nextFreePos = popupId;

		// Se elimina del documento
		document.body.removeChild(pop);

		// Se agrega al 'pool' para futuro reuso
		popupManager.addPopupToPool(pop);
		this.list[popupId] = null;
		
		var pos;
		
		// Se resta uno a la pocici'on en la que se hab'ia abierto este 'popup'
		if ((pos = pop.lastChild.position) != null)
			if (pos >= 0)
				this.positions[pos]--;
	}
}

function pUMRemoveAll()
{
	var i;

	for (i = 0; i < this.list.length; i++)
	{
		if (this.list[i] != null)
		{
			// Se elimina del documento
			document.body.removeChild(this.list[i]);
			
			// Se agrega al 'pool' para futuro reuso
			popupManager.addPopupToPool(this.list[i]);
			this.list[i] = null;
		}
	}

	// Se re-inicializa
	this.nextFreePos = 0;
	this.free = true;
	this.parent = null;
	this.positions = new Array(0, 0, 0, 0);
}

function pUMSetURL(panel, url)
{
	var ifr = panel.childNodes[5];//lastChild;

	try
	{
		ifr.contentWindow.document.write('');
		ifr.contentWindow.document.close();
	}
	catch (e) {}

	ifr.contentWindow.location.replace(url);
}

function resizePanelElems(elem, fromIFrameLoad)
{
	var height = elem.clientHeight;
	var width = elem.clientWidth;

	// En caso de ser el primer ajuste de tamaño se ajusta la posición del cartel de espera
	if (fromIFrameLoad)
	{
		var waitMessage = elem.childNodes[4];

		waitMessage.style.top = "23px";
		waitMessage.style.left = "2px";
		waitMessage.style.height = (height - 25) + "px";
		waitMessage.style.width = (width - 4) + "px";
		
		var message = waitMessage.childNodes[0];
		
		message.style.top = ((height - 25 - 101) / 2) + "px";
		message.style.left = ((width - 4 - 288) / 2) + "px";
		
		waitMessage.style.display = "inline";
	}

	elem.childNodes[0].style.width = (width - 4) + "px"; // El borde es de 2 px de cada lado
	elem.childNodes[0].style.height = (height - 4) + "px"; // El borde es de 2 px de cada lado
	elem.childNodes[2].style.width = width + "px";
	elem.childNodes[2].style.height = (height - 23) + "px"; // La altura de la barra del título, desde donde se arrastra, es 23
	elem.lastChild.style.width = (width - 4) + "px"; // El borde es de 2 px de cada lado
	elem.lastChild.style.height = (height - 25) + "px"; // La altura de la barra del título, desde donde se arrastra, es 23, y el borde inferior es de 2
	elem.style.visibility = "visible"; // Se hace visible todo el panel
	elem.style.zIndex = currentDrag.zIndex; // Se coloca encima de los anteriores
}

function refreshPopup(elem)
{
	var form = elem.contentWindow.document.forms[0];
	
	// Se evitan 'refresh' durante la carga del panel
	if ((typeof(form) != "undefined") && (form != null))
	{
		var emptyEventNameSM = 'EHTMLTXTEMPTYEVENT';

		if (elem.contentWindow.prePost != null)
			elem.contentWindow.prePost(true);

		if (elem.contentWindow.GX_setevent != null)
			elem.contentWindow.GX_setevent(emptyEventNameSM + '.CLICK.');

		elem.contentWindow.document.forms[0].submit();
	}
}

function pUMCreatePanel(parentId, popupId, width, height, title, isPrompt)
{
	// Barra de despazamiento y bordes
	width += 21;
	
	// Barra del ti'tulo y bordes
	height += 25;

	var minPos = function(pos)
	{
		var result = 0;

		for (var i = 1; i < pos.length; i++)
			if (pos[result] > pos[i])
				result = i;
				
		return result;
	}

	var panel, pos;

	if (isPrompt)
	{
		// Si es un 'prompt' se posiciona centrado en la pantalla
		var l = (screen.availWidth - width) / 2;
		var t = (screen.availHeight - height) / 2;
		
		// Se crea el 'div' principal del panel
		panel = document.createElement("<DIV CLASS='panel' STYLE='top: " + t + "px; left: " + l + "px; width: " + width + "px; height: " + height + "px' ONFOCUS='this.hideFocus = true'>");

		// Es un 'prompt' por lo tanto se posiciona en ninguna de las 4 esquinas
		pos = -1;
	}
	else
	{
		// Si es un panel se posiciona en la esquina con menor cantidad de paneles
		pos = minPos(this.positions);

		var posStyle;

		if (pos < 2)
			posStyle = "top: 0px;";
		else
			posStyle = "top: " + (document.documentElement.clientHeight - height) + "px;";

		if ((pos == 0) || (pos == 2))
			posStyle += "left: 0px;";
		else
			posStyle += "left: " + (document.documentElement.clientWidth - width) + "px;";

		// Se crea el 'div' principal del panel
		panel = document.createElement("<DIV CLASS='panel' STYLE='" + posStyle + "width: " + width + "px; height: " + height + "px' ONFOCUS='this.hideFocus = true'>");

		// Se recuerda que hay un nuevo panel en esta posicion
		this.positions[pos]++;
	}

	// Se crea el div que tendrá el borde
	panel.appendChild(document.createElement("<DIV CLASS='panelBackground'>"));

	// Se crea el 'iframe' que quedará detrás del 'div' anterior de manera que no se vean los controle 'windowed'
	panel.appendChild(document.createElement("<IFRAME CLASS='panelBack' SCROLLING='no' FRAMEBORDER='0'>"));

	// Se crea el 'div' que oficiará de 'cover' para lograr que no se pierda el 'drag' sobre el 'iframe'
	panel.appendChild(document.createElement("<DIV CLASS='panelCover'>"));

	// Se crea la barra superior, cuando se presiona sobre ella se muestra el 'cover' que cubre el 'iframe' interno de manera que no se pierda el 'drag' al 
	// posicionar el mouse sobre dicho 'iframe'
	var topBar = document.createElement("<DIV CLASS='panelTopBar' ONMOUSEDOWN='showCover(); this.parentElement.childNodes[2].style.display = \"inline\"; beginDrag(this.parentElement, this.parentElement.childNodes[2]);' ONFOCUS='this.hideFocus = true;'>");

		// Se agrega texto del título
		var titleText = document.createElement("<A CLASS='panelTitle'>");
		titleText.innerText = title;
		topBar.appendChild(titleText);

		// Se crea el boto'n de cerrar
		// Se define "left" en lugar de utilizar "right" fijo porque e'ste a veces se calculaba mal dejando un pi'xel corrido el boto'n
		topBar.appendChild(document.createElement("<IMG STYLE='left: " + (width - 19) + "px;'  ONMOUSEDOWN='window.event.cancelBubble = true' ONCLICK='popupManager.removePopup(this.parentElement.parentElement.lastChild.parentId, this.parentElement.parentElement.lastChild.popupId);' class='panelButton' src='images/close.gif'>"));

		// Se crea el botón de vincular y desvincular del paso actual
		topBar.appendChild(document.createElement("<IMG STYLE='left: " + (width - 38) + "px;'  ONMOUSEDOWN='window.event.cancelBubble = true' ONCLICK='' class='panelButton' src='images/detach.gif'>"));

		// Se crea el botón de minimizar
		topBar.appendChild(document.createElement("<IMG STYLE='left: " + (width - 57) + "px;'  ONMOUSEDOWN='window.event.cancelBubble = true' ONCLICK='' class='panelButton' src='images/minimize.gif'>"));

		// Se crea el botón de refrescar
		topBar.appendChild(document.createElement("<IMG ONMOUSEDOWN='window.event.cancelBubble = true' ONCLICK='refreshPopup(this.parentElement.parentElement.lastChild)' class='panelRefreshButton' src='images/refresh.gif'>"));

	panel.appendChild(topBar);

	var elem;

	// Se escribe el HTML del cartel de espera que se utilizará inicialmente
	panel.appendChild(elem = document.createElement("<DIV CLASS='panelWaitMessage'>"))
	elem.innerHTML = '<DIV STYLE="background-color: #ffffff; position: absolute; height: 101px; width: 288px;"><table bgcolor="#888888" cellpadding="0" cellspacing="3"><tr><td><table bgcolor="#FFFFFF" cellSpacing="0px" cellPadding="0px">\
					<tr height="65"><td width="21"></td><td><font color="#969696" face="Verdana" size="5">Procesando...</font></td><td width="16"></td><td valign="middle"><table cellSpacing="0px" cellPadding="0px"><tr><td height="18px"></td></tr>\
					<tr valign="middle"><td><img src="images/wait.gif"></img></td></tr><tr><td height="14px"></td></tr></table></td><td width="18"></td></tr></table></td></tr></table>';
					
	// Se crea el 'iframe' dual que se utilizara' en conjunto con el inicial para evitar parpadeos entre pedidos
	var ifr = document.createElement("<IFRAME NAME='pop" + popCount++ + "' STYLE='display: none' CLASS='panelBody' FRAMEBORDER='0' ONFOCUS='this.hideFocus = true; this.parentElement.style.zIndex = ++(top.currentDrag.zIndex); this.parentElement.childNodes[2].style.zIndex = top.currentDrag.zIndex;' SCROLLING='yes'>");
	panel.appendChild(ifr);
	ifr.popupId = popupId;
	ifr.parentId = parentId;
	ifr.maxHeight = height;
	ifr.position = pos;
	ifr.isNew = false;

	// Se crea el 'iframe' que tendrá el contenido del panel, se aprovecha el evento 'onload' de este elemento 
	// para acomodar los tamaños de todos los elementos del panel
	ifr = document.createElement("<IFRAME NAME='pop" + popCount++ + "' CLASS='panelBody' ONLOAD='if (this.isNew) resizePanelElems(this.parentElement, true)' FRAMEBORDER='0' ONFOCUS='this.hideFocus = true; this.parentElement.style.zIndex = ++(top.currentDrag.zIndex); this.parentElement.childNodes[2].style.zIndex = top.currentDrag.zIndex;' SCROLLING='yes'>");
	panel.appendChild(ifr);

	// Se setean los identificadores
	ifr.popupId = popupId;
	ifr.parentId = parentId;

	// Se almacena la altura maxima permitida para no excederla
	ifr.maxHeight = height;
	
	// Se almacena la posicio'n en la que se abrio' para poder eliminarlo cuando se cierre
	ifr.position = pos;
	
	// Se marca como nuevo porque luego de recibido el primer pedido (y solo del primero) se debera' ajustar la pocisio'n
	ifr.isNew = true;

	return panel;
}

// Notifica el inicio de la carga de un panel.
function pUMLoading(popupId)
{
	if (this.list[popupId] != null)
	{
		var pop = this.list[popupId];
		var target = pop.childNodes[5];
		
		return target.name;
	}
	
	return null;
}

// Notifica la finalizacion de la carga de un panel, se redimensiona el mismo.
function pUMLoadEnd(popupId)
{
	if (this.list[popupId] != null)
	{
		var pop = this.list[popupId];
		var h;
		var target = pop.childNodes[5];
		var wind = target.contentWindow;

		target.style.display = "inline";

		if ((typeof(wind.getRealHeight) != "undefined") && (wind.getRealHeight != null))
		{
			var maxHeight = target.maxHeight;
			var currentHeight = wind.getRealHeight();

			// No se permite exceder la máxima altura definida
			if (currentHeight <= maxHeight)
				h = pop.style.height = currentHeight + 25;
			else
				h = pop.style.height = maxHeight;

			// En caso de ser la recepcio'n de la primer respuesta y de estar en pociciones 2 o 3 se reposiciona verticalmente para que quede
			// justo contra el margen inferior
			if (pop.lastChild.isNew)
			{
				pop.lastChild.isNew = false;
				if (pop.lastChild.position >= 2)
					pop.style.top = (document.documentElement.clientHeight - h) + "px";
			}
		}

		// Se corrige la visibilidad de los elementos "select", que a veces quedaban ocultos sin razo'n alguna
		var sels = target.contentWindow.document.getElementsByTagName("SELECT");
		
		for (i = 0; i < sels.length; i++)
		{
			sels[i].style.visibility = "visible";
			sels[i].style.display = "inline";
		}

		// Se hace que el 'iframe' que se esta' mostrando siempre quede u'ltimo
		target.swapNode(pop.lastChild);

		resizePanelElems(pop, false);

		// Se oculta el cartel de espera, ya que la primera vez estaría visible
		pop.childNodes[4].style.display = "none";

		// Se oculta completamente el 'iframe' dual
		pop.childNodes[5].style.visibility = "hidden";
		
		// Se setea el foco en el primer campo editable
		target.contentWindow.setFocus();
		
		target.style.visibility = "visible";
	}
}

// Define el un contendor de 'popups' de para un 'iframe' padre
function Popups()
{
	this.list = new Array();
	this.free = true;
	this.nextFreePos = 0;
	this.parent = null;
	
	// Atributos para manejar el posicionamiento de paneles, se definen 4 posiciones, una por cada esquina, y se pocisionará
	// en orden en el lugar que esté más vacío
	this.positions = new Array(0, 0, 0, 0);
}

Popups.prototype.add = pUMAdd;
Popups.prototype.remove = pUMRemove;
Popups.prototype.removeAll = pUMRemoveAll;
Popups.prototype.changeAllVisibility = pUMChangeAllVisibility;
Popups.prototype.loadEnd = pUMLoadEnd;
Popups.prototype.loading = pUMLoading;
Popups.prototype.createPanel = pUMCreatePanel;
Popups.prototype.setURL = pUMSetURL;

// CONTENEDOR DE PADRES DE CONJUNTOS DE 'POPUPS'

function pUMNotifyLoadEnd(parentId, popupId)
{
	var aux = this.list[parentId];
	
	if ((aux != null) && !aux.free)
		this.list[parentId].loadEnd(popupId);
}

// Devuelve el nombre del 'iframe' dual sobre el cual se hara' el pedido
function pUMNotifyLoading(parentId, popupId)
{
	var aux = this.list[parentId];
	
	if ((aux != null) && !aux.free)
		return this.list[parentId].loading(popupId);
	else
		return null;
}

/**
 * Registra un nuevo contenedor de paneles.
 *   'parent' -> Ventana del contenedor.
 * Resultado:
 *   Identificador del nuevo contenedor de paneles.
 */
function pUMRegister(parent)
{
	var id = this.nextFreePos;

	// Se busca la próxima posición libre para uso futuro
	for (i = id + 1; i < this.list.length; i++)
	{
		if ((this.list[i] == null) || (!this.list[i].free))
		{
			this.nextFreePos = i;
			break;
		}
	}

	if (this.list[id] == null)
		this.list[id] = new Popups();

	this.list[id].free = false;
	this.list[id].parent = parent;
	
	if (this.nextFreePos == id)
	{
		this.nextFreePos = this.list.length;
		this.list[this.nextFreePos] = new Popups();
	}

	return id;
}

/**
 * Crea un nuevo panel para el contenedor indicado.
 * Parámetros:
 *   'parentId' -> Identificador del contendor donde se creará el panel.
 *   'url'      -> Dirección base para el nuevo panel.
 * Resultado:
 *   Identificador del panel creado o -1 en caso de error.
 */
function pUMCreatePopup(parentId, url, width, height, title, isPrompt)
{
	var aux = this.list[parentId];
	
	if ((aux != null) && !aux.free)
		return aux.add(parentId, url, width, height, title, isPrompt);
		
	return -1;
}

/**
 * Cambia la visibilidad de todos los paneles de un contenedor.
 * Parámetros:
 *   'parentId' -> Identificador del contenedor.
 *   'visible'  -> true para indicar que se hagan visible, y false para indicar lo contrario.
 */
function pUMChangeVisibility(parentId, visible)
{
	var aux = this.list[parentId];
	
	if ((aux != null) && !aux.free)
		this.list[parentId].changeAllVisibility(visible);
}

/**
 * Elimina un panel de un contenedor.
 * Parámetros:
 *   'parentId' -> Identificador del contenedor de paneles del cual se removerá uno.
 *   'popupId'  -> Identificador del panel a remover.
 */
function pUMRemovePopup(parentId, popupId)
{
	var aux = this.list[parentId];

	if ((aux != null) && !aux.free)
		this.list[parentId].remove(popupId);
}

/**
 * Desregistra un contenedor de paneles liberando los recursos del mismo.
 * Parámetros:
 *   'parentId' -> Identificador del contenedor a liberar.
 */
function pUMUnregister(parentId)
{
	if (parentId != -1)
	{
		var aux = this.list[parentId];
		
		if ((aux != null) && !aux.free)
		{
			// En caso de haberse liberado una posición anterior a la próxima libre se modifica la próxmia libre
			if (this.nextFreePos > parentId)
				this.nextFreePos = parentId;
			
			this.list[parentId].removeAll();
		}
	}
}

/**
 * Devuelve la ventana asociada al contenedor indicado.
 * Parámetros:
 *   'parentId' -> Idenfiticador del contenedor cuya ventana se devolverá.
 * Resultado:
 *   Referencia el objeto 'window' del contenedor indicado, o null en caso de error.
 */
function pUMGetParent(parentId)
{
	var aux = this.list[parentId];
	
	if ((aux != null) && !aux.free)
		return this.list[parentId].parent;

	return null;
}

/**
 * Permite obtener un panel del conjunto de paneles a reutilizar.
 * Resultado:
 *   Panel a reutilizar o null en caso de no encontrar ninguno.
 */
function pUMGetPopupFromPool()
{
	return null;//this.pool.pop();
}

/**
 * Agrega un panel al conjunto de paneles a reutilizar.
 * Parámetros:
 *   'popup' -> Panel a agregar al conjunto de paneles a reutilizar.
 */
function pUMAddPopupToPool(popup)
{
//	this.pool.push(popup);
}

function PopupManager()
{
	// Lista de padres
	this.list = new Array();
	
	// Próxima posición libre
	this.nextFreePos = 0;
		
	// Conjunto de paneles a reutilizar
	this.pool = new Array();
}

PopupManager.prototype.register = pUMRegister;
PopupManager.prototype.createPopup = pUMCreatePopup;
PopupManager.prototype.notifyLoadEnd = pUMNotifyLoadEnd;
PopupManager.prototype.notifyLoading = pUMNotifyLoading;
PopupManager.prototype.changeVisibility = pUMChangeVisibility;
PopupManager.prototype.removePopup = pUMRemovePopup;
PopupManager.prototype.unregister = pUMUnregister;
PopupManager.prototype.getParent = pUMGetParent;
PopupManager.prototype.addPopupToPool = pUMAddPopupToPool;
PopupManager.prototype.getPopupFromPool = pUMGetPopupFromPool;

var popupManager = new PopupManager();
