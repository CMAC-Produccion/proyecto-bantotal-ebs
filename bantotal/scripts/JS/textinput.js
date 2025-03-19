var TextInputManager = 
{
    _KeydownHandler: function(e)
    {
        // El caso ti'pico de insercio'n caracter a caracter se bloquea con esta funcio'n que se ejecuta antes de procesada
        // la tecla, en caso contrario siempre seri'a visible en truncado

        if (!e)
            e = window.event;

        var code = e.keyCode;
        var textArea = e.srcElement;

        if (removeOperationShortcuts(code, false))
            return false;

        // Alt + F4
        if ((code == 115) && (e.altKey))
            return true;

        // Se permite cualquier combinacio'n alt ya que no redundara'n en una insercio'n directa
        if (e.altKey)
            return true;

        // Se permite cualquier combinacio'n ctrl (salvo ctrl + 'c') ya que no redundara'n en una insercio'n directa
        if (e.ctrlKey && (code != 86))
            return true;
        
        // Caracteres de control
        if ((code >= 16) && (code <= 18))
            return true;

        // Teclas de funcio'n
        if ((code >= 112) && (code <= 123))
            return true;    

        // Se evita que se propague de forma de que no lo tome el manejador base
        e.cancelBubble = true;

        if (textArea.value.length < textArea.maxLength)
            return true;

        // Si hay algo seleccionado no se bloque
        var selectedRange = document.selection.createRange();
        if (selectedRange && (selectedRange.text != ""))
            return true;

        // 36 "home"            
        // 37 "back-arrow"
        // 38 "up-arrow"
        // 39 "forward-arrow"
        // 40 "down-arrow"
        if ((code >= 36) && (code <= 40))
            return true;

        switch (code)
        {
            case 45: // "insert" (salvo pegado del portapaleles)
                if (e.shiftKey)
                    break;
            case 8:  // "back-space"
            case 9:  // "tab"
            case 35: // "end"
            case 46: // "delete"
                return true;
        }

        // No hay ma's espacio, se cancela completamente
        e.cencelBubble = true;
        return false;
    },
    
    _KeyupHandler: function(e)
    {
        // Los casos que no se logran manejar se corrigen aqui' truncando

        if (!e)
            e = window.event;

        TextInputManager._TruncateIfNeeded(e.srcElement);
    },
    
    _PasteHandler: function(e)
    {
        if (!e)
            e = window.event;

        // En caso que se pegue desde con el rato'n
        var element = e.srcElement;
        var f = function()
        {
            TextInputManager._TruncateIfNeeded(element);
        };
        setTimeout(f, 1);
    },
    
    _TruncateIfNeeded: function(textArea)
    {
        if (textArea.value.length > textArea.maxLength)
            textArea.value = textArea.value.substring(0, textArea.maxLength);
    },
    
    ApplyTB: function(textAreaId, length)
    {
        var textArea = document.getElementById(textAreaId);
        if (!textArea || (textArea.tagName != "TEXTAREA"))
            return;
        
        textArea.maxLength = length;
        textArea.onkeydown = this._KeydownHandler;
        textArea.onkeyup = this._KeyupHandler;
        textArea.onpaste = this._PasteHandler;

        // Se eliminan los manejadores de GxX
        textArea.onblur = null;
        textArea.onchange = null;
        textArea.removeAttribute("onfocus");
        
        this._TruncateIfNeeded(textArea);
    }
};

function applyTB(textAreaId, length)
{
	TextInputManager.ApplyTB(textAreaId, length);
}