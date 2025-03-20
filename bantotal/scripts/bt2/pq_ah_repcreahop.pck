CREATE OR REPLACE PACKAGE PQ_AH_REPCREAHOP IS
  -------------------------------------------------------------------------
  -- AUTHOR  : SMARQUEZ
  -- PUBLIC TYPE DECLARATIONS
  -- PUBLIC FUNCTION AND PROCEDURE DECLARATIONS
  -- PROCEDURE SP_AH_GENERA_COBROS(P_D_FECHA IN DATE,P_N_MORA IN NUMBER);
  -- FECHA : 27/03/2015
  -- Reutilizacion de parte del codigo para la impresion del reporte
  -- de afectacion de Creditos con N dias de Mora Relacionados con los
  -- Ahorros Moviles y las ordenes de Pagos
  -------------------------------------------------------------------------

  PROCEDURE SP_AH_CREDITOS(P_DIAS_MORA IN NUMBER,
                           P_SUCURSAL  IN NUMBER,
                           P_ACCION    IN NUMBER,
                           P_USUARIO   IN VARCHAR2,
                           P_SALDOM     IN NUMBER);

  FUNCTION FN_FACULTAD_CTA(VPGCOD  NUMBER,
                           VSCSUC  NUMBER,
                           VSCMDA  NUMBER,
                           VSCPAP  NUMBER,
                           VSCCTA  NUMBER,
                           VSCOPER NUMBER,
                           VSCSBOP NUMBER,
                           VSCMOD  NUMBER
                         ) RETURN NUMBER;

  PROCEDURE SP_AH_CTACOB(P_REGION IN VARCHAR2,
                          P_SUCURS IN VARCHAR2,
                          P_ANALIS IN VARCHAR2,
                          P_TITULA IN VARCHAR2,
                          P_NUMDOC IN VARCHAR2,
                          P_MDACRE IN VARCHAR2,
                          P_CODSUC IN NUMBER,
                          P_CREMDA IN NUMBER,
                          P_PAPCRE IN NUMBER,
                          P_CTACRE IN NUMBER,
                          P_OPECRE IN NUMBER,
                          P_SUBCRE IN NUMBER,
                          P_TIPCRE IN NUMBER,
                          P_MODCRE IN NUMBER,
                          P_SALCRE IN NUMBER,
                          P_NROCUO IN NUMBER,
                          P_TOTDEU IN NUMBER,
                          P_DIAATS IN NUMBER,
                          P_RELCRE IN VARCHAR2,
                          P_CUENTA IN NUMBER,
                          P_USER   IN VARCHAR2,
                          P_SALDOA IN NUMBER,
                          P_DNIPER IN VARCHAR2);


END PQ_AH_REPCREAHOP;
/

