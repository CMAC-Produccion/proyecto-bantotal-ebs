// ******************************************
// Álvaro Morales
// 17/03/2005
// v1.0
// ******************************************

//-------------------------- FUNCIONES AUXILIARES GENERALES -------------------------------------

// ****************************** Funciones para ordenar una tabla ******************************
var intPreviousCol = -1;

function columnSort( strTable, intCol, strOrderType, strBackgroundColor ) {
	var objTable = document.getElementById( strTable );
	var intRows = objTable.rows.length - 1;
	var intCols = objTable.rows( 0 ).cells.length;
	var arraySort = new Array( intRows );
	var arrayRowContent = new Array( intRows );
	var objCell;
	var i, j;

	for ( i = 0; i < intRows; i++ ) {
		arraySort[i] = new Array(2);
		arraySort[i][0] = objTable.rows( i + 1 ).cells( intCol ).innerText;
		arraySort[i][1] = i;
		arrayRowContent[i] = new Array( intCols );
		for ( j = 0; j < intCols; j++ ) {
			arrayRowContent[i][j] =  objTable.rows( i + 1 ).cells( j ).innerHTML;
		}
	}

	if ( intCol != intPreviousCol ) {
		switch ( strOrderType.toUpperCase().replace(/^\s*|\s*$/g,"") ) {
			case "KEYSENSITIVE":
				arraySort.sort( compareKeySensitiveChar );
				break;
			case "NOKEYSENSITIVE":
				arraySort.sort( compareNoKeySensitiveChar );
				break;
			case "DATE":
				arraySort.sort( compareJavaScriptFormatDate );
				break;
			case "NUMBER":
				arraySort.sort( compareNumeric );
				break;
			default:
				arraySort.sort()
		}
		intPreviousCol = intCol;
	}
	else {
		arraySort.reverse();
	}

	for (i = 0; i < intRows; i++ ) {
		for ( j = 0; j < intCols; j++ ) {
			objCell = objTable.rows( i + 1 ).cells( j );
			objCell.innerHTML = arrayRowContent[arraySort[i][1]][j];
			if ( j == intCol ) {
				objCell.style.backgroundColor = strBackgroundColor;
			} else {
				objCell.style.backgroundColor = "";
			}
		}
	}

	swapArrow( strTable, intCol );
	return false;
}

function swapArrow( strTable, intCol ) {
	var ARROWUP, ARROWDOWN, objHeaders, objHeader, objArrow, i;

	// Constantes	
	ARROWUP = "<IMG id='arrowUp' src='images/arrowUp.gif' style='margin-left: 5px; margin-right: 5px; margin-bottom: 2px'/>";
	ARROWDOWN = "<IMG id='arrowDown' src='images/arrowDown.gif' style='margin-left: 5px; margin-right: 5px'/>";

	objHeaders = document.getElementById( strTable ).rows( 0 ).cells;
	for ( i = 0; i < objHeaders.length; i++ ) {
		objHeader = objHeaders( i );
		objArrow = objHeader.all.arrowDown;
		if ( objArrow != undefined ) {
			if ( i == intCol ) {
				objArrow.outerHTML = ARROWUP;
			} else {
				objArrow.outerHTML = "";
			}
		} else {
			objArrow = objHeader.all.arrowUp;
			if ( objArrow != undefined ) {
				if ( i == intCol ) {
					objArrow.outerHTML = ARROWDOWN;
				} else {
					objArrow.outerHTML = "";
				}
			} else {
				if ( i == intCol ) {
					objHeader.innerHTML = objHeader.innerHTML + ARROWUP;
				}
			}
		}
	}
	return false;
}	

function compareKeySensitiveChar( a, b ) {
	var intResult = 0;
	if ( a[0] < b[0] ) { 
		intResult = -1; 
	} else {
		if ( a[0] > b[0] ) { 
			intResult 	= 1; 
		}
	}
	return intResult;
}

function compareNoKeySensitiveChar( a, b ) {
	var char1, char2, intResult = 0;

	char1 = a[0].toUpperCase();
	char2 = b[0].toUpperCase();
	if ( char1 < char2 ) { 
		intResult = -1;
	} else {
		if ( char1 > char2 ) { 
			intResult = 1;
		}
	}
	return intResult;
}

function compareJavaScriptFormatDate( a, b ) {
	// dd/mm/yyyy hh:mm:ss
	var d1, h1, d2, h2, i, date1, date2, intResult = 0;

	d1 = a[0].substring( 0, 10 ).split( "/" );
	h1 = a[0].substring( 11 ).split( ":" );
	d2 = b[0].substring( 0, 10 ).split( "/" );
	h2 = b[0].substring( 11 ).split( ":" );
	for ( i = 0; i < 3; i++ ) {
		if ( isNaN( d1[i] ) || d1[i] == "" ) {
			d1[i] = 0;
		}
		if ( isNaN( h1[i] ) || h1[i] == "" ) {
			h1[i] = 0;
		}
		if ( isNaN( d2[i] ) || d2[i] == "" ) {
			d2[i] = 0;
		}
		if ( isNaN( h2[i] ) || h2[i] == "" ) {
			h2[i] = 0;
		}
	} 
	date1 = new Date( d1[2], d1[1], d1[0], h1[2], h1[1], h1[0] );
	date2 = new Date( d2[2], d2[1], d2[0], h2[2], h2[1], h2[0] );
	if ( date1 < date2 ) { 
		intResult = -1;
	} else {
		if ( date1 > date2 ) { 
			intResult = 1;
  	 	}
	}
	return intResult;
}

