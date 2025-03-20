CREATE OR REPLACE TRIGGER TG_INS_FSD450
  before insert on FSD450
  for each row

DECLARE
  pc_codusu     varchar2(10);
  ld_fecpro     date;
  lc_coderr     varchar2(400);
  lc_deserr     varchar2(400);
  ln_jaqz188cte number(9) := 0;

  pn_hcmod     fst003.modulo%type;
  pn_htran     fsd015.ittran%type;
  pn_hsucor    fsd015.itsuc%type;
  pn_pgcod     fst017.pgcod%type;
  pd_fecpro    fst017.pgfape%type;
  pc_hora      char(8);
  lc_cuenta    char(27);
  lc_usuario   char(10);
  ln_estact    fsd011.scstat%type;
  WrkstName    VARCHAR2(50);
  ExistConData NUMBER;

  lv_pj     char(1);
  lv_inac   char(1);
  ld_fecval date;

BEGIN
  pc_codusu := SUBSTR(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'), 1, 10);
  begin
    Select a.pgfape into ld_fecpro from fst017 a where a.pgcod = 1;
  exception
    when others then
      ld_fecpro := trunc(sysdate);
  end;
  --
  -- Actualizamos tabla jaqz193 de registro de regularización de documentos digitales
  --
  If :new.cbiemod = 21 and :new.cbietop = 2 and :new.cbieant = 4 then
    begin
    
      Select R1cta
        into ln_jaqz188cte
        from fsr011
       Where R2cod = :new.cbieemp
         and R2mod = :new.cbiemod
         and R2suc = :new.cbiesuc
         and R2mda = :new.cbiemda
         and R2pap = :new.cbiepap
         and R2cta = :new.cbiecta
         and R2oper = :new.cbieope
         and R2sbop = :new.cbiesub
         and R2tope = :new.cbietop
         and Relcod = 45
         and R011co = 'S';
    exception
      when others then
        ln_jaqz188cte := 0;
    end;
  
    pq_ah_enviodigital.sp_ah_registra_envio(p_n_pgcod  => :new.cbieemp,
                                            p_n_scmod  => :new.cbiemod,
                                            p_n_scsuc  => :new.cbiesuc,
                                            p_n_scmda  => :new.cbiemda,
                                            p_n_scpap  => :new.cbiepap,
                                            p_n_sccta  => :new.cbiecta,
                                            p_n_scoper => :new.cbieope,
                                            p_n_scsbop => :new.cbiesub,
                                            p_n_sctope => :new.cbietop,
                                            p_n_ctaemp => ln_jaqz188cte,
                                            p_c_codusu => pc_codusu,
                                            p_c_desmot => 'Regularización en Agencia',
                                            p_d_fecpro => ld_fecpro,
                                            p_n_codmed => 3, --REGULARIZACION
                                            p_c_coderr => lc_coderr,
                                            p_c_deserr => lc_deserr);
  End IF;
  --fin

  If :new.CBIEANT = 81 and :new.HCMOD <> 0 and :new.cbiemod in (21, 22) then
    pq_ah_comision.sp_ah_exonera_inactiva(p_n_pgcod  => :new.CBIEEMP,
                                          p_n_ctnro  => :new.CBIECTA,
                                          p_n_itoper => :new.CBIEOPE,
                                          p_n_itsubo => :new.CBIESUB,
                                          p_n_sucdes => :new.CBIESUC,
                                          p_n_ittope => :new.CBIETOP,
                                          p_n_modulo => :new.CBIEMOD,
                                          p_n_moneda => :new.CBIEMDA,
                                          p_n_papel  => :new.CBIEPAP,
                                          p_d_fecpro => :new.CBIEFEC,
                                          p_c_codusu => pc_codusu --se adiciono parametro                                          
                                          );
  End If;

  If :new.CBIEANT in (6, 7) then
    pq_cl_autonomias.sp_ah_mail_actcta_pj(pn_codpgc => :new.CBIEEMP,
                                          pn_codmod => :new.CBIEMOD,
                                          pn_codsuc => :new.CBIESUC,
                                          pn_codmda => :new.CBIEMDA,
                                          pn_codpap => :new.CBIEPAP,
                                          pn_codcta => :new.CBIECTA,
                                          pn_codope => :new.CBIEOPE,
                                          pn_codsub => :new.CBIESUB,
                                          pn_codtpo => :new.CBIETOP,
                                          pn_estant => :new.CBIEANT,
                                          pc_codusu => pc_codusu);
  End If;

  if :new.HCMOD <> 0 and :new.cbiemod in (21, 22) then
    pn_pgcod := 1;
    pn_hcmod := 800;
    pn_htran := 503;
  
    begin
      select a.pgfape
        into pd_fecpro
        from fst017 a
       where a.pgcod = pn_pgcod;
    end;
    -- Call the procedure
    begin
      select a.exusso, a.exhora
        into lc_usuario, pc_hora
        from fsh010 a
       where a.pgcod = :new.pgcod
         and a.hcmod = :new.hcmod
         and a.hsucor = :new.hsucor
         and a.htran = :new.htran
         and a.hnrel = :new.hnrel
         and a.hfcont = :new.hfcont
         and a.hcord = :new.hcord
         and a.hcsubo = :new.hcsubo
         and a.excod = :new.excod;
    exception
      when others then
        pc_hora    := to_char(sysdate, 'HH24:mi:ss');
        lc_usuario := SUBSTR(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'),
                             1,
                             10);
    end;
  
    begin
      select UBSUC into pn_hsucor from fst046 where ubuser = lc_usuario;
    exception
      when others then
        pn_hsucor := 999;
    end;
  
    if :new.cbiemod = 21 then
      lc_cuenta := lpad(:new.cbiecta, 9, '0') || lpad(:new.cbiemod, 3, '0') ||
                   lpad(:new.cbiemda, 3, '0') || lpad(:new.cbiesub, 2, '0') ||
                   lpad(:new.cbietop, 3, '0');
    else
      lc_cuenta := lpad(:new.cbiecta, 9, '0') || lpad(:new.cbiemod, 3, '0') ||
                   lpad(:new.cbiemda, 3, '0') || lpad(:new.cbieope, 9, '0') ||
                   lpad(:new.cbietop, 3, '0');
    end if;
  
    begin
      select a.scstat, scfval
        into ln_estact, ld_fecval
        from fsd011 a
       where a.pgcod = :new.cbieemp
         and a.scsuc = :new.cbiesuc
         and a.sccta = :new.cbiecta
         and a.scmod = :new.cbiemod
         and a.scmda = :new.cbiemda
         and a.scpap = :new.cbiepap
         and a.scoper = :new.cbieope
         and a.scsbop = :new.cbiesub
         and a.sctope = :new.cbietop;
    Exception
      When others then
        ln_estact := 99;
    end;
  
    SELECT COUNT(*)
      INTO ExistConData
      FROM DBA_OBJECTS
     WHERE OWNER = sys_context('userenv', 'current_schema')
       AND OBJECT_TYPE = 'TABLE'
       AND OBJECT_NAME = 'CONDATA';
  
    if ExistConData > 0 then
      begin
        SELECT MAX(Value) INTO WrkstName FROM CONDATA WHERE Data = 'WRKST'; --'SERVER'
      exception
        when others then
          WrkstName := null;
      end;
    else
      SELECT COALESCE(WrkstName,
                      sys_context('USERENV', 'HOST'),
                      'NOTDEFINED')
        INTO WrkstName
        FROM dual;
    end if;
  
    pq_op_asientos_mplus.sp_op_registra_jaql977a(pn_pgcod  => pn_pgcod,
                                                 pn_hcmod  => pn_hcmod,
                                                 pn_hsucor => pn_hsucor,
                                                 pn_htran  => pn_htran,
                                                 pn_hnrel  => 0,
                                                 pd_fecpro => pd_fecpro,
                                                 pc_uing   => lc_usuario,
                                                 pc_hora   => pc_hora,
                                                 pc_cont   => 'S',
                                                 pn_corr   => 0,
                                                 pn_pais   => :new.CBIEANT,
                                                 pn_tipo   => ln_estact,
                                                 pc_numero => to_char(:new.cbiesub),
                                                 pc_valant => lc_cuenta ||
                                                              substr(WrkstName,
                                                                     1,
                                                                     15),
                                                 pc_valact => to_char(:new.cbiesuc));
  end if;

  --------- vigencia tasa especial por cambio de tarifario 20200601 maraujo------
  if :new.CBIEANT = 81 and :new.cbiemda = 0 and :new.cbiemod = 21 and
     :new.cbietop = 1 and ld_fecval <= to_date('31/05/2020', 'dd/mm/yyyy') then
  
    lv_pj := 'N';
    begin
      select 'S'
        into lv_pj
        from fsd008 b
       where b.pgcod = :new.cbieemp
         and b.ctnro = :new.cbiecta
         and b.ctccli = 2;
    exception
      when others then
        lv_pj := 'N';
    end;
  
    begin
      select 'S'
        into lv_inac
        from (select *
                from fsd450 z
               where cbieemp = :new.cbieemp
                 and cbiesuc = :new.cbiesuc
                 and cbiecta = :new.cbiecta
                 and cbiemod = :new.cbiemod
                 and cbiemda = :new.cbiemda
                 and cbiepap = :new.cbiepap
                 and cbieope = :new.cbieope
                 and cbiesub = :new.cbiesub
                 and cbietop = :new.cbietop
                 and cbiefec < ld_fecpro
               order by cbiefec desc)
       where rownum = 1
         and cbiefec <= to_date('31/05/2020', 'dd/mm/yyyy');
    end;
  
    if lv_pj = 'S' and lv_inac = 'S' then
      update FSD328 --si es pj y su inactivación fue antes del cambio de tasa
         set vtasfvto = ld_fecpro + 45
       where vtasemp = :new.cbieemp
         and vtasmod = :new.cbiemod
         and vtaspiz = 92
         and vtascta = :new.cbiecta
         and vtassop = :new.cbiesub
         and vtasmda = :new.cbiemda
         and vtaspap = :new.cbiepap
         and vtasfdes = to_date('01/06/2020', 'dd/mm/yyyy');
    
    end if;
  end if;

Exception
  When others then
    null;
END TG_INS_FSD605;
/

