create or replace procedure sp_parche_tipifica(PD_FECPRO in DATE)
 is
 cursor ven_ref is  
  select /*+all_rows parallel(a,2,1)*/ --jflor 23.01.2014
         a.pgcod, a.scsuc, a.scrub, a.scmda, a.scpap, a.sccta,
         --(select ctnom from  fsd008 where pgcod = 1 and ctnro = a.sccta) nombre,
         a.scoper, a.scsbop, a.sctope,a.scsdo, a.scstat,
         case when (select distinct 1 from  jaqm27 x,  jaqm33 y
           where x.jaqm27pgc = a.pgcod 
             and x.jaqm27suc = a.scsuc
             and x.jaqm27mda = a.scmda
             and x.jaqm27pap = a.scpap
             and x.jaqm27cta = a.sccta
             and x.jaqm27oper = a.scoper
             and x.jaqm33cor = y.jaqm33cor) = 1 then 33 else 61 end estado
          
    from fsd011 a
   where a.scstat = 0
     and a.sctope <> 550
     and a.scrub in (select rubro
                     from  fsd014
                    where (pcnivc in
                          (select modulo
                              from  fst111
                             where dscod = 50
                               and modulo not in (29, 120, 144, 33, 200)) --33 castigado , 200 judicial
                          )
                      and pcimpu = 'S'
                      and pmtit <> 9
                      and rubro like '14_5__19%');

cursor refina is  
select /*+all_rows parallel(a,2,1)*/ --jflor 23.01.2014
       a.pgcod, a.scsuc, a.scrub, a.scmda, a.scpap, a.sccta,
       --(select ctnom from  fsd008 where pgcod = 1 and ctnro = a.sccta) nombre,
       a.scoper, a.scsbop, a.sctope,a.scsdo, a.scstat,
       case when (select distinct 1 from  jaqm27 x,  jaqm33 y
         where x.jaqm27pgc = a.pgcod 
           and x.jaqm27suc = a.scsuc
           and x.jaqm27mda = a.scmda
           and x.jaqm27pap = a.scpap
           and x.jaqm27cta = a.sccta
           and x.jaqm27oper = a.scoper
           and x.jaqm33cor = y.jaqm33cor) = 1 then 33 else 61 end estado
        
  from  fsd011 a
 where a.scstat = 0
   --and a.sctope <> 550
   and a.scrub in (select rubro
                   from  fsd014
                  where (pcnivc in
                        (select modulo
                            from  fst111
                           where dscod = 50
                             and modulo not in (29, 120, 144, 33, 200)) --33 castigado , 200 judicial
                        )
                    and pcimpu = 'S'
                    and pmtit <> 9
                    and rubro like '14_4%');
                    
 cursor PJ is  
select /*+all_rows parallel(a,2,1)*/ --jflor 23.01.2014
       a.pgcod, a.scsuc, a.scrub, a.scmda, a.scpap, a.sccta,
       --(select ctnom from  fsd008 where pgcod = 1 and ctnro = a.sccta) nombre,
       a.scoper, a.scsbop, a.sctope,a.scsdo, a.scstat, decode (b.SNG400Evto,1100,22,21) estado
  from  fsd011 a,  sng410 b
 where a.scstat = 0
   and a.scrub in (select rubro
                   from  fsd014
                  where (pcnivc in
                        (select modulo
                            from  fst111
                           where dscod = 50
                             and modulo not in (29, 120, 144, 33, 200)) --33 castigado , 200 judicial
                        )
                    and pcimpu = 'S'
                    and pmtit <> 9)
   and b.sng410cta = a.sccta
   and b.sng410suc = a.scsuc
   and b.sng410mda = a.scmda
   and b.sng410pap = a.scpap
   and b.sng410op  = a.scoper
   and b.sng410mod = a.scmod
   and b.sng410top = a.sctope
   and b.sng410its <> 999
   and b.SNG400Evto in (1100,1101)
   --and ( scrub not like '14_4%' and  scrub not like '14_5__19%')
   and a.scfval < b.sng410fecg
   and not exists (select 1 from jaqm27 x
         where x.jaqm27pgc = a.pgcod 
           and x.jaqm27suc = a.scsuc
           and x.jaqm27mda = a.scmda
           and x.jaqm27pap = a.scpap
           and x.jaqm27cta = a.sccta
           and x.jaqm27oper = a.scoper) ;                  

cursor demanda is  
select /*+all_rows parallel(a,2,1)*/ --jflor 23.01.2014
       a.pgcod, a.scsuc, a.scrub, a.scmda, a.scpap, a.sccta,
       --(select ctnom from  fsd008 where pgcod = 1 and ctnro = a.sccta) nombre,
       a.scoper, a.scsbop, a.sctope,a.scsdo, a.scstat,
       case when (select distinct y.jaqm33fint from  jaqm27 x,  jaqm33 y
         where x.jaqm27pgc = a.pgcod 
           and x.jaqm27suc = a.scsuc
           and x.jaqm27mda = a.scmda
           and x.jaqm27pap = a.scpap
           and x.jaqm27cta = a.sccta
           and x.jaqm27oper = a.scoper
           and x.jaqm33cor = y.jaqm33cor) is not null then 25 else 23 end estado
        
  from  fsd011 a
