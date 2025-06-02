create or replace procedure sp_ex_caltot_amort(pn_apl in number, ps_ban in varchar2, pn_env in number, ps_Ent in varchar2,
                                         pn_totsol out number, pn_totdol out number, pn_regsol out number,
                                         pn_regdol out number)  is
-- *****************************************************************
-- Nombre                     : sp_ex_caltot_amort
-- Sistema                    : Bantotal
-- M�dulo                     : CONSULTAS BANTOTAL
-- Versi�n                    : 1.0
-- Fecha de Creaci�n          : 25/02/2025
-- Autor de Creaci�n          : Frank Pinto Carpio
-- Uso                        : Calculo de deudas totales de creditos 
-- Estado                     : Activo
-- Fecha Modificaci�n         : 
-- Autor de Modificaci�n      : 
-- Descripcion Modificacion   : 
-- *****************************************************************
Begin
   pn_totsol := 0;
   pn_totdol := 0;
   pn_regsol := 0;
   pn_regdol := 0;
   If ps_Ent = 'S' Then --Scotiabank
      select count(*) into pn_regsol
        from aqpd011b
       where aqpd011bcse = '001'
         and aqpd011apl = pn_Apl
         and aqpd011ban = ps_Ban
         and aqpd011env = pn_Env;
      select count(*) into pn_regdol
        from aqpd011b
       where aqpd011bcse = '002'
         and aqpd011apl = pn_Apl
         and aqpd011ban = ps_Ban
         and aqpd011env = pn_Env;
      select round(sum(aqpd011bic1),2) into pn_totsol
        from aqpd011b
       where aqpd011bcse='001'
         and aqpd011apl = pn_Apl
         and aqpd011ban = ps_Ban
         and aqpd011env = pn_Env;
      select round(sum(aqpd011bic1),2) into pn_totdol
        from aqpd011b
       where aqpd011bcse='002'
         and aqpd011apl = pn_Apl
         and aqpd011ban = ps_Ban
         and aqpd011env = pn_Env;
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
      if ps_Ban = '0004' then --BCP
         select count(*) into pn_regsol
           from aqpd011e
          where aqpd011apl = pn_Apl
            and aqpd011ban = ps_Ban
            and aqpd011env = pn_Env;
         select round(sum(aqpd011emcu),2) into pn_totsol
           from aqpd011e
          where aqpd011apl = pn_Apl
            and aqpd011ban = ps_Ban
            and aqpd011env = pn_Env;
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
