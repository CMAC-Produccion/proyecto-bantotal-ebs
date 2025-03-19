// Inicializa una nueva instancia del tipo ChartLayout
//
// Parámetros:
//   'labelXEncoded' -> Etiqueta del eje X (códificada para agregar en código HTML).
//   'xIsDateTime'   -> Indica si el eje X contiene fechas y horas.
//   'xLength'       -> Cantidad de caracteres utilizados para representar los valores de X.
//   'xFormat'       -> Formato utilizado para representar los valores de X.
//   'seriesCount'   -> Cantidad total de series.
//   'legendTitle'   -> Indica si la leyenda se ubica en el titulo de las areas.
function ChartLayout(labelXEncoded, xIsDateTime, xLength, xFormat, seriesCount, legendTitle)
{
    this.labelXEncoded = labelXEncoded;
    this.xIsDateTime   = xIsDateTime;
    this.xLength       = xLength;
    this.xFormat       = xFormat;    
    this.seriesCount   = seriesCount;
    this.legendTitle   = legendTitle;    
}

// Inicializa una nueva instancia del tipo ChartArea.
//
// Parámetros:
//   'labelYEncoded' -> Etiqueta Y (códificada para agregar en código HTML).
//   'boundsLeft'    -> Coordenada X del límite izquierdo del área.
//   'boundsTop'     -> Coordenada Y del límite superior del área.
//   'boundsRight'   -> Coordenada X del límite derecho del área.
//   'boundsBottom'  -> Coordenada Y del límite inferior del área.
//   'minX'          -> Valor mínimo del eje X.
//   'minY'          -> Valor mínimo del eje Y.
//   'maxX'          -> Valor máximo del eje X.
//   'maxY'          -> Valor máximo del eje Y.
//   'yLength'       -> Cantidad de caracteres utilizados para representar los valores de Y.
//   'yDecimals'     -> Cantidad de decimales utilizados para los valores de Y.
//   'series'        -> Arreglo con las series del área.
function ChartArea(labelYEncoded, boundsLeft, boundsTop, 
    boundsRight, boundsBottom, minX, minY, maxX, maxY, yLength, yDecimals, series)
{
    this.labelYEncoded = labelYEncoded;
    this.boundsLeft    = boundsLeft;
    this.boundsBottom  = boundsBottom;
    this.boundsRight   = boundsRight;
    this.boundsTop     = boundsTop;
    this.minX          = minX;
    this.minY          = minY;
    this.maxX          = maxX;
    this.maxY          = maxY;
    this.yLength       = yLength;
    this.yDecimals     = yDecimals;
    this.series        = series;
}

// Inicializa una nueva instancia del tipo ChartSerie.
//
// Parámetros:
//   'nameEncoded' -> Nombre de la serie (códificado para agregar en código HTML).
//   'type'        -> Tipo (0 - Normal, 1 - Financiera, 2 - Rango).
//   'yLength'     -> Cantidad de caracteres utilizados para representar los valores de Y.
//   'yDecimals'   -> Cantidad de decimales utilizados para los valores de Y.
function ChartSerie(nameEncoded, type, yLength, yDecimals)
{
    this.nameEncoded = nameEncoded;
    this.type        = type;
    this.yLength     = yLength;    
    this.yDecimals   = yDecimals;
}

// Inicializa una nueva instancia del tipo ChartDDElement. Contiene información
// de un elemento de una gráfica para implementar la funcionalidad de drill-down.
//
// Parámetros:
//   'id'     -> Identificador del elemento.
//   'type'   -> Tipo el elemento (P - Poligono, C - Circulo)
//   'x'      -> Coordenada X si es un circulo, arreglo de coordenadas X si 
//               es un poligono
//   'y'      -> Coordenada Y si es un circulo, arreglo de coordenadas Y si 
//               es un poligono
//   'r'      -> Radio si es un circulo.
function ChartDDElement(id, type, x, y, r)
{
    this.id   = id;
    this.type = type;
    this.x    = x;
    this.y    = y;
    this.r    = r;
}

// Hace un GET a la URL especificada para obtener el script de interactividad.
//
// Parámetros:
//   'url'      -> URL que se consulta
//   'callback' -> Función que se invoca cuando se recibe la respuesta. Está función
//                 debe recibir dos parametros. El primero será el valor de 'p', y el segundo
//                 el texto de la respuesta recibida.
//   'p'        -> Parametros con que se invoca a la función anterior
// Resultado:
//   Respuesta recibida
function cGetScript(url, callback, p) {
    var processReqChange, req;
        
    processReqChange = function processReqChange()
        {                
            // Verifica que la respuesta haya sido cargada
            if (req.readyState == 4) 
            {
                // Verifica si el resultado es OK
                if (req.status == 200) 
                    callback(p, req.responseText);
                else 
                    alert("There was a problem retrieving data:\n" + req.statusText);                   
                    
                cbRemoveEvent(req, "readystatechange", processReqChange);        
            }                 
        }    
            
    // Verifica si se encuentra una implementación nativa
    if (window.XMLHttpRequest) 
    {
        req = new XMLHttpRequest();
        //cbAttachEvent(req, "readystatechange", processReqChange);        
        req.onreadystatechange = processReqChange;            
        req.open("GET", url, true);
        req.send(null);
    } 
    else if (window.ActiveXObject) 
    {        
        // Estamos en Internet Explorer, se crea el ActiveX para hacer invocaciones HTTP
        req = new ActiveXObject("Microsoft.XMLHTTP");
        if (req) 
        {
	    req.onreadystatechange = processReqChange;            
            req.open("GET", url, true);
            req.send();
        }
    }
}

// Devuelve el largo que debe usarse para la cadena de
// caracteres especificada, asumiendo que se va a escribir
// en negrita
//
// Parámetros:
//   'infoBoxTextSize' -> SPAN que se utiliza para medir los textos.
//   's'               -> Texto que se mide.
// Resultado:
//   Largo.
function cGetBoldStringWidth(infoBoxTextSize, s)
{   
    var i, length;
  
    infoBoxTextSize.innerText = s;
    var width = infoBoxTextSize.clientWidth;
    
    return width;
}

// Le da formato al número especificado, con los decimales
// indicados
//
// Parámetros:
//   'n' -> Número.
//   'd' -> Cantidad de decimales.
// Resultado:
//   Número formateado.
function cFormatNumber(n, d)
{
    var DecimalSeparator = ',';
    var ThousandSeparator = '.';

    if (n == null)
        return "";
    else
    {
        // Pasa el número a cadena de caracteres
        var s = n.toFixed(d)
   	    if (s.length == 0)
   	        return s;        

        // Busca y carga la parte decimal
		var i = s.indexOf('.');  		
		var decPart = "";    	    
		if (i != -1)            
			decPart = s.substr(i + 1);    
		else
			i = s.length;	        	    
	        	    
	    // Le agrega el separador de miles y decimales
	    var start = (s.charAt(0) == '-' ? 1 : 0);
		var k = (i - start) % 3;
		if (k == 0)
		    k = 3;
		k += start;				
		var res = s.substr(0, k);	    		
		while (k < i)
		{
			if (res == "")
				res = s.substr(k, 3)
			else
				res += ThousandSeparator + s.substr(k, 3)
			k += 3;
		}	    
		if (decPart != "")
			res += "," + decPart;
			
	    // Si es valor sólo tiene ceros, y es negativo le saca el signo
	    if (start == 1)
	    {
			var zero = true;
			for (i = 0; i < res.length; i++)
			{
				var c = res.charAt(i);
				if ((c != '0') && (c != ThousandSeparator) && (c != '-'))
				{
					zero = false;
					break;
				}
			}
			if (zero)
			    return res.substr(1);
	    }
	    
		return res;
	}
}

// Determina el ancho que se le asigna a un SPAN
//
// Parámetros:
//   'infoBoxZeroWidth' -> Elemento de la imagen de la gráfica.
//   'infoBoxTextSize'  -> SPAN utilizado para estimar el tamaño de un texto.
//   's'                -> Etiqueta.
//   'l'                -> Largo del valor.
//   'last'             -> Indica si es el último SPAN de una linea.
// Resultado:
//   Ancho.
function cGetSpanWidth(infoBoxZeroWidth, infoBoxTextSize, s, l, last)
{      
    return (cGetBoldStringWidth(infoBoxTextSize, s) + 
        (l + (last ? 1 : 2)) * infoBoxZeroWidth);    
}

