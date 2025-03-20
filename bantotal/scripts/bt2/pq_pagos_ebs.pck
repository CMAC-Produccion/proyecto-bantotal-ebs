create or replace package PQ_PAGOS_EBS is

  -- Author  : YLOZADA
  -- Created : 10/04/2014 06:48:18 p.m.
  -- Purpose : 
  -- modificacion : yyampi 25.11.2014 se agrego el procedimient sp_act_pagos_ebs_pol
  -- Public type declarations
  -- Modificacion: SMARQUEZ
  -- Fecha cambio: 30/01/2020
  -- Purpose : Registro de la jaql474 desde sp_registra_devolucionII para el usuario desde panel HAQPA568
  
  Procedure sp_valida_proceso(P_C_CODPRO IN VARCHAR2);
  Procedure sp_carga_pagos(P_D_FECPRO IN DATE,
                           P_C_HORACA IN VARCHAR2,
                           P_N_TOTPCC out number,
                           P_N_TOTPCE out number
                           );
  
  procedure sp_act_pagos_ebs(P_C_TIPPRO IN VARCHAR2,  
                             P_C_CODACT IN VARCHAR2,  
                             P_N_CODIDE IN NUMBER,    
                             P_C_ESTOPE IN VARCHAR2,  
                             P_D_FECPRO IN DATE,      
                             P_N_CODERR IN NUMBER,    
                             P_C_MOTERR IN VARCHAR2,  
                             P_N_PGRCOD IN NUMBER,    
                             P_N_SUCURS IN NUMBER,    
                             P_N_MODULO IN NUMBER,    
                             P_N_TRASAC IN NUMBER,    
                             P_N_RELACI IN NUMBER,
                             P_C_HORARI IN VARCHAR2,
                             P_C_TIPTRA IN VARCHAR2                                  
                            );
                            
  Procedure sp_valida_abono(P_N_TPNRO  IN NUMBER,
                            P_N_TPIMP  IN NUMBER,
                            P_D_FECPRO IN DATE,
                            p_n_toppcc out number,
                            p_n_toaccc out number,
                            p_n_toppee out number,
                            p_n_toacee out number,
                            p_c_horari out varchar2                                                                                               
                            );
  Procedure sp_registra_devolucion(P_N_NUMPAI     IN NUMBER,
                                   P_N_TIPDOC     IN NUMBER,
                                   P_N_NUMDOC     IN NUMBER,
                                   P_C_TIPDEV     IN VARCHAR2,
                                   P_C_NUMNEC     IN VARCHAR2,
                                   P_C_DESCRI     IN VARCHAR2,
                                   P_N_CODMON     IN NUMBER,
                                   P_N_MONDEV     IN NUMBER,
                                   P_N_CODIDE     OUT NUMBER,
                                   P_N_CODIID     OUT NUMBER,                                   
                                   P_C_ERROR      OUT VARCHAR2
                                   );  
  Procedure sp_act_devolucion(P_N_CODIDE     IN NUMBER,
                              P_N_CODPGC     IN NUMBER,
                              P_N_CODMOD     IN NUMBER,
                              P_N_CODTRA     IN NUMBER,
                              P_N_CODREL     IN NUMBER,
                              P_N_CODSUC     IN NUMBER,
                              P_N_DESERR     IN VARCHAR2,
                              P_C_ERROR      OUT VARCHAR2
                             );                  
  Procedure sp_carga_manual;
  
   procedure sp_act_pagos_ebs_pol(P_C_TIPPRO IN VARCHAR2,  --tipo de proceso pago o extorno P / E
                               P_C_CODACT IN VARCHAR2,  --codigo de actualizacion
                               P_N_CODIDE IN NUMBER,    --id de pago
                               --estado de la operacion realizada C=correcta E=erronea
                               P_D_FECPRO IN DATE,      -- fecha de proceso        
                               P_N_CODERR IN NUMBER,    -- Codigo de error
                               P_C_MOTERR IN VARCHAR2,  -- Motivo del error
                               P_N_PGRCOD IN NUMBER,    -- Codigo de empresa Pgcod
                               P_N_SUCURS IN NUMBER,    -- Sucursal del pago
                               P_N_MODULO IN NUMBER,    -- Modulo
                               P_N_TRASAC IN NUMBER,    -- Transaccion
                               P_N_RELACI IN NUMBER,    -- Relacion                        
                               P_C_HORARI IN VARCHAR2,   -- Horario de proceso
                               P_C_TIPTRA IN VARCHAR2   -- Tipo de transaccion B=batch V=Ventanilla
                              );
 Procedure sp_anula_pago(P_N_ID     IN NUMBER,
                         P_D_FECPRO IN DATE,         
                         P_C_ERROR  OUT VARCHAR2
                        );  
---------------------------------------------------------------------------
  Procedure sp_registra_devolucionII(P_N_NUMPAI     IN NUMBER,
                                     P_N_TIPDOC     IN NUMBER,
                                     P_N_NUMDOC     IN varchar2,
                                     P_N_CODIID     IN NUMBER,                                     
                                     P_C_TIPDEV     IN VARCHAR2,
                                     P_C_NUMNEC     IN VARCHAR2,
                                     P_C_DESCRI     IN VARCHAR2,
                                     P_N_CODMON     IN NUMBER,
                                     P_N_MONDEV     IN NUMBER,
                                     P_N_CODIDE     OUT NUMBER,
                                     P_C_ERROR      out varchar2
                                     );                                                    
  
end PQ_PAGOS_EBS;
/

