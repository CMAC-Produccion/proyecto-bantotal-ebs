CREATE OR REPLACE PACKAGE pq_interfaz_etran is
  procedure SP_INTERFAZ_ETRAN_PROC(N_Se115cd in number,
                                   N_Se115su in number,
                                   N_Se115md in number,
                                   N_Se115tr in number,
                                   N_Se115re in number,
                                   N_Se115or in number,
                                   N_Se115fc in date,
                                   N_Exito   OUT varchar2);

  procedure SP_CLIENTE_CMAC(ln_pepais IN number,
                            ln_petdoc IN number,
                            ln_pendoc in varchar2,
                            cli_cmac  OUT varchar2);

  procedure SP_TIP_CAMBIO(ln_Se115cd  IN number,
                          ln_Se115su  IN number,
                          ln_Se115md  IN number,
                          ln_Se115tr  in number,
                          ln_Se115re  in number,
                          tipo_cambio OUT numeric,
                          Moneda      out number);

  procedure SP_ITF(N_Se115cd IN number,
                   N_Se115su IN number,
                   N_Se115md IN number,
                   N_Se115tr in number,
                   N_Se115re in number,
                   N_Itf     OUT numeric);

  function tipo_doc(ln_tp1cod1  in number,
                    ln_tp1corr1 in number,
                    ln_Tp1corr2 in number) return varchar2;
end pq_interfaz_etran;
/

CREATE OR REPLACE PACKAGE BODY pq_interfaz_etran is
/* ************************************************************************************************************
    -- Nombre                     : PQ_INTERFAZ_ETRAN
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 22/12/2023
    -- Autor de la Modificación   : Hlaqui
    -- Descripción de Modificación: Se guarda el numero de operaciones para extorno
 **************************************************************************************************************/

  procedure SP_INTERFAZ_ETRAN_PROC(N_Se115cd in number,
                                   N_Se115su in number,
                                   N_Se115md in number,
                                   N_Se115tr in number,
                                   N_Se115re in number,
                                   N_Se115or in number,
                                   N_Se115fc in date,
                                   N_Exito   OUT varchar2) is
                                   
                                   

    cursor tranfer is
      Select *
        from FSE115
       Where Se115su = N_Se115su
         and Se115md = N_Se115md
         and Se115tr = N_Se115tr
         and Se115re = N_Se115re
         and Se115fc = N_Se115fc;
    --and Se115or   = N_Se115or;  
    --and Se115fc   = N_Se115fc;
  
    cursor operacion is
      Select *
        from fsd015
       Where Pgcod = N_Se115cd
         and Itsuc = N_Se115su
         and Itmod = N_Se115md
         and Ittran = N_Se115tr
         and Itnrel = N_Se115re
         and Itfcon = N_Se115fc;
  
    cursor detalle is
      Select *
        from fsd016
       Where Pgcod = N_Se115cd
         and Itsuc = N_Se115su
         and Itmod = N_Se115md
         and Ittran = N_Se115tr
         and Itnrel = N_Se115re
         and Itord = 94;
  
    cursor comisiones is
      Select *
        from fsd016
       Where Pgcod = N_Se115cd
         and Itsuc = N_Se115su
         and Itmod = N_Se115md
         and Ittran = N_Se115tr
         and Itnrel = N_Se115re
         and Itord in (43, 44);
  
    P_C_CLICMA varchar2(1);
    P_C_CLIBEN varchar2(1);
    P_C_TIPCAM numeric(10, 2);
    P_C_Moneda number(3);
    P_C_Itf    numeric(10, 2);
    p_c_coderr varchar2(10);
    p_c_msgerr varchar2(200);
    p_c_numope varchar2(35);
    P_C_USER   varchar2(10);
    P_C_HORA   varchar2(8);
    P_C_CAJA   number(3);
    P_C_TDORI  varchar2(30);
    P_C_TDBEN  varchar2(30);
  
    comi_clie number(17, 2);
    mtoitf    number(17, 2);
    ln_tiprem number(1);
  
    formapago number(1);
    ConfAbo   number(1);
    
    moneda_trf number;
    moneda_ori number;
    
    canal char(2);
  begin
    N_Exito := 'X';
    p_c_coderr := '00';
    p_c_msgerr := null;
    -- P_C_Itf := 0.05;
  
    for i in operacion loop
      P_C_USER := i.ituing;
      P_C_HORA := i.ithora;
      P_C_CAJA := i.itcaja;
    end loop;
  
    P_C_Itf := 0;
    for i in detalle loop
      P_C_Itf := i.itimp1;
    end loop;
  
    comi_clie := 0;
    for i in comisiones loop
      comi_clie := i.itimp1;
    end loop;
  
    for i in tranfer loop
      -- Un solo registro con todos los datos de la FSE115
      -- Llamada al proceso que graba en la tabla de transferencias
      SP_CLIENTE_CMAC(i.se115paori, i.se115tdori, i.se115ndori, P_C_CLICMA);
      --SP_CLIENTE_CMAC(trim(i.se115paben), trim(i.se115tdben), trim(i.se115ndben),P_C_CLIBEN);
      SP_TIP_CAMBIO(i.se115cd,
                    i.se115su,
                    i.se115md,
                    i.se115tr,
                    i.se115re,
                    P_C_TIPCAM,
                    P_C_Moneda);
      --SP_ITF(i.se115cd,i.se115su,i.se115md,i.se115tr,i.se115re,P_C_Itf);
    
      If P_C_Moneda = 0 then
        P_C_Moneda := 1;
      Else
        P_C_Moneda := 2;
      End if;
    
