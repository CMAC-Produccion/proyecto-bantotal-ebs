function MapInfo(stepNum, real, mark, activeElement, extraInfo, scrollTop, src)
{
	this.stepNum = stepNum;
	this.real = real;
	this.mark = mark;
	this.activeElement = activeElement;
	this.activeElementExtraInfo = extraInfo;
	this.scrollTop = scrollTop;
	this.src = src;
}

function ActiveElement(id, info)
{
    this.elementId = id;
    this.extraInfo = info;
}

bigArchiveMsgSM = "Ha ocurrido un error al subir un archivo. Probablemente el mismo sea demasiado grande.";
emptyEventSpanNameSM = 'HTMLTXTEMPTYEVENT';
emptyEventNameSM = 'EHTMLTXTEMPTYEVENT';
externalPageContainerSM = 'HFREXTERNALPAGE';
getStepSM = top.getGetStepUrl();
errorMessageMarkSM = 'E';
confirmationMessageMarkSM = 'C';
pdfCompatibilityErrorMessageSM = "Se ha detectado la utilizaci\u00F3n de Internet Explorer 6 y Acrobat Reader 7 (o menor).\n\nAlgunos reportes pueden aparecer en blanco por problemas de compatibilidad entre estos dos programas.\n\nSe recomienda instalar una versi\u00F3n m\u00E1s nueva de al menos uno de los programas para evitar el problema.";

// Retrocede al paso anterior al actual en caso de existir.
function sMBack()
{
	if (this.current >= 0)
	{
		if (this.list[this.current].contentWindow.back == null)
		{
			if (this.current > 0)
			{
				this.changePopupVisibility(this.current, false);
				this.list[this.current].style.visibility = 'hidden';
				this.list[--this.current].style.visibility = 'visible';
				this.list[this.current].contentWindow.focus();
				this.tabManager.select(this.current);
				this.changePopupVisibility(this.current, true);
			}

			// Se setea el foco en el primer campo editable
			if (this.list[this.current].contentWindow.setFocus != null)
				this.list[this.current].contentWindow.setFocus();
		}
		else
			this.list[this.current].contentWindow.back();

		// Se refresca el nuevo paso actual en caso que se necesario debido a algu'n evento 
		// a nivel del cliente
		this.clientRefreshCurrentIfNedded();
	}
}

/// Avanza al paso siguiente al actual en caso de existir.
function sMFroward()
{
	if (this.current >= 0)
	{
		if (this.list[this.current].contentWindow.forward == null)
		{
			if (this.size > this.current + 1)
			{
				this.changePopupVisibility(this.current, false);
				this.list[this.current].style.visibility = 'hidden';
				this.list[++this.current].style.visibility = 'visible';
				this.list[this.current].contentWindow.focus();
				this.tabManager.select(this.current);
				this.changePopupVisibility(this.current, true);
			}

			if ((this.list[this.current] == this.pdfFrame) && this.pdfCompatibilityProblemNotificationPending)
				this.notifyPdfCompatibilityProblem();
			
			// Se setea el foco en el primer campo editable
			if (this.list[this.current].contentWindow.setFocus != null)
				this.list[this.current].contentWindow.setFocus();
		}
		else
			this.list[this.current].contentWindow.forward();

		// Se refresca el nuevo paso actual en caso que se necesario debido a algu'n evento 
		// a nivel del cliente
		this.clientRefreshCurrentIfNedded();
	}
}

function sMBackExternal()
{
	if (this.list[this.current].contentWindow.backExternal != null)
		this.list[this.current].contentWindow.backExternal();
}

function sMForwardExternal()
{
	if (this.list[this.current].contentWindow.forwardExternal != null)
		this.list[this.current].contentWindow.forwardExternal();
}

// Devuelve un valor que indica si existe un paso siguiente al actual o no.
// Resultado:
//   true en caso de existir un paso siguiente al actual, y false en caso contrario.
function sMHasNext()
{
	return (this.size - 1 > this.current);
}

// Devuelve un valor que indica si existe un paso anterior al actual o no.
// Resultado:
//   true en caso de existir un paso anterior al actual, y false en caso contrario.
function sMHasPrev()
{
	return (this.current > 0);
}

// Agrega un nuevo paso luego del actual eliminando cualquiera que estuviese luego de e'ste.
// Para'mentros:
//   'src' -> 'url' base del paso a agregar.
function sMAddNew(src)
{
	var eraseContent;

	// Se actualiza la estructura de leng'u'etas
	this.tabManager.enqueueTab();

	// Se pasan los 'iframes' de los pasos siguientes al conjunto de disponibles 
	// y se sacan del elemento contenedor
	for (i = this.current + 1; i < this.size; i++)
	{
		this.container.removeChild(this.list[i]);
		this.pushInPool(this.list[i]);
	}

	this.size = this.current + 1;

	// Se reutiliza o contruye un nuevo paso
	if ((this.submitTarget = this.pool.pop()) != null)
	{
		this.submitTarget.style.visibility = 'hidden';
		this.submitTarget.hasFile = false;
		this.submitTarget.managed = false;
		this.submitTarget.autoRefresh = false;
		this.submitTarget.onfocus = null;
		eraseContent = true;
	}
	else
	{
		this.name = 'step' + this.idCount;
		this.submitTarget = document.createElement("<IFRAME NAME='step" + this.idCount++ + "' FRAMEBORDER='0' ONFOCUS='this.hideFocus = true;' STYLE='position: absolute; left: 0px; margin-left: 0px; visibility: hidden;' HEIGHT='100%' WIDTH='100%' SCROLLING='auto' SRC='javascript:\"\">");
		this.submitTarget.attachEvent("onreadystatechange", onreadystateHandlerSM);
		eraseContent = false;
	}

	// En caso de borrar el contenido del IFRAME se ejecuta el evento "readyState", por lo tanto se marca
	// esta bandera para evitar esa primera ejecucio'n
	this.submitTarget.notifyFlag = !eraseContent;

	this.container.appendChild(this.submitTarget);

	if (eraseContent)
	{
		// Se borra el contenido anterior
		this.submitTarget.contentWindow.document.write('');
		this.submitTarget.contentWindow.document.close();
	}

	this.submitTarget.contentWindow.location.replace(src);
}

