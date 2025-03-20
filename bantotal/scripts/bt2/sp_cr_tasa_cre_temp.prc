create or replace procedure sp_cr_tasa_cre_temp
is
  cursor listado is
    select aqpb002fep, --35
           aqpb002cor,
           aqpb002emp,
           aqpb002mod,
           aqpb002suc,
           aqpb002mda,
           aqpb002pap,
           aqpb002cta,
           aqpb002ope,
           aqpb002sbo,
           aqpb002top,
           j.jaqa250fre
      from jaqa250 j, aqpb002 a
     where a.aqpb002emp = j.jaqa250emp
       and a.aqpb002mod = j.jaqa250mod
       and a.aqpb002suc = j.jaqa250suc
       and a.aqpb002mda = j.jaqa250mda
       and a.aqpb002pap = j.jaqa250pap
       and a.aqpb002cta = j.jaqa250cta
       and a.aqpb002ope = j.jaqa250ope
       and a.aqpb002sbo = j.jaqa250sbo
       and a.aqpb002top = j.jaqa250tpo
       and a.aqpb002feca > TO_DATE('27/05/2020','DD/MM/YYYY')
       and j.jaqa250est = 'S';

ln_corr number;
ln_ultima number;

BEGIN

  ln_corr := 0;
  for i in listado loop
    begin
      --aqui hay q verificar que no haya otro correlativo posterior.
      select max(f.evcorr)
        into ln_corr
        from fsd012 f
       where f.pgcod = i.aqpb002emp
         and f.aomod = i.aqpb002mod
         and f.aosuc = i.aqpb002suc
         and f.aomda = i.aqpb002mda
         and f.aopap = i.aqpb002pap
         and f.aocta = i.aqpb002cta
         and f.aooper = i.aqpb002ope
         and f.aosbop = i.aqpb002sbo
         and f.aotope = i.aqpb002top
         and f.evtipo = 3
         and f.evfval = i.jaqa250fre;
    exception
      when others then
        ln_corr := 0;

    end;

    ---obtiene  ultimo fsd012
    begin
      select max(f.evcorr)
        into ln_ultima
        from fsd012 f
       where f.pgcod = i.aqpb002emp
         and f.aomod = i.aqpb002mod
         and f.aosuc = i.aqpb002suc
         and f.aomda = i.aqpb002mda
         and f.aopap = i.aqpb002pap
         and f.aocta = i.aqpb002cta
         and f.aooper = i.aqpb002ope
         and f.aosbop = i.aqpb002sbo
         and f.aotope = i.aqpb002top
         and f.evtipo = 3;
    exception
      when others then
        ln_ultima := 0;
    end;
    ---

    if  ln_corr >= ln_ultima then

        if ln_corr <> 0 then
          DELETE FROM FSD012 f
           where f.pgcod = i.aqpb002emp
             and f.aomod = i.aqpb002mod
             and f.aosuc = i.aqpb002suc
             and f.aomda = i.aqpb002mda
             and f.aopap = i.aqpb002pap
             and f.aocta = i.aqpb002cta
             and f.aooper = i.aqpb002ope
             and f.aosbop = i.aqpb002sbo
             and f.aotope = i.aqpb002top
             and f.evtipo = 3
             and f.evfval = i.jaqa250fre
             and f.evcorr = ln_corr;

            commit;
        end if;

        --dbms_output.put_line(i.aqpb002cta || ' '|| i.aqpb002ope || ' - ' ||ln_corr || ' ultima '|| ln_ultima);
    end if;

  end loop;

END sp_cr_tasa_cre_temp;
/