// Muestra los valores especificados en el cuadro de texto que se utiliza para indicar la 
// posición del ratón y el elemento seleccionado en la gráfica.
//
// Parámetros:
//   'imageElem' -> Elemento de la imagen de la gráfica.
//   'areaSel'   -> Área a la que corresponde el valor X e Y.
//   'x'         -> Posición X del mouse.
//   'y'         -> Posición Y del mouse.
//   'xReal'     -> Valor X que corresponde a la posición actual.
//   'yReal'     -> Valor Y que corresponde a la posición actual.
//   'xElem'     -> Valor de X del elemento más cercano.
//   'data'      -> Valores de las series.
function cShowInfo(imageElem, areaSel, x, y, xReal, yReal, xElem, data)
{
    var l = imageElem.dataLayout;
    var a = imageElem.dataAreas;
    var infoBoxSeries = imageElem.infoBoxSeries;        
    var infoBox = imageElem.infoBox;
    var infoBoxX = imageElem.infoBoxX;        
    var imageElemId = imageElem.id;     
    var area, serie, infoBoxT, row, cell;
    var i, j, spanIndex, infoBoxPosCell;
    
    // Obtiene la tabla en la que se muestra la posición actual   
    var infoBoxPosTable = document.getElementById(imageElemId + "_IBPT");
    var infoBoxPosTableCell = infoBoxPosTable.rows(0).cells(0);
    
    // Obtiene la posición de la gráfica
	var pos = new Object();
	cGetPosition(imageElem, pos);
	        
    if (!imageElem.infoBoxInited)
    {				    
        // No se inicializó la caja de información. Se inicializa aquí para descargar un poco
        // el proceso de creación de los elementos utilizados para mostrar la posición seleccionada                
        
        // Obtiene el SPAN que se utiliza para medir los textos y lo muestra
        var infoBoxTextSize = document.getElementById(imageElemId + "_TS");
        infoBoxTextSize.style.display = "";
                
        // Obtiene el largo de un 0
        infoBoxTextSize.innerText = "0";        
        var infoBoxZeroWidth = infoBoxTextSize.clientWidth;        
        
        // De ahora en adelante se utiliza el SPAN para medir textos en negrita
        infoBoxTextSize.style.fontWeight = "bold";
                                
        // Calcula el largo de la etiqueta X
        l.sizeX = cGetSpanWidth(infoBoxZeroWidth, infoBoxTextSize, l.labelXEncoded, l.xLength, false);
        infoBoxPosTableCell.childNodes(0).style.width = l.sizeX;			
			
        var isLast, sizeSeries;        
        for (i = 0; i < a.length; i++)
        {
            area = a[i];
            
            // Obtiene la tabla que corresponde al área        
            infoBoxT = document.getElementById(imageElemId + "_IBT" + i);
            row = infoBoxT.rows(0);
        	    
			// Calcula el largo de la etiqueta Y
			area.sizeY = cGetSpanWidth(infoBoxZeroWidth, infoBoxTextSize, area.labelYEncoded, area.yLength, true);            
                        	
            spanIndex = 0;
            sizeSeries = 0;
            cell = row.cells(0);
            for (j = 0; j < area.series.length; j++)
			{
			    serie = area.series[j];			    
				isLast = (j == area.series.length - 1);
			
				switch (serie.type)
				{
					case 1:						
						size = cGetSpanWidth(infoBoxZeroWidth, infoBoxTextSize, "Open", serie.yLength, false);
						cell.childNodes(spanIndex).style.width = size;
						sizeSeries += size;
						spanIndex++;
						
						size = cGetSpanWidth(infoBoxZeroWidth, infoBoxTextSize, "High", serie.yLength, false);
						cell.childNodes(spanIndex).style.width = size;
						sizeSeries += size;
						spanIndex++;
						
						size = cGetSpanWidth(infoBoxZeroWidth, infoBoxTextSize, "Low", serie.yLength, false);
						cell.childNodes(spanIndex).style.width = size;
						sizeSeries += size;
						spanIndex++;
						
						size = cGetSpanWidth(infoBoxZeroWidth, infoBoxTextSize, "Close", serie.yLength, false);						
						cell.childNodes(spanIndex).style.width = size;
						sizeSeries += size;
						spanIndex++;
						break;
					case 2:
						size = cGetSpanWidth(infoBoxZeroWidth, infoBoxTextSize, serie.nameEncoded, serie.yLength, isLast);						
						cell.childNodes(spanIndex).style.width = size;
						sizeSeries += size;
						spanIndex++;
						break;
					default:
						size = cGetSpanWidth(infoBoxZeroWidth, infoBoxTextSize, serie.nameEncoded, serie.yLength, isLast);
						cell.childNodes(spanIndex).style.width = size;
						sizeSeries += size;
						spanIndex++;
						break;
				}				
			}	
			area.sizeSeries = sizeSeries;					
		}				
				
		// Oculta el SPAN utilizado para medir los textos
        infoBoxTextSize.style.display = "none";
        		
        imageElem.infoBoxInited = true;        
        imageElem.infoBoxArea = null;
        imageElem.infoBoxVisible = false;
        imageElem.infoBoxIFVisible = false;
    }
    	
    if (imageElem.infoBoxArea != areaSel)
    {   		        
        // Marca la nueva área seleccionada
    	imageElem.infoBoxArea = areaSel;    	    
    		 	
		// Adjusta el tamaño y la posición de la tabla de posición para mostrar 
		// correctamente la información del área actual
		infoBoxPosTableCell.childNodes(1).style.width = areaSel.sizeY;
		infoBoxPosTableCell.style.width = areaSel.sizeY + l.sizeX + 1;		        				
	}
    
    // Carga los valores del seleccionado en las series
    var infoBoxTables = new Array(a.length);
    var valueIndex = 0;
    for (i = 0; i < a.length; i++)
    {
        area = a[i];
        
        // Obtiene la celda donde se almacenan los valores de la serie para esta área
        infoBoxT = document.getElementById(imageElemId + "_IBT" + i);
        infoBoxTables[i] = infoBoxT;
        row = infoBoxT.rows(0);
        cell = row.cells(0);
				
        // Define la posición X de la tabla (se define aquí, ya que puede haber cambiado
        // si por ejemplo se redimensiona la página por lo tanto siempre se mantiene
        // actualizada)
		infoBoxT.style.left = pos.left + area.boundsLeft - 1;
        	
		// Carga los valores de la serie
		spanIndex = 0;
        for (j = 0; j < area.series.length; j++)
        {
            serie = area.series[j];
            value = data[valueIndex];
            valueIndex++;
                                    
			switch (serie.type)
			{
				case 1:					
					cell.childNodes(spanIndex).innerHTML = "<B>Open:</B> " + (value == null ? "" : cFormatNumber(value[0], serie.yDecimals));
					spanIndex++;
					cell.childNodes(spanIndex).innerHTML = "<B>High:</B> " + (value == null ? "" : cFormatNumber(value[1], serie.yDecimals));
					spanIndex++;
					cell.childNodes(spanIndex).innerHTML = "<B>Low:</B> " + (value == null ? "" : cFormatNumber(value[2], serie.yDecimals));
					spanIndex++;
					cell.childNodes(spanIndex).innerHTML = "<B>Close:</B> " + (value == null ? "" : cFormatNumber(value[3], serie.yDecimals));
					spanIndex++;
					break;
				case 2:					
					cell.childNodes(spanIndex).innerHTML = "<B>" + serie.nameEncoded + ": </B>" + 
						(value == null ? "" : (value[0] == null ? "" :
						cFormatNumber(value[0], serie.yDecimals) + ":" +
						cFormatNumber(value[1], serie.yDecimals)));
					spanIndex++;
					break;				
				default:					
					cell.childNodes(spanIndex).innerHTML = "<B>" + serie.nameEncoded + ": </B>" + (value == null ? "" : cFormatNumber(value, serie.yDecimals));
					spanIndex++;
					break;
			}
        }
    }
    if (imageElem.infoBoxIFVisible)
    {
		// Actualiza la posición horizontal
		var infoBoxIFrame = document.getElementById(imageElemId + "_IBIF");
		infoBoxIFrame.style.left   = infoBoxT.style.left;    
    }
    
    if (!imageElem.infoBoxVisible)
    {   				
   		// Muestras las tablas, y en caso que alguna supere el ancho permitido las reacomoda    
		var margin = 11;
		var areaAdjusted = false;
		for (i = 0; i < infoBoxTables.length; i++)
		{
			infoBoxT = infoBoxTables[i];				
			row = infoBoxT.rows(0);
			area = a[i];
			
			// Fija el ancho máximo de las series
			row.cells(0).style.width = area.sizeSeries;
	        
	        // Muestra la tabla del área
			infoBoxT.style.display = "";			
			
			// Si supera el ancho permitido la reacomoda
			if (infoBoxT.clientWidth > area.boundsRight - area.boundsLeft - margin)
			{    
				// Ajusta la celda con el elemento seleccionado
				var newCellWidth = area.boundsRight - area.boundsLeft - margin;			
				if (newCellWidth < 10)
					newCellWidth = 10;				
				row.cells(0).style.width = newCellWidth;													
				areaAdjusted = true;
			}
			else
				areaAdjusted = false;
			
			// Asigna la posición vertical del cuadro
			infoBoxT.style.top = pos.top + area.boundsTop - infoBoxT.clientHeight - 2;
			
			// Si se ajusto el área 0 le pone un frame detrás por si queda por encima
			// de algún control "windowed" (como un ComboBox)
			if ((i == 0) && (areaAdjusted))
			{
				var infoBoxIFrame = document.getElementById(imageElemId + "_IBIF");
				infoBoxIFrame.style.left   = infoBoxT.style.left;
				infoBoxIFrame.style.top    = infoBoxT.style.top;					
				infoBoxIFrame.style.width  = infoBoxT.clientWidth + 2;
				infoBoxIFrame.style.height = infoBoxT.clientHeight + 2;
				infoBoxIFrame.style.display = "";
				imageElem.infoBoxIFVisible = true;
			}
		}
	    
		imageElem.infoBoxVisible = true;
	}

    if ((xReal != null) && (yReal != null))
    {
		// Obtiene la tabla del área seleccionada y le asigna la posición actual        
		infoBoxPosTableCell.childNodes(0).innerHTML = "<B>" + l.labelXEncoded + ":</B> " + cXFormat(xReal, l);
		infoBoxPosTableCell.childNodes(1).innerHTML = "<B>" + areaSel.labelYEncoded + ":</B> " + cFormatNumber(yReal, areaSel.yDecimals);

		// Muestra la tabla con la posición actual		
		infoBoxPosTable.style.display = "";
	}
	else	
		infoBoxPosTable.style.display = "none";    
		
	// Ajusta la posición de la tabla de con la posición actual
	var ibptWidth  = infoBoxPosTable.clientWidth;
	var ibptHeight = infoBoxPosTable.clientHeight;
	var ibptLeft = pos.left + areaSel.boundsLeft - 1;
	var ibptTop  = pos.top + areaSel.boundsBottom - ibptHeight;	
			
	if ((x >= ibptLeft) && (x <= ibptLeft + ibptWidth + 15) &&
	    (y >= ibptTop - 15) && (y <= ibptTop + ibptHeight))
	{	
	    // El cursor está cerca de la caja de posición, la mueve de lugar
	    if (ibptWidth < (areaSel.boundsRight - areaSel.boundsLeft) / 2)
	    {
	        // La caja de posición no llega a la mitad del ancho, la corre a la derecha
	        ibptLeft = pos.left + areaSel.boundsRight - ibptWidth + 1;
	    }
	    else
	    {
	        // La caja de posición es muy ancha para correrla a la derecha, la corre 
	        // hacia arriba
	        ibptTop = pos.top + areaSel.boundsTop - 1;	
	    }
	}
	var scrollBottom = document.body.scrollTop + document.body.clientHeight;
	if (ibptTop + ibptHeight > scrollBottom)
	{
	    // No se llega a ver el cuadro con la posición actual porque queda fuera de 
	    // la página, lo reajusta para que se vea
		ibptTop = scrollBottom - ibptHeight;
	}
		
	infoBoxPosTable.style.left = ibptLeft;
	infoBoxPosTable.style.top  = ibptTop;	
}

