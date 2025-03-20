create or replace procedure sp_analista_credito(
                                               v_Scmod  in number,
                                               v_Scsuc  in number,
                                               v_Scmda  in number,
                                               v_Scpap  in number,
                                               v_Sccta  in number,
                                               v_Scoper in number,
                                               v_Scsbop in number,
                                               v_Sctope in number,
                                               v_analista out char
                                             ) is

    lc_analista fst046.ubuser%type;
    ln_instancia number(10);
    ln_lote fpp175.pp174cod%type;    

  begin

    --para prendario nombre del tasador   
   if (v_Scmod = 108) then 
     begin
      SELECT max(pp174cod) 
             into ln_lote
      FROM fpp175 d
      where 
           d.pp175suc  = v_Scsuc
       and d.pp175mda  = v_Scmda
       and d.pp175pap  = v_Scpap
       and d.pp175cta  = v_Sccta
       and d.pp175oper = v_Scoper
       and d.pp175sbop = v_Scsbop
       and d.pp175mod  = v_Scmod
       and d.pp175tope = v_Sctope;
    exception
      when no_data_found then
           ln_lote := null;       
     end;  
       
      begin
       select max(substr(pp178dtext,1,10)) 
              into lc_analista
       from fpp178 
       where 
            pp174cod = ln_lote 
        and pp177codd = 7;
      exception
        when no_data_found then
             lc_analista := null;
      end;        
   else
       If v_Scmod = 116 THEN
          Begin
                select max(xw2.xwfprcins)
                  into ln_instancia
                  From Fsr011 rel  join   xwf700 xw2 on xw2.xwfempresa   = rel.r2cod  
                                                  and xw2.xwfmodulo    = rel.r2mod  
                                                  and xw2.xwfsucursal  = rel.r2suc  
                                                  and xw2.xwfmoneda    = rel.r2mda  
                                                  and xw2.xwfpapel     = rel.r2pap  
                                                  and xw2.xwfcuenta    = rel.r2cta  
                                                  and xw2.xwfoperacion = rel.r2oper  
                                                  and xw2.xwfsubope    = rel.r2sbop  
                                                  and xw2.xwftipope    = rel.r2tope 
                                                  and rel.relcod       = 46     
                                                  and xw2.xwfcar3      = '1'
                 where rel.r1cod = 1
                   and rel.r1mod = v_Scmod
                   and rel.r1suc = v_Scsuc
                   and rel.r1mda = v_Scmda
                   and rel.r1pap = v_Scpap
                   and rel.r1cta = v_Sccta
                   and rel.r1oper= v_Scoper
                   and rel.r1sbop= v_Scsbop
                   and rel.r1tope= v_Sctope;
                   If nvl(ln_instancia,0) = 0 Then
                    Begin
                        select max(xw2.xwfprcins)
                          into ln_instancia
                          From Fsr011 rel  join   xwf700 xw2 on xw2.xwfempresa   = rel.r2cod  
                                                          and xw2.xwfmodulo    = rel.r2mod  
                                                          and xw2.xwfsucursal  = rel.r2suc  
                                                          and xw2.xwfmoneda    = rel.r2mda  
                                                          and xw2.xwfpapel     = rel.r2pap  
                                                          and xw2.xwfcuenta    = rel.r2cta  
                                                          and xw2.xwfoperacion = rel.r2oper  
                                                          and xw2.xwfsubope    = rel.r2sbop  
                                                          and xw2.xwftipope    = rel.r2tope 
                                                          and rel.relcod       = 46     
                         where rel.r1cod = 1
                           and rel.r1mod = v_Scmod
                           and rel.r1suc = v_Scsuc
                           and rel.r1mda = v_Scmda
                           and rel.r1pap = v_Scpap
                           and rel.r1cta = v_Sccta
                           and rel.r1oper= v_Scoper
                           and rel.r1tope= v_Sctope;
                    End;   
                 End IF;   
          End;         
                     
       Else
           Begin
               select xw2.xwfprcins
                 into ln_instancia
                 from   xwf700 xw2
                where xw2.xwfempresa   = 1
                  and xw2.xwfsucursal  = v_Scsuc
                  and xw2.xwfmodulo    = v_Scmod
                  and xw2.xwfmoneda    = v_Scmda
                  and xw2.xwfpapel     = v_Scpap
                  and xw2.xwfcuenta    = v_Sccta
                  and xw2.xwfoperacion = v_Scoper
                  and xw2.xwfsubope    = v_Scsbop
                  and xw2.xwftipope    = v_Sctope
                  and xw2.xwfcar3      = '1';
           Exception When Others Then
                      If v_Scmod in (200,33) or  v_Sctope = 550  Then
                         Begin
                                 select max(xw2.xwfprcins)
                                   into ln_instancia
                                   from   xwf700 xw2
                                  where xw2.xwfempresa   = 1
                                    and xw2.xwfsucursal  = v_Scsuc
                                    and xw2.xwfmoneda    = v_Scmda
                                    and xw2.xwfpapel     = v_Scpap
                                    and xw2.xwfcuenta    = v_Sccta
                                    and xw2.xwfoperacion = v_Scoper;
                           end;
                      Else
                      
                           Begin
                                 select xw2.xwfprcins
                                   into ln_instancia
                                   from   xwf700 xw2
                                  where xw2.xwfempresa   = 1
                                    and xw2.xwfsucursal  = v_Scsuc
                                    and xw2.xwfmodulo    = v_Scmod
                                    and xw2.xwfmoneda    = v_Scmda
                                    and xw2.xwfpapel     = v_Scpap
                                    and xw2.xwfcuenta    = v_Sccta
                                    and xw2.xwfoperacion = v_Scoper
                                    and xw2.xwftipope    = v_Sctope
                                    and xw2.xwfcar3      = '1';
                           Exception When Others Then
                                  begin
                                       select max(xw2.xwfprcins)
                                         into ln_instancia
                                         from   xwf700 xw2
                                        where xw2.xwfempresa   = 1
                                          and xw2.xwfsucursal  = v_Scsuc
                                          and xw2.xwfmodulo    = v_Scmod
                                          and xw2.xwfmoneda    = v_Scmda
                                          and xw2.xwfpapel     = v_Scpap
                                          and xw2.xwfcuenta    = v_Sccta
                                          and xw2.xwfoperacion = v_Scoper
                                          and xw2.xwftipope    = v_Sctope
                                          and xw2.xwfcar3      = '1';
                                    end;
                           End;         
                           End IF;                           
           End ;
           
           --2015.11.23 cuando instancia es 0 verificar si es judicial           
           if nvl(ln_instancia,0) = 0 and v_Scmod in (200,33) then
              begin            
                    select max(xw2.xwfprcins)
                      into ln_instancia
                      From Fsr011 rel  join   xwf700 xw2 on xw2.xwfempresa   = rel.r2cod  
                                                      and xw2.xwfmodulo    = rel.r2mod  
                                                      and xw2.xwfsucursal  = rel.r2suc  
                                                      and xw2.xwfmoneda    = rel.r2mda  
                                                      and xw2.xwfpapel     = rel.r2pap  
                                                      and xw2.xwfcuenta    = rel.r2cta  
                                                      and xw2.xwfoperacion = rel.r2oper  
                                                      and xw2.xwfsubope    = rel.r2sbop  
                                                      and xw2.xwftipope    = rel.r2tope 
                                                      and rel.relcod       = 46     
                                                      and xw2.xwfcar3      = '1'
                     where rel.r1cod = 1
                       and rel.r1mod = v_Scmod
                       and rel.r1suc = v_Scsuc
                       and rel.r1mda = v_Scmda
                       and rel.r1pap = v_Scpap
                       and rel.r1cta = v_Sccta
                       and rel.r1oper= v_Scoper
                       and rel.r1sbop= v_Scsbop
                       and rel.r1tope= v_Sctope;
            
               --2016.08.09        
                 if nvl(ln_instancia,0) = 0 then 
                     begin        
                          select max(xw2.xwfprcins)
                            into ln_instancia
                            From Fsr011 rel  join   xwf700 xw2 on xw2.xwfempresa   = rel.r2cod  
                                                            and xw2.xwfmodulo    = rel.r2mod  
                                                            and xw2.xwfsucursal  = rel.r2suc  
                                                            and xw2.xwfmoneda    = rel.r2mda  
                                                            and xw2.xwfpapel     = rel.r2pap  
                                                            and xw2.xwfcuenta    = rel.r2cta  
                                                            and xw2.xwfoperacion = rel.r2oper  
                                                            and xw2.xwfsubope    = rel.r2sbop  
                                                            and xw2.xwftipope    = rel.r2tope 
                                                            and rel.relcod       = 46     
                           where rel.r1cod = 1
                             and rel.r1mod = v_Scmod
                             and rel.r1suc = v_Scsuc
                             and rel.r1mda = v_Scmda
                             and rel.r1pap = v_Scpap
                             and rel.r1cta = v_Sccta
                             and rel.r1oper= v_Scoper
                             and rel.r1sbop= v_Scsbop
                             and rel.r1tope= v_Sctope;
                    exception when no_Data_found then
                       ln_instancia := 0;       
                     end;        
                   end if;  
               end; 
               --2016.08.09   

           
                        
           end if;   
           --2015.11.23
           
       End IF;
       if nvl(ln_instancia,0) = 0 then 
          Begin
            select max(xw2.xwfprcins)
              into ln_instancia
              from xwf700 xw2
             where xw2.xwfempresa   = 1
               and xw2.xwfsucursal  = v_Scsuc
               and xw2.xwfmoneda    = v_Scmda
               and xw2.xwfpapel     = v_Scpap
               and xw2.xwfcuenta    = v_Sccta
               and xw2.xwfoperacion = v_Scoper;
           end;
       end if;
       
       If ln_instancia is not null then
           Begin
                 select sng001ase
                   into lc_analista
                   from sng001  --Cambiar la tabla para producción
                  where sng001inst =  ln_instancia;
           Exception when no_data_found then
                      lc_analista := null;
           end;
       End If; 
       
     end if;      

      
  --return lc_analista;
  v_analista := lc_analista;
  --end;

end sp_analista_credito;
/

