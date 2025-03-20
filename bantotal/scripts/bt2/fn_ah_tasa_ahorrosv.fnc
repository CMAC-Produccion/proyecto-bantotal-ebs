create or replace function FN_AH_TASA_AHORROSV(vpgcod in number,
                                           vscsuc in number,
                                           vsccta in number,
                                           vscmda in number,
                                           vscpap in number,
                                           vscoper in number,
                                           vscsbop in number,
                                           vsctope in number,
                                           vscmod in number) return number is


   n_tasa number;

begin
    pq_segmentacion_clientes_pas.sp_tasa(vpgcod,
                                         vscsuc,
                                         vsccta,
                                         vscmda,
                                         vscpap,
                                         vscoper,
                                         vscsbop,
                                         vsctope,
                                         vscmod,
                                         n_tasa);

   return n_tasa;
end FN_AH_TASA_AHORROSV;
/

