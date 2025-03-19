
function Cambia_Cuo(elemento){                                                                                                                                                              
     var ElemName = elemento.name;                                      
     var pos_1 = ElemName.indexOf('_OP_') ;                                 
     var pos_2 = ElemName.lastIndexOf('_') ;                                 
     var strprincipio = ElemName.substring(0,pos_1) ;                    
     var strfinal = ElemName.substring(pos_2 + 1,pos_2 + 5) ;                    
     var nomNroCuo = strprincipio + '_ACuo_' + strfinal ;                                                
		 var Cuo = document.forms[ 0 ].elements(nomNroCuo).value;                                   
		 // Recorro todos los elementos en búsqueda del _XCUO y le asigno la Cuota seleccionada
     for (var i = 0, j = document.forms[ 0 ].elements.length; i < j; i++)                 
     {                                                                                    
         myName = document.forms[ 0 ].elements[ i ].name;                                 
         if (myName.indexOf('_XCUO') > -1)                                                  
         {                                                                               
             document.forms[ 0 ].elements[ i ].value = Cuo;                               
         }                                                                                
     }	  
     // Recorro todos los radiobuttons y los desmarco      		 		                                 		                                 
     for (var i = 0, j = document.forms[ 0 ].elements.length; i < j; i++)                 
     {                                                                                    
         myName = document.forms[ 0 ].elements[ i ].name;                                 
         if (myName.indexOf('_Op_') > -1)                                                  
         {                                                                               
             document.forms[ 0 ].elements[ i ].value = 'N';                               
         }                                                                                
     }
     // Marco el radiobutton seleccionado                                                                                         
     elemento.value='S';                                                                                                                                                             
}

function Cambia_Neg(elemento){                                                                                                                                                              
     var ElemName = elemento.name;                                      
     var pos_1 = ElemName.indexOf('_OP_') ;                                 
     var pos_2 = ElemName.lastIndexOf('_') ;                                 
     var strprincipio = ElemName.substring(0,pos_1) ;                    
     var strfinal = ElemName.substring(pos_2 + 1,pos_2 + 5) ;                    
     var nomNroNeg = strprincipio + '_ASubOp_' + strfinal ;                                                  
		 var Neg = document.forms[ 0 ].elements(nomNroNeg).value;                                              		 		                                 
		 // Recorro todos los elementos en búsqueda del _XSUBOP y le asigno la Neg seleccionada
     for (var i = 0, j = document.forms[ 0 ].elements.length; i < j; i++)                 
     {                                                                                    
         myName = document.forms[ 0 ].elements[ i ].name;                                 
         if (myName.indexOf('_XSUBOP') > -1)                                                  
         {                                                                               
             document.forms[ 0 ].elements[ i ].value = Neg;                               
         }                                                                                
     } 		    	
     // Recorro todos los radiobuttons y los desmarco
     for (var i = 0, j = document.forms[ 0 ].elements.length; i < j; i++)                 
     {                                                                                    
         myName = document.forms[ 0 ].elements[ i ].name;                                 
         if (myName.indexOf('_Op_') > -1)                                                  
         {                                                                               
             document.forms[ 0 ].elements[ i ].value = 'N';                               
         }                                                                                
     }                                                                                         
		 // Marco el radiobutton seleccionado     
     elemento.value='S';                                                                                                                                                             
}

function Cambia_Neg_Cuo(elemento){                              
                                                                                                                              
     var ElemName = elemento.name;                                      
     var pos_1 = ElemName.indexOf('_OP_') ;                                 
     var pos_2 = ElemName.lastIndexOf('_') ;                                                                                                                                     
     var strprincipio = ElemName.substring(0,pos_1) ;                    
     var strfinal = ElemName.substring(pos_2 + 1,pos_2 + 5) ; 
     var nomNroNeg = strprincipio + '_ASubOp_' + strfinal ;  
     var nomNroCuo = strprincipio + '_ACuo_' + strfinal ;                                                          
		 var Neg = document.forms[ 0 ].elements(nomNroNeg).value;   
		 var Cuo = document.forms[ 0 ].elements(nomNroCuo).value;	                                             		 		                                 
		 // Recorro todos los elementos en búsqueda del _XSUBOP y _XCUO y le asigno 
		 // la Neg y Cuota seleccionadas
     for (var i = 0, j = document.forms[ 0 ].elements.length; i < j; i++)                 
     {                                                                                    
         myName = document.forms[ 0 ].elements[ i ].name;
         //SubOp                                 
         if (myName.indexOf('_XSUBOP') > -1)                                                  
         {                                                                               
             document.forms[ 0 ].elements[ i ].value = Neg;                               
         };     
         //Cuota
         if (myName.indexOf('_XCUO') > -1)                                                  
         {                                                                               
             document.forms[ 0 ].elements[ i ].value = Cuo;                               
         }                                                                                    
     } 		    	
     // Recorro todos los radiobuttons y los desmarco
     for (var i = 0, j = document.forms[ 0 ].elements.length; i < j; i++)                 
     {                                                                                    
         myName = document.forms[ 0 ].elements[ i ].name;                                 
         if (myName.indexOf('_Op_') > -1)                                                  
         {                                                                               
             document.forms[ 0 ].elements[ i ].value = 'N';                               
         }                                                                                
     }                                                                                         
		 // Marco el radiobutton seleccionado     
     elemento.value='S';                                                                                                                                                             
}

function Cambia_Hija(elemento){                                                                                                                                                              
     var ElemName = elemento.name;                                      
     var pos_1 = ElemName.indexOf('_OP_') ;                                 
     var pos_2 = ElemName.lastIndexOf('_') ;                                 
     var strprincipio = ElemName.substring(0,pos_1) ;                    
     var strfinal = ElemName.substring(pos_2 + 1,pos_2 + 5) ;                    
     var nomNroHija = strprincipio + '_HijaOper_' + strfinal ;                                                  
		 var Hija = document.forms[ 0 ].elements(nomNroHija).value;                                              		 		                                 
     // Recorro todos los elementos en búsqueda del _OPHIJA y le asigno la Hija seleccionada
     for (var i = 0, j = document.forms[ 0 ].elements.length; i < j; i++)                 
     {                                                                                    
         myName = document.forms[ 0 ].elements[ i ].name;                                 
         if (myName.indexOf('_OPHIJA') > -1)                                                  
         {                                                                               
             document.forms[ 0 ].elements[ i ].value = Hija;                               
         }                                                                                
     } 		    	
     // Recorro todos los radiobuttons y los desmarco
     for (var i = 0, j = document.forms[ 0 ].elements.length; i < j; i++)                 
     {                                                                                    
         myName = document.forms[ 0 ].elements[ i ].name;                                 
         if (myName.indexOf('_Op_') > -1)                                                  
         {                                                                               
             document.forms[ 0 ].elements[ i ].value = 'N';                               
         }                                                                                
     }                                                                                         
     // Marco el radiobutton seleccionado     
     elemento.value='S';                                                                                                                                                             
}