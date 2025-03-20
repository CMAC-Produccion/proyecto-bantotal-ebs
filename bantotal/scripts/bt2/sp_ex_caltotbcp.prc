create or replace procedure sp_ex_caltotbcp(pn_apl in number, ps_ban in varchar2, pn_env in number, pn_regini in number,
                                            pn_regfin in number, pn_totsol out number, pn_regsol out number)  is
Begin
   pn_totsol := 0;
   pn_regsol := 0;
   select count(*) into pn_regsol
     from jaql824t
    where jaql824apl = pn_Apl
      and jaql824ban = ps_Ban
      and jaql824env = pn_Env
      and jaql824treg > pn_regini 
      and jaql824treg <= pn_regfin;
   select round(sum(jaql824tmcu),2) into pn_totsol
     from jaql824t
    where jaql824apl = pn_Apl
      and jaql824ban = ps_Ban
      and jaql824env = pn_Env
      and jaql824treg > pn_regini 
      and jaql824treg <= pn_regfin;
end;
/

