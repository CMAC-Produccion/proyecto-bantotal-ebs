create or replace package PQ_CR_DATOS_ACUERDOS is

  -- Author  : EFUENTES
  -- Created : 15/10/2021 12:45:11
  -- Purpose : 

  --*********************************************************
  procedure sp_datos_acuerdo(pn_Acuerdo in NUMBER,--(17)
                             pv_CodMemo out VARCHAR2,--(25)
                             pv_DesMemo out VARCHAR2,--(40)
                             pn_DeuTot  out NUMBER,--(17,2)
                             pv_Moneda  out VARCHAR2,--(4)
                             pn_Cuenta  out NUMBER,--(9)
                             pn_Opera   out NUMBER,--(9)
                             pn_MntCap  out NUMBER,--(17,2)
                             pn_MntInt  out NUMBER,--(17,2)
                             pn_MntIcv	out NUMBER,--(17,2)
                             pn_MntMor  out NUMBER,--(17,2)
                             pn_MntPen  out NUMBER,--(17,2)
                             pn_MntSeg  out NUMBER,--(17,2)
                             pn_MntOtro out NUMBER,--(17,2)
                             pn_MntAcu  out NUMBER,--(17,1)
                             pn_FecAcu  out DATE,
                             pv_LtrsFA  out VARCHAR2,--(255)
                             pv_NomCli  out VARCHAR2,--(30)
                             pv_DesTdoc out VARCHAR2,--(20)
                             pv_NumDoc  out VARCHAR2,--(12)
                             pv_DepDes	out VARCHAR2,--(20)
                             pv_ProDes  out VARCHAR2,--(30)
                             pv_DisDes  out VARCHAR2,--(30)
                             pv_DirDes  out VARCHAR2,--(140)
                             pv_LDeuTot  out VARCHAR2,--(30)
                             pv_LMntCap  out VARCHAR2,--(30)
                             pv_LMntInt  out VARCHAR2,--(30)
                             pv_LMntIcv	 out VARCHAR2,--(30)
                             pv_LMntMor  out VARCHAR2,--(30)
                             pv_LMntPen  out VARCHAR2,--(30)
                             pv_LMntSeg  out VARCHAR2,--(30)
                             pv_LMntOtro out VARCHAR2,--(30)
                             pv_LMntAcu  out VARCHAR2,--(30)
                             pv_DesCiud  out VARCHAR2,--(30)
                             pv_DesPer   out VARCHAR2,--(30)
                             pv_NomTIT   out VARCHAR2--(30)
                             );
                             
  --*********************************************************
  procedure sp_datos_direccion(pv_pepais  in NUMBER,--(3);
                               pv_petdoc  in NUMBER,--(2);
                               pv_NumDoc  in VARCHAR2,--(12)
                               pv_DepDes	out VARCHAR2,--(20)
                               pv_ProDes  out VARCHAR2,--(30)
                               pv_DisDes  out VARCHAR2,--(30)
                               pv_DirDes  out VARCHAR2--(140)
                              );

end PQ_CR_DATOS_ACUERDOS;
/

