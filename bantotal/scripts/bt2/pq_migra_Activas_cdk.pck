CREATE OR REPLACE PACKAGE pq_migra_Activas_cdk IS
  --                      :lllosa 2012.04.09 Se agrego historico de creditos
  --                      :lllosa 2012.04.11 se agrego relacion de garatias
  --                      :lllosa 2012.04.13 Se agrego bandejas de micro
  --                      :lllosa 2012.05.30 Se agrego codigo de proceso en tab_jobs
  --                      :lllosa 2012.07.09 Se actualizo cambios x n vez 
 procedure sp_llena_BNJ002 ;
 procedure sp_llena_BJR011 ;
 procedure sp_llena_JAQL165;
 procedure sp_llena_JAQL166;
 procedure sp_llena_JAQY068;
 procedure sp_llena_fsd012_tmp ;
 Procedure sp_cr_sng003 ;
 Procedure sp_cr_x054023;
 Procedure sp_cr_xwf700;
 procedure sp_llena_SNG001;
 procedure sp_llena_SNG122 ;
 procedure sp_llena_BNJ005 ;
end pq_migra_Activas_cdk;
/
CREATE OR REPLACE PACKAGE BODY pq_migra_Activas_cdk IS
procedure sp_llena_BNJ002 is
  lc_coderr Varchar2(300);
  begin 
             insert into bandejas.BNJ002(BNJEMP,    BNJCOD,  BNJSUC,  BNJMDA,  BNJPAP,  BNJCTA,
                                BNJOPE,    BNJSBOP, BNJTOPE, BNJSDO,  BNJFVAL, BNJFVTO,
                                BNJPZO,    BNJTTAS, BNJTDIA, BNJTVTO, BNJTANO, BNJIMP,
                                BNJPERIOD, BNJOK  , BNJim14, Bnjim2,  Bnjim3,  Bnjim4,
                                Bnjim5,    Bnjim7,  Bnjim8,  Bnjim9,  Bnjim10, --Bnjim11,
                                Bnjim12,   Bnjim13, Bnjstat, BNJTASA, Bnjim15, BBJIM6,
                                /*bnjim1, */   bnjim11, bnjtmor)
             select BNJEMP,    BNJCOD,  BNJSUC,  BNJMDA,  BNJPAP,  BNJCTA,
                                BNJOPE,    BNJSBOP, BNJTOPE, BNJSDO,  BNJFVAL, BNJFVTO,
                                BNJPZO,    BNJTTAS, BNJTDIA, BNJTVTO, BNJTANO, BNJIMP,
                                BNJPERIOD, BNJOK  , BNJim14, Bnjim2,  Bnjim3,  Bnjim4,
                                Bnjim5,    Bnjim7,  Bnjim8,  Bnjim9,  Bnjim10, --Bnjim11,
                                Bnjim12,   Bnjim13, Bnjstat, BNJTASA, Bnjim15, BBJIM6,
                                /*bnjim1, */   bnjim11, bnjtmor from BNJ002@credinka;
             commit; 
             exception
                when others then
                  lc_coderr := sqlerrm;
                  insert into log_error_bandeja(n_nro,c_codbdj,c_deserr,d_fecerr)
                  values (1,'BNJ002_0',lc_coderr,trunc(sysdate));   
                  commit;
            
end;

procedure sp_llena_BJR011  is
  lc_coderr  varchar2(300);
  begin 
             insert into bandejas.bjr011 (bnjemp,bnjcod,bnjr1cod,bnjr1mod,bnjr1suc,bnjr1mda,
                                       bnjr1pap,bnjr1cta,bnjr1oper,bnjr1sbop,bnjr1tope,
                                       bnjrelcod,bnjr2mod,bnjr2cta,bnjr2oper,bnjr2sbop,
                                       bnjr1rub,bnjr2cod,bnjr2suc,bnjr2mda,bnjr2pap,bnjr2tope,
                                       bnjr2rub,bnjr011co)
            select bnjemp,bnjcod,bnjr1cod,bnjr1mod,bnjr1suc,bnjr1mda,
                                       bnjr1pap,bnjr1cta,bnjr1oper,bnjr1sbop,bnjr1tope,
                                       bnjrelcod,bnjr2mod,bnjr2cta,bnjr2oper,bnjr2sbop,
                                       bnjr1rub,bnjr2cod,bnjr2suc,bnjr2mda,bnjr2pap,bnjr2tope,
                                       bnjr2rub,bnjr011co from bjr011_tmp@credinka;
           commit;                            
 exception
   when others then
      lc_coderr := sqlerrm;
      insert into log_error_bandeja(n_nro,c_codbdj,c_deserr,d_fecerr)
      values (2,'BJr011',lc_coderr,trunc(sysdate));   
      commit;            
