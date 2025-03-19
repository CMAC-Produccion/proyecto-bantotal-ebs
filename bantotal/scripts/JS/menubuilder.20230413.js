// Posiciones en el arreglo con los datos de cada entrada de menu' utilizados para la creacio'n a demanda
var TextPos = 0;
var LinkPos = 1;
var TypePos = 2;
var InitPos = 3;

// Creador del menu'
function mBInitMenu()
{
	this.baseElement = document.getElementById("menuBase");

	// Se elmina el menu' anterior en caso de existir
	while (this.baseElement.firstChild != null)
		this.baseElement.removeChild(this.baseElement.firstChild);

	this.rootDiv = document.createElement("<DIV CLASS='menuBar'>");
	this.baseElement.innerHTML = '';
	this.baseElement.appendChild(this.rootDiv);
}

// 'caption' -> etiqueta del boto'n del menu'
// 'initializer' -> nombre de l afunctio'n encargada de la inicializacio'n del submenu' de este boto'n
function mBAddButton(caption, initializer)
{
	// Se crea un nodo de nivel 0
	element = document.createElement("<A CLASS='menuButton' STYLE='z-index: 199'>");

	// Se asocian los eventos
	element.attachEvent("onmousedown", hBMousedown);
	element.attachEvent("onmouseout", hBMouseout);
	element.attachEvent("onmouseup", hBMouseup);
	element.attachEvent("onclick", hBClick);
	element.attachEvent("onmouseover", hBMouseover);

	// No es el boto'n que guarda el u'ltimo acceso
	element.refreshLast = 1;

	// Se asocia el inicializador
	element.init = initializer;

	// El boto'n corresponde a nivel -1, ya que su primer sub-menu' sera' el primer nivel importante, es decir el 0
	// Este valor solo es usado en la inicializacio'n de los sub-menu'es directos de los botones
	element.level = -1;

	element.insertAdjacentHTML('afterBegin', caption);

	// El menu' se creara' a demanda
	element.menu = null;

	// Al segundo boto'n (accesos) se le definen accesos directos con el teclado
	this.buttonCount++;
	element.includeAcceleratorKey = this.buttonCount == 2;

	this.rootDiv.appendChild(element);
	
	// Se inicializa este menu' por los accesos directos
	if (element.includeAcceleratorKey)
		this.initLevel(element);
}

