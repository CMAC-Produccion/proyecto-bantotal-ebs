create or replace package ritc_pq_ca_ple_lib_diario authid current_user is
 --se comento esquema 05/11/2021 dcastro
 
  -- Author  : PHILIPP
  -- Created : 07/09/2023 03:52:00
  -- Purpose : 
 /*========================================================================================+
  |                          Copyright (c) 2023 Royal ITC                                   |
  |                        ORACLE Applications Comun Customizing                            |
  +=========================================================================================+
  |                                                                                         |
  | DESCRIPTION : Paquete para la generación del PLE libro diario version SIRE              |
  | VERSION: 1.0																			|
  | USO: Realiza Calculos y Genera Estructura PLE para SIRE									|
  | HISTORY                                                                                 |
  | WHEN          WHO                 WHAT                                                  |
  | ----------    ------------------- ------------------------------------------------------|
  | 07/09/2023    Philipp Pacheco   Creación                                                |
  | 25/11/2025    Philipp Pacheco   Se añadieron comentarios                                |
  |=========================================================================================*/


  vg_period varchar2(200);
  
  vg_fecha_ini DATE;
  vg_fecha_fin DATE;
  vg_JOB NUMBER;

  procedure pr_main_libro_diario_ebs_bt(errbuf                  out varchar2,
                                        retcode                 out varchar2,
                                        pn_ledger_id            number,
                                        pn_legal_entity_id      number,
                                        pn_chart_of_accounts_id varchar2,
                                        pc_min_flex             varchar2,
                                        pc_max_flex             varchar2,
                                        -- INI, LUIS JARA, 20/07/2018
                                        P_FECHA_D in varchar2,
                                        P_FECHA_H in varchar2,
                                        -- FIN, LUIS JARA, 20/07/2018                                        
                                        pc_period      varchar2,
                                        pc_period2     varchar2,
                                        pc_moneda      varchar2,
                                        pc_fecha_desde varchar2,
                                        pc_fecha_al    varchar2,
                                        pc_lote        varchar2,
                                        pc_folio       varchar2,
                                        pc_origen      varchar2,
                                        pc_category    varchar2,
                                        pc_user        varchar2,
                                        pc_axi         varchar2,
                                        pc_modo        varchar2,
                                        pc_book        varchar2,
                                        --<I>IBK-CSA2-TXT-13.11.2013-CJulcapoma
                                        pc_path_file     varchar2 default null,
                                        pc_generate_file varchar2 default 'N',
                                        pc_sla_manual    varchar2 default 'N',
                                        pc_p_ebs_bt      varchar2,
                                        pc_p_tipo        varchar2
                                        --<F>IBK-CSA2-TXT-13.11.2013-CJulcapoma
                                        );
  procedure jc_tabla_temp(pv_origen varchar2,
                          pv_name   varchar2,
                          pv_ruta   varchar2);
  procedure jc_tabla_temp2(pv_origen varchar2,
                           pv_name   varchar2,
                           pv_ruta   varchar2);

  procedure jc_tabla_temp3(pv_origen varchar2,
                           pv_name   varchar2,
                           pv_ruta   varchar2);

  procedure jc_tabla_temp3_nuevo(pv_origen varchar2,
                                 pv_name   varchar2,
                                 pv_ruta   varchar2);

  procedure jc_tabla_temp4(pv_origen varchar2,
                           pv_name   varchar2,
                           pv_ruta   varchar2);

  procedure jc_upd_description_line;
  procedure jc_insert_ebs_fe_todos;

  procedure sp_write_log_add(p_directory in varchar2,
                             p_file_name in varchar2,
                             p_file_txt  in varchar2);
  procedure sp_write_log(p_directory in varchar2,
                         p_file_name in varchar2,
                         p_file_txt  in varchar2);
  
  PROCEDURE sp_carga_aqpa470_LD_per(pd_fe_desde IN DATE
                                ,pd_fe_hasta IN DATE);
                                
  PROCEDURE sp_gl_actualizar_cuo_2_fe;   
  
  --ADD JOGZARPDZ 24062019   
  
  --<Se inserta la data en una tabla final que se generaria en el txt, generando id por registro para su control>
  procedure jc_tabla_temp3_nuevo_final(pv_origen varchar2,
                                 pv_name   varchar2,
                                 pv_ruta   varchar2);
                                 
  --<Se invocara en paralelo en grupo de 2 la generacion del txt>                               
  procedure jc_tabla_temp3_nuevo_ejec(pv_origen varchar2,
                                 pv_name   varchar2,
                                 pv_ruta   varchar2);
  
  --<Generacion final del archivo .txt>                                
  procedure jc_tabla_temp3_nuevo_txt(
                                 pv_name   varchar2,
                                 pv_ruta   varchar2,
                                 PV_DESDE  NUMBER,
                                 PV_HASTA  NUMBER);
                                 
  --<Proceso que esperara las ejecuciones en paralelo terminen>                           
  procedure jc_tabla_temp3_nuevo_while ; 
  ---                            
  
  --add jc 25072022       
  PROCEDURE sp_insert_JC_AQPA470_flag_rv;           
  PROCEDURE sp_insert_hist_all;
  PROCEDURE sp_insert_JC_CUO_CORR_FE;
  PROCEDURE sp_gl_actualizar_cuo_2_fe_v2;
  
  --ADD JC13092022
  PROCEDURE sp_insert_AQPA470_TMP;    
   procedure jc_insert_ebs_fe_todos_2; 
   
  --ADD JC09072023 
   function get_nodom_doc(pn_invoice_id number, pv_accion varchar2)
    return varchar2;
                                         