// Devuelve el nombre de un 'iframe' para ser usado como destino de un pedido.
// Para'metros:
//   'asPeer' -> true para indicar que se quiere u'nicamente "refrescar el paso actual"; en este caso
//               cuando se reciba la respuesta simplemente se intercambiara' por el paso que en este
//               momento es el actual sin truncarse el resto de los pasos. Si el valor del para'metro
//               es false tendra' el comportamiento normal de cualquier pedido.
//   'autoRefresh' -> Indica si lo que se esta' por hacer es un refrescado automa'tico de forma de poner
//                    la marca correpondiente en el IFRAME para que se pueda detectar el caso el recibir
//                    la pa'gina luego del refrescado. El refrescado automa'tico u'nicamente se hace a
//                    partir en forma dual (asPeer = true).
//   'stepPos' -> indica el nu'mero de paso que se quiere refrescar. Tiene sentido u'nicamente en el caso
//                del refrescado autom'atico ya que el paso a refrescar no tiene por que coincidir con el actual.
function sMGetTargetName(asPeer, autoRefresh, stepPos)
{
	var iFrame, name;
	
	if (!asPeer)
	{
		// Pedido habitual
		return this.submitTarget.name;
	}
	else
	{
		if (this.current < 0)
		{
			// Si no hay paso actual no tiene sentido intentar refrescarlo
			return;
		}
		else
		{
			var peerPos = autoRefresh ? stepPos : this.current;
			if (this.peerList[peerPos] != null)
			{
				// En caso de ya existir un 'iframe' apareado con el actual se devuelve el nombre del mismo
				this.peerList[peerPos].notifyFlag = false;
				this.peerList[peerPos].hasFile = false;
				this.peerList[peerPos].managed = false;
				this.peerList[peerPos].autoRefresh = autoRefresh;
				// Se almacena el nu'mero real para que al llegar la respuesta se pueda saber concretamente de que' paso se trata
				// ya que puede haber cambiado el nu'mero de paso devuelto por el servidor
				this.peerList[peerPos].peerStepNum = stepPos;

				return this.peerList[peerPos].name;
			}
			else
			{
				// En caso de no existir un 'iframe' apareado con el actual se busca uno en el 'pool' o se
				// crea uno y se aparea con el actual
				if ((iFrame = this.pool.pop()) != null)
				{
					iFrame.style.visibility = 'hidden';
					iFrame.onfocus = null;
				}
				else
				{
					this.name = 'step' + this.idCount;
					iFrame = document.createElement("<IFRAME NAME='step" + this.idCount++ + "' FRAMEBORDER='0' ONFOCUS='this.hideFocus = true;' STYLE='position: absolute; left: 0px; margin-left: 0px; visibility: hidden;' HEIGHT='100%' WIDTH='100%' SCROLLING='auto' SRC='javascript:\"\">");
					iFrame.attachEvent("onreadystatechange", onreadystateHandlerSM);
				}

				iFrame.notifyFlag = false;
				iFrame.hasFile = false;
				iFrame.managed = false;
				iFrame.autoRefresh = autoRefresh;

				// Se almacena el nu'mero real para que al llegar la respuesta se pueda saber concretamente de que' paso se trata
				// ya que puede haber cambiado el nu'mero de paso devuelto por el servidor
				iFrame.peerStepNum = peerPos;
				
				this.container.appendChild(iFrame);

				// Se borra el contenido anterior
				iFrame.contentWindow.document.write('');
				iFrame.contentWindow.document.close();
				this.peerList[peerPos] = iFrame;

				return iFrame.name;
			}
		}
	}
}

// Notifica al manejador de pasos que se ha terminado de cargar un paso particular. Esta notificacio'n debera' ser
// invocada indefectiblmente en todo paso que se cargue.
// En caso de ser una pa'gina manejada, antes de esta notificacio'n se debe invocar 'notifyOnLoadEnd' o' 
// 'notifyExternalLoadEnd'.
function sMNotifyOnLoadEnd(elem, src, accessDenied)
{
	var title;//, position;

	if (this.reseted)
	{
		// En caso que el manejador de pasos haya sido reiniciado se ignonrara' el primer pedido
		// dado que es el paso final del proceso reiniciado
		this.resetAll(false);
	}
	else
	{	
		// Se verifica si el actual no fue actualizado au'n
		if ((this.current < 0) || (this.list[this.current].name != elem.name))
		{
			if (isReportURL(src))
			{
				if (top.hasPdfCompatibilityProblem())
					this.pdfFrame = elem;

				try
				{
					title = elem.contentWindow.document.title;
				}
				catch (e)
				{
					title = "";
				}
				
				if (title == "")
					title = "Reporte";

				if (this.size > 0)
					this.notifyLoadEnd(title, -1, null, "N", elem, -1, "", accessDenied);
				else
					this.notifyLoadEnd(title, 0, null, "N", elem, -1, "", accessDenied);
			}
			else
			{
				if (!accessDenied)
					title = elem.contentWindow.document.title;
				else
					title = null;

				if ((title == null) || (title == ""))
					title = "...";

				// Si no se puede acceder y se habi'a intentado subir un archivo quiere decir que probablemente el archivo
				// subido es demasiado grande, ya que esto provoca este tipo de error

				if ((accessDenied || (elem.contentWindow.document.body.childNodes.length == 0)) && (this.current >= 0) && this.list[this.current].hasFile)
				{
					var win = this.list[this.current].contentWindow;
					// Se reporta el error y se cancela el mostrado de la respuesta que contiene el error, habilitando el paso anterior
					if ((typeof(win.printErrorMessage) != "undefined") && (win.printErrorMessage != null))
						win.printErrorMessage(bigArchiveMsgSM, true, false, false);
					if ((typeof(win.hidePopup) != "undefined") && (win.hidePopup != null))
					{
						win.hidePopup();
						win.stopTimer();
						win.removeCover();
					}

					return;
				}

				this.notifyLoadEnd(title, -1, null, "N", elem, -1, "", accessDenied);
			}
		}
	}

	// Se pocesan los posibles eventos pendientes. Esto se hace al final de manera que
	// ya se haya actualizado la lista de pasos, ya es posible que un paso que haya provocado
	// un evento a nivel del cliente, este' suscripto al mismo y si el resultado de la operacio'n
	// fue un nuevo paso, se debe refrescar el paso original cuando se vuelva a e'l
	this.markRefreshNeededSteps();
}

// Notifica la terminacio'n de la carga del 'iframe' correspondiente al 
// nuevo paso actual.
// 'tabCaption' -> etiqueta a mostrar en la leng'u'eta correspondiente al paso.
function sMNotifyLoadEnd(tabCaption, stepNum, eventList, hasMessages, iFrame, lastStep, mark, accessDenied)
{
	// Se utiliza el gene'rico, ya que puede ser tanto para 
	// pa'ginas internas como externas
	return this.notifyAnyLoadEnd(tabCaption, stepNum, eventList, hasMessages, iFrame, lastStep, false, mark, accessDenied);
}

function SMNotifyExternalLoadEnd(tabCaption, stepNum, eventList, hasMessages, iFrame, lastStep, mark)
{
	// Se utiliza el gene'rico, ya que puede ser tanto para 
	// pa'ginas internas como externas
	this.notifyAnyLoadEnd(tabCaption, stepNum, eventList, hasMessages, iFrame, lastStep, true, mark, false);
}

