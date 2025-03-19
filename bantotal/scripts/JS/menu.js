// Observaciones sobre la navegacio'n dentro la estructura del menu':
//	- Del A hacia el DIV que lo contiene voy con "parentElement"
//	- Del A (boto'n o item) al DIV que e'ste define voy con "menu"
//	- Del DIV al A que lo define voy con "parentItem"
//	- Del DIV al u'ltimo item u hoja activa dentro de e'l voy con "lastActive"
//	- Del DIV al item u hoja actualmente activa, es decir que esta' coloreada en un momento dado, voy con "activeElement"
	
// Tiempo de espera antes de abrir un menu' para aumentar la usabilidad y la eficiencia
var gDelay = 200;

// Variable que almacena el u'ltimo boto'n activo, esto vendri'a a ser el equivalente a la propiedad
// "activeElement" de los items ya que no hay un "item de nivel -1" que contenga los botones
var gActiveButton = null;

// Variables utilizadas para almacenar la informacio'n entre un evento y su correspondiente accio'n en
// los casos que se utiliza un "timer"
var gTimer, gItem, gButton;

// Variables para saber cuando actualizar el lo correspondiente al boto'n de u'ltimo menu' accedido
var gRefreshLast, gRefreshLastFromItem;

// Variables para mantener cacheados los elementos SELECT, OBJECT, EMBED e IFRAME durante la ejecucio'n de una
// apertura de menu'. Son utilizadas a la hora de determinar cua'ndo es necesario ubicar un IFRAME detra's de
// un cierto menu' para ocultar los controles "windowed"
var overlappingCache = new OverlappingCache();
// Cantidad de pi'xeles que ocupan el menu', la barra de leng'u'etas de pasos y la barra superior
var gPageOffsetTop = 115;

// Variables para controlar estado de los botones del menu':
	// Indica cuando si fue la primera vez que se ejecuta un "onclick" sobre un boto'n para saber si e'ste debe
	// cerrarse o no, es para hacer convivir los eventos "onclick" y "onmousedown"
	var gClickFlag = false;
	// Indica si el mouse ha salido de la superficie del boto'n activo
	var gBeenOutsideButton = false;

////////////////////
// BEGIN: BUTTONS //
////////////////////

// Manejador correspondiente al evento de "onmousedown" sobre un boto'n.
// Se encarga de mostrar el menu' correspondiente al boto'n (solo en caso que el mismo no este' visible de antemano)
// y de cerrar el del anterior boto'n activo (en caso de existir). Si se ejecuta sobre el boto'n actual no se hace nada
// porque el encargado de cerrarlo seri'a el manejador del evento "onclick", ya que el usuario podri'a dejar el mouse 
// presionado (se ejecuta el 'mosuedown' pero no el 'click') de manera de poder arrastrarse sobre las opciones y que al 
// soltar se seleccione una.
//
// Para'metros:
//		"button"      -> boto'n sobre el cual se genero' el evento.
//		"refreshLast" -> 1 para indicar que se debe actualizar lo correspondiente al boto'n del u'ltimo menu' 
//                       accedido, y 0 en caso contrario (el 0 es para cuando se navega directamente desde el
//                       boto'n de u'ltimo acceso para que no se re-actualice a si' mismo).
function bMousedown(button, refreshLast)
{
	gRefreshLast = refreshLast;
	gBeenOutsideButton = false;

	// En caso de haberse presionado sobre el boto'n actual no se hace nada
	if (gActiveButton != button)
	{
		gClickFlag = false;

		// En caso de haber un boto'n previamente activo se devuelve e'ste a su estado original
		if (gActiveButton != null)
			deactivateButton(gActiveButton);

		// Se activa el boto'n cambiando su este'tica y abriendo su menu' asociado
		activateButton(button);
		
		gActiveButton = button;

		// Se abre el u'ltimo sub-menu' activo en caso de existir, o se colorea en caso de ser una hoja
		if (button.menu.lastActive != null)
		{
			if (button.menu.lastActive.type == 0)
			{
				// Se marca la hoja como el elemento activo
				button.menu.activeElement = button.menu.lastActive;
				button.menu.activeElement.className = "menuLeaf menuItemHighlightLeaf";
			}
			else
			{
				// Se utiliza un "timer" de 1 para que se dibujen los menu'es escalonadamente y no se perciba un
				// retraso importante
				gItem = button.menu.lastActive;
				gTimer = setTimeout("menuItemAction(null)", 1);
			}
		}
	}
}

