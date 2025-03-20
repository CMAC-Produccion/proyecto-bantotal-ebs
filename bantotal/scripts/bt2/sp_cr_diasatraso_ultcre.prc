CREATE OR REPLACE Procedure SP_CR_DIASATRASO_ULTCRE(lc_prgm      in varchar2,
                                                    lc_nmbvar    in varchar2,
                                                    lc_user      in varchar2,
                                                    ln_Instancia in number,
                                                    pn_pai       in number,
                                                    pn_tdo       in number,
                                                    pc_ndo       in char,
                                                    pd_fecpro    in date,
                                                    ln_promedio  out number,
                                                    pn_moramax   out number) is

  cursor clicre is
    select a.*,
           (case
             when aostat <> 99 then
              aofvto
             else
              pq_cr_relcrediticia.Fn_DiaPago(PGCOD,
                                             AOMOD,
                                             AOSUC,
                                             AOMDA,
                                             AOPAP,
                                             AOCTA,
                                             AOOPER,
                                             AOSBOP,
                                             AOTOPE,
                                             aostat,
                                             aofe99)
           end) FEUSO,
           
           pq_cr_relcrediticia.Fn_DiaPago(PGCOD,
                                          AOMOD,
                                          AOSUC,
                                          AOMDA,
                                          AOPAP,
                                          AOCTA,
                                          AOOPER,
                                          AOSBOP,
                                          AOTOPE,
                                          aostat,
                                          aofe99) fecpago
      from (
            
            select *
              from fsd010 d
             where pgcod = 1
               and aocta in (select distinct A.CTNRO --a.pepais, a.petdoc, a.pendoc  mod@abr 20170821
                               from fsr008 a
                              where a.pepais = pn_pai
                                and a.petdoc = pn_tdo
                                and a.pendoc = pc_ndo
                                and a.cttfir = 'T')
               and d.aostat = 99
               and aomod in (select modulo
                               from fst111
                              where dscod = 50
                                and modulo not in (200, 33, 108))
                  
               and aotope <> 550
             order by aofe99 desc
            
            ) a
     where rownum = 1;

  ln_contCuotas number(18);
  ln_dia        number(18);

  ln_contCuoTot number(18);
  ln_diaTot     number(18);

  ld_fecorte date;

  ln_moramax    number(10);
  ln_sw         number(1) := 0; --mod@abr 20170822
  lc_VerifExcp  varchar2(2); -- mpostigoc 20171102
  ln_periodoaux number; -- mpostigoc 20171106
  ln_periodo    number; -- mpostigoc 20171106
begin

  begin
    ln_contCuoTot := 0;
    ln_diaTot     := 0;
    ln_moramax    := 0;
    pn_moramax    := 0;
    for i in clicre loop
      ld_fecorte := i.aofval;
      if (i.fecpago is null or
         i.fecpago = to_date('0001.01.01', 'yyyy.mm.dd')) and i.aostat = 99 then
        ln_sw := 1;
      end if;
    
      pq_cr_ampliaciones.sp_cr_VerificaExcepciones(ln_pgcod     => I.PGCOD,
                                                   ln_modulo    => I.AOMOD,
                                                   ln_sucursal  => I.AOSUC,
                                                   ln_moneda    => I.AOMDA,
                                                   ln_papel     => I.AOPAP,
                                                   ln_cuenta    => I.AOCTA,
                                                   ln_operac    => I.AOOPER,
                                                   ln_suboper   => I.AOSBOP,
                                                   ln_tipoper   => I.AOTOPE,
                                                   lc_VerifExcp => lc_VerifExcp);
    
      if lc_VerifExcp <> 'N' then
        if ln_sw = 0 then
        
          begin
          
            begin
              -- MPOSTIGOC 20171106
              -- Periodo
              select a.aoperiod
                into ln_periodoaux
                from fsd010 a
               where a.pgcod = i.pgcod
                 and a.aomod = i.aomod
                 and a.aosuc = i.aosuc
                 and a.aomda = i.aomda
                 and a.aopap = i.aopap
                 and a.aocta = i.aocta
                 and a.aooper = i.aooper
                 and a.aosbop = i.aosbop
                 and a.aotope = i.aotope;
            exception
              when others then
                ln_periodoaux := 0;
            end;
          
            --Mensualizamos el periodo
            ln_periodo := ln_periodoaux / 30;
          
          end;
        
          pq_cr_ampliaciones.sp_calculaCuotas_new(i.pgcod,
                                                  i.aomod,
                                                  i.aosuc,
                                                  i.aomda,
                                                  i.aopap,
                                                  i.aocta,
                                                  i.aooper,
                                                  i.aosbop,
                                                  i.aotope,
                                                  pd_fecpro,
                                                  ld_fecorte,
                                                  i.aostat,
                                                  ln_periodo, -- mpostigoc 2017/11/06
                                                  ln_contCuotas,
                                                  ln_dia,
                                                  ln_moramax);
          ln_diaTot     := ln_diaTot + ln_dia;
          ln_contCuoTot := ln_contCuoTot + ln_contCuotas;
          --mora maxima
          if ln_moramax > pn_moramax then
            pn_moramax := ln_moramax;
          end if;
          --mora maxima
        end if;
      
      end if;
    end loop;
  
  end;

  if ln_contCuoTot = 0 then
    --dbms_output.put_line (i.pepais||'-'||i.petdoc||'-'||i.pendoc);
    ln_promedio := 0;
  else
    ln_promedio := round((ln_diaTot / ln_contCuoTot), 2);
  end if;

  pq_cr_ampliaciones.sp_cr_InsertLogJAQZ840(lc_prgm,
                                            lc_nmbvar,
                                            lc_user,
                                            ln_Instancia,
                                            pn_pai,
                                            pn_tdo,
                                            pc_ndo,
                                            pd_fecpro,
                                            ln_diaTot,
                                            ln_contCuoTot,
                                            ln_promedio,
                                            pn_moramax);

end SP_CR_DIASATRASO_ULTCRE;
/