end;

procedure sp_llena_JAQL165  is
  lc_coderr  varchar2(300);
  begin
             insert into bantprod.jaql165 (jaql165corr,-- ' Correlativo por cr?dito (para migraci?n "uno") 
                                           jaql165emp,-- ' Empresa 
                                           jaql165suc,-- ' Sucursal 
                                           jaql165mda,--  ' Moneda 
                                           jaql165pap,-- ' Papel 
                                           jaql165cta,-- ' Cuenta 
                                           jaql165ope,--  ' Operaci?n 
                                           jaql165sbo,-- ' Suboperaci?n 
                                           jaql165top,-- ' Tipo Operaci?n 
                                           jaql165mod,-- ' M?dulo 
                                           jaql165fec,-- ' Fecha de env?o a Judicial 
                                           jaql162codpre,-- ' C?digo de prelaci?n 
                                           jaql165com,-- ' Tipo de compromiso de pago (N=Ninguno/D=De Pago/P=Cancelaci?n Especial Parcial/T= Cancelaci?n Especial Total
                                           jaql165tex,-- ' Texto de autorizaci?n 
                                           jaql165usr,-- ' Usuario que registr? 
                                           jaql165hor,--' Hora de Registro 
                                           jaql165imp,--  ' Importe de Compromiso
                                           JAQL165STA
                                           )
            SELECT jaql165corr,-- ' Correlativo por cr?dito (para migraci?n "uno") 
                                           jaql165emp,-- ' Empresa 
                                           jaql165suc,-- ' Sucursal 
                                           jaql165mda,--  ' Moneda 
                                           jaql165pap,-- ' Papel 
                                           jaql165cta,-- ' Cuenta 
                                           jaql165ope,--  ' Operaci?n 
                                           jaql165sbo,-- ' Suboperaci?n 
                                           jaql165top,-- ' Tipo Operaci?n 
                                           jaql165mod,-- ' M?dulo 
                                           jaql165fec,-- ' Fecha de env?o a Judicial 
                                           jaql162codpre,-- ' C?digo de prelaci?n 
                                           jaql165com,-- ' Tipo de compromiso de pago (N=Ninguno/D=De Pago/P=Cancelaci?n Especial Parcial/T= Cancelaci?n Especial Total
                                           jaql165tex,-- ' Texto de autorizaci?n 
                                           jaql165usr,-- ' Usuario que registr? 
                                           jaql165hor,--' Hora de Registro 
                                           jaql165imp,--  ' Importe de Compromiso
                                           JAQL165STA FROM JAQL165_TMP@CREDINKA;                              
           
           exception
              when others then
                    lc_coderr := sqlerrm;
                    --insertar a una tabla generica de excepciones (dato y la bandeja)
                    insert into LOG_ERROR_BANDEJA
                      (n_nro, c_codbdj, c_deserr, d_fecerr)
                    values
                      (3, 'JAQL165N',lc_coderr, sysdate);
                   commit;
                     
end;

