create or replace procedure sp_ah_valida_oper(P_N_PGCOD  IN NUMBER,
                                              P_N_ITSUC  IN NUMBER,           
                                              P_N_ITMOD  IN NUMBER,
                                              P_N_ITTRAN IN NUMBER,                                
                                              P_N_ITNREL IN NUMBER,
                                              P_N_ITORD  IN NUMBER,  
                                              P_N_ITSBO  IN NUMBER,
                                              P_C_CODUSU IN VARCHAR2,
                                              p_c_indope out varchar2
                                              ) is   
  ln_itoper  number(9);  
  ln_itsubo  number(3);  
  ln_sucdes  number(3);  
  ln_ittope  number(3);  
  ln_moneda  number(4);  
  ln_papel   number(4);  
  ln_ctnro   number(9); 
  ln_modulo  number(3);                                                      
  ld_fecpro  date;
  ln_tpnro1  number(9);
  lc_inactiva char(1):= 'N';    
  ld_fecope   date;   
  ld_fecini   date;
  lc_horope   char(8);
  lc_hora     char(8);
begin
    begin 
      select x.pgfape 
        into ld_fecpro 
        from fst017 x 
       where x.pgcod = P_N_PGCOD; 
    exception 
    when others then 
      ld_fecpro := trunc(sysdate); 
    end;

    lc_horope := to_char(sysdate,'hh24:mi:ss');
    ld_fecope := to_date(to_char(ld_fecpro,'dd/mm/rrrr')||' '||lc_horope,'dd/mm/rrrr HH24:mi:ss');
    
    
    -- obtenemos guía de proceso con el número de minutos a considerar
    begin 
      select x.tp1nro1
        into ln_tpnro1
        from fst198 x 
       where x.tp1cod = P_N_PGCOD
         and x.tp1cod1 = 10825
         and x.tp1corr1 = 65
         and x.tp1corr2 = 1
         and x.tp1corr3 = 1;
    exception 
    when others then 
      ld_fecpro := trunc(sysdate); 
      ln_tpnro1 := 0;
      p_c_indope := 'N';
      return;
    end;    
    
    begin
        select a.modulo,
               a.ctnro,
               a.itoper,
               a.itsubo,
               a.itsucd,
               a.ittope,
               a.moneda,
               a.papel
          into ln_modulo,
               ln_ctnro,
               ln_itoper,          
               ln_itsubo,          
               ln_sucdes,          
               ln_ittope,          
               ln_moneda,          
               ln_papel
          from fsd016 a
         where a.pgcod  = P_N_PGCOD
           and a.itsuc  = P_N_ITSUC
           and a.itmod  = P_N_ITMOD
           and a.ittran = P_N_ITTRAN
           and a.itnrel = P_N_ITNREL
           and a.itord  = P_N_ITORD
           and a.itsbor = P_N_ITSBO;
    exception
    when others then            
      ln_ctnro := 0;
      p_c_indope := 'N';
      return;
    end;
    
    if ln_ctnro > 0 then
      begin 
        select 'S' 
          into lc_inactiva    
          from fsd450 a
         where a.cbieemp = P_N_PGCOD
           and a.cbiemod = ln_modulo
           and a.cbiesuc = ln_sucdes
           and a.cbiemda = ln_moneda 
           and a.cbiepap = ln_papel 
           and a.cbiecta = ln_ctnro  
           and a.cbieope = ln_itoper 
           and a.cbiesub = ln_itsubo 
           and a.cbietop = ln_ittope 
           and a.cbiefec = ld_fecpro
           and a.cbieant = 81; 
      exception 
      when others then 
        lc_inactiva := 'N';
      end; 
    Else
      p_c_indope := 'N';
      return;
    End If;
                  
    if ln_ctnro > 0 then
      begin
        select max(a.ithora) 
          into lc_hora
          from fsd015 a,
               fst198 b,
               fsd016 c
         where a.pgcod    = c.pgcod
           and a.itsuc    = c.itsuc
           and a.itmod    = c.itmod
           and a.ittran   = c.ittran
           and a.itnrel   = c.itnrel
           and a.pgcod    = b.tp1cod
           and a.itmod    = b.tp1nro1
           and a.ittran   = b.tp1nro2                    
           and c.modulo   = ln_modulo
           and c.ittope   = ln_ittope
           and c.itsucd   = ln_sucdes
           and c.moneda   = ln_moneda
           and c.papel    = ln_papel
           and c.ctnro    = ln_ctnro
           and c.itoper   = ln_itoper
           and c.itsubo   = ln_itsubo            
           and a.ituing   = decode(P_C_CODUSU,null,a.ituing,rpad(P_C_CODUSU,10,' '))
           and a.itcorr   = 0
           and a.itcont   = 'S'
           and a.pgcod    = P_N_PGCOD
           and b.tp1cod1  = 10825 
           and b.tp1corr1 = 65
           and b.tp1corr2 = 2;
      exception
      when others then            
           lc_hora := null;
      end;
      
      if lc_inactiva = 'S' and lc_hora is not null then
         ld_fecini := to_date(to_char(ld_fecpro,'dd/mm/rrrr')||' '||lc_hora,'dd/mm/rrrr HH24:mi:ss');
         if (ld_fecope - ld_fecini)*24*60 <= ln_tpnro1 then
            p_c_indope := 'S';
         Else  
            p_c_indope := 'N';
         End If;
         
      End If;  
      if lc_inactiva = 'S' and lc_hora is null then
        p_c_indope := 'S';
      End If;
      if lc_inactiva = 'N' and lc_hora is not null then
         ld_fecini := to_date(to_char(ld_fecpro,'dd/mm/rrrr')||' '||lc_hora,'dd/mm/rrrr HH24:mi:ss');
         if (ld_fecope - ld_fecini)*24*60 <= ln_tpnro1 then
            p_c_indope := 'S';
         Else  
            p_c_indope := 'N';
         End If;        
      End If;
      if lc_inactiva = 'N' and lc_hora is null then
        p_c_indope := 'N';
      End If;                  
    Else
      p_c_indope := 'N';
      return;
    End If ; 
exception
when others then     
  p_c_indope := 'N';   
  null;
end sp_ah_valida_oper;
/

