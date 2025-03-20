create or replace package pq_cr_condonaciones is

  -- Author  : KVALENCIAC
  -- Created : 18/10/2017 10:58:25 a.m.
  -- Purpose : 
  -- Modificado : KVALENCIAC
  -- Fecha : 20/10/2020 
  -- Modificación : Se adicionó el grabado del monto diferido y de los montos de los reprogramados 
  -- Modificado : KVALENCIAC
  -- Fecha : 21/05/2020 
  -- Modificación : Se adicinó más importes de donde obtener en los conceptos 
  -- Modificado : KVALENCIAC
  -- Fecha : 26/08/2021 - 09/09/2021
  -- Modificación : Se adicinó procesos para la exoneración de la última cuota 
  -- Fecha : kvalenciac 25/05/2023
  -- Modificación : Se adicinó el cálculo de los montos a pagar de las transacciones de cancelación. 
   
  procedure sp_graba (vn_Pgcod in number, 
                     vn_Itsuc in number, 
                     vn_Itmod in number,
                     vn_Ittran in number, 
                     vn_Itnrel in number, 
                     vn_Itord in number, 
                     vn_Itsbor in number, 
                     vd_Pgfape date);
  procedure sp_graba2 (vn_Pgcod in number, 
                      vn_Itsuc in number, 
                      vn_Itmod in number, 
                      vn_Ittran in number, 
                      vn_Itnrel in number, 
                      vn_Itord in number, 
                      vn_Itsbor in number, 
                      vd_Pgfape date);
  procedure sp_graba3 (vn_Pgcod in number, 
                      vn_Itsuc in number, 
                      vn_Itmod in number, 
                      vn_Ittran in number, 
                      vn_Itnrel in number, 
                      vn_Itord in number, 
    vn_Itsbor in number, vd_Pgfape date);
    procedure sp_graba4 (vn_Pgcod in number, 
                         vn_Itsuc in number, 
                         vn_Itmod in number, 
                         vn_Ittran in number, 
                         vn_Itnrel in number, 
                         vn_Itord in number, 
                         vn_Itsbor in number, 
                         vd_Pgfape date);
  procedure sp_cuota (vn_Pgcod in number, 
                      vn_ppmod in number, 
                      vn_ppsuc in number, 
                      vn_ppmda in number, 
                      vn_pppap in number,
                      vn_ppcta in number, 
                      vn_ppoper in number,
                      vn_ppsbop in number, 
                      vn_pptope in number,
                      vn_ppfpag in date, 
                      vd_Pgfape in date,
                      ln_cuota out number);
  procedure sp_JAQZ893(vn_Pgcod in number, 
                       vn_Itsuc in number, 
                       vn_Itmod in number, 
                       vn_Ittran in number, 
                       vn_Itnrel in number, 
                       vn_Itord in number, 
                       vn_Itsbor in number, 
                       vd_Pgfape date);
  procedure sp_eliminaJAQZ893(vn_Pgcod in number, 
                              vn_Itsuc in number, 
                              vn_Itmod in number, 
                              vn_Ittran in number, 
                              vn_Itnrel in number, 
                              vn_Itord in number, 
                              vn_Itsbor in number, 
                              vd_Pgfape date);
  procedure sp_diasatraso (v_aqpa018hpgcod in number, 
                           v_aqpa018hmodul in number,
                           v_aqpa018hsucur in number, 
                           v_aqpa018hmda in number,
                           v_aqpa018hpap in number, 
                           v_aqpa018hcta in number, 
                           v_aqpa018hoper in number, 
                           v_aqpa018hsubop in number, 
                           v_aqpa018htoper in number,
                           vd_Pgfape in date, 
                           ln_AQPA018DIAATR out number);
  procedure sp_montosultimacuota (vn_Pgcod in number,
                                  vn_Itsuc in number, 
                                  vn_Itmod in number, 
                                  vn_Ittran in number, 
                                  vn_Itnrel in number, 
                                  vn_Itord in number, 
                                  vn_Itsbor in number, 
                                  vd_Pgfape in date);
  procedure sp_exoneraultimacuota (vn_Pgcod in number, 
                                   vn_Itsuc in number, 
                                   vn_Itmod in number, 
                                   vn_Ittran in number, 
                                   vn_Itnrel in number, 
                                   vn_Itord in number, 
                                   vn_Itsbor in number, 
                                   vd_Pgfape date); 
  procedure sp_esreprog_exonerado (vn_Pgcod in number, 
                                   vn_ppmod in number, 
                                   vn_ppsuc in number, 
                                   vn_ppmda in number, 
                                   vn_pppap in number,
                                   vn_ppcta in number, 
                                   vn_ppoper in number,
                                   vn_ppsbop in number, 
                                   vn_pptope in number,
                                   vn_ppfpag in date, 
                                   ln_Indicador out number);
  procedure sp_ultimacuota( v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             vd_ppfpag in date,                              
                             v_esvencido out number                             
                             ) ; 
 procedure sp_estaamortizando( vn_Pgcod in number, 
                              vn_Itsuc in number, 
                              vn_Itmod in number, 
                              vn_Ittran in number, 
                              vn_Itnrel in number, 
                              vn_Itord in number, 
                              vn_Itsbor in number,
                              vd_ppfpag in date,                            
                              v_esamortizacion out number                            
                             ) ;                                
end pq_cr_condonaciones;
/

create or replace package body pq_cr_condonaciones is

procedure sp_graba ( vn_Pgcod in number, vn_Itsuc in number, vn_Itmod in number, vn_Ittran in number, vn_Itnrel in number, vn_Itord in number, 
    vn_Itsbor in number, vd_Pgfape date)
is
vn_capital number(17,2);
vn_seguros number(17,2);
vn_oro number(17,2);
vn_penalidad number(17,2);
vn_intmora number(17,2);
vn_icv number(17,2);
vn_intcompe number(17,2);
lc_rubro number(16,0);
ln_AQPA018TIPCRE varchar2(2);
ln_AQPA018DIAATR number(5,0);
ld_AQPA018FECINT date;
ln_AQPA018NROEXP char(20);
lc_AQPA018ACUPAG char (1);
lc_AQPA018DACUPAG  varchar2(50);
lc_AQPA018CANESP varchar2(200);
v_aqpa018hpgcod number(3); 
v_aqpa018hmodul number(3);
v_aqpa018htoper number(3);
v_aqpa018hsucur number(3);
v_aqpa018hmda number(4);
v_aqpa018hpap number(4);
v_aqpa018hcta number(9);
v_aqpa018hoper number(9);
v_aqpa018hsubop number(3);
ln_tpn1ro1 number(9);
ln_tpn1ro2 number(9);
ld_scfvto date;
ln_scstat number(2);
begin
        begin
        select --f_pag,itmod,ittran,itsuc,itnrel,
        sum(decode(tp1nro3,0,monto,0 )) capital,
        sum(decode(tp1nro3,1,monto,0 )) seguros,
        sum(decode(tp1nro3,2,monto,0 )) oro,
        sum(decode(tp1nro3,3,monto,0 )) penalidad,
        sum(decode(tp1nro3,4,monto,0 )) intmora,
        sum(decode(tp1nro3,5,monto,0 )) icv,        
        sum(decode(tp1nro3,6,monto,0 )) intcompe
        into vn_capital,vn_seguros,vn_oro,vn_penalidad,vn_intmora,vn_icv,vn_intcompe
        from
        (select g.tp1nro3,h.itmod,h.ittran,h.itsuc,h.itnrel,itfcon as f_pag,
        sum(h.itimp1) monto 
        from
        fsd016 h
        inner join fst198 g
          on h.itord=g.tp1nro1
          and g.tp1cod=1
          and g.tp1cod1=11105
          and g.tp1corr1=10
          and g.tp1corr2 in (1,2) -- kdvc 20/10/2020
          and g.tp1imp1 = h.itmod
          and g.tp1imp2 = h.ittran
        inner join fsd015 f
          on  f.pgcod=h.pgcod
          and f.itsuc=h.itsuc
          and f.itmod=h.itmod
          and f.ittran=h.ittran
          and f.itnrel=h.itnrel
        where f.pgcod=vn_Pgcod
        and f.itsuc=vn_Itsuc
        and f.itmod=vn_Itmod        
        and f.ittran=vn_Ittran        
        and f.itnrel=vn_Itnrel
        --and f.itcont='S'
        --and f.itcorr=0
        group by g.tp1nro3,h.itmod,h.ittran,h.itsuc,h.itnrel,f.itfcon,f.itfvc)
        group by f_pag,itmod,ittran,itsuc,itnrel;
      EXCEPTION
            when others then
          vn_capital:=0;
          vn_seguros:=0;
          vn_oro:=0;
          vn_penalidad:=0;
          vn_intmora:=0;
          vn_icv:=0;
          vn_intcompe:=0;
        end;
        --si es una trasaccion que este dentro de esta guia entonces se debe buscar el rubro de otro ordinal que no sea el 10
        begin
        select tp1nro1,tp1nro2 into ln_tpn1ro1,ln_tpn1ro2 from fst198 where tp1cod=1 and tp1cod1=11105 and tp1corr1=12 and tp1imp1=vn_Itmod and tp1imp2=vn_Ittran;
        exception
        when no_data_found then
          ln_tpn1ro1:= 10;
          ln_tpn1ro2:= 0;
        end;
        begin
          select rubro into lc_rubro from fsd016 f where f.pgcod=vn_Pgcod
          and f.itsuc=vn_Itsuc
          and f.itmod=vn_Itmod        
          and f.ittran=vn_Ittran        
          and f.itnrel=vn_Itnrel
          and f.itord = ln_tpn1ro1;
          exception
          when no_data_found then
              begin
              select rubro into lc_rubro from fsd016 f where f.pgcod=vn_Pgcod
              and f.itsuc=vn_Itsuc
              and f.itmod=vn_Itmod        
              and f.ittran=vn_Ittran        
              and f.itnrel=vn_Itnrel
              and f.itord = ln_tpn1ro2;
              exception
              when no_data_found then
                 lc_rubro:= 0;
              end;
         end; 
          
        --obtengo la clave del credito
        Begin
        select aqpa018hpgcod, 
        aqpa018hmodul,
        aqpa018htoper,
        aqpa018hsucur,
        aqpa018hmda,
        aqpa018hpap, 
        aqpa018hcta,
        aqpa018hoper,
        aqpa018hsubop into
        v_aqpa018hpgcod,
        v_aqpa018hmodul,
        v_aqpa018htoper,
        v_aqpa018hsucur,
        v_aqpa018hmda,
        v_aqpa018hpap,
        v_aqpa018hcta,
        v_aqpa018hoper,
        v_aqpa018hsubop
        from AQPA018 a
         where AQPA018IPGCOD = vn_Pgcod       
         and AQPA018Itmod = vn_Itmod                        
         and AQPA018Itsuc = vn_Itsuc
         and AQPA018Ittran = vn_Ittran        
         and AQPA018Itnrel = vn_Itnrel
         and AQPA018Itfcon = vd_Pgfape;
         exception
        when others then
          NULL;
        end; 
        Begin
          select scfvto,scstat into ld_scfvto,ln_scstat  from fsd011 f 
          where f.pgcod=v_aqpa018hpgcod 
          and f.scmod=v_aqpa018hmodul 
          and f.scsuc=v_aqpa018hsucur 
          and f.scmda=v_aqpa018hmda 
          and f.scpap=v_aqpa018hpap 
          and f.sccta=v_aqpa018hcta
          and f.scoper=v_aqpa018hoper 
          and f.sctope=v_aqpa018htoper
          and f.scsbop=v_aqpa018hsubop;
         exception
         when others then
           null;
         end;
         --ln_scstat era el estado a la fecha de proceso como queda pero se va a cambiar al estado del modulo y operacion
          Case
            when vn_Ittran = 200 then
              ln_scstat := 23;
            when vn_Ittran = 210 then
              ln_scstat := 23;
            when vn_Ittran = 402 then
              ln_scstat := 64;
            when vn_Ittran = 407 then
              ln_scstat := 90;
            Else
              ln_scstat := ln_scstat;
          end case;
         ln_AQPA018DIAATR := vd_Pgfape - ld_scfvto;
        ---se debe guardar los otros montos 
