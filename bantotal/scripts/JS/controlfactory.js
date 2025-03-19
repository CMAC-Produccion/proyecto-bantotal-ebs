// Constructor de instacias de objetos que describen controles a nivel de cliente. Esta clase es utilizada para brindarle
// a la fa'brica de controles la informacio'n necesaria sobre el/los controles a utilizar.
//
// Para'metros:
//   "type"        -> Tipo de control a crear: ('ACX' "ActiveX", 'APP' "Java Applet")
//   "description" -> Descripcio'n del control a crear. Esta descripcio'n es utilizada en caso de tener que reportar
//                    un error provocado por el uso de este control.
//   "codeBase"    -> 'codebase' del objeto a crear.
//   "id"          -> Identificador del la clase concreta del objeto.
//   "params"      -> Para'metros de inicializacio'n del objeto. Es un vector bidimensional que por cada para'metro define
//                    en la posicio'n 0 el nombre y en la posicio'n 1 el valor.
function ControlDescription(type, description, codeBase, id, params)
{
	this.type        = type;
	this.description = description;
	this.codeBase    = codeBase;
	this.id          = id;
	this.params      = params;
}

/*************************
 * BEGIN: ControlWrapper *
 *************************/

// Operacio'n del adaptador que permite realizar invocaciones gene'ricas hacia el objeto real.
//
// Para'metros:
//   "methodName"      -> Nombre del me'etodo a invocar.
//   "params"          -> Vector de para'metros a invocar, null si no hay para'metros.
//   "resultReceivers" -> Vector de objetos donde se devolvera' el resultado obtenido, null si no interesa el valor de retorno.
//                        Cada componente tiene 2 partes, en la primera esta' el objecto contenedor, y en la segunda el nombre de la propiedad 
//                        sobre la cual se devolvera' el valor.
//                        No se devuelve directamente debido a que cuando se carga el control se necesita esperar a que e'ste llegue a cargarse 
//                        realmente.
function CFInvoke(methodName, params, resultReceivers)
{
	var result;

	if (!this.isReady)
	{
		// Como el objeto au'n no se cargo' completamente se encola el comando para su posterior ejecucio'n
		this.commandsToInvoke.push([methodName, params, resultReceivers]);

		return;
	}

	// Se marca que se esta' procesando un comando para evitar invocaciones concurrentes
	this.isReady = false;

	// Se chequea si el control devolvera' co'digo Javascript o no en caso de no haberse verificado au'n
	if (this.returnExecutableCode == null)
	{
		try
		{
			this.returnExecutableCode = this.realControl.ReturnsExecutableCode();
		}
		catch (e)
		{
			this.returnExecutableCode = false;
		}
	}

	try
	{
		// Se incova el me'todo indicado
		if (params == null)
			result = eval("this.realControl." + methodName + "()");
		else
		{
			var p = "";

			for (var i = 0; i < params.length - 1; i++)
				p += "params[" + i + "],";

			if (params.length > 0)
				p += "params[" + (params.length - 1) + "]";

			result = eval("this.realControl." + methodName + "(" + p + ")");
		}

		// En caso que se devuelva co'digo para ejecutar se evalu'a el mismo		
		if (this.returnExecutableCode)
			result = eval(result);
		
		// En caso que se haya indicado un contenedor para el valor de retorno se define
		if (resultReceivers != null)
		{
			for (var i in resultReceivers)
			{
				// Se define el valor devuelto en los contenedores dados, segu'n las propiedades indicadas
				if (resultReceivers[i][0] != null)
					resultReceivers[i][0][resultReceivers[i][1]] = result;
			}
		}
	}
	catch (e)
	{
		// Se reporta el error
		alert("Ocurri\u00F3 un error al invocar el m\u00E9todo '" + methodName + "' de '" + this.description + "'.\nPuede haberse bloqueado por pol\u00EDticas de seguridad, contacte al administrador de la red.\n\nDetalle:\n  " + e.message);
	}
	
	// Se marca como libre y se procesa el siguiente comando en caso de haber alguno encolado
	this.internalTurnReady();
}

