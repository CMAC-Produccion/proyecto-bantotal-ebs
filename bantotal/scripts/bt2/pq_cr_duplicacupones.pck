create or replace package PQ_CR_DUPLICACUPONES is

  -- Author  : MPOSTIGOC
  -- Created : 04/01/2018 07:07:11 p.m.
  -- Purpose : 
  procedure sp_cr_InicioDuplica(lc_Digito in varchar2);
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
  -----------------------------------------------------
  procedure sp_cr_InicioTipCred(lc_Digito     in varchar2,
                                ld_fechacorte in date);
  ------------------------------------------------------
  procedure sp_cr_VerTipoCred(ln_instancia   in number,
                              lc_FlagTipCred out varchar2,
                              ln_nrocupones  out number);

  ------------------------------------------------------
  Procedure sp_cr_carga_job;
  ---------------------------------------------------
  Procedure sp_cr_JobTipCred(ld_FechaCorte in date);

end PQ_CR_DUPLICACUPONES;
/

create or replace package body PQ_CR_DUPLICACUPONES is

  procedure sp_cr_InicioDuplica(lc_Digito in varchar2) is
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
             count(*) ln_NroCuotPagadas
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
               order by j.jaql406pgc,
                        j.jaql406mod,
                        j.jaql406suc,
                        j.jaql406mda,
                        j.jaql406pap,
                        j.jaql406cta,
                        j.jaql406ope,
                        j.jaql406sbo,
                        j.jaql406top,
                        j.jaql406fcta) t
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
  
    cursor detallado(ln_pgcod in number,
                     ln_mod   in number,
                     ln_suc   in number,
                     ln_mda   in number,
                     ln_pap   in number,
                     ln_cta   in number,
                     ln_ope   in number,
                     ln_sbo   in number,
                     ln_top   in number) is
    
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
  
    ld_FchI           date;
    ld_FchF           date;
    ln_NroCuotCalend  number;
    ln_NroCuotPagadas number;
  
  begin
  
    Begin
      select to_date(Tp1nro1 || '/' || Tp1nro2 || '/' || Tp1nro3,
                     'DD/MM/YYYY'), --fech_inicio,
             to_date(Tp1imp1 || '/' || Tp1imp2 || '/' || Tp1imp3,
                     'DD/MM/YYYY')
        into ld_FchI, ld_FchF
        from FST198
       Where Tp1cod = 1
         and Tp1cod1 = 10871
         and Tp1corr1 = 7
         and Tp1corr2 = 4;
    
    End;
  
    for l in listado loop
    
      ln_NroCuotPagadas := l.ln_nrocuotpagadas;
    
      begin
      
        select count(*)
          into ln_NroCuotCalend
          from fsd601 f
         where f.pgcod = l.jaql406pgc
           and f.ppmod = l.jaql406mod
           and f.ppsuc = l.jaql406suc
           and f.ppmda = l.jaql406mda
           and f.pppap = l.jaql406pap
           and f.ppcta = l.jaql406cta
           and f.ppoper = l.jaql406ope
           and f.ppsbop = l.jaql406sbo
           and f.pptope = l.jaql406top
           and f.ppfpag between ld_FchI and ld_FchF
           and f.d601co = 'S';
      end;
    
      if ln_NroCuotPagadas = ln_NroCuotCalend then
      
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
          
            PQ_CR_DUPLICACUPONES.sp_cr_inserta(SQ_CR_JAQL406_2.NEXTVAL,
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
                                               'CD',
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
      end if;
    end loop;
  
  end sp_cr_InicioDuplica;
  ------------------------------------------------------

  procedure sp_cr_InicioTipCred(lc_Digito     in varchar2,
                                ld_fechacorte in date) is
    cursor Lista_Creditos is
      select distinct j.jaql406pgc    ln_jaql406pgc,
                      j.jaql406mod    ln_jaql406mod,
                      j.jaql406suc    ln_jaql406suc,
                      j.jaql406mda    ln_jaql406mda,
                      j.jaql406pap    ln_jaql406pap,
                      j.jaql406cta    ln_jaql406cta,
                      j.jaql406ope    ln_jaql406ope,
                      j.jaql406sbo    ln_jaql406sbo,
                      j.jaql406top    ln_jaql406top,
                      j.jaql406tsbor  ln_jaql406tsbor,
                      j.jaql406tord   ln_jaql406tord,
                      j.jaql406tnrel  ln_jaql406tnrel,
                      j.jaql406ttran  ln_jaql406ttran,
                      j.jaql406tmod   ln_jaql406tmod,
                      j.jaql406tsuc   ln_jaql406tsuc,
                      j.jaql406cre    ln_jaql406cred,
                      j.jaql406fec    ln_jaql406fec,
                      j.jaql406fop    ln_jaql406fop,
                      j.jaql406est    ln_jaql406est,
                      j.jaql406usr    ln_jaql406usr,
                      j.jaql406age    ln_jaql406age,
                      j.jaql406dpt    ln_jaql406dpt,
                      j.jaql406ant    ln_jaql406ant,
                      j.jaql406atr    ln_jaql406atr,
                      j.jaql406cal    ln_jaql406cal,
                      j.jaql406excup  ln_jaql406excup,
                      j.jaql406fcta   ln_jaql406fcta,
                      j.jaql406nump   ln_jaql406nump,
                      j.jaql406cupnum ln_jaql406cupnum,
                      j.jaql406tip    ln_jaql406tip
      
        from jaql406 j
       where jaql406tip in ('D', 'P')
         and jaql406excup = 'C'
         and to_char(substr(trim(j.jaql406cta), -1, 1)) = lc_Digito
         and j.jaql406fop <= ld_fechacorte;
    /*and j.jaql406cta = 281511*/
  
    ln_instancia   number;
    lc_FlagTipCred varchar2(2) := 'N';
    ln_nrocupones  number;
    i              number := 1;
    ln_Grupo       number;
  
  begin
  
    for l in Lista_Creditos loop
    
      if l.ln_jaql406tip = 'D' then
      
        ln_instancia := fn_instancia_credito(v_Scmod  => l.ln_jaql406mod,
                                             v_Scsuc  => l.ln_jaql406suc,
                                             v_Scmda  => l.ln_jaql406mda,
                                             v_Scpap  => l.ln_jaql406pap,
                                             v_Sccta  => l.ln_jaql406cta,
                                             v_Scoper => l.ln_jaql406ope,
                                             v_Scsbop => l.ln_jaql406sbo,
                                             v_Sctope => l.ln_jaql406top);
      
        pq_cr_duplicacupones.sp_cr_VerTipoCred(ln_instancia,
                                               lc_FlagTipCred,
                                               ln_nrocupones);
      
        if lc_FlagTipCred = 'S' then
        
          i := 1;
        
          while i <= ln_nrocupones loop
          
            PQ_CR_DUPLICACUPONES.sp_cr_inserta(SQ_CR_JAQL406_2.NEXTVAL,
                                               L.LN_JAQL406PGC,
                                               l.ln_jaql406mod,
                                               l.ln_jaql406suc,
                                               l.ln_jaql406mda,
                                               l.ln_jaql406pap,
                                               l.ln_jaql406cta,
                                               l.ln_jaql406ope,
                                               l.ln_jaql406sbo,
                                               l.ln_jaql406top,
                                               l.ln_jaql406cred,
                                               l.ln_jaql406fec,
                                               l.ln_jaql406fop,
                                               l.ln_jaql406est,
                                               l.ln_jaql406usr,
                                               l.ln_jaql406age,
                                               l.ln_jaql406dpt,
                                               l.ln_jaql406ant,
                                               l.ln_jaql406atr,
                                               l.ln_jaql406cal,
                                               'M',
                                               l.ln_jaql406excup,
                                               l.ln_jaql406tsbor,
                                               l.ln_JAQL406tord,
                                               l.ln_JAQL406tnrel,
                                               l.ln_JAQL406ttran,
                                               l.ln_JAQL406tmod,
                                               l.ln_JAQL406tsuc,
                                               l.ln_jaql406fcta,
                                               l.ln_jaql406nump,
                                               l.ln_jaql406cupnum,
                                               ln_nrocupones);
          
            i := i + 1;
          
          end loop;
        end if;
      
      else
        if l.ln_jaql406tip = 'P' then
          ln_Grupo      := 0;
          ln_nrocupones := 0;
          begin
            select f.scgru
              into ln_Grupo
              from fsd011 f
             where f.pgcod = l.ln_jaql406pgc
               and f.scsuc = l.ln_jaql406suc
               and f.scmda = l.ln_jaql406mda
               and f.scpap = l.ln_jaql406pap
               and f.sccta = l.ln_jaql406cta
               and f.scoper = l.ln_jaql406ope
               and f.scsbop = l.ln_jaql406sbo
               and f.sctope = l.ln_jaql406top
               and f.scstat <> 99;
          exception
            when others then
              ln_Grupo := 9999;
          end;
        
          begin
          
            select tp1imp1
              into ln_nrocupones
              from fst198
             where tp1cod = 1
               and tp1cod1 = 10871
               and tp1corr1 = 7
               and tp1corr2 = 153
               and tp1corr3 > 1
               and tp1nro3 = ln_Grupo;
          exception
            when others then
              lc_FlagTipCred := 'N';
          end;
        
          if ln_nrocupones <> 0 then
            lc_FlagTipCred := 'S';
          end if;
        
          if lc_FlagTipCred = 'S' then
            i := 1;
          
            while i <= ln_nrocupones loop
            
              PQ_CR_DUPLICACUPONES.sp_cr_inserta(SQ_CR_JAQL406_2.NEXTVAL,
                                                 L.LN_JAQL406PGC,
                                                 l.ln_jaql406mod,
                                                 l.ln_jaql406suc,
                                                 l.ln_jaql406mda,
                                                 l.ln_jaql406pap,
                                                 l.ln_jaql406cta,
                                                 l.ln_jaql406ope,
                                                 l.ln_jaql406sbo,
                                                 l.ln_jaql406top,
                                                 l.ln_jaql406cred,
                                                 l.ln_jaql406fec,
                                                 l.ln_jaql406fop,
                                                 l.ln_jaql406est,
                                                 l.ln_jaql406usr,
                                                 l.ln_jaql406age,
                                                 l.ln_jaql406dpt,
                                                 l.ln_jaql406ant,
                                                 l.ln_jaql406atr,
                                                 l.ln_jaql406cal,
                                                 'M',
                                                 l.ln_jaql406excup,
                                                 l.ln_jaql406tsbor,
                                                 l.ln_JAQL406tord,
                                                 l.ln_JAQL406tnrel,
                                                 l.ln_JAQL406ttran,
                                                 l.ln_JAQL406tmod,
                                                 l.ln_JAQL406tsuc,
                                                 l.ln_jaql406fcta,
                                                 l.ln_jaql406nump,
                                                 l.ln_jaql406cupnum,
                                                 ln_nrocupones);
            
              i := i + 1;
            
            end loop;
          end if;
        
        end if;
      end if;
    
    end loop;
  
  end sp_cr_InicioTipCred;
  ------------------------------------------------------
  procedure sp_cr_VerTipoCred(ln_instancia   in number,
                              lc_FlagTipCred out varchar2,
                              ln_nrocupones  out number) is
  
    LN_TIPOCRED number;
  
  begin
    -- Tipo de Credito en el flujo
  
    lc_FlagTipCred := 'N';
    ln_nrocupones  := 0;
    begin
      select to_number(REGEXP_REPLACE((UPPER(replace(w.wfattsval, ';', ''))),
                                      '([A-Z])',
                                      ''))
        into LN_TIPOCRED
        from wfattsvalues w
       where w.wfinsprcid = ln_instancia
         and w.wfattsid = 'TIPO_CREDITO';
    exception
      when others then
        null;
    end;
  
    begin
    
      select tp1imp1
        into ln_nrocupones
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10871
         and tp1corr1 = 7
         and tp1corr2 = 153
         and tp1corr3 > 1
         and tp1nro3 = LN_TIPOCRED;
    exception
      when others then
        lc_FlagTipCred := 'N';
    end;
  
    if ln_nrocupones <> 0 then
      lc_FlagTipCred := 'S';
    end if;
  
  end sp_cr_VerTipoCred;
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
                     'PQ_CR_DUPLICACUPONES.sp_cr_InicioDuplica(''' || x ||
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

  -----------------------------------------------------------------------------------
  Procedure sp_cr_JobTipCred(ld_FechaCorte in date) is
  
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    --ln_cont     number(2) := 0;
    -- lc_fecpro char(10);
  
  begin
  
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    begin
      delete from jaql406 where jaql406tip = 'M';
      commit;
    end;
  
    for x in 0 .. 9 loop
    
      lc_variable := ' begin ' ||
                     'PQ_CR_DUPLICACUPONES.sp_cr_InicioTipCred(''' || x || '''' || ',' || '''' ||
                     ld_FechaCorte || ''');' || ' End; ';
    
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
  
  end sp_cr_JobTipCred;
  ------------------------------------------------------------------------------------  
end PQ_CR_DUPLICACUPONES;
/

