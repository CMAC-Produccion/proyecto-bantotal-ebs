// Constantes
var EditableBlankNI    = ' ';
var NotEditableBlankNI = '';

/***********************
 * BEGIN: Utils *
 ***********************/

function nIUpdateChangeHandler(attach)
{
    if (attach) 
    {
        if (!this.valueChangeHandlerDefined)
        {
            this.input.attachEvent("onpropertychange", nIOnropertychangeHandler);
            this.valueChangeHandlerDefined = true;
        }
    }
    else
    {
        this.input.detachEvent("onpropertychange", nIOnropertychangeHandler);
        this.valueChangeHandlerDefined = false;
    }
}

// Devuelve la cadena de caracteres con el caracter dado insertado en la posicio'n indicada.
// Para'metros:
//     "c"    -> Caracter a agregar.
//     "pos"  -> Posicio'n donde se insertara'.
// Retorno:
//     Cadena de caracteres con "c" insertado en la posicio'n "pos".
function nIInsertCharAt(c, pos)
{
    var l = this.length;

    if ((pos < 0) || (pos > l))
        return this;

    return this.substring(0, pos) + c + this.substring(pos, l);
}

// Devuelve la cadena de caracteres sin el caracter de la posicio'n indicada.
// Para'metros:
//     "pos"  -> Posicio'n del caracter a remover.
// Retorno:
//     Cadena de caracteres sin el caracter de la posicio'n "pos".
function nIRemoveCharAt(pos)
{
    var l = this.length;

    if ((l <= pos) || (pos < 0))
        return this;

    return this.substring(0, pos) + this.substring(pos + 1, l);
}

// Se asocian a la clase "String" para su uso directo
String.prototype.insertCharAt = nIInsertCharAt;
String.prototype.removeCharAt = nIRemoveCharAt;

// Aplica al elemento dado las propiedades de estilo propias de los campos nume'ricos.
// Para'metros:
//     "elem" -> Elemento al que se le aplicara'n los atributos de estilo.
function nISetStyleProperties(elem)
{
	elem.style.textAlign = "right";
}

/*********************
 * END: String utils *
 *********************/

/**********************************
 * BEGIN: Behavior event handlers *
 **********************************/

// Manejador del evento de presionado de teclas por parte del usuario.
function nIOnkeydownHandler()
{
	var e = window.event;
	var code = e.keyCode;
	var behavior = e.srcElement.behavior;

    // Si se esta' ante una tecla de control no se hace nada    
    if ((code >= 16) && (code <= 18))
        return false;
    
    // '0' - '9' normales y '0' - '9' del teclado nume'rico
	if (((code >= 48) && (code <= 57)) || ((code >= 96) && (code <= 105)))
	{
		// Si hay alguna tecla de control presionada no se hace nada
	    if (e.ctrlKey || e.altKey || e.shiftKey)
	        return false;

	    // Se normaliza el co'digo para manejar entradas desde el teclado nume'rico
	    if (code > 57)
	        code -= 48;

		if (!removeOperationShortcuts(e.keyCode, false))
		{
			// Se procesa el di'gito ingresado, eliminando la seleccio'n y actualizando el formato
			// porque se recibio' directamente una entrada del usuario
			behavior.insertDigit(String.fromCharCode(code), true, true);
			e.cancelBubble = true;
			// Esto es para que se marquen como modificadas las li'neas en donde se haya cambiado un campo con comportamiento nume'rico
			if ((typeof(e.srcElement.onchange) != "undefined") && (e.srcElement.onchange != null))
			    e.srcElement.fireEvent("onchange");
		}

		return false;
    }
    else
    {
		// Se procesa la entrada no nume'rica
		if (behavior.processNonDigit(code, e.ctrlKey, e.shiftKey))
		{
		    // Esto es para que se marquen como modificadas las li'neas en donde se haya cambiado un campo con comportamiento nume'rico
		    if ((typeof(e.srcElement.onchange) != "undefined") && (e.srcElement.onchange != null))
		        e.srcElement.fireEvent("onchange");

			return true;
		}
		else
		{
			if (e.srcElement.insideGrid == "no")
				keyDownHandler(e);
			else
			{
				if (e.srcElement.insideGrid == "yes")
					gridKeyDownHandler(e);
				else
				{
					// e.srcElement.insideGrid = "maybe"
					// Se verifica si esta' en una grilla o no
					if (gridKeyDownHandler(e) == "outsideGrid")
					{
						e.srcElement.insideGrid = "no";
						keyDownHandler(e);
					}
					else
						e.srcElement.insideGrid = "yes";
				}
		    }

			e.cancelBubble = true;
			return false;
		}
	}
}

// Manejador del evento de copiado.
function nIOncopyHandler()
{
	var behavior = window.event.srcElement.behavior;
    
    // Se deja en el porta-papeles la parte del nu'mero seleccionada sin el formato particular del INPUT
    // para que cuando sea pegado en otro lugar se comporte igual que un campo con el comportamiento por usual
    window.clipboardData.setData("Text", behavior.getUnformatedSelectedText(false));
    
    return false;
}

// Manejador del evento de cortado.
function nIOncutHandler()
{
	var behavior = window.event.srcElement.behavior;
    
    // Se deja en el porta-papeles la parte del nu'mero seleccionada sin el formato particular del INPUT
    // para que cuando sea pegado en otro lugar se comporte igual que un campo con el comportamiento por usual
    window.clipboardData.setData("Text", behavior.getUnformatedSelectedText(true));
    
    return false;
}

// Manejador del evento de pegado.
function nIOnpasteHandler()
{
	var behavior = window.event.srcElement.behavior;

	// En esta operacio'n se hace efectiva la seleccio'n sobre el campo con un "timer"
	// porque de otra forma el cursor siempre queda posicionado contra la derecha
	// luego de este evento
	behavior.insertFormatedText(window.clipboardData.getData("Text"), true, true);

	return false;
}

// Manejador del evento de pe'rdida de foco.
function nIOnblurHandler()
{
	var srcElement = window.event.srcElement;
	var behavior   = srcElement.behavior;

	behavior.leaveEditableState();
	behavior.updateChangeHandler(true);

	return true;
}

// Manejador del evento previo al posicionamiento del foco.
function nIOnfocusinHandler()
{
	var srcElement = window.event.srcElement;
	var behavior   = srcElement.behavior;

	behavior.updateChangeHandler(false);
	behavior.enterEditableState();

	return true;
}

// Manejador del evento que indica el cambio en una propiedad.
// Se utiliza para notificar de posibles cambios hechos por co'digo en el "value".
function nIOnropertychangeHandler()
{
	var e          = window.event;
	var srcElement = e.srcElement;
	var behavior   = srcElement.behavior;
	var val;

	if (e.propertyName == "value")
	{
		// Si define esto por si internamente se quiere utilizar la operación "setValue" para no
		// re-asignar el manejador del "onpropertychange"
	    behavior.updateChangeHandler(false);

		// Se elimina lo anterior ya que se modifico' el "value" por co'digo
		behavior.reset();

		// Se elimina el valor asignado dejando el INPUT en blanco para la insercio'n formateada
		val = srcElement.value;
		srcElement.value = "";

		// Se inserta el nuevo valor
		behavior.insertFormatedText(val, false, false);

		behavior.updateChangeHandler(true);

		// Esto es para que se marquen como modificadas las li'neas en donde se haya cambiado un campo con comportamiento nume'rico
        if ((typeof(srcElement.onchange) != "undefined") && (srcElement.onchange != null))
            srcElement.fireEvent("onchange");

		return false;
	}

	return true;
}

