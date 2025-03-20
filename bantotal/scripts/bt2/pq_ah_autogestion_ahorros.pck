create or replace package PQ_AH_AUTOGESTION_AHORROS is

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  type reg_age is record(
      n_nroreg jaql405.n_nroreg%type,  
      c_regins jaql405.c_regins%type,
      c_tipper jaql405.c_tipper%type,
      c_tipdoc jaql405.c_tipdoc%type, 
      c_numdoc jaql405.c_numdoc%type,  
      c_nomcom jaql405.c_nomcon%type, 
      c_ubgdir jaql405.c_codubi%type,
      c_desdir jaql405.c_dircon%type,      
      c_numtel jaql405.c_telefo%type,    
      c_emails jaql405.c_email%type,
      c_codage jaql405.c_codage%type,
      c_codsor jaql405.c_codper%type,
      c_codvis jaql405.c_tipcam%type,
      c_codpro jaql405.c_codepa%type,
      n_proint jaql405.n_proint%type,
      c_codmod jaql405.c_codmon%type,
      n_monto  jaql405.n_mtoint%type,
      c_numcta jaql405.c_numcta%type,
      c_fecven varchar(8),
      n_tastea jaql405.n_tastea%type,
      c_clirec jaql405.c_indrec%type,
      c_calcli jaql405.c_poscli%type,
      c_codmvi varchar(2),
      c_ususor jaql405.c_usureg%type,
      c_fecreg varchar(8),
      c_fecvis varchar(8),
      c_fecnac varchar(8),
      c_horvis jaql405.c_horvis%type
    );
	type cur_age is ref cursor return reg_age;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  type reg_cuen is record(
      c_numcta varchar2(27)
    );
	type cur_cuen is ref cursor return reg_cuen;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_ah_formato_cuenta_producto(
                           p_n_sccta in fsd011.sccta%type,
                           p_n_scmda in fsd011.scmda%type,
                           p_n_scmod in fsd011.scmod%type,
                           p_n_scoper in fsd011.scoper%type,
                           p_n_scsbop in fsd011.scsbop%type,
                           p_n_sctope in fsd011.sctope%type
                           ) return varchar2;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_ah_agregar_ceros(
                           p_n_tope number,
                           p_c_result character
                           ) return character;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_ah_cuentas( P_C_CODUSU in varchar2,
                               P_C_TIPDOC in varchar2,
                               P_C_NUMDOC in fsr008.pendoc%type,
                               P_C_FECINI in varchar2,
                               P_C_FECFIN in varchar2,
                               P_C_TIPRPO in varchar2,
                               bl_datos in out cur_cuen);
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_ah_exist_cuenta_reno2(p_n_sccta in fsd011.sccta%type,
                           p_n_scmda in fsd011.scmda%type,
                           p_n_scmod in fsd011.scmod%type,
                           p_n_scsuc in fsd011.scsuc%type,
                           p_n_scoper in fsd011.scoper%type,
                           p_n_scsbop in fsd011.scsbop%type,
                           p_n_sctope in fsd011.sctope%type,
                           p_c_fecini in varchar2,
                           p_c_fecfin in varchar2
                           ) return number;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_cr_exist_cuenta_acti2(p_c_codusu in varchar2,
                           p_n_sccta in fsd011.sccta%type,
                           p_n_scmda in fsd011.scmda%type,
                           p_n_scmod in fsd011.scmod%type,
                           p_n_scsuc in fsd011.scsuc%type,
                           p_n_scoper in fsd011.scoper%type,
                           p_n_scsbop in fsd011.scsbop%type,
                           p_n_sctope in fsd011.sctope%type,
                           p_c_fecini in varchar2,
                           p_c_fecfin in varchar2
                           ) return number;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_ah_insertar(P_C_CODPRO  in varchar2,
                           P_D_FECVIS  in varchar2,
                           P_D_HORVIS  in varchar2,
                           P_C_CODCLI  in varchar2,
                           P_C_TIPDOC  in number,
                           P_C_NUMDOC  in character,
                           p_c_coderr out varchar2,
                           p_c_msgerr out varchar2
                           );

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_ah_cliente_cartera(P_C_TIPDOC in fsr008.pendoc%type,
                               P_C_NUMDOC in fsr008.pendoc%type) return varchar2;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_ah_cargar_data(P_C_FECPRO IN VARCHAR2);
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_ah_data_renovacion(P_D_FECPRO in date);
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_ah_data_fidelizacion(P_D_FECPRO in date);
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_ah_data_interesados(P_D_FECPRO in date);
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  procedure sp_ah_datosAgenda(P_C_FECPRO in varchar2,
                              P_C_TIPREG in varchar2,
                              bl_datos in out cur_age);   
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                               
  procedure sp_cr_actualiza_regins( P_N_NROREG IN NUMBER,
                                    P_C_REGINS IN VARCHAR2,
                                    P_N_EXITO  OUT NUMBER); 

--------------------------------------------------------------------------

procedure sp_ah_insertar_PRUEBA(P_C_CODPRO  in varchar2,
                                 P_D_FECVIS  in varchar2,
                                 P_D_HORVIS  in varchar2,
                                 P_C_CODCLI  in varchar2,
                                 P_C_TIPDOC  in number,
                                 P_C_NUMDOC  in character,                                 
                                 p_c_coderr out varchar2,
                                 p_c_msgerr out varchar2
                                 );                                    

end PQ_AH_AUTOGESTION_AHORROS;
/