function compareNumeric( a, b ) {
	var num1, num2, intResult = 0;
	num1 = parseInt( a[0].replace( /\./g, "" ).replace( /,/g, "" ) )
	num2 = parseInt( b[0].replace( /\./g, "" ).replace( /,/g, "" ) );
	if ( !isNaN( num1 ) && !isNaN( num2 ) ) {
		if ( num1 < num2 ) {
			intResult = -1;
		} else {
			if ( num1 > num2 ) {
				intResult = 1;
			}
		}
	}
	return intResult;
}
// **************************** Fin Funciones para ordenar una tabla ****************************

// *************************************** Funcion popup ****************************************
var GXPARAMETERS = new Array();

function popup( x )
{
    var width = 0, heigth = 0, left = 0, top = 0, props = "";
    argv = popup.arguments;
    argc = argv.length;
    if ( argc > 0 )
    {
        sURL = argv[ 0 ];
        sParms = '?';
        if ( argc > 1 )
        {
            p = document.all.item( argv[ 1 ] );
            GXPARAMETERS[ 0 ] = p;
            sParms = sParms + escape( p.value ); 
            for ( var i = 2; i < argc; i++ )
            {
                p = document.all.item( argv[i] );
                if ( p.value == null )
                {
                    // Carga el valor si proviene de un radio button
                    for ( var j = 0; j < 10; j++ )
                    {
                        p = document.all.item( argv[i] + "_" + j );	
                        if ( p != null )
                        {
                             if ( p.checked == true )
                                 break;
                        }
                    }
                }
                GXPARAMETERS[i - 1] = p;
                sParms = sParms + ',' + escape( p.value );
            }
        }
        width = 552;
        height = 498;
        left = ( screen.availWidth - width ) / 2;
        top = ( screen.availHeight - heigth ) / 2;
        props = 'titlebar=no, menubar=no, status=no, toolbar=no, left=' + left + ', top=' + top + ', height=' + heigth + ', width=' + width; 
        try {
            window.open( sURL + sParms, '', props );
        } catch ( e ) {
            var ok = false;
            ok = confirm( "Ha ocurrido un error inesperado.\n¿Desea ver la información sobre el tipo de error?");
            if ( ok ) {
                alert("Error número " + ( e.number & 0xFFFF ) + ":\n" + e.description );
            }
        }
    }
}
// ************************************* Fin Funcion popup **************************************

// ********************** Funciones para desplegar un indicador de progreso *********************
var _timer;
var _waitMessage = null;
var _waitHeight = 105;
var _waitWidth = 502;

// Tiempo de espera en milisegundos antes de mostrar el mensaje de procesando
var _waitTime = 1500;

function initializeMessage()
{
	_waitMessage = document.createElement('<DIV style="BACKGROUND-COLOR: #ffffff; z-index: 300; visibility: hidden; position: absolute;">');
	_waitMessage.innerHTML = 
	'<table bgcolor="#888888" cellpadding="0" cellspacing="3"><tr><td>\
		<table bgcolor="#FFFFFF" cellSpacing="0px" cellPadding="0px">\
			<tr height="65">\
				<td width="21"></td>\
				<td>\
					<font color="#969696" face="Verdana" size="5">Procesando, espere por favor...</font>\
				</td>\
				<td width="16">\
				</td>\
				<td valign="middle">\
					<table cellSpacing="0px" cellPadding="0px">\
						<tr><td height="18px"></td></tr>\
						<tr valign="middle">\
							<td>\
								<img src="images/wait.gif"></img>\
							</td>\
						</tr>\
						<tr><td height="14px"></td></tr>\
					</table>\
				</td>\
				<td width="18"></td>\
			</tr>\
		</table>\
	</td></tr></table>';
	
	document.body.appendChild(_waitMessage);
}

function preClick()
{
	_timer = setTimeout("waitMessage()", _waitTime);			
	return true;
}

function preClickMenu(obj)
{
	if (obj.firstChild != null) {
		if (obj.firstChild.nodeType != 3) {
			// No es nodo texto
			_timer = setTimeout("waitMessage()", _waitTime);			
		}	
	}
	return true;
}

function waitMessage()
{
	// Si es la primera vez se crea el mensaje
	if (_waitMessage == null) {
		initializeMessage();
	}

	t = document.body.scrollTop + (document.documentElement.scrollHeight - _waitHeight) / 2;
	l = document.body.scrollLeft + (document.documentElement.scrollWidth - _waitWidth) / 2;

	_waitMessage.style.left = l;
	_waitMessage.style.top = t;

	_waitMessage.style.visibility = 'visible';
}

function removeWaitMessage()
{
       if (_waitMessage != null) {
               _waitMessage.style.visibility = 'hidden';
       }
       clearTimeout(_timer);
}
// ********************* Fin Funciones para desplegar un indicador de espera ********************
