CREATE OR REPLACE PACKAGE PQ_CR_MIGRA_EVALUACION is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_EXPERIAN
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2014.11.24
  -- Autor de Creación          : CMAC-SFERNANDEM
  -- Uso                        : Migracion de bd evaluacion a bantotal
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2017.02.20
  -- Autor de Modificación      : DCASTRO
  -- Descripción de Modificación: Se modifico procedimiento sp_cr_migracion, sp_cr_migra_batch
  --
  --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_migracion(P_INSTANCIA in number,
                            P_ERROR     out varchar2,
                            P_USU2      in varchar2,
                            P_FECHA     in date,
                            P_HORA      in varchar2);
  ------------------------------------------------------------                             
  Procedure sp_cr_migra_batch(P_INSTANCIA in number,
                              P_USU       in varchar2,
                              P_FECHA     in date,
                              P_HORA      in varchar2,
                              P_EVAL      out number);
  ---------------------------------------------------------                                                     
  Procedure sp_cr_migracion_batch(P_SUCUR in number);
  ---------------------------------------------------------
  procedure sp_cr_migracion_batch_job;
  ---------------------------------------------------------
  Procedure sp_cr_consulta_evaluacion(P_INSTANCIA in number,
                                      P_PAIS      in number,
                                      P_TDOC      in number,
                                      P_NDOC      in varchar2,
                                      P_MAQUINA   IN varchar2);
  ---------------------------------------------------------
  Procedure sp_cr_ultima_evaluacion(pn_instDES in number,
                                    P_ERROR    out varchar2);
  ---------------------------------------------------------                                  
  Procedure sp_cr_Saldo_Deudor(pn_NumIns in number, pc_FlgRes out varchar2);
  ---------------------------------------------
  Procedure sp_cr_sng120(pn_NumIns in number, pc_FlgRes out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

end PQ_CR_MIGRA_EVALUACION;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_MIGRA_EVALUACION is

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_migracion(P_INSTANCIA in number,
                            P_ERROR     out varchar2,
                            P_USU2      in varchar2,
                            P_FECHA     in date,
                            P_HORA      in varchar2) IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_limpia_direccion_trigger
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2015.04.27
    -- Autor de Creación          : CMAC - SFERNANDEM
    -- Uso                        : MIGRA DE BASE DE EVALUACION de BD evalucion a BT 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_PAIS ,P_TDOC,P_NDOC,P_DOCOD,P_CORR,P_UGEO
    --                            : P_DPTO,P_PROV,P_DIST,P_DIRECCION
    -- Parámetros de Salida       :
    -- Fecha de Modificación      : 2017.02.20
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: Se modifico para retornar maxima evaluacion por instancia
    -- Fecha de Modificación      : 02/08/2017
    -- Autor de la Modificación   : HLAQUI
    -- Descripción de Modificación: Se agrega logica para la migracion de la deuda del RCC
    -- *****************************************************************
  
    l_nroeval      sng021.sng021eval%type;
    l_pdoc         sng021.sng021pdoc%type;
    l_tdoc         sng021.sng021tdoc%type;
    l_ndoc         sng021.sng021ndoc%type;
    l_tmod         sng021.sng021tmod%type;
    l_dfec         sng021.sng021fec%type;
    l_max_eval     sng021.sng021eval%type;
    l_FVto         sng120.sng120fvto%type;
    l_max_leido    number(10) := 0;
    l_max_log      number(10) := 0;
    P_USU          varchar2(30);
    l_sng001ase    sng001.sng001ase%type;
    L_FECHA        fst017.pgfape%type;
    L_sng021obs1   VARCHAR2(400);
    L_sng021obs2   VARCHAR2(400);
    L_sng021obs3   VARCHAR2(400);
    lc_coderr      varchar2(500);
    lc_msgerr      varchar2(500);
    ln_jaqy327corr numeric(10);
  begin
    -- P_USU:=P_USU2;
    BEGIN
      select sng001ase
        into l_sng001ase
        from sng001
       where sng001inst = P_INSTANCIA;
      select pgfape into L_FECHA from fst017 where pgcod = 1;
      select trim(rr.sng057sup)
        into P_USU
        from sng057 rr
       where rr.sng057usr = l_sng001ase
         and rr.sng057ini <= L_FECHA
         and rr.sng057fin >= L_FECHA;
    EXCEPTION
      when no_data_found then
        P_USU := trim(l_sng001ase);
      WHEN others THEN
        return;
    END;
  
    BEGIN
      p_error := 'IMPORTACION EXITOSA';
      /*     20170220
       select c.sng021eval, c.sng021pdoc, c.sng021tdoc, c.sng021ndoc,c.sng021tmod
       into l_nroeval, l_pdoc, l_tdoc, l_ndoc,l_tmod
       from sng021 c
      where c.sng021sol = p_instancia; -- p_instancia
       */
    
      --debe retornar maxima evaluacion
      select c.sng021eval,
             c.sng021pdoc,
             c.sng021tdoc,
             c.sng021ndoc,
             c.sng021tmod
        into l_nroeval, l_pdoc, l_tdoc, l_ndoc, l_tmod
        from sng021 c
       where c.sng021sol = p_instancia
         and c.sng021eval in
             (select max(d.sng021eval)
                from sng021 d
               where d.sng021sol = p_instancia);
    
    EXCEPTION
      WHEN no_data_found THEN
        p_error := 'NO HAY NRO DE EVALUACION EN BT';
        return;
    END;
  
    IF (l_tmod = 13) THEN
      /*Ev. independiente*/
      BEGIN
        select nvl(max(sng021eval), 0)
          into l_max_eval
          from SNG021SQL@eval
         where sng021pdoc = l_pdoc
           and sng021tdoc = l_tdoc
           and SNG021NDOC = l_ndoc
           and sng021fgest <> 2 --anulada
           and sng021fgpro = 0 --no leida
           and SNG021USU = trim(P_USU)
           and sng021tmod = 13;
      
        if (l_max_eval = 0) then
          p_error := 'NO HAY  EVALUACION WEB';
          return;
        End if;
      
        delete from sng023
         where sng021eval = l_nroeval
           and sng026cod in (select tpnro
                               from fst098
                              where pgcod = 1
                                and tpcod = 7690
                                and tpimp = 1
                             union all
                             select tpnro
                               from fst098
                              where pgcod = 1
                                and tpcod = 7690
                                and tpnro in (13,
                                              14,
                                              15,
                                              16,
                                              17,
                                              18,
                                              19,
                                              20,
                                              513,
                                              514,
                                              515,
                                              516,
                                              517,
                                              518,
                                              519,
                                              520)); /*Ev. independiente*/
        commit;
      
        insert into sng023
          select l_nroeval, R.sng026cod, R.sng023mto
            from (select tpnro
                    from fst098
                   where pgcod = 1
                     and tpcod = 7690
                     and tpimp = 1
                  union all
                  select tpnro
                    from fst098
                   where pgcod = 1
                     and tpcod = 7690
                     and tpnro in (13,
                                   14,
                                   15,
                                   16,
                                   17,
                                   18,
                                   19,
                                   20,
                                   513,
                                   514,
                                   515,
                                   516,
                                   517,
                                   518,
                                   519,
                                   520)) S
           inner join (SELECT a.sng021pdoc,
                              a.sng021tdoc,
                              a.sng021ndoc,
                              b.sng021eval,
                              b.sng026cod,
                              b.sng023mto
                         from SNG021SQL@eval a, SNG023SQL@eval b
                        Where a.sng021eval = b.sng021eval
                          and a.sng021eval = l_max_eval) R
              on S.TPNRO = R.sng026cod;
        commit;
        --HLAQUI 02/08/2017
        /********************GASTOS FINANCIEROS***********************/
        /*
        select nvl(max(JAQY327CORR),1) into ln_jaqy327corr from JAQY327 Where JAQY327FECH = L_FECHA;
             
        update JAQY327 
        set JAQY327ESTA = 'N'
        where JAQY327INST = p_instancia and JAQY327ESTA='S';
        commit;
                     
        insert into JAQY327
        (JAQY327CORR, JAQY327FECH, JAQY327HORA, JAQY327INST, JAQY327NEVA, JAQY327PAIS,
         JAQY327TDOC, JAQY327NDOC, JAQY327RUBR, JAQY327ESTA, JAQY327ENTI, JAQY327TCRE,
         JAQY327SDEU, JAQY327PLAZ, JAQY327TAZA, JAQY327CCALC, JAQY327GFIN, JAQY327FRCC, 
         JAQY327DORI, JAQY327CHEK)
        
        select rownum + ln_jaqy327corr, L_FECHA, to_char( CURRENT_TIMESTAMP, 'HH24:MI:SS' ),
        p_instancia, l_nroeval, a.jaqz343pais, a.jaqz343tdoc, a.jaqz343ndoc, a.jaqz343rubr, 'S',
        a.jaqz343enti, a.jaqz343tcre, a.jaqz343sdeu, a.jaqz343plaz, a.jaqz343taza, a.jaqz343ccalc,
        a.jaqz343gfin, a.jaqz343frcc, '1', '1'
        from JAQZ343@eval a 
        where 
        a.jaqz343neva = l_max_eval
        and a.jaqz343esta='S';
        commit;
        */
        /*************************************************************/
      
      EXCEPTION
        WHEN others THEN
          p_error := 'ERROR AL INSERTAR';
      END;
    END IF; /*FIn EVALUACION independiente*/
  
    IF (l_tmod = 14) THEN
      /*Ev. Dependiente*/
      BEGIN
        select nvl(max(sng021eval), 0)
          into l_max_eval
          from SNG021SQL@eval
         where sng021pdoc = l_pdoc
           and sng021tdoc = l_tdoc
           and SNG021NDOC = l_ndoc
           and sng021fgest <> 2 --anulado
           and sng021fgpro = 0 --no leida
           and SNG021USU = trim(P_USU)
           and sng021tmod = 14;
      
        if (l_max_eval = 0) then
          p_error := 'NO HAY EVALUACION WEB';
          return;
        End if;
      
        delete from sng023
         where sng021eval = l_nroeval
           and sng026cod in (select tpnro
                               from fst098
                              where pgcod = 1
                                and tpcod = 7690
                                and tpimp = 2); /*Ev. Dependiente*/
        commit;
      
        insert into sng023
          select l_nroeval, R.sng026cod, R.sng023mto
            from (select tpnro
                    from fst098
                   where pgcod = 1
                     and tpcod = 7690
                     and tpimp = 2) S
           inner join (SELECT a.sng021pdoc,
                              a.sng021tdoc,
                              a.sng021ndoc,
                              b.sng021eval,
                              b.sng026cod,
                              b.sng023mto
                         from SNG021SQL@eval a, SNG023SQL@eval b
                        Where a.sng021eval = b.sng021eval
                          and a.sng021eval = l_max_eval) R
              on S.TPNRO = R.sng026cod;
        commit;
      
        /*BOTON ACTIVOS Y PASIVOS DE LA EVALUACION*/
        delete from SNG028 where sng021eval = l_nroeval;
        commit;
        insert into SNG028
          (SNG021EVAL,
           SNG026COD,
           SNG028LIN,
           SNG028MTO1,
           SNG028MTO2,
           SNG028MTO3,
           SNG028MTO4,
           SNG028MDA1,
           SNG028MDA2,
           SNG028MDA3,
           SNG028MDA4,
           SNG028TXT1,
           SNG028TXT2,
           SNG028TXT3,
           SNG028CON1,
           SNG028CON2,
           SNG028CON3,
           SNG028CAN1,
           SNG028CAN2,
           SNG028CAN3,
           SNG028CAN4,
           SNG028TXL1,
           SNG028TXL2,
           SNG028TXL3)
          select l_nroeval,
                 SNG026COD,
                 SNG028LIN,
                 SNG028MTO1,
                 SNG028MTO2,
                 SNG028MTO3,
                 SNG028MTO4,
                 SNG028MDA1,
                 SNG028MDA2,
                 SNG028MDA3,
                 SNG028MDA4,
                 SNG028TXT1,
                 SNG028TXT2,
                 SNG028TXT3,
                 SNG028CON1,
                 SNG028CON2,
                 SNG028CON3,
                 SNG028CAN1,
                 SNG028CAN2,
                 SNG028CAN3,
                 SNG028CAN4,
                 SNG028TXL1,
                 SNG028TXL2,
                 SNG028TXL3
            from sng028sql@eval
           where SNG021EVAL = l_max_eval;
        commit;
      
      EXCEPTION
        WHEN others THEN
          p_error := 'ERROR AL INSERTAR';
      END;
    END IF; /*FIn EVALUACION DEPENDIENTE*/
  
    BEGIN
      --OBSERVACIONES
      select trim(sng021obs1), trim(sng021obs2), trim(sng021obs3)
        into L_sng021obs1, L_sng021obs2, L_sng021obs3 /*Codigos: 73,74,75*/
        from SNG021SQL@eval
       where sng021eval = l_max_eval;
    
      delete from sng031 s
       where s.sng001inst = p_instancia
         and s.sng027cod in (select tpnro
                               from fst098
                              Where pgcod = 1
                                and tpcod = 7690
                                and tpcorr >= 200
                                and tpcorr <= 202);
    
      commit;
      insert into sng031 values (p_instancia, 73, L_sng021obs1);
      commit;
      insert into sng031 values (p_instancia, 74, L_sng021obs2);
      commit;
      insert into sng031 values (p_instancia, 75, L_sng021obs3);
      commit;
    EXCEPTION
      WHEN others THEN
        lc_coderr := sqlcode;
        lc_msgerr := sqlerrm;
        p_error   := 'ERROR AL INSERTAR';
        return;
    END; /*FIn OBSERVACIONES*/
  
    BEGIN
      select sng021fec
        into l_dfec
        from SNG021SQL@eval
       where sng021eval = l_max_eval;
    
      Update sng021 set sng021fec = l_dfec where sng021sol = p_instancia;
      COMMIT;
    
      l_max_leido := 2;
    
      update SNG021SQL@eval a
         set a.sng021fgpro = l_max_leido, a.sng021fgest = l_max_leido
       where a.sng021eval = l_max_eval;
      commit;
    
      select nvl(max(jaqy736corr), 0) + 1 --cantidad de lectura
        into l_max_log
        from jaqy736
       where jaqy736usu = trim(P_USU);
    
      select sng021eeff
        into l_FVto
        from SNG021SQL@eval
       Where sng021eval = l_max_eval;
    
      update SNG120
         set SNG120FVto = l_FVto, sng120fpag = l_dfec ---??
       where sng120ins = p_instancia
         and SNG120Tsk = 'EVALUACION';
      commit;
    
      insert into jaqy736
      values
        (l_max_log, p_fecha, p_hora, p_usu, p_instancia, l_max_eval);
      commit;
    EXCEPTION
      WHEN others THEN
        p_error := 'ERROR AL INSERTAR';
    END;
  
  END sp_cr_migracion;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_migra_batch(P_INSTANCIA in number,
                              P_USU       in varchar2,
                              P_FECHA     in date,
                              P_HORA      in varchar2,
                              P_EVAL      out number) IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_limpia_direccion_trigger
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2015.04.27
    -- Autor de Creación          : CMAC - SFERNANDEM
    -- Uso                        : MIGRA DE BASE DE EVALUACION de BD evalucion a BT 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_PAIS ,P_TDOC,P_NDOC,P_DOCOD,P_CORR,P_UGEO
    --                            : P_DPTO,P_PROV,P_DIST,P_DIRECCION
    -- Parámetros de Salida       :
    -- Fecha de Modificación      : 2017.02.20
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: Se modifico para obtener ultima evaluacion por instancia
    -- Fecha de Modificación      : 02/08/2017
    -- Autor de la Modificación   : HLAQUI
    -- Descripción de Modificación: Se agrega logica para la migracion de la deuda del RCC
    -- *****************************************************************
  
    l_nroeval  sng021.sng021eval%type;
    l_pdoc     sng021.sng021pdoc%type;
    l_tdoc     sng021.sng021tdoc%type;
    l_ndoc     sng021.sng021ndoc%type;
    l_tmod     sng021.sng021tmod%type;
    l_dfec     sng021.sng021fec%type;
    l_max_eval sng021.sng021eval%type;
    l_FVto     sng120.sng120fvto%type;
    -- l_max_leido number(10):=0;
    l_max_log      number(10) := 0;
    lc_coderr      varchar2(500);
    lc_msgerr      varchar2(500);
    L_sng021obs1   VARCHAR2(400);
    L_sng021obs2   VARCHAR2(400);
    L_sng021obs3   VARCHAR2(400);
    L_FECHA        fst017.pgfape%type;
    ln_jaqy327corr numeric(10);
  
  begin
    BEGIN
    
      /*     20170220
       select c.sng021eval, c.sng021pdoc, c.sng021tdoc, c.sng021ndoc,c.sng021tmod
       into l_nroeval, l_pdoc, l_tdoc, l_ndoc,l_tmod
       from sng021 c
      where c.sng021sol = p_instancia; -- p_instancia
       */
      select pgfape into L_FECHA from fst017 where pgcod = 1;
      --debe retornar maxima evaluacion
      select c.sng021eval,
             c.sng021pdoc,
             c.sng021tdoc,
             c.sng021ndoc,
             c.sng021tmod
        into l_nroeval, l_pdoc, l_tdoc, l_ndoc, l_tmod
        from sng021 c
       where c.sng021sol = p_instancia
         and c.sng021eval in
             (select max(d.sng021eval)
                from sng021 d
               where d.sng021sol = p_instancia);
    
    EXCEPTION
      WHEN no_data_found THEN
        return;
      WHEN others THEN
        return;
    END;
  
    IF (l_tmod = 13) THEN
      /*Ev. independiente*/ --falta activar si el usuario ha ingresado la solicitud
      BEGIN
        select nvl(max(sng021eval), 0)
          into l_max_eval
          from SNG021SQL@eval
         where sng021pdoc = l_pdoc
           and sng021tdoc = l_tdoc
           and SNG021NDOC = l_ndoc
           and sng021fgest = 1 --terminada
           and sng021fgpro = 0 --no leida
           and SNG021USU = trim(P_USU);
      
        if (l_max_eval = 0) then
          return;
        End if;
      
        delete from sng023
         where sng021eval = l_nroeval
           and sng026cod in (select tpnro
                               from fst098
                              where pgcod = 1
                                and tpcod = 7690
                                and tpimp = 1
                             union all
                             select tpnro
                               from fst098
                              where pgcod = 1
                                and tpcod = 7690
                                and tpnro in (13,
                                              14,
                                              15,
                                              16,
                                              17,
                                              18,
                                              19,
                                              20,
                                              513,
                                              514,
                                              515,
                                              516,
                                              517,
                                              518,
                                              519,
                                              520)); /*Ev. independiente*/
        commit;
      
        insert into sng023
          select l_nroeval, R.sng026cod, R.sng023mto
            from (select tpnro
                    from fst098
                   where pgcod = 1
                     and tpcod = 7690
                     and tpimp = 1
                  union all
                  select tpnro
                    from fst098
                   where pgcod = 1
                     and tpcod = 7690
                     and tpnro in (13,
                                   14,
                                   15,
                                   16,
                                   17,
                                   18,
                                   19,
                                   20,
                                   513,
                                   514,
                                   515,
                                   516,
                                   517,
                                   518,
                                   519,
                                   520)) S
           inner join (SELECT a.sng021pdoc,
                              a.sng021tdoc,
                              a.sng021ndoc,
                              b.sng021eval,
                              b.sng026cod,
                              b.sng023mto
                         from SNG021SQL@eval a, SNG023SQL@eval b
                        Where a.sng021eval = b.sng021eval
                          and a.sng021eval = l_max_eval) R
              on S.TPNRO = R.sng026cod;
        commit;
      
        --HLAQUI 02/08/2017
        /********************GASTOS FINANCIEROS***********************/
        /*
        select nvl(max(JAQY327CORR),1) into ln_jaqy327corr from JAQY327 Where JAQY327FECH = L_FECHA;
          
        update JAQY327 
        set JAQY327ESTA = 'N'
        where JAQY327INST = p_instancia and JAQY327ESTA='S';
        commit;
                                  
        insert into JAQY327
        (JAQY327CORR, JAQY327FECH, JAQY327HORA, JAQY327INST, JAQY327NEVA, JAQY327PAIS,
         JAQY327TDOC, JAQY327NDOC, JAQY327RUBR, JAQY327ESTA, JAQY327ENTI, JAQY327TCRE,
         JAQY327SDEU, JAQY327PLAZ, JAQY327TAZA, JAQY327CCALC, JAQY327GFIN, JAQY327FRCC, 
         JAQY327DORI, JAQY327CHEK)          
        select rownum + ln_jaqy327corr, L_FECHA, to_char( CURRENT_TIMESTAMP, 'HH24:MI:SS' ),
        p_instancia, l_nroeval, a.jaqz343pais, a.jaqz343tdoc, a.jaqz343ndoc, a.jaqz343rubr, 'S',
        a.jaqz343enti, a.jaqz343tcre, a.jaqz343sdeu, a.jaqz343plaz, a.jaqz343taza, a.jaqz343ccalc,
        a.jaqz343gfin, a.jaqz343frcc, '1', '1'
        from JAQZ343@eval a where 
        a.jaqz343neva = l_max_eval
        and a.jaqz343esta='S';
        commit  ;
        */
        /*************************************************************/
      
      EXCEPTION
        WHEN others THEN
          return;
      END;
    END IF; /*FIN EV. INDEPENDIENTE */
    IF (l_tmod = 14) THEN
      /*EV. DEPENDIENTE */
      BEGIN
        select nvl(max(sng021eval), 0)
          into l_max_eval
          from SNG021SQL@eval
         where sng021pdoc = l_pdoc
           and sng021tdoc = l_tdoc
           and SNG021NDOC = l_ndoc
           and sng021fgest = 1 --terminada
           and sng021fgpro = 0 --no leida
           and SNG021USU = trim(P_USU);
      
        if (l_max_eval = 0) then
          return;
        End if;
      
        delete from sng023
         where sng021eval = l_nroeval
           and sng026cod in (select tpnro
                               from fst098
                              where pgcod = 1
                                and tpcod = 7690
                                and tpimp = 2);
        commit;
      
        insert into sng023
          select l_nroeval, R.sng026cod, R.sng023mto
            from (select tpnro
                    from fst098
                   where pgcod = 1
                     and tpcod = 7690
                     and tpimp = 2) S
           inner join (SELECT a.sng021pdoc,
                              a.sng021tdoc,
                              a.sng021ndoc,
                              b.sng021eval,
                              b.sng026cod,
                              b.sng023mto
                         from SNG021SQL@eval a, SNG023SQL@eval b
                        Where a.sng021eval = b.sng021eval
                          and a.sng021eval = l_max_eval) R
              on S.TPNRO = R.sng026cod;
        commit;
      
        delete from SNG028 where sng021eval = l_nroeval;
        commit;
        insert into SNG028
          (SNG021EVAL,
           SNG026COD,
           SNG028LIN,
           SNG028MTO1,
           SNG028MTO2,
           SNG028MTO3,
           SNG028MTO4,
           SNG028MDA1,
           SNG028MDA2,
           SNG028MDA3,
           SNG028MDA4,
           SNG028TXT1,
           SNG028TXT2,
           SNG028TXT3,
           SNG028CON1,
           SNG028CON2,
           SNG028CON3,
           SNG028CAN1,
           SNG028CAN2,
           SNG028CAN3,
           SNG028CAN4,
           SNG028TXL1,
           SNG028TXL2,
           SNG028TXL3)
          select l_nroeval,
                 SNG026COD,
                 SNG028LIN,
                 SNG028MTO1,
                 SNG028MTO2,
                 SNG028MTO3,
                 SNG028MTO4,
                 SNG028MDA1,
                 SNG028MDA2,
                 SNG028MDA3,
                 SNG028MDA4,
                 SNG028TXT1,
                 SNG028TXT2,
                 SNG028TXT3,
                 SNG028CON1,
                 SNG028CON2,
                 SNG028CON3,
                 SNG028CAN1,
                 SNG028CAN2,
                 SNG028CAN3,
                 SNG028CAN4,
                 SNG028TXL1,
                 SNG028TXL2,
                 SNG028TXL3
            from sng028sql@eval
           where SNG021EVAL = l_max_eval;
        commit;
      
      EXCEPTION
        WHEN others THEN
          return;
      END;
    END IF; /* FIN EV. DEPENDIENTE */
  
    BEGIN
      --OBSERVACIONES
      select trim(sng021obs1), trim(sng021obs2), trim(sng021obs3)
        into L_sng021obs1, L_sng021obs2, L_sng021obs3 /*Codigos: 73,74,75*/
        from SNG021SQL@eval
       where sng021eval = l_max_eval;
    
      delete from sng031 s
       where s.sng001inst = p_instancia
         and s.sng027cod in (select tpnro
                               from fst098
                              Where pgcod = 1
                                and tpcod = 7690
                                and tpcorr >= 200
                                and tpcorr <= 202);
    
      commit;
      insert into sng031 values (p_instancia, 73, L_sng021obs1);
      commit;
      insert into sng031 values (p_instancia, 74, L_sng021obs2);
      commit;
      insert into sng031 values (p_instancia, 75, L_sng021obs3);
      commit;
    EXCEPTION
      WHEN others THEN
        return;
    END; /*FIN OBSERVACIONES */
  
    BEGIN
    
      select sng021fec
        into l_dfec
        from SNG021SQL@eval
       where sng021eval = l_max_eval;
    
      Update sng021 set sng021fec = l_dfec where sng021sol = p_instancia;
      COMMIT;
    
      select nvl(max(jaqy736corr), 0) + 1 --cantidad de lectura
        into l_max_log
        from jaqy736
       where jaqy736usu = trim(P_USU);
    
      select sng021eeff
        into l_FVto
        from SNG021SQL@eval
       Where sng021eval = l_max_eval;
    
      update SNG120
         set SNG120FVto = l_FVto, sng120fpag = l_dfec ---??
       where sng120ins = p_instancia
         and SNG120Tsk = 'EVALUACION';
      commit;
    
      insert into jaqy736
      values
        (l_max_log, p_fecha, p_hora, p_usu, p_instancia, l_max_eval);
      commit;
      P_EVAL := l_max_eval;
    EXCEPTION
      WHEN others THEN
        lc_coderr := sqlcode;
        lc_msgerr := sqlerrm;
        return;
    END;
  
  END sp_cr_migra_batch;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_migracion_batch(P_SUCUR in number) IS
    cursor INSTANCES is
    --   select /*+ALL_ROWS parallel(s,2,1)*/
      select /*+ALL_ROWS*/
       wfinsprcid,
       s.sng001ase,
       x.xwfsucursal,
       s.sng001pais,
       s.sng001tdoc,
       s.sng001ndoc
        from wfwrkitems r, xwf700 x, sng001 s
       where wftaskcod = 7
         and r.WFSTSCOD not in ('C', 'D', 'B', 'E')
         and r.wfiteminit > to_date('01/05/2014', 'dd/mm/rrrr')
         and r.wfitemend = to_date('01/01/0001', 'dd/mm/rrrr')
         and x.xwfprcins = r.wfinsprcid
         and s.sng001inst = r.wfinsprcid
         and x.xwfsucursal = P_SUCUR --2
       order by s.sng001pais, s.sng001tdoc, s.sng001ndoc;
  
    L_USUARIO  varchar2(20);
    L_FECHA    fst017.pgfape%type;
    L_HORA     varchar2(10);
    L_EVAL     NUMBER(10);
    L_PAIS_ANT sng001.sng001pais%type;
    L_TDOC_ANT sng001.sng001tdoc%type;
    L_NDOC_ANT sng001.sng001ndoc%type;
    L_EVAL_ANT NUMBER(10);
    L_CONT     NUMBER(10) := 0;
  
  BEGIN
    select pgfape into L_FECHA from fst017 where pgcod = 1;
    SELECT TO_CHAR(sysdate, 'HH24:MM:SS') into L_HORA from dual;
  
    for g in INSTANCES loop
    
      begin
        select rr.sng057sup
          into L_USUARIO
          from sng057 rr
         where rr.sng057usr = g.sng001ase
           and rr.sng057ini <= L_FECHA
           and rr.sng057fin >= L_FECHA;
      exception
        when no_data_found then
          L_USUARIO := trim(g.sng001ase);
        
      End;
    
      pq_cr_migra_evaluacion.sp_cr_migra_batch(p_instancia => g.wfinsprcid,
                                               p_usu       => L_USUARIO,
                                               p_fecha     => L_FECHA,
                                               p_hora      => L_HORA,
                                               p_eval      => L_EVAL);
    
      IF (L_CONT = 0) THEN
        L_PAIS_ANT := G.SNG001PAIS;
        L_TDOC_ANT := G.SNG001TDOC;
        L_NDOC_ANT := G.SNG001NDOC;
        L_EVAL_ANT := L_EVAL;
      ELSE
        IF (L_PAIS_ANT <> G.SNG001PAIS OR L_TDOC_ANT <> G.SNG001TDOC OR
           L_NDOC_ANT <> G.SNG001NDOC) THEN
          update SNG021SQL@eval a
             set a.sng021fgpro = 1
           where a.sng021eval = L_EVAL_ANT;
          commit;
          L_PAIS_ANT := G.SNG001PAIS;
          L_TDOC_ANT := G.SNG001TDOC;
          L_NDOC_ANT := G.SNG001NDOC;
          L_EVAL_ANT := L_EVAL;
        END IF;
      END IF;
      L_CONT := L_CONT + 1;
    end loop;
    update SNG021SQL@eval a
       set a.sng021fgpro = 1
     where a.sng021eval = L_EVAL;
  
    commit;
  END sp_cr_migracion_batch;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                             
  procedure sp_cr_migracion_batch_job is
    -- ******************************************************************************************************
    -- Nombre                     : sp_inserta_jaqy709_job
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     :
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2014.02.05
    -- Autor de Creaci¿n          : SFERNANDEM
    -- Uso                        : JOBS para insercion jay709- reporte de liquidacion de gestores
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : pn_pgcod:1,pd_feccar:fecha apeertura
    -- Par¿metros de Salida       :
    -- Fecha de Modificaci¿n      :
    -- Autor de la Modificaci¿n   :
    -- Descripci¿n de Modificaci¿n:
    --
    -- ********************************************************************************************************
  
    cursor c_regiones_job is --sucursales
      select sucurs
        from fst001
       where sucurs < 200
         and pgcod = 1;
  
    --lc_pgcod varchar2(4);
    lc_variable  varchar2(4000);
    ln_job       number := 0;
    ln_instancia number(2);
    lc_hostname  varchar2(64);
  
  BEGIN
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    select nvl(count(*), 0)
      into ln_instancia
      from gv$instance
     where inst_id = 2
       and status = 'OPEN';
  
    if (ln_instancia = 1) then
      for job in c_regiones_job loop
        lc_variable := ' begin ' ||
                       ' PQ_CR_MIGRA_EVALUACION.sp_cr_migracion_batch(' ||
                       'to_number(''' || job.sucurs || ''')' || ');' ||
                       ' End; ';
        ln_job      := ln_job + 1;
      
        --if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
        --if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
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
    else
      for job in c_regiones_job loop
        lc_variable := ' begin ' ||
                       ' PQ_CR_MIGRA_EVALUACION.sp_cr_migracion_batch(' ||
                       'to_number(''' || job.sucurs || ''')' || ');' ||
                       ' End; ';
        ln_job      := ln_job + 1;
      
        --if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then
        --if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
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
    End if;
  
  end sp_cr_migracion_batch_job;
  -----------------------------------------------------------------------------------------------                           
  Procedure sp_cr_consulta_evaluacion(P_INSTANCIA in number,
                                      P_PAIS      in number,
                                      P_TDOC      in number,
                                      P_NDOC      in varchar2,
                                      P_MAQUINA   in varchar2) is
    -- ******************************************************************************************************
    -- Nombre                     : sp_inserta_jaqy709_job
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     :
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2014.02.05
    -- Autor de Creaci¿n          : SFERNANDEM
    -- Uso                        : JOBS para insercion jay709- reporte de liquidacion de gestores
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : pn_pgcod:1,pd_feccar:fecha apeertura
    -- Par¿metros de Salida       :
    -- Fecha de Modificaci¿n      :
    -- Autor de la Modificaci¿n   :
    -- Descripci¿n de Modificaci¿n:
    --
    -- ********************************************************************************************************
    P_USU       varchar2(30);
    l_sng001ase sng001.sng001ase%type;
    L_FECHA     fst017.pgfape%type;
    L_corr      number(10);
    L_maquina   char(30);
    L_USU       char(30);
    cursor evaluaciones is
      select nvl(sng021eval, 0) as neval, sng021tmod, sng021fec
        from SNG021SQL@eval
       where sng021pdoc = P_PAIS
         and sng021tdoc = P_TDOC
         and SNG021NDOC = trim(P_NDOC)
         and sng021fgest <> 2 --anulada
         and sng021fgpro = 0 --no leida
         and SNG021USU = trim(P_USU);
  
  BEGIN
    BEGIN
      select sng001ase
        into l_sng001ase
        from sng001
       where sng001inst = P_INSTANCIA;
      select pgfape into L_FECHA from fst017 where pgcod = 1;
      select trim(rr.sng057sup)
        into P_USU
        from sng057 rr
       where rr.sng057usr = l_sng001ase
         and rr.sng057ini <= L_FECHA
         and rr.sng057fin >= L_FECHA;
    EXCEPTION
      when no_data_found then
        P_USU := trim(l_sng001ase);
      
    END;
    L_maquina := trim(P_MAQUINA);
    L_USU     := trim(P_USU);
    delete from jaqy738
     where JAQY738MAQ = L_maquina
       and jaqy738usu = L_USU;
    commit;
  
    FOR ev IN evaluaciones LOOP
      select nvl(max(jaqy738corr), 0) + 1
        into L_corr
        from jaqy738
       where jaqy738usu = trim(P_USU)
         and JAQY738MAQ = trim(P_MAQUINA);
      insert into jaqy738
      values
        (L_corr,
         trim(P_USU),
         TRIM(P_MAQUINA),
         ev.neval,
         ev.sng021tmod,
         ev.sng021fec);
    
      commit;
    END LOOP;
  
  END sp_cr_consulta_evaluacion;
  -----------------------------------------------------------------------------------------------                           
  Procedure sp_cr_ultima_evaluacion(pn_instDES in number,
                                    P_ERROR    out varchar2) is
    ld_MaxFchDesemb date;
    ln_pgcod        number;
    ln_modulo       number;
    ln_sucursal     number;
    ln_moneda       number;
    ln_papel        number;
    ln_cuenta       number;
    ln_operacion    number;
    ln_suboper      number;
    ln_tipooper     number;
    ln_instORI      number;
    ln_evalORI      number; --Origen
    ln_evalDES      number; --Destino
    L_FECHA         date;
    ld_fecana       date;
    ln_jaqy327corr  number;
  begin
    p_error := 'Importacion exitosa';
    begin
      select pgfape into L_FECHA from fst017 where pgcod = 1;
      select max(g.aofval)
        into ld_MaxFchDesemb
        from fsd010 g
       where g.pgcod = 1
         and g.aomod in (select modulo
                           from fst111
                          where dscod = 50
                            and modulo not in (33, 200, 108))
         and g.aocta in (select f.ctnro
                           from fsr008 f
                          inner join sng001 x
                             on f.pepais = x.sng001pais
                            and f.petdoc = x.sng001tdoc
                            and f.pendoc = x.sng001ndoc
                            and f.cttfir = 'T'
                            and x.sng001inst = pn_instDES);
    exception
      when no_data_found then
        p_error := 'No se encontro credito para este cliente';
        return;
    end;
  
    begin
      select g.pgcod,
             g.aomod,
             g.aosuc,
             g.aomda,
             g.aopap,
             g.aocta,
             g.aooper,
             g.aosbop,
             g.aotope
        into ln_pgcod,
             ln_modulo,
             ln_sucursal,
             ln_moneda,
             ln_papel,
             ln_cuenta,
             ln_operacion,
             ln_suboper,
             ln_tipooper
      
        from fsd010 g
       where g.pgcod = 1
         and g.aomod in (select modulo
                           from fst111
                          where dscod = 50
                            and modulo not in (33, 200, 108))
         and g.aocta in (select f.ctnro
                           from fsr008 f
                          inner join sng001 x
                             on f.pepais = x.sng001pais
                            and f.petdoc = x.sng001tdoc
                            and f.pendoc = x.sng001ndoc
                            and f.cttfir = 'T'
                            and x.sng001inst = pn_instDES)
         and g.aofval = ld_MaxFchDesemb
         and rownum = 1;
    exception
      when no_data_found then
        p_error := 'No se encontro credito para este cliente';
        return;
    end;
  
    begin
      ln_instORI := fn_instancia_credito(v_Scmod  => ln_modulo,
                                         v_Scsuc  => ln_sucursal,
                                         v_Scmda  => ln_moneda,
                                         v_Scpap  => ln_papel,
                                         v_Sccta  => ln_cuenta,
                                         v_Scoper => ln_operacion,
                                         v_Scsbop => ln_suboper,
                                         v_Sctope => ln_tipooper);
    exception
      when no_data_found then
        p_error := 'No se encontro instancia para este cliente';
        return;
    end;
    --Migramos la instancia encontrada
    begin
      select x.sng021eval
        into ln_evalORI
        from sng021 x
       where x.sng021sol = ln_instORI; --Evaluacion Origen
      select y.sng021eval
        into ln_evalDES
        from sng021 y
       where y.sng021sol = pn_instDES; --Evaluacion Destino          
    
      /********************DATOS EVALUACION***********************/
      delete from sng023
       where sng021eval = ln_evalDES
         and sng026cod in (select tpnro
                             from fst098
                            where pgcod = 1
                              and tpcod = 7690
                              and tpimp = 1
                           union all
                           select tpnro
                             from fst098
                            where pgcod = 1
                              and tpcod = 7690
                              and tpnro in (13,
                                            14,
                                            15,
                                            16,
                                            17,
                                            18,
                                            19,
                                            20,
                                            513,
                                            514,
                                            515,
                                            516,
                                            517,
                                            518,
                                            519,
                                            520)); /*Ev. independiente*/
    
      insert into sng023
        select ln_evalDES, R.sng026cod, R.sng023mto
          from (select tpnro
                  from fst098
                 where pgcod = 1
                   and tpcod = 7690
                   and tpimp = 1
                union all
                select tpnro
                  from fst098
                 where pgcod = 1
                   and tpcod = 7690
                   and tpnro in (13,
                                 14,
                                 15,
                                 16,
                                 17,
                                 18,
                                 19,
                                 20,
                                 513,
                                 514,
                                 515,
                                 516,
                                 517,
                                 518,
                                 519,
                                 520)) S
         inner join (SELECT a.sng021pdoc,
                            a.sng021tdoc,
                            a.sng021ndoc,
                            b.sng021eval,
                            b.sng026cod,
                            b.sng023mto
                       from SNG021 a, SNG023 b
                      Where a.sng021eval = b.sng021eval
                        and a.sng021eval = ln_evalORI) R
            on S.TPNRO = R.sng026cod;
      --commit; 
    
      /******************** FECHA ANALISIS *************************/
      /*select SNG120FPAG into ld_fecana  from sng120 x where x.sng120tsk = 'EVALUACION' AND x.sng120ins=ln_instORI; 
      update sng120 y 
      set sng120fpag = ld_fecana
      where y.sng120tsk = 'EVALUACION' AND y.sng120ins=pn_instDES;
       */
      /********************GASTOS FINANCIEROS***********************/
      /*select nvl(max(JAQY327CORR),1) into ln_jaqy327corr from JAQY327 Where JAQY327FECH = L_FECHA;
           
      update JAQY327 
      set JAQY327ESTA = 'N'
      where JAQY327INST = pn_instDES and JAQY327ESTA='S';
      --commit;
                   
      insert into JAQY327
      (JAQY327CORR, JAQY327FECH, JAQY327HORA, JAQY327INST, JAQY327NEVA, JAQY327PAIS,
       JAQY327TDOC, JAQY327NDOC, JAQY327RUBR, JAQY327ESTA, JAQY327ENTI, JAQY327TCRE,
       JAQY327SDEU, JAQY327PLAZ, JAQY327TAZA, JAQY327CCALC, JAQY327GFIN, JAQY327FRCC, 
       JAQY327DORI, JAQY327CHEK, JAQY327PERS, JAQY327RELA, JAQY327LINE, JAQY327AUX1,
       JAQY327AUX2, JAQY327AUX3, JAQY327AUX4, JAQY327AUX5, JAQY327AUX6, JAQY327AUX7,
       JAQY327AUX8, JAQY327AUX9)
      
      select rownum + ln_jaqy327corr, L_FECHA, to_char( CURRENT_TIMESTAMP, 'HH24:MI:SS' ),
      pn_instDES, ln_evalDES, JAQY327PAIS,
       JAQY327TDOC, JAQY327NDOC, JAQY327RUBR, JAQY327ESTA, JAQY327ENTI, JAQY327TCRE,
       JAQY327SDEU, JAQY327PLAZ, JAQY327TAZA, JAQY327CCALC, JAQY327GFIN, JAQY327FRCC, 
       JAQY327DORI, JAQY327CHEK, JAQY327PERS, JAQY327RELA, JAQY327LINE, JAQY327AUX1,
       JAQY327AUX2, JAQY327AUX3, JAQY327AUX4, JAQY327AUX5, JAQY327AUX6, JAQY327AUX7,
       JAQY327AUX8, JAQY327AUX9
      from JAQY327 a 
      where 
      a.JAQY327INST = ln_instORI
      and a.jaqy327esta='S';
      */
    
      commit;
    exception
      when no_data_found then
        p_error := 'No se pudo copiar la ultima evaluacion';
        return;
    end;
  
  end sp_cr_ultima_evaluacion;
  -----------------------------------------------------------------------------------------------
  Procedure sp_cr_Saldo_Deudor(pn_NumIns in number, pc_FlgRes out varchar2) is
    ln_TipDoc number;
    ln_PaiDoc number;
    lc_NumDoc varchar2(12);
    ln_NumEva number;
  
    ln_InsAux number;
    ld_FecAux date;
    ld_FecApe date;
  
    ln_NumCor number; --Correlativo
    PRAGMA AUTONOMOUS_TRANSACTION;
    ln_TMOD   number(4); --mod@abr 20191209
    ln_mod    number(3); --mod@abr 20191209
    ln_top    number(3); --mod@abr 20191209
    ln_mda    number(4); --mod@abr 20191209
    ln_mto    number(17, 2) := 0; --mod@abr 20191209
    ln_cuo    number(5) := 0; --mod@abr 20191209
    ln_per    number(5) := 0; --mod@abr 20191209
    ln_pzo    number(5) := 0; --mod@abr 20191209
    ln_tipcam number(14, 8) := 1; --mod@abr 20191209
  begin
    begin
      select pgfape into ld_FecApe from fst017 where pgcod = 1;
      --Obtenemos el Documento y Evaluacion
      select SNG021TDoc, SNG021PDoc, SNG021NDoc, SNG021Eval, SNG021TMOD --mod@abr 20191209
        into ln_TipDoc, ln_PaiDoc, lc_NumDoc, ln_NumEva, ln_TMOD --mod@abr 20191209 
        from Sng021
       where Sng021Sol = pn_NumIns;
    
      --and Aqpa190dFlguso = 'N' --Que no hayan sido usados
    
      if ln_TMOD = 14 then
        --Obtenemos la instancia de la tabla AQPA190D correspondiente al DNI
        select AQPA190DInst, AQPA190DFech
          into ln_InsAux, ld_FecAux
          from (select *
                  from (Select AQPA190DInst, AQPA190DFech, Aqpa190dFlguso
                          from Aqpa190d
                         where Aqpa190dPais = ln_PaiDoc
                           and Aqpa190dTdoc = ln_TipDoc
                           and Aqpa190dNdoc = lc_NumDoc
                         order by AQPA190DFech desc)
                 where rownum = 1) x
         where x.Aqpa190dFlguso = 'N';
      
        --mod@abr 20191209
      
        --Obtenemos el ultimo correlativo
        select nvl(max(Jaqz862Corr), 1)
          into ln_NumCor
          from Jaqz862
         where jaqz862Fech = ld_FecApe;
      
        Insert into JAQZ862
          (Jaqz862corr,
           Jaqz862fech,
           Jaqz862hora,
           Jaqz862inst,
           Jaqz862neva,
           Jaqz862pais,
           Jaqz862tdoc,
           Jaqz862ndoc,
           Jaqz862rubr,
           Jaqz862esta,
           Jaqz862enti,
           Jaqz862tcre,
           Jaqz862sdeu,
           Jaqz862plaz,
           Jaqz862taza,
           Jaqz862ccalc,
           Jaqz862gfin,
           Jaqz862frcc,
           Jaqz862dori,
           Jaqz862chek,
           Jaqz862pers,
           Jaqz862rela,
           Jaqz862line,
           Jaqz862aux1,
           Jaqz862aux2,
           Jaqz862aux3,
           Jaqz862aux4,
           Jaqz862aux5,
           Jaqz862aux6,
           Jaqz862aux7,
           Jaqz862aux8,
           Jaqz862aux9,
           Jaqz862mda,
           Jaqz862tlin,
           Jaqz862util,
           Jaqz862flin,
           jaqz862cptn,
           jaqz862fac1,
           jaqz862fac2,
           jaqz862fac3,
           jaqz862cent)
        
          select ln_NumCor + rownum,
                 ld_FecApe,
                 a.aqpa190dhora,
                 pn_NumIns,
                 ln_NumEva,
                 a.aqpa190dpais,
                 a.aqpa190dtdoc,
                 a.aqpa190dndoc,
                 a.aqpa190drubr,
                 a.aqpa190desta,
                 a.aqpa190denti,
                 a.aqpa190dtcre,
                 a.aqpa190dsdeu,
                 a.aqpa190dplaz,
                 a.aqpa190dtaza,
                 a.aqpa190dccalc,
                 a.aqpa190dgfin,
                 a.aqpa190dfrcc,
                 a.aqpa190ddori,
                 a.aqpa190dchek,
                 a.aqpa190dpers,
                 a.aqpa190drela,
                 a.aqpa190dline,
                 a.aqpa190daux1,
                 a.aqpa190daux2,
                 a.aqpa190daux3,
                 a.aqpa190daux4,
                 a.aqpa190daux5,
                 a.aqpa190daux6,
                 a.aqpa190daux7,
                 a.aqpa190daux8,
                 a.aqpa190daux9,
                 a.aqpa190dmda,
                 a.aqpa190dtlin,
                 a.aqpa190dutil,
                 a.aqpa190dflin,
                 a.aqpa190dcptn,
                 a.aqpa190dfac1,
                 a.aqpa190dfac2,
                 a.aqpa190dfac3,
                 a.aqpa190dcent
            from Aqpa190d a
           where AQPA190DInst = ln_InsAux
             and AQPA190DFech = ld_FecAux;
      
        commit;
        pc_FlgRes := 'S';
      end if;
    
      if ln_TMOD = 13 then
        --mod@abr 20191209
        --Obtenemos la instancia de la tabla AQPA190D correspondiente al DNI
        select AQPA190DInst, AQPA190DFech
          into ln_InsAux, ld_FecAux
          from (select *
                  from (Select AQPA190DInst, AQPA190DFech, Aqpa190dFlguso
                          from Aqpa190d
                         where Aqpa190dPais = ln_PaiDoc
                           and Aqpa190dTdoc = ln_TipDoc
                           and Aqpa190dNdoc = lc_NumDoc
                         order by AQPA190DFech desc)
                 where rownum = 1) x
         where x.Aqpa190dFlguso = 'N';
      
        /*begin
          select a.jaqm750mod,
                 a.jaqm750tip,
                 a.jaqm750mda,
                 a.jaqm750imp,
                 a.jaqm750cuo,
                 a.jaqm750pdo
            into ln_mod, ln_top, ln_mda, ln_mto, ln_cuo, ln_per
            from jaqm750 a
           where a.jaqm750pai = ln_PaiDoc
             and a.jaqm750tdo = ln_TipDoc
             and a.jaqm750ndo = lc_NumDoc
             and a.jaqm750fch = ld_FecApe;
        exception
          when too_many_rows then
            begin
              select a.jaqm750mod,
                     a.jaqm750tip,
                     a.jaqm750mda,
                     a.jaqm750imp,
                     a.jaqm750cuo,
                     a.jaqm750pdo
                into ln_mod, ln_top, ln_mda, ln_mto, ln_cuo, ln_per
                from jaqm750 a
               where a.jaqm750pai = ln_PaiDoc
                 and a.jaqm750tdo = ln_TipDoc
                 and a.jaqm750ndo = lc_NumDoc
                 and a.jaqm750fch = ld_FecApe
                 and rownum = 1;
            exception
              when others then
                null;
            end;
          when others then
            null;
        end;
        ln_pzo := nvl(ln_cuo, 0) * nvl(ln_per, 0);
        
        begin
          select cotcbi
            into ln_tipcam
            from fsh005 f
           where cofdes in (select max(cofdes)
                              from fsh005 g
                             where g.cofdes <= ld_FecApe
                               and moneda = 101)
             and moneda = 101;
        exception
          when no_data_found then
            ln_tipcam := 1;
        end;
        */
      
        --Obtenemos el ultimo correlativo
        select nvl(max(a.jaqy327corr), 1)
          into ln_NumCor
          from jaqy327 a
         where a.jaqy327fech = ld_FecApe;
      
        Insert into JAQY327
          (JAQY327CORR,
           JAQY327FECH,
           JAQY327HORA,
           JAQY327INST,
           JAQY327NEVA,
           JAQY327PAIS,
           JAQY327TDOC,
           JAQY327NDOC,
           JAQY327RUBR,
           JAQY327ESTA,
           JAQY327ENTI,
           JAQY327TCRE,
           JAQY327SDEU,
           JAQY327PLAZ,
           JAQY327TAZA,
           JAQY327CCALC,
           JAQY327GFIN,
           JAQY327FRCC,
           JAQY327DORI,
           JAQY327CHEK,
           JAQY327PERS,
           JAQY327RELA,
           JAQY327LINE,
           JAQY327AUX1,
           JAQY327AUX2,
           JAQY327AUX3,
           JAQY327AUX4,
           JAQY327AUX5,
           JAQY327AUX6,
           JAQY327AUX7,
           JAQY327AUX8,
           JAQY327AUX9,
           JAQY327MDA,
           JAQY327TLIN,
           JAQY327UTIL,
           JAQY327FLIN,
           JAQY327CPTN,
           JAQY327FAC1,
           JAQY327FAC2,
           JAQY327FAC3,
           JAQY327CENT)
        
          select ln_NumCor + rownum,
                 ld_FecApe,
                 a.aqpa190dhora,
                 pn_NumIns,
                 ln_NumEva,
                 a.aqpa190dpais,
                 a.aqpa190dtdoc,
                 a.aqpa190dndoc,
                 a.aqpa190drubr,
                 a.aqpa190desta,
                 a.aqpa190denti,
                 a.aqpa190dtcre,
                 a.aqpa190dsdeu,
                 a.aqpa190dplaz,
                 a.aqpa190dtaza,
                 a.aqpa190dccalc,
                 a.aqpa190dgfin,
                 a.aqpa190dfrcc,
                 a.aqpa190ddori,
                 a.aqpa190dchek,
                 a.aqpa190dpers,
                 a.aqpa190drela,
                 a.aqpa190dline,
                 a.aqpa190daux1,
                 a.aqpa190daux2,
                 a.aqpa190daux3,
                 a.aqpa190daux4,
                 a.aqpa190daux5,
                 a.aqpa190daux6,
                 a.aqpa190daux7,
                 a.aqpa190daux8,
                 a.aqpa190daux9,
                 a.aqpa190dmda,
                 a.aqpa190dtlin,
                 a.aqpa190dutil,
                 a.aqpa190dflin,
                 a.aqpa190dCPTN,
                 a.aqpa190dFAC1,
                 a.aqpa190dFAC2,
                 a.aqpa190dFAC3,
                 a.aqpa190dCENT
            from Aqpa190d a
           where AQPA190DInst = ln_InsAux
             and AQPA190DFech = ld_FecAux;
      
      end if;
    
      update Aqpa190d
         set Aqpa190dFlguso = 'S'
       where AQPA190DInst = ln_InsAux
         and AQPA190DFech = ld_FecAux;
    
      --MOD@ABR 20191209 
      /*
      insert into sng120
        (sng120ins,
         sng120tsk,
         sng120mod,
         sng120top,
         sng120mda,
         sng120pap,
         sng120pzo,
         sng120cuo,
         sng120per,
         sng120mto,
         sng120tcbi)
      
      values
        (pn_NumIns,
         'EVALUACION',
         ln_mod,
         ln_top,
         ln_mda,
         0,
         ln_pzo,
         ln_cuo,
         ln_per,
         ln_mto,
         ln_tipcam);
      --MOD@ABR 20191209*/
      commit;
      pc_FlgRes := 'S';
    
    exception
      when no_data_found then
        pc_FlgRes := 'N';
        return;
    end;
  
  end sp_cr_Saldo_Deudor;

  ------------------------------------------------------------------------
  Procedure sp_cr_sng120(pn_NumIns in number, pc_FlgRes out varchar2) is
    ln_TipDoc number;
    ln_PaiDoc number;
    lc_NumDoc varchar2(12);
    ln_NumEva number;
  
    ln_InsAux number;
    ld_FecAux date;
    ld_FecApe date;
  
    ln_NumCor number; --Correlativo
    PRAGMA AUTONOMOUS_TRANSACTION;
    ln_TMOD    number(4); --mod@abr 20191209
    ln_mod     number(3); --mod@abr 20191209
    ln_top     number(3); --mod@abr 20191209
    ln_mda     number(4); --mod@abr 20191209
    ln_mto     number(17, 2) := 0; --mod@abr 20191209
    ln_cuo     number(5) := 0; --mod@abr 20191209
    ln_per     number(5) := 0; --mod@abr 20191209
    ln_pzo     number(5) := 0; --mod@abr 20191209
    ln_tipcam  number(14, 8) := 1; --mod@abr 20191209
    ln_HayData number;
  
  begin
  
    begin
      select pgfape into ld_FecApe from fst017 where pgcod = 1;
    end;
  
    begin
      --Obtenemos el Documento y Evaluacion
      select SNG021TDoc, SNG021PDoc, SNG021NDoc, SNG021Eval, SNG021TMOD --mod@abr 20191209
        into ln_TipDoc, ln_PaiDoc, lc_NumDoc, ln_NumEva, ln_TMOD --mod@abr 20191209 
        from Sng021
       where Sng021Sol = pn_NumIns;
    exception
      when others then
        null;
    end;
    --and Aqpa190dFlguso = 'N' --Que no hayan sido usados
  
    if ln_TMOD = 13 then
      --mod@abr 20191209
    
      begin
        select a.jaqm750mod,
               a.jaqm750tip,
               a.jaqm750mda,
               a.jaqm750imp,
               a.jaqm750cuo,
               a.jaqm750pdo
          into ln_mod, ln_top, ln_mda, ln_mto, ln_cuo, ln_per
          from jaqm750 a
         where a.jaqm750pai = ln_PaiDoc
           and a.jaqm750tdo = ln_TipDoc
           and a.jaqm750ndo = lc_NumDoc
           and a.jaqm750fch = ld_FecApe;
      exception
        when too_many_rows then
          begin
            select a.jaqm750mod,
                   a.jaqm750tip,
                   a.jaqm750mda,
                   a.jaqm750imp,
                   a.jaqm750cuo,
                   a.jaqm750pdo
              into ln_mod, ln_top, ln_mda, ln_mto, ln_cuo, ln_per
              from jaqm750 a
             where a.jaqm750pai = ln_PaiDoc
               and a.jaqm750tdo = ln_TipDoc
               and a.jaqm750ndo = lc_NumDoc
               and a.jaqm750fch = ld_FecApe
               and rownum = 1;
          exception
            when others then
              null;
          end;
        when others then
          null;
      end;
    
      ln_pzo := nvl(ln_cuo, 0) * nvl(ln_per, 0);
    
      begin
        select cotcbi
          into ln_tipcam
          from fsh005 f
         where cofdes in (select max(cofdes)
                            from fsh005 g
                           where g.cofdes <= ld_FecApe
                             and moneda = 101)
           and moneda = 101;
      exception
        when no_data_found then
          ln_tipcam := 1;
      end;
    
      --MOD@ABR 20191209 
      begin
        select count(*)
          into ln_HayData
          from sng120 s
         where s.sng120ins = pn_NumIns
           and s.sng120tsk = 'EVALUACION';
      exception
        when others then
          null;
      end;
    
      if ln_HayData = 0 then
      
        begin
          insert into sng120
            (sng120ins,
             sng120tsk,
             sng120mod,
             sng120top,
             sng120mda,
             sng120pap,
             sng120pzo,
             sng120cuo,
             sng120per,
             sng120mto,
             sng120fval,
             sng120fpag,
             sng120tcbi)
          
          values
            (pn_NumIns,
             'EVALUACION',
             ln_mod,
             ln_top,
             ln_mda,
             0,
             ln_pzo,
             ln_cuo,
             ln_per,
             ln_mto,
             ld_FecApe,
             ld_FecApe,
             ln_tipcam);
        
        exception
          when no_data_found then
            pc_FlgRes := 'N';
            return;
        end;
      
        --MOD@ABR 20191209
        commit;
        pc_FlgRes := 'S';
      end if;
    end if;
  
  end sp_cr_sng120;

end PQ_CR_MIGRA_EVALUACION;
/