// Oculta los cuadros de texto que se utilizan para indicar la posición del ratón y 
// el elemento seleccionado en la gráfica.
//
// Parámetros:
//   'imageElem' -> Elemento de la imagen de la gráfica.
function cHideInfo(imageElem, x, y, series)
{   
	var a = imageElem.dataAreas;
	var imageElemId = imageElem.id;
	var i, area, infoBoxT;
	
	for (i = 0; i < a.length; i++)
    {
        area = a[i];
        
        // Obtiene la celda donde se almacenan los valores de la serie para esta área
        infoBoxT = document.getElementById(imageElemId + "_IBT" + i);
        infoBoxT.style.display = "none";    
    } 
    document.getElementById(imageElemId + "_IBPT").style.display = "none";
    
    imageElem.infoBoxVisible = false;
    
    if (imageElem.infoBoxIFVisible)
    {
		document.getElementById(imageElemId + "_IBIF").style.display = "none";
		imageElem.infoBoxIFVisible = false;
	}
}

// Se invoca cuando se carga el script.
//
// Parámetros:
//   'imageElem' -> Elemento de la imagen de la gráfica.
//   'script'    -> Script cargado.
function cOnLoadScript(imageElem, script)
{    
    if (script != "")
    {
        var l = null, a = null, e = null, dd = null;
        var attachMouseEvents = false;
        
	    // Evalua el script para crear el arreglo a con las áreas, s con las series y e con
	    // los elementos de las series	    
	    eval(script);
	  
	    if ((l != null) && (a != null) && (e != null))
	    {
			// Inicia el sistema de coordenadas sobre la gráfica
			cInitCoords(imageElem, l, a, e);    
			attachMouseEvents = true;
		}
		
		if (dd != null)
		{
			// Inicia el sistema de drill-down sobre la gráfica
			cInitDrillDown(imageElem, dd);
			attachMouseEvents = true;
		}
		
		if (attachMouseEvents)
		{
		    // Se subscribe a los eventos necesarios para realizar la interacción con la gráfica
			cbAttachEvent(imageElem, "mousemove", cOnMouseMove);
			cbAttachEvent(imageElem, "mouseleave", cOnMouseLeave);    						
			cbAttachEvent(imageElem, "click", cOnClick);
		}
	}
	
	// Libera el objeto del template porque no lo necesitamos más
    imageElem.chartTemplate = null;
}

// Calcula la posición absoluta de la imagen en la página.
//
// Parámetros:
//   'imageElem' -> Elemento de la imagen de la gráfica.
//   'script'    -> Objeto donde se carga la posición.
function cGetPosition(imageElem, pos)
{
    var body = document.body;
    
	pos.left = imageElem.offsetLeft;
	pos.top  = imageElem.offsetTop;
	
    var posParent = imageElem.offsetParent;
    while ((posParent != null) && (posParent != body))
    {
        pos.left += posParent.offsetLeft;
        pos.top  += posParent.offsetTop;
        
        posParent = posParent.offsetParent;
    }
} 

// Se invoca cuando se va a comenzar la seleccion en un elemento. Se utiliza
// para cancelar la selección.
function cOnSelectStart()
{
    return false;
}

// Se invoca cuando se mueve el mouse sobre una imagen que representa una gráfica.
function cOnMouseMove()
{    
    var imageElem = cGetImageElemInEvent(window.event.srcElement);
     
    if (imageElem != null)    
    {
		// Obtiene la posición del elemento
    	var pos = new Object();   
		cGetPosition(window.event.srcElement, pos);

        // Si hay información de los elementos para hacer drill-down, actualiza 
        // la selección actual
		var dd = imageElem.dataDrillDown;
		if ((typeof(dd) != "undefined") && (dd != null))
		{		
		    cUpdateDDSelection(imageElem, pos.left + window.event.offsetX,
		        pos.top + window.event.offsetY);
		}
    
        // Si hay información de las áreas actualiza la coordenada actual
        var l = imageElem.dataLayout;   
		if ((typeof(l) != "undefined") && (l != null))
		{		    
			cUpdateAxis(imageElem, pos.left + window.event.offsetX, 
				pos.top + window.event.offsetY);
		}
	}
}

// Se invoca cuando se mueve el mouse fuera una imagen que representa una gráfica.
function cOnMouseLeave()
{   
    var imageElem = cGetImageElemInEvent(window.event.srcElement);
    
    if (imageElem != null)
    {
		// Obtiene la posición del elemento
    	var pos = new Object();
		cGetPosition(window.event.srcElement, pos);     
		
		// Si hay información de los elementos para hacer drill-down, actualiza 
        // la selección actual
		var dd = imageElem.dataDrillDown;   
		if ((typeof(dd) != "undefined") && (dd != null))
		{		
		    cUpdateDDSelection(imageElem, pos.left + window.event.offsetX,
		        pos.top + window.event.offsetY);
		}
    		
		// Si hay información de las áreas actualiza la coordenada actual        
        var l = imageElem.dataLayout;   
		if ((typeof(l) != "undefined") && (l != null))
		{    
			cUpdateAxis(imageElem, pos.left + window.event.offsetX, 
				pos.top + window.event.offsetY);
		}
    }
}

