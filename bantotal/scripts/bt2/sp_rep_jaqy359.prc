create or replace procedure SP_REP_JAQY359
(
    COD_AGE in number, UBUSER in varchar2
) is

--UBUSER CHAR(10);
BEGIN
  delete from JAQY360 where trim(UBUSER) = trim(UBUSER);commit;
  --execute immediate('truncate table jaqy360');
  delete from JAQY359 t where trim(t.jaqy359ubuser) = trim(UBUSER);commit;
  --UBUSER:='ABERNEDO';
  insert into jaqy360 
  SELECT 
       DISTINCT 
       LPAD(E.AOCTA, 9, '0') || LPAD(E.AOMOD, 3, '0') ||
       LPAD(E.AOMDA, 3, '0') || LPAD(E.AOOPER, 9, '0') ||
       LPAD(E.AOTOPE, 3, '0') NRO_CREDITO,      
       F.CTNOM CLIENTE,
       (select pendoc from fsr008 r WHERE r.ctnro=f.ctnro and r.cttfir='T') ndoc,
       g.scfval fech_gar,
       F2.PENOM PROPGAR,
       (SELECT F.TONOM FROM FST004 F WHERE F.MODULO=G.SCMOD and F.totope=G.SCTOPE) TIPO,          
       (G.SCSDO) MTO_GARANTIA, 
       E.AOFVAL  FEC_DES, -- FECHA DESEMBOLSO            
     --  (select P.ppg004dato from ppg004 P where P.ppg004cta =R.R2CTA and P.ppg004ope =  R.R2OPER and p.ppg004cdat = 60 ) GRAVAMEN,
      e.pgcod,
      e.aomod,
      e.aosuc,
      e.aomda,
      e.aopap,
      e.aoCTA,
      e.aoOPER,
      e.aosbop,
      e.aoTOPE,
      g.sccta,
      g.scoper,
      g.scmod,
      g.scsuc,
      (select tdnom from fst014 where tdocum = s.petdoc),
      UBUSER
      
FROM 
       FSD011 A, --SALDOS VIGENTE
       FST004 B, --PRODUCTOS
       FSR011 R, --RELACION PRESTAMO GARANTIA
       FSD010 E, --TODOS LOS CRÉDITOS
       FSD008 F,
       FSD011 G,  -- GARANTIAS
       FST001 T,
       FSR008 S,
       FSD001 F2/*,
       PPG002 P*/
WHERE 
      A.SCMOD=B.MODULO
  AND A.SCTOPE=B.TOTOPE  
  AND A.PGCOD = R.R1COD
  AND A.SCSUC = R.R1SUC
  AND A.SCMDA = R.R1MDA
  AND A.SCPAP = R.R1PAP
  AND A.SCCTA = R.R1CTA
  AND A.SCOPER= R.R1OPER
  AND A.SCSBOP= R.R1SBOP
  AND A.SCTOPE= R.R1TOPE
  AND A.SCMOD = R.R1MOD
  AND A.SCSTAT <> 99   --NO CANCELADOS/ANULADOS
  AND R.RELCOD=50      --RELACION PRESTAMO GARANTIA
  AND E.PGCOD  = A.PGCOD 
  AND E.AOMOD  = A.SCMOD 
  AND E.AOSUC  = A.SCSUC 
  AND E.AOMDA  = A.SCMDA  --MONEDA 0 SOLES 101 DOLARES
  AND E.AOPAP  = A.SCPAP 
  AND E.AOCTA  = A.SCCTA  --CUENTA CLIENTE
  AND E.AOOPER = A.SCOPER
  AND E.AOSBOP = A.SCSBOP
  AND E.AOOPER = A.SCOPER
  AND A.SCCTA = F.CTNRO
  AND G.SCCTA = R.R2CTA
  AND G.SCTOPE= R.R2TOPE  
  AND G.PGCOD = R.R2COD
  AND G.SCSUC = R.R2SUC
  AND G.SCMDA = R.R2MDA
  AND G.SCPAP = R.R2PAP
  AND G.SCOPER= R.R2OPER
  AND G.SCSBOP= R.R2SBOP
  AND G.SCTOPE= R.R2TOPE
  AND G.SCMOD = 70
  AND G.SCTOPE IN (10,15,20,25,30,40,42,45,47,50,55,60,65)
  and G.SCTIT<>9
  AND T.PGCOD = E.PGCOD
  AND T.SUCURS= E.AOSUC
  AND G.SCCTA=S.CTNRO
  AND S.PENDOC=F2.PENDOC
  AND T.SUCURS=COD_AGE; --AGENCIA 
  COMMIT;
  
  
  insert into JAQY359
  SELECT distinct
         r2.regnom,
         age.scnom,
         gar.fec_des,
         gar.nro_credito,
         gar.cliente,
         gar.ndoc,
         GAR.PROPGAR,
         G001.PPG001DATO PARTIDA,
         gar.tipo,  
         fn_garantia_cred(gar.pgcod,gar.aomod,gar.aosuc,gar.aomda,gar.aopap,Gar.aoCTA,Gar.aoOPER,gar.aosbop,Gar.aoTOPE) Garantia,    
         gar.mto_garantia, 
         GAR.fech_gar,
         gar.tdnom,
         UBUSER
  FROM jaqy360 gar LEFT JOIN ppg001 G001
       ON G001.ppg001mod=470 AND G001.ppg001cta=GAR.SCCTA  AND G001.ppg001ope=GAR.SCOPER AND G001.PPG001CDAT=129,
       fst811 r,  
       FST001 age,
       fst810 r2
   where age.Pgcod  = 1 and age.Sucurs = gar.aosuc
   and r.pgcod = 1 and r.oficod = gar.aosuc and r.RegCod < 100
   and r2.regcod = r.regcod
   and r2.regcod<100
  order by 1,2 desc;   
  COMMIT;
  
END;
/

