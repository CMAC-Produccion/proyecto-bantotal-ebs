CREATE OR REPLACE PROCEDURE SP_DIASATRASOMAX (
v_Pgfape in date,
v_Sccta  in number,
ln_diatr_ant out number,
ln_diatr out number )IS

  cursor c_ctas is
           Select  /*+ALL_ROWS PARALLEL(h,16)*/
           h.bcemp,h.bcmod,h.bcsuc,h.bcmda,h.bcpap,h.bccta,h.bcoper,h.bcsbop,h.bctop,h.bcfech,h.bcfvto
           from fsh012 h
          where h.bcemp=1
            and h.bccta =v_Sccta
            and h.bccta <> 999999999
            and substr(h.bcrubr,1,4) in (1411,1414,1415/*,1416*/, 1421,1424,1425/*,1426*/)
            and h.bcmod not in (33,141)
            and h.bcprod <> 99 --se agrego condicion
            and h.bcfech=v_Pgfape;
BEGIN
   ln_diatr_ant:=0;
  for i in c_ctas  loop

            --If v_Scstat in (64,90) Then
        If i.bcmod in (200,33) Then

               ln_diatr := i.bcfech - i.bcfvto;
            Else


       -- exception
         -- when no_data_found then
            begin
              --vigente y refinanciado
              SELECT /*+ALL_ROWS PARALLEL(a,16) (b,16)*/
                    (v_Pgfape - min(a.Ppfpag))
                    into ln_diatr
              FROM FSD601 a left join FSD602 b
              on
                    a.Pgcod  = 1
                and b.Pgcod  = a.Pgcod
                and b.Ppmod  = a.Ppmod
                and b.Ppsuc  = a.Ppsuc
                and b.Ppmda  = a.Ppmda
                and b.Pppap  = a.Pppap
                and b.Ppcta  = a.Ppcta
                and b.Ppoper = a.Ppoper
                and b.Ppsbop = a.Ppsbop
                and b.Pptope = a.Pptope
                and b.Ppfpag = a.Ppfpag
                and b.Pptipo = a.Pptipo
                and b.Pp1stat = 'T'
                and b.D602co  = 'S'
                and b.pp1fech<= i.bcfech
              where
                    a.Pgcod  = 1
                and a.Pgcod  = i.bcemp
                and a.Ppmod  = i.bcmod
                and a.Ppsuc  = i.bcsuc
                and a.Ppmda  = i.bcmda
                and a.Pppap  = i.bcpap
                and a.Ppcta  = i.bccta
                and a.Ppoper = i.bcoper
                and a.Ppsbop = i.bcsbop
                and a.Pptope = i.bctop
                and a.Ppfpag <= i.bcfech
                and a.D601co = 'S'
                and (a.ppcap + a.ppint ) > 0 --se agrego por cuotas de gracia 2013.09.06
                and b.D602co is null;
          exception
            when no_data_found then

              Begin
                 select  /*+ALL_ROWS PARALLEL(d,16)*/
                 (v_Pgfape - min(d.Ppfpag))
                 into ln_diatr
                 from fsd601 d
                 where  d.Pgcod  = 1
                and d.Pgcod  = i.bcemp
                and d.Ppmod  = i.bcmod
                and d.Ppsuc  = i.bcsuc
                and d.Ppmda  = i.bcmda
                and d.Pppap  = i.bcpap
                and d.Ppcta  = i.bccta
                and d.Ppoper = i.bcoper
                and d.Ppsbop = i.bcsbop
                and d.Pptope = i.bctop
                and d.Ppfpag <= i.bcfech
                and (d.ppcap + d.ppint ) > 0;
              exception
                  when no_data_found then
                       ln_diatr := 0;
              End;


        end;
        End IF;

    if (ln_diatr> ln_diatr_ant)
         then ln_diatr_ant:=ln_diatr;
    end if;
   end loop;

      ln_diatr_ant := NVL(ln_diatr_ant,0);
  NULL;

END SP_DIASATRASOMAX;
/

