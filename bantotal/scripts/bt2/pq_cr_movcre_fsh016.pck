create or replace package PQ_CR_MOVCRE_FSH016 is
 
    -- *****************************************************************
    -- Nombre                     : SALDOS COMPARATIVOS DE CREDITOS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.01.03
    -- Autor de Creación          : DCASTRO 
    -- Uso                        : OBTENER SALDOS COMPARATIVOS DE CREDITOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2015.02.27
    -- Autor de la Modificación   :  DCASTRO
    -- Descripción de Modificación: Se agrego campo jaql982tcr, se agrego funcion fn_cr_tipo_credito_Desem
    --                              2016.04.13 DCASTRO se agrego condicion para eliminar JAQL583 fecha anterior a fecha proceso.
    -- *****************************************************************
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_MOV_FSH016  (  pn_emp  in number,
                               pn_mod  in number,
                               pn_suc  in number,
                               pn_mda  in number,
                               pn_pap  in number,
                               pn_cta  in number,
                               pn_ope  in number,
                               pn_sbo  in number,
                               pn_top  in number,
                               pd_fpp  in date,  
                               pd_fec  in date,
                               pd_fei  in date, -- fecha inicio de calculo
                               pc_ind  in char, --indicador ultimo pago                               
                               pv_cap  out number,
                               pv_int  out number,
                               pv_icv  out number,
                               pv_mor  out number,
                               pv_seg  out number,
                               pv_rub  out number,
                               pv_gas  out number
                            );

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_asientos  (    p_pgcod  in number,
                               p_itmod  in number,
                               p_ittran  in number,
                               p_itsuc  in number,
                               p_itnrel  in number,
                               pn_cta  in number,
                               pn_ope  in number,
                               pd_fpp  in date,  
                               pd_fec  in date,
                               pv_cap  out number,
                               pv_int  out number,
                               pv_icv  out number,
                               pv_mor  out number,
                               pv_seg  out number,
                               pv_rub  out number,
                               pv_gas  out number
                            );

end PQ_CR_MOVCRE_FSH016;
/

create or replace package body PQ_CR_MOVCRE_FSH016 is
    -- *****************************************************************
    -- Nombre                     : PQ_CR_MOVCRE_FSH016
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.12.31
    -- Autor de Creación          : DCASTRO
    -- Uso                        : CARGA DATOS PARA REPORTE VARIACION DE SALDOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2015.02.23
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    --                            :   2015.03.13 se agrego tabla jaql983 para control jobs
    --                            :   2015.11.24 se modifico sp_cr_actualiza
    -- *****************************************************************
      
 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

procedure sp_cr_MOV_FSH016  (  pn_emp  in number,
                               pn_mod  in number,
                               pn_suc  in number,
                               pn_mda  in number,
                               pn_pap  in number,
                               pn_cta  in number,
                               pn_ope  in number,
                               pn_sbo  in number,
                               pn_top  in number,
                               pd_fpp  in date,  
                               pd_fec  in date,
                               pd_fei  in date, -- fecha inicio de calculo
                               pc_ind  in char, --indicador ultimo pago
                               pv_cap  out number,
                               pv_int  out number,
                               pv_icv  out number,
                               pv_mor  out number,
                               pv_seg  out number,
                               pv_rub  out number,
                               pv_gas  out number
                            ) is

cursor asientos is
select distinct x.tp1nro1 MODUL, x.tp1nro2 TRAN--, y.TP1NRO3 IMP , y.TP1IMP1 ORDINAL, y.TP1DESC--, x.*, y.*
                    from fst198 x, fst198 y
                   where x.TP1COD = 1
                     and x.TP1COD1 = 11144
                     and x.TP1CORR1 = 1
                     and x.tp1corr2 = 3
                     and x.tp1corr3 > 0
                     and y.TP1COD = 1
                     and y.TP1COD1 = 10876
                     and y.tp1corr1 = x.tp1nro1
                     and y.tp1corr2 = x.tp1nro2
/*                     and x.TP1NRO1 = 30
                     and x.TP1NRO2 = 100*/
                     ;

cursor creditos(pd_fecini date, pd_fecpro date, pn_cod number, 
                pn_mdx number, pn_tran number, pn_ctnro number, pn_oper number) is
