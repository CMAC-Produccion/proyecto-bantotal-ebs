CREATE OR REPLACE TRIGGER TG_JAQM750_AU_01
  after update on JAQM750
  for each row

DECLARE

 

  lc_msgvou varchar2(200);
  lc_msgbt  varchar2(150);
  ln_numcor number := 0;
  lc_existe char(1):= 'N';
  ld_jaqz695fep date;
  ld_jaqz695cor number;
  

BEGIN
  
  if  :new.jaqm750est in ('S', 'K') then 


      begin
        select j.jaqz695fep , j.jaqz695cor, 'S'
          into ld_jaqz695fep, ld_jaqz695cor, lc_existe
          from jaqz695 j
         where j.jaqz695pai = :new.jaqm750pai
           and j.jaqz695tdo = :new.jaqm750tdo
           and j.jaqz695ndo = :new.jaqm750ndo
           and j.jaqz695suc = :new.jaqm750suc
           and j.jaqz695mda = :new.jaqm750mda
           and j.jaqz695cta = :new.jaqm750cta
           and j.jaqz695mod = :new.jaqm750mod
           and j.jaqz695top = :new.jaqm750tip
           and j.jaqz695chk = 1;
           --and j.jaqz695au2 = 0;
      exception when others then
          lc_existe := 'N';
      end;

      if lc_existe = 'S' then
        
        lc_msgvou := 'Por Navidad Caja Arequipa tiene para ti un credito para recoger al instante solo con tu DNI en cualquier agencia';
        lc_msgbt  := 'Cliente con credito aprobado a sola firma';

        begin
          select max(jaqm100cor)
            into ln_numcor
            from jaqm100 j
           where j.jaqm100fpr = trunc(sysdate)
             and j.jaqm100cof = 99;
        exception
          when others then
            ln_numcor := 1;
        end;

        if ln_numcor is null then
          ln_numcor := 1;
        else
          ln_numcor := ln_numcor + 1;
        end if;



        begin
          insert into jaqm100
            (jaqm100pai,
             jaqm100tdo,
             jaqm100ndo,
             jaqm100tme,
             jaqm100cof,
             jaqm100cor,
             jaqm100fpr,
             jaqm100hpr,
             jaqm100mpa,
             jaqm100mvo,
             jaqm100fiv,
             jaqm100ffv,
             jaqm100cus,
             jaqm100ch1)
          
          values
            (:new.jaqm750pai,
             :new.jaqm750tdo,
             :new.jaqm750ndo,
             'I',
             99,
             ln_numcor,
             trunc(sysdate),
             to_char(sysdate, 'HH24:MI:SS'),
             lc_msgbt,
             lc_msgvou,
             to_date('13/12/2019', 'DD/MM/YYYY'),
             to_date('31/12/2019', 'DD/MM/YYYY'),
             'BANTOTAL',
             'C');
          exception when others then
             null;    
         end;    
            
        begin
          update jaqz695 a
             set a.jaqz695au2 = 1
           where a.jaqz695fep = ld_jaqz695fep
             and a.jaqz695cor = ld_jaqz695cor
             and a.jaqz695pai = :new.jaqm750pai
             and a.jaqz695tdo = :new.jaqm750tdo
             and a.jaqz695ndo = :new.jaqm750ndo;
                   
        exception when others then
             null;          
        end;     
             
       
        
          
  
      end if;
          
  end if;    


exception
  when others then
    null;

END TG_JAQM750_AU_01;
/

