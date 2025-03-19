var GXPARAMETERS = new Array();

function openPopup(url, params, nParams, width, height, title, isPrompt)
{
	var sParams = "";

	if (nParams > 1)
	{
		for (i = 0; i < nParams - 1; i++)
		{
			GXPARAMETERS[i] = params[i];
			sParams = sParams + encodeURIComponent(typeof(params[i]) == "string" ? params[i] : params[i].value) + ",";
		}
	}
	
	if (nParams > 0)
	{
		GXPARAMETERS[nParams - 1] = params[nParams - 1];
		sParams = sParams + encodeURIComponent(typeof(params[nParams - 1]) == "string" ? params[nParams - 1] : params[nParams - 1].value);
	}

	if (panelRegIdGU == -1)
		panelRegIdGU = top.popupManager.register(this);

	// Los para'metros se pasan como uno solo, por lo tanto se vuelven a codificar
	sParams = encodeURIComponent(sParams);

	top.popupManager.createPopup(panelRegIdGU, url + ',' + sParams, width, height, title, isPrompt);
}
