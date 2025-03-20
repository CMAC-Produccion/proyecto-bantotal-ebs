create or replace package PQ_CR_MANTIENE_EVAL is

  -- Author  : MPOSTIGOC
  -- Created : 31/07/2019 3:47:13 p. m.
  -- Purpose : 
  -- Fecha de Modificación      : 10/12/2024
  -- Autor de la Modificación   :  Maria Postigo
  -- Descripción de Modificación: Se ordeno la fecha desembolsos  
  -----------------------------------------------------------------------------------------------------------------------------
  -- Public type declarations

  procedure sp_cr_inicio(ln_Instancia  in number,
                         saldo_externo out number,
                         ln_NroSolCred out number,
                         ln_NroEval    out number);
  ----------------------------------------------------------    

  procedure sp_cr_verifPSD(ln_Instancia    in number,
                           lc_TieneInfoPSD out varchar2);
  ---------------------------------------------------------                           
  procedure sp_cr_verifEval(ln_Instancia in number,
                            lc_VerfEval  out varchar2);
  ----------------------------------------------------------                            
  procedure sp_Cr_VerfUltEvaluacion(ln_Instancia  in number,
                                    ln_NroSolCred out number,
                                    ln_NroEval    out number);
  ----------------------------------------------------------------
  procedure sp_Cr_DeudaIFIS_ME(ln_Instancia in number,
                               ln_deudaIFIS out number);

end PQ_CR_MANTIENE_EVAL;
/