select distinct 
f.pgcod, f.hcmod, f.hsucor, f.htran, f.hnrel, f.hfcon, f.hmodul, f.htoper,-- hsucur, hrubro, 
f.hmda, f.hpap, f.hcta, f.hoper
from fsh016 f,fsh015 g
where g.pgcod = f.pgcod
  and g.hcmod = f.hcmod
  and g.hsucor = f.hsucor
  and g.htran = f.htran
  and g.hnrel = f.hnrel
  and g.hfcon = f.hfcon
  and g.hccorr <>99
  and f.pgcod = pn_cod
  and f.hcmod = pn_mdx
  and f.htran = pn_tran
  and f.hfcon >= pd_fecini
  and f.hfcon <= pd_fecpro 
  and f.hcta  =  pn_ctnro
  and f.hoper =  pn_oper
  and f.hmodul in (200,33)  ;

ld_fecpag date;
lv_cap number :=0;
lv_int number :=0;
lv_icv number :=0;
lv_mor number :=0;
lv_seg number :=0;
lv_rub number :=0;
lv_gas number :=0;

begin

  if pc_ind is null then --sino es ultimo pago entonces validar
         
      if pd_fei is null then --- es acumulativo       
          --obtiene max fecha de fsd602
          begin
            select max(f.d602fc)
              into ld_Fecpag
              from fsd602 f
             where f.pgcod = 1
              and f.ppcta = pn_cta
              and f.ppoper = pn_ope
              and f.d602co = 'S';
              
          end;                   
      else
         ld_Fecpag := pd_fei;
      end if;
      
  elsif pc_ind = 'U' then--para obtener fecha ultimo pago
        begin
          select max(f.hfcon)
            into ld_Fecpag
            from fsh016 f, fsh015 g
            where g.pgcod = f.pgcod
              and g.hcmod = f.hcmod
              and g.hsucor = f.hsucor
              and g.htran = f.htran
              and g.hnrel = f.hnrel
              and g.hfcon = f.hfcon
              and g.hccorr <>99
              and f.hcmod not in (98,99)
              and f.hcta  =  pn_cta
              and f.hoper =  pn_ope
              and f.hmodul in (200,33)
              and (g.hcmod, g.htran) in (  select distinct x.tp1nro1 MODUL, x.tp1nro2 TRAN--, y.TP1NRO3 IMP , y.TP1IMP1 ORDINAL, y.TP1DESC--, x.*, y.*
                    from fst198 x, fst198 y
                   where x.TP1COD = 1
                     and x.TP1COD1 = 11144
                     and x.TP1CORR1 = 1
                     and x.tp1corr2 = 3
                     and x.tp1corr3 > 0
                     and y.TP1COD = 1
                     and y.TP1COD1 = 10876
                     and y.tp1corr1 = x.tp1nro1
                     and y.tp1corr2 = x.tp1nro2)
                       ;  
        exception when others then
            ld_Fecpag := null;
        end;
  end if;
      
  pv_cap := 0;
  pv_int := 0;
  pv_icv := 0;
  pv_mor := 0;
  pv_seg := 0;
  pv_gas := 0;

  for i in asientos loop
      for y in creditos(ld_Fecpag, pd_fpp, pn_emp, i.modul, i.tran, pn_cta, pn_ope  )  loop
  
          begin
            pq_cr_movcre_fsh016.sp_cr_asientos(p_pgcod => y.pgcod,
                                              p_itmod =>  y.hcmod,
                                              p_ittran => y.htran,
                                              p_itsuc =>  y.hsucor, 
                                              p_itnrel => y.hnrel,
                                              pn_cta =>   y.hcta,
                                              pn_ope =>   y.hoper,
                                              pd_fpp =>   pd_fpp,
                                              pd_fec =>   y.hfcon,--pd_fec,  08/08/2021
                                              pv_cap =>   lv_cap,
                                              pv_int =>   lv_int,
                                              pv_icv =>   lv_icv,
                                              pv_mor =>   lv_mor,
                                              pv_seg =>   lv_seg,
                                              pv_rub =>   lv_rub,
                                              pv_gas =>   lv_gas
                                              );
          end;
          
          
          pv_cap := pv_cap + nvl(lv_cap,0);
          pv_int := pv_int + nvl(lv_int,0);
          pv_icv := pv_icv + nvl(lv_icv,0);
          pv_mor := pv_mor + nvl(lv_mor,0);
          pv_seg := pv_seg + nvl(lv_seg,0);
          pv_gas := pv_gas + nvl(lv_gas,0);
          
          
    end loop;    

  end loop;
  