create or replace package body PQ_AH_REPCREAHOP is

 PROCEDURE SP_AH_CREDITOS(P_DIAS_MORA IN NUMBER,
                          P_SUCURSAL  IN NUMBER,
                          P_ACCION    IN NUMBER,
                          P_USUARIO   IN VARCHAR2,
                          p_SALDOM    IN NUMBER ) IS
  cursor c_cta_avales(P_N_SUC in number,P_N_MOD in number,P_N_MDA in number,P_N_CTA in number,P_N_OPE in number,P_N_SBO in number,P_N_TOP in number)is
   select distinct
          b.sng003cta cuenta1, 
          c.pendoc  documento1
     from xwf700    a,
          sng003    b,
          fsr008    c
    where a.XWFPRCINS    = b.sng001inst
      and a.XWFEMPRESA   = 1
      and a.XWFSUCURSAL  = P_N_SUC
      and a.XWFMODULO    = P_N_MOD
      and a.XWFMONEDA    = P_N_MDA
      and a.XWFPAPEL     = 0
      and a.XWFCUENTA    = P_N_CTA
      and a.XWFOPERACION = P_N_OPE
      and a.XWFSUBOPE    = P_N_SBO
      and a.XWFTIPOPE    = P_N_TOP
      and a.XWFCAR3 = '1'
      and c.ctnro = b.sng003cta
      and c.ttcod = 1;

  cursor c_creditos (v_fecha in date)is
      select DISTINCT
                      j64.jaql964ren as Region,
                      j64.jaql964nom as sucursal,
                      J64.jaql964usu as Analista,
                      j64.jaql964tit as Titular,
                      j64.jaql964doc as Numero_doc,
                      decode(J64.JAQL964MDA, 0, 'NUEVOS SOLES', 'DOLARES') as Mda_Credito,
                      fr8.pepais,
                      fr8.petdoc,
                      fr8.pendoc,
                      cre.sccta,
                      cre.scsuc,
                      cre.scmda,
                      cre.scpap,
                      cre.scoper,
                      cre.scsbop,
                      cre.sctope,
                      cre.scmod,
                      cre.scsdo as Saldo_Cred,
                      (pq_cr_creditos.fn_cuotas_pagadas(cre.pgcod,
                                                       cre.scmod,
                                                       cre.scsuc,
                                                       cre.scmda,
                                                       cre.scpap,
                                                       cre.sccta,
                                                       cre.scoper,
                                                       cre.scsbop,
                                                       cre.sctope,
                                                       v_fecha)+ 1) as Nro_Cuota_atrasada,
                      (pq_cr_creditos.fn_monto_atrasado(cre.pgcod,
                                                         cre.scmod,
                                                         cre.scsuc,
                                                         cre.scmda,
                                                         cre.scpap,
                                                         cre.sccta,
                                                         cre.scoper,
                                                         cre.scsbop,
                                                         cre.sctope,
                                                         v_fecha) + (j64.jaql964gas + j64.jaql964mor)) Total_deuda,
              j64.jaql964dia dia_atraso
        from fsd011 cre,
             jaql964 j64,
             fsr008 fr8
       where cre.pgcod = 1
         and cre.scrub in (select rubro
                             from fsd014
                            where pcimpu = 'S'
                              and pcnivc in
                                  (select modulo
                                     from fst111
                                    where dscod = 50
                                      and modulo not in (33, 120, 141, 144, 200))
                           )
         and cre.scsdo <> 0.00                 
         and j64.jaql964suc = cre.scsuc
         AND j64.jaql964mod <> 108
         and j64.jaql964cta = cre.sccta
         and j64.jaql964mod = cre.scmod
         and j64.jaql964mda = cre.scmda
         and j64.jaql964ope = cre.scoper
         and j64.jaql964sob = cre.scsbop
         and j64.jaql964top = cre.sctope
         and j64.jaql964dia >= P_DIAS_MORA
         and j64.jaql964suc = P_SUCURSAL    
         and fr8.pgcod = cre.pgcod
         and fr8.ctnro = cre.sccta
         and fr8.ttcod = 1
         AND NOT EXISTS (SELECT 1
                    FROM JAQY666 j6                    
                   WHERE j6.jaqy666suc = j64.jaql964suc
                     and j6.jaqy666cta = j64.jaql964cta
                     and j6.jaqy666mda = j64.jaql964mda
                     and j6.jaqy666mod = j64.jaql964mod
                     and j6.jaqy666ope = j64.jaql964ope
                     and j6.jaqy666sop = j64.jaql964sob
                     and j6.jaqy666top = j64.jaql964top
                     and j6.jaqy666est = 'S'
                     and v_fecha between j6.jaqy666fini and j6.jaqy666ffin)--and j6.jaqy666ffin >= v_fecha)                     
    order by fr8.pepais,fr8.petdoc, fr8.pendoc desc;

    cursor c_conyugues(P_N_CUENTA IN NUMBER,P_N_DOCUMENTO IN VARCHAR2) is
      select distinct
             c.ctnro cuenta,
             C.PENDOC DOCUMENTO
        from fsr002 a,
             fsr008 b,
             fsr008 c
       where a.pepais = b.pepais
         and a.petdoc = b.petdoc
         and a.pendoc = b.pendoc
         and b.pepais = c.pepais
         and b.petdoc = c.petdoc
         and b.pendoc = c.pendoc
         and c.ttcod  = 1
         and b.ctnro  = P_N_CUENTA
         AND c.pendoc <> P_N_DOCUMENTO
         and a.rpccyg = 66;
         
  fecha date;
  v_verif number;
  begin
    select pgfape
      into fecha
      from fst017
     where pgcod = 1;
  
    CASE P_ACCION
    WHEN 1 THEN
        DELETE JAQY664
         WHERE JAQY664AUX3 = P_USUARIO;
        commit;
        For i in c_creditos(fecha) loop

                    -- Buscar saldo de cuentas de los titulares del credito (busca x cta cliente i.sccta)
                   sp_ah_ctacob(P_REGION  => i.region,
                                P_SUCURS => i.sucursal,
                                P_ANALIS => i.analista,
                                P_TITULA => i.titular ,
                                P_NUMDOC => i.numero_doc,
                                P_MDACRE => i.mda_credito,
                                P_CODSUC => i.scsuc,
                                P_CREMDA => i.scmda,
                                P_PAPCRE => i.scpap,
                                P_CTACRE => i.sccta,
                                P_OPECRE => i.scoper,
                                P_SUBCRE => i.scsbop,
                                P_TIPCRE => i.sctope,
                                P_MODCRE => i.scmod,
                                P_SALCRE => i.saldo_cred,
                                P_NROCUO => i.nro_cuota_atrasada,
                                P_TOTDEU => i.total_deuda,
                                P_DIAATS => i.dia_atraso,
                                P_RELCRE => 'Titular',
                                P_CUENTA => i.sccta,
                                P_USER   => P_USUARIO,
                                P_SALDOA => P_SALDOM,
                                P_DNIPER => I.NUMERO_DOC);
                   -- Buscar saldo de cuentas de los conyugues del credito
                   For j in c_conyugues(i.sccta,I.NUMERO_DOC) loop --retorna las cuentas clientes de los conyugues de la cuenta origen
                     Begin
                       SElect 1
                         into v_verif
                         from fsd010
                        where pgcod = 1
                          and aocta = j.cuenta
                          and aomod = 21
                          and aotope in (1,3)
                          and aostat <> 99
                          and rownum = 1;
                     Exception
                       when no_data_found then
                         v_verif := 0;
                     End;    
                     if v_verif = 1 then                       
                         sp_ah_ctacob(P_REGION  => i.region,
                                      P_SUCURS => i.sucursal,
                                      P_ANALIS => i.analista,
                                      P_TITULA => i.titular ,
                                      P_NUMDOC => i.numero_doc,
                                      P_MDACRE => i.mda_credito,
                                      P_CODSUC => i.scsuc,
                                      P_CREMDA => i.scmda,
                                      P_PAPCRE => i.scpap,
                                      P_CTACRE => i.sccta,
                                      P_OPECRE => i.scoper,
                                      P_SUBCRE => i.scsbop,
                                      P_TIPCRE => i.sctope,
                                      P_MODCRE => i.scmod,
                                      P_SALCRE => i.saldo_cred,
                                      P_NROCUO => i.nro_cuota_atrasada,
                                      P_TOTDEU => i.total_deuda,
                                      P_DIAATS => i.dia_atraso,
                                      P_RELCRE => 'Conyuge',
                                      P_CUENTA => j.cuenta,
                                      P_USER   => P_USUARIO,
                                      P_SALDOA => p_SALDOM,
                                      P_DNIPER => J.DOCUMENTO);
                     end if;                 
                   End loop;
                 -- Buscar avales del credito cursor c_cta_avales
                   For k in c_cta_avales(i.scsuc,i.scmod,i.scmda,i.sccta,i.scoper,i.scsbop,i.sctope) loop
                     -- Buscar saldo de cuentas de los avales del credito
                     Begin
                       SElect 1
                         into v_verif
                         from fsd010
                        where pgcod = 1
                          and aocta = k.cuenta1
                          and aomod = 21
                          and aotope  in (1,3)
                          and aostat <> 99
                          and rownum = 1;
                     Exception
                       when no_data_found then
                         v_verif := 0;
                     End;    
                     if v_verif = 1 then    
                         sp_ah_ctacob(P_REGION  => i.region,
                                      P_SUCURS => i.sucursal,
                                      P_ANALIS => i.analista,
                                      P_TITULA => i.titular ,
                                      P_NUMDOC => i.numero_doc,
                                      P_MDACRE => i.mda_credito,
                                      P_CODSUC => i.scsuc,
                                      P_CREMDA => i.scmda,
                                      P_PAPCRE => i.scpap,
                                      P_CTACRE => i.sccta,
                                      P_OPECRE => i.scoper,
                                      P_SUBCRE => i.scsbop,
                                      P_TIPCRE => i.sctope,
                                      P_MODCRE => i.scmod,
                                      P_SALCRE => i.saldo_cred,
                                      P_NROCUO => i.nro_cuota_atrasada,
                                      P_TOTDEU => i.total_deuda,
                                      P_DIAATS => i.dia_atraso,
                                      P_RELCRE => 'Aval',
                                      P_CUENTA => k.cuenta1,
                                      P_USER   => P_USUARIO,
                                      P_SALDOA => p_SALDOM,
                                      P_DNIPER => k.documento1);
                        end if;
                        For m in c_conyugues(k.cuenta1,k.documento1) loop --retorna las cuentas clientes de los conyugues de la cuenta origen
                         -- Buscar saldo de cuentas de los coyugues de los avales del credito
                             Begin
                             SElect 1
                               into v_verif
                               from fsd010
                              where pgcod = 1
                                and aocta = m.cuenta
                                and aomod = 21
                                and aotope in (1,3)
                                and aostat <> 99
                                and rownum = 1;
                             Exception
                               when no_data_found then
                                 v_verif := 0;
                             End;    
                             if v_verif = 1 then    
                                 sp_ah_ctacob(P_REGION  => i.region,
                                              P_SUCURS => i.sucursal,
                                              P_ANALIS => i.analista,
                                              P_TITULA => i.titular ,
                                              P_NUMDOC => i.numero_doc,
                                              P_MDACRE => i.mda_credito,
                                              P_CODSUC => i.scsuc,
                                              P_CREMDA => i.scmda,
                                              P_PAPCRE => i.scpap,
                                              P_CTACRE => i.sccta,
                                              P_OPECRE => i.scoper,
                                              P_SUBCRE => i.scsbop,
                                              P_TIPCRE => i.sctope,
                                              P_MODCRE => i.scmod,
                                              P_SALCRE => i.saldo_cred,
                                              P_NROCUO => i.nro_cuota_atrasada,
                                              P_TOTDEU => i.total_deuda,
                                              P_DIAATS => i.dia_atraso,
                                              P_RELCRE => 'Conyuge-Aval',
                                              P_CUENTA => m.cuenta,
                                              P_USER   => P_USUARIO,
                                              P_SALDOA => p_SALDOM,
                                              P_DNIPER => M.DOCUMENTO);
                              end if;
                         End loop;
                   End Loop;
        End Loop;
       
        
   WHEN 2 THEN
        DELETE JAQY664
        WHERE JAQY664AUX3 = P_USUARIO;
        COMMIT;
    END CASE;
  End sp_ah_creditos;


  Function FN_FACULTAD_CTA(vpgcod  number,
                           vscsuc  number,
                           vscmda  number,
                           vscpap  number,
                           vsccta  number,
                           vscoper number,
                           vscsbop number,
                           vscmod  number
                         ) return number is
  facultad number(3);
  begin
  select Case R2sbop
           when 1 then
            1
           when 511 then
            511
           else
            2
         end
    into facultad
    from fsr011
   Where Relcod = 5
     and R1cod = vpgcod
     and R1mod = vscmod
     and R1suc = vscsuc
     and R1mda = vscmda
     and R1pap = vscpap
     and R1cta = vsccta
     and R1oper = vscoper
     and R1sbop = vscsbop
     and rownum = 1;

  return(facultad);
  Exception
   When no_data_found then
     begin
       select Case ctfaccor
                 when 1 then 1
                 when 511 then 511
                 else 2 end
                 into facultad
        from fse130
       where pgcod = vpgcod
         and ctnro = vsccta
         and rownum = 1;
    Exception
      When no_data_found then
        facultad := 0;
    end;
    return(facultad);
