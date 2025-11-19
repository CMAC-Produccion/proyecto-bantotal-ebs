create or replace package PQ_CR_CHECK_LIST is

  -- *****************************************************************
  -- Nombre                     : PQ_CR_CHECK_LIST 
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 27/10/2025 17:54:30
  -- Autor de Creación          : ENINAH
  -- Descripcion                : PAQUETE PARA LA LÓGICA DEL PANEL DE CHECK LIST DOCUMENTARIO
  -- Uso                        : 
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :

  procedure sp_cr_determinar_credito(instancia in number,
                                     indicador out varchar2);
  procedure sp_cr_guardar_check_list_documentario(instancia     in number,
                                                  id_documento  in number,
                                                  chk_info      in varchar2,
                                                  chk_politicas in varchar2,
                                                  usuario       in varchar2,
                                                  indicador     in varchar2,
                                                  resultado     out varchar2);
  procedure sp_cr_credito_desembolsado_cancelado(instancia in number,
                                                 bloquear  out varchar2);
  procedure sp_cr_validar_checklist(instancia in number,
                                    resultado out varchar2);

end PQ_CR_CHECK_LIST;
/
create or replace package body PQ_CR_CHECK_LIST is

  procedure sp_cr_determinar_credito(instancia in number,
                                     indicador out varchar2) is
    V_MODO      number(4);
    V_MODULO    NUMBER(3);
    V_TIPOPE    NUMBER(3);
    V_COUNT     NUMBER := 0;
    P_RESULTADO varchar2(1);
  begin
    begin
      select s.sng021tmod
        into V_MODO
        from sng021 s
       where s.sng021sol = instancia;
    exception
      when others then
        V_MODO := 0;
    end;
  
    begin
      select x.xwfmodulo, x.xwftipope
        into V_MODULO, V_TIPOPE
        from xwf700 x
       where x.xwfprcins = instancia
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    begin
      -- Verificar si existe en FST004
      SELECT COUNT(*)
        INTO V_COUNT
        FROM FST004 F
       WHERE F.MODULO = V_MODULO
         AND UPPER(F.TONOM) LIKE '%MICROC%';
    exception
      when others then
        null;
    end;
    -- Asignar resultado
    IF V_COUNT > 0 THEN
      P_RESULTADO := 'S';
    ELSE
      P_RESULTADO := 'N';
    END IF;
  
    if V_MODO = 14 or P_RESULTADO = 'S' then
      -- Dependiente
      indicador := 'C';
      -- Independiente
    else
      if V_MODULO = 103 then
        indicador := 'I';
      else
        indicador := 'P';
      end if;
    end if;
  end sp_cr_determinar_credito;

  procedure sp_cr_guardar_check_list_documentario(instancia     in number,
                                                  id_documento  in number,
                                                  chk_info      in varchar2,
                                                  chk_politicas in varchar2,
                                                  usuario       in varchar2,
                                                  indicador     in varchar2,
                                                  resultado     out varchar2) is
    fecha_registro date;
    hora_registro  varchar2(8);
    v_existe       number;
  begin
  
    begin
      fecha_registro := TRUNC(sysdate);
      hora_registro  := to_char(sysdate, 'HH24:MI:SS');
    end;
    -- Verificar si existe
    select count(*)
      into v_existe
      from aqpd726
     where AQPD726INS = instancia
       and aqpd726idm = id_documento
       and AQPD726TCR = indicador;
  
    if v_existe > 0 then
      -- Actualizar si existe
      update aqpd726
         set aqpd726chki = chk_info,
             aqpd726chkp = chk_politicas,
             aqpd726usua = usuario,
             aqpd726fcha = fecha_registro,
             aqpd726hra  = hora_registro
       where AQPD726INS = instancia
         and aqpd726idm = id_documento
         and AQPD726TCR = indicador;
    else
      -- Insertar si no existe
      insert into aqpd726
        (AQPD726INS,
         aqpd726idm,
         aqpd726chki,
         aqpd726chkp,
         aqpd726usua,
         aqpd726fcha,
         aqpd726hra,
         AQPD726TCR)
      values
        (instancia,
         id_documento,
         chk_info,
         chk_politicas,
         usuario,
         fecha_registro,
         hora_registro,
         indicador);
    end if;
  
    commit;
    resultado := 'OK';
  exception
    when others then
      rollback;
      resultado := 'FAIL';
  end sp_cr_guardar_check_list_documentario;

  procedure sp_cr_credito_desembolsado_cancelado(instancia in number,
                                                 bloquear  out varchar2) is
    contador number(9);
  begin
    contador := 0;
    begin
      select count(*)
        into contador
        from wfwrkitems
       where WFINSPRCID = instancia
         and WFITEMSTSACT = 1
         and wftaskcod in (3, 7, 11);
    end;
  
    if contador = 0 then
      bloquear := 'S';
    else
      bloquear := 'N';
    end if;
  
  end sp_cr_credito_desembolsado_cancelado;

  procedure sp_cr_validar_checklist(instancia in number,
                                    resultado out varchar2) is
  begin
    begin
      select case
               when total_N > 0 then
                'S'
               else
                'N'
             end
        into resultado
        from (SELECT SUM(CASE
                           WHEN aqpd726chki = 'S' THEN
                            1
                           ELSE
                            0
                         END) + SUM(CASE
                                      WHEN aqpd726chkp = 'S' THEN
                                       1
                                      ELSE
                                       0
                                    END) AS total_S,
                     SUM(CASE
                           WHEN aqpd726chki = 'N' THEN
                            1
                           ELSE
                            0
                         END) + SUM(CASE
                                      WHEN aqpd726chkp = 'N' THEN
                                       1
                                      ELSE
                                       0
                                    END) AS total_N
                from aqpd726 b
               where b.aqpd726ins = instancia);
    exception
      when others then
        null;
    end;
  end sp_cr_validar_checklist;
end PQ_CR_CHECK_LIST;
/
