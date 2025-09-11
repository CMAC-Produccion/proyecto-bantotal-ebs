CREATE OR REPLACE TRIGGER BANTPROD.TG_WFWRKITEMS_INS
  after insert on WFWRKITEMS
  for each row

-- *******************************************************************************************************
-- Nombre                     : TG_WFWRKITEMS_INS
-- Sistema                    : BANTOTAL
-- Módulo                     : Créditos
-- Versión                    : 1.0
-- Fecha de Creación          : 2015.08.10
-- Autor de Creación          : Jeankharlo Pinto Espejo - CAJA AREQUIPA
-- Uso                        : Envío de alertas via correo electrónco a usuarios con creditos pendientes
--                              de aprobacion desde Administradores en adelante.
-- Estado                     : Activo
-- Acceso                     : Público
-- Fecha de Modificación      : 2015.09.01
-- Autor de Modificación      : Jeankharlo Pinto Espejo - CAJA AREQUIPA
-- Descripción de Modificación: Se adicionó el analista al que pertenece el crédito al mensaje enviado por correo
--								por requerimiento del Gerente Regional Arequipa y aprobacion de Eduardo Zanabria.
-- Fecha de Modificación      : 04/09/2025
-- Autor de Modificación      : Sergio Gamero
-- Descripción de Modificación: Se eliminan trims que invalidan el uso del indice
-- ********************************************************************************************************

DECLARE

  cursor c1(pn_numins in number) is
      select n_codpai,
        n_tipdoc,
        c_numdoc,
        n_codmod,
        n_codtop,
        c_desmod,
        c_destop,
        n_codmda,
        n_mtoapr,
        n_placre,
        n_ctacli
   from (select /*+ choose */
          a.sng001pais n_codpai,
          a.sng001tdoc n_tipdoc,
          trim(a.sng001ndoc) || trim(to_char(c.xwfmodulo)) c_numdoc, -- COMENTADO EL 30/09/2014
          c.xwfmodulo n_codmod,
          c.xwftipope n_codtop,
          trim(d.mdnom) c_desmod,
          trim(e.tonom) c_destop,
          c.xwfmoneda n_codmda,
          c.xwfmonto1 n_mtoapr,
          floor(c.xwfplazo1 / 30.0) n_placre,
          c.xwfcuenta n_ctacli
           from sng001 a, xwf700 c, fst003 d, fst004 e
          where a.sng001inst = c.xwfprcins
            and a.sng001inst = pn_numins
            and d.modulo = c.xwfmodulo
            and d.modulo = e.modulo
            and e.totope = c.xwftipope);

ln_numins number := 0;
ln_carapr number := 0;
lv_usrapr varchar2(50) := null;
lv_emailu varchar2(50) := null;
lv_numdoc varchar2(50) := null;
lv_nomcli varchar2(50) := null;
lv_mtoapr varchar2(50) := null;
lv_placre varchar2(50) := null;
lv_codmda varchar2(50) := null;
lv_produc varchar2(50) := null;
lv_modulo varchar2(50) := null;
lv_mensaj varchar2(1000) := null;
lv_motivo varchar2(1000) := null;
lv_remite varchar2(1000) := null;
lv_usrins varchar2(10) := null;
ln_usrsuc number := 0;
ln_cntreg number := 0;
ld_fecins date;
lv_horins varchar2(10) := null;
lv_nomana varchar2(100) := null;
BEGIN
  --//
  begin
    select count(1)
      into ln_cntreg
      from JAQL015
     where instancia = :new.wfinsprcid;
  exception
    when others then
      ln_cntreg := 0;
  end;
  --//
  if :new.wftaskcod = '11' and ln_cntreg  = 0 then
    --//
    ld_fecins := trunc(sysdate);
    lv_horins := to_char(sysdate,'HH24:MI:ss');
    lv_remite := 'workflow@cajaarequipa.pe';
    lv_usrins := '';
    ln_carapr := 0;
    lv_usrapr := trim(:new.wfitemusrcod);
    --//
    ln_numins := :new.wfinsprcid;

    --//
	begin
    select sng001ase
      into lv_usrins
      from sng001
     where sng001.sng001inst = ln_numins;
	exception
      when others then
        lv_usrins := '';
    end;

    --//
	begin
    select ubsuc
      into ln_usrsuc
      from fst046
     where ubuser = rpad(upper(lv_usrins), 10);
	exception
      when others then
        ln_usrsuc := 0;
    end;

    --//
	begin
    select sng055car
      into ln_carapr
      from sng057
     where sng057usr = rpad(upper(lv_usrins), 10);
	exception
      when others then
        ln_carapr := 0;
    end;

    --//
	begin
    select trim(sng001ndoc)
      into lv_numdoc
      from sng001
     where sng001inst = :new.wfinsprcid;
	exception
      when others then
        lv_numdoc := '';
    end;

	--//
    begin
     select ubnom
       into lv_nomana
       from fst746
      where ubuser = lv_usrins;
    exception
      when others then
        lv_nomana := lv_usrins;
    end;

