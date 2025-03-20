CREATE OR REPLACE FUNCTION FN_TIPCLI (P_C_NUMDOC IN varchar2,
                                      P_N_TIPDOC IN number
                                     ) RETURN VARCHAR2 is
  v_tipcli varchar2(20);
  n_ctl001 integer;
  n_ctl002 integer;
  n_ctl003 integer;
begin
   n_ctl001 := 0;
   n_ctl002 := 0;
   n_ctl003 := 0;
   select count(a.pendoc) INTO n_ctl001
     from fsr008 a,fsd011 b
    where a.ttcod = 1
      and a.cttfir = 'T'
      and a.pgcod = b.pgcod
      and a.ctnro = b.sccta
      and b.scmod in (21,22)
      and b.scstat <> 99
      and a.pendoc = P_C_NUMDOC
      and a.petdoc = P_N_TIPDOC;
   n_ctl001 := nvl(n_ctl001,0);
   IF n_ctl001 > 0 THEN
      n_ctl002 := 1;
   END IF;
   n_ctl001 := 0;
   select count(a.pendoc) INTO n_ctl001
     from fsr008 a,fsd011 b,fst111 c
    where a.ttcod = 1
      and a.cttfir = 'T'
      and a.pgcod = b.pgcod
      and a.ctnro = b.sccta
      and ((c.dscod in (50) and b.scmod = c.modulo) or b.scmod in (117,29,120,144))
      and b.scstat <> 99
      and a.pendoc = P_C_NUMDOC
      and a.petdoc = P_N_TIPDOC;
   n_ctl001 := nvl(n_ctl001,0);
   IF n_ctl001 > 0 THEN
      n_ctl003 := 1;
   END IF;
   IF n_ctl002 + n_ctl003 = 2 THEN
      v_tipcli := 'MIXTO';
   ELSIF n_ctl002 = 1 and n_ctl003 = 0 THEN
      v_tipcli := 'AHORROS';
   ELSIF n_ctl002 = 0 and n_ctl003 = 1 THEN
      v_tipcli := 'CREDITOS';
   ELSE
      v_tipcli := 'USUARIO';
   END IF;
   RETURN v_tipcli;
end FN_TIPCLI;
/

