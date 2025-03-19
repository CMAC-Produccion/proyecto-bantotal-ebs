// Inicializa una nueva instancia del tipo PageTemplates
function PageTemplates()
{
    // Crea las plantillas
    pTCreateTemplates(this);    
}

// Inicializa una nueva instancia del tipo PageBuilder
//
// Par�metros:
//   'temp' -> Plantillas para construir la p�gina.
//   'cont' -> Identificador del contenedor.
function PageBuilder(tmp, cont)
{
    this.tmp  = tmp;
    this.cont = document.getElementById(cont);
}

// Crea las plantillas de los objetos
//
// Par�metros:
//   'pt' -> Objeto de tipo PageTemplates donde se almacenan las plantillas.
function pTCreateTemplates(pt)
{
    pt.chart = pTCreateChartTemplate();    
}

// Crea la plantilla para las gr�ficas.
//
// Resultado:
//   Plantilla creada.
function pTCreateChartTemplate()
{
    return cCreateTemplate();
}

// Crea una nueva instancia de una gr�fica
//
// Par�metros:
//   'serverUrl'    -> URL del servidor de gr�fica.
//   'maxLineWidth' -> Ancho m�ximo de una linea.
//   'charts'       -> Definici�n de las gr�ficas.
function pBCreateChart(serverUrl, maxLineWidth, charts)
{
    cCreateChart(this.cont, this.tmp.chart, serverUrl, maxLineWidth, charts);
}

// Define los m�todos del constructor de p�gina. Los nombres de los m�todos
// tienen nombres cortos para disminuir el tama�o del HTML generado.
PageBuilder.prototype.c = pBCreateChart;