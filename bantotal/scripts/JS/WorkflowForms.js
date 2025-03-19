function ModifyHtml(){

	//HideEmptyCells ();	
	// ** (Elimina celdas del HTML - Expande Columnas - Mueve html de las grillas)

	var spans = document.getElementsByTagName("SPAN");
	var oSpan = null;		  
	var oTDWC  = document.getElementById('cellWC');		
	var oTDWC2 = document.getElementById('cellWC2');		
	var oTDWC3 = document.getElementById('cellWC3');		
	var oTDWC4 = document.getElementById('cellWC4');		
	var oTDWC5 = document.getElementById('cellWC5');		
	var oTDWC6 = document.getElementById('cellWC6');		
	var oTDWC7 = document.getElementById('cellWC7');		
	var oTDWC8 = document.getElementById('cellWC8');		
	var oTDWC9 = document.getElementById('cellWC9');		
	var oDestino = null;

	for (var i = 0; i < spans.length; i++)
	{
		if (spans[i].id.indexOf("EXPANDIR_CL") != -1)
		{
			oSpan = spans[i];
			var oTD = (oSpan.parentElement).parentElement;
			if (oTD != null)
			{	
				oTD.colSpan = 3;
			}
		}
		
		if (spans[i].id.indexOf("ELIMINAR_CL") != -1)
		{
			oSpan = spans[i];
			var oTD = null;
			oTD	= (oSpan.parentElement).parentElement;
			var oParentTD = ((oSpan.parentElement).parentElement).parentElement;
			if (oTD != null)
			{	
				var oNode = oTD.parentNode;
				oNode.removeChild(oTD);
			}
		}

		if (spans[i].id.indexOf("HIDEROWATTS") != -1)
		{
			oSpan = spans[i];
			var OTD = ((oSpan.parentElement).parentElement).parentElement;
			OTD.style.display = "none";	   
		}

		//copia html de las grillas 
		if (spans[i].id.indexOf("GRID_CL1") != -1){
			oDestino = spans[i];
			if (oDestino != null && oTDWC != null )
			{
				copyHtml(oTDWC,oDestino);
			}
		}	
		
		if (spans[i].id.indexOf("GRID_CL2") != -1){
			oDestino = spans[i];
			if (oDestino != null && oTDWC2 != null )
			{
				copyHtml(oTDWC2,oDestino);
			}
		}	
		if (spans[i].id.indexOf("GRID_CL3") != -1){
			oDestino = spans[i];
			if (oDestino != null && oTDWC3 != null )
			{
				copyHtml(oTDWC3,oDestino);
			}
		}	
		if (spans[i].id.indexOf("GRID_CL4") != -1){
			oDestino = spans[i];
			if (oDestino != null && oTDWC4 != null )
			{
				copyHtml(oTDWC4,oDestino);
			}
		}	
		if (spans[i].id.indexOf("GRID_CL5") != -1){
			oDestino = spans[i];
			if (oDestino != null && oTDWC5 != null )
			{
				copyHtml(oTDWC5,oDestino);
			}
		}	
		if (spans[i].id.indexOf("GRID_CL6") != -1){
			oDestino = spans[i];
			if (oDestino != null && oTDWC6 != null )
			{
				copyHtml(oTDWC6,oDestino);
			}
		}	
		if (spans[i].id.indexOf("GRID_CL7") != -1){
			oDestino = spans[i];
			if (oDestino != null && oTDWC7 != null )
			{
				copyHtml(oTDWC7,oDestino);
			}
		}	
		if (spans[i].id.indexOf("GRID_CL8") != -1){
			oDestino = spans[i];
			if (oDestino != null && oTDWC8 != null )
			{
				copyHtml(oTDWC8,oDestino);
			}
		}	
		if (spans[i].id.indexOf("GRID_CL9") != -1){
			oDestino = spans[i];
			if (oDestino != null && oTDWC9 != null )
			{
				copyHtml(oTDWC9,oDestino);
			}
		}	
	}
	
	// ** Oculta Filas Vacias
	var inputs = document.getElementsByTagName("INPUT");
	var input = null;
	
	// Busca la cantidad de filas que debera ocultar
	for (var i = 0; i < inputs.length; i++)
	{
		if (inputs[i].id.indexOf("CANTREPLACE") != -1)
		{
			input = inputs[i];
			break;
		}
	}

	//oculta de a una las filas que tengan la marca apropiada
	if (input != null)
	{
		for (i = 1; i <= input.value;i++)
		{	
			if (i<10) {
				var nro="0"+i;
			}
			else{
				nro= i;
			}
			
			var SpanName = 'OCULTAR' + nro;
			var obj = document.getElementById(SpanName);
			if (obj != null)
			{	
				var objTR = (((obj.parentElement).parentElement).parentElement).parentElement;
				if (objTR != null)
				{	
					objTR.style.display = "none";	   					
				}			
			}
			else{
				var SpanName = 'DELSPAN' + nro;
				var obj = document.getElementById(SpanName);			
				if (obj != null)
				{	
					var oSpanDel = obj.parentElement;
					oNode = oSpanDel.parentNode;
					if (oNode != null)
					{
						oNode.removeChild(oSpanDel);
					}
				}			
			}
		}
	}
}

