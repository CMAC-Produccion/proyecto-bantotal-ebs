function validateDate(day, month, year)
{
	if ((day < 1) || (month < 1) || (month > 12))
		return false;

	if ((month == 4) || (month == 6) || (month == 9) || (month == 11))
		return day <= 30;

	if (month == 2)
	{
		if (day <= 28)
			return true;

		if ((year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0)))
			return day == 29;

		return false;
	}

	return day <= 31;
}

function gxvdate( Elem, nDateLen, nDateFmt, nTimeLen, nTimeFmt, sIdiom)
{
	var error = false;
	var message;

	var reEmpty = /^([ ]*(\/[ ]*\/[ ]*((00|12)(:00(:00)?)?[ ]*(a|am)?)?)?)?[ ]*$/i;
	var reVDTime;

	if (reEmpty.test( Elem.value))
	{
		Elem.value = "";
	}

	var sVDTime = "^[ ]*(";
	if (nDateLen > 0)
	{
		if (nDateLen == 8)
			sVDTime = sVDTime + "([0-9]{1,2})[\/]?([0-9]{1,2})[\/]?([0-9]{2})";
		else
			if (nDateFmt == 0)
				sVDTime = sVDTime + "([0-9]{1,2})[\/]?([0-9]{1,2})[\/]?([0-9]{2,4})";
			else
				sVDTime = sVDTime + "([0-9]{2,4})[\/]?([0-9]{1,2})[\/]?([0-9]{1,2})";
	}
	else
		/* Extra parenthesis are added to maintain parameter numbers */
		sVDTime = sVDTime + "( )?( )?( )?";

	if (nTimeLen > 0)
	{
		sVDTime = sVDTime + "(";
		if (nDateLen > 0)
			sVDTime = sVDTime + "[ ]*";
		sVDTime = sVDTime + "([0-9]{2})";

		if (nTimeLen > 2)
			sVDTime = sVDTime + "(:?([0-9]{2}))?";
		else
			sVDTime = sVDTime + "(( )?)?";

		if (nTimeLen > 5)
			sVDTime = sVDTime + "(:?([0-9]{2}))?";
		else
			sVDTime = sVDTime + "(( )?)?";

		if ( nTimeFmt == 1)
			sVDTime = sVDTime + "[ ]*(a|am|p|pm)?";
		else
			sVDTime = sVDTime + "(( )?)?";

		sVDTime = sVDTime + ")?";
	}
	sVDTime = sVDTime + ")?[ ]*$";
	reVDTime = new RegExp( sVDTime, "i");

	if (reVDTime.test( Elem.value))
	{
		var sTokArr = Elem.value.match( reVDTime);

		if (nDateLen > 0)
		{
			if (sTokArr[2] == "" || sTokArr[2] == null)
				Elem.value = "  /  /  ";
			else
			{
				var year = sTokArr[nDateFmt == 0 ? 4 : 2];
				var month = sTokArr[3];
				var day = sTokArr[nDateFmt == 0 ? 2 : 4];
				var completeDateWithSeps = sTokArr[0];
				var len = day.length + month.length + year.length;

				// Se realizan validaciones extras sobre la fecha
				if ((len < 6) && (completeDateWithSeps.length < len + 2))
				{
					// Se deben haber ingresado al menos 6 di'gitos salvo que se hayan ingresado expli'citamente
					// los separadores '/'; sin este control, por ejemplo la fecha "1110" se interpretari'a como "1/1/10"
					// pudiendo generar errores si lo que se queri'a ingresar era "11/10"
					error = true;
					message = message_text(sIdiom, "datefmt");
				}
				else
				{
					if ((year.length == 3) || ((nTimeLen > 0) && (nDateLen == 10) && (year.length == 2)))
					{
						// Se controla que no hayan 3 di'gitos para el an~o, ya que no se logra interpretar eso en el servidor
						// Adema's si hay hora y se esperan 4 di'gitos en el an~o no puede haber 2 porque tambie'n falla
						error = true;
						message = message_text( sIdiom, "datefmt");
					}
					else
					{
						// Se controla que en nu'mero de di'a, mes y an~o sean va'lidos
						if (!validateDate(day, month, year))
						{
							error = true;
							message = "La fecha no es v\u00E1lida.";
						}
					}
				}

				Elem.value = sTokArr[2] + "/" + sTokArr[3] + "/" + sTokArr[4];
			}
		}
		else
			Elem.value = "";

		if ((nTimeLen > 0) && !error)
		{
			if (nDateLen > 0)
				Elem.value = Elem.value + " ";

			if (sTokArr[6] == "" || sTokArr[6] == null)
				if (nTimeFmt == 1)
					Elem.value = Elem.value + "12";
				else
					Elem.value = Elem.value + "00";
			else
			{
				var hour = sTokArr[6];

				Elem.value = Elem.value + hour;

				if (((nTimeFmt == 1) && ((hour > 12) || (hour < 1))) || (hour > 23))
				{
					error = true;
					message = "La hora no es v\u00E1lida.";
				}
			}

			if (nTimeLen > 2)
			{
				if (sTokArr[8] == "" || sTokArr[8] == null)
					Elem.value = Elem.value + ":00";
				else
				{
					var minutes = sTokArr[8];

					Elem.value = Elem.value + ":" + minutes;

					if (minutes > 59)
					{
						error = true;
						message = "La hora no es v\u00E1lida.";
					}
				}
			}

			if (nTimeLen > 5)
			{
				if (sTokArr[10] == "" || sTokArr[10] == null)
					Elem.value = Elem.value + ":00";
				else
				{
					var seconds = sTokArr[10];

					Elem.value = Elem.value + ":" + seconds;

					if (seconds > 59)
					{
						error = true;
						message = "La hora no es v\u00E1lida.";
					}
				}
			}

			if ( nTimeFmt == 1)
			{
				var x;
				if (sTokArr[11] == "" || sTokArr[11] == null)
					x = "a";
				else
					x = sTokArr[11].substr(0,1);
				if (x.toLowerCase() == "p")
				{
					Elem.value = Elem.value + " PM";
				}
				else
				{
					Elem.value = Elem.value + " AM";
				}
			}
		}


		if (error)
		{
			// Se recuerda el error para evitar pedidos erro'neos
			validationGU = false;

			// Se colorea en caso de error
			if ((typeof(Elem.prevClassName) == "undefined") || (Elem.prevClassName == null))
				Elem.prevClassName = Elem.className;
			Elem.className = "AttributeEmphasised";

			alert(message);

			Elem.value = "";

			// Se controla que au'n se este' visible el paso actual
			if (self.frameElement.style.visibility == 'visible')
				Elem.focus();

			return false;
		}

		// Se recuerda la validación correcta para permitir pedidos
		validationGU = true;

		// Se vuelve al color original
		if ((typeof(Elem.prevClassName) != "undefined") && (Elem.prevClassName != null))
			Elem.className = Elem.prevClassName;

		return true;
	}

	// Se recuerda el error para evitar pedidos erro'neos
	validationGU = false;

	// Se colorea en caso de error
	if ((typeof(Elem.prevClassName) == "undefined") || (Elem.prevClassName == null))
		Elem.prevClassName = Elem.className;
	Elem.className = "AttributeEmphasised";

	alert( message_text( sIdiom, "datefmt"));

	Elem.value = "";

	// Se controla que au'n se este' visible el paso actual
	if (self.frameElement.style.visibility == 'visible')
		Elem.focus();

	return false;
}