/*        sp_dias_atraso(vd_Pgfape, v_aqpa018hpgcod, v_aqpa018hmodul,v_aqpa018hsucur,
        v_aqpa018hmda,
        v_aqpa018hpap,
        v_aqpa018hcta,
        v_aqpa018hoper,
        v_aqpa018hsubop,
        v_aqpa018htoper,
        0,ld_scfvto,
        ln_AQPA018DIAATR); */
        --fecha de interposicion
        begin
        select t.jaqm33fint, t.jaqm33nexp
        into ld_AQPA018FECINT, ln_AQPA018NROEXP
        from jaqm33 t, jaqm27 j
        where j.jaqm27pgc = v_aqpa018hpgcod
         and j.jaqm27mod = v_aqpa018hmodul
         and j.jaqm27suc = v_aqpa018hsucur
         and j.jaqm27mda = v_aqpa018hmda
         and j.jaqm27pap = v_aqpa018hpap
         and j.jaqm27cta = v_aqpa018hcta
         and j.jaqm27oper = v_aqpa018hoper
         and j.jaqm27sbop = v_aqpa018hsubop
         and j.jaqm27tope = v_aqpa018htoper
         and j.jaqm33cor = t.jaqm33cor;
         exception
        when others then
          NULL;
        end;
       /*--acuerdo de pago  y descripcion de acuerdo de pago
        PQ_CR_jaql964_cartera.sp_cr_acuerdo_pago( P_N_JAQL165EMP  => v_aqpa018hpgcod,
                                               P_N_JAQL165SUC  => v_aqpa018hsucur,
                                               P_N_JAQL165MDA  => v_aqpa018hmda,
                                               P_N_JAQL165PAP  => v_aqpa018hpap,
                                               P_N_JAQL165CTA  => v_aqpa018hcta,
                                               P_N_JAQL165OPE  => v_aqpa018hoper,
                                               P_N_JAQL165SBO  => v_aqpa018hsubop,
                                               P_N_JAQL165TOP  => v_aqpa018htoper,
                                               P_N_JAQL165MOD  => v_aqpa018hmodul,
                                               P_N_JAQL165COM  => lc_AQPA018ACUPAG,
                                               P_N_JAQL165DCOM => lc_AQPA018DACUPAG);
         */
         begin
          SELECT s.JAQL165COM
            into lc_AQPA018ACUPAG
            FROM (select * from JAQL165 T
         where t.jaql165emp = v_aqpa018hpgcod
           and t.jaql165suc = v_aqpa018hsucur
           and t.jaql165mda = v_aqpa018hmda
           and t.jaql165pap = v_aqpa018hpap
           and t.jaql165cta = v_aqpa018hcta
           and t.jaql165ope = v_aqpa018hoper
           and t.jaql165sbo = v_aqpa018hsubop
           and t.jaql165top = v_aqpa018htoper
           and t.jaql165mod = v_aqpa018hmodul           
           order by  t.jaql165corr desc) s
           where rownum=1;
        
        exception
          when others then
            NULL;
        end;
        
        if lc_AQPA018ACUPAG = 'P' then
          lc_AQPA018DACUPAG := 'Cancelacion Especial Parcial';
        elsif lc_AQPA018ACUPAG = 'D' then
          lc_AQPA018DACUPAG := 'De pago';
        elsif lc_AQPA018ACUPAG = 'T' then
          lc_AQPA018DACUPAG := 'Cancelacion Especial Total';
        elsif lc_AQPA018ACUPAG = 'N' then
          lc_AQPA018DACUPAG := 'Ninguna';
        end if;
         ---cancelación especial        
        begin
        SELECT s.JAQL165TEX
            into lc_AQPA018CANESP
            FROM (select * from JAQL165 T
            where t.jaql165emp = v_aqpa018hpgcod
             and t.jaql165suc = v_aqpa018hsucur
             and t.jaql165mda = v_aqpa018hmda
             and t.jaql165pap = v_aqpa018hpap
             and t.jaql165cta = v_aqpa018hcta
             and t.jaql165ope = v_aqpa018hoper
             and t.jaql165sbo = v_aqpa018hsubop
             and t.jaql165top = v_aqpa018htoper
             and t.jaql165mod = v_aqpa018hmodul
             and t.jaql165com in ('T','P')
             order by t.jaql165corr desc) s 
             where rownum=1;
         exception
          when others then
            NULL;
         end;

        /* PQ_CR_jaql964_cartera.sp_cr_cancelacion_esp(P_N_JAQL165EMP => v_aqpa018hpgcod,
                                                  P_N_JAQL165SUC => v_aqpa018hsucur,
                                                  P_N_JAQL165MDA => v_aqpa018hmda,
                                                  P_N_JAQL165PAP => v_aqpa018hpap,
                                                  P_N_JAQL165CTA => v_aqpa018hcta,
                                                  P_N_JAQL165OPE => v_aqpa018hcta,
                                                  P_N_JAQL165SBO => v_aqpa018hsubop,
                                                  P_N_JAQL165TOP => v_aqpa018htoper,
                                                  P_N_JAQL165MOD => v_aqpa018hmodul,
                                                  P_N_JAQL165TEX => lc_AQPA018CANESP);*/
        -- tipo de credito
        ln_AQPA018TIPCRE := substr(lc_rubro,5,2);
        --se debe insertar estos montos en la tabla estos son los montos Condonados
        update AQPA018 set 
          AQPa018mcapitc=vn_capital, 
          AQPa018mseguc=vn_seguros, 
          AQPa018motroc=vn_oro ,
          AQPa018mpenac=vn_penalidad, 
          AQPa018minmoc=vn_intmora,
          AQPa018micvc=vn_icv, 
          aqpa018mincoc=vn_intcompe, 
          AQPa018mSUMAC = vn_seguros + vn_oro + vn_penalidad + vn_intmora + vn_icv + vn_intcompe,
    
          AQPa018hrubroc = lc_rubro,
          AQPA018TIPCRE = ln_AQPA018TIPCRE,
          AQPA018DIAATR = ln_AQPA018DIAATR,
          AQPA018FECINT = ld_AQPA018FECINT,
          AQPA018NROEXP = ln_AQPA018NROEXP,
          AQPA018ACUPAG = lc_AQPA018ACUPAG,
          AQPA018DACUPAG = lc_AQPA018DACUPAG,
          AQPA018CANESP = lc_AQPA018CANESP,
          AQPA018STATC = ln_scstat
        where AQPA018IPGCOD = vn_Pgcod       
         and AQPA018Itmod = vn_Itmod                        
         and AQPA018Itsuc = vn_Itsuc
         and AQPA018Ittran = vn_Ittran        
         and AQPA018Itnrel = vn_Itnrel
         and AQPA018Itfcon = vd_Pgfape;
         commit;
end sp_graba;
procedure sp_graba2 ( vn_Pgcod in number, vn_Itsuc in number, vn_Itmod in number, vn_Ittran in number, vn_Itnrel in number, vn_Itord in number, 
    vn_Itsbor in number, vd_Pgfape date)
is
vn_capital number(17,2);
vn_seguros number(17,2);
vn_oro number(17,2);
vn_penalidad number(17,2);
vn_intmora number(17,2);
vn_icv number(17,2);
vn_intcompe number(17,2);
vn_capital_ref number(17,2);
lc_rubro number(16,0);
ln_AQPA018TIPCRE  varchar2(2);
ln_AQPA018DIAATR number(5,0);
ld_AQPA018FECINT date;
ln_AQPA018NROEXP char(20);
lc_AQPA018ACUPAG char (1);
lc_AQPA018DACUPAG  varchar2(50);
lc_AQPA018CANESP varchar2(200);
v_aqpa018hpgcod number(3); 
v_aqpa018hmodul number(3);
v_aqpa018htoper number(3);
v_aqpa018hsucur number(3);
v_aqpa018hmda number(4);
v_aqpa018hpap number(4);
v_aqpa018hcta number(9);
v_aqpa018hoper number(9);
v_aqpa018hsubop number(3);
ld_scfvto date;
ln_scstat number(2);
v_AQPa018mpenac number(17,2); 
v_AQPa018minmoc number(17,2);
v_AQPa018micvc number(17,2);
v_AQPa018mcapitc number(17,2);
v_AQPa018mseguc number(17,2);
v_AQPa018motroc number(17,2);
v_aqpa018mincoc number(17,2);
v_AQPa018mSUMAC number(17,2);

begin
        begin
        select 
        --sum(decode(tp1nro3,0,monto,0 )) capital,
        sum(decode(tp1imp3,1,decode(tp1nro3,0,monto,0 ),2,decode(tp1nro3,0,monto2,0 ))) capital,
        sum(decode(tp1nro3,1,monto,0 )) seguros,
        sum(decode(tp1nro3,2,monto,0 )) oro,
        sum(decode(tp1nro3,3,monto,0 )) penalidad,
        --sum(decode(tp1nro3,4,monto,0 )) intmora,
        sum(decode(tp1imp3,1,decode(tp1nro3,4,monto,0 ),4,decode(tp1nro3,4,monto4,0 ),12,decode(tp1nro3,4,monto12,0 ))) intmora,
        --sum(decode(tp1nro3,5,monto,0 )) icv,        
        sum(decode(tp1imp3,1,decode(tp1nro3,5,monto,0 ),4,decode(tp1nro3,5,monto4,0 ),12,decode(tp1nro3,5,monto12,0 ))) icv,
        sum(decode(tp1nro3,6,monto,0 )) intcompe,
        sum(decode(tp1nro3,7,monto,0 )) capital_ref--se adiciono kdvc 13/11/2019 
        into vn_capital,vn_seguros,vn_oro,vn_penalidad,vn_intmora,vn_icv,vn_intcompe,vn_capital_ref
        from
        (select g.tp1nro3,h.itmod,h.ittran,h.itsuc,h.itnrel,itfcon as f_pag,
        sum(h.itimp1) monto,g.tp1imp3, sum(h.itimp4) monto4, sum(h.itimp12) monto12,sum(h.itimp2) monto2--sum(h.itimp1) monto 
        from
        fsd016 h
        inner join fst198 g
          on h.itord=g.tp1nro1
          and g.tp1cod=1
          and g.tp1cod1=11105
          and g.tp1corr1=10
          and g.tp1corr2=2   --- solo para modulo y transacciones de exoneraciones
          and g.tp1imp1 = h.itmod
          and g.tp1imp2 = h.ittran
        inner join fsd015 f
          on  f.pgcod=h.pgcod
          and f.itsuc=h.itsuc
          and f.itmod=h.itmod
          and f.ittran=h.ittran
          and f.itnrel=h.itnrel
        where f.pgcod=vn_Pgcod
        and f.itsuc=vn_Itsuc
        and f.itmod=vn_Itmod        
        and f.ittran=vn_Ittran        
        and f.itnrel=vn_Itnrel
        --and f.itcont='S'
        --and f.itcorr=0
        group by g.tp1nro3,h.itmod,h.ittran,h.itsuc,h.itnrel,f.itfcon,f.itfvc,g.tp1imp3)      
        group by f_pag,itmod,ittran,itsuc,itnrel;
      EXCEPTION
            when others then
          vn_capital:=0;
          vn_seguros:=0;
          vn_oro:=0;
          vn_penalidad:=0;
          vn_intmora:=0;
          vn_icv:=0;
          vn_intcompe:=0;
        end;
        --para los casos 
        begin
          select rubro into lc_rubro from fsd016 f where f.pgcod=vn_Pgcod
          and f.itsuc=vn_Itsuc
          and f.itmod=vn_Itmod        
          and f.ittran=vn_Ittran        
          and f.itnrel=vn_Itnrel
          and f.itord = 10;
        exception
         when no_data_found then
          lc_rubro:= 0;
        end; 
          
        --obtengo la clave del credito
        Begin
        select aqpa018hpgcod, 
        aqpa018hmodul,
        aqpa018htoper,
        aqpa018hsucur,
        aqpa018hmda,
        aqpa018hpap, 
        aqpa018hcta,
        aqpa018hoper,
        aqpa018hsubop into
        v_aqpa018hpgcod,
        v_aqpa018hmodul,
        v_aqpa018htoper,
        v_aqpa018hsucur,
        v_aqpa018hmda,
        v_aqpa018hpap,
        v_aqpa018hcta,
        v_aqpa018hoper,
        v_aqpa018hsubop
        from AQPA018 a
         where AQPA018IPGCOD = vn_Pgcod       
         and AQPA018Itmod = vn_Itmod                        
         and AQPA018Itsuc = vn_Itsuc
         and AQPA018Ittran = vn_Ittran        
         and AQPA018Itnrel = vn_Itnrel
         and AQPA018Itfcon = vd_Pgfape;
         exception
        when others then
          NULL;
        end; 
        Begin
          select aofvto/*,aostat*/ into ld_scfvto/*,ln_scstat*/  from fsd010 f 
          where f.pgcod=v_aqpa018hpgcod 
          and f.aomod=  v_aqpa018hmodul 
          and f.aosuc=  v_aqpa018hsucur 
          and f.aomda=  v_aqpa018hmda 
          and f.aopap=  v_aqpa018hpap 
          and f.aocta=  v_aqpa018hcta
          and f.aooper= v_aqpa018hoper 
          and f.aotope= v_aqpa018htoper
          and f.aosbop= v_aqpa018hsubop;
         exception
         when others then
           null;
         end;
