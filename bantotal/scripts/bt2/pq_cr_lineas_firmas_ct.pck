create or replace package PQ_CR_LINEAS_FIRMAS_CT is

procedure SP_CR_CONYUGE
  ( pn_Pepais IN NUMBER,
    pn_Petdoc IN NUMBER,
    pc_Pendoc IN CHAR,
    pc_PendocTit IN CHAR,
    pn_PepaisC out NUMBER,
    pn_PetdocC out NUMBER,
    pc_PendocC out CHAR,      
    pc_indicador OUT VARCHAR2);
    

procedure SP_CR_CONYUGE_OT
  ( pn_Pepais IN NUMBER,
    pn_Petdoc IN NUMBER,
    pc_Pendoc IN CHAR,
    pn_PepaisC out NUMBER,
    pn_PetdocC out NUMBER,
    pc_PendocC out CHAR);    

procedure SP_CR_FIRMAS (pn_cuenta in number, pn_ind out number);
  
end PQ_CR_LINEAS_FIRMAS_CT;
/

create or replace package body PQ_CR_LINEAS_FIRMAS_CT is

procedure SP_CR_FIRMAS (pn_cuenta in number, pn_ind out number) is 

/*****************************************************************
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.03.16
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 

    ******************************************************************/
  
 cursor persona (ln_pgcod in number, ln_cuenta in number) is
 select * from FSR008
  Where Pgcod = ln_pgcod
    and Ctnro = ln_cuenta; 


  ln_numero number := 0;

  ln_Ppgcod number := 1;
  pc_PendocTit char(12);
  pn_pepaisc number;
  pn_petdocc number;
  pc_pendocc char(12);
  pc_pendocct char(12);  
  pc_indicador varchar2(50);

 
BEGIN



   begin   
      select Pendoc --> FSR008
        into pc_PendocTit
        from FSR008
      Where Pgcod = ln_Ppgcod
        and Ctnro = pn_cuenta 
        and Cttfir = 'T'
        and Ttcod = 1;
   exception when others then
         pc_PendocTit := null;
   end;
 
   for i in persona(ln_Ppgcod , pn_cuenta) loop
     ln_numero := ln_numero + 1;
     if i.cttfir <> 'T' then --si es diferente de titular evalua si es conyuge
       pc_indicador := 'N';
       
       begin
         pq_cr_lineas_firmas_ct.sp_cr_conyuge(pn_pepais => i.pepais,
                                             pn_petdoc => i.petdoc,
                                             pc_pendoc => i.pendoc,
                                             pc_pendoctit => pc_PendocTit,
                                             pn_pepaisc => pn_pepaisc,
                                             pn_petdocc => pn_petdocc,
                                             pc_pendocc => pc_pendocc,
                                             pc_indicador => pc_indicador);
       end;
       
       if i.pendoc = pc_pendocct then
          ln_numero := ln_numero - 1;
       end if;
            
       if pc_indicador = 'N' then

          begin
            pq_cr_lineas_firmas_ct.sp_cr_conyuge_ot(pn_pepais => i.pepais,
                                                    pn_petdoc => i.petdoc,
                                                    pc_pendoc => i.pendoc,
                                                    pn_pepaisc => pn_pepaisc,
                                                    pn_petdocc => pn_petdocc,
                                                    pc_pendocc => pc_pendocct);
          end;         
       
       end if;
       
       if pc_indicador = 'S' then
          ln_numero := ln_numero - 1;          
       end if;
     
     end if;   --fin si es diferente de titular evalua si es conyuge
   
   end loop;
   pn_ind := ln_numero;

END SP_CR_FIRMAS;

 
procedure SP_CR_CONYUGE
  ( pn_Pepais IN NUMBER,
    pn_Petdoc IN NUMBER,
    pc_Pendoc IN CHAR,
    pc_PendocTit IN CHAR,
    pn_PepaisC out NUMBER,
    pn_PetdocC out NUMBER,
    pc_PendocC out CHAR,      
    pc_indicador OUT VARCHAR2) is
/*****************************************************************
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.03.16
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 

    ******************************************************************/    

 pn_Vicod number :=  66;
 
BEGIN

   begin   
     select Rppais, Rptdoc, Rpndoc --  //Busqueda Izquierda
       into pn_PepaisC,   pn_PetdocC,   pc_PendocC
       from fsr002 f
      Where Pepais  = pn_Pepais 
      and Petdoc    = pn_Petdoc
      and Pendoc    = pc_Pendoc
      and Rpccyg    = pn_Vicod
      and Rpndoc    = pc_PendocTit; -- ///relacion con titular principal
   exception when others then
         pn_PepaisC := null;
         pn_PetdocC := null;
         pc_PendocC := null;
         pc_indicador := 'N';
   end;
   if pc_PendocC is not null then
      pc_indicador := 'S';
   end if;
 

/*
&Vicod = 66
  //Busqueda Izquierda
  For Each Pepais, Petdoc, Pendoc//-->Fsr002
  Where Pepais    = &Pepais 
  Where Petdoc    = &Petdoc
  Where Pendoc    = &Pendoc
    Where Rpccyg    = &Vicod
    Where Rpndoc    = &PendocTit  ///relacion con titular principal
    
      &Rptdoc  = Rptdoc
      &Rpndoc  = Rpndoc
      &Rppais  = Rppais
            &Varcony = 'S'
            If &Varcony = 'S'
                &Mensaje = ' LA CUENTA CLIENTE POSEE CONYUGE. '

                &GP_Mensaje = Udp(PFRRepMsg, &Mensaje , "W") 
        Do 'GP: Reportar mensaje'
            EndIf
            
  When none
        &Rpndoc  = NullValue(&Rpndoc)
        &Varcony = 'N'
  EndFor
*/


END SP_CR_CONYUGE;


procedure SP_CR_CONYUGE_OT
  ( pn_Pepais IN NUMBER,
    pn_Petdoc IN NUMBER,
    pc_Pendoc IN CHAR,
    pn_PepaisC out NUMBER,
    pn_PetdocC out NUMBER,
    pc_PendocC out CHAR      ) is
/*****************************************************************
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.03.16
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 

    ******************************************************************/    

 pn_Vicod number :=  66;
 
BEGIN

   begin   
     select Rppais, Rptdoc, Rpndoc --  //Busqueda Izquierda
       into pn_PepaisC,   pn_PetdocC,   pc_PendocC
       from fsr002 f
      Where Pepais  = pn_Pepais 
      and Petdoc    = pn_Petdoc
      and Pendoc    = pc_Pendoc
      and Rpccyg    = pn_Vicod; 
   exception when others then
         pn_PepaisC := null;
         pn_PetdocC := null;
         pc_PendocC := null;
   end;
 
/*
Sub 'ConyugeOTROS'
    // conyugue
      
  &Vicod = 66
  //Busqueda Izquierda
  For Each Pepais, Petdoc, Pendoc//-->Fsr002
  Where Pepais    = &Pepais 
  Where Petdoc    = &Petdoc
  Where Pendoc    = &Pendoc
    Where Rpccyg    = &Vicod
      &Rptdoc  = Rptdoc
      &RpndocT  = Rpndoc
      &Rppais  = Rppais
  When none
        &Rpndoc  = NullValue(&Rpndoc)

  EndFor

    
EndSub // 'ConyugeOTROS'

*/



END SP_CR_CONYUGE_OT;


end PQ_CR_LINEAS_FIRMAS_CT;
/

