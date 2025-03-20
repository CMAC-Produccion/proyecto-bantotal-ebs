create or replace package PQ_CR_RN_REPROGRAMADOS is

  -- **********************************************************************************
  -- NOMBRE                      : PQ_CR_RN_REPROGRAMADOS
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 20/09/2024
  -- AUTOR DE CREACION           : MILTON CORDOVA
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -------------------------------------------------------------------------------------
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  --                               
  -- **********************************************************************************

  PROCEDURE sp_cr_VerfCalTitConyRL6M(ln_ins     in number,
                                     lc_var     out varchar2,
                                     lc_cod_err out varchar2,
                                     lc_msg_err out varchar2);

  PROCEDURE sp_cr_resolutorA(ln_ins     in number,
                             lc_var     out varchar2,
                             lc_cod_err out varchar2,
                             lc_msg_err out varchar2);

end PQ_CR_RN_REPROGRAMADOS;
/

create or replace package body PQ_CR_RN_REPROGRAMADOS is

  procedure sp_cr_VerfCalTitConyRL6M(ln_ins     in number,
                                     lc_var     out varchar2,
                                     lc_cod_err out varchar2,
                                     lc_msg_err out varchar2) is
  
    -- **********************************************************************************
    -- NOMBRE                      : sp_cr_VerfCalTitConyRL6M
    -- SISTEMA                     : BANTOTAL
    -- MODULO                      : CREDITOS - ACTIVAS
    -- VERSION                     : 1.0
    -- FECHA DE CREACION           : 20/09/2024
    -- AUTOR DE CREACION           : MILTON CORDOVA
    -- USO                         : VERIFICA SI TITULAR / CONYUGUE O TITULAR / REPRS LEGAL 
    --                               TIENE CALIF 100% NORMAL EN EL ULTIMO PERIODO
    -- PARAMETROS                  : ln_ins     | NUMBER
    --                               lc_var     | varchar2
    --                               lc_cod_err | varchar2
    --                               lc_msg_err | varchar2
    -- ESTADO                      : ACTIVO
    -- ACCESO                      : PUBLICO
    -------------------------------------------------------------------------------------
    -- FECHA DE MODIFICACION       : 
    -- AUTOR DE LA MODIFICACION    : 
    -- DESCRIPCION DE MODIFICACION : 
    --
    -- **********************************************************************************                                 
  
    ld_FchRCC       date;
    ln_PaisDoc      number;
    ln_TipoDoc      number;
    lc_Ndoc         varchar2(12);
    ln_PaisDocII    number;
    ln_TipoDocII    number;
    lc_NdocII       varchar2(12);
    lc_FlagCalif    varchar2(2) := 'N';
    ln_ctdocid      varchar2(1);
    ln_ctdocidII    varchar2(1);
    ln_Calificacion number;
  
  begin
  
    begin
      --Extrae Datos del Titular
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_PaisDoc, ln_TipoDoc, lc_Ndoc
        from sng001 s
       where s.sng001inst = ln_Ins;
    exception
      when others then
        null;
    end;
  
    if ln_PaisDoc is not null then
      begin
        select to_char(a.tp1corr3)
          into ln_ctdocid
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 11111
           and a.tp1corr1 = 1
           and a.tp1corr2 = 3
           and a.tp1nro1 = ln_TipoDoc;
      exception
        when others then
          null;
        
      end;
    
      if ln_TipoDoc = 21 then
        begin
          select f.rppais, f.rptdoc, f.rpndoc
            into ln_PaisDocII, ln_TipoDocII, lc_NdocII
            from fsr002 f
           where f.pepais = ln_PaisDoc
             and f.petdoc = ln_TipoDoc
             and f.pendoc = lc_Ndoc
             and f.rpccyg = 66;
        exception
          when others then
            null;
        end;
        if ln_TipoDoc = 9 then
          begin
            select f.pfpai1, f.pftdo1, f.pfndo1
              into ln_PaisDocII, ln_TipoDocII, lc_NdocII
              from fsr003 f
             where f.pjpais = ln_PaisDoc
               and f.pjtdoc = ln_TipoDoc
               and f.pjndoc = lc_Ndoc
               and f.vicod = 7;
          exception
            when others then
              null;
          end;
        end if;
      
        begin
          select to_char(a.tp1corr3)
            into ln_ctdocidII
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 11111
             and a.tp1corr1 = 1
             and a.tp1corr2 = 3
             and a.tp1nro1 = ln_TipoDocII;
        exception
          when others then
            null;
        end;
      
      end if;
    
      begin
        -- Extrae Fecha RCC
        select to_date(to_char(Tpnro), 'dd/mm/yyyy')
          into ld_FchRCC
          from FST098
         Where Pgcod = 1
           and Tpcod = 7647
           and Tpcorr = 12;
      exception
        when others then
          null;
      end;
    
      begin
        -- Extrae Calificacion      
        select c.n_calif0
          into ln_Calificacion
          from cldrcci c
         where c.c_docide = trim(lc_Ndoc)
           and c.c_tdocid = ln_ctdocid
           and c.d_fecpre = ld_FchRCC;
      exception
        when no_data_found then
          lc_FlagCalif := 'N';
        when too_many_rows then
          begin
            select c.n_calif0
              into ln_Calificacion
              from cldrcci c
             where c.c_docide = trim(lc_Ndoc)
               and c.c_tdocid = ln_ctdocid
               and c.d_fecpre = ld_FchRCC
               and c.c_person = '1'
               and rownum = 1;
          end;
      end;
    
      if ln_Calificacion = 100 then
        lc_FlagCalif := 'N';
      else
        if ln_Calificacion < 100 then
          lc_FlagCalif := 'S';
        end if;
      end if;
    
      if lc_FlagCalif = 'N' and lc_NdocII is not null then
      
        ln_Calificacion := null;
      
        begin
          -- Extrae Calificacion        
          select c.n_calif0
            into ln_Calificacion
            from cldrcci c
           where c.c_docide = trim(lc_NdocII)
             and c.c_tdocid = ln_ctdocidII
             and c.d_fecpre = ld_FchRCC;
        exception
          when no_data_found then
            lc_FlagCalif := 'N';
          when too_many_rows then
            begin
              select c.n_calif0
                into ln_Calificacion
                from cldrcci c
               where c.c_docide = trim(lc_NdocII)
                 and c.c_tdocid = ln_ctdocidII
                 and c.d_fecpre = ld_FchRCC
                 and c.c_person = '1'
                 and rownum = 1;
            exception
              when others then
                null;
            end;
        end;
      
        if ln_Calificacion = 100 then
          lc_FlagCalif := 'N';
        else
          if ln_Calificacion < 100 then
            lc_FlagCalif := 'S';
          end if;
        end if;
      
      end if;
    
    else
      lc_FlagCalif := 'N';
    end if;
    lc_var := lc_FlagCalif;
  end sp_cr_VerfCalTitConyRL6M;

  PROCEDURE sp_cr_resolutorA(ln_ins     in number,
                             lc_var     out varchar2,
                             lc_cod_err out varchar2,
                             lc_msg_err out varchar2) is
  
    -- **********************************************************************************
    -- NOMBRE                      : sp_cr_resolutorA
    -- SISTEMA                     : BANTOTAL
    -- MODULO                      : CREDITOS - ACTIVAS
    -- VERSION                     : 1.0
    -- FECHA DE CREACION           : 20/09/2024
    -- AUTOR DE CREACION           : MILTON CORDOVA
    -- USO                         : VALIDA SI TIENE MORA
    -- PARAMETROS                  : ln_ins     | NUMBER
    --                               lc_var     | varchar2
    --                               lc_cod_err | varchar2
    --                               lc_msg_err | varchar2
    -- ESTADO                      : ACTIVO
    -- ACCESO                      : PUBLICO
    -------------------------------------------------------------------------------------
    -- FECHA DE MODIFICACION       : 
    -- AUTOR DE LA MODIFICACION    : 
    -- DESCRIPCION DE MODIFICACION : 
    --
    -- **********************************************************************************
  
    ld_FchCalnda date;
    ln_Pepais    number;
    ln_Petdoc    number;
    ln_Pendoc    char(12);
    ld_FchPrc    date;
    cursor data is
      select d10.pgcod  ln_pgcod,
             d10.aomod  ln_modulo,
             d10.aosuc  ln_sucursal,
             d10.aomda  ln_moneda,
             d10.aopap  ln_papel,
             d10.aocta  ln_cuenta,
             d10.aooper ln_operacion,
             d10.aosbop ln_sbopera,
             d10.aotope ln_tipopera
        from fsd010 d10
       where d10.pgcod = 1
         and Aocta in (select Ctnro
                         from fsr008
                        where pepais = ln_Pepais
                          and Petdoc = ln_Petdoc
                          and pendoc = ln_Pendoc)
         and (Aomod in (select modulo
                          from fst111
                         where dscod = 50
                           and modulo not in (107, 108, 141)))
            
         and d10.aostat <> 99
       group by d10.pgcod,
                d10.aomod,
                d10.aosuc,
                d10.aomda,
                d10.aopap,
                d10.aocta,
                d10.aooper,
                d10.aosbop,
                d10.aotope
      union
      select b.pgcod  ln_pgcod,
             b.aomod  ln_modulo,
             b.aosuc  ln_sucursal,
             b.aomda  ln_moneda,
             b.aopap  ln_papel,
             b.aocta  ln_cuenta,
             b.aooper ln_operacion,
             b.aosbop ln_sbopera,
             b.aotope ln_tipopera
        from fsr008 a, fsd010 b, fsr002 c
       where a.pgcod = 1
         and b.pgcod = 1
         and c.pepais = ln_Pepais
         and c.petdoc = ln_Petdoc
         and c.pendoc = ln_Pendoc
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and (b.Aomod in (select modulo
                            from fst111
                           where dscod = 50
                             and modulo not in (107, 108, 141)))
         and c.rpccyg = 66
            
         and b.aostat <> 99
       group by b.pgcod,
                b.aomod,
                b.aosuc,
                b.aomda,
                b.aopap,
                b.aocta,
                b.aooper,
                b.aosbop,
                b.aotope;
    lc_Flag      varchar(2);
    ld_NroCuotas number;
    ld_fchdesm   date;
  
  begin
    begin
      SELECT PGFAPE
        INTO ld_FchPrc
        FROM FST017
       WHERE PGCOD = 1
         AND ROWNUM = 1;
    exception
      when others then
        null;
    end;
  
    begin
      SELECT SNG001PAIS, SNG001TDOC, SNG001NDOC
        INTO ln_Pepais, ln_Petdoc, ln_Pendoc
        FROM SNG001
       WHERE SNG001INST = ln_ins;
    exception
      when others then
        null;
    end;
  
    for i in data loop
    
      lc_var := 'N';
    
      begin
        select count(*)
          into ld_NroCuotas
          from fsd601 f
         where f.pgcod = i.ln_pgcod
           and f.ppmod = i.ln_modulo
           and f.ppsuc = i.ln_sucursal
           and f.ppmda = i.ln_moneda
           and f.pppap = i.ln_papel
           and f.ppcta = i.ln_cuenta
           and f.ppoper = i.ln_operacion
           and f.ppsbop = i.ln_sbopera
           and f.pptope = i.ln_tipopera;
      exception
        when no_data_found then
          ld_NroCuotas := 0;
      end;
    
      if ld_NroCuotas > 1 then
      
        begin
          begin
            select max(f.ppfpag)
              into ld_FchCalnda
              from fsd601 f
             where f.pgcod = i.ln_pgcod
               and f.ppmod = i.ln_modulo
               and f.ppsuc = i.ln_sucursal
               and f.ppmda = i.ln_moneda
               and f.pppap = i.ln_papel
               and f.ppcta = i.ln_cuenta
               and f.ppoper = i.ln_operacion
               and f.ppsbop = i.ln_sbopera
               and f.pptope = i.ln_tipopera
               and f.ppfpag <= ld_FchPrc;
          exception
            when others then
              null;
          end;
        
          begin
            select 'S'
              into lc_Flag
              from fsd602 f
             where f.pgcod = i.ln_pgcod
               and f.ppmod = i.ln_modulo
               and f.ppsuc = i.ln_sucursal
               and f.ppmda = i.ln_moneda
               and f.pppap = i.ln_papel
               and f.ppcta = i.ln_cuenta
               and f.ppoper = i.ln_operacion
               and f.ppsbop = i.ln_sbopera
               and f.pptope = i.ln_tipopera
               and f.ppfpag = ld_FchCalnda
               and f.pp1stat = 'T'
               and f.d602co = 'S'
               and rownum = 1;
          exception
            when no_data_found then
              lc_Flag := 'N';
          end;
        
          if lc_Flag = 'S' then
            lc_var := 'N'; -- No Deudor
          else
            if lc_Flag = 'N' then
              lc_var := 'S'; -- Si Deudor
              exit;
            end if;
          end if;
        
        end;
      
      else
        if ld_NroCuotas = 1 then
        
          begin
            select d.aofval
              into ld_fchdesm
              from fsd010 d
             where d.pgcod = i.ln_pgcod
               and d.aomod = i.ln_modulo
               and d.aosuc = i.ln_sucursal
               and d.aomda = i.ln_moneda
               and d.aopap = i.ln_papel
               and d.aocta = i.ln_cuenta
               and d.aooper = i.ln_operacion
               and d.aosbop = i.ln_sbopera
               and d.aotope = i.ln_tipopera
               and d.aostat <> 99;
          exception
            when others then
              null;
          end;
        
          begin
            select max(f.ppfpag)
              into ld_FchCalnda
              from fsd601 f
             where f.pgcod = i.ln_pgcod
               and f.ppmod = i.ln_modulo
               and f.ppsuc = i.ln_sucursal
               and f.ppmda = i.ln_moneda
               and f.pppap = i.ln_papel
               and f.ppcta = i.ln_cuenta
               and f.ppoper = i.ln_operacion
               and f.ppsbop = i.ln_sbopera
               and f.pptope = i.ln_tipopera;
          exception
            when others then
              null;
          end;
        
          if ld_fchdesm < ld_FchPrc and ld_FchCalnda >= ld_FchPrc then
            lc_var := 'N';
          
          else
            if ld_FchPrc > ld_FchCalnda then
            
              begin
                select max(f.ppfpag)
                  into ld_FchCalnda
                  from fsd601 f
                 where f.pgcod = i.ln_pgcod
                   and f.ppmod = i.ln_modulo
                   and f.ppsuc = i.ln_sucursal
                   and f.ppmda = i.ln_moneda
                   and f.pppap = i.ln_papel
                   and f.ppcta = i.ln_cuenta
                   and f.ppoper = i.ln_operacion
                   and f.ppsbop = i.ln_sbopera
                   and f.pptope = i.ln_tipopera
                   and f.ppfpag <= ld_FchPrc;
              exception
                when others then
                  null;
              end;
            
              begin
                select 'S'
                  into lc_Flag
                  from fsd602 f
                 where f.pgcod = i.ln_pgcod
                   and f.ppmod = i.ln_modulo
                   and f.ppsuc = i.ln_sucursal
                   and f.ppmda = i.ln_moneda
                   and f.pppap = i.ln_papel
                   and f.ppcta = i.ln_cuenta
                   and f.ppoper = i.ln_operacion
                   and f.ppsbop = i.ln_sbopera
                   and f.pptope = i.ln_tipopera
                   and f.ppfpag = ld_FchCalnda
                   and f.pp1stat = 'T'
                   and f.d602co = 'S'
                   and rownum = 1;
              exception
                when no_data_found then
                  lc_Flag := 'N';
              end;
            
              if lc_Flag = 'S' then
                lc_var := 'N'; -- No Deudor
              else
                if lc_Flag = 'N' then
                  lc_var := 'S'; -- Si Deudor
                  exit;
                end if;
              end if;
            
            end if;
          end if;
        
        end if;
      end if;
    
    end loop;
  end sp_cr_resolutorA;
end PQ_CR_RN_REPROGRAMADOS;
/

