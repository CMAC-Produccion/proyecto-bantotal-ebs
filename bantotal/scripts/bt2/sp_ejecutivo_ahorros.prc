create or replace procedure sp_ejecutivo_ahorros(pn_mod in number, pn_pais in number, pn_tdoc in number, pc_ndoc in char,
                               pn_suc in number, pn_mda in number, pn_cta in number, pn_oper in number,
                               pn_top in number, pc_ejecutivo out varchar2) is
begin

  pc_ejecutivo := pq_ocum_calificacion.Fn_Ejecutivo(pn_mod, pn_pais, pn_tdoc, pc_ndoc, pn_suc, pn_mda, pn_cta, pn_oper, pn_top);

end sp_ejecutivo_ahorros;
/

