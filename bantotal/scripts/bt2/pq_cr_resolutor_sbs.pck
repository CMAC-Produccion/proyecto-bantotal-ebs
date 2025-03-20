create or replace package PQ_CR_RESOLUTOR_SBS is

  -- Author  : ABERNEDO
  -- Created : 19/10/2017 05:10:55 p.m.
  -- Purpose : 
  
  Procedure Sp_Cr_segmentacion(pn_ins in number,pc_segm out char);
                                                                                                                                                          
end PQ_CR_RESOLUTOR_SBS;
/

create or replace package body PQ_CR_RESOLUTOR_SBS is

Procedure Sp_Cr_segmentacion(pn_ins in number,pc_segm out char)is
ln_item number(9);
lc_val char(30);
ln_pos number(5):=null;
begin

       begin
          select a.tp1nro1
            into ln_item
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 10899
             and a.tp1corr1 = 501
             and a.tp1corr2 = 1
             and a.tp1corr3 = 1;
       exception
             when others then null;
       end;
       
       begin
          select v.pae71val 
            into lc_val
           from  fpae70 n, 
                 fpae71 v 
           where n.pae70nro = v.pae70nro 
             and v.pae71ite = ln_item 
             and n.pae51eva = v.pae51eva 
             and v.pae51eva = 1
             and n.pae70nro = (select max(pae70nro) 
                                 from fpae70 
                                where pae70ins = pn_ins);

       exception
          when others then null;
       end;
       
       ln_pos := instr(lc_val,':');
       ln_pos := ln_pos - 1;
       pc_segm := substr(lc_val,1,ln_pos);
       
end Sp_Cr_segmentacion;


end PQ_CR_RESOLUTOR_SBS;
/

