function fDStartDownload(downloadLink)
{
    // Inicia un temporizador que verifica si se cargó completamente la página 
    // antes de empezar la carga. Cuando se ocultó el dialogo de espera y 
    // se terminó de mostrar la página recien allí se empieza a descargar el archivo
    document.fDDownloadLink = downloadLink;
    document.fDCheckDownloadTimer = setInterval('fDCheckDownload()', 200);
}

function fDCheckDownload()
{    
    if (document.readyState == 'complete')
    {
        clearTimeout(document.fDCheckDownloadTimer);
 
        var f = document.all.openFileFrame;
        if (f != null)
        {
            // Carga el link del archivo en el frame para comenzar la descarga
            f.src = document.fDDownloadLink
        }        
    }
}

function onFDLoad()
{
    f = document.all.openFileFrame;
                
    if (f != null)
    {
        if ((f.src != '') && (f.innerHTML != ''))
        {
            // Se cargó un archivo dentro del frame, lo muestra
            fDShowFileFrame();
        }
    }
}
    
function onFDReadStateChange()
{
    f = document.all.openFileFrame;
                
    if (f != null)
    {
        if ((f.src != '') && (f.readyState == 'complete'))
        {
            // Se cargó un archivo dentro del frame, lo muestra
            fDShowFileFrame();
        }
    }
}

function fDShowFileFrame()
{
    f = document.all.openFileFrame;
                
    if (f != null)
    {
        if (f.style.visibility == 'hidden')
        {        
            // Deshabilita el desplazamiento porque al abrir archivos (como de tipo Excel) lo calcula 
            // incorrectamente y queda mal la barra de desplazamiento vertical
            document.body.scroll = 'no';
            f.style.width  = document.body.clientWidth;
            f.style.height = document.body.clientHeight;
            f.style.visibility = 'visible';
            f.style.display    = 'inline';
        }
    }
}
