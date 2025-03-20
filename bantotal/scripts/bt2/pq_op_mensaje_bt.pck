create or replace package PQ_OP_MENSAJE_BT is
  -- *****************************************************************
  -- Nombre                     : PQ_OP_MENSAJE_VOUCHER
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 
  -- Autor de Creación          : DCASTRO
  -- Uso                        : 
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 Procedure sp_op_msj_boleta(  pn_pgcod in number, 
                              pn_mod   in number,
                              pn_suc   in number,
                              pn_mda   in number,
                              pn_pap   in number,
                              pn_cta   in number,
                              pn_oper  in number,
                              pn_sbop  in number,
                              pn_tope  in number,
                              pc_msje  out varchar2 );
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 Procedure sp_op_msj_emergente( pn_pgcod in number, 
                              pn_mod   in number,
                              pn_suc   in number,
                              pn_mda   in number,
                              pn_pap   in number,
                              pn_cta   in number,
                              pn_oper  in number,
                              pn_sbop  in number,
                              pn_tope  in number ,
                              pc_msje  out varchar2 ); 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 

end PQ_OP_MENSAJE_BT;
/

create or replace package body PQ_OP_MENSAJE_BT is
  -- *****************************************************************
  -- Nombre                     : PQ_OP_MENSAJE_VOUCHER
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 
  -- Autor de Creación          : DCASTRO
  -- Uso                        : PRocesos para carga de informacion de facturacion electronica
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : DCASTRO
  -- Descripción de Modificación: 
  -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 Procedure sp_op_msj_boleta(  pn_pgcod in number, 
                              pn_mod   in number,
                              pn_suc   in number,
                              pn_mda   in number,
                              pn_pap   in number,
                              pn_cta   in number,
                              pn_oper  in number,
                              pn_sbop  in number,
                              pn_tope  in number,
                              pc_msje  out varchar2 ) is
  -- *****************************************************************
    -- Nombre                     : sp_op_msj_boleta
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                              

                              
 begin
   
      begin
         select trim(a.aqpa607aux1) --msje voucher
           into pc_msje 
           from AQPA607 a 
          where a.aqpa607pgc = pn_pgcod
            and a.aqpa607mod =  pn_mod 
            and a.aqpa607suc =  pn_suc 
            and a.aqpa607mda =  pn_mda 
            and a.aqpa607pap =  pn_pap 
            and a.aqpa607cta =  pn_cta 
            and a.aqpa607ope =  pn_oper
            and a.aqpa607sbo =  pn_sbop
            and a.aqpa607top =  pn_tope
            and a.aqpa607est =  'S';
      exception when others then
            pc_msje := null;
      end;                               

 end sp_op_msj_boleta;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 Procedure sp_op_msj_emergente( pn_pgcod in number, 
                              pn_mod   in number,
                              pn_suc   in number,
                              pn_mda   in number,
                              pn_pap   in number,
                              pn_cta   in number,
                              pn_oper  in number,
                              pn_sbop  in number,
                              pn_tope  in number ,
                              pc_msje  out varchar2 ) is
                              
 begin
      begin
         select substr(trim(a.aqpa607aux2),1,50) --msje emergente
           into pc_msje 
           from AQPA607 a 
          where a.aqpa607pgc =  pn_pgcod
            and a.aqpa607mod =  pn_mod 
            and a.aqpa607suc =  pn_suc 
            and a.aqpa607mda =  pn_mda 
            and a.aqpa607pap =  pn_pap 
            and a.aqpa607cta =  pn_cta 
            and a.aqpa607ope =  pn_oper
            and a.aqpa607sbo =  pn_sbop
            and a.aqpa607top =  pn_tope
            and a.aqpa607est =  'S';
      exception when others then
            pc_msje := null;
      end;                                    

 end sp_op_msj_emergente;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
    
end PQ_OP_MENSAJE_BT;
/

