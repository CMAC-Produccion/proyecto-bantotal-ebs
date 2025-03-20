create or replace package PQ_CR_EXMEDICO is

  -- Author  : ABERNEDO
  -- Created : 07/04/2015 11:13:23 a.m.
  -- Purpose : 
  
  PROCEDURE SP_CARGA_DATA(PD_FECINI IN DATE, PD_FECFIN IN DATE);
  function fn_cr_years(P_D_FECPRO in date,P_D_FECNAC in date)return number;
  Procedure sp_cr_years(P_D_FECPRO in date,P_D_FECNAC in date, ln_year out number);

end PQ_CR_EXMEDICO;
/

create or replace package body PQ_CR_EXMEDICO is

PROCEDURE SP_CARGA_DATA(PD_FECINI IN DATE, PD_FECFIN IN DATE)IS

BEGIN
          execute immediate ('truncate table JAQZ056');
          update jaqy500 set jaqy500flg = 1 where jaqy500cod = 907;COMMIT;
          begin
          
              insert into JAQZ056(JAQZ056EMP,
                                  JAQZ056SUC,
                                  JAQZ056MOD,
                                  JAQZ056MDA,
                                  JAQZ056PAP,
                                  JAQZ056CTA,
                                  JAQZ056OPE,
                                  JAQZ056SBO,
                                  JAQZ056TOP,
                                  JAQZ056INS,
                                  JAQZ056MTO,
                                  JAQZ056CR3,
                                  JAQZ056FEC)
                select a.xwfempresa,
                       a.xwfsucursal,
                       a.xwfmodulo,
                       a.xwfmoneda,
                       a.xwfpapel,
                       a.xwfcuenta,
                       a.xwfoperacion,
                       a.xwfsubope,
                       a.xwftipope,
                       a.xwfprcins,
                       a.xwfmonto1,
                       a.xwfcar3,
                       b.wfiteminit

                  from xwf700 a, 
                       wfwrkitems b
                 where a.xwfprcins = b.wfinsprcid
                   and b.wfstscod not in ('C','D')
                   and b.wfiteminit = (select min(bb.wfiteminit)
                                          from wfwrkitems bb
                                         where bb.wfinsprcid = b.wfinsprcid
                                         ) 
                   and to_date(b.wfiteminit,'dd/mm/yy') between to_date(pd_fecini,'dd/mm/yy') 
                                                            and to_date(pd_fecfin,'dd/mm/yy');
                   
                   
                   COMMIT;
           end; 
           begin
               update jaqy500 set jaqy500flg = 0 where jaqy500cod = 907;COMMIT;
          end;
END SP_CARGA_DATA;

function fn_cr_years(P_D_FECPRO in date,P_D_FECNAC in date) return number is

      ld_fecpro date;
      ld_fecnac date;
      
      ln_year number;
    begin
      -- Datos según Parámetros.
      ld_fecpro := trunc(P_D_FECPRO);
      ld_fecnac := trunc(P_D_FECNAC);
      --
      ln_year := to_number(to_char(ld_fecpro,'yyyy')) - to_number(to_char(ld_fecnac,'yyyy'));
      if (ln_year > 0) then
         if (to_char(ld_fecpro,'mm') < to_char(ld_fecnac,'mm')) then
            ln_year := ln_year - 1;
         else
            if (to_char(ld_fecpro,'mm') = to_char(ld_fecnac,'mm')) and (to_char(ld_fecpro,'dd') < to_char(ld_fecnac,'dd')) then
               ln_year := ln_year - 1;
            end if;
         end if;
      else
         ln_year := null;
      end if;
      return(ln_year);
    exception
      when others then
        return(null);
end fn_cr_years;

Procedure sp_cr_years(P_D_FECPRO in date,P_D_FECNAC in date, ln_year out number) is

      ld_fecpro date;
      ld_fecnac date;
      
      --ln_year number;
    begin
      -- Datos según Parámetros.
      ld_fecpro := trunc(P_D_FECPRO);
      ld_fecnac := trunc(P_D_FECNAC);
      --
      ln_year := to_number(to_char(ld_fecpro,'yyyy')) - to_number(to_char(ld_fecnac,'yyyy'));
      if (ln_year > 0) then
         if (to_char(ld_fecpro,'mm') < to_char(ld_fecnac,'mm')) then
            ln_year := ln_year - 1;
         else
            if (to_char(ld_fecpro,'mm') = to_char(ld_fecnac,'mm')) and (to_char(ld_fecpro,'dd') < to_char(ld_fecnac,'dd')) then
               ln_year := ln_year - 1;
            end if;
         end if;
      else
         ln_year := null;
      end if;
      --return(ln_year);
    exception
      when others then
        ln_year := null;
end sp_cr_years;

end PQ_CR_EXMEDICO;
/