procedure sp_llena_JAQL166  is
  lc_coderr  varchar2(300);
  begin
             insert into bantprod.jaql166 (JAQL166PGCOD,JAQL166SCMOD,JAQL166SCSUC,JAQL166SCMDA,JAQL166SCPAP,JAQL166SCCTA,JAQL166SCOPE,
                JAQL166SCSBO,JAQL166SCTOP,JAQL166SCFVL,JAQL166NRPAG,JAQL166EST,JAQL166FPGA,JAQL166IMPCAP,JAQL166IMPINT,
                JAQL166IMPMOR,JAQL166IMPGAS,JAQL166IMP1,JAQL166IMP2,D166CD,D166SU,D166MO,D166TR,D166RE,JAQL166IMPSEG,
                D166CO
                                           )
            SELECT JAQL166PGCOD,JAQL166SCMOD,JAQL166SCSUC,JAQL166SCMDA,JAQL166SCPAP,JAQL166SCCTA,JAQL166SCOPE,
                JAQL166SCSBO,JAQL166SCTOP,JAQL166SCFVL,JAQL166NRPAG,JAQL166EST,JAQL166FPGA,JAQL166IMPCAP,JAQL166IMPINT,
                JAQL166IMPMOR,JAQL166IMPGAS,JAQL166IMP1,JAQL166IMP2,D166CD,D166SU,D166MO,D166TR,D166RE,JAQL166IMPSEG,
                D166CO  FROM JAQL166_TMP@CREDINKA;                              
           
           exception
              when others then
                    lc_coderr := sqlerrm;
                    --insertar a una tabla generica de excepciones (dato y la bandeja)
                    insert into LOG_ERROR_BANDEJA
                      (n_nro, c_codbdj, c_deserr, d_fecerr)
                    values
                      (4, 'JAQL166N', lc_coderr, sysdate);
                   commit;
                     
end;

procedure sp_llena_JAQY068   is
  lc_coderr  varchar2(300);
  begin
             insert into bantprod.JAQY068  (JAQY068PGCO,JAQY068MODU,JAQY068TOPE,JAQY068SUCD,JAQY068MONE,JAQY068PAPE,
                         JAQY068CTRO,JAQY068OPER,JAQY068SUBO,JAQY068RUBR,JAQY068TORD,JAQY068SBOR,
                                JAQY068FVAL,JAQY068TMOD,JAQY068TSUC,JAQY068TRAN,JAQY068NREL)
            SELECT JAQY068PGCO,JAQY068MODU,JAQY068TOPE,JAQY068SUCD,JAQY068MONE,JAQY068PAPE,
                   JAQY068CTRO,JAQY068OPER,JAQY068SUBO,JAQY068RUBR,JAQY068TORD,JAQY068SBOR,
                   JAQY068FVAL,JAQY068TMOD,JAQY068TSUC,JAQY068TRAN,JAQY068NREL
              FROM JAQY068_TMP@CREDINKA;                             
           
           exception
              when others then
                    lc_coderr := sqlerrm;
                    --insertar a una tabla generica de excepciones (dato y la bandeja)
                    insert into LOG_ERROR_BANDEJA
                      (n_nro, c_codbdj, c_deserr, d_fecerr)
                    values
                      (5, 'JAQY068', lc_coderr, sysdate);
                   commit;
                     
end;

