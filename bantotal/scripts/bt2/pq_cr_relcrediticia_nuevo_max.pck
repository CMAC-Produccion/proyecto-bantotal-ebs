create or replace package PQ_CR_RELCREDITICIA_NUEVO_MAX is
  -- Author : MHUAMANIA
  -- Created : 21/01/2025
  -- Proyecto : DEVUELVE LOS DÍAS ATRASO MAXIMO

   Function Fn_CuotasPag(pn_emp    in number,
                        pn_mod    in number,
                        pn_suc    in number,
                        pn_mda    in number,
                        pn_pap    in number,
                        pn_cta    in number,
                        pn_ope    in number,
                        pn_sbo    in number,
                        pn_top    in number,
                        pd_fec    in date,
                        pd_fecpro in date) return number;
  
  Procedure Sp_CalculaCuotas(pn_emp      in number,
                           pn_mod      in number,
                           pn_suc      in number,
                           pn_mda      in number,
                           pn_pap      in number,
                           pn_cta      in number,
                           pn_ope      in number,
                           pn_sbo      in number,
                           pn_top      in number,
                           pd_fec      in date,
                           pd_fecor    in date,
                           pn_stat     in number,
                           ln_contador out number,
                           ln_diasTot  out number,
                           ln_diasMax  out number);
  
  Procedure Sp_DiaAtraso_linea(pn_pai      in number,
                               pn_tdo      in number,
                               pc_ndo      in char,
                               pd_fecpro   in date,
                               ln_maximo out number);
  Procedure Sp_cr_histDiaAtr_linea(pn_pai        in number,
                                   pn_tdo        in number,
                                   pc_ndo        in char,
                                   pd_fecpro     in date,
                                   pd_fecini     in date,
                                   ln_contCuoTot out number,
                                   ln_diaMax    out number);
  Procedure Sp_cr_histDiaAtr_linea_ii(pn_pai        in number,
                                      pn_tdo        in number,
                                      pc_ndo        in char,
                                      pd_fecor      in date,
                                      pd_fecpro     in date, /*pd_fecini in date,*/
                                      ln_contCuoTot out number,
                                      ln_diaMax     out number);
  Function Fn_DiaPago(pn_emp in number,
                      pn_mod in number,
                      pn_suc in number,
                      pn_mda in number,
                      pn_pap in number,
                      pn_cta in number,
                      pn_ope in number,
                      pn_sbo in number,
                      pn_top in number,
                      pn_est in number,
                      pd_fec in date) return date;

  
end PQ_CR_RELCREDITICIA_NUEVO_MAX;
/

