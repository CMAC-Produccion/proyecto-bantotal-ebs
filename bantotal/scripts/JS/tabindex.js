var imagePromptSrcTI = "promptbutton.gif";
var vLPrefixTI = "HTMLTXTVLEVENT_";
var auxATI;

// Botonoes de 'prompt'
imgColTI = document.getElementsByTagName('IMG');

for (i = 0; i < imgColTI.length; i++)
{
	if (imgColTI[i].getAttribute("src").indexOf(imagePromptSrcTI) != -1)
	{
		imgColTI[i].parentNode.setAttribute("tabIndex", -1);
	}
}

// Cuadros de texto asociados a eventos de listas de valores
spanColTI = document.getElementsByTagName('SPAN');

for (i = 0; i < spanColTI.length; i++)
{
	if (spanColTI[i].getAttribute("id").substring(0, 15) == vLPrefixTI)
	{
		auxATI = spanColTI[i].firstChild;
	
		if (auxATI != null)
			auxATI.setAttribute("tabIndex", -1);
	}
}
