create or replace package PQ_AH_ACTUALIZA_DATA is

  -- Author  : YLOZADA
  -- Created : 30/01/2021 11:52:18 a.m.
  -- Purpose : 

  Procedure sp_genera_scheduler(p_c_coderr out varchar2);
  Procedure sp_cl_volcado_job(P_C_DIGITO1 IN VARCHAR2,
                              P_C_DIGITO2 IN VARCHAR2,
                              ln_ini      in number);  
end PQ_AH_ACTUALIZA_DATA;
/

create or replace package body PQ_AH_ACTUALIZA_DATA is

  procedure sp_genera_scheduler(p_c_coderr out varchar2) is
    lc_coderr varchar2(2000);
  
    cursor c_job is
    
      SELECT /*+PARALLEL(T,4)*/
       SUBSTR(trim(JAQN451NDO), -1, 1) C_DIGITO1,
       SUBSTR(trim(JAQN451NDO), -2, 1) C_DIGITO2
        FROM JAQN451 T
        WHERE t.jaqn451cod = 1
       GROUP BY SUBSTR(trim(JAQN451NDO), -1, 1),
                SUBSTR(trim(JAQN451NDO), -2, 1);
  
    lc_variable varchar2(4000);
    ln_job      number := 0;
    ln_ini      number := 0;
  
  begin
  
    --
    -- Barridos de jobs
    --
    execute immediate ('truncate table schedulers');
  
    for job in c_job loop
      ln_ini      := ln_ini + 1;
      lc_variable := ' begin ' ||
                     '  PQ_AH_ACTUALIZA_DATA.sp_cl_volcado_job(' || '''' ||
                     job.C_DIGITO1 || '''' || ',' || '''' || job.C_DIGITO2 || '''' || ',' ||
                     ln_ini || ');' || ' End; ';
      ln_job      := ln_job + 1;
    
      dbms_scheduler.create_job(job_name   => 'ACTUALIZA_DATA' ||
                                              LPAD(TO_CHAR(ln_job), 5, '0'),
                                job_type   => 'PLSQL_BLOCK',
                                job_action => lc_variable,
                                start_date => sysdate + 1 / (24 * 180),
                                enabled    => true,
                                auto_drop  => TRUE,
                                comments   => 'ACTUALIZA FECHA FIN TASA DE AHORROS CLIENTES COMUNICADOS');
    
      INSERT INTO Schedulers
        (c_codage, n_Numer1, c_detjob)
      VALUES
        ('ACT', ln_ini, lc_variable);
      COMMIT;
    
    end loop;
  exception
    when others then
      lc_coderr  := sqlerrm;
      p_c_coderr := lc_coderr;
  end sp_genera_scheduler;

  -------------------------------------------------------------------------------

  Procedure sp_cl_volcado_job(P_C_DIGITO1 IN VARCHAR2,
                              P_C_DIGITO2 IN VARCHAR2,
                              ln_ini      in number) is
         
   cursor c_clientes is
   Select a.* 
    from jaqn451 a 
   where a.jaqn451cod = 1
     and a.jaqn451fco is not null
     and a.jaqn451fap > to_date('31/01/2021','dd/mm/rrrr')
     and substr(trim(a.jaqn451ndo), -1, 1) = P_C_DIGITO1
     and substr(trim(a.jaqn451ndo), -2, 1) = P_C_DIGITO2   
     ;
   
   cursor c_cuentas(ln_pais in number,ln_tipo in number,lc_numero in char) is
   Select b.*
     from jaqn452 b
    where b.jaqn452cod = 1
      and b.jaqn452pai = ln_pais
      and b.jaqn452tdo = ln_tipo
      and b.jaqn452ndo = lc_numero
      and b.jaqn452emp = 1
      and b.jaqn452mod = 21
      and b.jaqn452top <> 2;
      
   cursor c_integración(P_N_PGCOD  in number,
                        P_N_MODULO in number,
                        P_N_SUCDES in number,
                        P_N_MONEDA in number,
                        P_N_PAPEL  in number,
                        P_N_CTNRO  in number,
                        P_N_ITOPER in number,
                        P_N_ITSUBO in number,
                        P_N_ITTOPE in number
                       ) is
          Select nvl(count(1),0) no_comunicados
            from jaqn451 b,
                 jaqn452 c
          where b.jaqn451cod = c.jaqn452cod
            and b.jaqn451pai = c.jaqn452pai
            and b.jaqn451tdo = c.jaqn452tdo
            and b.jaqn451ndo = c.jaqn452ndo 
            and c.jaqn452emp = P_N_PGCOD 
            and c.jaqn452mod = P_N_MODULO
            and c.jaqn452suc = P_N_SUCDES
            and c.jaqn452mda = P_N_MONEDA
            and c.jaqn452pap = P_N_PAPEL 
            and c.jaqn452cta = P_N_CTNRO 
            and c.jaqn452ope = P_N_ITOPER
            and c.jaqn452sbo = P_N_ITSUBO
            and c.jaqn452top = P_N_ITTOPE
            and b.jaqn451cod = 1
            and c.jaqn452cod = 1
            and b.jaqn451fap is null;   
  ld_tasvig date;   
  ln_taspiz number(2):=0;
  ln_cont number(9):=0; 
  lc_msgerr     VARCHAR2(400);  
  
  begin
  
    update schedulers g
       set g.d_fecini = sysdate
     where g.n_numer1 = ln_ini
       and g.c_codage = 'ACT';
    commit;
  
  for i in c_clientes loop    
    for j in c_cuentas(i.jaqn451pai,i.jaqn451tdo,i.jaqn451ndo) loop
      ln_cont := 0;
      for k in c_integración(j.jaqn452emp,
                            j.jaqn452mod,
                            j.jaqn452suc,
                            j.jaqn452mda,
                            j.jaqn452pap,
                            j.jaqn452cta,
                            j.jaqn452ope,
                            j.jaqn452sbo,
                            j.jaqn452top
                            ) loop
        ln_cont := k.no_comunicados;                          
      end loop;
      if ln_cont = 0 then --actualizar fsd328
         ld_tasvig := null;
        begin
          Select max(a.tasfdes)
            into ld_tasvig
            from fsd427 a
           where a.tasemp = j.jaqn452emp
             and a.tasmod = j.jaqn452mod
             and a.tascta = j.jaqn452cta
             and a.tassop = j.jaqn452sbo
             and a.tasmda = j.jaqn452mda
             and a.taspap = j.jaqn452pap
             and a.tasvig = 'S'
             and a.tasfdes = to_date('01/12/2020','dd/mm/rrrr'); 
          Exception 
          when others then
            ld_tasvig := null;
          end;
          if ld_tasvig is not null then
             update fsd328 z
                set z.vtasfvto = i.jaqn451fap
              where z.vtasemp = j.jaqn452emp
                and z.vtasmod = j.jaqn452mod
                and z.vtascta = j.jaqn452cta
                and z.vtassop = j.jaqn452sbo
                and z.vtasmda = j.jaqn452mda
                and z.vtaspap = j.jaqn452pap
                and z.vtasfdes = ld_tasvig;
                
                if sql%notfound then 
                  ln_taspiz := 0;
                 begin
                    Select a.taspiz
                      into ln_taspiz
                      from fsd427 a
                     where a.tasemp  = j.jaqn452emp
                       and a.tasmod  = j.jaqn452mod
                       and a.tascta  = j.jaqn452cta
                       and a.tassop  = j.jaqn452sbo
                       and a.tasmda  = j.jaqn452mda
                       and a.taspap  = j.jaqn452pap 
                       and a.tasfdes = ld_tasvig
                       and a.tasvig = 'S'     
                       and rownum = 1;               
                 end;
                 begin
                   insert into fsd328
                     (vtasemp,
                      vtasmod,
                      vtaspiz,
                      vtascta,
                      vtassop,
                      vtasmda,
                      vtaspap,
                      vtasfdes,
                      vtasfvto)
                   values
                     (j.jaqn452emp,
                      j.jaqn452mod,
                      ln_taspiz,
                      j.jaqn452cta,
                      j.jaqn452sbo,
                      j.jaqn452mda,
                      j.jaqn452pap,
                      ld_tasvig,
                      i.jaqn451fap);
                 exception 
                 when others then
                   null;                   
                 end;
                End If; 
            commit;  
          End If;
      End If;
    end loop;
  End loop;  
    update schedulers g
       set g.d_fecfin = sysdate
     where g.n_numer1 = ln_ini
       and g.c_codage = 'ACT';
    commit;
    
  Exception
    when others then
      lc_msgerr := sqlerrm;
      update schedulers g
         set g.c_inderr = 'S', g.c_deserr = lc_msgerr
       where g.n_numer1 = ln_ini
         and g.c_codage = 'ACT';
      commit;
    
  end;

  ------------------------------------------------------------------

  
end PQ_AH_ACTUALIZA_DATA;
/

