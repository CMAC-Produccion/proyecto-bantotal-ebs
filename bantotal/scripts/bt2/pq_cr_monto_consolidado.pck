create or replace package pq_cr_monto_consolidado is

  -- Author  : ENINAH
  -- Created : 28/12/2023 15:39:34
  -- Purpose : monto del crédito del titular
  procedure sp_cr_monto_credito_titular(n_inst in number,
                                        --n_modulo    in number,
                                        monto_final out number);
  -------------------------------------------------------------------
  procedure sp_cr_calcular_monto(pgcod      in number,
                                 modulo     in number,
                                 sucursal   in number,
                                 moneda     in number,
                                 papel      in number,
                                 nro_cuenta in number,
                                 operacion  in number,
                                 subope     in number,
                                 tipope     in number,
                                 rub_1      in number,
                                 rub_2      in number,
                                 rub_3      in number,
                                 rub_4      in number,
                                 TIPOCAMBIO in number,
                                 ln_saldo   out number);
  -------------------------------------------------------------                                 
  procedure sp_Cr_LogAqpd152d(ld_fecha   in date,
                              v_hora     in varchar2,
                              ln_inst    in number,
                              TIPOCAMBIO in number,
                              ln_pgcod   in number,
                              ln_aosuc   in number,
                              ln_aomod   in number,
                              ln_aomda   in number,
                              ln_aopap   in number,
                              ln_aocta   in number,
                              ln_aooper  in number,
                              ln_aosbop  in number,
                              ln_aotope  in number,
                              saldo_cap  in number);

end pq_cr_monto_consolidado;
/