function mBInitLevel(element)
{
	var items = eval(element.init + "()");
	var level = element.level;

	element.menu = document.createElement("<DIV STYLE='z-index:" + (201 + level) + "' CLASS='menu'>");
	// En esta propiedad se almacenar� el u'ltimo item activo
	element.menu.lastActive = null;
	
	// Se define el item padre
	element.menu.parentItem = element;
	
	// Au'n no hay nada activo
	element.menu.activeElement = null;
	
	this.baseElement.appendChild(element.menu);
	
	// Se crea un IFRAME de manera de que no se transluzcan los controles con ventana, como por ejemplo los SELECT
	element.cover = this.baseElement.appendChild(document.createElement("<IFRAME STYLE='display: none; position: absolute; z-index:" + (200 + level) + "' SCROLLING='no' FRAMEBORDER='0' SRC='javascript:\"\"'>"));

	var auxSeparatorsForShortcuts;
	
	if (element.includeAcceleratorKey && (this.keyAttachFunction != null))
		auxSeparatorsForShortcuts = new Array();

	for (var i = 0; i < items.length; i++)
	{
		var item = items[i];

		if (item[InitPos] != null)
		{
			// Sub-menu'

			// El tipo 1 indica una entrada con sub-menu'
			var sub = document.createElement("<A HREF='javascript:;' TYPE='1' CLASS='menuItem' STYLE='z-index:" + (200 + level) + "'>");
			
			// Se asocian los eventos
			sub.attachEvent("onmouseout", hIMouseout);
			sub.attachEvent("onmouseover", hIMouseover);
			sub.attachEvent("onclick", hIClick);

			// Se agrega el texto del menu'
			sub.insertAdjacentHTML('afterBegin', item[TextPos]);

			// Se agrega la flecha, elemento adema's necesario para que el navegador calcule bien los anchos
			sub.appendChild(this.getArrow());

			// Se define el nivel del sub-menu' a partir del nivel del menu' padre
			sub.level = level + 1;

			// El sub-menu' se crea a demanda
			sub.menu = null;

			// Se referencia el inicializador del sub-menu' de este elemento
			sub.init = item[InitPos];

			element.menu.appendChild(sub);
		}
		else
		{
			// Hoja

			var text = item[TextPos];
			
			// Se comprueba que no se trate de un separador
			if ((text.length > 0) && (text.charAt(0) == '-'))
			{
				this.addSeparator(element.menu);

				continue;
			}

			// El tipo 0 indica que es una hoja
			var leaf = document.createElement("<A ONFOCUS='this.hideFocus=true;return false;' CLASS='menuLeaf' TYPE='0' STYLE='z-index:" + (200 + level) + "' HREF='javascript:;'>");

			// Se asocian los eventos
			leaf.attachEvent("onmouseup", hLMouseup);
			leaf.attachEvent("onmouseover", hLMouseover);
			leaf.attachEvent("onmouseout", hLMouseout);

			// Se recuerdan las propiedades del "link" asociado a la hoja
			leaf.linkType = item[TypePos];
			leaf.link = item[LinkPos];

			// Se define el nivel de la hoja a partir del nivel del menu' padre
			leaf.level = level + 1;

			leaf.insertAdjacentHTML('afterBegin', text);
			
			if (element.includeAcceleratorKey && (this.keyAttachFunction != null))
			{
				// Esta' dentro de los accesos, se agregan accesos directos del teclado
				var sp = document.createElement("<SPAN CLASS='shortcutSeparator'>");
				
				// Por las dudas que haya ma's de 6 accesos directos desde el teclado, en cuyo caso se utilizar'a el Shift, se almacenan
				// referencias a los separadores para aumentarles en margen a posteriori
				
				if (this.acceleratorIndex <= 11)
					auxSeparatorsForShortcuts.push(sp);
				else if (this.acceleratorIndex == 12)
				{
					// Se ajustan los ma'rgenes previos
					for (var q = 0; q < auxSeparatorsForShortcuts.length; q++)
						auxSeparatorsForShortcuts[q].style.marginLeft = "62px";
					
					auxSeparatorsForShortcuts.length = 0;
				}
					
				leaf.appendChild(sp);

				// Se necesita este elemento para que el navegador calcule bien los anchos
				leaf.appendChild(this.getLeafComp(true, leaf));
			}
			else
				leaf.appendChild(this.getLeafComp(false, null));

			element.menu.appendChild(leaf);
		}
	}
}

// Agrega una li'nea como separador.
function mBAddSeparator(element)
{
	if (this.separatorSample == null)
	{
		this.separatorSample = document.createElement("<DIV CLASS='menuItemSep'>");
		element.appendChild(this.separatorSample);
	}
	else
		element.appendChild(this.separatorSample.cloneNode(false));
}

// Template para los elementos que representan las felchas de accseso a sub-menu's.
function mBGetArrow()
{
	if (this.arrowSample == null)
	{
		this.arrowSample = document.createElement("<IMG CLASS='arrow' SRC='images/arrow.gif'>");
		return this.arrowSample;
	}
	
	return this.arrowSample.cloneNode(false);
}