/********************************
 * END: Behavior event handlers *
 ********************************/

/*******************************
 * BEGIN: Extra event handlers *
 *******************************/
 
function nIOnsubmitFormHandler()
{
	// Se consigue asi' la referencia al formulario porque no se esta' 
	// utilizando como evento, ver constructor de "NumericInputBehavior"
	var inputs = this.elements;

	for (var i = 0; i < inputs.length; i++)
	{
		if (typeof(inputs[i].behavior) == "object")
			inputs[i].behavior.beforeSubmit();
	}
}

function nIOnafterSubmitFormHandler()
{
	// Se consigue asi' la referencia al formulario porque no se esta' 
	// utilizando como evento, ya que no existe un evento con estas caracteri'sticas
	var inputs = this.elements;

	for (var i = 0; i < inputs.length; i++)
	{
		if (typeof(inputs[i].behavior) == "object")
			inputs[i].behavior.afterSubmit();
	}
}

/*****************************
 * END: Extra event handlers *
 *****************************/

/***************************************************
 * BEGIN: NumericInputBehavior :: API para eventos *
 ***************************************************/

// Inserta en la posicio'n actual el texto formateado.
// Para'metros:
//     "formatedText"   -> Texto con formato a insertar.
//     "select"         -> true para indicar que se haga visible la seleccio'n , y false en caso contrario.
//     "delaySelection" -> true para indicar que se utilice un "timer" antes de hacer efectiva la selección, 
//                         y false en caso contrario.
// Observaciones:
//     - Elimina la seleccio'n actual.
function nIInsertFormatedText(formatedText, select, delaySelection)
{
	var c;

	// Se actualiza y elimina la seleccio'n actual
	this.updateCurrentSelection();
	this.eraseSelection();
	
	for (var i = 0; i < formatedText.length; i++)
	{
		c = formatedText.charAt(i);
	
		// Si se encontro' un separador decimal se desplaza hasta luego de e'l
		if ((c == this.decimalSep) && (this.nDecs > 0))
		{
			this.visibleDecimalSep = true;
			this.endPosition = this.beginPosition = this.integerValue.length + 1 + this.sign.length;
			continue;
		}

		// Se procesa el di'gito
		if ((c >= '0') && (c <= '9'))
		{
			// No se actualiza el formato ni se elmina la seleccio'n porque eso se maneja en esta operacio'n
			this.insertDigit(c, false, false);
		}
		
		// Se procesa el signo si no se ocupo' su lugar con un di'gito entero
		if (this.signed && this.integerValue.length <= this.nInts)
		{
			if (c == '+')
				this.sign = "";
			else if (c == '-')
				this.sign = c;
		}
	}

	// Se actualiza el formato
	this.updateFormat(0, select, delaySelection);
}

// Devuelve el texto seleccionado sin formato.
// Para'metros:
//     "remove" -> true para indicar que se remueva la seleccio'n y false en caso contrario.
// Retorno:
//     Texto sin formato seleccionado.
function nIGetUnformatedSelectedText(remove)
{
    var begin, end;
    var res = this.sign + this.integerValue;

    if (this.nDecs > 0)
        res += this.decimalSep + this.decimalValue;
    
    // Se actualiza segu'n la seleccio'n actual
    this.updateCurrentSelection();
    
    if (this.beginPosition >= this.endPosition)
    {
        begin = this.endPosition;
        end   = this.beginPosition;
    }
    else
    {
        begin = this.beginPosition;
        end   = this.endPosition;
    }

	// Se remueve la seleccio'n si asi' se indico'
	if (remove)
		this.eraseSelection();

	// Se actualiza el campo
    this.updateFormat(0, true, false);
    
    return res.substring(begin, end);
}

// Inserta un di'gito.
// Para'metros:
//     "digit"                 -> Carater con el di'gito a agregar.
//     "eraseCurrentSelection" -> true para indicar que se elimine la seleccio'n actual, y false
//                                para indicar lo contrario.
//     "update"                -> true para indicar que se actualice el formato, y false en caso contrario.
function nIInsertDigit(digit, eraseCurrentSelection, update)
{
	// Si se indico' que se eliminara la seleccio'n
	if (eraseCurrentSelection)
	{
		this.updateCurrentSelection();
		this.eraseSelection();
	}

    // Se verifica si se esta' agregando un di'gito decimal o entero
    if (this.beginPosition > this.integerValue.length + this.sign.length)
        this.insertDecimalDigit(digit, update);
    else
        this.insertIntegerDigit(digit, update);
}

