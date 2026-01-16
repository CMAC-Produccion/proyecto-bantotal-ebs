create or replace package PQ_POLIZA_DESGRAVAMEN is

  -- Author  : ABERNEDO
  -- Created : 16/01/2014 09:50:23 a.m.
  -- MODIFICADO : DCASTRO/YYAMPI  22/10/2021


  PROCEDURE SP_DESGRAVAMEN(PD_FECHA  DATE,
                           PN_TIPCAM NUMBER,
                           PN_TOPE1  NUMBER,
                           PN_TOPE2  NUMBER,
                           PN_TOPE3  NUMBER,
                           PN_TOPE4  NUMBER);
  function fn_cr_years(P_D_FECPRO in date, P_D_FECNAC in date) return number;
  function fn_tipo_rep(pcnomr   in varchar2,
                       fec_nac  in date,
                       PD_FECHA in date) return varchar2;
  function fn_nomtit(PD_PAIS in number,
                     PD_TDOC in NUMBER,
                     PD_NDOC in number) return varchar2;
  Procedure sp_fsr011buscar(ln_pgcod  in number,
                            ln_aomod  in number,
                            ln_aosuc  in number,
                            ln_aomda  in number,
                            ln_aopap  in number,
                            ln_aocta  in number,
                            ln_aooper in number,
                            ln_aosbop in number,
                            ln_tope   in number,
                            ln_result out number);
  Procedure recorrerData(ln_result out number);
