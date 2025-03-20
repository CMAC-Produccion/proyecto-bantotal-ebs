create or replace procedure SP_CR_REGREPROPANALI(insta number) is
--Luis Carpio/Erika Hidalgo
  cursor creditos is

    select *
      from jaqm750 a, jaqz697 b
     where a.jaqm750ins = insta
       and a.jaqm750fch >= b.jaqz697fep
--and b.jaqz697fep>=to_date('03062020','DDMMYYYY')
and b.jaqz697fep>=(select max(JAQZ697FEP) from jaqz697)--10/07/2020
       and a.jaqm750pai = b.JAQZ697PAI
       and a.jaqm750tdo = b.JAQZ697TDO
       and a.jaqm750ndo = b.JAQZ697NDO
       and a.jaqm750mod = b.JAQZ697MOD
       and a.jaqm750tip = b.JAQZ697TOP
       and a.jaqm750suc = b.JAQZ697SUC
       and a.jaqm750mda = b.JAQZ697MDA
       and a.jaqm750cta = b.JAQZ697CTA
       and a.jaqm750imp = b.JAQZ697MTO
       and a.jaqm750cuo = b.JAQZ697CUO;
  ln_ins number(10);
  ld_Fec date;
  ln_cor number(9);
  ln_id  number(10);

begin

  for i in creditos loop

    if i.jaqm750ins <> 0 then
      begin
        select a.wfitemid
          into ln_id
          from wfwrkitems a
         where a.wfinsprcid = i.jaqm750ins
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

      commit;

      execute immediate 'create table operador.wfwrkitems_'||to_char(systimestamp, 'DDMMRR_HH24MISSFF3')||SUBSTR(USER, 1, 3)||
                ' as select * from wfwrkitems where wfinsprcid = '||i.jaqm750ins||' and wfitemstsact = 1';

      update wfwrkitems a
         set WFStsCod = 'B', WFItemStsAct = 0, WFItemEnd = sysdate
       where a.wfinsprcid = i.jaqm750ins
         and a.wfitemstsact = 1;

      commit;

      execute immediate 'create table operador.wfinstprc_'||to_char(systimestamp, 'DDMMRR_HH24MISSFF3')||SUBSTR(USER, 1, 3)||
                ' as select * from wfinstprc where wfinsprcid = '||i.jaqm750ins;

      update wfinstprc b
         set WFInsPrcSta = 'B', WFInsPrcOSta = 0, WFInsPrcEnd = sysdate
       where b.wfinsprcid = i.jaqm750ins;

      commit;
    end if;

    execute immediate 'create table operador.jaqm751_'||to_char(systimestamp, 'DDMMRR_HH24MISSFF3')||SUBSTR(USER, 1, 3)||
                      ' as select * from jaqm751 where jaqm751fch = to_date('''||to_char(i.jaqm750fch,'YYYYMMDD')||''',''YYYYMMDD'') and jaqm751reg = '||i.jaqm750reg;

    delete from jaqm751 a
     where a.jaqm751fch = i.jaqm750fch
       and a.jaqm751reg = i.jaqm750reg;

    commit;

    execute immediate 'create table operador.jaqm750_'||to_char(systimestamp, 'DDMMRR_HH24MISSFF3')||SUBSTR(USER, 1, 3)||
                      ' as select * from jaqm750 where jaqm750fch =  to_date('''||to_char(i.jaqm750fch,'YYYYMMDD')||''',''YYYYMMDD'') and jaqm750reg = '||i.jaqm750reg;

    delete from jaqm750 a
     where a.jaqm750fch = i.jaqm750fch
       and a.jaqm750reg = i.jaqm750reg;

    commit;

    execute immediate 'create table operador.aqpa190a_'||to_char(systimestamp, 'DDMMRR_HH24MISSFF3')||SUBSTR(USER, 1, 3)||
                      ' as select * from aqpa190a where aqpa190aeval = '||i.jaqz697eva;

    delete from aqpa190a a where a.aqpa190aeval = i.jaqz697eva;

    commit;

    execute immediate 'create table operador.aqpa190b_'||to_char(systimestamp, 'DDMMRR_HH24MISSFF3')||SUBSTR(USER, 1, 3)||
                      ' as select * from aqpa190b where aqpa190beval = '||i.jaqz697eva;

    delete from aqpa190b a where a.aqpa190beval = i.jaqz697eva;
    commit;

    execute immediate 'create table operador.aqpa190d_'||to_char(systimestamp, 'DDMMRR_HH24MISSFF3')||SUBSTR(USER, 1, 3)||
                      ' as select * from aqpa190d where aqpa190dneva = '||i.jaqz697eva;

    delete from aqpa190d a where a.aqpa190dneva = i.jaqz697eva;
    commit;

    execute immediate 'create table operador.jaqz697_'||to_char(systimestamp, 'DDMMRR_HH24MISSFF3')||SUBSTR(USER, 1, 3)||
                      ' as select * from jaqz697 where jaqz697fep = to_date('''||to_char(i.jaqz697fep,'YYYYMMDD')||''',''YYYYMMDD'') and jaqz697cor = '||i.jaqz697cor;

    update jaqz697 a
       set a.jaqz697au5 = 'N',
           a.jaqz697fan = null,
           a.jaqz697caj = null,
           a.jaqz697apr = 'N'
     where a.jaqz697fep = i.jaqz697fep
       and a.jaqz697cor = i.jaqz697cor
       AND a.JAQZ697AU5 <>'H';--29.11 indicado por Cinthya Liz Hernandez 

    commit;
  end loop;
  commit;
  insert into AQPB876 values (user,sysdate,'SP_CR_REGREPROPANALI',   insta);
  commit;
end SP_CR_REGREPROPANALI;
/

