create or replace function dias_mora_credito_drc
(
  P_PGCOD NUMBER,
  P_PPMOD NUMBER,
  P_PPSUC NUMBER,
  P_PPMDA NUMBER,
  P_PPPAP NUMBER,
  P_PPCTA NUMBER,
  P_PPOPER NUMBER,
  P_PPSBOP NUMBER,
  P_PPTOPE NUMBER,
  P_FECHA DATE
) return number is
n_dias number(10);
d_fecven date;
d_fecpag date;
begin

  select count(p.pgcod)
  into n_dias
  from fsd601 c join fsd602 p
  on c.pgcod = p.pgcod
  and c.ppmod = p.ppmod
  and c.ppsuc = p.ppsuc
  and c.ppmda = p.ppmda
  and c.pppap = p.pppap
  and c.ppcta = p.ppcta
  and c.ppoper = p.ppoper
  and c.ppsbop = p.ppsbop
  and c.pptope = p.pptope
  and c.ppfpag = p.ppfpag
  and c.pptipo = p.pptipo
  and p.pp1stat = 'T'
  where
  p.pgcod = P_PGCOD
  and p.ppmod = P_PPMOD
  and p.ppsuc = P_PPSUC
  and p.ppmda = P_PPMDA
  and p.pppap = P_PPPAP
  and p.ppcta = P_PPCTA
  and p.ppoper = P_PPOPER
  and p.ppsbop = P_PPSBOP
  and p.pptope = P_PPTOPE
  order by c.pgcod, c.ppmod, c.ppsuc, c.ppmda, c.pppap, c.ppcta, c.ppoper, c.ppsbop, c.pptope;

  if ( n_dias = 0 ) then
      select min(c.ppfpag)
      into d_fecven
      from fsd601 c
      where
      c.pgcod = P_PGCOD
      and c.ppmod = P_PPMOD
      and c.ppsuc = P_PPSUC
      and c.ppmda = P_PPMDA
      and c.pppap = P_PPPAP
      and c.ppcta = P_PPCTA
      and c.ppoper = P_PPOPER
      and c.ppsbop = P_PPSBOP
      and c.pptope = P_PPTOPE
      order by c.pgcod, c.ppmod, c.ppsuc, c.ppmda, c.pppap, c.ppcta, c.ppoper, c.ppsbop, c.pptope;
  else
      select max(p.ppfpag)
      into d_fecpag
      from fsd601 c join fsd602 p
      on c.pgcod = p.pgcod
      and c.ppmod = p.ppmod
      and c.ppsuc = p.ppsuc
      and c.ppmda = p.ppmda
      and c.pppap = p.pppap
      and c.ppcta = p.ppcta
      and c.ppoper = p.ppoper
      and c.ppsbop = p.ppsbop
      and c.pptope = p.pptope
      and c.ppfpag = p.ppfpag
      and c.pptipo = p.pptipo
      and p.pp1stat = 'T'
      where
      p.pgcod = P_PGCOD
      and p.ppmod = P_PPMOD
      and p.ppsuc = P_PPSUC
      and p.ppmda = P_PPMDA
      and p.pppap = P_PPPAP
      and p.ppcta = P_PPCTA
      and p.ppoper = P_PPOPER
      and p.ppsbop = P_PPSBOP
      and p.pptope = P_PPTOPE
      order by c.pgcod, c.ppmod, c.ppsuc, c.ppmda, c.pppap, c.ppcta, c.ppoper, c.ppsbop, c.pptope;
      
      select min(c.ppfpag)
      into d_fecven
      from fsd601 c      
      where
      c.pgcod = P_PGCOD
      and c.ppmod = P_PPMOD
      and c.ppsuc = P_PPSUC
      and c.ppmda = P_PPMDA
      and c.pppap = P_PPPAP
      and c.ppcta = P_PPCTA
      and c.ppoper = P_PPOPER
      and c.ppsbop = P_PPSBOP
      and c.pptope = P_PPTOPE
      and c.ppfpag > d_fecpag;

      if ( d_fecven is null ) then
         return 0;
      end if;
  end if;
  
  if ( (P_FECHA - d_fecven) <= 0 ) then
     return 0;
  else
     return P_FECHA - d_fecven;
  end if;

end;
/