create or replace package body PQ_AH_AUTOGESTION_AHORROS is

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_ah_formato_cuenta_producto(
                           p_n_sccta in fsd011.sccta%type,
                           p_n_scmda in fsd011.scmda%type,
                           p_n_scmod in fsd011.scmod%type,
                           p_n_scoper in fsd011.scoper%type,
                           p_n_scsbop in fsd011.scsbop%type,
                           p_n_sctope in fsd011.sctope%type
                           ) return varchar2 is
  c_numcta varchar2(27);
  n_pgcod fst017.pgcod%type;
  n_pgmoca fst017.pgmoca%type;
  n_pgmocc fst017.pgmocc%type;
  n_tope number(3,1);
  c_result varchar2(27);
  begin

    n_pgcod := 1;

    select Pgmoca,
          Pgmocc
    into
          n_pgmoca,
          n_pgmocc
    from fst017
    where Pgcod = n_pgcod;

    if ( p_n_scmod = n_pgmoca or p_n_scmod = n_pgmocc ) then
      --Cuenta
      n_tope := 9;
      c_result := to_char(p_n_sccta);
      c_result := fn_ah_agregar_ceros(n_tope, c_result);
      c_numcta := c_result;
      --Módulo
      n_tope := 3;
      c_result := to_char(p_n_scmod);
      c_result := fn_ah_agregar_ceros(n_tope, c_result);
      c_numcta := c_numcta || c_result;
      --Moneda
      n_tope := 4;
      c_result := to_char(p_n_scmda);
      c_result := fn_ah_agregar_ceros(n_tope, c_result);
      c_numcta := c_numcta || SubStr(c_result,2,3);
      --Subcta
      n_tope := 3;
      c_result := to_char(p_n_scsbop);
      c_result := fn_ah_agregar_ceros(n_tope, c_result);
      c_numcta := c_numcta || SubStr(c_result,2,2);
      --Tipo Op
      n_tope := 3;
      c_result := to_char(p_n_sctope);
      c_result := fn_ah_agregar_ceros(n_tope, c_result);
      c_numcta := c_numcta || c_result;
    else --DPF y Creds
      --Cuenta
      n_tope := 9;
      c_result := to_char(p_n_sccta);
      c_result := fn_ah_agregar_ceros(n_tope, c_result);
      c_numcta := c_result;
      --Módulo
      n_tope := 3;
      c_result := to_char(p_n_scmod);
      c_result := fn_ah_agregar_ceros(n_tope, c_result);
      c_numcta := c_numcta || c_result;
      --Moneda
      n_tope := 4;
      c_result := to_char(p_n_scmda);
      c_result := fn_ah_agregar_ceros(n_tope, c_result);
      c_numcta := c_numcta || SubStr(c_result,2,3);
      --Operación
      n_tope := 9;
      c_result := to_char(p_n_scoper);
      c_result := fn_ah_agregar_ceros(n_tope, c_result);
      c_numcta := c_numcta || c_result;
      --Tipo Op
      n_tope := 3;
      c_result := to_char(p_n_sctope);
      c_result := fn_ah_agregar_ceros(n_tope, c_result);
      c_numcta := c_numcta || c_result;
    end if;

    return c_numcta;

  end fn_ah_formato_cuenta_producto;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_ah_agregar_ceros(
                           p_n_tope number,
                           p_c_result character
                           ) return character is
  n_largo number(9,2);
  c_result varchar2(27);
  begin

    c_result := p_c_result;
    n_largo := length(Trim(c_result));

    if p_n_tope = 2 then
    	if n_largo = 0 then
    		c_result := '00';
    	end if;
    	if n_largo = 1 then
    		c_result := '0' || Trim(c_result);
    	end if;
    end if;

    if p_n_tope = 3 then
      if n_largo = 0 then
        c_result := '000';
      end if;
    	if n_largo = 1 then
    		c_result := '00' || Trim(c_result);
    	end if;
    	if n_largo = 2 then
    		c_result := '0' || Trim(c_result);
    	end if;
    end if;

    if p_n_tope = 4 then
    	if n_largo = 0 then
    		c_result := '0000';
    	end if;
    	if n_largo = 1 then
    		c_result := '000' || Trim(c_result);
    	end if;
    	if n_largo = 2 then
    		c_result := '00' || Trim(c_result);
    	end if;
    	if n_largo = 3 then
    		c_result := '0' || Trim(c_result);
    	end if;
    end if;

    if p_n_tope = 5 then
    	if n_largo = 0 then
    		c_result := '00000';
    	end if;
    	if n_largo = 1 then
    		c_result := '0000' || Trim(c_result);
    	end if;
    	if n_largo = 2 then
    		c_result := '000' || Trim(c_result);
    	end if;
    	if n_largo = 3 then
    		c_result := '00' || Trim(c_result);
    	end if;
    	if n_largo = 4 then
    		c_result := '0' || Trim(c_result);
    	end if;
    end if;

    if p_n_tope = 6 then
    	if n_largo = 0 then
    		c_result := '000000';
    	end if;
    	if n_largo = 1 then
    		c_result := '00000' || Trim(c_result);
    	end if;
    	if n_largo = 2 then
    		c_result := '0000' || Trim(c_result);
    	end if;
    	if n_largo = 3 then
    		c_result := '000' || Trim(c_result);
    	end if;
    	if n_largo = 4 then
    		c_result := '00' || Trim(c_result);
    	end if;
    	if n_largo = 5 then
    		c_result := '0' || Trim(c_result);
    	end if;
    end if;

    if p_n_tope = 7 then
    	if n_largo = 0 then
    		c_result := '0000000';
    	end if;
    	if n_largo = 1 then
    		c_result := '000000' || Trim(c_result);
    	end if;
    	if n_largo = 2 then
    		c_result := '00000' || Trim(c_result);
    	end if;
    	if n_largo = 3 then
    		c_result := '0000' || Trim(c_result);
    	end if;
    	if n_largo = 4 then
    		c_result := '000' || Trim(c_result);
    	end if;
    	if n_largo = 5 then
    		c_result := '00' || Trim(c_result);
    	end if;
    	if n_largo = 6 then
    		c_result := '0' || Trim(c_result);
    	end if;
    end if;

    if p_n_tope = 8 then
    	if n_largo = 0 then
    		c_result := '00000000';
    	end if;
    	if n_largo = 1 then
    		c_result := '0000000' || Trim(c_result);
    	end if;
    	if n_largo = 2 then
    		c_result := '000000' || Trim(c_result);
    	end if;
    	if n_largo = 3 then
    		c_result := '00000' || Trim(c_result);
    	end if;
    	if n_largo = 4 then
    		c_result := '0000' || Trim(c_result);
    	end if;
    	if n_largo = 5 then
    		c_result := '000' || Trim(c_result);
    	end if;
    	if n_largo = 6 then
    		c_result := '00' || Trim(c_result);
    	end if;
    	if n_largo = 7 then
    		c_result := '0' || Trim(c_result);
    	end if;
    end if;

    if p_n_tope = 9 then
    	if n_largo = 0 then
    		c_result := '000000000';
    	end if;
    	if n_largo = 1 then
    		c_result := '00000000' || Trim(c_result);
    	end if;
    	if n_largo = 2 then
    		c_result := '0000000' || Trim(c_result);
    	end if;
    	if n_largo = 3 then
    		c_result := '000000' || Trim(c_result);
    	end if;
    	if n_largo = 4 then
    		c_result := '00000' || Trim(c_result);
    	end if;
    	if n_largo = 5 then
    		c_result := '0000' || Trim(c_result);
    	end if;
    	if n_largo = 6 then
    		c_result := '000' || Trim(c_result);
    	end if;
    	if n_largo = 7 then
    		c_result := '00' || Trim(c_result);
    	end if;
    	if n_largo = 8 then
    		c_result := '0' || Trim(c_result);
    	end if;
    end if;

    return c_result;

  end fn_ah_agregar_ceros;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_ah_cuentas( P_C_CODUSU in varchar2,
                               P_C_TIPDOC in varchar2,
                               P_C_NUMDOC in fsr008.pendoc%type,
                               P_C_FECINI in varchar2,
                               P_C_FECFIN in varchar2,
                               P_C_TIPRPO in varchar2,
                               bl_datos in out cur_cuen)is
  cur_dat_cuen cur_cuen;
  begin

    open cur_dat_cuen for
      SELECT DISTINCT
        PQ_AH_AUTOGESTION_AHORROS.fn_ah_formato_cuenta_producto(fsd011.sccta, fsd011.scmda, fsr012.p1mod, fsd011.scoper, fsd011.scsbop, fsd011.sctope) c_numcta
      FROM
        fsr008, fsd011, fsr012, fst156
      WHERE        
        fsd011.pgcod = fsr012.p1cod
        and fsd011.sccta = fsr012.p1cta
        and fsd011.scmod = fsr012.p1mod
        and fsd011.scsuc = fsr012.p1suc
        and fsd011.scmda = fsr012.p1mda
        and fsd011.scpap = fsr012.p1pap
        and fsd011.scoper = fsr012.p1oper
        and fsd011.scsbop = fsr012.p1sbop
        and fsd011.sctope = fsr012.p1tope
        
        and fsr008.pgcod = fsd011.pgcod
        and fsr008.ctnro = fsd011.sccta
        
        and fsr012.p1ndoc = fst156.agtecod        
        
        and fsd011.pgcod = 1
        and fsd011.scmod in (21,22)
        and fsr012.relcod = 77
        and fsr012.p1mod in (21,22)

        and fsr008.pepais = 604
        and fsr008.petdoc = P_C_TIPDOC
        and fsr008.pendoc = P_C_NUMDOC
        and fsd011.scfval between to_date(P_C_FECINI,'rrrrmmdd') and to_date(P_C_FECFIN,'rrrrmmdd');

    bl_datos := cur_dat_cuen;

  end sp_ah_cuentas;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_ah_exist_cuenta_reno2(p_n_sccta in fsd011.sccta%type,
                                     p_n_scmda in fsd011.scmda%type,
                                     p_n_scmod in fsd011.scmod%type,
                                     p_n_scsuc in fsd011.scsuc%type,
                                     p_n_scoper in fsd011.scoper%type,
                                     p_n_scsbop in fsd011.scsbop%type,
                                     p_n_sctope in fsd011.sctope%type,
                                     p_c_fecini in varchar2,
                                     p_c_fecfin in varchar2
                           ) return number is
  ln_nroreno number;
  begin
    begin
      select
        max(fsd011.scsbop)
      into
        ln_nroreno
      from fsd011, fsr012, fst156
      where
            fsd011.scmod = p_n_scmod
        and fsd011.sccta = p_n_sccta
        and fsd011.scsuc = p_n_scsuc
        and fsd011.scmda = p_n_scmda
        and fsd011.scpap = 0
        and fsd011.scoper = p_n_scoper
        and fsd011.scsbop = p_n_scsbop
        and fsd011.sctope = p_n_sctope

        and fsd011.scmod = fsr012.p1mod
        and fsd011.sccta = fsr012.p1cta
        and fsd011.scsuc = fsr012.p1suc
        and fsd011.scmda = fsr012.p1mda
        and fsd011.scpap = fsr012.p1pap
        and fsd011.scoper = fsr012.p1oper
        and fsd011.scsbop = fsr012.p1sbop
        and fsd011.sctope = fsr012.p1tope
        and fsr012.relcod = 77
        and fsr012.p1ndoc = fst156.agtecod

        and fsd011.scfval between to_date(p_c_fecini,'rrrr.mm.dd') and to_date(p_c_fecfin,'rrrr.mm.dd');
    exception
      when no_data_found then
        ln_nroreno := 0;
    end;

    return(ln_nroreno);

  end fn_ah_exist_cuenta_reno2;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_cr_exist_cuenta_acti2( p_c_codusu in varchar2,
                                     p_n_sccta in fsd011.sccta%type,
                                     p_n_scmda in fsd011.scmda%type,
                                     p_n_scmod in fsd011.scmod%type,
                                     p_n_scsuc in fsd011.scsuc%type,
                                     p_n_scoper in fsd011.scoper%type,
                                     p_n_scsbop in fsd011.scsbop%type,
                                     p_n_sctope in fsd011.sctope%type,
                                     p_c_fecini in varchar2,
                                     p_c_fecfin in varchar2
                           ) return number is
  ln_nroacti number;
  begin
    begin
      select
        count(*)
      into
        ln_nroacti
      from fsd011, fsd450--fsr012, fst156, 
      where
            fsd011.scmod = p_n_scmod
        and fsd011.sccta = p_n_sccta
        and fsd011.scsuc = p_n_scsuc
        and fsd011.scmda = p_n_scmda
        and fsd011.scpap = 0
        and fsd011.scoper = p_n_scoper
        and fsd011.scsbop = p_n_scsbop
        and fsd011.sctope = p_n_sctope