function sMRemovePrevSelects(stepNum, lastStep, iFrame)
{
	var isNormal; // Indica bajo que caso se esta' ejecutando
	var removeFrom, prevPos, real, i, peerPos;
	
	real = stepNum != -1;

	if (!real)
	{
		if (this.size > 0)
			stepNum = this.mapping[this.size - 1].stepNum + 1;
		else
			stepNum = 1;
	}

	// Se distingue en que caso se encuentra
	isNormal = this.submitTarget == iFrame;

	if (!isNormal)
	{	
		// Se busca un paso con igual nu'mero que el recibido
		peerPos = iFrame.peerStepNum;
	}
	
	// Si esta' reiniciado no se hace nada ya que se ignorara' la primer respuesta
	if (isNormal)
	{
		// El anterior necesariamente es el u'ltimo ya que en cada pedido se
		// eliminan los pasos siguientes al actual
		prevPos = this.size - 1;

		if (prevPos >= 0)
		{
			removeFrom = -1;

			if (lastStep == -1)
				lastStep = stepNum;

			// Se busca la primer posicio'n con nu'mero de paso mayor o igual al dado
			for (i = 0; i < this.size; i++)
			{
				if (this.mapping[i].stepNum >= lastStep)
				{
					removeFrom = i;

					break;
				}
			}

			if (removeFrom != -1)
			{
				// Se van a remover los pasos posteriores al dado
				for (i = removeFrom; i < this.size; i++)
				{
					try
					{
						var selects = this.list[i].contentWindow.document.getElementsByTagName("SELECT");
					
						for (var k = 0; k < selects.length; k++)
						{
							selects[k].style.visibility = 'hidden';
						}
					}
					catch (e) {}
				}
			}
		}
	}
	else
	{
		try
		{
			var selects = this.list[peerPos].contentWindow.document.getElementsByTagName("SELECT");
	
			for (i = 0; i < selects.length; i++)
			{
				selects[i].style.visibility = 'hidden';
			}
		}
		catch (e) {}
	}
}

