create or replace package pq_cr_reporte_cajacash is

  procedure Sp_carga(pc_usr in char, pn_suc in number);

end pq_cr_reporte_cajacash;
/

create or replace package body pq_cr_reporte_cajacash is

  procedure Sp_carga(pc_usr in char, pn_suc in number) is
  
  begin
  
    delete from jaqz694_rep a where a.jaqz694rusp = pc_usr;
    commit;
  
    if pn_suc = 0 then
      begin
      
        insert into jaqz694_rep
          (jaqz694rins,
           jaqz694reva,
           jaqz694rmt1,
           jaqz694rmt2,
           jaqz694rmt3,
           jaqz694rmtf,
           jaqz694rseg,
           jaqz694rplz,
           jaqz694rnrc,
           jaqz694rrcc,
           jaqz694rfep,
           jaqz694rusr,
           jaqz694rsbs,
           jaqz694rfvt,
           jaqz694rfv1,
           jaqz694rusp,
           jaqz694rau2)
        
          select a.jaqz694ins,
                 a.jaqz694eva,
                 a.jaqz694mt1,
                 a.jaqz694mt2,
                 a.jaqz694mt3,
                 a.jaqz694mtf,
                 a.jaqz694seg,
                 a.jaqz694plz,
                 a.jaqz694nrc,
                 a.jaqz694rcc,
                 a.jaqz694fep,
                 a.jaqz694usr,
                 a.jaqz694sbs,
                 a.jaqz694fvt,
                 a.jaqz694fv1,
                 pc_usr,
                 b.xwfsucursal
          
            from jaqz694 a, xwf700 b
           where a.jaqz694ins = b.xwfprcins
             and b.xwfcar3 = '1'
             and b.xwfmodulo in (select distinct c.tp1nro1
                                   from fst198 c
                                  where c.tp1cod = 1
                                    and c.tp1cod1 = 10899
                                    and c.tp1corr1 = 5555
                                    and c.tp1corr2 = 8)
             and b.xwftipope in (select c.tp1nro2
                                   from fst198 c
                                  where c.tp1cod = 1
                                    and c.tp1cod1 = 10899
                                    and c.tp1corr1 = 5555
                                    and c.tp1corr2 = 8)
             and a.jaqz694mtf between 500 and 20000;
      
        commit;
      end;
    
    else
    
      begin
      
        insert into jaqz694_rep
          (jaqz694rins,
           jaqz694reva,
           jaqz694rmt1,
           jaqz694rmt2,
           jaqz694rmt3,
           jaqz694rmtf,
           jaqz694rseg,
           jaqz694rplz,
           jaqz694rnrc,
           jaqz694rrcc,
           jaqz694rfep,
           jaqz694rusr,
           jaqz694rsbs,
           jaqz694rfvt,
           jaqz694rfv1,
           jaqz694rusp,
           jaqz694rau2)
        
          select a.jaqz694ins,
                 a.jaqz694eva,
                 a.jaqz694mt1,
                 a.jaqz694mt2,
                 a.jaqz694mt3,
                 a.jaqz694mtf,
                 a.jaqz694seg,
                 a.jaqz694plz,
                 a.jaqz694nrc,
                 a.jaqz694rcc,
                 a.jaqz694fep,
                 a.jaqz694usr,
                 a.jaqz694sbs,
                 a.jaqz694fvt,
                 a.jaqz694fv1,
                 pc_usr,
                 b.xwfsucursal
          
            from jaqz694 a, xwf700 b
           where a.jaqz694ins = b.xwfprcins
             and b.xwfcar3 = '1'
             and b.xwfmodulo in (select distinct c.tp1nro1
                                   from fst198 c
                                  where c.tp1cod = 1
                                    and c.tp1cod1 = 10899
                                    and c.tp1corr1 = 5555
                                    and c.tp1corr2 = 8)
             and b.xwftipope in (select c.tp1nro2
                                   from fst198 c
                                  where c.tp1cod = 1
                                    and c.tp1cod1 = 10899
                                    and c.tp1corr1 = 5555
                                    and c.tp1corr2 = 8)
             and a.jaqz694mtf between 500 and 20000
             and b.xwfsucursal = pn_suc
          union
          
          select a.jaqz694ins,
                 a.jaqz694eva,
                 a.jaqz694mt1,
                 a.jaqz694mt2,
                 a.jaqz694mt3,
                 a.jaqz694mtf,
                 a.jaqz694seg,
                 a.jaqz694plz,
                 a.jaqz694nrc,
                 a.jaqz694rcc,
                 a.jaqz694fep,
                 a.jaqz694usr,
                 a.jaqz694sbs,
                 a.jaqz694fvt,
                 a.jaqz694fv1,
                 pc_usr,
                 d.xwftsuc
          
            from jaqz694 a, xwf700 b, xwf070 d
           where a.jaqz694ins = b.xwfprcins
             and b.xwfcar3 = '1'
             and b.xwfmodulo in (select distinct c.tp1nro1
                                   from fst198 c
                                  where c.tp1cod = 1
                                    and c.tp1cod1 = 10899
                                    and c.tp1corr1 = 5555
                                    and c.tp1corr2 = 8)
             and b.xwftipope in (select c.tp1nro2
                                   from fst198 c
                                  where c.tp1cod = 1
                                    and c.tp1cod1 = 10899
                                    and c.tp1corr1 = 5555
                                    and c.tp1corr2 = 8)
             and a.jaqz694mtf between 500 and 20000
             and a.jaqz694ins = d.xwfprcin
             and d.xwftsuc = pn_suc
             and d.xwfcont = 'S';
      
        commit;
      end;
    end if;
  end Sp_carga;

end pq_cr_reporte_cajacash;
/

