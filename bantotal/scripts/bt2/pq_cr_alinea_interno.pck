create or replace package pq_cr_alinea_interno is

  -- Author  : DCASTRO 
  -- Created : 10/11/2022 
  -- Purpose : 
  
procedure sp_verificafecha(vn_Ppgcod  in number,
                           vn_Pitsuc  in number,
                           vn_Pitmod  in number,
                           vn_PIttran in number,
                           vn_Pitnrel in number,
                           vn_Pitord  in number,
                           vn_Pitsbor in number,
                           rpta       out number);


  procedure sp_cr_Fec_Proximo_vto(pn_emp    in number,
                                  pn_mod    in number,
                                  pn_suc    in number,
                                  pn_mda    in number,
                                  pn_pap    in number,
                                  pn_cta    in number,
                                  pn_oper   in number,
                                  pn_sbop   in number,
                                  pn_top    in number,
                                  pd_fecpro in date,
                                  pd_fecha  out date);
                                                             
end pq_cr_alinea_interno;
/

create or replace package body pq_cr_alinea_interno is

procedure sp_verificafecha(vn_Ppgcod  in number,
                           vn_Pitsuc  in number,
                           vn_Pitmod  in number,
                           vn_PIttran in number,
                           vn_Pitnrel in number,
                           vn_Pitord  in number,
                           vn_Pitsbor in number,
                           rpta       out number)
  is

ln_ppg000pgc number(3);
ln_ppg000mod number(4);
ln_ppg000suc number(3);
ln_ppg000mda number(4);
ln_ppg000pap number(4);
ln_ppg000cta number(9);
ln_ppg000ope number(9);
ln_ppg000sbo number(3);
ln_ppg000tpo number(3);
ln_ppg000frm number(3);
ln_ordinal number(4);
ld_pgfape date;
ld_fecant date;
ld_fecven date;

begin
  select pgfape into ld_pgfape from fst017 where  pgcod=vn_Ppgcod; 
 

  rpta := 0;
  Begin
      select 
          pgcod,modulo,itsucd,moneda,papel,ctnro,itoper,itsubo,ittope into ln_ppg000pgc,
          ln_ppg000mod,
          ln_ppg000suc,
          ln_ppg000mda,
          ln_ppg000pap,
          ln_ppg000cta,
          ln_ppg000ope,
          ln_ppg000sbo,
          ln_ppg000tpo
        from fsd016
       where pgcod = vn_Ppgcod
         and itsuc = vn_Pitsuc
         and itmod = vn_Pitmod
         and ittran = vn_PIttran
         and itnrel = vn_Pitnrel
         and itord = ln_ordinal
         and itsbor = vn_Pitsbor;
      Exception
         when no_data_found then
          ln_ppg000cta:=0;
          ln_ppg000ope:=0;
   end;
 

    begin
      pq_cr_alinea_interno.sp_cr_fec_proximo_vto(pn_emp => 1,
                                                 pn_mod => ln_ppg000mod,
                                                 pn_suc => ln_ppg000suc,
                                                 pn_mda => ln_ppg000mda,
                                                 pn_pap => ln_ppg000pap,
                                                 pn_cta => ln_ppg000cta,
                                                 pn_oper => ln_ppg000ope,
                                                 pn_sbop => ln_ppg000sbo,
                                                 pn_top => ln_ppg000tpo,
                                                 pd_fecpro => ld_pgfape,
                                                 pd_fecha => ld_fecven);
    end;
  
  
   --revisar cuota pendiente de pago si corresponde a penultima cuota
   begin
      select /*+ parallel(n,2,1)*/
         max(n.ppfval) ---fecha valor de ultima cuota corresponde a fecha de pago de penultima cuota
          into ld_fecant
          from fsd601 n
         where n.pgcod = 1
           and n.ppcta = ln_ppg000cta
           and n.ppmda = ln_ppg000mda
           and n.ppsuc = ln_ppg000suc
           and n.pppap = ln_ppg000pap
           and n.ppoper = ln_ppg000ope
           and n.ppsbop = ln_ppg000sbo
           and n.pptope = ln_ppg000tpo
           and n.ppmod = ln_ppg000mod
           and n.d601co = 'S' ;
   exception when others then
       ld_fecant := null;      
   end;           
   
   if ld_fecven = ld_fecant then
     rpta := 1;---fecha corresponde a penultima cuota
   else
     rpta := 0;  
   end if;

end sp_verificafecha;


  procedure sp_cr_Fec_Proximo_vto(pn_emp    in number,
                                  pn_mod    in number,
                                  pn_suc    in number,
                                  pn_mda    in number,
                                  pn_pap    in number,
                                  pn_cta    in number,
                                  pn_oper   in number,
                                  pn_sbop   in number,
                                  pn_top    in number,
                                  pd_fecpro in date,
                                  pd_fecha  out date) is
  
    ld_fecpxv date;
  begin
    begin
      select /*+ parallel(n,2,1)*/
       min(n.ppfpag)
        into ld_fecpxv
        from fsd601 n
       where n.pgcod = pn_emp
         and n.ppcta = pn_cta
         and n.ppmda = pn_mda
         and n.ppsuc = pn_suc
         and n.pppap = pn_pap
         and n.ppoper = pn_oper
         and n.ppsbop = pn_sbop
         and n.pptope = pn_top
         and n.ppmod = pn_mod
         and n.d601co = 'S'
         and (n.ppcap + n.ppint) <> 0
         and not exists (select /*+ parallel(o,2,1)*/
               ppmod, ppcta, ppoper, pptope, ppfpag
                from fsd602 o
               where o.pgcod = n.pgcod
                 and o.ppmod = n.ppmod
                 and o.ppsuc = n.ppsuc
                 and o.ppmda = n.ppmda
                 and o.pppap = n.pppap
                 and o.ppcta = n.ppcta
                 and o.ppoper = n.ppoper
                 and o.ppsbop = n.ppsbop
                 and o.pptope = n.pptope
                 and o.ppfpag = n.ppfpag
                 and o.pp1fech <= pd_fecpro
                 and o.pp1stat = 'T'
                 and o.d602co = 'S'
                 and (o.pp1cap + o.pp1int) <> 0);
    exception
      when no_data_found then
        ld_fecpxv := null;
      when too_many_rows then
        ld_fecpxv := null;
    end;
    pd_fecha := ld_fecpxv;
  
  end sp_cr_Fec_Proximo_vto;
  
end pq_cr_alinea_interno;
/

