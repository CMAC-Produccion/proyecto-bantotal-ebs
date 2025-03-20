create or replace procedure SP_CR_CORREO_APROBACION(P_N_PGCOD  IN number,
                                                    P_N_SCSUC  IN number,
                                                    P_N_SCMDA  IN number,
                                                    P_N_SCPAP  IN number,
                                                    P_N_SCCTA  IN number,
                                                    P_N_SCOPER IN number,
                                                    P_N_SCSBOP IN number,
                                                    P_N_SCTOPE IN number,
                                                    P_N_SCMOD  IN number,
                                                    P_V_UBUSER IN varchar2,
                                                    P_V_TIPO   IN varchar2,
                                                    P_D_PGFAPE IN date,
                                                    p_n_coderr out number,
                                                    p_c_msgerr out varchar2) is
  -- Author  : HSUAREZ
  -- Created : 29/01/2021 09:42:39
  -- Purpose : Envio de correo de Aprobacion
  -- Modificacion: APACHECOH
  -- Fecha Modificacion: 14/02/2023
  -- Descripción: Se agregó una validación para que al aprobar o rechazar se envie el correo directamente al usuario que lo hizo
  -- Modificacion: HSUAREZ
  -- Fecha Modificacion: 01/07/2024
  -- Descripción: Se realiza una modificación al proceso actual.
  -- Modificacion: HSUAREZ
  -- Fecha Modificacion: 16/09/2024
  -- Descripción: Se realiza una modificación para los correos de reprogramados sin CRM
  
  CURSOR lista_Aprobadores_sinCRM(vi_codrpg in number,vi_instance in number,vi_fecharpg in date) is
    select *
      from aqpd157 a
     where a.aqpd157codrep = vi_codrpg
       and a.aqpd157inst   = vi_instance
       and a.aqpd157fecapro= vi_fecharpg
       and a.aqpd157est    = 'P'
       and a.AQPD157REQ    = 'S';
  CURSOR lista_gerente(viagencia in number, vicargo in number) is
    select b.sng057usr
      from sng057 b, fst046 d
     where b.sng057usr = d.ubuser
       and b.sng055emp = d.pgcod
       and b.sng055emp = P_N_PGCOD
       and b.sng055car = vicargo
       and (not (b.sng057ini <= P_D_PGFAPE and b.sng057fin >= P_D_PGFAPE AND
            b.sng057sup IS NOT NULL))
       and d.ubsuc = viagencia;

  vagencia   fst046.ubsuc%type;
  vubuser    fst046.ubuser%type := rpad(P_V_UBUSER, 10, ' ');
  vcargog    number(3) := 202;
  vanalista  fst046.ubuser%type;
  vgerente   fst046.ubuser%type;
  vgerente2  fst046.ubuser%type;
  vgerentec  fst046.ubuser%type;
  vcliente   fsd001.penom%type;
  vcapital   fsd011.scsdo%type;
  p_c_coderr varchar2(3);

  lv_correog  VARCHAR2(4000) := '';
  lv_correog2 VARCHAR2(1000) := '';
  lv_cont     number := 0;
  lv_tmp_mail VARCHAR2(100) := '';
  lv_correoa  VARCHAR2(4000) := '';
  lv_estado   varchar2(100);

  ll_mensaje    CLOB;
  lv_mensaje    VARCHAR2(32767);
  lv_remitente  VARCHAR2(90);
  lv_asunto     VARCHAR2(200);
  lv_directorio VARCHAR2(40) := '';
  lv_destinos   VARCHAR2(4000) := '';
  lv_destinos_c VARCHAR2(4000) := '';
  lv_archivo    VARCHAR2(100) := '';
  l_bfile       BFILE;
  l_blob        BLOB;

  lv_cuentat VARCHAR2(100);
  vmosign    fst005.mosign%type;
  vsaldocons number(17, 2);
  flag_enc   char(1);
  -----
  vi_aqpb556cod    number(10);
  vi_aqpb556tprg   number(3);
  vi_aqpb556pais   number(3);
  vi_AQPB556PTDC   number(2);
  vi_AQPB556DNI    varchar(12);
  vi_TIPOCAMBIO    number(10, 6);
  VI_REGCOD        NUMBER(3);
  vi_AQPB556INST   number(10);
  vi_AQPB556tcov   char(1);
  vi_pFechaN       date;
  vi_fecha         date;
  vi_AQPB556CONS   number(17, 2);
  vi_cargo         number(3);
  vi_dcargo        varchar(30);
  v_mensaje_a      varchar(100);
  v_mensaje_covid  varchar(60); --25/08/2021
  vi_mensaje       varchar(400);
  VI_MENSAJEA      VARCHAR(450);
  VI_APROBADOR     varchar(10);
  VI_APROBADOR_SUP varchar(10);
  VI_PERFIL        number(3);
  vo_Cargo         number(3);
  vi_perfilc       varchar(30);
  vi_contador      number(10);
  vi_fecharpg      date;
  --variables de envio de correos para el nivel multiple
  vi_usuarios_aprobador varchar(150);
  vi_cargos_aprobador varchar(300);
  --
  vi_cargo_papr varchar(150);
  vi_usr_papr   varchar(150);
  vi_email_papr varchar(50);
  vi_correos    varchar(300);
  --
  vo_coderror   varchar(5);
  vo_msgerror   varchar(150);
  ----
  VOI_N_COD_TRPG NUMBER(9);
  VOI_V_DSC_TRPG VARCHAR(250);
