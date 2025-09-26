CREATE OR REPLACE PACKAGE JC_FA_CORRECCION_MONEDA AS

  /*========================================================================================+
  |                     Copyright (c) 2025 Jogzar Consulting S.A.C.                         |
  |                        ORACLE Applications Comun Customizing                            |
  +=========================================================================================+
  |                                                                                         |
  | DESCRIPTION : Funciones/Procedimientos para GL exclusivos para la version R12           |
  |               Correción segmento "digito" para los asientos cargados                    |
  | HISTORY                                                                                 |
  | WHEN          WHO                 WHAT                                                  |
  | ----------    ------------------- ------------------------------------------------------|
  | 06/08/2025    Jose Zavala         Creación del paquete                                  |
  +=========================================================================================*/

  PROCEDURE MAIN(errbuf        out varchar2,
                 retcode       out varchar2,
                 P_PERIOD_NAME varchar2);
  PROCEDURE PR_LOG(vc_message in varchar2);
END JC_FA_CORRECCION_MONEDA;
/
CREATE OR REPLACE PACKAGE BODY JC_FA_CORRECCION_MONEDA AS

  /*========================================================================================+
  |                     Copyright (c) 2025 Jogzar Consulting S.A.C.                         |
  |                        ORACLE Applications Comun Customizing                            |
  +=========================================================================================+
  |                                                                                         |
  | DESCRIPTION : Funciones/Procedimientos para GL exclusivos para la version R12           |
  |               Correción segmento "digito" para los asientos cargados                    |
  | HISTORY                                                                                 |
  | WHEN          WHO                 WHAT                                                  |
  | ----------    ------------------- ------------------------------------------------------|
  | 06/08/2025    Jose Zavala         Creación del paquete                                  |
  +=========================================================================================*/

  PROCEDURE MAIN(errbuf        out varchar2,
                 retcode       out varchar2,
                 P_PERIOD_NAME varchar2) IS
    V_STATUS              VARCHAR2(1) := 'P';
    V_CODE_COMBINATION_ID VARCHAR2(20);
    V_LEDGER_ID           NUMBER := 2022;
    V_FOR                 NUMBER;
  BEGIN
    select COUNT(c.code_combination_id)
      into v_for
      from gl_code_combinations c
     inner join gl_je_lines b on c.code_combination_id =
                                 b.code_combination_id
     inner join gl_je_headers a on a.je_header_id = b.je_header_id
     where a.ledger_id = v_ledger_id
       and a.status != v_status
       and a.period_name = P_PERIOD_NAME
       and decode(c.segment3, '1', 'PEN', '2', 'USD') != a.currency_code;
    if v_for > 0 then
      pr_log('Periodo || Nro Asiento || Nro Linea || Divisa || Combinación Contable Inconsistente || Combinación Contable Actualizada');
      for x in (select c.code_combination_id,
                       c.segment1,
                       c.segment2,
                       c.segment3,
                       c.segment4,
                       c.segment5,
                       c.segment6,
                       c.segment7,
                       c.segment8,
                       c.segment9,
                       a.doc_sequence_value,
                       a.period_name,
                       a.currency_code as divisa,
                       a.je_header_id,
                       b.je_line_num,
                       case a.currency_code
                         when 'PEN' then
                          '1'
                         when 'USD' then
                          '2'
                       end currency_code
                  from gl_code_combinations c
                 inner join gl_je_lines b on c.code_combination_id =
                                             b.code_combination_id
                 inner join gl_je_headers a on a.je_header_id =
                                               b.je_header_id
                 where a.ledger_id = v_ledger_id
                   and a.status != v_status
                   and a.period_name = P_PERIOD_NAME
                   and decode(c.segment3, '1', 'PEN', '2', 'USD') !=
                       a.currency_code) loop
        BEGIN
          select code_combination_id
            into v_code_combination_id
            from gl.gl_code_combinations
           where segment1 = x.segment1
             and segment2 = x.segment2
             and segment3 = x.currency_code
             and segment4 = x.segment4
             and segment5 = x.segment5
             and segment6 = x.segment6
             and segment7 = x.segment7
             and segment8 = x.segment8
             and segment9 = x.segment9;
        
          pr_log(P_PERIOD_NAME || ' || ' || x.je_header_id || ' || ' ||
                 x.je_line_num || ' || ' || x.divisa || ' || ' ||
                 x.segment1 || x.segment2 || x.segment3 || x.segment4 ||
                 x.segment5 || x.segment6 || x.segment7 || x.segment8 ||
                 x.segment9 || ' || ' || x.segment1 || x.segment2 ||
                 x.currency_code || x.segment4 || x.segment5 || x.segment6 ||
                 x.segment7 || x.segment8 || x.segment9);
          update gl.gl_je_lines
             set code_combination_id = V_CODE_COMBINATION_ID
           where je_header_id = x.je_header_id
             and JE_LINE_NUM = x.je_line_num;
        EXCEPTION
          WHEN OTHERS THEN
            pr_log('No se encontro Combinacion para: ' ||
                   v_code_combination_id || ' || ' || x.segment1 ||
                   x.segment2 || x.segment3 || x.segment4 || x.segment5 ||
                   x.segment6 || x.segment7 || x.segment8 || x.segment9);
        END;
      end loop;
    else
      pr_log('No se encontró ninguna inconsistencia');
      pr_log(SQLERRM);
    end if;
  EXCEPTION
    WHEN OTHERS THEN
      errbuf  := SQLERRM; -- mensaje del error
      retcode := 2; -- código de error
  END;
  PROCEDURE PR_LOG(vc_message in varchar2) is
  BEGIN
    apps.fnd_file.put_line(apps.fnd_file.log, vc_message);
    Fnd_File.put_line(apps.Fnd_File.OUTPUT, vc_message);
  END pr_log;
END JC_FA_CORRECCION_MONEDA;
/