/*
        and fsd011.scmod = fsr012.p1mod
        and fsd011.sccta = fsr012.p1cta
        and fsd011.scsuc = fsr012.p1suc
        and fsd011.scmda = fsr012.p1mda
        and fsd011.scpap = fsr012.p1pap
        and fsd011.scoper = fsr012.p1oper
        and fsd011.scsbop = fsr012.p1sbop
        and fsd011.sctope = fsr012.p1tope
        and fsr012.relcod = 77
        and fsr012.p1ndoc = fst156.agtecod
*/
        and fsd450.cbiemod = fsd011.scmod
        and fsd450.cbiesuc = fsd011.scsuc
        and fsd450.cbiemda = fsd011.scmda
        and fsd450.cbiepap = fsd011.scpap
        and fsd450.cbiecta = fsd011.sccta
        and fsd450.cbieope = fsd011.scoper
        and fsd450.cbiesub = fsd011.scsbop
        and fsd450.cbietop = fsd011.sctope
        and fsd450.cbiefec = fsd011.scfcon
        and trim(fsd450.cbietxt1) = trim(p_c_codusu)

        and fsd011.scfcon between to_date(p_c_fecini,'rrrr.mm.dd') and to_date(p_c_fecfin,'rrrr.mm.dd')
        and fsd011.scfcon > fsd011.scfval;

    exception
      when no_data_found then

        ln_nroacti := 0;
    end;

    return(ln_nroacti);

  end fn_cr_exist_cuenta_acti2;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_ah_insertar(P_C_CODPRO in varchar2,
                           P_D_FECVIS in varchar2,
                           P_D_HORVIS in varchar2,
                           P_C_CODCLI in varchar2,
                           P_C_TIPDOC in number,
                           P_C_NUMDOC in character,
                           p_c_coderr out varchar2,
                           p_c_msgerr out varchar2
                           )is
  ld_fecvis date;
  ln_cont number;
  lc_hosvis varchar2(8);
  HORA VARCHAR2(8);
  begin

    p_c_coderr := '0000';
    ln_cont := 0;
    ld_fecvis := to_date(P_D_FECVIS, 'rrrr.mm.dd');
