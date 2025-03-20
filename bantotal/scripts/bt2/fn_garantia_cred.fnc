create or replace function fn_garantia_cred(p_Pgcod  in number,
                                            p_Scmod  in number,
                                            p_Scsuc  in number,
                                            p_Scmda  in number,
                                            p_Scpap  in number,
                                            p_Sccta  in number,
                                            p_Scoper in number,
                                            p_Scsbop in number,
                                            p_Sctope in number
                                           ) return varchar2 is

    lv_desgar varchar2(10000);

    cursor c_relgar
        is select trim(t04.tonom) gara
             from fsr011 r11 join fst004 t04 on t04.modulo = r11.r2mod
                                            and t04.totope = r11.r2tope
            where r11.r1cod = p_Pgcod
              and r11.r1mod = p_Scmod
              and r11.r1suc = p_Scsuc
              and r11.r1mda = p_Scmda
              and r11.r1pap = p_Scpap
              and r11.r1cta = p_Sccta
              and r11.r1oper= p_Scoper
              and r11.r1sbop= p_Scsbop
              and r11.r1tope= p_Sctope
              and r11.relcod= 50
              and r11.r011co= 'S';

    cursor c_garlin
        is select trim(t04.tonom) gara
             from fsr011 r11 join fsr011 r11_2 on r11_2.r1cod= r11.r2cod
                                              and r11_2.r1mod= r11.r2mod
                                              and r11_2.r1suc= r11.r2suc
                                              and r11_2.r1mda= r11.r2mda
                                              and r11_2.r1pap= r11.r2pap
                                              and r11_2.r1cta= r11.r2cta
                                              and r11_2.r1oper=r11.r2oper
                                              and r11_2.r1sbop=r11.r2sbop
                                              and r11_2.r1tope=r11.r2tope
                                              and r11_2.relcod=50
                                              and r11_2.r011co='S'
                               join fst004 t04 on t04.modulo = r11_2.r2mod
                                              and t04.totope = r11_2.r2tope
            where r11.r1cod = p_Pgcod
              and r11.r1mod = p_Scmod
              and r11.r1suc = p_Scsuc
              and r11.r1mda = p_Scmda
              and r11.r1pap = p_Scpap
              and r11.r1cta = p_Sccta
              and r11.r1oper= p_Scoper
              and r11.r1sbop= p_Scsbop
              and r11.r1tope= p_Sctope
              and r11.relcod= 46
              and r11.r011co= 'S';

  begin
      If p_Scmod = 116 Then
          for x in c_garlin loop
              lv_desgar := lv_desgar||x.gara||'|';
          End loop;
      Else
          for x in c_relgar loop
              lv_desgar := lv_desgar||x.gara||'|';
          End loop;
      End If;

      lv_desgar := substr(lv_desgar,1,length(lv_desgar)-1);
      Return lv_desgar;

end fn_garantia_cred;
/