// Manejador correspondiente al evento "onclick" de un boto'n.
// Se encarga de cerrar el menu' correspondiente al boto'n actual solo en caso que el mouse no haya salido
// de la superficie de dicho boto'n. No se encarga de abrirlo porque eso se hace en el evento "onmousedown".
//
// Para'metros:
//		"button"      -> boto'n sobre el cual se genero' el evento.
//		"refreshLast" -> 1 para indicar que se debe actualizar lo correspondiente al boto'n del u'ltimo menu' 
//                       accedido, y 0 en caso contrario (el 0 es para cuando se navega directamente desde el
//                       boto'n de u'ltimo acceso para que no se re-actualice a si' mismo).
function bClick(button, refreshLast)
{
	gRefreshLast = refreshLast;

	// En caso de que el mouse haya salido de la superficie del boto'n actualmente activo no se cerrara' su menu'
	// asociado ('gBeenOutsideButton'), como tampoco se cerrara' en caso de haberse abierto en este momento en el
	// evento "onmousedown" que se ejecuta antes que e'ste ('gClickFlag')
	if (!gClickFlag || gBeenOutsideButton)
	{
		gClickFlag = true;
		gBeenOutsideButton = false;
	}
	else
	{
		// En este punto el boto'n activo es el mismo sobre el cual se genero' este evento

		// Se actualiza la variable global
		gClickFlag = false;

		// Se desactiva el boto'n actual
		if (gActiveButton != null)
		{
			// Se invalida el cache' para el control de solapado
			overlappingCache.invalidate();

			deactivateButton(gActiveButton);
		}

		// Ya no hay bot'n actual
		gActiveButton = null;

		// Se colorea como el boto'n como en el "mouseover" para dar el efecto deseado
		shadeButton(button);
	}
}

// Manejador correspondiente al evento "onmosueover" de un boto'n.
// Se encarga de pintar de gris los botones en caso que no haya ninguno activo, y si hay un boto'n activo
// que no coincide con el que genero' el evento pasa a este u'ltimo como actual.
//
// Para'metros:
//		"button"      -> boto'n sobre el cual se genero' el evento.
//		"refreshLast" -> 1 para indicar que se debe actualizar lo correspondiente al boto'n del u'ltimo menu' 
//                       accedido, y 0 en caso contrario (el 0 es para cuando se navega directamente desde el
//                       boto'n de u'ltimo acceso para que no se re-actualice a si' mismo).
//		"timer"       -> 1 para indicar que se aplique un timer con lapso "gDelay", y 0 para indicar la ejecucio'n
//		                 sea directa.
function bMouseover(button, refreshLast, timer)
{
	// Se cancela un potencial "timer" anterior
	clearTimeout(gTimer);

	// Si no hay ningu'n boto'n activo simplemente se colorea el que genero' el evento
	if (gActiveButton == null)
		shadeButton(button);	
	else
	{
		// Se ejecuta la accio'n asociada directamente o vi'a "timer"
		if (timer)
		{
			gButton = button;
			gTimer = setTimeout("bMouseoverAction(null, " + refreshLast + ")", gDelay);
		}
		else
			bMouseoverAction(gButton, refreshLast);
	}
}

