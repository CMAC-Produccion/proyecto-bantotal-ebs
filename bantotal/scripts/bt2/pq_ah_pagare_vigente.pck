CREATE OR REPLACE PACKAGE PQ_AH_PAGARE_VIGENTE IS

------------------------------------------------------
Procedure SP_AH_GENERA_UNO  (LN_SUCUR    IN NUMBER,
                             LC_USUARIO  IN VARCHAR2);
------------------------------------------------------
/*function Fecha_Desembolso1(cuenta in number,
                           operacion in number,
                           moneda    in number,
                           modulo    in number,
                           subopera  in number
                          ) return date;*/
------------------------------------------------------
function Monto_Aprobado(cuenta    in number,
                        operacion in number,
                        moneda    in number,
                        modulo    in number,
                        subopera  in number,
                        agencia   in number,
                        tipoope   in number
                        ) return number;
------------------------------------------------------
function Fecha_desembolso2(ln_Aomod in number,
                           ln_Aosuc in number,
                           ln_Aomda in number,
                           ln_Aocta in number,
                           ln_Aooper in number,
                           ln_Aosbop in number,
                           ln_Aotope in number)return date;
------------------------------------------------------
function cuotas_pendientes(pn_emp in number,
                           pn_mod in number,
                           pn_suc in number,
                           pn_mda in number,
                           pn_pap in number,
                           pn_cta in number,
                           pn_oper in number,
                           pn_sbop in number,
                           pn_top in number) return varchar2;
--------------------------------------------------------------
function estado_linea(pn_cuenta in number,
                      pn_operacion in number) return varchar2;
---------------------------------------------------------------
function Verifica_sucursal(pn_emp in number,
                           pn_mod in number,
                           pn_suc in number,
                           pn_mda in number,
                           pn_pap in number,
                           pn_cta in number,
                           pn_oper in number,
                           pn_sbop in number,
                           pn_top in number,
                           pd_fech in date)return number;
---------------------------------------------------------------
function Fecha_judicial(pn_emp in number,
                        pn_mod in number,
                        pn_suc in number,
                        pn_mda in number,
                        pn_pap in number,
                        pn_cta in number,
                        pn_oper in number,
                        pn_sbop in number,
                        pn_top in number,
                        pn_est in number)return date;
----------------------------------------------------------------

END PQ_AH_PAGARE_VIGENTE;
/
CREATE OR REPLACE PACKAGE BODY PQ_AH_PAGARE_VIGENTE  IS
-----------------------------------------------------------------------
-- Fecha Modificación : 09/01/2020
-- Modificacion       : Adición de módulo 117 para que muestre la agencia
--                      correcta de desembolso
--                      Eliminación de condicion de fechas  para que
--                      se generen todos los registros
-- Autor              : Silvia Marquez Avendaño
-- Fecha Modificación : 06/02/2020
-- Modificacion       : Ora 1422 en el modulo 117
-- Autor              : Silvia Marquez Avendaño
-- Fecha Modificación : 14/07/2020
-- Modificacion       : sucursal desembolso/desembolsos digitales
-- Autor              : Silvia Marquez Avendaño
-- Fecha Modificación : 26/10/2020
-- Modificacion       : Modificacion de fechas cruzadas
-- Autor              : Silvia Marquez Avendaño
-- fecha              : 11/11/2020
-- Modificacion       : Modificacion creditos de CAJA MOVIL
-- Autor              : Silvia Marquez Avendaño
-- fecha              : 16/11/2020
-- Modificacion       : Modificacion creditos de CAJA MOVIL
-- Autor              : Silvia Marquez Avendaño
-- fecha              : 20/01/2021
-- Modificacion       : Adicion de verificacion en la fsh016 y fsh015 desembolso caja movil
--                    : adición de consulta de transaccione en los desembolsos remotos
-- Autor              : Silvia Marquez Avendaño
-- fecha              : 05/02/2021
-- Modificacion       : Empleo de Tablas temporales
-- Autor              : Silvia Marquez Avendaño
-- fecha              : 01/03/2021
-- Modificacion       : Eliminación del bult collect
-- Autor              : Silvia Marquez Avendaño
-- fecha              : 23/09/2021
-- Modificacion       : Lineas remotas
-- Autor              : Silvia Marquez Avendaño
-- fecha              : 22/10/2021
-- Modificacion       : cASOS QUE NO MUESTRA SUCURSAL REMOTA, FECHA DE DESEMBOLSO CORRECTO
-- Autor              : Silvia Marquez Avendaño
-- fecha              : 06/05/2022
-- Modificacion       : Para que se impriman los Refinanciados con otra operacion
-- Autor              : Silvia Marquez Avendaño
-- fecha              : 29/12/2022
-- Modificacion       : Para que se impriman los remotos de ampliaciones
-- Autor              : Silvia Marquez Avendaño
-- fecha              : 25/01/2023
-- Modificacion       : SMARQUEZ 22/01/2025 correccion lineas 117
-- Modificación       : SMARQUEZ 02/05/2025 modificacion credinka y  movil
-- Modificacion       : SMARQUEZ 23/05/2025 modificacion Lineas remotas
--------------------------------------------------------------

Procedure SP_AH_GENERA_UNO (LN_SUCUR    IN NUMBER,
                            LC_USUARIO  IN VARCHAR2) IS

 cursor jaqz596 (usu in char) is
  select * from  jaqz596_tem where usuariot = usu and flag ='N' order by fecha_inicial;


 cursor reprog is
   select *
     from fst198
    where tp1cod = 1
      and tp1cod1 = 10884
      and tp1corr1 = 41
      and tp1corr2 = 1;


 cursor transac1 is
   select tp1nro2 tran, tp1desc estado
     from fst198
    Where Tp1cod   = 1
      and Tp1cod1  = 10884
      and tp1corr1 = 15;

cursor modulos is
  select tp1nro1
   from fst198
  where tp1cod = 1
    AND tp1cod1 = 10884
    AND TP1CORR1 = 5
    AND TP1CORR2 = 1;


  cursor remotoUNO (usu in char) is
    select * from  jaqz596_tem where usuariot = usu and flag ='R' ;


 fecha2 date;
 montoA number(17,2);
 moneda varchar2(5);
 estado varchar2(30);
 agencia number;
 observacion char(30);
 v_sboper number;
 existe number:= 0;
 reprog1 char(1):='N';

 fecha1rep date;
 fecha2rep date;

 fechadesembolso date;
 fechaALTA date;
 analista1 char(20);
 cuotas varchar2(20);
 fechajud date;
 nomage char(30);
 flagI char(1):='N';
 var_refiImprime char(1);
 flagnewope char(1):= 'N';
