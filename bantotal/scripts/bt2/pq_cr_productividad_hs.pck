create or replace package PQ_CR_PRODUCTIVIDAD_HS is
/*
  *-- Author  : HSUAREZ
  *-- Created : 8/04/2021 14:33:38
  *-- Modificado: Bhernard S. Beisaga
  *-- Purpose : Paqute para el calculo de devengados en créditos reprogramados
  *-- Modificado:
      Se ha adicionado sp_jobs_cargaini_nor para ejecucion por schedules
      Se ha adiconado sp_jobs_cargaini_bulk para ejecuciones por Bulk (DATA MASIVA)
      Se ha adicionado SP_CR_CARGAINI_BULK carga de FSH016 po bulk
      Se ha adicionado SP_CR_CARGAINI_NOR carga de FSH016 po schedules
      Se ha adicionado SP_CR_INSERT_REPROGRAMADOS para lsita de reprogramados
      Se ha adicionado SP_CR_INSERT_REPOFINAL entregable
      Modificado: Hsuarez -  Se cambio los jobs de Regiones a Sucursales, y se implemento la nueva forma de devengamiento.
      
  *
  */
 procedure sp_jobs_DIARIO_cargaini_nor(ve_fecini in varchar,ve_fecfin in varchar);
 PROCEDURE SP_CR_DIARIO_CARGAINI_NOR(ve_sucursal in number, ve_fchini in date, ve_fchcorte in date);

 Function fn_cr_DIARIO_verifica_tarea(P_C_NOMJOB IN VARCHAR2, P_C_HOSTNA IN VARCHAR2) return number;


end PQ_CR_PRODUCTIVIDAD_HS;
/

create or replace package body PQ_CR_PRODUCTIVIDAD_HS is


