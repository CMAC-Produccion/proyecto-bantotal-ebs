create or replace package pq_cr_lineas_vinc is
/* ************************************************************************************************************
    -- Nombre                     : AQPA012
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Consulta Central Unificada 
    -- Descripción                                                     : Rpta Consulta Central Unificada
    -- Versión                    : 1.0
    -- Fecha de Creación          : 18/08/2017
    -- Autor de Creación          : hsuarez
    -- Versión                    : 1.0
    -- Fecha de Modificación      : 22/03/2021
    -- Autor de la Modificación   : dcastro
    -- Descripción de Modificación: 2021.03.29 dcastro se modifico sp_linea_vinc_CRM
    --                              2024.09.25 dcastro se modifico sp_linea_vinc_CRM cambio tabla crm por tabla AQPB297
    --
* *************************************************************************************************************/

  
  
  -- Public type declarations
  Procedure desvincular_linea(instancia in number,flag_desv out varchar,msj out varchar);
  
  

  procedure  sp_linea_vinc_CRM (pn_instancia  in number,
                              pc_ind out varchar2);
      
 procedure sp_deuda_linea (pn_instancia  in number,
                          pc_ind out varchar2);
                          
                              
end pq_cr_lineas_vinc;
/

create or replace package body pq_cr_lineas_vinc is


Procedure desvincular_linea(instancia in number,flag_desv out varchar,msj out varchar)is
    flag_vinc char(1);
    cod_tarea number(4);
    est_tarea char(1);
    flag_tarea char(1);
    ln_emp number(3);
    ln_suc number(3);
    ln_mod number(3);
    ln_mda number(4);
    ln_pap number(4);
    ln_cta number(9);
    ln_ope number(9);
    ln_sbop number(3);
    ln_tipo number(3);
    
    lv_pgcod number(3);
    lv_suc   number(3);
    lv_mod   number(3);
    lv_tran  number(3);
    lv_nrel  number(3);
    lv_corr  number(4);
