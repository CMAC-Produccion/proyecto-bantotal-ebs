create or replace package pq_cr_val_rtes_desem_AlinInt is

  -- Author  : IGS_RCASTRO
  -- Created : 7/11/2022 12:47:18
  -- Purpose : Validación en RTEs de Trans. de Desembolso de alineamiento Interno
  
  PROCEDURE sp_validar_cred_alineamiento(xpgfape date, xuser varchar2, auxPgcod number, auxItsuc number, auxMod number, 
                                         auxTran number, auxNrel number, auxPitord number );
 
  procedure sp_val_extor_desemb(fechaaper date, xuser varchar2, auxPgcod number, auxItsuc number, auxMod number, 
                                auxTran number, auxNrel number, auxPitord number  );
  
end pq_cr_val_rtes_desem_AlinInt;
/

create or replace package body pq_cr_val_rtes_desem_AlinInt is
       
   PROCEDURE sp_validar_cred_alineamiento(xpgfape date, xuser varchar2, auxPgcod number, auxItsuc number, auxMod number, auxTran number, 
                                          auxNrel number, auxPitord number ) is
   l_cod number(3);
   l_suc number(3);
   l_mod number(3);
   l_ctnro number(9);    
   l_oper  number(9);
   l_tope  number(3);
   l_moned number(4);
   l_papel number(4);  
   l_subope number(3);  
   flg_exist934 char(1); 
   ln_fechactual date;  
   l_fcont date;                        
   BEGIN
       ln_fechactual := to_date(sysdate, 'DD/MM/RRRR');   

       BEGIN
             SELECT    
             h.Pgcod  ,      
             h.Itsucd ,     
             h.Modulo ,    
             h.Ctnro  ,     
             h.Moneda ,    
             h.Papel  ,    
             h.Ittope ,    
             h.Itoper ,    
             h.ITSUBO,
             B.ITFCON
             INTO
             l_cod, l_suc, l_mod, l_ctnro, l_moned, l_papel, l_tope, l_oper, l_subope, l_fcont
             FROM FSD016 h, FSD015 B
             WHERE
             B.PGCOD = h.pgcod  and
             B.ITSUC = h.Itsuc  and
             B.ITMOD = h.Itmod  and
             B.ITTRAN = h.Ittran and
          --   B.ITCONT = 'S'      and
             B.ITNREL = h.Itnrel and            
             B.ITFCON = xpgfape  and
             
             h.Pgcod  = auxPgcod and
             h.Itsuc  = auxItsuc and
             h.Itmod  = auxMod   and
             h.Ittran = auxTran  and
             h.Itnrel = auxNrel  and
             h.Itord  = auxPitord ;
             
           
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            l_cod := 0; 
            l_suc := 0;
            l_mod := 0; 
            l_ctnro := 0; 
            l_moned := 0; 
            l_papel := 0; 
            l_tope := 0; 
            l_oper := 0; 
            l_subope := 0;
          
        END;                
             
        --BUSCAR EN TABL ALINEAMIENTO
        BEGIN
            SELECT 'S' into flg_exist934 FROM AQPB999 WHERE 
            AQPB999EMP = l_cod   and
            AQPB999MOD = l_mod   and             
            AQPB999SUC = l_suc   and
            AQPB999MDA = l_moned and
            AQPB999PAP = l_papel and
            AQPB999CTA = l_ctnro and
            AQPB999OPE = l_oper  and
            AQPB999SBO = l_subope and
            AQPB999TOP = l_tope and 
            AQPB999EST = 'C';                                         
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            flg_exist934 := 'N';
        END; 
        
        IF flg_exist934 = 'S' THEN
           BEGIN
               INSERT INTO AQPB411 VALUES
               (l_cod, l_mod, l_suc, l_moned, l_papel, l_ctnro, l_oper, l_subope, l_tope, 'P', xuser, ln_fechactual, 0, 0, '', 'A', '', '', '', 
               auxPgcod, auxItsuc, auxMod, auxTran, auxNrel, l_fcont);
               COMMIT;              
               
           EXCEPTION
             WHEN OTHERS THEN
               NULL;
           END;                            
        END IF; 
                            

   END;     
   
  ------EXTORNO
   PROCEDURE sp_val_extor_desemb(fechaaper date, xuser varchar2, auxPgcod number, auxItsuc number, auxMod number, 
                                auxTran number, auxNrel number, auxPitord number  ) IS
   RelOri NUMBER;
   FContOrig DATE;                               
   BEGIN                                          
       BEGIN            
        SELECT TO_NUMBER(TRIM(Txtext)) INTO RelOri FROM FSX015 WHERE 
          Pgcod  = auxPgcod AND
          Hcmod  = auxMod and
          Hsucor = auxItsuc and
          Htran  = auxTran and
          Hnrel  = auxNrel and
          Hfcon  = fechaaper and
          Txcod  = 0  AND
          Txreng = 1 ;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
              RelOri := 0;  
          WHEN OTHERS THEN
              NULL;        
        END; 
                   
        BEGIN
         SELECT  TO_DATE(TRIM(Txtext),'dd/MM/yyyy') INTO FContOrig FROM FSX015 WHERE 
          Pgcod  = auxPgcod AND
          Hcmod  = auxMod and
          Hsucor = auxItsuc and
          Htran  = auxTran and
          Hnrel  = auxNrel and
          Hfcon  = fechaaper and
          Txcod  = 0  AND
          Txreng = 2 ;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
              FContOrig := '';  
          WHEN OTHERS THEN
              NULL;        
        END;   
        
        --ACTUALKUZAR CAMPOS
       
        BEGIN
            UPDATE AQPB411
            SET AQPB411FECEXT = fechaaper, 
                AQPB411EST = 'I'
            WHERE 
            AQPB411PGCOD = auxPgcod AND
            AQPB411ITSUC = auxItsuc  AND
            AQPB411ITMOD = auxMod - 500  AND
            AQPB411ITRAN = auxTran  AND
            AQPB411ITNREL = RelOri  AND
            AQPB411FCONT  = to_date(FContOrig, 'dd/MM/RRRR');
            COMMIT;
        END;  
        
        BEGIN
              UPDATE AQPB999 
              SET AQPB999EST = 'E'
              WHERE             
              AQPB999ITCOD = auxPgcod   and
              AQPB999ITMOD = auxMod - 500 and             
              AQPB999ITSUC = auxItsuc   and
              AQPB999ITTRAN = auxTran and
              AQPB999ITNREL = RelOri and
              AQPB999ITFCON = to_date(FContOrig, 'dd/MM/RRRR');            
              COMMIT;      
        EXCEPTION
             WHEN OTHERS THEN
              NULL;
        END;
                                                                             
     END;
   
end pq_cr_val_rtes_desem_AlinInt;
/