// Procesa una entrada de usuario no nume'rica.
// Para'metros:
//     "code"  -> Co'digo de la tecla presionada.
//     "ctrl"  -> true si el "Ctrl" esta' presionado, y false en caso contrario.
//     "shift" -> true si el "Shift" esta' presionado, y false en caso contrario.
// Retorno:
//     true si no se quiere bloquear el evento del teclado, y false en caso contrario.
function nIProcessNonDigit(code, ctrl, shift)
{
    switch (code)
    {
        case 8: // "back-space"
			this.updateCurrentSelection();

			// Si la seleccio'n no era vaci'a so'lamente se borra lo contenido de la misma
            if (!this.eraseSelection())
            {
				// Seleccio'n vaci'a

				// Se verifica si se esta' borrando el signo
				if ((this.sign.length == 1) && (this.beginPosition == 1))
				{
					this.sign = "";
					this.beginPosition = this.endPosition = 0;
					this.updateFormat(-1, true, false);
					
					break;
				}

				// Posicio'n del primer di'gito decimal
				var firstDecPos = this.integerValue.length + 1 + this.sign.length;

                if (ctrl && (this.beginPosition != firstDecPos))
                {
                    if (this.beginPosition > firstDecPos)
                        this.endPosition = firstDecPos;
                    else
                        this.endPosition = this.sign.length;

                    this.eraseSelection();
                }
                else
                {
                    if (this.beginPosition > 0)
                    {
						// Si se esta' en el separador decimal se borra
						if ((this.beginPosition == firstDecPos) && !this.monospacedFont)
						{
							// Se elimina el separador decimal
							this.integerValue += this.decimalValue;
							if (this.integerValue.length > this.nInts)
							{
								if (!this.signed || (this.sign == '-'))
									this.integerValue = this.integerValue.substring(0, this.nInts);
								else
								{
									// En caso de tener signo, si e'ste no es negativo se permite un di'gito ma's
									this.sign = "";
									this.integerValue = this.integerValue.substring(0, this.nInts + 1);
								}
							}

							this.decimalValue = "";
							this.visibleDecimalSep = false;

							this.endPosition = --this.beginPosition;
							this.updateFormat(-1, true, false);
							break;
						}

                        if (this.beginPosition > this.integerValue.length + this.sign.length)
                            this.decimalValue = this.decimalValue.removeCharAt(this.beginPosition - this.integerValue.length - this.sign.length - 2);
                        else
                            this.integerValue = this.integerValue.removeCharAt(this.beginPosition - this.sign.length - 1);

                        this.endPosition = --this.beginPosition;
                    }
                }
            }

            this.updateFormat(-1, true, false);
            break;
        case 37: // "back-arrow"
			this.updateCurrentSelection();
			
            // En caso de haber seleccio'n simplemente se elimna la misma y se posiciona al principio
            if ((this.endPosition > this.beginPosition) && !shift)
                this.endPosition = this.beginPosition;
            else
            {
                // No hay seleccio'on
                if (!ctrl)
                {
                    if (this.beginPosition > 0)
                        this.beginPosition--;

                    if (!shift)
                        this.endPosition = this.beginPosition;
                }
                else
                {
					var signLength = this.sign.length;

                    if (this.beginPosition > this.integerValue.length + 1 + signLength)
                        this.beginPosition = this.integerValue.length + 1 + signLength;
                    else if (this.beginPosition > signLength)
                        this.beginPosition = signLength;
                    else
						this.beginPosition = 0;
                    
                    if (!shift)
                        this.endPosition = this.beginPosition;
                }
            }

            this.updateFormat(-1, true, false);
            
            break;
        case 38: // "up-arrow"
			// Con "Ctrl" o "Shift" se comporta como el "home"
			if (!shift && !ctrl)
				break;
        case 36: // "home"
            this.beginPosition = 0;
            
            if (!shift)
                this.endPosition  = 0;
                
            this.updateFormat(-1, true, false);
            
            break;
        case 39: // "forward-arrow"
			this.updateCurrentSelection();
			
            // En caso de haber seleccio'n simplemente se elimna la misma y se posiciona al final
            if ((this.endPosition > this.beginPosition) && !shift)
                this.beginPosition = this.endPosition;
            else
            {
                // No hay seleccio'on
                if (!ctrl)
                {
                    if (this.beginPosition <= (this.integerValue.length + this.sign.length - 1) + (this.nDecs > 0 ? this.decimalValue.length + 1 : 0))
                        this.beginPosition++;

                    if (!shift)
                        this.endPosition = this.beginPosition;
                }
                else
                {
					var signLength = this.sign.length;
					
					if (this.beginPosition < signLength)
						this.beginPosition = signLength;
					else if (this.beginPosition < this.integerValue.length + signLength)
                        this.beginPosition = this.integerValue.length + signLength;
                    else
                        this.beginPosition = this.integerValue.length + signLength + (this.nDecs > 0 ? this.decimalValue.length + 1 : 0);
                    
                    if (!shift)
                        this.endPosition = this.beginPosition;
                }
            }
            
            this.updateFormat(1, true, false);
            
            break;
        case 40: // "down-arrow"
			// Con "Ctrl" o "Shift" se comporta como el "end"
			if (!shift && !ctrl)
				break;
        case 35: // "end"
            this.beginPosition = this.integerValue.length + this.sign.length;
            if (this.nDecs > 0)
				this.beginPosition += this.decimalValue.length + 1;
            
            if (!shift)
                this.endPosition = this.beginPosition;

            this.updateFormat(0, true, false);
            
            break;
        case 46: // "delete"
            if (ctrl)
                break;

            // Se permite el manejo del porta-papeles
            if (shift)
				return true;

			this.updateCurrentSelection();
            if (!this.eraseSelection())
            {
				// Seleccio'n vaci'a

				// Se verifica si se esta' borrando el signo
				if ((this.sign.length == 1) && (this.beginPosition == 0))
				{
					this.sign = "";
					this.beginPosition = this.endPosition = 0;
					this.updateFormat(-1, true, false);
					
					break;
				}
				
				var signLength = this.sign.length;
				
                if (this.beginPosition > this.integerValue.length + signLength)
                    this.decimalValue = this.decimalValue.removeCharAt(this.beginPosition - this.integerValue.length - signLength - 1);
                else
                    if (this.beginPosition == this.integerValue.length + signLength)
                    {
						if (this.monospacedFont && (this.decimalValue.length > 0))
                        {
                            // Se saltea el separador decimal
                            this.endPosition = ++this.beginPosition;
                        }

                        if (!this.monospacedFont)
                        {
							// Se elimina el separador decimal
							this.integerValue += this.decimalValue;
							if (this.integerValue.length > this.nInts)
							{
								if (!this.signed || (this.sign == '-'))
									this.integerValue = this.integerValue.substring(0, this.nInts);
								else
								{
									// En caso de tener signo, si e'ste no es negativo se permite un di'gito ma's
									this.sign = "";
									this.integerValue = this.integerValue.substring(0, this.nInts + 1);
								}
							}

							this.decimalValue = "";
							this.visibleDecimalSep = false;
                        }
                    }
                    else
                        this.integerValue = this.integerValue.removeCharAt(this.beginPosition - signLength);
            }

            this.updateFormat(1, true, false);
            
            break;
        case 190: // "dot"
        case 110: // "keypad dot"
            if (this.nDecs > 0)
            {
		        this.updateCurrentSelection();
                this.eraseSelection();

				if (!this.visibleDecimalSep && !this.monospacedFont)
				{
					// Se agrega el separador decimal en la posicio'n actual
					this.decimalValue = this.integerValue.substring(this.beginPosition - this.sign.length, this.integerValue.length);
					if (this.decimalValue.length > this.nDecs)
						this.decimalValue = this.decimalValue.substring(0, this.nDecs);

					this.integerValue = this.integerValue.substring(0, this.beginPosition - this.sign.length);
				}

				// Se posiciona inmediatamente luego del separador decimal
				this.endPosition = this.beginPosition = this.integerValue.length + 1 + this.sign.length;

				this.visibleDecimalSep = true;
				this.updateFormat(1, true, false);
            }
            
            break;
        case 9: // "tab"
            return true;
        case 106: // "asterisk"
	        this.updateCurrentSelection();

	        this.eraseSelection();

			// Se insertan 3 ceros, no se actualiza el formato ni se elmina la seleccio'n porque eso 
			// se maneja en esta operacio'n
            this.insertDigit('0', false, false);
            this.insertDigit('0', false, false);
            this.insertDigit('0', false, false);

            this.updateFormat(0, true, false);

            break;
        case 109: // "keypad -"
        case 189: // "-"
			// Si ya se consumio' el lugar del signo no se hace nada
			if (this.signed)
			{
		        this.updateCurrentSelection();

		        // En caso de tener seleccionado u'nicamente el di'gito de ma's a la derecha
		        // se sustituye por el signo, si se habi'a utilizado su lugar
		        if (this.integerValue.length == this.nInts + 1)
		        {
					if (((this.beginPosition == 1) && (this.endPosition == 0)) || ((this.beginPosition == 0) && (this.endPosition == 1)))
					{
						this.sign = "-";
						this.endPosition = this.beginPosition = 1;
						this.integerValue = this.integerValue.substring(1, this.integerValue.length);
					}
		        }
		        else
		        {
					// Si estaba al principio se posiciona a continuacio'n del signo, si no no se cambia la posicio'n actual
					if (this.sign.length == 0)
					{
						this.beginPosition++
						this.endPosition++
					}
					else
					{
						if (this.beginPosition == 0)
							this.beginPosition = 1;
						if (this.endPosition == 0)
							this.endPosition = 1;
					}
					
					this.sign = "-";
				}
				
				this.updateFormat(0, true, false);
			}

			break;
        case 107: // "keypad +"
        case 187: // "+"
			// Si ya se consumio' el lugar del signo no se hace nada
			if (this.signed)
			{
		        this.updateCurrentSelection();
		        
		        // En caso de tener seleccionado u'nicamente el di'gito de ma's a la derecha
		        // se sustituye por el signo, si se habi'a utilizado su lugar
		        if (this.integerValue.length == this.nInts + 1)
		        {
					if (((this.beginPosition == 1) && (this.endPosition == 0)) || ((this.beginPosition == 0) && (this.endPosition == 1)))
					{
						this.sign = "+";
						this.endPosition = this.beginPosition = 1;
						this.integerValue = this.integerValue.substring(1, this.integerValue.length);
					}
		        }
		        else
		        {
					// Si estaba al principio se posiciona a continuacio'n del signo, si no no se cambia la posicio'n actual
					if (this.sign.length == 0)
					{
						this.beginPosition++
						this.endPosition++
					}
					else
					{
						if (this.beginPosition == 0)
							this.beginPosition = 1;
						if (this.endPosition == 0)
							this.endPosition = 1;
					}

					this.sign = "+";
				}
				
				this.updateFormat(0, true, false);
			}
			
			break;
        case 67: // "c"
        case 86: // "v"
        case 88: // "x"
			// Se permite el manejo del porta-papeles
			if (ctrl)
				return true;
			
			break;
		case 45: // "insert"
			// Se permite el manejo del porta-papeles
			if (ctrl || shift)
				return true;
			
			break;
		case 65: // "a"
		case 69: // "e"
			if (!ctrl)
				break;
			
			// Se selecciona todo
			this.beginPosition = 0;
			this.endPosition = this.integerValue.length + (this.nDecs > 0 ? this.decimalValue.length + 1 : 0) + this.sign.length;
			
			this.updateFormat(0, true, false);
    }

    return false;
}

