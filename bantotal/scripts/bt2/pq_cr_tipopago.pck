create or replace package PQ_CR_TIPOPAGO is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_TIPOPAGO
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          :
  -- Autor de Creación          : EFUENTES
  -- Uso                        : Valida tipo de pago, negociación y pago anticipado
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  --
  -- *****************************************************************
  Procedure SP_CR_TIPOPAGO(pn_pgcod in number,
                           pn_suc   in number,
                           pn_mod   in number,
                           pn_tran  in number,
                           pn_rel   in number,
                           pd_fec   in date,
                           pc_flag  out varchar2);
                           
  -- *****************************************************************
  Procedure SP_CR_NEGOCIACION(pn_pgcod in number,
                              pn_mod   in number,
                              pn_suc   in number,
                              pn_tran  in number,
                              pn_rel   in number,
                              pd_fec   in date,
                              pc_flag  out varchar2);
                                   
  -- *****************************************************************
  Procedure SP_CR_PAGO_ANTICIPADO(pn_pgcod in number,
                                  pn_mod   in number,
                                  pn_suc   in number,
                                  pn_tran  in number,
                                  pn_rel   in number,
                                  pd_fec   in date,
                                  pc_flag  out varchar2);
                                   
  -- *****************************************************************
                                
end PQ_CR_TIPOPAGO;
/

create or replace package body PQ_CR_TIPOPAGO is
  -- *****************************************************************
  Procedure SP_CR_TIPOPAGO(pn_pgcod in number,
                           pn_suc   in number,
                           pn_mod   in number,
                           pn_tran  in number,
                           pn_rel   in number,
                           pd_fec   in date,
                           pc_flag  out varchar2)is
    lc_coderr varchar2(400);
  BEGIN
    --REDUCCION DE PLAZO: 'S'
    --REDUCCION DE CUOTA: 'A'
    begin
      PQ_CR_TIPOPAGO.SP_CR_NEGOCIACION(pn_pgcod,
                                       pn_mod,
                                       pn_suc,
                                       pn_tran,
                                       pn_rel,
                                       pd_fec,
                                       pc_flag);
    exception
      when others then 
        lc_coderr := sqlerrm;
        null;
    end;
    
    -- SI ES PAGO ANTICIPADO DE CUOTAS: 'X'
    if pc_flag is null then
      begin
        PQ_CR_TIPOPAGO.SP_CR_PAGO_ANTICIPADO(pn_pgcod,
                                             pn_mod,
                                             pn_suc,
                                             pn_tran,
                                             pn_rel,
                                             pd_fec,
                                             pc_flag);
      exception
        when others then 
          lc_coderr := sqlerrm;
          null;
      end;
    end if;
    
    -- NO TIENE NADA: 'N'
    pc_flag := NVL(pc_flag, 'N');
  end SP_CR_TIPOPAGO;

  -- *****************************************************************
  Procedure SP_CR_NEGOCIACION(pn_pgcod in number,
                                   pn_mod   in number,
                                   pn_suc   in number,
                                   pn_tran  in number,
                                   pn_rel   in number,
                                   pd_fec   in date,
                                   pc_flag  out varchar2) is
    lc_coderr varchar2(400);
  BEGIN
    --REDUCCION DE PLAZO: 'S'
    --REDUCCION DE CUOTA: 'A'
    BEGIN
      select d.evcd02
        into pc_flag
        from fsd012 d
       where d.d012cd = pn_pgcod
         and d.d012mo = pn_mod
         and d.d012su = pn_suc
         and d.d012tr = pn_tran
         and d.d012re = pn_rel
         and d.d012fc = pd_fec
         and d.evtipo = 31
            --and d.evcd01 = 2 --opcional
         and d.d012co = 'S';
    EXCEPTION
      when others then 
        lc_coderr := sqlerrm;
        null;
    END;
  end SP_CR_NEGOCIACION;

  -- *****************************************************************
  Procedure SP_CR_PAGO_ANTICIPADO(pn_pgcod in number,
                                  pn_mod   in number,
                                  pn_suc   in number,
                                  pn_tran  in number,
                                  pn_rel   in number,
                                  pd_fec   in date,
                                  pc_flag  out varchar2) is
    lc_coderr varchar2(400);
    ln_cont   number;
    ln_numcta number;
  BEGIN
    begin
      select t.tp1nro1
        into ln_numcta
        from fst198 t
       where t.tp1cod = 1 
         and t.tp1cod1 = 11146
         and t.tp1corr1 = 1
         and t.tp1corr2 = 16;
    exception
      when others then 
        lc_coderr := sqlerrm;
        ln_numcta := 2;
    end;
  
    BEGIN
      select count(*)
        into ln_cont
        from fsd602 a
       where a.d602cd = pn_pgcod
         and a.d602mo = pn_mod
         and a.d602su = pn_suc
         and a.d602tr = pn_tran
         and a.d602re = pn_rel
         and a.d602fc = pd_fec
         and d602co = 'S' --contabilizado
         and pp1stat = 'T' --pago completo
         and a.ppfpag > a.pp1fech;
        
      if ln_cont > ln_numcta then
        pc_flag := 'X';
      else
        pc_flag := null;
      end if;
    EXCEPTION
      when others then 
        lc_coderr := sqlerrm;
        null;
    END;
  end SP_CR_PAGO_ANTICIPADO;  

  -- *****************************************************************
  
end PQ_CR_TIPOPAGO;
/