begin
             
                --paso 01 -- Verificamos que la instancia este vinculada.
                flag_desv := 'N';
                begin
                  select 'S'
                  into
                         flag_vinc
                    from jaqy800 
                   where jaqy800ins=instancia 
                     and jaqy800vinc='S'
                     and jaqy800tpc='P';
                exception
                when others then 
                    flag_vinc :='N';
                end;
                if flag_vinc='S' then  
                        --paso 02 -- Obtenemos la ultima tarea de la instancia consultada y el estado en la que se encuentra
                        begin
                          select k.wftaskcod,
                                 k.wfstscod
                            into
                                 cod_tarea,
                                 est_tarea
                            from wfwrkitems k
                           where k.wfinsprcid=instancia
                             and k.wfitemend=(
                                            select max(wfitemend) 
                                              from wfwrkitems 
                                             where wfinsprcid=instancia
                                          );
                        exception
                        when others then 
                             cod_tarea:=0;
                             est_tarea:='';
                        end;
                        
                        if est_tarea='L' or est_tarea='B' or est_tarea='C' or est_tarea='E' then
                            flag_tarea:='S';        
                        else
                            if cod_tarea=55 then
                               flag_tarea:='N';
                            else
                               msj:='No se puede desvicular, mantiene la solicitud en estado vigente y no rechazada';
                            end if;
                        end if;
                        if flag_tarea='N' then
                            --En caso que el taskcod sea 55 y no esta cancelado, consultar seguir paso 05
                            begin               
                                select 
                                       x.xwfempresa,
                                       x.xwfsucursal,
                                       x.xwfmodulo,
                                       x.xwfmoneda,
                                       x.xwfpapel,
                                       x.xwfcuenta,
                                       x.xwfoperacion,
                                       x.xwfsubope,
                                       x.xwftipope                       
                                  into
                                       ln_emp,
                                       ln_suc,
                                       ln_mod,
                                       ln_mda,
                                       ln_pap,
                                       ln_cta,
                                       ln_ope,
                                       ln_sbop,
                                       ln_tipo
                                  from xwf700 x 
                                 where x.xwfprcins=instancia 
                                   and x.xwfcar3='1';
                            exception
                            when others then 
                                 ln_emp :=0; 
                                 ln_suc :=0; 
                                 ln_mod :=0;
                                 ln_mda :=0;
                                 ln_pap :=0;
                                 ln_cta :=0;
                                 ln_ope :=0;
                                 ln_sbop:=0;
                                 ln_tipo:=0;
                            end;
                                      --VERIFICAMOS QUE EN EL MOVIMIENTO DIARIO SE HAYA CANCELADO EL CREDITO.  
                                      --paso 06 det. mov. diario
                                      begin
                                        select 
                                               d.pgcod,
                                               d.itsuc,
                                               d.itmod,
                                               d.ittran,
                                               d.itnrel                              
                                          into 
                                               lv_pgcod,
                                               lv_suc,
                                               lv_mod,
                                               lv_tran,
                                               lv_nrel                                  
                                          from fsd016 d 
                                         where d.itmod = 117 
                                           and d.ittran  = 10 
                                           and d.itsucd  = ln_suc 
                                           and d.ctnro   = ln_cta 
                                           and d.itoper  = ln_ope 
                                           and d.modulo  = ln_mod;
                                      exception
                                      when others then 
                                           lv_pgcod:=0;
                                           lv_suc  :=0;
                                           lv_mod  :=0;
                                           lv_tran :=0;
                                           lv_nrel :=0;
                                      end;
                                      --paso 06 cab. mov. diario  
                                      --VERIFICAMOS QUE EL ESTADO ESTE EN EXTORNO.
                                      begin 
                                            select
                                                   d.itcorr                      
                                              into
                                                   lv_corr                 
                                              from fsd015 d 
                                             where d.pgcod =lv_pgcod 
                                               and d.itsuc =lv_suc
                                               and d.itmod =lv_mod 
                                               and d.ittran=lv_tran
                                               and d.itnrel=lv_nrel;
                                      exception
                                      when others then 
                                          lv_corr:=0;
                                      end;
                                      
                                      if lv_corr=99 then
                                         flag_desv:='S';
                                      else
                                      
                                            --VERIFICAMOS QUE EN EL MOVIMIENTO DIARIO SE DIO BAJA DE LINEA
                                            begin
                                                  select 
                                                         d.pgcod,
                                                         d.itsuc,
                                                         d.itmod,
                                                         d.ittran,
                                                         d.itnrel                              
                                                    into 
                                                         lv_pgcod,
                                                         lv_suc,
                                                         lv_mod,
                                                         lv_tran,
                                                         lv_nrel                                  
                                                    from fsd016 d 
                                                   where d.itmod = 117 
                                                     and d.ittran  = 100 
                                                     and d.itsucd  = ln_suc 
                                                     and d.ctnro   = ln_cta 
                                                     and d.itoper  = ln_ope 
                                                     and d.modulo  = ln_mod;
                                            exception
                                            when others then 
                                                 lv_pgcod:=0;
                                                 lv_suc  :=0;
                                                 lv_mod  :=0;
                                                 lv_tran :=0;
                                                 lv_nrel :=0;
                                            end;
                                              --paso 06 cab. mov. diario   
                                              --SE VERIFICA QUE EL ESTADO SIGA EN 0, ES DECIR NO SE HAYA ANULADO
                                              begin
                                                select
                                                       d.itcorr                      
                                                  into
                                                       lv_corr                 
                                                  from fsd015 d 
                                                 where d.pgcod =lv_pgcod 
                                                   and d.itsuc =lv_suc
                                                   and d.itmod =lv_mod 
                                                   and d.ittran=lv_tran
                                                   and d.itnrel=lv_nrel;
                                              exception
                                              when others then 
                                                 lv_corr:=99;
                                              end;  
                                              
                                              if lv_corr=0 then
                                                 flag_desv:='S';
                                              end if;                                           
                                      end if;
                                  end if;
                                  if flag_tarea='S' then
                                     flag_desv:='S';
                                     msj:='Desvinculado';
                                  end if;
                
              end if;    
                /*
                --paso 06 mov. historico
                select * from fsh016 h where h.hcmod=117 and h.htran=10  and hcta=1763818 and hoper=3638703;
                --PASO07 - con el dato obtenido se verifica si el itcorr es 99 si lo es se extorno por tanto le quitamos la instancia y el vinculo.

                --paso 08 verificamos que no se haya dado de baja.
                select * from fsd016 d where d.itmod=117 and ittran=100 and itsucd=17 and ctnro=1763818 and itoper=3638703 and modulo=117;
                select * from fsd015 d where d.pgcod=1 and d.itsuc=2 and d.itmod=117 and ittran=100 and d.itnrel=2;

                select * from fsh016 h where h.hcmod=117 and htran=100 and hsucor=2 and hnrel=1 and hmodul=117 and hcta=814504 and hoper=2206332; 
                select * from fsh015 h where h.hcmod=117 and htran=100 and hsucor=2 and hnrel=1 and hfcon='02/01/2017';
                */
                
exception 
  /*when no_data_found then */
when others then 
     dbms_output.put_line('error:');
end desvincular_linea;



procedure  sp_linea_vinc_CRM (pn_instancia  in number,
                              pc_ind out varchar2) is
  --2021.03.29 dcastro se modifico sp_linea_vinc_CRM
  --2024.09.25 dcastro se cambio tabla de crm por nueva tabla aqpb297
  
   