// En caso de resfrescado devuelve las posicio'n del frame refrescado
function SMNotifyAnyLoadEnd(tabCaption, stepNum, eventList, hasMessages, iFrame, lastStep, external, mark, accessDenied)
{
	// Hay 2 grandes casos posibles a nivel de este evento:
	//
	//	- "Normal"     -> Pa'gina resultado de un pedido hecho por el usuario. En este caso
	//	                  se elimina el estado "procesando" de la pa'gina que habi'a realizado el 
	//	                  pedido; luego se eliminan todas las pa'ginas con nu'mero de paso mayor o 
	//	                  igual a 'stepNum', paso de la respuesta recie'n recibida; y por u'ltimo se
	//	                  coloca el mismo como u'ltimo paso.
	//	                  
	//	- "Refrescado" -> Pa'gina resultado de refrescar un paso particular a causa de un evento
	//	                  en el cliente. Este caso simplemente se realiza un intercambio de la
	//	                  vieja versio'n del paso por la nueva recibida.

	var isNormal; // Indica bajo que caso se esta' ejecutando
	var removeFrom, prevPos, real, i, peerPos;
	var activeElement = "";
	var activeElementExtraInfo = "";
	var scrollTop = 0;
	var src = "";
	var result = null;
	
	if (!accessDenied)
	{
		src = iFrame.contentWindow.location.href;

		// Se remueven los para'metros
		i = src.indexOf('?');
		
		if (i >= 0)
			src = src.substring(i, src.length);
	}

	// En caso que la pa'gina arrivada contenga mensajes de error se cancelan los eventos generados
	// en el cliente pendientes, ya que la operacio'n que los genero' reporto' errores
	if ((hasMessages == errorMessageMarkSM) || (hasMessages == confirmationMessageMarkSM))
		this.unconfirmedClientEvents.length = 0;

	// Se detecta si el nu'mero de paso es real
	real = stepNum != -1;
	// En caso que no sea real (-1 indica el final) se coloca al final del proceso
	if (!real)
	{
		if (this.size > 0)
			stepNum = this.mapping[this.size - 1].stepNum + 1;
		else
			stepNum = 1;
	}

	// Se distingue en que caso se encuentra
	isNormal = this.submitTarget == iFrame;

	if (!isNormal)
	{	
		// Se busca un paso con igual nu'mero que el recibido
		peerPos = iFrame.peerStepNum;
	}
	
	// Si esta' reiniciado no se hace nada ya que se ignorara' la primer respuesta
	if (!this.reseted)
	{
		if (isNormal)
		{
			// Caso "Normal"
			
			// El anterior necesariamente es el u'ltimo ya que en cada pedido se
			// eliminan los pasos siguientes al actual
			prevPos = this.size - 1;

			if (prevPos >= 0)
			{
				this.list[prevPos].style.visibility = 'hidden';
				this.changePopupVisibility(prevPos, false);
				
				if (this.list[prevPos].contentWindow.hidePopup != null)
					this.list[prevPos].contentWindow.hidePopup();
				if (this.list[prevPos].contentWindow.stopTimer != null)
					this.list[prevPos].contentWindow.stopTimer();
				if (this.list[prevPos].contentWindow.removeCover != null)
					this.list[prevPos].contentWindow.removeCover();

				removeFrom = -1;

				// En caso que se haya indicado el truncado expli'cito desde algu'n paso
				// se realiza el mismo, si no (lastStep == -1), se trunca a partir
				// del paso recibido
				if (lastStep == -1)
					lastStep = stepNum;

				// Se busca la primer posicio'n con nu'mero de paso mayor o igual al dado
				for (i = 0; i < this.size; i++)
				{
					if (this.mapping[i].stepNum >= lastStep)
					{
						removeFrom = i;
						
						// Se controla que el nu'mero de paso sea el mismo y que adema's se haya mantenido en la misma pa'gina
						if ((this.mapping[i].stepNum == lastStep) && !accessDenied && (this.mapping[i].src == src))
						{
							activeElement          = this.mapping[i].activeElement;
							activeElementExtraInfo = this.mapping[i].activeElementExtraInfo;
							scrollTop              = this.mapping[i].scrollTop;
						}

						break;
					}
				}

				if (removeFrom != -1)
				{
					// Se deben remover los pasos posteriores al dado
					for (i = removeFrom; i < this.size; i++)
					{
						this.removePopups(i);
						this.pushInPool(this.list[i]);
						this.container.removeChild(this.list[i]);
					}

					this.current = removeFrom;

					// Se actualiza la estructura de leng'u'etas
					this.tabManager.truncAt(removeFrom + 1);

					// En caso de ser una pa'gina externa no se hara' nada con la etqueta ya que se
					// ocultara' la barra de leng'u'etas de pasos
					if (!external)
						this.tabManager.setCaption(this.current, tabCaption);
				}
				else
				{
					this.current = prevPos + 1;

					// Se actualiza la estructura de leng'u'etas
					this.tabManager.enqueueTab();

					// En caso de ser una pa'gina externa no se hara' nada con la etiqueta ya que se
					// ocultara' la barra de leng'u'etas de pasos
					if (!external)
						this.tabManager.setCaption(this.current, tabCaption);
				}
			}
			else
			{
				this.current = 0;

				// Se actualiza la estructura de leng'u'etas
				//AVthis.tabManager.enqueueTab();
				
				// En caso de ser una pa'gina externa no se hara' nada con la etqueta ya que se
				// ocultara' la barra de leng'u'etas de pasos
				if (!external)
					this.tabManager.setCaption(this.current, tabCaption);
			}

			// Se oculta nuevamente para evitar que quede el a'rea de paginado de las grid visibles
			if ((prevPos < this.current) && (prevPos >= 0))
			{
				this.changePopupVisibility(prevPos, false);
				this.list[prevPos].style.visibility = 'hidden';
			}

			this.list[this.current] = this.submitTarget;

			// Se contruye otro 'iframe' que servira' como destino de los pedidos del cliente
			if ((this.submitTarget = this.pool.pop()) == null)
			{
				this.name = 'step' + this.idCount;
				this.submitTarget = document.createElement("<IFRAME FRAMEBORDER='0' NAME='step" + this.idCount++ + "' ONFOCUS='this.hideFocus = true;' STYLE='position: absolute; left: 0px; margin-left: 0px; visibility: hidden;' HEIGHT='100%' WIDTH='100%' SCROLLING='auto' SRC='javascript:\"\">");
				this.submitTarget.attachEvent("onreadystatechange", onreadystateHandlerSM);
			}

			this.submitTarget.notifyFlag = false;
			this.submitTarget.hasFile = false;
			this.submitTarget.managed = false;
			this.submitTarget.autoRefresh = false;
			this.submitTarget.onfocus = null;
			this.submitTarget.style.visibility = 'hidden';
			
			this.container.appendChild(this.submitTarget);

			this.submitTarget.contentWindow.document.write('');
			this.submitTarget.contentWindow.document.close();

			this.size = this.current + 1;

			this.mapping[this.current] = new MapInfo(stepNum, real, mark, activeElement, activeElementExtraInfo, scrollTop, src);

			// Se recuerda la suscripcio'n del paso a los eventos indicados
			this.clientEventSubscription[this.current] = eventList;

			if (this.callBack(true))
			{
				this.list[this.current].style.visibility = 'visible';
				//alert("Before focus");
					this.list[this.current].focus();
				//alert("After focus");
			}

			// Se selecciona la etiqueta actual
			this.tabManager.select(this.current);
		}
		else
		{
			// Caso "Refrescado"

			// Se comprueba si no cambio' el nu'mero de paso en el servidor
			if (stepNum != this.mapping[peerPos].stepNum)
			{
				// En caso que en el servidor se haya efectivamente se haya cambiado de paso en el refrescado
				// se coloca el IFRAME par como objetivo de nuevos pasos y se simula un pedido normal
				this.pushInPool(this.submitTarget);
				this.submitTarget = this.peerList[peerPos];
				this.peerList[peerPos] = null;
				this.notifyAnyLoadEnd(tabCaption, stepNum, eventList, hasMessages, iFrame, lastStep, external, mark, accessDenied);
			}
			else
			{
				result = peerPos;

				// Se realiza el intercambio entre el apareado y el normal
				this.list[peerPos].style.visibility = 'hidden';
				this.pushInPool(this.list[peerPos]);
				this.container.removeChild(this.list[peerPos]);
				this.list[peerPos] = this.peerList[peerPos];
				this.peerList[peerPos] = null;

				// Se recuerda la suscripcio'n del paso a los eventos indicados
				this.clientEventSubscription[peerPos] = eventList;

				// Se actualiza el texto de la leng'u'eta asociada
				this.tabManager.setCaption(peerPos, tabCaption);

				// Esta variable indica si se debe setear el foco o al aviso intermitente ya que eso no se hara' en caso de ser un refrescado
				// automa'tico a menos que sea el u'ltimo
				var iFrame = this.list[peerPos];
				
				// Se recuerda si este paso petenece al espacio de trabajo actual o no, esto hara' que se realice un resaltado intermitente
				// en caso de que sea el u'ltimo refrescado automa'tico o que sea un refrescado por evento de cliente
				// Se tienen 2 tipos de refrescado:
				//    1 - refrescado autom'atico [iFrame.autoRefresh = true]
				//    2 - refrescado por un evento de cliente [iFrame.autoRefresh = false]
				// En el caso 1 se indicara' al manejador padre que avise mediante un resaltado intermitente solamente si no hay ma's refrescados
				// automa'ticos [iFrame.contentWindow.adviceGU]
				// En el caso 2 nunca se indicara' al manejador padre que haga eso.
				var isCurrentWorkSpace = this.callBack(iFrame.contentWindow.adviceGU);

				// En caso que se este' en un caso 2 se controla que el paso actual sea el mismo en caso de tener que hacerlo visible
				if (this.current != peerPos)
				{
					// Los eventos de cliente nunca provocan un resaltado intermitente
					if (iFrame.contentWindow.adviceGU)
						this.tabManager.adviceAt(peerPos);
				}
				else
				{
					// Posicio'n actual del espacio de trabajo...
					if (isCurrentWorkSpace)
					{
						// ... y mismo espacio de trabajo, se hace visible
						this.list[peerPos].style.visibility = 'visible';
						this.changePopupVisibility(peerPos, true);
	
						// So'lo se setea el foco si antes se evaluo' que era necesario, ya que por ma's que sea el paso actualmente visible
						// resulta molesto que si se esta' en un refrescado atuoma'tico se vuelva el foco al navegador cada vez que se recibe algo
						if (iFrame.contentWindow.setFocusGU)
						{
							this.list[peerPos].focus();
						}
					}
				}
			}
		}
	}

	// Se pocesan los posibles eventos pendientes. Esto se hace al final de manera que
	// ya se haya actualizado la lista de pasos, ya que es posible que un paso que haya provocado
	// un evento a nivel del cliente, este' suscripto al mismo y si el resultado de la operacio'n
	// fue un nuevo paso, se debe refrescar el paso original cuando se vuelva a e'l
	this.markRefreshNeededSteps();

	return result;
}

// Cambia el paso actual, acorde al i'ndice dado.
// 'index' -> i'ndice del nuevo paso actual.
function sMGoTo(index)
{
	if ((index >= 0) && (index < this.size) && (index != this.current))
	{
		this.list[this.current].style.visibility = 'hidden';
		this.changePopupVisibility(this.current, false);
		this.current = index;
		
		if (this.callBack(true))
		{
			this.list[index].style.visibility = 'visible';
			this.list[index].focus();
			this.changePopupVisibility(index, true);

			if ((this.list[this.current] == this.pdfFrame) && this.pdfCompatibilityProblemNotificationPending)
				this.notifyPdfCompatibilityProblem();

			// Se setea el foco en el primer campo editable
			if (this.list[this.current].contentWindow.setFocusTime1 != null)
				this.list[this.current].contentWindow.setFocusTime1();
			
			this.tabManager.select(this.current);
		}
		
		// Se refresca el nuevo paso actual en caso que se necesario debido a algu'n evento 
		// a nivel del cliente
		this.clientRefreshCurrentIfNedded();
	}
}

