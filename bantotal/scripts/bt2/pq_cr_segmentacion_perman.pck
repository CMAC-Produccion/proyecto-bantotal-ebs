create or replace package PQ_CR_SEGMENTACION_PERMAN is

  -- Author  : ABERNEDO
  -- Created : 18/12/2017 12:10:55 p.m.
  -- Purpose : 
  Procedure Sp_cr_Carga_0;
  procedure sp_cr_job_Carga(P_D_FECPRO IN DATE);
  Procedure Sp_cr_Carga(P_D_FECPRO in date, P_C_DIGITO in varchar2);
  Procedure Sp_existe(pn_pai in number,
                      pn_tdo in number,
                      pc_ndo in char,
                      pn_seg in number);
  Procedure Sp_cr_variables(pn_pai   in number,
                            pn_tdo   in number,
                            pc_ndo   in char,
                            pc_var30 out char,
                            pc_var31 out char,
                            pc_var32 out char,
                            pc_var33 out char,
                            pc_var34 out char,
                            pc_var35 out char,
                            pc_var36 out char,
                            pc_var37 out char,
                            pc_var38 out char,
                            pc_var39 out char,
                            pc_var40 out char,
                            pc_var41 out char);
  Procedure Sp_Segmento_Des(pn_ins in number,
                            pn_seg out number,
                            pn_pai out number,
                            pn_tdo out number,
                            pc_ndo out char,
                            pd_fec out date);
end PQ_CR_SEGMENTACION_PERMAN;
/

