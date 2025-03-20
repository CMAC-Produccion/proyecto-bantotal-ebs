create or replace package PQ_CR_OFERTA_COMERCIAL is

  -- Author  : YLOZADA
  -- Created : 06/04/2016 11:44:26 a.m.
  -- Purpose : 

  -- Public type declarations
  TYPE rec_alerta IS RECORD(
    cod_alerta NUMBER,
    des_alerta VARCHAR2(100),
    cod_color  VARCHAR2(7),
    cod_accion VARCHAR2(1),
    valor1     VARCHAR2(150),
    valor2     VARCHAR2(150),
    valor3     VARCHAR2(150),
    valor4     VARCHAR2(150),
    valor5     VARCHAR2(150),
    valor6     VARCHAR2(150),
    valor7     VARCHAR2(150),
    valor8     VARCHAR2(150),
    valor9     VARCHAR2(150),
    valor10    VARCHAR2(150));

  TYPE tp_alerta IS TABLE OF rec_alerta INDEX BY BINARY_INTEGER;

  TYPE rec_productos IS RECORD(
    modulo  NUMBER(3),
    desmod  VARCHAR2(30),
    tipope  NUMBER(3),
    destip  VARCHAR2(30),
    FRECPAG VARCHAR2(100));

  TYPE tp_producto IS TABLE OF rec_productos INDEX BY BINARY_INTEGER;

  TYPE rec_maestro IS RECORD(
    codgru NUMBER,
    codigo VARCHAR2(30),
    descri VARCHAR2(30),
    vextra VARCHAR2(30));

  TYPE tp_maestro IS TABLE OF rec_maestro INDEX BY BINARY_INTEGER;

  type vc_array is table of varchar2(20) index by pls_integer;
  type vc_matriz is table of vc_array index by pls_integer;

  -- Public function and procedure declarations

  procedure SP_MAESTROS_OFERTA;

  Procedure sp_cr_datos_cliente(P_C_IDCONX IN VARCHAR2,
                                P_C_CODUSU IN VARCHAR2,
                                P_N_TIPDOC IN NUMBER,
                                P_C_NUMDOC IN VARCHAR2,
                                p_c_nomcli out varchar2,
                                p_c_dircli out varchar2,
                                p_c_numtel out varchar2,
                                p_n_codcon out varchar2,
                                p_c_descon out varchar2,
                                p_n_codseg out varchar2,
                                p_c_desseg out varchar2,
                                P_C_ACTIVI OUT VARCHAR2,
                                P_C_DIRACT OUT VARCHAR2,
                                P_N_CODCAL OUT VARCHAR2,
                                P_C_HABOFE OUT VARCHAR2,
                                p_c_deserr out varchar2);

  Procedure sp_cr_datos_alertas(P_C_IDCONX IN VARCHAR2,
                                P_C_CODUSU IN VARCHAR2,
                                P_N_TIPDOC IN NUMBER,
                                P_C_NUMDOC IN VARCHAR2,
                                p_c_noclca IN VARCHAR2,
                                P_C_HABOFE OUT VARCHAR2);

  procedure SP_PROPUESTA_CAB(IDCONX    IN VARCHAR2,
                             USUARIO   IN VARCHAR2,
                             TIPDOC    IN NUMBER,
                             NUMDOC    IN VARCHAR2,
                             CONDICION IN NUMBER,
                             SEGMENTO  IN NUMBER,
                             CALIFICA  IN NUMBER);

  procedure SP_PROPUESTA_DET(IDCONX   IN VARCHAR2,
                             USUARIO  IN VARCHAR2,
                             MONEDA   IN NUMBER,
                             MODULO   IN NUMBER,
                             TIPOOP   IN NUMBER,
                             SEGMENTO IN NUMBER,
                             CALIFICA IN NUMBER,
                             NIVEND   OUT NUMBER,
                             CAPPAG   OUT NUMBER);

  procedure SP_REGISTRA_OPORTUNIDAD(vjaql721idco   varchar2,
                                    vjaql721user   varchar2,
                                    vjaql721fere_v varchar2, --date,
                                    vjaql721tido   number,
                                    vjaql721nudo   varchar2,
                                    vjaql721nomb   varchar2,
                                    vjaql721segm   number,
                                    vjaql721tidi   number,
                                    vjaql721dire   varchar2,
                                    vjaql721tite   number,
                                    vjaql721telf   number,
                                    vjaql721mail   varchar2,
                                    vjaql721mone   number,
                                    vjaql721modu   number,
                                    vjaql721tope   number,
                                    vjaql721mont   number,
                                    vjaql721plaz   number,
                                    vjaql721tasa   number,
                                    vjaql721estr   number,
                                    vjaql721feco_v varchar2, --date,
                                    P_C_DESPRO     IN VARCHAR2,
                                    codmsg         OUT varchar2,
                                    mensaje        OUT varchar2);

  procedure SP_REGISTRA_SOLICITUD(P_C_IDCONX   IN VARCHAR2,
                                  P_C_CODUSU   IN VARCHAR2,
                                  P_D_FECREG_v IN varchar2, -- IN DATE,
                                  P_N_TIPDOC   IN NUMBER,
                                  P_C_NUMDOC   IN VARCHAR2,
                                  P_C_CUENTA   IN NUMBER,
                                  P_N_MONEDA   IN NUMBER,
                                  P_N_MODULO   IN NUMBER,
                                  P_N_TIPOPE   IN NUMBER,
                                  P_N_MONTO    IN NUMBER,
                                  P_N_PLAZO    IN NUMBER,
                                  P_N_FRECU    IN NUMBER,
                                  P_N_TIPSOL   IN NUMBER,
                                  P_C_CODMSG   OUT VARCHAR2,
                                  P_C_DESMSG   OUT VARCHAR2);

  function FN_NOMBRE_USER(P_C_UBUSER char) return varchar2;

  function FN_SUCUR_USER(P_C_UBUSER char) return number;

  procedure SP_CALI_RCC(P_N_TIPDOC IN NUMBER,
                        P_C_NUMDOC IN VARCHAR2,
                        P_C_DESCAL OUT VARCHAR2,
                        P_C_ACCION OUT CHAR,
                        P_C_CODSBS OUT VARCHAR2);

  procedure SP_CALI_CAJA(P_N_TIPDOC  IN NUMBER,
                         P_C_NUMDOC  IN VARCHAR2,
                         P_D_FECHA   IN DATE,
                         P_C_USUARIO IN VARCHAR2,
                         p_n_codseg  IN NUMBER,
                         P_N_CODCAl  OUT NUMBER,
                         P_C_DESCAL  OUT VARCHAR2);

  procedure SP_SALDOS(P_C_NUMDOC IN VARCHAR2,
                      p_n_nument out number,
                      p_n_totdeu out number,
                      p_n_capend out number,
                      p_n_cappag out number,
                      p_n_salhip out number,
                      p_n_salcon out number,
                      p_n_salpym out number);

  procedure SP_CREA_CUENTA(P_N_TIPDOC IN NUMBER,
                           P_C_NUMDOC IN VARCHAR2,
                           P_N_CTNRO  OUT NUMBER);

  procedure SP_CL_RETORNA_DIRECCION(P_C_CODUSU   IN VARCHAR2,
                                    P_N_TIPDOC   IN NUMBER,
                                    P_C_NUMDOC   IN VARCHAR2,
                                    P_N_DOMCOD   IN NUMBER,
                                    P_D_RESDES_v OUT varchar2, -- OUT DATE,
                                    P_C_CASNEG   OUT VARCHAR2,
                                    P_C_VIVCOD   OUT VARCHAR2,
                                    P_N_COVIA1   OUT NUMBER,
                                    P_C_DEVIA1   OUT VARCHAR2,
                                    P_N_COVIA2   OUT NUMBER,
                                    P_C_DEVIA2   OUT VARCHAR2,
                                    P_N_COVIA3   OUT NUMBER,
                                    P_C_DEVIA3   OUT VARCHAR2,
                                    P_N_COVIA4   OUT NUMBER,
                                    P_C_DEVIA4   OUT VARCHAR2,
                                    P_N_COVIA5   OUT NUMBER,
                                    P_C_DEVIA5   OUT VARCHAR2,
                                    P_N_COVIA6   OUT NUMBER,
                                    P_C_DEVIA6   OUT VARCHAR2,
                                    P_N_CODPAI   OUT NUMBER,
                                    P_N_CODPTO   OUT NUMBER,
                                    P_N_COPROV   OUT NUMBER,
                                    P_N_CODIST   OUT NUMBER,
                                    P_C_REFERE   OUT VARCHAR2,
                                    P_C_DIRCON   OUT VARCHAR2,
                                    P_C_LATDIR   OUT VARCHAR2,
                                    P_C_LONDIR   OUT VARCHAR2,
                                    BL_TELEFON   OUT SYS_REFCURSOR,
                                    P_C_CODMSG   OUT VARCHAR2,
                                    P_C_DESMSG   OUT VARCHAR2);

  procedure SP_CL_ACTUALIZA_DIRECCION(P_C_IDCONX   IN VARCHAR2,
                                      P_C_CODUSU   IN VARCHAR2,
                                      P_D_FECREG_v IN varchar2, -- IN DATE,
                                      P_N_TIPDOC   IN NUMBER,
                                      P_C_NUMDOC   IN VARCHAR2,
                                      P_C_TIPACT   IN VARCHAR2,
                                      P_N_DOMCOD   IN NUMBER,
                                      P_D_RESDES_v IN varchar2, -- IN DATE,
                                      P_C_CASNEG   IN VARCHAR2,
                                      P_C_VIVCOD   IN VARCHAR2,
                                      P_N_COVIA1   IN NUMBER,
                                      P_C_DEVIA1   IN VARCHAR2,
                                      P_N_COVIA2   IN NUMBER,
                                      P_C_DEVIA2   IN VARCHAR2,
                                      P_N_COVIA3   IN NUMBER,
                                      P_C_DEVIA3   IN VARCHAR2,
                                      P_N_COVIA4   IN NUMBER,
                                      P_C_DEVIA4   IN VARCHAR2,
                                      P_N_COVIA5   IN NUMBER,
                                      P_C_DEVIA5   IN VARCHAR2,
                                      P_N_COVIA6   IN NUMBER,
                                      P_C_DEVIA6   IN VARCHAR2,
                                      P_N_CODPAI   IN NUMBER,
                                      P_N_CODPTO   IN NUMBER,
                                      P_N_COPROV   IN NUMBER,
                                      P_N_CODIST   IN NUMBER,
                                      P_C_REFERE   IN VARCHAR2,
                                      P_C_LATORI   IN VARCHAR2,
                                      P_C_LONORI   IN VARCHAR2,
                                      P_C_LATDIR   IN VARCHAR2,
                                      P_C_LONDIR   IN VARCHAR2,
                                      P_C_CODMSG   OUT VARCHAR2,
                                      P_C_DESMSG   OUT VARCHAR2);

  procedure SP_CL_ACTUALIZA_TELEFONO(P_C_IDCONX   IN VARCHAR2,
                                     P_C_CODUSU   IN VARCHAR2,
                                     P_D_FECREG_v IN varchar2, -- IN DATE,
                                     P_N_TIPDOC   IN NUMBER,
                                     P_C_NUMDOC   IN VARCHAR2,
                                     P_C_TIPACT   IN VARCHAR2,
                                     P_N_DOMCOD   IN NUMBER,
                                     P_N_CORREL   IN NUMBER,
                                     P_N_TIPTEL   IN NUMBER,
                                     P_C_TELEFO   IN CHAR,
                                     P_C_ANEXO    IN CHAR,
                                     P_C_COMENT   IN CHAR,
                                     P_C_CODMSG   OUT VARCHAR2,
                                     P_C_DESMSG   OUT VARCHAR2);

  procedure SP_CL_RETORNA_ACTIVIDAD(P_C_CODUSU   IN VARCHAR2,
                                    P_N_TIPDOC   IN NUMBER,
                                    P_C_NUMDOC   IN VARCHAR2,
                                    P_N_TIPACT   OUT NUMBER,
                                    P_N_ACTIVI   OUT NUMBER,
                                    P_N_CODOCU   OUT NUMBER,
                                    P_C_NOMEMP   OUT VARCHAR2,
                                    P_N_INGRESO  OUT NUMBER,
                                    P_D_FEFINE   OUT VARCHAR2, --DATE,
                                    P_D_FEFINI   OUT VARCHAR2, --DATE,
                                    P_N_CODUBI   OUT NUMBER,
                                    P_N_VCOD     OUT NUMBER,
                                    P_C_RUTE     OUT VARCHAR2,
                                    P_N_SEGMENTO OUT NUMBER,
                                    P_C_CODMSG   OUT VARCHAR2,
                                    P_C_MSG      OUT VARCHAR2);

  procedure SP_CL_ACTUALIZA_ACTIVIDAD(P_C_CODUSU   IN VARCHAR2,
                                      P_N_TIPDOC   IN NUMBER,
                                      P_C_NUMDOC   IN VARCHAR2,
                                      P_N_TIPACT   IN NUMBER,
                                      P_N_ACTIVI   IN NUMBER,
                                      P_N_CODOCU   IN NUMBER,
                                      P_C_NOMEMP   IN VARCHAR2,
                                      P_N_INGRESO  IN NUMBER,
                                      P_D_FEFINE   IN VARCHAR2, --DATE,
                                      P_D_FEFINI   IN VARCHAR2, --DATE,
                                      P_N_CODUBI   IN NUMBER,
                                      P_N_VCOD     IN NUMBER,
                                      P_C_RUTE     IN VARCHAR2,
                                      P_N_SEGMENTO IN NUMBER,
                                      P_C_CODMSG   OUT VARCHAR2,
                                      P_C_MSG      OUT VARCHAR2);

  function FN_TIENE_CREDITO(P_N_TIPDOC IN NUMBER, P_C_NUMDOC IN VARCHAR2)
    return CHAR;

  procedure SP_CL_RETORNA_EMAIL(P_C_CODUSU IN VARCHAR2,
                                P_N_TIPDOC IN NUMBER,
                                P_C_NUMDOC IN VARCHAR2,
                                BL_EMAIL   OUT SYS_REFCURSOR,
                                P_C_CODMSG OUT VARCHAR2,
                                P_C_DESMSG OUT VARCHAR2);

  procedure SP_CL_ACTUALIZA_EMAIL(P_C_IDCONX   IN VARCHAR2,
                                  P_C_CODUSU   IN VARCHAR2,
                                  P_D_FECREG_v IN varchar2, -- IN DATE,
                                  P_N_TIPDOC   IN NUMBER,
                                  P_C_NUMDOC   IN VARCHAR2,
                                  P_C_TIPACT   IN VARCHAR2,
                                  P_N_CORREL   IN NUMBER,
                                  P_C_EMAIL    IN CHAR,
                                  P_C_CODMSG   OUT VARCHAR2,
                                  P_C_DESMSG   OUT VARCHAR2);

  procedure sp_obtener_cuentas(BL_DATOS   IN OUT SYS_REFCURSOR,
                               P_N_TIPDOC IN NUMBER,
                               P_C_NUMDOC IN VARCHAR2);

end PQ_CR_OFERTA_COMERCIAL;
/