/*         --estado
         Begin
         select jaqy971stat into ln_scstat from jaqy971 where 
              jaqy971pgco = v_aqpa018hpgcod 
          and jaqy971mod  = v_aqpa018hmodul
          and jaqy971sucu = v_aqpa018hsucur
          and jaqy971mda =  v_aqpa018hmda 
          and jaqy971pape = v_aqpa018hpap 
          and jaqy971ncta = v_aqpa018hcta
          and jaqy971oper = v_aqpa018hoper 
          and jaqy971sbop = v_aqpa018hsubop
          and jaqy971tope = v_aqpa018htoper
          and jaqy971pgtr = vn_Pgcod 
          and jaqy971modt = vn_Itmod 
          and jaqy971suct = vn_Itsuc
          and jaqy971tran = vn_Ittran
          and jaqy971relt = vn_Itnrel;                                     
         exception
        when no_data_found then
            select aostat into ln_scstat  from fsd010 f 
            where f.pgcod=v_aqpa018hpgcod 
            and f.aomod=  v_aqpa018hmodul 
            and f.aosuc=  v_aqpa018hsucur 
            and f.aomda=  v_aqpa018hmda 
            and f.aopap=  v_aqpa018hpap 
            and f.aocta=  v_aqpa018hcta
            and f.aooper= v_aqpa018hoper 
            and f.aotope= v_aqpa018htoper
            and f.aosbop= v_aqpa018hsubop;
         end;*/
        ---se debe guardar los otros montos 
      /*  sp_dias_atraso(vd_Pgfape, v_aqpa018hpgcod, v_aqpa018hmodul,v_aqpa018hsucur,
        v_aqpa018hmda,
        v_aqpa018hpap,
        v_aqpa018hcta,
        v_aqpa018hoper,
        v_aqpa018hsubop,
        v_aqpa018htoper,
        ln_scstat,ld_scfvto,
        ln_AQPA018DIAATR); */
        --fecha de interposicion
        begin
        select t.jaqm33fint, t.jaqm33nexp
        into ld_AQPA018FECINT, ln_AQPA018NROEXP
        from jaqm33 t, jaqm27 j
        where j.jaqm27pgc = v_aqpa018hpgcod
         and j.jaqm27mod = v_aqpa018hmodul
         and j.jaqm27suc = v_aqpa018hsucur
         and j.jaqm27mda = v_aqpa018hmda
         and j.jaqm27pap = v_aqpa018hpap
         and j.jaqm27cta = v_aqpa018hcta
         and j.jaqm27oper = v_aqpa018hoper
         and j.jaqm27sbop = v_aqpa018hsubop
         and j.jaqm27tope = v_aqpa018htoper
         and j.jaqm33cor = t.jaqm33cor;
         exception
        when others then
          NULL;
        end;
        begin
          SELECT s.JAQL165COM
            into lc_AQPA018ACUPAG
            FROM (select * from JAQL165 T
         where t.jaql165emp = v_aqpa018hpgcod
           and t.jaql165suc = v_aqpa018hsucur
           and t.jaql165mda = v_aqpa018hmda
           and t.jaql165pap = v_aqpa018hpap
           and t.jaql165cta = v_aqpa018hcta
           and t.jaql165ope = v_aqpa018hoper
           and t.jaql165sbo = v_aqpa018hsubop
           and t.jaql165top = v_aqpa018htoper
           and t.jaql165mod = v_aqpa018hmodul           
           order by  t.jaql165corr desc) s
           where rownum=1;        
        exception
          when others then
            NULL;
        end;
      
        if lc_AQPA018ACUPAG = 'P' then
          lc_AQPA018DACUPAG := 'Cancelacion Especial Parcial';
        elsif lc_AQPA018ACUPAG = 'D' then
          lc_AQPA018DACUPAG := 'De pago';
        elsif lc_AQPA018ACUPAG = 'T' then
          lc_AQPA018DACUPAG := 'Cancelacion Especial Total';
        elsif lc_AQPA018ACUPAG = 'N' then
          lc_AQPA018DACUPAG := 'Ninguna';
        end if;
         ---cancelación especial        
        begin
        SELECT s.JAQL165TEX
            into lc_AQPA018CANESP
            FROM (select * from JAQL165 T
            where t.jaql165emp = v_aqpa018hpgcod
             and t.jaql165suc = v_aqpa018hsucur
             and t.jaql165mda = v_aqpa018hmda
             and t.jaql165pap = v_aqpa018hpap
             and t.jaql165cta = v_aqpa018hcta
             and t.jaql165ope = v_aqpa018hoper
             and t.jaql165sbo = v_aqpa018hsubop
             and t.jaql165top = v_aqpa018htoper
             and t.jaql165mod = v_aqpa018hmodul
             and t.jaql165com in ('T','P')
             order by t.jaql165corr desc) s 
             where rownum=1;
         exception
          when others then
            NULL;
         end;
        -- tipo de credito
        ln_AQPA018TIPCRE := substr(lc_rubro,5,2);
        --se debe insertar estos montos en la tabla estos son los montos Condonados
        update AQPA018 set 
          AQPa018mcapip=vn_capital, 
          AQPa018msegup=vn_seguros, 
          AQPa018motrop=vn_oro ,
          AQPa018mpenap=vn_penalidad, 
          AQPa018minmop=vn_intmora,
          AQPa018micvp=vn_icv, 
          aqpa018mincop=vn_intcompe,
          aqpa018mcapref=vn_capital_ref, 
          AQPa018hrubroc = lc_rubro, ---ESTO PREGUNTAR SI ESTA BIEN ESE RUBRO DE LA TRANSACCION DE PAGO
          AQPA018TIPCRE = ln_AQPA018TIPCRE,
          AQPA018FECINT = ld_AQPA018FECINT,
          AQPA018NROEXP = ln_AQPA018NROEXP,
          AQPA018ACUPAG = lc_AQPA018ACUPAG,
          AQPA018DACUPAG = lc_AQPA018DACUPAG,
          AQPA018CANESP = lc_AQPA018CANESP
        where AQPA018IPGCOD = vn_Pgcod       
         and AQPA018Itmod =   vn_Itmod                        
         and AQPA018Itsuc =   vn_Itsuc
         and AQPA018Ittran =  vn_Ittran        
         and AQPA018Itnrel =  vn_Itnrel
         and AQPA018Itfcon =  vd_Pgfape;
         commit;
        --se adiciono este update kdvc 13/11/2019 para que calcule todos los campos C
         update AQPA018 set
         AQPa018mpenac = AQPa018mpenad - AQPa018mpenap, --solo se actualiza estos montos porque son los exonerados por estas transacciones
         AQPa018minmoc = AQPa018minmod - AQPa018minmop,  --exonerado por la transaccion 30/111  o 30/122
         AQPa018micvc  = AQPa018micvd - AQPa018micvp,    ---exonerado solo por la transaccion 30/111 
         AQPa018mcapitc = AQPa018mcapitd - AQPa018mcapip - AQPa018mcapref, 
         AQPa018mseguc = AQPa018msegud - AQPa018msegup , 
         AQPa018motroc = AQPa018motrod - AQPa018motrop,
         aqpa018mincoc = aqpa018mincod - aqpa018mincop         
         where AQPA018IPGCOD = vn_Pgcod       
         and AQPA018Itmod =   vn_Itmod                        
         and AQPA018Itsuc =   vn_Itsuc
         and AQPA018Ittran =  vn_Ittran        
         and AQPA018Itnrel =  vn_Itnrel
         and AQPA018Itfcon =  vd_Pgfape;
         commit;
         update AQPA018 set        
         AQPa018mSUMAC = AQPa018mpenac + AQPa018minmoc + AQPa018micvc + AQPa018mcapitc + AQPa018mseguc + AQPa018motroc + aqpa018mincoc         
         where AQPA018IPGCOD = vn_Pgcod       
         and AQPA018Itmod =   vn_Itmod                        
         and AQPA018Itsuc =   vn_Itsuc
         and AQPA018Ittran =  vn_Ittran        
         and AQPA018Itnrel =  vn_Itnrel
         and AQPA018Itfcon =  vd_Pgfape;
         commit;
         -- fin de cambios kdvc 13/11/2019 se modifico la suma en el total para que sume todo los campos que terminan en C
         -- kdvc 15/11/2019 actualiza los campos de la tabla detalle
         begin 
            select 
              AQPa018mpenac, 
              AQPa018minmoc,
              AQPa018micvc,  
              AQPa018mcapitc,
              AQPa018mseguc, 
              AQPa018motroc, 
              aqpa018mincoc, 
              AQPa018mSUMAC 
              into
              v_AQPa018mpenac, 
              v_AQPa018minmoc,
              v_AQPa018micvc,  
              v_AQPa018mcapitc,
              v_AQPa018mseguc, 
              v_AQPa018motroc, 
              v_aqpa018mincoc, 
              v_AQPa018mSUMAC            
             from  AQPA018
             where AQPA018IPGCOD = vn_Pgcod       
             and AQPA018Itmod =   vn_Itmod                        
             and AQPA018Itsuc =   vn_Itsuc
             and AQPA018Ittran =  vn_Ittran        
             and AQPA018Itnrel =  vn_Itnrel
             and AQPA018Itfcon =  vd_Pgfape;
             exception
          when others then
            v_AQPa018mpenac := 0;
              v_AQPa018minmoc := 0;
              v_AQPa018micvc := 0;
              v_AQPa018mcapitc := 0;
              v_AQPa018mseguc := 0;
              v_AQPa018motroc := 0; 
              v_aqpa018mincoc := 0; 
              v_AQPa018mSUMAC := 0;
         end;
           update jaqz893_aux set
           jaqz893auxcapit = v_AQPa018mcapitc,
           jaqz893auxinter  = v_aqpa018mincoc, 
           jaqz893auxsegur = v_AQPa018mseguc, 
           jaqz893auxicv   = v_AQPa018micvc,  
           jaqz893auxintmor = v_AQPa018minmoc,
           jaqz893auxpen   = v_AQPa018mpenac, 
           jaqz893auxmonto =  v_AQPa018mSUMAC                                
           where jaqz893auxpgct = vn_Pgcod  
           and jaqz893auxsuct = vn_Itsuc
           and jaqz893auxmodt = vn_Itmod  
           and  jaqz893auxtrxt =vn_Ittran 
           and  jaqz893auxrelt =vn_Itnrel
           and  jaqz893auxfect =vd_Pgfape;
          --fin de cambios kdvc 15/11/2019
         /* --se cambio con el update de arriba 
         if ( vn_Itmod=30 and vn_Ittran=111 ) then
           update jaqz893_aux set
           jaqz893auxcapit = jaqz893auxcapitd,
           jaqz893auxinter = jaqz893auxinterd ,
           jaqz893auxsegur = jaqz893auxsegurd ,
           jaqz893auxicv   = 0,
           jaqz893auxintmor = 0,
           jaqz893auxpen   = 0, --para todos los casos lo coloca en cero
           jaqz893auxmonto =jaqz893auxcapitd + jaqz893auxinterd + jaqz893auxsegurd
           where
               jaqz893auxpgct = vn_Pgcod  
           and jaqz893auxsuct = vn_Itsuc
           and jaqz893auxmodt = vn_Itmod  
           and  jaqz893auxtrxt =vn_Ittran 
           and  jaqz893auxrelt =vn_Itnrel
           and  jaqz893auxfect =vd_Pgfape;
         end if ;        
         if ( vn_Itmod=30 and vn_Ittran=122 ) then
           update jaqz893_aux set
           jaqz893auxcapit = jaqz893auxcapitd,
           jaqz893auxinter = jaqz893auxinterd ,
           jaqz893auxsegur = jaqz893auxsegurd ,
           jaqz893auxicv   = jaqz893auxicvd,
           jaqz893auxintmor = 0,
           jaqz893auxpen   = 0, --para todos los casos lo coloca en cero
           jaqz893auxmonto = jaqz893auxcapitd +jaqz893auxinterd + jaqz893auxsegurd + jaqz893auxicvd
           where
               jaqz893auxpgct = vn_Pgcod  
           and jaqz893auxsuct = vn_Itsuc
           and jaqz893auxmodt = vn_Itmod  
           and  jaqz893auxtrxt =vn_Ittran 
           and  jaqz893auxrelt =vn_Itnrel
           and  jaqz893auxfect =vd_Pgfape;
         end if ;  */
         commit;      
end sp_graba2;
--inicio kdvc 20/10/2020
procedure sp_graba3 ( vn_Pgcod in number, vn_Itsuc in number, vn_Itmod in number, vn_Ittran in number, vn_Itnrel in number, vn_Itord in number, 
    vn_Itsbor in number, vd_Pgfape date)
is
vn_capital number(17,2);
vn_seguros number(17,2);
vn_seguros_temp number(17,2);
vn_oro number(17,2);
vn_penalidad number(17,2);
vn_intmora number(17,2);
vn_icv number(17,2);
vn_intcompe number(17,2);
vn_capital_ref number(17,2);
vn_diferido number(17,2);
vn_diferidoc number(17,2);
vn_diferidoa number(17,2);
vn_montoefectivo number(17,2);
vn_SumOtros  number(17,2);
vn_montonointeres number(17,2);
lc_rubro number(16,0);
ln_AQPA018TIPCRE  varchar2(2);
ln_AQPA018DIAATR number(5,0);
ld_AQPA018FECINT date;
ln_AQPA018NROEXP char(20);
lc_AQPA018ACUPAG char (1);
lc_AQPA018DACUPAG  varchar2(50);
lc_AQPA018CANESP varchar2(200);
v_aqpa018hpgcod number(3); 
v_aqpa018hmodul number(3);
v_aqpa018htoper number(3);
v_aqpa018hsucur number(3);
v_aqpa018hmda number(4);
v_aqpa018hpap number(4);
v_aqpa018hcta number(9);
v_aqpa018hoper number(9);
v_aqpa018hsubop number(3);
ld_scfvto date;
ln_scstat number(2);
v_AQPa018mpenac number(17,2); 
v_AQPa018minmoc number(17,2);
v_AQPa018micvc number(17,2);
v_AQPa018mcapitc number(17,2);
v_AQPa018mseguc number(17,2);
v_AQPa018motroc number(17,2);
v_aqpa018mincoc number(17,2);
v_AQPa018mSUMAC number(17,2);

