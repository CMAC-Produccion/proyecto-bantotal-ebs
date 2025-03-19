var confAreaNameOP = 'HTMLTBLCONFIRMATIONAREA';
var messageAreaOP  = 'TXTMESSAGES';
var myEvent   = '';
var forcePost = false;

function dropReportedErrors()
{
	document.getElementById(messageAreaOP).innerHTML = '';
}

function initPrompt(eventName, doPost)
{
	var confirmation = document.getElementById(confAreaNameOP);
	var confParent;
	
	state = 1;

	if (confirmation != null)
	{
		confParent = confirmation.parentNode;
		if (confParent != null)
			confParent.removeChild(confirmation);
	}

	document.getElementById(messageAreaOP).innerHTML = '';

	forcePost = doPost;
	
	if (doPost)
		myEvent = 'E' + eventName;
}

function autoRefresh()
{
	if (forcePost)
	{
		preClick();
		GX_setevent(myEvent + '.CLICK.');
		self.document.forms[0].submit();
	}

	state = 0;
}