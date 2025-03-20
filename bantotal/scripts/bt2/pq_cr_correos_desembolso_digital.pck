create or replace package PQ_CR_CORREOS_DESEMBOLSO_DIGITAL is
  /* ************************************************************************************************************
     -- Nombre                     : PQ_CR_CORREOS_DESEMBOLSO_DIGITAL
     -- Sistema                    : BANTOTAL
     -- Módulo                     : ACTIVAS
     -- Descripción                : Envío de Correos para Desembolso Digital
     -- Versión                    : 1.0
     -- Fecha de Creación          : 2021.11.30
     -- Autor de Creación          : Alonso Pacheco Huachaca
     -- Estado                     : Activo
     -- Acceso                     : Público
     -- Fecha de Modificación      : 2022.06.30
     -- Autor de la Modificación   : Alonso Pacheco Huachaca
     -- Descripción de Modificación: Aplica Desembolso Digital
     -- Fecha de Modificación      : 11/12/2023
     -- Autor de la Modificación   : IGS_RCASTRO
     -- Descripción de Modificación: Validación de score máximo para Aplicar Desembolso Digital
     -- Fecha de Modificación      : 06/2/2024
     -- Autor de la Modificación   : IGS_RCASTRO
     -- Descripción de Modificación: Validación de score máximo y validacion de plazo máx. para Aplicar Desembolso Digital
     -- Fecha de Modificación      : 01/3/2024
     -- Autor de la Modificación   : IGS_RCASTRO
     -- Descripción de Modificación: Ajuste en garantia y score
     -- Fecha de Modificación      : 27/8/2024
     -- Autor de la Modificación   : IGS_RCASTRO
     -- Descripción de Modificación: Ajuste en garantia reales
     -- Fecha de Modificación      : 28/8/2024
     -- Autor de la Modificación   : IGS_RCASTRO
     -- Descripción de Modificación: Ajuste en score minimo
     -- Fecha de Modificación      : 18/12/2024
     -- Autor de la Modificación   : IGS_RCASTRO
     -- Descripción de Modificación: Se agregan nuevos controles masificacion aval, fondos gob. y compra deuda
     -- Fecha de Modificación      : 04/2/2025
     -- Autor de la Modificación   : IGS_RCASTRO
     -- Descripción de Modificación: Se agregan ajusta validacion de aval
  * *************************************************************************************************************/

  procedure sp_cr_envioanalista(pn_pgcod     in number,
                                pn_scmod     in number,
                                pn_scsuc     in number,
                                pn_scmda     in number,
                                pn_scpap     in number,
                                pn_sccta     in number,
                                pn_scoper    in number,
                                pn_scsbop    in number,
                                pn_sctope    in number,
                                pn_instancia in number,
                                pv_ubuser    in varchar2,
                                pd_fecapr    in date);

  procedure sp_cr_envioaprobador(pn_pgcod     in number,
                                 pn_scmod     in number,
                                 pn_scsuc     in number,
                                 pn_scmda     in number,
                                 pn_scpap     in number,
                                 pn_sccta     in number,
                                 pn_scoper    in number,
                                 pn_scsbop    in number,
                                 pn_sctope    in number,
                                 pn_instancia in number,
                                 pv_ubuser    in varchar2,
                                 pd_fecapr    in date);

  --2022.30.06
  procedure sp_cr_aplica_desembolso_digital(pn_pgcod     in number,
                                            pn_scmod     in number,
                                            pn_scsuc     in number,
                                            pn_sccta     in number,
                                            pn_scoper    in number,
                                            pn_scsbop    in number,
                                            pn_sctope    in number,
                                            pn_monto     in number,
                                            pn_instancia in number,
                                            vo_rpta      out number);
  --2023.12.11
  procedure sp_valid_control_limit_desem_dig(instancia in number,
                                             codRpta   out number);

  procedure sp_valid_garantias_reales(instancia in number,
                                      codRpta   out number);

  procedure sp_validar_modulos_habilit(instancia in number,
                                       codRpta   out number);

  procedure sp_validar_score(instancia  in number,
                             usuarioEje in varchar2,
                             codRpta    out number);

  procedure SP_CR_OBTENER_SCORE(P_TIPO_DOCUMENTO  IN NUMBER,
                                P_NRO_DOCUMENTO   IN VARCHAR2,
                                P_USUARIO_EJECUTA IN VARCHAR2,
                                P_SEGMENTO_RIESGO OUT VARCHAR2,
                                P_RIESGO_SCORE    OUT VARCHAR2,
                                P_TIPO_SCORE      OUT VARCHAR2,
                                P_PUNTAJE         OUT NUMBER,
                                P_FECHA_SCORE     OUT DATE);

end PQ_CR_CORREOS_DESEMBOLSO_DIGITAL;
/

create or replace package body PQ_CR_CORREOS_DESEMBOLSO_DIGITAL is

