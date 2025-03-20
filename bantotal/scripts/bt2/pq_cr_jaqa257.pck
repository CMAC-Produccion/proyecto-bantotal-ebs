create or replace package PQ_CR_JAQA257 is

  -- Author  : MPOSTIGOC
  -- Created : 28/06/2020 11:07:28 p. m.
  -- Purpose : Paquete que valida e inserta un evento 3 en la fsd012 para reprogramaciones

  -- Public type declarations
  procedure sp_cr_inicio(lc_digito in varchar2, ld_FchJAQA257 date);
  ---------------------------------------------
  procedure sp_cr_reproceso(ld_FchJAQA257 in date);
  ---------------------------------------------
  procedure sp_cr_bk_fsd012(pn_emp  in number,
                            pn_mod  in number,
                            pn_suc  in number,
                            pn_mda  in number,
                            pn_pap  in number,
                            pn_cta  in number,
                            pn_ope  in number,
                            pn_sbo  in number,
                            pn_top  in number,
                            ld_f257 in date);
  ------------------------------------------------
  procedure sp_cr_up_fsd012(pn_emp  in number,
                            pn_mod  in number,
                            pn_suc  in number,
                            pn_mda  in number,
                            pn_pap  in number,
                            pn_cta  in number,
                            pn_ope  in number,
                            pn_sbo  in number,
                            pn_top  in number,
                            ld_f601 in date,
                            ln_tasa in number,
                            ld_f257 in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_cr_tasa(v_Pgcod  in number,
                       v_Scmod  in number,
                       v_Scsuc  in number,
                       v_Scmda  in number,
                       v_Scpap  in number,
                       v_Sccta  in number,
                       v_Scoper in number,
                       v_Scsbop in number,
                       v_Sctope in number,
                       pn_tasa  out number);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cr_tasa(v_Pgcod  in number,
                      v_Scmod  in number,
                      v_Scsuc  in number,
                      v_Scmda  in number,
                      v_Scpap  in number,
                      v_Sccta  in number,
                      v_Scoper in number,
                      v_Scsbop in number,
                      v_Sctope in number) return number;
  -------------------------------------------------------------------------------
  procedure sp_cr_Jobs_Inicio(ld_FechProc in date);

end PQ_CR_JAQA257;
/

create or replace package body PQ_CR_JAQA257 is

  procedure sp_cr_inicio(lc_digito in varchar2, ld_FchJAQA257 date) is
  
    cursor listado(ln_digito number) is
      select *
        from JAQA257 j
       where j.jaqa257fec = ld_FchJAQA257
         and j.jaqa257est = 'A'
         and j.jaqa257ch2 = 'B'
         and j.jaqa257suc = lc_digito;
  
    ld_MaxFch602 date;
    ld_MinFch601 date;
    ld_MaxEst602 varchar2(5) := 'N';
    ln_digito    number;
  
  begin
  
    ln_digito := to_number(lc_digito);
  
    if ld_FchJAQA257 is not null then
    
      for l in listado(ln_digito) loop
        -- Verificamos la ultima fecha de la fsd602
        begin
          select max(f.ppfpag)
            into ld_MaxFch602
            from fsd602 f
           where f.pgcod = l.jaqa257emp
             and f.ppmod = l.jaqa257mod
             and f.ppsuc = l.jaqa257suc
             and f.ppmda = l.jaqa257mda
             and f.pppap = l.jaqa257pap
             and f.ppcta = l.jaqa257cta
             and f.ppoper = l.jaqa257ope
             and f.ppsbop = l.jaqa257sbo
             and f.pptope = l.jaqa257tpo
             and f.d602co = 'S';
        exception
          when others then
            null;
        end;
      
        if ld_MaxFch602 is not null then
          -- si la fecha no es nula, extraemos el maximo estado de la fsd602
          begin
            select max(f.pp1stat)
              into ld_MaxEst602
              from fsd602 f
             where f.pgcod = l.jaqa257emp
               and f.ppmod = l.jaqa257mod
               and f.ppsuc = l.jaqa257suc
               and f.ppmda = l.jaqa257mda
               and f.pppap = l.jaqa257pap
               and f.ppcta = l.jaqa257cta
               and f.ppoper = l.jaqa257ope
               and f.ppsbop = l.jaqa257sbo
               and f.pptope = l.jaqa257tpo
               and f.d602co = 'S'
               and f.ppfpag = ld_MaxFch602;
          exception
            when others then
              ld_MaxEst602 := 'N';
          end;
        
        else
          -- si no tiene registro entonces automaticamente el valor es T
          ld_MaxEst602 := 'T';
        end if;
      
        if ld_MaxEst602 = 'T' then
          -- solo se considera todos los creditos cuyo estado sea T
          -- se tiene un historico de lo que se guarda en las tablas BK
          begin
            update aqpa380 a
               set a.aqpa380est = 'I'
             where a.aqpa380cod = l.jaqa257emp
               and a.aqpa380mod = l.jaqa257mod
               and a.aqpa380suc = l.jaqa257suc
               and a.aqpa380mda = l.jaqa257mda
               and a.aqpa380pap = l.jaqa257pap
               and a.aqpa380cta = l.jaqa257cta
               and a.aqpa380oper = l.jaqa257ope
               and a.aqpa380sbop = l.jaqa257sbo
               and a.aqpa380tope = l.jaqa257tpo;
            commit;
          end;
        
          -- procedimeinto del bk
          begin
            pq_cr_jaqa257.sp_cr_bk_fsd012(pn_emp  => l.jaqa257emp,
                                          pn_mod  => l.jaqa257mod,
                                          pn_suc  => l.jaqa257suc,
                                          pn_mda  => l.jaqa257mda,
                                          pn_pap  => l.jaqa257pap,
                                          pn_cta  => l.jaqa257cta,
                                          pn_ope  => l.jaqa257ope,
                                          pn_sbo  => l.jaqa257sbo,
                                          pn_top  => l.jaqa257tpo,
                                          ld_f257 => l.jaqa257fec);
          end;
        
          if ld_MaxFch602 is not null then
            -- si tiene fecha en la fsd602, identificamos la min fecha val de la fds601 a partir de la fch
            -- de la 602
            begin
              select min(f.ppfval)
                into ld_MinFch601
                from fsd601 f
               where f.pgcod = l.jaqa257emp
                 and f.ppmod = l.jaqa257mod
                 and f.ppsuc = l.jaqa257suc
                 and f.ppmda = l.jaqa257mda
                 and f.pppap = l.jaqa257pap
                 and f.ppcta = l.jaqa257cta
                 and f.ppoper = l.jaqa257ope
                 and f.ppsbop = l.jaqa257sbo
                 and f.pptope = l.jaqa257tpo
                 and f.ppfpag > ld_MaxFch602
                 and f.d601co = 'S';
            exception
              when others then
                null;
            end;
          else
            begin
              -- si no tiene fecha de la 602, entonces es un credito que no tiene ningun pago, consdieramos la primera
              -- fecha del calendario
              select min(f.ppfval)
                into ld_MinFch601
                from fsd601 f
               where f.pgcod = l.jaqa257emp
                 and f.ppmod = l.jaqa257mod
                 and f.ppsuc = l.jaqa257suc
                 and f.ppmda = l.jaqa257mda
                 and f.pppap = l.jaqa257pap
                 and f.ppcta = l.jaqa257cta
                 and f.ppoper = l.jaqa257ope
                 and f.ppsbop = l.jaqa257sbo
                 and f.pptope = l.jaqa257tpo
                 and f.d601co = 'S';
            exception
              when others then
                null;
            end;
          end if;
        
          -- Procedimiento que actualiza la fsd012
          begin
            pq_cr_jaqa257.sp_cr_up_fsd012(pn_emp  => l.jaqa257emp,
                                          pn_mod  => l.jaqa257mod,
                                          pn_suc  => l.jaqa257suc,
                                          pn_mda  => l.jaqa257mda,
                                          pn_pap  => l.jaqa257pap,
                                          pn_cta  => l.jaqa257cta,
                                          pn_ope  => l.jaqa257ope,
                                          pn_sbo  => l.jaqa257sbo,
                                          pn_top  => l.jaqa257tpo,
                                          ld_f601 => ld_MinFch601,
                                          ln_tasa => l.jaqa257tas,
                                          ld_f257 => ld_FchJAQA257);
          end;
        
        else
        
          -- si el estado es P, entoces actualizaremos el estado a Z y el campo ch2 a P
          if ld_MaxEst602 = 'P' then
            begin
              update jaqa257 j
                 set j.jaqa257ch2 = 'P', j.jaqa257est = 'Z'
               where j.jaqa257emp = L.JAQA257EMP
                 and j.jaqa257mod = L.JAQA257MOD
                 and j.jaqa257suc = L.JAQA257SUC
                 and j.jaqa257mda = L.JAQA257MDA
                 and j.jaqa257pap = L.JAQA257PAP
                 and j.jaqa257cta = L.JAQA257CTA
                 and j.jaqa257ope = L.JAQA257OPE
                 and j.jaqa257sbo = L.JAQA257SBO
                 and j.jaqa257tpo = L.JAQA257TPO
                 and j.jaqa257fec = L.JAQA257FEC;
            end;
          end if;
        end if;
      end loop;
    
    end if;
  
  end sp_cr_inicio;
  --------------------------------------------------------------------
  procedure sp_cr_reproceso(ld_FchJAQA257 in date) is
  
    cursor listado is
      select *
        from JAQA257 j
       where j.jaqa257fec = ld_FchJAQA257
         and j.jaqa257est = 'A'
         and j.jaqa257ch2 = 'S'
         and j.jaqa257ch3 = 'P';
  
    ln_Cor12 number;
  
  begin
  
    if ld_FchJAQA257 is not null then
    
      for l in listado loop
      
        begin
          begin
            select max(j.jaqa257nu3)
              into ln_Cor12
              from jaqa257 j
             where j.jaqa257emp = l.jaqa257emp
               and j.jaqa257mod = l.jaqa257mod
               and j.jaqa257suc = l.jaqa257suc
               and j.jaqa257mda = l.jaqa257mda
               and j.jaqa257pap = l.jaqa257pap
               and j.jaqa257cta = l.jaqa257cta
               and j.jaqa257ope = l.jaqa257ope
               and j.jaqa257sbo = l.jaqa257sbo
               and j.jaqa257tpo = l.jaqa257tpo
               and j.jaqa257fec = ld_FchJAQA257;
          exception
            when others then
              null;
          end;
        
          if ln_Cor12 >= 0 then
          
            begin
              delete fsd012 f
               where f.pgcod = l.jaqa257emp
                 and f.aomod = l.jaqa257mod
                 and f.aosuc = l.jaqa257suc
                 and f.aomda = l.jaqa257mda
                 and f.aopap = l.jaqa257pap
                 and f.aocta = l.jaqa257cta
                 and f.aooper = l.jaqa257ope
                 and f.aosbop = l.jaqa257sbo
                 and f.aotope = l.jaqa257tpo
                 and f.evcorr = ln_Cor12;
            end;
          end if;
        end;
      
        begin
          update aqpa380 a
             set a.aqpa380est = 'I'
           where a.aqpa380cod = l.jaqa257emp
             and a.aqpa380mod = l.jaqa257mod
             and a.aqpa380suc = l.jaqa257suc
             and a.aqpa380mda = l.jaqa257mda
             and a.aqpa380pap = l.jaqa257pap
             and a.aqpa380cta = l.jaqa257cta
             and a.aqpa380oper = l.jaqa257ope
             and a.aqpa380sbop = l.jaqa257sbo
             and a.aqpa380tope = l.jaqa257tpo;
        end;
      
        begin
          update jaqa257 j
             set j.jaqa257ch2 = 'A', j.jaqa257ch3 = 'R'
           where j.jaqa257emp = l.jaqa257emp
             and j.jaqa257mod = l.jaqa257mod
             and j.jaqa257suc = l.jaqa257suc
             and j.jaqa257mda = l.jaqa257mda
             and j.jaqa257pap = l.jaqa257pap
             and j.jaqa257cta = l.jaqa257cta
             and j.jaqa257ope = l.jaqa257ope
             and j.jaqa257sbo = l.jaqa257sbo
             and j.jaqa257tpo = l.jaqa257tpo
             and j.jaqa257fec = ld_FchJAQA257;
        end;
      
        commit;
      
      end loop;
    end if;
  end sp_cr_reproceso;
  ---------------------------------------------------------------------
  procedure sp_cr_bk_fsd012(pn_emp  in number,
                            pn_mod  in number,
                            pn_suc  in number,
                            pn_mda  in number,
                            pn_pap  in number,
                            pn_cta  in number,
                            pn_ope  in number,
                            pn_sbo  in number,
                            pn_top  in number,
                            ld_f257 in date) is
    cursor reg_fsd012 is
      select /*+index(f FSD01204)*/
       f.*
        from fsd012 f
       where f.pgcod = pn_emp
         and f.aomod = pn_mod
         and f.aosuc = pn_suc
         and f.aomda = pn_mda
         and f.aopap = pn_pap
         and f.aocta = pn_cta
         and f.aooper = pn_ope
         and f.aosbop = pn_sbo
         and f.aotope = pn_top
         and f.d012co = 'S';
  
    ld_fchsist date;
    lc_hora    char(8) := '00:00:00';
    ln_corre   number := 0;
  
  begin
  
    begin
      select f.pgfape into ld_fchsist from fst017 f where f.pgcod = 1;
    end;
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    for f in reg_fsd012 loop
    
      begin
        select max(a.aqpa380corre)
          into ln_corre
          from aqpa380 a
         where a.aqpa380fech = ld_fchsist
           and a.aqpa380mod = pn_mod
           and a.aqpa380cta = pn_cta
           and a.aqpa380oper = pn_ope
           and a.aqpa380est = 'H';
      end;
    
      ln_corre := nvl(ln_corre, 0);
    
      begin
        insert into AQPA380
          (AQPA380CORRE,
           AQPA380FECH,
           AQPA380HORA,
           AQPA380f257,
           AQPA380COD,
           AQPA380MOD,
           AQPA380SUC,
           AQPA380MDA,
           AQPA380PAP,
           AQPA380CTA,
           AQPA380OPER,
           AQPA380SBOP,
           AQPA380TOPE,
           AQPA380CORR,
           AQPA380TIPO,
           AQPA380FVAL,
           AQPA380FVTO,
           AQPA380IMP,
           AQPA380TTAS,
           AQPA380TASA,
           AQPA380CAP,
           AQPA380INT,
           AQPA380MOR,
           AQPA380SCAP,
           AQPA380SINT,
           AQPA380SMOR,
           AQPA380INTC,
           AQPA380MORC,
           AQPA380CD01,
           AQPA380CD02,
           AQPA380INV,
           AQPA380PER,
           AQPA380TCBI,
           AQPA380TCBI1,
           AQPA380ARB,
           AQPA380ARB1,
           AQPA380MD,
           AQPA380MD1,
           AQPA380PRE,
           AQPA380PRE1,
           AQPA38012CD,
           AQPA38012MO,
           AQPA38012SU,
           AQPA38012TR,
           AQPA38012RE,
           AQPA38012FC,
           AQPA38012OR,
           AQPA38012SB,
           AQPA38012CO,
           aqpa380est)
        values
          (ln_corre + 1,
           ld_fchsist,
           lc_hora,
           ld_f257,
           f.pgcod,
           f.aomod,
           f.aosuc,
           f.aomda,
           f.aopap,
           f.aocta,
           f.aooper,
           f.aosbop,
           f.aotope,
           f.evcorr,
           f.evtipo,
           f.evfval,
           f.evfvto,
           f.evimp,
           f.evttas,
           f.evtasa,
           f.evcap,
           f.evint,
           f.evmor,
           f.evscap,
           f.evsint,
           f.evsmor,
           f.evintc,
           f.evmorc,
           f.evcd01,
           f.evcd02,
           f.evinv,
           f.evper,
           f.evtcbi,
           f.evtcbi1,
           f.evarb,
           f.evarb1,
           f.evmd,
           f.evmd1,
           f.evpre,
           f.evpre1,
           f.d012cd,
           f.d012mo,
           f.d012su,
           f.d012tr,
           f.d012re,
           f.d012fc,
           f.d012or,
           f.d012sb,
           f.d012co,
           'H');
        commit;
      
      end;
    
    end loop;
  end sp_cr_bk_fsd012;
  ------------------------------------------------------------
  procedure sp_cr_up_fsd012(pn_emp  in number,
                            pn_mod  in number,
                            pn_suc  in number,
                            pn_mda  in number,
                            pn_pap  in number,
                            pn_cta  in number,
                            pn_ope  in number,
                            pn_sbo  in number,
                            pn_top  in number,
                            ld_f601 in date,
                            ln_tasa in number,
                            ld_f257 in date) is
  
    ln_cor012   number := 0;
    ln_InsrtReg number := 0;
  
  begin
  
    begin
      select /*+index(F FSD01204)*/
       max(f.evcorr)
        into ln_cor012
        from fsd012 f
       where f.pgcod = pn_emp
         and f.aomod = pn_mod
         and f.aosuc = pn_suc
         and f.aomda = pn_mda
         and f.aopap = pn_pap
         and f.aocta = pn_cta
         and f.aooper = pn_ope
         and f.aosbop = pn_sbo
         and f.aotope = pn_top
         and f.d012co = 'S';
    end;
  
    ln_cor012 := nvl(ln_cor012, 0);
  
    begin
    
      begin
        insert into fsd012
          (pgcod,
           aomod,
           aosuc,
           aomda,
           aopap,
           aocta,
           aooper,
           aosbop,
           aotope,
           evcorr,
           evtipo,
           evfval,
           evfvto,
           evimp,
           evttas,
           evtasa,
           evcap,
           evint,
           evmor,
           evscap,
           evsint,
           evsmor,
           evintc,
           evmorc,
           evcd01,
           evcd02,
           evinv,
           evper,
           evtcbi,
           evtcbi1,
           evarb,
           evarb1,
           evmd,
           evmd1,
           evpre,
           evpre1,
           d012cd,
           d012mo,
           d012su,
           d012tr,
           d012re,
           d012fc,
           d012or,
           d012sb,
           d012co)
        
        values
          (pn_emp,
           pn_mod,
           pn_suc,
           pn_mda,
           pn_pap,
           pn_cta,
           pn_ope,
           pn_sbo,
           pn_top,
           ln_cor012 + 1,
           3,
           ld_f601,
           '1/01/0001',
           0.00,
           1,
           ln_tasa,
           0.00,
           0.00,
           0.00,
           0.00,
           0.00,
           0.00,
           0.00,
           0.00,
           0,
           null,
           0,
           0,
           0.00000000,
           0.00000000,
           0.00000000,
           0.00000000,
           null,
           null,
           0.00000000,
           0.00000000,
           0,
           0,
           0,
           0,
           0,
           '1/01/0001',
           0,
           0,
           'S');
      exception
        when others then
          null;
      end;
      commit;
    
      begin
        select count(*)
          into ln_InsrtReg
          from fsd012 f
         where f.pgcod = pn_emp
           and f.aomod = pn_mod
           and f.aosuc = pn_suc
           and f.aomda = pn_mda
           and f.aopap = pn_pap
           and f.aocta = pn_cta
           and f.aooper = pn_ope
           and f.aosbop = pn_sbo
           and f.aotope = pn_top
           and f.d012co = 'S'
           and f.evcorr = ln_cor012 + 1
           and f.evtipo = 3;
      exception
        when others then
          ln_InsrtReg := 0;
      end;
    
      ln_InsrtReg := nvl(ln_InsrtReg, 0);
    
      if ln_InsrtReg > 0 then
      
        begin
          update aqpa380 a
             set a.aqpa380ncor  = ln_cor012 + 1,
                 a.aqpa380nfval = ld_f601,
                 a.aqpa380ntas  = ln_tasa,
                 a.aqpa380camb  = 'S'
           where a.aqpa380cod = pn_emp
             and a.aqpa380mod = pn_mod
             and a.aqpa380suc = pn_suc
             and a.aqpa380mda = pn_mda
             and a.aqpa380pap = pn_pap
             and a.aqpa380cta = pn_cta
             and a.aqpa380oper = pn_ope
             and a.aqpa380sbop = pn_sbo
             and a.aqpa380tope = pn_top
             and a.aqpa380f257 = ld_f257;
        end;
      
        begin
          update jaqa257 j
             set j.jaqa257nu3 = ln_cor012 + 1,
                 j.jaqa257ch2 = 'S',
                 j.jaqa257ch3 = 'P'
           where j.jaqa257emp = pn_emp
             and j.jaqa257mod = pn_mod
             and j.jaqa257suc = pn_suc
             and j.jaqa257mda = pn_mda
             and j.jaqa257pap = pn_pap
             and j.jaqa257cta = pn_cta
             and j.jaqa257ope = pn_ope
             and j.jaqa257sbo = pn_sbo
             and j.jaqa257tpo = pn_top
             and j.jaqa257fec = ld_f257;
        end;
      
      end if;
    
      commit;
    end;
  
  end sp_cr_up_fsd012;
  ---------------------------------------------------------------
  PROCEDURE sp_cr_tasa(v_Pgcod  in number,
                       v_Scmod  in number,
                       v_Scsuc  in number,
                       v_Scmda  in number,
                       v_Scpap  in number,
                       v_Sccta  in number,
                       v_Scoper in number,
                       v_Scsbop in number,
                       v_Sctope in number,
                       pn_tasa  out number) is
  
    -- *****************************************************************
    -- Nombre                     : SP_CR_TASA
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2020.06.27
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Retorna TASA
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : 
    --                              
    -- ***************************************************************** 
  
  BEGIN
  
    begin
      select f1.evtasa
        into pn_tasa
        from fsd012 f1
       where f1.pgcod = v_Pgcod
         and f1.aomod = v_Scmod
         and f1.aosuc = v_Scsuc
         and f1.aomda = v_Scmda
         and f1.aopap = v_Scpap
         and f1.aocta = v_Sccta
         and f1.aooper = v_Scoper
         and f1.aosbop = v_Scsbop
         and f1.aotope = v_Sctope
         and f1.evtipo = 3
         and f1.d012co = 'S'
         and f1.evcorr in (select max(f1.evcorr)
                             from fsd012 f1
                            where f1.pgcod = v_Pgcod
                              and f1.aomod = v_Scmod
                              and f1.aosuc = v_Scsuc
                              and f1.aomda = v_Scmda
                              and f1.aopap = v_Scpap
                              and f1.aocta = v_Sccta
                              and f1.aooper = v_Scoper
                              and f1.aosbop = v_Scsbop
                              and f1.aotope = v_Sctope
                              and f1.evtipo = 3
                              and f1.d012co = 'S');
    exception
      when others then
        begin
          select f1.aotasa
            into pn_tasa
            from fsd010 f1
           where f1.pgcod = v_Pgcod
             and f1.aomod = v_Scmod
             and f1.aosuc = v_Scsuc
             and f1.aomda = v_Scmda
             and f1.aopap = v_Scpap
             and f1.aocta = v_Sccta
             and f1.aooper = v_Scoper
             and f1.aosbop = v_Scsbop
             and f1.aotope = v_Sctope;
        exception
          when others then
            pn_tasa := 0;
        end;
    end;
  
    if pn_tasa = 0 then
      begin
        select f1.aotasa
          into pn_tasa
          from fsd010 f1
         where f1.pgcod = v_Pgcod
           and f1.aomod = v_Scmod
           and f1.aosuc = v_Scsuc
           and f1.aomda = v_Scmda
           and f1.aopap = v_Scpap
           and f1.aocta = v_Sccta
           and f1.aooper = v_Scoper
           and f1.aosbop = v_Scsbop
           and f1.aotope = v_Sctope;
      exception
        when others then
          pn_tasa := 0;
      end;
    
    end if;
  
  end sp_cr_tasa;
  -------------------------------------------------------------------------
  function fn_cr_tasa(v_Pgcod  in number,
                      v_Scmod  in number,
                      v_Scsuc  in number,
                      v_Scmda  in number,
                      v_Scpap  in number,
                      v_Sccta  in number,
                      v_Scoper in number,
                      v_Scsbop in number,
                      v_Sctope in number) return number is
  
    -- *****************************************************************
    -- Nombre                     : fn_CR_TASA
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2020.06.27
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Retorna TASA
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : 
    --                              
    -- ***************************************************************** 
    pn_tasa number(10, 6);
  
  BEGIN
  
    begin
      select f1.evtasa
        into pn_tasa
        from fsd012 f1
       where f1.pgcod = v_Pgcod
         and f1.aomod = v_Scmod
         and f1.aosuc = v_Scsuc
         and f1.aomda = v_Scmda
         and f1.aopap = v_Scpap
         and f1.aocta = v_Sccta
         and f1.aooper = v_Scoper
         and f1.aosbop = v_Scsbop
         and f1.aotope = v_Sctope
         and f1.evtipo = 3
         and f1.d012co = 'S'
         and f1.evcorr in (select max(f1.evcorr)
                             from fsd012 f1
                            where f1.pgcod = v_Pgcod
                              and f1.aomod = v_Scmod
                              and f1.aosuc = v_Scsuc
                              and f1.aomda = v_Scmda
                              and f1.aopap = v_Scpap
                              and f1.aocta = v_Sccta
                              and f1.aooper = v_Scoper
                              and f1.aosbop = v_Scsbop
                              and f1.aotope = v_Sctope
                              and f1.evtipo = 3
                              and f1.d012co = 'S');
    exception
      when others then
        begin
          select f1.aotasa
            into pn_tasa
            from fsd010 f1
           where f1.pgcod = v_Pgcod
             and f1.aomod = v_Scmod
             and f1.aosuc = v_Scsuc
             and f1.aomda = v_Scmda
             and f1.aopap = v_Scpap
             and f1.aocta = v_Sccta
             and f1.aooper = v_Scoper
             and f1.aosbop = v_Scsbop
             and f1.aotope = v_Sctope;
        exception
          when others then
            pn_tasa := 0;
        end;
    end;
  
    if pn_tasa = 0 then
      begin
        select f1.aotasa
          into pn_tasa
          from fsd010 f1
         where f1.pgcod = v_Pgcod
           and f1.aomod = v_Scmod
           and f1.aosuc = v_Scsuc
           and f1.aomda = v_Scmda
           and f1.aopap = v_Scpap
           and f1.aocta = v_Sccta
           and f1.aooper = v_Scoper
           and f1.aosbop = v_Scsbop
           and f1.aotope = v_Sctope;
      exception
        when others then
          pn_tasa := 0;
      end;
    
    end if;
  
    return pn_Tasa;
  
  end fn_cr_tasa;
  ---------------------------------------------------------------------
  procedure sp_cr_Jobs_Inicio(ld_FechProc in date) is
  
    cursor sucursales is
      select sucurs from regsuc order by sucurs;
  
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    --ln_cont     number(2) := 0;
    -- lc_fecpro char(10);
  
  begin
  
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    for x in sucursales loop
    
      lc_variable := ' begin ' || 'PQ_CR_JAQA257.sp_cr_inicio(''' ||
                     x.sucurs || ''',''' || ld_FechProc || ''');' ||
                     ' End; ';
    
      ln_job := ln_job + 1;
    
      --      if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101','T54BTRAC4052','T74BTRAC4051') then
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      commit;
    
    end loop;
  
  end sp_cr_Jobs_Inicio;

end PQ_CR_JAQA257;
/

