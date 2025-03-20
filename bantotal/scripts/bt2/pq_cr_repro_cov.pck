create or replace package PQ_CR_REPRO_COV is

  -- Author  : CHERNANDEZ/DCASTRO
  -- Created : 20/03/2020
  -- Purpose :
  -- MODIFCADO : JUAN  
  -- Fecha:    
  -- MODIFCADO : CHERNANDEZ 
  -- Fecha:    12/07/2020
  -- Public type declarations
  --Autor modificacion: jrodriguej 
  --fecha modificacion: 26/08/2020 
  --Descripcion modificacion: se retira el procedimiento sp_inserta_hsd010  
  --Autor modificacion: jrodriguej 
  --fecha modificacion: 07/02/2021
  --Descripcion modificacion: se agregó el paquete sp_backup_ini_mype  

  Procedure Sp_Actualiza_FSD601(p_n_emp    in number,
                                p_n_mod    in number,
                                p_n_suc    in number,
                                p_n_mda    in number,
                                p_n_pap    in number,
                                p_n_cta    in number,
                                p_n_ope    in number,
                                p_n_sbo    in number,
                                p_n_top    in number,
                                p_n_grupo  in number,
                                p_d_fecpro in date);
  Procedure Sp_Actualiza_FSD611(p_n_emp    in number,
                                p_n_mod    in number,
                                p_n_suc    in number,
                                p_n_mda    in number,
                                p_n_pap    in number,
                                p_n_cta    in number,
                                p_n_ope    in number,
                                p_n_sbo    in number,
                                p_n_top    in number,
                                p_n_grupo  in number,
                                p_d_fecpro in date);
  Procedure Sp_Actualiza_FSD010(p_n_emp in number,
                                p_n_mod in number,
                                p_n_suc in number,
                                p_n_mda in number,
                                p_n_pap in number,
                                p_n_cta in number,
                                p_n_ope in number,
                                p_n_sbo in number,
                                p_n_top in number,
                                p_n_cor in number,
                                p_d_fep in date);
  Procedure Sp_Actualiza_FSD011(p_n_emp    in number,
                                p_n_mod    in number,
                                p_n_suc    in number,
                                p_n_mda    in number,
                                p_n_pap    in number,
                                p_n_cta    in number,
                                p_n_ope    in number,
                                p_n_sbo    in number,
                                p_n_top    in number,
                                p_n_grupo  in number,
                                p_d_fecpro in date);

  Procedure Sp_verifica602(pn_emp    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_ope    in number,
                           pn_sbo    in number,
                           pn_top    in number,
                           pd_fec    in date,
                           lc_cambia out char);

  Procedure Sp_Revierte602_612(pn_emp in number,
                               pn_mod in number,
                               pn_suc in number,
                               pn_mda in number,
                               pn_pap in number,
                               pn_cta in number,
                               pn_ope in number,
                               pn_sbo in number,
                               pn_top in number,
                               pn_gru in number,
                               pd_fep in date,
                               pc_usr in char,
                               pd_fec in date);

  Procedure sp_backup_ini(pd_fep in date,
                          pn_cor in number,
                          pn_emp in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number,
                          pd_fec in date,
                          pc_hor in varchar2,
                          pc_usu in varchar2,
                          PC_EST OUT varchar2);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                          
  Procedure sp_backup_ini_mype(
                          pn_emp in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number,
                          pd_fec in date,
                          pc_hor in varchar2,
                          pc_usu in varchar2,
                          PC_EST OUT varchar2,
                          pd_fep out date,   --- jrodriguej 09/07/2021 salida de fecha en AQPB088
                          pn_cor out number  --- jrodriguej 09/07/2021 salida de corr en AQPB088                          
                          );  
                          
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                          
  Procedure sp_actualizar_aqpb088(pn_emp in number,
                               pn_mod in number,
                               pn_suc in number,
                               pn_mda in number,
                               pn_pap in number,
                               pn_cta in number,
                               pn_ope in number,
                               pn_sbo in number,
                               pn_top in number);                              

end PQ_CR_REPRO_COV;
/