// Se invoca cuando se hace clic sobre un objeto.
function cOnClick()
{    
    var imageElem = cGetImageElemInEvent(window.event.srcElement);
         
    if (imageElem != null)    
    {
		// Si hay información de los elementos para hacer drill-down, verifica
        // si se hizo clic sobre uno de ellos
		var dd = imageElem.dataDrillDown;
		if ((typeof(dd) != "undefined") && (dd != null))
		{	
			// Obtiene la posición en coordenadas de la página
    		var pos = new Object();   
			cGetPosition(window.event.srcElement, pos);        
			var x = pos.left + window.event.offsetX;
			var y = pos.top + window.event.offsetY;
			
			// Adjusta la posición en coordenadas de la imagen
			cGetPosition(imageElem, pos);        			
			var offsetX = x - pos.left;
			var offsetY = y - pos.top;   
			
			// Verifica si la posición está sobre algún elementp
		    var ele = cDDHitTest(imageElem, offsetX, offsetY)
		    if (ele != null)
		        cDDSubmit(imageElem, ele);
		}
	}
}

// Realiza un submit para enviar un mensaje al servidor web indicando que 
// se hizo clic sobre el elemento especificado
//
// Parámetros:
//   'imageElem' -> Elemento de la imagen de la gráfica.
//   'ele'       -> Elemento sobre el cual se hizo clic.
function cDDSubmit(imageElem, ele)
{
    var form = document.forms[0];

    if (preClick(imageElem.chartClientEvents))
    {    
        form._GP_CHARTCLIENTID.value  = imageElem.chartClientId;
        form._GP_CHARTELEMENTID.value = ele.id;
        GX_setevent("ETXTDRILLDOWN.CLICK.");
        form.submit();    
    }
}

// Determina el elemento de la imagen a partir del objeto en que ocurrió un evento.
// En caso que el elemento no sea una imagen, a partir de su identificador
// se trata de determinar la imagen de la gráfica
//
// Parámetros:
//   'srcElement' -> Elemento en que se produjo .
// Resultado:
//   Elemento de la imagen de la gráfica. null si no se pudo determinar.
function cGetImageElemInEvent(srcElement)
{
    var id, isChartPart;
        
    // Nota: Se observó un caso extraño que al hacer clic en la imagen cuando
    // el cursor no está sobre un eje, a veces cambia el objeto devuelto por 
    // window.event.srcElement, por lo tanto se invoca siempre a este método para
    // legar a la imagen
    
    id = srcElement.id;
    isChartPart = (id.indexOf("chartImg") != -1)
    if (!isChartPart)
    {
        // El elemento actual no tiene un identificador que determine
        // que sea una parte de la gráfica. Busca en su padre
        var parent = srcElement.parentNode
        if (parent != null)
        {
            id = parent.id;
            isChartPart = (id.indexOf("chartImg") != -1)            
        }
    }
    
    if (isChartPart)    
    {
        var k = id.indexOf("_");
        if (k == -1)
            return srcElement;
        else
            return document.getElementById(id.substring(0, k));                           
    }
    
    return null;
}

// Determina que elemento está más cercano al valor X especificado
//
// Parámetros:
//   'layout' -> Layout.
//   'elems' -> Elementos.
//   'xReal' -> Valor de X para el cual se busca el elemento.
function cGetDataIndex(layout, elems, xReal)
{
    var i, xValue, iL, distL, distR, xMin, xMax, xCount, xReal2;    
    
    dataSize = elems[0];
    if (elems.length < dataSize + 1)
    {
        // No hay elementos
        return -1;
    }
    else
    {
        // Estima el indice donde puede estar el valor xReal haciendo una
        // regla de 3 con los extremos del eje X 
        if (layout.xIsDateTime)    
        {
            xMin   = elems[1].getTime();
            xMax   = elems[elems.length - dataSize].getTime();
            xReal2 = xReal.getTime();
        }
        else
        {
            xMin   = elems[1];
            xMax   = elems[elems.length - dataSize];
            xReal2 = xReal;        
        }        
        xCount = (elems.length - 1) / dataSize;        
        if (xCount <= 1)
            xPos = 0;
        else
            xPos = Math.floor(((xReal2 - xMin) * xCount ) / (xMax - xMin));
   
        // En caso que el indice se haya excedido hacia la derecha busca el elemento recorriendo
        // la lista de elementos hacia la izquierda
  	    i = 1 + xPos * dataSize;
  	    while (i > 1 + dataSize)
  	    {
  	        xValue = elems[i];
	        if (xReal < xValue)
	            i -= dataSize;
	        else
	        {
	            i += dataSize;
	            break; 
	        }
  	    }

	    // Busca el elemento hacia la derecha
	    while (i < elems.length)
	    {
	        xValue = elems[i];
	        if (xReal < xValue)
	        {
	            // Encontró el valor. Verifica si está más cerca del anterior
	            iL = i - dataSize;
	            if (iL > 0)
	            {                
	                distL = xReal - elems[iL];
	                distR = xValue - xReal;
	                
	                if (distL < distR)
	                {
	                    // Está más cerca el valor de la izquierda, lo selecciona
	                    i = iL;
	                }
	            }
	            
	            return i;
	        }   
	        else                       
	            i += dataSize;
	    }	    
    
	    // El valor es el último
	    return (elems.length - dataSize);
    }   
}

// Formatea el valor especificado para el área indicada
//
// Parámetros:
//   'xValue' -> Valor de X.
//   'layout' -> Layout de la gráfica.
function cXFormat(xValue, layout)
{
    if (xValue == null)
        return "";
    else if (!layout.xIsDateTime)    
        return cFormatNumber(xValue, layout.xFormat);
    else
    {
        switch (layout.xFormat)
        {
            case 0:
                return xValue.getYear();
            case 1:
                return cFormatNumber2(xValue.getMonth() + 1) + "/" + xValue.getYear();
            case 2:
                return cFormatNumber2(xValue.getDate()) + "/" + cFormatNumber2(xValue.getMonth() + 1) + "/" + xValue.getYear();
            case 3:
                return cFormatNumber2(xValue.getDate()) + "/" + cFormatNumber2(xValue.getMonth() + 1) + "/" + xValue.getYear() + " " + cFormatNumber2(xValue.getHours()) + ":" + cFormatNumber2(xValue.getMinutes());
            case 4:
                return cFormatNumber2(xValue.getHours()) + ":" + cFormatNumber2(xValue.getMinutes());
            case 5:            
                return cFormatNumber2(xValue.getHours()) + ":" + cFormatNumber2(xValue.getMinutes()) + ":" + cFormatNumber2(xValue.getSeconds());
        }
    }
}

// Devuelve una cadena de caracteres con el número expresado en 2 digitos
//
// Parámetros:
//   'n' -> Número.
function cFormatNumber2(n)
{
    if (n < 10)
        return "0" + n.toString();
    else
        return (n % 100).toString();
}

// Actualiza el cuadro de información que indica la
// posición actual en la gráfica especificada.
//
// Parámetros:
//   'imageElem' -> Elemento de la imagen de la gráfica.
//   'areaSel'   -> Área en que esta posicionado el mouse.
//   'x'         -> Posición X del mouse.
//   'y'         -> Posición Y del mouse.
//   'xReal'     -> Valor X que corresponde a la posición actual.
//   'yReal'     -> Valor Y que corresponde a la posición actual.
function cUpdateChartInfo(imageElem, areaSel, x, y, xReal, yReal)
{    
	var timeStart = new Date();
	
    // Determina los valores sobre los cuales se está posicionado
    var dataIndex = cGetDataIndex(imageElem.dataLayout, imageElem.dataElements, xReal);

    // Obtiene el valor X seleccionado, y el de todas las series    
    var l = imageElem.dataLayout;
    var a = imageElem.dataAreas;
    var e = imageElem.dataElements;
    var xElem = (dataIndex == -1 ? null : e[dataIndex]);
    var data = new Array(l.seriesCount);    
    if (dataIndex == -1)
    {
        for (i = 0; i < series.length; i++)
            data[i] = null;                   
    }
    else
    {
        var k = dataIndex + 1;
        var serieIndex = 0, area = null;
	    for (i = 0; i < a.length; i++)
	    {
	        area = a[i];
	        for (j = 0; j < area.series.length; j++)
	        {
				switch (area.series[j].type)
				{   
					case 1:
						data[serieIndex] = new Array(e[k], // Open
							e[k + 3], // High
							e[k + 2], // Low
							e[k + 1]); // Close	                    	                    
						k += 4;
						break;
					case 2:
						data[serieIndex] = new Array(e[k], // Low
							e[k + 1]); // High
						k += 2;
						break;					
					default:
						data[serieIndex] = e[k];
						k++;
						break;
				}
				serieIndex++;
			}
	    }
	}
    
    // Muestra el mensaje en el cuadro de información de la gráfica
    cShowInfo(imageElem, areaSel, x, y, xReal, yReal, xElem, data);
    
    // Registra el tiempo que se llevo mostrar la información
    // de la posición actual    
    var timeEnd = new Date();    
    imageElem.updateInfoTime = (timeEnd - timeStart);    
}

