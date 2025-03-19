// Inicializa una nueva instancia del tipo PageTemplates
function PageTemplates()
{
    // Crea las plantillas
    pTCreateTemplates(this);    
}

// Inicializa una nueva instancia del tipo PageBuilder
//
// Parámetros:
//   'temp' -> Plantillas para construir la página.
//   'cont' -> Identificador del contenedor.
function PageBuilder(tmp, cont)
{
    this.tmp  = tmp;
    this.cont = document.getElementById(cont);
}

// Crea las plantillas de los objetos
//
// Parámetros:
//   'pt' -> Objeto de tipo PageTemplates donde se almacenan las plantillas.
function pTCreateTemplates(pt)
{
    pt.chart = pTCreateChartTemplate();    
}

// Crea la plantilla para las gráficas.
//
// Resultado:
//   Plantilla creada.
function pTCreateChartTemplate()
{
    return cCreateTemplate();
}

// Crea una nueva instancia de una gráfica
//
// Parámetros:
//   'serverUrl'    -> URL del servidor de gráfica.
//   'maxLineWidth' -> Ancho máximo de una linea.
//   'charts'       -> Definición de las gráficas.
function pBCreateChart(serverUrl, maxLineWidth, charts)
{
    cCreateChart(this.cont, this.tmp.chart, serverUrl, maxLineWidth, charts);
}

// Define los métodos del constructor de página. Los nombres de los métodos
// tienen nombres cortos para disminuir el tamaño del HTML generado.
PageBuilder.prototype.c = pBCreateChart;