create or replace package body PQ_CR_MANTIENE_EVAL is

  procedure sp_cr_inicio(ln_Instancia  in number,
                         saldo_externo out number,
                         ln_NroSolCred out number,
                         ln_NroEval    out number) is
  
    lc_TieneInfoPSD varchar2(2) := 'S';
    lc_VerfEval     varchar2(2) := 'S';
  
  begin
  
    pq_Cr_mantiene_eval.sp_cr_verifPSD(ln_Instancia, lc_TieneInfoPSD);
    pq_cr_mantiene_eval.sp_cr_verifEval(ln_Instancia, lc_VerfEval);
  
    if lc_TieneInfoPSD = 'N' and lc_VerfEval = 'S' then
      PQ_Cr_mantiene_eval.sp_Cr_VerfUltEvaluacion(ln_Instancia,
                                                  ln_NroSolCred,
                                                  ln_NroEval);
    
      if ln_NroSolCred > 0 and ln_NroEval > 0 then
        pq_cr_mantiene_eval.sp_Cr_DeudaIFIS_ME(ln_Instancia => ln_NroSolCred,
                                               ln_deudaIFIS => saldo_externo);
      
      end if;
    
      --  saldo_externo := nvl(saldo_externo, 0);
    end if;
  
    ln_NroSolCred := nvl(ln_NroSolCred, 0);
    saldo_externo := nvl(saldo_externo, 0); --MPOSTIGOC 16/08/2019
  
  end sp_cr_inicio;
  --------------------------------------------------------------------------- 

  procedure sp_cr_verifPSD(ln_Instancia    in number,
                           lc_TieneInfoPSD out varchar2) is
  
    ln_TipoSoli  number := 0;
    ln_NroRegPSD number := 0;
  
  begin
  
    lc_TieneInfoPSD := 'S';
  
    begin
      select s.sng021tmod
        into ln_TipoSoli
        from sng021 s
       where s.sng021sol = ln_Instancia;
    exception
      when others then
        ln_TipoSoli := 0;
    end;
  
    if ln_TipoSoli = 13 then
    
      begin
        select count(*)
          into ln_NroRegPSD
          from jaqy327 j
         where j.jaqy327inst = ln_Instancia
           and j.jaqy327esta = 'S';
      exception
        when others then
          ln_NroRegPSD := 0;
      end;
    
      if ln_NroRegPSD > 0 then
        lc_TieneInfoPSD := 'S';
      else
        lc_TieneInfoPSD := 'N';
      end if;
    
    end if;
  
  end sp_cr_verifPSD;
  --------------------------------------------------------
  procedure sp_cr_verifEval(ln_Instancia in number,
                            lc_VerfEval  out varchar2) is
  
    ld_fchevalAux date;
    ld_FchIniSoli date;
  begin
    begin
      select SNG120FPag
        into ld_fchevalAux
        from sng120 s
       where s.sng120ins = ln_Instancia
         and s.sng120tsk = 'EVALUACION';
    exception
      when others then
        null;
    end;
  
    begin
      select s.sng001fin
        into ld_FchIniSoli
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    if ld_fchevalAux is not null and ld_FchIniSoli is not null then
    
      if ld_fchevalAux < ld_FchIniSoli then
        lc_VerfEval := 'S';
      else
        lc_VerfEval := 'N';
      end if;
    end if;
  
  end sp_cr_verifEval;
  ---------------------------------------------------
  procedure sp_Cr_VerfUltEvaluacion(ln_Instancia  in number,
                                    ln_NroSolCred out number,
                                    ln_NroEval    out number) is
  
    cursor lista_creditos(ln_pais number, ln_tdoc number, lc_ndoc varchar2) is
    
      select g.pgcod  ln_pgcod,
             g.aomod  ln_mod,
             g.aosuc  ln_suc,
             g.aomda  ln_mda,
             g.aopap  ln_pap,
             g.aocta  ln_cta,
             g.aooper ln_oper,
             g.aosbop ln_sbop,
             g.aotope ln_tope
        from fsd010 g
       where g.pgcod = 1
         and g.aomda in (0, 101)
         and g.aopap = 0
         and g.aocta in (select f.ctnro
                           from fsr008 f
                          where f.pepais = ln_pais
                            and f.petdoc = ln_tdoc
                            and f.pendoc = lc_ndoc
                            and f.cttfir = 'T')
         and (aomod in (select modulo
                          from fst111
                         where dscod = 50
                           and modulo not in (108, 116)
                            or aomod in (117, 141)))
       order by g.aofval desc;
  
    cursor lista_Inst_MismaEval(ld_FchEval  date,
                                ln_pdoc     number,
                                ln_tdoc     number,
                                lc_ndoc     varchar2,
                                ln_InstCred number) is
    
      select s.sng120ins ln_OtraInst
        from sng120 s
       where s.sng120fpag = ld_FchEval
         and s.sng120ins in (select d.sng001inst
                               from sng001 d
                              where d.sng001pais = ln_pdoc
                                and d.sng001tdoc = ln_tdoc
                                and d.sng001ndoc = lc_ndoc)
         and s.sng120tsk = 'EVALUACION'
         and s.sng120ins <> ln_InstCred
       order by s.sng120ins desc;
  
    ln_pais            number;
    ln_tdoc            number;
    lc_ndoc            varchar2(12);
    ln_NroSolCredAux   number;
    ld_FchEvalAux      date := null;
    ld_FchEval         date;
    ln_NroEvalAux      number;
    ln_ResulNetoSol    number;
    ln_ResulNetoDol    number;
    ln_NroEvalProceso  number;
    ln_tipocambio      number;
    ln_ResulNetoOld    number;
    ln_ResulNetoSolNew number;
    ln_ResulNetoDolNew number;
    ln_ResulNetoNew    number;
    ln_NroDataPSD      number := 0;
  
  begin
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    ln_NroEval := 0;
  
    for l in lista_creditos(ln_pais, ln_tdoc, lc_ndoc) loop
    
      begin
        ln_NroSolCredAux := fn_instancia_credito(v_Scmod  => l.ln_mod,
                                                 v_Scsuc  => l.ln_suc,
                                                 v_Scmda  => l.ln_mda,
                                                 v_Scpap  => l.ln_pap,
                                                 v_Sccta  => l.ln_cta,
                                                 v_Scoper => l.ln_oper,
                                                 v_Scsbop => l.ln_sbop,
                                                 v_Sctope => l.ln_tope);
      end;
    
      begin
        select s.sng021eval
          into ln_NroEvalAux
          from sng021 s
         where s.sng021sol = ln_NroSolCredAux
           and s.sng021tmod = 13;
      exception
        when others then
          ln_NroEvalAux := 0;
      end;
    
      if ln_NroEvalAux > 0 then
      
        begin
          select s.sng120fpag
            into ld_FchEvalAux
            from sng120 s
           where s.sng120ins = ln_NroSolCredAux
             and s.sng120tsk = 'EVALUACION';
        exception
          -- mpostigoc 13.05.2020
          when others then
            null;
        end;
      
        if ld_FchEval < ld_FchEvalAux then
          ld_FchEval    := ld_FchEvalAux;
          ln_NroEval    := ln_NroEvalAux;
          ln_NroSolCred := ln_NroSolCredAux;
        else
          if ld_FchEval = ld_FchEvalAux then
            if ln_NroEval < ln_NroEvalAux then
              ln_NroEval    := ln_NroEvalAux;
              ln_NroSolCred := ln_NroSolCredAux;
            end if;
          end if;
        end if;
      
        if ld_FchEval is null then
          ld_FchEval    := ld_FchEvalAux;
          ln_NroEval    := ln_NroEvalAux;
          ln_NroSolCred := ln_NroSolCredAux;
        
        end if;
      end if;
    
    end loop;
  
    begin
      select count(*)
        into ln_NroDataPSD
        from jaqy327 j
       where j.jaqy327inst = ln_NroSolCred
         and j.jaqy327esta = 'S';
    exception
      when others then
        ln_NroDataPSD := 0;
    end;
  
    if ln_NroDataPSD > 0 then
    
      begin
        --Resultado Neto de la Solicitud que se copiara evaluacion
        begin
        
          begin
            select s. sng120tcbi
              into ln_tipocambio
              from sng120 s
             where s.sng120ins = ln_NroSolCred
               and s.sng120tsk = 'EVALUACION';
          exception
            when others then
              ln_tipocambio := 0;
          end;
        
        end;
      
        begin
          select s.sng023mto
            into ln_ResulNetoSol
            from sng023 s
           where s.sng021eval = ln_NroEval
             and s.sng026cod = 40;
        exception
          when others then
            ln_ResulNetoSol := 0;
        end;
        begin
          select s.sng023mto
            into ln_ResulNetoDol
            from sng023 s
           where s.sng021eval = ln_NroEval
             and s.sng026cod = 540;
        exception
          when others then
            ln_ResulNetoDol := 0;
        end;
      
        ln_ResulNetoDol := ln_ResulNetoDol * ln_tipocambio;
      
        ln_ResulNetoOld := nvl(ln_ResulNetoSol, 0) +
                           nvl(ln_ResulNetoDol, 0);
      
      end;
    
      begin
        --Resultado Neto de la Solicitud en proceso
      
        begin
          select s. sng120tcbi
            into ln_tipocambio
            from sng120 s
           where s.sng120ins = ln_Instancia
             and s.sng120tsk = 'EVALUACION';
        exception
          when others then
            ln_tipocambio := 0;
        end;
      
        begin
          select s.sng021eval
            into ln_NroEvalProceso
            from sng021 s
           where s.sng021sol = ln_Instancia;
        exception
          when others then
            ln_NroEvalProceso := 0;
        end;
      
        begin
          select s.sng023mto
            into ln_ResulNetoSolNew
            from sng023 s
           where s.sng021eval = ln_NroEvalProceso
             and s.sng026cod = 40;
        exception
          when others then
            ln_ResulNetoSolNew := 0;
        end;
        begin
          select s.sng023mto
            into ln_ResulNetoDolNew
            from sng023 s
           where s.sng021eval = ln_NroEvalProceso
             and s.sng026cod = 540;
        exception
          when others then
            ln_ResulNetoDolNew := 0;
        end;
      
        ln_ResulNetoDolNew := ln_ResulNetoDolNew * ln_tipocambio;
      
        ln_ResulNetoNew := nvl(ln_ResulNetoSolNew, 0) +
                           nvl(ln_ResulNetoDolNew, 0);
      end;
    
      if ln_ResulNetoNew <> ln_ResulNetoOld then
        ln_NroEval    := 0;
        ln_NroSolCred := 0;
      
      end if;
    
    else
      if ln_NroDataPSD = 0 then
      
        for o in lista_Inst_MismaEval(ld_FchEval, ln_pais, ln_tdoc, lc_ndoc, ln_NroSolCred) loop
        
          begin
            select count(*)
              into ln_NroDataPSD
              from jaqy327 j
             where j.jaqy327inst = o.ln_otrainst
               and j.jaqy327esta = 'S';
          exception
            when others then
              ln_NroDataPSD := 0;
          end;
        
          if ln_NroDataPSD > 0 then
            ln_NroSolCred := o.ln_otrainst;
            exit;
          end if;
        
        end loop;
      
        if ln_NroDataPSD > 0 then
          begin
            --Resultado Neto de la Solicitud que se copiara evaluacion
            begin
            
              begin
                select s. sng120tcbi
                  into ln_tipocambio
                  from sng120 s
                 where s.sng120ins = ln_NroSolCred
                   and s.sng120tsk = 'EVALUACION';
              exception
                when others then
                  ln_tipocambio := 0;
              end;
            
            end;
          
            begin
              select s.sng021eval
                into ln_NroEval
                from sng021 s
               where s.sng021sol = ln_NroSolCred;
            exception
              when others then
                ln_NroEval := 0;
            end;
          
            begin
              select s.sng023mto
                into ln_ResulNetoSol
                from sng023 s
               where s.sng021eval = ln_NroEval
                 and s.sng026cod = 40;
            exception
              when others then
                ln_ResulNetoSol := 0;
            end;
            begin
              select s.sng023mto
                into ln_ResulNetoDol
                from sng023 s
               where s.sng021eval = ln_NroEval
                 and s.sng026cod = 540;
            exception
              when others then
                ln_ResulNetoDol := 0;
            end;
          
            ln_ResulNetoDol := ln_ResulNetoDol * ln_tipocambio;
          
            ln_ResulNetoOld := nvl(ln_ResulNetoSol, 0) +
                               nvl(ln_ResulNetoDol, 0);
          
          end;
        
          begin
            --Resultado Neto de la Solicitud en proceso
          
            begin
              select s. sng120tcbi
                into ln_tipocambio
                from sng120 s
               where s.sng120ins = ln_Instancia
                 and s.sng120tsk = 'EVALUACION';
            exception
              when others then
                ln_tipocambio := 0;
            end;
          
            begin
              select s.sng021eval
                into ln_NroEvalProceso
                from sng021 s
               where s.sng021sol = ln_Instancia;
            exception
              when others then
                ln_NroEvalProceso := 0;
            end;
          
            begin
              select s.sng023mto
                into ln_ResulNetoSolNew
                from sng023 s
               where s.sng021eval = ln_NroEvalProceso
                 and s.sng026cod = 40;
            exception
              when others then
                ln_ResulNetoSolNew := 0;
            end;
            begin
              select s.sng023mto
                into ln_ResulNetoDolNew
                from sng023 s
               where s.sng021eval = ln_NroEvalProceso
                 and s.sng026cod = 540;
            exception
              when others then
                ln_ResulNetoDolNew := 0;
            end;
          
            ln_ResulNetoDolNew := ln_ResulNetoDolNew * ln_tipocambio;
          
            ln_ResulNetoNew := nvl(ln_ResulNetoSolNew, 0) +
                               nvl(ln_ResulNetoDolNew, 0);
          end;
        
          if ln_ResulNetoNew <> ln_ResulNetoOld then
            ln_NroEval    := 0;
            ln_NroSolCred := 0;
          
          end if;
        
        end if;
      
      end if;
    end if;
  
  end sp_Cr_VerfUltEvaluacion;
  --------------------------------------------------------  
  procedure sp_Cr_DeudaIFIS_ME(ln_Instancia in number,
                               ln_deudaIFIS out number) is
  
    saldo_extDol   number := 0;
    saldo_extSoles number := 0;
    ln_tipocambio  number(14, 8);
  
  begin
    begin
    
      begin
      
        begin
          select s. sng120tcbi
            into ln_tipocambio
            from sng120 s
           where s.sng120ins = ln_Instancia
             and s.sng120tsk = 'EVALUACION';
        exception
          when others then
            ln_tipocambio := 0;
        end;
      
      end;
    
      begin
        select sum(j.jaqy327gfin)
          into saldo_extSoles
          from jaqy327 j
         where j.jaqy327inst = ln_Instancia
           and j.jaqy327esta = 'S'
           and j.jaqy327chek = '1'
           and j.jaqy327cent <> '00104' -- mpostigoc 29.09.2022
           and j.jaqy327tcre in
               ('Pymes S/.', 'Consumo S/.', 'Hipotecario S/.');
        /* and j.jaqy327aux3 = 'R' -- MPOSTIGOC 04/10/18 INC1373
        and j.jaqy327aux1 = 7; -- Tarea de Evaluacion Propuesta MPOSTIGOC 04/10/18 INC1373*/
      exception
        when others then
          saldo_extSoles := 0;
        
      end;
    
      begin
        begin
          select sum(j.jaqy327gfin)
            into saldo_extDol
            from jaqy327 j
           where j.jaqy327inst = ln_Instancia
             and j.jaqy327esta = 'S'
             and j.jaqy327chek = '1'
             and j.jaqy327cent <> '00104' -- mpostigoc 29.09.2022
             and j.jaqy327tcre in
                 ('Pymes US$', 'Consumo US$', 'Hipotecario US$');
          /*and j.jaqy327aux3 = 'R' -- MPOSTIGOC 04/10/18 INC1373
          and j.jaqy327aux1 = 7; -- Tarea de Evaluacion Propuesta MPOSTIGOC 04/10/18 INC1373;*/
        exception
          when others then
            saldo_extDol := 0;
        end;
      
        saldo_extDol := nvl(saldo_extDol, 0) * ln_tipocambio;
      
      end;
    
      ln_deudaIFIS := nvl(saldo_extDol, 0) + nvl(saldo_extSoles, 0);
    end;
  end sp_Cr_DeudaIFIS_ME;

end PQ_CR_MANTIENE_EVAL;
/