BEGIN
   execute immediate 'alter session set "_optimizer_batch_table_access_by_rowid" =false';
   delete jaqy680
    where jaqy680au4 = LC_USUARIO;
   commit;
   delete jaqz596_tem
    where usuariot = rpad(LC_USUARIO,12,' ');
   commit;

   select scnom into nomage   from fst001 where sucurs = LN_SUCUR;

   insert into jaqz596_tem (v1scsuc, v1sccta, v1scoper, v1scmda, v1scpap, v1scmod, v1scsbop, v1sctope, v1scfval, v1scstat,
                            v1scsdo, fecha_contable,fecha_inicial, estado, producto, cliente, moneda ,sucursal, transac, usuariot, flag )
   select f.scsuc v1scsuc, -- f.sccta cta, f.scoper oper ---count(*) --7272 --4709 c.xwftsuc suc1 , f.scsuc  suc2,
             f.sccta v1sccta,
             f.scoper v1scoper,
             f.scmda v1Scmda,
             f.Scpap v1Scpap,
             f.Scmod v1Scmod,
             f.Scsbop v1Scsbop,
             f.Sctope v1Sctope,
             f.Scfval v1Scfval,
             f.scstat v1scstat,
             abs(f.Scsdo) v1Scsdo,
             to_char(f.scfcon,'dd/mm/yyyy')  Fecha_contable,
             (select min(b.aofval)
                from fsd010 b
               where b.pgcod = 1
                 and b.aomod = f.scmod
                 and b.aocta = f.sccta
                 and b.aooper = f.scoper
                 and b.aosuc = f.scsuc) fecha_inicial,
             (SELECT Cenom FROM fst026 where Cecod = f.Scstat) ESTADO,
             (SELECT Mdnom from fst003 where Modulo = f.Scmod) PRODUCTO,
             (select r.penom
                from fsr008 t ,
                     fsd001 r
               where t.pgcod = 1
                 and t.ctnro = f.sccta
                 and t.cttfir ='T'
                 and r.pepais = t.pepais
                 and r.petdoc = t.petdoc
                 and r.pendoc = t.pendoc) cliente,
             (select mosign from fst005 where moneda = f.scmda) moneda,
             (select Scnom
                from FST001
               Where Pgcod = 1
                 and Sucurs =f.SCSUC) sucursal,
             c.xwfttran transac,
             LC_USUARIO usuariot,
             'N' flag
        FROM xwf070 c, xwf700 a, fsd011 f, fsh015 g -- sma 22052024
       where g.pgcod = c.xwfpgcod
         and g.hcmod = c.xwftmod
         and g.hsucor = c.xwftsuc
         and g.htran = c.xwfttran
         and g.hnrel = c.xwfnrel
         and g.hfcon = c.xwffcon
         and g.hccorr = 0
         and c.xwfpgcod = 1
         and c.xwftmod = 30
         and c.xwftsuc = LN_SUCUR
         and c.xwfttran in (select tp1nro2
                              from fst198
                             where Tp1cod = 1
                               and Tp1cod1 = 10884
                               and Tp1corr1 = 15
                               and tp1nro1 = 30) ----= TRANSAC --951
         and c.xwffcon >= to_Date('01/07/2013','dd/mm/rrrr')
         and c.xwfcont = 'S'
         AND a.xwfprcins = c.xwfprcin
         and a.xwfcar3 = '1'
         AND f.PGCOD = a.xwfempresa --PGCOD, SCMOD, SCMDA, SCPAP, SCCTA, SCSUC, SCOPER, SCSBOP, SCTOPE
         and f.SCMOD = a.xwfmodulo
         AND f.Scmod in (select tp1nro1
                           from fst198
                          where tp1cod = 1
                            AND tp1cod1 = 10884
                            AND TP1CORR1 = 5
                            AND TP1CORR2 = 1)
         and f.SCMDA = a.xwfmoneda
         AND f.Scmda in (0, 101)
         and f.SCPAP = a.xwfpapel
         and f.SCCTA = a.xwfcuenta
         and f.SCSUC = a.xwfsucursal
         and f.SCOPER = a.xwfoperacion
         and f.SCSBOP = a.xwfsubope
         and f.SCTOPE = a.xwftipope
         AND f.Scpap = 0
         and f.scstat in (select tp1nro1
                            from fst198
                           where tp1cod = 1
                             AND tp1cod1 = 10884
                             AND TP1CORR1 = 5
                             AND TP1CORR2 = 2)
         AND f.scstat <> 99
         and f.SCSUC <> c.xwftsuc
         ---validacion credinka
         and not exists(SELECT 1 
                          FROM AQPB178 A 
                         WHERE A.AQPB178TFLU = 'D' 
                           and aqpb178ctacr = a.xwfcuenta	
                           and aqpb178opecr = a.xwfoperacion
                           and rownum = 1 )
         ;
         commit;


   insert into jaqz596_tem (v1scsuc, v1sccta, v1scoper, v1scmda, v1scpap, v1scmod, v1scsbop, v1sctope, v1scfval, v1scstat,
                            v1scsdo, fecha_contable,fecha_inicial, estado, producto, cliente, moneda ,sucursal, transac, usuariot, flag )
   SELECT SCSUC v1SCSUC,
             SCCTA v1SCCTA,
             SCOPER v1SCOPER,
             Scmda v1Scmda,
             Scpap v1Scpap,
             Scmod v1Scmod,
             Scsbop v1Scsbop,
             Sctope v1Sctope,
             Scfval v1Scfval,
             Scstat v1scstat,
             abs(Scsdo) v1Scsdo,
             to_char(scfcon,'dd/mm/yyyy')  Fecha_contable,

             (select min(b.aofval)
                from fsd010 b
               where b.pgcod = 1
                 and b.aomod = scmod
                 and b.aocta = sccta
                 and b.aooper = scoper
                 and b.aosuc = scsuc) fecha_inicial,
             (SELECT Cenom FROM fst026 where Cecod = Scstat) ESTADO,
             (SELECT Mdnom from fst003 where Modulo = Scmod) PRODUCTO,
             (select r.penom
                from fsr008 t ,
                     fsd001 r
               where t.pgcod = 1
                 and t.ctnro = sccta
                 and t.cttfir ='T'
                 and r.pepais = t.pepais
                 and r.petdoc = t.petdoc
                 and r.pendoc = t.pendoc)  cliente,
             (select mosign from fst005 where moneda = scmda) moneda,
             (select Scnom
                from FST001
               Where Pgcod = 1
                 and Sucurs = SCSUC) sucursal,
             0 transac,
             LC_USUARIO usuariot,
             'N' Flag
        FROM fsd011
       where Pgcod = 1
         AND Scsuc = LN_SUCUR --&SUCURS   a
         AND Scmda in (0, 101)
         AND Scpap = 0
         AND Scmod in (select tp1nro1
                         from fst198
                        where tp1cod = 1
                          AND tp1cod1 = 10884
                          AND TP1CORR1 = 5
                          AND TP1CORR2 = 1)
         and scstat in (select tp1nro1
                         from fst198
                        where tp1cod = 1
                          AND tp1cod1 = 10884
                          AND TP1CORR1 = 5
                          AND TP1CORR2 = 2)
         AND Scstat <> 99
         and not exists (select 1
                                  from fsd601
                                 where pgcod = 1
                                   and ppmod = scmod
                                   and ppsuc = scsuc
                                   and ppmda = scmda
                                   and pppap = scpap
                                   and ppcta = sccta
                                   and ppoper = scoper
                                   and ppsbop = 0
                                   and pptope = sctope
                                   and d601mo = 489
                                   and rownum = 1)
          and not exists(SELECT 1 
                            FROM AQPB178 A 
                           WHERE A.AQPB178TFLU = 'D' 
                             and aqpb178ctacr = sccta
                             and aqpb178opecr = scoper
                             and rownum = 1 )                           
         ;

      commit;
--------------------------sma Lineas remotas 117 ------------------
   insert into jaqz596_tem (v1scsuc, v1sccta, v1scoper, v1scmda, v1scpap, v1scmod, v1scsbop, v1sctope, v1scfval, v1scstat,
                            v1scsdo, fecha_contable,fecha_inicial, estado, producto, cliente, moneda ,sucursal, transac, usuariot, flag )

     select  f.aosuc  v1scsuc, --c.hsucor  v1scsuc,
             c.hcta  v1sccta,
             c.hoper  v1scoper,
             c.hmda  v1Scmda,
             c.hpap  v1Scpap,
             c.hmodul  v1Scmod,
             c.hsubop  v1Scsbop,
             c.htoper  v1Sctope,
             c.hfval  v1Scfval,
             f.AOSTAT v1scstat,---aqui
             abs(c.hcimp1 ) v1Scsdo,
             to_char(c.hfcon ,'dd/mm/yyyy')  Fecha_contable,
              f.aofval  fecha_inicial,
             (SELECT Cenom FROM fst026 where Cecod = f.aostat ) ESTADO,---aqui
             (SELECT Mdnom from fst003 where Modulo = c.hmodul) PRODUCTO,
             (select r.penom
                from fsr008 t ,
                     fsd001 r
               where t.pgcod = 1
                 and t.ctnro = c.hcta
                 and t.cttfir ='T'
                 and r.pepais = t.pepais
                 and r.petdoc = t.petdoc
                 and r.pendoc = t.pendoc)  cliente,
             (select mosign from fst005 where moneda = c.hmda ) moneda,
             (select Scnom
                from FST001
               Where Pgcod = 1
                 and Sucurs = c.HSUCUR ) sucursal,---c.HSUCOR ) sucursal,
             c.htran transac,
             LC_USUARIO usuariot,
             'R' flag
         FROM fsh015 d,fsh016 c, fsd010 f
             where c.pgcod = d.pgcod
               and c.hcmod = d.hcmod
               and c.hsucor = d.hsucor
               and c.htran = d.htran
               and c.hfcon = d.hfcon
               and c.hcord= 10 ---sma 250121
--               and c.hsucur = d.HSUCoR ---sma 250121
               and d.hfcon >=  to_Date('01/07/2013','dd/mm/rrrr')
               and d.hccorr = 0
               and d.pgcod = 1
               and d.hcmod = 117
               and d.hsucor <> LN_SUCUR  ---sma 250121
               and d.htran = 10
               and f.PGCOD = c.PGCOD
               and f.AOMOD = c.HCMOD
               and f.AOSUC = c.hsucur
               and f.AOMDA =c.HMDA
               and f.AOPAP = c.HPAP
               and f.AOCTA = c.HCTA
               and f.AOOPER = c.HOPER
               and f.AOSBOP = c.HSUBOP
               and f.aotope = c.HTOPER
               and f.aomod = 117
               and f.aostat <> 99
               and not exists (  select 1
                                 from jaqz596_tem
                                where usuariot = LC_USUARIO
                                  and v1scsuc = f.aosuc
                                  and v1sccta = f.aocta
                                  and v1scoper = f.aooper
                                  and v1scpap = f.aopap
                                  and v1scmod = f.aomod
                                  and v1scsbop = f.aosbop
                                  and v1sctope = f.aotope
                                  and v1scfval = f.aofval
                                  and v1scstat = f.aostat
                                  and v1scsdo = f.aoimp
                                  and transac = 0
                                  and flag ='N');

     commit;
