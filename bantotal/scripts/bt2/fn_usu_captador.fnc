create or replace function fn_usu_captador(
                                               v_Sccta  in number,
                                               v_Scoper in number,
                                               v_Scpgc  in number,
                                               v_scmod  in number,
                                               v_scsuc  in number,
                                               v_scmda  in number,
                                               v_scpap  in number,
                                               v_ssbop  in number,
                                               v_sctop  in number

                                             ) return varchar2 is

    lc_analista varchar2(10);
    lc_hora  varchar2(8);
    lc_fecha DATE;
  begin

           SELECT min(jaqm251fec)
             into lc_fecha
             FROM jaqm251
            WHERE JAQM251PGC=v_Scpgc
              AND JAQM251MOD=v_scmod
              AND JAQM251SUC=v_scsuc
              AND JAQM251MDA=v_scmda
              AND JAQM251PAP=v_scpap
              and JAQM251CTA=v_Sccta
              AND JAQM251OPE=v_Scoper
              AND JAQM251SBO=v_ssbop
              AND JAQM251TOP=v_sctop;

         if lc_fecha is not null then

           SELECT min(jaqm251hoc)
             into lc_hora
             FROM jaqm251
             WHERE JAQM251PGC=v_Scpgc
              AND JAQM251MOD=v_scmod
              AND JAQM251SUC=v_scsuc
              AND JAQM251MDA=v_scmda
              AND JAQM251PAP=v_scpap
              and JAQM251CTA=v_Sccta
              AND JAQM251OPE=v_Scoper
              AND JAQM251SBO=v_ssbop
              AND JAQM251TOP=v_sctop
              AND jaqm251fec=lc_fecha;

      Begin
           SELECT JAQM251UCA
             into lc_analista
             FROM jaqm251
            WHERE JAQM251PGC=v_Scpgc
              AND JAQM251MOD=v_scmod
              AND JAQM251SUC=v_scsuc
              AND JAQM251MDA=v_scmda
              AND JAQM251PAP=v_scpap
              and JAQM251CTA=v_Sccta
              AND JAQM251OPE=v_Scoper
              AND JAQM251SBO=v_ssbop
              AND JAQM251TOP=v_sctop
              AND jaqm251fec=lc_fecha
              and jaqm251hoc=lc_hora;
     exception
       when too_many_rows then
            SELECT JAQM251UCA
              into lc_analista
              FROM jaqm251
             WHERE JAQM251PGC=v_Scpgc
               AND JAQM251MOD=v_scmod
               AND JAQM251SUC=v_scsuc
               AND JAQM251MDA=v_scmda
               AND JAQM251PAP=v_scpap
               and JAQM251CTA=v_Sccta
               AND JAQM251OPE=v_Scoper
               AND JAQM251SBO=v_ssbop
               AND JAQM251TOP=v_sctop
               AND jaqm251fec=lc_fecha
               and jaqm251hoc=lc_hora
               and rownum = 1;
       when no_data_found then
         BEGIN
           select jaql964usu
             into lc_analista
             from jaql964
            where JAQL964PGCOD = v_Scpgc
              and JAQL964SUC = v_scsuc
              and jaql964cta  = v_Sccta
              and JAQL964PAP = v_scpap
              and jaql964ope = v_Scoper
              and jaql964sob = v_ssbop
              and jaql964mda = v_scmda
              and jaql964mod = v_scmod
              and jaql964top = v_sctop;
         exception
           when no_data_found then
             lc_analista := 'S/Analista';
         end;

     end;
     else
        BEGIN
           select jaql964usu
             into lc_analista
             from jaql964
            where JAQL964PGCOD = v_Scpgc
              and JAQL964SUC = v_scsuc
              and jaql964cta  = v_Sccta
              and JAQL964PAP = v_scpap
              and jaql964ope = v_Scoper
              and jaql964sob = v_ssbop
              and jaql964mda = v_scmda
              and jaql964mod = v_scmod
              and jaql964top = v_sctop;
         exception
           when no_data_found then
             lc_analista := 'S/Analista';
         end;
     end if;
  return lc_analista;
end;
/