procedure sp_cr_envioanalista (pn_pgcod in number, pn_scmod in number, pn_scsuc in number,
                               pn_scmda in number, pn_scpap in number, pn_sccta in number,
                               pn_scoper in number, pn_scsbop in number, pn_sctope in number,
                               pn_instancia in number, pv_ubuser in varchar2, pd_fecapr in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_envioanalista
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2021.11.30
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Envia correo post-aprobacion al analista del credito para D. Digital
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_pgcod ( Codigo Empresa )
    --                              pn_scmod ( Modulo )
    --                              pn_scsuc ( Sucursal )
    --                              pn_scmda ( Moneda )
    --                              pn_scpap ( Papel )
    --                              pn_sccta ( Cuenta )
    --                              pn_scoper ( Operacion )
    --                              pn_scsbop ( Sub Operacion )
    --                              pn_sctope ( Tipo Operacion )
    --                              pn_instancia ( Instancia )
    --                              pc_ubuser ( Usuario que ejecuta )
    --                              pd_fecapr ( Fecha de aprobación )
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 2022.09.07
    -- Autor de la Modificación   : Alonso Pacheco Huachaca
    -- Descripción de Modificación: Parametrizacion de Envio de Correo
    -- *****************************************************************
       ln_pgcod number := 0;
       ln_scmod number := 0;
       ln_scsuc number := 0;
       ln_scmda number := 0;
       ln_scpap number := 0;
       ln_sccta number := 0;
       ln_scoper number := 0;
       ln_scsbop number := 0;
       ln_sctope number := 0;
       ln_instancia number := 0;
       ln_monto number := 0;
       --
       lc_numdoc  varchar2(12) := '';
       lc_score   char(1) := '';
       ln_exmodu  number  := 0;
       ln_ddigit  number  := 0;
       ln_cntcta  number  := 0;
       lv_nombre  varchar2(30) := '';
       lv_modulo  varchar2(30) := '';
       lv_tioper  varchar2(30) := '';
       lv_monto   varchar2(30) := '';
       lv_analist varchar2(10) := '';
       lv_geragen varchar2(10) := '';
       ln_anasuc  number  := 0;
       --
       lv_emisor  varchar2(40) := '';
       lv_destino varchar2(100) := '';
       lv_descopi varchar2(100) := '';
       lv_asunto  varchar2(100) := '';
       ll_mensaje long := '';
       p_c_coderr  varchar2(5);
       p_c_msgerr  varchar2(200);
begin
       --inicializa variables acorde si se envio toda la clave o solo la instancia
       begin
         begin
           if pn_instancia = 0 or pn_instancia is null then
               select xwfprcins, xwfmonto1 into ln_instancia, ln_monto from xwf700
                      where xwfempresa = pn_pgcod and xwfsucursal = pn_scsuc and xwfmodulo = pn_scmod
                        and xwfmoneda = pn_scmda and xwfpapel = pn_scpap and xwfcuenta= pn_sccta
                        and xwfoperacion = pn_scoper and xwfsubope = pn_scsbop and xwftipope = pn_sctope;

               ln_pgcod := pn_pgcod;
               ln_scmod := pn_scmod;
               ln_scsuc := pn_scsuc;
               ln_scmda := pn_scmda;
               ln_scpap := pn_scpap;
               ln_sccta := pn_sccta;
               ln_scoper := pn_scoper;
               ln_scsbop := pn_scsbop;
               ln_sctope := pn_sctope;
           else
               select xwfempresa, xwfsucursal, xwfmodulo, xwfmoneda, xwfpapel,
                      xwfcuenta, xwfoperacion, xwfsubope, xwftipope, xwfmonto1
                    into ln_pgcod, ln_scsuc, ln_scmod, ln_scmda, ln_scpap,
                         ln_sccta, ln_scoper, ln_scsbop, ln_sctope, ln_monto
               from xwf700 where xwfprcins = pn_instancia and xwfcar3 = '1';

               ln_instancia := pn_instancia;
           end if;
       exception
            when others then
                p_c_coderr := '90';
                p_c_msgerr := sqlerrm;
                --Grabar Log de datos enviados en tabla incluido el error del sql.
                begin
                  insert into AQPB902A( AQPB902ACOD,AQPB902AMOD,AQPB902ASUC,AQPB902AMDA,AQPB902APAP,AQPB902ACTA,
                                        AQPB902AOPER,AQPB902ASBOP,AQPB902ATOPE,AQPB902AINST,AQPB902AEMIS,AQPB902ADEST,
                                        AQPB902ACOPI,AQPB902AMESG,AQPB902AASUN,AQPB902ADDIG,AQPB902AERRO,AQPB902AERMG,
                                        AQPB902AUSUR,AQPB902AFECR,AQPB902AHORA)
                  values (pn_pgcod, pn_scmod, pn_scsuc, pn_scmda, pn_scpap, pn_sccta, pn_scoper, pn_scsbop, pn_sctope,
                          pn_instancia, lv_emisor, lv_destino, lv_descopi, ll_mensaje, lv_asunto, 1, p_c_coderr, p_c_msgerr,
                          pv_ubuser, TRUNC(SYSDATE), to_char(sysdate, 'HH24:MI:SS'));
                  return;
                exception
                  when others then
                      DBMS_OUTPUT.put_line('Error '|| sqlerrm);
                      return;
                end;
       end;
       --se valida si aplica o no el desembolso digital
       PQ_CR_CORREOS_DESEMBOLSO_DIGITAL.sp_cr_aplica_desembolso_digital(
                  ln_pgcod, ln_scmod, ln_scsuc, ln_sccta, ln_scoper,
                  ln_scsbop, ln_sctope, ln_monto, ln_instancia, ln_ddigit
       );
       if  ln_ddigit = 1 then
            begin
                select d.penom, trim(e.mdnom), trim(f.tonom),
                       concat(decode(b.xwfmoneda,0,'S/. ','US$ '),b.xwfmonto1),
                       trim(fn_analista_credito(b.xwfmodulo,b.xwfsucursal,b.xwfmoneda,b.xwfpapel,b.xwfcuenta,b.xwfoperacion,b.xwfsubope,b.xwftipope))
                       into lv_nombre, lv_modulo, lv_tioper, lv_monto, lv_analist
                from xwf700 b
                inner join sng001 c on c.sng001inst = b.xwfprcins
                inner join fsd001 d on (d.pepais = c.sng001pais and
                                       d.petdoc = c.sng001tdoc and
                                       d.pendoc = c.sng001ndoc)
                inner join fst003 e on e.modulo = b.xwfmodulo
                inner join fst004 f on f.modulo = b.xwfmodulo and f.totope = b.xwftipope
                where b.xwfprcins = ln_instancia and b.xwfcar3 = '1';

                select trim(wfusremail) into lv_destino from wfusers where wfusrcod = rpad(lv_analist, 30, ' ');

                --Gerente de agencia y/o aprobador
                select ubsuc into ln_anasuc from fst046 where ubuser = rpad(pv_ubuser, 10, ' ');
                select b.ubuser into lv_geragen from sng057 a, fst046 b
                       where b.ubuser = a.sng057usr and b.ubsuc = ln_anasuc
                         and a.sng055car = 202
                         and rownum = 1;

                if lv_geragen = pv_ubuser then
                   select trim(wfusremail) into lv_descopi from wfusers where wfusrcod = rpad(pv_ubuser, 30, ' ');
                else
                  select concat(
                  (select concat(trim(wfusremail),';') from wfusers where wfusrcod = rpad(pv_ubuser, 30, ' ')),
                  (select trim(wfusremail) from wfusers where wfusrcod = rpad(lv_geragen, 30, ' '))
                  ) into lv_descopi from dual;
                end if;

            exception
                when others then
                    p_c_coderr := '91';
                    p_c_msgerr := sqlerrm;
                    --Grabar Log de datos enviados en tabla incluido el error del sql.
                    begin
                      insert into AQPB902A( AQPB902ACOD,AQPB902AMOD,AQPB902ASUC,AQPB902AMDA,AQPB902APAP,AQPB902ACTA,
                                            AQPB902AOPER,AQPB902ASBOP,AQPB902ATOPE,AQPB902AINST,AQPB902AEMIS,AQPB902ADEST,
                                            AQPB902ACOPI,AQPB902AMESG,AQPB902AASUN,AQPB902ADDIG,AQPB902AERRO,AQPB902AERMG,
                                            AQPB902AUSUR,AQPB902AFECR,AQPB902AHORA)
                      values (ln_pgcod, ln_scmod, ln_scsuc, ln_scmda, ln_scpap, ln_sccta, ln_scoper, ln_scsbop, ln_sctope,
                              ln_instancia, lv_emisor, lv_destino, lv_descopi, ll_mensaje, lv_asunto, 1, p_c_coderr, p_c_msgerr,
                              pv_ubuser, TRUNC(SYSDATE), to_char(sysdate, 'HH24:MI:SS'));
                      return;
                    exception
                      when others then
                          DBMS_OUTPUT.put_line('Error '|| sqlerrm);
                    end;
            end;

            lv_emisor := 'notificaciones@cajaarequipa.pe';
            lv_asunto := 'ALERTA: CRÉDITO APROBADO - DESEMBOLSO DIGITAL';
            ll_mensaje := '<html><head><style type="text/css"></style>' ||
            '</head><body><br><p>Estimado.</p>' ||
            '<p>El Crédito:
            <ul><li> Del Cliente: ' || lv_nombre || '
            </li><li> Cuenta Cliente: ' || ln_sccta || '
            </li><li> Fecha de Aprobación: ' || TO_CHAR(pd_fecapr) || '
            </li><li> Módulo y Tipo de Operación: ' || lv_modulo || ' / ' || lv_tioper || '
            </li><li> Monto y moneda: ' || lv_monto ||
            '</ul></p><p>Puede ser desembolsado por canales digitales, revisa que el crédito y el expediente se encuentre conforme a la normativa de Caja.' ||
            '<br><br>De estar completo el expediente, coordina su desembolso con el cliente desde nuestra Aplicación y/o Banca por internet.' ||
            '</p><br><p>' || 'Atte.- <br><br>Caja Arequipa.</p></body></html>';

            begin
                  pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destino,
                                                   p_destinatarioscc   => lv_descopi,
                                                   p_destinatariosbcc  => '',
                                                   p_mensaje           => ll_mensaje,
                                                   p_remitente         => lv_emisor,
                                                   p_asunto            => lv_asunto,
                                                   p_tipomensaje       => 'HTML',
                                                   p_directorio        => '',
                                                   p_archivosadjuntos  => '',
                                                   p_c_coderr          => p_c_coderr,
                                                   p_c_deserr          => p_c_msgerr);
                  --Grabar log de datos enviados en tabla
                  insert into AQPB902A( AQPB902ACOD,AQPB902AMOD,AQPB902ASUC,AQPB902AMDA,AQPB902APAP,AQPB902ACTA,
                                        AQPB902AOPER,AQPB902ASBOP,AQPB902ATOPE,AQPB902AINST,AQPB902AEMIS,AQPB902ADEST,
                                        AQPB902ACOPI,AQPB902AMESG,AQPB902AASUN,AQPB902ADDIG,AQPB902AERRO,AQPB902AERMG,
                                        AQPB902AUSUR,AQPB902AFECR,AQPB902AHORA)
                  values (ln_pgcod, ln_scmod, ln_scsuc, ln_scmda, ln_scpap, ln_sccta, ln_scoper, ln_scsbop, ln_sctope,
                          ln_instancia, lv_emisor, lv_destino, lv_descopi, ll_mensaje, lv_asunto, 1, p_c_coderr, p_c_msgerr,
                          pv_ubuser, TRUNC(SYSDATE), to_char(sysdate, 'HH24:MI:SS'));
              exception
                  when others then
                    p_c_coderr := '92';
                    p_c_msgerr := sqlerrm;
                    --Grabar Log de datos enviados en tabla incluido el error del sql.
                    begin
                      insert into AQPB902A( AQPB902ACOD,AQPB902AMOD,AQPB902ASUC,AQPB902AMDA,AQPB902APAP,AQPB902ACTA,
                                            AQPB902AOPER,AQPB902ASBOP,AQPB902ATOPE,AQPB902AINST,AQPB902AEMIS,AQPB902ADEST,
                                            AQPB902ACOPI,AQPB902AMESG,AQPB902AASUN,AQPB902ADDIG,AQPB902AERRO,AQPB902AERMG,
                                            AQPB902AUSUR,AQPB902AFECR,AQPB902AHORA)
                      values (ln_pgcod, ln_scmod, ln_scsuc, ln_scmda, ln_scpap, ln_sccta, ln_scoper, ln_scsbop, ln_sctope,
                              ln_instancia, lv_emisor, lv_destino, lv_descopi, ll_mensaje, lv_asunto, 1, p_c_coderr, p_c_msgerr,
                              pv_ubuser, TRUNC(SYSDATE), to_char(sysdate, 'HH24:MI:SS'));
                    exception
                      when others then
                           DBMS_OUTPUT.put_line('Error '|| sqlerrm);
                    end;
              end;
        else
            begin
              --Grabar Log de datos enviados en tabla incluido el error del sql.
             insert into AQPB902A( AQPB902ACOD,AQPB902AMOD,AQPB902ASUC,AQPB902AMDA,AQPB902APAP,AQPB902ACTA,
                                   AQPB902AOPER,AQPB902ASBOP,AQPB902ATOPE,AQPB902AINST,AQPB902AEMIS,AQPB902ADEST,
                                   AQPB902ACOPI,AQPB902AMESG,AQPB902AASUN,AQPB902ADDIG,AQPB902AERRO,AQPB902AERMG,
                                   AQPB902AUSUR,AQPB902AFECR,AQPB902AHORA)
              values (ln_pgcod, ln_scmod, ln_scsuc, ln_scmda, ln_scpap, ln_sccta, ln_scoper, ln_scsbop, ln_sctope, ln_instancia,
                      '', '', '', '', '', 0, '000', 'NO APLICA DESEMBOLSO DIGITAL.', pv_ubuser, TRUNC(SYSDATE), to_char(sysdate, 'HH24:MI:SS'));
            exception
              when others then
                    DBMS_OUTPUT.put_line('Error '|| sqlerrm);
            end;
        end if;

       end;
