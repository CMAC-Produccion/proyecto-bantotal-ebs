create or replace package PQ_CR_FACTURACION is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_FACTURACION
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 
  -- Autor de Creación          : DCASTRO
  -- Uso                        : 
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 29/10/2020
  -- Autor de la Modificación   : jrodriguej
  -- Descripción de Modificación: Adición de procedimientos para generar la serie y correlativo del DAE y NCE
  -- Fecha de Modificación      : 11/11/2020
  -- Autor de la Modificación   : jrodriguej
  -- Descripción de Modificación: Adición de procesos para reprocesar fechas
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  Procedure sp_cr_tipo_cliente(pn_pais   in number,
                               pn_tipdoc in number,
                               pc_numdoc in char,
                               pc_tipper out char);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_tipo_credito(pn_pais   in number,
                               pn_tipdoc in number,
                               pc_numdoc in char,
                               pn_nument out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_producto(pn_rubro     in number,
                           pc_tipcli    in varchar2,
                           pc_tipo      in varchar2,
                           pc_secuencia out varchar2,
                           pc_codigo    out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_producto_financiero(pn_rubro     in number,
                                      pc_tipo      in varchar2,
                                      pc_secuencia out varchar2,
                                      pc_codigo    out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_producto_contingen(pn_rubro     in number,
                                     pc_tipo      in varchar2,
                                     pc_secuencia out varchar2,
                                     pc_codigo    out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Function fn_cr_fac_Hipotecario(ln_rubro       in number,
                                 lc_descripcion varchar2) return varchar2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_fac_Hipotecario(ln_rubro       in number,
                                  lc_descripcion varchar2,
                                  lc_serie       out char,
                                  lc_correlativo out char);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_NC_Hipotecario(lc_descripcion varchar2,
                                 lc_serie       out char,
                                 lc_correlativo out char);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_Factura(pn_rubro       in number,
                          pc_tipcli      in varchar2,
                          pc_tipo        in varchar2,
                          pc_serie       out varchar2,
                          pc_correlativo out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  Procedure sp_cr_Factura_Financiero(pn_rubro       in number,
                                     pc_tipo        in varchar2,
                                     pc_serie       out varchar2,
                                     pc_correlativo out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  Procedure sp_cr_Factura_Contingen(pn_rubro       in number,
                                     pc_tipo        in varchar2,
                                     pc_serie       out varchar2,
                                     pc_correlativo out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --     

end PQ_CR_FACTURACION;
/

create or replace package body PQ_CR_FACTURACION is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_FACTURACION
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 
  -- Autor de Creación          : DCASTRO
  -- Uso                        : 
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : DCASTRO
  -- Descripción de Modificación: 2017.08.09 DCASTRO Se modifico sp_cr_entidades_Tit
  -- Fecha de Modificación      : 29/10/2020
  -- Autor de la Modificación   : jrodriguej
  -- Descripción de Modificación: Adición de procedimientos para generar la serie y correlativo del DAE y NCE  
  -- Fecha de Modificación      : 11/11/2020
  -- Autor de la Modificación   : jrodriguej
  -- Descripción de Modificación: Adición de procesos para reprocesar fechas
  -- *****************************************************************

  Procedure sp_cr_tipo_cliente(pn_pais   in number,
                               pn_tipdoc in number,
                               pc_numdoc in char,
                               pc_tipper out char) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_tipo_cliente
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************
  
  begin
  
    --juridica
    begin
      select 'J'
        into pc_tipper
        from fsd003 f
       where f.pjpais = pn_pais
         and f.pjtdoc = pn_tipdoc
         and f.pjndoc = pc_numdoc;
    exception
      when others then
        pc_tipper := null;
    end;
  
    if pc_tipper is null then
      --verificar si es natural
      --natural
      begin
        select 'N'
          into pc_tipper
          from fsd002 f
         where f.pfpais = pn_pais
           and f.pftdoc = pn_tipdoc
           and f.pfndoc = pc_numdoc;
      exception
        when others then
          pc_tipper := null;
      end;
    
    end if;
  
  end sp_cr_tipo_cliente;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_tipo_credito(pn_pais   in number,
                               pn_tipdoc in number,
                               pc_numdoc in char,
                               pn_nument out number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_entidades_Tit
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************
  
    ln_serie number := 0;
  
  begin
  
    null;
  
  end sp_cr_tipo_Credito;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_producto(pn_rubro     in number,
                           pc_tipcli    in varchar2,
                           pc_tipo      in varchar2,
                           pc_secuencia out varchar2,
                           pc_codigo    out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_producto
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************
  
    ln_serie  number := 0;
    lc_serie  char(1);
    lc_descri varchar2(10) := null;
  
  begin
  
    if pc_tipcli = 'J' then
      lc_descri := '_FAC';
      lc_serie  := 'F';
    elsif pc_tipcli = 'N' then
      lc_descri := '_BOL';
      lc_serie  := 'B';
    end if;
  
    if pc_tipo = 'NC' then
      -- nota credito
    
      /*case 
          when pn_rubro = 4 then --hipotecario
               pc_codigo := 'FC';
               pc_secuencia := 'SEQ_NOTACREDITO_COR';  
              
          else 
               if lc_serie = 'B' then    
                   pc_codigo := lc_serie||'C';      
                   pc_secuencia := 'SQ_CR_NOTACREDITO'|| lc_descri;  
               else  --si es factura se utiliza la secuencia de hipotecario
                   pc_codigo := 'FC';
                   pc_secuencia := 'SEQ_NOTACREDITO_COR';   
               end if;    
      end case ;*/
    
      if lc_serie = 'B' then
        pc_codigo    := lc_serie || 'C';
        pc_secuencia := 'SQ_CR_NOTACREDITO' || lc_descri;
      else
        --si es factura se utiliza la secuencia de hipotecario 
        pc_codigo    := 'FG';
        pc_secuencia := 'SEQ_NOTACREDITO_GRA';
      end if;
    
    elsif pc_tipo = 'ND' then
      -- nota debito
    
      pc_codigo    := lc_serie || 'D';
      pc_secuencia := 'SQ_CR_NOTADEBITO' || lc_descri;
    
    elsif pc_tipo = 'MOV' then
      --movimiento / transaccion
    
      case
        when pn_rubro = 15 then
          --comisiones
          pc_codigo    := lc_serie || 'S';
          pc_secuencia := 'SQ_CR_COMISION' || lc_descri;
        when pn_rubro = 2 then
          --microempresa
          pc_codigo    := lc_serie || 'M';
          pc_secuencia := 'SQ_CR_MICRO' || lc_descri;
        when pn_rubro = 3 then
          --consumo
          pc_codigo    := 'FN';
          pc_secuencia := 'SQ_CR_CONSUMO_GR'; -- antes era SQ_CR_CONSUMO         
        when pn_rubro = 4 then
          --hipotecario
          pc_codigo    := 'FP';
          pc_secuencia := 'SEQ_HIPOTECARIO_GR'; --SEQ_HIPOTECARIO_GR
        when pn_rubro in (5, 6, 7, 8, 9, 10, 11, 12) then
          --medianas, grandes, corporativos
          pc_codigo    := lc_serie || 'O';
          pc_secuencia := 'SQ_CR_OTROS' || lc_descri;
        when pn_rubro = 13 then
          --pequeña empresa
          pc_codigo    := lc_serie || 'P';
          pc_secuencia := 'SQ_CR_PEQUENA' || lc_descri;
        else
          pc_codigo := null;
      end case;
    
    end if;
  
  end sp_cr_producto;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  Procedure sp_cr_producto_financiero(pn_rubro     in number,
                                      pc_tipo      in varchar2,
                                      pc_secuencia out varchar2,
                                      pc_codigo    out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_producto
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************
  
    ln_serie  number := 0;
    lc_serie  char(1);
    lc_descri varchar2(10) := null;
  
  begin
  
    lc_descri := '_FAC';
    lc_serie  := 'F';
  
    if pc_tipo = 'NC' then
      -- nota credito
    
      /*case 
          when pn_rubro = 4 then --hipotecario
               pc_codigo := 'FC';
               pc_secuencia := 'SEQ_NOTACREDITO_COR';
          when pn_rubro = 3 then --consumo
               pc_codigo := 'FC';
               pc_secuencia := 'SEQ_NOTACREDITO_COR';    
          else 
               if lc_serie = 'B' then    
                   pc_codigo := lc_serie||'C';      
                   pc_secuencia := 'SQ_CR_NOTACREDITO'|| lc_descri;  
               else  --si es factura se utiliza la secuencia de hipotecario
                   pc_codigo := 'FC';
                   pc_secuencia := 'SEQ_NOTACREDITO_COR';  
               end if;  
      end case ;*/
      --pc_codigo := 'FC';
      --pc_secuencia := 'SEQ_NOTACREDITO_COR'; 
    
      pc_codigo    := 'FC';
      pc_secuencia := 'SEQ_NOTACREDITO_COR';
    
    elsif pc_tipo = 'ND' then
      -- nota debito
    
      pc_codigo    := lc_serie || 'D';
      pc_secuencia := 'SQ_CR_NOTADEBITO' || lc_descri;
    
    elsif pc_tipo = 'MOV' then
      --movimiento / transaccion
    
      case
      /*when pn_rubro = 15 then --comisiones
                       pc_codigo := lc_serie||'S';
                       pc_secuencia := 'SQ_CR_COMISION' || lc_descri;*/
      
      /*se comento 12/12/2021 dcastro
        when pn_rubro = 2 then
          --microempresa
          pc_codigo    := lc_serie || 'M';
          pc_secuencia := 'SQ_CR_MICRO' || lc_descri;
          
        when pn_rubro = 3 then
          --consumo
          pc_codigo    := lc_serie || 'F';
          pc_secuencia := 'SQ_CR_CONSUMO' || lc_descri;
         */
         when pn_rubro in (3,2,5,6,7,8,9,10,11,12,13) then  --12/12/2021 dcastro se agrego todos los productos micro pequeña mediana grandes empresas
          --consumo
          pc_codigo    := lc_serie || 'F';
          pc_secuencia := 'SQ_CR_CONSUMO' || lc_descri;          
          
        when pn_rubro = 4 then
          --hipotecario
          pc_codigo    := 'FH';
          pc_secuencia := 'SEQ_HIPOTECARIO_COR';
          /*when pn_rubro in (5,6,7,8,9,10,11,12) then --medianas, grandes, corporativos
               pc_codigo := lc_serie||'O';
               pc_secuencia := 'SQ_CR_OTROS' || lc_descri;           
          when pn_rubro = 13 then --pequeña empresa
               pc_codigo := lc_serie||'P';      
               pc_secuencia := 'SQ_CR_PEQUENA' || lc_descri;  */
        else
          pc_codigo := null;
      end case;
    
    end if;
  
  end sp_cr_producto_financiero;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  Procedure sp_cr_producto_contingen(pn_rubro     in number,
                                     pc_tipo      in varchar2,
                                     pc_secuencia out varchar2,
                                     pc_codigo    out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_producto_contingen
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 09/11/2020
    -- Autor de Creación          : jrodriguej
    -- Uso                        : Generación de correlativos de contingencia
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  
  begin
  
    if pc_tipo = 'NC' then
      -- nota credito
    
      pc_codigo    := 'FT';
      pc_secuencia := 'SEQ_NOTACREDITO_CNT';
    
      --elsif pc_tipo = 'ND' then -- nota debito
    
      --       pc_codigo := 'FT';      
      --       pc_secuencia := 'SQ_CR_NOTADEBITO_CNT';  
    
    elsif pc_tipo = 'MOV' then
      --movimiento / transaccion
    
      --pc_codigo    := 'FS'; 12/12/2021 dcastro se cambio FS por FL
      pc_codigo    := 'FL';  -- 12/12/2021
      pc_secuencia := 'SEQ_HIPOTECARIO_CNT';
    
    end if;
  
  end sp_cr_producto_contingen;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Function fn_cr_fac_Hipotecario(ln_rubro       in number,
                                 lc_descripcion varchar2) return varchar2 is
    -- *****************************************************************
    -- Nombre                     : sp_cr_entidades_Tit
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************
  
    ln_number      number := 0;
    ln_serie       number := 0;
    lc_serie       char(4);
    lc_correlativo char(8);
    lc_car         char(2) := 'FH';
    ln_finnumero   number := 0;
    ln_finserie    number := 0;
    lc_numfac      varchar2(30);
    ln_codserie    number(5);
  
  BEGIN
    begin
      select f.tp1imp2, f.tp1nro3, f.tp1imp3
        into ln_finnumero, ln_finserie, ln_codserie
        from fst198 f
       where 
         f.tp1cod = 1
         and f.tp1cod1 = 11120
         and f.tp1corr1 = 1
         and f.tp1corr2 = 1
         and f.tp1nro1 = ln_rubro;
    end;
  
    begin
      select max(j.jaqz457max)
        into ln_serie
        from jaqz457 j
       where j.jaqz457cod = ln_codserie;
    end;
  
    --ln_number := SEQ_HIPOTECARIO_COR.NEXTVAL;   
    begin
      sp_correl_sq(p_c_nomseq => lc_descripcion,
                   p_c_codusu => 'BANTOTAL',
                   p_n_correl => ln_number);
    end;
    commit;
  
    lc_serie       := lpad(ln_serie, 2, '0');
    lc_correlativo := lpad(ln_number, 8, '0');
    --dbms_output.put_line(lc_car||' serie '||lc_serie ||' - '||lc_correlativo );   
  
    --concatena numero de factura
    lc_numfac := lc_car || lc_serie || '-' || lc_correlativo;
  
    if ln_number = ln_finnumero then
      --si es igual a Limite superior , debe incrementar segunda secuencia.
      ln_serie := ln_serie + 1;
      --si cambia de numero actualiza tabla
      update jaqz457 j
         set j.jaqz457max = ln_serie
       where j.jaqz457cod = ln_codserie;
      commit;
    end if;
  
    return lc_numfac;
  
  end fn_cr_Fac_Hipotecario;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_fac_Hipotecario(ln_rubro       in number,
                                  lc_descripcion varchar2,
                                  lc_serie       out char,
                                  lc_correlativo out char) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_entidades_Tit
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************
  
    ln_number    number := 0;
    ln_serie     number := 0;
    lc_car       char(2) := 'FH';
    ln_finnumero number := 0;
    ln_finserie  number := 0;
    lc_numfac    varchar2(30);
    ln_codserie  number(5);
  
  BEGIN
    begin
      select f.tp1imp2, f.tp1nro3, f.tp1imp3
        into ln_finnumero, ln_finserie, ln_codserie
        from fst198 f
       where 
        f.tp1cod = 1
         and f.tp1cod1 = 11120
         and f.tp1corr1 = 1
         and f.tp1corr2 = 1
         and f.tp1nro1 = ln_rubro;
    end;
  
    begin
      select max(j.jaqz457max)
        into ln_serie
        from jaqz457 j
       where j.jaqz457cod = ln_codserie;
    end;
  
    --ln_number := SEQ_HIPOTECARIO_COR.NEXTVAL;   
    begin
      sp_correl_sq(p_c_nomseq => lc_descripcion,
                   p_c_codusu => 'BANTOTAL',
                   p_n_correl => ln_number);
    end;
    commit;
  
    lc_serie       := lc_car || lpad(ln_serie, 2, '0'); --mod@abr 20180530
    lc_correlativo := lpad(ln_number, 8, '0');
    --dbms_output.put_line(lc_car||' serie '||lc_serie ||' - '||lc_correlativo );   
  
    --concatena numero de factura
    lc_numfac := lc_car || lc_serie || '-' || lc_correlativo;
  
    if ln_number = ln_finnumero then
      --si es igual a Limite superior , debe incrementar segunda secuencia.
      ln_serie := ln_serie + 1;
      --si cambia de numero actualiza tabla
      update jaqz457 j
         set j.jaqz457max = ln_serie
       where j.jaqz457cod = ln_codserie;
      commit;
    end if;
  
  end sp_cr_Fac_Hipotecario;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_NC_Hipotecario(lc_descripcion varchar2,
                                 lc_serie       out char,
                                 lc_correlativo out char) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_entidades_Tit
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************
  
    ln_number    number := 0;
    ln_serie     number := 0;
    lc_car       char(2) := 'FC';
    ln_finnumero number := 0;
    ln_finserie  number := 0;
    lc_numfac    varchar2(30);
    ln_codserie  number(5); --NOTACREDITO
  
  BEGIN
    --NOTA CREDITO
  
    begin
      select f.tp1imp2, f.tp1nro3, f.tp1imp3
        into ln_finnumero, ln_finserie, ln_codserie
        from fst198 f
       where 
         f.tp1cod = 1
         and f.tp1cod1 = 11120
         and f.tp1corr1 = 1
         and f.tp1corr2 = 1
         and f.tp1corr3 = 0;
    end;
  
    begin
      select max(j.jaqz457max)
        into ln_serie
        from jaqz457 j
       where j.jaqz457cod = ln_codserie;
    end;
  
    --ln_number := SEQ_HIPOTECARIO_COR.NEXTVAL;   
    begin
      sp_correl_sq(p_c_nomseq => lc_descripcion,
                   p_c_codusu => 'BANTOTAL',
                   p_n_correl => ln_number);
    end;
    commit;
  
    lc_serie       := lc_car || lpad(ln_serie, 2, '0'); --mod@abr 20180530
    lc_correlativo := lpad(ln_number, 8, '0');
    --dbms_output.put_line(lc_car||' serie '||lc_serie ||' - '||lc_correlativo );   
  
    --concatena numero de factura
    -- lc_numfac := lc_car||lc_serie ||'-'||lc_correlativo;
  
    if ln_number = ln_finnumero then
      --si es igual a Limite superior , debe incrementar segunda secuencia.
      ln_serie := ln_serie + 1;
      --si cambia de numero actualiza tabla
      update jaqz457 j
         set j.jaqz457max = ln_serie
       where j.jaqz457cod = ln_codserie;
      commit;
    end if;
  
  end sp_cr_NC_Hipotecario;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_Factura(pn_rubro       in number,
                          pc_tipcli      in varchar2,
                          pc_tipo        in varchar2,
                          pc_serie       out varchar2,
                          pc_correlativo out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_Factura
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************
  
    ln_number      number := 0;
    ln_serie       number := 0;
    lc_car         char(2);
    ln_finnumero   number := 0;
    ln_finserie    number := 0;
    lc_numfac      varchar2(30);
    ln_codserie    number(5);
    lc_descripcion varchar2(30);
    lc_serie       varchar2(4);
    lc_correlativo number(9) := 0;
  
  BEGIN
  
    --obtener producto  
    begin
      pq_cr_facturacion.sp_cr_producto(pn_rubro     => pn_rubro,
                                       pc_tipcli    => pc_tipcli,
                                       pc_tipo      => pc_tipo,
                                       pc_secuencia => lc_descripcion,
                                       pc_codigo    => lc_car);
    end;
  
    begin
      select f.tp1imp2, f.tp1nro3, f.tp1imp3
        into ln_finnumero, ln_finserie, ln_codserie
        from fst198 f
       where 
         f.tp1cod = 1
         and f.tp1cod1 = 11120
         and f.tp1corr1 = 1
         and f.tp1corr2 = 1
         and f.tp1nro1 = pn_rubro;
    end;
  
    begin
      select max(j.jaqz457max)
        into ln_serie
        from jaqz457 j ---tab número de serie
       where j.jaqz457cod = ln_codserie;
    end;
  
    --ln_number := SEQ_HIPOTECARIO_COR.NEXTVAL;   
    begin
      sp_correl_sq(p_c_nomseq => lc_descripcion,
                   p_c_codusu => 'BANTOTAL',
                   p_n_correl => ln_number);
    end;
    commit;
  
    lc_serie       := lc_car || lpad(ln_serie, 2, '0'); --mod@abr 20180530
    lc_correlativo := lpad(ln_number, 8, '0');
    --dbms_output.put_line(lc_car||' serie '||lc_serie ||' - '||lc_correlativo );   
  
    --concatena numero de factura
    lc_numfac := lc_serie || '-' || lc_correlativo;
  
    if ln_number = ln_finnumero then
      --si es igual a Limite superior , debe incrementar segunda secuencia.
      ln_serie := ln_serie + 1;
      --si cambia de numero actualiza tabla
      update jaqz457 j
         set j.jaqz457max = ln_serie
       where j.jaqz457cod = ln_codserie;
      commit;
    end if;
  
    pc_serie       := lc_serie;
    pc_correlativo := lc_correlativo;
  
  end sp_cr_Factura;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_Factura_Financiero(pn_rubro       in number,
                                     pc_tipo        in varchar2,
                                     pc_serie       out varchar2,
                                     pc_correlativo out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_Factura
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************
  
    ln_number      number := 0;
    ln_serie       number := 0;
    lc_car         char(2);
    ln_finnumero   number := 0;
    ln_finserie    number := 0;
    lc_numfac      varchar2(30);
    ln_codserie    number(5);
    lc_descripcion varchar2(30);
    lc_serie       varchar2(4);
    lc_correlativo number(9) := 0;
  
  BEGIN
  
    --obtener producto  
    begin
      pq_cr_facturacion.sp_cr_producto_financiero(pn_rubro     => pn_rubro,
                                                  pc_tipo      => pc_tipo,
                                                  pc_secuencia => lc_descripcion,
                                                  pc_codigo    => lc_car);
    end;
  
    begin
      select f.tp1imp2, f.tp1nro3, f.tp1imp3
        into ln_finnumero, ln_finserie, ln_codserie
        from fst198 f
       where 
         f.tp1cod = 1
         and f.tp1cod1 = 11120
         and f.tp1corr1 = 1
         and f.tp1corr2 = 1
         and f.tp1nro1 = pn_rubro;
    end;
  
    begin
      select max(j.jaqz457max)
        into ln_serie
        from jaqz457 j ---tab número de serie
       where j.jaqz457cod = ln_codserie;
    end;
  
    --ln_number := SEQ_HIPOTECARIO_COR.NEXTVAL;   
    begin
      sp_correl_sq(p_c_nomseq => lc_descripcion,
                   p_c_codusu => 'BANTOTAL',
                   p_n_correl => ln_number); --out
    end;
    commit;
  
    lc_serie       := lc_car || lpad(ln_serie, 2, '0'); --mod@abr 20180530
    lc_correlativo := lpad(ln_number, 8, '0');
    --dbms_output.put_line(lc_car||' serie '||lc_serie ||' - '||lc_correlativo );   
  
    --concatena numero de factura
    lc_numfac := lc_serie || '-' || lc_correlativo;
  
    if ln_number = ln_finnumero then
      --si es igual a Limite superior , debe incrementar segunda secuencia.
      ln_serie := ln_serie + 1;
      --si cambia de numero actualiza tabla
      update jaqz457 j
         set j.jaqz457max = ln_serie
       where j.jaqz457cod = ln_codserie;
      commit;
    end if;
  
    pc_serie       := lc_serie;
    pc_correlativo := lc_correlativo;
  
  end sp_cr_Factura_Financiero;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                            
  Procedure sp_cr_Factura_Contingen(pn_rubro       in number,
                                    pc_tipo        in varchar2,
                                    pc_serie       out varchar2,
                                    pc_correlativo out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_Factura
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 09/11/2020
    -- Autor de Creación          : Jrodriguej
    -- Uso                        : Generación de correlativos para contigencia
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  
    ln_number      number := 0;
    ln_serie       number := 0;
    lc_car         char(2);
    ln_finnumero   number := 0;
    ln_finserie    number := 0;
    lc_numfac      varchar2(30);
    ln_codserie    number(5);
    lc_descripcion varchar2(30);
    lc_serie       varchar2(4);
    lc_correlativo number(9) := 0;
  
  BEGIN
  
    --obtener producto  
    begin
      pq_cr_facturacion.sp_cr_producto_contingen(pn_rubro     => pn_rubro,
                                                 pc_tipo      => pc_tipo,
                                                 pc_secuencia => lc_descripcion,
                                                 pc_codigo    => lc_car);
    end;
  
    begin
      select f.tp1imp2, f.tp1nro3, f.tp1imp3
        into ln_finnumero, ln_finserie, ln_codserie
        from fst198 f
       where 
        f.tp1cod = 1
         and f.tp1cod1 = 11120
         and f.tp1corr1 = 1
         and f.tp1corr2 = 1
         and f.tp1nro1 = pn_rubro;
    end;
  
    begin
      select max(j.jaqz457max)
        into ln_serie
        from jaqz457 j ---tab número de serie
       where j.jaqz457cod = ln_codserie;
    end;
  
    --ln_number := SEQ_HIPOTECARIO_COR.NEXTVAL;   
    begin
      sp_correl_sq(p_c_nomseq => lc_descripcion,
                   p_c_codusu => 'BANTOTAL',
                   p_n_correl => ln_number); --out
    end;
    commit;
  
    lc_serie       := lc_car || lpad(ln_serie, 2, '0'); --mod@abr 20180530
    lc_correlativo := lpad(ln_number, 8, '0');
    --dbms_output.put_line(lc_car||' serie '||lc_serie ||' - '||lc_correlativo );   
  
    --concatena numero de factura
    lc_numfac := lc_serie || '-' || lc_correlativo;
  
    if ln_number = ln_finnumero then
      --si es igual a Limite superior , debe incrementar segunda secuencia.
      ln_serie := ln_serie + 1;
      --si cambia de numero actualiza tabla
      update jaqz457 j
         set j.jaqz457max = ln_serie
       where j.jaqz457cod = ln_codserie;
      commit;
    end if;
  
    pc_serie       := lc_serie;
    pc_correlativo := lc_correlativo;
  
  end sp_cr_Factura_Contingen;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                              
end PQ_CR_FACTURACION;
/