// Accio'n asociada al evento "mouseover" sobre un boto'n.
// Ver "bMouseover" por descripcio'n.
// Puede ser invocada tanto en forma directa como por medio de un "timer", en cuyo caso utilizar'a "gButton" en
// lugar de "button".
//
// Para'metros:
//		"button"      -> boto'n sobre el cual se genero' el evento.
//		"refreshLast" -> 1 para indicar que se debe actualizar lo correspondiente al boto'n del u'ltimo menu' 
//                       accedido, y 0 en caso contrario (el 0 es para cuando se navega directamente desde el
//                       boto'n de u'ltimo acceso para que no se re-actualice a si' mismo).
function bMouseoverAction(button, refreshLast)
{
	// Se normaliza el tipo de invocacio'n (directa o vi'a "timer")
	if (button == null)
		button = gButton;

	gRefreshLast = refreshLast;

	// Si no hay boto'n activo no hay nada que hacer
	if (gActiveButton != null)
	{
		// Si el boto'n activo es este mismo no hay nada que hacer
		if (gActiveButton != button)
		{
			// Se realiza la inicializacio'n a demanda
			if (button.menu == null)
				mBuilder.initLevel(button);

			// Se utiliza el "mousedown" para abrir el menu' del nuevo boto'n actual y cerrar el previo
			bMousedown(button, gRefreshLast);
			
			// Como no se realizo' un clic sobre el boto'n se cambia esta propiedad para que el primer clic
			// ya cierre el menu' del boto'n
			gClickFlag = true;
			gBeenOutsideButton = true;
		}
	}
}

// Manejador correspondiente al evento "onmosueup" de un boto'n.
// Se encarga de abrir el menu' de un boto'n solamente si no hay otro activo, dado que en caso de que haya otro activo
// el encargado de hacer esto es el evento del "mouseover".
//
// Para'metros:
//		"button"      -> boto'n sobre el cual se genero' el evento.
//		"refreshLast" -> 1 para indicar que se debe actualizar lo correspondiente al boto'n del u'ltimo menu' 
//                       accedido, y 0 en caso contrario (el 0 es para cuando se navega directamente desde el
//                       boto'n de u'ltimo acceso para que no se re-actualice a si' mismo).
function bMouseup(button, refreshLast)
{
	gRefreshLast = refreshLast;

	if (gActiveButton == null)
	{
		// Se utiliza el "mousedown" para abrir el menu' del nuevo boto'n actual
		bMousedown(button, refreshLast);

		// Como no se realizo' un clic sobre el boto'n se cambia esta propiedad para que el primer clic
		// ya cierre el menu' del boto'n
		gClickFlag = true;
		gBeenOutsideButton = true;		
	}
}

// Manejador correspondiente al evento "onmosueout" de un boto'n.
// Se encarga de volver al estado original a un boto'n en caso que no haya ninguno activo, es decir de quitarle el 
// efecto del "mouseover", y en caso que haya alguno activo se marca que se salio' de la superficie del boto'n
// activo para que el evento "onclick" no cierre el boto'n actual.
//
// Para'metros:
//		"button" -> boto'n sobre el cual se genero' el evento.
function bMouseout(button)
{
	// Se cancela un potencial "timer" anterior
	clearTimeout(gTimer);

	if (gActiveButton == null)
		removeButtonShade(button);
	else
		gBeenOutsideButton = true;
}

// Activa un boto'n cambiando su este'tica y abriendo su menu' asociado.
//
// Para'metros:
//		"button" -> boto'n a activar.
function activateButton(button)
{
	var x, y, width;
	var menuStyle;
	
	// Se coloca el cobertor en caso de tratarse de una pa'gina externa de forma de poder capturar todo evento que suceda sobre la misma
	mBuilder.placeCover();

	// Se modifica la parte este'tica para que lusca como un boto'n activo
	button.className = "menuButtonActive";
	button.style.zIndex = "501";

	// Se cambia la propiedad "display" de manera de poder corregir los anchos correctamente
	menuStyle = button.menu.style;
	menuStyle.display = "inline";

	// Si el boto'n es ma's ancho que el menu' se hace el ajuste necesario para que el borde se vea correctamente
	if (button.offsetWidth > button.menu.offsetWidth)
	{
		button.className = "menuButtonActiveBottomBorder";
		button.style.zIndex = 200;
		button.menu.className = "menuNoTopBorder";
	}

	// Se consiguen las posiciones izquierda y superior
	x = top.offsetLeft(button);
	y = top.offsetTop(button) + button.offsetHeight - 1;

	// Se recuerda el ancho porque si no al reposicionarlo hay veces que el browser calcula mal el ancho y quedan
	// textos en 2 renglones, además si no fijo el ancho el "hover" del css funciona muy lento
	width = button.menu.clientWidth;
	
	// Se posiciona el menu'
	menuStyle.left = x;
	menuStyle.top  = y;

	// Se corrige el ancho dado que el "clientWidth" es ma's chico que la propiedad "width" del estilo
	menuStyle.width = width;
	width += width - button.menu.clientWidth;
	menuStyle.width = width;

	// Se coloca un "iframe" detra's de manera de ocultar los controles "windowed"
	placeBackground(button.menu, button.cover);
}