begin
       vn_diferido := 0;
       vn_diferidoc := 0;
       vn_diferidoa := 0;
       vn_montoefectivo:=0;
        vn_seguros_temp :=0;
       --obtengo los montos pagados pagados los que terminan en P
        begin
        select 
        sum(decode(tp1imp3,1,decode(tp1nro3,0,monto,0 ),2,decode(tp1nro3,0,monto2,0 ))) capital,
       -- sum(decode(tp1nro3,1,monto,0 )) seguros,
        sum(decode(tp1imp3,1,decode(tp1nro3,1,monto,0 ),2,decode(tp1nro3,1,monto2,0 ),3,decode(tp1nro3,1,monto3,0 ),4,decode(tp1nro3,1,monto4,0 ),5,decode(tp1nro3,1,monto5,0 ),6,decode(tp1nro3,1,monto6,0 ),7,decode(tp1nro3,1,monto7,0 ))) seguros,
        --sum(decode(tp1nro3,2,monto,0 )) oro,
        sum(decode(tp1imp3,1,decode(tp1nro3,2,monto,0 ),2,decode(tp1nro3,2,monto2,0 ),3,decode(tp1nro3,2,monto3,0 ),4,decode(tp1nro3,2,monto4,0 ),5,decode(tp1nro3,2,monto5,0 ),6,decode(tp1nro3,2,monto6,0 ),7,decode(tp1nro3,2,monto7,0 ))) oro,           
        --sum(decode(tp1nro3,3,monto,0 )) penalidad,       
        sum(decode(tp1imp3,1,decode(tp1nro3,3,monto,0 ),2,decode(tp1nro3,3,monto2,0 ),3,decode(tp1nro3,3,monto3,0 ),4,decode(tp1nro3,3,monto4,0 ),5,decode(tp1nro3,3,monto5,0 ),6,decode(tp1nro3,3,monto6,0 ),7,decode(tp1nro3,3,monto7,0 ))) penalidad,
        --sum(decode(tp1imp3,1,decode(tp1nro3,4,monto,0 ),4,decode(tp1nro3,4,monto4,0 ),12,decode(tp1nro3,4,monto12,0 ))) intmora,  
        sum(decode(tp1imp3,1,decode(tp1nro3,4,monto,0 ),2,decode(tp1nro3,4,monto2,0 ),3,decode(tp1nro3,4,monto3,0 ),4,decode(tp1nro3,4,monto4,0 ),5,decode(tp1nro3,4,monto5,0 ),6,decode(tp1nro3,4,monto6,0 ),7,decode(tp1nro3,4,monto7,0 ),12,decode(tp1nro3,4,monto12,0 ))) intmora,           
        --sum(decode(tp1imp3,1,decode(tp1nro3,5,monto,0 ),4,decode(tp1nro3,5,monto4,0 ),12,decode(tp1nro3,5,monto12,0 ))) icv,
        sum(decode(tp1imp3,1,decode(tp1nro3,5,monto,0 ),2,decode(tp1nro3,5,monto2,0 ),3,decode(tp1nro3,5,monto3,0 ),4,decode(tp1nro3,5,monto4,0 ),5,decode(tp1nro3,5,monto5,0 ),6,decode(tp1nro3,5,monto6,0 ),7,decode(tp1nro3,5,monto7,0 ),12,decode(tp1nro3,5,monto12,0 ))) icv,           
        --sum(decode(tp1nro3,6,monto,0 )) intcompe,
        sum(decode(tp1imp3,1,decode(tp1nro3,6,monto,0 ),2,decode(tp1nro3,6,monto2,0 ),3,decode(tp1nro3,6,monto3,0 ),4,decode(tp1nro3,6,monto4,0 ),5,decode(tp1nro3,6,monto5,0 ),6,decode(tp1nro3,6,monto6,0 ),7,decode(tp1nro3,6,monto7,0 ))) intcompe,           
        sum(decode(tp1nro3,7,monto,0 )) capital_ref,
        sum(decode(tp1nro3,8,monto,0 )) diferido_consolidado,
        sum(decode(tp1nro3,9,monto,0 )) diferido_anterior,
        sum(decode(tp1nro3,10,monto,0 )) monto_efectivo,
        sum(decode(tp1nro3,11,monto,0 )) monto_nointeres
        into vn_capital,vn_seguros,vn_oro,vn_penalidad,vn_intmora,vn_icv,vn_intcompe,vn_capital_ref, vn_diferidoc,vn_diferidoa,vn_montoefectivo, vn_montonointeres
        from
        (select g.tp1nro3,h.itmod,h.ittran,h.itsuc,h.itnrel,itfcon as f_pag,
        sum(h.itimp1) monto,g.tp1imp3, 
        sum(h.itimp4) monto4, 
        sum(h.itimp12) monto12,
        sum(h.itimp2) monto2,--sum(h.itimp1) monto 
        sum(h.itimp3) monto3,
        sum(h.itimp5) monto5,
        sum(h.itimp6) monto6,
        sum(h.itimp7) monto7       
        from
        fsd016 h
        inner join fst198 g
          on h.itord=g.tp1nro1
          and g.tp1cod=1
          and g.tp1cod1=11105
          and g.tp1corr1=10
          and g.tp1corr2=3   --- solo para modulo y transacciones de exoneraciones
          and g.tp1imp1 = h.itmod
          and g.tp1imp2 = h.ittran
        inner join fsd015 f
          on  f.pgcod=h.pgcod
          and f.itsuc=h.itsuc
          and f.itmod=h.itmod
          and f.ittran=h.ittran
          and f.itnrel=h.itnrel
        where f.pgcod=vn_Pgcod
        and f.itsuc=vn_Itsuc
        and f.itmod=vn_Itmod        
        and f.ittran=vn_Ittran        
        and f.itnrel=vn_Itnrel
        --and f.itcont='S'
        --and f.itcorr=0
        group by g.tp1nro3,h.itmod,h.ittran,h.itsuc,h.itnrel,f.itfcon,f.itfvc,g.tp1imp3)      
        group by f_pag,itmod,ittran,itsuc,itnrel;
      EXCEPTION
            when others then
          vn_capital:=0;
          vn_seguros:=0;
          vn_oro:=0;
          vn_penalidad:=0;
          vn_intmora:=0;
          vn_icv:=0;
          vn_intcompe:=0;
          vn_capital_ref:=0;
          vn_diferidoc:= 0;
          vn_diferidoa:=0;
          vn_montoefectivo:=0;
        end;
        vn_intcompe:= vn_intcompe-vn_montonointeres;
        vn_diferido := vn_diferidoc - vn_diferidoa;
        if ( vn_diferido < 0 ) then
          vn_diferido :=0;
        end if;        
        if ( vn_montoefectivo = 0 )then --si no hay monto pagado en efectivo entonces coloco en cero el seguro y capital
          vn_capital:=0;
          vn_seguros:=0;
        else
          --159.21  si hay direferncia  1  que sibre que pago el cliente 
          ---primero sumo os otros conceptos 1559.28  si el monto que esta pagado le resto  los otros conpcetos, lo que queda lo compara con el seguro.
          --calulo primero seguro
          vn_SumOtros := vn_oro + vn_penalidad + vn_intmora + vn_icv+ vn_intcompe ;
          if vn_montoefectivo > 0 then
            if ( vn_SumOtros > vn_montoefectivo or vn_SumOtros=vn_montoefectivo) then --vn_montoefectivo < vn_seguros and vn_montoefectivo > 0
              vn_seguros := 0;           --vn_seguros := vn_montoefectivo;
            else
              vn_seguros_temp := vn_montoefectivo - vn_SumOtros; 
              if ( vn_seguros_temp < vn_seguros ) then
                vn_seguros := vn_seguros_temp;                       
              end if;
            end if;
          end if;
          --luego calculo capital
          vn_SumOtros := vn_seguros + vn_oro + vn_penalidad + vn_intmora + vn_icv+ vn_intcompe ;
          if ( vn_montoefectivo > 0 ) then
            if ( vn_SumOtros < vn_montoefectivo ) then
               vn_capital := vn_montoefectivo - vn_SumOtros;          
            else
               if ( vn_SumOtros > vn_montoefectivo or vn_SumOtros = vn_montoefectivo  ) then
                  vn_capital:=0;
               end if;
            end if;
          end if;

        end if;
        
        
        --obtengo los montos condonados los que terminan en C
        v_AQPa018mcapitc :=0;
        v_AQPa018mseguc :=0;
        v_AQPa018motroc :=0;
        v_AQPa018mpenac :=0; 
        v_AQPa018minmoc:=0;
        v_AQPa018micvc :=0;                       
        v_aqpa018mincoc:=0;
        begin
        select 
        sum(decode(tp1imp3,1,decode(tp1nro3,0,monto,0 ),2,decode(tp1nro3,0,monto2,0 ),3,decode(tp1nro3,0,monto3,0 ),16,decode(tp1nro3,0,monto16,0 ))) capital,--0
        --sum(decode(tp1nro3,1,monto,0 )) seguros,
        sum(decode(tp1imp3,1,decode(tp1nro3,1,monto,0 ),2,decode(tp1nro3,1,monto2,0 ),3,decode(tp1nro3,1,monto3,0 ),4,decode(tp1nro3,1,monto4,0 ),5,decode(tp1nro3,1,monto5,0 ),6,decode(tp1nro3,1,monto6,0 ),7,decode(tp1nro3,1,monto7,0 ),18,decode(tp1nro3,1,monto18,0 ))) seguros,
        --sum(decode(tp1nro3,2,monto,0 )) oro,
        sum(decode(tp1imp3,1,decode(tp1nro3,2,monto,0 ),2,decode(tp1nro3,2,monto2,0 ),3,decode(tp1nro3,2,monto3,0 ),4,decode(tp1nro3,2,monto4,0 ),5,decode(tp1nro3,2,monto5,0 ),6,decode(tp1nro3,2,monto6,0 ),7,decode(tp1nro3,2,monto7,0 ))) oro,           
        --sum(decode(tp1imp3,1,decode(tp1nro3,3,monto,0 ),19,decode(tp1nro3,3,monto19,0 ),20,decode(tp1nro3,3,monto20,0 ))) penalidad, -- 3      
        sum(decode(tp1imp3,1,decode(tp1nro3,3,monto,0 ),2,decode(tp1nro3,3,monto2,0 ),3,decode(tp1nro3,3,monto3,0 ),4,decode(tp1nro3,3,monto4,0 ),5,decode(tp1nro3,3,monto5,0 ),6,decode(tp1nro3,3,monto6,0 ),7,decode(tp1nro3,3,monto7,0 ),19,decode(tp1nro3,3,monto19,0 ),20,decode(tp1nro3,3,monto20,0 ))) penalidad,
        --sum(decode(tp1imp3,1,decode(tp1nro3,4,monto,0 ),18,decode(tp1nro3,4,monto18,0 ),19,decode(tp1nro3,4,monto19,0 ))) intmora, -- 4  
        sum(decode(tp1imp3,1,decode(tp1nro3,4,monto,0 ),2,decode(tp1nro3,4,monto2,0 ),3,decode(tp1nro3,4,monto3,0 ),4,decode(tp1nro3,4,monto4,0 ),5,decode(tp1nro3,4,monto5,0 ),6,decode(tp1nro3,4,monto6,0 ),7,decode(tp1nro3,4,monto7,0 ),18,decode(tp1nro3,4,monto18,0 ),19,decode(tp1nro3,4,monto19,0 ))) intmora,               
        --sum(decode(tp1imp3,1,decode(tp1nro3,5,monto,0 ),20,decode(tp1nro3,5,monto20,0 ),19,decode(tp1nro3,5,monto19,0 ))) icv,---5
        sum(decode(tp1imp3,1,decode(tp1nro3,5,monto,0 ),2,decode(tp1nro3,5,monto2,0 ),3,decode(tp1nro3,5,monto3,0 ),4,decode(tp1nro3,5,monto4,0 ),5,decode(tp1nro3,5,monto5,0 ),6,decode(tp1nro3,5,monto6,0 ),7,decode(tp1nro3,5,monto7,0 ),19,decode(tp1nro3,5,monto19,0 ),20,decode(tp1nro3,5,monto20,0 ))) icv,           
        --sum(decode(tp1imp3,1,decode(tp1nro3,6,monto,0 ),17,decode(tp1nro3,6,monto17,0 ),18,decode(tp1nro3,6,monto18,0 ))) intcompe ---6
        sum(decode(tp1imp3,1,decode(tp1nro3,6,monto,0 ),2,decode(tp1nro3,6,monto2,0 ),3,decode(tp1nro3,6,monto3,0 ),4,decode(tp1nro3,6,monto4,0 ),5,decode(tp1nro3,6,monto5,0 ),6,decode(tp1nro3,6,monto6,0 ),7,decode(tp1nro3,6,monto7,0 ),17,decode(tp1nro3,6,monto17,0 ),18,decode(tp1nro3,6,monto18,0 ),19,decode(tp1nro3,6,monto19,0 ))) intcompe          
        into v_AQPa018mcapitc,v_AQPa018mseguc,v_AQPa018motroc,v_AQPa018mpenac,v_AQPa018minmoc,v_AQPa018micvc,v_aqpa018mincoc
        from
        (select g.tp1nro3,h.itmod,h.ittran,h.itsuc,h.itnrel,itfcon as f_pag,
        sum(h.itimp1) monto,--importe1
        g.tp1imp3,
        sum(h.itimp2) monto2,
        sum(h.itimp3) monto3,
        sum(h.itimp4) monto4,
        sum(h.itimp5) monto5,
        sum(h.itimp6) monto6,
        sum(h.itimp7) monto7,
        sum(h.itimp8) monto8,
        sum(h.itimp9) monto9,
        sum(h.itimp10) monto10,        
        sum(h.itimp16) monto16, 
        sum(h.itimp17) monto17,
        sum(h.itimp18) monto18,
        sum(h.itimp19) monto19,
        sum(h.itimp20) monto20
        from
        fsd016 h
        inner join fst198 g
          on h.itord=g.tp1nro1
          and g.tp1cod=1
          and g.tp1cod1=11105
          and g.tp1corr1=10
          and g.tp1corr2=4   --- solo para refinanciados
          and g.tp1imp1 = h.itmod
          and g.tp1imp2 = h.ittran
        inner join fsd015 f
          on  f.pgcod=h.pgcod
          and f.itsuc=h.itsuc
          and f.itmod=h.itmod
          and f.ittran=h.ittran
          and f.itnrel=h.itnrel
        where f.pgcod=vn_Pgcod
        and f.itsuc=vn_Itsuc
        and f.itmod=vn_Itmod        
        and f.ittran=vn_Ittran        
        and f.itnrel=vn_Itnrel
        --and f.itcont='S'
        --and f.itcorr=0
        group by g.tp1nro3,h.itmod,h.ittran,h.itsuc,h.itnrel,f.itfcon,f.itfvc,g.tp1imp3)      
        group by f_pag,itmod,ittran,itsuc,itnrel;
      EXCEPTION
            when others then
          v_AQPa018mpenac :=0; 
          v_AQPa018minmoc:=0;
          v_AQPa018micvc :=0;
          v_AQPa018mcapitc :=0;
          v_AQPa018mseguc :=0;
          v_AQPa018motroc :=0;
          v_aqpa018mincoc:=0;
        end;
        
        begin
          select rubro into lc_rubro from fsd016 f where f.pgcod=vn_Pgcod
          and f.itsuc=vn_Itsuc
          and f.itmod=vn_Itmod        
          and f.ittran=vn_Ittran        
          and f.itnrel=vn_Itnrel
          and f.itord = 10;
        exception
         when no_data_found then
          lc_rubro:= 0;
        end; 
          
        --obtengo la clave del credito
        Begin
        select aqpa018hpgcod, 
        aqpa018hmodul,
        aqpa018htoper,
        aqpa018hsucur,
        aqpa018hmda,
        aqpa018hpap, 
        aqpa018hcta,
        aqpa018hoper,
        aqpa018hsubop into
        v_aqpa018hpgcod,
        v_aqpa018hmodul,
        v_aqpa018htoper,
        v_aqpa018hsucur,
        v_aqpa018hmda,
        v_aqpa018hpap,
        v_aqpa018hcta,
        v_aqpa018hoper,
        v_aqpa018hsubop
        from AQPA018 a
         where AQPA018IPGCOD = vn_Pgcod       
         and AQPA018Itmod = vn_Itmod                        
         and AQPA018Itsuc = vn_Itsuc
         and AQPA018Ittran = vn_Ittran        
         and AQPA018Itnrel = vn_Itnrel
         and AQPA018Itfcon = vd_Pgfape;
         exception
        when others then
          NULL;
        end; 
        Begin
          select aofvto/*,aostat*/ into ld_scfvto/*,ln_scstat*/  from fsd010 f 
          where f.pgcod=v_aqpa018hpgcod 
          and f.aomod=  v_aqpa018hmodul 
          and f.aosuc=  v_aqpa018hsucur 
          and f.aomda=  v_aqpa018hmda 
          and f.aopap=  v_aqpa018hpap 
          and f.aocta=  v_aqpa018hcta
          and f.aooper= v_aqpa018hoper 
          and f.aotope= v_aqpa018htoper
          and f.aosbop= v_aqpa018hsubop;
         exception
         when others then
           null;
         end;
        begin
        select t.jaqm33fint, t.jaqm33nexp
        into ld_AQPA018FECINT, ln_AQPA018NROEXP
        from jaqm33 t, jaqm27 j
        where j.jaqm27pgc = v_aqpa018hpgcod
         and j.jaqm27mod = v_aqpa018hmodul
         and j.jaqm27suc = v_aqpa018hsucur
         and j.jaqm27mda = v_aqpa018hmda
         and j.jaqm27pap = v_aqpa018hpap
         and j.jaqm27cta = v_aqpa018hcta
         and j.jaqm27oper = v_aqpa018hoper
         and j.jaqm27sbop = v_aqpa018hsubop
         and j.jaqm27tope = v_aqpa018htoper
         and j.jaqm33cor = t.jaqm33cor;
         exception
        when others then
          NULL;
        end;
        begin
          SELECT s.JAQL165COM
            into lc_AQPA018ACUPAG
            FROM (select * from JAQL165 T
         where t.jaql165emp = v_aqpa018hpgcod
           and t.jaql165suc = v_aqpa018hsucur
           and t.jaql165mda = v_aqpa018hmda
           and t.jaql165pap = v_aqpa018hpap
           and t.jaql165cta = v_aqpa018hcta
           and t.jaql165ope = v_aqpa018hoper
           and t.jaql165sbo = v_aqpa018hsubop
           and t.jaql165top = v_aqpa018htoper
           and t.jaql165mod = v_aqpa018hmodul           
           order by  t.jaql165corr desc) s
           where rownum=1;        
        exception
          when others then
            NULL;
        end;
      
        if lc_AQPA018ACUPAG = 'P' then
          lc_AQPA018DACUPAG := 'Cancelacion Especial Parcial';
        elsif lc_AQPA018ACUPAG = 'D' then
          lc_AQPA018DACUPAG := 'De pago';
        elsif lc_AQPA018ACUPAG = 'T' then
          lc_AQPA018DACUPAG := 'Cancelacion Especial Total';
        elsif lc_AQPA018ACUPAG = 'N' then
          lc_AQPA018DACUPAG := 'Ninguna';
        end if;
         ---cancelación especial        
        begin
        SELECT s.JAQL165TEX
            into lc_AQPA018CANESP
            FROM (select * from JAQL165 T
            where t.jaql165emp = v_aqpa018hpgcod
             and t.jaql165suc = v_aqpa018hsucur
             and t.jaql165mda = v_aqpa018hmda
             and t.jaql165pap = v_aqpa018hpap
             and t.jaql165cta = v_aqpa018hcta
             and t.jaql165ope = v_aqpa018hoper
             and t.jaql165sbo = v_aqpa018hsubop
             and t.jaql165top = v_aqpa018htoper
             and t.jaql165mod = v_aqpa018hmodul
             and t.jaql165com in ('T','P')
             order by t.jaql165corr desc) s 
             where rownum=1;
         exception
          when others then
            NULL;
         end;
        -- tipo de credito
        ln_AQPA018TIPCRE := substr(lc_rubro,5,2);
        --se debe insertar estos montos en la tabla estos son los montos Condonados
        update AQPA018 set 
          AQPa018mcapip=vn_capital, 
          AQPa018msegup=vn_seguros, 
          AQPa018motrop=vn_oro ,
          AQPa018mpenap=vn_penalidad, 
          AQPa018minmop=vn_intmora,
          AQPa018micvp=vn_icv, 
          aqpa018mincop=vn_intcompe,
          aqpa018mcapref=vn_capital_ref, 
          aqpa018mdif= vn_diferido,
          AQPa018hrubroc = lc_rubro, ---ESTO PREGUNTAR SI ESTA BIEN ESE RUBRO DE LA TRANSACCION DE PAGO
          AQPA018TIPCRE = ln_AQPA018TIPCRE,
          AQPA018FECINT = ld_AQPA018FECINT,
          AQPA018NROEXP = ln_AQPA018NROEXP,
          AQPA018ACUPAG = lc_AQPA018ACUPAG,
          AQPA018DACUPAG = lc_AQPA018DACUPAG,
          AQPA018CANESP = lc_AQPA018CANESP
        where AQPA018IPGCOD = vn_Pgcod       
         and AQPA018Itmod =   vn_Itmod                        
         and AQPA018Itsuc =   vn_Itsuc
         and AQPA018Ittran =  vn_Ittran        
         and AQPA018Itnrel =  vn_Itnrel
         and AQPA018Itfcon =  vd_Pgfape;
         commit;
        --se adiciono este update kdvc 13/11/2019 para que calcule todos los campos C
         update AQPA018 set
         AQPa018mpenac = v_AQPa018mpenac,  --                AQPa018mpenad - AQPa018mpenap, --solo se actualiza estos montos porque son los exonerados por estas transacciones
         AQPa018minmoc = v_AQPa018minmoc,   --             AQPa018minmod - AQPa018minmop,  --exonerado por la transaccion 30/111  o 30/122
         AQPa018micvc  = v_AQPa018micvc,  --          AQPa018micvd - AQPa018micvp,    ---exonerado solo por la transaccion 30/111 
         AQPa018mcapitc =v_AQPa018mcapitc,  --                AQPa018mcapitd - AQPa018mcapip - AQPa018mcapref, 
         AQPa018mseguc = v_AQPa018mseguc,   --               AQPa018msegud - AQPa018msegup , 
         AQPa018motroc = v_AQPa018motroc,   --               AQPa018motrod - AQPa018motrop,
         aqpa018mincoc = v_aqpa018mincoc   --              aqpa018mincod - aqpa018mincop         
         where AQPA018IPGCOD = vn_Pgcod       
         and AQPA018Itmod =   vn_Itmod                        
         and AQPA018Itsuc =   vn_Itsuc
         and AQPA018Ittran =  vn_Ittran        
         and AQPA018Itnrel =  vn_Itnrel
         and AQPA018Itfcon =  vd_Pgfape;
         commit;
         update AQPA018 set        
         AQPa018mSUMAC = AQPa018mpenac + AQPa018minmoc + AQPa018micvc + AQPa018mcapitc + AQPa018mseguc + AQPa018motroc + aqpa018mincoc         
         where AQPA018IPGCOD = vn_Pgcod       
         and AQPA018Itmod =   vn_Itmod                        
         and AQPA018Itsuc =   vn_Itsuc
         and AQPA018Ittran =  vn_Ittran        
         and AQPA018Itnrel =  vn_Itnrel
         and AQPA018Itfcon =  vd_Pgfape;
         commit;
         
         begin 
            select 
              AQPa018mpenac, 
              AQPa018minmoc,
              AQPa018micvc,  
              AQPa018mcapitc,
              AQPa018mseguc, 
              AQPa018motroc, 
              aqpa018mincoc, 
              AQPa018mSUMAC 
              into
              v_AQPa018mpenac, 
              v_AQPa018minmoc,
              v_AQPa018micvc,  
              v_AQPa018mcapitc,
              v_AQPa018mseguc, 
              v_AQPa018motroc, 
              v_aqpa018mincoc, 
              v_AQPa018mSUMAC            
             from  AQPA018
             where AQPA018IPGCOD = vn_Pgcod       
             and AQPA018Itmod =   vn_Itmod                        
             and AQPA018Itsuc =   vn_Itsuc
             and AQPA018Ittran =  vn_Ittran        
             and AQPA018Itnrel =  vn_Itnrel
             and AQPA018Itfcon =  vd_Pgfape;
             exception
          when others then
            v_AQPa018mpenac := 0;
              v_AQPa018minmoc := 0;
              v_AQPa018micvc := 0;
              v_AQPa018mcapitc := 0;
              v_AQPa018mseguc := 0;
              v_AQPa018motroc := 0; 
              v_aqpa018mincoc := 0; 
              v_AQPa018mSUMAC := 0;
         end;
           update jaqz893_aux set
           jaqz893auxcapit = v_AQPa018mcapitc,
           jaqz893auxinter  = v_aqpa018mincoc, 
           jaqz893auxsegur = v_AQPa018mseguc, 
           jaqz893auxicv   = v_AQPa018micvc,  
           jaqz893auxintmor = v_AQPa018minmoc,
           jaqz893auxpen   = v_AQPa018mpenac, 
           jaqz893auxmonto =  v_AQPa018mSUMAC                                
           where jaqz893auxpgct = vn_Pgcod  
           and jaqz893auxsuct = vn_Itsuc
           and jaqz893auxmodt = vn_Itmod  
           and  jaqz893auxtrxt =vn_Ittran 
           and  jaqz893auxrelt =vn_Itnrel
           and  jaqz893auxfect =vd_Pgfape;     
         commit;      
