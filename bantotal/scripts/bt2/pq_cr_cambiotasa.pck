create or replace package PQ_CR_CAMBIOTASA is

  -- Author  : MPOSTIGOC
  -- Created : 26/04/2018 12:50:18 p.m.
  -- Purpose : 

  -- Public type declarations
  procedure sp_cr_PorCampania(ln_Instancia in number, lc_Usuario in char);
  ----------------------------------------------------------------
  procedure sp_cr_TipoGarantia(ln_Instancia in number,
                               lc_Garantia  out varchar2);
  -----------------------------------------------
  procedure sp_cr_AtrasoMax(ln_pgcod10   in number,
                            ln_mod10     in number,
                            ln_suc10     in number,
                            ln_mda10     in number,
                            ln_pap10     in number,
                            ln_cta10     in number,
                            ln_oper10    in number,
                            ln_sbop10    in number,
                            ln_tope10    in number,
                            ld_FchSist   in date,
                            ln_AtrasoMax out number);
  --------------------------------------------------------- 
  procedure sp_cr_PromAtras6meses(ln_pgcod10     in number,
                                  ln_mod10       in number,
                                  ln_suc10       in number,
                                  ln_mda10       in number,
                                  ln_pap10       in number,
                                  ln_cta10       in number,
                                  ln_oper10      in number,
                                  ln_sbop10      in number,
                                  ln_tope10      in number,
                                  ld_FchIni      in date,
                                  ld_FchFin      in date,
                                  ln_PromdAtraso out number);
  ------------------------------------------------------------------  
  procedure sp_cr_InsertJAQZ841(ln_JAQZ841INST    NUMBER,
                                ln_jaqz841instv   number,
                                ln_JAQZ841FCH     DATE,
                                ln_JAQZ841HORA    CHAR,
                                ln_JAQZ841USER    CHAR,
                                ln_JAQZ841IND     VARCHAR2,
                                ln_JAQZ841EST     VARCHAR2,
                                ln_JAQZ841CTA     NUMBER,
                                ln_JAQZ841OPER    NUMBER,
                                ln_JAQZ841MOD     NUMBER,
                                ln_JAQZ841MNTCRED NUMBER,
                                ln_JAQZ841SLDCAP  NUMBER,
                                ln_JAQZ841MNTCUO  NUMBER,
                                ln_JAQZ841NROCUOT NUMBER,
                                ln_JAQZ841NROCUOP NUMBER,
                                ln_JAQZ841FCHDES  DATE,
                                ln_JAQZ841ATRMAX  NUMBER,
                                ln_JAQZ841PROMATR NUMBER,
                                ln_JAQZ841TASA    NUMBER,
                                ln_JAQZ841TIPGAR  VARCHAR2);
  -----------------------------------------------------------------
  procedure sp_relacion_cred(pn_pais in fsr008.pepais%type,
														 pn_tdoc in fsr008.petdoc%type,
														 pn_ndoc in varchar,
														 pd_fecp in date,
														 pd_flag out varchar);
  -----------------------------------------------------------------
  
  -----------------------------------------------------------------
end PQ_CR_CAMBIOTASA;
/