end sp_cr_MOV_FSH016;


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

procedure sp_cr_asientos  (    p_pgcod  in number,
                               p_itmod  in number,
                               p_ittran  in number,
                               p_itsuc  in number,
                               p_itnrel  in number,
                               pn_cta  in number,
                               pn_ope  in number,
                               pd_fpp  in date,  
                               pd_fec  in date,
                               pv_cap  out number,
                               pv_int  out number,
                               pv_icv  out number,
                               pv_mor  out number,
                               pv_seg  out number,
                               pv_rub  out number,
                               pv_gas  out number
                            ) is


ld_fecpag date;
lv_fpag   date;
lv_mod    number;
lv_trx    number; 
lv_suc    number;
lv_rel    number;
lv_cap    number;
lv_int    number;
lv_icv    number;
lv_mor    number;
lv_seg    number;
lv_rub    number;
lv_gas    number;
ld_fsis   date;


begin
  select w.pgfape into ld_fsis from fst017 w where w.pgcod = 1;
  
    if ld_fsis <> pd_Fec then  --historico

      begin
            select f_pag,
               hcmod,
               htran,
               hsucor,
               hnrel,
               sum(decode(tp1nro1, 1, (monto / cont), 0)) capital,
               sum(decode(tp1nro1, 2, (monto / cont), 0)) interes,
               sum(decode(tp1nro3, 1,  decode(tp1nro1, 3, (monto / cont), 0),
                          4, decode(tp1nro1, 3, (monto4 / cont), 0),
                          12, decode(tp1nro1, 3, (monto12 / cont), 0))) int_comp_extra, -- 062017 -- sum(decode(tp1nro1,3,(monto/cont),0 )) int_comp_extra,--ICV        
               sum(decode(tp1nro3, 1, decode(tp1nro1, 4, (monto / cont), 0),
                          4, decode(tp1nro1, 4, (monto4 / cont), 0),
                          12, decode(tp1nro1, 4, (monto12 / cont), 0))) mora, --062017 -- sum(decode(tp1nro1,4,(monto/cont),0 )) mora,
               sum(decode(tp1nro1, 5, (monto / cont), 0)) seguros,
               sum(decode(tp1nro1, 6, (monto / cont), 0)) rub_obli,
               sum(decode(tp1nro1, 7, (monto / cont), 0)) gastos
               into lv_fpag, lv_mod, lv_trx, lv_suc, lv_rel, lv_cap, lv_int, lv_icv,
                    lv_mor, lv_seg, lv_rub, lv_gas
          from (select g.tp1nro1,
                       h.HCMOD,
                       g.tp1nro3,
                       h.HTRAN,
                       h.HSUCOR,
                       h.HNREL,
                       f.hfcon as f_pag, -- 062017 (select g.tp1nro1,h.itmod,h.ittran,h.itsuc,h.itnrel,itfcon as f_pag,
                       sum(h.HCIMP1) monto,
                       sum(h.HCIMP4) monto4, /*sum(h.itimp12)*/
                       0 monto12,
                       count(*) cont --062017 se adiciono suma de impuestos --sum(h.itimp1) monto,count(*) cont
                  from fsh016 h
                 inner join fst198 g
                    on h.HCMOD = g.tp1corr1
                   and h.HTRAN = g.tp1corr2
                   and h.HCORD = g.tp1imp1 --  062017--and h.itord=g.tp1corr3
                   and g.tp1cod = 1
                   and g.tp1cod1 = 10876
                   and g.tp1corr1 <> 999999
                 inner join fsh015 f
                    on f.pgcod = h.pgcod
                   and f.HSUCOR = h.HSUCOR
                   and f.HCMOD = h.HCMOD
                   and f.HTRAN = h.HTRAN
                   and f.HNREL = h.HNREL
                   and f.hfcon = h.hfcon
                 where f.pgcod  = p_pgcod
                   and f.hcmod  = p_itmod
                   and f.htran  = p_ittran
                   and f.hsucor = p_itsuc
                   and f.hnrel  = p_itnrel
                   and f.hfcon  = pd_fec
                      --and f.itcont='S'
                   and f.hccorr = 0
                 group by g.tp1nro1,
                          h.HCMOD,
                          h.HTRAN,
                          h.HSUCOR,
                          h.HNREL,
                          f.hfcon,
                          f.hfvc,
                          g.tp1nro3) --062017 --group by g.tp1nro1,h.itmod,h.ittran,h.itsuc,h.itnrel,f.itfcon,f.itfvc)
         group by f_pag, hcmod, htran, hsucor, hnrel;
      exception when others then
           lv_fpag := null; 
           lv_mod  := null;
           lv_trx  := null; 
           lv_suc  := null;
           lv_rel  := null; 
           lv_cap  := 0;
           lv_int  := 0;
           lv_icv  := 0;
           lv_mor  := 0;
           lv_seg  := 0;
           lv_rub  := 0;
           lv_gas  := 0;
      end;         
    else  --diario
      begin
        select f_pag,itmod,ittran,itsuc,itnrel,
        sum(decode(tp1nro1,1,(monto/cont) ,0 ))  capital,
        sum(decode(tp1nro1,2,(monto/cont),0 )) interes,
        sum(decode(tp1nro3,1,decode(tp1nro1,3,(monto/cont),0 ),4,decode(tp1nro1,3,(monto4/cont),0 ),12,decode(tp1nro1,3,(monto12/cont),0 ))) int_comp_extra, -- 062017 -- sum(decode(tp1nro1,3,(monto/cont),0 )) int_comp_extra,--ICV        
        sum(decode(tp1nro3,1,decode(tp1nro1,4,(monto/cont),0),4,decode(tp1nro1,4,(monto4/cont),0),12,decode(tp1nro1,4,(monto12/cont),0 ))) mora,   --062017 -- sum(decode(tp1nro1,4,(monto/cont),0 )) mora,
        sum(decode(tp1nro1,5,(monto/cont),0 )) seguros,
        sum(decode(tp1nro1,6,(monto/cont),0 )) rub_obli,
        sum(decode(tp1nro1,7,(monto/cont),0 )) gastos
        into lv_fpag, lv_mod, lv_trx, lv_suc, lv_rel, lv_cap, lv_int, lv_icv,
            lv_mor, lv_seg, lv_rub, lv_gas
        from
        (select g.tp1nro1,h.itmod,g.tp1nro3,h.ittran,h.itsuc,h.itnrel,itfcon as f_pag,-- 062017 (select g.tp1nro1,h.itmod,h.ittran,h.itsuc,h.itnrel,itfcon as f_pag,
        sum(h.itimp1) monto, sum(h.itimp4) monto4, sum(h.itimp12) monto12,count(*) cont --062017 se adiciono suma de impuestos --sum(h.itimp1) monto,count(*) cont
        from
        fsd016 h
        inner join fst198 g
        on  h.itmod=g.tp1corr1
        and h.ittran=g.tp1corr2
         and h.itord=g.tp1imp1 --  062017--and h.itord=g.tp1corr3
        and g.tp1cod=1
        and g.tp1cod1=10876
        and g.tp1corr1<>999999
        inner join fsd015 f
        on  f.pgcod=h.pgcod
        and f.itsuc=h.itsuc
        and f.itmod=h.itmod
        and f.ittran=h.ittran
        and f.itnrel=h.itnrel
        where f.pgcod= p_pgcod
        and f.itmod=   p_itmod
        and f.ittran=  p_ittran
        and f.itsuc=   p_itsuc
        and f.itnrel=  p_itnrel
        and f.itcont='S'
        and f.itcorr=0
        group by g.tp1nro1,h.itmod,h.ittran,h.itsuc,h.itnrel,f.itfcon,f.itfvc,g.tp1nro3  )--062017 --group by g.tp1nro1,h.itmod,h.ittran,h.itsuc,h.itnrel,f.itfcon,f.itfvc)
        group by f_pag,itmod,ittran,itsuc,itnrel;
      exception when others then
           lv_fpag := null; 
           lv_mod  := null;
           lv_trx  := null; 
           lv_suc  := null;
           lv_rel  := null; 
           lv_cap  := 0;
           lv_int  := 0;
           lv_icv  := 0;
           lv_mor  := 0;
           lv_seg  := 0;
           lv_rub  := 0;
           lv_gas  := 0;
      end;
      
    end if;
    
    pv_cap := lv_cap;
    pv_int := lv_int;
    pv_icv := lv_icv;
    pv_mor := lv_mor;
    pv_seg := lv_seg;
    pv_rub := lv_rub;
    pv_gas := lv_gas;

end sp_cr_asientos;


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

end PQ_CR_MOVCRE_FSH016;
/

