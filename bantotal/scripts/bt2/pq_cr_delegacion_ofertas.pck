create or replace package PQ_CR_DELEGACION_OFERTAS is

  -- Author  : MPOSTIGOC
  -- Created : 11/01/2022 20:36:50
  -- Purpose : 

  procedure sp_cr_inicio(lc_UsuLogin in varchar2, ln_TipoGrnt in number);
  -----------------------------------------------
  procedure sp_cr_GrntAgencia(lc_UsuLogin in varchar2,
                              ln_sucursal in number);
  ---------------------------------------------------
  procedure sp_cr_GrntRegional(lc_UsuLogin in varchar2,
                               ln_sucursal in number);
  --------------------------------------------------------------------
  procedure sp_cr_PrimeraGrilla(ld_fep  in date,
                                ln_cor  in number,
                                ln_pai  in number,
                                ln_tdo  in number,
                                lc_ndo  in varchar2,
                                ln_suc  in number,
                                ln_mda  in number,
                                ln_cta  in number,
                                ln_mod  in number,
                                ln_top  in number,
                                lc_ase  in varchar2,
                                ln_mto  in number,
                                ln_pzo  in number,
                                ln_cuo  in number,
                                ln_moe  in number,
                                lc_au5  in varchar2,
                                lc_des  in varchar2,
                                lc_tca  in varchar2,
                                lc_prio in varchar2,
                                lc_base in varchar2,
                                lc_ulog in varchar2);

  ------------------------------------------------------                                
  procedure sp_cr_ValidaAnalista(lc_Ulogin   in varchar2,
                                 ln_TipoGrnt in number,
                                 lc_Analista in varchar2,
                                 lc_Valida   out varchar2);

  -------------------------------------------------------- 
  PROCEDURE SP_ASESOR_SUC(P_JAQZ697ASE_OLD CHAR,
                          P_JAQZ697ASE_NEW CHAR,
                          P_FECHA          DATE,
                          P_CTA            NUMBER);
  -------------------------------------------------------                                                                

end PQ_CR_DELEGACION_OFERTAS;
/