create or replace package body PQ_CR_CAMBIOTASA is

  procedure sp_cr_PorCampania(ln_Instancia in number, lc_Usuario in char) is
  
    cursor Cred_Vigentes(ln_Pepais in number, ln_Petdoc in number, ln_Pendoc in varchar2, ld_FchSist date) is
    
      select d10.pgcod    ln_pgcod10,
             d10.aomod    ln_mod10,
             d10.aosuc    ln_suc10,
             d10.aomda    ln_mda10,
             d10.aopap    ln_pap10,
             d10.aocta    ln_cta10,
             d10.aooper   ln_oper10,
             d10.aosbop   ln_sbop10,
             d10.aotope   ln_tope10,
             d10.aoperiod ln_peri10,
             d10.aotasa   ln_Tasa,
             d10.aoimp    ln_MontAprob,
             d10.aofval   ld_FchDesembolso
      
        from fsd010 d10
       where Pgcod = 1
         and Aocta in (select Ctnro
                         from fsr008
                        where pepais = ln_Pepais
                          and Petdoc = ln_Petdoc
                          and pendoc = ln_Pendoc)
         and (Aomod in (select modulo
                          from fst111
                         where dscod = 50
                           and modulo not in (108, 141)) or Aomod = 117)
         and Aostat <> 99
      /*and aofvto >= ld_FchSist*/
      ;
  
    cursor Cred_Cancelados(ln_Pepais in number, ln_Petdoc in number, ln_Pendoc in varchar2, ld_FchSist date) is
    
      select d10.pgcod    ln_pgcod10,
             d10.aomod    ln_mod10,
             d10.aosuc    ln_suc10,
             d10.aomda    ln_mda10,
             d10.aopap    ln_pap10,
             d10.aocta    ln_cta10,
             d10.aooper   ln_oper10,
             d10.aosbop   ln_sbop10,
             d10.aotope   ln_tope10,
             d10.aoperiod ln_peri10,
             d10.aotasa   ln_Tasa,
             d10.aoimp    ln_MontAprob,
             d10.aofval   ld_FchDesembolso
        from fsd010 d10
       where Pgcod = 1
         and Aocta in (select Ctnro
                         from fsr008
                        where pepais = ln_Pepais
                          and Petdoc = ln_Petdoc
                          and pendoc = ln_Pendoc)
         and (Aomod in (select modulo
                          from fst111
                         where dscod = 50
                           and modulo not in (108, 141)) or Aomod = 117)
         and Aostat = 99;
  
    ln_Pepais         number;
    ln_Petdoc         number;
    ln_Pendoc         varchar2(12);
    ld_FchSist        date;
    ln_SaldCapCredVig number;
    ln_MontCuota      number;
    ln_NroCuotCalend  number;
    ln_NroCuotPagadas number;
    ln_AtrasoMax      number;
    ln_PromdAtraso    number; 
    ld_FchIni         date;
    lc_hora           char(8);
    ln_instcredvig    number;
    lc_Garantia       varchar2(150);
    vi_tasa           fsd010.aotasa%type;
    vi_meses_calc     number;
  begin
  
    begin
      --Datos de la Instancia
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_Pepais, ln_Petdoc, ln_Pendoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
       when others then
            null;
    end;
  
    begin
      -- Fcha del sistema
      select pgfape into ld_FchSist from fst017 where pgcod = 1;
    end;
  
    begin --Guia especial de proceso para obtener los meses que se utilizaran para el calculo del promedio de atraso.
         SELECT tp1nro1
         INTO   vi_meses_calc
         FROM fst198
         where tp1cod    = 1
           and tp1cod1   = 11119
           and tp1corr1  = 5
           and tp1corr2  = 2
           and tp1corr3  = 1;
    exception 
      when no_data_found then
           vi_meses_calc:=12;
      end;
    begin
      --Meses de Corte para Promedio
      SELECT ADD_MONTHS(ld_FchSist, -vi_meses_calc)
        into ld_FchIni
        FROM DUAL;
        dbms_output.put_line(ld_FchIni);
    end;
  
    begin
      delete from jaqz841 where jaqz841inst = ln_Instancia;
    end;
  
    for cv in Cred_Vigentes(ln_Pepais, ln_Petdoc, ln_Pendoc, ld_FchSist) loop
    
      begin
        -- Hora de ejecucion
        select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
      end;
      --verificar tasa actual. 2018.11.21
      vi_tasa := cv.ln_tasa;
      begin
           select
                d.evtasa
             into
                vi_tasa 
           from fsd012 d 
           where d.pgcod = cv.ln_pgcod10  
             and d.aomod = cv.ln_mod10
             and d.aosuc = cv.ln_suc10
             and d.aomda = cv.ln_mda10  
             and d.aopap = cv.ln_pap10 
             and d.aocta = cv.ln_cta10
             and d.aooper= cv.ln_oper10
             and d.aosbop= cv.ln_sbop10
             and d.aotope= cv.ln_tope10
             and d.evtipo= 3
             and d.d012co='S'
             and evcorr= (select max(evcorr) from fsd012 d0 where d0.pgcod = cv.ln_pgcod10  
                                                           and d0.aomod = cv.ln_mod10
                                                           and d0.aosuc = cv.ln_suc10
                                                           and d0.aomda = cv.ln_mda10  
                                                           and d0.aopap = cv.ln_pap10 
                                                           and d0.aocta = cv.ln_cta10
                                                           and d0.aooper= cv.ln_oper10
                                                           and d0.aosbop= cv.ln_sbop10
                                                           and d0.aotope= cv.ln_tope10
                                                           and d0.evtipo= 3
                                                           and d0.d012co= 'S' );
      exception 
        when others then   
             vi_tasa := cv.ln_tasa;
        end;
      --------------------------------------------------------------------  
      begin
        
        select x.xwfprcins
          into ln_instcredvig
          from xwf700 x
         where x.xwfempresa  = cv.ln_pgcod10
           and x.xwfsucursal = cv.ln_suc10
           and x.xwfmodulo   = cv.ln_mod10
           and x.xwfmoneda   = cv.ln_mda10
           and x.xwfpapel    = cv.ln_pap10
           and x.xwfcuenta   = cv.ln_cta10
           and x.xwfoperacion= cv.ln_oper10
           and x.xwfsubope   = cv.ln_sbop10
           and x.xwftipope   = cv.ln_tope10
           and x.xwfcar3 = '1';
      exception --HSUAREZ 23.07.2018 - AGREGAGO EXCEPTION
        when others then
          null;
          ln_instcredvig:=0;
      end;
    
      begin
        ln_MontCuota:=0;
        if cv.ln_mod10<>117 then --HSUAREZ 24.07.2018
          --Monto de Cuota
          select s.sng01icuot
            into ln_MontCuota
            from sng001 s
           where s.sng001inst = ln_instcredvig;
        end if;
      exception --HSUAREZ 23.07.2018 - AGREGAGO EXCEPTION
        when others then
          begin
              select (d.ppcap+d.ppint)
              into   ln_MontCuota
              from  fsd601 d
              where d.pgcod   = cv.ln_pgcod10
              and   d.ppmod   = cv.ln_mod10
              and   d.ppsuc   = cv.ln_suc10          
              and   d.ppmda   = cv.ln_mda10
              and   d.pppap   = cv.ln_pap10
              and   d.ppcta   = cv.ln_cta10
              and   d.ppoper  = cv.ln_oper10
              and   d.ppsbop  = cv.ln_sbop10
              and   d.pptope  = cv.ln_tope10
              and   d.ppfpag  = (select 
                                         max(ppfval)
                                   from  fsd601 dd
                                   where dd.pgcod   = cv.ln_pgcod10
                                     and dd.ppmod   = cv.ln_mod10
                                     and dd.ppsuc   = cv.ln_suc10
                                     and dd.ppmda   = cv.ln_mda10
                                     and dd.pppap   = cv.ln_pap10
                                     and dd.ppcta   = cv.ln_cta10
                                     and dd.ppoper  = cv.ln_oper10
                                     and dd.ppsbop  = cv.ln_sbop10
                                     and dd.pptope  = cv.ln_tope10
                                     and dd.d601co  = 'S'
                                   )                               
              and   d.d601co  = 'S'; 
           exception when others then
                     null;
           end;   
      end;
    
      begin
         ln_SaldCapCredVig:= 0;
         if cv.ln_mod10<>117 then --HSUAREZ 24.07.2018
        -- Saldo Capital
        select (f.scsdo * -1)
          into ln_SaldCapCredVig
          from fsd011 f
         where f.pgcod = cv.ln_pgcod10
           and f.scsuc = cv.ln_suc10
           and f.scmda = cv.ln_mda10
           and f.scpap = cv.ln_pap10
           and f.sccta = cv.ln_cta10
           and f.scoper = cv.ln_oper10
           and f.scsbop = cv.ln_sbop10
           and f.sctope = cv.ln_tope10;
         end if;
      exception
        when others then
          null;
      end;
    
      begin
        -- Nro de Cuotas Calendario
        select COUNT(*)
          into ln_NroCuotCalend
          from fsd601 g
         where g.pgcod = cv.ln_pgcod10
           and g.ppmod = cv.ln_mod10
           and g.ppsuc = cv.ln_suc10
           and g.ppmda = cv.ln_mda10
           and g.pppap = cv.ln_pap10
           and g.ppcta = cv.ln_cta10
           and g.ppoper = cv.ln_oper10
           and g.ppsbop = cv.ln_sbop10
           and g.pptope = cv.ln_tope10
           and g.d601co = 'S';
      exception
        when others then
          null;
      end;
    
      begin
        -- Nro de Cuotas Pagadas
        select COUNT(*)
          into ln_NroCuotPagadas
          from fsd602 g
         where g.pgcod = cv.ln_pgcod10
           and g.ppmod = cv.ln_mod10
           and g.ppsuc = cv.ln_suc10
           and g.ppmda = cv.ln_mda10
           and g.pppap = cv.ln_pap10
           and g.ppcta = cv.ln_cta10
           and g.ppoper = cv.ln_oper10
           and g.ppsbop = cv.ln_sbop10
           and g.pptope = cv.ln_tope10
           and g.pp1stat = 'T'
           and g.d602co = 'S';
      exception
        when others then
          null;
      end;
    
      pq_cr_cambiotasa.sp_cr_TipoGarantia(ln_instcredvig, lc_Garantia);
    
      pq_cr_cambiotasa.sp_cr_AtrasoMax(ln_pgcod10   => cv.ln_pgcod10,
                                       ln_mod10     => cv.ln_mod10,
                                       ln_suc10     => cv.ln_suc10,
                                       ln_mda10     => cv.ln_mda10,
                                       ln_pap10     => cv.ln_pap10,
                                       ln_cta10     => cv.ln_cta10,
                                       ln_oper10    => cv.ln_oper10,
                                       ln_sbop10    => cv.ln_sbop10,
                                       ln_tope10    => cv.ln_tope10,
                                       ld_FchSist   => ld_FchSist,
                                       ln_AtrasoMax => ln_AtrasoMax);
    
      pq_cr_cambiotasa.sp_cr_PromAtras6meses(ln_pgcod10     => cv.ln_pgcod10,
                                             ln_mod10       => cv.ln_mod10,
                                             ln_suc10       => cv.ln_suc10,
                                             ln_mda10       => cv.ln_mda10,
                                             ln_pap10       => cv.ln_pap10,
                                             ln_cta10       => cv.ln_cta10,
                                             ln_oper10      => cv.ln_oper10,
                                             ln_sbop10      => cv.ln_sbop10,
                                             ln_tope10      => cv.ln_tope10,
                                             ld_FchIni      => ld_FchIni,--cv.ld_fchdesembolso,-- ld_FchIni, rmogrovejo 23/08/2018
                                             ld_FchFin      => ld_FchSist,
                                             ln_PromdAtraso => ln_PromdAtraso);
    
      pq_cr_cambiotasa.sp_cr_InsertJAQZ841(ln_Instancia,
                                           ln_instcredvig,--HSUAREZ 22.05.2018 - SE AGREGO EL CAMPO INSTANCIA DEL CREDITO VIGENTES
                                           ld_FchSist,
                                           lc_hora,
                                           lc_Usuario,
                                           'V',
                                           'H',
                                           cv.ln_cta10,
                                           cv.ln_oper10,
                                           cv.ln_mod10,
                                           cv.ln_montaprob,
                                           ln_SaldCapCredVig,
                                           ln_MontCuota,
                                           ln_NroCuotCalend,
                                           ln_NroCuotPagadas,
                                           cv.ld_fchdesembolso,
                                           ln_AtrasoMax,
                                           ln_PromdAtraso,
                                           vi_tasa,--cv.ln_tasa, 2018.11.21
                                           lc_Garantia
                                           );
    
    end loop;
  
    for cc in Cred_Cancelados(ln_Pepais, ln_Petdoc, ln_Pendoc, ld_FchSist) loop
    
      begin
        -- Hora de ejecucion
        select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
      end;
    
      begin
        select x.xwfprcins
          into ln_instcredvig
          from xwf700 x
         where x.xwfempresa   = cc.ln_pgcod10
           and x.xwfsucursal  = cc.ln_suc10
           and x.xwfmodulo    = cc.ln_mod10
           and x.xwfmoneda    = cc.ln_mda10
           and x.xwfpapel     = cc.ln_pap10
           and x.xwfcuenta    = cc.ln_cta10
           and x.xwfoperacion = cc.ln_oper10
           and x.xwfsubope    = cc.ln_sbop10
           and x.xwftipope    = cc.ln_tope10
           and x.xwfcar3 = '1';
      exception --Hsuarez 2018-07-23
           when others then
               null; 
               ln_instcredvig:=0;
      end;
      --verificar tasa actual. 2018.11.21
      vi_tasa := cc.ln_tasa;
      begin
           select
                d.evtasa
             into
                vi_tasa 
           from fsd012 d 
           where d.pgcod = cc.ln_pgcod10  
             and d.aomod = cc.ln_mod10
             and d.aosuc = cc.ln_suc10
             and d.aomda = cc.ln_mda10  
             and d.aopap = cc.ln_pap10 
             and d.aocta = cc.ln_cta10
             and d.aooper= cc.ln_oper10
             and d.aosbop= cc.ln_sbop10
             and d.aotope= cc.ln_tope10
             and d.evtipo= 3
             and d.d012co='S'
             and evcorr= (select max(evcorr) from fsd012 d0 where d0.pgcod = cc.ln_pgcod10  
                                                           and d0.aomod = cc.ln_mod10
                                                           and d0.aosuc = cc.ln_suc10
                                                           and d0.aomda = cc.ln_mda10  
                                                           and d0.aopap = cc.ln_pap10 
                                                           and d0.aocta = cc.ln_cta10
                                                           and d0.aooper= cc.ln_oper10
                                                           and d0.aosbop= cc.ln_sbop10
                                                           and d0.aotope= cc.ln_tope10
                                                           and d0.evtipo= 3
                                                           and d0.d012co= 'S' );
      exception 
        when others then   
             vi_tasa := cc.ln_tasa;
        end;
      --------------------------------------------------------------------  
      begin
        --Monto de Cuota
        select s.sng01icuot
          into ln_MontCuota
          from sng001 s
         where s.sng001inst = ln_instcredvig;
      exception --HSUAREZ 23.07.2018 - AGREGAGO EXCEPTION
        when others then
          begin
                select (d.ppcap+d.ppint)
                into   ln_MontCuota
                from  fsd601 d
                where d.pgcod   =  cc.ln_pgcod10
                and   d.ppmod   =  cc.ln_suc10
                and   d.ppsuc   =  cc.ln_mod10
                and   d.ppmda   =  cc.ln_mda10
                and   d.pppap   =  cc.ln_pap10
                and   d.ppcta   =  cc.ln_cta10
                and   d.ppoper  =  cc.ln_oper10
                and   d.ppsbop  =  cc.ln_sbop10
                and   d.pptope  =  cc.ln_tope10
                and   d.ppfpag  = (select 
                                           max(ppfval)
                                     from  fsd601 dd
                                     where dd.pgcod   =  cc.ln_pgcod10
                                       and dd.ppmod   =  cc.ln_suc10
                                       and dd.ppsuc   =  cc.ln_mod10
                                       and dd.ppmda   =  cc.ln_mda10
                                       and dd.pppap   =  cc.ln_pap10
                                       and dd.ppcta   =  cc.ln_cta10
                                       and dd.ppoper  =  cc.ln_oper10
                                       and dd.ppsbop  =  cc.ln_sbop10
                                       and dd.pptope  =  cc.ln_tope10
                                       and dd.d601co  = 'S'
                                     )                               
                and   d.d601co  = 'S'; 
           exception when others then
                     null;
           end; 
      end;
    
      begin
        -- Nro de Cuotas Calendario
        select COUNT(*)
          into ln_NroCuotCalend
          from fsd601 g
         where g.pgcod = cc.ln_pgcod10
           and g.ppmod = cc.ln_mod10
           and g.ppsuc = cc.ln_suc10
           and g.ppmda = cc.ln_mda10
           and g.pppap = cc.ln_pap10
           and g.ppcta = cc.ln_cta10
           and g.ppoper = cc.ln_oper10
           and g.ppsbop = cc.ln_sbop10
           and g.pptope = cc.ln_tope10
           and g.d601co = 'S';
      exception
        when others then
          null;
      end;
    
      begin
        -- Nro de Cuotas Pagadas
        select COUNT(*)
          into ln_NroCuotPagadas
          from fsd602 g
         where g.pgcod = cc.ln_pgcod10
           and g.ppmod = cc.ln_mod10
           and g.ppsuc = cc.ln_suc10
           and g.ppmda = cc.ln_mda10
           and g.pppap = cc.ln_pap10
           and g.ppcta = cc.ln_cta10
           and g.ppoper = cc.ln_oper10
           and g.ppsbop = cc.ln_sbop10
           and g.pptope = cc.ln_tope10
           and g.pp1stat = 'T'
           and g.d602co = 'S';
      exception
        when others then
          null;
      end;
    
      pq_cr_cambiotasa.sp_cr_AtrasoMax(ln_pgcod10   => cc.ln_pgcod10,
                                       ln_mod10     => cc.ln_mod10,
                                       ln_suc10     => cc.ln_suc10,
                                       ln_mda10     => cc.ln_mda10,
                                       ln_pap10     => cc.ln_pap10,
                                       ln_cta10     => cc.ln_cta10,
                                       ln_oper10    => cc.ln_oper10,
                                       ln_sbop10    => cc.ln_sbop10,
                                       ln_tope10    => cc.ln_tope10,
                                       ld_FchSist   => ld_FchSist,
                                       ln_AtrasoMax => ln_AtrasoMax);
    
      pq_cr_cambiotasa.sp_cr_PromAtras6meses(ln_pgcod10     => cc.ln_pgcod10,
                                             ln_mod10       => cc.ln_mod10,
                                             ln_suc10       => cc.ln_suc10,
                                             ln_mda10       => cc.ln_mda10,
                                             ln_pap10       => cc.ln_pap10,
                                             ln_cta10       => cc.ln_cta10,
                                             ln_oper10      => cc.ln_oper10,
                                             ln_sbop10      => cc.ln_sbop10,
                                             ln_tope10      => cc.ln_tope10,
                                             ld_FchIni      => ld_FchIni,--HSUAREZ COMENTADO AHORA SE USARA GUIA Y SE CALCULARA EL PROMEDIO DE LOS MESES SEÑALADOS POR GUIA. /*cc.ld_fchdesembolso*/,---ld_FchIni, rmogrovejo seagrego y comento 23/08/18
                                             ld_FchFin      => ld_FchSist,
                                             ln_PromdAtraso => ln_PromdAtraso);
    
      pq_cr_cambiotasa.sp_cr_InsertJAQZ841(ln_Instancia,
                                           ln_instcredvig,--HSUAREZ 22.05.2018 - SE AGREGO EL CAMPO INSTANCIA DEL CREDITO CANCELADO
                                           ld_FchSist,
                                           lc_hora,
                                           lc_Usuario,
                                           'C',
                                           'H',
                                           cc.ln_cta10,
                                           cc.ln_oper10,
                                           cc.ln_mod10,
                                           cc.ln_montaprob,
                                           0.00,
                                           ln_MontCuota,
                                           ln_NroCuotCalend,
                                           ln_NroCuotPagadas,
                                           cc.ld_fchdesembolso,
                                           ln_AtrasoMax,
                                           ln_PromdAtraso,
                                           cc.ln_tasa,
                                           '');
    
    end loop;
  
  end sp_cr_PorCampania;
  ------------------------------------------------------- verificar esto
  procedure sp_cr_AtrasoMax(ln_pgcod10   in number,
                            ln_mod10     in number,
                            ln_suc10     in number,
                            ln_mda10     in number,
                            ln_pap10     in number,
                            ln_cta10     in number,
                            ln_oper10    in number,
                            ln_sbop10    in number,
                            ln_tope10    in number,
                            ld_FchSist   in date,
                            ln_AtrasoMax out number) is
  
    cursor calendario is
      select f.pgcod  ln_pgcod,
             f.ppsuc  ln_sucursal,
             f.ppmod  ln_modulo,
             f.ppmda  ln_moneda,
             f.pppap  ln_papel,
             f.ppcta  ln_cuenta,
             f.ppoper ln_operacion,
             f.ppsbop ln_subopera,
             f.pptope ln_tipopera,
             f.ppfpag ld_FchCalendario
        from fsd601 f
       where f.pgcod = ln_pgcod10
         and f.ppsuc = ln_suc10
         and f.ppmod = ln_mod10
         and f.ppmda = ln_mda10
         and f.pppap = ln_pap10
         and f.ppcta = ln_cta10
         and f.ppoper = ln_oper10
         and f.ppsbop = ln_sbop10
         and f.pptope = ln_tope10
         and f.ppfpag <= ld_FchSist;
  
    ln_MoraCuota    number := 0;
    ln_MoraCuotaAux2  number := 0;
    aux number := 0;
    ln_MoraCuotaAux number := 0;
  
    ln_fult_pago date;
    ln_fec_sist date;
    ln_atraso_cuotp number;
    pn_estado number(2);
    pd_fecha_vencimiento date;--
    result number;
    
  begin
    ln_AtrasoMax := 0;
    --HSUAREZ 2018.08.10
    
    begin
         select pgfape
         into   ln_fec_sist
         from fst017 where pgcod=1;
    end;         

    -----------rmogrovejo si es credito cancelado -------------------------
              
      select aostat, aofvto
      into pn_estado, pd_fecha_vencimiento
      from  fsd010 
      where pgcod= ln_pgcod10
       and aomod = ln_mod10
      and aosuc = ln_suc10   
      and aocta = ln_cta10     
      and aomda= ln_mda10
      and aopap= ln_pap10
      and aooper= ln_oper10         
      and aosbop= ln_sbop10   
      and aotope= ln_tope10;

    -----------------------------------------------------------------------
           
   if pn_estado <> 99 then ---rmogrovejo
      
    begin  
      select max(ppfpag)
            into ln_fult_pago  
      from fsd602 
      where pgcod  = ln_pgcod10
        and ppsuc  = ln_suc10
        and ppmod  = ln_mod10
        and ppmda  = ln_mda10
        and pppap  = ln_pap10
        and ppcta  = ln_cta10
        and ppoper = ln_oper10
        and ppsbop = ln_sbop10
        and pptope = ln_tope10
        and pp1stat= 'T';
     exception 
       when no_data_found then
           null;
     end;
     
    begin
      if ln_fult_pago<>null then ---credit nuevo 
        begin
         select 
              ln_fec_sist - max(ppfpag)  ---rmogrovejo se agrego maxima fecha de pago max  ln_fec_sist - ppfpag 
           into ln_atraso_cuotp
           from fsd601 
          where pgcod  = ln_pgcod10 
            and ppsuc  = ln_suc10
            and ppmod  = ln_mod10
            and ppmda  = ln_mda10
            and pppap  = ln_pap10
            and ppcta  = ln_cta10
            and ppoper = ln_oper10
            and ppsbop = ln_sbop10
            and pptope = ln_tope10
            --and ppfpag > ln_fult_pago
            and ppfval = ln_fult_pago
            and rownum = 1
            order by ppfpag asc;
         exception 
           when no_data_found then
               ln_atraso_cuotp:=0;
         end;
         
       else
         
         begin
           select 
                 ln_fec_sist - max(ppfpag)  ---rmogrovejo se agrego maxima fecha de pago max  ln_fec_sist - ppfpag
             into 
                ln_atraso_cuotp
             from fsd601 
            where pgcod  = ln_pgcod10 
              and ppsuc  = ln_suc10
              and ppmod  = ln_mod10
              and ppmda  = ln_mda10
              and pppap  = ln_pap10
              and ppcta  = ln_cta10
              and ppoper = ln_oper10
              and ppsbop = ln_sbop10
              and pptope = ln_tope10  
            --  and d601co= 'S' --agregar q te contabilzado  rms
              and rownum = 1
              order by ppfpag asc;
            exception 
           when no_data_found then
               ln_atraso_cuotp:=0;
         end;    
       end if;
           
      end;
      
   end if;---rmogrovejo
     
   if pn_estado = 99  then --- se agrego rmogrovejo-------para creditos cancelados -------------------------------------
     
   for c in calendario loop
      ln_MoraCuotaAux := 0;
    
      begin
        select max(pp1fech - ppfpag)
          into ln_MoraCuotaAux----atrasos cuotas canceladas
          from fsd602
         where pgcod = C.LN_PGCOD
           and ppsuc = c.ln_sucursal
           and ppmod = c.ln_modulo
           and ppmda = c.ln_moneda
           and pppap = c.ln_papel
           and ppcta = c.ln_cuenta
           and ppoper = c.ln_operacion
           and ppsbop = c.ln_subopera
           and pptope = c.ln_tipopera
           and pp1stat = 'T'
           and ppfpag = c.ld_fchcalendario; --c.ld_fchcalendario;regresar rmogrovejo++
      exception
        when no_Data_found then
          ln_MoraCuota := null; --ld_FchSist - c.ld_fchcalendario;----ver rmogrovejo 20/08/2018 cuotas sin pagar 
      end;
    
      ln_MoraCuotaAux2:=ln_MoraCuotaAux;
   
    if ln_MoraCuotaAux2 >= aux THEN
            aux:= ln_MoraCuotaAux2;
    END IF;
    
    end loop;
    
    ln_AtrasoMax:=aux;
       
   end if;
 -------------------------------------------------------------------------------------------------------------------------
     
    --HSUAREZ  xekear
   if pn_estado <> 99 then ---rmogrovejo 
    
    for c in calendario loop
      ln_MoraCuotaAux := 0;
    
      begin
        select max(pp1fech - ppfpag)
          into ln_MoraCuotaAux----atrasos cuotas canceladas
          from fsd602
         where pgcod = C.LN_PGCOD
           and ppsuc = c.ln_sucursal
           and ppmod = c.ln_modulo
           and ppmda = c.ln_moneda
           and pppap = c.ln_papel
           and ppcta = c.ln_cuenta
           and ppoper = c.ln_operacion
           and ppsbop = c.ln_subopera
           and pptope = c.ln_tipopera
           and pp1stat = 'T'
           and ppfpag = c.ld_fchcalendario; --c.ld_fchcalendario;regresar rmogrovejo++
      exception
        when no_Data_found then
          ln_MoraCuota := null; --ld_FchSist - c.ld_fchcalendario;----ver rmogrovejo 20/08/2018 cuotas sin pagar 
      end;
    
      if ln_AtrasoMax < ln_MoraCuotaAux then
        ln_AtrasoMax := ln_MoraCuotaAux;
      end if;
      
      if ln_AtrasoMax < ln_atraso_cuotp then
        ln_AtrasoMax := ln_atraso_cuotp;
        end if;
    
    end loop;
    if ln_AtrasoMax < 0 then
        ln_AtrasoMax:=0;
    end if;
    
  end if;
    
  end sp_cr_AtrasoMax;
  ------------------------------------------------------------
  procedure sp_cr_PromAtras6meses(ln_pgcod10     in number,
                                  ln_mod10       in number,
                                  ln_suc10       in number,
                                  ln_mda10       in number,
                                  ln_pap10       in number,
                                  ln_cta10       in number,
                                  ln_oper10      in number,
                                  ln_sbop10      in number,
                                  ln_tope10      in number,
                                  ld_FchIni      in date,
                                  ld_FchFin      in date,
                                  ln_PromdAtraso out number) is
  
    cursor calendarios(fec_ini in date, fec_fin in date) is
      select f.pgcod  ln_pgcod,
             f.ppsuc  ln_sucursal,
             f.ppmod  ln_modulo,
             f.ppmda  ln_moneda,
             f.pppap  ln_papel,
             f.ppcta  ln_cuenta,
             f.ppoper ln_operacion,
             f.ppsbop ln_subopera,
             f.pptope ln_tipopera,
             f.ppfpag ld_FchCalendario
        from fsd601 f
       where f.ppfpag >=fec_ini
         and f.ppfpag <=fec_fin
         and f.pgcod = ln_pgcod10
         and f.ppsuc = ln_suc10
         and f.ppmod = ln_mod10
         and f.ppmda = ln_mda10
         and f.pppap = ln_pap10
         and f.ppcta = ln_cta10
         and f.ppoper = ln_oper10
         and f.ppsbop = ln_sbop10
         and f.pptope = ln_tope10
         and f.d601co = 'S'; --2018.10.10 - filtro adicional
  
    ln_NroCuotCalend number;
    ln_DiasAtraso    number := 0;
    aux    number := 0;
    aux2 date:=ld_FchIni;
    pd_fecprg date;
    ln_DiasAtrasoAux number;
    ln_DiasAtrasoAux2 number;
    ln_fult_pago date;
    ln_fec_sist date;
    ln_atraso_cuotp number;
    pn_estado number(2);
    pd_fecha_vencimiento date;--
    pd_fecha_pag date;
    pd_fecha_pag2 date;
    vi_fecha_habil date;
    flag_habil char(1);
    vi_regula number;
    vi_fecha_1pago date;
    
  begin
  dbms_output.put_line(ld_FchIni);
  dbms_output.put_line(ld_FchFin);
  ln_PromdAtraso:=0;
  
    begin
      select COUNT(*)
        into ln_NroCuotCalend
        from fsd601 g
       where g.pgcod = ln_pgcod10
         and g.ppmod = ln_mod10
         and g.ppsuc = ln_suc10
         and g.ppmda = ln_mda10
         and g.pppap = ln_pap10
         and g.ppcta = ln_cta10
         and g.ppoper = ln_oper10
         and g.ppsbop = ln_sbop10
         and g.pptope = ln_tope10
         and g.ppfpag >=ld_FchIni  --Fecha de Inicio  se agrego 2019.01.16 
         and g.ppfpag <=ld_FchFin  --Fecha Fin se agrego 2019.01.16
         and g.d601co = 'S';
         
    exception
      when others then
        null;
    end;
    --HSUAREZ 2018.08.10
    
    begin
         select pgfape
         into   ln_fec_sist
         from fst017 where pgcod=1;
      end;     
               
      -----------rmogrovejo si es credito cancelado -------------------------
              
      select aostat, aofvto
      into pn_estado, pd_fecha_vencimiento
      from  fsd010 
      where pgcod= ln_pgcod10
       and aomod = ln_mod10
      and aosuc = ln_suc10   
      and aocta = ln_cta10     
      and aomda= ln_mda10
      and aopap= ln_pap10
      and aooper= ln_oper10         
      and aosbop= ln_sbop10   
      and aotope= ln_tope10;

    -----------------------------------------------------------------------
 if pn_estado <> 99 then ---rmogrovejo
   
    begin  
      select max(ppfpag)
            into ln_fult_pago  
      from fsd602 
      where pgcod  = ln_pgcod10
        and ppsuc  = ln_suc10
        and ppmod  = ln_mod10
        and ppmda  = ln_mda10
        and pppap  = ln_pap10
        and ppcta  = ln_cta10
        and ppoper = ln_oper10
        and ppsbop = ln_sbop10
        and pptope = ln_tope10
        and pp1stat= 'T';
     exception 
       when no_data_found then
           null;
     end;
     
    begin
      if ln_fult_pago<>null then
        begin
         select 
               ln_fec_sist - max(ppfpag)  --rmogrovejo agrego max
           into ln_atraso_cuotp
           from fsd601 
          where pgcod  = ln_pgcod10 
            and ppsuc  = ln_suc10
            and ppmod  = ln_mod10
            and ppmda  = ln_mda10
            and pppap  = ln_pap10
            and ppcta  = ln_cta10
            and ppoper = ln_oper10
            and ppsbop = ln_sbop10
            and pptope = ln_tope10
            and ppfpag > ln_fult_pago
            and d601co = 'S' --2018.10.10 filtro adicional
            and rownum = 1
            order by ppfpag asc;
         exception 
           when no_data_found then
               ln_atraso_cuotp:=0;
         end;
       else
         begin
           select 
                ln_fec_sist - max(ppfpag)--rmogrovejo agrego max
             into 
                ln_atraso_cuotp
             from fsd601 
            where pgcod  = ln_pgcod10 
              and ppsuc  = ln_suc10
              and ppmod  = ln_mod10
              and ppmda  = ln_mda10
              and pppap  = ln_pap10
              and ppcta  = ln_cta10
              and ppoper = ln_oper10
              and ppsbop = ln_sbop10
              and pptope = ln_tope10
              and d601co = 'S'
              and rownum = 1
              order by ppfpag asc;
            exception 
           when no_data_found then
               ln_atraso_cuotp:=0;
         end;    
       end if;
      end;
  end if;
  
 if pn_estado = 99  then --- se agrego rmogrovejo-------para creditos cancelados -------------------------------------
   begin
       select min(ppfpag)
       into   vi_fecha_1pago
       from fsd601 d1
             where d1.pgcod  = ln_pgcod10 
               and d1.ppsuc  = ln_suc10   
               and d1.ppmod  = ln_mod10   
               and d1.ppmda  = ln_mda10   
               and d1.pppap  = ln_pap10   
               and d1.ppcta  = ln_cta10   
               and d1.ppoper = ln_oper10  
               and d1.ppsbop = ln_sbop10  
               and d1.pptope = ln_tope10  
               --and d1.ppstat= 'T';  COMENTADO NO FUNCIONA ACTUALMENTE ESTE FILTRO.
               and d1.d601co = 'S';
     end;  
   for c in calendarios(vi_fecha_1pago,ld_Fchfin) loop
      ln_DiasAtrasoAux := 0;
      ln_PromdAtraso :=0;
    
        begin
            select (pp1fech - ppfpag),pp1fech
              into ln_DiasAtrasoAux, pd_fecha_pag 
              from fsd602
             where pgcod = C.LN_PGCOD
               and ppsuc = c.ln_sucursal
               and ppmod = c.ln_modulo
               and ppmda = c.ln_moneda
               and pppap = c.ln_papel
               and ppcta = c.ln_cuenta
               and ppoper = c.ln_operacion
               and ppsbop = c.ln_subopera
               and pptope = c.ln_tipopera
               and pp1stat = 'T'
               and ppfpag = c.ld_fchcalendario
               and rownum = 1; --HSUAREZ -2018.07.23 - AGREGADO PARA MAS DE UN REGISTRO EN LA FECHA. PAGOS SEGMENTADOS.
          exception
            when no_Data_found then
              ln_DiasAtrasoAux := ld_FchFin - c.ld_fchcalendario;
            
        end;
        --EN CASO QUE EL CLIENTE PAGO ANTICIPADAMENTE se iguala a 0
        if ln_DiasAtrasoAux<0 then
          ln_DiasAtrasoAux:=0;
        end if;
        --VERIFICAR_SI_LA FECHA DE PAGO ES DIA HABIL.
        BEGIN
             select a.fhabil
               into flag_habil
               from fst028 a, fst001 b
              where a.calcod = b.calcod
                and a.ffecha = c.ld_fchcalendario
                and b.sucurs = c.ln_sucursal;
         END;
         if flag_habil='N' then
           BEGIN
                select min(a.ffecha)
                  into vi_fecha_habil
                  from fst028 a, fst001 b
                 where a.calcod = b.calcod
                   and a.ffecha > c.ld_fchcalendario
                   and b.sucurs = c.ln_sucursal
                   and a.fhabil = 'S';
               
            END;
            begin
                   vi_regula:=vi_fecha_habil - c.ld_fchcalendario;
                   ln_DiasAtrasoAux := ln_DiasAtrasoAux - vi_regula;
              end;
          End if;
        --FIN CASO.  
        pd_fecha_pag2:= pd_fecha_pag; 
        
        IF (TO_DATE(pd_fecha_pag2,'DD/MM/YYYY')) >= (TO_DATE(aux2,'DD/MM/YYYY')) then

          ln_DiasAtraso := ln_DiasAtraso + ln_DiasAtrasoAux;
          --ln_DiasAtrasoAux := ln_DiasAtrasoAux;
          
           IF (TO_DATE(pd_fecha_pag2,'DD/MM/YYYY')) = (TO_DATE(aux2,'DD/MM/YYYY')) then
             ln_DiasAtrasoAux := 0;             
           end if;
           
            aux2:= pd_fecha_pag2;        
           
        else
          
          ln_DiasAtrasoAux := 0;--ln_DiasAtraso + ln_DiasAtrasoAux;
          
        end if;
        
        ln_DiasAtraso := ln_DiasAtraso + ln_DiasAtrasoAux;
      
    end loop;
    
    --ln_DiasAtraso := ln_DiasAtraso + ln_atraso_cuotp;
    
    if ln_NroCuotCalend <> 0  then
      
      ln_PromdAtraso :=(ln_DiasAtraso /ln_NroCuotCalend);      --ln_DiasAtraso -- HSUAREZ COMENTADO Y PUESTO EN FIJO 6 ya que solo se evalua los ultimos 6 meses.
    --ln_PromdAtraso := nvl(ln_DiasAtraso, 0) / nvl(ln_NroCuotCalend, 0);
    
    end if;
    
    if ln_PromdAtraso < 0 then
      ln_PromdAtraso := 0;
    end if;

    
  --  ln_DiasAtrasoAux2:=ln_DiasAtrasoAux;
   
 --   if ln_DiasAtrasoAux2 >= aux THEN
      ---      aux:= ln_DiasAtrasoAux2;