// Permite consultar si el control ha terminado de ejecutar los comandos que se le invocaron o no. En caso de que no se hayan
// terminado de ejecutar los comandos de este control se utilizara' el "callback" dado para realizar la notificacio'n luego de
// que realmente se termine la ejecucio'n.
//
// Para'metros:
//   "callBack" -> Funcio'n a invocar cuando se terminen las ejecuciones.
//   "params"   -> Para'metros del "callBack".
//
// Devuelve true en caso de haber terminado las invocaciones, y false en caso contrario.
function CFExecutionEnd(callBack, params)
{
	if (this.isReady && (this.commandsToInvoke.length == 0))
		return true;
	else
		this.callBacks.push([callBack, params]);
}

// Cambia el estado del adaptador de manera que invoque directamente las operaciones sobre el objeto real. Adema's se procesan los comandos
// que se hayan invocado antes de la terminacio'n de la carga de dicho objeto real en el orden original.
function CFInternalTurnReady()
{
	// Se inicializo' el objeto real correctamente
	this.isReady = true;
	
	// Se procesan la primer operacio'n que se haya encolado
	if (this.commandsToInvoke.length > 0)
	{
		var command = this.commandsToInvoke[0];
		
		// Se elimina el primer elemento
		this.commandsToInvoke = this.commandsToInvoke.slice(1, this.commandsToInvoke.length);

		// Se invoca el primer comando
		this.invoke(command[0], command[1], command[2]);
	}
	else
	{
		// Se notifican los registrados
		for (var i in this.callBacks)
		{
			try
			{
				this.callBacks[i][0](this.callBacks[i][1]);
			}
			catch (e)
			{
			}
		}
		
		// Se eliminan los registros
		this.callBacks = new Array();
	}
}

// Constructor de instancias de objetos que servira'n de adaptadores a los controles reales. Instancias de esta clase son devueltas al cliente
// evitando la interaccio'n directa de e'ste con los controles reales.
//
// Para'metros:
//   "control"     -> Instancia del control real.
//   "description" -> Descripcio'n del control. Es utilizada en el reporte de errores asociados con e'ste control.
//   "className"   -> Nombre de la clase de control adaptado. Se utiliza para poder buscar dentro del "pool" por si ya
//                    se creo' una instancia del tipo indicado antes de tomar la decisio'n de crear una nueva.
function ControlWrapper(control, description, className)
{
	this.realControl          = control;
	this.description          = description;
	this.className            = className;
	this.isReady              = false;
	this.returnExecutableCode = null;
	this.commandsToInvoke     = new Array();
	this.callBacks            = new Array();
}
// Operaciones de la clase "ControlWrapper".
ControlWrapper.prototype.invoke = CFInvoke;
ControlWrapper.prototype.executionEnd = CFExecutionEnd;
// Operaciones de uso interno
ControlWrapper.prototype.internalTurnReady = CFInternalTurnReady;

/***********************
 * END: ControlWrapper *
 ***********************/

/*************************
 * BEGIN: ControlFactory *
 *************************/

// Devuelve una instanca del un control de la clase indicada. Se busca el control ma's adecuado segu'n el ambiente
// del cliente dentro de las descripciones dadas.
//
// Para'metros:
//   "class"    -> Clase del control buscado.
//   "controls" -> Arreglo de descripciones de controles con la clase indicada.
function CFGetInstance(className, controls)
{
	var pos = -1;

	// Por ahora se busca el control de tipo "ActiveX", el u'nico tipo soportado
	for (var i in controls)
	{
		if (controls[i][0] == 'ACX')
		{
			pos = i;
			break;
		}	
	}

	// No se encontro' un control adecuado
	if (pos == -1)
		return null;

	return this.internalCreateControl(className, new ControlDescription(controls[pos][0], controls[pos][1], controls[pos][2], controls[pos][3], controls[pos][4]), this.activeXPool, this.internalActiveXCreator);
}

// Operacio'n de uso interno. Crea una instancia del "ActiveX" con los datos indicados.
//
// Para'metros:
//   "id"                 -> Identificador de la instancia a crear.
//   "controlDescription" -> Descripcio'n del control a crear.
function CFInternalActiveXCreator(id, controlDescription)
{
	return document.createElement("<OBJECT ID='" + id + "' CODEBASE='" + controlDescription.codeBase + "' CLASSID='" + controlDescription.id + "'>");
}

