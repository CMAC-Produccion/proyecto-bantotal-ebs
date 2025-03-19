var opClickedGU = false;
var hasMessagesGU = 'N';
var reqIdGU = null;
var externalGU = false;
var messageAreaGU  = 'TXTMESSAGES';
var messageAreaSepGU = 'MESSAGESSEPARATOR';
var confAreaNameGU = 'HTMLTBLCONFIRMATIONAREA';
var operationsDivNameGU = 'operationsDiv';
var gridDivNameGU = 'gridDiv';
var refreshIntervalGU = 0;
var errorImgSrc = 'images/error.gif';
var warningImgSrc = 'images/warning.gif';
var titleGU, stepNumGU, timerGU, eventListGU, lastStepGU, setFocusGU, adviceGU, markGU, focusedControlGU, acceptStateGU, oneRecordAddGridsGU, editableGridsGU, nOpsPerLineGU;
var waitMessageGU = null;
var waitHeightGU;
var waitWidthGU;
var urlGU = null;
var coverDiv = document.createElement('<DIV STYLE="cursor: wait; filter: alpha(opacity=0); z-index: 500; background-color: #FFFFFF; width: 100%; top: 0px; position: absolute;">');
var validationGU = true;
var insideClientOperationGU = false;
var errorCommandInvocationGU = false;
var undefCommandInvocationGU = false;
var removePopupsGU = true;
// Identificador en el manejador de paneles
var panelRegIdGU = -1;
// En esta variable se almacenara' el "parent" lo'gico para uniformizar, dado que en el caso de los "prompts" y paneles e'ste valor no va a coincidir con el "window.parent"
var realParentGU = null;
var realTopGU = null;
var accessDeniedURLGU = "accessDenied.html";
var afterfocusEventsGU = null;
var environment;
var reqStatusIntervalGU = null;
var nFailuresGU = 0;
var reqHasStartedGU = false;
var serverRequestCountGU;
var noGridsGU = true; // Indica si no hay grillas en la pantalla
var firstGridGU = null;
//-- calculadora



//-- fin calc
function initializeMessage()
{
	var size;
	
	if ((waitMessageGU != null) && !waitMessageGU.changed)
		return;
	
	// El mensaje sera' ma's corto en el caso de un 'popup'
	if (realParentGU != this)
	{
		text = "Procesando, por favor espere...";
		waitHeightGU = 105;
		waitWidthGU = 502;
	}
	else
	{
		text = "Procesando...";
		waitHeightGU = 105;
		waitWidthGU = 288;
	}

	waitMessageGU = document.createElement('<DIV style="BACKGROUND-COLOR: #ffffff; z-index: 300; display: none; position: absolute;">');
	waitMessageGU.innerHTML = 
	'<table bgcolor="#888888" cellpadding="0" cellspacing="3" style="position:absolute;" width="' + waitWidthGU + '"><tr><td>\
		<table bgcolor="#FFFFFF" cellSpacing="0px" cellPadding="0px">\
			<tr height="65">\
				<td width="21"></td>\
				<td>\
					<font color="#969696" face="Verdana" size="5">' + text + '</font>\
				</td>\
				<td width="16">\
				</td>\
				<td valign="middle">\
					<table cellSpacing="0px" cellPadding="0px">\
						<tr><td height="18px"></td></tr>\
						<tr valign="middle">\
							<td>\
								<img src="images/wait.gif"></img>\
							</td>\
						</tr>\
						<tr><td height="14px"></td></tr>\
					</table>\
				</td>\
				<td width="18"></td>\
			</tr>\
		</table>\
	</td></tr></table>\
	<iframe width="10px" height="10px" src="javascript:\'\'" onload="this.style.width = this.parentElement.childNodes[0].clientWidth; this.style.height = this.parentElement.childNodes[0].clientHeight"></iframe>';
	// Se le define altura y ancho pequeños de manera que nunca se llegue a ver por afuera del cartel de espera
	
	waitMessageGU.changed = false;
}

function changeMessage()
{
	var msg = waitMessageGU.firstChild;
	var background = waitMessageGU.childNodes[1];
	msg.height = 105;
	var tr = msg.firstChild.firstChild.firstChild.firstChild.firstChild.firstChild;
	var a = tr.childNodes[1].firstChild;
	tr.style.textAlign = "center";

	if (realParentGU != this)
	{
		a.size = 4;
		a.innerText = "El pedido no se est\u00E1 ejecutando en el servidor y no se ha recibido la respuesta. Puede deberse a que se reinici\u00F3 el servidor o a problemas con la red. Contacte a un administrador.";
		tr.height = 105;
	}
	else
	{
		a.size = 3;
		a.innerText = "No se ha recibido la respuesta.\nPuede deberse a que se reinici\u00F3 el servidor o a problemas con la red.\nContacte a un administrador.";
	}

	tr.childNodes[2].style.display = "none";
	tr.childNodes[3].style.display = "none";
	
	if ((typeof(background) != "undefined") && (background != null))
	{
		// En caso de estar en "processIndex.html" no hay IFRAME de fondo
		background.style.width = msg.clientWidth;
		background.style.height = msg.clientHeight;
	}

	waitMessageGU.changed = true;
}

// Similar a "preclick", pero utilizada para preprocesar eventos sin botón asociado, por ejemplo un refrescado.
function prePost(trunc, redefineOp)
{
	// Se valida que no se haya abierto otra sesio'n
	if (!realTopGU.checkBeforeSubmit(false))
		return false;

	if ((typeof(redefineOp) == "undefined") || (redefineOp == null))
		redefineOp = false;

	var confirmation, messages, confParent;

	// No se removera' el "popup" en caso de que se haya incovado una operacio'n
	removePopupsGU = false;

	// En caso de haber habido un error de formato en algún campo de entrada no se realiza el pedido
	if (!validationGU)
		return false;

	// Se realiza el chequeo de que las rutas de los archivos sean absolutas
	if (!checkFileInputs(true))
		return false;

	if (realParentGU != this)
	{
		// Se oculta el a'rea de confirmación en caso de existir
		confirmation = document.getElementById(confAreaNameGU);
		if (confirmation != null)
		{
			confParent = confirmation.parentNode;
			if (confParent != null)
				confParent.removeChild(confirmation);
		}

		// Se eliminan los posibles errores reportados
		removeErrors();

		// Se setea el 'iframe' objetivo del formulario de la página antes de ir al servidor
		realParentGU.sManager.setUnmamagedTarget();

		timerGU = setTimeout("waitMessage()", 1500);

		if (!opClickedGU || redefineOp)
		{
			document.body.attachEvent('onkeydown', voidEventHandler);
			opClickedGU = true;
			placeCover();

			// Se eliminan los pasos siguientes al actual
			if (trunc)
				realParentGU.sManager.removeFromCurrent();
		}
		else
			return false;

		beforeSubmit();

		return true;
	}
	else
	{
		// Control por compatibilidad hacia atra's
		if (self.frameElement == null)
		{
			placeCover();
			document.body.attachEvent('onkeydown', voidEventHandler);
			
			beforeSubmit();

			setClientCookies();

			return true;
		}
		else
		{
			var id = self.frameElement.parentId;
			
			if ((typeof(id) != "undefined") && (id != null))
			{
				// En caso de ser un 'popup' se notifica al manejador de los mismos que ponga éste en estado de espera
				if ((document.forms[0].target = top.popupManager.notifyLoading(id, self.frameElement.popupId)) != null)
				{
					timerGU = setTimeout("waitMessage()", 1500);
	
					if (!opClickedGU || redefineOp)
					{
						document.body.attachEvent('onkeydown', voidEventHandler);
						opClickedGU = true;
						placeCover();

						beforeSubmit();
						
						return true;
					}
				}
			}
		}

		return false;
	}
}

function preClickMarkRow(rowId, clientEvents)
{
	
	var len = event.srcElement.name.length;
	var selectedRow = event.srcElement.name.substring(len - 4, len);

	var elem = document.getElementById(rowId);
	if (elem != null)
		elem.value = eval(selectedRow);

	return preClick(clientEvents);
}

function preClick(clientEvents)
{
	// Se valida que no se haya abierto otra sesio'n (se valida que este' definido el "top" por objetos no manejados)
	if ((typeof(realTopGU) != "undefined") && (realTopGU != null) && (typeof(realTopGU.checkBeforeSubmit) != "undefined") && !realTopGU.checkBeforeSubmit(false))
		return false;

	return preClickWaitMessage(true, clientEvents);
}

function preClickWaitMessage(showMessage, clientEvents)
{
	var confirmation, messages, confParent;

	// No se removera' el "popup" en caso de que se haya incovado una operacio'n
	removePopupsGU = false;

	// En caso de haber habido un error de formato en algún campo de entrada no se realiza el pedido
	if (!validationGU)
		return false;

	// Se realiza el chequeo de que las rutas de los archivos sean absolutas
	if (!checkFileInputs(true))
		return false;

	if (realParentGU != this)
	{
		// Se notifica al contenedor de pasos los nuevos eventos generados
		realParentGU.sManager.notifyClientEvents(clientEvents);

		// Se oculta el área de confirmación en caso de existir
		confirmation = document.getElementById(confAreaNameGU);
		if (confirmation != null)
		{
			confParent = confirmation.parentNode;
			if (confParent != null)
				confParent.removeChild(confirmation);
		}

		// Se eliminan los posibles errores reportados
		removeErrors();

		// Se setea el 'iframe' objetivo del formulario de la página antes de ir al servidor
		document.forms[0].target = realParentGU.sManager.getTargetName(false, false, null);
		
		if (showMessage)
			timerGU = setTimeout("waitMessage()", 1500);

		if (!opClickedGU)
		{
			document.body.attachEvent('onkeydown', voidEventHandler);
			opClickedGU = true;

			placeCover();

			// Se eliminan los pasos siguientes al actual
			if (realParentGU != this)
				realParentGU.sManager.removeFromCurrent();
		}
		else
			return false;

		beforeSubmit();

		return true;
	}
	else
	{
		// Control por compatibilidad hacia atra's
		if (self.frameElement == null)
		{
			placeCover();
			document.body.attachEvent('onkeydown', voidEventHandler);
		
			beforeSubmit();

			setClientCookies();

			return true;
		}
		else
		{
			var id = self.frameElement.parentId;
			
			if ((typeof(id) != "undefined") && (id != null))
			{
				// En caso de ser un 'popup' se notifica al manejador de los mismos que ponga éste en estado de espera
				if ((document.forms[0].target = top.popupManager.notifyLoading(id, self.frameElement.popupId)) != null)
				{
					if (showMessage)
						timerGU = setTimeout("waitMessage()", 1500);
					
					if (!opClickedGU)
					{
						document.body.attachEvent('onkeydown', voidEventHandler);
						opClickedGU = true;
						placeCover();

						beforeSubmit();

						return true;
					}
				}
			}
		}

		return false;
	}
}

function beforeSubmit()
{
	// Se eliminan las "cookies" por si se aborto' algu'n pedido desde un "prompt" y quedo' el "popupId" definido
	clearClientCookies();
	
	if ((stepNumGU != null) && (stepNumGU != ""))
	{
		var procId = document.forms[0]._ZG1_PROCID;
		if (procId != null)
		{
			reqIdGU = procId.value + "_" + stepNumGU + "_" + realTopGU.getTimeStamp();
			document.cookie = "FRRequestId=" + reqIdGU;
		}
	}
	
	if (realParentGU != this)
	{
		// Se recuerda el elemento activo
		if ((document.activeElement != null) && ((document.activeElement.tagName == "INPUT") || (document.activeElement.tagName == "SELECT") || (document.activeElement.tagName == "TABLE")))
			realParentGU.sManager.setActiveElement(stepNumGU, document.activeElement.id != "" ? document.activeElement.id : document.activeElement.name, document.activeElementExtraInfo);
		else
			realParentGU.sManager.setActiveElement(stepNumGU, "");

		// Se recuerda el "scroll"
		realParentGU.sManager.setScrollTop(stepNumGU, document.body.scrollTop);
	}
}

// Chequea si una ruta es absoluta. Es utilizada para evitar errores de acceso denegado en campos de tipo 'file'
function checkAbsolutePath(path)
{
	if (path.length > 0)
	{
		if (path.charAt(0) != '\\')
		{
			if (path.length < 2)
				return false;
			else
			{
				if (((path.charAt(0) >= 'a') && (path.charAt(0) <= 'z')) || ((path.charAt(0) >= 'A') && (path.charAt(0) <= 'Z')))
					return path.charAt(1) == ':';
				else
					return false;
			}
		}
	}

	return true;
}

// Realiza el chequeo de la buena formacio'n de todos los campos de tipo archivo
// Este control no se hace de la misma forma que el resto (fechas o nu'meros) porque no se puede asegurar que al
// perder el foco realmente se haya corregido el valor debido al boto'n "browse" 
// 'reportError' -> true para indicar que se genera la alerta, y false en caso contrario.
function checkFileInputs(reportError)
{
	// Si hay 'inputs' de tipo 'file' se controla que no se generen errores de acceso denegado,
	// esto suceden cuando la ruta ingresada NO es absoluta
	if (document.forms[0] != null)
	{
		var elements = document.forms[0].elements;
		var el;

		for (var i = 0; i < elements.length; i++)
		{
			if (elements[i].type == 'file')
			{
				// En caso de estar dentro del contenedor se marca el paso comno que tiene un archivo para manejar especi'ficamente el error
				// que se da cuando el archivo excede el taman~o ma'ximo soportado por el servidor
				if (self.frameElement != null)
					self.frameElement.hasFile = true;

				el = elements[i];

				if (!checkAbsolutePath(elements[i].value))
				{
					// Se colorea en caso de error
					if ((typeof(el.prevClassName) == "undefined") || (el.prevClassName == null))
						el.prevClassName = el.className;
					el.className = "AttributeEmphasised";

					if (reportError)
					{
						alert("La ruta del archivo debe ser absoluta.");
						el.focus();
					}

					return false;
				}
				else
				{
					// Se vuelve al color original
					if ((typeof(el.prevClassName) != "undefined") && (el.prevClassName != null))
						el.className = el.prevClassName;
				}
			}
		}
	}

	return true;
}

function voidEventHandler()
{
	// Se evita la generacio'n de errores de acceso denegado frente al uso de teclas especiales como "ctrl" o "alt"
	try
	{
		// Se bloquea el teclado
		event.keyCode = 7;
	}
	catch (e) {}

	return false;
}

