create or replace package PQ_CR_LIMITE_REPROG is

  -- *****************************************************************
  -- Nombre                     : PQ_CR_LIMITE_REPROG
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 15/07/2025 11:54:12
  -- Autor de Creación          : MARIA POSTIGO
  -- Uso                        : Proceso de Carga para Control de Limite de Reprogramaciones por Mes
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 30/10/2025
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se agrego los procedimientos para la carga de limites por agencia y Nacional
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- *****************************************************************

  procedure sp_cr_CargaLimiteR;
  -----------------------------------------------
  procedure sp_cr_CargaLimiteAgencia;
  -----------------------------------------------
  procedure sp_cr_CargaLimNacional;

end PQ_CR_LIMITE_REPROG;
/
create or replace package body PQ_CR_LIMITE_REPROG is

  procedure sp_cr_CargaLimiteR is
  
    cursor LimteRegion is
      select rownum ln_corr,
             a.aqpb200afecha,
             a.aqpb200acodreg,
             a.aqpb200aregion,
             a.aqpb200anumrd,
             a.aqpb200adenomdr,
             a.aqpb200aratrisk
        from USRBNDJ.aqpb200a a;
  
    lc_hora        varchar2(8) := '00:00:00';
    ld_fchaSist    date;
    ln_CInfoPuente number(17);
    ln_SaldLimReg  number(17, 2) := 0.00;
    ld_FchCarga    date;
    ln_MaxLimt     number(10, 4);
  
  begin
  
    begin
      select f.pgfape into ld_fchaSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
    end;
  
    begin
      select count(*) into ln_CInfoPuente from USRBNDJ.aqpb200a a;
    exception
      when others then
        null;
    end;
  
    if ln_CInfoPuente > 0 then
    
      begin
        select max(a.aqpb200afecha)
          into ld_FchCarga
          from USRBNDJ.aqpb200a a;
      exception
        when others then
          null;
      end;
    
      begin
        update aqpb200 a
           set a.aqpb200est = 'I'
         where a.aqpb200fecha = ld_FchCarga;
        commit;
      end;
    
      for l in LimteRegion loop
      
        ln_MaxLimt := 0;
      
        begin
          select f.tp1imp1 / 100
            into ln_MaxLimt
            from fst198 f
           where f.tp1cod = 1
             and f.tp1cod1 = 10899
             and f.tp1corr1 = 152
             and f.tp1corr2 = 1
             and f.tp1nro3 = l.aqpb200acodreg;
        exception
          when others then
            ln_MaxLimt := 0;
        end;
      
        ln_SaldLimReg := l.aqpb200adenomdr * ln_MaxLimt;
      
        begin
          insert into aqpb200
            (aqpb200cor,
             aqpb200fecha,
             aqpb200codreg,
             aqpb200region,
             aqpb200numrd,
             aqpb200denomdr,
             aqpb200saldcalt,
             aqpb200ratrisk,
             aqpb200freg,
             aqpb200hora,
             aqpb200mntact,
             aqpb200saldrep,
             aqpb200est)
          values
            (l.ln_corr,
             l.aqpb200afecha,
             l.aqpb200acodreg,
             l.aqpb200aregion,
             l.aqpb200anumrd,
             l.aqpb200adenomdr,
             ln_SaldLimReg,
             l.aqpb200aratrisk,
             ld_fchaSist,
             lc_hora,
             l.aqpb200anumrd,
             ln_SaldLimReg - l.aqpb200anumrd,
             'H');
          commit;
        end;
      end loop;
    end if;
  end;
  --------------------------------------------------------------------------
  procedure sp_cr_CargaLimiteAgencia is
  
    cursor LimteAgencia is
      select rownum ln_corr,
             a.aqpd064aregion,
             a.aqpd064acodreg,
             a.aqpd064azona,
             a.aqpd064acodzon,
             a.aqpd064asucur,
             a.aqpd064acodsuc,
             a.aqpd064asaldd,
             a.aqpd064asaldm,
             a.aqpd064aratrisk,
             a.aqpd064afecha
        from USRBNDJ.aqpd064a a;
  
    lc_hora        varchar2(8) := '00:00:00';
    ld_fchaSist    date;
    ln_CInfoPuente number(17);
    ln_SaldLimReg  number(17, 2) := 0.00;
    ld_FchCarga    date;
    ln_MaxLimt     number(10, 4);
  
  begin
  
    begin
      select f.pgfape into ld_fchaSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
    end;
  
    begin
      select count(*) into ln_CInfoPuente from USRBNDJ.aqpd064a a;
    exception
      when others then
        null;
    end;
  
    if ln_CInfoPuente > 0 then
    
      begin
        select max(a.aqpd064afecha)
          into ld_FchCarga
          from USRBNDJ.aqpd064a a;
      exception
        when others then
          null;
      end;
    
      begin
        update aqpd064 a
           set a.aqpd064est = 'I'
         where a.aqpd064fecha = ld_FchCarga;
        commit;
      end;
    
      for l in LimteAgencia loop
      
        ln_MaxLimt := 0;
      
        begin
          select f.tp1imp1
            into ln_MaxLimt
            from fst198 f
           where f.tp1cod = 1
             and f.tp1cod1 = 10899
             and f.tp1corr1 = 152
             and f.tp1corr2 = 2
             and f.tp1nro3 = l.aqpd064acodsuc;
        exception
          when others then
            ln_MaxLimt := 0;
        end;
      
        ln_SaldLimReg := l.aqpd064asaldm * ln_MaxLimt;
      
        begin
          insert into aqpd064
            (aqpd064cor,
             aqpd064fecha,
             aqpd064region,
             aqpd064codreg,
             aqpd064zona,
             aqpd064codzon,
             aqpd064sucur,
             aqpd064codsuc,
             aqpd064saldd,
             aqpd064saldm,
             aqpd064ratrisk,
             aqpd064freg,
             aqpd064hora,
             aqpd064saldlmt,
             aqpd064mntact,
             aqpd064sldrepage,
             aqpd064est)
          values
            (l.ln_corr,
             l.aqpd064afecha,
             l.aqpd064aregion,
             l.aqpd064acodreg,
             l.aqpd064azona,
             l.aqpd064acodzon,
             l.aqpd064asucur,
             l.aqpd064acodsuc,
             l.aqpd064asaldd,
             l.aqpd064asaldm,
             l.aqpd064aratrisk,
             ld_fchaSist,
             lc_hora,
             ln_SaldLimReg,
             l.aqpd064asaldm,
             ln_SaldLimReg - l.aqpd064asaldm,
             'H');
          commit;
        end;
      end loop;
    end if;
  end sp_cr_CargaLimiteAgencia;
  -----------------------------------------------------------------------------------
  procedure sp_cr_CargaLimNacional is
  
    cursor LimteRegion is
      select rownum ln_corr,
             a.aqpd065apais,
             a.aqpd065acodpais,
             a.aqpd065asaldd,
             a.aqpd065asaldm,
             a.aqpd065aratrisk,
             a.aqpd065afecha
        from USRBNDJ.aqpd065a a;
  
    lc_hora        varchar2(8) := '00:00:00';
    ld_fchaSist    date;
    ln_CInfoPuente number(17);
    ln_SaldLimReg  number(17, 2) := 0.00;
    ld_FchCarga    date;
    ln_MaxLimt     number(10, 4);
  
  begin
  
    begin
      select f.pgfape into ld_fchaSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
    end;
  
    begin
      select count(*) into ln_CInfoPuente from USRBNDJ.aqpd065a a;
    exception
      when others then
        null;
    end;
  
    if ln_CInfoPuente > 0 then
    
      begin
        select max(a.aqpd065afecha)
          into ld_FchCarga
          from USRBNDJ.aqpd065a a;
      exception
        when others then
          null;
      end;
    
      begin
        update aqpd065 a
           set a.aqpd065est = 'I'
         where a.aqpd065fecha = ld_FchCarga;
        commit;
      end;
    
      for l in LimteRegion loop
      
        ln_MaxLimt := 0;
      
        begin
          select f.tp1imp1
            into ln_MaxLimt
            from fst198 f
           where f.tp1cod = 1
             and f.tp1cod1 = 10899
             and f.tp1corr1 = 152
             and f.tp1corr2 = 3
             and f.tp1nro3 = l.aqpd065acodpais;
        exception
          when others then
            ln_MaxLimt := 0;
        end;
      
        ln_SaldLimReg := l.aqpd065asaldm * ln_MaxLimt;
      
        begin
          insert into aqpd065
            (aqpd065cor,
             aqpd065fecha,
             aqpd065pais,
             aqpd065codpais,
             aqpd065saldd,
             aqpd065saldm,
             aqpd065ratrisk,
             aqpd065freg,
             aqpd065hora,
             aqpd065saldlmt,
             aqpd065mntact,
             aqpd065sldrepnac,
             aqpd065est)
          values
            (l.ln_corr,
             l.aqpd065afecha,
             l.aqpd065apais,
             l.aqpd065acodpais,
             l.aqpd065asaldd,
             l.aqpd065asaldm,
             l.aqpd065aratrisk,
             ld_fchaSist,
             lc_hora,
             ln_SaldLimReg,
             l.aqpd065asaldm,
             ln_SaldLimReg - l.aqpd065asaldm,
             'H');
          commit;
        end;
      end loop;
    end if;
  end sp_cr_CargaLimNacional;
  -------------------------------------------------------------------------------------
end PQ_CR_LIMITE_REPROG;
/
