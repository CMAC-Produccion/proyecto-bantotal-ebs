create or replace procedure sp_actualiza_tipsbs (pd_fecpro in date) is

  cursor tipo is
     select 
     c.jqy470cfev,
     c.jqy470cnro,
     c.jqy470csec,
     c.jqy470ccta, 
     c.jqy470csuc,
     c.jqy470crub,
     c.jqy470cope, 
     c.jqy470cmod, 
     c.jqy470cmda, 
     substr(b.jqy470bide,11,10) ide
     from jaqy470c c
     inner join jaqy470b b
     on c.jqy470ccta = b.jqy470bcta
     where c.jqy470cfev = pd_fecpro;

  lc_tipsbs varchar2(2);
  ln_cnt number(2);
  
begin     

  for i in tipo loop
    begin

      SP_tipSBS(i.jqy470ccta, i.jqy470cope, i.jqy470cmod, i.ide, lc_tipsbs);
      
      if lc_tipsbs = '99' then

        for ln_cnt in reverse 4 .. 10 loop
        
          begin
            select substr(cicpo,7,2)
            into lc_tipsbs
            from fsi006
            where pgcod = 1
            and cicpo like 'ANEXO6%'
            and substr(rubro,1,ln_cnt) like substr(i.jqy470crub,1,ln_cnt)
            and rownum = 1;
            
          exception 
          when no_data_found then
            lc_tipsbs := '99';
          when others then
            dbms_output.put_line('-');
            dbms_output.put_line(sqlerrm);
          end;
          
          exit when lc_tipsbs <> '99';
        end loop;
         
      end if;

      update jaqy470c c1
      set c1.jqy470ctip = lc_tipsbs
      where c1.jqy470cfev = i.jqy470cfev
      and c1.jqy470cnro = i.jqy470cnro
      and c1.jqy470csec = i.jqy470csec
      and c1.jqy470ccta = i.jqy470ccta
      and c1.jqy470csuc = i.jqy470csuc
      and c1.jqy470crub = i.jqy470crub
      and c1.jqy470cope = i.jqy470cope
      and c1.jqy470cmod = i.jqy470cmod
      and c1.jqy470cmda = i.jqy470cmda;
    
      update jaqy470 c2
      set c2.jqy470tip = lc_tipsbs
      where c2.jqy470fev = i.jqy470cfev
      and c2.jqy470nro = i.jqy470cnro
      and c2.jqy470sec = i.jqy470csec
      and c2.jqy470cta = i.jqy470ccta
      and c2.jqy470suc = i.jqy470csuc
      and c2.jqy470rub = i.jqy470crub;

      commit;
      
    exception when others then
      dbms_output.put_line(sqlerrm);      
    end;
  end loop;

end;
/

