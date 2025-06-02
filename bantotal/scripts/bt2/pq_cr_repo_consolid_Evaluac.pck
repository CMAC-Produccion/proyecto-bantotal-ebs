create or replace package pq_cr_repo_consolid_Evaluac is

  -- *****************************************************************
  -- Nombre                     : PAQUETE PARA OPINION DE RIESGOS 
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 28/04/2025 11:08:41
  -- Autor de Creación          : IGS_RCASTRO
  -- Uso                        : Reporte para expediente digital - consolidacion de evaluaciones para pyme
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 15/05/2025
  -- Autor de Modificación      : rcastro
  -- Descripción de Modificación: se agrega ratio financiero
  -- *****************************************************************  

  procedure sp_obtener_cabecera(instancia  number,
                                nrocta     out number,
                                nomcliente out varchar2,
                                asesor     out varchar2);
  procedure sp_obtner_activos(instancia         number,
                              p_AQPB195CODCONC  varchar2,
                              p_AQPB195FCHEVAL1 out date,
                              p_AQPB195FCHEVAL2 out date,
                              p_AQPB195FCHEVAL3 out date,
                              
                              p_AQPB195MNT1 out number,
                              p_AQPB195MNT2 out number,
                              p_AQPB195MNT3 out number,
                              
                              p_AQPB195VARHORZ1  out number,
                              p_AQPB195VARHORZ2  out number,
                              p_AQPB195PORCHORZ1 out varchar2,
                              p_AQPB195PORCHORZ2 out varchar2,
                              p_AQPB195PORCVERT1 out varchar2,
                              p_AQPB195PORCVERT2 out varchar2,
                              p_AQPB195PORCVERT3 out varchar2);
                              
  procedure sp_dat_ratiofinanciero(instancia         number,
                                   p_AQPB198CODCONC  varchar2,
                                   p_AQPB198FCHEVAL1 out date,
                                   p_AQPB198FCHEVAL2 out date,
                                   p_AQPB198FCHEVAL3 out date, 
                                   p_AQPB198MNT1     out number, 
                                   p_AQPB198MNT2     out number,
                                   p_AQPB198MNT3     out number);                              
