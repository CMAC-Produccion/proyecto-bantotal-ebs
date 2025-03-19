var requiredEM = 0;

function backExternal()
{
	requiredEM++;
	self.history.back();
}

function forwardExternal()
{
	requiredEM++;
	self.history.forward();
}

function externalOnLoadHandler()
{
	// Se notifica solamente si el 'onload' no fue provocado por un cambio
	// forzado en el historial
	if (requiredEM == 0)
		notifyExternalChange();
	else
		requiredEM--;
}