------------------------------ sma 116 --------------------------------
insert into jaqz596_tem (v1scsuc, v1sccta, v1scoper, v1scmda, v1scpap, v1scmod, v1scsbop, v1sctope, v1scfval, v1scstat,
                            v1scsdo, fecha_contable,fecha_inicial, estado, producto, cliente, moneda ,sucursal, transac, usuariot, flag )

     select  f.aosuc  v1scsuc, --c.hsucor  v1scsuc,
             c.hcta  v1sccta,
             c.hoper  v1scoper,
             c.hmda  v1Scmda,
             c.hpap  v1Scpap,
             c.hmodul  v1Scmod,
             c.hsubop  v1Scsbop,
             c.htoper  v1Sctope,
             c.hfval  v1Scfval,
             f.AOSTAT v1scstat,---aqui
             abs(c.hcimp1 ) v1Scsdo,
             to_char(c.hfcon ,'dd/mm/yyyy')  Fecha_contable,
              f.aofval  fecha_inicial,
             (SELECT Cenom FROM fst026 where Cecod = f.aostat ) ESTADO,---aqui
             (SELECT Mdnom from fst003 where Modulo = c.hmodul) PRODUCTO,
             (select r.penom
                from fsr008 t ,
                     fsd001 r
               where t.pgcod = 1
                 and t.ctnro = c.hcta
                 and t.cttfir ='T'
                 and r.pepais = t.pepais
                 and r.petdoc = t.petdoc
                 and r.pendoc = t.pendoc)  cliente,
             (select mosign from fst005 where moneda = c.hmda ) moneda,
             (select Scnom
                from FST001
               Where Pgcod = 1
                 and Sucurs =c.hsucur ) sucursal,
             c.htran transac,
             LC_USUARIO usuariot,
             'R' flag
         FROM fsh015 d,fsh016 c, fsd010 f
             where c.pgcod = d.pgcod
               and c.hcmod = d.hcmod
               and c.hsucor = d.hsucor
               and c.htran = d.htran
               and c.hfcon = d.hfcon
               and c.hsucur <> d.HSUCoR
               and d.hfcon >=  to_Date('01/07/2013','dd/mm/rrrr')
               and d.hccorr = 0
               and d.pgcod = 1
               and d.hcmod = 116
               and d.hsucor = LN_SUCUR
               and d.htran = 50
 --and c.hcta= 1960046           ---  pruebas
               and f.PGCOD = c.PGCOD
               and f.AOMOD = c.HCMOD
               and f.AOSUC = c.hsucur
               and f.AOMDA =c.HMDA
               and f.AOPAP = c.HPAP
               and f.AOCTA = c.HCTA
               and f.AOOPER = c.HOPER
               and f.AOSBOP = c.HSUBOP
               and f.aotope = c.HTOPER
               and f.aomod = 116
               and f.aostat <> 99
               and not exists (select 1
                                 from jaqz596_tem
                                where usuariot = LC_USUARIO
                                  and v1scsuc = f.aosuc
                                  and v1sccta = f.aocta
                                  and v1scoper = f.aooper
                                  and v1scpap = f.aopap
                                  and v1scmod = f.aomod
                                  and v1scsbop = f.aosbop
                                  and v1sctope = f.aotope
                                  and v1scfval = f.aofval
                                  and v1scstat = f.aostat
                                  and v1scsdo = f.aoimp
                                  and transac = 0
                                  and flag ='N');

     commit;
---------------------------------------------------------------

       For r in transac1  loop
         For m in modulos loop
           if m.tp1nro1 = 117 then
              insert into jaqz596_tem (v1scsuc, v1sccta, v1scoper, v1scmda, v1scpap, v1scmod, v1scsbop, v1sctope, v1scfval, v1scstat,
                                     v1scsdo, fecha_contable,fecha_inicial, estado, producto, cliente, moneda ,sucursal, transac, usuariot, flag )

             select f.AOsuc v1scsuc,
                   f.AOcta v1sccta,
                   f.AOoper v1scoper,
                   f.AOmda v1Scmda,
                   f.AOpap v1Scpap,
                   f.AOmod v1Scmod,
                   f.AOsbop v1Scsbop,
                   f.AOtope v1Sctope,
                   f.AOfval v1Scfval,
                   f.aostat v1Scstat,
                   abs(f.aoimp) v1Scsdo,
                   to_char(f.aofval ,'dd/mm/yyyy')  Fecha_contable,
                   (select min(b.aofval)
                      from fsd010 b
                     where b.pgcod = 1
                       and b.aomod = f.AOmod
                       and b.aocta = f.AOcta
                       and b.aooper = f.AOoper
                       and b.aosuc = f.AOsuc) fecha_inicial,
                   'REPROGRAMADO' ESTADO,--(SELECT Cenom FROM fst026 where Cecod = f.AOstat) ESTADO,
                   (SELECT Mdnom from fst003 where Modulo = f.AOmod) PRODUCTO,
                   (select r.penom
                      from fsr008 t ,
                           fsd001 r
                     where t.pgcod = 1
                       and t.ctnro = f.AOcta
                       and t.cttfir ='T'
                       and r.pepais = t.pepais
                       and r.petdoc = t.petdoc
                       and r.pendoc = t.pendoc) cliente,
                   (select mosign from fst005 where moneda = f.AOmda) moneda,
                   (select Scnom
                      from FST001
                     Where Pgcod = 1
                       and Sucurs =f.AOSUC) sucursal,
                   c.xwfttran transac,
                   LC_USUARIO usu,
                   'R' flag
         FROM xwf070 c, xwf700 a, fsd010 f
             where c.xwfpgcod = 1
               and c.xwftmod = 117
               and c.xwftsuc = LN_SUCUR
               and c.xwfttran = 10 --r.tran --360--in (951,360,350)
               and c.xwffcon >= to_Date('01/07/2013','dd/mm/rrrr')
               and c.xwfcont = 'S'
               AND a.xwfprcins = c.xwfprcin
               and a.xwfcar3 = '1'
               AND f.PGCOD = a.xwfempresa --PGCOD, SCMOD, SCMDA, SCPAP, SCCTA, SCSUC, SCOPER, SCSBOP, SCTOPE
               and f.AOMOD = a.xwfmodulo
               AND f.AOmod = 117
               and f.AOMDA = a.xwfmoneda
               and f.AOPAP = a.xwfpapel
               and f.AOCTA = a.xwfcuenta
               and f.AOSUC = a.xwfsucursal
               and f.AOOPER = a.xwfoperacion
               and f.AOSBOP = a.xwfsubope
               and f.AOTOPE = a.xwftipope
               AND f.AOstat = 99
--and f.aocta = 1960046 --pruebas
               and f.AOSUC <> c.xwftsuc
               and f.aofe99 > to_Date('01/03/2020','dd/mm/rrrr')
               and exists (select 1
                             from fsd010
                            where pgcod = 1
                              and aomod  = f.aomod
                              and aosuc = f.AOSUC
                              and aomda = f.aomda
                              and aopap = f.aopap
                              and aocta = f.aocta
                              and aooper = f.aooper
                              and aosbop <> 0
                              and aotope = f.aotope
                              and aostat <> 99)
               and not exists(SELECT 1 
                            FROM AQPB178 A 
                           WHERE A.AQPB178TFLU = 'D' 
                             and aqpb178ctacr = f.aocta
                             and aqpb178opecr = f.aooper
                             and rownum = 1 ) 
              ;
           else
            insert into jaqz596_tem (v1scsuc, v1sccta, v1scoper, v1scmda, v1scpap, v1scmod, v1scsbop, v1sctope, v1scfval, v1scstat,
                                     v1scsdo, fecha_contable,fecha_inicial, estado, producto, cliente, moneda ,sucursal, transac, usuariot, flag )
            select f.AOsuc v1scsuc,
                   f.AOcta v1sccta,
                   f.AOoper v1scoper,
                   f.AOmda v1Scmda,
                   f.AOpap v1Scpap,
                   f.AOmod v1Scmod,
                   f.AOsbop v1Scsbop,
                   f.AOtope v1Sctope,
                   f.AOfval v1Scfval,
                   f.aostat v1Scstat,
                   abs(f.aoimp) v1Scsdo,
                   to_char(f.aofval ,'dd/mm/yyyy')  Fecha_contable,
                   (select min(b.aofval)
                      from fsd010 b
                     where b.pgcod = 1
                       and b.aomod = f.AOmod
                       and b.aocta = f.AOcta
                       and b.aooper = f.AOoper
                       and b.aosuc = f.AOsuc) fecha_inicial,
                   'REPROGRAMADO' ESTADO,--(SELECT Cenom FROM fst026 where Cecod = f.AOstat) ESTADO,
                   (SELECT Mdnom from fst003 where Modulo = f.AOmod) PRODUCTO,
                   (select r.penom
                      from fsr008 t ,
                           fsd001 r
                     where t.pgcod = 1
                       and t.ctnro = f.AOcta
                       and t.cttfir ='T'
                       and r.pepais = t.pepais
                       and r.petdoc = t.petdoc
                       and r.pendoc = t.pendoc)  cliente,
                   (select mosign from fst005 where moneda = f.AOmda) moneda,
                   (select Scnom
                      from FST001
                     Where Pgcod = 1
                       and Sucurs =f.AOSUC) sucursal,
                   c.xwfttran transac,
                   LC_USUARIO usu,
                   'R' flag
              FROM xwf070 c, xwf700 a, fsd010 f, fsh015 g
             where g.pgcod = c.xwfpgcod
               and g.hcmod = c.xwftmod
               and g.hsucor = c.xwftsuc
               and g.htran = c.xwfttran
               and g.hnrel = c.xwfnrel
               and g.hfcon = c.xwffcon
               and g.hccorr = 0
               and c.xwfpgcod = 1
               and c.xwftmod = 30
               and c.xwftsuc = LN_SUCUR
               and c.xwfttran = r.tran --360--in (951,360,350)
               and c.xwffcon >= to_Date('01/07/2013','dd/mm/rrrr')
               and c.xwfcont = 'S'
               AND a.xwfprcins = c.xwfprcin
               and a.xwfcar3 = '1'
               AND f.PGCOD = a.xwfempresa --PGCOD, SCMOD, SCMDA, SCPAP, SCCTA, SCSUC, SCOPER, SCSBOP, SCTOPE
               and f.AOMOD = a.xwfmodulo
               AND f.AOmod = m.tp1nro1
               and f.AOMDA = a.xwfmoneda
               and f.AOPAP = a.xwfpapel
               and f.AOCTA = a.xwfcuenta
               and f.AOSUC = a.xwfsucursal
               and f.AOOPER = a.xwfoperacion
               and f.AOSBOP = a.xwfsubope
               and f.AOTOPE = a.xwftipope
               AND f.AOstat = 99
               and f.AOSUC <> c.xwftsuc
               and f.aofe99 > to_Date('01/03/2020','dd/mm/rrrr')
               and exists (select 1
                             from fsd010
                            where pgcod = 1
                              and aomod  = f.aomod
                              and aosuc = f.AOSUC
                              and aomda = f.aomda
                              and aopap = f.aopap
                              and aocta = f.aocta
                              and aooper = f.aooper
                              and aosbop <> 0
                              and aotope = f.aotope
                              and aostat <> 99)
               and not exists (select 1
                                  from fsd601
                                 where pgcod = 1
                                   and ppmod = f.aomod
                                   and ppsuc = f.AOSUC
                                   and ppmda = f.aomda
                                   and pppap = f.aopap
                                   and ppcta = f.aocta
                                   and ppoper = f.aooper
                                   and ppsbop = 0
                                   and pptope = f.aotope
                                   and d601mo = 489
                                   and rownum = 1)
               ---validacion credinka
               and not exists(SELECT 1 
                                FROM AQPB178 A 
                               WHERE A.AQPB178TFLU = 'D' 
                                 and aqpb178ctacr = f.aocta	
                                 and aqpb178opecr = f.aooper
                                 and rownum = 1 )
             ;
        end if;
      end loop;
      commit;
    END loop;
    commit;


   -----------------------------------------

      for reg in jaqz596(lc_usuario) loop
          fecha2 :=  Fecha_desembolso2(reg.v1scmod,
                                       reg.v1scsuc,
                                       reg.v1scmda,
                                       reg.v1sccta,
                                       reg.v1scoper,
                                       reg.v1scsbop,
                                       reg.v1Sctope);
         Begin
           select 1
              into Existe --- Verifica desembolso Caja Movil
              from fsd601
             where pgcod = 1
               and ppmod = reg.v1Scmod
               and ppsuc = LN_SUCUR
               and ppmda = reg.v1Scmda
               and pppap = reg.v1Scpap
               and ppcta = reg.v1SCCTA
               and ppoper = reg.v1SCOPER
               and ppsbop = reg.v1Scsbop
               and pptope = reg.v1Sctope
               and d601mo = 489
               and rownum = 1;