// Template para los elementos que sirven como complemento del ancho para las hojas.
function mBGetLeafComp(addKeyAccelerator, leaf)
{
	// F11 es la u'litma tecla de funcio'n libre
	if (addKeyAccelerator && (this.acceleratorIndex < 23))
	{
		var result = document.createElement("<A CLASS='leafCompementWithShortcut'>");
			
		if (this.acceleratorIndex == 0)
		{
			// Se comienza con F6
			this.acceleratorIndex = 6;
		}

		this.keyAttachFunction(this.acceleratorIndex, leaf.link, leaf.innerText, leaf.linkType);
		
		if (this.acceleratorIndex <= 11)
		{
			var key = 'F' + this.acceleratorIndex++;
			result.insertAdjacentText('afterBegin', key);
		}
		else
		{
			// Se utiliza el Shift y se comienza del F2
			var key = 'Shift+F' + (this.acceleratorIndex++ - 10);
			result.insertAdjacentText('afterBegin', key);
		}
		
		return result;
	}

	if (this.leafCompSample == null)
	{
		this.leafCompSample = document.createElement("<A CLASS='leafComplement' STYLE='visibility: hidden'>");
		return this.leafCompSample;
	}
		
	return this.leafCompSample.cloneNode(false);
}

// Funcio'n para el manejo del u'ltimo accedido
function mBAddLastAccessed(text, element)
{
	if (this.firstTime)
	{
		this.firstTime = false;
		this.separator.innerHTML = "::";
	}
	this.lastAccessedMenu.innerHTML = text;
	this.lastAccessedMenu.menu = element;
	this.lastAccessedMenu.style.display = 'inline';
}

function mBEndMenu()
{
	this.separator = this.rootDiv.appendChild(document.createElement("<A CLASS='menuButton'>"));

	// Se crea un nodo de nivel 0
	var element = this.lastAccessedMenu = this.rootDiv.appendChild(document.createElement("<A CLASS='menuButton' STYLE='z-index: 199; display: none;'>"));

	// Es el boto'n de u'ltimo acceso, por lo tanto el nivel de su sub-menu' va a variar, este valor nunca es consultado
	element.level = -1;
	
	// Es el boto'n que guarda el u'ltimo acceso, por lo tanto no se actualiza a si mismo
	element.refreshLast = 0;

	// Se asocian los eventos
	element.attachEvent("onmousedown", hBMousedown);
	element.attachEvent("onmouseout", hBMouseout);
	element.attachEvent("onmouseup", hBMouseup);
	element.attachEvent("onclick", hBClick);
	element.attachEvent("onmouseover", hBMouseover);

	// Se crea un IFRAME de manera de que no se transluzcan los controles con ventana, como por ejemplo los 'SELECT'
	this.lastAccessedMenu.cover = this.baseElement.appendChild(document.createElement("<IFRAME STYLE='display: none; position: absolute; z-index: 200' SCROLLING='no' FRAMEBORDER='0' SRC='javascript:\"\"'>"));

	// Se crea un DIV que se encargara' de posicionarse delante de las pa'ginas externas de forma de poder capturar cualquier
	// accio'n con el rato'n o teclado sobre ella. En particular no hay otra forma de capurar el "scroll" de forma de cerrar el menu'
	// Se define un color de fondo porque si no no se muestra el DIV
	this.externalCover = document.createElement('<DIV STYLE="background-color: #FFFFFF; filter: alpha(opacity=0); position: absolute; z-index: 150;">');
	this.externalCover.attachEvent("onactivate", coverActivate);
}

// Definicio'n de la clase responsable de crear el menu'
function MenuBuilder(keyAttachFunction)
{
	this.rootDiv = null;
	this.baseElement = null;
	this.firstTime = true;
	this.lastAccessedMenu = null;
	this.separator = null;
	this.leafCompSample = null;
	this.arrowSample = null;
	this.separatorSample = null;
	this.externalCover = null;
	this.coverPlaced = false;
	this.acceleratorIndex = 0;
	this.buttonCount = 0;
	this.keyAttachFunction = keyAttachFunction;
}

MenuBuilder.prototype.addButton = mBAddButton;
MenuBuilder.prototype.initLevel = mBInitLevel;
MenuBuilder.prototype.getArrow = mBGetArrow;
MenuBuilder.prototype.getLeafComp = mBGetLeafComp;
MenuBuilder.prototype.initMenu = mBInitMenu;
MenuBuilder.prototype.endMenu = mBEndMenu;
MenuBuilder.prototype.addLastAccessed = mBAddLastAccessed;
MenuBuilder.prototype.addSeparator = mBAddSeparator;
MenuBuilder.prototype.placeCover = placeCov;
MenuBuilder.prototype.removeCover = removeCov;