// Desactiva un boto'n cambiando su este'tica y cerrando su menu' asociado.
//
// Para'metros:
//		"button" -> boto'n a desactivar.
function deactivateButton(button)
{
	// Se retira el cobertor en caso de tratarse de una pa'gina externa de forma de dejar de capturar todo evento que suceda sobre la misma
	mBuilder.removeCover();

	// Se modifica la parte este'tica para que lusca como un boto'n inactivo
	button.style.zIndex = 100;
	button.className = "menuButton";

	// Se corrigen los bordes por si se tuvieron que cambiar dado que el boto'n fuera ma's ancho que el menu
	button.menu.className = "menu";

	// Se cierra el menu' asociado al boto'n
	closeMenu(button.menu);
	button.menu.style.display = "none";
	removeBackground(button.cover);
}

// Pone un sombreado sobre un boto'n para generar el efecto de "mouseover".
//
// Para'metros:
//		"button" -> boto'n a sombrear.
function shadeButton(button)
{
	// Se colorea como el boto'n para dar el efecto de "mouseover"
	button.className = 'menuButtonHover';
}

// Quita la sombra de un boto'n, es decir el efecto de "mouseover".
//
// Para'metros:
//		"button" -> boto'n al cual se le removera' la sombra.
function removeButtonShade(button)
{
	// Le saca el sobreado para devolverlo a su estado original quitando el efecto de "mouseover"
	button.className = 'menuButton';
}

//////////////////
// END: BUTTONS //
//////////////////

//////////////////
// BEGIN: ITEMS //
//////////////////

// Manejador correspondiente al evento "onclick" de un item.
// Se encarga de abrir el menu' de un item (con todo su u'ltimo estado) y de cerrar el menu' activo de su propio nivel
// en caso de existir.
//
// Para'metros:
//		"button" -> item sobre el cual se genero' el evento.
function iClick(item)
{
	// Se cancela un potencial "timer" anterior
	clearTimeout(gTimer);

	// Se indica que no se esta' en una cadena de reaperturas para mantener estado previo, sino que el
	// usuario realmente hizo clic en un item y por lo tanto habri'a qua actualizar en boto'n de u'ltimo
	// acceso a menos que ya se este' dentro de e'ste (lo segundo es indicado por la variable "gRefreshLast")
	gRefreshLastFromItem = 1;

	// Se abre el menu' y se cierra el previo activo del nivel en caso de existir
	menuItemAction(item);
}

// Manejador correspondiente al evento "onmouseover" de un item.
// Se encarga de abrir el menu' de un item (con todo su u'ltimo estado) y de cerrar el menu' activo de su propio nivel
// en caso de existir. Esto se hace vi'a "timer" para aumentar la usabilidad y la eficiencia.
//
// Para'metros:
//		"button" -> item sobre el cual se genero' el evento.
function iMouseover(item)
{
	// Se cancela un potencial "timer" anterior
	clearTimeout(gTimer);

	// Si bien NO se est'a en una cadena de reaperturas para mantener estado previo (dado que el
	// usuario realmente se posiciono' sobre un item) tampoco es deseable que se actualice el boto'n
	// de u'ltimo acceso a menos que el usuario cliquee sobre un item, por lo tanto se marca la NO
	// actualizacio'n
	gRefreshLastFromItem = 0;

	// Se invocara' la accio'n vi'a "timer" de manera de aumentar la usabilidad
	gItem = item;

	// Se abre el menu' y se cierra el previo activo del nivel en caso de existir
	gTimer = setTimeout("menuItemAction(null)", gDelay);
}

