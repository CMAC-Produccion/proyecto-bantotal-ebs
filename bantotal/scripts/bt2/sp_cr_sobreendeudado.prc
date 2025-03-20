create or replace procedure sp_cr_sobreendeudado(ld_fecha  in date,
                                                 ln_pepais in number,
                                                 ln_petdoc in number,
                                                 ln_pendoc in char,
                                                 lc_fgsob  out varchar2) is
  lc_fgsobact varchar2(2);
  lc_fgsobhis varchar2(2);
  ln_sobreen  number;
  ld_primes   date;
  ld_segmes   date;
  ld_termes   date;
  --fecha_anterior date;
  --fecha_final    date;
  -- fecha_inicial  date;
  ld_jaqy490fec date;
  ld_fechas     date;
  cont          number := 0;
  --lc_mesyear     varchar2(6);

  /*  cursor ld_FechasHistoricas is
      select distinct (h.jaqy490fec) FechHisto
        from jaqy490h h
       where h.jaqy490fec <= ld_fecha
       order by jaqy490fec desc;
  */
begin
  lc_fgsobact := 'N';
  lc_fgsobhis := 'N';
  lc_fgsob    := 'N';

  begin
  
    select max(jaqy490fec) into ld_fechas from jaqy490s s;
  exception
    when others then
      null;
    
  end;

  begin
    --jaqy490s 
    begin
      select jaqy490sob
        into ln_sobreen
        from jaqy490s s
       where s.Jaqy490fec <= ld_fecha --'21/07/2016' 
         and s.Jaqy490pai = ln_pepais --604
         and s.Jaqy490tdo = ln_petdoc --21
         and s.JAQY490NDO = ln_pendoc --'00006472' 
      -- and s. jaqy490sob = 1
       order by s.jaqy490fec desc;
    
    exception
      when others then
        null;
    end;
  
    if ln_sobreen = 1 then
      lc_fgsobact := 'S';
    
    else
      if (ln_sobreen = 0) or (ld_fecha >= ld_fechas) then
        lc_fgsobact := 'N';
        cont        := cont + 1;
      end if;
    end if;
  
  end;

  if lc_fgsobact = 'N' THEN
  
    /*for f in ld_FechasHistoricas loop
    
      if cont < 3 then
      
        begin
          select jaqy490fec Fecha, jaqy490sob sobreen
          
            into ld_jaqy490fec, ln_sobreen
            from jaqy490h h
           where h.Jaqy490fec = f.fechhisto
             and h.Jaqy490pai = ln_pepais
             and h.Jaqy490tdo = ln_petdoc
             and h.JAQY490NDO = ln_pendoc;
        
        exception
          when others then
            null;
        end;
      
        if ln_sobreen = 1 then
          lc_fgsobhis := 'S';
          exit;
        else
          if ln_sobreen = 0 or ln_sobreen is null then
            lc_fgsobhis := 'N';
            cont        := cont + 1;
          
          end if;
        end if;
      end if;
    
    end loop;*/
  
    if ld_fecha = last_day(ld_fecha) and cont = 0  then
      ld_primes := ld_fecha;
      ld_segmes := last_day(add_months(ld_fecha, -1));
      ld_termes := last_day(add_months(ld_fecha, -2));
    else
      if ld_fecha <> last_day(ld_fecha) and cont = 0 then
        ld_primes := last_day(add_months(ld_fecha, -1));
        ld_segmes := last_day(add_months(ld_fecha, -2));
        ld_termes := last_day(add_months(ld_fecha, -3));
      else
        if cont = 1 then
          ld_primes := last_day(add_months(ld_fecha, -2));
          ld_segmes := last_day(add_months(ld_fecha, -3));
        end if;
      end if;
    end if;
  
    --  fecha_final    := last_day(ld_fecha);
  
    begin
      -- Primer Mes Historico
      select jaqy490fec Fecha, jaqy490sob sobreen
      
        into ld_jaqy490fec, ln_sobreen
        from jaqy490h h
       where h.Jaqy490fec = ld_primes
         and h.Jaqy490pai = ln_pepais
         and h.Jaqy490tdo = ln_petdoc
         and h.JAQY490NDO = ln_pendoc;
    
    exception
      when others then
        null;
    end;
  
    --  for s in Sobreendeudaant loop
    if ln_sobreen = 1 then
      lc_fgsobhis := 'S';
    
    else
      if ln_sobreen = 0 or ln_sobreen is null then
        lc_fgsobhis := 'N';
        cont        := cont + 1;
      
      end if;
    end if;
  
    if lc_fgsobhis = 'N' then
    
      begin
        -- Segundo Mes Historico
      
        -- ld_fecha := fecha_final;
      
        /* fecha_anterior := add_months(fecha_final, -1);
        
        fecha_final    := last_day(fecha_anterior);*/
      
        begin
        
          select jaqy490fec Fecha, jaqy490sob sobreen
          
            into ld_jaqy490fec, ln_sobreen
            from jaqy490h h
           where h.Jaqy490fec = ld_segmes
             and h.Jaqy490pai = ln_pepais
             and h.Jaqy490tdo = ln_petdoc
             and h.JAQY490NDO = ln_pendoc;
        exception
          when others then
            null;
        end;
      
        if ln_sobreen = 1 then
          lc_fgsobhis := 'S';
          --exit;
        else
          if ln_sobreen = 0 or ln_sobreen is null then
            lc_fgsobhis := 'N';
            cont        := cont + 1;
          end if;
        end if;
      
      end;
    
      if lc_fgsobhis = 'N' and cont < 3 then
      
        begin
          -- Tercer Mes Historico
        
          -- ld_fecha := fecha_final;
        
          /* fecha_anterior := add_months(fecha_final, -1);
          
          fecha_final    := last_day(fecha_anterior);*/
        
          begin
          
            select jaqy490fec Fecha, jaqy490sob sobreen
            
              into ld_jaqy490fec, ln_sobreen
              from jaqy490h h
             where h.Jaqy490fec = ld_termes
               and h.Jaqy490pai = ln_pepais
               and h.Jaqy490tdo = ln_petdoc
               and h.JAQY490NDO = ln_pendoc;
          exception
            when others then
              null;
          end;
        
          if ln_sobreen = 1 then
            lc_fgsobhis := 'S';
            --exit;
          else
            if ln_sobreen = 0 or ln_sobreen is null then
              lc_fgsobhis := 'N';
              -- cont:= cont + 1;
            end if;
          end if;
        
        end;
      
      end if;
    
    end if;
  
  end if;

  if lc_fgsobact = 'S' or lc_fgsobhis = 'S' then
    lc_fgsob := 'S';
  else
    lc_fgsob := 'N';
  end if;

end sp_cr_sobreendeudado;
/