// Notifica al campo que se entra en estado de edicio'n.
function nIEnterEditableState()
{
	this.updateCurrentSelection();
	this.updateFormat(0, true, false);
}

// Notifica al campo que se deja el estado de edicio'n.
function nILeaveEditableState()
{
	this.updateFormat(0, false, false);
}

// Notifica al campo que se esta' por enviar su contenido al servidor.
function nIBeforeSubmit()
{
	// Si no hay separadores de miles, y el separador decimal para visualizaci'on es igual al que se debe enviar no se hace nada
	if ((this.thousandSepLength == 0) && ((serverDecimalSeparatorNI == null) || (serverDecimalSeparatorNI == this.decimalSep) || (this.nDecs <= 0)))
	{
		this.valueBeforeSubmit = "";
		return;
	}

	this.valueBeforeSubmit = this.input.value;

	if (this.sign == '+')
		this.sign = '';
	
	// Se eliminan los separadores de miles para evitar problemas con el largo total de los nu'meros en
	// la ida al servidor
	if (this.nDecs > 0)
		this.setValue(this.sign + this.integerValue + (serverDecimalSeparatorNI != null ? serverDecimalSeparatorNI : this.decimalSep) + this.decimalValue);
	else
		this.setValue(this.sign + this.integerValue);
}

// Notifica al campo que se recibio' la respuesta del servidor.
function nIAfterSubmit()
{
	if (this.valueBeforeSubmit != "")
	{
		// Se oculta el DIV con el formato
		this.input.value = this.valueBeforeSubmit;
		this.valueBeforeSubmit = "";
	}
}

/*************************************************
 * END: NumericInputBehavior :: API para eventos *
 *************************************************/
 
/******************************************************
 * BEGIN: NumericInputBehavior :: Internal operations *
 ******************************************************/

// Actualiza los i'ndices de la seleccio'n actual segu'n la u'litma seleccio'n hecha por el usuario.
// Observaciones:
//     - Se debe actualizar el formato luego de la invocacio'n de esta opercio'n, ya que la misma altera
//       el texto mostrado.
function nIUpdateCurrentSelection()
{
    var selectedRange = document.selection.createRange();
    var selectedText = selectedRange.text;
    var c;

	// Si la seleccio'n actual no esta' contenida no se hace nada
	if (!this.input.createTextRange().inRange(selectedRange))
		return;

    // Luego del parche KB2586448 el range no puede tener ma's largo que el input, por eso temproalmente se le suma 1
    var maxLength = this.input.maxLength;
    this.input.maxLength = maxLength + 1;
    
	// Se sustituye en texto seleccionado con un caracter especial para encontrar los i'ndices de la seleccio'n actual
	selectedRange.text = "@";

	var inputText = this.input.createTextRange().text;
	var begin = 0;

	if ((this.sign.length == 0) || (inputText.length == 0) || (inputText.charAt(0) != "@"))
	{
		begin = this.sign.length;

		for (var i = this.sign.length; i < inputText.length; i++)
		{
			c = inputText.charAt(i);
			
			if (c == "@")
			{
				// Si se queda posicionado contiguo a un separador de miles se actualiza la posicio'n relativa
				if ((i < inputText.length + 1) && (inputText.charAt(i + 1) == this.thousandSep))
					this.thousandSepRelativePosition = -1;
				else if ((i > 0) && (inputText.charAt(i - 1) == this.thousandSep))
					this.thousandSepRelativePosition = 1;
				break;
			}

			// Se saltean los caracteres que no sean di'gitos o separador decimal
			if ((c == this.thousandSep) || (c == EditableBlankNI) || (c == NotEditableBlankNI))
				continue;

			begin++;
		}
	}
	
	var end = begin;
	
	for (var i = 0; i < selectedText.length; i++)
	{
		// Se saltean los caracteres que no sean di'gitos o separador decimal
		if ((selectedText.charAt(i) == this.thousandSep) || 
			(selectedText.charAt(i) == EditableBlankNI) || 
			(selectedText.charAt(i) == NotEditableBlankNI))
			continue;

		end++;
	}

	// Si la seleccio'n es exactamente la misma de antes se mantiene los extremos izquiero y derecho de la misma por si se
	// esta' realizando seleccio'n con el teclado, si no se asumiri'a que el extremo izquierdo siempre es el menor
	if (((this.beginPosition != begin) || (this.endPosition != end)) && ((this.beginPosition != end) || (this.endPosition != begin)))
	{
		this.beginPosition = begin;
		this.endPosition   = end;
	}
	
	this.input.maxLength = maxLength;
}

