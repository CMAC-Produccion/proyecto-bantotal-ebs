var acceptGlobalHiddenSpanPPR = 'HTMLTXTPROMPTACCEPT';
var emptyEventNamePPR = 'EHTMLTXTEMPTYEVENT';

function refreshOpener()
{
	if ((opener != null) && (opener.state == 1))
		opener.autoRefresh();
}

function attachUnload()
{
	if (navigator.appName == "Netscape")
		window.captureEvents(Event.ONUNLOAD);

	window.onunload = refreshOpener;

	return false;
}

function attachAcceptEvent()
{
	attachUnload();

	var url = String(document.getElementById(acceptGlobalHiddenSpanPPR).childNodes[0].getAttribute('href'));
	url = unescape(url);

	eval(url);
}

/**
 * Este evento se utiliza para asociar el posible refrescado del padre. Se invoca la operacio'n
 * "autoRefresh" del padre quien decidira' si se debe refrescar o no.
 *
 * Adicionalmente si se indica "type == 0" se retornan automa'ticamente los valores asociados el control oculto de retorno.
 */
function attachAcceptEvent2(type)
{
	attachUnload();

	if (type == 0)
	{
		// Se viene de un 'href'
		var url = String(document.getElementById(acceptGlobalHiddenSpanPPR).childNodes[0].getAttribute('href'));
		url = unescape(url);

		eval(url);

		return false;
	}

	return true;
}

// Evento que va al servidor para actualizar los valores de retorno. Es utilizado desde la operacio'n "Aceptar".
function acceptReturnEvent()
{
	// Se modifica el valor de la variable que controla el estado de aceptacio'n para que al retornar
	// se devuelvan automáticamente los valores
	document.forms[0]._ZG1_PROMPTACCEPT.value = 1;
	
	// se realiza la ida al servidor
	if ((typeof(GX_setevent) != "undefined") && (GX_setevent != null))
	{
		setClientCookies();

		// Esto evita que se declare cerrado el "popup" ya que primero se va hasta el servidor, cuando se cierre realmente la ventana se removera' el mismo
		removePopupsGU = false;

		GX_setevent(emptyEventNamePPR + '.CLICK.');
		document.forms[0].submit();
	}
}