end;


procedure sp_cr_envioaprobador (pn_pgcod in number, pn_scmod in number, pn_scsuc in number,
                                pn_scmda in number, pn_scpap in number, pn_sccta in number,
                                pn_scoper in number, pn_scsbop in number, pn_sctope in number,
                                pn_instancia in number, pv_ubuser in varchar2, pd_fecapr in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_envioanalista
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2021.11.30
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Envia correo post-aprobacion al aprobador del credito para D. Digital
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_pgcod ( Codigo Empresa )
    --                              pn_scmod ( Modulo )
    --                              pn_scsuc ( Sucursal )
    --                              pn_scmda ( Moneda )
    --                              pn_scpap ( Papel )
    --                              pn_sccta ( Cuenta )
    --                              pn_scoper ( Operacion )
    --                              pn_scsbop ( Sub Operacion )
    --                              pn_sctope ( Tipo Operacion )
    --                              pn_instancia ( Instancia )
    --                              pc_ubuser ( Usuario que ejecuta )
    --                              pd_fecapr ( Fecha de aprobación )
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 2022.09.07
    -- Autor de la Modificación   : Alonso Pacheco Huachaca
    -- Descripción de Modificación: Parametrizacion de Envio de Correo
    -- *****************************************************************
       ln_pgcod number := 0;
       ln_scmod number := 0;
       ln_scsuc number := 0;
       ln_scmda number := 0;
       ln_scpap number := 0;
       ln_sccta number := 0;
       ln_scoper number := 0;
       ln_scsbop number := 0;
       ln_sctope number := 0;
       ln_instancia number := 0;
       ln_monto number :=0;
       --
       lc_numdoc  varchar2(12) := '';
       lc_score   char(1) := '';
       ln_ddigit  number  := 0;
       ln_exmodu  number  := 0;
       ln_cntcta  number  := 0;
       lv_nombre  varchar2(30) := '';
       lv_modulo  varchar2(30) := '';
       lv_tioper  varchar2(30) := '';
       lv_monto   varchar2(30) := '';
       lv_analist varchar2(10) := '';
       lv_geragen varchar2(10) := '';
       ln_anasuc  number  := 0;
       --
       lv_emisor  varchar2(40) := '';
       lv_destino varchar2(100) := '';
       lv_descopi varchar2(100) := '';
       lv_asunto  varchar2(100) := '';
       ll_mensaje long := '';
       p_c_coderr  varchar2(5);
       p_c_msgerr  varchar2(200);
begin
       --inicializa variables acorde si se envio toda la clave o solo la instancia
       begin
         begin
           if pn_instancia = 0 or pn_instancia is null then
               select xwfprcins, xwfmonto1 into ln_instancia, ln_monto from xwf700
                      where xwfempresa = pn_pgcod and xwfsucursal = pn_scsuc and xwfmodulo = pn_scmod
                        and xwfmoneda = pn_scmda and xwfpapel = pn_scpap and xwfcuenta= pn_sccta
                        and xwfoperacion = pn_scoper and xwfsubope = pn_scsbop and xwftipope = pn_sctope;

               ln_pgcod := pn_pgcod;
               ln_scmod := pn_scmod;
               ln_scsuc := pn_scsuc;
               ln_scmda := pn_scmda;
               ln_scpap := pn_scpap;
               ln_sccta := pn_sccta;
               ln_scoper := pn_scoper;
               ln_scsbop := pn_scsbop;
               ln_sctope := pn_sctope;
           else
               select xwfempresa, xwfsucursal, xwfmodulo, xwfmoneda, xwfpapel,
                      xwfcuenta, xwfoperacion, xwfsubope, xwftipope, xwfmonto1
                    into ln_pgcod, ln_scsuc, ln_scmod, ln_scmda, ln_scpap,
                         ln_sccta, ln_scoper, ln_scsbop, ln_sctope, ln_monto
               from xwf700 where xwfprcins = pn_instancia and xwfcar3 = '1';

               ln_instancia := pn_instancia;
           end if;
       exception
            when others then
                p_c_coderr := '90';
                p_c_msgerr := sqlerrm;
                --Grabar Log de datos enviados en tabla incluido el error del sql.
                begin
                  insert into AQPB902A( AQPB902ACOD,AQPB902AMOD,AQPB902ASUC,AQPB902AMDA,AQPB902APAP,AQPB902ACTA,
                                        AQPB902AOPER,AQPB902ASBOP,AQPB902ATOPE,AQPB902AINST,AQPB902AEMIS,AQPB902ADEST,
                                        AQPB902ACOPI,AQPB902AMESG,AQPB902AASUN,AQPB902ADDIG,AQPB902AERRO,AQPB902AERMG,
                                        AQPB902AUSUR,AQPB902AFECR,AQPB902AHORA)
                  values (pn_pgcod, pn_scmod, pn_scsuc, pn_scmda, pn_scpap, pn_sccta, pn_scoper, pn_scsbop, pn_sctope,
                          pn_instancia, lv_emisor, lv_destino, lv_descopi, ll_mensaje, lv_asunto, 1, p_c_coderr, p_c_msgerr,
                          pv_ubuser, TRUNC(SYSDATE), to_char(sysdate, 'HH24:MI:SS'));
                  return;
                exception
                  when others then
                      DBMS_OUTPUT.put_line('Error '|| sqlerrm);
                      return;
                end;
       end;
       --se valida si aplica o no el desembolso digital
       PQ_CR_CORREOS_DESEMBOLSO_DIGITAL.sp_cr_aplica_desembolso_digital(
                  ln_pgcod, ln_scmod, ln_scsuc, ln_sccta, ln_scoper,
                  ln_scsbop, ln_sctope, ln_monto, ln_instancia, ln_ddigit
       );
       if  ln_ddigit = 1 then
            begin
                select d.penom, trim(e.mdnom), trim(f.tonom),
                       concat(decode(b.xwfmoneda,0,'S/. ','US$ '),b.xwfmonto1),
                       trim(fn_analista_credito(b.xwfmodulo,b.xwfsucursal,b.xwfmoneda,b.xwfpapel,b.xwfcuenta,b.xwfoperacion,b.xwfsubope,b.xwftipope))
                       into lv_nombre, lv_modulo, lv_tioper, lv_monto, lv_analist
                from xwf700 b
                inner join sng001 c on c.sng001inst = b.xwfprcins
                inner join fsd001 d on (d.pepais = c.sng001pais and
                                       d.petdoc = c.sng001tdoc and
                                       d.pendoc = c.sng001ndoc)
                inner join fst003 e on e.modulo = b.xwfmodulo
                inner join fst004 f on f.modulo = b.xwfmodulo and f.totope = b.xwftipope
                where b.xwfprcins = ln_instancia and b.xwfcar3 = '1';

                 --Gerente de agencia y/o aprobador
                select ubsuc into ln_anasuc from fst046 where ubuser = rpad(pv_ubuser, 10, ' ');
                select b.ubuser into lv_geragen from sng057 a, fst046 b
                       where b.ubuser = a.sng057usr and b.ubsuc = ln_anasuc
                         and a.sng055car = 202
                         and rownum = 1;

                if lv_geragen = pv_ubuser then
                   select trim(wfusremail) into lv_destino from wfusers where wfusrcod = rpad(pv_ubuser, 30, ' ');
                else
                   select trim(wfusremail) into lv_destino from wfusers where wfusrcod = rpad(pv_ubuser, 30, ' ');
                   select trim(wfusremail) into lv_descopi from wfusers where wfusrcod = rpad(lv_geragen, 30, ' ');
                end if;

                --select trim(wfusremail) into lv_destino from wfusers where trim(wfusrcod) = lv_analist;
            exception
                when others then
                    p_c_coderr := '94';
                    p_c_msgerr := sqlerrm;
                    --Grabar Log de datos enviados en tabla incluido el error del sql.
                    begin
                      insert into AQPB902A( AQPB902ACOD,AQPB902AMOD,AQPB902ASUC,AQPB902AMDA,AQPB902APAP,AQPB902ACTA,
                                            AQPB902AOPER,AQPB902ASBOP,AQPB902ATOPE,AQPB902AINST,AQPB902AEMIS,AQPB902ADEST,
                                            AQPB902ACOPI,AQPB902AMESG,AQPB902AASUN,AQPB902ADDIG,AQPB902AERRO,AQPB902AERMG,
                                            AQPB902AUSUR,AQPB902AFECR,AQPB902AHORA)
                      values (ln_pgcod, ln_scmod, ln_scsuc, ln_scmda, ln_scpap, ln_sccta, ln_scoper, ln_scsbop, ln_sctope,
                              ln_instancia, lv_emisor, lv_destino, lv_descopi, ll_mensaje, lv_asunto, 1, p_c_coderr, p_c_msgerr,
                              pv_ubuser, TRUNC(SYSDATE), to_char(sysdate, 'HH24:MI:SS'));
                      return;
                    exception
                      when others then
                          DBMS_OUTPUT.put_line('Error '|| sqlerrm);
                    end;
            end;

            lv_emisor := 'notificaciones@cajaarequipa.pe';
            lv_asunto := 'ALERTA: CRÉDITO APROBADO - DESEMBOLSO DIGITAL';
            ll_mensaje := '<html><head><style type="text/css"></style>' ||
            '</head><body><br><p>Estimado.</p>' ||
            '<p>Revisa que el siguiente expediente del crédito contenga la documentación y los formatos completos:
            <ul><li> Cliente: ' || lv_nombre || '
            </li><li> Cuenta Cliente: ' || ln_sccta || '
            </li><li> Fecha de Aprobación: ' || TO_CHAR(pd_fecapr) || '
            </li><li> Módulo y Tipo de Operación: ' || lv_modulo || ' / ' || lv_tioper || '
            </li><li> Monto y moneda: ' || lv_monto ||
            '</ul></p><p>Si hubiera algún faltante en la documentación, regularizar antes de efectuar el desembolso. Evitemos observaciones y llamadas de atención.' ||
            '</p><br><p>' || 'Atte.- <br><br>Caja Arequipa.</p></body></html>';

            begin
                  pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destino,
                                                   p_destinatarioscc   => lv_descopi,
                                                   p_destinatariosbcc  => '',                                                   p_mensaje           => ll_mensaje,
                                                   p_remitente         => lv_emisor,
                                                   p_asunto            => lv_asunto,
                                                   p_tipomensaje       => 'HTML',
                                                   p_directorio        => '',
                                                   p_archivosadjuntos  => '',
                                                   p_c_coderr          => p_c_coderr,
                                                   p_c_deserr          => p_c_msgerr);
                  --Grabar log de datos enviados en tabla
                  insert into AQPB902A( AQPB902ACOD,AQPB902AMOD,AQPB902ASUC,AQPB902AMDA,AQPB902APAP,AQPB902ACTA,
                                        AQPB902AOPER,AQPB902ASBOP,AQPB902ATOPE,AQPB902AINST,AQPB902AEMIS,AQPB902ADEST,
                                        AQPB902ACOPI,AQPB902AMESG,AQPB902AASUN,AQPB902ADDIG,AQPB902AERRO,AQPB902AERMG,
                                        AQPB902AUSUR,AQPB902AFECR,AQPB902AHORA)
                  values (ln_pgcod, ln_scmod, ln_scsuc, ln_scmda, ln_scpap, ln_sccta, ln_scoper, ln_scsbop, ln_sctope,
                          ln_instancia, lv_emisor, lv_destino, lv_descopi, ll_mensaje, lv_asunto, 1, p_c_coderr, p_c_msgerr,
                          pv_ubuser, TRUNC(SYSDATE), to_char(sysdate, 'HH24:MI:SS'));
              exception
                  when others then
                    p_c_coderr := '95';
                    p_c_msgerr := sqlerrm;
                    --Grabar Log de datos enviados en tabla incluido el error del sql.
                    begin
                      insert into AQPB902A( AQPB902ACOD,AQPB902AMOD,AQPB902ASUC,AQPB902AMDA,AQPB902APAP,AQPB902ACTA,
                                            AQPB902AOPER,AQPB902ASBOP,AQPB902ATOPE,AQPB902AINST,AQPB902AEMIS,AQPB902ADEST,
                                            AQPB902ACOPI,AQPB902AMESG,AQPB902AASUN,AQPB902ADDIG,AQPB902AERRO,AQPB902AERMG,
                                            AQPB902AUSUR,AQPB902AFECR,AQPB902AHORA)
                      values (ln_pgcod, ln_scmod, ln_scsuc, ln_scmda, ln_scpap, ln_sccta, ln_scoper, ln_scsbop, ln_sctope,
                              ln_instancia, lv_emisor, lv_destino, lv_descopi, ll_mensaje, lv_asunto, 1, p_c_coderr, p_c_msgerr,
                              pv_ubuser, TRUNC(SYSDATE), to_char(sysdate, 'HH24:MI:SS'));
                    exception
                      when others then
                           DBMS_OUTPUT.put_line('Error '|| sqlerrm);
                    end;
              end;
        else
            begin
              --Grabar Log de datos enviados en tabla incluido el error del sql.
             insert into AQPB902A( AQPB902ACOD,AQPB902AMOD,AQPB902ASUC,AQPB902AMDA,AQPB902APAP,AQPB902ACTA,
                                   AQPB902AOPER,AQPB902ASBOP,AQPB902ATOPE,AQPB902AINST,AQPB902AEMIS,AQPB902ADEST,
                                   AQPB902ACOPI,AQPB902AMESG,AQPB902AASUN,AQPB902ADDIG,AQPB902AERRO,AQPB902AERMG,
                                   AQPB902AUSUR,AQPB902AFECR,AQPB902AHORA)
              values (ln_pgcod, ln_scmod, ln_scsuc, ln_scmda, ln_scpap, ln_sccta, ln_scoper, ln_scsbop, ln_sctope, ln_instancia,
                      '', '', '', '', '', 0, '000', 'NO APLICA DESEMBOLSO DIGITAL.', pv_ubuser, TRUNC(SYSDATE), to_char(sysdate, 'HH24:MI:SS'));
            exception
              when others then
                    DBMS_OUTPUT.put_line('Error '|| sqlerrm);
            end;
        end if;

       end;
