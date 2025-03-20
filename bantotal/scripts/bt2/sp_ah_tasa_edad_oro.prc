create or replace procedure sp_ah_tasa_edad_oro(P_D_FECPRO IN DATE) is
/* ************************************************************************************************************
    -- Nombre                     : sp_ah_tasa_edad_oro
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Pasivas
    -- Descripción                : Proceso para cambiar la instrucción de renovacion (tasa) de los dpf tipo 4 que no cumplen con monto mínimo de capital
    -- Versión                    : 1.0
    -- Fecha de Creación          : 25/09/2020
    -- Autor de Creación          : Yrving Lozada
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 25/09/2020
    -- Autor de Modificación      : Yrving Lozada
    -- Descripción Modificación   : Se adicionó verificación en guias especial para obtener la pizara para obtención de la tasa.
* *************************************************************************************************************/

 cursor c_reno is
  select x.*
    from (select pgcod,
                 sccta,
                 scoper,
                 scmda,
                 scpap,
                 scsbop,
                 scsuc,
                 min(scmod)  scmod,
                 max(sctope) sctope,
                 max(scfvto) scfvto,
                 sum(scsdo)  scsdo,
                 max(scpzo)  scpzo
            from fsd011
           where pgcod = 1        
             and scmod in (22, 426)
             and decode(sctope, 0, 4, sctope) = 4
             and scstat <> 99
           group by pgcod, sccta, scoper, scmda, scpap, scsbop, scsuc) x
   where x.scfvto = P_D_FECPRO;
   
  ln_monmin number(17,2); 
  tasa      number(10,6);
  tipo      number(9);
  ln_plazo  number(5):=0;
  plazo     number(5):=0;
begin
  -- obtenemos monto minimo
  begin
   select nvl(min(tp1imp1),0) 
     into ln_monmin
     from fst198
    where tp1cod1  = 11002
      and tp1corr2 = 2;    
  exception
  when others then    
    ln_monmin := 0;  
  end;
  
  for i in c_reno loop    
    if i.scsdo < ln_monmin then
      begin
        select tp1nro3
          into tipo
          from fst198
         where tp1cod   = 1 
           and tp1cod1  = 5900
           and tp1corr1 = 0
           and tp1corr2 = 99999
           and tp1corr3 = 1;
      exception
      when no_data_found then
          begin
            select totpiz
              into tipo
              from fst004
             where modulo = 22
               and toeleg = 'S'
               and totope = 1;
          exception
          when others then
              tipo := 0;
          end;          
      when others then
          tipo := 0;
      end;      

      begin
        select x.aopzo
          into ln_plazo
          from fsd010 x
         where x.pgcod  = i.pgcod
           and x.aomod  = i.scmod
           and x.aosuc  = i.scsuc
           and x.aomda  = i.scmda
           and x.aopap  = i.scpap
           and x.aocta  = i.sccta
           and x.aooper = i.scoper
           and x.aosbop = i.scsbop
           and x.aotope = i.sctope;
      exception
      when others then
        ln_plazo := 0;         
      end;
            
      begin
          select tatasa, tapzo
            into tasa, plazo
            from (
                    select a.tatasa,a.tapzo
                      from fsr025 a, 
                           fsd025 b
                     Where a.pgcod  = b.pgcod
                       and a.tamod  = b.tamod
                       and a.tpizar = b.tpizar
                       and a.tamda  = b.tamda
                       and a.tapap  = b.tapap
                       and a.tafdes = b.tafdes
                       and a.tamto  = b.tamto
                       and a.Pgcod  =  i.pgcod
                       and a.Tamod  =  i.scmod
                       and a.Tamda  =  i.scmda
                       and a.Tapap  =  i.scpap
                       and a.Tpizar =  tipo -- totpiz   
                       and a.tamto  >= i.scsdo
                       and a.tafdes <= P_D_FECPRO
                       and a.tapzo  >= ln_plazo
                  order by a.tafdes desc, a.tamto,a.tapzo
                  )
           where rownum = 1;        
      exception
      when no_data_found then  
        begin
          select tatasa,tapzo
            into tasa,plazo
            from (
                    select a.tatasa, a.tapzo
                      from fsr025 a, 
                           fsd025 b
                     Where a.pgcod  = b.pgcod
                       and a.tamod  = b.tamod
                       and a.tpizar = b.tpizar
                       and a.tamda  = b.tamda
                       and a.tapap  = b.tapap
                       and a.tafdes = b.tafdes
                       and a.tamto  = b.tamto
                       and a.Pgcod  =  i.pgcod
                       and a.Tamod  =  i.scmod
                       and a.Tamda  =  i.scmda
                       and a.Tapap  =  i.scpap
                       and a.Tpizar =  tipo -- totpiz   
                       and a.tamto  >= i.scsdo
                       and a.tafdes <= P_D_FECPRO
                  order by a.tafdes desc, a.tamto, a.tapzo desc
                  )
           where rownum = 1;                       
        exception
        when others then  
          tasa := 0;
        end;
      end;
      
      begin
        insert into FSD605(RdCod,    
                           RdMod,    
                           RdSuc,    
                           RdMda,    
                           RdPap,    
                           RdCta,    
                           RdOper,   
                           RdSbop,   
                           RdTope,   
                           Rdttas,   
                           Rdtasa,   
                           Rdpzo,    
                           Rdcltcod, 
                           Rdplus   
                           )
                    values(i.pgcod, 
                           i.scmod,
                           i.scsuc,
                           i.scmda,
                           i.scpap,
                           i.sccta,
                           i.scoper,
                           i.scsbop,
                           i.sctope,
                           1,
                           tasa,
                           plazo,
                           0, 
                           0
                           );
        exception                 
        when dup_val_on_index then
          begin
                delete 
                  from FSD605 
                 Where RdCod  = i.pgcod
                   and RdMod  = i.scmod
                   and RdSuc  = i.scsuc
                   and RdMda  = i.scmda
                   and RdPap  = i.scpap
                   and RdCta  = i.sccta
                   and RdOper = i.scoper
                   and RdSbop = i.scsbop
                   and RdTope = i.sctope;
          exception
          when others then
            null;            
          end;    
          
          begin    
            insert into FSD605(RdCod,    
                               RdMod,    
                               RdSuc,    
                               RdMda,    
                               RdPap,    
                               RdCta,    
                               RdOper,   
                               RdSbop,   
                               RdTope,   
                               Rdttas,   
                               Rdtasa,   
                               Rdpzo,    
                               Rdcltcod, 
                               Rdplus   
                               )
                        values(i.pgcod, 
                               i.scmod,
                               i.scsuc,
                               i.scmda,
                               i.scpap,
                               i.sccta,
                               i.scoper,
                               i.scsbop,
                               i.sctope,
                               1,
                               tasa,
                               plazo,
                               0, 
                               0
                               );
          exception
          when others then
            null;                   
          End;
        End;
      End if;    		
    End loop;
    commit;
end sp_ah_tasa_edad_oro;
/

