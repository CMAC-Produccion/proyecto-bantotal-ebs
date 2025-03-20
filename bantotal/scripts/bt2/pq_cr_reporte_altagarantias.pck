create or replace package pq_cr_reporte_altagarantias is

  -- Author  : RMONTESR
  -- Created : 22/03/2021 15:39:23
  -- Purpose : Reporte Alta Garantias
  -- Modificado: Ray Montes 04/11/2021
  -- Razon:      Se agrego procedimiento de carga para reporte de garantias fae1

  procedure sp_cr_carga_aqpb368(pc_usuario  in varchar,
                                pn_region   in number,
                                pn_zona     in number,
                                pn_sucursal in number,
                                pd_fecini   in date,
                                pd_fecfin   in date);
                                
   procedure sp_cr_carga_rfondosreactiva(pc_usuario  in varchar,
                                pn_region   in number,
                                pn_zona     in number,
                                pn_sucursal in number,
                                pd_fecini   in date,
                                pd_fecfin   in date);
   
   procedure sp_cr_carga_aqpb392(pc_usuario  in varchar,
                                pn_region   in number,
                                pn_zona     in number,
                                pn_sucursal in number,
                                pd_fecini   in date,
                                pd_fecfin   in date);
   procedure sp_cr_carga_aqpb393(pc_usuario  in varchar,
                                pn_region   in number,
                                pn_zona     in number,
                                pn_sucursal in number,
                                pd_fecini   in date,
                                pd_fecfin   in date);
  procedure sp_cr_carga_aqpc261(pc_usuario  in varchar,
                                pn_region   in number,
                                pn_zona     in number,
                                pn_sucursal in number,
                                pd_fecini   in date,
                                pd_fecfin   in date);
  procedure sp_cr_carga_aqpc268(pc_usuario  in varchar,
                                pn_region   in number,
                                pn_zona     in number,
                                pn_sucursal in number,
                                pd_fecini   in date,
                                pd_fecfin   in date);

end pq_cr_reporte_altagarantias;
/