// Se asocia este evento el DIV de bloqueo
coverDiv.attachEvent('onkeydown', voidEventHandler);

function goToStep(stepNum, refresh, lastStep)
{
	// Este control es por compatibilidad con versiones viejas
	if (lastStep == null)
		lastStep = -1;

	// Se utiliza directamente el padre porque esta funcio'n es usada directamente sin previa inicializacio'n
	if (parent != this)
		parent.sManager.goToAndRefresh(null, stepNum, refresh, lastStep);
}

function goToStep2(procId, stepNum, refresh, lastStep)
{
	if (parent != this)
		parent.sManager.goToAndRefresh(procId, stepNum, refresh, lastStep);
}

function declareControls(controls)
{
	var wrongClasses;
	if (parent != self)
		wrongClasses = parent.declareControls(controls);
	else
		wrongClasses = opener.parent.declareControls(controls);
		
	var message;
	
	// En caso de haber controles no definidos en el sistema se genera el error correspondiente
	if (wrongClasses != null)
	{
		if (wrongClasses.length == 1)
		{
			printErrorMessage("No hay nung\u00FAn control de clase '" + wrongClasses[0] + "' definido en el sistema.", false, true, false);
			return;
		}
		
		message = "No hay controles definidos en el sistema para ninguna de las siguientes clases: '" + wrongClasses[0] + "'";
		
		for (var i = 1; i < wrongClasses.length; i++)
			message += ", '" + wrongClasses[i] + "'";
			
		message += ".";
		printErrorMessage(message, false, true, false);
	}
}

// Invoca el comando indicado en el control indicado.
// En caso que el control no este' definido se reportara' el error correspondiente.
//
// Para'metros:
//   "declaredInstanceName" -> Nombre de la instancia del control declarada en la defincio'n. Esto se utilizara'
//                             para el reporte del error.
//   "instanceName"         -> Nombre u'nico de la instancia (declaredInstanceName_controlClass).
//   "methodName"           -> Nombre del me'todo a invocar.
//   "params"               -> Vector de para'metros del me'todo a invocar.
//   "resultReceivers"      -> Lista de contenedores (objeto, propiedad) en donde se colocara' el resultado
//                             de la operacio'n invocada.
function invokeCommand(declaredInstanceName, instanceId, methodName, params, resultReceivers)
{
	var p;
	if (parent != self)
		p = parent;
	else
		p = opener.parent;
		
	// Se utiliza el padre directamente porque esta funcio'n es usada directamente sin previa inicializacio'n

	// El error se reporta solamente si NO se esta' dentro de una operacio'n de cliente o si es el primero de este tipo
	if (!p.invokeCommand(instanceId, methodName, params, resultReceivers) && (!insideClientOperationGU || (insideClientOperationGU && !errorCommandInvocationGU)))
	{
		// Si ocurrio' un error al invocar el me'todo porque no se encontro' en control se reporta
		printErrorMessage("El control '" + declaredInstanceName + "' no est\u00E1 definido.", true, true, false);
		errorCommandInvocationGU = true;
	}
}

function undefCommandInvocation(declaredInstanceName, commandName)
{
	// Si intento' invocar un comando no definido
	printErrorMessage("El comando '" + commandName + "' no est\u00E1 definido en el control '" + declaredInstanceName + "'.", true, true, false);
	undefCommandInvocationGU = true;
}

function beginClientOperation()
{
	removeErrors();
	
	errorCommandInvocationGU = false;
	undefCommandInvocationGU = false;
	// Se marca el inicio de la operacio'n de cliente
	insideClientOperationGU = true;
}

function endClientOperation(instanceId, spanName, clientEvents, doPost, condition)
{
	var p;
	if (parent != self)
		p = parent;
	else
		p = opener.parent;

	// Se marca el fin de la operacio'n de cliente
	insideClientOperationGU = false;
	
	// Si el control no estaba bien definido o alguno de los comandos no estaba bien definido no se hara' el "submit"
	if (!doPost || errorCommandInvocationGU || undefCommandInvocationGU)
	{
		errorCommandInvocationGU = false;
		undefCommandInvocationGU = false;
		return;
	}

	if (preClickWaitMessage(false, clientEvents))
	{
		// Se asegura que se haya terminado la ejecucio'n de todos los comandos definidos para esta operaci'n
		// Por las dudas se propociona una funcio'n pare hacer el "callback" de manera de que cuando realmente terminen las
		// ejecuciones se invoque el fin de esta operacio'on
		if (p.isControlReady(instanceId, endClientOperationCallBack, [spanName, condition]))
		{
			if ((condition == null) || eval(condition))
			{
				timerGU = setTimeout("waitMessage()", 1500);
				GX_setevent('E' + spanName + '.CLICK.');
				self.document.forms[0].submit();
			}
			else
				removeCover();
		}
	}
}

function endClientOperationCallBack(spanNameAndCondition)
{
	if ((spanNameAndCondition[1] == null) || eval(spanNameAndCondition[1]))
	{
		timerGU = setTimeout("waitMessage()", 1500);
		GX_setevent('E' + spanNameAndCondition[0] + '.CLICK.');
		self.document.forms[0].submit();
	}
	else
		removeCover();
}

// Oculta la barra de herramientas para las ima'genes del IE
function hideImageToolBar()
{
	var imgs = document.getElementsByTagName('IMG');
	
	for (var i = 0; i < imgs.length; i++)
		imgs[i].galleryImg = false;
}

function attachAfterfocus(handler)
{
	if (afterfocusEventsGU == null)
		afterfocusEventsGU = new Array();

	afterfocusEventsGU.push(handler);
}

function detachAfterfocus(handler)
{
	if (afterfocusEventsGU == null)
		return;

	for (var i = 0; i < afterfocusEventsGU.length; i++)
	{
		if (afterfocusEventsGU[i] == handler)
		{
			afterfocusEventsGU[i] = null;
			return;
		}
	}
}

function execAfterfocusEvents()
{
	if (afterfocusEventsGU == null)
		return;

	for (var i = 0; i < afterfocusEventsGU.length; i++)
	{
		if (afterfocusEventsGU[i] != null)
		{
			try
			{
				afterfocusEventsGU[i]();
			}
			catch (e) {}
		}
	}
}

function clearClientCookies()
{
	document.cookie = "popupId=";
}

function setClientCookies()
{
	try
	{
		if (realParentGU == this)
		{
			if (popupIdGU != null)
			{
				// "popup" viejo
				document.cookie = "popupId=" + popupIdGU;
			}
			else
			{
				// "popup" nuevo
				document.cookie = "popupId=" + document.forms[0]._ZG1_POPUPID.value;
			}
		}
	}
	catch (e)
	{
		clearClientCookies();
	}
}

// Notifica la carga de una página.
// 'title' -> título de la página
// 'stepNum'                 -> Nu'mero de paso de la página.
// 'eventList'               -> Vector con el conjunto de eventos (a nivel del cliente)
//                              a los que página se subscribirá.
// 'hasMessages'             -> 'E' para indicar que la página contiene mensajes de error, 'W' para indicar
//                              que contiene mensajes de advertencia, 'N' para indicar que no contiene mensajes,
//                              y 'C' para indicar que ocurrió una confirmación.
// 'lastStep'                -> Indica el último paso significativo a nivel del servidor. -1 para indicar que todos los
//                              pasos son significativos.
// 'refreshInterval'         -> Tiempo de refrescado automático en segundos, en caso de ser -1 no se refrescará automáticamente.
// 'mark'                    -> Marca de navegacio'n del paso, cadena de caracteres vaci'a en caso de no tener marca.
// 'genereratedClientEvents' -> Lista de eventos generados siempre por esta pa'gina.
// 'focusedControl'          -> Identificador o nombre del control al que se debera' definir en foco.
// 'oneRecordAddGrids'       -> Vector con identificacores de grillas que posean el comportamiento de agregado de registro.
function initializePage(title, stepNum, eventList, hasMessages, lastStep, refreshInterval, mark, generatedClientEvents, focusedControl, oneRecordAddGrids, nOpsPerLine)
{
	var popupId;

	if (typeof(self.opener) != "undefined")
	{
		popupId = getCookie("popupId");
		if (popupId != null)
		{
			initializePrompt(0, popupId, oneRecordAddGrids, nOpsPerLine);
			return;
		}
	}

	clearClientCookies();

	if (!checkEnvironment(1))
		return;

	// Se marca el paso como "manejado" de manera que cuando se ejecute en "onreadystateHandlerSM" no se haga nada,
	// ya que se notificara' por aca'. En caso contrario se ejecutari'a esto luego que eso y se asumiri'a que la
	// pa'gina no es manejada
	if ((typeof(self.frameElement) != "undefined") && (self.frameElement != null))
		 self.frameElement.managed = true;

	if ((typeof(focusedControl) == "undefined") || (focusedControl == null))
		focusedControl = "";
	
	// En caso que no se haya definido correctamente el tipo del contenedor padre (invocaciones viejas a "attachOnKeyDown") se define aqui'
	if ((typeof(ownerLevelGU) == "undefined") || (ownerLevelGU == null))
		ownerLevelGU = 0;
	
	// Se oculta la barra de herramientas para las ima'genes en IE
	hideImageToolBar();

	realParentGU = parent;
	realTopGU = self.top;
	
	// Este control es por compatibilidad con versiones viejas
	if (lastStep == null)
		lastStep = -1;

	if (realParentGU != this)
	{
		// En caso que haya errores o confirmacio'n no se mantendra' el foco en el campo anterior para evitar que el "scroll"
		// oculte los avisos, asi' como tampoco se respetar'a el la posicio'n de "scroll" anterior
		if ((hasMessages != 'N') || (document.getElementById(confAreaNameGU) != null))
		{
			realParentGU.sManager.setActiveElement(stepNum, "");
			realParentGU.sManager.setScrollTop(stepNum, 0);
		}

		oneRecordAddGridsGU = oneRecordAddGrids;
		externalGU = false;
		titleGU = title;
		stepNumGU = stepNum;
		eventListGU = eventList;
		hasMessagesGU = hasMessages;
		focusedControlGU = focusedControl;
		lastStepGU = lastStep;
		markGU = mark;
		refreshIntervalGU = refreshInterval;
		nOpsPerLineGU = nOpsPerLine;

		redefineSubmit();
		self.focus = onfocusHandler;

		if ((typeof(generatedClientEvents) != "undefined") && (generatedClientEvents != null))
		{
			// Se notifica al contenedor de pasos los nuevos eventos generados
			realParentGU.sManager.notifyClientEvents(generatedClientEvents);
		}

		// Se seteara' el foco solamente cuando NO se este' ante un caso de refrescado atuoma'tico
		setFocusGU = (typeof(self.frameElement.autoRefresh) == "undefined") || !self.frameElement.autoRefresh;
		// Se avisara' solamente si es un refrescado automa'tico que sea el u'ltimo
		adviceGU = self.frameElement.autoRefresh && (refreshInterval == null || refreshInterval <= 0);

		document.body.onload = onloadHandler;
		document.forms[0].onactivate = onactivateFormHandler;
		
		document.body.onresize = new Function("removeOperationShortcuts(null, false);");

//		document.oncontextmenu = voidEventHandler;
	}
}

function initializeExternalPage()
{
	clearClientCookies();
	
	// Si no se esta' dentro del ambiente no se muestra la pa'gina
	if (typeof(top.environment) != "function")
	{
		self.location.assign(accessDeniedURLGU);
		return;
	}

	// Se marca el paso como "manejado" de manera que cuando se ejecute en "onreadystateHandlerSM" no se haga nada,
	// ya que se notificara' por aca'. En caso contrario se ejecutari'a esto luego que eso y se asumiri'a que la
	// pa'gina no es manejada
	if ((typeof(self.frameElement) != "undefined") && (self.frameElement != null))
		 self.frameElement.managed = true;

	realParentGU = self.parent;
	realTopGU = self.top;
	
	if (realParentGU != this)
	{
		// Se notifica al manejador de procesos que este proceso es externo
		realParentGU.notifyExternalWorkSpace();
		
		externalGU = true;
		titleGU = "";
		stepNumGU = 0;
		eventListGU = "";
		hasMessagesGU = "N";
		focusedControlGU = "";
		lastStepGU = -1;
		markGU = "";
		refreshIntervalGU = 0;
		document.body.onload = onloadHandler;

//		document.oncontextmenu = voidEventHandler;
	}
}

function isExternalPage()
{
	if (externalGU)
	{
		// Espacio de trabajo externo
		return true;
	}
	else
	{
		// Se comprueba si existe la variable que marca la dirección base, para ver si se trata de paso concreto externo
		return ((typeof(initialUrl) != "undefined") && (initialUrl != null));
	}
}

function notifyExternalChange()
{
	if (realParentGU != this)
	{
		realParentGU.notifyExternalChange();
	}
}

function onloadHandler()
{
	var elements, i;

	if (externalGU)
	{
		// Se realiza este control por si se cerró el paso durante la carga
		if ((typeof(top.popupManager) != "undefined") && (top.popupManager != null))
			// Se notifica que la página externa fue cargada
			realParentGU.sManager.notifyExternalLoadEnd(titleGU, stepNumGU, eventListGU, hasMessagesGU, this.frameElement, lastStepGU, markGU, false);
	}
	else
	{
		// Se remueven los SELECTS del paso anterior antes de ocultarlo para eviar parpadeos
		realParentGU.sManager.removePrevSelects(stepNumGU, lastStepGU, self.frameElement);
	
		// Se mantiene el "scroll"
		self.scrollTo(0, realParentGU.sManager.getConcreteScrollTop(stepNumGU));

		// Se realiza este control por si se cerró el paso durante la carga
		if ((typeof(top.popupManager) != "undefined") && (top.popupManager != null))
		{
			// Se notifica que la página fue cargada
			var pos = realParentGU.sManager.notifyLoadEnd(titleGU, stepNumGU, eventListGU, hasMessagesGU, this.frameElement, lastStepGU, markGU, false);
			// Se asocian las nuevas validaciones para tener control sobre los errores
			var script = document.createElement("<SCRIPT SRC='javascripts/validations.js'>");
			document.body.appendChild(script);

			// En algunos casos queda desahibilitada la pa'gina cuando el paso actual no es el que se recibio' (ti'picamente
			// un "auto-refresh" de un paso previo, se ejecuta esto a modo de workaround
			if ((pos != null) && (pos != realParentGU.sManager.current))
			{
				self.frameElement.style.visibility = "visible";
				self.frameElement.style.visibility = "hidden";
			}
		}

		// Se invoca el evento de a nivel de cliente con el co'digo a ejecutar luego de la carga
		try
		{
			if (typeof(customOnloadEvent) != "undefined")
				customOnloadEvent();
		}
		catch (e) {}
	}

	document.body.onscroll = onscrollHandler;

	// Se corrige la altura de las grillas que tengan scroll
	fixGridsScrollHeight(false);

	// Se corrige la alineacio'n de las operaciones
	fixOperationsAlignment(nOpsPerLineGU);
	
	// Se vuelven a ajustar las grillas por cambios hechos en las operaciones
	fixGridsScrollHeight(false);
	
	initializeGrids(oneRecordAddGridsGU);

	// Se utiliza un 'timer' ya que si no la primera ejecución dentro de un espacio de trabajo no setea el foco correctamente
	if (setFocusGU)
		setFocusTime1();

	// En caso de tener un tiempo de refrescado definido se setea el mismo
	if (refreshIntervalGU > 0)
		setTimeout("realParentGU.sManager.clientRefreshIndicatedStep(" + stepNumGU + ")", 1000 * refreshIntervalGU);
}

