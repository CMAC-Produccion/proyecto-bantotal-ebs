CREATE OR REPLACE FUNCTION FN_MAX_FORM_PPG000(pn_PPG000Pgc IN NUMBER,
                                              pn_PPG000Mod in number,
                                              pn_PPG000Suc in number,
                                              pn_PPG000Mda in number,
                                              pn_PPG000Pap in number,
                                              pn_PPG000Cta in number,
                                              pn_PPG000Ope in number,
                                              pn_PPG000Sbo in number,
                                              pn_PPG000Top in number,
                                              pc_PPG000TCo in char)
  RETURN NUMBER IS

  -- *****************************************************************
  -- Nombre                     : FUNCION PARA OBTENER EL MAXIMO FORMULARIO DE LA TABLA PPG000
  -- Sistema                    : BANTOTAL
  -- Módulo                     :
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2020/12/28
  -- Autor de Creación          : RAY MONTES
  -- Uso                        : maximo formulario
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  --
  --
  --
  -- *****************************************************************

  maxform NUMBER(3);

BEGIN

  maxform := 0;
  begin
    select PPG000Frm
      into maxform
      from ppg000 p
     where PPG000Pgc = pn_PPG000Pgc
       and PPG000Mod = pn_PPG000Mod
       and PPG000Suc = pn_PPG000Suc
       and PPG000Mda = pn_PPG000Mda
       and PPG000Pap = pn_PPG000Pap
       and PPG000Cta = pn_PPG000Cta
       and PPG000Ope = pn_PPG000Ope
       and PPG000Sbo = pn_PPG000Sbo
       and PPG000Top = pn_PPG000Top
       and PPG000TCo = pc_PPG000TCo;
  exception
    when others then
      maxform := 0;
  end;

  RETURN maxform;

END;
/

