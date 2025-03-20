create or replace package PQ_CR_SEGUROS is

  procedure  SP_DatosPago(p_ppmod in number,
                          p_ppsuc in number,
                          p_ppmda in number,
                          p_pppap in number,
                          p_ppcta in number,
                          p_ppoper in number,
                          p_ppsbop in number,
                          p_ppTope in number,
                          p_segcod in number,
                          p_fecha  out date,
                          p_estado out varchar2,
                          p_posi   out number,
                          p_vdesa  out varchar2);
------------------------------------------------------------
  procedure SP_DESAFILIA(p_ppmod in number,
                          p_ppsuc in number,
                          p_ppmda in number,
                          p_pppap in number,
                          p_ppcta in number,
                          p_ppoper in number,
                          p_ppsbop in number,
                          p_ppTope in number,
                          p_segcod in number,
                          p_fMax   in date,
                          p_estado in varchar2,
                          p_posi   in number,
                          p_user   in varchar2,
                          p_msg    out varchar2);
------------------------------------------------------------
  procedure SP_AFILIA(p_ppmod in number,
                      p_ppsuc in number,
                      p_ppmda in number,
                      p_pppap in number,
                      p_ppcta in number,
                      p_ppoper in number,
                      p_ppsbop in number,
                      p_ppTope in number,
                      p_segcod in number,
                      p_user   in varchar2,
                      p_msg    out varchar2);

------------------------------------------------------------

end PQ_CR_SEGUROS;
/

create or replace package body PQ_CR_SEGUROS is
    -- Function and procedure implementations
  procedure SP_DatosPago(p_ppmod in number,
                          p_ppsuc in number,
                          p_ppmda in number,
                          p_pppap in number,
                          p_ppcta in number,
                          p_ppoper in number,
                          p_ppsbop in number,
                          p_ppTope in number,
                          p_segcod in number,
                          p_fecha  out date,
                          p_estado out varchar2,
                          p_posi   out number,
                          p_vdesa  out varchar2)as
  cursor posicion is
     select sgcod
       from fpp001
      where pgcod = 1
        and aomod = p_ppmod
        and aosuc = p_ppsuc
        and aomda = p_ppmda
        and aopap = p_pppap
        and aocta = p_ppcta
        and aooper = p_ppoper
        and aosbop = p_ppsbop
        and aotope = p_ppTope
      order by sgcod asc;

