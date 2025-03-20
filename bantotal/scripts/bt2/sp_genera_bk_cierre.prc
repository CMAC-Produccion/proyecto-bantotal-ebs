create or replace procedure sp_genera_bk_cierre(P_D_FECPRO IN DATE,
                                                P_C_TABLAS IN VARCHAR2,
                                                P_N_CODSEQ IN NUMBER,
                                                P_N_TIPQUE IN NUMBER,
                                                p_c_backup out varchar2,
                                                p_c_salida out varchar2
                                                ) is
   -- *****************************************************************
    -- Nombre                     : sp_genera_bk_cierre
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 23/11/2021
    -- Autor de Creación          : Yrving Lozada
    -- Uso                        : Proceso multiple de cadena
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificación      : 23/11/2023
    -- Autor de la Modificación   : Yrving Lozada
    -- Descripción de Modificación: Se adicionó un caso mas para grabar fsi002 para reporte 1 encaje de tesorería
    --
    -- *****************************************************************                                                  

  lc_fecha varchar2(8):=null;
  lv_variable varchar2(200);
  lv_mensaje  varchar2(32767);
  lv_mail varchar2(30);
  
  ll_mensaje CLOB;    
  cont number:=0;
  ln_dias number(9):=0;
  ln_Tp1nro1 NUMBER(2):=0;
  ln_Tp1nro2 NUMBER(7):=0;
  ln_Tp1nro3 NUMBER(3):=0;
  ln_Tp1imp1 NUMBER(9):=0;
  ln_Tp1imp2 NUMBER(3):=0;  
  ln_salacu number(17,2):=0;
  
  ld_fecfin date;
     
  CURSOR C_MAILS_RECOR IS
  select trim(tp1desc) lv_mail
    from fst198
   where tp1cod   = 1
     and tp1cod1  = 10825
     and tp1corr1 = 50
     and tp1corr2 = 1;     
     
  CURSOR C_SOLICITUDES(LN_NUMDIAS IN NUMBER) IS
  select a.jaqz159sol                                       SOLICITUD,
         a.jaqz159pai||'-'||a.jaqz159tpo||'-'||a.jaqz159num DOCUMENTO,
         b.penom                                            CLIENTE,
         to_char(a.jaqz159fes,'dd/mm/rrrr')                 FECHA_RE,
         trim(a.jaqz159usc)||' - '||c.ubnom                 USUARIO,  
         a.jaqz159agc||' - '||d.scnom                       AGENCIA
    from jaqz159 a,
         fsd001  b,
         fst746  c,
         fst001  d
   where a.jaqz159pai = b.pepais
     and a.jaqz159tpo = b.petdoc
     and a.jaqz159num = b.pendoc
     and c.ubuser     = a.jaqz159usc
     and d.sucurs     = a.jaqz159agc
     and d.pgcod      = 1
     and a.jaqz159est IN ('I','E')
     and a.jaqz159fel = P_D_FECPRO + LN_NUMDIAS 
  order by 1;    
  CURSOR C_GRUPOS IS
    Select a.Tp1nro1,a.Tp1nro2,a.Tp1nro3,a.Tp1imp1,a.Tp1imp2    
      from fst198 a
     Where a.Tp1cod   = 1
       and a.Tp1cod1  = 10825
       and a.Tp1corr1 = 100
       --and a.Tp1corr2 in(1,2,3);      
    union
    Select a.Tp1nro1,a.Tp1nro2,a.Tp1nro3,a.Tp1imp1,a.Tp1imp2
      from fst198 a
     Where a.Tp1cod   = 1
       and a.Tp1cod1  = 10825
       and a.Tp1corr1 = 113;         
begin
  lc_fecha := to_char(P_D_FECPRO,'RRRRMMDD');        
  CASE
    WHEN P_N_TIPQUE = 1 THEN      
        p_c_backup := trim(P_C_TABLAS)||'_'||lc_fecha||'_'||P_N_CODSEQ;
        --lv_variable := 'CREATE TABLE '||'OPERADOR.'||trim(P_C_TABLAS)||'_'||lc_fecha||'_'||P_N_CODSEQ||' AS SELECT * FROM '||trim(P_C_TABLAS);
        --lv_variable := 'CREATE TABLE '||'OPERADOR.'||trim(P_C_TABLAS)||'_'||lc_fecha||'_'||P_N_CODSEQ||' AS SELECT /*+parallel(a,20)*/ a.* FROM '||trim(P_C_TABLAS)|| ' a';
        lv_variable := 'CREATE TABLE '||'OPERADOR.'||trim(P_C_TABLAS)||'_'||lc_fecha||'_'||P_N_CODSEQ||' parallel (degree 4) nologging AS SELECT  a.* FROM  '||trim(P_C_TABLAS)|| ' a';        
        begin
            execute immediate (lv_variable);       