function sMGoToAndRefresh(procId, stepNum, refresh, lastStep)
{
	var index;
	
	// En caso que no se haya indicado un truncado especi'fico a partir de un paso dado
	// se realiza el mismo
	if (lastStep != -1)
	{
		index = -1;
		
		// Se busca la primer posicio'n con nu'mero de paso mayor o igual al dado
		for (i = 0; i < this.size; i++)
		{
			if (this.mapping[i].stepNum >= lastStep)
			{
				index = i;
				break;
			}
		}
	
		if (index != -1)
		{	
			// Se deben remover los pasos posteriores al dado
			for (i = index; i < this.size; i++)
			{
				this.pushInPool(this.list[i]);
				this.container.removeChild(this.list[i]);
			}
	
			this.current = index - 1;
			this.size = index;
	
			// Se actualiza la estructura de leng'u'etas
			this.tabManager.truncAt(index);
		}
	}

	index = -1;

	for (i = 0; i < this.size; i++)
	{
		if (this.mapping[i].stepNum == stepNum)
		{
			index = i;
			break;
		}
	}

	if (index != -1)
	{
		// El paso se encuentra en el cliente
		if (refresh)
		{
			// Se refresca
			if (this.mapping[index].real)
			{
				var check = true;
				
				if (this.list[index].contentWindow.prePost != null)
				{
					// Se evita que se refresque la pa'gina el ser seleccionada por un evento de cliente porque se va a refrescar
					// directamente aqui'
					this.refreshNeeded[index] = false;

					this.selectStep(index);

					// Se fuerza que se refresque aunque se haya presionado una opercio'n previamente
					// porque se puede dar el caso que se partio' de el paso a refrescar mediante una operacio'n
					// y luego de una cadena de llamadas en el servidor se vuelve al paso original con refrescado
					check = this.list[index].contentWindow.prePost(true, true);
				}

				if (check)
				{
					this.list[index].contentWindow.document.forms[0].target = this.submitTarget.name;

					if (this.list[index].contentWindow.GX_setevent != null)
						this.list[index].contentWindow.GX_setevent(emptyEventNameSM + '.CLICK.');

					this.list[index].contentWindow.document.forms[0].submit();
				}
			}
			else
			{
				this.current = index;
				this.removeFromCurrent();
				
				this.tabManager.enqueueTab();
				this.submitTarget.notifyFlag = false;
				this.submitTarget.hasFile = false;
				this.submitTarget.managed = false;
				this.submitTarget.autoRefresh = false;
				this.tabManager.select(index);
				
				this.list[index].contentWindow.location.replace(this.list[index].contentWindow.location.href);
	
				this.list[this.current].style.visibility = 'hidden';
				this.removePopups(this.current);
				if (this.callBack(true))
				{
					this.list[index].style.visibility = 'visible';
					this.list[index].focus();

					if ((this.list[this.current] == this.pdfFrame) && this.pdfCompatibilityProblemNotificationPending)
						this.notifyPdfCompatibilityProblem();

					this.tabManager.select(index);

					// Se setea el foco en el primer campo editable
					if (this.list[index].contentWindow.setFocus != null)
						this.list[index].contentWindow.setFocus();
						
					try
					{
						if (this.list[index].contentWindow.hidePopup != null)
							this.list[index].contentWindow.hidePopup();
						if (this.list[index].contentWindow.stopTimer != null)
							this.list[index].contentWindow.stopTimer();
						if (this.list[index].contentWindow.removeCover != null)
							this.list[index].contentWindow.removeCover();
					}
					catch (e) {}
				}                  
			}
		}
		else
		{
			// Se actualiza la estructura de leng'u'etas
			this.tabManager.truncAt(index + 1);
			this.tabManager.enqueueTab();
			this.tabManager.select(index);

			this.submitTarget.notifyFlag = false;
			this.submitTarget.hasFile = false;
			this.submitTarget.managed = false;
			this.submitTarget.autoRefresh = false;
			this.list[this.current].style.visibility = 'hidden';
			this.current = index;
			
			if (this.callBack(true))
			{
				this.list[index].style.visibility = 'visible';
				this.list[index].focus();

				// Se setea el foco en el primer campo editable
				if (this.list[index].contentWindow.setFocus != null)
					this.list[index].contentWindow.setFocus();

				this.tabManager.select(index);

				if ((this.list[this.current] == this.pdfFrame) && this.pdfCompatibilityProblemNotificationPending)
					this.notifyPdfCompatibilityProblem();

				try
				{
					if (this.list[index].contentWindow.hidePopup != null)
						this.list[index].contentWindow.hidePopup();
					if (this.list[index].contentWindow.stopTimer != null)
						this.list[index].contentWindow.stopTimer();
					if (this.list[index].contentWindow.removeCover != null)
						this.list[index].contentWindow.removeCover();
				}
				catch (e)
				{
				}					
			}
			
			// Se refresca el nuevo paso actual en caso que se necesario debido a algu'n evento 
			// a nivel del cliente
			this.clientRefreshCurrentIfNedded();
		}
	}
	else
	{
		// El paso no se encuentra en el cliente, por lo tanto se solicita al servidor
		if (procId == null)
			src = getStepSM + "?" + this.list[this.current].contentWindow.document.forms[0]._ZG1_PROCID.value + "," + stepNum;
		else
			src = getStepSM + "?" + procId + "," + stepNum;

		this.submitTarget.contentWindow.location.replace(src);
	}
}

// Ajusta el taman~o del 'iframe' correspondiente al paso actual, en caso de existir.
// 'newHeight' -> nueva altura del 'iframe' correspondiente al paso actual.
// 'newTop' -> nuevo distancia del 'iframe' correspondiente al paso hacia el el borde superior de 
//             la pantalla.
function sMResizeCurrent(newHeight, newTop)
{
	if (this.current > -1)
	{
		this.list[this.current].height = newHeight;
		this.list[this.current].style.top = newTop;
	}
}

// Elimina todos los pasos.
function sMResetAll(skipFst)
{
	for (i = 0; i < this.size; i++)
	{
		this.pushInPool(this.list[i]);
		this.removePopups(i);
		this.container.removeChild(this.list[i]);
	}

	if (!skipFst)
	{
		if (this.submitTarget != null)
		{
			this.pushInPool(this.submitTarget);
			this.container.removeChild(this.submitTarget);
			this.submitTarget = null;
		}
		this.reseted = false;
	}
	else
		this.reseted = true;
	
	this.tabManager.reset();

	this.size = 0;
	this.current = -1;
}

// Setea el estado de visibilidad del 'iframe' correspondiente al paso actual.
// 'visible' -> true para indicar que se haga visible, y false en caso contrario.
function sMSetCurrentVisibility(visible)
{
	if (this.current > -1)
	{
		if (!visible)
		{
			this.list[this.current].style.visibility = 'hidden';
			// Se mando' ocultar el espacio de trabajo
			if (this.pdfFrame != null)
				this.pdfCompatibilityProblemNotificationPending = true;
		}
		else
		{
			this.list[this.current].style.visibility = 'visible';

			if (typeof(this.list[this.current].contentWindow.document) != "unknown")
			{
				this.list[this.current].contentWindow.document.body.focus();
			
				// Se setea el foco en el primer campo
				if (this.list[this.current].contentWindow.setFocusTime1 != null)
					this.list[this.current].contentWindow.setFocusTime1();
			}
			else
			{
				// Caso de PDF's
				this.list[this.current].contentWindow.focus();
				if (this.pdfCompatibilityProblemNotificationPending)
					this.notifyPdfCompatibilityProblem();
			}
		}

		this.changePopupVisibility(this.current, visible);
		
		this.tabManager._container.style.visibility = visible ? 'visible' : 'hidden';
	}
}