--  fecha date;
  ln_tipo char(1);
  ln_imp11 number(17,2):= 0;
  ln_imp12 number(17,2):= 0;
  ln_imp13 number(17,2):= 0;
  ln_imp14 number(17,2):= 0;
  ln_imp15 number(17,2):= 0;
  cont     number:= 0;
  importe  number(17,2):=0;
  importe1 number(17,2):=0;


  begin
      select max(ppfpag)--, pp1stat
        into p_fecha--, p_estado
        from fsd602 --> detalle de pago de seguros
       Where Pgcod = 1
         AND Ppmod = p_ppmod
         AND Ppsuc = p_ppsuc
         AND Ppmda = p_ppmda
         AND Pppap = p_pppap
         AND Ppcta = p_ppcta
         AND Ppoper = p_ppoper
         AND Ppsbop = p_ppsbop
         AND Pptope = p_ppTope
         AND D602co = 'S';

         if p_fecha is not null then
           Begin
            select pp1stat, pptipo
              into p_estado, ln_tipo
              from fsd602 --> detalle de pago de seguros
             Where Pgcod = 1
               AND Ppmod = p_ppmod
               AND Ppsuc = p_ppsuc
               AND Ppmda = p_ppmda
               AND Pppap = p_pppap
               AND Ppcta = p_ppcta
               AND Ppoper = p_ppoper
               AND Ppsbop = p_ppsbop
               AND Pptope = p_ppTope
               AND D602co = 'S'
               and ppfpag = p_fecha
               and rownum = 1;

           select min(ppimp11),
                  min(ppimp12),
                  min(ppimp13),
                  min(ppimp14),
                  min(ppimp15)
             into ln_imp11, ln_imp12, ln_imp13, ln_imp14,ln_imp15
             from fsd611 --ppcta = 156217 and ppoper = 2605941;
            where pgcod = 1
              and ppmod = p_ppmod
              and ppsuc = p_ppsuc
              and ppmda = p_ppmda
              and pppap = p_pppap
              and ppcta = p_ppcta
              and ppoper = p_ppoper
              and ppsbop = p_ppsbop
              and pptope = p_ppTope
              and ppfpag = (select Min(ppfpag)
                              from fsd611 a
                             where a.pgcod = 1
                               and a.ppmod = p_ppmod
                               and a.ppsuc = p_ppsuc
                               and a.ppmda = p_ppmda
                               and a.pppap = p_pppap
                               and a.ppcta = p_ppcta
                               and a.ppoper = p_ppoper
                               and a.pptope = p_ppTope
                               and a.ppfpag > p_fecha)
              and pptipo = ln_tipo;

           exception
             when no_data_found then
               p_estado := '0';
           end;
         else
           select min(ppimp11),
                  min(ppimp12),
                  min(ppimp13),
                  min(ppimp14)
             into ln_imp11, ln_imp12, ln_imp13, ln_imp14
             from fsd611 --ppcta = 156217 and ppoper = 2605941;
            where pgcod = 1
              and ppmod = p_ppmod
              and ppsuc = p_ppsuc
              and ppmda = p_ppmda
              and pppap = p_pppap
              and ppcta = p_ppcta
              and ppoper = p_ppoper
              and ppsbop = p_ppsbop
              and pptope = p_ppTope;
         end if;
         for p in posicion loop
           cont := cont + 1;
           if p.sgcod = p_segcod then
              p_posi := cont;
             exit;
           end if;
         end loop;
       --  if p_estado = 'P' then
         case p_posi
               when 1 then if ln_imp11 is not null then

                              importe1 := ln_imp11;
                           end if;
               when 2 then if ln_imp12 is not null then
                              importe1 := ln_imp12;
                           end if;
               when 3 then if ln_imp13 is not null then
                              importe1 := ln_imp13;
                           end if;
               when 4 then if ln_imp14 is not null then
                              importe1 := ln_imp14;
                           end if;
               when 5 then if ln_imp15 is not null then
                              importe1 := ln_imp15;
                           end if;
               else
                 p_vdesa := 'N';
           end case;

           Begin
              select tp1imp1
                into importe
                from fst198
               Where Tp1cod = 1
                 and Tp1cod1 = 10898
                 and Tp1corr1 = 18
                 and Tp1nro3 = p_segcod;
           exception when no_data_found then
             importe := 0;
           end;

           if importe1 = importe then
             p_vdesa :='S';
           else
             p_vdesa := 'N';
           end if;
        -- end if;
  end SP_DatosPago;
  ------------------------------------------------------------------------
  procedure SP_DESAFILIA(p_ppmod in number,
                          p_ppsuc in number,
                          p_ppmda in number,
                          p_pppap in number,
                          p_ppcta in number,
                          p_ppoper in number,
                          p_ppsbop in number,
                          p_ppTope in number,
                          p_segcod in number,
                          p_fMax   in date,
                          p_estado in varchar2,
                          p_posi   in number,
                          p_user   in varchar2,
                          p_msg    out varchar2) as
  cursor Hist_fsd611 is
    SELECT *
      FROM fsd611
     Where Pgcod  = 1
       and Ppmod  = p_ppmod
       and Ppsuc  = p_ppsuc
       and Ppmda  = p_ppmda
       and Pppap  = p_pppap
       and Ppcta  = p_ppcta
       and Ppoper = p_ppoper
       and Ppsbop = p_ppsbop
       and Pptope = p_ppTope
       and Ppfpag > p_fMax;