---               and d601tr = 951;
         exception
           when no_data_found then
             BEGIN
               Select 1
                 into existe
                 from fsh016 a,
                      fsh015 b
                where a.pgcod = 1
                  and a.hcmod = 489
                  and a.htran = 951
                  and a.hmodul = reg.v1Scmod
                  and a.htoper = reg.v1Sctope
                  and a.hsucur = LN_SUCUR
                  and a.hmda = reg.v1Scmda
                  and a.hpap = reg.v1Scpap
                  and a.hcta = reg.v1SCCTA
--and a.hcta = 1960046
                  and a.hoper = reg.v1SCOPER
                  and a.hsubop = reg.v1Scsbop
                  and a.hfcon = reg.v1Scfval
                  and b.pgcod = a.pgcod
                  and b.hcmod = a.hcmod
                  and b.hsucor = a.hsucor
                  and b.htran = a.htran
                  and b.hnrel = a.hnrel
                  and b.hfcon = a.hfcon
                  and b.hccorr = 0;
             exception
               when no_data_found then
                 existe := 0;
             end;
           when too_many_rows then
             existe := 1;
         end;

         if existe = 0 then ---No Caja Movil
             Begin

                 IF reg.v1Scmod = 117 then
                   estado := estado_linea(pn_cuenta => reg.v1sccta , pn_operacion =>reg.v1scoper );
                   if estado is null then
                      estado:= reg.estado;
                   end if;
                 else
                   estado := reg.estado;
                 end if;
                 ---- verifica reprogramacion
                 IF reg.transac = 0 then
                     For a in reprog loop


                      BEgin
                        SElect 'S'--1--d602tr
                          into reprog1 --transaccion
                          from fsd602
                         where pgcod = 1
                           AND ppmod  = reg.v1Scmod
                           AND ppsuc  = reg.v1scsuc
                           AND ppmda  = reg.v1Scmda
                           AND pppap  = reg.v1Scpap
                           AND ppcta  = reg.v1sccta  ---225267
