function DragInfo()
{
	this.zIndex = 10000;
	this.x = 0;
	this.y = 0;
	this.startX = 0;
	this.startY = 0;
	this.elemX = 0;
	this.elemY = 0;
	this.element = null;
	this.cover = null;
	this.dragCoverElem = null;
	this.tempX = 0;
	this.tempY = 0;
}

var currentDrag = new DragInfo();
var coverDrag = null;
var d1Drag = null;
// Tiempo ma'ximo aceptable para realizar el arrastre con transaparencia
var thresholdDrag = 500;
var timerDrag = null;
var gapDrag = 20;

function renderPopup()
{
	timerDrag = null;

	currentDrag.dragCoverElem.style.top = currentDrag.tempY + "px";
	currentDrag.dragCoverElem.style.left = currentDrag.tempX + "px";
}

function beginDrag(elem, cover)
{
	var dragCover = getDragCover(elem);

	currentDrag.dragCoverElem = dragCover;

	// Se define el elemento actual
	currentDrag.element = elem;
	currentDrag.cover = cover;

	// Se consigue la posición del mouse relativa a la página
	currentDrag.y = window.event.clientY + document.documentElement.scrollTop + document.body.scrollTop;
	currentDrag.x = window.event.clientX + document.documentElement.scrollLeft + document.body.scrollLeft;

	currentDrag.elemX = parseInt(currentDrag.element.style.left);
	currentDrag.elemY = parseInt(currentDrag.element.style.top);

	// Se pone encima del resto de los elementos
	currentDrag.element.style.zIndex = ++currentDrag.zIndex;
	currentDrag.dragCoverElem.style.zIndex = currentDrag.zIndex + 1;

	document.body.onmousemove = drag;
	document.body.onmouseup = stopDrag;
}

function drag()
{
	if (timerDrag == null)
		timerDrag = setTimeout("renderPopup()", gapDrag);

	var x, y;

	// Se controla que el botón esté presionado para evitar seguir arrastrando cuando lo sueltan fuera de la pantalla
	if (event.button != 1)
	{
		stopDrag();
		return false;
	}

	y = window.event.clientY + document.documentElement.scrollTop + document.body.scrollTop;
	x = window.event.clientX + document.documentElement.scrollLeft + document.body.scrollLeft;

	x = currentDrag.elemX + x - currentDrag.x;
	y = currentDrag.elemY + y - currentDrag.y;
	if (y < 0)
		y = 0;
//	if (x < 0)
//		x = 0;

	currentDrag.tempX = x;
	currentDrag.tempY = y;

	window.event.cancelBubble = true;
	window.event.returnValue = false;
}

function stopDrag()
{
	if (timerDrag != null)
	{
		clearTimeout(timerDrag);
		renderPopup();
	}

	currentDrag.element.style.top = currentDrag.dragCoverElem.style.top;
	currentDrag.element.style.left = currentDrag.dragCoverElem.style.left;

	document.body.removeChild(currentDrag.dragCoverElem);

	currentDrag.dragCoverElem = null;
	currentDrag.element = null;
	document.body.onmousemove = null;
	document.body.onmouseup = null;
	currentDrag.cover.style.display = 'none';
	hideCover();
}

function getDragCover(elem)
{
	if (coverDrag == null)
		coverDrag = document.createElement("<IFRAME SRC='#' ONLOAD='notifyOnLoadDrag(this)' FRAMEBORDER='0' STYLE='position: absolute; filter: Alpha(opacity=0)'>");

	coverDrag.style.top = elem.style.top;
	coverDrag.style.left = elem.style.left;
	coverDrag.style.width = elem.clientWidth;
	coverDrag.style.height = elem.clientHeight;
	coverDrag.style.zIndex = currentDrag.zIndex;
	d1Drag = new Date();

	/* Se agrega el elemento que será arrastrado en lugar de todo el 'popup' */
	document.body.appendChild(coverDrag);

	return coverDrag;
}

function notifyOnLoadDrag(elem)
{
	var difference = (new Date()).getTime() - d1Drag.getTime();

	// Se recalcula el tiempo entre redibujados
	gapDrag = difference / 30;
	if (gapDrag > 100)
		gapDrag = 100;
	else if (gapDrag < 5)
		gapDrag = 5;

	// Si se demoro' demasiado en dibujar el 'iframe' transparente se utilizara' uno opaco para disminuir la carga de procesamiento
	if (difference > thresholdDrag)
	{
		elem.style.filter = "";
		elem.contentWindow.document.body.style.backgroundColor = "#EEEEEE";
	}
	else
		elem.style.filter = "Alpha(opacity=60)";
}