// Manejador correspondiente al evento "onmouseout" de un item.
// Se encarga de abortar el proceso de abertura de un menu' en caso de haberlo para evitar que si el usuario esta'
// un peri'odo muy breve de tiempo sobre un item no pase nada.
//
// Para'metros:
//		"button" -> item sobre el cual se genero' el evento.
function iMouseout(item)
{
	// Se cancela la accio'n de posicionarse sobre el menuitem anterior
	clearTimeout(gTimer);
}

// Funcio'n encargada del manejo de apertura de items. Se encarga de abrir el menu' del item indicado y de 
// reestablecer todo su estado previo (sub-menu'es previamente abiertos). Tambie'n cierra el potencial item
// del mismo nivel que el abierto.
// Puede ser invocada tanto en forma directa como por medio de un "timer", en cuyo caso utilizar'a "gItem" en
// lugar de "item".
//
// Para'metros:
//		"item"  -> item que se abrira'.
function menuItemAction(item)
{
	var parentMenu, sMStyle;
	var offsetWidth, maxX, maxY, docElem, docBody, x, y, width;

	// Se normaliza el tipo de invocacio'n (directa o vi'a timer)
	if (item == null)
		item = gItem;

	// Se realiza la inicializacio'n a demanda
	if (item.menu == null)
		mBuilder.initLevel(item);

	// Se consigue el DIV padre
	parentMenu = item.parentElement;

	// Si ya estaba activo el item que se intenta activar solo se reposiciona
	if (parentMenu.activeElement != item)
	{
		if (parentMenu.activeElement != null)
		{
			// Se desactiva el elemento anterior del menu' contenedor del item accionado
			if (parentMenu.activeElement.type == 0)
				// Se desmarca la hoja
				parentMenu.activeElement.className = "menuLeaf";
			else
				// Se cierra el sub-menu'
				closeMenu(parentMenu);
		}

		// Se activa este item
		parentMenu.activeElement = item;
		item.className = "menuItem menuItemHighlight";

		// Se setea este item como el u'ltimo activo ya que luego se utilizara' esto para reabrir toda la cadena
		// de u'ltimos menu'es abiertos
		parentMenu.lastActive = item;
	}

	// Se consiguen las posiciones izquierda y superior
	offsetWidth = item.offsetWidth;
	x = top.offsetLeft(item) + offsetWidth;
	y = top.offsetTop(item);

	// Se ajusta la posicio'n por si se iba de la pantalla
	docElem = document.documentElement;
	docBody = document.body;

	maxX = Math.max(docElem.scrollLeft, docBody.scrollLeft) + (docElem.clientWidth != 0 ? docElem.clientWidth : docBody.clientWidth);
	maxY = Math.max(docElem.scrollTop, docBody.scrollTop) + (docElem.clientHeight != 0 ? docElem.clientHeight : docBody.clientHeight);

	// Se cambia la propiedad "display" de manera de poder corregir los anchos correctamente
	sMStyle = item.menu.style;
	sMStyle.display = "inline";

	maxX -= item.menu.offsetWidth;
	maxY -= item.menu.offsetHeight;

	if (x > maxX)
		x = Math.max(0, x - offsetWidth - item.menu.offsetWidth + (parentMenu.offsetWidth - offsetWidth));

	y = Math.max(0, Math.min(y, maxY));

	// Se recuerda el ancho porque si no al reposicionarlo hay veces que el browser calcula mal el ancho y quedan
	// textos en 2 renglones, además si no fijo el ancho el "hover" del css funciona muy lento
	width = item.menu.clientWidth;
	
	// Se hace visible
	item.style.display = "block";
	sMStyle.left = (x + 2) + "px";
	sMStyle.top  = (y - 1) + "px";

	// Se corrige el ancho dado que el "clientWidth" es ma's chico que la propiedad "width" del estilo
	sMStyle.width = width;
	width += width - item.menu.clientWidth;
	sMStyle.width = width;
	
	// Se coloca un "iframe" detra's de manera de ocultar los controles "windowed"
	placeBackground(item.menu, item.cover);

	// En caso de ser necesario se actualiza el boto'n de u'ltimo acceso
	if ((gRefreshLast == 1) && (gRefreshLastFromItem == 1))
	{
		// Se notifica al manejador del menu' del cambio en el u'ltimo elemento accedido para que actualice 
		// el boto'n de u'ltimo acceso
		mBuilder.addLastAccessed(item.innerText, item.menu);
	}

	// En caso de que el item tuviese algu'n menu' que se hubiese abierto previamente se re-abre, o se marca en caso
	// de ser una hoja
	if (item.menu.lastActive != null)
	{
		if (item.menu.lastActive.type == 0)
		{
			// Se marca la hoja
			item.menu.activeElement = item.menu.lastActive;
			item.menu.activeElement.className = "menuLeaf menuItemHighlightLeaf";
		}
		else
		{
			// Aqui' no hay que refrescar el boto'n de u'ltimo acceso ya que simplemente se esta' recuperando el 
			// estado de la u'ltima vez que se abrio'
			gRefreshLastFromItem = 0;

			// Se utiliza un "timer" de 1 para que se dibujen los menu'es escalonadamente y no se perciba un
			// retraso importante
			gItem = item.menu.lastActive;
			gTimer = setTimeout("menuItemAction(null)", 1);
		}
	}
}