// Actualiza la selección actual de elemento para hacer drill-down (con retardo).
//
// Parámetros:
//   'imageElem' -> Elemento de la imagen de la gráfica.
//   'x'         -> Posición X del mouse.
//   'y'         -> Posición Y del mouse.
function cUpdateDDSelection(imageElem, x, y)
{
    imageElem.updateDDX = x;
	imageElem.updateDDY = y;	
		
	// Actualiza la selección con un retraso para evitar sobrecargar al
	// procesador en máquinas lentas
	var timerFunction = function()
		{
			cUpdateDDSelectionNow(imageElem, imageElem.updateDDX, imageElem.updateDDY);
			imageElem.updateDDTimer = null;
		}
	
	if (imageElem.updateDDTimer == null)					
		imageElem.updateDDTimer = window.setTimeout(timerFunction, 20);			
}

// Actualiza la posición de los ejes (con retardo).
//
// Parámetros:
//   'imageElem' -> Elemento de la imagen de la gráfica.
//   'x'         -> Posición X del mouse.
//   'y'         -> Posición Y del mouse.
function cUpdateAxis(imageElem, x, y)
{
    imageElem.updateAxisX = x;
	imageElem.updateAxisY = y;	
		
	// Actualiza el eje con un retraso para producir un movimiento
	// más suave		
	var timerFunction = function()
		{		    
			cUpdateAxisNow(imageElem, imageElem.updateAxisX, imageElem.updateAxisY);
			imageElem.updateAxisTimer = null;
		}
	
	if (imageElem.updateAxisTimer == null)
	{	
		var dist = Math.max(Math.abs(imageElem.updateAxisX - x), Math.abs(imageElem.updateAxisY - y));
		var delay = Math.min(50 + 2 * imageElem.updateAxisTime, dist * imageElem.updateAxisTime) + 20;		
		imageElem.updateAxisTimer = window.setTimeout(timerFunction, delay);	
	}			
}

// Actualiza inmediatamente la selección actual del elemento para hacer
// drill-down.
//
// Parámetros:
//   'imageElem' -> Elemento de la imagen de la gráfica.
//   'x'         -> Posición X del mouse.
//   'y'         -> Posición Y del mouse.
function cUpdateDDSelectionNow(imageElem, x, y)
{	
	var pos = new Object();
    cGetPosition(imageElem, pos);
    var offsetX = x - pos.left;
    var offsetY = y - pos.top;
    
    // Obtiene el elemento sobre el cual está la coordenada
    var sel = cDDHitTest(imageElem, offsetX, offsetY);
    
    var ddSelection = imageElem.ddSelection;
    if (sel != ddSelection)
    {    
		var jg = imageElem.jsGraphics;
		jg.clear();
		
		// Actualiza el cursor
		if (sel == null)						
			cUpdateCursor(imageElem, "");
		else if (ddSelection == null)
			cUpdateCursor(imageElem, "hand");
		
		if (sel != null)
		{
		    // Fija la posiciòn del DIV donde se dibuja la selección actual
		    var ddDiv = document.getElementById(imageElem.id + "_DD");
		    var style = ddDiv.style;
		    style.left = pos.left;
			style.top  = pos.top;    

			// Dibuja el elemento seleccionado        
			switch (sel.type)
			{
				case 'C':                    	
				    var margin = Math.floor(jg.stroke / 2);			    				    
					jg.drawEllipse(sel.x - sel.r - margin, sel.y - sel.r - margin, 
					    sel.r * 2 + margin, sel.r * 2 + margin);
					jg.paint();
					break;
				case 'P': 
					var margin = Math.floor(jg.stroke / 2);
					var xAdj = new Array(sel.x.length);
					var yAdj = new Array(sel.y.length);
					for (var i = 0; i < xAdj.length; i++)
					{
					    xAdj[i] = sel.x[i] - margin;
					    yAdj[i] = sel.y[i] - margin;
					}
					jg.drawPolygon(xAdj, yAdj);
					jg.paint();
					break;
			}        		    
		}
				
		imageElem.ddSelection = sel;
	}
}

// Actualiza el cursor definido para que se muestre cuando el mouse está
// sobre la gráfica
//
// Parámetros:
//   'imageElem' -> Elemento de la imagen de la gráfica.
//   'cursor'    -> Nuevo cursor.
function cUpdateCursor(imageElem, cursor)
{
    var imageElemId = imageElem.id;
	var ddDiv = document.getElementById(imageElem.id + "_DD");    
		
	imageElem.style.cursor = cursor;
	ddDiv.style.cursor = cursor;
	
	// Si tiene ejes los actualiza
	var a = imageElem.dataAreas;
	if (a != null)
	{		
        var axisY = document.getElementById(imageElemId + "_Y");
        if (axisY != null)
			axisY.style.cursor = cursor;
		var axisX;
        for (i = 0; i < a.length; i++)                
        {
            axisX = document.getElementById(imageElemId + "_X" + i);
            axisX.style.cursor = cursor;        
        }
	}
}

// Verifica si la posición x, y especificada está sobre algún elemento sobre
// el cual se puede hacer drill-down.
//
// Parámetros:
//   'imageElem' -> Elemento de la imagen de la gráfica.
//   'x'         -> Posición X.
//   'y'         -> Posición Y.
// Resultado:
//   Elemento sobre el cual están las coordenadas. null si no hay un elemento
//   debajo de las coordenadas.
function cDDHitTest(imageElem, x, y)
{
    var sel = imageElem.ddSelection;
    
    if (sel != null)
    {
        // Verifica si las coordenadas están sobre la selección actual
        if (cDDHitTestCheck(imageElem, sel, x, y))
            return sel;
    }
    
    // Verifica si está sobre algún elemento
    var dd = imageElem.dataDrillDown;        
    var e;
    for (var i = 0; i < dd.length; i++)
    {
        e = dd[i];        
        if (cDDHitTestCheck(imageElem, e, x, y))
            return e;        
    }
}

// Verifica si la posición x, y especificada está sobre el elemento (para
// hacer drill-down) especificado.
//
// Parámetros:
//   'imageElem' -> Elemento de la imagen de la gráfica.
//   'e'         -> Elemento para el cual se hace la verificación.
//   'x'         -> Posición X.
//   'y'         -> Posición Y.
// Resultado:
//   true si las coordenadas están sobre el elemento, false en caso contrario.
function cDDHitTestCheck(imageElem, e, x, y)
{
    switch (e.type)
    {
        case 'C':
            var distX = x - e.x;
            var distY = y - e.y;
            var dist = Math.sqrt(distX * distX + distY * distY);            
            return (dist <= e.r);
        case 'P':
            return cPointInPolygon(x, y, e.x, e.y);			
    }
    
    return false;
}

// Verifica si la posición x, y especificada está dentro de un poligono.
//
// Parámetros:
//   'x'         -> Posición X.
//   'y'         -> Posición Y.
//   'xPoints'   -> Arreglo con las coordenadas X de los puntos del poligono.
//   'yPoints'   -> Arreglo con las coordenadas Y de los puntos del poligono.
// Resultado:
//   true si las coordenadas están sobre el elemento, false en caso contrario.
function cPointInPolygon(x, y, xPoints, yPoints) 
{
	var i, j = 0;
	var oddNODES = false;

	var polySides = xPoints.length;
	for (i = 0; i < polySides; i++) 
	{
		j++; 
		if (j == polySides) 
			j=0;
	
		if (((yPoints[i] < y) && (yPoints[j]>=y)) ||
			((yPoints[j] < y) && (yPoints[i] >= y)))
		{
			if (xPoints[i] + (y - yPoints[i]) / 
				(yPoints[j] - yPoints[i]) * (xPoints[j] - xPoints[i]) < x)
			{
				oddNODES = !oddNODES; 
			}
		}
	}        
	
	return oddNODES; 
}