create or replace package body PQ_PAGOS_EBS is


  -- Function and procedure implementations
  Procedure sp_valida_proceso(p_c_codpro in varchar2
                              ) is     
  cursor c_mail(p_n_tpnro in number) is
  select *
    from fst098
   where pgcod = 1
     and tpcod = 7664
     and tpnro = p_n_tpnro;
     
  lc_error varchar2(400);
  ll_mensaje CLOB;
  lv_mensaje VARCHAR2(32767);            
  lc_horini  char(8);             
  lc_horfin  char(8); 
  lc_horcar  char(8);
  lc_horari  varchar2(30);    
  lc_flag    char(1);      
  ld_fecpro date;   
  ln_pagcar number;
  ln_pagnca number;
  ln_indcar number;
  
  ln_toppcc number;
  ln_toaccc number; 
  ln_toppee number;
  ln_toacee number;  
  lc_horario varchar2(30);  
  --ln_diapro number;
   
  begin
  
  ld_fecpro := trunc(sysdate); 
  --ln_diapro := to_char(sysdate,'D');   
  dbms_lob.createtemporary(ll_mensaje, TRUE);  
  
      If p_c_codpro = 'C' then
         lc_flag := 'N';
         for i in c_mail(1) loop   
           lc_horari := i.tpdesc;
           lc_horcar := to_char(SYSDATE, 'HH24:MI:SS');
           lc_horini := substr(lc_horari,1,8);
           lc_horfin := substr(lc_horari,10,8);
            
             If  lc_horcar >=lc_horini and lc_horcar<=lc_horfin then
                 lc_flag := 'S';
                 Exit;
             End If;             
         End Loop;
         
         If lc_flag = 'S' /*and ln_diapro not in (1,7)*/  then      
             -- ejecutar copiado            
             pq_pagos_ebs.sp_carga_pagos(ld_fecpro,lc_horari,ln_pagcar,ln_pagnca);  
                                                                     
            -- armado del cuerpo del mensaje                          
              lv_mensaje := '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">Estimado(a)(s) : </p>' ||  
                            '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">'|| 'Usuario' || '</p>' ||
                            '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">De acuerdo a lo solicitado adjunto detalle de la carga de Pagos EBS - Bantotal</p><br/>';  
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                           
                            
              lv_mensaje := --ll_mensaje ||                                                
              '<style  type="text/css">td {font-family:''Courier New'', Courier, monospace; font-size:13px}</style>' ||
              '<table cellspacing=0 cellpadding=0 width=400>' ||
              '  <tr>' ||
              '    <td align="left">Fecha de Carga:</td>' ||
              '    <td align="left">'||to_char(ld_fecpro, 'DD/MM/YY') ||'</td>' ||
              '  </tr>    ' ||
              '  <tr>    ' ||
              '    <td align="left">Hora de Carga: </td>' ||
              '    <td align="left">'||to_char(SYSDATE, 'HH24:MI:SS')||'</td>  ' ||          
              '  </tr>' ||
              '  <tr>    ' ||
              '    <td align="left">Horario de carga : </td>' ||
              '    <td align="left">'||lc_horari||'</td>  ' ||          
              '  </tr>' ||                        
              '  <tr>' ||
              '    <td align="left">Carga de Pagos Correctos :</td>' ||
              '    <td align="left">'|| ln_pagcar ||'</td>' ||
              '  </tr>' ||     
              '  <tr>' ||
              '    <td align="left">Carga de Pagos Erroneos :</td>' ||
              '    <td align="left">'|| ln_pagnca ||'</td>' ||          
              '  </tr>    '||
              '  </table>    '||
              '<br/>'||
              '<br/>'||         
              '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">Saludos Cordiales<br/>Caja Arequipa</p>';
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                                   
             
            -- envio de mail a los interesados
            for i in c_mail(3) loop
             begin
             
               sys.sp_sy_enviamail_html(pc_aquien => i.tpdesc,
                                        pc_de => 'informatica@cajaarequipa.pe',
                                        pc_motivo => 'Carga de Pagos EBS - Bantotal',
                                        pc_mensaje => ll_mensaje
                                       );   
             -- registrar log de envio de notificaciones                                   
             exception
             when others then
             lc_error:= sqlcode||'-'||sqlerrm; 
             -- registrar log de envio de notificaciones
             end;
                          
          end loop;  
        end If;        
         
      else         
         lc_flag := 'N';
         for i in c_mail(5) loop   
           lc_horari := i.tpdesc;
           lc_horcar := to_char(SYSDATE, 'HH24:MI:SS');
           lc_horini := substr(lc_horari,1,8);
           lc_horfin := substr(lc_horari,10,8);
            
             If  lc_horcar >=lc_horini and lc_horcar<=lc_horfin then
                 lc_flag := 'S';
                 ln_indcar := i.tpimp;
                 Exit;
             End If;             
         end Loop;
         
         If lc_flag = 'S' /*and ln_diapro not in (1,7)*/ then                
            -- Validar que se haya eejecutado la carga de los pagos 
            
            pq_pagos_ebs.sp_valida_abono(2,ln_indcar,ld_fecpro,ln_toppcc,ln_toaccc,ln_toppee,ln_toacee,lc_horario);
        
            -- envio de mail a los interesados
        
            -- armado del cuerpo del mensaje                          
              lv_mensaje := '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">Estimado(a)(s) : </p>' ||  
                            '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">'|| 'Usuario' || '</p>' ||
                            '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">De acuerdo a lo solicitado adjunto detalle Pagos/Abono a cuenta realizados en Bantotal</p><br/>';  
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                           
                            
              lv_mensaje := --ll_mensaje ||                                                
              '<style  type="text/css">td {font-family:''Courier New'', Courier, monospace; font-size:13px}</style>' ||
              '<table cellspacing=0 cellpadding=0 width=400>' ||
              '  <tr>' ||
              '    <td align="left">Fecha de Proceso:</td>' ||
              '    <td align="left">'||to_char(ld_fecpro, 'DD/MM/YY') ||'</td>' ||
              '  </tr>    ' ||
              '  <tr>    ' ||
              '    <td align="left">Hora de Proceso: </td>' ||
              '    <td align="left">'||to_char(SYSDATE, 'HH24:MI:SS')||'</td>  ' ||          
              '  </tr>' ||
              '  <tr>    ' ||
              '    <td align="left">Horario de Proceso: </td>' ||
              '    <td align="left">'||lc_horario||'</td>  ' ||          
              '  </tr>' ||              
              '  <tr>    ' ||
              '    <td align="left">Horario de Notificación : </td>' ||
              '    <td align="left">'||lc_horari||'</td>  ' ||          
              '  </tr>' ||                        
              '  <tr>' ||
              '    <td align="left">Total Abonos Correctos :</td>' ||
              '    <td align="left">'|| ln_toaccc ||'</td>' ||
              '  </tr>' ||                   
              '  <tr>' ||
              '    <td align="left">Total Abonos Erroneos :</td>' ||
              '    <td align="left">'|| ln_toacee ||'</td>' ||          
              '  </tr>    '||
                     
              '  <tr>' ||
              '    <td align="left">Total Pagos Correctos :</td>' ||
              '    <td align="left">'|| ln_toppcc ||'</td>' ||
              '  </tr>' ||     
              '  <tr>' ||
              '    <td align="left">Total Pagos Erroneos :</td>' ||
              '    <td align="left">'|| ln_toppee ||'</td>' ||          
              '  </tr>    '||
              '  </table>    '||
              '<br/>'||
              '<br/>'||         
              '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">Saludos Cordiales<br/>Caja Arequipa</p>';
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                                   
        
              for i in c_mail(4) loop
               begin
               
                 sys.sp_sy_enviamail_html(pc_aquien => i.tpdesc,
                                          pc_de => 'informatica@cajaarequipa.pe',
                                          pc_motivo => 'Batch de Abono ERC cuenta / pago Provedores cuenta',
                                          pc_mensaje => ll_mensaje
                                         );   
                     -- registrar log de envio de notificaciones                                   
               exception
               when others then
               lc_error:= sqlcode||'-'||sqlerrm; 
               -- registrar log de envio de notificaciones
               end;         
              end loop;  
         end If;               
      end If; 
  end;

  Procedure sp_carga_pagos(P_D_FECPRO IN DATE,
                           P_C_HORACA IN VARCHAR2,
                           P_N_TOTPCC out number,
                           P_N_TOTPCE out number
                           ) is
  cursor c_pagos is
  select ID                        ,
         CHECKRUN_ID               ,
         CHECKRUN_NAME             ,
         CHECK_NUMBER              ,
         CURRENCY_CODE             ,
         AMOUNT                    ,
         LAST_UPDATE_BY            ,
         LAST_UPDATE_DATE          ,
         CREATED_BY                ,
         CREATED_DATE              ,
         VENDOR_ID                 ,
         VENDOR_SITE_ID            ,
         VENDOR_NUM                ,
         VENDOR_NAME               ,
         BANK_ACCOUNT_NUM          ,
         BANK_ACCOUNT_TYPE         ,
         PAYMENT_METHOD_CODE       ,
         PAYMENT_BANK_ACCOUNT_NAME ,
         INVOICE_ID                ,
         INVOICE_NUM               ,
         DOC_TYPE                  ,
         NUMERO_REGISTRO           ,
         INVOICE_DESCRIPTION       ,
         STATUS_PROCESS            ,
         DATE_PROCESS              ,
         STATUS_PAYMENT            ,
         DATE_PAYMENT              ,
         ORG_ID                    ,
         HOLD_REASON_CODE          ,
         HOLD_OUTPUT               ,
         PAYMENT_DOCUMENT_CODE     ,
         PAYMENT_DOCUMENT_NAME     ,
         STATUS_LOOKUP_CODE        ,
         TIPO_GASTO                ,
         ESTADO_RGJ                
    from TS_AP_CA_DET_PAGOS_INT@erp a
   where a.status_process is null
     and payment_document_code in
         (select substr(tpdesc, 1, 2)
            from fst098
           where PGCOD = 1
             AND TPCOD = 7664
             and tpnro = 8);
             
  ld_fecpro date;
  lc_horaca varchar2(30);
  ln_pagcar number;
  ln_pagnca number;
  lc_error varchar2(400);
  begin
  ld_fecpro := P_D_FECPRO;
  lc_horaca := P_C_HORACA;
  ln_pagcar := 0;
  ln_pagnca := 0;

  for i in c_pagos loop
      begin
        insert into jaql472(ID                        ,                     
                            CHECKRUN_ID               ,
                            CHECKRUN_NAME             ,
                            CHECK_NUMBER              ,
                            CURRENCY_CODE             ,
                            AMOUNT                    ,
                            LAST_UPDATE_BY            ,
                            LAST_UPDATE_DATE          ,
                            CREATED_BY                ,
                            CREATED_DATE              ,
                            VENDOR_ID                 ,
                            VENDOR_SITE_ID            ,
                            VENDOR_NUM                ,
                            VENDOR_NAME               ,
                            BANK_ACCOUNT_NUM          ,
                            BANK_ACCOUNT_TYPE         ,
                            PAYMENT_METHOD_CODE       ,
                            PAYMENT_BANK_ACCOUNT_NAME ,
                            INVOICE_ID                ,
                            INVOICE_NUM               ,
                            DOC_TYPE                  ,
                            NUMERO_REGISTRO           ,
                            INVOICE_DESCRIPTION       ,
                            STATUS_PROCESS            ,
                            DATE_PROCESS              ,
                            STATUS_PAYMENT            ,
                            DATE_PAYMENT              ,
                            ORG_ID                    ,
                            HOLD_REASON_CODE          ,
                            HOLD_OUTPUT               ,
                            PAYMENT_DOCUMENT_CODE     ,
                            PAYMENT_DOCUMENT_NAME     ,
                            STATUS_LOOKUP_CODE        ,
                            TIPO_GASTO                ,
                            ESTADO_RGJ                ,
                            FECHA_CARGA               ,
                            HORA_CARGA                ,
                            HORARIO_CARGA             
                           )
                     values(i.ID                        ,
                            i.CHECKRUN_ID               ,
                            i.CHECKRUN_NAME             ,
                            i.CHECK_NUMBER              ,
                            i.CURRENCY_CODE             ,
                            i.AMOUNT                    ,
                            i.LAST_UPDATE_BY            ,
                            i.LAST_UPDATE_DATE          ,
                            i.CREATED_BY                ,
                            i.CREATED_DATE              ,
                            i.VENDOR_ID                 ,
                            i.VENDOR_SITE_ID            ,
                            i.VENDOR_NUM                ,
                            i.VENDOR_NAME               ,
                            i.BANK_ACCOUNT_NUM          ,
                            i.BANK_ACCOUNT_TYPE         ,
                            i.PAYMENT_METHOD_CODE       ,
                            i.PAYMENT_BANK_ACCOUNT_NAME ,
                            i.INVOICE_ID                ,
                            i.INVOICE_NUM               ,
                            i.DOC_TYPE                  ,
                            i.NUMERO_REGISTRO           ,
                            i.INVOICE_DESCRIPTION       ,
                            i.STATUS_PROCESS            ,
                            i.DATE_PROCESS              ,
                            i.STATUS_PAYMENT            ,
                            i.DATE_PAYMENT              ,
                            i.ORG_ID                    ,
                            i.HOLD_REASON_CODE          ,
                            i.HOLD_OUTPUT               ,
                            i.PAYMENT_DOCUMENT_CODE     ,
                            i.PAYMENT_DOCUMENT_NAME     ,
                            i.STATUS_LOOKUP_CODE        ,
                            i.TIPO_GASTO                ,
                            i.ESTADO_RGJ                ,
                            ld_fecpro                   ,
                            to_char(SYSDATE, 'HH24:MI:SS'),
                            lc_horaca             
                           );
      
      pq_pagos_ebs.sp_act_pagos_ebs('C','P',i.ID,'C',ld_fecpro,null,null,null,null,null,null,null,null,null);
      ln_pagcar := ln_pagcar + 1;                  
      exception
      when others then
      ln_pagnca := ln_pagnca+ 1;
      lc_error  := sqlerrm;
      end;    
        
      commit;
      
      -- Generamos Histórico de lo cargado
      begin
        insert into jaql473(HID                        ,                     
                            HCHECKRUN_ID               ,
                            HCHECKRUN_NAME             ,
                            HCHECK_NUMBER              ,
                            HCURRENCY_CODE             ,
                            HAMOUNT                    ,
                            HLAST_UPDATE_BY            ,
                            HLAST_UPDATE_DATE          ,
                            HCREATED_BY                ,
                            HCREATED_DATE              ,
                            HVENDOR_ID                 ,
                            HVENDOR_SITE_ID            ,
                            HVENDOR_NUM                ,
                            HVENDOR_NAME               ,
                            HBANK_ACCOUNT_NUM          ,
                            HBANK_ACCOUNT_TYPE         ,
                            HPAYMENT_METHOD_CODE       ,
                            HPAYMENT_BANK_ACCOUNT_NAME ,
                            HINVOICE_ID                ,
                            HINVOICE_NUM               ,
                            HDOC_TYPE                  ,
                            HNUMERO_REGISTRO           ,
                            HINVOICE_DESCRIPTION       ,
                            HSTATUS_PROCESS            ,
                            HDATE_PROCESS              ,
                            HSTATUS_PAYMENT            ,
                            HDATE_PAYMENT              ,
                            HORG_ID                    ,
                            HHOLD_REASON_CODE          ,
                            HHOLD_OUTPUT               ,
                            HPAYMENT_DOCUMENT_CODE     ,
                            HPAYMENT_DOCUMENT_NAME     ,
                            HSTATUS_LOOKUP_CODE        ,
                            HTIPO_GASTO                ,
                            HESTADO_RGJ                ,
                            HFECHA_CARGA               ,
                            HHORA_CARGA                ,
                            HHORARIO_CARGA             
                           )
                     values(i.ID                        ,
                            i.CHECKRUN_ID               ,
                            i.CHECKRUN_NAME             ,
                            i.CHECK_NUMBER              ,
                            i.CURRENCY_CODE             ,
                            i.AMOUNT                    ,
                            i.LAST_UPDATE_BY            ,
                            i.LAST_UPDATE_DATE          ,
                            i.CREATED_BY                ,
                            i.CREATED_DATE              ,
                            i.VENDOR_ID                 ,
                            i.VENDOR_SITE_ID            ,
                            i.VENDOR_NUM                ,
                            i.VENDOR_NAME               ,
                            i.BANK_ACCOUNT_NUM          ,
                            i.BANK_ACCOUNT_TYPE         ,
                            i.PAYMENT_METHOD_CODE       ,
                            i.PAYMENT_BANK_ACCOUNT_NAME ,
                            i.INVOICE_ID                ,
                            i.INVOICE_NUM               ,
                            i.DOC_TYPE                  ,
                            i.NUMERO_REGISTRO           ,
                            i.INVOICE_DESCRIPTION       ,
                            i.STATUS_PROCESS            ,
                            i.DATE_PROCESS              ,
                            i.STATUS_PAYMENT            ,
                            i.DATE_PAYMENT              ,
                            i.ORG_ID                    ,
                            i.HOLD_REASON_CODE          ,
                            i.HOLD_OUTPUT               ,
                            i.PAYMENT_DOCUMENT_CODE     ,
                            i.PAYMENT_DOCUMENT_NAME     ,
                            i.STATUS_LOOKUP_CODE        ,
                            i.TIPO_GASTO                ,
                            i.ESTADO_RGJ                ,
                            ld_fecpro                   ,
                            to_char(SYSDATE, 'HH24:MI:SS'),
                            lc_horaca             
                           );
      exception
      when others then
           null;
      end; 
      commit; 
  end loop;
  
  P_N_TOTPCC := ln_pagcar;
  P_N_TOTPCE := ln_pagnca;
  
  end sp_carga_pagos;  
  
  procedure sp_act_pagos_ebs(P_C_TIPPRO IN VARCHAR2,  --tipo de proceso carga o pago
                             P_C_CODACT IN VARCHAR2,  --codigo de actualizacion
                             P_N_CODIDE IN NUMBER,    --id de pago
                             P_C_ESTOPE IN VARCHAR2,  --estado de la operacion realizada C=correcta E=erronea
                             P_D_FECPRO IN DATE,      -- fecha de proceso        
                             P_N_CODERR IN NUMBER,    -- Codigo de error
                             P_C_MOTERR IN VARCHAR2,  -- Motivo del error
                             P_N_PGRCOD IN NUMBER,    -- Codigo de empresa Pgcod
                             P_N_SUCURS IN NUMBER,    -- Sucursal del pago
                             P_N_MODULO IN NUMBER,    -- Modulo
                             P_N_TRASAC IN NUMBER,    -- Transaccion
                             P_N_RELACI IN NUMBER,    -- Relacion                        
                             P_C_HORARI IN VARCHAR2,   -- Horario de proceso
                             P_C_TIPTRA IN VARCHAR2   -- Tipo de transaccion B=batch V=Ventanilla
                            ) IS
  ln_numid number := 0;                            
  begin
  
  If P_C_TIPPRO = 'C' then
     begin
         update TS_AP_CA_DET_PAGOS_INT@erp a
            set a.STATUS_PROCESS = P_C_CODACT
          where a.id = P_N_CODIDE;
     exception
     when others then
          null;       
     end;                   
  else
       If P_C_TIPTRA = 'B' then  --BATCH
           -- obtenemos el id de proceso
           begin
             select max(idprocess) 
               into ln_numid 
               from jaql472 a 
              where a.payment_document_code in ('SE','EE')
                and a.date_payment = P_D_FECPRO
                and a.horario_pago = P_C_HORARI;
           exception     
           when no_data_found then
                begin
                   select max(idprocess) 
                     into ln_numid 
                     from jaql472 a 
                    where a.payment_document_code in ('SE','EE');                          
                exception     
                when others then            
                     null;
                end;             
           end;
           if ln_numid is null then
              ln_numid := 1;
           End If;  
           
          If P_C_ESTOPE = 'C' then     
                 begin
                     update TS_AP_CA_DET_PAGOS_INT@erp a
                        set a.STATUS_PAYMENT = P_C_CODACT, --E
                            a.DATE_PAYMENT = P_D_FECPRO   -- sysdate              
                     where a.id = P_N_CODIDE;
                 exception
                 when others then
                      null;       
                 end;   
                                      
                 begin
                     update JAQL472 a
                        set a.codigo         = P_N_PGRCOD, 
                            a.sucursal       = P_N_SUCURS,
                            a.cod_mod        = P_N_MODULO,
                            a.transaccion    = P_N_TRASAC,
                            a.relacion       = P_N_RELACI,
                            a.date_payment   = P_D_FECPRO,
                            a.hora_pago      = to_char(sysdate,'HH24:mi:ss'),
                            a.horario_pago   = P_C_HORARI,
                            a.idprocess      = ln_numid,
                            a.STATUS_PAYMENT = P_C_CODACT, --E      
                            a.status_process = 'P',    
                            a.jaql472ext     = 'N'                   
                     where a.id = P_N_CODIDE;
                 exception
                 when others then
                      null;       
                 end; 
                           
          else
                 If P_N_PGRCOD = 0 then
                 
                     begin
                         update TS_AP_CA_DET_PAGOS_INT@erp a
                            set a.STATUS_PAYMENT = null, --NULO X EXTORNO
                                a.DATE_PAYMENT = null,   -- sysdate   
                                a.HOLD_REASON_CODE = null,
                                a.HOLD_OUTPUT = null           
                         where a.id = P_N_CODIDE;
                     exception
                     when others then
                          null;       
                     end;     
                     
                     begin
                         update JAQL472 a
                            set a.codigo           = null, 
                                a.sucursal         = null,
                                a.cod_mod          = null,
                                a.transaccion      = null,
                                a.relacion         = null,
                                a.date_payment     = null,
                                a.hora_pago        = null,
                                a.horario_pago     = null,
                                a.moterror         = null,
                                a.idprocess        = null,
                                a.STATUS_PAYMENT   = null, --R    
                                a.HOLD_REASON_CODE = null,
                                a.hold_output      = null,
                                a.status_process   = null, --P
                                a.JAQL472EXT       = 'S',                  
                                a.JAQL472AX7       = P_D_FECPRO                                
                         where a.id = P_N_CODIDE;
                     exception
                     when others then
                          null;       
                     end;                                    
                 Else
                 
                     begin
                         update TS_AP_CA_DET_PAGOS_INT@erp a
                            set a.STATUS_PAYMENT = P_C_CODACT, --R
                                a.DATE_PAYMENT = P_D_FECPRO,   -- sysdate   
                                a.HOLD_REASON_CODE = P_N_CODERR,
                                a.HOLD_OUTPUT = P_C_MOTERR           
                         where a.id = P_N_CODIDE;
                     exception
                     when others then
                          null;       
                     end;     
                     
                     begin
                         update JAQL472 a
                            set a.codigo           = P_N_PGRCOD, 
                                a.sucursal         = P_N_SUCURS,
                                a.cod_mod          = P_N_MODULO,
                                a.transaccion      = P_N_TRASAC,
                                a.relacion         = P_N_RELACI,
                                a.date_payment     = P_D_FECPRO,
                                a.hora_pago        = to_char(sysdate,'HH24:mi:ss'),
                                a.horario_pago     = P_C_HORARI,
                                a.moterror         = P_C_MOTERR,
                                a.idprocess        = ln_numid,
                                a.STATUS_PAYMENT   = P_C_CODACT, --R    
                                a.HOLD_REASON_CODE = P_N_CODERR,
                                a.hold_output      = P_C_MOTERR,
                                a.status_process   = 'P',
                                a.jaql472ext       = 'N'                                            
                         where a.id = P_N_CODIDE;
                     exception
                     when others then
                          null;       
                     end;  
                 End if;      
          end if;                
      else
           ln_numid := 0;
           If P_C_ESTOPE = 'C' then     
                 begin
                     update TS_AP_CA_DET_PAGOS_INT@erp a
                        set a.STATUS_PAYMENT = P_C_CODACT, --E
                            a.DATE_PAYMENT = P_D_FECPRO   -- sysdate              
                     where a.id = P_N_CODIDE;
                 exception
                 when others then
                      null;       
                 end;   
                                      
                 begin
                     update JAQL472 a
                        set a.codigo         = P_N_PGRCOD, 
                            a.sucursal       = P_N_SUCURS,
                            a.cod_mod        = P_N_MODULO,
                            a.transaccion    = P_N_TRASAC,
                            a.relacion       = P_N_RELACI,
                            a.date_payment   = P_D_FECPRO,
                            a.hora_pago      = to_char(sysdate,'HH24:mi:ss'),
                            a.horario_pago   = P_C_HORARI,
                            a.idprocess      = ln_numid,
                            a.STATUS_PAYMENT = P_C_CODACT, --E      
                            a.status_process = 'P', 
                            a.jaql472ext     = 'N'                                         
                     where a.id = P_N_CODIDE;
                 exception
                 when others then
                      null;       
                 end; 
           else
                 If P_N_PGRCOD = 0 then
                 
                     begin
                         update TS_AP_CA_DET_PAGOS_INT@erp a
                            set a.STATUS_PAYMENT = null, --NULO X EXTORNO
                                a.DATE_PAYMENT = null,   -- sysdate   
                                a.HOLD_REASON_CODE = null,
                                a.HOLD_OUTPUT = null           
                         where a.id = P_N_CODIDE;
                     exception
                     when others then
                          null;       
                     end;     
                     
                     begin
                         update JAQL472 a
                            set a.codigo           = null, 
                                a.sucursal         = null,
                                a.cod_mod          = null,
                                a.transaccion      = null,
                                a.relacion         = null,
                                a.date_payment     = null,
                                a.hora_pago        = null,
                                a.horario_pago     = null,
                                a.moterror         = null,
                                a.idprocess        = null,
                                a.STATUS_PAYMENT   = null, --R    
                                a.HOLD_REASON_CODE = null,
                                a.hold_output      = null,
                                a.status_process   = null, --P
                                a.JAQL472EXT       = 'S',                  
                                a.JAQL472AX7       = P_D_FECPRO
                         where a.id = P_N_CODIDE;
                     exception
                     when others then
                          null;       
                     end;                                    
                 End If;                                   
           end if;                                      
      end if;
  end if;
  commit;  
  exception
  when others then
       null;
  end sp_act_pagos_ebs;

  
  Procedure sp_valida_abono(P_N_TPNRO  IN NUMBER,
                            P_N_TPIMP  IN NUMBER,
                            P_D_FECPRO IN DATE,
                            p_n_toppcc out number,
                            p_n_toaccc out number,
                            p_n_toppee out number,
                            p_n_toacee out number,
                            p_c_horari out varchar2                                                                   
                            ) IS
  cursor c_pagos(P_C_HORARIO IN VARCHAR2) is
      select count(1) total,
             STATUS_PAYMENT estado,
             PAYMENT_DOCUMENT_CODE tipo
        from jaql472
       where STATUS_PAYMENT in ('E', 'R')
         and PAYMENT_DOCUMENT_CODE in ('SE', 'EE')
         and DATE_PAYMENT = P_D_FECPRO
         and HORARIO_PAGO = P_C_HORARIO
    group by STATUS_PAYMENT,
             PAYMENT_DOCUMENT_CODE;
                               
  lc_horario varchar2(30);
  ln_toppcc number;
  ln_toaccc number; 
  ln_toppee number;
  ln_toacee number;    

  begin
  
  ln_toppcc := 0;
  ln_toaccc := 0; 
  ln_toppee := 0;
  ln_toacee := 0;    
    
  --obtenemos el horario de carga
    begin 
      select trim(tpdesc)
        into lc_horario
        from fst098
       where pgcod = 1
         and tpcod = 7664
         and tpnro = p_n_tpnro  
         and tpimp = p_n_tpimp;
    exception
    when others then  
         null; 
    end;          
    
    for i in c_pagos(lc_horario) loop
    
      case
          when i.estado = 'E' and i.tipo = 'SE' then
            ln_toppcc := i.total;
          when i.estado = 'E' and i.tipo = 'EE' then
            ln_toaccc := i.total;
          when i.estado = 'R' and i.tipo = 'SE' then
            ln_toppee := i.total;
          when i.estado = 'R' and i.tipo = 'EE' then
            ln_toacee := i.total;
      end case;    
    end loop;  

    p_n_toppcc := ln_toppcc;    
    p_n_toaccc := ln_toaccc;
    p_n_toppee := ln_toppee;
    p_n_toacee := ln_toacee; 
    p_c_horari := lc_horario; 
  
  end sp_valida_abono;   
  Procedure sp_registra_devolucion(P_N_NUMPAI     IN NUMBER,
                                   P_N_TIPDOC     IN NUMBER,
                                   P_N_NUMDOC     IN NUMBER,
                                   P_C_TIPDEV     IN VARCHAR2,
                                   P_C_NUMNEC     IN VARCHAR2,
                                   P_C_DESCRI     IN VARCHAR2,
                                   P_N_CODMON     IN NUMBER,
                                   P_N_MONDEV     IN NUMBER,
                                   P_N_CODIDE     OUT NUMBER,
                                   P_N_CODIID     OUT NUMBER,
                                   P_C_ERROR      OUT VARCHAR2
                                   ) is  
                                   
  ln_numid number := 0;  
  ln_nuide number := 0;
  lc_estado varchar2(240);     
  lc_codope char(2);                            
  begin
    
   If P_C_TIPDEV = 'DE' then
      lc_codope := 'EC';       
   else
      lc_codope := 'CC';
   End If;   
   -- obtenemos a traves del numero de erc/cajachica la operacion del desembolso/asignacion    
    begin      
      select ID,
             STATUS_PAYMENT
        into ln_nuide,
             lc_estado 
        from jaql472 
       where INVOICE_NUM = P_C_NUMNEC
         and STATUS_PAYMENT = 'E'
         and PAYMENT_DOCUMENT_CODE = lc_codope;                  
    exception
    When no_data_found then
      If P_C_TIPDEV <> 'DE' then
        begin      
          select ID,
                 STATUS_PAYMENT
            into ln_nuide,
                 lc_estado 
            from jaql472 
           where INVOICE_NUM = P_C_NUMNEC
             and STATUS_PAYMENT = 'E'
             and PAYMENT_DOCUMENT_CODE = 'CR';  
        Exception 
        when others then    
           If P_C_TIPDEV = 'DE' then           
              P_C_ERROR := 'El número de ERC No existe';
           else
              P_C_ERROR := 'El número de Caja chica no Existe';
           End If;          
        End;  
      ElsIf P_C_TIPDEV = 'DE' then
        begin      
          select ID,
                 STATUS_PAYMENT
            into ln_nuide,
                 lc_estado 
            from jaql472 
           where INVOICE_NUM = P_C_NUMNEC
             and STATUS_PAYMENT = 'E'
             and PAYMENT_DOCUMENT_CODE = 'EE';  
        Exception 
        when others then    
           If P_C_TIPDEV = 'DE' then           
              P_C_ERROR := 'El número de ERC No existe';
           else
              P_C_ERROR := 'El número de Caja chica no Existe';
           End If;          
        End;        
      Else  
           If P_C_TIPDEV = 'DE' then           
              P_C_ERROR := 'El número de ERC No existe';
           else
              P_C_ERROR := 'El número de Caja chica no Existe';
           End If;           
      End If;
    when others then
     P_N_CODIDE := 0;
       If P_C_TIPDEV = 'DE' then           
          P_C_ERROR := 'El número de ERC No existe';
       else
          P_C_ERROR := 'El número de Caja chica no Existe';
       End If;     
    end;
    
    If P_C_TIPDEV = 'DE' then       
      If lc_estado = 'R' then    
         P_N_CODIDE := 0;
         P_C_ERROR := 'El número de ERC No existe';    
      ElsIf lc_estado is null then
         P_N_CODIDE := 0;
         P_C_ERROR := 'La ERC seleccionada aún no a sido desembolsada';    
      End If;
   Else
      If lc_estado = 'R' then    
         P_N_CODIDE := 0;
         P_C_ERROR := 'El número de Caja chica no existe';    
      ElsIf lc_estado is null then
         P_N_CODIDE := 0;
         P_C_ERROR := 'La Caja chica seleccionada aún no a sido asignada';    
      End If;   
   End If;  

   If P_C_ERROR is null then
      begin
        select max(JAQL474ID) into ln_numid from JAQL474;                                    
      exception
      when others then
           ln_numid := 0; 
      end;
      
      If ln_numid is null then
          ln_numid := 0; 
      End If;
      
      ln_numid := ln_numid + 1;
      
      begin                              
      insert into jaql474(JAQL474ID,
                          JAQL474PAI,
                          JAQL474TPO,
                          JAQL474NRO,
                          JAQL474TPD,
                          JAQL474NEC,
                          JAQL474DES,
                          JAQL474MDA,
                          JAQL474MTO    
                         )
                   values(ln_numid,                        
                          P_N_NUMPAI,
                          P_N_TIPDOC,
                          P_N_NUMDOC,
                          P_C_TIPDEV,
                          P_C_NUMNEC,
                          P_C_DESCRI,
                          P_N_CODMON,
                          P_N_MONDEV
                         );     
      commit;
      P_N_CODIID := ln_numid;
      P_N_CODIDE := ln_nuide;
      P_C_ERROR := '';            
      exception
      when others then
        P_C_ERROR := sqlerrm;                               
      end;
   End If;        
  Exception
  when others then
    P_C_ERROR := sqlerrm;
  end sp_registra_devolucion; 
  
  Procedure sp_act_devolucion(P_N_CODIDE     IN NUMBER,
                              P_N_CODPGC     IN NUMBER,
                              P_N_CODMOD     IN NUMBER,
                              P_N_CODTRA     IN NUMBER,
                              P_N_CODREL     IN NUMBER,
                              P_N_CODSUC     IN NUMBER,
                              P_N_DESERR     IN VARCHAR2,
                              P_C_ERROR      OUT VARCHAR2
                             ) is
  begin
          
     update JAQL474 
        set JAQL474PGC = P_N_CODPGC,
            JAQL474MOD = P_N_CODMOD, 
            JAQL474TRA = P_N_CODTRA,
            JAQL474REL = P_N_CODREL,
            JAQL474SUC = P_N_CODSUC,
            JAQL474ERR = P_N_DESERR,
            JAQL474FDV = trunc(sysdate) 
      where JAQL474ID = P_N_CODIDE;
      commit;         
  Exception
  when others then
    P_C_ERROR := sqlerrm;
  end sp_act_devolucion;   

  Procedure sp_carga_manual is
  
  lc_horini  char(8);             
  lc_horfin  char(8); 
  lc_horcar  char(8); 
  lc_horari  varchar2(30); 
  lc_flag    char(1);
  ln_tpcorr number(3);    
                          
  
  cursor c_guia(p_n_tpnro in number) is
    select *
      from fst098
     where pgcod = 1
       and tpcod = 7664
       and tpnro = p_n_tpnro
  order by tpcorr ;  
  
  begin 
  lc_flag := 'N';
  
    for i in c_guia(1) loop   
       lc_horari := i.tpdesc;
       lc_horcar := to_char(SYSDATE, 'HH24:MI:SS');
       lc_horini := substr(lc_horari,1,8);
       lc_horfin := substr(lc_horari,10,8);
              
         If  lc_horcar >=lc_horini and lc_horcar<=lc_horfin then
             lc_flag := 'S';
             Exit;
         End If;             
     End Loop;  
         
     If lc_flag = 'S' then
        begin
          -- Call the procedure
          pq_pagos_ebs.sp_valida_proceso(p_c_codpro => 'C');
          commit;
        end;     
     Else
     lc_flag := 'N';
        for i in c_guia(1) loop   
           lc_horari := i.tpdesc;
           ln_tpcorr := i.tpcorr;
           lc_horcar := to_char(SYSDATE, 'HH24:MI:SS');
           lc_horini := substr(lc_horari,1,8);
           lc_horfin := substr(lc_horari,10,8);
                  
             If  lc_horcar <= lc_horini then
                 lc_flag := 'S';
                 begin
                    update fst098
                       set tpdesc = lc_horcar||'-'||lc_horfin
                     Where pgcod = 1
                       and tpcod = 7664
                       and tpnro = 1
                       and tpcorr = ln_tpcorr;
                    commit;
                 end;  
                 begin
                    -- Call the procedure
                    pq_pagos_ebs.sp_valida_proceso(p_c_codpro => 'C');
                    commit;
                 end;
                 begin
                    update fst098
                       set tpdesc = lc_horini||'-'||lc_horfin
                     Where pgcod = 1
                       and tpcod = 7664
                       and tpnro = 1
                       and tpcorr = ln_tpcorr;
                    commit;       
                 end;                                                   
                 Exit;                
             End If;             
         End Loop;
         If lc_flag = 'N' then
         
            for i in c_guia(1) loop   
               ln_tpcorr := i.tpcorr;
               
               If ln_tpcorr = 3 then
                  lc_horari := i.tpdesc;
                  lc_horcar := to_char(SYSDATE, 'HH24:MI:SS');
                  lc_horini := substr(lc_horari,1,8);
                  lc_horfin := substr(lc_horari,10,8);
               End If;   
            End loop;                         
            begin
              update fst098
                 set tpdesc = lc_horcar||'-'||'23:59:59'
               Where pgcod = 1
                 and tpcod = 7664
                 and tpnro = 1
                 and tpcorr = ln_tpcorr;
              commit;
            end;  
            begin
              -- Call the procedure
              pq_pagos_ebs.sp_valida_proceso(p_c_codpro => 'C');
              commit;
            end;
            begin
              update fst098
                 set tpdesc = lc_horini||'-'||lc_horfin
               Where pgcod = 1
                 and tpcod = 7664
                 and tpnro = 1
                 and tpcorr = ln_tpcorr;
              commit;       
            end;                     
         End If;          
     End if;                  
  Exception
  when others then
    null;
  end sp_carga_manual;   
 
 
 procedure sp_act_pagos_ebs_pol(P_C_TIPPRO IN VARCHAR2,  --tipo de proceso pago o extorno P / E
                               P_C_CODACT IN VARCHAR2,  --codigo de actualizacion
                               P_N_CODIDE IN NUMBER,    --id de pago
                                --estado de la operacion realizada C=correcta E=erronea
                               P_D_FECPRO IN DATE,      -- fecha de proceso        
                               P_N_CODERR IN NUMBER,    -- Codigo de error
                               P_C_MOTERR IN VARCHAR2,  -- Motivo del error
                               P_N_PGRCOD IN NUMBER,    -- Codigo de empresa Pgcod
                               P_N_SUCURS IN NUMBER,    -- Sucursal del pago
                               P_N_MODULO IN NUMBER,    -- Modulo
                               P_N_TRASAC IN NUMBER,    -- Transaccion
                               P_N_RELACI IN NUMBER,    -- Relacion                        
                               P_C_HORARI IN VARCHAR2,   -- Horario de proceso
                               P_C_TIPTRA IN VARCHAR2   -- Tipo de transaccion B=batch V=Ventanilla
                              ) IS
  ln_numid number := 0;                            
  begin
  
   if P_C_TIPPRO = 'P' then
     
      begin
           update TS_AP_CA_DET_PAGOS_INT@erp a
              set a.STATUS_PAYMENT = P_C_CODACT, --E
                  a.DATE_PAYMENT   = P_D_FECPRO -- sysdate              
            where a.id = P_N_CODIDE;
       exception
       when others then
            null;       
       end;   
  
  
        begin
                 update JAQL472 a
                    set a.codigo         = P_N_PGRCOD, 
                        a.sucursal       = P_N_SUCURS,
                        a.cod_mod        = P_N_MODULO,
                        a.transaccion    = P_N_TRASAC,
                        a.relacion       = P_N_RELACI,
                        a.date_payment   = P_D_FECPRO,
                        a.hora_pago      = to_char(sysdate,'HH24:mi:ss'),
                        a.horario_pago   = P_C_HORARI,
                        a.idprocess      = ln_numid,
                        a.STATUS_PAYMENT = P_C_CODACT, --E      
                        a.status_process = 'P',    
                        a.jaql472ext     = 'N'                   
                 where a.id = P_N_CODIDE;
             exception
             when others then
                  null;       
             end; 
  
  else -- extorno E
     
                 
             begin
                 update JAQL472 a
                    set a.codigo           = null, 
                        a.sucursal         = null,
                        a.cod_mod          = null,
                        a.transaccion      = null,
                        a.relacion         = null,
                        a.date_payment     = null,
                        a.hora_pago        = null,
                        a.horario_pago     = null,
                        a.moterror         = null,
                        a.idprocess        = null,
                        a.STATUS_PAYMENT   = null, --R    
                        a.HOLD_REASON_CODE = null,
                        a.hold_output      = null,
                        a.status_process   = null, --P
                        a.JAQL472EXT       = 'S',                  
                        a.JAQL472AX7       = P_D_FECPRO                                
                 where a.id = P_N_CODIDE;
             exception
             when others then
                  null;       
             end;  
             
     end if;         
                                               
                
                 
            /* begin
                 update TS_AP_CA_DET_PAGOS_INT@erp a
                    set a.STATUS_PAYMENT = P_C_CODACT, --R
                        a.DATE_PAYMENT = P_D_FECPRO,   -- sysdate   
                        a.HOLD_REASON_CODE = P_N_CODERR,
                        a.HOLD_OUTPUT = P_C_MOTERR           
                 where a.id = P_N_CODIDE;
             exception
             when others then
                  null;       
             end;     */
                     
                    
  commit;  
  
  exception  when others then       null;
  
  end sp_act_pagos_ebs_pol;
 
 Procedure sp_anula_pago(P_N_ID     IN NUMBER,
                         P_D_FECPRO IN DATE,         
                         P_C_ERROR  OUT VARCHAR2
                        ) is
  begin
          
     update JAQL472 
        set STATUS_PROCESS = 'A',
            MOTERROR       = 'ANULACION MANUAL',
            DATE_PAYMENT   = P_D_FECPRO,
            HORA_PAGO      = to_char(sysdate,'HH24:mi:ss')            
      where ID = P_N_ID;
      commit;        
      
     update TS_AP_CA_DET_PAGOS_INT@erp 
        set STATUS_PROCESS = 'A',
            DATE_PAYMENT   = P_D_FECPRO
      where ID = P_N_ID;
      commit;              
  Exception
  when others then
    P_C_ERROR := sqlerrm;
  end sp_anula_pago;  
  ---------------------------------------------------------------------------
  Procedure sp_registra_devolucionII(P_N_NUMPAI IN NUMBER,
                                     P_N_TIPDOC IN NUMBER,
                                     P_N_NUMDOC IN varchar2,
                                     P_N_CODIID IN NUMBER,
                                     P_C_TIPDEV IN VARCHAR2,
                                     P_C_NUMNEC IN VARCHAR2,
                                     P_C_DESCRI IN VARCHAR2,
                                     P_N_CODMON IN NUMBER,
                                     P_N_MONDEV IN NUMBER,
                                     P_N_CODIDE OUT NUMBER,
                                     P_C_ERROR  out varchar2) is

    ln_numid  number := 0;
    ln_nuide  number := 0;
    lc_estado varchar2(240);
    lc_codope char(2);
  begin
    lc_codope := 'EC';
    ln_nuide  := P_N_CODIID;

    /*If lc_estado is null then
       P_N_CODIDE := 0;
       P_C_ERROR := 'La ERC seleccionada aún no a sido desembolsada';    
    End If; */

    begin
      select (NVL(max(JAQL474ID), 0)) + 1 into ln_numid from JAQL474;
    exception
      when others then
        ln_numid := 0;
    end;
    begin
      insert into jaql474
        (JAQL474ID,
         JAQL474PAI,
         JAQL474TPO,
         JAQL474NRO,
         JAQL474TPD,
         JAQL474NEC,
         JAQL474DES,
         JAQL474MDA,
         JAQL474MTO)
      values
        (ln_numid,
         P_N_NUMPAI,
         P_N_TIPDOC,
         P_N_NUMDOC,
         P_C_TIPDEV,
         P_C_NUMNEC,
         P_C_DESCRI,
         P_N_CODMON,
         P_N_MONDEV);
      commit;
--      P_N_CODIID := ln_numid;  
      P_N_CODIDE := ln_numid ;
    exception
      when others then
        P_C_ERROR := sqlerrm;
    end;

  Exception
    when others then
      P_C_ERROR := sqlerrm;
  end sp_registra_devolucionII;
end PQ_PAGOS_EBS;
/