// Funcio'n encargada de cerrar un menu'.
//
// Para'metros:
//		"item"  -> menu' a cerrar.
function closeMenu(item)
{
	var active = item.activeElement;
	
	// Si no hay un elemento activo no hay nada para hacer
	if (active == null)
		return;

	// Se cierra un posible sub-menu' del elemento activo del menu'
	if (active.menu != null)
	{
		closeMenu(active.menu);
		active.menu.style.display = "none";
		removeBackground(active.cover);
	}

	// Se vuelve el elemento padre del menu' cerrado a su estado original	
	if (active.type == 0)
		active.className = "menuLeaf";
	else
		active.className = "menuItem";

	// Ya no hay elemento activo en este menu'
	item.activeElement = null;
}

// Fuincio'n que sirve para colocar un IFRAME detra's de un menu' para ocultar los controles "windowed".
function placeBackground(div, iframe)
{
	// Se controla si se solapa con algu'n elemento "windowed"
	if (overlappingCache.overlaps(div))
	{
		// Se definen las propiedades del IFRAME de manera que quede igual que el menu' de atra's
		var st = iframe.style;
		st.width = div.offsetWidth;
		st.height = div.offsetHeight;
		st.top = div.style.top;
		st.left = div.style.left;
		st.display = "block";
	}
}

// Oculta un IFRAME utilizado para ocultar los controles "windowed".
function removeBackground(iframe)
{
	if (iframe != null)
		iframe.style.display = "none";
}

////////////////
// END: ITEMS //
////////////////

///////////////////
// BEGIN: LEAVES //
///////////////////

// Manejador correspondiente al evento "onmouseover" de una hoja.
// Se encarga de cerrar el menu' previamente abierto de este nivel en caso de exitir.
//
// Para'metros:
//		"leaf"  -> hoja sobre el cual se genero' el evento.
function lMouseover(leaf)
{
	// Se cancela un potencial "timer" anterior
	clearTimeout(gTimer);

	// Se invocva la accio'n vi'a timer para aumentar la usabilidad y la eficiencia
	gItem = leaf;
	gTimer = setTimeout("menuLeafAction(null)", gDelay);
}

// Manejador correspondiente al evento "onmouseout" de una hoja.
// Simplemente cancela la accio'n de abertura que hubiese en curso.
function lMouseout()
{
	// Se cancela un potencial "timer" anterior para cancelar la accio'n de posicionarse sobre el menu' que se
	// acaba de abandonar
	clearTimeout(gTimer);
}

