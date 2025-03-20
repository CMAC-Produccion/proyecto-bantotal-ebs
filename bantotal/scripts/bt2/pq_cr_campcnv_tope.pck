create or replace package PQ_CR_CAMPCNV_TOPE is

  -- Author  : MPOSTIGOC
  -- Created : 11/10/2021 12:54:17
  -- Purpose : 

  procedure sp_cr_tope_campconv(ln_instancia in number,
                                lc_TopeOk    out varchar2);

end PQ_CR_CAMPCNV_TOPE;
/

create or replace package body PQ_CR_CAMPCNV_TOPE is

  procedure sp_cr_tope_campconv(ln_instancia in number,
                                lc_TopeOk    out varchar2) is
  
    ln_nroconv   number;
    ln_ContCompe number;
    ln_ContPoten number;
    ln_TopeAnt   number;
    ln_TopeNew   number;
    ln_EsCompt   number;
    ln_EsPoten   number;
    ln_ModNew    number;
    ln_tipSol    number := 0;
    ln_ErsBenf   number := 0;
    ln_TopeBenf  number;
    ln_EsCamp    number;
    ln_EsAmpl    number;
    ln_EsOk      number;
  
  begin
  
    lc_TopeOk := 'S';
  
    begin
      select x.xwftipope, x.xwfmodulo
        into ln_TopeNew, ln_ModNew
        from xwf700 x
       where x.xwfprcins = ln_instancia
         and x.xwfcar3 = '1';
    exception
      when others then
        ln_TopeNew := 0;
    end;
  
    begin
      select x.xwftipope
        into ln_TopeAnt
        from xwf700 x
       where x.xwfprcins = ln_instancia
         and x.xwfcar3 <> '1';
    exception
      when others then
        ln_TopeAnt := 0;
    end; --INC3903
  
    begin
      select s.sng001ori
        into ln_tipSol
        from sng001 s
       where s.sng001inst = ln_instancia;
    exception
      when others then
        ln_tipSol := 0;
    end;
  
    pq_cr_convenioessalud.sp_cr_nroconvenio(ln_instancia, ln_nroconv);
  
    begin
      select count(*)
        into ln_ErsBenf
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 751
         and f.tp1corr2 = 2
         and f.tp1corr3 > 0
         and f.tp1nro3 = ln_nroconv;
    exception
      when others then
        ln_ErsBenf := 0;
      
    end;
  
    if ln_ErsBenf > 0 then
    
      if ln_ModNew = 107 and ln_tipSol = 4 then
      
        begin
          select count(*)
            into ln_ContCompe
            from fpp104 f, x054010 x
           where f.pp104ncart = ln_nroconv
             and to_number(f.pp104val1) = x.xpremod
             and to_number(f.pp104val2) = x.xpretope
             and to_number(f.pp104val3) = x.xpremoneda
             and to_number(f.pp104val4) = x.xprepapel
             and x.xpredesc like '%ompet%';
        exception
          when others then
            ln_ContCompe := 0;
        end;
      
        begin
          select count(*)
            into ln_ContPoten
            from fpp104 f, x054010 x
           where f.pp104ncart = ln_nroconv
             and to_number(f.pp104val1) = x.xpremod
             and to_number(f.pp104val2) = x.xpretope
             and to_number(f.pp104val3) = x.xpremoneda
             and to_number(f.pp104val4) = x.xprepapel
             and x.xpredesc like '%otenc%';
        exception
          when others then
            ln_ContPoten := 0;
        end;
      
        if ln_ContCompe > 0 and ln_ContPoten = 0 then
          begin
            select count(*)
              into ln_EsCompt
              from fst198 f
             where f.tp1cod = 1
               and f.tp1cod1 = 10899
               and f.tp1corr1 = 751
               and f.tp1corr2 = 1
               and f.tp1desc = 'Competitivo'
               and f.tp1nro2 = ln_TopeAnt
               and f.tp1nro3 = ln_TopeNew;
          exception
            when others then
              ln_EsCompt := 0;
          end;
        
        else
          if ln_ContPoten > 0 and ln_ContCompe = 0 then
            begin
              select count(*)
                into ln_EsPoten
                from fst198 f
               where f.tp1cod = 1
                 and f.tp1cod1 = 10899
                 and f.tp1corr1 = 751
                 and f.tp1corr2 = 1
                 and f.tp1desc = 'Potencial'
                 and f.tp1nro2 = ln_TopeAnt
                 and f.tp1nro3 = ln_TopeNew;
            exception
              when others then
                ln_EsPoten := 0;
            end;
          else
            if ln_ContCompe = 0 and ln_ContPoten = 0 then
            
              begin
                select count(*)
                  into ln_EsCamp
                  from fst198 f
                 where f.tp1cod = 1
                   and f.tp1cod1 = 10899
                   and f.tp1corr1 = 751
                   and f.tp1corr2 = 1
                   and f.tp1desc = 'Campaña'
                   and f.tp1nro2 = ln_TopeAnt
                   and f.tp1nro3 = ln_TopeNew;
              exception
                when others then
                  ln_EsCamp := 0;
              end;
            
            end if;
          
          end if;
        end if;
      
        if nvl(ln_EsCompt, 0) > 0 or nvl(ln_EsPoten, 0) > 0 or
           nvl(ln_EsCamp, 0) > 0 then
          lc_TopeOk := 'S';
        else
          lc_TopeOk := 'N';
        end if;
      
      else
        if ln_TopeNew = 107 and ln_tipSol = 10 then
        
          begin
            select count(*)
              into ln_TopeBenf
              from fst198 f
             where f.tp1cod = 1
               and f.tp1cod1 = 10899
               and f.tp1corr1 = 751
               and f.tp1corr2 = 1
               and f.tp1nro1 = ln_tipSol
               and f.tp1nro3 = ln_TopeNew;
          exception
            when others then
              ln_TopeBenf := 0;
          end;
        
          if nvl(ln_TopeBenf, 0) > 0 then
            lc_TopeOk := 'S';
          else
            lc_TopeOk := 'N';
          end if;
        
        else
          lc_TopeOk := 'S';
        end if;
      end if;
    
    else
      if ln_ErsBenf = 0 and ln_tipSol = 4 then
      
        begin
          select count(*)
            into ln_EsAmpl
            from fst198
           where Tp1cod = 1
             and Tp1cod1 = 10899
             and Tp1corr1 = 751
             and Tp1corr2 = 3
             and tp1nro1 = ln_tipSol
             and tp1nro2 = ln_TopeAnt;
        exception
          when others then
            ln_EsAmpl := 0;
        end;
      
        if ln_EsAmpl > 0 then
        
          begin
            select count(*)
              into ln_EsOk
              from fst198
             where Tp1cod = 1
               and Tp1cod1 = 10899
               and Tp1corr1 = 751
               and Tp1corr2 = 3
               and tp1nro1 = ln_tipSol
               and tp1nro2 = ln_TopeAnt
               and tp1nro3 = ln_TopeNew;
          exception
            when others then
              ln_EsOk := 0;
          end;
        
          if nvl(ln_EsOk, 0) > 0 then
            lc_TopeOk := 'S';
          else
            lc_TopeOk := 'N';
          end if;
        
        else
          lc_TopeOk := 'S';
        end if;
      
        lc_TopeOk := 'S';
      
      end if;
    
    end if;
  
  end sp_cr_tope_campconv;

end PQ_CR_CAMPCNV_TOPE;
/