--and ppcta = 1960046
                           and ppoper  = reg.v1scoper---   6071016
                           AND pptope = reg.v1Sctope
                           and pp1stat ='T'
                           and d602mo = a.tp1nro1
                           and d602tr = a.tp1nro2
                           and d602fc > to_date('01/03/2020','dd/mm/rrrr')
                           and d602co = 'S'
                           and rownum = 1;
                           exit;
                       exception
                         when no_data_found then
                           reprog1 := 'N';--- v_conta := 0;
                       end;
                     End loop;
                     if reprog1 = 'N' then
                        begin
                          select 'S'
                           into reprog1
                           from JAQA400
                           where jaqa400emp = 1
                             and jaqa400mod = reg.v1Scmod
                             and jaqa400suc = reg.v1Scsuc
                             and jaqa400mda = reg.v1Scmda
                             and jaqa400pap = reg.v1Scpap
                             and jaqa400cta = reg.v1Sccta
                             and jaqa400ope = reg.v1scoper
                             and jaqa400sbo = reg.v1scsbop
                             and jaqa400top = reg.v1Sctope
                             and jaqa400est = 'C'
                             and rownum = 1;
                        exception
                           when others then
                            null;
                        end;
                     end if;
                     fechadesembolso := null;
                     fechaALTA:= null;
                     if reprog1 = 'S' then--transaccion = 356 then
                       v_sboper := 0;
                       BEgin
                        SElect aofval
                          into fecha1rep --fecha alta
                          from fsd010
                         where pgcod = 1
                           AND aomod = reg.v1Scmod
                           AND aosuc = reg.v1scsuc
                           AND aomda = reg.v1Scmda
                           AND aopap = reg.v1Scpap
                           AND aocta = reg.v1sccta  ---225267
                           and aooper = reg.v1scoper---   6071016
                           and aosbop = 0
                           AND aotope = reg.v1Sctope;
                       exception
                         when no_data_found then
                            begin
                             SElect aofval
                              into fecha1rep --fecha alta
                              from fsd010
                             where pgcod = 1
                               AND aocta = reg.v1sccta  ---225267
                               and aooper = reg.v1scoper---   6071016
                               and aosbop = 0;
                           exception
                             when others then
                               fecha1rep := null;
                           end;
                       end;
                       BEgin
                        SElect aofval
                          into fecha2rep
                          from fsd010
                         where pgcod = 1
                           AND aomod = reg.v1Scmod
                           AND aosuc = reg.v1scsuc
                           AND aomda = reg.v1Scmda
                           AND aopap = reg.v1Scpap
                           AND aocta = reg.v1sccta  ---225267
                           and aooper = reg.v1scoper---   6071016
                           and aosbop = reg.v1Scsbop
                           AND aotope = reg.v1Sctope;
                       exception
                         when no_data_found then
                           fecha2rep :=null;
                       end;
                      --fechadesembolso := fecha2rep; ---reg.fecha_inicial;
                      --fechaALTA:= fecha1rep; --reg.fecha2;
                      fechadesembolso := fecha1rep; ---reg.fecha_inicial;
                      fechaALTA:=fecha2rep ; --reg.fecha2;

                     else
                       v_sboper := reg.v1scsbop;
                       fechadesembolso := reg.fecha_inicial; ---fecha1,
                      fechaALTA:= fecha2; --reg.fecha2;

                     end if;
                 else
                      v_sboper := reg.v1scsbop;
                       fechadesembolso := reg.fecha_inicial; ---fecha1,
                      fechaALTA:= fecha2; ---reg.fecha2;
                 end if;

               --SUCURSAL DE DESEMBOLSO
              Begin
                select xwftsuc
                  into agencia--,   usudes
                  FROM xwf070
                 where xwfprcin = (select nvl(xwfprcins,0)
                                     from xwf700
                                    where xwfempresa = 1
                                      and xwfsucursal = reg.v1scsuc
                                      and xwfmodulo = reg.v1scmod
                                      and xwfmoneda = reg.v1scmda
                                      and xwfpapel = reg.v1scpap
                                      and xwfcuenta = reg.v1sccta
                                      and xwfoperacion =  reg.v1scoper
                                      and xwfsubope = v_sboper ---reg.v1scsbop
                                      and xwfcar3 = '1'
                                      and rownum =1)
                   and xwftmod = 30
                   and xwfttran in (select tp1nro2
                                      from fst198
                                     where Tp1cod = 1
                                       and Tp1cod1 = 10884
                                       and Tp1corr1 = 15
                                       and tp1nro1 = 30)
                   and xwffcon = reg.fecha_inicial
                   and xwfcont = 'S';
                   if agencia <>  reg.v1scsuc then
                     observacion :='OTRA AGENCIA';
                   else
                     observacion := null;
                   End if;
              Exception
                when no_data_found then
                  Begin --sma 090120
                    select xwftsuc
                      into agencia--,   usudes
                      FROM xwf070
                     where xwfprcin = (select NVL(xwfprcins,0)
                                         from xwf700
                                        where xwfempresa = 1
                                          and xwfsucursal = reg.v1scsuc
                                          and xwfmodulo = reg.v1scmod
                                          and xwfmoneda = reg.v1scmda
                                          and xwfpapel = reg.v1scpap
                                          and xwfcuenta = reg.v1sccta
                                          and xwfoperacion = reg.v1scoper
                                          and xwfsubope = v_sboper --reg.v1scsbop
                                          and xwfcar3 = '1' --in ('1','A')
                                          and rownum =1)
                       and xwftmod = 117
                       and xwfttran = 10
                       and xwffcon = reg.fecha_inicial
                       and xwfcont in('B','S');

                       if agencia <>  reg.v1scsuc then
                         observacion :='OTRA AGENCIA';
                       else
                         observacion := null;
                       End if;
                  Exception
                    when no_Data_found then
                      Begin --sma 060220
                        select xwftsuc
                          into agencia--,   usudes
                          FROM xwf070
                         where xwfprcin = (select NVL(xwfprcins,0)
                                             from xwf700
                                            where xwfempresa = 1
                                              and xwfsucursal = reg.v1scsuc
                                              and xwfmodulo = reg.v1scmod
                                              and xwfmoneda = reg.v1scmda
                                              and xwfpapel = reg.v1scpap
                                              and xwfcuenta = reg.v1sccta
                                              and xwfoperacion = reg.v1scoper
                                              and xwfsubope = v_sboper---reg.v1scsbop
                                              and xwfcar3 = 'A'--in ('1','A')
                                              and rownum =1)
                           and xwftmod = 117
                           and xwfttran = 10
                           and xwffcon = reg.fecha_inicial
                           and xwfcont in ('B','S');--sma 20250122

                           if agencia <>  reg.v1scsuc then
                             observacion :='OTRA AGENCIA';
                           else
                             observacion := null;
                           End if;
                      Exception
                        when no_Data_found then
                          Begin
                            select xwftsuc
                              into agencia--,   usudes
                              FROM xwf070
                             where xwfprcin = (select nvl(xwfprcins,0)
                                                 from xwf700
                                                where xwfempresa = 1
                                                  and xwfsucursal = reg.v1scsuc
                                                  and xwfmodulo = reg.v1scmod
                                                  and xwfmoneda = reg.v1scmda
                                                  and xwfpapel = reg.v1scpap
                                                  and xwfcuenta = reg.v1sccta
                                                  and xwfoperacion =  reg.v1scoper
                                                  and xwfsubope = 0
                                                  and xwfcar3 = '1'
                                                  and rownum =1)
                               and xwftmod = 30
                               and xwfttran in (select tp1nro2
                                                  from fst198
                                                 where Tp1cod = 1
                                                   and Tp1cod1 = 10884
                                                   and Tp1corr1 = 15
                                                   and tp1nro1 = 30)
                               and xwffcon = reg.fecha_inicial
                               and xwfcont = 'S';

                               if agencia <>  reg.v1scsuc then
                                 observacion :='OTRA AGENCIA';
                               else
                                 observacion := null;
                               End if;
                          Exception
                            when no_data_found then
                              begin ---25012023 SMARQUEZ
                                select d601su
                                  into agencia
                                  from fsd601
                                 where pgcod = 1
                                   and ppmod = reg.v1scmod
                                   and ppsuc = reg.v1scsuc
                                   and ppmda = reg.v1scmda
                                   and pppap = reg.v1scpap
                                   and ppcta = reg.v1sccta
                                   and ppoper = reg.v1scoper
                                   and ppsbop = reg.v1scsbop
                                   and pptope = reg.v1sctope
                                   and d601mo  = 30
                                   and d601tr  in (select tp1nro2
                                                     from fst198
                                                    where Tp1cod = 1
                                                      and Tp1cod1 = 10884
                                                      and Tp1corr1 = 15
                                                      and tp1nro1 = 30)
                                   and d601fc  = reg.fecha_inicial
                                   and d601co = 'S'
                                   and rownum = 1;
                                   if agencia <>  reg.v1scsuc then
                                     observacion :='OTRA AGENCIA';
                                   else
                                     observacion := null;
                                   End if;
                              exception
                                when no_data_found then
                                  Begin --SMA 23052025
                                    select d601su
                                      into agencia
                                      from fsd601
                                     where pgcod = 1
                                       and ppmod = 116
                                       and ppsuc = reg.v1scsuc
                                       and ppmda = reg.v1scmda
                                       and pppap = reg.v1scpap
                                       and ppcta = reg.v1sccta
                                       and ppoper = reg.v1scoper
                                       and ppsbop = reg.v1scsbop
                                       and pptope = reg.v1sctope
                                       and d601mo  = 116
                                       and d601tr  = 50
                                       and d601fc  = reg.fecha_inicial
                                       and d601co = 'S'
                                       and rownum = 1;
                                       if agencia <>  reg.v1scsuc then
                                         observacion :='OTRA AGENCIA';
                                       else
                                         observacion := null;
                                       End if;
                                  exception
                                    when no_data_found then
                                      agencia := reg.v1scsuc;
                                      observacion := null;
                                  end;
                              end;
                          end;
                      end;
                      When too_many_rows then
                           Begin --sma 090120
                              select xwftsuc
                                into agencia--,   usudes
                                FROM xwf070
                               where xwfprcin = (select NVL(xwfprcins,0)
                                                   from xwf700
                                                  where xwfempresa = 1
                                                    and xwfsucursal = reg.v1scsuc
                                                    and xwfmodulo = reg.v1scmod
                                                    and xwfmoneda = reg.v1scmda
                                                    and xwfpapel = reg.v1scpap
                                                    and xwfcuenta = reg.v1sccta
                                                    and xwfoperacion = reg.v1scoper
                                                    and xwfsubope = v_sboper-- reg.v1scsbop
                                                    and xwfcar3 = '1' --in ('1','A')
                                                    and rownum =1)
                                 and xwftmod = 117
                                 and xwfttran = 10
                                 and xwffcon = reg.fecha_inicial
                                 and xwfcont = 'S'
                                 and rownum = 1;

                                 if agencia <>  reg.v1scsuc then
                                   observacion :='OTRA AGENCIA';
                                 else
                                   observacion := null;
                                 End if;
                         end;
                  end;
                when too_many_rows then
                  dbms_output.put_line(reg.v1sccta||','||reg.v1scoper||','||reg.v1scsuc||','||reg.v1scsbop||','||reg.v1sctope);
              End;
              if fechadesembolso is not null and fechaALTA is not null then
                  analista1 := fn_analista_credito(reg.v1scmod,
                                                   reg.v1scsuc,
                                                   reg.v1scmda,
                                                   reg.v1scpap,
                                                   reg.v1sccta,
                                                   reg.v1scoper,
                                                   reg.v1scsbop,
                                                   reg.v1Sctope) ;
                   montoA := Monto_Aprobado(reg.v1sccta,
                                            reg.v1scoper,
                                            reg.v1scmda,
                                            reg.v1scmod,
                                            reg.v1scsbop,
                                            reg.v1scsuc,
                                            reg.v1Sctope) ;

                  cuotas := cuotas_pendientes(1,
                                               reg.v1scmod,
                                               reg.v1scsuc,
                                               reg.v1scmda,
                                               reg.v1scpap,
                                               reg.v1sccta,
                                               reg.v1scoper,
                                               reg.v1scsbop,
                                               reg.v1Sctope);
                    fechajud :=  Fecha_judicial(1,
                                               reg.v1scmod,
                                               reg.v1scsuc,
                                               reg.v1scmda,
                                               reg.v1scpap,
                                               reg.v1sccta,
                                               reg.v1scoper,
                                               reg.v1scsbop,
                                               reg.v1Sctope,
                                               reg.v1scstat);

               if agencia <> LN_SUCUR then
                  if trim(reg.sucursal) = trim(nomage) then
                    flagI := 'S';
                  else
                    flagI := 'N';
                  end if;
               else
                   flagI := 'S';
               end if;
               begin
                 select 'S'
                   into flagnewope
                   from fsd010
                  where pgcod = 1
                    and aomod = reg.v1scmod
                    and aosuc = reg.v1scsuc
                    and aomda = reg.v1scmda
                    and aopap = reg.v1scpap
                    and aocta = reg.v1sccta
                    and aooper = reg.v1scoper
                    and aosbop > 0
                    and aotope = reg.v1sctope
                    and rownum = 1;
               exception
                 when no_data_found then
                   flagnewope :=  'N';
               end;

               if reg.v1scsbop = 0 and reg.v1scstat = 61 and flagnewope = 'S' then
                 var_refiImprime := 'N';
               else
                 var_refiImprime :='S';
               end if;

               if flagI = 'S' and var_refiImprime ='S' then
                 insert into jaqy680 (jaqy680cod,
                                      jaqy680cta,
                                      jaqy680ope,
                                      jaqy680fe1,
                                      jaqy680fe2,
                                      jaqy680suc,
                                      jaqy680cli,
                                      jaqy680pro,
                                      jaqy680est,
                                      jaqy680res,
                                      jaqy680mda,
                                      jaqy680mto,
                                      jaqy680sdo,
                                      jaqy680au3,
                                      jaqy680au4,
                                      jaqy680au5,
                                 --     jaqy680au1,
                                      jaqy680au2,
                                      jaqy680feju,
                                      jaqy680au6)
                               values (agencia, --reg.v1scsuc,
                                       reg.v1sccta,
                                       reg.v1scoper,
                                       fechadesembolso, ---reg.fecha_inicial, ---fecha1,
                                       fechaALTA, --reg.fecha2,
                                       reg.sucursal,
                                       reg.cliente,
                                       reg.producto,
                                       estado,
                                       analista1, --reg.analista,
                                       reg.moneda,---MONEDA,
                                       montoA, --reg.montoA,
                                       reg.v1scsdo,
                                       cuotas, --reg.cuotas,
                                       LC_USUARIO,
                                       reg.v1scfval,
                                       reg.v1SCSUC,
                                       fechajud,--reg.fechajud,
                                       reprog1);
                  commit;
                 end if;
               end if;
             exception
               when no_data_found then
                 null;
               when dup_val_on_index then
                 null;
             end;
         end if;
    end loop;

    For reg1 in remotouno(lc_usuario) loop
          Begin
            v_sboper := 0;
            reprog1 :='S';
            -----------

            analista1 := fn_analista_credito(reg1.v1scmod,
                                             reg1.v1scsuc,
                                             reg1.v1scmda,
                                             reg1.v1scpap,
                                             reg1.v1sccta,
                                             reg1.v1scoper,
                                             reg1.v1scsbop,
                                             reg1.v1Sctope) ;
             montoA := Monto_Aprobado(reg1.v1sccta,
                                      reg1.v1scoper,
                                      reg1.v1scmda,
                                      reg1.v1scmod,
                                      reg1.v1scsbop,
                                      reg1.v1scsuc,
                                      reg1.v1Sctope) ;
            fecha2 :=  Fecha_desembolso2(reg1.v1scmod,
                                         reg1.v1scsuc,
                                         reg1.v1scmda,
                                         reg1.v1sccta,
                                         reg1.v1scoper,
                                         reg1.v1scsbop,
                                         reg1.v1Sctope);
            cuotas := cuotas_pendientes(1,
                                         reg1.v1scmod,
                                         reg1.v1scsuc,
                                         reg1.v1scmda,
                                         reg1.v1scpap,
                                         reg1.v1sccta,
                                         reg1.v1scoper,
                                         reg1.v1scsbop,
                                         reg1.v1Sctope);
              fechajud :=  Fecha_judicial(1,
                                         reg1.v1scmod,
                                         reg1.v1scsuc,
                                         reg1.v1scmda,
                                         reg1.v1scpap,
                                         reg1.v1sccta,
                                         reg1.v1scoper,
                                         reg1.v1scsbop,
                                         reg1.v1Sctope,
                                         reg1.v1scstat);

            --------------
             --SUCURSAL DE DESEMBOLSO
                  Begin
                    select xwftsuc
                      into agencia--,   usudes
                      FROM xwf070
                     where xwfprcin = (select nvl(xwfprcins,0)
                                         from xwf700
                                        where xwfempresa = 1
                                          and xwfsucursal = reg1.v1scsuc
                                          and xwfmodulo = reg1.v1scmod
                                          and xwfmoneda = reg1.v1scmda
                                          and xwfpapel = reg1.v1scpap
                                          and xwfcuenta = reg1.v1sccta
                                          and xwfoperacion =  reg1.v1scoper
                                          and xwfsubope = v_sboper ---reg1.v1scsbop
                                          and xwfcar3 = '1'
                                          and rownum =1)
                       and xwftmod = 30
                       and xwfttran = reg1.transac --r.tran --360--951 verificar
                       and xwffcon = reg1.fecha_inicial
                       and xwfcont = 'S';
                       if agencia <>  reg1.v1scsuc then
                         observacion :='OTRA AGENCIA';
                       else
                         observacion := null;
                       End if;
                  Exception
                    when no_data_found then
                      Begin --sma 090120
                        select xwftsuc
                          into agencia--,   usudes
                          FROM xwf070
                         where xwfprcin = (select NVL(xwfprcins,0)
                                             from xwf700
                                            where xwfempresa = 1
                                              and xwfsucursal = reg1.v1scsuc
                                              and xwfmodulo = reg1.v1scmod
                                              and xwfmoneda = reg1.v1scmda
                                              and xwfpapel = reg1.v1scpap
                                              and xwfcuenta = reg1.v1sccta
                                              and xwfoperacion = reg1.v1scoper
                                              and xwfsubope = v_sboper --reg1.v1scsbop
                                              and xwfcar3 = '1' --in ('1','A')
                                              and rownum =1)
                           and xwftmod = 117
                           and xwfttran = 10
                           and xwffcon = reg1.fecha_inicial
                           and xwfcont in ('S','B');

                           if agencia <>  reg1.v1scsuc then
                             observacion :='OTRA AGENCIA';
                           else
                             observacion := null;
                           End if;
                      Exception
                        when no_Data_found then
                          Begin --sma 060220
                            select xwftsuc
                              into agencia--,   usudes
                              FROM xwf070
                             where xwfprcin = (select NVL(xwfprcins,0)
                                                 from xwf700
                                                where xwfempresa = 1
                                                  and xwfsucursal = reg1.v1scsuc
                                                  and xwfmodulo = reg1.v1scmod
                                                  and xwfmoneda = reg1.v1scmda
                                                  and xwfpapel = reg1.v1scpap
                                                  and xwfcuenta = reg1.v1sccta
                                                  and xwfoperacion = reg1.v1scoper
                                                  and xwfsubope = v_sboper---reg1.v1scsbop
                                                  and xwfcar3 = 'A'--in ('1','A')
                                                  and rownum =1)
                               and xwftmod = 117
                               and xwfttran = 10
                               and xwffcon = reg1.fecha_inicial
                               and xwfcont in ('S','B');

                               if agencia <>  reg1.v1scsuc then
                                 observacion :='OTRA AGENCIA';
                               else
                                 observacion := null;
                               End if;
                          Exception
                            when no_Data_found then
                              begin ---25012023 SMARQUEZ
                                select d601su
                                  into agencia
                                  from fsd601
                                 where pgcod = 1
                                   and ppmod = reg1.v1scmod
                                   and ppsuc = reg1.v1scsuc
                                   and ppmda = reg1.v1scmda
                                   and pppap = reg1.v1scpap
                                   and ppcta = reg1.v1sccta
                                   and ppoper = reg1.v1scoper
                                   and ppsbop = reg1.v1scsbop
                                   and pptope = reg1.v1sctope
                                   and d601mo  = 30
                                   and d601tr  in (select tp1nro2
                                                     from fst198
                                                    where Tp1cod = 1
                                                      and Tp1cod1 = 10884
                                                      and Tp1corr1 = 15
                                                      and tp1nro1 = 30)
                                   and d601fc  = reg1.fecha_inicial
                                   and d601co = 'S'
                                   and rownum = 1;
                               if agencia <>  reg1.v1scsuc then
                                 observacion :='OTRA AGENCIA';
                               else
                                 observacion := null;
                               End if;
                              exception
                                when no_data_found then
                                  begin --SMA 23/058/2025
                                    select d601su
                                      into agencia
                                      from fsd601
                                     where pgcod = 1
                                       and ppmod = 116
                                       and ppsuc = reg1.v1scsuc
                                       and ppmda = reg1.v1scmda
                                       and pppap = reg1.v1scpap
                                       and ppcta = reg1.v1sccta
                                       and ppoper = reg1.v1scoper
                                       and ppsbop = reg1.v1scsbop
                                       and pptope = reg1.v1sctope
                                       and d601mo  = 116
                                       and d601tr  = 50
                                       and d601fc  = reg1.fecha_inicial
                                       and d601co = 'S'
                                       and rownum = 1;
                                       if agencia <>  reg1.v1scsuc then
                                         observacion :='OTRA AGENCIA';
                                       else
                                         observacion := null;
                                       End if;
                                  exception
                                    when no_data_found then     
                                      agencia := reg1.v1scsuc;
                                      observacion := null;
                                  end;
                              end;
                          end;
                          When too_many_rows then
                               Begin --sma 090120
                                  select xwftsuc
                                    into agencia--,   usudes
                                    FROM xwf070
                                   where xwfprcin = (select NVL(xwfprcins,0)
                                                       from xwf700
                                                      where xwfempresa = 1
                                                        and xwfsucursal = reg1.v1scsuc
                                                        and xwfmodulo = reg1.v1scmod
                                                        and xwfmoneda = reg1.v1scmda
                                                        and xwfpapel = reg1.v1scpap
                                                        and xwfcuenta = reg1.v1sccta
                                                        and xwfoperacion = reg1.v1scoper
                                                        and xwfsubope = v_sboper-- reg1.v1scsbop
                                                        and xwfcar3 = '1' --in ('1','A')
                                                        and rownum =1)
                                     and xwftmod = 117
                                     and xwfttran = 10
                                     and xwffcon = reg1.fecha_inicial
                                     and xwfcont = 'S'
                                     and rownum = 1;

                                     if agencia <>  reg1.v1scsuc then
                                       observacion :='OTRA AGENCIA';
                                     else
                                       observacion := null;
                                     End if;
                             end;
                      end;
                    when too_many_rows then
                      null;
                    -- dbms_output.put_line(reg1.v1sccta||','||reg1.v1scoper||','||reg1.v1scsuc||','||reg1.v1scsbop||','||reg1.v1sctope);
                  End;
                  if agencia <> LN_SUCUR then
                    if trim(reg1.sucursal) = trim(nomage) then
                      flagI := 'S';
                    else
                        flagI := 'N';
                    end if;
                 else
                    flagI := 'S';
                 end if;
                 if flagI = 'S' then
                  if reg1.fecha_inicial is not null and fecha2 is not null then --reg1.fecha2 is not null then
                   insert into jaqy680 (jaqy680cod,
                                        jaqy680cta,
                                        jaqy680ope,
                                        jaqy680fe1,
                                        jaqy680fe2,
                                        jaqy680suc,
                                        jaqy680cli,
                                        jaqy680pro,
                                        jaqy680est,
                                        jaqy680res,
                                        jaqy680mda,
                                        jaqy680mto,
                                        jaqy680sdo,
                                        jaqy680au3,
                                        jaqy680au4,
                                        jaqy680au5,
                                   --     jaqy680au1,
                                        jaqy680au2,
                                        jaqy680feju,
                                        jaqy680au6)
                                 values (agencia, --reg1.v1scsuc,
                                         reg1.v1sccta,
                                         reg1.v1scoper,
                                         reg1.fecha_inicial, ---fecha1,
                                         fecha2,---reg1.fecha2,sma 20210201
                                         reg1.sucursal,
                                         reg1.cliente,
                                         reg1.producto,
                                         reg1.estado,--'REPROGRAMADO',sma 15012021
                                         analista1, --reg1.analista,sma 20210201
                                         reg1.moneda,---MONEDA,
                                         montoA,--reg1.montoA,
                                         reg1.v1scsdo,
                                         cuotas, --reg1.cuotas,sma 20210201
                                         LC_USUARIO,
                                         reg1.v1scfval,
                                         reg1.v1SCSUC,
                                         fechajud,--reg1.fechajud,sma 20210201
                                         reprog1);
                      commit;
                   end if;
                  end if;
                 exception
                   when no_data_found then
                     null;
                   when dup_val_on_index then
                     null;
                 end;

      --  end loop;
    end loop;


