// Contiene funciones que encapsula mecanismos para poder construir una aplicación
// que sea independiente del navegador

// Registra una función para responder al evento especificado.
//
// Parámetros:
//   'obj'  -> Objeto al que pertenece el evento.
//   'evnt' -> Evento.
//   'f'    -> Función.
function cbAttachEvent(obj, evnt, f)
{	
	if (obj.addEventListener) // Mozilla/W3C
		obj.addEventListener(type, f, true);				
	else if (obj.attachEvent) // IE
		obj.attachEvent("on" + evnt, f)
}

// Quita el registro una función para responder a un event.
//
// Parámetros:
//   'obj'  -> Objeto al que pertenece el evento.
//   'evnt' -> Evento.
//   'f'    -> Función.
function cbRemoveEvent(obj, evnt, f)
{
	if (obj.removeEventListener) // Mozilla/W3C
		obj.removeEventListener(evnt, f, false);				
	else if (obj.detachEvent) // IE
		obj.detachEvent("on" + evnt, f)
}