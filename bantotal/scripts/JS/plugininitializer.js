function initializeTopAndAppBars()
{
	var tbc = document.getElementById("topbarcontainer");
	var apc = document.getElementById("apptabcontainer");

	var codeBase = top.getFlashCodeBase();
	if (codeBase == "")
		codeBase = "https://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0";

	tbc.innerHTML = '<object onfocus="document.body.focus()" style="z-index: 100" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"\
				codebase="' + codeBase + '"\
				HEIGHT="54" width="100%" id="topbar" align="left" VIEWASTEXT>\
				<param name="scale" value="noscale" />\
				<param name="allowScriptAccess" value="sameDomain" />\
				<param name="salign" value="lt" />\
				<param name=movie value="flash/topbar.swf">\
				<param name=quality value=high>\
				<param name=bgcolor value=#FFFFFF>\
				<param name="wmode" value="opaque">\
				<embed src="flash/topbar.swf" swLiveConnect=true allowScriptAccess="sameDomain" scale="noscale"\
					quality="high" salign="lt" bgcolor="#FFFFFF" height="54" name="topbar" align="" wmode="opaque"\
					type="application/x-shockwave-flash" pluginspage="https://www.macromedia.com/go/getflashplayer"></embed>\
			</object>';

	apc.innerHTML = '<object onfocus="document.body.focus()" style="z-index: 500" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"\
				codebase="' + codeBase + '"\
				width="100%" height="26" id="apptab" align="" VIEWASTEXT>\
				<param name="allowScriptAccess" value="sameDomain" />\
				<param name="movie" VALUE="flash/apptab.swf">\
				<param name="quality" VALUE="high">\
				<param name="bgcolor" VALUE="#FFFFFF">\
				<param name="wmode" VALUE="opaque">\
				<embed src="flash/apptab.swf" quality="high" bgcolor="#FFFFFF" width="100%" height="26"\
					name="apptab" align="" wmode="opaque" type="application/x-shockwave-flash"\
					pluginspage="https://www.macromedia.com/go/getflashplayer"></embed>\
			</object>';

}

function initializeStepBar()
{
	var tc = document.getElementById("tabcontainer");

	var codeBase = top.getFlashCodeBase();
	if (codeBase == "")
		codeBase = "https://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0";

	tc.innerHTML = '<OBJECT onfocus="document.body.focus();" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"\
				codebase="' + codeBase + '"\
				WIDTH="100%" HEIGHT="27" id="tab" ALIGN="" style="BACKGROUND-COLOR: #A3A4A6" VIEWASTEXT>\
				<PARAM NAME=movie VALUE="flash/tab.swf">\
				<PARAM NAME=quality VALUE=high>\
				<PARAM NAME=bgcolor VALUE=#A3A4A6>\
				<PARAM NAME="wmode" VALUE="opaque">\
				<EMBED src="flash/tab.swf" quality=high bgcolor=#A3A4A6  WIDTH="100%" HEIGHT="27" NAME="tab" ALIGN="" WMODE="opaque"\
					TYPE="application/x-shockwave-flash" PLUGINSPAGE="https://www.macromedia.com/go/getflashplayer"></EMBED>\
			</OBJECT>';
}