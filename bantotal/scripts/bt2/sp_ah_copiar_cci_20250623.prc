create or replace procedure sp_ah_copiar_cci(P_D_FECAPE in date) is
  -- *****************************************************************
  -- Nombre                     : sp_ah_copiar_cci
  -- Versión                    : 1.0
  -- Fecha de Creación          : 
  -- Uso                        : sp_ah_copiar_cci
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2025.06.24
  -- Autor de la Modificación   : EHIDALGO
  -- Descripción de Modificación: Se comento dblink cuentas@web
  -- *****************************************************************

  cursor cur_cci is
    select lpad(a.sccta, 9, '0') || lpad(a.scmod, 3, '0') ||
           lpad(a.scmda, 3, '0') || lpad(a.scsbop, 2, '0') ||
           lpad(a.sctope, 3, '0') c_numcta,
           a.scmod || a.sctope c_codppa,
           (case
             when a.scmod || a.sctope = '212' then
              'COMPENSACION POR TIEMPO DE SERVICIO'
             when a.scmod || a.sctope = '213' then
              'ORDENES DE PAGO'
             else
              'AHORROS'
           end) c_desppa,
           '803' || lpad(b.Tpcorr, 3, '0') || lpad(sccta, 9, '0') ||
           lpad(scsbop, 3, '0') ||
           fn_ah_modulo10('803' || lpad(b.Tpcorr, 3, '0'), 121212) ||
           fn_ah_modulo10(lpad(sccta, 9, '0') || lpad(scsbop, 3, '0'),
                          121212121212) c_codcci--,
           --a.*,
           --b.*
      from fsd011 a, fst098 b
     where b.Tpnro = a.scsuc
       and a.pgcod = 1
       and a.scmod = 21
       and a.scfval >= P_D_FECAPE
       and b.pgcod = 1
       and b.Tpcod = 25000;

begin

  for i in cur_cci loop
    /*insert into cuentas@web
      ("C_NUMCTA", "C_CODPPA", "C_DESPPA", "C_CODCCI")
    values
      (i.c_numcta, i.c_codppa, i.c_desppa, i.c_codcci);*/
     null;--comentado 2025.06.23
  end loop;
  commit;

end sp_ah_copiar_cci;
/