create or replace package body PQ_CR_RELCREDITICIA_NUEVO_MAX is

  -- Author : MHUAMANIA
  -- Created : 21/01/2025
  -- Proyecto : DEVUELVE LOS DÍAS ATRASO MAXIMO

   ------------------------------------------------------------------
   
   Function Fn_CuotasPag(pn_emp    in number,
                          pn_mod    in number,
                          pn_suc    in number,
                          pn_mda    in number,
                          pn_pap    in number,
                          pn_cta    in number,
                          pn_ope    in number,
                          pn_sbo    in number,
                          pn_top    in number,
                          pd_fec    in date,
                          pd_fecpro in date) return number is
      ln_dias number(10);
    begin
    
      begin
      
        select (a.pp1fech - a.ppfpag)
          into ln_dias
          from fsd602 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top
           and a.ppfpag = pd_fec
           and a.d602co = 'S'
           and a.pp1stat = 'T'
           and (a.pp1cap + a.pp1int) <> 0
           and rownum = 1;
      
      exception
        when no_data_found then
          ln_dias := pd_fecpro - pd_fec;
        When too_many_rows then
          dbms_output.put_line(pn_cta || '-' || pn_ope || '-' || pn_sbo || '-' ||
                               pn_top || '-' || pd_fec);
        
      end;
      if ln_dias < 0 then
        ln_dias := 0;
      end if;
    
      return ln_dias;
    
    end Fn_CuotasPag;
  -----------------------------------------------------------------------------
    
    Procedure Sp_CalculaCuotas(pn_emp      in number,
                               pn_mod      in number,
                               pn_suc      in number,
                               pn_mda      in number,
                               pn_pap      in number,
                               pn_cta      in number,
                               pn_ope      in number,
                               pn_sbo      in number,
                               pn_top      in number,
                               pd_fec      in date,
                               pd_fecor    in date,
                               pn_stat     in number,
                               ln_contador out number,
                               ln_diasTot  out number,
                               ln_diasMax  out number
                               ) is
      cursor creditos is
        select a.pgcod,
               a.ppmod,
               a.ppsuc,
               a.ppmda,
               a.pppap,
               a.ppcta,
               a.ppoper,
               a.ppsbop,
               a.pptope,
               a.ppfpag --,modificado 20151022 porque no esta tomando la ultima cuota pendiente de pago
        --b.ppfpag pag602,modificado 20151022
        --b.pp1fech modificado 20151022
          from fsd601 a --,fsd602 b modificado 20151022
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top
              --and a.ppfpag between pd_fecor and pd_fec
              --and a.ppfpag >= pd_fecor
           and a.ppfpag < pd_fec
           and a.d601co = 'S'
           and (a.ppcap + a.ppint) <> 0;

      --ln_contador number(5);
      ln_dias number(10);
    
      ln_flag    number(1);
      ld_fecantC date;
    
      ld_fecpago date; --modificado 20151022
      ln_diasMaxAux number(15) := -999999;
    
    begin
      begin
        ln_diasTot  := 0;
        ln_contador := 0;
        ln_flag     := 0;
        ld_fecantC  := to_date('2000.01.01', 'yyyy.mm.dd');
        For i in creditos loop
        
          begin
          
            select b.pp1fech
              into ld_fecpago
              from fsd602 b
             where b.pgcod = i.pgcod
               and b.ppmod = i.ppmod
               and b.ppsuc = i.ppsuc
               and b.ppmda = i.ppmda
               and b.pppap = i.pppap
               and b.ppcta = i.ppcta
               and b.ppoper = i.ppoper
               and b.ppsbop = i.ppsbop
               and b.pptope = i.pptope
               and b.ppfpag = i.ppfpag
               and b.pp1stat = 'T'
               and b.d602co = 'S'
               and (b.pp1cap + b.pp1int) <> 0
               and rownum = 1;
          exception
            when no_data_found then
              ld_fecpago := null;
          end;
        
          if ld_fecpago >= pd_fecor or ld_fecpago is null then
          
            if ld_fecantC <> i.ppfpag then
              ln_contador := ln_contador + 1;
            
              ln_dias    := PQ_CR_RELCREDITICIA_NUEVO_MAX.fn_cuotasPag(i.pgcod,
                                                             i.ppmod,
                                                             i.ppsuc,
                                                             i.ppmda,
                                                             i.pppap,
                                                             i.ppcta,
                                                             i.ppoper,
                                                             i.ppsbop,
                                                             i.pptope,
                                                             i.ppfpag,
                                                             pd_fec);
              ln_diasTot := ln_diasTot + ln_dias;
              
              if ln_diasMaxAux < ln_dias then
                ln_diasMaxAux := ln_dias;
                end if;
                 
                
            end if;
          
            ld_fecantC := i.ppfpag;
          end if;
        
        end loop;
        ln_diasMax := ln_diasMaxAux;
      
        if pn_stat = 99 then
          begin
          
            select 1
              into ln_flag
              from fsd601 a
             where a.pgcod = pn_emp
               and a.ppmod = pn_mod
               and a.ppsuc = pn_suc
               and a.ppmda = pn_mda
               and a.pppap = pn_pap
               and a.ppcta = pn_cta
               and a.ppoper = pn_ope
               and a.ppsbop = pn_sbo
               and a.pptope = pn_top
                  --and a.ppfpag between pd_fecor and pd_fec
               and a.ppfpag >= pd_fec
                  --and a.ppfpag < pd_fec
               and a.d601co = 'S'
               and (a.ppcap + a.ppint) <> 0
               and rownum = 1;
          exception
            when no_data_found then
              ln_flag := 0;
          end;
        else
          ln_flag := 0;
        end if;
      
        if ln_flag = 1 then
          ln_contador := ln_contador + 1;
        end if;
      end;
    
    end Sp_CalculaCuotas;
  ------------------------------------------------------------
    
    Procedure Sp_DiaAtraso_linea(pn_pai      in number,
                                 pn_tdo      in number,
                                 pc_ndo      in char,
                                 pd_fecpro   in date,
                                 ln_maximo out number) is
    
      ld_fecini   date;
      ln_vig      number(9);
      ln_dia      number(18);
      ln_contador number(18);
    begin
    
      begin
        select tp1nro1
          into ln_vig
          from fst198
         where tp1cod = 1
           and tp1cod1 = 10899
           and tp1corr1 = 2
           and tp1corr2 = 4;
      exception
        when others then
          ln_vig := null; --cambiar en produccion
      
      end;
    
      ld_fecini := add_months(pd_fecpro, -ln_vig);
      delete from jaqz081 a
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo;
      commit;
      --execute immediate('truncate table jaqz081');
      begin
        insert into jaqz081
          (PGCOD,
           AOMOD,
           AOSUC,
           AOMDA,
           AOPAP,
           AOCTA,
           AOOPER,
           AOSBOP,
           AOTOPE,
           AOFVAL,
           AOFVTO,
           AOFE99,
           AOSTAT,
           PEPAIS,
           PETDOC,
           PENDOC,
           FEUSO)
          select B.PGCOD,
                 b.aomod,
                 b.aosuc,
                 b.aomda,
                 b.aopap,
                 b.aocta,
                 b.aooper,
                 b.aosbop,
                 b.aotope,
                 b.aofval,
                 b.aofvto,
                 PQ_CR_RELCREDITICIA_NUEVO_MAX.Fn_DiaPago(b.PGCOD,
                                                AOMOD,
                                                AOSUC,
                                                AOMDA,
                                                AOPAP,
                                                AOCTA,
                                                AOOPER,
                                                AOSBOP,
                                                AOTOPE,
                                                aostat,
                                                aofe99),
                 --b.aofe99,
                 b.aostat,
                 a.pepais,
                 a.petdoc,
                 a.pendoc,
                 --(case when aostat <> 99 then aofvto
                 --else aofe99 end )FEUSO
                 
                 (case
                   when aostat <> 99 then
                    aofvto
                   else
                    PQ_CR_RELCREDITICIA_NUEVO_MAX.Fn_DiaPago(b.PGCOD,
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
                 end) FEUSO
          
            from fsr008 a, fsd010 b
           where a.pgcod = 1
             and a.pepais = pn_pai
             and a.petdoc = pn_tdo
             and a.pendoc = pc_ndo
             and a.cttfir = 'T'
             and b.pgcod = a.pgcod
             and b.aocta = a.ctnro
             and aomod in (select modulo
                             from fst111
                            where dscod = 50
                              and modulo not in (200, 33, 108))
             and (aofe99 >= ld_fecini or
                 aofe99 = to_date('0001.01.01', 'yyyy.mm.dd'))
             and aotope <> 550;
      
        commit;
      end;
    
      PQ_CR_RELCREDITICIA_NUEVO_MAX.Sp_cr_histDiaAtr_linea(pn_pai,
                                                 pn_tdo,
                                                 pc_ndo,
                                                 Pd_fecpro,
                                                 ld_fecini,
                                                 ln_contador,
                                                 ln_dia);
     /* if ln_contador = 0 then
        --dbms_output.put_line (i.pepais||'-'||i.petdoc||'-'||i.pendoc);
        ln_maximo := 0;
      else*/
        ln_maximo := ln_dia;
      /*end if;*/
    
      --      Sp_cr_histDiaAtr_linea
    end Sp_DiaAtraso_linea;

    Procedure Sp_cr_histDiaAtr_linea(pn_pai        in number,
                                     pn_tdo        in number,
                                     pc_ndo        in char,
                                     pd_fecpro     in date,
                                     pd_fecini     in date,
                                     ln_contCuoTot out number,
                                     ln_diaMax     out number) is
    
      cursor creditos is
        select *
          from jaqz081 a
         where a.pepais = pn_pai
           and a.petdoc = pn_tdo
           and a.pendoc = pc_ndo
         order by aostat, aofe99 desc, aofval desc; --aofe99;--aofval DESC;
     
      --ln_contador number(5);    
      ld_fecantD date;
      ld_fecantC date;
      --ln_aux number(4);
      ln_mesac number(2);
      ln_aniac number(4);
      ln_mesan number(2);
      ln_anian number(4);
      ln_suma  number(5);
    
      ld_aofval date;
      ld_aofe99 date;
      --ld_dia number(2);
      ld_feccorte date;
      ln_auxiliar number(5);
      ld_fecdes   date;
      ld_fecaux   date;
      lc_fecaux   char(6);
      ld_sysdate  date;
    
      --ln_contCuoTot number(5);
      --ln_diaMax number(5);
      ln_contador number(18);
    
      ln_sw number(1);
    begin
    
      begin
        ln_contador := 0;
        ld_fecantD  := null;
        --ld_fecantC := to_date('2000.01.01','yyyy.mm.dd');
      
        For i in creditos loop
          ln_sw := 0;
          if (i.aofe99 is null or
             i.aofe99 = to_date('0001.01.01', 'yyyy.mm.dd')) and
             i.aostat = 99 then
            ln_sw := 1;
          end if;
          if ln_sw = 0 then
          
            ln_mesac  := to_number(to_char(i.aofe99, 'mm'));
            ln_aniac  := to_number(to_char(i.aofe99, 'yyyy'));
            ln_suma   := null;
            ld_aofval := i.aofval;
            ld_aofe99 := last_day(i.aofe99);
            --ld_aofe99 := last_day(i.aofe99);
            ld_fecdes  := i.aofval;
            ld_sysdate := last_day(pd_fecpro);
          
            if ld_aofval < pd_fecini then
              ld_aofval := pd_fecini;
            end if;
          
            if i.aostat <> 99 then
              ld_aofe99 := pd_fecpro;
            end if;
          
            if ld_fecantD is null then
              if i.aostat = 99 then
                ln_suma := trunc(months_between(ld_aofe99, ld_aofval)) + 1;
                if ln_suma < 0 then
                  ln_suma := 0;
                end if;
                ln_contador := ln_contador + ln_suma;
              else
                ln_suma := trunc(months_between(ld_sysdate, ld_aofval)) + 1;
                if ln_suma < 0 then
                  ln_suma := 0;
                end if;
                ln_contador := ln_contador + ln_suma;
              
              end if;
            
            Else
            
              if ld_aofe99 = ld_fecantD or
                 (ln_mesac = ln_mesan and ln_aniac = ln_anian) then
                if i.aostat = 99 then
                  ln_suma := trunc(months_between(ld_aofe99, ld_aofval));
                  if ln_suma < 0 then
                    ln_suma := 0;
                  end if;
                  ln_contador := ln_contador + ln_suma;
                
                else
                  ln_suma := trunc(months_between(ld_sysdate, ld_aofval));
                  if ln_suma < 0 then
                    ln_suma := 0;
                  end if;
                  ln_contador := ln_contador + ln_suma;
                end if;
              
              else
                if ld_aofe99 > ld_fecantD then
                  --ln_aux := trunc(months_between(ld_fecantC,ld_aofval));  
                  ld_aofe99 := last_day(ld_fecantD);
                  if i.aostat = 99 then
                    ln_suma := trunc(months_between(ld_aofe99, ld_aofval));
                    if ln_suma < 0 then
                      ln_suma := 0;
                    end if;
                    /*if ln_aux > ln_suma then
                       ln_suma := 0;
                       ln_aux  := 0;
                    end if;*/
                    ln_contador := ln_contador + ln_suma; -- - ln_aux;
                  
                  else
                    ln_suma := trunc(months_between(ld_aofe99, ld_aofval));
                    if ln_suma < 0 then
                      ln_suma := 0;
                    end if;
                    /*if ln_aux > ln_suma then
                       ln_suma := 0;
                       ln_aux  := 0;
                    end if; */
                    ln_contador := ln_contador + ln_suma; -- - ln_aux;
                  end if;
                
                end if;
              
                if ld_aofe99 < ld_fecantD then
                
                  if i.aostat = 99 then
                    ln_suma := trunc(months_between(ld_aofe99, ld_aofval)) + 1;
                    if ln_suma < 0 then
                      ln_suma := 0;
                    end if;
                    ln_contador := ln_contador + ln_suma;
                  
                  else
                    ln_suma := trunc(months_between(ld_sysdate, ld_aofval)) + 1;
                    if ln_suma < 0 then
                      ln_suma := 0;
                    end if;
                    ln_contador := ln_contador + ln_suma;
                  end if;
                
                end if;
              
              end if;
            
            end if;
          
            --if i.aofe99 = to_date('0001.01.01','yyyy.mm.dd') then
            ld_fecantD := ld_aofval;
            ld_fecantC := i.aofe99;
          
            ln_mesan := to_number(to_char(ld_fecantD, 'mm'));
            ln_anian := to_number(to_char(ld_fecantD, 'yyyy'));
          
            if ln_contador = 6 then
              --ld_feccorte := i.aofval;
              lc_fecaux   := to_char(ld_aofval, 'yyyymm');
              ld_feccorte := to_date((lc_fecaux || '01'), 'yyyymmdd');
              exit;
            
            end if;
            if ln_contador > 6 then
              ln_auxiliar := ln_contador - 6;
              ld_fecaux   := add_months(ld_aofval, ln_auxiliar);
              lc_fecaux   := to_char(ld_fecaux, 'yyyymm');
              ld_feccorte := to_date((lc_fecaux || '01'), 'yyyymmdd');
              exit;
            end if;
            ld_feccorte := ld_aofval;
          end if;
        end loop;
        PQ_CR_RELCREDITICIA_NUEVO_MAX.Sp_cr_histDiaAtr_linea_ii(pn_pai,
                                                      pn_tdo,
                                                      pc_ndo,
                                                      ld_feccorte,
                                                      pd_fecpro, /*pd_fecini,*/
                                                      ln_contCuoTot,
                                                      ln_diaMax);
      
      end;
    end Sp_cr_histDiaAtr_linea;

    Procedure Sp_cr_histDiaAtr_linea_ii(pn_pai        in number,
                                        pn_tdo        in number,
                                        pc_ndo        in char,
                                        pd_fecor      in date,
                                        pd_fecpro     in date, /*pd_fecini in date,*/
                                        ln_contCuoTot out number,
                                        ln_diaMax     out number) is
    
      cursor creditos is
      
        select *
          FROM JAQZ081 a
         WHERE a.pepais = pn_pai
           and a.petdoc = pn_tdo
           and a.pendoc = pc_ndo
           and a.feuso >= pd_fecor
         order by aofval desc;
    
      ln_contCuotas number(18);
      ln_dia        number(18);
      ln_diaMaxAux number(15);
      ld_feccan date;
    begin
    
      begin
        ln_contCuoTot := 0;
        ln_diaMax     := -999999;
        ln_diaMaxAux     := -999999;
        for i in creditos loop
          if i.aostat = 99 then
            --                ld_feccan := last_day(i.aofe99);
            ld_feccan := i.aofe99;
          else
            --ld_feccan := last_day(pd_fecpro);
            ld_feccan := pd_fecpro;
          end if;
          PQ_CR_RELCREDITICIA_NUEVO_MAX.sp_calculaCuotas(i.pgcod,
                                               i.aomod,
                                               i.aosuc,
                                               i.aomda,
                                               i.aopap,
                                               i.aocta,
                                               i.aooper,
                                               i.aosbop,
                                               i.aotope,
                                               ld_feccan,
                                               pd_fecor,
                                               i.aostat,
                                               ln_contCuotas,
                                               ln_dia,
                                               ln_diaMaxAux);
          if ln_diaMaxAux>ln_diaMax then
            ln_diaMax := ln_diaMaxAux;
          end if;
          --ln_diaMax     := ln_diaMax + ln_dia;
          ln_contCuoTot := ln_contCuoTot + ln_contCuotas;
        end loop;
      
      end;
    
    end Sp_cr_histDiaAtr_linea_ii;

    Function Fn_DiaPago(pn_emp in number,
                        pn_mod in number,
                        pn_suc in number,
                        pn_mda in number,
                        pn_pap in number,
                        pn_cta in number,
                        pn_ope in number,
                        pn_sbo in number,
                        pn_top in number,
                        pn_est in number,
                        pd_fec in date) return date is
      ld_fecpag date;
    
    begin
    
      begin
        if pn_est = 99 then
          if pd_fec = to_date('01.01.0001', 'dd.mm.yyyy') or pd_fec is null then
            begin
            
              Select max(pp1fech)
                into ld_fecpag
                from fsd602 a
               where a.pgcod = pn_emp
                 and a.ppmod = pn_mod
                 and a.ppsuc = pn_suc
                 and a.ppmda = pn_mda
                 and a.pppap = pn_pap
                 and a.ppcta = pn_cta
                 and a.ppoper = pn_ope
                 and a.ppsbop = pn_sbo
                 and a.pptope = pn_top
                 and a.d602co = 'S'
                 and (a.pp1cap + a.pp1int) <> 0
                 and a.pp1stat = 'T';
            exception
              when no_data_found then
                ld_fecpag := to_date('01.01.0001', 'dd.mm.yyyy');
              
            end;
          else
            ld_fecpag := pd_fec;
          end if;
        
        else
          ld_fecpag := to_date('01.01.0001', 'dd.mm.yyyy');
        end if;

      end;
      return ld_fecpag;
    end Fn_DiaPago;

    
  end PQ_CR_RELCREDITICIA_NUEVO_MAX;
/

