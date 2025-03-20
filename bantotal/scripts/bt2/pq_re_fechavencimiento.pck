create or replace package pq_re_FechaVencimiento is
  -- *****************************************************************
    -- Nombre                     : PAQUETES CON FUNICON PARA OBTENER FECHA DE VENCIMIENTO Origen EN CRÉDITOS CON PASE A ESTADO JUDICIAL
    -- Sistema                    : BANTOTAL
    -- Módulo                     : RECUPERACIONES
    -- Versión                    : 1.0
    -- Fecha de Creación          : 22/08/2019
    -- Autor de Creación          : KAREN VALENCIA
    -- Uso                        : Realiza cálculos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : Clave del crédito
    --
    --
    --
    -- *****************************************************************

  function Fn_CR_FecVctoOrigen(pn_emp in number,
                                                     pn_mod in number,
                                                     pn_suc in number,
                                                     pn_mda in number,
                                                     pn_pap in number,
                                                     pn_cta in number,
                                                     pn_ope in number,
                                                     pn_sbo in number,
                                                     pn_top in number)
                                                     return date;
end pq_re_FechaVencimiento;
/

create or replace package body pq_re_FechaVencimiento is

function Fn_CR_FecVctoOrigen(pn_emp in number,
                                                     pn_mod in number,
                                                     pn_suc in number,
                                                     pn_mda in number,
                                                     pn_pap in number,
                                                     pn_cta in number,
                                                     pn_ope in number,
                                                     pn_sbo in number,
                                                     pn_top in number)
  return date is

  ln_emp    number(3);
  ln_mod    number(3);
  ln_suc    number(3);
  ln_mda    number(4);
  ln_pap    number(4);
  ln_cta    number(9);
  ln_ope    number(9);
  ln_sbo    number(3);
  ln_top    number(3);
  ld_fecpxv date;
  ld_fecpag date;
begin
      begin
          select a.r1cod,
               a.r1mod,
               a.r1suc,
               a.r1mda,
               a.r1pap,
               a.r1cta,
               a.r1oper,
               a.r1sbop,
               a.r1tope
          into ln_emp,
               ln_mod,
               ln_suc,
               ln_mda,
               ln_pap,
               ln_cta,
               ln_ope,
               ln_sbo,
               ln_top
          from fsr011 a
         where a.r2cod = pn_emp
           and a.r2mod = pn_mod
           and a.r2suc = pn_suc
           and a.r2mda = pn_mda
           and a.r2pap = pn_pap
           and a.r2cta = pn_cta
           and a.r2oper = pn_ope
           and a.r2sbop = pn_sbo
           and a.r2tope = pn_top
           and a.relcod = 36;
      exception
        when no_data_found then
          begin
             select a.r1cod,
                     a.r1mod,
                     a.r1suc,
                     a.r1mda,
                     a.r1pap,
                     a.r1cta,
                     a.r1oper,
                     a.r1sbop,
                     a.r1tope
                into ln_emp,
                     ln_mod,
                     ln_suc,
                     ln_mda,
                     ln_pap,
                     ln_cta,
                     ln_ope,
                     ln_sbo,
                     ln_top
                from fsr011 a
               where a.r2cod = pn_emp
                 and a.r2mod = pn_mod
                 and a.r2suc = pn_suc
                 and a.r2mda = pn_mda
                 and a.r2pap = pn_pap
                 and a.r2cta = pn_cta
                 and a.r2oper = pn_ope
                 and a.r2sbop = pn_sbo
                 and a.r2tope = pn_top
                 and a.relcod = 52;
            exception
             when others then
              null;
         end;
   end;
  begin
    select /*+ parallel(o,2,1)*/
     max(ppfpag)
      into ld_fecpag
      from fsd602 o
     where o.pgcod = ln_emp
       and o.ppmod = ln_mod
       and o.ppsuc = ln_suc
       and o.ppmda = ln_mda
       and o.pppap = ln_pap
       and o.ppcta = ln_cta
       and o.ppoper = ln_ope
       and o.ppsbop = ln_sbo
       and o.pptope = ln_top

       and o.pp1stat = 'T'
       and o.d602co = 'S'
       and (o.pp1cap + o.pp1int) <> 0
       and (o.d602mo, o.d602tr) not in (select 98, 310 from dual)
       and (o.d602mo, o.d602tr) not in (select 98, 312 from dual)
       and (o.d602mo, o.d602tr) not in (select 98, 316 from dual)
       and (o.d602mo, o.d602tr) not in (select 300, 390 from dual)
       and (o.d602mo, o.d602tr) not in (select 98, 311 from dual)
       and (o.d602mo, o.d602tr) not in (select 300, 406 from dual) --kdvc
       and (o.d602mo, o.d602tr) not in (select 300, 400 from dual);--kdvc
  exception
    when others then
      null;
  end;
  if ld_fecpag is null then
    ld_fecpag := to_date('01/01/0001','dd/mm/yyyy');
  end if;
  begin
    select /*+ parallel(n,2,1)*/
     min(n.ppfpag)
      into ld_fecpxv
      from fsd601 n
     where n.pgcod = ln_emp
       and n.ppcta = ln_cta
       and n.ppmda = ln_mda
       and n.ppsuc = ln_suc
       and n.pppap = ln_pap
       and n.ppoper = ln_ope
       and n.ppsbop = ln_sbo
       and n.pptope = ln_top
       and n.ppmod = ln_mod
       and n.d601co = 'S'
       and (n.ppcap + n.ppint) <> 0
       and n.ppfpag > ld_fecpag;
  exception
    when no_data_found then
      select min(n.ppfpag)
      into ld_fecpxv
      from fsd601 n
     where n.pgcod = ln_emp
       and n.ppcta = ln_cta
       and n.ppmda = ln_mda
       and n.ppsuc = ln_suc
       and n.pppap = ln_pap
       and n.ppoper = ln_ope
       and n.ppsbop = ln_sbo
       and n.pptope = ln_top
       and n.ppmod = ln_mod
       and n.d601co = 'S'
       and (n.ppcap + n.ppint) <> 0;
  end;

  return ld_fecpxv;

end Fn_CR_FecVctoOrigen;

end pq_re_FechaVencimiento;
/

