create or replace procedure sp_cr_fecblobbva(pd_fecpro date, pd_fecblo out date)  is

ld_fecblo date; 
ld_fectmp date; 
ln_numdia integer;  
ls_diafer char;  
ln_totdia number;         
Begin
   ld_fecblo := pd_fecpro;
   ln_totdia := 0;
   SELECT (TO_CHAR(pd_fecpro,'D')) into ln_numdia  FROM DUAL;
   -- Si es sabado
   if ln_numdia = 6 then
      -- Valida si es feriado codcal 900 CCE (feriado nacional)
      -- select fhabil into ls_diafer from fst028 where ffecha = ld_fectmp and calcod=900;
      ld_fectmp := pd_fecpro + 2;
      ls_diafer := null;
      FOR ln_ctldia IN 1..4 LOOP
         select count(*) into ln_totdia from fst028 where ffecha = ld_fectmp and fhabil = 'N';
         if ln_totdia < 160 then
            pd_fecblo := ld_fectmp - 1;
            return;
         end if;
         ld_fectmp := ld_fectmp + 1;
      END LOOP;
   end if;
   -- Si es lunes/martes/miercoles
   if ln_numdia >= 1 and ln_numdia <= 3 then
      ld_fectmp := pd_fecpro + 1;
      ls_diafer := null;
      FOR ln_ctldia IN 1..4 LOOP
         select count(*) into ln_totdia from fst028 where ffecha = ld_fectmp and fhabil = 'N';
         if ln_totdia < 160 then
            pd_fecblo := ld_fectmp - 1;
            return;
         end if;
         ld_fectmp := ld_fectmp + 1;
      END LOOP;
   end if;
   -- Si es jueves / viernes
   if ln_numdia = 4 or ln_numdia = 5 then
      ld_fectmp := pd_fecpro + 1;
      ls_diafer := null;
      FOR ln_ctldia IN 1..6 LOOP
         select count(*) into ln_totdia from fst028 where ffecha = ld_fectmp and fhabil = 'N';
         if ln_totdia < 160 then
            pd_fecblo := ld_fectmp - 1;
            exit;
         end if;
         ld_fectmp := ld_fectmp + 1;
      END LOOP;
   end if;
   -- si es domingo
   if ln_numdia = 7 then
      ld_fectmp := pd_fecpro + 1;
      ls_diafer := null;
      FOR ln_ctldia IN 1..4 LOOP
         select count(*) into ln_totdia from fst028 where ffecha = ld_fectmp and fhabil = 'N';
         if ln_totdia < 160 then
            pd_fecblo := ld_fectmp - 1;
            exit;
         end if;
         ld_fectmp := ld_fectmp + 1;
      END LOOP;
   end if;
 
end;
/

