function pfOnKeyDown(i)
{            
    if ((event.keyCode == 46) || (event.keyCode == 8))
    {
        // Borra el campo        
        var field = event.srcElement;
        pfClear(field);
        event.returnValue = false;
        event.cancels = true;
    }
    else if (event.keyCode == 13)    
    {
        event.returnValue = false;
        event.cancels = true;
        
        var field = event.srcElement;
        var hiddenField = document.getElementById(field.phidden);
        hiddenField.value += String.fromCharCode(event.keyCode);            
    }
    else if (event.keyCode < 32)
    {        
        event.returnValue = false;
        event.cancels = true;
    }    
}

function pfOnKeyPress()
{    
    var field = event.srcElement;
    
    if (event.keyCode >= 32)
    {
        event.returnValue = false;        

        // Agrega la tecla presionada en el texto del campo oculto, e ignora la tecla
        var hiddenField = document.getElementById(field.phidden);
        var oldValue = hiddenField.value;
        hiddenField.value += String.fromCharCode(event.keyCode);                   
            
        // Crea un temporizador para marcar que el campo está cargado, ya que
        // suele demorar algunos segundos en leer toda la tarjeta            
        field.waitingForInput = true;            
        clearTimeout(field.filledTimer);
        field.filledTimer = setTimeout("pfOnFilledTimeout('" + field.id + "','" + field.phidden + "')", parseInt(field.preadtime) * 1000);
        
        // Asignamos el estilo que indica que se está leyendo el valor
        pfSetStyle(field);        
    }
}

function pfOnFilledTimeout(fieldId, hiddenFieldId)
{
    // Verificamos que el campo oculto no esté vacío
    var hiddenField = document.getElementById(hiddenFieldId);
    if ((hiddenField != null) && (typeof(hiddenField) != "undefined"))
    {
        var field = document.getElementById(fieldId);       
        field.waitingForInput = false;
    
        if (hiddenField.value != "")
        {
            // Asignamos el estilo que indica que el campo se ha completado            
            pfSetStyle(field);
        }
    }
}

function pfOnGotFocus()
{
    var field = event.srcElement;

    // Actualizamos el estilo
    pfSetStyle(field)
}

function pfOnLostFocus()
{
    var field = event.srcElement;
        
    // Actualizamos el estilo
    pfSetStyle(field)
}

function pfClear(field)
{
    // Borra el contenido del campo
    document.getElementById(field.phidden).value = "";
    
    // Asigna el estilo que corresponde    
    pfSetStyle(field)
}

function pfSetStyle(field)
{
    try
    {
        var hasFocus = (document.activeElement == field);
    }
    catch (Exception)
    {
        var hasFocus = false;
    }
    
    // Verifica si se está leyendo el valor   
    if ((field.waitingForInput) && (parseInt(field.preadtime) > 0))
    {
        // Se está leyendo el valor
        field.value = "Leyendo el valor...espere, por favor";
        field.style.color = "#303030";                     
        field.style.backgroundColor = "#FFFFEA";
    }
    else
    {
        // Verifica si hay algún valor en el campo oculto        
        var fieldValue = document.getElementById(field.phidden).value;
        var emptyValue = (fieldValue == "");
        if (emptyValue) 
        {
            if (hasFocus)
            {
                // El campo tiene el foco y no se cargó aún un valor
                field.value = field.pfocused;                      
                field.style.color = "#303030";            
                field.style.backgroundColor = "#FFFFEA";
            }
            else
            {
                // El campo no tiene el foco ni se cargó un valor
                field.value = field.pnotfocused;                
                field.style.color = "#600000";    
                field.style.backgroundColor = "#FFF0F0";
            }    
        }
        else
        {
            var line2Text = field.pline2;
            var setLine2 = false;
            
            if ((typeof(line2Text) != "undefined") && (line2Text != ""))
            {
                // El control tiene un texto para la segunda línea, si el campo tiene dos lineas
                // muestra este texto
                var k = fieldValue.indexOf('\n');
                if (k != -1)
                {
                    k = fieldValue.indexOf('\n', k + 1);                    
                    if (k == -1)
                        setLine2 = true;
                }
            }
        
            if (setLine2)
            {
                // Se debe ingresar la segunda linea
                field.value = line2Text;                      
                field.style.color = "#303030";            
                field.style.backgroundColor = "#FFFFEA";               
            }
            else
            {
                // El campo tiene un valor asignado
                field.value = field.pfilled;
                field.style.color = "#003000";      
                field.style.backgroundColor = "#EAFFEA";
            }
        }
    }
       
    if (hasFocus)
    {
        // Deja el cursor luego del último carácter
        setSelectionRange(field, field.value.length, field.value.length);
    }
} 

function setSelectionRange(input, selectionStart, selectionEnd) 
{
    if (input.createTextRange) 
    {
        var range = input.createTextRange();
        range.collapse(true);
        range.moveEnd('character', selectionEnd);
        range.moveStart('character', selectionStart);
        range.select();
    }
    else if (input.setSelectionRange) 
    {
        input.focus();
        input.setSelectionRange(selectionStart, selectionEnd);
    }
}