function sMRefreshCurrent()
{
	var currentIFWin;

	if (this.current >= 0)
	{
		currentIFWin = this.list[this.current].contentWindow;

		// El paso se encuentra en el cliente, se refresca si no se esta' cargando
		if (currentIFWin.operationClicked != null)
		{
			// Si se esta' procesando una operacio'n no se hace nada
			if (!currentIFWin.operationClicked())
			{
				if (currentIFWin.document.forms[0] != null)
				{
					// En caso de no estar definido el 'span' para realizar el refrescado no se hace nada
					if (currentIFWin.document.getElementById(emptyEventSpanNameSM) != null)
					{
						var check = true;

						if (currentIFWin.prePost != null)
							check = currentIFWin.prePost(true, false);
	
						if (check)
						{
							currentIFWin.document.forms[0].target = this.submitTarget.name;

							if (currentIFWin.GX_setevent != null)
								currentIFWin.GX_setevent(emptyEventNameSM + '.CLICK.');

							this.removePopups(this.current);

							currentIFWin.document.forms[0].submit();
						}
					}
				}
				else
				{
					this.removePopups(this.current);
				
					// En caso que no haya formulario
					currentIFWin.location.reload(true);
				}
			}
		}
		else
		{
			this.removePopups(this.current);
			currentIFWin.location.replace(this.list[this.current].contentWindow.location.href);
		}
	}
}

function sMFocusOnCurrent()
{
	if (this.current >= 0)
	{
		if (typeof(this.list[this.current].contentWindow.document) != "unknown")
			this.list[this.current].contentWindow.focus();
		else
		{
			// PDF's (se define asi' para poder seguir capturando los eventos del teclado)
			self.focus();

			// En caso que el PDF quede en blanco (ver problema con IE6 y Acro7), se define esto
			// de forma de poder seguir capturando el teclado
			this.list[this.current].onfocus = function(){top.focus();};
		}
	}
	else
		self.focus();
}

function sMPrintCurrent()
{
	if (this.current >= 0)
	{
		try
		{
			var w = this.list[this.current].contentWindow;
			// Se intenta acceder al "document" de forma que si el contenido no es un HTML (en particular para los pdf's)
			// se bloquee el pedido de impresio'n
			var d = w.document;

			// Adema's se revisa si existe el metatag "Descartes_BlockPrintButton" con valor "1" lo cual quiere decir que la pantalla no debe imprimirse
			var metas = d.getElementsByTagName("META");
			if (metas != null)
			{
				for (var i = 0; i < metas.length; i++)
				{
					if ((metas[i].name == "Descartes_PrintButton") && (metas[i].content == "Block"))
					{
						alert("La funcionalidad 'Imprimir' est\u00E1 bloqueada para esta pantalla.");
						return;
					}
				}
			}

			w.focus();
			w.print();
		}
		catch (e)
		{
			alert("No se puede imprimir contenido externo con este bot\u00F3n.\nIntente imprimirlo desde la propia aplicaci\u00F3n donde se muestra el documento.");
		}
	}
}

function sMRemoveFromCurrent()
{
	// Se pasan los 'iframes' de los pasos siguientes al conjunto de disponibles 
	// y se sacan del elemento contenedor
	for (i = this.current + 1; i < this.size; i++)
	{
		this.removePopups(i);
		this.container.removeChild(this.list[i]);
		this.pushInPool(this.list[i]);
	}

	this.size = this.current + 1;
	
	this.tabManager.truncAt(this.current + 1);
}

// Retorna el nombre del programa actual
function sMGetCurrentPgm()
{
	var i, length, url;
	if (this.current != -1)
	{
		url = this.list[this.current].contentWindow.location.href;
		
		// Se eliminan los para'metros en caso de haberlos
		i = url.lastIndexOf("/");
		i++;

		if ((i < url.length) && (i > 0))
			url = url.substring(i);

		i = url.indexOf("?");

		if (i > 0)
			url = url.substring(0, i);

		length = url.length;

		if ((length > 5) && (url.substring(length - 5).toUpperCase() == ".ASPX"))
		{
			// .NET

			// Es un programa interno, se devuelve el nombre
			url = url.substring(0, length - 5);

			if (url.toUpperCase() == externalPageContainerSM)
			{
				// No es un programa interno, se pide la url inicial al contenedor de sitios externos
				if (this.list[this.current].contentWindow.getInitialURL != null)
					return this.list[this.current].contentWindow.getInitialURL();
			}
		}
		else
		{
			// JAVA

			i = url.lastIndexOf(".");
			i++;
		
			if ((i < url.length) && (i > 0))
				url = url.substring(i);
		
			if (url.toUpperCase() == externalPageContainerSM)
			{
				// No es un programa interno, se pide la url inicial al contenedor de sitios externos
				if (this.list[this.current].contentWindow.getInitialURL != null)
					return this.list[this.current].contentWindow.getInitialURL();
			}
		}
		
		return url;	
	}

	return "";
}

// Notifica la generacio'n de eventos a nivel del cliente.
// 'eventList' -> vector con los nombres de los eventos en cuestio'n
function sMNotifyClientEvents(eventList)
{
	// Se agregan los nuevos eventos a la lista
	if (eventList != null)
		this.unconfirmedClientEvents = this.unconfirmedClientEvents.concat(eventList);	
}

// Devuelve el nu'mero de paso con la marca indicada y -1 en caso de no contar con ningu'n paso con dicha marca.
function sMHasMarkedStep(mark)
{
	for (var i = 0; i < this.size; i++)
		if (this.mapping[i].mark == mark)
			return i;
			
	return -1;
}

function sMSelectStep(pos)
{
	this.goTo(pos);
	this.tabManager.select(pos);
}

// Se marcan los pasos que este'n suscriptos a algu'n evento que se haya generado
function sMMarkRefreshNeededSteps()
{
	var i, j, k, stop1, stop2, auxSEvents;
	
	stop1 = this.unconfirmedClientEvents.length;

	// Para cada evento a procesar
	for (i = 0; i < stop1; i++)
	{
		// Por cada paso, sin ser el u'ltimo, ya que, o bien es el que provoco' la confirmacio'n de 
		// los eventos pendientes, o bien es el paso siguiente. Es posible que el resultado de la llamada
		// haya sido un 'back', en este caso funcionara' correctamente tambie'n
		for (j = 0; j < this.size - 1; j++)
		{
			auxSEvents = this.clientEventSubscription[j];
			if ((auxSEvents != null) && ((this.refreshNeeded[j] == null) || !this.refreshNeeded[j]))
			{
				stop2 = auxSEvents.length;

				// Para cada evento al que el paso esta' suscripto
				for (k = 0; k < stop2; k++)
				{
					if (this.unconfirmedClientEvents[i] == auxSEvents[k])
					{
						// Se debe refrescar el paso 'j' ya que se genero' algu'n evento
						// al que e'ste estaba suscripto
						this.refreshNeeded[j] = true;
						break;
					}	
				}
			}
		}
	}
	
	// Se elimina la lista de eventos por confirmar, ya que acaban de ser confimados
	this.unconfirmedClientEvents.length = 0;
}

