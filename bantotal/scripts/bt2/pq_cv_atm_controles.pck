create or replace package PQ_CV_ATM_CONTROLES is
  -- ------------------------------------------------------------------------------------------------
  -- Nombre                : PQ_CV_ATM_CONTROLES
  -- Sistema               : BANTOTAL
  -- M�dulo                : ATMS
  -- Versi�n               : 1.1
  -- Fecha de Creaci�n     : 01/01/2019
  -- Autor de Creaci�n     : JPINTO
  -- Uso                   : Control para lectura de tarjetas con banda para la red de cajeros del BANBIF
  -- Estado                : Activo
  -- Acceso                : P�blico
  -- Fecha de Modificaci�n : 05/02/2019
  -- Autor de Creaci�n     : JPINTO
  -- Descripci�n Modific.  : Optimizaci�n para lectura de tarjetas con banda para la red de cajeros del BANBIF cuando haya cambio de dia l�gico
  -- Fecha de Modificaci�n : 
  -- Autor de Creaci�n     : 
  -- Descripci�n Modific.  : 
  -- ------------------------------------------------------------------------------------------------------------------------------------------------------

  procedure sp_controlLecturaBandaUnicard(pn_codtra number,
                                          pc_coderr out varchar2,
                                          pc_msgerr out varchar2);

end PQ_CV_ATM_CONTROLES;
/

create or replace package body PQ_CV_ATM_CONTROLES is
  --//
  procedure sp_controlLecturaBandaUnicard(pn_codtra number,
                                          pc_coderr out varchar2,
                                          pc_msgerr out varchar2) is
    lc_tracet varchar2(12) := ''; -- campo 37 / 540
    ld_fectra date; -- campo 11 / 540
    ln_ocurre number := -1;
  begin
    --//
    pc_coderr := '00000';
    pc_msgerr := '';
    --//                                           
    select b1.jaql540nutra, b1.jaql540feini
      into lc_tracet, ld_fectra
      from jaql540 b1
     where b1.jaql540cotra = pn_codtra;
  
    select count(*)
      into ln_ocurre
      from itxn@TXNSWT c1
     where lpad(to_char(trace), 12, '0') = lc_tracet
       and capdate >= ld_fectra
       and POS_COND_CODE = 2 -- red UNICARD
       and (POS_ENTRY_MODE = 901 or POS_ENTRY_MODE = 801) -- tipo de lectura 
       and ACQINST = 890605;
  
    if ln_ocurre >= 1 then
      pc_coderr := '53501';
      pc_msgerr := '53501(1) - Intento de Lectura de BANDA siendo esta de CHIP';     
    end if;
  
  exception
    when others then
      pc_coderr := sqlcode;
      pc_msgerr := sqlerrm;
  end sp_controlLecturaBandaUnicard;
  --//  
end PQ_CV_ATM_CONTROLES;
/

