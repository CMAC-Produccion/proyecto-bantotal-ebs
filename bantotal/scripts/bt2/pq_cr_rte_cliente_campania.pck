create or replace package PQ_CR_RTE_CLIENTE_CAMPANIA is

  -- Author  : MPOSTIGOC
  -- Created : 20/06/2022 10:06:59
  -- Purpose : Programa que verifica si el cliente esta en campaña
  -- Fecha de Modificación      : 12/12/2023
  -- Autor de la Modificación   : Maria Postigo
  -- Descripción de Modificación: Se agrego un procedimiento para identificar si el cliente esta en campaña o no
  -- Fecha de Modificación      : 24/10/2024
  -- Autor de la Modificación   : Maria Postigo
  -- Descripción de Modificación: Se agrego una condicion para ofertas aprobadas
  -- *****************************************************************

  procedure sp_cr_inicio(ln_pgcod   in number,
                         ln_suctx   in number,
                         ln_modtx   in number,
                         ln_tran    in number,
                         ln_nreltx  in number,
                         lc_pcancel out varchar2,
                         lc_sms     out varchar2);
  -------------------------------------------------------
  procedure sp_cr_inicioapp(ln_pais    in number,
                            ln_tdoc    in number,
                            lc_doc     in varchar2,
                            lc_pcancel out varchar2,
                            lc_sms     out varchar2);
  -------------------------------------------------------
  procedure sp_cr_grupo1(ln_pais    in number,
                         ln_tdoc    in number,
                         lc_doc     in varchar2,
                         lc_pcancel out varchar2,
                         lc_smsG1   out varchar2);
  ---------------------------------------------------------
  procedure sp_cr_grupo2(ln_pais    in number,
                         ln_tdoc    in number,
                         lc_doc     in varchar2,
                         lc_pcancel out varchar2,
                         lc_smsG2   out varchar2);
  ---------------------------------------------------------
  procedure sp_cr_grupo2app(ln_pais    in number,
                            ln_tdoc    in number,
                            lc_doc     in varchar2,
                            lc_pcancel out varchar2,
                            lc_smsG2   out varchar2);
  ---------------------------------------------------------
  procedure sp_cr_grupo1app(ln_pais    in number,
                            ln_tdoc    in number,
                            lc_doc     in varchar2,
                            lc_pcancel out varchar2,
                            lc_smsG1   out varchar2);
  ------------------------------------------------------
  procedure PER_FN_ES_TRABAJADOR(PC_NUMDOC IN VARCHAR2,
                                 PN_TIPDOC IN NUMBER,
                                 PN_CODPAI IN NUMBER,
                                 Lc_RPTA   out varchar2);
  --------------------------------------------------------------
  procedure PER_FN_ES_FAMILIAR_TRABAJADOR(PC_NUMDOC     IN VARCHAR2,
                                          PN_TIPDOC     IN NUMBER,
                                          PN_CODPAI     IN NUMBER,
                                          lc_EsFamiliar out varchar2);
  ---------------------------------------------------------------------
  procedure PER_FN_CLI_FALLECIDO(LV_PENDOC    IN VARCHAR2,
                                 LV_PETDOC    IN NUMBER,
                                 LV_PEPAIS    IN NUMBER,
                                 lc_Fallecido out VARCHAR2);
  ------------------------------------------------------------
  procedure PER_FN_FECNAC_DOC(LV_PENDOC IN VARCHAR2,
                              LV_PETDOC IN NUMBER,
                              LV_PEPAIS IN NUMBER,
                              LC_RPTA   out DATE);
  -----------------------------------------------------------
  procedure sp_cr_sobreendeudado(ln_pais    in number,
                                 ln_tdoc    in number,
                                 lc_doc     in varchar2,
                                 lc_Sobreen out varchar2);
  -------------------------------------------------------------     
  procedure PER_ESTA_LISTA_NEGRA(PC_NUMDOC     IN VARCHAR2,
                                 PN_TIPDOC     IN NUMBER,
                                 PN_CODPAI     IN NUMBER,
                                 lc_ListaNegra out VARCHAR2);
  -------------------------------------------------------------                                  
  procedure sp_NUM_DENEGADAS_PAR(PC_NUMDOC IN VARCHAR2,
                                 PN_TIPDOC IN NUMBER,
                                 PN_CODPAI IN NUMBER,
                                 LN_RPTA   out number);
  --------------------------------------------------------------
  procedure sp_cr_CASTJUD(ln_tdoc    in number,
                          lc_ndoc    in varchar2,
                          lc_CastJud out varchar2);

  ---------------------------------------------------------
  procedure SP_RCC_CPP_PJE(ln_tdoc     in number,
                           lc_ndoc     in varchar2,
                           LC_TieneCPP out varchar2);

  ---------------------------------------------------------------
  procedure sp_cr_EntTitCony(ln_pais   in number,
                             ln_tdoc   in number,
                             ln_ndoc   in varchar2,
                             ln_NroEnt out number);
  -------------------------------------------------------------
  procedure CRE_MAX_ATR_VIG_CLI_DOC(PD_FECPRO IN DATE,
                                    PN_PAIS   IN NUMBER,
                                    PN_TIPDOC IN NUMBER,
                                    PC_NUMDOC IN VARCHAR2,
                                    LN_PROATR out number);
  -------------------------------------------------------------
  procedure CRE_FN_ATR_PROM_CLI_DOC(PD_FECPRO IN DATE,
                                    PD_FECINI IN DATE,
                                    PN_PAIS   IN NUMBER,
                                    PN_TIPDOC IN NUMBER,
                                    PC_NUMDOC IN VARCHAR2,
                                    LN_PROATR out number);

end PQ_CR_RTE_CLIENTE_CAMPANIA;
/