end sp_graba3;
--fin kdvc 20/10/2020
--inicio kdvc 23/08/2021
procedure sp_graba4 ( vn_Pgcod in number, vn_Itsuc in number, vn_Itmod in number, vn_Ittran in number, vn_Itnrel in number, vn_Itord in number, 
    vn_Itsbor in number, vd_Pgfape date)
is
vn_capital number(17,2);
vn_seguros number(17,2);
vn_seguros_temp number(17,2);
vn_oro number(17,2);
vn_penalidad number(17,2);
vn_intmora number(17,2);
vn_icv number(17,2);
vn_intcompe number(17,2);
lc_rubro number(16,0);
ln_AQPA018TIPCRE  varchar2(2);
ln_AQPA018DIAATR number(5,0);
ld_AQPA018FECINT date;
ln_AQPA018NROEXP char(20);
lc_AQPA018ACUPAG char (1);
lc_AQPA018DACUPAG  varchar2(50);
lc_AQPA018CANESP varchar2(200);
v_aqpa018hpgcod number(3); 
v_aqpa018hmodul number(3);
v_aqpa018htoper number(3);
v_aqpa018hsucur number(3);
v_aqpa018hmda number(4);
v_aqpa018hpap number(4);
v_aqpa018hcta number(9);
v_aqpa018hoper number(9);
v_aqpa018hsubop number(3);
ld_scfvto date;
ln_scstat number(2);
v_AQPa018mpenac number(17,2); 
v_AQPa018minmoc number(17,2);
v_AQPa018micvc number(17,2);
v_AQPa018mcapitc number(17,2);
v_AQPa018mseguc number(17,2);
v_AQPa018motroc number(17,2);
v_aqpa018mincoc number(17,2);
v_AQPa018mSUMAC number(17,2);
vn_existe number(1);
begin
  vn_capital :=0;
  vn_seguros :=0;
  vn_oro :=0;
  vn_penalidad :=0;
  vn_intmora :=0;
  vn_icv :=0;
  vn_intcompe :=0;
  
  --inicio kvalenciac 25/05/2023
  vn_existe:=0;
  begin
   Select 1 into vn_existe from fst198 where Tp1cod=1 and Tp1cod1  = 11105 and Tp1corr1 = 10 and Tp1corr2 = 6 and tp1imp1=vn_Itmod and tp1imp2=vn_Ittran;
  exception when others then
    vn_existe:=0;
  end;
  if (vn_existe=1) then
  --fin kvalenciac 25/05/2023  
        --obtengo los montos pagados pagados los que terminan en P
        begin
        select 
        sum(decode(tp1imp3,1,decode(tp1nro3,0,monto,0 ),2,decode(tp1nro3,0,monto2,0 ))) capital,
       -- sum(decode(tp1nro3,1,monto,0 )) seguros,
        sum(decode(tp1imp3,1,decode(tp1nro3,1,monto,0 ),2,decode(tp1nro3,1,monto2,0 ),3,decode(tp1nro3,1,monto3,0 ),4,decode(tp1nro3,1,monto4,0 ),5,decode(tp1nro3,1,monto5,0 ),6,decode(tp1nro3,1,monto6,0 ),7,decode(tp1nro3,1,monto7,0 ))) seguros,
        --sum(decode(tp1nro3,2,monto,0 )) oro,
        sum(decode(tp1imp3,1,decode(tp1nro3,2,monto,0 ),2,decode(tp1nro3,2,monto2,0 ),3,decode(tp1nro3,2,monto3,0 ),4,decode(tp1nro3,2,monto4,0 ),5,decode(tp1nro3,2,monto5,0 ),6,decode(tp1nro3,2,monto6,0 ),7,decode(tp1nro3,2,monto7,0 ))) oro,           
        --sum(decode(tp1nro3,3,monto,0 )) penalidad,       
        sum(decode(tp1imp3,1,decode(tp1nro3,3,monto,0 ),2,decode(tp1nro3,3,monto2,0 ),3,decode(tp1nro3,3,monto3,0 ),4,decode(tp1nro3,3,monto4,0 ),5,decode(tp1nro3,3,monto5,0 ),6,decode(tp1nro3,3,monto6,0 ),7,decode(tp1nro3,3,monto7,0 ))) penalidad,
        --sum(decode(tp1imp3,1,decode(tp1nro3,4,monto,0 ),4,decode(tp1nro3,4,monto4,0 ),12,decode(tp1nro3,4,monto12,0 ))) intmora,  
        sum(decode(tp1imp3,1,decode(tp1nro3,4,monto,0 ),2,decode(tp1nro3,4,monto2,0 ),3,decode(tp1nro3,4,monto3,0 ),4,decode(tp1nro3,4,monto4,0 ),5,decode(tp1nro3,4,monto5,0 ),6,decode(tp1nro3,4,monto6,0 ),7,decode(tp1nro3,4,monto7,0 ),12,decode(tp1nro3,4,monto12,0 ))) intmora,           
        --sum(decode(tp1imp3,1,decode(tp1nro3,5,monto,0 ),4,decode(tp1nro3,5,monto4,0 ),12,decode(tp1nro3,5,monto12,0 ))) icv,
        sum(decode(tp1imp3,1,decode(tp1nro3,5,monto,0 ),2,decode(tp1nro3,5,monto2,0 ),3,decode(tp1nro3,5,monto3,0 ),4,decode(tp1nro3,5,monto4,0 ),5,decode(tp1nro3,5,monto5,0 ),6,decode(tp1nro3,5,monto6,0 ),7,decode(tp1nro3,5,monto7,0 ),12,decode(tp1nro3,5,monto12,0 ))) icv,           
        --sum(decode(tp1nro3,6,monto,0 )) intcompe,
        sum(decode(tp1imp3,1,decode(tp1nro3,6,monto,0 ),2,decode(tp1nro3,6,monto2,0 ),3,decode(tp1nro3,6,monto3,0 ),4,decode(tp1nro3,6,monto4,0 ),5,decode(tp1nro3,6,monto5,0 ),6,decode(tp1nro3,6,monto6,0 ),7,decode(tp1nro3,6,monto7,0 ))) intcompe
 
        into vn_capital,vn_seguros,vn_oro,vn_penalidad,vn_intmora,vn_icv,vn_intcompe
        from
        (select g.tp1nro3,h.itmod,h.ittran,h.itsuc,h.itnrel,itfcon as f_pag,
        sum(h.itimp1) monto,g.tp1imp3, 
        sum(h.itimp4) monto4, 
        sum(h.itimp12) monto12,
        sum(h.itimp2) monto2,--sum(h.itimp1) monto 
        sum(h.itimp3) monto3,
        sum(h.itimp5) monto5,
        sum(h.itimp6) monto6,
        sum(h.itimp7) monto7       
        from
        fsd016 h
        inner join fst198 g
          on h.itord=g.tp1nro1
          and g.tp1cod=1
          and g.tp1cod1=11105
          and g.tp1corr1=10
          and g.tp1corr2=6   --- solo para modulo y transacciones de exoneraciones
          and g.tp1imp1 = h.itmod
          and g.tp1imp2 = h.ittran
        inner join fsd015 f
          on  f.pgcod=h.pgcod
          and f.itsuc=h.itsuc
          and f.itmod=h.itmod
          and f.ittran=h.ittran
          and f.itnrel=h.itnrel
        where f.pgcod=vn_Pgcod
        and f.itsuc=vn_Itsuc
        and f.itmod=vn_Itmod        
        and f.ittran=vn_Ittran        
        and f.itnrel=vn_Itnrel
        --and f.itcont='S'
        --and f.itcorr=0
        group by g.tp1nro3,h.itmod,h.ittran,h.itsuc,h.itnrel,f.itfcon,f.itfvc,g.tp1imp3)      
        group by f_pag,itmod,ittran,itsuc,itnrel;
      EXCEPTION
            when others then
          vn_capital:=0;
          vn_seguros:=0;
          vn_oro:=0;
          vn_penalidad:=0;
          vn_intmora:=0;
          vn_icv:=0;
          vn_intcompe:=0;                 
        end;
   end if; -- kvalenciac 25/05/2023
        --obtengo los montos condonados los que terminan en C
        v_AQPa018mcapitc :=0;
        v_AQPa018mseguc :=0;
        v_AQPa018motroc :=0;
        v_AQPa018mpenac :=0; 
        v_AQPa018minmoc:=0;
        v_AQPa018micvc :=0;                       
        v_aqpa018mincoc:=0;
        begin
        select 
        sum(decode(tp1imp3,1,decode(tp1nro3,0,monto,0 ),2,decode(tp1nro3,0,monto2,0 ),3,decode(tp1nro3,0,monto3,0 ),16,decode(tp1nro3,0,monto16,0 ))) capital,--0
        --sum(decode(tp1nro3,1,monto,0 )) seguros,
        sum(decode(tp1imp3,1,decode(tp1nro3,1,monto,0 ),2,decode(tp1nro3,1,monto2,0 ),3,decode(tp1nro3,1,monto3,0 ),4,decode(tp1nro3,1,monto4,0 ),5,decode(tp1nro3,1,monto5,0 ),6,decode(tp1nro3,1,monto6,0 ),7,decode(tp1nro3,1,monto7,0 ),18,decode(tp1nro3,1,monto18,0 ))) seguros,
        --sum(decode(tp1nro3,2,monto,0 )) oro,
        sum(decode(tp1imp3,1,decode(tp1nro3,2,monto,0 ),2,decode(tp1nro3,2,monto2,0 ),3,decode(tp1nro3,2,monto3,0 ),4,decode(tp1nro3,2,monto4,0 ),5,decode(tp1nro3,2,monto5,0 ),6,decode(tp1nro3,2,monto6,0 ),7,decode(tp1nro3,2,monto7,0 ))) oro,           
        --sum(decode(tp1imp3,1,decode(tp1nro3,3,monto,0 ),19,decode(tp1nro3,3,monto19,0 ),20,decode(tp1nro3,3,monto20,0 ))) penalidad, -- 3      
        sum(decode(tp1imp3,1,decode(tp1nro3,3,monto,0 ),2,decode(tp1nro3,3,monto2,0 ),3,decode(tp1nro3,3,monto3,0 ),4,decode(tp1nro3,3,monto4,0 ),5,decode(tp1nro3,3,monto5,0 ),6,decode(tp1nro3,3,monto6,0 ),7,decode(tp1nro3,3,monto7,0 ),19,decode(tp1nro3,3,monto19,0 ),20,decode(tp1nro3,3,monto20,0 ))) penalidad,
        --sum(decode(tp1imp3,1,decode(tp1nro3,4,monto,0 ),18,decode(tp1nro3,4,monto18,0 ),19,decode(tp1nro3,4,monto19,0 ))) intmora, -- 4  
        sum(decode(tp1imp3,1,decode(tp1nro3,4,monto,0 ),2,decode(tp1nro3,4,monto2,0 ),3,decode(tp1nro3,4,monto3,0 ),4,decode(tp1nro3,4,monto4,0 ),5,decode(tp1nro3,4,monto5,0 ),6,decode(tp1nro3,4,monto6,0 ),7,decode(tp1nro3,4,monto7,0 ),18,decode(tp1nro3,4,monto18,0 ),19,decode(tp1nro3,4,monto19,0 ))) intmora,               
        --sum(decode(tp1imp3,1,decode(tp1nro3,5,monto,0 ),20,decode(tp1nro3,5,monto20,0 ),19,decode(tp1nro3,5,monto19,0 ))) icv,---5
        sum(decode(tp1imp3,1,decode(tp1nro3,5,monto,0 ),2,decode(tp1nro3,5,monto2,0 ),3,decode(tp1nro3,5,monto3,0 ),4,decode(tp1nro3,5,monto4,0 ),5,decode(tp1nro3,5,monto5,0 ),6,decode(tp1nro3,5,monto6,0 ),7,decode(tp1nro3,5,monto7,0 ),19,decode(tp1nro3,5,monto19,0 ),20,decode(tp1nro3,5,monto20,0 ))) icv,           
        --sum(decode(tp1imp3,1,decode(tp1nro3,6,monto,0 ),17,decode(tp1nro3,6,monto17,0 ),18,decode(tp1nro3,6,monto18,0 ))) intcompe ---6
        sum(decode(tp1imp3,1,decode(tp1nro3,6,monto,0 ),2,decode(tp1nro3,6,monto2,0 ),3,decode(tp1nro3,6,monto3,0 ),4,decode(tp1nro3,6,monto4,0 ),5,decode(tp1nro3,6,monto5,0 ),6,decode(tp1nro3,6,monto6,0 ),7,decode(tp1nro3,6,monto7,0 ),17,decode(tp1nro3,6,monto17,0 ),18,decode(tp1nro3,6,monto18,0 ),19,decode(tp1nro3,6,monto19,0 ))) intcompe          
        into v_AQPa018mcapitc,v_AQPa018mseguc,v_AQPa018motroc,v_AQPa018mpenac,v_AQPa018minmoc,v_AQPa018micvc,v_aqpa018mincoc
        from
        (select g.tp1nro3,h.itmod,h.ittran,h.itsuc,h.itnrel,itfcon as f_pag,
        sum(h.itimp1) monto,--importe1
        g.tp1imp3,
        sum(h.itimp2) monto2,
        sum(h.itimp3) monto3,
        sum(h.itimp4) monto4,
        sum(h.itimp5) monto5,
        sum(h.itimp6) monto6,
        sum(h.itimp7) monto7,
        sum(h.itimp8) monto8,
        sum(h.itimp9) monto9,
        sum(h.itimp10) monto10,        
        sum(h.itimp16) monto16, 
        sum(h.itimp17) monto17,
        sum(h.itimp18) monto18,
        sum(h.itimp19) monto19,
        sum(h.itimp20) monto20
        from
        fsd016 h
        inner join fst198 g
          on h.itord=g.tp1nro1
          and g.tp1cod=1
          and g.tp1cod1=11105
          and g.tp1corr1=10
          and g.tp1corr2=5   --- solo para refinanciados --23/08/2021
          and g.tp1imp1 = h.itmod
          and g.tp1imp2 = h.ittran
        inner join fsd015 f
          on  f.pgcod=h.pgcod
          and f.itsuc=h.itsuc
          and f.itmod=h.itmod
          and f.ittran=h.ittran
          and f.itnrel=h.itnrel
        where f.pgcod=vn_Pgcod
        and f.itsuc=vn_Itsuc
        and f.itmod=vn_Itmod        
        and f.ittran=vn_Ittran        
        and f.itnrel=vn_Itnrel
        --and f.itcont='S'
        --and f.itcorr=0
        group by g.tp1nro3,h.itmod,h.ittran,h.itsuc,h.itnrel,f.itfcon,f.itfvc,g.tp1imp3)      
        group by f_pag,itmod,ittran,itsuc,itnrel;
      EXCEPTION
            when others then
          v_AQPa018mpenac :=0; 
          v_AQPa018minmoc:=0;
          v_AQPa018micvc :=0;
          v_AQPa018mcapitc :=0;
          v_AQPa018mseguc :=0;
          v_AQPa018motroc :=0;
          v_aqpa018mincoc:=0;
        end;
        
        begin
          select rubro into lc_rubro from fsd016 f where f.pgcod=vn_Pgcod
          and f.itsuc=vn_Itsuc
          and f.itmod=vn_Itmod        
          and f.ittran=vn_Ittran        
          and f.itnrel=vn_Itnrel
          and f.itord = 10;
        exception
         when no_data_found then
          lc_rubro:= 0;
        end; 
          
        --obtengo la clave del credito
        Begin
        select aqpa018hpgcod, 
        aqpa018hmodul,
        aqpa018htoper,
        aqpa018hsucur,
        aqpa018hmda,
        aqpa018hpap, 
        aqpa018hcta,
        aqpa018hoper,
        aqpa018hsubop into
        v_aqpa018hpgcod,
        v_aqpa018hmodul,
        v_aqpa018htoper,
        v_aqpa018hsucur,
        v_aqpa018hmda,
        v_aqpa018hpap,
        v_aqpa018hcta,
        v_aqpa018hoper,
        v_aqpa018hsubop
        from AQPA018 a
         where AQPA018IPGCOD = vn_Pgcod       
         and AQPA018Itmod = vn_Itmod                        
         and AQPA018Itsuc = vn_Itsuc
         and AQPA018Ittran = vn_Ittran        
         and AQPA018Itnrel = vn_Itnrel
         and AQPA018Itfcon = vd_Pgfape;
         exception
        when others then
          NULL;
        end; 
        Begin
          select aofvto/*,aostat*/ into ld_scfvto/*,ln_scstat*/  from fsd010 f 
          where f.pgcod=v_aqpa018hpgcod 
          and f.aomod=  v_aqpa018hmodul 
          and f.aosuc=  v_aqpa018hsucur 
          and f.aomda=  v_aqpa018hmda 
          and f.aopap=  v_aqpa018hpap 
          and f.aocta=  v_aqpa018hcta
          and f.aooper= v_aqpa018hoper 
          and f.aotope= v_aqpa018htoper
          and f.aosbop= v_aqpa018hsubop;
         exception
         when others then
           null;
         end;
        begin
        select t.jaqm33fint, t.jaqm33nexp
        into ld_AQPA018FECINT, ln_AQPA018NROEXP
        from jaqm33 t, jaqm27 j
        where j.jaqm27pgc = v_aqpa018hpgcod
         and j.jaqm27mod = v_aqpa018hmodul
         and j.jaqm27suc = v_aqpa018hsucur
         and j.jaqm27mda = v_aqpa018hmda
         and j.jaqm27pap = v_aqpa018hpap
         and j.jaqm27cta = v_aqpa018hcta
         and j.jaqm27oper = v_aqpa018hoper
         and j.jaqm27sbop = v_aqpa018hsubop
         and j.jaqm27tope = v_aqpa018htoper
         and j.jaqm33cor = t.jaqm33cor;
         exception
        when others then
          NULL;
        end;
        begin
          SELECT s.JAQL165COM
            into lc_AQPA018ACUPAG
            FROM (select * from JAQL165 T
         where t.jaql165emp = v_aqpa018hpgcod
           and t.jaql165suc = v_aqpa018hsucur
           and t.jaql165mda = v_aqpa018hmda
           and t.jaql165pap = v_aqpa018hpap
           and t.jaql165cta = v_aqpa018hcta
           and t.jaql165ope = v_aqpa018hoper
           and t.jaql165sbo = v_aqpa018hsubop
           and t.jaql165top = v_aqpa018htoper
           and t.jaql165mod = v_aqpa018hmodul           
           order by  t.jaql165corr desc) s
           where rownum=1;        
        exception
          when others then
            NULL;
        end;
      
        if lc_AQPA018ACUPAG = 'P' then
          lc_AQPA018DACUPAG := 'Cancelacion Especial Parcial';
        elsif lc_AQPA018ACUPAG = 'D' then
          lc_AQPA018DACUPAG := 'De pago';
        elsif lc_AQPA018ACUPAG = 'T' then
          lc_AQPA018DACUPAG := 'Cancelacion Especial Total';
        elsif lc_AQPA018ACUPAG = 'N' then
          lc_AQPA018DACUPAG := 'Ninguna';
        end if;
         ---cancelación especial        
        begin
        SELECT s.JAQL165TEX
            into lc_AQPA018CANESP
            FROM (select * from JAQL165 T
            where t.jaql165emp = v_aqpa018hpgcod
             and t.jaql165suc = v_aqpa018hsucur
             and t.jaql165mda = v_aqpa018hmda
             and t.jaql165pap = v_aqpa018hpap
             and t.jaql165cta = v_aqpa018hcta
             and t.jaql165ope = v_aqpa018hoper
             and t.jaql165sbo = v_aqpa018hsubop
             and t.jaql165top = v_aqpa018htoper
             and t.jaql165mod = v_aqpa018hmodul
             and t.jaql165com in ('T','P')
             order by t.jaql165corr desc) s 
             where rownum=1;
         exception
          when others then
            NULL;
         end;
        -- tipo de credito
        ln_AQPA018TIPCRE := substr(lc_rubro,5,2);
        --se debe insertar estos montos en la tabla estos son los montos Condonados
        update AQPA018 set 
         AQPa018mcapip=vn_capital, 
         AQPa018msegup=vn_seguros, 
         AQPa018motrop=vn_oro ,
          AQPa018mpenap=vn_penalidad, 
          AQPa018minmop=vn_intmora,
          AQPa018micvp=vn_icv, 
          aqpa018mincop=vn_intcompe,
          
          AQPa018hrubroc = lc_rubro, ---ESTO PREGUNTAR SI ESTA BIEN ESE RUBRO DE LA TRANSACCION DE PAGO
          AQPA018TIPCRE = ln_AQPA018TIPCRE,
          AQPA018FECINT = ld_AQPA018FECINT,
          AQPA018NROEXP = ln_AQPA018NROEXP,
          AQPA018ACUPAG = lc_AQPA018ACUPAG,
          AQPA018DACUPAG = lc_AQPA018DACUPAG,
          AQPA018CANESP = lc_AQPA018CANESP
        where AQPA018IPGCOD = vn_Pgcod       
         and AQPA018Itmod =   vn_Itmod                        
         and AQPA018Itsuc =   vn_Itsuc
         and AQPA018Ittran =  vn_Ittran        
         and AQPA018Itnrel =  vn_Itnrel
         and AQPA018Itfcon =  vd_Pgfape;
         commit;
        --se adiciono este update kdvc 13/11/2019 para que calcule todos los campos C
         update AQPA018 set
         AQPa018mpenac = v_AQPa018mpenac,  --                AQPa018mpenad - AQPa018mpenap, --solo se actualiza estos montos porque son los exonerados por estas transacciones
         AQPa018minmoc = v_AQPa018minmoc,   --             AQPa018minmod - AQPa018minmop,  --exonerado por la transaccion 30/111  o 30/122
         AQPa018micvc  = v_AQPa018micvc,  --          AQPa018micvd - AQPa018micvp,    ---exonerado solo por la transaccion 30/111 
         AQPa018mcapitc =v_AQPa018mcapitc,  --                AQPa018mcapitd - AQPa018mcapip - AQPa018mcapref, 
         AQPa018mseguc = v_AQPa018mseguc,   --               AQPa018msegud - AQPa018msegup , 
         AQPa018motroc = v_AQPa018motroc,   --               AQPa018motrod - AQPa018motrop,
         aqpa018mincoc = v_aqpa018mincoc   --              aqpa018mincod - aqpa018mincop         
         where AQPA018IPGCOD = vn_Pgcod       
         and AQPA018Itmod =   vn_Itmod                        
         and AQPA018Itsuc =   vn_Itsuc
         and AQPA018Ittran =  vn_Ittran        
         and AQPA018Itnrel =  vn_Itnrel
         and AQPA018Itfcon =  vd_Pgfape;
         commit;
         update AQPA018 set        
         AQPa018mSUMAC = AQPa018mpenac + AQPa018minmoc + AQPa018micvc + AQPa018mcapitc + AQPa018mseguc + AQPa018motroc + aqpa018mincoc         
         where AQPA018IPGCOD = vn_Pgcod       
         and AQPA018Itmod =   vn_Itmod                        
         and AQPA018Itsuc =   vn_Itsuc
         and AQPA018Ittran =  vn_Ittran        
         and AQPA018Itnrel =  vn_Itnrel
         and AQPA018Itfcon =  vd_Pgfape;
         commit;
         
         begin 
            select 
              AQPa018mpenac, 
              AQPa018minmoc,
              AQPa018micvc,  
              AQPa018mcapitc,
              AQPa018mseguc, 
              AQPa018motroc, 
              aqpa018mincoc, 
              AQPa018mSUMAC 
              into
              v_AQPa018mpenac, 
              v_AQPa018minmoc,
              v_AQPa018micvc,  
              v_AQPa018mcapitc,
              v_AQPa018mseguc, 
              v_AQPa018motroc, 
              v_aqpa018mincoc, 
              v_AQPa018mSUMAC            
             from  AQPA018
             where AQPA018IPGCOD = vn_Pgcod       
             and AQPA018Itmod =   vn_Itmod                        
             and AQPA018Itsuc =   vn_Itsuc
             and AQPA018Ittran =  vn_Ittran        
             and AQPA018Itnrel =  vn_Itnrel
             and AQPA018Itfcon =  vd_Pgfape;
             exception
          when others then
            v_AQPa018mpenac := 0;
              v_AQPa018minmoc := 0;
              v_AQPa018micvc := 0;
              v_AQPa018mcapitc := 0;
              v_AQPa018mseguc := 0;
              v_AQPa018motroc := 0; 
              v_aqpa018mincoc := 0; 
              v_AQPa018mSUMAC := 0;
         end;
           update jaqz893_aux set
           jaqz893auxcapit = v_AQPa018mcapitc,
           jaqz893auxinter  = v_aqpa018mincoc, 
           jaqz893auxsegur = v_AQPa018mseguc, 
           jaqz893auxicv   = v_AQPa018micvc,  
           jaqz893auxintmor = v_AQPa018minmoc,
           jaqz893auxpen   = v_AQPa018mpenac, 
           jaqz893auxmonto =  v_AQPa018mSUMAC                                
           where jaqz893auxpgct = vn_Pgcod  
           and jaqz893auxsuct = vn_Itsuc
           and jaqz893auxmodt = vn_Itmod  
           and  jaqz893auxtrxt =vn_Ittran 
           and  jaqz893auxrelt =vn_Itnrel
           and  jaqz893auxfect =vd_Pgfape;     
         commit;      