where a.scstat = 0
   and a.sctope = 550
   and a.scrub in (select rubro
                   from  fsd014
                  where (pcnivc in
                        (select modulo
                            from  fst111
                           where dscod = 50
                             and modulo not in (29, 120, 144, 33, 200)) --33 castigado , 200 judicial
                        )
                    and pcimpu = 'S'
                    and pmtit <> 9);

cursor judicial is 
select a.pgcod, a.scsuc, a.scrub, a.scmda, a.scpap, a.sccta,
       a.scoper, a.scsbop, a.sctope,a.scsdo, a.scstat, 64 estado
 from  fsd011 a where scstat = 0 and scmod = 200;                         

cursor del_jud is
select * from  fsd011  where (pgcod,scsuc,scmda,scpap,sccta,
       scoper,scsbop,sctope,scmod) in (
select a.pgcod,a.scsuc,a.scmda,a.scpap,a.sccta,
       a.scoper,a.scsbop,a.sctope,a.scmod
  from  fsd011 a
 where a.scstat <> 99 
   and a.scmod in (select modulo from  fst111 where dscod = 50 and modulo not in (120))
 group by a.pgcod,a.scsuc,a.scmda,a.scpap,a.sccta,
          a.scoper,a.scsbop,a.sctope,a.scmod
having count(*) > 1)
and scsdo = 0;

 BEGIN
 --***************************************************
 -- Pre Judiciales
 --*************************************************** 
    begin 
       for i in PJ loop
         update fsd010
            set aostat = i.estado
          where pgcod  = i.pgcod
            and aosuc  = i.scsuc
            and aomda  = i.scmda
            and aopap  = i.scpap
            and aocta  = i.sccta
            and aooper = i.scoper
            and aosbop = i.scsbop
            and aotope = i.sctope ;
         
         update fsd011
            set scstat = i.estado
          where pgcod  = i.pgcod
            and scsuc  = i.scsuc
            and scmda  = i.scmda
            and scpap  = i.scpap
            and sccta  = i.sccta
            and scoper = i.scoper
            and scsbop = i.scsbop
            and sctope = i.sctope ;   
         commit;  
         begin 
             insert into fsd011_log (PGCOD,SCSUC,SCRUB,SCMDA,SCPAP,
                                            SCCTA,SCOPER,SCSBOP,SCTOPE,
                                            SCSDO,SCSTAT,ESTADO,TIPO,Fecpro) 
             values (i.PGCOD,i.SCSUC,i.SCRUB,i.SCMDA,i.SCPAP,
                     i.SCCTA,i.SCOPER,i.SCSBOP,i.SCTOPE,
                     i.SCSDO,i.SCSTAT,i.ESTADO,'UPD',pd_fecpro);
             commit;
         exception 
           when others then
             null;
         end;             
      end loop;
    end;    
 --***************************************************
 -- Vencido refinanciado
 --*************************************************** 
   begin 
       for i in ven_ref loop
         update fsd010
            set aostat = i.estado
          where pgcod  = i.pgcod
            and aosuc  = i.scsuc
            and aomda  = i.scmda
            and aopap  = i.scpap
            and aocta  = i.sccta
            and aooper = i.scoper
            and aosbop = i.scsbop
            and aotope = i.sctope ;
         
         update fsd011
            set scstat = i.estado
          where pgcod  = i.pgcod
            and scsuc  = i.scsuc
            and scmda  = i.scmda
            and scpap  = i.scpap
            and sccta  = i.sccta
            and scoper = i.scoper
            and scsbop = i.scsbop
            and sctope = i.sctope ;   
         commit;  
         begin 
             insert into fsd011_log (PGCOD,SCSUC,SCRUB,SCMDA,SCPAP,
                                            SCCTA,SCOPER,SCSBOP,SCTOPE,
                                            SCSDO,SCSTAT,ESTADO,TIPO,FECPRO) 
             values (i.PGCOD,i.SCSUC,i.SCRUB,i.SCMDA,i.SCPAP,
                     i.SCCTA,i.SCOPER,i.SCSBOP,i.SCTOPE,
                     i.SCSDO,i.SCSTAT,i.ESTADO,'UPD',pd_fecpro);
             commit;
         exception 
           when others then
             null;
         end;                                               
      end loop;
    end;    
 --***************************************************
 -- Refinaciado      
 --*************************************************** 
   begin 
       for i in refina loop
         update fsd010
            set aostat = i.estado
          where pgcod  = i.pgcod
            and aosuc  = i.scsuc
            and aomda  = i.scmda
            and aopap  = i.scpap
            and aocta  = i.sccta
            and aooper = i.scoper
            and aosbop = i.scsbop
            and aotope = i.sctope ;
         
         update fsd011
            set scstat = i.estado
          where pgcod  = i.pgcod
            and scsuc  = i.scsuc
            and scmda  = i.scmda
            and scpap  = i.scpap
            and sccta  = i.sccta
            and scoper = i.scoper
            and scsbop = i.scsbop
            and sctope = i.sctope ;   
         commit;
         begin 
             insert into fsd011_log (PGCOD,SCSUC,SCRUB,SCMDA,SCPAP,
                                            SCCTA,SCOPER,SCSBOP,SCTOPE,
                                            SCSDO,SCSTAT,ESTADO,TIPO,FECPRO) 
             values (i.PGCOD,i.SCSUC,i.SCRUB,i.SCMDA,i.SCPAP,
                     i.SCCTA,i.SCOPER,i.SCSBOP,i.SCTOPE,
                     i.SCSDO,i.SCSTAT,i.ESTADO,'UPD',pd_fecpro);
             commit;
         exception 
           when others then
             null;
         end;               
      end loop;
    end;    
   
 
