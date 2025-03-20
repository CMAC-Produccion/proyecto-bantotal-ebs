create or replace package pq_cr_rt_reprogramacion2 is

  -- Author  : RMONTESR
  -- Created : 21/06/2021 14:55:11
  -- Purpose : Paquete para resolutores de reprogramacion de fondos

  procedure sp_cr_existe_creditocrm(ln_Instancia     in number,
                                     lc_existecredito out char);
                    
  procedure sp_cr_tipo_programa(ln_Instancia     in number,
                                     lv_tipoprograma out varchar2); 
                                     
  procedure sp_cr_perfil(ln_Instancia     in number,
                                     lv_perfil out varchar2);                                                                 

end pq_cr_rt_reprogramacion2;
/

create or replace package body pq_cr_rt_reprogramacion2 is

 procedure sp_cr_existe_creditocrm(ln_Instancia     in number,
                                     lc_existecredito out char) is

    ln_pgcod        number;
    ln_sucursal     number;
    ln_modulo       number;
    ln_moneda       number;
    ln_papel        number;
    ln_cuenta       number;
    ln_operacion    number;
    ln_suboperacion number;
    ln_tipoper      number;
    --ln_creditoscrm  number;
    ln_creditoscrm2 number;

  begin
    begin

      select x.xwfempresa,
             x.xwfsucursal,
             x.xwfmodulo,
             x.xwfmoneda,
             x.xwfpapel,
             x.xwfcuenta,
             x.xwfoperacion,
             x.xwfsubope,
             x.xwftipope
        into ln_pgcod,
             ln_sucursal,
             ln_modulo,
             ln_moneda,
             ln_papel,
             ln_cuenta,
             ln_operacion,
             ln_suboperacion,
             ln_tipoper
        from xwf700 x
       where x.xwfprcins = ln_Instancia
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
    begin
      select count(*)
        into ln_creditoscrm2
        from (
        SELECT F.NUEVATASA
               ln_tasa
        FROM FONDOS G, FONDOS_CREDITOSFACILIDAD F
        WHERE F.IDFONDO = G.IDFONDO
        AND G.ESTADOSOLICITUD = 'BT'
         AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) = ln_cuenta
         AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION, '-') + 1, 99) = ln_operacion
         AND F.EMPRESA = ln_pgcod
         AND F.SUCURSAL = ln_sucursal
         AND F.MODULO = ln_modulo
         AND F.MONEDA = ln_moneda
         AND F.PAPEL = ln_papel
         AND F.SUBOPERACION = ln_suboperacion
         AND F.TIPOOPERACION = ln_tipoper
           ) t;
     exception
      when others then
        ln_creditoscrm2 := 0;
    end;

    /*begin
      select count(*)
        into ln_creditoscrm
        from (select *
                FROM --USRWEBCRM.
                REPROG L
               WHERE L.ESTADOSOLICITUD = 'BT'
                 AND SUBSTR(L.CUENTAOPERACION,
                            0,
                            INSTR(L.CUENTAOPERACION, '-') - 1) = ln_cuenta
                 AND SUBSTR(L.CUENTAOPERACION,
                            INSTR(L.CUENTAOPERACION, '-') + 1,
                            99) = ln_operacion) t;
    exception
      when others then
        ln_creditoscrm := 0;
    end;*/
    if ln_creditoscrm2 > 0 then
      lc_existecredito := 'S';
    else
      lc_existecredito := 'N';
    end if;

  end sp_cr_existe_creditocrm;
  -----------------------------------------------------------------------------------------------
   procedure sp_cr_tipo_programa(ln_Instancia     in number,
                                     lv_tipoprograma out varchar2) is

    ln_pgcod        number;
    ln_sucursal     number;
    ln_modulo       number;
    ln_moneda       number;
    ln_papel        number;
    ln_cuenta       number;
    ln_operacion    number;
    ln_suboperacion number;
    ln_tipoper      number;
    

  begin
    begin

      select x.xwfempresa,
             x.xwfsucursal,
             x.xwfmodulo,
             x.xwfmoneda,
             x.xwfpapel,
             x.xwfcuenta,
             x.xwfoperacion,
             x.xwfsubope,
             x.xwftipope
        into ln_pgcod,
             ln_sucursal,
             ln_modulo,
             ln_moneda,
             ln_papel,
             ln_cuenta,
             ln_operacion,
             ln_suboperacion,
             ln_tipoper
        from xwf700 x
       where x.xwfprcins = ln_Instancia
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
    begin
      
        SELECT F.tipoprograma into
               lv_tipoprograma
        FROM FONDOS G, FONDOS_CREDITOSFACILIDAD F
        WHERE F.IDFONDO = G.IDFONDO
        AND G.ESTADOSOLICITUD = 'BT'
         AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) = ln_cuenta
         AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION, '-') + 1, 99) = ln_operacion
         AND F.EMPRESA = ln_pgcod
         AND F.SUCURSAL = ln_sucursal
         AND F.MODULO = ln_modulo
         AND F.MONEDA = ln_moneda
         AND F.PAPEL = ln_papel
         AND F.SUBOPERACION = ln_suboperacion
         AND F.TIPOOPERACION = ln_tipoper ;
     exception
      when others then
        lv_tipoprograma := '';
    end;  
    
  end sp_cr_tipo_programa;
  -----------------------------------------------------------------------------------------------
   procedure sp_cr_perfil(ln_Instancia     in number,
                                     lv_perfil out varchar2) is

    ln_pgcod        number;
    ln_sucursal     number;
    ln_modulo       number;
    ln_moneda       number;
    ln_papel        number;
    ln_cuenta       number;
    ln_operacion    number;
    ln_suboperacion number;
    ln_tipoper      number;
    

  begin
    begin

      select x.xwfempresa,
             x.xwfsucursal,
             x.xwfmodulo,
             x.xwfmoneda,
             x.xwfpapel,
             x.xwfcuenta,
             x.xwfoperacion,
             x.xwfsubope,
             x.xwftipope
        into ln_pgcod,
             ln_sucursal,
             ln_modulo,
             ln_moneda,
             ln_papel,
             ln_cuenta,
             ln_operacion,
             ln_suboperacion,
             ln_tipoper
        from xwf700 x
       where x.xwfprcins = ln_Instancia
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
    begin
      
        SELECT F.perfil into
               lv_perfil
        FROM FONDOS G, FONDOS_CREDITOSFACILIDAD F
        WHERE F.IDFONDO = G.IDFONDO
        AND G.ESTADOSOLICITUD = 'BT'
         AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) = ln_cuenta
         AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION, '-') + 1, 99) = ln_operacion
         AND F.EMPRESA = ln_pgcod
         AND F.SUCURSAL = ln_sucursal
         AND F.MODULO = ln_modulo
         AND F.MONEDA = ln_moneda
         AND F.PAPEL = ln_papel
         AND F.SUBOPERACION = ln_suboperacion
         AND F.TIPOOPERACION = ln_tipoper ;
     exception
      when others then
        lv_perfil := '';
    end;  
    
  end sp_cr_perfil;
end pq_cr_rt_reprogramacion2;
/