end;
procedure sp_cr_aplica_desembolso_digital (pn_pgcod in number, pn_scmod in number, pn_scsuc in number,
                                           pn_sccta in number, pn_scoper in number, pn_scsbop in number,
                                           pn_sctope in number, pn_monto in number, pn_instancia in number, vo_rpta out number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_aplica_desembolso_digital
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2021.11.30
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Valida si aplica desembolso digital
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_pgcod ( Codigo Empresa )
    --                              pn_scmod ( Modulo )
    --                              pn_scsuc ( Sucursal )
    --                              pn_scmda ( Moneda )
    --                              pn_scpap ( Papel )
    --                              pn_sccta ( Cuenta )
    --                              pn_scoper ( Operacion )
    --                              pn_scsbop ( Sub Operacion )
    --                              pn_sctope ( Tipo Operacion )
    -- Parámetros de Salida       : vo_rpta ( Respuesta )
    -- Fecha de Modificación      : --
    -- Autor de la Modificación   : --
    -- Descripción de Modificación: --
    -- *****************************************************************
    lc_numdoc  varchar2(12) := '';
    lc_score   char(1) := '';
    ln_exmodu  number  := 0;
    ln_ddigit  number  := 0;
    ln_param   number  := 0;
    ln_cntcta  number  := 0;

    ln_envcor  number  := 0;
    --
    ln_pgcod number := 0;
    ln_scmod number := 0;
    ln_scsuc number := 0;
    ln_scmda number := 0;
    ln_scpap number := 0;
    ln_sccta number := 0;
    ln_scoper number := 0;
    ln_scsbop number := 0;
    ln_sctope number := 0;
    ln_monto number := 0;

    ln_userEje varchar2(128) := ''; --07/12/2023
    ln_codRpt  number(1) := 0;
begin
       begin
           select xwfempresa, xwfsucursal, xwfmodulo, xwfmoneda, xwfpapel, xwfcuenta, xwfoperacion, xwfsubope, xwftipope, xwfmonto1
                into ln_pgcod, ln_scsuc, ln_scmod, ln_scmda, ln_scpap, ln_sccta, ln_scoper, ln_scsbop, ln_sctope, ln_monto
                from xwf700
           where xwfprcins = pn_instancia and xwfcar3 = '1';
       exception when others then
             ln_scmda := 0;
             ln_scpap := 0;
       end;
       ln_ddigit := 1;

       --guia de deshabilitar envio de correos
       ln_envcor := 0;
       begin
         select tp1nro1 into ln_envcor from fst198
                where tp1cod = 1 and tp1cod1 = 11161 and tp1corr1 = 5
                  and tp1corr2 = 2 and tp1corr3 = 0;
       exception when others then
         ln_envcor := 0;
       end;
       if ln_envcor = 1 then
         --apachecoh 04.02.2022;
         if ln_scmda = 101 then
           select count(*) into ln_ddigit from fst198
                 where tp1cod1 = 10801 and tp1corr1 = 65 and tp1corr2 >= 100
           and tp1corr2 = pn_scmod and tp1corr3 = pn_sctope and pn_monto <= tp1imp2;
         else
           select count(*) into ln_ddigit from fst198
                 where tp1cod1 = 10801 and tp1corr1 = 65 and tp1corr2 >= 100
           and tp1corr2 = pn_scmod and tp1corr3 = pn_sctope and pn_monto <= tp1imp1;
         end if;
         --Validacion de score de cliente
         ln_param := 0;
         begin
           select tp1nro1 into ln_param from fst198
                  where tp1cod = 1 and tp1cod1 = 11161 and tp1corr1 = 5
                    and tp1corr2 = 2 and tp1corr3 = 4;
         exception when others then
           ln_param := 0;
         end;
         if ln_param = 1 then
           begin
                 select pendoc into lc_numdoc from fsr008 where cttfir = 'T' and ctnro = pn_sccta;

                 PQ_CL_SEGUIMIENTO_CLIENTES.sp_cl_score_cliente(lc_numdoc, lc_score);
                 if lc_score = 'N' then
                     ln_ddigit := 0;
                 end if;
           exception when others then
                 ln_ddigit := 0;
           end;
         end if;
         --Validacion de score de cliente

         --apachecoh 15.03.2022 sin cuenta conyugue
         ln_param := 0;
         begin
           select tp1nro1 into ln_param from fst198
                  where tp1cod = 1 and tp1cod1 = 11161 and tp1corr1 = 5
                    and tp1corr2 = 2 and tp1corr3 = 1;
         exception when others then
           ln_param := 0;
         end;
         if ln_param = 1 then
             select count(*) into ln_cntcta from fsr008 where ctnro = pn_sccta;
             if ln_cntcta > 1 then
                 ln_ddigit := 0;
             end if;
         end if;
         --apachecoh 15.03.2022 sin cuenta conyugue

         --apachecoh 15.03.2022 sin garantia
         ln_param := 0;
         begin
           select tp1nro1 into ln_param from fst198
                  where tp1cod = 1 and tp1cod1 = 11161 and tp1corr1 = 5
                    and tp1corr2 = 2 and tp1corr3 = 2;
         exception when others then
           ln_param := 0;
         end;
         if ln_param = 1 then
             select count(*) into ln_cntcta from sng122
                    where sng122inst = pn_instancia
                      and (sng122mod,sng122tope) in
                      (select tp1nro1, tp1nro2 from fst198
                        where tp1cod = 1 and tp1cod1 = 11161 and tp1corr1 = 5
                          and tp1corr2 = 3 and tp1corr3 > 0);
             if ln_cntcta > 0 then
                 ln_ddigit := 0;
             end if;
         end if;
         --apachecoh 15.03.2022 sin garantia

         --apachecoh 15.03.2022 sin aval
         ln_param := 0;
         begin
           select tp1nro1 into ln_param from fst198
                  where tp1cod = 1 and tp1cod1 = 11161 and tp1corr1 = 5
                    and tp1corr2 = 2 and tp1corr3 = 3;
         exception when others then
           ln_param := 0;
         end;
         if ln_param = 1 then
             select count(*) into ln_cntcta from sng003
                    where sng001inst = pn_instancia;
             if ln_cntcta > 0 then
                 ln_ddigit := 0;
             end if;
             select count(*) into ln_cntcta from fsr011
                    where r1cod = pn_pgcod and r1mod = pn_scmod and r1suc = pn_scsuc and r1mda = ln_scmda and r1pap = ln_scpap
                      and r1cta = pn_sccta and r1oper = pn_scoper and r1sbop = pn_scsbop and r1tope = pn_sctope
                      and R011CO = 'S'
                      and relcod = 50;
             if ln_cntcta > 0 then
                 ln_ddigit := 0;
             end if;
         end if;
         --apachecoh 15.03.2022 sin aval

         --guia de exclusión de desembolso digital
         ln_param := 0;
         begin
           select tp1nro1 into ln_param from fst198
                  where tp1cod = 1 and tp1cod1 = 11161 and tp1corr1 = 5
                    and tp1corr2 = 2 and tp1corr3 = 5;
         exception when others then
           ln_param := 0;
         end;
         if ln_param = 1 then
             select count(*) into ln_exmodu from fst198
               where tp1cod1 = 10899 and tp1corr1 = 6000 and tp1corr2 = 11 and tp1corr3 > 0
                 and tp1nro1 = pn_scmod and tp1nro2 = pn_sctope;
             if ln_exmodu > 0 then
                    ln_ddigit := 0;
             end if;
         end if;
         --guia de exclusión de desembolso digital

         --validar score máximo permitido  rcastro 06/12/2023
         ln_param := 0;
         begin
           select tp1nro1 into ln_param from fst198
                  where tp1cod = 1 and tp1cod1 = 11161 and tp1corr1 = 5
                    and tp1corr2 = 2 and tp1corr3 = 7;
         exception when others then
           ln_param := 0;
         end;
         if ln_param = 1 then
            begin
                PQ_CR_CORREOS_DESEMBOLSO_DIGITAL.sp_valid_control_limit_desem_dig(pn_instancia, ln_codRpt );
            exception
              when others then
                ln_codRpt := 0;
            end;

            if ln_codRpt = 0 then
               ln_ddigit := 0;
            end if;
         end if;
         --

       end if;

       --retorna 1 si aplica o 0 si no aplica
       vo_rpta := ln_ddigit;

end sp_cr_aplica_desembolso_digital;


procedure sp_valid_control_limit_desem_dig(instancia in number, codRpta out number) is
    -- *****************************************************************
    -- Nombre                     : sp_valid_control_limit_desem_dig
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.1.04
    -- Autor de Creación          : rcastro
    -- Uso                        : valida controles de nuevos limites en desembolso digital - mismos controles
    --                              que PCK pq_cr_limit_desemb_digital
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : instancia
    --                              codRpta
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 2024.02.06
    -- Autor de la Modificación   : Rcastro
    -- Descripción de Modificación: Se agrega ajustes en valid. plazo y Score
    -- *****************************************************************
auxRpta number(1);
usuarioEje varchar2(10);
ln_plazoX700 number(10,2); --24012024
ln_moduloCred number(4);
ln_plzoMaxGuia number(10,2);
ModelEval   number(4);
p_codRpta     VARCHAR2(4);
p_msg         varchar2(200);
BEGIN
   auxRpta := 0;
   BEGIN
      PQ_CR_CORREOS_DESEMBOLSO_DIGITAL.sp_valid_garantias_reales(instancia, auxRpta);
   EXCEPTION
     WHEN OTHERS THEN
       auxRpta := 1;
   END;

   IF auxRpta = 1 THEN
     BEGIN
       PQ_CR_CORREOS_DESEMBOLSO_DIGITAL.sp_validar_modulos_habilit(instancia,
                                                                   auxRpta);
     EXCEPTION
       WHEN OTHERS THEN
         auxRpta := 1;
     END;
     IF auxRpta = 1 THEN

        BEGIN
          select SNG001USI into usuarioEje from sng001 where sng001inst = instancia and rownum = 1;
        EXCEPTION
          WHEN OTHERS THEN
            usuarioEje := 'TOMCAT';
        END;
        --
        /*BEGIN
          SELECT SNG021TMod
            INTO ModelEval
            FROM SNG021
           WHERE SNG021Sol = instancia;
        EXCEPTION
          WHEN OTHERS THEN
            ModelEval := 0;
        END;
        ModelEval := NVL(ModelEval, 0);*/

        --IF ModelEval <> 14 THEN
        --
          BEGIN
              PQ_CR_CORREOS_DESEMBOLSO_DIGITAL.sp_validar_score(instancia,
                                                                usuarioEje,
                                                                auxRpta);
          EXCEPTION
            WHEN OTHERS THEN
              auxRpta := 1;
          END;
        --END IF;
        ----------validar pplazo max 18 meses 24012024
        IF auxRpta = 1 THEN
           ln_plazoX700 := 0;
           ln_moduloCred := 0;
           BEGIN
                SELECT XWFMODULO, XWFPLAZO1 INTO ln_moduloCred, ln_plazoX700
                  FROM XWF700
                 WHERE XWFPRCINS = instancia
                   AND XWFCAR3 = '1';
           EXCEPTION
            WHEN OTHERS THEN
              NULL;
           END;
           ln_plazoX700 := nvl(ln_plazoX700, 0);
           ln_moduloCred := nvl(ln_moduloCred,0);

           BEGIN
              SELECT TP1NRO3 into ln_plzoMaxGuia FROM FST198 WHERE
              TP1COD = 1 AND
              TP1COD1= 10801 AND
              TP1CORR1= 65 AND
              TP1CORR2= 8 AND
              TP1CORR3 = ln_moduloCred;
           EXCEPTION
             WHEN OTHERS THEN
               ln_plzoMaxGuia := 0;
           END;
           ln_plzoMaxGuia := nvl(ln_plzoMaxGuia, 0);

           IF ln_plazoX700 > ln_plzoMaxGuia THEN
              auxRpta := 0; -- 0 = no aplica, 1 = aplica
           ELSE
              auxRpta := 1;
           END IF;

           IF auxRpta = 1 THEN -- 16122024
              BEGIN
              pq_cr_limit_desemb_digital.sp_valid_aval(instancia,
                                                       p_codRpta,
                                                       p_msg);
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;
              END;

              IF p_codRpta = '0000' THEN
                 auxRpta := 1;
              ELSE
                 auxRpta := 0; --10012025
              END IF;

              IF auxRpta = 1 THEN
                  BEGIN
                         pq_cr_limit_desemb_digital.sp_validar_compraDeuda(instancia,
                                                                           p_codRpta,
                                                                           p_msg);
                  EXCEPTION
                    WHEN OTHERS THEN
                      NULL;
                  END;

                  IF p_codRpta = '0000' THEN
                     auxRpta := 1;
                  ELSE
                     auxRpta := 0; --10012025
                  END IF;

                  IF auxRpta = 1 THEN
                      BEGIN
                         pq_cr_limit_desemb_digital.sp_validar_fondos_gobierno(instancia,
                                                                               p_codRpta,
                                                                               p_msg);
                      EXCEPTION
                        WHEN OTHERS THEN
                          NULL;
                      END;

                      IF p_codRpta = '0000' THEN
                         auxRpta := 1;
                      ELSE
                         auxRpta := 0; --10012025
                      END IF;

                  END IF;
              END IF;
           END IF;

        END IF;
        -----------
     END IF;
   END IF;

   codRpta := auxRpta;

END sp_valid_control_limit_desem_dig;

procedure sp_valid_garantias_reales(instancia in number,
                                    codRpta out number) IS
    cont    number(2);
    mensaje VARCHAR2(200);
    v_flgExcpSolicitud varchar2(1);
    v_Modulo number(3);
    v_tope  number(3);
    v_flgHblCtr varchar2(1);
    nroControl number(3);
BEGIN

 ---01/03/2024 EXCEPTUAR por instancia o mod y transaccion de garantia
  v_flgExcpSolicitud := 'N';
  nroControl := 1;
  BEGIN
     pq_cr_limit_desemb_digital.SP_VALIDAR_EXCEPCIONES_CONTROL(instancia, nroControl,  v_flgExcpSolicitud);
  EXCEPTION
    WHEN OTHERS THEN
    NULL;
  END;
  v_flgExcpSolicitud := NVL(v_flgExcpSolicitud, 'N');
  ------------

  BEGIN
    SELECT XWFMODULO, XWFTIPOPE INTO v_Modulo, v_tope
    FROM XWF700 W WHERE W.XWFPRCINS = instancia AND W.XWFCAR3 = '1';
  EXCEPTION
    WHEN OTHERS THEN
      v_Modulo := 0;
      v_tope   := 0;
  END;

  -----
  IF v_flgExcpSolicitud = 'N' THEN
      BEGIN
        SELECT 'S' INTO v_flgHblCtr FROM FST198 M  WHERE
           M.Tp1cod = 1
           AND M.Tp1cod1 = 11152
           AND M.Tp1corr1 = 80 --for update
           AND M.Tp1corr2 = 3
           AND M.TP1NRO3 = 1;
     EXCEPTION
       WHEN OTHERS THEN
         v_flgHblCtr := 'N';
     END;

      v_flgHblCtr := NVL(v_flgHblCtr, 'N');

     IF v_Modulo = 106 AND v_tope = 91 AND v_flgHblCtr = 'S' THEN
        --VALIDAR que solo tenga garantias por guia
        BEGIN
           SELECT COUNT(1)
              INTO cont
              FROM SNG122 G WHERE
               G.SNG122INST = instancia
               --AND SNG122MOD = 70 AND G.SNG122TOPE <> 90;
               AND (SNG122MOD, SNG122TOPE) NOT IN
                (SELECT M.TP1NRO2,M.TP1NRO3 -- habilit tope 80 RCASTRO 27/08/2024
                 FROM FST198 M  WHERE
                           M.Tp1cod = 1
                           AND M.Tp1cod1 = 11152
                           AND M.Tp1corr1 = 80
                           AND M.Tp1corr2 = 4
                           AND M.TP1CORR3 > 0
             );

        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
     ELSE
            BEGIN
              SELECT COUNT(1)
                INTO cont
                FROM SNG122 G, FST198 K
               WHERE K.Tp1cod = 1
                 AND K.Tp1cod1 = 10897
                 AND K.Tp1corr1 = 500
                 AND K.Tp1corr2 = 1
                 AND K.TP1NRO1 = G.SNG122MOD
                 AND K.TP1NRO2 = G.SNG122TOPE
                 AND G.SNG122INST = instancia
                 AND NOT EXISTS( --exceptuar por mod y tope garantia
                   SELECT * FROM FST198 M  WHERE
                     M.Tp1cod = 1
                     AND M.Tp1cod1 = 11152
                     AND M.Tp1corr1 = 80
                     AND M.Tp1corr2 = 2
                     AND M.TP1CORR3 > 0
                     AND M.TP1NRO2 = G.SNG122MOD
                     AND M.TP1NRO3 = G.SNG122TOPE
                   );
            EXCEPTION
              WHEN OTHERS THEN
                NULL;
            END;
      END IF;

      cont := nvl(cont, 0);
      IF CONT > 0 THEN
         codRpta := 0; -- 0 = no aplica, 1 = aplica
      ELSE
        codRpta := 1;
      END IF;
  ELSE
      codRpta := 1;
  END IF;
END sp_valid_garantias_reales;

procedure sp_validar_modulos_habilit(instancia in number,
                                     codRpta out number) IS
    xrow    number(3);
    mensaje varchar2(200);

    v_Pgcod  number(3);
    v_Scmod  number(4);
    v_Scsuc  number(4);
    v_Scmda  number(4);
    v_Scpap  number(4);
    v_Sccta  number(9);
    v_Scoper number(9);
    v_Scsbop number(3);
    v_Sctope number(3);
  BEGIN
    BEGIN
      pq_cr_limit_desemb_digital.sp_obtener_Credito(instancia => instancia,
                                                    v_Pgcod   => v_Pgcod,
                                                    v_Scmod   => v_Scmod,
                                                    v_Scsuc   => v_Scsuc,
                                                    v_Scmda   => v_Scmda,
                                                    v_Scpap   => v_Scpap,
                                                    v_Sccta   => v_Sccta,
                                                    v_Scoper  => v_Scoper,
                                                    v_Scsbop  => v_Scsbop,
                                                    v_Sctope  => v_Sctope);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;

    BEGIN
      SELECT COUNT(1)
        INTO xrow
        FROM FST198 K
       WHERE K.TP1COD = 1
         AND K.TP1COD1 = 11152
         AND K.tp1corr1 = 70
         AND K.TP1CORR2 = 2
         AND K.TP1CORR3 > 0
         AND K.TP1NRO1 = v_Scmod;
    EXCEPTION
      WHEN OTHERS THEN
        xrow := 0;
    END;
    xrow := nvl(xrow, 0);

    IF xrow > 0 THEN
       codRpta := 0; --0 = no aplica
    ELSE
      codRpta := 1;  --1 = aplica
    END IF;

END;


procedure sp_validar_score(instancia in number,
                           usuarioEje in varchar2,
                           codRpta out number) is
v_pais number(4);
v_tdoc number(3);
v_ndoc varchar2(12);

p_segmRiesg  varchar2(50);
p_riesgoScor varchar2(50);
p_tipoScore  varchar2(50);
p_puntaje    NUMBER(9, 2);
p_fechScore  date;
P_SEGM_MICR  varchar2(30);
P_SEGM_PYME  varchar2(30);
P_SEGM_CONS  varchar2(30);
SegmClient   varchar2(30);

ScoreHabil    varchar2(1);
mensaje       varchar2(200);
v_EsSegmHabil varchar2(1);

v_Pgcod  number(3);
v_Scmod  number(4);
v_Scsuc  number(4);
v_Scmda  number(4);
v_Scpap  number(4);
v_Sccta  number(9);
v_Scoper number(9);
v_Scsbop number(4);
v_Sctope number(4);

v_LetraScore      varchar2(1);
v_NScoreMaxPermit number(2);
v_ValScoreClient  number(2);
v_LetrScoreMin    varchar2(30);

BEGIN
-- Clientes premium o superior con score A,B,C,D,E
BEGIN
  SELECT W.SNG001PAIS, W.SNG001TDOC, W.SNG001NDOC
    INTO v_pais, v_tdoc, v_ndoc
    FROM SNG001 W
   WHERE W.SNG001INST = instancia;
EXCEPTION
  WHEN OTHERS THEN
    v_pais := 0;
    v_tdoc := 0;
    v_ndoc := '';
END;

BEGIN
  pq_cr_limit_desemb_digital.sp_obtener_Credito(instancia => instancia,
                                                v_Pgcod   => v_Pgcod,
                                                v_Scmod   => v_Scmod,
                                                v_Scsuc   => v_Scsuc,
                                                v_Scmda   => v_Scmda,
                                                v_Scpap   => v_Scpap,
                                                v_Sccta   => v_Sccta,
                                                v_Scoper  => v_Scoper,
                                                v_Scsbop  => v_Scsbop,
                                                v_Sctope  => v_Sctope);
END;

--Validar max score para mod y tipo operac permitido
v_NScoreMaxPermit := 0;
BEGIN
  SELECT TP1IMP3
    INTO v_NScoreMaxPermit
    FROM FST198
   WHERE TP1COD = 1
     AND TP1COD1 = 10801
     AND tp1corr1 = 65
     AND TP1CORR2 = v_Scmod
     AND TP1CORR3 = v_Sctope;
EXCEPTION
  WHEN OTHERS THEN
    v_NScoreMaxPermit := 0;
END;

v_NScoreMaxPermit := NVL(v_NScoreMaxPermit, 0);

IF v_NScoreMaxPermit <> 0 THEN --28/08/2024

  v_LetrScoreMin := '';
  BEGIN
    SELECT TP1DESC
      INTO v_LetrScoreMin
      FROM FST198
     WHERE TP1COD = 1
       AND TP1COD1 = 11152
       AND tp1corr1 = 70
       AND TP1CORR2 = 7
       AND TP1CORR3 > 0
       AND TP1NRO3 = v_NScoreMaxPermit;
  EXCEPTION
    WHEN OTHERS THEN
      v_LetrScoreMin := '';
  END;

  v_LetrScoreMin := RPAD(v_LetrScoreMin, 30, ' ');

  --IF v_NScoreMaxPermit > 0 THEN
    -- Obtener el score del cliente
    BEGIN
      PQ_CR_CORREOS_DESEMBOLSO_DIGITAL.SP_CR_OBTENER_SCORE(P_TIPO_DOCUMENTO  => v_tdoc,
                                                    P_NRO_DOCUMENTO   => trim(v_ndoc),
                                                    P_USUARIO_EJECUTA => usuarioEje,
                                                    P_SEGMENTO_RIESGO => p_segmRiesg,
                                                    P_RIESGO_SCORE    => p_riesgoScor,
                                                    P_TIPO_SCORE      => p_tipoScore,
                                                    P_PUNTAJE         => p_puntaje,
                                                    P_FECHA_SCORE     => p_fechScore);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;

    v_LetraScore := substr(trim(p_riesgoScor), 8, 1);
    v_LetraScore := TRIM(v_LetraScore);
    IF TRIM(p_riesgoScor) = 'SIN SCORE' THEN
      v_LetraScore := '';
    END IF;

    v_ValScoreClient := 0;
    BEGIN
      SELECT TP1NRO3
        INTO v_ValScoreClient
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11152
         AND tp1corr1 = 70
         AND TP1CORR2 = 7
         AND TP1CORR3 > 0
         AND TP1DESC = RPAD(v_LetraScore, 30, ' ');
    EXCEPTION
      WHEN OTHERS THEN
        v_ValScoreClient := 0;
    END;

    v_ValScoreClient := NVL(v_ValScoreClient, 0);

    IF (v_ValScoreClient > v_NScoreMaxPermit) OR v_ValScoreClient = 0 THEN -- rcastro Mod 28/11/2023
       codRpta := 0;
    ELSE
      codRpta := 1;
    END IF;
ELSE
  codRpta := 1;
END IF;
END;



PROCEDURE SP_CR_OBTENER_SCORE(P_TIPO_DOCUMENTO  IN  NUMBER,
                                 P_NRO_DOCUMENTO   IN  VARCHAR2,
                                 P_USUARIO_EJECUTA IN  VARCHAR2,
                                 P_SEGMENTO_RIESGO OUT VARCHAR2,
                                 P_RIESGO_SCORE    OUT VARCHAR2,
                                 P_TIPO_SCORE      OUT VARCHAR2,
                                 P_PUNTAJE         OUT NUMBER,
                                 P_FECHA_SCORE     OUT DATE) IS
      V_PROGRAMA     VARCHAR2(50);
      V_PROBAL       NUMBER(9, 7);
      V_NUMERO2      NUMBER(5);
      V_TABLA        VARCHAR2(50);
      V_FECHA_SCORE  DATE;
      V_TIPO_SCORE   VARCHAR2(50);
      V_PUNTAJE      NUMBER(9, 2);
      V_RIESGO_SCORE VARCHAR2(50);
   BEGIN
      V_PROGRAMA := 'BTSERVICE CRU';
      BEGIN
         PQ_CR_SCORE_RCC_DESEM_DIGI.SP_CR_SCOREDNI(ln_inst       => 0,
                                        ln_tdoc       => P_TIPO_DOCUMENTO,
                                        lc_ndoc       => TRIM(P_NRO_DOCUMENTO),
                                        lc_prgm       => V_PROGRAMA,
                                        lc_user       => P_USUARIO_EJECUTA,
                                        lc_score      => V_RIESGO_SCORE,
                                        ln_probal     => V_PROBAL,
                                        lc_SegmRiesgo => P_SEGMENTO_RIESGO,
                                        ln_PDCal      => V_NUMERO2,
                                        lc_tabla      => V_TABLA,
                                        ld_fchscore   => V_FECHA_SCORE);
      EXCEPTION
         WHEN OTHERS THEN
            P_SEGMENTO_RIESGO := NULL;
      END;
      V_TIPO_SCORE := 'CLIENTE NUEVO';
      IF V_TABLA = 'JAQL640' AND (V_PROBAL != 0 AND V_PROBAL != 1 AND V_PROBAL != 1000) THEN
         V_PUNTAJE    := TRUNC((LN((1 - V_PROBAL) / V_PROBAL)) * 77 / LN(2.3) + 350);
         V_TIPO_SCORE := 'CLIENTE DE CAJA AREQUIPA';
      ELSIF V_TABLA = 'JAQL639' AND (V_PROBAL != 0 AND V_PROBAL != 1 AND V_PROBAL != 1000) THEN
         V_PUNTAJE := TRUNC((LN((1 - V_PROBAL) / V_PROBAL)) * 91 / LN(1.7) + 190);
      END IF;
      IF V_PROBAL = 1 THEN
         V_PUNTAJE := 0;
      ELSIF V_PROBAL = 0 THEN
         V_PUNTAJE := 982;
      END IF;
      IF V_PUNTAJE < 122 THEN
         V_PUNTAJE := 122;
      ELSIF V_PUNTAJE > 982 THEN
         V_PUNTAJE := 982;
      END IF;
      IF V_RIESGO_SCORE = 'SIN SCORE' THEN
         V_PUNTAJE := 0.00;
      END IF;
      P_RIESGO_SCORE := TRIM(V_RIESGO_SCORE);
      P_PUNTAJE      := V_PUNTAJE;
      P_TIPO_SCORE   := TRIM(V_TIPO_SCORE);
      P_FECHA_SCORE  := V_FECHA_SCORE;
   END SP_CR_OBTENER_SCORE;

end PQ_CR_CORREOS_DESEMBOLSO_DIGITAL;
/