end PQ_POLIZA_DESGRAVAMEN;
/
create or replace package body PQ_POLIZA_DESGRAVAMEN is
 -- *****************************************************************
    -- Nombre                     : PAQUETE GENERA TRAMA GRUPAL DESGRAVAMEN
    -- Sistema                    : BANTOTAL
    -- M dulo                     : Cr ditos - Activas
    -- Versi n                    : 1.0
    -- Fecha de Creaci n          : 16/01/2014 09:50:23 a.m.
    -- Autor de Creaci n          : Avernedo
    -- Modificacion               : DCASTRO/YYAMPI  22/10/2021
    -- Estado                     : Activo
    -- Acceso                     : P blico
    -- Modificacion               : 10/12/2025 SMARQUEZ GRUPAL- ADICION PARA TOMAR CREDITOS SIN SEGURO
    --                              RS SBS N  890-2025
    -- *****************************************************************
  PROCEDURE SP_DESGRAVAMEN(PD_FECHA  DATE,
                           PN_TIPCAM NUMBER,
                           PN_TOPE1  NUMBER,
                           PN_TOPE2  NUMBER,
                           PN_TOPE3  NUMBER,
                           PN_TOPE4  NUMBER) Is

    LD_FECHADESGRA DATE; -- gcarranzas 10052021

    cursor datos_ha_procesar is
      select /*+parallel(t_hist,4) parallel(t_agen,4) parallel(t_rela,4) parallel(t_age1,4)
                                     parallel(t_rel1,4) parallel(t_pers,4) parallel(t_iden,4) parallel(t_cred,4)
                                     parallel(t_rubr,4) parallel(t_pena,4) parallel(t_relj,4) parallel(t_peju,4)*/
       t_hist.bcrubr,
       t_rubr.pcnomr,
       t_hist.bccta CTA_CLIENTE,
       t_hist.bcoper OPERACION,
       t_iden.penom TITULAR,
       t_pers.petdoc,
       t_pers.pendoc,
       t_pena.pffnac,
       (select t_fecju.PFFNAC
          from fsd002 t_fecju
         where t_fecju.PFPAIS = t_relj.PFPAI1
           and t_fecju.PFTDOC = t_relj.PFTDO1
           and t_fecju.PFNDOC = t_relj.PFNDO1) pjfnac,
       t_peju.njcod,
       --t_cred.aofval FEC_DES,
       nvl(t_cred.aofval , t_hist.BCFVAL) FEC_DES, ---- 21/10/2021
        /*case  ---- 21/10/2021
         when t_hist.bcmda = 0 then
          NVL(t_cred.aoimp, 0)
         else
          NVL(t_cred.aoimp, 0) * PN_TIPCAM
       end Mto_Apr, ---------->>>>>>>>>>>>>>>>>>ACTUALIZAR IMPORTE DE MINIMA OPERACION DE CREDITOS QUE NO TIENEN IMPORTE
       */
       case  ---- 21/10/2021
           when t_cred.aocta is null then
                    (SELECT decode( f.aomda, 0 ,f.aoimp ,  f.aoimp * PN_TIPCAM )
                FROM fsd010 f where f.aocta = t_hist.bccta and f.aooper =  t_hist.bcoper and f.aomod in
                (select modulo from fst111 where dscod = 50)  and f.aostat <> 99 and rownum = 1)

           else
               case
                 when t_hist.bcmda = 0 then
                  t_cred.aoimp
                 else
                  t_cred.aoimp * PN_TIPCAM
               end
         end Mto_Apr,  ---- 21/10/2021
       case
         when t_hist.bcmda = 0 then
          t_hist.bcsdmo
         else
          t_hist.bcsdmo * PN_TIPCAM
       end Saldo,
       case
         when t_hist.bcmda = 0 then
          t_hist.bcsdmo
         else
          t_hist.bcsdmo * PN_TIPCAM
       end Cobert,
       t_hist.bcsuc,
       t_pers.PEPAIS,
       t_hist.BCMDA,
       t_hist.BCSDMO,
       t_iden.petipo,
       t_hist.bcplaz,
       (lpad(to_char(t_hist.bcmod), 3, '0') ||
       lpad(to_char(t_hist.bcsuc), 3, '0') ||
       lpad(to_char(t_hist.bcmda), 3, '0') ||
       lpad(to_char(t_hist.bcpap), 3, '0') ||
       lpad(to_char(t_hist.bccta), 9, '0') ||
       lpad(to_char(t_hist.bcoper), 9, '0') ||
       lpad(to_char(t_hist.bcsbop), 3, '0') ||
       lpad(to_char(t_hist.bctop), 3, '0')) valores,
       nvl(t_cred.pgcod,t_hist.BCEMP) pgcod, ---21/10/2021
       nvl(t_cred.aomod,t_hist.BCMOD) aomod, ---21/10/2021
       nvl(t_cred.aosuc,t_hist.BCSUC) aosuc, ---21/10/2021
       nvl(t_cred.aomda,t_hist.BCMDA) aomda, ---21/10/2021
       nvl(t_cred.aopap,t_hist.BCPAP) aopap, ---21/10/2021
       nvl(t_cred.aocta,t_hist.BCCTA) aocta,---21/10/2021
       nvl(t_cred.aooper,t_hist.BCOPER) aooper, ---21/10/2021
       nvl(t_cred.aosbop,t_hist.BCSBOP) aosbop, ---21/10/2021
       nvl(t_cred.aotope,t_hist.BCTOP) aotope, ---21/10/2021
       --t_cred.aostat             --gcarranzas 10052021
       t_hist.bcprod aostat --gcarranzas 10052021 -- Se agrego el estado del historico para obtener el ultimo estado del credito
      --to_char(t_hist.bcmod||t_hist.bcsuc||t_hist.bcmda||t_hist.bcpap||t_hist.bccta||t_hist.bcoper||
      --t_hist.bcsbop||t_hist.bctop)
        from --fsh012 t_hist,
             fsh012 t_hist,
             fst001 t_agen,
             fst811 t_rela,
             fst001 t_age1,
             fst810 t_rel1,
             fsr008 t_pers,
             fsd001 t_iden,
             fsd010 t_cred,
             fsd014 t_rubr,
             fsd002 t_pena,
             fsr003 t_relj,
             fsd003 t_peju
       where t_hist.bccta <> 999999999
         and substr(t_hist.bcrubr, 1, 4) in
             (1411, 1414, 1415, 1416, 1421, 1424, 1425, 1426)
         and t_hist.bcmod not in (33, 141, 108, 232)
         and ((-1) * t_hist.bcsdmo) > 0
         and t_agen.pgcod = t_hist.bcemp
         and t_agen.sucurs = t_hist.bcsuc
         and t_hist.bcfech = PD_FECHA
         and t_rela.pgcod = 1
         and t_rela.oficod = t_hist.bcsuc
         and t_rela.RegCod < 100
         and t_age1.Pgcod = 1
         and t_age1.Sucurs = t_hist.bcsuc
         and t_rel1.regcod = t_rela.regcod
         and t_rel1.regcod < 100
         and t_pers.ctnro = t_hist.bccta
         and t_pers.ttcod = 1
         and t_pers.CTTFIR = 'T'
         and t_iden.pepais = t_pers.pepais
         and t_iden.petdoc = t_pers.petdoc
         and t_iden.pendoc = t_pers.pendoc
         and t_rubr.rubro = t_hist.bcrubr
         --and t_cred.aomod in (select modulo from fst111 where dscod = 50) -- modficado29012018
             and t_hist.BCMOD in (select modulo from fst111 where dscod = 50) ---- 21/10/2021-- modficado29012018
            --and (t_cred.aofval > '02/11/2015') -- modficado29012018  --gcarranzas 26042021
            --AND t_cred.aostat <> 99 -- modficado29012018 --gcarranzas 10052021
            --and t_cred.aostat in (select fst198.tp1nro1 from fst198 where fst198.tp1cod1=11109 and fst198.tp1corr1=3) --gcarranzas 10052021
            --gcarranzas 10052021 ****** INICIO --
         AND (
           /*  --NO cancelados Y ESTADOS EN GUIA
              (t_cred.aostat <> 99 AND
              t_cred.aostat in
              (select fst198.tp1nro1
                  from fst198
                 where fst198.tp1cod = 1
                   and fst198.tp1cod1 = 11109
                   and fst198.tp1corr1 = 3))
             -- o cancelados pero despues del mes consultado Y CON EL ULTIMO ESTADO EN GUIA
              OR (t_cred.aostat = 99 AND t_cred.aofe99 > PD_FECHA AND*/ --10/10/2021
              T_HIST.BCPROD IN
              (select fst198.tp1nro1
                     from fst198
                    where fst198.tp1cod = 1
                      and fst198.tp1cod1 = 11109
                      and fst198.tp1corr1 = 3)) -- ) --10/10/2021
            --gcarranzas 10052021 ****** FIN --
         and t_cred.pgcod(+) = t_hist.bcemp  ---21/10/2021
         and t_cred.aomod(+) = t_hist.bcmod  ---21/10/2021
            --and t_cred.aosuc              = t_hist.bcsuc
         ------------Refinanciado
         and t_cred.aomda(+) = t_hist.bcmda  ---21/10/2021
         and t_cred.aopap(+) = t_hist.bcpap  ---21/10/2021
         and t_cred.aocta(+) = t_hist.bccta  ---21/10/2021
         and t_cred.aooper(+) = t_hist.bcoper  ---21/10/2021
         and t_cred.aosbop(+) = t_hist.bcsbop  ---21/10/2021      --10/10/2021 se descomento
         and t_cred.aotope(+) = t_hist.bctop   ---21/10/2021
         and t_pena.pfpais(+) = t_pers.pepais
         and t_pena.pftdoc(+) = t_pers.petdoc
         and t_pena.pfndoc(+) = t_pers.pendoc
         and t_peju.pjpais(+) = t_pers.pepais
         and t_peju.pjtdoc(+) = t_pers.petdoc
         and t_peju.pjndoc(+) = t_pers.pendoc
         and t_relj.pjpais(+) = t_pers.pepais
         and t_relj.pjtdoc(+) = t_pers.petdoc
         and t_relj.pjndoc(+) = t_pers.pendoc
            ------------Refinanciado
            /* and t_cred.pgcod =  t_relcod.r1cod
            and t_cred.aomod =  t_relcod.r1mod
            and t_cred.aosuc =  t_relcod.r1suc
            and t_cred.aomda =  t_relcod.r1mda
            and t_cred.aopap =  t_relcod.r1pap
            and t_cred.aocta =  t_relcod.r1cta
            and t_cred.aooper = t_relcod.r1oper
            and t_cred.aosbop = t_relcod.r1sbop
            and t_cred.aotope = t_relcod.r1tope*/
            ------------Refinanciado
         and not exists
       (SELECT P.AOMOD, P.AOSUC, P.AOCTA, P.AOOPER, P.AOSBOP, P.AOTOPE
                FROM FPP001 P
               WHERE P.SGCOD in (select tp1imp1
                                   from fst198
                                  where tp1cod = 1
                                    and tp1cod1 = 10898
                                    and tp1corr1 = 8)
                 and p.pgcod = t_hist.bcemp
                 and p.aomod = t_hist.bcmod
                    --and p.aosuc  = t_hist.bcsuc
                 and p.aomda = t_hist.bcmda
                 and p.aopap = t_hist.bcpap
                 and p.aocta = t_hist.bccta
                 and p.aooper = t_hist.bcoper
                 and p.aosbop = t_hist.bcsbop
                 and p.aotope = t_hist.bctop)
            --gcarranzas 26042021 ****** INICIO --
         and (
             --Creditos con fecha valor mayor a 2 DE noviembre a 2015
--              t_cred.aofval >= LD_FECHADESGRA -- gcarranzas 10052021
              nvl(t_cred.aofval, t_hist.BCFVAL ) >= LD_FECHADESGRA -- ---21/10/2021 gcarranzas 10052021
             --O mayor a noviembre del 2015 en todas las suboperaciones
              OR exists (select pgcod,
                                aomod,
                                aosuc,
                                aomda,
                                aopap,
                                aocta,
                                aooper,
                                aotope,
                                min(aofval) fechaDes
                           from fsd010 f
                          where f.pgcod = t_cred.pgcod
                            and f.aomod = t_cred.aomod
                               --and f.aosuc = t_cred.aosuc
                            and f.aomda = t_cred.aomda
                            and f.aopap = t_cred.aopap
                            and f.aocta = t_cred.aocta
                            and f.aooper = t_cred.aooper
                            and f.aotope = t_cred.aotope
                            and f.aofval >= LD_FECHADESGRA
                          group by f.pgcod,
                                   f.aomod,
                                   f.aosuc,
                                   f.aomda,
                                   f.aopap,
                                   f.aocta,
                                   f.aooper,
                                   f.aotope)
             ---o CREDITOS desdolarizados CON FECHA DE CREDITO EN DOLARES DESPUES de noviembre del 2015
              OR exists (select f.pgcod,
                                f.aomod,
                                f.aosuc,
                                f.aomda,
                                f.aopap,
                                f.aocta,
                                f.aooper,
                                --aosbop,
                                f.aotope,
                                min(f.aofval) fechaDes
                           from fsd010 f, fsd010 dd
                          where dd.aocta = t_cred.aocta
                            and dd.aooper = t_cred.aooper
                            and f.pgcod = dd.pgcod
                            and f.aomod = dd.aomod
                               --and f.aosuc = dd.aosuc
                            and f.aomda = 101
                            and dd.aomda = 0
                            and f.aopap = dd.aopap
                            and f.aocta = dd.aocta
                            and f.aotope = dd.aotope
                            and f.aostat = 99
                            and f.aofe99 = dd.aofval
                            and f.aofval >= LD_FECHADESGRA
                          group by f.pgcod,
                                   f.aomod,
                                   f.aosuc,
                                   f.aomda,
                                   f.aopap,
                                   f.aocta,
                                   f.aooper,
                                   f.aotope) --desdolarizacion
             )
            --gcarranzas 26042021 ****** FIN