// Refresca el paso actual en caso que sea necesario debido a la ocurrencia de algu'n evento
// a nivel del cliente.
function sMClientRefreshCurrentIfNedded()
{
	if (this.current >= 0)
	{
		if ((this.refreshNeeded[this.current] != null) && this.refreshNeeded[this.current])
		{
			var check = true;

			this.refreshNeeded[this.current] = false;
			this.list[this.current].contentWindow.document.forms[0].target = this.getTargetName(true, false, null);
			
			if (this.list[this.current].contentWindow.prePost != null)
				check = this.list[this.current].contentWindow.prePost(false, true);

			if (check)
			{
				if (this.list[this.current].contentWindow.GX_setevent != null)
					this.list[this.current].contentWindow.GX_setevent(emptyEventNameSM + '.CLICK.');
				
				this.removePopups(this.current);
				this.list[this.current].contentWindow.document.forms[0].submit();
			}
		}
	}
}

// Fuerza el refrescado del paso indicado, se eliminan los eventos pendientes desde el cliente.
function sMClientRefreshIndicatedStep(stepNum)
{
	var pos, i;

	pos = -1;

	// Se busca la posicio'n del paso indicado
	for (i = 0; i < this.size; i++)
		if (this.mapping[i].stepNum == stepNum)
			pos = i;
	
	if (pos >= 0)
	{
		var check = true;
		
		// Se elminan los eventos pendientes del cliente
		if (this.refreshNeeded[pos] != null)
			this.refreshNeeded[pos] = false;

		this.list[pos].contentWindow.document.forms[0].target = this.getTargetName(true, true, pos);
		
		if (this.list[pos].contentWindow.prePost != null)
			check = this.list[pos].contentWindow.prePost(false, false);

		if (check)
		{
			if (this.list[pos].contentWindow.GX_setevent != null)
				this.list[pos].contentWindow.GX_setevent(emptyEventNameSM + '.CLICK.');
		
			this.removePopups(pos);
			this.list[pos].contentWindow.document.forms[0].submit();
		}
	}
}

function sMChangePopupVisibility(pos, visible)
{
	top.popupManager.changeVisibility(this.list[pos].contentWindow.panelRegIdGU, visible);
}

function sMRemovePopups(pos)
{
	top.popupManager.unregister(this.list[pos].contentWindow.panelRegIdGU);
}

function sMRemoveAllPopups()
{
	for (var i = 0; i < this.size; i++)
		this.removePopups(i);
}

function sMIsCurrentMark(mark)
{
	if (this.current >= 0)
		return this.mapping[this.current].mark == mark;

	return false;
}

// Devuelve false en caso de no poder acceder al "document", esto se da con el Acrobat.
function sMGetElements(tagName)
{
	if (this.current >= 0)
	{
		if (typeof(this.list[this.current].contentWindow.document) == "unknown")
			return false;
		else
			return this.list[this.current].contentWindow.document.getElementsByTagName(tagName);
	}
	else
		return null;
}

function sMGetScrollTop()
{
	try
	{
		// Cuando se trata de un pdf no se puede acceder
		if (this.current >= 0)
			return this.list[this.current].contentWindow.document.body.scrollTop;
	}
	catch (e) {}

	return 0;
}

function sMGetScrollLeft()
{
	try
	{
		// Cuando se trata de un pdf no se puede acceder
		if (this.current >= 0)
			return this.list[this.current].contentWindow.document.body.scrollLeft;
	}
	catch (e) {}

	return 0;
}

function sMIsExternal()
{
	var w = this.list[this.current].contentWindow;
	
	if ((typeof(w.isExternalPage) != "undefined") && (w.isExternalPage != null))
		return this.list[this.current].contentWindow.isExternalPage();
	else
		// En el caso que no este' definida la funcio'n se asumira' pa'gina externa
		return true;
}

function sMPushInPool(iframe)
{
	try
	{
		// En caso de que fuera el reporte que habi'a se indica que ya no hay ninguno
		if (this.pdfFrame == iframe)
		{
			this.pdfFrame = null;
			this.pdfCompatibilityProblemNotificationPending = false;
		}

		// Solo se agrega si el contenido esta' en el mismo dominio que el resto de la aplicacio'n para evitar errores a la hora de re-inicializar
		// el paso cuando se vaya a reutilizar, en particular no puedo hacer por ejemplo "iframe.contentWindow.document.?"
		var aux = iframe.contentWindow.location.href;
		this.pool.push(iframe);
	}
	catch (e) {}
}

function sMSetActiveElement(stepNum, element, extraInfo)
{
	for (var i = 0; i < this.size; i++)
	{
		if (this.mapping[i].stepNum == stepNum)
		{
			this.mapping[i].activeElement = element;
			this.mapping[i].activeElementExtraInfo = extraInfo;
			break;
		}
	}
}

function sMGetActiveElement(stepNum)
{
	for (var i = 0; i < this.size; i++)
	{
		if (this.mapping[i].stepNum == stepNum)
			return new ActiveElement(this.mapping[i].activeElement, this.mapping[i].activeElementExtraInfo);
	}
}

function sMSetScrollTop(stepNum, scrollTop)
{
	for (var i = 0; i < this.size; i++)
	{
		if (this.mapping[i].stepNum == stepNum)
		{
			this.mapping[i].scrollTop = scrollTop;
			break;
		}
	}
}

function sMGetConcreteScrollTop(stepNum)
{
	for (var i = 0; i < this.size; i++)
		if (this.mapping[i].stepNum == stepNum)
			return this.mapping[i].scrollTop;

	return 0;
}

function sMGetNumberOfSteps()
{
	return this.size;
}

function sMSetUnmamagedTarget()
{
	if (this.submitTarget != null)
		this.submitTarget.managed = false;
}

function sMNotifyPdfCompatibilityProblem()
{
	// Se notifica una u'nica vez
	if (!top.compatibilityProblemAlreadyNotified)
		alert(pdfCompatibilityErrorMessageSM);

	this.pdfFrame = null;
	this.pdfCompatibilityProblemNotificationPending = false;
	top.compatibilityProblemAlreadyNotified = true;
}

