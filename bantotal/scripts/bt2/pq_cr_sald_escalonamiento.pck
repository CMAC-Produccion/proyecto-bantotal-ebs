create or replace package PQ_CR_SALD_ESCALONAMIENTO is
  -- *****************************************************************
  -- Nombre                     : Proceso que calcula el % de avance para escalonamiento
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 10/09/2024 10:45:17
  -- Autor de Creación          : MARIA POSTIGO
  -- Uso                        : Proceso que calcula el % de avance para escalonamiento
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación:   
  -- *****************************************************************

  procedure sp_cr_PorcAvance(ln_instancia  in number,
                             ln_PorcAvance out number);
  -------------------------------------------------------------
  procedure sp_cr_SaldVgnt(ln_instancia in number, ln_SaldVgnt out number);
  ----------------------------------------------------------------
  procedure sp_Cr_SaldConsUltDesm(ln_instancia      in number,
                                  ln_InstDesemb     out number,
                                  ln_SaldConsDesemb out number,
                                  ln_MntUtil        out number,
                                  ln_SaldoAntg      out number);
  -------------------------------------------------------------------------
  procedure sp_cr_LogAQPB181(ln_inst   in number,
                             ln_sldvig in number,
                             ln_insdes in number,
                             ln_slcdes in number,
                             ln_mntlin in number,
                             ln_sldant in number,
                             ln_avance in number);

end PQ_CR_SALD_ESCALONAMIENTO;
/