cursor lineas(ln_emp in number,ln_suc  in number,ln_mod  in number,
ln_mda  in number,ln_pap  in number, ln_cta in number,
ln_ope  in number,ln_sbo  in number,ln_top  in number)  is

select f.r1cod, f.r1mod, f.r1cta, f.r1oper , f.r1suc, f.r1mda, f.r1pap, f.r1sbop, f.r1tope
from fsr011 f 
where f.r1cod  = ln_emp  
  and f.r2suc  = ln_suc 
  and f.r2mod  = ln_mod 
  and f.r2cta  = ln_cta  
  and f.r2oper = ln_ope 
  and f.r2sbop = ln_sbo 
  and f.r2tope = ln_top 
  and f.r2mda =  ln_mda  
  and f.r2pap =  ln_pap  
  and relcod = 46 
  and r011co = 'S';
  

  
  

ln_mtocap number(18,2);
ln_tasa number(10,6);
ln_porcentaje  number(10,6);
ln_mtocred  number(18,2);
pn_emp number;
pn_suc number;
pn_mod number;
pn_mda number;
pn_pap number;
pn_cta number;
pn_ope number;
pn_sbo number;
pn_top number;
ln_scap number(18,2);
ln_capt number(18,2); 
ln_redu number(10,6);
lc_autonomia varchar2(100);
lc_ind varchar2(1);
ld_fechaguia date; --- 2024.09.25
lc_existe char(1);
                            
Begin

---
--- mod 101 tipope 600
/*      
    --obtener credito nuevo
    begin
      select x.xwfempresa,
             x.xwfsucursal,
             x.xwfmodulo,
             x.xwfmoneda,
             x.xwfpapel,
             x.xwfcuenta,
             x.xwfoperacion,
             x.xwfsubope,
             x.xwftipope
        into pn_emp,
             pn_suc,
             pn_mod,
             pn_mda,
             pn_pap,
             pn_cta,
             pn_ope,
             pn_sbo,
             pn_top
        from xwf700 x
       where x.xwfprcins = pn_instancia
         and x.xwfcar3 = '1'
         and rownum = 1;
    exception
      when others then
        pn_cta := null;
    end;

    --obtener nuevo credito
    ln_cta := pn_cta;
    ln_ope := pn_ope;
*/  

    --buscar credito vinculado
    begin
      select j.jaqy800pgcd, j.jaqy800mod, j.jaqy800suc, j.jaqy800mda, j.jaqy800pap, j.jaqy800cta, j.jaqy800ope, j.jaqy800sbop, j.jaqy800tope
      into pn_emp,  pn_mod, pn_suc, pn_mda, pn_pap, pn_cta, pn_ope, pn_sbo, pn_top
        from jaqy800 j
       where jaqy800ins=pn_instancia 
         and jaqy800vinc='S'
         and jaqy800tpc='P';
    exception
    when others then 
        pn_cta := null;
    end;

    pc_ind := 'N';    
    ---despues de obtener el modulo 117 buscar los creditos asociados al 116 y validar en CRM
    if pn_cta is not null then

      for i in lineas(pn_emp, pn_suc, pn_mod, pn_mda, pn_pap, pn_cta, pn_ope, pn_sbo, pn_top) loop        

/*          begin
            select 'S'
             into lc_ind
                 FROM REPROG L
             WHERE L.ESTADOSOLICITUD = 'BT'
               AND L.CUENTAOPERACION =  (i.r1cta ||'-'||i.r1oper) ;   
            exception when others then        
                  lc_ind := 'N';
            end;

           if lc_ind = 'S' then
              pc_ind := lc_ind;             
              exit;
           else
                         
              --2021.03.29 dcastro
              begin
                  SELECT 'S'
                    into lc_ind
                    FROM \*usrwebcrm.*\ LEY31050 L
                   INNER JOIN \*usrwebcrm.*\
                  LEY31050_CREDITOSFACILIDAD F
                      ON L.IDLEY31050 = F.IDLEY31050
                   WHERE L.ESTADOSOLICITUD = 'BT'
                     --AND L.TIPOFACILIDAD = 'CAJA'
                     AND SUBSTR(F.CUENTAOPERACION,
                                0,
                                INSTR(F.CUENTAOPERACION, '-') - 1) = i.r1cta 
                     AND SUBSTR(F.CUENTAOPERACION,
                                INSTR(F.CUENTAOPERACION, '-') + 1,
                                99) = i.r1oper
                     AND F.EMPRESA = i.r1cod
                     --AND F.SUCURSAL = pn_suc
                     AND F.MODULO = i.r1mod
                     AND F.MONEDA = i.r1mda
                     AND F.PAPEL = i.r1pap
                     AND F.SUBOPERACION = i.r1sbop
                     AND F.TIPOOPERACION = i.r1tope; 
                     
                exception
                  when others then
                    pc_ind := 'N';  
                end;

                 if lc_ind = 'S' then
                    pc_ind := lc_ind;             
                    exit;
                 end if;
           end if;
*/

        /*2024.09.25 se cambio tabla aqpb297*/   
          begin
           select  to_date(f.tp1desc, 'DD/MM/YYYY') 
           into ld_fechaguia
           from FST198 F
          WHERE TP1COD = 1
            AND TP1COD1 = 10847 
            AND TP1CORR1 = 905
            AND TP1CORR2 = 1
            AND TP1CORR3 = 1; ---
          exception when others then
             ld_fechaguia := null;
          end; 

          if ld_fechaguia is not null then
              begin
                   select  'S'
                   into lc_existe 
                   from aqpb297 a
                   where a.aqpb297fec = ld_fechaguia
                     and a.aqpb297cta = i.r1cta
                     and a.aqpb297oper = i.r1oper
                     and a.aqpb297mod = i.r1mod
                     and a.aqpb297est = 'S';
                exception when others then
                      lc_existe := 'N';    
              end; 
          else
             lc_existe := 'N';
          end if;    
          pc_ind := lc_existe;
     end loop;
     
    end if;  
        
                              
