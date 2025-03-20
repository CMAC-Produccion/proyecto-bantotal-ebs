create or replace package PQ_CR_MONTOS_EVAL is
  -- *****************************************************************
  -- Nombre                     : PCK PARA INGRESO CONSUMO
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2020.06.05
  -- Autor de Creación          : CMAC-GCARRANZAS
  -- Uso                        :
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      :
  -- Autor de Modificación      :
  -- Descripción de Modificación:
  --
  --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_ingreso_consumo(PN_INSTANCIA  IN NUMBER,
                                  PN_CONSUM_SOL OUT NUMBER,
                                  PN_CONSUM_DOL OUT NUMBER,
                                  PC_CODERR     OUT varchar2,
                                  PC_DESERR     OUT varchar2);

end PQ_CR_MONTOS_EVAL;
/

create or replace package body PQ_CR_MONTOS_EVAL is
  Procedure sp_cr_ingreso_consumo(PN_INSTANCIA  IN NUMBER,
                                  PN_CONSUM_SOL OUT NUMBER,
                                  PN_CONSUM_DOL OUT NUMBER,
                                  PC_CODERR     OUT varchar2,
                                  PC_DESERR     OUT varchar2) is
  
    --ln_Tp1corr2 NUMBER(9);
  BEGIN
    PC_CODERR := '000';
    PC_DESERR := '';
  
    PN_CONSUM_SOL := 0;
    PN_CONSUM_DOL := 0;
  
    IF PN_INSTANCIA IS null or PN_INSTANCIA = 0 THEN
      PC_CODERR := '003';
      PC_DESERR := 'INSTANCIA SIN VALOR';
      RETURN;
    END IF;
  
    -- INGRESO CONSUMO SOLES
    BEGIN
      Select coalesce(sum(case
                            when sng026cod in (5, 6, 7, 8) then
                             coalesce(sng023mto, 0) * -1
                            else
                             coalesce(sng023mto, 0)
                          end),
                      0)
        into PN_CONSUM_SOL
        From SNG023
       where sng021eval = (select SNG021EVAL
                             from sng021
                            where sng021sol = PN_INSTANCIA
                              and rownum = 1)
         AND SNG026COD IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        PN_CONSUM_SOL := 0;
        PC_CODERR     := '001';
        PC_DESERR     := 'NO HAY MONTO EN SOLES';
    END;
  
    -- INGRESO CONSUMO DÓLARES
    BEGIN
      Select coalesce(sum(case
                            when sng026cod in (505, 506, 507, 508) then
                             coalesce(sng023mto, 0) * -1
                            else
                             coalesce(sng023mto, 0)
                          end),
                      0)
        into PN_CONSUM_DOL
        From SNG023
       where sng021eval = (select SNG021EVAL
                             from sng021
                            where sng021sol = PN_INSTANCIA
                              and rownum = 1)
         AND SNG026COD IN
             (501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512)
       group by sng021eval;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        PN_CONSUM_DOL := 0;
        PC_CODERR     := '002';
        PC_DESERR     := 'NO HAY MONTO EN DOLARES';
    END;
  
  END sp_cr_ingreso_consumo;

end PQ_CR_MONTOS_EVAL;
/