--BEGIN execute immediate ('GRANT SELECT ON '||'OPERADOR.'||trim(P_C_TABLAS)||'_'||lc_fecha||'_'||P_N_CODSEQ||' TO ROL_BANTPROD_CONS'); EXCEPTION WHEN OTHERS THEN NULL; END;
            p_c_salida := NULL;
        exception
        when others then
          p_c_salida := sqlerrm;
          --obtenemos correo
          begin
            select trim(tp1desc)
              into lv_mail
              from fst198
             where tp1cod = 1
               and tp1cod1 = 10825
               and tp1corr1 = 16;
          Exception 
          when others then
              null;
          end;
          
          begin
            lv_mensaje := 'Ocurrió un error en la generación de la tabla: ' ||p_c_backup||' - '||p_c_salida;
                 sys.sp_sy_enviamail_html(pc_aquien =>lv_mail,--- sys.sp_sy_enviamail_html_silvia
                                          pc_de => 'notificacionesbantotal@cajaarequipa.pe',
                                          pc_motivo => 'Error en Backup de tabla',
                                          pc_mensaje => lv_mensaje
                                         );   
          Exception
          when others then                             
            null;
          end;                
        end;
  WHEN P_N_TIPQUE = 2 THEN 
        p_c_backup  := 'FSRH101';
        lv_variable := 'INSERT INTO FSRH101 SELECT PBCOD,PBNSEC,PBTHREAD,PBPATH,PBIMPR,PBD1,PBH1,PBD2,PBH2,PBD3,PBH3,PBD4,PBH4,PBD5,PBH5,PBD6,PBH6,PBD7,PBH7,PBD8,PBH8,TO_DATE('''||lc_fecha||''',''RRRRMMDD'')-1'||' FROM '|| trim(P_C_TABLAS);
        begin
          execute immediate (lv_variable);      
          commit; 
          p_c_salida := NULL;
        exception
        when others then
          p_c_salida := sqlerrm;
          --obtenemos correo
          begin
            select trim(tp1desc)
              into lv_mail
              from fst198
             where tp1cod = 1
               and tp1cod1 = 10825
               and tp1corr1 = 16;
          Exception 
          when others then
              null;
          end;
              
          begin
            lv_mensaje := 'Ocurrió un error en la extracción de la data de la tabla: ' ||P_C_TABLAS||' - '||p_c_salida;
                 sys.sp_sy_enviamail_html(pc_aquien =>lv_mail,--- sys.sp_sy_enviamail_html_silvia
                                          pc_de => 'notificacionesbantotal@cajaarequipa.pe',
                                          pc_motivo => 'Error en Histórico de tabla',
                                          pc_mensaje => lv_mensaje
                                         );   
          Exception
          when others then                             
            null;
          end;        
        end;
    WHEN P_N_TIPQUE = 3 THEN    -- ELIMINAR CUENTAS DEL GRUPO DE DPF   
        For i in c_grupos loop    
            ln_Tp1nro1 := i.Tp1nro1;
            ln_Tp1nro2 := i.Tp1nro2;
            ln_Tp1nro3 := i.Tp1nro3;
            ln_Tp1imp1 := i.Tp1imp1;
            ln_Tp1imp2 := i.Tp1imp2; 
             
            p_c_backup := trim(P_C_TABLAS);
            lv_variable := 'DELETE FROM '||trim(P_C_TABLAS)||' WHERE TGCOD='||trim(TO_CHAR(ln_Tp1nro1))||' AND GRNRO='||trim(TO_CHAR(ln_Tp1nro2));        
            begin
                execute immediate (lv_variable);  
                commit;      
                p_c_salida := NULL;
            exception
            when others then
              p_c_salida := sqlerrm;
              --obtenemos correo
              begin
                select trim(tp1desc)
                  into lv_mail
                  from fst198
                 where tp1cod = 1
                   and tp1cod1 = 10825
                   and tp1corr1 = 16;
              Exception 
              when others then
                  null;
              end;
              
              begin
                lv_mensaje := 'Ocurrió un error en el borrado de la tabla : ' ||p_c_backup||' - '||p_c_salida;
                     sys.sp_sy_enviamail_html(pc_aquien =>lv_mail,--- sys.sp_sy_enviamail_html_silvia
                                              pc_de => 'notificacionesbantotal@cajaarequipa.pe',
                                              pc_motivo => 'Error en Borrado de tabla',
                                              pc_mensaje => lv_mensaje
                                             );   
              Exception
              when others then                             
                null;
              end;                
            end; 
        end loop;        
        p_c_backup := 'SP_VERIFICA_TRAB_FSD009';
        begin
            --execute immediate (lv_variable);       
            SP_VERIFICA_TRAB_FSD009;
            p_c_salida := NULL;
        exception
        when others then
          p_c_salida := sqlerrm;
          --obtenemos correo
          begin
            select trim(tp1desc)
              into lv_mail
              from fst198
             where tp1cod = 1
               and tp1cod1 = 10825
               and tp1corr1 = 16;
          Exception 
          when others then
              null;
          end;
          
          begin
            lv_mensaje := 'Ocurrió un error en la ejecución del proceso: ' ||p_c_backup||' - '||p_c_salida;
                 sys.sp_sy_enviamail_html(pc_aquien =>lv_mail,--- sys.sp_sy_enviamail_html_silvia
                                          pc_de => 'notificacionesbantotal@cajaarequipa.pe',
                                          pc_motivo => 'Error en ejecución de proceso',
                                          pc_mensaje => lv_mensaje
                                         );   
          Exception
          when others then                             
            null;
          end;                
        end;               
  WHEN P_N_TIPQUE = 5 THEN  --Recordatorios Traslados de CTS  
      p_c_salida := NULL;
      p_c_backup := trim(P_C_TABLAS)||'_'||lc_fecha||'_'||P_N_CODSEQ;
      dbms_lob.createtemporary(ll_mensaje, TRUE);    
      lv_mensaje := '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">Estimado Usuario : </p>' ||  
                    '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">Se ha encontrado la(s) siguientes SOLICITUDES DE TRASLADO DE CTS próximas a vencer.</p><br/>';  
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                           
                            
              lv_mensaje := --ll_mensaje ||                                                
              '<style  type="text/css">td {font-family:''Courier New'', Courier, monospace; font-size:13px}</style>' ||
              '<table cellspacing=0 cellpadding=2 width=1400>'||
              '  <tr>'||
              '    <td width="50" style="border-bottom: 1px solid black;"><b>Solicitud</b></td>'||
              '    <td width="200" style="border-bottom: 1px solid black;"><b>Documento</b></td>'||
              '    <td width="400" style="border-bottom: 1px solid black;"><b>Cliente</b></td>'||          
              '    <td width="100" style="border-bottom: 1px solid black;"><b>Fecha de Recepción</b></td>    '||
              '    <td width="400" style="border-bottom: 1px solid black;"><b>Usuario</b></td>    '||
              '    <td width="250" style="border-bottom: 1px solid black;"><b>Agencia</b></td>    '||                    
              '  </tr>          ';
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);       
        begin
          select Tp1nro1
            into ln_dias
            from fst198
           where tp1cod   = 1
             and tp1cod1  = 10825
             and tp1corr1 = 50
             and tp1corr2 = 2;
        Exception 
        when others then
            ln_dias := 0;
        end;  
            
        if ln_dias > 0 then                     
          FOR J IN C_SOLICITUDES(ln_dias) LOOP
            lv_mensaje := 
            '  <tr>'||
            '    <td align="left">'||trim(j.SOLICITUD)||'</td>'||
            '    <td align="left">'||trim(j.DOCUMENTO)||'</td>'||
            '    <td align="left">'||trim(j.CLIENTE)||'</td>'||
            '    <td align="left">'||trim(j.FECHA_RE)||'</td>'||
            '    <td align="left">'||trim(j.USUARIO)||'</td>'||
            '    <td align="left">'||trim(j.AGENCIA)||'</td>'||    
            '  </tr>                ';   
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
          cont := cont + 1;            
          END LOOP;
        else
          p_c_salida := 'NO SE HAN PARAMETRIZADO LOS DIAS POR VENCER';
        end if;
      
      lv_mensaje := 
      '</table>'||
      '<br/>'||
      '<br/>'||         
      '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">Saludos Cordiales<br/>Caja Arequipa</p>';           
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);     
      
      if cont > 0 then 
        for i in C_MAILS_RECOR LOOP   
          begin
           sys.sp_sy_enviamail_html(pc_aquien  => i.lv_mail,--- sys.sp_sy_enviamail_html
                                    pc_de      => 'notificacionesbantotal@cajaarequipa.pe',
                                    pc_motivo  => 'Alerta Traslados de CTS por vencer',
                                    pc_mensaje => ll_mensaje
                                   );   
          Exception
          when others then                             
            null;
          end; 
        end loop; 
      else
         p_c_salida := 'NO SE HAN ENCONTYRADO SOLICITUDES PENDIENTES DE VENCER';   
      End if;          
      dbms_lob.freetemporary(ll_mensaje);         
    WHEN P_N_TIPQUE = 10 THEN      
        p_c_backup := trim(P_C_TABLAS)||'_'||lc_fecha||'_'||P_N_CODSEQ;
        begin
            --execute immediate (lv_variable);       
            SP_TB_DEPURADOR;
            p_c_salida := NULL;
        exception
        when others then
          p_c_salida := sqlerrm;
          --obtenemos correo
          begin
            select trim(tp1desc)
              into lv_mail
              from fst198
             where tp1cod = 1
               and tp1cod1 = 10825
               and tp1corr1 = 16;
          Exception 
          when others then
              null;
          end;
          
          begin
            lv_mensaje := 'Ocurrió un error en la ejecución del proceso: ' ||p_c_backup||' - '||p_c_salida;
                 sys.sp_sy_enviamail_html(pc_aquien =>lv_mail,--- sys.sp_sy_enviamail_html_silvia
                                          pc_de => 'notificacionesbantotal@cajaarequipa.pe',
                                          pc_motivo => 'Error en ejecución de proceso',
                                          pc_mensaje => lv_mensaje
                                         );   
          Exception
          when others then                             
            null;
          end;                
        end;    
    WHEN P_N_TIPQUE = 20 THEN      
        p_c_backup := trim(P_C_TABLAS)||'_'||lc_fecha||'_'||P_N_CODSEQ;
        begin
            --execute immediate (lv_variable);       
            sp_ah_create_cts001_temp;
            p_c_salida := NULL;
        exception
        when others then
          p_c_salida := sqlerrm;
          --obtenemos correo
          begin
            select trim(tp1desc)
              into lv_mail
              from fst198
             where tp1cod = 1
               and tp1cod1 = 10825
               and tp1corr1 = 16;
          Exception 
          when others then
              null;
          end;
          
          begin
            lv_mensaje := 'Ocurrió un error en la ejecución del proceso: ' ||p_c_backup||' - '||p_c_salida;
                 sys.sp_sy_enviamail_html(pc_aquien =>lv_mail,--- sys.sp_sy_enviamail_html_silvia
                                          pc_de => 'notificacionesbantotal@cajaarequipa.pe',
                                          pc_motivo => 'Error en ejecución de proceso',
                                          pc_mensaje => lv_mensaje
                                         );   
          Exception
          when others then                             
            null;
          end;                
        end;    
    WHEN P_N_TIPQUE = 30 THEN --COPIAMOS SALDO DE REACTIVA A FSI002 para anexo 5 SBS tesorería        
        p_c_backup := trim(P_C_TABLAS)||'_'||lc_fecha||'_'||P_N_CODSEQ;
        ld_fecfin := P_D_FECPRO-1;
        begin
            select (sum(a.bcsdmn)) * -1
              into ln_salacu            
              from fsd010   t,
                   aqpb065b g,
                   fsh012   a --usar la fsd011 en caso la fecha de consulta sea igual a la fecha actual
             where a.bcemp = t.pgcod
               and a.bcemp = 1 
               and t.aomod <> 33
               and t.aomod in (select modulo
                             from fst111
                            where dscod = 50
                              and modulo not in (29, 120, 144))
               and g.aqpb065bcod = t.pgcod      
               and g.aqpb065bmda = t.aomda
               and g.aqpb065bpap = t.aopap
               and g.aqpb065bcta = t.aocta
               and g.aqpb065bope = t.aooper
               and g.aqpb065best <>'D'             
               and a.bcemp = t.pgcod
               and a.bcmod = t.aomod
               and a.bcmda = t.aomda
               and a.bcpap = t.aopap
               and a.bccta = t.aocta
               and a.bcoper = t.aooper
               and a.bcsbop = t.AOSBOP
               and a.bctop = t.aotope
               and a.bcfech = ld_fecfin; --fecha de consulta                    
        exception
        when others then
            lv_mensaje := 'Ocurrió un error en la ejecución del proceso: ' ||p_c_backup||' - '||p_c_salida;
                 sys.sp_sy_enviamail_html(pc_aquien =>lv_mail,--- sys.sp_sy_enviamail_html_silvia
                                          pc_de => 'notificacionesbantotal@cajaarequipa.pe',
                                          pc_motivo => 'Error en ejecución de proceso',
                                          pc_mensaje => lv_mensaje
                                         );   
        end;
        begin
            insert into FSI002
              (PGCOD, CICPO, CIFECH, CIIMP)
            values
              (1, 'ME766100', ld_fecfin, ln_salacu);
            commit;
        exception
        when others then
            lv_mensaje := 'Ocurrió un error en la ejecución del proceso: ' ||p_c_backup||' - '||p_c_salida;
                 sys.sp_sy_enviamail_html(pc_aquien =>lv_mail,--- sys.sp_sy_enviamail_html_silvia
                                          pc_de => 'notificacionesbantotal@cajaarequipa.pe',
                                          pc_motivo => 'Error en ejecución de proceso',
                                          pc_mensaje => lv_mensaje
                                         );   
        end;                
  ELSE
    NULL;  
  END CASE;
Exception
when others then  
  null;
end sp_genera_bk_cierre;
/

