create or replace package PQ_CR_CAPANA is

  -- Author  : IGS_MCORDOVA
  -- Created : 18/07/2022 08:18:48
  -- Purpose : 
  PROCEDURE SP_CR_VALIDAR_RENOVACION_EXPRESS(USUARIO IN VARCHAR2,
                                             FLAG    OUT VARCHAR2);
  PROCEDURE SP_CR_OBTIENE_FECHA_MAXIMA(FECHA OUT DATE);
end PQ_CR_CAPANA;
/

create or replace package body PQ_CR_CAPANA is

  PROCEDURE SP_CR_VALIDAR_RENOVACION_EXPRESS(USUARIO IN VARCHAR2,
                                             FLAG    OUT VARCHAR2) IS
  BEGIN
    SELECT 'S'
      INTO FLAG
      FROM JAQZ697
     WHERE JAQZ697FEP = (SELECT MAX(JAQZ697FEP) FROM JAQZ697)
       AND JAQZ697AU5 = 'A'
       AND TRIM(JAQZ697ASE) = USUARIO
       AND ROWNUM = 1;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      FLAG := 'N';
  END SP_CR_VALIDAR_RENOVACION_EXPRESS;

  PROCEDURE SP_CR_OBTIENE_FECHA_MAXIMA(FECHA OUT DATE) IS
  BEGIN
  
    begin
      SELECT MAX(JAQZ697FEP) INTO FECHA FROM JAQZ697;
    exception
      when others then
        null;
    end;
  END SP_CR_OBTIENE_FECHA_MAXIMA;

  Procedure Sp_cr_mtoCuota(pn_mod     in number,
                           pn_mda     in number,
                           pn_pap     in number,
                           pn_top     in number,
                           pn_suc     in number,
                           pn_mto     in number,
                           pn_cuo     in number,
                           pn_fre     in number,
                           pd_fecpro  in date,
                           pd_Fec     in date,
                           pc_cor     in number,
                           pc_flg     in char,
                           pd_Fecprim in date,
                           pn_cta     in number, --mod@abr 20201115
                           pn_mtoCuo  out number) is
  
    ln_mod      number(3);
    ln_suc      number(3);
    ln_mda      number(4);
    ln_pap      number(4);
    ln_top      number(3);
    ln_mto      number(17, 2);
    ln_pzo      number(5);
    ln_defn     number(17, 2);
    ln_cont     number(5) := 0;
    ln_tas      number(10, 6);
    ln_mtt      number(17, 2);
    ln_fde      date;
    ln_tat      number(7, 4);
    ln_cont2    number(5) := 0;
    ln_tvmpo    number(7, 4);
    ln_porc     number(4) := 100;
    ln_aux      number(9);
    pn_tasa     number(10, 6);
    ln_div      number(10, 6);
    ld_fecSis   date;
    ln_dife     number(10);
    ln_int      number(17, 2);
    ln_mtoFinal number(17, 2);
    ld_fecAux   date;
    ln_cuo      number;
  
    cursor tasa(cn_defn in number,
                cn_mod  in number,
                cn_mda  in number,
                cn_pap  in number,
                cn_mto  in number,
                cn_pzo  in number,
                cf_fec  in date) is
      select *
        from fsr025 a
       where a.pgcod = 1
         and a.tpizar = cn_defn
         and a.tamod = cn_mod
         and a.tamda = cn_mda
         and a.tapap = cn_pap
         and a.tamto >= cn_mto
         and a.tapzo >= cn_pzo
         and a.tafdes <= cf_fec
         and a.tafdes = (select max(aa.tafdes)
                           from fsr025 aa
                          where aa.pgcod = 1
                            and aa.tpizar = cn_defn
                            and aa.tamod = cn_mod
                            and aa.tamda = cn_mda
                            and aa.tapap = cn_pap
                               --and aa.tamto  >= cn_mto
                               --and aa.tapzo  >= cn_pzo 
                            and aa.tafdes <= cf_fec);
    cursor region(cn_sucR in number) is
      select *
        from fst811 a
       where a.pgcod = 1
         and a.regcod >= 100
         and a.oficod = cn_sucR;
  
    cursor tasa_esp(cn_modE in number,
                    cn_defE in number,
                    cn_papE in number,
                    cn_mdaE in number,
                    cn_mtoE in number,
                    cn_regE in number,
                    cd_fecE in date) is
    
      select *
        from fsd527 a
       where a.pgcod = 1
         and a.tamod = cn_modE
         and a.tpizar = cn_defE
         and a.tapap = cn_papE
         and a.tamda = cn_mdaE
         and a.tvfmon = cn_mtoE
         and a.tvsuc = cn_regE
         and a.tvfdes <= cd_fecE;
  
    ln_Pp028DefN number(17, 2);
    ln_cta       number(9);
    -- ln_mtoAUX    NUMBER(17, 2);
  begin
  
    ln_mod := pn_mod;
    ln_suc := pn_suc;
    ln_mda := pn_mda;
    ln_pap := pn_pap;
    ln_top := pn_top;
    ln_mto := pn_mto;
    ln_cuo := pn_cuo;
  
    if ln_mod = 117 then
    
      ln_cuo := 24; -- mpostigoc 18.02.2022
    
    end if;
  
    --tasa por cuenta
  
    begin
      select a.jaqz697cta
        into ln_cta
        from jaqz697 a
       where a.jaqz697fep = pd_Fec
         and a.jaqz697cor = pc_cor;
    exception
      when others then
        null;
    end;
  
    ln_cta := pn_cta;
  
    begin
      select Pp028DefN
        into ln_Pp028DefN
        from FPP028
       Where Pp028Emp = 1
         and Pp028Mod = ln_mod
         and Pp028Top = ln_top
         and Pp028Mda = ln_mda
         and Pp028Pap = ln_pap
         and Pp017Par = 17;
    exception
      when others then
        null;
    end;
    /*
    begin
      select MIN(f.tpmto)
        into ln_mtoAUX
        from fsr027 f
       where f.pgcod = 1
         and f.modulo = ln_mod
         and f.tpizar = ln_Pp028DefN
         and f.ctnro = ln_cta
         and f.moneda = ln_mda
         and f.papel = ln_pap
         and f.tpfdes = pd_Fec
         and f.tpmto >= pn_mto
         and f.tppzo = 99999;
    exception
      when others then
        null;
    end;
    
    begin
      select f.tptasa
        into pn_tasa
        from fsr027 f
       where f.pgcod = 1
         and f.modulo = ln_mod
         and f.tpizar = ln_Pp028DefN
         and f.ctnro = ln_cta
         and f.moneda = ln_mda
         and f.papel = ln_pap
         and f.tpfdes = pd_Fec
         and f.tpmto = ln_mtoAUX
         and f.tppzo = 99999;
    exception
      when others then
        null;
    end;*/
    --calculo de plazo
    begin
      select tp1nro1
        into ln_aux
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10899
         and tp1corr1 = 88888
         and tp1corr2 = 4
         and tp1corr3 = 1;
    exception
      when others then
        null;
    end;
  
    ln_pzo := (ln_cuo * pn_fre) + nvl(ln_aux, 0);
  
    -- mpostigoc 25.07.2022  
    Pq_Cr_Modulo_Campanias.sp_cr_TasaPorPlazo(ln_cuenta => ln_cta,
                                              ln_mod    => ln_mod,
                                              ln_piza   => ln_Pp028DefN,
                                              ld_fcha   => pd_Fec,
                                              ln_monto  => pn_mto,
                                              ln_Plazo  => ln_pzo,
                                              pn_tasa   => pn_tasa);
  
    if nvl(pn_tasa, 0) = 0 then
      --obtiene pizarra
      begin
        select Pp028DefN
          into ln_defn
          from fpp028
         where Pp010Prd = 1
           and Pp017Par = 17
           and Pp028Mod = ln_mod
           and Pp028Mda = ln_mda
           and Pp028Pap = ln_pap
           and Pp028Top = ln_top;
      exception
        when others then
          null;
      end;
    
      for i in tasa(ln_defn,
                    ln_mod,
                    ln_mda,
                    ln_pap,
                    ln_mto,
                    ln_pzo,
                    pd_fecpro) loop
      
        ln_tas  := i.Tatasa;
        ln_mtt  := i.Tamto;
        ln_fde  := i.Tafdes;
        ln_tat  := i.Tatol;
        ln_cont := ln_cont + 1;
      
        if ln_cont > 0 then
          exit;
        end if;
      
      end loop;
    
      for j in region(ln_suc) loop
        for k in tasa_esp(ln_mod,
                          ln_defn,
                          ln_pap,
                          ln_mda,
                          ln_mtt, --MOD@ABR 20171018
                          j.regcod,
                          pd_fecpro) loop
        
          ln_tvmpo := k.TvMPorc - ln_porc;
          ln_cont2 := ln_cont2 + 1;
        
          if ln_cont2 > 0 then
            exit;
          end if;
        
        end loop;
      end loop;
    
      pn_tasa := nvl(ln_tas, 0) + nvl(ln_tvmpo, 0);
    end if;
  
    if nvl(pc_flg, 'N') = 'S' then
      begin
        select a.pgfape into ld_fecSis from fst017 a where a.pgcod = 1;
      exception
        when others then
          null;
      end;
      ld_fecAux := ld_fecSis + pn_fre;
    
      if ld_fecAux <> pd_Fecprim then
        ln_dife := (pd_Fecprim - ld_fecSis) - pn_fre;
      
        if ln_dife < 0 then
          ln_int := 0;
        else
          ln_int := pn_mto *
                    ((power((1 + (pn_tasa / 100)), (ln_dife / 360))) - 1);
        end if;
      
      end if;
    
    end if;
  
    ln_mtoFinal := pn_mto + nvl(ln_int, 0);
  
    ln_div := (1 - power((1 +
                         ((power((1 + (pn_tasa / 100)), (pn_fre / 360))) - 1)),
                         -ln_cuo));
    if ln_div > 0 then
      pn_mtoCuo := (ln_mtoFinal *
                   ((power((1 + (pn_tasa / 100)), (pn_fre / 360))) - 1)) /
                   ln_div;
    else
      pn_mtoCuo := 0;
    end if;
  
  end Sp_cr_mtoCuota;
end PQ_CR_CAPANA;
/

