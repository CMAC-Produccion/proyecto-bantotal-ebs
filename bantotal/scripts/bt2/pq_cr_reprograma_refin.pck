create or replace package PQ_CR_REPROGRAMA_REFIN is

  -- Author  : MPOSTIGOC
  -- Created : 12/06/2020 9:44:03 p. m.
  -- Purpose : 

  -- Public type declarations
  procedure sp_cr_tipo_refihipot(ln_instancia in number,
                                 lc_RefHip    out varchar2);
  ------------------------------------------------------------------------------
  procedure sp_cr_insert378(ln_inst   in number,
                            ln_pgcod  in number,
                            ln_mod    in number,
                            ln_suc    in number,
                            ln_mda    in number,
                            ln_pap    in number,
                            ln_cta    in number,
                            ln_ope    in number,
                            ln_sbop   in number,
                            ln_tope   in number,
                            ln_instc  in number,
                            ln_tcred  in number,
                            lc_dtcred in varchar2);

end PQ_CR_REPROGRAMA_REFIN;
/

create or replace package body PQ_CR_REPROGRAMA_REFIN is

  procedure sp_cr_tipo_refihipot(ln_instancia in number,
                                 lc_RefHip    out varchar2) is
  
    cursor lista is
      select x.xwfempresa,
             x.xwfsucursal,
             x.xwfmodulo,
             x.xwfmoneda,
             x.xwfpapel,
             x.xwfcuenta,
             x.xwfoperacion,
             x.xwfsubope,
             x.xwftipope
        from xwf700 x
       where x.xwfprcins = ln_instancia
         and x.xwfcar3 <> '1';
  
    ln_ori      number := 0;
    LN_TIPOCRED number;
    lc_tipcred  varchar2(30);
    ln_instcred number;
    ln_NroTotal number := 0;
    ln_NroHipot number := 0;
  
  begin
  
    lc_RefHip := 'N';
  
    begin
      delete aqpa378 a where a.aqpa378inst = ln_instancia;
      commit;
    end;
  
    begin
      select s.sng001ori
        into ln_ori
        from sng001 s
       where s.sng001inst = ln_instancia;
    exception
      when others then
        null;
    end;
  
    if ln_ori = 3 then
    
      for l in lista loop
      
        begin
          ln_instcred := fn_instancia_credito(v_Scmod  => l.xwfmodulo,
                                              v_Scsuc  => l.xwfsucursal,
                                              v_Scmda  => l.xwfmoneda,
                                              v_Scpap  => l.xwfpapel,
                                              v_Sccta  => l.xwfcuenta,
                                              v_Scoper => l.xwfoperacion,
                                              v_Scsbop => l.xwfsubope,
                                              v_Sctope => l.xwftipope);
        end;
      
        if ln_instcred > 0 then
        
          begin
            select w.wfattsval
              into lc_tipcred
              from wfattsvalues w
             where w.wfinsprcid = ln_instcred
               and w.wfattsid = 'TIPO_CREDITO';
          exception
            when others then
              null;
          end;
        
          LN_TIPOCRED := to_number(substr(lc_tipcred,
                                          1,
                                          INSTR(lc_tipcred, ';') - 1));
        
          pq_cr_reprograma_refin.sp_cr_insert378(ln_inst   => ln_instancia,
                                                 ln_pgcod  => l.xwfempresa,
                                                 ln_mod    => l.xwfmodulo,
                                                 ln_suc    => l.xwfsucursal,
                                                 ln_mda    => l.xwfmoneda,
                                                 ln_pap    => l.xwfpapel,
                                                 ln_cta    => l.xwfcuenta,
                                                 ln_ope    => l.xwfoperacion,
                                                 ln_sbop   => l.xwfsubope,
                                                 ln_tope   => l.xwftipope,
                                                 ln_instc  => ln_instcred,
                                                 ln_tcred  => LN_TIPOCRED,
                                                 lc_dtcred => lc_tipcred);
        end if;
      
      end loop;
    
      begin
        select count(*)
          into ln_NroTotal
          from aqpa378 a
         where a.aqpa378inst = ln_instancia;
      exception
        when others then
          ln_NroTotal := 0;
      end;
    
      begin
        select count(*)
          into ln_NroHipot
          from aqpa378 a
         where a.aqpa378inst = ln_instancia
           and a.aqpa378tcred = 4;
      exception
        when others then
          ln_NroHipot := 0;
      end;
    
      ln_NroTotal := nvl(ln_NroTotal, 0);
      ln_NroHipot := nvl(ln_NroHipot, 0);
    
      if ln_NroHipot > 0 then
        if ln_NroTotal = ln_NroHipot then
          lc_RefHip := 'N';
        else
          if ln_NroTotal <> ln_NroHipot then
            lc_RefHip := 'S';
          end if;
        end if;
      else
        lc_RefHip := 'N';
      end if;
    else
      lc_RefHip := 'N';
    end if;
  
  end sp_cr_tipo_refihipot;
  ----------------------------------------------------
  procedure sp_cr_insert378(ln_inst   in number,
                            ln_pgcod  in number,
                            ln_mod    in number,
                            ln_suc    in number,
                            ln_mda    in number,
                            ln_pap    in number,
                            ln_cta    in number,
                            ln_ope    in number,
                            ln_sbop   in number,
                            ln_tope   in number,
                            ln_instc  in number,
                            ln_tcred  in number,
                            lc_dtcred in varchar2) is
    ln_corr number;
    lc_hora char(8) := '00:00:00';
    ld_fec  date;
  
  begin
  
    begin
      select max(a.aqpa378corr)
        into ln_corr
        from aqpa378 a
       where a.aqpa378inst = ln_inst;
    exception
      when others then
        ln_corr := 0;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    begin
      select f.pgfape into ld_fec from FST017 f where f.pgcod = 1;
    end;
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    begin
      insert into aqpa378
        (aqpa378corr,
         aqpa378fec,
         aqpa378hora,
         aqpa378inst,
         aqpa378pgcod,
         aqpa378mod,
         aqpa378suc,
         aqpa378mda,
         aqpa378pap,
         aqpa378cta,
         aqpa378ope,
         aqpa378sbop,
         aqpa378tope,
         aqpa378instc,
         aqpa378tcred,
         Aqpa378dtcred)
      values
        (ln_corr + 1,
         ld_fec,
         lc_hora,
         ln_inst,
         ln_pgcod,
         ln_mod,
         ln_suc,
         ln_mda,
         ln_pap,
         ln_cta,
         ln_ope,
         ln_sbop,
         ln_tope,
         ln_instc,
         ln_tcred,
         lc_dtcred);
      commit;
    end;
  
  end sp_cr_insert378;
  ----------------------------------------------------
end PQ_CR_REPROGRAMA_REFIN;
/