/*      If i.se115tr = 30 then
        P_C_CLIBEN := 'M';
      Else
        P_C_CLIBEN := 'O';
      End if;*/
      
      P_C_CLIBEN := i.se115clasi;
    
      P_C_TDORI := tipo_doc(159, 105, i.se115tdori);
      P_C_TDBEN := tipo_doc(159, 105, i.se115tdben);
    
      If i.se115tipo = 221 then
        ln_tiprem := 4;
      Else
        ln_tiprem := null;
      End If;
    
      If i.se115imp = 0 then
        formapago := 4;
      Else
        formapago := 2;
      End if;
    
      ConfAbo := i.se115ax3;
    
      if i.se115mda = 0 then
        moneda_ori := 1;
      else
        moneda_ori := 2;
      end if;
    
    
      if i.se115mdaco = 0 then
        moneda_trf := 1;
      else
        moneda_trf := 2;
      end if;    
      
      If i.se115md = 18 then
         canal := '01';
      Else
         canal := '02';
      end if;
              
      begin
      
        transfintbanpr.trf_sp003(VTPOTRANSF            => i.se115tipo, -- tipo de transaccion cce
                                 VFCH_REG              => to_char(trunc(sysdate),'dd/mm/yyyy')/*to_char(i.se115fc,
                                                                  'dd/mm/yyyy')*/, -- fec. registro de la transaccion
                                 VHORA_REG             => to_char(sysdate,'HH24:mi:ss')/*P_C_HORA*/, -- hora de registro de la transaccion
                                 VUSU_REG              => P_C_USER, -- usuario que registro la transaccion
                                 VCANAL                => canal, -- canal de origen de la transaccion
                                 VFORMAPAGO            => formapago, -- forma de pago
                                 VCAJA                 => P_C_CAJA, -- SUBSTR(P_C_CVERTR, 1, 4), -- ventanilla donde se realizo la transaccion
                                 VPROD_ORI             => i.se115mod, -- codigo de producto de origen de la transaccion
                                 VTPO_PROD             => '1', -- tipo de producto pasivo o activo
                                 VAGE_ORI              => lpad(i.se115bsuor,
                                                               3,
                                                               0), -- codigo de la agencia de origen de la transaccion
                                 VFLAGCLI              => P_C_CLICMA, -- es o no cliente CMAC
                                 VTIP_PLAZA            => i.se115crit, -- tipo de plaza
                                 VCONFABON             => ConfAbo, -- confirmar abono
                                 VTPODOC_ORI           => to_number(P_C_TDORI), --i.se115tdori, -- tipo de documento de origen
                                 VNRODOC_ORI           => nvl(trim(i.se115ndori),
                                                              ''), -- numero de documento de identidad de origen
                                 VNOM_ORI              => nvl(trim(i.se115nomor),
                                                              ''), -- nombre la persona originante de la transaccion
                                 VDIR_ORI              => nvl(trim(i.se115diror),
                                                              ''), -- direccion del originante de la transaccion
                                 VARTELEF_ORI          => null, -- codigo de area del telefono originante
                                 -- WCRW Solo enviar numeros
                                 VNRTELEF_ORI          => nvl(REGEXP_REPLACE(i.se115telbe,'\D'),'000000'), -- nvl(i.se115telbe,'000000'), telefono del originante
                                 VCTA_ORI              => i.se115cta, -- numero de la cuenta donde se hizo el cargo de la transferencia
                                 VTARJ_ORI             => null, -- este campo es solo cuando es pago de creditos
                                 VCCI_ORI              => i.se115ccior, -- cci origen
                                 VMON_ORI              => moneda_ori, -- codigo de moneda de la cuenta
                                 VMTO_ORI              => i.se115imp, -- monto de la transaccion convertido a la moneda de origen de la cuenta
                                 VITF_ORI              => P_C_Itf, -- determinar el porcentaje del ift
                                 VCODTARI_INT          => i.se115codt, -- codigo de tarifa interbancario
                                 VCOMI_CLI_ORI         => comi_clie, -- importe de comision de cara al cliente tipo moneda origen
                                 VTC                   => P_C_TIPCAM, -- tipo de cambio aplicado si moneda origen != moneda destino
                                 VCOMI_INT_TRANSF      => i.se115impco, -- importe de la comision interbancaria
                                 VCOMI_CLI_TRANSF      => 0, --comi_clie, -- importe de la comision de cara al cliente
                                 VMTO_TRANSF           => i.se115imp, -- monto de la transferencia a enviar a la CCE
                                 VMON_TRANSF           => moneda_trf, -- moneda en que se envia la transferencia a la CCE
                                 VITF_TRANSF           => P_C_Itf, -- itf de la transferencia
                                 VCCI_DES              => i.se115ccids, -- cci destino
                                 VCTA_DES              => null, -- ?
                                 VTARJ_DES             => null, -- numero de tarjeta de credito destino, uso futuro.
                                 VBCO_DES              => lpad(to_char(i.se115bcods),
                                                               3,
                                                               '0'), -- codigo de banco destino
                                 VAGE_DES              => lpad(i.se115bsuds,
                                                               3,
                                                               0), -- agencia de destino
                                 VMTITULAR             => P_C_CLIBEN, -- si es o no titular de la cuenta
                                 VTPODOC_BEF           => P_C_TDBEN, --i.se115tdben, -- tipo de documento del beneficiario
                                 VNRODOC_BEF           => trim(i.se115ndben), -- numero del documento del beneficiario
                                 VNOM_BEF              => nvl(trim(i.se115nombe),
                                                              ''), -- nombre completo del beneficiario
                                 VDIR_BEF              => nvl(trim(i.se115dirbe),
                                                              ''), -- direccion del beneficiario
                                 VARTELEF_BEF          => null, -- nvl(P_C_CODATE, '00'), -- codigo de area del telefono del beneficiario
                                 -- WCRW solo enviar numeros
                                 VNRTELEF_BEF          => trim(nvl(REGEXP_REPLACE(i.se115telbe,'\D'),'000000')), -- nvl(i.se115telbe,'000000'),-- nvl(P_C_TELBEN, '000000'), -- telefono del beneficiario
                                 VREFERENCIA           => nvl(trim(i.se115ref),
                                                              ''), -- lc_refmod, --P_C_REFTRA, -- referencia de la transaccion
                                 VPERIODOANIO          => null, -- p_c_anoper,
                                 VPERIODOMES           => null, -- p_c_mesper,
                                 VSECUENCIATXNMULTIPLE => null, -- p_c_codlot,
                                 VTIPOPAGOHABERES      => ln_tiprem, -- P_N_TIPREM,
                                 VMTO_SUELDO_BRUTO     => null, -- P_C_NTARDE,
                                 -- PARAMETROS OUT
                                 vcodrpt    => p_c_coderr,
                                 vdescrpt   => p_c_msgerr,
                                 vid_numope => p_c_numope);
      
      --Hlaqui 22/12/2023 - Se guarda el numero de operaciones
      insert into FSX015 (PGCOD, HCMOD, HSUCOR, HTRAN, HNREL, HFCON, TXCOD, TXRENG, TXTEXT)
      values (N_Se115cd,N_Se115md , N_Se115su, N_Se115tr, N_Se115re, N_Se115fc, 400, 1, p_c_numope);


      exception
        when others then
          p_c_coderr := '99';
          p_c_msgerr := SQLERRM;
          N_Exito    := 'X';
      end;
    
      If p_c_coderr = '07' then
        N_Exito := 'S';
      Else
        N_Exito := 'X';
      End If;
    end loop;
  
  end;

  procedure SP_CLIENTE_CMAC(ln_pepais IN number,
                            ln_petdoc IN number,
                            ln_pendoc in varchar2,
                            cli_cmac  OUT varchar2) IS
    lc_numdoc varchar2(12);
  begin
    select pendoc
      into lc_numdoc
      from fsd001 a
     where a.pepais = ln_pepais
       and a.petdoc = ln_petdoc
       and a.pendoc = ln_pendoc;
    if lc_numdoc = ln_pendoc then
      cli_cmac := 'S';
    else
      cli_cmac := 'N';
    end if;
  exception
    when no_data_found then
      cli_cmac := 'N';
  end;

  procedure SP_TIP_CAMBIO(ln_Se115cd  IN number,
                          ln_Se115su  IN number,
                          ln_Se115md  IN number,
                          ln_Se115tr  in number,
                          ln_Se115re  in number,
                          tipo_cambio OUT numeric,
                          Moneda      out number) IS
  
  begin
    select ittcbi, moneda
      into tipo_cambio, Moneda
      from fsd016 a
     where a.pgcod = ln_Se115cd
       and a.itsuc = ln_Se115su
       and a.itmod = ln_Se115md
       and a.ittran = ln_Se115tr
       and a.itnrel = ln_Se115re
       and a.itord = 42;
  Exception
    when no_data_found then
      tipo_cambio := 0;
      Moneda      := 0;
  end;

  procedure SP_ITF(N_Se115cd IN number,
                   N_Se115su IN number,
                   N_Se115md IN number,
                   N_Se115tr in number,
                   N_Se115re in number,
                   N_Itf     OUT numeric) IS
  begin
    select Itimp1
      into N_Itf
      from fsd016 a
     where a.pgcod = N_Se115cd
       and a.itsuc = N_Se115su
       and a.itmod = N_Se115md
       and a.ittran = N_Se115tr
       and a.itnrel = N_Se115re
       and a.itord = 93;
  Exception
    When no_data_found then
      N_Itf := 0;
  end;

  function tipo_doc(ln_tp1cod1  in number,
                    ln_tp1corr1 in number,
                    ln_Tp1corr2 in number
                    --ln_tp1desc out nvarchar2
                    ) RETURN varchar2 is
    ln_tp1desc varchar2(30);
  Begin
    begin
      select Tp1desc
        into ln_tp1desc
        from fst198 a
       where tp1cod1 = ln_tp1cod1
         and tp1corr1 = ln_tp1corr1
         and Tp1corr2 = ln_Tp1corr2;
    Exception
      When no_data_found then
        ln_tp1desc := 1;
    end;
    return ln_tp1desc;
  end;
end pq_interfaz_etran;
/