create or replace package body PQ_CR_OFERTA_COMERCIAL is

  procedure SP_MAESTROS_OFERTA is
  
    cont    number;
    MAESTRO pq_cr_oferta_comercial.tp_maestro;
  begin
  
    -- tipo documento
    /*
    2  Carne Extranjeria   
    4  Carne FFAA          
    5 Pasaporte           
    6 Partida Nacimiento  
    9 R.U.C.              
    15  Tramite             
    21  DNI/LE              
    */
    cont := 1;
  
    MAESTRO(cont).codgru := 1;
    MAESTRO(cont).codigo := '2';
    MAESTRO(cont).descri := 'Carne Extranjeria';
    MAESTRO(cont).vextra := '';
  
    cont := cont + 1;
  
    MAESTRO(cont).codgru := 1;
    MAESTRO(cont).codigo := '9';
    MAESTRO(cont).descri := 'R.U.C.';
    MAESTRO(cont).vextra := '';
  
    cont := cont + 1;
  
    MAESTRO(cont).codgru := 1;
    MAESTRO(cont).codigo := '21';
    MAESTRO(cont).descri := 'DNI';
    MAESTRO(cont).vextra := '';
  
    -- segmento
    cont := cont + 1;
  
    MAESTRO(cont).codgru := 2;
    MAESTRO(cont).codigo := '1';
    MAESTRO(cont).descri := 'Independiente';
    MAESTRO(cont).vextra := '';
  
    cont := cont + 1;
  
    MAESTRO(cont).codgru := 2;
    MAESTRO(cont).codigo := '2';
    MAESTRO(cont).descri := 'Dependiente';
    MAESTRO(cont).vextra := '';
  
    -- condici?n
  
    cont := cont + 1;
  
    MAESTRO(cont).codgru := 3;
    MAESTRO(cont).codigo := '1';
    MAESTRO(cont).descri := 'Nuevo';
    MAESTRO(cont).vextra := '';
  
    cont := cont + 1;
  
    MAESTRO(cont).codgru := 3;
    MAESTRO(cont).codigo := '2';
    MAESTRO(cont).descri := 'Recurrente';
    MAESTRO(cont).vextra := '';
  
    -- moneda
    cont := cont + 1;
  
    MAESTRO(cont).codgru := 4;
    MAESTRO(cont).codigo := '0';
    MAESTRO(cont).descri := 'Soles';
    MAESTRO(cont).vextra := '';
  
    cont := cont + 1;
  
    MAESTRO(cont).codgru := 4;
    MAESTRO(cont).codigo := '101';
    MAESTRO(cont).descri := 'Dolares';
    MAESTRO(cont).vextra := '';
  
    -- tipo tel?fono  
  
    cont := cont + 1;
  
    MAESTRO(cont).codgru := 5;
    MAESTRO(cont).codigo := '1';
    MAESTRO(cont).descri := 'Celular';
    MAESTRO(cont).vextra := '';
  
    cont := cont + 1;
  
    MAESTRO(cont).codgru := 5;
    MAESTRO(cont).codigo := '2';
    MAESTRO(cont).descri := 'Fijo';
    MAESTRO(cont).vextra := '';
  
    -- tipo direcci?n
  
    cont := cont + 1;
  
    MAESTRO(cont).codgru := 6;
    MAESTRO(cont).codigo := '1';
    MAESTRO(cont).descri := 'Legal';
    MAESTRO(cont).vextra := '';
  
    cont := cont + 1;
  
    MAESTRO(cont).codgru := 6;
    MAESTRO(cont).codigo := '3';
    MAESTRO(cont).descri := 'Negocio';
    MAESTRO(cont).vextra := '';
  
    -- estrategias
  
    cont := cont + 1;
  
    MAESTRO(cont).codgru := 7;
    MAESTRO(cont).codigo := '1';
    MAESTRO(cont).descri := 'Visita Casa';
    MAESTRO(cont).vextra := '';
  
    cont := cont + 1;
  
    MAESTRO(cont).codgru := 7;
    MAESTRO(cont).codigo := '2';
    MAESTRO(cont).descri := 'Visita Negocio';
    MAESTRO(cont).vextra := '';
  
    cont := cont + 1;
  
    MAESTRO(cont).codgru := 7;
    MAESTRO(cont).codigo := '3';
    MAESTRO(cont).descri := 'Llamar contacto';
    MAESTRO(cont).vextra := '';
  
    cont := cont + 1;
  
    MAESTRO(cont).codgru := 7;
    MAESTRO(cont).codigo := '4';
    MAESTRO(cont).descri := 'Visita a agencia';
    MAESTRO(cont).vextra := '';
  
    --
    for i in maestro.FIRST .. maestro.LAST loop
      dbms_output.put_line('codgru: ' || maestro(i).codgru);
      dbms_output.put_line('codigo:' || maestro(i).codigo);
      dbms_output.put_line('descri:' || maestro(i).descri);
      dbms_output.put_line('vextra:' || maestro(i).vextra);
      dbms_output.put_line('-------------------------');
    
      insert into jaql722
      values
        (maestro(i).codgru,
         maestro(i).codigo,
         maestro(i).descri,
         maestro(i).vextra);
    end loop;
  
  end SP_MAESTROS_OFERTA;

  ---------------------------------------------------------------------

  Procedure SP_CR_DATOS_CLIENTE(P_C_IDCONX IN VARCHAR2,
                                P_C_CODUSU IN VARCHAR2,
                                P_N_TIPDOC IN NUMBER,
                                P_C_NUMDOC IN VARCHAR2,
                                p_c_nomcli out varchar2,
                                p_c_dircli out varchar2,
                                p_c_numtel out varchar2,
                                p_n_codcon out varchar2,
                                p_c_descon out varchar2,
                                p_n_codseg out varchar2,
                                p_c_desseg out varchar2,
                                P_C_ACTIVI OUT VARCHAR2,
                                P_C_DIRACT OUT VARCHAR2,
                                P_N_CODCAL OUT VARCHAR2,
                                P_C_HABOFE OUT VARCHAR2,
                                p_c_deserr out varchar2) is
    lc_petipo char(1);
    ln_pais   number(3) := 604;
    ln_tipo   number(2);
    lc_docu   char(12);
    lc_numtel char(12);
    ln_meses  number;
    ld_fecpro date;
    ld_fecrcc date;
    lc_noclca varchar2(100);
    lc_descal varchar2(60);
  
    cursor c_telefonos(pn_pais in number,
                       pn_tipo in number,
                       pc_docu in char) is
      select a.docod, b.sngc16ttel, a.dotelfp
        from fsr005 a, sngc17 b
       where a.pepais = b.sngc17pais
         and a.petdoc = b.sngc17tdoc
         and a.pendoc = b.sngc17ndoc
         and a.docod = b.sngc17dcod
         and a.doordp = b.sngc17corr
         and a.pepais = pn_pais
         and a.petdoc = pn_tipo
         and a.pendoc = pc_docu
         and a.docod = 1;
  
  begin
    p_c_deserr := '';
    ln_pais    := 604;
    ln_tipo    := P_N_TIPDOC;
    lc_docu    := P_C_NUMDOC;
    p_n_codcon := 0;
  
    --
    -- Obtenemos datos basicos
    --
  
    begin
      select a.pgfape into ld_fecpro from fst017 a where a.pgcod = 1;
    end;
  
    begin
      select to_date(trim(to_char(tpnro)), 'ddmmyyyy')
        into ld_fecrcc
        from fst098
       where pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    end;
  
    begin
      select a.petipo
        into lc_petipo
        from fsd001 a
       where a.pepais = ln_pais
         and a.petdoc = ln_tipo
         and a.pendoc = lc_docu;
    Exception
      when others then
        lc_noclca  := 'NO ES CLIENTE DE CAJA AREQUIPA';
        p_n_codcon := 1;
        p_c_descon := 'NUEVO';
    end;
  
    if lc_petipo = 'F' then
      begin
        select trim(b.pfape1) || ' ' || trim(b.pfape2) || ', ' ||
               trim(b.pfnom1) || ' ' || trim(b.pfnom2)
          into p_c_nomcli
          from fsd002 b
         where b.pfpais = ln_pais
           and b.pftdoc = ln_tipo
           and b.pfndoc = lc_docu;
      Exception
        When others then
          p_c_nomcli := null;
      end;
    
      if p_c_nomcli is not null then
        begin
          select y.CTSEGM,
                 case
                   when y.CTSEGM = 1 then
                    'INDEPENDIENTE'
                   when y.CTSEGM = 2 then
                    'DEPENDIENTE'
                   when y.CTSEGM = 3 then
                    'OTROS'
                   else
                    NULL
                 end
            into p_n_codseg, p_c_desseg
            from fsr008 x, fsd008 y
           where x.pgcod = y.pgcod
             and x.ctnro = y.ctnro
             and x.pgcod = 1
             and x.pepais = ln_pais
             and x.petdoc = ln_tipo
             and x.pendoc = lc_docu
             and x.ttcod = 1
             and x.cttfir = 'T'
             and rownum = 1;
        Exception
          When others then
            begin
              select b.segcod,
                     case
                       when b.segcod = 1 then
                        'INDEPENDIENTE'
                       when b.segcod = 2 then
                        'DEPENDIENTE'
                       when b.segcod = 3 then
                        'OTROS'
                       else
                        NULL
                     end
                into p_n_codseg, p_c_desseg
                from sngc60 a, sngc07 b
               where a.sngc60ocup = b.sngc07cod
                 and a.sngc60pais = ln_pais
                 and a.sngc60tdoc = ln_tipo
                 and a.sngc60ndoc = lc_docu
                 and rownum = 1;
            Exception
              When others then
                p_n_codseg := 1;
                p_c_desseg := null;
            end;
        end;
      end if;
    
    Elsif lc_petipo = 'J' then
      begin
        select trim(b.pjrazs),
               nvl(b.pjsegmento, 1),
               case
                 when b.pjsegmento = 1 then
                  'INDEPENDIENTE'
                 when b.pjsegmento = 2 then
                  'DEPENDIENTE'
                 when b.pjsegmento = 3 then
                  'OTROS'
                 else
                  'INDEPENDIENTE'
               End
          into p_c_nomcli, p_n_codseg, p_c_desseg
          from fsd003 b
         where b.pjpais = ln_pais
           and b.pjtdoc = ln_tipo
           and b.pjndoc = lc_docu;
      Exception
        When others then
          p_c_nomcli := null;
          p_n_codseg := 1;
      end;
    
    else
      BEGIN
        if ln_tipo <> 9 then
          begin
            select a.c_nomdeu
              into p_c_nomcli
              from cldrcci a
             where a.d_fecpre = ld_fecrcc
               and a.c_docide = trim(lc_docu);
          exception
            when others then
              lc_noclca := 'DOCUMENTO NO EXISTE EN RCC';
              begin
                select r.JAQL1Appat || ' ' || r.JAQL1Apmat || ' ' ||
                       r.JAQL1Prnom,
                       r.JAQL1Drdom
                  into p_c_nomcli, p_c_dircli
                  from jaql001 r
                 where r.JAQL1Pendo = P_C_NUMDOC;
              exception
                when others then
                  p_c_nomcli := '';
                  p_c_dircli := '';
                  lc_noclca  := 'DOCUMENTO NO EXISTE EN RENIEC';
              end;
            
          end;
        else
          begin
            select a.c_nomdeu
              into p_c_nomcli
              from cldrcci a
             where a.d_fecpre = ld_fecrcc
               and a.c_doctri = trim(lc_docu);
          exception
            when others then
              p_c_nomcli := NULL;
              lc_noclca  := 'DOCUMENTO NO EXISTE EN RCC';
              p_n_codcon := 1;
              p_c_descon := 'NUEVO';
          end;
        end if;
      
        p_n_codseg := 1;
      EXCEPTION
        WHEN Others THEN
          null;
      END;
    End if;
  
    if p_c_dircli is null then
      begin
        select a.sngc13dir
          into p_c_dircli
          from sngc13 a
         where a.sngc13pais = ln_pais
           and a.sngc13tdoc = ln_tipo
           and a.sngc13ndoc = lc_docu
           and a.docod = 1
           and a.sngc13est = 'H';
      Exception
        When others then
          p_c_dircli := null;
      end;
    end if;
  
    for i in c_telefonos(ln_pais, ln_tipo, lc_docu) loop
      if i.sngc16ttel <> 2 then
        --si no es fijo
        p_c_numtel := substr(trim(i.dotelfp), 1, 12);
        exit;
      else
        lc_numtel := substr(trim(i.dotelfp), 1, 12);
      end if;
    end loop;
  
    If p_c_numtel is null then
      p_c_numtel := lc_numtel;
    end if;
  
    --determinamos si es nuevo o recurrente  
    begin
      pq_cr_relcrediticia.sp_relcredi_nr(pn_pai      => ln_pais,
                                         pn_tdo      => ln_tipo,
                                         pc_ndo      => lc_docu,
                                         pd_fecpro   => ld_fecpro,
                                         ln_contador => ln_meses);
    end;
  
    if ln_meses <= 5 and p_c_deserr is null then
      p_n_codcon := 1;
      p_c_descon := 'NUEVO';
    end if;
    if ln_meses > 5 and p_c_deserr is null then
      p_n_codcon := 2;
      p_c_descon := 'RECURRENTE';
    End if;
  
    begin
      select actnom1
        into P_C_ACTIVI
        from sngc60 a, fst750 b
       where a.sngc60acte = b.actcod1
         and a.sngc60pais = ln_pais
         and a.sngc60tdoc = ln_tipo
         and a.sngc60ndoc = lc_docu
         and rownum = 1;
    exception
      when no_data_found then
        P_C_ACTIVI := 'SIN ACTIVIDAD';
    end;
  
    begin
      select a.sngc13dir
        into p_c_diract
        from sngc13 a
       where a.sngc13pais = ln_pais
         and a.sngc13tdoc = ln_tipo
         and a.sngc13ndoc = lc_docu
         and a.docod = 3
         and a.sngc13est = 'H';
    Exception
      When others then
        p_c_diract := null;
    end;
  
    SP_CALI_CAJA(P_N_TIPDOC,
                 P_C_NUMDOC,
                 ld_fecpro,
                 P_C_CODUSU,
                 p_n_codseg,
                 P_N_CODCAL,
                 lc_descal);
  
    /*    SP_CR_DATOS_ALERTAS(P_C_IDCONX,
    P_C_CODUSU,
    P_N_TIPDOC,
    P_C_NUMDOC,
    lc_noclca,
    P_C_HABOFE,     
    p_t_alerta);*/
  
    pq_cr_oferta_comercial.sp_cr_datos_alertas(p_c_idconx => p_c_idconx,
                                               p_c_codusu => p_c_codusu,
                                               p_n_tipdoc => p_n_tipdoc,
                                               p_c_numdoc => p_c_numdoc,
                                               p_c_noclca => lc_noclca,
                                               p_c_habofe => p_c_habofe);
  
  Exception
    When others then
      p_c_deserr := sqlerrm;
  end sp_cr_datos_cliente;

  ---------------------------------------------------------------------

  Procedure SP_CR_DATOS_ALERTAS(P_C_IDCONX IN VARCHAR2,
                                P_C_CODUSU IN VARCHAR2,
                                P_N_TIPDOC IN NUMBER,
                                P_C_NUMDOC IN VARCHAR2,
                                p_c_noclca IN VARCHAR2,
                                P_C_HABOFE OUT VARCHAR2) is
  
    ln_pais number(3) := 604;
    ln_tipo number(2);
    lc_docu char(12);
  
    ln_paisc   number(3) := 604;
    ln_tipoc   number(2) := 0;
    lc_docuc   char(12);
    lc_nomcon  varchar2(80);
    lc_descalc varchar2(50);
    lc_accionc char(1) := null;
  
    ld_fecpro   date;
    flagexi     number := 0;
    flagvig     char(1);
    ln_cont     number := 0;
    ln_scsdo    fsd011.scsdo%type := 0;
    flagale     number := 0;
    ln_Monto    number(17, 2) := 0;
    lc_sobre    char(2);
    lc_descal   varchar2(50);
    ln_deuda    number(17, 2) := 0;
    ln_diasmora number := 0;
    lc_error    varchar2(150);
    lc_accion   char(1) := null;
    --ln_num      number;
    ln_cuota  number(17, 2) := 0;
    ln_nrocuo number(5);
    ln_cuopen number(5);
    ld_fecrcc date;
    lc_color  varchar2(6);
  
    lc_resref char(1);
    lc_resjud char(1);
    lc_resven char(1);
  
    /*    ln_codseg number;
    lc_desseg varchar2(200);*/
  
    ln_nument  number;
    ln_totdeu  number;
    ln_capend  number;
    ln_cappag  number;
    ln_salhip  number;
    ln_salcon  number;
    ln_salpym  number;
    ln_salhipc number;
    ln_salconc number;
    ln_salpymc number;
    ln_totale  number;
    ln_totald  number;
    lc_codsbs  varchar2(10);
    lc_codsbsc varchar2(10);
    flag       CHAR(1);
  
    p_t_alerta tp_alerta;
  
    cursor c_vigentes(pn_pais in number,
                      pn_tipo in number,
                      pc_docu in char) is
      select /*+ ALL_ROWS */
       b.petdoc,
       b.pendoc,
       upper(d.tonom) descre,
       e.Mosign,
       upper(e.monom) monom,
       upper(f.scnom) scnom,
       a.pgcod,
       a.scsuc,
       a.scmda,
       a.scpap,
       a.sccta,
       a.scoper,
       a.scsbop,
       a.sctope,
       a.scmod,
       abs(a.scsdo) scsdo,
       lpad(a.sccta, 9, '0') || lpad(a.scmda, 3, '0') ||
       lpad(a.scoper, 9, '0') numcre,
       g.aofvto d_fecven,
       fn_analista_credito(a.scmod,
                           a.scsuc,
                           a.scmda,
                           a.scpap,
                           a.sccta,
                           a.scoper,
                           a.scsbop,
                           a.sctope) c_codana,
       'T' titu,
       
       /*       FN_CR_Mto_Cuota(a.sccta,
       a.scoper,
       a.sctope,
       a.scsbop,
       a.scmod,
       a.scsuc,
       a.scmda)*/
       fn_cr_mto_cuotatot(a.sccta,
                          a.scoper,
                          a.sctope,
                          a.scsbop,
                          a.scmod,
                          a.scsuc,
                          a.scmda) cuota
        from fsd011 a,
             fsr008 b,
             (select *
                from fst111
              union all
              select 50, 117
                from dual
              union all
              select 50, 141
                from dual
              union all
              select 50, 65
                from dual) c,
             fst004 d,
             fst005 e,
             fst001 f,
             fsd010 g
       where a.pgcod = b.pgcod
         and a.sccta = b.ctnro
         and b.pgcod = g.pgcod
         and a.scsuc = g.aosuc
         and a.scmda = g.aomda
         and a.scpap = g.aopap
         and a.sccta = g.aocta
         and a.scoper = g.aooper
         and a.scsbop = g.aosbop
         and a.sctope = g.aotope
         and a.scmod = g.aomod
         and c.dscod = 50
         and a.scstat <> 99
         and a.scmod = d.modulo
         and a.sctope = d.totope
         and a.scmda = e.moneda
         and f.pgcod = b.pgcod
         and f.sucurs = a.scsuc
         and a.scmod = c.modulo
         and b.pepais = ln_pais
         and b.petdoc = ln_tipo
         and b.pendoc = lc_docu
         and b.ttcod = 1
         and a.scmod <> 108
      
      union all
      
      select /*+ ALL_ROWS */
       b.petdoc,
       b.pendoc,
       upper(d.tonom) descre,
       e.Mosign,
       upper(e.monom) monom,
       upper(f.scnom) scnom,
       a.pgcod,
       a.scsuc,
       a.scmda,
       a.scpap,
       a.sccta,
       a.scoper,
       a.scsbop,
       a.sctope,
       a.scmod,
       abs(a.scsdo) scsdo,
       lpad(a.sccta, 9, '0') || lpad(a.scmda, 3, '0') ||
       lpad(a.scoper, 9, '0') numcre,
       g.aofvto d_fecven,
       fn_analista_credito(a.scmod,
                           a.scsuc,
                           a.scmda,
                           a.scpap,
                           a.sccta,
                           a.scoper,
                           a.scsbop,
                           a.sctope) c_codana,
       'C' titu,
       fn_cr_mto_cuotatot(a.sccta,
                          a.scoper,
                          a.sctope,
                          a.scsbop,
                          a.scmod,
                          a.scsuc,
                          a.scmda) cuota
        from fsd011 a,
             fsr008 b,
             (select *
                from fst111
              union all
              select 50, 117
                from dual
              union all
              select 50, 141
                from dual
              union all
              select 50, 65
                from dual) c,
             fst004 d,
             fst005 e,
             fst001 f,
             fsd010 g
       where a.pgcod = b.pgcod
         and a.sccta = b.ctnro
         and b.pgcod = g.pgcod
         and a.scsuc = g.aosuc
         and a.scmda = g.aomda
         and a.scpap = g.aopap
         and a.sccta = g.aocta
         and a.scoper = g.aooper
         and a.scsbop = g.aosbop
         and a.sctope = g.aotope
         and a.scmod = g.aomod
         and c.dscod = 50
         and a.scstat <> 99
         and a.scmod = d.modulo
         and a.sctope = d.totope
         and a.scmda = e.moneda
         and f.pgcod = b.pgcod
         and f.sucurs = a.scsuc
         and a.scmod = c.modulo
         and b.pepais = ln_paisc
         and b.petdoc = ln_tipoc
         and b.pendoc = lc_docuc
         and b.ttcod = 1
         and a.scmod <> 108;
  
    cursor c_vigentes_t is
      select *
        from (select petdoc,
                     pendoc,
                     descre,
                     mosign,
                     monom,
                     scnom,
                     pgcod,
                     scsuc,
                     scmda,
                     scpap,
                     sccta,
                     scoper,
                     scsbop,
                     sctope,
                     scmod,
                     scsdo,
                     numcre,
                     d_fecven,
                     c_codana,
                     titu,
                     cuota
                from JAQL727
               where petdoc = ln_tipo
                 and pendoc = lc_docu
              union all
              select petdoc,
                     pendoc,
                     descre,
                     mosign,
                     monom,
                     scnom,
                     pgcod,
                     scsuc,
                     scmda,
                     scpap,
                     sccta,
                     scoper,
                     scsbop,
                     sctope,
                     scmod,
                     scsdo,
                     numcre,
                     d_fecven,
                     c_codana,
                     titu,
                     cuota
                from JAQL727
               where petdoc = ln_tipoc
                 and pendoc = lc_docuc)
       order by titu desc, scmod desc;
  
    cursor c_cancela(pn_pais   in number,
                     pn_tipo   in number,
                     pc_docu   in char,
                     pd_fecpro in date) is
      select /*+ ALL_ROWS */
       upper(d.tonom) descre,
       e.Mosign,
       upper(e.monom) monom,
       upper(f.scnom) scnom,
       a.pgcod,
       a.aosuc,
       a.aomda,
       a.aopap,
       a.aocta,
       a.aooper,
       a.aosbop,
       a.aotope,
       a.aomod,
       decode(a.aomda,
              101,
              round(a.aoimp * fn_tipo_cambio(ld_fecpro, a.aomda, 0, 500), 2),
              a.aoimp) monto_soles,
       a.aoimp,
       a.aofe99,
       lpad(a.aocta, 9, '0') || lpad(a.aomda, 3, '0') ||
       lpad(a.aooper, 9, '0') numcre,
       a.aofvto d_fecven,
       fn_analista_credito(a.aomod,
                           a.aosuc,
                           a.aomda,
                           a.aopap,
                           a.aocta,
                           a.aooper,
                           a.aosbop,
                           a.aotope) c_codana
        from fsd010 a, fsr008 b, fst111 c, fst004 d, fst005 e, fst001 f
       where a.pgcod = b.pgcod
         and a.aocta = b.ctnro
         and c.dscod = 50
         and a.aostat = 99
         and a.aomod = d.modulo
         and a.aotope = d.totope
         and a.aomda = e.moneda
         and f.pgcod = b.pgcod
         and f.sucurs = a.aosuc
         and (a.aomod = c.modulo or a.aomod in (117, 141, 65))
         and b.pepais = pn_pais
         and b.petdoc = pn_tipo
         and b.pendoc = pc_docu
         and a.aofe99 between pd_fecpro - 360 and pd_fecpro
         and b.ttcod = 1
         and a.aomod <> 108
       order by decode(a.aomda,
                       101,
                       round(a.aoimp *
                             fn_tipo_cambio(ld_fecpro, a.aomda, 0, 500),
                             2),
                       a.aoimp) desc;
  
    cursor c_morosos is
      select n_monto1,
             n_monto2,
             c_descri,
             n_monto3,
             c_descri1,
             c_descri2,
             c_descri3,
             c_descri4,
             c_descri5,
             c_descri6,
             c_descri7,
             c_descri8,
             c_descri9,
             c_descri10
        from crdtcap
       where n_monto2 = 30
       order by n_monto1;
  
    cursor c_blaclist(pn_pais in number,
                      pn_tipo in number,
                      pc_docu in char) is
      select b.tlisde, a.lnfact, a.lnmoobs
        from fsd201 a, fst501 b
       where a.tlis = b.tlis
         and a.lnpais = pn_pais
         and a.lntdoc = pn_tipo
         and a.lnndoc = pc_docu;
  
    cursor c_desembolso(pn_pais in number,
                        pn_tipo in number,
                        pc_docu in char) is
      select /*+ALL_ROWS*/
       upper(f.tonom) descre,
       upper(c.scnom) scnom,
       trunc(a.wfiteminit) fecsol,
       b.XWFMONTO1 monto,
       e.monom monom,
       lpad(b.XWFCUENTA, 9, '0') || lpad(b.XWFMONEDA, 3, '0') ||
       lpad(b.XWFOPERACION, 9, '0') numcre,
       fn_analista_credito(b.xwfmodulo,
                           b.xwfsucursal,
                           b.xwfmoneda,
                           b.xwfpapel,
                           b.xwfcuenta,
                           b.xwfoperacion,
                           b.xwfsubope,
                           b.xwftipope) c_codana
        from wfwrkitems a, xwf700 b, fst001 c, fsr008 d, fst005 e, fst004 f
       where a.wfinsprcid = b.xwfprcins
         and a.wftaskcod = 55
         and a.wfstscod in ('A', 'B', 'E', 'P', 'R', 'T', 'L', 'S', 'Z')
         and b.xwfcar3 = '1'
         and c.pgcod = b.xwfempresa
         and c.sucurs = b.xwfsucursal
         and e.moneda = b.xwfmoneda
         and b.xwfempresa = d.pgcod
         and b.xwfcuenta = d.ctnro
         and f.modulo = b.xwfmodulo
         and f.totope = b.xwftipope
         and d.pepais = pn_pais
         and d.petdoc = pn_tipo
         and d.pendoc = pc_docu
         and d.ttcod = 1;
    /* 
        cursor c_pasivos(pn_pais in number, pn_tipo in number, pc_docu in char) is
          select 
           scmod,
           decode(scmod, 22, 1, a.sctope) sctope, 
           trim(upper(g.tonom)) || ' ' || trim(h.monom) descri,
           count(*) total
            from fsd011 a, fsr008 b, fst004 g, fst005 h
           where a.pgcod = b.pgcod
             and a.sccta = b.ctnro
             and g.modulo = a.scmod
             and g.totope = a.sctope
             and h.moneda = a.scmda
             and a.scmod in (21, 22, 122)
             and a.scstat <> 99
             and b.pepais = pn_pais
             and b.petdoc = pn_tipo
             and b.pendoc = pc_docu
             and b.ttcod = 1
           group by scmod, decode(scmod, 22, 1, a.sctope), g.tonom, h.monom;
      
        cursor oferta_pas(pn_pais in number,
                          pn_tipo in number,
                          pc_docu in char) is
          select trim(upper(tp1desc)) produc,
                 trim(to_char(tp1imp1, '90.90')) || '%' teasol,
                 trim(to_char(tp1imp2, '90.90')) || '%' teadol
            from fst198 c
           where Tp1cod = 1
             and tp1cod1 = 10818
             and tp1corr1 = 6
             and tp1corr2 = 1
             and not exists (select 1
                    from fsd011 a, fsr008 b
                   where a.pgcod = b.pgcod
                     and a.sccta = b.ctnro
                     and a.scmod in (21, 22, 122)
                     and a.scstat <> 99
                     and b.pepais = pn_pais
                     and b.petdoc = pn_tipo
                     and b.pendoc = pc_docu
                     and b.ttcod = 1
                     and a.scmod = c.tp1nro1
                     and a.sctope = c.tp1nro2);
      
        cursor seguros is
          select count(*) total,
                 n_monto2,
                 c_descri,
                 c_descri1,
                 c_descri2,
                 c_descri3,
                 c_descri4,
                 c_descri5,
                 c_descri6,
                 c_descri7,
                 c_descri8,
                 c_descri9,
                 c_descri10
            from crdtcap
           where n_monto2 = 90
           group by n_monto2,
                    c_descri,
                    c_descri1,
                    c_descri2,
                    c_descri3,
                    c_descri4,
                    c_descri5,
                    c_descri6,
                    c_descri7,
                    c_descri8,
                    c_descri9,
                    c_descri10
          --       order by n_monto1
          ;
      
        cursor oferta_seg is
          select trim(upper(tp1desc)) produc,
                 trim(to_char(tp1imp1, '990.90')) prima
            from fst198 c
           where Tp1cod = 1
             and tp1cod1 = 10818
             and tp1corr1 = 6
             and tp1corr2 = 2
             and not exists (select 1
                    from crdtcap
                   where n_monto2 = 9
                     and n_monto3 = tp1nro1
                     and n_monto4 = tp1nro2);
                     
    */
  
    cursor calif(nrodoc varchar2) is
      select to_char(d_fecpre, 'mm/yy') fecrcc,
             n_calif0 nor,
             n_calif1 cpp,
             n_calif2 def,
             n_calif3 dud,
             n_calif4 per
        from cldrcci
       where d_fecpre > add_months(ld_fecrcc, -6)
         and c_tipreg = 1
         and c_tipdet = 'Z'
         and (c_docide = nrodoc or c_doctri = nrodoc)
       order by d_fecpre desc;
  
    cursor visitas is
      select fn_nombre_user(rpad(a1.jaql721user, 10, ' ')) analista,
             a1.jaql721fere,
             f1.scnom nomsuc
        from jaql721 a1, fst001 f1, fst046 f2
       where jaql721tido = P_N_TIPDOC
         and jaql721nudo = P_C_NUMDOC
         and f1.pgcod = 1
         and f1.sucurs = f2.ubsuc
         and f2.ubuser = rpad(a1.jaql721user, 10, ' ');
  
    cursor enti(codsbs varchar2) is
      select c_desemp insti,
             c_destcr tipo,
             n_diaatr atraso,
             n_salcap saldo,
             c_descal calif
        from (select nvl(c_desemp, 'ENTIDAD') c_desemp,
                     --c_destcr,
                     (select decode(trim(tp1desc),
                                    'COORPORATIVOS',
                                    'CORP',
                                    'GRANDES EMPRESAS',
                                    ' GRAN',
                                    'MEDIANAS EMPRESAS',
                                    ' MED',
                                    'PEQUENAS EMPRESAS',
                                    ' PEQ',
                                    'MICROEMPRESAS',
                                    'MICRO',
                                    'CONSUMO REVOLVENTE',
                                    'C REV',
                                    'CONSUMO NO REVOLVENTE',
                                    'C NO REV',
                                    'HIPOTECARIOS PARA VIVIENDA',
                                    ' HIP',
                                    trim(tp1desc))
                        from fst198
                       where Tp1cod = 1
                         and tp1cod1 = 10832
                         and tp1corr1 = 6
                         and tp1corr2 = c_cretip) c_destcr,
                     --c_descta,
                     n_diaatr,
                     decode(c_descal,
                            'NORMAL',
                            'NOR',
                            'C.P.P.',
                            'CPP',
                            'DEFICIENTE',
                            'DEF',
                            'DUDOSO',
                            'DUD',
                            'P?RDIDA',
                            'PER',
                            'SIN_CALI',
                            'SCA') c_descal,
                     sum(n_salcap) n_salcap
                from (select a.c_cretip,
                             DECODE(SUBSTR(A.C_CUENTA, 1, 4),
                                    '1411',
                                    a.c_codsbs,
                                    '1413',
                                    a.c_codsbs,
                                    '1414',
                                    a.c_codsbs,
                                    '1415',
                                    a.c_codsbs,
                                    '1416',
                                    a.c_codsbs,
                                    '1418',
                                    a.c_codsbs,
                                    '1421',
                                    a.c_codsbs,
                                    '1423',
                                    a.c_codsbs,
                                    '1424',
                                    a.c_codsbs,
                                    '1425',
                                    a.c_codsbs,
                                    '1426',
                                    a.c_codsbs,
                                    '1428',
                                    a.c_codsbs,
                                    '7111',
                                    a.c_codsbs,
                                    '7112',
                                    a.c_codsbs,
                                    '7113',
                                    a.c_codsbs,
                                    '7114',
                                    a.c_codsbs,
                                    '7121',
                                    a.c_codsbs,
                                    '7122',
                                    a.c_codsbs,
                                    '7123',
                                    a.c_codsbs,
                                    '7124',
                                    a.c_codsbs,
                                    '8113',
                                    a.c_codsbs,
                                    '8123',
                                    a.c_codsbs,
                                    DECODE(SUBSTR(A.C_CUENTA, 1, 6),
                                           '811302',
                                           a.c_codsbs,
                                           '812302',
                                           a.c_codsbs,
                                           '721501',
                                           a.c_codsbs,
                                           '721502',
                                           a.c_codsbs,
                                           '721503',
                                           a.c_codsbs,
                                           '721504',
                                           a.c_codsbs,
                                           '721505',
                                           a.c_codsbs,
                                           '721506',
                                           a.c_codsbs,
                                           '721507',
                                           a.c_codsbs,
                                           '722501',
                                           a.c_codsbs,
                                           '722502',
                                           a.c_codsbs,
                                           '722503',
                                           a.c_codsbs,
                                           '722504',
                                           a.c_codsbs,
                                           '722505',
                                           a.c_codsbs,
                                           '722506',
                                           a.c_codsbs,
                                           '722507',
                                           a.c_codsbs
                                           /*,0*/)) c_codsbs,
                             DECODE(SUBSTR(A.C_CUENTA, 1, 4),
                                    '1411',
                                    b.c_desabr,
                                    '1413',
                                    b.c_desabr,
                                    '1414',
                                    b.c_desabr,
                                    '1415',
                                    b.c_desabr,
                                    '1416',
                                    b.c_desabr,
                                    '1418',
                                    b.c_desabr,
                                    '1421',
                                    b.c_desabr,
                                    '1423',
                                    b.c_desabr,
                                    '1424',
                                    b.c_desabr,
                                    '1425',
                                    b.c_desabr,
                                    '1426',
                                    b.c_desabr,
                                    '1428',
                                    b.c_desabr,
                                    '7111',
                                    b.c_desabr,
                                    '7112',
                                    b.c_desabr,
                                    '7113',
                                    b.c_desabr,
                                    '7114',
                                    b.c_desabr,
                                    '7121',
                                    b.c_desabr,
                                    '7122',
                                    b.c_desabr,
                                    '7123',
                                    b.c_desabr,
                                    '7124',
                                    b.c_desabr,
                                    '8113',
                                    b.c_desabr,
                                    '8123',
                                    b.c_desabr,
                                    DECODE(SUBSTR(A.C_CUENTA, 1, 6),
                                           '811302',
                                           b.c_desabr,
                                           '812302',
                                           b.c_desabr,
                                           '721501',
                                           b.c_desabr,
                                           '721502',
                                           b.c_desabr,
                                           '721503',
                                           b.c_desabr,
                                           '721504',
                                           b.c_desabr,
                                           '721505',
                                           b.c_desabr,
                                           '721506',
                                           b.c_desabr,
                                           '721507',
                                           b.c_desabr,
                                           '722501',
                                           b.c_desabr,
                                           '722502',
                                           b.c_desabr,
                                           '722503',
                                           b.c_desabr,
                                           '722504',
                                           b.c_desabr,
                                           '722505',
                                           b.c_desabr,
                                           '722506',
                                           b.c_desabr,
                                           '722507',
                                           b.c_desabr
                                           /*,0*/)) c_desemp,
                             DECODE(SUBSTR(A.C_CUENTA, 1, 4),
                                    '1411',
                                    d.tp1desc,
                                    '1413',
                                    d.tp1desc,
                                    '1414',
                                    d.tp1desc,
                                    '1415',
                                    d.tp1desc,
                                    '1416',
                                    d.tp1desc,
                                    '1418',
                                    d.tp1desc,
                                    '1421',
                                    d.tp1desc,
                                    '1423',
                                    d.tp1desc,
                                    '1424',
                                    d.tp1desc,
                                    '1425',
                                    d.tp1desc,
                                    '1426',
                                    d.tp1desc,
                                    '1428',
                                    d.tp1desc,
                                    '7111',
                                    d.tp1desc,
                                    '7112',
                                    d.tp1desc,
                                    '7113',
                                    d.tp1desc,
                                    '7114',
                                    d.tp1desc,
                                    '7121',
                                    d.tp1desc,
                                    '7122',
                                    d.tp1desc,
                                    '7123',
                                    d.tp1desc,
                                    '7124',
                                    d.tp1desc,
                                    '8113',
                                    d.tp1desc,
                                    '8123',
                                    d.tp1desc,
                                    DECODE(SUBSTR(A.C_CUENTA, 1, 6),
                                           '811302',
                                           d.tp1desc,
                                           '812302',
                                           d.tp1desc,
                                           '721501',
                                           d.tp1desc,
                                           '721502',
                                           d.tp1desc,
                                           '721503',
                                           d.tp1desc,
                                           '721504',
                                           d.tp1desc,
                                           '721505',
                                           d.tp1desc,
                                           '721506',
                                           d.tp1desc,
                                           '721507',
                                           d.tp1desc,
                                           '722501',
                                           d.tp1desc,
                                           '722502',
                                           d.tp1desc,
                                           '722503',
                                           d.tp1desc,
                                           '722504',
                                           d.tp1desc,
                                           '722505',
                                           d.tp1desc,
                                           '722506',
                                           d.tp1desc,
                                           '722507',
                                           d.tp1desc
                                           /*,0*/)) c_destcr,
                             DECODE(SUBSTR(A.C_CUENTA, 1, 4),
                                    '1411',
                                    to_char(e.rubro),
                                    '1413',
                                    to_char(e.rubro),
                                    '1414',
                                    to_char(e.rubro),
                                    '1415',
                                    to_char(e.rubro),
                                    '1416',
                                    to_char(e.rubro),
                                    '1418',
                                    to_char(e.rubro),
                                    '1421',
                                    to_char(e.rubro),
                                    '1423',
                                    to_char(e.rubro),
                                    '1424',
                                    to_char(e.rubro),
                                    '1425',
                                    to_char(e.rubro),
                                    '1426',
                                    to_char(e.rubro),
                                    '1428',
                                    to_char(e.rubro),
                                    '7111',
                                    to_char(e.rubro),
                                    '7112',
                                    to_char(e.rubro),
                                    '7113',
                                    to_char(e.rubro),
                                    '7114',
                                    to_char(e.rubro),
                                    '7121',
                                    to_char(e.rubro),
                                    '7122',
                                    to_char(e.rubro),
                                    '7123',
                                    to_char(e.rubro),
                                    '7124',
                                    to_char(e.rubro),
                                    '8113',
                                    to_char(e.rubro),
                                    '8123',
                                    to_char(e.rubro),
                                    DECODE(SUBSTR(A.C_CUENTA, 1, 6),
                                           '811302',
                                           to_char(e.rubro),
                                           '812302',
                                           to_char(e.rubro),
                                           '721501',
                                           to_char(e.rubro),
                                           '721502',
                                           to_char(e.rubro),
                                           '721503',
                                           to_char(e.rubro),
                                           '721504',
                                           to_char(e.rubro),
                                           '721505',
                                           to_char(e.rubro),
                                           '721506',
                                           to_char(e.rubro),
                                           '721507',
                                           to_char(e.rubro),
                                           '722501',
                                           to_char(e.rubro),
                                           '722502',
                                           to_char(e.rubro),
                                           '722503',
                                           to_char(e.rubro),
                                           '722504',
                                           to_char(e.rubro),
                                           '722505',
                                           to_char(e.rubro),
                                           '722506',
                                           to_char(e.rubro),
                                           '722507',
                                           to_char(e.rubro)
                                           /*,0*/)) c_descta,
                             DECODE(SUBSTR(A.C_CUENTA, 1, 4),
                                    '1411',
                                    a.n_diaatr,
                                    '1413',
                                    a.n_diaatr,
                                    '1414',
                                    a.n_diaatr,
                                    '1415',
                                    a.n_diaatr,
                                    '1416',
                                    a.n_diaatr,
                                    '1418',
                                    a.n_diaatr,
                                    '1421',
                                    a.n_diaatr,
                                    '1423',
                                    a.n_diaatr,
                                    '1424',
                                    a.n_diaatr,
                                    '1425',
                                    a.n_diaatr,
                                    '1426',
                                    a.n_diaatr,
                                    '1428',
                                    a.n_diaatr,
                                    '7111',
                                    a.n_diaatr,
                                    '7112',
                                    a.n_diaatr,
                                    '7113',
                                    a.n_diaatr,
                                    '7114',
                                    a.n_diaatr,
                                    '7121',
                                    a.n_diaatr,
                                    '7122',
                                    a.n_diaatr,
                                    '7123',
                                    a.n_diaatr,
                                    '7124',
                                    a.n_diaatr,
                                    '8113',
                                    a.n_diaatr,
                                    '8123',
                                    a.n_diaatr,
                                    DECODE(SUBSTR(A.C_CUENTA, 1, 6),
                                           '811302',
                                           a.n_diaatr,
                                           '812302',
                                           a.n_diaatr,
                                           '721501',
                                           a.n_diaatr,
                                           '721502',
                                           a.n_diaatr,
                                           '721503',
                                           a.n_diaatr,
                                           '721504',
                                           a.n_diaatr,
                                           '721505',
                                           a.n_diaatr,
                                           '721506',
                                           a.n_diaatr,
                                           '721507',
                                           a.n_diaatr,
                                           '722501',
                                           a.n_diaatr,
                                           '722502',
                                           a.n_diaatr,
                                           '722503',
                                           a.n_diaatr,
                                           '722504',
                                           a.n_diaatr,
                                           '722505',
                                           a.n_diaatr,
                                           '722506',
                                           a.n_diaatr,
                                           '722507',
                                           a.n_diaatr
                                           /*,0*/)) n_diaatr,
                             DECODE(SUBSTR(A.C_CUENTA, 1, 4),
                                    '1411',
                                    a.n_salcap,
                                    '1413',
                                    a.n_salcap,
                                    '1414',
                                    a.n_salcap,
                                    '1415',
                                    a.n_salcap,
                                    '1416',
                                    a.n_salcap,
                                    '1418',
                                    a.n_salcap,
                                    '1421',
                                    a.n_salcap,
                                    '1423',
                                    a.n_salcap,
                                    '1424',
                                    a.n_salcap,
                                    '1425',
                                    a.n_salcap,
                                    '1426',
                                    a.n_salcap,
                                    '1428',
                                    a.n_salcap,
                                    '7111',
                                    a.n_salcap,
                                    '7112',
                                    a.n_salcap,
                                    '7113',
                                    a.n_salcap,
                                    '7114',
                                    a.n_salcap,
                                    '7121',
                                    a.n_salcap,
                                    '7122',
                                    a.n_salcap,
                                    '7123',
                                    a.n_salcap,
                                    '7124',
                                    a.n_salcap,
                                    '8113',
                                    a.n_salcap,
                                    '8123',
                                    a.n_salcap,
                                    DECODE(SUBSTR(A.C_CUENTA, 1, 6),
                                           '811302',
                                           a.n_salcap,
                                           '812302',
                                           a.n_salcap,
                                           '721501',
                                           a.n_salcap,
                                           '721502',
                                           a.n_salcap,
                                           '721503',
                                           a.n_salcap,
                                           '721504',
                                           a.n_salcap,
                                           '721505',
                                           a.n_salcap,
                                           '721506',
                                           a.n_salcap,
                                           '721507',
                                           a.n_salcap,
                                           '722501',
                                           a.n_salcap,
                                           '722502',
                                           a.n_salcap,
                                           '722503',
                                           a.n_salcap,
                                           '722504',
                                           a.n_salcap,
                                           '722505',
                                           a.n_salcap,
                                           '722506',
                                           a.n_salcap,
                                           '722507',
                                           a.n_salcap
                                           /*,0*/)) n_salcap,
                             DECODE(SUBSTR(A.C_CUENTA, 1, 4),
                                    '1411',
                                    c.c_desabr,
                                    '1413',
                                    c.c_desabr,
                                    '1414',
                                    c.c_desabr,
                                    '1415',
                                    c.c_desabr,
                                    '1416',
                                    c.c_desabr,
                                    '1418',
                                    c.c_desabr,
                                    '1421',
                                    c.c_desabr,
                                    '1423',
                                    c.c_desabr,
                                    '1424',
                                    c.c_desabr,
                                    '1425',
                                    c.c_desabr,
                                    '1426',
                                    c.c_desabr,
                                    '1428',
                                    c.c_desabr,
                                    '7111',
                                    c.c_desabr,
                                    '7112',
                                    c.c_desabr,
                                    '7113',
                                    c.c_desabr,
                                    '7114',
                                    c.c_desabr,
                                    '7121',
                                    c.c_desabr,
                                    '7122',
                                    c.c_desabr,
                                    '7123',
                                    c.c_desabr,
                                    '7124',
                                    c.c_desabr,
                                    '8113',
                                    c.c_desabr,
                                    '8123',
                                    c.c_desabr,
                                    DECODE(SUBSTR(A.C_CUENTA, 1, 6),
                                           '811302',
                                           c.c_desabr,
                                           '812302',
                                           c.c_desabr,
                                           '721501',
                                           c.c_desabr,
                                           '721502',
                                           c.c_desabr,
                                           '721503',
                                           c.c_desabr,
                                           '721504',
                                           c.c_desabr,
                                           '721505',
                                           c.c_desabr,
                                           '721506',
                                           c.c_desabr,
                                           '721507',
                                           c.c_desabr,
                                           '722501',
                                           c.c_desabr,
                                           '722502',
                                           c.c_desabr,
                                           '722503',
                                           c.c_desabr,
                                           '722504',
                                           c.c_desabr,
                                           '722505',
                                           c.c_desabr,
                                           '722506',
                                           c.c_desabr,
                                           '722507',
                                           c.c_desabr
                                           /*,0*/)) c_descal
                        from CLDRCCS a
                        join ahtbanc b
                          on (b.c_codefi = a.c_codemp and
                             a.d_fecpre = ld_fecrcc and
                             b.c_codefi <> '00104')
                        join wap.crtcali c
                          on (c.c_codcal = a.c_calvig)
                        join fst198 d
                          on (a.c_cretip = d.tp1corr2)
                        left JOIN fsd014 e
                          ON (substr(a.c_cuenta, 1, 2) =
                             substr(to_char(e.rubro), 1, 2) and
                             (to_number(a.c_cuenta) / 10) = e.rubro)
                       WHERE a.c_codsbs = codsbs
                         and Tp1cod = 1
                         and tp1cod1 = 10832
                         and tp1corr1 = 6)
               WHERE C_CODSBS IS NOT NULL
               group by c_cretip,
                        c_codsbs,
                        c_desemp,
                        c_destcr,
                        n_diaatr,
                        c_descal
               order by c_cretip, c_desemp);
  
    cursor cuentas is
      select a2.*, a4.tdnom, a3.penom
        from fsr008 a1, fsr008 a2, fsd001 a3, fst014 a4
       where a1.pgcod = a2.pgcod
         and a1.ctnro = a2.ctnro
         and a3.pepais = a2.pepais
         and a3.petdoc = a2.petdoc
         and a3.pendoc = a2.pendoc
         and a4.tdocum = a3.petdoc
         and a1.pepais = ln_pais
         and a1.petdoc = ln_tipo
         and a1.pendoc = lc_docu
         and a1.ttcod = 1
         and a1.cttfir = 'T';
  
  begin
    execute immediate ('truncate table crdtcap');
  
    begin
      select a.pgfape into ld_fecpro from fst017 a where a.pgcod = 1;
    end;
  
    delete from jaql723
     where JAQL723IDCO = P_C_IDCONX
       and JAQL723USER = P_C_CODUSU;
  
    commit;
  
    ln_pais := 604;
    ln_tipo := P_N_TIPDOC;
    lc_docu := P_C_NUMDOC;
  
    P_C_HABOFE := 'S';
  
    begin
      select rppais, rptdoc, rpndoc
        into ln_paisc, ln_tipoc, lc_docuc
        from fsr002
       where pepais = ln_pais
         and petdoc = ln_tipo
         and pendoc = lc_docu
         and rpccyg = 66;
    
      select penom
        into lc_nomcon
        from fsd001
       where pepais = ln_paisc
         and petdoc = ln_tipoc
         and pendoc = lc_docuc;
    
    exception
      when no_data_found then
        ln_tipoc := null;
    end;
  
    delete from JAQL727
     where petdoc = ln_tipo
       and pendoc = lc_docu;
  
    delete from JAQL727
     where petdoc = ln_tipoc
       and pendoc = lc_docuc;
  
    commit;
  
    --
    -- Obtenemos datos de Alertas
    --
  
    begin
      select to_date(trim(to_char(tpnro)), 'ddmmyyyy')
        into ld_fecrcc
        from fst098
       where pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    end;
  
    if p_c_noclca is not null then
      ln_cont := ln_cont + 1;
    
      p_t_alerta(ln_cont).cod_alerta := 1;
      p_t_alerta(ln_cont).des_alerta := p_c_noclca;
      p_t_alerta(ln_cont).cod_color := '0000F0';
      p_t_alerta(ln_cont).cod_accion := 'N';
      p_t_alerta(ln_cont).valor1 := '';
      p_t_alerta(ln_cont).valor2 := '';
      p_t_alerta(ln_cont).valor3 := '';
      p_t_alerta(ln_cont).valor4 := '';
      p_t_alerta(ln_cont).valor5 := '';
      p_t_alerta(ln_cont).valor6 := '';
      p_t_alerta(ln_cont).valor7 := '';
      p_t_alerta(ln_cont).valor8 := '';
      p_t_alerta(ln_cont).valor9 := '';
      p_t_alerta(ln_cont).valor10 := '';
    end if;
  
    -- CREDITOS VIGENTES
    flagale := 0;
  
    for i in c_vigentes(ln_pais, ln_tipo, lc_docu) loop
      begin
        insert into JAQL727
        values
          (i.petdoc,
           i.pendoc,
           i.descre,
           i.mosign,
           i.monom,
           i.scnom,
           i.pgcod,
           i.scsuc,
           i.scmda,
           i.scpap,
           i.sccta,
           i.scoper,
           i.scsbop,
           i.sctope,
           i.scmod,
           i.scsdo,
           i.numcre,
           i.d_fecven,
           i.c_codana,
           i.titu,
           i.cuota);
      
        commit;
      exception
        when dup_val_on_index then
          null;
      end;
    end loop;
  
    for i in c_vigentes_t loop
      flagvig := 'S';
      flagexi := 0;
    
      flagale := 1;
      if i.scmod = 117 then
        begin
          select 1
            into flagexi
            from fsr011 a, fsd010 b
           Where b.Pgcod = a.R1cod
             and b.Aomod = a.R1mod
             and b.Aosuc = a.R1suc
             and b.Aomda = a.R1mda
             and b.Aopap = a.R1pap
             and b.Aocta = a.R1cta
             and b.Aooper = a.R1oper
             and b.Aosbop = a.R1sbop
             and b.Aotope = a.R1tope
             and b.Aostat <> 99
             and a.R2cod = i.pgcod
             and a.R2mod = i.scmod
             and a.R2suc = i.scsuc
             and a.R2mda = i.scmda
             and a.R2pap = i.scpap
             and a.R2cta = i.sccta
             and a.R2oper = i.scoper
             and a.R2sbop = i.scsbop
             and a.R2tope = i.sctope
             and a.Relcod = 46
             and a.R011co = 'S'
             and rownum = 1;
        exception
          when others then
            flagexi := 0;
        end;
      End If;
    
      if i.scmod <> 117 then
        ln_scsdo := i.Scsdo;
      else
        --valida saldo de la linea                                                        
        if i.scmod = 117 and flagexi = 0 then
          --si no existe 116 para ese 117
          begin
            select x.Scsdo
              into ln_scsdo
              from fsd011 x
             Where x.Pgcod = i.pgcod
               and x.Sccta = i.sccta
               and x.Scmod = 443
               and x.Scmda = i.scmda
               and x.Scpap = i.scpap
               and x.Scoper = i.scoper;
          exception
            when others then
              ln_scsdo := 0;
          end;
        else
          if i.scmod = 117 and flagexi = 1 then
            flagvig := 'N';
          else
            flagvig := 'S';
          end if;
        end if;
      end if;
    
      if i.scmod = 116 then
        begin
          select b.aoimp
            into ln_Monto
            from fsr011 a, fsd010 b
           Where b.Pgcod = a.R2cod
             and b.Aomod = a.R2mod
             and b.Aosuc = a.R2suc
             and b.Aomda = a.R2mda
             and b.Aopap = a.R2pap
             and b.Aocta = a.R2cta
             and b.Aooper = a.R2oper
             and b.Aosbop = a.R2sbop
             and b.Aotope = a.R2tope
             and b.Aostat <> 99
             and a.R1cod = i.pgcod
             and a.R1mod = i.scmod
             and a.R1suc = i.scsuc
             and a.R1mda = i.scmda
             and a.R1pap = i.scpap
             and a.R1cta = i.sccta
             and a.R1oper = i.scoper
             and a.R1sbop = i.scsbop
             and a.R1tope = i.sctope
             and a.Relcod = 46
             and a.R011co = 'S'
             and rownum = 1;
        exception
          when others then
            ln_Monto := 0;
        end;
      else
        begin
          select a.Aoimp
            into ln_Monto
            from Fsd010 a
           Where a.Pgcod = i.pgcod
             and a.Aomod = i.scmod
             and a.Aosuc = i.scsuc
             and a.Aomda = i.scmda
             and a.Aopap = i.scpap
             and a.Aocta = i.sccta
             and a.Aooper = i.scoper
             and a.Aosbop = i.scsbop
             and a.Aotope = i.sctope;
        exception
          when others then
            ln_Monto := 0;
        end;
      End if;
    
      --ln_cuota := BT_Deuda_Cuota(1,i.scmod,i.scsuc,i.scmda,i.scpap,i.sccta,i.scoper,i.scsbop,i.sctope);     
    
      ln_cuota := i.cuota;
    
      if flagvig = 'S' then
        ln_cont := ln_cont + 1;
        p_t_alerta(ln_cont).cod_alerta := 10;
        p_t_alerta(ln_cont).des_alerta := 'CREDITOS VIGENTES';
        p_t_alerta(ln_cont).cod_color := '';
        p_t_alerta(ln_cont).cod_accion := 'C';
        If i.titu = 'T' then
          p_t_alerta(ln_cont).valor1 := 'CREDITO             : ' ||
                                        trim(i.descre);
        Else
          p_t_alerta(ln_cont).valor1 := 'CREDITO CONYUGE     : ' ||
                                        trim(i.descre);
        End If;
        p_t_alerta(ln_cont).valor2 := '                      ' || i.numcre;
        p_t_alerta(ln_cont).valor3 := 'MONEDA              : ' || i.monom;
        p_t_alerta(ln_cont).valor4 := 'MONTO APROBADO      : ' ||
                                      to_char(ln_monto, '9,999,999.00');
        p_t_alerta(ln_cont).valor5 := 'SALDO CAPITAL       : ' ||
                                      to_char(ln_scsdo, '9,999,999.00');
        p_t_alerta(ln_cont).valor6 := 'CUOTA               : ' ||
                                      to_char(ln_cuota, '9,999,999.00');
        p_t_alerta(ln_cont).valor7 := 'VENCIMIENTO CREDITO : ' ||
                                      to_char(i.d_fecven, 'dd/mm/rrrr');
        p_t_alerta(ln_cont).valor8 := 'ANALISTA            : ' ||
                                      FN_NOMBRE_USER(i.c_codana);
        p_t_alerta(ln_cont).valor9 := 'SUCURSAL            : ' ||
                                      trim(i.scnom);
        p_t_alerta(ln_cont).valor10 := '';
      end if;
    
      begin
        select (g.jaql964gas + g.jaql964mor + g.jaql964int + g.jaql964cuo) Deuda,
               g.jaql964dia diasmora
          into ln_deuda, ln_diasmora
          from jaql964 g
         where g.jaql964suc = i.scsuc
           and g.jaql964cta = i.sccta
           and g.jaql964mod = i.scmod
           and g.jaql964mda = i.scmda
           and g.jaql964ope = i.scoper
           and g.jaql964sob = i.scsbop
           and g.jaql964top = i.sctope
           and g.jaql964mod not in (117, 33, 200, 65)
           and g.jaql964dia > 0;
      exception
        when others then
          ln_Deuda    := 0;
          ln_diasmora := 0;
      end;
    
      if ln_diasmora > 0 then
      
        ln_nrocuo := pq_cr_creditos.fn_nro_cuota(pn_emp  => i.pgcod,
                                                 pn_mod  => i.scmod,
                                                 pn_suc  => i.scsuc,
                                                 pn_mda  => i.scmda,
                                                 pn_pap  => i.scpap,
                                                 pn_cta  => i.sccta,
                                                 pn_oper => i.scoper,
                                                 pn_sbop => i.scsbop,
                                                 pn_top  => i.sctope);
      
        ln_cuopen := pq_cr_creditos.fn_nro_cuota_pendiente(pn_emp    => i.pgcod,
                                                           pn_mod    => i.scmod,
                                                           pn_suc    => i.scsuc,
                                                           pn_mda    => i.scmda,
                                                           pn_pap    => i.scpap,
                                                           pn_cta    => i.sccta,
                                                           pn_oper   => i.scoper,
                                                           pn_sbop   => i.scsbop,
                                                           pn_top    => i.sctope,
                                                           pd_fecpro => ld_fecpro);
      
        insert into crdtcap
          (n_monto1,
           n_monto2,
           c_descri,
           c_descri11,
           c_descri12,
           c_descri1,
           c_descri2,
           c_descri3,
           c_descri4,
           c_descri5,
           c_descri6,
           c_descri7,
           c_descri8,
           c_descri9,
           c_descri10
           --c_descri13
           )
        values
          (ln_cont,
           30,
           'CREDITOS MOROSOS',
           '',
           'C',
           decode(i.titu,
                  'T',
                  'CREDITO           : ',
                  'CREDITO CONYUGE   : ') || trim(i.descre),
           '                    ' || i.numcre,
           'MONEDA            : ' || i.monom,
           --'MONTO APROBADO    : ' || to_char(ln_monto, '9,999,999.00'),
           'SALDO CAPITAL     : ' || to_char(ln_scsdo, '9,999,999.00'),
           'DIAS DE ATRASO    : ' || ln_diasmora,
           'CUOTAS IMPAGAS    : ' || trim(to_char(ln_cuopen)) || '/' ||
           trim(to_char(ln_nrocuo)),
           'DEUDA A LA FECHA  : ' || to_char(ln_deuda, '9,999,999.00'),
           'FECHA VENCIMIENTO : ' || to_char(i.d_fecven, 'dd/mm/rrrr'),
           'ANALISTA          : ' || FN_NOMBRE_USER(i.c_codana),
           'SUCURSAL          : ' || i.scnom);
        commit;
      End if;
    
      If i.titu = 'T' then
        begin
          insert into crdtcap
            (n_monto1,
             n_monto2,
             n_monto3,
             n_monto4,
             c_descri,
             c_descri11,
             c_descri12,
             c_descri1,
             c_descri2,
             c_descri3,
             c_descri4,
             c_descri5,
             c_descri6,
             c_descri7,
             c_descri8,
             c_descri9,
             c_descri10)
          
            select ln_cont,
                   90,
                   c.tp1nro1,
                   c.tp1nro2,
                   'SEGUROS',
                   '',
                   'N',
                   trim(upper(tp1desc)),
                   '',
                   '',
                   '',
                   '',
                   '',
                   '',
                   '',
                   '',
                   ''
              from fst198 c
             where tp1cod1 = 10818
               and tp1corr1 = 6
               and tp1corr2 = 2
               and tp1nro2 = 1
               and exists
             (select 1
                      from fpp001 sg, fst300 ms
                     where sg.sgcod = ms.sgcod
                       and sg.pgcod = i.pgcod
                       and sg.aomod = i.scmod
                       and sg.aosuc = i.scsuc
                       and sg.aomda = i.scmda
                       and sg.aopap = i.scpap
                       and sg.aocta = i.sccta
                       and sg.aooper = i.scoper
                       and sg.aosbop = i.scsbop
                       and sg.aotope = i.sctope
                       and to_number(ms.sgsn02) = c.tp1nro1);
          commit;
        
        exception
          when others then
            null;
        end;
      End If;
    end loop;
  
    if flagale = -1 then
      -- si quiere que se vea los cred asi no tenga poner = 0
      ln_cont := ln_cont + 1;
      p_t_alerta(ln_cont).cod_alerta := 10;
      p_t_alerta(ln_cont).des_alerta := 'CREDITOS VIGENTES';
      p_t_alerta(ln_cont).cod_color := '';
      p_t_alerta(ln_cont).cod_accion := 'N'; --N= NADA C= CONTAR I = ICONO
      p_t_alerta(ln_cont).valor1 := '';
      p_t_alerta(ln_cont).valor2 := '';
      p_t_alerta(ln_cont).valor3 := '';
      p_t_alerta(ln_cont).valor4 := '';
      p_t_alerta(ln_cont).valor5 := '';
      p_t_alerta(ln_cont).valor6 := '';
      p_t_alerta(ln_cont).valor7 := '';
      p_t_alerta(ln_cont).valor8 := '';
      p_t_alerta(ln_cont).valor9 := '';
      p_t_alerta(ln_cont).valor10 := '';
    end if;
  
    begin
      insert into crdtcap
        (n_monto1,
         n_monto2,
         n_monto3,
         n_monto4,
         c_descri,
         c_descri11,
         c_descri12,
         c_descri1,
         c_descri2,
         c_descri3,
         c_descri4,
         c_descri5,
         c_descri6,
         c_descri7,
         c_descri8,
         c_descri9,
         c_descri10)
        select ln_cont,
               90,
               PRODINT,
               2,
               'SEGUROS',
               '',
               'N',
               replace(producto, ' MANUAL', ''),
               '',
               '',
               '',
               '',
               '',
               '',
               '',
               '',
               ''
          from v_certificados
         where documento = P_C_NUMDOC
           and (length(cuenta) <> 27 or substr(cuenta, 10, 3) = '022');
    
      commit;
    exception
      when others then
        null;
    end;
  
    -- CREDITOS CANCELADOS  - EL DE MAYOR MONTO EN EL ULTIMO A?O
  
    for i in c_cancela(ln_pais, ln_tipo, lc_docu, ld_fecpro) loop
      ln_cont := ln_cont + 1;
      p_t_alerta(ln_cont).cod_alerta := 20;
      p_t_alerta(ln_cont).des_alerta := 'ULTIMO CREDITO DEL CLIENTE';
      p_t_alerta(ln_cont).cod_color := '';
      p_t_alerta(ln_cont).cod_accion := 'C';
      p_t_alerta(ln_cont).valor1 := 'CREDITO           : ' ||
                                    trim(i.descre);
      p_t_alerta(ln_cont).valor2 := '                    ' || i.numcre;
      p_t_alerta(ln_cont).valor3 := 'MONEDA            : ' || i.monom;
      p_t_alerta(ln_cont).valor4 := 'MONTO APROBADO    : ' ||
                                    to_char(i.aoimp, '9,999,999.00');
      p_t_alerta(ln_cont).valor5 := 'FECHA CANCELACION : ' ||
                                    to_char(i.aofe99, 'dd/mm/rrrr');
      p_t_alerta(ln_cont).valor6 := 'SUCURSAL          : ' || i.scnom;
      p_t_alerta(ln_cont).valor7 := 'FECHA VENCIMIENTO : ' ||
                                    to_char(i.d_fecven, 'dd/mm/rrrr');
      p_t_alerta(ln_cont).valor8 := 'ANALISTA          : ' ||
                                    FN_NOMBRE_USER(i.c_codana);
      p_t_alerta(ln_cont).valor9 := '';
      p_t_alerta(ln_cont).valor10 := '';
    
      exit;
    end loop;
  
    --CREDITOS MOROSOS
    for i in c_morosos loop
      ln_cont := ln_cont + 1;
      p_t_alerta(ln_cont).cod_alerta := i.n_monto2;
      p_t_alerta(ln_cont).des_alerta := i.c_descri;
      p_t_alerta(ln_cont).cod_color := '#FF0000';
      p_t_alerta(ln_cont).cod_accion := 'C';
      p_t_alerta(ln_cont).valor1 := i.c_descri1;
      p_t_alerta(ln_cont).valor2 := i.c_descri2;
      p_t_alerta(ln_cont).valor3 := i.c_descri3;
      p_t_alerta(ln_cont).valor4 := i.c_descri4;
      p_t_alerta(ln_cont).valor5 := i.c_descri5;
      p_t_alerta(ln_cont).valor6 := i.c_descri6;
      p_t_alerta(ln_cont).valor7 := i.c_descri7;
      p_t_alerta(ln_cont).valor8 := i.c_descri8;
      p_t_alerta(ln_cont).valor9 := i.c_descri9;
      p_t_alerta(ln_cont).valor10 := i.c_descri10;
    end loop;
  
    --SOBREENDEUDAMIENTO
    begin
      select a.sobre
        into lc_sobre
        from (select decode(jaqy490sob, 0, 'NO', 'SI') sobre, jaqy490fec
                from jaqy490S
               where jaqy490pai = ln_pais
                 and jaqy490tdo = ln_tipo
                 and jaqy490ndo = lc_docu
                 and jaqy490fec is not null
               order by jaqy490fec desc) a
       where rownum = 1;
    exception
      when no_data_found then
        begin
          select a.sobre
            into lc_sobre
            from (select decode(jaql157sob, 'N', 'NO', 'SI') sobre,
                         jaql157fch
                    from jaql157
                   where jaql157pai = ln_pais
                     and jaql157tdo = ln_tipo
                     and jaql157ndo = lc_docu
                     and jaql157fch is not null
                   order by jaql157fch desc) a
           where rownum = 1;
        exception
          when others then
            lc_sobre := 'NO';
        end;
      
    end;
  
    If lc_sobre = 'SI' then
      lc_accion := 'I';
      lc_color := 'FF0000';
      ln_cont := ln_cont + 1;
      p_t_alerta(ln_cont).cod_alerta := 40;
      p_t_alerta(ln_cont).des_alerta := 'SOBREENDEUDAMIENTO';
      p_t_alerta(ln_cont).cod_color := lc_color;
      p_t_alerta(ln_cont).cod_accion := lc_accion;
      p_t_alerta(ln_cont).valor1 := 'SOBREENDEUDADO: ' || lc_sobre;
      p_t_alerta(ln_cont).valor2 := '';
      p_t_alerta(ln_cont).valor3 := '';
      p_t_alerta(ln_cont).valor4 := '';
      p_t_alerta(ln_cont).valor5 := '';
      p_t_alerta(ln_cont).valor6 := '';
      p_t_alerta(ln_cont).valor7 := '';
      p_t_alerta(ln_cont).valor8 := '';
      p_t_alerta(ln_cont).valor9 := '';
      p_t_alerta(ln_cont).valor10 := '';
    end if;
  
    --end if;
    lc_accion := null;
  
    -- RESTRICCIONES
    -- listas negras
    for i in c_blaclist(ln_pais, ln_tipo, lc_docu) loop
      ln_cont := ln_cont + 1;
      p_t_alerta(ln_cont).cod_alerta := 50;
      p_t_alerta(ln_cont).des_alerta := 'RESTRICCIONES';
      p_t_alerta(ln_cont).cod_color := 'FF0000';
      p_t_alerta(ln_cont).cod_accion := 'I';
      p_t_alerta(ln_cont).valor1 := 'TITULAR LISTAS NEGRAS';
      p_t_alerta(ln_cont).valor2 := 'FECHA     : ' ||
                                    to_char(i.lnfact, 'dd/mm/rrrr');
      p_t_alerta(ln_cont).valor3 := 'TIPO LISTA: ' || i.tlisde;
      p_t_alerta(ln_cont).valor4 := 'MOTIVO    : ' || i.lnmoobs;
      p_t_alerta(ln_cont).valor5 := '';
      p_t_alerta(ln_cont).valor6 := '';
      p_t_alerta(ln_cont).valor7 := '';
      p_t_alerta(ln_cont).valor8 := '';
      p_t_alerta(ln_cont).valor9 := '';
      p_t_alerta(ln_cont).valor10 := '';
    
      P_C_HABOFE := 'N';
    end loop;
  
    for i in c_blaclist(ln_paisc, ln_tipoc, lc_docuc) loop
      ln_cont := ln_cont + 1;
      p_t_alerta(ln_cont).cod_alerta := 50;
      p_t_alerta(ln_cont).des_alerta := 'RESTRICCIONES';
      p_t_alerta(ln_cont).cod_color := 'FF0000';
      p_t_alerta(ln_cont).cod_accion := 'I';
      p_t_alerta(ln_cont).valor1 := 'CONYUGE LISTAS NEGRAS';
      p_t_alerta(ln_cont).valor2 := 'FECHA     : ' ||
                                    to_char(i.lnfact, 'dd/mm/rrrr');
      p_t_alerta(ln_cont).valor3 := 'TIPO LISTA: ' || i.tlisde;
      p_t_alerta(ln_cont).valor4 := 'MOTIVO    : ' || i.lnmoobs;
      p_t_alerta(ln_cont).valor5 := '';
      p_t_alerta(ln_cont).valor6 := '';
      p_t_alerta(ln_cont).valor7 := '';
      p_t_alerta(ln_cont).valor8 := '';
      p_t_alerta(ln_cont).valor9 := '';
      p_t_alerta(ln_cont).valor10 := '';
    
      P_C_HABOFE := 'N';
    end loop;
  
    -- refinanciados
    lc_resref := pq_cr_deudacliente.fn_refinanciado(ln_pais,
                                                    ln_tipo,
                                                    lc_docu);
  
    if lc_resref = 'S' then
      ln_cont := ln_cont + 1;
      p_t_alerta(ln_cont).cod_alerta := 50;
      p_t_alerta(ln_cont).des_alerta := 'RESTRICCIONES';
      p_t_alerta(ln_cont).cod_color := 'FF0000';
      p_t_alerta(ln_cont).cod_accion := 'I';
      p_t_alerta(ln_cont).valor1 := 'TITULAR TIENE CREDITOS REFINANCIADOS';
      p_t_alerta(ln_cont).valor2 := '';
      p_t_alerta(ln_cont).valor3 := '';
      p_t_alerta(ln_cont).valor4 := '';
      p_t_alerta(ln_cont).valor5 := '';
      p_t_alerta(ln_cont).valor6 := '';
      p_t_alerta(ln_cont).valor7 := '';
      p_t_alerta(ln_cont).valor8 := '';
      p_t_alerta(ln_cont).valor9 := '';
      p_t_alerta(ln_cont).valor10 := '';
    
      P_C_HABOFE := 'N';
    end if;
  
    -- refinanciados
    lc_resref := pq_cr_deudacliente.fn_refinanciado(ln_paisc,
                                                    ln_tipoc,
                                                    lc_docuc);
  
    if lc_resref = 'S' then
      ln_cont := ln_cont + 1;
      p_t_alerta(ln_cont).cod_alerta := 50;
      p_t_alerta(ln_cont).des_alerta := 'RESTRICCIONES';
      p_t_alerta(ln_cont).cod_color := 'FF0000';
      p_t_alerta(ln_cont).cod_accion := 'I';
      p_t_alerta(ln_cont).valor1 := 'CONYUGE TIENE CREDITOS REFINANCIADOS';
      p_t_alerta(ln_cont).valor2 := '';
      p_t_alerta(ln_cont).valor3 := '';
      p_t_alerta(ln_cont).valor4 := '';
      p_t_alerta(ln_cont).valor5 := '';
      p_t_alerta(ln_cont).valor6 := '';
      p_t_alerta(ln_cont).valor7 := '';
      p_t_alerta(ln_cont).valor8 := '';
      p_t_alerta(ln_cont).valor9 := '';
      p_t_alerta(ln_cont).valor10 := '';
    
      P_C_HABOFE := 'N';
    end if;
  
    --judiciales
    pq_cr_deudacliente.sp_judicast(ln_pais, ln_tipo, lc_docu, lc_resjud);
  
    if lc_resjud = 'S' then
      ln_cont := ln_cont + 1;
      p_t_alerta(ln_cont).cod_alerta := 50;
      p_t_alerta(ln_cont).des_alerta := 'RESTRICCIONES';
      p_t_alerta(ln_cont).cod_color := 'FF0000';
      p_t_alerta(ln_cont).cod_accion := 'I';
      p_t_alerta(ln_cont).valor1 := 'TITULAR TIENE CREDITOS JUDICIALES';
      p_t_alerta(ln_cont).valor2 := '';
      p_t_alerta(ln_cont).valor3 := '';
      p_t_alerta(ln_cont).valor4 := '';
      p_t_alerta(ln_cont).valor5 := '';
      p_t_alerta(ln_cont).valor6 := '';
      p_t_alerta(ln_cont).valor7 := '';
      p_t_alerta(ln_cont).valor8 := '';
      p_t_alerta(ln_cont).valor9 := '';
      p_t_alerta(ln_cont).valor10 := '';
    
      P_C_HABOFE := 'N';
    end if;
  
    --judiciales
    pq_cr_deudacliente.sp_judicast(ln_paisc, ln_tipoc, lc_docuc, lc_resjud);
  
    if lc_resjud = 'S' then
      ln_cont := ln_cont + 1;
      p_t_alerta(ln_cont).cod_alerta := 50;
      p_t_alerta(ln_cont).des_alerta := 'RESTRICCIONES';
      p_t_alerta(ln_cont).cod_color := 'FF0000';
      p_t_alerta(ln_cont).cod_accion := 'I';
      p_t_alerta(ln_cont).valor1 := 'CONYUGE TIENE CREDITOS JUDICIALES';
      p_t_alerta(ln_cont).valor2 := '';
      p_t_alerta(ln_cont).valor3 := '';
      p_t_alerta(ln_cont).valor4 := '';
      p_t_alerta(ln_cont).valor5 := '';
      p_t_alerta(ln_cont).valor6 := '';
      p_t_alerta(ln_cont).valor7 := '';
      p_t_alerta(ln_cont).valor8 := '';
      p_t_alerta(ln_cont).valor9 := '';
      p_t_alerta(ln_cont).valor10 := '';
    
      P_C_HABOFE := 'N';
    end if;
    --vendida
    pq_cr_deudacliente.sp_venta(ln_pais, ln_tipo, lc_docu, lc_resven);
  
    if lc_resven = 'S' then
      ln_cont := ln_cont + 1;
      p_t_alerta(ln_cont).cod_alerta := 50;
      p_t_alerta(ln_cont).des_alerta := 'RESTRICCIONES';
      p_t_alerta(ln_cont).cod_color := 'FF0000';
      p_t_alerta(ln_cont).cod_accion := 'I';
      p_t_alerta(ln_cont).valor1 := 'TITULAR TIENE CREDITOS EN CARTERA VENDIDA';
      p_t_alerta(ln_cont).valor2 := '';
      p_t_alerta(ln_cont).valor3 := '';
      p_t_alerta(ln_cont).valor4 := '';
      p_t_alerta(ln_cont).valor5 := '';
      p_t_alerta(ln_cont).valor6 := '';
      p_t_alerta(ln_cont).valor7 := '';
      p_t_alerta(ln_cont).valor8 := '';
      p_t_alerta(ln_cont).valor9 := '';
      p_t_alerta(ln_cont).valor10 := '';
    
      P_C_HABOFE := 'N';
    end if;
  
    --vendida
    pq_cr_deudacliente.sp_venta(ln_paisc, ln_tipoc, lc_docuc, lc_resven);
  
    if lc_resven = 'S' then
      ln_cont := ln_cont + 1;
      p_t_alerta(ln_cont).cod_alerta := 50;
      p_t_alerta(ln_cont).des_alerta := 'RESTRICCIONES';
      p_t_alerta(ln_cont).cod_color := 'FF0000';
      p_t_alerta(ln_cont).cod_accion := 'I';
      p_t_alerta(ln_cont).valor1 := 'CONYUGE TIENE CREDITOS EN CARTERA VENDIDA';
      p_t_alerta(ln_cont).valor2 := '';
      p_t_alerta(ln_cont).valor3 := '';
      p_t_alerta(ln_cont).valor4 := '';
      p_t_alerta(ln_cont).valor5 := '';
      p_t_alerta(ln_cont).valor6 := '';
      p_t_alerta(ln_cont).valor7 := '';
      p_t_alerta(ln_cont).valor8 := '';
      p_t_alerta(ln_cont).valor9 := '';
      p_t_alerta(ln_cont).valor10 := '';
    
      P_C_HABOFE := 'N';
    end if;
  
    --CALIFICACION SBS
  
    ln_totale := 0;
    ln_totald := 0;
  
    SP_CALI_RCC(P_N_TIPDOC, P_C_NUMDOC, lc_descal, lc_accion, lc_codsbs);
  
    If ln_tipoc <> 0 then
      lc_nomcon := 'CONYUGE: ' || trim(lc_docuc) || '-' || trim(lc_nomcon);
    
      SP_CALI_RCC(ln_tipoc, lc_docuc, lc_descalc, lc_accionc, lc_codsbsc);
    
      lc_descalc :=  /*'CALIFICACION CONYUGE: ' || */
       trim(lc_descalc);
    
      SP_SALDOS(lc_docuc,
                ln_nument,
                ln_totdeu,
                ln_capend,
                ln_cappag,
                ln_salhipc,
                ln_salconc,
                ln_salpymc);
    
      ln_totale := ln_nument;
      ln_totald := ln_totdeu;
    End if;
  
    If lc_accionc != 'N' then
      lc_accion := lc_accionc;
    End if;
  
    SP_SALDOS(lc_docu,
              ln_nument,
              ln_totdeu,
              ln_capend,
              ln_cappag,
              ln_salhip,
              ln_salcon,
              ln_salpym);
  
    ln_totale := ln_totale + ln_nument;
    ln_totald := ln_totald + ln_totdeu;
  
    --if ln_calif0 <> 100 then
    ln_cont := ln_cont + 1;
    p_t_alerta(ln_cont).cod_alerta := 60;
    p_t_alerta(ln_cont).des_alerta := 'CALIFICACION SBS: ' ||
                                      trim(to_char(ln_totald,
                                                   '99,999,999,990.90')) ||
                                      ' soles / ' ||
                                      trim(to_char(ln_totale, '90')) ||
                                      ' entidad(es)';
    p_t_alerta(ln_cont).cod_color := '';
    p_t_alerta(ln_cont).cod_accion := lc_accion;
    p_t_alerta(ln_cont).valor1 := lc_nomcon;
  
    If ln_tipoc <> 0 then
      p_t_alerta(ln_cont).valor3 := '                   ' ||
                                    '    ***TITULAR***  ' ||
                                    '    ***CONYUGE***  ';
      p_t_alerta(ln_cont).valor4 := 'CALIFICACION      : ' ||
                                    lpad(lc_descal, 20, ' ') ||
                                    lpad(lc_descalc, 20, ' ');
      p_t_alerta(ln_cont).valor5 := 'SALDO PYME        : ' ||
                                    lpad(to_char(ln_salpym,
                                                 '999,999,990.90'),
                                         20,
                                         ' ') || lpad(to_char(ln_salpymc,
                                                              '999,999,990.90'),
                                                      20,
                                                      ' ');
      p_t_alerta(ln_cont).valor6 := 'SALDO CONSUMO     : ' ||
                                    lpad(to_char(ln_salcon, '99,999,990.90'),
                                         20,
                                         ' ') || lpad(to_char(ln_salconc,
                                                              '99,999,990.90'),
                                                      20,
                                                      ' ');
      p_t_alerta(ln_cont).valor7 := 'SALDO HIPOTECARIO : ' ||
                                    lpad(to_char(ln_salhip, '99,999,990.90'),
                                         20,
                                         ' ') || lpad(to_char(ln_salhipc,
                                                              '99,999,990.90'),
                                                      20,
                                                      ' ');
    else
      p_t_alerta(ln_cont).valor3 := '                      ' ||
                                    '    ***TITULAR***  ';
      p_t_alerta(ln_cont).valor4 := 'CALIFICACION      : ' ||
                                    lpad(lc_descal, 20, ' ');
      p_t_alerta(ln_cont).valor5 := 'SALDO PYME        : ' ||
                                    lpad(to_char(ln_salpym,
                                                 '999,999,990.90'),
                                         20,
                                         ' ');
      p_t_alerta(ln_cont).valor6 := 'SALDO CONSUMO     : ' ||
                                    lpad(to_char(ln_salcon, '99,999,990.90'),
                                         20,
                                         ' ');
      p_t_alerta(ln_cont).valor7 := 'SALDO HIPOTECARIO : ' ||
                                    lpad(to_char(ln_salhip, '99,999,990.90'),
                                         20,
                                         ' ');
    end if;
  
    p_t_alerta(ln_cont).valor2 := ' ';
    p_t_alerta(ln_cont).valor8 := '';
    p_t_alerta(ln_cont).valor9 := '';
    p_t_alerta(ln_cont).valor10 := '';
  
    ln_cont := ln_cont + 1;
    p_t_alerta(ln_cont).cod_alerta := 60;
    p_t_alerta(ln_cont).des_alerta := 'CALIFICACION SBS';
    p_t_alerta(ln_cont).cod_color := '';
    p_t_alerta(ln_cont).cod_accion := lc_accion;
    p_t_alerta(ln_cont).valor1 := '<tbl>@hea RCC DETALLE 6 MESES TITULAR';
    p_t_alerta(ln_cont).valor2 := '@tit | FECHA |' || '   NOR   |' ||
                                  '   CPP   |' || '   DEF   |' ||
                                  '   DUD   |' || '   PER   |';
    p_t_alerta(ln_cont).valor3 := '';
    p_t_alerta(ln_cont).valor4 := '';
    p_t_alerta(ln_cont).valor5 := '';
    p_t_alerta(ln_cont).valor6 := '';
    p_t_alerta(ln_cont).valor7 := '';
    p_t_alerta(ln_cont).valor8 := '';
    p_t_alerta(ln_cont).valor9 := '';
    p_t_alerta(ln_cont).valor10 := '';
  
    for z in calif(p_c_numdoc) loop
      ln_cont := ln_cont + 1;
      p_t_alerta(ln_cont).cod_alerta := 60;
      p_t_alerta(ln_cont).des_alerta := 'CALIFICACION SBS';
      p_t_alerta(ln_cont).cod_color := '';
      p_t_alerta(ln_cont).cod_accion := lc_accion;
      p_t_alerta(ln_cont).valor1 := '|' || lpad(z.fecrcc, 6, ' ') || ' |' ||
                                    lpad(to_char(z.nor, '990.90'), 8, ' ') || ' |' ||
                                    lpad(to_char(z.cpp, '990.90'), 8, ' ') || ' |' ||
                                    lpad(to_char(z.def, '990.90'), 8, ' ') || ' |' ||
                                    lpad(to_char(z.dud, '990.90'), 8, ' ') || ' |' ||
                                    lpad(to_char(z.per, '990.90'), 8, ' ') || ' |';
      p_t_alerta(ln_cont).valor2 := '';
      p_t_alerta(ln_cont).valor3 := '';
      p_t_alerta(ln_cont).valor4 := '';
      p_t_alerta(ln_cont).valor5 := '';
      p_t_alerta(ln_cont).valor6 := '';
      p_t_alerta(ln_cont).valor7 := '';
      p_t_alerta(ln_cont).valor8 := '';
      p_t_alerta(ln_cont).valor9 := '';
      p_t_alerta(ln_cont).valor10 := '';
    end loop;
  
    p_t_alerta(ln_cont).valor1 := p_t_alerta(ln_cont).valor1 || '</tbl>';
  
    if ln_tipoc <> 0 then
      ln_cont := ln_cont + 1;
      p_t_alerta(ln_cont).cod_alerta := 60;
      p_t_alerta(ln_cont).des_alerta := 'CALIFICACION SBS';
      p_t_alerta(ln_cont).cod_color := '';
      p_t_alerta(ln_cont).cod_accion := lc_accion;
      p_t_alerta(ln_cont).valor1 := ' ';
      p_t_alerta(ln_cont).valor2 := '<tbl>@hea RCC DETALLE 6 MESES CONYUGE';
      p_t_alerta(ln_cont).valor3 := '@tit | FECHA |' || '   NOR   |' ||
                                    '   CPP   |' || '   DEF   |' ||
                                    '   DUD   |' || '   PER   |';
      p_t_alerta(ln_cont).valor4 := '';
      p_t_alerta(ln_cont).valor5 := '';
      p_t_alerta(ln_cont).valor6 := '';
      p_t_alerta(ln_cont).valor7 := '';
      p_t_alerta(ln_cont).valor8 := '';
      p_t_alerta(ln_cont).valor9 := '';
      p_t_alerta(ln_cont).valor10 := '';
    
      flag := 'N';
      for z in calif(trim(lc_docuc)) loop
        ln_cont := ln_cont + 1;
        flag := 'S';
        p_t_alerta(ln_cont).cod_alerta := 60;
        p_t_alerta(ln_cont).des_alerta := 'CALIFICACION SBS';
        p_t_alerta(ln_cont).cod_color := '';
        p_t_alerta(ln_cont).cod_accion := lc_accion;
        p_t_alerta(ln_cont).valor1 := '|' || lpad(z.fecrcc, 6, ' ') || ' |' ||
                                      lpad(to_char(z.nor, '990.90'), 8, ' ') || ' |' ||
                                      lpad(to_char(z.cpp, '990.90'), 8, ' ') || ' |' ||
                                      lpad(to_char(z.def, '990.90'), 8, ' ') || ' |' ||
                                      lpad(to_char(z.dud, '990.90'), 8, ' ') || ' |' ||
                                      lpad(to_char(z.per, '990.90'), 8, ' ') || ' |';
        p_t_alerta(ln_cont).valor2 := '';
        p_t_alerta(ln_cont).valor3 := '';
        p_t_alerta(ln_cont).valor4 := '';
        p_t_alerta(ln_cont).valor5 := '';
        p_t_alerta(ln_cont).valor6 := '';
        p_t_alerta(ln_cont).valor7 := '';
        p_t_alerta(ln_cont).valor8 := '';
        p_t_alerta(ln_cont).valor9 := '';
        p_t_alerta(ln_cont).valor10 := '';
      end loop;
    
      If flag = 'N' then
        ln_cont := ln_cont + 1;
        p_t_alerta(ln_cont).cod_alerta := 60;
        p_t_alerta(ln_cont).des_alerta := 'CALIFICACION SBS';
        p_t_alerta(ln_cont).cod_color := '';
        p_t_alerta(ln_cont).cod_accion := lc_accion;
        p_t_alerta(ln_cont).valor1 := '</tbl>';
      Else
        p_t_alerta(ln_cont).valor1 := p_t_alerta(ln_cont).valor1 || '</tbl>';
      End if;
    
    end if;
  
    ---------------deuda entidades-----------------------
    ln_cont := ln_cont + 1;
    p_t_alerta(ln_cont).cod_alerta := 60;
    p_t_alerta(ln_cont).des_alerta := 'SALDO CONSOLIDADO DEUDOR';
    p_t_alerta(ln_cont).cod_color := '';
    p_t_alerta(ln_cont).cod_accion := lc_accion;
    p_t_alerta(ln_cont).valor1 := '';
    p_t_alerta(ln_cont).valor2 := '';
    p_t_alerta(ln_cont).valor3 := '';
    p_t_alerta(ln_cont).valor4 := '';
    p_t_alerta(ln_cont).valor5 := '';
    p_t_alerta(ln_cont).valor6 := '';
    p_t_alerta(ln_cont).valor7 := '';
    p_t_alerta(ln_cont).valor8 := '';
    p_t_alerta(ln_cont).valor9 := '';
    p_t_alerta(ln_cont).valor10 := '';
  
    ln_cont := ln_cont + 1;
    p_t_alerta(ln_cont).cod_alerta := 60;
    p_t_alerta(ln_cont).des_alerta := 'SALDO CONSOLIDADO DEUDOR';
    p_t_alerta(ln_cont).cod_color := '';
    p_t_alerta(ln_cont).cod_accion := lc_accion;
    p_t_alerta(ln_cont).valor1 := '<tbl>@hea SALDO CONSOLIDADO DEUDOR TITULAR';
    p_t_alerta(ln_cont).valor2 := '@tit |    INSTITUCION      |' ||
                                  ' TIPO |' || 'ATRASO|' ||
                                  '        SALDO   |' || ' CALIFIC|';
    p_t_alerta(ln_cont).valor3 := '';
    p_t_alerta(ln_cont).valor4 := '';
    p_t_alerta(ln_cont).valor5 := '';
    p_t_alerta(ln_cont).valor6 := '';
    p_t_alerta(ln_cont).valor7 := '';
    p_t_alerta(ln_cont).valor8 := '';
    p_t_alerta(ln_cont).valor9 := '';
    p_t_alerta(ln_cont).valor10 := '';
  
    dbms_output.put_line(lc_codsbs);
    dbms_output.put_line(ld_fecrcc);
  
    for m in enti(lc_codsbs) loop
      ln_cont := ln_cont + 1;
      p_t_alerta(ln_cont).cod_alerta := 60;
      p_t_alerta(ln_cont).des_alerta := 'CALIFICACION SBS';
      p_t_alerta(ln_cont).cod_color := '';
      p_t_alerta(ln_cont).cod_accion := lc_accion;
      p_t_alerta(ln_cont).valor1 := '|' || lpad(m.insti, 20, ' ') || ' |' ||
                                    lpad(m.tipo, 5, ' ') || ' |' ||
                                    lpad(to_char(m.atraso, '99990'), 6, ' ') || '|' ||
                                    lpad(to_char(m.saldo, '99,999,990.90'),
                                         15,
                                         ' ') || ' |' ||
                                    lpad(m.calif, 8, ' ') || '|';
      p_t_alerta(ln_cont).valor2 := '';
      p_t_alerta(ln_cont).valor3 := '';
      p_t_alerta(ln_cont).valor4 := '';
      p_t_alerta(ln_cont).valor5 := '';
      p_t_alerta(ln_cont).valor6 := '';
      p_t_alerta(ln_cont).valor7 := '';
      p_t_alerta(ln_cont).valor8 := '';
      p_t_alerta(ln_cont).valor9 := '';
      p_t_alerta(ln_cont).valor10 := '';
    end loop;
    p_t_alerta(ln_cont).valor1 := p_t_alerta(ln_cont).valor1 || '</tbl>';
  
    if ln_tipoc <> 0 then
      ln_cont := ln_cont + 1;
      p_t_alerta(ln_cont).cod_alerta := 60;
      p_t_alerta(ln_cont).des_alerta := 'SALDO CONSOLIDADO DEUDOR';
      p_t_alerta(ln_cont).cod_color := '';
      p_t_alerta(ln_cont).cod_accion := lc_accion;
      p_t_alerta(ln_cont).valor1 := ' ';
      p_t_alerta(ln_cont).valor2 := '<tbl>@hea SALDO CONSOLIDADO DEUDOR CONYUGE';
      p_t_alerta(ln_cont).valor3 := '@tit |    INSTITUCION      |' ||
                                    ' TIPO |' || 'ATRASO|' ||
                                    '        SALDO   |' || ' CALIFIC|';
      p_t_alerta(ln_cont).valor4 := '';
      p_t_alerta(ln_cont).valor5 := '';
      p_t_alerta(ln_cont).valor6 := '';
      p_t_alerta(ln_cont).valor7 := '';
      p_t_alerta(ln_cont).valor8 := '';
      p_t_alerta(ln_cont).valor9 := '';
      p_t_alerta(ln_cont).valor10 := '';
    
      flag := 'N';
      for m in enti(lc_codsbsc) loop
        ln_cont := ln_cont + 1;
        flag := 'S';
        p_t_alerta(ln_cont).cod_alerta := 60;
        p_t_alerta(ln_cont).des_alerta := 'CALIFICACION SBS';
        p_t_alerta(ln_cont).cod_color := '';
        p_t_alerta(ln_cont).cod_accion := lc_accion;
        p_t_alerta(ln_cont).valor1 := '|' || lpad(m.insti, 20, ' ') || ' |' ||
                                      lpad(m.tipo, 5, ' ') || ' |' ||
                                      lpad(to_char(m.atraso, '99990'),
                                           6,
                                           ' ') || '|' ||
                                      lpad(to_char(m.saldo, '99,999,990.90'),
                                           15,
                                           ' ') || ' |' ||
                                      lpad(m.calif, 8, ' ') || '|';
        p_t_alerta(ln_cont).valor2 := '';
        p_t_alerta(ln_cont).valor3 := '';
        p_t_alerta(ln_cont).valor4 := '';
        p_t_alerta(ln_cont).valor5 := '';
        p_t_alerta(ln_cont).valor6 := '';
        p_t_alerta(ln_cont).valor7 := '';
        p_t_alerta(ln_cont).valor8 := '';
        p_t_alerta(ln_cont).valor9 := '';
        p_t_alerta(ln_cont).valor10 := '';
      end loop;
      If flag = 'N' then
        ln_cont := ln_cont + 1;
        p_t_alerta(ln_cont).cod_alerta := 60;
        p_t_alerta(ln_cont).des_alerta := 'CALIFICACION SBS';
        p_t_alerta(ln_cont).cod_color := '';
        p_t_alerta(ln_cont).cod_accion := lc_accion;
        p_t_alerta(ln_cont).valor1 := '</tbl>';
      Else
        p_t_alerta(ln_cont).valor1 := p_t_alerta(ln_cont).valor1 || '</tbl>';
      End if;
    end if;
  
    -- NO DESEMBOLSADOS
  
    for i in c_desembolso(ln_pais, ln_tipo, lc_docu) loop
      ln_cont := ln_cont + 1;
      p_t_alerta(ln_cont).cod_alerta := 70;
      p_t_alerta(ln_cont).des_alerta := 'CREDITOS NO DESEMBOLSADOS';
      p_t_alerta(ln_cont).cod_color := '';
      p_t_alerta(ln_cont).cod_accion := 'C';
      p_t_alerta(ln_cont).valor1 := 'CREDITO       : ' || trim(i.descre);
      p_t_alerta(ln_cont).valor2 := '                ' || i.numcre;
      p_t_alerta(ln_cont).valor3 := 'MONEDA        : ' || i.monom;
      p_t_alerta(ln_cont).valor4 := 'MONTO APROBADO: ' ||
                                    to_char(i.monto, '9,999,999.00');
      p_t_alerta(ln_cont).valor5 := 'FECHA SOLICIT.: ' ||
                                    to_char(i.fecsol, 'dd/mm/rrrr');
      p_t_alerta(ln_cont).valor6 := 'SUCURSAL      : ' || i.scnom;
      p_t_alerta(ln_cont).valor7 := 'ANALISTA      : ' ||
                                    FN_NOMBRE_USER(i.c_codana);
      p_t_alerta(ln_cont).valor8 := '';
      p_t_alerta(ln_cont).valor9 := '';
      p_t_alerta(ln_cont).valor10 := '';
    end loop;
  
    /*
      
        -- PRODS PASIVOS
        ln_num := ln_cont + 1;
        for i in c_pasivos(ln_pais, ln_tipo, lc_docu) loop
          ln_cont := ln_cont + 1;
          p_t_alerta(ln_cont).cod_alerta := 80;
          p_t_alerta(ln_cont).des_alerta := 'PRODUCTOS PASIVOS';
          p_t_alerta(ln_cont).cod_color := '';
          p_t_alerta(ln_cont).cod_accion := 'N';
          If ln_num = ln_cont then
            p_t_alerta(ln_cont).valor1 := 'El cliente tiene: ' ||
                                          to_char(i.total, 90) || ' ' ||
                                          i.descri;
          Else
            p_t_alerta(ln_cont).valor1 := '                  ' ||
                                          to_char(i.total, 90) || ' ' ||
                                          i.descri;
          End If;
          p_t_alerta(ln_cont).valor2 := '';
          p_t_alerta(ln_cont).valor3 := '';
          p_t_alerta(ln_cont).valor4 := '';
          p_t_alerta(ln_cont).valor5 := '';
          p_t_alerta(ln_cont).valor6 := '';
          p_t_alerta(ln_cont).valor7 := '';
          p_t_alerta(ln_cont).valor8 := '';
          p_t_alerta(ln_cont).valor9 := '';
          p_t_alerta(ln_cont).valor10 := '';
        end loop;
      
        ln_num := ln_cont + 1;
        for i in oferta_pas(ln_pais, ln_tipo, lc_docu) loop
          ln_cont := ln_cont + 1;
          p_t_alerta(ln_cont).cod_alerta := 80;
          p_t_alerta(ln_cont).des_alerta := 'PRODUCTOS PASIVOS';
          p_t_alerta(ln_cont).cod_color := '';
          p_t_alerta(ln_cont).cod_accion := 'N';
          If ln_num = ln_cont then
            p_t_alerta(ln_cont).valor1 := 'Ofrezca: ' || i.produc ||
                                          ' con TEA en S/. desde ' || i.teasol ||
                                          ' y en US$ ' || i.teadol;
          Else
            p_t_alerta(ln_cont).valor1 := '         ' || i.produc ||
                                          ' con TEA en S/. desde ' || i.teasol ||
                                          ' y en US$ ' || i.teadol;
          End If;
        
          p_t_alerta(ln_cont).valor2 := '';
          p_t_alerta(ln_cont).valor3 := '';
          p_t_alerta(ln_cont).valor4 := '';
          p_t_alerta(ln_cont).valor5 := '';
          p_t_alerta(ln_cont).valor6 := '';
          p_t_alerta(ln_cont).valor7 := '';
          p_t_alerta(ln_cont).valor8 := '';
          p_t_alerta(ln_cont).valor9 := '';
          p_t_alerta(ln_cont).valor10 := '';
        end loop;
      
        ln_num := ln_cont + 1;
      
        for i in seguros loop
          ln_cont := ln_cont + 1;
          p_t_alerta(ln_cont).cod_alerta := i.n_monto2;
          p_t_alerta(ln_cont).des_alerta := i.c_descri;
          p_t_alerta(ln_cont).cod_color := '';
          p_t_alerta(ln_cont).cod_accion := 'N';
          If ln_num = ln_cont then
            p_t_alerta(ln_cont).valor1 := 'El cliente tiene: ' ||
                                          to_char(i.total, 90) || ' ' ||
                                          i.c_descri1;
          Else
            p_t_alerta(ln_cont).valor1 := '                  ' ||
                                          to_char(i.total, 90) || ' ' ||
                                          i.c_descri1;
          End If;
        
          p_t_alerta(ln_cont).valor2 := i.c_descri2;
          p_t_alerta(ln_cont).valor3 := i.c_descri3;
          p_t_alerta(ln_cont).valor4 := i.c_descri4;
          p_t_alerta(ln_cont).valor5 := i.c_descri5;
          p_t_alerta(ln_cont).valor6 := i.c_descri6;
          p_t_alerta(ln_cont).valor7 := i.c_descri7;
          p_t_alerta(ln_cont).valor8 := i.c_descri8;
          p_t_alerta(ln_cont).valor9 := i.c_descri9;
          p_t_alerta(ln_cont).valor10 := i.c_descri10;
        end loop;
      
        ln_num := ln_cont + 1;
        for i in oferta_seg loop
          ln_cont := ln_cont + 1;
          p_t_alerta(ln_cont).cod_alerta := 90;
          p_t_alerta(ln_cont).des_alerta := 'SEGUROS';
          p_t_alerta(ln_cont).cod_color := '';
          p_t_alerta(ln_cont).cod_accion := 'N';
        
          If ln_num = ln_cont then
            p_t_alerta(ln_cont).valor1 := 'Ofrezca:       ' || i.produc ||
                                          ' con prima ' || i.prima;
          Else
            p_t_alerta(ln_cont).valor1 := '               ' || i.produc ||
                                          ' con prima ' || i.prima;
          End If;
        
          p_t_alerta(ln_cont).valor2 := '';
          p_t_alerta(ln_cont).valor3 := '';
          p_t_alerta(ln_cont).valor4 := '';
          p_t_alerta(ln_cont).valor5 := '';
          p_t_alerta(ln_cont).valor6 := '';
          p_t_alerta(ln_cont).valor7 := '';
          p_t_alerta(ln_cont).valor8 := '';
          p_t_alerta(ln_cont).valor9 := '';
          p_t_alerta(ln_cont).valor10 := '';
        end loop;
    */
    for i in visitas loop
      ln_cont := ln_cont + 1;
      p_t_alerta(ln_cont).cod_alerta := 100;
      p_t_alerta(ln_cont).des_alerta := 'CLIENTE YA CONTACTADO';
      p_t_alerta(ln_cont).cod_color := 'FF7A01';
      p_t_alerta(ln_cont).cod_accion := 'I';
      p_t_alerta(ln_cont).valor1 := 'El cliente fue contactado el ' ||
                                    i.jaql721fere || ' por ' ||
                                    trim(i.analista) || ' de la sucursal ' ||
                                    i.nomsuc;
      p_t_alerta(ln_cont).valor2 := '';
      p_t_alerta(ln_cont).valor3 := '';
      p_t_alerta(ln_cont).valor4 := '';
      p_t_alerta(ln_cont).valor5 := '';
      p_t_alerta(ln_cont).valor6 := '';
      p_t_alerta(ln_cont).valor7 := '';
      p_t_alerta(ln_cont).valor8 := '';
      p_t_alerta(ln_cont).valor9 := '';
      p_t_alerta(ln_cont).valor10 := '';
    end loop;
  
    for i in cuentas loop
      ln_cont := ln_cont + 1;
      p_t_alerta(ln_cont).cod_alerta := 1000;
      p_t_alerta(ln_cont).des_alerta := 'CUENTAS CLIENTES';
      p_t_alerta(ln_cont).cod_color := '';
      p_t_alerta(ln_cont).cod_accion := '';
      p_t_alerta(ln_cont).valor1 := to_char(i.ctnro);
      p_t_alerta(ln_cont).valor2 := trim(i.tdnom);
      p_t_alerta(ln_cont).valor3 := trim(i.pendoc);
      p_t_alerta(ln_cont).valor4 := trim(i.penom);
      p_t_alerta(ln_cont).valor5 := '';
      p_t_alerta(ln_cont).valor6 := '';
      p_t_alerta(ln_cont).valor7 := '';
      p_t_alerta(ln_cont).valor8 := '';
      p_t_alerta(ln_cont).valor9 := '';
      p_t_alerta(ln_cont).valor10 := '';
    end loop;
  
    for i in p_t_alerta.FIRST .. p_t_alerta.LAST loop
      dbms_output.put_line(p_t_alerta(i).cod_alerta);
      dbms_output.put_line(p_t_alerta(i).des_alerta);
      dbms_output.put_line(p_t_alerta(i).cod_accion);
      dbms_output.put_line(p_t_alerta(i).valor1);
      dbms_output.put_line(p_t_alerta(i).valor2);
      dbms_output.put_line(p_t_alerta(i).valor3);
      dbms_output.put_line(p_t_alerta(i).valor4);
      dbms_output.put_line(p_t_alerta(i).valor5);
      dbms_output.put_line(p_t_alerta(i).valor6);
      dbms_output.put_line(p_t_alerta(i).valor7);
      dbms_output.put_line(p_t_alerta(i).valor8);
      dbms_output.put_line(p_t_alerta(i).valor9);
      dbms_output.put_line(p_t_alerta(i).valor10);
      dbms_output.new_line;
    
      insert into jaql723
      values
        (P_C_IDCONX,
         P_C_CODUSU,
         P_N_TIPDOC,
         P_C_NUMDOC,
         trunc(sysdate),
         to_char(sysdate, 'HH24:MI:SS'),
         p_t_alerta(i).cod_alerta,
         p_t_alerta(i).des_alerta,
         p_t_alerta(i).cod_color,
         p_t_alerta(i).cod_accion,
         p_t_alerta(i).valor1,
         p_t_alerta(i).valor2,
         p_t_alerta(i).valor3,
         p_t_alerta(i).valor4,
         p_t_alerta(i).valor5,
         p_t_alerta(i).valor6,
         p_t_alerta(i).valor7,
         p_t_alerta(i).valor8,
         p_t_alerta(i).valor9,
         p_t_alerta(i).valor10,
         i);
    
      commit;
    
    End loop;
  
  exception
    when others then
      ln_cont := ln_cont + 1;
      lc_error := upper(substr(sqlerrm, 1, 150));
      p_t_alerta(ln_cont).cod_alerta := -1;
      p_t_alerta(ln_cont).des_alerta := 'ERROR';
      p_t_alerta(ln_cont).cod_color := '';
      p_t_alerta(ln_cont).cod_accion := 'N';
      p_t_alerta(ln_cont).valor1 := 'OCURRIO UN PROBLEMA AL OBTENER LAS ALERTAS DEL CLIENTE';
      p_t_alerta(ln_cont).valor2 := lc_error;
      p_t_alerta(ln_cont).valor3 := '';
      p_t_alerta(ln_cont).valor4 := '';
      p_t_alerta(ln_cont).valor5 := '';
      p_t_alerta(ln_cont).valor6 := '';
      p_t_alerta(ln_cont).valor7 := '';
      p_t_alerta(ln_cont).valor8 := '';
      p_t_alerta(ln_cont).valor9 := '';
      p_t_alerta(ln_cont).valor10 := '';
    
      for i in p_t_alerta.FIRST .. p_t_alerta.LAST loop
        dbms_output.put_line(p_t_alerta(i).cod_alerta);
        dbms_output.put_line(p_t_alerta(i).des_alerta);
        dbms_output.put_line(p_t_alerta(i).cod_accion);
        dbms_output.put_line(p_t_alerta(i).valor1);
        dbms_output.put_line(p_t_alerta(i).valor2);
        dbms_output.put_line(p_t_alerta(i).valor3);
        dbms_output.put_line(p_t_alerta(i).valor4);
        dbms_output.put_line(p_t_alerta(i).valor5);
        dbms_output.put_line(p_t_alerta(i).valor6);
        dbms_output.put_line(p_t_alerta(i).valor7);
        dbms_output.put_line(p_t_alerta(i).valor8);
      
        insert into jaql723
        values
          (P_C_IDCONX,
           P_C_CODUSU,
           P_N_TIPDOC,
           P_C_NUMDOC,
           trunc(sysdate),
           to_char(sysdate, 'HH24:MI:SS'),
           p_t_alerta(i).cod_alerta,
           p_t_alerta(i).des_alerta,
           p_t_alerta(i).cod_color,
           p_t_alerta(i).cod_accion,
           p_t_alerta(i).valor1,
           p_t_alerta(i).valor2,
           p_t_alerta(i).valor3,
           p_t_alerta(i).valor4,
           p_t_alerta(i).valor5,
           p_t_alerta(i).valor6,
           p_t_alerta(i).valor7,
           p_t_alerta(i).valor8,
           p_t_alerta(i).valor9,
           p_t_alerta(i).valor10,
           i);
      
      End loop;
    
      commit;
  end sp_cr_datos_alertas;

  ---------------------------------------------------------------------

  procedure SP_PROPUESTA_CAB(IDCONX    IN VARCHAR2,
                             USUARIO   IN VARCHAR2,
                             TIPDOC    IN NUMBER,
                             NUMDOC    IN VARCHAR2,
                             CONDICION IN NUMBER,
                             SEGMENTO  IN NUMBER,
                             CALIFICA  IN NUMBER)
  
   is
  
    vjaql720fech date;
    vjaqz086CALF jaqz086_APL.jaqz086CALF%type;
    vJAQL719FREC jaql719.jaql719frec%type;
    ln_cont      number;
    vtonom       fst004.tonom%type;
    vmdnom       fst003.mdnom%type;
    --evasol       number;
    --evadol       number;
    tipcam      number;
    CAPPAGO     number;
    adicional   number;
    CAPPAGO_D   number;
    adicional_D number;
    nivend      number;
    nivend_d    number;
    Frecpag     varchar2(30);
    lc_activi   varchar2(60);
    --lc_descal   varchar2(200);
  
    ln_paisc number(3) := 604;
    ln_tipoc number(2) := 0;
    lc_docuc char(12);
    NIVENDC  number;
    CAPPAGC  number;
  
    cursor producto is
      select jaql717idgr, jaql717modu, jaql717tope, jaql717alia
        from jaql717 p
       where jaql717segm = segmento
         and jaql717cond = condicion
         and jaql717cali = vjaqz086CALF
         and not exists (select 1
                from fsd011 a, fsr008 b
               where a.pgcod = b.pgcod
                 and a.sccta = b.ctnro
                 and a.scstat <> 99
                 and b.pepais = 604
                 and b.petdoc = TIPDOC
                 and b.pendoc = rpad(NUMDOC, 12, ' ')
                 and p.jaql717modu = a.scmod
                 and p.jaql717tope = a.sctope)
       order by jaql717modu, jaql717tope;
  
    PRODUCTOS PQ_CR_OFERTA_COMERCIAL.TP_PRODUCTO;
  
  begin
  
    delete from jaql724
     where JAQL724IDCO = IDCONX
       and JAQL724USER = USUARIO;
  
    delete from jaql720 where jaql720idco = IDCONX;
  
    commit;
  
    select pgfape into vjaql720fech from fst017 where pgcod = 1;
  
    vjaqz086CALF := CALIFICA;
  
    /*
    SP_CALI_CAJA(TIPDOC,
                 NUMDOC,
                 vjaql720fech,
                 USUARIO,
                 vjaqz086CALF,
                 lc_descal);*/
  
    begin
      select c.JAQL719FREC, c.jaql719desc, actnom1
        into vJAQL719FREC, FRECPAG, lc_activi
        from sngc60 a, fst750 b, jaql719 c -- actividad econ?mica
       where a.sngc60acte = b.actcod1
         and b.actcod3 = c.jaql719acc3
         and a.sngc60pais = 604
         and a.sngc60tdoc = Tipdoc
         and a.sngc60ndoc = rpad(NUMDOC, 12, ' ');
    exception
      when no_data_found then
        FRECPAG := 'MENSUAL';
      when too_many_rows then
        FRECPAG := 'MENSUAL';
    end;
  
    tipcam := fn_tipo_cambio(vjaql720fech, 101, 0, 0);
  
    --CAPPAGO := evasol + (evadol * tipcam);  
    begin
      select nvl(JAQY347CEN, 0), nvl(JAQY347CPA, 0)
        into NIVEND, CAPPAGO
        from JAQY347
       where jaqy347ndo = rpad(NUMDOC, 12, ' ');
    exception
      when others then
        NIVEND  := 0;
        CAPPAGO := 0;
    end;
  
    begin
      select rppais, rptdoc, rpndoc
        into ln_paisc, ln_tipoc, lc_docuc
        from fsr002
       where pepais = 604
         and petdoc = 21
         and pendoc = rpad(NUMDOC, 12, ' ')
         and rpccyg = 66;
    
      select nvl(JAQY347CEN, 0), nvl(JAQY347CPA, 0)
        into NIVENDC, CAPPAGC
        from JAQY347
       where jaqy347ndo = rpad(lc_docuc, 12, ' ');
    
      NIVENDC := 0; -- ya no tomar saldos conyuge
      CAPPAGC := 0;
    
    exception
      when others then
        NIVENDC := 0;
        CAPPAGC := 0;
    end;
  
    NIVEND  := NIVEND + NIVENDC;
    CAPPAGO := CAPPAGO + CAPPAGC;
  
    If vJAQL719FREC = 2 then
      CAPPAGO := CAPPAGO / 2;
    End If;
  
    begin
      select tp1imp1
        into adicional
        from fst198
       where TP1COD = 1
         and tp1cod1 = 10818
         and tp1corr1 = 7
         and tp1corr2 = 1;
    exception
      when others then
        adicional := 0;
    end;
  
    ADICIONAl_D := round(ADICIONAl / tipcam, 2);
    CAPPAGO_D   := round(CAPPAGO / tipcam, 2);
    Nivend_D    := round(NIVEND / tipcam, 2);
  
    ln_cont := 0;
  
    for j in producto loop
    
      ln_cont := ln_cont + 1;
    
      --select mdnom into vmdnom from fst003 where modulo = j.jaql717modu;
      vmdnom := j.jaql717alia;
    
      select tonom
        into vtonom
        from fst004
       where modulo = j.jaql717modu
         and totope = j.jaql717tope;
    
      productos(ln_cont).modulo := j.jaql717modu;
      productos(ln_cont).desmod := vmdnom;
      productos(ln_cont).tipope := j.jaql717tope;
      productos(ln_cont).destip := vtonom;
      /*
      productos(ln_cont).cappago := CAPPAGO;
      productos(ln_cont).adicional := ADICIONAl;
      productos(ln_cont).cappago_d := CAPPAGO_D;
      productos(ln_cont).adicional_d := ADICIONAl_D;
      */
      productos(ln_cont).frecpag := FRECPAG; --|| '-' ||trim(to_char(NIVEND, '999,999,990.90')) || '-' ||                                    trim(to_char(CAPPAGO, '999,990.90'));
    
      --llena tabla oferta
      begin
        insert into jaql720
          select IDCONX,
                 jaql718mone,
                 jaql718corr,
                 j.jaql717modu,
                 j.jaql717tope,
                 jaql718capi,
                 jaql718tasa,
                 jaql718pz01,
                 jaql718cu01,
                 jaql718pz02,
                 jaql718cu02,
                 jaql718pz03,
                 jaql718cu03,
                 jaql718pz04,
                 jaql718cu04,
                 jaql718pz05,
                 jaql718cu05,
                 jaql718pz06,
                 jaql718cu06,
                 jaql718pz07,
                 jaql718cu07,
                 jaql718pz08,
                 jaql718cu08,
                 jaql718pz09,
                 jaql718cu09,
                 jaql718pz10,
                 jaql718cu10,
                 tipdoc,
                 numdoc,
                 usuario,
                 vjaql720fech,
                 to_char(sysdate, 'HH:MI:SS'),
                 SEGMENTO,
                 condicion,
                 vjaqz086CALF,
                 CAPPAGO,
                 CAPPAGO_D,
                 ADICIONAl,
                 ADICIONAl_D,
                 Nivend,
                 Nivend_D
            from jaql718
           where jaql718idgr = j.jaql717idgr;
      exception
        when dup_val_on_index then
          null;
      end;
    
      commit;
    
    end loop;
  
    if ln_cont = 0 then
      productos(1).modulo := -1;
      productos(1).desmod := 'No hay ofertas para el cliente';
    end if;
  
    for i in productos.FIRST .. productos.LAST loop
      dbms_output.put_line('modulo: ' || productos(i).modulo);
      dbms_output.put_line('desmod:' || productos(i).desmod);
      dbms_output.put_line('tipope:' || productos(i).tipope);
      dbms_output.put_line('destip:' || productos(i).destip);
      dbms_output.put_line('frecpag:' || productos(i).frecpag);
      dbms_output.new_line;
    
      insert into jaql724
        (jaql724idco,
         jaql724user,
         jaql724tido,
         jaql724nudo,
         jaql724fech,
         jaql724hora,
         modulo,
         desmod,
         tipope,
         destip,
         frecpag)
      values
        (IDCONX,
         USUARIO,
         TIPDOC,
         NUMDOC,
         trunc(sysdate),
         to_char(sysdate, 'HH24:MI:SS'),
         productos(i).modulo,
         productos(i).desmod,
         productos(i).tipope,
         productos(i).destip,
         productos(i).frecpag);
    
    End loop;
    commit;
  
  end SP_PROPUESTA_CAB;

  ---------------------------------------------------------------------

  procedure SP_PROPUESTA_DET(IDCONX   IN VARCHAR2,
                             USUARIO  IN VARCHAR2,
                             MONEDA   IN NUMBER,
                             MODULO   IN NUMBER,
                             TIPOOP   IN NUMBER,
                             SEGMENTO IN NUMBER,
                             CALIFICA IN NUMBER,
                             NIVEND   OUT NUMBER,
                             CAPPAG   OUT NUMBER) is
  
    oferta pq_cr_oferta_comercial.vc_matriz;
  
    cursor prop is
      select *
        from jaql720
       where jaql720idco = IDCONX
         and jaql720mone = MONEDA
         and jaql720modu = MODULO
         and jaql720tope = TIPOOP
         and jaql720segm = SEGMENTO
         and jaql720cali = CALIFICA; --decode(SEGMENTO,3,1,segmento);
  
    a number;
    b number;
  
    --CAPPAG number;
    ADICIO number;
    --NIVEND number;
  
    capital number;
  
    detalle   varchar2(250);
    detalle_c varchar2(250);
    color     char(2);
    monto     number(12, 2);
  
    va01 varchar2(20);
    va02 varchar2(20);
    va03 varchar2(20);
    va04 varchar2(20);
    va05 varchar2(20);
    va06 varchar2(20);
    va07 varchar2(20);
    va08 varchar2(20);
    va09 varchar2(20);
    va10 varchar2(20);
    va11 varchar2(20);
    va12 varchar2(20);
  
    mm number;
  
    NIVENDx number;
  
  begin
  
    delete from jaql725
     where JAQL725IDCO = IDCONX
       and JAQL725USER = USUARIO
       and JAQL725MONE = MONEDA
       and JAQL725MODU = MODULO
       and JAQL725TOPE = TIPOOP;
  
    a := 0;
  
    for z in prop loop
    
      if moneda = 0 then
        cappag := z.jaql720cpso;
        adicio := z.jaql720cpso + z.jaql720adso;
        nivend := z.jaql720enso;
      else
        cappag := z.jaql720cpdo;
        adicio := z.jaql720cpdo + z.jaql720addo;
        nivend := z.jaql720endo;
      end if;
    
      NIVENDx := nivend;
    
      If SEGMENTO = 2 then
        nivend := 999999999;
      End if;
    
      a := a + 1;
      b := 1;
    
      if a = 1 then
        if z.jaql720pz01 > 0 then
        
          oferta(a)(b) := 'Capital';
          b := b + 1;
          oferta(a)(b) := z.jaql720pz01 || 'M';
        
          if z.jaql720pz02 > 0 then
            b := b + 1;
            oferta(a)(b) := z.jaql720pz02 || 'M';
          
            if z.jaql720pz03 > 0 then
              b := b + 1;
              oferta(a)(b) := z.jaql720pz03 || 'M';
            
              if z.jaql720pz04 > 0 then
                b := b + 1;
                oferta(a)(b) := z.jaql720pz04 || 'M';
              
                if z.jaql720pz05 > 0 then
                  b := b + 1;
                  oferta(a)(b) := z.jaql720pz05 || 'M';
                
                  if z.jaql720pz06 > 0 then
                    b := b + 1;
                    oferta(a)(b) := z.jaql720pz06 || 'M';
                  
                    if z.jaql720pz07 > 0 then
                      b := b + 1;
                      oferta(a)(b) := z.jaql720pz07 || 'M';
                    
                      if z.jaql720pz08 > 0 then
                        b := b + 1;
                        oferta(a)(b) := z.jaql720pz08 || 'M';
                      
                        if z.jaql720pz09 > 0 then
                          b := b + 1;
                          oferta(a)(b) := z.jaql720pz09 || 'M';
                        
                          if z.jaql720pz10 > 0 then
                            b := b + 1;
                            oferta(a)(b) := z.jaql720pz10 || 'M';
                          end if;
                        end if;
                      end if;
                    end if;
                  
                  end if;
                end if;
              
              end if;
            end if;
          end if;
          b := b + 1;
          oferta(a)(b) := 'TASA';
        
          b := 1;
          a := a + 1;
        
          oferta(a)(b) := to_char(z.jaql720capi, '99,999,990');
          b := b + 1;
        
          oferta(a)(b) := to_char(z.jaql720cu01, '999,990.90');
          b := b + 1;
          oferta(a)(b) := to_char(z.jaql720cu02, '999,990.90');
          b := b + 1;
          oferta(a)(b) := to_char(z.jaql720cu03, '999,990.90');
          b := b + 1;
          oferta(a)(b) := to_char(z.jaql720cu04, '999,990.90');
          b := b + 1;
          oferta(a)(b) := to_char(z.jaql720cu05, '999,990.90');
          b := b + 1;
          oferta(a)(b) := to_char(z.jaql720cu06, '999,990.90');
          b := b + 1;
          oferta(a)(b) := to_char(z.jaql720cu07, '999,990.90');
          b := b + 1;
          oferta(a)(b) := to_char(z.jaql720cu08, '999,990.90');
          b := b + 1;
          oferta(a)(b) := to_char(z.jaql720cu09, '999,990.90');
          b := b + 1;
          oferta(a)(b) := to_char(z.jaql720cu10, '999,990.90');
        
          b := b + 1;
          oferta(a)(b) := to_char(z.jaql720tasa, '90.990');
        
        else
          exit;
        end if;
      
      else
        oferta(a)(b) := to_char(z.jaql720capi, '99,999,990');
      
        b := b + 1;
        oferta(a)(b) := to_char(z.jaql720cu01, '999,990.90');
        b := b + 1;
        oferta(a)(b) := to_char(z.jaql720cu02, '999,990.90');
        b := b + 1;
        oferta(a)(b) := to_char(z.jaql720cu03, '999,990.90');
        b := b + 1;
        oferta(a)(b) := to_char(z.jaql720cu04, '999,990.90');
        b := b + 1;
        oferta(a)(b) := to_char(z.jaql720cu05, '999,990.90');
        b := b + 1;
        oferta(a)(b) := to_char(z.jaql720cu06, '999,990.90');
        b := b + 1;
        oferta(a)(b) := to_char(z.jaql720cu07, '999,990.90');
        b := b + 1;
        oferta(a)(b) := to_char(z.jaql720cu08, '999,990.90');
        b := b + 1;
        oferta(a)(b) := to_char(z.jaql720cu09, '999,990.90');
        b := b + 1;
        oferta(a)(b) := to_char(z.jaql720cu10, '999,990.90');
        b := b + 1;
        oferta(a)(b) := to_char(z.jaql720tasa, '90.990');
      end if;
    
    end loop;
  
    If a = 0 then
      oferta(1)(1) := '-1';
      oferta(1)(2) := 'No existe tarifario';
      dbms_output.put_line(oferta(1) (1) || '|' || oferta(1) (2));
    Else
      for m in 1 .. oferta.Count loop
        for n in 1 .. oferta(m).Count loop
          --dbms_output.put_line(oferta(m)(n));  
          if oferta(m) (n) is not null then
            detalle := oferta(m) (n);
            If m >= 2 and n = 1 then
              detalle_c := oferta(m) (n);
              capital   := to_number(trim(replace(detalle_c, ',', '')),
                                     '999999990.90');
            End If;
            if m > 1 and n > 1 and n < oferta(m).Count then
              if CAPPAG > 0 then
                monto := to_number(trim(replace(detalle, ',', '')),
                                   '999999990.90');
                If capital <= nivend then
                  -- si nivel de endeudamiento es mayor igual a k              
                  case
                    when monto <= CAPPAG then
                      color := 'V|';
                    when monto > CAPPAG and monto <= ADICIO then
                      color := 'A|';
                    else
                      color := 'R|';
                  end case;
                else
                  color := 'R|'; -- si nivel no cubre capital
                end if;
                detalle := color || oferta(m) (n);
              else
                detalle := 'P|' || oferta(m) (n);
              end if;
            end if;
          
            oferta(m)(n) := detalle;
            dbms_output.put(lpad(oferta(m) (n), 15, ' ') || '|');
          
          end if;
        end loop;
        dbms_output.new_line;
      end loop;
    End If;
  
    for m in 1 .. oferta.Count loop
      a  := 0;
      mm := m;
      for n in 1 .. oferta(m).Count loop
        detalle := oferta(m) (n);
        if oferta(m) (n) is not null then
          a := a + 1;
          case
            when a = 1 then
              va01 := oferta(m) (n);
            when a = 2 then
              va02 := oferta(m) (n);
            when a = 3 then
              va03 := oferta(m) (n);
            when a = 4 then
              va04 := oferta(m) (n);
            when a = 5 then
              va05 := oferta(m) (n);
            when a = 6 then
              va06 := oferta(m) (n);
            when a = 7 then
              va07 := oferta(m) (n);
            when a = 8 then
              va08 := oferta(m) (n);
            when a = 9 then
              va09 := oferta(m) (n);
            when a = 10 then
              va10 := oferta(m) (n);
            when a = 11 then
              va11 := oferta(m) (n);
            when a = 12 then
              va12 := oferta(m) (n);
          end case;
        end if;
      end loop;
    
      NIVEND := nivendx;
    
      insert into jaql725
      values
        (IDCONX,
         USUARIO,
         mm,
         MONEDA,
         MODULO,
         TIPOOP,
         va01,
         va02,
         va03,
         va04,
         va05,
         va06,
         va07,
         va08,
         va09,
         va10,
         va11,
         va12,
         SEGMENTO,
         CALIFICA);
      commit;
    end loop;
  
  end SP_PROPUESTA_DET;

  ---------------------------------------------------------------------

  procedure SP_REGISTRA_OPORTUNIDAD(vjaql721idco   varchar2,
                                    vjaql721user   varchar2,
                                    vjaql721fere_v varchar2, -- date,
                                    vjaql721tido   number,
                                    vjaql721nudo   varchar2,
                                    vjaql721nomb   varchar2,
                                    vjaql721segm   number,
                                    vjaql721tidi   number,
                                    vjaql721dire   varchar2,
                                    vjaql721tite   number,
                                    vjaql721telf   number,
                                    vjaql721mail   varchar2,
                                    vjaql721mone   number,
                                    vjaql721modu   number,
                                    vjaql721tope   number,
                                    vjaql721mont   number,
                                    vjaql721plaz   number,
                                    vjaql721tasa   number,
                                    vjaql721estr   number,
                                    vjaql721feco_v varchar2, -- date,
                                    P_C_DESPRO     IN VARCHAR2,
                                    codmsg         OUT varchar2,
                                    mensaje        OUT varchar2) is
  
    --msgerr varchar2(200);
  
    vjaql721fere date := to_date(vjaql721fere_v, 'dd-mm-yyyy');
    vjaql721feco date := to_date(vjaql721feco_v, 'dd-mm-yyyy');
  
  begin
    codmsg  := 0;
    mensaje := 'Grabacion Satisfactoria';
  
    begin
      insert into jaql721
      values
        (vjaql721idco,
         vjaql721user,
         vjaql721fere,
         vjaql721tido,
         vjaql721nudo,
         vjaql721segm,
         vjaql721tidi,
         vjaql721dire,
         vjaql721tite,
         vjaql721telf,
         vjaql721mail,
         vjaql721mone,
         vjaql721modu,
         vjaql721tope,
         vjaql721mont,
         vjaql721plaz,
         vjaql721tasa,
         vjaql721estr,
         vjaql721feco,
         to_char(sysdate, 'HH24:MI:SS'),
         vjaql721nomb,
         P_C_DESPRO);
    exception
      when dup_val_on_index then
        codmsg  := -1;
        mensaje := 'Oportunidad ya se registro';
      when others then
        codmsg  := -1;
        mensaje := 'No se pudo registrar la oportunidad';
        --msgerr  := sqlerrm;
    end;
  
    commit;
  
  end SP_REGISTRA_OPORTUNIDAD;

  ---------------------------------------------------------------------

  procedure SP_REGISTRA_SOLICITUD(P_C_IDCONX   IN VARCHAR2,
                                  P_C_CODUSU   IN VARCHAR2,
                                  P_D_FECREG_v IN varchar2, -- IN DATE,
                                  P_N_TIPDOC   IN NUMBER,
                                  P_C_NUMDOC   IN VARCHAR2,
                                  P_C_CUENTA   IN NUMBER,
                                  P_N_MONEDA   IN NUMBER,
                                  P_N_MODULO   IN NUMBER,
                                  P_N_TIPOPE   IN NUMBER,
                                  P_N_MONTO    IN NUMBER,
                                  P_N_PLAZO    IN NUMBER,
                                  P_N_FRECU    IN NUMBER,
                                  P_N_TIPSOL   IN NUMBER,
                                  P_C_CODMSG   OUT VARCHAR2,
                                  P_C_DESMSG   OUT VARCHAR2) is
  
    P_D_FECREG date := to_date(P_D_FECREG_v, 'dd-mm-yyyy');
  
    VEXISTE   char(1);
    VJAQM80ID number(10);
    VCUENTA   number(9);
    VOPERA    number(9);
    VSUCUR    number(3);
  
    VJAQM81ID number(10);
  
    cursor aval is
      select x2.sng003cta vjaqm81ca
        from xwf700 x1, sng003 x2
       where x2.sng001inst = x1.xwfprcins
         and x2.sng003pgc = x1.xwfempresa
         and xwfcar3 = '1'
         and XWFEMPRESA = 1
         and XWFCUENTA = vcuenta
         and XWFOPERACION = vopera;
  
  begin
  
    P_C_CODMSG := '';
  
    begin
      select max(JAQM80ID) + 1 into VJAQM80ID from jaqm80;
    exception
      when no_data_found then
        VJAQM80ID := 1;
    end;
  
    VCUENTA := 0;
    VOPERA  := 0;
  
    VEXISTE := 'N';
  
    begin
      select 'S'
        into VEXISTE
        from fsd001 f4
       where f4.pepais = 604
         and f4.petdoc = P_N_TIPDOC
         and f4.pendoc = rpad(P_C_NUMDOC, 12, ' ');
    exception
      when no_data_found then
        P_C_CODMSG := '1';
        P_C_DESMSG := 'NO EXISTE LA PERSONA EN BT';
        return;
    end;
  
    /*  
       --cuenta
       begin
         select ctnro, aooper
           into VCUENTA, VOPERA
           from (select ctnro, aooper
                   from fsr008 f1,
                        fsd010 f2,
                        (select *
                           from fst111
                         union all
                         select 50, 117
                           from dual
                         union all
                         select 50, 141
                           from dual
                         union all
                         select 50, 65
                           from dual) c2
                  where f1.pgcod = f2.pgcod
                    and f1.ctnro = f2.aocta
                    and f2.aomod = c2.modulo
                    and c2.dscod = 50
                    and pepais = 604
                    and petdoc = P_N_TIPDOC
                    and pendoc = rpad(P_C_NUMDOC, 12, ' ')
                    and ttcod = 1
                  order by aofval desc)
          where rownum = 1;
       exception
         when no_data_found then
           begin
             select ctnro
               into VCUENTA
               from (select ctnro
                       from fsr008 f1, fsd010 f2
                      where f1.pgcod = f2.pgcod
                        and f1.ctnro = f2.aocta
                        and pepais = 604
                        and petdoc = P_N_TIPDOC
                        and pendoc = rpad(P_C_NUMDOC, 12, ' ')
                        and ttcod = 1
                        and aomod = 22
                      order by aofval desc)
              where rownum = 1;
           
           exception
             when no_data_found then
               begin
                 select ctnro
                   into VCUENTA
                   from (select sccta ctnro
                           from fsr008 f1, fsd011 f3
                          where f1.pgcod = f3.pgcod
                            and f1.ctnro = f3.sccta
                            and pepais = 604
                            and petdoc = P_N_TIPDOC
                            and pendoc = rpad(P_C_NUMDOC, 12, ' ')
                            and ttcod = 1
                            and scmod = 21
                          order by scfval desc)
                  where rownum = 1;
               exception
                 when no_data_found then
                   vcuenta := 0;
               end;
           end;
       end;
     
       if vcuenta = 0 then
         SP_CREA_CUENTA(P_N_TIPDOC, P_C_NUMDOC, VCUENTA);
       end if;
     
       if VCUENTA = 0 then
         P_C_CODMSG := '2';
         P_C_DESMSG := 'NO EXISTE CUENTA PARA EL CLIENTE';
         return;
       end if;
    */
  
    VCUENTA := P_C_CUENTA;
    -- sucur
    VSUCUR := FN_SUCUR_USER(P_C_CODUSU);
  
    insert into JAQM80
      (JAQM80ID,
       JAQM80FC,
       JAQM80OR,
       JAQM80PA,
       JAQM80TD,
       JAQM80ND,
       JAQM80CT,
       JAQM80TS,
       JAQM80SU,
       JAQM80MO,
       JAQM80TP,
       JAQM80MN,
       JAQM80PP,
       JAQM80CN,
       JAQM80PE,
       JAQM80IM,
       JAQM80TA,
       JAQM80AS,
       JAQM80OG,
       JAQM80ES,
       JAQM80SO,
       JAQM80DS)
    values
      (VJAQM80ID,
       P_D_FECREG,
       0,
       604,
       P_N_TIPDOC,
       P_C_NUMDOC,
       VCUENTA,
       P_N_TIPSOL,
       VSUCUR,
       P_N_MODULO,
       P_N_TIPOPE,
       P_N_MONEDA,
       0,
       P_N_PLAZO,
       P_N_FRECU,
       P_N_MONTO,
       0,
       P_C_CODUSU,
       4,
       'A',
       0,
       'OC-' || P_C_IDCONX);
  
    if vopera <> 0 then
      /*      begin
        select max(JAQM81ID) + 1 into VJAQM81ID from jaqm81;
      exception
        when no_data_found then
          VJAQM81ID := 1;
      end;*/
    
      VJAQM81ID := VJAQM80ID;
    
      for j in aval loop
        begin
          insert into jaqm81 values (VJAQM81ID, 1, j.vjaqm81ca);
        exception
          when dup_val_on_index then
            null;
        end;
      end loop;
    
    end if;
  
    commit;
  
  end SP_REGISTRA_SOLICITUD;

  ---------------------------------------------------------------------

  function FN_NOMBRE_USER(P_C_UBUSER char) return varchar2 is
    lc_ubnom fst746.ubnom%type;
  begin
    select ubnom into lc_ubnom from fst746 where ubuser = P_C_UBUSER;
    return lc_ubnom;
  exception
    when others then
      lc_ubnom := '';
      return lc_ubnom;
  end;
  ----------------------------------------

  function FN_SUCUR_USER(P_C_UBUSER char) return number is
    ln_ubsuc fst046.ubsuc%type;
  begin
    select ubsuc into ln_ubsuc from fst046 where ubuser = P_C_UBUSER;
    return ln_ubsuc;
  exception
    when others then
      ln_ubsuc := 0;
      return ln_ubsuc;
  end;

  procedure SP_CALI_RCC(P_N_TIPDOC IN NUMBER,
                        P_C_NUMDOC IN VARCHAR2,
                        P_C_DESCAL OUT VARCHAR2,
                        P_C_ACCION OUT CHAR,
                        P_C_CODSBS OUT VARCHAR2) is
  
    ln_tipo   number(2);
    lc_docu   char(12);
    ln_calif0 number(5, 2) := 0;
    ln_calif1 number(5, 2) := 0;
    ln_calif2 number(5, 2) := 0;
    ln_calif3 number(5, 2) := 0;
    ln_calif4 number(5, 2) := 0;
    lc_descal varchar2(50);
    ld_fecpro date;
    lc_accion char(1) := null;
    lc_existe char(1) := 'N';
  
  begin
  
    ln_tipo := P_N_TIPDOC;
    lc_docu := P_C_NUMDOC;
  
    begin
      --fecha del ultimo rcc              
      select to_date(tpnro, 'dd/mm/rrrr')
        into ld_fecpro
        from fst098
       where pgcod = 1
         and tpcod = 7647
         and tpcorr = 12;
    exception
      when others then
        ld_fecpro := null;
    end;
  
    lc_accion := 'N';
  
    if ln_tipo <> 9 then
      begin
        select a.n_calif0,
               a.n_calif1,
               a.n_calif2,
               a.n_calif3,
               a.n_calif4,
               c_codsbs
          into ln_calif0,
               ln_calif1,
               ln_calif2,
               ln_calif3,
               ln_calif4,
               P_C_CODSBS
          from cldrcci a
         where a.d_fecpre = ld_fecpro
           and a.c_docide = trim(lc_docu)
           and c_tipreg = 1
           and c_tipdet = 'Z'
           and rownum = 1;
        lc_existe := 'S';
      exception
        when others then
          ln_calif0 := 0;
          ln_calif1 := 0;
          ln_calif2 := 0;
          ln_calif3 := 0;
          ln_calif4 := 0;
          lc_existe := 'N';
          lc_descal := 'SIN CALIFICACION';
      end;
    else
      begin
        select a.n_calif0,
               a.n_calif1,
               a.n_calif2,
               a.n_calif3,
               a.n_calif4,
               C_CODSBS
          into ln_calif0,
               ln_calif1,
               ln_calif2,
               ln_calif3,
               ln_calif4,
               P_C_CODSBS
          from cldrcci a
         where a.d_fecpre = ld_fecpro
           and a.c_doctri = trim(lc_docu)
           and c_tipreg = 1
           and c_tipdet = 'Z'
           and rownum = 1;
        lc_existe := 'S';
      exception
        when others then
          ln_calif0 := 0;
          ln_calif1 := 0;
          ln_calif2 := 0;
          ln_calif3 := 0;
          ln_calif4 := 0;
          lc_existe := 'N';
          lc_descal := 'SIN CALIFICACION';
      end;
    end if;
  
    if (ln_calif0 + ln_calif1 + ln_calif2 + ln_calif3 + ln_calif4) = 0 and
       lc_existe = 'S' then
      lc_descal := 'SIN HISTORIAL';
      lc_accion := 'N';
    end if;
  
    If ln_calif0 > 0 then
      lc_descal := to_char(ln_calif0, '999.00') || '%' || '-' || 'NORMAL';
      lc_accion := 'N';
    End If;
    If ln_calif1 > 0 then
      lc_descal := to_char(ln_calif1, '999.00') || '%' || '-' || 'C.P.P.';
      lc_accion := 'I';
    End If;
    If ln_calif2 > 0 then
      lc_descal := to_char(ln_calif2, '999.00') || '%' || '-' ||
                   'DEFICIENTE';
      lc_accion := 'I';
    End If;
    If ln_calif3 > 0 then
      lc_descal := to_char(ln_calif3, '999.00') || '%' || '-' || 'DUDOSO';
      lc_accion := 'I';
    End If;
    If ln_calif4 > 0 then
      lc_descal := to_char(ln_calif4, '999.00') || '%' || '-' || 'PERDIDA';
      lc_accion := 'I';
    End If;
  
    p_c_descal := lc_descal;
    p_c_accion := lc_accion;
  end;

  ----------------------------------------------------------
  procedure SP_CALI_CAJA(P_N_TIPDOC  IN NUMBER,
                         P_C_NUMDOC  IN VARCHAR2,
                         P_D_FECHA   IN DATE,
                         P_C_USUARIO IN VARCHAR2,
                         p_n_codseg  IN NUMBER,
                         P_N_CODCAl  OUT NUMBER,
                         P_C_DESCAL  OUT VARCHAR2) is
  
  begin
  
    P_N_CODCAl := 0;
    P_C_DESCAL := '';
  
    if p_n_codseg = 2 then
    
      begin
        select JAQY066CALF
          into P_N_CODCAl
          from (select JAQY066CALF
                  from JAQY066
                 where jaqy066paic = 604
                   and jaqy066tdoc = P_N_TIPDOC
                   and jaqy066tndoc = rpad(P_C_NUMDOC, 12, ' ')
                 order by jaqy066pano desc, jaqy066pmes desc)
         where rownum = 1;
      exception
        when no_data_found then
          P_N_CODCAl := 0;
      end;
    else
      pq_cr_segmentacion_aplic.sp_carga_data(pd_fecpro => P_D_FECHA, --fecha del dia
                                             pn_pai    => 604, --pais
                                             pn_tdo    => p_n_tipdoc, --tipo de documento
                                             pc_doc    => p_c_numdoc, --nro de documento
                                             pc_usr    => p_c_usuario); --usuario que esta ejecutando el paquete
      begin
        select jaqz086CALF
          into P_N_CODCAl
          from jaqz086_APL
         where jaqz086paic = 604
           and jaqz086tdoc = P_N_TIPDOC
           and jaqz086tndoc = rpad(P_C_NUMDOC, 12, ' ')
           and JAQZ086USR = P_C_USUARIO;
      exception
        when no_data_found then
          P_N_CODCAl := 0;
      end;
    end if;
  
    begin
      select c1.jaqy067ncal
        into P_C_DESCAL
        from jaqy067 c1
       where c1.jaqy067ccal = P_N_CODCAl;
    exception
      when no_data_found then
        If P_N_CODCAl = 0 then
          P_C_DESCAL := 'SIN CALIFICACION';
        Else
          P_C_DESCAL := 'NO DEFINIDA';
        End If;
    end;
  
  end;

  ----------------------------------------------------------

  procedure SP_SALDOS(P_C_NUMDOC IN VARCHAR2,
                      p_n_nument out number,
                      p_n_totdeu out number,
                      p_n_capend out number,
                      p_n_cappag out number,
                      p_n_salhip out number,
                      p_n_salcon out number,
                      p_n_salpym out number) is
  
  begin
    select --JAQY347PAI Pais,
    --JAQY347TDO Tipo_documento,
    --JAQY347NDO Numero_documento,
    --JAQY347FEC Fecha_proceso,
     nvl(JAQY347ETO, 0) Numero_entidades, -- JAQY347ENT
     nvl(JAQY347SDT, 0) Deuda_externa_total,
     --JAQY347PAT Patrimonio_Evaluacion,
     --JAQY347RCC Deuda_rcc_Pyme,
     --JAQY347BAN Deuda_Bantotal,
     nvl(JAQY347CEN, 0) Capacidad_endeudamiento,
     --JAQY347RES Resultado_Neto,
     --JAQY347CBA Cuota_Bantotal,
     nvl(JAQY347CPA, 0) Capacidad_pago,
     --JAQY347CAL Calificacion_ultimo_RCC,
     --JAQY347CAS Calificacion_6meses_RCC,
     --JAQY347SBS Codigo_SBS,
     nvl(JAQY347HIP, 0) Saldo_hipotecario,
     nvl(JAQY347CON, 0) Saldo_Consumo,
     nvl(JAQY347PYM, 0) Saldo_Pyme
      into p_n_nument,
           p_n_totdeu,
           p_n_capend,
           p_n_cappag,
           p_n_salhip,
           p_n_salcon,
           p_n_salpym
      from JAQY347
     where jaqy347ndo = P_C_NUMDOC;
  exception
    when others then
      p_n_nument := 0;
      p_n_totdeu := 0;
      p_n_capend := 0;
      p_n_cappag := 0;
      p_n_salhip := 0;
      p_n_salcon := 0;
      p_n_salpym := 0;
  end;

  ---------------------------------------------------------------------

  procedure SP_CREA_CUENTA(P_N_TIPDOC IN NUMBER,
                           P_C_NUMDOC IN VARCHAR2,
                           P_N_CTNRO  OUT NUMBER) is
  
  begin
  
    insert into jaqz311
      (jaqz311numdoc,
       jaqz311apepat,
       jaqz311apemat,
       jaqz311estciv,
       jaqz311fecnac,
       jaqz311sexo,
       jaqz311nacdep,
       jaqz311dirdep,
       jaqz311dirpro,
       jaqz311dirdis,
       jaqz311dirdes,
       jaqz311prinom,
       jaqz311segnom,
       jaqz311horreg,
       jaqz311fecreg,
       jaqz311fgcta,
       jaqz311fgcli)
      select trim(f4.pendoc),
             f4.penom,
             '',
             null,
             null,
             null,
             null,
             f5.sngc13dpto,
             f5.sngc13prov,
             f5.sngc13dist,
             f5.sngc13dir,
             null,
             null,
             to_char(sysdate, 'hh24:mi:ss'),
             trunc(sysdate),
             0,
             1
        from fsd001 f4, sngc13 f5
       where f4.pepais = f5.sngc13pais
         and f4.petdoc = f5.sngc13tdoc
         and f4.pendoc = f5.sngc13ndoc
         and f5.docod = 1
         and f5.sngc13est = 'H'
         and f4.pepais = 604
         and f4.petdoc = P_N_TIPDOC
         and f4.pendoc = rpad(P_C_NUMDOC, 12, ' ');
  
    pq_dinero_electronico.sp_procesar_migracion_cuentas;
  
    begin
      select ctnro
        into P_N_CTNRO
        from fsr008
       where pepais = 604
         and petdoc = P_N_TIPDOC
         and pendoc = rpad(P_C_NUMDOC, 12, ' ');
    exception
      when no_data_found then
        P_N_CTNRO := 0;
    end;
  
  end;

  ----------------------------------------------
  procedure SP_CL_RETORNA_DIRECCION(P_C_CODUSU   IN VARCHAR2,
                                    P_N_TIPDOC   IN NUMBER,
                                    P_C_NUMDOC   IN VARCHAR2,
                                    P_N_DOMCOD   IN NUMBER,
                                    P_D_RESDES_v OUT varchar2, -- OUT DATE,
                                    P_C_CASNEG   OUT VARCHAR2,
                                    P_C_VIVCOD   OUT VARCHAR2,
                                    P_N_COVIA1   OUT NUMBER,
                                    P_C_DEVIA1   OUT VARCHAR2,
                                    P_N_COVIA2   OUT NUMBER,
                                    P_C_DEVIA2   OUT VARCHAR2,
                                    P_N_COVIA3   OUT NUMBER,
                                    P_C_DEVIA3   OUT VARCHAR2,
                                    P_N_COVIA4   OUT NUMBER,
                                    P_C_DEVIA4   OUT VARCHAR2,
                                    P_N_COVIA5   OUT NUMBER,
                                    P_C_DEVIA5   OUT VARCHAR2,
                                    P_N_COVIA6   OUT NUMBER,
                                    P_C_DEVIA6   OUT VARCHAR2,
                                    P_N_CODPAI   OUT NUMBER,
                                    P_N_CODPTO   OUT NUMBER,
                                    P_N_COPROV   OUT NUMBER,
                                    P_N_CODIST   OUT NUMBER,
                                    P_C_REFERE   OUT VARCHAR2,
                                    P_C_DIRCON   OUT VARCHAR2,
                                    P_C_LATDIR   OUT VARCHAR2,
                                    P_C_LONDIR   OUT VARCHAR2,
                                    BL_TELEFON   OUT SYS_REFCURSOR,
                                    P_C_CODMSG   OUT VARCHAR2,
                                    P_C_DESMSG   OUT VARCHAR2) IS
  
    P_D_RESDES date;
  
    ln_pais number(3);
    ln_tipo number(2);
    lc_docu char(12);
    --lc_cartera char(1);
  
  BEGIN
  
    ln_pais := 604;
    ln_tipo := P_N_TIPDOC;
    lc_docu := P_C_NUMDOC;
  
    P_C_CODMSG := '';
    P_C_DESMSG := '';
  
    OPEN BL_TELEFON FOR
      select a.doordp     p_n_correl,
             b.sngc16ttel p_n_tiptel,
             a.dotelfp    p_c_telefon,
             a.dotlexp    p_c_anexo,
             a.dofaxp     p_c_coment
        from fsr005 a, sngc17 b
       where a.pepais = b.sngc17pais
         and a.petdoc = b.sngc17tdoc
         and a.pendoc = b.sngc17ndoc
         and a.docod = b.sngc17dcod
         and a.doordp = b.sngc17corr
         and a.pepais = ln_pais
         and a.petdoc = ln_tipo
         and a.pendoc = lc_docu
         and a.docod = P_N_DOMCOD;
  
    /*    begin
      select 'S'
        into lc_cartera
        from jaql964 j1
       where j1.jaql964pai = ln_pais
         and j1.jaql964tid = ln_tipo
         and j1.jaql964doc = lc_docu
         and j1.jaql964usu = P_C_CODUSU
         and rownum = 1;
    exception
      when no_data_found then
        P_C_CODMSG := '50';
        P_C_DESMSG := 'EL CLIENTE NO PERTENECE A LA CARTERA DEL ANALISTA';
        return;
      when others then
        P_C_CODMSG := '51';
        P_C_DESMSG := 'ERROR AL REVISAR LA CARTERA DEL ANALISTA';
        return;
    end;*/
  
    begin
      select SNGC13PDOC,
             SNGC12VIVC,
             SNGC01ID,
             SNGC02ID,
             SNGC03ID,
             SNGC04ID,
             SNGC05ID,
             SNGC06ID,
             SNGC13DSC1,
             SNGC13DSC2,
             SNGC13DSC3,
             SNGC13DSC4,
             SNGC13DSC5,
             SNGC13DSC6,
             SNGC13DPTO,
             SNGC13PROV,
             SNGC13DIST,
             SNGC13CNEG,
             nvl(trim(SNGC13REF), trim(SNGC13REF1)),
             SNGC13RDES,
             SNGC13DIR
        into P_N_CODPAI,
             P_C_VIVCOD,
             P_N_COVIA1,
             P_N_COVIA2,
             P_N_COVIA3,
             P_N_COVIA4,
             P_N_COVIA5,
             P_N_COVIA6,
             P_C_DEVIA1,
             P_C_DEVIA2,
             P_C_DEVIA3,
             P_C_DEVIA4,
             P_C_DEVIA5,
             P_C_DEVIA6,
             P_N_CODPTO,
             P_N_COPROV,
             P_N_CODIST,
             P_C_CASNEG,
             P_C_REFERE,
             P_D_RESDES,
             P_C_DIRCON
        from sngc13 a
       where a.sngc13pais = ln_pais
         and a.sngc13tdoc = ln_tipo
         and a.sngc13ndoc = lc_docu
         and a.docod = P_N_DOMCOD
         and a.sngc13est = 'H';
    Exception
      When others then
        P_C_CODMSG := '51';
        P_C_DESMSG := 'EL CLIENTE NO TIENE REGISTRADA DIRECCION';
        return;
    end;
  
    begin
      select a.sngc13ref, a.sngc13ref1
        into P_C_LATDIR, P_C_LONDIR
        from sngc13 a
       where a.sngc13pais = ln_pais
         and a.sngc13tdoc = ln_tipo
         and a.sngc13ndoc = lc_docu
         and a.docod = P_N_DOMCOD
         and a.sngc13est = 'I'
         and a.sngc13corr = 500;
    Exception
      When others then
        P_C_LATDIR := '';
        P_C_LONDIR := '';
    end;
  
    P_D_RESDES_v := to_char(P_D_RESDES, 'dd-mm-yyyy');
  end;

  ----------------------------------------------------
  procedure SP_CL_ACTUALIZA_DIRECCION(P_C_IDCONX   IN VARCHAR2,
                                      P_C_CODUSU   IN VARCHAR2,
                                      P_D_FECREG_v IN varchar2, -- IN DATE,
                                      P_N_TIPDOC   IN NUMBER,
                                      P_C_NUMDOC   IN VARCHAR2,
                                      P_C_TIPACT   IN VARCHAR2,
                                      P_N_DOMCOD   IN NUMBER,
                                      P_D_RESDES_v IN varchar2, -- IN DATE,
                                      P_C_CASNEG   IN VARCHAR2,
                                      P_C_VIVCOD   IN VARCHAR2,
                                      P_N_COVIA1   IN NUMBER,
                                      P_C_DEVIA1   IN VARCHAR2,
                                      P_N_COVIA2   IN NUMBER,
                                      P_C_DEVIA2   IN VARCHAR2,
                                      P_N_COVIA3   IN NUMBER,
                                      P_C_DEVIA3   IN VARCHAR2,
                                      P_N_COVIA4   IN NUMBER,
                                      P_C_DEVIA4   IN VARCHAR2,
                                      P_N_COVIA5   IN NUMBER,
                                      P_C_DEVIA5   IN VARCHAR2,
                                      P_N_COVIA6   IN NUMBER,
                                      P_C_DEVIA6   IN VARCHAR2,
                                      P_N_CODPAI   IN NUMBER,
                                      P_N_CODPTO   IN NUMBER,
                                      P_N_COPROV   IN NUMBER,
                                      P_N_CODIST   IN NUMBER,
                                      P_C_REFERE   IN VARCHAR2,
                                      P_C_LATORI   IN VARCHAR2,
                                      P_C_LONORI   IN VARCHAR2,
                                      P_C_LATDIR   IN VARCHAR2,
                                      P_C_LONDIR   IN VARCHAR2,
                                      P_C_CODMSG   OUT VARCHAR2,
                                      P_C_DESMSG   OUT VARCHAR2) IS
  
    P_D_FECREG date := to_date(P_D_FECREG_v, 'dd-mm-yyyy');
    P_D_RESDES date := to_date(P_D_RESDES_v, 'dd-mm-yyyy');
  
    lc_hora    char(8) := to_char(sysdate, 'hh24:mi:ss');
    ln_pais    number(3);
    ln_tipo    number(2);
    lc_docu    char(12);
    ln_corr    number;
    vsngc13dir varchar2(140);
    descvia    varchar2(35);
    credvig    char(1);
    tiporel    varchar2(7) := '';
  
  BEGIN
  
    ln_pais := 604;
    ln_tipo := P_N_TIPDOC;
    lc_docu := P_C_NUMDOC;
  
    P_C_CODMSG := '0';
    P_C_DESMSG := 'GRABACION SATISFACTORIA';
  
    -- verifica si tiene alg?n cr?dito o es aval
    credvig := FN_TIENE_CREDITO(ln_tipo, lc_docu);
  
    If P_C_TIPACT in ('D', 'A') then
      if credvig <> 'N' and P_N_DOMCOD = 1 then
        if credvig = 'A' then
          tiporel := 'aval';
        else
          tiporel := 'titular';
        end if;
        P_C_CODMSG := '02';
        P_C_DESMSG := 'Cliente tiene credito vigente (' || tiporel ||
                      '), no se puede actualizar direccion';
      else
        -- sacar ?ltimo correlativo de direcci?n
        begin
          select sngc13corr
            into ln_corr
            from sngc13
           where SNGC13PAIS = ln_pais
             and SNGC13TDOC = ln_tipo
             and SNGC13NDOC = lc_docu
             and DOCOD = P_N_DOMCOD
             and SNGC13EST = 'H'
             and sngc13corr <> 500;
        exception
          when no_data_found then
            begin
              select sngc13corr
                into ln_corr
                from sngc13
               where SNGC13PAIS = ln_pais
                 and SNGC13TDOC = ln_tipo
                 and SNGC13NDOC = lc_docu
                 and DOCOD = P_N_DOMCOD
                 and SNGC13EST = 'I'
                 and sngc13corr <> 500;
            exception
              when no_data_found then
                ln_corr := 0;
              when others then
                P_C_CODMSG := '01';
                P_C_DESMSG := 'Error al obtener la direcci?n actual';
            end;
          when others then
            P_C_CODMSG := '01';
            P_C_DESMSG := 'Error al obtener la direcci?n actual';
        end;
      
        -- inhabilitar ?ltima direcci?n
        if ln_corr > 0 then
          update sngc13
             set sngc13est = 'I'
           where SNGC13PAIS = ln_pais
             and SNGC13TDOC = ln_tipo
             and SNGC13NDOC = lc_docu
             and DOCOD = P_N_DOMCOD
             and sngc13corr = ln_corr
             and SNGC13EST = 'H'
             and sngc13corr <> 500;
        end if;
      
        begin
          select v1.sngc01dsc
            into descvia
            from sngc01 v1
           where v1.sngc01id = P_N_COVIA1;
        exception
          when no_data_found then
            select v2.sngc02dsc
              into descvia
              from sngc02 v2
             where v2.sngc02id = P_N_COVIA1
               and rownum = 1;
        end;
      
        vsngc13dir := trim(descvia) || ' ' || trim(P_C_DEVIA1);
      
        if P_N_COVIA2 <> 0 then
          begin
            select v1.sngc01dsc
              into descvia
              from sngc01 v1
             where v1.sngc01id = P_N_COVIA2;
          exception
            when no_data_found then
              select v2.sngc02dsc
                into descvia
                from sngc02 v2
               where v2.sngc02id = P_N_COVIA2
                 and rownum = 1;
          end;
        
          vsngc13dir := vsngc13dir || ' ' || trim(descvia) || ' ' ||
                        trim(P_C_DEVIA2);
        end if;
      
        if P_N_COVIA3 <> 0 then
          begin
            select v1.sngc01dsc
              into descvia
              from sngc01 v1
             where v1.sngc01id = P_N_COVIA3;
          exception
            when no_data_found then
              select v2.sngc02dsc
                into descvia
                from sngc02 v2
               where v2.sngc02id = P_N_COVIA3
                 and rownum = 1;
          end;
        
          vsngc13dir := vsngc13dir || ' ' || trim(descvia) || ' ' ||
                        trim(P_C_DEVIA3);
        end if;
      
        if P_N_COVIA4 <> 0 then
          begin
            select v1.sngc01dsc
              into descvia
              from sngc01 v1
             where v1.sngc01id = P_N_COVIA4;
          exception
            when no_data_found then
              select v2.sngc02dsc
                into descvia
                from sngc02 v2
               where v2.sngc02id = P_N_COVIA4
                 and rownum = 1;
          end;
        
          vsngc13dir := vsngc13dir || ' ' || trim(descvia) || ' ' ||
                        trim(P_C_DEVIA4);
        end if;
      
        if P_N_COVIA5 <> 0 then
          begin
            select v1.sngc01dsc
              into descvia
              from sngc01 v1
             where v1.sngc01id = P_N_COVIA5;
          exception
            when no_data_found then
              select v2.sngc02dsc
                into descvia
                from sngc02 v2
               where v2.sngc02id = P_N_COVIA5
                 and rownum = 1;
          end;
        
          vsngc13dir := vsngc13dir || ' ' || trim(descvia) || ' ' ||
                        trim(P_C_DEVIA5);
        end if;
      
        if P_N_COVIA6 <> 0 then
          begin
            select v1.sngc01dsc
              into descvia
              from sngc01 v1
             where v1.sngc01id = P_N_COVIA6;
          exception
            when no_data_found then
              select v2.sngc02dsc
                into descvia
                from sngc02 v2
               where v2.sngc02id = P_N_COVIA6
                 and rownum = 1;
          end;
        
          vsngc13dir := vsngc13dir || ' ' || trim(descvia) || ' ' ||
                        trim(P_C_DEVIA6);
        end if;
      
        begin
          insert into sngc13
            (SNGC13PAIS,
             SNGC13TDOC,
             SNGC13NDOC,
             DOCOD,
             SNGC13CORR,
             SNGC13PDOC,
             SNGC12VIVC,
             SNGC01ID,
             SNGC02ID,
             SNGC03ID,
             SNGC04ID,
             SNGC05ID,
             SNGC06ID,
             SNGC13DSC1,
             SNGC13DSC2,
             SNGC13DSC3,
             SNGC13DSC4,
             SNGC13DSC5,
             SNGC13DSC6,
             SNGC13UGEO,
             SNGC13DPTO,
             SNGC13PROV,
             SNGC13DIST,
             SNGC13CNEG,
             SNGC13REF,
             SNGC13REF1,
             SNGC13DIR,
             SNGC13RDES,
             SNGC13ARR,
             SNGC13ATEL,
             SNGC13FHAB,
             SNGC13EST,
             SNGC13DEST,
             SNGC13FDIR,
             SNGC13USER,
             SNGC13COL,
             SNGC13TAS)
          values
            (ln_pais,
             ln_tipo,
             lc_docu,
             P_N_DOMCOD,
             ln_corr + 1,
             P_N_CODPAI,
             P_C_VIVCOD,
             P_N_COVIA1,
             P_N_COVIA2,
             P_N_COVIA3,
             P_N_COVIA4,
             P_N_COVIA5,
             P_N_COVIA6,
             upper(P_C_DEVIA1),
             upper(P_C_DEVIA2),
             upper(P_C_DEVIA3),
             upper(P_C_DEVIA4),
             upper(P_C_DEVIA5),
             upper(P_C_DEVIA6),
             lpad(P_N_CODIST, 6, '0'),
             P_N_CODPTO,
             P_N_COPROV,
             P_N_CODIST,
             P_C_CASNEG,
             upper(P_C_REFERE),
             upper(substr(P_C_REFERE || ' / ' || vsngc13dir, 1, 200)),
             upper(vsngc13dir),
             P_D_RESDES,
             null,
             null,
             null,
             'H',
             2,
             P_D_FECREG,
             P_C_CODUSU,
             null,
             null);
        Exception
          when others then
            P_C_CODMSG := trim(to_char(sqlcode));
            P_C_DESMSG := trim(sqlerrm);
        end;
      end if;
    end if;
  
    if P_C_TIPACT in ('G', 'A') then
      -- actualizar geolocalizaci?n
      begin
        insert into sngc13
          (sngc13pais,
           sngc13tdoc,
           sngc13ndoc,
           docod,
           sngc13corr,
           sngc13ref,
           sngc13ref1,
           SNGC13FDIR,
           SNGC13USER,
           SNGC13EST)
        values
          (ln_pais,
           ln_tipo,
           lc_docu,
           P_N_DOMCOD,
           500,
           P_C_LATDIR,
           P_C_LONDIR,
           P_D_FECREG,
           P_C_CODUSU,
           'I');
      exception
        when dup_val_on_index then
          update sngc13
             set sngc13ref  = P_C_LATDIR,
                 sngc13ref1 = P_C_LONDIR,
                 SNGC13FDIR = P_D_FECREG,
                 SNGC13USER = P_C_CODUSU
           where SNGC13PAIS = ln_pais
             and SNGC13TDOC = ln_tipo
             and SNGC13NDOC = lc_docu
             and DOCOD = P_N_DOMCOD
             and SNGC13EST = 'I'
             and sngc13corr = 500;
      end;
    end if;
  
    if P_C_CASNEG = 'S' and P_N_DOMCOD = 1 and P_C_CODMSG = '0' then
      -- si el legal y es casa negocio
      begin
        -- Call the procedure
        pq_cr_oferta_comercial.sp_cl_actualiza_direccion(p_c_idconx   => p_c_idconx,
                                                         p_c_codusu   => p_c_codusu,
                                                         p_d_fecreg_v => p_d_fecreg_v,
                                                         p_n_tipdoc   => p_n_tipdoc,
                                                         p_c_numdoc   => p_c_numdoc,
                                                         p_c_tipact   => p_c_tipact,
                                                         p_n_domcod   => 3,
                                                         p_d_resdes_V => p_d_resdes_v,
                                                         p_c_casneg   => p_c_casneg,
                                                         p_c_vivcod   => p_c_vivcod,
                                                         p_n_covia1   => p_n_covia1,
                                                         p_c_devia1   => p_c_devia1,
                                                         p_n_covia2   => p_n_covia2,
                                                         p_c_devia2   => p_c_devia2,
                                                         p_n_covia3   => p_n_covia3,
                                                         p_c_devia3   => p_c_devia3,
                                                         p_n_covia4   => p_n_covia4,
                                                         p_c_devia4   => p_c_devia4,
                                                         p_n_covia5   => p_n_covia5,
                                                         p_c_devia5   => p_c_devia5,
                                                         p_n_covia6   => p_n_covia6,
                                                         p_c_devia6   => p_c_devia6,
                                                         p_n_codpai   => p_n_codpai,
                                                         p_n_codpto   => p_n_codpto,
                                                         p_n_coprov   => p_n_coprov,
                                                         p_n_codist   => p_n_codist,
                                                         p_c_refere   => p_c_refere,
                                                         p_c_latori   => p_c_latori,
                                                         p_c_lonori   => p_c_lonori,
                                                         p_c_latdir   => p_c_latdir,
                                                         p_c_londir   => p_c_londir,
                                                         p_c_codmsg   => p_c_codmsg,
                                                         p_c_desmsg   => p_c_desmsg);
      end;
    
    else
      if P_C_CODMSG = '0' then
        -- llena log
        insert into jaql730
        values
          (P_C_IDCONX,
           P_C_CODUSU,
           P_D_FECREG,
           lc_hora,
           ln_tipo,
           lc_docu,
           P_N_DOMCOD,
           P_C_TIPACT,
           P_C_LATORI,
           P_C_LONORI,
           P_C_LATDIR,
           P_C_LONDIR,
           '');
        commit;
      end if;
    end if;
  Exception
    when others then
      P_C_CODMSG := trim(to_char(sqlcode));
      P_C_DESMSG := trim(sqlerrm);
    
  END;
  ----------------------------------------------------
  procedure SP_CL_ACTUALIZA_TELEFONO(P_C_IDCONX   IN VARCHAR2,
                                     P_C_CODUSU   IN VARCHAR2,
                                     P_D_FECREG_v IN varchar2, -- IN DATE,
                                     P_N_TIPDOC   IN NUMBER,
                                     P_C_NUMDOC   IN VARCHAR2,
                                     P_C_TIPACT   IN VARCHAR2,
                                     P_N_DOMCOD   IN NUMBER,
                                     P_N_CORREL   IN NUMBER,
                                     P_N_TIPTEL   IN NUMBER,
                                     P_C_TELEFO   IN CHAR,
                                     P_C_ANEXO    IN CHAR,
                                     P_C_COMENT   IN CHAR,
                                     P_C_CODMSG   OUT VARCHAR2,
                                     P_C_DESMSG   OUT VARCHAR2) is
  
    P_D_FECREG date := to_date(P_D_FECREG_v, 'dd-mm-yyyy');
  
    lc_hora   char(8) := to_char(sysdate, 'hh24:mi:ss');
    ln_pais   number(3);
    ln_tipo   number(2);
    lc_docu   char(12);
    ln_correl number(2);
  
  begin
  
    ln_pais := 604;
    ln_tipo := P_N_TIPDOC;
    lc_docu := P_C_NUMDOC;
  
    P_C_CODMSG := '0';
    P_C_DESMSG := 'GRABACION SATISFACTORIA';
  
    case
      when P_C_TIPACT = 'D' then
        delete from fsr005 a
         where a.pepais = ln_pais
           and a.petdoc = ln_tipo
           and a.pendoc = lc_docu
           and a.docod = P_N_DOMCOD
           and a.doordp = P_N_CORREL;
      
        delete from sngc17 b
         where b.sngc17pais = ln_pais
           and b.sngc17tdoc = ln_tipo
           and b.sngc17ndoc = lc_docu
           and b.sngc17dcod = P_N_DOMCOD
           and b.sngc17corr = P_N_CORREL;
      
      when P_C_TIPACT = 'I' then
        begin
          select nvl(max(a.doordp), 0) + 1
            into ln_correl
            from fsr005 a
           where a.pepais = ln_pais
             and a.petdoc = ln_tipo
             and a.pendoc = lc_docu
             and a.docod = P_N_DOMCOD;
        exception
          when no_data_found then
            ln_correl := 1;
        end;
      
        insert into fsr005
          (pepais, petdoc, pendoc, docod, doordp, dotelfp, dotlexp, dofaxp)
        values
          (ln_pais,
           ln_tipo,
           lc_docu,
           P_N_DOMCOD,
           ln_correl,
           P_C_TELEFO,
           P_C_ANEXO,
           P_C_COMENT);
      
        insert into sngc17
          (sngc17pais,
           sngc17tdoc,
           sngc17ndoc,
           sngc17dcod,
           sngc17corr,
           sngc16ttel)
        values
          (ln_pais, ln_tipo, lc_docu, P_N_DOMCOD, ln_correl, P_N_TIPTEL);
      
      when P_C_TIPACT = 'U' then
        update fsr005 a
           set a.dotelfp = P_C_TELEFO,
               a.dotlexp = P_C_ANEXO,
               a.dofaxp  = P_C_COMENT
         where a.pepais = ln_pais
           and a.petdoc = ln_tipo
           and a.pendoc = lc_docu
           and a.docod = P_N_DOMCOD
           and a.doordp = P_N_CORREL;
      
        update sngc17 b
           set b.sngc16ttel = P_N_TIPTEL
         where b.sngc17pais = ln_pais
           and b.sngc17tdoc = ln_tipo
           and b.sngc17ndoc = lc_docu
           and b.sngc17dcod = P_N_DOMCOD
           and b.sngc17corr = P_N_CORREL;
    end case;
  
    if P_C_CODMSG = '0' then
      -- llena log
      insert into jaql730
      values
        (P_C_IDCONX,
         P_C_CODUSU,
         P_D_FECREG,
         lc_hora,
         ln_tipo,
         lc_docu,
         P_N_DOMCOD,
         '',
         to_char(P_N_CORREL),
         '',
         '',
         '',
         P_C_TIPACT);
      commit;
    end if;
  Exception
    when others then
      P_C_CODMSG := trim(to_char(sqlcode));
      P_C_DESMSG := trim(sqlerrm);
  end;

  ------------------------------------------------------------------

  procedure SP_CL_RETORNA_ACTIVIDAD(P_C_CODUSU   IN VARCHAR2,
                                    P_N_TIPDOC   IN NUMBER,
                                    P_C_NUMDOC   IN VARCHAR2,
                                    P_N_TIPACT   OUT NUMBER,
                                    P_N_ACTIVI   OUT NUMBER,
                                    P_N_CODOCU   OUT NUMBER,
                                    P_C_NOMEMP   OUT VARCHAR2,
                                    P_N_INGRESO  OUT NUMBER,
                                    P_D_FEFINE   OUT VARCHAR2, --DATE,
                                    P_D_FEFINI   OUT VARCHAR2, --DATE,
                                    P_N_CODUBI   OUT NUMBER,
                                    P_N_VCOD     OUT NUMBER,
                                    P_C_RUTE     OUT VARCHAR2,
                                    P_N_SEGMENTO OUT NUMBER,
                                    P_C_CODMSG   OUT VARCHAR2,
                                    P_C_MSG      OUT VARCHAR2) is
    /* ln_tipo    number(2);
    lc_docu    char(12);
    lc_cartera char(1); */
    LC_TIPO CHAR(1);
    -- LN_INGRESO NUMBER(17,2):= 0;
    documento1 char(12);
  
  BEGIN
  
    documento1 := trim(P_C_NUMDOC);
  
    /*begin
      select 'S'
        into lc_cartera
        from jaql964 j1
       where j1.jaql964pai = 604
         and j1.jaql964tid = P_N_TIPDOC
         and j1.jaql964doc = documento1
         and j1.jaql964usu = P_C_CODUSU
         and rownum = 1;
    exception
      when no_data_found then
        P_C_CODMSG := '50';
        P_C_MSG := 'EL CLIENTE NO PERTENECE A LA CARTERA DEL ANALISTA';
        return;
      when others then
        P_C_CODMSG := '51';
        P_C_MSG := 'ERROR AL REVISAR LA CARTERA DEL ANALISTA';
        return;
    end;*/
    Begin
      SELECT A.PETIPO,
             NVL((SELECT PexIng
                   FROM FSE101
                  Where Pepais = A.PEPAIS
                    AND Petdoc = A.PETDOC
                    AND Pendoc = A.PENDOC
                    AND PexIng <> 0),
                 0)
        INTO LC_TIPO, P_N_INGRESO
        FROM FSD001 A
       WHERE A.PEPAIS = 604
         AND A.PETDOC = P_N_TIPDOC
         AND A.PENDOC = documento1; --P_C_NUMDOC;---'15151515'
      P_C_CODMSG := '0';
      P_C_MSG    := 'CONSULTA SATISFACTORIA';
    Exception
      when no_data_found then
        P_C_CODMSG := '61';
        P_C_MSG    := 'SIN REGISTRO EN EL SISTEMA';
    END;
    IF P_C_CODMSG = '0' THEN
      ----IS NULL THEN
      IF LC_TIPO = 'F' THEN
        --PER NATURAL
        select SNGC60Tipa, --cod tipo actividad
               SNGC60Acte, --cod actividad
               SNGC60Ocup, --cod ocupacion
               SNGC60Nome, --
               TO_CHAR(SNGC60Fine, 'DD-MM-YYYY'), --fecha ine       
               TO_CHAR(SNGC60Fini, 'DD-MM-YYYY'), --fecha ini
               SNGC60Ubic, --codubic
               SNGC60Vcod, --
               SNGC60Rute, --
               (SELECT SEGCOD FROM SNGC07 WHERE SNGC07COD = SNGC60Ocup)
          into P_N_TIPACT,
               P_N_ACTIVI,
               P_N_CODOCU,
               P_C_NOMEMP,
               P_D_FEFINE,
               P_D_FEFINI,
               P_N_CODUBI,
               P_N_VCOD,
               P_C_RUTE,
               P_N_SEGMENTO
          from sngc60
         Where SNGC60Pais = 604
           and SNGC60Tdoc = P_N_TIPDOC
           and SNGC60Ndoc = documento1
           and SNGC60Corr = 0;
      ELSE
        -- PER JURIDICA
        select (SELECT sngc11TpA2
                  FROM sngc11
                 Where sngc11Pais = B.PJPAIS
                   AND sngc11Tdoc = B.PJTDOC
                   AND sngc11Ndoc = B.PJNDOC),
               (SELECT ExpNIns
                  FROM fse001
                 Where D511Pais = B.PJPAIS
                   AND D511Tdoc = B.PJTDOC
                   AND D511Ndoc = B.PJNDOC),
               0,
               B.PJRAZS,
               '01-01-0001',
               '01-01-0001',
               0,
               0,
               0,
               B.PJSEGMENTO
          INTO P_N_TIPACT,
               P_N_ACTIVI,
               P_N_CODOCU,
               P_C_NOMEMP,
               P_D_FEFINE,
               P_D_FEFINI,
               P_N_CODUBI,
               P_N_VCOD,
               P_C_RUTE,
               P_N_SEGMENTO
          from FSD003 B
         Where B.Pjpais = 604
           and B.Pjtdoc = P_N_TIPDOC
           and B.Pjndoc = documento1; ---P_C_NUMDOC;
      END IF;
    END IF;
  END;

  ---------------------------------------------------------

  procedure SP_CL_ACTUALIZA_ACTIVIDAD(P_C_CODUSU   IN VARCHAR2,
                                      P_N_TIPDOC   IN NUMBER,
                                      P_C_NUMDOC   IN VARCHAR2,
                                      P_N_TIPACT   IN NUMBER,
                                      P_N_ACTIVI   IN NUMBER,
                                      P_N_CODOCU   IN NUMBER,
                                      P_C_NOMEMP   IN VARCHAR2,
                                      P_N_INGRESO  IN NUMBER,
                                      P_D_FEFINE   IN varchar2, --DATE,
                                      P_D_FEFINI   IN varchar2, ---DATE,
                                      P_N_CODUBI   IN NUMBER,
                                      P_N_VCOD     IN NUMBER,
                                      P_C_RUTE     IN VARCHAR2,
                                      P_N_SEGMENTO IN NUMBER,
                                      P_C_CODMSG   OUT VARCHAR2,
                                      P_C_MSG      OUT VARCHAR2) IS
    cursor cuentas(doc in char) is
      select Ctnro
        from fsr008
       Where Pepais = 604
         and Petdoc = P_N_TIPDOC
         and Pendoc = doc
         and Cttfir = 'T';
  
    documento1 char(12);
    lc_tipo    char(1);
    FECHA      DATE;
    VERIFICA   NUMBER;
  BEGIN
  
    documento1 := P_C_NUMDOC;
  
    SELECT PGFAPE INTO FECHA FROM FST017 WHERE PGCOD = 1;
  
    P_C_CODMSG := '0';
    P_C_MSG    := 'GRABACION SATISFACTORIA';
  
    Begin
    
      select petipo
        into lc_tipo
        from fsd001
       where pepais = 604
         and petdoc = P_N_TIPDOC
         and pendoc = documento1;
    exception
      when no_data_found then
        lc_tipo := null;
    end;
  
    if P_N_INGRESO <> 0 then
      Begin
        insert into fse101
          (pepais, petdoc, pendoc, pexfecha, pexing)
        values
          (604,
           P_N_TIPDOC,
           documento1,
           to_date('01/01/0001', 'dd/mm/yyyy'),
           P_N_INGRESO);
        insert into fse101
          (pepais, petdoc, pendoc, pexfecha, pexing)
        values
          (604,
           P_N_TIPDOC,
           documento1,
           to_date('01/01/0001', 'dd/mm/yyyy'),
           0);
      exception
        when dup_val_on_index then
          update fse101
             set pexing = P_N_INGRESO
           where pepais = 604
             and petdoc = P_N_TIPDOC
             and pendoc = documento1
             AND pexfecha = to_date('01/01/0001', 'dd/mm/yyyy');
        
      end;
      IF LC_TIPO = 'F' THEN
        Begin
          select 1
            into vERIFICA
            from sngc60
           Where SNGC60Pais = 604
             and SNGC60Tdoc = P_N_TIPDOC
             and SNGC60Ndoc = documento1;
        
          For cta in cuentas(documento1) loop
            update fsd008
               set Ctsegm = P_N_SEGMENTO
             Where PgCod = 1
               and Ctnro = cta.ctnro;
          end loop;
        
          if P_N_CODOCU = 1 THEN
            update sngc60
               set SNGC60Ocup = P_N_CODOCU,
                   SNGC60Vcod = P_N_VCOD,
                   SNGC60Rute = P_C_RUTE,
                   SNGC60Rzso = P_C_NOMEMP, ---&NomEmp
                   SNGC60Nome = P_C_NOMEMP,
                   SNGC60Tipa = P_N_TIPACT,
                   SNGC60Acte = P_N_ACTIVI,
                   SNGC60Aux1 = P_C_CODUSU,
                   SNGC60Aux2 = FECHA,
                   SNGC60Fine = to_date(P_D_FEFINE, 'dd/mm/yyyy'),
                   SNGC60Fini = TO_DATE('01/01/0001', 'DD/MM/YYYY'),
                   SNGC60Ubic = P_N_CODUBI
             WHERE SNGC60Pais = 604
               and SNGC60Tdoc = P_N_TIPDOC
               and SNGC60Ndoc = documento1;
          elsif P_N_CODOCU = 2 THEN
            update sngc60
               set SNGC60Ocup = P_N_CODOCU,
                   SNGC60Vcod = 0,
                   SNGC60Rute = P_C_RUTE,
                   SNGC60Rzso = P_C_NOMEMP, ---&NomEmp
                   SNGC60Nome = P_C_NOMEMP,
                   SNGC60Tipa = P_N_TIPACT,
                   SNGC60Acte = P_N_ACTIVI,
                   SNGC60Aux1 = P_C_CODUSU,
                   SNGC60Aux2 = FECHA,
                   SNGC60Fine = to_date(P_D_FEFINE, 'dd/mm/yyyy'),
                   SNGC60Fini = TO_DATE('01/01/0001', 'DD/MM/YYYY'),
                   SNGC60Ubic = P_N_CODUBI
             WHERE SNGC60Pais = 604
               and SNGC60Tdoc = P_N_TIPDOC
               and SNGC60Ndoc = documento1;
          elsif P_N_CODOCU in (4, 5, 6) THEN
            update sngc60
               set SNGC60Ocup = P_N_CODOCU,
                   SNGC60Vcod = 0,
                   SNGC60Rute = '',
                   SNGC60Rzso = '',
                   SNGC60Nome = P_C_NOMEMP,
                   SNGC60Tipa = P_N_TIPACT,
                   SNGC60Acte = P_N_ACTIVI,
                   SNGC60Aux1 = P_C_CODUSU,
                   SNGC60Aux2 = FECHA,
                   SNGC60Fine = TO_DATE('01/01/0001', 'DD/MM/YYYY'),
                   SNGC60Fini = to_date(P_D_FEFINI, 'dd/mm/yyyy'),
                   SNGC60Ubic = P_N_CODUBI
             WHERE SNGC60Pais = 604
               and SNGC60Tdoc = P_N_TIPDOC
               and SNGC60Ndoc = documento1;
          elsif P_N_CODOCU in (3, 7, 8) THEN
            update sngc60
               set SNGC60Ocup = P_N_CODOCU,
                   SNGC60Vcod = 0,
                   SNGC60Rute = '',
                   SNGC60Rzso = '',
                   SNGC60Nome = '',
                   SNGC60Tipa = P_N_TIPACT,
                   SNGC60Acte = P_N_ACTIVI,
                   SNGC60Aux1 = P_C_CODUSU,
                   SNGC60Aux2 = FECHA,
                   SNGC60Fine = TO_DATE('01/01/0001', 'DD/MM/YYYY'),
                   SNGC60Fini = TO_DATE('01/01/0001', 'DD/MM/YYYY'),
                   SNGC60Ubic = ''
             WHERE SNGC60Pais = 604
               and SNGC60Tdoc = P_N_TIPDOC
               and SNGC60Ndoc = documento1;
          end if;
        Exception
          when no_data_found then
            P_C_CODMSG := '62';
            P_C_MSG    := 'LOS DATOS ESTAN INCOMPLETOS FAVOR ACERCARSE A PLATAFORMA';
        End;
      ELSE
        UPDATE sngc11
           SET sngc11TpA2 = P_N_TIPACT,
               sngc11Dat2 = FECHA,
               sngc11NEst = P_C_NOMEMP
         Where sngc11Pais = 604
           AND sngc11Tdoc = P_N_TIPDOC
           AND sngc11Ndoc = documento1;
      
        UPDATE fse001
           SET ExpNIns = P_N_ACTIVI, ExpFIns = FECHA
         Where D511Pais = 604
           and D511Tdoc = P_N_TIPDOC
           and D511Ndoc = documento1;
      
        update fsd003
           set PjSegmento = P_N_SEGMENTO
         Where Pjpais = 604
           and Pjtdoc = P_N_TIPDOC
           and Pjndoc = documento1;
      END IF;
    END IF;
    COMMIT;
  
  END;

  ---------------------------------------------------------

  function FN_TIENE_CREDITO(P_N_TIPDOC IN NUMBER, P_C_NUMDOC IN VARCHAR2)
    return CHAR is
  
    lc_relaci char(1) := 'N';
  
    ln_pais number(3);
    ln_tipo number(2);
    lc_docu char(12);
  
  begin
  
    ln_pais := 604;
    ln_tipo := P_N_TIPDOC;
    lc_docu := P_C_NUMDOC;
    begin
      select 'T'
        into lc_relaci
        from fsr008 b,
             (select *
                from fst111
              union all
              select 50, 117
                from dual
              union all
              select 50, 141
                from dual
              union all
              select 50, 65
                from dual) c,
             fsd010 g
       where g.pgcod = b.pgcod
         and g.aocta = b.ctnro
         and c.dscod = 50
         and g.aostat not in (99, 27)
         and g.aomod = c.modulo
         and b.pepais = ln_pais
         and b.petdoc = ln_tipo
         and b.pendoc = lc_docu
         and b.ttcod = 1
         and rownum = 1;
    exception
      when no_data_found then
        begin
          select 'A'
            into lc_relaci
            from sng003 a,
                 fsr008 b,
                 xwf700 d,
                 (select *
                    from fst111
                  union all
                  select 50, 117
                    from dual
                  union all
                  select 50, 141
                    from dual
                  union all
                  select 50, 65
                    from dual) c,
                 fsd010 g
           where b.pepais = ln_pais
             and b.petdoc = ln_tipo
             and b.pendoc = lc_docu
             and b.ttcod = 1
             and b.ctnro = a.sng003cta
             and a.sng001inst = d.xwfprcins
             and d.xwfcar3 = '1'
             and g.pgcod = d.xwfempresa
             and g.aocta = d.xwfcuenta
             and g.aomod = d.xwfmodulo
             and g.aooper = d.xwfoperacion
             and g.aotope = d.xwftipope
             and c.dscod = 50
             and g.aostat not in (99, 27)
             and g.aomod = c.modulo
             and rownum = 1;
        exception
          when no_data_found then
            lc_relaci := 'N';
        end;
    end;
    return lc_relaci;
  end;
  -----------------------------------------------------------

  procedure SP_CL_RETORNA_EMAIL(P_C_CODUSU IN VARCHAR2,
                                P_N_TIPDOC IN NUMBER,
                                P_C_NUMDOC IN VARCHAR2,
                                BL_EMAIL   OUT SYS_REFCURSOR,
                                P_C_CODMSG OUT VARCHAR2,
                                P_C_DESMSG OUT VARCHAR2) IS
  
    ln_pais number(3);
    ln_tipo number(2);
    lc_docu char(12);
  
  begin
  
    ln_pais := 604;
    ln_tipo := P_N_TIPDOC;
    lc_docu := P_C_NUMDOC;
  
    P_C_CODMSG := '0';
    P_C_DESMSG := '';
  
    OPEN BL_EMAIL FOR
      select PEXREN, SubStr(Pextxt,1,(Instr(Pextxt,'\')-1)) mail -- replace(pextxt, '\', '') mail
        from fsx001
       Where pepais = ln_pais
         and petdoc = ln_tipo
         and pendoc = lc_docu
         and Txcod = 0;
  end;
  ----------------------------------------------------
  procedure SP_CL_ACTUALIZA_EMAIL(P_C_IDCONX   IN VARCHAR2,
                                  P_C_CODUSU   IN VARCHAR2,
                                  P_D_FECREG_v IN varchar2, -- IN DATE,
                                  P_N_TIPDOC   IN NUMBER,
                                  P_C_NUMDOC   IN VARCHAR2,
                                  P_C_TIPACT   IN VARCHAR2,
                                  P_N_CORREL   IN NUMBER,
                                  P_C_EMAIL    IN CHAR,
                                  P_C_CODMSG   OUT VARCHAR2,
                                  P_C_DESMSG   OUT VARCHAR2) is
  
    P_D_FECREG date := to_date(P_D_FECREG_v, 'dd-mm-yyyy');
  
    lc_hora   char(8) := to_char(sysdate, 'hh24:mi:ss');
    ln_pais   number(3);
    ln_tipo   number(2);
    lc_docu   char(12);
    ln_correl number(2);
    lc_tipo   varchar2(20);
  
  begin
  
    ln_pais := 604;
    ln_tipo := P_N_TIPDOC;
    lc_docu := P_C_NUMDOC;
  
    P_C_CODMSG := '0';
    P_C_DESMSG := 'GRABACION SATISFACTORIA';
  
    if P_N_CORREL = 99 then
      lc_tipo := '\AM Correspondencia';
    else
      lc_tipo := '\Act. Misti';
    end if;
  
    case
      when P_C_TIPACT = 'D' then
        delete from fsx001 x
         where x.pepais = ln_pais
           and x.petdoc = ln_tipo
           and x.pendoc = lc_docu
           and x.txcod = 0
           and x.pexren = P_N_CORREL;
      
      when P_C_TIPACT = 'I' then
        if P_N_CORREL = 99 then
          ln_correl := 99;
        else
          begin
            select nvl(max(x.pexren),0) + 1
              into ln_correl
              from fsx001 x
             where x.pepais = ln_pais
               and x.petdoc = ln_tipo
               and x.pendoc = lc_docu
               and x.txcod = 0
               and x.pexren <> 99;
          exception
            when no_data_found then
              ln_correl := 1;
          end;
          
          insert into fsx001
          values
            (ln_pais,
             ln_tipo,
             lc_docu,
             0,
             ln_correl,
             trim(P_C_EMAIL) || lc_tipo,
             P_C_CODUSU,
             P_D_FECREG);
        end if;
      
      when P_C_TIPACT = 'U' then
        update fsx001 x
           set x.Pextxt = trim(P_C_EMAIL) || lc_tipo
         where x.pepais = ln_pais
           and x.petdoc = ln_tipo
           and x.pendoc = lc_docu
           and x.txcod = 0
           and x.pexren = P_N_CORREL;
    end case;
  
    if P_C_CODMSG = '0' then
      -- llena log
      insert into jaql730
      values
        (P_C_IDCONX,
         P_C_CODUSU,
         P_D_FECREG,
         lc_hora,
         ln_tipo,
         lc_docu,
         0,
         '',
         to_char(p_n_correl),
         '',
         '',
         '',
         P_C_TIPACT);
      commit;
    end if;
  Exception
    when others then
      P_C_CODMSG := trim(to_char(sqlcode));
      P_C_DESMSG := trim(sqlerrm);
  end;
  -------------------------------------------------------------

  procedure SP_OBTENER_CUENTAS(BL_DATOS   IN OUT SYS_REFCURSOR,
                               P_N_TIPDOC IN NUMBER,
                               P_C_NUMDOC IN VARCHAR2) IS
  begin
    open BL_DATOS for
      select a1.ctnro n_numcta,
             (select tdnom from fst014 where tdocum = a1.petdoc) c_tipdoc,
             a1.pendoc c_numdoc,
             a2.penom c_nomcli
        from fsr008 a1, fsd001 a2
       where a1.pepais = a2.pepais
         and a1.petdoc = a2.petdoc
         and a1.pendoc = a2.pendoc
         and a1.pepais = 604
         and a1.petdoc = P_N_TIPDOC
         and a1.pendoc = rpad(P_C_NUMDOC, 12, ' ');
  
  exception
    when others then
      null;
  end sp_obtener_cuentas;

end PQ_CR_OFERTA_COMERCIAL;
/