importeSeg number(10,2):=0;
fechaVTO   date;
fechacan   date;
Correlativo number:= 0;
DEVINV number(9);
plan3  number:= 0;
oper3  number:= 0;
  Begin
    begin
      select 1
        into plan3
        from fst198
       Where Tp1cod = 1
         AND Tp1cod1 = 10884
         AND Tp1corr1 = 30
         and tp1nro1 =  p_segcod;
    exception
      when no_Data_Found then
       plan3 := 0;
    end;
    Begin
      select 1
        into oper3
        from fst198
       Where Tp1cod = 1
         AND Tp1cod1 = 10884
         AND Tp1corr1 = 31
         and tp1nro1 = p_ppmod
         and tp1nro2 = p_ppTope;
    exception
      when no_Data_Found then
       oper3 := 0;
    end;
    if (plan3 = 0 and oper3 = 0) or (plan3 = 1 and oper3 = 0)  then -- smarquez 31/10/2019


      select pgfape into fechacan from fst017 where pgcod = 1;
      for h in Hist_fsd611 loop
        delete jaqy778
         where jaqy778cod = 1
           and jaqy778mod = p_ppmod
           and jaqy778suc = p_ppsuc
           and jaqy778mda = p_ppmda
           and jaqy778pap = p_pppap
           and jaqy778cta = p_ppcta
           and jaqy778oper = p_ppoper
           and jaqy778sbop = p_ppsbop
           and jaqy778tope = p_ppTope
           and jaqy778fpag > p_fMax;
         commit;
        insert into jaqy778(jaqy778cod,
                            jaqy778mod,
                            jaqy778suc,
                            jaqy778mda,
                            jaqy778pap,
                            jaqy778cta,
                            jaqy778oper,
                            jaqy778sbop,
                            jaqy778tope,
                            jaqy778fpag,
                            jaqy778tipo,
                            jaqy778exte,
                            jaqy778imp1,
                            jaqy778imp2,
                            jaqy778imp3,
                            jaqy778imp4,
                            jaqy778imp5,
                            jaqy778imp6,
                            jaqy778imp7,
                            jaqy778imp8,
                            jaqy778imp9,
                            jaqy778imp10,
                            jaqy778imp11,
                            jaqy778imp12,
                            jaqy778imp13,
                            jaqy778imp14,
                            jaqy778imp15,
                            jaqy778imp16,
                            jaqy778imp17,
                            jaqy778imp18,
                            jaqy778imp19,
                            jaqy778imp20,
                            jaqy778fchsis,
                            jaqy778hora,
                            jaqy778user,
                            jaqy778est)
                     values(h.pgcod,
                            h.ppmod,
                            h.ppsuc,
                            h.ppmda,
                            h.pppap,
                            h.ppcta,
                            h.ppoper,
                            h.ppsbop,
                            h.pptope,
                            h.ppfpag,
                            h.pptipo,
                            h.ppexte,
                            h.ppimp1,
                            h.ppimp2,
                            h.ppimp3,
                            h.ppimp4,
                            h.ppimp5,
                            h.ppimp6,
                            h.ppimp7,
                            h.ppimp8,
                            h.ppimp9,
                            h.ppimp10,
                            h.ppimp11,
                            h.ppimp12,
                            h.ppimp13,
                            h.ppimp14,
                            h.ppimp15,
                            h.ppimp16,
                            h.ppimp17,
                            h.ppimp18,
                            h.ppimp19,
                            h.ppimp20,
                            trunc(sysdate),
                            to_char(sysdate,'hh24:MM:SS'),
                            p_user,
                            'D');


      end loop;

      BEGIN
          INSERT INTO JAQY762(jaqy762pgcod,
                              jaqy762mod,
                              jaqy762suc,
                              jaqy762mda,
                              jaqy762pap,
                              jaqy762cta,
                              jaqy762oper,
                              jaqy762sbop,
                              jaqy762tope,
                              jaqy762sgcod,
                              jaqy762fchsis,
                              jaqy762hora,
                              jaqy762est,
                              jaqy762vc,
                              jaqy762imp,
                              jaqy762porc,
                              jaqy762plus,
                              jaqy762part,
                              jaqy762veh,
                              jaqy762inm,
                              jaqy762end,
                              jaqy762stat,
                              jaqy762co,
                              jaqy762user)
              SELECT pgcod ,aomod,aosuc,aomda  ,aopap ,aocta ,aooper ,aosbop ,aotope,sgcod, TRUNC(SYSDATE),TO_CHAR(SYSDATE,'HH24:MM:SS'),pp001stat,pp001vc ,pp001imp ,
                     pp001porc, pp001plus, pp001part, pp001veh, pp001inm, pp001end, pp001stat, pp001co,P_USER
                from fpp001  --> relacion credito seguro
               Where Pgcod  = 1
                 and Aomod  = p_ppmod
                 and Aosuc  = p_ppsuc
                 and Aomda  = p_ppmda
                 and Aopap  = p_pppap
                 and Aocta  = p_ppcta
                 and Aooper = p_ppoper
                 and Aosbop = p_ppsbop
                 and Aotope = p_ppTope;
  --               and SgCod  = p_segcod;
      EXCEPTION WHEN DUP_VAL_ON_INDEX THEN
        NULL;
      END;
     --- commit;
      begin
        select pp001imp
          into importeSeg
          from FPP001
         WHERE Pgcod  = 1
           and Aomod  = p_ppmod
           and Aosuc  = p_ppsuc
           and Aomda  = p_ppmda
           and Aopap  = p_pppap
           and Aocta  = p_ppcta
           and Aooper = p_ppoper
           and Aosbop = p_ppsbop
           and Aotope = p_ppTope
           and SgCod  = p_segcod;
      exception
        when no_data_found then
         importeSeg := 0;
      end;
      --obtenemos correlativo
      beGIN
        select NVL(max(evcorr),0)
          into Correlativo
          from fsd012
         where pgcod = 1
           and aomod = p_ppmod
           and aosuc = p_ppsuc
           and aomda = p_ppmda
           and aopap = p_pppap
           and aocta = p_ppcta
           and aooper = p_ppoper
           and aosbop = p_ppsbop
           and aotope = p_ppTope;
         Correlativo := Correlativo + 1;
         DEVINV :=  999999999 - Correlativo;
      EXCEPTION
        WHEN NO_dATA_FOUND THEN
          Correlativo := 0;
      END;

      bEGIN
      select min(ppfvto)
        into fechaVTO
        from fsd601 f1
       where f1.pgcod = 1
         and f1.ppmod = p_ppmod
         and f1.ppsuc = p_ppsuc
         and f1.ppmda = p_ppmda
         and f1.pppap = p_pppap
         and f1.ppcta = p_ppcta
         and f1.ppoper = p_ppoper
         and f1.ppsbop = p_ppsbop
         and f1.pptope = p_ppTope
         and f1.ppfpag > (select max(ppfpag)
                        from fsd602
                       where pgcod = 1
                         and ppmod = p_ppmod
                         and ppsuc = p_ppsuc
                         and ppmda = p_ppmda
                         and pppap = p_pppap
                         and ppcta = p_ppcta
                         and ppoper = p_ppoper
                         and ppsbop = p_ppsbop
                         and pptope = p_pptope
                         and d602co = 'S'
                         and pp1stat = 'T');
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          fechaVTO := NULL;
      END;
      Begin
        insert into fsd012(pgcod,
                            aomod,
                            aosuc,
                            aomda,
                            aopap,
                            aocta,
                            aooper,
                            aosbop,
                            aotope,
                            evcorr,
                            evtipo,
                            evfval,
                            evfvto,
                            evimp, --  evttas. evtasa
                            evcap,--   evint evmor evscap evsint evsmor evintc evmorc evcd01
                            evcd02,
                            evinv,
                            d012co,
                            evttas,
                            evtasa,
                            evint,
                            evmor,
                            evscap,
                            evsint,
                            evsmor,
                            evintc,
                            evmorc,
                            evcd01,
                            evper,
                            evtcbi,
                            evtcbi1,
                            evarb,
                            evarb1,
                            evpre,
                            evpre1,
                            d012cd,
                            d012mo,
                            d012su,
                            d012tr,
                            d012re,
                            d012fc,
                            d012or,
                            d012sb)
                     values(1,
                            p_ppmod,
                            p_ppsuc,
                            p_ppmda,
                            p_pppap,
                            p_ppcta,
                            p_ppoper,
                            p_ppsbop,
                            p_ppTope,
                            Correlativo,
                            47,
                            fechacan,
                            fechaVTO,
                            importeSeg,
                            p_segcod,
                            'B',
                            DEVINV,
                            'S',
                            0,
                            0.000000,
                            0.00,
                            0.00,
                            0.00,
                            0.00,
                            0.00,
                            0.00,
                            0.00,
                            0,
                            0,
                            0.00000000,
                            0.00000000,
                            0.00000000,
                            0.00000000,
                            0.00000000,
                            0.00000000,
                            0,
                            0,
                            0,
                            0,
                            0,
                            null,
                            0,
                            0);
         ---   commit;
      Exception
        when dup_val_on_index then
          null;
         when others then
          null;
      end;

      bEGIN
        FOR reg IN HIST_FSD611 LOOP

          CASE P_POSI
            WHEN  1 THEN
               UPDATE FSD611
                  SET ppimp11 = ppimp12,
                      ppimp12 = ppimp13,
                      ppimp13 = ppimp14,
                      ppimp14 = ppimp15 ,
                      Ppimp15 = 0
                where pgcod = 1
                  and ppmod = reg.ppmod
                  AND ppsuc = reg.ppsuc
                  AND ppmda = reg.ppmda
                  AND pppap = reg.pppap
                  AND ppcta = reg.ppcta
                  AND ppoper = reg.ppoper
                  AND ppsbop = reg.ppsbop
                  AND pptope = reg.ppTope
                  AND ppfpag = reg.ppfpag;

            WHEN 2 THEN
               UPDATE FSD611
                  SET ppimp12 = ppimp13,
                      ppimp13 = ppimp14,
                      ppimp14 = ppimp15,
                      Ppimp15 = 0
                where pgcod = 1
                  and ppmod = reg.ppmod
                  AND ppsuc = reg.ppsuc
                  AND ppmda = reg.ppmda
                  AND pppap = reg.pppap
                  AND ppcta = reg.ppcta
                  AND ppoper = reg.ppoper
                  AND ppsbop = reg.ppsbop
                  AND pptope = reg.ppTope
                  AND ppfpag = reg.ppfpag;

            WHEN 3 THEN
                 UPDATE FSD611
                  SET ppimp13 = ppimp14,
                      ppimp14 = ppimp15,
                      Ppimp15 = 0
                where pgcod = 1
                  and ppmod = reg.ppmod
                  AND ppsuc = reg.ppsuc
                  AND ppmda = reg.ppmda
                  AND pppap = reg.pppap
                  AND ppcta = reg.ppcta
                  AND ppoper = reg.ppoper
                  AND ppsbop = reg.ppsbop
                  AND pptope = reg.ppTope
                  AND ppfpag = reg.ppfpag;
            WHEN  4 THEN
              UPDATE FSD611
                  SET ppimp14 = ppimp15,
                      Ppimp15 = 0
                where pgcod = 1
                  and ppmod = reg.ppmod
                  AND ppsuc = reg.ppsuc
                  AND ppmda = reg.ppmda
                  AND pppap = reg.pppap
                  AND ppcta = reg.ppcta
                  AND ppoper = reg.ppoper
                  AND ppsbop = reg.ppsbop
                  AND pptope = reg.ppTope
                  AND ppfpag = reg.ppfpag;
            WHEN 5 THEN
              UPDATE FSD611
                  SET ppimp15 = 0
                where pgcod = 1
                  and ppmod = reg.ppmod
                  AND ppsuc = reg.ppsuc
                  AND ppmda = reg.ppmda
                  AND pppap = reg.pppap
                  AND ppcta = reg.ppcta
                  AND ppoper = reg.ppoper
                  AND ppsbop = reg.ppsbop
                  AND pptope = reg.ppTope
                  AND ppfpag = reg.ppfpag;
            end case;
        END LOOP;

      DELETE FPP001  WHERE Pgcod  = 1
                         and Aomod  = p_ppmod
                         and Aosuc  = p_ppsuc
                         and Aomda  = p_ppmda
                         and Aopap  = p_pppap
                         and Aocta  = p_ppcta
                         and Aooper = p_ppoper
                         and Aosbop = p_ppsbop
                         and Aotope = p_ppTope
                         and SgCod  = p_segcod;
                         p_msg := 'S';
        commit;
      EXCEPTION WHEN OTHERS THEN
        P_MSG := 'N';
      END;
   else
     P_MSG := 'N';
   end if;
  End SP_DESAFILIA;
  ---------------------------------------------------
  procedure SP_AFILIA(p_ppmod in number,
                      p_ppsuc in number,
                      p_ppmda in number,
                      p_pppap in number,
                      p_ppcta in number,
                      p_ppoper in number,
                      p_ppsbop in number,
                      p_ppTope in number,
                      p_segcod in number,
                      p_user   in varchar2,
                      p_msg    out varchar2)is

   cursor Hist_fsd611(fechaMax date) is
    SELECT *
      FROM fsd611
     Where Pgcod  = 1
       and Ppmod  = p_ppmod
       and Ppsuc  = p_ppsuc
       and Ppmda  = p_ppmda
       and Pppap  = p_pppap
       and Ppcta  = p_ppcta
       and Ppoper = p_ppoper
       and Ppsbop = p_ppsbop
       and Pptope = p_ppTope
       and Ppfpag > fechaMax;
    cursor posicion is
     select *--sgcod
       from fpp001
      where pgcod = 1
        and aomod = p_ppmod
        and aosuc = p_ppsuc
        and aomda = p_ppmda
        and aopap = p_pppap
        and aocta = p_ppcta
        and aooper = p_ppoper
        and aosbop = p_ppsbop
        and aotope = p_ppTope
      order by sgcod asc;

  fecha date;
  cont number:= 0;
  posi number:= 0;
  importe number:= 0;
  importe_s number:=0;
  importe_d number:=0;

  Begin
   select max(ppfpag)--, pp1stat
        into fecha--, p_estado
        from fsd602 --> detalle de pago de seguros
       Where Pgcod = 1
         AND Ppmod = p_ppmod
         AND Ppsuc = p_ppsuc
         AND Ppmda = p_ppmda
         AND Pppap = p_pppap
         AND Ppcta = p_ppcta
         AND Ppoper = p_ppoper
         AND Ppsbop = p_ppsbop
         AND Pptope = p_ppTope
         AND D602co = 'S';
    if  fecha is null then
      Begin
        select aofval
          into fecha
          from fsd010
         where pgcod = 1
           and aomod = p_ppmod
           and aosuc = p_ppsuc
           and aomda = p_ppmda
           and aopap = p_pppap
           and aocta = p_ppcta
           and aooper = p_ppoper
           and aosbop = p_ppsbop
           and aotope = p_ppTope ;
      exception
        when no_data_found then null;
      end;
    end if;

    delete jaqy762 where jaqy762pgcod = 1 and jaqy762mod  = p_ppmod and jaqy762suc  = p_ppsuc and jaqy762mda  = p_ppmda
                     and jaqy762pap  = p_pppap and jaqy762cta  = p_ppcta and jaqy762oper = p_ppoper
                     and jaqy762sbop = p_ppsbop and jaqy762tope = p_ppTope;
    commit;

    for co in posicion loop
      insert into jaqy762(jaqy762pgcod,
                          jaqy762mod,
                          jaqy762suc,
                          jaqy762mda,
                          jaqy762pap,
                          jaqy762cta,
                          jaqy762oper,
                          jaqy762sbop,
                          jaqy762tope,
                          jaqy762sgcod,
                          jaqy762fchsis,
                          jaqy762hora,
                          jaqy762imp,
                          jaqy762est)
                   values(co.pgcod,
                          co.aomod,
                          co.aosuc,
                          co.aomda,
                          co.aopap,
                          co.aocta,
                          co.aooper,
                          co.aosbop,
                          co.aotope,
                          co.sgcod,
                          trunc(sysdate),
                          to_char(sysdate,'hh24:MM:SS'),
                          co.pp001imp,
                          'A');
    end loop;
     commit;
    for p in posicion loop
       cont := cont + 1;
       if p.sgcod = p_segcod then
          posi := cont;
          p_msg :='S';
         exit;
       end if;
    end loop;
    Begin
        select tp1imp1,tp1imp2
          into importe_s, importe_d
          from fst198
         Where Tp1cod = 1
           and Tp1cod1 = 10898
           and Tp1corr1 = 18
           and Tp1nro3 = p_segcod;
     exception when no_data_found then
