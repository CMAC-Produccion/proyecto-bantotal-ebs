var noRowSelectedMsgPGS = 'No hay ninguna fila seleccionada.'
var messageAreaPGS      = 'TXTMESSAGES';

function checkSelection(gridId)
{
	if (eval('document.MAINFORM.' + gridId.toUpperCase() + '_ROW').value != '0')
	{
		document.getElementById(messageAreaPGS).innerHTML = '';
		return true;
	}
	else
	{
		document.getElementById(messageAreaPGS).innerHTML = '&nbsp;<TABLE cellSpacing=2 cellPadding=0 width=778 border=0><TBODY><TR bgColor=#9f2020><TD colspan=2><P class=TblTitle>Mensajes</P></TD></TR><TR HEIGHT=20><TD bgcolor=#DDDDDD width=20 valign=center align=center><IMG SRC="images/error.gif"></TD><TD bgcolor=#F3F3F3 class=MsgText>&nbsp;' + noRowSelectedMsgPGS + '</TD></TR><TR><TD bgColor=#9f2020 colSpan=2 height=2></TD></TR></TBODY></TABLE></span>';
		return false;
	}
}

function getSelectedValue(gridId, dataId)
{
	dataId = (dataId.substring(0, dataId.lastIndexOf('_') + 1)).toUpperCase();
	gridId = gridId.toUpperCase();
	rowN   = to4Digits(eval('document.MAINFORM.' + gridId + '_ROW').value);

	return eval('document.forms[0].' + dataId + rowN);
}

function forceMarkRow(gridId, rowNumber)
{
	markrow("#adbeda", gridId, gridId + "_ROW", rowNumber);
}