---             and t_cred.aocta = 312841 and t_cred.aooper = 6593138  se comento
       order by t_hist.bcrubr, t_rubr.pcnomr, t_hist.bccta;

    VALORES       NUMBER;
    control       number;
    evaluar       number;
    fechaestatica date;
    fechaevaluar  date;
    ln_result     number;
    flagE         char(1);

  BEGIN
    execute immediate ('truncate table Seg_Desgrav2');
    execute immediate ('truncate table Segu_Final');
    execute immediate ('truncate table TotCred');
    execute immediate ('truncate table Seg_Rangos');
    execute immediate ('truncate table JAQY522');
    execute immediate ('truncate table JAQY523');
    execute immediate ('truncate table JAQY524');
    execute immediate ('truncate table JAQY525');

    BEGIN
      LD_FECHADESGRA := TO_DATE('03/11/2015', 'DD/MM/YYYY'); -- gcarranzas 10052021

      /*begin
         select g.cotcbi
             into PN_TIPCAM
             from fsh005 g
            where g.moneda = 101
              and g.cofdes = PD_FECHA;
         exception
           when no_data_found then
             BEGIN
              select g.cotcbi
                 into PN_TIPCAM
                from fsh005 g
               where g.moneda = 101
                 and g.cofdes = PD_FECHA - 1;
              exception
                 When others then
                      PN_TIPCAM:=1;
              END;
           when others then
             PN_TIPCAM:=1;
      end;*/

      /*update fst098 set tpnro = 1 where tpcod =9838;
      COMMIT;  */

      INSERT INTO Seg_Desgrav2
        (bcrubr,
         pcnomr,
         CTA_CLIENTE,
         OPERACION,
         TITULAR,
         petdoc,
         pendoc,
         pffnac,
         pjfnac,
         njcod,
         FEC_DES,
         Mto_Apr,
         Saldo,
         Cobert,
         bcsuc,
         Pepais,
         Bcmda,
         Bcsdmo,
         PETIPO,
         Bcplaz,
         Nro_Cred)

        select /*+parallel(t_hist,4) parallel(t_agen,4) parallel(t_rela,4) parallel(t_age1,4)
                                                                                                                   parallel(t_rel1,4) parallel(t_pers,4) parallel(t_iden,4) parallel(t_cred,4)
                                                                                                                   parallel(t_rubr,4) parallel(t_pena,4) parallel(t_relj,4) parallel(t_peju,4)*/
         t_hist.bcrubr,
         t_rubr.pcnomr,
         t_hist.bccta  CTA_CLIENTE,
         t_hist.bcoper OPERACION,
         t_iden.penom  TITULAR,
         t_pers.petdoc,
         t_pers.pendoc,
         t_pena.pffnac,

         (select t_fecju.PFFNAC
            from fsd002 t_fecju
           where t_fecju.PFPAIS = t_relj.PFPAI1
             and t_fecju.PFTDOC = t_relj.PFTDO1
             and t_fecju.PFNDOC = t_relj.PFNDO1) pjfnac,
         t_peju.njcod,
         nvl(t_cred.aofval , t_hist.BCFVAL) FEC_DES, -------------------21/10/2021
        /* case
           when t_hist.bcmda = 0 then
            NVL(t_cred.aoimp, 0) -------------------21/10/2021
           else
            NVL(t_cred.aoimp, 0) * PN_TIPCAM -------------------21/10/2021
         end Mto_Apr,
         */
         case  ---- 21/10/2021
           when t_cred.aocta is null then
                    (SELECT decode( f.aomda, 0 ,f.aoimp ,  f.aoimp * PN_TIPCAM )
                FROM fsd010 f where f.aocta = t_hist.bccta and f.aooper =  t_hist.bcoper and f.aomod in
                (select modulo from fst111 where dscod = 50)  and f.aostat <> 99
                 and rownum = 1)

           else
               case
                 when t_hist.bcmda = 0 then
                  t_cred.aoimp
                 else
                  t_cred.aoimp * PN_TIPCAM
               end
         end Mto_Apr,
         case
           when t_hist.bcmda = 0 then
            t_hist.bcsdmo
           else
            t_hist.bcsdmo * PN_TIPCAM
         end Saldo,
         case
           when t_hist.bcmda = 0 then
            t_hist.bcsdmo
           else
            t_hist.bcsdmo * PN_TIPCAM
         end Cobert,
         t_hist.bcsuc,
         t_pers.PEPAIS,
         t_hist.BCMDA,
         t_hist.BCSDMO,
         t_iden.petipo,
         t_hist.bcplaz,
         lpad(to_char(t_hist.bcmod), 3, '0') ||
         lpad(to_char(t_hist.bcsuc), 3, '0') ||
         lpad(to_char(t_hist.bcmda), 3, '0') ||
         lpad(to_char(t_hist.bcpap), 3, '0') ||
         lpad(to_char(t_hist.bccta), 9, '0') ||
         lpad(to_char(t_hist.bcoper), 9, '0') ||
         lpad(to_char(t_hist.bcsbop), 3, '0') ||
         lpad(to_char(t_hist.bctop), 3, '0')

        --to_char(t_hist.bcmod||t_hist.bcsuc||t_hist.bcmda||t_hist.bcpap||t_hist.bccta||t_hist.bcoper||
        --t_hist.bcsbop||t_hist.bctop)
          from --fsh012 t_hist,
               fsh012 t_hist,
               fst001 t_agen,
               fst811 t_rela,
               fst001 t_age1,
               fst810 t_rel1,
               fsr008 t_pers,
               fsd001 t_iden,
               fsd010 t_cred,
               fsd014 t_rubr,
               fsd002 t_pena,
               fsr003 t_relj,
               fsd003 t_peju
         where t_hist.bccta <> 999999999
           and substr(t_hist.bcrubr, 1, 4) in
               (1411, 1414, 1415, 1416, 1421, 1424, 1425, 1426)
           and t_hist.bcmod not in (33, 141, 108, 232)
           and ((-1) * t_hist.bcsdmo) > 0
           and t_agen.pgcod = t_hist.bcemp
           and t_agen.sucurs = t_hist.bcsuc
           and t_hist.bcfech = PD_FECHA
           and t_rela.pgcod = 1
           and t_rela.oficod = t_hist.bcsuc
           and t_rela.RegCod < 100
           and t_age1.Pgcod = 1
           and t_age1.Sucurs = t_hist.bcsuc
           and t_rel1.regcod = t_rela.regcod
           and t_rel1.regcod < 100
           and t_pers.ctnro = t_hist.bccta
           and t_pers.ttcod = 1
           and t_pers.CTTFIR = 'T'
           and t_iden.pepais = t_pers.pepais
           and t_iden.petdoc = t_pers.petdoc
           and t_iden.pendoc = t_pers.pendoc
           and t_rubr.rubro = t_hist.bcrubr