// Inicializa una nueva instancia de tipo 'StepManager'.
// 'container' -> es el elemento que contendra' los 'iframes'.
// 'tabContainer -> es el elemento que conendra' los leng'u'etas.
// 'changeCallBack' -> co'digo a ejecutar cuando se cambie el paso actual ya sea por 
//                     una accio'n interna, o por una notificacio'n de carga terminada.
function StepManager(container, tabContainer, changeCallBack, TabManager)
{
	// Lista de 'iframes' que contienen y representan los pasos actualmente visibles
	this.list = new Array();
	
	// Por cada paso de la lista de pasos visibles, se tiene registro del conjunto de eventos
	// a los que cada paso esta' suscripto
	this.clientEventSubscription = new Array();

	// Vector de eventos por confirmar
	this.unconfirmedClientEvents = new Array();

	// Marca los pasos que deben ser refrescados
	this.refreshNeeded = new Array();

	// Lista de 'iframes' pares a los visibles; a e'stos se redirigira'n los refrescados
	// que solo afecten a un paso en particular, es decir que cuando se reciba la respuesta
	// solamente se actualizara' ese paso y no se truncara' de ahi' hacia adelante
	this.peerList = new Array();
	
	// Mapeo de nu'mero de paso a posicio'n del 'iframe' en la lista de pasos visibles
	this.mapping = new Array();
	
	// Conjunto de 'iframes' que no esta'n siendo utilizados en este momento y esta'n
	// disponibles para ser utilizados
	this.pool = new Array();
	
	// Cantidad de pasos visibles, es decir, tope de los arreglos 'list', 'clientEventSubscription',
	// 'peerList' y 'mapping'
	this.size = 0;
	
	// Nu'mero de paso actual, es decir el paso que el usuario esta' viendo
	this.current = -1;
	
	this.callBack = changeCallBack;
	this.container = container;
	this.idCount = 0;
	this.tabManager = TabManager;
	
	this.submitTarget = null;
	this.reseted = false;

	// Se detecto' un problema de compatibilidad entre el IE 6 y el Reader 7, si se tiene un PDF abierto en un espacio de trabajo,
	// se cambia de espacio de trabajo y se realiza algu'n pedido al servidor, al volver al espacio de trabajo original, y al paso
	// donde estaba el PDF se encuentre el mismo totalmente en blanco. Cuando se deteca este caso se notifica la primera vez que
	// ocurre ("top.compatibilityProblemAlreadyNotified") al usuario.
	this.pdfFrame = null;
	this.pdfCompatibilityProblemNotificationPending = false;
}

// Popiedades comunes a todos los objetos de tipo 'StepManager'
StepManager.prototype.back = sMBack;
StepManager.prototype.forward = sMFroward;
StepManager.prototype.hasNext = sMHasNext;
StepManager.prototype.hasPrev = sMHasPrev;
StepManager.prototype.addNew = sMAddNew;
StepManager.prototype.resetAll = sMResetAll;
StepManager.prototype.notifyLoadEnd = sMNotifyLoadEnd;
StepManager.prototype.notifyExternalLoadEnd = SMNotifyExternalLoadEnd;
StepManager.prototype.notifyAnyLoadEnd = SMNotifyAnyLoadEnd;
StepManager.prototype.resizeCurrent = sMResizeCurrent;
StepManager.prototype.refreshCurrent = sMRefreshCurrent;
StepManager.prototype.focusOnCurrent = sMFocusOnCurrent;
StepManager.prototype.printCurrent = sMPrintCurrent;
StepManager.prototype.setCurrentVisibility = sMSetCurrentVisibility;
StepManager.prototype.goToAndRefresh = sMGoToAndRefresh;
StepManager.prototype.getTargetName = sMGetTargetName;
StepManager.prototype.notifyOnLoadEnd = sMNotifyOnLoadEnd;
StepManager.prototype.goTo = sMGoTo;
StepManager.prototype.removeFromCurrent = sMRemoveFromCurrent;
StepManager.prototype.getCurrentPgm = sMGetCurrentPgm;
StepManager.prototype.backExternal = sMBackExternal;
StepManager.prototype.forwardExternal = sMForwardExternal;
StepManager.prototype.isExternal = sMIsExternal;
StepManager.prototype.notifyClientEvents = sMNotifyClientEvents;
StepManager.prototype.getScrollTop = sMGetScrollTop;
StepManager.prototype.getScrollLeft = sMGetScrollLeft;
StepManager.prototype.getNumberOfSteps = sMGetNumberOfSteps;
StepManager.prototype.markRefreshNeededSteps = sMMarkRefreshNeededSteps;
StepManager.prototype.clientRefreshCurrentIfNedded = sMClientRefreshCurrentIfNedded;
StepManager.prototype.clientRefreshIndicatedStep = sMClientRefreshIndicatedStep;
StepManager.prototype.changePopupVisibility = sMChangePopupVisibility;
StepManager.prototype.removePopups = sMRemovePopups;
StepManager.prototype.removeAllPopups = sMRemoveAllPopups;
StepManager.prototype.getElements = sMGetElements;
StepManager.prototype.pushInPool = sMPushInPool;
StepManager.prototype.hasMarkedStep = sMHasMarkedStep;
StepManager.prototype.selectStep = sMSelectStep;
StepManager.prototype.isCurrentMark = sMIsCurrentMark;
StepManager.prototype.setActiveElement = sMSetActiveElement;
StepManager.prototype.getActiveElement = sMGetActiveElement;
StepManager.prototype.setScrollTop = sMSetScrollTop;
StepManager.prototype.getConcreteScrollTop = sMGetConcreteScrollTop;
StepManager.prototype.removePrevSelects = sMRemovePrevSelects;
StepManager.prototype.setUnmamagedTarget = sMSetUnmamagedTarget;
StepManager.prototype.notifyPdfCompatibilityProblem = sMNotifyPdfCompatibilityProblem;

function isReportURL(url)
{
	var length, i, c;

	length = url.length;

	if (length > 0)
	{
		// Se chequea si se trata de un pdf
		if (length > 4)
			if (url.substring(length - 4).toUpperCase() == ".PDF")
				return true;

		if ((length > 5) && (url.substring(length - 5).toUpperCase() == ".ASPX"))
		{
			// .NET
	

			// Se chequea si se trata de un procedimiento o reporte
			i = url.lastIndexOf("/");
			i++;
		}
		else
		{
			// JAVA
	
			i = url.lastIndexOf(".");
			i++;
		}

		if ((i < length) && (i != 0))
		{
			c = url.charAt(i);
			if ((c == 'o') || (c == 'O') || (c == 'a') || (c == 'A'))
				return true;
		}
	}

	return false;
}

// Se define este evento porque el ONLOAD no se ejecuta con elgunas versiones del "Actobat".
function onreadystateHandlerSM()
{
	var elem = window.event.srcElement;
	
	if ((elem != null) && (elem.readyState == "complete"))
	{
		// Solamente los pasos no manejados deben entrar ya que los manejados se encargan de notificar por si mismos de su carga
		if ((typeof(elem.managed) == "undefined") || !elem.managed)
		{
			if ((typeof(elem.notifyFlag) == "undefined") || (elem.notifyFlag == null) || (!elem.notifyFlag))
				elem.notifyFlag = true;
			else
			{
				try
				{
					notifyOnLoadEnd(elem, elem.contentWindow.location.pathname, false);
				}
				catch (e)
				{
					notifyOnLoadEnd(elem, "", true);
				}
			}
		}
	}
}
