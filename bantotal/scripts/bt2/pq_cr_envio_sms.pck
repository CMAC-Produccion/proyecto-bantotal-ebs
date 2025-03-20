create or replace package PQ_CR_ENVIO_SMS is

    -- *****************************************************************
    -- Nombre                     : PQ_CR_ENVIO_SMS
    -- Sistema                    : BANTOTAL
    -- M�dulo                     : Cr�ditos - Activas
    -- Versi�n                    : 1.0
    -- Fecha de Creaci�n          : 4/04/2023 
    -- Autor de Creaci�n          : IGS_RCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : P�blico
    -- Par�metros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificaci�n      : 
    -- Autor de la Modificaci�n   : 
    -- Descripci�n de Modificaci�n: 
    --
    -- *****************************************************************

  
  
  
 procedure sp_insert_aqpc804(p_AQPC806ITPGCOD    NUMBER,
                              p_AQPC806ITSUC    NUMBER,
                              p_AQPC806ITMOD    NUMBER,
                              p_AQPC806ITTRAN   NUMBER,
                              p_AQPC806ITNREL   NUMBER,
                              p_AQPC806ITFCON   DATE,                                 
                              p_AQPC806HORAT     VARCHAR2,
                              p_AQPC806AGENCIT   VARCHAR2,
                              p_AQPC806OPERADT   VARCHAR2,
                              p_AQPC806PRODUCT   VARCHAR2,                                 
                              p_AQPC806EMP     NUMBER,
                              p_AQPC806MODU    NUMBER,
                              p_AQPC806SUC     NUMBER,
                              p_AQPC806MDA     NUMBER, 
                              p_AQPC806PAP     NUMBER,
                              p_AQPC806CTA     NUMBER,
                              p_AQPC806OPER    NUMBER,
                              p_AQPC806SBOP    NUMBER,
                              p_AQPC806TOPE    NUMBER,
                              p_AQPC806FECSIS  DATE,
                              p_AQPC806HORSIS  VARCHAR2,
                              p_AQPC806CODCLI  IN VARCHAR2);

end PQ_CR_ENVIO_SMS;
/

create or replace package body PQ_CR_ENVIO_SMS is

  procedure sp_insert_aqpc804(p_AQPC806ITPGCOD    NUMBER,
                              p_AQPC806ITSUC    NUMBER,
                              p_AQPC806ITMOD    NUMBER,
                              p_AQPC806ITTRAN   NUMBER,
                              p_AQPC806ITNREL   NUMBER,
                              p_AQPC806ITFCON   DATE,                                 
                              p_AQPC806HORAT     VARCHAR2,
                              p_AQPC806AGENCIT   VARCHAR2,
                              p_AQPC806OPERADT   VARCHAR2,
                              p_AQPC806PRODUCT   VARCHAR2,                                 
                              p_AQPC806EMP     NUMBER,
                              p_AQPC806MODU    NUMBER,
                              p_AQPC806SUC     NUMBER,
                              p_AQPC806MDA     NUMBER, 
                              p_AQPC806PAP     NUMBER,
                              p_AQPC806CTA     NUMBER,
                              p_AQPC806OPER    NUMBER,
                              p_AQPC806SBOP    NUMBER,
                              p_AQPC806TOPE    NUMBER,
                              p_AQPC806FECSIS  DATE,
                              p_AQPC806HORSIS  VARCHAR2,
                              --p_AQPC806FECHOR  VARCHAR2,
                              p_AQPC806CODCLI IN VARCHAR2) is

  p_AQPC806FECHOR date;--(20);                              
                                                         
  begin
     BEGIN
       SELECT fn_jaql977_fechor(to_char(p_AQPC806FECSIS, 'rrrrmmdd'),
                                  replace(p_AQPC806HORSIS, ':', '')) INTO p_AQPC806FECHOR
       FROM DUAL;
     EXCEPTION 
       WHEN OTHERS THEN
         NULL;
     END;      
  
      BEGIN
        INSERT INTO AQPC806(
        AQPC806ITPGCOD,
        AQPC806ITSUC,  
        AQPC806ITMOD,  
        AQPC806ITTRAN, 
        AQPC806ITNREL, 
        AQPC806ITFCON ,           
        AQPC806HORAT,  
        AQPC806AGENCIT,
        AQPC806OPERADT,
        AQPC806PRODUCT,          
        AQPC806EMP ,   
        AQPC806MODU,   
        AQPC806SUC ,   
        AQPC806MDA ,   
        AQPC806PAP ,   
        AQPC806CTA ,   
        AQPC806OPER,   
        AQPC806SBOP ,  
        AQPC806TOPE,   
        AQPC806FECSIS,
        AQPC806HORSIS ,
        AQPC806FECHOR, 
        AQPC806CODCLI                          
        )
        VALUES(
        p_AQPC806ITPGCOD,
        p_AQPC806ITSUC,  
        p_AQPC806ITMOD,  
        p_AQPC806ITTRAN, 
        p_AQPC806ITNREL, 
        p_AQPC806ITFCON ,
        p_AQPC806HORAT,  
        p_AQPC806AGENCIT,
        p_AQPC806OPERADT,
        p_AQPC806PRODUCT,
        p_AQPC806EMP ,   
        p_AQPC806MODU,   
        p_AQPC806SUC ,   
        p_AQPC806MDA ,   
        p_AQPC806PAP ,   
        p_AQPC806CTA ,   
        p_AQPC806OPER,   
        p_AQPC806SBOP ,  
        p_AQPC806TOPE,   
        p_AQPC806FECSIS,
        p_AQPC806HORSIS ,
        p_AQPC806FECHOR, 
        p_AQPC806CODCLI
        );
        COMMIT;
      EXCEPTION 
        WHEN OTHERS THEN
        NULL;
      END;  
  end;                              


end PQ_CR_ENVIO_SMS;
/

