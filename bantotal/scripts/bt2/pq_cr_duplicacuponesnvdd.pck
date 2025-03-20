create or replace package PQ_CR_DUPLICACUPONESNVDD is

  -- Author  : MPOSTIGOC
  -- Created : 04/01/2018 07:07:11 p.m.
  -- Purpose : 
  procedure sp_cr_Inicio(lc_Digito in varchar2);
  -----------------------------------------------------
  procedure sp_cr_inserta(nro_cupon     in number,
                          ln_pgcod      in number,
                          ln_modulo     in number,
                          ln_sucursal   in number,
                          ln_moneda     in number,
                          ln_papel      in number,
                          ln_cuenta     in number,
                          ln_operacion  in number,
                          ln_subope     in number,
                          ln_tope       in number,
                          ln_nrocred    in varchar2,
                          ld_fecha1     in date,
                          pd_fecha      in date,
                          lc_Est        in varchar2,
                          lc_usuario    in varchar2,
                          ln_sucusuario in number,
                          lc_region     in number,
                          lc_Ant        in varchar2,
                          ln_Atr        in varchar2,
                          ln_calific    in number,
                          lc_Tip        in varchar2,
                          lc_EXCUP      in varchar2,
                          JAQL406tsbor  in number,
                          JAQL406tord   in number,
                          JAQL406tnrel  in number,
                          JAQL406ttran  in number,
                          JAQL406tmod   in number,
                          JAQL406tsuc   in number,
                          ld_fecha2     in date,
                          ln_NUMP       in number,
                          ln_CUPNUM     in number,
                          ln_opcion     in number);

  ------------------------------------------------------
  Procedure sp_cr_carga_job;

end PQ_CR_DUPLICACUPONESNVDD;
/

