create or replace package PQ_CR_CAMP_CONSUMO is

   PROCEDURE SP_CR_RESTRICCION_DESEMB_APP(P_InInstancia IN NUMBER, P_OutCoprDeuda OUT VARCHAR2, P_OutTipConv OUT VARCHAR2);

end PQ_CR_CAMP_CONSUMO;
/

create or replace package body PQ_CR_CAMP_CONSUMO is

   PROCEDURE SP_CR_RESTRICCION_DESEMB_APP(
     P_InInstancia  IN NUMBER, 
     P_OutCoprDeuda OUT VARCHAR2, 
     P_OutTipConv   OUT VARCHAR2) IS
     vCoprDeuda VARCHAR2(1);
     vOutTipConv CHAR(10);
     MOD198 NUMBER(9);
     MOD700 NUMBER(9);
     BEGIN
       BEGIN
         SELECT 'S'
         INTO vCoprDeuda
         FROM JAQZ862
         WHERE JAQZ862INST = P_InInstancia AND JAQZ862ESTA = 'S' AND JAQZ862AUX4 = '1' AND
         JAQZ862CORR = (SELECT MAX(JAQZ862CORR) FROM JAQZ862 WHERE JAQZ862INST = P_InInstancia AND
          JAQZ862ESTA = 'S' AND JAQZ862AUX4 = '1');
       EXCEPTION
         WHEN OTHERS THEN
           BEGIN
             SELECT 'S'
             INTO vCoprDeuda
             FROM JAQY327
             WHERE JAQY327INST = P_InInstancia AND JAQY327ESTA = 'S' AND JAQY327AUX4 = '1' AND
             JAQY327CORR = (SELECT MAX(JAQY327CORR) FROM JAQY327 WHERE JAQY327INST = P_InInstancia AND
             JAQY327ESTA = 'S' AND JAQY327AUX4 = '1');
             EXCEPTION
               WHEN OTHERS THEN
                 vCoprDeuda:= 'N';
             END;
       END;
       PQ_CR_CAMP_CONVENIO.sp_cr_inicio(P_InInstancia, vOutTipConv);
       
       BEGIN
         SELECT XWFMODULO
         INTO MOD700
         FROM XWF700 WHERE XWFPRCINS = P_InInstancia AND XWFCAR3 = '1';
       EXCEPTION
         WHEN OTHERS THEN
           MOD700 := 0;
       END;
       BEGIN
         SELECT TP1NRO1
         INTO MOD198
         FROM FST198 WHERE
         TP1COD = 1 AND TP1COD1 = 111154 AND TP1CORR1 = 4 AND TP1CORR2 = 0 AND TP1CORR3 > 0 AND TP1NRO1=MOD700; 
       EXCEPTION
         WHEN OTHERS THEN
           MOD198 := 0; 
       END;
       
       IF vOutTipConv = 'PRIVADA' THEN
         IF MOD700 = MOD198 THEN
           P_OutCoprDeuda := vCoprDeuda;
           P_OutTipConv   := vOutTipConv;
         ELSE
           P_OutCoprDeuda := vCoprDeuda;
           P_OutTipConv   := 'N';
         END IF;
       ELSE
         IF vOutTipConv = 'PÚBLICA' THEN
           P_OutCoprDeuda := vCoprDeuda;
           P_OutTipConv   := vOutTipConv;
         END IF;
       END IF;       
     END SP_CR_RESTRICCION_DESEMB_APP;
end PQ_CR_CAMP_CONSUMO;
/