end sp_linea_vinc_CRM;


procedure sp_deuda_linea (pn_instancia  in number,
                          pc_ind out varchar2) is
 
cursor lineas(ln_emp in number,ln_suc  in number,ln_mod  in number,
ln_mda  in number,ln_pap  in number, ln_cta in number,
ln_ope  in number,ln_sbo  in number,ln_top  in number)  is

select f.r1cod, f.r1mod, f.r1suc, f.r1mda, f.r1pap, f.r1cta, f.r1oper, f.r1sbop, f.r1tope
from fsr011 f 
where f.r1cod  = ln_emp  
  and f.r2suc  = ln_suc 
  and f.r2mod  = ln_mod 
  and f.r2cta  = ln_cta  
  and f.r2oper = ln_ope 
  and f.r2sbop = ln_sbo 
  and f.r2tope = ln_top 
  and f.r2mda =  ln_mda  
  and f.r2pap =  ln_pap  
  and relcod = 46 
  and r011co = 'S';
  

  
  

ln_mtocap number(18,2);
ln_tasa number(10,6);
ln_porcentaje  number(10,6);
ln_mtocred  number(18,2);
pn_emp number;
pn_suc number;
pn_mod number;
pn_mda number;
pn_pap number;
pn_cta number;
pn_ope number;
pn_sbo number;
pn_top number;
ln_scap number(18,2);
ln_capt number(18,2); 
ln_redu number(10,6);
lc_autonomia varchar2(100);
lc_ind varchar2(1);
ln_mtodeu number;
ln_mtotot number;
ln_monto number;
                            
Begin

---
  

    --buscar credito vinculado
    begin
      select j.jaqy800pgcd, j.jaqy800mod, j.jaqy800suc, j.jaqy800mda, j.jaqy800pap, j.jaqy800cta, j.jaqy800ope, j.jaqy800sbop, j.jaqy800tope
      into pn_emp,  pn_mod, pn_suc, pn_mda, pn_pap, pn_cta, pn_ope, pn_sbo, pn_top
        from jaqy800 j
       where jaqy800ins=pn_instancia 
         and jaqy800vinc='S'
         and jaqy800tpc='P';
    exception
    when others then 
        pn_cta := null;
    end;

    pc_ind := 'N';    
    ---despues de obtener el modulo 117 buscar los creditos asociados al 116 y validar en CRM
    if pn_cta is not null then

      for i in lineas(pn_emp, pn_suc, pn_mod, pn_mda, pn_pap, pn_cta, pn_ope, pn_sbo, pn_top) loop        

          begin
             select j.jaql964mtd 
              into ln_mtodeu 
             from jaql964 j
             where j.jaql964cta = i.r1cta
               and j.jaql964ope = i.r1oper
               and j.jaql964mod = i.r1mod
               and j.jaql964suc = i.r1suc
               and j.jaql964mda = i.r1mda
               and j.jaql964pgcod = i.r1cod
               and j.jaql964pap = i.r1pap;
          exception
          when others then 
              ln_mtodeu := 0;
          end;

           ln_mtotot := nvl(ln_mtotot,0) + ln_mtodeu;
           
           
     end loop;
     

    begin
      select x.xwfmonto1
        into ln_monto
        from xwf700 x
       where x.xwfprcins = pn_instancia
         and x.xwfcar3 = '1'
         and rownum = 1;
    exception
      when others then
        ln_monto := 0;
    end;

     
     if ln_monto <> ln_mtotot then
        pc_ind := 'S';             
     else
        pc_ind := 'N';             
     end if;

    end if;  
        
                              
end sp_deuda_linea;


end pq_cr_lineas_vinc;
/