create or replace package body PQ_CR_DUPLICACUPONESNVDD is

  procedure sp_cr_Inicio(lc_Digito in varchar2) is
    cursor listado is
      select t.jaql406pgc,
             t.jaql406mod,
             t.jaql406suc,
             t.jaql406mda,
             t.jaql406pap,
             t.jaql406cta,
             t.jaql406ope,
             t.jaql406sbo,
             t.jaql406top,
             count(*)
        from (select distinct j.jaql406pgc,
                              j.jaql406mod,
                              j.jaql406suc,
                              j.jaql406mda,
                              j.jaql406pap,
                              j.jaql406cta,
                              j.jaql406ope,
                              j.jaql406sbo,
                              j.jaql406top,
                              j.jaql406fcta
                from jaql406 j
               where j.jaql406excup = 'C'
                 and to_char(substr(trim(j.jaql406cta), -1, 1)) = lc_Digito
               group by j.jaql406pgc,
                        j.jaql406mod,
                        j.jaql406suc,
                        j.jaql406mda,
                        j.jaql406pap,
                        j.jaql406cta,
                        j.jaql406ope,
                        j.jaql406sbo,
                        j.jaql406top,
                        j.jaql406fcta

               /*order by j.jaql406pgc,
                        j.jaql406mod,
                        j.jaql406suc,
                        j.jaql406mda,
                        j.jaql406pap,
                        j.jaql406cta,
                        j.jaql406ope,
                        j.jaql406sbo,
                        j.jaql406top,
                        j.jaql406fcta*/) t
       group by t.jaql406pgc,
                t.jaql406mod,
                t.jaql406suc,
                t.jaql406mda,
                t.jaql406pap,
                t.jaql406cta,
                t.jaql406ope,
                t.jaql406sbo,
                t.jaql406top
      having count(*) > 2;
  
    cursor detallado(ln_pgcod in number, ln_mod in number, ln_suc in number, ln_mda in number, ln_pap in number, ln_cta in number, ln_ope in number, ln_sbo in number, ln_top in number) is
    
      select distinct j.jaql406pgc,
                      j.jaql406mod,
                      j.jaql406suc,
                      j.jaql406mda,
                      j.jaql406pap,
                      j.jaql406cta,
                      j.jaql406ope,
                      j.jaql406sbo,
                      j.jaql406top,
                      j.jaql406cre,
                      j.jaql406fec,
                      j.jaql406fop,
                      j.jaql406est,
                      j.jaql406usr,
                      j.jaql406age,
                      j.jaql406dpt,
                      j.jaql406ant,
                      j.jaql406atr,
                      j.jaql406cal,
                      j.jaql406tip,
                      j.jaql406excup,
                      j.jaql406tsbor,
                      j.jaql406tord,
                      j.jaql406tnrel,
                      j.jaql406ttran,
                      j.jaql406tmod,
                      j.jaql406tsuc,
                      j.jaql406fcta,
                      j.jaql406nump,
                      j.jaql406cupnum,
                      j.jaql406opc,
                      count(*) ln_NroOpciones
        from jaql406 j
       where j.jaql406excup = 'C'
         and j.jaql406pgc = ln_pgcod
         and j.jaql406mod = ln_mod
         and j.jaql406suc = ln_suc
         and j.jaql406mda = ln_mda
         and j.jaql406pap = ln_pap
         and j.jaql406cta = ln_cta
         and j.jaql406ope = ln_ope
         and j.jaql406sbo = ln_sbo
         and j.jaql406top = ln_top
       group by j.jaql406pgc,
                j.jaql406mod,
                j.jaql406suc,
                j.jaql406mda,
                j.jaql406pap,
                j.jaql406cta,
                j.jaql406ope,
                j.jaql406sbo,
                j.jaql406top,
                j.jaql406cre,
                j.jaql406fec,
                j.jaql406fop,
                j.jaql406est,
                j.jaql406usr,
                j.jaql406age,
                j.jaql406dpt,
                j.jaql406ant,
                j.jaql406atr,
                j.jaql406cal,
                j.jaql406tip,
                j.jaql406excup,
                j.jaql406tsbor,
                j.jaql406tord,
                j.jaql406tnrel,
                j.jaql406ttran,
                j.jaql406tmod,
                j.jaql406tsuc,
                j.jaql406fcta,
                j.jaql406nump,
                j.jaql406cupnum,
                j.jaql406opc;
  
    i number := 1;
  
  begin
  
    for l in listado loop
      for d in detallado(l.jaql406pgc,
                         l.jaql406mod,
                         l.jaql406suc,
                         l.jaql406mda,
                         l.jaql406pap,
                         l.jaql406cta,
                         l.jaql406ope,
                         l.jaql406sbo,
                         l.jaql406top) loop
        i := 1;
      
        while i <= d.ln_nroopciones loop
        
          PQ_CR_DUPLICACUPONESNVDD.sp_cr_inserta(SQ_CR_JAQL406_2.NEXTVAL,
                                                 d.jaql406pgc,
                                                 d.JAQL406Mod,
                                                 d.JAQL406Suc,
                                                 d.JAQL406Mda,
                                                 d.JAQL406pap,
                                                 d.JAQL406Cta,
                                                 d.JAQL406Ope,
                                                 d.JAQL406Sbo,
                                                 d.JAQL406Top,
                                                 d.jaql406cre,
                                                 d.jaql406fec,
                                                 d.jaql406fop,
                                                 d.jaql406est,
                                                 d.jaql406usr,
                                                 d.jaql406age,
                                                 d.jaql406dpt,
                                                 d.jaql406ant,
                                                 d.jaql406atr,
                                                 d.jaql406cal,
                                                 'D',
                                                 d.jaql406excup,
                                                 d.jaql406tsbor,
                                                 d.JAQL406tord,
                                                 d.JAQL406tnrel,
                                                 d.JAQL406ttran,
                                                 d.JAQL406tmod,
                                                 d.JAQL406tsuc,
                                                 d.jaql406fcta,
                                                 d.jaql406nump,
                                                 d.jaql406cupnum,
                                                 d.ln_nroopciones);
        
          i := i + 1;
        
        end loop;
      end loop;
    
    end loop;
  
  end sp_cr_Inicio;
  ---------------------------------------------------------
  procedure sp_cr_inserta(nro_cupon     in number,
                          ln_pgcod      in number,
                          ln_modulo     in number,
                          ln_sucursal   in number,
                          ln_moneda     in number,
                          ln_papel      in number,
                          ln_cuenta     in number,
                          ln_operacion  in number,
                          ln_subope     in number,
                          ln_tope       in number,
                          ln_nrocred    in varchar2,
                          ld_fecha1     in date,
                          pd_fecha      in date,
                          lc_Est        in varchar2,
                          lc_usuario    in varchar2,
                          ln_sucusuario in number,
                          lc_region     in number,
                          lc_Ant        in varchar2,
                          ln_Atr        in varchar2,
                          ln_calific    in number,
                          lc_Tip        in varchar2,
                          lc_EXCUP      in varchar2,
                          JAQL406tsbor  in number,
                          JAQL406tord   in number,
                          JAQL406tnrel  in number,
                          JAQL406ttran  in number,
                          JAQL406tmod   in number,
                          JAQL406tsuc   in number,
                          ld_fecha2     in date,
                          ln_NUMP       in number,
                          ln_CUPNUM     in number,
                          ln_opcion     in number) is
  begin
    begin
      insert into JAQL406
        (JAQL406Cup,
         JAQL406PGC,
         JAQL406Mod,
         JAQL406Suc,
         JAQL406Mda,
         JAQL406PAP,
         JAQL406Cta,
         JAQL406Ope,
         JAQL406Sbo,
         JAQL406Top,
         JAQL406CRE,
         JAQL406FEC,
         JAQL406FOP,
         JAQL406EST,
         JAQL406USR,
         JAQL406AGE,
         JAQL406DPT,
         JAQL406ANT,
         JAQL406ATR,
         JAQL406CAL,
         JAQL406TIP,
         JAQL406EXCUP,
         JAQL406TSBOR,
         JAQL406TORD,
         JAQL406TNREL,
         JAQL406TTRAN,
         JAQL406TMOD,
         JAQL406TSUC,
         JAQL406FCTA,
         JAQL406NUMP,
         JAQL406CUPNUM,
         JAQL406OPC)
      values
        (nro_cupon,
         ln_pgcod,
         ln_modulo,
         ln_sucursal,
         ln_moneda,
         ln_papel,
         ln_cuenta,
         ln_operacion,
         ln_subope,
         ln_tope,
         ln_nrocred,
         ld_fecha1,
         pd_fecha,
         lc_Est,
         lc_usuario,
         ln_sucusuario,
         lc_region,
         lc_Ant,
         ln_Atr,
         ln_calific,
         lc_Tip,
         lc_EXCUP,
         JAQL406tsbor,
         JAQL406tord,
         JAQL406tnrel,
         JAQL406ttran,
         JAQL406tmod,
         JAQL406tsuc,
         ld_fecha2,
         ln_NUMP,
         ln_CUPNUM,
         ln_opcion);
    End;
    COMMIT;
  
  end sp_cr_inserta;
  ----------------------------------------------------------
  Procedure sp_cr_carga_job is
  
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    --ln_cont     number(2) := 0;
    -- lc_fecpro char(10);
  
  begin
  
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    for x in 0 .. 9 loop
    
      lc_variable := ' begin ' ||
                     'PQ_CR_DUPLICACUPONESNVDD.sp_cr_Inicio(''' || x ||
                     ''');' || ' End; ';
    
      ln_job := ln_job + 1;
    
--      if UPPER(lc_hostname) in ('SC01ZDBADM010101', 'SC01ZDBADM020101') then
IF SYS.FN_BD_ISRAC='TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      commit;
    
    end loop;
  
  end sp_cr_carga_job;
  ------------------------------------------------------------------------------------  
end PQ_CR_DUPLICACUPONESNVDD;
/

