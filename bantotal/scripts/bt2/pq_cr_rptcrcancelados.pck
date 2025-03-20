create or replace package PQ_CR_RPTCRCANCELADOS is

  -- Author  : EFUENTES
  -- Created : 24/12/2021 12:27:25
  -- Purpose : PAQUETE PARA REPORTE DE CREDITOS CANCELADOS

  ------------------------------------------------------------------------------  
  procedure sp_generar_rptcrcancelados(pd_fecha    in date,
                                       pd_analista in char,
                                       pd_fecpro   in date,
                                       pn_Coderr   out number);
                          
end PQ_CR_RPTCRCANCELADOS;
/

create or replace package body PQ_CR_RPTCRCANCELADOS is

  ------------------------------------------------------------------------------  
  procedure sp_generar_rptcrcancelados(pd_fecha    in date,
                                       pd_analista in char,
                                       pd_fecpro   in date,
                                       pn_Coderr   out number) is
    my_errm VARCHAR2(32000);
  begin
    pn_Coderr := 0;
    begin
      delete from aqpb620 a where a.aqpb620usurpt = pd_analista;-- and a.aqpb620fec = pd_fecha;
      COMMIT;
    end;
    begin
      insert into aqpb620(AQPB620FEC, AQPB620HOR, AQPB620NTRX, AQPB620NOMCLI, AQPB620EMP, AQPB620MDA, AQPB620CTA,
                          AQPB620OPE, AQPB620SOPE, AQPB620TOPE, AQPB620MOD, AQPB620SUCOPE, AQPB620DMDATR, AQPB620SLDCAN,
                          AQPB620TOTCAN, AQPB620MNTOTO, AQPB620EMPTRX, AQPB620MODTRX, AQPB620SUCTRX, AQPB620TRX,
                          AQPB620RELTRX, AQPB620FCONTRX, AQPB620NSUCTR, AQPB620NMOD, AQPB620NTOPE, AQPB620NTIPCR,
                          AQPB620ANA, AQPB620TLF, AQPB620DIRCL, AQPB620DIRNG, AQPB620REGION, AQPB620CTAGAR,
                          AQPB620OPEGAR, AQPB620MNDGAR, AQPB620MTOGAR, AQPB620TIPGAR, AQPB620ESTGAR, 
                          AQPB620USURPT, AQPB620FECRPT)
      select distinct /*+all_rows*/
             h16.hfcon Fecha,
             h15.hhora,  
             h16.hcmod||'-'||h16.htran||':'||trim(t34.trnom) Transaccion,
             InitCap(Trim(replace(d1.penom,'"',''))) Cliente,
             h16.pgcod Empresa,
             h16.hmda Moneda,
             h16.hcta Cuenta,
             h16.hoper Operacion,
             h16.hsubop Sub_Oper,
             h16.htoper Tipo_Oper,
             h16.hmodul Modulo,
             h16.hsucur||'-'||Initcap(trim(t2.scnom)) Sucursal_Ope,
             decode(h16.hmda,0,'S/.','US$') Moneda_Trx,
             h16.hcimp1 Saldo_Cancelado,
             h16.hcimp6 Total_Cancelacion,
             d10.aoimp ImpOtorgado,
             h16.pgcod EmpresaTrx,
             h16.hcmod ModuloTrx,
             h16.hsucor SucursalTrx,
             h16.htran TransaccionTrx,
             h16.hnrel RelacionTrx,
             h16.hfcon FConTrx,
             InitCap(Trim(t1.scnom)) Sucursal_Transaccion,
             InitCap(Trim(t3.mdnom)) Modulo,
             InitCap(Trim(t4.tonom)) Tipo_Oper,
             case  when h16.hrubro like '14%' and substr(h16.hrubro,5,2)='02' then 'MICROEMPRESAS'   
                   when h16.hrubro like '14%' and substr(h16.hrubro,5,2)='03' and substr(h16.hrubro,11,3)='015' then 'CONSUMO REVOLVENTE' 
                   when h16.hrubro like '14%' and substr(h16.hrubro,5,2)='03' and substr(h16.hrubro,11,3)<>'015' then 'CONSUMO NO REVOLVENTE'  
                   when h16.hrubro like '14%' and substr(h16.hrubro,5,2)='04' then 'HIPOTECARIO'
                   when h16.hrubro like '14%' and substr(h16.hrubro,5,2)='12' then 'MEDIANA EMPRESA'
                   when h16.hrubro like '14%' and substr(h16.hrubro,5,2)='13' then 'PEQUEÑA EMPRESA' || ' '|| fn_sector_credito(h16.hfcon,h16.pgcod,h16.hmodul,h16.hsucur,h16.hmda,h16.hpap,h16.hcta,h16.hoper,h16.hsubop,h16.htoper)                                     
                   else InitCap(Trim(t4.tonom))
             END Tipo_Credito,
             fn_analista_credito(h16.hmodul,h16.hsucur,h16.hmda,h16.hpap,h16.hcta,h16.hoper,h16.hsubop,h16.htoper) Analista,
             /*aojeda.*/fn_telclie(d1.pendoc) telefono,
             /*aojeda.*/fn_direccion_cliente(d1.pepais,d1.petdoc,d1.pendoc,1,'DIR') DIRECCION_CLIENTE,
             /*aojeda.*/fn_direccion_cliente(d1.pepais,d1.petdoc,d1.pendoc,3,'DIR') DIRECCION_NEGOCIO,
             upper(rs.RegNOM) region,
             (select r_011.r2cta
                from fsr011 r_011
               where r_011.r1cod  = h16.pgcod
                 and r_011.r1mod  = h16.hmodul
                 and r_011.r1suc  = h16.hsucur
                 and r_011.r1mda  = h16.hmda
                 and r_011.r1pap  = h16.hpap
                 and r_011.r1cta  = h16.hcta
                 and r_011.r1oper = h16.hoper
                 and r_011.r1sbop = h16.hsubop
                 and r_011.r1tope = h16.htoper
                 and r_011.relcod = 50
                 and r_011.r2mod  = 70
                 and r_011.r2tope in (10, 11, 13, 15, 16, 18, 20, 25, 30, 40, 42, 50, 55, 60, 65, 70)
                 and r_011.r011co = 'S' and rownum=1) Cta_Garantia,
             (select r_011.r2oper
                from fsr011 r_011
               where r_011.r1cod  = h16.pgcod
                 and r_011.r1mod  = h16.hmodul
                 and r_011.r1suc  = h16.hsucur
                 and r_011.r1mda  = h16.hmda
                 and r_011.r1pap  = h16.hpap
                 and r_011.r1cta  = h16.hcta
                 and r_011.r1oper = h16.hoper
                 and r_011.r1sbop = h16.hsubop
                 and r_011.r1tope = h16.htoper
                 and r_011.relcod = 50
                 and r_011.r2mod  = 70
                 and r_011.r2tope in (10, 11, 13, 15, 16, 18, 20, 25, 30, 40, 42, 50, 55, 60, 65, 70)
                 and r_011.r011co = 'S' and rownum=1) Oper_Garantia,
             (select t_005.mosign
                from fsr011 r_011
               inner join fst005 t_005
                  on t_005.moneda = r_011.r2mda
               where r_011.r1cod  = h16.pgcod
                 and r_011.r1mod  = h16.hmodul
                 and r_011.r1suc  = h16.hsucur
                 and r_011.r1mda  = h16.hmda
                 and r_011.r1pap  = h16.hpap
                 and r_011.r1cta  = h16.hcta
                 and r_011.r1oper = h16.hoper
                 and r_011.r1sbop = h16.hsubop
                 and r_011.r1tope = h16.htoper
                 and r_011.relcod = 50
                 and r_011.r2mod  = 70
                 and r_011.r2tope in (10, 11, 13, 15, 16, 18, 20, 25, 30, 40, 42, 50, 55, 60, 65, 70)
                 and r_011.r011co = 'S' and rownum=1) Moneda_Garantia,
             (select d_010.aoimp
                from fsr011 r_011
               inner join fsd010 d_010
                  on r_011.r2cod  = d_010.pgcod
                 and r_011.r2mod  = d_010.aomod
                 and r_011.r2suc  = d_010.aosuc
                 and r_011.r2mda  = d_010.aomda
                 and r_011.r2pap  = d_010.aopap
                 and r_011.r2cta  = d_010.aocta
                 and r_011.r2oper = d_010.aooper
                 and r_011.r2sbop = d_010.aosbop
                 and r_011.r2tope = d_010.aotope
               where r_011.r1cod  = h16.pgcod
                 and r_011.r1mod  = h16.hmodul
                 and r_011.r1suc  = h16.hsucur
                 and r_011.r1mda  = h16.hmda
                 and r_011.r1pap  = h16.hpap
                 and r_011.r1cta  = h16.hcta
                 and r_011.r1oper = h16.hoper
                 and r_011.r1sbop = h16.hsubop
                 and r_011.r1tope = h16.htoper
                 and r_011.relcod = 50
                 and r_011.r2mod  = 70
                 and r_011.r2tope in (10, 11, 13, 15, 16, 18, 20, 25, 30, 40, 42, 50, 55, 60, 65, 70)
                 and r_011.r011co = 'S' and rownum=1) Mto_Garantia,
             (select t_004.tonom
                from fsr011 r_011
               inner join fst004 t_004
                  on t_004.modulo = r_011.r2mod
                 and t_004.totope = r_011.r2tope
               where r_011.r1cod  = h16.pgcod
                 and r_011.r1mod  = h16.hmodul
                 and r_011.r1suc  = h16.hsucur
                 and r_011.r1mda  = h16.hmda
                 and r_011.r1pap  = h16.hpap
                 and r_011.r1cta  = h16.hcta
                 and r_011.r1oper = h16.hoper
                 and r_011.r1sbop = h16.hsubop
                 and r_011.r1tope = h16.htoper
                 and r_011.relcod = 50
                 and r_011.r2mod  = 70
                 and r_011.r2tope in (10, 11, 13, 15, 16, 18, 20, 25, 30, 40, 42, 50, 55, 60, 65, 70)
                 and r_011.r011co = 'S' and rownum=1) Tipo_Garantia,
             (select d_010.aostat
                from fsr011 r_011
               inner join fsd010 d_010
                  on r_011.r2cod  = d_010.pgcod
                 and r_011.r2mod  = d_010.aomod
                 and r_011.r2suc  = d_010.aosuc
                 and r_011.r2mda  = d_010.aomda
                 and r_011.r2pap  = d_010.aopap
                 and r_011.r2cta  = d_010.aocta
                 and r_011.r2oper = d_010.aooper
                 and r_011.r2sbop = d_010.aosbop
                 and r_011.r2tope = d_010.aotope
               where r_011.r1cod  = h16.pgcod
                 and r_011.r1mod  = h16.hmodul
                 and r_011.r1suc  = h16.hsucur
                 and r_011.r1mda  = h16.hmda
                 and r_011.r1pap  = h16.hpap
                 and r_011.r1cta  = h16.hcta
                 and r_011.r1oper = h16.hoper
                 and r_011.r1sbop = h16.hsubop
                 and r_011.r1tope = h16.htoper
                 and r_011.relcod = 50
                 and r_011.r2mod  = 70
                 and r_011.r2tope in (10, 11, 13, 15, 16, 18, 20, 25, 30, 40, 42, 50, 55, 60, 65, 70)
                 and r_011.r011co = 'S' and rownum=1) Est_Garantia
                 ,pd_analista ,pd_fecpro
        From fsh016 h16  join fsh015 h15 on h15.pgcod = h16.pgcod
                                        and h15.hcmod = h16.hcmod
                                        and h15.hsucor= h16.hsucor
                                        and h15.htran = h16.htran
                                        and h15.hnrel = h16.hnrel
                                        and h15.hfcon = h16.hfcon
                                        and h15.hccorr <> 99 
                        join fst034 t34 on t34.pgcod = h16.pgcod
                                       and t34.trmod = h16.hcmod
                                       and t34.trnro = h16.htran
                        join fsd010 d10 on d10.pgcod = h16.pgcod
                                       and d10.aomod = h16.hmodul
                                       and d10.aosuc = h16.hsucur
                                       and d10.aomda = h16.hmda
                                       and d10.aopap = h16.hpap
                                       and d10.aocta = h16.hcta
                                       and d10.aooper= h16.hoper
                                       and d10.aosbop= h16.hsubop
                                       and d10.aotope= h16.htoper
                                       and d10.aosbop=(select max(aosbop) -- efuentes
                                                  from fsd010
                                                  where pgcod = h16.pgcod
                                                  and aomod = h16.hmodul
                                                  and aosuc = h16.hsucur 
                                                  and aomda = h16.hmda
                                                  and aopap = h16.hpap
                                                  and aocta = h16.hcta
                                                  and aooper = h16.hoper
                                                  and aotope = h16.htoper)
                                       and d10.aofe99= h16.hfcon
                                       and d10.aostat= 99
                                       
                         join fsr011 r_011 on r_011.r1cod  = h16.pgcod
                                       and r_011.r1mod  = h16.hmodul
                                       and r_011.r1suc  = h16.hsucur
                                       and r_011.r1mda  = h16.hmda
                                       and r_011.r1pap  = h16.hpap
                                       and r_011.r1cta  = h16.hcta
                                       and r_011.r1oper = h16.hoper
                                       and r_011.r1sbop = h16.hsubop
                                       and r_011.r1tope = h16.htoper
                                       and r_011.relcod = 50
                                       and r_011.r2mod  = 70
                                       and r_011.r2tope in (10, 11, 13, 15, 16, 18, 20, 25, 30, 40, 42, 50, 55, 60, 65, 70)
                                       and r_011.r011co = 'S' --and rownum=1
                 
                         join fst003 t3 on t3.modulo = h16.hmodul
                         join fst004 t4 on t4.modulo = h16.hmodul
                                       and t4.totope = h16.htoper
                         join fst001 t1 on t1.pgcod = h16.pgcod
                                       and t1.sucurs= h16.hsucor                           
                         join fst001 t2 on t2.pgcod = h16.pgcod
                                       and t2.sucurs= h16.hsucur     
                         join fsr008 r8 on r8.ctnro = h16.hcta
                                       and r8.ttcod = 1
                                       and r8.cttfir= 'T'
                         join fsd001 d1 on d1.pepais= r8.pepais
                                       and d1.petdoc= r8.petdoc
                                       and d1.pendoc= r8.pendoc 
                         join fst811 r on r.pgcod = t1.pgcod
                                      and r.oficod = (case when t1.sucurs > 900 then 11 else t1.sucurs end)
                                      and r.regcod < 100
                          join fst810 rs on rs.regcod = r.regcod
                                      and r.regcod < 100                                                                                              
       where h16.pgcod = 1
         and h16.hfcon = pd_fecha --to_date(pd_fecpro,'rrrrmmdd')   
         and h16.hcodmo = 2
         and h16.hmodul in (select modulo from fst111 where dscod = 50)
         and ((h16.hcmod <> 99 and h16.htran <> 994) AND
              (h16.hcmod <> 300 and h16.htran <> 390) AND
              (h16.hcmod <> 300 and h16.htran <> 400)
             );
             
       pn_Coderr := 1;
       commit;
    exception
      when others then
        pn_Coderr := -1;
        my_errm := SQLERRM;
        DBMS_OUTPUT.put_line (my_errm);
    end;
  
  end sp_generar_rptcrcancelados;

end PQ_CR_RPTCRCANCELADOS;
/