--           and t_cred.aomod in (select modulo from fst111 where dscod = 50) -- modficado29012018
           and t_hist.BCMOD in (select modulo from fst111 where dscod = 50) ---- 21/10/2021-- modficado29012018

              --and (t_cred.aofval < '03/11/2015' OR (t_cred.aomod = 116 and t_cred.aostat <> 99)) -- modficado29012018  --gcarranzas 10052021
              --AND t_cred.aostat <> 99 -- modficado29012018 --gcarranzas 10052021
              --gcarranzas 10052021 ****** INICIO --
           AND (
               /*--NO cancelados
                t_cred.aostat <> 99
               -- o cancelados pero despues del mes consultado
                OR (t_cred.aostat = 99 AND t_cred.aofe99 > PD_FECHA AND */ --10/10/2021
                T_HIST.BCPROD <> 99) -- )
              --gcarranzas 10052021 ****** FIN --
           and t_cred.pgcod(+) = t_hist.bcemp  ---21/10/2021
           and t_cred.aomod(+) = t_hist.bcmod  ---21/10/2021
              ------------Refinanciado
           and t_cred.aomda(+) = t_hist.bcmda  ---21/10/2021
           and t_cred.aopap(+) = t_hist.bcpap  ---21/10/2021
           and t_cred.aocta(+) = t_hist.bccta  ---21/10/2021
           and t_cred.aooper(+) = t_hist.bcoper  ---21/10/2021
           and t_cred.aosbop(+) = t_hist.bcsbop  ---21/10/2021      --10/10/2021 se descomento
           and t_cred.aotope(+) = t_hist.bctop   ---21/10/2021
           and t_pena.pfpais(+) = t_pers.pepais
           and t_pena.pftdoc(+) = t_pers.petdoc
           and t_pena.pfndoc(+) = t_pers.pendoc
           and t_peju.pjpais(+) = t_pers.pepais
           and t_peju.pjtdoc(+) = t_pers.petdoc
           and t_peju.pjndoc(+) = t_pers.pendoc
           and t_relj.pjpais(+) = t_pers.pepais
           and t_relj.pjtdoc(+) = t_pers.petdoc
           and t_relj.pjndoc(+) = t_pers.pendoc
           and not exists
         (SELECT P.AOMOD,
                       P.AOSUC,
                       P.AOCTA,
                       P.AOOPER,
                       P.AOSBOP,
                       P.AOTOPE
                  FROM FPP001 P
                 WHERE P.SGCOD in (select tp1imp1
                                     from fst198
                                    where tp1cod = 1
                                      and tp1cod1 = 10898
                                      and tp1corr1 = 8)
                   and p.pgcod = t_hist.bcemp
                   and p.aomod = t_hist.bcmod
                      --and p.aosuc  = t_hist.bcsuc
                   and p.aomda = t_hist.bcmda
                   and p.aopap = t_hist.bcpap
                   and p.aocta = t_hist.bccta
                   and p.aooper = t_hist.bcoper
                   and p.aosbop = t_hist.bcsbop
                   and p.aotope = t_hist.bctop)
              --gcarranzas 23042021***fecha menores a 03/11/2015
           and (
               -- FECHA VALOR MENOR A 3 DE NOVIEMBRE 2015
              --  t_cred.aofval < LD_FECHADESGRA
                nvl(t_cred.aofval, t_hist.BCFVAL ) < LD_FECHADESGRA ---21/10/2021 -- gcarranzas 10052021
               --O TODOS LOS CREDITOS CON MODULO 116
                OR nvl(t_cred.aomod, t_hist.bcmod) = 116 -- 21/10/2021
               --creditos antes de noviembre 2015 en todas las suboperaciones
                OR exists (select pgcod,
                                  aomod,
                                  aosuc,
                                  aomda,
                                  aopap,
                                  aocta,
                                  aooper,
                                  aotope,
                                  min(aofval) fechaDes
                             from fsd010 f
                            where f.pgcod = t_cred.pgcod
                              and f.aomod = t_cred.aomod
                                 --and f.aosuc = t_cred.aosuc
                              and f.aomda = t_cred.aomda
                              and f.aopap = t_cred.aopap
                              and f.aocta = t_cred.aocta
                              and f.aooper = t_cred.aooper
                              and f.aotope = t_cred.aotope
                              and f.aofval < LD_FECHADESGRA
                            group by f.pgcod,
                                     f.aomod,
                                     f.aosuc,
                                     f.aomda,
                                     f.aopap,
                                     f.aocta,
                                     f.aooper,
                                     f.aotope)
               ---o CREDITOS desdolarizados CON FECHA DE CREDITO EN DOLARES antes de noviembre del 2015
                OR exists (select f.pgcod,
                                  f.aomod,
                                  f.aosuc,
                                  f.aomda,
                                  f.aopap,
                                  f.aocta,
                                  f.aooper,
                                  --aosbop,
                                  f.aotope,
                                  min(f.aofval) fechaDes
                             from fsd010 f, fsd010 dd
                            where dd.aocta = t_cred.aocta
                              and dd.aooper = t_cred.aooper
                              and f.pgcod = dd.pgcod
                              and f.aomod = dd.aomod
                                 --and f.aosuc = dd.aosuc
                              and f.aomda = 101
                              and dd.aomda = 0
                              and f.aopap = dd.aopap
                              and f.aocta = dd.aocta
                              and f.aotope = dd.aotope
                              and f.aostat = 99
                              and f.aofe99 = dd.aofval
                              and f.aofval < LD_FECHADESGRA
                            group by f.pgcod,
                                     f.aomod,
                                     f.aosuc,
                                     f.aomda,
                                     f.aopap,
                                     f.aocta,
                                     f.aooper,
                                     f.aotope) --desdolarizacion
               )
              --gcarranzas 23042021******fin

         order by t_hist.bcrubr, t_rubr.pcnomr, t_hist.bccta;

      commit;
      ----------------------------------------------------------------------------------------------------------------
      ----------------------------------------------------------------------------------------------------------------

      for j in datos_ha_procesar loop
        control       := 0;
        evaluar       := 0;
        fechaestatica := '03/11/2015';
        fechaevaluar  := '01/01/0001';

        if j.aostat = 61 then

          begin
            SELECT count(*)
              into control
              FROM fsr011
             where fsr011.r1cod = j.pgcod
               and fsr011.r1mod = j.aomod
               and fsr011.r1suc = j.aosuc
               and fsr011.r1mda = j.aomda
               and fsr011.r1pap = j.aopap
               and fsr011.r1cta = j.aocta
               and fsr011.r1oper = j.aooper
               and fsr011.r1sbop = j.aosbop
               and fsr011.r1tope = j.aotope
               and fsr011.relcod = 120;

          end;
        end if;
        if control < 2 and control <> 0 then
          begin
            select count(*)
              into evaluar
              from fsd010,
                   (SELECT fsr011.r2cod,
                           fsr011.r2mod,
                           fsr011.r2suc,
                           fsr011.r2mda,
                           fsr011.r2pap,
                           fsr011.r2cta,
                           fsr011.r2oper,
                           fsr011.r2sbop,
                           fsr011.r2tope
                      FROM fsr011
                     where fsr011.r1cod = j.pgcod
                       and fsr011.r1mod = j.aomod
                       and fsr011.r1suc = j.aosuc
                       and fsr011.r1mda = j.aomda
                       and fsr011.r1pap = j.aopap
                       and fsr011.r1cta = j.aocta
                       and fsr011.r1oper = j.aooper
                       and fsr011.r1sbop = j.aosbop
                       and fsr011.r1tope = j.aotope
                       and fsr011.relcod = 120) valores
             WHERE valores.r2cod = fsd010.pgcod
               and valores.r2mod = fsd010.aomod
               and valores.r2suc = fsd010.aosuc
               and valores.r2mda = fsd010.aomda
               and valores.r2pap = fsd010.aopap
               and valores.r2cta = fsd010.aocta
               and valores.r2oper = fsd010.aooper
               and valores.r2sbop = fsd010.aosbop
               and valores.r2tope = fsd010.aotope
               and fsd010.aofval < '03/11/2015';

          end;
          if evaluar > 0 and evaluar < 2 then
            INSERT INTO Seg_Desgrav2
              (bcrubr,
               pcnomr,
               CTA_CLIENTE,
               OPERACION,
               TITULAR,
               petdoc,
               pendoc,
               pffnac,
               pjfnac,
               njcod,
               FEC_DES,
               Mto_Apr,
               Saldo,
               Cobert,
               bcsuc,
               Pepais,
               Bcmda,
               Bcsdmo,
               PETIPO,
               Bcplaz,
               Nro_Cred)
            values
              (j.bcrubr,
               j.pcnomr,
               j.cta_cliente,
               j.operacion,
               j.titular,
               j.petdoc,
               j.pendoc,
               j.pffnac,
               j.pjfnac,
               j.njcod,
               j.fec_des,
               j.mto_apr,
               j.saldo,
               j.cobert,
               j.bcsuc,
               j.pepais,
               j.bcmda,
               j.bcsdmo,
               j.petipo,
               j.bcplaz,
               j.valores);

          end if;

        end if;
        if j.aostat in (33, 34) then
          begin

            PQ_POLIZA_DESGRAVAMEN.sp_fsr011buscar(j.pgcod,
                                                  j.aomod,
                                                  j.aosuc,
                                                  j.aomda,
                                                  j.aopap,
                                                  j.aocta,
                                                  j.aooper,
                                                  j.aosbop,
                                                  j.aotope,
                                                  ln_result);
            if ln_result = 1 then
              INSERT INTO Seg_Desgrav2
                (bcrubr,
                 pcnomr,
                 CTA_CLIENTE,
                 OPERACION,
                 TITULAR,
                 petdoc,
                 pendoc,
                 pffnac,
                 pjfnac,
                 njcod,
                 FEC_DES,
                 Mto_Apr,
                 Saldo,
                 Cobert,
                 bcsuc,
                 Pepais,
                 Bcmda,
                 Bcsdmo,
                 PETIPO,
                 Bcplaz,
                 Nro_Cred)
              values
                (j.bcrubr,
                 j.pcnomr,
                 j.cta_cliente,
                 j.operacion,
                 j.titular,
                 j.petdoc,
                 j.pendoc,
                 j.pffnac,
                 j.pjfnac,
                 j.njcod,
                 j.fec_des,
                 j.mto_apr,
                 j.saldo,
                 j.cobert,
                 j.bcsuc,
                 j.pepais,
                 j.bcmda,
                 j.bcsdmo,
                 j.petipo,
                 j.bcplaz,
                 j.valores);
            end if;
          end;
        end if;
        if j.aostat in (21, 22, 23, 25, 64, 90) then
          begin
            SELECT min(fsd010.aofval)
              into fechaevaluar
              FROM fsd010
             WHERE fsd010.PGCOD = j.pgcod
               and fsd010.AOCTA = j.aocta
               and fsd010.AOOPER = j.aooper
               and fsd010.aomod in
                   (select modulo from fst111 where dscod = 50); ---
          exception
            when no_data_found then
              fechaevaluar := '01/01/0001';
          end;
          /*  if j.aomod in(107,109,116) then
              INSERT INTO Seg_Desgrav2 (bcrubr,pcnomr,CTA_CLIENTE,OPERACION,TITULAR,petdoc,pendoc,pffnac,
                                    pjfnac,njcod,FEC_DES,Mto_Apr,Saldo,Cobert,bcsuc,Pepais,Bcmda,
                                    Bcsdmo,PETIPO,Bcplaz,Nro_Cred) values
                                 (j.bcrubr,j.pcnomr,j.cta_cliente,j.operacion,j.titular,
                                 j.petdoc,j.pendoc,j.pffnac,j.pjfnac,j.njcod,j.fec_des,j.mto_apr,
                                 j.saldo,j.cobert,j.bcsuc,j.pepais,j.bcmda,j.bcsdmo,j.petipo,
                                 j.bcplaz,j.valores
                                 );
          else*/

          if fechaestatica > fechaevaluar and fechaevaluar <> '01/01/0001' then
            INSERT INTO Seg_Desgrav2
              (bcrubr,
               pcnomr,
               CTA_CLIENTE,
               OPERACION,
               TITULAR,
               petdoc,
               pendoc,
               pffnac,
               pjfnac,
               njcod,
               FEC_DES,
               Mto_Apr,
               Saldo,
               Cobert,
               bcsuc,
               Pepais,
               Bcmda,
               Bcsdmo,
               PETIPO,
               Bcplaz,
               Nro_Cred)
            values
              (j.bcrubr,
               j.pcnomr,
               j.cta_cliente,
               j.operacion,
               j.titular,
               j.petdoc,
               j.pendoc,
               j.pffnac,
               j.pjfnac,
               j.njcod,
               j.fec_des,
               j.mto_apr,
               j.saldo,
               j.cobert,
               j.bcsuc,
               j.pepais,
               j.bcmda,
               j.bcsdmo,
               j.petipo,
               j.bcplaz,
               j.valores);
          end if;
          /*  end if;  */

        end if;
        if j.aomod in (107, 109, 116) AND J.AOSTAT <> 99 then
          INSERT INTO Seg_Desgrav2
            (bcrubr,
             pcnomr,
             CTA_CLIENTE,
             OPERACION,
             TITULAR,
             petdoc,
             pendoc,
             pffnac,
             pjfnac,
             njcod,
             FEC_DES,
             Mto_Apr,
             Saldo,
             Cobert,
             bcsuc,
             Pepais,
             Bcmda,
             Bcsdmo,
             PETIPO,
             Bcplaz,
             Nro_Cred)
          values
            (j.bcrubr,
             j.pcnomr,
             j.cta_cliente,
             j.operacion,
             j.titular,
             j.petdoc,
             j.pendoc,
             j.pffnac,
             j.pjfnac,
             j.njcod,
             j.fec_des,
             j.mto_apr,
             j.saldo,
             j.cobert,
             j.bcsuc,
             j.pepais,
             j.bcmda,
             j.bcsdmo,
             j.petipo,
             j.bcplaz,
             j.valores);
          /* else

           if fechaestatica> fechaevaluar and fechaevaluar<> '01/01/0001' then
                  INSERT INTO Seg_Desgrav2 (bcrubr,pcnomr,CTA_CLIENTE,OPERACION,TITULAR,petdoc,pendoc,pffnac,
                                    pjfnac,njcod,FEC_DES,Mto_Apr,Saldo,Cobert,bcsuc,Pepais,Bcmda,
                                    Bcsdmo,PETIPO,Bcplaz,Nro_Cred) values
                                 (j.bcrubr,j.pcnomr,j.cta_cliente,j.operacion,j.titular,
                                 j.petdoc,j.pendoc,j.pffnac,j.pjfnac,j.njcod,j.fec_des,j.mto_apr,
                                 j.saldo,j.cobert,j.bcsuc,j.pepais,j.bcmda,j.bcsdmo,j.petipo,
                                 j.bcplaz,j.valores
                                 );
          end if ;  */
        end if;
        --------------------- SMARQUEZ 10/12/2025 -----------------------
        BEgin
          select 'S'
            into flagE
            from jaqm8f
           where jaqm8fins = (select xwfprcins
                                from xwf700
                               where xwfempresa = 1
                                 and xwfcuenta = j.aocta
                                 and xwfoperacion = j.aooper
                                 and xwfcar3 ='1')
              and jaqm8fval = 'N';
        exception
          when others then
            begin
              SELECT 'N'
                into flagE
                FROM FPP001 
               WHERE pgcod = 1
                 and aomod = j.aomod
                 and aomda = j.aomda
                 and aopap = j.aopap
                 and aocta = j.aocta
                 and aooper = j.aooper
                 and aosbop = j.aosbop
                 and aotope = j.aotope
                 and sgcod in (select tp1imp1
                                   from fst198
                                  where tp1cod = 1
                                    and tp1cod1 = 10898
                                    and tp1corr1 = 8);
            exception
              when no_data_found  then
                flagE :='S';                
            end;
        end;
        if FlagE = 'S' then
          INSERT INTO Seg_Desgrav2
            (bcrubr,
             pcnomr,
             CTA_CLIENTE,
             OPERACION,
             TITULAR,
             petdoc,
             pendoc,
             pffnac,
             pjfnac,
             njcod,
             FEC_DES,
             Mto_Apr,
             Saldo,
             Cobert,
             bcsuc,
             Pepais,
             Bcmda,
             Bcsdmo,
             PETIPO,
             Bcplaz,
             Nro_Cred)
          values
            (j.bcrubr,
             j.pcnomr,
             j.cta_cliente,
             j.operacion,
             j.titular,
             j.petdoc,
             j.pendoc,
             j.pffnac,
             j.pjfnac,
             j.njcod,
             j.fec_des,
             j.mto_apr,
             j.saldo,
             j.cobert,
             j.bcsuc,
             j.pepais,
             j.bcmda,
             j.bcsdmo,
             j.petipo,
             j.bcplaz,
             j.valores);
        end if;
        -----------------------------------------------------
      end loop;
      ----------------------------------------------------------------------------------------------------------------

      INSERT INTO Segu_Final
        (Estado,
         bcrubr,
         pcnomr,
         cta_cliente,
         titular,
         operacion,
         Tip_Per,
         Tip_Doc,
         pendoc,
         Fec_Nac,
         fec_des,
         mto_apr,
         saldo,
         cobert,
         Pepais,
         Petdoc,
         Bcmda,
         Bcsdmo,
         Agencia,
         Petipo,
         Bcplaz,
         Nro_Cred)
        select case
                 when substr(t_base.bcrubr, 1, 4) in ('1411', '1421') then
                  'VIGENTE'
                 when substr(t_base.bcrubr, 1, 4) in ('1415', '1425') then
                  'VENCIDO'
                 when substr(t_base.bcrubr, 1, 4) in ('1414', '1424') then
                  'REFINANCIADO'
                 when substr(t_base.bcrubr, 1, 4) in ('1416', '1426') then
                  'JUDICIAL'
               end Estado,
               t_base.bcrubr,
               t_base.pcnomr,
               t_base.cta_cliente,
               t_base.titular,
               t_base.operacion,
               case
                 when t_base.petdoc = 21 then
                  'NATURAL'
                 when t_base.petdoc = 9 then
                  'EIRL'
               end Tip_Per,
               case
                 when t_base.petdoc = 21 then
                  'DNI'
                 when t_base.petdoc = 9 then
                  'RUC'
               end Tip_Doc,
               t_base.pendoc,
               case
                 when t_base.petdoc = 21 then
                  t_base.pffnac
                 when t_base.petdoc = 9 then
                  t_base.pjfnac
               end Fec_Nac,
               t_base.fec_des,
               t_base.mto_apr,
               (-1) * t_base.saldo saldo,
               (-1) * t_base.cobert cobert,
               t_base.pepais,
               t_base.petdoc,
               t_base.bcmda,
               (-1) * t_base.bcsdmo,
               (select suc.SCNOM
                  from fst001 suc
                 where suc.SUCURS = t_base.bcsuc),
               t_base.petipo,
               t_base.bcplaz,
               t_base.nro_cred
          from Seg_Desgrav2 t_base
         where t_base.BCSUC <= 200
           and t_base.petdoc = 21
            or (t_base.petdoc = 9 and t_base.njcod = 7);
      --                      or (t_base.petdoc =  9 and t_base.njcod = 14);

      INSERT INTO TotCred
        ( /*cta_cliente,*/titular,
         tip_per,
         tip_doc,
         pendoc,
         fec_nac,
         Sal_Cli,
         Apr_Cli)
        select --t_segu.cta_cliente,
         t_segu.titular,
         t_segu.tip_per,
         t_segu.tip_doc,
         t_segu.pendoc,
         t_segu.fec_nac,
         sum(t_segu.saldo) Sal_Cli,
         sum(t_segu.mto_apr) Apr_Cli
          from Segu_Final t_segu
         group by --t_segu.cta_cliente,
                  t_segu.titular,
                  t_segu.tip_per,
                  t_segu.tip_doc,
                  t_segu.pendoc,
                  t_segu.fec_nac;

      COMMIT;

      ---------------------------------------------------- RESUMIDOS ----------------------------------------------

      INSERT INTO Seg_Rangos
        (estado,
         bcrubr,
         pcnomr,
         cta_cliente,
         titular,
         operacion,
         tip_per,
         tip_doc,
         pendoc,
         fec_nac,
         fec_des,
         mto_apr,
         saldo,
         cobert,
         sal_cli,
         Apr_Cli,
         Pepais,
         Petdoc,
         Bcmda,
         Bcsdmo,
         Agencia,
         petipo,
         Bcplaz,
         Nro_Cred)
        select estado,
               bcrubr,
               pcnomr,
               cta_cliente,
               titular,
               operacion,
               tip_per,
               tip_doc,
               pendoc,
               min(fec_nac) fec_nac,
               fec_des,
               mto_apr,
               saldo,
               cobert,
               sal_cli,
               apr_cli,
               pepais,
               petdoc,
               bcmda,
               bcsdmo,
               agencia,
               petipo,
               bcplaz,
               nro_cred
          from (select t_base.estado,
                        t_base.bcrubr,
                        t_base.pcnomr,
                        t_base.cta_cliente,
                        t_base.titular,
                        t_base.operacion,
                        t_base.tip_per,
                        t_base.tip_doc,
                        t_base.pendoc,
                        t_rela.vicod,
                        case
                          when t_base.tip_per = 'EIRL' then
                           case
                             when t_natu.pffnac is null then
                              t_base.fec_nac
                             else
                              t_natu.pffnac
                           end
                          else
                           t_base.fec_nac
                        end fec_nac,
                        t_base.fec_des,
                        t_base.mto_apr,
                        t_base.saldo,
                        t_base.cobert,
                        t_tota.sal_cli,
                        t_tota.apr_cli,
                        t_base.pepais,
                        t_base.petdoc,
                        t_base.bcmda,
                        t_base.bcsdmo,
                        t_base.agencia,
                        t_base.petipo,
                        t_base.bcplaz,
                        t_base.nro_cred
                   from Segu_Final t_base,
                        TotCred    t_tota,
                        fsr003     t_rela,
                        fsd002     t_natu
                  where /*t_tota.cta_cliente   = t_base.cta_cliente
                                                                                                                                                                                                                                                                                                                                                                                                                                                                   and*/
                  t_tota.titular = t_base.titular
               and t_tota.tip_per = t_base.tip_per
               and t_tota.tip_doc = t_base.tip_doc
               and t_tota.pendoc = t_base.pendoc
               and t_tota.fec_nac = t_base.fec_nac
               and t_rela.pjndoc(+) = t_base.pendoc
               and t_natu.pfpais(+) = t_rela.pfpai1
               and t_natu.pftdoc(+) = t_rela.pftdo1
               and t_natu.pfndoc(+) = t_rela.pfndo1)
         group by estado,
                  bcrubr,
                  pcnomr,
                  cta_cliente,
                  titular,
                  operacion,
                  tip_per,
                  tip_doc,
                  pendoc,
                  fec_des,
                  mto_apr,
                  saldo,
                  cobert,
                  sal_cli,
                  apr_cli,
                  pepais,
                  petdoc,
                  bcmda,
                  bcsdmo,
                  agencia,
                  petipo,
                  bcplaz,
                  nro_cred
         order by estado, bcrubr, pcnomr, cta_cliente, titular, operacion;
      COMMIT;

      INSERT INTO JAQY523
        (JAQY523fecpro,
         JAQY523estado,
         JAQY523bcrubr,
         JAQY523pcnomr,
         JAQY523cta_cliente,
         JAQY523titular,
         JAQY523operacion,
         JAQY523tip_per,
         JAQY523tip_doc,
         JAQY523pendoc,
         JAQY523fec_nac,
         JAQY523fec_des,
         JAQY523mto_apr,
         JAQY523saldo,
         JAQY523cobert,
         JAQY523sal_cli,
         JAQY523APR_CLI,
         JAQY523TIPREP,
         JAQY523EDAD,
         JAQY523REPJUR,
         JAQY523MDA,
         JAQY523BCSDMO,
         JAQY523AGENCIA,
         JAQY523PETIPO,
         JAQY523BCPLAZ,
         JAQY523PAIS,
         JAQY523TDOC,
         JAQY523NRO_CRED)

        SELECT PD_FECHA,
               estado,
               bcrubr,
               pcnomr,
               cta_cliente,
               titular,
               operacion,
               tip_per,
               tip_doc,
               pendoc,
               fec_nac,
               fec_des,
               mto_apr,
               saldo,
               cobert,
               sal_cli,
               apr_cli,
               PQ_POLIZA_DESGRAVAMEN.fn_tipo_rep(pcnomr, fec_nac, PD_FECHA),
               --PQ_POLIZA_DESGRAVAMEN.fn_cr_years(PD_FECHA,fec_nac),
               floor(MONTHS_BETWEEN(PD_FECHA, fec_nac) / 12),
               PQ_POLIZA_DESGRAVAMEN.fn_nomtit(seg.pepais,
                                               seg.petdoc,
                                               seg.pendoc),
               seg.bcmda,
               seg.bcsdmo,
               seg.agencia,
               seg.petipo,
               seg.bcplaz,
               seg.pepais,
               seg.petdoc,
               SEG.NRO_CRED

          FROM Seg_Rangos seg
         order by estado, bcrubr, pcnomr, cta_cliente, titular, operacion;

      COMMIT;

      INSERT INTO JAQY524
        (JAQY524fecpro,
         JAQY524estado,
         JAQY524bcrubr,
         JAQY524pcnomr,
         JAQY524cta_cliente,
         JAQY524titular,
         JAQY524operacion,
         JAQY524tip_per,
         JAQY524tip_doc,
         JAQY524pendoc,
         JAQY524fec_nac,
         JAQY524fec_des,
         JAQY524mto_apr,
         JAQY524saldo,
         JAQY524cobert,
         JAQY524sal_cli,
         JAQY524APR_CLI,
         JAQY524TIPREP,
         JAQY524EDAD,
         JAQY524REPJUR,
         JAQY524MDA,
         JAQY524BCSDMO,
         JAQY524AGENCIA,
         JAQY524PETIPO,
         JAQY524BCPLAZ,
         JAQY524NRO_CRED /*,JAQY524FIL*/)

        SELECT PD_FECHA,
               JAQY523estado,
               JAQY523bcrubr,
               JAQY523pcnomr,
               JAQY523cta_cliente,
               JAQY523titular,
               JAQY523operacion,
               JAQY523tip_per,
               JAQY523tip_doc,
               JAQY523pendoc,
               JAQY523fec_nac,
               JAQY523fec_des,
               JAQY523mto_apr,
               JAQY523saldo,
               JAQY523cobert,
               JAQY523sal_cli,
               JAQY523APR_CLI,
               JAQY523TIPREP,
               JAQY523EDAD,
               JAQY523REPJUR,
               JAQY523MDA,
               JAQY523BCSDMO,
               JAQY523AGENCIA,
               JAQY523PETIPO,
               i.jaqy523bcplaz,
               I.jaqy523NRO_CRED /*,
                                                                                                                                                                                                                                  Case
                                                                                                                                                                                                                                     when i.jaqy523tiprep in ('HIPOA','HIPOB')  Then 'HIPO'
                                                                                                                                                                                                                                     when i.jaqy523tiprep in ('SD1','SD2') and i.jaqy523sal_cli >= 8000  Then 'NORMAL'
                                                                                                                                                                                                                                     else 'OTROS'
                                                                                                                                                                                                                                  END*/
          FROM JAQY523 i
         order by JAQY523estado,
                  JAQY523bcrubr,
                  JAQY523pcnomr,
                  JAQY523cta_cliente,
                  JAQY523titular,
                  JAQY523operacion;

      COMMIT;

      INSERT INTO JAQY522
        (JAQY522fecpro,
         JAQY522TIPREP,
         JAQY522TITULAR,
         JAQY522TIP_DOC,
         JAQY522PENDOC,
         JAQY522FEC_NAC,
         JAQY522EDAD,
         JAQY522PETIPO,
         JAQY522SAL_CLI,
         JAQY522REPJUR,
         JAQY522APR_CLI,
         JAQY522COBTOT,
         JAQY522PAIS,
         JAQY522TDOC)

        select PD_FECHA,
               JAQY523tiprep,
               JAQY523titular,
               JAQY523tip_doc,
               JAQY523pendoc,
               JAQY523fec_nac,
               JAQY523edad,
               JAQY523petipo,
               sum(JAQY523saldo),
               JAQY523REPJUR,
               sum(JAQY523mto_apr),
               case
                 when JAQY523tiprep = 'SD1' and
                      sum(JAQY523saldo) > PN_TOPE1 * PN_TIPCAM then
                  round(PN_TOPE1 * PN_TIPCAM, 2)
                 when JAQY523tiprep = 'SD1' and
                      sum(JAQY523saldo) <= PN_TOPE1 * PN_TIPCAM then
                  sum(JAQY523saldo)
                 when JAQY523tiprep = 'SD2' and
                      sum(JAQY523saldo) > PN_TOPE2 * PN_TIPCAM then
                  round(PN_TOPE2 * PN_TIPCAM, 2)
                 when JAQY523tiprep = 'SD2' and
                      sum(JAQY523saldo) <= PN_TOPE2 * PN_TIPCAM then
                  sum(JAQY523saldo)
                 when JAQY523tiprep = 'HIPOA' and
                      sum(JAQY523saldo) > PN_TOPE3 * PN_TIPCAM then
                  round(PN_TOPE3 * PN_TIPCAM, 2)
                 when JAQY523tiprep = 'HIPOA' and
                      sum(JAQY523saldo) <= PN_TOPE3 * PN_TIPCAM then
                  sum(JAQY523saldo)
                 when JAQY523tiprep = 'HIPOB' and
                      sum(JAQY523saldo) > PN_TOPE4 * PN_TIPCAM then
                  round(PN_TOPE4 * PN_TIPCAM, 2)
                 when JAQY523tiprep = 'HIPOB' and
                      sum(JAQY523saldo) <= PN_TOPE4 * PN_TIPCAM then
                  sum(JAQY523saldo)
               end,
               a.jaqy523pais,
               a.jaqy523tdoc

          from JAQY523 a
        --where j.jaqy524fil in ('HIPO','NORMAL')

         group by JAQY523tiprep,
                  JAQY523titular,
                  JAQY523tip_doc,
                  JAQY523pendoc,
                  JAQY523fec_nac,
                  JAQY523edad,
                  JAQY523petipo,
                  --JAQY523sal_cli,
                  JAQY523REPJUR,
                  jaqy523pais,
                  jaqy523tdoc /*,
                                                                                                                                                                                                                                 JAQY523APR_CLI */
        ;
      COMMIT;

      INSERT INTO JAQY525
        (JAQY525fecpro,
         JAQY525TIPREP,
         JAQY525TITULAR,
         JAQY525TIP_DOC,
         JAQY525PENDOC,
         JAQY525FEC_NAC,
         JAQY525EDAD,
         JAQY525PETIPO,
         JAQY525SAL_CLI,
         JAQY525REPJUR,
         JAQY525APR_CLI,
         JAQY525COBTOT,
         JAQY525PAIS,
         JAQY525TDOC)

        select PD_FECHA,
               JAQY522tiprep,
               JAQY522titular,
               JAQY522tip_doc,
               JAQY522pendoc,
               JAQY522fec_nac,
               JAQY522edad,
               JAQY522petipo,
               JAQY522SAL_CLI,
               JAQY522REPJUR,
               JAQY522APR_CLI,
               JAQY522COBTOT,
               j.jaqy522pais,
               j.jaqy522tdoc

          from JAQY522 j
         where (j.jaqy522tiprep in ('SD1', 'SD2') and
               j.jaqy522sal_cli >= 8000)
            or j.jaqy522tiprep in ('HIPOA', 'HIPOB')
        /*group by  JAQY522tiprep,
        JAQY522titular,
        JAQY522tip_doc,
        JAQY522pendoc,
        JAQY522fec_nac,
        JAQY522edad,
        JAQY522petipo,
        --JAQY523sal_cli,
        JAQY522REPJUR\*,
        JAQY523APR_CLI *\   */
        ;
      COMMIT;

      /*update fst098 set tpnro = 0 where tpcod =9838;

      COMMIT;*/

    END;

  END;

  function fn_cr_years(P_D_FECPRO in date, P_D_FECNAC in date) return number is

    ld_fecpro date;
    ld_fecnac date;

    ln_year number;
  begin
    -- Datos seg n Par metros.
    ld_fecpro := trunc(P_D_FECPRO);
    ld_fecnac := trunc(P_D_FECNAC);
    --
    ln_year := to_number(to_char(ld_fecpro, 'yyyy')) -
               to_number(to_char(ld_fecnac, 'yyyy'));
    if (ln_year > 0) then
      if (to_char(ld_fecpro, 'mm') < to_char(ld_fecnac, 'mm')) then
        ln_year := ln_year - 1;
      else
        if (to_char(ld_fecpro, 'mm') = to_char(ld_fecnac, 'mm')) and
           (to_char(ld_fecpro, 'dd') < to_char(ld_fecnac, 'dd')) then
          ln_year := ln_year - 1;
        end if;
      end if;
    else
      ln_year := null;
    end if;
    return(ln_year);
  exception
    when others then
      return(null);
  end fn_cr_years;

  function fn_tipo_rep(pcnomr   in varchar2,
                       fec_nac  in date,
                       PD_FECHA in date) return varchar2 is

    lc_tiprep varchar2(20);
    ln_edad   number(5);
    ln_es     number;

  begin
    begin

      --ln_edad   := PQ_POLIZA_DESGRAVAMEN.fn_cr_years(PD_FECHA,fec_nac); --edad actual
      ln_edad := floor(MONTHS_BETWEEN(PD_FECHA, fec_nac) / 12);

      if pcnomr like '%Hipo%' then
        ln_es := 1;
      else
        ln_es := 0;
      end if;

      case
        when ln_es = 1 and ln_edad >= 18 and ln_edad <= 70 then
          lc_tiprep := 'HIPOA';
        when ln_es = 1 and ln_edad > 70 and ln_edad <= 75 then
          lc_tiprep := 'HIPOB';
        when ln_es = 0 and ln_edad >= 18 and ln_edad <= 70 then
          lc_tiprep := 'SD1';
        when ln_es = 0 and ln_edad > 70 and ln_edad <= 75 then
          lc_tiprep := 'SD2';
        else
          lc_tiprep := '';
      end case;

    end;

    return lc_tiprep;

  end fn_tipo_rep;

  function fn_nomtit(PD_PAIS in number,
                     PD_TDOC in NUMBER,
                     PD_NDOC in number) return varchar2 is

    lc_nomtit varchar2(200);

  begin
    begin

      select k.penom
        into lc_nomtit
        from fsd001 k, fsr003 j
       where j.pjpais = PD_PAIS
         and j.pjtdoc = PD_TDOC
         and j.pjndoc = PD_NDOC
         and j.pfpai1 = k.pepais
         and j.pftdo1 = k.petdoc
         and j.pfndo1 = k.pendoc
         and rownum = 1;

    exception
      when others then
        lc_nomtit := null;
    end;
    return(lc_nomtit);
  end fn_nomtit;

  Procedure sp_fsr011buscar(ln_pgcod  in number,
                            ln_aomod  in number,
                            ln_aosuc  in number,
                            ln_aomda  in number,
                            ln_aopap  in number,
                            ln_aocta  in number,
                            ln_aooper in number,
                            ln_aosbop in number,
                            ln_tope   in number,
                            ln_result out number) IS

  BEGIN
    execute immediate ('truncate table JAQZ747');
    ---------r2
    insert into JAQZ747
      (JAQZ747PGCOD,
       JAQZ747AOMOD,
       JAQZ747AOSUC,
       JAQZ747AOMDA,
       JAQZ747AOPAP,
       JAQZ747AOCTA,
       JAQZ747AOOPER,
       JAQZ747AOSBOP,
       JAQZ747AOTOPE)
      SELECT fsr011.r2cod,
             fsr011.r2mod,
             fsr011.r2suc,
             fsr011.r2mda,
             fsr011.r2pap,
             fsr011.r2cta,
             fsr011.r2oper,
             fsr011.r2sbop,
             fsr011.r2tope
        FROM fsr011
       where fsr011.r1cod = ln_pgcod
         and fsr011.r1mod = ln_aomod
         and fsr011.r1suc = ln_aosuc
         and fsr011.r1mda = ln_aomda
         and fsr011.r1pap = ln_aopap
         and fsr011.r1cta = ln_aocta
         and fsr011.r1oper = ln_aooper
         and fsr011.r1sbop = ln_aosbop
         and fsr011.r1tope = ln_tope
         and fsr011.relcod in (35, 36, 121, 38, 39);
    COMMIT;
    ----------r1
    insert into JAQZ747
      (JAQZ747PGCOD,
       JAQZ747AOMOD,
       JAQZ747AOSUC,
       JAQZ747AOMDA,
       JAQZ747AOPAP,
       JAQZ747AOCTA,
       JAQZ747AOOPER,
       JAQZ747AOSBOP,
       JAQZ747AOTOPE)
      SELECT fsr011.r2cod,
             fsr011.r2mod,
             fsr011.r2suc,
             fsr011.r2mda,
             fsr011.r2pap,
             fsr011.r2cta,
             fsr011.r2oper,
             fsr011.r2sbop,
             fsr011.r2tope
        FROM fsr011
       where fsr011.r1cod = ln_pgcod
         and fsr011.r2mod = ln_aomod
         and fsr011.r2suc = ln_aosuc
         and fsr011.r2mda = ln_aomda
         and fsr011.r2pap = ln_aopap
         and fsr011.r2cta = ln_aocta
         and fsr011.r2oper = ln_aooper
         and fsr011.r2sbop = ln_aosbop
         and fsr011.r2tope = ln_tope
         and fsr011.relcod in (35, 36, 121, 38, 39);
    COMMIT;
    ------RESULTADO

    PQ_POLIZA_DESGRAVAMEN.recorrerData(ln_result);

  End sp_fsr011buscar;

  Procedure recorrerData(ln_result out number) IS
    minimo date;

    cursor casojaqz747 is
      select jaqz747.jaqz747pgcod,
             jaqz747.jaqz747aomod,
             jaqz747.jaqz747aosuc,
             jaqz747.jaqz747aomda,
             jaqz747.jaqz747aopap,
             jaqz747.jaqz747aocta,
             jaqz747.jaqz747aooper,
             jaqz747.jaqz747aosbop,
             jaqz747.jaqz747aotope
        from jaqz747;
  begin
    for p in casojaqz747 loop
      select min(fsd010.aofval)
        into minimo
        from fsd010
       where fsd010.aocta = p.jaqz747aocta
         and fsd010.aooper = p.jaqz747aooper;
      if minimo < '03/11/2015' then
        ln_result := 1;
        exit;
      else
        ln_result := 0;
      end if;
    end loop;

  end recorrerData;

end PQ_POLIZA_DESGRAVAMEN;
/