// Inserta un di'gito entero en el campo.
// Para'metros:
//     "digit"  -> Caracter con el di'gito a agregar.
//     "update" -> true para indicar que se actualice el formato, y false en caso contrario.
function nIInsertIntegerDigit(digit, update)
{
	// Si tiene signo visible y adema's esta' posicionado antes que e'ste se corre a la posicio'n 1 para
	// poder agregar el di'gito
	if ((this.beginPosition == 0) && (this.sign.length > 0))
		this.beginPosition = ++this.endPosition;

    if (this.integerValue.length < (this.nInts + (this.signed && (this.sign != '-') ? 1 : 0)))
    {
		if (this.integerValue.length == this.nInts)
		{
			// Se agrega el di'gito
			this.integerValue = this.integerValue.insertCharAt(digit, this.beginPosition - this.sign.length);
			
			// Se actualiza la posicio'n
			if (this.sign.length == 0)
				this.endPosition = ++this.beginPosition;
			else
				this.sign = '';
		}
		else
		{
			// Se agrega el di'gito
			this.integerValue = this.integerValue.insertCharAt(digit, this.beginPosition - this.sign.length);

			// Se actualiza la posicio'n
			this.endPosition = ++this.beginPosition;
		}
    }
    else
    {
        // En caso que desde la posicio'n actual hacia la izquierda hayan solamente ceros se corren
        if ((this.beginPosition > 0) && (this.integerValue.charAt(0) == '0'))
            this.integerValue = this.integerValue.insertCharAt(digit, this.beginPosition - this.sign.length).substring(1, this.nInts + 1 + (this.signed && (this.sign != '-') ? 1 : 0));
    }

	// Si asi' se indico' se reformatea la entrada
	if (update)
		this.updateFormat(0, true, false);
}

// Inserta un di'gito decimal en el campo.
// Para'metros:
//     "digit"  -> Caracter con el di'gito a agregar.
//     "update" -> true para indicar que se actualice el formato, y false en caso contrario.
function nIInsertDecimalDigit(digit, update)
{
    // Se agrega el di'gito
    this.decimalValue = this.decimalValue.insertCharAt(digit, this.beginPosition - this.integerValue.length - this.sign.length - 1).substring(0, this.nDecs);

    // Se actualiza la posicio'n
    if (this.beginPosition <= this.integerValue.length + this.nDecs + this.sign.length)
        this.endPosition = ++this.beginPosition;

	// Si asi' se indico' se reformatea la entrada
	if (update)
		this.updateFormat(0, true, false);
}

// Elimina el contenido de la seleccio'n y la seleccio'n en si' misma del campo.
// Retorno:
//     true si la seleccio'n no era vaci'a, y false en caso que si' lo fuera.
function nIEraseSelection()
{
    var intPart = this.integerValue;
    var begin, end;

    // Si no hay seleccio'n no hay nada que borrar
    if (this.beginPosition == this.endPosition)
        return false;

    if (this.beginPosition < this.endPosition)
	{
		begin = this.beginPosition;
		end   = this.endPosition;
	}
    else
    {
		begin = this.endPosition;
		end   = this.beginPosition;
    }
    
    var signLength = this.sign.length;
    
    if (begin == 0)
		this.sign = "";

    // Luego del borrado ya no hay seleccio'n
    this.beginPosition = this.endPosition = begin;

    // Se elimina la parte correspondiente al valor entero
    if (begin < this.integerValue.length + signLength)
    {
        intPart = this.integerValue.substring(0, begin - signLength);
        
        if (end < this.integerValue.length + signLength)
        {
            this.integerValue = intPart + this.integerValue.substring(end - signLength, this.integerValue.length);
            return true;
        }
	}

	// Se verifica si se elimino' el separador decimal
	if ((end >= this.integerValue.length + 1 + signLength) && !this.monospacedFont && (begin <= this.integerValue.length + signLength))
	{
		this.visibleDecimalSep = false;
        this.integerValue = intPart + this.decimalValue.substring(end - signLength - this.integerValue.length - 1, this.decimalValue.length);
        this.decimalValue = "";
        
        return true;
	}
	
    // Se elimina la parte correspondiente al valor decimal
    if (end > this.integerValue.length + 1 + signLength)
    {
		if (begin <= this.integerValue.length + 1 + signLength)
        {
            this.decimalValue = this.decimalValue.substring(end - signLength - this.integerValue.length - 1, this.decimalValue.length);
            this.integerValue = intPart;
            
            return true;
        }

        begin = begin - this.integerValue.length - signLength - 1;
        end   = end - this.integerValue.length - signLength - 1;
        
        this.decimalValue = this.decimalValue.substring(0, begin) + this.decimalValue.substring(end, this.decimalValue.length);
    }

    this.integerValue = intPart;
    
    return true;
}

// Elimina los valores que haya en el INPUT.
function nIReset()
{
	// Parte entera del nu'mero sin separadores
	this.integerValue = "";
	// Parte decimal del nu'mero sin separadores
	this.decimalValue = "";
	// Posicio'n inicial del a'rea seleccionada
	this.beginPosition = 0;
	// Posicio'n final del a'rea seleccionada
	this.endPosition = 0;
	// Indica la u'ltima posicio'n relativa con respecto a un separador de miles en caso de que el cursor 
	// quede posicionado de forma contigua a uno de e'stos: -1 indica que se debe posicionar a la izquierda, 
	// 1 que se debe posicionar a la derecha. Esto se mantiene porque los separadores de miles son ignorados 
	// desde el punto de vista de la edicio'n
	this.thousandSepRelativePosition = 0;
	// Indica si el separador decimal esta' visible o no, este valor tiene sentido u'nicamente cuando
	// la fuente no es mono-espaciada, ya que si lo fuera, los separadores estari'an siempre visibles
	this.visibleDecimalSep = false;
	// Positivo por defecto
	this.sign = "";
}

// Realiza la seleccio'n indicada sobre el INPUT.
// Para'metros:
//     "begin" -> Primer extremo.
//     "end"   -> Segundo extremo.
// Obervaciones:
//     - Los extremos no tiene por que' estar ordenados.
function nISelect(begin, end)
{
    var textRange = this.input.createTextRange();

    if (begin <= end)
    {
		textRange.moveStart("character", begin);
		textRange.moveEnd("character", end - this.input.value.length);
    }
    else
    {
		textRange.moveStart("character", end);
		textRange.moveEnd("character", begin - this.input.value.length);
    }
    
    this.performSelect(textRange);
}

// Esta funcio'n realiza el select evitando que llamadas al property change. Luego del parche KB2586448 la invocación 
// al input.slect() provca un cambio de property "value".
function nIPerformSelect(textRange)
{
	if (this.valueChangeHandlerDefined)
	{
	    this.updateChangeHandler(false);
	    textRange.select();
	    this.updateChangeHandler(true);
	}
	else
		textRange.select();
}