end sp_graba4;
--fin kdvc 23/08/2021
procedure sp_cuota (vn_Pgcod in number, vn_ppmod in number, vn_ppsuc in number, vn_ppmda in number, vn_pppap in number,
   vn_ppcta in number, vn_ppoper in number,vn_ppsbop in number, vn_pptope in number,vn_ppfpag in date, vd_Pgfape in date,ln_cuota out number)
is
begin
  --número de cuota
  begin
    select count(*) into ln_cuota
    from fsd601 aa
    where aa.pgcod = vn_Pgcod
    and aa.ppmod = vn_ppmod
    and aa.ppsuc = vn_ppsuc
    and aa.ppmda = vn_ppmda
    and aa.pppap = vn_pppap
    and aa.ppcta = vn_ppcta
    and aa.ppoper =  vn_ppoper
    and aa.ppsbop = vn_ppsbop
    and aa.pptope = vn_pptope
    and aa.d601co = 'S'
    and aa.ppfpag <= vn_ppfpag;
      exception
        when others then
          NULL;
        end; 
end sp_cuota;
procedure sp_JAQZ893(vn_Pgcod in number, vn_Itsuc in number, vn_Itmod in number, vn_Ittran in number, vn_Itnrel in number, vn_Itord in number, 
    vn_Itsbor in number, vd_Pgfape date)
