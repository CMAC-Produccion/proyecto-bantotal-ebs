CREATE OR REPLACE TRIGGER TG_JAQN76_AI_01
  after insert on JAQN76 
  for each row
-- *******************************************************************************************************
-- Nombre                     : TG_JAQN76_AI_01
-- Sistema                    : BANTOTAL
-- Módulo                     : Créditos
-- Versión                    : 1.0
-- Fecha de Creación          : 2022.07.11
-- Autor de Creación          : Alonso Pacheco Huachaca
-- Uso                        : Envío de alertas via correo electrónico cuando detecta dos pagos consecutivos 
-- Estado                     : Activo
-- Acceso                     : Público
-- Fecha de Modificación      :
-- Autor de Modificación      :
-- Descripción de Modificación:
-- ********************************************************************************************************

declare
  pn_jaqn76moe NUMBER(3);
  pn_jaqn76tre NUMBER(3);
  pn_jaqn76emp NUMBER(3);
  pn_jaqn76sue NUMBER(3);
  pn_jaqn76ree NUMBER(4);
  pn_jaqn76fee DATE;
  pn_correl NUMBER(10);
  pn_instancia NUMBER(10);
  --ld_fchsist DATE;
  ln_aqpb922cta number(9) := 0;
  ln_aqpb922ope number(9) := 0; 
  lv_aqpb922doc varchar2(12);
  lv_aqpb922noc varchar2(30);  
  lv_aqpb922ntr varchar2(30);
  lv_aqpb922nco varchar2(50); 
  ld_aqpb922fve date;  
  ln_aqpb922nrc number(4) := 0;
  ln_aqpb922moc number(17,2) := 0;
  ln_aqpb922mon number(17,2) := 0;
  ln_aqpb922par number(17,2) := 0;
  ln_aqpb922sap number(17,2) := 0;
  ln_aqpb922sua number := 0;
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
  ln_instancia number := 0;   
  ln_flag number := 0;
  --
  ld_ppfpag date;
  --
  ERR_MSG VARCHAR2(200);
  CURSOR GUIA_CONVENIO IS
        select tp1nro1,tp1nro2 from fst198 
                      where tp1cod1 = 11161 and tp1corr1 = 9 and tp1corr2 = 3 and tp1corr3 > 0; 
                      
  CURSOR GUIA_CONVENIO2 IS
        select tp1nro1,tp1nro2 from fst198 
                      where tp1cod1 = 11161 and tp1corr1 = 9 and tp1corr2 = 3 and tp1corr3 > 0; 
