create or replace function fn_ocum_fec_desembolso(P_Cuenta in number,
                                                  P_Operacion in number) return Date is

  ld_fec_desemb date := null;
begin

   begin
      select min(d_010.aofval)
        into ld_fec_desemb
        from fsd010 d_010
       where d_010.pgcod  = 1
         and d_010.aopap  = 0
         and d_010.aocta  = P_Cuenta
         and d_010.aooper = P_Operacion
         and d_010.aosbop = 0
         and d_010.aofval <> to_date('0001.01.01','yyyy.mm.dd');
   exception
   when others then
        ld_fec_desemb := null;
   end;

   if ld_fec_desemb is null then
      begin
          select min(d_010.aofval)
            into ld_fec_desemb
            from fsd010 d_010
           where d_010.pgcod  = 1
             and d_010.aopap  = 0
             and d_010.aocta  = P_Cuenta
             and d_010.aooper = P_Operacion
             and d_010.aosbop = 1
             and d_010.aofval <> to_date('0001.01.01','yyyy.mm.dd');
      exception
      when others then
           ld_fec_desemb := null;
      end;
   end if;
   if ld_fec_desemb is null then
      begin
         select min(d_010.aofval)
           into ld_fec_desemb
           from fsd010 d_010
          where d_010.pgcod  = 1
            and d_010.aocta  = P_Cuenta
            and d_010.aooper = P_Operacion
            and d_010.aofval <> to_date('0001.01.01','yyyy.mm.dd');
      exception      
      when others then
           ld_fec_desemb := null;
      end;
   end if;

   return ld_fec_desemb;
end fn_ocum_fec_desembolso;
/

