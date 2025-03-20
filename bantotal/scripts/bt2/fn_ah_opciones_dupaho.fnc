create or replace function fn_ah_opciones_dupaho(P_N_PAIS   IN NUMBER,
                                                 P_N_TIPO   IN NUMBER,
                                                 P_C_NUMERO IN VARCHAR2,
                                                 P_N_CODCAM IN NUMBER
                                                 ) return  number is
  ln_numsor number(9):=0;
  lc_numero char(12);
  ld_fecpro date;
begin
  lc_numero := rpad(P_C_NUMERO,12,' ');
  select a.pgfape into ld_fecpro from FST017 a where a.pgcod = 1;
  
    begin
      select nvl(sum(a.jaqz169opt),0)
       into  ln_numsor
       from jaqz169 a,
            fsd011  b,
            fsr008  c 
      where a.jaqz169pgc = b.pgcod
        and a.jaqz169suc = b.scsuc
        and a.jaqz169mod = b.scmod
        and a.jaqz169mda = b.scmda
        and a.jaqz169pap = b.scpap
        and a.jaqz169cta = b.sccta
        and a.jaqz169ope = b.scoper
        and a.jaqz169sbo = b.scsbop
        and a.jaqz169tpo = b.sctope
        and a.jaqz169cam = P_N_CODCAM
        and c.pgcod      = b.pgcod
        and c.ctnro      = b.sccta
        and c.pepais     = P_N_PAIS
        and c.petdoc     = P_N_TIPO
        and c.pendoc     = lc_numero
        and a.jaqz169fec = ld_fecpro - 1
        and c.ttcod      = 1
        and c.cttfir     = 'T'
        and b.scstat     <> 99;
    exception
    when others then
      ln_numsor := 0;
    end;          
  return(ln_numsor);
exception
when others then
  ln_numsor := 0;
  return(ln_numsor);
end fn_ah_opciones_dupaho;
/