// Modifica la propiedad "value" del INPUT sin provocar el evento "onpropertychange".
// Para'metros:
//     "value" -> Nuevo valor.
function nISetValue(value)
{
	if (this.valueChangeHandlerDefined)
	{
	    this.updateChangeHandler(false);
		this.input.value = value;
		this.updateChangeHandler(true);
	}
	else
		this.input.value = value;
}

// Actualiza la visualizacio'n del campo mostrando los valores reales con el formato correspondiente.
// Para'metros:
//     "thousandSepRelativePos" -> Indica la u'ltima posicio'n relativa con respecto a un separador de miles en caso de que el cursor 
//                                 quede posicionado de forma contigua a uno de e'stos: -1 indica que se debe posicionar a la izquierda, 
//                                 1 que se debe posicionar a la derecha. Esto se mantiene porque los separadores de miles son ignorados 
//                                 desde el punto de vista de la edicio'n
//     "editableFormat"         -> true para indicar que se esta' editando el campo, y false en caso contrario.
//     "delaySelection"         -> true para indicar que se utilice un "timer" antes de hacer efectiva la selección, y false en caso contrario.
// Observaciones:
//     - En caso que no se este' editando se presentara' el nu'mero sin caracteres extra, simplemente
//       con separadores de miles y separador decimal en caso de tener. En este caso se rellena la parte
//       decimal con ceros y si la parte entera es vaci'a se define con un cero.
function nIUpdateFormat(thousandSepRelativePos, editableFormat, delaySelection)
{
	var i;

	// En caso de dejarse en estado final, es decir no "editable", se agregan ceros para completar si es necesario
	if (!editableFormat)
	{
		if (this.integerValue == "")
		{
			if (this.nInts > 0)
				// Si no hay parte entera se define con un cero
				this.integerValue = "0";
		}
		else
		{
			// Se elminan los ceros extra a la izquierda
			var leftTruncIndex = -1;
			
			// El caracter de ma's a la derecha siempre se mantiene aunque sea un cero
			for (i = 0; i < this.integerValue.length - 1; i++)
			{
				if (this.integerValue.charAt(i) == '0')
					leftTruncIndex = i;
				else
					break;
			}

			// Se mantiene al menos un cero
			if (leftTruncIndex >= 0)
				this.integerValue = this.integerValue.substring(leftTruncIndex + 1, this.integerValue.length);
		}

		// Se completa la parte decimal con ceros a la derecha
		for (i = this.decimalValue.length; i < this.nDecs; i++)
			this.decimalValue += "0";
			
		// El signo de ma's no se muestra porque es el que se toma por defecto
		if (this.signed && (this.sign == "+"))
		{
			this.sign = "";
			this.beginPosition++;
			this.endPosition++;
		}
	}

	// I'ndices reales de la seleccio'n sobre el texto formatedo
    var begin = this.beginPosition;
    var end   = this.endPosition;

    // Valor formateado
	var formatedNumber = "";
	
	var unformatedIndex = this.integerValue.length;
	
	var signLength = this.sign.length;
	
	// Si no hay signo se permite un nuevo di'gito entero, siempre y cuando el nu'mero permitiera la posibilidad de un signo
	var nInts = this.nInts + (this.signed && this.sign == "" ? 1 : 0);

	// Se formatea la parte entera
	for (i = nInts - 1; i >= 0; i--)
	{
		unformatedIndex--;
		
        if (unformatedIndex >= 0)
		    formatedNumber = this.integerValue.charAt(unformatedIndex) + formatedNumber;
		else
		{
			// Por ma's que sea mono-espaciada no se agregan separadores ni espacios extras
			// a la izquierda en caso de tener signo, ya que la usabilidad con e'ste no seri'a clara
			if (this.monospacedFont && !this.signed)
			{
				if (editableFormat)
					formatedNumber = EditableBlankNI + formatedNumber;
				else
					formatedNumber = NotEditableBlankNI + formatedNumber;

			    begin++;
			    end++;
			}
		}

		// Si no se utiliza una fuente mono-espaciada no se
		// agregara'n los separadores de miles a la izquierda de los di'gitos
		// porque la posicio'n de e'stos no puede fijarse
		if ((unformatedIndex <= 0) && (!this.monospacedFont || this.signed))
			break;

		// Se verifica si no se debe agregar un separador de miles
		if ((((nInts - i) % 3) == 0) && (i > 0))
		{
		    if (unformatedIndex + signLength <= this.beginPosition)
		        begin += this.thousandSepLength;

		    if (unformatedIndex + signLength <= this.endPosition)
		        end += this.thousandSepLength;

			// Si no se esta' editando no se agregan separadores de miles extra a la izquierda
			if (!editableFormat && (unformatedIndex <= 0))
				formatedNumber = NotEditableBlankNI + formatedNumber;
			else
				formatedNumber = this.thousandSep + formatedNumber;
		}
	}

    // Se agrega el signo en caso de tener
    if (signLength > 0)
		formatedNumber = this.sign + formatedNumber;

    // Se ajusta la posicio'n relativa con respecto a los separadores de miles
    if ((formatedNumber.length >= begin) && (this.thousandSep != ''))
    {
		// Si no se especifico' posicio'n relativa se usa la definida en el propio control
        if (thousandSepRelativePos == 0)
            thousandSepRelativePos = this.thousandSepRelativePosition;
            
	    if ((thousandSepRelativePos == -1) && (formatedNumber.charAt(begin - 1) == this.thousandSep))
	    {
	        if (begin == end)
	            end = --begin;
	        else
	            begin--;
	    }
	    else if ((thousandSepRelativePos == 1) && (formatedNumber.charAt(begin) == this.thousandSep))
	    {
	        if (begin == end)
	            end = ++begin;
	        else
	            begin++;
	    }
	}

	// Se formatea la parte decimal
	// Si no se utiliza una fuente mono-espaciada no se agrega punto decimal a menos
	// que haya di'gitos para agregar luego
	if ((this.nDecs > 0) && (this.monospacedFont || (this.decimalValue.length > 0) || this.visibleDecimalSep))
	{
        // Se agregan los decimales
		if (this.decimalSep.length == 1)
			formatedNumber += this.decimalSep + this.decimalValue;
		else
			formatedNumber += "." + this.decimalValue;		

		// Se completan los espacis en blanco, en caso de estar en estado no editable no
		// va a haber lugar porque ya se completo' con ceros, por eso no se verifica
		// si completar con "EditableBlankNI" o "NotEditableBlankNI"
		if (this.monospacedFont)
			for (i = this.decimalValue.length; i < this.nDecs; i++)
				formatedNumber += EditableBlankNI;
    }

	// Se define el valor con formato
	this.setValue(formatedNumber);

	// Se realiza la seleccio'n concreta solamente si el campo tiene el foco, es decir si se esta' editando
	if (editableFormat)
	{
		if (!delaySelection)
		{
			this.select(begin, end);
			return;
		}

		// Se demora la seleccio'n
		var behavior = this;
		var sel = function()
		{
			behavior.select(begin, end);
		}
		
		setTimeout(sel, 1);
	}
}