create or replace package body PQ_CR_RTE_CLIENTE_CAMPANIA is

  procedure sp_cr_inicio(ln_pgcod   in number,
                         ln_suctx   in number,
                         ln_modtx   in number,
                         ln_tran    in number,
                         ln_nreltx  in number,
                         lc_pcancel out varchar2,
                         lc_sms     out varchar2) is
  
    ln_cuenta number;
    ln_pais   number;
    ln_tdoc   number;
    lc_doc    varchar2(12);
    lc_smsG1  varchar2(150);
    lc_smsG2  varchar2(150);
  
  begin
  
    lc_pcancel := 'N';
    lc_sms     := null;
  
    begin
      select distinct (f.ctnro)
        into ln_cuenta
        from fsd016 f
       where f.pgcod = ln_pgcod
         and f.itsuc = ln_suctx
         and f.itmod = ln_modtx
         and f.ittran = ln_tran
         and f.itnrel = ln_nreltx
         and f.ctnro > 0
         and rownum = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select f.pepais, f.petdoc, f.pendoc
        into ln_pais, ln_tdoc, lc_doc
        from fsr008 f
       where f.CTNRO = ln_cuenta
         and f.cttfir = 'T';
    exception
      when others then
        null;
    end;
  
    lc_doc := trim(lc_doc);
  
    PQ_CR_RTE_CLIENTE_CAMPANIA.sp_cr_grupo1(ln_pais    => ln_pais,
                                            ln_tdoc    => ln_tdoc,
                                            lc_doc     => lc_doc,
                                            lc_pcancel => lc_pcancel,
                                            lc_smsG1   => lc_smsG1);
    if lc_smsG1 is null then
      PQ_CR_RTE_CLIENTE_CAMPANIA.sp_cr_grupo2(ln_pais    => ln_pais,
                                              ln_tdoc    => ln_tdoc,
                                              lc_doc     => lc_doc,
                                              lc_pcancel => lc_PCancel,
                                              lc_smsG2   => lc_smsG2);
    
      lc_sms := lc_smsG2;
    else
      lc_sms := lc_smsG1;
    end if;
  
  end sp_cr_inicio;
  ----------------------------------------------------------------
  procedure sp_cr_inicioapp(ln_pais    in number,
                            ln_tdoc    in number,
                            lc_doc     in varchar2,
                            lc_pcancel out varchar2,
                            lc_sms     out varchar2) is
  
    lc_docAux varchar2(12);
    lc_smsG1  varchar2(150);
    lc_smsG2  varchar2(150);
  
  begin
  
    lc_pcancel := 'N';
    lc_sms     := null;
    lc_docAux  := trim(lc_doc);
  
    PQ_CR_RTE_CLIENTE_CAMPANIA.sp_cr_grupo1app(ln_pais    => ln_pais,
                                               ln_tdoc    => ln_tdoc,
                                               lc_doc     => lc_docAux,
                                               lc_pcancel => lc_pcancel,
                                               lc_smsG1   => lc_smsG1);
    if lc_smsG1 is null then
      PQ_CR_RTE_CLIENTE_CAMPANIA.sp_cr_grupo2app(ln_pais    => ln_pais,
                                                 ln_tdoc    => ln_tdoc,
                                                 lc_doc     => lc_docAux,
                                                 lc_pcancel => lc_PCancel,
                                                 lc_smsG2   => lc_smsG2);
    
      lc_sms := lc_smsG2;
    else
      lc_sms := lc_smsG1;
    end if;
  
  end sp_cr_inicioapp;

  ----------------------------------------------------------------
  procedure sp_cr_grupo1(ln_pais    in number,
                         ln_tdoc    in number,
                         lc_doc     in varchar2,
                         lc_pcancel out varchar2,
                         lc_smsG1   out varchar2) is
  
    ln_tienecamp  number;
    ln_monto      number(17, 2);
    lc_asesor     varchar2(10);
    lc_NombAnalis varchar2(30);
  
  begin
  
    lc_pcancel := 'N';
    lc_smsG1   := null;
  
    begin
      select count(*)
        into ln_tienecamp
        from jaqz697 j
       where j.jaqz697fep = (select max(z.jaqz697fep) from jaqz697 z)
         and j.jaqz697pai = ln_pais
         and j.jaqz697tdo = ln_tdoc
         and j.jaqz697ndo = rpad(lc_doc, 12, ' ')
         and j.jaqz697au5 in ('N', 'F', 'B');
    exception
      when others then
        null;
    end;
  
    if ln_tienecamp > 0 then
      -- Linea preaprobada ampliación, 
      begin
        select max(j.jaqz697mto), j.jaqz697ase
          into ln_monto, lc_asesor
          from jaqz697 j
         where j.jaqz697fep = (select max(z.jaqz697fep) from jaqz697 z)
           and j.jaqz697pai = ln_pais
           and j.jaqz697tdo = ln_tdoc
           and j.jaqz697ndo = rpad(lc_doc, 12, ' ')
           and j.jaqz697au5 in ('N', 'F')
           and j.jaqz697mod = 117
           and j.jaqz697des = 'AMPLIACION'
           and rownum = 1 -- mpostigoc 10.08.2022
         group by j.jaqz697ase;
      exception
        when others then
          null;
      end;
    
      if ln_monto > 0 then
        begin
          select f.ubnom
            into lc_NombAnalis
            from fst746 f
           where f.ubuser = rpad(lc_asesor, 10, ' ');
        exception
          when others then
            lc_NombAnalis := 'su analista';
        end;
      
        lc_smsG1 := 'Tiene S/. ' || to_char(ln_monto) ||
                    ' en campaña Linea preaprobada ampliación, contactarse con ' ||
                    lc_NombAnalis;
      else
        -- Linea preaprobada adicional, 
        begin
          select max(j.jaqz697mto), j.jaqz697ase
            into ln_monto, lc_asesor
            from jaqz697 j
           where j.jaqz697fep = (select max(z.jaqz697fep) from jaqz697 z)
             and j.jaqz697pai = ln_pais
             and j.jaqz697tdo = ln_tdoc
             and j.jaqz697ndo = rpad(lc_doc, 12, ' ')
             and j.jaqz697au5 in ('N', 'F')
             and j.jaqz697mod = 117
             and j.jaqz697des = 'ADICIONAL'
             and rownum = 1 -- mpostigoc 10.08.2022
           group by j.jaqz697ase;
        exception
          when others then
            null;
        end;
      
        if ln_monto > 0 then
          begin
            select f.ubnom
              into lc_NombAnalis
              from fst746 f
             where f.ubuser = rpad(lc_asesor, 10, ' ');
          exception
            when others then
              lc_NombAnalis := 'su analista';
          end;
        
          lc_smsG1 := 'Tiene S/. ' || to_char(ln_monto) ||
                      ' en campaña Linea preaprobada adicional, contactarse con ' ||
                      lc_NombAnalis;
        else
        
          --  Crédito pre aprobado ampliación, 
          begin
            select max(j.jaqz697mto), j.jaqz697ase
              into ln_monto, lc_asesor
              from jaqz697 j
             where j.jaqz697fep = (select max(z.jaqz697fep) from jaqz697 z)
               and j.jaqz697pai = ln_pais
               and j.jaqz697tdo = ln_tdoc
               and j.jaqz697ndo = rpad(lc_doc, 12, ' ')
               and j.jaqz697au5 in ('N', 'F')
               and j.jaqz697mod <> 117
               and j.jaqz697des = 'AMPLIACION'
               and j.jaqz697tca = 'P'
               and rownum = 1 -- mpostigoc 10.08.2022
             group by j.jaqz697ase;
          exception
            when others then
              null;
          end;
        
          if ln_monto > 0 then
            begin
              select f.ubnom
                into lc_NombAnalis
                from fst746 f
               where f.ubuser = rpad(lc_asesor, 10, ' ');
            exception
              when others then
                lc_NombAnalis := 'su analista';
            end;
          
            lc_smsG1 := 'Tiene S/. ' || to_char(ln_monto) ||
                        ' en campaña credito preaprobado ampliación, contactarse con ' ||
                        lc_NombAnalis;
          else
            --  Crédito preaprobado adicional, 
            begin
              select max(j.jaqz697mto), j.jaqz697ase
                into ln_monto, lc_asesor
                from jaqz697 j
               where j.jaqz697fep =
                     (select max(z.jaqz697fep) from jaqz697 z)
                 and j.jaqz697pai = ln_pais
                 and j.jaqz697tdo = ln_tdoc
                 and j.jaqz697ndo = rpad(lc_doc, 12, ' ')
                 and j.jaqz697au5 in ('N', 'F')
                 and j.jaqz697mod <> 117
                 and j.jaqz697des = 'ADICIONAL'
                 and j.jaqz697tca = 'P'
                 and rownum = 1 -- mpostigoc 10.08.2022
               group by j.jaqz697ase;
            exception
              when others then
                null;
            end;
          
            if ln_monto > 0 then
              begin
                select f.ubnom
                  into lc_NombAnalis
                  from fst746 f
                 where f.ubuser = rpad(lc_asesor, 10, ' ');
              exception
                when others then
                  lc_NombAnalis := 'su analista';
              end;
            
              lc_smsG1 := 'Tiene S/. ' || to_char(ln_monto) ||
                          ' en campaña credito preaprobado adicional, contactarse con ' ||
                          lc_NombAnalis;
            else
              --  Campaña Estacional ampliación,
              begin
                select max(j.jaqz697mto), j.jaqz697ase
                  into ln_monto, lc_asesor
                  from jaqz697 j
                 where j.jaqz697fep =
                       (select max(z.jaqz697fep) from jaqz697 z)
                   and j.jaqz697pai = ln_pais
                   and j.jaqz697tdo = ln_tdoc
                   and j.jaqz697ndo = rpad(lc_doc, 12, ' ')
                   and j.jaqz697au5 in ('N', 'F')
                   and j.jaqz697mod <> 117
                   and j.jaqz697des = 'AMPLIACION'
                   and (j.jaqz697tca is null or j.jaqz697tca <> 'P')
                   and rownum = 1 -- mpostigoc 10.08.2022
                 group by j.jaqz697ase;
              exception
                when others then
                  null;
              end;
            
              if ln_monto > 0 then
                begin
                  select f.ubnom
                    into lc_NombAnalis
                    from fst746 f
                   where f.ubuser = rpad(lc_asesor, 10, ' ');
                exception
                  when others then
                    lc_NombAnalis := 'su analista';
                end;
              
                lc_smsG1 := 'Tiene S/. ' || to_char(ln_monto) ||
                            ' en campaña estacional ampliacion, contactarse con ' ||
                            lc_NombAnalis;
              else
                --  Campaña Estacional adicional
                begin
                  select max(j.jaqz697mto), j.jaqz697ase
                    into ln_monto, lc_asesor
                    from jaqz697 j
                   where j.jaqz697fep =
                         (select max(z.jaqz697fep) from jaqz697 z)
                     and j.jaqz697pai = ln_pais
                     and j.jaqz697tdo = ln_tdoc
                     and j.jaqz697ndo = rpad(lc_doc, 12, ' ')
                     and j.jaqz697au5 in ('N', 'F')
                     and j.jaqz697mod <> 117
                     and j.jaqz697des = 'ADICIONAL'
                     and (j.jaqz697tca is null or j.jaqz697tca <> 'P')
                     and rownum = 1 -- mpostigoc 10.08.2022
                   group by j.jaqz697ase;
                exception
                  when others then
                    null;
                end;
              
                if ln_monto > 0 then
                  begin
                    select f.ubnom
                      into lc_NombAnalis
                      from fst746 f
                     where f.ubuser = rpad(lc_asesor, 10, ' ');
                  exception
                    when others then
                      lc_NombAnalis := 'su analista';
                  end;
                
                  lc_smsG1 := 'Tiene S/. ' || to_char(ln_monto) ||
                              ' en campaña estacional adicional, contactarse con ' ||
                              lc_NombAnalis;
                
                else
                  --  Campaña Aprobada para desembolsar en Ventanilla
                  begin
                    select max(j.jaqz697mto), j.jaqz697ase
                      into ln_monto, lc_asesor
                      from jaqz697 j
                     where j.jaqz697fep =
                           (select max(z.jaqz697fep) from jaqz697 z)
                       and j.jaqz697pai = ln_pais
                       and j.jaqz697tdo = ln_tdoc
                       and j.jaqz697ndo = rpad(lc_doc, 12, ' ')
                       and j.jaqz697au5 = 'B'
                          -- and j.jaqz697des = 'ADICIONAL'
                       and j.JAQZ697APR = 'A'
                       and rownum = 1
                     group by j.jaqz697ase;
                  exception
                    when others then
                      null;
                  end;
                
                  if ln_monto > 0 then
                    begin
                      select f.ubnom
                        into lc_NombAnalis
                        from fst746 f
                       where f.ubuser = rpad(lc_asesor, 10, ' ');
                    exception
                      when others then
                        lc_NombAnalis := 'su analista';
                    end;
                  
                    lc_smsG1 := 'Tiene S/. ' || to_char(ln_monto) ||
                                ' en campaña aprobada, contactarse con ' ||
                                lc_NombAnalis;
                  end if;
                end if;
              end if;
            end if;
          end if;
        end if;
      end if;
    
      if lc_smsG1 is not null then
        lc_pcancel := 'S';
      end if;
    
    else
      lc_smsG1 := null;
    end if;
  
  end sp_cr_grupo1;
  ----------------------------------------------------------------        
  procedure sp_cr_grupo2(ln_pais    in number,
                         ln_tdoc    in number,
                         lc_doc     in varchar2,
                         lc_pcancel out varchar2,
                         lc_smsG2   out varchar2) is
  
    lc_EsTrabajador varchar2(2) := 'N';
    lc_EsFamilia    varchar2(2) := 'N';
    lc_Fallecido    varchar2(2) := 'N';
    ld_FchNac       date;
    ld_FchSist      date;
    lc_Sobreen      varchar2(5);
    lc_EstaLN       varchar2(2) := 'N';
    ln_Denegado     number;
    lc_CastJudi     varchar2(2) := 'N';
    lc_TieneCPP     varchar2(2) := 'N';
    ln_NroEntTitCy  number;
    ln_anios        number;
    ld_FFin         date;
    ln_Promedio     number;
    ln_MaxMora      number;
  
  begin
  
    lc_pcancel := 'N';
    lc_smsG2   := null;
  
    begin
      select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select add_months(ld_FchSist, -6) into ld_FFin from dual;
    exception
      when others then
        null;
    end;
    --a.  Número de créditos diferente a condición contable vigente = 0
    --b.  Titular no es trabajador de Caja Arequipa
    pq_Cr_rte_cliente_campania.PER_FN_ES_TRABAJADOR(PC_NUMDOC => lc_doc,
                                                    PN_TIPDOC => ln_tdoc,
                                                    PN_CODPAI => ln_pais,
                                                    Lc_RPTA   => lc_EsTrabajador);
    if lc_EsTrabajador = 'N' then
      --c.  Titular no es familiar de trabajador de Caja Arequipa
      pq_Cr_rte_cliente_campania.PER_FN_ES_FAMILIAR_TRABAJADOR(PC_NUMDOC     => lc_doc,
                                                               PN_TIPDOC     => ln_tdoc,
                                                               PN_CODPAI     => ln_pais,
                                                               lc_EsFamiliar => lc_EsFamilia);
      if lc_EsFamilia = 'N' then
        --d.  Titular no este registrado como fallecido
        pq_Cr_rte_cliente_campania.PER_FN_CLI_FALLECIDO(LV_PENDOC    => lc_doc,
                                                        LV_PETDOC    => ln_tdoc,
                                                        LV_PEPAIS    => ln_pais,
                                                        lc_Fallecido => lc_Fallecido);
        if lc_Fallecido = 'N' then
          --e.  Edad titular <= 75 años
          pq_Cr_rte_cliente_campania.PER_FN_FECNAC_DOC(LV_PENDOC => lc_doc,
                                                       LV_PETDOC => ln_tdoc,
                                                       LV_PEPAIS => ln_pais,
                                                       LC_RPTA   => ld_FchNac);
        
          begin
            SELECT floor(months_between(ld_FchSist, ld_FchNac) / 12)
              into ln_anios
              FROM dual;
          exception
            when others then
              ln_anios := 100;
          end;
          if ln_anios <= 75 then
            --f.  No sobre-endeudados ni titular ni cónyuge
            pq_Cr_rte_cliente_campania.sp_cr_sobreendeudado(ln_pais    => ln_pais,
                                                            ln_tdoc    => ln_tdoc,
                                                            lc_doc     => lc_doc,
                                                            lc_Sobreen => lc_Sobreen);
          
            if lc_Sobreen = 'N' then
              --g.  No en listas negras ni titular ni cónyuge
              pq_Cr_rte_cliente_campania.PER_ESTA_LISTA_NEGRA(PC_NUMDOC     => lc_doc,
                                                              PN_TIPDOC     => ln_tdoc,
                                                              PN_CODPAI     => ln_pais,
                                                              lc_ListaNegra => lc_EstaLN);
              if lc_EstaLN = 'N' then
                --h.  No en recuperación legal ni titular ni cónyuge
                --i.  No tiene solicitudes en vuelo ni titular ni cónyuge
                --j.  No tiene solicitudes denegadas ni titular ni cónyuge
                pq_Cr_rte_cliente_campania.sp_NUM_DENEGADAS_PAR(PC_NUMDOC => lc_doc,
                                                                PN_TIPDOC => ln_tdoc,
                                                                PN_CODPAI => ln_pais,
                                                                LN_RPTA   => ln_Denegado);
                if ln_Denegado = 0 then
                  --k.  No tenga ningún crédito judicial ni castigado en el SF
                  pq_Cr_rte_cliente_campania.sp_cr_CASTJUD(ln_tdoc    => ln_tdoc,
                                                           lc_ndoc    => lc_doc,
                                                           lc_CastJud => lc_CastJudi);
                  if lc_CastJudi = 'N' then
                    --l.  Titular y cónyuge hasta 20% CPP (los últimos 06 meses)
                    pq_Cr_rte_cliente_campania.SP_RCC_CPP_PJE(ln_tdoc     => ln_tdoc,
                                                              lc_ndoc     => lc_doc,
                                                              LC_TieneCPP => lc_TieneCPP);
                    if lc_TieneCPP = 'N' then
                      --m.  Titular y cónyuge hasta 5 ifi¿s (inc. Caja).
                      pq_Cr_rte_cliente_campania.sp_cr_EntTitCony(ln_pais   => ln_pais,
                                                                  ln_tdoc   => ln_tdoc,
                                                                  ln_ndoc   => lc_doc,
                                                                  ln_NroEnt => ln_NroEntTitCy);
                    
                      if ln_NroEntTitCy <= 5 then
                        --n.  Para clientes Caja: promedio de días de atraso de las cuotas pagadas 
                        --en los últimos 6 meses (180 días calendario) no mayor a 15 días 
                        pq_Cr_rte_cliente_campania.CRE_FN_ATR_PROM_CLI_DOC(PD_FECPRO => ld_FchSist,
                                                                           PD_FECINI => ld_FFin,
                                                                           PN_PAIS   => ln_pais,
                                                                           PN_TIPDOC => ln_tdoc,
                                                                           PC_NUMDOC => lc_doc,
                                                                           LN_PROATR => ln_Promedio);
                      
                        if ln_Promedio <= 15 then
                        
                          --y ninguna cuota más de 30 días, exceptuando la deuda hipotecaria.
                          pq_Cr_rte_cliente_campania.CRE_MAX_ATR_VIG_CLI_DOC(PD_FECPRO => ld_FchSist,
                                                                             PN_PAIS   => ln_pais,
                                                                             PN_TIPDOC => ln_tdoc,
                                                                             PC_NUMDOC => lc_doc,
                                                                             LN_PROATR => ln_MaxMora);
                        
                          if ln_MaxMora <= 30 then
                            lc_pcancel := 'S';
                            lc_smsG2   := 'Cliente califica para campaña, contactarse con un analista';
                          end if;
                        end if;
                      end if;
                    end if;
                  end if;
                end if;
              end if;
            end if;
          end if;
        end if;
      end if;
    end if;
  
  end sp_cr_grupo2;
  --------------------------------------------------------------
  procedure sp_cr_grupo1app(ln_pais    in number,
                            ln_tdoc    in number,
                            lc_doc     in varchar2,
                            lc_pcancel out varchar2,
                            lc_smsG1   out varchar2) is
  
    ln_tienecamp number;
    ln_monto     number(17, 2);
    lc_asesor    varchar2(10);
  
  begin
  
    lc_pcancel := 'N';
    lc_smsG1   := null;
  
    begin
      select count(*)
        into ln_tienecamp
        from jaqz697 j
       where j.jaqz697fep = (select max(z.jaqz697fep) from jaqz697 z)
         and j.jaqz697pai = ln_pais
         and j.jaqz697tdo = ln_tdoc
         and j.jaqz697ndo = rpad(lc_doc, 12, ' ')
         and j.jaqz697au5 in ('N', 'F');
    end;
  
    if ln_tienecamp > 0 then
      -- Linea preaprobada ampliación, 
      begin
        select max(j.jaqz697mto), j.jaqz697ase
          into ln_monto, lc_asesor
          from jaqz697 j
         where j.jaqz697fep = (select max(z.jaqz697fep) from jaqz697 z)
           and j.jaqz697pai = ln_pais
           and j.jaqz697tdo = ln_tdoc
           and j.jaqz697ndo = rpad(lc_doc, 12, ' ')
           and j.jaqz697au5 in ('N', 'F')
           and j.jaqz697mod = 117
           and j.jaqz697des = 'AMPLIACION'
           and rownum = 1 -- mpostigoc 10.08.2022
         group by j.jaqz697ase;
      exception
        when others then
          null;
      end;
    
      if ln_monto > 0 then
        if ln_monto < 999999 then
          lc_smsG1 := 'Tiene S/. ' || to_char(ln_monto) || ' Preaprobados.';
        else
          lc_smsG1 := 'Si, Califica.';
        end if;
      else
        -- Linea preaprobada adicional, 
        begin
          select max(j.jaqz697mto), j.jaqz697ase
            into ln_monto, lc_asesor
            from jaqz697 j
           where j.jaqz697fep = (select max(z.jaqz697fep) from jaqz697 z)
             and j.jaqz697pai = ln_pais
             and j.jaqz697tdo = ln_tdoc
             and j.jaqz697ndo = rpad(lc_doc, 12, ' ')
             and j.jaqz697au5 in ('N', 'F')
             and j.jaqz697mod = 117
             and j.jaqz697des = 'ADICIONAL'
             and rownum = 1 -- mpostigoc 10.08.2022
           group by j.jaqz697ase;
        exception
          when others then
            null;
        end;
      
        if ln_monto > 0 then
        
          if ln_monto < 999999 then
            lc_smsG1 := 'Tiene S/. ' || to_char(ln_monto) ||
                        ' Preaprobados.';
          else
            lc_smsG1 := 'Si, Califica.';
          end if;
        else
        
          --  Crédito pre aprobado ampliación, 
          begin
            select max(j.jaqz697mto), j.jaqz697ase
              into ln_monto, lc_asesor
              from jaqz697 j
             where j.jaqz697fep = (select max(z.jaqz697fep) from jaqz697 z)
               and j.jaqz697pai = ln_pais
               and j.jaqz697tdo = ln_tdoc
               and j.jaqz697ndo = rpad(lc_doc, 12, ' ')
               and j.jaqz697au5 in ('N', 'F')
               and j.jaqz697mod <> 117
               and j.jaqz697des = 'AMPLIACION'
               and j.jaqz697tca = 'P'
               and rownum = 1 -- mpostigoc 10.08.2022
             group by j.jaqz697ase;
          exception
            when others then
              null;
          end;
        
          if ln_monto > 0 then
          
            if ln_monto < 999999 then
              lc_smsG1 := 'Tiene S/. ' || to_char(ln_monto) ||
                          ' Preaprobados.';
            else
              lc_smsG1 := 'Si, Califica.';
            end if;
          
          else
            --  Crédito preaprobado adicional, 
            begin
              select max(j.jaqz697mto), j.jaqz697ase
                into ln_monto, lc_asesor
                from jaqz697 j
               where j.jaqz697fep =
                     (select max(z.jaqz697fep) from jaqz697 z)
                 and j.jaqz697pai = ln_pais
                 and j.jaqz697tdo = ln_tdoc
                 and j.jaqz697ndo = rpad(lc_doc, 12, ' ')
                 and j.jaqz697au5 in ('N', 'F')
                 and j.jaqz697mod <> 117
                 and j.jaqz697des = 'ADICIONAL'
                 and j.jaqz697tca = 'P'
                 and rownum = 1 -- mpostigoc 10.08.2022
               group by j.jaqz697ase;
            exception
              when others then
                null;
            end;
          
            if ln_monto > 0 then
            
              if ln_monto < 999999 then
                lc_smsG1 := 'Tiene S/. ' || to_char(ln_monto) ||
                            ' Preaprobados.';
              else
                lc_smsG1 := 'Si, Califica.';
              end if;
            else
              --  Campaña Estacional ampliación,
              begin
                select max(j.jaqz697mto), j.jaqz697ase
                  into ln_monto, lc_asesor
                  from jaqz697 j
                 where j.jaqz697fep =
                       (select max(z.jaqz697fep) from jaqz697 z)
                   and j.jaqz697pai = ln_pais
                   and j.jaqz697tdo = ln_tdoc
                   and j.jaqz697ndo = rpad(lc_doc, 12, ' ')
                   and j.jaqz697au5 in ('N', 'F')
                   and j.jaqz697mod <> 117
                   and j.jaqz697des = 'AMPLIACION'
                   and (j.jaqz697tca is null or j.jaqz697tca <> 'P')
                   and rownum = 1 -- mpostigoc 10.08.2022
                 group by j.jaqz697ase;
              exception
                when others then
                  null;
              end;
            
              if ln_monto > 0 then
              
                if ln_monto < 999999 then
                  lc_smsG1 := 'Tiene S/. ' || to_char(ln_monto) ||
                              ' Preaprobados.';
                else
                  lc_smsG1 := 'Si, Califica.';
                end if;
              else
                --  Campaña Estacional adicional
                begin
                  select max(j.jaqz697mto), j.jaqz697ase
                    into ln_monto, lc_asesor
                    from jaqz697 j
                   where j.jaqz697fep =
                         (select max(z.jaqz697fep) from jaqz697 z)
                     and j.jaqz697pai = ln_pais
                     and j.jaqz697tdo = ln_tdoc
                     and j.jaqz697ndo = rpad(lc_doc, 12, ' ')
                     and j.jaqz697au5 in ('N', 'F')
                     and j.jaqz697mod <> 117
                     and j.jaqz697des = 'ADICIONAL'
                     and (j.jaqz697tca is null or j.jaqz697tca <> 'P')
                     and rownum = 1 -- mpostigoc 10.08.2022
                   group by j.jaqz697ase;
                exception
                  when others then
                    null;
                end;
              
                if ln_monto > 0 then
                
                  if ln_monto < 999999 then
                    lc_smsG1 := 'Tiene S/. ' || to_char(ln_monto) ||
                                ' Preaprobados.';
                  else
                    lc_smsG1 := 'Si, Califica.';
                  end if;
                
                end if;
              end if;
            end if;
          end if;
        end if;
      end if;
    
      if lc_smsG1 is not null then
        lc_pcancel := 'S';
      end if;
    
    else
      lc_smsG1 := null;
    end if;
  
  end sp_cr_grupo1app;
  ----------------------------------------------------------------        
  procedure sp_cr_grupo2app(ln_pais    in number,
                            ln_tdoc    in number,
                            lc_doc     in varchar2,
                            lc_pcancel out varchar2,
                            lc_smsG2   out varchar2) is
  
    lc_EsTrabajador varchar2(2) := 'N';
    lc_EsFamilia    varchar2(2) := 'N';
    lc_Fallecido    varchar2(2) := 'N';
    ld_FchNac       date;
    ld_FchSist      date;
    lc_Sobreen      varchar2(5);
    lc_EstaLN       varchar2(2) := 'N';
    ln_Denegado     number;
    lc_CastJudi     varchar2(2) := 'N';
    lc_TieneCPP     varchar2(2) := 'N';
    ln_NroEntTitCy  number;
    ln_anios        number;
    ld_FFin         date;
    ln_Promedio     number;
    ln_MaxMora      number;
  
  begin
  
    lc_pcancel := 'N';
    lc_smsG2   := null;
  
    begin
      select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select add_months(ld_FchSist, -6) into ld_FFin from dual;
    exception
      when others then
        null;
    end;
    --a.  Número de créditos diferente a condición contable vigente = 0
    --b.  Titular no es trabajador de Caja Arequipa
    pq_Cr_rte_cliente_campania.PER_FN_ES_TRABAJADOR(PC_NUMDOC => lc_doc,
                                                    PN_TIPDOC => ln_tdoc,
                                                    PN_CODPAI => ln_pais,
                                                    Lc_RPTA   => lc_EsTrabajador);
    if lc_EsTrabajador = 'N' then
      --c.  Titular no es familiar de trabajador de Caja Arequipa
      pq_Cr_rte_cliente_campania.PER_FN_ES_FAMILIAR_TRABAJADOR(PC_NUMDOC     => lc_doc,
                                                               PN_TIPDOC     => ln_tdoc,
                                                               PN_CODPAI     => ln_pais,
                                                               lc_EsFamiliar => lc_EsFamilia);
      if lc_EsFamilia = 'N' then
        --d.  Titular no este registrado como fallecido
        pq_Cr_rte_cliente_campania.PER_FN_CLI_FALLECIDO(LV_PENDOC    => lc_doc,
                                                        LV_PETDOC    => ln_tdoc,
                                                        LV_PEPAIS    => ln_pais,
                                                        lc_Fallecido => lc_Fallecido);
        if lc_Fallecido = 'N' then
          --e.  Edad titular <= 75 años
          pq_Cr_rte_cliente_campania.PER_FN_FECNAC_DOC(LV_PENDOC => lc_doc,
                                                       LV_PETDOC => ln_tdoc,
                                                       LV_PEPAIS => ln_pais,
                                                       LC_RPTA   => ld_FchNac);
        
          begin
            SELECT floor(months_between(ld_FchSist, ld_FchNac) / 12)
              into ln_anios
              FROM dual;
          exception
            when others then
              ln_anios := 100;
          end;
          if ln_anios <= 75 then
            --f.  No sobre-endeudados ni titular ni cónyuge
            pq_Cr_rte_cliente_campania.sp_cr_sobreendeudado(ln_pais    => ln_pais,
                                                            ln_tdoc    => ln_tdoc,
                                                            lc_doc     => lc_doc,
                                                            lc_Sobreen => lc_Sobreen);
          
            if lc_Sobreen = 'N' then
              --g.  No en listas negras ni titular ni cónyuge
              pq_Cr_rte_cliente_campania.PER_ESTA_LISTA_NEGRA(PC_NUMDOC     => lc_doc,
                                                              PN_TIPDOC     => ln_tdoc,
                                                              PN_CODPAI     => ln_pais,
                                                              lc_ListaNegra => lc_EstaLN);
              if lc_EstaLN = 'N' then
                --h.  No en recuperación legal ni titular ni cónyuge
                --i.  No tiene solicitudes en vuelo ni titular ni cónyuge
                --j.  No tiene solicitudes denegadas ni titular ni cónyuge
                pq_Cr_rte_cliente_campania.sp_NUM_DENEGADAS_PAR(PC_NUMDOC => lc_doc,
                                                                PN_TIPDOC => ln_tdoc,
                                                                PN_CODPAI => ln_pais,
                                                                LN_RPTA   => ln_Denegado);
                if ln_Denegado = 0 then
                  --k.  No tenga ningún crédito judicial ni castigado en el SF
                  pq_Cr_rte_cliente_campania.sp_cr_CASTJUD(ln_tdoc    => ln_tdoc,
                                                           lc_ndoc    => lc_doc,
                                                           lc_CastJud => lc_CastJudi);
                  if lc_CastJudi = 'N' then
                    --l.  Titular y cónyuge hasta 20% CPP (los últimos 06 meses)
                    pq_Cr_rte_cliente_campania.SP_RCC_CPP_PJE(ln_tdoc     => ln_tdoc,
                                                              lc_ndoc     => lc_doc,
                                                              LC_TieneCPP => lc_TieneCPP);
                    if lc_TieneCPP = 'N' then
                      --m.  Titular y cónyuge hasta 5 ifi¿s (inc. Caja).
                      pq_Cr_rte_cliente_campania.sp_cr_EntTitCony(ln_pais   => ln_pais,
                                                                  ln_tdoc   => ln_tdoc,
                                                                  ln_ndoc   => lc_doc,
                                                                  ln_NroEnt => ln_NroEntTitCy);
                    
                      if ln_NroEntTitCy <= 5 then
                        --n.  Para clientes Caja: promedio de días de atraso de las cuotas pagadas 
                        --en los últimos 6 meses (180 días calendario) no mayor a 15 días 
                        pq_Cr_rte_cliente_campania.CRE_FN_ATR_PROM_CLI_DOC(PD_FECPRO => ld_FchSist,
                                                                           PD_FECINI => ld_FFin,
                                                                           PN_PAIS   => ln_pais,
                                                                           PN_TIPDOC => ln_tdoc,
                                                                           PC_NUMDOC => lc_doc,
                                                                           LN_PROATR => ln_Promedio);
                      
                        if ln_Promedio <= 15 then
                        
                          --y ninguna cuota más de 30 días, exceptuando la deuda hipotecaria.
                          pq_Cr_rte_cliente_campania.CRE_MAX_ATR_VIG_CLI_DOC(PD_FECPRO => ld_FchSist,
                                                                             PN_PAIS   => ln_pais,
                                                                             PN_TIPDOC => ln_tdoc,
                                                                             PC_NUMDOC => lc_doc,
                                                                             LN_PROATR => ln_MaxMora);
                        
                          if ln_MaxMora <= 30 then
                            lc_pcancel := 'S';
                            lc_smsG2   := 'Si, Cliente califica.';
                          end if;
                        end if;
                      end if;
                    end if;
                  end if;
                end if;
              end if;
            end if;
          end if;
        end if;
      end if;
    end if;
  
  end sp_cr_grupo2app;
  ---------------------------------------------------------------------
  procedure PER_FN_ES_TRABAJADOR(PC_NUMDOC IN VARCHAR2,
                                 PN_TIPDOC IN NUMBER,
                                 PN_CODPAI IN NUMBER,
                                 Lc_RPTA   out varchar2) IS
  
    ln_TieneReg number;
  
  begin
  
    BEGIN
      SELECT COUNT(D2.PFNDOC)
        INTO ln_TieneReg
        FROM FSD002 D2
       WHERE D2.PFEBCO = 'S'
         AND D2.PFPAIS = PN_CODPAI
         AND D2.PFTDOC = PN_TIPDOC
         AND D2.PFNDOC = RPAD(PC_NUMDOC, 12, ' ');
    EXCEPTION
      WHEN OTHERS THEN
        Lc_RPTA := 'N';
    end;
  
    IF ln_TieneReg = 0 THEN
      Lc_RPTA := 'N';
    ELSE
      Lc_RPTA := 'S';
    END IF;
  
  END PER_FN_ES_TRABAJADOR;
  -------------------------------------------------------------

  procedure PER_FN_ES_FAMILIAR_TRABAJADOR(PC_NUMDOC     IN VARCHAR2,
                                          PN_TIPDOC     IN NUMBER,
                                          PN_CODPAI     IN NUMBER,
                                          lc_EsFamiliar out varchar2) IS
    LN_RPTA NUMBER;
  
  BEGIN
  
    begin
      SELECT COUNT(D2.PFNDOC)
        INTO LN_RPTA
        FROM FSD002 D2, FSR002 R2
       WHERE D2.PFEBCO = 'S'
         AND D2.PFPAIS = R2.PEPAIS
         AND D2.PFTDOC = R2.PETDOC
         AND D2.PFNDOC = R2.PENDOC
         AND R2.RPCCYG IN (71,
                           69,
                           68,
                           63,
                           70, --CONS(Padres-Hijos-Hermanos-Abuelos-Nietos)
                           66,
                           75,
                           67) --AFI(Conyuge-Suegros-Cuñados)
         AND R2.RPPAIS = PN_CODPAI
         AND R2.RPTDOC = PN_TIPDOC
         AND R2.RPNDOC = RPAD(PC_NUMDOC, 12, ' ');
    EXCEPTION
      WHEN OTHERS THEN
        lc_EsFamiliar := 'N';
    end;
  
    IF (LN_RPTA = 0) THEN
      lc_EsFamiliar := 'N';
    ELSE
      lc_EsFamiliar := 'S';
    END IF;
  
  END PER_FN_ES_FAMILIAR_TRABAJADOR;

  -------------------------------------------------------------
  procedure PER_FN_CLI_FALLECIDO(LV_PENDOC    IN VARCHAR2,
                                 LV_PETDOC    IN NUMBER,
                                 LV_PEPAIS    IN NUMBER,
                                 lc_Fallecido out VARCHAR2) IS
    LN_RPTA NUMBER;
  
  BEGIN
  
    begin
      SELECT COUNT(*)
        INTO LN_RPTA
        FROM FSD002 A
       WHERE A.PFPAIS = LV_PEPAIS
         AND A.PFTDOC = LV_PETDOC
         AND A.PFNDOC = RPAD(LV_PENDOC, 12, ' ')
         AND A.PFFAL = 'S';
    exception
      when others then
        null;
    end;
  
    IF LN_RPTA > 0 THEN
      lc_Fallecido := 'S';
    ELSE
      lc_Fallecido := 'N';
    END IF;
  
  END PER_FN_CLI_FALLECIDO;
  -------------------------------------------------------------
  procedure PER_FN_FECNAC_DOC(LV_PENDOC IN VARCHAR2,
                              LV_PETDOC IN NUMBER,
                              LV_PEPAIS IN NUMBER,
                              LC_RPTA   out DATE) IS
  
  BEGIN
    begin
      SELECT D2.PFFNAC
        INTO LC_RPTA
        FROM FSD002 D2
       WHERE D2.PFNDOC = RPAD(LV_PENDOC, 12, ' ')
         AND D2.PFPAIS = LV_PEPAIS
         AND D2.PFTDOC = LV_PETDOC;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        SELECT D3.PJFCON
          INTO LC_RPTA
          FROM FSD003 D3
         WHERE D3.PJNDOC = RPAD(LV_PENDOC, 12, ' ')
           AND D3.PJPAIS = LV_PEPAIS
           AND D3.PJTDOC = LV_PETDOC;
        -- RETURN LC_RPTA;
      WHEN OTHERS THEN
        null;
        --RETURN NULL;
    END;
  end PER_FN_FECNAC_DOC;
  -------------------------------------------------------------
  procedure sp_cr_sobreendeudado(ln_pais    in number,
                                 ln_tdoc    in number,
                                 lc_doc     in varchar2,
                                 lc_Sobreen out varchar2) is
  
  begin
  
    begin
      SELECT CASE
               WHEN J.JAQY490SOB IN (0, 2) THEN
                'N'
               ELSE
                'S' --1 SOBREENDEUDADO
             END
        into lc_Sobreen
        FROM JAQY490S J
       WHERE J.JAQY490PAI = ln_pais
         AND J.JAQY490TDO = ln_tdoc
         AND J.JAQY490NDO = RPAD(lc_doc, 12, ' ');
    exception
      when others then
        lc_Sobreen := 'N';
      
    end;
  end sp_cr_sobreendeudado;
  -------------------------------------------------------------
  procedure PER_ESTA_LISTA_NEGRA(PC_NUMDOC     IN VARCHAR2,
                                 PN_TIPDOC     IN NUMBER,
                                 PN_CODPAI     IN NUMBER,
                                 lc_ListaNegra out VARCHAR2) IS
    LN_RPTA NUMBER;
  BEGIN
  
    begin
      SELECT COUNT(D201.LNNDOC)
        INTO LN_RPTA
        FROM FSD201 D201
       WHERE D201.TLIS <> 2
         AND D201.LNPAIS = PN_CODPAI
         AND D201.LNTDOC = PN_TIPDOC
         AND D201.LNNDOC = RPAD(PC_NUMDOC, 25, ' ');
    exception
      when others then
        null;
    end;
  
    IF (LN_RPTA = 0) THEN
      lc_ListaNegra := 'N';
    ELSE
      lc_ListaNegra := 'S';
    END IF;
  
  END PER_ESTA_LISTA_NEGRA;
  -------------------------------------------------------------
  procedure sp_NUM_DENEGADAS_PAR(PC_NUMDOC IN VARCHAR2,
                                 PN_TIPDOC IN NUMBER,
                                 PN_CODPAI IN NUMBER,
                                 LN_RPTA   out number) IS
  
  BEGIN
  
    begin
      SELECT /*+ALL_ROWS*/
       COUNT(*)
        INTO LN_RPTA
        FROM FSR008 R8, SNG001 B, SNGM10 C
       WHERE R8.PEPAIS = PN_CODPAI
         AND R8.PETDOC = PN_TIPDOC
         AND R8.PENDOC = RPAD(PC_NUMDOC, 12, ' ')
         AND R8.CTNRO = B.SNG001CTA
         AND B.SNG001INST = C.SNGM10INST
         AND C.SNGM01TIPM = 1
         AND C.SNGM02MOTC IN (15, 30, 35);
    EXCEPTION
      WHEN OTHERS THEN
        LN_RPTA := 0;
    END;
  
  end sp_NUM_DENEGADAS_PAR;
  -------------------------------------------------------------
  /*procedure sp_Cr_RECLEGALXCTA( LV_CTNRO IN NUMBER,
                            LN_NUMINS IN NUMBER,
                            LV_COPAIS IN NUMBER,
                            LV_COTDOC IN NUMBER,
                            LV_CONDOC IN CHAR,
                            LV_VALTIT IN CHAR
                          )
  RETURN VARCHAR2 PARALLEL_ENABLE
  IS
  
    LC_RECLEG VARCHAR2(1);
  
    CURSOR C_INTCTA IS --PERSONAS A EVALUAR
      SELECT R8.PEPAIS,R8.PETDOC, R8.PENDOC,TRIM(PENDOC) NUMDOC
        FROM FSR008 R8
      WHERE R8.CTNRO  = LV_CTNRO
        AND R8.TTCOD  = (CASE WHEN LV_VALTIT='S' THEN 1 ELSE R8.TTCOD END)
        AND R8.CTTFIR = (CASE WHEN LV_VALTIT='S' THEN 'T' ELSE R8.CTTFIR END)
      UNION
      SELECT LV_COPAIS, LV_COTDOC, LV_CONDOC, TRIM(LV_CONDOC) NUMDOC
        FROM DUAL
      UNION --AVALES DE CUENTA
      SELECT R8.PEPAIS,R8.PETDOC, R8.PENDOC,TRIM(R8.PENDOC) NUMDOC
        FROM SNG003 G3
             INNER JOIN FSR008 R8
             ON R8.CTNRO = G3.SNG003CTA
        WHERE
             G3.SNG001INST = LN_NUMINS
        ;
  
    CURSOR C_CTAS IS --CUENTAS A EVALUAR
      SELECT DISTINCT R8I.CTNRO
        FROM FSR008 R8
             INNER JOIN FSR008 R8I --CUENTAS ASOCIADAS A LOS INTEGRANTES DE LA CUENTA
               ON R8I.PGCOD = R8.PGCOD
              AND R8I.PEPAIS = R8.PEPAIS
              AND R8I.PETDOC = R8.PETDOC
              AND R8I.PENDOC = R8.PENDOC
      WHERE EXISTS ( SELECT 1
                       FROM
                           (
                              SELECT R8.PEPAIS,R8.PETDOC, R8.PENDOC
                                FROM FSR008 R8
                              WHERE R8.CTNRO  = LV_CTNRO
                                AND R8.TTCOD  = (CASE WHEN LV_VALTIT='S' THEN 1 ELSE R8.TTCOD END)
                                AND R8.CTTFIR = (CASE WHEN LV_VALTIT='S' THEN 'T' ELSE R8.CTTFIR END)
                              UNION
                              SELECT LV_COPAIS, LV_COTDOC, LV_CONDOC
                                FROM DUAL
                              UNION --AVALES DE CUENTA
                              SELECT R8.PEPAIS,R8.PETDOC, R8.PENDOC
                                FROM SNG003 G3
                                     INNER JOIN FSR008 R8
                                     ON R8.CTNRO = G3.SNG003CTA
                                WHERE
                                     G3.SNG001INST = LN_NUMINS
                           )A
                       WHERE
                            A.PEPAIS = R8.PEPAIS
                        AND A.PETDOC = R8.PETDOC
                        AND A.PENDOC = R8.PENDOC
                   );
  
    CURSOR C_CTASAVAL IS --CUENTAS AVALADAS POR INTEGRANTES
       SELECT DISTINCT F700.XWFCUENTA CTNRO
          FROM FSR008 R8
               INNER JOIN SNG003 G3
               ON G3.SNG003CTA = R8.CTNRO
               INNER JOIN XWF700 F700
               ON F700.XWFPRCINS = G3.SNG001INST
        WHERE EXISTS ( SELECT 1
                         FROM
                             (
                                SELECT R8.PEPAIS,R8.PETDOC, R8.PENDOC
                                  FROM FSR008 R8
                                WHERE R8.CTNRO  = LV_CTNRO
                                  AND R8.TTCOD  = (CASE WHEN LV_VALTIT='S' THEN 1 ELSE R8.TTCOD END)
                                  AND R8.CTTFIR = (CASE WHEN LV_VALTIT='S' THEN 'T' ELSE R8.CTTFIR END)
                                UNION
                                SELECT LV_COPAIS, LV_COTDOC, LV_CONDOC
                                  FROM DUAL
                             )A
                         WHERE
                              A.PEPAIS = R8.PEPAIS
                          AND A.PETDOC = R8.PETDOC
                          AND A.PENDOC = R8.PENDOC
                     );
    BEGIN
    BEGIN
        --VERIFICAR CON MODULOS, TIPO DE OPERACION Y ESTADOS
        SELECT DISTINCT 'S'
               INTO LC_RECLEG
          FROM FSR008 R8
               INNER JOIN FSR008 R8I --CUENTAS ASOCIADAS A LOS INTEGRANTES DE LA CUENTA
                 ON R8I.PGCOD = R8.PGCOD
                AND R8I.PEPAIS = R8.PEPAIS
                AND R8I.PETDOC = R8.PETDOC
                AND R8I.PENDOC = R8.PENDOC
              INNER JOIN FSD010 D10
                ON  D10.PGCOD = R8I.PGCOD
               AND  D10.AOCTA = R8I.CTNRO
               AND  D10.AOMOD IN (SELECT MODULO FROM FST111 WHERE DSCOD=50 AND MODULO NOT IN (29,120) UNION ALL SELECT 117 FROM DUAL)
               AND  D10.AOMOD <> 120
               AND ( D10.AOMOD IN (33,200) --CASTIGADO, JUDICIAL
                     OR
                     D10.AOTOPE = 550 --PREJUDICIAL
                     OR
                     D10.AOSTAT   IN (71,66,64,23,25,22,21,33,34) --PJ
                   )
        WHERE EXISTS ( SELECT 1
                         FROM
                             (
                                SELECT R8.PEPAIS,R8.PETDOC, R8.PENDOC
                                  FROM FSR008 R8
                                WHERE R8.CTNRO  = LV_CTNRO
                                  AND R8.TTCOD  = (CASE WHEN LV_VALTIT='S' THEN 1 ELSE R8.TTCOD END)
                                  AND R8.CTTFIR = (CASE WHEN LV_VALTIT='S' THEN 'T' ELSE R8.CTTFIR END)
                                UNION
                                SELECT LV_COPAIS, LV_COTDOC, LV_CONDOC
                                  FROM DUAL
                             )A
                         WHERE
                              A.PEPAIS = R8.PEPAIS
                          AND A.PETDOC = R8.PETDOC
                          AND A.PENDOC = R8.PENDOC
                     );
  
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
          BEGIN
  
            --INTEGRANTES PARTICIPARON EN UN CREDITO EN RECUPERACION LEGAL EN BANTOTAL
            FOR I IN C_CTAS  LOOP
              BEGIN
                 SELECT DISTINCT 'S'
                   INTO LC_RECLEG
                 FROM SNG410 G4
                WHERE
                      G4.SNG400COD = 1
                  AND G4.SNG410CTA = I.CTNRO
                  AND G4.SNG400EVTO IN (1101,1100)
                  AND G4.SNG410ITS <>999
                  AND G4.SNG410FECG IS NOT NULL;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    LC_RECLEG:='N';
                END;
                EXIT WHEN LC_RECLEG = 'S';
            END LOOP;
  
            --INTEGRANTES AVALARON UN CREDITO EN RECUPERACION LEGAL EN RECUPERACION LEGAL EN BANTOTAL
            IF(NVL(LC_RECLEG,'N')= 'N') THEN
  
              FOR I IN C_CTASAVAL  LOOP
                BEGIN
                   SELECT DISTINCT 'S'
                     INTO LC_RECLEG
                   FROM SNG410 G4
                  WHERE
                        G4.SNG400COD = 1
                    AND G4.SNG410CTA = I.CTNRO
                    AND G4.SNG400EVTO IN (1101,1100)
                    AND G4.SNG410ITS <>999
                    AND G4.SNG410FECG IS NOT NULL;
                  EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                      LC_RECLEG:='N';
                  END;
                  EXIT WHEN LC_RECLEG = 'S';
  
              END LOOP;
  
            END IF;
  
  
            --INTEGRANTES PARTICIPARON EN UN CREDITO EN RECUPERACION LEGAL EN SORFY
            IF(NVL(LC_RECLEG,'N')= 'N') THEN
              FOR I IN C_INTCTA  LOOP
                BEGIN
                  SELECT DISTINCT 'S'
                     INTO LC_RECLEG
                    FROM REC_LEG_SORFY_1 R
                   WHERE R.C_NUMDOC = I.NUMDOC;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    LC_RECLEG:='N';
                END;
  
                EXIT WHEN LC_RECLEG = 'S';
              END LOOP;
            END IF;
            --INTEGRANTES AVALARON UN CREDITO EN RECUPERACION LEGAL EN SORFY
            IF NVL(LC_RECLEG,'N') = 'N' THEN
                FOR I IN C_INTCTA  LOOP
                BEGIN
                    SELECT DISTINCT 'S'
                    INTO LC_RECLEG
                    FROM REC_LEG_SORFY RL
                    WHERE RL.C_NUMDOC = I.NUMDOC;
  
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    LC_RECLEG:='N';
                END;
                  EXIT WHEN LC_RECLEG = 'S';
                END LOOP;
            END IF;
  
          EXCEPTION
              WHEN NO_DATA_FOUND THEN
                   LC_RECLEG := 'N';
          END;
    END;
  
    RETURN LC_RECLEG;
  
    END;
    */
  -------------------------------------------------------------
  /*SOLICITUDES EN VUELO 
  
  NVL((SELECT CASE WHEN COUNT(*) > 0 THEN 'S' ELSE 'N' END
            FROM FSR008 F JOIN XWF700 X ON X.XWFEMPRESA = F.PGCOD
                                       AND X.XWFCUENTA = F.CTNRO
                                       AND X.XWFCAR3 = '1'
                          JOIN WFWRKITEMS W ON W.WFINSPRCID = X.XWFPRCINS
                                           AND W.WFTASKCOD IN (3, 7, 11, 55)
                                           AND W.WFSTSCOD NOT IN ('C','B','E','D')
                                           AND W.WFITEMID = (SELECT MAX(M.WFITEMID)
                                                             FROM WFWRKITEMS M
                                                             WHERE M.WFINSPRCID = W.WFINSPRCID
                                                            )
            WHERE F.PEPAIS = A.PEPAIS
              AND F.PETDOC = A.PETDOC
              AND F.PENDOC = RPAD(A.PENDOC,12,' ')
              AND F.TTCOD = 1
              AND F.CTTFIR = 'T'
              AND TRUNC(W.WFITEMINIT) <= TRUNC(TO_DATE('&FECPRO','YYYYMMDD'))),'N') SOL_EN_VUELO,
         
         NVL((SELECT CASE WHEN COUNT(*) > 0 THEN 'S' ELSE 'N' END
            FROM FSR008 F JOIN XWF700 X ON X.XWFEMPRESA = F.PGCOD
                                       AND X.XWFCUENTA = F.CTNRO
                                       AND X.XWFCAR3 = '1'
                          JOIN WFWRKITEMS W ON W.WFINSPRCID = X.XWFPRCINS
                                           AND W.WFTASKCOD IN (3, 7, 11, 55)
                                           AND W.WFSTSCOD NOT IN ('C','B','E','D')
                                           AND W.WFITEMID = (SELECT MAX(M.WFITEMID)
                                                             FROM WFWRKITEMS M
                                                             WHERE M.WFINSPRCID = W.WFINSPRCID
                                                            )
            WHERE F.PEPAIS = A.PEPAIS_CYG
              AND F.PETDOC = A.PETDOC_CYG
              AND F.PENDOC = RPAD(A.PENDOC_CYG,12,' ')
              AND F.TTCOD = 1
              AND F.CTTFIR = 'T'
              AND TRUNC(W.WFITEMINIT) <= TRUNC(TO_DATE('&FECPRO','YYYYMMDD'))),'N') SOL_EN_VUELO_CYG,
         NVL((SELECT CASE WHEN COUNT(*) > 0 THEN 'S' ELSE 'N' END
            FROM XWF700 X JOIN FSR008 F ON X.XWFCUENTA = F.CTNRO,
                 SNG120 S
           WHERE X.XWFEMPRESA = 1
             AND F.PEPAIS = A.PEPAIS
             AND F.PETDOC = A.PETDOC
             AND F.PENDOC = A.PENDOC
             AND (X.XWFMODULO IN
                 (SELECT MODULO
                     FROM FST111
                    WHERE DSCOD = 50
                      AND MODULO NOT IN (29, 33, 200)) OR -- MPOSTIGOC INC1373 04/10/18
                 X.XWFMODULO = 117)
             AND X.XWFPRCINS IN
                 (SELECT WFINSPRCID
                    FROM WFWRKITEMS WF
                   WHERE WF.WFINSPRCID = X.XWFPRCINS
                     AND WF.WFSTSCOD NOT IN ('C', 'D', 'B', 'E', 'T')
                     AND WF.WFITEMINIT =
                         (SELECT MAX(WFITEMINIT)
                            FROM WFWRKITEMS W
                           WHERE W.WFINSPRCID = X.XWFPRCINS
                             AND W.WFSTSCOD NOT IN ('C', 'D', 'B', 'E', 'T')
                             AND W.WFITEMSTSACT = 1
                                --AND WFTASKCOD <> 55  --20160623ABR
                             AND W.WFITEMINIT >=
                                 TO_DATE('2013.07.01', 'yyyy.mm.dd')) --20160519
                        --AND WFTASKCOD <> 55--20160623ABR
                     AND WF.WFITEMINIT >= TO_DATE('2013.07.01', 'yyyy.mm.dd')) --20160519
             AND S.SNG120INS = X.XWFPRCINS
             AND X.XWFCAR3 = '1'),'N') SOL_EN_VUELO2,
         NVL((SELECT CASE WHEN COUNT(*) > 0 THEN 'S' ELSE 'N' END
            FROM XWF700 X JOIN FSR008 F ON X.XWFCUENTA = F.CTNRO,
                 SNG120 S
           WHERE X.XWFEMPRESA = 1
             AND F.PEPAIS = A.PEPAIS_CYG
             AND F.PETDOC = A.PETDOC_CYG
             AND F.PENDOC = A.PENDOC_CYG
             AND (X.XWFMODULO IN
                 (SELECT MODULO
                     FROM FST111
                    WHERE DSCOD = 50
                      AND MODULO NOT IN (29, 33, 200)) OR -- MPOSTIGOC INC1373 04/10/18
                 X.XWFMODULO = 117)
             AND X.XWFPRCINS IN
                 (SELECT WFINSPRCID
                    FROM WFWRKITEMS WF
                   WHERE WF.WFINSPRCID = X.XWFPRCINS
                     AND WF.WFSTSCOD NOT IN ('C', 'D', 'B', 'E', 'T')
                     AND WF.WFITEMINIT =
                         (SELECT MAX(WFITEMINIT)
                            FROM WFWRKITEMS W
                           WHERE W.WFINSPRCID = X.XWFPRCINS
                             AND W.WFSTSCOD NOT IN ('C', 'D', 'B', 'E', 'T')
                             AND W.WFITEMSTSACT = 1
                                --AND WFTASKCOD <> 55  --20160623ABR
                             AND W.WFITEMINIT >=
                                 TO_DATE('2013.07.01', 'yyyy.mm.dd')) --20160519
                        --AND WFTASKCOD <> 55--20160623ABR
                     AND WF.WFITEMINIT >= TO_DATE('2013.07.01', 'yyyy.mm.dd')) --20160519
             AND S.SNG120INS = X.XWFPRCINS
             AND X.XWFCAR3 = '1'),'N') SOL_EN_VUELO_CYG2,*/
  -------------------------------------------------------------
  procedure sp_cr_CASTJUD(ln_tdoc    in number,
                          lc_ndoc    in varchar2,
                          lc_CastJud out varchar2) is
  
    ld_FchSBS   date;
    lc_docsbs   varchar2(5);
    lc_CodSbs   varchar2(10);
    ln_SaldCast number(17, 2);
    ln_SaldJud  number(17, 2);
  
  begin
  
    lc_CastJud := 'N';
  
    Begin
      -- Tipo de DOC para la RCC
      select to_char(a.tp1corr3)
        into lc_docsbs
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11111
         and a.tp1corr1 = 1
         and a.tp1corr2 = 3
         and a.tp1nro1 = ln_tdoc;
    exception
      when others then
        lc_docsbs := '0';
    End;
  
    begin
      select to_date(Tpnro, 'DD/MM/YYYY')
        into ld_FchSBS
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    exception
      when others then
        null;
    end;
  
    begin
      select c_codsbs
        into lc_CodSbs
        from CLDRCCI
       where D_FECPRE = ld_FchSBS
         and C_TDOCID = lc_docsbs
         and C_DOCIDE = lc_ndoc;
    exception
      when others then
        lc_CodSbs := null;
    end;
  
    if lc_CodSbs is not null then
    
      begin
      
        SELECT NVL(SUM(CC.N_SALCAP), 0)
          into ln_SaldCast
          FROM CLDRCCS CC
         WHERE CC.C_CODSBS = lc_CodSbs
           AND CC.D_FECPRE = ld_FchSBS
           AND (SUBSTR(CC.C_CUENTA, 1, 2) = '81' AND
               SUBSTR(CC.C_CUENTA, 4, 3) = '302');
      exception
        when others then
          ln_SaldCast := 0;
      end;
    
      begin
        SELECT NVL(SUM(CC.N_SALCAP), 0)
          into ln_SaldJud
          FROM CLDRCCS CC
         WHERE CC.C_CODSBS = lc_CodSbs
           AND CC.D_FECPRE = ld_FchSBS
           AND (SUBSTR(CC.C_CUENTA, 1, 2) = '14' AND
               SUBSTR(CC.C_CUENTA, 4, 1) IN ('6'));
      exception
        when others then
          ln_SaldJud := 0;
      end;
    
      if ln_SaldCast > 0 or ln_SaldJud > 0 then
        lc_CastJud := 'S';
      end if;
    end if;
  end sp_cr_CASTJUD;

  -------------------------------------------------------------
  --HASTA 20% CPP
  --RCC_FN_CPP_PJE(A.CODSBS,TO_DATE('&fecrcc','YYYYMMDD'),6,20) 

  procedure SP_RCC_CPP_PJE(ln_tdoc     in number,
                           lc_ndoc     in varchar2,
                           LC_TieneCPP out varchar2)
  
   IS
    LN_CUMPLE NUMBER;
    LD_FECINI DATE;
    lc_docsbs varchar2(5);
    ld_FchSBS date;
    lc_CodSbs varchar2(10);
  BEGIN
  
    Begin
      -- Tipo de DOC para la RCC
      select to_char(a.tp1corr3)
        into lc_docsbs
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11111
         and a.tp1corr1 = 1
         and a.tp1corr2 = 3
         and a.tp1nro1 = ln_tdoc;
    exception
      when others then
        lc_docsbs := '0';
    End;
  
    begin
      select to_date(Tpnro, 'DD/MM/YYYY')
        into ld_FchSBS
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    exception
      when others then
        null;
    end;
  
    begin
      select c_codsbs
        into lc_CodSbs
        from CLDRCCI
       where D_FECPRE = ld_FchSBS
         and C_TDOCID = lc_docsbs
         and C_DOCIDE = lc_ndoc;
    exception
      when others then
        lc_CodSbs := null;
    end;
  
    LD_FECINI := ADD_MONTHS(ld_FchSBS, ((-1) * 6));
    LN_CUMPLE := 0;
  
    begin
      SELECT SUM(CASE
                   WHEN CI.N_CALIF0 + CI.N_CALIF1 + CI.N_CALIF2 + CI.N_CALIF3 +
                        CI.N_CALIF4 = 0 THEN
                    0
                   WHEN CI.N_CALIF0 = 100 THEN
                    0
                   WHEN CI.N_CALIF2 + CI.N_CALIF3 + CI.N_CALIF4 = 0 AND
                        CI.N_CALIF1 <= 20 THEN
                    0
                   ELSE
                    1
                 END)
        INTO LN_CUMPLE
        FROM CLDRCCI CI
       WHERE CI.C_CODSBS = lc_CodSbs
         AND CI.D_FECPRE > LD_FECINI
         AND CI.D_FECPRE <= ld_FchSBS;
    exception
      when others then
        null;
    end;
  
    IF (LN_CUMPLE = 0 OR LN_CUMPLE IS NULL) THEN
      LC_TieneCPP := 'N';
    ELSE
      LC_TieneCPP := 'S';
    END IF;
  
  END SP_RCC_CPP_PJE;
  -------------------------------------------------------------
  --ENTIDADES TIT Y CONY
  procedure sp_cr_EntTitCony(ln_pais   in number,
                             ln_tdoc   in number,
                             ln_ndoc   in varchar2,
                             ln_NroEnt out number) is
  
    ln_paiscy   number;
    ln_tdoccy   number;
    lc_ndocy    varchar2(12);
    lc_docsbs   number;
    ld_FchSBS   date;
    lc_CodSbsCy varchar2(10);
    lc_CodSbs   varchar2(10);
  
  begin
    Begin
      -- Tipo de DOC para la RCC
      select to_char(a.tp1corr3)
        into lc_docsbs
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11111
         and a.tp1corr1 = 1
         and a.tp1corr2 = 3
         and a.tp1nro1 = ln_tdoc;
    exception
      when others then
        lc_docsbs := '0';
    End;
  
    begin
      select to_date(Tpnro, 'DD/MM/YYYY')
        into ld_FchSBS
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    exception
      when others then
        null;
    end;
  
    begin
      select c_codsbs
        into lc_CodSbs
        from CLDRCCI
       where D_FECPRE = ld_FchSBS
         and C_TDOCID = lc_docsbs
         and C_DOCIDE = ln_ndoc;
    exception
      when others then
        lc_CodSbs := null;
    end;
  
    begin
      select f.rppais, f.rptdoc, f.rpndoc
        into ln_paiscy, ln_tdoccy, lc_ndocy
        from fsr002 f
       where f.pepais = ln_pais
         and f.petdoc = ln_tdoc
         and f.pendoc = ln_ndoc
         and f.rpccyg = 66;
    exception
      when others then
        begin
          select g.pepais, g.petdoc, g.pendoc
            into ln_paiscy, ln_tdoccy, lc_ndocy
            from fsr002 g
           where g.rppais = ln_pais
             and g.rptdoc = ln_tdoc
             and g.rpndoc = ln_ndoc
             and g.rpccyg = 66;
        exception
          when others then
            null;
        end;
    end;
  
    Begin
      -- Tipo de DOC para la RCC
      select to_char(a.tp1corr3)
        into lc_docsbs
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11111
         and a.tp1corr1 = 1
         and a.tp1corr2 = 3
         and a.tp1nro1 = ln_tdoccy;
    exception
      when others then
        lc_docsbs := '0';
    End;
  
    begin
      select c_codsbs
        into lc_CodSbsCy
        from CLDRCCI
       where D_FECPRE = ld_FchSBS
         and C_TDOCID = lc_docsbs
         and C_DOCIDE = lc_ndocy;
    exception
      when others then
        lc_CodSbsCy := null;
    end;
  
    begin
      SELECT /*+ALL_ROWS*/
       COUNT(DISTINCT CC.C_CODEMP)
        into ln_NroEnt
        FROM CLDRCCS CC
       WHERE CC.C_CODSBS IN (lc_CodSbs, lc_CodSbsCy)
         AND CC.D_FECPRE = ld_FchSBS
         AND ((SUBSTR(CC.C_CUENTA, 1, 2) = '14' AND
             SUBSTR(CC.C_CUENTA, 4, 1) IN ('1', '3', '4', '5', '6')) --CREDITOS DIRECTOS
             OR (SUBSTR(CC.C_CUENTA, 1, 2) = '71' AND
             SUBSTR(CC.C_CUENTA, 4, 1) IN ('1', '2', '3', '4')) --CREDITOS INDIRECTOS
             OR (SUBSTR(CC.C_CUENTA, 1, 2) = '81' AND
             SUBSTR(CC.C_CUENTA, 4, 3) = '302') --CREDITOS CASTIGADOS
             OR (SUBSTR(CC.C_CUENTA, 1, 2) = '72' AND
             SUBSTR(CC.C_CUENTA, 4, 1) = '5') --LINEAS NO UTILIZADAS Y CREDITOS OTORGADOS NO DESEMBOLSADOS
             );
    exception
      when others then
        null;
    end;
  
  end sp_cr_EntTitCony;
  -----------------------------------------------------------------
  procedure CRE_MAX_ATR_VIG_CLI_DOC(PD_FECPRO IN DATE,
                                    PN_PAIS   IN NUMBER,
                                    PN_TIPDOC IN NUMBER,
                                    PC_NUMDOC IN VARCHAR2,
                                    LN_PROATR out number) IS
  begin
  
    BEGIN
      SELECT ATRA
        INTO LN_PROATR
        FROM (SELECT MAX(CASE
                           WHEN NVL(B.PP1FECH, PD_FECPRO) - A.PPFPAG > 0 THEN
                            NVL(B.PP1FECH, PD_FECPRO) - A.PPFPAG
                           ELSE
                            NULL
                         END) ATRA
                FROM FSD601 A
                LEFT JOIN FSD602 B
                  ON B.PGCOD = A.PGCOD
                 AND B.PPMOD = A.PPMOD
                 AND B.PPSUC = A.PPSUC
                 AND B.PPMDA = A.PPMDA
                 AND B.PPPAP = A.PPPAP
                 AND B.PPCTA = A.PPCTA
                 AND B.PPOPER = A.PPOPER
                 AND B.PPSBOP = A.PPSBOP
                 AND B.PPTOPE = A.PPTOPE
                 AND B.PPFPAG = A.PPFPAG
                 AND B.PPTIPO = A.PPTIPO
                 AND B.PP1STAT = 'T'
                 AND B.D602CO = 'S'
                 AND B.PP1FECH <= PD_FECPRO
               WHERE A.PPFPAG <= PD_FECPRO
                 AND A.D601CO = 'S'
                 AND (A.PPCAP + A.PPINT) > 0
                 AND EXISTS
               (SELECT 1
                        FROM FSR008 R8, FSD010 D10
                       WHERE D10.PGCOD = R8.PGCOD
                         AND D10.AOCTA = R8.CTNRO
                         AND D10.AOMOD IN
                             (SELECT MODULO
                                FROM FST111
                               WHERE DSCOD = 50
                                 AND MODULO NOT IN (29, 120))
                         AND D10.AOMOD NOT IN (33, 141, 200)
                         AND D10.AOTOPE <> 550
                         AND (CASE
                               WHEN D10.AOSTAT <> 99 THEN
                                1
                               ELSE
                                0
                             END) = 1
                         AND R8.PEPAIS = PN_PAIS
                         AND R8.PETDOC = PN_TIPDOC
                         AND R8.PENDOC = RPAD(PC_NUMDOC, 12, ' ')
                         AND R8.TTCOD = 1
                         AND R8.CTTFIR = 'T'
                         AND D10.PGCOD = A.PGCOD
                         AND D10.AOMOD = A.PPMOD
                         AND D10.AOSUC = A.PPSUC
                         AND D10.AOMDA = A.PPMDA
                         AND D10.AOPAP = A.PPPAP
                         AND D10.AOCTA = A.PPCTA
                         AND D10.AOOPER = A.PPOPER
                         AND D10.AOSBOP = A.PPSBOP
                         AND D10.AOTOPE = A.PPTOPE));
    EXCEPTION
      WHEN OTHERS THEN
        LN_PROATR := 0;
    end;
  END CRE_MAX_ATR_VIG_CLI_DOC;
  --------------------------------------------------------------------
  procedure CRE_FN_ATR_PROM_CLI_DOC(PD_FECPRO IN DATE,
                                    PD_FECINI IN DATE,
                                    PN_PAIS   IN NUMBER,
                                    PN_TIPDOC IN NUMBER,
                                    PC_NUMDOC IN VARCHAR2,
                                    LN_PROATR out number) is
  
  begin
    BEGIN
      SELECT CASE
               WHEN SUM(NROCUO) > 0 THEN
                ROUND(SUM(ATRACUM) / SUM(NROCUO), 2)
               ELSE
                0
             END
        INTO LN_PROATR
        FROM (SELECT /*+PARALLEL(A,16) PARALLEL(B,16)*/
               SUM(CASE
                     WHEN NVL(B.PP1FECH, PD_FECPRO) - A.PPFPAG > 0 THEN
                      NVL(B.PP1FECH, PD_FECPRO) - A.PPFPAG
                     ELSE
                      0
                   END) ATRACUM,
               COUNT(*) NROCUO
                FROM FSD601 A
                LEFT JOIN FSD602 B
                  ON B.PGCOD = A.PGCOD
                 AND B.PPMOD = A.PPMOD
                 AND B.PPSUC = A.PPSUC
                 AND B.PPMDA = A.PPMDA
                 AND B.PPPAP = A.PPPAP
                 AND B.PPCTA = A.PPCTA
                 AND B.PPOPER = A.PPOPER
                 AND B.PPSBOP = A.PPSBOP
                 AND B.PPTOPE = A.PPTOPE
                 AND B.PPFPAG = A.PPFPAG
                 AND B.PPTIPO = A.PPTIPO
                 AND B.PP1STAT = 'T'
                 AND B.D602CO = 'S'
                 AND B.PP1FECH <= PD_FECPRO
              
               WHERE A.PPFPAG >= PD_FECINI
                 AND A.PPFPAG <= PD_FECPRO
                 AND A.D601CO = 'S'
                 AND (A.PPCAP + A.PPINT) > 0
                 AND EXISTS
               (SELECT /*+PARALLEL(R8,16) PARALLEL(D10,16)*/
                       1
                        FROM FSR008 R8, FSD010 D10
                       WHERE D10.PGCOD = R8.PGCOD
                         AND D10.AOCTA = R8.CTNRO
                         AND D10.AOMOD IN
                             (SELECT MODULO
                                FROM FST111
                               WHERE DSCOD = 50
                                 AND MODULO NOT IN (29, 120))
                         AND D10.AOMOD NOT IN (33, 141, 200)
                         AND D10.AOTOPE <> 550
                         AND (CASE
                               WHEN D10.AOSTAT <> 99 THEN
                                1
                               WHEN (D10.AOSTAT = 99 AND
                                    D10.AOFE99 >
                                    TO_DATE('2013.06.30', 'RRRR.MM.DD')) THEN
                                1
                               ELSE
                                0
                             END) = 1
                         AND R8.PEPAIS = PN_PAIS
                         AND R8.PETDOC = PN_TIPDOC
                         AND R8.PENDOC = RPAD(PC_NUMDOC, 12, ' ')
                         AND R8.TTCOD = 1
                         AND R8.CTTFIR = 'T'
                         AND D10.PGCOD = A.PGCOD
                         AND D10.AOMOD = A.PPMOD
                         AND D10.AOSUC = A.PPSUC
                         AND D10.AOMDA = A.PPMDA
                         AND D10.AOPAP = A.PPPAP
                         AND D10.AOCTA = A.PPCTA
                         AND D10.AOOPER = A.PPOPER
                         AND D10.AOSBOP = A.PPSBOP
                         AND D10.AOTOPE = A.PPTOPE)
                 AND EXISTS
               (SELECT 1
                        FROM FST034 T34
                       WHERE T34.PGCOD = B.D602CD
                         AND T34.TRMOD = B.D602MO
                         AND T34.TRNRO = B.D602TR
                         AND UPPER(T34.TRNOM) IN
                             ('!NORMALIZATE!                 ',
                              'ACUERDO PARA CANCELACIÓN TOTAL',
                              'AMPLIACION DE CREDITOS        ',
                              'AMPLIACION DE CREDITOS (MOVIL)',
                              'CANC. DE PRESTAMOS CONVENIOS  ',
                              'CANCELACION TOTAL             ',
                              'CANCELACION TOTAL FEC VAL CONV',
                              'CANCELACION TOTAL FECHA VALOR ',
                              'CANCELACION TOTAL PRENDARIO   ',
                              'CANCELACION TOTAL RL          ',
                              'COBRO DE CUOTA BATCH          ',
                              'CUOTA MOVIL                   ',
                              'FALLECIDOS VIGENTES           ',
                              'INCREMENTO LINEA DE CREDITO   ',
                              'INCREMENTO LINEA DE CREDITO FV',
                              'P.PARCIAL FECHA VALOR KASNET  ',
                              'PAGO CAMP NO TE QUEDES EN ROJO',
                              'PAGO CREDITO BANBIF           ',
                              'PAGO CREDITO BANBIF-INTERAC   ',
                              'PAGO CREDITO CORRESP.-BN      ',
                              'PAGO CREDITO CORRESP.-INTERAC ',
                              'PAGO CREDITO INTERBANK        ',
                              'PAGO CREDITO INTERBANK-INTERAC',
                              'PAGO CREDITO POR IB           ',
                              'PAGO CREDITO SCOTIABANK       ',
                              'PAGO CREDITO SCOTI-INTERAC    ',
                              'PAGO CREDITO VENT.COMPART.-BN ',
                              'PAGO DE CREDITO - AGENTE      ',
                              'PAGO DE CREDITO - CM          ',
                              'PAGO DE CREDITO - GLOBOKAS    ',
                              'PAGO EMERG CON FECHA VALOR    ', ---?
                              'PAGO PARCIAL                  ',
                              'PAGO PARCIAL CON FECHA VALOR  ',
                              'PAGO PARCIAL FECHA VALOR CONVE',
                              'PAGO PARCIAL RL               ',
                              'PAGO PARCIAL RL CAMPAÑAS      ',
                              'PSJE. REFINA. A JUDIC-CANCE.  ',
                              'CANCELACION TOTAL EX- TRA     ',
                              'COMPENSACION AUTOMATICA       ',
                              'DESEMBOLSOS PARCIALES         ',
                              'PAGO PARCIAL EX- TRABAJADORES ',
                              'PAGO PARCIAL FECHA VALOR- BANC',
                              'PAGO CREDITO BCP-INTERAC      ',
                              'PAGO CREDITO BCP              ',
                              'PAGO CREDITO VENT.COMP.-INTERA')));
    
    EXCEPTION
      WHEN OTHERS THEN
        LN_PROATR := 0;
    END;
  end;

------------------------------------------------------------------
end PQ_CR_RTE_CLIENTE_CAMPANIA;
/

