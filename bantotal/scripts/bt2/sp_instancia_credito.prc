create or replace procedure sp_instancia_credito(
                                               v_Scmod  in number,
                                               v_Scsuc  in number,
                                               v_Scmda  in number,
                                               v_Scpap  in number,
                                               v_Sccta  in number,
                                               v_Scoper in number,
                                               v_Scsbop in number,
                                               v_Sctope in number,
                                               v_instancia out number
                                             ) is

  /*  2015.11.24 DCASTRO Se agrego condicion cuando instancia es 0 y es judicial, castigado - busca en FSR011 */
  /* 2016.06.09 DCASTRO Se agrego condicion cuando instancia es 0 es judicial y proviene de una linea*/
  
    ln_instancia sng001.sng001inst%type;

  begin

       If v_Scmod = 116 THEN
          Begin
                select max(xw2.xwfprcins)
                  into ln_instancia
                  From Fsr011 rel  join  xwf700 xw2 on xw2.xwfempresa   = rel.r2cod
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

              If ln_instancia is null Then
                    Begin
                        select max(xw2.xwfprcins)
                          into ln_instancia
                          From Fsr011 rel  join  xwf700 xw2 on xw2.xwfempresa   = rel.r2cod
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
              End If;
          End;

       Else
           Begin
               select xw2.xwfprcins
                 into ln_instancia
                 from  xwf700 xw2
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
                                   from  xwf700 xw2
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
                                   from  xwf700 xw2
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
                                         from  xwf700 xw2
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

           --2015.11.24 cuando instancia es 0 verificar si es judicial
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
           --2015.11.24


       End IF;
       if nvl(ln_instancia,0) = 0 then
          Begin
            select max(xw2.xwfprcins)
              into ln_instancia
              from  xwf700 xw2
             where xw2.xwfempresa   = 1
               and xw2.xwfsucursal  = v_Scsuc
               and xw2.xwfmoneda    = v_Scmda
               and xw2.xwfpapel     = v_Scpap
               and xw2.xwfcuenta    = v_Sccta
               and xw2.xwfoperacion = v_Scoper;
           end;
       end if;


       v_instancia := ln_instancia;

end sp_instancia_credito;
/