create or replace package body PQ_CR_SEGMENTACION_PERMAN is

  Procedure Sp_cr_Carga_0 is
  
    ld_fecprod date;
  
  begin
  
    execute immediate ('truncate table jaqz542_aux');
    begin
      select to_date(a.Tp1nro1, 'dd.mm.yyyy') + 1
        into ld_fecprod
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 700
         and a.tp1corr2 = 1
         and a.tp1corr3 = 1;
    exception
      when others then
        null;
    end;
    begin
    
      Insert into jaqz542_aux
        (jaqz542pai,
         jaqz542tdo,
         jaqz542ndo,
         jaqz542emp,
         jaqz542mod,
         jaqz542suc,
         jaqz542mda,
         jaqz542pap,
         jaqz542cta,
         jaqz542ope,
         jaqz542sbo,
         jaqz542top,
         jaqz542fva)
      
        Select b.pepais,
               b.petdoc,
               b.pendoc,
               a.pgcod,
               a.aomod,
               a.aosuc,
               a.aomda,
               a.aopap,
               a.aocta,
               a.aooper,
               a.aosbop,
               a.aotope,
               a.aofval
          from fsd010 a, fsr008 b
         where a.pgcod = 1
           and a.aomod in (select modulo
                             from fst111
                            where dscod = 50
                              and modulo not in (33, 200, 108))
           and a.aofval >= ld_fecprod
           and a.pgcod = b.pgcod
           and a.aocta = b.ctnro
           and b.cttfir = 'T'
        --and aocta=1767710
        ;
    
      commit;
    end;
  end Sp_cr_Carga_0;

  procedure sp_cr_job_Carga(P_D_FECPRO IN DATE) is
  
    cursor c_clientes_job is
      select substr(trim(a.jaqz542ndo), -1, 1) digito
        from jaqz542_aux a
       group by substr(trim(a.jaqz542ndo), -1, 1);
  
    lc_hostname varchar2(64);
    lc_fecpro   varchar2(10);
    lc_variable varchar2(4000);
    ln_job      number := 0;
    ln_cont     number(5) := 0;
    ln_inst     number(1) := 1;
    lc_coderr   varchar2(300);
  BEGIN
  
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    delete Tab_jobs where c_Codage = 'SEGP';
    commit;
  
    lc_fecpro := to_char(P_D_FECPRO, 'RRRR.MM.DD');
  
    for job in c_clientes_job loop
    
      lc_variable := ' begin ' ||
                     ' PQ_CR_SEGMENTACION_PERMAN.Sp_cr_Carga(TO_DATE(''' ||
                     lc_fecpro || ''',''RRRR.MM.DD''),''' || job.digito ||
                     ''');' || ' End; ';
      ln_cont     := ln_cont + 1;
    
      if (ln_cont >= 6) then
        ln_inst := 2;
      end if;
    
      ln_job := ln_job + 1;
    
      --if UPPER(lc_hostname) in ('SC01ZDBADM010101', 'SC01ZDBADM020101') then
     
      
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 1,
                        --instance => 2, 01/01/2024
                        force => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      
      
      commit;
      INSERT INTO Tab_jobs
        (c_Codage, c_detjob, C_DATO1)
      VALUES
        ('SEGP', job.digito, lc_variable);
      COMMIT;
    end loop;
  exception
    when others then
      lc_coderr := sqlerrm;
      INSERT INTO LOG_ERROR_BANDEJA
        (N_NRO, C_CODBDJ, C_DESERR, D_FECERR)
      VALUES
        (0, 'SEGP', lc_coderr, TRUNC(SYSDATE));
      COMMIT;
  end sp_cr_job_Carga;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  Procedure Sp_cr_Carga(P_D_FECPRO in date, P_C_DIGITO in varchar2) is
  
    cursor creditos is
      select *
        from jaqz542_aux
       where substr(trim(jaqz542ndo), -1, 1) = P_C_DIGITO;
    ln_instancia    number(10);
    lc_segmentacion char(30);
    ln_codSeg       number(5);
    lc_coderr       varchar2(300);
  
  begin
    update tab_jobs g
       set g.d_fecini = sysdate
     where g.c_detjob = P_C_DIGITO
       and g.c_codage = 'SEGP';
    commit;
  
    for i in creditos loop
    
      ln_instancia    := null;
      lc_segmentacion := null;
      ln_codSeg       := null;
      --instancia
      ln_instancia := fn_instancia_credito(v_Scmod  => i.jaqz542mod,
                                           v_Scsuc  => i.jaqz542suc,
                                           v_Scmda  => i.jaqz542mda,
                                           v_Scpap  => i.jaqz542pap,
                                           v_Sccta  => i.jaqz542cta,
                                           v_Scoper => i.jaqz542ope,
                                           v_Scsbop => i.jaqz542sbo,
                                           v_Sctope => i.jaqz542top);
      --segmentacion
      begin
        select substr(pae71val, 1, INSTR(pae71val, ':') - 1)
          into lc_segmentacion
          from fpae70 pnro, fpae71 wit
         where pnro.pae70nro = wit.pae70nro
           and pnro.pae51eva = wit.pae51eva
           and pnro.pae51eva = 1
           and wit.pae71ite = 380
           and pnro.pae70ins = ln_instancia;
      Exception
        when too_many_rows then
          begin
            select substr(pae71val, 1, INSTR(pae71val, ':') - 1)
              into lc_segmentacion
              from fpae70 pnro, fpae71 wit
             where pnro.pae70nro = wit.pae70nro
               and pnro.pae51eva = wit.pae51eva
               and pnro.pae51eva = 1
               and wit.pae71ite = 380
               and pnro.pae70nro =
                   (select max(pae70nro)
                      from fpae70
                     where pae70ins = ln_instancia)
                  
               and rownum = 1;
          Exception
            when others then
              null;
          end;
        when others then
          null;
      end;
      begin
        select a.jaqy067ccal
          into ln_codSeg
          from jaqy067 a
         where a.jaqy067ncal = trim(lc_segmentacion)
           and a.jaqy067ccal >= 30;
      exception
        when others then
          null;
      end;
    
      pq_Cr_segmentacion_perman.sp_existe(pn_pai => i.jaqz542pai,
                                          pn_tdo => i.jaqz542tdo,
                                          pc_ndo => i.jaqz542ndo,
                                          pn_seg => ln_codSeg);
    
      insert into jaqz542
        (jaqz542pai,
         jaqz542tdo,
         jaqz542ndo,
         jaqz542emp,
         jaqz542mod,
         jaqz542suc,
         jaqz542mda,
         jaqz542pap,
         jaqz542cta,
         jaqz542ope,
         jaqz542sbo,
         jaqz542top,
         jaqz542ins,
         jaqz542fva,
         jaqz542fep,
         jaqz542seg,
         jaqz542est)
      values
        (i.jaqz542pai,
         i.jaqz542tdo,
         i.jaqz542ndo,
         i.jaqz542emp,
         i.jaqz542mod,
         i.jaqz542suc,
         i.jaqz542mda,
         i.jaqz542pap,
         i.jaqz542cta,
         i.jaqz542ope,
         i.jaqz542sbo,
         i.jaqz542top,
         ln_instancia,
         i.jaqz542fva,
         P_D_FECPRO,
         ln_codSeg,
         'S');
    
      commit;
    end loop;
  
    commit;
  
    update tab_jobs g
       set g.d_fecfin = sysdate
     where g.c_detjob = P_C_DIGITO
       and g.c_codage = 'SEGP';
    commit;
  
  exception
    when others then
      lc_coderr := sqlerrm;
      INSERT INTO LOG_ERROR_BANDEJA
        (N_NRO, C_CODBDJ, C_DESERR, D_FECERR)
      VALUES
        (0, 'SEGP', P_C_DIGITO || lc_coderr, TRUNC(SYSDATE));
      COMMIT;
    
  end Sp_cr_Carga;

  Procedure Sp_existe(pn_pai in number,
                      pn_tdo in number,
                      pc_ndo in char,
                      pn_seg in number) is
  
    ln_codseg number(5);
    lc_flg    char(1) := 'N';
  
  begin
  
    begin
      select a.jaqz542seg
        into ln_codseg
        from jaqz542 a
       where a.jaqz542pai = pn_pai
         and a.jaqz542tdo = pn_tdo
         and a.jaqz542ndo = pc_ndo;
    exception
      when others then
        null;
    end;
  
    if ln_codseg = pn_seg then
      lc_flg := 'S';
    else
      lc_flg := 'N';
    end if;
  
    if lc_flg = 'S' then
      delete from jaqz542 a
       where a.jaqz542pai = pn_pai
         and a.jaqz542tdo = pn_tdo
         and a.jaqz542ndo = pc_ndo
         and a.jaqz542seg = pn_seg;
    
      commit;
    end if;
  
  end Sp_existe;

  Procedure Sp_cr_variables(pn_pai   in number,
                            pn_tdo   in number,
                            pc_ndo   in char,
                            pc_var30 out char,
                            pc_var31 out char,
                            pc_var32 out char,
                            pc_var33 out char,
                            pc_var34 out char,
                            pc_var35 out char,
                            pc_var36 out char,
                            pc_var37 out char,
                            pc_var38 out char,
                            pc_var39 out char,
                            pc_var40 out char,
                            pc_var41 out char) is
    cursor creditos is
      select *
        from jaqz542 a
       where a.jaqz542pai = pn_pai
         and a.jaqz542tdo = pn_tdo
         and a.jaqz542ndo = pc_ndo;
  
  begin
    pc_var30 := 'N';
    pc_var31 := 'N';
    pc_var32 := 'N';
    pc_var33 := 'N';
    pc_var34 := 'N';
    pc_var35 := 'N';
    pc_var36 := 'N';
    pc_var37 := 'N';
    pc_var38 := 'N';
    pc_var39 := 'N';
    pc_var40 := 'N';
    pc_var41 := 'N';
    for i in creditos loop
    
      case
        when i.jaqz542seg = 30 then
          pc_var30 := 'S';
        when i.jaqz542seg = 31 then
          pc_var31 := 'S';
        when i.jaqz542seg = 32 then
          pc_var32 := 'S';
        when i.jaqz542seg = 33 then
          pc_var33 := 'S';
        when i.jaqz542seg = 34 then
          pc_var34 := 'S';
        when i.jaqz542seg = 35 then
          pc_var35 := 'S';
        when i.jaqz542seg = 36 then
          pc_var36 := 'S';
        when i.jaqz542seg = 37 then
          pc_var37 := 'S';
        when i.jaqz542seg = 38 then
          pc_var38 := 'S';
        when i.jaqz542seg = 39 then
          pc_var39 := 'S';
        when i.jaqz542seg = 40 then
          pc_var40 := 'S';
        when i.jaqz542seg = 41 then
          pc_var41 := 'S';
        else
          null;
      end case;
    end loop;
  
  end Sp_cr_variables;

  Procedure Sp_Segmento_Des(pn_ins in number,
                            pn_seg out number,
                            pn_pai out number,
                            pn_tdo out number,
                            pc_ndo out char,
                            pd_fec out date) is
    lc_segmentacion char(30);
  
  begin
    begin
      select n.pae70pdoc,
             n.pae70tdoc,
             n.pae70ndoc,
             n.pae70time,
             substr(pae71val, 1, INSTR(pae71val, ':') - 1)
        into pn_pai, pn_tdo, pc_ndo, pd_fec, lc_segmentacion
        from fpae70 n, fpae71 v
       where n.pae70nro = v.pae70nro
         and v.pae71ite = 380
         and n.pae51eva = v.pae51eva
         and v.pae51eva = 1
         and n.pae70ins = pn_ins;
    exception
      when no_data_found then
        null;
      
      when too_many_ROWS then
        begin
          select n.pae70pdoc,
                 n.pae70tdoc,
                 n.pae70ndoc,
                 n.pae70time,
                 substr(pae71val, 1, INSTR(pae71val, ':') - 1)
            into pn_pai, pn_tdo, pc_ndo, pd_fec, lc_segmentacion
            from fpae70 n, fpae71 v
           where n.pae70nro = v.pae70nro
             and v.pae71ite = 380
             and n.pae51eva = v.pae51eva
             and v.pae51eva = 1
             and n.pae70nro =
                 (select max(pae70nro) from fpae70 where pae70ins = pn_ins)
             and rownum = 1;
        exception
          when others then
            null;
        end;
      
      when others then
        null;
    end;
  
    begin
      select a.jaqy067ccal
        into pn_seg
        from jaqy067 a
       where a.jaqy067ncal = trim(lc_segmentacion);
    exception
      when others then
        null;
    end;
  
  end Sp_Segmento_Des;

end PQ_CR_SEGMENTACION_PERMAN;
/

