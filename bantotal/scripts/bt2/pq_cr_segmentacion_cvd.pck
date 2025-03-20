create or replace package pq_cr_segmentacion_CVD is

  Procedure sp_cr_segmentacion_HIS(pn_pai    in number,
                                   pn_tdo    in number,
                                   pc_ndo    in char,
                                   pn_codSeg out number,
                                   pn_pro    out number);

end pq_cr_segmentacion_CVD;
/

create or replace package body pq_cr_segmentacion_CVD is

  Procedure sp_cr_segmentacion_HIS(pn_pai    in number,
                                   pn_tdo    in number,
                                   pc_ndo    in char,
                                   pn_codSeg out number,
                                   pn_pro    out number) is
  
    ld_fecTmp   date;
    ln_cod      number(5);
    ln_promedio number(17, 2);
  
  begin
  
    begin
      select to_date(a.tp1nro1, 'dd/mm/yyyy')
        into ld_fecTmp
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 111111
         and a.tp1corr2 = 1
         and a.tp1corr3 = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select a.jaqy066calf
        into ln_cod
        from jaqy066 a
       where a.jaqy066fecp = ld_fecTmp
         and a.jaqy066paic = pn_pai
         and a.jaqy066tdoc = pn_tdo
         and a.jaqy066tndoc = pc_ndo;
    exception
      when others then
        null;
    end;
  
    pn_codSeg := nvl(ln_cod, 0);
  
    begin
      select to_number(substr(a.jaqz095var2,
                              (instr(a.jaqz095var2, '=')) + 1,
                              length(a.jaqz095var2)),
                       '99999999999999999.99')
        into ln_promedio
        from jaqz095 a
       where a.jaqz095fech = ld_fecTmp
         and a.jaqz095pais = pn_pai
         and a.jaqz095tdoc = pn_tdo
         and a.jaqz095ndoc = pc_ndo;
    exception
      when others then
        null;
    end;
    pn_pro := nvl(ln_promedio, 0);
  
  end sp_cr_segmentacion_HIS;

end pq_cr_segmentacion_CVD;
/