--    END IF;
    
   -- end loop;
    
    ---ln_AtrasoMax:=aux;
       
   end if;
 -------------------------------------------------------------------------------------------------------------------------
  
    
if pn_estado <> 99  then --- se agrego rmogrovejo-------
  ---    
        
    for ddd in  calendarios(ld_FchIni,ld_Fchfin)  loop
    
      ln_DiasAtrasoAux := 0;
    
      begin
        select (pp1fech - ppfpag)
          into ln_DiasAtrasoAux
          from fsd602
         where pgcod = ddd.LN_PGCOD
           and ppsuc = ddd.ln_sucursal
           and ppmod = ddd.ln_modulo
           and ppmda = ddd.ln_moneda
           and pppap = ddd.ln_papel
           and ppcta = ddd.ln_cuenta
           and ppoper = ddd.ln_operacion
           and ppsbop = ddd.ln_subopera
           and pptope = ddd.ln_tipopera
           and pp1stat = 'T'
           and ppfpag = ddd.ld_fchcalendario
           and rownum = 1; --HSUAREZ -2018.07.23 - AGREGADO PARA MAS DE UN REGISTRO EN LA FECHA. PAGOS SEGMENTADOS.
      exception
        when no_Data_found then
          ln_DiasAtrasoAux := ld_FchFin - ddd.ld_fchcalendario;
        
      end;
      --VERIFICAR_SI_LA FECHA DE PAGO ES DIA HABIL.
        BEGIN
             select a.fhabil
               into flag_habil
               from fst028 a, fst001 b
              where a.calcod = b.calcod
                and a.ffecha = ddd.ld_fchcalendario
                and b.sucurs = ddd.ln_sucursal;
         END;
         if flag_habil='N' then
           BEGIN
                select min(a.ffecha)
                  into vi_fecha_habil
                  from fst028 a, fst001 b
                 where a.calcod = b.calcod
                   and a.ffecha > ddd.ld_fchcalendario
                   and b.sucurs = ddd.ln_sucursal
                   and a.fhabil = 'S';
               
            END;
            begin
                   vi_regula:=vi_fecha_habil - ddd.ld_fchcalendario;
                   ln_DiasAtrasoAux := ln_DiasAtrasoAux - vi_regula;
              end;
         End if;
      --EN CASO QUE EL CLIENTE PAGO ANTICIPADAMENTE se iguala a 0
        if ln_DiasAtrasoAux<0 then
          ln_DiasAtrasoAux:=0;
        end if;
        --FIN CASO. 
        
      ln_DiasAtraso := ln_DiasAtraso + ln_DiasAtrasoAux;
      
    end loop;
    
    --ln_DiasAtraso := ln_DiasAtraso + ln_DiasAtrasoAux; COMENTADO ESTA REPITIENDO DEFINIDO YA EN 1031
    --ln_DiasAtraso := ln_DiasAtraso + ln_atraso_cuotp; COMENTADO NO SE UTILIZA ESTO. 
    
    if ln_NroCuotCalend <> 0  then
          ln_PromdAtraso := nvl(ln_DiasAtraso, 0) / nvl(6/*ln_NroCuotCalend*/, 0); --comentado son los ultimos 6 meses, por tanto se divide.
    
    end if;
    
    if ln_PromdAtraso < 0 then
      ln_PromdAtraso := 0;
    end if;
    
 end if;
 
  end sp_cr_PromAtras6meses;
  --------------------------------------------------------------
  procedure sp_cr_TipoGarantia(ln_Instancia in number,
                               lc_Garantia  out varchar2) is
  
    cursor lista_Garantia is
    
      select distinct (to_char(sng122tope)) lc_GarantiaAux
        from sng122
       where sng122pgc = 1
         and sng122inst = ln_Instancia
         and sng122mod = 70;
  
  begin
  
    for l in lista_Garantia loop
    
      lc_Garantia := lc_Garantia || ',' || l.lc_garantiaaux;
    
    end loop;
  
  end sp_cr_TipoGarantia;
  ------------------------------------------------------------  
  procedure sp_cr_InsertJAQZ841(ln_JAQZ841INST    NUMBER,
                                ln_jaqz841instv   number, --HSUAREZ 22.05.2018 - Instancias del Credito vinculado
                                ln_JAQZ841FCH     DATE,
                                ln_JAQZ841HORA    CHAR,
                                ln_JAQZ841USER    CHAR,
                                ln_JAQZ841IND     VARCHAR2,
                                ln_JAQZ841EST     VARCHAR2,
                                ln_JAQZ841CTA     NUMBER,
                                ln_JAQZ841OPER    NUMBER,
                                ln_JAQZ841MOD     NUMBER,
                                ln_JAQZ841MNTCRED NUMBER,
                                ln_JAQZ841SLDCAP  NUMBER,
                                ln_JAQZ841MNTCUO  NUMBER,
                                ln_JAQZ841NROCUOT NUMBER,
                                ln_JAQZ841NROCUOP NUMBER,
                                ln_JAQZ841FCHDES  DATE,
                                ln_JAQZ841ATRMAX  NUMBER,
                                ln_JAQZ841PROMATR NUMBER,
                                ln_JAQZ841TASA    NUMBER,
                                ln_JAQZ841TIPGAR  VARCHAR2) is
  
    ln_corr  number;
    lc_cpxct varchar2(15);
  
  begin

    begin
      select max(jaqz841corr)
        into ln_corr
        from jaqz841
       where jaqz841inst = ln_JAQZ841INST
         and jaqz841fch = ln_JAQZ841FCH;
    exception
      when others then
        null;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    BEGIN
      lc_cpxct := to_char(ln_JAQZ841NROCUOP) || '/' ||
                  to_char(ln_JAQZ841NROCUOT);
    END;
  
    begin
    
      insert into jaqz841
        (jaqz841corr,
         jaqz841inst,
         jaqz841instv, --HSUAREZ 22.05.2018 - Instancias del Credito vinculado
         jaqz841fch,
         jaqz841hora,
         jaqz841user,
         jaqz841ind,
         jaqz841est,
         jaqz841cta,
         jaqz841oper,
         jaqz841mod,
         jaqz841mntcred,
         jaqz841sldcap,
         jaqz841mntcuo,
         jaqz841nrocuot,
         jaqz841nrocuop,
         jaqz841fchdes,
         jaqz841atrmax,
         jaqz841promatr,
         jaqz841tasa,
         JAQZ841AUXV1,
         JAQZ841AUXV2)
      values
        (ln_corr + 1,
         ln_JAQZ841INST,
         ln_jaqz841instv, -- HSUAREZ 22.05.2018 - INSTANCIA VINCULADA.
         ln_JAQZ841FCH,
         ln_JAQZ841HORA,
         ln_JAQZ841USER,
         ln_JAQZ841IND,
         ln_JAQZ841EST,
         ln_JAQZ841CTA,
         ln_JAQZ841OPER,
         ln_JAQZ841MOD,
         ln_JAQZ841MNTCRED,
         ln_JAQZ841SLDCAP,
         ln_JAQZ841MNTCUO,
         ln_JAQZ841NROCUOT,
         ln_JAQZ841NROCUOP,
         ln_JAQZ841FCHDES,
         ln_JAQZ841ATRMAX,
         ln_JAQZ841PROMATR,
         ln_JAQZ841TASA,
         ln_JAQZ841TIPGAR,
         lc_cpxct);
    
      commit;
    
    end;
  
  end sp_cr_InsertJAQZ841;
  ------------------------------------------------------------
  procedure sp_relacion_cred(pn_pais in fsr008.pepais%type,
														 pn_tdoc in fsr008.petdoc%type,
														 pn_ndoc in varchar,
														 pd_fecp in date,
														 pd_flag out varchar) is

		cursor cuentas(ln_pais number, ln_tdoc number, ln_ndoc char) is
			select ctnro
				from fsr008 f
			 where f.pepais = ln_pais
				 and f.petdoc = ln_tdoc
				 and f.pendoc = ln_ndoc
				 and f.cttfir = 'T';
	  cursor fsd010(ln_ctnro number,ld_fecini date) is
	       select *
				 from fsd010 d
				 where d.pgcod=1
				 and   d.aocta=ln_ctnro
				 and   d.aomod in (select modulo
														 from fst111
														where dscod = 50
															and modulo not in (108))
				 and (aofe99 >= ld_fecini or aofe99 = to_date('0001.01.01','yyyy.mm.dd'));
				 --and   d.aostat<>99;
				 
		ln_inactivo  number(10);
		ln_rel_crd   number(10);
		ln_mes_acum  number(10);
		ld_fecini    date;
		ln_fec_inc   date;
		ln_fec_val   date;
		ln_fec_can   date;
		ln_empresa   xwf700.xwfempresa%type;
		ln_sucursal  xwf700.xwfsucursal%type;
		ln_modulo    xwf700.xwfmodulo%type;
		ln_moneda    xwf700.xwfmoneda%type;
		ln_papel     xwf700.xwfpapel%type;
		ln_cuenta    xwf700.xwfcuenta%type;
		ln_operacion xwf700.xwfoperacion%type;
		ln_subope    xwf700.xwfsubope%type;
		ln_tipope    xwf700.xwftipope%type;
		ln_mes_lv  number(10,2);
    ln_mes_max number(10,2);
		ln_est_can   number(10);
		err_num      number;
		temp         date;
		err_msg      varchar(250);
	
	begin
		-- Obtener periodo de inactividad del cliente con la caja.
		begin
		-- Desde la fecha de consulta.
		select tp1nro1
			into ln_inactivo
			from fst198
		 where tp1cod   = 1
			 and tp1cod1  = 11119
			 and tp1corr1 = 11
			 and tp1corr2 = 2
			 and tp1corr3 = 1;
	  exception
			when others then
				ln_inactivo:=0;
		end;
		begin
		-- Obtener periodo de relacion crediticia minima
		select tp1nro1
			into ln_rel_crd
			from fst198
		 where tp1cod = 1
			 and tp1cod1 = 11119
			 and tp1corr1 = 11
			 and tp1corr2 = 1
			 and tp1corr3 = 1;
	 exception
			when others then
				ln_rel_crd:=0;
		end;
		--Obtener la fecha limite segun guia de proceso.
		ld_fecini:=add_months(pd_fecp,-ln_inactivo);
		--inicializo variables,
	  pd_flag := 'N';
		ln_mes_acum:=0;
		ln_mes_lv :=0;
    ln_mes_max:=0;
		--for x in modulo_toperacion loop                             
		for x in cuentas(pn_pais, pn_tdoc, pn_ndoc) loop
			--Obtengo clave del credito a traves de la cuenta obtenida del cursor cuentas y de los modulos.
			for y in fsd010(x.ctnro,ld_fecini) loop
			    if /*y.aofe99=to_date('0001.01.01','yyyy.mm.dd') and*/ y.aostat<>99 then
							begin
								select trunc((months_between(pd_fecp, d10.aofval)))+1
								into ln_mes_lv
								from fsd010 d10 
								where d10.pgcod  = 1
									and d10.aomod  = y.aomod
									and d10.aosuc  = y.aosuc
									and d10.aomda  = y.aomda
									and d10.aopap  = y.aopap
									and d10.aocta  = y.aocta
									and d10.aooper = y.aooper  
									and d10.aosbop = y.aosbop
									and d10.aotope = y.aotope
									and d10.aostat <> 99;
							exception
								when others then
										ln_mes_lv:=0;
						  end;
					else
								begin
								  --select trunc((months_between(d10.aofe99,d10.aofval)))+1
									select d10.aofval,d10.aofe99
									into ln_fec_val,ln_fec_can
									from fsd010 d10 
									where d10.pgcod  = 1
										and d10.aomod  = y.aomod
										and d10.aosuc  = y.aosuc
										and d10.aomda  = y.aomda
										and d10.aopap  = y.aopap
										and d10.aocta  = y.aocta
										and d10.aooper = y.aooper  
										and d10.aosbop = y.aosbop
										and d10.aotope = y.aotope
										and d10.aostat = 99;
								exception
									when others then
											ln_mes_lv:=0;
								end;
								
								if ln_fec_val>=ld_fecini then
								   ln_mes_lv:= months_between(ln_fec_can, ln_fec_val);
								else
								   if ln_fec_val<ld_fecini then
								      ln_mes_lv:= months_between(ln_fec_can, ld_fecini);
									 end if;
								end if;
								
					end if;
          
					--si la diferencia es menor que 0 se iguala a 0.
					if ln_mes_lv<0 then
					   ln_mes_lv :=0;
					end if;
          --obtenemos el que tenga mas meses. 
          if ln_mes_lv>ln_mes_max then
             ln_mes_max := ln_mes_lv;
          end if;
          --verificamos si tiene la relacion crediticia minima si cumple retorna S caso contrario N
          if ln_mes_max >= ln_rel_crd then
            pd_flag := 'S';
            return;
          else
            pd_flag := 'N';
          end if;
			    /*
          --verificamos la condicion si ya fue cancelado o no. para aplicar.
          ln_mes_acum := ln_mes_acum + ln_mes_lv;
          if (ln_mes_acum) >= ln_rel_crd then
            pd_flag := 'S';
            return;
          else
            pd_flag := 'N';
          end if;
          */
		  end loop;
		end loop;
	end sp_relacion_cred;
  ------------------------------------------------------------
end PQ_CR_CAMBIOTASA;
/

