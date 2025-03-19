var etk;
var pke;
var width = 256;
var height = 394;
var halfSize = 0;
var consolidate = 0;
var umbral = 80;
var timeout = 30;
var token = "";
var imgFlag = 1;
var visible = 0;
var response = "Data adicional";
var ie8 = false;
var host = "LocalHost";

function autenticacionBiometrica(nuDocCliente) {
    try {

        var puerto = '2224';//document.getElementById('puerto').value;
        var params = "r=" + Math.random();
        var url = "https://" + host + ":" + puerto + "/biomatchwsi";//?"+params;
        ////alert("url:" + url);
        var xhr = createCORSRequest('POST', url);

        var coProceso = '50'; //document.getElementById('coProceso').value;
        var ipConsulta = '192.168.1.1';	//document.getElementById('ipConsulta').value;
        var nuDocUsuario = '72968642'; //document.getElementById('nuDocUsuario').value;
      //  var nuDocCliente = '46116453';//document.getElementById('nuDocCliente').value;
        var tiDocUsuario = "1";
        var tiDocCliente = "1";

        if (ie8) {
            //alert("ie8")
            var params = "r=" + Math.random() + "&op=autenticacionBiometrica" +
                    "&coProceso=" + coProceso + "&ipConsulta=" + ipConsulta + "&nuDocCliente=" + nuDocCliente +
                    "&nuDocUsuario=" + nuDocUsuario + "&tiDocCliente=" + tiDocCliente + "&tiDocUsuario=" + tiDocUsuario;
            xhr = createCORSRequest('GET', url + "?" + params);
            //alert(url + "?" + params);

        }
        if (!xhr) {
           // document.getElementById('msgLabel').style.color = "#F00";
            document.getElementById('msgLabel').innerHTML = 'Su browser no soporta Componentes Ajax, Por favor utilizar IE 8 or higher,FireFox 4.0 or higher';
			alert('Su browser no soporta Componentes Ajax, Por favor utilizar IE 8 or higher,FireFox 4.0 or higher');
            return;
        }

        var handle_load = function (event_type) {
            return function (XHRobj) {
                var XHRobj = is_iexplorer() ? xhr : XHRobj;
                if (event_type == 'load' && (is_iexplorer() || XHRobj.readyState == 4) && vcSuccess)					
					{ 
						var respuesta = XHRobj.responseText; 
						vcSuccess(respuesta, XHRobj);		
					}
                else if (vcError)
				{ 
					vcError(XHRobj);
				}
            }
        };

        xhr.onload = function (e) {
            handle_load('load')(is_iexplorer() ? e : e.target)
        };
        xhr.onerror = function (e) {
            handle_load('error')(is_iexplorer() ? e : e.target)
        };
        //document.getElementById('msgLabel').style.color = "#00F";
        document.getElementById('msgLabel').innerHTML = "Procesando...";

        if (ie8) {
            xhr.send();
        } else {
            //alert("NO IE8");
            xhr.setRequestHeader("Content-Type", "text/plain"); // nuevo agregado
			xhr.setRequestHeader("Access-Control-Allow-Origin", "http://localhost");
			xhr.setRequestHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS, DELETE");
			xhr.setRequestHeader("Access-Control-Max-Age", "3600");
			xhr.setRequestHeader("Access-Control-Allow-Headers", "Content-Type, Accept, X-Requested-With, remember-me");
            try {
                //xhr.setRequestHeader("Content-Type", "text/plain"); // nuevo agregado
                xhr.setRequestHeader("Access-Control-Allow-Origin","*")
                xhr.send(buildXmlVcRequest(coProceso, ipConsulta, nuDocUsuario, nuDocCliente, tiDocCliente, tiDocUsuario));
            } catch (err) {
                alert("err.description:"+err.description);  
            }
        }
		
		

    } catch (err) {
       // document.getElementById('msgLabel').style.color = "#F00";
        document.getElementById('msgLabel').innerHTML = "BioMatchClient Service not running! [err1=" + err.description + "]";
		alert("BioMatchClient Service not running! [err1=" + err.description + "]");
    }
}




