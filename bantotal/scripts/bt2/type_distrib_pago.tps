CREATE OR REPLACE TYPE "TYPE_DISTRIB_PAGO"
as object (
      v_tsum  number(17,2),
      v_gas   number(17,2), -- seguridad
      v_mor   number(17,2), -- moratoria
      v_int   number(17,2), -- interés
      v_cuo   number(17,2), -- capital
      v_icv   number(17,2), -- interés compensatorio (icv)
      v_pen   number(17,2)
)
/

