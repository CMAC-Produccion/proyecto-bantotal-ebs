var GXPARAMETERS = new Array();

function openPrompt(url, params, nParams, width, height)
{
	document.activeElementBeforePrompt = document.activeElement;

	// Se valida que no se haya abierto otra sesio'n (se valida que este' definido el "top" por objetos no manejados)
	if ((typeof(realTopGU) != "undefined") && (realTopGU != null) && !realTopGU.checkBeforeSubmit(false))
		return;

	var sParams = "";
	var popupId;

	if (width != -1)
	{
		// Se agrega el ancho de las barras de desplazamiento
		width += 16;
		height += 4;
	}

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

	if (width != -1)
	{
		var l = (screen.availWidth - width) / 2;
		var t = (screen.availHeight - height) / 2;
	}
	else
	{
		// Tamaño máximo
		var l = 0;
		var t = 0;
		width = screen.availWidth - 12;
		height = screen.availHeight - 50;
	}

	// Los para'metros se pasan como uno solo, por lo tanto se vuelven a codificar
	sParams = encodeURIComponent(sParams);

	wPromptPD = window.open(url + ',' + sParams,"_blank","status=no,toolbar=no,location=no,directories=no,menubar=no,width=" + width + ",height=" + height + ",left=" + l + ",top=" + t + ",scrollbars=yes,resizable=yes,copyhistory=no");
	wPromptPD.focus();
}