create or replace package body PQ_CR_REPRO_COV is

  Procedure Sp_Actualiza_FSD601(p_n_emp    in number,
                                p_n_mod    in number,
                                p_n_suc    in number,
                                p_n_mda    in number,
                                p_n_pap    in number,
                                p_n_cta    in number,
                                p_n_ope    in number,
                                p_n_sbo    in number,
                                p_n_top    in number,
                                p_n_grupo  in number,
                                p_d_fecpro in date) is
    cursor creditos is
      select b.jaqz519emp pgcod,
             b.jaqz519mod aomod,
             b.jaqz519suc aosuc,
             b.jaqz519mda aomda,
             b.jaqz519pap aopap,
             b.jaqz519cta aocta,
             b.jaqz519ope aooper,
             b.jaqz519sbo aosbop,
             b.jaqz519top aotope,
             b.jaqz519pdi
        from jaqz519 b
       where b.jaqz519emp = p_n_emp
         and b.jaqz519mod = p_n_mod
         and b.jaqz519suc = p_n_suc
         and b.jaqz519mda = p_n_mda
         and b.jaqz519pap = p_n_pap
         and b.jaqz519cta = p_n_cta
         and b.jaqz519ope = p_n_ope
         and b.jaqz519sbo = p_n_sbo
         and b.jaqz519top = p_n_top
         and b.jaqz519ind = 'S'
         and b.jaqz519grp = p_n_grupo
         and b.jaqz519fep = p_d_fecpro;
  
    ld_fecpxv date;
  
    cursor calendario(pn_emp in number,
                      pn_mod in number,
                      pn_suc in number,
                      pn_mda in number,
                      pn_pap in number,
                      pn_cta in number,
                      pn_ope in number,
                      pn_sbo in number,
                      pn_top in number,
                      pd_fec in date) is
      select *
        from fsd601 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.d601co = 'S'
         and (a.ppcap + a.ppint) <> 0
         and a.ppfpag >= pd_fec
       order by ppfpag desc;
  
    cursor calendario_asc(pn_emp in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number,
                          pd_fec in date) is
      select *
        from fsd601 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.d601co = 'S'
         and (a.ppcap + a.ppint) <> 0
         and a.ppfpag >= pd_fec
       order by ppfpag asc;
  
    type c_list is varray(999) of fsd601.ppfpag%type;
    name_list c_list := c_list();
    counter   number := 0;
    ln_cont   number;
    ln_int    number;
  
    ld_ppfpag     date;
    ld_ppfval     date;
    ld_ppfvto     date;
    lc_hab_ppfpag char(1);
    lc_hab_ppfval char(1);
    lc_hab_ppfvto char(1);
    ld_ppfpag_F   date;
    ld_ppfval_F   date;
    ld_ppfvto_F   date;
    ld_ppfpag_ini date;
  
    ln_countTot number;
    ln_contAF   number;
  
    --PPFVAL
    type c_list_FV is varray(999) of fsd601.ppfval%type;
    name_list_FV c_list_FV := c_list_FV();
    counter_FV   number := 0;
    ln_contFV    number;
    ln_intFV     number;
    --PPFVAL
  
    --mod@abr 20170403
    ln_numpdi number;
    --mod@abr 20170403
  
  BEGIN
  
    for i in creditos loop
      ld_fecpxv     := null;
      ld_ppfpag_ini := null;
    
      begin
        select /*+ parallel(n,2,1)*/
         min(n.ppfpag)
          into ld_ppfpag_ini
          from fsd601 n
         where n.pgcod = i.pgcod
           and n.ppcta = i.aocta
           and n.ppmda = i.aomda
           and n.ppsuc = i.aosuc
           and n.pppap = i.aopap
           and n.ppoper = i.aooper
           and n.ppsbop = i.aosbop
           and n.pptope = i.aotope
           and n.ppmod = i.aomod
           and n.d601co = 'S'
           and (n.ppcap + n.ppint) <> 0;
      
      exception
        when others then
          null;
      end;
    
      begin
        select /*+ parallel(n,2,1)*/
         min(n.ppfpag)
          into ld_fecpxv
          from fsd601 n
         where n.pgcod = i.pgcod
           and n.ppcta = i.aocta
           and n.ppmda = i.aomda
           and n.ppsuc = i.aosuc
           and n.pppap = i.aopap
           and n.ppoper = i.aooper
           and n.ppsbop = i.aosbop
           and n.pptope = i.aotope
           and n.ppmod = i.aomod
           and n.d601co = 'S'
           and (n.ppcap + n.ppint) <> 0
           and not exists (select /*+ parallel(o,2,1)*/
                 ppmod, ppcta, ppoper, pptope, ppfpag
                  from fsd602 o
                 where o.pgcod = n.pgcod
                   and o.ppmod = n.ppmod
                   and o.ppsuc = n.ppsuc
                   and o.ppmda = n.ppmda
                   and o.pppap = n.pppap
                   and o.ppcta = n.ppcta
                   and o.ppoper = n.ppoper
                   and o.ppsbop = n.ppsbop
                   and o.pptope = n.pptope
                   and o.ppfpag = n.ppfpag
                   and o.pp1stat = 'T'
                   and o.d602co = 'S'
                   and (o.pp1cap + o.pp1int) <> 0);
      exception
        when others then
          null;
      end;
    
      counter     := 0;
      ln_countTot := 0;
      name_list   := c_list();
      for j in calendario_asc(i.pgcod,
                              i.aomod,
                              i.aosuc,
                              i.aomda,
                              i.aopap,
                              i.aocta,
                              i.aooper,
                              i.aosbop,
                              i.aotope,
                              ld_fecpxv) loop
      
        counter := counter + 1;
        name_list.extend;
        name_list(counter) := j.ppfpag;
      
      end loop;
      ln_countTot := counter;
      ln_cont     := 0;
      ln_contAF   := 0;
    
      --mod@abr 20170403
      ln_numpdi := i.jaqz519pdi;
    
      for k in calendario(i.pgcod,
                          i.aomod,
                          i.aosuc,
                          i.aomda,
                          i.aopap,
                          i.aocta,
                          i.aooper,
                          i.aosbop,
                          i.aotope,
                          ld_fecpxv) loop
        ln_cont := ln_cont + 1;
      
        --if ln_cont < ln_numpdi + 1 then
      
        ld_ppfpag := add_months(k.ppfpag, ln_numpdi); --MOD@ABR 20170403
        ld_ppfval := add_months(k.ppfval, ln_numpdi); --MOD@ABR 20170403
        ld_ppfvto := add_months(k.ppfvto, ln_numpdi); --MOD@ABR 20170403
      
        --verificar si es dia habil
        begin
          select a.fhabil
            into lc_hab_ppfpag
            from fst028 a, fst001 b
           where a.calcod = b.calcod
             and a.ffecha = ld_ppfpag
             and b.sucurs = i.aosuc;
        exception
          when others then
            null;
        end;
      
        if lc_hab_ppfpag = 'N' then
          begin
            select min(a.ffecha)
              into ld_ppfpag_F
              from fst028 a, fst001 b
             where a.calcod = b.calcod
               and a.ffecha > ld_ppfpag
               and b.sucurs = i.aosuc
               and a.fhabil = 'S';
          exception
            when others then
              null;
          end;
        
        else
          ld_ppfpag_F := ld_ppfpag;
        
        end if;
      
        begin
          select a.fhabil
            into lc_hab_ppfval
            from fst028 a, fst001 b
           where a.calcod = b.calcod
             and a.ffecha = ld_ppfval
             and b.sucurs = i.aosuc;
        exception
          when others then
            null;
        end;
      
        if lc_hab_ppfval = 'N' then
          begin
            select min(a.ffecha)
              into ld_ppfval_F
              from fst028 a, fst001 b
             where a.calcod = b.calcod
               and a.ffecha > ld_ppfval
               and b.sucurs = i.aosuc
               and a.fhabil = 'S';
          exception
            when others then
              null;
          end;
        
        else
          ld_ppfval_F := ld_ppfval;
        end if;
      
        begin
          select a.fhabil
            into lc_hab_ppfvto
            from fst028 a, fst001 b
           where a.calcod = b.calcod
             and a.ffecha = ld_ppfvto
             and b.sucurs = i.aosuc;
        exception
          when others then
            null;
        end;
      
        if lc_hab_ppfpag = 'N' then
          begin
            select min(a.ffecha)
              into ld_ppfvto_F
              from fst028 a, fst001 b
             where a.calcod = b.calcod
               and a.ffecha > ld_ppfvto
               and b.sucurs = i.aosuc
               and a.fhabil = 'S';
          exception
            when others then
              null;
          end;
        
        else
          ld_ppfvto_F := ld_ppfvto;
        end if;
        --dbms_output.put_line('0-'||k.ppcta||'-'||k.ppoper||'-'||ld_ppfpag_F||'-'||ld_ppfval_F||'-'||ld_ppfvto_F||'-'||k.ppfpag); 
        begin
          --chernandez
          --if ld_ppfpag_ini <> k.ppfpag then
          if ln_countTot <> ln_cont then
          
            update fsd601 a
               set a.ppfpag = ld_ppfpag_F,
                   a.ppfval = ld_ppfval_F,
                   a.ppfvto = ld_ppfvto_F,
                   a.pptipo = 'F'
             where a.pgcod = k.pgcod
               and a.ppmod = k.ppmod
               and a.ppsuc = k.ppsuc
               and a.ppmda = k.ppmda
               and a.pppap = k.pppap
               and a.ppcta = k.ppcta
               and a.ppoper = k.ppoper
               and a.ppsbop = k.ppsbop
               and a.pptope = k.pptope
               and a.ppfpag = k.ppfpag;
          else
            update fsd601 a
               set a.ppfpag = ld_ppfpag_F,
                   a.ppfvto = ld_ppfvto_F,
                   a.pptipo = 'F'
             where a.pgcod = k.pgcod
               and a.ppmod = k.ppmod
               and a.ppsuc = k.ppsuc
               and a.ppmda = k.ppmda
               and a.pppap = k.pppap
               and a.ppcta = k.ppcta
               and a.ppoper = k.ppoper
               and a.ppsbop = k.ppsbop
               and a.pptope = k.pptope
               and a.ppfpag = k.ppfpag;
          end if;
        end;
      
      /*else
                                                                                
                                                                                  ln_contAF := ln_contAF + 1;
                                                                                  ln_int    := counter;
                                                                                
                                                                                  while ln_int = counter loop
                                                                                    ld_ppfpag_F := name_list(ln_int);
                                                                                    ln_int      := ln_int - 1;
                                                                                  
                                                                                    begin
                                                                                      update fsd601 a
                                                                                         set a.ppfpag = ld_ppfpag_F,
                                                                                             a.ppfvto = ld_ppfpag_F,
                                                                                             a.pptipo = 'F'
                                                                                       where a.pgcod = k.pgcod
                                                                                         and a.ppmod = k.ppmod
                                                                                         and a.ppsuc = k.ppsuc
                                                                                         and a.ppmda = k.ppmda
                                                                                         and a.pppap = k.pppap
                                                                                         and a.ppcta = k.ppcta
                                                                                         and a.ppoper = k.ppoper
                                                                                         and a.ppsbop = k.ppsbop
                                                                                         and a.pptope = k.pptope
                                                                                         and a.ppfpag = k.ppfpag;
                                                                                       end;
                                                                                  end loop;
                                                                                  counter := counter - 1;
                                                                                
                                                                                  If (ln_countTot - ln_contAF) = ln_numpdi then
                                                                                    exit;
                                                                                  end if;
                                                                                
                                                                                end if;*/
      
      end loop;
    
      --PPFVAL
      /*
      counter_FV   := 0;
      name_list_FV := c_list_FV();
      for j in calendario_asc(i.pgcod,
                              i.aomod,
                              i.aosuc,
                              i.aomda,
                              i.aopap,
                              i.aocta,
                              i.aooper,
                              i.aosbop,
                              i.aotope,
                              ld_fecpxv) loop
      
        counter_FV := counter_FV + 1;
        name_list_FV.extend;
        name_list_FV(counter_FV) := j.ppfpag;
      
      end loop;
      
      ln_contFV := 0;
      
      ln_intFV := 1;
      For g in calendario_asc(i.pgcod,
                              i.aomod,
                              i.aosuc,
                              i.aomda,
                              i.aopap,
                              i.aocta,
                              i.aooper,
                              i.aosbop,
                              i.aotope,
                              ld_fecpxv) loop
        ln_contFV := ln_contFV + 1;
      
        if ln_contFV >= 1 then
          counter_FV := ln_intFV;
          while ln_intFV = counter_FV loop
            ld_ppfval_F := name_list_FV(ln_intFV);
            counter_FV := counter_FV - 1;
            begin
              if ld_ppfpag_ini <> g.ppfval then
                update fsd601 a
                   set a.ppfval = ld_ppfval_F
                 where a.pgcod = g.pgcod
                   and a.ppmod = g.ppmod
                   and a.ppsuc = g.ppsuc
                   and a.ppmda = g.ppmda
                   and a.pppap = g.pppap
                   and a.ppcta = g.ppcta
                   and a.ppoper = g.ppoper
                   and a.ppsbop = g.ppsbop
                   and a.pptope = g.pptope
                   and a.ppfpag = g.ppfpag;
              end if;
            end;
          
          end loop;
          ln_intFV := ln_intFV + 1;
        end if;
      end loop;*/
      --PPFVAL
      update jaqz519 A
         set a.JAQZ519PRO601 = 'S'
       where a.jaqz519emp = i.pgcod
         and a.jaqz519mod = i.aomod
         and a.jaqz519suc = i.aosuc
         and a.jaqz519mda = i.aomda
         and a.jaqz519pap = i.aopap
         and a.jaqz519cta = i.aocta
         and a.jaqz519ope = i.aooper
         and a.jaqz519sbo = i.aosbop
         and a.jaqz519top = i.aotope
         and a.jaqz519grp = p_n_grupo
         and a.jaqz519fep = p_d_fecpro;
    
    END LOOP;
    commit;
  END Sp_Actualiza_FSD601;

  Procedure Sp_Actualiza_FSD611(p_n_emp    in number,
                                p_n_mod    in number,
                                p_n_suc    in number,
                                p_n_mda    in number,
                                p_n_pap    in number,
                                p_n_cta    in number,
                                p_n_ope    in number,
                                p_n_sbo    in number,
                                p_n_top    in number,
                                p_n_grupo  in number,
                                p_d_fecpro in date) is
    cursor creditos is
    
      select b.jaqz519emp pgcod,
             b.jaqz519mod aomod,
             b.jaqz519suc aosuc,
             b.jaqz519mda aomda,
             b.jaqz519pap aopap,
             b.jaqz519cta aocta,
             b.jaqz519ope aooper,
             b.jaqz519sbo aosbop,
             b.jaqz519top aotope,
             b.jaqz519pdi
        from jaqz519 b
       where b.jaqz519emp = p_n_emp
         and b.jaqz519mod = p_n_mod
         and b.jaqz519suc = p_n_suc
         and b.jaqz519mda = p_n_mda
         and b.jaqz519pap = p_n_pap
         and b.jaqz519cta = p_n_cta
         and b.jaqz519ope = p_n_ope
         and b.jaqz519sbo = p_n_sbo
         and b.jaqz519top = p_n_top
         and b.jaqz519ind = 'S'
         and b.jaqz519grp = p_n_grupo
         and b.jaqz519fep = p_d_fecpro;
  
    ld_fecpxv date;
  
    cursor calendario(pn_emp in number,
                      pn_mod in number,
                      pn_suc in number,
                      pn_mda in number,
                      pn_pap in number,
                      pn_cta in number,
                      pn_ope in number,
                      pn_sbo in number,
                      pn_top in number,
                      pd_fec in date) is
      select *
        from fsd611 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag >= pd_fec
       order by ppfpag desc;
  
    cursor calendario_asc(pn_emp in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number,
                          pd_fec in date) is
      select *
        from fsd611 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag >= pd_fec
       order by ppfpag asc;
  
    type c_list is varray(999) of fsd601.ppfpag%type;
    name_list c_list := c_list();
    counter   number := 0;
    ln_cont   number;
    ln_int    number;
  
    ld_ppfpag date;
  
    lc_hab_ppfpag char(1);
  
    ld_ppfpag_F date;
  
    ln_countTot number;
    ln_contAF   number;
  
    --mod@abr 20170403
    ld_fecha  date;
    ln_numpdi number;
    --mod@abr 20170403
  
  BEGIN
  
    for i in creditos loop
      ld_fecpxv := null;
    
      begin
        select /*+ parallel(n,2,1)*/
         min(n.ppfpag)
          into ld_fecpxv
          from fsd611 n
         where n.pgcod = i.pgcod
           and n.ppcta = i.aocta
           and n.ppmda = i.aomda
           and n.ppsuc = i.aosuc
           and n.pppap = i.aopap
           and n.ppoper = i.aooper
           and n.ppsbop = i.aosbop
           and n.pptope = i.aotope
           and n.ppmod = i.aomod
              --and n.d601co = 'S'
              --and (n.ppcap+n.ppint)<>0
           and not exists (select /*+ parallel(o,2,1)*/
                 ppmod, ppcta, ppoper, pptope, ppfpag
                  from fsd602 o
                 where o.pgcod = n.pgcod
                   and o.ppmod = n.ppmod
                   and o.ppsuc = n.ppsuc
                   and o.ppmda = n.ppmda
                   and o.pppap = n.pppap
                   and o.ppcta = n.ppcta
                   and o.ppoper = n.ppoper
                   and o.ppsbop = n.ppsbop
                   and o.pptope = n.pptope
                   and o.ppfpag = n.ppfpag
                   and o.pp1stat = 'T'
                   and o.d602co = 'S'
                   and (o.pp1cap + o.pp1int) <> 0);
      exception
        when others then
          null;
      end;
      --dbms_output.put_line('ld_fecpxv-'||ld_fecpxv ); 
      counter     := 0;
      ln_countTot := 0;
      name_list   := c_list();
      for j in calendario_asc(i.pgcod,
                              i.aomod,
                              i.aosuc,
                              i.aomda,
                              i.aopap,
                              i.aocta,
                              i.aooper,
                              i.aosbop,
                              i.aotope,
                              ld_fecpxv) loop
      
        counter := counter + 1;
        name_list.extend;
        name_list(counter) := j.ppfpag;
        --dbms_output.put_line('Customer('||counter ||'):'||name_list(counter)); 
      
      end loop;
      ln_countTot := counter;
      ln_cont     := 0;
      ln_contAF   := 0;
    
      --mod@abr 20170403    
    
      ln_numpdi := i.jaqz519pdi;
      --mod@abr 20170403
    
      for k in calendario(i.pgcod,
                          i.aomod,
                          i.aosuc,
                          i.aomda,
                          i.aopap,
                          i.aocta,
                          i.aooper,
                          i.aosbop,
                          i.aotope,
                          ld_fecpxv) loop
        ln_cont := ln_cont + 1;
      
        --if ln_cont < ln_numpdi + 1 then
        --mod@abr 20170403
      
        ld_ppfpag := add_months(k.ppfpag, ln_numpdi); --mod@abr 20170403
      
        --verificar si es dia habil
        begin
          select a.fhabil
            into lc_hab_ppfpag
            from fst028 a, fst001 b
           where a.calcod = b.calcod
             and a.ffecha = ld_ppfpag
             and b.sucurs = i.aosuc;
        exception
          when others then
            null;
        end;
      
        if lc_hab_ppfpag = 'N' then
          begin
            select min(a.ffecha)
              into ld_ppfpag_F
              from fst028 a, fst001 b
             where a.calcod = b.calcod
               and a.ffecha > ld_ppfpag
               and b.sucurs = i.aosuc
               and a.fhabil = 'S';
          exception
            when others then
              null;
          end;
        
        else
          ld_ppfpag_F := ld_ppfpag;
        
        end if;
      
        begin
          update fsd611 a
             set a.ppfpag = ld_ppfpag_F, a.pptipo = 'F'
           where a.pgcod = k.pgcod
             and a.ppmod = k.ppmod
             and a.ppsuc = k.ppsuc
             and a.ppmda = k.ppmda
             and a.pppap = k.pppap
             and a.ppcta = k.ppcta
             and a.ppoper = k.ppoper
             and a.ppsbop = k.ppsbop
             and a.pptope = k.pptope
             and a.ppfpag = k.ppfpag;
        
        end;
      
      /*else
                                                                                
                                                                                  ln_contAF := ln_contAF + 1;
                                                                                  ln_int    := counter;
                                                                                
                                                                                  while ln_int = counter loop
                                                                                    ld_ppfpag_F := name_list(ln_int);
                                                                                    ln_int      := ln_int - 1;
                                                                                  
                                                                                    begin
                                                                                      update fsd611 a
                                                                                         set a.ppfpag = ld_ppfpag_F, a.pptipo = 'F'
                                                                                       where a.pgcod = k.pgcod
                                                                                         and a.ppmod = k.ppmod
                                                                                         and a.ppsuc = k.ppsuc
                                                                                         and a.ppmda = k.ppmda
                                                                                         and a.pppap = k.pppap
                                                                                         and a.ppcta = k.ppcta
                                                                                         and a.ppoper = k.ppoper
                                                                                         and a.ppsbop = k.ppsbop
                                                                                         and a.pptope = k.pptope
                                                                                         and a.ppfpag = k.ppfpag;
                                                                                    
                                                                                    end;
                                                                                  end loop;
                                                                                  counter := counter - 1;
                                                                                
                                                                                  If (ln_countTot - ln_contAF) = ln_numpdi then
                                                                                    exit;
                                                                                  end if;
                                                                                
                                                                                end if;*/
      
      end loop;
    
      update jaqz519 A
         set a.JAQZ519PRO611 = 'S'
       where a.jaqz519emp = i.pgcod
         and a.jaqz519mod = i.aomod
         and a.jaqz519suc = i.aosuc
         and a.jaqz519mda = i.aomda
         and a.jaqz519pap = i.aopap
         and a.jaqz519cta = i.aocta
         and a.jaqz519ope = i.aooper
         and a.jaqz519sbo = i.aosbop
         and a.jaqz519top = i.aotope
         and a.jaqz519grp = p_n_grupo
         and a.jaqz519fep = p_d_fecpro;
    
    END LOOP;
    commit;
  END Sp_Actualiza_FSD611;

  Procedure Sp_Actualiza_FSD010(p_n_emp in number,
                                p_n_mod in number,
                                p_n_suc in number,
                                p_n_mda in number,
                                p_n_pap in number,
                                p_n_cta in number,
                                p_n_ope in number,
                                p_n_sbo in number,
                                p_n_top in number,
                                p_n_cor in number,
                                p_d_fep in date) is
  
    cursor creditos is
      select *
        from jaqz520_010C a
       where a.fec = p_d_fep
         and a.cor = p_n_cor
      /* and a.pgcod = pn_emp
      and a.aomod = pn_mod
      and a.aosuc = pn_suc
      and a.aomda = pn_mda
      and a.aopap = pn_pap
      and a.aocta = pn_cta
      and a.aooper = pn_ope
      and a.aosbop = pn_sbo
      and a.aotope = p_n_top*/
      ;
  
    ld_fecvto date;
  begin
  
    for i in creditos loop
    
      begin
        select max(ppfpag)
          into ld_fecvto
          from fsd601 a
         where a.pgcod = i.pgcod
           and a.ppmod = i.aomod
           and a.ppsuc = i.aosuc
           and a.ppmda = i.aomda
           and a.pppap = i.aopap
           and a.ppcta = i.aocta
           and a.ppoper = i.aooper
           and a.ppsbop = i.aosbop
           and a.pptope = i.aotope
           and d601co = 'S';
      exception
        when others then
          null;
      end;
    
      update fsd010
         set aofvto = ld_fecvto, aopzo = ld_fecvto - i.aofval --mod@abr20170405
       where pgcod = i.pgcod
         and aomod = i.aomod
         and aosuc = i.aosuc
         and aomda = i.aomda
         and aopap = i.aopap
         and aocta = i.aocta
         and aooper = i.aooper
         and aosbop = i.aosbop
         and aotope = i.aotope;
      commit;
    
    end loop;
    commit;
  end Sp_Actualiza_FSD010;

  Procedure Sp_Actualiza_FSD011(p_n_emp    in number,
                                p_n_mod    in number,
                                p_n_suc    in number,
                                p_n_mda    in number,
                                p_n_pap    in number,
                                p_n_cta    in number,
                                p_n_ope    in number,
                                p_n_sbo    in number,
                                p_n_top    in number,
                                p_n_grupo  in number,
                                p_d_fecpro in date) is
    cursor creditos is
      select a.pgcod,
             a.scsuc,
             a.scmda,
             a.scpap,
             a.sccta,
             a.scoper,
             a.scsbop,
             a.sctope,
             a.scmod,
             b.jaqz519pzo,
             a.scfval --mod@abr 20170405
        from fsd011 a, jaqz519 b
       where a.pgcod = b.jaqz519emp
         and a.scsuc = b.jaqz519suc
         and a.scmda = b.jaqz519mda
         and a.scpap = b.jaqz519pap
         and a.sccta = b.jaqz519cta
         and a.scoper = b.jaqz519ope
         and a.scsbop = b.jaqz519sbo
         and a.sctope = b.jaqz519top
         and a.scmod = b.jaqz519mod
         and a.scfvto is not null
         and b.jaqz519emp = p_n_emp
         and b.jaqz519mod = p_n_mod
         and b.jaqz519suc = p_n_suc
         and b.jaqz519mda = p_n_mda
         and b.jaqz519pap = p_n_pap
         and b.jaqz519cta = p_n_cta
         and b.jaqz519ope = p_n_ope
         and b.jaqz519sbo = p_n_sbo
         and b.jaqz519top = p_n_top
         and b.jaqz519ind = 'S'
         and b.jaqz519grp = p_n_grupo
         and b.jaqz519fep = p_d_fecpro;
    ld_fecvto date;
  
  begin
    for i in creditos loop
    
      begin
        select max(ppfpag)
          into ld_fecvto
          from fsd601 a
         where a.pgcod = i.pgcod
           and a.ppmod = i.scmod
           and a.ppsuc = i.scsuc
           and a.ppmda = i.scmda
           and a.pppap = i.scpap
           and a.ppcta = i.sccta
           and a.ppoper = i.scoper
           and a.ppsbop = i.scsbop
           and a.pptope = i.sctope
           and d601co = 'S';
      exception
        when others then
          null;
      end;
    
      update fsd011
         set scfvto = ld_fecvto, scpzo = ld_fecvto - i.scfval --mod@abr 20170405
       where pgcod = i.pgcod
         and scsuc = i.scsuc
         and scmda = i.scmda
         and scpap = i.scpap
         and sccta = i.sccta
         and scoper = i.scoper
         and scsbop = i.scsbop
         and sctope = i.sctope
         and scmod = i.scmod;
    
      --commit;  
    
      update jaqz519 A
         set a.JAQZ519PRO11 = 'S'
       where a.jaqz519emp = i.pgcod
         and a.jaqz519mod = i.scmod
         and a.jaqz519suc = i.scsuc
         and a.jaqz519mda = i.scmda
         and a.jaqz519pap = i.scpap
         and a.jaqz519cta = i.sccta
         and a.jaqz519ope = i.scoper
         and a.jaqz519sbo = i.scsbop
         and a.jaqz519top = i.sctope
         and a.jaqz519grp = p_n_grupo
         and a.jaqz519fep = p_d_fecpro;
    
    --COMMIT;
    
    end loop;
    commit;
  end Sp_Actualiza_FSD011;

  Procedure Sp_verifica602(pn_emp    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_ope    in number,
                           pn_sbo    in number,
                           pn_top    in number,
                           pd_fec    in date,
                           lc_cambia out char) is
  
  begin
    lc_cambia := 'N';
    begin
      select 'S'
        into lc_cambia
        from fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag >= pd_fec
         and a.pptipo = 'F'
         and rownum = 1;
    exception
      when others then
        lc_cambia := 'N';
    end;
  end Sp_verifica602;

  Procedure Sp_Revierte602_612(pn_emp in number,
                               pn_mod in number,
                               pn_suc in number,
                               pn_mda in number,
                               pn_pap in number,
                               pn_cta in number,
                               pn_ope in number,
                               pn_sbo in number,
                               pn_top in number,
                               pn_gru in number,
                               pd_fep in date,
                               pc_usr in char,
                               pd_fec in date) is
  
    cursor calendario is
      select *
        from fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.d602co = 'S'
       order by ppfpag;
    ld_fecant date;
  
  begin
    for i in calendario loop
      begin
        select a.jaqz522fan
          into ld_fecant
          from jaqz522 a
         where a.jaqz522emp = i.pgcod
           and a.jaqz522mod = i.ppmod
           and a.jaqz522suc = i.ppsuc
           and a.jaqz522mda = i.ppmda
           and a.jaqz522pap = i.pppap
           and a.jaqz522cta = i.ppcta
           and a.jaqz522ope = i.ppoper
           and a.jaqz522sbo = i.ppsbop
           and a.jaqz522top = i.pptope
           and a.jaqz522fac = i.ppfpag
           and a.jaqz522usr = pc_usr
           and a.jaqz522fep = pd_fec;
      exception
        when others then
          null;
      end;
    
      update fsd602 a
         set a.ppfpag = ld_fecant, a.pptipo = 'M'
       where a.pgcod = i.pgcod
         and a.ppmod = i.ppmod
         and a.ppsuc = i.ppsuc
         and a.ppmda = i.ppmda
         and a.pppap = i.pppap
         and a.ppcta = i.ppcta
         and a.ppoper = i.ppoper
         and a.ppsbop = i.ppsbop
         and a.pptope = i.pptope
         and a.ppfpag = i.ppfpag
         and a.d602co = 'S';
    
      --Actualiza si se revertio FSD602
      UPDATE jaqz519 a
         set a.jaqz519r602 = 'S'
       where a.jaqz519emp = i.pgcod
         and a.jaqz519mod = i.ppmod
         and a.jaqz519suc = i.ppsuc
         and a.jaqz519mda = i.ppmda
         and a.jaqz519pap = i.pppap
         and a.jaqz519cta = i.ppcta
         and a.jaqz519ope = i.ppoper
         and a.jaqz519sbo = i.ppsbop
         and a.jaqz519top = i.pptope
         and a.jaqz519grp = pn_gru
         and a.jaqz519fep = pd_fep;
    
      update fsd612 a
         set a.ppfpag = ld_fecant, a.pptipo = 'M'
       where a.pgcod = i.pgcod
         and a.ppmod = i.ppmod
         and a.ppsuc = i.ppsuc
         and a.ppmda = i.ppmda
         and a.pppap = i.pppap
         and a.ppcta = i.ppcta
         and a.ppoper = i.ppoper
         and a.ppsbop = i.ppsbop
         and a.pptope = i.pptope
         and a.ppfpag = i.ppfpag;
    
      --Actualiza si se revertio FSD612
      UPDATE jaqz519 a
         set a.jaqz519r612 = 'S'
       where a.jaqz519emp = i.pgcod
         and a.jaqz519mod = i.ppmod
         and a.jaqz519suc = i.ppsuc
         and a.jaqz519mda = i.ppmda
         and a.jaqz519pap = i.pppap
         and a.jaqz519cta = i.ppcta
         and a.jaqz519ope = i.ppoper
         and a.jaqz519sbo = i.ppsbop
         and a.jaqz519top = i.pptope
         and a.jaqz519grp = pn_gru
         and a.jaqz519fep = pd_fep;
      commit;
    end loop;
    commit;
  end Sp_Revierte602_612;

  Procedure sp_backup_ini(pd_fep in date,
                          pn_cor in number,
                          pn_emp in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number,
                          pd_fec in date,
                          pc_hor in varchar2,
                          pc_usu in varchar2,
                          PC_EST OUT varchar2) is
    pc_usuChar Character(10);
  
    pc_coderr varchar2(100);
    pc_msgerr varchar2(100);
  
    /*
    AQPA004CV    Maestro
    jaqz520_010C FSD010
    JAQZ520_011C FSD011
    JAQZ520_601C FSD601
    JAQZ520_611C FSD611
    JAQZ520_602C FSD602
    JAQZ520_612C FSD612
    AQPA004V1    FPP001
    AQPA004D1    FPP003
    */
  
  begin
  
    pc_usuChar := pc_usu;
  
    insert into AQPA004CV
      (AQPA4LFEP,
       AQPA4LCOR,
       AQPA4LPGCOD,
       AQPA4LMOD,
       AQPA4LSUC,
       AQPA4LMDA,
       AQPA4LPAP,
       AQPA4LCTA,
       AQPA4LOPER,
       AQPA4LSBOP,
       AQPA4LTOPE,
       AQPA4LFEC,
       AQPA4LHOR,
       AQPA4LUSU,
       AQPA4LTIPO)
    VALUES
      (pd_fep,
       pn_cor,
       pn_emp,
       pn_mod,
       pn_suc,
       pn_mda,
       pn_pap,
       pn_cta,
       pn_ope,
       pn_sbo,
       pn_top,
       pd_fec,
       pc_hor,
       pc_usuChar,
       'COV19');
  
    -------------
    delete from jaqz520_010C a
     where a.fec = pd_fec
       and a.cor = pn_cor
       and a.pgcod = pn_emp
       and a.aomod = pn_mod
       and a.aosuc = pn_suc
       and a.aomda = pn_mda
       and a.aopap = pn_pap
       and a.aocta = pn_cta
       and a.aooper = pn_ope
       and a.aosbop = pn_sbo
       and a.aotope = pn_top;
  
    delete from jaqz520_011C a
     where a.fec = pd_fec
       and a.cor = pn_cor
       and a.pgcod = pn_emp
       and a.scmod = pn_mod
       and a.scsuc = pn_suc
       and a.scmda = pn_mda
       and a.scpap = pn_pap
       and a.sccta = pn_cta
       and a.scoper = pn_ope
       and a.scsbop = pn_sbo
       and a.sctope = pn_top;
  
    delete from jaqz520_601C a
     where a.fec = pd_fec
       and a.cor = pn_cor
       and a.pgcod = pn_emp
       and a.ppmod = pn_mod
       and a.ppsuc = pn_suc
       and a.ppmda = pn_mda
       and a.pppap = pn_pap
       and a.ppcta = pn_cta
       and a.ppoper = pn_ope
       and a.ppsbop = pn_sbo
       and a.pptope = pn_top;
  
    delete from jaqz520_611C a
     where a.fec = pd_fec
       and a.cor = pn_cor
       and a.pgcod = pn_emp
       and a.ppmod = pn_mod
       and a.ppsuc = pn_suc
       and a.ppmda = pn_mda
       and a.pppap = pn_pap
       and a.ppcta = pn_cta
       and a.ppoper = pn_ope
       and a.ppsbop = pn_sbo
       and a.pptope = pn_top;
  
    delete from jaqz520_602C a
     where a.fec = pd_fec
       and a.cor = pn_cor
       and a.pgcod = pn_emp
       and a.ppmod = pn_mod
       and a.ppsuc = pn_suc
       and a.ppmda = pn_mda
       and a.pppap = pn_pap
       and a.ppcta = pn_cta
       and a.ppoper = pn_ope
       and a.ppsbop = pn_sbo
       and a.pptope = pn_top;
  
    delete from jaqz520_612C a
     where a.fec = pd_fec
       and a.cor = pn_cor
       and a.pgcod = pn_emp
       and a.ppmod = pn_mod
       and a.ppsuc = pn_suc
       and a.ppmda = pn_mda
       and a.pppap = pn_pap
       and a.ppcta = pn_cta
       and a.ppoper = pn_ope
       and a.ppsbop = pn_sbo
       and a.pptope = pn_top;
    --chernandez 12/07/2020
    delete from jaqz520_002C a
     where a.fecha = pd_fec
       and a.corre = pn_cor
       and a.pgcod = pn_emp
       and a.ppmod = pn_mod
       and a.ppsuc = pn_suc
       and a.ppmda = pn_mda
       and a.pppap = pn_pap
       and a.ppcta = pn_cta
       and a.ppoper = pn_ope
       and a.ppsbop = pn_sbo
       and a.pptope = pn_top;
    --chernandez 12/07/2020
    delete from jaqz520_012C a
     where a.fec = pd_fec
       and a.cor = pn_cor
       and a.pgcod = pn_emp
       and a.aomod = pn_mod
       and a.aosuc = pn_suc
       and a.aomda = pn_mda
       and a.aopap = pn_pap
       and a.aocta = pn_cta
       and a.aooper = pn_ope
       and a.aosbop = pn_sbo
       and a.aotope = pn_top;
    ----------------
  
    insert into jaqz520_010C
      (fec,
       cor,
       pgcod,
       aomod,
       aosuc,
       aomda,
       aopap,
       aocta,
       aooper,
       aosbop,
       aotope,
       aofval,
       aofvto,
       aopzo,
       aottas,
       aotasa,
       aotmor,
       aottac,
       aotasc,
       aotdia,
       aotvto,
       aotano,
       aotint,
       aodrev,
       aoimp,
       aopre,
       aopre1,
       aotcbi,
       aotcbi1,
       aoarb,
       aoarb1,
       aomd,
       aomd1,
       aonume,
       aofnum,
       aoafiv,
       aocbcu,
       aostat,
       aoavis,
       aoplus,
       aoeven,
       aofe99,
       aocltcod,
       aoperiod)
      select pd_fep, pn_cor, a.*
        from fsd010 a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top;
  
    insert into jaqz520_011C
      (fec,
       cor,
       pgcod,
       scsuc,
       scrub,
       scmda,
       scpap,
       sccta,
       scoper,
       scsbop,
       sctope,
       scmod,
       scfcon,
       scfval,
       scfvto,
       scfulm,
       scpzo,
       scsdo,
       scsdoh,
       scsegm,
       scfunc,
       scstat,
       sccc,
       sctit,
       sccap,
       scplzo,
       scgru)
      select pd_fep, pn_cor, a.*
        from fsd011 a
       where a.pgcod = pn_emp
         and a.scmod = pn_mod
         and a.scsuc = pn_suc
         and a.scmda = pn_mda
         and a.scpap = pn_pap
         and a.sccta = pn_cta
         and a.scoper = pn_ope
         and a.scsbop = pn_sbo
         and a.sctope = pn_top;
  
    insert into jaqz520_601C
      (fec,
       cor,
       pgcod,
       ppmod,
       ppsuc,
       ppmda,
       pppap,
       ppcta,
       ppoper,
       ppsbop,
       pptope,
       ppfpag,
       pptipo,
       ppfval,
       ppfvto,
       pppzo,
       ppcap,
       ppint,
       ppintmex,
       ppicap,
       ppiint,
       ppstat,
       ppnume,
       ppfinv,
       d601cd,
       d601mo,
       d601su,
       d601tr,
       d601re,
       d601fc,
       d601or,
       d601sb,
       d601co)
    
      select pd_fep, pn_cor, a.*
        from fsd601 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top;
  
    insert into jaqz520_611C
      (fec,
       cor,
       pgcod,
       ppmod,
       ppsuc,
       ppmda,
       pppap,
       ppcta,
       ppoper,
       ppsbop,
       pptope,
       ppfpag,
       pptipo,
       ppexte,
       ppimp1,
       ppimp2,
       ppimp3,
       ppimp4,
       ppimp5,
       ppimp6,
       ppimp7,
       ppimp8,
       ppimp9,
       ppimp10,
       ppimp11,
       ppimp12,
       ppimp13,
       ppimp14,
       ppimp15,
       ppimp16,
       ppimp17,
       ppimp18,
       ppimp19,
       ppimp20)
      select pd_fep, pn_cor, a.*
        from fsd611 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top;
  
    insert into jaqz520_602C
      (fec,
       cor,
       pgcod,
       ppmod,
       ppsuc,
       ppmda,
       pppap,
       ppcta,
       ppoper,
       ppsbop,
       pptope,
       ppfpag,
       pptipo,
       pp1nump,
       pp1fech,
       pp1cap,
       pp1int,
       pp1intmex,
       pp1intm,
       pp1intmmex,
       pp1icap,
       pp1iint,
       pp1iintm,
       pp1salcap,
       pp1salint,
       pp1salade,
       pp1salmor,
       pp1stat,
       pp1salintm,
       pp1salmorm,
       pp1saladem,
       d602cd,
       d602mo,
       d602su,
       d602tr,
       d602re,
       d602fc,
       d602or,
       d602sb,
       d602co)
      select pd_fep, pn_cor, a.*
        from fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top;
  
    insert into jaqz520_612C
      (fec,
       cor,
       pgcod,
       ppmod,
       ppsuc,
       ppmda,
       pppap,
       ppcta,
       ppoper,
       ppsbop,
       pptope,
       ppfpag,
       pptipo,
       pp1nump,
       pp1exte,
       pp1imp1,
       pp1imp2,
       pp1imp3,
       pp1imp4,
       pp1imp5,
       pp1imp6,
       pp1imp7,
       pp1imp8,
       pp1imp9,
       pp1imp10,
       pp1imp11,
       pp1imp12,
       pp1imp13,
       pp1imp14,
       pp1imp15,
       pp1imp16,
       pp1imp17,
       pp1imp18,
       pp1imp19,
       pp1imp20,
       pp1sal1,
       pp1sal2,
       pp1sal3,
       pp1sal4,
       pp1sal5,
       pp1sal6,
       pp1sal7,
       pp1sal8,
       pp1sal9,
       pp1sal10,
       pp1sal11,
       pp1sal12,
       pp1sal13,
       pp1sal14,
       pp1sal15,
       pp1sal16,
       pp1sal17,
       pp1sal18,
       pp1sal19,
       pp1sal20)
    
      select pd_fep, pn_cor, a.*
        from fsd612 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top;
  
    insert into aqpa004v1
      (aqpa4cfep,
       aqpa4ccor,
       aqpa4cpgcod,
       aqpa4caomod,
       aqpa4caosuc,
       aqpa4caomda,
       aqpa4caopap,
       aqpa4caocta,
       aqpa4caooper,
       aqpa4caosbop,
       aqpa4caotope,
       aqpa4csgcod,
       aqpa4cfpro,
       aqpa4cvc,
       aqpa4cimp,
       aqpa4cporc,
       aqpa4cplus,
       aqpa4cpart,
       aqpa4cveh,
       aqpa4cinm,
       aqpa4cend,
       aqpa4cstat,
       aqpa4cco,
       aqpa4caux1,
       aqpa4caux2,
       aqpa4caux3,
       aqpa4caux4,
       aqpa4caux5,
       aqpa4caux6,
       aqpa4caux7 --,
       --aqpa4chpro
       )
      select pd_fep,
             pn_cor,
             pgcod,
             aomod,
             aosuc,
             aomda,
             aopap,
             aocta,
             aooper,
             aosbop,
             aotope,
             sgcod,
             pd_fec,
             pp001vc,
             pp001imp,
             pp001porc,
             pp001plus,
             pp001part,
             pp001veh,
             pp001inm,
             pp001end,
             pp001stat,
             pp001co,
             pp001aux1,
             pp001aux2,
             pp001aux3,
             pp001aux4,
             pp001aux5,
             pp001aux6,
             pp001aux7 --,
      --pc_hor
        from fpp001
       where pgcod = pn_emp
         and aomod = pn_mod
         and aosuc = pn_suc
         and aomda = pn_mda
         and aopap = pn_pap
         and aocta = pn_cta
         and aooper = pn_ope
         and aosbop = pn_sbo
         and aotope = pn_top;
  
    insert into aqpa004d1
      (aqpa4dfep,
       aqpa4dcor,
       aqpa4dpgcod,
       aqpa4dmod,
       aqpa4dsuc,
       aqpa4dmda,
       aqpa4dpap,
       aqpa4dcta,
       aqpa4doper,
       aqpa4dsbop,
       aqpa4dtope,
       aqpa4dfpag,
       aqpa4dtipo,
       aqpa4dnump,
       aqpa4dprcnc,
       aqpa4dfepro,
       aqpa4dimp,
       aqpa4dstat,
       aqpa4daux1,
       aqpa4daux2,
       aqpa4daux3)
      select pd_fep,
             pn_cor,
             pgcod,
             ppmod,
             ppsuc,
             ppmda,
             pppap,
             ppcta,
             ppoper,
             ppsbop,
             pptope,
             ppfpag,
             pptipo,
             pp003nump,
             prestconc,
             pd_fec,
             pp003imp,
             pp003stat,
             pp003aux1,
             pp003aux2,
             pp003aux3
        from fpp003
       where pgcod = pn_emp
         and ppmod = pn_mod
         and ppsuc = pn_suc
         and ppmda = pn_mda
         and pppap = pn_pap
         and ppcta = pn_cta
         and ppoper = pn_ope
         and ppsbop = pn_sbo
         and pptope = pn_top;
    --chernandez 12/07/2020
    insert into jaqz520_002C
      (pgcod,
       ppmod,
       ppsuc,
       ppmda,
       pppap,
       ppcta,
       ppoper,
       ppsbop,
       pptope,
       ppfpag,
       pptipo,
       prestconc,
       pp002imp,
       pp002stat,
       pp002aux1,
       pp002aux2,
       pp002aux3,
       fecha,
       corre)
      select pgcod,
             ppmod,
             ppsuc,
             ppmda,
             pppap,
             ppcta,
             ppoper,
             ppsbop,
             pptope,
             ppfpag,
             pptipo,
             prestconc,
             pp002imp,
             pp002stat,
             pp002aux1,
             pp002aux2,
             pp002aux3,
             pd_fep,
             pn_cor
        from fpp002
       where pgcod = pn_emp
         and ppmod = pn_mod
         and ppsuc = pn_suc
         and ppmda = pn_mda
         and pppap = pn_pap
         and ppcta = pn_cta
         and ppoper = pn_ope
         and ppsbop = pn_sbo
         and pptope = pn_top;
    --chernandez 12/07/2020
    insert into jaqz520_012c
      (pgcod,
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
       evimp,
       evttas,
       evtasa,
       evcap,
       evint,
       evmor,
       evscap,
       evsint,
       evsmor,
       evintc,
       evmorc,
       evcd01,
       evcd02,
       evinv,
       evper,
       evtcbi,
       evtcbi1,
       evarb,
       evarb1,
       evmd,
       evmd1,
       evpre,
       evpre1,
       d012cd,
       d012mo,
       d012su,
       d012tr,
       d012re,
       d012fc,
       d012or,
       d012sb,
       d012co,
       fec,
       cor)
      select a.*, pd_fep, pn_cor
        from fsd012 a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top;
  
    PC_EST := 'C';
    commit;
  
  exception
    when others then
      pc_coderr := sqlcode;
      pc_msgerr := sqlerrm;
      PC_EST    := 'Z';
  end Sp_backup_ini;

  Procedure sp_extorno_ini(pd_fep in date,
                           pn_cor in number,
                           pn_emp in number,
                           pn_mod in number,
                           pn_suc in number,
                           pn_mda in number,
                           pn_pap in number,
                           pn_cta in number,
                           pn_ope in number,
                           pn_sbo in number,
                           pn_top in number,
                           pd_fec in date,
                           pc_hor in varchar2,
                           pc_usu in varchar2,
                           PC_EST OUT varchar2) is
    pc_usuChar Character(10);
  
    pc_coderr varchar2(100);
    pc_msgerr varchar2(100);
  
    /*
    AQPA004CV    Maestro
    jaqz520_010C FSD010
    JAQZ520_011C FSD011
    JAQZ520_601C FSD601
    JAQZ520_611C FSD611
    JAQZ520_602C FSD602
    JAQZ520_612C FSD612
    AQPA004V1    FPP001
    AQPA004D1    FPP003
    */
    lc_estado varchar2(2);
  
  begin
  
    pc_usuChar := pc_usu;
  
    --si se extorno
    update AQPA004CV a
       set a.aqpa4lest = lc_estado
     where AQPA4LFEP = pd_fep
       and AQPA4LCOR = pn_cor
       and AQPA4LPGCOD = pn_emp
       and AQPA4LMOD = pn_mod
       and AQPA4LSUC = pn_suc
       and AQPA4LMDA = pn_mda
       and AQPA4LPAP = pn_pap
       and AQPA4LCTA = pn_cta
       and AQPA4LOPER = pn_ope
       and AQPA4LSBOP = pn_sbo
       and AQPA4LTOPE = pn_sbo;
  
    -------------
  
    delete from jaqz520_011C a
     where a.fec = pd_fec
       and a.cor = pn_cor
       and a.pgcod = pn_emp
       and a.scmod = pn_mod
       and a.scsuc = pn_suc
       and a.scmda = pn_mda
       and a.scpap = pn_pap
       and a.sccta = pn_cta
       and a.scoper = pn_ope
       and a.scsbop = pn_sbo
       and a.sctope = pn_top;
  
    delete from jaqz520_601C a
     where a.fec = pd_fec
       and a.cor = pn_cor
       and a.pgcod = pn_emp
       and a.ppmod = pn_mod
       and a.ppsuc = pn_suc
       and a.ppmda = pn_mda
       and a.pppap = pn_pap
       and a.ppcta = pn_cta
       and a.ppoper = pn_ope
       and a.ppsbop = pn_sbo
       and a.pptope = pn_top;
  
    delete from jaqz520_611C a
     where a.fec = pd_fec
       and a.cor = pn_cor
       and a.pgcod = pn_emp
       and a.ppmod = pn_mod
       and a.ppsuc = pn_suc
       and a.ppmda = pn_mda
       and a.pppap = pn_pap
       and a.ppcta = pn_cta
       and a.ppoper = pn_ope
       and a.ppsbop = pn_sbo
       and a.pptope = pn_top;
  
    delete from jaqz520_602C a
     where a.fec = pd_fec
       and a.cor = pn_cor
       and a.pgcod = pn_emp
       and a.ppmod = pn_mod
       and a.ppsuc = pn_suc
       and a.ppmda = pn_mda
       and a.pppap = pn_pap
       and a.ppcta = pn_cta
       and a.ppoper = pn_ope
       and a.ppsbop = pn_sbo
       and a.pptope = pn_top;
  
    delete from jaqz520_612C a
     where a.fec = pd_fec
       and a.cor = pn_cor
       and a.pgcod = pn_emp
       and a.ppmod = pn_mod
       and a.ppsuc = pn_suc
       and a.ppmda = pn_mda
       and a.pppap = pn_pap
       and a.ppcta = pn_cta
       and a.ppoper = pn_ope
       and a.ppsbop = pn_sbo
       and a.pptope = pn_top;
  
    ----------------
  
    insert into jaqz520_010C
      (fec,
       cor,
       pgcod,
       aomod,
       aosuc,
       aomda,
       aopap,
       aocta,
       aooper,
       aosbop,
       aotope,
       aofval,
       aofvto,
       aopzo,
       aottas,
       aotasa,
       aotmor,
       aottac,
       aotasc,
       aotdia,
       aotvto,
       aotano,
       aotint,
       aodrev,
       aoimp,
       aopre,
       aopre1,
       aotcbi,
       aotcbi1,
       aoarb,
       aoarb1,
       aomd,
       aomd1,
       aonume,
       aofnum,
       aoafiv,
       aocbcu,
       aostat,
       aoavis,
       aoplus,
       aoeven,
       aofe99,
       aocltcod,
       aoperiod)
      select pd_fep, pn_cor, a.*
        from fsd010 a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top;
  
    insert into jaqz520_011C
      (fec,
       cor,
       pgcod,
       scsuc,
       scrub,
       scmda,
       scpap,
       sccta,
       scoper,
       scsbop,
       sctope,
       scmod,
       scfcon,
       scfval,
       scfvto,
       scfulm,
       scpzo,
       scsdo,
       scsdoh,
       scsegm,
       scfunc,
       scstat,
       sccc,
       sctit,
       sccap,
       scplzo,
       scgru)
      select pd_fep, pn_cor, a.*
        from fsd011 a
       where a.pgcod = pn_emp
         and a.scmod = pn_mod
         and a.scsuc = pn_suc
         and a.scmda = pn_mda
         and a.scpap = pn_pap
         and a.sccta = pn_cta
         and a.scoper = pn_ope
         and a.scsbop = pn_sbo
         and a.sctope = pn_top;
  
    insert into jaqz520_601C
      (fec,
       cor,
       pgcod,
       ppmod,
       ppsuc,
       ppmda,
       pppap,
       ppcta,
       ppoper,
       ppsbop,
       pptope,
       ppfpag,
       pptipo,
       ppfval,
       ppfvto,
       pppzo,
       ppcap,
       ppint,
       ppintmex,
       ppicap,
       ppiint,
       ppstat,
       ppnume,
       ppfinv,
       d601cd,
       d601mo,
       d601su,
       d601tr,
       d601re,
       d601fc,
       d601or,
       d601sb,
       d601co)
    
      select pd_fep, pn_cor, a.*
        from fsd601 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top;
  
    insert into jaqz520_611C
      (fec,
       cor,
       pgcod,
       ppmod,
       ppsuc,
       ppmda,
       pppap,
       ppcta,
       ppoper,
       ppsbop,
       pptope,
       ppfpag,
       pptipo,
       ppexte,
       ppimp1,
       ppimp2,
       ppimp3,
       ppimp4,
       ppimp5,
       ppimp6,
       ppimp7,
       ppimp8,
       ppimp9,
       ppimp10,
       ppimp11,
       ppimp12,
       ppimp13,
       ppimp14,
       ppimp15,
       ppimp16,
       ppimp17,
       ppimp18,
       ppimp19,
       ppimp20)
      select pd_fep, pn_cor, a.*
        from fsd611 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top;
  
    insert into jaqz520_602C
      (fec,
       cor,
       pgcod,
       ppmod,
       ppsuc,
       ppmda,
       pppap,
       ppcta,
       ppoper,
       ppsbop,
       pptope,
       ppfpag,
       pptipo,
       pp1nump,
       pp1fech,
       pp1cap,
       pp1int,
       pp1intmex,
       pp1intm,
       pp1intmmex,
       pp1icap,
       pp1iint,
       pp1iintm,
       pp1salcap,
       pp1salint,
       pp1salade,
       pp1salmor,
       pp1stat,
       pp1salintm,
       pp1salmorm,
       pp1saladem,
       d602cd,
       d602mo,
       d602su,
       d602tr,
       d602re,
       d602fc,
       d602or,
       d602sb,
       d602co)
      select pd_fep, pn_cor, a.*
        from fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top;
  
    insert into jaqz520_612C
      (fec,
       cor,
       pgcod,
       ppmod,
       ppsuc,
       ppmda,
       pppap,
       ppcta,
       ppoper,
       ppsbop,
       pptope,
       ppfpag,
       pptipo,
       pp1nump,
       pp1exte,
       pp1imp1,
       pp1imp2,
       pp1imp3,
       pp1imp4,
       pp1imp5,
       pp1imp6,
       pp1imp7,
       pp1imp8,
       pp1imp9,
       pp1imp10,
       pp1imp11,
       pp1imp12,
       pp1imp13,
       pp1imp14,
       pp1imp15,
       pp1imp16,
       pp1imp17,
       pp1imp18,
       pp1imp19,
       pp1imp20,
       pp1sal1,
       pp1sal2,
       pp1sal3,
       pp1sal4,
       pp1sal5,
       pp1sal6,
       pp1sal7,
       pp1sal8,
       pp1sal9,
       pp1sal10,
       pp1sal11,
       pp1sal12,
       pp1sal13,
       pp1sal14,
       pp1sal15,
       pp1sal16,
       pp1sal17,
       pp1sal18,
       pp1sal19,
       pp1sal20)
    
      select pd_fep, pn_cor, a.*
        from fsd612 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top;
  
    insert into aqpa004v1
      (aqpa4cfep,
       aqpa4ccor,
       aqpa4cpgcod,
       aqpa4caomod,
       aqpa4caosuc,
       aqpa4caomda,
       aqpa4caopap,
       aqpa4caocta,
       aqpa4caooper,
       aqpa4caosbop,
       aqpa4caotope,
       aqpa4csgcod,
       aqpa4cfpro,
       aqpa4cvc,
       aqpa4cimp,
       aqpa4cporc,
       aqpa4cplus,
       aqpa4cpart,
       aqpa4cveh,
       aqpa4cinm,
       aqpa4cend,
       aqpa4cstat,
       aqpa4cco,
       aqpa4caux1,
       aqpa4caux2,
       aqpa4caux3,
       aqpa4caux4,
       aqpa4caux5,
       aqpa4caux6,
       aqpa4caux7 --,
       --aqpa4chpro
       )
      select pd_fep,
             pn_cor,
             pgcod,
             aomod,
             aosuc,
             aomda,
             aopap,
             aocta,
             aooper,
             aosbop,
             aotope,
             sgcod,
             pd_fec,
             pp001vc,
             pp001imp,
             pp001porc,
             pp001plus,
             pp001part,
             pp001veh,
             pp001inm,
             pp001end,
             pp001stat,
             pp001co,
             pp001aux1,
             pp001aux2,
             pp001aux3,
             pp001aux4,
             pp001aux5,
             pp001aux6,
             pp001aux7 --,
      --pc_hor
        from fpp001
       where pgcod = pn_emp
         and aomod = pn_mod
         and aosuc = pn_suc
         and aomda = pn_mda
         and aopap = pn_pap
         and aocta = pn_cta
         and aooper = pn_ope
         and aosbop = pn_sbo
         and aotope = pn_top;
  
    insert into aqpa004d1
      (aqpa4dfep,
       aqpa4dcor,
       aqpa4dpgcod,
       aqpa4dmod,
       aqpa4dsuc,
       aqpa4dmda,
       aqpa4dpap,
       aqpa4dcta,
       aqpa4doper,
       aqpa4dsbop,
       aqpa4dtope,
       aqpa4dfpag,
       aqpa4dtipo,
       aqpa4dnump,
       aqpa4dprcnc,
       aqpa4dfepro,
       aqpa4dimp,
       aqpa4dstat,
       aqpa4daux1,
       aqpa4daux2,
       aqpa4daux3)
      select pd_fep,
             pn_cor,
             pgcod,
             ppmod,
             ppsuc,
             ppmda,
             pppap,
             ppcta,
             ppoper,
             ppsbop,
             pptope,
             ppfpag,
             pptipo,
             pp003nump,
             prestconc,
             pd_fec,
             pp003imp,
             pp003stat,
             pp003aux1,
             pp003aux2,
             pp003aux3
        from fpp003
       where pgcod = pn_emp
         and ppmod = pn_mod
         and ppsuc = pn_suc
         and ppmda = pn_mda
         and pppap = pn_pap
         and ppcta = pn_cta
         and ppoper = pn_ope
         and ppsbop = pn_sbo
         and pptope = pn_top;
  
    PC_EST := 'C';
    commit;
  
  exception
    when others then
      pc_coderr := sqlcode;
      pc_msgerr := sqlerrm;
      PC_EST    := 'Z';
  end Sp_extorno_ini;
  -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_backup_ini_mype(pn_emp in number,
                               pn_mod in number,
                               pn_suc in number,
                               pn_mda in number,
                               pn_pap in number,
                               pn_cta in number,
                               pn_ope in number,
                               pn_sbo in number,
                               pn_top in number,
                               pd_fec in date,
                               pc_hor in varchar2,
                               pc_usu in varchar2,
                               PC_EST OUT varchar2,
                               pd_fep out date,   --- jrodriguej 09/07/2021 salida de fecha en AQPB088
                               pn_cor out number  --- jrodriguej 09/07/2021 salida de corr en AQPB088
                               ) is
    pc_usuChar Character(10);
  
    pc_coderr varchar2(100);
    pc_msgerr varchar2(100);
  
    --pd_fep date;
    --pn_cor number(9);
  
    lx_cont   number(5);
    lx_fecha  date;
    lx_fecha2 date;
  
    /*
    AQPA004CV    Maestro
    jaqz520_010C FSD010
    JAQZ520_011C FSD011
    JAQZ520_601C FSD601
    JAQZ520_611C FSD611
    JAQZ520_602C FSD602
    JAQZ520_612C FSD612
    AQPA004V1    FPP001
    AQPA004D1    FPP003
    */
  
    cursor creditos_601(pn_fecha date, pn_corr number) is
      select x.pgcod,
             x.ppmod,
             x.ppsuc,
             x.ppmda,
             x.pppap,
             x.ppcta,
             x.ppoper,
             x.ppsbop,
             x.pptope,
             x.ppfpag,
             x.pptipo,
             x.ppfval,
             x.ppfvto,
             x.pppzo,
             x.ppcap,
             x.ppint,
             x.ppintmex,
             x.ppicap,
             x.ppiint,
             x.ppstat,
             x.ppnume,
             x.ppfinv,
             x.d601cd,
             x.d601mo,
             x.d601su,
             x.d601tr,
             x.d601re,
             x.d601fc,
             x.d601or,
             x.d601sb,
             x.d601co
        from aqpb088_601c x
       where x.fec = pn_fecha
         and x.cor = pn_corr;
  
  begin
  
    pc_usuChar := pc_usu;
  
    begin
      sp_correl_sq(p_c_nomseq => 'SEQ_AQPB088_COR',
                   p_c_codusu => 'BANTOTAL',
                   p_n_correl => pn_cor); --out        9999 9999
    end;  
  
    --- Obtener maximo
    /*
    select (nvl(max(x.aqpb088cor), 0) + 1)
      into pn_cor
      from aqpb088 x
     where x.aqpb088fep = pd_fec;
    */
  
    pd_fep := pd_fec;
  
    -- jrodriguej 05/02/2021
    insert into aqpb088
      (aqpb088fep,
       aqpb088cor,
       aqpb088emp,
       aqpb088mod,
       aqpb088suc,
       aqpb088mda,
       aqpb088pap,
       aqpb088cta,
       aqpb088ope,
       aqpb088sbo,
       aqpb088top,
       aqpb088est,
       aqpb088fex,
       aqpb088hor,
       AQPB088usu)
    values
      (pd_fep,
       pn_cor,
       pn_emp,
       pn_mod,
       pn_suc,
       pn_mda,
       pn_pap,
       pn_cta,
       pn_ope,
       pn_sbo,
       pn_top,
       'C',
       pd_fec,
       pc_hor,
       pc_usu);
    commit;
  
    --- Insert
  
    insert into AQPB088A -- AQPA004CV
      (AQPB088AFEP,
       AQPB088ACOR,
       AQPB088APGCOD,
       AQPB088AMOD,
       AQPB088ASUC,
       AQPB088AMDA,
       AQPB088APAP,
       AQPB088ACTA,
       AQPB088AOPER,
       AQPB088ASBOP,
       AQPB088ATOPE,
       AQPB088AFEC,
       AQPB088AHOR,
       AQPB088AUSU,
       AQPB088ATIPO)
    VALUES
      (pd_fep,
       pn_cor,
       pn_emp,
       pn_mod,
       pn_suc,
       pn_mda,
       pn_pap,
       pn_cta,
       pn_ope,
       pn_sbo,
       pn_top,
       pd_fec,
       pc_hor,
       pc_usuChar,
       'COV19');
    commit;
    
    ---======================
    --- INSERT
    ---======================    
    insert into aqpb088_010C
      (fec,
       cor,
       pgcod,
       aomod,
       aosuc,
       aomda,
       aopap,
       aocta,
       aooper,
       aosbop,
       aotope,
       aofval,
       aofvto,
       aopzo,
       aottas,
       aotasa,
       aotmor,
       aottac,
       aotasc,
       aotdia,
       aotvto,
       aotano,
       aotint,
       aodrev,
       aoimp,
       aopre,
       aopre1,
       aotcbi,
       aotcbi1,
       aoarb,
       aoarb1,
       aomd,
       aomd1,
       aonume,
       aofnum,
       aoafiv,
       aocbcu,
       aostat,
       aoavis,
       aoplus,
       aoeven,
       aofe99,
       aocltcod,
       aoperiod)
      select pd_fep, pn_cor, a.*
        from fsd010 a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top;
    commit;
    
    insert into aqpb088_011C
      (fec,
       cor,
       pgcod,
       scsuc,
       scrub,
       scmda,
       scpap,
       sccta,
       scoper,
       scsbop,
       sctope,
       scmod,
       scfcon,
       scfval,
       scfvto,
       scfulm,
       scpzo,
       scsdo,
       scsdoh,
       scsegm,
       scfunc,
       scstat,
       sccc,
       sctit,
       sccap,
       scplzo,
       scgru)
      select pd_fep, pn_cor, a.*
        from fsd011 a
       where a.pgcod = pn_emp
         and a.scmod = pn_mod
         and a.scsuc = pn_suc
         and a.scmda = pn_mda
         and a.scpap = pn_pap
         and a.sccta = pn_cta
         and a.scoper = pn_ope
         and a.scsbop = pn_sbo
         and a.sctope = pn_top;
    commit;
    
    insert into aqpb088_601C
      (fec,
       cor,
       pgcod,
       ppmod,
       ppsuc,
       ppmda,
       pppap,
       ppcta,
       ppoper,
       ppsbop,
       pptope,
       ppfpag,
       pptipo,
       ppfval,
       ppfvto,
       pppzo,
       ppcap,
       ppint,
       ppintmex,
       ppicap,
       ppiint,
       ppstat,
       ppnume,
       ppfinv,
       d601cd,
       d601mo,
       d601su,
       d601tr,
       d601re,
       d601fc,
       d601or,
       d601sb,
       d601co)
    
      select pd_fep, pn_cor, a.*
        from fsd601 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top;
    commit;
    
    insert into aqpb088_611C
      (fec,
       cor,
       pgcod,
       ppmod,
       ppsuc,
       ppmda,
       pppap,
       ppcta,
       ppoper,
       ppsbop,
       pptope,
       ppfpag,
       pptipo,
       ppexte,
       ppimp1,
       ppimp2,
       ppimp3,
       ppimp4,
       ppimp5,
       ppimp6,
       ppimp7,
       ppimp8,
       ppimp9,
       ppimp10,
       ppimp11,
       ppimp12,
       ppimp13,
       ppimp14,
       ppimp15,
       ppimp16,
       ppimp17,
       ppimp18,
       ppimp19,
       ppimp20)
      select pd_fep, pn_cor, a.*
        from fsd611 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top;
    commit;
    
    insert into aqpb088_602C
      (fec,
       cor,
       pgcod,
       ppmod,
       ppsuc,
       ppmda,
       pppap,
       ppcta,
       ppoper,
       ppsbop,
       pptope,
       ppfpag,
       pptipo,
       pp1nump,
       pp1fech,
       pp1cap,
       pp1int,
       pp1intmex,
       pp1intm,
       pp1intmmex,
       pp1icap,
       pp1iint,
       pp1iintm,
       pp1salcap,
       pp1salint,
       pp1salade,
       pp1salmor,
       pp1stat,
       pp1salintm,
       pp1salmorm,
       pp1saladem,
       d602cd,
       d602mo,
       d602su,
       d602tr,
       d602re,
       d602fc,
       d602or,
       d602sb,
       d602co)
      select pd_fep, pn_cor, a.*
        from fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top;
    commit;
     
    insert into aqpb088_612C
      (fec,
       cor,
       pgcod,
       ppmod,
       ppsuc,
       ppmda,
       pppap,
       ppcta,
       ppoper,
       ppsbop,
       pptope,
       ppfpag,
       pptipo,
       pp1nump,
       pp1exte,
       pp1imp1,
       pp1imp2,
       pp1imp3,
       pp1imp4,
       pp1imp5,
       pp1imp6,
       pp1imp7,
       pp1imp8,
       pp1imp9,
       pp1imp10,
       pp1imp11,
       pp1imp12,
       pp1imp13,
       pp1imp14,
       pp1imp15,
       pp1imp16,
       pp1imp17,
       pp1imp18,
       pp1imp19,
       pp1imp20,
       pp1sal1,
       pp1sal2,
       pp1sal3,
       pp1sal4,
       pp1sal5,
       pp1sal6,
       pp1sal7,
       pp1sal8,
       pp1sal9,
       pp1sal10,
       pp1sal11,
       pp1sal12,
       pp1sal13,
       pp1sal14,
       pp1sal15,
       pp1sal16,
       pp1sal17,
       pp1sal18,
       pp1sal19,
       pp1sal20)
    
      select pd_fep, pn_cor, a.*
        from fsd612 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top;
    commit;
    
    insert into AQPB088_001C
      (aqpa4cfep,
       aqpa4ccor,
       aqpa4cpgcod,
       aqpa4caomod,
       aqpa4caosuc,
       aqpa4caomda,
       aqpa4caopap,
       aqpa4caocta,
       aqpa4caooper,
       aqpa4caosbop,
       aqpa4caotope,
       aqpa4csgcod,
       aqpa4cfpro,
       aqpa4cvc,
       aqpa4cimp,
       aqpa4cporc,
       aqpa4cplus,
       aqpa4cpart,
       aqpa4cveh,
       aqpa4cinm,
       aqpa4cend,
       aqpa4cstat,
       aqpa4cco,
       aqpa4caux1,
       aqpa4caux2,
       aqpa4caux3,
       aqpa4caux4,
       aqpa4caux5,
       aqpa4caux6,
       aqpa4caux7 --,
       --aqpa4chpro
       )
      select pd_fep,
             pn_cor,
             pgcod,
             aomod,
             aosuc,
             aomda,
             aopap,
             aocta,
             aooper,
             aosbop,
             aotope,
             sgcod,
             pd_fec,
             pp001vc,
             pp001imp,
             pp001porc,
             pp001plus,
             pp001part,
             pp001veh,
             pp001inm,
             pp001end,
             pp001stat,
             pp001co,
             pp001aux1,
             pp001aux2,
             pp001aux3,
             pp001aux4,
             pp001aux5,
             pp001aux6,
             pp001aux7 --,
      --pc_hor
        from fpp001
       where pgcod = pn_emp
         and aomod = pn_mod
         and aosuc = pn_suc
         and aomda = pn_mda
         and aopap = pn_pap
         and aocta = pn_cta
         and aooper = pn_ope
         and aosbop = pn_sbo
         and aotope = pn_top;
    commit;
     
    insert into AQPB088_003C
      (aqpa4dfep,
       aqpa4dcor,
       aqpa4dpgcod,
       aqpa4dmod,
       aqpa4dsuc,
       aqpa4dmda,
       aqpa4dpap,
       aqpa4dcta,
       aqpa4doper,
       aqpa4dsbop,
       aqpa4dtope,
       aqpa4dfpag,
       aqpa4dtipo,
       aqpa4dnump,
       aqpa4dprcnc,
       aqpa4dfepro,
       aqpa4dimp,
       aqpa4dstat,
       aqpa4daux1,
       aqpa4daux2,
       aqpa4daux3)
      select pd_fep,
             pn_cor,
             pgcod,
             ppmod,
             ppsuc,
             ppmda,
             pppap,
             ppcta,
             ppoper,
             ppsbop,
             pptope,
             ppfpag,
             pptipo,
             pp003nump,
             prestconc,
             pd_fec,
             pp003imp,
             pp003stat,
             pp003aux1,
             pp003aux2,
             pp003aux3
        from fpp003
       where pgcod = pn_emp
         and ppmod = pn_mod
         and ppsuc = pn_suc
         and ppmda = pn_mda
         and pppap = pn_pap
         and ppcta = pn_cta
         and ppoper = pn_ope
         and ppsbop = pn_sbo
         and pptope = pn_top;
    commit;
    
    insert into aqpb088_002C
      (pgcod,
       ppmod,
       ppsuc,
       ppmda,
       pppap,
       ppcta,
       ppoper,
       ppsbop,
       pptope,
       ppfpag,
       pptipo,
       prestconc,
       pp002imp,
       pp002stat,
       pp002aux1,
       pp002aux2,
       pp002aux3,
       fecha,
       corre)
      select pgcod,
             ppmod,
             ppsuc,
             ppmda,
             pppap,
             ppcta,
             ppoper,
             ppsbop,
             pptope,
             ppfpag,
             pptipo,
             prestconc,
             pp002imp,
             pp002stat,
             pp002aux1,
             pp002aux2,
             pp002aux3,
             pd_fep,
             pn_cor
        from fpp002
       where pgcod = pn_emp
         and ppmod = pn_mod
         and ppsuc = pn_suc
         and ppmda = pn_mda
         and pppap = pn_pap
         and ppcta = pn_cta
         and ppoper = pn_ope
         and ppsbop = pn_sbo
         and pptope = pn_top;
    commit;
    
    insert into aqpb088_012c
      (pgcod,
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
       evimp,
       evttas,
       evtasa,
       evcap,
       evint,
       evmor,
       evscap,
       evsint,
       evsmor,
       evintc,
       evmorc,
       evcd01,
       evcd02,
       evinv,
       evper,
       evtcbi,
       evtcbi1,
       evarb,
       evarb1,
       evmd,
       evmd1,
       evpre,
       evpre1,
       d012cd,
       d012mo,
       d012su,
       d012tr,
       d012re,
       d012fc,
       d012or,
       d012sb,
       d012co,
       fec,
       cor)
      select a.*, pd_fep, pn_cor
        from fsd012 a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top;
    commit;
   
    PC_EST := 'C';
  
  exception
    when others then
      pc_coderr := sqlcode;
      pc_msgerr := sqlerrm;
      PC_EST    := 'Z';
  end sp_backup_ini_mype;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  Procedure sp_actualizar_aqpb088(pn_emp in number,
                                  pn_mod in number,
                                  pn_suc in number,
                                  pn_mda in number,
                                  pn_pap in number,
                                  pn_cta in number,
                                  pn_ope in number,
                                  pn_sbo in number,
                                  pn_top in number) is
    --pc_usuChar Character(10);
  
    pc_coderr varchar2(100);
    pc_msgerr varchar2(100);
  
    pd_fep date;
    pn_cor number(9);
  
    lx_cont   number(5);
    lx_fecha  date;
    lx_fecha2 date;
  
    cursor creditos_601(pn_fecha date, pn_corr number) is
      select x.pgcod,
             x.ppmod,
             x.ppsuc,
             x.ppmda,
             x.pppap,
             x.ppcta,
             x.ppoper,
             x.ppsbop,
             x.pptope,
             x.ppfpag,
             x.pptipo,
             x.ppfval,
             x.ppfvto,
             x.pppzo,
             x.ppcap,
             x.ppint,
             x.ppintmex,
             x.ppicap,
             x.ppiint,
             x.ppstat,
             x.ppnume,
             x.ppfinv,
             x.d601cd,
             x.d601mo,
             x.d601su,
             x.d601tr,
             x.d601re,
             x.d601fc,
             x.d601or,
             x.d601sb,
             x.d601co
        from aqpb088_601c x
       where x.fec = pn_fecha
         and x.cor = pn_corr
       order by x.ppfpag asc;
  
  begin
  
    begin
      select max(a.aqpb088fep)
        into pd_fep
        from aqpb088 a
       where a.aqpb088emp = pn_emp
         and a.aqpb088mod = pn_mod
         and a.aqpb088suc = pn_suc
         and a.aqpb088mda = pn_mda
         and a.aqpb088pap = pn_pap
         and a.aqpb088cta = pn_cta
         and a.aqpb088ope = pn_ope
         and a.aqpb088sbo = pn_sbo
         and a.aqpb088top = pn_top
         and a.aqpb088est = 'C';
    exception
      when others then
        null;
    end;
  
    --pd_fep := '15/09/2020';
    --pn_cor := 8;
  
    begin
      select max(a.aqpb088cor)
        into pn_cor
        from aqpb088 a
       where a.aqpb088emp = pn_emp
         and a.aqpb088mod = pn_mod
         and a.aqpb088suc = pn_suc
         and a.aqpb088mda = pn_mda
         and a.aqpb088pap = pn_pap
         and a.aqpb088cta = pn_cta
         and a.aqpb088ope = pn_ope
         and a.aqpb088sbo = pn_sbo
         and a.aqpb088top = pn_top
         and a.aqpb088est = 'C'
         and a.aqpb088fep = pd_fep;
    exception
      when others then
        pn_cor := 0;
    end;
  
    --jrodriguej 04/03/2021
  
    for j in creditos_601(pd_fep, pn_cor) loop
    
      select count(*)
        into lx_cont
        from fsd601 t
       where t.pgcod = j.pgcod
         and t.ppmod = j.ppmod
         and t.ppsuc = j.ppsuc
         and t.ppmda = j.ppmda
         and t.pppap = j.pppap
         and t.ppcta = j.ppcta
         and t.ppoper = j.ppoper
         and t.ppsbop = j.ppsbop
         and t.pptope = j.pptope
         and t.ppfpag = j.ppfpag;
    
      if lx_cont > 0 then
      
        select t.ppfpag
          into lx_fecha
          from fsd601 t
         where t.pgcod = j.pgcod
           and t.ppmod = j.ppmod
           and t.ppsuc = j.ppsuc
           and t.ppmda = j.ppmda
           and t.pppap = j.pppap
           and t.ppcta = j.ppcta
           and t.ppoper = j.ppoper
           and t.ppsbop = j.ppsbop
           and t.pptope = j.pptope
           and t.ppfpag = j.ppfpag;
      
      end if;
    
      if lx_cont = 0 then
      
        begin
        
          --dbms_output.put_line('FSD601 ' || lx_fecha2);
          lx_fecha2 := j.ppfvto;
        
          update aqpb088 p
             set p.aqpb088fev = lx_fecha2
           where p.aqpb088fep = pd_fep
             and p.aqpb088cor = pn_cor;
          commit;
        
        exception
          when others then
            null;
          
        end;
      
        --dbms_output.put_line('AQPB088_601 ' || j.ppfvto);
        --dbms_output.put_line('fsd601 ' || lx_fecha2);
        --dbms_output.put_line('FEC ' || i.aqpb088fep);
        --dbms_output.put_line('COR ' || i.aqpb088cor);
      
        exit;
      end if;
    
    --dbms_output.put_line('lx_cont ' || lx_cont);
    --dbms_output.put_line('VESTA ' || j.ppfpag);
    
    end loop;
  
  exception
    when others then
      pc_coderr := sqlcode;
      pc_msgerr := sqlerrm;
  end sp_actualizar_aqpb088;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
end PQ_CR_REPRO_COV;
/

