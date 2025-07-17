create or replace package pq_cr_cliente_reinsertar is
  -- *****************************************************************
  -- Nombre                     : pq_cr_cliente_reinsertar
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Creditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2025.07.10
  -- Autor de Creación          : YYAMPI
  -- Uso                        : juego de procedimientos para reinsertar cliente
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : 
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  --                              
  --  
  -- *****************************************************************

  procedure sp_cr_saldos_calif(pn_pgpais number,
                               pn_tipdoc number,
                               pc_numdoc char,
                               pn_saldos out number,
                               pn_calif  out number);

end pq_cr_cliente_reinsertar;
/
create or replace package body pq_cr_cliente_reinsertar is

  -----------------------------------------------------------------------------

  procedure sp_cr_saldos_calif(pn_pgpais number,
                               pn_tipdoc number,
                               pc_numdoc char,
                               pn_saldos out number,
                               pn_calif  out number) is
    -- *****************************************************************
    -- Nombre                     : pq_cr_cliente_reinsertar
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 10/07/2025
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Retorna la menor calificacion en una ventana de tiempo de 24 meses
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************
  
    ld_fecrcc    date; --fecha de ultima carga RCC
    ln_petipo    varchar(2) := ''; --Tipo de persona (F/J)
    ln_tipdocSBS number(9) := 0; --Tipo documento SBS
    lv_codSBS    varchar(10) := ''; --codigoSBS 
    --pn_result number;  --resultado
    ln_meseva   number := 0; --meses de evaluacion 
    ln_meseva2  number := 0; --meses de evaluacion 
    ld_fecrcci  date; --fecha de inicio carga RCC
    ld_fecrcci2 date; --fecha de inicio carga RCC
    pn_result   number;
    pv_numdoc   varchar(12);
    ln_calif    number(5, 2) := 0;
  begin
    pn_result := 0.00;
    --pv_result := 'S';
  
    /*fecha de ultima carga del RCC */
    begin
      select to_date(Tpnro, 'dd.mm.yyyy')
        into ld_fecrcc
        from Fst098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    exception
      when others then
        ld_fecrcc := null;
    end;
  
    /*obtener el numero de meses maximo para la evaluacion*/
    begin
      select t.tp1nro1
        into ln_meseva
        from FST198 t
       Where t.Tp1cod = 1
         and t.Tp1cod1 = 11155
         and t.Tp1corr1 = 601
         and t.Tp1corr2 = 1
         and t.Tp1corr3 = 1;
    
      ld_fecrcci := add_months(ld_fecrcc, -1 * ln_meseva);
    
    exception
      when others then
        ln_meseva  := 0;
        ld_fecrcci := null;
    end;
  
    begin
      select t.tp1nro1
        into ln_meseva2
        from FST198 t
       Where t.Tp1cod = 1
         and t.Tp1cod1 = 11155
         and t.Tp1corr1 = 601
         and t.Tp1corr2 = 1
         and t.Tp1corr3 = 2;
    
      ld_fecrcci2 := add_months(ld_fecrcc, -1 * (ln_meseva + ln_meseva2));
    
    exception
      when others then
        ln_meseva   := 0;
        ld_fecrcci2 := null;
    end;
  
    /*obtener tipo de persona (Juridica o natural) */
    begin
      select t.petipo
        into ln_petipo
        from fsd001 t
       where t.pepais = pn_pgpais
         and t.petdoc = pn_tipdoc
         and t.pendoc = pc_numdoc;
    exception
      when others then
        DBMS_OUTPUT.put_line(SQLERRM);
    end;
  
    /*Calculo de tipo de documento SBS*/
    begin
      select t.tp1corr3
        into ln_tipdocSBS
        from FST198 t
       where t.tp1cod = 1
         and t.tp1cod1 = 11111
         and t.tp1corr1 = 1
         and t.tp1corr2 = 3
         and t.tp1nro1 = pn_tipdoc;
    exception
      when others then
        DBMS_OUTPUT.put_line(SQLERRM);
    end;
  
    /*Obtencion del codigo SBS*/
    begin
      pv_numdoc := trim(pc_numdoc);
      if ln_petipo = 'F' then
        select c_codsbs
          into lv_codSBS
          from (select c.c_codsbs
                   from CLDRCCI c
                  Where --D_FECPRE = ld_fecrcc
                  C.D_FECPRE between ld_fecrcci and ld_fecrcc
               and C_TDOCID = ln_tipdocSBS
               and C_DOCIDE = pv_numdoc
                  order by C.D_FECPRE desc)
         where rownum = 1;
      else
        if ln_petipo = 'J' then
          select c_codsbs
            into lv_codSBS
            from (select c.c_codsbs --into lv_codSBS
                     from CLDRCCI c
                    Where --D_FECPRE = ld_fecrcc
                    C.D_FECPRE between ld_fecrcci and ld_fecrcc
                 and C_TDOCTR = ln_tipdocSBS
                 and C_DOCTRI = pv_numdoc
                    order by C.D_FECPRE desc)
           where rownum = 1;
        else
          lv_codSBS := null;
        end if;
      end if;
    exception
      when others then
        DBMS_OUTPUT.put_line(SQLERRM);
    end;
  
    /*Calculo de saldo en meses de antiguedad*/
  
    begin
      select /*+index(C XN_CLDRCCS_1)*/
       nvl(sum(c.n_salcap), 0) --, count(distinct c.d_fecpre) --*  --sum(c.n_salcap) INACTIVO-- into pn_result  
        into pn_saldos --,  pn_cuotas
        FROM CLDRCCS C
       WHERE C.C_CODSBS = lv_codSBS --A.CODSBS
         AND C.D_FECPRE between ld_fecrcci and ld_fecrcc
            --to_date('2020.02.29','rrrr.mm.dd') and to_date('2020.07.31','rrrr.mm.dd') 
         AND ((SUBSTR(C.C_CUENTA, 1, 2) = '14' AND
             SUBSTR(C.C_CUENTA, 4, 1) IN ('1', '3', '4', '5', '6')) OR
             (SUBSTR(C.C_CUENTA, 1, 2) = '71' AND
             SUBSTR(C.C_CUENTA, 4, 1) IN ('1', '2', '3', '4')) --CREDITOS INDIRECTOS
             OR (SUBSTR(C.C_CUENTA, 1, 2) = '81' AND
             SUBSTR(C.C_CUENTA, 4, 3) = '302') --CREDITOS CASTIGADOS      
             ) --CREDITOS DIRECTOS
            
         AND C.C_CRETIP IN (select SUBSTR(T.TP1DESC, 1, 2)
                              from FST198 T
                             WHERE t.Tp1cod = 1
                               AND t.Tp1cod1 = 11155
                               AND t.Tp1corr1 = 301
                               AND t.Tp1corr2 = 2);
    
    exception
      when others then
        pn_result := 0;
        pn_saldos := 0;
    end;
  
    if pn_saldos <= 0 then
    
      begin
      
        /*Calculo de minima calificacion  en meses de antiguedad*/
        select nvl(min(nvl(c.n_calif0, 100)), 100)
          into ln_calif
          from CLDRCCI c
         where c.c_codsbs = lv_codSBS
           and c.d_fecpre between ld_fecrcci2 and ld_fecrcci;
      
        pn_calif := ln_calif;
      
      exception
        when others then
          ln_calif := 0;
          pn_calif := 0;
      end;
    
    end if;
  
  exception
    WHEN OTHERS THEN
      pn_result := 0;
      pn_saldos := 0;
      --pn_cuotas  := 0;
    --pn_volumen := 0;
    --pv_result :='S'; 
  
  end sp_cr_saldos_calif;

-----------------------------------------------------------------------------------
end pq_cr_cliente_reinsertar;
/