function createCORSRequest(method, url) {
    var xhr = new XMLHttpRequest();
    if ("withCredentials" in xhr) {
        alert("createCORSRequest_1");
        // XHR for Chrome/Firefox/Opera/Safari.
        ie8 = false;
        xhr.open(method, url, true);	
        xhr.setRequestHeader("Content-Type", "text/xml");
        xhr.setRequestHeader("Access-Control-Allow-Origin", "http://localhost");
        xhr.setRequestHeader("Access-Control-Allow-Methods", "POST");
        xhr.setRequestHeader("Access-Control-Max-Age", "3600");
        xhr.setRequestHeader("Access-Control-Allow-Headers", "Content-Type, Accept, X-Requested-With, remember-me");
	
        //xhr.setRequestHeader("Content-Type", "text/plain");
    } else if (typeof XDomainRequest != "undefined") {
        alert("createCORSRequest_2");
        ie8 = true;
        xhr = new XDomainRequest();
        xhr.open(method, url);
    } else {
        alert("createCORSRequest_3");
        xhr = null;
    }
    return xhr;
}

function buildXmlVcRequest(coProceso, ipConsulta, nuDocUsuario, nuDocCliente, tiDocCliente, tiDocUsuario) {

    var xmlToSend = "<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:wsi='http://wsi.client.match.bio.zy.com/'>";
    xmlToSend += "  <soapenv:Header/>";
    xmlToSend += "  <soapenv:Body>";
    xmlToSend += "   <wsi:autenticacionBiometrica>";
    xmlToSend += "     <inputBean>";
    xmlToSend += "        <coProceso>" + coProceso + "</coProceso>";
    xmlToSend += "        <ipConsulta>" + ipConsulta + "</ipConsulta>";
    xmlToSend += "        <nuDocCliente>" + nuDocCliente + "</nuDocCliente>";
    xmlToSend += "        <nuDocUsuario>" + nuDocUsuario + "</nuDocUsuario>";
    xmlToSend += "        <tiDocCliente>" + tiDocCliente + "</tiDocCliente>";
    xmlToSend += "        <tiDocUsuario>" + tiDocUsuario + "</tiDocUsuario>";
    xmlToSend += "      </inputBean>";
    xmlToSend += "   </wsi:autenticacionBiometrica>";
    xmlToSend += "  </soapenv:Body>";
    xmlToSend += "</soapenv:Envelope>";

    //alert(xmlToSend);
    if (window.DOMParser) {
//        //alert("1");
        parser = new DOMParser();
//        //alert("1.1");
        xmldoc = parser.parseFromString(xmlToSend, "text/xml");
//        //alert("1.2:"+xmldoc);
    } else {
//        //alert("2");
        xmldoc = new ActiveXObject("Microsoft.XMLDOM");
        xmldoc.async = "false";
        xmldoc.loadXML(xmlToSend);
    }
    return xmldoc;
}

function is_iexplorer() {
    return navigator.userAgent.indexOf('MSIE') != -1;
}

function parseXMLDoc(xmlDocText) {
    var parserXml, xmlDocument;
    if (window.DOMParser) {
        parserXml = new DOMParser();
        xmlDocument = parserXml.parseFromString(xmlDocText, "text/xml");
    } else {// Internet Explorer    
        xmlDocument = new ActiveXObject("Microsoft.XMLDOM");
        xmlDocument.async = false;
        xmlDocument.loadXML(xmlDocText);
    }
    return xmlDocument;
}