begin
                                 
  --manda mail a gerente
  --busca agencia de analista

  p_c_coderr := '00';
  -- SUCURSAL DE LA AGENCIA
  begin
    select a.ubsuc
      into vagencia
      from fst046 a
     where a.pgcod = P_N_PGCOD
       and a.ubuser = vubuser;
  exception
    when others then
      p_c_coderr := '01';
      p_c_msgerr := 'No se encontró agencia';
  end;

  if p_c_coderr = '00' then  
    -- Busca a gerente de agencia
    -- 
    begin
      select b.sng057usr
        into vgerente
        from sng057 b, fst046 d, prfu00 p
       where b.sng057usr = d.ubuser
         and b.sng055emp = d.pgcod
         and b.sng055emp = P_N_PGCOD
         and b.sng055car = vcargog
         and p.ubuser = d.ubuser
         and p.prfgcod not in ('CESADO')
         and d.ubsuc <> 904
         and (not (b.sng057ini <= P_D_PGFAPE and b.sng057fin >= P_D_PGFAPE AND
              b.sng057sup IS NOT NULL))
         and d.ubsuc = vagencia;
    exception
      when too_many_rows then
        BEGIN
          lv_correog2 := '';
          lv_cont     := 1;
          FOR i in lista_gerente(vagencia, vcargog) LOOP
            BEGIN
              vgerente2 := i.sng057usr;
            
              begin
                select wfusremail
                  into lv_correog
                  from WFUSERS
                 where wfusrcod = vgerente2;
              exception
                when others then
                  p_c_coderr := '05';
                  p_c_msgerr := 'No se encontró correo gerente';
              end;
              if trim(lv_correog) <> '' or lv_correog is not null then
                if lv_cont > 1 and lv_correog2 is not null and
                   trim(lv_correog2) <> '' then
                  lv_correog2 := trim(lv_correog2) || ';' ||
                                 trim(lv_correog);
                else
                  lv_correog2 := trim(lv_correog);
                end if;
              end if;
              lv_correog := '';
              lv_cont    := lv_cont + 1;
            END;
          END LOOP;
        END;
      when no_data_found then
        BEGIN
          select b.sng057sup
            into vgerente
            from sng057 b, fst046 d
           where b.sng057usr = d.ubuser
             and b.sng055emp = d.pgcod
             and b.sng055emp = P_N_PGCOD
             and b.sng055car = vcargog
             and b.sng057ini <= P_D_PGFAPE
             and b.sng057fin >= P_D_PGFAPE
             and d.ubsuc = vagencia;
        EXCEPTION
          WHEN OTHERS THEN
            p_c_coderr := '02';
            p_c_msgerr := 'No se encontró gerente SUPLENTE';
        END;
      when others then
        p_c_coderr := '02';
        p_c_msgerr := 'No se encontró gerente';
    end;
  end if;
  if vagencia = 904 then
    p_c_coderr := '00';
    vgerente   := vubuser;
  end if;
  if p_c_coderr = '00' then
    begin
      select y.penom,
             x.aqpb556scap,
             x.aqpb556usrr,
             x.aqpb556scons,
             x.aqpb556pais,
             x.aqpb556ptdc,
             x.aqpb556dni,
             x.Aqpb556inst,
             x.Aqpb556tcov,
             x.aqpb556cod,
             x.aqpb556tprg,
             x.aqpb556arch,
             x.aqpb556fecrpg
        into vcliente,
             vcapital,
             vanalista,
             vsaldocons,
             vi_aqpb556pais,
             vi_AQPB556PTDC,
             vi_AQPB556DNI,
             vi_AQPB556INST,
             vi_AQPB556tcov,
             vi_aqpb556cod,
             vi_aqpb556tprg,
             LV_ARCHIVO,
             vi_fecharpg
        from aqpb556 x, fsd001 y
       where x.aqpb556pais = y.pepais
         and x.aqpb556ptdc = y.petdoc
         and rpad(x.aqpb556dni, 12, ' ') = y.pendoc
         and x.aqpb556emp = P_N_PGCOD
         and x.aqpb556mod = P_N_SCMOD
         and x.aqpb556suc = P_N_SCSUC
         and x.aqpb556mda = P_N_SCMDA
         and x.aqpb556pap = P_N_SCPAP
         and x.aqpb556cta = P_N_SCCTA
         and x.aqpb556oper = P_N_SCOPER
         and x.aqpb556sbop = P_N_SCSBOP
         and x.aqpb556top = P_N_SCTOPE
         AND x.aqpb556ehab = 'H'
         AND x.Aqpb556cod = (select max(AQPB556COD)
                               from aqpb556 dd
                              where dd.aqpb556emp = P_N_PGCOD
                                and dd.aqpb556mod = P_N_SCMOD
                                and dd.aqpb556suc = P_N_SCSUC
                                and dd.aqpb556mda = P_N_SCMDA
                                and dd.aqpb556pap = P_N_SCPAP
                                and dd.aqpb556cta = P_N_SCCTA
                                and dd.aqpb556oper = P_N_SCOPER
                                and dd.aqpb556sbop = P_N_SCSBOP
                                and dd.aqpb556top = P_N_SCTOPE
                                AND dd.aqpb556ehab = 'H');
    exception
      when others then
        if P_V_TIPO = 'M' then
          begin
            select y.penom,
                   abs(w.scsdo),
                   z.sng001ase,
                   z.sng001pais,
                   z.sng001tdoc,
                   z.sng001ndoc,
                   x.jaqz698inst,
                   x.jaqz698cor
              into vcliente,
                   vcapital,
                   vanalista,
                   vi_aqpb556pais,
                   vi_AQPB556PTDC,
                   vi_AQPB556DNI,
                   vi_AQPB556INST,
                   vi_aqpb556cod
              from jaqz698 x, fsd001 y, sng001 z, fsd011 w
             where z.sng001pais = y.pepais
               and z.sng001tdoc = y.petdoc
               and rpad(z.sng001ndoc, 12, ' ') = y.pendoc
               and x.jaqz698inst = z.sng001inst
               and x.jaqz698emp = P_N_PGCOD
               and x.jaqz698mod = P_N_SCMOD
               and x.jaqz698suc = P_N_SCSUC
               and x.jaqz698mda = P_N_SCMDA
               and x.jaqz698pap = P_N_SCPAP
               and x.jaqz698cta = P_N_SCCTA
               and x.jaqz698ope = P_N_SCOPER
               and x.jaqz698sbo = P_N_SCSBOP
               and x.jaqz698top = P_N_SCTOPE
               and x.jaqz698emp = w.pgcod
               and x.jaqz698mod = w.scmod
               and x.jaqz698suc = w.scsuc
               and x.jaqz698mda = w.scmda
               and x.jaqz698pap = w.scpap
               and x.jaqz698cta = w.sccta
               and x.jaqz698ope = w.scoper
               and x.jaqz698sbo = w.scsbop
               and x.jaqz698top = w.sctope
               and x.jaqz698est = 'C'
               and x.jaqz698nu2 = 2
               and rownum = 1;
          exception
            when others then
              begin
                select y.penom,
                       abs(w.scsdo),
                       z.sng001ase,
                       z.sng001pais,
                       z.sng001tdoc,
                       z.sng001ndoc,
                       x.jaqz698inst,
                       x.jaqz698cor
                  into vcliente,
                       vcapital,
                       vanalista,
                       vi_aqpb556pais,
                       vi_AQPB556PTDC,
                       vi_AQPB556DNI,
                       vi_AQPB556INST,
                       vi_aqpb556cod
                  from jaqz698 x, fsd001 y, sng001 z, fsd011 w
                 where z.sng001pais = y.pepais
                   and z.sng001tdoc = y.petdoc
                   and rpad(z.sng001ndoc, 12, ' ') = y.pendoc
                   and x.jaqz698inst = z.sng001inst
                   and x.jaqz698emp = P_N_PGCOD
                   and x.jaqz698mod = P_N_SCMOD
                   and x.jaqz698suc = P_N_SCSUC
                   and x.jaqz698mda = P_N_SCMDA
                   and x.jaqz698pap = P_N_SCPAP
                   and x.jaqz698cta = P_N_SCCTA
                   and x.jaqz698ope = P_N_SCOPER
                   and x.jaqz698sbo = P_N_SCSBOP
                   and x.jaqz698top = P_N_SCTOPE
                   and x.jaqz698emp = w.pgcod
                   and x.jaqz698mod = w.scmod
                   and x.jaqz698suc = w.scsuc
                   and x.jaqz698mda = w.scmda
                   and x.jaqz698pap = w.scpap
                   and x.jaqz698cta = w.sccta
                   and x.jaqz698ope = w.scoper
                   and x.jaqz698sbo = (w.scsbop - 1)
                   and x.jaqz698top = w.sctope
                   and x.jaqz698est = 'C'
                   and x.jaqz698nu2 = 2
                   and rownum = 1;
              exception
                when others then
                  begin
                    select y.penom,
                           -1,
                           z.sng001ase,
                           z.sng001pais,
                           z.sng001tdoc,
                           z.sng001ndoc,
                           x.jaqz698inst,
                           x.jaqz698cor
                      into vcliente,
                           vcapital,
                           vanalista,
                           vi_aqpb556pais,
                           vi_AQPB556PTDC,
                           vi_AQPB556DNI,
                           vi_AQPB556INST,
                           vi_aqpb556cod
                      from jaqz698 x, fsd001 y, sng001 z
                     where z.sng001pais = y.pepais
                       and z.sng001tdoc = y.petdoc
                       and rpad(z.sng001ndoc, 12, ' ') = y.pendoc
                       and x.jaqz698inst = z.sng001inst
                       and x.jaqz698emp = P_N_PGCOD
                       and x.jaqz698mod = P_N_SCMOD
                       and x.jaqz698suc = P_N_SCSUC
                       and x.jaqz698mda = P_N_SCMDA
                       and x.jaqz698pap = P_N_SCPAP
                       and x.jaqz698cta = P_N_SCCTA
                       and x.jaqz698ope = P_N_SCOPER
                       and x.jaqz698sbo = P_N_SCSBOP
                       and x.jaqz698top = P_N_SCTOPE
                       and x.jaqz698est = 'C'
                       and x.jaqz698nu2 = 2
                       and rownum = 1;
                  exception
                    when others then
                      null;
                  end;
              end;
          end;
        else
          p_c_coderr := '03';
          p_c_msgerr := 'No se encontró cliente';
        end if;
    end;
  end if;

  lv_remitente := 'notificacionesbantotal@cajaarequipa.pe';
  lv_asunto    := 'REPROGRAMACION CLIENTE ' || upper(trim(vcliente));

  if p_c_coderr = '00' then
    begin
      select mosign into vmosign from fst005 where moneda = P_N_SCMDA;
    exception
      when others then
        p_c_coderr := '04';
        p_c_msgerr := 'No se encontró moneda';
    end;
  end if;

  if p_c_coderr = '00' then
    if lv_correog2 is not null OR lv_correog2 <> '' then
      lv_correog := lv_correog2;
    else
      begin
        select wfusremail
          into lv_correog
          from WFUSERS
         where wfusrcod = vgerente;
      exception
        when others then
          p_c_coderr := '05';
          p_c_msgerr := 'No se encontró correo gerente';
      end;
    end if;
  end if;

  if p_c_coderr = '00' then
  
    begin
      select wfusremail
        into lv_correoa
        from WFUSERS
       where wfusrcod = vanalista;
    exception
      when others then
        p_c_coderr := '05';
        p_c_msgerr := 'No se encontró correo analista';
    end;
  end if;

  if p_c_coderr = '00' then
  
    lv_cuentat := 'cuenta ' || trim(to_char(P_N_SCCTA)) || ' y operación ' ||
                  trim(to_char(P_N_SCOPER)) || ' por ' || trim(vmosign) ||
                  trim(to_char(vcapital, '9,999,999.99'));
    dbms_lob.createtemporary(ll_mensaje, TRUE);
  
    Case
      WHEN P_V_TIPO = 'G' THEN
        -----------------------------------
        begin
          SELECT pgfape INTO vi_pFechaN FROM FST017 WHERE pgcod = 1;
        end;
        BEGIN
          SELECT TRIM(J.JAQA400AC1)
            INTO vi_AQPB556tcov
            FROM JAQA400 J
           WHERE J.JAQA400EMP = P_N_PGCOD
             AND J.JAQA400MOD = P_N_SCMOD
             AND J.JAQA400SUC = P_N_SCSUC
             AND J.JAQA400MDA = P_N_SCMDA
             AND J.JAQA400PAP = P_N_SCPAP
             AND J.JAQA400CTA = P_N_SCCTA
             AND J.JAQA400OPE = P_N_SCOPER
             AND J.JAQA400SBO = P_N_SCSBOP
             AND J.JAQA400TOP = P_N_SCTOPE
             AND J.JAQA400FEC =
                 (select MAX(JAQA400FEC)
                    FROM JAQA400 D
                   WHERE D.JAQA400EMP = P_N_PGCOD
                     AND D.JAQA400MOD = P_N_SCMOD
                     AND D.JAQA400SUC = P_N_SCSUC
                     AND D.JAQA400MDA = P_N_SCMDA
                     AND D.JAQA400PAP = P_N_SCPAP
                     AND D.JAQA400CTA = P_N_SCCTA
                     AND D.JAQA400OPE = P_N_SCOPER
                     AND D.JAQA400SBO = P_N_SCSBOP
                     AND D.JAQA400TOP = P_N_SCTOPE)
             and ROWNUM = 1;
        exception
          when others then
            vi_AQPB556tcov := 'C';
        END;
        if vi_AQPB556tcov != 'U' or vi_AQPB556tcov is null then
          if vi_aqpb556tprg = 1 then
            v_mensaje_covid := 'Tipo Reprogramación: Reprogramación Covid Consensuado';
          end if;
          if vi_aqpb556tprg = 2 then
            v_mensaje_covid := 'Tipo Reprogramación: Reprogramación Gobierno';
          end if;
          if vi_aqpb556tprg = 3 then
            v_mensaje_covid := 'Tipo Reprogramación: Reprogramación Caja';
          end if;
          if vi_aqpb556tprg = 4 then
            v_mensaje_covid := 'Tipo Reprogramación: Reprogramación Fondos';
          end if;
          if vi_aqpb556tprg > 5 then
            v_mensaje_covid := 'Tipo Reprogramación: Reprogramacion General';
          end if;
          --ARBOL DE APROBACION CAJA
          if vi_aqpb556tprg = 3 then
            pq_cr_reprog_sin_cap.SP_CRD_ARBOL_APROBACION_CAJA2024(vi_aqpb556cod,
                                                                  vi_AQPB556INST,
                                                                  vi_Cargo,
                                                                  vi_perfilc);
            BEGIN
              --OBTENER CODIGO DE REGION
              BEGIN
                SELECT F.REGCOD
                  INTO VI_REGCOD
                  FROM FST811 F
                 WHERE F.OFICOD = P_N_SCSUC
                   AND F.REGCOD <= 100
                   AND ROWNUM = 1;
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;
              END;
              -----------------------------------
              --determinar jefe
              vgerentec := '';
              flag_enc  := 'N';
              PQ_CR_CREDITOS_CAP_HS.sp_obtener_jefe_cargo(vi_cargo,
                                                          vanalista,
                                                          vgerentec);
            
              if vgerentec is null or vgerentec <> trim(vgerentec) then
                --11/08/2021
                pq_cr_reprog_sin_cap.SP_CRD_OBTENER_APROBADOR(vi_Cargo,
                                                              P_N_SCSUC,
                                                              VI_APROBADOR,
                                                              VI_APROBADOR_SUP);
              end if;
              IF vi_cargo = 202 THEN
                flag_enc := 'S';
              END IF;
              IF vi_cargo = 220 THEN
                IF TRIM(vi_perfilc) = 'JZON01' THEN
                  BEGIN
                    select sng057usr
                      INTO vgerentec
                      from fst811 f, sng057 s, fst046 t
                     where f.regcod = VI_REGCOD
                       and s.sng055car = 220
                       and t.ubuser = s.sng057usr
                       --and s.sng057aut = 'S'
                       and f.oficod = t.ubsuc
                       AND ROWNUM = 1;
                    vi_aprobador := vgerentec;
                  EXCEPTION
                    WHEN OTHERS THEN
                      NULL;
                  END;
                END IF;
                IF TRIM(vi_perfilc) = 'GREG01' THEN
                  BEGIN
                    SELECT F.REGCOD
                      INTO VI_REGCOD
                      FROM REGSUC F
                     WHERE F.SUCURS = P_N_SCSUC;
                  
                    SELECT F.UBUSER
                      INTO vgerentec
                      FROM REGSUC R, FST046 F, PRFU00 P, SNG057 S
                     WHERE R.REGCOD = VI_REGCOD
                       AND R.SUCURS = F.UBSUC
                       AND F.UBUSER = P.UBUSER
                       AND P.PRFGCOD = 'GREG01'
                       AND S.SNG055EMP = F.PGCOD
                       AND S.SNG057USR = P.UBUSER
                       AND S.SNG055CAR = 220
                       AND ROWNUM = 1;
                       --AND S.SNG057AUT = 'S';
                    vi_aprobador := vgerentec;
                  EXCEPTION
                    WHEN OTHERS THEN
                      NULL;
                  END;
                END IF;
              END IF;
            
              if vi_cargo >= 230 then
                pq_cr_reprog_sin_cap.SP_CRD_OBTENER_APROBADOR(vi_Cargo,
                                                              P_N_SCSUC,
                                                              VI_APROBADOR,
                                                              VI_APROBADOR_SUP);
                vgerentec := vi_aprobador;
              end if;
              vgerente := vgerentec;
            EXCEPTION
              WHEN OTHERS THEN
                NULL;
            END;
          else
              if vi_aqpb556tprg = 4 then
                  ---PROCESO PARA OBTENER EL PERFIL DE LA REPROGRAMACION FONDOS
                  BEGIN
                    SELECT F.PERFIL
                      into VI_PERFIL
                      FROM FONDOS G, FONDOS_CREDITOSFACILIDAD F
                     WHERE F.IDFONDO = G.IDFONDO
                       AND G.ESTADOSOLICITUD = 'BT'
                       AND SUBSTR(F.CUENTAOPERACION,
                                  0,
                                  INSTR(F.CUENTAOPERACION, '-') - 1) =
                           P_N_SCCTA
                       AND SUBSTR(F.CUENTAOPERACION,
                                  INSTR(F.CUENTAOPERACION, '-') + 1,
                                  99) = P_N_SCOPER
                       AND F.EMPRESA = P_N_PGCOD
                       AND F.SUCURSAL = P_N_SCSUC
                       AND F.MODULO = P_N_SCMOD
                       AND F.MONEDA = P_N_SCMDA
                       AND F.PAPEL = P_N_SCPAP
                       AND F.SUBOPERACION = P_N_SCSBOP
                       AND F.TIPOOPERACION = P_N_SCTOPE;
                  EXCEPTION
                    WHEN OTHERS THEN
                      NULL;
                  END;
                  --Evaluar en Guia de Proceso Especial, de acuerdo al Perfil encontrado quien debe ser el aprobador.
                  --ve_rpta := 'N';
                  BEGIN
                    SELECT tp1nro1
                      INTO vi_cargo
                      FROM FST198 F
                     WHERE TP1COD1 = 10899
                       AND TP1CORR1 = 400000
                       AND TP1CORR2 = 5
                       AND TP1CORR2 > 0
                       AND tp1imp1 = VI_PERFIL;
                    --AND tp1nro1  in (ve_cargo,ve_cargo2);  
                  EXCEPTION
                    WHEN OTHERS THEN
                      NULL; --ve_rpta:= 'N';         
                  END;
                  BEGIN
                    SELECT F.REGCOD
                      INTO VI_REGCOD
                      FROM FST811 F
                     WHERE F.OFICOD = P_N_SCSUC
                       AND F.REGCOD <= 100;
                  EXCEPTION
                    WHEN OTHERS THEN
                      NULL;
                  END;
                  BEGIN
                    select sng057usr
                      INTO vgerentec
                      from fst811 f, sng057 s, fst046 t
                     where f.regcod = VI_REGCOD
                       and s.sng055car = 220
                       and t.ubuser = s.sng057usr
                       and s.sng057aut = 'S'
                       and f.oficod = t.ubsuc;
                  
                    vi_aprobador := vgerentec;
                  EXCEPTION
                    WHEN OTHERS THEN
                      NULL;
                  END;
                  if vi_cargo >= 230 then
                    pq_cr_reprog_sin_cap.SP_CRD_OBTENER_APROBADOR(vi_Cargo,
                                                                  P_N_SCSUC,
                                                                  VI_APROBADOR,
                                                                  VI_APROBADOR_SUP);
                  
                  end if;
              end if;  
              --ARBOL DE APROBACION CASO DIFERENTE A REPROG CAJA CUALQUIER REPROGRAMACION COVID
              IF vi_aqpb556tprg <= 5 THEN  
                  PQ_CR_CREDITOS_CAP_HS.sp_tipo_cambio_fijo(vi_pFechaN,
                                                            vi_TIPOCAMBIO);
                  PQ_CR_RESOLUTOR_AUTONOMIA.sp_cuentas(vi_aqpb556pais,
                                                       vi_AQPB556PTDC,
                                                       vi_AQPB556DNI,
                                                       vi_TIPOCAMBIO,
                                                       vi_AQPB556INST,
                                                       vi_pFechaN,
                                                       vi_AQPB556CONS);
                  -----------------------------------
                  --VALIDANDO CUAL ES EL CARGO QUE DEBE APROBAR EL CREDITO.
                  BEGIN
                    SELECT F.TP1NRO1
                      INTO vi_cargo
                      FROM FST198 F
                     WHERE F.TP1COD = 1
                       AND F.TP1COD1 = 10899
                       AND F.TP1CORR1 = 400000
                       AND F.TP1CORR2 = 1
                       AND F.TP1IMP1 <= vi_AQPB556CONS
                       AND F.TP1IMP2 >= vi_AQPB556CONS;
                  EXCEPTION
                    WHEN OTHERS THEN
                      vi_cargo := 202;
                  END;
                  -----------------------------------
                  --determinar jefe
                  vgerentec := '';
                  flag_enc  := 'N';
                
                  PQ_CR_CREDITOS_CAP_HS.sp_obtener_jefe_cargo(vi_cargo,
                                                              vanalista,
                                                              vgerentec);
                
                  if vgerentec is null or vgerentec <> trim(vgerentec) then
                    --11/08/2021
                    pq_cr_reprog_sin_cap.SP_CRD_OBTENER_APROBADOR(vo_Cargo,
                                                                  P_N_SCSUC,
                                                                  VI_APROBADOR,
                                                                  VI_APROBADOR_SUP);
                  end if;
                
                  if vgerentec <> '' and vgerentec is not null then
                    vgerente := vgerentec;
                    flag_enc := 'S';
                  end if;
                  vi_aprobador := vgerentec;
                  if vi_cargo >= 230 then
                    pq_cr_reprog_sin_cap.SP_CRD_OBTENER_APROBADOR(vo_Cargo,
                                                                  P_N_SCSUC,
                                                                  VI_APROBADOR,
                                                                  VI_APROBADOR_SUP);
                  end if;
              END IF;
              --REPROGRAMACION MEMO 2024 HACIA ADELANTE. CON CRM
              IF vi_aqpb556tprg > 5 AND vi_aqpb556tprg < 10 THEN
                BEGIN
                  --VALIDANDO CUAL ES EL CARGO QUE DEBE APROBAR EL CREDITO MEMO 2024.
                  BEGIN
                    SELECT F.TP1NRO1, TP1DESC
                      INTO vi_cargo, vi_perfilc
                      FROM FST198 F
                     WHERE F.TP1COD = 1
                       AND F.TP1COD1 = 10899
                       AND F.TP1CORR1 = 400000
                       AND F.TP1CORR2 = 65
                       AND F.TP1IMP1 <= abs(vcapital)
                       AND F.TP1IMP2 >= abs(vcapital);
                  EXCEPTION
                    WHEN OTHERS THEN
                      vi_cargo := 202;
                  END;
                  --OBTENER CODIGO DE REGION
                  BEGIN
                    SELECT F.REGCOD
                      INTO VI_REGCOD
                      FROM FST811 F
                     WHERE F.OFICOD = P_N_SCSUC
                       AND F.REGCOD <= 100
                       AND ROWNUM = 1;
                  EXCEPTION
                    WHEN OTHERS THEN
                      NULL;
                  END;
                  -----------------------------------
                  --determinar jefe
                  vgerentec := '';
                  flag_enc  := 'N';
                
                  PQ_CR_CREDITOS_CAP_HS.sp_obtener_jefe_cargo(vi_cargo,
                                                              vanalista,
                                                              vgerentec);
                
                  if vgerentec is null or vgerentec <> trim(vgerentec) then
                    --11/08/2021
                    pq_cr_reprog_sin_cap.SP_CRD_OBTENER_APROBADOR(vi_Cargo,
                                                                  P_N_SCSUC,
                                                                  VI_APROBADOR,
                                                                  VI_APROBADOR_SUP);
                  end if;
                  IF vi_cargo = 202 THEN
                    flag_enc := 'S';
                  END IF;
                  IF vi_cargo = 220 THEN
                    IF TRIM(vi_perfilc) = 'JZON01' THEN
                      BEGIN
                        select sng057usr
                          INTO vgerentec
                          from fst811 f, sng057 s, fst046 t
                         where f.regcod = VI_REGCOD
                           and s.sng055car = 220
                           and t.ubuser = s.sng057usr
                           and s.sng057aut = 'S'
                           and f.oficod = t.ubsuc
                           AND ROWNUM = 1;
                        vi_aprobador := vgerentec;
                      EXCEPTION
                        WHEN OTHERS THEN
                          NULL;
                      END;
                    END IF;
                    IF TRIM(vi_perfilc) = 'GREG01' THEN
                      BEGIN
                        SELECT F.REGCOD
                          INTO VI_REGCOD
                          FROM REGSUC F
                         WHERE F.SUCURS = P_N_SCSUC;
                      
                        SELECT F.UBUSER
                          INTO vgerentec
                          FROM REGSUC R, FST046 F, PRFU00 P, SNG057 S
                         WHERE R.REGCOD = VI_REGCOD
                           AND R.SUCURS = F.UBSUC
                           AND F.UBUSER = P.UBUSER
                           AND P.PRFGCOD = 'GREG01'
                           AND S.SNG055EMP = F.PGCOD
                           AND S.SNG057USR = P.UBUSER
                           AND S.SNG055CAR = 220
                           AND S.SNG057AUT = 'S';
                        vi_aprobador := vgerentec;
                      EXCEPTION
                        WHEN OTHERS THEN
                          NULL;
                      END;
                    END IF;
                  END IF;
                
                  if vi_cargo >= 230 then
                    pq_cr_reprog_sin_cap.SP_CRD_OBTENER_APROBADOR(vi_Cargo,
                                                                  P_N_SCSUC,
                                                                  VI_APROBADOR,
                                                                  VI_APROBADOR_SUP);
                    vgerentec := vi_aprobador;
                  end if;
                  vgerente := vgerentec;
                END;
              end if;
              --REPROGRAMACION MEMO 2024 HACIA ADELANTE. SIN CRM - 
              IF vi_aqpb556tprg = 10 THEN
                 vi_contador := 0;                             
                 for x in lista_Aprobadores_sinCRM(vi_aqpb556cod,vi_AQPB556INST,vi_fecharpg) loop
                     --OBTENER DESCRIPCION CARGO
                     BEGIN
                        SELECT s.sng055dsc
                          INTO vi_dcargo
                          FROM SNG055 s
                         WHERE s.SNG055CAR = x.AQPD157CODCAR;
                     EXCEPTION
                        WHEN OTHERS THEN
                          vi_dcargo := 'Gerente';
                     END;
                     --OBTENER CORREO DEL APROBADOR
                     BEGIN
                        select wfusremail
                          into lv_correog
                          from WFUSERS
                         where wfusrcod = X.AQPD157UAPRO;
                     EXCEPTION
                        WHEN OTHERS THEN
                          p_c_coderr := '05';
                          p_c_msgerr := 'No se encontró correo de ';
                     END;
                     if x.AQPD157NIAP = 1 AND x.AQPD157NIDP = 0 then
                          vi_cargo_papr := vi_dcargo; 
                          vi_usr_papr   := X.AQPD157UAPRO;
                          vi_email_papr := lv_correog;
                          vi_cargo      := x.AQPD157CODCAR;
                     end if;
                       
                     if vi_contador = 0 then
                        lv_destinos := lv_correog;
                        vi_usuarios_aprobador := X.AQPD157UAPRO;
                        vi_cargos_aprobador := vi_dcargo;
                     else
                        if lv_correog is not null then
                          lv_destinos := TRIM(lv_destinos)||';'||lv_correog;
                          vi_usuarios_aprobador := TRIM(vi_usuarios_aprobador)||';'||X.AQPD157UAPRO;
                          vi_cargos_aprobador := TRIM(vi_cargos_aprobador)||';'||vi_dcargo;
                        end if;
                     end if;
                     vi_contador:=vi_contador+1;
                 end loop;                   
              END IF;
            -- condicion para reprogramacion Fondos 
          end if; --fin de condicional reprogramacion caja 3        
        else -- FIN DE LA CONDICION DIFERENTE A UNILATERAL, EL ELSE ES PARA LOS UNILATERALES.
        
          vi_cargo := 202;
          PQ_CR_CREDITOS_CAP_HS.sp_obtener_jefe_cargo(vi_cargo,
                                                      vanalista,
                                                      vgerentec);
          if vgerentec <> '' and vgerentec is not null then
            vgerente := vgerentec;
            flag_enc := 'S';
          end if;
          vi_aprobador    := vgerentec;
          v_mensaje_covid := 'Tipo Reprogramación: Reprogramación Covid Unilateral';
        end if; -- comentado hastahabilitar tipo de reprogrmacion 3
        
        --EXTRAYENDO DESCRIPCION DEL CARGO.
        BEGIN
          SELECT s.sng055dsc
            INTO vi_dcargo
            FROM SNG055 s
           WHERE s.SNG055CAR = vi_cargo;
        EXCEPTION
          WHEN OTHERS THEN
            vi_dcargo := 'Gerente';
        END;
        if flag_enc = 'N' and vi_cargo > 202 then
          v_mensaje_a := 'Requiere se Aprobado por ' || trim(vi_dcargo);
        else
          v_mensaje_a := '';
        end if;
        if flag_enc = 'N' then
          vi_dcargo := 'Gerente';
        end if;
      
        --ANALIZANDO EL CORREO DEL USUARIO AL QUE SE ENVIARA EL CORREO DE APROBACION DEL MONTO.
        begin
          select wfusremail
            into lv_correog
            from WFUSERS
           where wfusrcod = vgerente;
        exception
          when others then
            p_c_coderr := '05';
            p_c_msgerr := 'No se encontró correo de ';
        end;
        BEGIN
             pq_cr_reprog_sin_cap.SP_VALIDAR_TIPO_REPROGD( vi_aqpb556cod,
                                                           vi_AQPB556INST,
                                                           VOI_N_COD_TRPG,
                                                           VOI_V_DSC_TRPG
                                                          );
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        if vi_aqpb556tprg < 10 then
          ----------------------------------------------  
          lv_destinos   := lv_correog;
          lv_destinos_c := lv_correoa;
          lv_mensaje    := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(s) ' ||
                           vi_dcargo || ',</p>' ||
                           '<p "font-family: Arial, sans-serif; font-size: 14px;">Tiene pendiente de aprobación la reprogramación de ' ||
                           lv_cuentat || '<br />' || trim(v_mensaje_a) ||
                           '<br />' || trim(v_mensaje_covid) || '.</p>';
          --GRABANDO APROBADOR PROPUESTO EN LA TABLA DE APROBACION
          vi_mensaje := 'Tiene pendiente la Aprobacion de ' ||
                        trim(lv_cuentat) || '-' || trim(v_mensaje_a) || '-' ||
                        trim(v_mensaje_covid) || '; correo enviado a ' ||
                        trim(vi_perfilc) || ':' || trim(vanalista) || '-' ||
                        trim(lv_correoa) || '-' || trim(vgerente) || '-' ||
                        trim(lv_correog);         
                   
        else
          
          lv_mensaje    := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(s) ' ||
                           trim(vi_cargo_papr) || ',</p>' ||
                           '<p "font-family: Arial, sans-serif; font-size: 14px;">Tiene pendiente de aprobación la reprogramación por '||VOI_V_DSC_TRPG||' sin CRM de ' ||
                           trim(lv_cuentat) || '<br />' || trim(v_mensaje_a) ||
                           '<br />' || trim(v_mensaje_covid) || '.</p>';
          lv_destinos   := vi_email_papr;      
          lv_destinos_c := lv_correoa;
          vi_correos    := 'para: '||TRIM(lv_destinos)||'***con copia:'||TRIM(lv_destinos_c);
          --Grabando log de mensaje enviado.
          vi_mensaje    := 'Tiene pendiente de aprobación la reprogramación por '||VOI_V_DSC_TRPG||' sin CRM de'||trim(lv_cuentat)||' '||trim(v_mensaje_a)||' '|| trim(v_mensaje_covid);
          vi_mensaje    := SUBSTR(trim(vi_mensaje),1,250)||'...';
          --Enviar a tabla log aqpd157 para sabe que se envio y a quien.
           pq_cr_reprog_sin_cap.SP_CRD_LOG_APROB_AQPD157(vi_aqpb556cod,
                                                         vi_AQPB556INST,
                                                         vi_fecharpg,
                                                         vi_cargo,
                                                         vi_correos,
                                                         'P', --ESTADO
                                                         vi_usr_papr,
                                                         vi_mensaje,
                                                         vo_coderror,
                                                         vo_msgerror                                                          
                                                        );
          --Cargando los datos para la tabla LOG aqpb556
          VI_MENSAJE  := trim(VI_MENSAJE)||'***aprobadores_cargos:'||vi_cargos_aprobador||'***Usuarios:'||vi_usuarios_aprobador;
          VI_MENSAJE  := SUBSTR(trim(vi_mensaje),1,400)||'...';
        end if;
        --GRABANDO EL LOG
        pq_cr_reprog_sin_cap.SP_CRD_SAVE_APROB_PRP(vi_aqpb556cod,
                                                   vi_AQPB556INST,
                                                   vi_cargo,
                                                   vi_usr_papr,
                                                   vi_mensaje);
    --FIN DE GRABACION 
      when P_V_TIPO = 'GG' then
      
        lv_destinos   := lv_correog;
        lv_destinos_c := lv_correoa;
        lv_mensaje    := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado Gerente,</p>' ||
                         '<p "font-family: Arial, sans-serif; font-size: 14px;">Tiene pendiente de aprobación la reprogramación de ' ||
                         lv_cuentat || '.</p>';
      
      when P_V_TIPO in ('A', 'R') then
        -----------------------------------------
        --apachecoh 2024.02.14
        begin
          select wfusremail
            into lv_correog
            from wfusers
           where wfusrcod = rpad(P_V_UBUSER, 30, ' ')
             and rownum = 1;
        exception
          when others then
            null;
        end;
      
        if P_V_TIPO = 'A' then
          lv_estado := 'Se ha APROBADO';
          --AGREGADO PROCESO PARA LA EVALUACION. 10.09.2021 - PROCESO DE EDWARD MARIA.
          BEGIN
            select pgfape into vi_fecha from fst017 where pgcod = 1;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
          PQ_CR_LOG_HISTORICOS.sp_cr_gen_logs(vi_fecha, vi_AQPB556INST);
        else
          lv_estado := 'Se ha RECHAZADO';
        end if;
      
        --TIPO DE REPROGRAMACION.
        /*
        IF vi_aqpb556tprg = 1 THEN --TIPO DE REPROGRAMACION COVID
          --OBTENER DIRECTORIO Y ARCHIVOS
          --LV_DIRECTORIO := 'DTPUMP_PR_EMAIL_DIG';
          --LV_ARCHIVO    := 'PPR42903523_001894788000008421582.pdf';
        END IF;
        IF vi_aqpb556tprg = 2 THEN --TIPO DE REPROGRAMACION GOBIERNO
          --OBTENER DIRECTORIO Y ARCHIVOS
          --LV_DIRECTORIO := 'DTPUMP_PR_EMAIL_DIG';
          --LV_ARCHIVO    := 'PPR42903523_001894788000008421582.pdf';
        END IF;
        */
        IF vi_aqpb556tprg = 3 THEN
          --TIPO DE REPROGRAMACION CAJA
          --OBTENER DIRECTORIO Y ARCHIVOS
          LV_DIRECTORIO := 'DTPUMP_PR_EMAIL_DIG';
          --LV_ARCHIVO    := 'PPR42903523_001894788000008421582.pdf';
        END IF;
        /*
        IF vi_aqpb556tprg = 4 THEN --TIPO DE REPROGRAMACION FONDOS
          --OBTENER DIRECTORIO Y ARCHIVOS
          --LV_DIRECTORIO := 'DTPUMP_PR_EMAIL_DIG';
          --LV_ARCHIVO    := 'PPR42903523_001894788000008421582.pdf';
        END IF;
        */
        lv_destinos   := lv_correoa;
        lv_destinos_c := lv_correog;
        lv_mensaje    := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado analista,</p>' ||
                         '<p "font-family: Arial, sans-serif; font-size: 14px;">' ||
                         lv_estado || ' la reprogramación de ' ||
                         lv_cuentat || '.</p>';
      
        --LOG DE ENVIO DE MENSAJE
        VI_MENSAJEA := 'Estimado analista ' || lv_estado ||
                       ' la reprogramación de ' || lv_cuentat ||
                       ';correo enviado a:' || lv_correoa;

