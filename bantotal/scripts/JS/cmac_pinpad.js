
var pinpad;
var owner;
var Timeout  =60;
var tipo 	 =2;
var Puerto   =1;
var toRead   =600;
var toTimeout=600;
var bauld    =19200;
var t_chip	 =120;
var t_band	 =120;var resenc = 9;pinpad = new ActiveXObject("HComPinpad.Pinpad");
pinpad.Port =1;
function setHiddenVariable(name, value)
{
    var element = document.getElementById(name);    
    element.value = value;
}
function setPinpadError(Response)
{
	var LastError;
	LastError = "Error"+Response; 
	setHiddenVariable("_PINPADERROR", LastError);
}
function gettrack2()
{
	var cTrackEncri;
	var Mensaje  	= "(CHIP)PASE BANDA";
	var cNumeroTarjeta;
	/*Hlaqui 22/01/2019 - Obtener ARQC - Variables AQRC*/
	var cTramaARQC;
	var cTypeTrx = "00";
	var cAmount = "0";
	var cOtheramount = "0";
	var ctxCurrencyCode = "0604";
	var cTrxDate = "190118";
	var TCountry = "0604";
	

	cTrackEncri = pinpad.EMVReadCardMagChipEx(Puerto, bauld, t_chip, t_band, tipo, Mensaje);
	if(cTrackEncri=="99-4"||cTrackEncri=="99-5")
	{
		document.forms[0]._PROMPTCARD.value="Tarjeta con chip";
		setHiddenVariable("_TRACK2", "Tarjeta con chip");
		//gettrack2();
	}
	else if(cTrackEncri=="99-3")
	{
		document.forms[0]._PROMPTCARD.value="Error en chip dañado";
		setHiddenVariable("_TRACK2", "Error en chip dañado");
	}
	else if(cTrackEncri=="99-10")
	{
		document.forms[0]._PROMPTCARD.value="Tarjeta no valida";
		setHiddenVariable("_TRACK2", "Tarjeta no valida");
	}
	else
	{
		document.forms[0]._PROMPTCARD.value=cTrackEncri;
		//document.forms[0]._TRACK2.value=cTrackEncri;
		setHiddenVariable("_TRACK2", cTrackEncri);		
	}
        //setPinpadError(cTrackEncri);
    pinpad.Disconnect();
	if (preClick(null))
	{
		self.GX_setevent('EBTNOPHIDDEN.CLICK.');
 		self.document.forms[0].submit();
	}
}
function gettrackandpin()
{
	var cTrackEncri;
	var Mensaje  	= "(CHIP)PASE BANDA";
	var cNumeroTarjeta;
	var cNumeroPin;
	var Flag = "9";
	var pinblock="";
	cTrackEncri = pinpad.EMVReadCardMagChipEx(Puerto, bauld, t_chip, t_band, tipo, Mensaje);
	if(cTrackEncri=="99-4"||cTrackEncri=="99-5")
	{
		document.forms[0]._PROMPTCARD.value="Tarjeta con chip";
		//setHiddenVariable("_TRACK2", "Tarjeta con chip, ingrese nuevamente");
		//gettrack2();
	}
	else if(cTrackEncri=="99-3")
	{
		document.forms[0]._PROMPTCARD.value="Error en chip dañado";
		//setHiddenVariable("_TRACK2", "Error en chip dañado");
	}
	else
	{
		document.forms[0]._PROMPTCARD.value=cTrackEncri;
		//document.forms[0]._TRACK2.value=cTrackEncri;
		setHiddenVariable("_TRACK2", cTrackEncri);
		pinpad.Disconnect();
		if(cTrackEncri.length==0)
		{
			pinpad.Connect(Puerto, bauld);
			cNumeroPin = pinpad.ReadPinIni(0,document.forms[0]._TPK.value,document.forms[0]._TARJETA.value);
			if (cNumeroPin != 1)
			{
				setHiddenVariable("_Mensaje", "Error lectura del PIN");
				return;
			}
			while (pinblock.length == 0)
			{
				pinblock = pinpad.ReadPin(Flag);
			}
			pinpad.Disconnect();
			setHiddenVariable("_PIN", pinblock);
		}
	}
	if (preClick(null))
	{
		self.GX_setevent('EBTNOPHIDDEN.CLICK.');
 		self.document.forms[0].submit();
	}
}
function getARQC() {
    var cTramaARQC = "";
    var cTypeTrx = "00";
    var cAmount = "0";
    var cOtheramount = "0";
    var ctxCurrencyCode = "0604";
    //var cTrxDate = "190118";
    var cTrxDate = document.forms[0]._FECVAL.value;
    var TCountry = "0604";
    cTramaARQC = pinpad.EMVGenerateARQCEx(Puerto, bauld, cTypeTrx, cAmount, cOtheramount, ctxCurrencyCode, cTrxDate, TCountry);
    setHiddenVariable("_ARQC", cTramaARQC);   

    if (preClick(null)) {
        self.GX_setevent('EBTNOPHIDDEN.CLICK.');
        self.document.forms[0].submit();
    }
}

