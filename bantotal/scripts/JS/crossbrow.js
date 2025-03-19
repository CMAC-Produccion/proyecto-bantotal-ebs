// Contiene funciones que encapsula mecanismos para poder construir una aplicaci�n
// que sea independiente del navegador

// Registra una funci�n para responder al evento especificado.
//
// Par�metros:
//   'obj'  -> Objeto al que pertenece el evento.
//   'evnt' -> Evento.
//   'f'    -> Funci�n.
function cbAttachEvent(obj, evnt, f)
{	
	if (obj.addEventListener) // Mozilla/W3C
		obj.addEventListener(type, f, true);				
	else if (obj.attachEvent) // IE
		obj.attachEvent("on" + evnt, f)
}

// Quita el registro una funci�n para responder a un event.
//
// Par�metros:
//   'obj'  -> Objeto al que pertenece el evento.
//   'evnt' -> Evento.
//   'f'    -> Funci�n.
function cbRemoveEvent(obj, evnt, f)
{
	if (obj.removeEventListener) // Mozilla/W3C
		obj.removeEventListener(evnt, f, false);				
	else if (obj.detachEvent) // IE
		obj.detachEvent("on" + evnt, f)
}