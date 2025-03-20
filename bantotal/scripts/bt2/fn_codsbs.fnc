create or replace function fn_codsbs (pn_pepais in number,pn_petdoc in number, pc_pendoc in varchar2, pn_cta in number) return varchar2
is
lc_codsbs varchar2(10);
begin
  begin

    select lpad(to_char(c.bc739sbs),10,0)
      into lc_codsbs
      from  fbc739 c
     where c.bc739pais = pn_pepais
       and c.bc739tdoc = pn_petdoc
       and c.bc739ndoc = pc_pendoc
       and c.bc739cta  = pn_cta;
  exception
      when others then
         lc_codsbs := null;
  end;
   return lc_codsbs;
end fn_codsbs;
/