function copyHtml(origen,destino){

	if (origen != null && destino != null){
		destino.innerHTML = origen.innerHTML; 
		var oNode = origen.parentNode;
		oNode.removeChild(origen);				
	}	
}


function Prueba(){
	/*
	alert('Prueba');
	*/
}		 

function preClickGrid(clientEvents){

	var inputs = document.getElementsByTagName("INPUT");
	var input = null;
	// Se conisuge el input deseado
	for (var i = 0; i < inputs.length; i++)
	{
		if (inputs[i].id.indexOf("EVENTGRID") != -1)
		{	
			input = inputs[i];
			break;
		}
	}
	//setea variable indicando que ocurrio un evento en el grid
	if (input != null)
	{
		input.value = 'S';
	}
	
	var ret = preClick(clientEvents);
	return ret;
}

function controles(){
	
	var inputs = document.getElementsByTagName("INPUT");
	var input = null;

	// controla el valor de los campos date
	for (var i = 0; i < inputs.length; i++)
	{
		if (inputs[i].id.indexOf("_ATRDATDATE") != -1)
		{
			input = inputs[i];
			
			if (input.value != "  /  /  ")
			{	//controlo el valor de la fecha
				input.setActive();
				input.blur();				
				break;
			}
		}
	}
}

function preClickForm(clientEvents){
	
	controles();	

	if (validationGU)
	{
		var ret = preClick(clientEvents);
		return ret;
	}
	return validationGU;
}

function SetComboDes(){

	var obj = window.event.srcElement ;
	var name = obj.name;

	if( name.indexOf("_ATRDATCMB") != null){ 
		var posI = name.indexOf("_ATRDATCMB");
		var posF = posI + 10;
		var auxvar = name.substring(posI,posF) + 'DES' + name.substring((posF),name.length) ;
		var objaux = document.getElementById(auxvar);

		if (objaux != null) 		//cuando ejecuta como 825 en modo GRD
		{
			objaux.value = obj.options[obj.selectedIndex].text;
		}
	}

	window.event.cancelBubble = true;
	window.event.returnValue = false;
	return true;
}

function initCombos()
{
	var c = document.getElementsByTagName("SELECT");
	
	for (var i = 0; i < c.length; i++)
		c[i].attachEvent("onblur", SetComboDes);
}


function SetPrefijo825v (pref){
	
	pref825v = pref;
}

function GridTDAlignRight(spanName){	

	if (spanName != null)
	{	
		var obj = document.getElementById(spanName);
		if (obj != null)
		{
			(obj.parentElement).align = "right";		
		}
	}
}


function CopyMsg(webCmsg){	
	
	if (webCmsg != null)
	{
		var obj = document.getElementById(webCmsg);


		var spans = document.getElementsByTagName("SPAN");
		var span = null;
		
		// Se conisuge el span deseado
		for (var i = 0; i < spans.length; i++)
		{
			if (spans[i].id.indexOf("TXTMESSAGES") != -1)
			{
				span = spans[i];
				break;
			}
		}		
		//asigno html al span
		span.innerHTML = obj.value;

	}	
}

function HideBotonera(string){
	
	var spanName = string + "_HIDEBOTONERA";
	var obj = document.getElementById(spanName);
	if (obj != null)
	{	
		if(obj.value == "S"){

			var par = obj.parentElement.parentElement;/*.parentElement.parentElement; */
			par.parentNode.removeChild(par);

		}
	}	

	var spanName3 = string + "_HIDEDOWNBOTONERA";
	var obj3 = document.getElementById(spanName3);
	if (obj3 != null)
	{
		if(obj3.value == "S"){

			var par3 = obj3.parentElement;
			par3.parentNode.removeChild(par3);
		}
	}
}