end FN_FACULTAD_CTA;



Procedure sp_ah_ctacob(P_REGION IN VARCHAR2,
                        P_SUCURS IN VARCHAR2,
                        P_ANALIS IN VARCHAR2,
                        P_TITULA IN VARCHAR2,
                        P_NUMDOC IN VARCHAR2,
                        P_MDACRE IN VARCHAR2,
                        P_CODSUC IN NUMBER,
                        P_CREMDA IN NUMBER,
                        P_PAPCRE IN NUMBER,
                        P_CTACRE IN NUMBER,
                        P_OPECRE IN NUMBER,
                        P_SUBCRE IN NUMBER,
                        P_TIPCRE IN NUMBER,
                        P_MODCRE IN NUMBER,
                        P_SALCRE IN NUMBER,
                        P_NROCUO IN NUMBER,
                        P_TOTDEU IN NUMBER,
                        P_DIAATS IN NUMBER,
                        P_RELCRE IN VARCHAR2,
                        P_CUENTA IN NUMBER,
                        P_USER   IN VARCHAR2,
                        P_SALDOA IN NUMBER,
                        P_DNIPER IN VARCHAR2) is
  cursor c_cuentas1 is
    select q.pgcod,
           q.scsuc,
           q.scmod,
           q.scmda,
           q.scpap,
           q.sccta,
           q.scoper,
           q.scsbop,
           q.sctope,         
           q.scsdo,
           z.pepais,
           z.petdoc,
           z.pendoc,
           (select scnom from fst001 where sucurs = q.scsuc) as sucuraho,
           decode(q.scmda, 0, 'NUEVOS SOLES', 'DOLARES') AS MDAAHO,
           (select cenom from fst026 where cecod = q.scstat) as estado,
           fn_facultad_cta(q.pgcod,
                            q.scsuc,
                            q.scmda,
                            q.scpap,
                            q.sccta,
                            q.scoper,
                            q.scsbop,
                        ---    q.sctope,
                            q.scmod) as facultad_aho,
           (select depnom from FST068 where depcod = s.sngc13dpto) as departamento,
           (select concat((select (trim(fst071dsc) || ' - ')
                            from FST071
                           where fst071dpt = s.sngc13prov
                             and fst071loc = s.sngc13prov
                             and fst071col = s.sngc13dist),
                          (select trim(locnom)
                             from FST070
                            where depcod = s.sngc13dpto
                              and loccod = s.sngc13prov))
              from dual) as DistritoProvincia,
           s.sngc13dir as direccion
      from (select w.pgcod,
                   w.scmda,
                   w.scsuc,
                   w.sccta,
                   w.scsbop,
                   w.scoper,
                   sum(w.scsdo) as saldo,                   
                   w.pepais,
                   w.petdoc,
                   w.pendoc
              from (select a.pgcod,
                           a.scmda,
                           a.scsuc,
                           a.sccta,
                           a.scoper,
                           a.scsbop,
                           a.scsdo,
                           d.pepais,
                           d.petdoc,
                           d.pendoc
                      from fsd011 a,
                           (select distinct b.pgcod,
                                            b.ctnro,
                                            b.pepais,
                                            b.petdoc,
                                            b.pendoc
                              from fsr008 b, fsr008 c
                             Where c.pgcod = b.pgcod
                               and c.pepais = b.pepais
                               and c.petdoc = b.petdoc
                               and c.pendoc = b.pendoc
                               and b.ttcod = c.ttcod
                               and c.ttcod = 1
                               and c.pendoc = P_DNIPER
                               and c.ctnro = P_CUENTA) d
                     where a.pgcod = d.pgcod
                       and a.sccta = d.ctnro
                       and a.scmod = 21
                       and a.sctope in (1,3)
                       and a.scstat in (0,81)                       
                       and a.scsdo >= P_SALDOA
                    union
                    select e.pgcod,
                           e.scmda,
                           e.scsuc,
                           e.sccta,
                           e.scoper,
                           e.scsbop,                           
                           e.scsdo, 
                           f.pepais,
                           f.petdoc,
                           f.pendoc
                      from fsd011 e,
                           (select distinct b.pgcod,
                                            b.ctnro,
                                            b.pepais,
                                            b.petdoc,
                                            b.pendoc
                              from fsr008 b, fsr008 c
                             Where c.pgcod = b.pgcod
                               and c.pepais = b.pepais
                               and c.petdoc = b.petdoc
                               and c.pendoc = b.pendoc
                               and b.ttcod = c.ttcod
                               and c.ttcod = 1     
                               AND c.pendoc = P_DNIPER                      
                               and c.ctnro = P_CUENTA) f
                     where e.pgcod = f.pgcod
                       and e.sccta = f.ctnro
                       and e.scmod = 136
                       and e.scsdo > 0) w
             where fn_facultad_cta(w.pgcod,
                                   w.scsuc,
                                   w.scmda,
                                   0,
                                   w.sccta,
                                   0,
                                   w.scsbop,
                                   21) <> 511
             group by w.pgcod,
                      w.scmda,
                      w.scsuc,
                      w.sccta,
                      w.scsbop,
                      w.scoper,
                      w.pepais,
                      w.petdoc,
                      w.pendoc) z,
           fsd011 q,
           sngc13 s
     where q.pgcod = z.pgcod
       and q.scsuc = z.scsuc
       and q.scmda = z.scmda
       and q.sccta = z.sccta
       and q.scsbop = z.scsbop
       and q.scoper = z.scoper
       and q.scpap = 0
       and q.scmod = 21
       and q.sctope in (1,3)
       and q.scstaT in (0,81)
       and s.sngc13pais = z.pepais
       and s.sngc13tdoc = z.petdoc
       and s.sngc13ndoc = z.pendoc
       and s.sngc13corr = 1
       and s.sngc13est = 'H'
       and s.docod = 1;
  DNI varchar2(12);
  V_INSERT NUMBER;
  begin
    For reg in c_cuentas1 loop
       if reg.sccta is not null or reg.sccta <> 0 then
               bEGIN
                   INSERT INTO JAQY664 (JAQY664REG,
                                        JAQY664SUC,
                                        JAQY664ANA,
                                        JAQY664TIT,
                                        JAQY664NROD,
                                        JAQY664MDAC,
                                        JAQY664SUCC,
                                        JAQY664CMDA,
                                        JAQY664PAPC,
                                        JAQY664CTAC,
                                        JAQY664OPEC,
                                        JAQY664SUBOC,
                                        JAQY664TOPEC,
                                        JAQY664MODC,
                                        JAQY664SALC,
                                        JAQY664NCA,
                                        JAQY664TOTD,
                                        JAQY664DIAM,
                                        JAQY664DNIA,
                                        JAQY664RELA,
                                        JAQY664SUCAL,
                                        JAQY664MDAL,
                                        JAQY664SUCA,
                                        JAQY664MDAA,
                                        JAQY664PAPA,
                                        JAQY664CTAA,
                                        JAQY664OPEA,
                                        JAQY664SUBOA,
                                        JAQY664TOPEA,
                                        JAQY664MODA,
                                        JAQY664SALA,
                                        JAQY664EST,
                                        JAQY664TIPO,
                                        JAQY664AUX3,
                                        JAQY664AUX5,
                                        JAQY664AUX6,
                                        JAQY664AUX7)
                                VALUES ( P_REGION,
                                        P_SUCURS,
                                        P_ANALIS,
                                        P_TITULA,
                                        P_NUMDOC,
                                        P_MDACRE,
                                        P_CODSUC,
                                        P_CREMDA,
                                        P_PAPCRE,
                                        P_CTACRE,
                                        P_OPECRE,
                                        P_SUBCRE,
                                        P_TIPCRE,
                                        P_MODCRE,
                                        P_SALCRE,
                                        P_NROCUO,
                                        P_TOTDEU,
                                        P_DIAATS,
                                        reg.pendoc, --P_DNIAHO,
                                        P_RELCRE,
                                        reg.sucuraho, --P_SUCAHO,
                                        reg.mdaaho,--P_MDAAHO,
                                        reg.scsuc,--P_AHOSUC,
                                        reg.scmda,--P_AHOMDA,
                                        reg.scpap,--P_PAPAHO,
                                        reg.sccta,--P_CTAAHO,
                                        reg.scoper,--P_OPEAHO,
                                        reg.scsbop,--P_SUBAHO,
                                        reg.sctope,--P_TIPAHO,
                                        reg.scmod,--P_MODAHO,
                                        reg.scsdo, --SALAHO,
                                        reg.estado,--P_ESTADO,
                                        reg.facultad_aho,--P_FACULT,
                                        P_USER,
                                        reg.departamento,--P_DEPMTO,
                                        reg.distritoprovincia,--P_DISPRV,
                                        reg.direccion);
                         commit;  
                eXCEPTION        
                  WHEN DUP_VAL_ON_INDEX THEN  
                    NULL;
               eND;
       End if;                          
    End Loop;
   
  Exception
  When Others Then
       null;
  End sp_ah_ctacob;

 end PQ_AH_REPCREAHOP;
/