procedure sp_llena_fsd012_tmp   is
  lc_coderr  varchar2(300);
  cursor f12 is 
  select PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,EVCORR,EVTIPO,EVFVAL,EVFVTO,
                   EVIMP,EVTTAS,EVTASA,EVCAP,EVINT,EVMOR,EVSCAP,EVSINT,EVSMOR,EVINTC,EVMORC,EVCD01,EVCD02,
                   EVINV,EVPER,EVTCBI,EVTCBI1,EVARB,EVARB1,EVMD,EVMD1,EVPRE,EVPRE1,D012CD,D012MO,D012SU,
                   D012TR,D012RE,D012FC,D012OR,D012SB,D012CO from fsd012_tmp@credinka ;                             
           
  begin
    begin
         insert into fsd012_tmp  (PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,EVCORR,EVTIPO,EVFVAL,EVFVTO,
                   EVIMP,EVTTAS,EVTASA,EVCAP,EVINT,EVMOR,EVSCAP,EVSINT,EVSMOR,EVINTC,EVMORC,EVCD01,EVCD02,
                   EVINV,EVPER,EVTCBI,EVTCBI1,EVARB,EVARB1,EVMD,EVMD1,EVPRE,EVPRE1,D012CD,D012MO,D012SU,
                   D012TR,D012RE,D012FC,D012OR,D012SB,D012CO)
         select PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,EVCORR,EVTIPO,EVFVAL,EVFVTO,
                   EVIMP,EVTTAS,EVTASA,EVCAP,EVINT,EVMOR,EVSCAP,EVSINT,EVSMOR,EVINTC,EVMORC,EVCD01,EVCD02,
                   EVINV,EVPER,EVTCBI,EVTCBI1,EVARB,EVARB1,EVMD,EVMD1,EVPRE,EVPRE1,D012CD,D012MO,D012SU,
                   D012TR,D012RE,D012FC,D012OR,D012SB,D012CO from fsd012_tmp@credinka;          
    exception 
        when others then 
           lc_coderr := sqlerrm;
            --insertar a una tabla generica de excepciones (dato y la bandeja)
            insert into LOG_ERROR_BANDEJA
              (n_nro, c_codbdj, c_deserr, d_fecerr)
            values
              (5, 'fsd012_tmp', lc_coderr, sysdate);
           commit;
    end; 
      for i in f12 loop 
         begin
             insert into bantprod.fsd012  (PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,EVCORR,EVTIPO,EVFVAL,EVFVTO,
                   EVIMP,EVTTAS,EVTASA,EVCAP,EVINT,EVMOR,EVSCAP,EVSINT,EVSMOR,EVINTC,EVMORC,EVCD01,EVCD02,
                   EVINV,EVPER,EVTCBI,EVTCBI1,EVARB,EVARB1,EVMD,EVMD1,EVPRE,EVPRE1,D012CD,D012MO,D012SU,
                   D012TR,D012RE,D012FC,D012OR,D012SB,D012CO)
            values(i.PGCOD,i.AOMOD,i.AOSUC,i.AOMDA,i.AOPAP,i.AOCTA,i.AOOPER,i.AOSBOP,i.AOTOPE,i.EVCORR,i.EVTIPO,i.EVFVAL,i.EVFVTO,
                   i.EVIMP,i.EVTTAS,i.EVTASA,i.EVCAP,i.EVINT,i.EVMOR,i.EVSCAP,i.EVSINT,i.EVSMOR,i.EVINTC,i.EVMORC,i.EVCD01,i.EVCD02,
                   i.EVINV,i.EVPER,i.EVTCBI,i.EVTCBI1,i.EVARB,i.EVARB1,i.EVMD,i.EVMD1,i.EVPRE,i.EVPRE1,i.D012CD,i.D012MO,i.D012SU,
                   i.D012TR,i.D012RE,i.D012FC,i.D012OR,i.D012SB,i.D012CO) ;                             
           
           exception
              when others then
                    lc_coderr := sqlerrm;
                    --insertar a una tabla generica de excepciones (dato y la bandeja)
                    insert into LOG_ERROR_BANDEJA
                      (n_nro, c_codbdj, c_deserr, d_fecerr)
                    values
                      (5, 'fsd012', i.AOCTA||'-'||i.AOOPER||'-'||lc_coderr, sysdate);
                   commit;
           end;        
         end loop;
end;

