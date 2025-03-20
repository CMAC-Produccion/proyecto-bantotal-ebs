create or replace package PQ_CR_REPORTE_SEGCAMPANIA is

  Procedure Sp_cr_reporte_AUX(pd_Fecini in date,
                              pd_fecfin in date,
                              pd_Fecpro in date,
                              pc_usr    in char);
  Procedure Sp_cr_reporte(pd_Fecini date,
                          pd_fecfin date,
                          pd_Fecpro date,
                          pc_usr    char);
  Procedure Sp_cr_reporte_bk(pd_Fecini in date,
                             pd_fecfin in date,
                             pd_Fecpro in date,
                             pc_usr    in char);

end PQ_CR_REPORTE_SEGCAMPANIA;
/

create or replace package body PQ_CR_REPORTE_SEGCAMPANIA is

  Procedure Sp_cr_reporte_AUX(pd_Fecini in date,
                              pd_fecfin in date,
                              pd_Fecpro in date,
                              pc_usr    in char) is
  
    cursor creditos is
      select a.pgcod,
             a.aomod,
             a.aosuc,
             a.aomda,
             a.aopap,
             a.aocta,
             a.aooper,
             a.aosbop,
             a.aotope,
             a.aostat,
             a.aoimp,
             a.aofval,
             a.aofvto,
             c.pepais,
             c.petdoc,
             c.pendoc,
             e.xwfprcins,
             g.jaqy327enti,
             
             d.regcod,
             d.regnom,
             d.codzon,
             d.deszon,
             f.sng001ase,
             sum(g.jaqy327sdeu) deuda
        from fsd010 a, fsr008 c, regsuc d, XWF700 e, sng001 f, jaqy327 g
       where a.pgcod = 1
         and a.aostat <> 99
         and a.aofval between pd_Fecini and pd_fecfin
            
         and a.aocta = c.ctnro
         and c.ttcod = 1
         and c.cttfir = 'T'
         and a.aosuc = d.sucurs
         and e.xwfcar3 = '1'
         and e.xwfempresa = a.pgcod
         and e.xwfmodulo = a.aomod
         and e.xwfsucursal = a.aosuc
         and e.xwfmoneda = a.aomda
         and e.xwfpapel = a.aopap
         and e.xwfcuenta = a.aocta
         and e.xwfoperacion = a.aooper
         and e.xwfsubope = a.aosbop
         and e.xwftipope = a.aotope
         and e.xwfprcins = f.sng001inst
         and g.jaqy327inst = f.sng001inst
         and g.jaqy327aux4 = '1'
         and g.jaqy327esta = 'S'
       group by a.pgcod,
                a.aomod,
                a.aosuc,
                a.aomda,
                a.aopap,
                a.aocta,
                a.aooper,
                a.aosbop,
                a.aotope,
                a.aostat,
                a.aoimp,
                a.aofval,
                a.aofvto,
                c.pepais,
                c.petdoc,
                c.pendoc,
                e.xwfprcins,
                g.jaqy327enti,
                d.regcod,
                d.regnom,
                d.codzon,
                d.deszon,
                f.sng001ase;
    lc_hora char(8);
  begin
  
    delete from jaqz683 where jaqz683USR = pc_usr;
    commit;
  
    lc_hora := to_char(sysdate, 'HH24:MI:SS');
  
    for i in creditos loop
    
      insert into jaqz683
        (jaqz683emp,
         jaqz683mod,
         jaqz683suc,
         jaqz683mda,
         jaqz683pap,
         jaqz683cta,
         jaqz683ope,
         jaqz683sbo,
         jaqz683top,
         jaqz683est,
         jaqz683imp,
         jaqz683fva,
         jaqz683fvt,
         jaqz683pai,
         jaqz683tdo,
         jaqz683ndo,
         jaqz683ins,
         jaqz683ent,
         jaqz683reg,
         jaqz683ren,
         jaqz683zon,
         jaqz683dzn,
         jaqz683ana,
         jaqz683usr,
         jaqz683fep,
         jaqz683hor,
         jaqz683sdo)
      
      values
        (i.pgcod,
         i.aomod,
         i.aosuc,
         i.aomda,
         i.aopap,
         i.aocta,
         i.aooper,
         i.aosbop,
         i.aotope,
         i.aostat,
         i.aoimp,
         i.aofval,
         i.aofvto,
         i.pepais,
         i.petdoc,
         i.pendoc,
         i.xwfprcins,
         i.jaqy327enti,
         
         i.regcod,
         i.regnom,
         i.codzon,
         i.deszon,
         i.sng001ase,
         pc_usr,
         pd_Fecpro,
         lc_hora,
         i.deuda);
      commit;
    end loop;
  
  end Sp_cr_reporte_AUX;

  Procedure Sp_cr_reporte(pd_Fecini in date,
                          pd_fecfin in date,
                          pd_Fecpro in date,
                          pc_usr    in char) is
  
    lc_hora char(8);
  begin
  
    delete from jaqz683 where jaqz683USR = pc_usr;
    commit;
  
    lc_hora := to_char(sysdate, 'HH24:MI:SS');
  
    begin
      insert into jaqz683
        (jaqz683emp,
         jaqz683mod,
         jaqz683suc,
         jaqz683mda,
         jaqz683pap,
         jaqz683cta,
         jaqz683ope,
         jaqz683sbo,
         jaqz683top,
         jaqz683est,
         jaqz683imp,
         jaqz683fva,
         jaqz683fvt,
         jaqz683pai,
         jaqz683tdo,
         jaqz683ndo,
         jaqz683ins,
         jaqz683ent,
         jaqz683reg,
         jaqz683ren,
         jaqz683zon,
         jaqz683dzn,
         jaqz683ana,
         jaqz683usr,
         jaqz683fep,
         jaqz683hor,
         jaqz683sdo)
      
        select a.pgcod,
               a.aomod,
               a.aosuc,
               a.aomda,
               a.aopap,
               a.aocta,
               a.aooper,
               a.aosbop,
               a.aotope,
               a.aostat,
               a.aoimp,
               a.aofval,
               a.aofvto,
               c.pepais,
               c.petdoc,
               c.pendoc,
               e.xwfprcins,
               g.jaqy327enti,
               
               d.regcod,
               d.regnom,
               d.codzon,
               d.deszon,
               f.sng001ase,
               pc_usr,
               pd_Fecpro,
               lc_hora,
               sum(g.jaqy327sdeu) deuda
          from fsd010 a, fsr008 c, regsuc d, XWF700 e, sng001 f, jaqy327 g
         where a.pgcod = 1
           and a.aostat <> 99
           and a.aofval between pd_Fecini and pd_fecfin
              
           and a.aocta = c.ctnro
           and c.ttcod = 1
           and c.cttfir = 'T'
           and a.aosuc = d.sucurs
           and e.xwfcar3 = '1'
           and e.xwfempresa = a.pgcod
           and e.xwfmodulo = a.aomod
           and e.xwfsucursal = a.aosuc
           and e.xwfmoneda = a.aomda
           and e.xwfpapel = a.aopap
           and e.xwfcuenta = a.aocta
           and e.xwfoperacion = a.aooper
           and e.xwfsubope = a.aosbop
           and e.xwftipope = a.aotope
           and e.xwfprcins = f.sng001inst
           and g.jaqy327inst = f.sng001inst
           and g.jaqy327aux4 = '1'
           and g.jaqy327esta = 'S'
         group by a.pgcod,
                  a.aomod,
                  a.aosuc,
                  a.aomda,
                  a.aopap,
                  a.aocta,
                  a.aooper,
                  a.aosbop,
                  a.aotope,
                  a.aostat,
                  a.aoimp,
                  a.aofval,
                  a.aofvto,
                  c.pepais,
                  c.petdoc,
                  c.pendoc,
                  e.xwfprcins,
                  g.jaqy327enti,
                  d.regcod,
                  d.regnom,
                  d.codzon,
                  d.deszon,
                  f.sng001ase,
                  pc_usr,
                  pd_Fecpro,
                  lc_hora;
      commit;
    exception
      when others then
        NULL;
    end;
  end Sp_cr_reporte;

  Procedure Sp_cr_reporte_bk(pd_Fecini in date,
                             pd_fecfin in date,
                             pd_Fecpro in date,
                             pc_usr    in char) is
  
    cursor creditos is
      select a.pgcod,
             a.aomod,
             a.aosuc,
             a.aomda,
             a.aopap,
             a.aocta,
             a.aooper,
             a.aosbop,
             a.aotope,
             a.aostat,
             a.aoimp,
             a.aofval,
             a.aofvto,
             c.pepais,
             c.petdoc,
             c.pendoc,
             e.xwfprcins instancia,
             f.sng001ase analista,
             /*fn_instancia_credito(v_Scmod  => a.aomod,
                                  v_Scsuc  => a.aosuc,
                                  v_Scmda  => a.aomda,
                                  v_Scpap  => a.aopap,
                                  v_Sccta  => a.aocta,
                                  v_Scoper => a.aooper,
                                  v_Scsbop => a.aosbop,
                                  v_Sctope => a.aotope) instancia,
             fn_analista_credito(v_Scmod  => a.aomod,
                                 v_Scsuc  => a.aosuc,
                                 v_Scmda  => a.aomda,
                                 v_Scpap  => a.aopap,
                                 v_Sccta  => a.aocta,
                                 v_Scoper => a.aooper,
                                 v_Scsbop => a.aosbop,
                                 v_Sctope => a.aotope) analista,*/
             d.regcod,
             d.regnom,
             d.codzon,
             d.deszon
        from fsd010 a, fsr008 c, regsuc d, XWF700 e, sng001 f
       where a.pgcod = 1
         and a.aostat <> 99
         and a.aofval between pd_Fecini and pd_fecfin
            /*and (a.aomod, a.aotope) in
            (select b.tp1nro1, b.tp1nro2
               from fst198 b
              where b.tp1cod = 1
                and b.tp1cod1 = 11129
                and b.tp1corr1 = 1
                and b.tp1corr2 = 1)*/ --mod@abr 20190613
         and a.aocta = c.ctnro
         and c.ttcod = 1
         and c.cttfir = 'T'
         and a.aosuc = d.sucurs
         and e.xwfcar3 = '1'
         and e.xwfempresa = a.pgcod
         and e.xwfmodulo = a.aomod
         and e.xwfsucursal = a.aosuc
         and e.xwfmoneda = a.aomda
         and e.xwfpapel = a.aopap
         and e.xwfcuenta = a.aocta
         and e.xwfoperacion = a.aooper
         and e.xwfsubope = a.aosbop
         and e.xwftipope = a.aotope
         and e.xwfprcins = f.sng001inst
      
      ;
  
    cursor detalle_ind(cn_ins in number) is
      select a.jaqy327enti, sum(a.jaqy327sdeu) jaqy327sdeu
        from jaqy327 a
       where a.jaqy327inst = cn_ins
         and a.jaqy327aux4 = '1'
         and a.jaqy327esta = 'S'
      --and a.jaqy327chek = '1'
       group by a.jaqy327enti;
  
    /*    cursor detalle_dep(cn_ins in number) is
    select *
      from jaqz862 a
     where a.jaqz862inst = cn_ins
       and a.jaqz862aux4 = '1'
       and a.jaqz862esta = 'S'
       and a.jaqz862chek = '1';*/
  
    lc_hora char(8);
    --ln_segmento number(3);
  begin
  
    delete from jaqz683 where jaqz683USR = pc_usr;
    commit;
  
    lc_hora := to_char(sysdate, 'HH24:MI:SS');
  
    for i in creditos loop
      /*ln_segmento := null;
      
      begin
        -- Call the procedure
        pq_cr_rte_verificasegmento.sp_cr_verifsegmevaluacion(i.instancia,
                                                             ln_segmento);
      end;
      
      if ln_segmento = 1 then*/
      --independiente
    
      for j in detalle_ind(i.instancia) loop
      
        BEGIN
          insert into jaqz683
            (jaqz683emp,
             jaqz683mod,
             jaqz683suc,
             jaqz683mda,
             jaqz683pap,
             jaqz683cta,
             jaqz683ope,
             jaqz683sbo,
             jaqz683top,
             jaqz683est,
             jaqz683imp,
             jaqz683fva,
             jaqz683fvt,
             jaqz683pai,
             jaqz683tdo,
             jaqz683ndo,
             jaqz683ins,
             jaqz683ent,
             jaqz683sdo,
             jaqz683reg,
             jaqz683ren,
             jaqz683zon,
             jaqz683dzn,
             jaqz683ana,
             jaqz683usr,
             jaqz683fep,
             jaqz683hor)
          
          values
            (i.pgcod,
             i.aomod,
             i.aosuc,
             i.aomda,
             i.aopap,
             i.aocta,
             i.aooper,
             i.aosbop,
             i.aotope,
             i.aostat,
             i.aoimp,
             i.aofval,
             i.aofvto,
             i.pepais,
             i.petdoc,
             i.pendoc,
             i.instancia,
             j.jaqy327enti,
             j.jaqy327sdeu,
             i.regcod,
             i.regnom,
             i.codzon,
             i.deszon,
             i.analista,
             pc_usr,
             pd_Fecpro,
             lc_hora);
          commit;
        EXCEPTION
          WHEN OTHERS THEN
            DBMS_OUTPUT.put_line(i.aomod || '-' || i.aocta || '-' ||
                                 i.aooper || '-' || i.instancia || '-' ||
                                 j.jaqy327enti || '-' || j.jaqy327sdeu);
        END;
      
      end loop;
      commit;
      --end if;
    
    /*if ln_segmento = 2 then
                                                                                                                                                                    --dependiente
                                                                                                                                                                  
                                                                                                                                                                    for k in detalle_dep(i.instancia) loop
                                                                                                                                                                      insert into jaqz683
                                                                                                                                                                        (jaqz683emp,
                                                                                                                                                                         jaqz683mod,
                                                                                                                                                                         jaqz683suc,
                                                                                                                                                                         jaqz683mda,
                                                                                                                                                                         jaqz683pap,
                                                                                                                                                                         jaqz683cta,
                                                                                                                                                                         jaqz683ope,
                                                                                                                                                                         jaqz683sbo,
                                                                                                                                                                         jaqz683top,
                                                                                                                                                                         jaqz683est,
                                                                                                                                                                         jaqz683imp,
                                                                                                                                                                         jaqz683fva,
                                                                                                                                                                         jaqz683fvt,
                                                                                                                                                                         jaqz683pai,
                                                                                                                                                                         jaqz683tdo,
                                                                                                                                                                         jaqz683ndo,
                                                                                                                                                                         jaqz683ins,
                                                                                                                                                                         --jaqz683coe,
                                                                                                                                                                         jaqz683ent,
                                                                                                                                                                         jaqz683sdo,
                                                                                                                                                                         jaqz683reg,
                                                                                                                                                                         jaqz683ren,
                                                                                                                                                                         jaqz683zon,
                                                                                                                                                                         jaqz683dzn,
                                                                                                                                                                         jaqz683usr,
                                                                                                                                                                         jaqz683fep,
                                                                                                                                                                         jaqz683hor)
                                                                                                                                                                      
                                                                                                                                                                      values
                                                                                                                                                                        (i.pgcod,
                                                                                                                                                                         i.aomod,
                                                                                                                                                                         i.aosuc,
                                                                                                                                                                         i.aomda,
                                                                                                                                                                         i.aopap,
                                                                                                                                                                         i.aocta,
                                                                                                                                                                         i.aooper,
                                                                                                                                                                         i.aosbop,
                                                                                                                                                                         i.aotope,
                                                                                                                                                                         i.aostat,
                                                                                                                                                                         i.aoimp,
                                                                                                                                                                         i.aofval,
                                                                                                                                                                         i.aofvto,
                                                                                                                                                                         i.pepais,
                                                                                                                                                                         i.petdoc,
                                                                                                                                                                         i.pendoc,
                                                                                                                                                                         i.instancia,
                                                                                                                                                                         k.jaqz862enti,
                                                                                                                                                                         k.jaqz862sdeu,
                                                                                                                                                                         i.regcod,
                                                                                                                                                                         i.regnom,
                                                                                                                                                                         i.codzon,
                                                                                                                                                                         i.deszon,
                                                                                                                                                                         pc_usr,
                                                                                                                                                                         pd_Fecpro,
                                                                                                                                                                         lc_hora);
                                                                                                                                                                      commit;
                                                                                                                                                                    
                                                                                                                                                                    end loop;
                                                                                                                                                                    commit;
                                                                                                                                                                  end if;*/
    
    end loop;
    commit;
  end Sp_cr_reporte_bk;

end PQ_CR_REPORTE_SEGCAMPANIA;
/