begin
        pq_cr_reprog_sin_cap.SP_CRD_SAVE_APROB_AUT(vi_aqpb556cod,
                                                   vi_AQPB556INST,
                                                   VI_MENSAJEA);
                                                    exception
          when others then
            null;
        end;
      
      when P_V_TIPO in ('T', 'M') then
        -----------------------------------------
        begin
          select wfusremail
            into lv_correog
            from WFUSERS
           where wfusrcod = vubuser;
        exception
          when others then
            p_c_coderr := '05';
            p_c_msgerr := 'No se encontró correo de plataforma';
        end;
      
        lv_estado := 'Se ha Cambiado de Unilateral a Consensuada';
      
        lv_destinos   := lv_correoa;
        lv_destinos_c := lv_correog;
        lv_mensaje    := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado analista,</p>' ||
                         '<p "font-family: Arial, sans-serif; font-size: 14px;">' ||
                         lv_estado || ' la reprogramación de ' ||
                         lv_cuentat || '.</p>';
      
    end case;
  
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    --GUARDAR LOG DEL MENSAJE ENVIADO
    --LOG DE ENVIO DE MENSAJE
    --vi_mensaje:= 'Estimado analista ' ||lv_estado||' la reprogramación de '||lv_cuentat||'; correo enviado a:'||lv_correoa ;    
    --pq_cr_reprog_sin_cap.SP_CRD_SAVE_CAMBIO_PRP(vi_aqpb556cod,vi_AQPB556INST,lv_mensaje);
  
    lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Atentamente<br/>Caja Arequipa</strong></p>';
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
  
    begin
      -- Call the procedure 
      -- if LV_DIRECTORIO is null then 
      --     LV_DIRECTORIO := '';            
      -- end if;
	  
      pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                       p_destinatarioscc   => lv_destinos_c,
                                       p_destinatariosbcc  => '',
                                       p_mensaje           => ll_mensaje, --ll_mensaje
                                       p_remitente         => lv_remitente,
                                       p_asunto            => lv_asunto,
                                       p_tipomensaje       => 'HTML',
                                       p_directorio        => lv_directorio,
                                       p_archivosadjuntos  => lv_archivo,
                                       p_c_coderr          => p_c_coderr,
                                       p_c_deserr          => p_c_msgerr);


    exception
      when others then
        p_c_coderr := '99';
        p_c_msgerr := sqlerrm;
    end;
  
    dbms_lob.freetemporary(ll_mensaje);
  end if;

  p_n_coderr := to_number(p_c_coderr);

end SP_CR_CORREO_APROBACION;
/