procedure sp_jobs_DIARIO_cargaini_nor(ve_fecini in varchar,ve_fecfin in varchar) is

    ln_ini      number;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_fecini   date;
    lc_fecfin   date;
    lc_hostname varchar2(64);

    pi_vc2_nomjob varchar2(65);
    lc_prefjob    varchar2(64);
    ln_numjob     number(9) := 0;
    lc_rpta       number:=0;
    n_inst number;
    vi_contab number;
    resultado varchar2(3000);
    vi_correos VARCHAR2(300);
    p_c_coderr VARCHAR2(1500);
    p_c_deserr VARCHAR2(1500);
    cursor sucursal is
      --select regcod, regnom from fst810 where regcod < 100;
      select SUCURS from fst001 where sucurs < 800; --HASL cambio de codigo de region a sucursal.
    cursor email is 
       select TP1DESC
       from fst198 where tp1cod1=10899 and tp1corr1 = 4000 and TP1CORR2 = 1 and TP1CORR3 > 0;
  begin
    begin
      select host_name into lc_hostname from v$instance;
    exception when others then
      null;
    end;

    lc_fecini := to_date(ve_fecini, 'dd/mm/yyyy');
    lc_fecfin := to_date(ve_fecfin, 'dd/mm/yyyy');

    

    ---carga diaria
    for i in sucursal loop
      ln_ini      := i.sucurs;
      lc_prefjob    := 'PRDVDD';
      pi_vc2_nomjob := lc_prefjob || to_char(lc_fecfin, 'ddmmrrrr') ||
                       lpad(ln_ini, 3, '0'); ---ln_job

      lc_variable := 'BEGIN ' ||
                     '  PQ_CR_PRODUCTIVIDAD_HS.SP_CR_DIARIO_CARGAINI_NOR(' ||
                     ln_ini || ',''' || lc_fecini ||
                     ''',''' || lc_fecfin || '''); END;';
      ln_job      := ln_job + 1;

     select sys.FN_BD_NODO_CIERRE_JOB into n_inst from dual;
     if n_inst in (1,2) then
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Carga_diaria_prdvdd');
        begin
          dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', n_inst);
        end;
      Else
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Carga_diaria_prdvdd');
      End If;
      commit;
      INSERT INTO Tab_jobs
        (c_Codage, n_Numer1, c_detjob)
      VALUES
        ('PRDVDD', ln_ini, lc_variable);
      COMMIT;

    end loop;

    ln_numjob := fn_cr_DIARIO_verifica_tarea(lc_prefjob, lc_hostname);

    While ln_numjob > 0 loop
      ln_numjob := fn_cr_DIARIO_verifica_tarea(lc_prefjob, lc_hostname);
    End loop;
    
    /*
    dbms_output.put_line ('>>>>CARGA MASIVA TERMINADA: ' || localtimestamp);
    resultado:= resultado||'<br><br> >>>>CARGA MASIVA TERMINADA: ' || localtimestamp;
    PQ_CR_EXTORDEV_DIARIO.SP_CR_DIARIO_INSERT_REPROGRAMADOS (lc_fecini,lc_fecfin,vs_filasafectadas => lc_rpta);
    dbms_output.put_line ('>>>>INSERT REPROGRAMADOS TERMINADO: ' || localtimestamp);
    
    resultado:= resultado||'<br><br> >>>>INSERT REPROGRAMADOS TERMINADO: ' || localtimestamp;    
    If lc_rpta > 0 then      
       PQ_CR_EXTORDEV_DIARIO.sp_jobs_DIARIO_carga_devengado (lc_fecini, lc_fecfin);
       dbms_output.put_line ('>>>>INSERT DEVENGADOS TERMINADO: ' || localtimestamp);
       resultado:= resultado||'<br><br> >>>>INSERT DEVENGADOS TERMINADO: ' || localtimestamp;
       PQ_CR_EXTORDEV_DIARIO.SP_CR_DIARIO_PRIMER_ENTREGABLE (lc_fecini, lc_fecfin, vs_filasafectadas =>lc_rpta);
       dbms_output.put_line ('>>>>INSERT PRIMER ENTGREGABLE: ' || localtimestamp);
       resultado:= resultado||'<br><br> >>>>INSERT PRIMER ENTGREGABLE: ' || localtimestamp;
       
       If lc_rpta > 0 then
          PQ_CR_EXTORDEV_DIARIO.SP_CR_DIARIO_SEGUNDO_ENTREGABLE (lc_fecini, lc_fecfin, vs_filasafectadas =>lc_rpta);
          dbms_output.put_line ('>>>>INSERT SEGUNDO ENTGREGABLE: ' || localtimestamp);
          resultado:= resultado||'<br><br> >>>>INSERT SEGUNDO ENTGREGABLE: ' || localtimestamp;
          
             If lc_rpta > 0 then
                                           DBMS_OUTPUT.put_line ('Se ha procesado TODO satisfactoriamente');
                                           resultado:= resultado||'<br><br> Se ha procesado TODO satisfactoriamente';
                         else
                                           DBMS_OUTPUT.put_line ('Falla en el proceso');
                                           resultado:= resultado||'<br><br> Falla en el proceso';
                      end if;
             else
                      DBMS_OUTPUT.put_line ('Falla en SP_CR_DIARIO_PRIMER_ENTREGABLE');
                      resultado:= resultado||'<br><br> Falla en SP_CR_DIARIO_PRIMER_ENTREGABLE';
        end if;
    end if;
    */
    --AGREGADO ADICIONAL - EMIAL DE STATUS DEL PROCESO.
    FOR X IN EMAIL LOOP
         BEGIN
           vi_correos :=  vi_correos || trim(X.TP1DESC)||';';
         END;         
    END LOOP;
    pq_ah_planillas.p_sendmailattach(vi_correos, --p_destinatariospara
                                        '', --p_destinatarioscc
                                         '', --p_destinatariosbcc
                                        resultado,--mensaje a enviar
                                        'notificacionesbantotal@cajaarequipa.pe', --remitente
                                        'Resultados de la Ejecucion', --p_asunto
                                        'HTML', --p_asunto
                                        '', --p_directorio
                                        '', --p_archivosadjuntos
                                        p_c_coderr,
                                        p_c_deserr);                                                                 
    --DBMS_OUTPUT.put_line('Error2: ' || p_c_coderr || '-' || p_c_deserr);
  END;

  PROCEDURE SP_CR_DIARIO_CARGAINI_NOR(ve_sucursal in number, ve_fchini in date, ve_fchcorte in date) IS
      err_code NUMBER;
      err_msg  VARCHAR2(1500);
      p_c_coderr VARCHAR2(1500);
      p_c_deserr VARCHAR2(1500);
      p_destinatariospara varchar2(30);
      p_destinatarioscc varchar2(30);
      vi_correos VARCHAR2(200);
      --
      LN_RPTA NUMBER;
      LC_MOD NUMBER;
      LC_TOP NUMBER;
      lc_analista char(10);
      ln_instancia number;   
              
      cursor listado is
      select jaql965fech,jaql965emp, jaql965mod, jaql965suc, jaql965mda, jaql965pap,jaql965cta, jaql965oper,jaql965sbop, 
             jaql965top, jaql965inst, jaql965ase
      from jaql965 j where j.jaql965fech = to_date(ve_fchcorte, 'DD/MM/RRRR') AND jaql965suc = ve_sucursal;
      
      cursor email is 
         select TP1DESC
         from fst198 where tp1cod1=10899 and tp1corr1 = 4000 and TP1CORR2 = 1 and TP1CORR3 > 0; 
            
  BEGIN
      BEGIN
          for i in listado loop
            BEGIN
                LN_RPTA := NULL;            
                LC_MOD :=  i.jaql965mod;
                LC_TOP :=  i.jaql965top;
                  
                IF LC_MOD = 116 THEN
                  BEGIN
                    SELECT /*+index(H12 FSH01204)*/ 
                           MAX(XW2.XWFPRCINS)
                      INTO LN_RPTA
                      FROM FSH012 H12,
                           FSR011 REL
                      JOIN XWF700 XW2
                        ON XW2.XWFEMPRESA = REL.R2COD
                       AND XW2.XWFMODULO = REL.R2MOD
                       AND XW2.XWFSUCURSAL = REL.R2SUC
                       AND XW2.XWFMONEDA = REL.R2MDA
                       AND XW2.XWFPAPEL = REL.R2PAP
                       AND XW2.XWFCUENTA = REL.R2CTA
                       AND XW2.XWFOPERACION = REL.R2OPER
                       AND XW2.XWFSUBOPE = REL.R2SBOP
                       AND XW2.XWFTIPOPE = REL.R2TOPE
                       AND REL.RELCOD = 46
                       AND XW2.XWFCAR3 = '1'
                      JOIN SNG001 GG ON GG.SNG001INST = XW2.XWFPRCINS
                     WHERE --H12.ROWID = PC_ROWID
                         H12.bcemp = i.jaql965emp and H12.bcmod = i.jaql965mod and H12.BCSUC = i.jaql965suc 
                       and H12.BCMDA = i.jaql965mda  and H12.BCPAP = i.jaql965pap
                       and H12.BCCTA = i.jaql965cta  and H12.BCOPER = i.jaql965oper  
                       and H12.BCSBOP = i.jaql965sbop  and H12.BCTOP = i.jaql965top 
                       and H12.BCFECH = i.jaql965fech
                       AND REL.R1COD = 1
                       AND REL.R1MOD = H12.BCMOD
                       AND REL.R1SUC = H12.BCSUC
                       AND REL.R1MDA = H12.BCMDA
                       AND REL.R1PAP = H12.BCPAP
                       AND REL.R1CTA = H12.BCCTA
                       AND REL.R1OPER = H12.BCOPER
                       AND REL.R1SBOP = H12.BCSBOP
                       AND REL.R1TOPE = H12.BCTOP;
                       --dbms_output.put_line('1 '||LN_RPTA);                     
                    IF LN_RPTA IS NULL THEN
                      BEGIN
                        SELECT /*+index(H12 FSH01204)*/ 
                               MAX(XW2.XWFPRCINS)
                          INTO LN_RPTA
                          FROM FSH012 H12,
                               FSR011 REL
                          JOIN XWF700 XW2
                            ON XW2.XWFEMPRESA = REL.R2COD
                           AND XW2.XWFMODULO = REL.R2MOD
                           AND XW2.XWFSUCURSAL = REL.R2SUC
                           AND XW2.XWFMONEDA = REL.R2MDA
                           AND XW2.XWFPAPEL = REL.R2PAP
                           AND XW2.XWFCUENTA = REL.R2CTA
                           AND XW2.XWFOPERACION = REL.R2OPER
                           AND XW2.XWFSUBOPE = REL.R2SBOP
                           AND XW2.XWFTIPOPE = REL.R2TOPE
                           AND REL.RELCOD = 46
                          JOIN SNG001 GG ON GG.SNG001INST = XW2.XWFPRCINS
                         WHERE --H12.ROWID = PC_ROWID
                             H12.bcemp = i.jaql965emp and H12.bcmod = i.jaql965mod and H12.BCSUC = i.jaql965suc 
                           and H12.BCMDA = i.jaql965mda  and H12.BCPAP = i.jaql965pap
                           and H12.BCCTA = i.jaql965cta  and H12.BCOPER = i.jaql965oper  
                           and H12.BCSBOP = i.jaql965sbop  and H12.BCTOP = i.jaql965top 
                           and H12.BCFECH = i.jaql965fech
                           AND REL.R1COD = 1
                           AND REL.R1MOD = H12.BCMOD
                           AND REL.R1SUC = H12.BCSUC
                           AND REL.R1MDA = H12.BCMDA
                           AND REL.R1PAP = H12.BCPAP
                           AND REL.R1CTA = H12.BCCTA
                           AND REL.R1OPER = H12.BCOPER
                           AND REL.R1TOPE = H12.BCTOP;
                           --dbms_output.put_line('2 '||LN_RPTA);
                      END;
                    END IF;
                  END;
                ELSE
                  BEGIN
                    SELECT /*+index(H12 FSH01204)*/ 
                           MAX(XW2.XWFPRCINS)
                      INTO LN_RPTA
                      FROM FSH012 H12,
                           XWF700 XW2 JOIN SNG001 GG ON GG.SNG001INST = XW2.XWFPRCINS
                     WHERE --H12.ROWID = PC_ROWID
                             H12.bcemp = i.jaql965emp and H12.bcmod = i.jaql965mod and H12.BCSUC = i.jaql965suc 
                           and H12.BCMDA = i.jaql965mda  and H12.BCPAP = i.jaql965pap
                           and H12.BCCTA = i.jaql965cta  and H12.BCOPER = i.jaql965oper  
                           and H12.BCSBOP = i.jaql965sbop  and H12.BCTOP = i.jaql965top 
                           and H12.BCFECH = i.jaql965fech                 
                       AND XW2.XWFEMPRESA = 1
                       AND XW2.XWFSUCURSAL = H12.BCSUC
                       AND XW2.XWFMODULO = H12.BCMOD
                       AND XW2.XWFMONEDA = H12.BCMDA
                       AND XW2.XWFPAPEL = H12.BCPAP
                       AND XW2.XWFCUENTA = H12.BCCTA
                       AND XW2.XWFOPERACION = H12.BCOPER
                       AND XW2.XWFSUBOPE = H12.BCSBOP
                       AND XW2.XWFTIPOPE = H12.BCTOP
                       AND XW2.XWFCAR3 = '1';
                       --dbms_output.put_line('3 '||LN_RPTA);             
                  EXCEPTION
                    WHEN OTHERS THEN
                      IF LC_MOD IN (200, 33) OR LC_TOP = 550 THEN
                        BEGIN
                          SELECT /*+index(H12 FSH01204)*/ 
                                 MAX(XW2.XWFPRCINS)
                            INTO LN_RPTA
                            FROM FSH012 H12,
                                 XWF700 XW2 JOIN SNG001 GG ON GG.SNG001INST = XW2.XWFPRCINS
                           WHERE --H12.ROWID = PC_ROWID
                             H12.bcemp = i.jaql965emp and H12.bcmod = i.jaql965mod and H12.BCSUC = i.jaql965suc 
                           and H12.BCMDA = i.jaql965mda  and H12.BCPAP = i.jaql965pap
                           and H12.BCCTA = i.jaql965cta  and H12.BCOPER = i.jaql965oper  
                           and H12.BCSBOP = i.jaql965sbop  and H12.BCTOP = i.jaql965top 
                           and H12.BCFECH = i.jaql965fech
                             AND XW2.XWFEMPRESA = 1
                             AND XW2.XWFSUCURSAL = H12.BCSUC
                             AND XW2.XWFMONEDA = H12.BCMDA
                             AND XW2.XWFPAPEL = H12.BCPAP
                             AND XW2.XWFCUENTA = H12.BCCTA
                             AND XW2.XWFOPERACION = H12.BCOPER;
                                             -- dbms_output.put_line('4 '||LN_RPTA);
                        END;
                      ELSE
                        BEGIN
                          SELECT /*+index(H12 FSH01204)*/ 
                                 MAX(XW2.XWFPRCINS)
                            INTO LN_RPTA
                            FROM FSH012 H12,
                                 XWF700 XW2 JOIN SNG001 GG ON GG.SNG001INST = XW2.XWFPRCINS
                           WHERE --H12.ROWID = PC_ROWID
                                 H12.bcemp = i.jaql965emp and H12.bcmod = i.jaql965mod and H12.BCSUC = i.jaql965suc 
                             and H12.BCMDA = i.jaql965mda  and H12.BCPAP = i.jaql965pap
                             and H12.BCCTA = i.jaql965cta  and H12.BCOPER = i.jaql965oper  
                             and H12.BCSBOP = i.jaql965sbop  and H12.BCTOP = i.jaql965top 
                             and H12.BCFECH = i.jaql965fech  
                             AND XW2.XWFEMPRESA = 1
                             AND XW2.XWFSUCURSAL = H12.BCSUC
                             AND XW2.XWFMODULO = H12.BCMOD
                             AND XW2.XWFMONEDA = H12.BCMDA
                             AND XW2.XWFPAPEL = H12.BCPAP
                             AND XW2.XWFCUENTA = H12.BCCTA
                             AND XW2.XWFOPERACION = H12.BCOPER
                             AND XW2.XWFTIPOPE = H12.BCTOP
                             AND XW2.XWFCAR3 = '1';
                                              --dbms_output.put_line('5 '||LN_RPTA);
                        EXCEPTION
                          WHEN OTHERS THEN
                            BEGIN
                              SELECT/*+index(H12 FSH01204)*/ 
                                     MAX(XW2.XWFPRCINS)
                                INTO LN_RPTA
                                FROM FSH012 H12,
                                     XWF700 XW2 JOIN SNG001 GG ON GG.SNG001INST = XW2.XWFPRCINS
                               WHERE --H12.ROWID = PC_ROWID
                                   H12.bcemp = i.jaql965emp and H12.bcmod = i.jaql965mod and H12.BCSUC = i.jaql965suc 
                                 and H12.BCMDA = i.jaql965mda  and H12.BCPAP = i.jaql965pap
                                 and H12.BCCTA = i.jaql965cta  and H12.BCOPER = i.jaql965oper  
                                 and H12.BCSBOP = i.jaql965sbop  and H12.BCTOP = i.jaql965top 
                                 and H12.BCFECH = i.jaql965fech
                                 AND XW2.XWFEMPRESA = 1
                                 AND XW2.XWFSUCURSAL = H12.BCSUC
                                 AND XW2.XWFMODULO = H12.BCMOD
                                 AND XW2.XWFMONEDA = H12.BCMDA
                                 AND XW2.XWFPAPEL = H12.BCPAP
                                 AND XW2.XWFCUENTA = H12.BCCTA
                                 AND XW2.XWFOPERACION = H12.BCOPER
                                 AND XW2.XWFTIPOPE = H12.BCTOP
                                 AND XW2.XWFCAR3 = '1';
                                                  --dbms_output.put_line('6 '||LN_RPTA);
                            END;
                        END;
                      END IF;
                  END;
                 IF NVL(LN_RPTA, 0) = 0 AND LC_MOD IN (200, 33) THEN
                   BEGIN
                        SELECT /*+index(H12 FSH01204)*/ 
                               MAX(XW2.XWFPRCINS)
                          INTO LN_RPTA
                          FROM FSH012 H12,
                               FSR011 REL
                          JOIN XWF700 XW2
                            ON XW2.XWFEMPRESA = REL.R2COD
                           AND XW2.XWFMODULO = REL.R2MOD
                           AND XW2.XWFSUCURSAL = REL.R2SUC
                           AND XW2.XWFMONEDA = REL.R2MDA
                           AND XW2.XWFPAPEL = REL.R2PAP
                           AND XW2.XWFCUENTA = REL.R2CTA
                           AND XW2.XWFOPERACION = REL.R2OPER
                           AND XW2.XWFSUBOPE = REL.R2SBOP
                           AND XW2.XWFTIPOPE = REL.R2TOPE
                          AND REL.RELCOD = 46
                           AND XW2.XWFCAR3 = '1'
                          JOIN SNG001 GG ON GG.SNG001INST = XW2.XWFPRCINS
                         WHERE --H12.ROWID = PC_ROWID
                                 H12.bcemp = i.jaql965emp and H12.bcmod = i.jaql965mod and H12.BCSUC = i.jaql965suc 
                               and H12.BCMDA = i.jaql965mda  and H12.BCPAP = i.jaql965pap
                               and H12.BCCTA = i.jaql965cta  and H12.BCOPER = i.jaql965oper  
                               and H12.BCSBOP = i.jaql965sbop  and H12.BCTOP = i.jaql965top 
                               and H12.BCFECH = i.jaql965fech
                           AND REL.R1COD = 1
                           AND REL.R1MOD = H12.BCMOD
                           AND REL.R1SUC = H12.BCSUC
                           AND REL.R1MDA = H12.BCMDA
                           AND REL.R1PAP = H12.BCPAP
                           AND REL.R1CTA = H12.BCCTA
                           AND REL.R1OPER = H12.BCOPER
                           AND REL.R1SBOP = H12.BCSBOP
                           AND REL.R1TOPE = H12.BCTOP;
                                            --dbms_output.put_line('7 '||LN_RPTA);
                   END;                      
                  END IF;
                END IF;
                IF NVL(LN_RPTA, 0) = 0 THEN
                  BEGIN
                    SELECT /*+index(H12 FSH01204)*/ 
                           MAX(XW2.XWFPRCINS)
                      INTO LN_RPTA
                      FROM FSH012 H12,
                           XWF700 XW2 JOIN SNG001 GG ON GG.SNG001INST = XW2.XWFPRCINS
                     WHERE --H12.ROWID = PC_ROWID
                             H12.bcemp = i.jaql965emp and H12.bcmod = i.jaql965mod and H12.BCSUC = i.jaql965suc 
                           and H12.BCMDA = i.jaql965mda  and H12.BCPAP = i.jaql965pap
                           and H12.BCCTA = i.jaql965cta  and H12.BCOPER = i.jaql965oper  
                           and H12.BCSBOP = i.jaql965sbop  and H12.BCTOP = i.jaql965top 
                           and H12.BCFECH = i.jaql965fech
                       AND XW2.XWFEMPRESA = 1
                       AND XW2.XWFSUCURSAL = H12.BCSUC
                       AND XW2.XWFMONEDA = H12.BCMDA
                       AND XW2.XWFPAPEL = H12.BCPAP
                       AND XW2.XWFCUENTA = H12.BCCTA
                       AND XW2.XWFOPERACION = H12.BCOPER;
                                       -- dbms_output.put_line('8 '||LN_RPTA);
                  END;
                END IF;
                IF NVL(LN_RPTA, 0) = 0 THEN
                  BEGIN
                    SELECT /* +ALL_ROWS */ 
                           MAX(XW2.XWFPRCINS)
                    INTO LN_RPTA
                    FROM XWF700 XW2 JOIN SNG001 GG ON GG.SNG001INST = XW2.XWFPRCINS,
                         FSH012 H12
                    WHERE --H12.ROWID = PC_ROWID
                             H12.bcemp = i.jaql965emp and H12.bcmod = i.jaql965mod and H12.BCSUC = i.jaql965suc 
                           and H12.BCMDA = i.jaql965mda  and H12.BCPAP = i.jaql965pap
                           and H12.BCCTA = i.jaql965cta  and H12.BCOPER = i.jaql965oper  
                           and H12.BCSBOP = i.jaql965sbop  and H12.BCTOP = i.jaql965top 
                           and H12.BCFECH = i.jaql965fech
                      AND XW2.XWFEMPRESA = 1
                      AND XW2.XWFMONEDA = H12.BCMDA
                      AND XW2.XWFPAPEL = H12.BCPAP
                      AND XW2.XWFCUENTA = H12.BCCTA
                      AND XW2.XWFOPERACION = H12.BCOPER;
                                       --dbms_output.put_line('9 '||LN_RPTA);
                  END;
                END IF;
            --RETURN LN_RPTA;
          
             --si instancia es <> nula
             ln_instancia := LN_RPTA;
              if ln_instancia is not null then
                 begin
                   select sng001ase
                           into lc_analista
                           from sng001  --Cambiar la tabla para producción
                          where sng001inst =  ln_instancia;
                 Exception when no_data_found then
                            lc_analista := null;
                 end;
       
                   begin
                       update jaql965 J
                          set jaql965inst = ln_instancia ,      
                              jaql965ase  = lc_analista,
                              jaql965ind  = 'A' --se actualizo analista e instancia
                             where j.JAQL965FECH = i.jaql965fech  
                               and JAQL965EMP = i.JAQL965EMP
                               and JAQL965MOD = i.JAQL965MOD
                               and JAQL965SUC = i.JAQL965SUC
                               and JAQL965MDA = i.JAQL965MDA 
                               and JAQL965PAP = i.JAQL965PAP 
                               and JAQL965CTA = i.JAQL965CTA
                               and JAQL965OPER = i.JAQL965OPER
                               and JAQL965SBOP = i.JAQL965SBOP
                               and JAQL965TOP  = i.JAQL965TOP
                               and jaql965inst <> ln_instancia;
                               COMMIT;
                   end;            
              end if;
              EXCEPTION
                 when others then
                     err_code := SQLCODE;
                     err_msg := SUBSTR(SQLERRM, 1, 500);
                     err_msg := 'Error1: ' || err_code || '-' || err_msg || '  Cta: ' || I.JAQL965CTA || '  Oper: ' || I.JAQL965OPER;
                     DBMS_OUTPUT.put_line(err_msg);
                     -----------------envio de correo en caso de error-------------------
                     --/*      
                     vi_correos :='';
                     FOR X IN EMAIL LOOP
                       BEGIN
                         vi_correos :=  vi_correos || trim(X.TP1DESC)||';';
                       END;         
                     END LOOP;
                     vi_correos := SUBSTR(vi_correos, 1, (LENGTH(vi_correos) -1));
                     pq_ah_planillas.p_sendmailattach(vi_correos, --p_destinatariospara
                                                      '', --p_destinatarioscc
                                                       '', --p_destinatariosbcc
                                                      err_msg,--mensaje a enviar
                                                      'notificacionesbantotal@cajaarequipa.pe', --remitente
                                                      'registros actualizados.', --p_asunto
                                                      'HTML', --p_asunto
                                                      '', --p_directorio
                                                      '', --p_archivosadjuntos
                                                      p_c_coderr,
                                                      p_c_deserr);   
                                                                              
                     DBMS_OUTPUT.put_line('Error2: ' || p_c_coderr || '-' || p_c_deserr);
                     
                     ---------------------------------------------------------------------------                                        
                     --rollback;     
                     --*/
              END;                     
       END LOOP;
           BEGIN
               FOR X IN EMAIL LOOP
                 BEGIN
                   vi_correos :=  vi_correos || trim(X.TP1DESC)||';';
                 END;         
               END LOOP;
                   vi_correos := SUBSTR(vi_correos, 1, (LENGTH(vi_correos) -1));
                   pq_ah_planillas.p_sendmailattach(vi_correos, --p_destinatariospara
                                                    '', --p_destinatarioscc
                                                     '', --p_destinatariosbcc
                                                    err_msg,--mensaje a enviar
                                                    'notificacionesbantotal@cajaarequipa.pe', --remitente
                                                    'registros actualizados.', --p_asunto
                                                    'HTML', --p_asunto
                                                    '', --p_directorio
                                                    '', --p_archivosadjuntos
                                                    p_c_coderr,
                                                    p_c_deserr);
           END;                                      
       END;
  END SP_CR_DIARIO_CARGAINI_NOR;

  Function fn_cr_DIARIO_verifica_tarea(P_C_NOMJOB IN VARCHAR2,
                                   P_C_HOSTNA IN VARCHAR2) return number is

      ln_numjob number(9) := 0;
      lc_nomusr varchar2(50);

    begin

      begin
        select TRIM(TP1DESC)
          INTO lc_nomusr
          from fst198
         where tp1cod = 1
           and tp1cod1 = 10847
           and tp1corr1 = 999; ---2019.07.22 guia de proceso para hostname
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      end;

      begin
        SELECT COUNT(1)
          INTO ln_numjob
          FROM dba_scheduler_jobs job
         WHERE owner = lc_nomusr
           AND job.job_name LIKE P_C_NOMJOB || '%';
           exception
           when others then 
             ln_numjob:=0;
      end;

      return ln_numjob;
    end fn_cr_DIARIO_verifica_tarea;

end PQ_CR_PRODUCTIVIDAD_HS;
/

