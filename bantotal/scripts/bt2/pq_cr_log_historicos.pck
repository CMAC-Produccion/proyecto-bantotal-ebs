create or replace package PQ_CR_LOG_HISTORICOS is
  -- *****************************************************************
  -- Nombre                     : PROGRAMA CAJA
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2021.08.05
  -- Autor de Creación          : EFUENTES
  -- Uso                        : 
  -- Estado                     : Activo
  -- Acceso                     : Público
  --
  -- ****************************************************************

  ------------------------------------------------------------------
  procedure sp_cr_gen_logs(pd_fecha date, pn_instan number);

end PQ_CR_LOG_HISTORICOS;
/

create or replace package body PQ_CR_LOG_HISTORICOS is
  ------------------------------------------------------------------
  procedure sp_cr_gen_logs(pd_fecha date, pn_instan number) is
    lc_hora varchar2(15);
  
    ln_CorrA number;
    ld_fecA  date;
    lv_horA  varchar2(15);
    ln_contA number;
  
    ln_CorrB number;
    ld_fecB  date;
    lv_horB  varchar2(15);
    ln_contB number;
  
    ln_CorrC number;
    ld_fecC  date;
    lv_horC  varchar2(15);
    ln_contC number;
  
    ld_fecD  date;
    ln_contD number;
  
    ld_fecE  date;
    ln_evaE  number;
    ln_contE number;
  
    ln_CorrG number;
    ld_fecG  date;
    lv_horG  varchar2(15);
    ln_contG number;
  
    ln_CorrH number;
    ld_fecH  date;
    lv_horH  varchar2(15);
    ln_contH number;
  
    ln_CorrI number;
    ld_fecI  date;
    lv_horI  varchar2(15);
    ln_contI number;
  
    err_num NUMBER;
    err_msg VARCHAR2(255);
  
  BEGIN
  
    BEGIN
      SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') INTO lc_hora FROM DUAL;
    END;
  
    --jaqy140b - A
    begin
    
      begin
        -- Pyme Ratio
        select max(a.jaqy140corr)
          into ln_CorrA
          from jaqy140b a
         where a.jaqy140inst = pn_instan
           and a.jaqy140est = 'H'; --A
      exception
        when others then
          ln_CorrA := 0;
      end;
    
      begin
        select a.jaqy140fec, a.jaqy140hora
          into ld_fecA, lv_horA
          from jaqy140b a
         where a.jaqy140inst = pn_instan
           and a.jaqy140est = 'H'
           and a.jaqy140corr = ln_CorrA; --A
      exception
        when others then
          null;
      end;
    
      begin
        select count(*)
          into ln_contA
          from aqpb613a a613
         where a613.aqpb613ainst = pn_instan
           and a613.aqpb613afec = ld_fecA
           and a613.aqpb613ahora = lv_horA;
      exception
        when others then
          null;
      end;
    
      if ln_contA = 0 then
        begin
          insert into aqpb613a
            select /*+all_rows*/
             a.*, pd_fecha, lc_hora
              from jaqy140b a
             where a.jaqy140inst = pn_instan
               and a.jaqy140est = 'H';
        exception
          when others then
            null;
        end;
        commit;
      end if;
    
    end;
  
    --jaqy142b - b
    begin
      ------------------------
      begin
        select max(b.jaqy142corr)
          into ln_CorrB
          from jaqy142b b
         where b.jaqy142inst = pn_instan
           and b.jaqy142est = 'H'; --B
      exception
        when others then
          null;
      end;
    
      begin
        select b.jaqy142fec, b.jaqy142hora
          into ld_fecB, lv_horB
          from jaqy142b b
         where b.jaqy142inst = pn_instan
           and b.jaqy142est = 'H'
           and b.jaqy142corr = ln_CorrB; --B
      exception
        when others then
          null;
      end;
    
      begin
        select count(*)
          into ln_contB
          from aqpb613b b613
         where b613.aqpb613binst = pn_instan
           and b613.aqpb613bfec = ld_fecB
           and b613.aqpb613bhora = lv_horB;
      exception
        when others then
          null;
      end;
    
      if ln_contB = 0 then
        begin
          insert into aqpb613b
            select /*+all_rows*/
             b.*, pd_fecha, lc_hora
              from jaqy142b b
             where b.jaqy142inst = pn_instan
               and b.jaqy142est = 'H';
        exception
          when others then
            null;
        end;
        commit;
      end if;
    
    end;
  
    --aqpb081 - c
    begin
      ------------------------
      -- Panel Saldo Deudor Pyme
    
      begin
        select max(c.aqpb081corr)
          into ln_CorrC
          from aqpb081 c
         where c.aqpb081inst = pn_instan
           and c.aqpb081esta = 'S'; --C
      exception
        when others then
          null;
      end;
    
      begin
        select c.aqpb081fech, c.aqpb081hora
          into ld_fecC, lv_horC
          from aqpb081 c
         where c.aqpb081inst = pn_instan
           and c.aqpb081esta = 'S'
           and c.aqpb081corr = ln_CorrC; --C
      exception
        when others then
          null;
      end;
    
      begin
        select count(*)
          into ln_contC
          from aqpb613c c613
         where c613.aqpb613cinst = pn_instan
           and c613.aqpb613cfech = ld_fecC
           and c613.aqpb613chora = lv_horC;
      exception
        when others then
          null;
      end;
    
      if ln_contC = 0 then
        begin
          insert into aqpb613c
            select /*+all_rows*/
             c.*, pd_fecha, lc_hora
              from aqpb081 c
             where c.aqpb081inst = pn_instan
               and c.aqpb081esta = 'S'; --C;
        exception
          when others then
            null;
        end;
      
        commit;
      end if;
    
    end;
  
    --jaqz515 - D
    begin
      ------------------------
      -- Evaluacion Pyme
      begin
        select max(d.jaqz515fep)
          into ld_fecD
          from jaqz515 d
         where d.jaqz515ins = pn_instan; --D
      exception
        when others then
          null;
      end;
    
      begin
        select count(*)
          into ln_contD
          from aqpb613d d613
         where d613.aqpb613dins = pn_instan
           and d613.aqpb613dfep = ld_fecD;
      exception
        when others then
          null;
      end;
    
      if ln_contD = 0 then
        begin
          insert into aqpb613d
            select /*+all_rows*/
             d.*, pd_fecha, lc_hora
              from jaqz515 d
             where d.jaqz515ins = pn_instan; --D
        exception
          when others then
            null;
        end;
        commit;
      end if;
    
    end;
  
    --jaqz516 - E
    begin
      ------------------------
      begin
        select max(e.jaqz516fec)
          into ld_fecE
          from jaqz516 e
         where e.jaqz516sol = pn_instan; --E
      exception
        when others then
          null;
      end;
    
      begin
        select e.jaqz516eval
          into ln_evaE
          from jaqz516 e
         where e.jaqz516sol = pn_instan; --E
      exception
        when others then
          null;
      end;
    
      begin
        select count(*)
          into ln_contE
          from aqpb613e e613
         where e613.aqpb613esol = pn_instan
           and e613.aqpb613efec = ld_fecE;
      exception
        when others then
          null;
      end;
    
      if ln_contE = 0 then
        begin
          insert into aqpb613e
            select /*+all_rows*/
             e.*, pd_fecha, lc_hora
              from jaqz516 e
             where e.jaqz516sol = pn_instan; --E
        exception
          when others then
            null;
        end;
      
        --jaqz517 - F
        begin
          insert into aqpb613f
            select /*+all_rows*/
             f.*, pd_fecha, lc_hora
              from jaqz517 f
             where f.jaqz517eval = ln_evaE; --F
        exception
          when others then
            null;
        end;
      
        commit;
      end if;
    end;
  
    --jaqz821b - G
    begin
      ------------------------
      -- Consumo Ratio
      begin
        select max(g.jaqz821corr)
          into ln_CorrG
          from jaqz821b g
         where g.jaqz821inst = pn_instan
           and g.jaqz821est = 'H'; --G
      exception
        when others then
          null;
      end;
    
      begin
        select g.jaqz821fec, g.jaqz821hora
          into ld_fecG, lv_horG
          from jaqz821b g
         where g.jaqz821inst = pn_instan
           and g.jaqz821est = 'H'
           and g.jaqz821corr = ln_CorrG; --G
      exception
        when others then
          null;
      end;
    
      begin
        select count(*)
          into ln_contG
          from aqpb613g g613
         where g613.aqpb613ginst = pn_instan
           and g613.aqpb613gfec = ld_fecG
           and g613.aqpb613ghora = lv_horG;
      exception
        when others then
          null;
      end;
    
      if ln_contG = 0 then
        begin
          insert into aqpb613g
            select /*+all_rows*/
             g.*, pd_fecha, lc_hora
              from jaqz821b g
             where g.jaqz821inst = pn_instan
               and g.jaqz821est = 'H'; --G
        exception
          when others then
            null;
        end;
        commit;
      end if;
    
    end;
  
    --jaqz822b - H
    begin
      ------------------------
      begin
        select max(h.jaqz822corr)
          into ln_CorrH
          from jaqz822b h
         where h.jaqz822inst = pn_instan
           and h.jaqz822est = 'H'; --H
      exception
        when others then
          null;
      end;
    
      begin
        select h.jaqz822fec, h.jaqz822hora
          into ld_fecH, lv_horH
          from jaqz822b h
         where h.jaqz822inst = pn_instan
           and h.jaqz822est = 'H' --H
           and h.JAQZ822CORR = ln_CorrH;
      exception
        when others then
          null;
      end;
    
      begin
        select count(*)
          into ln_contH
          from aqpb613h h613
         where h613.AQPB613HINST = pn_instan
           and H613.AQPB613HFEC = ld_fecH
           and h613.AQPB613HHORA = lv_horH;
      exception
        when others then
          null;
      end;
    
      if ln_contH = 0 then
        begin
          insert into aqpb613h
            select /*+all_rows*/
             h.*, pd_fecha, lc_hora
              from jaqz822b h
             where h.jaqz822inst = pn_instan
               and h.jaqz822est = 'H'; --H
        exception
          when others then
            null;
        end;
        commit;
      end if;
    
    end;
  
    --aqpb357 - I
    begin
      ------------------------
      -- Panel Saldo Deudor Consumo
      begin
        select max(i.aqpb357corr)
          into ln_CorrI
          from aqpb357 i
         where i.aqpb357inst = pn_instan; --I
      exception
        when others then
          null;
      end;
    
      begin
        select i.aqpb357fech, i.aqpb357hora
          into ld_fecI, lv_horI
          from aqpb357 i
         where i.aqpb357inst = pn_instan --I
           and i.AQPB357CORR = ln_CorrI;
      exception
        when others then
          null;
      end;
    
      begin
        select count(*)
          into ln_contI
          from aqpb613i i613
         where i613.AQPB613IINST = pn_instan
           and i613.AQPB613IFECH = ld_fecH
           and i613.AQPB613IHORA = lv_horH;
      exception
        when others then
          null;
      end;
    
      if ln_contI = 0 then
        begin
          insert into aqpb613i
            select /*+all_rows*/
             i.*, pd_fecha, lc_hora
              from aqpb357 i
             where i.aqpb357inst = pn_instan; --I
        exception
          when others then
            null;
        end;
        commit;
      end if;
    end;
  
    --jaqm400 - J    
    begin
      ------------------------
      -- Evaluacion Consumo
      insert into aqpb613j
        select /*+all_rows*/
         j.*, pd_fecha, lc_hora
          from jaqm400 j
         where j.jaqm400ins = pn_instan; --J  
    exception
      when others then
        null;
      
    end;
    commit;
  
  END sp_cr_gen_logs;

end PQ_CR_LOG_HISTORICOS;
/

