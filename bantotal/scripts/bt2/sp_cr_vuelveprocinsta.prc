create or replace procedure SP_CR_VUELVEPROCINSTA(insta number) is
--Luis Carpio/Erika Hidalgo
cursor credito is
select a.jaqm750ins ln_ins,jaqm750fch,a.jaqm750reg from jaqm750 a where a.jaqm750ins = insta;--colocar instancia
ld_sis date;
ln_id number(10);
ln_cor number(9);
vct varchar2(1000);
begin

   begin
   select a.PGFAPE into ld_sis from fst017 a where pgcod=1;
   exception  when others then null;
   end;
   for i in credito loop
       if ld_sis = i.jaqm750fch then
          --baja solicitud
          begin
              select a.wfitemid
                into ln_id
                from wfwrkitems a
               where a.wfinsprcid = i.ln_ins
                 and a.wfitemstsact = 1;
            exception
              when others then
                ln_id := null;
                null;
            end;

            if ln_id is not null then
              execute immediate 'create table operador.wfworklist_'||to_char(systimestamp, 'DDMMRR_HH24MISSFF3')||SUBSTR(USER, 1, 3)||
                  ' as select * from wfworklist where wfwrklstitemid = '||ln_id;
            end if;

            delete from wfworklist c where c.wfwrklstitemid = ln_id;

            execute immediate 'create table operador.wfwrkitems_'||to_char(systimestamp, 'DDMMRR_HH24MISSFF3')||SUBSTR(USER, 1, 3)||
                ' as select * from wfwrkitems where wfinsprcid = '||i.ln_ins||' and wfitemstsact = 1';

            update wfwrkitems a
               set WFStsCod = 'B', WFItemStsAct = 0, WFItemEnd = sysdate
             where a.wfinsprcid = i.ln_ins
               and a.wfitemstsact = 1;

            execute immediate 'create table operador.wfinstprc_'||to_char(systimestamp, 'DDMMRR_HH24MISSFF3')||SUBSTR(USER, 1, 3)||
                ' as select * from wfinstprc where wfinsprcid = '||i.ln_ins;

            update wfinstprc b
               set WFInsPrcSta = 'B', WFInsPrcOSta = 0, WFInsPrcEnd = sysdate
             where b.wfinsprcid = i.ln_ins;

            commit;
          execute immediate 'create table operador.jaqm750_'||to_char(systimestamp, 'DDMMRR_HH24MISSFF3')||SUBSTR(USER, 1, 3)||
                      ' as select * from jaqm750 where jaqm750ins = '||i.ln_ins;

          update jaqm750 a
             set a.jaqm750ins = 0,
                 a.jaqm750est = 'O'
            where a.jaqm750ins = i.ln_ins;
            commit;

       end if;

       if ld_sis <> i.jaqm750fch then
          --baja solicitud
          begin
              select a.wfitemid
                into ln_id
                from wfwrkitems a
              where a.wfinsprcid = i.ln_ins
                 and a.wfitemstsact = 1;
            exception
              when others then
                ln_id:=null;
                null;
            end;

            if ln_id is not null then
              execute immediate 'create table operador.wfworklist_'||to_char(systimestamp, 'DDMMRR_HH24MISSFF3')||SUBSTR(USER, 1, 3)||
                    ' as select * from wfworklist where wfwrklstitemid = '||ln_id;
            end if;

            delete from wfworklist c where c.wfwrklstitemid = ln_id;

            execute immediate 'create table operador.wfwrkitems_'||to_char(systimestamp, 'DDMMRR_HH24MISSFF3')||SUBSTR(USER, 1, 3)||
                ' as select * from wfwrkitems where wfinsprcid = '||i.ln_ins||' and wfitemstsact = 1';

            update wfwrkitems a
               set WFStsCod = 'B', WFItemStsAct = 0, WFItemEnd = sysdate
             where a.wfinsprcid = i.ln_ins
               and a.wfitemstsact = 1;

            execute immediate 'create table operador.wfinstprc_'||to_char(systimestamp, 'DDMMRR_HH24MISSFF3')||SUBSTR(USER, 1, 3)||
                ' as select * from wfinstprc where wfinsprcid = '||i.ln_ins;

            update wfinstprc b
               set WFInsPrcSta = 'B', WFInsPrcOSta = 0, WFInsPrcEnd = sysdate
             where b.wfinsprcid = i.ln_ins;

            commit;

          begin
            select max(a.jaqm750reg)+1
              into ln_cor
              from jaqm750 a
             where a.jaqm750fch = ld_sis;
             exception when others then null;
            end;

        if ln_cor is not null  then

          execute immediate 'create table operador.jaqm751_'||to_char(systimestamp, 'DDMMRR_HH24MISSFF3')||SUBSTR(USER, 1, 3)||
                        ' as select * from jaqm751 where jaqm751fch = to_date('''||to_char(i.jaqm750fch,'YYYYMMDD')||''',''YYYYMMDD'') and jaqm751reg = '||i.jaqm750reg;

          update jaqm751 a
            set a.jaqm751fch = ld_sis,
                a.jaqm751reg = ln_cor
           where a.jaqm751fch = i.jaqm750fch
             and a.jaqm751reg = i.jaqm750reg;

          execute immediate 'create table operador.jaqm750_'||to_char(systimestamp, 'DDMMRR_HH24MISSFF3')||SUBSTR(USER, 1, 3)||
                        ' as select * from jaqm750 where jaqm750ins = '||i.ln_ins;

            update jaqm750 a
               set a.jaqm750ins = 0,
                   a.jaqm750est = 'O',
                   a.jaqm750fch = ld_sis,
                   a.jaqm750reg = ln_cor
              where a.jaqm750ins = i.ln_ins;
            commit;
         end if;
       end if;
   end loop;
   commit;
   insert into AQPB876 values (user,sysdate,'SP_CR_VUELVEPROCINSTA',
   insta);
   commit;
end SP_CR_VUELVEPROCINSTA;
/

