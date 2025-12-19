create or replace package pq_cr_contral_ubigeo_direcc_rc is

   -- *****************************************************************
   -- NOMBRE                      : pq_cr_contral_ubigeo_direcc_rc
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 3/12/2025
   -- AUTOR DE CREACION           : RCASTRO
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    :
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************  
   
   procedure sp_validar_control_ubigeo(intancia number,
                                       voRpta   out varchar2);  

end pq_cr_contral_ubigeo_direcc_rc;
/
create or replace package body pq_cr_contral_ubigeo_direcc_rc is

   procedure sp_validar_control_ubigeo(intancia number,
                                       voRpta   out varchar2) IS
    vi_empresa   XWF700.XWFEMPRESA%type;
    vi_sucursal  XWF700.XWFSUCURSAL%type;
    vi_modulo    XWF700.XWFMODULO%type;
    vi_moneda    xWF700.Xwfmoneda%type;
    vi_papel     XWF700.XWFPAPEL%type;
    vi_cuenta    XWF700.XWFCUENTA%type;
    vi_operacion XWF700.XWFOPERACION%type;
    vi_subope    XWF700.XWFSUBOPE%type;
    vi_tipope    XWF700.Xwftipope%type;    
    
    v_pepais     number(5);
    v_pendoc     varchar2(12);
    v_petdoc     number(5);
    
    V_FechaHoy   DATE;
    V_N_DIAS     NUMBER(6);
    V_FECHAANTE  DATE;
    v_count      NUMBER(5);
    V_FLGEXIS    VARCHAR2(1);
                                                                                                                          
   BEGIN
    --OBTENER LA CLAVE DEL CREDITO
    begin
      select x.xwfempresa,
             x.xwfsucursal,
             x.xwfmodulo,
             x.xwfmoneda,
             x.xwfpapel,
             x.xwfcuenta,
             x.xwfoperacion,
             x.xwfsubope,
             x.xwftipope
        into vi_empresa,
             vi_sucursal,
             vi_modulo,
             vi_moneda,
             vi_papel,
             vi_cuenta,
             vi_operacion,
             vi_subope,
             vi_tipope
        from xwf700 x
       where x.xwfprcins = intancia
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
    
    
    BEGIN
      SELECT A.PEPAIS, A.PETDOC, A.PENDOC INTO v_pepais, v_petdoc, v_pendoc   FROM FSR008 A WHERE A.PGCOD = 1 AND A.CTNRO = vi_cuenta AND A.CTTFIR = 'T'; 
    EXCEPTION 
      WHEN OTHERS THEN
        v_pendoc := '';
    END;
    
    BEGIN
      SELECT PGFAPE INTO V_FechaHoy FROM FST017 WHERE PGCOD = 1;
    EXCEPTION 
      WHEN OTHERS THEN
        V_FechaHoy := null;
    END;    
    
    
    BEGIN
               
      SELECT TP1NRO3
       INTO V_N_DIAS
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11152
         AND TP1CORR1 = 320
         AND TP1CORR2 = 1
         AND TP1CORR3 = 1; 
    EXCEPTION 
      WHEN OTHERS THEN
        V_N_DIAS := 0;           
    END;
    
    V_N_DIAS := NVL(V_N_DIAS, 0);
    
    BEGIN
      V_FECHAANTE := V_FechaHoy - V_N_DIAS;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
    END;
    
    
    BEGIN
    SELECT /*+ ALL_ROWS INDEX(XX SYS_C0048315)*/
       'S' INTO V_FLGEXIS
        FROM FPAE70 XX, FPAE73 YY
       WHERE  
         XX.PAE51EVA = YY.PAE51EVA
         AND XX.PAE70NRO = YY.PAE70NRO                  
         AND YY.PAE73POL = 207
         AND XX.PAE70PDOC = v_pepais
         AND XX.PAE70TDOC = v_petdoc
         AND XX.PAE70NDOC = RPAD(v_pendoc, 12, ' ')
         AND PAE70TIME >= V_FECHAANTE
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        V_FLGEXIS := 'N';         
    END;
    
    V_FLGEXIS := NVL(V_FLGEXIS, 'N');
    
    
    voRpta := V_FLGEXIS;            
    
        
   END;                                       
end pq_cr_contral_ubigeo_direcc_rc;
/