function valid_decimal( Elem, ThSep, DecPoint, Dec)
{
	var gx_DecRegExp = new RegExp("^[ ]*([+-]?[0-9]*(\\" + ThSep + "[0-9]{3})*(\\" + DecPoint + "[0-9]*)?)?[ ]*$");
	if (gx_DecRegExp.test( Elem.value))
	{
		DecPointIndex = Elem.value.indexOf(DecPoint);
		if (DecPointIndex != -1)
			Elem.value = Elem.value.slice( 0, DecPointIndex + parseInt(Dec) + 1);

		// Se recuerda la validación correcta para permitir pedidos
		validationGU = true;


		// Se vuelve al color original
		if ((typeof(Elem.prevClassName) != "undefined") && (Elem.prevClassName != null))
			Elem.className = Elem.prevClassName;
	}
	else
	{
		// Se recuerda el error para evitar pedidos erro'neos
		validationGU = false;

		// Se colorea en caso de error
		if ((typeof(Elem.prevClassName) == "undefined") || (Elem.prevClassName == null))
			Elem.prevClassName = Elem.className;
		Elem.className = "AttributeEmphasised";

	   	alert(GXBadNumMsg); 

		// Se controla que au'n se este' visible el paso actual
		if (self.frameElement.style.visibility == 'visible')
	   		Elem.focus();
	}
}

function valid_integer( Elem, ThSep)
{
	var gx_IntRegExp = new RegExp("^[ ]*([+-]?[0-9]*(\\" + ThSep + "[0-9]{3})*)?[ ]*$");
	if (! gx_IntRegExp.test( Elem.value))
	{ 
		// Se recuerda el error para evitar pedidos erro'neos
		validationGU = false;

		// Se colorea en caso de error
		if ((typeof(Elem.prevClassName) == "undefined") || (Elem.prevClassName == null))
			Elem.prevClassName = Elem.className;
		Elem.className = "AttributeEmphasised";

		alert(GXBadNumMsg); 

		// Se controla que au'n se este' visible el paso actual
		if (self.frameElement.style.visibility == 'visible')
			Elem.focus();
	}
	else
	{
		// Se recuerda la validación correcta para permitir pedidos
		validationGU = true;

		// Se vuelve al color original
		if ((typeof(Elem.prevClassName) != "undefined") && (Elem.prevClassName != null))
			Elem.className = Elem.prevClassName;
	}
}