function vcSuccess(responseText, XHRobj) {
    //alert("vcSuccess");
    var coMensaje;
    var deMensaje;
    var xmlDocument;
    var coResultado;
    var deResultado;
    var nomCliente;
    var apPatCliente;
    var apMatCliente;
    var feTxn;
    var indQA;
    var nuTxn;
    var tiDocCliente;
    var vigencia;
    var nuDocCliente;

    if (!ie8) {


        xmlDocument = parseXMLDoc(responseText);
        
        var x = xmlDocument.childNodes;
        alert("numero_child_nodes:"+x);
        
        
        
        coMensaje = xmlDocument.getElementsByTagName("coMensaje")[0].childNodes[0].nodeValue;
        deMensaje = xmlDocument.getElementsByTagName("deMensaje")[0].childNodes[0].nodeValue;
		
		document.getElementById('coMensaje').innerHTML = coMensaje;
		document.getElementById('deMensaje').innerHTML = deMensaje;
		
        alert("coMensaje i8:"+coMensaje);  
        alert("deMensaje i8:"+deMensaje);    

        document.getElementById('msgLabel').innerHTML = deMensaje;
		
		
        cleanLabels();
        if (coMensaje == "8000") {
			alert("Exito!! 8000");	
								
            document.getElementById('msgLabel').style.color = "#00F";
			
		
            
			
            nuDocCliente = xmlDocument.getElementsByTagName("nuDocCliente")[0].childNodes[0].nodeValue;
            document.getElementById('nuDocClienteResp').style.color = "#00F";
            document.getElementById('nuDocClienteResp').innerHTML = nuDocCliente;

            coResultado = xmlDocument.getElementsByTagName("coResultado")[0].childNodes[0].nodeValue;
            document.getElementById('coResultado').style.color = "#00F";
            document.getElementById('coResultado').innerHTML = coResultado;

            deResultado = xmlDocument.getElementsByTagName("deResultado")[0].childNodes[0].nodeValue;
            document.getElementById('deResultado').style.color = "#00F";
            document.getElementById('deResultado').innerHTML = deResultado;

            nomCliente = xmlDocument.getElementsByTagName("nomCliente")[0].childNodes[0].nodeValue;
            document.getElementById('nomCliente').style.color = "#00F";
            document.getElementById('nomCliente').innerHTML = nomCliente;

            apPatCliente = xmlDocument.getElementsByTagName("apPatCliente")[0].childNodes[0].nodeValue;
            document.getElementById('apPatCliente').style.color = "#00F";
            document.getElementById('apPatCliente').innerHTML = apPatCliente;

            apMatCliente = xmlDocument.getElementsByTagName("apMatCliente")[0].childNodes[0].nodeValue;
            document.getElementById('apMatCliente').style.color = "#00F";
            document.getElementById('apMatCliente').innerHTML = apMatCliente;

            feTxn = xmlDocument.getElementsByTagName("feTxn")[0].childNodes[0].nodeValue;
            document.getElementById('feTxn').style.color = "#00F";
            document.getElementById('feTxn').innerHTML = feTxn;

            indQA = xmlDocument.getElementsByTagName("indQA")[0].childNodes[0].nodeValue;
            document.getElementById('indQA').style.color = "#00F";
            document.getElementById('indQA').innerHTML = indQA;

            nuTxn = xmlDocument.getElementsByTagName("nuTxn")[0].childNodes[0].nodeValue;
            document.getElementById('nuTxn').style.color = "#00F";
            document.getElementById('nuTxn').innerHTML = nuTxn;

            tiDocCliente = xmlDocument.getElementsByTagName("tiDocCliente")[0].childNodes[0].nodeValue;
            document.getElementById('tiDocCliente').style.color = "#00F";
            document.getElementById('tiDocCliente').innerHTML = tiDocCliente;

            vigencia = xmlDocument.getElementsByTagName("vigencia")[0].childNodes[0].nodeValue;
            document.getElementById('vigencia').style.color = "#00F";
            document.getElementById('vigencia').innerHTML = vigencia;

        } else {
            //document.getElementById('msgLabel').style.color = "#F00";
        }
    } else {
        //alert(responseText);
        var arr = responseText.split("#");
        ////alert("datos array:" + arr.length);
        coMensaje = arr[0];
        deMensaje = arr[1];
        
		alert(coMensaje);
        alert(deMensaje);
       
	   	document.getElementById('coMensaje').innerHTML = coMensaje;
		document.getElementById('deMensaje').innerHTML = deMensaje;
		
	    document.getElementById('msgLabel').innerHTML = deMensaje;
        cleanLabels();

        if (coMensaje == "8000") {
			alert("Exito 8000!!!");

            document.getElementById('msgLabel').style.color = "#00F";

            coResultado = arr[2];
            document.getElementById('coResultado').style.color = "#00F";
            document.getElementById('coResultado').innerHTML = coResultado;

            deResultado = arr[3];
            document.getElementById('deResultado').style.color = "#00F";
            document.getElementById('deResultado').innerHTML = deResultado;

            tiDocCliente = arr[4];
            document.getElementById('tiDocCliente').style.color = "#00F";
            document.getElementById('tiDocCliente').innerHTML = tiDocCliente;

            nuDocCliente = arr[5];
            //alert("nuDocCliente:" + nuDocCliente);
            document.getElementById('nuDocClienteResp').style.color = "#00F";
            document.getElementById('nuDocClienteResp').innerHTML = nuDocCliente;

            apPatCliente = arr[6];
            document.getElementById('apPatCliente').style.color = "#00F";
            document.getElementById('apPatCliente').innerHTML = apPatCliente;

            apMatCliente = arr[7];
            document.getElementById('apMatCliente').style.color = "#00F";
            document.getElementById('apMatCliente').innerHTML = apMatCliente;

            nomCliente = arr[8];
            document.getElementById('nomCliente').style.color = "#00F";
            document.getElementById('nomCliente').innerHTML = nomCliente;

            vigencia = arr[10];
            document.getElementById('vigencia').style.color = "#00F";
            document.getElementById('vigencia').innerHTML = vigencia;


            nuTxn = arr[12];
            document.getElementById('nuTxn').style.color = "#00F";
            document.getElementById('nuTxn').innerHTML = nuTxn;

            feTxn = arr[13];
            document.getElementById('feTxn').style.color = "#00F";
            document.getElementById('feTxn').innerHTML = feTxn;

            indQA = arr[14];
            document.getElementById('indQA').style.color = "#00F";
            document.getElementById('indQA').innerHTML = indQA;


        } else {
           // document.getElementById('msgLabel').style.color = "#F00";
        }
    }

}