function onscrollHandler()
{
	top.closeAll();
}

// design -> indica si se esta' en modo de disen~o o ejecucio'n
function fixGridsScrollHeight(design)
{
	
	var divs = document.getElementsByName(gridDivNameGU);
	
	for (var i = 0; i < divs.length; i++)
	{
		var div = divs[i];
		var child;

		// Las grillas con seleccio'n tienen el INPUT oculto con la fila seleccionada antes que el TABLE
		if (div.firstChild.tagName == "TABLE")
			child = div.firstChild;		
		else		
			child = div.childNodes[1];
			
		if (child.clientWidth > div.xwidth)
		{			
			// En caso que se haga visible la barra de scroll se debe agregar un padding de 17 pi'xeles
			// porque la barra de scroll ocupa espacio de la grilla propiamente dicha
			div.style.width = div.xwidth + "px";
			if (!design)
			{
				var headers = child.rows[0].children;
				for (var j = 0; j < headers.length; j++)
					headers[j].noWrap = true;
				
				div.style.paddingBottom = "17px";
			}
			
			// En disen~o si todas las columnas son editables se ajustan para no mostrar "scroll", 
			// por lo tanto se fuerza aqui'
			if (design)
				div.style.overflowX = "scroll";
		}
		else
		{
			// DG: Fix provisorio mientras Diego no lo arregle
			div.style.width = div.xwidth + "px";
			
			if (!design)			
				div.style.paddingBottom = "0px";
			
			if (design)
				div.style.overflowX = "auto";
		}
	}
	
}

function fixOperationsAlignment(nOpsPerLine)
{
	if ((typeof(nOpsPerLine) != "undefined") && (nOpsPerLine != null))
	{
		var divs = document.getElementsByName(operationsDivNameGU);

		for (var i = 0; i < divs.length; i++)
		{
			var aux = divs[i];

			// En caso de no haber operaciones simplemente se oculta el elemento lo que corresponde
			if ((aux.firstChild == null) || (aux.firstChild.childNodes.length == 0))
			{
				// type == "global" indica que son operaciones de pa'gina, lo cual requiere remover la tabla entera que contiene al elemento
				if (aux.type == "global")
				{
					// Se oculta toda la tabla auxiliar del pie de pa'gina
					aux.parentNode.parentNode.parentNode.style.display = "none";
				}
				else if (aux.type == "grid")
				{
					if (aux.parentNode.parentNode.previousSibling.firstChild.firstChild.tagName == "TABLE")
					{
						// Hay paginado, por lo tanto no se oculta la separacio'n previa
						aux.parentNode.parentNode.style.display = "none";
					}
					else
					{
						aux.parentNode.parentNode.previousSibling.previousSibling.style.display = "none";
						aux.parentNode.parentNode.style.display = "none";
					}
				}
				else
				{
					// categori'a o sub-categori'a, se oculta la fila entera TR
					aux.parentNode.parentNode.style.display = "none";
				}
			}
			else
			{
				var realignHeaders = false;

				// En caso de ser una grilla se define el ancho del div ya que puede variar dependiendo del ancho concreto de la grilla
				if (aux.type == "grid")
				{
					// Se define el ancho segu'n la cantidad de operaciones que haya (sin pasarse del máximo por li'nea)
					// Si ese ancho es menor que el de la grilla se define el de e'sta para que el a'rea de operaciones no quede desalineada

					var nActualOps = aux.firstChild.childNodes.length;
					var width = getWidthForOperations(nActualOps);
					var gridWidth = aux.parentNode.parentNode.parentNode.parentNode.clientWidth;

					// En caso que no haya suficientes operaciones como para llenar el ancho de la grilla, se estira
					// el a'rea de operaciones para que quede igual que la grilla

					if (width - 6 <= gridWidth)
						width = gridWidth + 6;
					else
						realignHeaders = true;

					if (aux.firstChild.childNodes.length <= nOpsPerLine)
						aux.style.width = width + "px";
					else
						aux.style.width = (getWidthForOperations(nOpsPerLine)) + "px";
				}

				if (realignHeaders)
				{
					// Como el ancho de la grilla se estiro' por causa de las operaciones los ti'tulos quedan mal alineados
					// ya que se alinean segu'n el atributo width
					try
					{
						var gridHeaderRow = aux.parentNode.parentNode.previousSibling.previousSibling.previousSibling.firstChild.firstChild.firstChild.firstChild;
						// Si la grilla se genero' con un DIV alrededor para tener scroll horizontal hay que avanzar un nivel ma's						
						if (gridHeaderRow.tagName != "TR")
							gridHeaderRow = gridHeaderRow.firstChild;

						var ths = gridHeaderRow.childNodes;

						for (var i = 0; i < ths.length; i++)
						{
							// En caso que la columna tenga texto se elimina su ancho para que se corrija la alineacio'n
							if (ths[i].innerText.length > 0)
							{
								ths[i].width = "";
								ths[i].style.width = ths[i].clientWidth - 4;
							}
						}
					}
					catch (e) {}
				}
			}
		}
	}
}

// Devuelve el ancho necesario para el a'rea de operaciones segu'n la cantidad de operaciones por li'nea.
function getWidthForOperations(nOperations)
{
	// ancho de las operaciones + 
	// ancho entre operaciones + 
	// espacio a la izquierda y derecha

	if (nOperations < 8)
		return (119 * nOperations) + ((nOperations - 1) * 6) + 12;
	else
	{
		// En caso que se trate de una pa'gina grande la separacio'n entre operaciones es 4 no 6, y el ancho de las operaciones 117 en vez de 119
		return (117 * nOperations) + ((nOperations - 1) * 4) + 8;
	}
}

function setFocusTime1()
{
	setTimeout(setFocus, 1);
}

function setFocus()
{
	removeOperationShortcuts(null, true);
	
	// Se setea el foco donde se indico'
	if (focusedControlGU != "")
	{
		try
		{
			var toFocus;
			
			if ((toFocus = document.getElementById(focusedControlGU)) != null)
			{
				focusedControlGU = "";
				toFocus.focus();

				// Se hace un "select" porque en caso de no ser la primer pantalla del espacio de trabajo
				// el foco no quedaba bien seteado si no se haci'a esto
				if (toFocus.tagName == "INPUT")
					toFocus.select();

				// Se ejecutan el evento luego del posicionado del foco
				execAfterfocusEvents();
				
				return;
			}
			else
			{
				var elems = document.getElementsByName(focusedControlGU);
				focusedControlGU = "";

				for (var i = 0; i < elems.length; i++)
					if ((elems[i].tagName == "INPUT") || (elems[i].tagName == "SELECT"))
					{
						elems[i].focus();

						// Se ejecutan el evento luego del posicionado del foco
						execAfterfocusEvents();

						return;
					}
			}
		}
		catch (e) {}
	}

	if (realParentGU != this)
	{
	    var activeInfo = realParentGU.sManager.getActiveElement(stepNumGU);
	
		if ((activeInfo != null) && (activeInfo.elementId != ""))
		{
			var elem = document.getElementById(activeInfo.elementId);

			// La segunda parte de la condicio'n es porque en IE "getElementById" devuelve uno de los elementos con ese id, en MOZ si hay ma's
			// de uno devuelve null, y en el caso de los radio buttons es de intere's que el foco quede exactamente en el mismo radio button
			// que estaba previo la ida al servidor
			if ((elem == null) || ((elem.tagName == "INPUT") && (elem.type == "radio")))
			{
				var elems = document.getElementsByName(activeInfo.elementId);
				for (var i = 0; i < elems.length; i++)
					if ((elems[i].tagName == "INPUT") || (elems[i].tagName == "SELECT") || (elems[i].tagName == "TABLE"))
					{
						// En el caso de tratarse de un radio button no se debe definir el foco en el primer INPUT que lo componga
						// si no en el que teni'a el foco previamente que es el chequeado
						if ((elems[i].tagName == "INPUT") && (elems[i].type == "radio") && !elems[i].checked)
							continue;
						elem = elems[i];
						break;
					}
			}
			
            if ((elem != null) && (elem.tagName == "TABLE"))
            {
                // En el caso de tratarse de una tabla viene acompan~ada de informacio'n adicional que indica si se debe posicionar el foco
                // en la primer o u'litma fila de la misma
                elem = grGetInputForFocusing(elem, activeInfo.extraInfo);
            }
			
			if (elem != null)
			{
				if ((elem.type != 'hidden') && !elem.disabled)
				{
					try
					{
						elem.focus();

						// Se hace un "select" porque en caso de no ser la primer pantalla del espacio de trabajo
						// el foco no quedaba bien seteado si no se haci'a esto
						if (elem.tagName == "INPUT")
							elem.select();

						// Se ejecutan el evento luego del posicionado del foco
						execAfterfocusEvents();

						return;
					}
					catch (e) {}
				}
			}
		}
	}

	var found = false;

	// Se setea el foco en el primer campo editable en caso que e'ste exista y que el paso este' visible
	// Adema's este campo debe estar dentro del a'rea visible segu'n el "scroll" actual
	if ((document.forms[0] != null) && (self.frameElement.style.visibility == "visible"))
	{
		// Se obtiene el a'rea visible
		var top = document.body.scrollTop;
		var bottom = top + document.body.clientHeight;
		var offset;
		
		elements = document.forms[0].elements;

		for (var i = 0; i < elements.length; i++)
		{
			if ((elements[i].type != "hidden") && !elements[i].disabled)
			{
				offset = window.top.offsetTop(elements[i]);
				
				// Se verifica que este' dentro del a'rea visible
				if ((top <= offset) && (offset <= bottom))
				{
					try
					{
						// Se hacen estas invocaciones porque se encontro' un caso en el cual la pantalla quedaba
						// totalmente deshabilitada (bug del IE), no se podi'an seleccionar ni siquiera el texto de las etiquetas
						// Ralizando un blur y un focus extra se corrigio'
						elements[i].focus();
						elements[i].blur();
						elements[i].focus();
						
						// Se hace un "select" porque en caso de no ser la primer pantalla del espacio de trabajo
						// el foco no quedaba bien seteado si no se haci'a esto
						if (elements[i].tagName == "INPUT")
						{
							var x = elements[i];
							function xx()
							{
								x.select();
							}
							setTimeout(xx, 1);
						}
							
						found = true;
						break;
					}
					catch (e) {}
				}
			}
		}

		// Si no hay ningún campo habilitado de todas formas se define el foco en la pa'gina
		if (!found)
		{
			if (firstGridGU == null)
				document.body.focus();
			else
				firstGridGU.focus();
			paintOriginalEnterButton();
		}
	}

	// Se ejecutan el evento luego del posicionado del foco
	execAfterfocusEvents();
}

function waitMessage()
{
	// Si es la primera vez se crea el mensaje
	initializeMessage();

	// En caso que el paso no este' visible se hace visible solo para este ca'lculo
	if (self.frameElement.style.visibility == 'hidden')
	{
		self.frameElement.style.visibility = 'visible';

		t = (document.documentElement.scrollHeight - waitHeightGU) / 2;
		l = (document.documentElement.scrollWidth - waitWidthGU) / 2;

		self.frameElement.style.visibility = 'hidden';
	}
	else
	{
		t = (document.documentElement.scrollHeight - waitHeightGU) / 2;
		l = (document.documentElement.scrollWidth - waitWidthGU) / 2;
	}

	waitMessageGU.style.left = l;
	waitMessageGU.style.top = t;

	document.appendChild(waitMessageGU);
	waitMessageGU.style.display = 'inline';
	
	if (reqIdGU != null)
	{
		// Se define un "timer" encargado de verificar si el pedido sigue efectivamente en ejecucio'n en el servidor
		// Si 3 consultas sucesivas (nFailuresGU) devuelven que no se esta' ejecutando se reporta el error, esto es para darle
		// tiempo de llegar a la respuesta
		serverRequestCountGU = realTopGU.getServerRequestCount();
		reqStatusIntervalGU = setInterval(checkReqStatus, 10000);
	}
}

function checkReqStatus()
{
	// En caso que se haya cerrado la ventana no va a existir la funcio'n "top.getServerRequestCount" de esta forma
	// se realiza un control extra para evitar dejar "timers" corriendo
	if (typeof(top.getServerRequestCount) == "undefined")
	{
		stopTimer();
		hidePopup();
		stopTimer();
		removeCover();
		return;
	}
	
	// Se utiliza "top" directamente porque solamente va a ser usado desde "processIndex.html" y desde pantallas "other"
	var count = top.getServerRequestCount();

	if (!reqHasStartedGU)
		reqHasStartedGU = top.executionHasStarted(reqIdGU);

	if (reqHasStartedGU && top.executionHasEnded(reqIdGU))
	{
		// Si se logro' ir al servidor al menos una vez entre medio se aumenta el nu'mero de fallos
		// De esta forma se intenta asegurar que siempre haya habido al menos 3 verificaciones efectivas, ya que si no seri'a
		// posible que se estuvieran usando las dos conexiones del IE y se asumiera que el pedido se perdio' porque nunca se pudo
		// verificar efectivamente contra el servidor.
		if (serverRequestCountGU < count)
		{
			serverRequestCountGU = count;
			nFailuresGU++;

			if (nFailuresGU >= top.getMaxWaitCalls())
			{
				// Se reporta el error en la conexio'n
				stopTimer();
				changeMessage();
			}
		}
	}
	else
	{
		nFailuresGU = 0;
	}
}