// Actualiza inmediatamente la posición de los ejes.
//
// Parámetros:
//   'imageElem' -> Elemento de la imagen de la gráfica.
//   'x'         -> Posición X del mouse.
//   'y'         -> Posición Y del mouse.
function cUpdateAxisNow(imageElem, x, y)
{
    var xReal, yReal, i, style, needUpdateTimer;

    // Registra el tiempo que se llevo mostrar la información
    // de la posición actual    
    var timeStart = new Date();
	    
    var a = imageElem.dataAreas;    
    var l = imageElem.dataLayout;        
    var imageElemId = imageElem.id;
    
    // Obtiene el desplazamiento de x e y con respecto a la
    // gráfica
    var pos = new Object();
    cGetPosition(imageElem, pos);
    var offsetX = x - pos.left;
    var offsetY = y - pos.top;
    
    // Verifica si la posición está dentro de algún area (en caso que
    // esté en una separación selecciona la de arriba)
    var area = null;    
    for (i = 0; i < a.length; i++)
    {
        var areaI = a[i];
        var boundsTop = (i == 0 ? areaI.boundsTop : (a[i - 1].boundsBottom + areaI.boundsTop) / 2);
        var boundsBottom = (i == a.length - 1 ? areaI.boundsBottom : (a[i + 1].boundsTop + areaI.boundsBottom) / 2);        
        
        if ((areaI.boundsLeft <= offsetX) &&
	        (offsetX <= areaI.boundsRight) &&
	        (boundsTop <= offsetY) && 
	        (offsetY <= boundsBottom))            
        {
            area = areaI;
            break;
        }
    }
    
    if (area == null)
    {
        // El ratón no está sobre ninguna área. Oculta todos los ejes
        if (imageElem.updateAxisTimer != null)
        {
			window.clearTimeout(imageElem.updateAxisTimer);
			imageElem.updateAxisTimer = null;
        }                    
        if (imageElem.updateInfoTimer != null)
        {
			window.clearTimeout(imageElem.updateInfoTimer);
			imageElem.updateInfoTimer = null;               
        }
        
        // Oculta los ejes
        document.getElementById(imageElemId + "_Y").style.visibility = "hidden";
        for (i = 0; i < imageElem.dataAreas.length; i++)                
            document.getElementById(imageElemId + "_X" + i).style.visibility = "hidden";        

		// Crea un temporizador para ocultar la información para que
		// en caso que se mueva el mouse de un área a otra, o se saque
		// y se vuelva a agregar rapidamente, no parpadee el cuadro de
		// información
		if (imageElem.hideInfoTimer != null)
            window.clearTimeout(imageElem.hideInfoTimer);                		
		timerFunction = function()
		{
			cHideInfo(imageElem);
			imageElem.hideInfoTimer = null;
		}
			
		imageElem.hideInfoTimer = window.setTimeout(timerFunction, 200);
    }
	else
    {    
        // El ratón está sobre un área. Define la posición de los ejes
        
        // Pone visible el eje Y si el ratón está dentro del área
        var axisY = document.getElementById(imageElemId + "_Y");
        style = axisY.style;
        if ((area.boundsTop <= offsetY) && (offsetY <= area.boundsBottom))
        {
			style.top   = y;
			style.left  = pos.left + area.boundsLeft;
			style.width = area.boundsRight - area.boundsLeft;
			style.visibility = "visible";
			
			yReal = area.minY + ((area.boundsBottom - offsetY) * (area.maxY - area.minY)) / (area.boundsBottom - area.boundsTop);        
		}
        else        
        {   
			style.visibility = "hidden";        
			
			yReal = null;             
		}			
				
		// Pone visibles los ejes sobre X
        for (i = 0; i < a.length; i++)
        {
            var axisX = document.getElementById(imageElemId + "_X" + i);            
            var areaI = a[i];
    	    style = axisX.style;
	        style.left = x;    
	        style.top = areaI.boundsTop + pos.top;                
	        style.visibility = "visible";
        }

		// Determina la coordenadas reales que coresponden a la posición del ratón sobre el área
        if (l.xIsDateTime)
        {
		    xReal = new Date();
            xReal.setTime(area.minX.getTime() + ((offsetX - area.boundsLeft) * (area.maxX.getTime() - area.minX.getTime())) / (area.boundsRight - area.boundsLeft));
        }
        else        
            xReal = area.minX + ((offsetX - area.boundsLeft) * (area.maxX - area.minX)) / (area.boundsRight - area.boundsLeft);                        

        // Si el movimiento es corto (despacio) se hace
        // la actualización más rápida
        var dist = Math.max(Math.abs(imageElem.updateInfoX - x),
			Math.abs(imageElem.updateInfoY - y));
		var fastInfoUpdate = (dist < 20);
		
		if (imageElem.updateInfoTimer == null)        
			needUpdateTimer = true;
		else
		{
			if (fastInfoUpdate)
				needUpdateTimer = (!imageElem.updateInfoFast);					
			else
			{
				needUpdateTimer = ((imageElem.updateInfoArea != area) ||
					(Math.abs(imageElem.updateInfoX - x) > 10) ||
					(Math.abs(imageElem.updateInfoY - y) > 10));					    
			}	
		}

        // Asigna los elementos que se actualizan        
		imageElem.updateInfoX     = x;
        imageElem.updateInfoY     = y;      
        imageElem.updateInfoXReal = xReal;
        imageElem.updateInfoYReal = yReal;               
		imageElem.updateInfoArea  = area; 
        imageElem.updateInfoFast  = fastInfoUpdate;

        if (needUpdateTimer)
        {
            if (imageElem.hideInfoTimer != null)
            {				
				window.clearTimeout(imageElem.hideInfoTimer);
				imageElem.hideInfoTimer = null;
            }
            if (imageElem.updateInfoTimer != null)
                window.clearTimeout(imageElem.updateInfoTimer);
                
			// Crea un temporizador para actualizar la información
			// con retraso, para que en caso que se este moviendo
			// el mouse no se actualice hasta que se deje quieto
			var timerFunction = function()
			{
			    // Actualiza la información sólo si no está habilitado
			    // el timer para ocultar, ya que se pudiera haber iniciado
			    // antes que se ejecutara esta función
			    if (imageElem.hideInfoTimer == null)
					cUpdateChartInfo(imageElem, imageElem.updateInfoArea,
					imageElem.updateInfoX, imageElem.updateInfoY,
					imageElem.updateInfoXReal, imageElem.updateInfoYReal);
				imageElem.updateInfoTimer = null;
			}
			
			var delay = (fastInfoUpdate ? dist * 6 + imageElem.updateInfoTime: 
				Math.min(1000, imageElem.updateInfoTime * 2));
			imageElem.updateInfoTimer = window.setTimeout(timerFunction, delay);
		}
    }
    
    var timeEnd = new Date();    
    imageElem.updateAxisTime = (timeEnd - timeStart);
}

// Inicia el sistema de coordenadas de una imagen para que al mover el ratón
// sobre ella se marque la coordenada actual.
//
// Parámetros:
//   'imageElem' -> Elemento de la imagen de la gráfica.
//   'l'         -> Datos generales de la gráfica.
//   'a'         -> Áreas del gráfico.
//   'e'         -> Elementos que representan valores en el gráfico.
function cInitCoords(imageElem, l, a, e)
{
    var i, style;      

    // Asigna los datos a la imagen
    imageElem.dataLayout   = l;
    imageElem.dataAreas    = a;    
    imageElem.dataElements = e;

    // Inicializa la propiedad que se utiliza para controlar
    // el temporizador que actualiza la posición actual
    // sobre la gráfica
    imageElem.updateInfoTimer = null;
    imageElem.updateInfoTime  = 20;
    imageElem.updateAxisTime  = 20;
	imageElem.updateAxisX     = 0;
    imageElem.updateAxisY     = 0;        
    imageElem.updateInfoX     = 0;
    imageElem.updateInfoY     = 0;    

    // Obtiene la posición de la gráfica 
    var pos = new Object();
    cGetPosition(imageElem, pos);

    // Le asigna un identificador a cada área y determina el ancho máximo
    var width = 0;
    var area;    
    for (i = 0; i < a.length; i++)
    {
        area = a[i];
        area.id = i;
            
        w = area.boundsRight - area.boundsLeft + 1;
        if (w > width)
            width = w;       
    }
    
    var template = imageElem.chartTemplate;
    var imageElemId = imageElem.id;
    var parent = imageElem.parentNode;
    
    // Crea un iframe que se utiliza para indicar el elemento actualmente seleccionado        
    // en el área 0 ya que pueden haber ComboBox (o algún otro control windowed detrás)
    var infoBoxIFrame = template.infoBoxIFrame.cloneNode(true);
    infoBoxIFrame.id = imageElemId + "_IBIF";
    parent.appendChild(infoBoxIFrame);        

    // Crea una celda para marcar la posición actualmente seleccionado
	var infoBoxPosTable = template.infoBoxPosTable.cloneNode(true);		
	infoBoxPosTable.id = imageElemId + "_IBPT";
	parent.appendChild(infoBoxPosTable);
	
    // Crea las tablas para mostrar la información de cada área
    var infoBoxTable, infoBoxEleTd;
    for (i = 0; i < a.length; i++)
    {
        area = a[i];
        
        infoBoxTable = template.infoBoxTable.cloneNode(true);
        infoBoxTable.id = imageElemId + "_IBT" + i;
        if (i == 0)
            infoBoxTable.style.paddingBottom = "3px";
        row = infoBoxTable.rows(0);
        infoBoxEleTd = row.cells(0);        
        
        // Crea los SPAN's de las series del área
        for (j = 0; j < area.series.length; j++)
        {
			switch (area.series[j].type)
			{
			    case 1:
					infoBoxEleTd.appendChild(template.infoBoxSpan.cloneNode(true));
					infoBoxEleTd.appendChild(template.infoBoxSpan.cloneNode(true));
					infoBoxEleTd.appendChild(template.infoBoxSpan.cloneNode(true));
					infoBoxEleTd.appendChild(template.infoBoxSpan.cloneNode(true));
					break;
				default:
					infoBoxEleTd.appendChild(template.infoBoxSpan.cloneNode(true));
					break;
			}
        }
                
	    parent.appendChild(infoBoxTable);
    }
    imageElem.infoBoxInited = false;
    
    // Crea un SPAN que se utiliza para medir el largo de los textos
    var textSizeSpan = template.textSizeSpan.cloneNode(true);
    textSizeSpan.id = imageElemId + "_TS";
    parent.appendChild(textSizeSpan);
                
    // Crea un elemento que se utiliza para representa una posición sobre el eje Y
    var axisY = template.axisY.cloneNode(true);
    style = axisY.style;        
    axisY.id = imageElemId + "_Y";
    parent.appendChild(axisY);    
    
    // Crea un elemento por cada área que se utiliza para dibujar la posición sobre el eje X de
    // dicha área    
    var axisX;
    for (i = 0; i < a.length; i++)
    {    
        axisX = template.axisX.cloneNode(true);
        area = a[i];
        style = axisX.style;
        style.height = area.boundsBottom - area.boundsTop + 1;        
        axisX.id = imageElemId + "_X" + i;
        parent.appendChild(axisX);        
    }        
}

