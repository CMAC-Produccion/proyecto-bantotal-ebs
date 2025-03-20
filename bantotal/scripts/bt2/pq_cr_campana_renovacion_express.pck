create or replace package PQ_CR_CAMPANA_RENOVACION_EXPRESS is

  -- Author  : APACHECOH
  -- Created : 19/07/2022 15:52:27
  -- Purpose : 

  procedure sp_cr_cliente_renovacion_express(vi_pgcod  in number,
                                             vi_hcsuc  in number,
                                             vi_hcmod  in number,
                                             vi_htran  in number,
                                             vi_hnrel  in number,
                                             vo_cancel out varchar2,
                                             vo_messa  out varchar2);

end PQ_CR_CAMPANA_RENOVACION_EXPRESS;
/

create or replace package body PQ_CR_CAMPANA_RENOVACION_EXPRESS is

  procedure sp_cr_cliente_renovacion_express(vi_pgcod  in number,
                                             vi_hcsuc  in number,
                                             vi_hcmod  in number,
                                             vi_htran  in number,
                                             vi_hnrel  in number,
                                             vo_cancel out varchar2,
                                             vo_messa  out varchar2) is
    -- *****************************************************************
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.07.14
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Valida si el cliente tiene campaña de renovacion express
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : vi_pgcod ( Empresa )
    --                              vi_hcmod ( Modulo )
    --                              vi_hcsuc ( Sucursal )
    --                              vi_htran ( Transaccion )
    --                              vi_hnrel ( Relacion )
    -- Parámetros de Salida       : vo_cancel ( Cancelado )
    --                              vo_messa ( Mensaje )
    -- Fecha de Modificación      : --
    -- Autor de la Modificación   : --
    -- Descripción de Modificación: --
    -- *****************************************************************
    ln_flag   number := 0;
    ln_petdoc number := 0;
    lv_pendoc varchar2(12);
    ln_pais   number := 0;
    ln_cuenta number := 0;
    --      
    ln_pgcod  number := 0;
    ln_scmod  number := 0;
    ln_scsuc  number := 0;
    ln_scmda  number := 0;
    ln_scpap  number := 0;
    ln_sccta  number := 0;
    ln_scoper number := 0;
    ln_scsbop number := 0;
    ln_sctope number := 0;
    ln_cuopag number := 0;
    ln_cuotot number := 0;
  begin
    vo_cancel := 'N';
    vo_messa  := '';
  
    --buscar cliente a partir de la trasaccion
    begin
      select modulo, itsucd, moneda, papel, ctnro, itoper, itsubo, ittope
        into ln_scmod,
             ln_scsuc,
             ln_scmda,
             ln_scpap,
             ln_sccta,
             ln_scoper,
             ln_scsbop,
             ln_sctope
        from fsd016 f
       where f.pgcod = vi_pgcod
         and f.itsuc = vi_hcsuc
         and f.itmod = vi_hcmod
         and f.ittran = vi_htran
         and f.itnrel = vi_hnrel
         and f.itord = 10
         and f.ctnro > 0
         and rownum = 1;
      /*select distinct (f.ctnro)
       into ln_cuenta
       from fsd016 f
      where f.pgcod = vi_pgcod
        and f.itsuc = vi_hcsuc
        and f.itmod = vi_hcmod
        and f.ittran = vi_htran
        and f.itnrel = vi_hnrel
        and f.ctnro > 0
        and rownum = 1;*/
    
      select f.pepais, f.petdoc, f.pendoc
        into ln_pais, ln_petdoc, lv_pendoc
        from fsr008 f
       where f.CTNRO = ln_sccta
         and f.cttfir = 'T';
    exception
      when others then
        return;
    end;
    --validar ultimo pago
    if vi_hcmod = 30 and vi_htran = 100 then
      begin
        select count(*)
          into ln_cuotot
          from fsd601
         where pgcod = vi_pgcod
           and ppmod = ln_scmod
           and ppsuc = ln_scsuc
           and ppmda = ln_scmda
           and pppap = ln_scpap
           and ppcta = ln_sccta
           and ppoper = ln_scoper
           and ppsbop = ln_scsbop
           and pptope = ln_sctope
           and d601co = 'S';
      
        select count(*)
          into ln_cuopag
          from fsd602
         where pgcod = vi_pgcod
           and ppmod = ln_scmod
           and ppsuc = ln_scsuc
           and ppmda = ln_scmda
           and pppap = ln_scpap
           and ppcta = ln_sccta
           and ppoper = ln_scoper
           and ppsbop = ln_scsbop
           and pptope = ln_sctope
           and pp1stat = 'T'
           and d602co = 'S';
      exception
        when others then
          return;
      end;
      if (ln_cuotot - ln_cuopag) > 1 then
        return;
      end if;
    end if;
    --buscar cliente en la tabla campaña
    begin
      select count(*)
        into ln_flag
        from jaqz697 j
       where j.jaqz697fep = (select max(a.jaqz697fep) from jaqz697 a)
         and j.jaqz697pai = ln_pais
         and j.jaqz697tdo = ln_petdoc
         and j.jaqz697ndo = lv_pendoc
         and j.jaqz697moa = ln_scmod
         and j.jaqz697sua = ln_scsuc
         and j.jaqz697maa = ln_scmda
         and j.jaqz697paa = ln_scpap
         and j.jaqz697caa = ln_sccta
         and j.jaqz697opa = ln_scoper
         and j.jaqz697sba = ln_scsbop
         and j.jaqz697toa = ln_sctope
         and j.jaqz697au5 = 'B'
         and j.jaqz697apr = 'A';
    exception
      when others then
        return;
    end;
    --Se valida si encuentra
    if ln_flag > 0 then
      vo_cancel := 'S';
      vo_messa  := 'Cliente con campaña de Renovación Express, imprimir cupón';
    end if;
  
  end sp_cr_cliente_renovacion_express;

end PQ_CR_CAMPANA_RENOVACION_EXPRESS;
/