end;
/
create or replace package body ritc_pq_ca_ple_lib_diario is

  procedure pr_main_libro_diario_ebs_bt(errbuf                  out varchar2,
                                        retcode                 out varchar2,
                                        pn_ledger_id            number,
                                        pn_legal_entity_id      number,
                                        pn_chart_of_accounts_id varchar2,
                                        pc_min_flex             varchar2,
                                        pc_max_flex             varchar2,
                                        -- INI, LUIS JARA, 20/07/2018
                                        P_FECHA_D in varchar2,
                                        P_FECHA_H in varchar2,
                                        -- FIN, LUIS JARA, 20/07/2018
                                        pc_period        varchar2,
                                        pc_period2       varchar2,
                                        pc_moneda        varchar2,
                                        pc_fecha_desde   varchar2,
                                        pc_fecha_al      varchar2,
                                        pc_lote          varchar2,
                                        pc_folio         varchar2,
                                        pc_origen        varchar2,
                                        pc_category      varchar2,
                                        pc_user          varchar2,
                                        pc_axi           varchar2,
                                        pc_modo          varchar2,
                                        pc_book          varchar2,
                                        pc_path_file     varchar2 default null,
                                        pc_generate_file varchar2 default 'N',
                                        pc_sla_manual    varchar2 default 'N',
                                        pc_p_ebs_bt      varchar2,
                                        pc_p_tipo        varchar2) is
  
    p_file_name varchar2(3000);
    -- INI, LUIS JARA, 20/07/2018
    pd_FECHA_D date;
    pd_FECHA_H date;
    -- FIN, LUIS JARA, 20/07/2018
  
    ---JCSHALOOM
    P_DIR varchar2(100) := 'TS_INV_SUNAT_PLE_RIPV_DIR';
    ---
    
    p_n_mespro NUMBER;
    p_n_anopro NUMBER;
    p_n_id_concurrente NUMBER :=fnd_global.conc_request_id;
    p_n_ruta_dir varchar2(3000);
  
  begin
  
    -- INI, LUIS JARA, 20/07/2018
    pd_FECHA_D := to_date(substr(P_FECHA_D, 1, 10), 'YYYY/MM/DD');
    pd_FECHA_H := to_date(substr(P_FECHA_H, 1, 10), 'YYYY/MM/DD');
    -- FIN, LUIS JARA, 20/07/2018
  
    ts_fnd_log_pkg.pr_log('El archivo TXT se crear¿ en el directorio: TS_INV_SUNAT_PLE_RIPV_DIR');
  
    vg_period := pc_period;
    
    SELECT add_months(last_day(to_date(vg_period, 'MON-YY')) + 1, -1)
            ,last_day(to_date(vg_period, 'MON-YY'))
        INTO vg_fecha_ini
            ,vg_fecha_fin
        FROM dual;
   
    
  
    --BT/EBS
  
    --TS Libro Diario - PLE v5.0 - Detallado - CMAC
    if pc_p_tipo = 'DET' then
    
      /*XXBOL.TS_GL_BOOKS_REP_PLE_5_C3_PKG.pr_main*/
      xxbol.ts_gl_books_rep_ple_5_c_pkg_v2.pr_main(errbuf,
                                                    retcode,
                                                    pn_ledger_id,
                                                    pn_legal_entity_id,
                                                    pn_chart_of_accounts_id,
                                                    pc_min_flex,
                                                    pc_max_flex,
                                                    -- INI, LUIS JARA, 20/07/2018
                                                    pd_FECHA_D,
                                                    pd_FECHA_H,
                                                    -- FIN, LUIS JARA, 20/07/2018                                                   
                                                    pc_period,
                                                    pc_period2,
                                                    pc_moneda,
                                                    pc_fecha_desde,
                                                    pc_fecha_al,
                                                    pc_lote,
                                                    pc_folio,
                                                    pc_origen,
                                                    pc_category,
                                                    pc_user,
                                                    pc_axi,
                                                    pc_modo,
                                                    pc_book,
                                                    --<I>IBK-CSA2-TXT-13.11.2013-CJulcapoma
                                                    /*Pc_Path_File*/
                                                    --P_DIR,
                                                    'ECX_UTL_LOG_DIR_OBJ',
                                                    pc_generate_file
                                                    --<F>IBK-CSA2-TXT-13.11.2013-CJulcapoma
                                                    );
      
    
      ---TS Libro Diario - PLE v5.0 - CMAC  
    
      /*P_FILE_NAME := 'PLE_LD_' || replace(PC_PERIOD, '-', '') || '_' ||
                     pc_p_ebs_bt || '.txt';*/
                     
      --ADD 26062019 JOGZARPDZ
      
      p_n_mespro := to_number(to_char(to_date(pc_period, 'MON-RR'), 'MM'));
      p_n_anopro := to_number(to_char(to_date(pc_period, 'MON-RR'), 'RRRR'));
      
      P_FILE_NAME :='LE20100209641' || p_n_anopro ||
                   lpad(p_n_mespro, 2, '0') || '00140100001111_'||p_n_id_concurrente||'.TXT';
                   
     
     SELECT DIRECTORY_PATH 
     INTO p_n_ruta_dir
     FROM ALL_DIRECTORIES 
     WHERE 
     DIRECTORY_NAME = 'TS_INV_SUNAT_PLE_RIPV_DIR';
                    
                     
     ts_fnd_log_pkg.pr_log('Nombre del Archivo TXT : ' ||P_FILE_NAME);
     ts_fnd_log_pkg.pr_log('Ruta : ' ||p_n_ruta_dir);                
     ts_fnd_log_pkg.pr_log('Directorio : ' ||P_DIR);                
     ------
    
      IF pc_p_ebs_bt = 'BT' THEN
        xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('jc_pq_ca_ple_lib_diario_PR_V3.jc_tabla_temp ');
        jc_tabla_temp(PC_ORIGEN, P_FILE_NAME, P_DIR);
        xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('FIN procesos JC ');
      ELSIF pc_p_ebs_bt = 'EBS' THEN
        xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('jc_pq_ca_ple_lib_diario_PR_V3.jc_tabla_temp2 ');
        jc_tabla_temp2(PC_ORIGEN, P_FILE_NAME, P_DIR);
        xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('FIN procesos JC ');

      ELSIF pc_p_ebs_bt = 'FE' THEN
        
        --ADD 110319 PDZ JOGZAR
        xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('jc_pq_ca_ple_lib_diario_PR_V3.sp_carga_aqpa470_LD_per ');
        sp_carga_aqpa470_LD_per(vg_fecha_ini, vg_fecha_fin);    
            
        /*xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('jc_pq_ca_ple_lib_diario_PR_V3.sp_gl_actualizar_cuo_2_fe ');
        sp_gl_actualizar_cuo_2_fe;*/--DESABILITADO JC05082022
        
        ---ADD JC05062022
        xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('jc_pq_ca_ple_lib_diario_PR_V3.sp_insert_JC_AQPA470_flag_rv ');
        sp_insert_JC_AQPA470_flag_rv;
        xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('jc_pq_ca_ple_lib_diario_PR_V3.sp_insert_hist_all ');
        sp_insert_hist_all;
        xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('jc_pq_ca_ple_lib_diario_PR_V3.sp_insert_JC_CUO_CORR_FE ');
        sp_insert_JC_CUO_CORR_FE;
        xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('jc_pq_ca_ple_lib_diario_PR_V3.sp_gl_actualizar_cuo_2_fe_v2 ');
        sp_gl_actualizar_cuo_2_fe_v2;
        ---
        
        xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('jc_pq_ca_ple_lib_diario_PR_V3.jc_upd_description_line ');      
        ritc_pq_ca_ple_lib_diario.jc_upd_description_line;
        -- 
        xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('jc_pq_ca_ple_lib_diario_PR_V3.jc_tabla_temp4 '); 
        jc_tabla_temp4(PC_ORIGEN, P_FILE_NAME, P_DIR);
        xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('FIN procesos JC ');
      
      ELSIF SUBSTR(pc_period, 5, 6) >= 18 AND pc_p_ebs_bt = 'TODOS' THEN
        
       --ADD 110319 PDZ JOGZAR
       xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('jc_pq_ca_ple_lib_diario_PR_V3.sp_carga_aqpa470_LD_per ');
       sp_carga_aqpa470_LD_per(vg_fecha_ini, vg_fecha_fin); 

       ---ADD JC05062022
        xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('jc_pq_ca_ple_lib_diario_PR_V3.sp_insert_JC_AQPA470_flag_rv ');
        sp_insert_JC_AQPA470_flag_rv;
        xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('jc_pq_ca_ple_lib_diario_PR_V3.sp_insert_hist_all ');
        sp_insert_hist_all;
        xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('jc_pq_ca_ple_lib_diario_PR_V3.sp_insert_JC_CUO_CORR_FE ');
        sp_insert_JC_CUO_CORR_FE;
        xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('jc_pq_ca_ple_lib_diario_PR_V3.sp_gl_actualizar_cuo_2_fe_v2 ');
        sp_gl_actualizar_cuo_2_fe_v2;
        ---
    
       --update description line
        
        xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('jc_pq_ca_ple_lib_diario_PR_V3.jc_upd_description_line ');
      
        ritc_pq_ca_ple_lib_diario.jc_upd_description_line;
        
        --add jc 13092022
        xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('jc_pq_ca_ple_lib_diario_PR_V3.sp_insert_AQPA470_TMP ');
        
        ritc_pq_ca_ple_lib_diario.sp_insert_AQPA470_TMP;
        
        xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('jc_pq_ca_ple_lib_diario_PR_V3.jc_insert_ebs_fe_todos_2 ');
                        
        -- insert de data EBS BT Y FE (Facturacion Electronica)
      
        ritc_pq_ca_ple_lib_diario.jc_insert_ebs_fe_todos_2;
        
        --ADD JOGZARPDZ 24062019
        
        xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log(' INICIO jc_tabla_temp3_nuevo_final ');
        jc_tabla_temp3_nuevo_final(PC_ORIGEN, P_FILE_NAME, P_DIR);
        
        xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('INICIO jc_tabla_temp3_nuevo_ejec ');
        jc_tabla_temp3_nuevo_ejec(PC_ORIGEN, P_FILE_NAME, P_DIR);
         
        xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('INICIO jc_tabla_temp3_nuevo_while ');
         jc_tabla_temp3_nuevo_while;
      
        --
        
        xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('FIN procesos JC ');
      
      ELSE
        xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('jc_tabla_temp3 ');
        jc_tabla_temp3(PC_ORIGEN, P_FILE_NAME, P_DIR);
        xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('FIN procesos JC ');
      
      END IF;
    
    elsif pc_p_tipo = 'RES' then
      
      xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('RES xxbol.ts_gl_books_rep_ple_5_c_pkg_rs.pr_main ');
      xxbol.ts_gl_books_rep_ple_5_c_pkg_rs.pr_main(errbuf,
                                                   retcode,
                                                   pn_ledger_id,
                                                   pn_legal_entity_id,
                                                   pn_chart_of_accounts_id,
                                                   pc_min_flex,
                                                   pc_max_flex,
                                                   -- INI, LUIS JARA, 20/07/2018
                                                   pd_FECHA_D,
                                                   pd_FECHA_H,
                                                   -- FIN, LUIS JARA, 20/07/2018                                                   
                                                   pc_period,
                                                   pc_period2,
                                                   pc_moneda,
                                                   pc_fecha_desde,
                                                   pc_fecha_al,
                                                   pc_lote,
                                                   pc_folio,
                                                   pc_origen,
                                                   pc_category,
                                                   pc_user,
                                                   pc_axi,
                                                   pc_modo,
                                                   pc_book,
                                                   pc_path_file,
                                                   pc_generate_file,
                                                   null /*PC_SLA_MANUAL*/);
    
      p_file_name := 'PLE_LD_' || replace(pc_period, '-', '') || '_' ||
                     pc_modo || '.txt';
      commit; --->> 18042018
      if pc_origen = 'BT' then
        xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('RES jc_tabla_temp ');
        jc_tabla_temp(pc_origen, p_file_name, P_DIR);
      elsif pc_origen = 'EBS' then
        xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('RES jc_tabla_temp2 ');
        jc_tabla_temp2(pc_origen, p_file_name, P_DIR);
      else
        xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('RES jc_tabla_temp3 ');
        jc_tabla_temp3(pc_origen, p_file_name, P_DIR);
      end if;
    
    else
      
      xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('xxbol.ts_gl_books_rep_ple_5_c_pkg_rs.pr_write_output_apu');
      xxbol.ts_gl_books_rep_ple_5_c_pkg_rs.pr_write_output_apu(errbuf,
                                                               retcode,
                                                               pc_period,
                                                               pn_ledger_id);
    
    end if;
  
  end;

  procedure jc_tabla_temp(pv_origen varchar2,
                          pv_name   varchar2,
                          pv_ruta   varchar2) is
    cursor table_temp is
      select a.period,
             a.doc_sequence_value,
             a.code_accounting,
             a.ledger_account,
             a.gl_date,
             translate(a.gl_description, '|/\', ' ') gl_description,
             a.accounted_dr,
             a.accounted_cr,
             a.line_status,
             a.annotation_date,
             a.je_header_id,
             a.je_line_num,
             a.org_id,
             a.period_name,
             a.ledger_id,
             a.created_by,
             a.creation_date,
             a.last_update_by,
             a.last_update_date,
             a.last_update_login,
             a.request_id,
             translate(a.additional_field01, '|/\', ' ') additional_field01,
             a.line_type,
             a.journal_type,
             a.doc_sequence_value_aux,
             a.doc_sequence_line,
             a.invoice_line_number,
             a.ae_header_id,
             a.ae_line_num,
             a.centro_costo,
             a.currency_code,
             a.tipo_doc_prove,
             a.numero_entidad_emisor,
             decode(a.doc_sunat, '', '00', 'NA', '00', a.doc_sunat) doc_sunat, --add modify 231017 pdiaz
             a.serie_documento,
             decode(a.numero_documento, '', '00', a.numero_documento) numero_documento,
             a.effective_date,
             a.due_date,
             translate(substr(a.glosa_referencial, 1, 200), '|/\', ' ') glosa_referencial,
             a.structured_field,
             a.leasing_id,
             a.fecha_emision,
             a.je_source,
             decode(length(a.je_source), 2, 'BT', 'EBS') origen
        from ts_gl_lines_ple_tmp a
       where 1 = 1
            ---AND rownum < 10
         and (decode('BT',
                     'TODOS',
                     'TODOS',
                     decode(length(je_source), 2, 'BT', 'EBS')) = 'BT')
       order by a.doc_sequence_value;
  
    -- INI, LUIS JARA, 02/05/2018
    vd_comparar date;
  
    cursor table_temp_nuevo is
      select a.period,
             a.doc_sequence_value,
             a.code_accounting,
             a.ledger_account,
             a.gl_date,
             translate(a.gl_description, '|/\', ' ') gl_description,
             a.accounted_dr,
             a.accounted_cr,
             a.line_status,
             a.annotation_date,
             a.je_header_id,
             a.je_line_num,
             a.org_id,
             a.period_name,
             a.ledger_id,
             a.created_by,
             a.creation_date,
             a.last_update_by,
             a.last_update_date,
             a.last_update_login,
             a.request_id,
             translate(a.additional_field01, '|/\', ' ') additional_field01,
             a.line_type,
             a.journal_type,
             a.doc_sequence_value_aux,
             a.doc_sequence_line,
             a.invoice_line_number,
             a.ae_header_id,
             a.ae_line_num,
             a.centro_costo,
             a.currency_code,
             a.tipo_doc_prove,
             a.numero_entidad_emisor,
             decode(a.doc_sunat, '', '00', 'NA', '00', a.doc_sunat) doc_sunat, --add modify 231017 pdiaz
             a.serie_documento,
             decode(a.numero_documento, '', '00', a.numero_documento) numero_documento,
             a.effective_date,
             a.due_date,
             translate(substr(a.glosa_referencial, 1, 200), '|/\', ' ') glosa_referencial,
             a.structured_field,
             a.leasing_id,
             a.fecha_emision,
             a.je_source,
             decode(length(a.je_source), 2, 'BT', 'EBS') origen,
             h.attribute3 as attribute3_h,
             l.attribute3 as attribute3_l
        from ts_gl_lines_ple_tmp a,
             apps.gl_je_headers  h,
             apps.gl_je_lines    l
       where 1 = 1
            ---AND rownum < 10
         and (decode('BT',
                     'TODOS',
                     'TODOS',
                     decode(length(a.je_source), 2, 'BT', 'EBS')) = 'BT')
         and to_date(a.period_name, 'MON-YY') >= vd_comparar
         and a.je_header_id = h.je_header_id(+)
         and a.je_header_id = l.je_header_id(+)
         and a.je_line_num = l.je_line_num(+)
            --FE
         and not exists
      --FE
       (select 1
                from /*operador.*/ ---se comento esquema 05/11/2021 dcastro
                     XXBOL.AQPA470 xz
               where to_char(xz.AQPA470FEMI, 'MON-YY') = vg_period
                 and to_char(xz.aqpa470con, 'YYYYMMDD') || '-' ||
                     xz.aqpa470pgcod || '-' || xz.aqpa470sucor || '-' ||
                     xz.aqpa470mod || '-' || xz.aqpa470tran || '-' ||
                     xz.aqpa470rel || '-' || xz.aqpa470cord || '-' ||
                     xz.aqpa470subo = TRIM(a.DESCRIPTION_LINE))
      ----test
      --and rownum <= 10            
      --order by a.doc_sequence_value;
       order by h.attribute3 asc, l.attribute3 asc;
    -- FIN, LUIS JARA, 02/05/2018
  
    vc_title_file varchar2(3000);
    vc_title_line varchar2(4000);
    vc_sep        varchar2(1);
    vv_name       varchar2(200);
    --vd_comparar      date;
    vd_compara       date;
    vv_cuo_b         varchar2(200);
    vv_correlativo_b varchar2(200);
    vc_cuo_periodo   varchar2(15); /*CVEAS*/
    v_cuo_old        varchar2(80);
    vn_secuencial    number;
    v_cuo_old_n      varchar2(80);
    vn_secuencial_n  number;
	vc_nro_ruc	varchar2(11):='20100209641'; -- PPCH Royal ITC
  
  begin
  
    /*INICIO----CVEAS*/
    select c.period_name
      into vc_cuo_periodo
      from jc.jc_ple_nuevo_cuo_corr c;
  
    /*FIN----CVEAS*/
  
    vd_comparar := to_date(vc_cuo_periodo, 'MON-YY') /*to_date('ENE-18','MON-YY')*/
     ; /*CVEAS*/
    vd_compara  := to_date(vg_period, 'MON-YY');
  
    vv_name := pv_name || '_' || pv_origen;
  
    vc_sep        := '|';
    vc_title_file := 'Periodo' ||
                    --<I>PLE-v4.0-30.04.2014-CJulcapoma
                     vc_sep || 'Codigo Unico de la Operacion (CUO)' ||
                    --vc_sep || 'Numero correlativo del asiento o Codigo Unico de la operacion en el Libro Diario' ||
                     vc_sep || 'Numero correlativo del asiento contable' ||
                    --<F>PLE-v4.0-30.04.2014-CJulcapoma
                    --vc_sep || 'Codigo del Plan de Cuentas utilizado por el deudor tributario' ||--GCM
                     vc_sep || 'Codigo de la cuenta contable asociada' ||
                    --<I>SUNAT-PLEV5-25.09.2015-GCorvera
                     vc_sep || 'Codigo de Unidad de Operacion' || vc_sep ||
                     'Centro de Costos' || vc_sep ||
                     'Tipo de Moneda de origen' || vc_sep ||
                     'Tipo de Documento de identidad de emisor' || vc_sep ||
                     'Numero de documento de identidad del emisor' ||
                     vc_sep ||
                     'Tipo de Comprobante de Pago o documento asociado' ||
                     vc_sep || 'Numero de Serie de comprobante de Pago' ||
                     vc_sep ||
                     'Numero del comprobante de Pago o documento asociado' ||
                     vc_sep || 'Fecha Contable' || vc_sep ||
                     'Fecha de Vencimiento' ||
                    --<F>SUNAT-PLEV5-25.09.2015-GCorvera
                     vc_sep || 'Fecha de la operacion' || vc_sep ||
                     'Glosa o descripcion de la naturaleza de la operacion registrada' ||
                     vc_sep || 'Glosa referencial' || --SUNAT-PLEV5-25.09.2015-GCorvera
                     vc_sep || 'Movimientos del Debe' || vc_sep ||
                     'Movimientos del Haber' ||
                    --<I>SUNAT-PLEV5-25.09.2015-GCorvera
                    /*--<I>PLE-v4.0-30.04.2014-CJulcapoma
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    vc_sep || 'Numero correlativo utilizado en el Registro de Ventas e Ingresos' ||
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    vc_sep || 'Numero correlativo utilizado en el Registro de Compras' ||
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    vc_sep || 'Numero correlativo utilizado en el Registro de Consignaciones' ||
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    --<F>PLE-v4.0-30.04.2014-CJulcapoma*/
                    --<F>SUNAT-PLEV5-25.09.2015-GCorvera
                     vc_sep || 'Dato Estructurado' || --SUNAT-PLEV5-25.09.2015-GCorvera
                     vc_sep || 'Indica el estado de la operacion  ' || --21
                     vc_sep || 'Campos de libre utilizacion'
                    --<I>IBK-LEM_LEASING-161215-EMauricio
                     || vc_sep || 'Llave Leasing' || vc_sep || 'Origen'
    --<F>IBK-LEM_LEASING-161215-EMauricio
     ;
    --**25/04/2018
    sp_write_log(pv_ruta, pv_name, vc_title_file);
    --**25/04/2018
    fnd_file.put_line(fnd_file.output, vc_title_file);
    --fnd_file.put_line(fnd_file.log,vc_title_file);
    --   SP_WRITE_LOG(pv_ruta, vv_name, vc_title_file);
  
    for rc_lin in table_temp loop
    
      if /*vd_compara*/
       to_date(rc_lin.period_name, 'MON-YY') < vd_comparar then
      
        if rc_lin.doc_sequence_value = nvl(v_cuo_old, '0') then
          vn_secuencial := vn_secuencial + 1;
        else
          vn_secuencial := 1;
        end if;
        v_cuo_old := rc_lin.doc_sequence_value;
      
        vc_title_line := rc_lin.period || vc_sep || --1
                         rc_lin.doc_sequence_value || vc_sep || --2
                         rc_lin.doc_sequence_line || vc_sep || --3      
                         rc_lin.ledger_account || vc_sep || --4
                         rc_lin.ledger_id || vc_sep || --5
                         rc_lin.centro_costo || vc_sep || --6
                         rc_lin.currency_code || vc_sep || --7
                         rc_lin.tipo_doc_prove || vc_sep || --8
                         rc_lin.numero_entidad_emisor || vc_sep || --9
                         rc_lin.doc_sunat || vc_sep || --10
                         rc_lin.serie_documento || vc_sep || --11
                         rc_lin.numero_documento || vc_sep || --12
                         rc_lin.effective_date || vc_sep || --13
                         rc_lin.due_date || vc_sep || --14
                         rc_lin.fecha_emision || vc_sep || --15
                         rc_lin.gl_description || vc_sep || --16
                         rc_lin.glosa_referencial || vc_sep || --17 --SUNAT-PLEV5-25.09.2015-GCorvera
                         rc_lin.accounted_dr || vc_sep || --18
                         rc_lin.accounted_cr || vc_sep || --19
                         rc_lin.structured_field || vc_sep || --20 --SUNAT-PLEV5-25.09.2015-GCorvera
						 rc_lin.line_status || vc_sep || --21
                         rc_lin.additional_field01 || vc_sep || --22
                         rc_lin.leasing_id || vc_sep || --23
                         rc_lin.origen;
      
        --**25/04/2018
        sp_write_log_add(pv_ruta, pv_name, vc_title_line);
        --**25/04/2018
      
        fnd_file.put_line(fnd_file.output, vc_title_line);
        --  SP_WRITE_LOG_ADD(pv_ruta, vv_name, vc_title_line);
      
        /*else
        select gjh.attribute3,
               rpad(rc_lin.doc_sequence_line, 1) || gjl.attribute3
          into vv_cuo_b, vv_correlativo_b
          from gl.gl_je_lines gjl, gl.gl_je_headers gjh
         where gjl.je_header_id = gjh.je_header_id
           and gjl.je_line_num = rc_lin.je_line_num
           and gjh.je_header_id = rc_lin.je_header_id;
        
        vc_title_line := rc_lin.period || vc_sep || --1
                         vv_cuo_b || vc_sep || --2
                         vv_correlativo_b || vc_sep || --3      
                         rc_lin.ledger_account || vc_sep || --4
                         rc_lin.ledger_id || vc_sep || --5
                         rc_lin.centro_costo || vc_sep || --6
                         rc_lin.currency_code || vc_sep || --7
                         rc_lin.tipo_doc_prove || vc_sep || --8
                         rc_lin.numero_entidad_emisor || vc_sep || --9
                         rc_lin.doc_sunat || vc_sep || --10
                         rc_lin.serie_documento || vc_sep || --11
                         rc_lin.numero_documento || vc_sep || --12
                         rc_lin.effective_date || vc_sep || --13
                         rc_lin.due_date || vc_sep || --14
                         rc_lin.fecha_emision || vc_sep || --15
                         rc_lin.gl_description || vc_sep || --16
                         rc_lin.glosa_referencial || vc_sep || --17 --SUNAT-PLEV5-25.09.2015-GCorvera
                         rc_lin.accounted_dr || vc_sep || --18
                         rc_lin.accounted_cr || vc_sep || --19
                         rc_lin.structured_field || vc_sep || --20 --SUNAT-PLEV5-25.09.2015-GCorvera
                         rc_lin.line_status || vc_sep || --21
                         rc_lin.additional_field01 || vc_sep || --22
                         rc_lin.leasing_id || vc_sep || --23
                         rc_lin.origen;*/
      end if;
    
    end loop;
  
    -- INI, LUIS JARA, 02/05/2018
    for rc_lin in table_temp_nuevo loop
    
      if rc_lin.attribute3_h || rc_lin.attribute3_l =
         nvl(v_cuo_old_n, 'SIN_VALOR') then
        vn_secuencial_n := vn_secuencial_n + 1;
      else
        vn_secuencial_n := 1;
      end if;
      v_cuo_old_n := rc_lin.attribute3_h || rc_lin.attribute3_l;
    
      /*select gjh.attribute3,
            rpad(rc_lin.doc_sequence_line, 1) || gjl.attribute3
       into vv_cuo_b, vv_correlativo_b
       from gl.gl_je_lines gjl, gl.gl_je_headers gjh
      where gjl.je_header_id = gjh.je_header_id
        and gjl.je_line_num = rc_lin.je_line_num
        and gjh.je_header_id = rc_lin.je_header_id;*/
    
      vc_title_line := rc_lin.period || vc_sep || --1
                      /*vv_cuo_b*/
                       rc_lin.attribute3_h || '-' ||
                       lpad(vn_secuencial_n, 5, '0') || vc_sep || --2
                      /*vv_correlativo_b*/
                       rpad(rc_lin.doc_sequence_line, 1) ||
                       rc_lin.attribute3_l || vc_sep || --3      
                       rc_lin.ledger_account || vc_sep || --4
                       rc_lin.ledger_id || vc_sep || --5
                       rc_lin.centro_costo || vc_sep || --6
                       rc_lin.currency_code || vc_sep || --7
                       rc_lin.tipo_doc_prove || vc_sep || --8
                       rc_lin.numero_entidad_emisor || vc_sep || --9
                       rc_lin.doc_sunat || vc_sep || --10
                       rc_lin.serie_documento || vc_sep || --11
                       rc_lin.numero_documento || vc_sep || --12
                       rc_lin.effective_date || vc_sep || --13
                       rc_lin.due_date || vc_sep || --14
                       rc_lin.fecha_emision || vc_sep || --15
                       rc_lin.gl_description || vc_sep || --16
                       rc_lin.glosa_referencial || vc_sep || --17 --SUNAT-PLEV5-25.09.2015-GCorvera
                       rc_lin.accounted_dr || vc_sep || --18
                       rc_lin.accounted_cr || vc_sep || --19
                       rc_lin.structured_field || vc_sep || --20 --SUNAT-PLEV5-25.09.2015-GCorvera
					   rc_lin.line_status || vc_sep || --21
                       rc_lin.additional_field01 || vc_sep || --22
                       rc_lin.leasing_id || vc_sep || --23
                       rc_lin.origen;
    
      --**25/04/2018
      sp_write_log_add(pv_ruta, pv_name, vc_title_line);
      --**25/04/2018
    
      fnd_file.put_line(fnd_file.output, vc_title_line);
      --  SP_WRITE_LOG_ADD(pv_ruta, vv_name, vc_title_line);
    
    end loop;
    -- FIN, LUIS JARA, 02/05/2018    
  
  end;

  procedure jc_tabla_temp2(pv_origen varchar2,
                           pv_name   varchar2,
                           pv_ruta   varchar2) is
  
    vd_comparar date;
  
    cursor table_temp is
      select a.period,
             a.doc_sequence_value,
             a.code_accounting,
             a.ledger_account,
             a.gl_date,
             translate(a.gl_description, '|/\', ' ') gl_description,
             a.accounted_dr,
             a.accounted_cr,
             a.line_status,
             a.annotation_date,
             a.je_header_id,
             a.je_line_num,
             a.org_id,
             a.period_name,
             a.ledger_id,
             a.created_by,
             a.creation_date,
             a.last_update_by,
             a.last_update_date,
             a.last_update_login,
             a.request_id,
             translate(a.additional_field01, '|/\', ' ') additional_field01,
             a.line_type,
             a.journal_type,
             a.doc_sequence_value_aux,
             a.doc_sequence_line,
             a.invoice_line_number,
             a.ae_header_id,
             a.ae_line_num,
             a.centro_costo,
             a.currency_code,
             a.tipo_doc_prove,
             a.numero_entidad_emisor,
             decode(a.doc_sunat, '', '00', 'NA', '00', a.doc_sunat) doc_sunat, --add modify 231017 pdiaz
             CASE WHEN a.doc_sunat = 91  AND a.serie_documento IS NULL THEN
                get_nodom_doc(a.invoice_id,'SERIE')
             ELSE
                a.serie_documento
             END serie_documento,
             
               CASE WHEN a.doc_sunat = 91 AND a.numero_documento IS NULL THEN
                get_nodom_doc(a.invoice_id,'NUMERO')
             ELSE
               decode(a.numero_documento, '', '00', a.numero_documento) 
               END numero_documento,
             a.effective_date,
             a.due_date,
             translate(substr(a.glosa_referencial, 1, 200), '|/\', ' ') glosa_referencial,
             a.structured_field,
             a.leasing_id,
             a.fecha_emision,
             a.je_source,
             decode(length(a.je_source), 2, 'BT', 'EBS') origen
        from ts_gl_lines_ple_tmp a
       where 1 = 1
         and (decode('EBS',
                     'TODOS',
                     'TODOS',
                     decode(length(je_source), 2, 'BT', 'EBS')) = 'EBS')
       order by a.doc_sequence_value;
  
    -- INI, LUIS JARA, 02/05/2018
    cursor table_temp_nuevo is
      select a.period,
             a.doc_sequence_value,
             a.code_accounting,
             a.ledger_account,
             a.gl_date,
             translate(a.gl_description, '|/\', ' ') gl_description,
             a.accounted_dr,
             a.accounted_cr,
             a.line_status,
             a.annotation_date,
             a.je_header_id,
             a.je_line_num,
             a.org_id,
             a.period_name,
             a.ledger_id,
             a.created_by,
             a.creation_date,
             a.last_update_by,
             a.last_update_date,
             a.last_update_login,
             a.request_id,
             translate(a.additional_field01, '|/\', ' ') additional_field01,
             a.line_type,
             a.journal_type,
             a.doc_sequence_value_aux,
             a.doc_sequence_line,
             a.invoice_line_number,
             a.ae_header_id,
             a.ae_line_num,
             a.centro_costo,
             a.currency_code,
             a.tipo_doc_prove,
             a.numero_entidad_emisor,
             decode(a.doc_sunat, '', '00', 'NA', '00', a.doc_sunat) doc_sunat, --add modify 231017 pdiaz
             CASE WHEN a.doc_sunat = 91 AND a.serie_documento IS NULL THEN
                get_nodom_doc(a.invoice_id,'SERIE')
             ELSE
                a.serie_documento
             END serie_documento,
               CASE WHEN a.doc_sunat = 91 AND a.numero_documento IS NULL THEN
                get_nodom_doc(a.invoice_id,'NUMERO')
             ELSE
               decode(a.numero_documento, '', '00', a.numero_documento) 
               END numero_documento,
             a.effective_date,
             a.due_date,
             translate(substr(a.glosa_referencial, 1, 200), '|/\', ' ') glosa_referencial,
             a.structured_field,
             a.leasing_id,
             a.fecha_emision,
             a.je_source,
             decode(length(a.je_source), 2, 'BT', 'EBS') origen,
             h.attribute3 as attribute3_h,
             l.attribute3 as attribute3_l
        from ts_gl_lines_ple_tmp a,
             apps.gl_je_headers  h,
             apps.gl_je_lines    l
       where 1 = 1
         and (decode('EBS',
                     'TODOS',
                     'TODOS',
                     decode(length(a.je_source), 2, 'BT', 'EBS')) = 'EBS')
            
            --and rownum <= 5                  
         and a.je_header_id = h.je_header_id(+)
         and a.je_header_id = l.je_header_id(+)
         and a.je_line_num = l.je_line_num(+)
         and to_date(a.period_name, 'MON-YY') >= vd_comparar
       order by h.attribute3 asc, l.attribute3 asc;
    -- FIN, LUIS JARA, 02/05/2018
  
    vc_title_file    varchar2(3000);
    vc_title_line    varchar2(4000);
    vc_sep           varchar2(1);
    vv_name          varchar2(200);
    vd_compara       date;
    vv_cuo_b         varchar2(200);
    vv_correlativo_b varchar2(200);
    vc_cuo_periodo   varchar2(15); /*CVEAS*/
    v_cuo_old        varchar2(80);
    v_cuo_old_n      varchar2(80);
    vn_secuencial    number;
    vn_secuencial_n  number;
  
  begin
  
    /*INICIO----CVEAS*/
    select c.period_name
      into vc_cuo_periodo
      from jc.jc_ple_nuevo_cuo_corr c;
  
    /*INICIO----CVEAS*/
  
    vd_comparar := to_date(vc_cuo_periodo, 'MON-YY') /*to_date('ENE-18','MON-YY')*/
     ; /*CVEAS*/
    vd_compara  := to_date(vg_period, 'MON-YY');
  
    vv_name := pv_name || '_' || pv_origen;
  
    vc_sep        := '|';
    vc_title_file := 'Periodo' ||
                    --<I>PLE-v4.0-30.04.2014-CJulcapoma
                     vc_sep || 'Codigo Unico de la Operacion (CUO)' ||
                    --vc_sep || 'Numero correlativo del asiento o Codigo Unico de la operacion en el Libro Diario' ||
                     vc_sep || 'Numero correlativo del asiento contable' ||
                    --<F>PLE-v4.0-30.04.2014-CJulcapoma
                    --vc_sep || 'Codigo del Plan de Cuentas utilizado por el deudor tributario' ||--GCM
                     vc_sep || 'Codigo de la cuenta contable asociada' ||
                    --<I>SUNAT-PLEV5-25.09.2015-GCorvera
                     vc_sep || 'Codigo de Unidad de Operacion' || vc_sep ||
                     'Centro de Costos' || vc_sep ||
                     'Tipo de Moneda de origen' || vc_sep ||
                     'Tipo de Documento de identidad de emisor' || vc_sep ||
                     'Numero de documento de identidad del emisor' ||
                     vc_sep ||
                     'Tipo de Comprobante de Pago o documento asociado' ||
                     vc_sep || 'Numero de Serie de comprobante de Pago' ||
                     vc_sep ||
                     'Numero del comprobante de Pago o documento asociado' ||
                     vc_sep || 'Fecha Contable' || vc_sep ||
                     'Fecha de Vencimiento' ||
                    --<F>SUNAT-PLEV5-25.09.2015-GCorvera
                     vc_sep || 'Fecha de la operacion' || vc_sep ||
                     'Glosa o descripcion de la naturaleza de la operacion registrada' ||
                     vc_sep || 'Glosa referencial' || --SUNAT-PLEV5-25.09.2015-GCorvera
                     vc_sep || 'Movimientos del Debe' || vc_sep ||
                     'Movimientos del Haber' ||
                    --<I>SUNAT-PLEV5-25.09.2015-GCorvera
                    /*--<I>PLE-v4.0-30.04.2014-CJulcapoma
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    vc_sep || 'Numero correlativo utilizado en el Registro de Ventas e Ingresos' ||
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    vc_sep || 'Numero correlativo utilizado en el Registro de Compras' ||
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    vc_sep || 'Numero correlativo utilizado en el Registro de Consignaciones' ||
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    --<F>PLE-v4.0-30.04.2014-CJulcapoma*/
                    --<F>SUNAT-PLEV5-25.09.2015-GCorvera
                     vc_sep || 'Dato Estructurado' || --SUNAT-PLEV5-25.09.2015-GCorvera
                     vc_sep || 'Indica el estado de la operacion  ' || --21
                     vc_sep || 'Campos de libre utilizacion'
                    --<I>IBK-LEM_LEASING-161215-EMauricio
                     || vc_sep || 'Llave Leasing' || vc_sep || 'Origen'
    --<F>IBK-LEM_LEASING-161215-EMauricio
     ;
  
    --**25/04/2018
    sp_write_log(pv_ruta, pv_name, vc_title_file);
    --**25/04/2018
  
    fnd_file.put_line(fnd_file.output, vc_title_file);
    --fnd_file.put_line(fnd_file.log,vc_title_file);
    -- SP_WRITE_LOG(pv_ruta, vv_name, vc_title_file);
  
    for rc_lin in table_temp loop
      dbms_output.put_line('ENTRO');
      if /*vd_compara*/
       to_date(rc_lin.period_name, 'MON-YY') < vd_comparar then
      
        /* if rc_lin.doc_sequence_value = nvl(v_cuo_old, '0') then
          vn_secuencial := vn_secuencial + 1;
        else
          vn_secuencial := 1;
        end if;
        v_cuo_old := rc_lin.doc_sequence_value;*/
      
        vc_title_line := rc_lin.period || vc_sep || --1
                         rc_lin.doc_sequence_value /*|| '-' || vn_secuencial */
                         || vc_sep || --2
                         rc_lin.doc_sequence_line || vc_sep || --3      
                         rc_lin.ledger_account || vc_sep || --4
                         rc_lin.ledger_id || vc_sep || --5
                         rc_lin.centro_costo || vc_sep || --6
                         rc_lin.currency_code || vc_sep || --7
                         rc_lin.tipo_doc_prove || vc_sep || --8
                         rc_lin.numero_entidad_emisor || vc_sep || --9
                         rc_lin.doc_sunat || vc_sep || --10
                         rc_lin.serie_documento || vc_sep || --11
                         rc_lin.numero_documento || vc_sep || --12
                         rc_lin.effective_date || vc_sep || --13
                         rc_lin.due_date || vc_sep || --14
                         rc_lin.fecha_emision || vc_sep || --15
                         rc_lin.gl_description || vc_sep || --16
                         rc_lin.glosa_referencial || vc_sep || --17 --SUNAT-PLEV5-25.09.2015-GCorvera
                         rc_lin.accounted_dr || vc_sep || --18
                         rc_lin.accounted_cr || vc_sep || --19
                         rc_lin.structured_field || vc_sep || --20 --SUNAT-PLEV5-25.09.2015-GCorvera
                         rc_lin.line_status || vc_sep || --21
                         rc_lin.additional_field01 || vc_sep || --22
                         rc_lin.leasing_id || vc_sep || --23
                         rc_lin.origen;
        dbms_output.put_line('ENTRO2');
        /*else
        
        select gjh.attribute3,
               rpad(rc_lin.doc_sequence_line, 1) || gjl.attribute3
          into vv_cuo_b, vv_correlativo_b
          from gl.gl_je_lines gjl, gl.gl_je_headers gjh
         where gjl.je_header_id = gjh.je_header_id
           and gjl.je_line_num = rc_lin.je_line_num
           and gjh.je_header_id = rc_lin.je_header_id;
        
        vc_title_line := rc_lin.period || vc_sep || --1
                         vv_cuo_b || vc_sep || --2
                         vv_correlativo_b || vc_sep || --3      
                         rc_lin.ledger_account || vc_sep || --4
                         rc_lin.ledger_id || vc_sep || --5
                         rc_lin.centro_costo || vc_sep || --6
                         rc_lin.currency_code || vc_sep || --7
                         rc_lin.tipo_doc_prove || vc_sep || --8
                         rc_lin.numero_entidad_emisor || vc_sep || --9
                         rc_lin.doc_sunat || vc_sep || --10
                         rc_lin.serie_documento || vc_sep || --11
                         rc_lin.numero_documento || vc_sep || --12
                         rc_lin.effective_date || vc_sep || --13
                         rc_lin.due_date || vc_sep || --14
                         rc_lin.fecha_emision || vc_sep || --15
                         rc_lin.gl_description || vc_sep || --16
                         rc_lin.glosa_referencial || vc_sep || --17 --SUNAT-PLEV5-25.09.2015-GCorvera
                         rc_lin.accounted_dr || vc_sep || --18
                         rc_lin.accounted_cr || vc_sep || --19
                         rc_lin.structured_field || vc_sep || --20 --SUNAT-PLEV5-25.09.2015-GCorvera
                         rc_lin.line_status || vc_sep || --21
                         rc_lin.additional_field01 || vc_sep || --22
                         rc_lin.leasing_id || vc_sep || --23
                         rc_lin.origen;*/
      
        --**25/04/2018
        sp_write_log_add(pv_ruta, pv_name, vc_title_line);
        --**25/04/2018
      
        fnd_file.put_line(fnd_file.output, vc_title_line);
        --  SP_WRITE_LOG_ADD(pv_ruta, vv_name, vc_title_line);
      
      end if;
    
    end loop;
  
    -- INI, LUIS JARA, 02/05/2018
    for rc_lin in table_temp_nuevo loop
    
      dbms_output.put_line('ENTRO');
    
      /*select gjh.attribute3,
            rpad(rc_lin.doc_sequence_line, 1) || gjl.attribute3
       into vv_cuo_b, vv_correlativo_b
       from gl.gl_je_lines gjl, gl.gl_je_headers gjh
      where gjl.je_header_id = gjh.je_header_id
        and gjl.je_line_num = rc_lin.je_line_num
        and gjh.je_header_id = rc_lin.je_header_id;*/
    
      if rc_lin.attribute3_h || rc_lin.attribute3_l =
         nvl(v_cuo_old_n, 'SIN_VALOR') then
        vn_secuencial_n := vn_secuencial_n + 1;
      else
        vn_secuencial_n := 1;
      end if;
      v_cuo_old_n := rc_lin.attribute3_h || rc_lin.attribute3_l;
    
      vc_title_line := rc_lin.period || vc_sep || --1
                      /*vv_cuo_b*/
                       rc_lin.attribute3_h || '-' ||
                       lpad(vn_secuencial_n, 5, '0') || vc_sep || --2
                      /*vv_correlativo_b*/
                       rpad(rc_lin.doc_sequence_line, 1) ||
                       rc_lin.attribute3_l || vc_sep || --3      
                       rc_lin.ledger_account || vc_sep || --4
                       rc_lin.ledger_id || vc_sep || --5
                       rc_lin.centro_costo || vc_sep || --6
                       rc_lin.currency_code || vc_sep || --7
                       rc_lin.tipo_doc_prove || vc_sep || --8
                       rc_lin.numero_entidad_emisor || vc_sep || --9
                       rc_lin.doc_sunat || vc_sep || --10
                       rc_lin.serie_documento || vc_sep || --11
                       rc_lin.numero_documento || vc_sep || --12
                       rc_lin.effective_date || vc_sep || --13
                       rc_lin.due_date || vc_sep || --14
                       rc_lin.fecha_emision || vc_sep || --15
                       rc_lin.gl_description || vc_sep || --16
                       rc_lin.glosa_referencial || vc_sep || --17 --SUNAT-PLEV5-25.09.2015-GCorvera
                       rc_lin.accounted_dr || vc_sep || --18
                       rc_lin.accounted_cr || vc_sep || --19
                       rc_lin.structured_field || vc_sep || --20 --SUNAT-PLEV5-25.09.2015-GCorvera
                       rc_lin.line_status || vc_sep || --21
                       rc_lin.additional_field01 || vc_sep || --22
                       rc_lin.leasing_id || vc_sep || --23
                       rc_lin.origen;
    
      --**25/04/2018
      sp_write_log_add(pv_ruta, pv_name, vc_title_line);
      --**25/04/2018
    
      fnd_file.put_line(fnd_file.output, vc_title_line);
      --  SP_WRITE_LOG_ADD(pv_ruta, vv_name, vc_title_line);
    end loop;
    -- FIN, LUIS JARA, 02/05/2018 
  
  end;

  procedure jc_tabla_temp3(pv_origen varchar2,
                           pv_name   varchar2,
                           pv_ruta   varchar2) is
    cursor table_temp is
      select a.period,
             a.doc_sequence_value,
             a.code_accounting,
             a.ledger_account,
             a.gl_date,
             translate(a.gl_description, '|/\', ' ') gl_description,
             a.accounted_dr,
             a.accounted_cr,
             a.line_status,
             a.annotation_date,
             a.je_header_id,
             a.je_line_num,
             a.org_id,
             a.period_name,
             a.ledger_id,
             a.created_by,
             a.creation_date,
             a.last_update_by,
             a.last_update_date,
             a.last_update_login,
             a.request_id,
             translate(a.additional_field01, '|/\', ' ') additional_field01,
             a.line_type,
             a.journal_type,
             a.doc_sequence_value_aux,
             a.doc_sequence_line,
             a.invoice_line_number,
             a.ae_header_id,
             a.ae_line_num,
             a.centro_costo,
             a.currency_code,
             a.tipo_doc_prove,
             a.numero_entidad_emisor,
             decode(a.doc_sunat, '', '00', 'NA', '00', a.doc_sunat) doc_sunat, --add modify 231017 pdiaz
             a.serie_documento,
             decode(a.numero_documento, '', '00', a.numero_documento) numero_documento,
             a.effective_date,
             a.due_date,
             translate(substr(a.glosa_referencial, 1, 200), '|/\', ' ') glosa_referencial,
             a.structured_field,
             a.leasing_id,
             a.fecha_emision,
             a.je_source,
             decode(length(a.je_source), 2, 'BT', 'EBS') origen
        from ts_gl_lines_ple_tmp a
       where 1 = 1
            --   AND rownum < 10
         and (decode('TODOS',
                     'TODOS',
                     'TODOS',
                     decode(length(je_source), 2, 'BT', 'EBS')) = 'TODOS')
       order by a.doc_sequence_value;
  
    -- INI, LUIS JARA, 02/05/2018
    vd_comparar     date;
    v_cuo_old_n     varchar2(80);
    vn_secuencial_n number;
  
    -- FIN, LUIS JARA, 02/05/2018
  
    vc_title_file varchar2(3000);
    vc_title_line varchar2(4000);
    vc_sep        varchar2(1);
    vv_name       varchar2(200);
    --vd_comparar      date;
    vd_compara       date;
    vv_cuo_b         varchar2(200);
    vv_correlativo_b varchar2(200);
    vc_cuo_periodo   varchar2(15); /*CVEAS*/
    v_cuo_old        varchar2(80);
    vn_secuencial    number;
  
    v_strucuture_field varchar2(500);
  
  begin
  
    /*INICIO----CVEAS*/
    select c.period_name
      into vc_cuo_periodo
      from jc.jc_ple_nuevo_cuo_corr c;
  
    /*FIN----CVEAS*/
  
    vd_comparar := to_date(vc_cuo_periodo, 'MON-YY') /*to_date('ENE-18','MON-YY')*/
     ; /*CVEAS*/
    vd_compara  := to_date(vg_period, 'MON-YY');
    vv_name     := pv_name || '_' || pv_origen;
  
    vc_sep        := '|';
    vc_title_file := 'Periodo' ||
                    --<I>PLE-v4.0-30.04.2014-CJulcapoma
                     vc_sep || 'Codigo Unico de la Operacion (CUO)' ||
                    --vc_sep || 'Numero correlativo del asiento o Codigo Unico de la operacion en el Libro Diario' ||
                     vc_sep || 'Numero correlativo del asiento contable' ||
                    --<F>PLE-v4.0-30.04.2014-CJulcapoma
                    --vc_sep || 'Codigo del Plan de Cuentas utilizado por el deudor tributario' ||--GCM
                     vc_sep || 'Codigo de la cuenta contable asociada' ||
                    --<I>SUNAT-PLEV5-25.09.2015-GCorvera
                     vc_sep || 'Codigo de Unidad de Operacion' || vc_sep ||
                     'Centro de Costos' || vc_sep ||
                     'Tipo de Moneda de origen' || vc_sep ||
                     'Tipo de Documento de identidad de emisor' || vc_sep ||
                     'Numero de documento de identidad del emisor' ||
                     vc_sep ||
                     'Tipo de Comprobante de Pago o documento asociado' ||
                     vc_sep || 'Numero de Serie de comprobante de Pago' ||
                     vc_sep ||
                     'Numero del comprobante de Pago o documento asociado' ||
                     vc_sep || 'Fecha Contable' || vc_sep ||
                     'Fecha de Vencimiento' ||
                    --<F>SUNAT-PLEV5-25.09.2015-GCorvera
                     vc_sep || 'Fecha de la operacion' || vc_sep ||
                     'Glosa o descripcion de la naturaleza de la operacion registrada' ||
                     vc_sep || 'Glosa referencial' || --SUNAT-PLEV5-25.09.2015-GCorvera
                     vc_sep || 'Movimientos del Debe' || vc_sep ||
                     'Movimientos del Haber' ||
                    --<I>SUNAT-PLEV5-25.09.2015-GCorvera
                    /*--<I>PLE-v4.0-30.04.2014-CJulcapoma
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    vc_sep || 'Numero correlativo utilizado en el Registro de Ventas e Ingresos' ||
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    vc_sep || 'Numero correlativo utilizado en el Registro de Compras' ||
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    vc_sep || 'Numero correlativo utilizado en el Registro de Consignaciones' ||
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    --<F>PLE-v4.0-30.04.2014-CJulcapoma*/
                    --<F>SUNAT-PLEV5-25.09.2015-GCorvera
                     vc_sep || 'Dato Estructurado' || --SUNAT-PLEV5-25.09.2015-GCorvera
                     vc_sep || 'Indica el estado de la operacion  ' || --21
                     vc_sep || 'Campos de libre utilizacion'
                    --<I>IBK-LEM_LEASING-161215-EMauricio
                     || vc_sep || 'Llave Leasing' || vc_sep || 'Origen'
    --<F>IBK-LEM_LEASING-161215-EMauricio
     ;
  
    --**25/04/2018
    sp_write_log(pv_ruta, pv_name, vc_title_file);
    --**25/04/2018
  
    fnd_file.put_line(fnd_file.output, vc_title_file);
    --fnd_file.put_line(fnd_file.log,vc_title_file);
    --  SP_WRITE_LOG(pv_ruta, vv_name, vc_title_file);
  
    for rc_lin in table_temp loop
    
      if /*vd_compara*/
       to_date(rc_lin.period_name, 'MON-YY') < vd_comparar then
      
        if rc_lin.doc_sequence_value = nvl(v_cuo_old, '0') then
          vn_secuencial := vn_secuencial + 1;
        else
          vn_secuencial := 1;
        end if;
        v_cuo_old := rc_lin.doc_sequence_value;
      
        vc_title_line := rc_lin.period || vc_sep || --1
                         rc_lin.doc_sequence_value || vc_sep || --2
                         rc_lin.doc_sequence_line || vc_sep || --3      
                         rc_lin.ledger_account || vc_sep || --4
                         rc_lin.ledger_id || vc_sep || --5
                         rc_lin.centro_costo || vc_sep || --6
                         rc_lin.currency_code || vc_sep || --7
                         rc_lin.tipo_doc_prove || vc_sep || --8
                         rc_lin.numero_entidad_emisor || vc_sep || --9
                         rc_lin.doc_sunat || vc_sep || --10
                         rc_lin.serie_documento || vc_sep || --11
                         rc_lin.numero_documento || vc_sep || --12
                         rc_lin.effective_date || vc_sep || --13
                         rc_lin.due_date || vc_sep || --14
                         rc_lin.fecha_emision || vc_sep || --15
                         rc_lin.gl_description || vc_sep || --16
                         rc_lin.glosa_referencial || vc_sep || --17 --SUNAT-PLEV5-25.09.2015-GCorvera
                         rc_lin.accounted_dr || vc_sep || --18
                         rc_lin.accounted_cr || vc_sep || --19
                         rc_lin.structured_field || vc_sep || --20 --SUNAT-PLEV5-25.09.2015-GCorvera  
                         rc_lin.line_status || vc_sep || --21
                         rc_lin.additional_field01 || vc_sep || --22
                         rc_lin.leasing_id || vc_sep || --23
                         rc_lin.origen;
      
        /*else
        select gjh.attribute3,
               rpad(rc_lin.doc_sequence_line, 1) || gjl.attribute3
          into vv_cuo_b, vv_correlativo_b
          from gl.gl_je_lines gjl, gl.gl_je_headers gjh
         where gjl.je_header_id = gjh.je_header_id
           and gjl.je_line_num = rc_lin.je_line_num
           and gjh.je_header_id = rc_lin.je_header_id;
        
        vc_title_line := rc_lin.period || vc_sep || --1
                         vv_cuo_b || vc_sep || --2
                         vv_correlativo_b || vc_sep || --3      
                         rc_lin.ledger_account || vc_sep || --4
                         rc_lin.ledger_id || vc_sep || --5
                         rc_lin.centro_costo || vc_sep || --6
                         rc_lin.currency_code || vc_sep || --7
                         rc_lin.tipo_doc_prove || vc_sep || --8
                         rc_lin.numero_entidad_emisor || vc_sep || --9
                         rc_lin.doc_sunat || vc_sep || --10
                         rc_lin.serie_documento || vc_sep || --11
                         rc_lin.numero_documento || vc_sep || --12
                         rc_lin.effective_date || vc_sep || --13
                         rc_lin.due_date || vc_sep || --14
                         rc_lin.fecha_emision || vc_sep || --15
                         rc_lin.gl_description || vc_sep || --16
                         rc_lin.glosa_referencial || vc_sep || --17 --SUNAT-PLEV5-25.09.2015-GCorvera
                         rc_lin.accounted_dr || vc_sep || --18
                         rc_lin.accounted_cr || vc_sep || --19
                         rc_lin.structured_field || vc_sep || --20 --SUNAT-PLEV5-25.09.2015-GCorvera
                         rc_lin.line_status || vc_sep || --21
                         rc_lin.additional_field01 || vc_sep || --22
                         rc_lin.leasing_id || vc_sep || --23
                         rc_lin.origen;*/
      
        --**25/04/2018
        sp_write_log_add(pv_ruta, pv_name, vc_title_line);
        --**25/04/2018
      
        fnd_file.put_line(fnd_file.output, vc_title_line);
        -- SP_WRITE_LOG_ADD(pv_ruta, vv_name, vc_title_line);
      
      end if;
    
    end loop;
  
  end;

  procedure jc_tabla_temp3_nuevo(pv_origen varchar2,
                                 pv_name   varchar2,
                                 pv_ruta   varchar2) is
  
    -- INI, LUIS JARA, 02/05/2018
    vd_comparar     date;
    v_cuo_old_n     varchar2(80);
    vn_secuencial_n number;
  
    cursor c_stry(cn_period varchar2) is
      select /*+parallel (a,10)*/
       period,
       doc_sequence_value,
       code_accounting,
       ledger_account,
       gl_date,
       gl_description,
       accounted_dr,
       accounted_cr,
       line_status,
       annotation_date,
       je_header_id,
       je_line_num,
       org_id,
       period_name,
       ledger_id,
       created_by,
       creation_date,
       last_update_by,
       last_update_date,
       last_update_login,
       request_id,
       additional_field01,
       line_type,
       journal_type,
       doc_sequence_value_aux,
       doc_sequence_line,
       invoice_line_number,
       ae_header_id,
       ae_line_num,
       centro_costo,
       currency_code,
       tipo_doc_prove,
       numero_entidad_emisor,
       doc_sunat,
       serie_documento,
       numero_documento,
       effective_date,
       due_date,
       glosa_referencial,
       structured_field,
       leasing_id,
       fecha_emision,
       je_source,
       origen,
       attribute3_l,
       attribute3_h,
       IMPORT_TOT_EXCEP_SUNAT,
       CUOEBS,
       RELEBS,
       DESCRIPTION
      
        from JC_EBS_FE_TODOS_ALL_TMP a 
      
       where/* rownum < 999999
            
         and */ a.PERIOD_NAME = cn_period
      
       order by a.ATTRIBUTE3_H asc, a.ATTRIBUTE3_L asc;
  
    -- FIN, LUIS JARA, 02/05/2018
  
    vc_title_file varchar2(3000);
    vc_title_line varchar2(4000);
    vc_sep        varchar2(1);
    vv_name       varchar2(200);
    --vd_comparar      date;
    vd_compara       date;
    vv_cuo_b         varchar2(200);
    vv_correlativo_b varchar2(200);
    vc_cuo_periodo   varchar2(15); /*CVEAS*/
    v_cuo_old        varchar2(80);
    vn_secuencial    number;
  
    v_strucuture_field varchar2(500);
  
    ---bulk collect
    TYPE stry_type IS TABLE OF c_stry%ROWTYPE INDEX BY PLS_INTEGER;
    vt_stry      stry_type;
    rc_lin       c_stry%ROWTYPE;
    vn_bulk_cant NUMBER := 1000;
  
  begin
  
    /*INICIO----CVEAS*/
    select c.period_name
      into vc_cuo_periodo
      from jc.jc_ple_nuevo_cuo_corr c;
  
    /*FIN----CVEAS*/
  
    vd_comparar := to_date(vc_cuo_periodo, 'MON-YY') /*to_date('ENE-18','MON-YY')*/
     ; /*CVEAS*/
    vd_compara  := to_date(vg_period, 'MON-YY');
    vv_name     := pv_name || '_' || pv_origen;
  
    vc_sep        := '|';
    vc_title_file := 'Periodo' ||
                    --<I>PLE-v4.0-30.04.2014-CJulcapoma
                     vc_sep || 'Codigo Unico de la Operacion (CUO)' ||
                    --vc_sep || 'Numero correlativo del asiento o Codigo Unico de la operacion en el Libro Diario' ||
                     vc_sep || 'Numero correlativo del asiento contable' ||
                    --<F>PLE-v4.0-30.04.2014-CJulcapoma
                    --vc_sep || 'Codigo del Plan de Cuentas utilizado por el deudor tributario' ||--GCM
                     vc_sep || 'Codigo de la cuenta contable asociada' ||
                    --<I>SUNAT-PLEV5-25.09.2015-GCorvera
                     vc_sep || 'Codigo de Unidad de Operacion' || vc_sep ||
                     'Centro de Costos' || vc_sep ||
                     'Tipo de Moneda de origen' || vc_sep ||
                     'Tipo de Documento de identidad de emisor' || vc_sep ||
                     'Numero de documento de identidad del emisor' ||
                     vc_sep ||
                     'Tipo de Comprobante de Pago o documento asociado' ||
                     vc_sep || 'Numero de Serie de comprobante de Pago' ||
                     vc_sep ||
                     'Numero del comprobante de Pago o documento asociado' ||
                     vc_sep || 'Fecha Contable' || vc_sep ||
                     'Fecha de Vencimiento' ||
                    --<F>SUNAT-PLEV5-25.09.2015-GCorvera
                     vc_sep || 'Fecha de la operacion' || vc_sep ||
                     'Glosa o descripcion de la naturaleza de la operacion registrada' ||
                     vc_sep || 'Glosa referencial' || --SUNAT-PLEV5-25.09.2015-GCorvera
                     vc_sep || 'Movimientos del Debe' || vc_sep ||
                     'Movimientos del Haber' ||
                    --<I>SUNAT-PLEV5-25.09.2015-GCorvera
                    /*--<I>PLE-v4.0-30.04.2014-CJulcapoma
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    vc_sep || 'Numero correlativo utilizado en el Registro de Ventas e Ingresos' ||
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    vc_sep || 'Numero correlativo utilizado en el Registro de Compras' ||
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    vc_sep || 'Numero correlativo utilizado en el Registro de Consignaciones' ||
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    --<F>PLE-v4.0-30.04.2014-CJulcapoma*/
                    --<F>SUNAT-PLEV5-25.09.2015-GCorvera
                     vc_sep || 'Dato Estructurado' || --SUNAT-PLEV5-25.09.2015-GCorvera
                     vc_sep || 'Indica el estado de la operacion  ' || --21
                     vc_sep || 'Campos de libre utilizacion'
                    --<I>IBK-LEM_LEASING-161215-EMauricio
                     || vc_sep || 'Llave Leasing' || vc_sep || 'Origen'
                     
                     --ADD110319 PDZ JOGZAR
                     || vc_sep || 'Importe total del comprobante de pago - Excepción SUNAT'
                     || vc_sep || 'CUO y Correlativo EBS del comprobante de pago que se modifica'
                     || vc_sep || 'Correlativo EBS del comprobante de pago que se modifica'
                     || vc_sep || 'Asiento BT del comprobante de pago que se modifica (Fecha-Cia-Sucursal-Modulo-Transaccion-Relacion)'


    --<F>IBK-LEM_LEASING-161215-EMauricio
     ;
  
    --**25/04/2018
    sp_write_log(pv_ruta, pv_name, vc_title_file);
    --**25/04/2018
  
    fnd_file.put_line(fnd_file.output, vc_title_file);
    --fnd_file.put_line(fnd_file.log,vc_title_file);
    --  SP_WRITE_LOG(pv_ruta, vv_name, vc_title_file);
  
    -- INI, LUIS JARA, 02/05/2018
  
    open c_stry(vg_period);
  
    loop
    
      FETCH c_stry BULK COLLECT
      
        INTO vt_stry LIMIT vn_bulk_cant;
    
      for idx in 1 .. vt_stry.count loop
      
        rc_lin := vt_stry(idx);
      
        begin
        
          if rc_lin.attribute3_h || rc_lin.attribute3_l =
             nvl(v_cuo_old_n, 'SIN_VALOR') then
            vn_secuencial_n := vn_secuencial_n + 1;
          else
            vn_secuencial_n := 1;
          end if;
          v_cuo_old_n := rc_lin.attribute3_h || rc_lin.attribute3_l;
        
          IF rc_lin.origen = 'FE' AND rc_lin.structured_field <> 'SIN_VALOR' THEN
          
            /*v_strucuture_field := '140100' || '&' || rc_lin.period || '&' ||
                                  rc_lin.attribute3_h \*|| '-' ||lpad(vn_secuencial_n, 5, '0')*\
                                  || '&' ||
                                  rpad(rc_lin.doc_sequence_line, 1) ||
                                  rc_lin.attribute3_l;*/
            v_strucuture_field := lpad(rc_lin.numero_entidad_emisor,11,'0')||lpad(rc_lin.doc_sunat,2,'0') || lpad(rc_lin.serie_documento,4,'0') ||lpad(rc_lin.numero_documento,10,'0');
                                  
          ELSIF rc_lin.origen = 'FE' AND rc_lin.structured_field = 'SIN_VALOR' THEN
          
            v_strucuture_field := '';                        
                                  
          ELSE
          
            v_strucuture_field := rc_lin.structured_field;
          
          END IF;
        
          vc_title_line := rc_lin.period || vc_sep || --1
                          /*vv_cuo_b*/
                           rc_lin.attribute3_h || '-' ||
                           lpad(vn_secuencial_n, 5, '0') || vc_sep || --2
                          /*vv_correlativo_b*/
                           rpad(rc_lin.doc_sequence_line, 1) ||
                           rc_lin.attribute3_l || vc_sep || --3      
                           rc_lin.ledger_account || vc_sep || --4
                           rc_lin.ledger_id || vc_sep || --5
                           rc_lin.centro_costo || vc_sep || --6
                           rc_lin.currency_code || vc_sep || --7
                           rc_lin.tipo_doc_prove || vc_sep || --8
                           rc_lin.numero_entidad_emisor || vc_sep || --9
                           rc_lin.doc_sunat || vc_sep || --10
                           rc_lin.serie_documento || vc_sep || --11
                           rc_lin.numero_documento || vc_sep || --12
                           rc_lin.effective_date || vc_sep || --13
                           rc_lin.due_date || vc_sep || --14
                           rc_lin.fecha_emision || vc_sep || --15
                           rc_lin.gl_description || vc_sep || --16
                           rc_lin.glosa_referencial || vc_sep || --17 --SUNAT-PLEV5-25.09.2015-GCorvera
                           rc_lin.accounted_dr || vc_sep || --18
                           rc_lin.accounted_cr || vc_sep || --19
                          /*rc_lin.structured_field*/
                           v_strucuture_field || vc_sep || --20 --SUNAT-PLEV5-25.09.2015-GCorvera
						   --lpad(NVL(rc_lin.numero_entidad_emisor,'0'),11,'0')||lpad(NVL(rc_lin.doc_sunat,'0'),2,'0')|| lpad(NVL(rc_lin.serie_documento,'0'),4,'0')||lpad(rc_lin.numero_documento,10,'0')||vc_sep || -- CAR -- SIRE PPCH Royal ITC
                           rc_lin.line_status || vc_sep || --21
                           rc_lin.additional_field01 || vc_sep || --22
                           rc_lin.leasing_id || vc_sep || --23
                           rc_lin.origen
                           --add110319 jogzar pdz
                             || vc_sep || --38
                             rc_lin.import_tot_excep_sunat
                             || vc_sep || --39
                             rc_lin.cuoebs
                             || vc_sep || --40
                             rc_lin.relebs
                             || vc_sep || --41
                             rc_lin.description
                           --
                           ;
        
          --**25/04/2018
          sp_write_log_add(pv_ruta, pv_name, vc_title_line);
          --**25/04/2018
        
          fnd_file.put_line(fnd_file.output, vc_title_line);
          -- SP_WRITE_LOG_ADD(pv_ruta, vv_name, vc_title_line);
        
        end;
      
      end loop;
    
      EXIT WHEN vt_stry.COUNT < vn_bulk_cant;
    
    end loop;
  
    close c_stry;
  
  end;

  procedure jc_tabla_temp4(pv_origen varchar2,
                           pv_name   varchar2,
                           pv_ruta   varchar2) is
  
    -- INI, LUIS JARA, 02/05/2018
    vd_comparar date;
  
    cursor table_temp_nuevo is
      select a.period,
             a.doc_sequence_value,
             a.code_accounting,
             a.ledger_account,
             a.gl_date,
             translate(a.gl_description, '|/\', ' ') gl_description,
             a.accounted_dr,
             a.accounted_cr,
             a.line_status,
             a.annotation_date,
             a.je_header_id,
             a.je_line_num,
             a.org_id,
             a.period_name,
             a.ledger_id,
             a.created_by,
             a.creation_date,
             a.last_update_by,
             a.last_update_date,
             a.last_update_login,
             a.request_id,
             translate(a.additional_field01, '|/\', ' ') additional_field01,
             a.line_type,
             a.journal_type,
             a.doc_sequence_value_aux,
             a.doc_sequence_line,
             a.invoice_line_number,
             a.ae_header_id,
             a.ae_line_num,
             a.centro_costo,
             a.currency_code,
             a.tipo_doc_prove,
             a.numero_entidad_emisor,
             decode(a.doc_sunat, '', '00', 'NA', '00', a.doc_sunat) doc_sunat, --add modify 231017 pdiaz
             a.serie_documento,
             decode(a.numero_documento, '', '00', a.numero_documento) numero_documento,
             a.effective_date,
             a.due_date,
             translate(substr(a.glosa_referencial, 1, 200), '|/\', ' ') glosa_referencial,
             /*'140100' || '&' || a.period || '&' ||
               h.attribute3|| '&' || rpad(a.doc_sequence_line, 1) ||
               l.attribute3*/ 
             lpad(a.numero_entidad_emisor,11,'0')||lpad(decode(a.doc_sunat, '', '00', 'NA', '00', a.doc_sunat),2,'0') || lpad(a.serie_documento,4,'0') ||lpad(decode(a.numero_documento, '', '00', a.numero_documento),10,'0')  structured_field,
             a.leasing_id,
             a.fecha_emision,
             a.je_source,
             /*decode(length(a.je_source), 2, 'BT', 'EBS')*/
             'FE' origen,
             h.attribute3 as attribute3_h,
             l.attribute3 as attribute3_l,
             
             ----FE
             
             aqp.AQPA470TDOCR,
             aqp.AQPA470NRUC,
             LPAD(aqp.AQPA470TCOMF, 2, '0') AQPA470TCOMF,
             aqp.AQPA470SERI,
             aqp.AQPA470NUM
             
             --ADD11032019 PDZ JOGZAR
             
              ,
              null import_tot_excep_sunat--38
              ,
              
              null cuoebs --39
              
             ,
              
              null relebs--40 
              
              ,
              
              null description --41  
              
              
             
      
        from ts_gl_lines_ple_tmp a,
             apps.gl_je_headers  h,
             apps.gl_je_lines    l,
             --FE
             (select to_char(xz.aqpa470con, 'YYYYMMDD') || '-' ||
                     xz.aqpa470pgcod || '-' || xz.aqpa470sucor || '-' ||
                     xz.aqpa470mod || '-' || xz.aqpa470tran || '-' ||
                     xz.aqpa470rel || '-' || xz.aqpa470cord || '-' ||
                     xz.aqpa470subo description_line,
                     
                     xz.AQPA470TCOMF,
                     decode(xz.AQPA470SERI,
                            null,
                            xz.AQPA470SERIE,
                            xz.AQPA470SERI) AQPA470SERI,
                     decode(xz.AQPA470NUM,
                            null,
                            xz.AQPA470NRO,
                            xz.AQPA470NRO) AQPA470NUM,
                     xz.AQPA470TDOCR,
                     trim(xz.AQPA470NRUC) AQPA470NRUC 

                     
                from /*operador.*/ --se comento esquema 05/11/2021 dcastro
                XXBOL.AQPA470 xz
               where to_char(xz.AQPA470FEMI, 'MON-YY') = vg_period
               and xz.AQPA470LEST NOT IN ('M','R') -- NO TRAE LOS DOCUMENTOS ANULADOS
               ) aqp
      --FE
       where 1 = 1
            
         and (decode('BT',
                     'TODOS',
                     'TODOS',
                     decode(length(a.je_source), 2, 'BT', 'EBS')) = 'BT')
         and to_date(a.period_name, 'MON-YY') >= vd_comparar
         and a.je_header_id = h.je_header_id(+)
         and a.je_header_id = l.je_header_id(+)
         and a.je_line_num = l.je_line_num(+)
            --FE
         and a.DESCRIPTION_LINE = aqp.DESCRIPTION_LINE
         
         and not exists (select 1 
                         from JC.jc_aqpa470_per xz 
                         where (to_char(xz.aqpa470con, 'YYYYMMDD') || '-' || xz.aqpa470pgcod || '-' || xz.aqpa470sucor || '-' ||
                         xz.aqpa470mod || '-' || xz.aqpa470tran || '-' || xz.aqpa470rel || '-' || xz.aqpa470cord || '-' ||
                         xz.aqpa470subo) = aqp.DESCRIPTION_LINE
                         and  to_char(xz.AQPA470FEMI, 'MON-YY') = vg_period  
                         and xz.flag_rv = 'Y'
                         and nvl(xz.aqpa470flag,'X') = 'S'
                         )
         
     UNION ALL
     
      select to_char(xz.aqpa470femi, 'YYYYMM') || '00' period, --1
             null doc_sequence_value,
             null code_accounting,
             SUBSTR(xz.aqpa470rubro, 1, 2) || '0' ||
             SUBSTR(xz.aqpa470rubro, 3, length(xz.aqpa470rubro)) || '00000' ledger_account,
             null gl_date,
             'CDP de Referencia '||to_char(to_date(xz.aqpa470fdref, 'DD-MM-YY'), 'DD-MM-RRRR')||' '||xz.aqpa470tcomp||' '||xz.aqpa470sdref||'-'||xz.aqpa470ndref gl_description,
             '0.00' accounted_dr,
             '0.00' accounted_cr,
             '1' line_status,
             null annotation_date,
             null je_header_id,
             null je_line_num,
             null org_id,
             null period_name,
             NULL ledger_id,
             null created_by,
             null creation_date,
             null last_update_by,
             null last_update_date,
             null last_update_login,
             null request_id,
             null additional_field01,
             null line_type,
             null journal_type,
             null doc_sequence_value_aux,
             null doc_sequence_line,
             null invoice_line_number,
             null ae_header_id,
             null ae_line_num,
             NULL centro_costo,
             xz.aqpa470mone currency_code,
             null tipo_doc_prove,
             null numero_entidad_emisor,
             null  doc_sunat, --add modify 231017 pdiaz
             null serie_documento,
             null  numero_documento,
             null effective_date,
             null due_date,
             null glosa_referencial,
             null structured_field,
             null leasing_id,
             to_char(xz.aqpa470femi, 'dd/mm/yyyy') fecha_emision,
             null je_source,
             /*decode(length(a.je_source), 2, 'BT', 'EBS')*/
             'FE' origen
             ,TRIM(xz.aqpa470tcomf||'-'||xz.aqpa470seri||'-'||xz.aqpa470num||'-'||xz.aqpa470tdocr||'-'||xz.aqpa470nruc)  as attribute3_h,
             'M000000001' as attribute3_l,
             
             ----FE             
             xz.aqpa470tdocr,
             xz.AQPA470NRUC,
             LPAD(xz.AQPA470TCOMF, 2, '0') AQPA470TCOMF,
             xz.AQPA470SERI,
             xz.AQPA470NUM
             
             --ADD11032019 PDZ JOGZAR
             
              ,
               TRIM(to_char((CASE
                 WHEN xz.AQPA470TCOMF = '07' THEN
                  DECODE(xz.AQPA470MONE, 'PEN', -xz.aqpa470impt,-xz.aqpa470impt * xz.aqpa470tcam)
                  ELSE 
                  DECODE(xz.AQPA470MONE, 'PEN', xz.aqpa470impt,xz.aqpa470impt * xz.aqpa470tcam) 
               END), '9999999999999990.99')) import_tot_excep_sunat--38
              ,
              
              (select p.cuoebs
              from JC.jc_aqpa470_per p
              where p.aqpa470fdref = xz.aqpa470fdref 
                and p.aqpa470tcomp = xz.aqpa470tcomp 
                and p.aqpa470sdref = xz.aqpa470sdref
                and p.aqpa470ndref = xz.aqpa470ndref 
                and p.AQPA470FLAG = 'S' 
                and p.cuoebs is not null            
               ) cuoebs --39
              
             ,
              
              (select p.relebs
              from JC.jc_aqpa470_per p
              where p.aqpa470fdref = xz.aqpa470fdref 
                and p.aqpa470tcomp = xz.aqpa470tcomp 
                and p.aqpa470sdref = xz.aqpa470sdref
                and p.aqpa470ndref = xz.aqpa470ndref 
                and p.AQPA470FLAG = 'S'       
                and p.relebs is not null       
               ) relebs--40 
              
              ,
              
              (select p.description
              from JC.jc_aqpa470_per p
              where p.aqpa470fdref = xz.aqpa470fdref 
                and p.aqpa470tcomp = xz.aqpa470tcomp 
                and p.aqpa470sdref = xz.aqpa470sdref
                and p.aqpa470ndref = xz.aqpa470ndref 
                and p.AQPA470FLAG = 'S' 
                and p.description is not null            
               ) description --41  
               
      
        from  JC.jc_aqpa470_per xz
       where to_char(xz.AQPA470FEMI, 'MON-YY') = vg_period  
       and xz.flag_rv = 'Y'
       and xz.aqpa470flag = 'S'
                     
      --FE
         
         
      --       
      ----test
      --and rownum <= 1000
      --order by a.doc_sequence_value;
       order by 45/*h.attribute3*/ asc, 46/*l.attribute3*/ asc;
    -- FIN, LUIS JARA, 02/05/2018
  
    vc_title_file varchar2(3000);
    vc_title_line varchar2(4000);
    vc_sep        varchar2(1);
    vv_name       varchar2(200);
    --vd_comparar      date;
    vd_compara       date;
    vv_cuo_b         varchar2(200);
    vv_correlativo_b varchar2(200);
    vc_cuo_periodo   varchar2(15); /*CVEAS*/
    v_cuo_old        varchar2(80);
    vn_secuencial    number;
    v_cuo_old_n      varchar2(80);
    vn_secuencial_n  number;
  
  begin
  
    /*INICIO----CVEAS*/
    select c.period_name
      into vc_cuo_periodo
      from jc.jc_ple_nuevo_cuo_corr c;
  
    /*FIN----CVEAS*/
  
    vd_comparar := to_date(vc_cuo_periodo, 'MON-YY') /*to_date('ENE-18','MON-YY')*/
     ; /*CVEAS*/
    vd_compara  := to_date(vg_period, 'MON-YY');
  
    vv_name := pv_name || '_' || pv_origen;
  
    vc_sep        := '|';
    vc_title_file := 'Periodo' ||
                    --<I>PLE-v4.0-30.04.2014-CJulcapoma
                     vc_sep || 'Codigo Unico de la Operacion (CUO)' ||
                    --vc_sep || 'Numero correlativo del asiento o Codigo Unico de la operacion en el Libro Diario' ||
                     vc_sep || 'Numero correlativo del asiento contable' ||
                    --<F>PLE-v4.0-30.04.2014-CJulcapoma
                    --vc_sep || 'Codigo del Plan de Cuentas utilizado por el deudor tributario' ||--GCM
                     vc_sep || 'Codigo de la cuenta contable asociada' ||
                    --<I>SUNAT-PLEV5-25.09.2015-GCorvera
                     vc_sep || 'Codigo de Unidad de Operacion' || vc_sep ||
                     'Centro de Costos' || vc_sep ||
                     'Tipo de Moneda de origen' || vc_sep ||
                     'Tipo de Documento de identidad de emisor' || vc_sep ||
                     'Numero de documento de identidad del emisor' ||
                     vc_sep ||
                     'Tipo de Comprobante de Pago o documento asociado' ||
                     vc_sep || 'Numero de Serie de comprobante de Pago' ||
                     vc_sep ||
                     'Numero del comprobante de Pago o documento asociado' ||
                     vc_sep || 'Fecha Contable' || vc_sep ||
                     'Fecha de Vencimiento' ||
                    --<F>SUNAT-PLEV5-25.09.2015-GCorvera
                     vc_sep || 'Fecha de la operacion' || vc_sep ||
                     'Glosa o descripcion de la naturaleza de la operacion registrada' ||
                     vc_sep || 'Glosa referencial' || --SUNAT-PLEV5-25.09.2015-GCorvera
                     vc_sep || 'Movimientos del Debe' || vc_sep ||
                     'Movimientos del Haber' ||
                    --<I>SUNAT-PLEV5-25.09.2015-GCorvera
                    /*--<I>PLE-v4.0-30.04.2014-CJulcapoma vc_sep || 'Numero correlativo utilizado en el Registro de Ventas e Ingresos' ||
                    --<F>PLE-v4.0-30.04.2014-CJulcapoma*/
                    --<F>SUNAT-PLEV5-25.09.2015-GCorvera
                     vc_sep || 'Dato Estructurado' || --SUNAT-PLEV5-25.09.2015-GCorvera
                     vc_sep || 'Indica el estado de la operacion  ' || --21
                     vc_sep || 'Campos de libre utilizacion'
                    --<I>IBK-LEM_LEASING-161215-EMauricio
                     || vc_sep || 'Llave Leasing' || vc_sep || 'Origen'
                     
                     --ADD110319 PDZ JOGZAR
                     || vc_sep || 'Importe total del comprobante de pago - Excepción SUNAT'
                     || vc_sep || 'CUO y Correlativo EBS del comprobante de pago que se modifica'
                     || vc_sep || 'Correlativo EBS del comprobante de pago que se modifica'
                     || vc_sep || 'Asiento BT del comprobante de pago que se modifica (Fecha-Cia-Sucursal-Modulo-Transaccion-Relacion)'
                     --
                     
   --<F>IBK-LEM_LEASING-161215-EMauricio
     ;
    --**25/04/2018
    sp_write_log(pv_ruta, pv_name, vc_title_file);
    --**25/04/2018
    fnd_file.put_line(fnd_file.output, vc_title_file);
    --fnd_file.put_line(fnd_file.log,vc_title_file);
    --   SP_WRITE_LOG(pv_ruta, vv_name, vc_title_file);
  
    /* for rc_lin in table_temp loop
    
      if \*vd_compara*\
       to_date(rc_lin.period_name, 'MON-YY') < vd_comparar then
      
        if rc_lin.doc_sequence_value = nvl(v_cuo_old, '0') then
          vn_secuencial := vn_secuencial + 1;
        else
          vn_secuencial := 1;
        end if;
        v_cuo_old := rc_lin.doc_sequence_value;
      
        vc_title_line := rc_lin.period || vc_sep || --1
                         rc_lin.doc_sequence_value || vc_sep || --2
                         rc_lin.doc_sequence_line || vc_sep || --3      
                         rc_lin.ledger_account || vc_sep || --4
                         rc_lin.ledger_id || vc_sep || --5
                         rc_lin.centro_costo || vc_sep || --6
                         rc_lin.currency_code || vc_sep || --7
                         rc_lin.tipo_doc_prove || vc_sep || --8
                         rc_lin.numero_entidad_emisor || vc_sep || --9
                         rc_lin.doc_sunat || vc_sep || --10
                         rc_lin.serie_documento || vc_sep || --11
                         rc_lin.numero_documento || vc_sep || --12
                         rc_lin.effective_date || vc_sep || --13
                         rc_lin.due_date || vc_sep || --14
                         rc_lin.fecha_emision || vc_sep || --15
                         rc_lin.gl_description || vc_sep || --16
                         rc_lin.glosa_referencial || vc_sep || --17 --SUNAT-PLEV5-25.09.2015-GCorvera
                         rc_lin.accounted_dr || vc_sep || --18
                         rc_lin.accounted_cr || vc_sep || --19
                         rc_lin.structured_field || vc_sep || --20 --SUNAT-PLEV5-25.09.2015-GCorvera
                         rc_lin.line_status || vc_sep || --21
                         rc_lin.additional_field01 || vc_sep || --22
                         rc_lin.leasing_id || vc_sep || --23
                         rc_lin.origen;
    
        --**25/04/2018
        sp_write_log_add(pv_ruta, pv_name, vc_title_line);
        --**25/04/2018
      
        fnd_file.put_line(fnd_file.output, vc_title_line);
        --  SP_WRITE_LOG_ADD(pv_ruta, vv_name, vc_title_line);
                         
      
      \*else
        select gjh.attribute3,
               rpad(rc_lin.doc_sequence_line, 1) || gjl.attribute3
          into vv_cuo_b, vv_correlativo_b
          from gl.gl_je_lines gjl, gl.gl_je_headers gjh
         where gjl.je_header_id = gjh.je_header_id
           and gjl.je_line_num = rc_lin.je_line_num
           and gjh.je_header_id = rc_lin.je_header_id;
      
        vc_title_line := rc_lin.period || vc_sep || --1
                         vv_cuo_b || vc_sep || --2
                         vv_correlativo_b || vc_sep || --3      
                         rc_lin.ledger_account || vc_sep || --4
                         rc_lin.ledger_id || vc_sep || --5
                         rc_lin.centro_costo || vc_sep || --6
                         rc_lin.currency_code || vc_sep || --7
                         rc_lin.tipo_doc_prove || vc_sep || --8
                         rc_lin.numero_entidad_emisor || vc_sep || --9
                         rc_lin.doc_sunat || vc_sep || --10
                         rc_lin.serie_documento || vc_sep || --11
                         rc_lin.numero_documento || vc_sep || --12
                         rc_lin.effective_date || vc_sep || --13
                         rc_lin.due_date || vc_sep || --14
                         rc_lin.fecha_emision || vc_sep || --15
                         rc_lin.gl_description || vc_sep || --16
                         rc_lin.glosa_referencial || vc_sep || --17 --SUNAT-PLEV5-25.09.2015-GCorvera
                         rc_lin.accounted_dr || vc_sep || --18
                         rc_lin.accounted_cr || vc_sep || --19
                         rc_lin.structured_field || vc_sep || --20 --SUNAT-PLEV5-25.09.2015-GCorvera
                         rc_lin.line_status || vc_sep || --21
                         rc_lin.additional_field01 || vc_sep || --22
                         rc_lin.leasing_id || vc_sep || --23
                         rc_lin.origen;*\
      end if;
      
    end loop;*/
  
    -- INI, LUIS JARA, 02/05/2018
    for rc_lin in table_temp_nuevo loop
    
      if rc_lin.attribute3_h || rc_lin.attribute3_l =
         nvl(v_cuo_old_n, 'SIN_VALOR') then
        vn_secuencial_n := vn_secuencial_n + 1;
      else
        vn_secuencial_n := 1;
      end if;
      v_cuo_old_n := rc_lin.attribute3_h || rc_lin.attribute3_l;
    
      /*select gjh.attribute3,
            rpad(rc_lin.doc_sequence_line, 1) || gjl.attribute3
       into vv_cuo_b, vv_correlativo_b
       from gl.gl_je_lines gjl, gl.gl_je_headers gjh
      where gjl.je_header_id = gjh.je_header_id
        and gjl.je_line_num = rc_lin.je_line_num
        and gjh.je_header_id = rc_lin.je_header_id;*/
    
      vc_title_line := rc_lin.period || vc_sep || --1
                      /*vv_cuo_b*/
                       rc_lin.attribute3_h || '-' ||lpad(vn_secuencial_n, 5, '0') || vc_sep || --2
                      /*vv_correlativo_b*/
                       rpad(rc_lin.doc_sequence_line, 1) || rc_lin.attribute3_l || vc_sep || --3      
                       rc_lin.ledger_account || vc_sep || --4
                       rc_lin.ledger_id || vc_sep || --5
                       rc_lin.centro_costo || vc_sep || --6
                       rc_lin.currency_code || vc_sep || --7
                       rc_lin.AQPA470TDOCR /*tipo_doc_prove*/
                       || vc_sep || --8
                       rc_lin.AQPA470NRUC /*numero_entidad_emisor*/
                       || vc_sep || --9
                       rc_lin.AQPA470TCOMF /*doc_sunat*/
                       || vc_sep || --10
                       rc_lin.AQPA470SERI /*serie_documento*/
                       || vc_sep || --11
                       rc_lin.AQPA470NUM /*numero_documento*/
                       || vc_sep || --12
                       rc_lin.effective_date || vc_sep || --13
                       rc_lin.due_date || vc_sep || --14
                       rc_lin.fecha_emision || vc_sep || --15
                       rc_lin.gl_description || vc_sep || --16
                       rc_lin.glosa_referencial || vc_sep || --17 --SUNAT-PLEV5-25.09.2015-GCorvera
                       rc_lin.accounted_dr || vc_sep || --18
                       rc_lin.accounted_cr || vc_sep || --19
                       rc_lin.structured_field || vc_sep || --20 --SUNAT-PLEV5-25.09.2015-GCorvera
                       rc_lin.line_status || vc_sep || --21
                       rc_lin.additional_field01 || vc_sep || --22
                       rc_lin.leasing_id || vc_sep || --23
                       rc_lin.origen 
                       --add110319 jogzar pdz
                       || vc_sep || --38
                       rc_lin.import_tot_excep_sunat
                       || vc_sep || --39
                       rc_lin.cuoebs
                       || vc_sep || --40
                       rc_lin.relebs
                       || vc_sep || --41
                       rc_lin.description;
    
      --**25/04/2018
      sp_write_log_add(pv_ruta, pv_name, vc_title_line);
      --**25/04/2018
    
      fnd_file.put_line(fnd_file.output, vc_title_line);
      --  SP_WRITE_LOG_ADD(pv_ruta, vv_name, vc_title_line);
    
    end loop;
    -- FIN, LUIS JARA, 02/05/2018    
  
  end;

  procedure jc_upd_description_line is
    
  cont number :=0;
  
    cursor c_update is
    
      SELECT /*+ NO_CPU_COSTING */ TRIM(xal.description) description, 
       tgp.je_header_id, 
       tgp.je_line_num 
  FROM xxbol.ts_gl_ple_group tgp 
       INNER JOIN apps.gl_je_lines gjl 
          ON tgp.fecha_contable = gjl.effective_date 
             AND tgp.je_header_id = gjl.je_header_id 
             AND tgp.je_line_num = gjl.je_line_num 
       INNER JOIN apps.gl_import_references gir 
          ON gir.je_header_id = gjl.je_header_id 
             AND gir.je_line_num = gjl.je_line_num 
       INNER JOIN xla.xla_ae_lines xal 
          ON xal.gl_sl_link_id = gir.gl_sl_link_id 
             AND xal.gl_sl_link_table = gir.gl_sl_link_table 
       INNER JOIN xla.xla_ae_line_acs xala 
          ON xala.ae_header_id = xal.ae_header_id 
             AND xala.ae_line_num = xal.ae_line_num 
 WHERE 1 = 1 
   AND tgp.period_name = vg_period
   AND tgp.ledger_id = 2022 
   AND xal.application_id = NVL(20025, xal.application_id)
      ;
  begin
    for c in c_update loop
      update ts_gl_lines_ple_tmp
      
         set description_line = c.description
      
       where description_line is null
         and je_header_id = c.je_header_id
         and je_line_num = c.je_line_num;
     cont:=cont+1;    
    end loop;
    COMMIT;
    
    xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('jc_upd_description_line registro updates :'||cont);
  
  end;

   procedure jc_insert_ebs_fe_todos is
  
  begin
  
    execute immediate 'truncate table JC_EBS_FE_TODOS_ALL_TMP';
  
    INSERT /*+ append nologging parallel */
    INTO JC_EBS_FE_TODOS_ALL_TMP
      (period,
       doc_sequence_value,
       code_accounting,
       ledger_account,
       gl_date,
       gl_description,
       accounted_dr,
       accounted_cr,
       line_status,
       annotation_date,
       je_header_id,
       je_line_num,
       org_id,
       period_name,
       ledger_id,
       created_by,
       creation_date,
       last_update_by,
       last_update_date,
       last_update_login,
       request_id,
       additional_field01,
       line_type,
       journal_type,
       doc_sequence_value_aux,
       doc_sequence_line,
       invoice_line_number,
       ae_header_id,
       ae_line_num,
       centro_costo,
       currency_code,
       tipo_doc_prove,
       numero_entidad_emisor,
       doc_sunat,
       serie_documento,
       numero_documento,
       effective_date,
       due_date,
       glosa_referencial,
       structured_field,
       leasing_id,
       fecha_emision,
       je_source,
       origen,
       attribute3_l,
       attribute3_h,
       IMPORT_TOT_EXCEP_SUNAT,
       CUOEBS,
       RELEBS,
       DESCRIPTION)
    
      select /*+parallel (a,10)*/ a.period,
             a.doc_sequence_value,
             a.code_accounting,
             a.ledger_account,
             a.gl_date,
             translate(a.gl_description, '|/\', ' ') gl_description,
             a.accounted_dr,
             a.accounted_cr,
             a.line_status,
             a.annotation_date,
             a.je_header_id,
             a.je_line_num,
             a.org_id,
             a.period_name,
             a.ledger_id,
             a.created_by,
             a.creation_date,
             a.last_update_by,
             a.last_update_date,
             a.last_update_login,
             a.request_id,
             translate(a.additional_field01, '|/\', ' ') additional_field01,
             a.line_type,
             a.journal_type,
             a.doc_sequence_value_aux,
             a.doc_sequence_line,
             a.invoice_line_number,
             a.ae_header_id,
             a.ae_line_num,
             a.centro_costo,
             a.currency_code,
             a.tipo_doc_prove,
             a.numero_entidad_emisor,
             decode(a.doc_sunat, '', '00', 'NA', '00', a.doc_sunat) doc_sunat, --add modify 231017 pdiaz
             
             CASE WHEN a.doc_sunat = 91 AND a.serie_documento IS NULL THEN
                get_nodom_doc(a.invoice_id,'SERIE')
             ELSE
                a.serie_documento
             END serie_documento,
             
              CASE WHEN a.doc_sunat = 91 AND a.numero_documento IS NULL THEN
                get_nodom_doc(a.invoice_id,'NUMERO')
             ELSE
               decode(a.numero_documento, '', '00', a.numero_documento) 
               END numero_documento,
               
             a.effective_date,
             a.due_date,
             translate(substr(a.glosa_referencial, 1, 200), '|/\', ' ') glosa_referencial,
             a.structured_field,
			 a.leasing_id,
             a.fecha_emision,
             a.je_source,
             decode(length(a.je_source), 2, 'BT', 'EBS') origen,
             
             (select l.attribute3
                from apps.gl_je_lines l
               where l.je_header_id = a.je_header_id
                 and l.je_line_num = a.je_line_num) attribute3_l,
             (select l.attribute3
                from apps.gl_je_headers l
               where l.je_header_id = a.je_header_id) attribute3_h,
               
            null,--38
            null,--39
            null,--40
            null --41  
      
        from ts_gl_lines_ple_tmp a
       where 1 = 1
            
            --FE
         and not exists
      --FE
       (select /*+parallel (xz,10)*/ 1
                from /*operador.*/
                XXBOL.AQPA470 xz  --se comento esquema 05/11/2021 dcastro
               where to_char(xz.AQPA470FEMI, 'MON-YY') = vg_period
                 and to_char(xz.aqpa470con, 'YYYYMMDD') || '-' ||
                     xz.aqpa470pgcod || '-' || xz.aqpa470sucor || '-' ||
                     xz.aqpa470mod || '-' || xz.aqpa470tran || '-' ||
                     xz.aqpa470rel || '-' || xz.aqpa470cord || '-' ||
                     xz.aqpa470subo = a.DESCRIPTION_LINE
                     and xz.AQPA470LEST NOT IN ('M','R') -- NO TRAE LOS DOCUMENTOS ANULADOS
                     
                     )
      
      ---UNIENDO SOLO FACTURACION ELECTRONICA FE            
      union all
      
      select /*+parallel (a,10)*/ a.period,
             a.doc_sequence_value,
             a.code_accounting,
             a.ledger_account,
             a.gl_date,
             translate(a.gl_description, '|/\', ' ') gl_description,
             a.accounted_dr,
             a.accounted_cr,
             a.line_status,
             a.annotation_date,
             a.je_header_id,
             a.je_line_num,
             a.org_id,
             a.period_name,
             a.ledger_id,
             a.created_by,
             a.creation_date,
             a.last_update_by,
             a.last_update_date,
             a.last_update_login,
             a.request_id,
             translate(a.additional_field01, '|/\', ' ') additional_field01,
             a.line_type,
             a.journal_type,
             a.doc_sequence_value_aux,
             a.doc_sequence_line,
             a.invoice_line_number,
             a.ae_header_id,
             a.ae_line_num,
             a.centro_costo,
             a.currency_code,
             aqp.AQPA470TDOCR tipo_doc_prove, --8 FE
             aqp.AQPA470NRUC numero_entidad_emisor, --9 FE
             LPAD(aqp.AQPA470TCOMF, 2, '0') doc_sunat, --10 FE
             aqp.AQPA470SERI serie_documento, --11 FE
             TO_CHAR(aqp.AQPA470NUM) numero_documento, --12 FE
             a.effective_date,
             a.due_date,
             translate(substr(a.glosa_referencial, 1, 200), '|/\', ' ') glosa_referencial,
             'X' structured_field,
             a.leasing_id,
             a.fecha_emision,
             a.je_source,
             'FE' origen,
             
             (select l.attribute3
                from apps.gl_je_lines l
               where l.je_header_id = a.je_header_id
                 and l.je_line_num = a.je_line_num) attribute3_l,
             (select l.attribute3
                from apps.gl_je_headers l
               where l.je_header_id = a.je_header_id) attribute3_h
               
             --ADD11032019 PDZ JOGZAR
             
              ,
              NULL import_tot_excep_sunat--38
              ,
              
              NULL cuoebs --39
              
             ,
              
              NULL relebs--40 
              
              ,
              
              NULL description --41   
      
        from ts_gl_lines_ple_tmp a,
             
             --FE
             (select /*+parallel (xz,10)*/ to_char(xz.aqpa470con, 'YYYYMMDD') || '-' ||
                     xz.aqpa470pgcod || '-' || xz.aqpa470sucor || '-' ||
                     xz.aqpa470mod || '-' || xz.aqpa470tran || '-' ||
                     xz.aqpa470rel || '-' || xz.aqpa470cord || '-' ||
                     xz.aqpa470subo description_line,
                     
                     xz.AQPA470TCOMF,
                     decode(xz.AQPA470SERI,
                            null,
                            xz.AQPA470SERIE,
                            xz.AQPA470SERI) AQPA470SERI,
                     decode(xz.AQPA470NUM,
                            null,
                            xz.AQPA470NRO,
                            xz.AQPA470NRO) AQPA470NUM,
                     xz.AQPA470TDOCR,
                     trim(xz.AQPA470NRUC) AQPA470NRUC 

                     
                from /*operador.*/   --se comento esquema 05/11/2021 dcastro
                XXBOL.AQPA470 xz

               where to_char(xz.AQPA470FEMI, 'MON-YY') = vg_period
               and xz.AQPA470LEST NOT IN ('M','R') -- NO TRAE LOS DOCUMENTOS ANULADOS             
               ) aqp
      --FE
       where 1 = 1
            
         and (decode('BT',
                     'TODOS',
                     'TODOS',
                     decode(length(a.je_source), 2, 'BT', 'EBS')) = 'BT')
            
         and a.DESCRIPTION_LINE = aqp.DESCRIPTION_LINE
         and not exists (select /*+parallel (xz,10)*/ 1 
                         from JC.jc_aqpa470_per xz 
                         where (to_char(xz.aqpa470con, 'YYYYMMDD') || '-' || xz.aqpa470pgcod || '-' || xz.aqpa470sucor || '-' ||
                         xz.aqpa470mod || '-' || xz.aqpa470tran || '-' || xz.aqpa470rel || '-' || xz.aqpa470cord || '-' ||
                         xz.aqpa470subo) = aqp.DESCRIPTION_LINE
                         and  to_char(xz.AQPA470FEMI, 'MON-YY') = vg_period  
                         and xz.flag_rv = 'Y'
                         and xz.aqpa470flag = 'S'
                         )
         
      union all
      
     select /*+parallel (xz,10)*/ to_char(xz.aqpa470femi, 'YYYYMM') || '00' period,
             null doc_sequence_value,
             null code_accounting,
             SUBSTR(xz.aqpa470rubro, 1, 2) || '0' ||
             SUBSTR(xz.aqpa470rubro, 3, length(xz.aqpa470rubro)) || '00000' ledger_account,
             null gl_date,
             'CDP de Referencia '||to_char(to_date(xz.aqpa470fdref, 'DD-MM-YY'), 'DD-MM-RRRR')||' '||xz.aqpa470tcomp||' '||xz.aqpa470sdref||'-'||xz.aqpa470ndref gl_description,
             '0.00' accounted_dr,
             '0.00' accounted_cr,
             '1' line_status,
             null annotation_date,
             null je_header_id,
             null je_line_num,
             null org_id,
             to_char(xz.AQPA470FEMI, 'MON-YY') period_name,
             NULL ledger_id,
             null created_by,
             null creation_date,
             null last_update_by,
             null last_update_date,
             null last_update_login,
             null request_id,
             null additional_field01,
             null line_type,
             null journal_type,
             null doc_sequence_value_aux,
             null doc_sequence_line,
             null invoice_line_number,
             null ae_header_id,
             null ae_line_num,
             NULL centro_costo,
             xz.aqpa470mone currency_code,
             xz.AQPA470TDOCR tipo_doc_prove, --8 FE
             xz.AQPA470NRUC numero_entidad_emisor, --9 FE
             LPAD(xz.AQPA470TCOMF, 2, '0') doc_sunat, --10 FE
             xz.AQPA470SERI serie_documento, --11 FE
             TO_CHAR(xz.AQPA470NUM) numero_documento, --12 FE
             null effective_date,
             null due_date,
             null glosa_referencial,
             'SIN_VALOR' structured_field,
			 null leasing_id,
             to_char(xz.aqpa470femi, 'dd/mm/yyyy') fecha_emision,
             null je_source,
             /*decode(length(a.je_source), 2, 'BT', 'EBS')*/
             'FE' origen,
             
             --110619 modify jogzarpdz 
             'M000000001' as attribute3_l,
              TRIM(xz.aqpa470tcomf||'-'||xz.aqpa470seri||'-'||xz.aqpa470num||'-'||xz.aqpa470tdocr||'-'||xz.aqpa470nruc)  as attribute3_h,
             --
             
             --ADD11032019 PDZ JOGZAR
             
               TRIM(to_char((CASE
                 WHEN xz.AQPA470TCOMF = '07' THEN
                  DECODE(xz.AQPA470MONE, 'PEN', -xz.aqpa470impt,-xz.aqpa470impt * xz.aqpa470tcam)
                  ELSE 
                  DECODE(xz.AQPA470MONE, 'PEN', xz.aqpa470impt,xz.aqpa470impt * xz.aqpa470tcam) 
               END), '9999999999999990.99')) import_tot_excep_sunat--38
              ,
              
              (select p.cuoebs
              from JC.jc_aqpa470_per p
              where p.aqpa470fdref = xz.aqpa470fdref 
                and p.aqpa470tcomp = xz.aqpa470tcomp 
                and p.aqpa470sdref = xz.aqpa470sdref
                and p.aqpa470ndref = xz.aqpa470ndref 
                and p.AQPA470FLAG = 'S' 
                and p.cuoebs is not null            
               ) cuoebs --39
              
             ,
              
              (select p.relebs
              from JC.jc_aqpa470_per p
              where p.aqpa470fdref = xz.aqpa470fdref 
                and p.aqpa470tcomp = xz.aqpa470tcomp 
                and p.aqpa470sdref = xz.aqpa470sdref
                and p.aqpa470ndref = xz.aqpa470ndref 
                and p.AQPA470FLAG = 'S'       
                and p.relebs is not null       
               ) relebs--40 
              
              ,
              
              (select p.description
              from JC.jc_aqpa470_per p
              where p.aqpa470fdref = xz.aqpa470fdref 
                and p.aqpa470tcomp = xz.aqpa470tcomp 
                and p.aqpa470sdref = xz.aqpa470sdref
                and p.aqpa470ndref = xz.aqpa470ndref 
                and p.AQPA470FLAG = 'S' 
                and p.description is not null            
               ) description --41  
               
      
        from  JC.jc_aqpa470_per xz
       where to_char(xz.AQPA470FEMI, 'MON-YY') = vg_period  
       and xz.flag_rv = 'Y'
       and xz.aqpa470flag = 'S';
  
    COMMIT;
  
  end;
  procedure sp_write_log(p_directory in varchar2,
                         p_file_name in varchar2,
                         p_file_txt  in varchar2) as
    l_line varchar2(32767);
    l_done number;
    l_file utl_file.file_type;
  begin
    l_file := utl_file.fopen(p_directory, p_file_name, 'W', 32767);
    /* CHMOD :=777;*/
    -- LOOP
    /* EXIT WHEN l_done = 1;*/
    dbms_output.get_line(l_line, l_done);
    -- if nvl(trim(l_line), 'XX') <> 'XX' THEN*/
    utl_file.put_line(l_file, p_file_txt /*l_line*/); --ESCRIBIENDO ARCHIVO
    -- dbms_output.put_line(l_line);
    --   END IF;
    -- END LOOP;
    --utl_file.fflush(l_file);
    utl_file.fclose(l_file);
  end;

  procedure sp_write_log_add(p_directory in varchar2,
                             p_file_name in varchar2,
                             p_file_txt  in varchar2) as
    l_line varchar2(32767);
    l_done number;
    l_file utl_file.file_type;
  begin
    l_file := utl_file.fopen(p_directory, p_file_name, 'A', 32767);
    -- LOOP
    /* EXIT WHEN l_done = 1;*/
    dbms_output.get_line(l_line, l_done);
    -- if nvl(trim(l_line), 'XX') <> 'XX' THEN*/
    utl_file.put_line(l_file, p_file_txt /*l_line*/); --ESCRIBIENDO ARCHIVO
    -- dbms_output.put_line(l_line);
    --   END IF;
    -- END LOOP;
    --utl_file.fflush(l_file);
    utl_file.fclose(l_file);
  end;
  
  PROCEDURE sp_carga_aqpa470_LD_per(pd_fe_desde IN DATE
                                ,pd_fe_hasta IN DATE) IS
    row_id     ROWID;
    vn_ordinal NUMBER;
    v_counfe   NUMBER;
  BEGIN

    -- corregir
    xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('truncate jc_aqpa470_per');
  
    EXECUTE IMMEDIATE 'truncate table JC.jc_aqpa470_per';
  
    -- corregir
    xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('insert jc_aqpa470_per');
  
    INSERT /*+ append nologging parallel */ INTO JC.jc_aqpa470_per
      (aqpa470serie
      ,aqpa470nro
      ,aqpa470pgcod
      ,aqpa470mod
      ,aqpa470sucor
      ,aqpa470tran
      ,aqpa470rel
      ,aqpa470con
      ,aqpa470cord
      ,aqpa470subo
      ,aqpa470ind
      ,aqpa470rubro
      ,aqpa470ccos
      ,aqpa470femi
      ,aqpa470tcomf
      ,aqpa470seri
      ,aqpa470num
      ,aqpa470tdocr
      ,aqpa470nruc
      ,aqpa470rasoc
      ,aqpa470fdref
      ,aqpa470mtotal
      ,aqpa470mtimp
      ,aqpa470mtinf
      ,aqpa470impt
      ,aqpa470mone
      ,aqpa470tcam
      ,aqpa470tcomp
      ,aqpa470sdref
      ,aqpa470ndref
      ,aqpa470lest
      ,aqpa470csuna
      ,apaq470imdeb
      ,apaq470imhab
      ,aqpa470mbim
      ,aqpa470prvit
      ,aqpa470total
      ,aqpa470vvuig
      ,aqpa470vvun
      ,aqpa470item
      ,aqpa470desc
      ,aqpa470corr,
       AQPA470FLAG)
      
      SELECT /*+parallel (a,10)*/ a.aqpa470serie,
       a.aqpa470nro,
       a.aqpa470pgcod,
       a.aqpa470mod,
       a.aqpa470sucor,
       a.aqpa470tran,
       a.aqpa470rel,
       a.aqpa470con,
       a.aqpa470cord,
       a.aqpa470subo,
       a.aqpa470ind,
       a.aqpa470rubro,
       a.aqpa470ccos,
       a.aqpa470femi,
       a.aqpa470tcomf,
       a.aqpa470seri,
       a.aqpa470num,
       a.aqpa470tdocr,
       a.aqpa470nruc,
       a.aqpa470rasoc,
       a.aqpa470fdref,
       a.aqpa470mtotal,
       a.aqpa470mtimp,
       a.aqpa470mtinf,
       a.aqpa470impt,
       a.aqpa470mone,
       a.aqpa470tcam,
       a.aqpa470tcomp,
       a.aqpa470sdref,
       a.aqpa470ndref,
       a.aqpa470lest,
       a.aqpa470csuna,
       a.apaq470imdeb,
       a.apaq470imhab,
       a.aqpa470mbim,
       a.aqpa470prvit,
       a.aqpa470total,
       a.aqpa470vvuig,
       a.aqpa470vvun,
       a.aqpa470item,
       a.aqpa470desc,
       a.aqpa470corr,
       a.AQPA470FLAG
  FROM /*operador.*/   --se comento esquema 05/11/2021 dcastro
  XXBOL.AQPA470 a
 WHERE aqpa470femi BETWEEN pd_fe_desde AND pd_fe_hasta
 --ADD JC15112022 ESTADO 'X' documentos extornados que no afectan contabilizacion
 and AQPA470LEST NOT IN ('X') 
 --
 --jogzar pdz 080319
     AND NOT EXISTS
 (SELECT  /*+parallel (b,10)*/ 1   
          FROM /*operador.*/XXBOL.AQPA470 b   --se comento esquema 05/11/2021 dcastro
         WHERE aqpa470femi BETWEEN pd_fe_desde AND pd_fe_hasta
           AND b.aqpa470sdref = a.aqpa470serie
           AND b.aqpa470ndref = a.aqpa470nro           
           AND b.AQPA470TCOMF = '07')
           
UNION ALL 

SELECT /*+parallel (a,10)*/ a.aqpa470serie,
       a.aqpa470nro,
       a.aqpa470pgcod,
       a.aqpa470mod,
       a.aqpa470sucor,
       a.aqpa470tran,
       a.aqpa470rel,
       a.aqpa470con,
       a.aqpa470cord,
       a.aqpa470subo,
       a.aqpa470ind,
       a.aqpa470rubro,
       a.aqpa470ccos,
       a.aqpa470femi,
       a.aqpa470tcomf,
       a.aqpa470seri,
       a.aqpa470num,
       a.aqpa470tdocr,
       a.aqpa470nruc,
       a.aqpa470rasoc,
       a.aqpa470fdref,
       a.aqpa470mtotal,
       a.aqpa470mtimp,
       a.aqpa470mtinf,
       a.aqpa470impt,
       a.aqpa470mone,
       a.aqpa470tcam,
       a.aqpa470tcomp,
       a.aqpa470sdref,
       a.aqpa470ndref,
       a.aqpa470lest,
       a.aqpa470csuna,
       a.apaq470imdeb,
       a.apaq470imhab,
       a.aqpa470mbim,
       a.aqpa470prvit,
       a.aqpa470total,
       a.aqpa470vvuig,
       a.aqpa470vvun,
       a.aqpa470item,
       a.aqpa470desc,
       a.aqpa470corr,
       a.AQPA470FLAG
  FROM /*operador.*/XXBOL.AQPA470 a   --se comento esquema 05/11/2021 dcastro
 WHERE 
  --ADD JC15112022 ESTADO 'X' documentos extornados que no afectan contabilizacion
   AQPA470LEST NOT IN ('X') 
  --
 and  EXISTS
 (SELECT  /*+parallel (b,10)*/ 1   
          FROM /*operador.*/XXBOL.AQPA470 b   --se comento esquema 05/11/2021 dcastro
         WHERE aqpa470femi BETWEEN pd_fe_desde AND pd_fe_hasta
           AND b.aqpa470sdref = a.aqpa470serie
           AND b.aqpa470ndref = a.aqpa470nro           
           AND b.AQPA470TCOMF = '07');
 --jogzar pdz 080319
  
    -- corregir
    xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('antes loop10');
  
    FOR r IN (SELECT DISTINCT x.aqpa470serie
                             ,x.aqpa470nro
                             ,x.aqpa470femi /*,
                                                                                                                                                                                                                                  x.aqpa470IMPT*/
                FROM JC.jc_aqpa470_per x) LOOP
      --
      row_id := NULL;
    
      SELECT MIN(ROWID)
        INTO row_id
        FROM JC.jc_aqpa470_per x
       WHERE /*nvl(x.aqpa470IMPT, 999999999999)  = nvl(r.aqpa470IMPT, 999999999999)
                                                                                             and */
       x.aqpa470serie = r.aqpa470serie
       AND x.aqpa470nro = r.aqpa470nro
       AND x.aqpa470femi = r.aqpa470femi
       AND x.aqpa470cord = 10
       AND x.aqpa470subo = 1
       AND x.aqpa470impt IS NOT NULL;
    
      IF (row_id IS NULL) THEN
        SELECT MIN(ROWID)
          INTO row_id
          FROM JC.jc_aqpa470_per x
         WHERE /*nvl(x.aqpa470IMPT, 999999999999)  = nvl(r.aqpa470IMPT, 999999999999)
                                                                                                                           and */
         x.aqpa470serie = r.aqpa470serie
         AND x.aqpa470nro = r.aqpa470nro
         AND x.aqpa470femi = r.aqpa470femi
         AND x.aqpa470cord = 1
         AND x.aqpa470subo = 1
         AND x.aqpa470impt IS NOT NULL;
        --
        IF (row_id IS NULL) THEN
          SELECT MIN(aqpa470cord)
            INTO vn_ordinal
            FROM JC.jc_aqpa470_per x
           WHERE /*nvl(x.aqpa470IMPT, 999999999999)  = nvl(r.aqpa470IMPT, 999999999999)
                                                                                                                                                         and */
           x.aqpa470serie = r.aqpa470serie
           AND x.aqpa470nro = r.aqpa470nro
           AND x.aqpa470femi = r.aqpa470femi
           AND x.aqpa470impt IS NOT NULL;
          SELECT MIN(ROWID)
            INTO row_id
            FROM JC.jc_aqpa470_per x
           WHERE /*nvl(x.aqpa470IMPT, 999999999999)  = nvl(r.aqpa470IMPT, 999999999999)
                                                                                                                                                       and */
           x.aqpa470serie = r.aqpa470serie
           AND x.aqpa470nro = r.aqpa470nro
           AND x.aqpa470femi = r.aqpa470femi
           AND x.aqpa470cord = vn_ordinal
           AND x.aqpa470impt IS NOT NULL;
        END IF;
        --
      END IF;
    
      -- Para caso de importes nulos, en caso no se haya encontrado registros con importe no nulo
      IF (row_id IS NULL) THEN
        --
        SELECT MIN(ROWID)
          INTO row_id
          FROM JC.jc_aqpa470_per x
         WHERE /*nvl(x.aqpa470IMPT, 999999999999)  = nvl(r.aqpa470IMPT, 999999999999)
                                                                                                                           and */
         x.aqpa470serie = r.aqpa470serie
         AND x.aqpa470nro = r.aqpa470nro
         AND x.aqpa470femi = r.aqpa470femi
         AND x.aqpa470cord = 10
         AND x.aqpa470subo = 1
         AND x.aqpa470impt IS NULL;
      
        IF (row_id IS NULL) THEN
          SELECT MIN(ROWID)
            INTO row_id
            FROM JC.jc_aqpa470_per x
           WHERE /*nvl(x.aqpa470IMPT, 999999999999)  = nvl(r.aqpa470IMPT, 999999999999)
                                                                                                                                                         and */
           x.aqpa470serie = r.aqpa470serie
           AND x.aqpa470nro = r.aqpa470nro
           AND x.aqpa470femi = r.aqpa470femi
           AND x.aqpa470cord = 1
           AND x.aqpa470subo = 1
           AND x.aqpa470impt IS NULL;
          --
          IF (row_id IS NULL) THEN
            SELECT MIN(aqpa470cord)
              INTO vn_ordinal
              FROM JC.jc_aqpa470_per x
             WHERE /*nvl(x.aqpa470IMPT, 999999999999)  = nvl(r.aqpa470IMPT, 999999999999)
                                                                                                                                                                                       and */
             x.aqpa470serie = r.aqpa470serie
             AND x.aqpa470nro = r.aqpa470nro
             AND x.aqpa470femi = r.aqpa470femi
             AND x.aqpa470impt IS NULL;
            SELECT MIN(ROWID)
              INTO row_id
              FROM JC.jc_aqpa470_per x
             WHERE /*nvl(x.aqpa470IMPT, 999999999999)  = nvl(r.aqpa470IMPT, 999999999999)
                                                                                                                                                                                     and */
             x.aqpa470serie = r.aqpa470serie
             AND x.aqpa470nro = r.aqpa470nro
             AND x.aqpa470femi = r.aqpa470femi
             AND x.aqpa470cord = vn_ordinal
             AND x.aqpa470impt IS NULL;
          END IF;
          --
        END IF;
        --
      END IF;
      --
      UPDATE JC.jc_aqpa470_per a
         SET a.flag_rv = 'Y'
       WHERE a.rowid = row_id;
      --
    END LOOP;
  
    -- corregir
    xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('fin loop10');
  
    COMMIT;
  
    SELECT COUNT(*)
      INTO v_counfe
      FROM JC.jc_aqpa470_per x
     WHERE x.flag_rv = 'Y';
  
    xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('Cantidad: ' || v_counfe);
  
  END;
  
  PROCEDURE sp_gl_actualizar_cuo_2_fe IS
  
    CURSOR cuos IS
      SELECT (to_char(xz.aqpa470con, 'YYYYMMDD') || '-' || xz.aqpa470pgcod || '-' || xz.aqpa470sucor || '-' ||
             xz.aqpa470mod || '-' || xz.aqpa470tran || '-' || xz.aqpa470rel || '-' || xz.aqpa470cord || '-' ||
             xz.aqpa470subo) c_codcuo
            ,(to_char(xz.aqpa470con, 'YYYYMMDD') || '-' || xz.aqpa470pgcod || '-' || xz.aqpa470sucor || '-' ||
             xz.aqpa470mod || '-' || xz.aqpa470tran || '-' || xz.aqpa470rel) c_descrip
            ,aqpa470serie
            ,aqpa470nro
        FROM JC.jc_aqpa470_per xz
       WHERE xz.flag_rv = 'Y';
  
    lc_cuoebs      VARCHAR(40);
    lc_cuorel      VARCHAR(10);
    lc_description VARCHAR(100);
    vn_cuenta_reg  NUMBER := 0;
  BEGIN
    xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('Entro Procedimiento Actualizar FE');
  
    FOR c IN cuos LOOP
    
      BEGIN
        SELECT nvl(gjh.attribute3
                  ,gjh.je_header_id || '-' || substr(gjh.je_category, 1, 8) || '-' || gjh.period_name || '-' ||
                   gjh.doc_sequence_value) cuo
              ,nvl('M' || gjl.attribute3, 'M' || lpad(gjl.je_line_num, 9, 0)) correl
          INTO lc_cuoebs
              ,lc_cuorel
          FROM gl.gl_je_headers                    gjh
              ,gl.gl_je_lines                      gjl
              ,gl.gl_import_references             gir
              ,xla.xla_ae_lines                    xal
              ,xla.xla_ae_line_acs                 xala
              ,apps.xla_ae_headers                 h
              ,xxbol.ts_xla_cma_int_l_int_hist_all i
              ,xla.xla_events                      xale
              ,xla.xla_transaction_entities        xlat
         WHERE i.description_line = c.c_codcuo
           AND gjl.je_header_id = gjh.je_header_id
           AND gir.je_header_id = gjl.je_header_id
           AND gir.je_line_num = gjl.je_line_num
           AND xal.gl_sl_link_id = gir.gl_sl_link_id
           AND xal.gl_sl_link_table = gir.gl_sl_link_table
           AND xala.ae_header_id = xal.ae_header_id
           AND xala.ae_line_num = xal.ae_line_num
           AND xal.ae_header_id = h.ae_header_id
           AND h.event_id = i.event_id
           AND xal.description = i.description_line || ' '
           AND xal.ledger_id = 2022
           AND xal.ledger_id = gjh.ledger_id
           AND h.application_id = xale.application_id
           AND h.event_id = xale.event_id
           AND xale.application_id = xlat.application_id
           AND xale.entity_id = xlat.entity_id;
      
        /*  pr_record_log('lc_cuoebs :' || lc_cuoebs || '-' ||
        'lc_cuorel :' || lc_cuorel);*/
      
        UPDATE JC.jc_aqpa470_per g
           SET g.cuoebs      = lc_cuoebs
              ,g.relebs      = lc_cuorel
              ,g.description = c.c_descrip
         WHERE g.aqpa470serie = c.aqpa470serie
           AND g.aqpa470nro = c.aqpa470nro
           AND g.flag_rv = 'Y';
      
        COMMIT;
        vn_cuenta_reg := vn_cuenta_reg + 1;
        IF (MOD(vn_cuenta_reg, 1000) = 0) THEN
          -- corregir
          xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log(' FE van ' || vn_cuenta_reg);
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log(' FE van ' || vn_cuenta_reg || ' ERROR : ' || SQLERRM);
      END;
    
    END LOOP;
    
    
    
  
  END;

  
  procedure jc_tabla_temp3_nuevo_final(pv_origen varchar2,
                                 pv_name   varchar2,
                                 pv_ruta   varchar2) is
  
    -- INI, LUIS JARA, 02/05/2018
    vd_comparar     date;
    v_cuo_old_n     varchar2(80);
    vn_secuencial_n number;
  
    cursor c_stry(cn_period varchar2) is
      select /*+parallel (a,10)*/
       period,
       doc_sequence_value,
       code_accounting,
       ledger_account,
       gl_date,
       gl_description,
       accounted_dr,
       accounted_cr,
       line_status,
       annotation_date,
       je_header_id,
       je_line_num,
       org_id,
       period_name,
       ledger_id,
       created_by,
       creation_date,
       last_update_by,
       last_update_date,
       last_update_login,
       request_id,
       additional_field01,
       line_type,
       journal_type,
       doc_sequence_value_aux,
       doc_sequence_line,
       invoice_line_number,
       ae_header_id,
       ae_line_num,
       centro_costo,
       currency_code,
       tipo_doc_prove,
       numero_entidad_emisor,
       doc_sunat,
       serie_documento,
       numero_documento,
       effective_date,
       due_date,
       glosa_referencial,
       structured_field,
       leasing_id,
       fecha_emision,
       je_source,
       origen,
       attribute3_l,
       attribute3_h,
       IMPORT_TOT_EXCEP_SUNAT,
       CUOEBS,
       RELEBS,
       DESCRIPTION
      
        from JC_EBS_FE_TODOS_ALL_TMP a 
      
      /* where\* rownum < 999999
            
         and *\ a.PERIOD_NAME = cn_period*/
      
       order by a.ATTRIBUTE3_H asc, a.ATTRIBUTE3_L asc;
  
    -- FIN, LUIS JARA, 02/05/2018
  
    vc_title_file varchar2(3000);
    vc_title_line varchar2(4000);
    vc_sep        varchar2(1);
    vv_name       varchar2(200);
    --vd_comparar      date;
    vd_compara       date;
    vv_cuo_b         varchar2(200);
    vv_correlativo_b varchar2(200);
    vc_cuo_periodo   varchar2(15); /*CVEAS*/
    v_cuo_old        varchar2(80);
    vn_secuencial    number;
  
    v_strucuture_field varchar2(500);
  
    ---bulk collect
    TYPE stry_type IS TABLE OF c_stry%ROWTYPE INDEX BY PLS_INTEGER;
    vt_stry      stry_type;
    rc_lin       c_stry%ROWTYPE;
    vn_bulk_cant NUMBER := 1000;
    i number :=0;
  
  begin
    
 
    /*INICIO----CVEAS*/
    select c.period_name
      into vc_cuo_periodo
      from jc.jc_ple_nuevo_cuo_corr c;
  
    /*FIN----CVEAS*/
  
    vd_comparar := to_date(vc_cuo_periodo, 'MON-YY') /*to_date('ENE-18','MON-YY')*/
     ; /*CVEAS*/
    vd_compara  := to_date(vg_period, 'MON-YY');
    vv_name     := pv_name || '_' || pv_origen;
  
    vc_sep        := '|';
    vc_title_file := 'Periodo' ||
                    --<I>PLE-v4.0-30.04.2014-CJulcapoma
                     vc_sep || 'Codigo Unico de la Operacion (CUO)' ||
                    --vc_sep || 'Numero correlativo del asiento o Codigo Unico de la operacion en el Libro Diario' ||
                     vc_sep || 'Numero correlativo del asiento contable' ||
                    --<F>PLE-v4.0-30.04.2014-CJulcapoma
                    --vc_sep || 'Codigo del Plan de Cuentas utilizado por el deudor tributario' ||--GCM
                     vc_sep || 'Codigo de la cuenta contable asociada' ||
                    --<I>SUNAT-PLEV5-25.09.2015-GCorvera
                     vc_sep || 'Codigo de Unidad de Operacion' || vc_sep ||
                     'Centro de Costos' || vc_sep ||
                     'Tipo de Moneda de origen' || vc_sep ||
                     'Tipo de Documento de identidad de emisor' || vc_sep ||
                     'Numero de documento de identidad del emisor' ||
                     vc_sep ||
                     'Tipo de Comprobante de Pago o documento asociado' ||
                     vc_sep || 'Numero de Serie de comprobante de Pago' ||
                     vc_sep ||
                     'Numero del comprobante de Pago o documento asociado' ||
                     vc_sep || 'Fecha Contable' || vc_sep ||
                     'Fecha de Vencimiento' ||
                    --<F>SUNAT-PLEV5-25.09.2015-GCorvera
                     vc_sep || 'Fecha de la operacion' || vc_sep ||
                     'Glosa o descripcion de la naturaleza de la operacion registrada' ||
                     vc_sep || 'Glosa referencial' || --SUNAT-PLEV5-25.09.2015-GCorvera
                     vc_sep || 'Movimientos del Debe' || vc_sep ||
                     'Movimientos del Haber' ||
                    --<I>SUNAT-PLEV5-25.09.2015-GCorvera
                    /*--<I>PLE-v4.0-30.04.2014-CJulcapoma
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    vc_sep || 'Numero correlativo utilizado en el Registro de Ventas e Ingresos' ||
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    vc_sep || 'Numero correlativo utilizado en el Registro de Compras' ||
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    vc_sep || 'Numero correlativo utilizado en el Registro de Consignaciones' ||
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    --<F>PLE-v4.0-30.04.2014-CJulcapoma*/
                    --<F>SUNAT-PLEV5-25.09.2015-GCorvera
                     vc_sep || 'Dato Estructurado' || --SUNAT-PLEV5-25.09.2015-GCorvera
                     vc_sep || 'Indica el estado de la operacion  ' || --21
                     vc_sep || 'Campos de libre utilizacion'
                    --<I>IBK-LEM_LEASING-161215-EMauricio
                     || vc_sep || 'Llave Leasing' || vc_sep || 'Origen'
                     
                     --ADD110319 PDZ JOGZAR
                     || vc_sep || 'Importe total del comprobante de pago - Excepción SUNAT'
                     || vc_sep || 'CUO y Correlativo EBS del comprobante de pago que se modifica'
                     || vc_sep || 'Correlativo EBS del comprobante de pago que se modifica'
                     || vc_sep || 'Asiento BT del comprobante de pago que se modifica (Fecha-Cia-Sucursal-Modulo-Transaccion-Relacion)'


    --<F>IBK-LEM_LEASING-161215-EMauricio
     ;
  
    --**25/04/2018
    sp_write_log(pv_ruta, pv_name, vc_title_file);
    --**25/04/2018
    
    execute immediate 'truncate table JC.JC_EBS_FE_TODOS_ALL_FINAL_TMP';
  
    
    open c_stry(vg_period);
  
    loop
    
      FETCH c_stry BULK COLLECT
      
        INTO vt_stry LIMIT vn_bulk_cant;
    
      for idx in 1 .. vt_stry.count loop
      
        rc_lin := vt_stry(idx);
        
        i:=i+1;
      
        begin
        
          if rc_lin.attribute3_h || rc_lin.attribute3_l =
             nvl(v_cuo_old_n, 'SIN_VALOR') then
            vn_secuencial_n := vn_secuencial_n + 1;
          else
            vn_secuencial_n := 1;
          end if;
          v_cuo_old_n := rc_lin.attribute3_h || rc_lin.attribute3_l;
        
          IF rc_lin.origen = 'FE' AND rc_lin.structured_field <> 'SIN_VALOR' THEN
          
           /* v_strucuture_field := '140100' || '&' || rc_lin.period || '&' ||
                                  rc_lin.attribute3_h \*|| '-' ||lpad(vn_secuencial_n, 5, '0')*\
                                  || '&' ||
                                  rpad(rc_lin.doc_sequence_line, 1) ||
                                  rc_lin.attribute3_l;*/
            v_strucuture_field := lpad(rc_lin.numero_entidad_emisor,11,'0')||lpad(rc_lin.doc_sunat,2,'0') || lpad(rc_lin.serie_documento,4,'0') ||lpad(rc_lin.numero_documento,10,'0');
                                  
          ELSIF rc_lin.origen = 'FE' AND rc_lin.structured_field = 'SIN_VALOR' THEN
          
            v_strucuture_field := '';                        
                                  
          ELSE
          
            v_strucuture_field := rc_lin.structured_field;
          
          END IF;
        
          insert /*+ append nologging parallel */
          into JC.JC_EBS_FE_TODOS_ALL_FINAL_TMP
            (period, 
            cuo, 
            rel, 
            ledger_account, 
            ledger_id, 
            centro_costo, 
            currency_code, 
            tipo_doc_prove, 
            numero_entidad_emisor, 
            doc_sunat, 
            serie_documento, 
            numero_documento, 
            effective_date, 
            due_date, 
            fecha_emision, 
            gl_description, 
            glosa_referencial, 
            accounted_dr, 
            accounted_cr, 
            structured_field, 
            line_status, 
            additional_field01, 
            leasing_id, 
            origen, 
            import_tot_excep_sunat, 
            cuoebs, 
            relebs, 
            description, 
            id  )
          values
            (rc_lin.period ,
                           rc_lin.attribute3_h || '-' || lpad(vn_secuencial_n, 5, '0') ,
                           rpad(rc_lin.doc_sequence_line, 1) || rc_lin.attribute3_l ,      
                           rc_lin.ledger_account ,
                           rc_lin.ledger_id ,
                           rc_lin.centro_costo ,
                           rc_lin.currency_code ,
                           rc_lin.tipo_doc_prove ,
                           rc_lin.numero_entidad_emisor ,
                           rc_lin.doc_sunat ,
                           rc_lin.serie_documento ,
                           rc_lin.numero_documento ,
                           rc_lin.effective_date ,
                           rc_lin.due_date ,
                           rc_lin.fecha_emision ,
                           rc_lin.gl_description ,
                           rc_lin.glosa_referencial ,
                           rc_lin.accounted_dr ,
                           rc_lin.accounted_cr ,
                           v_strucuture_field ,
                           rc_lin.line_status,
                           rc_lin.additional_field01 ,
                           rc_lin.leasing_id ,
                           rc_lin.origen    ,
                           rc_lin.import_tot_excep_sunat,
                           rc_lin.cuoebs  ,
                           rc_lin.relebs  ,
                           rc_lin.description,
                           i
                           
);
       
                             
         
        
        end;
      
      end loop;
    
      EXIT WHEN vt_stry.COUNT < vn_bulk_cant;
    
    end loop;
  
    close c_stry;
    
    commit;
  
  end;
  
  procedure jc_tabla_temp3_nuevo_ejec(pv_origen varchar2,
                                 pv_name   varchar2,
                                 pv_ruta   varchar2) is
  
    
   /*l_jobno pls_integer;  
   
   txt1 varchar2(500);
   txt2 varchar2(500);
   txt3 varchar2(500);
   txt4 varchar2(500);
   txt5 varchar2(500);*/
   
   
  --add jc19072022
  conta     number := 0;
  desde     number := 0;
  hasta     number := 0;
  cantcorte number := 1000000; --1MILLON
  n_mod     number;
  n_flor    number;
  tot_reg   number;
  txt       varchar2(500);
  l_jobno   number;
  
 
 
  begin
  
  /*txt1 := 'begin jc_pq_ca_ple_lib_diario_PR_V3.jc_tabla_temp3_nuevo_txt('||''''||pv_name||''''||','||''''||pv_ruta||''''||','||''''||1||''''||','||''''||10000000||''''||'); end;';
  txt2 := 'begin jc_pq_ca_ple_lib_diario_PR_V3.jc_tabla_temp3_nuevo_txt('||''''||pv_name||''''||','||''''||pv_ruta||''''||','||''''||10000001||''''||','||''''||20000000||''''||'); end;';
  txt3 := 'begin jc_pq_ca_ple_lib_diario_PR_V3.jc_tabla_temp3_nuevo_txt('||''''||pv_name||''''||','||''''||pv_ruta||''''||','||''''||20000001||''''||','||''''||30000000||''''||'); end;';
  txt4 := 'begin jc_pq_ca_ple_lib_diario_PR_V3.jc_tabla_temp3_nuevo_txt('||''''||pv_name||''''||','||''''||pv_ruta||''''||','||''''||30000001||''''||','||''''||40000000||''''||'); end;';
  txt5 := 'begin jc_pq_ca_ple_lib_diario_PR_V3.jc_tabla_temp3_nuevo_txt('||''''||pv_name||''''||','||''''||pv_ruta||''''||','||''''||40000001||''''||','||''''||99000000||''''||'); end;';


  dbms_job.submit(l_jobno,txt1);--1    
  dbms_job.submit(l_jobno,txt2);--2
  dbms_job.run(l_jobno,false); 
  
  dbms_job.submit(l_jobno,txt3);--3    
  dbms_job.submit(l_jobno,txt4);--4
  dbms_job.run(l_jobno,false); 
  
  dbms_job.submit(l_jobno,txt5);--5 
 
 
                                                   
  VG_JOB :=l_jobno;*/
  
  --add jc19072022
  
 select mod(count(0), cantcorte) n_mod,
         floor(count(0) / cantcorte) n_flor,
         count(0)
    into n_mod, n_flor, tot_reg
    from JC.JC_EBS_FE_TODOS_ALL_FINAL_TMP a;
  
  WHILE (conta <= n_flor) LOOP

    hasta := hasta + cantcorte;
    desde := (hasta + 1) - cantcorte;

    txt := 'begin jc_pq_ca_ple_lib_diario_PR_V3.jc_tabla_temp3_nuevo_txt(' || '''' ||
           pv_name || '''' || ',' || '''' || pv_ruta || '''' || ',' || '''' ||
           desde || '''' || ',' || '''' || hasta || '''' || '); end;';
    dbms_job.submit(l_jobno, txt);
    conta := conta + 1;
  END LOOP;
  commit;
  
  
  
  
  end;
  
  procedure jc_tabla_temp3_nuevo_txt(
                                 pv_name   varchar2,
                                 pv_ruta   varchar2,
                                 PV_DESDE  NUMBER,
                                 PV_HASTA  NUMBER ) is
  
    
    vd_comparar     date;
    v_cuo_old_n     varchar2(80);
    vn_secuencial_n number;
  
    cursor c_stry(cn_period varchar2) is
      select /*+parallel (a,10)*/
            period, 
            cuo, 
            rel, 
            ledger_account, 
            ledger_id, 
            centro_costo, 
            currency_code, 
            tipo_doc_prove, 
            numero_entidad_emisor, 
            doc_sunat, 
            serie_documento, 
            numero_documento, 
            effective_date, 
            due_date, 
            fecha_emision, 
            gl_description, 
            glosa_referencial, 
            accounted_dr, 
            accounted_cr, 
            structured_field, 
            line_status, 
            additional_field01, 
            leasing_id, 
            origen, 
            import_tot_excep_sunat, 
            cuoebs, 
            relebs, 
            description, 
            id                  
        from JC.JC_EBS_FE_TODOS_ALL_FINAL_TMP a
        
        WHERE ID >=  PV_DESDE AND ID <= PV_HASTA
         ;
  
    -- FIN, LUIS JARA, 02/05/2018
  
    vc_title_file varchar2(3000);
    vc_title_line varchar2(4000);
    vc_sep        varchar2(1);
    vv_name       varchar2(200);
    
    vd_compara       date;
    vv_cuo_b         varchar2(200);
    vv_correlativo_b varchar2(200);
    vc_cuo_periodo   varchar2(15);  
    v_cuo_old        varchar2(80);
    vn_secuencial    number;
  
    v_strucuture_field varchar2(500);
  
    ---bulk collect
    TYPE stry_type IS TABLE OF c_stry%ROWTYPE INDEX BY PLS_INTEGER;
    vt_stry      stry_type;
    rc_lin       c_stry%ROWTYPE;
    vn_bulk_cant NUMBER := 1000;
  
  begin
  
  vc_sep        := '|';
  
  xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log(' ENTRO jc_tabla_temp3_nuevo_txt1 ');
  
    open c_stry(vg_period);
  
    loop
    
      FETCH c_stry BULK COLLECT
      
        INTO vt_stry LIMIT vn_bulk_cant;
    
      for idx in 1 .. vt_stry.count loop
      
        rc_lin := vt_stry(idx);
      
        begin
        
           
        
          vc_title_line := rc_lin.period || vc_sep || --1
                           rc_lin.cuo || vc_sep || --2
                           rc_lin.rel || vc_sep || --3      
                           rc_lin.ledger_account || vc_sep || --4
                           rc_lin.ledger_id || vc_sep || --5
                           rc_lin.centro_costo || vc_sep || --6
                           rc_lin.currency_code || vc_sep || --7
                           rc_lin.tipo_doc_prove || vc_sep || --8
                           rc_lin.numero_entidad_emisor || vc_sep || --9
                           rc_lin.doc_sunat || vc_sep || --10
                           rc_lin.serie_documento || vc_sep || --11
                           rc_lin.numero_documento || vc_sep || --12
                           rc_lin.effective_date || vc_sep || --13
                           rc_lin.due_date || vc_sep || --14
                           rc_lin.fecha_emision || vc_sep || --15
                           rc_lin.gl_description || vc_sep || --16
                           rc_lin.glosa_referencial || vc_sep || --17 --SUNAT-PLEV5-25.09.2015-GCorvera
                           rc_lin.accounted_dr || vc_sep || --18
                           rc_lin.accounted_cr || vc_sep || --19
                           rc_lin.structured_field || vc_sep || --20 --SUNAT-PLEV5-25.09.2015-GCorvera
                           rc_lin.line_status || vc_sep /*|| --21
                           --JC DESABILITADO 18072022
                           rc_lin.additional_field01 || vc_sep || --22
                           rc_lin.leasing_id || vc_sep || --23
                           rc_lin.origen    || vc_sep || --38
                           rc_lin.import_tot_excep_sunat|| vc_sep || --39
                           rc_lin.cuoebs  || vc_sep || --40
                           rc_lin.relebs  || vc_sep || --41
                           rc_lin.description*/ 
                           
                           /*|| vc_sep || rc_lin.ID*/
                           --
                           ;
        
          
          sp_write_log_add(pv_ruta, pv_name, vc_title_line);
           
        
        end;
      
      end loop;
    
      EXIT WHEN vt_stry.COUNT < vn_bulk_cant;
    
    end loop;
  
    close c_stry;
  
  end;
  
  
  procedure jc_tabla_temp3_nuevo_while is
  
    
    
   v_job_id number:=99;
   
  begin
    
   
  --xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('VG_JOB : '|| VG_JOB);
  
  
  WHILE (v_job_id <>  0) LOOP 
  select COUNT(0)
  into v_job_id
  from ALL_JOBS  
  --where job = VG_JOB;
  where what like '%jc_pq_ca_ple_lib_diario_PR_V3%';  
  END LOOP;
    
  end;
  
  
   PROCEDURE sp_insert_JC_AQPA470_flag_rv is
    row_id     ROWID;
    vn_ordinal NUMBER;
    v_counfe   NUMBER;
  BEGIN

    -- corregir
    xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('truncate jc.jc_aqpa470_per_flag_rv');
  
    EXECUTE IMMEDIATE 'truncate table jc.jc_aqpa470_per_flag_rv';
  
    -- corregir
    xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('insert jc_aqpa470_per_flag_rv');
  
    INSERT /*+ append nologging parallel */ INTO jc.jc_aqpa470_per_flag_rv
      (description_line,AQPA470SERIE,AQPA470NRO,c_descrip)
      
        SELECT  /*+parallel (xz,10)*/ (to_char(xz.aqpa470con, 'YYYYMMDD') || '-' || xz.aqpa470pgcod || '-' ||
               xz.aqpa470sucor || '-' || xz.aqpa470mod || '-' ||
               xz.aqpa470tran || '-' || xz.aqpa470rel || '-' ||
               xz.aqpa470cord || '-' || xz.aqpa470subo) description_line,
               xz.AQPA470SERIE,
               xz.AQPA470NRO,
               (to_char(xz.aqpa470con, 'YYYYMMDD') || '-' || xz.aqpa470pgcod || '-' || xz.aqpa470sucor || '-' ||
               xz.aqpa470mod || '-' || xz.aqpa470tran || '-' || xz.aqpa470rel) c_descrip
          FROM jc.jc_aqpa470_per xz
         where xz.flag_rv = 'Y';
         
     commit;    
  
  END;
  
  procedure sp_insert_hist_all is
  CURSOR reg IS
    select /*+ parallel(auto) */
     a.fecha_registro,
     a.asiento_id,
     a.line_number,
     a.description_line,
     a.event_id,
     a.description_line || ' ' description_line_,     
     XZ.AQPA470SERIE,
     XZ.AQPA470NRO,
     XZ.C_DESCRIP,
     a.segment3
      from xxbol.ts_xla_cma_int_l_int_hist_all a, jc.jc_aqpa470_per_flag_rv xz
     WHERE xz.description_line = a.description_line;

  l_limit PLS_INTEGER := 1000;

  TYPE t_data_cursor IS TABLE OF reg%ROWTYPE INDEX BY PLS_INTEGER;
  l_data_cursor t_data_cursor;

  --c reg%ROWTYPE;

BEGIN

  EXECUTE IMMEDIATE 'truncate table JC.TS_XLA_CMA_INT_L_INT_HIST_TMP';

  EXECUTE IMMEDIATE 'ALTER SESSION SET commit_wait=''NOWAIT''';
  EXECUTE IMMEDIATE 'ALTER SESSION SET commit_logging=''BATCH''';
  EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_mode=''ALL_ROWS''';

  OPEN reg;
  LOOP
    FETCH reg BULK COLLECT
      INTO l_data_cursor LIMIT l_limit;
    EXIT WHEN l_data_cursor.count = 0;
    
    FORALL i IN 1..l_data_cursor.COUNT
    INSERT /*+ append nologging parallel */ INTO JC.TS_XLA_CMA_INT_L_INT_HIST_TMP VALUES l_data_cursor(i); 
  
    COMMIT;
  
  END LOOP;
  CLOSE reg;
  
 --ADD JC 09062022 se agrego para depurar data duplicada 
  ts_fnd_log_pkg.pr_log('Inicio delete rows duplicate JC.TS_XLA_CMA_INT_L_INT_HIST_TMP');
 delete JC.TS_XLA_CMA_INT_L_INT_HIST_TMP
 where rowid not in (SELECT MIN(rowid)
                       FROM JC.TS_XLA_CMA_INT_L_INT_HIST_TMP
                      GROUP BY fecha_registro,
                               asiento_id,
                               line_number,
                               description_line,
                               event_id,
                               description_line_);
  COMMIT;
  ts_fnd_log_pkg.pr_log('Fin delete rows duplicate JC.TS_XLA_CMA_INT_L_INT_HIST_TMP'); 
 -- 
END;

PROCEDURE sp_insert_JC_CUO_CORR_FE is
  row_id     ROWID;
  vn_ordinal NUMBER;
  v_counfe   NUMBER;
BEGIN

  -- corregir
  xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('truncate JC.JC_CUO_CORRELATIVO_FE');

  EXECUTE IMMEDIATE 'truncate table JC.JC_CUO_CORRELATIVO_FE';

  -- corregir
  xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('insert JC.JC_CUO_CORRELATIVO_FE');

  INSERT /*+ append nologging parallel */
  INTO JC.JC_CUO_CORRELATIVO_FE
    (cuo, correl, description_line, AQPA470SERIE, AQPA470NRO,c_descrip)
    SELECT /*+ parallel(auto) */
     nvl(gjh.attribute3,
         gjh.je_header_id || '-' || substr(gjh.je_category, 1, 8) || '-' ||
         gjh.period_name || '-' || gjh.doc_sequence_value) cuo,
     nvl('M' || gjl.attribute3, 'M' || lpad(gjl.je_line_num, 9, 0)) correl,
     i.description_line,
     i.AQPA470SERIE,
     i.AQPA470NRO,
     i.C_DESCRIP
    
      FROM gl.gl_je_headers                gjh,
           gl.gl_je_lines                  gjl,
           gl.gl_import_references         gir,
           xla.xla_ae_lines                xal,
           xla.xla_ae_line_acs             xala,
           apps.xla_ae_headers             h,
           JC.TS_XLA_CMA_INT_L_INT_HIST_TMP i,
           xla.xla_events                  xale,
           xla.xla_transaction_entities    xlat
     WHERE gjl.je_header_id = gjh.je_header_id
       AND gir.je_header_id = gjl.je_header_id
       AND gir.je_line_num = gjl.je_line_num
       AND xal.gl_sl_link_id = gir.gl_sl_link_id
       AND xal.gl_sl_link_table = gir.gl_sl_link_table
       AND xala.ae_header_id = xal.ae_header_id
       AND xala.ae_line_num = xal.ae_line_num
       AND xal.ae_header_id = h.ae_header_id
       AND h.event_id = i.event_id
       AND xal.description = i.description_line_-- || ' ' --jc se desabilito 29082022 para no invalidar los index
       AND xal.ledger_id = 2022
       AND xal.ledger_id = gjh.ledger_id
       AND h.application_id = xale.application_id
       AND h.event_id = xale.event_id
       AND xale.application_id = xlat.application_id
       AND xale.entity_id = xlat.entity_id;

  commit;

END;

PROCEDURE sp_gl_actualizar_cuo_2_fe_v2 IS
  
    CURSOR cuos IS
      SELECT  /*+ NO_CPU_COSTING */ cuo,
              correl,
              description_line,
              aqpa470serie,
              aqpa470nro,
              C_DESCRIP
        FROM JC.JC_CUO_CORRELATIVO_FE;
  
    lc_cuoebs      VARCHAR(40);
    lc_cuorel      VARCHAR(10);
    lc_description VARCHAR(100);
    vn_cuenta_reg  NUMBER := 0;
  BEGIN
    xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('Entro Procedimiento Actualizar FE V2');
  
    FOR c IN cuos LOOP
    
      BEGIN       
      
        UPDATE JC.jc_aqpa470_per g
           SET g.cuoebs      = c.cuo
              ,g.relebs      = c.correl
              ,g.description = c.c_descrip
         WHERE g.aqpa470serie = c.aqpa470serie
           AND g.aqpa470nro = c.aqpa470nro
           AND g.flag_rv = 'Y';
      
        COMMIT;
        vn_cuenta_reg := vn_cuenta_reg + 1;
        IF (MOD(vn_cuenta_reg, 1000) = 0) THEN
          -- corregir
          xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log(' FE van ' || vn_cuenta_reg);
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log(' FE van ' || vn_cuenta_reg || ' ERROR : ' || SQLERRM);
      END;
    
    END LOOP;
    
    
    
  
  END;
  
 PROCEDURE sp_insert_AQPA470_TMP is
    row_id     ROWID;
    vn_ordinal NUMBER;
    v_counfe   NUMBER;
  BEGIN

    -- corregir
    xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('truncate JC.AQPA470_TMP');
  
    EXECUTE IMMEDIATE 'truncate table JC.AQPA470_TMP';
  
    -- corregir
    xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('insert JC.AQPA470_TMP');
  
    INSERT /*+ append nologging parallel */
    INTO JC.AQPA470_TMP
      (description_line,
       aqpa470tcomf,
       aqpa470seri,
       aqpa470num,
       aqpa470tdocr,
       aqpa470nruc)

      SELECT /*+parallel (xz,10)*/
       to_char(xz.aqpa470con, 'YYYYMMDD') || '-' || xz.aqpa470pgcod || '-' ||
           xz.aqpa470sucor || '-' || xz.aqpa470mod || '-' || xz.aqpa470tran || '-' ||
           xz.aqpa470rel || '-' || xz.aqpa470cord || '-' || xz.aqpa470subo DESCRIPTION_LINE,
           xz.AQPA470TCOMF,
           decode(xz.AQPA470SERI, null, xz.AQPA470SERIE, xz.AQPA470SERI) AQPA470SERI,
           decode(xz.AQPA470NUM, null, xz.AQPA470NRO, xz.AQPA470NRO) AQPA470NUM,
           xz.AQPA470TDOCR,
           trim(xz.AQPA470NRUC) AQPA470NRUC
      from /*operador.*/ --se comento esquema 05/11/2021 dcastro
           XXBOL.AQPA470 xz
     where to_char(xz.AQPA470FEMI, 'MON-YY') = vg_period
       and xz.AQPA470LEST NOT IN ('M', 'R');
    commit;    
  
  END;
  
  procedure jc_insert_ebs_fe_todos_2 is
  
  begin
  
    execute immediate 'truncate table JC_EBS_FE_TODOS_ALL_TMP';
  
    INSERT /*+ append nologging parallel */
    INTO JC_EBS_FE_TODOS_ALL_TMP
      (period,
       doc_sequence_value,
       code_accounting,
       ledger_account,
       gl_date,
       gl_description,
       accounted_dr,
       accounted_cr,
       line_status,
       annotation_date,
       je_header_id,
       je_line_num,
       org_id,
       period_name,
       ledger_id,
       created_by,
       creation_date,
       last_update_by,
       last_update_date,
       last_update_login,
       request_id,
       additional_field01,
       line_type,
       journal_type,
       doc_sequence_value_aux,
       doc_sequence_line,
       invoice_line_number,
       ae_header_id,
       ae_line_num,
       centro_costo,
       currency_code,
       tipo_doc_prove,
       numero_entidad_emisor,
       doc_sunat,
       serie_documento,
       numero_documento,
       effective_date,
       due_date,
       glosa_referencial,
       structured_field,
       leasing_id,
       fecha_emision,
       je_source,
       origen,
       attribute3_l,
       attribute3_h,
       IMPORT_TOT_EXCEP_SUNAT,
       CUOEBS,
       RELEBS,
       DESCRIPTION)
    
      select /*+ parallel(auto) */ a.period,
             a.doc_sequence_value,
             a.code_accounting,
             a.ledger_account,
             a.gl_date,
             translate(a.gl_description, '|/\', ' ') gl_description,
             a.accounted_dr,
             a.accounted_cr,
             a.line_status,
             a.annotation_date,
             a.je_header_id,
             a.je_line_num,
             a.org_id,
             a.period_name,
             a.ledger_id,
             a.created_by,
             a.creation_date,
             a.last_update_by,
             a.last_update_date,
             a.last_update_login,
             a.request_id,
             translate(a.additional_field01, '|/\', ' ') additional_field01,
             a.line_type,
             a.journal_type,
             a.doc_sequence_value_aux,
             a.doc_sequence_line,
             a.invoice_line_number,
             a.ae_header_id,
             a.ae_line_num,
             a.centro_costo,
             a.currency_code,
             a.tipo_doc_prove,
             a.numero_entidad_emisor,
             --ADD JC180723
             decode(a.doc_sunat, '', '00', 'NA', '00', a.doc_sunat) doc_sunat, 
             CASE WHEN a.doc_sunat = 91 AND a.serie_documento IS NULL THEN
                get_nodom_doc(a.invoice_id,'SERIE')
             ELSE
                a.serie_documento
             END serie_documento,
             
              CASE WHEN a.doc_sunat = 91 AND a.numero_documento IS NULL THEN
                get_nodom_doc(a.invoice_id,'NUMERO')
             ELSE
               decode(a.numero_documento, '', '00', a.numero_documento) 
               END numero_documento,
             a.effective_date,
             a.due_date,
             translate(substr(a.glosa_referencial, 1, 200), '|/\', ' ') glosa_referencial,
            -- a.structured_field,
			 lpad(NVL(a.numero_entidad_emisor,'0'),11,'0')||lpad(NVL(decode(a.doc_sunat, '', '00', 'NA', '00', a.doc_sunat),'0'),2,'0')|| lpad(NVL(CASE WHEN a.doc_sunat = 91 AND a.serie_documento IS NULL THEN
                get_nodom_doc(a.invoice_id,'SERIE')
             ELSE
                a.serie_documento
             END,'0'),4,'0')||lpad(CASE WHEN a.doc_sunat = 91 AND a.numero_documento IS NULL THEN
                get_nodom_doc(a.invoice_id,'NUMERO')
             ELSE
               decode(a.numero_documento, '', '00', a.numero_documento) 
               END,10,'0') structured_field, -- CAR/SIRE PPCH Royal ITC
             a.leasing_id,
             a.fecha_emision,
             a.je_source,
             decode(length(a.je_source), 2, 'BT', 'EBS') origen,
             
             (select l.attribute3
                from apps.gl_je_lines l
               where l.je_header_id = a.je_header_id
                 and l.je_line_num = a.je_line_num) attribute3_l,
             (select l.attribute3
                from apps.gl_je_headers l
               where l.je_header_id = a.je_header_id) attribute3_h,
               
            null,--38
            null,--39
            null,--40
            null --41  
      
        from ts_gl_lines_ple_tmp a
       where 1 = 1
            
            --FE
         and not exists
      --FE
       (select /*+ parallel(auto) */ 1
                from JC.AQPA470_TMP xz
               where  xz.DESCRIPTION_LINE= a.DESCRIPTION_LINE
               -- NO TRAE LOS DOCUMENTOS ANULADOS                     
                     );
      
      ---UNIENDO SOLO FACTURACION ELECTRONICA FE            
      COMMIT;
   xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('jc_pq_ca_ple_lib_diario_PR_V3.jc_insert_ebs_fe_todos_2 SELECT 1 ');   
      
   INSERT /*+ append nologging parallel */
    INTO JC_EBS_FE_TODOS_ALL_TMP
      (period,
       doc_sequence_value,
       code_accounting,
       ledger_account,
       gl_date,
       gl_description,
       accounted_dr,
       accounted_cr,
       line_status,
       annotation_date,
       je_header_id,
       je_line_num,
       org_id,
       period_name,
       ledger_id,
       created_by,
       creation_date,
       last_update_by,
       last_update_date,
       last_update_login,
       request_id,
       additional_field01,
       line_type,
       journal_type,
       doc_sequence_value_aux,
       doc_sequence_line,
       invoice_line_number,
       ae_header_id,
       ae_line_num,
       centro_costo,
       currency_code,
       tipo_doc_prove,
       numero_entidad_emisor,
       doc_sunat,
       serie_documento,
       numero_documento,
       effective_date,
       due_date,
       glosa_referencial,
       structured_field,
       leasing_id,
       fecha_emision,
       je_source,
       origen,
       attribute3_l,
       attribute3_h,
       IMPORT_TOT_EXCEP_SUNAT,
       CUOEBS,
       RELEBS,
       DESCRIPTION)
      
      select /*+ parallel(auto) */ a.period,
             a.doc_sequence_value,
             a.code_accounting,
             a.ledger_account,
             a.gl_date,
             translate(a.gl_description, '|/\', ' ') gl_description,
             a.accounted_dr,
             a.accounted_cr,
             a.line_status,
             a.annotation_date,
             a.je_header_id,
             a.je_line_num,
             a.org_id,
             a.period_name,
             a.ledger_id,
             a.created_by,
             a.creation_date,
             a.last_update_by,
             a.last_update_date,
             a.last_update_login,
             a.request_id,
             translate(a.additional_field01, '|/\', ' ') additional_field01,
             a.line_type,
             a.journal_type,
             a.doc_sequence_value_aux,
             a.doc_sequence_line,
             a.invoice_line_number,
             a.ae_header_id,
             a.ae_line_num,
             a.centro_costo,
             a.currency_code,
             aqp.AQPA470TDOCR tipo_doc_prove, --8 FE
             aqp.AQPA470NRUC numero_entidad_emisor, --9 FE
             LPAD(aqp.AQPA470TCOMF, 2, '0') doc_sunat, --10 FE
             aqp.AQPA470SERI serie_documento, --11 FE
             TO_CHAR(aqp.AQPA470NUM) numero_documento, --12 FE
             a.effective_date,
             a.due_date,
             translate(substr(a.glosa_referencial, 1, 200), '|/\', ' ') glosa_referencial,
             'X' structured_field,
             a.leasing_id,
             a.fecha_emision,
             a.je_source,
             'FE' origen,
             
             (select l.attribute3
                from apps.gl_je_lines l
               where l.je_header_id = a.je_header_id
                 and l.je_line_num = a.je_line_num) attribute3_l,
             (select l.attribute3
                from apps.gl_je_headers l
               where l.je_header_id = a.je_header_id) attribute3_h
               
             --ADD11032019 PDZ JOGZAR
             
              ,
              NULL import_tot_excep_sunat--38
              ,
              
              NULL cuoebs --39
              
             ,
              
              NULL relebs--40 
              
              ,
              
              NULL description --41   
      
        from ts_gl_lines_ple_tmp a,
             
             --FE
             (select /*+ parallel(auto) */
                      description_line, 
                      aqpa470tcomf, 
                      aqpa470seri, 
                      aqpa470num, 
                      aqpa470tdocr, 
                      aqpa470nruc                     
                from JC.AQPA470_TMP xz-- NO TRAE LOS DOCUMENTOS ANULADOS             
               ) aqp
      --FE
       where 1 = 1
            
         and (decode('BT',
                     'TODOS',
                     'TODOS',
                     decode(length(a.je_source), 2, 'BT', 'EBS')) = 'BT')
            
         and a.DESCRIPTION_LINE = aqp.DESCRIPTION_LINE
         and not exists (select /*+ parallel(auto) */ 1 
                         from JC.jc_aqpa470_per xz 
                         where (to_char(xz.aqpa470con, 'YYYYMMDD') || '-' || xz.aqpa470pgcod || '-' || xz.aqpa470sucor || '-' ||
                         xz.aqpa470mod || '-' || xz.aqpa470tran || '-' || xz.aqpa470rel || '-' || xz.aqpa470cord || '-' ||
                         xz.aqpa470subo) = aqp.DESCRIPTION_LINE
                         and  to_char(xz.AQPA470FEMI, 'MON-YY') =  vg_period  
                         and xz.flag_rv = 'Y'
                         and xz.aqpa470flag = 'S'
                         );
         
     COMMIT;
     
  xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('jc_pq_ca_ple_lib_diario_PR_V3.jc_insert_ebs_fe_todos_2 SELECT 2 ');   

     
   INSERT /*+ append nologging parallel */
    INTO JC_EBS_FE_TODOS_ALL_TMP
      (period,
       doc_sequence_value,
       code_accounting,
       ledger_account,
       gl_date,
       gl_description,
       accounted_dr,
       accounted_cr,
       line_status,
       annotation_date,
       je_header_id,
       je_line_num,
       org_id,
       period_name,
       ledger_id,
       created_by,
       creation_date,
       last_update_by,
       last_update_date,
       last_update_login,
       request_id,
       additional_field01,
       line_type,
       journal_type,
       doc_sequence_value_aux,
       doc_sequence_line,
       invoice_line_number,
       ae_header_id,
       ae_line_num,
       centro_costo,
       currency_code,
       tipo_doc_prove,
       numero_entidad_emisor,
       doc_sunat,
       serie_documento,
       numero_documento,
       effective_date,
       due_date,
       glosa_referencial,
       structured_field,
       leasing_id,
       fecha_emision,
       je_source,
       origen,
       attribute3_l,
       attribute3_h,
       IMPORT_TOT_EXCEP_SUNAT,
       CUOEBS,
       RELEBS,
       DESCRIPTION)
      
     select /*+ parallel(auto) */ to_char(xz.aqpa470femi, 'YYYYMM') || '00' period,
             null doc_sequence_value,
             null code_accounting,
             SUBSTR(xz.aqpa470rubro, 1, 2) || '0' ||
             SUBSTR(xz.aqpa470rubro, 3, length(xz.aqpa470rubro)) || '00000' ledger_account,
             null gl_date,
             'CDP de Referencia '||to_char(to_date(xz.aqpa470fdref, 'DD-MM-YY'), 'DD-MM-RRRR')||' '||xz.aqpa470tcomp||' '||xz.aqpa470sdref||'-'||xz.aqpa470ndref gl_description,
             '0.00' accounted_dr,
             '0.00' accounted_cr,
             '1' line_status,
             null annotation_date,
             null je_header_id,
             null je_line_num,
             null org_id,
             to_char(xz.AQPA470FEMI, 'MON-YY') period_name,
             NULL ledger_id,
             null created_by,
             null creation_date,
             null last_update_by,
             null last_update_date,
             null last_update_login,
             null request_id,
             null additional_field01,
             null line_type,
             null journal_type,
             null doc_sequence_value_aux,
             null doc_sequence_line,
             null invoice_line_number,
             null ae_header_id,
             null ae_line_num,
             NULL centro_costo,
             xz.aqpa470mone currency_code,
             xz.AQPA470TDOCR tipo_doc_prove, --8 FE
             xz.AQPA470NRUC numero_entidad_emisor, --9 FE
             LPAD(xz.AQPA470TCOMF, 2, '0') doc_sunat, --10 FE
             xz.AQPA470SERI serie_documento, --11 FE
             TO_CHAR(xz.AQPA470NUM) numero_documento, --12 FE
             null effective_date,
             null due_date,
             null glosa_referencial,
            'SIN_VALOR' structured_field,
             null leasing_id,
             to_char(xz.aqpa470femi, 'dd/mm/yyyy') fecha_emision,
             null je_source,
             /*decode(length(a.je_source), 2, 'BT', 'EBS')*/
             'FE' origen,
             
             --110619 modify jogzarpdz 
             'M000000001' as attribute3_l,
              TRIM(xz.aqpa470tcomf||'-'||xz.aqpa470seri||'-'||xz.aqpa470num||'-'||xz.aqpa470tdocr||'-'||xz.aqpa470nruc)  as attribute3_h,
             --
             
             --ADD11032019 PDZ JOGZAR
             
               TRIM(to_char((CASE
                 WHEN xz.AQPA470TCOMF = '07' THEN
                  DECODE(xz.AQPA470MONE, 'PEN', -xz.aqpa470impt,-xz.aqpa470impt * xz.aqpa470tcam)
                  ELSE 
                  DECODE(xz.AQPA470MONE, 'PEN', xz.aqpa470impt,xz.aqpa470impt * xz.aqpa470tcam) 
               END), '9999999999999990.99')) import_tot_excep_sunat--38
              ,
              
              (select p.cuoebs
              from JC.jc_aqpa470_per p
              where p.aqpa470fdref = xz.aqpa470fdref 
                and p.aqpa470tcomp = xz.aqpa470tcomp 
                and p.aqpa470sdref = xz.aqpa470sdref
                and p.aqpa470ndref = xz.aqpa470ndref 
                and p.AQPA470FLAG = 'S' 
                and p.cuoebs is not null            
               ) cuoebs --39
              
             ,
              
              (select p.relebs
              from JC.jc_aqpa470_per p
              where p.aqpa470fdref = xz.aqpa470fdref 
                and p.aqpa470tcomp = xz.aqpa470tcomp 
                and p.aqpa470sdref = xz.aqpa470sdref
                and p.aqpa470ndref = xz.aqpa470ndref 
                and p.AQPA470FLAG = 'S'       
                and p.relebs is not null       
               ) relebs--40 
              
              ,
              
              (select p.description
              from JC.jc_aqpa470_per p
              where p.aqpa470fdref = xz.aqpa470fdref 
                and p.aqpa470tcomp = xz.aqpa470tcomp 
                and p.aqpa470sdref = xz.aqpa470sdref
                and p.aqpa470ndref = xz.aqpa470ndref 
                and p.AQPA470FLAG = 'S' 
                and p.description is not null            
               ) description --41  
               
      
        from  JC.jc_aqpa470_per xz
       where to_char(xz.AQPA470FEMI, 'MON-YY') =  vg_period  
       and xz.flag_rv = 'Y'
       and xz.aqpa470flag = 'S';
  
    COMMIT;
    
  xxbol.TS_GL_BOOKS_REP_PLE_5_C_PKG_v2.pr_record_log('jc_pq_ca_ple_lib_diario_PR_V3.jc_insert_ebs_fe_todos_2 SELECT 3 ');   

  
  end;


  function get_nodom_doc(pn_invoice_id number, pv_accion varchar2)
    return varchar2 is
  
    lv_invoicenum       ap_invoices_all.invoice_num%type;
    lv_new_invoicenum   ap_invoices_all.invoice_num%type; --CMAC-CSA2-Cam06-19092016-JHAMA
    lv_validate_flag    varchar2(1);
    lv_serie_documento  varchar2(30);
    lv_numero_documento varchar2(300);--add jc 30 to 300 19072022
    lv_tipo_doc_sunat   ts_ap_invoices_all.doc_sunat%type;
    ln_ledger_id        varchar2(6);
    vc_post_error       varchar2(1000);
    VN_FORMAT NUMBER;
  begin
  
      execute immediate 'Alter session set nls_language = ''LATIN AMERICAN SPANISH''';

  
    select invoice_num, attribute40, taia.doc_sunat
      into lv_invoicenum, lv_validate_flag, lv_tipo_doc_sunat
      from ap_invoices_all     aia,
           ts_ap_invoices_all  taia,
           fnd_flex_value_sets ffvs,
           fnd_flex_values     ffv
     where aia.invoice_id = taia.invoice_id
       and ffvs.flex_value_set_id = ffv.flex_value_set_id
       and ffvs.flex_value_set_name = 'TS_AP_SUNAT_DOCUMENTOS'
       and taia.invoice_id = pn_invoice_id
       and ffv.flex_Value = taia.doc_sunat;
       
       BEGIN
         SELECT 1
           INTO VN_FORMAT
           FROM XXBOL.ts_ap_format_documents
          WHERE TIPO_DOCUMENTO_SUNAT = lv_tipo_doc_sunat
            AND FORMAT = '%-%'
            AND TIPO_DOCUMENTO_SUNAT IN (91);
       EXCEPTION
         WHEN OTHERS THEN
           VN_FORMAT := 0;
       END;
       
       SELECT INVOICE_NUM
       INTO lv_new_invoicenum
       FROM AP_INVOICES_ALL
       WHERE INVOICE_ID = pn_invoice_id; 
    
    if pv_accion = 'SERIE' AND VN_FORMAT = 1 then
      SELECT DECODE(INSTR(lv_new_invoicenum, '-'),
                    0,
                    NULL,
                    SUBSTR(lv_new_invoicenum,
                           1,
                           INSTR(lv_new_invoicenum, '-') - 1))
        into lv_serie_documento
        FROM dual;
      return lv_serie_documento;
    
    elsif pv_accion = 'NUMERO' AND VN_FORMAT = 1 then
      SELECT DECODE(INSTR(lv_new_invoicenum, '-'),
                    0,
                    lv_new_invoicenum,
                    SUBSTR(lv_new_invoicenum,
                           INSTR(lv_new_invoicenum, '-') + 1,
                           LENGTH(lv_new_invoicenum) -
                           INSTR(lv_new_invoicenum, '-')))
        into lv_numero_documento
        FROM dual;
      return lv_numero_documento;
    end if;
    return null;
  end get_nodom_doc;

 
end;
/