--    if ln_usrsuc in (1,2,3,4,5,6,7,11,12,23,24,30,38,42,55,56,59,62,67,69,71,75,79,80,902, 903, 904) then
      --//
      if ln_carapr in (201, 202, 210, 214, 216, 220, 230, 240, 245) then
        --//
        for i in c1(ln_numins)
        loop
            --
            lv_emailu := :new.wfitemusrcod;
            lv_mtoapr := to_char(i.n_mtoapr, '9999,999,999.99');
            lv_produc := i.c_destop;
            lv_modulo := i.c_desmod;
            lv_placre := to_char(i.n_placre);
            if i.n_codmda = 0 then
               lv_codmda := 'S/.';
            else
               lv_codmda := 'USD';
            end if;
            --
            exit;
        end loop;
        --//
        lv_emailu := trim(lower(lv_emailu))||'@cajaarequipa.pe';
        --//
        select trim(pfape1) || ' ' || trim(pfape2) || ', ' || trim(pfnom1) || ' ' ||
               trim(pfnom2)
          into lv_nomcli
          from fsd002
         where pfndoc = rpad(trim(substr(lv_numdoc, 1, 8)),12,' ');
        --//
        lv_motivo := 'Recordatorio de Aprobacion de Crédito';
        --//
        lv_mensaj := 'Estimada(o), tiene pendiente aprobar el crédito [ '||to_char(ln_numins)||' ]';
        lv_mensaj := lv_mensaj ||', del cliente: ' ||lv_nomcli;
        lv_mensaj := lv_mensaj ||' por monto '||lv_codmda||' '|| trim(lv_mtoapr);
        lv_mensaj := lv_mensaj ||' y plazo '||lv_placre||' mes(es)';
        lv_mensaj := lv_mensaj ||' por: '|| lv_modulo||' - '||trim(lv_produc);
		lv_mensaj := lv_mensaj ||' por el analista : '|| lv_nomana;
        lv_mensaj := lv_mensaj || chr(13)||chr(13)||chr(13)||chr(13);
        lv_mensaj := lv_mensaj ||'Saludos Cordiales';
        lv_mensaj := lv_mensaj || chr(13)||chr(13);
        lv_mensaj := lv_mensaj ||'WORKFLOW DE CREDITOS.';
        --//
		if lv_emailu <> 'wdongo@cajaarequipa.pe' then
		  sys.SP_SY_ENVIAMAIL(PC_DE => lv_remite, PC_AQUIEN => lv_emailu, PC_MOTIVO => lv_motivo, PC_MENSAJE => lv_mensaj);
		end if;
        --//
        insert into JAQL015(instancia, ingreso, mensaje, fecha, hora, cargo) values(ln_numins, lv_emailu, lv_mensaj, ld_fecins,  lv_horins, lv_usrapr);
        --// fin del condicional que valida el cargo de la persona a enviar la alerta.
      end if;
    --// fin del condicional que valida si es de las agencias piloto
--    end if;
  end if;
  --//
exception
  when others then
    lv_mensaj := sqlerrm;
    insert into JAQL015(instancia, ingreso, mensaje, fecha, hora,  cargo) values(ln_numins, '99 ERROR', lv_mensaj, ld_fecins,  lv_horins, lv_usrapr);

END TG_WFWRKITEMS_INS;
/