END SP_AH_GENERA_UNO;

function Monto_Aprobado(cuenta    in number,
                        operacion in number,
                        moneda    in number,
                        modulo    in number,
                        subopera  in number,
                        agencia   in number,
                        tipoope   in number
                        ) return number is
monto1 number(17,2);

Begin

  if modulo <> 116 then
    Begin
      select Aoimp
        into monto1
        from fsd010
       Where Pgcod  = 1
         and Aosuc  = agencia
         and Aomda  = moneda
         and Aotope = tipoope
         and Aopap  = 0
         and Aocta  = cuenta  ---Sccta
         and Aooper = operacion ---Scoper
         and aomod = modulo
         and Aosbop = subopera;---Scsbop;
     Exception
       When no_data_found then
          monto1 := 0;
     end;
   end if;
   if modulo = 116 then
     Begin  --R1COD, R1MOD, R1SUC, R1MDA, R1PAP, R1CTA, R1OPER, R1SBOP, R1TOPE, RELCOD, R2MOD, R2CTA, R2OPER, R2SBOP
       select b.Scsdo
         into monto1
         from fsr011 a,
              fsd011 b
        where a.r1cod = 1
          and a.r1mod = modulo
          and a.r1suc = agencia
          and a.r1mda = moneda
          and a.r1pap = 0
          and a.R1cta = cuenta---Sccta
          and a.R1oper = operacion --Scoper
          and a.r1sbop = subopera
          and a.R1tope = tipoope--in (3,4)
          and a.Relcod = 46
          and a.r2mod = 117
          and a.r011co = 'S'
          and a.r2cta = cuenta
          and b.Scmod = a.R2mod
          and b.Sccta = a.R2cta
          and b.Scoper = a.R2oper
          and b.Scsbop = a.R2sbop
          and b.Scsuc = a.R2suc
          and b.Scmda = a.R2mda
          and b.Scpap = a.R2pap
          and b.Sctope = a.R2tope;

     exception
       when no_data_found then
         monto1 := 0;
     end;
    End if;
   return monto1;
