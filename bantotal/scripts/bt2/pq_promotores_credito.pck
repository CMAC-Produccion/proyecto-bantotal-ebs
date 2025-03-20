create or replace package PQ_PROMOTORES_CREDITO is

  -- Author  : ABERNEDO
  -- Created : 27/06/2014 06:19:49 p.m.
  -- Purpose : 
  
Procedure SP_CR_PROMOTORES(PD_FECINI IN DATE,PD_FECFIN IN DATE);

end PQ_PROMOTORES_CREDITO;
/

create or replace package body PQ_PROMOTORES_CREDITO is

Procedure SP_CR_PROMOTORES(PD_FECINI IN DATE,PD_FECFIN IN DATE)IS

begin
          execute immediate ('truncate table JAQY280');
          execute immediate ('truncate table JAQY281');
  begin
            insert into JAQY280(JAQY280PGCOD,JAQY280AOMOD,JAQY280AOSUC,JAQY280AOMDA,JAQY280AOPAP,
                                JAQY280AOCTA,JAQY280AOOPER,JAQY280AOSBOP,JAQY280AOTOPE,JAQY280AOFVAL,
                                JAQY280AOSTAT,JAQY280INST)
            Select a.pgcod,
                   a.aomod,
                   a.aosuc,
                   a.aomda,
                   a.aopap,
                   a.aocta,
                   a.aooper,
                   a.aosbop,
                   a.aotope,
                   a.aofval,
                   a.aostat,
                   fn_instancia_credito(aomod,aosuc,aomda,aopap,aocta,aooper,aosbop,aotope)
              from fsd010 a
             where a.aomod in (select modulo from fst111 where dscod = 50 and modulo not in (33,141,108))
               and a.aofval between PD_FECINI and PD_FECFIN
               and a.aostat = 0;

               COMMIT;
  END;
  
  begin
        
            INSERT INTO JAQY281 (JAQY281PGCOD,JAQY281REGCOD,JAQY281REGION,JAQY281SUCURS,JAQY281AGENCIA,
                                 JAQY281INSTANCIA,JAQY281CTA,JAQY281TITULAR,JAQY281OPE,JAQY281MOD,
                                 JAQY281SBO,JAQY281TOP,JAQY281SUCURSAL,JAQY281MTO,JAQY281ORI,JAQY281CODANA,
                                 JAQY281DESSOL,JAQY281PROD,JAQY281MODOPE,JAQY281ANA,JAQY281CODPRO,JAQY281PROM,
                                 JAQY281SALCAP,JAQY281FECAPRo,JAQY281MTOAPRO,JAQY281PEPAIS,JAQY281PETDOC,
                                 JAQY281PENDOC,JAQY281SALAMPLI,JAQY281NROCRE,JAQY281AOFVAL,JAQY281AOSTAT,
                                 JAQY281CANT,JAQY281REVOLV,JAQY281FECULT,JAQY281DIA,JAQY281SALREC,JAQY281TIPO)
  
  
        select jaqy280pgcod, 
              regcod, 
              region, 
              sucurs, 
              agencia,
              SOLICITUD,
              CUENTA,
              TITULAR,
              OPERACION,
              MODULO,
              SUBOPERACION,
              TIPOOPERACION,
              SUCURSAL,
              MONTO,
              TIPO_SOLICITUD,
              CODANA,
              DESCRI_SOLICITUD,
              PRODUCTO,
              MODULO_OPERACION,
              ANALISTA,
              CODPROMOTOR,
              PROMOTOR,
              SALDOCAPITAL_SOLES,
              FECHA_APROBACION,
              MONTO_APROBADO,
              PEPAIS,
              petdoc,
              pendoc,
              SALDO_AMPLIACION ,
              NUMCRES_OTOR3, 
              JAQY280AOFVAL,
              JAQY280AOSTAT,
              cantidad,
              revolvente,
              fecult_cancela,
              case when fecult_cancela is not null then ( JAQY280AOFVAL - fecult_cancela ) end dias,
              CASE when SALDO_AMPLIACION is not null then (MONTO_APROBADO -SALDO_AMPLIACION) end,
              case when cantidad >1 then 'Recurrente' else 'Nuevo' end
      from
      (select /*+parallel(h,2) parallel(s,2) parallel(pers,2) parallel(s1,2) parallel(j280,2)*/
             distinct
             j280.jaqy280pgcod,
             r2.regcod,
             upper(r2.RegNOM) region,
             age.sucurs,
             upper(age.Scnom) agencia,
             sng001inst AS SOLICITUD,
             sng001cta  AS CUENTA,
             (select p.penom 
                from fsd001 p 
               where p.pepais = pers.pepais 
                 and p.petdoc = pers.petdoc 
                 and p.pendoc = pers.pendoc ) TITULAR,
             j280.jaqy280aooper as OPERACION,
             j280.jaqy280aomod as MODULO,
             j280.jaqy280aosbop as SUBOPERACION,
             j280.jaqy280aotope as TIPOOPERACION,
             sng001age  as SUCURSAL,
             sng017mto  as MONTO,
             sng001ori  as TIPO_SOLICITUD,
             case when sng001ori in (4,12) then 'Ampliacion' else '' end DESCRI_SOLICITUD,
             (select xwfmonto1 
                from xwf700 xx 
               where xx.xwfprcins = j280.jaqy280inst 
                 and xx.xwfcar3 = 'G') SALDO_AMPLIACION,
             case
                 when h.BCGpo = 2 then 'MICROEMPRESA'
                 when h.BCGpo = 3 and substr(h.bcrubr,11,3)='015' then 'CONSUMO REVOLVENTE'
                 when h.BCGpo = 3 and substr(h.bcrubr,11,3)<>'015' then 'CONSUMO NO REVOLVENTE'
                 when h.BCGpo = 4 then 'HIPOTECARIO'
                 when h.BCGpo = 12 then 'MEDIANA EMPRESA'
                 when h.BCGpo = 13 then 'PEQUEÑA EMPRESA'
               end PRODUCTO,

             (select f4.tonom 
                from fst004 f4 
               where f4.modulo  = j280.jaqy280aomod 
                 and f4.totope = j280.jaqy280aotope) MODULO_OPERACION,
             sng001ase  as CODANA,
             fn_usuario_nombre(fn_analista_credito(j280.jaqy280aomod,j280.jaqy280aosuc,j280.jaqy280aomda,
                                                   j280.jaqy280aopap,j280.jaqy280aocta,j280.jaqy280aooper,
                                                   j280.jaqy280aosbop,j280.jaqy280aotope)) ANALISTA,
             sng001usc  as CODPROMOTOR,
             fn_usuario_nombre(sng001usc) PROMOTOR,
             h.bcsdmn SALDOCAPITAL_SOLES,
             s1.sng120fval FECHA_APROBACION,
             decode(J280.JAQY280AOMDA,0,s1.sng120mcr,s1.sng120mcr*sng120tcbi ) MONTO_APROBADO,
             PERS.PEPAIS,
             pers.petdoc,
             pers.pendoc,
             (J280.JAQY280AOMOD||'-'||J280.JAQY280AOSUC||'-'||J280.JAQY280AOMDA||'-'||J280.JAQY280AOPAP||'-'||
              J280.JAQY280AOCTA||'-'||J280.JAQY280AOOPER||'-'||J280.JAQY280AOSBOP||'-'||J280.JAQY280AOTOPE) NUMCRES_OTOR3,
             J280.JAQY280AOFVAL,
             J280.JAQY280AOSTAT,
             (     select count(*)
                      from fsr008 cta , fsd010 pre
                     where cta.pepais = pers.pepais
                       and cta.petdoc = pers.petdoc
                       and cta.pendoc = pers.pendoc
                       and cta.ctnro  = pre.aocta
                       and pre.pgcod = 1
                       and cta.ttcod = 1
                       and cta.cttfir = 'T'
                       and pre.aomod in (select modulo
                                           from fst111 a
                                          where a.dscod = 50
                                            and modulo not in (120, 29 )
                                          union all
                                         select modulo
                                           from fst003
                                          where modulo in (117,141))
              ) cantidad,

              (
                 Select /*+choose*/max(j.aofe99 /*j.scfulm*/) --scfvto
              from fsd010 j
              where j.aocta = J280.JAQY280AOCTA
                and j.pgcod = 1
                and ( j.aomod in (select modulo from fst111 where dscod = 50 )  or j.aomod = 117 )
                and j.aomod <>108
                and j.aostat = 99--cancelado
                --and substr(j.scrub,1,4) in (1411,1414,1415,1416, 1421,1424,1425,1426)
             ) fecult_cancela,
             (      case when j280.jaqy280aomod in (116, 117)  then 1 else 0 end  ) revolvente
        from JAQY280 j280,
             --fsd011 f,
             --fst001 b,
             fst811 r,
             FST001 age,
             fst810 r2,
             fsr008 pers,
             sng001 s,
             fsh012 h,
             sng120 s1

       where /*b.pgcod = j280.jaqy280pgcod
         and b.sucurs= j280.jaqy280aosuc
         and */r.pgcod = 1 
         and r.oficod = j280.jaqy280aosuc
         and r.RegCod < 100
         and age.Pgcod  = 1 
         and age.Sucurs = j280.jaqy280aosuc
         and r2.regcod = r.regcod
         and r2.regcod<100
         and pers.ctnro = j280.jaqy280aocta
         and pers.ttcod = 1
         and pers.CTTFIR = 'T'
         and s.sng001emp = r.pgcod
         and s.sng015cod = 1
         and s.sng001cta = j280.jaqy280aocta
         and s.sng001inst = j280.jaqy280inst
         and h.bcemp = j280.jaqy280pgcod
         and h.bcmod = j280.jaqy280aomod
         and h.bcsuc = j280.jaqy280aosuc
         and h.bcmda = j280.jaqy280aomda
         and h.bcpap = j280.jaqy280aopap
         and h.bccta = j280.jaqy280aocta
         and h.bcoper= j280.jaqy280aooper
         and h.bcsbop= j280.jaqy280aosbop
         and h.bctop = j280.jaqy280aotope
         and h.bcfech = pd_fecfin
         and s1.sng120ins = j280.jaqy280inst
         and s1.sng120tsk = 'APROBACION');
  commit;
  end;
  
  
End SP_CR_PROMOTORES;
end PQ_PROMOTORES_CREDITO;
/

