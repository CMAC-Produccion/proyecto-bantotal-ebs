create or replace package PQ_CR_ENVIO_CORREOS_PAGOS_CONSECUTIVOS is

  -- Author  : APACHECOH
  -- Created : 13/07/2022 12:30:31
  -- Purpose : Envio de Alertas por Correo de Pagos Consecutivos
  
procedure sp_cr_envioanalista (vi_pgcod in number, vi_hcmod in number, vi_hsucor in number, vi_htran in number,
                               vi_hnrel in number, vi_hfcon in date, vi_ubuser in varchar2, vi_correl in number);
 
procedure sp_cr_obtener_trn_inst(vi_pgcod in number, vi_hcmod in number, vi_hsucor in number, vi_htran in number,
                                 vi_hnrel in number, vi_hfcon in date, vo_instancia out number);
 
                                            
end PQ_CR_ENVIO_CORREOS_PAGOS_CONSECUTIVOS;
/

create or replace package body PQ_CR_ENVIO_CORREOS_PAGOS_CONSECUTIVOS is

procedure sp_cr_envioanalista (vi_pgcod in number, vi_hcmod in number, vi_hsucor in number, vi_htran in number,
                               vi_hnrel in number, vi_hfcon in date, vi_ubuser in varchar2, vi_correl in number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_envioanalista
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.07.14
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Envia correo al analista en pagos consecutivos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : vi_hcmod ( Modulo )
    --                              vi_hsucor ( Sucursal )
    --                              vi_htran ( Transaccion )
    --                              vi_hnrel ( Relacion )
    --                              vi_hfcon ( Fecha )
    --                              vi_ubuser ( Usuario )
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : --
    -- Autor de la Modificación   : --
    -- Descripción de Modificación: --
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
       --
       ln_aqpb922cta number(9) := 0;
       ln_aqpb922ope number(9) := 0; 
       lv_aqpb922doc varchar2(12);
       lv_aqpb922noc varchar2(30);  
       lv_aqpb922ntr varchar2(30);
       lv_aqpb922nco varchar2(50); 
       ld_aqpb922fve date;  
       ln_aqpb922nrc number(4);
       ln_aqpb922moc number(17,2) := 0;
       ln_aqpb922mon number(17,2) := 0;
       ln_aqpb922par number(17,2) := 0;
       ln_aqpb922sap number(17,2) := 0;
       ln_aqpb922sua number(4) := 0;
       lc_numdoc  varchar2(12) := '';
       ln_cntcta  number  := 0;
       lv_nombre  varchar2(30) := '';
       lv_modulo  varchar2(30) := '';
       lv_tioper  varchar2(30) := '';
       --
       lv_monto   varchar2(30) := ''; 
       lv_analist varchar2(10) := '';
       lv_geragen varchar2(10) := '';
       ln_anasuc  number  := 0;
       ln_ddigit  number  := 0;
       --       
       lv_emisor  varchar2(40) := ''; 
       lv_destino varchar2(40) := ''; 
       lv_descopi varchar2(40) := ''; 
       lv_asunto  varchar2(150) := ''; 
       ll_mensaje long := '';
       p_c_coderr  varchar2(5);
       p_c_msgerr  varchar2(200);
begin  
       --inicializa variables acorde si se envio toda la clave o solo la instancia                
       begin
         begin
           select aqpb922cta,aqpb922ope,aqpb922doc,aqpb922nrc,trim(aqpb922ntr),trim(aqpb922nco),trim(aqpb922noc),
                  aqpb922fve,aqpb922moc,aqpb922mon,aqpb922par,aqpb922sap,aqpb922sua
                       into ln_aqpb922cta,ln_aqpb922ope,lv_aqpb922doc,ln_aqpb922nrc,lv_aqpb922ntr,lv_aqpb922nco,lv_aqpb922noc,  
                            ld_aqpb922fve,ln_aqpb922moc,ln_aqpb922mon,ln_aqpb922par,ln_aqpb922sap,ln_aqpb922sua
                  from aqpb922 
                     where aqpb922fee = vi_hfcon  and aqpb922emp = vi_pgcod 
                       and aqpb922sue = vi_hsucor and aqpb922moe = vi_hcmod 
                       and aqpb922tre = vi_htran and aqpb922ree = vi_hnrel;
         exception when others then           
            p_c_coderr := '992';
            p_c_msgerr := substr(sqlerrm,1,250); 
            begin           
              INSERT INTO AQPB922L(aqpb922lfee,aqpb922lemp,aqpb922lsue,aqpb922lmoe,aqpb922ltre,aqpb922lree,
                           aqpb922lflag,aqpb922lerro,aqpb922lermg,aqpb922lusur,aqpb922lfecr,aqpb922lhora,aqpb922lcorre) 
                    VALUES(vi_hfcon,vi_pgcod,vi_hsucor,vi_hcmod,vi_htran,vi_hnrel,1,p_c_coderr,p_c_msgerr,
                           vi_ubuser,TRUNC(SYSDATE),to_char(sysdate, 'HH24:MI:SS'),vi_correl);
            exception when others then
              null;
            end;
         end; 
       end;
       begin   
         begin
              PQ_CR_ENVIO_CORREOS_PAGOS_CONSECUTIVOS.sp_cr_obtener_trn_inst(vi_pgcod, vi_hcmod, vi_hsucor, 
                                                                            vi_htran, vi_hnrel, vi_hfcon, 
                                                                            ln_instancia);     
         exception when others then             
            p_c_coderr := '993';
            p_c_msgerr := substr(sqlerrm,1,250);  
            begin   
              INSERT INTO AQPB922L(aqpb922lfee,aqpb922lemp,aqpb922lsue,aqpb922lmoe,aqpb922ltre,aqpb922lree,
                           aqpb922lcta,aqpb922lope,aqpb922ldoc,aqpb922lnrc,aqpb922lnoc,aqpb922lntr,aqpb922lnco,
                           aqpb922lfve,aqpb922lmoc,aqpb922lmon,aqpb922lpar,aqpb922lsap,aqpb922lemis,aqpb922ldest,
                           aqpb922lcopi,aqpb922lmesg,aqpb922lasun,
                           aqpb922lflag,aqpb922lerro,aqpb922lermg,aqpb922lusur,aqpb922lfecr,aqpb922lhora,aqpb922lcorre) 
                    VALUES(vi_hfcon,vi_pgcod,vi_hsucor,vi_hcmod,vi_htran,vi_hnrel,
                           ln_aqpb922cta,ln_aqpb922ope,lv_aqpb922doc,ln_aqpb922nrc,lv_aqpb922noc,lv_aqpb922ntr,lv_aqpb922nco, 
                           ld_aqpb922fve,ln_aqpb922moc,ln_aqpb922mon,ln_aqpb922par,ln_aqpb922sap,
                           '','','','','',1,p_c_coderr,p_c_msgerr,
                           vi_ubuser,TRUNC(SYSDATE),to_char(sysdate, 'HH24:MI:SS'),vi_correl);
             exception when others then
               null;
             end;
         end;      
       exception
            when others then
                p_c_coderr := '994';
                p_c_msgerr := substr(sqlerrm,1,250);
                begin
                  INSERT INTO AQPB922L(aqpb922lfee,aqpb922lemp,aqpb922lsue,aqpb922lmoe,aqpb922ltre,aqpb922lree,
                         aqpb922lcta,aqpb922lope,aqpb922ldoc,aqpb922lnrc,aqpb922lnoc,aqpb922lntr,aqpb922lnco,
                         aqpb922lfve,aqpb922lmoc,aqpb922lmon,aqpb922lpar,aqpb922lsap,aqpb922lemis,aqpb922ldest,
                         aqpb922lcopi,aqpb922lmesg,aqpb922lasun,aqpb922lins,
                         aqpb922lflag,aqpb922lerro,aqpb922lermg,aqpb922lusur,aqpb922lfecr,aqpb922lhora,aqpb922lcorre) 
                  VALUES(vi_hfcon,vi_pgcod,vi_hsucor,vi_hcmod,vi_htran,vi_hnrel,
                         ln_aqpb922cta,ln_aqpb922ope,lv_aqpb922doc,ln_aqpb922nrc,lv_aqpb922noc,lv_aqpb922ntr,lv_aqpb922nco, 
                         ld_aqpb922fve,ln_aqpb922moc,ln_aqpb922mon,ln_aqpb922par,ln_aqpb922sap,ln_instancia,
                         '','','','','',1,p_c_coderr,p_c_msgerr,
                         vi_ubuser,TRUNC(SYSDATE),to_char(sysdate, 'HH24:MI:SS'),vi_correl);                      
                exception when others then
                  null;
                end; 
       end;
       begin
          select tp1nro1 into ln_ddigit from fst198 
                   where tp1cod1 = 11161 and tp1corr1 = 9 and tp1corr2 = 1;
       exception when others then
         null;
       end;
       --flag para habilitar el envio de correo en caso algun problema
       if  ln_ddigit = 1 then                 
           begin                         
                select ubsuc into ln_anasuc from fst046 where ubuser = rpad(vi_ubuser, 10, ' ');
                select b.ubuser into lv_geragen from sng057 a, fst046 b 
                       where b.ubuser = a.sng057usr and b.ubsuc = ln_anasuc
                         and a.sng055car = 202
                         and rownum = 1; 
                                 
                select trim(wfusremail) into lv_destino from wfusers where wfusrcod = rpad(vi_ubuser, 30, ' ');
                select trim(wfusremail) into lv_descopi from wfusers where wfusrcod = rpad(lv_geragen, 30, ' ');
            exception
                when others then
                    p_c_coderr := '994';
                    p_c_msgerr := substr(sqlerrm,1,250);
                    begin  
                        INSERT INTO AQPB922L(aqpb922lfee,aqpb922lemp,aqpb922lsue,aqpb922lmoe,aqpb922ltre,aqpb922lree,
                                     aqpb922lcta,aqpb922lope,aqpb922ldoc,aqpb922lnoc,aqpb922lntr,aqpb922lnco,
                                     aqpb922lfve,aqpb922lmoc,aqpb922lmon,aqpb922lpar,aqpb922lsap,aqpb922lemis,aqpb922ldest,
                                     aqpb922lcopi,aqpb922lmesg,aqpb922lasun,aqpb922lins,
                                     aqpb922lflag,aqpb922lerro,aqpb922lermg,aqpb922lusur,aqpb922lfecr,aqpb922lhora,aqpb922lcorre) 
                              VALUES(vi_hfcon,vi_pgcod,vi_hsucor,vi_hcmod,vi_htran,vi_hnrel,
                                     ln_aqpb922cta,ln_aqpb922ope,lv_aqpb922doc,lv_aqpb922noc,lv_aqpb922ntr,lv_aqpb922nco, 
                                     ld_aqpb922fve,ln_aqpb922moc,ln_aqpb922mon,ln_aqpb922par,ln_aqpb922sap,ln_instancia,
                                     '','','','','',1,p_c_coderr,p_c_msgerr,
                                     vi_ubuser,TRUNC(SYSDATE),to_char(sysdate, 'HH24:MI:SS'),vi_correl);                       
                    exception              
                      when others then
                          null;
                    end; 
            end;
            
            lv_emisor := 'notificaciones@cajaarequipa.pe';
            lv_asunto := 'ALERTA: El Cliente ' || trim(lv_aqpb922noc) || ' realizo dos pagos consecutivos en Otros Canales';      
            ll_mensaje := '<html><head><style type="text/css"></style>' ||
            '</head><body><p>Estimado.</p>' ||
            '<p>El Cliente ' || lv_aqpb922noc || ' realizo dos pagos consecutivos en otros canales:
            <ul><li> Instancia pertenece al Convenio de: ' || ln_aqpb922nrc || ' - ' || lv_aqpb922nco || '
            </li><li> Cuenta Cliente: ' || ln_aqpb922cta || 
            '</ul></p><p>' || 'Atte.- <br><br>Caja Arequipa.</p></body></html>';                        
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
                  INSERT INTO AQPB922L(aqpb922lfee,aqpb922lemp,aqpb922lsue,aqpb922lmoe,aqpb922ltre,aqpb922lree,
                               aqpb922lcta,aqpb922lope,aqpb922ldoc,aqpb922lnrc,aqpb922lnoc,aqpb922lntr,aqpb922lnco,
                               aqpb922lfve,aqpb922lmoc,aqpb922lmon,aqpb922lpar,aqpb922lsap,aqpb922lins,aqpb922lemis,
                               aqpb922ldest,aqpb922lcopi,aqpb922lmesg,aqpb922lasun,
                               aqpb922lflag,aqpb922lerro,aqpb922lermg,aqpb922lusur,aqpb922lfecr,aqpb922lhora,aqpb922lcorre) 
                        VALUES(vi_hfcon,vi_pgcod,vi_hsucor,vi_hcmod,vi_htran,vi_hnrel,
                               ln_aqpb922cta,ln_aqpb922ope,lv_aqpb922doc,ln_aqpb922nrc,lv_aqpb922noc,lv_aqpb922ntr,lv_aqpb922nco, 
                               ld_aqpb922fve,ln_aqpb922moc,ln_aqpb922mon,ln_aqpb922par,ln_aqpb922sap,ln_instancia,
                               lv_emisor,lv_destino,lv_descopi,ll_mensaje,lv_asunto,1,'000','PAGO POSTERIOR',
                               vi_ubuser,TRUNC(SYSDATE),to_char(sysdate, 'HH24:MI:SS'),vi_correl);                                      
              exception
                  when others then
                    p_c_coderr := '996';
                    p_c_msgerr := substr(sqlerrm,1,250);
                    begin
                      INSERT INTO AQPB922L(aqpb922lfee,aqpb922lemp,aqpb922lsue,aqpb922lmoe,aqpb922ltre,aqpb922lree,
                               aqpb922lcta,aqpb922lope,aqpb922ldoc,aqpb922lnrc,aqpb922lnoc,aqpb922lntr,aqpb922lnco,
                               aqpb922lfve,aqpb922lmoc,aqpb922lmon,aqpb922lpar,aqpb922lsap,aqpb922lins,
                               aqpb922lemis,aqpb922ldest,aqpb922lcopi,aqpb922lmesg,aqpb922lasun,
                               aqpb922lflag,aqpb922lerro,aqpb922lermg,aqpb922lusur,aqpb922lfecr,aqpb922lhora,aqpb922lcorre) 
                        VALUES(vi_hfcon,vi_pgcod,vi_hsucor,vi_hcmod,vi_htran,vi_hnrel,
                               ln_aqpb922cta,ln_aqpb922ope,lv_aqpb922doc,ln_aqpb922nrc,lv_aqpb922noc,lv_aqpb922ntr,lv_aqpb922nco, 
                               ld_aqpb922fve,ln_aqpb922moc,ln_aqpb922mon,ln_aqpb922par,ln_aqpb922sap,ln_instancia,
                               lv_emisor,lv_destino,lv_descopi,ll_mensaje,lv_asunto,1,p_c_coderr,p_c_msgerr,
                               vi_ubuser,TRUNC(SYSDATE),to_char(sysdate, 'HH24:MI:SS'),vi_correl); 
                    exception              
                      when others then
                           null;
                    end; 
              end;
        else  
            begin
              --Grabar Log de datos enviados en tabla incluido el error del sql.
             INSERT INTO AQPB922L(aqpb922lfee,aqpb922lemp,aqpb922lsue,aqpb922lmoe,aqpb922ltre,aqpb922lree,
                       aqpb922lcta,aqpb922lope,aqpb922ldoc,aqpb922lnrc,aqpb922lnoc,aqpb922lntr,aqpb922lnco,
                       aqpb922lfve,aqpb922lmoc,aqpb922lmon,aqpb922lpar,aqpb922lsap,aqpb922lemis,aqpb922ldest,
                       aqpb922lcopi,aqpb922lmesg,aqpb922lasun,aqpb922lins,
                       aqpb922lflag,aqpb922lerro,aqpb922lermg,aqpb922lusur,aqpb922lfecr,aqpb922lhora,aqpb922lcorre) 
                VALUES(vi_hfcon,vi_pgcod,vi_hsucor,vi_hcmod,vi_htran,vi_hnrel,
                       ln_aqpb922cta,ln_aqpb922ope,lv_aqpb922doc,ln_aqpb922nrc,lv_aqpb922noc,lv_aqpb922ntr,lv_aqpb922nco, 
                       ld_aqpb922fve,ln_aqpb922moc,ln_aqpb922mon,ln_aqpb922par,ln_aqpb922sap,ln_instancia,
                       '','','','','',0,'000','NO APLICA POR FLAG',
                       vi_ubuser,TRUNC(SYSDATE),to_char(sysdate, 'HH24:MI:SS'),vi_correl);
            exception              
              when others then
                    DBMS_OUTPUT.put_line('Error '|| substr(sqlerrm,1,250));
            end;                        
        end if;  
end;

procedure sp_cr_obtener_trn_inst(vi_pgcod in number, vi_hcmod in number, vi_hsucor in number, vi_htran in number,
                                 vi_hnrel in number, vi_hfcon in date, vo_instancia out number) is
                                 
    -- *****************************************************************
    -- Nombre                     : sp_cr_obtener_trn_inst
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.07.14
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Envia correo al analista en pagos consecutivos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : vi_hcmod ( Modulo )
    --                              vi_hsucor ( Sucursal )
    --                              vi_htran ( Transaccion )
    --                              vi_hnrel ( Relacion )
    --                              vi_hfcon ( Fecha )
    --                              vi_ubuser ( Usuario )
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : --
    -- Autor de la Modificación   : --
    -- Descripción de Modificación: --
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
    begin
      begin
        --buscar clave de credito
        begin
          select pgcod, hmodul, hsucur, hmda, hpap, hcta, hoper, hsubop, htoper 
                into ln_pgcod, ln_scmod, ln_scsuc, ln_scmda, ln_scpap, 
                     ln_sccta, ln_scoper, ln_scsbop, ln_sctope
                from fsh016 
                   where hcmod = vi_hcmod and hsucor = vi_hsucor and htran = vi_htran 
                     and hnrel = vi_hnrel and hfcon = vi_hfcon and hcord = 10;
          /*select pgcod, modulo, itsucd, moneda, papel, ctnro, itoper, itsubo, ittope
                      into ln_pgcod, ln_scmod, ln_scsuc, ln_scmda, ln_scpap, 
                           ln_sccta, ln_scoper, ln_scsbop, ln_sctope
                      from fsd016
                        where itmod = pn_jaqn76moe and itsuc = pn_jaqn76sue and ittran = pn_jaqn76tre 
                             and itnrel = pn_jaqn76ree and itord = 10;*/
        exception when others then
          begin
             select pgcod, hmodul, hsucur, hmda, hpap, hcta, hoper, hsubop, htoper 
                into ln_pgcod, ln_scmod, ln_scsuc, ln_scmda, ln_scpap, 
                     ln_sccta, ln_scoper, ln_scsbop, ln_sctope
                from fsh016 
                   where hcmod = vi_hcmod and hsucor = vi_hsucor and htran = vi_htran 
                     and hnrel = vi_hnrel and hfcon = vi_hfcon and hcord = 10 and rownum = 1;
          exception when others then
            null;
          end;
        end;
        --buscar la instancia
        begin
          select xwfprcins into vo_instancia
                  from xwf700 
                     where xwfempresa = ln_pgcod and xwfmodulo = ln_scmod and xwfsucursal = ln_scsuc
                       and xwfmoneda = ln_scmda and xwfpapel = ln_scpap and xwfcuenta = ln_sccta 
                       and xwfoperacion = ln_scoper and xwfsubope = ln_scsbop and xwftipope = ln_sctope 
                       and xwfcar3 = '1';
        exception when others then
            begin
              select xwfprcins into vo_instancia
                    from xwf700 
                       where xwfempresa = ln_pgcod and xwfmodulo = ln_scmod and xwfsucursal = ln_scsuc 
                         and xwfmoneda = ln_scmda and xwfpapel = ln_scpap and xwfcuenta = ln_sccta 
                         and xwfoperacion = ln_scoper and xwfsubope = ln_scsbop and xwftipope = ln_sctope 
                         and xwfcar3 = '1' and rownum = 1;
            exception when others then
               vo_instancia := 0;
            end;
        end;
      exception when others then
         vo_instancia := 0;
      end;
end;      
                       
end PQ_CR_ENVIO_CORREOS_PAGOS_CONSECUTIVOS;
/