// Inicia el sistema de drill down de una gráfica para que se puedan
// seleccionar elemento de ella.
//
// Parámetros:
//   'imageElem' -> Elemento de la imagen de la gráfica.
//   'dd'        -> Definición de los elementos sobre los cuales se hace drill-down.
function cInitDrillDown(imageElem, dd)
{
	// Asigna los datos de drill-down a la imagen
    imageElem.dataDrillDown = dd;
    
    // Crea un elemento sobre el cual se dibujan los elementos seleccionados
    // en la gráfica
    var ddDiv = imageElem.chartTemplate.ddDiv.cloneNode(true);        
    ddDiv.id = imageElem.id + "_DD";
    var style = ddDiv.style;
    style.left    = 0;
	style.top     = 0;           
    style.width   = imageElem.chartWidth;
    style.height  = imageElem.chartHeight;    
    style.display = "";
    imageElem.parentNode.appendChild(ddDiv);       
    
    // Inicializa el objeto para dibujar las figuras para marcar la selección
    // actual
    var jg = new jsGraphics(ddDiv.id);
    jg.setColor("#9F4040"); 
    jg.setStroke(3);
    imageElem.jsGraphics = jg;
    
    // Inicializa algunas propiedades utilizadas para hacer el drill-down
    imageElem.ddSelection = null;    
}

// Se invoca cuando se termina de cargar la imagen de una gráfica
function cOnLoad() 
{  
    var imageElem = window.event.srcElement;
    var serverId = imageElem.chartServerId;
    var serverSeed = imageElem.chartServerSeed;
    var serverUrl = imageElem.chartServerUrl;
        
        
	// Define la URL con que se pide el script
	var scriptUrl;
    if (serverId != 0)
		scriptUrl = serverUrl + "/GetScript.ashx?id=" + serverId + "&s=" + serverSeed;
	else
	{
	    // Este es un caso especial en el cual no se tiene un identificador
	    // asignado por el servidor, sino que directamente se le mandan los
	    // parametros en la URL (los parametros están en 'serverSeed')
	    scriptUrl = serverUrl + "/GetScript.ashx?p=" + serverSeed;
	}
	scriptUrl += "&w=" + imageElem.chartWidth + "&h=" + imageElem.chartHeight;

    // Pide el script de interactividad al servidor de gráficas
    cGetScript(scriptUrl, cOnLoadScript, imageElem);    
}

// Se invoca cuando ocurre un error al cargar la gráfica
function cOnError()
{
	var imageElem = window.event.srcElement;

    if ((typeof(imageElem.reloadTries) == "undefined") ||
		(imageElem.reloadTries == null))
		imageElem.reloadTries = 0;		
    
    // Ocurrió un error al cargar la gráfica, reasigna el source
    // e intenta devuelta (hasta 2 veces)
    if (imageElem.reloadTries < 2)
    {		
		imageElem.reloadTries++;		
		imageElem.src = imageElem.src;    
    }
}

// Crea la plantilla para las gráficas.
//
// Resultado:
//   Plantilla creada.
function cCreateTemplate()
{
    var template = new Object();        
 
    // Crea el DIV externo que se utiliza para alinear las gráficas
    var extDiv = document.createElement("DIV");
    extDiv.align = "center";    
    template.extDiv = extDiv;
        
    // Crea la tabla base cuando se debe poner más de una gráfica
    var extTable = document.createElement("TABLE");
    extTable.border = 0;
    extTable.cellpadding = 0;
    extTable.cellspacing = 0;
    var extTableTBody = document.createElement("TBODY");  
    extTable.appendChild(extTableTBody);                  
    var extTableRow = document.createElement("TR");  
    extTableTBody.appendChild(extTableRow);    
    template.extTable = extTable;
            
    // Crea la imagen de la gráfica
    var chartImg = document.createElement("IMG");
    chartImg.galleryimg = "no";    
	cbAttachEvent(chartImg, "error", cOnError);
	cbAttachEvent(chartImg, "selectstart", cOnSelectStart);
    template.chartImg = chartImg;
    
    // Crea los ejes    
    var axisX = document.createElement("div");
    var style = axisX.style;
    style.backgroundColor = "#606060";
    style.position = "absolute";        
    style.top      = 0;                
    style.height   = 10;
    style.width    = 1;
    style.zIndex   = 5;
    style.visibility = "hidden";        
    cbAttachEvent(axisX, "mousemove", cOnMouseMove);
    cbAttachEvent(axisX, "mouseleave", cOnMouseLeave);
    cbAttachEvent(axisX, "click", cOnClick);
    cbAttachEvent(axisX, "selectstart", cOnSelectStart);
    template.axisX = axisX;
    var axisY = document.createElement("IMG");
    style = axisY.style;
    style.backgroundColor = "#606060";
    style.position = "absolute";
    style.left     = 0;
    style.height   = 1;
    style.width    = 10;
    style.zIndex   = 5;
    style.visibility = "hidden";
    cbAttachEvent(axisY, "mousemove", cOnMouseMove);
    cbAttachEvent(axisY, "mouseleave", cOnMouseLeave);
    cbAttachEvent(axisY, "click", cOnClick);
    cbAttachEvent(axisY, "selectstart", cOnSelectStart);    
    template.axisY = axisY;

    // Crea la caja de texto para mostrar la selección actual
    var infoBoxIFrame = document.createElement("IFRAME");
    infoBoxIFrame.scrolling = "no";
    infoBoxIFrame.frameBorder = 0;    
    style = infoBoxIFrame.style;    
    style.position      = "absolute";
    style.left          = 1;
    style.top           = 1;
    style.display       = "none";    
    style.zIndex        = 6;
    template.infoBoxIFrame = infoBoxIFrame;    
    var infoBoxTable = document.createElement("TABLE");
	infoBoxTable.cellSpacing = 0;
    infoBoxTable.cellPadding = 0;    
    style = infoBoxTable.style;
    style.border        = 1;    
    style.borderColor   = "#000000";    
    style.borderStyle   = "solid";
    style.paddingLeft   = 4;
    style.paddingRight  = 4;
    style.paddingTop    = 2;    
    style.paddingBottom = 2;    
    style.position      = "absolute";
    style.left          = 1;
    style.top           = 1;
    style.display       = "none";    
    style.fontFamily    = "Arial";   
    style.fontSize      = "8pt";    
    style.zIndex        = 7;    
    var infoBoxTBody = document.createElement("TBODY");  
    infoBoxTable.appendChild(infoBoxTBody);      
    var infoBoxTr = document.createElement("TR");
    infoBoxTr.vAlign = "top";
    infoBoxTBody.appendChild(infoBoxTr);
    var infoBoxTd = document.createElement("TD");
    infoBoxTd.bgColor = "#D0D0D0";
    infoBoxTd.style.paddingLeft = 8;    
    infoBoxTr.appendChild(infoBoxTd);            
    template.infoBoxTable = infoBoxTable;    
    
    // Crea una tabla que se utiliza para la posición actual
    var infoBoxPosTable = document.createElement("TABLE");
	infoBoxPosTable.cellSpacing = 0;
    infoBoxPosTable.cellPadding = 0;    
    style = infoBoxPosTable.style;
    style.border        = 1;    
    style.borderColor   = "#000000";    
    style.borderStyle   = "solid";
    style.paddingLeft   = 4;
    style.paddingRight  = 4;
    style.paddingTop    = 2;    
    style.paddingBottom = 2;    
    style.position      = "absolute";
    style.left          = 1;
    style.top           = 1;
    style.display       = "none";    
    style.fontFamily    = "Arial";   
    style.fontSize      = "8pt";    
    style.zIndex        = 7;    
    infoBoxTBody = document.createElement("TBODY");  
    infoBoxPosTable.appendChild(infoBoxTBody);      
    infoBoxTr = document.createElement("TR");
    infoBoxTr.vAlign = "top";
    infoBoxTBody.appendChild(infoBoxTr);
    infoBoxTd = document.createElement("TD");
    infoBoxTd.bgColor = "#DDDDDD";            
    infoBoxTr.appendChild(infoBoxTd);
    infoBoxSpan = document.createElement("SPAN");
    infoBoxSpan.style.whiteSpace = "nowrap";
    infoBoxTd.appendChild(infoBoxSpan);        
    infoBoxSpan = document.createElement("SPAN");    
    infoBoxSpan.style.whiteSpace = "nowrap";
    infoBoxTd.appendChild(infoBoxSpan);      
    template.infoBoxPosTable = infoBoxPosTable;
    
    // Crea un SPAN que se utiliza para medir los textos    
   	var textSizeSpan = document.createElement("SPAN");
	style = textSizeSpan.style;
    style.whiteSpace = "nowrap";
    style.position   = "absolute";
    style.display    = "none";
	style.fontFamily = "Arial";
    style.fontSize   = "8pt";    
    style.left       = 1;
    style.top        = 1;
    style.zIndex     = 1;
    template.textSizeSpan = textSizeSpan;
    
    // Crea un SPAN que se utiliza para mostrar los valores de las series
    infoBoxSpan = document.createElement("SPAN");
	infoBoxSpan.style.whiteSpace = "nowrap";
	template.infoBoxSpan = infoBoxSpan;	
	
	// Crea un DIV que se utiliza para mostrar el elemento seleccionado para hacer
	// drill-down
	var ddDiv = document.createElement("DIV");
	style = ddDiv.style;    
    style.position   = "absolute";   
    style.zIndex     = 4; 
    cbAttachEvent(ddDiv, "mousemove", cOnMouseMove);
    cbAttachEvent(ddDiv, "mouseleave", cOnMouseLeave);
    cbAttachEvent(ddDiv, "click", cOnClick);
    cbAttachEvent(ddDiv, "selectstart", cOnSelectStart);        
	template.ddDiv = ddDiv;    
					
    return template;
}