procedure sp_llena_SNG122   is
  lc_coderr  varchar2(300);
  cursor s122 is 
  /*select SNG122INST,SNG122CORR,SNG122PGC,SNG122MOD,SNG122SUC,SNG122MDA,SNG122PAP,SNG122CTA,
       SNG122OPER,SNG122SBOP,SNG122TOPE,SNG122PRI,SNG122TIPO,SNG122SDOG,SNG122MTOU,SNG122FAPE,
       SNG122MTOD,SNG122POCO,SNG122TCBI,SNG122AUXC from SNG122_tmp@credinka ; */                            
   select /*b.n_nummov */SNG122INST,SNG122CORR,SNG122PGC,SNG122MOD,SNG122SUC,SNG122MDA,SNG122PAP,SNG122CTA,
       SNG122OPER,SNG122SBOP,SNG122TOPE,SNG122PRI,SNG122TIPO,SNG122SDOG,SNG122MTOU,SNG122FAPE,
       SNG122MTOD,SNG122POCO,SNG122TCBI,SNG122AUXC from SNG122_tmp@credinka a/*, btctaprd b
       where a.SNG122INST = b.n_nroist*/ ;        
  begin
    /*begin
         insert into SNG122_tmp  (SNG122INST,SNG122CORR,SNG122PGC,SNG122MOD,SNG122SUC,SNG122MDA,SNG122PAP,SNG122CTA,
                     SNG122OPER,SNG122SBOP,SNG122TOPE,SNG122PRI,SNG122TIPO,SNG122SDOG,SNG122MTOU,SNG122FAPE,
                     SNG122MTOD,SNG122POCO,SNG122TCBI,SNG122AUXC)
         select SNG122INST,SNG122CORR,SNG122PGC,SNG122MOD,SNG122SUC,SNG122MDA,SNG122PAP,SNG122CTA,
               SNG122OPER,SNG122SBOP,SNG122TOPE,SNG122PRI,SNG122TIPO,SNG122SDOG,SNG122MTOU,SNG122FAPE,
               SNG122MTOD,SNG122POCO,SNG122TCBI,SNG122AUXC from SNG122_tmp@credinka;          
    exception 
        when others then 
           lc_coderr := sqlerrm;
            --insertar a una tabla generica de excepciones (dato y la bandeja)
            insert into LOG_ERROR_BANDEJA
              (n_nro, c_codbdj, c_deserr, d_fecerr)
            values
              (5, 'fsd012_tmp', lc_coderr, sysdate);
           commit;
    end;*/ 
      for i in s122 loop 
         begin
             insert into bantprod.SNG122  (SNG122INST,SNG122CORR,SNG122PGC,SNG122MOD,SNG122SUC,SNG122MDA,SNG122PAP,SNG122CTA,
                   SNG122OPER,SNG122SBOP,SNG122TOPE,SNG122PRI,SNG122TIPO,SNG122SDOG,SNG122MTOU,SNG122FAPE,
                   SNG122MTOD,SNG122POCO,SNG122TCBI,SNG122AUXC)
            values(i.SNG122INST,i.SNG122CORR,i.SNG122PGC,i.SNG122MOD,i.SNG122SUC,i.SNG122MDA,i.SNG122PAP,i.SNG122CTA,
                   i.SNG122OPER,i.SNG122SBOP,i.SNG122TOPE,i.SNG122PRI,i.SNG122TIPO,i.SNG122SDOG,i.SNG122MTOU,i.SNG122FAPE,
                   i.SNG122MTOD,i.SNG122POCO,i.SNG122TCBI,i.SNG122AUXC) ;                             
           
           exception
              when others then
                    lc_coderr := sqlerrm;
                    --insertar a una tabla generica de excepciones (dato y la bandeja)
                    insert into LOG_ERROR_BANDEJA
                      (n_nro, c_codbdj, c_deserr, d_fecerr)
                    values
                      (5, 'SNG122', i.SNG122CTA||'-'||i.SNG122OPER||lc_coderr, sysdate);
                   commit;
           end;         
         end loop;
end;