begin
  begin
    PQ_CR_ENVIO_CORREOS_PAGOS_CONSECUTIVOS.sp_cr_obtener_trn_inst(:new.jaqn76emp, :new.jaqn76moe, :new.jaqn76sue, 
                                                                  :new.jaqn76tre, :new.jaqn76ree, :new.jaqn76fee,
                                                                  ln_instancia);    
  exception when others then
    ln_instancia := 0;
  end;
  --guarda en mi tabla log
  begin
           INSERT INTO AQPB922L(aqpb922lfee,aqpb922lemp,aqpb922lsue,aqpb922lmoe,aqpb922ltre,aqpb922lree,
                       aqpb922lcta,aqpb922lope,aqpb922ldoc,aqpb922lnrc,aqpb922lnoc,aqpb922lntr,aqpb922lnco,
                       aqpb922lfve,aqpb922lmoc,aqpb922lmon,aqpb922lpar,aqpb922lsap,aqpb922lemis,aqpb922ldest,
                       aqpb922lcopi,aqpb922lmesg,aqpb922lasun,aqpb922lflag,aqpb922lerro,aqpb922lermg,
                       aqpb922lusur,aqpb922lfecr,aqpb922lhora,aqpb922lins) 
                VALUES(:new.jaqn76fee,:new.jaqn76emp,:new.jaqn76sue,:new.jaqn76moe,:new.jaqn76tre,:new.jaqn76ree,
                       :new.jaqn76cta,:new.jaqn76ope,:new.jaqn76doc,:new.jaqn76nrc,:new.jaqn76noc,:new.jaqn76ntr,
                       :new.jaqn76nco,:new.jaqn76fve,:new.jaqn76moc,:new.jaqn76mon,
                       :new.jaqn76par,:new.jaqn76sap,'','','','','',0,'001','EJECUCION TRIGGER',
                       :new.jaqn76ana,TRUNC(SYSDATE),to_char(sysdate, 'HH24:MI:SS'),ln_instancia);
  exception when others then
    null;
  end;                     
  --new. equivale al campo de un nuevo registro
  --valida que la transaccion no sea de Procesos Centrales
  FOR I IN GUIA_CONVENIO LOOP
     --validar si es pago total
     begin
        select ppfpag into ld_ppfpag
              from fsd602 
              where ppcta = :new.jaqn76cta and ppoper = :new.jaqn76ope 
                and d602fc = :new.jaqn76fee and d602cd = :new.jaqn76emp and d602mo = :new.jaqn76moe
                and d602su = :new.jaqn76sue and d602tr = :new.jaqn76tre and d602re = :new.jaqn76ree
                and pp1stat = 'T' and d602co = 'S'; 
     exception when others then
        ld_ppfpag := to_date('01/01/1900','dd/mm/yyy');
     end;      
     select count(*) into ln_flag
              from fsd602 
              where ppcta = :new.jaqn76cta and ppoper = :new.jaqn76ope 
                and d602fc = :new.jaqn76fee and d602cd = :new.jaqn76emp and d602mo = :new.jaqn76moe
                and d602su = :new.jaqn76sue and d602tr = :new.jaqn76tre and d602re = :new.jaqn76ree
                and pp1stat = 'T' and d602co = 'S'; 
    IF (:new.jaqn76moe <> I.tp1nro1 and :new.jaqn76tre <> I.tp1nro2) AND ln_flag = 1 THEN
      begin
        --validar si es pago total (mes anterior)
         select d602fc,d602cd,d602mo,d602su,d602tr,d602re
                into pn_jaqn76fee,pn_jaqn76emp,pn_jaqn76moe,
                     pn_jaqn76sue,pn_jaqn76tre,pn_jaqn76ree
                from fsd602 
                where ppcta = :new.jaqn76cta and ppoper = :new.jaqn76ope 
                  and ppfpag = add_months(ld_ppfpag,-1)
                  and pp1stat = 'T' and d602co = 'S';   
        --obtengo la transaccion del mes anterior
          select trim(aqpb922ntr),trim(aqpb922nco),trim(aqpb922noc),
                 aqpb922fve,aqpb922moc,aqpb922mon,aqpb922par,aqpb922sap
              into lv_aqpb922ntr,lv_aqpb922nco,lv_aqpb922noc,ld_aqpb922fve,
                   ln_aqpb922moc,ln_aqpb922mon,ln_aqpb922par,ln_aqpb922sap 
              from aqpb922 
          where (aqpb922moe,aqpb922tre) not in 
                (select tp1nro1,tp1nro2 from fst198 
                        where tp1cod1 = 11161 and tp1corr1 = 9 and tp1corr2 = 3 and tp1corr3 > 0)
             and aqpb922cta = :new.jaqn76cta and aqpb922ope = :new.jaqn76ope and aqpb922doc = :new.jaqn76doc
             --and aqpb922fve = add_months(to_date(:new.jaqn76fve,'dd/mm/yy'),-1)
             and aqpb922fee = pn_jaqn76fee and aqpb922emp = pn_jaqn76emp and aqpb922moe = pn_jaqn76moe
             and aqpb922sue = pn_jaqn76sue and aqpb922tre = pn_jaqn76tre and aqpb922ree = pn_jaqn76ree;    
      exception when others then
        --ERR_MSG := substr(sqlerrm,1,200);
        --INSERT INTO PRUEBA_LOG_DATA VALUES(5,:new.jaqn76moe,:new.jaqn76tre,:new.jaqn76cta,:new.jaqn76ope,:new.jaqn76doc,ERR_MSG,add_months(to_date(:new.jaqn76fve,'dd/mm/yy'),-1),SYSDATE);
        return;
      end;   
      --la actual y la anterior son consecutivos en otros pagos
      FOR J IN GUIA_CONVENIO2 LOOP
        IF pn_jaqn76moe <> J.TP1NRO1 and pn_jaqn76tre <> J.TP1NRO2 THEN                 
          --ejecuta proceso para envio de correos
          BEGIN
            --Instancia
            begin
              PQ_CR_ENVIO_CORREOS_PAGOS_CONSECUTIVOS.sp_cr_obtener_trn_inst(:new.jaqn76emp, pn_jaqn76moe, pn_jaqn76sue, 
                                                                            pn_jaqn76tre, pn_jaqn76ree, pn_jaqn76fee, 
                                                                            ln_instancia);    
            exception when others then
              ln_instancia := 0;
            end;            
            --Correlativo
            begin
              select tp1nro1 into pn_correl from fst198 
                         where tp1cod1 = 11161 and tp1corr1 = 9 and tp1corr2 = 2;
              pn_correl := pn_correl +1;
              update fst198 set tp1nro1 = pn_correl 
                     where tp1cod1 = 11161 and tp1corr1 = 9 and tp1corr2 = 2;
            exception when others then
              null;
            end;
            
            INSERT INTO AQPB922L(aqpb922lfee,aqpb922lemp,aqpb922lmoe,aqpb922lsue,aqpb922ltre,aqpb922lree,
                           aqpb922lcta,aqpb922lope,aqpb922ldoc,aqpb922lnrc,aqpb922lnoc,aqpb922lntr,aqpb922lnco,
                           aqpb922lfve,aqpb922lmoc,aqpb922lmon,aqpb922lpar,aqpb922lsap,aqpb922lemis,aqpb922ldest,
                           aqpb922lcopi,aqpb922lmesg,aqpb922lasun,aqpb922lflag,aqpb922lerro,aqpb922lermg,
                           aqpb922lusur,aqpb922lfecr,aqpb922lhora,aqpb922lcorre,aqpb922lins) 
                    VALUES(pn_jaqn76fee,pn_jaqn76emp,pn_jaqn76moe,pn_jaqn76sue,pn_jaqn76tre,pn_jaqn76ree,
                           :new.jaqn76cta,:new.jaqn76ope,:new.jaqn76doc,:new.jaqn76nrc,:new.jaqn76noc,lv_aqpb922ntr,lv_aqpb922nco, 
                           ld_aqpb922fve,ln_aqpb922moc,ln_aqpb922mon,ln_aqpb922par,ln_aqpb922sap,'','','','','',1,'000','PAGO ANTERIOR',
                           :new.jaqn76ana,TRUNC(SYSDATE),to_char(sysdate, 'HH24:MI:SS'),pn_correl,ln_instancia);                       
            --Envio de correo
            PQ_CR_ENVIO_CORREOS_PAGOS_CONSECUTIVOS.sp_cr_envioanalista(:new.jaqn76emp, :new.jaqn76moe, :new.jaqn76sue, 
                                                                       :new.jaqn76tre, :new.jaqn76ree, :new.jaqn76fee, 
                                                                       :new.jaqn76ana, pn_correl);                       
          EXCEPTION
            WHEN OTHERS THEN
              ERR_MSG := substr(sqlerrm,1,250);          
              INSERT INTO AQPB922L(aqpb922lfee,aqpb922lemp,aqpb922lsue,aqpb922lmoe,aqpb922ltre,aqpb922lree,
                           aqpb922lcta,aqpb922lope,aqpb922ldoc,aqpb922lnrc,aqpb922lnoc,aqpb922lntr,aqpb922lnco,
                           aqpb922lfve,aqpb922lmoc,aqpb922lmon,aqpb922lpar,aqpb922lsap,aqpb922lemis,aqpb922ldest,
                           aqpb922lcopi,aqpb922lmesg,aqpb922lasun,aqpb922lflag,aqpb922lerro,aqpb922lermg,
                           aqpb922lusur,aqpb922lfecr,aqpb922lhora,aqpb922lcorre) 
                    VALUES(pn_jaqn76fee,pn_jaqn76emp,pn_jaqn76moe,pn_jaqn76tre,pn_jaqn76ree,:new.jaqn76ree,
                           :new.jaqn76cta,:new.jaqn76ope,:new.jaqn76doc,:new.jaqn76nrc,:new.jaqn76noc,lv_aqpb922ntr,lv_aqpb922nco,  
                           ld_aqpb922fve,ln_aqpb922moc,ln_aqpb922mon,ln_aqpb922par,ln_aqpb922sap,'','','','','',1,'991',ERR_MSG,
                           :new.jaqn76ana,TRUNC(SYSDATE),to_char(sysdate, 'HH24:MI:SS'),pn_correl);
          END;
        END IF;        
      END LOOP;
    END IF; 
  END LOOP;
  COMMIT;
exception
  when others then
    null;
end TG_JAQN76_AI_01;
/

