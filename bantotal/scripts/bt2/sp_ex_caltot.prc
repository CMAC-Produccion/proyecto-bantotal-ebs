create or replace procedure sp_ex_caltot(pn_apl in number, ps_ban in varchar2, pn_env in number, ps_Ent in varchar2,
                                         pn_totsol out number, pn_totdol out number, pn_regsol out number,
                                         pn_regdol out number)  is
Begin
   pn_totsol := 0;
   pn_totdol := 0;
   pn_regsol := 0;
   pn_regdol := 0;
   If ps_Ent = 'S' Then
      select count(*) into pn_regsol
        from jaql824i
       where jaql824icse = '001'
         and jaql824apl = pn_Apl
         and jaql824ban = ps_Ban
         and jaql824env = pn_Env;
      select count(*) into pn_regdol
        from jaql824i
       where jaql824icse = '002'
         and jaql824apl = pn_Apl
         and jaql824ban = ps_Ban
         and jaql824env = pn_Env;
      select round(sum(jaql824iic1),2) into pn_totsol
        from jaql824i
       where jaql824icse='001'
         and jaql824apl = pn_Apl
         and jaql824ban = ps_Ban
         and jaql824env = pn_Env;
      select round(sum(jaql824iic1),2) into pn_totdol
        from jaql824i
       where jaql824icse='002'
         and jaql824apl = pn_Apl
         and jaql824ban = ps_Ban
         and jaql824env = pn_Env;
   Else
      if ps_Ban = '0002' then
         select count(*) into pn_regsol
           from jaql824c
          where jaql824apl = pn_Apl
            and jaql824ban = ps_Ban
            and jaql824env = pn_Env;
         select round(sum(jaql824cdc1),2) into pn_totsol
          from jaql824c
         where jaql824apl = pn_Apl
           and jaql824ban = ps_Ban
           and jaql824env = pn_Env
           and jaql824cmde = 1;
         select round(sum(jaql824cdc1),2) into pn_totdol
           from jaql824c
          where jaql824apl = pn_Apl
            and jaql824ban = ps_Ban
            and jaql824env = pn_Env
            and jaql824cmde = 10;
      end if;
      if ps_Ban = '0003' then
         select count(*) into pn_regsol
           from jaql824q
          where jaql824apl = pn_Apl
            and jaql824ban = ps_Ban
            and jaql824env = pn_Env;
         select round(sum(jaql824qdc1),2) into pn_totsol
           from jaql824q
          where jaql824apl = pn_Apl
            and jaql824ban = ps_Ban
            and jaql824env = pn_Env
            and jaql824qmde = 1;
         select round(sum(jaql824qdc1),2) into pn_totdol
           from jaql824q
          where jaql824apl = pn_Apl
            and jaql824ban = ps_Ban
            and jaql824env = pn_Env
            and jaql824qmde = 10;
      end if;
      if ps_Ban = '0004' then
         select count(*) into pn_regsol
           from jaql824t
          where jaql824apl = pn_Apl
            and jaql824ban = ps_Ban
            and jaql824env = pn_Env;
         select round(sum(jaql824tmcu),2) into pn_totsol
           from jaql824t
          where jaql824apl = pn_Apl
            and jaql824ban = ps_Ban
            and jaql824env = pn_Env;
          pn_totdol := 0;
          pn_regdol := 0;
      end if;
      if ps_Ban = '0005' then
         select count(*) into pn_regsol
           from jaql824w
          where jaql824apl = pn_Apl
            and jaql824ban = ps_Ban
            and jaql824env = pn_Env;
         select round(sum(jaql824wic1),2) into pn_totsol
           from jaql824w
          where jaql824apl = pn_Apl
            and jaql824ban = ps_Ban
            and jaql824env = pn_Env;
          pn_totdol := 0;
          pn_regdol := 0;
      end if;
      if ps_Ban = '0006' then
         select count(*) into pn_regsol
           from jaql824f
          where jaql824apl = pn_Apl
            and jaql824ban = ps_Ban
            and jaql824env = pn_Env;
         select round(sum(JAQL824FIMA),2) into pn_totsol
           from jaql824f
          where jaql824apl = pn_Apl
            and jaql824ban = ps_Ban
            and jaql824env = pn_Env;
          pn_totdol := 0;
          pn_regdol := 0;
      end if;
   End If;
end;
/

