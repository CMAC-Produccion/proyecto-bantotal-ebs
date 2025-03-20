create or replace package pq_Cr_res_PasEvaAnt is

  Procedure Sp_Cr_pasivo_EvaAnt(pn_pai in number,
                                pn_tdo in number,
                                pc_ndo in char,
                                pn_mto out number);

end pq_Cr_res_PasEvaAnt;
/

create or replace package body pq_Cr_res_PasEvaAnt is

  Procedure Sp_Cr_pasivo_EvaAnt(pn_pai in number,
                                pn_tdo in number,
                                pc_ndo in char,
                                pn_mto out number) is
  
    ld_fma       date;
    ln_emp       number(3);
    ln_mod       number(3);
    ln_suc       number(3);
    ln_mda       number(4);
    ln_pap       number(4);
    ln_cta       number(9);
    ln_ope       number(9);
    ln_sbo       number(3);
    ln_top       number(3);
    ln_instancia number(10);
    ln_tca       number(14, 8);
    ln_eva       number(10);
    ln_mtoSoles  number(17, 2);
    ln_mtoDol    number(17, 2);
  begin
  
    --obteniendo ultima instancia contabilizada
    begin
      select max(g.aofval)
        into ld_fma
        from fsd010 g
       where g.pgcod = 1
         and g.aomod in (select modulo
                           from fst111
                          where dscod = 50
                            and modulo not in (33, 200, 108))
         and g.aocta in (select f.ctnro
                           from fsr008 f
                          where f.pepais = pn_pai
                            and f.petdoc = pn_tdo
                            and f.pendoc = pc_ndo
                            and f.cttfir = 'T');
    exception
      when others then
        null;
    end;
  
    begin
      select g.pgcod,
             g.aomod,
             g.aosuc,
             g.aomda,
             g.aopap,
             g.aocta,
             g.aooper,
             g.aosbop,
             g.aotope
        into ln_emp,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top
        from fsd010 g
       where g.pgcod = 1
         and g.aomod in (select modulo
                           from fst111
                          where dscod = 50
                            and modulo not in (33, 200, 108))
         and g.aocta in (select f.ctnro
                           from fsr008 f
                          where f.pepais = pn_pai
                            and f.petdoc = pn_tdo
                            and f.pendoc = pc_ndo
                            and f.cttfir = 'T')
         and g.aofval = ld_fma
         and rownum = 1;
    exception
      when others then
        null;
    end;
  
    begin
      ln_instancia := fn_instancia_credito(v_Scmod  => ln_mod,
                                           v_Scsuc  => ln_suc,
                                           v_Scmda  => ln_mda,
                                           v_Scpap  => ln_pap,
                                           v_Sccta  => ln_cta,
                                           v_Scoper => ln_ope,
                                           v_Scsbop => ln_sbo,
                                           v_Sctope => ln_top);
    end;
  
    --informacion evaluacion
  
    begin
      select a.sng120tcbi
        into ln_tca
        from sng120 a
       where a.sng120ins = ln_instancia
         and a.sng120tsk = 'EVALUACION';
    exception
      when others then
        null;
    end;
  
    begin
      select a.sng021eval
        into ln_eva
        from sng021 a
       where a.sng021sol = ln_instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select b.sng023mto
        into ln_mtoSoles
        from sng023 b
       where b.sng021eval = ln_eva
         and b.sng026cod = 65;
    exception
      when others then
        null;
    end;
  
    begin
      select b.sng023mto
        into ln_mtoDol
        from sng023 b
       where b.sng021eval = ln_eva
         and b.sng026cod = 565;
    exception
      when others then
        null;
    end;
  
    pn_mto := nvl(ln_mtoSoles, 0) + (nvl(ln_mtoDol, 0) * nvl(ln_tca, 0));
  
  end Sp_Cr_pasivo_EvaAnt;

end pq_Cr_res_PasEvaAnt;
/