function hidePopup()
{
	if ((waitMessageGU != null) && (waitMessageGU.style.display == 'inline'))
	{
		waitMessageGU.style.display = 'none';
		document.removeChild(waitMessageGU);
	}
}

function stopTimer()
{
	clearTimeout(timerGU);
	
	// Se resetea lo relativo al control de la ejecuicio'n del requerimiento
	if (reqStatusIntervalGU != null)
	{
		clearInterval(reqStatusIntervalGU);
		reqStatusIntervalGU = null;
	}
	nFailuresGU = 0;
}

// Posiciona el 'DIV' encargado de bloquear todo.
function placeCover()
{
	// Se define la altura del cobertor de manera que solamente cubra todo el espacio
	// visible del 'BODY' y todo el espacio de 'scroll' del mismo
	if (document.body.clientHeight > document.body.scrollHeight)
		coverDiv.style.height = document.body.clientHeight;
	else
		coverDiv.style.height = document.body.scrollHeight;

	coverDiv.style.width = document.body.clientWidth;

	document.body.appendChild(coverDiv);
}

// Remueve 'DIV' encargado de bloquear todo.
function removeCover()
{
	opClickedGU = false;
	if (coverDiv.parentNode != null)
	{
		document.body.removeChild(coverDiv);
		document.body.detachEvent('onkeydown', voidEventHandler);
	}
}

function operationClicked()
{
	return opClickedGU;
}

function resetWorkSpace()
{
	// Se utiliza directamente el padre porque esta funcio'n es usada directamente sin previa inicializacio'n
	if (parent != this)
		parent.closeProcess();
}

// Esta función devuelve la altura de la pantalla en funcion de la tabla que contiene todo. Es utilizada
// para obtener dinámicmante la altura de un panel.
function getRealHeight()
{
	// Los 3 píxeles se deben a la fila de altura 0 que defina la alineción del formulario principal
	return document.getElementsByTagName("table")[0].clientHeight - 3;
}

function getCookie(name)
{
	var values, cookie = document.cookie.split("; ");

	for (var i = 0; i < cookie.length; i++)
	{
		values = cookie[i].split("=");
		if (name == values[0])
			return values[1];
	}

	return null;
}

// fromWhat = 1 caso normal
// fromWhat = 2 caso prompt
// fromWhat = 0 cualquiera de los dos (error.html)
function checkEnvironment(fromWhat)
{
	if ((fromWhat == 2) || (fromWhat == 0))
	{
		if (typeof(self.opener) != "undefined")
		{
			// "Prompt"
			
			// Si no se esta' dentro del ambiente no se muestra la pa'gina, en este caso devuelve "object"
			if ((typeof(self.opener.top.environment) != "object") && (typeof(self.opener.top.environment) != "function"))
			{
				self.location.assign(accessDeniedURLGU);
				return false;
			}
	
			// Este "prompt" puede ser padre de otro
			environment = new Function();
		}
		else
		{
			// Panel
	
			// Si no se esta' dentro del ambiente no se muestra la pa'gina
			if ((top != self) && (typeof(top.environment) != "function"))
			{
				self.location.assign(accessDeniedURLGU);
				return false;
			}
		}
	}

	if ((fromWhat == 1) || (fromWhat == 0))
	{
		// Si no se esta' dentro del ambiente no se muestra la pa'gina
		if (typeof(top.environment) != "function")
		{
			self.location.assign(accessDeniedURLGU);
			return false;
		}
	}


	return true;
}

// Notifica la carga de un 'prompt'.
// 'acceptState' -> 1 para indicar que se vuelve luego de la operacio'n "Aceptar" y hay que automa'ticamente devolver los valores.
function initializePrompt(acceptState, popupId, oneRecordAddGrids, nOpsPerLine)
{
	if ((typeof(popupId) != "undefined") && (popupId != null) && (popupId != ""))
	{
		// "popup" nuevo
		popupIdGU = popupId;
	}
	else
	{
		// "popup" viejo, se obtiene el identificador de "popup" de la "cookie" y se elimina el mismo
		popupIdGU = getCookie("popupId");
	}

	clearClientCookies();

	if (!checkEnvironment(2))
		return;

	// Se redefine este valor porque los programas normales cuando son invocados como "prompt" hacen incovaciones
	// a "attachOnKeyDown" con un valor que corresponde a un programa comu'n en lugar de a un "prompt"
	ownerLevelGU = -1;

	// Chequeo por compatibildad hacia atra's
	if (self.frameElement != null)
	{
		var id = self.frameElement.parentId;

		// Se setea el padre y la ventana que abrio' e'sta, y se muestra el contenido
		if ((typeof(id) != "undefined") && (id != null) && (typeof(top.popupManager) != "undefined") && (top.popupManager != null))
		{
			self.opener = top.popupManager.getParent(id);

			// Se utiliza un 'timer' para que el manejador de 'popups' pueda consultar por la altura de esta pantalla "getRealHeight()"
			// y se le devuelva el valor real
			setTimeout("top.popupManager.notifyLoadEnd(" + id + ", self.frameElement.popupId)", 1);
		}

		// Se redefine la operación "window.close()" para que el código generado funcione correctamente
		self.close = closePrompt;
	}

	realParentGU = this;
	realTopGU = opener.realTopGU;
	acceptStateGU = acceptState;
	oneRecordAddGridsGU = oneRecordAddGrids;
	nOpsPerLineGU = nOpsPerLine;

	document.body.onload = promptOnloadHandler;
	document.forms[0].onactivate = onactivateFormHandler;

	redefineSubmit();
	self.focus = onfocusHandler;

	document.body.onresize = new Function("removeOperationShortcuts(null, true);");
		
//	document.oncontextmenu = voidEventHandler;

	if (popupIdGU != null)
	{
		// Se asocia al "unload" un evento que notifica el cerrado del "popup"
		self.popupSerId = popupIdGU;
		if (self.onunload == null)
		{
			self.attachEvent("onunload", winUnload);
			self.onunload = "attached";
		}
	}
}

function setPromptFocus()
{
	if ((parent == this) || (self.frameElement.style.display != "none"))
	{
		if (document.forms[0] != null)
		{
			var found = false;
			var elements = document.forms[0].elements;
	
			for (var i = 0; i < elements.length; i++)
			{
				if ((elements[i].type != "hidden") && !elements[i].disabled)
				{
					try
					{
						elements[i].focus();
						found = true;
						break;
					}
					catch (e) {}
				}
			}
	
			// Si no hay ningún campo habilitado de todas formas se define el foco en la pa'gina
			if (!found)
			{
				if (firstGridGU == null)
					document.body.focus();
				else
					firstGridGU.focus();
			}
		}
	}

	// Se ejecutan el evento luego del posicionado del foco
	execAfterfocusEvents();
}

function winUnload()
{
	// Si se ejecuto' una operacio'n no se remueven los "popups"
	if (removePopupsGU)
	{
		if (typeof(self.opener) != "undefined")
		{
			// Si se cerro' el "prompt" padre el objeto "opener" no queda indefinido, sino que queda de tipo
			// "object" pero al intentar acceder a cualquier propiedad falla
			try
			{
				// "Prompt"
				opener.top.clearPopup(this.popupSerId);
			}
			catch (e) {}
		}
		else
		{
			if (top != self)
			{
				// Panel
				top.clearPopup(this.popupSerId);
			}
		}
	}
}

// Para poder atener los pedidos de "prompts" anidados
function clearPopup(popupId)
{
	if (typeof(opener) != "undefined")
		opener.top.clearPopup(popupId);
	else
	{
		// Se evita la recursividad infinita
		if (top != self)
			top.clearPopup(popupId);
	}
}

function promptOnloadHandler()
{
	// Se invoca el evento de a nivel de cliente con el co'digo a ejecutar luego de la carga
	try
	{
		if (typeof(customOnloadEvent) != "undefined")
			customOnloadEvent();
	}
	catch (e) {}

	// Se corrige la altura de las grillas que tengan scroll
	fixGridsScrollHeight(false);

	// Se corrige la alineacio'n de las operaciones
	fixOperationsAlignment(nOpsPerLineGU);
	
	// Se vuelven a ajustar las grillas por cambios hechos en las operaciones
	fixGridsScrollHeight(false);

    initializeGrids(oneRecordAddGridsGU);
    
    if (document.activeElement != null)
	{
		// Se elimina el foco definido desde la pa'gina por GX de forma que al setearlo nuevamente en "setPromptFocus"
		// se ejecute el evento "onactivateFormHandler" y se detecte correctamente si se esta' en un a'rea de filtrado
		document.body.setActive();
	}
    
	// Se setea el foco en el primer campo del "prompt" y se ejecutan los eventos posteriores al mismo
	setTimeout("setPromptFocus()", 1);

	// Se hace el retorno automa'tico en caso de ser necesario
	if ((typeof(acceptStateGU) != "undefined") && (acceptStateGU != null) && (acceptStateGU == 1))
		attachAcceptEvent2(0);
}

// Función utilizada para redefinir el "window.close()" de los prompts
function closePrompt()
{
	top.popupManager.removePopup(self.frameElement.parentId, self.frameElement.popupId);
}

function refreshOnChange(spanName)
{
	var toEval = function()
	{
		if (preClick(null))
		{
			GX_setevent('E' + spanName + '.CLICK.');
			document.forms[0].submit();
		}
	}

	// Se utiliza un "timer" de forma de evitar parpadeos cuando se cambia el valor de un SELECT con el rato'n (con el teclado no pasa)
	setTimeout(toEval, 1);
}

function cboxPropertychangeHandler()
{
	// Como los "checkbox's" no tienen evento "onchange" se utiliza el evento "onpropertychange", por lo tanto se verifica 
	// que el nombre de la propiedad cambiada
	if (event.propertyName == "checked")
	{
		refreshOnChange(event.srcElement.eventName);
	}
}

function applyCboxOnchange(id, eventName, isColumn)
{
	if (isColumn)
	{
		for (var i = 1;; i++)
		{
			// Se va aumentando el i'ndice de la fila y asociando los eventos correspondientes
			var rowId = id + '_' + to4Digits(i);
			
			if (!internalApplyCboxChange(rowId, eventName))
				break;
		}
	}
	else
	{
		internalApplyCboxChange(id, eventName);
	}
}

function internalApplyCboxChange(id, eventName)
{
	var cb = document.getElementById(id);
	
	if (cb != null)
	{
		cb.eventName = eventName;
		cb.onpropertychange = cboxPropertychangeHandler;
		
		return true;
	}

	return false;
}

// A diferencia de los checkboxs no hay caso de tipo "columna" porque GX no permite definir radio buttons en las columnas
function applyRadioOnchange(name, eventName)
{
	var rads = document.getElementsByName(name);
	if (rads.length == 0)
		return;

	// Se les define "onlick" a todos los INPUT's con el nombre indicado (cada radio button)
	for (var i = 0; i < rads.length; i++)
	{
		var r = rads[i];	
		if (r != null)
		{
			r.eventName = eventName;
			r.checked2 = r.checked;
			// Se puede utilizar el "onlclick" porque funciona en radio buttons aunque se cambie el valor con el teclado
			r.attachEvent("onclick", radioClickHandler);
		}
	}
}

function radioClickHandler()
{
	var radio = window.event.srcElement;

	if (radio.checked2 != radio.checked)
		refreshOnChange(radio.eventName);
}

/**********************
 * Reporte de errores *
 **********************/

function removeErrors()
{
	var messageArea = document.getElementById(messageAreaGU);

	try
	{
		if (messageArea != null)
			messageArea.innerHTML = "";
	}
	catch (e) {}
}

function printErrorMessage(text, error, keepPrevious, keepConfirmation)
{
	var messageArea = document.getElementById(messageAreaGU);

	var imgSrc;

	if (!keepConfirmation)
	{
		// Se oculta el área de confirmación en caso de existir
		confirmation = document.getElementById(confAreaNameGU);
		if (confirmation != null)
		{
			confParent = confirmation.parentNode;
			if (confParent != null)
				confParent.removeChild(confirmation);
		}
	}

	// Si no se encuentran los elementos necesarios se repora como una alerta por compatibilidad hacia atra's
	if (messageArea == null)
		alert(text);
	else
	{
		// Se eliminan los mensajes anteriores en caso de haberse indicado asi'	
		if (!keepPrevious)
			messageArea.innerHTML = "";

		if (error)
			imgSrc = errorImgSrc;
		else
			imgSrc = warningImgSrc;

		var table = null;

		// Se consigue el TABLE
		for (var i in messageArea.childNodes)
		{
			if (messageArea.childNodes[i].nodeName == "TABLE")
			{
				table = messageArea.childNodes[i];
				break;
			}
		}

		if (table == null)
		{
			// No hay TABLE, se crea
			table = document.createElement('<TABLE CELLSPACING="2" CELLPADDING="0" WIDTH="100%" BORDER=0>');

			messageArea.appendChild(table);

			// Se agrega el cabezal
			var elem1 = table.insertRow();
			elem1.backgroundColor = "#9f2020";
			elem1 = elem1.insertCell();
			elem1.className = "TblHeader";
			elem1.colSpan = 2;
			var elem2 = document.createElement("<P CLASS='TblTitle'>");
			elem2.innerText = "Mensajes";
			elem1.appendChild(elem2);

			// Se agrega el pie
			elem1 = table.insertRow();
			elem1 = elem1.insertCell();
			elem1.style.backgroundColor = "#9f2020";
			elem1.colSpan = 2;
			elem1.style.height = "2px";
		}

		messageArea = table;

		var row = messageArea.insertRow(messageArea.childNodes.length);
		row.style.height = 19;
		var cell = row.insertCell();
		cell.align = "center";
		cell.vAlign = "center";
		cell.style.backgroundColor = "#DDDDDD";
		cell.style.width = 19;
		cell.appendChild(document.createElement("<IMG SRC=" + imgSrc + ">"));
		var cell = row.insertCell();
		cell.className = "MsgText";
		cell.style.backgroundColor = "#F3F3F3";
		cell.innerHTML = "&nbsp;" + text;
		messageArea.parentNode.style.display = "";
	}
}

function findGlobalThoSep(localThoSep)
{
	// Si no se inidico' separador de miles no se define
	if (localThoSep == '')
		return '';

	try
	{
		// Se puede haber cerrado el "opener", en caso de prompts de prompts
		return realTopGU.getThoSep();
	}
	catch (e) {}

	return localThoSep;
}