procedure sp_llena_SNG001 is
  lc_coderr  varchar2(300);
  cursor sng1 is 
  select SNG001INST,SNG001EMP,SNG001CTA,SNG001PAIS,SNG001TDOC,SNG001NDOC,
         SNG001ORI,SNG001SEG,SNG001AGE,SNG001ASE,SNG001USI,SNG001FIN,SNG015COD,
         SNG001USC,SNG001EMC,SNG014COD,SNG01ICUOT,SNG001EJEC,SNG001NGRP,SNG001EVER
    from SNG001_tmp ;                              
           
  begin
    begin
         insert into SNG001_tmp  (SNG001INST,SNG001EMP,SNG001CTA,SNG001PAIS,SNG001TDOC,SNG001NDOC,
                     SNG001ORI,SNG001SEG,SNG001AGE,SNG001ASE,SNG001USI,SNG001FIN,SNG015COD,
                     SNG001USC,SNG001EMC,SNG014COD,SNG01ICUOT,SNG001EJEC,SNG001NGRP,SNG001EVER)
         select /*b.n_nummov*/ SNG001INST,SNG001EMP,SNG001CTA,SNG001PAIS,SNG001TDOC,SNG001NDOC,
                SNG001ORI,SNG001SEG,SNG001AGE,SNG001ASE,SNG001USI,SNG001FIN,SNG015COD,
                SNG001USC,SNG001EMC,SNG014COD,SNG01ICUOT,SNG001EJEC,SNG001NGRP,SNG001EVER
           from SNG001_tmp@credinka a/*, btctaprd b
           where a.sng001inst = b.n_nroist*/;          
    exception 
        when others then 
           lc_coderr := sqlerrm;
            --insertar a una tabla generica de excepciones (dato y la bandeja)
            insert into LOG_ERROR_BANDEJA
              (n_nro, c_codbdj, c_deserr, d_fecerr)
            values
              (5, 'SNG001_tmp', lc_coderr, sysdate);
           commit;
    end; 
      for i in sng1 loop 
           begin
             insert into bantprod.SNG001 (SNG001INST,SNG001EMP,SNG001CTA,SNG001PAIS,SNG001TDOC,SNG001NDOC,
                         SNG001ORI,SNG001SEG,SNG001AGE,SNG001ASE,SNG001USI,SNG001FIN,SNG015COD,
                         SNG001USC,SNG001EMC,SNG014COD,SNG01ICUOT,SNG001EJEC,SNG001NGRP,SNG001EVER)
            values(i.SNG001INST,i.SNG001EMP,i.SNG001CTA,i.SNG001PAIS,i.SNG001TDOC,i.SNG001NDOC,
                   i.SNG001ORI,i.SNG001SEG,i.SNG001AGE,i.SNG001ASE,i.SNG001USI,i.SNG001FIN,i.SNG015COD,
                   i.SNG001USC,i.SNG001EMC,i.SNG014COD,i.SNG01ICUOT,i.SNG001EJEC,i.SNG001NGRP,i.SNG001EVER) ;                             
           
           exception
              when others then
                    lc_coderr := sqlerrm;
                    --insertar a una tabla generica de excepciones (dato y la bandeja)
                    insert into LOG_ERROR_BANDEJA
                      (n_nro, c_codbdj, c_deserr, d_fecerr)
                    values
                      (6, 'sng001', i.SNG001CTA||'-'||lc_coderr, sysdate);
                   commit;
            end;       
         end loop;
