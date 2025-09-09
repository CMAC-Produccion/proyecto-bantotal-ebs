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
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- *****************************************************************

  procedure sp_cr_CargaLimiteR;

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
  -------
end PQ_CR_LIMITE_REPROG;
/