--***************************************************
-- Demanda
--*************************************************** 
   begin 
       for i in demanda loop
         update fsd010
            set aostat = i.estado
          where pgcod  = i.pgcod
            and aosuc  = i.scsuc
            and aomda  = i.scmda
            and aopap  = i.scpap
            and aocta  = i.sccta
            and aooper = i.scoper
            and aosbop = i.scsbop
            and aotope = i.sctope ;
         
         update fsd011
            set scstat = i.estado
          where pgcod  = i.pgcod
            and scsuc  = i.scsuc
            and scmda  = i.scmda
            and scpap  = i.scpap
            and sccta  = i.sccta
            and scoper = i.scoper
            and scsbop = i.scsbop
            and sctope = i.sctope ;   
         commit;
         begin 
             insert into fsd011_log (PGCOD,SCSUC,SCRUB,SCMDA,SCPAP,
                                            SCCTA,SCOPER,SCSBOP,SCTOPE,
                                            SCSDO,SCSTAT,ESTADO,TIPO,Fecpro) 
             values (i.PGCOD,i.SCSUC,i.SCRUB,i.SCMDA,i.SCPAP,
                     i.SCCTA,i.SCOPER,i.SCSBOP,i.SCTOPE,
                     i.SCSDO,i.SCSTAT,i.ESTADO,'UPD',pd_fecpro);
             commit;
         exception 
           when others then
             null;
         end;               
      end loop;
    end;    
    
 --***************************************************
 -- Judicial Estado
 --*************************************************** 
    begin
      for i in judicial loop
         update fsd010
            set aostat = i.estado
          where pgcod  = i.pgcod
            and aosuc  = i.scsuc
            and aomda  = i.scmda
            and aopap  = i.scpap
            and aocta  = i.sccta
            and aooper = i.scoper
            and aosbop = i.scsbop
            and aotope = i.sctope ;
         
         update fsd011
            set scstat = i.estado
          where pgcod  = i.pgcod
            and scsuc  = i.scsuc
            and scmda  = i.scmda
            and scpap  = i.scpap
            and sccta  = i.sccta
            and scoper = i.scoper
            and scsbop = i.scsbop
            and sctope = i.sctope ;   
         commit; 
         begin 
             insert into fsd011_log (PGCOD,SCSUC,SCRUB,SCMDA,SCPAP,
                                            SCCTA,SCOPER,SCSBOP,SCTOPE,
                                            SCSDO,SCSTAT,ESTADO,TIPO,Fecpro) 
             values (i.PGCOD,i.SCSUC,i.SCRUB,i.SCMDA,i.SCPAP,
                     i.SCCTA,i.SCOPER,i.SCSBOP,i.SCTOPE,
                     i.SCSDO,i.SCSTAT,i.ESTADO,'UPD',pd_fecpro);
             commit;
         exception 
           when others then
             null;
         end;              
       end loop;
    end;
 --***************************************************
 -- Borra Judiciales
 --*************************************************** 
   begin
      for i in del_jud loop
          delete from fsd011 a
           where pgcod = i.pgcod
             and scsuc = i.scsuc
             and scmda = i.scmda
             and scpap = i.scpap
             and sccta = i.sccta
             and scoper= i.scoper
             and scsbop= i.scsbop
             and sctope= i.sctope
             and scmod = i.scmod
             and scsdo = 0
             and scrub = i.scrub
             and scstat = i.scstat;
          begin 
               insert into fsd011_log (PGCOD,SCSUC,SCRUB,SCMDA,SCPAP,
                                              SCCTA,SCOPER,SCSBOP,SCTOPE,
                                              SCSDO,SCSTAT,ESTADO,TIPO,Fecpro) 
               values (i.PGCOD,i.SCSUC,i.SCRUB,i.SCMDA,i.SCPAP,
                       i.SCCTA,i.SCOPER,i.SCSBOP,i.SCTOPE,
                       i.SCSDO,i.SCSTAT,NULL,'DEL',pd_fecpro);
               commit;
           exception 
             when others then
               null;
           end;          
      end loop;
      commit;
      
    end;

end sp_parche_tipifica;
/