function cleanLabels() {

    document.getElementById('coResultado').innerHTML = "";
    document.getElementById('deResultado').innerHTML = "";
    document.getElementById('tiDocCliente').innerHTML = "";
    document.getElementById('nuDocClienteResp').innerHTML = "";
    document.getElementById('apPatCliente').innerHTML = "";
    document.getElementById('apMatCliente').innerHTML = "";

    document.getElementById('nomCliente').innerHTML = "";
    document.getElementById('vigencia').innerHTML = "";
    document.getElementById('nuTxn').innerHTML = "";
    document.getElementById('feTxn').innerHTML = "";
    document.getElementById('indQA').innerHTML = "";
}


function vcError(XHRobj) {
   // document.getElementById('msgLabel').style.color = "#F00";
    document.getElementById('msgLabel').innerHTML = 'Ups, se produjo un inconveniente accesando al BioMatchClient (Huellero), por favor verifique!';
	
	alert('Ups, se produjo un inconveniente accesando al BioMatchClient (Huellero), por favor verifique!');
}

function hex2a(hexx) {
    var hex = hexx.toString();//force conversion
    var str = '';
    for (var i = 0; (i < hex.length && hex.substr(i, 2) !== '00'); i += 2)
        str += String.fromCharCode(parseInt(hex.substr(i, 2), 16));
    return str;
}

function hexToBase64(str) {
    return btoa(String.fromCharCode.apply(null,
            str.replace(/\r|\n/g, "").replace(/([\da-fA-F]{2}) ?/g, "0x$1 ").replace(/ +$/, "").split(" "))
            );
}