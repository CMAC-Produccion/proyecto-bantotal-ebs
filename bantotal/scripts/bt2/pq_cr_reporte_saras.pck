create or replace package pq_cr_reporte_saras is

  -- Author  : GCARRANZAS
  -- Created : 29/10/2020 12:27:03
  -- Purpose : Listas SARAS

  procedure sp_reporte_saras(pd_fechasis in date,
                             pd_fechaini in date,
                             pd_fechafin in date,
                             pn_region   in number,
                             pn_zona     in number,
                             pn_usuario  in char);

  procedure sp_obtener_suc(pn_suc  in number,
                           pn_regi out number,
                           pn_zona out number,
                           pn_nsuc out aqpb065.aqpb065nsuc%type,
                           pn_nzon out aqpb065.aqpb065nzon%type,
                           pn_nreg out aqpb065.aqpb065nreg%type);

  function fn_obtener_nomb_cli(p_pais in number,
                               p_tdoc in number,
                               p_ndoc in char) return char;

  function fn_obtener_saldocap(pn_cod in number,
                               pn_mod in number,
                               pn_suc in number,
                               pn_mda in number,
                               pn_pap in number,
                               pn_cta in number,
                               pn_ope in number,
                               pn_sbo in number,
                               pn_top in number) return number;

  function fn_obtener_cuo_tot(pn_cod in number,
                              pn_mod in number,
                              pn_suc in number,
                              pn_mda in number,
                              pn_pap in number,
                              pn_cta in number,
                              pn_ope in number,
                              pn_sbo in number,
                              pn_top in number) return number;

  function fn_obtener_ultfechpag(pn_cod   in number,
                                 pn_mod   in number,
                                 pn_suc   in number,
                                 pn_mda   in number,
                                 pn_pap   in number,
                                 pn_cta   in number,
                                 pn_ope   in number,
                                 pn_sbo   in number,
                                 pn_top   in number,
                                 pn_fecha in date) return date;
  function fn_obtener_cuo_pag(pn_cod in number,
                              pn_mod in number,
                              pn_suc in number,
                              pn_mda in number,
                              pn_pap in number,
                              pn_cta in number,
                              pn_ope in number,
                              pn_sbo in number,
                              pn_top in number,
                              pn_fec in date) return number;

end pq_cr_reporte_saras;
/

