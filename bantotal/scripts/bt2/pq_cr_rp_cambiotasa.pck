create or replace package PQ_CR_RP_CAMBIOTASA is

  -- Author  : MPOSTIGOC
  -- Created : 30/10/2019 9:35:50 a. m.
  -- Purpose : 

  procedure sp_cr_inicio(ln_Instancia  in number,
                         lc_CambioTasa out varchar2);

end PQ_CR_RP_CAMBIOTASA;
/

create or replace package body PQ_CR_RP_CAMBIOTASA is

  procedure sp_cr_inicio(ln_Instancia  in number,
                         lc_CambioTasa out varchar2) is
  
    ln_MinSubOpe   number := 0;
    ln_PgcodOri    number := 0;
    ln_SucOri      number := 0;
    ln_ModOri      number := 0;
    ln_MdaOri      number := 0;
    ln_PapOri      number := 0;
    ln_CtaOri      number := 0;
    ln_OpeOri      number := 0;
    ln_SbopOri     number := 0;
    ln_TopeOri     number := 0;
    ln_TasaOri     number(10, 6) := 0.00;
    ln_TasaOriF12  number(10, 6) := 0.00;
    ld_FchOriF12   date;
    ln_TasaOriX054 number(10, 6) := 0.00;
    ld_FchOriX054  date;
    ln_PgcodAct    number := 0;
    ln_SucAct      number := 0;
    ln_ModAct      number := 0;
    ln_MdaAct      number := 0;
    ln_PapAct      number := 0;
    ln_CtaAct      number := 0;
    ln_OpeAct      number := 0;
    ln_SbopAct     number := 0;
    ln_TopeAct     number := 0;
    ln_TasaActX054 number(10, 6) := 0.00;
    ld_FchActX054  date;
  
  begin
  
    lc_CambioTasa := 'N';
  
    begin
      -- Datos Credito Original
      begin
        select min(x.xwfsubope)
          into ln_MinSubOpe
          from xwf700 x
         where x.xwfprcins = ln_Instancia;
      exception
        when others then
          ln_MinSubOpe := 0;
      end;
    
      begin
        select x.xwfempresa,
               x.xwfsucursal,
               x.xwfmodulo,
               x.xwfmoneda,
               x.xwfpapel,
               x.xwfcuenta,
               x.xwfoperacion,
               x.xwfsubope,
               x.xwftipope
          into ln_PgcodOri,
               ln_SucOri,
               ln_ModOri,
               ln_MdaOri,
               ln_PapOri,
               ln_CtaOri,
               ln_OpeOri,
               ln_SbopOri,
               ln_TopeOri
          from xwf700 x
         where x.xwfprcins = ln_Instancia
           and x.xwfsubope = ln_MinSubOpe;
      exception
        when others then
          null;
      end;
    
      begin
        select x.xlltasap, x.xllfvalor
          into ln_TasaOriX054, ld_FchOriX054
          from x054023 x
         where x.xllpgcod = ln_PgcodOri
           and x.xllaomod = ln_ModOri
           and x.xllaosuc = ln_SucOri
           and x.xllaomda = ln_MdaOri
           and x.xllaopap = ln_PapOri
           and x.xllaocta = ln_CtaOri
           and x.xllaooper = ln_OpeOri
           and x.xllaosbop = ln_SbopOri
           and x.xllaotop = ln_TopeOri;
      exception
        when others then
          null;
      end;
    
      begin
        select f.evtasa, f.evfval
          into ln_TasaOriF12, ld_FchOriF12
          from fsd012 f
         where f.pgcod = ln_PgcodOri
           and f.aomod = ln_ModOri
           and f.aosuc = ln_SucOri
           and f.aomda = ln_MdaOri
           and f.aopap = ln_PapOri
           and f.aocta = ln_CtaOri
           and f.aooper = ln_OpeOri
           and f.aosbop = ln_SbopOri
           and f.aotope = ln_TopeOri
           and f.evtipo = 3;
      exception
        when others then
          null;
      end;
    
      if ld_FchOriF12 is not null then
        if ld_FchOriF12 >= ld_FchOriX054 then
          ln_TasaOri := ln_TasaOriF12;
        else
          ln_TasaOri := ln_TasaOriX054;
        end if;
      else
        if ld_FchOriF12 is null then
          ln_TasaOri := ln_TasaOriX054;
        end if;
      end if;
    
    end;
  
    begin
      -- Datos del Credito en Proceso
      begin
        select x.xwfempresa,
               x.xwfsucursal,
               x.xwfmodulo,
               x.xwfmoneda,
               x.xwfpapel,
               x.xwfcuenta,
               x.xwfoperacion,
               x.xwfsubope,
               x.xwftipope
          into ln_PgcodAct,
               ln_SucAct,
               ln_ModAct,
               ln_MdaAct,
               ln_PapAct,
               ln_CtaAct,
               ln_OpeAct,
               ln_SbopAct,
               ln_TopeAct
          from xwf700 x
         where x.xwfprcins = ln_Instancia
           and x.xwfcar3 = '1';
      exception
        when others then
          null;
      end;
    
      begin
        select x.xlltasap, x.xllfvalor
          into ln_TasaActX054, ld_FchActX054
          from x054023 x
         where x.xllpgcod = ln_PgcodAct
           and x.xllaomod = ln_ModAct
           and x.xllaosuc = ln_SucAct
           and x.xllaomda = ln_MdaAct
           and x.xllaopap = ln_PapAct
           and x.xllaocta = ln_CtaAct
           and x.xllaooper = ln_OpeAct
           and x.xllaosbop = ln_SbopAct
           and x.xllaotop = ln_TopeAct;
      exception
        when others then
          null;
      end;
    
    end;
  
    if ln_TasaOri <> ln_TasaActX054 then
      lc_CambioTasa := 'S';
    else
      lc_CambioTasa := 'N';
    end if;
  
  end sp_cr_inicio;
end PQ_CR_RP_CAMBIOTASA;
/

