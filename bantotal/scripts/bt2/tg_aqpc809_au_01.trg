CREATE OR REPLACE TRIGGER "TG_AQPC809_AU_01"
after insert on AQPC809
for each row
BEGIN
   BEGIN
     pq_cr_envio_notifi_canc_amortiz.sp_cr_envio_correo(
                               :new.AQPC809EMP  ,
                               :new.AQPC809MODU,
                               :new.AQPC809SUC ,
                               :new.AQPC809MDA ,
                               :new.AQPC809PAP ,
                               :new.AQPC809CTA,
                               :new.AQPC809OPER,
                               :new.AQPC809SBOP,
                               :new.AQPC809TOPE,
                               :new.AQPC809OPERADT,
                               :new.AQPC809NOMCLI,
                               :new.AQPC809SUCCLI,
                               :new.AQPC809PRODUCT,
                               :new.AQPC809HORAT,
                               :new.AQPC809MONTO,
                               :new.AQPC809DESMDA,
                               :new.AQPC809TIPPGO,
                               :new.AQPC809ITFCON,
                               :new.AQPC809AGENCIT );

      insert into AQPC810( AQPC810COD,AQPC810MOD,AQPC810SUC,AQPC810MDA,AQPC810PAP,AQPC810CTA,
                                        AQPC810OPER,AQPC810SBOP,AQPC810TOPE,AQPC810EMIS,AQPC810DEST,
                                        AQPC810COPI,AQPC810MESG,AQPC810ASUN,AQPC810ERRO,AQPC810ERMG,
                                        AQPC810USUR,AQPC810FECR,AQPC810HORA)
                  values (:new.AQPC809EMP, :new.AQPC809MODU, :new.AQPC809SUC, :new.AQPC809MDA, :new.AQPC809PAP, :new.AQPC809CTA, :new.AQPC809OPER, :new.AQPC809SBOP, :new.AQPC809TOPE,
                          '', '', 'datos del trigger', '', '', 0, '',
                          :new.AQPC809OPERADT, TRUNC(SYSDATE), to_char(sysdate, 'HH24:MI:SS'));
  EXCEPTION
      WHEN OTHERS THEN
        NULL;
  END;

END TG_AQPC809_INS;
/