create or replace package body pq_cr_reporte_saras is

  procedure sp_reporte_saras(pd_fechasis in date,
                             pd_fechaini in date,
                             pd_fechafin in date,
                             pn_region   in number,
                             pn_zona     in number,
                             pn_usuario  in char) IS
  
    cursor reporte_saras is
      select f.pgcod,
             f.aomod,
             f.aosuc,
             f.aomda,
             f.aopap,
             f.aocta,
             f.aooper,
             f.aosbop,
             f.aotope,
             f.aofval,
             f.aostat,
             f.aofvto,
             a.aqpb302pais   pepais,
             a.aqpb302tdoc   petdoc,
             a.aqpb302ndoc   pendoc,
             f.aoimp,
             t.cenom,
             a.aqpb302fecha,
             a.aqpb302hora,
             a.aqpb302estado,
             a.aqpb302respta,
             a.aqpb302modo,
             a.aqpb302observ
        from aqpb302 a,
             xwf700  x,
             fsd010  f,
             fst026  t,
             fst811  fs,
             fst810  zo,
             fst198  re
       where x.xwfprcins = a.aqpb302instancia
         and x.xwfcuenta = a.aqpb302cuenta
         and x.xwfcar3 = '1'
         and f.pgcod = x.xwfempresa
         and f.aomod = x.xwfmodulo
         and f.aosuc = x.xwfsucursal
         and f.aomda = x.xwfmoneda
         and f.aopap = x.xwfpapel
         and f.aocta = x.xwfcuenta
         and f.aooper = x.xwfoperacion
         and f.aosbop = x.xwfsubope
         and f.aotope = x.xwftipope
         and f.aostat = t.cecod
            --////region zona sucursal
         and fs.pgcod = f.pgcod
         and fs.regcod < 100
         and fs.regcod <> 0
         and fs.oficod = f.aosuc
         and zo.pgcod = fs.pgcod
         and zo.regcod = fs.regcod
         and re.tp1cod = fs.pgcod
         and re.tp1cod1 = 10872
         and re.tp1corr1 = 11
         and re.tp1nro2 = fs.regcod
         and re.tp1nro2 = NVL(case
                                when pn_region = 0 then
                                 null
                                else
                                 pn_region
                              end,
                              re.tp1nro2)
         and zo.regcod = NVL(case
                               when pn_zona = 0 then
                                null
                               else
                                pn_zona
                             end,
                             zo.regcod)
            --//////
         and a.aqpb302estado = 'V'
         and a.aqpb302fecha <= pd_fechafin
         and a.aqpb302fecha >= pd_fechaini;
  
    lc_nomb_cli  char(70);
    ln_saldocap  number(17, 2);
    ln_cuo_total number;
    ln_cuo_pag   number;
    ln_dias_atr  number;
  
    lc_analista fst046.ubuser%type;
  
    lc_regi number(9);
    lc_zona number(9);
    lc_nsuc char(30);
    lc_nzon char(40);
    lc_nreg char(30);
  
    ld_ultfechpag date;
  
  BEGIN
  
    DELETE FROM AQPA992 A WHERE A.AQPA992USU = pn_usuario;
    COMMIT;
  
    for r in reporte_saras() loop
    
      lc_nomb_cli := fn_obtener_nomb_cli(r.pepais, r.petdoc, r.pendoc);
    
      ln_saldocap := fn_obtener_saldocap(r.pgcod,
                                         r.aomod,
                                         r.aosuc,
                                         r.aomda,
                                         r.aopap,
                                         r.aocta,
                                         r.aooper,
                                         r.aosbop,
                                         r.aotope);
    
      ln_cuo_total := fn_obtener_cuo_tot(r.pgcod,
                                         r.aomod,
                                         r.aosuc,
                                         r.aomda,
                                         r.aopap,
                                         r.aocta,
                                         r.aooper,
                                         r.aosbop,
                                         r.aotope);
    
      ld_ultfechpag := fn_obtener_ultfechpag(r.pgcod,
                                             r.aomod,
                                             r.aosuc,
                                             r.aomda,
                                             r.aopap,
                                             r.aocta,
                                             r.aooper,
                                             r.aosbop,
                                             r.aotope,
                                             pd_fechasis);
    
      ln_cuo_pag := fn_obtener_cuo_pag(r.pgcod,
                                       r.aomod,
                                       r.aosuc,
                                       r.aomda,
                                       r.aopap,
                                       r.aocta,
                                       r.aooper,
                                       r.aosbop,
                                       r.aotope,
                                       ld_ultfechpag);
    
      ln_dias_atr := fn_dias_atraso(pd_fechasis, --fecha de sistema
                                    r.pgcod,
                                    r.aomod,
                                    r.aosuc,
                                    r.aomda,
                                    r.aopap,
                                    r.aocta,
                                    r.aooper,
                                    r.aosbop,
                                    r.aotope,
                                    r.aostat,
                                    r.aofvto);
    
      lc_analista := fn_analista_credito(r.aomod,
                                         r.aosuc,
                                         r.aomda,
                                         r.aopap,
                                         r.aocta,
                                         r.aooper,
                                         r.aosbop,
                                         r.aotope);
    
      begin
      
        pq_cr_reporte_saras.sp_obtener_suc(pn_suc  => r.aosuc,
                                           pn_regi => lc_regi,
                                           pn_zona => lc_zona,
                                           pn_nsuc => lc_nsuc,
                                           pn_nzon => lc_nzon,
                                           pn_nreg => lc_nreg);
      end;
    
      insert into AQPA992
        (AQPA992USU,
         AQPA992EMP,
         AQPA992MOD,
         AQPA992SUC,
         AQPA992MDA,
         AQPA992PAP,
         AQPA992CTA,
         AQPA992OPE,
         AQPA992SBOP,
         AQPA992TOPE,
         AQPA992FDESE,
         AQPA992MNTOD,
         AQPA992SLDOC,
         AQPA992CUOT,
         AQPA992CUOP,
         AQPA992DIASA,
         AQPA992ANLST,
         AQPA992AGE,
         AQPA992REG,
         AQPA992ZON,
         AQPA992FIRM,
         AQPA992FEFIRM,
         AQPA992ESTN,
         AQPA992PAIS,
         AQPA992TDOC,
         AQPA992NDOC,
         AQPA992NOMC)
      VALUES
        (pn_usuario,
         r.pgcod,
         r.aomod,
         r.aosuc,
         r.aomda,
         r.aopap,
         r.aocta,
         r.aooper,
         r.aosbop,
         r.aotope,
         r.aofval,
         r.aoimp,
         ln_saldocap,
         ln_cuo_total,
         ln_cuo_pag,
         ln_dias_atr,
         lc_analista,
         lc_nsuc,
         lc_nreg,
         lc_nzon,
         r.aqpb302respta,
         r.aqpb302fecha,
         r.aqpb302estado,
         r.pepais,
         r.petdoc,
         r.pendoc,
         lc_nomb_cli);
      COMMIT;
    
    end loop;
  
  END sp_reporte_saras;

  procedure sp_obtener_suc(pn_suc  in number,
                           pn_regi out number,
                           pn_zona out number,
                           pn_nsuc out aqpb065.aqpb065nsuc%type,
                           pn_nzon out aqpb065.aqpb065nzon%type,
                           pn_nreg out aqpb065.aqpb065nreg%type) is
  
  begin
  
    -- Nombre de la sucursal
    select t.scnom into pn_nsuc from fst001 t where t.sucurs = pn_suc;
  
    -- zona
    select t.regcod
      into pn_zona
      from fst811 t
     where t.pgcod = 1
       and t.oficod = pn_suc
       and t.regcod < 100
       and t.regcod <> 0;
  
    select t.regnom
      into pn_nzon
      from fst810 t
     where t.pgcod = 1
       and t.regcod = pn_zona;
  
    -- Región
    select t.tp1nro1, t.tp1desc ---tp1desc(zona) char(30)
      into pn_regi, pn_nreg
      from fst198 t
     where t.tp1cod = 1
       and t.tp1cod1 = 10872
       and t.tp1corr1 = 11
       and t.tp1nro2 = pn_zona;
  
  end sp_obtener_suc;

  function fn_obtener_nomb_cli(p_pais in number,
                               p_tdoc in number,
                               p_ndoc in char) return char is
  
    lc_razon char(70);
    respc    char(70);
  
  begin
  
    if p_tdoc = 21 then
      -- -- -- -- -- -- -- -- -- --
      select concat(trim(s.pfape1),
                    concat(' ',
                           concat(trim(s.pfape2),
                                  concat(' ',
                                         concat(trim(s.pfnom1),
                                                concat(' ', s.pfnom2))))))
        into lc_razon
        from fsd002 s
       where s.pfpais = p_pais
         and s.pftdoc = p_tdoc
         and s.pfndoc = p_ndoc;
      -- -- -- -- -- -- -- -- -- --
    else
      -- -- -- -- -- -- -- -- -- --
      lc_razon := '';
      -- -- -- -- -- -- -- -- -- --
    end if;
  
    respc := lc_razon;
    return respc;
  
  end fn_obtener_nomb_cli;

  function fn_obtener_saldocap(pn_cod in number,
                               pn_mod in number,
                               pn_suc in number,
                               pn_mda in number,
                               pn_pap in number,
                               pn_cta in number,
                               pn_ope in number,
                               pn_sbo in number,
                               pn_top in number) return number is
    ln_saldocap number(17, 2);
  begin
    begin
      select SUM(f.scsdo)
        into ln_saldocap
        from fsd011 f
       where f.pgcod = pn_cod
         and f.scmod = pn_mod
         and f.scsuc = pn_suc
         and f.scmda = pn_mda
         and f.scpap = pn_pap
         and f.sccta = pn_cta
         and f.scoper = pn_ope
         and f.scsbop = pn_sbo
         and f.sctope = pn_top;
    exception
      when others then
        ln_saldocap := 0;
    end;
  
    return ln_saldocap;
  
  end fn_obtener_saldocap;

  function fn_obtener_cuo_tot(pn_cod in number,
                              pn_mod in number,
                              pn_suc in number,
                              pn_mda in number,
                              pn_pap in number,
                              pn_cta in number,
                              pn_ope in number,
                              pn_sbo in number,
                              pn_top in number) return number is
    lx_cuo_n number;
  begin
  
    begin
    
      select count(*)
        into lx_cuo_n
        from FSD601 t
       where t.pgcod = pn_cod
         and t.ppmod = pn_mod
         and t.ppsuc = pn_suc
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
         and t.ppsbop = pn_sbo
         and t.pptope = pn_top
         and t.d601Co = 'S';
    
    exception
      when others then
        lx_cuo_n := null;
    end;
  
    return lx_cuo_n;
  
  end fn_obtener_cuo_tot;

  function fn_obtener_ultfechpag(pn_cod   in number,
                                 pn_mod   in number,
                                 pn_suc   in number,
                                 pn_mda   in number,
                                 pn_pap   in number,
                                 pn_cta   in number,
                                 pn_ope   in number,
                                 pn_sbo   in number,
                                 pn_top   in number,
                                 pn_fecha in date) return date is
    ld_fpagu date;
  begin
  
    begin
    
      -- Obtener última fecha de pago
      SELECT
      --max(t.d602fc)
       max(t.ppfpag)
        into ld_fpagu
        FROM FSD602 t
       where t.pgcod = pn_cod
         and t.ppmod = pn_mod
         and t.ppsuc = pn_suc
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
         and t.ppsbop = pn_sbo
         and t.pptope = pn_top
         and t.pp1stat = 'T'
         and t.d602co = 'S'
      --and t.d602fc <= pn_fecha
      ;
    exception
      when others then
        ld_fpagu := null;
    end;
  
    return ld_fpagu;
  
  end fn_obtener_ultfechpag;

  function fn_obtener_cuo_pag(pn_cod in number,
                              pn_mod in number,
                              pn_suc in number,
                              pn_mda in number,
                              pn_pap in number,
                              pn_cta in number,
                              pn_ope in number,
                              pn_sbo in number,
                              pn_top in number,
                              pn_fec in date) return number is
    ln_cuo_pag number;
  begin
  
    begin
    
      SELECT NVL(count(*), 0)
        into ln_cuo_pag
        FROM FSD601 t
       where t.pgcod = pn_cod
         and t.ppmod = pn_mod
         and t.ppsuc = pn_suc
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
         and t.ppsbop = pn_sbo
         and t.pptope = pn_top
         and t.ppfpag <= pn_fec
         and t.d601co = 'S';
    exception
      when others then
        ln_cuo_pag := 0;
    end;
    return ln_cuo_pag;
  end fn_obtener_cuo_pag;

end pq_cr_reporte_saras;
/