create or replace package body PQ_CR_SALD_ESCALONAMIENTO is

  procedure sp_cr_PorcAvance(ln_instancia  in number,
                             ln_PorcAvance out number) is
  
    ln_SaldoVgnt number(17, 2) := 0.00;
    ln_SaldoAntg number(17, 2) := 0.00;
    ln_InstAux   number;
    ln_SaldAux   number(17, 2) := 0.00;
    ln_MntLinea  number(17, 2) := 0.00;
  
  begin
  
    ln_PorcAvance := 0;
  
    begin
      update aqpb181 a
         set a.aqpb181est = 'I'
       where a.aqpb181inst = ln_instancia;
      commit;
    end;
  
    pq_Cr_sald_escalonamiento.sp_cr_SaldVgnt(ln_instancia, ln_SaldoVgnt);
    pq_Cr_sald_escalonamiento.sp_Cr_SaldConsUltDesm(ln_instancia      => ln_instancia,
                                                    ln_InstDesemb     => ln_InstAux,
                                                    ln_SaldConsDesemb => ln_SaldAux,
                                                    ln_MntUtil        => ln_MntLinea,
                                                    ln_SaldoAntg      => ln_SaldoAntg);
  
    if ln_SaldoAntg > 0 then
    
      ln_PorcAvance := 1 - (nvl(ln_SaldoVgnt, 0) / nvl(ln_SaldoAntg, 0));
    
    else
      ln_PorcAvance := 9999;
    
    end if;
  
    pq_Cr_sald_escalonamiento.sp_cr_LogAQPB181(ln_inst   => ln_instancia,
                                               ln_sldvig => nvl(ln_SaldoVgnt,
                                                                0),
                                               ln_insdes => nvl(ln_InstAux,
                                                                0),
                                               ln_slcdes => nvl(ln_SaldAux,
                                                                0),
                                               ln_mntlin => nvl(ln_MntLinea,
                                                                0),
                                               ln_sldant => nvl(ln_SaldoAntg,
                                                                0),
                                               ln_avance => ln_PorcAvance);
  
  end sp_cr_PorcAvance;
  -----------------------------------------------------------------------
  procedure sp_cr_SaldVgnt(ln_instancia in number, ln_SaldVgnt out number) is
  
    cursor inserta(ln_Pepais number, ln_Petdoc number, ln_Pendoc varchar2) is
      select d10.pgcod    ln_pgcod10,
             d10.aomod    ln_mod10,
             d10.aosuc    ln_suc10,
             d10.aomda    ln_mda10,
             d10.aopap    ln_pap10,
             d10.aocta    ln_cta10,
             d10.aooper   ln_oper10,
             d10.aosbop   ln_sbop10,
             d10.aotope   ln_tope10,
             d10.aoperiod ln_peri10
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc)
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 17
                                        and a.tp1corr2 = 1))) or
             d10.Aomod in (141))
         and d10.Aostat <> 99;
  
    lc_Vinculado varchar2(5) := 'N';
    ln_Pepais    number;
    ln_Petdoc    number;
    ln_Pendoc    varchar2(12);
    -- ln_captotcaja number;
    tipocambio   number(14, 8) := 0.00;
    ld_fecpro    date;
    ln_capacidad number;
    lc_fgAdic    varchar2(1);
    lc_fgAmpl    varchar2(1);
    ln_indicador number;
    lc_fgRefLin  varchar2(1) := 'N';
    lc_fgRepro   varchar2(2);
  
  begin
  
    --  ln_captotcaja := 0;
  
    begin
      select f.pgfape into ld_fecpro from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_Pepais, ln_Petdoc, ln_Pendoc
        from sng001 s
       where s.sng001inst = ln_instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select S.SNG120TCbi
        into tipocambio
        from sng120 s
       where s.sng120ins = ln_Instancia
         and s.sng120tsk = 'EVALUACION';
    exception
      when others then
        tipocambio := 0.0000;
    end;
  
    if tipocambio = 0 then
      tipocambio := fn_tipo_cambio_fijo(P_FECHA => ld_fecpro);
    end if;
  
    for i in inserta(ln_Pepais, ln_Petdoc, ln_Pendoc) loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
    
      PQ_CR_RESOLUTOR_AUTONOMIA.sp_resolutor(i.ln_pgcod10,
                                             i.ln_mod10,
                                             i.ln_suc10,
                                             i.ln_mda10,
                                             i.ln_pap10,
                                             i.ln_cta10,
                                             i.ln_oper10,
                                             i.ln_sbop10,
                                             i.ln_tope10,
                                             tipocambio,
                                             lc_fgRefLin,
                                             ln_Instancia,
                                             ln_capacidad);
    
      ln_SaldVgnt := nvl(ln_SaldVgnt, 0) + nvl(ln_capacidad, 0);
    
    end loop;
  
  end sp_cr_SaldVgnt;
  -----------------------------------------------------------------------
  procedure sp_Cr_SaldConsUltDesm(ln_instancia      in number,
                                  ln_InstDesemb     out number,
                                  ln_SaldConsDesemb out number,
                                  ln_MntUtil        out number,
                                  ln_SaldoAntg      out number) is
  
    ld_FchMaxDesVig date;
    ln_pgcod        number;
    ln_mod          number;
    ln_suc          number;
    ln_mda          number;
    ln_pap          number;
    ln_cta          number;
    ln_ope          number;
    ln_sbop         number;
    ln_tope         number;
    --  ln_InstDesemb     number;
    --  ln_SaldConsDesemb number(17, 2) := 0.00;
    ln_TieneLineas number;
    ln_ModEva      number;
    --  ln_MntUtil     number(17, 2) := 0.00;
  
  begin
  
    begin
      select max(f.aofval)
        into ld_FchMaxDesVig
        from fsd010 f
       where f.pgcod = 1
         and f.aomod in
             (select s.modulo
                from fst111 s
               where s.dscod = 50
                 and s.modulo not in (29, 33, 108, 116, 120, 142, 144, 200)) ----
         and f.aomda in (0, 101)
         and f.aocta in (select r.ctnro
                           from fsr008 r, sng001 n
                          where r.pepais = n.sng001pais
                            and r.petdoc = n.sng001tdoc
                            and r.pendoc = n.sng001ndoc
                            and r.cttfir = 'T'
                            and n.sng001inst = ln_instancia);
    exception
      when others then
        null;
    end;
  
    if ld_FchMaxDesVig is not null then
      begin
        select f.pgcod,
               f.aomod,
               f.aosuc,
               f.aomda,
               f.aopap,
               f.aocta,
               f.aooper,
               f.aosbop,
               f.aotope
          into ln_pgcod,
               ln_mod,
               ln_suc,
               ln_mda,
               ln_pap,
               ln_cta,
               ln_ope,
               ln_sbop,
               ln_tope
          from fsd010 f
         where f.pgcod = 1
           and f.aomod in
               (select s.modulo
                  from fst111 s
                 where s.dscod = 50
                   and s.modulo not in
                       (29, 33, 108, 116, 120, 142, 144, 200)) ----
           and f.aomda in (0, 101)
           and f.aocta in (select r.ctnro
                             from fsr008 r, sng001 n
                            where r.pepais = n.sng001pais
                              and r.petdoc = n.sng001tdoc
                              and r.pendoc = n.sng001ndoc
                              and r.cttfir = 'T'
                              and n.sng001inst = ln_instancia)
           and f.aofval = ld_FchMaxDesVig
           and rownum = 1;
      exception
        when others then
          null;
      end;
    
      sp_cr_instancia(ln_Scmod     => ln_mod,
                      ln_Scsuc     => ln_suc,
                      ln_Scmda     => ln_mda,
                      ln_Scpap     => ln_pap,
                      ln_Sccta     => ln_cta,
                      ln_Scoper    => ln_ope,
                      ln_Scsbop    => ln_sbop,
                      ln_Sctope    => ln_tope,
                      ln_instancia => ln_InstDesemb);
    
      begin
        select to_number(trim(replace(g.pae71val, ',', '.')),
                         '99999999999999D99')
          into ln_SaldConsDesemb
          from fpae71 g
         where g.pae51eva = 3
           and g.pae70nro = (select max(f.pae70nro)
                               from fpae70 f
                              where f.pae70ins = ln_InstDesemb
                                and f.pae51eva = 3)
           and g.pae71ite = 397;
      exception
        when others then
          ln_SaldConsDesemb := 0;
        
      end;
      /* insert into prueba_log
        (pgcod, msg)
      values
        (900, 'ln_SaldConsDesemb' || ln_SaldConsDesemb);
      commit;*/
      begin
        select s.sng021tmod
          into ln_ModEva
          from sng021 s
         where s.sng021sol = ln_InstDesemb;
      exception
        when others then
          null;
      end;
    
      begin
        select count(*)
          into ln_TieneLineas
          from jaqy142 j
         where j.jaqy142inst = ln_InstDesemb
           and j.jaqy142mod in (117, 116)
           and j.jaqy142tarea = 7
           and j.jaqy142est = 'H';
      exception
        when others then
          null;
      end;
    
      if ln_TieneLineas > 0 then
        if ln_ModEva = 13 then
          begin
            select sum(j.jaqy327util)
              into ln_MntUtil
              from jaqy327 j
             where j.jaqy327inst = ln_InstDesemb
               and j.jaqy327esta = 'S'
               and j.jaqy327cent = '00104';
          exception
            when others then
              null;
          end;
        
        else
          if ln_ModEva = 14 then
          
            begin
              select sum(j.jaqz862util)
                into ln_MntUtil
                from jaqz862 j
               where j.jaqz862inst = ln_InstDesemb
                 and j.jaqz862esta = 'S'
                 and j.jaqz862cent = '00104';
            exception
              when others then
                null;
            end;
          end if;
        end if;
      end if;
    end if;
  
    ln_SaldoAntg := nvl(ln_SaldConsDesemb, 0) - nvl(ln_MntUtil, 0);
  
  end sp_Cr_SaldConsUltDesm;
  -------------------------------------------------------------------
  procedure sp_cr_LogAQPB181(ln_inst   in number,
                             ln_sldvig in number,
                             ln_insdes in number,
                             ln_slcdes in number,
                             ln_mntlin in number,
                             ln_sldant in number,
                             ln_avance in number) is
  
    ln_corr  number;
    lc_hora  char(8) := '00:00:00';
    ld_fecha date;
  
  begin
  
    begin
      select max(a.aqpb181cor)
        into ln_corr
        from aqpb181 a
       where a.aqpb181inst = ln_inst;
    exception
      when others then
        ln_corr := 0;
    end;
    ln_corr := nvl(ln_corr, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
    end;
  
    begin
      select f.pgfape into ld_fecha from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      insert into aqpb181
        (aqpb181cor,
         aqpb181inst,
         aqpb181fecha,
         aqpb181hora,
         aqpb181sldvig,
         aqpb181insdes,
         aqpb181slcdes,
         aqpb181mntlin,
         aqpb181sldant,
         aqpb181avance,
         aqpb181est)
      values
        (ln_corr + 1,
         ln_inst,
         ld_fecha,
         lc_hora,
         ln_sldvig,
         ln_insdes,
         ln_slcdes,
         ln_mntlin,
         ln_sldant,
         ln_avance,
         'H');
    end;
    commit;
  
  end sp_cr_LogAQPB181;
  --------------------------------------------------------
end PQ_CR_SALD_ESCALONAMIENTO;
/

