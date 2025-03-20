create or replace package PQ_CR_VERIF_LOGRATIOS is

  -- Author  : MPOSTIGOC
  -- Created : 24/09/2018 9:58:24 a. m.
  -- Purpose : 

  procedure sp_cr_VerfLogRatios(ln_Instancia     in number,
                                ln_VerfLogRatios out varchar2);
  procedure sp_cr_VerfLogRatDesem(ln_Instancia     in number,
                                  ln_VerfLogRatios out varchar2);

end PQ_CR_VERIF_LOGRATIOS;
/

create or replace package body PQ_CR_VERIF_LOGRATIOS is

  procedure sp_cr_VerfLogRatios(ln_Instancia     in number,
                                ln_VerfLogRatios out varchar2) is
  
    ln_RCRCAB  number := 0;
    ln_RPPCAB  number := 0;
    ln_RCNSCAB number := 0;
    ln_RCNVDET number := 0;
    ln_RCNVCAB number := 0;
    ln_modulo  number;
  
  begin
  
    ln_VerfLogRatios := 'N';
  
    begin
      select distinct x.xwfmodulo -- 31/05/2019 mpostigoc
        into ln_modulo
        from xwf700 x
       where x.xwfprcins = ln_Instancia
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    if ln_modulo <> 107 then
      -- 31/05/2019 mpostigoc
    
      begin
        select count(*)
          into ln_RCRCAB
          from jaqy140 j
         where j.jaqy140inst = ln_Instancia
           and j.jaqy140est = 'H';
      exception
        when others then
          ln_RCRCAB := 0;
      end;
    
      begin
        select count(*)
          into ln_RPPCAB
          from jaqy147 j
         where j.jaqy147inst = ln_Instancia
           and j.jaqy147est = 'H';
      exception
        when others then
          ln_RPPCAB := 0;
      end;
    
      begin
        select count(*)
          into ln_RCNSCAB
          from jaqz821 j
         where j.jaqz821inst = ln_Instancia
           and j.jaqz821est = 'H';
      exception
        when others then
          ln_RCNSCAB := 0;
      end;
    
      if ln_RCRCAB > 0 and ln_RCNSCAB > 0 and ln_RPPCAB > 0 then
      
        ln_VerfLogRatios := 'N';
      else
        ln_VerfLogRatios := 'S';
      end if;
    
    else
      if ln_modulo = 107 then
        -- 31/05/2019 mpostigoc
      
        begin
          select count(*)
            into ln_RCNVCAB
            from jaqz835 j
           where j.jaqz835inst = ln_Instancia
             and j.jaqz835est = 'H';
        exception
          when others then
            ln_RCNVCAB := 0;
        end;
        begin
          select count(*)
            into ln_RCNVDET
            from jaqz836 j
           where j.jaqz836inst = ln_Instancia
             and j.jaqz836est = 'H';
        exception
          when others then
            ln_RCNVDET := 0;
        end;
      
        if ln_RCNVCAB > 0 and ln_RCNVDET > 0 then
          ln_VerfLogRatios := 'N';
        else
          ln_VerfLogRatios := 'S';
        end if;
      
      end if;
    end if;
  
  end sp_cr_VerfLogRatios;
  -------------------------------------------------------------------------
  procedure sp_cr_VerfLogRatDesem(ln_Instancia     in number,
                                  ln_VerfLogRatios out varchar2) is
  
    ln_RCRCAB number := 0;
    --ln_RPPCAB  number := 0;
    ln_RCNSCAB number := 0;
    -- ln_RCNVDET number := 0;
    --  ln_RCNVCAB number := 0;
    ln_modulo number;
  
  begin
  
    ln_VerfLogRatios := 'N';
  
    begin
      select distinct x.xwfmodulo
        into ln_modulo
        from xwf700 x
       where x.xwfprcins = ln_Instancia
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    if ln_modulo <> 107 then
      -- 31/05/2019 mpostigoc
    
      begin
        select count(*)
          into ln_RCRCAB
          from jaqy140 j
         where j.jaqy140inst = ln_Instancia
           and j.jaqy140tarea = 55
           and j.jaqy140est = 'H';
      exception
        when others then
          ln_RCRCAB := 0;
      end;
    
      begin
        select count(*)
          into ln_RCNSCAB
          from jaqz821 j
         where j.jaqz821inst = ln_Instancia
           and j.jaqz821tarea = 55
           and j.jaqz821est = 'H';
      exception
        when others then
          ln_RCNSCAB := 0;
      end;
    
      if ln_RCRCAB > 0 and ln_RCNSCAB > 0 then
      
        ln_VerfLogRatios := 'N';
      else
        ln_VerfLogRatios := 'S';
      end if;
    
      /*else
      if ln_modulo = 107 then
        
        begin
          select count(*)
            into ln_RCNVCAB
            from jaqz835 j
           where j.jaqz835inst = ln_Instancia
             and j.jaqz835est = 'H';
        exception
          when others then
            ln_RCNVCAB := 0;
        end;
        begin
          select count(*)
            into ln_RCNVDET
            from jaqz836 j
           where j.jaqz836inst = ln_Instancia
             and j.jaqz836est = 'H';
        exception
          when others then
            ln_RCNVDET := 0;
        end;
      
        if ln_RCNVCAB > 0 and ln_RCNVDET > 0 then
          ln_VerfLogRatios := 'N';
        else
          ln_VerfLogRatios := 'S';
        end if;
      
      end if;*/
    end if;
  
  end sp_cr_VerfLogRatDesem;

--------------------------------------------------------------------------
end PQ_CR_VERIF_LOGRATIOS;
/