end Monto_Aprobado;

function Fecha_desembolso2(ln_Aomod in number,
                           ln_Aosuc in number,
                           ln_Aomda in number,
                           ln_Aocta in number,
                           ln_Aooper in number,
                           ln_Aosbop in number,
                           ln_Aotope in number)return date is
fec2Desem date;
begin
  if  ( ln_aomod <> 117 and ln_aomod <> 200 and ln_aomod <> 116) then
       if ln_aotope <> 550 then
         Begin
           select Aofval
             into fec2Desem
             from fsd010
            where Pgcod = 1
              and Aomod = ln_aomod
              and Aosuc = ln_aosuc
              and Aomda = ln_aomda
              and Aopap = 0
              and Aocta = ln_Aocta
              and Aooper = ln_Aooper
              and Aosbop = ln_Aosbop
              and Aotope = ln_aotope;
         exception
           when no_data_found then
               fec2Desem := null;
         end;
       else

           Begin
            select min(b.Aofval)
              into fec2Desem
              from fsr011 a,
                   fsd010 b
             where a.Relcod = 52
               and a.R2mod  = ln_aomod
               and a.R2cta  = ln_Aocta
               and a.R2oper = ln_Aooper
               and a.R2sbop = ln_Aosbop
               and a.R2cod  = 1
               and a.R2suc  = ln_aosuc
               and a.R2mda  = ln_aomda
               and a.R2pap  = 0
               and a.R2tope = ln_aotope
               and a.R011co = 'S'
               and b.Pgcod = a.R1COD
               and b.Aomod = a.R1MOD
               and b.Aosuc = a.R1suc
               and b.Aomda = a.R1mda
               and b.Aopap = a.R1pap
               and b.Aocta = a.R1cta
               and b.Aooper = a.R1oper
               and b.Aosbop = a.R1sbop
               and b.Aotope = a.R1tope;
           exception
             when no_data_found then
                fec2Desem := null;
           end;
       end if;
 else
    if ln_aomod = 117 then

        select min(b.Aofval)
         into fec2Desem
         from fsr011 a,
              fsd010 b
        where a.R1cod = 1
          and a.R1mod = 116
          and a.R1mda = ln_aomda
          and a.R1pap = 0
          and a.R1cta = ln_Aocta
          and a.R1sbop = ln_Aosbop
          and a.R1tope = ln_aotope
          and a.Relcod = 46
          and a.R2mod  = ln_aomod
          and a.R2cta  = ln_Aocta
          and a.R2oper = ln_Aooper
          and a.R2sbop = ln_Aosbop
          and a.R2cod  = 1
          and a.R2suc  = ln_aosuc
          and a.R2mda  = ln_aomda
          and a.R2pap  = 0
          and a.R2tope = ln_aotope
          and a.R011co = 'S'
          and b.Pgcod = a.R1COD
          and b.Aomod = a.R1MOD
          and b.Aosuc = a.R1suc
          and b.Aomda = a.R1mda
          and b.Aopap = a.R1pap
          and b.Aocta = a.R1cta
          and b.Aooper = a.R1oper
          and b.Aosbop = a.R1sbop
          and b.Aotope = a.R1tope;
    end if;
    if ln_aomod = 116  then
       Begin
         select min(b.Aofval)
           into fec2Desem
           from fsr011 a,
                fsd010 b
          where a.R1cod  = 1
            and a.R1mod  = ln_aomod
            and a.R1suc  = ln_aosuc
            and a.R1mda  = ln_aomda
            and a.R1pap  = 0
            and a.R1cta  = ln_Aocta
            and a.R1sbop = ln_Aosbop
            and a.R1tope = ln_aotope
            and a.Relcod = 46
            and a.R2mod  = 117
            and a.R2cta  = ln_Aocta
            and a.R011co = 'S'
            and b.Pgcod = a.R1COD
            and b.Aomod = a.R1MOD
            and b.Aosuc = a.R1suc
            and b.Aomda = a.R1mda
            and b.Aopap = a.R1pap
            and b.Aocta = a.R1cta
            and b.Aooper = a.R1oper
            and b.Aosbop = a.R1sbop
            and b.Aotope = a.R1tope;
       exception
         when no_data_found then
           fec2Desem := null;
       end;
     end if;
     if (ln_aomod = 200 or  ln_aotope = 550)then
       Begin
        select min(b.Aofval)
          into fec2Desem
          from fsr011 a,
               fsd010 b
         where a.Relcod = 52
           and a.R2mod   = ln_aomod
           and a.R2cta  = ln_Aocta
           and a.R2oper = ln_aooper
           and a.R2sbop = ln_Aosbop
           and a.R2cod   = 1
           and a.R2suc   = ln_aosuc
           and a.R2mda   = ln_aomda
           and a.R2pap   = 0
           and a.R2tope = ln_aotope
           and a.R011co = 'S'
           and b.Pgcod = a.R1COD
           and b.Aomod = a.R1MOD
           and b.Aosuc = a.R1suc
           and b.Aomda = a.R1mda
           and b.Aopap = a.R1pap
           and b.Aocta = a.R1cta
           and b.Aooper = a.R1oper
           and b.Aosbop = a.R1sbop
           and b.Aotope = a.R1tope;
       Exception
         when no_data_found then
           fec2Desem := null;
       end;
     end if;
 end if;
  return fec2Desem;