// Manejador correspondiente al evento "onmouseup" de una hoja.
// Se encarga de cerrar el menu' previamente abierto de este nivel en caso de exitir.
//
// Para'metros:
//		"leaf"  -> hoja sobre el cual se genero' el evento.
function lMouseup(leaf)
{
	// Se consigue el DIV padre
	var parentMenu = leaf.parentElement;

	// Se elimina cualquier otra cosa activa de este nivel
	menuLeafAction(leaf);

	// Se define esta hoja como activa
	parentMenu.activeElement = leaf;
	parentMenu.lastActive = leaf;
	leaf.className = "menuLeaf menuItemHighlightLeaf";

	// Se cierra todo el menu'
	deactivateButton(gActiveButton);
	gActiveButton = null;
	
	// En caso de ser necesario se actualiza el boto'n de u'ltimo acceso
	// No se actualiza en caso de estar navegando dentro del boto'n de u'ltimo acceso ("gRefreshLast")
	// Tampoco se actualiza en caso que estemos en el nivel 0, es decir en el sub-menu' directo de un boto'n
	if ((gRefreshLast == 1) && (leaf.level > 0))
	{
		// Se notifica al manejador del menu' del cambio en el u'ltimo elemento accedido para que actualice 
		// el boto'n de u'ltimo acceso
		mBuilder.addLastAccessed(parentMenu.parentItem.innerText, parentMenu.parentItem.menu);
	}

	// Se reinicia el espacio de trabajo actual

	// Se utiliza "leaf.childNodes[0].nodeValue" y no "leaf.innerText" porque las hojas que tienen un acceso
	// directo contienen un elemento A interior, y el texto del mismo es parte de la propiedad "innerText"; de esta
	// forma se evita que quede "F?" concatenado luego del nombre de la entrada del menu' como ti'tulo del espacio de trabajo
	getUrl(leaf.link, leaf.childNodes[0].nodeValue, leaf.linkType);
}

// Funcio'n encargada del manejo de posicionamientos sobre hojas. Se encarga de cerrar lo previamente activo
// en el nivel de la hoja sobre la que se pocisiono'.
// Puede ser invocada tanto en forma directa como por medio de un "timer", en cuyo caso utilizar'a "gItem" en
// lugar de "item".
//
// Para'metros:
//		"leaf"  -> hoja que sobre la que se posiciono'.
function menuLeafAction(leaf)
{
	// Se normaliza el tipo de invocacio'n (directa o vi'a "timer")
	if (leaf == null)
		leaf = gItem;

	// Se consigue el DIV padre
	var parentMenu = leaf.parentElement;

	// Se vuelve al estado original el elemento previamente seleccionado
	if ((parentMenu.activeElement != null) && (parentMenu.activeElement != leaf))
	{
		// Segu'n sea una hoja o no se le setea la clase normal
		if (parentMenu.activeElement.type == 0)
			// Se desmarca la hoja
			parentMenu.activeElement.className = "menuLeaf";
		else
			// Se cierra el sub-menu'
			closeMenu(parentMenu);
	}
}

/////////////////
// END: LEAVES //
/////////////////

//////////////////////////////
// BEGIN: OVERLAPPING-CACHE //
//////////////////////////////

// Funcio'n utilizada para vaciar el cache de elementos.
function invalidateCache()
{
	if (this.areas.length != 0)
		this.areas = new Array();

	// Se rescribe siempre porque consultar por el valor puede causar errores de "access denied"
	this.elements = new Array(-1, -1, -1, -1);

	this.lastIndex = 0;
	this.lastType = 0;
}

// Devuelve true en caso de que haya algu'n elemento que se solape con el elemento dado.
function overlapsCache(menu)
{
	var i, kind, type, elems;
	var menuArea = new Area(menu, 0);
	var scrollTop = getScrollTop();
	var scrollLeft = getScrollLeft();
	var lastType = this.lastType;

	// Primero se intenta comparar contra las a'reas que ya se hayan construido
	for (i = 0; i < this.areas.length; i++)
		if (menuArea.overlaps(this.areas[i], gPageOffsetTop - scrollTop, scrollLeft))
			return true;

	// Si no se logro' encontrar nada se continu'a con la bu'sequeda
	try
	{
		for (kind = lastType; kind < 4; kind++)
		{
			// Se recuerda el u'ltimo tipo revisado
			this.lastType = kind;

			// Si no se ha conseguido au'n la coleccio'n de este tipo de elementos se hace
			if (this.elements[kind] == -1)
			{
				// Se elige el tipo de elemento a ocultar
				switch (kind)
				{
					case 0: type = "SELECT";
							break;
					case 1: type = "IFRAME";
							break;
					case 2: type = "OBJECT";
							break;
					case 3: type = "EMBED";
							break;
				}

				this.elements[kind] = getElements(type);
			}

			// Si la funcio'n devolvio' false es porque encontro' algu'n problema para acceder al contenido
			// de una pa'gina, por lo tanto se asume que hay contenido solapado
			if (this.elements[kind] == false)
				return true;

			// En caso de estar revisando el u'ltimo tipo revisado se comienza desde el u'ltimo i'ndice donde se habi'a dejado
			if (lastType != kind)
				this.lastIndex = 0;

			elems = this.elements[kind];

			// Se compara contra los elementos encontrados
			if (elems != null)
			{
				for (i = this.lastIndex; i < elems.length; i++)
				{
					var auxElem = elems[i];
					var area = new Area(auxElem);

					if (auxElem.style.visibility != "hidden")
					{
						// Se guarda el a'rea para futuras comparaciones
						this.areas.push(area);

 						if (menuArea.overlaps(area, gPageOffsetTop - scrollTop, scrollLeft))
						{
							// Se recuerda hasta donde se llego' en esta bu'squeda
							this.lastIndex = i + 1;
							return true;
						}
					}
				}
			}
		}
	}
	catch (e)
	{
		// En caso de error se hace visible el IFRAME por si a caso
		return true;
	}
	
	return false;
}

