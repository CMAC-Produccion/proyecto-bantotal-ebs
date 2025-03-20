create or replace package pq_gar_verifica is

  -- Author  : KVALENCIAC
  -- Created : 11/04/2018 10:58:25 a.m.
  -- Purpose : 
  -- Modificación  : KVALENCIAC
  -- Fecha de Modificación      : 18/01/2024 10:58:25 a.m.
  -- Autor de la Modificación   : KVALENCIAC
  -- Purpose : Se modificó para que valide dato fijo en caso de tener flag activo
  
procedure sp_IngresoRevision (vn_Ppgcod in number, vn_Pitsuc in number, vn_Pitmod in number, vn_PIttran in number, vn_Pitnrel in number, vn_Pitord in number, vn_Pitsbor in number,  rpta out number, ln_modulo out number,ln_atributo out number);
  
end pq_gar_verifica;
/

create or replace package body pq_gar_verifica is

procedure sp_IngresoRevision(vn_Ppgcod in number, vn_Pitsuc in number, vn_Pitmod in number, vn_PIttran in number, vn_Pitnrel in number, vn_Pitord in number, vn_Pitsbor in number,  rpta out number, ln_modulo out number,ln_atributo out number)
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
ln_tabla number (2);
lc_tabla varchar(30);
ld_pgfape date;
rpta2 number(1);
ln_flag number(17,2);--kvalenciac 18/01/2024
ln_valor number(17,2); --kvalenciac 18/01/2024
ln_atributo2 number(17,2); --kvalenciac 18/01/2024
begin
  select pgfape into ld_pgfape from fst017 where  pgcod=vn_Ppgcod; 
begin
  select tp1nro1,tp1nro2, tp1imp1,tp1imp2,tp1imp3 into ln_modulo,ln_atributo,ln_flag,ln_valor,ln_atributo2 --kvalenciac 18/01/2024
    from fst198
   where tp1cod = vn_Ppgcod
     and tp1cod1 = 11116
     and tp1corr1 = 1
     and tp1corr2 = vn_Pitmod
     and tp1corr3 = vn_PIttran;
  Exception
                 when no_data_found then
                   ln_modulo :=0;
                   ln_atributo := 0;               
  end;
  begin
  select ppg010tdat
    into ln_tabla
    from ppg010
   where ppg010cdat in (ln_atributo);
  Exception when no_data_found then ln_tabla := 0; end;
  begin
  select trim(tp1desc) into lc_tabla
    from fst198
   where tp1cod = vn_Ppgcod
     and tp1cod1 = 11116
     and tp1corr1 = 3
     and tp1corr2 = ln_tabla;
  Exception
                 when no_data_found then
                   lc_tabla :='';
  end;
  rpta := 0;
  
  --fin 18/01/2024
  
  if (ln_modulo<> 0 and ln_atributo<>0) then
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
         and itord = 10
         and itsbor = vn_Pitsbor;
      Exception
         when no_data_found then
          ln_ppg000cta:=0;
          ln_ppg000ope:=0;
      end;
      rpta2:=1;
      --inicio kvalenciac 18/01/2024 valido si tiene el valor marcado
      if (ln_flag=1) then
        rpta2:=0;-- si entra aqui debe validar en la PPg008 tenga ese atributo (ln_atributo2) igual al valor colocado ln_valor; si es igual se valida lo parte de abajo sino no hace nada y sale
        begin
          select 1 into rpta2 
            from ppg008
           where ppg008pgc = ln_ppg000pgc
             and ppg008mod = ln_modulo   --modulo de guia
             and ppg008suc = ln_ppg000suc
             and ppg008mda = ln_ppg000mda
             and ppg008pap = ln_ppg000pap
             and ppg008cta = ln_ppg000cta
             and ppg008ope = ln_ppg000ope
             and ppg008cdat = ln_atributo2 --atributo
             and PPG008CIP = ln_valor; --solo si es 40 valida lo de abajo que tenga dato sino no debe validar nada 
          Exception
          when no_data_found then
            rpta2:=0;
        end;
      end if;
      --busco formulario
      if (rpta2=1) then 
              begin
              select  
              max(PPG000FRM) into ln_ppg000frm
              from ppg000
              where
              ppg000pgc = ln_ppg000pgc and
              ppg000mod = ln_modulo and --modulo de guia
              ppg000suc = ln_ppg000suc and
              ppg000mda = ln_ppg000mda and
              ppg000pap = ln_ppg000pap and
              ppg000cta = ln_ppg000cta and
              ppg000ope = ln_ppg000ope and
              ppg000sbo = ln_ppg000sbo and
              ppg000top = ln_ppg000tpo and
              ppg000TSC = vn_Pitsuc and --sucursal transacción
              ppg000tmd = vn_Pitmod and --modulo transacción
              ppg000ttr = vn_PIttran and --trasaccion ingresada
              ppg000tnr = vn_Pitnrel and --número de relación
              ppg000tfc = ld_pgfape;  --fecha transacción
              Exception
                 when no_data_found then
                  ln_ppg000frm:=0;
              end;
              if (lc_tabla='PPG008') then
                begin
                  select 1 into rpta 
                    from ppg008
                   where ppg008pgc = ln_ppg000pgc
                     and ppg008mod = ln_modulo   --modulo de guia
                     and ppg008suc = ln_ppg000suc
                     and ppg008mda = ln_ppg000mda
                     and ppg008pap = ln_ppg000pap
                     and ppg008cta = ln_ppg000cta
                     and ppg008ope = ln_ppg000ope
                     and ppg008frm = ln_ppg000frm  --formulario
                     and ppg008cdat = ln_atributo;  --atributo
                  Exception
                  when no_data_found then
                    rpta:=0;
              end;
         end if;
      else
          rpta:=1;---devuelve 1 para que no salga pantalla de control
      end if;
   end if;    
end sp_IngresoRevision;
end pq_gar_verifica;
/