end Fecha_desembolso2;
-----------------------------------------------------
function cuotas_pendientes(pn_emp in number,
                           pn_mod in number,
                           pn_suc in number,
                           pn_mda in number,
                           pn_pap in number,
                           pn_cta in number,
                           pn_oper in number,
                           pn_sbop in number,
                           pn_top in number) return varchar2 is
CuotasPe varchar2(20);
CuotasFa number:=0;
cuotasTo number :=0;
fecpro date;
begin
  select pgfape
    into fecpro
    from fst017
   where pgcod = 1;

  begin
    --/*+ parallel(n,2,1)*/
    select
           count(n.ppfpag)
      into CuotasFa
      from fsd601 n
     where n.pgcod  = pn_emp
       and n.ppmod  = pn_mod
       and n.ppsuc  = pn_suc
       and n.ppmda  = pn_mda
       and n.pppap  = pn_pap
       and n.ppcta  = pn_cta
       and n.ppoper = pn_oper
       and n.ppsbop = pn_sbop
       and n.pptope = pn_top
       and n.d601co = 'S'
       and (n.ppcap+n.ppint)<>0
       and not exists
                (select  ppmod, ppcta,ppoper, pptope,ppfpag --/*+ parallel(o,2,1)*/
                   from fsd602 o
                  where o.pgcod   = n.pgcod
                    and o.ppmod   = n.ppmod
                    and o.ppsuc   = n.ppsuc
                    and o.ppmda   = n.ppmda
                    and o.pppap   = n.pppap
                    and o.ppcta   = n.ppcta
                    and o.ppoper  = n.ppoper
                    and o.ppsbop  = n.ppsbop
                    and o.pptope  = n.pptope
                    and o.ppfpag  = n.ppfpag
                    and o.pp1fech  <= fecpro
                    and o.pp1stat = 'T'
                    and o.d602co  = 'S'
                    and (o.pp1cap+o.pp1int)<>0);
  end;
  begin
    --/*+ parallel(n,2,1)*/
    select count(n.ppfpag)
      into CuotasTo
      from fsd601 n
     where n.pgcod  = pn_emp
       and n.ppmod  = pn_mod
       and n.ppsuc  = pn_suc
       and n.ppmda  = pn_mda
       and n.pppap  = pn_pap
       and n.ppcta  = pn_cta
       and n.ppoper = pn_oper
       and n.ppsbop = pn_sbop
       and n.pptope = pn_top

       and n.d601co = 'S'
       and (n.ppcap+n.ppint)<>0;
   end;
       CuotasPe := to_char(cuotasFa)||'/'||to_char(cuotasTo);
  return CuotasPe;
end cuotas_pendientes;
------------------------------------------------------
function estado_linea(pn_cuenta in number,
                      pn_operacion in number) return varchar2 is

  CURSOR Estados is
     select *
       from fsr011
      where relcod= 46
        and r2cta = pn_cuenta
        and r2oper = pn_operacion
        and r2mod =117
        order by r1tope;
estado number;
descestado varchar2(30);
Begin
  for est in Estados loop
    begin
        select scstat
          into estado
          from fsd011
         where pgcod = 1
           and scsuc = est.r1suc
           and scmda = est.r1mda
           and scpap = est.r1pap
           and sccta = est.r1cta
           and scoper = est.r1oper
           and scsbop = est.r1sbop
           and sctope = est.r1tope
           and scmod = 33
           and scstat <> 99
           and rownum = 1;

    exception
      when no_data_found then
        Begin
          select scstat
            into estado
            from fsd011
           where pgcod = 1
             and scsuc = est.r1suc
             and scmda = est.r1mda
             and scpap = est.r1pap
             and sccta = est.r1cta
             and scoper = est.r1oper
             and scsbop = est.r1sbop
             and sctope = est.r1tope
             and scmod = 200
             and scstat <> 99
             and rownum = 1;
          Exception
            when no_data_found then
              Begin
                select scstat
                  into estado
                  from fsd011
                 where pgcod = 1
                   and scsuc = est.r1suc
                   and scmda = est.r1mda
                   and scpap = est.r1pap
                   and sccta = est.r1cta
                   and scoper = est.r1oper
                   and scsbop = est.r1sbop
                   and sctope = est.r1tope
                   and scmod = 116
                   and scstat <> 99
                   and rownum = 1;
              Exception
                when no_data_found then
                   Begin
                      select scstat
                        into estado
                        from fsd011
                       where pgcod = 1
                         and scsuc = est.r1suc
                         and scmda = est.r1mda
                         and scpap = est.r1pap
                         and sccta = est.r1cta
                         and scoper = est.r1oper
                         and scsbop = est.r1sbop
                         and sctope = est.r1tope
                         and scmod = est.r1mod
                         and scstat <> 99
                         and rownum = 1;
                    Exception
                      when no_data_found then
                        null;
                    end;
              end;
        end;
    end;
  end loop;
  if estado is not null then
    select cenom
      into descestado
      from fst026
     where cecod = estado;
  end if;
  return descestado;
end estado_linea;
function Verifica_sucursal(pn_emp in number,
                           pn_mod in number,
                           pn_suc in number,
                           pn_mda in number,
                           pn_pap in number,
                           pn_cta in number,
                           pn_oper in number,
                           pn_sbop in number,
                           pn_top in number,
                           pd_fech in date) return number is
  cursor trans is
    select *
      from fst198
     where Tp1cod = 1
       and Tp1cod1 = 10884
       and Tp1corr1 = 15
       and tp1nro1 = 30;

agencia number;--varchar2(30);

begin

       select xwftsuc -- (select scnom from fst001 where pgcod = pn_emp and sucurs = xwftsuc)
         into agencia
         from xwf070
        where xwfprcin = (select a.xwfprcins
                              from xwf700 a
                             where a.xwfempresa = pn_emp
                               and a.xwfsucursal  = pn_suc
                               and a.xwfmodulo = pn_mod
                               and a.xwfmoneda = pn_mda
                               and a.xwfpapel = pn_pap
                               and a.xwfcuenta = pn_cta
                               and a.xwfoperacion = pn_oper
                               and a.xwfsubope = pn_sbop
                               and a.xwftipope = pn_top
                               and a.xwfcar3 = '1'
                               and rownum = 1)
         and xwfpgcod = 1
         and xwftmod = 30
         and xwfttran = 951
         and xwfcont = 'S'
         and xwffcon = pd_fech
         and rownum = 1;
         return agencia;
exception
  when no_data_found then
    agencia := pn_suc;
    return agencia;
end Verifica_sucursal;
function Fecha_judicial(pn_emp in number,
                        pn_mod in number,
                        pn_suc in number,
                        pn_mda in number,
                        pn_pap in number,
                        pn_cta in number,
                        pn_oper in number,
                        pn_sbop in number,
                        pn_top in number,
                        pn_est in number)return date is
fecha date;
modulo number;
begin
  fecha:= null;
  if pn_est = 21 or pn_est =23 then
    begin
        select w.sng410fecg
          into fecha
          from sng410 w/*,
               fsd011 x */
         where w.sng400evto in (1100,1101)
           and w.sng410its <> 99
           and w.sng410corr = (select max(sng410corr)
                                 from sng410
                                where sng400cod =  1
                                  and sng400evto in (1100,1101)
                                  and sng410cta = pn_cta
                                  and sng410suc = pn_suc
                                  and sng410mda = pn_mda
                                  and sng410pap = pn_pap
                                  and sng410op = pn_oper
                                  and sng410sbop = pn_sbop
                                  and sng410mod = pn_mod
                                  and sng410top = pn_top
                                  and sng410its <> 99);
    exception
      when no_data_found then
        fecha := null;--- to_Date('dd/mm/yyyy','01/01/0001');
    end;
  end if;
  if  pn_est = 64 or pn_est = 90 or pn_est = 33  THEN
   if pn_est = 64 and pn_mod =200  then
      modulo := 200;
   end if;
   if pn_est = 90 and pn_mod = 33 then
      modulo := 33;
   end if;
   if pn_est = 33  then
      modulo := pn_mod;
   end if;
    Begin
       select jaql166scfvl
         into fecha
         from jaql166
        where jaql166pgcod = pn_emp
          and jaql166scmod = modulo ---
          and jaql166scsuc = pn_suc
          and jaql166scmda = pn_mda
          and jaql166scpap = pn_pap
          and jaql166sccta = pn_cta
          and jaql166scope = pn_oper
          and jaql166scsbo = pn_sbop
          and jaql166sctop = pn_top
          and exists (select 1
                        from fsh016
                       where pgcod = d166cd
                         and hcmod = d166mo
                         and htran = d166tr
                         and hsucor = d166su
                         and hnrel = d166re
                         and hfcon = jaql166scfvl
                         and hcord = 12
                         and hmodul = 200
                         and hmda = jaql166scmda
                         and hpap = jaql166scpap
                         and hcta = jaql166sccta
                         and hoper = jaql166scope
                      union
                       select 1
                        from fsd016
                       where pgcod = d166cd
                         and itmod = d166mo
                         and ittran = d166tr
                         and itsuc = d166su
                         and itnrel = d166re
                         and itord = 12
                         and modulo  = 200
                         and moneda  = jaql166scmda
                         and papel  = jaql166scpap
                         and ctnro  = jaql166sccta
                         and itoper  = jaql166scope);
    exception
      when no_data_found then
        fecha:= null;
    end;
  end if;

  return fecha;

end Fecha_judicial;
END PQ_AH_PAGARE_VIGENTE;
/