function findGlobalDecSep(localDecSep)
{
	// Si no se inidico' separador decimal no se define
	if (localDecSep == '')
		return '';

	try
	{
		// Se puede haber cerrado el "opener", en caso de prompts de prompts
		return realTopGU.getDecSep();
	}
	catch (e) {}

	return localDecSep;
}

/*********************
 * Manejo de grillas *
 *********************/

// Usada directamente desde paneles.
function grChkSel(gridId)
{
	if (document.forms[0][gridId + "_ROW"].value != '0')
	{
		removeErrors();
		return true;
	}
	else
	{
		printErrorMessage("No hay ninguna fila seleccionada", true, false, false);
		return false;
	}
}

// Usada directamente desde paneles.
function grGetSelElem(gridId, elemId, eval)
{
	var elem;
	var rowN = document.forms[0][gridId + "_ROW"].value;

	// Se pasa a 4 di'gitos
	if (rowN < 10)
		rowN = '000' + rowN;
	else
		rowN = '00' + rowN;

	elem = document.getElementById(elemId + '_' + rowN);

	// Si devuelve el valor si fue indicado
	return eval ? elem.value : elem;
}

// Manejador del evento "onchange" de una celda editable de una grilla.
function grCelCha(elem, varName)
{
	if (elem.oriValue != elem.value)
		document.getElementById(varName).value = 1;
}

// Manejador del evento "propertychange" de una celda editable de una grilla.
function grCelProCha(elem, varName)
{
	if (event.propertyName == "value")
		document.getElementById(varName).value = 1;
}

// Manejador de los eventos "onmousedown" y "onkeydown" de una celda editable de tipo "checkbox" de una grilla.
// Este manejador se asocia al SPAN contenedor.
function grCelCheCha(elem, varName)
{
	// Si esta' habilitado se marca como modificado una u'nica vez
	if (!elem.firstChild.disabled)
		document.getElementById(varName).value = 1;	
	
	elem.onkeydown = '';
	elem.onmousedown = '';
}

function grCelFoc(elem)
{
	if (elem.oriValue == null)
		elem.oriValue = elem.value;
}

function promptButtonActivateHander()
{
	event.srcElement.firstChild.src = "images/grayreturnbutton.gif";
}

function promptButtonDeactivateHander()
{
	event.srcElement.firstChild.src = "images/returnbutton.gif";
}

// Se utiliza este manejador para ejecutar el co'digo asociado al "onclick" en los botones de retorno de prompt cuando se presiona el ENTER
function promptReturnKeyDownHandler()
{
	if (event.keyCode == 13)
		event.srcElement.firstChild.click();

	return true;
}

// Manejador de activacio'n del formulario.
// El primer uso es: detectar posicionamientos en campos que pertenezcan a a'reas de filtrado
// de forma de modificar el comportamiento del ENTER asocia'ndolo al boto'n de filtrado.
// El segundo uso es: detectar posicionamiento en botones de retorno de "prompts" (dentro de grillas)
// de forma de modificar su aspecto para hacerlos notar.
function onactivateFormHandler()
{
	// En pantallas sin grillas no se hace esta validacio'n
	if (noGridsGU)
	{
		paintOriginalEnterButton();
		return;
	}

	var elem = event.srcElement;

	if ((elem.tagName == "A") && (elem.alredyVisited == null) && (elem.firstChild != null) && (elem.firstChild.tagName == "IMG"))
	{
		elem.alredyVisited = true;

		if (elem.firstChild.src.indexOf("returnbutton.gif") != -1)
		{
			// Se simula el "onclick" en caso de ser necesario al momento de presionar el ENTER
			if (elem.firstChild.onclick != null)
				elem.attachEvent("onkeydown", promptReturnKeyDownHandler);

			elem.firstChild.src = "images/grayreturnbutton.gif";
			elem.onactivate = promptButtonActivateHander;
			elem.ondeactivate = promptButtonDeactivateHander;
		}

		paintOriginalEnterButton();
		return;
	}

	if ((elem.tagName == "INPUT") || (elem.tagName == "SELECT"))
	{
		if (elem.insideFilter == "no")
			return;

		var filterButton;

		if (elem.insideFilter == "yes")
		{
			filterButton = elem.filterButton;
		}
		else
		{
			// Es la primera vez que se entra en este campo, se valida si es o no un campo de filtro de una grilla
			// y en caso de serlo se obtiene el boto'n de filtrado correspondiente
			var grid = elem.parentElement;
			while (grid != null)
			{
				if (grid.tagName == "TABLE")
				{
					if (grid.className == "Grid")
					{
						// Es un campo perteneciente a una columna
						filterButton = null;
						break;
					}
					else if (grid.id.substring(0, 7) == "HTMLTBL")
					{
						// Si se trata de la tabla de una dependencia se sigue buscando hacia la tabla superior
						if (grid.id.substring(7, 14) != "DEPAREA")
						{
							// Se llego' a la tabla padre de una grilla sin pasar por la grilla, por lo tanto
							// se esta' en un campo de un filtro
							filterButton = document.getElementById("BTNFILTER_" + grid.id.substring(7));

							if (filterButton != null)
							{
								// Verificacio'n por pa'ginas no generadas
								filterButton.insideFilter = "yes";
							}

							break;
						}
					}
				}

				grid = grid.parentElement;
			}

			if (elem.insideFitler == null)
			{
				// Se verifica si es un filtro de una grilla o no
				if (filterButton != null)
				{
					elem.filterButton = filterButton;
					elem.ondeactivate = filterDeactivateHandler;
					elem.insideFilter = "yes";
					
					if (filterButton.alredyVisited == null)
					{
						filterButton.alredyVisited = true;
						filterButton.firstChild.ondeactivate = filterButtonDeactivateHandler;
						filterButton.onactivate = filterButtonActivateHandler;
					}
				}
				else
				{
					elem.insideFilter = "no";
					paintOriginalEnterButton();
					return;
				}
			}
		}

		// Si se setea como activo solamente porque hubo un "blur" de validacio'n no se hace ningu'n cambio (ver "onkeydownHandler")
		if (elem.blurForValidate)
			return;

		// Se esta' dentro de un filtro:
		//     Si el boto'n de filtrado no esta' marcado como el poseedor del ENTER se marca, y adema's se quita
		//     el ENTER de cualquier otro boto'n que lo tuviese
		filterButton.activated = true;
		filterButton.isFilter = true;

		beginEnterState(filterButton);

		var removeActivationFlag = function()
		{
			filterButton.activated = false;
		}

		// De esta manera si se ejecuta un 'blur' en el medio no se despinta el boto'n
		setTimeout(removeActivationFlag, 1);
	}
}

function filterDeactivateHandler()
{
	// Si se hizo un "blur" solamente para validacio'n no se hace ningu'n cambio (ver "onkeydownHandler")
	if (event.srcElement.blurForValidate)
		return;

	var filterButton = event.srcElement.filterButton;

	if (filterButton.activated)
		return;

	endEnterState(filterButton);
}

function filterButtonDeactivateHandler()
{
	// Si se hizo un "blur" solamente para validacio'n no se hace ningu'n cambio (ver "onkeydownHandler")
	if (event.srcElement.blurForValidate)
		return;

	var filterButton = event.srcElement.parentElement;

	if (filterButton.activated)
		return;

	endEnterState(filterButton);
}

function filterButtonActivateHandler()
{
	// Si se hizo un "blur" solamente para validacio'n no se hace ningu'n cambio (ver "onkeydownHandler")
	if (event.srcElement.blurForValidate)
		return;

	var filterButton = event.srcElement.parentElement;
	filterButton.activated = true;

	beginEnterState(event.srcElement.parentElement);
	
	var removeActivationFlag = function()
	{
		filterButton.activated = false;
	}

	// De esta manera si se ejecuta un 'blur' en el medio no se despinta el boto'n
	setTimeout(removeActivationFlag, 1);	
}

function beginEnterState(button)
{
	removeOperationShortcuts(null, false);
	swapEnterState(enterCtrlElementGU, button);
}

function endEnterState(button)
{
	removeOperationShortcuts(null, false);
	var pageEnterButton = null;
	
	if (enterCtrlIdGU != null)
		pageEnterButton = document.getElementById(enterCtrlIdGU);

	swapEnterState(button, pageEnterButton);
}

function swapEnterState(source, target)
{
	if (source == target)
		return;

	if (source != null)
	{
		removeEnterStyle(source);

		if (source.shortcut != null)
		{
			source.shortcut.innerText = source.noEnterShortcutText;
			source.keyCode = source.noEnterKeyCode;
		}
	}
	
	if (target != null)
	{
		enterCtrlElementGU = target;
		setEnterStyle(target);

		if (target.shortcut != null)
		{
			target.noEnterShortcutText = target.shortcut.innerText;
			target.noEnterKeyCode = target.keyCode;
			target.shortcut.innerText = "Enter";
			target.keyCode = 13;
		}
	}
	else
		enterCtrlElementGU = null;
}

function setEnterStyle(button)
{
	button.firstChild.style.color = "white";
	button.parentNode.background = 'images/graybuttonmiddle.gif';

	if (!button.isFilter && (nOpsPerLineGU > 6))
	{
		button.parentNode.previousSibling.background = 'images/graybuttonleftsmall.gif';
		button.parentNode.nextSibling.background = 'images/graybuttonrightsmall.gif';
	}
	else
	{
		button.parentNode.previousSibling.background = 'images/graybuttonleft.gif';
		button.parentNode.nextSibling.background = 'images/graybuttonright.gif';
	}
}

function removeEnterStyle(button)
{
	button.firstChild.style.color = "rgb(96, 96, 96)";
	button.parentNode.background = 'images/buttonmiddle.gif';
	
	if (!button.isFilter && (nOpsPerLineGU > 6))
	{
		button.parentNode.previousSibling.background = 'images/buttonleftsmall.gif';
		button.parentNode.nextSibling.background = 'images/buttonrightsmall.gif';
	}
	else
	{
		button.parentNode.previousSibling.background = 'images/buttonleft.gif';
		button.parentNode.nextSibling.background = 'images/buttonright.gif';
	}
}

// Inicializa las grillas que tengan el comportamiento de mantener el estado.
// Se invoca siempre de forma de asociar el manejador del teclado a toda grilla, ma's alla' de que mantenga o no
// el estado entre pedidos.
// 'grids' -> [['name', 'gridname', pageSize, true o false (si tiene agregado de fila o no; en caso de ser null quiere decir que tiene agregado de fila pero condicionado, y esta vez no esta' el boto'n visible)], ...]
function initializeGrids(grids)
{
	if ((typeof(oneRecordAddGridsGU) != "undefined") && (oneRecordAddGridsGU != null))
	{
		var grid, tbody;

		editableGridsGU = new Array();

		for (var i = 0; i < grids.length; i++)
		{
			grid = document.getElementById(grids[i][1].toUpperCase());
			// Chequeo por visibilidad
			if (grid != null)
			{
				noGridsGU = false;

				// Se asocia el evento del teclado en el elemento TABLE ma's externo de forma que aún estando en un
				// campo de un filtro o una opercio'n de la grilla se pueda modificar la seleccio'n simple con las flechas
				id = "HTMLTBL" + grid.id.substring(4, grid.id.length);
				var outerGrid = document.getElementById(id);
				outerGrid.attachEvent("onkeydown", gridKeyDownHandler);
				outerGrid.onkeyup = keyUpHandler;
				outerGrid.innerGrid = grid;
				
				tbody = grid.children[0];
				// Se recuerda en la propia grilla la posicio'n del vector de filas base para ser clonadas cuando el usuario agregue una fila
				// desde el cliente
				grid.templatePos = i;
				grid.userName = grids[i][0];
				grid.serverName = grids[i][1];
				grid.pageSize = grids[i][2];
				grid.hasAddRow = grids[i][3];
				if (grid.hasAddRow || (grid.hasAddRow == null))
				{
					// En caso de ser null quiere decir que esta vez se oculto' el boto'n de agregado de fila porque estaba condicionado,
					// por lo tanto se oculta la fila extra y de ahora en ma's es como si no tuviera agregado de fila
					if (grid.hasAddRow == null)
						grid.hasAddRow = false;
					grid.originalRowsCount = tbody.children.length - 1;
					editableGridsGU[i] = tbody.children[tbody.children.length - 1];
					tbody.removeChild(tbody.children[tbody.children.length - 1]);
					document.getElementById(getGridSizeVar(grids[i][1])).value = tbody.children.length - 1;
				}
				
				grid.singleSelection = document.getElementById(grid.id + "_ROW") != null;
				if (grid.singleSelection)
					grid.tabIndex = 0;
			}
			else
			{
				// En caso de estar invisible se asigna 0 a la cantidad de filas para no tener en cuenta la fila agregada para ser clonada
				document.getElementById(getGridSizeVar(grids[i][1])).value = 0;
			}
		}
	}

	var gridElements = document.getElementsByTagName("table");
	for (var i = 0; i < gridElements.length; i++)
	{
		if (gridElements[i].className == "Grid")
		{
			// Se almacena una referencia a la primer grilla de forma de poder setearle el foco en caso de no encontrar otro elemento para hacerlo
			if (firstGridGU == null)
				firstGridGU = gridElements[i];

			if (typeof(gridElements[i].templatePos) == "undefined")
			{
				var grid = gridElements[i];
				id = "HTMLTBL" + grid.id.substring(4, grid.id.length);
				var outerGrid = document.getElementById(id);
				if (outerGrid != null)
				{
					noGridsGU = false;
				
					outerGrid.innerGrid = grid;
					outerGrid.attachEvent("onkeydown", gridKeyDownHandler);
					outerGrid.onkeyup = keyUpHandler;

					grid.singleSelection = document.getElementById(grid.id + "_ROW") != null;
					if (grid.singleSelection)
						grid.tabIndex = 0;
				}
			}
		}
	}
}

function findPromptReturn(grid, index)
{
	// La primer vez se verifica si la grilla tiene retorno
	
	var cells = grid.rows[index + 1].cells; // cabezales

	// Se recorren los hijos de la u'ltima celda de la primer fila ya que los retornos siempre van a estar al final
	var elems = cells[cells.length - 1].childNodes;
	
	for (var i = 0; i < elems.length; i++)
	{
		if (elems[i].tagName == "A")
		{
			var e = elems[i];
			
			if ((e.firstChild != null) && (e.firstChild.tagName == "IMG") && (e.firstChild.src.indexOf("returnbutton.gif") != -1))
				return e;
		}
	}
	
	return null;
}