create or replace package body pq_cr_monto_consolidado is

  -- *****************************************************************
  -- Nombre                     : PAQUETES PARA OBTENER EL MONTO CONSOLIDADO
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2024.01.12
  -- Autor de Creación          : EDEHILTON NINA, MARIA POSTIGO
  -- Uso                        : Realiza cálculos
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : n_inst
  --
  --
  --
  -- *****************************************************************

  procedure sp_cr_monto_credito_titular(n_inst in number,
                                        --n_modulo    in number,
                                        monto_final out number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_monto_credito_titular
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : EDEHILTON NINA, MARIA POSTIGO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : n_inst
    --
    -- Retorno                    : monto_final
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: Devuelve el monto consolidado final
    --
    -- *****************************************************************
  
    cursor creditos(ln_pais number, ln_tdoc number, num_doc varchar2) is
      select pgcod,
             aomod,
             aosuc,
             aomda,
             aopap,
             aocta,
             aooper,
             aosbop,
             aotope
        from fsd010
       where pgcod = 1
         and aocta in (select ctnro
                         from fsr008
                        where pepais = ln_pais
                          and petdoc = ln_tdoc
                          and pendoc = rpad(num_doc, 12, ' ')
                          and ttcod = 1
                          and cttfir = 'T')
         and aostat <> 99
         and (aomod in
             (select s.modulo
                 from fst111 s
                where s.dscod = 50
                  and s.modulo not in (29, 33, 108, 116, 142, 144, 200)
                   or aomod = 117));
  
    ln_pais       number;
    ln_tdoc       number;
    num_doc       varchar2(12);
    scrub_1       number(16);
    scrub_2       number(16);
    scrub_3       number(16);
    scrub_4       number(16);
    monto_conso   number(17, 2) := 0.0;
    monto_conso_f number(17, 2) := 0.0;
    --fecha_hor     date;
    --v_fecha_str  VARCHAR2(20);
    v_fecha varchar(10);
    v_hora  varchar(8);
    --tip_cam number(14, 6);
    --existe       number(10);
    ln_instancia      number;
    ln_TieneGar       number;
    TIPOCAMBIO        number(14, 6);
    v_max_correlativo number;
  
  begin
  
    -- Verificamos si existe el log cabecera y detalle
  
    begin
      update aqpd152 set aqpd152estreg = 'I' where aqpd152inst = n_inst;
      update aqpd152d set aqpd152destreg = 'I' where aqpd152dinst = n_inst;
      commit;
    end;
  
    begin
      --Obtenemos la fecha del sistema
      select f.pgfape into v_fecha from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into v_hora from dual;
    exception
      when others then
        null;
    end;
  
    begin
      --Saco DNI de la SNG001 con la instancia
      select s.sng001pais, s.sng001tdoc, s.SNG001NDOC
        into ln_pais, ln_tdoc, num_doc
        from sng001 s
       where s.sng001inst = n_inst;
    exception
      when others then
        null;
    end;
  
    --Obtengo el tipo de cambio a la fecha actual
    begin
      TIPOCAMBIO := fn_tipo_cambio_fijo(v_fecha);
    exception
      when others then
        TIPOCAMBIO := 1;
    end;
  
    BEGIN
      monto_conso_f := 0;
      --Con cada cuenta saco la clave de credito de los créditos vigentes
    
      FOR c IN creditos(ln_pais, ln_tdoc, num_doc) LOOP
      
        ln_instancia := fn_instancia_credito(v_Scmod  => c.aomod,
                                             v_Scsuc  => c.aosuc,
                                             v_Scmda  => c.aomda,
                                             v_Scpap  => c.aopap,
                                             v_Sccta  => c.aocta,
                                             v_Scoper => c.aooper,
                                             v_Scsbop => c.aosbop,
                                             v_Sctope => c.aotope);
      
        begin
          select count(*)
            into ln_TieneGar
            from sng122 s
           where s.sng122inst = ln_instancia
             and s.sng122mod = 70
             and s.sng122tope in (90, 91);
        exception
          when others then
            ln_TieneGar := 0;
        end;
      
        if ln_TieneGar = 0 then
        
          --Con cada Crédito Vigente Saco el saldo total
          --segun el rubro del modulo del
        
          if c.aomod = 117 then
            scrub_1 := 7215000000000;
            scrub_2 := 7216000000000;
            scrub_3 := 7225000000000;
            scrub_4 := 7226000000000;
            begin
              pq_cr_monto_consolidado.sp_cr_calcular_monto(pgcod      => c.pgcod,
                                                           modulo     => c.aomod,
                                                           sucursal   => c.aosuc,
                                                           moneda     => c.aomda,
                                                           papel      => c.aopap,
                                                           nro_cuenta => c.aocta,
                                                           operacion  => c.aooper,
                                                           subope     => c.aosbop,
                                                           tipope     => c.aotope,
                                                           rub_1      => scrub_1,
                                                           rub_2      => scrub_2,
                                                           rub_3      => scrub_3,
                                                           rub_4      => scrub_4,
                                                           TIPOCAMBIO => TIPOCAMBIO,
                                                           ln_saldo   => monto_conso);
            
            end;
          
          elsif c.aomod = 141 then
            scrub_1 := 7112000000000;
            scrub_2 := 7113000000000;
            scrub_3 := 7122000000000;
            scrub_4 := 7123000000000;
            begin
              pq_cr_monto_consolidado.sp_cr_calcular_monto(pgcod      => c.pgcod,
                                                           modulo     => c.aomod,
                                                           sucursal   => c.aosuc,
                                                           moneda     => c.aomda,
                                                           papel      => c.aopap,
                                                           nro_cuenta => c.aocta,
                                                           operacion  => c.aooper,
                                                           subope     => c.aosbop,
                                                           tipope     => c.aotope,
                                                           rub_1      => scrub_1,
                                                           rub_2      => scrub_2,
                                                           rub_3      => scrub_3,
                                                           rub_4      => scrub_4,
                                                           TIPOCAMBIO => TIPOCAMBIO,
                                                           ln_saldo   => monto_conso);
            
            end;
          elsif c.aomod <> 141 or c.aomod <> 117 then
          
            scrub_1 := 1411000000000;
            scrub_2 := 1412000000000;
            scrub_3 := 1421000000000;
            scrub_4 := 1422000000000;
          
            begin
              pq_cr_monto_consolidado.sp_cr_calcular_monto(pgcod      => c.pgcod,
                                                           modulo     => c.aomod,
                                                           sucursal   => c.aosuc,
                                                           moneda     => c.aomda,
                                                           papel      => c.aopap,
                                                           nro_cuenta => c.aocta,
                                                           operacion  => c.aooper,
                                                           subope     => c.aosbop,
                                                           tipope     => c.aotope,
                                                           rub_1      => scrub_1,
                                                           rub_2      => scrub_2,
                                                           rub_3      => scrub_3,
                                                           rub_4      => scrub_4,
                                                           TIPOCAMBIO => TIPOCAMBIO,
                                                           ln_saldo   => monto_conso);
            
            end;
          end if;
        
          monto_conso_f := nvl(monto_conso, 0) + nvl(monto_conso_f, 0);
        
          pq_cr_monto_consolidado.sp_Cr_LogAqpd152d(ld_fecha   => v_fecha,
                                                    v_hora     => v_hora,
                                                    ln_inst    => n_inst,
                                                    TIPOCAMBIO => TIPOCAMBIO,
                                                    ln_pgcod   => c.pgcod,
                                                    ln_aosuc   => c.aosuc,
                                                    ln_aomod   => c.aomod,
                                                    ln_aomda   => c.aomda,
                                                    ln_aopap   => c.aopap,
                                                    ln_aocta   => c.aocta,
                                                    ln_aooper  => c.aooper,
                                                    ln_aosbop  => c.aosbop,
                                                    ln_aotope  => c.aotope,
                                                    saldo_cap  => monto_conso);
        end if;
      END LOOP;
    
      monto_final := nvl(monto_conso_f, 0);
    end;
  
    -- log cabecera
    begin
      select max(aqpd152corr)  into v_max_correlativo from aqpd152 where aqpd152inst = n_inst ;
    exception
      when others then
        v_max_correlativo := 0;
    end;
    
    v_max_correlativo := nvl(v_max_correlativo,0);
    
    begin
      insert into aqpd152
        (aqpd152corr,
         aqpd152inst,
         aqpd152fec,
         aqpd152hor,
         aqpd152tipcam,
         aqpd152mntcons,
         aqpd152estreg)
      values
        (v_max_correlativo + 1,
         n_inst,
         v_fecha,
         v_hora,
         TIPOCAMBIO,
         monto_final,
         'H');
      commit;
    end;
  
  end sp_cr_monto_credito_titular;
  -----------------------------------------------------------------
  procedure sp_cr_calcular_monto(pgcod      in number,
                                 modulo     in number,
                                 sucursal   in number,
                                 moneda     in number,
                                 papel      in number,
                                 nro_cuenta in number,
                                 operacion  in number,
                                 subope     in number,
                                 tipope     in number,
                                 rub_1      in number,
                                 rub_2      in number,
                                 rub_3      in number,
                                 rub_4      in number,
                                 TIPOCAMBIO in number,
                                 ln_saldo   out number) is
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_calcular_monto
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : EDEHILTON NINA, MARIA POSTIGO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pgcod, modul0, sucursal, moneda, papel, nro_cuenta,operacion  in number, subope, tipope, rub_1, rub_2, rub_3, rub_4, TIPOCAMBIO
    -- Retorno                    : ln_saldo
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: Calcula el monto consolidado
    --
    -- *****************************************************************
  
    -- ln_saldo number(17, 2) := 0.00;
  
  begin
  
    Begin
      SELECT SCSDO
        into ln_saldo
        FROM fsd011 f
       where pgcod = pgcod
         and SCMOD = modulo
         and SCSUC = sucursal
         and SCMDA = moneda
         and SCPAP = papel
         and SCCTA = nro_cuenta
         and SCOPER = operacion
         and SCSBOP = subope
         and SCTOPE = tipope
         and (SCRUB > rub_1 or SCRUB < rub_2 or SCRUB > rub_3 or
             SCRUB < rub_4); -- 27828;
    exception
      when others then
        null;
    end;
  
    --Aqui se calcula si es el que monto es negativo se hace positivo
  
    --mnd   := registro.SCMDA;
    --saldo := registro.SCSDO;
    IF moneda = 0 THEN
      if ln_saldo < 0 then
        ln_saldo := ln_saldo * (-1);
      end if;
    ELSIF moneda = 101 THEN
      if ln_saldo < 0 then
        ln_saldo := ln_saldo * (-1);
      end if;
      ln_saldo := ln_saldo * TIPOCAMBIO;
    END IF;
  end sp_cr_calcular_monto;
  ----------------------------------------------------------------
  procedure sp_Cr_LogAqpd152d(ld_fecha   in date,
                              v_hora     in varchar2,
                              ln_inst    in number,
                              TIPOCAMBIO in number,
                              ln_pgcod   in number,
                              ln_aosuc   in number,
                              ln_aomod   in number,
                              ln_aomda   in number,
                              ln_aopap   in number,
                              ln_aocta   in number,
                              ln_aooper  in number,
                              ln_aosbop  in number,
                              ln_aotope  in number,
                              saldo_cap  in number) is
  
    -- *****************************************************************
    -- Nombre                     : sp_Cr_LogAqpd152d
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : HENRY SUAREZ
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : ld_fecha, v_hora, ln_inst, TIPOCAMBIO, TIPOCAMBIO, ln_pgcod, ln_pgcod, ln_aosuc, ln_aomod, ln_aomda, ln_aomda, ln_aopap, ln_aocta, ln_aooper, ln_aosbop, ln_aotope, saldo_cap
    --
    -- Retorno                    : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: Procedimiento que inserta en tabla log aqpd152d
    --
    -- *****************************************************************
  
    ln_corr number := 0;
  begin
    begin
      select max(d.aqpd152dcorr)
        into ln_corr
        from aqpd152d d
       where d.aqpd152dinst = ln_inst;
    exception
      when others then
        ln_corr := 0;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    begin
      begin
        insert into aqpd152d
          (aqpd152dcorr,
           aqpd152dfec,
           aqpd152dhor,
           aqpd152dinst,
           aqpd152dtcamb,
           aqpd152dpgcod,
           aqpd152dsuc,
           aqpd152dmod,
           aqpd152dmnd,
           aqpd152dpap,
           aqpd152dcta,
           aqpd152dope,
           aqpd152dsubope,
           aqpd152dtipope,
           aqpd152dsalcp,
           aqpd152destreg)
        values
          (ln_corr + 1,
           ld_fecha,
           v_hora,
           ln_inst,
           TIPOCAMBIO,
           ln_pgcod,
           ln_aosuc,
           ln_aomod,
           ln_aomda,
           ln_aopap,
           ln_aocta,
           ln_aooper,
           ln_aosbop,
           ln_aotope,
           saldo_cap,
           'H');
      exception
        when others then
          null;
      end;
      commit;
    end;
  end sp_Cr_LogAqpd152d;

end pq_cr_monto_consolidado;
/