is
begin
  --graba en tabla
  begin    
  insert into JAQZ893
  select aqpa018hpgcod, 
         aqpa018hmodul,
        aqpa018hsucur,
        aqpa018hmda,
        aqpa018hpap,
        aqpa018hcta,             
        aqpa018hoper,
        aqpa018hsubop,               
        aqpa018htoper,
        aqpa018ipgcod,
        aqpa018itmod, 
        aqpa018itsuc, 
        aqpa018ittran,
        aqpa018itnrel,
        aqpa018itfcon,
        vn_Itord,
        aqpa018hrubroc,
        aqpa018ithora,
        aqpa018itucnf 
  from AQPA018  
  where AQPA018IPGCOD = vn_Pgcod       
         and AQPA018Itmod = vn_Itmod                        
         and AQPA018Itsuc = vn_Itsuc
         and AQPA018Ittran = vn_Ittran        
         and AQPA018Itnrel = vn_Itnrel
         and AQPA018Itfcon = vd_Pgfape;
   exception
        when others then
          NULL;
   end;  
   commit;
end sp_JAQZ893;

procedure sp_eliminaJAQZ893(vn_Pgcod in number, vn_Itsuc in number, vn_Itmod in number, vn_Ittran in number, vn_Itnrel in number, vn_Itord in number, 
    vn_Itsbor in number, vd_Pgfape date)
is
begin
  --graba en tabla
  begin    
  delete JAQZ893
  where      jaqz893d602cd = vn_Pgcod       
         and jaqz893d602mo = vn_Itmod                        
         and jaqz893d602su = vn_Itsuc
         and jaqz893d602tr = vn_Ittran        
         and jaqz893d602re = vn_Itnrel
         and jaqz893d602fc = vd_Pgfape;
        -- and JAQZ893D602HR = '09:38:42'
   exception
        when others then
          NULL;
   end;  
  commit;
end sp_eliminaJAQZ893;
procedure sp_diasatraso (v_aqpa018hpgcod in number, v_aqpa018hmodul in number,v_aqpa018hsucur in number, v_aqpa018hmda in number,
                         v_aqpa018hpap in number, v_aqpa018hcta in number, v_aqpa018hoper in number, v_aqpa018hsubop in number, v_aqpa018htoper in number,
                        vd_Pgfape in date, ln_AQPA018DIAATR out number)
is
BEGIN
  begin
        --vigente y refinanciado
          SELECT (vd_Pgfape - min(a.Ppfpag))
                 into ln_AQPA018DIAATR 
          FROM FSD601 a left join FSD602 b
          on
                b.Pgcod  = a.Pgcod
            and b.Ppmod  = a.Ppmod
            and b.Ppsuc  = a.Ppsuc
            and b.Ppmda  = a.Ppmda
            and b.Pppap  = a.Pppap
            and b.Ppcta  = a.Ppcta
            and b.Ppoper = a.Ppoper
            and b.Ppsbop = a.Ppsbop
            and b.Pptope = a.Pptope
            and b.Ppfpag = a.Ppfpag
            and b.Pptipo = a.Pptipo
            and b.Pp1stat = 'T'
            and b.D602co  = 'S'
            --and b.pptipo  <> 'K'
            and b.pp1fech<=vd_Pgfape
          where
                a.Pgcod  = v_aqpa018hpgcod
            and a.Ppmod  = v_aqpa018hmodul
            and a.Ppsuc  = v_aqpa018hsucur
            and a.Ppmda  = v_aqpa018hmda
            and a.Pppap  = v_aqpa018hpap
            and a.Ppcta  = v_aqpa018hcta
            and a.Ppoper = v_aqpa018hoper
            and a.Ppsbop = v_aqpa018hsubop
            and a.Pptope = v_aqpa018htoper
            and a.Ppfpag <= vd_Pgfape
            and a.D601co = 'S'
            and (a.ppcap + a.ppint ) > 0 --se agrego por cuotas de gracia 2013.09.06
            and b.D602co is null;                      
        exception
        when no_data_found then
          Begin
             select (vd_Pgfape - min(d.Ppfpag))
             into ln_AQPA018DIAATR
             from fsd601 d
          where d.Pgcod  = v_aqpa018hpgcod
            and d.Ppmod  = v_aqpa018hmodul
            and d.Ppsuc  = v_aqpa018hsucur
            and d.Ppmda  = v_aqpa018hmda
            and d.Pppap  = v_aqpa018hpap
            and d.Ppcta  = v_aqpa018hcta
            and d.Ppoper = v_aqpa018hoper
            and d.Ppsbop = v_aqpa018hsubop
            and d.Pptope = v_aqpa018htoper
            and d.Ppfpag <= vd_Pgfape
            and (d.ppcap + d.ppint ) > 0;
          exception
              when no_data_found then
                   ln_AQPA018DIAATR := null;
          End;
        END;