end pq_cr_repo_consolid_Evaluac;
/
create or replace package body pq_cr_repo_consolid_Evaluac is

  procedure sp_obtener_cabecera(instancia  number,
                                nrocta     out number,
                                nomcliente out varchar2,
                                asesor     out varchar2) IS
  
  BEGIN
    BEGIN
      SELECT AQPB195CTA, AQPB195CLIENTE, AQPB195ANALST
        INTO nrocta, nomcliente, asesor
        FROM AQPB195
       WHERE AQPB195INST = instancia
         AND AQPB195EST = 'H'
         and rownum = 1;
    EXCEPTION
      WHEN OTHERS THEN
        nrocta     := 0;
        nomcliente := '';
        asesor     := '';
    END;
  END;

  procedure sp_obtner_activos(instancia         number,
                              p_AQPB195CODCONC  varchar2,
                              p_AQPB195FCHEVAL1 out date,
                              p_AQPB195FCHEVAL2 out date,
                              p_AQPB195FCHEVAL3 out date,
                              --p_AQPB195INSTEVAL1 number,
                              --p_AQPB195INSTEVAL2 number, 
                              --p_AQPB195INSTEVAL3 number,
                              p_AQPB195MNT1 out number,
                              p_AQPB195MNT2 out number,
                              p_AQPB195MNT3 out number,
                              
                              p_AQPB195VARHORZ1  out number,
                              p_AQPB195VARHORZ2  out number,
                              p_AQPB195PORCHORZ1 out varchar2,
                              p_AQPB195PORCHORZ2 out varchar2,
                              p_AQPB195PORCVERT1 out varchar2,
                              p_AQPB195PORCVERT2 out varchar2,
                              p_AQPB195PORCVERT3 out varchar2) IS
  
    x_AQPB195PORCHORZ1 number(17, 2);
    x_AQPB195PORCHORZ2 number(17, 2);
    x_AQPB195PORCVERT1 number(17);
    x_AQPB195PORCVERT2 number(17);
    x_AQPB195PORCVERT3 number(17);
  
  BEGIN
    BEGIN
      select AQPB195FCHEVAL1,
             AQPB195FCHEVAL2,
             AQPB195FCHEVAL3,
             
             AQPB195MNT1,
             AQPB195MNT2,
             AQPB195MNT3,
             
             AQPB195VARHORZ1,
             AQPB195VARHORZ2,
             AQPB195PORCHORZ1,
             AQPB195PORCHORZ2,
             AQPB195PORCVERT1,
             AQPB195PORCVERT2,
             AQPB195PORCVERT3
      
        INTO p_AQPB195FCHEVAL1,
             p_AQPB195FCHEVAL2,
             p_AQPB195FCHEVAL3,
             
             p_AQPB195MNT1,
             p_AQPB195MNT2,
             p_AQPB195MNT3,
             
             p_AQPB195VARHORZ1,
             p_AQPB195VARHORZ2,
             x_AQPB195PORCHORZ1,
             x_AQPB195PORCHORZ2,
             x_AQPB195PORCVERT1,
             x_AQPB195PORCVERT2,
             x_AQPB195PORCVERT3
      
        from aqpb195
       where AQPB195INST = instancia
         AND AQPB195CODCONC = p_AQPB195CODCONC
         AND AQPB195EST = 'H';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    x_AQPB195PORCHORZ1 := nvl(x_AQPB195PORCHORZ1, 0);
    x_AQPB195PORCHORZ2 := nvl(x_AQPB195PORCHORZ2, 0);
    x_AQPB195PORCVERT1 := nvl(x_AQPB195PORCVERT1, 0);
    x_AQPB195PORCVERT2 := nvl(x_AQPB195PORCVERT2, 0);
    x_AQPB195PORCVERT3 := nvl(x_AQPB195PORCVERT3, 0);
  
    p_AQPB195PORCHORZ1 := to_char(x_AQPB195PORCHORZ1, 'FM999999990.00') || '%';
    p_AQPB195PORCHORZ2 := to_char(x_AQPB195PORCHORZ2, 'FM999999990.00') || '%';
    p_AQPB195PORCVERT1 := to_char(x_AQPB195PORCVERT1, 'FM999999990.00') || '%';
    p_AQPB195PORCVERT2 := to_char(x_AQPB195PORCVERT2, 'FM999999990.00') || '%';
    p_AQPB195PORCVERT3 := to_char(x_AQPB195PORCVERT3, 'FM999999990.00') || '%';
  
  END;
  
  PROCEDURE sp_dat_ratiofinanciero(instancia         number,
                                   p_AQPB198CODCONC  varchar2,
                                   p_AQPB198FCHEVAL1 out date,
                                   p_AQPB198FCHEVAL2 out date,
                                   p_AQPB198FCHEVAL3 out date, 
                                   p_AQPB198MNT1     out number, 
                                   p_AQPB198MNT2     out number,
                                   p_AQPB198MNT3     out number) is                                                                                                           
  BEGIN      
      BEGIN
        SELECT AQPB198FCHEVAL1, AQPB198FCHEVAL2, AQPB198FCHEVAL3, AQPB198MNT1, AQPB198MNT2, AQPB198MNT3 
        INTO p_AQPB198FCHEVAL1, p_AQPB198FCHEVAL2, p_AQPB198FCHEVAL3, p_AQPB198MNT1, p_AQPB198MNT2, p_AQPB198MNT3                           
        
        FROM AQPB198 where aqpb198inst = instancia AND AQPB198EST = 'H' and AQPB198CODCONC = p_AQPB198CODCONC;
      EXCEPTION
       WHEN OTHERS THEN
         NULL;
      END;
  END;                                   

end pq_cr_repo_consolid_Evaluac;
/
