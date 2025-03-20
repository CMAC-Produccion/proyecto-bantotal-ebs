create or replace function FN_CR_Mto_Cuota(P_Cuenta in number,
                                         P_Operacion in number,
                                         P_Tipo in number,
                                         P_SubTipo in number,
                                         P_Modulo in number,
                                         P_Cod_Age in number,
                                         P_Moneda in number) return number is

  ld_ult_cuota  date := null;
  ld_ult_cancel date := null;
  ln_Mto_Cuota number := 0;
begin

   begin
      select max(ppfpag)
        into ld_ult_cuota
        from fsd602
       where pgcod = 1
         and ppmod   = P_Modulo
         and ppsuc   = P_Cod_Age
         and ppmda   = P_Moneda
         and pppap   = 0
         and ppcta   = P_Cuenta
         and ppoper  = P_Operacion
         and ppsbop  = P_SubTipo
         and pptope  = P_Tipo
         and pp1stat = 'T'
         and pptipo <> 'K'
         and d602co  = 'S';
   exception
   when no_data_found then        -- Cuando no hizo ningun pago
        ld_ult_cuota := null;
   end;
   if ld_ult_cuota is null then
      select min(ppfpag)
        into ld_ult_cancel
        from fsd601
       where pgcod  = 1
         and ppmod  = P_Modulo
         and ppsuc  = P_Cod_Age
         and ppmda  = P_Moneda
         and pppap  = 0
         and ppcta  = P_Cuenta
         and ppoper = P_Operacion
         and ppsbop = P_SubTipo
         and pptope = P_Tipo
         and pptipo <> 'K';
   end if;
   if ld_ult_cancel is null then
      begin
         select min(ppfpag)
           into ld_ult_cancel
           from fsd601
          where pgcod  = 1
            and ppmod  = P_Modulo
            and ppsuc  = P_Cod_Age
            and ppmda  = P_Moneda
            and pppap  = 0
            and ppcta  = P_Cuenta
            and ppoper = P_Operacion
            and ppsbop = P_SubTipo
            and pptope = P_Tipo
            and pptipo <> 'K'
            and ppfpag > ld_ult_cuota;
      exception
      when no_data_found then
         ld_ult_cancel := '';
      end;
   end if;
---> Hallar el Mto. de la Cuota pendiente de Pago
   select sum(ppcap + ppint)
     into ln_Mto_Cuota
     from fsd601
    where pgcod  = 1
      and ppmod  = P_Modulo
      and ppsuc  = P_Cod_Age
      and ppmda  = P_Moneda
      and pppap  = 0
      and ppcta  = P_Cuenta
      and ppoper = P_Operacion
      and ppsbop = P_SubTipo
      and pptope = P_Tipo
      and pptipo <> 'K'
      and ppfpag = ld_ult_cancel;
  return(nvl(ln_Mto_Cuota,0));
end FN_CR_Mto_Cuota;
/