end sp_diasatraso;
-- inicio se adicionó el 26/08/2021
procedure sp_montosultimacuota ( vn_Pgcod in number, vn_Itsuc in number, vn_Itmod in number, vn_Ittran in number, vn_Itnrel in number, vn_Itord in number, 
    vn_Itsbor in number, vd_Pgfape date)
is
ln_PgCod number;
ln_Ppsuc number;
ln_Ppmod number;
ln_Ppmda number;
ln_Pppap number;
ln_Ppcta number;
ln_Ppoper number;
ln_Ppsbop number;
ln_Pptope number;
ld_Ppfpag date;
ln_Pp1nump number;
ln_Ppcap number;
ln_Ppint number;
ln_IntMor number;
ln_Icv number;
ln_Seguro1 number;
ln_Seguro2 number;
ln_Seguro3 number;
ln_Seguro4 number;
ln_Seguro5 number;
ln_penalidad number;
ln_modulo number;
ln_ittope number;
ln_itsucd number;
ln_moneda number;
ln_papel number;
ln_ctnro number;
ln_itoper number;
ln_itsubope number;
vn_total number;
begin
  --obtengo la máxima cuot o última cuota
  begin
    select modulo,
           ittope,
           itsucd,
           moneda,
           papel,
           ctnro,
           itoper,
           itsubo
    into   ln_modulo,
           ln_ittope,
           ln_itsucd,
           ln_moneda,
           ln_papel,
           ln_ctnro,
           ln_itoper,
           ln_itsubope                   
    from fsd016
    where pgcod =vn_Pgcod
    and itsuc = vn_Itsuc
    and itmod = vn_Itmod
    and ittran =vn_Ittran 
    and itnrel =vn_Itnrel
    and itord = 10;
  EXCEPTION
   when others then
      ln_ctnro:= 0 ; 
   end;    
  if (ln_ctnro > 0) then
      begin 
        select max(ppfpag)
        into ld_ppfpag   
        from FSD601 -- --> FSD602: Calendario de Pagos, busca las cuotas pagadas por la transacción
        Where PgCod = vn_Pgcod
          and Ppmod = ln_modulo
          and Ppsuc = ln_itsucd
          and Ppmda = ln_moneda
          and Pppap = ln_papel
          and Ppcta = ln_ctnro
          and Ppoper = ln_itoper
          and Ppsbop = ln_itsubope
          and Pptope = ln_ittope;                                 
       EXCEPTION
       when others then
          ld_ppfpag:= null ; 
       end;
       Begin
       select         
           Ppcap,  --capital
           Ppint   --interes compensatorio          
           into                     
           ln_Ppcap,
           ln_Ppint 
        from FSD601 -- --> FSD601: cronograma de pago se debe sacar de aca porque cuando se apga adelantado los montos en le fSD602 del interes se vuelve cero
        where PgCod = vn_Pgcod
          and Ppmod = ln_modulo
          and Ppsuc = ln_itsucd
          and Ppmda = ln_moneda
          and Pppap = ln_papel
          and Ppcta = ln_ctnro
          and Ppoper = ln_itoper
          and Ppsbop = ln_itsubope
          and Pptope = ln_ittope
          and ppfpag = ld_ppfpag;
        EXCEPTION
        when others then
             ln_Ppcap:= 0;
           ln_Ppint:=0;
        end;
        --obtengo seguros       
      begin
      select  --Pp1imp2,  -- Interes Moratorio
              --Pp1imp3, --obtengo ICV
              Ppimp11, --seguro
              Ppimp12, --seguro
              Ppimp13, --seguro
              Ppimp14, --seguro
              Ppimp15 --seguro
       into
              --ln_IntMor, 
              --ln_Icv,
              ln_Seguro1,
              ln_Seguro2,
              ln_Seguro3,
              ln_Seguro4,
              ln_Seguro5
      from FSD611
      where PgCod = vn_Pgcod
      and Ppmod   =  ln_modulo 
      and Ppsuc   =  ln_itsucd 
      and Ppmda   =  ln_moneda
      and Pppap   =  ln_papel
      and Ppcta   =  ln_ctnro
      and Ppoper  =  ln_itoper
      and Ppsbop  = ln_itsubope
      and Pptope  = ln_ittope
      and ppfpag = ld_ppfpag;
      EXCEPTION
      when others then
       -- ln_IntMor :=0; 
       -- ln_Icv :=0; 
        ln_Seguro1:=0; 
        ln_Seguro2 :=0;
        ln_Seguro3:=0;
        ln_Seguro4:=0;
        ln_Seguro5:=0;
      end;
      vn_total:=  ln_Ppcap + ln_Ppint + ln_Seguro1 + ln_Seguro2 + ln_Seguro3 + ln_Seguro4 + ln_Seguro5;
      -- graba los montos obtenidos en la FSD016
      begin
        update fsd016 set Itimp2=vn_total                                    
         where PgCod = vn_Pgcod
         and Itsuc   = vn_Itsuc 
         and Itmod   = vn_Itmod
         and Ittran  = vn_Ittran
         and Itnrel  = vn_Itnrel
         and Itord   = 44;
       EXCEPTION
       when others then
        null;
       end;
       commit;      
    end if;    
end sp_montosultimacuota;

procedure sp_exoneraultimacuota ( vn_Pgcod in number, vn_Itsuc in number, vn_Itmod in number, vn_Ittran in number, vn_Itnrel in number, vn_Itord in number, 
    vn_Itsbor in number, vd_Pgfape date)
is
ln_PgCod number;
ln_Ppsuc number;
ln_Ppmod number;
ln_Ppmda number;
ln_Pppap number;
ln_Ppcta number;
ln_Ppoper number;
ln_Ppsbop number;
ln_Pptope number;
ld_Ppfpag date;
ln_Pp1nump number;

begin
  --obtengo la máxima cuota o última cuota
  begin 
    select max(Pp1nump)
    into ln_Pp1nump    
    from FSD602 -- --> FSD602: Calendario de Pagos, busca las cuotas pagadas por la transacción
    Where D602cd = vn_Pgcod
      and D602mo = vn_Itmod
      and D602su = vn_Itsuc
      and D602tr = vn_Ittran
      and D602re = vn_Itnrel
      and D602fc = vd_Pgfape;
   EXCEPTION
   when others then
      ln_Pp1nump:= 0 ; 
   end;
  
  if ( ln_Pp1nump > 0) then            
   --obtengo la clave del crédito 
    begin 
    select PgCod,
           Ppsuc,
           Ppmod,
           Ppmda,
           Pppap,
           Ppcta,
           Ppoper,
           Ppsbop,
           Pptope,
           Ppfpag      
           into          
           ln_PgCod, 
           ln_Ppsuc, 
           ln_Ppmod,  
           ln_Ppmda,  
           ln_Pppap,  
           ln_Ppcta,  
           ln_Ppoper, 
           ln_Ppsbop, 
           ln_Pptope, 
           ld_Ppfpag           
      from FSD602 -- --> FSD602: Calendario de Pagos, busca las cuotas pagadas por la transacción
      Where D602cd = vn_Pgcod
      and D602mo   = vn_Itmod
      and D602su   = vn_Itsuc
      and D602tr   = vn_Ittran
      and D602re   = vn_Itnrel
      and D602fc   = vd_Pgfape
      and Pp1nump = ln_Pp1nump;
     EXCEPTION
      when others then
        ln_Ppcta:= 0 ; 
        ln_Ppoper:=0;       
     end;
     --coloco en cero el capital y el interes        
     begin 
     update  FSD602 -- --> FSD602: Calendario de Pagos, busca las cuotas pagadas por la transacción        
     set   Pp1cap=0,  --capital
           Pp1int=0   --interes compensatorio               
      Where D602cd = vn_Pgcod
      and D602mo   = vn_Itmod
      and D602su   = vn_Itsuc
      and D602tr   = vn_Ittran
      and D602re   = vn_Itnrel
      and D602fc   = vd_Pgfape
      and Pp1nump = ln_Pp1nump;
      EXCEPTION
      when others then
           null;
      end;
      -- coloco en cero montos de los seguros, int moratorio, ICV
      begin
      update FSD612  
      set     Pp1imp2=0, -- Interes Moratorio
              Pp1imp3=0, --obtengo ICV
              Pp1imp11=0,--seguro
              Pp1imp12=0,--seguro
              Pp1imp13=0,--seguro
              Pp1imp14=0,--seguro
              Pp1imp15=0 --seguro
      where PgCod = ln_PgCod
      and Ppmod   =  ln_Ppmod 
      and Ppsuc   =  ln_Ppsuc 
      and Ppmda   =  ln_Ppmda
      and Pppap   =  ln_Pppap
      and Ppcta   =  ln_Ppcta
      and Ppoper  = ln_Ppoper
      and Ppsbop  = ln_Ppsbop
      and Pptope  = ln_Pptope
      and pp1nump = ln_Pp1nump;
      EXCEPTION
      when others then
           null;
      end;
       -- coloco en cero montos de penalidad
      begin
        update Fpp003 
        set Pp003Imp=0        
        where PgCod = ln_PgCod
        and Ppmod   = ln_Ppmod 
        and Ppsuc   = ln_Ppsuc 
        and Ppmda   = ln_Ppmda
        and Pppap   = ln_Pppap
        and Ppcta   = ln_Ppcta
        and Ppoper  = ln_Ppoper
        and Ppsbop  = ln_Ppsbop
        and Pptope  = ln_Pptope
        and Ppfpag  = ld_Ppfpag 
        and pp003nump = ln_Pp1nump
        and  PrestConc = 3;
      EXCEPTION
      when others then
        null;
      end;      
    end if;
end sp_exoneraultimacuota;
procedure sp_esreprog_exonerado (vn_Pgcod in number, vn_ppmod in number, vn_ppsuc in number, vn_ppmda in number, vn_pppap in number,
   vn_ppcta in number, vn_ppoper in number,vn_ppsbop in number, vn_pptope in number,vn_ppfpag in date, ln_Indicador out number)
is
begin
  ln_Indicador:=0;
  begin
      select 1 into ln_Indicador
      from AQPB411
      where AQPB411COD = vn_Pgcod
      and AQPB411MOD = vn_ppmod
      and AQPB411SUC = vn_ppsuc
      and AQPB411MDA = vn_ppmda
      and AQPB411PAP = vn_pppap
      and AQPB411CTA = vn_ppcta
      and AQPB411OPE = vn_ppoper
      and AQPB411SBO = vn_ppsbop
      and AQPB411TPO = vn_pptope
      and AQPB411EST  ='P';
   exception 
      when others then
        ln_Indicador :=0;
   end;       
end  sp_esreprog_exonerado;   
procedure sp_ultimacuota( v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number, 
                             vd_ppfpag in date,                            
                             v_esvencido out number                             
                             ) is
ld_ppfpag date;
ld_pgfape date;
begin
  v_esvencido:=0;
  select pgfape into ld_pgfape from fst017 where pgcod= v_pgcod; 
  begin 
    select max(ppfpag) into ld_ppfpag from fsd601
    where Pgcod  =  v_pgcod 
      and Ppmod  =  v_Scmod 
      and Ppsuc  =  v_Scsuc 
      and Ppmda  =  v_Scmda 
      and Pppap  =  v_Scpap 
      and Ppcta  =  v_Sccta 
      and Ppoper =  v_Scoper
      and Ppsbop =  v_Scsbop
      and Pptope =  v_Sctope;
   exception
     when others then
       ld_ppfpag := null;
   end;
   if ( ld_ppfpag <  vd_ppfpag ) then --ld_pgfape ) then
    v_esvencido:=1;
   end if;    
end   sp_ultimacuota;  
procedure sp_estaamortizando( vn_Pgcod in number, 
                              vn_Itsuc in number, 
                              vn_Itmod in number, 
                              vn_Ittran in number, 
                              vn_Itnrel in number, 
                              vn_Itord in number, 
                              vn_Itsbor in number,
                              vd_ppfpag in date,                            
                              v_esamortizacion out number                             
                             ) is
ln_encontro number;
begin
  v_esamortizacion:=0;
  
  begin 
    select count(*) into ln_encontro 
    from FSD012
    where D012CD = vn_Pgcod
      and D012MO = vn_Itmod
      and D012SU = vn_Itsuc
      and D012TR = vn_Ittran
      and D012RE = vn_Itnrel
      and D012OR = vn_Itord
      and D012SB = vn_Itsbor
      and D012FC = vd_ppfpag
      and EVTIPO = 31;      
   exception     
     when others then
       ln_encontro := 0;
   end;
   if ( ln_encontro >0 ) then 
    v_esamortizacion:=1;
   end if;    
end   sp_estaamortizando;                            
-- fin se adicionó el 26/08/2021    
end pq_cr_condonaciones;
/

