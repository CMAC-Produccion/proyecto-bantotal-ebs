create or replace function fn_tipo_tasa_mora(v_Pgfape in date, --fecha de proceso
                                             v_Pgfdes in date, --fecha de proceso         
                                             v_Pgcod  in number,
                                             v_Scmod  in number,
                                             v_Scsuc  in number,
                                             v_Scmda  in number,
                                             v_Scpap  in number,
                                             v_Sccta  in number,
                                             v_Scoper in number,
                                             v_Scsbop in number,
                                             v_Sctope in number) return varchar2
  is
    lc_tipotas varchar2(10);
  Begin
       begin 
           select 'Lineal' 
             into lc_tipotas
             from fsd010 f, fsd012 g  ---354
            where g.pgcod = f.pgcod
              and g.aomod = f.aomod
              and g.aosuc = f.aosuc
              and g.aomda = f.aomda
              and g.aopap = f.aopap
              and g.aocta = f.aocta
              and g.aooper = f.aooper
              and g.aosbop = f.aosbop
              and g.aotope = f.aotope
              and g.evtipo = 4
              and f.pgcod = v_Pgcod
              and f.aomod = v_Scmod
              and f.aosuc = v_Scsuc
              and f.aomda = v_Scmda
              and f.aopap = v_Scpap
              and f.aocta = v_Sccta
              and f.aooper= v_Scoper
              and f.aosbop= v_Scsbop
              and f.aotope= v_Sctope
              and g.evfval in (select max(h.evfval) from fsd012 h where 
                            h.pgcod = g.pgcod
                            and h.aomod = g.aomod
                            and h.aosuc = g.aosuc
                            and h.aomda = g.aomda
                            and h.aopap = g.aopap
                            and h.aocta = g.aocta
                            and h.aooper = g.aooper
                            and h.aosbop = g.aosbop
                            and h.aotope = g.aotope
                            and h.evtipo = 4 --cambio tasa
                            and h.d012co = 'S'
                            and h.evfval <= v_Pgfape
               )
              and g.evttas = 2 --1-efectiva - 2 lineal  ----> 372
              and f.aostat  <> 99
              and f.aomod not in (200,33)
              and f.aotope <> 550
              and g.evtasa > 0 ;
       exception
       when others then
         if v_Pgfdes > to_date('20150320','yyyymmdd') then
           lc_tipotas:= 'TEA';
         else
           lc_tipotas:= 'Lineal';  
         end if;  
       end;         

       Return lc_tipotas;
  
  end fn_tipo_tasa_mora;
/