--       importe := 0;
        importe_s :=0;
        importe_d :=0;
     end;
     if p_ppmda = 0 then
       importe := importe_s;
     else
       importe := importe_d;
     end if;
    delete jaqy778
     where jaqy778cod = 1
       and jaqy778mod = p_ppmod
       and jaqy778suc = p_ppsuc
       and jaqy778mda = p_ppmda
       and jaqy778pap = p_pppap
       and jaqy778cta = p_ppcta
       and jaqy778oper = p_ppoper
       and jaqy778sbop = p_ppsbop
       and jaqy778tope = p_ppTope
       and jaqy778fpag > fecha;
     commit;
    for h in Hist_fsd611(fecha) loop
      insert into jaqy778(jaqy778cod,
                          jaqy778mod,
                          jaqy778suc,
                          jaqy778mda,
                          jaqy778pap,
                          jaqy778cta,
                          jaqy778oper,
                          jaqy778sbop,
                          jaqy778tope,
                          jaqy778fpag,
                          jaqy778tipo,
                          jaqy778exte,
                          jaqy778imp1,
                          jaqy778imp2,
                          jaqy778imp3,
                          jaqy778imp4,
                          jaqy778imp5,
                          jaqy778imp6,
                          jaqy778imp7,
                          jaqy778imp8,
                          jaqy778imp9,
                          jaqy778imp10,
                          jaqy778imp11,
                          jaqy778imp12,
                          jaqy778imp13,
                          jaqy778imp14,
                          jaqy778imp15,
                          jaqy778imp16,
                          jaqy778imp17,
                          jaqy778imp18,
                          jaqy778imp19,
                          jaqy778imp20,
                          jaqy778fchsis,
                          jaqy778hora,
                          jaqy778user,
                          jaqy778est)
                   values(h.pgcod,
                          h.ppmod,
                          h.ppsuc,
                          h.ppmda,
                          h.pppap,
                          h.ppcta,
                          h.ppoper,
                          h.ppsbop,
                          h.pptope,
                          h.ppfpag,
                          h.pptipo,
                          h.ppexte,
                          h.ppimp1,
                          h.ppimp2,
                          h.ppimp3,
                          h.ppimp4,
                          h.ppimp5,
                          h.ppimp6,
                          h.ppimp7,
                          h.ppimp8,
                          h.ppimp9,
                          h.ppimp10,
                          h.ppimp11,
                          h.ppimp12,
                          h.ppimp13,
                          h.ppimp14,
                          h.ppimp15,
                          h.ppimp16,
                          h.ppimp17,
                          h.ppimp18,
                          h.ppimp19,
                          h.ppimp20,
                          trunc(sysdate),
                          to_char(sysdate,'hh24:MM:SS'),
                          p_user,
                          'A');
    end loop;
    For reg in Hist_fsd611(fecha) loop
       CASE POSI
          WHEN  1 THEN
             UPDATE FSD611
                SET Ppimp15 = ppimp14,
                    ppimp14 = ppimp13,
                    ppimp13 = ppimp12,
                    ppimp12 = ppimp11,
                    ppimp11 = importe
              where pgcod = 1
                and ppmod = reg.ppmod
                AND ppsuc = reg.ppsuc
                AND ppmda = reg.ppmda
                AND pppap = reg.pppap
                AND ppcta = reg.ppcta
                AND ppoper = reg.ppoper
                AND ppsbop = reg.ppsbop
                AND pptope = reg.ppTope
                AND ppfpag = reg.ppfpag;

          WHEN 2 THEN
             UPDATE FSD611
                SET Ppimp15 = ppimp14,
                    ppimp14 = ppimp13,
                    ppimp13 = ppimp12,
                    ppimp12 = importe
              where pgcod = 1
                and ppmod = reg.ppmod
                AND ppsuc = reg.ppsuc
                AND ppmda = reg.ppmda
                AND pppap = reg.pppap
                AND ppcta = reg.ppcta
                AND ppoper = reg.ppoper
                AND ppsbop = reg.ppsbop
                AND pptope = reg.ppTope
                AND ppfpag = reg.ppfpag;

          WHEN 3 THEN
               UPDATE FSD611
                SET Ppimp15 = ppimp14,
                    ppimp14 = ppimp13,
                    ppimp13 = importe
              where pgcod = 1
                and ppmod = reg.ppmod
                AND ppsuc = reg.ppsuc
                AND ppmda = reg.ppmda
                AND pppap = reg.pppap
                AND ppcta = reg.ppcta
                AND ppoper = reg.ppoper
                AND ppsbop = reg.ppsbop
                AND pptope = reg.ppTope
                AND ppfpag = reg.ppfpag;
          WHEN  4 THEN
            UPDATE FSD611
                SET Ppimp15 = ppimp14,
                    ppimp14 = importe
              where pgcod = 1
                and ppmod = reg.ppmod
                AND ppsuc = reg.ppsuc
                AND ppmda = reg.ppmda
                AND pppap = reg.pppap
                AND ppcta = reg.ppcta
                AND ppoper = reg.ppoper
                AND ppsbop = reg.ppsbop
                AND pptope = reg.ppTope
                AND ppfpag = reg.ppfpag;
          WHEN 5 THEN
            UPDATE FSD611
                SET ppimp15 = importe
              where pgcod = 1
                and ppmod = reg.ppmod
                AND ppsuc = reg.ppsuc
                AND ppmda = reg.ppmda
                AND pppap = reg.pppap
                AND ppcta = reg.ppcta
                AND ppoper = reg.ppoper
                AND ppsbop = reg.ppsbop
                AND pptope = reg.ppTope
                AND ppfpag = reg.ppfpag;
          end case;
    End loop;
    commit;
  end SP_AFILIA;
end PQ_CR_SEGUROS;
/