function gridKeyDownHandler(e)
{
    var element, grid, tr, i;
    
    if ((typeof(e) == "undefined") || (e == null))
        e = window.event;

    element = e.srcElement;
    
    // Se encuentra la tabla
    grid = element;
    while ((grid != null) && ((grid.tagName != "TABLE") || ((grid.singleSelection == null) && (grid.innerGrid == null))))
    {
		// Se almacena la fila
		if (grid.tagName == "TR")
			tr = grid;

        grid = grid.parentElement;
    }

	// Se indica que no estaba dentro de una grilla, los campos num'ericos pueden ser filtros o no, con esto se evita
	// intentar invocar este manejador ma's de una vez sobre un campo que no sea un filtro
	if (grid == null)
		return "outsideGrid";

	// En caso que no se este' efectivamente dentro de la grilla, es decir, si se esta' en una operacio'n o un filtro de la misma,
	// en ENTER se maneja por el evento de la pag'na de forma de evitar el agregado de fila o avance de fila en la grilla
	var bubbleEnter = false;

	if (grid.innerGrid != null)
	{
		bubbleEnter = true;
		grid = grid.innerGrid;
	}

	if ((e.srcElement.tagName != "SELECT") && ((e.keyCode == 40) || (e.keyCode == 38)))
	{
		if (grid.singleSelection)
		{
			var lastRow = document.getElementById(grid.id + "_ROW").value;
			if ((lastRow == "") || (lastRow == "0"))
			{
				if (e.keyCode == 40)
					lastRow = 1;
				else
					lastRow = grid.rows.length - 1;
			}
			else
			{
				if (e.keyCode == 40)
					lastRow++;
				else
					lastRow--;
			}

			if ((lastRow > 0) && (lastRow < grid.rows.length))
			{
				markrow("#adbeda", grid.id, grid.id + "_ROW", lastRow);
			}

			// En caso que se este' posicionado dentro de un campo de filtrado se setea el foco en la grilla de forma de recuperar
			// el boto'n con ENTER original
			if ((enterCtrlElementGU != null) && (enterCtrlElementGU.id.indexOf("BTNFILTER_") != -1))
			{
				grid.focus();
			}

			e.cancelBubble = true;
			return false;
		}
		else
		{
			// En caso que no tenga seleccio'n simple se utilizan las flechas para moverse entre botones de retorno (siempre y cuando hayan)
			if (grid.hasPromptReturn == null)
			{
				// La primer vez se verifica si la grilla tiene retorno
				
				var rows = grid.rows;
				
				if (rows.length > 1)
				{
					var cells;
						
					cells = rows[1].cells; // cabezales

					if (cells.length > 0)
					{
						// Se recorren los hijos de la u'ltima celda de la primer fila ya que los retornos siempre van a estar al final
						var elems = cells[cells.length - 1].childNodes;
						
						for (var i = 0; i < elems.length; i++)
						{
							if (elems[i].tagName == "A")
							{
								var el = elems[i];
								
								if ((el.firstChild != null) && (el.firstChild.tagName == "IMG") && (el.firstChild.src.indexOf("returnbutton.gif") != -1))
								{
									// Se encontro' la celda con el retorno de "prompt"
									grid.hasPromptReturn = true;

									// Se alamcena un vector con referencias a los botones concretos para no volver a calcularlos cada vez
									grid.promptReturns = new Array(rows.length - 1); // cabezales

									break;
								}
							}
						}
					}
				}
			}

			if (grid.hasPromptReturn)
			{
				// En caso de tener se mueve el boto'n re retorno seleccionado

				// Se verifica si se esta' parado en un boto'n de retorno
				var el = document.activeElement;
				var index;
				
				if ((el != null) && (el.firstChild != null) && (el.firstChild.tagName == "IMG") && (el.firstChild.src.indexOf("returnbutton.gif") != -1))
				{
					if (el.promptReturnCacheIndex != null)
					{
						index = el.promptReturnCacheIndex + (e.keyCode == 40 ? +1 : -1);
					}
					else
					{
						var tr = el.parentNode.parentNode;
						
						for (var i = 0; i < grid.rows.length; i++)
						{
							if (tr == grid.rows[i])
							{
								el.promptReturnCacheIndex = i - 1;
								grid.promptReturns[i - 1] = el;
								index = e.keyCode == 38 ? i - 2 : i;

								break;
							}
						}
					}
				}
				else
				{
					index = e.keyCode == 40 ? 0 : grid.promptReturns.length - 1;
				}

				if ((index >= 0) && (index < grid.promptReturns.length))
				{
					// Si au'n no se habi'a llegado a este boto'n se busca y se agrega al cache
					if (grid.promptReturns[index] == null)
						grid.promptReturns[index] = findPromptReturn(grid, index);

					grid.promptReturns[index].focus();
				}
			}
		}
	}

    // Si no se encontro' la tabla, o la misma no tiene la funcionalidad de agregado de filas habilitada se procede con un manejo normal
    // Solamente interesa la tecla ENTER en este manejador, por lo tanto no se hara' nada si no se trata de e'sta
    if (((e.keyCode != 13) && (e.keyCode != 116)) || (grid == null) || (grid.templatePos == null) || bubbleEnter)
    {
        e.cancelBubble = true;
	    return keyDownHandler(e);
    }

	if (e.keyCode == 116)
	{
		var active = document.activeElement;
		if ((active != null) && (active.tagName == "INPUT"))
		{
		    active.blur();

    		// Se vuelve a setear como elemento activo para poder
		    // mantener el foco entre pedidos
		    active.setActive();
		}

		e.cancelBubble = true;
		
		return keyDownHandler(e);
	}
	
	if (!removeOperationShortcuts(e.keyCode, false))
	{
		if ((element.tagName == "INPUT") || (element.tagName == "SELECT"))
		{
			// Se intenta pasar el foco a la li'nea de abajo o agregar una nueva li'nea en caso que esa posibilidad exista

			var pos = 0;
			var rows = grid.children[0].children;
	        
			for (i = 0; i < rows.length; i++)
			{
				if (rows[i] == tr)
				{
					pos = i;
					break;
				}
			}
	        
			if (pos == rows.length - 1)
			{
				if (grid.hasAddRow)
					grGenericAddRecord(grid.serverName, false);
				else
				{
					// Se avanza de página si es eso posible
					var nPageSpan = document.getElementById("BTNGRIDNEXTPAGE_" + grid.userName.toUpperCase());

					if (nPageSpan != null)
					{
						if ((nPageSpan.children.length > 0) && (nPageSpan.children[0].tagName == "A"))
						{
							// Se define la tabla como elemento activo indicando que se debe focalizar en su primer registro, ya que
							// simplemente se esta' pasando de pa'gina
							document.activeElementExtraInfo = "firstRecord";

							grid.setActive();

							if(preClick(null))
							{
								GX_setevent("EBTNGRIDNEXTPAGE_" + grid.userName.toUpperCase() + ".CLICK.");
								self.document.forms[0].submit();
							}
						}
					}
				}
			}
			else
			{
				tr = rows[pos + 1];
				focusOnFirstEditableCell(tr);
			}
		}
		else
		{
			if (grid.hasAddRow)
				grGenericAddRecord(grid.serverName, false);
		}
	}
	
    e.cancelBubble = true;
    
    return false;
}

function focusOnFirstEditableCell(tr)
{
    var tds = tr.children;
    var input;
    for (var i = 0; i < tds.length; i++)
    {
        // Se busca un INPUT editable
        for (var j = 0; j < tds[i].children.length; j++)
        {
            input = tds[i].children[j];
            if (((input.tagName == "INPUT") || (input.tagName == "SELECT")) && (input.type != "hidden") && !input.disabled)
            {
			    if (input.tagName == "INPUT")
				    input.select();
    				
			    input.focus();
                
                return input;
            }
            else if (input.tagName == "TABLE")
            {
                // Caso de tipos de datos fecha que tienen una tabla por el "Calendar"
                for (var k = 0; k < input.rows.length; k++)
                {
                    var inner = focusOnFirstEditableCell(input.rows[k]);
                    if (inner != null)
                        return inner;
                }
            }
        }
    }

    return null;
}

function getGridSizeVar(gridIdRealCase)
{
    return "nRC_" + gridIdRealCase.charAt(0).toUpperCase() + gridIdRealCase.substring(1, gridIdRealCase.length);
}

// Agrega un registro a la grilla indicada a nivel del cliente. En caso de llegar al taman~o de la pa'gina se devuelve true
// de forma de ir al servidor y se hagan las modificaciones correspondientes.
// Esta funcio'n es utilizada desde JSEvent.
function grAddRec(gridIdRealCase)
{
    // Se utiliza una ma's general que considera al caso de la invocacio'n desde el JSEvent y desde co'digo directo
    // por el ENTER sobre una grilla
    return grGenericAddRecord(gridIdRealCase, true);
}

function grGenericAddRecord(gridIdRealCase, fromJSEvent)
{
    var tr, tbody, grid = document.getElementById(gridIdRealCase.toUpperCase());
    
    removeOperationShortcuts(null, false);
    
    if (grid != null)
    {
        tbody = grid.children[0];

        if (tbody.children.length == 1)
        {
            // Si no habi'a registros se elimina la notificacio'n de grilla vaci'a
            var advice = document.getElementById("TXTADVICE_" + grid.userName.toUpperCase());
            if (advice != null)
                advice.parentNode.removeChild(advice);
        }
        
        // Hay una fila que corresponde al ti'tulo
        if (tbody.children.length > grid.pageSize)
        {
            if (fromJSEvent)
            {
                // Se modifica el nu'mero de pa'gina indicando que se presion'o el boto'n y se debe ir al final
                document.getElementById("_ZG1_GR_" + grid.userName.toUpperCase() + "_CURRPAGE").value = -2;
                
                // Se define la tabla como elemento activo indicando que se debe focalizar en su u'litmo registro, ya que
                // se esta' agregando uno nuevo, y e'ste simpre va a ser el u'litmo
                document.activeElementExtraInfo = "lastRecord";
                grid.setActive();
                
                return preClick(null);
            }

            // Se define la tabla como elemento activo indicando que se debe focalizar en su primer registro, ya que
            // simplemente se esta' pasando de pa'gina
            document.activeElementExtraInfo = "firstRecord";
            grid.setActive();

            if (preClick(null))
            {
                // Se simula el presionado del boto'n de agregado de fila
                GX_setevent("EBTNADDPAGEORROW" + grid.userName.toUpperCase() +  ".CLICK.");
                document.forms[0].submit();
            }
            
            return;
        }

        document.getElementById(getGridSizeVar(gridIdRealCase)).value = tbody.children.length;

        tr = editableGridsGU[eval(grid.templatePos)].cloneNode(true);

        if ((tbody.children.length % 2) == 0)
            tr.className = "GridEven";
        else
            tr.className = "GridOdd";

        // Se actualizan los identificadores y nombres de todos los inputs de la fila creada
        adaptRow(grid.originalRowsCount, tr, tbody.children.length, editableGridsGU[eval(grid.templatePos)]);

        // Se agrega luego de modificar los identificadores de los INPUT's para evitar errores cuando se referencien
        tbody.appendChild(tr);

        modifyBehavior(tr, editableGridsGU[eval(grid.templatePos)]);
        
        focusOnFirstEditableCell(tr);
    }
    
    return false;
}

// Devuelve un INPUT como para posicionar el foco dentro de la table
// 'extraInfo' -> "lastRecord" para indicar que se posicione en el u'ltimo registro, y "firstRecord" (o cualquier otro valor) para 
// indicar que se posicione en el primero
function grGetInputForFocusing(table, extraInfo)
{
    var tbody = table.children[0];
    var l = tbody.children.length;
    var tr;

    // Siempre hay una fila con los cabezales
    if (l <= 1)
        return null;

    if (extraInfo == "lastRecord")
        tr = tbody.children[l - 1];
    else
        tr = tbody.children[1];

    return focusOnFirstEditableCell(tr);
}

function replaceAll(str, from, to)
{
    if (from == to)
        return str;

    var i = str.indexOf(from);

    while (i > -1)
    {
        str = str.replace(from, to);
        i = str.indexOf(from);
    }

    return str;
}