/*********
 * CLONE *
 *********/
 
 // Clona el comportamiento de forma de poder ser utilizado ante un "cloneNode" (ver agregado de filas en grillas "generalutils")
 function nICloneBehavior(input)
 {
    nIApplyNumericBehavior(input, this.nInts, this.nDecs, this.thousandSep, this.decimalSep, this.signed, true);
 }

/****************************************************
 * END: NumericInputBehavior :: Internal operations *
 ****************************************************/

// Constructor de objetos encargados de almacenar la informacio'n extra
// y definir el comportamiento de un INPUT de tipo nume'rico.
// Para'metros:
//     "input"          -> Objeto de tipo INPUT al cual se le asocia la informacio'n extra.
//     "nInts"          -> Cantidad de di'gitos enteros de los nu'meros a ingresar.
//     "nDecs"          -> Cantidad de di'gitos decimales de los nu'meros a ingresar.
//     "thousandSep"    -> Separador de miles.
//     "decimalSep"     -> Separador decimal.
//     "signed"         -> true para indicar que el campo tiene signo, y false para indicar lo contrario.
//     "monospacedFont" -> true para indicar si el INPUT asociado utiliza una fuente mono-espaciada, y false
//                         para indicar lo contrario.
//     "detachEvents"   -> true para indicar que se eliminen los eventos que pudiera tener previamente (es para el clonado de INPUT's)
function NumericInputBehavior(input, nInts, nDecs, thousandSep, decimalSep, signed, monospacedFont, detachEvents)
{
	// Se verifica la viabilidad
    if (input.createTextRange() == null)
    {
        alert("Ocurri\u00F3 un error al aplicar el estilo num\u00E9rico a un campo, no se aplicar\u00E1 dicho formato.");
        this.input = null;
        return;
    }

	// Para'metros
	this.input          = input;
	this.thousandSep    = thousandSep;
	this.decimalSep     = decimalSep;
	this.nInts          = nInts;
	this.nDecs          = nDecs;
	this.signed         = signed;
	this.monospacedFont = monospacedFont;
	
	// Largo del separador de miles
	this.thousandSepLength = thousandSep.length;
	// Parte entera del nu'mero sin separadores
	this.integerValue = "";
	// Parte decimal del nu'mero sin separadores
	this.decimalValue = "";
	// Posicio'n inicial del a'rea seleccionada
	this.beginPosition = 0;
	// Posicio'n final del a'rea seleccionada
	this.endPosition = 0;
	// Indica la u'ltima posicio'n relativa con respecto a un separador de miles en caso de que el cursor 
	// quede posicionado de forma contigua a uno de e'stos: -1 indica que se debe posicionar a la izquierda, 
	// 1 que se debe posicionar a la derecha. Esto se mantiene porque los separadores de miles son ignorados 
	// desde el punto de vista de la edicio'n
	this.thousandSepRelativePosition = 0;
	// Indica si el separador decimal esta' visible o no, este valor tiene sentido u'nicamente cuando
	// la fuente no es mono-espaciada, ya que si lo fuera, los separadores estari'an siempre visibles
	this.visibleDecimalSep = false;
	// Positivo por defecto
	this.sign = "";
	
	    // Se definen los manjadores de eventos que permiten el comportamiento deseado
	if (detachEvents)
	{
	    input.detachEvent("onkeydown", nIOnkeydownHandler);
	    input.detachEvent("oncopy", nIOncopyHandler);
	    input.detachEvent("oncut", nIOncutHandler);
	    input.detachEvent("onpaste", nIOnpasteHandler);
	    input.detachEvent("onblur", nIOnblurHandler);
	    input.detachEvent("onfocusin", nIOnfocusinHandler);
	    input.detachEvent("ondrag", new Function("return false;"));
	    this.updateChangeHandler(false);
	}
	
    input.attachEvent("onkeydown", nIOnkeydownHandler);
    input.attachEvent("oncopy", nIOncopyHandler);
    input.attachEvent("oncut", nIOncutHandler);
    input.attachEvent("onpaste", nIOnpasteHandler);
    input.attachEvent("onblur", nIOnblurHandler);
    input.attachEvent("onfocusin", nIOnfocusinHandler);
    // Se bloquea el arrastrado
    input.attachEvent("ondrag", new Function("return false;"));
    this.updateChangeHandler(true);
    // Este propiedad indica si el manejador ante cambios de la propiedad "value" del campo
    // esta asociado o no, se desasocia al momento de cambiar el valor desde co'digo interno
    // para evitar que se hagan infinitas llamadas recursivas
	this.valueChangeHandlerDefined = true;

	// Se definen el estilo particular para este comportamiento
	nISetStyleProperties(input);

	// Se ajusta el largo ya que internamente se necesita un caracter ma's por el hecho del '@' 
	// utilizado para detectar la seleccio'n; de todas formas el usuario nunca va a poder
	// agregar caracteres dema's porque es controlado por co'digo
	input.maxLength = nInts + (Math.floor((nInts - 1) / 3) * this.thousandSepLength) + (nDecs > 0 ? nDecs + 1 : 0) + (signed ? 1 : 0) + 1;

	// Se quitan los eventos definidos por defecto
	input.onblur = null;
	input.onfocus = null;
	
	// Se define el evento e nivel del formulario que quitara' el formato especial a los campos antes
	// de ir al servidor
	// Se define esta propiedad "beforeSubmit" porque el ".submit()" por co'digo no invoca al evento "onsubmit"
	// de esta manera se llama al "evento" de forma si'ncrona
	input.form.beforeSubmit = nIOnsubmitFormHandler;
	// Luego de recibir la respuesta (si llega en una ventana distinta) se pos-procesan los campos
	input.form.afterSubmit = nIOnafterSubmitFormHandler;
	
	// Se redefine el "focus"
	input.focus = nIFocus;
	
	this.valueBeforeSubmit = "";
}

// API interna
NumericInputBehavior.prototype.updateFormat              = nIUpdateFormat;
NumericInputBehavior.prototype.updateCurrentSelection    = nIUpdateCurrentSelection;
NumericInputBehavior.prototype.insertIntegerDigit        = nIInsertIntegerDigit;
NumericInputBehavior.prototype.insertDecimalDigit        = nIInsertDecimalDigit;
NumericInputBehavior.prototype.eraseSelection            = nIEraseSelection;
NumericInputBehavior.prototype.select                    = nISelect;
NumericInputBehavior.prototype.setValue                  = nISetValue;
NumericInputBehavior.prototype.performSelect             = nIPerformSelect;
NumericInputBehavior.prototype.updateChangeHandler       = nIUpdateChangeHandler;
// API para eventos
NumericInputBehavior.prototype.insertDigit               = nIInsertDigit;
NumericInputBehavior.prototype.processNonDigit           = nIProcessNonDigit;
NumericInputBehavior.prototype.getUnformatedSelectedText = nIGetUnformatedSelectedText;
NumericInputBehavior.prototype.beforeSubmit              = nIBeforeSubmit;
NumericInputBehavior.prototype.afterSubmit               = nIAfterSubmit;
NumericInputBehavior.prototype.insertFormatedText        = nIInsertFormatedText;
NumericInputBehavior.prototype.leaveEditableState        = nILeaveEditableState;
NumericInputBehavior.prototype.enterEditableState        = nIEnterEditableState;
NumericInputBehavior.prototype.reset                     = nIReset;
// Se utiliza desde la clonacio'n de filas de las grillas para el agregado desde el cliente
NumericInputBehavior.prototype.cloneBehavior             = nICloneBehavior;