---    hosvis := to_char(sysdate, 'HH:MI:SS');
    lc_hosvis := to_char(to_date(P_D_HORVIS, 'HH24:MI:SS'), 'HH:MI:SS');
    HORA := to_char(sysdate, 'HH24:MI:SS');
    SELECT count(*)
      into ln_cont
    FROM JAQL108
    WHERE
      JAQL108USU = P_C_CODPRO
      AND JAQL108FCH = ld_fecvis
      AND JAQL108PTD = P_C_TIPDOC
      AND JAQL108DOC = P_C_NUMDOC;

    IF ln_cont = 0  THEN
      INSERT INTO JAQL108 (
        JAQL108PAI,
        JAQL108PTD,
        JAQL108DOC,
        JAQL108FCH,
        JAQL108USU,
        JAQL108MOD,
        JAQL108TOP,
        JAQL108RES,
        JAQL108A01,
        JAQL108A02,
        JAQL108A03,
        JAQL108A04,
        JAQL108A05,
        JAQL108A06,
        JAQL108A07,
        JAQL108A08,
        JAQL108A09,
        JAQL108A10,
        JAQL108A11,
        JAQL108A12,
        JAQL108HRA
      )
      VALUES (
        604,
        P_C_TIPDOC,
        P_C_NUMDOC,
        ld_fecvis,
        P_C_CODPRO,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        HORA,---NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        lc_hosvis
      );
    END IF;

    commit;
  exception
    when others then
      p_c_coderr := sqlcode;
      p_c_msgerr := sqlerrm;
  end;
  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_ah_cliente_cartera(P_C_TIPDOC in fsr008.pendoc%type,
                                 P_C_NUMDOC in fsr008.pendoc%type) return varchar2 is
    -- *****************************************************************
    lc_jaql61user jaql061.jaql61user%type;
  begin
  
    begin
      select ea.jaql61user 
      into lc_jaql61user
      from jaql061 ea 
      where ea.jaql61tdoc = trim(P_C_TIPDOC) 
      and ea.jaql61ndoc = trim(P_C_NUMDOC)
      and ea.jaql61esta = 'S'
      and rownum =1;
      return lc_jaql61user;
    exception
      when others then
        return null;
    end;
  
  end;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_ah_cargar_data(P_C_FECPRO IN VARCHAR2) is
  -- *****************************************************************
  -- Nombre                     : SP_AH_CARGAR_DATA
  -- Sistema                    : SORFY
  -- Módulo                     : Ahorros
  -- Versión                    : 1.0
  -- Fecha de Creación          : 01/02/2011
  -- Autor de Creación          : DRODRIGUEZD
  -- Uso                        : CARGA DE DATA DE AHORROS
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_D_FECPRO ( FECHA DE PROCESO )
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- *****************************************************************  
  begin
  
    --carga campaña renovacion
    PQ_AH_AUTOGESTION_AHORROS.sp_ah_data_renovacion(to_date(P_C_FECPRO,'YYYYMMDD'));
  
    --carga campaña fidelizacion
    PQ_AH_AUTOGESTION_AHORROS.sp_ah_data_fidelizacion(to_date(P_C_FECPRO,'YYYYMMDD'));
    
    --carga clientes interesados
    PQ_AH_AUTOGESTION_AHORROS.sp_ah_data_interesados(to_date(P_C_FECPRO,'YYYYMMDD'));
    
    commit;
  
  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_ah_data_renovacion(P_D_FECPRO in date) is
  -- *****************************************************************
  -- Nombre                     : SP_AH_DATA_RENOVACION
  -- Sistema                    : SORFY
  -- Módulo                     : Ahorros
  -- Versión                    : 1.0
  -- Fecha de Creación          : 01/02/2011
  -- Autor de Creación          : DRODRIGUEZD
  -- Uso                        : Obtener data de renovación
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_D_FECPRO ( FECHA DE PROCESO )
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación: 2011.02.15 DRODRIGUEZD -> TEA por 100
  -- *****************************************************************    
  begin

    insert into jaql405
      (d_fecpro,
       d_fecvis,
       c_nomcon,
       c_tipdoc,
       c_numdoc,
       c_dircon,
       c_dirdis,
       c_dirpro,
       c_dirdpt,
       c_telefo,
       c_email,
       c_numcta,
       d_fecven,
       c_poscli,
       c_codmon,
       n_mtoint,
       n_tastea,
       c_codepa,
       c_codper,
       c_codcma,
       c_codage,
       c_tipcam,
       c_codubi,
       c_tipper,
       c_dirref,
       n_nroreg,
       n_proint,
       c_indrec
       )
      select /*+choose*/
       P_D_FECPRO,
       P_D_FECPRO d_fecvis,
       tmp.c_nomcon,
       tmp.c_tipdoc,
       tmp.c_numdoc,
       tmp.c_dircon,
       tmp.c_desdis,
       tmp.c_despro,
       tmp.c_desdpt,
       tmp.c_numtel,
       tmp.c_mail,
       tmp.c_numcta,
       tmp.d_fecven,
       tmp.c_poscli,
       tmp.c_codmon,
       tmp.n_mtocap,
       tmp.n_tastea,
       tmp.c_codusu,
       tmp.c_codper,
       tmp.c_cmacli,
       tmp.c_agecli,
       '02',
       tmp.c_ubgdir,
       tmp.c_tipper,
       tmp.c_desref,
       SQ_AH_JAQL405.Nextval,
       n_codpro,
       'NO'
        from (
        select case
                 when a.petipo = 'F' then
                  (select trim(f2.pfape1) || ' ' || trim(f2.pfape2) || ', ' ||
                          trim(f2.pfnom1) || ' ' || trim(f2.pfnom2)
                     from fsd002 f2
                    where a.pepais = f2.pfpais
                      and a.petdoc = f2.pftdoc
                      and a.pendoc = f2.pfndoc)
                 when a.petipo = 'J' then
                  (select trim(f3.pjrazs)
                     from fsd003 f3
                    where a.pepais = f3.pjpais
                      and a.petdoc = f3.pjtdoc
                      and a.pendoc = f3.pjndoc)
               end c_nomcon,
               a.petipo c_tipper,
               a.petdoc c_tipdoc,
               trim(a.pendoc) c_numdoc,
               (select u.sngc13dir
                  from sngc13 u
                 where u.sngc13tdoc = a.petdoc
                   and u.sngc13ndoc = a.pendoc
                   and rownum = 1) c_dircon,
               (select u.sngc13ugeo
                  from sngc13 u
                 where u.sngc13tdoc = a.petdoc
                   and u.sngc13ndoc = a.pendoc
                   and rownum = 1) c_ubgdir,
               substr((select u.sngc13ref1
                        from sngc13 u
                       where u.sngc13tdoc = a.petdoc
                         and u.sngc13ndoc = a.pendoc
                         and rownum = 1),
                      0,
                      99) c_desref,
               (select f.fst071dsc
                  from fst071 f
                 inner join sngc13 u
                    on u.sngc13ugeo = to_char(f.fst071col)
                 where u.sngc13tdoc = a.petdoc
                   and u.sngc13ndoc = a.pendoc
                   and rownum = 1) c_desdis,
               (select d.locnom
                  from fst071 f
                 inner join fst070 d
                    on d.loccod = f.fst071loc
                 inner join sngc13 u
                    on u.sngc13ugeo = to_char(f.fst071col)
                 where u.sngc13tdoc = a.petdoc
                   and u.sngc13ndoc = a.pendoc
                   and rownum = 1) c_despro,
               (select k.depnom
                  from fst071 f
                 inner join fst068 k
                    on k.depcod = f.fst071dpt
                 inner join sngc13 u
                    on u.sngc13ugeo = to_char(f.fst071col)
                 where u.sngc13tdoc = a.petdoc
                   and u.sngc13ndoc = a.pendoc
                   and rownum = 1) c_desdpt,
               (select t.dotelfp
                  from fsr005 t
                 where t.petdoc = a.petdoc
                   and t.pendoc = a.pendoc
                   and rownum = 1) c_numtel,
               '' c_mail,
               pq_ah_autogestion_ahorros.fn_ah_formato_cuenta_producto(d.aocta,
                                                                       d.aomda,
                                                                       d.aomod,
                                                                       d.aooper,
                                                                       d.aosbop,
                                                                       d.aotope) c_numcta,
               d.aofvto d_fecven,
               nvl((select jaql60cali
                     from jaql060
                    where jaql60tdoc = a.petdoc
                      and jaql60ndoc = a.pendoc
                      and rownum = 1),
                   'G') c_poscli,
               d.aomda c_codmon,
               d.aoimp n_mtocap,
               d.aotasa n_tastea,
               e.jaql61user c_codusu,
               (trim(a.petdoc) || trim(a.pendoc)) c_codper,
               '1' c_cmacli,
               (select jaql60sucu
                  from jaql060
                 where jaql60tdoc = a.petdoc
                   and jaql60ndoc = a.pendoc
                   and rownum = 1) c_agecli,
               (d.aofvto - 3) d_fecvis1,--AQUI(d.aofvto - 14)
               trim(d.aomod) || trim(d.aotope) n_codpro
          from fsd010 d
         inner join fsr008 p
            on d.aocta = p.ctnro
         inner join fsd001 a
            on a.pepais = p.pepais
           and a.petdoc = p.petdoc
           and a.pendoc = p.pendoc
         inner join jaql061 e
            on a.pepais = e.jaql61pais
           and a.petdoc = e.jaql61tdoc
           and a.pendoc = e.jaql61ndoc
         where d.aomod = 22
           and d.aostat = 0
           and p.cttfir = 'T'
           and e.jaql61esta = 'S'
              ) tmp
      
       where d_fecvis1 = P_D_FECPRO;
          --or d_fecvis2 = P_D_FECPRO;

  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_ah_data_fidelizacion(P_D_FECPRO in date) is
  -- *****************************************************************
  -- Nombre                     : SP_AH_DATA_FIDELIZACION
  -- Sistema                    : SORFY
  -- Módulo                     : Ahorros
  -- Versión                    : 1.0
  -- Fecha de Creación          : 01/02/2011
  -- Autor de Creación          : DRODRIGUEZD
  -- Uso                        : Obtener data de fidelización
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_D_FECPRO ( FECHA DE PROCESO )
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- *****************************************************************    
  begin
 
    insert into jaql405
      (d_fecpro,
       d_fecvis,
       c_nomcon,
       c_tipdoc,
       c_numdoc,
       c_dircon,
       c_dirdis,
       c_dirpro,
       c_dirdpt,
       c_telefo,
       c_email,
       d_fecnac,
       c_poscli,
       c_codepa,
       c_codper,
       c_codcma,
       c_codage,
       c_tipcam,
       c_codubi,
       c_tipper,
       c_dirref,
       n_nroreg,
       c_indrec)
      select P_D_FECPRO,
             P_D_FECPRO d_fecvis,
             tmp.c_nomcon,
             tmp.c_tipdoc,
             tmp.c_numdoc,
             tmp.c_dircon,
             tmp.c_desdis,
             tmp.c_despro,
             tmp.c_desdpt,
             tmp.c_numtel,
             tmp.c_mail,
             tmp.d_fecnac,
             tmp.c_postra,
             tmp.c_codusu,
             tmp.c_codper,
             tmp.c_cmacli,
             tmp.c_agecli,
             '03',
             tmp.c_ubgdir,
             tmp.c_tipper,
             tmp.c_desref,
             SQ_AH_JAQL405.Nextval,
             'NO'
        from (
            select case
                     when p.petipo = 'F' then
                      (select trim(f2.pfape1) || ' ' || trim(f2.pfape2) || ', ' ||
                              trim(f2.pfnom1) || ' ' || trim(f2.pfnom2)
                         from fsd002 f2
                        where p.pepais = f2.pfpais
                          and p.petdoc = f2.pftdoc
                          and p.pendoc = f2.pfndoc)
                     when p.petipo = 'J' then
                      (select trim(f3.pjrazs)
                         from fsd003 f3
                        where p.pepais = f3.pjpais
                          and p.petdoc = f3.pjtdoc
                          and p.pendoc = f3.pjndoc)
                   end c_nomcon,
                   p.petipo c_tipper,
                   p.petdoc c_tipdoc,
                   p.pendoc c_numdoc,
                   (select u.sngc13dir
                      from sngc13 u
                     where u.sngc13tdoc = p.petdoc
                       and u.sngc13ndoc = p.pendoc
                       and rownum = 1) c_dircon,
                   (select u.sngc13ugeo
                      from sngc13 u
                     where u.sngc13tdoc = p.petdoc
                       and u.sngc13ndoc = p.pendoc
                       and rownum = 1) c_ubgdir,
                   substr((select u.sngc13ref1
                            from sngc13 u
                           where u.sngc13tdoc = p.petdoc
                             and u.sngc13ndoc = p.pendoc
                             and rownum = 1),
                          0,
                          99) c_desref,
                   (select f.fst071dsc
                      from fst071 f
                     inner join sngc13 u
                        on u.sngc13ugeo = to_char(f.fst071col)
                     where u.sngc13tdoc = p.petdoc
                       and u.sngc13ndoc = p.pendoc
                       and rownum = 1) c_desdis,
                   (select d.locnom
                      from fst071 f
                     inner join fst070 d
                        on d.loccod = f.fst071loc
                     inner join sngc13 u
                        on u.sngc13ugeo = to_char(f.fst071col)
                     where u.sngc13tdoc = p.petdoc
                       and u.sngc13ndoc = p.pendoc
                       and rownum = 1) c_despro,
                   (select k.depnom
                      from fst071 f
                     inner join fst068 k
                        on k.depcod = f.fst071dpt
                     inner join sngc13 u
                        on u.sngc13ugeo = to_char(f.fst071col)
                     where u.sngc13tdoc = p.petdoc
                       and u.sngc13ndoc = p.pendoc
                       and rownum = 1) c_desdpt,
                   (select t.dotelfp
                      from fsr005 t
                     where t.petdoc = p.petdoc
                       and t.pendoc = p.pendoc
                       and rownum = 1) c_numtel,
                   '' c_mail,
                   case
                     when p.petipo = 'F' then
                      f.pffnac
                     when p.petipo = 'J' then
                      j.pjfina
                   end d_fecnac,
                   a.jaql60cali c_postra,
                   e.jaql61user c_codusu,
                   (trim(p.petdoc) || trim(p.pendoc)) c_codper,
                   '1' c_cmacli,
                   (select jaql60sucu
                      from jaql060
                     where jaql60tdoc = p.petdoc
                       and jaql60ndoc = p.pendoc
                       and rownum = 1) c_agecli,
                   
                   case
                     when p.petipo = 'F' then
                      (case
                        when to_char(nvl(f.pffnac,
                                         to_date('0001-01-01', 'YYYY-MM-DD')),
                                     'mm') = '02' and
                             to_char(nvl(f.pffnac,
                                         to_date('0001-01-01', 'YYYY-MM-DD')),
                                     'dd') = '29' then
                         (case
                           when ((mod(to_char(sysdate, 'rrrr'), 100) = 0 and
                                mod(to_char(sysdate, 'rrrr'), 400) = 0) or
                                mod(to_char(sysdate, 'rrrr'), 4) = 0) then
                           
                            to_date(to_char(sysdate, 'rrrr') ||
                                    to_char(nvl(f.pffnac,
                                                to_date('0001-01-01', 'YYYY-MM-DD')),
                                            'mm') ||
                                    to_char(nvl(f.pffnac,
                                                to_date('0001-01-01', 'YYYY-MM-DD')),
                                            'dd'),
                                    'rrrrmmdd')
                           else
                            to_date(to_char(sysdate, 'rrrr') ||
                                    to_char(nvl(f.pffnac,
                                                to_date('0001-01-01', 'YYYY-MM-DD')),
                                            'mm') || '28',
                                    'rrrrmmdd')
                         end)
                        else
                         to_date(to_char(sysdate, 'rrrr') ||
                                 to_char(nvl(f.pffnac,
                                             to_date('0001-01-01', 'YYYY-MM-DD')),
                                         'mm') ||
                                 to_char(nvl(f.pffnac,
                                             to_date('0001-01-01', 'YYYY-MM-DD')),
                                         'dd'),
                                 'rrrrmmdd')
                      end)
                     when p.petipo = 'J' then
                      (case
                        when to_char(nvl(j.pjfina,
                                         to_date('0001-01-01', 'YYYY-MM-DD')),
                                     'mm') = '02' and
                            
                             to_char(nvl(j.pjfina,
                                         to_date('0001-01-01', 'YYYY-MM-DD')),
                                     'dd') = '29' then
                         (case
                           when ((mod(to_char(sysdate, 'rrrr'), 100) = 0 and
                                mod(to_char(sysdate, 'rrrr'), 400) = 0) or
                                mod(to_char(sysdate, 'rrrr'), 4) = 0) then
                           
                            to_date(to_char(sysdate, 'rrrr') ||
                                    to_char(nvl(j.pjfina,
                                                to_date('0001-01-01', 'YYYY-MM-DD')),
                                            'mm') ||
                                    to_char(nvl(j.pjfina,
                                                to_date('0001-01-01', 'YYYY-MM-DD')),
                                            'dd'),
                                    'rrrrmmdd')
                           else
                            to_date(to_char(sysdate, 'rrrr') ||
                                    to_char(nvl(j.pjfina,
                                                to_date('0001-01-01', 'YYYY-MM-DD')),
                                            'mm') || '28',
                                    'rrrrmmdd')
                         end)
                        else
                         to_date(to_char(sysdate, 'rrrr') ||
                                 to_char(nvl(j.pjfina,
                                             to_date('0001-01-01', 'YYYY-MM-DD')),
                                         'mm') ||
                                 to_char(nvl(j.pjfina,
                                             to_date('0001-01-01', 'YYYY-MM-DD')),
                                         'dd'),
                                 'rrrrmmdd')
                      end)
                   end d_fecvis
            
              from jaql060 a
             inner join jaql061 e
                on a.jaql60pais = e.jaql61pais
               and a.jaql60tdoc = e.jaql61tdoc
               and a.jaql60ndoc = e.jaql61ndoc
             inner join fsd001 p
                on a.jaql60pais = p.pepais
               and a.jaql60tdoc = p.petdoc
               and a.jaql60ndoc = p.pendoc
              left join fsd002 f
                on a.jaql60pais = f.pfpais
               and a.jaql60tdoc = f.pftdoc
               and a.jaql60ndoc = f.pfndoc
              left join fsd003 j
                on a.jaql60pais = j.pjpais
               and a.jaql60tdoc = j.pjtdoc
               and a.jaql60ndoc = j.pjndoc
             where a.jaql60cali = 'A'
               and e.jaql61esta = 'S'
               and p.petipo in ('F', 'J')
               and p.petdoc in (9, 21)
                ) tmp
       where ( d_fecvis - 1 ) = P_D_FECPRO
       and d_fecnac is not null;
  
  end;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_ah_data_interesados(P_D_FECPRO in date)
  -- *****************************************************************
  -- Nombre                     : SP_AH_DATA_INTERESADOS
  -- Sistema                    : SORFY
  -- Módulo                     : Ahorros
  -- Versión                    : 1.0
  -- Fecha de Creación          : 24/06/2011
  -- Autor de Creación          : DRODRIGUEZD
  -- Uso                        : Obtener data de clientes interesados
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_D_FECPRO ( FECHA DE PROCESO )
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación: 2011.03.01 DRODRIGUEZD -> Eliminar clasificación G
  --                              2011.05.31 DRODRIGUEZD -> No asignar clientes interesados a rol BO01
  --                              2011.06.30 DRODRIGUEZD -> No asignar clientes interesados a rol BO01  
  --                              2011.08.25 DRODRIGUEZD -> Con fecha de visita = P_D_FECPRO  
  -- *****************************************************************    
  is
  
  begin

  -- interesados con fecha de visita
  insert into JAQL405
    (d_fecpro,
     d_fecvis,
     c_nomcon,
     c_tipdoc,
     c_numdoc,
     c_dircon,
     c_dirdis,
     c_dirpro,
     c_dirdpt,
     c_telefo,
     c_codepa,
     c_codcma,
     c_codage,
     c_tipcam,
     c_codubi,
     c_tipper,
     c_dirref,
     c_codmon,
     n_mtoint,
     n_proint,
     d_fecreg,
     c_usureg,
     c_indrec,
     c_horvis,
     --n_nroreg,
     c_poscli
     )
    select distinct P_D_FECPRO,
           tmp.d_fecvis,
           tmp.c_nomcon,
           tmp.c_tipdoc,
           tmp.c_numdoc,
           tmp.c_dircon,
           tmp.c_desdis,
           tmp.c_despro,
           tmp.c_desdpt,
           tmp.c_numtel,
           tmp.c_codusu,
           tmp.c_codcma,
           tmp.c_codage,
           tmp.c_tipcam,
           tmp.c_ubgdir,
           tmp.c_tipper,
           tmp.c_desref,
           tmp.c_codmon,
           tmp.n_mtoint,
           tmp.n_codpro,
           tmp.d_fecreg,
           tmp.c_usureg,
           tmp.c_clirec,
           tmp.c_horvis,
           --SQ_AH_AHDDAGA.Nextval,
           nvl((select jaql60cali from jaql060 where jaql60tdoc = tmp.c_tipdoc and jaql60ndoc = tmp.c_numdoc and rownum = 1),'G') 
      from (            
          select c.csw01fch d_fecvis,
                 case
                   when a.petipo = 'F' then
                    (select trim(f2.pfape1) || ' ' || trim(f2.pfape2) || ', ' ||
                            trim(f2.pfnom1) || ' ' || trim(f2.pfnom2)
                       from fsd002 f2
                      where a.pepais = f2.pfpais
                        and a.petdoc = f2.pftdoc
                        and a.pendoc = f2.pfndoc)
                   when a.petipo = 'J' then
                    (select trim(f3.pjrazs)
                       from fsd003 f3
                      where a.pepais = f3.pjpais
                        and a.petdoc = f3.pjtdoc
                        and a.pendoc = f3.pjndoc)
                 end c_nomcon,
                 d.spptipo c_tipdoc,
                 trim(d.spodoc) c_numdoc,
                 (select u.sngc13dir
                    from sngc13 u
                   where u.sngc13tdoc = d.spptipo
                     and u.sngc13ndoc = d.spodoc
                     and rownum = 1) c_dircon,
                 (select f.fst071dsc
                    from fst071 f
                   inner join sngc13 u
                      on u.sngc13ugeo = to_char(f.fst071col)
                   where u.sngc13tdoc = a.petdoc
                     and u.sngc13ndoc = a.pendoc
                     and rownum = 1) c_desdis,
                 (select d.locnom
                    from fst071 f
                   inner join fst070 d
                      on d.loccod = f.fst071loc
                   inner join sngc13 u
                      on u.sngc13ugeo = to_char(f.fst071col)
                   where u.sngc13tdoc = a.petdoc
                     and u.sngc13ndoc = a.pendoc
                     and rownum = 1) c_despro,
                 (select k.depnom
                    from fst071 f
                   inner join fst068 k
                      on k.depcod = f.fst071dpt
                   inner join sngc13 u
                      on u.sngc13ugeo = to_char(f.fst071col)
                   where u.sngc13tdoc = a.petdoc
                     and u.sngc13ndoc = a.pendoc
                     and rownum = 1) c_desdpt,
                 (select t.dotelfp
                    from fsr005 t
                   where t.pepais = a.pepais
                     and t.petdoc = a.petdoc
                     and t.pendoc = a.pendoc
                     and rownum = 1) c_numtel,
                 '1' c_codcma,
                 (select ubsuc
                    from fst046
                   where trim(ubuser) like trim(r.csw011usu)
                     and rownum = 1) c_codage,
                 '04' c_tipcam,
                 (select u.sngc13ugeo
                    from sngc13 u
                   where u.sngc13tdoc = d.spptipo
                     and u.sngc13ndoc = d.spodoc
                     and rownum = 1) c_ubgdir,
                 a.petipo c_tipper,
                 substr((select u.sngc13ref1
                          from sngc13 u
                         where u.sngc13tdoc = d.spptipo
                           and u.sngc13ndoc = d.spodoc
                           and rownum = 1),
                        0,
                        99) c_desref,
                 (select cpimda
                    from cpi010
                   where cpitdoc = a.petdoc
                     and cpindoc = a.pendoc
                     and rownum = 1) c_codmon,
                 0 n_mtoint,--(to_number(substr(x.pextxt, 1, instr(x.pextxt, '.') - 1))) n_mtoint,
                 (select trim(cpimod) || trim(cpitope)
                    from cpi010
                   where cpitdoc = a.petdoc
                     and cpindoc = a.pendoc
                     and rownum = 1) n_codpro,
                 a.pefalt d_fecreg,
                 nvl(pq_ah_autogestion_ahorros.fn_ah_cliente_cartera(d.spptipo,
                                                                     d.spodoc),
                     (select jaql62user
                        from jaql062
                       where jaql62sucu =
                             (select ubsuc
                                from fst046
                               where trim(ubuser) like trim(r.csw011usu)
                                 and rownum = 1)
                         and jaql62esta = 'S'
                         and rownum = 1)) c_codusu,
                 'NO' c_clirec,
                 r.csw011usu c_usureg,
                 c.csw01hra c_horvis,
                 trim(d.spptipo) || trim(d.spodoc) c_codper
            from fsd001 a
           inner join fse201 d
              on a.pepais = d.sppepais
             and a.petdoc = d.sppetdoc
             and a.pendoc = d.sppendoc
           inner join fsx001 x
              on x.petdoc = d.spptipo
             and x.pendoc = d.spodoc
            left join csw01 c
              on a.pepais = c.csw01pai
             and a.petdoc = c.csw01tdc
             and a.pendoc = c.csw01ndc
            left join csw011 r
              on a.pepais = r.csw011pai
             and a.petdoc = r.csw011tdo
             and a.pendoc = r.csw011ndo
           where (a.pepais = 999 and a.petdoc = 99)
             and (a.pefbaj = to_date('0001-01-01', 'YYYY-MM-DD'))
          ) tmp
     where d_fecvis = P_D_FECPRO;
     
  -- interesados sin fecha de visita
  insert into jaql405
    (d_fecpro,
     c_nomcon,
     c_tipdoc,
     c_numdoc,
     c_dircon,
     c_dirdis,
     c_dirpro,
     c_dirdpt,
     c_telefo,
     c_codepa,
     c_codcma,
     c_codage,
     c_tipcam,
     c_codubi,
     c_tipper,
     c_dirref,
     c_codmon,
     n_mtoint,
     n_proint,
     d_fecreg,
     c_usureg,
     c_indrec,
     c_horvis,
     --n_nroreg,
     c_poscli
     )
    select distinct P_D_FECPRO,
           tmp.c_nomcon,
           tmp.c_tipdoc,
           tmp.c_numdoc,
           tmp.c_dircon,
           tmp.c_desdis,
           tmp.c_despro,
           tmp.c_desdpt,
           tmp.c_numtel,
           tmp.c_codusu,
           tmp.c_codcma,
           tmp.c_codage,
           tmp.c_tipcam,
           tmp.c_ubgdir,
           tmp.c_tipper,
           tmp.c_desref,
           tmp.c_codmon,
           tmp.n_mtoint,
           tmp.n_codpro,
           tmp.d_fecreg,
           tmp.c_usureg,
           tmp.c_clirec,
           tmp.c_horvis,
           --SQ_AH_AHDDAGA.Nextval,
           nvl((select jaql60cali from jaql060 where jaql60tdoc = tmp.c_tipdoc and jaql60ndoc = tmp.c_numdoc and rownum = 1),'G')
      from (
          select (a.pefalt + 1) d_fecreg,
                 case
                   when a.petipo = 'F' then
                    (select trim(f2.pfape1) || ' ' || trim(f2.pfape2) || ', ' ||
                            trim(f2.pfnom1) || ' ' || trim(f2.pfnom2)
                       from fsd002 f2
                      where a.pepais = f2.pfpais
                        and a.petdoc = f2.pftdoc
                        and a.pendoc = f2.pfndoc)
                   when a.petipo = 'J' then
                    (select trim(f3.pjrazs)
                       from fsd003 f3
                      where a.pepais = f3.pjpais
                        and a.petdoc = f3.pjtdoc
                        and a.pendoc = f3.pjndoc)
                 end c_nomcon,
                 d.spptipo c_tipdoc,
                 trim(d.spodoc) c_numdoc,
                 (select u.sngc13dir
                    from sngc13 u
                   where u.sngc13tdoc = d.spptipo
                     and u.sngc13ndoc = d.spodoc
                     and rownum = 1) c_dircon,
                 (select f.fst071dsc
                    from fst071 f
                   inner join sngc13 u
                      on u.sngc13ugeo = to_char(f.fst071col)
                   where u.sngc13tdoc = a.petdoc
                     and u.sngc13ndoc = a.pendoc
                     and rownum = 1) c_desdis,
                 (select d.locnom
                    from fst071 f
                   inner join fst070 d
                      on d.loccod = f.fst071loc
                   inner join sngc13 u
                      on u.sngc13ugeo = to_char(f.fst071col)
                   where u.sngc13tdoc = a.petdoc
                     and u.sngc13ndoc = a.pendoc
                     and rownum = 1) c_despro,
                 (select k.depnom
                    from fst071 f
                   inner join fst068 k
                      on k.depcod = f.fst071dpt
                   inner join sngc13 u
                      on u.sngc13ugeo = to_char(f.fst071col)
                   where u.sngc13tdoc = a.petdoc
                     and u.sngc13ndoc = a.pendoc
                     and rownum = 1) c_desdpt,
                 (select t.dotelfp
                    from fsr005 t
                   where t.pepais = a.pepais
                     and t.petdoc = a.petdoc
                     and t.pendoc = a.pendoc
                     and rownum = 1) c_numtel,
                 '1' c_codcma,
                 (select ubsuc
                    from fst046
                   where trim(ubuser) like trim(r.csw011usu)
                     and rownum = 1) c_codage,
                 '04' c_tipcam,
                 (select u.sngc13ugeo
                    from sngc13 u
                   where u.sngc13tdoc = d.spptipo
                     and u.sngc13ndoc = d.spodoc
                     and rownum = 1) c_ubgdir,
                 a.petipo c_tipper,
                 substr((select u.sngc13ref1
                          from sngc13 u
                         where u.sngc13tdoc = d.spptipo
                           and u.sngc13ndoc = d.spodoc
                           and rownum = 1),
                        0,
                        99) c_desref,
                 (select cpimda
                    from cpi010
                   where cpitdoc = a.petdoc
                     and cpindoc = a.pendoc
                     and rownum = 1) c_codmon,
                 (to_number(substr(x.pextxt, 1, instr(x.pextxt, '.') - 1))) n_mtoint,
                 (select trim(cpimod) || trim(cpitope)
                    from cpi010
                   where cpitdoc = a.petdoc
                     and cpindoc = a.pendoc
                     and rownum = 1) n_codpro,
                 --a.pefalt d_fecreg,
                 nvl(pq_ah_autogestion_ahorros.fn_ah_cliente_cartera(d.spptipo,
                                                                     d.spodoc),
                     (select jaql62user
                        from jaql062
                       where jaql62sucu =
                             (select ubsuc
                                from fst046
                               where trim(ubuser) like trim(r.csw011usu)
                                 and rownum = 1)
                         and jaql62esta = 'S'
                         and rownum = 1)) c_codusu,
                 nvl(pq_ah_autogestion_ahorros.fn_ah_cliente_cartera(d.spptipo,
                                                                     d.spodoc),
                     (select jaql62esta
                        from jaql062
                       where jaql62sucu =
                             (select ubsuc
                                from fst046
                               where trim(ubuser) like trim(r.csw011usu)
                                 and rownum = 1)
                         and jaql62esta = 'S'
                         and rownum = 1)) c_estado,
                 'NO' c_clirec,
                 r.csw011usu c_usureg,
                 c.csw01hra c_horvis,
                 trim(d.spptipo) || trim(d.spodoc) c_codper
            from fsd001 a
           inner join fse201 d
              on a.pepais = d.sppepais
             and a.petdoc = d.sppetdoc
             and a.pendoc = d.sppendoc
           inner join fsx001 x
              on x.petdoc = d.spptipo
             and x.pendoc = d.spodoc
            left join csw01 c
              on a.pepais = c.csw01pai
             and a.petdoc = c.csw01tdc
             and a.pendoc = c.csw01ndc
            left join csw011 r
              on a.pepais = r.csw011pai
             and a.petdoc = r.csw011tdo
             and a.pendoc = r.csw011ndo
           where (a.pepais = 999 and a.petdoc = 99)
             and (a.pefbaj = to_date('0001-01-01', 'YYYY-MM-DD'))
             and c.csw01fch is null --d_fecvis
          ) tmp
     where d_fecreg = P_D_FECPRO - 1
     and c_estado = 'S';
 
  end;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                          
    procedure sp_ah_datosAgenda(  P_C_FECPRO in varchar2,
                                  P_C_TIPREG in varchar2,
                                bl_datos in out cur_age)is
    cur_dat_age cur_age;
    begin

      open cur_dat_age for
          SELECT 
              n_nroreg,  
              c_regins,       
              c_tipper,
              c_tipdoc, 
              c_numdoc,  
              c_nomcon c_nomcom, 
              c_codubi c_ubgdir,
              c_dircon c_desdir,              
              c_telefo c_numtel,    
              c_email c_emails,
              c_codage,
              c_codper c_codsor,
              c_tipcam c_codvis,
              c_codepa c_codpro,
              n_proint,
              c_codmon c_codmod,
              n_mtoint n_monto,
              c_numcta,
              to_char(d_fecven,'rrrrmmdd') c_fecven,
              n_tastea,
              c_indrec c_clirec,
              c_poscli c_calcli,
              case when c_tipcam = '03' then  '01' end c_codmvi, --Fidelizacion - cumpleaños
              c_usureg c_ususor,
              to_char(d_fecreg,'rrrrmmdd') c_fecreg,
              to_char(d_fecvis,'rrrrmmdd') c_fecvis,
              to_char(d_fecnac,'rrrrmmdd') c_fecnac,
              c_horvis      
          FROM 
              jaql405 
          WHERE 
              d_fecpro = to_date(P_C_FECPRO,'rrrrmmdd') 
          AND NVL(c_regins,'%') like  P_C_TIPREG;     

      bl_datos := cur_dat_age;

  end sp_ah_datosAgenda;