// Operacio'n de uso interno. Crea un control en caso de no haber uno equivalente ya creado.
//
// Para'metros:
//   "className"          -> Clase del control a crear.
//   "controlDescription" -> Descripcio'n del control a crear.
//   "typedPool"          -> "pool" especi'fico de controles previamente creados.
//   "objectCreator"      -> Funcio'n encargada de crear el control concreto segu'n el tipo.
function CFInternalCreateControl(className, controlDescription, typedPool, objectCreator)
{
	var object, wrapper, i;

	// Se verifica que no se haya creado previamente un control de este tipo
	for (i in typedPool)
		if (typedPool[i].className == className)
			return typedPool[i];

	// Inicializador del adaptaror
	function wrapperInitializer()
	{
		// Se modifica el estado de forma que ahora si' pueda procesar pedidos y se ejecuta el primer comando
		// encolado en caso de haber alguno
		wrapper.internalTurnReady();
	}

	// Manejador para el evento de cambio de estado del control
	var handler = function onreadystatechangeHandler()
	{
		// Se marca al adaptador como listo para ser usado
		if (object.readyState == 4)
		{
			// Se utiliza un "timer" para que el objeto se termine realmente de inicializar y luego notificar al adaptaror
			setTimeout(wrapperInitializer, 1);
		}
	}

	// Si no se econtro' un control adecuado se crea uno
	object = objectCreator("ctrlId_" + className, controlDescription);
	object.onreadystatechange = handler;

	// Se crea el adaptador
	wrapper = new ControlWrapper(object, controlDescription.description, className);

	// Se crean los pra'metros
	for (i in controlDescription.params)
		object.appendChild(document.createElement("<PARAM NAME='" + controlDescription.params[i][0] + "' VALUE='" + controlDescription.params[i][1] + "'>"));

	// Se agrega al conjunto de controles creados
	typedPool.push(wrapper);

	// Se agrega al documento
	this.containerElement.appendChild(object);

	return wrapper;
}

// Consturctor de instancias de objetos que representan fa'bricas de controles.
// Para soportar nuevos tipos de objetos hay que agregar un nuevo "pool" para el tipo concreto, modificar el co'digo
// de la operacio'n "getInstance" para reconocer dicho tipo, y por u'ltimo definir una operacio'n interna "internalNEWTYPECreator"
// que se encargue de los detalles especi'ficos de la definicio'n del HTML del nuevo tipo.
//
// Para'metros:
//   "containerElement" -> Objeto HTML donde se insertara'n los controles creados.
function ControlFactory(containerElement)
{
	this.containerElement = containerElement;
	
	// "Pool" de objetos de tipo "ActiveX"
	this.activeXPool = new Array();
}
// Operaciones de la clase "ControlFactory"
ControlFactory.prototype.getInstance = CFGetInstance;
// Operaciones de uso interno
ControlFactory.prototype.internalCreateControl  = CFInternalCreateControl;
ControlFactory.prototype.internalActiveXCreator = CFInternalActiveXCreator;

/***********************
 * END: ControlFactory *
 ***********************/
/*
// Se crea la instancia de la fa'brica de controles
var controlFactoryInstance = new ControlFactory(aaaa);


var arr = new Array();
arr.push(new ControlDescription('ACX', "description", "activex/PrintControl.cab#version=1,1,0,2", "CLSID:F94FBCE4-EF19-40C7-BD3E-2FA729853ABB", [["_Version", "65536"], ["_ExtentX", "2646"], ["_ExtentY", "1323"], ["_StockProps", "0"]]));
var asdf = controlFactoryInstance.getInstance("class1", [new ControlDescription('ACX', "description", "activex/PrintControl.cab#version=1,1,0,2", "CLSID:F94FBCE4-EF19-40C7-BD3E-2FA729853ABB", [["_Version", "65536"], ["_ExtentX", "2646"], ["_ExtentY", "1323"], ["_StockProps", "0"]])]);
alert(asdf.invoke('PrintText', ['asdas', 'nada2'], null));
*/