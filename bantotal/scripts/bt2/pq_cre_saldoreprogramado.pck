create or replace package pq_cre_saldoreprogramado is

  -- Author  : KVALENCIAC
  -- Created : 07/04/2020 
  -- Purpose : 
   -- Modificado  : KVALENCIAC
  -- Created : 10/11/2022
  -- Purpose :
procedure sp_verificasaldo (vn_Ppgcod in number, vn_Pitsuc in number, vn_Pitmod in number, vn_PIttran in number, vn_Pitnrel in number, vn_Pitord in number, vn_Pitsbor in number,  rpta out number, ln_saldo out number);

procedure sp_verificasaldo2 (vn_Ppgcod in number, vn_Pitsuc in number, vn_Pitmod in number, vn_PIttran in number, vn_Pitnrel in number, vn_Pitord in number, vn_Pitsbor in number,  rpta out number, ln_saldo out number);
  
end pq_cre_saldoreprogramado;
/

create or replace package body pq_cre_saldoreprogramado is

procedure sp_verificasaldo(vn_Ppgcod in number, vn_Pitsuc in number, vn_Pitmod in number, vn_PIttran in number, vn_Pitnrel in number, vn_Pitord in number, vn_Pitsbor in number,  rpta out number, ln_saldo out number)
  is
--ln_atributo number(9);
--ln_modulo number(3);
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
ln_monto number;
begin
  select pgfape into ld_pgfape from fst017 where  pgcod=vn_Ppgcod; 
  begin
  select tp1nro1 into ln_ordinal
    from fst198
   where tp1cod = vn_Ppgcod
     and tp1cod1 = 11123
     and tp1corr1 = 2
     and tp1corr2 = 1
     and tp1corr3 = 2;
  Exception
                 when no_data_found then
                   ln_ordinal :=10;                     
  end; 
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
      --busco formulario
   ln_saldo :=0;
   begin        
        select  
        sum(scsdo) into ln_saldo
        from fsd011
        where
        pgcod = ln_ppg000pgc and
        sccta = ln_ppg000cta and
        scrub in (9500092000000,9500093000000,9500094000000) and 
        scoper = ln_ppg000ope and     
        scmda = ln_ppg000mda 
        order by PGCOD, SCRUB, SCCTA;
      Exception
         when no_data_found then
          ln_saldo:=0;
    end;
    /*
    begin
        select sum(pgcod) into rpta 
         from fsd011
        where
        pgcod = ln_ppg000pgc and
        sccta = ln_ppg000cta and
        scrub in (9500092000000,9500093000000,9500094000000) and 
        scoper = ln_ppg000ope and     
        scmda = ln_ppg000mda 
        order by PGCOD, SCRUB, SCCTA;
       Exception
        when no_data_found then
            rpta:=0; 
    end;*/
    
    if (ln_saldo<0) then
       ln_saldo := ln_saldo*-1;
    end if;
    if (ln_saldo>0) then
      rpta := 1;
    end if;
end sp_verificasaldo;
procedure sp_verificasaldo2(vn_Ppgcod in number, vn_Pitsuc in number, vn_Pitmod in number, vn_PIttran in number, vn_Pitnrel in number, vn_Pitord in number, vn_Pitsbor in number,  rpta out number, ln_saldo out number)
  is
--ln_atributo number(9);
--ln_modulo number(3);
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
ln_monto number;
begin
  select pgfape into ld_pgfape from fst017 where  pgcod=vn_Ppgcod; 
  begin
  select tp1nro1 into ln_ordinal
    from fst198
   where tp1cod = vn_Ppgcod
     and tp1cod1 = 11123
     and tp1corr1 = 2
     and tp1corr2 = 1
     and tp1corr3 = 2;
  Exception
                 when no_data_found then
                   ln_ordinal :=10;                     
  end; 
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
      --busco formulario
   ln_saldo :=0;
   begin        
        select  
        sum(scsdo) into ln_saldo
        from fsd011
        where
        pgcod = ln_ppg000pgc and
        sccta = ln_ppg000cta and
        scrub in (9500092000000,9500093000000,9500094000000) and 
        scoper = ln_ppg000ope and     
        scmda = ln_ppg000mda 
        order by PGCOD, SCRUB, SCCTA;
      Exception
         when no_data_found then
          ln_saldo:=0;
    end;
    /*
    begin
        select sum(pgcod) into rpta 
         from fsd011
        where
        pgcod = ln_ppg000pgc and
        sccta = ln_ppg000cta and
        scrub in (9500092000000,9500093000000,9500094000000) and 
        scoper = ln_ppg000ope and     
        scmda = ln_ppg000mda 
        order by PGCOD, SCRUB, SCCTA;
       Exception
        when no_data_found then
            rpta:=0; 
    end;*/
    begin 
       select aqpb999mora+aqpb999icv into ln_monto
       from aqpb999
       where aqpb999emp = ln_ppg000pgc
       and aqpb999mod   = ln_ppg000mod
       and aqpb999suc   = ln_ppg000suc
       and aqpb999mda   = ln_ppg000mda
       and aqpb999pap   = ln_ppg000pap
       and aqpb999cta   = ln_ppg000cta
       and aqpb999ope   = ln_ppg000ope
       and aqpb999sbo   =ln_ppg000sbo
       and aqpb999top   = ln_ppg000tpo;
      Exception
         when no_data_found then
          ln_monto:=0;
    end;
       
       
    if (ln_saldo<0) then
       ln_saldo := ln_saldo*-1;
    end if;
    if (ln_saldo>0 and ln_monto>0) then
      rpta := 1;
    end if;
end sp_verificasaldo2;
end pq_cre_saldoreprogramado;
/