var mBuilder = new MenuBuilder(attachKey);

// Funciones auxiliares para manejar eventos de botones
function hBMousedown()
{

		var elem = window.event.srcElement;

		// Se realiza la inicializacio'n a demanda
		if (elem.menu == null)
			mBuilder.initLevel(elem);

		bMousedown(elem, elem.refreshLast);

}

function hBClick()
{
	var elem = window.event.srcElement;
	return bClick(elem, elem.refreshLast);
	
}

function hBMouseup()
{

		var elem = window.event.srcElement;
		
		// Se realiza la inicializacio'n a demanda
		if (elem.menu == null)
			mBuilder.initLevel(elem);

		bMouseup(elem, elem.refreshLast);

	
}

function hBMouseout()
{
	var e = window.event;
	bMouseout(e.srcElement);
	e.cancelBubble = true;
}

function hBMouseover()
{
	var elem = window.event.srcElement;
	bMouseover(elem, elem.refreshLast, true);
}

// Funciones para manejar los eventos de los items
function hIMouseout()
{
	
	var e = window.event;
	var item = e.srcElement;

	item = getContainer(item, "A");

	iMouseout(item);
	
	e.cancelBubble = true;
}

function hIMouseover()
{
	
	var e = window.event;
	var item = e.srcElement;

	item = getContainer(item, "A");

	iMouseover(item);
	e.cancelBubble = true;
}

function hIClick()
{
	
	var e = window.event;
	var item = e.srcElement;

	item = getContainer(item, "A");
	
	iClick(item);
	e.cancelBubble = true;
}

// Funciones para manejar los eventos de las hojas
function hLMouseup()
{


	
	if(IsNotInitalPageStatic){
		// openWorkSpace();
		// //alert("Se ha alcanzado la cantidad m\u00E1xima de 'Espacios de Trabajo' definidos para su usuario.");
		var leaf = window.event.srcElement;
		if ((leaf.className != 'menuLeaf') && (leaf.className != 'menuLeaf menuItemHighlightLeaf'))
		{
			// Si se trata de un elemento A de un acceso directo se obtiene la hoja real
			leaf = leaf.parentNode;
		}
		lMouseup(leaf);
	}else{
		
		openWorkSpace()
		if(NoMoreWorkSpace){
			return ;
		}else{
			var leaf = window.event.srcElement;
			if ((leaf.className != 'menuLeaf') && (leaf.className != 'menuLeaf menuItemHighlightLeaf'))
			{
				// Si se trata de un elemento A de un acceso directo se obtiene la hoja real
				leaf = leaf.parentNode;
			}
			lMouseup(leaf);
		}

	}
}

function hLMouseover()
{
	var leaf = window.event.srcElement;
	lMouseover(leaf);
}

function hLMouseout()
{

	lMouseout();
}

function placeCov()
{
	if (!this.coverPlaced)
	{
		// Se comprueba si se trata de una pa'gina externa
		if (isExternal())
		{
			// Se define la altura del cobertor de manera que solamente cubra el espacio
			// visible del BODY y todo el espacio de "scroll" del mismo
			if (document.body.clientHeight > document.body.scrollHeight)
			{
				this.externalCover.style.height = document.body.clientHeight;
				this.externalCover.style.width = document.body.clientWidth;
			}
			else
			{
				this.externalCover.style.height = document.body.scrollHeight;
				this.externalCover.style.width = document.body.clientWidth;
			}

			document.body.appendChild(this.externalCover);

			this.coverPlaced = true;
		}
	}
}

function removeCov()
{
	if (this.coverPlaced)
	{
		document.body.removeChild(this.externalCover);
		this.coverPlaced = false;
	}
}

function coverActivate()
{
	closeAllMenu();
	mBuilder.removeCover();
}