end;
Procedure sp_cr_sng003 is 
  begin
      insert into bantprod.sng003
      (SNG001INST,
       SNG003PGC,
       SNG003CTA,
       SNG003COR,
       SNG003TPO
      )
      select /*b.n_nummov*/ SNG001INST,
             SNG003PGC,
             SNG003CTA,
             SNG003COR,
             SNG003TPO
        from sng003_tmp@credinka a/*
             , btctaprd b
        where a.SNG001INST = b.n_nroist */;
        commit;        
  exception
  when others then
    null;   
  End sp_cr_sng003;
  Procedure sp_cr_xwf700 is 
  begin
      insert into bantprod.xwf700
      (XWFEMPRESA,
       XWFSUCURSAL,
       XWFMODULO,
       XWFMONEDA,
       XWFPAPEL,
       XWFCUENTA,
       XWFOPERACION,
       XWFSUBOPE,
       XWFTIPOPE,
       XWFPRCINS,
       XWFMONTO1,
       XWFMONTO2,
       XWFPLAZO1,
       XWFPLAZO2,
       XWFCAR1,
       XWFCAR2,
       XWFFEC1,
       XWFEMP1,
       XWFCTA1,
       XWFCAR3    
      )
      select XWFEMPRESA,
             XWFSUCURSAL,
             XWFMODULO,
             XWFMONEDA,
             XWFPAPEL,
             XWFCUENTA,
             XWFOPERACION,
             XWFSUBOPE,
             XWFTIPOPE,
            /* n_nummov, --*/XWFPRCINS,
             XWFMONTO1,
             XWFMONTO2,
             XWFPLAZO1,
             XWFPLAZO2,
             XWFCAR1,
             XWFCAR2,
             XWFFEC1,
             XWFEMP1,
             XWFCTA1,
             XWFCAR3    
        from xwf700_tmp@credinka a/*, btctaprd b
        where a.xwfprcins = b.n_nroist*/;
        commit;        
  exception
  when others then
    null;  
  End sp_cr_xwf700;
   Procedure sp_cr_x054023 is 
  begin
  insert into bantprod.x054023
      (XLLPGCOD ,
       XLLAOMOD ,
       XLLAOSUC ,
       XLLAOMDA ,
       XLLAOPAP,
       XLLAOCTA ,
       XLLAOOPER ,
       XLLAOSBOP ,
       XLLAOTOP ,
       XLLFVALOR,
       XLLCAPITAL ,
       XLLFPRIMPA ,
       XLLCANTCUO ,
       XLLPERIODO ,
       XLLTIPOPRE ,
       XLLTIPODIA ,
       XLLTIPOTAS, 
       XLLTASAP ,
       XLLGRADPER ,
       XLLGRADPOR,
       xlltipoano 
      )
      select XLLPGCOD ,
             XLLAOMOD ,
             XLLAOSUC ,
             XLLAOMDA ,
             XLLAOPAP,
             XLLAOCTA ,
             XLLAOOPER ,
             XLLAOSBOP ,
             XLLAOTOP ,
             XLLFVALOR,
             XLLCAPITAL ,
             XLLFPRIMPA ,
             XLLCANTCUO ,
             XLLPERIODO ,
             XLLTIPOPRE ,
             XLLTIPODIA ,
             XLLTIPOTAS, 
             XLLTASAP ,
             XLLGRADPER ,
             XLLGRADPOR,
             xlltipoano 
        from x054023_tmp@credinka ;
        commit;        
  exception
  when others then
    null;
  End sp_cr_x054023;
  procedure sp_llena_BNJ005 is
  lc_coderr Varchar2(300);
  begin 
             insert into bnj005 (      BnjSCEmp, -- Empresa 1
                          BnjSCSuc, -- Sucursal de la garantia
                          BnjSCRub, -- Rubro de la garantia
                          BnjSCMda, -- Moneda
                          BnjSCPap, -- Papel
                          BnjSCCta, -- Cuenta cliente
                          BnjSCOpe, -- Operacion
                          BnjSCSub, -- Sub operacion 
--                          BNJSIM15, -- Sub Operacion para CTS
                          BnjSCTOp, -- Tipo Operacion 
                          BnjSCSta, -- 0
                          BnjSCSdo, -- SAldo Contable
                          BnjSCEst, -- Estado = 'P'
                          BNJSIM14, -- Rubro Generico (todo en moneda soles el 3er digito siempre es 1)
                          BnjSCBnd, -- Codigo de bandeja
                          BnjSCFun, -- 0
                          BNJSIM3 -- Datos adicionales) 
                          )
             select BnjSCEmp, -- Empresa 1
                          BnjSCSuc, -- Sucursal de la garantia
                          BnjSCRub, -- Rubro de la garantia
                          BnjSCMda, -- Moneda
                          BnjSCPap, -- Papel
                          BnjSCCta, -- Cuenta cliente
                          BnjSCOpe, -- Operacion
                          BnjSCSub, -- Sub operacion 
--                          BNJSIM15, -- Sub Operacion para CTS
                          BnjSCTOp, -- Tipo Operacion 
                          nvl(BnjSCSta,0), -- 0
                          BnjSCSdo, -- SAldo Contable
                          BnjSCEst, -- Estado = 'P'
                          BNJSIM14, -- Rubro Generico (todo en moneda soles el 3er digito siempre es 1)
                          BnjSCBnd, -- Codigo de bandeja
                          BnjSCFun, -- 0
                          BNJSIM3 from BNJ005@credinka;
             commit; 
             exception
                when others then
                  lc_coderr := sqlerrm;
                  insert into log_error_bandeja(n_nro,c_codbdj,c_deserr,d_fecerr)
                  values (1,'BNJ005_0',lc_coderr,trunc(sysdate));   
                  commit;
            
end;
end pq_migra_Activas_cdk;
/