// Funcio'n que redefine el me'todo "focus" en el INPUT nume'rico.
// Es utilizada para que cuando se defina el foco por co'digo quede todo seleccionado.
function nIFocus()
{
	// Se selecciona todo
	this.behavior.beginPosition = 0;
	this.behavior.endPosition = this.behavior.integerValue.length + 
								(this.behavior.nDecs > 0 ? this.behavior.decimalValue.length + 1 : 0) + 
								this.behavior.sign.length;
	this.behavior.updateFormat(0, true, false);
}

var serverDecimalSeparatorNI = null;

// Aplica el comportamiento de campo nume'rico al INPUT indicado con los para'metros dados.
// Para'metros:
//     "input"        -> INPUT al que se le aplicara' el formato nume'rico.
//     "nInts"        -> Cantidad de di'gitos enteros de los nu'meros a ingresar.
//     "nDecs"        -> Cantidad de di'gitos decimales de los nu'meros a ingresar.
//     "thousandSep"  -> Separador de miles, cadena de largo 1 o 0 en caso de no querer separador.
//     "decimalSep"   -> Separador decimal, cadena de largo 1.
//     "signed"       -> true para indicar que el campo tiene signo, y false en caso contrario.
//     "detachEvents" -> indica si se deben desasociar eventos previos o no. Si se viene de una clonacio'n se deben eliminar dichos eventos.
function nIApplyNumericBehavior(input, nInts, nDecs, thousandSep, decimalSep, signed, detachEvents)
{
	if ((input != null) && (input.type != 'hidden'))
	{
		var value = input.value;
		var validation = input.onblur;

		// Se quita el valor antes de inicilizar el comportamiento para evitar que se ejecute el evento "onpropertychange"
		input.value = "";
		
		// El u'ltimo para'metro indica si se utilizara' una fuente mono-espaciada o no,
		// esto afecta el comportamiento del control ya que en caso de utilizarse se pueden
		// completar con todos los separadores de miles a la izquierda y mantener
		// la posicio'n del punto decimal
		var behavior = input.behavior = new NumericInputBehavior(input, nInts, nDecs, thousandSep, decimalSep, signed, false, detachEvents);

		// Si se inicializo' correctamente se setea el valor inicial del INPUT
		if (behavior.input != null)
		{
			// Si no hay decimales la funcio'n que realiza el control es otra, por lo tanto no se debe evaluar la validacio'n
			if ((nDecs > 0) && (serverDecimalSeparatorNI == null))
			{
				var temp = valid_decimal;
				
				// Se utiliza el co'digo de validacio'n generado por GX para obtener el separador decimal esperado por el mismo
				// ya que el "value" siempre utiliza el punto
				valid_decimal = function(elem,thSep,decSep,nDecs){serverDecimalSeparatorNI = decSep;}

				try
				{
					validation();
				}
				catch (e) {}
				
				valid_decimal = temp;
			}

			if (serverDecimalSeparatorNI != null)
			{
				// Se cambia el separador decimal del servidor por el que se utilizara' para la visualizacio'n
				value = value.replace(serverDecimalSeparatorNI, decimalSep);
			}

			behavior.insertFormatedText(value, document.activeElement == input, false);

            // Se copia el valor original porque si el evento del seteo de foco se sobrescribe y si se necesita
            // controlar los cambios (grillas editables), se necesita tener inicializado "oriValue" al valor original
		    input.oriValue = input.value;
		}
		else
			input.value = value;
	}
}

// API externa

// Aplica el comportamiento de campo nume'rico al INPUT indicado con los para'metros dados.
// Para'metros:
//     "inputId"     -> Identificador del INPUT al que se le aplicara' el formato nume'rico.
//     "nInts"       -> Cantidad de di'gitos enteros de los nu'meros a ingresar.
//     "nDecs"       -> Cantidad de di'gitos decimales de los nu'meros a ingresar.
//     "thousandSep" -> Separador de miles, cadena de largo 1 o 0 en caso de no querer separador.
//     "decimalSep"  -> Separador decimal, cadena de largo 1.
//     "signed"      -> true para indicar que el campo tiene signo, y false en caso contrario.
function applyNB(inputId, nInts, nDecs, thousandSep, decimalSep, signed)
{
	var input = document.getElementById(inputId);

	// Se ajustan los separadores segu'n la configuracio'n global
	thousandSep = findGlobalThoSep(thousandSep);
	decimalSep = findGlobalDecSep(decimalSep);

	// Se recuerda esto para diferenciar el manejo de teclado
	input.insideGrid = "maybe";
	
	// Se aplica en formato
	nIApplyNumericBehavior(input, nInts, nDecs, thousandSep, decimalSep, signed, false);
}

// API externa

// Aplica el comportamiento de campo nume'rico al todos los INPUT's de una columna de una grilla.
// Para'metros:
//     "inputId"     -> Prefijo de identificadores de los INPUT's a los que se le aplicara' el formato nume'rico.
//     "nInts"       -> Cantidad de di'gitos enteros de los nu'meros a ingresar.
//     "nDecs"       -> Cantidad de di'gitos decimales de los nu'meros a ingresar.
//     "thousandSep" -> Separador de miles, cadena de largo 1 o 0 en caso de no querer separador.
//     "decimalSep"  -> Separador decimal, cadena de largo 1.
//     "signed"      -> true para indicar que el campo tiene signo, y false en caso contrario.
function applyColNB(inputId, nInts, nDecs, thousandSep, decimalSep, signed)
{
	var input, postfix;

	// Se ajustan los separadores segu'n la configuracio'n global
	thousandSep = findGlobalThoSep(thousandSep);
	decimalSep = findGlobalDecSep(decimalSep);

	// Se recorren todos los campos mientras haya alguno
	for (var i = 1; i < 1000; i++)
	{
		// Se consigue el posfijo
        postfix = i < 10 ? "_000" + i : (i < 100 ? "_00" + i : "_0" + i);
		
		input = document.getElementById(inputId + postfix);
		
		if (input == null)
			break;

        // Se recuerda esto para diferenciar el manejo de teclado		
		input.insideGrid = "maybe";	// Se inicializa en "maybe" (y no en "yes") porque hay pantallas no generadas que utilizan esta funcio'n con 
									// campos de grillas de estilo libre
		
		// Se aplica en formato	
		nIApplyNumericBehavior(input, nInts, nDecs, thousandSep, decimalSep, signed, false);
	}
}