// Clase utilizada para llevar el cache' de elementos contra los cuales se comparara' para decidir cuando colocar
// IFRAMES para ocultar los controles "windowed".
function OverlappingCache()
{
	// Cuadros ya calculados
	this.areas = new Array();
	// I'ndices de los u'ltimos elementos y tipos analizados
	this.lastIndex = 0;
	this.lastType = 0;
	// Arreglo con cuatro posiciones para almacenar SELECT's, OBJECT's, IFRAME's y EMBED's
	this.elements = new Array(-1, -1, -1, -1);
}

OverlappingCache.prototype.invalidate = invalidateCache;
OverlappingCache.prototype.overlaps = overlapsCache;

function overlapsArea(area, t, l)
{
	return (area.left + l <= this.left + this.width) && 
	       (area.left + l + area.width >= this.left) && 
	       (area.top + t <= this.top + this.height) && 
	       (area.top + t + area.height >= this.top);
}

// Clase utilizada para realizar comparaciones de solapado de a'reas rectangulares.
function Area(elem)
{
	this.width = elem.offsetWidth;
	this.height = elem.offsetHeight;
	this.top = top.offsetTop(elem);
	this.left = top.offsetLeft(elem);
}

Area.prototype.overlaps = overlapsArea;

////////////////////////////
// END: OVERLAPPING-CACHE //
////////////////////////////

///////////////////////////
// MISCELANIUS FUNCTIONS //
///////////////////////////

// Devuelve  el primer nodo en la jerarqui'a de ancestros (incluyendo al propio nodo) que sea un elemento
// correspondiente al nombre de tag indicado.
function getContainer(startNode, tagName)
{
	while (startNode != null)
	{
		if ((startNode.tagName != null) && (startNode.tagName == tagName))
			return startNode;

		startNode = startNode.parentNode;
	}

	return startNode;
}

// Manejador del evento "mousedown" sobre la pa'gina.
// Se encarga de cerrar completamente el menu' cuando corresponde.
function pageMousedown()
{
	var element, div;

	// Si no hay ningu'n boto'n abierto no hay nada que hacer
	if (gActiveButton == null)
		return;

	element = window.event.srcElement;

	// Si se cliqueo' sobre el boto'n activo no se hace nada
	if (element == gActiveButton)
		return;

	// Si se presiono' fuera del menu'
	if (((div = getContainer(element, "DIV")) == null) || ((div.className != "menu") && (div.className != "menuNoTopBorder")))
	{
		// Se cierra todo el menu'
		deactivateButton(gActiveButton);

		// Se invalida el cache' para el control de solapado
		overlappingCache.invalidate();

		gActiveButton = null;
	}
}

// Fuerza el cerrado completo del menu'.
function closeAllMenu()
{
	// Se invalida el cache' para el control de solapado
	overlappingCache.invalidate();
	
	if (gActiveButton == null)
		return;

	deactivateButton(gActiveButton);
	gActiveButton = null;
}