// Realiza todas las transformaciones necesarias para que la nueva fila se comporta como si se hubiese
// agregado desde el servidor.
// Se necesita la fila original porque el co'digo javascript de los elementos SCRIPTS dentro de la fila copiada
// no esta'.
function adaptRow(originalRowCount, tr, pos, originalRow)
{
    var posfix = to4Digits(pos);
    var cells = tr.children;
    var originalCells = originalRow.children;

	// En caso que la fila tenga los eventos 'onmouseleave', 'onmouseover' y 'onclick' (seleccio'n simple) se actualiza el
	// i'ndice para que se marque la fila correcta
	if ((tr.onclick != null) && (tr.onmouseleave != null) && (tr.onmouseover != null))
	{
		var toReplace = originalRowCount + ')';
		var replacement = pos + ')';
		for (var i = 0; i < 3; i++)
		{
			var text, eventName;
			
			if (i == 0)
			{
				text = tr.onclick.toString();
				eventName = "onclick";
				tr.onclick = null;
			}
			else if (i == 1)
			{
				text = tr.onmouseleave.toString();
				eventName = "onmouseleave";
				tr.onmouseleave = null;
			}
			else if (i == 2)
			{
				text = tr.onmouseover.toString();
				eventName = "onmouseover";
				tr.onmouseover = null;
			}

			var ini = text.indexOf('{');
			if (ini <= -1)
				break;

			var end = text.lastIndexOf('}');
			if (end <= -1)
				break;

			tr.attachEvent(eventName, new Function(replaceAll(text.substring(ini + 1, end - 1), toReplace, replacement)));
		}
	}

    for (var i = 0; i < cells.length; i++)
    {
        var replacePosfix, col, originalCol;
        var prompt = false;
        var doBreak = false;

        col = cells[i].children;
        originalCol = originalCells[i].children;

		// Obs: las columnas ocultas (INPUT) que aparecen dircetamente como hijos de la fila (TR): <INPUT ...><INPUT ...>...
		// son todos hijos de un elemento ficticio que tiene tagName == "" y que si' es hijo directo del TR

        for (var j = 0; j < col.length; j++)
        {
            var child = col[j];

            if (child.tagName == "SPAN")
            {
                // Caso de "checkboxes"
                if (child.children.length > 0)
                    child = child.children[0];
                else
                    continue;
            }

            if (child.tagName == "TABLE")
            {
				var script = null;

				// Un campo de tipo fecha

				// Se eliminan los "scripts" y "links"
				var l = 0;
				
				for (var k = 0; k < col.length; l++)
				{
					if ((col[k].tagName == "SCRIPT") || (col[k].tagName == "LINK"))
						col[k].parentNode.removeChild(col[k]);
					else
						k++;

					// El u'ltimo script es el que contiene el codigo a modificar (tiene la inicializacio'n del "Calendar"
					// y la declaracio'n de la funcio'n de seleccio'n
					if (originalCol[l].tagName == "SCRIPT")
						script = originalCol[l];
				}

				// Se modifica la imagen que dispara el cuadro de fechas ("trigger" con identificador particular por fila)
				image = child.firstChild.firstChild.children[1].firstChild;

				// Se avanza al INPUT de forma que al final de este bucle se realicen las modificaciones necesarias para 
				// el mismo (clonado con cambio de identificador)
				// <table><tbody><tr><td><input ...
				child = child.firstChild.firstChild.firstChild.firstChild;
				replacePosfix = child.id.substring(child.id.length - 5, child.id.length);

				var html = image.outerHTML;
				html = replaceAll(html, replacePosfix, '_' + posfix);
				image.swapNode(document.createElement(html));

				if (script != null)
				{
					// El co'digo generado tiene la estructura:
					// document.write("<link ...>");      // Esto se elimina completamente
					// Calendar.setup(...);               // Inicializador del "Calendar"
					// function dateChanged__DD_000X ...
					var code = script.innerHTML;
					// Se elimina el co'digo que escribe la referencia el estilo de las fechas (document.write no puede ser ejecutado luego
					// que se cargo' el documento)
					code = code.substring(code.indexOf(';') + 1, code.length);
					code = replaceAll(code, replacePosfix, '_' + posfix);
					
					var auxContextFunction = function(c)
					{
						var auxFunction = function()
						{
							eval(c);
						}
						
						// Se evalu'a despue's porque se necesita que el INPUT pertenezca al documento al momento de inicializar el "Calendar"
						setTimeout(auxFunction, 1);
					}
					
					// Se utiliza esta funcio'n para dar contexto ya que si hay ma's de una columna de tipo fecha, la variable "code" se redefine
					auxContextFunction(code);
				}

				// Se sigue procesando para modificar el INPUT, pero toda esta celda ya fue procesada, por lo tanto 
				// se debe continuar con el bucle externo
				doBreak = true;
            }

            if (prompt && (child.tagName == "A"))
            {
                // Se corrigen las variables de la invocacio'n al "prompt"
                child.href = replaceAll(child.href, replacePosfix, '_' + posfix);
                prompt = false;
                continue;
            }

            if ((child.tagName == "INPUT") || (child.tagName == "SELECT"))
            {
                if (child.id.substring(0, 14) == "_ZG1_PROMPTCOL")
                {
                    // Se marca el caso de "prompt"
                    prompt = true;
                    replacePosfix = child.id.substring(child.id.length - 5, child.id.length);
                }

                // Se crea otro elemento con el identificador y el nombre modificados porque no se puede cambiar el nombre por co'digo
				var auxName, name;
				
				auxName = name = child.name;
				name = name.substring(0, name.length - 4) + posfix;
			    
				var html = child.outerHTML;
				html = replaceAll(html, auxName, name);

				var toAddInput;
				
				// Los SELECTS contienen elementos hijos, por lo tango no se pueden crear directamente
				if (child.tagName != "SELECT")
				{
					toAddInput = document.createElement(html);
				}
				else
				{
					var html = html.substring(0, html.indexOf('>') + 1);
					toAddInput = document.createElement(html);
					for (var k = 0; k < child.childNodes.length; k++)
					{
						var option = child.childNodes[k];
						if (option.tagName == "OPTION")
							toAddInput.appendChild(option.cloneNode(true));
					}
				}

				// Se intercambian para no alterar el orden en que se esta'n recorriendo los elementos, 
				// Esto es necesario, por ejemplo, en el caso relativo a la observacio'n de ma's arriba
				child.swapNode(toAddInput);
            }
            
			if (doBreak)
				break;
        }
    }
}

function modifyBehavior(tr, baseTr)
{
    var cells = tr.children;
    var cellsBase = baseTr.children;
    var colBase, col, i, j, name, input, baseInput;
    
    for (var i = 0; i < cells.length; i++)
    {
        col = cells[i].children;
        colBase = cellsBase[i].children;
        for (j = 0; j < col.length; j++)
        {
            input = col[j];
            baseInput = colBase[j];

            if ((input.tagName == "INPUT") || (input.tagName == "SELECT"))
                if ((typeof(baseInput.behavior) != "undefined") && (baseInput.behavior != null))
                    baseInput.behavior.cloneBehavior(input);
        }
    }
}

// Se usa desde tambie'n "promptgridsel"
function to4Digits(digit)
{
	if (digit < 10)
		return '000' + digit;
	else if (digit < 100)
		return '00' + digit;
	else
	    return '0' + digit;
}

/**********************
 * Manejo del teclado *
 **********************/

var enterCtrlIdGU = null;
var enterCtrlElementGU = null;
// -1 -> 'prompt', 0 -> página común, 1 -> "processIndex", 2 -> "index"
// En el caso de las páginas comunes se tendrá en cuenta que pueden estar fuera del contenedor de manera de no realzar bloqueos
var ownerLevelGU;
var avoidMarkBecouseFocusInsideFilterGU = false;

function attachOnKeyDown(controlId, ownerLevel)
{
	// Los objetos viejos veni'an con el string "null" en lugar del valor null
	enterCtrlIdGU = controlId == "null" ? null : controlId;
	ownerLevelGU = ownerLevel;

	// Se modifica el color de fondo del boto'n
	var control = document.getElementById(controlId);
	if (control != null)
	{
		if (control.className == 'BtnText')
		{
			// Se marca que se evito' pintar el boto'n de gris porque se estaba en un a'rea de filtrado
			avoidMarkBecouseFocusInsideFilterGU = true;
		}
	}

	document.body.onkeydown = keyDownHandler;
	document.body.onkeyup = keyUpHandler;
}

function paintOriginalEnterButton()
{
	if (avoidMarkBecouseFocusInsideFilterGU)
	{
		avoidMarkBecouseFocusInsideFilter = false;

		var control = document.getElementById(enterCtrlIdGU);
		enterCtrlElementGU = control;

		// Esta' habilitado
		setEnterStyle(control);
	}
}

var shortcutsGU = false;
var opsGU = null;
var shKeysGU = null;
var uppedGU = false;
var placeShortcutsOnUpGU = false;

function placeOperationShortcuts()
{
	// HLogin no tiene "top" y queda mal posicionado el ENTER
	if (typeof(realTopGU.offsetTop) == "undefined")
		return;
		
	if (shortcutsGU)
		return;

	var i;

	shortcutsGU = true;
	if (opsGU == null)
	{
		// Se consiguen todas las operaciones habilitadas
		var aux = document.getElementsByTagName("SPAN");
		opsGU = new Array();
		shKeysGU = new Array();

		var freeCodes = new Array();

		// Se reservan los siguientes caracteres
		// 67 'c', 78 'n', 80 'p', 86 'v', 88 'x', 89 'y', 90 'z'

		for (i = 65; i <= 66; i++)
			freeCodes.push(i);

		for (i = 68; i <= 77; i++)
			freeCodes.push(i);

		freeCodes.push(79);
		
		for (i = 81; i <= 85; i++)
			freeCodes.push(i);
			
		freeCodes.push(87);
		
		for (i = 48; i <= 57; i++)
			freeCodes.push(i);

		for (i = 0; i < aux.length; i++)
		{
			if ((aux[i].className == "BtnText") && (aux[i].firstChild.tagName == "A"))
			{
				var op = aux[i];
				
				var c, code;

				code = getShortcutKey(op.firstChild.firstChild.nodeValue.toUpperCase(), freeCodes);
				c = String.fromCharCode(code);
				
				if (aux[i] == enterCtrlElementGU)
				{
					// En caso que sea la operacio'n con ENTER se recuerda el "shortcut" original por si el ENTER pasa
					// a algu'n boto'n de filtro temporalmente
					op.noEnterShortcutText = c;
					op.noEnterShortcutKeyCode = code;
					
					code = 13;
					c = "Enter";
				}

				if (code != null)
				{
					var sh = document.createElement("<DIV CLASS='Shortcut'>");
					sh.innerText = c;
					document.body.appendChild(sh);
					sh.style.position = "absolute";
					sh.style.top = (realTopGU.offsetTop(op.parentNode) - 6) + "px";
					sh.style.left = (realTopGU.offsetLeft(op.parentNode) - 4) + "px";
					op.shortcut = sh;
					opsGU.push(op);
					op.keyCode = code;
				}
			}
		}
	}
	
	for (i = 0; i < opsGU.length; i++)
	{
		var op = opsGU[i];
		
		op.shortcut.style.top = (realTopGU.offsetTop(op.parentNode) - 6) + "px";
		op.shortcut.style.left = (realTopGU.offsetLeft(op.parentNode) - 4) + "px";
		opsGU[i].shortcut.className = 'Shortcut';
		opsGU[i].shortcut.style.display = '';
	}
}

function manageOperationKey(keyCode)
{
	if (opsGU == null)
		return null;

	for (var i = 0; i < opsGU.length; i++)
	{
		var op = opsGU[i];
		
		if ((op.keyCode != null) && (op.keyCode == keyCode))
		{
			highlightShortcut(op);
				
			opsGU.splice(i, 1);

			var url = String(op.firstChild.href.substring(11));
			url = unescape(url);
			var toEval = function()
			{
				eval(url);
			}
			setTimeout(toEval, 1);

			// Se quitan los accessos directos en caso de existir
			setTimeout("removeOperationShortcuts(null, true)", 500);
			
			return op;
		}
	}
	return null;
}

function highlightShortcut(op)
{
	if ((op.shortcut != null) && (op.shortcut.style.display != "none"))
	{
		op.shortcut.className = 'HighlightedShortcut'
		op.shortcut.style.top = (realTopGU.offsetTop(op.parentNode) - 5) + "px";
		op.shortcut.style.left = (realTopGU.offsetLeft(op.parentNode) - 3) + "px";
	}
}

function getShortcutKey(text, freeCodes)
{
	var found;
	
	for (var i = 0; i < text.length; i++)
	{
		found = false;
		var c = text.charAt(i);
		var code = c.charCodeAt(0);
		
		if (((code >= 48) && (code <= 57)) || ((code >= 65) && (code <= 90)))
		{
			for (var j = 0; j < freeCodes.length; j++)
			{
				if (code == freeCodes[j])
				{
					found = true;
					freeCodes.splice(j, 1);
					break;
				} 
			}

			if (found)
			{
				shKeysGU.push(code);
				return code;
			}
		}
	}

	// Se intenta conseugir un caracter cualquiera no utilizado
	if (freeCodes.length > 0)
	{
		var res = freeCodes[0];
		
		freeCodes.splice(0, 1);
		
		shKeysGU.push(res);
		return res;
	}

	return null;
}

function removeOperationShortcuts(keyCode, forced)
{
	var pressedOp = null;

	if (!shortcutsGU && !forced)
		return false;

	if (keyCode != null)
		pressedOp = manageOperationKey(keyCode);

	shortcutsGU = false;

	if (opsGU != null)
	{
		for (var i = 0; i < opsGU.length; i++)
		{
			var op = opsGU[i];

			if (op.shortcut != null)
				op.shortcut.style.display = "none";
		}
	}
	
	if (pressedOp != null)
	{
		opsGU.push(pressedOp);
		return true;
	}
		
	return false;
}

function evalURL()
{
	eval(urlGU);
}

function keyUpHandler()
{
	if (event.keyCode == 17 && !event.altKey)
	{
		if (placeShortcutsOnUpGU) {
			placeOperationShortcuts();
			placeShortcutsOnUpGU = false;
			uppedGU = true;
		}
	}
}

var promptButtonsGU = null;
var promptButtonsParentTablesGU = null;

// Si esta' posicionado en un campo se busca si hay un 'prompt' asociado para abrirlo (respuesta a tecla F4)
function openPromptIfPosible()
{
	var elem = event.srcElement;
	
	if ((elem.promptButton == "no") || ((elem.tagName != "INPUT") && (elem.tagName != "SELECT")))
		return;

	if (elem.promptButton == null)
	{
		// Es la primera vez que se presiona F4 en el campo, se verifica si existe un "prompt" asociado o no
		
		var table = findParentByTagName(elem, "TABLE");
		if (table == null)
			elem.promptButton = "no";

		var brakeOnFirst = false;
		
		if (table.className == "Grid")
		{
			// Si se esta' dentro de una grilla se evita que se recorran todos los "prompts" (abajo) ya que
			// eso se hace para "prompt" del directos del formulario en pa'ginas no generadas
			brakeOnFirst = true;

			// Si se detecta que se esta' dentro de una grilla se utiliza la fila ya que el "prompt" es por fila
			table = findParentByTagName(elem, "TR");
			
			if (table == null)
				elem.promptButton = "no";
		}

		// Se inicializan los vectores que cachean los "prompts" y sus tablas padres
		if (promptButtonsGU == null)
		{
			var imgs = document.getElementsByTagName("IMG");
			promptButtonsGU = new Array();
			promptButtonsParentTablesGU = new Array();
			
			for (var i = 0; i < imgs.length; i++)
			{
				if (imgs[i].src.indexOf("promptbutton.gif") != -1)
				{
					var t = findParentByTagName(imgs[i], "TABLE");
					if (t != null)
					{
						if (t.className == "Grid")
							t = findParentByTagName(imgs[i], "TR");

						if (t != null)
						{
							// Se almacena el objeto A que contiene el "href"
							promptButtonsGU.push(imgs[i].parentNode);
							promptButtonsParentTablesGU.push(t);
						}
					}
				}
			}
		}

		var elemTd = null;
		var promptTd = null;

		// Se busca el "prompt" particular
		for (var i = 0; i < promptButtonsParentTablesGU.length; i++)
		{
			if (promptButtonsParentTablesGU[i] == table)
			{
				// Si hay ma's de un "prompt" con la misma tabla padre se elije el que este' en la misma celda (TD) que el campo
				// Este control se realiza porque hay pantallas no generadas que no definen una tabla alrededor del campo o dependencia
				// con "prompt"
				if (elem.promptButton == null)
				{
					elem.promptButton = promptButtonsGU[i];

					// Si se esta' dentro de una grilla no se sigue buscando
					if (brakeOnFirst)
						break;
				}
				else
				{
					// Si se habi'a encontrado otro se busca la celda
					if (elemTd == null)
						elemTd = findParentByTagName(elem, "TD");
					
					promptTd = findParentByTagName(elem.promptButton, "TD");
					if (elemTd == promptTd) // Si efectivamente esta'n en la misma celda se corta el ciclo
						break;

					// Se verifica si el otro boto'n esta' en la misma celda
					promptTd = findParentByTagName(promptButtonsGU[i], "TD");
					if (elemTd == promptTd)
					{
						elem.promptButton = promptButtonsGU[i];
						break;
					}
					
					// En caso que ninguno de los dos est'e en la misma celda se sigue recorriendo
				}
			}
		}

		// Se marca para no volver a buscar
		if (elem.promptButton == null)
			elem.promptButton = "no";
	}

	if (elem.promptButton != "no")
	{
		// Se abre el "prompt"
		var url = elem.promptButton.href.substring(11);
		url = unescape(url);
		eval(url);
	}
}