create or replace package body PQ_CR_DATOS_ACUERDOS is

  --*********************************************************
  procedure sp_datos_acuerdo(pn_Acuerdo  in NUMBER,--(17)
                             pv_CodMemo  out VARCHAR2,--(25)
                             pv_DesMemo  out VARCHAR2,--(40)
                             pn_DeuTot   out NUMBER,--(17,2)
                             pv_Moneda   out VARCHAR2,--(4)
                             pn_Cuenta   out NUMBER,--(9)
                             pn_Opera    out NUMBER,--(9)
                             pn_MntCap   out NUMBER,--(17,2)
                             pn_MntInt   out NUMBER,--(17,2)
                             pn_MntIcv   out NUMBER,--(17,2)
                             pn_MntMor   out NUMBER,--(17,2)
                             pn_MntPen   out NUMBER,--(17,2)
                             pn_MntSeg   out NUMBER,--(17,2)
                             pn_MntOtro  out NUMBER,--(17,2)
                             pn_MntAcu   out NUMBER,--(17,1)
                             pn_FecAcu   out DATE,
                             pv_LtrsFA   out VARCHAR2,--(255)
                             pv_NomCli   out VARCHAR2,--(30)
                             pv_DesTdoc  out VARCHAR2,--(20)
                             pv_NumDoc   out VARCHAR2,--(12)
                             pv_DepDes   out VARCHAR2,--(20)
                             pv_ProDes   out VARCHAR2,--(30)
                             pv_DisDes   out VARCHAR2,--(30)
                             pv_DirDes   out VARCHAR2,--(140)
                             pv_LDeuTot  out VARCHAR2,--(30)
                             pv_LMntCap  out VARCHAR2,--(30)
                             pv_LMntInt  out VARCHAR2,--(30)
                             pv_LMntIcv	 out VARCHAR2,--(30)
                             pv_LMntMor  out VARCHAR2,--(30)
                             pv_LMntPen  out VARCHAR2,--(30)
                             pv_LMntSeg  out VARCHAR2,--(30)
                             pv_LMntOtro out VARCHAR2,--(30)
                             pv_LMntAcu  out VARCHAR2,--(30)
                             pv_DesCiud  out VARCHAR2,--(30)
                             pv_DesPer   out VARCHAR2,--(30) periocidad
                             pv_NomTIT    out VARCHAR2--(30) --pv_NomTIT
                             ) is
    my_errm    VARCHAR2(32000);
    pn_coderr  NUMBER(4);
    
    ln_CodMone NUMBER(4);
    lv_anio    VARCHAR2(5);
    lv_mes     VARCHAR2(15);
    lv_dia     VARCHAR2(2);
    
    lv_pepais  NUMBER(3);
    lv_petdoc  NUMBER(2);

    lv_NoObli  VARCHAR2(1);
    
    ln_CodSuc  NUMBER(3);
    ln_CodCiu  NUMBER(5);
    
    lv_Frecue  VARCHAR2(1);
    
    ------TITULAR
    lv_paisTit  NUMBER(3);
    lv_tdocTit  NUMBER(2);
    lv_NumTIT   VARCHAR2(12);
    lc_ubigeo varchar(6);
    lv_pepaisno number(4);

    cod_departa VARCHAR2(6);
    cod_provincia VARCHAR2(6);
    cod_distrito VARCHAR2(6);
    
    
  begin
  
    pn_MntOtro := 0.00; --verificar este dato 
    
    --datos del acuerdo
    begin
      select a.AQPA806MEMO,
             a.AQPA806TOTD,
             a.AQPA806MDA,
             a.AQPA806CTA,
             a.AQPA806OPE,
             a.AQPA806CAP,
             a.AQPA806INT,
             a.AQPA806ICV,
             a.AQPA806MOR,
             a.AQPA806PEN,
             a.AQPA806SEG,
             a.AQPA806FECA,
             a.AQPA806MTOI,
             a.AQPA806ESTP,
             a.AQPA806SUC,
             AQPA806CUOFRE
        into pv_CodMemo,
             pn_DeuTot,
             ln_CodMone,
             pn_Cuenta,
             pn_Opera,
             pn_MntCap,
             pn_MntInt,
             pn_MntIcv,
             pn_MntMor,
             pn_MntPen,
             pn_MntSeg,
             pn_FecAcu,
             pn_MntAcu,
             lv_NoObli,
             ln_CodSuc,
             lv_Frecue
        from aqpa806 a
       where a.aqpa806cod = pn_Acuerdo;
        
        pv_LDeuTot  := TRIM(TO_CHAR(pn_DeuTot, '99999999999999999D99'));--(17,2)
        pv_LMntCap  := TRIM(TO_CHAR(pn_MntCap, '99999999999999999D99'));--(17,2)
        pv_LMntInt  := TRIM(TO_CHAR(pn_MntInt, '99999999999999999D99'));--(17,2)
        pv_LMntIcv	:= TRIM(TO_CHAR(pn_MntIcv, '99999999999999999D99'));--(17,2)
        pv_LMntMor  := TRIM(TO_CHAR(pn_MntMor, '99999999999999999D99'));--(17,2)
        pv_LMntPen  := TRIM(TO_CHAR(pn_MntPen, '99999999999999999D99'));--(17,2)
        pv_LMntSeg  := TRIM(TO_CHAR(pn_MntSeg, '99999999999999999D99'));--(17,2)
        pv_LMntOtro := TRIM(TO_CHAR(pn_MntOtro, '99999999999999999D99'));--(17,2)
        pv_LMntAcu  := TRIM(TO_CHAR(pn_MntAcu, '99999999999999999D99'));--(17,1)

    exception
      when others then
        pv_DesMemo := '';
        pn_coderr  := 1;
        my_errm    := SQLERRM;
        DBMS_OUTPUT.put_line(pn_coderr || '-' || my_errm);
    end;
    
    --cuando es titular -> titular de la cuenta ??
    
    --PERIODICIDAD
    pv_DesPer := case when lv_Frecue = 'Q'
                        then 'Quincenal'
                      when lv_Frecue = 'M'
                        then 'Mensual'                        
                      when lv_Frecue = 'T'
                        then 'Trimestral'
                      else 'Semestral' --S
                 end;
    
    -- simbolo moneda
    begin
      select trim(mosign)
        into pv_Moneda
        from Fst005
       where moneda = ln_CodMone;
    exception
      when others then
        pv_DesMemo := '';
        pn_coderr  := 2;
        my_errm    := SQLERRM;
        DBMS_OUTPUT.put_line(pn_coderr || '-' || my_errm);
    end;
    
    -- decripcion memo 
    begin
      select AQPA423MEMO des_memo
        into pv_DesMemo
        from AQPA423 a
       where AQPA423ESTA = 'S'
         and AQPA423CODM = pv_CodMemo;
    exception
      when others then
        pv_DesMemo := '';
        pn_coderr  := 3;
        my_errm    := SQLERRM;
        DBMS_OUTPUT.put_line(pn_coderr || '-' || my_errm);
    end;
    
    -- fecha acuerdo letras
    begin
      lv_anio := trim(to_char(pn_FecAcu, 'YYYY'));
      lv_mes  := trim(to_char(pn_FecAcu,
                              'Month',
                              'nls_date_language=spanish'));
      lv_dia  := trim(to_char(pn_FecAcu, 'DD'));
    
      pv_LtrsFA := lv_dia || ' de ' || lv_mes || ' del ' || lv_anio;
    exception
      when others then
        pv_LtrsFA := '';
        pn_coderr := 4;
        my_errm   := SQLERRM;
        DBMS_OUTPUT.put_line(my_errm);
    end;

    
   -- if lv_NoObli = 'N' then
      -- titular 
      begin         
        select pepais, petdoc, pendoc
          into lv_pepais, lv_petdoc, pv_NumDoc
          from fsr008
         where cttfir = 'T'
           and ctnro = pn_Cuenta
           and rownum = 1;
          
      EXCEPTION          
         when others then 
           lv_pepais  := '';
           lv_petdoc := '';
           pv_NumDoc  := 0;
           my_errm    := SQLERRM;
           DBMS_OUTPUT.put_line (my_errm);
      end;
     
  --  else 
     if lv_NoObli = 'S' then
        --nombre del titular
             begin
              select penom into pv_NomTIT
              from Fsd001 
              where pepais = lv_pepais  
               and petdoc  = lv_petdoc  
               and pendoc  = pv_NumDoc ;
             exception
               when others then
                 pv_NomTIT := '';          
             end;   
      -- no obligado
            begin        
              select AQPA809PDOC,
                     AQPA809TDOC,
                     AQPA809NDOC,
                     AQPA809NOM,
                     aqpa809dir,
                     aqpa809ubigeo
                into lv_pepaisno,--lv_paisTit, 
                     lv_tdocTit,--lv_tdocTit, 
                     pv_NumDoc,
                     pv_NomCli,
                     pv_DirDes,
                     lc_ubigeo
                from AQPA809 b
               where b.aqpa806cod = pn_Acuerdo
                 and rownum = 1;
            EXCEPTION          
               when no_data_found then           
                 lv_pepaisno  := 0;
                 lv_tdocTit :=0;
                 pv_NumDoc :='';
                 pv_NomCli  := '';
                 pv_DirDes:='';
                 my_errm    := SQLERRM;                 
                 DBMS_OUTPUT.put_line (my_errm);
            end;
            lv_paisTit :=lv_pepaisno;
             --descripcion tipo documento
           begin
            select Tdnom into pv_DesTdoc
            from  Fst014
            where Tdocum = lv_tdocTit;
          exception
              when others then
                pv_DesTdoc:=0;
           end;
           ---OBTENGO DEP PROV DIST SEGÚN UBIGEO
            pv_DepDes := '';
            pv_ProDes := '';
            pv_DisDes  :='';
            cod_departa:=SUBSTR(lc_ubigeo,1,2);
            cod_provincia := SUBSTR(lc_ubigeo,1,4);
            cod_distrito := SUBSTR(lc_ubigeo,1,6);
            --busca departamento
            select DepNom into pv_DepDes from FST068
            Where Pais = 604
              and DepCod = cod_departa;
            --busca Provincia
            select LocNom into pv_ProDes  from FST070
            Where Pais = 604
            and DepCod =  cod_departa
            and LocCod = cod_provincia;
            --busca Distrito
            select fst071dsc into pv_DisDes from FST071
            Where Fst071Pai = 604
            and Fst071Dpt = cod_departa
            and Fst071Loc = cod_provincia 
            and Fst071Col = cod_distrito
            order by Fst071Pai, Fst071Dpt, Fst071Loc, Fst071Col;
                  
     else
        --nombre del cliente
       begin
        select penom into pv_NomCli
        from Fsd001 
        where pepais = lv_pepais  
         and petdoc  = lv_petdoc  
         and pendoc  = pv_NumDoc ;
       exception
         when others then
           pv_NomCli := '';          
       end;        
       --descripcion tipo documento
        select Tdnom into pv_DesTdoc
        from  Fst014
         where Tdocum = lv_petdoc;
      
      -- datos direccion
      begin
        sp_datos_direccion(lv_pepais,
                           lv_petdoc,
                           pv_NumDoc,
                           pv_DepDes,
                           pv_ProDes,
                           pv_DisDes,
                           pv_DirDes
                          );
    
      exception when others then
         pv_DepDes	:= '';
         pv_ProDes  := '';
         pv_DisDes  := '';
         pv_DirDes  := '';
         pn_coderr  := 8;
         my_errm    := SQLERRM;
         DBMS_OUTPUT.put_line (pn_coderr || '-' || my_errm);
      end;   
    end if; 

    -- cidudad del acuerdo
    begin
      SELECT TO_NUMBER(t1.scciud)
        INTO ln_CodCiu
        FROM FST001 t1
       where t1.sucurs =ln_CodSuc;

      SELECT t70.locnom 
        INTO pv_DesCiud
        FROM FST070 t70
       where t70.loccod = ln_CodCiu;
  
    exception when others then
       pv_DesCiud := 'Arequipa';
       pn_coderr  := 9;
       my_errm    := SQLERRM;
       DBMS_OUTPUT.put_line (pn_coderr || '-' || my_errm);
    end; 

     
    pv_NomCli  := trim(pv_NomCli);
    pv_NumDoc  := trim(pv_NumDoc);
    pv_DesTdoc := trim(pv_DesTdoc);
    pv_DesCiud := trim(pv_DesCiud);
    pv_DesPer  := trim(pv_DesPer);
     
  end sp_datos_acuerdo;
  
  --*********************************************************
  procedure sp_datos_direccion(pv_pepais  in NUMBER,--(3);
                               pv_petdoc  in NUMBER,--(2);
                               pv_NumDoc  in VARCHAR2,--(12)
                               pv_DepDes	out VARCHAR2,--(20)
                               pv_ProDes  out VARCHAR2,--(30)
                               pv_DisDes  out VARCHAR2,--(30)
                               pv_DirDes  out VARCHAR2--(140)
                              ) is
    my_errm    VARCHAR2(32000);
    pn_coderr  NUMBER(4);
    
  begin
    -- datos direccion
    begin
             
      --"DEPARTAMENTO DOM."
      SELECT H.DEPNOM
        into pv_DepDes
        FROM SNGC13 C13, FST068 H
       WHERE C13.SNGC13PAIS = pv_pepais
         AND C13.SNGC13TDOC = pv_petdoc
         AND C13.SNGC13NDOC = pv_NumDoc
         AND C13.SNGC13EST = 'H'
         AND ROWNUM = 1
         AND C13.DOCOD = 1
         AND H.PAIS = C13.SNGC13PAIS
         AND H.DEPCOD = C13.SNGC13DPTO;

      --"PROVINICIA DOM."
      SELECT I.LOCNOM
        into pv_ProDes
        FROM SNGC13 C13, FST068 H, FST070 I
       WHERE C13.SNGC13PAIS = pv_pepais
         AND C13.SNGC13TDOC = pv_petdoc
         AND C13.SNGC13NDOC = pv_NumDoc
         AND C13.SNGC13EST = 'H'
         AND ROWNUM = 1
         AND C13.DOCOD = 1
         AND H.PAIS = C13.SNGC13PAIS
         AND H.DEPCOD = C13.SNGC13DPTO
         AND I.PAIS = C13.SNGC13PAIS
         AND I.DEPCOD = H.DEPCOD
         AND I.LOCCOD = C13.SNGC13PROV;
      
      --"DISTRITO DOM."
      SELECT J.FST071DSC
        into pv_DisDes
        FROM SNGC13 C13, FST068 H, FST071 J
       WHERE C13.SNGC13PAIS = pv_pepais
         AND C13.SNGC13TDOC = pv_petdoc
         AND C13.SNGC13NDOC = pv_NumDoc
         AND C13.SNGC13EST = 'H'
         AND ROWNUM = 1
         AND C13.DOCOD = 1
         AND H.PAIS = C13.SNGC13PAIS
         AND H.DEPCOD = C13.SNGC13DPTO
         AND J.FST071PAI = C13.SNGC13PAIS
         AND J.FST071DPT = H.DEPCOD
         AND J.FST071COL = C13.SNGC13UGEO;

      --"DIRECCION DOM"
      SELECT C13.SNGC13DIR 
        into pv_DirDes
        FROM SNGC13 C13
       WHERE C13.SNGC13PAIS = pv_pepais 
         AND C13.SNGC13TDOC = pv_petdoc 
         AND C13.SNGC13NDOC = pv_NumDoc
         AND C13.SNGC13EST = 'H' 
         AND ROWNUM = 1
         AND C13.DOCOD = 1;  
  
    exception when others then
       pv_DepDes := '';
       pv_ProDes := '';
       pv_DisDes := '';
       pv_DirDes := '';
       pn_coderr := 1;
       my_errm   := SQLERRM;
       DBMS_OUTPUT.put_line (pn_coderr || '-' || my_errm);
    end; 
       
     pv_DepDes	:= trim(pv_DepDes);
     pv_ProDes  := trim(pv_ProDes);
     pv_DisDes  := trim(pv_DisDes);
     pv_DirDes  := trim(pv_DirDes);
     
  end sp_datos_direccion;
  
  --*********************************************************
end PQ_CR_DATOS_ACUERDOS;
/

