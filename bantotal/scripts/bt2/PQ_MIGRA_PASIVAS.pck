create or replace package PQ_MIGRA_PASIVAS is

  -- Author  : YLOZADA
  -- Created : 25/09/2015 04:50:52 p.m.
  -- Purpose : 
  
  -- Public type declarations
  -- Public function and procedure declarations
  Procedure sp_bandeja_bnj002;
  Procedure sp_bandeja_bnj004;
  Procedure sp_bandeja_bnj012;  
  Procedure sp_bandeja_bnj601;  
  Procedure sp_bandeja_bnj602;  
  Procedure sp_bandeja_JAQL714;
  Procedure sp_bandeja_CTS001;
  Procedure sp_bandeja_bjr011;    
  Procedure sp_bandeja_bjr111;    
  Procedure sp_bandeja_bnjti2;  
  Procedure sp_bandeja_bjd016 ;    
end PQ_MIGRA_PASIVAS;
/
create or replace package body PQ_MIGRA_PASIVAS is

  Procedure sp_bandeja_bnj002 is
    lc_error VARCHAR2(400);
   begin 
      insert /*+append */  into bandejas.BNJ002
        (bnjemp,
         bnjcod,
         bnjsuc,
         bnjmda,
         bnjpap,
         bnjcta,
         bnjope,
         bnjsbop,
         bnjtope,
         bnjsdo,
         bnjfval,
         bnjfvto,
         bnjfulm,
         bnjpzo,
         bnjttas,
         bnjtasa,
         bnjtmor,
         bnjttac,
         bnjtasc,
         bnjtdia,
         bnjtvto,
         bnjtano,
         bnjtint,
         bnjdrev,
         bnjimp,
         bnjim2,
         bnjim3,
         bnjim4,
         bnjim5,
         bbjim6,
         bnjim7,
         bnjim8,
         bnjim9,
         bnjim10,
         bnjim11,
         bnjim12,
         bnjim13,
         bnjim14,
         bnjim15,
         bnjvt11,
         bnjvt12,
         bnjvt13,
         bnjvt14,
         bnjvt15,
         bnjcon1,
         bnjpre,
         bnjpre1,
         bnjtcbi,
         bnjtcbi1,
         bnjarb,
         bnjarb1,
         bnjmd,
         bnjmd1,
         bnjnume,
         bnjfnum,
         bnjafiv,
         bnjcbcu,
         bnjstat,
         bnjavis,
         bnjplus,
         bnjeven,
         bnjfe99,
         bnjcltcod,
         bnjperiod,
         bnjcot1,
         bnjcot3,
         bnjcot4,
         bnjcot2,
         bnjok,
         bnjcon2)
        select 1,
               BnjCod,
               BnjSuc,
               BnjMda,
               BnjPap,
               BnjCta,
               BnjOpe,
               BnjSbOp,
               BnjTOpe,
               BnjSdo,
               BnjFval,
               BnjFvto,
               BnjFulm,
               BnjPzo,
               BnjTtas,
               BnjTasa,
               BnjTmor,
               BnjTtac,
               BnjTasc,
               BnjTdia,
               BnjTvto,
               BnjTano,
               BnjTint,
               BnjDrev,
               BnjImp,
               BnjIm2,
               BnjIm3,
               BnjIm4,
               BnjIm5,
               null, --BnjIm6,
               BnjIm7,
               BnjIm8,
               BnjIm9,
               BnjIm10,
               BnjIm11,
               BnjIm12,
               BnjIm13,
               BnjIm14,
               BnjIm15,
               BnjVt11,
               BnjVt12,
               BnjVt13,
               BnjVt14,
               BnjVt15,
               BnjCon1,
               BnjPre,
               BnjPre1,
               BnjTcbi,
               BnjTcbi1,
               BnjArb,
               BnjArb1,
               BnjMd,
               BnjMd1,
               BnjNume,
               BnjFnum,
               BnjAfiv,
               BnjCbcu,
               BnjStat,
               BnjAvis,
               BnjPlus,
               BnjEven,
               BnjFe99,
               BnjCltcod,
               BnjPeriod,
               BnjCoT1,
               BNJCOT3,
               --to_char(BNJCOT4,'dd/mm/rrrr'),
               to_char(to_date(substr(BNJCOT4,1,10), 'rrrr-mm-dd'), 'dd/mm/rrrr'),
               BNJCOT2,
               BnjOK,
               0
          from BNJ002@credinka; --bandejas.BNJ002_TMP;
    commit;      
   Exception
   when others then 
   lc_error := sqlerrm;
    --insertar a una tabla generica de excepciones (dato y la bandeja)
    insert into LOG_ERROR_BANDEJA
      (n_nro,c_codbdj,c_deserr,d_fecerr)
    values
      (999,'BNJ002',lc_error,sysdate);
    commit;     
   end sp_bandeja_bnj002;
   

  Procedure sp_bandeja_bnj004 is
    lc_error VARCHAR2(400);
  begin  
      insert /*+append */   into bandejas.BNJ004
        (bnjcvcode,
         bnjcvcodb,
         bnjcvmod,
         bnjcvmda,
         bnjcvpap,
         bnjcvcta,
         bnjcvsuc,
         bnjcvope,
         bnjcvsbo,
         bnjcvtop,
         bnjcvcsp,
         bnjcvsmo,
         bnjcvcch,
         bnjcvpin,
         bnjcvcin,
         bnjcvsbg,
         bnjcvcau,
         bnjcvest,
         bnjcvpmi,
         bnjcvnom,
         bnjcvfcb,
         bnjcvusb,
         bnjcvwsb,
         bnjcvtce,
         bnjcvfol,
         bnjcv1fre,
         bnjcv1fol,
         bnjcv1ulf,
         bnjcv1imp,
         bnjcv1tde,
         bnjcv1sda,
         bnjcv1aux1,
         bnjcv1aux2,
         bnjcv1aux3,
         bnjcv1aux4,
         bnjcv1aux5,
         bnjcv1aux6,
         bnjcv1aux7,
         bnjcvok,
         bnjcvprc)
        select BnjCvCodE,
               BnjCvCodB,
               BnjCvMod,
               BnjCvMda,
               BnjCvPap,
               BnjCvCta,
               BnjCvSuc,
               BnjCvOpe,
               BnjCvSbo,
               BnjCvTop,
               BnjCvCsp,
               BnjCvSmo,
               BnjCvCch,
               BnjCvPin,
               BnjCvCin,
               BnjCvSbg,
               BnjCvCau,
               BnjCvEst,
               BnjCvPmi,
               BnjCvNom,
               BnjCvFcb,
               BnjCvUsb,
               BnjCvWsb,
               BnjCvTce,
               BnjCvFol,
               BnjCv1Fre,
               BnjCv1Fol,
               BnjCv1Ulf,
               BnjCv1Imp,
               BnjCv1Tde,
               BnjCv1Sda,
               substr(BnjCv1Aux1, 1, 1),
               BnjCv1Aux2,
               BnjCv1Aux3,
               BnjCv1Aux4,
               BnjCv1Aux5,
               BnjCv1Aux6,
               BnjCv1Aux7,
               BnjCvOk,
               BnjCvPrc
          from bnj004@credinka; --bandejas.bnj004_tmp;      
  commit;      
  Exception
  when others then 
  lc_error := sqlerrm;
    --insertar a una tabla generica de excepciones (dato y la bandeja)
    insert into LOG_ERROR_BANDEJA
      (n_nro,c_codbdj,c_deserr,d_fecerr)
    values
      (999,'BNJ004',lc_error,sysdate);
    commit;     
  end sp_bandeja_bnj004;   
  
  Procedure sp_bandeja_bnj012 is
    lc_error VARCHAR2(400);
  begin    
      insert /*+append */  into bandejas.BNJ012(
                 bnjemp ,   
                 bnjcod ,  
                 bnjaocod,  
                 bnjaomod,  
                 bnjaosuc,  
                 bnjaomda,  
                 bnjaopap,  
                 bnjaocta,  
                 bnjaooper, 
                 bnjaosbop, 
                 bnjaotope, 
                 bnjevcorr, 
                 bnjevtipo, 
                 bnjevfval, 
                 bnjevttas, 
                 bnjevtasa, 
                 bnjevest  
                 )
      select  BnjEmp,         
              BnjCod,        
              BnjAocod,      
              Bnjaomod,    
              BnjAosuc,    
              BnjAomda,    
              BnjAopap,    
              BnjAocta,    
              BnjAooper,   
              BnjAosbop,   
              BnjAotope,   
              BnjEvcorr,   
              BnjEvtipo,   
              BnjEvfval,   
              BnjEvttas,   
              BnjEvtasa,   
              BnjEvEst  
      from BNJ012@credinka; --bandejas.BNJ012_TMP;      
  commit;      
  Exception
  when others then 
  lc_error := sqlerrm;
    --insertar a una tabla generica de excepciones (dato y la bandeja)
    insert into LOG_ERROR_BANDEJA
      (n_nro,c_codbdj,c_deserr,d_fecerr)
    values
      (999,'BNJ012',lc_error,sysdate);
    commit;     
  end sp_bandeja_bnj012;   

  Procedure sp_bandeja_bnj601 is
    lc_error VARCHAR2(400);
  begin  
        insert /*+append */ into bandejas.bnj601
          (bnjemp,
           bnjcod,
           bnjsuc,
           bnjmda,
           bnjpap,
           bnjcta,
           bnjope,
           bnjsbop,
           bnjtope,
           bnjfpag,
           bnjtipo,
           b601fval,
           b601fvto,
           b601pzo,
           b601cap,
           b601int,
           b601icap,
           b601iint,
           b601stat,
           b601pago,
           b601est)
          select BnjEmp,
                 BnjCod,
                 BnjSuc,
                 BnjMda,
                 BnjPap,
                 BnjCta,
                 BnjOpe,
                 BnjSbOp,
                 BnjTOpe,
                 BnjFPag,
                 BnjTipo,
                 B601FVal,
                 B601FVto,
                 B601Pzo,
                 B601Cap,
                 B601Int,
                 B601ICap,
                 B601IInt,
                 B601Stat,
                 B601Pago,
                 B601Est
            from bnj601@credinka; --bandejas.bnj601_tmp;
  commit;      
  Exception
  when others then 
  lc_error := sqlerrm;
    --insertar a una tabla generica de excepciones (dato y la bandeja)
    insert into LOG_ERROR_BANDEJA
      (n_nro,c_codbdj,c_deserr,d_fecerr)
    values
      (999,'BNJ601',lc_error,sysdate);
    commit;     
  end sp_bandeja_bnj601;   

  Procedure sp_bandeja_bnj602 is
    lc_error VARCHAR2(400);
  begin    
        insert /*+append */ into bandejas.bnj602
          (bnjemp,
           bnjcod,
           bnjsuc,
           bnjmda,
           bnjpap,
           bnjcta,
           bnjope,
           bnjsbop,
           bnjtope,
           bnjfpag,
           bnjtipo,
           bnjnump,
           b602fech,
           b602cap,
           b602int,
           b602mor,
           b602icap,
           b602iint,
           b602imor,
           b602scap,
           b602sint,
           b602sade,
           b602smor,
           b602stat,
           b602est)
          select BnjEmp,
                 BnjCod,
                 BnjSuc,
                 BnjMda,
                 BnjPap,
                 BnjCta,
                 BnjOpe,
                 BnjSbOp,
                 BnjTOpe,
                 BnjFPag,
                 BnjTipo,
                 BnjNumP,
                 B602Fech,
                 B602Cap,
                 B602Int,
                 B602Mor,
                 B602ICap,
                 B602IInt,
                 B602IMor,
                 B602SCap,
                 B602SInt,
                 B602SAde,
                 B602SMor,
                 B602Stat,
                 B602Est
            from bnj602@credinka; --bandejas.bnj602_tmp;
  commit;      
  Exception
  when others then 
  lc_error := sqlerrm;
    --insertar a una tabla generica de excepciones (dato y la bandeja)
    insert into LOG_ERROR_BANDEJA
      (n_nro,c_codbdj,c_deserr,d_fecerr)
    values
      (999,'BNJ602',lc_error,sysdate);
    commit;     
  end sp_bandeja_bnj602;   

  Procedure sp_bandeja_JAQL714 is
    lc_error VARCHAR2(400);
  begin    
    --null;
    insert /*+append */ into jaql714
    select * from jaql714@credinka;
  commit;      
  Exception
  when others then 
  lc_error := sqlerrm;
    --insertar a una tabla generica de excepciones (dato y la bandeja)
    insert into LOG_ERROR_BANDEJA
      (n_nro,c_codbdj,c_deserr,d_fecerr)
    values
      (999,'JAQL714',lc_error,sysdate);
    --commit;     
  end sp_bandeja_JAQL714;   

  Procedure sp_bandeja_CTS001 is
    lc_error VARCHAR2(400);
  begin   
      insert into cts001
        (ctspemp1,
         ctstemp1,
         ctsnemp1,
         ctspemp2,
         ctstemp2,
         ctsnemp2,
         ctsctae2,
         ctstiprg,
         ctsfecrg,
         ctshorrg,
         ctsusurg,
         ctssucrg,
         ctsmdarm,
         ctsimprm,
         ctsmdacb,
         ctsauxn2)
        select ctspemp1,
               ctstemp1,
               ctsnemp1,
               ctspemp2,
               ctstemp2,
               ctsnemp2,
               ctsctae2,
               ctstiprg,
               ctsfecrg,
               ctshorrg,
               ctsusurg,
               ctssucrg,
               ctsmdarm,
               ctsimprm,
               ctsmdacb,
               ctsauxn2
          from bandejas.cts001_tmp; --1475   
  commit;      
  Exception
  when others then 
  lc_error := sqlerrm;
    --insertar a una tabla generica de excepciones (dato y la bandeja)
    insert into LOG_ERROR_BANDEJA
      (n_nro,c_codbdj,c_deserr,d_fecerr)
    values
      (999,'CTS001',lc_error,sysdate);
    commit;     
  end sp_bandeja_CTS001;       
  
  Procedure sp_bandeja_bjr011 is
    lc_error VARCHAR2(400);
  begin    
    insert /*+append */  into BJR011
    select * from BJR011@credinka; --bandejas.BJR011_TMP;        
  commit;      
  Exception
  when others then 
  lc_error := sqlerrm;
    --insertar a una tabla generica de excepciones (dato y la bandeja)
    insert into LOG_ERROR_BANDEJA
      (n_nro,c_codbdj,c_deserr,d_fecerr)
    values
      (999,'BJR011',lc_error,sysdate);
    commit;     
  end sp_bandeja_bjr011;     
  Procedure sp_bandeja_bjr111 is
    lc_error VARCHAR2(400);
  begin    
    insert /*+append */  into BJR111
    select * from BJR111@credinka; --bandejas.BJR111_TMP;        
  commit;      
  Exception
  when others then 
  lc_error := sqlerrm;
    --insertar a una tabla generica de excepciones (dato y la bandeja)
    insert into LOG_ERROR_BANDEJA
      (n_nro,c_codbdj,c_deserr,d_fecerr)
    values
      (999,'BJR111',lc_error,sysdate);
    commit;     
  end sp_bandeja_bjr111;     
  
  Procedure sp_bandeja_bnjti2 is
    lc_error VARCHAR2(400);
    TYPE t_bnjti2 IS TABLE OF bnjti2%ROWTYPE;  
    l_tab9   t_bnjti2;  
    
    CURSOR c_bnjti2 IS
        SELECT *
        FROM bnjti2;  
              
  begin    
      begin
      insert /*+append */ into BNJTI2
        (bt2emp,
         bt2suc,
         bt2mod,
         bt2mda,
         bt2pap,
         bt2cta,
         bt2ope,
         bt2sub,
         bt2top,
         bt2imp,
         bt2band,
         bt2corr,
         bt2cond,
         bt2rub,
         bt2coef,
         bt2mnto,
         bt2min,
         bt2minb,
         bt2minf,
         bt2max,
         bt2est)
        select bt2emp,
               bt2suc,
               bt2mod,
               bt2mda,
               bt2pap,
               bt2cta,
               bt2ope,
               bt2sub,
               bt2top,
               bt2imp,
               bt2band,
               bt2corr,
               bt2cond,
               bt2rub,
               bt2coef,
               bt2mnto,
               bt2min,
               bt2minb,
               bt2minf,
               bt2max,
               bt2est
          from BNJTI2@credinka; --bandejas.BNJTI2_TMP;
          commit; 
       Exception
       When others then        
          lc_error := sqlerrm;
            --insertar a una tabla generica de excepciones (dato y la bandeja)
            insert into LOG_ERROR_BANDEJA
              (n_nro,c_codbdj,c_deserr,d_fecerr)
            values
              (999,'BNJTI2',lc_error,sysdate);
            commit;              
       end;
       begin
        /* TI0010 */
        OPEN c_bnjti2;    
        LOOP
          FETCH c_bnjti2
          BULK COLLECT INTO l_tab9 LIMIT 10000;
          EXIT WHEN l_tab9.count = 0;  
          
          FORALL i IN l_tab9.first .. l_tab9.last
            INSERT /*+ APPEND_VALUES */ INTO TI0010 
              (TiPgcod, TiScSuc, TiScMod, TiScMda, TiScPap, TiScCta, 
               TiScOper, TiScSbop, TiScTope, TiimpuCod, TiDimCorr, TiopRub, 
               TiopCoef, TiopMnto, TiopMin, TiopMinBas, TiopMinFor, TiopImpMax)
            VALUES (l_tab9(i).BT2Emp, l_tab9(i).BT2Suc, l_tab9(i).BT2Mod, 
                    l_tab9(i).BT2Mda, l_tab9(i).BT2Pap, l_tab9(i).BT2Cta, 
                    l_tab9(i).BT2Ope, l_tab9(i).BT2Sub, l_tab9(i).BT2TOp, 
                    l_tab9(i).BT2Imp, l_tab9(i).BT2Corr, l_tab9(i).BT2Rub, 
                    l_tab9(i).BT2Coef, l_tab9(i).BT2Mnto, l_tab9(i).BT2Min, 
                    l_tab9(i).BT2MinB, l_tab9(i).BT2MinF, l_tab9(i).BT2Max);
          commit;
        END LOOP;
        CLOSE c_bnjti2;  
        Exception
        When others then
           lc_error := sqlerrm;
              --insertar a una tabla generica de excepciones (dato y la bandeja)
              insert into LOG_ERROR_BANDEJA
                (n_nro,c_codbdj,c_deserr,d_fecerr)
              values
                (999,'TI0010',lc_error,sysdate);
              commit;               
        end;
        commit;
  Exception
  when others then 
       null;
  end sp_bandeja_bnjti2;  
  -- Se agrego para Credinka
  Procedure sp_bandeja_bjd016 is
    lc_error VARCHAR2(400);
  begin    
        insert /*+append */ into bandejas.bjd016
          ( BNJEMP,
            BNJCOD,
            BD016SUC,
            BD016MDA,
            BD016PAP,
            BD016CTA,
            BD016OPE,
            BD016SBOP,
            BD016TOPE,
            BD016SUCOR,
            BD016CORR,
            BD016CORR1,
            BD016FCON,
            BD016FVAL,
            BD016CMOV,
            BD016REF,
            BD016TXT,
            BD016IMP,
            BD016DH,
            BD016CH,
            BD016AX1,
            BD016AX2,
            BD016AX3,
            BD016AX4,
            BD016AX5,
            BD016AX6,
            BD016AX7,
            BD016STAT,
            BD016MOD,
            BD016SINI,
            BD016SACT
)
          select  BNJEMP,
                  BNJCOD,
                  BD016SUC,
                  BD016MDA,
                  BD016PAP,
                  BD016CTA,
                  BD016OPE,
                  BD016SBOP,
                  BD016TOPE,
                  BD016SUCOR,
                  BD016CORR,
                  BD016CORR1,
                  BD016FCON,
                  BD016FVAL,
                  BD016CMOV,
                  BD016REF,
                  BD016TXT,
                  BD016IMP,
                  BD016DH,
                  BD016CH,
                  BD016AX1,
                  BD016AX2,
                  BD016AX3,
                  BD016AX4,
                  BD016AX5,
                  BD016AX6,
                  BD016AX7,
                  BD016STAT,
                  BD016MOD,
                  BD016SINI,
                  BD016SACT
            from bjd016@credinka; --bandejas.bnj602_tmp;
  commit;      
  Exception
  when others then 
  lc_error := sqlerrm;
    --insertar a una tabla generica de excepciones (dato y la bandeja)
    insert into LOG_ERROR_BANDEJA
      (n_nro,c_codbdj,c_deserr,d_fecerr)
    values
      (999,'BJD016',lc_error,sysdate);
    commit;     
  end sp_bandeja_bjd016;   
  
end PQ_MIGRA_PASIVAS;
/