function findParentByTagName(element, tagName)
{
	var parent = element.parentNode;
	
	while ((parent != null) && (parent.tagName != tagName))
		parent = parent.parentNode;
	
	return parent;
}

function keyDownHandler(e)
{
	if ((typeof(e) == "undefined") || (e == null))
		e = window.event;
	//alert(e.keyCode);
	if (e.altKey)					
	{
		if (e.keyCode == 67){
			top._Calculator.openCalc();
			return false;
		}
	}
	
	try
	{
		if ((typeof(form_onkeypress) != "undefined") && (form_onkeypress != null))
			form_onkeypress(e, false);

		if (ownerLevelGU == 0)
		{
			if (activeObject != null)
			{
				if ((activeObject.tagName != 'BODY') && (activeObject.tagName != 'TEXTAREA'))
				{
					// Si el objeto activo es un campo de un filtro se evita sacar el ENTER del boto'n de filtrado (esto permite
					// el correcto funcionamiento de los accesos directos, en caso contrario si bien el ENTER funciona, no se "presiona"
					// el acceso directo)
					activeObject.blurForValidate = true;
					// Se fuerza un blur para que se hagan las validaciones
					activeObject.blur();

					// Se vuelve a setear como elemento activo para poder
					// mantener el foco entre pedidos
					activeObject.setActive();
					activeObject.blurForValidate = false;
				}
				
				activeObject = null;
			}
		}

		// En caso de ser un ENTER se controla que el valor de retorno definido en "setevent.js" sea false, lo cual indica que
		// el foco no esta' en un elemento que responda ante el ENTER por si mismo, con la salvedad de que dicho elemento no tenga
		// texto definido, lo cual quiere decir que es un "textblock" oculto utilizado para el manejo de eventos o bien de refrescado
		// o bien de cambio de una lista de valores
		if (!shortcutsGU && (enterCtrlElementGU != null) && (e.keyCode == 13) &&
			((!e.returnValue && (e.returnValue != null)) ||
				((document.activeElement.tagName == "A") && 
				 (document.activeElement.innerText == "") && 
				 !((document.activeElement.firstChild != null) && (document.activeElement.firstChild.tagName == "IMG"))))) // botones de retorno de "prompts"
		{
			if (enterCtrlElementGU != null)
			{
				if (enterCtrlElementGU.childNodes[0] != null)
				{
					if (enterCtrlElementGU.childNodes[0].nodeType == 1)
					{
						var url = String(enterCtrlElementGU.childNodes[0].getAttribute('href'));
						if (url != null)
						{
							urlGU = unescape(url);
							// Se utiliza un timer para lograr que se corrijan los valores de tipo fecha, ya que si no 
							// se reportará un error al volver del servidor
							timerGU = setTimeout("evalURL()", 1);

							e.keyCode = 7;
							return false;
						}
					}
				}
			}
		}
		else
		{
			if (e.keyCode == 17 && !e.altKey)
			{
				if (!shortcutsGU)
				{
					// En caso de presionar el Ctrl se hacen visibles los accesos directos de todas las operaciones
					placeShortcutsOnUpGU = true;
					uppedGU = false;
				}
				else
				{
					if (uppedGU)
						removeOperationShortcuts(null, false);
				}
			}

			if (shortcutsGU)
			{
				// Se ajusta el co'digo por el "keypad"
				if ((e.keyCode >= 96) && (e.keyCode <= 105))
					e.keyCode -= 48;

				if (!e.altKey && ((e.keyCode == 13) || ((e.keyCode >= 48) && (e.keyCode <= 57)) || ((e.keyCode >= 65) && (e.keyCode <= 90))))
				{
	 				// A = 60, Z = 90
					// Es una letra, se verifica si no es al acceso directo de alguna operacio'n
					if (removeOperationShortcuts(e.keyCode, false))
					{
						var act = document.activeElement;
						
						if (act != null)
						{
							// Se ejecutan los eventos "onchange" en caso que se este' posicionado en una grilla editable
							act.blur();
							act.focus();
						}
						// Se bloquea el ctrl + F (70) y el ctrl + O (79)
						// Primero se debe cancelar el "bubble" y se definir el valor de retorno, porque al modificar el "keyCode"
						// si se esta' en un INPUT de tipo "file" se genera una excepcio'n de acceso denegado y se procesa la tecla como
						// si nunca se hubiese pasado por aqui' modificando el contenido del INPUT
						e.cancelBubble = true;
						e.returnValue = false;
						e.keyCode = 7;
						return false;
					}
				}
			}

			if (e.keyCode == 27)
			{
				// Esc, se retiran los accesos directos visibles
				removeOperationShortcuts(null, false);
				e.keyCode = 7;
				return false;
			}

			// Se evitan problemas con 'prompts'
			if (ownerLevelGU == -1)
			{
				if (e.keyCode == 116)
				{
					// El F5
					if (preClick(null))
					{
						// Se utiliza este evento para refrescar un "prompt" porque no se cuenta con un SPAN oculto para ello
						GX_setevent('EBTNCANCELCONFIRMATION.CLICK.');
						self.document.forms[0].submit();
					}
					e.keyCode = 7;
					return false;
				}

				if (e.keyCode == 115)
				{
					if (e.altKey)
						return false;

					// F4 -> "apertura de 'prompt'"
					openPromptIfPosible();
					return false;
				}

				if ((e.keyCode == 122) || (e.keyCode == 117))
				{
					// El F6 y F11 necesitan bloqueo especial
					e.keyCode = 7;
					return false;
				}

				if (e.ctrlKey && !e.altKey && ((e.keyCode == 80) || (e.keyCode == 79) || (e.keyCode == 76) || (e.keyCode == 87) || (e.keyCode == 9)))
				{
					// Se bloquea Ctrl-O, Ctrl-L, Ctrl-W, Ctrl-P y Ctrl-Tab que necesitan tratamiento especial
					e.keyCode = 7;
					return false;
				}

				if (e.altLeft || (e.ctrlKey && (((e.keyCode < 35) || (e.keyCode > 40)) && (e.keyCode != 45) && (e.keyCode != 88) && 
					(e.keyCode != 86) && (e.keyCode != 67) && (e.keyCode != 65))))
				{
					// Se bloquea el resto de las combinaciones con Ctrl que no necesitan tratamiento especial
					// Solo se permite el copiado, cortado y pegado al portapapeles
					if ((e.keyCode == 80) || (e.keyCode == 116))
						e.keyCode = 7;
					return false;
				}

				return true;
			}
			else
			{
				// En caso de no estar dentro del contenedor no se realiza manejo alguno
				if ((ownerLevelGU > 0) || (realParentGU != this))
				{
					if (e.altLeft)
					{
						if (e.keyCode == 37)
						{
							// "back"
							if (ownerLevelGU == 0)
								realParentGU.sManager.back();
							else if ((ownerLevelGU == 1) && (sManager != null))
								sManager.back();
							return false;
						}
						else if (e.keyCode == 39)
						{
							// "forward"
							if (ownerLevelGU == 0)
								realParentGU.sManager.forward();
							else if ((ownerLevelGU == 1) && (sManager != null))
								sManager.forward();
							return false;
						}
					}
					else if (e.ctrlKey && !e.altKey) // Se evita bloquear el altGr = alt + ctrl
					{
						if (e.keyCode == 80)
						{
							// "print"
							if (ownerLevelGU == 0)
								realParentGU.sManager.printCurrent();
							e.keyCode = 7;
						}
						else if (e.keyCode == 78)
						{
							// Ctrl-N -> "open workspace"
							if (top.openWorkSpace != null)
								top.openWorkSpace();
						}
						else if (e.keyCode == 115)
						{
							// Ctrl-F4 -> "close WorkSpace"
							if (top.closeWorkSpace != null)
								top.closeWorkSpace(true);
						}
						else if (e.keyCode == 116)
						{
							// Ctrl-F5 -> "refresh"
							if (ownerLevelGU == 0)
								realParentGU.sManager.refreshCurrent();
							e.keyCode = 7;
						}
						else if (e.keyCode == 33)
						{
							// Ctrl-PgUp -> "prev workspace"
							if (top.prevWorkspace != null)
								top.prevWorkspace();
						}
						else if (e.keyCode == 34)
						{
							// Ctrl-PgDn -> "next workspace"
							if (top.nextWorkspace != null)
								top.nextWorkspace();
						}
						else if ((e.keyCode == 79) || (e.keyCode == 70) || (e.keyCode == 76) || (e.keyCode == 87) || (e.keyCode == 9))
						{
							// Se bloquea Ctrl-F (por accesos directos), Ctrl-O, Ctrl-L, Ctrl-W o Ctrol-Tab que necesitan tratamiento especial
							e.keyCode = 7;
						}

						if (((e.keyCode < 35) || (e.keyCode > 40)) && (e.keyCode != 45) && (e.keyCode != 88) && 
							(e.keyCode != 86) && (e.keyCode != 67) && (e.keyCode != 65) && (e.keyCode != 90) && (e.keyCode != 89))
						{
							// Se bloquea el resto de las combinaciones con Ctrl que no necesitan tratamiento especial
							// Solo se permite el copiado ('c'), cortado ('x') y pegado ('v') al portapapeles; seleccionar todo ('a');
							// deshacer ('z'); y rehacer ('y')
							return false;
						}
					}
					else if (!e.shiftKey && (e.keyCode == 116))
					{
						// F5 -> "refresh"
						if (ownerLevelGU == 0)
							realParentGU.sManager.refreshCurrent();
						e.keyCode = 7;
						return false;
					}
					else if (!e.shiftKey && (e.keyCode == 113))
					{
						// F2 -> "open workspace"
						if (top.openWorkSpace != null)
							top.openWorkSpace();
					}
					else if (!e.shiftKey && (e.keyCode == 114))
					{
						// F3 -> "close WorkSpace"
						if (top.closeWorkSpace != null)
							top.closeWorkSpace(true);
						e.keyCode = 7;
						return false;
					}
					else if (!e.shiftKey && (e.keyCode == 123))
					{
						// F12 -> "print"
						if (ownerLevelGU == 0)
							realParentGU.sManager.printCurrent();
						e.keyCode = 7;
					}
					else if (!e.shiftKey && ((e.keyCode >= 117) && (e.keyCode <= 122)))
					{
						var code = e.keyCode;
						
						// Se bloquea el F11 y el F6
						e.keyCode = 7;
						
						// Del F6 al F11 son posibles accesso directos del menu'
						top.handleMenuShorcut(code);
						return false;
					}
					else if (e.shiftKey && ((e.keyCode >= 113) && (e.keyCode <= 123)))
					{
						var code = e.keyCode;

						// Shift + F2 al F12 (ma's accesos del menu')
						// Se bloquea el F11 y el F6
						e.keyCode = 7;

						// Se le suma 10 que es el "offset" de teclas de funcio'n no utilizadas
						// sin Shift y el F1 que no se puede utilizar de ninguna forma al no poder bloquearse
						top.handleMenuShorcut(code + 10);
						return false;
					}
					else if (e.keyCode == 8)
					{
						// Se bloquea el 'back' a menos que se esté en un INPUT
						if ((e.srcElement.nodeName != 'INPUT') || (e.srcElement.type == "checkbox"))
							e.keyCode = 7;
					}
					else if (e.keyCode == 115)
					{
						// F4 -> "apertura de 'prompt'"
						openPromptIfPosible();
					}
				}
			}
		}
	}
	catch(ex)
	{
		// En caso de haber presionado alguna operación en un campo de entrada de tipo archivo se puede haber generado un error
	}
}

// Redefinicio'n de la operacio'n "submit" del formulario para poder escribir co'digo despue's.
function submitRedefinition()
{
	// Se corrigen los campos de tipo nume'rico con comportamiento especial definido
	if (typeof(document.forms[0].beforeSubmit) == "function")
		document.forms[0].beforeSubmit();

	document.forms[0].realSubmit();

	// Se ocultan los DIV's utilizados para mantener visualmente el formato de los campos nume'ricos ante un "submit"
	if (typeof(document.forms[0].afterSubmit) == "function")
		document.forms[0].afterSubmit();
}

function redefineSubmit()
{
	// Hay pantallas no generadas que invocan ma's de una vez a "initializaPage", con este control se evita una recusio'n infinita
	// si se llegase a redefinir dos o ma's veces
	if (document.forms[0].submit != submitRedefinition)
	{
		document.forms[0].realSubmit = document.forms[0].submit;
		document.forms[0].submit = submitRedefinition;
	}
}

function onfocusHandler()
{
	try
	{
		if ((typeof(document.activeElementBeforePrompt) != "undefined") && (document.activeElementBeforePrompt != null))
		{
			var tagName = document.activeElement.tagName;
			if ((tagName == "INPUT") || (tagName == "SELECT") || (tagName == "TEXTAREA"))
			{
				document.activeElementBeforePrompt.focus();
				return;
			}
		}
	}
	catch (e) {}
	
	setFocus();
}

function setLinkOpStyles()
{ 
	var links = document.getElementsByTagName('A');
	for (var i = 0; i < links.length; i++)
	{
		var link = links[i];	
                var parentNode = link.parentNode;
                if (parentNode != null && parentNode.className == 'ReadonlyAttributeBase')
			link.style.textDecoration = 'underline';
	}
}