function CheckARPC() {
    var Szpacket;
    var szHostDecision;
    var flag_eval;
    var szARC;
    var Response;

    Szpacket = document.forms[0]._ARPC.value;
    szARC = document.forms[0]._ARC.value;
    szHostDecision  = "0"
    flag_eval       = "1"

    if (Szpacket.length == 0) {
        setHiddenVariable("_Mensaje", "No se tiene valor del ARPC");
        return;
    }
    Response = pinpad.EMVValidateARPCEx(Puerto, bauld, Szpacket, szHostDecision, flag_eval, szARC)    
    if (Response != 1) {        
        setHiddenVariable("_CRIOK", "0");        
    }
    else 
        setHiddenVariable("_CRIOK", Response);
    

    if (preClick(null)) {
        self.GX_setevent('EBTNOPHIDDEN.CLICK.');
        self.document.forms[0].submit();
    }
}

function GetCard()
{
	var cNumeroTarjeta;
	//--------------------------------------------------------------------------------------//
	//----------------------------------Modificado 05-06-2015-------------------------------//
	//--------------------------------------------------------------------------------------//
	var Mensaje  	= "(CHIP)PASE BANDA";
	var	Response;
	cNumeroTarjeta = pinpad.EMVReadCardMagChipEx(Puerto, bauld, t_chip, t_band, tipo, Mensaje);
	document.forms[0]._PROMPTCARD.value=cNumeroTarjeta;
	setHiddenVariable("_TARJETA", cNumeroTarjeta);
	if (preClick(null))
	{
		self.GX_setevent('EBTNOPHIDDEN.CLICK.');
 		self.document.forms[0].submit();
	}
}
function getpin() 
{
	var cNumeroTarjeta;
	var cNumeroPin;
	var Flag = "9";
	var pinblock="";
	pinpad.Connect(Puerto, bauld);
	cNumeroPin = pinpad.ReadPinIni(0,document.forms[0]._TPK.value,document.forms[0]._TARJETA.value);
	if (cNumeroPin != 1)
	{
		setHiddenVariable("_Mensaje", "Error al ejecutar funcion de inicializacion de lectura del PIN");
		return;
	}
	while (pinblock.length == 0)
	{
		pinblock = pinpad.ReadPin(Flag);
	}
		
	pinpad.Disconnect();
	setHiddenVariable("_PIN", pinblock);
        //setPinpadError(pinblock); 

	if (preClick(null))
	{
		self.GX_setevent('EBTNOPHIDDEN.CLICK.');
		self.document.forms[0].submit();
	}
}
function getpin2() 
{
	var cNumeroTarjeta;
	var cNumeroPin1;
	var cNumeroPin2;
	var Flag = "9";
	var pinblock1="";
	var pinblock2="";
	var LastError;
	pinpad.Connect(Puerto, bauld);
	cNumeroPin1 = pinpad.ReadPinIni(0,document.forms[0]._TPK.value,document.forms[0]._TARJETA.value);
	if (cNumeroPin1 != 1)
	{
		setHiddenVariable("_Mensaje", "Error al ejecutar funcion de inicializacion de lectura del PIN");
		return;
	}
	while (pinblock1.length == 0)
	{
		pinblock1 = pinpad.ReadPin(Flag);
	}
	//pinpad.Disconnect();
	setHiddenVariable("_PIN1", pinblock1);
	if(pinblock1.length != 0)
	{
		//pinpad.Connect(Puerto, bauld);
		cNumeroPin2 = pinpad.ReadPinIni(0,document.forms[0]._TPK.value,document.forms[0]._TARJETA.value);
		if (cNumeroPin2 != 1)
		{
			setHiddenVariable("_Mensaje", "Error al ejecutar funcion de inicializacion de lectura del PIN");
			return;
		}

		while (pinblock2.length == 0)
		{
			pinblock2 = pinpad.ReadPin(Flag);
		}

		setHiddenVariable("_PIN2", pinblock2);
	}
	pinpad.Disconnect();
	if (preClick(null))
	{
		self.GX_setevent('EBTNOPHIDDEN.CLICK.');
		self.document.forms[0].submit();
	}
}function encuesta()
	{
		pinpad.Connect(Puerto, bauld);
   		var tecla1 = 9;
		pinpad.ShowMessage("[1]Muy Malo [2]Malo [3]Regular    [4]Bueno [5]Muy Bueno       Eliga del 1 al 5");
		tecla1 = pinpad.ReadKey(25);
		setHiddenVariable("_CALCLI", tecla1);
		pinpad.ShowMessage("CMAC - AREQUIPA");
		pinpad.Disconnect();
		if (preClick(null))
	{
		self.GX_setevent('EBTNOPHIDDEN.CLICK.');
		self.document.forms[0].submit();
	}
	}	

function gracias() 
{	
	pinpad.DisplayString("Gracias");
	setTimeout(ok,1200);			
}

function error() 
{	
	pinpad.DisplayString("Error");
	setTimeout(ok,2000);			
}

function ok() 
{
	pinpad.Disconnect();
}

	