-----------------------------------------------------------------
  procedure sp_cr_actualiza_regins( P_N_NROREG IN NUMBER,
                                    P_C_REGINS IN VARCHAR2,
                                    P_N_EXITO  OUT NUMBER
                                  ) is
  begin
   p_n_exito := 0;
   begin

       update jaql405
          set c_regins = P_C_REGINS
        where n_nroreg = P_N_NROREG;
        p_n_exito := 1;
   exception
   when others then 
       p_n_exito := 0;
  end;
  end sp_cr_actualiza_regins;
  
-----------------------------------------------------------------
procedure sp_ah_insertar_prueba(P_C_CODPRO in varchar2,
                                 P_D_FECVIS in varchar2,
                                 P_D_HORVIS in varchar2,
                                 P_C_CODCLI in varchar2,
                                 P_C_TIPDOC in number,
                                 P_C_NUMDOC in character,                                
                                 p_c_coderr out varchar2,
                                 p_c_msgerr out varchar2
                                 )is
  ld_fecvis date;
 -- ln_cont number;
  lc_hosvis varchar2(8);
  lc_fcompl timestamp;
  begin

    p_c_coderr := '0000';
    --ln_cont := 0;
    ld_fecvis := to_date(P_D_FECVIS, 'rrrr.mm.dd');
    lc_fcompl := sysdate;
   -- lc_hosvis := to_char(sysdate, 'HH:MI:SS');
    lc_hosvis := to_char(to_date(P_D_HORVIS, 'HH24:MI:SS'), 'HH:MI:SS');

   /* SELECT count(*)
      into ln_cont
    FROM JAQL108
    WHERE
      JAQL108USU = P_C_CODPRO
      AND JAQL108FCH = ld_fecvis
      AND JAQL108PTD = P_C_TIPDOC
      AND JAQL108DOC = P_C_NUMDOC;

    IF ln_cont = 0  THEN*/
      INSERT INTO JAQY678 (
                            JAQY678PAI,
                            JAQY678PTD,
                            JAQY678DOC,
                            JAQY678FCH,
                            JAQY678USU,
                            JAQY678REG,
                            JAQY678EST,
                            JAQY678HRA
                          )
                          VALUES (
                            604,
                            P_C_TIPDOC,
                            P_C_NUMDOC,
                            ld_fecvis,
                            P_C_CODPRO,
                            lc_fcompl,  
                            P_C_CODCLI,     
                            lc_hosvis
                          );
   -- END IF;

    commit;
  exception
    when others then
      p_c_coderr := sqlcode;
      p_c_msgerr := sqlerrm;
  end;
    

end PQ_AH_AUTOGESTION_AHORROS;
/