create or replace package body pq_cr_reporte_altagarantias is

  ------------------------------------------------------------
  procedure sp_cr_carga_aqpb368(pc_usuario  in varchar,
                                pn_region   in number,
                                pn_zona     in number,
                                pn_sucursal in number,
                                pd_fecini   in date,
                                pd_fecfin   in date) is
  begin
    begin
      delete from aqpb368 x
       where x.aqpb368usr = rpad(trim(pc_usuario), 10, ' ');
      commit;
    end;
    begin
      insert into aqpb368
        (AQPB368usr,
         AQPB368emp,
         AQPB368suc,
         AQPB368mod,
         AQPB368mda,
         AQPB368pap,
         AQPB368cta,
         AQPB368ope,
         AQPB368sbo,
         AQPB368top,
         AQPB368ins,
         AQPB368sdo,
         AQPB368mtoa,
         AQPB368pcj,
         AQPB368tip,
         AQPB368empg,
         AQPB368sucg,
         AQPB368modg,
         AQPB368mdag,
         AQPB368papg,
         AQPB368ctag,
         AQPB368opeg,
         AQPB368sbog,
         AQPB368topg,
         aqpb368estg,
         aqpb368estgde,
         aqpb368mtoog,
         aqpb368mtoag,
         aqpb368est,
         aqpb368estc,
         aqpb368estcde,
         AQPB368itcod,
         AQPB368itmod,
         AQPB368itsuc,
         AQPB368ittran,
         AQPB368itnrel,
         AQPB368itfcon,
         AQPB368ithor,
         AQPB368itucnf,
         AQPB368usuact,
         AQPB368fecact,
         aqpb368sucdes,
         aqpb368sucgdes)
      
        select pc_usuario,
               t1.AQPB423emp,
               t1.AQPB423suc,
               t1.AQPB423mod,
               t1.AQPB423mda,
               t1.AQPB423pap,
               t1.AQPB423cta,
               t1.AQPB423ope,
               t1.AQPB423sbo,
               t1.AQPB423top,
               t1.AQPB423ins,
               case
                 when t3.scsdo < 0 then
                  t3.scsdo * -1
                 else
                  t3.scsdo
               end,
               t1.AQPB423mtoa,
               t1.AQPB423pcj,
               t1.AQPB423tip,
               t1.AQPB423empg,
               t1.AQPB423sucg,
               t1.AQPB423modg,
               t1.AQPB423mdag,
               t1.AQPB423papg,
               t1.AQPB423ctag,
               t1.AQPB423opeg,
               t1.AQPB423sbog,
               t1.AQPB423topg,
               t2.scstat,
               t4.cenom,
               
               t1.aqpb423mtoa,
               t2.scsdo,
               t1.AQPB423est,
               t3.scstat,
               t5.cenom,
               t1.AQPB423itcod,
               t1.AQPB423itmod,
               t1.AQPB423itsuc,
               t1.AQPB423ittran,
               t1.AQPB423itnrel,
               t1.AQPB423itfcon,
               t1.AQPB423ithor,
               t1.AQPB423itucnf,
               t1.AQPB423usuact,
               t1.AQPB423fecact,
               ta.scnom,
               tb.scnom
          from aqpb423 t1
         inner join fsd011 t2
            on t1.AQPB423empg = t2.pgcod
           and t1.AQPB423SUCG = t2.scsuc
           and t1.AQPB423MODG = t2.scmod
           and t1.AQPB423MDAG = t2.scmda
           and t1.AQPB423PAPG = t2.scpap
           and t1.AQPB423CTAG = t2.sccta
           and t1.AQPB423OPEG = t2.scoper
           and t1.AQPB423SBOG = t2.scsbop
           and t1.AQPB423TOPG = t2.sctope
        
         inner join fsd011 t3
            on t1.AQPB423emp = t3.pgcod
           and t1.AQPB423SUC = t3.scsuc
           and t1.AQPB423MOD = t3.scmod
           and t1.AQPB423MDA = t3.scmda
           and t1.AQPB423PAP = t3.scpap
           and t1.AQPB423CTA = t3.sccta
           and t1.AQPB423OPE = t3.scoper
           and t1.AQPB423SBO = t3.scsbop
           and t1.AQPB423TOP = t3.sctope
          left join fst026 t4
            on t4.cecod = t2.scstat
          left join fst026 t5
            on t5.cecod = t3.scstat
          left join fst001 ta
            on ta.pgcod = t1.AQPB423emp
           and ta.sucurs = t1.AQPB423suc
          left join fst001 tb
            on tb.pgcod = t1.AQPB423empg
           and tb.sucurs = t1.AQPB423sucg
         where t2.scstat <> 99
           and t1.AQPB423itfcon between pd_fecini and pd_fecfin
           and t3.scmod in (select modulo from fst111 where dscod = 50)
           and (t1.AQPB423sucg = pn_sucursal or
               (pn_sucursal = 0 and pn_zona <> 0 and
               t1.AQPB423sucg in
               (select oficod
                    from fst811 t6
                   where t6.pgcod = 1
                     and t6.regcod = pn_zona)) or
               (pn_sucursal = 0 and pn_zona = 0 and
               t1.AQPB423sucg in
               (select oficod
                    from fst811 t7
                   where t7.pgcod = 1
                     and t7.regcod in
                         (select tp1nro2
                            from fst198 t8
                           where t8.tp1cod = 1
                             and t8.tp1cod1 = 10872
                             and t8.tp1corr1 = 11
                             and t8.tp1nro1 = pn_region))));
      commit;
    end;
  end sp_cr_carga_aqpb368;
  -------------------------------------------------------------------------------------------
  procedure sp_cr_carga_rfondosreactiva(pc_usuario  in varchar,
                                pn_region   in number,
                                pn_zona     in number,
                                pn_sucursal in number,
                                pd_fecini   in date,
                                pd_fecfin   in date) is
  begin
    begin
      delete from aqpb369 x
       where x.aqpb369usr = rpad(trim(pc_usuario), 10, ' ');
      commit;
    end;
    begin
      insert into aqpb369
        (aqpb369usr,
         aqpb369emp,
         aqpb369suc,
         aqpb369mod,
         aqpb369mda,
         aqpb369pap,
         aqpb369cta,
         aqpb369ope,
         aqpb369sbo,
         aqpb369top,
         aqpb369ins,
         aqpb369sdo,
         aqpb369mtoa,
         aqpb369pcj,
         aqpb369tip,
         aqpb369empg,
         aqpb369sucg,
         aqpb369modg,
         aqpb369mdag,
         aqpb369papg,
         aqpb369ctag,
         aqpb369opeg,
         aqpb369sbog,
         aqpb369topg,
         aqpb369estg,
         aqpb369estgde,
         aqpb369mtoog,
         aqpb369mtoag,
         aqpb369est,
         aqpb369estc,
         aqpb369estcde,
         aqpb369itcod,
         aqpb369itmod,
         aqpb369itsuc,
         aqpb369ittran,
         aqpb369itnrel,
         aqpb369itfcon,
         aqpb369ithor,
         aqpb369itucnf,
         aqpb369usuact,
         aqpb369fecact,
         aqpb369sucdes,
         aqpb369sucgdes)
      
        select pc_usuario,
               t1.aqpb429emp,
               t1.aqpb429suc,
               t1.aqpb429mod,
               t1.aqpb429mda,
               t1.aqpb429pap,
               t1.aqpb429cta,
               t1.aqpb429ope,
               t1.aqpb429sbo,
               t1.aqpb429top,
               t1.aqpb429ins,
               case
                 when t3.scsdo < 0 then
                  t3.scsdo * -1
                 else
                  t3.scsdo
               end,
               t1.aqpb429mtoa,
               t1.aqpb429pcj,
               t1.aqpb429tip,
               t1.aqpb429empg,
               t1.aqpb429sucg,
               t1.aqpb429modg,
               t1.aqpb429mdag,
               t1.aqpb429papg,
               t1.aqpb429ctag,
               t1.aqpb429opeg,
               t1.aqpb429sbog,
               t1.aqpb429topg,
               t2.scstat,
               t4.cenom,
               
               t1.aqpb429mtoa,
               t2.scsdo,
               t1.aqpb429est,
               t3.scstat,
               t5.cenom,
               t1.aqpb429itcod,
               t1.aqpb429itmod,
               t1.aqpb429itsuc,
               t1.aqpb429ittran,
               t1.aqpb429itnrel,
               t1.aqpb429itfcon,
               t1.aqpb429ithor,
               t1.aqpb429itucnf,
               t1.aqpb429usuact,
               t1.aqpb429fecact,
               ta.scnom,
               tb.scnom
          from aqpb429 t1
         inner join fsd011 t2
            on t1.aqpb429empg = t2.pgcod
           and t1.aqpb429SUCG = t2.scsuc
           and t1.aqpb429MODG = t2.scmod
           and t1.aqpb429MDAG = t2.scmda
           and t1.aqpb429PAPG = t2.scpap
           and t1.aqpb429CTAG = t2.sccta
           and t1.aqpb429OPEG = t2.scoper
           and t1.aqpb429SBOG = t2.scsbop
           and t1.aqpb429TOPG = t2.sctope
        
         inner join fsd011 t3
            on t1.aqpb429emp = t3.pgcod
           and t1.aqpb429SUC = t3.scsuc
           and t1.aqpb429MOD = t3.scmod
           and t1.aqpb429MDA = t3.scmda
           and t1.aqpb429PAP = t3.scpap
           and t1.aqpb429CTA = t3.sccta
           and t1.aqpb429OPE = t3.scoper
           and t1.aqpb429SBO = t3.scsbop
           and t1.aqpb429TOP = t3.sctope
          left join fst026 t4
            on t4.cecod = t2.scstat
          left join fst026 t5
            on t5.cecod = t3.scstat
          left join fst001 ta
            on ta.pgcod = t1.aqpb429emp
           and ta.sucurs = t1.aqpb429suc
          left join fst001 tb
            on tb.pgcod = t1.aqpb429empg
           and tb.sucurs = t1.aqpb429sucg
         where t2.scstat <> 99
           and t1.aqpb429itfcon between pd_fecini and pd_fecfin
           and t3.scmod in (select modulo from fst111 where dscod = 50)
           and (t1.aqpb429sucg = pn_sucursal or
               (pn_sucursal = 0 and pn_zona <> 0 and
               t1.aqpb429sucg in
               (select oficod
                    from fst811 t6
                   where t6.pgcod = 1
                     and t6.regcod = pn_zona)) or
               (pn_sucursal = 0 and pn_zona = 0 and
               t1.aqpb429sucg in
               (select oficod
                    from fst811 t7
                   where t7.pgcod = 1
                     and t7.regcod in
                         (select tp1nro2
                            from fst198 t8
                           where t8.tp1cod = 1
                             and t8.tp1cod1 = 10872
                             and t8.tp1corr1 = 11
                             and t8.tp1nro1 = pn_region))));
      commit;
    end;
  end sp_cr_carga_rfondosreactiva;
  ------------------------------------------------------------
  procedure sp_cr_carga_aqpb392(pc_usuario  in varchar,
                                pn_region   in number,
                                pn_zona     in number,
                                pn_sucursal in number,
                                pd_fecini   in date,
                                pd_fecfin   in date) is
  begin
    begin
      delete from aqpb392 x
       where x.aqpb392usr = rpad(trim(pc_usuario), 10, ' ');
      commit;
    end;
    begin
      insert into aqpb392
        (aqpb392usr,
         aqpb392emp,
         aqpb392suc,
         aqpb392mod,
         aqpb392mda,
         aqpb392pap,
         aqpb392cta,
         aqpb392ope,
         aqpb392sbo,
         aqpb392top,
         aqpb392ins,
         aqpb392sdo,
         aqpb392mtoa,
         aqpb392pcj,
         aqpb392tip,
         aqpb392empg,
         aqpb392sucg,
         aqpb392modg,
         aqpb392mdag,
         aqpb392papg,
         aqpb392ctag,
         aqpb392opeg,
         aqpb392sbog,
         aqpb392topg,
         aqpb392estg,
         aqpb392estgde,
         aqpb392mtoog,
         aqpb392mtoag,
         aqpb392est,
         aqpb392estc,
         aqpb392estcde,
         aqpb392itcod,
         aqpb392itmod,
         aqpb392itsuc,
         aqpb392ittran,
         aqpb392itnrel,
         aqpb392itfcon,
         aqpb392ithor,
         aqpb392itucnf,
         aqpb392usuact,
         aqpb392fecact,
         aqpb392sucdes,
         aqpb392sucgdes)
      
        select pc_usuario,
               t1.aqpb722emp,
               t1.aqpb722suc,
               t1.aqpb722mod,
               t1.aqpb722mda,
               t1.aqpb722pap,
               t1.aqpb722cta,
               t1.aqpb722ope,
               t1.aqpb722sbo,
               t1.aqpb722top,
               t1.aqpb722ins,
               case
                 when t3.scsdo < 0 then
                  t3.scsdo * -1
                 else
                  t3.scsdo
               end,
               t1.aqpb722mtoa,
               t1.aqpb722pcj,
               t1.aqpb722tip,
               t1.aqpb722empg,
               t1.aqpb722sucg,
               t1.aqpb722modg,
               t1.aqpb722mdag,
               t1.aqpb722papg,
               t1.aqpb722ctag,
               t1.aqpb722opeg,
               t1.aqpb722sbog,
               t1.aqpb722topg,
               t2.scstat,
               t4.cenom,
               
               t1.aqpb722mtoa,
               t2.scsdo,
               t1.aqpb722est,
               t3.scstat,
               t5.cenom,
               t1.aqpb722itcod,
               t1.aqpb722itmod,
               t1.aqpb722itsuc,
               t1.aqpb722ittran,
               t1.aqpb722itnrel,
               t1.aqpb722itfcon,
               t1.aqpb722ithor,
               t1.aqpb722itucnf,
               t1.aqpb722usuact,
               t1.aqpb722fecact,
               ta.scnom,
               tb.scnom
          from aqpb722 t1
         inner join fsd011 t2
            on t1.aqpb722empg = t2.pgcod
           and t1.aqpb722SUCG = t2.scsuc
           and t1.aqpb722MODG = t2.scmod
           and t1.aqpb722MDAG = t2.scmda
           and t1.aqpb722PAPG = t2.scpap
           and t1.aqpb722CTAG = t2.sccta
           and t1.aqpb722OPEG = t2.scoper
           and t1.aqpb722SBOG = t2.scsbop
           and t1.aqpb722TOPG = t2.sctope
        
         inner join fsd011 t3
            on t1.aqpb722emp = t3.pgcod
           and t1.aqpb722SUC = t3.scsuc
           and t1.aqpb722MOD = t3.scmod
           and t1.aqpb722MDA = t3.scmda
           and t1.aqpb722PAP = t3.scpap
           and t1.aqpb722CTA = t3.sccta
           and t1.aqpb722OPE = t3.scoper
           and t1.aqpb722SBO = t3.scsbop
           and t1.aqpb722TOP = t3.sctope
          left join fst026 t4
            on t4.cecod = t2.scstat
          left join fst026 t5
            on t5.cecod = t3.scstat
          left join fst001 ta
            on ta.pgcod = t1.aqpb722emp
           and ta.sucurs = t1.aqpb722suc
          left join fst001 tb
            on tb.pgcod = t1.aqpb722empg
           and tb.sucurs = t1.aqpb722sucg
         where t2.scstat <> 99
           and t1.aqpb722est = 'C'
           and t1.aqpb722itfcon between pd_fecini and pd_fecfin
           and t3.scmod in (select modulo from fst111 where dscod = 50)
           and (t1.aqpb722sucg = pn_sucursal or
               (pn_sucursal = 0 and pn_zona <> 0 and
               t1.aqpb722sucg in
               (select oficod
                    from fst811 t6
                   where t6.pgcod = 1
                     and t6.regcod = pn_zona)) or
               (pn_sucursal = 0 and pn_zona = 0 and
               t1.aqpb722sucg in
               (select oficod
                    from fst811 t7
                   where t7.pgcod = 1
                     and t7.regcod in
                         (select tp1nro2
                            from fst198 t8
                           where t8.tp1cod = 1
                             and t8.tp1cod1 = 10872
                             and t8.tp1corr1 = 11
                             and t8.tp1nro1 = pn_region))));
      commit;
    end;
  end sp_cr_carga_aqpb392;
  ------------------------------------------------------------
  procedure sp_cr_carga_aqpb393(pc_usuario  in varchar,
                                pn_region   in number,
                                pn_zona     in number,
                                pn_sucursal in number,
                                pd_fecini   in date,
                                pd_fecfin   in date) is
  begin
    begin
      delete from aqpb393 x
       where x.aqpb393usr = rpad(trim(pc_usuario), 10, ' ');
      commit;
    end;
    begin
      insert into aqpb393
        (aqpb393usr,
         aqpb393emp,
         aqpb393suc,
         aqpb393mod,
         aqpb393mda,
         aqpb393pap,
         aqpb393cta,
         aqpb393ope,
         aqpb393sbo,
         aqpb393top,
         aqpb393ins,
         aqpb393sdo,
         aqpb393mtoa,
         aqpb393pcj,
         aqpb393tip,
         aqpb393empg,
         aqpb393sucg,
         aqpb393modg,
         aqpb393mdag,
         aqpb393papg,
         aqpb393ctag,
         aqpb393opeg,
         aqpb393sbog,
         aqpb393topg,
         aqpb393estg,
         aqpb393estgde,
         aqpb393mtoog,
         aqpb393mtoag,
         aqpb393est,
         aqpb393estc,
         aqpb393estcde,
         aqpb393itcod,
         aqpb393itmod,
         aqpb393itsuc,
         aqpb393ittran,
         aqpb393itnrel,
         aqpb393itfcon,
         aqpb393ithor,
         aqpb393itucnf,
         aqpb393usuact,
         aqpb393fecact,
         aqpb393sucdes,
         aqpb393sucgdes)
      
        select pc_usuario,
               t1.aqpb728emp,
               t1.aqpb728suc,
               t1.aqpb728mod,
               t1.aqpb728mda,
               t1.aqpb728pap,
               t1.aqpb728cta,
               t1.aqpb728ope,
               t1.aqpb728sbo,
               t1.aqpb728top,
               t1.aqpb728ins,
               case
                 when t3.scsdo < 0 then
                  t3.scsdo * -1
                 else
                  t3.scsdo
               end,
               t1.aqpb728mtoa,
               t1.aqpb728pcj,
               t1.aqpb728tip,
               t1.aqpb728empg,
               t1.aqpb728sucg,
               t1.aqpb728modg,
               t1.aqpb728mdag,
               t1.aqpb728papg,
               t1.aqpb728ctag,
               t1.aqpb728opeg,
               t1.aqpb728sbog,
               t1.aqpb728topg,
               t2.scstat,
               t4.cenom,
               
               t1.aqpb728mtoa,
               t2.scsdo,
               t1.aqpb728est,
               t3.scstat,
               t5.cenom,
               t1.aqpb728itcod,
               t1.aqpb728itmod,
               t1.aqpb728itsuc,
               t1.aqpb728ittran,
               t1.aqpb728itnrel,
               t1.aqpb728itfcon,
               t1.aqpb728ithor,
               t1.aqpb728itucnf,
               t1.aqpb728usuact,
               t1.aqpb728fecact,
               ta.scnom,
               tb.scnom
          from aqpb728 t1
         inner join fsd011 t2
            on t1.aqpb728empg = t2.pgcod
           and t1.aqpb728SUCG = t2.scsuc
           and t1.aqpb728MODG = t2.scmod
           and t1.aqpb728MDAG = t2.scmda
           and t1.aqpb728PAPG = t2.scpap
           and t1.aqpb728CTAG = t2.sccta
           and t1.aqpb728OPEG = t2.scoper
           and t1.aqpb728SBOG = t2.scsbop
           and t1.aqpb728TOPG = t2.sctope
        
         inner join fsd011 t3
            on t1.aqpb728emp = t3.pgcod
           and t1.aqpb728SUC = t3.scsuc
           and t1.aqpb728MOD = t3.scmod
           and t1.aqpb728MDA = t3.scmda
           and t1.aqpb728PAP = t3.scpap
           and t1.aqpb728CTA = t3.sccta
           and t1.aqpb728OPE = t3.scoper
           and t1.aqpb728SBO = t3.scsbop
           and t1.aqpb728TOP = t3.sctope
          left join fst026 t4
            on t4.cecod = t2.scstat
          left join fst026 t5
            on t5.cecod = t3.scstat
          left join fst001 ta
            on ta.pgcod = t1.aqpb728emp
           and ta.sucurs = t1.aqpb728suc
          left join fst001 tb
            on tb.pgcod = t1.aqpb728empg
           and tb.sucurs = t1.aqpb728sucg
         where t2.scstat <> 99
           and t1.aqpb728est = 'C'
           and t1.aqpb728itfcon between pd_fecini and pd_fecfin
           and t3.scmod in (select modulo from fst111 where dscod = 50)
           and (t1.aqpb728sucg = pn_sucursal or
               (pn_sucursal = 0 and pn_zona <> 0 and
               t1.aqpb728sucg in
               (select oficod
                    from fst811 t6
                   where t6.pgcod = 1
                     and t6.regcod = pn_zona)) or
               (pn_sucursal = 0 and pn_zona = 0 and
               t1.aqpb728sucg in
               (select oficod
                    from fst811 t7
                   where t7.pgcod = 1
                     and t7.regcod in
                         (select tp1nro2
                            from fst198 t8
                           where t8.tp1cod = 1
                             and t8.tp1cod1 = 10872
                             and t8.tp1corr1 = 11
                             and t8.tp1nro1 = pn_region))));
      commit;
    end;
  end sp_cr_carga_aqpb393;
  
   ------------------------------------------------------------
  procedure sp_cr_carga_aqpc261(pc_usuario  in varchar,
                                pn_region   in number,
                                pn_zona     in number,
                                pn_sucursal in number,
                                pd_fecini   in date,
                                pd_fecfin   in date) is
  begin
    begin
      delete from AQPC261 x
       where x.AQPC261usr = rpad(trim(pc_usuario), 10, ' ');
      commit;
    end;
    begin
      insert into AQPC261
        (AQPC261usr,
         AQPC261emp,
         AQPC261suc,
         AQPC261mod,
         AQPC261mda,
         AQPC261pap,
         AQPC261cta,
         AQPC261ope,
         AQPC261sbo,
         AQPC261top,
         AQPC261ins,
         AQPC261sdo,
         AQPC261mtoa,
         AQPC261pcj,
         AQPC261tip,
         AQPC261empg,
         AQPC261sucg,
         AQPC261modg,
         AQPC261mdag,
         AQPC261papg,
         AQPC261ctag,
         AQPC261opeg,
         AQPC261sbog,
         AQPC261topg,
         AQPC261estg,
         AQPC261estgde,
         AQPC261mtoog,
         AQPC261mtoag,
         AQPC261est,
         AQPC261estc,
         AQPC261estcde,
         AQPC261itcod,
         AQPC261itmod,
         AQPC261itsuc,
         AQPC261ittran,
         AQPC261itnrel,
         AQPC261itfcon,
         AQPC261ithor,
         AQPC261itucnf,
         AQPC261usuact,
         AQPC261fecact,
         AQPC261sucdes,
         AQPC261sucgdes)
      
        select pc_usuario,
               t1.aqpb741emp,
               t1.aqpb741suc,
               t1.aqpb741mod,
               t1.aqpb741mda,
               t1.aqpb741pap,
               t1.aqpb741cta,
               t1.aqpb741ope,
               t1.aqpb741sbo,
               t1.aqpb741top,
               t1.aqpb741ins,
               case
                 when t3.scsdo < 0 then
                  t3.scsdo * -1
                 else
                  t3.scsdo
               end,
               t1.aqpb741mtoa,
               t1.aqpb741pcj,
               t1.aqpb741tip,
               t1.aqpb741empg,
               t1.aqpb741sucg,
               t1.aqpb741modg,
               t1.aqpb741mdag,
               t1.aqpb741papg,
               t1.aqpb741ctag,
               t1.aqpb741opeg,
               t1.aqpb741sbog,
               t1.aqpb741topg,
               t2.scstat,
               t4.cenom,
               
               t1.aqpb741mtoa,
               t2.scsdo,
               t1.aqpb741est,
               t3.scstat,
               t5.cenom,
               t1.aqpb741itcod,
               t1.aqpb741itmod,
               t1.aqpb741itsuc,
               t1.aqpb741ittran,
               t1.aqpb741itnrel,
               t1.aqpb741itfcon,
               t1.aqpb741ithor,
               t1.aqpb741itucnf,
               t1.aqpb741usuact,
               t1.aqpb741fecact,
               ta.scnom,
               tb.scnom
          from AQPB741 t1
         inner join fsd011 t2
            on t1.aqpb741empg = t2.pgcod
           and t1.aqpb741SUCG = t2.scsuc
           and t1.aqpb741MODG = t2.scmod
           and t1.aqpb741MDAG = t2.scmda
           and t1.aqpb741PAPG = t2.scpap
           and t1.aqpb741CTAG = t2.sccta
           and t1.aqpb741OPEG = t2.scoper
           and t1.aqpb741SBOG = t2.scsbop
           and t1.aqpb741TOPG = t2.sctope
        
         inner join fsd011 t3
            on t1.aqpb741emp = t3.pgcod
           and t1.aqpb741SUC = t3.scsuc
           and t1.aqpb741MOD = t3.scmod
           and t1.aqpb741MDA = t3.scmda
           and t1.aqpb741PAP = t3.scpap
           and t1.aqpb741CTA = t3.sccta
           and t1.aqpb741OPE = t3.scoper
           and t1.aqpb741SBO = t3.scsbop
           and t1.aqpb741TOP = t3.sctope
          left join fst026 t4
            on t4.cecod = t2.scstat
          left join fst026 t5
            on t5.cecod = t3.scstat
          left join fst001 ta
            on ta.pgcod = t1.aqpb741emp
           and ta.sucurs = t1.aqpb741suc
          left join fst001 tb
            on tb.pgcod = t1.aqpb741empg
           and tb.sucurs = t1.aqpb741sucg
         where t2.scstat <> 99
           and t1.aqpb741est = 'C'
           and t1.aqpb741itfcon between pd_fecini and pd_fecfin
           and t3.scmod in (select modulo from fst111 where dscod = 50)
           and (t1.aqpb741sucg = pn_sucursal or
               (pn_sucursal = 0 and pn_zona <> 0 and
               t1.aqpb741sucg in
               (select oficod
                    from fst811 t6
                   where t6.pgcod = 1
                     and t6.regcod = pn_zona)) or
               (pn_sucursal = 0 and pn_zona = 0 and
               t1.aqpb741sucg in
               (select oficod
                    from fst811 t7
                   where t7.pgcod = 1
                     and t7.regcod in
                         (select tp1nro2
                            from fst198 t8
                           where t8.tp1cod = 1
                             and t8.tp1cod1 = 10872
                             and t8.tp1corr1 = 11
                             and t8.tp1nro1 = pn_region))));
      commit;
    end;
  end sp_cr_carga_aqpc261;
  
   ------------------------------------------------------------
  procedure sp_cr_carga_aqpc268(pc_usuario  in varchar,
                                pn_region   in number,
                                pn_zona     in number,
                                pn_sucursal in number,
                                pd_fecini   in date,
                                pd_fecfin   in date) is
  begin
    begin
      delete from AQPC268 x
       where x.AQPC268usr = rpad(trim(pc_usuario), 10, ' ');
      commit;
    end;
    begin
      insert into AQPC268
        (AQPC268usr,
         AQPC268emp,
         AQPC268suc,
         AQPC268mod,
         AQPC268mda,
         AQPC268pap,
         AQPC268cta,
         AQPC268ope,
         AQPC268sbo,
         AQPC268top,
         AQPC268ins,
         AQPC268sdo,
         AQPC268mtoa,
         AQPC268pcj,
         AQPC268tip,
         AQPC268empg,
         AQPC268sucg,
         AQPC268modg,
         AQPC268mdag,
         AQPC268papg,
         AQPC268ctag,
         AQPC268opeg,
         AQPC268sbog,
         AQPC268topg,
         AQPC268estg,
         AQPC268estgde,
         AQPC268mtoog,
         AQPC268mtoag,
         AQPC268est,
         AQPC268estc,
         AQPC268estcde,
         AQPC268itcod,
         AQPC268itmod,
         AQPC268itsuc,
         AQPC268ittran,
         AQPC268itnrel,
         AQPC268itfcon,
         AQPC268ithor,
         AQPC268itucnf,
         AQPC268usuact,
         AQPC268fecact,
         AQPC268sucdes,
         AQPC268sucgdes)
      
        select pc_usuario,
               t1.AQPC401emp,
               t1.AQPC401suc,
               t1.AQPC401mod,
               t1.AQPC401mda,
               t1.AQPC401pap,
               t1.AQPC401cta,
               t1.AQPC401ope,
               t1.AQPC401sbo,
               t1.AQPC401top,
               t1.AQPC401ins,
               case
                 when t3.scsdo < 0 then
                  t3.scsdo * -1
                 else
                  t3.scsdo
               end,
               t1.AQPC401mtoa,
               t1.AQPC401pcj,
               t1.AQPC401tip,
               t1.AQPC401empg,
               t1.AQPC401sucg,
               t1.AQPC401modg,
               t1.AQPC401mdag,
               t1.AQPC401papg,
               t1.AQPC401ctag,
               t1.AQPC401opeg,
               t1.AQPC401sbog,
               t1.AQPC401topg,
               t2.scstat,
               t4.cenom,
               
               t1.AQPC401mtoa,
               t2.scsdo,
               t1.AQPC401est,
               t3.scstat,
               t5.cenom,
               t1.AQPC401itcod,
               t1.AQPC401itmod,
               t1.AQPC401itsuc,
               t1.AQPC401ittran,
               t1.AQPC401itnrel,
               t1.AQPC401itfcon,
               t1.AQPC401ithor,
               t1.AQPC401itucnf,
               t1.AQPC401usuact,
               t1.AQPC401fecact,
               ta.scnom,
               tb.scnom
          from AQPC401 t1
         inner join fsd011 t2
            on t1.AQPC401empg = t2.pgcod
           and t1.AQPC401SUCG = t2.scsuc
           and t1.AQPC401MODG = t2.scmod
           and t1.AQPC401MDAG = t2.scmda
           and t1.AQPC401PAPG = t2.scpap
           and t1.AQPC401CTAG = t2.sccta
           and t1.AQPC401OPEG = t2.scoper
           and t1.AQPC401SBOG = t2.scsbop
           and t1.AQPC401TOPG = t2.sctope
        
         inner join fsd011 t3
            on t1.AQPC401emp = t3.pgcod
           and t1.AQPC401SUC = t3.scsuc
           and t1.AQPC401MOD = t3.scmod
           and t1.AQPC401MDA = t3.scmda
           and t1.AQPC401PAP = t3.scpap
           and t1.AQPC401CTA = t3.sccta
           and t1.AQPC401OPE = t3.scoper
           and t1.AQPC401SBO = t3.scsbop
           and t1.AQPC401TOP = t3.sctope
          left join fst026 t4
            on t4.cecod = t2.scstat
          left join fst026 t5
            on t5.cecod = t3.scstat
          left join fst001 ta
            on ta.pgcod = t1.AQPC401emp
           and ta.sucurs = t1.AQPC401suc
          left join fst001 tb
            on tb.pgcod = t1.AQPC401empg
           and tb.sucurs = t1.AQPC401sucg
         where t2.scstat <> 99
           and t1.AQPC401est = 'C'
           and t1.AQPC401itfcon between pd_fecini and pd_fecfin
           and t3.scmod in (select modulo from fst111 where dscod = 50)
           and (t1.AQPC401sucg = pn_sucursal or
               (pn_sucursal = 0 and pn_zona <> 0 and
               t1.AQPC401sucg in
               (select oficod
                    from fst811 t6
                   where t6.pgcod = 1
                     and t6.regcod = pn_zona)) or
               (pn_sucursal = 0 and pn_zona = 0 and
               t1.AQPC401sucg in
               (select oficod
                    from fst811 t7
                   where t7.pgcod = 1
                     and t7.regcod in
                         (select tp1nro2
                            from fst198 t8
                           where t8.tp1cod = 1
                             and t8.tp1cod1 = 10872
                             and t8.tp1corr1 = 11
                             and t8.tp1nro1 = pn_region))));
      commit;
    end;
  end sp_cr_carga_aqpc268;
end pq_cr_reporte_altagarantias;
/