create or replace package body PQ_CR_DELEGACION_OFERTAS is

  procedure sp_cr_inicio(lc_UsuLogin in varchar2, ln_TipoGrnt in number) is
  
    ln_SucAgencia  number;
    ln_SucRegional number;
  
  begin
  
    begin
      delete aqpb395 a where a.aqpb395ulog = lc_UsuLogin;
      commit;
    end;
  
    if ln_TipoGrnt = 1 then
      -- gerente de agencia
    
      begin
        select f.ubsuc
          into ln_SucAgencia
          from fst046 f
         where f.pgcod = 1
           and f.ubuser = RPAD(lc_UsuLogin, 10, ' ');
      end;
    
      pq_cR_delegacion_ofertas.sp_cr_GrntAgencia(lc_UsuLogin,
                                                 ln_SucAgencia);
    
    else
      if ln_TipoGrnt = 2 then
        -- gerente regional
      
        begin
          select f.ubsuc
            into ln_SucRegional
            from fst046 f
           where f.pgcod = 1
             and f.ubuser = RPAD(lc_UsuLogin, 10, ' ');
        end;
      
        pq_cR_delegacion_ofertas.sp_cr_GrntRegional(lc_UsuLogin,
                                                    ln_SucRegional);
      
      end if;
    end if;
  
  end sp_cr_inicio;
  -----------------------------------------------
  procedure sp_cr_GrntAgencia(lc_UsuLogin in varchar2,
                              ln_sucursal in number) is
    cursor ofertas is
      select *
        from jaqz697 j
       where j.jaqz697fep = (select max(g.jaqz697fep) from jaqz697 g)
         and j.jaqz697suc = ln_sucursal
         and j.jaqz697au5 in ('N', 'F');
  
  begin
  
    for o in ofertas loop
      pq_cR_delegacion_ofertas.sp_cr_PrimeraGrilla(ld_fep  => o.jaqz697fep,
                                                   ln_cor  => o.jaqz697cor,
                                                   ln_pai  => o.jaqz697pai,
                                                   ln_tdo  => o.jaqz697tdo,
                                                   lc_ndo  => o.jaqz697ndo,
                                                   ln_suc  => o.jaqz697suc,
                                                   ln_mda  => o.jaqz697mda,
                                                   ln_cta  => o.jaqz697cta,
                                                   ln_mod  => o.jaqz697mod,
                                                   ln_top  => o.jaqz697top,
                                                   lc_ase  => o.jaqz697ase,
                                                   ln_mto  => o.jaqz697mto,
                                                   ln_pzo  => o.jaqz697pzo,
                                                   ln_cuo  => o.jaqz697cuo,
                                                   ln_moe  => o.jaqz697moe,
                                                   lc_au5  => o.jaqz697au5,
                                                   lc_des  => o.jaqz697des,
                                                   lc_tca  => o.jaqz697tca,
                                                   lc_prio => o.jaqz697prio,
                                                   lc_base => o.jaqz697base,
                                                   lc_ulog => lc_UsuLogin);
    
    end loop;
  
  end sp_cr_GrntAgencia;

  ------------------------------------------------
  procedure sp_cr_GrntRegional(lc_UsuLogin in varchar2,
                               ln_sucursal in number) is
  
    cursor regional is
      select g.sucurs Sucursal
        from regsuc g
       where g.regcod =
             (select r.regcod from regsuc r where r.sucurs = ln_sucursal);
  
    cursor ofertas(ln_SucReg number) is
      select *
        from jaqz697 j
       where j.jaqz697fep = (select max(g.jaqz697fep) from jaqz697 g)
         and j.jaqz697suc = ln_SucReg
         and j.jaqz697au5 in ('N', 'F');
  
  begin
  
    for r in regional loop
      for o in ofertas(r.Sucursal) loop
        pq_cR_delegacion_ofertas.sp_cr_PrimeraGrilla(ld_fep  => o.jaqz697fep,
                                                     ln_cor  => o.jaqz697cor,
                                                     ln_pai  => o.jaqz697pai,
                                                     ln_tdo  => o.jaqz697tdo,
                                                     lc_ndo  => o.jaqz697ndo,
                                                     ln_suc  => o.jaqz697suc,
                                                     ln_mda  => o.jaqz697mda,
                                                     ln_cta  => o.jaqz697cta,
                                                     ln_mod  => o.jaqz697mod,
                                                     ln_top  => o.jaqz697top,
                                                     lc_ase  => o.jaqz697ase,
                                                     ln_mto  => o.jaqz697mto,
                                                     ln_pzo  => o.jaqz697pzo,
                                                     ln_cuo  => o.jaqz697cuo,
                                                     ln_moe  => o.jaqz697moe,
                                                     lc_au5  => o.jaqz697au5,
                                                     lc_des  => o.jaqz697des,
                                                     lc_tca  => o.jaqz697tca,
                                                     lc_prio => o.jaqz697prio,
                                                     lc_base => o.jaqz697base,
                                                     lc_ulog => lc_UsuLogin);
      
      end loop;
    
    end loop;
  end sp_cR_GrntRegional;
  ------------------------------------------
  procedure sp_cr_PrimeraGrilla(ld_fep  in date,
                                ln_cor  in number,
                                ln_pai  in number,
                                ln_tdo  in number,
                                lc_ndo  in varchar2,
                                ln_suc  in number,
                                ln_mda  in number,
                                ln_cta  in number,
                                ln_mod  in number,
                                ln_top  in number,
                                lc_ase  in varchar2,
                                ln_mto  in number,
                                ln_pzo  in number,
                                ln_cuo  in number,
                                ln_moe  in number,
                                lc_au5  in varchar2,
                                lc_des  in varchar2,
                                lc_tca  in varchar2,
                                lc_prio in varchar2,
                                lc_base in varchar2,
                                lc_ulog in varchar2) is
  
    lc_hora char(8);
  begin
  
    begin
    
      insert into aqpb395
        (aqpb395fep,
         aqpb395cor,
         aqpb395pai,
         aqpb395tdo,
         aqpb395ndo,
         aqpb395suc,
         aqpb395mda,
         aqpb395cta,
         aqpb395mod,
         aqpb395top,
         aqpb395ase,
         aqpb395mto,
         aqpb395pzo,
         aqpb395cuo,
         aqpb395moe,
         aqpb395au5,
         aqpb395des,
         aqpb395tca,
         aqpb395prio,
         aqpb395base,
         aqpb395ulog,
         aqpb395hora)
      values
        (ld_fep,
         ln_cor,
         ln_pai,
         ln_tdo,
         lc_ndo,
         ln_suc,
         ln_mda,
         ln_cta,
         ln_mod,
         ln_top,
         lc_ase,
         ln_mto,
         ln_pzo,
         ln_cuo,
         ln_moe,
         lc_au5,
         lc_des,
         lc_tca,
         lc_prio,
         lc_base,
         lc_ulog,
         lc_hora);
      commit;
    end;
  
  end sp_cr_PrimeraGrilla;

  ---------------------------------
  procedure sp_cr_ValidaAnalista(lc_Ulogin   in varchar2,
                                 ln_TipoGrnt in number,
                                 lc_Analista in varchar2,
                                 lc_Valida   out varchar2) is
  
    ln_SucLogin    number;
    ln_SucAnalista number;
    ln_RegLogin    number;
    ln_RegAnalista number;
  
    lc_cesado char(1);
  
  begin
  
    lc_Valida := 'N';
    lc_cesado := 'S';
  
    begin
      select 'N'
        into lc_cesado
        from jaqn002 a
       inner join fsd002 b
          on a.jaqn002pai = b.pfpais
         and a.jaqn002tdo = b.pftdoc
         and a.jaqn002ndo = b.pfndoc
       where a.jaqn002usr = rpad(lc_Analista, 10)
         and b.pfebco = 'S'
         and rownum = 1;
    
    exception
      when others then
        lc_cesado := 'S';
    end;
    if lc_cesado = 'N' then
      if ln_TipoGrnt = 1 then
        begin
          select f.ubsuc
            into ln_SucLogin
            from fst046 f
           where f.pgcod = 1
             and f.ubuser = RPAD(lc_Ulogin, 10, ' ');
        exception
          when others then
            ln_SucLogin := 9999;
        end;
      
        begin
          select f.ubsuc
            into ln_SucAnalista
            from fst046 f
           where f.pgcod = 1
             and f.ubuser = RPAD(lc_Analista, 10, ' ');
        exception
          when others then
            ln_SucAnalista := 9998;
        end;
        if ln_SucLogin = ln_SucAnalista then
        
          lc_Valida := 'S';
        end if;
      
      else
        if ln_TipoGrnt = 2 then
        
          begin
            select r.regcod
              into ln_RegLogin
              from regsuc r
             where r.sucurs =
                   (select f.ubsuc
                      from fst046 f
                     where f.pgcod = 1
                       and f.ubuser = RPAD(lc_Ulogin, 10, ' '));
          exception
            when others then
              ln_RegLogin := 9999;
          end;
        
          begin
            select r.regcod
              into ln_RegAnalista
              from regsuc r
             where r.sucurs =
                   (select f.ubsuc
                      from fst046 f
                     where f.pgcod = 1
                       and f.ubuser = RPAD(lc_Analista, 10, ' '));
          exception
            when others then
              ln_RegAnalista := 9998;
          end;
        
          if ln_RegLogin = ln_RegAnalista then
          
            lc_Valida := 'S';
          
          end if;
        
        end if;
      end if;
    else
      if ln_TipoGrnt = 1 then
        begin
          select f.ubsuc
            into ln_SucLogin
            from fst046 f
           where f.pgcod = 1
             and f.ubuser = RPAD(lc_Ulogin, 10, ' ');
        exception
          when others then
            ln_SucLogin := 9999;
        end;
      
        begin
          select f.jaqz697suc
            into ln_SucAnalista
            from jaqz697 f
           where f.jaqz697fep = (select max(g.jaqz697fep) from jaqz697 g)
             and f.jaqz697au5 in ('N', 'F')
             and f.jaqz697ase = RPAD(lc_Analista, 10, ' ')
             and rownum = 1;
        exception
          when others then
            ln_SucAnalista := 9998;
        end;
        if ln_SucLogin = ln_SucAnalista then
        
          lc_Valida := 'S';
        end if;
      
      else
        if ln_TipoGrnt = 2 then
        
          begin
            select r.regcod
              into ln_RegLogin
              from regsuc r
             where r.sucurs =
                   (select f.ubsuc
                      from fst046 f
                     where f.pgcod = 1
                       and f.ubuser = RPAD(lc_Ulogin, 10, ' '));
          exception
            when others then
              ln_RegLogin := 9999;
          end;
        
          begin
            select r.regcod
              into ln_RegAnalista
              from regsuc r
             where r.sucurs =
                   (select f.jaqz697suc
                      from jaqz697 f
                     where f.jaqz697fep =
                           (select max(g.jaqz697fep) from jaqz697 g)
                       and f.jaqz697au5 in ('N', 'F')
                       and f.jaqz697ase = RPAD(lc_Analista, 10, ' ')
                       and rownum = 1);
          exception
            when others then
              ln_RegAnalista := 9998;
          end;
        
          if ln_RegLogin = ln_RegAnalista then
          
            lc_Valida := 'S';
          
          end if;
        
        end if;
      end if;
    end if;
  
  end sp_cr_ValidaAnalista;
  ---------------------------------------------------------------------------------------------
  PROCEDURE SP_ASESOR_SUC(P_JAQZ697ASE_OLD CHAR,
                          P_JAQZ697ASE_NEW CHAR,
                          P_FECHA          DATE,
                          P_CTA            NUMBER) IS
    N_CONT  NUMBER;
    suc_new number;
  BEGIN
    SELECT COUNT(1)
      INTO N_CONT
      FROM JAQZ697
     WHERE JAQZ697ASE = P_JAQZ697ASE_OLD
       AND JAQZ697FEP = P_FECHA
       AND JAQZ697AU5 IN ('N', 'F')
       AND JAQZ697CTA = P_CTA; --26.04.2021
  
    begin
      select t1.ubsuc
        into suc_new
        from fst046 t1
       where t1.pgcod = 1
         and t1.ubuser = rpad(P_JAQZ697ASE_NEW, 10);
    exception
      when others then
        null;
    end;
  
    IF N_CONT > 0 THEN
    
      EXECUTE IMMEDIATE 'create table operador.jaqz697_' ||
                        TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) ||
                        ' as select * from jaqz697 where jaqz697ase=''' ||
                        P_JAQZ697ASE_OLD ||
                        ''' and jaqz697fep = to_date(''' ||
                        TO_CHAR(P_FECHA, 'YYYYMMDD') ||
                        ''',''YYYYMMDD'') AND jaqz697au5 in(''N'',''F'') and JAQZ697CTA=' ||
                        P_CTA; --26.04.2021
    
      UPDATE JAQZ697
         SET JAQZ697ASE = P_JAQZ697ASE_NEW, JAQZ697SUC = suc_new
       WHERE JAQZ697ASE = P_JAQZ697ASE_OLD
         AND JAQZ697FEP = P_FECHA
         AND JAQZ697AU5 IN ('N', 'F')
         AND JAQZ697CTA = P_CTA; --26.04.2021
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Se ACTUALIZÓ ' || N_CONT ||
                           ' registro(s) en jaqz697 para jaqz697ase:' ||
                           P_JAQZ697ASE_OLD || ',  JAQZ697FEP:' || P_FECHA ||
                           ' y JAQZ697CTA:' || P_CTA); --26.04.2021
    ELSE
      DBMS_OUTPUT.PUT_LINE('El jaqz697ase:' || P_JAQZ697ASE_OLD ||
                           ', JAQZ697FEP:' || P_FECHA || ' y JAQZ697CTA:' ||
                           P_CTA || --26.04.2021
                           ' considera ' || N_CONT ||
                           ' registro(s) en la JAQZ697.' || CHR(13) ||
                           'No se realizó el UPDATE.');
    END IF;
  
    insert into AQPB876
    values
      (user,
       sysdate,
       'PQ_CR_JAQZ697_AQPA842_AYUDA.SP_ASESOR_SUC',
       P_JAQZ697ASE_OLD || '-' || P_JAQZ697ASE_NEW || '-' ||
       to_char(P_FECHA, 'DD/MM/RRRR') || '-' || P_CTA);
    commit;
  
  END SP_ASESOR_SUC;

end PQ_CR_DELEGACION_OFERTAS;
/