// Crea una nueva instancia de una gráfica
//
// Parámetros:
//   'cont'         -> Contenedor. Es el objeto donde se agrega la gráfica creada.
//   'template'     -> Plantilla de gráficas.
//   'serverUrl'    -> URL del servidor de gráfica.
//   'maxLineWidth' -> Ancho máximo de una linea.
//   'charts'       -> Definición de las gráficas.
function cCreateChart(cont, template, serverUrl, maxLineWidth, charts)
{    
    var i, first, endOfLine, width, heigth, lineWidth, noVisibleWidth, interactive, clientEvents;
 
    var extDiv = template.extDiv.cloneNode(true);  
    var extTable = null, extTableTB = null, row = null, cell = null;
    
    // Agrega el DIV dentro del contenedor de la página    
    cont.appendChild(extDiv);
    
    i = 0;
    first = true;
    lineWidth = 0;
    noVisibleWidth = 0;
    while (i < charts.length)
    {
        visible      = charts[i];
        width        = charts[i + 1];
        height       = charts[i + 2]; 
        clientId     = charts[i + 3];
        serverId     = charts[i + 4];
        serverSeed   = charts[i + 5];
        interactive  = charts[i + 6];
        clientEvents = charts[i + 7];
    
        // Mueve el indice, y verifica si se llegó al fin de la linea
        i += 8;
        if (i < charts.length)
        {
            if (charts[i] == null)
            {            
                endOfLine = true;
                i++;
            }
        }    
        else
            endOfLine = true;
        
        if ((first) && (endOfLine) && (width == maxLineWidth))
        {
            if (visible == 1)
            {
	            // No es necesario definir la tabla así que escribe la imagen directamente
	            cWriteChart(extDiv, template, serverUrl, width, height, clientId, serverId, serverSeed, interactive, clientEvents);
	            extDiv.appendChild(document.createElement("BR"));
            }
        }
        else
        {
            if ((visible == 0) && ((!endOfLine) || (first)))
            {
                // La gráfica no esta visible, y aún no se dibujo ninguna (first es true) o 
                // no se llegó aún al fin de la linea. Acumula el ancho de la gráfica para
                // luego agregar una celda que lo ocupe (si hay algun gráfica en la fila)
                noVisibleWidth += width;
            }
            else
            {        
		        // Escribe el código de la gráfica        
		        if (first)            
		        {       					
		            extTable = template.extTable.cloneNode(true);             		            
		            row = extTable.rows(0);		            
		            first = false;
		        }
	            if (noVisibleWidth != 0)
	            {
	                cell = document.createElement("TD");
	                cell.width = noVisibleWidth;
	                row.appendChild(cell);
	   	            lineWidth += noVisibleWidth;                     
	   	            noVisibleWidth = 0;      
		        }
		        if (visible == 1)
		        {
			        cell = document.createElement("TD");
			        cWriteChart(cell, template, serverUrl, width, height, clientId, serverId, serverSeed, interactive, clientEvents);
			        row.appendChild(cell);
			        lineWidth += width;                           
			    }
		        if (endOfLine)
		        {
		            if (lineWidth < maxLineWidth)
		            {
		                cell = document.createElement("TD");
		                cell.width = (maxLineWidth - lineWidth);
		                row.appendChild(cell);
		            }
		            extDiv.appendChild(extTable);
		        }
		    }
	    }
	    
	    if (endOfLine)
	    {
            // Inicializa las variables para la próxima linea
            first = true;
            lineWidth = 0;
            noVisibleWidth = 0;
            endOfLine = false;
	    }
    }    
}

// Escribe el código de una gráfica
//
// Parámetros:
//   'parent'       -> Objeto padre.
//   'template'     -> Plantilla.
//   'serverUrl'    -> URL del servidor de gráfica.
//   'width'        -> Ancho de la imagen.
//   'height'       -> Altura de la imagen.
//   'clientId'     -> Identificador de la gráfica en el cliente.
//   'serverId'	    -> Identificador de la gráfica en el servidor de gráficas.
//   'serverSeed'   -> Semilla de la gráfica en el servidor de gráficas.
//   'interactive'  -> 1 si tiene contenido interactivo.
//   'clientEvents' -> Eventos a nivel de cliente que se generarán ante el evento drill-down.
function cWriteChart(parent, template, serverUrl, width, height, clientId, serverId, serverSeed, interactive, clientEvents)
{
    var chartImg = template.chartImg.cloneNode(true);
    var url;
      
    chartImg.id = "chartImg" + clientId;
    chartImg.chartWidth = width;
    chartImg.chartHeight = height;
    chartImg.chartClientId = clientId;
    chartImg.chartClientEvents = clientEvents;
        
    // Define la URL de la imagen
    if (serverId != 0)
		url = serverUrl + "/GetChart.ashx?id=" + serverId + "&s=" + serverSeed + "&w=" + width + "&h=" + height;
	else
	{
	    // Este es un caso especial en el cual no se tiene un identificador
	    // asignado por el servidor, sino que directamente se le mandan los
	    // parametros en la URL (los parametros están en 'serverSeed')
	    url = serverUrl + "/GetChart.ashx?p=" + serverSeed + "&w=" + width + "&h=" + height;
	}	        		
    
    if (interactive == 1)
    {
        chartImg.chartServerUrl  = serverUrl;
        chartImg.chartServerId   = serverId;
        chartImg.chartServerSeed = serverSeed;        
        
        cbAttachEvent(chartImg, "load", cOnLoad);        
        chartImg.chartTemplate = template;    
    }

    parent.appendChild(chartImg);
    chartImg.src = url;
}
