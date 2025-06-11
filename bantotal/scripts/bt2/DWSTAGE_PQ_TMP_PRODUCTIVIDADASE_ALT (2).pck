create or replace package PQ_TMP_PRODUCTIVIDADASE is

  -- Author  : PVARGAS
  -- Created : 10/04/2022 01:24:52 p.m.
  -- Purpose : PRoductividad de Ejecutivos e Incentivos
  
  -- Author  : PVARGAS
  -- Updated : 2023.09.20
  -- Purpose : PRoductividad de Ejecutivos e Incentivos nueva version 2023
  
  -- Author  : PVARGAS
  -- Updated : 2024.08.19
  -- Purpose : En crecimiento eliminar la restrición de fecha de apertura
  
  -- Author  : PVARGAS
  -- Updated : 2024.10.20
  -- Purpose : Adecuación de ajuste de metas por ausencias prolongadas en el 
  --           porceso SP_PRAS_LoGROS_V5    

  ------------------------------------------------------------------------------------------------------------------
  Procedure SP_START_PRODUC_ASESOR(PD_FECHA In Date);
  
  ------------------------------------------------------------------------------------------------------------------
  Procedure SP_LLENAR_ASIGCLI(PD_FECHA In Date);
  FUNCTION fn_tipo_cambio_fijo(P_FECHA in date) return number;
  ------------------------------------------------------------------------------------------------------------------
  Procedure SP_DESEM_CUENTA(PD_FECDIA In Varchar2);
  PROCEDURE SP_JOB_DESEM_CUENTA(PD_FECHA In Date);
  ------------------------------------------------------------------------------------------------------------------
  Procedure SP_GET_SLD_ASESOR_CLI(PD_FECINI In Date, PD_FECFIN In Date);
  
  ------------------------------------------------------------------------------------------------------------------
  Procedure SP_GET_SLD_ASESOR_CLICAP(PD_FECINI In Date, PD_FECFIN In Date);
    
  ------------------------------------------------------------------------------------------------------------------
  Procedure SP_GET_PRODUC_ASESOR(PD_FECINI In Date, PD_FECFIN In Date);

  ------------------------------------------------------------------------------------------------------------------
  Procedure SP_CALCULAR_SALDOS(PD_FECINI In Date, PD_FECFIN In Date);
    
  ------------------------------------------------------------------------------------------------------------------
  FUNCTION FN_ASESOR_REG_CLIENTE(PN_PAIS        IN NUMBER,
                                 PN_TDOC        IN NUMBER,
                                 PC_NDOC        IN CHAR,
                                 PN_CLIENTE_KEY IN NUMBER,
                                 PD_FINI        IN DATE,
                                 PD_FFIN        IN DATE) RETURN VARCHAR2;
                                 
  ------------------------------------------------------------------------------------------------------------------
  FUNCTION FN_CLIENTE_RECAUDACION(PN_PAIS        IN NUMBER,
                                  PN_TDOC        IN NUMBER,
                                  PC_NDOC        IN CHAR,
                                  PN_CLIENTE_KEY IN NUMBER) RETURN VARCHAR2;
                                  
  ------------------------------------------------------------------------------------------------------------------
  FUNCTION FN_OBTENER_DESEMBOLSO(PN_CUENTA      IN NUMBER,
                                 PD_FECHA       IN DATE) RETURN NUMBER;
  FUNCTION FN_COD_AGENCIA(PC_CODANA In Varchar2) Return Number;                               
 ------------------------------------------------------------------------------------------------------------------
  PROCEDURE SP_PRAS_EJECUTA (PD_FECHA IN DATE);
  PROCEDURE SP_PRAS_ASIGNACION(PD_FECHA IN DATE);
  PROCEDURE SP_PRAS_MANTENIMIENTO(PD_FECHA IN DATE);
  PROCEDURE SP_PRAS_ACT_TITULARES;
  PROCEDURE SP_PRAS_CAPTACIONES(PD_FECHA In Date);
  PROCEDURE SP_PRAS_ACT_DESEMBOLSOS(PD_FECHA IN DATE);
  PROCEDURE SP_PRAS_SALDOAVANCE(PD_FECHA IN DATE);
  PROCEDURE SP_PRAS_LOGROS(PD_FECHA IN DATE);
  
 ------------------------------------------------------------------------------------------------------------------  
  Function FN_NOMBRE_CLIENTE(PN_PAIS IN Number,PN_TDOC in Number, PV_NDOC In Varchar2)
  Return Varchar2;
  PROCEDURE SP_INC_EJECUTA(PD_FECHA In Date);
  PROCEDURE SP_INC_METAS(PD_FECHA In Date);
  PROCEDURE SP_INC_REGCLI(PD_FECDIA In Date);
  PROCEDURE SP_INC_SALDOS(PD_FECDIA IN Date);
  PROCEDURE SP_INC_SALDOMETA_AGEN(PD_FECHA in Date,PD_FECMET out Date, PN_INDMET out Number);
  PROCEDURE SP_INC_CLASIFICA_DEP(PD_FECDIA In Date);
  PROCEDURE SP_INC_APERTURA_DIG(PD_FECDIA In Date);
  PROCEDURE SP_INC_ACT_METAS_AGENCIAS(PD_FECDIA In Date);
  PROCEDURE SP_INC_INSSDOMET_AGE(PD_FECHA In DATE);
  PROCEDURE SP_INC_RESULTADOS(PD_FECHA In Date);
  PROCEDURE SP_INC_RETENCION(PD_FECHA In Date);
  
  PROCEDURE SP_INC_SALDOS_AGE(PD_FECHA In Date);
  PROCEDURE SP_INC_RESULTADOS_AGE(PD_FECHA In date);
  
  PROCEDURE SP_REGISTRO_CLIENTES(PD_FECHA In Date);
  FUNCTION FN_CARGO(PV_CODUSU In Varchar2,PN_PERIOD In Number) RETURN Varchar2;
  
  FUNCTION FN_TIPO_ANALISTA(PN_PAIS In Number, PN_TDOC In Number, 
                            PV_NUMDOC In Varchar2, PD_FECHA In Date)
  Return Number;
  
  FUNCTION FN_CODAGE_ANALISTA(PN_PAIS In Number, PN_TDOC In Number, 
                              PV_NUMDOC In Varchar2, PD_FECHA In Date,
                              PN_CODAGE In Number)
  Return Number;
  Procedure SP_FACT_PRODASE_RENDPF(PD_FECHA In Date);
  
  --> Version V2023
  PROCEDURE SP_INC_METAS_V2023(PD_FECHA In Date);
  PROCEDURE SP_INC_ACT_METAAGE_V2023(PD_FECDIA In Date);
  PROCEDURE SP_INC_RESULTADOS_OPE_V2023(PD_FECHA In Date);
  PROCEDURE SP_INC_RESULTADOS_NEG_V2023(PD_FECHA In Date);
  PROCEDURE SP_INC_SALDOS_AGE_V2023(PD_FECHA In Date);
  PROCEDURE SP_INC_EJECUTA_V2023(PD_FECHA In Date);
  PROCEDURE SP_INC_RESULTADOS_AGE_V2023(PD_FECHA In date);
  PROCEDURE SP_INC_RETENCION_V2023(PD_FECHA In Date);
  
  PROCEDURE SP_EJECUTA_PRODEJE_INCEN(PD_FECHA In date);
  PROCEDURE SP_JOB_PRODEJE(PV_FECHA In Varchar2);
  PROCEDURE SP_JOB_INCENTIVOS(PV_FECHA In Varchar2);
  --< Version V2023
  
  --> Version V4 2023 EJECUTIVOS
  Procedure SP_PRAS_METAS(PD_FECHA In Date);
  PROCEDURE SP_PRAS_LOGROS_V4(PD_FECHA IN DATE);
  FUNCTION FN_PRAS_SALDO_DESFASE(PN_TIEMPO In Number, 
                                 PD_FECSDO In Date,
                                 PN_ASEKEY In Number,
                                 PN_TIPREG In Number,
                                 PN_NIVEJE In Number,
                                 PN_INDDES In Number,
                                 PN_IMPDES In Number 
                                )
  RETURN Number;
  --< Version V4 2023 EJECUTIVOS
  PROCEDURE SP_PRAS_LOGROS_V5(PD_FECHA IN DATE);
  PROCEDURE SP_PRAS_COPIA_RENOV(PD_FECHA In Date, PN_TIPCAM In Number);
  PROCEDURE SP_PRAS_LOGRO_JEF(PD_FECHA In Date);
  
  --> 2024.02.28 CAPTACIONES con saldo base dia anterior a la captacion 
  PROCEDURE SP_PRAS_CAPTACIONES_BASE_DIAANT(PD_FECHA In Date);
  PROCEDURE SP_PRAS_RENOV_ASESOR(PD_FECHA In Date, PN_TIPCAM In Number, PV_CODASE In Varchar2);
 ------------------------------------------------------------------------------------------------------------------    
end PQ_TMP_PRODUCTIVIDADASE;
/
create or replace package body PQ_TMP_PRODUCTIVIDADASE is
  ------------------------------------------------------------------------------------------------------------------
  FUNCTION fn_tipo_cambio_fijo(P_FECHA in date) return number
  is
    ln_tipcam fsh005.cotcbi@produ%type;
  Begin
       Select cotcbi
         Into ln_tipcam
         From (
                 select u.cotcbi
                   From fsh005@produ u
                  Where moneda=101
                    And cofdes <= P_FECHA
               Order by cofdes desc
              )
        Where rownum = 1;

       Return ln_tipcam;
  Exception when others then
            return 0;
  end fn_tipo_cambio_fijo;
  ------------------------------------------------------------------------------------------------------------------  
  Function FN_NOMBRE_CLIENTE(PN_PAIS IN Number,PN_TDOC in Number, PV_NDOC In Varchar2)
  Return Varchar2
  Is   
    lv_nomcli varchar2(200);
  Begin
      Select cl.nombre_cliente Into lv_nomcli
        From tmp_dm_cliente cl
        where cl.pais = PN_PAIS
          and to_number(cl.tipo_documento) = PN_TDOC
          and trim(cl.numero_documento) = trim(PV_NDOC);
       Return lv_nomcli;
  Exception When Others Then
       Return Null;        
  End FN_NOMBRE_CLIENTE;         
  ------------------------------------------------------------------------------------------------------------------
  FUNCTION FN_COD_AGENCIA(PC_CODANA In Varchar2) Return Number
  IS
    ln_codsuc number(4);        
  Begin  
       Begin
         Select to_number(ge.codigo_agencia) Into ln_codsuc 
           From Jaqy830@produ pr
           JOIN dwhouse.dm_geografia ge 
             on upper(trim(ge.nombre_agencia)) = trim(upper(pr.jaqy830agen))
          where jaqy830est='S' 
            and trim(jaqy830codana) = TRIM(PC_CODANA)
            and tipo_region = 'R';
       Exception When Others Then
          ln_codsuc := Null;
       End;
       
       If ln_codsuc Is Null Then
          Begin
             Select ubsuc Into ln_codsuc
               From fst046@produ
              Where ubuser = trim(PC_CODANA);
          Exception When Others Then
             ln_codsuc := Null;
          End;
       End If;
       
       Return nvl(ln_codsuc,0);
       
  END FN_COD_AGENCIA;     
  ------------------------------------------------------------------------------------------------------------------
  Procedure SP_DESEM_CUENTA(PD_FECDIA In Varchar2)
  Is
  ------
  --- DESEMBOLSO EN CUENTA
  ------
      ld_feccie date := to_date(PD_FECDIA,'rrrrmmdd');
      PD_FECCIE date := last_day(add_months(ld_feccie,-1));
      ld_feiman date := to_date(to_char(ld_feccie,'rrrrmm')||'01','rrrrmmdd');
  Begin      
      Execute Immediate 'Truncate table TMP_TRX_DESEM_CUENTA';
      Loop  
        Insert into TMP_TRX_DESEM_CUENTA
                   (pgcod, hcmod, hsucor, htran, hnrel, hfcon, 
                    husing, hmodul, htoper, hsucur, hrubro, hmda, 
                    hpap, hcta, hoper, hsubop, hcimp1, hcodmo
                   )
            Select c.pgcod,c.hcmod,c.hsucor,c.htran,c.hnrel,c.hfcon,c.husing,d.hmodul,
                   d.htoper,d.hsucor,d.hrubro,d.hmda,d.hpap,d.hcta,d.hoper,d.hsubop,
                   d.hcimp1,d.hcodmo 
              FRom fsh015@produ c 
              Join fsh016@produ d on d.pgcod = c.pgcod and d.hcmod = c.hcmod
               and d.hsucor = c.hsucor and d.htran=c.htran 
               and d.hnrel = c.hnrel and d.hfcon = c.hfcon 
             Where c.hfcon = ld_feiman
               and c.hccorr = 0
               and d.hcodmo = 2 
               and d.hmodul = 21
               and exists(select 1 from fsh016@produ a
                           where a.pgcod = d.pgcod and a.hcmod = d.hcmod
                             and a.hsucor = d.hsucor and a.htran=d.htran
                             and a.hnrel = d.hnrel and a.hfcon = d.hfcon
                             and substr(a.hrubro,1,4) in ('1411','1414','1421','1424')
                             and a.hcodmo = 1
                          );
           COMMIT;
           ld_feiman := ld_feiman + 1; 
      Exit When ld_feiman > ld_feccie ;
      End Loop;
  END SP_DESEM_CUENTA;      
  ------------------------------------------------------------------------------------------------------------------
  Procedure SP_START_PRODUC_ASESOR(PD_FECHA In Date) IS
     --parametros
    ld_fecha   date := PD_FECHA;
    ld_mesant  date := add_months(ld_fecha, -1);
    ld_fecIni1 date := TRUNC(ld_mesant, 'MM');
    ld_fecfin1 date := last_day(ld_fecIni1);
    ld_fecIni2 date := TRUNC(ld_fecha, 'MM');
    ld_fecFin2 date := ld_fecha - 1;
    ln_dia     number(2);
  Begin
    
    ln_dia := EXTRACT(DAY FROM PD_FECHA);
    if ln_dia = 1 then
      ld_mesant  := add_months(ld_fecha, -2);
      ld_fecIni1 := TRUNC(ld_mesant, 'MM');
      ld_fecfin1 := last_day(ld_fecIni1);
      ld_fecIni2 := TRUNC(ld_fecha, 'MM');
      ld_fecFin2 := ld_fecha - 1;
    end if;    
    
    DBMS_OUTPUT.put_line('ld_fecfin1:'||ld_fecfin1);
    DBMS_OUTPUT.put_line('ld_fecFin2:'||ld_fecFin2);
    --DBMS_OUTPUT.put_line(ln_dia);
    --DBMS_OUTPUT.put_line('ld_fecha:'||ld_fecha);
    --DBMS_OUTPUT.put_line('ld_fecIni1:'||ld_fecIni1);
    --DBMS_OUTPUT.put_line('ld_fecfin1:'||ld_fecfin1);
    --DBMS_OUTPUT.put_line('ld_fecIni2:'||ld_fecIni2);
    --DBMS_OUTPUT.put_line('ld_fecFin2:'||ld_fecFin2);
    
    PQ_TMP_PRODUCTIVIDADASE.SP_LLENAR_ASIGCLI(PD_FECHA);
    PQ_TMP_PRODUCTIVIDADASE.SP_GET_SLD_ASESOR_CLI(ld_fecfin1, ld_fecFin2);
    PQ_TMP_PRODUCTIVIDADASE.SP_GET_SLD_ASESOR_CLICAP(ld_fecfin1, ld_fecFin2);
    PQ_TMP_PRODUCTIVIDADASE.SP_GET_PRODUC_ASESOR(ld_fecfin1, ld_fecFin2);
    PQ_TMP_PRODUCTIVIDADASE.SP_CALCULAR_SALDOS(ld_fecfin1, ld_fecFin2);
    
  End SP_START_PRODUC_ASESOR;

------------------------------------------------------------------------------------------------------------------ 
 Procedure SP_LLENAR_ASIGCLI(PD_FECHA In Date)
 Is
   ld_mesant date := last_day(add_months(PD_FECHA,-1));
   ld_diauno date := ld_mesant + 1;
   ln_tiekey number(10) := dwhouse.pq_carga_facts.fn_tiempo_key(ld_diauno);
   ln_peract number(6) := to_number(to_char(trunc(sysdate),'RRRRMM'));
   ln_perpro number(6) := to_number(to_char(PD_FECHA,'RRRRMM')); 
   lv_fecdat varchar2(10); 
   lv_script varchar2(1000); 
 Begin
     Execute Immediate 'Truncate table TMP_EXT_JAQL061';
     lv_script := 'Insert Into TMP_EXT_JAQL061('||
                   'jaql61pgco, jaql61pais, jaql61tdoc, jaql61ndoc,'|| 
                   'jaql61user, jaql61fech, jaql61au01, jaql61au02,'|| 
                   'jaql61au03, jaql61au04, jaql61au05, jaql61au06,'|| 
                   'jaql61au07, jaql61au08, jaql61esta) '||
                   'Select jaql61pgco, jaql61pais, jaql61tdoc, jaql61ndoc,'|| 
                   'jaql61user, jaql61fech, jaql61au01, jaql61au02,'|| 
                   'jaql61au03, jaql61au04, jaql61au05, jaql61au06,'|| 
                   'jaql61au07, jaql61au08, jaql61esta ';
                                    
     If ln_peract > ln_perpro Then
        lv_fecdat := to_char(last_day(add_months(trunc(sysdate),-1)),'rrrrmmdd');
        lv_script := lv_script ||'From dwbkext.JAQL061_'||lv_fecdat;
     Else
        lv_script := lv_script ||'From dwextra.JAQL061';
     End If; 
     lv_script := lv_script ||' Where jaql61esta = ''S'' and (trim(jaql61user) is not null or trim(jaql61user) <> ''SIN ASESOR'')';
     
     Execute Immediate lv_script;
     
     /*
     begin--02.07.2021
       DBMS_STATS.gather_table_stats(ownname          => 'DWSTAGE',
                                     tabname          => 'TMP_EXT_JAQL061',
                                     degree           => 20,
                                     granularity      => 'ALL',
                                     estimate_percent => 100,
                                     cascade          => TRUE);
     end;
     */
 Exception When Others Then
     Null; 
 End SP_LLENAR_ASIGCLI;

  ------------------------------------------------------------------------------------------------------------------
  Procedure SP_GET_SLD_ASESOR_CLI(PD_FECINI In Date, PD_FECFIN In Date) IS
    lv_part1   varchar(25);
    lv_part2   varchar(25);
    my_errm    VARCHAR2(32000);
  Begin
    --parametroz
    begin
      lv_part1 := to_char(PD_FECINI, 'rrrrmmdd');
      lv_part2 := to_char(PD_FECFIN, 'rrrrmmdd');
      lv_part1 := 'fact_pasivo_' || lv_part1;
      lv_part2 := 'fact_pasivo_' || lv_part2;
    end;
    --obtención de saldos 
    begin
      DBMS_OUTPUT.put_line('Inicio');
      --Execute Immediate 'Truncate table TMP_FACT_PRODUCASE_TEMP';
      --DBMS_OUTPUT.put_line(
      Execute Immediate 'insert into TMP_FACT_PRODUCASE_TEMP' ||
                        '(FEC_BASE, FEC_AVANCE, FEC_PROCESO, COD_ASESOR, ASESOR_KEY, EST_ASESOR, COD_CLIENTE, CLIENTE_KEY, COD_PRODUCTO, NOM_PRODUCTO, SALDO,' ||
                        ' CUENTA)' ||
                        'select /*all_rows*/ :3, :4, tt.* ' || 
                        'from (' ||
                        '(Select /*+parallel(p,25)*/ t.fecha,' ||
                        '        trim(x.jaql61user), a.asesor_key, x.jaql61esta,' ||
                        '        c.codigo_cliente, p.cliente_key,' ||
                        '        b.codigo_producto,b.nombre_producto,' ||
                        '        sum(p.saldo_mn),' || 
                        '        k.cuenta' ||
                        '  From dwhouse.fact_pasivo partition(' ||lv_part1 || ') p' ||
                        '  Join dwhouse.dm_tiempo t on t.tiempo_key = p.tiempo_key' ||
                        '  Join dwhouse.dm_cliente c on c.cliente_key = p.cliente_key' ||
                        '  Join dwhouse.dm_producto b on b.producto_key = p.producto_key' ||
                        '  Join dwhouse.dm_empleador e on e.empleador_key = p.empleador_key' ||
                        '  Join dwhouse.dm_cuentas k on k.cuentas_key = p.cuentas_key' ||
                        '  join TMP_EXT_JAQL061 x on x.jaql61pais = c.pais' ||
                        '                        and x.jaql61tdoc = to_number(c.tipo_documento)' ||
                        '                        and trim(x.jaql61ndoc) = trim(c.numero_documento)' ||
                        '  Join dwhouse.dm_asesor a on trim(a.codigo_asesor) = trim(x.jaql61user)' ||
                        ' Where t.fecha = :1' ||
                        '   and p.estado_key <> 72' ||
                        '   and x.jaql61esta = ''S'' ' ||
                        ' group by t.fecha,trim(x.jaql61user), a.asesor_key, x.jaql61esta,c.codigo_cliente, p.cliente_key,b.codigo_producto, b.nombre_producto, k.cuenta)' ||
                        'union' || 
                        '(Select /*+parallel(p,25)*/ t.fecha,' ||
                        '        trim(x.jaql61user), a.asesor_key, x.jaql61esta,' ||
                        '        c.codigo_cliente, p.cliente_key,' ||
                        '        b.codigo_producto, b.nombre_producto,' ||
                        '        sum(p.saldo_mn), ' ||
                        '        k.cuenta' ||
                        '   From dwhouse.fact_pasivo partition(' ||lv_part2 || ') p' ||
                        '   Join dwhouse.dm_tiempo t on t.tiempo_key = p.tiempo_key' ||
                        '   Join dwhouse.dm_cliente c on c.cliente_key = p.cliente_key' ||
                        '   Join dwhouse.dm_producto b on b.producto_key = p.producto_key' ||
                        '   Join dwhouse.dm_empleador e on e.empleador_key = p.empleador_key' ||
                        '   Join dwhouse.dm_cuentas k on k.cuentas_key = p.cuentas_key' ||
                        '   join TMP_EXT_JAQL061 x on x.jaql61pais = c.pais' ||
                        '                         and x.jaql61tdoc = to_number(c.tipo_documento)' ||
                        '                         and trim(x.jaql61ndoc) = trim(c.numero_documento)' ||
                        '   Join dwhouse.dm_asesor a on trim(a.codigo_asesor) = trim(x.jaql61user)' ||
                        ' Where t.fecha = :2' ||
                        '    and p.estado_key <> 72' ||
                        '    and x.jaql61esta = ''S'' ' ||
                        'group by t.fecha,trim(x.jaql61user), a.asesor_key, x.jaql61esta,c.codigo_cliente, p.cliente_key,b.codigo_producto, b.nombre_producto, k.cuenta)) tt'
        Using PD_FECINI, PD_FECFIN, PD_FECINI, PD_FECFIN;
      --);
      commit;
      DBMS_OUTPUT.put_line('fin');
    Exception
      When Others Then
        my_errm := SQLERRM;
        DBMS_OUTPUT.put_line('SP_GET_SLD_ASESOR_CLI - my_errm: ' || my_errm);
        --DBMS_OUTPUT.put_line('ERROR');
    End;
  End SP_GET_SLD_ASESOR_CLI;

  ------------------------------------------------------------------------------------------------------------------
  Procedure SP_GET_SLD_ASESOR_CLICAP(PD_FECINI In Date, PD_FECFIN In Date) IS
    lv_part1   varchar(25);
    lv_part2   varchar(25);
    my_errm    VARCHAR2(32000);
    query      VARCHAR2(32767);
  Begin
    --parametroz
    begin
      lv_part1 := to_char(PD_FECINI, 'rrrrmmdd');
      lv_part2 := to_char(PD_FECFIN, 'rrrrmmdd');
      lv_part1 := 'fact_pasivo_' || lv_part1;
      lv_part2 := 'fact_pasivo_' || lv_part2;
    end;
    --obtención de saldos 
    begin
      DBMS_OUTPUT.put_line('Inicio');
      Execute Immediate 'insert into TMP_FACT_PRODUCASE_TEMP' ||
                        '(FEC_BASE, FEC_AVANCE, CAPTADO, FEC_PROCESO, COD_ASESOR, ASESOR_KEY, EST_ASESOR, COD_CLIENTE, CLIENTE_KEY, COD_PRODUCTO, NOM_PRODUCTO, SALDO, ' ||
                        ' CUENTA)' ||
                        'select /*all_rows*/ :1, :2, ''C'', tt.* ' || 
                        'from ( ' ||
                        'Select /*+parallel(p,25)*/ t.fecha, ' ||
                        '        trim(z.jaql108usu), a.asesor_key, ''S'', ' ||
                        '        c.codigo_cliente, p.cliente_key, ' ||
                        '        b.codigo_producto, b.nombre_producto, ' ||
                        '        sum(p.saldo_mn), ' ||
                        '        k.cuenta' ||
                        '   From dwhouse.fact_pasivo partition(' ||lv_part2 || ') p ' ||
                        '   Join dwhouse.dm_tiempo t on t.tiempo_key = p.tiempo_key ' ||
                        '   Join dwhouse.dm_cliente c on c.cliente_key = p.cliente_key ' ||
                        '   Join dwhouse.dm_producto b on b.producto_key = p.producto_key ' ||
                        '   Join dwhouse.dm_empleador e on e.empleador_key = p.empleador_key ' ||
                        '   Join dwhouse.dm_cuentas k on k.cuentas_key = p.cuentas_key ' ||
                        '   join dwextra.jaql108 z on z.jaql108pai = c.pais ' ||
                        '                         and z.jaql108ptd = c.tipo_docum ' ||
                        '                         and trim(z.jaql108doc) = trim(c.numero_documento) ' ||
                        '                         and Z.jaql108fch between :3 and :4 ' ||
                        '   Join dwhouse.dm_asesor a on trim(a.codigo_asesor) = trim(z.jaql108usu) ' ||
                        '  Where t.fecha = :5 ' ||
                        '    and p.estado_key <> 72 ' ||
                        '    and (p.asesor_key, p.cliente_key) not in  '||
                        '        (select f.asesor_key, f.cliente_key '||
                        '           from tmp_fact_producase_temp f '||
                        '          where f.fec_proceso = :6 '||
                        '            and f.fec_base    = :7 '||
                        '            and f.fec_avance  = :8) '||
                        'group by t.fecha,trim(z.jaql108usu), a.asesor_key, c.codigo_cliente, p.cliente_key,b.codigo_producto, b.nombre_producto, k.cuenta) tt'

        Using PD_FECINI, PD_FECFIN, TRUNC(PD_FECFIN,'MM'), PD_FECFIN, PD_FECFIN, PD_FECFIN, PD_FECINI, PD_FECFIN
        ;

      commit;
      DBMS_OUTPUT.put_line('fin');
    Exception
      When Others Then
        my_errm := SQLERRM;
        DBMS_OUTPUT.put_line('SP_GET_SLD_ASESOR_CLICAP my_errm: ' || my_errm);
    End;
  End SP_GET_SLD_ASESOR_CLICAP;
  
/*  Procedure SP_GET_SLD_ASESOR_CLICAP(PD_FECINI In Date, PD_FECFIN In Date) IS
    lv_part1   varchar(25);
    lv_part2   varchar(25);
    my_errm    VARCHAR2(32000);
    query      VARCHAR2(32767);
  Begin
    --parametroz
    begin
      lv_part1 := to_char(PD_FECINI, 'rrrrmmdd');
      lv_part2 := to_char(PD_FECFIN, 'rrrrmmdd');
      lv_part1 := 'fact_pasivo_' || lv_part1;
      lv_part2 := 'fact_pasivo_' || lv_part2;
    end;
    --obtención de saldos 
    begin
      DBMS_OUTPUT.put_line('Inicio');
      Execute Immediate 'insert into TMP_FACT_PRODUCASE_TEMP' ||
                        '(FEC_BASE, FEC_AVANCE, CAPTADO, FEC_PROCESO, COD_ASESOR, ASESOR_KEY, EST_ASESOR, COD_CLIENTE, CLIENTE_KEY, COD_PRODUCTO, NOM_PRODUCTO, SALDO, ' ||
                        ' CUENTA)' ||
                        'select \*all_rows*\ :1, :2, ''C'', tt.* ' || 
                        'from ( ' ||
                        'Select \*+parallel(p,25)*\ t.fecha, ' ||
                        '        trim(z.jaql108usu), a.asesor_key, ''S'', ' ||
                        '        c.codigo_cliente, p.cliente_key, ' ||
                        '        b.codigo_producto, b.nombre_producto, ' ||
                        '        sum(p.saldo_mn), ' ||
                        '        k.cuenta' ||
                        '   From dwhouse.fact_pasivo partition(' ||lv_part2 || ') p ' ||
                        '   Join dwhouse.dm_tiempo t on t.tiempo_key = p.tiempo_key ' ||
                        '   Join dwhouse.dm_cliente c on c.cliente_key = p.cliente_key ' ||
                        '   Join dwhouse.dm_producto b on b.producto_key = p.producto_key ' ||
                        '   Join dwhouse.dm_empleador e on e.empleador_key = p.empleador_key ' ||
                        '   Join dwhouse.dm_cuentas k on k.cuentas_key = p.cuentas_key ' ||
                        '   join dwextra.jaql108 z on z.jaql108pai = c.pais ' ||
                        '                         and z.jaql108ptd = c.tipo_docum ' ||
                        '                         and trim(z.jaql108doc) = trim(c.numero_documento) ' ||
                        '                         and Z.jaql108fch between :3 and :4 ' ||
                        '   Join dwhouse.dm_asesor a on trim(a.codigo_asesor) = trim(z.jaql108usu) ' ||
                        '  Where t.fecha = :5 ' ||
                        '    and p.estado_key <> 72 ' ||
                        'group by t.fecha,trim(z.jaql108usu), a.asesor_key, c.codigo_cliente, p.cliente_key,b.codigo_producto, b.nombre_producto, k.cuenta) tt'
        Using PD_FECINI, PD_FECFIN, TRUNC(PD_FECFIN,'MM'), PD_FECFIN, PD_FECFIN;
        
      query:='insert into TMP_FACT_PRODUCASE_TEMP' ||
                        '(FEC_BASE, FEC_AVANCE, FEC_PROCESO, COD_ASESOR, ASESOR_KEY, EST_ASESOR, COD_CLIENTE, CLIENTE_KEY, COD_PRODUCTO, NOM_PRODUCTO, SALDO, ' ||
                        ' CUENTA)' ||
                        'select \*all_rows*\ '''||TO_CHAR(PD_FECINI, 'dd/mm/yyyy')||''', '''||TO_CHAR(PD_FECFIN, 'dd/mm/yyyy')||''', tt.* ' || 
                        'from ( ' ||
                        'Select \*+parallel(p,25)*\ t.fecha, ' ||
                        '        trim(z.jaql108usu), a.asesor_key, ''S'', ' ||
                        '        c.codigo_cliente, p.cliente_key, ' ||
                        '        b.codigo_producto, b.nombre_producto, ' ||
                        '        sum(p.saldo_mn), ' ||
                        '        k.cuenta' ||
                        '   From dwhouse.fact_pasivo partition(' ||lv_part2 || ') p ' ||
                        '   Join dwhouse.dm_tiempo t on t.tiempo_key = p.tiempo_key ' ||
                        '   Join dwhouse.dm_cliente c on c.cliente_key = p.cliente_key ' ||
                        '   Join dwhouse.dm_producto b on b.producto_key = p.producto_key ' ||
                        '   Join dwhouse.dm_empleador e on e.empleador_key = p.empleador_key ' ||
                        '   Join dwhouse.dm_cuentas k on k.cuentas_key = p.cuentas_key ' ||
                        '   join dwextra.jaql108 z on z.jaql108pai = c.pais ' ||
                        '                         and z.jaql108ptd = c.tipo_docum ' ||
                        '                         and trim(z.jaql108doc) = trim(c.numero_documento) ' ||
                        '                         and Z.jaql108fch between '''||TO_CHAR(TRUNC(PD_FECFIN,'MM'), 'dd/mm/yyyy')||''' and '''||TO_CHAR(PD_FECFIN, 'dd/mm/yyyy') ||''''||
                        '   Join dwhouse.dm_asesor a on trim(a.codigo_asesor) = trim(z.jaql108usu) ' ||
                        '  Where t.fecha = '''||TO_CHAR(PD_FECFIN, 'dd/mm/yyyy')||'''' ||
                        '    and p.estado_key <> 72 ' ||
                        'group by t.fecha,trim(z.jaql108usu), a.asesor_key, c.codigo_cliente, p.cliente_key,b.codigo_producto, b.nombre_producto, k.cuenta) tt';
        DBMS_OUTPUT.put_line('query: '||query);
        Execute Immediate query;
      commit;
      DBMS_OUTPUT.put_line('fin');
    Exception
      When Others Then
        my_errm := SQLERRM;
        DBMS_OUTPUT.put_line('SP_GET_SLD_ASESOR_CLICAP my_errm: ' || my_errm);
    End;
  End SP_GET_SLD_ASESOR_CLICAP;*/

  ------------------------------------------------------------------------------------------------------------------
  Procedure SP_GET_PRODUC_ASESOR(PD_FECINI In Date, PD_FECFIN In Date) IS
    --parametros
    my_errm    VARCHAR2(32000);
  Begin
    --obtención de saldos 
    begin
      DBMS_OUTPUT.put_line('Inicio');
      --Execute Immediate 'Truncate table TMP_FACT_PRODUCASE';
      INSERT INTO TMP_FACT_PRODUCASE
        (COD_ASESOR, ASESOR_KEY, EST_ASESOR, 
         COD_CLIENTE, CLIENTE_KEY,
         CUENTA,
         FEC_BASE, SLD_BASE, AHO_BASE, CTS_BASE, DPF_BASE,
         FEC_AVANCE, SLD_AVANCE, AHO_AVANCE, CTS_AVANCE, DPF_AVANCE,
         --SLD_CAPTA, AHO_CAPTA,  CTS_CAPTA, DPF_CAPTA,
         FLG_TIPO)
        select trim(nvl(a.COD_ASESOR, b.COD_ASESOR)) COD_ASESOR, nvl(a.ASESOR_KEY, b.ASESOR_KEY) ASESOR_KEY,nvl(a.EST_ASESOR, b.EST_ASESOR) EST_ASESOR,
               nvl(a.COD_CLIENTE, b.COD_CLIENTE) COD_CLIENTE,nvl(a.CLIENTE_KEY, b.CLIENTE_KEY) CLIENTE_KEY,
               nvl(a.CUENTA, b.CUENTA) CUENTA,
               nvl(a.fec_proceso, PD_FECINI) fec_base, sum((a.AHORROS + a.CTS + a.DPF)) sld_base, sum(a.AHORROS) AHORROS_base, sum(a.CTS) CTS_base, sum(a.DPF) DPF_base,
               nvl(b.fec_proceso, PD_FECFIN) fec_avance, sum((b.AHORROS + b.CTS + b.DPF)) sld_avance, sum(b.AHORROS) AHORROS_avance, sum(b.CTS) CTS_avance, sum(b.DPF) DPF_avance,
               --                                          sum((b.AHORROS + b.CTS + b.DPF)) sld_cap, sum(b.AHORROS) AHORROS_cap, sum(b.CTS) , sum(b.DPF) DPF_cap,
               CASE PQ_TMP_PRODUCTIVIDADASE.FN_ASESOR_REG_CLIENTE(NULL,
                                                                  NULL,
                                                                  NULL,
                                                                  nvl(a.CLIENTE_KEY,b.CLIENTE_KEY),
                                                                  TRUNC(PD_FECFIN,'MM'), --ld_fecFin1,
                                                                  PD_FECFIN)
                 WHEN '-' THEN PQ_TMP_PRODUCTIVIDADASE.FN_CLIENTE_RECAUDACION(NULL,
                                                                              NULL,
                                                                              NULL,
                                                                              nvl(a.CLIENTE_KEY,
                                                                              b.CLIENTE_KEY))
                 WHEN TRIM(nvl(a.COD_ASESOR, b.COD_ASESOR)) THEN
                                                              case 
                                                                when (select count(*)
                                                                        from TMP_FACT_PRODUCASE_TEMP p
                                                                       where p.fec_base = PD_FECINI
                                                                         and p.fec_avance = PD_FECFIN
                                                                         and p.CLIENTE_KEY = nvl(a.CLIENTE_KEY,b.CLIENTE_KEY)
                                                                         and p.captado = 'N'
                                                                         and p.cod_asesor <> TRIM(nvl(a.COD_ASESOR, b.COD_ASESOR))) > 0  
                                                                    then 'N'
                                                                ELSE 'C'
                                                              end
                 ELSE 
                   case 
                     when nvl(a.captado, b.captado) = 'N' then null
                     when nvl(a.captado, b.captado) = 'C' then 'N'
                   end
               END flg_tipo
          from (select x.COD_ASESOR, x.ASESOR_KEY, x.EST_ASESOR,
                       x.COD_CLIENTE, x.CLIENTE_KEY,
                       x.Cuenta, x.captado,
                       x.fec_proceso,
                       sum(case when COD_PRODUCTO = 21 then SALDO else 0 end) AHORROS,
                       sum(case when COD_PRODUCTO = 211 then SALDO else 0 end) CTS,
                       sum(case when COD_PRODUCTO = 22 then SALDO else 0 end) DPF
                  from (select /*+ INDEX (TMP_FACT_PRODUCASE_TEMP TMP_FACT_PRODUCASE_TEMP5) */ p.fec_proceso,
                               p.COD_ASESOR, p.ASESOR_KEY, p.EST_ASESOR,
                               p.COD_CLIENTE, p.CLIENTE_KEY,
                               p.Cuenta, p.captado,
                               p.cod_producto, p.saldo                               
                          from TMP_FACT_PRODUCASE_TEMP p
                         where p.fec_proceso = PD_FECINI
                           and p.fec_base = PD_FECINI
                           and p.fec_avance = PD_FECFIN
                         ) x
                      group by x.fec_proceso, 
                               x.COD_ASESOR, x.ASESOR_KEY, x.EST_ASESOR,
                               x.COD_CLIENTE, x.CLIENTE_KEY,
                               x.Cuenta, x.captado) a
          full join 
               (select y.COD_ASESOR, y.ASESOR_KEY, y.EST_ASESOR,
                       y.COD_CLIENTE, y.CLIENTE_KEY,
                       y.Cuenta, y.captado,
                       y.fec_proceso,
                       sum(case when COD_PRODUCTO = 21 then SALDO else 0 end) AHORROS,
                       sum(case when COD_PRODUCTO = 211 then SALDO else 0 end) CTS, 
                       sum(case when COD_PRODUCTO = 22 then SALDO else 0 end) DPF
                  from (select /*+ INDEX (TMP_FACT_PRODUCASE_TEMP TMP_FACT_PRODUCASE_TEMP5) */ p.fec_proceso,
                               p.COD_ASESOR, p.ASESOR_KEY, p.EST_ASESOR,
                               p.COD_CLIENTE, p.CLIENTE_KEY, 
                               p.Cuenta, p.captado,
                               p.cod_producto, p.saldo
                          from TMP_FACT_PRODUCASE_TEMP p
                          where p.fec_proceso = PD_FECFIN
                            and p.fec_base = PD_FECINI
                            and p.fec_avance = PD_FECFIN
                          ) y
                       group by y.COD_ASESOR, y.ASESOR_KEY, y.EST_ASESOR,
                                y.COD_CLIENTE, y.CLIENTE_KEY,
                                y.Cuenta, y.captado,
                                y.fec_proceso) b
            on a.COD_ASESOR = b.COD_ASESOR
           and a.ASESOR_KEY = b.ASESOR_KEY
           and a.EST_ASESOR = b.EST_ASESOR
           and a.COD_CLIENTE = b.COD_CLIENTE
           and a.CLIENTE_KEY = b.CLIENTE_KEY
           and a.CUENTA      = b.CUENTA
      group by nvl(a.COD_ASESOR, b.COD_ASESOR), nvl(a.ASESOR_KEY, b.ASESOR_KEY),nvl(a.EST_ASESOR, b.EST_ASESOR),
               nvl(a.COD_CLIENTE, b.COD_CLIENTE),nvl(a.CLIENTE_KEY, b.CLIENTE_KEY),               
               nvl(a.CUENTA, b.CUENTA), 
               nvl(a.fec_proceso, PD_FECINI),
               nvl(b.fec_proceso, PD_FECFIN),
               nvl(a.captado, b.captado);
      DBMS_OUTPUT.put_line('fin');
      commit;
    Exception
      When Others Then
        my_errm := SQLERRM;
        DBMS_OUTPUT.put_line('SP_GET_PRODUC_ASESOR my_errm: ' || my_errm);
    End;
  End SP_GET_PRODUC_ASESOR;
/*  Procedure SP_GET_PRODUC_ASESOR(PD_FECINI In Date, PD_FECFIN In Date) IS
    --parametros
    my_errm    VARCHAR2(32000);
  Begin
    --obtención de saldos 
    begin
      DBMS_OUTPUT.put_line('Inicio');
      --Execute Immediate 'Truncate table TMP_FACT_PRODUCASE';
      INSERT INTO TMP_FACT_PRODUCASE
        (COD_ASESOR, ASESOR_KEY, EST_ASESOR, 
         COD_CLIENTE, CLIENTE_KEY,
         CUENTA,
         FEC_BASE, SLD_BASE, AHO_BASE, CTS_BASE, DPF_BASE,
         FEC_AVANCE, SLD_AVANCE, AHO_AVANCE, CTS_AVANCE, DPF_AVANCE,
         SLD_CAPTA, AHO_CAPTA,  CTS_CAPTA, DPF_CAPTA,
         FLG_TIPO)
        select trim(nvl(a.COD_ASESOR, b.COD_ASESOR)) COD_ASESOR, nvl(a.ASESOR_KEY, b.ASESOR_KEY) ASESOR_KEY,nvl(a.EST_ASESOR, b.EST_ASESOR) EST_ASESOR,
               nvl(a.COD_CLIENTE, b.COD_CLIENTE) COD_CLIENTE,nvl(a.CLIENTE_KEY, b.CLIENTE_KEY) CLIENTE_KEY,
               nvl(a.CUENTA, b.CUENTA) CUENTA,
               nvl(a.fec_proceso, PD_FECINI) fec_base, sum((a.AHORROS + a.CTS + a.DPF)) sld_base, sum(a.AHORROS) AHORROS_base, sum(a.CTS) CTS_base, sum(a.DPF) DPF_base,
               nvl(b.fec_proceso, PD_FECFIN) fec_avance, sum((b.AHORROS + b.CTS + b.DPF)) sld_avance, sum(b.AHORROS) AHORROS_avance, sum(b.CTS) CTS_avance, sum(b.DPF) DPF_avance,
                                              sum((b.AHORROS + b.CTS + b.DPF)) sld_cap, sum(b.AHORROS) AHORROS_cap, sum(b.CTS) , sum(b.DPF) DPF_cap,
               CASE PQ_TMP_PRODUCTIVIDADASE.FN_ASESOR_REG_CLIENTE(NULL,
                                                                  NULL,
                                                                  NULL,
                                                                  nvl(a.CLIENTE_KEY,b.CLIENTE_KEY),
                                                                  TRUNC(PD_FECFIN,'MM'), --ld_fecFin1,
                                                                  PD_FECFIN)
                 WHEN '-' THEN PQ_TMP_PRODUCTIVIDADASE.FN_CLIENTE_RECAUDACION(NULL,
                                                                              NULL,
                                                                              NULL,
                                                                              nvl(a.CLIENTE_KEY,
                                                                              b.CLIENTE_KEY))
                 WHEN TRIM(nvl(a.COD_ASESOR, b.COD_ASESOR)) THEN
                                                              case 
                                                                when nvl(a.captado, b.captado) = 'N' then null
                                                                when nvl(a.captado, b.captado) = 'C' then
                                                                                                       case
                                                                                                         when (select count(*)
                                                                                                                 from TMP_FACT_PRODUCASE_TEMP p
                                                                                                                where p.fec_base = PD_FECINI
                                                                                                                  and p.fec_avance = PD_FECFIN
                                                                                                                  and p.CLIENTE_KEY = nvl(a.CLIENTE_KEY,b.CLIENTE_KEY)--915584
                                                                                                                  and p.captado = 'N') > 0 
                                                                                                               then 'N'
                                                                                                         else 'C'
                                                                                                       end
                                                              end
                 ELSE 
                   case 
                     when nvl(a.captado, b.captado) = 'N' then null
                     when nvl(a.captado, b.captado) = 'C' then 'N'
                   end
               END flg_tipo
          from (select x.COD_ASESOR, x.ASESOR_KEY, x.EST_ASESOR,
                       x.COD_CLIENTE, x.CLIENTE_KEY,
                       x.Cuenta, x.captado,
                       x.fec_proceso,
                       sum(case when COD_PRODUCTO = 21 then SALDO else 0 end) AHORROS,
                       sum(case when COD_PRODUCTO = 211 then SALDO else 0 end) CTS,
                       sum(case when COD_PRODUCTO = 22 then SALDO else 0 end) DPF
                  from (select \*+ INDEX (TMP_FACT_PRODUCASE_TEMP TMP_FACT_PRODUCASE_TEMP5) *\ p.fec_proceso,
                               p.COD_ASESOR, p.ASESOR_KEY, p.EST_ASESOR,
                               p.COD_CLIENTE, p.CLIENTE_KEY,
                               p.Cuenta, p.captado,
                               p.cod_producto, p.saldo                               
                          from TMP_FACT_PRODUCASE_TEMP p
                         where p.fec_proceso = PD_FECINI
                           and p.fec_base = PD_FECINI
                           and p.fec_avance = PD_FECFIN
                         ) x
                      group by x.fec_proceso, 
                               x.COD_ASESOR, x.ASESOR_KEY, x.EST_ASESOR,
                               x.COD_CLIENTE, x.CLIENTE_KEY,
                               x.Cuenta, x.captado) a
          full join 
               (select y.COD_ASESOR, y.ASESOR_KEY, y.EST_ASESOR,
                       y.COD_CLIENTE, y.CLIENTE_KEY,
                       y.Cuenta, y.captado,
                       y.fec_proceso,
                       sum(case when COD_PRODUCTO = 21 then SALDO else 0 end) AHORROS,
                       sum(case when COD_PRODUCTO = 211 then SALDO else 0 end) CTS, 
                       sum(case when COD_PRODUCTO = 22 then SALDO else 0 end) DPF
                  from (select \*+ INDEX (TMP_FACT_PRODUCASE_TEMP TMP_FACT_PRODUCASE_TEMP5) *\ p.fec_proceso,
                               p.COD_ASESOR, p.ASESOR_KEY, p.EST_ASESOR,
                               p.COD_CLIENTE, p.CLIENTE_KEY, 
                               p.Cuenta, p.captado,
                               p.cod_producto, p.saldo
                          from TMP_FACT_PRODUCASE_TEMP p
                          where p.fec_proceso = PD_FECFIN
                            and p.fec_base = PD_FECINI
                            and p.fec_avance = PD_FECFIN
                          ) y
                       group by y.COD_ASESOR, y.ASESOR_KEY, y.EST_ASESOR,
                                y.COD_CLIENTE, y.CLIENTE_KEY,
                                y.Cuenta, y.captado,
                                y.fec_proceso) b
            on a.COD_ASESOR = b.COD_ASESOR
           and a.ASESOR_KEY = b.ASESOR_KEY
           and a.EST_ASESOR = b.EST_ASESOR
           and a.COD_CLIENTE = b.COD_CLIENTE
           and a.CLIENTE_KEY = b.CLIENTE_KEY
           and a.CUENTA      = b.CUENTA
      group by nvl(a.COD_ASESOR, b.COD_ASESOR), nvl(a.ASESOR_KEY, b.ASESOR_KEY),nvl(a.EST_ASESOR, b.EST_ASESOR),
               nvl(a.COD_CLIENTE, b.COD_CLIENTE),nvl(a.CLIENTE_KEY, b.CLIENTE_KEY),               
               nvl(a.CUENTA, b.CUENTA), 
               nvl(a.fec_proceso, PD_FECINI),
               nvl(b.fec_proceso, PD_FECFIN),
               nvl(a.captado, b.captado);
      DBMS_OUTPUT.put_line('fin');
      commit;
    Exception
      When Others Then
        my_errm := SQLERRM;
        DBMS_OUTPUT.put_line('SP_GET_PRODUC_ASESOR my_errm: ' || my_errm);
    End;
  End SP_GET_PRODUC_ASESOR;*/
  
--ANTES DE MOD DE FLAG
/*  Procedure SP_GET_PRODUC_ASESOR(PD_FECINI In Date, PD_FECFIN In Date) IS
    --parametros
    my_errm    VARCHAR2(32000);
  Begin
    --obtención de saldos 
    begin
      DBMS_OUTPUT.put_line('Inicio');
      --Execute Immediate 'Truncate table TMP_FACT_PRODUCASE';
      INSERT INTO TMP_FACT_PRODUCASE
        (COD_ASESOR, ASESOR_KEY, EST_ASESOR, 
         COD_CLIENTE, CLIENTE_KEY,
         CUENTA,
         FEC_BASE, SLD_BASE, AHO_BASE, CTS_BASE, DPF_BASE,
         FEC_AVANCE, SLD_AVANCE, AHO_AVANCE, CTS_AVANCE, DPF_AVANCE,
         SLD_CAPTA, AHO_CAPTA,  CTS_CAPTA, DPF_CAPTA,
         FLG_TIPO)
        select trim(nvl(a.COD_ASESOR, b.COD_ASESOR)) COD_ASESOR, nvl(a.ASESOR_KEY, b.ASESOR_KEY) ASESOR_KEY,nvl(a.EST_ASESOR, b.EST_ASESOR) EST_ASESOR,
               nvl(a.COD_CLIENTE, b.COD_CLIENTE) COD_CLIENTE,nvl(a.CLIENTE_KEY, b.CLIENTE_KEY) CLIENTE_KEY,
               nvl(a.CUENTA, b.CUENTA) CUENTA,
               nvl(a.fec_proceso, PD_FECINI) fec_base, sum((a.AHORROS + a.CTS + a.DPF)) sld_base, sum(a.AHORROS) AHORROS_base, sum(a.CTS) CTS_base, sum(a.DPF) DPF_base,
               nvl(b.fec_proceso, PD_FECFIN) fec_avance, sum((b.AHORROS + b.CTS + b.DPF)) sld_avance, sum(b.AHORROS) AHORROS_avance, sum(b.CTS) CTS_avance, sum(b.DPF) DPF_avance,
                                              sum((b.AHORROS + b.CTS + b.DPF)) sld_cap, sum(b.AHORROS) AHORROS_cap, sum(b.CTS) , sum(b.DPF) DPF_cap,
               CASE PQ_TMP_PRODUCTIVIDADASE.FN_ASESOR_REG_CLIENTE(NULL,
                                                                  NULL,
                                                                  NULL,
                                                                  nvl(a.CLIENTE_KEY,b.CLIENTE_KEY),
                                                                  TRUNC(PD_FECFIN,'MM'), --ld_fecFin1,
                                                                  PD_FECFIN)
                 WHEN TRIM(nvl(a.COD_ASESOR, b.COD_ASESOR)) THEN 'C'
                 WHEN '-' THEN PQ_TMP_PRODUCTIVIDADASE.FN_CLIENTE_RECAUDACION(NULL,
                                                                              NULL,
                                                                              NULL,
                                                                              nvl(a.CLIENTE_KEY,
                                                                              b.CLIENTE_KEY))
                 ELSE 'N'
               END flg_tipo
          from (select x.COD_ASESOR, x.ASESOR_KEY, x.EST_ASESOR,
                       x.COD_CLIENTE, x.CLIENTE_KEY,
                       x.Cuenta,
                       x.fec_proceso,
                       sum(case when COD_PRODUCTO = 21 then SALDO else 0 end) AHORROS,
                       sum(case when COD_PRODUCTO = 211 then SALDO else 0 end) CTS,
                       sum(case when COD_PRODUCTO = 22 then SALDO else 0 end) DPF
                  from (select \*+ INDEX (TMP_FACT_PRODUCASE_TEMP TMP_FACT_PRODUCASE_TEMP5) *\ p.fec_proceso,
                               p.COD_ASESOR, p.ASESOR_KEY, p.EST_ASESOR,
                               p.COD_CLIENTE, p.CLIENTE_KEY,
                               p.Cuenta,
                               p.cod_producto, p.saldo
                          from TMP_FACT_PRODUCASE_TEMP p
                         where p.fec_proceso = PD_FECINI
                           and p.fec_base = PD_FECINI
                           and p.fec_avance = PD_FECFIN
                         ) x
                      group by x.fec_proceso, 
                               x.COD_ASESOR, x.ASESOR_KEY, x.EST_ASESOR,
                               x.COD_CLIENTE, x.CLIENTE_KEY,
                               x.Cuenta) a
          full join 
               (select y.COD_ASESOR, y.ASESOR_KEY, y.EST_ASESOR,
                       y.COD_CLIENTE, y.CLIENTE_KEY,
                       y.Cuenta,
                       y.fec_proceso,
                       sum(case when COD_PRODUCTO = 21 then SALDO else 0 end) AHORROS,
                       sum(case when COD_PRODUCTO = 211 then SALDO else 0 end) CTS, 
                       sum(case when COD_PRODUCTO = 22 then SALDO else 0 end) DPF
                  from (select \*+ INDEX (TMP_FACT_PRODUCASE_TEMP TMP_FACT_PRODUCASE_TEMP5) *\ p.fec_proceso,
                               p.COD_ASESOR, p.ASESOR_KEY, p.EST_ASESOR,
                               p.COD_CLIENTE, p.CLIENTE_KEY, 
                               p.Cuenta,
                               p.cod_producto, p.saldo
                          from TMP_FACT_PRODUCASE_TEMP p
                          where p.fec_proceso = PD_FECFIN
                            and p.fec_base = PD_FECINI
                            and p.fec_avance = PD_FECFIN
                          ) y
                       group by y.COD_ASESOR, y.ASESOR_KEY, y.EST_ASESOR,
                                y.COD_CLIENTE, y.CLIENTE_KEY,
                                y.Cuenta,
                                y.fec_proceso) b
            on a.COD_ASESOR = b.COD_ASESOR
           and a.ASESOR_KEY = b.ASESOR_KEY
           and a.EST_ASESOR = b.EST_ASESOR
           and a.COD_CLIENTE = b.COD_CLIENTE
           and a.CLIENTE_KEY = b.CLIENTE_KEY
           and a.CUENTA      = b.CUENTA
      group by nvl(a.COD_ASESOR, b.COD_ASESOR), nvl(a.ASESOR_KEY, b.ASESOR_KEY),nvl(a.EST_ASESOR, b.EST_ASESOR),
               nvl(a.COD_CLIENTE, b.COD_CLIENTE),nvl(a.CLIENTE_KEY, b.CLIENTE_KEY),               
               nvl(a.CUENTA, b.CUENTA),
               nvl(a.fec_proceso, PD_FECINI),
               nvl(b.fec_proceso, PD_FECFIN);
      DBMS_OUTPUT.put_line('fin');
      commit;
    Exception
      When Others Then
        my_errm := SQLERRM;
        DBMS_OUTPUT.put_line('SP_GET_PRODUC_ASESOR my_errm: ' || my_errm);
    End;
  End SP_GET_PRODUC_ASESOR;
*/
  ------------------------------------------------------------------------------------------------------------------
  Procedure SP_CALCULAR_SALDOS(PD_FECINI In Date, PD_FECFIN In Date) IS
    Cursor lst_asesores(fecha1 date, fecha2 date) is
      --select distinct COD_ASESOR, ASESOR_KEY, EST_ASESOR, FEC_BASE, FEC_AVANCE
      select /*+ INDEX (TMP_FACT_PRODUCASE TMP_FACT_PRODUCASE6) */ COD_CLIENTE, CLIENTE_KEY, CUENTA, FEC_BASE, FEC_AVANCE, FLG_TIPO
        from TMP_FACT_PRODUCASE
       where fec_base   = fecha1
         and fec_avance = fecha2
         and CLIENTE_KEY = 915584;--670007;
    ln_cliente     NUMBER(10);
    
    ld_fec_base   date;
    ld_fec_avance date;
  
    ln_sld_base_A    number(16,2);
    ln_sld_avance_A  number(16,2);
    ln_sld_base_C    number(16,2);
    ln_sld_avance_C  number(16,2);
    ln_sld_base_R    number(16,2);
    ln_sld_avance_R  number(16,2);
    ln_total_base    number(16,2);
    ln_total_avance  number(16,2);
    ln_total_general number(16,2);
    
    ln_desem_anterior number(16,2);
    ln_desem_actual   number(16,2);
    
    ln_logro1 number(16,2);
    ln_logro2 number(16,2);
    ln_logro3 number(16,2);
    ln_logro number(16,2);
    my_errm VARCHAR2(32000);
    
    cl_temp number;
    cu_temp number;
    ba_temp date;
    av_temp date;
    fl_temp varchar2(1);
    
    fila    number := 1;
    
  Begin
    --obtención de saldos 
    begin
      DBMS_OUTPUT.put_line('Inicio');
      For i In lst_asesores(PD_FECINI, PD_FECFIN) Loop        
      /*ln_sld_base_A := null;
        ln_sld_avance_A := null;
        ln_sld_base_C := null;
        ln_sld_avance_C := null;
        ln_sld_base_R := null;
        ln_sld_avance_R := null;
        ln_total_base := null;
        ln_total_avance := null;
        ln_total_general := null;
        ln_desem_anterior := null;
        ln_desem_actual := null;
        ln_logro1 := null;
        ln_logro2 := null;
        ln_logro3 := null;
        ln_logro := null;*/
        
        cl_temp := i.cliente_key;
        cu_temp :=  i.CUENTA;
        ba_temp :=  i.fec_base;
        av_temp := i.fec_avance;
        fl_temp := i.FLG_TIPO;
        
        begin
          if i.FLG_TIPO = 'C' then 
            update tmp_fact_producase t
               set t.sld_avance = null,
                   t.aho_avance = null,
                   t.cts_avance = null,
                   t.dpf_avance = null
             where t.cliente_key = i.CLIENTE_KEY
               and t.cuenta      = i.CUENTA
               and t.fec_base    = i.FEC_BASE
               and t.fec_avance  = i.FEC_AVANCE
               and nvl(t.flg_tipo,'-') = nvl(i.FLG_TIPO,'-');
            commit;
          elsif i.FLG_TIPO is null then 
            update tmp_fact_producase t
               set t.sld_capta = null,
                   t.aho_capta = null,
                   t.cts_capta = null,
                   t.dpf_capta = null
             where t.cliente_key = i.CLIENTE_KEY
               and t.cuenta      = i.CUENTA
               and t.fec_base    = i.FEC_BASE
               and t.fec_avance  = i.FEC_AVANCE
               and nvl(t.flg_tipo,'-') = nvl(i.FLG_TIPO,'-');
            commit;
          end if;
        Exception
          When Others Then
            my_errm := SQLERRM;
        End;
        
        --desembolso mes anterior
        ln_desem_anterior := PQ_TMP_PRODUCTIVIDADASE.FN_OBTENER_DESEMBOLSO(i.CUENTA, PD_FECINI);
        --desembolso mes actual
        ln_desem_actual   := PQ_TMP_PRODUCTIVIDADASE.FN_OBTENER_DESEMBOLSO(i.CUENTA, PD_FECFIN);
    
        --monto para el total
        select /*+ INDEX (TMP_FACT_PRODUCASE TMP_FACT_PRODUCASE5) */ t.cliente_key, t.fec_base, t.fec_avance,
               case when t.flg_tipo is null then t.sld_base else 0 end base_1, 
               case when t.flg_tipo is null then t.sld_avance else 0 end avance_1,
               case when t.flg_tipo = 'C' then t.sld_base else 0 end base_2,
               case when t.flg_tipo = 'C' then t.sld_avance else 0 end avance_2,
               case when t.flg_tipo = 'R' then t.cts_base + t.dpf_base else 0 end base_3, 
               case when t.flg_tipo = 'R' then t.cts_avance + t.dpf_avance else 0 end avance_3
          into ln_cliente, ld_fec_base, ld_fec_avance,
               ln_sld_base_A,
               ln_sld_avance_A,
               ln_sld_base_C,
               ln_sld_avance_C,
               ln_sld_base_R,
               ln_sld_avance_R
          from tmp_fact_producase t
         where t.cliente_key       = i.CLIENTE_KEY
           and t.cuenta            = i.CUENTA
           and t.fec_base          = i.FEC_BASE
           and t.fec_avance        = i.FEC_AVANCE
           and nvl(t.flg_tipo,'-') = nvl(i.FLG_TIPO,'-');
         --group by t.cliente_key, t.fec_base, t.fec_avance;
         
        ln_sld_base_A   := nvl(ln_sld_base_A,0);
        ln_sld_base_C   := nvl(ln_sld_base_C,0);
        ln_sld_base_R   := nvl(ln_sld_base_R,0);
        ln_sld_avance_A := nvl(ln_sld_avance_A,0);
        ln_sld_avance_C := nvl(ln_sld_avance_C,0);
        ln_sld_avance_R := nvl(ln_sld_avance_R,0);
         
        ln_total_base    := ln_sld_base_A + ln_sld_base_C + ln_sld_base_R;
        ln_total_avance  := ln_sld_avance_A + ln_sld_avance_C + ln_sld_avance_R;
        ln_total_general := ln_total_avance - ln_total_base;
        
        
        --calcular logro
        --(Saldos Base - Desembolsos mes anterior)
        ln_logro1 := ln_sld_base_A - ln_desem_anterior;
        --(Saldo Avance - desembolsos del mes de proceso)
        ln_logro2 := ln_sld_avance_A - ln_desem_actual;
        --(Saldo captado - importe desembolsado)
        ln_logro3 := ln_sld_avance_C - ln_desem_actual;
        --Logro = (Saldos Base - Desembolsos mes anterior) (Saldo Avance - desembolsos del mes de proceso) + (Saldo captado - importe desembolsado)  
        --Logro = LOGRO1 + LOGRO2 + LOGRO3 
        ln_logro := ln_logro1 + ln_logro2 + ln_logro3;
        
        begin
          update tmp_fact_producase t
             set t.SLD_CAPTA = case when i.FLG_TIPO is null or i.FLG_TIPO = 'R' then null else t.SLD_AVANCE end,
                 t.AHO_CAPTA = case when i.FLG_TIPO is null or i.FLG_TIPO = 'R' then null else t.AHO_AVANCE end,
                 t.CTS_CAPTA = case when i.FLG_TIPO is null or i.FLG_TIPO = 'R' then null else t.CTS_AVANCE end,
                 t.DPF_CAPTA = case when i.FLG_TIPO is null or i.FLG_TIPO = 'R' then null else t.DPF_AVANCE end,
                 
                 t.SLD_AVANCE = case when i.FLG_TIPO is null or i.FLG_TIPO = 'R' then t.SLD_AVANCE else null end,
                 t.AHO_AVANCE = case when i.FLG_TIPO is null or i.FLG_TIPO = 'R' then t.AHO_AVANCE else null end,
                 t.CTS_AVANCE = case when i.FLG_TIPO is null or i.FLG_TIPO = 'R' then t.CTS_AVANCE else null end,
                 t.DPF_AVANCE = case when i.FLG_TIPO is null or i.FLG_TIPO = 'R' then t.DPF_AVANCE else null end,
                 
                 t.FILA_NUM = fila,

                 t.DSM_MES_AN   = ln_desem_anterior, --DESEMBOLSO MES ANTERIOR
                 t.DSM_MES_AC   = case when i.FLG_TIPO is null then ln_desem_actual else 0 end, --DESEMBOLSO MES ACTUAL
                 t.DSM_CAPTA    = case when i.FLG_TIPO = 'C' then ln_desem_actual else 0 end, --DESEMBOLSO CAPTACION
                                 
                 t.TOTAL_BASE   = ln_total_base, --total_base: sld_base1 + sld_base2 (captado) + sld_base3 (recaudador);
                 t.TOTAL_AVANCE = ln_total_avance, --total_avance: sld_avance1 + sld_avance2 (captado) + sld_avance3 (recaudador);
                 t.TOTAL        = ln_total_general, --total: total_avance - total_base
                                 
                 t.LOGRO1       = ln_logro1, --(Saldos Base - Desembolsos mes anterior)
                 t.LOGRO2       = ln_logro2, --(Saldo Avance - desembolsos del mes de proceso)
                 t.LOGRO3       = ln_logro3, --(Saldo captado - importe desembolsado)
                 t.LOGRO        = ln_logro, --Logro = LOGRO1 + LOGRO2 + LOGRO3 
                  
                 t.META         = null
           where t.cliente_key = i.CLIENTE_KEY
             and t.cuenta      = i.CUENTA
             and t.fec_base    = i.FEC_BASE
             and t.fec_avance  = i.FEC_AVANCE
             and nvl(t.flg_tipo,'-') = nvl(i.FLG_TIPO,'-');
          commit;
        Exception
          When Others Then
            my_errm := SQLERRM;
            DBMS_OUTPUT.put_line('cl_temp: '||cl_temp);
            DBMS_OUTPUT.put_line('cu_temp: '||cu_temp);
            DBMS_OUTPUT.put_line('ba_temp: '||ba_temp);
            DBMS_OUTPUT.put_line('av_temp: '||av_temp);
            DBMS_OUTPUT.put_line('fl_temp: '||fl_temp);
            
            DBMS_OUTPUT.put_line('PD_FECINI: '||PD_FECINI);
            DBMS_OUTPUT.put_line('PD_FECFIN: '||PD_FECFIN);
            DBMS_OUTPUT.put_line('SP_CALCULAR_SALDOS my_errm: ' || my_errm);
        End;
        
        fila := fila + 1;
        if fila = 999999999999999999 then
          fila := 1;
        end if;
      end loop;
      DBMS_OUTPUT.put_line('fin');
    Exception
      When Others Then
        my_errm := SQLERRM;
        DBMS_OUTPUT.put_line('cl_temp: '||cl_temp);
        DBMS_OUTPUT.put_line('cu_temp: '||cu_temp);
        DBMS_OUTPUT.put_line('ba_temp: '||ba_temp);
        DBMS_OUTPUT.put_line('av_temp: '||av_temp);
        DBMS_OUTPUT.put_line('fl_temp: '||fl_temp);
        
        DBMS_OUTPUT.put_line('PD_FECINI: '||PD_FECINI);
        DBMS_OUTPUT.put_line('PD_FECFIN: '||PD_FECFIN);
        DBMS_OUTPUT.put_line('SP_CALCULAR_SALDOS my_errm: ' || my_errm);
    End;
  End SP_CALCULAR_SALDOS;

  ------------------------------------------------------------------------------------------------------------------
  FUNCTION FN_ASESOR_REG_CLIENTE(PN_PAIS        IN NUMBER,
                                 PN_TDOC        IN NUMBER,
                                 PC_NDOC        IN CHAR,
                                 PN_CLIENTE_KEY IN NUMBER,
                                 PD_FINI        IN DATE,
                                 PD_FFIN        IN DATE) RETURN VARCHAR2 IS
    my_errm   VARCHAR2(32000);
    ln_period number(6) := to_number(to_char(PD_FFIN, 'rrrrmm'));
  
    ln_pais   NUMBER(4) := PN_PAIS;
    ln_tdoc   NUMBER(4) := PN_TDOC;
    lc_ndoc   CHAR(12) := PC_NDOC;
    PD_FECAGE TIMESTAMP;
    PV_CODASE VARCHAR2(10);
  Begin
    -- Asesor/Analista que lo Registra Primero
    if PN_CLIENTE_KEY IS NULL OR PN_CLIENTE_KEY = 0 THEN
      Begin
        Select trim(jaql108usu), fecha
          Into PV_CODASE, PD_FECAGE
          From (Select j.jaql108usu,
                       to_Date(to_char(j.jaql108fch, 'rrrrmmdd') || ' ' ||
                               j.jaql108a04,
                               'rrrrmmdd hh24:mi:ss') fecha
                  From dwextra.jaql108 j
                 Where j.jaql108pai = ln_pais --x.pais
                   and j.jaql108ptd = ln_tdoc --x.tdoc
                   and j.jaql108doc = lc_ndoc --x.ndoc
                      --and j.jaql108fch between ld_iniman and ld_regcli
                   and j.jaql108fch between PD_FINI and PD_FFIN
                UNION
                Select cusuing, dfeceva
                  from dwextra.acdeval ac
                 where npaicli = ln_pais --x.jaql108pai 
                   and ntipdoc = ln_tdoc --x.jaql108ptd 
                   and cnumdoc = trim(lc_ndoc) --trim(x.jaql108doc)
                      --and d_feceva between ld_iniman and ld_regcli
                   and d_feceva between PD_FINI and PD_FFIN
                   and exists
                 (select 1
                          from dwextra.fst198 u
                         where u.tp1cod = 1
                           and u.tp1cod1 = 10819
                           and u.tp1corr1 = 302
                           and tp1corr3 = ln_period
                           and trim(upper(tp1desc)) = trim(ac.cusuing))
                 Order by 2)
         Where rownum = 1;
      Exception
        When Others Then
          PV_CODASE := null;
          PD_FECAGE := null;
          my_errm   := SQLERRM;
          --DBMS_OUTPUT.put_line('FN_ASESOR_REG_CLIENTE my_errm: '||my_errm);
      end;
    else
      begin
        select d.pais,
               to_number(d.tipo_documento),
               rpad(d.numero_documento, 12, ' ')
          into ln_pais, ln_tdoc, lc_ndoc
          from dwhouse.dm_cliente d
         where d.cliente_key = PN_CLIENTE_KEY;
      Exception
        When Others Then
          ln_pais := null;
          ln_tdoc := null;
          lc_ndoc := null;
      end;
    
      Begin
        Select trim(jaql108usu), fecha
          Into PV_CODASE, PD_FECAGE
          From (Select j.jaql108usu,
                       to_Date(to_char(j.jaql108fch, 'rrrrmmdd') || ' ' ||
                               j.jaql108a04,
                               'rrrrmmdd hh24:mi:ss') fecha
                  From dwextra.jaql108 j
                 Where j.jaql108pai = ln_pais --x.pais
                   and j.jaql108ptd = ln_tdoc --x.tdoc
                   and j.jaql108doc = lc_ndoc --x.ndoc
                      --and j.jaql108fch between ld_iniman and ld_regcli
                   and j.jaql108fch between PD_FINI and PD_FFIN
                UNION
                Select cusuing, dfeceva
                  from dwextra.acdeval ac
                 where npaicli = ln_pais --x.jaql108pai 
                   and ntipdoc = ln_tdoc --x.jaql108ptd 
                   and cnumdoc = trim(lc_ndoc) --trim(x.jaql108doc)
                      --and d_feceva between ld_iniman and ld_regcli
                   and d_feceva between PD_FINI and PD_FFIN
                   and exists
                 (select 1
                          from dwextra.fst198 u
                         where u.tp1cod = 1
                           and u.tp1cod1 = 10819
                           and u.tp1corr1 = 302
                           and tp1corr3 = ln_period
                           and trim(upper(tp1desc)) = trim(ac.cusuing))
                 Order by 2)
         Where rownum = 1;
      Exception
        When Others Then
          PV_CODASE := null;
          PD_FECAGE := null;
          my_errm   := SQLERRM;
          --DBMS_OUTPUT.put_line('FN_ASESOR_REG_CLIENTE my_errm: '||my_errm);
      end;
    end if;
    PV_CODASE := nvl(PV_CODASE,'-');
    RETURN PV_CODASE;
  End FN_ASESOR_REG_CLIENTE;

  ------------------------------------------------------------------------------------------------------------------
  FUNCTION FN_CLIENTE_RECAUDACION(PN_PAIS        IN NUMBER,
                                  PN_TDOC        IN NUMBER,
                                  PC_NDOC        IN CHAR,
                                  PN_CLIENTE_KEY IN NUMBER) RETURN VARCHAR2 IS
    my_errm VARCHAR2(32000);
  
    ln_pais     NUMBER(4) := PN_PAIS;
    ln_tdoc     NUMBER(4) := PN_TDOC;
    lc_ndoc     CHAR(12) := PC_NDOC;
    ln_contador NUMBER(2);
    pc_flg      char(1);
  Begin
    -- Asesor/Analista que lo Registra Primero
    if PN_CLIENTE_KEY IS NULL OR PN_CLIENTE_KEY = 0 THEN
      Begin
        select count(*)
          into ln_contador
          from dwextra.ext_msrecaudacion e
         where e.pais = ln_pais
           and e.tdoc = ln_tdoc
           and e.ndoc = lc_ndoc
           and ind_estado = 1;
      Exception
        When Others Then
          ln_contador := 0;
          my_errm     := SQLERRM;
          --DBMS_OUTPUT.put_line('FN_ASESOR_REG_CLIENTE my_errm: '||my_errm);
      end;
    else
      begin
        select d.pais,
               to_number(d.tipo_documento),
               rpad(d.numero_documento, 12, ' ')
          into ln_pais, ln_tdoc, lc_ndoc
          from dwhouse.dm_cliente d
         where d.cliente_key = PN_CLIENTE_KEY;
      Exception
        When Others Then
          ln_pais := null;
          ln_tdoc := null;
          lc_ndoc := null;
      end;
    
      begin
        select count(*)
          into ln_contador
          from dwextra.ext_msrecaudacion e
         where e.pais = ln_pais
           and e.tdoc = ln_tdoc
           and e.ndoc = rpad(lc_ndoc, 12, ' ')
           and e.ind_estado = 1;
      Exception
        When Others Then
          ln_contador := 0;
          my_errm     := SQLERRM;
          --DBMS_OUTPUT.put_line('FN_ASESOR_REG_CLIENTE my_errm: '||my_errm);
      end;
    end if;
  
    if ln_contador > 0 then
      pc_flg := 'R';
    else
      pc_flg := null;
    end if;
  
    RETURN pc_flg;
  End FN_CLIENTE_RECAUDACION;

  ------------------------------------------------------------------------------------------------------------------
  FUNCTION FN_OBTENER_DESEMBOLSO(PN_CUENTA      IN NUMBER,
                                 PD_FECHA       IN DATE) RETURN NUMBER IS
    my_errm VARCHAR2(32000);
    pn_mnt  NUMBER;
  Begin
    Begin
      select sum(hcimp1)
        into pn_mnt
        from dwextra.fsh015_16 
       where htran = 951
         and hfcon >= TRUNC(PD_FECHA,'MM')
         and hfcon <= PD_FECHA
         and hcta = PN_CUENTA;
    Exception
      When Others Then
        pn_mnt := 0;
        my_errm     := SQLERRM;
        --DBMS_OUTPUT.put_line('FN_ASESOR_REG_CLIENTE my_errm: '||my_errm);
    end;
    pn_mnt := nvl(pn_mnt,0);   
    RETURN pn_mnt;
  End FN_OBTENER_DESEMBOLSO;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- -- --
  PROCEDURE SP_PRAS_EJECUTA(PD_FECHA IN DATE)
  IS
  BEGIN
       PQ_TMP_PRODUCTIVIDADASE.SP_PRAS_ASIGNACION(PD_FECHA);
       PQ_TMP_PRODUCTIVIDADASE.SP_PRAS_MANTENIMIENTO(PD_FECHA);
       --PQ_TMP_DESARROLLO.SP_FACT_PRODASE_RENDPF(PD_FECHA);
       PQ_TMP_PRODUCTIVIDADASE.SP_FACT_PRODASE_RENDPF(PD_FECHA);
       PQ_TMP_PRODUCTIVIDADASE.SP_PRAS_ACT_TITULARES;
       
       PQ_TMP_PRODUCTIVIDADASE.SP_PRAS_CAPTACIONES(PD_FECHA);
       --PQ_TMP_PRODUCTIVIDADASE.SP_PRAS_CAPTACIONES_BASE_DIAANT(PD_FECHA);
       PQ_TMP_PRODUCTIVIDADASE.SP_PRAS_ACT_DESEMBOLSOS(PD_FECHA);
       PQ_TMP_PRODUCTIVIDADASE.SP_PRAS_SALDOAVANCE(PD_FECHA);
       --PQ_TMP_PRODUCTIVIDADASE.SP_PRAS_LOGROS(PD_FECHA); V3
       
       --> 2023.10.30 Nuevo calculo de Renovaciones
       --PQ_TMP_PRODUCTIVIDADASE.SP_PRAS_LOGROS_V4(PD_FECHA);
       PQ_TMP_PRODUCTIVIDADASE.SP_PRAS_LOGROS_V5(PD_FECHA);
       PQ_TMP_PRODUCTIVIDADASE.SP_PRAS_LOGRO_JEF(PD_FECHA);
       --< 2023.10.30
  END SP_PRAS_EJECUTA;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- -- --  
  PROCEDURE SP_PRAS_ASIGNACION(PD_FECHA IN DATE)
  IS
    ld_mesant date := last_day(add_months(PD_FECHA,-1));
    ld_diauno date := ld_mesant + 1;
    ln_tiekey number(10) := dwhouse.pq_carga_facts.fn_tiempo_key(ld_diauno);
    ln_peract number(6) := to_number(to_char(trunc(sysdate-1),'RRRRMM'));
    ln_perpro number(6) := to_number(to_char(PD_FECHA,'RRRRMM')); 
    lv_fecdat varchar2(10); 
    lv_script varchar2(1000); 
  BEGIN
       Execute Immediate 'Truncate table TMP_EXT_JAQL061';
       lv_script := 'Insert Into TMP_EXT_JAQL061('||
                    'jaql61pgco, jaql61pais, jaql61tdoc, jaql61ndoc,'|| 
                    'jaql61user, jaql61fech, jaql61au01, jaql61au02,'|| 
                    'jaql61au03, jaql61au04, jaql61au05, jaql61au06,'|| 
                    'jaql61au07, jaql61au08, jaql61esta) '||
                    'Select jaql61pgco, jaql61pais, jaql61tdoc, jaql61ndoc,'|| 
                    'jaql61user, jaql61fech, jaql61au01, jaql61au02,'|| 
                    'jaql61au03, jaql61au04, jaql61au05, jaql61au06,'|| 
                    'jaql61au07, jaql61au08, jaql61esta ';
                                        
       If ln_peract > ln_perpro Then
          If ln_perpro = 202206 then
             lv_script := lv_script ||'From dwbkext.JAQL061_20220626'; 
          Else
              --lv_fecdat := to_char(last_day(add_months(trunc(sysdate),-1)),'rrrrmmdd');
              lv_fecdat := to_char(PD_FECHA,'RRRRMMDD');
              lv_script := lv_script ||'From dwbkext.JAQL061_'||lv_fecdat;
          End If;
       Else
          lv_script := lv_script ||'From dwextra.JAQL061';
       End If; 
       lv_script := lv_script ||' Where jaql61esta = ''S'' and (trim(jaql61user) is not null or trim(jaql61user) <> ''SIN ASESOR'')';
       lv_script := lv_script ||' and exists (select 1 from dwextra.fst198 '||
                                            ' where tp1cod1 = 10819 '||
                                            ' and tp1corr1 = 35 '||
                                            ' and tp1corr2 = 1 '||
                                            ' and tp1corr3 = '||ln_perpro||
                                            ' and trim(tp1desc) =  trim(jaql61user))';  
       Execute Immediate lv_script;
         
       begin--02.07.2021
           DBMS_STATS.gather_table_stats(ownname          => 'DWSTAGE',
                                         tabname          => 'TMP_EXT_JAQL061',
                                         degree           => 20,
                                         granularity      => 'ALL',
                                         estimate_percent => 100,
                                         cascade          => TRUE);
        end;
  END SP_PRAS_ASIGNACION;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- -- --
  PROCEDURE SP_PRAS_MANTENIMIENTO(PD_FECHA IN DATE)
  IS
    ld_mesant date := last_day(add_months(PD_FECHA,-1));
    ln_mankey number(10) := dwhouse.pq_carga_facts.fn_tiempo_key(ld_mesant);
    ld_diauno date := ld_mesant + 1;
    ln_tiekey number(10) := dwhouse.pq_carga_facts.fn_tiempo_key(ld_diauno);
    ln_peract number(6) := to_number(to_char(trunc(sysdate),'RRRRMM'));
    ln_perpro number(6) := to_number(to_char(PD_FECHA,'RRRRMM')); 
    lv_fecdat varchar2(10); 
    lv_script varchar2(1000);
    lv_error varchar2(200);
  BEGIN
       Execute Immediate 'Truncate table TMP_FACT_PASIVOS_PROASE';
       Execute Immediate 'Truncate table TMP_FACT_PRODASE_ASIGCLI'; 
     
       Execute Immediate 'Insert Into TMP_FACT_PRODASE_ASIGCLI (fecha, codigo_asesor, asesor_key,'|| 
                         'est_asesor, codigo_producto,'||
                         'codigo_subproducto, codigo_empleador,codigo_cliente, saldo_mn,'|| 
                         'saldo_mo, moneda_key, producto_key, empleador_key, cliente_key,'|| 
                         'estado_key, nombre_subproducto, nombre_producto, tiempo_key,'|| 
                         'cuentas_key, codigo_cuenta, fecha_renovaci, fecha_vencimie,'||
                         'Fecha_Cancela, Periodo, Cod_Cuenta, cod_ctacli, pais, tdoc, ndoc,ind_colcaj,GEOGRAFIA_KEY) '||
                         
                       'Select /*+parallel(p,25)*/  :1, trim(x.jaql61user), a.asesor_key, '||
                         '       x.jaql61esta, b.codigo_producto, '||
                         '       b.codigo_subproducto, e.codigo_empleador, c.codigo_cliente, p.saldo_mn, '||
                         '       p.saldo_mo, p.moneda_key, p.producto_key, p.empleador_key, c.cliente_key, '||
                         '       p.estado_key, b.nombre_subproducto, b.nombre_producto, :2, '||
                         '       p.cuentas_key, k.codigo_cuenta, k.fecha_renovaci, k.fecha_vencimie, '||
                         '       k.fecha_cancelac, :3, k.cod_cuenta, k.cuenta, c.pais, c.tipo_docum, c.numero_documento,nvl(c.ind_colbco,''N''),p.GEOGRAFIA_KEY '||
                         'From dwhouse.fact_pasivo partition (fact_pasivo_'||to_char(ld_mesant,'rrrrmmdd')||') p '||
                         'Join dwhouse.dm_producto  b on b.producto_key = p.producto_key '|| 
                         'Join dwhouse.dm_empleador e on e.empleador_key = p.empleador_key '|| 
                         'Join dwhouse.dm_cuentas   k on k.cuentas_key = p.cuentas_key '|| 
                         'Join dwextra.fsr008 r on r.ctnro = k.cuenta '||
                         'Join dwhouse.dm_cliente c on c.pais = r.pepais '|| 
                                                    'and c.tipo_docum = r.petdoc '||
                                                    'and c.numero_documento = r.pendoc '||
                         'Join TMP_EXT_JAQL061 x on x.jaql61pais = c.pais '|| 
                                                    'and x.jaql61tdoc = c.tipo_docum '|| 
                                                    'and trim(x.jaql61ndoc) = trim(c.numero_documento) '|| 
                         'Join dwhouse.dm_asesor    a on trim(a.codigo_asesor) = trim(x.jaql61user) '|| 
                        'Where p.tiempo_key = :4  '||
                          'and p.estado_key <> 72'||  
                          'and x.jaql61esta = ''S'''
       Using ld_diauno,ln_tiekey,ln_perpro,ln_mankey; 
       Commit;        
       
             ----- DPF CREDINKA MIGRADOS EL DIA 09/FEB/2025     
      IF ln_perpro = '202502' Then     
         ld_mesant := to_date('20250209','rrrrmmdd');
         ln_mankey := dwhouse.pq_carga_facts.fn_tiempo_key(ld_mesant);  
         Begin            
             Execute Immediate 'Insert Into TMP_FACT_PRODASE_ASIGCLI (fecha, codigo_asesor, asesor_key,'|| 
                         'est_asesor, codigo_producto,'||
                         'codigo_subproducto, codigo_empleador,codigo_cliente, saldo_mn,'|| 
                         'saldo_mo, moneda_key, producto_key, empleador_key, cliente_key,'|| 
                         'estado_key, nombre_subproducto, nombre_producto, tiempo_key,'|| 
                         'cuentas_key, codigo_cuenta, fecha_renovaci, fecha_vencimie,'||
                         'Fecha_Cancela, Periodo, Cod_Cuenta, cod_ctacli, pais, tdoc, ndoc,ind_colcaj,GEOGRAFIA_KEY) '||
                         
                       'Select  :1, trim(x.jaql61user), a.asesor_key, '||
                         '       x.jaql61esta, b.codigo_producto, '||
                         '       b.codigo_subproducto, e.codigo_empleador, c.codigo_cliente, p.saldo_mn, '||
                         '       p.saldo_mo, p.moneda_key, p.producto_key, p.empleador_key, c.cliente_key, '||
                         '       p.estado_key, b.nombre_subproducto, b.nombre_producto, :2, '||
                         '       p.cuentas_key, k.codigo_cuenta, k.fecha_renovaci, k.fecha_vencimie, '||
                         '       k.fecha_cancelac, :3, k.cod_cuenta, k.cuenta, c.pais, c.tipo_docum, c.numero_documento,nvl(c.ind_colbco,''N''),p.GEOGRAFIA_KEY '||
                         'From dwhouse.fact_pasivo partition (fact_pasivo_'||to_char(ld_mesant,'rrrrmmdd')||') p '||
                         'Join dwhouse.dm_producto  b on b.producto_key = p.producto_key '|| 
                         'Join dwhouse.dm_empleador e on e.empleador_key = p.empleador_key '|| 
                         'Join dwhouse.dm_cuentas   k on k.cuentas_key = p.cuentas_key '|| 
                         'Join dwextra.fsr008 r on r.ctnro = k.cuenta '||
                         'Join dwhouse.dm_cliente c on c.pais = r.pepais '|| 
                                                    'and c.tipo_docum = r.petdoc '||
                                                    'and c.numero_documento = r.pendoc '||
                         'Join TMP_EXT_JAQL061 x on x.jaql61pais = c.pais '|| 
                                                    'and x.jaql61tdoc = c.tipo_docum '|| 
                                                    'and trim(x.jaql61ndoc) = trim(c.numero_documento) '|| 
                         'Join dwhouse.dm_asesor    a on trim(a.codigo_asesor) = trim(x.jaql61user) '|| 
                        'Where p.tiempo_key = :4  '||
                          'and p.estado_key <> 72'||  
                          'and x.jaql61esta = ''S'' '||
                          'and p.cuentas_key in (Select u.cuentas_key from tmp_dm_cuenta c '||
                                                  'Join (select distinct Jaql54scct,Jaql54scop,Jaql54scsb,'||
                                                               'Jaql54scmo,Jaql54scto,Jaql54scmd '||
                                                          'From Jaql054@produ where Jaql54fech = :5 and jaql54scmo = 22) k '||
                                                            'on k.jaql54scct = c.aocta and k.jaql54scop = c.aoope '||
                                                           ' and k.jaql54scsb = c.aosbo and k.jaql54scmo = c.aomod '||
                                                           ' and k.jaql54scto = c.aotop and k.jaql54scmd = c.aomda '||
                                                           'Join dwhouse.dm_cuentas u on u.codigo_cuenta = c.codigo_cuenta '||
                                                            'and u.cuenta_unica = c.cuenta_unica '||
                                                ') '
                          
           Using ld_diauno,ln_tiekey,ln_perpro,ln_mankey,ld_mesant; 
           Commit;
       Exception When Others Then 
           Null;
       End;
      End If;
                
       ---- CLIENTES SIN SALDO A FIN DE MES
       Execute Immediate 'Insert Into TMP_FACT_PRODASE_ASIGCLI (fecha, codigo_asesor, asesor_key,'|| 
                         'est_asesor, codigo_producto,'||
                         'codigo_subproducto, codigo_empleador,codigo_cliente, saldo_mn,'|| 
                         'saldo_mo, producto_key, empleador_key, cliente_key,'|| 
                         'tiempo_key,'|| 
                         'cuentas_key, codigo_cuenta,'||
                         'Periodo, pais, tdoc, ndoc,ind_colcaj,GEOGRAFIA_KEY) '||
                'Select :1,trim(x.jaql61user),a.asesor_key, x.jaql61esta,'||
                      '''0'' codigo_producto, ''0'' codigo_subproducto,'||
                      '''0'' codigo_empleador,c.codigo_cliente codigo_cliente, 0 saldo_mn,'|| 
                      '0 saldo_mo,37 producto_key, 4281 empleador_key, c.cliente_key,'|| 
                      ':2,1404121192 cuentas_key, ''0'' codigo_cuenta,:3,'|| 
                      'c.pais, c.tipo_docum, c.numero_documento,nvl(c.ind_colbco,''N''),'||
                      '117893 GEOGRAFIA_KEY '|| 
                'From TMP_EXT_JAQL061 x '||
                'Join dwhouse.dm_asesor a on trim(a.codigo_asesor) = trim(x.jaql61user) '|| 
                'Join dwhouse.dm_cliente c on c.pais = x.jaql61pais '||  
                                         ' and c.tipo_docum = x.jaql61tdoc '||
                                         ' and c.numero_documento = x.jaql61ndoc '|| 
               'Where x.jaql61esta = ''S'' '||
                'and not exists (select 1 from dwstage.TMP_FACT_PRODASE_ASIGCLI asi '||
                                 'where asi.codigo_asesor = trim(x.jaql61user) '||  
                                   'and asi.pais = x.jaql61pais '||
                                   'and asi.tdoc = x.jaql61tdoc '||
                                   'and trim(asi.ndoc) = trim(x.jaql61ndoc) '||
                                 ')'
      Using ld_diauno,ln_tiekey,ln_perpro;    
            Commit;   
            
                   
      
      

                         
  Exception When Others Then
      lv_error := substr(sqlerrm,1,200);
      dbms_output.put_line( lv_error);     
  End SP_PRAS_MANTENIMIENTO;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE SP_PRAS_ACT_TITULARES
  IS
    Cursor c_ctas is Select distinct cod_ctacli  FRom TMP_FACT_PRODASE_ASIGCLI;
    ln_ccta number(5);
  BEGIN
       For x in c_ctas Loop
           Select count(*) Into ln_ccta
             From dwextra.fsr008 r
            Where r.ctnro = x.cod_ctacli; 
            
           Update TMP_FACT_PRODASE_ASIGCLI 
              set num_intcta = ln_ccta,
                  --> 2023.10.30
                  ind_titren = nvl(ind_titren,ln_ccta) 
                  --< 2023.10.30
            WHere cod_ctacli = x.cod_ctacli;
           Commit;  
       End Loop; 
  End SP_PRAS_ACT_TITULARES;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE SP_PRAS_CAPTACIONES(PD_FECHA In Date)
  IS
    ld_feccon date := PD_FECHA;    
    ld_inimes date := to_date(to_char(ld_feccon,'rrrrmm')||'01','rrrrmmdd');
    ld_iniman date := ld_inimes;
    ln_tipcam number(7,3) := pq_tmp_productividadase.fn_tipo_cambio_fijo(ld_feccon);
    ln_tiemp  number(10)  := dwhouse.pq_carga_facts.fn_tiempo_key(ld_inimes);  
    ln_tiesld number(10)  := dwhouse.pq_carga_facts.fn_tiempo_key(ld_feccon); 
    ln_period number(6)   := to_number(to_char(ld_feccon,'rrrrmm'));
    ln_tieman number(10)  := dwhouse.pq_carga_facts.fn_tiempo_key(last_day(add_months(ld_inimes,-1))); 
    ld_fecact date := trunc(sysdate);
    ld_regcli date := last_day(ld_feccon) + 0; -- Registro de clientes hasta fin de mes
    ln_keycl  number(10); 
    lv_codase varchar2(10);  
    ln_keyase Number(10);    
    ln_tipcli Number(1);    
    ln_nuev   Number(5);
    ln_inac   Number(5);
    ln_vige   Number(5);
    ln_slddpf Number(12,2);     
    ln_sldaho Number(12,2);    
    ln_sldcts Number(12,2);    
    ld_actcta Date;   
    ld_fecape Date;
    ln_ctakey Number(10);
    lv_codcta varchar2(40);
    ln_sldcre number(12,2);
    ln_rucemp varchar2(12);
    ln_empkey number(10);
    ld_feccan date; 
    ld_ultcan date;
    ld_fecage date;
    ld_feccar date := dwextra.pq_tmp_extrae_fuentes.fn_lee_fecha_cierre;
    lv_indcol varchar2(1);  
    lv_msg varchar2(200);
    ln_sldcdpf number(12,2);
    ln_sldcaho number(12,2);
    ln_sldccts number(12,2);
    lv_aseasi  varchar2(12);
    ln_saldo number(12,2);
    ln_indins number(2);
    ln_ininac number(2);
    
    ld_iniape date;
    
    -- Clientes Registrados en Herramienta Autogesti/Agenda Comercial
    Cursor c_cliage(ld_ini in Date, ld_fin in Date,ln_per in Number,ld_fmax in date) is
           SELECT DISTINCT NPAIS jaql108pai,NTDOC jaql108ptd,RPAD(trim(VNDOC),12,' ') jaql108doc,
                             TRIM(NPAIS||NTDOC||VNDOC) codcli,
                             NPAIS pais,NTDOC tdoc,RPAD(trim(VNDOC),12,' ') ndoc
             FROM TMP_AGECOM
            WHERE trunc(feceva) between ld_ini and ld_fmax
             --and trim(VNDOC) = '25482377'
             --and usureg = 'MYDROGO'
            ;
           

                            
    Cursor c_detdep(ln_tie In number,lv_cli In Varchar2,ln_tipc In Number, dFeci in Date)
        Is -->2024.01.01
           Select k.cuentas_key,k.codigo_cuenta,k.cod_cuenta,
                  m.codigo_producto,m.codigo_subproducto,
                  decode(p.moneda_key,1,p.saldo_mo,p.saldo_mo*ln_tipc) saldo,
                  k.fecha_apertura,k.fecha_cancelac,e.ruc,
                  --i.aosuc ln_suc, i.aomda ln_mda, i.aocta ln_cta, i.aoope ln_ope,
                  --i.aosbo ln_sbo,i.aotop ln_top,i.aomod ln_mod,
                  k.cuenta,
                  case when m.codigo_producto = '21' 
                       Then decode(p.moneda_key,1,p.saldo_mo,p.saldo_mo*ln_tipc) else 0 End sldaho,
                  case when m.codigo_producto = '22' 
                       Then decode(p.moneda_key,1,p.saldo_mo,p.saldo_mo*ln_tipc) else 0 End slddpf,  
                  case when m.codigo_producto = '211' 
                       Then decode(p.moneda_key,1,p.saldo_mo,p.saldo_mo*ln_tipc) else 0 End sldcts ,
                       p.estado_key,k.cuenta_unica,
                       (select count(*) from dwextra.fsr008 Where ctnro = k.cuenta) nro_tit 
             From dwhouse.fact_pasivo p
             Join dwhouse.dm_producto m on m.producto_key = p.producto_key
             Join dwhouse.dm_cuentas k on k.cuentas_key = p.cuentas_key
             Join dwhouse.dm_empleador e on e.empleador_key = p.empleador_key  
           Where p.tiempo_key  = ln_tie 
             and p.estado_key <> 72
             and (
                  (fecha_apertura < dFeci) OR
                  (fecha_renovaci < dFeci)
                 ) 
             and exists (select o.cliente_key, r.ctnro
                           from dwhouse.dm_cliente o
                           Join dwextra.fsr008 r on r.pepais = o.pais
                            and r.petdoc = o.tipo_docum
                            and r.pendoc = o.numero_documento
                            where o.codigo_cliente = lv_cli  
                            and r.ctnro = k.cuenta
                        );    
            /*Select k.cuentas_key,k.codigo_cuenta,k.cod_cuenta,
                  m.codigo_producto,m.codigo_subproducto,
                  decode(p.moneda_key,1,p.saldo_mo,p.saldo_mo*ln_tipc) saldo,
                  k.fecha_apertura,k.fecha_cancelac,e.ruc,
                  i.aosuc ln_suc, i.aomda ln_mda, i.aocta ln_cta, i.aoope ln_ope,
                  i.aosbo ln_sbo,i.aotop ln_top,i.aomod ln_mod,k.cuenta,
                  case when m.codigo_producto = '21' 
                       Then decode(p.moneda_key,1,p.saldo_mo,p.saldo_mo*ln_tipc) else 0 End sldaho,
                  case when m.codigo_producto = '22' 
                       Then decode(p.moneda_key,1,p.saldo_mo,p.saldo_mo*ln_tipc) else 0 End slddpf,  
                  case when m.codigo_producto = '211' 
                       Then decode(p.moneda_key,1,p.saldo_mo,p.saldo_mo*ln_tipc) else 0 End sldcts ,
                       p.estado_key,
                       (select count(*) from dwextra.fsr008 Where ctnro = r.ctnro) nro_tit 
             From dwhouse.fact_pasivo p
             Join dwhouse.dm_producto m on m.producto_key = p.producto_key
             Join dwhouse.dm_cuentas k on k.cuentas_key = p.cuentas_key
             Join dwextra.fsr008 r on r.ctnro = k.cuenta
             Join dwhouse.dm_cliente c on c.pais = r.pepais
                                and c.tipo_docum = r.petdoc
                          and c.nro_docum = trim(r.pendoc) 
             Join dwhouse.dm_empleador e on e.empleador_key = p.empleador_key  
             Join dwstage.tmp_dm_cuenta i on i.codigo_cuenta = k.codigo_cuenta
             and i.cuenta_unica = k.cuenta_unica            
           Where p.tiempo_key     = ln_tie 
             and c.codigo_cliente = lv_cli 
             and p.estado_key <> 72;*/
         --<2024.01.01
                                       
    Cursor c_depcap(ln_tie In number,lv_cli In Varchar2,ln_tipc In Number,
                    ld_inif Date,ld_ffi In Date,
                    ln_pai In Number, ln_tdo In Number, lc_ndo In Char)
        Is Select /*+index(temp_fact_saldos,IX_TEMP_FSALDOS_1)*/
                  cuentas_key,codigo_cuenta,cod_cuenta,
                  codigo_producto,codigo_subproducto,
                  saldo,fecha_apertura,fecha_cancelac,ruc,
                  ln_suc, ln_mda, ln_cta, ln_ope,
                  ln_sbo,ln_top,ln_mod,estado_key,nro_tit,  
                  nrotit,cuenta  
             From temp_fact_saldos
            Where tiempo_key = ln_tie 
              and pepais = ln_pai
              and petdoc = ln_tdo
              and pendoc = lc_ndo
              and (estado_key <> 72 
                  and (fecha_cancelac is null or fecha_cancelac > fecha)
                 )
                 
              and (
                   (fecha_apertura between ld_inif and ld_ffi) OR
                   (fecha_renovaci between ld_inif and ld_ffi)
                  ); 
        
        
           /*Select k.cuentas_key,k.codigo_cuenta,k.cod_cuenta,
                  m.codigo_producto,m.codigo_subproducto,
                  decode(p.moneda_key,1,p.saldo_mo,p.saldo_mo*ln_tipc) saldo,
                  k.fecha_apertura,k.fecha_cancelac,e.ruc,
                  i.aosuc ln_suc, i.aomda ln_mda, i.aocta ln_cta, i.aoope ln_ope,
                  i.aosbo ln_sbo,i.aotop ln_top,i.aomod ln_mod,
                  p.estado_key,
                  (select count(*) from dwextra.fsr008 Where  ctnro = r.ctnro) nro_tit,  
                  1 nrotit,k.cuenta     
             From temp_fact_pasivos p --dwhouse.fact_pasivo p
             Join dwhouse.dm_producto m on m.producto_key = p.producto_key
             Join dwhouse.dm_cuentas k on k.cuentas_key = p.cuentas_key
             Join dwextra.fsr008 r on r.ctnro = k.cuenta
             Join dwhouse.dm_empleador e on e.empleador_key = p.empleador_key  
             Join dwstage.tmp_dm_cuenta i on i.codigo_cuenta = k.codigo_cuenta
             Join dwhouse.dm_tiempo tm on tm.tiempo_key = p.tiempo_key
             and i.cuenta_unica = k.cuenta_unica            
           Where p.tiempo_key     = ln_tie 
             --and c.codigo_cliente = lv_cli 
             and r.pepais = ln_pai
             and r.petdoc = ln_tdo
             and r.pendoc = lc_ndo
             and (p.estado_key <> 72 
                  and (k.fecha_cancelac is null or k.fecha_cancelac > tm.fecha)
                 )
             and ((k.fecha_apertura between ld_ini and ld_ffi) OR
                  (k.fecha_renovaci between ld_ini and ld_ffi)
                 );
            -- and not (m.codigo_producto = '21' and m.codigo_subproducto='9');
                */                               
    ln_sldava number(12,2);
    ln_excta number(3);
    ln_sldbas number(12,2);
    ln_codreg number(4);
    ln_codsuc number(4);
    
    ln_clirec number(1);
    lv_clirec varchar2(2);
    
    ln_suc number(5);
    ln_mda number(5);
    ln_cta number(10);
    ln_ope number(10);
    ln_sbo number(5);
    ln_top number(5);
    ln_mod number(5);
    ln_tiedia number(10);
    ln_tiesba number(10);
 Begin
   -- Excepcion solicitada por Karolina solo para Abril 2022 
   IF to_char(ld_feccon,'rrrrmm') <= '202205' Then
      ld_regcli := ld_regcli + 5;
   End IF;
       
   Delete from TMP_FACT_PASIVOS_PROASE where fecha = ld_inimes and nvl(tipreg,0) = 3 and ind_version = 2;
   Commit;

   --- INSERTA DATOS DE FACT_PASIVOS
   Begin
         Execute Immediate 'Truncate table temp_fact_pasivos';
         Execute Immediate 'Insert into temp_fact_pasivos '||
                     '(moneda_key,saldo_mo,estado_key,producto_key,cuentas_key,empleador_key,'||
                      'tiempo_key,cliente_key) '||   
                     'Select moneda_key,saldo_mo,estado_key,producto_key,cuentas_key,empleador_key,'||
                            'tiempo_key,cliente_key  '||
                        'From dwhouse.fact_pasivo partition(fact_pasivo_'||to_char(ld_feccon,'rrrrmmdd')||') '||
                       'Where estado_key <> 72';
         Commit;  
   Exception When Others Then
      Null;
   End;    
   
   --- INSERTA DATOS COMPLETOS
   Begin
         Execute Immediate 'Truncate table temp_fact_saldos';
         Execute Immediate 'Insert into temp_fact_saldos '||
                          '(fecha, cuentas_key, codigo_cuenta, cod_cuenta, codigo_producto, codigo_subproducto,'|| 
                           'saldo, fecha_apertura, fecha_cancelac, ruc, ln_suc, ln_mda, ln_cta, ln_ope, ln_sbo, '||
                           'ln_top, ln_mod, estado_key, nro_tit, nrotit, cuenta, pepais, petdoc, pendoc, '||
                           'fecha_renovaci,sldaho,slddpf,sldcts,codigo_cliente,tiempo_key) '||
                          'Select tm.fecha,k.cuentas_key,k.codigo_cuenta,k.cod_cuenta,'||
                                 'm.codigo_producto,m.codigo_subproducto, '||
                                 'decode(p.moneda_key,1,p.saldo_mo,p.saldo_mo*:1) saldo, '||
                                 'k.fecha_apertura,k.fecha_cancelac,e.ruc, '||
                                 'i.aosuc ln_suc, i.aomda ln_mda, i.aocta ln_cta, i.aoope ln_ope, '||
                                 'i.aosbo ln_sbo,i.aotop ln_top,i.aomod ln_mod, '||
                                 'p.estado_key, '||
                                 '(select count(*) from dwextra.fsr008 Where  ctnro = r.ctnro) nro_tit, '||  
                                 '1 nrotit,k.cuenta     ,r.pepais,r.petdoc,r.pendoc,k.fecha_renovaci, '||
                                 'Case when m.codigo_producto = ''21'' '|| 
                                  'Then decode(p.moneda_key,1,p.saldo_mo,p.saldo_mo*:2) else 0 End, '||
                                 'Case when m.codigo_producto = ''22'' '|| 
                                  'Then decode(p.moneda_key,1,p.saldo_mo,p.saldo_mo*:3) else 0 End, '||  
                                 'Case when m.codigo_producto = ''211'' '||
                                  'Then decode(p.moneda_key,1,p.saldo_mo,p.saldo_mo*:4) else 0 End,'||
                                 'cl.codigo_cliente,p.tiempo_key '|| 
                           'From temp_fact_pasivos p '||             
                           'Join dwhouse.dm_producto m on m.producto_key = p.producto_key '||
                           'Join dwhouse.dm_empleador e on e.empleador_key = p.empleador_key '|| 
                           'Join dwhouse.dm_cuentas k on k.cuentas_key = p.cuentas_key '||
                           'Join dwstage.tmp_dm_cuenta i on i.codigo_cuenta = k.codigo_cuenta '||
                            'and i.cuenta_unica = k.cuenta_unica '||
                           'Join dwextra.fsr008 r on r.ctnro = k.cuenta '|| 
                           'Join dwhouse.dm_tiempo tm on tm.tiempo_key = p.tiempo_key '||
                           'Join dwhouse.dm_cliente cl on cl.cliente_key = p.cliente_key '
                            
         Using ln_tipcam,ln_tipcam,ln_tipcam,ln_tipcam;  
         Commit;  
   Exception When Others Then
      Null;
   End;     
             
   For x in c_cliage(ld_inimes,ld_feccon,ln_period,ld_regcli) Loop
       ln_indins := 0;
       -- ¿ESTA ASIGNADO?
       Begin
           select distinct a.codigo_asesor Into lv_aseasi 
             from TMP_FACT_PRODASE_ASIGCLI a 
            where a.periodo = ln_period
              and a.est_asesor = 'S'
              and a.codigo_cliente = x.codcli;
       Exception When Others Then
            lv_aseasi := Null;
       End;
       
       -- Asesor/Analista que lo Registra Primero
       If ld_feccon <= to_date('20220531','rrrrmmdd') Then
           Begin
                Select trim(jaql108usu),fecha Into lv_codase,ld_fecage
                  From (
                        Select j.jaql108usu,
                               to_Date(to_char(j.jaql108fch,'rrrrmmdd')||' '||j.jaql108a04,'rrrrmmdd hh24:mi:ss') fecha
                          From dwextra.jaql108 j
                         Where j.jaql108pai = x.pais
                           and j.jaql108ptd = x.tdoc
                           and j.jaql108doc = x.ndoc
                           and j.jaql108fch between ld_iniman and ld_regcli
                        UNION ALL
                        Select cusuing,dfeceva
                          from dwextra.acdeval ac 
                         where npaicli=x.jaql108pai 
                           and ntipdoc=x.jaql108ptd 
                           and cnumdoc=trim(x.jaql108doc)
                           and d_feceva between ld_iniman and ld_regcli
                           and exists (select 1 
                                         from dwextra.fst198 u 
                                        where u.tp1cod = 1 
                                          and u.tp1cod1 = 10819 
                                          and u.tp1corr1 = 302
                                          and tp1corr3 = ln_period
                                          and trim(upper(tp1desc))  = trim(ac.cusuing)
                                      )
                        Order by 2
                       )
                 Where rownum = 1;      
           Exception When Others Then
             lv_codase := null;
             ld_fecage := null;
           End;
       Else 
           Begin
                Select USUREG,FECEVA
                  Into lv_codase,ld_fecage
                  From (SELECT UPPER(USUREG) USUREG ,FECEVA
                          FROM TMP_AGECOM
                         where NPAIS=x.pais and NTDOC=x.tdoc 
                           and trim(VNDOC) = trim(x.ndoc)
                         Order by 2
                        ) 
                  Where Rownum = 1;
           Exception When Others Then
             lv_codase := null;
             ld_fecage := null;
           End;
       End If;
                   
       -- TIPO DE CLIENTE
       -- ¿Es Nuevo - integra cuenta cliente?

       -- ES COLABORADOR CAJA
       Begin
         Select nvl(c.pfebco,'N') Into lv_indcol
           From dwextra.fsd002 c
          Where c.pfpais = x.jaql108pai 
            and c.pftdoc = x.jaql108ptd
            and c.pfndoc = x.jaql108doc;
       Exception When Others Then
          lv_indcol := 'N';
       End;   
       
              
       ln_keyase := pq_tmp_carga_key.fn_asesor_key(lv_codase);
       ln_keycl  := pq_tmp_carga_key.fn_cliente_key(x.codcli);
       
       -- Cuentas Aperturadas/Renovadas en el mes en curso
       ln_tiesld := dwhouse.pq_carga_facts.fn_tiempo_key(ld_feccon);
       
       --- CLIENTE RECAUDACION
       ln_clirec := 0;
       lv_clirec:=dwstage.pq_tmp_productividadase.FN_CLIENTE_RECAUDACION(x.jaql108pai,x.jaql108ptd,x.jaql108doc,ln_keycl);
       If lv_clirec = 'R' Then
          ln_clirec := 1;
       End If;        
       
       ld_iniape := null;
       ld_iniape := (trunc(ld_fecage) - 1); 
       ln_tiesba := dwhouse.pq_carga_facts.fn_tiempo_key(ld_iniape);
       For u In c_depcap(ln_tiesld, 
                         x.codcli, 
                         ln_tipcam, 
                         ld_inimes, --ld_iniape, --ld_inimes, 
                         ld_feccon,
                         x.jaql108pai, 
                         x.jaql108ptd, 
                         x.jaql108doc)
          Loop
              ld_actcta := Null;
              ln_saldo  := 0;
              
              Begin
                SELECT SALDO_MN INTO ln_saldo FROM DWHOUSE.FACT_PASIVO 
                WHERE CUENTAS_KEY = u.cuentas_key AND TIEMPO_KEY = ln_tiesba;
              Exception When Others Then
                ln_saldo  := 0;
              End;    

              --- 2021.10.21: REVISAR SI OTRO TITULAR DE LA CUENTA FUE REGISTRADO ANTES EN HA
              ln_excta  := 0;

              --- 2021.08.20 REVISAR SI CUENTA YA FUE CONSIDERADA EN OTRO TITULAR
              ln_sldava := nvl(u.saldo,0);
              --ln_sldava := nvl(u.saldo/u.nrotit,0);
             
              --- 2021.08.20
              --- 2021.10.21----
              Insert Into TMP_FACT_PASIVOS_PROASE(fecha, tiempo_key, 
                                                  codigo_asesor, asesor_key, codigo_cliente, cliente_key,
                                                  periodo, tipreg, codigo_cuenta, ind_ctaren, cod_cuenta, fec_vencta,
                                                  fec_cancela, cuentas_key, val_rucemp, fec_actcta, cod_modcta, 
                                                  cod_topcta, imp_renmn, saldo, fec_heraut, Ind_Colcaj, Fecha_Sld, Imp_Tipcam, Numdoc,
                                                  COD_ASEASI, IND_CTACRE, Codsuc, Regeje, cod_ctacli, num_titcta, ind_clirec,
                                                  ind_version
                                                 )  
                                           Values(ld_inimes, ln_tiemp,
                                                  lv_codase, ln_keyase, x.codcli, ln_keycl,
                                                  ln_period, 3, u.codigo_cuenta, ln_tipcli, u.cod_cuenta, u.fecha_apertura,
                                                  u.fecha_cancelac, u.cuentas_key, u.ruc, ld_actcta, u.codigo_producto,
                                                  u.codigo_subproducto, ln_sldava, ln_saldo, ld_fecage, lv_indcol,
                                                  ld_feccon,ln_tipcam,trim(x.jaql108doc),lv_aseasi,ln_excta,
                                                  ln_codsuc,ln_codreg,u.cuenta,u.nro_tit,ln_clirec,2
                                                 );  
              Commit;    
              ln_indins := 1;                                 
          End Loop;
             
          
          ln_tiedia := dwhouse.pq_carga_facts.fn_tiempo_key(ld_iniape);
          --- Detalle de Cuentas cierre de mes Anterior
          -->2024.01.01
          --For u In c_detdep(ln_tieman,x.codcli,ln_tipcam)Loop
          For u In c_detdep(ln_tiedia,x.codcli,ln_tipcam,ld_inimes)Loop
          --<2024.01.01
              ln_indins := 1;
              ld_actcta := Null;
              
              --->2024.01.01 Datos de cuenta
              /*Begin
                 Select c.aosuc,c.aomda,c.aocta,c.aoope,c.aosbo,c.aotop,c.aomod
                   Into ln_suc,ln_mda,ln_cta,ln_ope,ln_sbo,ln_top,ln_mod
                   From tmp_dm_cuenta c
                  Where c.codigo_cuenta = u.codigo_cuenta
                    and c.cuenta_unica = u.cuenta_unica;
              Exception When Others Then
                 ln_suc:= null; ln_mda:= null; ln_cta:= null; 
                 ln_ope:= null; ln_sbo:= null; ln_top:= null;
                 ln_mod:= null;
              End;   */ 
              ---<2024.01.01

              If ln_indins = 1 Then
                  --- Saldo Avance
                  Begin
                     Select decode(p.moneda_key,1,p.saldo_mo,p.saldo_mo*ln_tipcam) 
                       Into ln_sldcre
                       From dwhouse.fact_pasivo p
                      Where p.tiempo_key = ln_tiesld
                        and p.cuentas_key = u.cuentas_key
                        and p.estado_key <> 72;
                  Exception When Others Then
                    ln_sldcre:= 0;
                  End;  
              
                  --- 2021.08.20 REVISAR SI CUENTA YA FUE CONSIDERADA EN OTRO TITULAR
                  ln_sldava := nvl(ln_sldcre,0);--/u.nrotit;
                  ln_sldbas := nvl(u.saldo,0);--/u.nrotit;
 
                  --- 2021.08.20
              
                  Insert Into TMP_FACT_PASIVOS_PROASE(fecha,tiempo_key,codigo_asesor,asesor_key,codigo_cliente,cliente_key,
                                                  periodo,tipreg,codigo_cuenta,ind_ctaren,cod_cuenta,fec_vencta,
                                                  fec_cancela,cuentas_key,val_rucemp,fec_actcta,cod_modcta,cod_topcta,
                                                  imp_renmn,saldo,fec_heraut,Ind_Colcaj,Fecha_Sld,Imp_Tipcam,Numdoc,
                                                  COD_ASEASI,Codsuc,Regeje,cod_ctacli,Num_Titcta,ind_clirec,ind_version
                                                 )  
                                           Values(ld_inimes,ln_tiemp,lv_codase,ln_keyase,x.codcli,ln_keycl,
                                                  ln_period,3,u.codigo_cuenta,ln_tipcli,u.cod_cuenta,u.fecha_apertura,
                                                  u.fecha_cancelac,u.cuentas_key,u.ruc,ld_actcta,u.codigo_producto,
                                                  u.codigo_subproducto,ln_sldava,ln_sldbas,ld_fecage,lv_indcol,
                                                  ld_feccon,ln_tipcam,trim(x.jaql108doc),lv_aseasi,ln_codsuc,ln_codreg,
                                                  u.cuenta,u.nro_tit,ln_clirec,2
                                                 );  
                  Commit;
                  --ln_indins := 1;  COMENTADO AQUI
              End If;   
              
              -- CAMBIO
              
          End Loop;
          
          -- NO TIENE SALDO ACTUAL NI EN MES ANTERIOR
          If (ln_indins = 0 and trunc(ld_fecage) between ld_inimes and ld_feccon)Then
              ln_saldo := 0;
                  Insert Into TMP_FACT_PASIVOS_PROASE(fecha,tiempo_key,codigo_asesor,asesor_key,codigo_cliente,cliente_key,
                                                      periodo,tipreg,codigo_cuenta,ind_ctaren,cod_cuenta,fec_vencta,
                                                      fec_cancela,cuentas_key,val_rucemp,fec_actcta,cod_modcta,cod_topcta,
                                                      imp_renmn,saldo,fec_heraut,Ind_Colcaj,Fecha_Sld,Imp_Tipcam,Numdoc,
                                                      COD_ASEASI,Codsuc,Regeje,Cod_Ctacli,Num_Titcta,ind_clirec,ind_version
                                                      )  
                                           Values(ld_inimes,ln_tiemp,lv_codase,ln_keyase,x.codcli,ln_keycl,
                                                  ln_period,3,null,ln_tipcli,null,null,
                                                  null,null,null,null,null,
                                                  null,null,ln_saldo,ld_fecage,lv_indcol,
                                                  ld_feccon,ln_tipcam,trim(x.jaql108doc),lv_aseasi,
                                                  ln_codsuc,ln_codreg,null,1,ln_clirec,2
                                                 );  
                    Commit;   
           End If; 
               
      End Loop;     
  END SP_PRAS_CAPTACIONES;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- -- --  
  PROCEDURE SP_PRAS_ACT_DESEMBOLSOS(PD_FECHA IN DATE)
  IS
    Cursor c_ctaasi is 
    Select x.tiempo_key,x.cliente_key,x.cuentas_key,k.aocta,k.aomod,k.aomda,k.aoope,k.aosbo,k.aotop,x.codigo_producto,
           x.pais,x.tdoc,x.ndoc
      from TMP_FACT_PRODASE_ASIGCLI x
      Join dwhouse.dm_cuentas ct on ct.cuentas_key = x.cuentas_key
      Join dwstage.tmp_dm_cuenta k on k.codigo_cuenta = ct.codigo_cuenta and k.cuenta_unica=ct.cuenta_unica;
      
    Cursor c_ctacap is   
    select x.tiempo_key,x.cliente_key,x.cuentas_key,k.aocta,k.aomod,k.aomda,k.aoope,k.aosbo,k.aotop,x.cod_modcta
      from TMP_FACT_PASIVOS_PROASE x
      Join dwhouse.dm_cuentas ct on ct.cuentas_key = x.cuentas_key
      Join dwstage.tmp_dm_cuenta k on k.codigo_cuenta = ct.codigo_cuenta and k.cuenta_unica=ct.cuenta_unica
      where ind_version = 2;
      
    ln_desbas number(12,2);
    ln_desava  number(12,2); 
    lv_clirec varchar2(2);
    ln_clirec number(1);
    
    ld_factf date := PD_FECHA;    
    ld_facti date := to_date(to_char(ld_factf,'rrrrmm')||'01','rrrrmmdd');
    ld_fantf date := last_day(add_months(ld_factf,-1));
    ld_fanti date := to_date(to_char(ld_fantf,'rrrrmm')||'01','rrrrmmdd');
    
    ln_tcant number(7,3) := pq_tmp_productividadase.fn_tipo_cambio_fijo(ld_fantf);
    ln_tcact number(7,3) := pq_tmp_productividadase.fn_tipo_cambio_fijo(ld_factf);
    
  BEGIN
    For x in c_ctaasi Loop
        ln_desava := 0;
        ln_desbas := 0;
        lv_clirec := dwstage.pq_tmp_productividadase.FN_CLIENTE_RECAUDACION(x.pais,x.tdoc,x.ndoc,x.cliente_key);
        If lv_clirec = 'R' Then ln_clirec := 1; else ln_clirec :=0; end If;
        
        If x.codigo_producto = '21' Then 
        --- Importe de desembolso mes anterior
        ln_desbas := 0;
        /*Begin
             Select sum(decode(ds.hmda,0,ds.hcimp1,ds.hcimp1*ln_tcant))
                Into ln_desbas
                from dwstage.Tmp_Trx_Desem_Cuenta ds
               Where ds.hfcon between ld_fanti and ld_fantf
                 and ds.hmodul = x.aomod
                 and ds.htoper = x.aotop
                 and ds.hmda = x.aomda
                 and ds.hcta = x.aocta
                 and ds.hoper = x.aoope
                 and ds.hsubop = x.aosbo;
        Exception When Others Then
            ln_desbas := 0;
        End;*/
        --- Importe de desembolso mes actual
        Begin
             Select sum(decode(ds.hmda,0,ds.hcimp1,ds.hcimp1*ln_tcact))
                Into ln_desava
                from dwstage.Tmp_Trx_Desem_Cuenta ds
               Where ds.hfcon between ld_facti and ld_factf
                 and ds.hmodul = x.aomod
                 and ds.htoper = x.aotop
                 and ds.hmda = x.aomda
                 and ds.hcta = x.aocta
                 and ds.hoper = x.aoope
                 and ds.hsubop = x.aosbo;
        Exception When Others Then
            ln_desava := 0;
        End;
        End If;
        -- Actualiza
        Update TMP_FACT_PRODASE_ASIGCLI s
           Set s.ind_clirec = ln_clirec,
               s.imp_desbas = ln_desbas,
               s.imp_desava = ln_desava
        Where s.tiempo_key = x.tiempo_key
          and s.cliente_key = x.cliente_key
          and s.cuentas_key = x.cuentas_key;
        Commit;         
    End Loop;
    
    For x in c_ctacap Loop
        ln_desava := 0;
        ln_desbas := 0;
        
        If x.cod_modcta = '21' Then 
        --- Importe de desembolso mes anterior
        ln_desbas := 0;
        /*Begin
             Select sum(decode(ds.hmda,0,ds.hcimp1,ds.hcimp1*ln_tcant))
                Into ln_desbas
                from dwstage.Tmp_Trx_Desem_Cuenta ds
               Where ds.hfcon between ld_fanti and ld_fantf
                 and ds.hmodul = x.aomod
                 and ds.htoper = x.aotop
                 and ds.hmda = x.aomda
                 and ds.hcta = x.aocta
                 and ds.hoper = x.aoope
                 and ds.hsubop = x.aosbo;
        Exception When Others Then
            ln_desbas := 0;
        End;*/
        --- Importe de desembolso mes actual
        Begin
             Select sum(decode(ds.hmda,0,ds.hcimp1,ds.hcimp1*ln_tcact))
                Into ln_desava
                from dwstage.Tmp_Trx_Desem_Cuenta ds
               Where ds.hfcon between ld_facti and ld_factf
                 and ds.hmodul = x.aomod
                 and ds.htoper = x.aotop
                 and ds.hmda = x.aomda
                 and ds.hcta = x.aocta
                 and ds.hoper = x.aoope
                 and ds.hsubop = x.aosbo;
        Exception When Others Then
            ln_desava := 0;
        End;
        
        End If;
        -- Actualiza
        Update TMP_FACT_PASIVOS_PROASE s
           Set s.imp_desbas = ln_desbas,
               s.imp_desava = ln_desava
        Where s.tiempo_key = x.tiempo_key
          and s.cliente_key = x.cliente_key
          and s.cuentas_key = x.cuentas_key
          and s.ind_version = 2;
        Commit;         
    End Loop;
  END SP_PRAS_ACT_DESEMBOLSOS;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- -- -- 
  PROCEDURE SP_PRAS_SALDOAVANCE(PD_FECHA IN DATE)  
  IS
    Cursor c_asesor(ln_per in Number)
       is Select distinct x.codigo_asesor jaql61user, s.ubsuc,
                 to_number(g.Codigo_Region) codreg, x.asesor_key 
            from TMP_FACT_PASIVOS_PROASE x  
            Join dwextra.fst046 s on trim(s.ubuser) = x.codigo_asesor 
            Join dwhouse.dm_geografia g 
              on to_number(g.codigo_agencia) = s.ubsuc
             and g.tipo_region = 'R'
           Where x.est_asesor <> 'N'
             and x.periodo= ln_per
             and x.tipreg = 5
             and x.ind_version = 2;
             
    Cursor c_sldcli (ld_Fec In Date,lc_ase in Varchar2, ln_tie in Number,ln_per In Number)
       is 
       --- CAMBIO: 2022.05.27 Consultar por cliente
       Select t.fecha,p.tiempo_key,c.codigo_cliente,c.cliente_key,x.codigo_asesor,
           x.asesor_key, k.cuenta,
           sum(p.saldo_mn) saldo,
           sum(case when b.codigo_producto = '21' then p.saldo_mn else 0 end) saldo_aho,
           sum(case when b.codigo_producto = '22' then p.saldo_mn else 0 end) saldo_dpf,
           sum(case when b.codigo_producto = '211' then p.saldo_mn else 0 end) saldo_cts
      From dwhouse.fact_pasivo p
      Join dwhouse.dm_tiempo t on t.tiempo_key = p.tiempo_key
      Join dwhouse.dm_producto b on b.producto_key = p.producto_key
      Join dwhouse.dm_cuentas k on k.cuentas_key = p.cuentas_key
      Join dwextra.fsr008 r8 on r8.ctnro = k.cuenta
      Join dwhouse.dm_cliente c on c.pais = r8.pepais
                               and c.tipo_docum = r8.petdoc
                               and c.numero_documento = r8.pendoc  
      Join --TMP_FACT_PASIVOS_PROASE x
      (select distinct codigo_asesor,codigo_cliente,cod_ctacli,ind_version,tipreg,periodo,asesor_key
              from  TMP_FACT_PASIVOS_PROASE
           ) x
        on x.codigo_cliente = c.codigo_cliente and x.cod_ctacli = k.cuenta
     Where p.tiempo_key = ln_tie
       and p.estado_key <> 72  
       and x.codigo_asesor = lc_ase
       and x.tipreg = 5
       and x.periodo = ln_per
       and x.ind_version = 2
     Group by t.fecha,p.tiempo_key,c.codigo_cliente,c.cliente_key,x.codigo_asesor,x.asesor_key,k.cuenta;
      
       /*Select t.fecha,p.tiempo_key,c.codigo_cliente,p.cliente_key,x.codigo_asesor,
           x.asesor_key, k.cuenta,
           sum(p.saldo_mn) saldo,
           sum(case when b.codigo_producto = '21' then p.saldo_mn else 0 end) saldo_aho,
           sum(case when b.codigo_producto = '22' then p.saldo_mn else 0 end) saldo_dpf,
           sum(case when b.codigo_producto = '211' then p.saldo_mn else 0 end) saldo_cts
      From dwhouse.fact_pasivo p
      Join dwhouse.dm_tiempo t on t.tiempo_key = p.tiempo_key
      Join dwhouse.dm_cliente c on c.cliente_key = p.cliente_key
      Join dwhouse.dm_producto b on b.producto_key = p.producto_key
      Join dwhouse.dm_cuentas k on k.cuentas_key = p.cuentas_key
      Join TMP_FACT_PASIVOS_PROASE x
        on x.codigo_cliente = c.codigo_cliente and x.cod_ctacli = k.cuenta
     Where p.tiempo_key = ln_tie
       and p.estado_key <> 72  
       and x.codigo_asesor = lc_ase
       and x.tipreg = 5
       and x.periodo = ln_per
       and x.ind_version = 2
       group by t.fecha,p.tiempo_key,c.codigo_cliente,p.cliente_key,x.codigo_asesor,x.asesor_key,k.cuenta;
       */
       --- CAMBIO: 2022.05.27 Consultar por cliente
    Cursor c_sldnue (ld_Fec In Date,lc_ase in Varchar2, ln_tie in Number,ln_per In Number, ld_Ini In Date)
       is  Select t.fecha,p.tiempo_key,c.codigo_cliente,c.cliente_key,
                  k.cuenta,sum(p.saldo_mn) saldo,
                  sum(case when b.codigo_producto = 21 then p.saldo_mn else 0 end) saldo_aho,
                  sum(case when b.codigo_producto = 22 then p.saldo_mn else 0 end) saldo_dpf,
                  sum(case when b.codigo_producto = 211 then p.saldo_mn else 0 end) saldo_cts,
                  (select count(*) from dwextra.fsr008 i where i.ctnro = k.cuenta) numtit,
                  kk.aomod,kk.aotop,kk.aomda,kk.aoope,kk.aosbo,
                  nvl(c.ind_colbco,'N') ind_colcaj
             From dwhouse.fact_pasivo p
             Join dwhouse.dm_tiempo t on t.tiempo_key = p.tiempo_key
             Join dwhouse.dm_producto b on b.producto_key = p.producto_key
             Join dwhouse.dm_cuentas k on k.cuentas_key = p.cuentas_key
             Join dwstage.tmp_dm_cuenta kk on kk.codigo_cuenta = k.codigo_cuenta
              and kk.cuenta_unica = k.cuenta_unica 
             Join dwextra.fsr008 r8 on r8.ctnro = k.cuenta
             Join dwhouse.dm_cliente c on c.pais = r8.pepais
                                       and c.tipo_docum = r8.petdoc
                                       and c.numero_documento = r8.pendoc  
     Where p.tiempo_key = ln_tie
       and p.estado_key <> 72  
       and ((k.fecha_apertura between ld_Ini and ld_Fec) OR (k.fecha_renovaci between ld_Ini and ld_Fec))
       and c.codigo_cliente in (select codigo_cliente from TMP_FACT_PASIVOS_PROASE
                                 where codigo_asesor = lc_ase 
                                   and periodo = ln_per 
                                   and tipreg = 5 and ind_version = 2
                                )
       and not exists (select 1 from TMP_FACT_PASIVOS_PROASE x 
                        Where x.codigo_cliente = c.codigo_cliente
                          and x.cod_Ctacli = k.cuenta and  x.tipreg = 5
                          and x.periodo = ln_per
                          and x.ind_version = 2
                       )
      group by  t.fecha,p.tiempo_key,c.codigo_cliente,c.cliente_key, k.cuenta,
                kk.aomod,kk.aotop,kk.aomda,kk.aoope,kk.aosbo, nvl(c.ind_colbco,'N');
          
    ld_feccon date := PD_FECHA;                                 
    ld_inimes date :=  to_date(to_char(ld_feccon,'rrrrmm')||'01','rrrrmmdd');
    ln_period  number(6) := to_number(to_char(ld_feccon,'rrrrmm'));
    ln_keymet number(10) := dwhouse.pq_carga_facts.fn_tiempo_key(ld_inimes);  
    ld_keysld number(10) := dwhouse.pq_carga_facts.fn_tiempo_key(ld_feccon);
    ln_tcam   number(7,3):= pq_tmp_productividadase.fn_tipo_cambio_fijo(ld_feccon);
    ln_desava number(12,2);
    ---> 2024.05.27
    cursor c_dup is 
        select distinct cod_ctacli,codigo_cliente,codigo_asesor
        from TMP_FACT_PASIVOS_PROASE 
        where cod_ctacli in (
        select distinct cod_ctacli
        from TMP_FACT_PASIVOS_PROASE
        where num_titcta  <> ind_titren
        and tipreg = 1
        and nvl(imp_logren,0) <> 0
        ) and  tipreg = 1;
    nAho number(12,2):= 0;  
    nDpf number(12,2):= 0; 
    nCts number(12,2):= 0;  
    nTit number(5);
    ---< 2024.05.27
   BEGIN
          -- Inserta ctas de clientes asignados
          Delete from TMP_FACT_PASIVOS_PROASE where periodo = ln_period and tipreg = 5 and ind_version = 2;
          Commit;
       
      Insert Into TMP_FACT_PASIVOS_PROASE(fecha,tiempo_key,codigo_asesor,asesor_key,
                                          cliente_key,codigo_cliente,saldo,saldo_aho,
                                          saldo_dpf,saldo_cts,est_asesor,periodo,
                                          num_metren,imp_metren,num_logren,imp_logren,
                                          tipreg,Fecha_Sld,COD_CTACLI,NUM_TITCTA,ind_clirec,
                                          imp_desbas,imp_desava,Ind_Version,Ind_Colcaj,IND_TITREN)
      Select s.fecha,s.tiempo_key,s.codigo_asesor,s.asesor_key,
             s.cliente_key,s.codigo_cliente, 
             sum(case when nvl(s.ind_insact,1) = 1 then s.saldo_mn else 0 end) saldo,
             sum(case when s.codigo_producto = '21' then  nvl(saldo_mn,0) else 0 end) saldo_aho,
             sum(case when s.codigo_producto = '22' and nvl(s.ind_insact,1) = 1 then  nvl(saldo_mn,0) else 0 end) saldo_dpf,
             sum(case when s.codigo_producto = '211' then nvl(saldo_mn,0) else 0 end) saldo_cts,
             est_asesor,to_number(to_char(fecha,'rrrrmm')),
             sum(case when s.codigo_producto = '22' and to_number(to_char(s.fecha_vencimie,'rrrrmm')) = to_number(to_char(fecha,'rrrrmm'))
                  and nvl(s.ind_insact,1) = 1 then 1 else 0 end),
             
             sum(case when s.codigo_producto = '22' and to_number(to_char(s.fecha_vencimie,'rrrrmm')) = to_number(to_char(fecha,'rrrrmm'))
             and  nvl(s.ind_insact,1) = 1 then s.saldo_mn else 0 end),
             
   
             sum(case when s.codigo_producto = '22' and to_number(to_char(s.fecha_vencimie,'rrrrmm')) = to_number(to_char(fecha,'rrrrmm'))
                       and nvl(s.ind_insact,1) = 1 
                      then nvl(s.ind_ctaren,0) 
                      else 0 
                  end),
             sum(case when s.codigo_producto = '22' and to_number(to_char(s.fecha_vencimie,'rrrrmm')) = to_number(to_char(fecha,'rrrrmm'))
                       and (s.fecha_vencimie <= ld_feccon or ((s.fecha_vencimie > ld_feccon) and s.cuenta_ren_key is not null))
                      then nvl(s.imp_renovmn,0) 
                      else 0 
                 end),
               
             5,ld_feccon,s.cod_ctacli,nvl(s.num_intcta,1),
             s.ind_clirec,sum(nvl(imp_desbas,0)),sum(nvl(imp_desava,0)),2, nvl(IND_COLCAJ,'N'),
             nvl(s.ind_titren,1)
        from TMP_FACT_PRODASE_ASIGCLI s  
       Where --s.cliente_key = 766018
       s.fecha = ld_inimes
       Group by s.fecha,s.codigo_asesor,s.asesor_key,s.cliente_key,s.codigo_cliente,tiempo_key,est_asesor,
                s.cod_ctacli,s.num_intcta,s.ind_clirec,s.IND_COLCAJ,s.ind_titren;
       Commit;
  
       --- SALDOS A FECHA DE PROCESO
       Delete from TMP_FACT_PASIVOS_PROASE 
       Where fecha=ld_inimes and fecha_sld=ld_feccon and periodo = ln_period 
         and tipreg = 1 and ind_version = 2;
       Commit;
  
       For y In c_asesor(ln_period) Loop
           -- Clientes asignados con saldos base, actualizar avance
           For x In c_sldcli(ld_feccon,y.jaql61user,ld_keysld,ln_period) Loop
               Begin
                    Insert into TMP_FACT_PASIVOS_PROASE(fecha,tiempo_key,codigo_asesor,asesor_key,
                                                        cliente_key,codigo_cliente,saldo,saldo_aho,
                                                        saldo_dpf,fecha_sld,tiempo_sld_key,sldaho,
                                                        slddpf,ind_nuevo,sldcts,est_asesor,
                                                        saldo_cts,periodo,codsuc,num_metren,
                                                        imp_metren,num_logren,imp_logren,tipreg,Regeje,
                                                        COD_CTACLI,NUM_TITCTA,
                                                        ind_clirec,imp_desbas,imp_desava,ind_version,
                                                        ind_colcaj,IND_TITREN
                                          ) 
                    Select  fecha,tiempo_key,codigo_asesor,asesor_key,cliente_key,
                            codigo_cliente,saldo,saldo_aho,saldo_dpf,
                            X.FECHA,X.TIEMPO_KEY,
                            X.SALDO_AHO,X.SALDO_DPF,0,x.saldo_cts,
                            est_asesor,saldo_cts,ln_period,y.ubsuc,num_metren,
                            imp_metren,num_logren,imp_logren,
                            1,y.codreg,cod_ctacli,num_titcta,
                            ind_clirec,imp_desbas,imp_desava,2,nvl(ind_colcaj,'N'),
                            ind_titren
                      FRom  TMP_FACT_PASIVOS_PROASE
                      Where fecha = ld_inimes
                        and cliente_key = x.cliente_key
                        and cod_ctacli = x.cuenta
                        and est_asesor = 'S'
                        and tipreg = 5
                        and ind_version = 2;
                    Commit;                              
               Exception When Others Then
                    
                    Insert into TMP_FACT_PASIVOS_PROASE(fecha,tiempo_key,codigo_asesor,asesor_key,cliente_key,
                                                        codigo_cliente,saldo,saldo_aho,saldo_dpf,
                                                        fecha_sld,tiempo_sld_key,sldaho,slddpf,ind_nuevo,sldcts,
                                                        est_asesor,saldo_cts,periodo,codsuc,num_metren,imp_metren,
                                                        num_logren,imp_logren,tipreg,Regeje,COD_CTACLI,NUM_TITCTA,
                                                        ind_clirec,imp_desbas,imp_desava,ind_version,ind_colcaj,
                                                        ind_titren
                                                       ) 
                    Select  ld_inimes,ln_keymet,x.codigo_asesor,x.asesor_key,x.cliente_key,
                            x.codigo_cliente,0,0,0,
                            X.FECHA,X.TIEMPO_KEY,X.SALDO_AHO,X.SALDO_DPF,1,X.saldo_cts,
                            est_asesor,saldo_cts,ln_period,y.ubsuc,num_metren,imp_metren,
                            num_logren,imp_logren,1,y.codreg,cod_Ctacli,num_titcta,
                            ind_clirec,imp_desbas,imp_desava,2,nvl(ind_colcaj,'N'),
                            ind_titren
                       FRom TMP_FACT_PASIVOS_PROASE 
                      Where fecha = ld_inimes
                        and cliente_key = x.cliente_key
                        and cod_ctacli = x.cuenta
                        and est_asesor = 'S'
                        and tipreg = 5
                        and ind_version = 2;
                   Commit;    
               End;                                
           End Loop; 
           -- Clientes asignados sin saldo base pero con saldo avance
           For x in c_sldnue(ld_feccon,y.jaql61user,ld_keysld,ln_period,ld_inimes) Loop
                    --- Importe de desembolso mes actual
                    Begin
                         Select sum(decode(ds.hmda,0,ds.hcimp1,ds.hcimp1*ln_tcam))
                            Into ln_desava
                            from dwstage.Tmp_Trx_Desem_Cuenta ds
                           Where ds.hfcon between ld_inimes and ld_feccon
                             and ds.hmodul = x.aomod
                             and ds.htoper = x.aotop
                             and ds.hmda = x.aomda
                             and ds.hcta = x.cuenta
                             and ds.hoper = x.aoope
                             and ds.hsubop = x.aosbo;
                    Exception When Others Then
                        ln_desava := 0;
                    End;
                   
                    Insert into TMP_FACT_PASIVOS_PROASE
                                (fecha,tiempo_key,codigo_asesor,asesor_key,
                                 cliente_key,codigo_cliente,saldo,saldo_aho,
                                 saldo_dpf,saldo_cts,
                                 fecha_sld,tiempo_sld_key,sldaho,
                                 slddpf,sldcts,ind_nuevo,est_asesor,
                                 periodo,codsuc,tipreg,Regeje,COD_CTACLI,NUM_TITCTA,
                                 imp_desbas,imp_desava,ind_version,ind_colcaj,
                                 ind_titren
                                )
                          Values(ld_inimes,ln_keymet,y.jaql61user,y.asesor_key,
                                 x.cliente_key,x.codigo_cliente,0,0,0,0,
                                 X.FECHA,X.TIEMPO_KEY,X.SALDO_AHO,X.SALDO_DPF,X.saldo_cts,1,
                                 'S',ln_period,y.ubsuc,1,y.codreg,x.cuenta,x.numtit,
                                 0,ln_desava,2,x.ind_colcaj,x.numtit);
                          Commit;       
                                      
           End Loop;
           
       End Loop;
       Commit;
   
       --- Clientes que cancelaron
       Begin
       Insert into TMP_FACT_PASIVOS_PROASE(fecha,tiempo_key,codigo_asesor,asesor_key,cliente_key,
                                       codigo_cliente,saldo,saldo_aho,saldo_dpf,saldo_cts,
                                       fecha_sld,tiempo_sld_key,sldaho,slddpf,ind_nuevo,est_asesor,
                                       periodo,num_metren,imp_metren,num_logren,imp_logren,tipreg,
                                       Codsuc,Regeje,COD_CTACLI,NUM_TITCTA,ind_clirec,
                                       imp_desbas,imp_desava,ind_version,ind_titren
                                      )  
       Select  m.fecha,m.tiempo_key,m.codigo_asesor,m.asesor_key,m.cliente_key,
               m.codigo_cliente,m.saldo,nvl(m.saldo_aho,0),nvl(m.saldo_dpf,0),nvl(m.saldo_cts,0),
               ld_feccon,ld_keysld,0,0,0,m.est_asesor,ln_period,m.num_metren,m.imp_metren,
               m.num_logren,m.imp_logren,1,m.codsuc,m.regeje,m.cod_ctacli,m.num_titcta,
               m.ind_clirec,m.imp_desbas,m.imp_desava,2,ind_titren
          FRom TMP_FACT_PASIVOS_PROASE m
         Where periodo = ln_period
           and est_asesor = 'S'
           and m.tipreg = 5
           and ind_version = 2
           and not exists (select 1 from TMP_FACT_PASIVOS_PROASE s 
                            where s.fecha=m.fecha 
                              and s.cliente_key = m.cliente_key 
                              and s.cod_ctacli = m.cod_ctacli
                              and s.fecha_sld = ld_feccon
                              and s.tipreg = 1
                              and s.ind_version = 2
                           );
        commit;  
    Exception When Others Then
       Null;
    End; 
    
    ---
    ---> 2024.05.28 Eliminar saldos duplicados en ahorros
    ---
    For x in c_dup Loop
        select max(sldaho),max(slddpf),max(sldcts),max(num_titcta) 
         into  nAho, nDpf, nCts, nTit
         from TMP_FACT_PASIVOS_PROASE where codigo_cliente = x.codigo_cliente
          and cod_ctacli =  x.cod_ctacli   and ind_nuevo = 0  and tipreg = 1;
          
        Update TMP_FACT_PASIVOS_PROASE
           set sldaho = 0, slddpf = 0 , sldcts = 0
         Where codigo_cliente = x.codigo_cliente
           and cod_ctacli = x.cod_ctacli
           and codigo_asesor = x.codigo_asesor
           and ind_nuevo = 0  and tipreg = 1;
           
          
         Update TMP_FACT_PASIVOS_PROASE
           set sldaho = nAho, slddpf = nDpf , sldcts = nCts
         Where codigo_cliente = x.codigo_cliente
           and cod_ctacli = x.cod_ctacli
           and codigo_asesor = x.codigo_asesor
           and ind_nuevo = 0  and tipreg = 1
           and num_titcta = nTit
           and rownum = 1;   
       commit;

    End Loop;  
    ---< 2024.05.28

    
    --- REGISTROS DE CRECIMIENTO
    --- INSERTA REGISTROS CRECIMIENTO
    Begin
         Insert Into TMP_FACT_PASIVOS_PROASE(fecha,tiempo_key,codigo_asesor,asesor_key,
                                             cliente_key,codigo_cliente,
                                             fecha_sld,
                                             tiempo_sld_key,
                                             ind_nuevo,periodo,tipreg,ind_tipren,Imp_Tipcam,
                                             saldo,sldbaho,sldbdpf,sldbcts,
                                             Imp_Renmn,sldcaho,sldccts,sldcdpf,Codsuc,Regeje,
                                             COD_CTACLI,NUM_TITCTA,
                                             ind_clirec,imp_desbas,imp_desava,ind_Version,
                                             ind_titren
                                             ) 
          select fecha,tiempo_key,codigo_asesor,asesor_key,v.cliente_key,v.codigo_cliente,
                 ld_feccon,ld_keysld,
                 v.ind_ctaren,ln_period,1,4,v.imp_tipcam,
                sum(case when nvl(v.saldo,0) >= nvl(v.imp_desbas,0) Then nvl(v.saldo,0) - nvl(v.imp_desbas,0) Else 0 End),
                sum(Case when v.cod_modcta = '21' then v.saldo else 0 end) sldaho,
                sum(Case when v.cod_modcta = '22' then v.saldo else 0 end) sldadpf,  
                sum(Case when v.cod_modcta = '211' then v.saldo else 0 end) sldcts,
                sum(Case when nvl(v.imp_renmn,0) >= nvl(v.imp_desava,0) Then  nvl(v.imp_renmn,0) - nvl(v.imp_desava,0) else 0 End),
                sum(Case when v.cod_modcta = '21'  then v.imp_renmn else 0 end) sldcaho,
                sum(Case when v.cod_modcta = '211' then v.imp_renmn else 0 end) sldccts,
                sum(Case when v.cod_modcta = '22' then v.imp_renmn else 0 end) sldadcpf,
                v.codsuc,v.regeje ,v.cod_ctacli,v.num_titcta,
                v.ind_clirec,sum(nvl(v.imp_desbas,0)),sum(nvl(v.imp_desava,0)),2,ind_titren 
           from TMP_FACT_PASIVOS_PROASE v 
           Join dwhouse.dm_cliente c on c.cliente_key = v.cliente_key
          where v.fecha = ld_inimes 
            and v.tipreg = 3
            and nvl(v.val_rucemp,'0') not in ('20100209641','20509815501')
            and nvl(v.ind_colcaj,'N') = 'N'
            and v.cod_aseasi is null
            and ind_version = 2
          Group By fecha,tiempo_key,codigo_asesor,asesor_key,v.cliente_key,
                   v.codigo_cliente,ind_ctaren,periodo,v.imp_tipcam,
                   v.codsuc,v.regeje,v.cod_ctacli,v.num_titcta,
                   v.ind_clirec,v.ind_titren;
          Commit;
    Exception When Others Then
        Null;
    End;

  END SP_PRAS_SALDOAVANCE;  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- -- --  
  PROCEDURE SP_PRAS_LOGROS(PD_FECHA IN DATE)
  IS
   Cursor c_asesor(ln_per in Number)
     is Select distinct x.codigo_asesor jaql61user, s.ubsuc,
               to_number(g.Codigo_Region) codreg 
          from TMP_FACT_PASIVOS_PROASE x  
          Join dwextra.fst046 s on trim(s.ubuser) = x.codigo_asesor 
          Join dwhouse.dm_geografia g 
            on to_number(g.codigo_agencia) = s.ubsuc
           and g.tipo_region = 'R'
         Where x.est_asesor <> 'N'
           and x.periodo= ln_per
           and x.tipreg = 5
           and x.ind_version = 2;
     
     Cursor c_rnk Is
            Select tiempo_key,nvl(POR_LOGRO,0) por_logro,codigo_asesor from TMP_FACT_PASIVOS_PROASE WHERE TIPREG = 0 
             and ind_version = 2
             Order by nvl(POR_LOGRO,0) desc;
      
     ld_feccon date := PD_FECHA;                                 
     ld_inimes date := to_date(to_char(ld_feccon,'rrrrmm')||'01','rrrrmmdd');
     ln_period  number(6) := to_number(to_char(ld_feccon,'rrrrmm'));
     ln_tipcam number(7,3) := pq_tmp_productividadase.fn_tipo_cambio_fijo(ld_feccon);        
     lv_perf varchar2(10);  
     ln_limp number(12,2);  
     ln_pontp number(7,3);
     ln_ponsld number(7,3);
     ln_poncli number(7,3);  
     ln_metsld number(7,3);
     ln_metcli number(7,3);
     lv_err varchar2(200);
     ln_mancli number(12,2);
     ln_metslr number(7,3);
     ln_metctr number(7,3);
     ln_ponren number(7,3);
     ln_prnsld number(7,3);
     ln_prncli number(7,3);
     
     ln_niveje number(3); -- nivel de ejecutivo
     ln_poncre number(7,3); -- ponderado crecimiento
     ln_metaho number(12,2);-- meta ahorros
     ln_ponaho number(7,3);-- ponderado ahorros
     ln_metdpf number(12,2);-- meta dpf
     ln_pondpf number(7,3);-- ponderado dpf
     ln_metcts number(12,2);-- meta cts
     ln_poncts number(7,3);-- ponderado cts
     ln_ponnue number(7,3);-- ponderado nuevos
     ln_metnue number(12,2);-- meta nuevos
     ln_indvar number(3);
     ln_guiapr number(10) := 10819; --guia de proceso
     ln_pagpro number(12,2);
     ln_rnkase number(5);
     ln_ubsuc number(3);
     ln_creg number(3);
     ln_geok number(10);
     ln_porpag number(9,4);
  BEGIN
     DelETE FROM TMP_FACT_PASIVOS_PROASE WHERE TIPREG = 0 and ind_version = 2;
     COMMIT;
     
     For x in c_asesor(ln_period) Loop
         -- PERFIL DE ASESOR  
           Begin
               -- Codigo Ejecutivo EJEAHO
               If ld_feccon = last_day(ld_feccon) and ld_feccon < trunc(sysdate-1) Then
                  Execute Immediate 'select min(prfgcod) '||
                                      'from dwbkext.prfu00_'||to_char(ld_feccon,'rrrrmmdd')||
                                    ' where trim(ubuser) = :1 '||
                                       'and PRFGCOD like ''EAH%'''
                      Into lv_perf Using trim(x.jaql61user); 
               Else
                   select min(prfgcod) Into lv_perf
                     from prfu00@produ where trim(ubuser) = trim(x.jaql61user) 
                      and PRFGCOD like 'EAH%';
                      
                   
               End If;    
               
               IF trim(x.jaql61user)  = 'MVALDEZC' Then 
                      lv_perf := 'EAHO06';
                   End IF;  
               
               -- Nivel de Ejecutivo
               select d.tp1corr3 Into ln_niveje
                 from dwextra.fst198 d  where d.tp1cod1 = ln_guiapr 
                  and d.tp1corr1 = 20 and d.tp1corr2=0 and trim(d.tp1desc) = trim(lv_perf); 
          
               -- Meta y Pago
               select d.tp1imp1,d.tp1imp2 Into ln_metnue,ln_pagpro
               from dwextra.fst198 d  where d.tp1cod1 = ln_guiapr and d.tp1corr1 = 30 and d.tp1corr2=x.codreg and d.tp1corr3=ln_niveje;
                   
               --SUCURSAL Y REGION
               Begin
               select ubsuc Into ln_ubsuc from dwextra.FST046 where trim(ubuser) = trim(x.jaql61user);
               Exception When Others Then
                   ln_ubsuc := 0;
               End;
               
               -- REGION
               Begin
                  Select g.geografia_key,to_number(g.codigo_region) Into ln_geok, ln_creg
                    From dwhouse.dm_geografia g
                  Where to_number(g.codigo_agencia) = ln_ubsuc
                    and g.tipo_region = 'R'; 
               Exception When Others Then
                    ln_geok := 117893;
                    ln_creg :=  0;  
                    ln_ubsuc:= 0; 
               End;
               
               --- ACTUALIZA DATOS DE CARTERA ASIGNADA
               UPDATE dwstage.TMP_FACT_PASIVOS_PROASE y 
                   set y.saldo_base = (case when ind_tipren is null and nvl(y.ind_clirec,0) = 0 Then
                                            case when nvl(saldo_aho,0) >= nvl(y.imp_desbas,0) 
                                                 Then ((nvl(saldo_aho,0)- nvl(y.imp_desbas,0))+nvl(y.saldo_dpf,0) + nvl(y.saldo_cts,0))/num_titcta 
                                                 Else (nvl(y.saldo_dpf,0) + nvl(y.saldo_cts,0))/num_titcta  
                                            End
                                            when ind_tipren is null and nvl(y.ind_clirec,0) = 1 Then  nvl(saldo_dpf,0)/num_titcta 
                                            else 0
                                       end),
                       y.saldo_avance = (case when ind_tipren is null and nvl(ind_clirec,0) = 1 Then nvl(slddpf,0)/num_titcta
                                            when ind_tipren is null and (nvl(ind_clirec,0) =0 or nvl(ind_colcaj,'N') = 'N') Then
                                                 (case when nvl(sldaho,0) >= nvl(y.imp_desava,0) Then
                                                           ((nvl(sldaho,0) - nvl(imp_desava,0))+nvl(slddpf,0)+nvl(sldcts,0))/num_titcta 
                                                      else (nvl(slddpf,0)+nvl(sldcts,0))/num_titcta     
                                                  end )      
                                            Else 0
                                       End) ,
                       y.sldbaho = (case when ind_tipren is null and nvl(y.ind_clirec,0) = 0 Then
                                            case when nvl(saldo_aho,0) >= nvl(y.imp_desbas,0) 
                                                 Then (nvl(saldo_aho,0)- nvl(y.imp_desbas,0))/num_titcta 
                                                 Else 0
                                                 End
                                        else 0
                                        end),
                       y.sldbdpf = (case when ind_tipren is null Then nvl(y.saldo_dpf,0) /num_titcta 
                                         else 0
                                         end),
                       y.sldbcts = (case when ind_tipren is null Then nvl(y.saldo_cts,0) /num_titcta 
                                         else 0
                                       end),
                       y.sldcaho = (case when ind_tipren is null and (nvl(ind_clirec,0) =0 or nvl(ind_colcaj,'N') = 'N') Then
                                                 (case when nvl(sldaho,0) >= nvl(y.imp_desava,0) Then
                                                           (nvl(sldaho,0) - nvl(imp_desava,0))/num_titcta 
                                                      else 0   
                                                  end )      
                                            Else 0
                                       End),
                       y.sldcdpf = (case when ind_tipren is null and nvl(ind_colcaj,'N') = 'N' Then nvl(slddpf,0)/num_titcta
                                             Else 0
                                       End),
                       y.sldccts = (case when ind_tipren is null and nvl(ind_colcaj,'N') = 'N' Then nvl(sldcts,0)/num_titcta
                                             Else 0
                                       End),
                       y.imp_desbas = (nvl(imp_desbas,0)/num_titcta),
                       y.imp_desava = (nvl(imp_desava,0)/num_titcta),
                       y.ind_colcaj = NVL(ind_colcaj,'N')
                WHERE TIPREG = 1  and y.Codigo_Asesor = trim(x.jaql61user) and ind_version = 2;
               Commit;
               --- INSERTA LOGROS     
                Insert INTO TMP_FACT_PASIVOS_PROASE(FECHA,TIEMPO_KEY,Fecha_Sld,Codigo_Asesor,Metnue,pagpro,
                                                    asesor_key,codsuc,regeje,key_geografia,
                                                    SALDO_BASE,IMP_DESBAS,
                                                    SALDO_AVANCE,SALDO_CAPTADO,IMP_DESAVA,
                                                    SALDO_META,SALDO_LOGRO,POR_LOGRO,TIPREG,
                                                    IND_VERSION,tipase,num_titcta,cod_ctacli)
                Select fecha, tiempo_key, fecha_sld,codigo_asesor,ln_metnue,ln_pagpro,asesor_key,ln_ubsuc,ln_creg,ln_geok,
                       sdobas,imp_desbas,
                       sdoava,nvl(sdocap,0)-nvl(sdocapbas,0), imp_desava,
                       sdobas + ln_metnue,
                       sdoava + (nvl(sdocap,0)-nvl(sdocapbas,0)),
                       case when sdobas + ln_metnue > 0 Then  (sdoava + (nvl(sdocap,0)-nvl(sdocapbas,0)))/(sdobas + ln_metnue)
                            else 0
                       end,0,2,
                       lv_perf,nclie,nclim
                From(                                             
                Select tiempo_key, codigo_asesor,fecha_sld,fecha,asesor_key,
                       sum(case when ind_tipren is null and nvl(y.ind_clirec,0) = 0 Then
                            case when nvl(saldo_aho,0) >= nvl(y.imp_desbas,0) 
                                 Then ((nvl(saldo_aho,0)- nvl(y.imp_desbas,0))+nvl(y.saldo_dpf,0) + nvl(y.saldo_cts,0))/num_titcta 
                                 Else (nvl(y.saldo_dpf,0) + nvl(y.saldo_cts,0))/num_titcta  
                            End
                            when ind_tipren is null and nvl(y.ind_clirec,0) = 1 Then  nvl(saldo_dpf,0)/num_titcta 
                            else 0
                       end) sdobas,
                       sum(nvl(imp_desbas,0)/num_titcta) imp_desbas,       
                       sum(case when ind_tipren is null and  nvl(ind_clirec,0) = 1 Then nvl(slddpf,0)/num_titcta
                                when ind_tipren is null and (nvl(ind_clirec,0) = 0 or ind_colcaj = 'N') Then
                                 (case when nvl(sldaho,0) >= nvl(y.imp_desava,0) Then
                                           ((nvl(sldaho,0) - nvl(imp_desava,0))+nvl(slddpf,0)+nvl(sldcts,0))/num_titcta 
                                      else (nvl(slddpf,0)+nvl(sldcts,0))/num_titcta     
                                  end )      
                            Else 0
                       End) sdoava,
                       sum(Case when ind_tipren is not null and (nvl(ind_clirec,0) = 0 OR ind_colcaj = 'N') Then
                                nvl(imp_renmn,0)/num_titcta 
                            /*case when nvl(imp_renmn,0) >= nvl(imp_desava,0) Then (nvl(imp_renmn,0) - nvl(imp_desava,0))/num_titcta
                                 else 0
                            end*/
                       Else 0 End) sdocap,
                       sum(nvl(imp_desava,0)/num_titcta) imp_desava,
                       sum(Case when ind_tipren is not null and (nvl(ind_clirec,0) = 0 OR ind_colcaj = 'N') Then
                            /*case when nvl(saldo,0) >= nvl(imp_desbas,0) Then (nvl(saldo,0) - nvl(imp_desbas,0))/num_titcta
                                 else 0
                            end*/
                            (nvl(saldo,0))/num_titcta
                       Else 0 End) sdocapbas,
                       count(distinct y.cliente_key) nclie, -- total clientes
                       count(distinct case when y.ind_nuevo = 0 then y.cliente_key end) nclim -- clientes mantenimiento        
                  from dwstage.TMP_FACT_PASIVOS_PROASE  y 
                  WHERE TIPREG = 1 and codigo_asesor =trim(x.jaql61user)
                  and ind_version = 2
                group by tiempo_key, codigo_asesor,fecha_sld,fecha,asesor_key
                );
                Commit;
               
           Exception WHen Others Then
              lv_err := substr(sqlerrm,1,200);
           End;     
       End Loop;
       
       ln_rnkase := 0;
       For x in c_rnk Loop
           ln_rnkase := ln_rnkase + 1;
           ---- Meta y Pago
           Begin
           select d.tp1imp3 Into ln_porpag
             from dwextra.fst198 d  where d.tp1cod1 = ln_guiapr 
              and d.tp1corr1 = 29 and d.tp1corr2=20 
              and round(x.por_logro*100,2) between d.tp1imp1 and tp1imp2;
           Exception When Others  Then
               ln_porpag := 0;
           End;     
               
           Update TMP_FACT_PASIVOS_PROASE d 
              set d.rnk_logro = ln_rnkase,
                  d.por_pagvar = (ln_porpag/100)
             Where d.codigo_asesor = x.codigo_asesor
               and d.tiempo_key = x.tiempo_key
               and ind_version = 2;
           Commit;    
       End Loop;
       
       -- Inserta DETALLE DE DPF RENOVADOS
       Delete from TMP_FACT_PASIVOS_PROASE n where n.tipreg=2 and ind_version = 2;
       Commit;
       Insert Into TMP_FACT_PASIVOS_PROASE(fecha,tiempo_key,periodo,codigo_asesor,asesor_key,
                                           cliente_key,codigo_cliente,saldo,
                                           cuentas_key,cuentas_ren_key,
                                           codigo_cuenta,codigo_cuenta_ren,imp_renmn,
                                           ind_ctaren,ind_tipren,tipreg,fec_vencta,
                                           ind_venmes,fec_cancela,cod_cuenta,imp_tipcam,
                                           Fecha_Sld,Fecha_Apre,Cod_Ctacli,Num_Titcta,ind_version,Key_Geografia)
        Select s.fecha,s.tiempo_key,to_number(to_char(s.fecha,'rrrrmm')),s.codigo_asesor,s.asesor_key,s.cliente_key,
               s.codigo_cliente, s.saldo_mn,
               s.cuentas_key,s.cuenta_ren_key,s.codigo_cuenta,s.codigo_ctaren,s.imp_renovmn,s.ind_ctaren,s.ind_tipren,2,
               s.fecha_vencimie,
               Case when to_char(s.fecha_vencimie,'rrrrmm') = to_char(s.fecha,'rrrrmm') Then 'Si' Else 'No' End,
               s.fecha_cancela,s.cod_cuenta,
               ln_tipcam,ld_feccon,s.fecha_apre,s.cod_ctacli,s.num_intcta,2,s.geografia_key
          From TMP_FACT_PRODASE_ASIGCLI s       
         Where s.codigo_producto = '22'      
           and s.est_asesor = 'S';
          -- and s.fecha = ld_inimes;
         Commit;
  END SP_PRAS_LOGROS;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- -- --  
  PROCEDURE SP_PRAS_LOGROS_V4(PD_FECHA IN DATE)
  IS
   Cursor c_asesor(ln_per in Number,ln_guia in Number)
     is  select trim(tp1desc) jaql61user,tp1nro1 nivase,tp1nro2 ubsuc,tp1nro3 sucsec,
                 to_number(g.Codigo_Region) codreg  
           from dwextra.fst198 d  
           Left Join dwhouse.dm_geografia g 
             on g.cod_sucurs = d.tp1nro2
            and g.tipo_region = 'R'
          where tp1cod1 = ln_guia
            and d.tp1corr1 = 35 
            and d.tp1corr2=1 
            and d.tp1corr3 = ln_per
            --and trim(tp1desc) = 'DZOLEZZI'
           ;
     
     Cursor c_rnk Is
            Select tiempo_key,nvl(POR_LOGRO,0) por_logro,codigo_asesor,niveje,
                   d.codsuc,d.sucsec,d.ponaho,d.PONREN,d.metnue,
                   nvl(saldo_logro,0)-nvl(saldo_meta,0) sobcum,PONRE1 
              from TMP_FACT_PASIVOS_PROASE d WHERE TIPREG = 0 
             and ind_version = 2
             Order by nvl(POR_LOGRO,0) desc;
     
              
     ld_feccon date := PD_FECHA;                                 
     ld_inimes date := to_date(to_char(ld_feccon,'rrrrmm')||'01','rrrrmmdd');
     ln_inimes number(10) := dwhouse.pq_carga_facts.fn_tiempo_key(ld_inimes);
     ln_period  number(6) := to_number(to_char(ld_feccon,'rrrrmm'));
     ln_tipcam number(7,3) := pq_tmp_productividadase.fn_tipo_cambio_fijo(ld_feccon);        
     lv_perf varchar2(20);  
     ln_limp number(12,2);  
     ln_pontp number(7,3);
     ln_ponsld number(7,3);
     ln_poncli number(7,3);  
     ln_metsld number(7,3);
     ln_metcli number(7,3);
     lv_err varchar2(200);
     ln_mancli number(12,2);
     ln_metslr number(7,3);
     ln_metctr number(7,3);
     ln_ponren number(7,3);
     ln_prnsld number(7,3);
     ln_prncli number(7,3);
     
     ln_niveje number(3); -- nivel de ejecutivo
     ln_poncre number(7,3); -- ponderado crecimiento
     ln_metaho number(12,2);-- meta ahorros
     ln_ponaho number(7,3);-- ponderado ahorros
     ln_metdpf number(12,2);-- meta dpf
     ln_pondpf number(7,3);-- ponderado dpf
     ln_metcts number(12,2);-- meta cts
     ln_poncts number(7,3);-- ponderado cts
     ln_ponnue number(7,3);-- ponderado nuevos
     ln_metnue number(12,2);-- meta nuevos
     ln_indvar number(3);
     ln_guiapr number(10) := 10819; --guia de proceso
     ln_pagpro number(12,2);
     ln_rnkase number(5);
     ln_ubsuc number(3);
     ln_creg number(3);
     ln_geok number(10);
     ln_porpag number(9,4);
     
     ld_mesant date := last_day(add_months(ld_feccon,-1));
     ln_iniman number := dwhouse.pq_carga_facts.fn_tiempo_key(to_date(to_char(ld_mesant,'rrrrmm')||'01','rrrrmmdd'));
     ln_sucsec number(4); -- Sucursal secundaria
     
     lnpeso1 number(7,3); lnmeta1 number(7,3); lnpago1 number(7,3);
     lnpeso2 number(7,3); lnmeta2 number(7,3); lnpago2 number(7,3);
     lnpeso3 number(7,3); lnmeta3 number(7,3); lnpago3 number(7,3);
     lnpeso4 number(7,3); lnmeta4 number(7,3); lnpago4 number(7,3);
     lnpeso5 number(7,3); lnmeta5 number(7,3); lnpago5 number(7,3);
     ln_psuc2 number(9,5);ln_psuc1 number(9,5);
     ln_msuc1 number(12,2); ln_isuc1 number(12,2);
     ln_msuc2 number(12,2); ln_isuc2 number(12,2);
     ln_bono  number(12,2);
     ln_rnkcc number(5);
     ln_rnkas number(5); 
     lnpsob number(12,2);
     ln_capaho number(12,2);
     ln_manaho number(12,2);
     ln_creaho number(7,3);
     ln_inddes number(2);
     ln_impdes number(12,2);
  BEGIN
    
     -- REVISA METAS 
     PQ_TMP_PRODUCTIVIDADASE.SP_PRAS_METAS(ld_feccon);
     
     DelETE FROM TMP_FACT_PASIVOS_PROASE WHERE TIPREG = 0 and ind_version = 2;
     COMMIT;
     
     For x in c_asesor(ln_period,ln_guiapr) Loop
         -- PERFIL DE ASESOR  
           
             -- Nive, Sucursal principal, Sucursal secundaria
             Begin  
                 select d.tp1nro1,d.tp1nro2,d.tp1nro3,d.tp1imp1,d.tp1imp2
                   Into ln_niveje,ln_ubsuc,ln_sucsec, ln_inddes, ln_impdes
                   from dwextra.fst198 d  where tp1cod1 = ln_guiapr
                    and d.tp1corr1 = 35 and d.tp1corr2=1 
                    and d.tp1corr3 = ln_period 
                    and trim(d.tp1desc) = trim(x.jaql61user); 
             Exception When Others Then
                ln_niveje := null;
                ln_ubsuc := null;
                ln_sucsec := null;
             End;     
             
             -- Nivel de Ejecutivo
             Begin
               Select trim(d.tp1desc) 
                 Into lv_perf
                 From dwextra.fst198 d  where tp1cod1 = ln_guiapr
                  and d.tp1corr1 = 35 and d.tp1corr2=0 
                  and d.tp1corr3 = ln_period and d.tp1nro1 = ln_niveje;
             Exception When Others Then
                lv_perf := null;
             End;    
               
             Begin   
               select d.tp1imp1,d.tp1imp2,d.tp1imp3 
                 Into ln_metnue,ln_pagpro,ln_bono
                 from dwextra.fst198 d  where d.tp1cod1 = ln_guiapr
                  and d.tp1corr1 = 35 and d.tp1corr2 = ln_period 
                  and d.tp1corr3=x.codreg and d.tp1nro1=ln_niveje;
               Exception When Others Then
                ln_metnue := null; ln_pagpro := null;
             End;       
              
               
               -- REGION
               Begin
                  Select g.geografia_key,to_number(g.codigo_region) Into ln_geok, ln_creg
                    From dwhouse.dm_geografia g
                  Where to_number(g.codigo_agencia) = ln_ubsuc
                    and g.tipo_region = 'R'; 
               Exception When Others Then
                    ln_geok := 117893;
                    ln_creg :=  0;  
                    ln_ubsuc:= 0; 
               End;
               
               --- ACTUALIZA DATOS DE CARTERA ASIGNADA
               BEGIN
               UPDATE dwstage.TMP_FACT_PASIVOS_PROASE y 
                   set y.saldo_base = (case when ind_tipren is null and nvl(y.ind_clirec,0) = 0 Then
                                            case when nvl(saldo_aho,0) >= nvl(y.imp_desbas,0) 
                                                 Then ((nvl(saldo_aho,0)- nvl(y.imp_desbas,0))+nvl(y.saldo_dpf,0) + nvl(y.saldo_cts,0))/num_titcta 
                                                 Else (nvl(y.saldo_dpf,0) + nvl(y.saldo_cts,0))/num_titcta  
                                            End
                                            when ind_tipren is null and nvl(y.ind_clirec,0) = 1 Then  nvl(saldo_dpf,0)/num_titcta 
                                            else 0
                                       end),
                       y.saldo_avance = (case when ind_tipren is null and nvl(ind_clirec,0) = 1 Then nvl(slddpf,0)/num_titcta
                                            when ind_tipren is null and (nvl(ind_clirec,0) =0 or nvl(ind_colcaj,'N') = 'N') Then
                                                 (case when nvl(sldaho,0) >= nvl(y.imp_desava,0) Then
                                                           ((nvl(sldaho,0) - nvl(imp_desava,0))+nvl(slddpf,0)+nvl(sldcts,0))/num_titcta 
                                                      else (nvl(slddpf,0)+nvl(sldcts,0))/num_titcta     
                                                  end )      
                                            Else 0
                                       End) ,
                       y.sldbaho = (case when ind_tipren is null and nvl(y.ind_clirec,0) = 0 Then
                                            case when nvl(saldo_aho,0) >= nvl(y.imp_desbas,0) 
                                                 Then (nvl(saldo_aho,0)- nvl(y.imp_desbas,0))/num_titcta 
                                                 Else 0
                                                 End
                                        else 0
                                        end),
                       y.sldbdpf = (case when ind_tipren is null Then nvl(y.saldo_dpf,0) /num_titcta 
                                         else 0
                                         end),
                       y.sldbcts = (case when ind_tipren is null Then nvl(y.saldo_cts,0) /num_titcta 
                                         else 0
                                       end),
                       y.sldcaho = (case when ind_tipren is null and (nvl(ind_clirec,0) =0 or nvl(ind_colcaj,'N') = 'N') Then
                                                 (case when nvl(sldaho,0) >= nvl(y.imp_desava,0) Then
                                                           (nvl(sldaho,0) - nvl(imp_desava,0))/num_titcta 
                                                      else 0   
                                                  end )      
                                            Else 0
                                       End),
                       y.sldcdpf = (case when ind_tipren is null and nvl(ind_colcaj,'N') = 'N' Then nvl(slddpf,0)/num_titcta
                                             Else 0
                                       End),
                       y.sldccts = (case when ind_tipren is null and nvl(ind_colcaj,'N') = 'N' Then nvl(sldcts,0)/num_titcta
                                             Else 0
                                       End),
                       y.imp_desbas = (nvl(imp_desbas,0)/num_titcta),
                       y.imp_desava = (nvl(imp_desava,0)/num_titcta),
                       y.ind_colcaj = NVL(ind_colcaj,'N'),
                       y.saldo_desfase = pq_tmp_productividadase.fn_pras_saldo_desfase(pn_tiempo => ln_iniman,
                                                                   pd_fecsdo => ld_mesant,
                                                                   pn_asekey => y.asesor_key,
                                                                   pn_tipreg => 0,
                                                                   pn_niveje => ln_niveje,
                                                                   pn_inddes => ln_inddes,
                                                                   pn_impdes => ln_impdes)
                WHERE TIPREG = 1  and y.Codigo_Asesor = trim(x.jaql61user) and ind_version = 2;
               Commit;
               Exception WHen Others Then
                lv_err := substr(sqlerrm,1,200);
                dbms_output.put_line('INS-'||trim(x.jaql61user)||':'||lv_err);
               End;     
               
               --- INSERTA LOGROS     
               BEGIN
                Insert INTO TMP_FACT_PASIVOS_PROASE
                       (FECHA,TIEMPO_KEY,FECHA_SLD,CODIGO_ASESOR,
                        METNUE,PAGPRO,ASESOR_KEY,CODSUC,REGEJE,
                        KEY_GEOGRAFIA,SALDO_BASE,IMP_DESBAS,
                        SALDO_AVANCE,SALDO_CAPTADO,IMP_DESAVA,
                        SALDO_META,SALDO_LOGRO,POR_LOGRO,TIPREG,
                        IND_VERSION,TIPASE,NUM_TITCTA,COD_CTACLI,
                        SUCSEC,SLDCAHO,SALDO_DESFASE,NIVEJE,
                        PONAHO,PONREN,IMP_METREN,IMP_LOGREN,PONRE1
                        
                        )
                Select fecha, tiempo_key, fecha_sld,codigo_asesor,
                       ln_metnue,ln_pagpro,asesor_key,ln_ubsuc,ln_creg,
                       ln_geok,sdobas,imp_desbas,sdoava,
                       nvl(sdocap,0)-nvl(sdocapbas,0), imp_desava,
                       sdobas + ln_metnue + nvl(Saldo_Desfase,0),
                       sdoava + (nvl(sdocap,0)-nvl(sdocapbas,0)),
                       case when sdobas + ln_metnue + nvl(Saldo_Desfase,0) > 0 
                            Then (sdoava + (nvl(sdocap,0)-nvl(sdocapbas,0)))/(sdobas + ln_metnue + nvl(Saldo_Desfase,0))
                            else 0
                       end,0,2,
                       lv_perf,nclie,nclim,ln_sucsec,
                       Sldcaho,
                       SALDO_DESFASE,ln_niveje,
                       case when Sldbaho <> 0 and Sldcaho >= Sldbaho Then (Sldcaho/Sldbaho)-1
                            Else 0
                       end METCAHO, 
                       case when imp_metren <> 0 and imp_logren >= imp_metren Then (imp_logren/imp_metren)
                            Else 0
                       end METRDPF,
                       imp_metren,imp_logren,ln_bono         
                       
                From(                                             
                     Select tiempo_key, codigo_asesor,fecha_sld,fecha,asesor_key,
                            sum(case when ind_tipren is null and nvl(y.ind_clirec,0) = 0 
                                     Then Case when nvl(saldo_aho,0) >= nvl(y.imp_desbas,0) 
                                          Then ((nvl(saldo_aho,0)- nvl(y.imp_desbas,0))+nvl(y.saldo_dpf,0) + nvl(y.saldo_cts,0))/num_titcta 
                                          Else (nvl(y.saldo_dpf,0) + nvl(y.saldo_cts,0))/num_titcta  
                                          End
                                     when ind_tipren is null and nvl(y.ind_clirec,0) = 1 
                                     Then  nvl(saldo_dpf,0)/num_titcta 
                                     else 0
                                end
                               ) sdobas,
                            sum(nvl(imp_desbas,0)/num_titcta) imp_desbas,       
                            sum(case when ind_tipren is null and  nvl(ind_clirec,0) = 1 Then nvl(slddpf,0)/num_titcta
                                    when ind_tipren is null and (nvl(ind_clirec,0) = 0 or ind_colcaj = 'N') Then
                                     (case when nvl(sldaho,0) >= nvl(y.imp_desava,0) Then
                                               ((nvl(sldaho,0) - nvl(imp_desava,0))+nvl(slddpf,0)+nvl(sldcts,0))/num_titcta 
                                          else (nvl(slddpf,0)+nvl(sldcts,0))/num_titcta     
                                      end )      
                                Else 0
                                End
                               ) sdoava,
                       sum(Case when ind_tipren is not null and (nvl(ind_clirec,0) = 0 OR ind_colcaj = 'N') Then
                                nvl(imp_renmn,0)/num_titcta 
                       Else 0 End) sdocap,
                       sum(nvl(imp_desava,0)/num_titcta) imp_desava,
                       sum(Case when ind_tipren is not null and (nvl(ind_clirec,0) = 0 OR ind_colcaj = 'N') Then
                            (nvl(saldo,0))/num_titcta
                       Else 0 End) sdocapbas,
                       count(distinct y.cliente_key) nclie, -- total clientes
                       count(distinct case when y.ind_nuevo = 0 then y.cliente_key end) nclim, -- clientes mantenimiento  
                       sum(nvl(Sldbaho,0)/nvl(num_titcta,1)) Sldbaho,
                       sum(nvl(Sldcaho,0)/nvl(num_titcta,1)) Sldcaho,
                       max(nvl(SALDO_DESFASE,0)) SALDO_DESFASE,
                       sum(nvl(imp_metren,0)/nvl(num_titcta,1)) imp_metren,
                       sum(nvl(imp_logren,0)/nvl(num_titcta,1)) imp_logren
                  from dwstage.TMP_FACT_PASIVOS_PROASE  y 
                  WHERE TIPREG = 1 and codigo_asesor =trim(x.jaql61user)
                  and ind_version = 2
                group by tiempo_key, codigo_asesor,fecha_sld,fecha,asesor_key
                );
                Commit;
               
           Exception WHen Others Then
              lv_err := substr(sqlerrm,1,200);
              dbms_output.put_line('INS-'||trim(x.jaql61user)||':'||lv_err);
           End;     
       End Loop;
       
       ln_rnkase := 0;
       ln_rnkcc  := 0;
       ln_rnkas  := 0;
       
       For x in c_rnk Loop
           ln_metnue := x.metnue;

           If x.niveje = 4 Then
              ln_rnkcc := ln_rnkcc + 1;
              ln_rnkase:= ln_rnkcc;
           Else
              ln_rnkas := ln_rnkas + 1;
              ln_rnkase:= ln_rnkas;
           End If;      
           
           -- PESO/META/PAGO INDIC1:TOTAL
           BEGIN
             select d.tp1imp2,d.tp1imp1,r.tp1imp3/100 
               Into lnpeso1,lnmeta1,lnpago1
               from dwextra.fst198 d 
               Join dwextra.fst198 r on r.tp1cod = d.tp1cod
                                    and r.tp1cod1 = d.tp1cod1
                                    and r.tp1corr1 = d.tp1corr1
                                    and r.tp1corr2 = d.tp1nro2
                                    and r.tp1corr3 = d.tp1corr3
                                   
                where d.tp1cod1 = ln_guiapr                      
                and d.tp1corr1 = 36 
                and d.tp1nro1 = 1--tabla1
                and d.tp1corr2 = x.niveje --codigo perfil
                and d.tp1corr3 =ln_period --periodo  
                and round((nvl(x.por_logro,0)/d.tp1imp1)*100,2) between r.tp1imp1 and r.tp1imp2;
           exception when others then
              lnpeso1 := 0; lnmeta1 :=0; lnpago1:=0;
           end;     
           
           -- PESO/META/PAGO INDIC1:TOTAL
           BEGIN
             select r.tp1imp3
               Into lnpsob
               from dwextra.fst198 d 
               Join dwextra.fst198 r on r.tp1cod = d.tp1cod
                                    and r.tp1cod1 = d.tp1cod1
                                    and r.tp1corr1 = d.tp1corr1
                                    and r.tp1corr2 = d.tp1nro2
                                    and r.tp1corr3 = d.tp1corr3
                                   
                where d.tp1cod1 = ln_guiapr                      
                and d.tp1corr1 = 36 
                and d.tp1nro1 = 6--tabla6
                and d.tp1corr2 = x.niveje --codigo perfil
                and d.tp1corr3 =ln_period --periodo  
                and x.sobcum between r.tp1imp1 and r.tp1imp2;
           exception when others then
              lnpsob := 0; 
           end;  
           
           --- PESO/META
           BEGIN
             select d.tp1imp2,d.tp1imp1
               Into lnpeso2,lnmeta2
               from dwextra.fst198 d 
              where d.tp1cod1 = ln_guiapr                      
                and d.tp1corr1 = 36 
                and d.tp1nro1 = 2--tabla2
                and d.tp1corr2 = x.niveje --codigo perfil
                and d.tp1corr3 =ln_period;
           exception when others then
              lnpeso2 := 0; lnmeta2 :=0;
           end;     
           
           
           
           --- CRECIMIENTO AHORROS
           -- CAPTACION
           Begin
               select sum(case when nvl(y.ind_clirec,0) = 0 or nvl(y.ind_colcaj,'N')= 'N' 
                               then (y.imp_renmn - y.saldo)/nvl(y.num_titcta,1)
                               else 0
                           end)
                 into ln_capaho               
                 From tmp_fact_pasivos_proase y
                 Where codigo_asesor = x.codigo_asesor
                   and tipreg = 3 and cod_modcta = 21;
           exception when others then
              ln_capaho :=0;
           end; 
           -- MANTENIMIENTO  
           Begin
                select sum(nvl(y.sldcaho,0))-sum(nvl(y.sldbaho,0))    
                  into ln_manaho
                  from dwstage.tmp_fact_pasivos_proase y
                  where codigo_asesor = x.codigo_asesor
                  and tipreg = 1;
            exception when others then
              ln_manaho :=0;
            end;  
            
            --> 2023.09.29 Formula Nueva
            If ln_manaho <= 0 Then
               ln_creaho := (ln_capaho)/(ln_metnue*lnmeta2);
            Else 
               ln_creaho := ((ln_manaho+ln_capaho)/(ln_metnue*lnmeta2));
            End If;
                 
            /*if ln_manaho+ln_capaho < 0 Then
               ln_creaho := 0;
            else    
               ln_creaho := ((ln_manaho+ln_capaho)/(ln_metnue*lnmeta2));
            end If;*/
            --< 2023.09.29 Formula Nueva
            
           -- PESO/META/PAGO INDIC2:AHORROS
           BEGIN
             select d.tp1imp2,d.tp1imp1,r.tp1imp3/100 
               Into lnpeso2,lnmeta2,lnpago2
               from dwextra.fst198 d 
               Join dwextra.fst198 r on r.tp1cod = d.tp1cod
                                    and r.tp1cod1 = d.tp1cod1
                                    and r.tp1corr1 = d.tp1corr1
                                    and r.tp1corr2 = d.tp1nro2
                                    and r.tp1corr3 = d.tp1corr3
                                   
                where d.tp1cod1 = ln_guiapr                      
                and d.tp1corr1 = 36 
                and d.tp1nro1 = 2--tabla2
                and d.tp1corr2 = x.niveje --codigo perfil
                and d.tp1corr3 =ln_period --periodo  
                --and (nvl(x.PONAHO,0)/d.tp1imp1)*100 between r.tp1imp1 and r.tp1imp2;
                and ln_creaho*100 between r.tp1imp1 and r.tp1imp2;
           exception when others then
              lnpeso2 := 0; lnmeta2 :=0; lnpago2:=0;
           end;     
           
           -- PESO/META/PAGO INDIC3:RENOV DPF
           BEGIN
             select d.tp1imp2,d.tp1imp1,r.tp1imp3/100 
               Into lnpeso3,lnmeta3,lnpago3
               from dwextra.fst198 d 
               Join dwextra.fst198 r on r.tp1cod = d.tp1cod
                                    and r.tp1cod1 = d.tp1cod1
                                    and r.tp1corr1 = d.tp1corr1
                                    and r.tp1corr2 = d.tp1nro2
                                    and r.tp1corr3 = d.tp1corr3
                                   
                where d.tp1cod1 = ln_guiapr                      
                and d.tp1corr1 = 36 
                and d.tp1nro1 = 3 --tabla2
                and d.tp1corr2 = x.niveje --codigo perfil
                and d.tp1corr3 =ln_period --periodo  
                and round((nvl(x.PONREN,0)/d.tp1imp1)*100,2) between r.tp1imp1 and r.tp1imp2;
           exception when others then
              lnpeso3 := 0; lnmeta3 :=0; lnpago3:=0;
           end;          
           
           -- Logro agencia1
           begin
              select e.por_logacum,
                     nvl(e.imp_avaaho,0)+nvl(e.imp_avacts,0)+nvl(e.imp_avadpf,0) impacu,
                     nvl(e.imp_metaho,0)+nvl(e.imp_metcts,0)+nvl(e.imp_metdpf,0) metacu
                Into ln_psuc1,ln_msuc1,ln_isuc1
                from dwhouse.fact_pasivo_prodinc_res e 
                Join dwhouse.dm_geografia ge on ge.geografia_key = e.geografia_key
               where e.tiempo_key = ln_inimes
                 and e.ind_tipmet = 1
                 and ge.cod_sucurs = x.codsuc;
           exception when others then
              ln_psuc1 := 0;
              ln_msuc1 := 0;
              ln_isuc1 := 0;
           end;   

     
           -- PESO/META/PAGO INDIC4:AGENCIA1
           BEGIN
             select d.tp1imp2,d.tp1imp1,r.tp1imp3/100 
               Into lnpeso4,lnmeta4,lnpago4
               from dwextra.fst198 d 
               Join dwextra.fst198 r on r.tp1cod = d.tp1cod
                                    and r.tp1cod1 = d.tp1cod1
                                    and r.tp1corr1 = d.tp1corr1
                                    and r.tp1corr2 = d.tp1nro2
                                    and r.tp1corr3 = d.tp1corr3
                                   
                where d.tp1cod1 = ln_guiapr                      
                and d.tp1corr1 = 36 
                and d.tp1nro1 = 4 --tabla2
                and d.tp1corr2 = x.niveje --codigo perfil
                and d.tp1corr3 =ln_period --periodo  
                and (nvl(ln_psuc1,0)/d.tp1imp1)*100 between r.tp1imp1 and r.tp1imp2;
           exception when others then
              lnpeso4 := 0; lnmeta4 :=0; lnpago4:=0;
           end;    
           
           
           -- Logro agencia2
           begin
              select e.por_logacum,
                     nvl(e.imp_avaaho,0)+nvl(e.imp_avacts,0)+nvl(e.imp_avadpf,0) impacu,
                     nvl(e.imp_metaho,0)+nvl(e.imp_metcts,0)+nvl(e.imp_metdpf,0) metacu
                Into ln_psuc2,ln_msuc2,ln_isuc2
                from dwhouse.fact_pasivo_prodinc_res e 
                Join dwhouse.dm_geografia ge on ge.geografia_key = e.geografia_key
               where e.tiempo_key = ln_inimes
                 and e.ind_tipmet = 1
                 and ge.cod_sucurs = x.sucsec;
           exception when others then
              ln_psuc2 := 0;
              ln_msuc2 := 0;
              ln_isuc2 := 0;
           end;
           -- PESO/META/PAGO INDIC4:AGENCIA2
           BEGIN
             select d.tp1imp2,d.tp1imp1,r.tp1imp3/100 
               Into lnpeso5,lnmeta5,lnpago5
               from dwextra.fst198 d 
               Join dwextra.fst198 r on r.tp1cod = d.tp1cod
                                    and r.tp1cod1 = d.tp1cod1
                                    and r.tp1corr1 = d.tp1corr1
                                    and r.tp1corr2 = d.tp1nro2
                                    and r.tp1corr3 = d.tp1corr3
                                   
                where d.tp1cod1 = ln_guiapr                      
                and d.tp1corr1 = 36 
                and d.tp1nro1 = 5 --tabla2
                and d.tp1corr2 = x.niveje --codigo perfil
                and d.tp1corr3 =ln_period --periodo  
                and (nvl(ln_psuc2,0)/d.tp1imp1)*100 between r.tp1imp1 and r.tp1imp2;
           exception when others then
              lnpeso5 := 0; lnmeta5 :=0; lnpago5:=0;
           end;  
           
           
           
         

           Begin
               Update TMP_FACT_PASIVOS_PROASE d 
                  set d.rnk_logro = ln_rnkase,
                      ind1_peso = lnpeso1,
                      ind1_meta = lnmeta1,
                      ind1_pago = lnpago1,
                      ind1_logro= nvl(x.por_logro,0),
                      ind2_peso = lnpeso2,
                      ind2_meta = lnmeta2,
                      ind2_logro= ln_creaho, --nvl(x.PONAHO,0),
                      ind2_pago = lnpago2,
                      ind3_peso = lnpeso3,
                      ind3_meta = lnmeta3,
                      ind3_logro= nvl(x.PONREN,0),
                      ind3_pago = lnpago3,
                      ind4_logro = nvl(ln_psuc1,0),
                      ind4_peso = lnpeso4,
                      ind4_meta = lnmeta4,
                      ind4_pago = lnpago4,
                      ind5_logro  = nvl(ln_psuc2,0),
                      ind5_peso = lnpeso5,
                      ind5_meta = lnmeta5,
                      ind5_pago = lnpago5,
                      saldo_aho = ln_msuc1,
                      sldaho    = ln_isuc1,
                      saldo_dpf = ln_msuc2,
                      slddpf    = ln_isuc2,
                      --ponnue    = (Case when nvl(ln_psuc2,0) < 1 then 0 else ln_bono end), -- bono segunda agencia
                      ponnue    = (Case when nvl(ln_psuc2,0) < 1 then 0 else x.PONRE1 end),
                      ponsld    = lnpsob,   --bono sobrecumpliemnto saldo
                      sldbaho   = (lnmeta2 * metnue), --metaaho
                      sldcaho   =  nvl(ln_capaho,0) + nvl(ln_manaho,0),
                      ponaho    = ln_creaho
                 Where d.codigo_asesor = x.codigo_asesor
                   and d.tiempo_key = x.tiempo_key
                   and ind_version = 2
                   and d.tipreg = 0;
               Commit;  
           Exception WHen Others Then
              lv_err := substr(sqlerrm,1,200);
              dbms_output.put_line('UPD-LOGROS:'||lv_err);
           End;     
       End Loop;
       
       -- Inserta DETALLE DE DPF RENOVADOS
       Delete from TMP_FACT_PASIVOS_PROASE n where n.tipreg=2 and ind_version = 2;
       Commit;
       Begin
       Insert Into TMP_FACT_PASIVOS_PROASE(fecha,tiempo_key,periodo,codigo_asesor,asesor_key,
                                           cliente_key,codigo_cliente,saldo,
                                           cuentas_key,cuentas_ren_key,
                                           codigo_cuenta,codigo_cuenta_ren,imp_renmn,
                                           ind_ctaren,ind_tipren,tipreg,fec_vencta,
                                           ind_venmes,fec_cancela,cod_cuenta,imp_tipcam,
                                           Fecha_Sld,Fecha_Apre,Cod_Ctacli,Num_Titcta,ind_version,Key_Geografia)
        Select s.fecha,s.tiempo_key,to_number(to_char(s.fecha,'rrrrmm')),s.codigo_asesor,s.asesor_key,s.cliente_key,
               s.codigo_cliente, s.saldo_mn,
               s.cuentas_key,s.cuenta_ren_key,s.codigo_cuenta,s.codigo_ctaren,s.imp_renovmn,s.ind_ctaren,s.ind_tipren,2,
               s.fecha_vencimie,
               Case when to_char(s.fecha_vencimie,'rrrrmm') = to_char(s.fecha,'rrrrmm') Then 'Si' Else 'No' End,
               s.fecha_cancela,s.cod_cuenta,
               ln_tipcam,ld_feccon,s.fecha_apre,s.cod_ctacli,s.num_intcta,2,s.geografia_key
          From TMP_FACT_PRODASE_ASIGCLI s       
         Where s.codigo_producto = '22'      
           and s.est_asesor = 'S';
          -- and s.fecha = ld_inimes;
         Commit;
         Exception WHen Others Then
              lv_err := substr(sqlerrm,1,200);
              dbms_output.put_line('INS-PDF RENOVADOS:'||lv_err);
         End;   
  END SP_PRAS_LOGROS_V4;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- -- --
  Procedure SP_PRAS_METAS(PD_FECHA In Date) 
  Is
    ln_existe number(5);
    ln_period number(10) := to_number(to_char(PD_FECHA,'RRRRMM'));
    ln_perant number(10) := to_number(to_char(add_months(PD_FECHA,-1),'rrrrmm'));
  Begin
      
      Select count(*) Into ln_existe
       From dwextra.fst198 where tp1cod1 = 10819 and 
       tp1corr2 = ln_period and tp1corr1 in (35,36,37); 
       
      If ln_existe = 0 Then 
         Insert into dwextra.fst198(tp1cod, tp1cod1, tp1corr1, tp1corr2, tp1corr3, tp1nro1, 
                                    tp1nro2, tp1nro3, tp1desc, tp1imp1, tp1imp2, tp1imp3)

         Select tp1cod, tp1cod1, tp1corr1, ln_period tp1corr2, tp1corr3, tp1nro1, 
                tp1nro2, tp1nro3, tp1desc, 
                case when tp1corr1 = 35 and tp1corr2 = 1 then 1 else tp1imp1 end tp1imp1, 
                case when tp1corr1 = 35 and tp1corr1 = 1 then 0 else tp1imp2 end tp1imp2,  
                tp1imp3 
           from dwextra.fst198 where tp1cod1 = 10819 
           and tp1corr2 = ln_perant;
         Commit;
      End If;   
      
      ln_existe:= 0;  
      Select count(*) Into ln_existe
       From dwextra.fst198 where tp1cod1 = 10819 and 
       tp1corr3 = ln_period and tp1corr1 in (35,36,37);    
      If ln_existe = 0 Then 
         Insert into dwextra.fst198(tp1cod, tp1cod1, tp1corr1, tp1corr2, tp1corr3, tp1nro1, 
                                    tp1nro2, tp1nro3, tp1desc, tp1imp1, tp1imp2, tp1imp3)
         Select tp1cod, tp1cod1, tp1corr1, tp1corr2, ln_period tp1corr3, tp1nro1, 
                tp1nro2, tp1nro3, tp1desc, 
                case when tp1corr1 = 35 and tp1corr2 = 1 then 0 else tp1imp1 end tp1imp1, 
                case when tp1corr1 = 35 and tp1corr2 = 1 then 0 else tp1imp2 end tp1imp2,
                case when tp1corr1 = 35 and tp1corr2 = 1 then 0 else tp1imp3 end tp1imp3
           from dwextra.fst198 where tp1cod1 = 10819 and tp1corr3 = ln_perant
            and tp1corr1 in (35,36,37);
         Commit;
      End If;
      
      --- Porcentajes dias libres  
      ln_existe:= 0;  
      Select count(*) Into ln_existe
        From dwextra.fst198 where tp1cod1 = 10819 and 
        tp1nro1 = ln_period and tp1corr1 = 38;   
      If ln_existe = 0 Then 
         Insert into dwextra.fst198(tp1cod, tp1cod1, tp1corr1, tp1corr2, tp1corr3, tp1nro1, 
                                    tp1nro2, tp1nro3, tp1desc, tp1imp1, tp1imp2, tp1imp3)
         Select tp1cod, tp1cod1, tp1corr1, tp1corr2, tp1corr3, ln_period tp1nro1, 
                tp1nro2, tp1nro3, tp1desc, tp1imp1, tp1imp2, tp1imp3
           from dwextra.fst198 where tp1cod1 = 10819 and tp1nro1 = ln_perant
            and tp1corr1 = 38;
         Commit;
      End If;         
       
  End SP_PRAS_METAS;    
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- -- --
  PROCEDURE SP_INC_EJECUTA(PD_FECHA In Date)
  IS
        ld_fecha date := PD_FECHA;
  BEGIN
       PQ_TMP_PRODUCTIVIDADASE.SP_INC_METAS(ld_fecha);
       PQ_TMP_PRODUCTIVIDADASE.SP_INC_REGCLI(ld_fecha);
       PQ_TMP_PRODUCTIVIDADASE.SP_INC_SALDOS(ld_fecha);
       PQ_TMP_PRODUCTIVIDADASE.SP_INC_CLASIFICA_DEP(ld_fecha);
       PQ_TMP_PRODUCTIVIDADASE.SP_INC_APERTURA_DIG(ld_fecha);
       PQ_TMP_PRODUCTIVIDADASE.SP_INC_ACT_METAS_AGENCIAS(ld_fecha);
       PQ_TMP_PRODUCTIVIDADASE.SP_INC_RESULTADOS(ld_fecha);
       
       PQ_TMP_PRODUCTIVIDADASE.SP_INC_SALDOS_AGE(ld_fecha);
       PQ_TMP_PRODUCTIVIDADASE.SP_INC_RESULTADOS_AGE(ld_fecha);
       --dwhouse.PQ_CARGA_PRODUCTIVIDAD.SP_CARGA_PRODINC(ld_fecha); 
  End SP_INC_EJECUTA;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- -- --   
  PROCEDURE SP_INC_METAS(PD_FECHA In Date)
  IS
      ld_fmes date := PD_FECHA;
      ld_imes date := to_date(to_char(ld_fmes,'rrrrmm')||'01','rrrrmmdd');
      ln_fmes number(6) := to_number(to_char(PD_FECHA,'rrrrmm'));
      ld_fmant date := last_day(add_months(PD_FECHA,-1));
      ln_fmant number(6) := to_number(to_char(ld_fmant,'rrrrmm'));
      ln_exist number(5);
      ln_meta1 number(12,2); 
      ln_meta2 number(12,2);
      ln_meta3 number(12,2);
      ln_dia number(2) := to_number(to_char(PD_FECHA,'dd')); 
      ln_tiek number(10) := dwhouse.pq_carga_facts.fn_tiempo_key(ld_fmant);
      ld_fmesp date := ld_fmant;
      ln_existe number(10);
      ld_fdiap date;
      ln_perio number(8) := to_number(to_char(ld_fmes,'rrrrmm'));
      lv_script varchar2(3000);
  BEGIN
       -----------------
       -- ANALISTAS
       -----------------
       IF ld_fmes = last_day(ld_fmes) and to_number(to_char(ld_fmes,'rrrrmm')) < to_number(to_char(trunc(sysdate-1),'rrrrmm')) Then
           delete from DWEXTRA.fst198 where tp1cod1=10819 and tp1corr1=302 and tp1corr3 = ln_fmes;
           commit;   
           
           lv_script := 'Insert Into DWEXTRA.fst198(tp1cod,tp1cod1,tp1corr1,tp1corr2,tp1corr3, '||
                                      'tp1desc,tp1nro1,tp1nro2,tp1imp1,tp1imp2) '|| 
                'Select 1 tp1cod,10819 tp1cod1,302 tp1corr1,rownum tp1corr2, :1 tp1corr3, '||
                       'trim(s.sng057usr), '||
                       'dwstage.pq_tmp_productividadase.FN_TIPO_ANALISTA(d.jaqn002pai,d.jaqn002tdo,trim(d.jaqn002ndo),:2) tipana, '||
                       ':3 tp1nro2,  '||
                       '1 tp1imp1, '||
                       'case when ag.ubsuc = 904 then '||
                            'dwstage.pq_tmp_productividadase.FN_CODAGE_ANALISTA(d.jaqn002pai,d.jaqn002tdo,trim(d.jaqn002ndo),:4,ag.ubsuc) '||
                            'else ag.ubsuc  '||
                       'end '||  
                  'From dwbkext.sng057_'||to_char(ld_fmes,'rrrrmmdd')||' s '||
                  'Join dwbkext.fst046_'||to_char(ld_fmes,'rrrrmmdd')||' ag on ag.ubuser = s.sng057usr '||
                  'Join jaqn002@produ d on d.jaqn002usr = s.sng057usr '||
                 'Where s.sng055car in (200,201) '||
                   'and (s.sng057fin is null or s.sng057fin = ''1/01/0001'' or s.sng057fin = :5) '||
                   'and exists (select 1 from dwextra.v_anexo17a an '||
                                'Where an.pais = d.jaqn002pai and an.tipodoc = d.jaqn002tdo and trim(an.nu_docu_iden) = trim(d.jaqn002ndo) '||
                                  'and to_date(an.fe_ingr_emp,''rrrr.mm.dd'') <= :6 '||
                                  'and (an.emp_estado = ''ACTIVO'' '||
                                  'OR  an.emp_estado = ''CESADO'' and to_date(an.fe_cese_trab,''rrrr.mm.dd'') > :7 '||
                                  ') '||
                               ')';
                   Execute Immediate lv_script Using ln_perio,ld_fmes,ln_perio,ld_fmes,ld_fmes,ld_fmes,ld_fmes;  
               
       ELSE 
           delete from DWEXTRA.fst198 where tp1cod1=10819 and tp1corr1=302 and tp1corr3 = ln_fmes;
           commit;   
          
           Insert Into DWEXTRA.fst198(tp1cod,tp1cod1,tp1corr1,tp1corr2,tp1corr3,
                                      tp1desc,tp1nro1,tp1nro2,tp1imp1,tp1imp2) 
                Select 1 tp1cod,10819 tp1cod1,302 tp1corr1,rownum tp1corr2, ln_perio tp1corr3,
                       trim(s.sng057usr),
                       dwstage.pq_tmp_productividadase.FN_TIPO_ANALISTA(d.jaqn002pai,d.jaqn002tdo,trim(d.jaqn002ndo),ld_fmes) tipana,
                       ln_perio tp1nro2, 
                       1 tp1imp1,
                       case when ag.ubsuc = 904 then
                            dwstage.pq_tmp_productividadase.FN_CODAGE_ANALISTA(d.jaqn002pai,d.jaqn002tdo,trim(d.jaqn002ndo),ld_fmes,ag.ubsuc)
                            else ag.ubsuc 
                       end  
                  From sng057@produ s 
                  Join fst046@produ ag on ag.ubuser = s.sng057usr
                  Join jaqn002@produ d on d.jaqn002usr = s.sng057usr
                 Where s.sng055car in (200,201)
                   and (s.sng057fin is null or s.sng057fin = '1/01/0001' or s.sng057fin = ld_fmes)
                   and exists (select 1 from dwextra.v_anexo17a an
                                Where an.pais = d.jaqn002pai and an.tipodoc = d.jaqn002tdo and trim(an.nu_docu_iden) = trim(d.jaqn002ndo)
                                  and to_date(an.fe_ingr_emp,'rrrr.mm.dd') <= ld_fmes
                                  and (an.emp_estado = 'ACTIVO'
                                  OR  an.emp_estado = 'CESADO' and to_date(an.fe_cese_trab,'rrrr.mm.dd') > ld_fmes
                                  )
                               );  
       END IF;
         /*
       IF ld_fmes <= last_day(ld_fmes) and to_char(ld_fmes,'rrrrmm') = to_char(trunc(sysdate-1),'rrrrmm') Then
          --- Fecha de carga
          SELECT max(jaql600fpro) Into ld_fdiap
          from jaql600@produ where jaql600fpro between ld_fmesp and ld_fmes;
          
          --- ld_fmant
          SELECT COUNT(*) Into ln_existe
          from jaql600@produ where jaql600fpro = ld_fdiap;--ld_fmesp
          --and jaql600codcat <> 0 ;--AND NVL(jaql600PMRA,0) < 60;
          
          If ln_existe = 0 Then
             --ld_fmesp := 
             ld_fdiap := last_day(add_months(ld_fmesp,-1)); 
          End If;
                         
          delete from DWEXTRA.fst198 where tp1cod1=10819 
             and tp1corr1=302 and tp1corr3 = ln_fmes;
          commit;   
          
          BEGIN
                Insert Into DWEXTRA.fst198(tp1cod,tp1cod1,tp1corr1,tp1corr2,tp1corr3,
                                           tp1desc,tp1nro1,tp1nro2,tp1imp1,tp1imp2) 
                
                select 1,10819,302,rownum,ln_fmes,trim(jaql600usu),
                          case when jaql600codcat = 8 then 9 
                               when jaql600codcat = 3 then 5
                               when jaql600codcat = 4 then 4
                               when jaql600codcat = 2 then 6
                               when jaql600codcat = 6 then 1 
                               when jaql600codcat = 9 then 2   
                               when jaql600codcat = 5 then 3
                               when jaql600codcat = 7 then 7
                               when jaql600codcat IN (1,0)then 8
                          else null
                          end code,to_number(to_char(jaql600fpro,'rrrrmm')),
                              1 estado,ag.ubsuc
                        from jaql600@produ an--ld_fmesp
                         Join fst046@produ ag on ag.ubuser = an.jaql600usu
                         where jaql600fpro = ld_fdiap
                         and exists (select 1 from jaqy830@produ 
                                      where jaqy830codana = jaql600usu 
                                        and jaqy830est='S');
                         --and jaql600codcat <> 0;-- AND NVL(jaql600PMRA,0) < 60;
 
              
                        Commit; 
          EXCEPTION WHEN OTHERS THEN
              NULL;
          END;              
       END IF;        
          */       
       -----------------
       -- METAS AGENCIAS
       -----------------
       select count(*) Into ln_exist from DWEXTRA.fst198 where tp1cod1=10819 and tp1corr1=301 and tp1corr3 = ln_fmes;
       If ln_exist = 0 Then
           -- Copia del mes anterior
           Insert Into DWEXTRA.fst198(tp1cod,tp1cod1,tp1corr1,tp1corr2,tp1corr3,tp1desc,tp1imp1,tp1imp2,tp1imp3)
           select tp1cod,tp1cod1,tp1corr1,tp1corr2, ln_fmes,tp1desc,tp1imp1,tp1imp2,tp1imp3  
             from DWEXTRA.fst198 x
            where tp1cod1=10819 and tp1corr1=301 and tp1corr3 = ln_fmant
              and tp1corr2 not in (78,904)
              and exists (select 1 
                           from dwhouse.fact_pasivo p
                           join dwhouse.dm_geografia g on g.geografia_key = p.geografia_key
                          where p.estado_key <> 72
                            and to_number(g.codigo_agencia) = x.tp1corr2
                            and tiempo_key = ln_tiek
                          ); 
           Commit;
           -- AGENCIAS NUEVAS COPIA DE TIPO D ULTIMO CODIGO
           Begin
                   select tp1imp1,tp1imp2,tp1imp3 Into ln_meta1, ln_meta2,ln_meta3
                     from DWEXTRA.fst198 a
                    where tp1cod1=10819 and tp1corr1=301 and tp1corr3 = ln_fmes and trim(tp1desc)= 'D' 
                      and tp1corr2 = (select max(tp1corr2) from DWEXTRA.fst198 b 
                                      where b.tp1cod = a.tp1cod and b.tp1cod1 = a.tp1cod1 and b.tp1corr1 = a.tp1corr1
                                      and b.tp1corr3 = a.tp1corr3 and b.tp1desc = a.tp1desc); 
             
                   Insert Into DWEXTRA.fst198(tp1cod,tp1cod1,tp1corr1,tp1corr2,tp1corr3,tp1desc,tp1imp1,tp1imp2,tp1imp3)
                               select 1,10819,301,sucurs,ln_fmes,'D',ln_meta1,ln_meta2,ln_meta3 
                                 from fst001@produ where calcod not in (1,2)
                                  and sucurs not in (select tp1corr2 from DWEXTRA.fst198
                                                     where tp1cod1=10819 and tp1corr1=301 and tp1corr3 = ln_fmes)
                                  and exists (select 1 
                                               from dwhouse.fact_pasivo p
                                               join dwhouse.dm_geografia g on g.geografia_key = p.geografia_key
                                              where p.estado_key <> 72
                                                and to_number(g.codigo_agencia) = sucurs
                                                and tiempo_key = ln_tiek);
                                                                                
                   Commit;
           Exception When Others Then
               Null;
           End;                         
       End If;
  End SP_INC_METAS;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE SP_INC_REGCLI(PD_FECDIA In Date)
  IS
    -- Clientes Registrados en Herramienta Autogesti/Agenda Comercial
    Cursor c_cliage(ld_ini in Date, ld_fmax in date) is
           
             SELECT DISTINCT NPAIS jaql108pai,NTDOC jaql108ptd,trim(VNDOC) jaql108doc,
                             TRIM(NPAIS||NTDOC||trim(VNDOC)) codcli,
                             NPAIS pais,NTDOC tdoc,RPAD(trim(VNDOC),12,' ') ndoc
             FROM TMP_AGECOM;
             --where trim(VNDOC) like '%40518222%';
             
             
      ld_feccon Date := PD_FECDIA;
      ln_perdia number(6) := to_number(to_char(PD_FECDIA,'rrrrmm'));
      ld_regcli date := PD_FECDIA;
      ld_inimes date := to_date(to_char(ld_feccon,'rrrrmm')||'01','rrrrmmdd');
      ln_tiempo number(10) := dwhouse.pq_carga_facts.fn_tiempo_key(ld_inimes);  
      ld_fecreg timestamp;       
      lv_usureg varchar2(20); 
      ln_tip number(5);
      ln_agekey number(10);
      ln_regana number(5);
      ln_ha number(5);
      ln_keyana number(10);
      ln_ac number(5);
      ln_geoope number(10);
      lv_agedes varchar2(50);
      ln_keyase number(10);
      lv_script varchar2(1000);
   Begin
       Execute Immediate 'Truncate table TMP_FACT_PASIVO_CLICAP';
       /*Execute Immediate 'Truncate table TMP_AGECOM';
       
       
       BEGIN
            If ld_feccon <= to_date('20220531','rrrrmmdd') Then
               Execute Immediate 'INSERT INTO TMP_AGECOM(FECEVA,USUREG,NPAIS,NTDOC,VNDOC,VOBSE,FECPRO) '||
                                 'Select eva.dfeceva,eva.cusuing,eva.npaicli,eva.ntipdoc,eva.cnumdoc,'||
                                        'trim(upper(replace(rev.cobserv,'' '',''''))) cobserv,sysdate '||
                                   'From agecom.acdeval@produ eva '||
                                   'Join agecom.acdrevi@produ rev on '||
                                        'rev.npaicli = eva.npaicli '||
                                     'and rev.ntipdoc = eva.ntipdoc '||
                                     'and rev.cnumdoc = eva.cnumdoc '||
                                     'and rev.ncodact = eva.ncodact '||
                                     'and rev.ncodbas = eva.ncodbas '||
                                   'where eva.ncodact = 1 '||
                                     'and eva.ncodbas = 5 '||
                                     'and trunc(eva.dfeceva) between :1 and :2 '||
                                     'and rev.cobserv is not null '||
                                     'and trim(upper(replace(rev.cobserv,'' '',''''))) in (''P'',''PC'',''CP'',''P.C'',''C.P'',''C-P'',''P-C'') '||
                                     'UNION ALL '||
                                 'Select eva.dfeceva,eva.cusuing,eva.npaicli,eva.ntipdoc,eva.cnumdoc,'||
                                        'trim(upper(replace(rev.cobserv,'' '',''''))) cobserv,sysdate '||
                                   'From agecom.acdeval@produ eva '||
                                   'Join agecom.achrevi@produ rev on '||
                                        'rev.npaicli = eva.npaicli '||
                                    'and rev.ntipdoc = eva.ntipdoc '||
                                    'and rev.cnumdoc = eva.cnumdoc '||
                                    'and rev.ncodact = eva.ncodact '||
                                    'and rev.ncodbas = eva.ncodbas '||
                                  'Where eva.ncodact = 1 '||
                                    'and eva.ncodbas = 5 '||
                                    'and trunc(eva.dfeceva) between :3 and :4 '||
                                    'and rev.cobserv is not null  '||
                                    'and trim(upper(replace(rev.cobserv,'' '',''''))) in (''P'',''PC'',''CP'',''P.C'',''C.P'',''C-P'',''P-C'') '
                 Using ld_inimes,ld_regcli,ld_inimes,ld_regcli;
                 Commit;
                 
                 Execute Immediate 'INSERT INTO TMP_AGECOM(FECEVA,USUREG,NPAIS,NTDOC,VNDOC,VOBSE,FECPRO) '||
                         'Select distinct to_date(to_char(p.jaql108fch,''rrrrmmdd'')||'' ''||trim(p.jaql108a04),''rrrrmmdd hh24:mi:ss''),'||
                                'trim(p.jaql108usu),'||
                                'decode(aqpb508pain,null,p.jaql108pai,aqpb508pain) jaql108pai,'||
                                'decode(r.aqpb508ptdn,null,p.jaql108ptd,r.aqpb508ptdn) jaql108ptd,'||
                                'decode(r.aqpb508docn,null,p.jaql108doc,rpad(r.aqpb508docn,12,'' '')) jaql108doc,'||
                                '''HA'',to_date(to_char(p.jaql108fch,''rrrrmmdd'')||'' ''||trim(p.jaql108a04),''rrrrmmdd hh24:mi:ss'') '||
                          'From dwextra.jaql108 p '||        
                     'Left Join dwextra.aqpb508 r '||   
                            'on r.aqpb508paio = p.jaql108pai '||
                           'and r.aqpb508ptdo= p.jaql108ptd '||
                           'and r.aqpb508doco= trim(p.jaql108doc) '||
                           'and r.aqpb508fcho= p.jaql108fch '||
                           'and r.aqpb508est = ''V'' '||
                         'Where jaql108fch between :1 and :2'
                 Using ld_inimes,ld_regcli;
                 Commit;        
            End If; */
              /*select eva.dfeceva,eva.cusuing,eva.npaicli,eva.ntipdoc,eva.cnumdoc,
                     trim(upper(replace(rev.cobserv,' ',''))) cobserv,sysdate
                from agecom.acdeval@produ eva
                Join agecom.acdrevi@produ rev on
                 rev.npaicli = eva.npaicli
                 and rev.ntipdoc = eva.ntipdoc
                 and rev.cnumdoc = eva.cnumdoc
                 and rev.ncodact = eva.ncodact
                 and rev.ncodbas = eva.ncodbas
               where eva.ncodact = 1
                 and eva.ncodbas = 5
                 and trunc(eva.dfeceva) between ld_inimes and ld_regcli
                 and rev.cobserv is not null
                 and trim(upper(replace(rev.cobserv,' ',''))) in ('P','PC','CP','P.C','C.P','C-P','P-C');*/
       /*EXCEPTION WHEN OTHERS THEN
           NUll;          
       END;*/

       -- Excepcion solicitada por Karolina solo para Abril 2022 
       IF to_char(ld_feccon,'rrrrmm') = '202204' Then
          ld_regcli := ld_regcli + 5;
       End IF;

  
       For x in c_cliage(ld_inimes,ld_regcli) Loop
           Begin
             If ld_feccon <= to_date('20220531','rrrrmmdd') Then  
                Select jaql108usu,fecha,n_tipo
                  Into lv_usureg ,ld_fecreg,ln_tip
                      From(
                           Select trim(y.jaql108usu) jaql108usu,
                                  to_date(to_char(y.jaql108fch,'rrrrmmdd')||' '||trim(y.jaql108a04),'rrrrmmdd hh24:mi:ss') fecha,
                                  1 n_tipo
                             from dwextra.jaql108 y
                            Where y.jaql108pai = x.pais
                              and y.jaql108ptd = x.tdoc 
                              and y.jaql108doc = x.ndoc
                              and y.jaql108fch between ld_inimes and ld_regcli
                                  UNION ALL
                           SELECT UPPER(USUREG),FECEVA,3
                             FROM TMP_AGECOM
                            where NPAIS=x.pais and NTDOC=x.tdoc and VNDOC = trim(x.ndoc)
                            Order by 2
                          ) Where Rownum = 1;
             Else
                Select USUREG,FECEVA,n_tipo
                  Into lv_usureg ,ld_fecreg,ln_tip
                  From (SELECT UPPER(USUREG) USUREG ,FECEVA,1 n_tipo
                          FROM TMP_AGECOM
                         where NPAIS=x.pais and NTDOC=x.tdoc and trim(VNDOC) = trim(x.ndoc)
                         Order by 2
                        ) 
                  Where Rownum = 1;
             End If;    
                      
            Exception When Others Then
               lv_usureg := Null;
            End;   
            
            ln_keyana := null;
            ln_agekey := null;
            lv_agedes := null;
            ln_geoope := null;
            
                If ln_tip = 1 Then -- REVISAR SI ES EJECUTIVO / ANALISTA / 
                   Select count(*) Into ln_regana from DWEXTRA.fst198 
                    where tp1cod1=10819 and tp1corr1=302 and tp1corr3 = ln_perdia
                          and trim(tp1desc) = TRIM(lv_usureg) --NUEVO
                          and tp1nro1 is not null; --NUEVO
                         
                    If ln_regana > 0 Then
                       ln_ha := 2;      -- Registro en HA de Analista
                       ln_keyana := pq_tmp_carga_key.fn_analista_key(lv_usureg); 
                       -- Agencia de Analista
                       Begin
                           select ge.geografia_key,ge.nombre_agencia
                             Into ln_agekey,lv_agedes
                            from DWEXTRA.fst198 pr
                            JOIN dwhouse.dm_geografia ge on to_number(ge.codigo_agencia) = pr.tp1imp2
                            where tp1cod1=10819 and tp1corr1=302 and tp1corr3 = ln_perdia
                              and trim(tp1desc) = lv_usureg
                              and ge.tipo_region = 'R';
                          /*
                          select ge.geografia_key,ge.nombre_agencia
                            Into ln_agekey,lv_agedes
                            from Jaqy830@produ pr
                            JOIN dwhouse.dm_geografia ge on upper(trim(ge.nombre_agencia)) = trim(upper(pr.jaqy830agen))
                           where jaqy830est='S' and trim(jaqy830codana) = lv_usureg
                             and tipo_region = 'R';*/
                       Exception When Others Then
                            ln_agekey := Null;
                       End;
                    Else 
                       
                       --- Buscar si es Ejecutivo
                       Select count(*) Into ln_regana from dwhouse.dm_asesor
                         where codigo_asesor  = lv_usureg;
                       If ln_regana > 0 Then  
                          ln_ha := 3;      -- Registro en HA de Ejecutivo
                       Else
                           -- Buscar si es asesor comercial
                           select count(*) Into ln_regana
                           from prfu00@produ where trim(ubuser) = lv_usureg 
                            and PRFGCOD like 'PCRE%';
                           If ln_regana > 0 Then
                              ln_tip := 3;
                              ln_ac := 1;         -- Registro en AC de Asesor Creditos
                              ln_ha := 7;
                              ln_keyase := pq_tmp_carga_key.fn_usuario_key(lv_usureg); 
                           Else
                           --- Personal de Agencia
                           ln_ha := 1;
                           End If;
                       End If;   
                    End If;
                 ElsIf ln_tip = 3 Then
                       ln_ac := 1;         -- Registro en AC de Asesor Creditos
                       ln_ha := 7;
                       ln_keyase := pq_tmp_carga_key.fn_usuario_key(lv_usureg);
                 End If;
                 
                 
                 IF ln_agekey is null Or ln_agekey = 117893 Then
                    Begin
                        Select ge.geografia_key,ge.nombre_agencia,
                               dwstage.pq_tmp_carga_transacc.fn_key_region_op(ag.ubsuc,ld_feccon)
                          Into ln_agekey,lv_agedes,ln_geoope
                          From fst046@produ ag
                          Join dwhouse.dm_geografia ge on to_number(ge.codigo_agencia) = ag.ubsuc
                         Where ag.ubuser = rpad(lv_usureg,10,' ')
                           and ge.tipo_region = 'R';
                     Exception When Others Then
                        ln_agekey := Null;
                     End;
                 End IF;

                 -- Inserta registros de Agenda Comercial
                 If ld_feccon <= to_date('20220531','rrrrmmdd') Then 
                     Insert Into TMP_FACT_PASIVO_CLICAP(TIEMPO_KEY,CLIENTE_KEY,GEOGRAFIA_KEY,FEC_PROCESO,
                                                         cod_usureg,IND_TIPINC,
                                                         COD_EJEAHO,Cod_Anacre,Cod_Asecre,Cod_Usuage,
                                                         Analista_Key,Ageana_Key,Ind_Regcli,Fec_Regcli,ind_increg,
                                                         pais, tdoc, ndoc, asesor_key
                                                        ) 
                     Select ln_tiempo,pq_tmp_carga_key.fn_cliente_key(codcli),ln_agekey,
                            trunc(sysdate),jaql108usu,10,
                            decode(ln_ha,3,jaql108usu,null), decode(ln_ha,2,jaql108usu,null),decode(ln_ha,7,jaql108usu,null),
                            decode(ln_ha,1,jaql108usu,null),ln_keyana,
                            decode(ln_keyana,null,null,ln_agekey),ln_ha,fecreg,
                            case when trim(jaql108usu) = trim(lv_usureg) then 1 else 0 end,
                            jaql108pai,jaql108ptd,jaql108doc, ln_keyase
                       From (                                         
                             Select decode(r.aqpb508pain,null,p.jaql108pai,aqpb508pain) jaql108pai,
                                    decode(r.aqpb508ptdn,null,p.jaql108ptd,r.aqpb508ptdn) jaql108ptd,
                                    decode(r.aqpb508docn,null,p.jaql108doc,rpad(r.aqpb508docn,12,' ')) jaql108doc, 
                                    (case when r.aqpb508docn is null 
                                         then trim(p.jaql108pai||p.jaql108ptd||p.jaql108doc)
                                         else trim(r.aqpb508pain||r.aqpb508ptdn||r.aqpb508docn)
                                    end)codcli,
                                    p.jaql108pai pais,
                                    p.jaql108ptd tdoc,
                                    p.jaql108doc ndoc,
                                    min(to_date(to_char(p.jaql108fch,'rrrrmmdd')||' '||trim(p.jaql108a04),'rrrrmmdd hh24:mi:ss')) fecreg,
                                    trim(p.jaql108usu) jaql108usu
                               from dwextra.jaql108 p        -- HERRAMIENTA AUTOGESTION
                               left Join dwextra.aqpb508 r   -- REGULARIZA DOCUMENTO EN TRAMITE
                                      on r.aqpb508paio = p.jaql108pai
                                      and r.aqpb508ptdo= p.jaql108ptd
                                      and r.aqpb508doco= trim(p.jaql108doc)
                                      and r.aqpb508fcho= p.jaql108fch
                                      and r.aqpb508est = 'V'
                               Where jaql108fch between ld_inimes and ld_regcli
                                 and p.jaql108pai = x.pais
                                 and p.jaql108ptd = x.tdoc 
                                 and p.jaql108doc = x. ndoc
                               Group By r.aqpb508pain,p.jaql108pai,p.jaql108ptd,r.aqpb508ptdn,r.aqpb508docn,p.jaql108doc,jaql108usu  
                                 UNION ALL 
                                SELECT NPAIS,NTDOC,VNDOC,
                                       TRIM(NPAIS||NTDOC||VNDOC),
                                       NPAIS,NTDOC,RPAD(trim(VNDOC),12,' '),
                                       MIN(FECEVA),TRIM(USUREG)
                                  FROM TMP_AGECOM 
                                  where NPAIS=x.pais and NTDOC=x.tdoc and VNDOC = trim(x.ndoc)
                                GROUP BY  NPAIS,NTDOC,VNDOC,USUREG
                                );
                            Commit;   
                 Else
                    Insert Into TMP_FACT_PASIVO_CLICAP(TIEMPO_KEY,CLIENTE_KEY,GEOGRAFIA_KEY,FEC_PROCESO,
                                                         cod_usureg,IND_TIPINC,
                                                         COD_EJEAHO,Cod_Anacre,Cod_Asecre,Cod_Usuage,
                                                         Analista_Key,Ageana_Key,Ind_Regcli,Fec_Regcli,ind_increg,
                                                         pais, tdoc, ndoc, asesor_key
                                                        ) 
                     Select ln_tiempo,pq_tmp_carga_key.fn_cliente_key(codcli),ln_agekey,
                            trunc(sysdate),jaql108usu,10,
                            decode(ln_ha,3,jaql108usu,null), decode(ln_ha,2,jaql108usu,null),decode(ln_ha,7,jaql108usu,null),
                            decode(ln_ha,1,jaql108usu,null),ln_keyana,
                            decode(ln_keyana,null,null,ln_agekey),ln_ha,fecreg,
                            case when trim(jaql108usu) = trim(lv_usureg) then 1 else 0 end,
                            jaql108pai,jaql108ptd,jaql108doc, ln_keyase
                       From (                                         
                    
                                SELECT NPAIS jaql108pai,NTDOC jaql108ptd,trim(VNDOC) jaql108doc,
                                       TRIM(NPAIS||NTDOC||trim(VNDOC)) codcli,
                                       NPAIS pais,NTDOC tdoc,RPAD(trim(VNDOC),12,' ') ndoc,
                                       MIN(FECEVA) fecreg,TRIM(USUREG) jaql108usu
                                  FROM TMP_AGECOM 
                                 where NPAIS=x.pais and NTDOC=x.tdoc 
                                   and trim(VNDOC) = trim(x.ndoc)
                                GROUP BY  NPAIS,NTDOC,trim(VNDOC),USUREG
                                );
                            Commit; 
                 End If;          
                 
                
     
      End Loop;
      Begin
          --- Inserta Analistas que no captaron
          Insert Into TMP_FACT_PASIVO_CLICAP
                      (TIEMPO_KEY,FEC_PROCESO,IND_TIPINC,Cod_Anacre,
                       Analista_Key,Ageana_Key,Ind_Regcli
                      ) 
               Select ln_tiempo,trunc(sysdate),10,trim(ex.tp1desc),
                      an.analista_key,ge.geografia_key,2 
                 From dwextra.fst198 ex
                 Join dwhouse.dm_analista an on an.codigo_analista = trim(ex.tp1desc)
                 Join dwhouse.dm_geografia ge on to_number(ge.codigo_agencia) = ex.tp1imp2 
                  and ge.tipo_region = 'R'
                where tp1corr1 = 302 and tp1corr3 = ln_perdia
                  and not exists (select 1 from TMP_FACT_PASIVO_CLICAP where ind_regcli = 2 and trim(cod_anacre) = trim(tp1desc))
                  and tp1imp2 <> 904;
           Commit;       
      Exception When Others Then
         Null;
      End;
       
   End SP_INC_REGCLI;   
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- -- -- 
  ----------------------------------------- 
  --- PROCESO: carga y clasifica depositos
  -----------------------------------------
  PROCEDURE SP_INC_SALDOS(PD_FECDIA IN Date)
  IS
      PD_FECCIE date := last_day(add_months(PD_FECDIA,-1));
      ld_fecpro date := dwextra.pq_tmp_extrae_fuentes.fn_lee_fecha_cierre;
      ld_feimes date := to_date(to_char(PD_FECDIA,'rrrrmm')||'01','rrrrmmdd');
      ld_feiman date := to_date(to_char(PD_FECCIE,'rrrrmm')||'01','rrrrmmdd');
      ln_tiemes number := dwhouse.pq_carga_facts.fn_tiempo_key(ld_feimes);
    
      ln_tiecie number(10) := DWHOUSE.PQ_CARGA_FACTS.fn_tiempo_key(PD_FECCIE);
      ln_tiedia number(10) := DWHOUSE.PQ_CARGA_FACTS.fn_tiempo_key(PD_FECDIA);
      ln_period number(6)  := to_number(to_char(PD_FECDIA,'rrrrmm'));
      ln_peract number(6)  := to_number(to_char(ld_fecpro,'rrrrmm'));
      lv_fecdat varchar2(10);
      
      lv_ruccaja varchar2(11) := '20100209641';
      ln_empcaja number(10);
      lv_script varchar2(1000);
     
      TYPE tp_codase IS TABLE OF VARCHAR2(10);
      TYPE tp_client IS TABLE OF NUMBER(10);
      TYPE tp_codana IS TABLE OF VARCHAR2(10);
      TYPE tp_keyana IS TABLE OF NUMBER(10);
      TYPE tp_nroana IS TABLE OF NUMBER(5);
    
      lv_codase tp_codase;
      ln_client tp_client;
      lv_codana tp_codana;
      ln_keyana tp_keyana;
      ln_nroana tp_nroana;
      ln_ctakey number(10);
  
      Cursor c_gob(fini in date, ffin in date)
          is Select aqpa118amod aomod,aqpa118amda aomda,aqpa118acta aocta,
                    aqpa118aope aoope,aqpa118asbo aosbo,aqpa118atop aotop,
                    sum(MTO_TRANSF) mto_tranf
              From (
                     Select x.aqpa118apgc,
                            x.aqpa118amod,
                            x.aqpa118asuc,
                            x.aqpa118amda,
                            x.aqpa118apap,
                            x.aqpa118acta,
                            x.aqpa118aope,
                            x.aqpa118asbo,
                            x.aqpa118atop,
                            w.fch_reg ,
                            w.MTO_TRANSF,
                            w.hora_Reg,'A' tippro
                      from (Select max(x.aqpa118aseq),
                                   x.aqpa118apgc,x.aqpa118amod,
                                   x.aqpa118asuc,x.aqpa118amda,
                                   x.aqpa118apap,x.aqpa118acta,
                                   x.aqpa118aope,x.aqpa118asbo,
                                   x.aqpa118atop,x.aqpa118acci
                        from aqpa118a@produ x
                       where x.aqpa118acta > 0
                      group by x.aqpa118apgc,x.aqpa118amod,
                               x.aqpa118asuc,x.aqpa118amda,
                               x.aqpa118apap,x.aqpa118acta,
                               x.aqpa118aope,x.aqpa118asbo,
                               x.aqpa118atop,x.aqpa118acci
                       ) x,
                       jaql380@produ w
                 where w.cci_des = x.aqpa118acci
                   and w.cod_esttra = 5
                   and (w.nom_ori like '%AFP%' or w.nom_ori like '%HA%-%FONDO%' or
                        w.nom_ori like '%IN%-%FONDO%' or w.nom_ori like '%PR%-%FONDO%' or
                        w.nom_ori like 'RI')
                        
                        UNION    
               Select z.jaql72pgco,  
                      z.jaql72scmo,
                      z.jaql72scsu,              
                      z.jaql72scmd,
                      z.jaql72scpa,
                      z.jaql72scct,
                      z.jaql72scop,
                      z.jaql72scsb,
                      z.jaql72scto,
                      y.jaql71fepr,
                      z.jaql72impo,
                      y.jaql71hopr,
                      'B' tippro
                 from jaql071@produ y,
                      jaql072@produ z,
                      aqpa124@produ w 
                where y.jaql71nuim = z.jaql72nuim
                  and z.jaql72nuim = w.aqpa124imp
                  and z.jaql72ax02 = 1
                  and z.jaql72impo > 0
                  and y.jaql71esta = 'P'
                )  
           Where fch_reg between fini and ffin   
           Group By aqpa118amod,aqpa118amda,aqpa118acta,aqpa118aope,aqpa118asbo,aqpa118atop;
 
  BEGIN
        Execute Immediate 'Truncate table TMP_EXT_JAQL061';
        lv_script := 'Insert Into TMP_EXT_JAQL061('||
                   'jaql61pgco, jaql61pais, jaql61tdoc, jaql61ndoc,'|| 
                   'jaql61user, jaql61fech, jaql61au01, jaql61au02,'|| 
                   'jaql61au03, jaql61au04, jaql61au05, jaql61au06,'|| 
                   'jaql61au07, jaql61au08, jaql61esta) '||
                   'Select jaql61pgco, jaql61pais, jaql61tdoc, jaql61ndoc,'|| 
                   'jaql61user, jaql61fech, jaql61au01, jaql61au02,'|| 
                   'jaql61au03, jaql61au04, jaql61au05, jaql61au06,'|| 
                   'jaql61au07, jaql61au08, jaql61esta ';
                                    
       If ln_peract > ln_period Then
          lv_fecdat := to_char(last_day(add_months(ld_fecpro,-1)),'rrrrmmdd');
          lv_script := lv_script ||'From dwbkext.JAQL061_'||lv_fecdat;
       Else
          lv_script := lv_script ||'From dwextra.JAQL061';
       End If; 
       lv_script := lv_script ||' Where jaql61esta = ''S'' and (trim(jaql61user) is not null or trim(jaql61user) <> ''SIN ASESOR'')';
       
       Execute Immediate lv_script;
       Commit;
       
       Execute Immediate 'Truncate table TMP_FACT_PASIVO_INCSALD';
       Execute Immediate 'Truncate table TMP_FACT_PASIVO_PRODINC';
        
       -- INSERTA SALDO CIERRE DE MES Y AVANCE
       Insert Into TMP_FACT_PASIVO_INCSALD(TIEMPO_KEY,CLIENTE_KEY,PRODUCTO_KEY,GEOGRAFIA_KEY,CUENTA_KEY,EMPLEADOR_KEY,
                                            SALDO_BASE_MN,TIEMPO_SLD_KEY,SALDO_AVAN_MN,FEC_PROCESO,ind_finmes,IND_TIPINC,
                                            Regionop_Key,Ind_Anainc,imp_bonafp_mant,imp_desemb_mant,FEC_SALDO,cod_producto,
                                            Aocta)
        Select ln_tiemes,sb.cliente_key,sb.producto_key,sb.geografia_key,sb.cuentas_key,sb.empleador_key,
               sb.saldo_mn,sa.tiempo_key,nvl(sa.saldo_mn,0),ld_fecpro,'S',1,
               dwstage.pq_tmp_carga_transacc.fn_key_region_op(to_number(ge.Codigo_Agencia),PD_FECCIE),0,0,0,PD_FECDIA,
               pr.codigo_producto,ct.cuenta
        From DWHOUSE.fact_pasivo sb
        Join DWHOUSE.Dm_Geografia ge on ge.geografia_key = sb.geografia_key
        Join dwhouse.dm_producto pr on pr.producto_key = sb.producto_key
        Join dwhouse.dm_cuentas ct on ct.cuentas_key = sb.cuentas_key
        Left Join (select ma.tiempo_key,ma.cuentas_key,ma.saldo_mn
                  From DWHOUSE.fact_pasivo ma 
                 Where ma.estado_key <> 72
                   and ma.tiempo_key = ln_tiedia
                ) sa on sa.cuentas_key = sb.cuentas_key 
        Where sb.tiempo_key = ln_tiecie
          and sb.estado_key <> 72
          --and ge.codigo_agencia not in ('78','904');
          and ge.tipo_Region = 'R';
        COMMIT;
     
        -- Inserta SALDO AVANCE QUE NO EXISTEN EN CIERRE DE MES
        Insert Into TMP_FACT_PASIVO_INCSALD(TIEMPO_KEY,CLIENTE_KEY,PRODUCTO_KEY,GEOGRAFIA_KEY,CUENTA_KEY,EMPLEADOR_KEY,
                                            SALDO_BASE_MN,TIEMPO_SLD_KEY,SALDO_AVAN_MN,FEC_PROCESO,ind_finmes,IND_TIPINC,
                                            Regionop_Key,Ind_Anainc,imp_bonafp_mant,imp_desemb_mant,FEC_SALDO,cod_producto,
                                            Aocta)
        Select ln_tiemes,ma.cliente_key,ma.producto_key,ma.geografia_key,ma.cuentas_key,ma.empleador_key,
               0,ma.tiempo_key,ma.saldo_mn,ld_fecpro,'N',1,
               dwstage.pq_tmp_carga_transacc.fn_key_region_op(to_number(ge.Codigo_Agencia),PD_FECDIA),0,0,0,PD_FECDIA,
               pr.codigo_producto,ct.cuenta
          From DWHOUSE.fact_pasivo ma
          Join dwhouse.dm_geografia ge on ge.geografia_key = ma.geografia_key
          Join dwhouse.dm_producto pr on pr.producto_key = ma.producto_key
          Join dwhouse.dm_cuentas ct on ct.cuentas_key = ma.cuentas_key
         Where ma.tiempo_key = ln_tiedia
           and ma.estado_key <> 72
           --and ge.codigo_agencia not in ('78','904')
           and ge.tipo_region = 'R'
           and not exists (select 1 from DWHOUSE.fact_pasivo sb 
                            Where sb.cuentas_key = ma.cuentas_key
                              and sb.estado_key <> 72
                              and sb.tiempo_key = ln_tiecie
                          )
           and exists (select 1 from DWHOUSE.fact_pasivo ag 
                        Where ag.geografia_key = ma.geografia_key
                          and ag.estado_key <> 72  
                          and ag.tiempo_key = ln_tiecie
                       );
         COMMIT;
         
  END SP_INC_SALDOS; 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- -- --
----------------------------------------- 
  --- PROCESO: clasifica depositos
  -----------------------------------------
  PROCEDURE SP_INC_CLASIFICA_DEP(PD_FECDIA In Date)
  IS
      PD_FECCIE date := last_day(add_months(PD_FECDIA,-1));
      ld_fecpro date := PD_FECDIA;--dwextra.pq_tmp_extrae_fuentes.fn_lee_fecha_cierre;
      ld_feimes date := to_date(to_char(PD_FECDIA,'rrrrmm')||'01','rrrrmmdd');
      ld_feiman date := to_date(to_char(PD_FECCIE,'rrrrmm')||'01','rrrrmmdd');
      ln_tiemes number := dwhouse.pq_carga_facts.fn_tiempo_key(ld_feimes);
    
      ln_tiecie number(10) := DWHOUSE.PQ_CARGA_FACTS.fn_tiempo_key(PD_FECCIE);
      ln_tiedia number(10) := DWHOUSE.PQ_CARGA_FACTS.fn_tiempo_key(PD_FECDIA);
      ln_period number(6)  := to_number(to_char(PD_FECDIA,'rrrrmm'));
      ln_peract number(6)  := to_number(to_char(ld_fecpro,'rrrrmm'));
      lv_fecdat varchar2(10);
      
      lv_ruccaja varchar2(11) := '20100209641';
      ln_empcaja number(10);
      lv_script varchar2(1000);
     
      TYPE tp_codase IS TABLE OF VARCHAR2(10);
      TYPE tp_client IS TABLE OF NUMBER(10);
      TYPE tp_codana IS TABLE OF VARCHAR2(10);
      TYPE tp_keyana IS TABLE OF NUMBER(10);
      TYPE tp_nroana IS TABLE OF NUMBER(5);
    
      lv_codase tp_codase;
      ln_client tp_client;
      lv_codana tp_codana;
      ln_keyana tp_keyana;
      ln_nroana tp_nroana;
      ln_ctakey number(10);
  
      Cursor c_gob(fini in date, ffin in date)
          is Select aqpa118amod aomod,aqpa118amda aomda,aqpa118acta aocta,
                    aqpa118aope aoope,aqpa118asbo aosbo,aqpa118atop aotop,
                    sum(MTO_TRANSF) mto_tranf
              From (
                     Select x.aqpa118apgc,
                            x.aqpa118amod,
                            x.aqpa118asuc,
                            x.aqpa118amda,
                            x.aqpa118apap,
                            x.aqpa118acta,
                            x.aqpa118aope,
                            x.aqpa118asbo,
                            x.aqpa118atop,
                            w.fch_reg ,
                            w.MTO_TRANSF,
                            w.hora_Reg,'A' tippro
                      from (Select max(x.aqpa118aseq),
                                   x.aqpa118apgc,x.aqpa118amod,
                                   x.aqpa118asuc,x.aqpa118amda,
                                   x.aqpa118apap,x.aqpa118acta,
                                   x.aqpa118aope,x.aqpa118asbo,
                                   x.aqpa118atop,x.aqpa118acci
                        from aqpa118a@produ x
                       where x.aqpa118acta > 0
                      group by x.aqpa118apgc,x.aqpa118amod,
                               x.aqpa118asuc,x.aqpa118amda,
                               x.aqpa118apap,x.aqpa118acta,
                               x.aqpa118aope,x.aqpa118asbo,
                               x.aqpa118atop,x.aqpa118acci
                       ) x,
                       jaql380@produ w
                 where w.cci_des = x.aqpa118acci
                   and w.cod_esttra = 5
                   and (w.nom_ori like '%AFP%' or w.nom_ori like '%HA%-%FONDO%' or
                        w.nom_ori like '%IN%-%FONDO%' or w.nom_ori like '%PR%-%FONDO%' or
                        w.nom_ori like 'RI')
                        
                        UNION    
               Select z.jaql72pgco,  
                      z.jaql72scmo,
                      z.jaql72scsu,              
                      z.jaql72scmd,
                      z.jaql72scpa,
                      z.jaql72scct,
                      z.jaql72scop,
                      z.jaql72scsb,
                      z.jaql72scto,
                      y.jaql71fepr,
                      z.jaql72impo,
                      y.jaql71hopr,
                      'B' tippro
                 from jaql071@produ y,
                      jaql072@produ z,
                      aqpa124@produ w 
                where y.jaql71nuim = z.jaql72nuim
                  and z.jaql72nuim = w.aqpa124imp
                  and z.jaql72ax02 = 1
                  and z.jaql72impo > 0
                  and y.jaql71esta = 'P'
                )  
           Where fch_reg between fini and ffin   
           Group By aqpa118amod,aqpa118amda,aqpa118acta,aqpa118aope,aqpa118asbo,aqpa118atop;
       
      Cursor c_clireg 
          is select * from TMP_FACT_PASIVO_CLICAP Where ind_increg = 1;
          
          lv_pendoc varchar2(12);    
  BEGIN
       Execute Immediate 'Truncate table TMP_FACT_PASIVO_PRODINC';
       
       --- CLIENTES REGISTRADOS PARA CAPTACION
       FOR x IN c_clireg LOOP
             lv_pendoc := rpad(trim(x.ndoc),12,' ');
             BEGIN
                   INSERT INTO TMP_FACT_PASIVO_PRODINC
                      (TIEMPO_KEY,PRODUCTO_KEY,GEOGRAFIA_KEY,CUENTA_KEY,EMPLEADOR_KEY,
                       Saldo_Base_Mn,Tiempo_Sld_Key,SALDO_AVAN_MN,Fec_Proceso,Ind_Finmes,Imp_Tragob,
                       Cod_Tipage,Regionop_Key,fec_saldo,cod_producto,Aocta,fec_aperen,ind_tipape,
                       des_cliente,ind_numtit,
                       -----
                       Ind_Tipinc,Cod_Ejeaho,Cod_Anacre,analista_key,ageana_key,cod_asecre,asecre_key,
                       fec_regcli,ind_regcli,pais,tdoc,ndoc,cod_usuage,CLIENTE_KEY,COD_USUREG
                      ) 
              SElect TIEMPO_KEY,inc.PRODUCTO_KEY,GEOGRAFIA_KEY,inc.CUENTA_KEY,EMPLEADOR_KEY,
                     Saldo_Base_Mn,Tiempo_Sld_Key,SALDO_AVAN_MN,Fec_Proceso,Ind_Finmes,Imp_Tragob,
                     Cod_Tipage,Regionop_Key,fec_saldo,cod_producto,Aocta,
                     nvl(ct.fecha_renovaci,ct.fecha_apertura),
                     case when inc.ind_finmes = 'N' and inc.cod_producto = '22' and ct.fecha_apertura < ld_feimes
                          then 'REN'
                          when inc.ind_finmes = 'N' and inc.cod_producto = '22' and ct.fecha_renovaci is null
                          then 'APE'
                          when inc.ind_finmes = 'N' and inc.cod_producto <> '22' then 'APE'
                          else null
                     end,         
                     PQ_TMP_PRODUCTIVIDADASE.FN_NOMBRE_CLIENTE(x.pais,x.tdoc,trim(x.ndoc)), 
                     (select count(*) From dwextra.fsr008 where ctnro = inc.aocta) nrotit
                      -------------------
                      ,x.ind_regcli,
                      decode(x.ind_regcli,3,x.cod_usureg),
                      decode(x.ind_regcli,2,x.cod_usureg),decode(x.ind_regcli,2,x.analista_key),
                      decode(x.ind_regcli,2,x.ageana_key),
                      decode(x.ind_regcli,7,x.cod_usureg),decode(x.ind_regcli,7,x.asesor_key),
                      x.fec_regcli,1,x.pais,x.tdoc,trim(x.ndoc),
                      decode(x.ind_regcli,1,x.cod_usureg),
                      x.cliente_key,x.cod_usureg
                from TMP_FACT_PASIVO_INCSALD inc
                Join dwhouse.dm_cuentas ct on ct.cuentas_key  = inc.cuenta_key
               Where exists (select 1 from dwextra.fsr008 cl 
                             where cl.pepais = x.pais and cl.petdoc=x.tdoc and cl.pendoc = lv_pendoc
                               and cl.ctnro = inc.aocta);
               COMMIT;
             EXCEPTION WHEN OTHERS THEN
                NULL;
             END;                    
         END LOOP;
         
         ---- INSERTA TODAS LAS CUENTAS DE CLIENTES QUE NO SE REGISTRARON PARA CAPTACION
         Begin
         INSERT INTO TMP_FACT_PASIVO_PRODINC
                     (TIEMPO_KEY,CLIENTE_KEY,PRODUCTO_KEY,GEOGRAFIA_KEY,CUENTA_KEY,EMPLEADOR_KEY,
                      SALDO_BASE_MN,TIEMPO_SLD_KEY,SALDO_AVAN_MN,FEC_PROCESO,ind_finmes,IND_TIPINC,
                      Regionop_Key,Ind_Anainc,imp_bonafp_mant,imp_desemb_mant,FEC_SALDO,cod_producto,
                      Aocta,ind_regcli,ind_numtit,
                      -- nuevo
                      pais,tdoc,ndoc
                     ) 
              SELECT TIEMPO_KEY,CLIENTE_KEY,sld.PRODUCTO_KEY,GEOGRAFIA_KEY,CUENTA_KEY,EMPLEADOR_KEY,
                      SALDO_BASE_MN,TIEMPO_SLD_KEY,SALDO_AVAN_MN,FEC_PROCESO,ind_finmes,IND_TIPINC,
                      Regionop_Key,Ind_Anainc,imp_bonafp_mant,imp_desemb_mant,FEC_SALDO,cod_producto,
                      Aocta,0,
                      --1
                      --nuevo
                      (select count(*) From dwextra.fsr008 where ctnro = ct.cuenta) nrotit,
                      r8.pepais,r8.petdoc,r8.pendoc
                 FROM TMP_FACT_PASIVO_INCSALD sld
                 Join dwhouse.dm_cuentas ct on ct.cuentas_key = sld.cuenta_key
                 Join dwextra.fsr008 r8 on r8.ctnro = ct.cuenta
                Where not exists (select 1 from TMP_FACT_PASIVO_PRODINC t where CUENTA_KEY = sld.cuenta_key
                                   and  t.pais = r8.pepais and t.tdoc = r8.petdoc and trim(t.ndoc) = trim(r8.pendoc)
                                 );
                /* NUEV FROM TMP_FACT_PASIVO_INCSALD sld
               WHERE not exists (select 1 from TMP_FACT_PASIVO_PRODINC where CUENTA_KEY = sld.cuenta_key);
              */
              COMMIT;
         Exception When Others Then
            Null;
         End;  
         
         -- Obtiene codigo empleador Caja Arequipa
         Begin
            Select empleador_key Into ln_empcaja From dwhouse.dm_empleador Where ruc = lv_ruccaja;
         Exception When Others Then
            ln_empcaja := Null;
         End;
     
         -- Actualiza Registros de depositos donde el Empleador es Caja Arequipa
         Update TMP_FACT_PASIVO_PRODINC Set ind_tipinc=4 Where empleador_key = ln_empcaja;
         Commit;
         
         -- Actualiza Registros de depositos donde el cliente es colaborador de Caja Arequipa
         Update TMP_FACT_PASIVO_PRODINC z Set ind_tipinc=4 
          Where exists (select 1 from dwhouse.dm_cliente where nvl(ind_colbco,'N') = 'S'
                           and cliente_key = z.cliente_key);
         Commit;
      
         --- Identificar Clientes con Ejecutivo
         Select trim(jaql61user),cl.cliente_key
          BULK COLLECT INTO lv_codase, ln_client
          From TMP_EXT_JAQL061 e
          Join dwhouse.dm_cliente cl
            on cl.pais = e.jaql61pais
           and cl.tipo_docum = e.jaql61tdoc
           and cl.numero_documento = e.jaql61ndoc  
         Where jaql61esta = 'S' 
           and (trim(jaql61user) is not null or trim(jaql61user) <> 'SIN ASESOR');
         
         For idx in 1 .. lv_codase.COUNT Loop
             Update TMP_FACT_PASIVO_PRODINC 
                Set ind_tipinc = 3,
                    cod_ejeaho  = lv_codase(idx) 
              Where cliente_key = ln_client(idx);
             Commit;       
         End Loop;  
     
         -- Depositos del Gobierno MES EN CURSO(AFP/BONO)
         For x in c_gob(ld_feimes,PD_FECDIA) Loop
                 -- Busca Cuenta_Key
                 Begin
                      Select c.cuentas_key INTO ln_ctakey
                        from dwhouse.dm_cuentas c
                        Join dwstage.tmp_dm_cuenta k
                          on k.cuenta_unica = c.cuenta_unica
                         and k.codigo_cuenta = c.codigo_cuenta
                       Where k.aomod = x.aomod
                         and k.aomda = x.aomda
                         and k.aocta = x.aocta
                         and k.aoope = x.aoope
                         and k.aosbo = x.aosbo
                         and k.aotop = x.aotop;
                 Exception When Others Then
                    ln_ctakey := Null;
                 End;
         
                 If ln_ctakey Is Not Null Then
                    Update TMP_FACT_PASIVO_PRODINC
                       set imp_tragob = x.mto_tranf
                     Where CUENTA_KEY = ln_ctakey;
                    Commit;    
                 End If;
                  
             End Loop;
     
     
             -- Depositos del Gobierno MES EN ANTERIOR(AFP/BONO)
             /*
             For x in c_gob(ld_feiman,PD_FECCIE) Loop
                 -- Busca Cuenta_Key
                 Begin
                      Select c.cuentas_key INTO ln_ctakey
                        from dwhouse.dm_cuentas c
                        Join dwstage.tmp_dm_cuenta k
                          on k.cuenta_unica = c.cuenta_unica
                         and k.codigo_cuenta = c.codigo_cuenta
                       Where k.aomod = x.aomod
                         and k.aomda = x.aomda
                         and k.aocta = x.aocta
                         and k.aoope = x.aoope
                         and k.aosbo = x.aosbo
                         and k.aotop = x.aotop;
                 Exception When Others Then
                    ln_ctakey := Null;
                 End;
         
                 If ln_ctakey Is Not Null Then
                    Update TMP_FACT_PASIVO_PRODINC
                       set imp_bonafp_mant = nvl(x.mto_tranf,0)
                     Where CUENTA_KEY = ln_ctakey;
                    Commit;    
                 End If;
                  
             End Loop;
            */
       --- INSERTA CAPTACIONES QUE NO APERTURARON ANALISTAS
       BEGIN
            INSERT INTO TMP_FACT_PASIVO_PRODINC
                        (TIEMPO_KEY,GEOGRAFIA_KEY,Saldo_Base_Mn,Tiempo_Sld_Key,SALDO_AVAN_MN,
                         Fec_Proceso,Ind_Finmes,Imp_Tragob,fec_saldo,ind_numtit,
                         -----
                         Ind_Tipinc,Cod_Anacre,analista_key,ageana_key,cod_usureg,
                         fec_regcli,ind_regcli,pais,tdoc,ndoc,cod_usuage,CLIENTE_KEY,
                         producto_key,cuenta_key
                        )  
                        
                  Select ln_tiemes,geografia_key,0,ln_tiedia,0,trunc(sysdate),'N',0,PD_FECDIA,1,
                         ind_regcli,cod_anacre,analista_key,ageana_key,cod_usureg,
                         fec_Regcli,nvl(ind_increg,0),
                         pais,tdoc,ndoc,cod_usuage,
                         nvl(pq_tmp_carga_key.fn_cliente_key(trim(pais||tdoc||trim(ndoc))),1549761484),
                         37,1404121192
                    from TMP_FACT_PASIVO_CLICAP ca 
                   Where ind_regcli = 2
                     and not exists (select 1 from TMP_FACT_PASIVO_PRODINC where analista_key = ca.analista_key
                                      and ind_Tipinc = 2
                                      and cliente_key = ca.cliente_key); ---LINEA AGREGADA
                   Commit; 
                   
                   
       EXCEPTION WHEN OTHERS THEN
            NULL;
       END;      
       --- ASESORES: INSERTA CLIENTES QUE NO APERTURAN
        BEGIN
            INSERT INTO TMP_FACT_PASIVO_PRODINC
                        (TIEMPO_KEY,GEOGRAFIA_KEY,Saldo_Base_Mn,Tiempo_Sld_Key,SALDO_AVAN_MN,
                         Fec_Proceso,Ind_Finmes,Imp_Tragob,fec_saldo,ind_numtit,
                         -----
                         Ind_Tipinc,Cod_Anacre,analista_key,ageana_key,cod_usureg,
                         fec_regcli,ind_regcli,pais,tdoc,ndoc,cod_usuage,CLIENTE_KEY,
                         producto_key,cuenta_key,asecre_key
                        )  
                        
                  Select ln_tiemes,geografia_key,0,ln_tiedia,0,trunc(sysdate),'N',0,PD_FECDIA,1,
                         ind_regcli,cod_anacre,analista_key,ageana_key,cod_usureg,
                         fec_Regcli,nvl(ind_increg,0),
                         pais,tdoc,ndoc,cod_usuage,
                         nvl(pq_tmp_carga_key.fn_cliente_key(trim(pais||tdoc||trim(ndoc))),1549761484),
                         37,1404121192,ca.asesor_key
                    from TMP_FACT_PASIVO_CLICAP ca 
                   Where ind_regcli = 7 and ca.analista_key is null
                     and not exists (select 1 from TMP_FACT_PASIVO_PRODINC  d 
                                      where d.asecre_key = ca.asesor_key
                                      and ind_Tipinc = 7
                                      and cliente_key = ca.cliente_key
                                      ); 
                   Commit; 
       EXCEPTION WHEN OTHERS THEN
            NULL;
       END;                 
                                           
       --- Depositos con ejecutivo el mes anterior y están en agencia
       
       If ln_period = 202206 Then
          ln_tiemes := dwhouse.pq_carga_facts.fn_tiempo_key(ld_feiman);
          ld_feiman := last_day(ld_feiman);
          Update TMP_FACT_PASIVO_PRODINC p
             set p.ind_tipinc = 8       
           Where p.ind_tipinc = 1
             and exists (select 1 from dwhouse.fact_pasivo_prodinc ma
                         Where ma.cuenta_key = p.cuenta_key
                           and ma.ind_tipinc = 3
                           and ma.tiempo_key = ln_tiemes
                           and ma.fec_saldo = ld_feiman
                         );
                       
           Commit;                     
       End If;   
  END;  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- -- --  
PROCEDURE SP_INC_RESULTADOS(PD_FECHA In Date)
    --- Creación:
    --- Fecha: 2022.07.26
    --- Motivo: Usuario requiere cambiar el datos de saldo base sin descuentos
  IS  
     Cursor c_tipage
       is Select distinct cod_tipage From tmp_fact_pasivo_prodinc_res 
           Where cod_tipage Is not null and ind_tipmet = 1;
       
     Cursor c_logtod(lv_tipage in Varchar2)
         is Select * From tmp_fact_pasivo_prodinc_res 
             Where cod_tipage = lv_tipage and ind_tipmet = 1 and IND_LogTod=1
             Order By (Por_LogAHO+Por_LogDPF) desc;  

     Cursor c_analista
       is Select distinct des_tipana From tmp_fact_pasivo_prodinc_res 
           Where des_tipana Is not null and ind_tipmet = 2;
       
   Cursor c_logtod_an(lv_tipa in varchar2)
       is Select * From tmp_fact_pasivo_prodinc_res 
          Where des_tipana = lv_tipa and ind_tipmet = 2 and IND_LogTod=1
          Order By (Por_LogAHO+Por_LogDPF) desc;  
          
   Cursor c_logacu_an(lv_tipa in varchar2)
       is Select * From tmp_fact_pasivo_prodinc_res 
          Where des_tipana = lv_tipa 
            and ind_tipmet = 2 
            and IND_LogTod=0
          Order By Por_LogACUM desc;    
   
     
     Cursor c_pagoana(ln_tot in Number)
         is  Select * From (
             select analista_key,des_tipana,to_number(to_char(fec_saldo,'rrrrmm')) periodo
               from tmp_fact_pasivo_prodinc_res 
              where ind_tipmet = 2 
                and des_tipana  in ('MASTER','SENIOR','SENIOR EXPERTO')
                and (Por_LogAho + Por_LogDPF) > 0
               Order by ind_logtod desc,(Por_LogAho + Por_LogDPF) desc
              ) Where Rownum <= ln_tot;
     
     Cursor c_pagoana2(ln_tot in Number)
         is  Select * From (
             select analista_key,des_tipana,to_number(to_char(fec_saldo,'rrrrmm')) periodo 
               from tmp_fact_pasivo_prodinc_res 
              where ind_tipmet = 2 
                and des_tipana not in ('MASTER','SENIOR','SENIOR EXPERTO')
                and (Por_LogAho + Por_LogDPF) > 0
               Order by ind_logtod desc,(Por_LogAho + Por_LogDPF) desc
              ) Where Rownum <= ln_tot;
                          
      Cursor c_resana 
            is Select tiempo_key,analista_key,geografia_key,des_tipana,fec_saldo,ind_tipmet,
                      sum(nvl(AHO_C,0)) ahoava,sum(nvl(DPF_C,0)) dpfava
                      from
                      (
               Select dat.*,
                      case when imp_capclit <= 0 Then 0
                           when imp_capclit > 0 and  aho <= 0 then 0  
                           when imp_capclit > 0 and  aho > 0 and dpf <= 0 then imp_capclit 
                           else aho 
                       end AHO_C, 
                      case when imp_capclit <= 0 Then 0
                           when imp_capclit > 0 and  dpf <= 0 then 0  
                           when imp_capclit > 0 and  aho <= 0 and dpf > 0 then imp_capclit 
                           else dpf
                       end DPF_C       
                 From (
               select tiempo_key,analista_key,geografia_key,des_tipana,fec_saldo,
                      cliente_key,imp_capclit,ind_tipmet,
                      sum(case when codigo_producto = '21' then imp_sdoavan - imp_sdobase else 0 end) AHO,
                      sum(case when codigo_producto = '22' then imp_sdoavan - imp_sdobase else 0 end) DPF
                from dwstage.TMP_FACT_PASIVO_PRODINC_METAS where ind_tipmet in (2,7)
               group by tiempo_key,analista_key,geografia_key,des_tipana,fec_saldo,cliente_key,ind_tipmet,imp_capclit
                ) dat)
               group by tiempo_key,analista_key,geografia_key,des_tipana,fec_saldo,ind_tipmet;
                  
               
     --- nuevo: saldo avance y base otros
     Cursor c_otros
         is Select i.cod_producto,i.geografia_key,sum(i.saldo_base_mn/i.ind_numtit) sbase,
                    sum(case when (nvl(i.imp_tragob,0) + nvl(i.imp_desemb,0))>nvl(i.saldo_avan_mn,0) then 0 
                             else (nvl(i.saldo_avan_mn,0) - (nvl(i.imp_tragob,0) + nvl(i.imp_desemb,0)))/nvl(i.ind_numtit,1)
                       end) savance,
                    to_number(g.codigo_agencia) codage   
              from dwstage.TMP_FACT_PASIVO_PRODINC i
              Join dwhouse.dm_geografia g on g.geografia_key = i.geografia_key
              Where g.tipo_region ='R'
                and i.ind_tipinc <>  1
                and i.cod_producto is not null
                group by i.cod_producto,i.geografia_key,to_number(g.codigo_agencia);
     ----------
     ln_rnkage Number(5) := 0;  
     ln_pesaho number(7,3) := 0.6; -- Peso ahorros
     ln_pespfc number(7,3) := 0.4; -- Peso DPF + CTS
     ln_agetip number(2) := 1;   -- Cantidad de agencias por tipo
     ln_cntage number(3) := 0;
     ln_anagr1 number(3) := 10;  -- Cantidad de analistas G1 
     ln_anagr2 number(3) := 15;  -- Cantidad de analistas G2
     lv_tippag varchar2(20);
     lv_motrnk varchar2(20);
     ln_pagmes number(5);
     ln_period number(6) := to_number(to_char(PD_FECHA,'rrrrmm'));
     
     ld_FecTri date;
     ln_indmet number(2);
     ln_sdobas number(20,4);
  BEGIN
       -- INSERTA SALDO META DE AGENCIAS
       PQ_TMP_PRODUCTIVIDADASE.SP_INC_INSSDOMET_AGE(PD_FECHA);   
  
       Execute Immediate 'Truncate table tmp_fact_pasivo_prodinc_metas';
       Insert Into tmp_fact_pasivo_prodinc_metas
                   (tiempo_key,codigo_producto,geografia_key,regionop_key,imp_meta,
                    cod_tipage,ind_tipmet,analista_key,des_tipana,fec_saldo,imp_sdobase,
                    imp_sdoavan,imp_sdometat,imp_sdometa,IMP_SDOBASO
                   )
       -- AGENCIAS: Metas de Ahorros 
       Select TIEMPO_KEY,codpro,GEOGRAFIA_KEY,REGIONOP_KEY,imp_meta,
              cod_tipage,ind_tipmet,anakey,desana,fec_saldo,nvl(imp_base,0),
              nvl(imp_avance,0),
              case when nvl(imp_meta,0) <> 0 Then nvl(imp_meta,0)+nvl(imp_sdomet,0) else 0 end,
              case when nvl(imp_meta,0) <> 0 Then nvl(imp_meta,0)+nvl(imp_sdomet,0) else 0 end,
              --0,
              0
         from (
       SELECT TIEMPO_KEY,'21' codpro,p.GEOGRAFIA_KEY,REGIONOP_KEY,
              max(nvl(P.IMP_META_AHO,0)) imp_meta,
              p.cod_tipage,1 ind_tipmet,
              0 anakey,'NO CLASIFICADO' desana,p.fec_saldo,
              --sum(nvl(p.saldo_base_mn,0)/nvl(p.ind_numtit,1)) imp_base, -- Saldo sin descuentos    
              sum(case when p.cod_producto='21' Then
                       case when (nvl(p.imp_bonafp_mant,0) + nvl(p.imp_desemb_mant,0))>nvl(p.saldo_base_mn,0) 
                            then 0 
                            else (nvl(p.saldo_base_mn,0) - (nvl(p.imp_bonafp_mant,0) + nvl(p.imp_desemb_mant,0)))/nvl(p.ind_numtit,1)
                       end
                  else 0     
                  end) imp_base,
                  
              sum(case when p.cod_producto='21' Then
                       case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_avan_mn,0) 
                            then 0 
                            else (nvl(p.saldo_avan_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/nvl(p.ind_numtit,1)
                       end
                  else 0     
                  end) imp_avance,
              nvl(max(x.tp1imp1),0)imp_sdomet     
         FROM dwstage.TMP_FACT_PASIVO_PRODINC P
         JOIN dwhouse.dm_geografia G ON G.Geografia_Key = P.Geografia_Key
         Left Join DWEXTRA.fst198 x on x.tp1corr2 = to_number(g.Codigo_Agencia) and x.tp1cod1=10819 and x.tp1corr1=304
                   and x.tp1corr3 = ln_period
        Where p.ind_tipinc = 1 
          and g.tipo_region = 'R'
          and p.cod_producto = '21'
        Group By TIEMPO_KEY,p.GEOGRAFIA_KEY,REGIONOP_KEY,p.cod_tipage,p.fec_saldo
                 UNION ALL
       --AGENCIA: Metas DPF
       SELECT TIEMPO_KEY,'22',p.GEOGRAFIA_KEY,REGIONOP_KEY,
              max(nvl(P.IMP_META_DPF,0)),
              p.cod_tipage,1 ind_tipmet,
              0,'NO CLASIFICADO',p.fec_saldo,
              --sum(nvl(p.saldo_base_mn,0)/nvl(p.ind_numtit,1)), 
               sum(case when p.cod_producto='22' Then
                       case when (nvl(p.imp_bonafp_mant,0) + nvl(p.imp_desemb_mant,0))>nvl(p.saldo_base_mn,0) 
                            then 0 
                            else (nvl(p.saldo_base_mn,0) - (nvl(p.imp_bonafp_mant,0) + nvl(p.imp_desemb_mant,0)))/nvl(p.ind_numtit,1)
                       end
                  else 0     
                  end) imp_base,
                      
              sum(case when p.cod_producto='22' Then
                      case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_avan_mn,0) 
                           then 0 
                           else (nvl(p.saldo_avan_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/nvl(p.ind_numtit,1)
                      end
                  Else 0     
                  End),
              nvl(max(x.tp1imp2),0)imp_sdomet     
         FROM dwstage.TMP_FACT_PASIVO_PRODINC P
         JOIN dwhouse.dm_geografia G ON G.Geografia_Key = P.Geografia_Key
         Left Join DWEXTRA.fst198 x on x.tp1corr2 = to_number(g.Codigo_Agencia) and x.tp1cod1=10819 and x.tp1corr1=304
                   and x.tp1corr3 = ln_period
        Where p.ind_tipinc = 1 
          and g.tipo_region = 'R'
          and p.cod_producto = '22'
        Group By TIEMPO_KEY,p.GEOGRAFIA_KEY,REGIONOP_KEY,p.cod_tipage,p.fec_saldo
                 UNION ALL
       --AGENCIAS: Metas CTS
       SELECT TIEMPO_KEY,'211',p.GEOGRAFIA_KEY,REGIONOP_KEY,
              max(nvl(P.IMP_META_CTS,0)),
              p.cod_tipage,1 ind_tipmet,
              0,'NO CLASIFICADO',p.fec_saldo,
              --sum(nvl(p.saldo_base_mn,0)/nvl(p.ind_numtit,1)), ---Saldo sin descuentos    
               sum(case when p.cod_producto='211' Then
                       case when (nvl(p.imp_bonafp_mant,0) + nvl(p.imp_desemb_mant,0))>nvl(p.saldo_base_mn,0) 
                            then 0 
                            else (nvl(p.saldo_base_mn,0) - (nvl(p.imp_bonafp_mant,0) + nvl(p.imp_desemb_mant,0)))/nvl(p.ind_numtit,1)
                       end
                  else 0     
                  end) imp_base,
                  
              sum(case when p.cod_producto='211' Then
                      case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_avan_mn,0) 
                           then 0 
                           else (nvl(p.saldo_avan_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/nvl(p.ind_numtit,1)
                      end
                      Else 0     
                      end),
              nvl(max(x.tp1imp3),0)imp_sdomet        
         FROM dwstage.TMP_FACT_PASIVO_PRODINC P
         JOIN dwhouse.dm_geografia G ON G.Geografia_Key = P.Geografia_Key
         Left Join DWEXTRA.fst198 x on x.tp1corr2 = to_number(g.Codigo_Agencia) and x.tp1cod1=10819 and x.tp1corr1=304
                   and x.tp1corr3 = ln_period
        Where p.ind_tipinc = 1 
          and g.tipo_region = 'R'
          and p.cod_producto = '211'
        Group By TIEMPO_KEY,p.GEOGRAFIA_KEY,REGIONOP_KEY,p.cod_tipage,p.fec_saldo
        );
       COMMIT;
       
       ---- Nuevo: actualiza otros en agencias
       -- Obtiene mes Inicial Trimestre
       dwstage.PQ_TMP_PRODUCTIVIDADASE.SP_INC_SALDOMETA_AGEN(PD_FECHA =>  PD_FECHA,
                                                             PD_FECMET => ld_FecTri,
                                                             PN_INDMET => ln_indmet);
                                                        
       For x In c_otros loop
           ln_sdobas := nvl(x.sbase,0);
           If ln_indmet = 0 Then
              select to_date(to_char(add_months(to_date(to_char(f.tp1nro1),'rrrrmmdd'),1),'rrrrmm')||'01','rrrrmmdd') 
                Into ld_FecTri
                from dwextra.fst198  f
               where tp1cod1=10819 and tp1corr1=304
                 and tp1corr2 = x.codage
                 and tp1corr3 = ln_period;
              If  to_char(ld_FecTri,'rrrrmm') <>  to_char(PD_FECHA,'rrrrmm') Then  
              dbms_output.put_line('Agencia:'|| x.codage);
              select nvl(sum(f.imp_sdobaso),0) Into ln_sdobas
                from dwhouse.fact_pasivo_prodinc_meta f 
                where ind_tipmet = 1 and geografia_key = x.geografia_key 
                and f.codigo_producto = x.cod_producto
                and tiempo_key = (select tiempo_key 
                                    from dwhouse.dm_tiempo 
                                   where fecha = ld_FecTri);
               End If;                                               
           End If;
           
           Update tmp_fact_pasivo_prodinc_metas p
              set IMP_SDOBASO = ln_sdobas, 
                  IMP_SDOAVAO =  nvl(x.savance,0),                        
                  imp_SDOMETA = (case when nvl(imp_sdometat,0) <> 0 then nvl(imp_sdometat,0)- nvl(ln_sdobas,0) else 0 end)
            Where p.codigo_producto = x.cod_producto
              and p.geografia_key = x.geografia_key 
              and p.ind_tipmet = 1;
              commit;    
       End Loop;
       ----------
  --select * from tmp_fact_pasivo_prodinc_metas where ind_Tipmet = 2 and analista_key = 11083502
  --select * from dwhouse.dm_analista where codigo_analista like 'JMOSCO%'
       ----
       -- ANALISTAS
       ----
       Insert Into tmp_fact_pasivo_prodinc_metas
                   (TIEMPO_KEY,CODIGO_PRODUCTO,GEOGRAFIA_KEY,REGIONOP_KEY,/*IMP_META,*/
                    IND_TIPMET,ANALISTA_KEY,DES_TIPANA,FEC_SALDO,cliente_key,imp_sdobase,imp_sdoavan,IMP_CAPCLIT)  
              
               Select dat.*,
                      sum(dat.avance-dat.base) over(partition by analista_key,cliente_key) poscli
                  from(      
              Select p.tiempo_key,p.cod_producto,
                     (case when p.ind_tipinc = 7 then p.geografia_key else p.ageana_key end) ageana_key,
                     p.regionop_key,
                     p.ind_tipinc,
                     (case when p.ind_tipinc = 2 then p.analista_key else p.asecre_key end) analista_key,
                     NVL(p.des_tipana,'NO CLASIFICADO'),
                     fec_saldo,p.cliente_key,
                     sum(nvl(p.saldo_base_mn,0)/nvl(p.ind_numtit,1)) base,  --sin descuentos   
                     sum(case when p.cod_producto='21' Then
                              case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_avan_mn,0) 
                                   then 0 
                                   else (nvl(p.saldo_avan_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/nvl(p.ind_numtit,1)
                              end
                              when p.cod_producto='22' Then
                              case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_avan_mn,0) 
                                   then 0 
                                   else (nvl(p.saldo_avan_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/nvl(p.ind_numtit,1)
                              end
                              when p.cod_producto='211' Then
                              case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_avan_mn,0) 
                              then 0 
                              else (nvl(p.saldo_avan_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/nvl(p.ind_numtit,1)
                              end
                      Else 0     
                      end) avance
                FROM dwstage.TMP_FACT_PASIVO_PRODINC P
                JOIN dwhouse.dm_geografia G ON G.Geografia_Key = P.Geografia_Key
               Where p.ind_tipinc in (2,7)  --Analistas y Asesores
                 and g.tipo_region = 'R'
               Group by p.tiempo_key,p.cod_producto,p.ageana_key,p.regionop_key,p.ind_tipinc,
                        p.analista_key,NVL(p.des_tipana,'NO CLASIFICADO'),fec_saldo,p.cliente_key,
                        (case when p.ind_tipinc = 7 then p.geografia_key else p.ageana_key end),
                        (case when p.ind_tipinc = 2 then p.analista_key else p.asecre_key end)  
                        )dat;  
                       
            COMMIT;
   
           ------------------------
           -- AGENCIAS: RESULTADOS
           ------------------------
           EXECUTE IMMEDIATE 'TRUNCATE TABLE tmp_fact_pasivo_prodinc_res';
           
           INSERT INTO tmp_fact_pasivo_prodinc_res
                       (tiempo_key,geografia_key,regionop_key,cod_tipage,ind_tipmet,analista_key,
                        des_tipana,fec_saldo,imp_metcts,imp_metaho,imp_metdpf,
                        imp_bascts,imp_basaho,imp_basdpf,imp_avacts,imp_avaaho,imp_avadpf,
                        imp_logcts,imp_logaho,imp_logdpf,por_logcts,por_logaho,por_logdpf,
                        imp_sdometcts,imp_sdometaho,imp_sdometdpf
                       ) 
                SELECT m.tiempo_key,m.geografia_key,m.regionop_key,m.cod_tipage,m.ind_tipmet,
                       m.analista_key,m.des_tipana,m.fec_saldo,
                       sum(Case when m.codigo_producto = 211 Then nvl(m.imp_meta,0) End) IMP_MetCTS, 
                       sum(Case when m.codigo_producto = 21 Then nvl(m.imp_meta,0) End) IMP_MetAHO, 
                       sum(Case when m.codigo_producto = 22 Then nvl(m.imp_meta,0) End) IMP_MetDPF, 
                   
                   
                       sum(Case when m.codigo_producto = 211 Then nvl(m.imp_sdobase,0) End) IMP_BasCTS, 
                       sum(Case when m.codigo_producto = 21 Then nvl(m.imp_sdobase,0) End) IMP_BasAHO, 
                       sum(Case when m.codigo_producto = 22 Then nvl(m.imp_sdobase,0) End) IMP_BasDPF, 
                   
                       sum(Case when m.codigo_producto = 211 Then nvl(m.imp_sdoavan,0) End) IMP_AvaCTS, 
                       sum(Case when m.codigo_producto = 21 Then nvl(m.imp_sdoavan,0) End) IMP_AvaAHO, 
                       sum(Case when m.codigo_producto = 22 Then nvl(m.imp_sdoavan,0) End) IMP_AvaDPF, 
                   
                       sum(Case when m.codigo_producto = 211 Then nvl(m.imp_sdoavan,0)- (nvl(m.imp_sdobase,0)) End) IMP_LogCTS, 
                       sum(Case when m.codigo_producto = 21 Then nvl(m.imp_sdoavan,0) - nvl(m.imp_sdobase,0) End) IMP_LogAHO,
                       sum(Case when m.codigo_producto = 22 Then nvl(m.imp_sdoavan,0) - nvl(m.imp_sdobase,0) End) IMP_LogDPF,
                      
                       /*sum(Case when m.codigo_producto = 211 Then (nvl(m.imp_sdoavan,0) + nvl(m.imp_sdoavao,0)) - (nvl(m.imp_sdobase,0)) End) IMP_LogCTS, 
                       sum(Case when m.codigo_producto = 21 Then (nvl(m.imp_sdoavan,0)+ nvl(m.imp_sdoavao,0)) - nvl(m.imp_sdobase,0) End) IMP_LogAHO,
                       sum(Case when m.codigo_producto = 22 Then (nvl(m.imp_sdoavan,0)+ nvl(m.imp_sdoavao,0)) - nvl(m.imp_sdobase,0) End) IMP_LogDPF,
                       */
                       sum(Case when m.codigo_producto = 211 and nvl(m.imp_meta,0) = 0 Then 0
                                When m.codigo_producto = 211 and nvl(m.imp_meta,0) <> 0 and
                                     nvl(m.imp_sdometa,0) <> 0 
                                Then nvl(m.imp_sdoavan,0)/nvl(m.imp_sdometa,0)  
                                When m.codigo_producto = 211 and nvl(m.imp_meta,0) <> 0 and
                                     nvl(m.imp_sdometa,0) = 0
                                Then nvl(m.imp_sdoavan,0)/(nvl(m.imp_sdobase,0) + nvl(m.imp_meta,0))       
                           End) POR_LogCTS,  
                       /*    
                       sum(Case when m.codigo_producto = 211 and nvl(m.imp_meta,0) = 0 Then 0
                                When m.codigo_producto = 211 and nvl(m.imp_meta,0) <> 0 and
                                     nvl(m.imp_sdometa,0) <> 0 
                                Then (nvl(m.imp_sdoavan,0) + nvl(m.imp_sdoavao,0)) /nvl(m.imp_sdometa,0)  
                                When m.codigo_producto = 211 and nvl(m.imp_meta,0) <> 0 and
                                     nvl(m.imp_sdometa,0) = 0
                                Then (nvl(m.imp_sdoavan,0)+ nvl(m.imp_sdoavao,0))/(nvl(m.imp_sdobase,0) + nvl(m.imp_meta,0))       
                           End) POR_LogCTS,
                       */       
                       sum(Case when m.codigo_producto = 21 and nvl(m.imp_meta,0)=0 Then 0
                                When m.codigo_producto = 21 and nvl(m.imp_meta,0)<> 0 and 
                                     nvl(m.imp_sdometa,0) <> 0 
                                Then nvl(m.imp_sdoavan,0)/nvl(m.imp_sdometa,0)  
                                When m.codigo_producto = 21 and nvl(m.imp_meta,0)<> 0 and 
                                     nvl(m.imp_sdometa,0) = 0      
                                Then nvl(m.imp_sdoavan,0)/(nvl(m.imp_sdobase,0) + nvl(m.imp_meta,0)) 
                           End) POR_LogAHO,    
                         /*  sum(Case when m.codigo_producto = 21 and nvl(m.imp_meta,0)=0 Then 0
                                When m.codigo_producto = 21 and nvl(m.imp_meta,0)<> 0 and 
                                     nvl(m.imp_sdometa,0) <> 0 
                                Then (nvl(m.imp_sdoavan,0)+nvl(m.imp_sdoavao,0))/nvl(m.imp_sdometa,0)  
                                When m.codigo_producto = 21 and nvl(m.imp_meta,0)<> 0 and 
                                     nvl(m.imp_sdometa,0) = 0      
                                Then (nvl(m.imp_sdoavan,0) + nvl(m.imp_sdoavao,0))/(nvl(m.imp_sdobase,0) + nvl(m.imp_meta,0)) 
                           End) POR_LogAHO,
                       */
                       sum(Case when m.codigo_producto = 22 and nvl(m.imp_meta,0)=0 Then 0
                                When m.codigo_producto = 22 and nvl(m.imp_meta,0)<> 0 and 
                                     nvl(m.imp_sdometa,0) <> 0 
                                Then nvl(m.imp_sdoavan,0)/nvl(m.imp_sdometa,0)  
                                When m.codigo_producto = 22 and nvl(m.imp_meta,0)<> 0 and 
                                     nvl(m.imp_sdometa,0) = 0      
                                Then nvl(m.imp_sdoavan,0)/(nvl(m.imp_sdobase,0) + nvl(m.imp_meta,0)) 
                           End) POR_LogDPF, 
                         /*  sum(Case when m.codigo_producto = 22 and nvl(m.imp_meta,0)=0 Then 0
                                When m.codigo_producto = 22 and nvl(m.imp_meta,0)<> 0 and 
                                     nvl(m.imp_sdometa,0) <> 0 
                                Then (nvl(m.imp_sdoavan,0)+nvl(m.imp_sdoavao,0))/nvl(m.imp_sdometa,0)  
                                When m.codigo_producto = 22 and nvl(m.imp_meta,0)<> 0 and 
                                     nvl(m.imp_sdometa,0) = 0      
                                Then (nvl(m.imp_sdoavan,0)+nvl(m.imp_sdoavao,0))/(nvl(m.imp_sdobase,0) + nvl(m.imp_meta,0)) 
                           End) POR_LogDPF,   
                        */     
                       sum(Case when m.codigo_producto = 211 and nvl(m.imp_meta,0) = 0
                                Then 0
                                when m.codigo_producto = 211 and nvl(m.imp_sdometa,0) = 0 
                                Then nvl(m.imp_sdobase,0) + nvl(m.imp_meta,0) 
                                when m.codigo_producto = 211 and nvl(m.imp_sdometa,0) <> 0 
                                Then nvl(m.imp_sdometa,0)     
                                Else 0 End) IMP_SdoMetCTS, 
                       sum(Case when m.codigo_producto = 21 and nvl(m.imp_meta,0) = 0
                                Then 0
                                when m.codigo_producto = 21 and nvl(m.imp_sdometa,0) = 0 
                                Then nvl(m.imp_sdobase,0) + nvl(m.imp_meta,0) 
                                when m.codigo_producto = 21 and nvl(m.imp_sdometa,0) <> 0 
                                Then nvl(m.imp_sdometa,0)
                                Else 0 End) IMP_SdoMetAHO,
                       sum(Case when m.codigo_producto = 22 and nvl(m.imp_meta,0) = 0
                                Then 0
                                when m.codigo_producto = 22 and nvl(m.imp_sdometa,0) = 0 
                                Then nvl(m.imp_sdobase,0) + nvl(m.imp_meta,0) 
                                when m.codigo_producto = 22 and nvl(m.imp_sdometa,0) <> 0
                                Then nvl(m.imp_sdometa,0)   
                                Else 0 End) IMP_SdoMetdPF 
                                 
                 FROM tmp_fact_pasivo_prodinc_metas m
                Where ind_tipmet = 1 
                Group By m.tiempo_key,m.geografia_key,m.regionop_key,m.cod_tipage,m.ind_tipmet,
                         m.analista_key,m.des_tipana,m.fec_saldo;
           COMMIT;
           
          ------------------------
          -- ANALISTAS: RESULTADOS
          ------------------------ 
          
          For x in c_resana Loop
               INSERT INTO tmp_fact_pasivo_prodinc_res
                     (tiempo_key,geografia_key,analista_key,des_tipana,fec_saldo,
                      cod_producto,imp_capdep,ind_tipmet,ind_regcap,ind_LogTod
                     ) 
               Select x.tiempo_key,x.geografia_key,x.analista_key,x.des_tipana,x.fec_saldo,
                      '21',x.ahoava,x.ind_tipmet,1,0 from dual
               union all
               Select x.tiempo_key,x.geografia_key,x.analista_key,x.des_tipana,x.fec_saldo,
                      '22',x.dpfava,x.ind_tipmet,1,0 from dual;
               Commit;       
           End Loop;
           
           -- 2022.06.28 INSERTA ANALISTAS QUE NO CAPTARON
           Begin
               INSERT INTO tmp_fact_pasivo_prodinc_res
                         (tiempo_key,geografia_key,analista_key,fec_saldo,
                          cod_producto,imp_capdep,ind_tipmet,ind_regcap,ind_LogTod,des_tipana
                         )
                  SELECT tiempo_key,ageana_key,analista_key,PD_FECHA,
                         '21' codpro,0,ind_regcli,0,0,
                         (SElect nvl(trim(tp1desc),'JUNIOR') 
                                            From DWEXTRA.fst198 z where tp1cod1=10819 and tp1corr1=303 
                                            and z.tp1corr2 = p.tp1nro1) Tipo  
                    From TMP_FACT_PASIVO_CLICAP an
                    Join DWEXTRA.fst198 p on tp1cod1=10819 and tp1corr1=302 
                     and tp1corr3 = ln_period
                     and trim(p.tp1desc) = an.cod_anacre
                    Where ind_regcli = 2 and fec_regcli is null
                          UNION ALL
                  SELECT distinct tiempo_key,ageana_key,analista_key,PD_FECHA,
                         '21' codpro,0,ind_regcli,1,0,
                         (SElect nvl(trim(tp1desc),'JUNIOR') 
                                            From DWEXTRA.fst198 z where tp1cod1=10819 and tp1corr1=303 
                                            and z.tp1corr2 = p.tp1nro1) Tipo  
                    From TMP_FACT_PASIVO_CLICAP an
                    Join DWEXTRA.fst198 p on tp1cod1=10819 and tp1corr1=302 
                     and tp1corr3 = ln_period
                     and trim(p.tp1desc) = an.cod_anacre
                    Where ind_regcli = 2 and fec_Regcli is not null
                      and not exists (select 1 from tmp_fact_pasivo_prodinc_res r 
                                       where r.ind_tipmet = 2 and r.analista_key = an.analista_key);        
               Commit;     
           Exception When Others Then
              Null;
           End;              
           -----------           
          
        -----------------------------------------
        --- ANALISTAS: CAPTACIONES
        -----------------------------------------
        --- CUMPLE TODOS LOS PRODUCTOS
        Update  tmp_fact_pasivo_prodinc_res res set ind_logtod = 1
         Where ind_tipmet = 2
           and exists (select 1 
                         from (select analista_key,sum(nvl(imp_capdep,0)) imp_capdep
                                 from tmp_fact_pasivo_prodinc_res
                                where ind_tipmet = 2
                                group by analista_key
                                having sum(nvl(imp_capdep,0)) > 0
                              ) tab 
                        where tab.analista_key= res.analista_key);
        COMMIT;                
       -----------------------------------------
       --- AGENCIAS: CUMPLE TODOS LOS PRODUCTOS
       -----------------------------------------
       Update tmp_fact_pasivo_prodinc_res 
          set ind_LogTod = 1 
        Where ind_tipmet = 1 
          and ((Por_LogAHO >=1 and nvl(imp_sdometaho,0) > 0) Or (Por_LogAHO = 0 and nvl(imp_sdometaho,0)=0))
          and ((Por_LogDPF >=1 and nvl(imp_sdometdpf,0) > 0) Or (Por_LogDPF = 0 and nvl(imp_sdometdpf,0)=0));
      
       Update tmp_fact_pasivo_prodinc_res set ind_LogTod = 0 
        Where ind_tipmet = 1 
          and nvl(ind_LogTod,0) <> 1 ;
       COMMIT;
       
       -------------------------
       -- RANKIG AGENCIAS
       -------------------------
       Update tmp_fact_pasivo_prodinc_res set rnk_logage = null Where ind_tipmet = 1;
       Commit;
   
       For x In c_tipage Loop
           ln_rnkage := 0;
           ln_cntage := 0;
           ln_pagmes := 0;
           
           For z In c_logtod(x.cod_tipage) Loop
               If x.cod_tipage = 'A' Then
                  ln_cntage := 4;
               ElsIf x.cod_tipage = 'B' Then
                  ln_cntage := 8;
               ElsIf x.cod_tipage = 'C' Then
                  ln_cntage := 10;  
               Else       
                  ln_cntage := 30;
               End If;
               
               ln_rnkage := ln_rnkage + 1;
               lv_tippag := Null;
               ln_pagmes := 0;
               
               If ln_cntage < ln_agetip Then
                  lv_tippag := 'Pago 100%';
               End If;
               ln_cntage := ln_cntage + 1;
               
               Update tmp_fact_pasivo_prodinc_res
                  Set rnk_logage = ln_rnkage,
                      Por_ImpPago= lv_tippag,
                      des_motrnk = 'Cumple Metas'
                Where tiempo_key = z.tiempo_key
                  and geografia_key = z.geografia_key
                  and ind_tipmet = 1;
               Commit;   
           End Loop;
       End Loop;
  END SP_INC_RESULTADOS;
  ----------------------------------------------------------------------------------------
 
  PROCEDURE SP_INC_RESULTADOS_OLD(PD_FECHA In Date)
    --- Deshabilitado:
    --- Fecha: 2022.07.26
    --- Motivo: Usuario requiere cambiar el datos de saldo base sin descuentos
  IS  
     Cursor c_tipage
       is Select distinct cod_tipage From tmp_fact_pasivo_prodinc_res 
           Where cod_tipage Is not null and ind_tipmet = 1;
       
     Cursor c_logtod(lv_tipage in Varchar2)
         is Select * From tmp_fact_pasivo_prodinc_res 
             Where cod_tipage = lv_tipage and ind_tipmet = 1 and IND_LogTod=1
             Order By (Por_LogAHO/*+Por_LogCTS*/+Por_LogDPF) desc;  

     Cursor c_analista
       is Select distinct des_tipana From tmp_fact_pasivo_prodinc_res 
           Where des_tipana Is not null and ind_tipmet = 2;
       
   Cursor c_logtod_an(lv_tipa in varchar2)
       is Select * From tmp_fact_pasivo_prodinc_res 
          Where des_tipana = lv_tipa and ind_tipmet = 2 and IND_LogTod=1
          Order By (Por_LogAHO+Por_LogDPF) desc;  
          
   Cursor c_logacu_an(lv_tipa in varchar2)
       is Select * From tmp_fact_pasivo_prodinc_res 
          Where des_tipana = lv_tipa 
            and ind_tipmet = 2 
            and IND_LogTod=0
          Order By Por_LogACUM desc;    
   
     
     Cursor c_pagoana(ln_tot in Number)
         is  Select * From (
             select analista_key,des_tipana,to_number(to_char(fec_saldo,'rrrrmm')) periodo
               from tmp_fact_pasivo_prodinc_res 
              where ind_tipmet = 2 
                and des_tipana  in ('MASTER','SENIOR','SENIOR EXPERTO')
                and (Por_LogAho + Por_LogDPF) > 0
               Order by ind_logtod desc,(Por_LogAho + Por_LogDPF) desc
              ) Where Rownum <= ln_tot;
     
     Cursor c_pagoana2(ln_tot in Number)
         is  Select * From (
             select analista_key,des_tipana,to_number(to_char(fec_saldo,'rrrrmm')) periodo 
               from tmp_fact_pasivo_prodinc_res 
              where ind_tipmet = 2 
                and des_tipana not in ('MASTER','SENIOR','SENIOR EXPERTO')
                and (Por_LogAho + Por_LogDPF) > 0
               Order by ind_logtod desc,(Por_LogAho + Por_LogDPF) desc
              ) Where Rownum <= ln_tot;
                          
      Cursor c_resana 
            is Select tiempo_key,analista_key,geografia_key,des_tipana,fec_saldo,ind_tipmet,
                      sum(nvl(AHO_C,0)) ahoava,sum(nvl(DPF_C,0)) dpfava
                      from
                      (
               Select dat.*,
                      case when imp_capclit <= 0 Then 0
                           when imp_capclit > 0 and  aho <= 0 then 0  
                           when imp_capclit > 0 and  aho > 0 and dpf <= 0 then imp_capclit 
                           else aho 
                       end AHO_C, 
                      case when imp_capclit <= 0 Then 0
                           when imp_capclit > 0 and  dpf <= 0 then 0  
                           when imp_capclit > 0 and  aho <= 0 and dpf > 0 then imp_capclit 
                           else dpf
                       end DPF_C       
                 From (
               select tiempo_key,analista_key,geografia_key,des_tipana,fec_saldo,
                      cliente_key,imp_capclit,ind_tipmet,
                      sum(case when codigo_producto = '21' then imp_sdoavan - imp_sdobase else 0 end) AHO,
                      sum(case when codigo_producto = '22' then imp_sdoavan - imp_sdobase else 0 end) DPF
                from dwstage.TMP_FACT_PASIVO_PRODINC_METAS where ind_tipmet in (2,7)
               group by tiempo_key,analista_key,geografia_key,des_tipana,fec_saldo,cliente_key,ind_tipmet,imp_capclit
                ) dat)
               group by tiempo_key,analista_key,geografia_key,des_tipana,fec_saldo,ind_tipmet;
                  
               
     
     ln_rnkage Number(5) := 0;  
     ln_pesaho number(7,3) := 0.6; -- Peso ahorros
     ln_pespfc number(7,3) := 0.4; -- Peso DPF + CTS
     ln_agetip number(2) := 1;   -- Cantidad de agencias por tipo
     ln_cntage number(3) := 0;
     ln_anagr1 number(3) := 10;  -- Cantidad de analistas G1 
     ln_anagr2 number(3) := 15;  -- Cantidad de analistas G2
     lv_tippag varchar2(20);
     lv_motrnk varchar2(20);
     ln_pagmes number(5);
     ln_period number(6) := to_number(to_char(PD_FECHA,'rrrrmm'));
  BEGIN
       -- INSERTA SALDO META DE AGENCIAS
       PQ_TMP_PRODUCTIVIDADASE.SP_INC_INSSDOMET_AGE(PD_FECHA);   
  
       Execute Immediate 'Truncate table tmp_fact_pasivo_prodinc_metas';
       Insert Into tmp_fact_pasivo_prodinc_metas
                   (tiempo_key,codigo_producto,geografia_key,regionop_key,imp_meta,
                    cod_tipage,ind_tipmet,analista_key,des_tipana,fec_saldo,imp_sdobase,
                    imp_sdoavan,imp_sdometa
                   )
       -- AGENCIAS: Metas de Ahorros 
       Select TIEMPO_KEY,codpro,GEOGRAFIA_KEY,REGIONOP_KEY,imp_meta,
              cod_tipage,ind_tipmet,anakey,desana,fec_saldo,nvl(imp_base,0),
              nvl(imp_avance,0),
              case when nvl(imp_meta,0) <> 0 Then nvl(imp_meta,0)+nvl(imp_sdomet,0) else 0 end
         from (
       SELECT TIEMPO_KEY,'21' codpro,p.GEOGRAFIA_KEY,REGIONOP_KEY,
              max(nvl(P.IMP_META_AHO,0)) imp_meta,
              p.cod_tipage,1 ind_tipmet,
              0 anakey,'NO CLASIFICADO' desana,p.fec_saldo,
              sum(case when p.cod_producto='21' Then
                       Case When (nvl(p.imp_bonafp_mant,0) + nvl(p.imp_desemb_mant,0)) > nvl(p.saldo_base_mn,0) 
                            then 0 
                            else (nvl(p.saldo_base_mn,0) - (nvl(p.imp_bonafp_mant,0) + nvl(p.imp_desemb_mant,0)))/*/(nvl(p.ind_numtit,1))*/
                       end
                  else 0     
                  end) imp_base,     
              sum(case when p.cod_producto='21' Then
                       case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_avan_mn,0) 
                           then 0 
                           else (nvl(p.saldo_avan_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/(nvl(p.ind_numtit,1))
                       end
                  else 0     
                  end) imp_avance,
              nvl(max(x.tp1imp1),0)imp_sdomet     
         FROM dwstage.TMP_FACT_PASIVO_PRODINC P
         JOIN dwhouse.dm_geografia G ON G.Geografia_Key = P.Geografia_Key
         Left Join DWEXTRA.fst198 x on x.tp1corr2 = to_number(g.Codigo_Agencia) and x.tp1cod1=10819 and x.tp1corr1=304
                   and x.tp1corr3 = ln_period
        Where p.ind_tipinc = 1 
          and g.tipo_region = 'R'
          and p.cod_producto = '21'
        Group By TIEMPO_KEY,p.GEOGRAFIA_KEY,REGIONOP_KEY,p.cod_tipage,p.fec_saldo
                 UNION ALL
       --AGENCIA: Metas DPF
       SELECT TIEMPO_KEY,'22',p.GEOGRAFIA_KEY,REGIONOP_KEY,
              max(nvl(P.IMP_META_DPF,0)),
              p.cod_tipage,1 ind_tipmet,
              0,'NO CLASIFICADO',p.fec_saldo,
              sum(Case When p.cod_producto='22' Then
                           case when (nvl(p.imp_bonafp_mant,0) + nvl(p.imp_desemb_mant,0)) > nvl(p.saldo_base_mn,0) 
                           then 0 
                           else (nvl(p.saldo_base_mn,0) - (nvl(p.imp_bonafp_mant,0) + nvl(p.imp_desemb_mant,0)))/*/(nvl(p.ind_numtit,1))*/
                           End
                  Else 0     
                  end),     
              sum(case when p.cod_producto='22' Then
                      case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_avan_mn,0) 
                           then 0 
                           else (nvl(p.saldo_avan_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/(nvl(p.ind_numtit,1))
                      end
                  Else 0     
                  End),
              nvl(max(x.tp1imp2),0)imp_sdomet     
         FROM dwstage.TMP_FACT_PASIVO_PRODINC P
         JOIN dwhouse.dm_geografia G ON G.Geografia_Key = P.Geografia_Key
         Left Join DWEXTRA.fst198 x on x.tp1corr2 = to_number(g.Codigo_Agencia) and x.tp1cod1=10819 and x.tp1corr1=304
                   and x.tp1corr3 = ln_period
        Where p.ind_tipinc = 1 
          and g.tipo_region = 'R'
          and p.cod_producto = '22'
        Group By TIEMPO_KEY,p.GEOGRAFIA_KEY,REGIONOP_KEY,p.cod_tipage,p.fec_saldo
                 UNION ALL
       --AGENCIAS: Metas CTS
       SELECT TIEMPO_KEY,'211',p.GEOGRAFIA_KEY,REGIONOP_KEY,
              max(nvl(P.IMP_META_CTS,0)),
              p.cod_tipage,1 ind_tipmet,
              0,'NO CLASIFICADO',p.fec_saldo,
              sum(case when p.cod_producto='211' Then
                      case when (nvl(p.imp_bonafp_mant,0) + nvl(p.imp_desemb_mant,0)) > nvl(p.saldo_base_mn,0) 
                           then 0 
                           else (nvl(p.saldo_base_mn,0) - (nvl(p.imp_bonafp_mant,0) + nvl(p.imp_desemb_mant,0)))/(nvl(p.ind_numtit,1))
                      end
                      Else 0     
                      end),     
              sum(case when p.cod_producto='211' Then
                      case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_avan_mn,0) 
                           then 0 
                           else (nvl(p.saldo_avan_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/*/(nvl(p.ind_numtit,1))*/
                      end
                      Else 0     
                      end),
              nvl(max(x.tp1imp3),0)imp_sdomet        
         FROM dwstage.TMP_FACT_PASIVO_PRODINC P
         JOIN dwhouse.dm_geografia G ON G.Geografia_Key = P.Geografia_Key
         Left Join DWEXTRA.fst198 x on x.tp1corr2 = to_number(g.Codigo_Agencia) and x.tp1cod1=10819 and x.tp1corr1=304
                   and x.tp1corr3 = ln_period
        Where p.ind_tipinc = 1 
          and g.tipo_region = 'R'
          and p.cod_producto = '211'
        Group By TIEMPO_KEY,p.GEOGRAFIA_KEY,REGIONOP_KEY,p.cod_tipage,p.fec_saldo
        );
       COMMIT;
    
  --select * from tmp_fact_pasivo_prodinc_metas where ind_Tipmet = 2 and analista_key = 11083502
  --select * from dwhouse.dm_analista where codigo_analista like 'JMOSCO%'
       ----
       -- ANALISTAS
       ----
       Insert Into tmp_fact_pasivo_prodinc_metas
                   (TIEMPO_KEY,CODIGO_PRODUCTO,GEOGRAFIA_KEY,REGIONOP_KEY,/*IMP_META,*/
                    IND_TIPMET,ANALISTA_KEY,DES_TIPANA,FEC_SALDO,cliente_key,imp_sdobase,imp_sdoavan,IMP_CAPCLIT)  
              
               Select dat.*,
                      sum(dat.avance-dat.base) over(partition by analista_key,cliente_key) poscli
                  from(      
              Select p.tiempo_key,p.cod_producto,
                     (case when p.ind_tipinc = 7 then p.geografia_key else p.ageana_key end) ageana_key,
                     p.regionop_key,
                     p.ind_tipinc,
                     (case when p.ind_tipinc = 2 then p.analista_key else p.asecre_key end) analista_key,
                     NVL(p.des_tipana,'NO CLASIFICADO'),
                     fec_saldo,p.cliente_key,
                     sum(case when p.cod_producto='21' Then
                                   Case When (nvl(p.imp_bonafp_mant,0) + nvl(p.imp_desemb_mant,0)) > nvl(p.saldo_base_mn,0) 
                                        then 0 
                                        else (nvl(p.saldo_base_mn,0) - (nvl(p.imp_bonafp_mant,0) + nvl(p.imp_desemb_mant,0)))/(nvl(p.ind_numtit,1))
                                   end
                           When p.cod_producto='22' Then
                               case when (nvl(p.imp_bonafp_mant,0) + nvl(p.imp_desemb_mant,0)) > nvl(p.saldo_base_mn,0) 
                               then 0 
                               else (nvl(p.saldo_base_mn,0) - (nvl(p.imp_bonafp_mant,0) + nvl(p.imp_desemb_mant,0)))/(nvl(p.ind_numtit,1))
                               End
                           When p.cod_producto='211' Then   
                                 case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_avan_mn,0) 
                                       then 0 
                                 else (nvl(p.saldo_avan_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/(nvl(p.ind_numtit,1))
                                 end
                            Else 0     
                         end) base,     
                     sum(case when p.cod_producto='21' Then
                              case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_avan_mn,0) 
                                   then 0 
                                   else (nvl(p.saldo_avan_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/(nvl(p.ind_numtit,1))
                              end
                              when p.cod_producto='22' Then
                              case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_avan_mn,0) 
                                   then 0 
                                   else (nvl(p.saldo_avan_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/(nvl(p.ind_numtit,1))
                              end
                              when p.cod_producto='211' Then
                              case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_avan_mn,0) 
                              then 0 
                              else (nvl(p.saldo_avan_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/(nvl(p.ind_numtit,1))
                              end
                      Else 0     
                      end) avance
                FROM dwstage.TMP_FACT_PASIVO_PRODINC P
                JOIN dwhouse.dm_geografia G ON G.Geografia_Key = P.Geografia_Key
               Where p.ind_tipinc in (2,7)  --Analistas y Asesores
                 and g.tipo_region = 'R'
               Group by p.tiempo_key,p.cod_producto,p.ageana_key,p.regionop_key,p.ind_tipinc,
                        p.analista_key,NVL(p.des_tipana,'NO CLASIFICADO'),fec_saldo,p.cliente_key,
                        (case when p.ind_tipinc = 7 then p.geografia_key else p.ageana_key end),
                        (case when p.ind_tipinc = 2 then p.analista_key else p.asecre_key end)  
                        )dat;  
                       
            COMMIT;
   
           ------------------------
           -- AGENCIAS: RESULTADOS
           ------------------------
           EXECUTE IMMEDIATE 'TRUNCATE TABLE tmp_fact_pasivo_prodinc_res';
           
           INSERT INTO tmp_fact_pasivo_prodinc_res
                       (tiempo_key,geografia_key,regionop_key,cod_tipage,ind_tipmet,analista_key,
                        des_tipana,fec_saldo,imp_metcts,imp_metaho,imp_metdpf,
                        imp_bascts,imp_basaho,imp_basdpf,imp_avacts,imp_avaaho,imp_avadpf,
                        imp_logcts,imp_logaho,imp_logdpf,por_logcts,por_logaho,por_logdpf,
                        imp_sdometcts,imp_sdometaho,imp_sdometdpf
                       ) 
                SELECT m.tiempo_key,m.geografia_key,m.regionop_key,m.cod_tipage,m.ind_tipmet,
                       m.analista_key,m.des_tipana,m.fec_saldo,
                       sum(Case when m.codigo_producto = 211 Then nvl(m.imp_meta,0) End) IMP_MetCTS, 
                       sum(Case when m.codigo_producto = 21 Then nvl(m.imp_meta,0) End) IMP_MetAHO, 
                       sum(Case when m.codigo_producto = 22 Then nvl(m.imp_meta,0) End) IMP_MetDPF, 
                   
                   
                       sum(Case when m.codigo_producto = 211 Then nvl(m.imp_sdobase,0) End) IMP_BasCTS, 
                       sum(Case when m.codigo_producto = 21 Then nvl(m.imp_sdobase,0) End) IMP_BasAHO, 
                       sum(Case when m.codigo_producto = 22 Then nvl(m.imp_sdobase,0) End) IMP_BasDPF, 
                   
                       sum(Case when m.codigo_producto = 211 Then nvl(m.imp_sdoavan,0) End) IMP_AvaCTS, 
                       sum(Case when m.codigo_producto = 21 Then nvl(m.imp_sdoavan,0) End) IMP_AvaAHO, 
                       sum(Case when m.codigo_producto = 22 Then nvl(m.imp_sdoavan,0) End) IMP_AvaDPF, 
                   
                       sum(Case when m.codigo_producto = 211 Then nvl(m.imp_sdoavan,0)- (nvl(m.imp_sdobase,0)) End) IMP_LogCTS, 
                       sum(Case when m.codigo_producto = 21 Then nvl(m.imp_sdoavan,0) - nvl(m.imp_sdobase,0) End) IMP_LogAHO,
                       sum(Case when m.codigo_producto = 22 Then nvl(m.imp_sdoavan,0) - nvl(m.imp_sdobase,0) End) IMP_LogDPF,
                      
                       /*sum(Case when m.codigo_producto = 211 and nvl(m.imp_meta,0) = 0 Then 0
                                When m.codigo_producto = 211 and nvl(m.imp_meta,0)<> 0
                                Then (nvl(m.imp_sdoavan,0)-nvl(m.imp_sdobase,0))/nvl(m.imp_meta,0) 
                           End) POR_LogCTS, 
                       sum(Case when m.codigo_producto = 21 and nvl(m.imp_meta,0)=0 Then 0
                                When m.codigo_producto = 21 and nvl(m.imp_meta,0)<> 0
                                Then (nvl(m.imp_sdoavan,0)-nvl(m.imp_sdobase,0))/nvl(m.imp_meta,0) 
                           End) POR_LogAHO,
                       sum(Case when m.codigo_producto = 22 and nvl(m.imp_meta,0)=0 Then 0
                                When m.codigo_producto = 22 and nvl(m.imp_meta,0)<> 0
                                Then (nvl(m.imp_sdoavan,0)-nvl(m.imp_sdobase,0))/nvl(m.imp_meta,0) 
                           End) POR_LogDPF,
                       */  
                       sum(Case when m.codigo_producto = 211 and nvl(m.imp_meta,0) = 0 Then 0
                                When m.codigo_producto = 211 and nvl(m.imp_meta,0) <> 0 and
                                     nvl(m.imp_sdometa,0) <> 0 
                                Then nvl(m.imp_sdoavan,0)/nvl(m.imp_sdometa,0)  
                                When m.codigo_producto = 211 and nvl(m.imp_meta,0) <> 0 and
                                     nvl(m.imp_sdometa,0) = 0
                                Then nvl(m.imp_sdoavan,0)/(nvl(m.imp_sdobase,0) + nvl(m.imp_meta,0))       
                           End) POR_LogCTS,  
                       sum(Case when m.codigo_producto = 21 and nvl(m.imp_meta,0)=0 Then 0
                                When m.codigo_producto = 21 and nvl(m.imp_meta,0)<> 0 and 
                                     nvl(m.imp_sdometa,0) <> 0 
                                Then nvl(m.imp_sdoavan,0)/nvl(m.imp_sdometa,0)  
                                When m.codigo_producto = 21 and nvl(m.imp_meta,0)<> 0 and 
                                     nvl(m.imp_sdometa,0) = 0      
                                Then nvl(m.imp_sdoavan,0)/(nvl(m.imp_sdobase,0) + nvl(m.imp_meta,0)) 
                           End) POR_LogAHO,    
                       sum(Case when m.codigo_producto = 22 and nvl(m.imp_meta,0)=0 Then 0
                                When m.codigo_producto = 22 and nvl(m.imp_meta,0)<> 0 and 
                                     nvl(m.imp_sdometa,0) <> 0 
                                Then nvl(m.imp_sdoavan,0)/nvl(m.imp_sdometa,0)  
                                When m.codigo_producto = 22 and nvl(m.imp_meta,0)<> 0 and 
                                     nvl(m.imp_sdometa,0) = 0      
                                Then nvl(m.imp_sdoavan,0)/(nvl(m.imp_sdobase,0) + nvl(m.imp_meta,0)) 
                           End) POR_LogDPF,    
                       sum(Case when m.codigo_producto = 211 and nvl(m.imp_meta,0) = 0
                                Then 0
                                when m.codigo_producto = 211 and nvl(m.imp_sdometa,0) = 0 
                                Then nvl(m.imp_sdobase,0) + nvl(m.imp_meta,0) 
                                when m.codigo_producto = 211 and nvl(m.imp_sdometa,0) <> 0 
                                Then nvl(m.imp_sdometa,0)     
                                Else 0 End) IMP_SdoMetCTS, 
                       sum(Case when m.codigo_producto = 21 and nvl(m.imp_meta,0) = 0
                                Then 0
                                when m.codigo_producto = 21 and nvl(m.imp_sdometa,0) = 0 
                                Then nvl(m.imp_sdobase,0) + nvl(m.imp_meta,0) 
                                when m.codigo_producto = 21 and nvl(m.imp_sdometa,0) <> 0 
                                Then nvl(m.imp_sdometa,0)
                                Else 0 End) IMP_SdoMetAHO,
                       sum(Case when m.codigo_producto = 22 and nvl(m.imp_meta,0) = 0
                                Then 0
                                when m.codigo_producto = 22 and nvl(m.imp_sdometa,0) = 0 
                                Then nvl(m.imp_sdobase,0) + nvl(m.imp_meta,0) 
                                when m.codigo_producto = 22 and nvl(m.imp_sdometa,0) <> 0
                                Then nvl(m.imp_sdometa,0)   
                                Else 0 End) IMP_SdoMetdPF 
                                 
                 FROM tmp_fact_pasivo_prodinc_metas m
                Where ind_tipmet = 1 
                Group By m.tiempo_key,m.geografia_key,m.regionop_key,m.cod_tipage,m.ind_tipmet,
                         m.analista_key,m.des_tipana,m.fec_saldo;
           COMMIT;
           
          ------------------------
          -- ANALISTAS: RESULTADOS
          ------------------------ 
          
          For x in c_resana Loop
               INSERT INTO tmp_fact_pasivo_prodinc_res
                     (tiempo_key,geografia_key,analista_key,des_tipana,fec_saldo,
                      cod_producto,imp_capdep,ind_tipmet,ind_regcap,ind_LogTod
                     ) 
               Select x.tiempo_key,x.geografia_key,x.analista_key,x.des_tipana,x.fec_saldo,
                      '21',x.ahoava,x.ind_tipmet,1,0 from dual
               union all
               Select x.tiempo_key,x.geografia_key,x.analista_key,x.des_tipana,x.fec_saldo,
                      '22',x.dpfava,x.ind_tipmet,1,0 from dual;
               Commit;       
           End Loop;
           
           -- 2022.06.28 INSERTA ANALISTAS QUE NO CAPTARON
           Begin
               INSERT INTO tmp_fact_pasivo_prodinc_res
                         (tiempo_key,geografia_key,analista_key,fec_saldo,
                          cod_producto,imp_capdep,ind_tipmet,ind_regcap,ind_LogTod,des_tipana
                         )
                  SELECT tiempo_key,ageana_key,analista_key,PD_FECHA,
                         '21' codpro,0,ind_regcli,0,0,
                         (SElect nvl(trim(tp1desc),'JUNIOR') 
                                            From DWEXTRA.fst198 z where tp1cod1=10819 and tp1corr1=303 
                                            and z.tp1corr2 = p.tp1nro1) Tipo  
                    From TMP_FACT_PASIVO_CLICAP an
                    Join DWEXTRA.fst198 p on tp1cod1=10819 and tp1corr1=302 
                     and tp1corr3 = ln_period
                     and trim(p.tp1desc) = an.cod_anacre
                    Where ind_regcli = 2 and fec_regcli is null
                          UNION ALL
                  SELECT distinct tiempo_key,ageana_key,analista_key,PD_FECHA,
                         '21' codpro,0,ind_regcli,1,0,
                         (SElect nvl(trim(tp1desc),'JUNIOR') 
                                            From DWEXTRA.fst198 z where tp1cod1=10819 and tp1corr1=303 
                                            and z.tp1corr2 = p.tp1nro1) Tipo  
                    From TMP_FACT_PASIVO_CLICAP an
                    Join DWEXTRA.fst198 p on tp1cod1=10819 and tp1corr1=302 
                     and tp1corr3 = ln_period
                     and trim(p.tp1desc) = an.cod_anacre
                    Where ind_regcli = 2 and fec_Regcli is not null
                      and not exists (select 1 from tmp_fact_pasivo_prodinc_res r 
                                       where r.ind_tipmet = 2 and r.analista_key = an.analista_key);        
               Commit;     
           Exception When Others Then
              Null;
           End;              
           -----------           
          
        -----------------------------------------
        --- ANALISTAS: CAPTACIONES
        -----------------------------------------
        --- CUMPLE TODOS LOS PRODUCTOS
        Update  tmp_fact_pasivo_prodinc_res res set ind_logtod = 1
         Where ind_tipmet = 2
           and exists (select 1 
                         from (select analista_key,sum(nvl(imp_capdep,0)) imp_capdep
                                 from tmp_fact_pasivo_prodinc_res
                                where ind_tipmet = 2
                                group by analista_key
                                having sum(nvl(imp_capdep,0)) > 0
                              ) tab 
                        where tab.analista_key= res.analista_key);
        COMMIT;                
        --Update tmp_fact_pasivo_prodinc_res set ind_LogTod = 1 
         --Where ind_tipmet = 2;
        --COMMIT;
       -----------------------------------------
       --- AGENCIAS: CUMPLE TODOS LOS PRODUCTOS
       -----------------------------------------
       Update tmp_fact_pasivo_prodinc_res 
          set ind_LogTod = 1 
        Where ind_tipmet = 1 
          --and ((Por_LogCTS >=1 and nvl(imp_metcts,0) > 0) Or (Por_LogCTS = 0 and nvl(imp_metcts,0)=0)) 
          and ((Por_LogAHO >=1 and nvl(imp_sdometaho,0) > 0) Or (Por_LogAHO = 0 and nvl(imp_sdometaho,0)=0))
          and ((Por_LogDPF >=1 and nvl(imp_sdometdpf,0) > 0) Or (Por_LogDPF = 0 and nvl(imp_sdometdpf,0)=0));
      
       Update tmp_fact_pasivo_prodinc_res set ind_LogTod = 0 
        Where ind_tipmet = 1 
          and nvl(ind_LogTod,0) <> 1 ;
       COMMIT;
       
       -------------------------
       -- RANKIG AGENCIAS
       -------------------------
       Update tmp_fact_pasivo_prodinc_res set rnk_logage = null Where ind_tipmet = 1;
       Commit;
   
       For x In c_tipage Loop
           ln_rnkage := 0;
           ln_cntage := 0;
           ln_pagmes := 0;
           
           For z In c_logtod(x.cod_tipage) Loop
               If x.cod_tipage = 'A' Then
                  ln_cntage := 4;
               ElsIf x.cod_tipage = 'B' Then
                  ln_cntage := 8;
               ElsIf x.cod_tipage = 'C' Then
                  ln_cntage := 10;  
               Else       
                  ln_cntage := 30;
               End If;
               
               ln_rnkage := ln_rnkage + 1;
               lv_tippag := Null;
               ln_pagmes := 0;
               
               If ln_cntage < ln_agetip Then
                  --ln_cntage := ln_cntage + 1;
                  lv_tippag := 'Pago 100%';
               End If;
               ln_cntage := ln_cntage + 1;
               
               Update tmp_fact_pasivo_prodinc_res
                  Set rnk_logage = ln_rnkage,
                      Por_ImpPago= lv_tippag,
                      des_motrnk = 'Cumple Metas'
                Where tiempo_key = z.tiempo_key
                  and geografia_key = z.geografia_key
                  and ind_tipmet = 1;
               Commit;   
           End Loop;
       End Loop;
  END SP_INC_RESULTADOS_OLD;
  ----------------------------------------------------------------------------------------
  PROCEDURE SP_INC_APERTURA_DIG(PD_FECDIA In Date)
  -- DESDE JULIO 2022 NO CALCULAR APERTURA DIGITAL
  IS
        PD_FECCIE date := last_day(add_months(PD_FECDIA,-1));
        ld_feimes date := to_date(to_char(PD_FECDIA,'rrrrmm')||'01','rrrrmmdd');
        ld_feiman date := to_date(to_char(PD_FECCIE,'rrrrmm')||'01','rrrrmmdd');
        ln_period number := to_number(to_char(PD_FECDIA,'rrrrmm'));
        ln_tipcam number(7,3) := pq_tmp_productividadase.fn_tipo_cambio_fijo(PD_FECDIA);
        ld_fecpro date := PD_FECDIA;
        ln_saldo number(12,2);
                
        Cursor c_aper 
            Is Select k.fecha_apertura,k.aomod,k.aocta,k.aoope,k.aosbo,k.aotop,k.aomda,
                to_number(cl.tipo_documento) tdoc,cl.numero_documento ndoc,
                cl.pais, geografia_key,regionop_key,d.cuenta_key,d.ind_regcli,
                case when d.ind_regcli = 1 and d.ind_tipinc = 1 then d.cod_usuage
                     when d.ind_regcli = 1 and d.ind_tipinc = 2 then d.cod_anacre
                     when d.ind_regcli = 1 and d.ind_tipinc = 3 then d.cod_ejeaho
                     when d.ind_regcli = 1 and d.ind_tipinc = 7 then d.cod_asecre
                     else null
                end COD_USUREG            
                from TMP_FACT_PASIVO_PRODINC d
                Join dwhouse.dm_cuentas c on c.cuentas_key = d.cuenta_key
                Join dwstage.tmp_dm_cuenta k on k.codigo_cuenta = c.codigo_cuenta and k.cuenta_unica = c.cuenta_unica
                Join dwhouse.dm_cliente cl on cl.cliente_key = d.cliente_key
                Where nvl(ind_finmes,'X') <> 'S' and ind_tipinc = 1;
                
        Cursor c_des (ld_fini in date, ld_ffin in date)
            IS Select k.cuentas_key,ds.hcmod||'-'||ds.htran||'-'||ds.hnrel||'-'||ds.hsucor trxdet,ds.hfcon,
                     decode(ds.hmda,0,ds.hcimp1,ds.hcimp1*ln_tipcam) hcimp1
                from TMP_TRX_DESEM_CUENTA ds
                Join tmp_dm_cuenta ct on ct.aomod = ds.hmodul
                  and ct.aomda = ds.hmda
                  and ct.aocta = ds.hcta
                  and ct.aoope = ds.hoper
                  and ct.aosbo = ds.hsubop
                  and ct.aotop = ds.htoper
                  and ct.aomod = ds.hmodul
                Join dwhouse.dm_cuentas k on k.codigo_cuenta = ct.codigo_cuenta
                     and k.cuenta_unica = ct.cuenta_unica
                Where ds.hfcon between ld_fini and ld_ffin;        
       
        lv_usuape varchar2(10); 
        ln_agekey Number(10);      
        lv_nrotrx varchar2(20);   
        lv_agedes varchar2(100); 
        lv_usuage varchar2(10);
        ld_fecage date;
        ln_ha number(1);
        ln_ac number(1);
        ln_tipinc number(1);
        ln_asesor number(1);
        ln_regana number(5);
        ln_geoope number(10);
        ln_tip Number(5);
        
        ln_anakey number(10); -- 24/08/2021
        ln_aseckey number(10); -- 24/04/2022

  BEGIN
        --- DESEMBOLSOS MES EN CURSO       
        For x in c_des(ld_feimes,PD_FECDIA) Loop
            Update TMP_FACT_PASIVO_PRODINC y
               SET imp_desemb = nvl(imp_desemb,0) + x.hcimp1,
                   des_trxape = x.trxdet,
                   fec_aperen = x.hfcon
             Where cuenta_key = x.cuentas_key;
             Commit;
        End Loop;  
    
        --- DESEMBOLSOS MES ANTERIOR       
        For x in c_des(ld_feiman,PD_FECCIE) Loop
            Update TMP_FACT_PASIVO_PRODINC y
               SET y.imp_desemb_mant = nvl(imp_desemb_mant,0) + x.hcimp1
             Where cuenta_key = x.cuentas_key;
             Commit;
        End Loop;
         
            /*            
        ----
        For x In c_aper Loop
            lv_usuape := Null;
            lv_nrotrx := Null;
            lv_agedes := Null;
            ld_fecage := Null;
            ln_anakey := Null;
            ln_geoope := x.regionop_key;
            lv_usuage := x.COD_USUREG;
            ln_agekey := x.geografia_key;
     
            IF x.fecha_apertura between ld_feimes and PD_FECDIA THEN
               IF x.aomod = 21 and x.aotop <> 2 Then  -- AHORROS
                   -- Buscar en tabla de aperturas el usuario que realiza la apertura
                   Begin
                     select trim(cv1aux6) Into lv_usuape
                       from dwextra.fse113
                      Where cv1cta = x.aocta
                        and cv1mod = x.aomod
                        and cv1sbop = x.aosbo
                        and cv1tope = x.aotop
                        and cv1mda = x.aomda
                        and cv1oper = x.aoope;
                    Exception When Others Then
                       lv_usuape := Null;
                    End;
                ELSIF x.aomod = 22 Then
                     Begin
                         select trim(us.codigo_usuario),
                                nt.modtrx||'-'||op.num_reltrx
                           Into lv_usuape,lv_nrotrx
                          from dwhouse.fact_op_transaccion op
                          Join dwhouse.dm_usuario us on us.usuario_key = op.key_usuario
                          Join dwhouse.dm_tiempo tp on tp.tiempo_key = op.tiempo_key
                          Join dwhouse.dm_transaccion nt on nt.transacc_key=op.transacc_key
                         Where tp.fecha = x.fecha_apertura
                           and op.cuentas_key = x.cuenta_key;
                     Exception When Others Then
                         lv_usuape := Null;
                     End;
                END IF;
              
               
               
               If lv_usuape in ('USRMOVIL','NSBTUSER') and lv_usuage Is Null Then 
                  ln_tipinc := 6;  --- APETRURA CAJA DIGITAL
                                 -----
                  -- ACTUALIZA INFORMACION
                  Update TMP_FACT_PASIVO_PRODINC
                    SET cod_opeape = lv_usuape,
                        des_trxape = lv_nrotrx,
                        geoape_key = ln_agekey,
                        --geoape_desc = lv_agedes,
                        ind_tipinc = ln_tipinc,
                        COD_USUREG = lv_usuage
                  Where cuenta_key = x.cuenta_key;
                  Commit;
               End If;
          END IF;     
      End Loop;
       */
  END SP_INC_APERTURA_DIG;   
  ----------------------------------------------------------------------------------------
  PROCEDURE SP_INC_APERTURA_DIG_OLD(PD_FECDIA In Date)
    --- HASTA JUNIO
  IS
        PD_FECCIE date := last_day(add_months(PD_FECDIA,-1));
        ld_feimes date := to_date(to_char(PD_FECDIA,'rrrrmm')||'01','rrrrmmdd');
        ld_feiman date := to_date(to_char(PD_FECCIE,'rrrrmm')||'01','rrrrmmdd');
        ln_period number := to_number(to_char(PD_FECDIA,'rrrrmm'));
        ln_tipcam number(7,3) := pq_tmp_productividadase.fn_tipo_cambio_fijo(PD_FECDIA);
        ld_fecpro date := PD_FECDIA;
        ln_saldo number(12,2);
                
        Cursor c_aper 
            Is Select k.fecha_apertura,k.aomod,k.aocta,k.aoope,k.aosbo,k.aotop,k.aomda,
                to_number(cl.tipo_documento) tdoc,cl.numero_documento ndoc,
                cl.pais, geografia_key,regionop_key,d.cuenta_key,d.ind_regcli,
                case when d.ind_regcli = 1 and d.ind_tipinc = 1 then d.cod_usuage
                     when d.ind_regcli = 1 and d.ind_tipinc = 2 then d.cod_anacre
                     when d.ind_regcli = 1 and d.ind_tipinc = 3 then d.cod_ejeaho
                     when d.ind_regcli = 1 and d.ind_tipinc = 7 then d.cod_asecre
                     else null
                end COD_USUREG            
                from TMP_FACT_PASIVO_PRODINC d
                Join dwhouse.dm_cuentas c on c.cuentas_key = d.cuenta_key
                Join dwstage.tmp_dm_cuenta k on k.codigo_cuenta = c.codigo_cuenta and k.cuenta_unica = c.cuenta_unica
                Join dwhouse.dm_cliente cl on cl.cliente_key = d.cliente_key
                Where nvl(ind_finmes,'X') <> 'S' and ind_tipinc = 1;
                
        Cursor c_des (ld_fini in date, ld_ffin in date)
            IS Select k.cuentas_key,ds.hcmod||'-'||ds.htran||'-'||ds.hnrel||'-'||ds.hsucor trxdet,ds.hfcon,
                     decode(ds.hmda,0,ds.hcimp1,ds.hcimp1*ln_tipcam) hcimp1
                from TMP_TRX_DESEM_CUENTA ds
                Join tmp_dm_cuenta ct on ct.aomod = ds.hmodul
                  and ct.aomda = ds.hmda
                  and ct.aocta = ds.hcta
                  and ct.aoope = ds.hoper
                  and ct.aosbo = ds.hsubop
                  and ct.aotop = ds.htoper
                  and ct.aomod = ds.hmodul
                Join dwhouse.dm_cuentas k on k.codigo_cuenta = ct.codigo_cuenta
                     and k.cuenta_unica = ct.cuenta_unica
                Where ds.hfcon between ld_fini and ld_ffin;        
       
        lv_usuape varchar2(10); 
        ln_agekey Number(10);      
        lv_nrotrx varchar2(20);   
        lv_agedes varchar2(100); 
        lv_usuage varchar2(10);
        ld_fecage date;
        ln_ha number(1);
        ln_ac number(1);
        ln_tipinc number(1);
        ln_asesor number(1);
        ln_regana number(5);
        ln_geoope number(10);
        ln_tip Number(5);
        
        ln_anakey number(10); -- 24/08/2021
        ln_aseckey number(10); -- 24/04/2022

  BEGIN
        --- LIMPIA DATOS ANTERIORES
        /*UPDATE TMP_FACT_PASIVO_PRODINC
           SET cod_opeape = null,
               des_trxape = null,
               geoape_key = null,
               geoape_desc = null,
               fec_aperen  = null,
               ind_tipape = null,
               imp_desemb = 0
         Where nvl(ind_finmes,'X') <> 'S' and ind_tipinc = 1;
        Commit; */      
        
        --- DESEMBOLSOS MES EN CURSO       
        For x in c_des(ld_feimes,PD_FECDIA) Loop
            Update TMP_FACT_PASIVO_PRODINC y
               SET imp_desemb = nvl(imp_desemb,0) + x.hcimp1,
                   des_trxape = x.trxdet,
                   fec_aperen = x.hfcon
             Where cuenta_key = x.cuentas_key;
             Commit;
        End Loop;  
    
        --- DESEMBOLSOS MES ANTERIOR       
        For x in c_des(ld_feiman,PD_FECCIE) Loop
            Update TMP_FACT_PASIVO_PRODINC y
               SET y.imp_desemb_mant = nvl(imp_desemb_mant,0) + x.hcimp1
             Where cuenta_key = x.cuentas_key;
             Commit;
        End Loop;  
                        
        ----
        For x In c_aper Loop
            lv_usuape := Null;
            lv_nrotrx := Null;
            lv_agedes := Null;
            ld_fecage := Null;
            ln_anakey := Null;
            ln_geoope := x.regionop_key;
            lv_usuage := x.COD_USUREG;
            ln_agekey := x.geografia_key;
     
            IF x.fecha_apertura between ld_feimes and PD_FECDIA THEN
               IF x.aomod = 21 and x.aotop <> 2 Then  -- AHORROS
                   -- Buscar en tabla de aperturas el usuario que realiza la apertura
                   Begin
                     select trim(cv1aux6) Into lv_usuape
                       from dwextra.fse113
                      Where cv1cta = x.aocta
                        and cv1mod = x.aomod
                        and cv1sbop = x.aosbo
                        and cv1tope = x.aotop
                        and cv1mda = x.aomda
                        and cv1oper = x.aoope;
                    Exception When Others Then
                       lv_usuape := Null;
                    End;
                ELSIF x.aomod = 22 Then
                     Begin
                         select trim(us.codigo_usuario),
                                nt.modtrx||'-'||op.num_reltrx
                           Into lv_usuape,lv_nrotrx
                          from dwhouse.fact_op_transaccion op
                          Join dwhouse.dm_usuario us on us.usuario_key = op.key_usuario
                          Join dwhouse.dm_tiempo tp on tp.tiempo_key = op.tiempo_key
                          Join dwhouse.dm_transaccion nt on nt.transacc_key=op.transacc_key
                         Where tp.fecha = x.fecha_apertura
                           and op.cuentas_key = x.cuenta_key;
                     Exception When Others Then
                         lv_usuape := Null;
                     End;
                END IF;
              
               
               
               If lv_usuape in ('USRMOVIL','NSBTUSER') and lv_usuage Is Null Then 
                  ln_tipinc := 6;  --- APETRURA CAJA DIGITAL
                                 -----
                  -- ACTUALIZA INFORMACION
                  Update TMP_FACT_PASIVO_PRODINC
                    SET cod_opeape = lv_usuape,
                        des_trxape = lv_nrotrx,
                        geoape_key = ln_agekey,
                        --geoape_desc = lv_agedes,
                        ind_tipinc = ln_tipinc,
                        COD_USUREG = lv_usuage
                  Where cuenta_key = x.cuenta_key;
                  Commit;
               End If;
          END IF;     
      End Loop;
  END SP_INC_APERTURA_DIG_OLD;     
  ----------------------------------------------------------------------------------------
  PROCEDURE SP_INC_ACT_METAS_AGENCIAS(PD_FECDIA In Date)
  --------------------------------------------------------------- 
  --- PROCESO: Actualiza Metas por agencia/producto y region operaciones
  ---------------------------------------------------------------
  Is
      ln_perdia number(6) := to_number(to_char(PD_FECDIA,'rrrrmm'));
      ln_guiapr number(5) := 10819;
      ln_per number(6) := to_number(to_char(PD_FECDIA,'rrrrmm'));
           
      Cursor c_tipage(ln_guia in Number,ln_per in Number)
          is Select tp1corr2 codage, tp1corr3 permet,trim(upper(tp1desc)) tipage, tp1imp1 metaho,tp1imp2 metdpf,tp1imp3 metcts
               from dwextra.fst198 u 
              where u.tp1cod = 1 and u.tp1cod1 = ln_guia and u.tp1corr1 = 301
                and tp1corr3 = (select max(tp1corr3) from dwextra.fst198
                                  Where tp1cod1 = u.tp1cod1 and tp1corr1 = u.tp1corr1
                                    and tp1corr2 = u.tp1corr2
                                    and tp1corr3 <= ln_per)
                                    union all
                             SElect to_number(codigo_agencia),ln_per,Null,0,0,0 
                               From dwhouse.dm_geografia
                              Where to_number(codigo_agencia) not in (Select tp1corr2 
                                                                        From dwextra.fst198 
                                                                       Where tp1cod = 1 
                                                                         and tp1cod1 = ln_guia 
                                                                         and tp1corr1 = 301)
                                and tipo_region = 'R' and to_number(codigo_agencia) < 800 
                                and to_number(codigo_agencia) <> 0;
      
      Cursor c_ana
          is Select distinct a.codigo_analista,k.analista_key
               From TMP_FACT_PASIVO_PRODINC k
               Join dwhouse.dm_analista a 
                 on a.analista_key = k.analista_key
              Where ind_tipinc = 2;
           
       
      ln_regkey Number(10);
      ln_agekey Number(10);     
      ln_agetes Number(10);  
      ln_metaho Number(12,2);
      ln_metdpf Number(12,2);
      ln_permet Number(6);
      lv_tipana Varchar2(20);  
      ln_tipana Number(3);                      
  BEGIN
       -- Actualiza Metas y Tipo de Agencia
       For x In c_tipage(ln_guiapr,ln_perdia) Loop
           Begin
              Select h.geografia_key Into ln_agekey
                From dwhouse.dm_geografia h
               Where h.tipo_region = 'R'
                 and to_number(h.codigo_agencia) = x.codage; 
           Exception When Others Then
              ln_agekey := Null;
           End;
         
           Begin
              Select h.geografia_key Into ln_agetes
                From dwhouse.dm_geografia h
               Where h.tipo_region <> 'R'
                 and to_number(h.codigo_agencia) = x.codage; 
           Exception When Others Then
              ln_agetes := Null;
           End;
         
           ln_regkey := dwstage.pq_tmp_carga_transacc.fn_key_region_op(x.codage,PD_FECDIA);
         
           Update TMP_FACT_PASIVO_PRODINC u
              Set u.cod_tipage   = x.tipage,
                  u.regionop_key = ln_regkey,
                  u.imp_meta_aho = nvl(x.metaho,0),
                  u.imp_meta_dpf = nvl(x.metdpf,0),
                  u.imp_meta_cts = nvl(x.metcts,0),
                  u.ind_permet   = x.permet
            Where u.geografia_key = ln_agekey;
              --and u.ind_tipinc = 1;
            Commit;      
          
            If ln_agetes Is Not Null Then
               Update TMP_FACT_PASIVO_PRODINC u
                Set u.cod_tipage   = x.tipage,
                    u.regionop_key = ln_regkey,
                    u.imp_meta_aho = nvl(x.metaho,0),
                    u.imp_meta_dpf = nvl(x.metdpf,0),
                    u.imp_meta_cts = nvl(x.metcts,0),
                    u.ind_permet   = x.permet
              Where u.geografia_key = ln_agetes;
              Commit;    
            End If;
       End Loop; 
     
       Update TMP_FACT_PASIVO_PRODINC u
          Set u.regionop_key = 0
        Where u.regionop_key Is Null;
       COMMIT;   
        
       ----
       -- Agencia de Analista
       ----
       For x in c_ana Loop
            --- Busca agencia en tabla de metas
            Begin
                SElect g.geografia_key,
                       (SElect nvl(trim(tp1desc),'') 
                          From DWEXTRA.fst198 z where tp1cod1=10819 and tp1corr1=303 
                          and z.tp1corr2 = p.tp1nro1) Tipo   
                  Into ln_agekey,lv_tipana
                  From DWEXTRA.fst198 p
                  Join dwhouse.dm_geografia g on to_number(g.codigo_agencia) = p.tp1imp2
                 Where tp1cod1=10819 and tp1corr1=302 
                   and tp1corr3 = ln_perdia 
                   and trim(p.tp1desc) = x.codigo_analista
                   and g.tipo_region = 'R';
            Exception When Others Then
                ln_agekey := Null;
                lv_tipana := null;
            End;
            --- Busca agencia en tabla de productividad de analista
            /*Begin
              select ge.geografia_key , case when jaqy830catana like '%SENIOR%EXPERTO%' then 9
                        when jaqy830catana like '%AVANZADO%EXPERTO%' then 5
                        when jaqy830catana like '%AVANZADO%SUPERIOR%' then 4
                        when jaqy830catana like '%AVANZADO%' and jaqy830catana not like '%SUPERIOR%' and 
                             jaqy830catana not like '%EXPERTO%' then 6
                        when jaqy830catana like '%SUPERIOR%' and jaqy830catana not like '%AVANZADO%' and 
                             jaqy830catana not like '%SENIOR%' then 1 
                        when jaqy830catana like '%MASTER%' then 2   
                        when jaqy830catana like '%EXPERTO%' and jaqy830catana not like '%AVANZADO%' and 
                             jaqy830catana not like '%SENIOR%' then 3
                        when jaqy830catana like '%SENIOR%' and jaqy830catana not like '%AVANZADO%' and 
                             jaqy830catana not like '%EXPERTO%' then 7
                        when jaqy830catana like '%JUNIOR%' or jaqy830catana like '%FORMACION%' then 8
                        else null
                     end code      
                Into ln_agekey,ln_tipana
                from Jaqy830@produ pr
                JOIN dwhouse.dm_geografia ge on upper(trim(ge.nombre_agencia)) = trim(upper(pr.jaqy830agen))
               where jaqy830est='S' and trim(jaqy830codana) = x.codigo_analista
                 and tipo_region = 'R';
            Exception When Others Then
                ln_agekey := Null;
                ln_tipana := null;
            End;
            */
            --- Si no encuentra en tabla de analista, obtiene agencia de tabla de usuarios
            IF ln_agekey is null Or ln_agekey = 117893 Then
                Begin
                    Select ge.geografia_key
                      Into ln_agekey
                      From fst046@produ ag
                      Join dwhouse.dm_geografia ge on to_number(ge.codigo_agencia) = ag.ubsuc
                     Where ag.ubuser = rpad(x.codigo_analista,10,' ')
                       and ge.tipo_region = 'R';
                Exception When Others Then
                    ln_agekey := Null;
                End;
            End If;
            
            ---- TIPO DE ANALISTA
            /*Begin
            SElect trim(tp1desc) Into lv_tipana
               From DWEXTRA.fst198 where tp1cod1=10819 and tp1corr1=303 and tp1corr2 = 2;
            Exception When Others Then
                lv_tipana := null;
            End;*/
                 
            Update TMP_FACT_PASIVO_PRODINC u
              Set u.des_tipana   = lv_tipana,
                  u.ageana_key   = nvl(ln_agekey,u.ageana_key)
            Where u.analista_key = x.analista_key;
            
            COMMIT;
          
       End Loop;  
  END SP_INC_ACT_METAS_AGENCIAS;
  ----------------------------------------------------------------------------------------
  -- PROCEDURE SP_INC_RENTENCION_SLD
  /*select tiempo_key,cuentas_key,saldo_mn,estado_key from dwhouse.fact_pasivo partition(fact_pasivo_20220429) where cuentas_key in (
Select pr.cuenta_key FROM  dwhouse.fact_pasivo_prodinc pr
join dwhouse.dm_tiempo tm on tm.tiempo_key = pr.tiempo_key
Where tm.fecha = '01/04/2022'
  and pr.fec_saldo = '30/04/2022'
  and pr.ind_tipinc in (2,7))*/
  -- END SP_INC_RENTENCION_SLD; 
  ----------------------------------------------------------------------------------------
  PROCEDURE SP_INC_RETENCION(PD_FECHA In Date)
  IS
    Cursor c_sdo
        is select t.cuenta_key, t.tiempo_key from TMP_FACT_PASIVO_PRODINC t;
    
    ld_mesant date := to_date(to_char(add_months(PD_FECHA,-1),'rrrrmm')||'01','rrrrmmdd');
    ln_tieant number(10) := dwhouse.pq_carga_facts.fn_tiempo_key(ld_mesant);
    ld_fecha  date := PD_FECHA;
    ln_tiepk number(10) := dwhouse.pq_carga_facts.fn_tiempo_key(ld_fecha);
    ln_saldo number(12,2);
    ln_period number(8) := to_number(to_char(ld_mesant,'rrrrmm'),999999);
    ld_fecsdo date;
    
    -- Analistas
    Cursor c_ana
        is Select distinct a.codigo_analista,k.analista_key
             From TMP_FACT_PASIVO_PRODINC k
             Join dwhouse.dm_analista a 
               on a.analista_key = k.analista_key
            Where ind_tipinc = 2;
              
    --- Pago
    Cursor c_resana 
            is Select tiempo_key,analista_key,geografia_key,des_tipana,fec_saldo,ind_tipmet,fec_sldren,
                      sum(nvl(AHO_C,0)) ahoava,sum(nvl(DPF_C,0)) dpfava,
                      sum(nvl(AHO_R,0)) ahoret,sum(nvl(DPF_R,0)) dpfret
                      from
                      (
               Select dat.*,
                      case when imp_capclit <= 0 Then 0
                           when imp_capclit > 0 and  aho <= 0 then 0  
                           when imp_capclit > 0 and  aho > 0 and dpf <= 0 then imp_capclit 
                           else aho 
                       end AHO_C, 
                      case when imp_capclit <= 0 Then 0
                           when imp_capclit > 0 and  dpf <= 0 then 0  
                           when imp_capclit > 0 and  aho <= 0 and dpf > 0 then imp_capclit 
                           else dpf
                       end DPF_C,
                        case when imp_retclit <= 0 Then 0
                           when imp_retclit > 0 and  AHOR <= 0 then 0  
                           when imp_retclit > 0 and  AHOR > 0 and DPFR <= 0 then imp_retclit 
                           else AHOR 
                       end AHO_R, 
                      case when imp_retclit <= 0 Then 0
                           when imp_retclit > 0 and  DPFR <= 0 then 0  
                           when imp_retclit > 0 and  AHOR <= 0 and DPFR > 0 then imp_retclit 
                           else DPFR
                       end DPF_R         
                 From (
               select tiempo_key,analista_key,geografia_key,des_tipana,fec_saldo,
                      cliente_key,imp_capclit,ind_tipmet,imp_retclit,fec_sldren,
                      sum(case when codigo_producto <> '22' then imp_sdoavan - imp_sdobase else 0 end) AHO,
                      sum(case when codigo_producto = '22' then imp_sdoavan - imp_sdobase else 0 end) DPF,
                      sum(case when codigo_producto <> '22' then imp_sdorete - imp_sdobase else 0 end) AHOR,
                      sum(case when codigo_producto = '22' then imp_sdorete - imp_sdobase else 0 end) DPFR
                from dwstage.TMP_FACT_PASIVO_PRODINC_METAS where ind_tipmet in (2,7)
               group by tiempo_key,analista_key,geografia_key,des_tipana,fec_saldo,cliente_key,
                        ind_tipmet,imp_capclit,imp_retclit,fec_sldren
                ) dat)
               group by tiempo_key,analista_key,geografia_key,des_tipana,fec_saldo,ind_tipmet,fec_sldren;
     
     ln_agetip number(2) := 1;   -- Cantidad de agencias por tipo
     ln_pagaho number(7,3); -- Pago ahorros negocio
     ln_pagdpf number(7,3);-- Pago DPF negocio
     
     ln_pahoas number(7,3) := 0.5; -- Pago ahorros asesores
     ln_pdpfas number(7,3) := 0.25; -- Pago DPF asesores
     ln_pahoan number(7,3) := 0.7; -- Pago ahorros analista
     ln_pdpfan number(7,3) := 0.4; -- Pago DPF analista
     
     lv_tippag varchar2(20);
     lv_motrnk varchar2(20);
     ln_pagmes number(5);
     lv_tipana varchar(20);
  Begin
     Execute Immediate 'truncate table TMP_FACT_PASIVO_PRODINC';
     Begin
         INSERT INTO TMP_FACT_PASIVO_PRODINC
               (tiempo_key, cliente_key, producto_key, geografia_key, cuenta_key, 
                empleador_key, saldo_base_mn, tiempo_sld_key, saldo_avan_mn, 
                fec_proceso, ind_finmes, ind_tipinc, cod_ejeaho, cod_anacre, 
                analista_key, imp_tragob, cod_tipage, regionop_key, imp_meta_aho, 
                imp_meta_dpf, imp_meta_cts, ind_permet, cod_opeape, des_trxape, 
                geoape_key, geoape_desc, fec_aperen, ind_tipape, cod_usuage, 
                fec_regage, imp_desemb, des_tipana, ind_anainc, ageana_key, 
                imp_bonafp_mant, imp_desemb_mant,
                cod_producto,
                fec_saldo,cod_asecre,asecre_key,
                ind_numtit,ind_regcli,fec_regcli,cod_usureg,pais,tdoc,ndoc,aocta,
                fec_sldren)
         Select x.tiempo_key, cliente_key, producto_key, geografia_key, cuenta_key, 
                empleador_key, saldo_base_mn, tiempo_sld_key, saldo_avan_mn, 
                fec_proceso, ind_finmes, ind_tipinc, cod_ejeaho, cod_anacre, 
                analista_key, imp_tragob, cod_tipage, regionop_key, imp_meta_aho, 
                imp_meta_dpf, imp_meta_cts, ind_permet, cod_opeape, des_trxape, 
                geoape_key, geoape_desc, fec_aperen, ind_tipape, cod_usuage, 
                fec_regage, imp_desemb, des_tipana, ind_anainc, ageana_key, 
                imp_bonafp_mant, imp_desemb_mant,cod_producto,fec_saldo,
                cod_asecre,asecre_key,
                ind_numtit,ind_regcli,fec_regcli,cod_usureg,pais,tdoc,ndoc,cuenta,
                PD_FECHA
           From dwhouse.fact_pasivo_prodinc x
           Join dwhouse.dm_tiempo t on t.tiempo_key = x.tiempo_key
           Where t.fecha = ld_mesant 
             and x.ind_tipinc in (2,7);
           Commit;
     Exception When Others Then
        Null;
     End;    
     --- Actualiza saldo a fecha de retención
     For x in c_sdo Loop
        Begin
            Select saldo_mn Into ln_saldo
              From dwhouse.fact_pasivo p
              Where p.tiempo_key = ln_tiepk
                and p.cuentas_key = x.cuenta_key; 
        Exception When Others Then
           ln_saldo := 0;
        End;  
        Update TMP_FACT_PASIVO_PRODINC s
           set s.saldo_reten_mn = ln_saldo,s.fec_sldren = PD_FECHA
          Where s.cuenta_key = x.cuenta_key
            and s.tiempo_key = x.tiempo_key;
        Commit;        
    End Loop;
    -- ACTUALIZA TIPO DE ANALISTA
    For x in c_ana Loop
        --- Busca agencia en tabla de metas
            Begin
                SElect trim(z.tp1desc)  
                  Into lv_tipana
                  From DWEXTRA.fst198 p
                  Join DWEXTRA.fst198 z 
                    on z.tp1corr2 = p.tp1nro1 and z.tp1cod1 = p.tp1cod1
                   and z.tp1corr1=303
                 Where p.tp1cod1=10819 and p.tp1corr1=302 
                   and p.tp1corr3 = ln_period 
                   and trim(p.tp1desc) = x.codigo_analista;
            Exception When Others Then
                lv_tipana := null;
            End;
            Update TMP_FACT_PASIVO_PRODINC an
               set an.des_tipana =lv_tipana
              Where an.analista_key = x.analista_key;
              Commit;
       End Loop;     
    -- PAGOS DE ANALISTAS Y ASESORES
    Execute Immediate 'Truncate table tmp_fact_pasivo_prodinc_metas';
    Execute Immediate 'Truncate table tmp_fact_pasivo_prodinc_res';

    Insert Into tmp_fact_pasivo_prodinc_metas
                (TIEMPO_KEY,CODIGO_PRODUCTO,GEOGRAFIA_KEY,REGIONOP_KEY,
                 IND_TIPMET,ANALISTA_KEY,DES_TIPANA,FEC_SALDO,cliente_key,
                 imp_sdobase,imp_sdoavan,imp_sdorete,fec_sldren,IMP_CAPCLIT,imp_retclit)  
          Select dat.*,
                 sum(dat.avance-dat.base) over(partition by analista_key,cliente_key) poscli,
                 sum(dat.reten-dat.base) over(partition by analista_key,cliente_key) posret
            from(      
                  Select p.tiempo_key,p.cod_producto,
                         (case when p.ind_tipinc = 7 then p.geografia_key else p.ageana_key end) ageana_key,
                         p.regionop_key,
                         p.ind_tipinc,
                         (case when p.ind_tipinc = 2 then p.analista_key else p.asecre_key end) analista_key,
                         NVL(p.des_tipana,'NO CLASIFICADO'),
                         fec_saldo,p.cliente_key,
                         sum(case when p.cod_producto <>  '22' Then
                                       Case When (nvl(p.imp_bonafp_mant,0) + nvl(p.imp_desemb_mant,0)) > nvl(p.saldo_base_mn,0) 
                                            then 0 
                                            else (nvl(p.saldo_base_mn,0) - (nvl(p.imp_bonafp_mant,0) + nvl(p.imp_desemb_mant,0)))/(nvl(p.ind_numtit,1))
                                       end
                               When p.cod_producto='22' Then
                                   case when (nvl(p.imp_bonafp_mant,0) + nvl(p.imp_desemb_mant,0)) > nvl(p.saldo_base_mn,0) 
                                   then 0 
                                   else (nvl(p.saldo_base_mn,0) - (nvl(p.imp_bonafp_mant,0) + nvl(p.imp_desemb_mant,0)))/(nvl(p.ind_numtit,1))
                                   End
                               /*When p.cod_producto='211' Then   
                                     case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_avan_mn,0) 
                                           then 0 
                                     else (nvl(p.saldo_avan_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/(nvl(p.ind_numtit,1))
                                     end*/
                                Else 0     
                             end) base,     
                             sum(case when p.cod_producto <> '22' Then
                                      case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_avan_mn,0) 
                                           then 0 
                                       else (nvl(p.saldo_avan_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/(nvl(p.ind_numtit,1))
                                  end
                                  when p.cod_producto='22' Then
                                  case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_avan_mn,0) 
                                       then 0 
                                       else (nvl(p.saldo_avan_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/(nvl(p.ind_numtit,1))
                                  end
                                  /*when p.cod_producto='211' Then
                                  case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_avan_mn,0) 
                                  then 0 
                                  else (nvl(p.saldo_avan_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/(nvl(p.ind_numtit,1))
                                  end*/
                          Else 0     
                          end) avance,
                          sum(case when p.cod_producto<>'22' Then
                                  case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_reten_mn,0) 
                                       then 0 
                                       else (nvl(p.saldo_reten_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/(nvl(p.ind_numtit,1))
                                  end
                                  when p.cod_producto='22' Then
                                  case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_reten_mn,0) 
                                       then 0 
                                       else (nvl(p.saldo_reten_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/(nvl(p.ind_numtit,1))
                                  end
                                  /*when p.cod_producto='211' Then
                                  case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_reten_mn,0) 
                                  then 0 
                                  else (nvl(p.saldo_reten_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/(nvl(p.ind_numtit,1))
                                  end*/
                              Else 0     
                              end) reten,fec_sldren
                    FROM dwstage.TMP_FACT_PASIVO_PRODINC P
                    JOIN dwhouse.dm_geografia G ON G.Geografia_Key = P.Geografia_Key
                   Where p.ind_tipinc in (2,7)  --Analistas y Asesores
                     and g.tipo_region = 'R'
                   Group by p.tiempo_key,p.cod_producto,p.ageana_key,p.regionop_key,p.ind_tipinc,
                            p.analista_key,NVL(p.des_tipana,'NO CLASIFICADO'),fec_saldo,p.cliente_key,
                            (case when p.ind_tipinc = 7 then p.geografia_key else p.ageana_key end),
                            (case when p.ind_tipinc = 2 then p.analista_key else p.asecre_key end),fec_sldren  
                            )dat;  
                           
                COMMIT;
          ------------------------
          -- ANALISTAS Y ASESORES: RESULTADOS
          ------------------------ 
          For x in c_resana Loop
              ld_fecsdo := x.fec_saldo;
              If x.ind_tipmet = 2 Then 
                 ln_pagaho := ln_pahoan;
                 ln_pagdpf := ln_pdpfan;
              Else
                 ln_pagaho := ln_pahoas;
                 ln_pagdpf := ln_pdpfas;
              End If;    

               INSERT INTO tmp_fact_pasivo_prodinc_res
                     (tiempo_key,geografia_key,analista_key,des_tipana,fec_saldo,cod_producto,
                      imp_capdep,ind_tipmet,imp_capret,fec_sldren,imp_pagmes,ind_regcap,ind_LogTod
                     )
               Select x.tiempo_key,x.geografia_key,x.analista_key,x.des_tipana,x.fec_saldo,'21',
                      x.ahoava,x.ind_tipmet,nvl(x.ahoret,0),x.fec_sldren,
                      case when nvl(x.ahoret,0) < nvl(x.ahoava,0) then nvl(x.ahoret,0)*(ln_pagaho/100) Else nvl(x.ahoava,0)*(ln_pagaho/100) End,
                      1,0  
                 from dual
               union all
               Select x.tiempo_key,x.geografia_key,x.analista_key,x.des_tipana,x.fec_saldo,'22',
                      x.dpfava,x.ind_tipmet,nvl(x.dpfret,0),x.fec_sldren,
                      case when nvl(x.dpfret,0) < nvl(x.dpfava,0) Then nvl(x.dpfret,0)*(ln_pagdpf/100) Else nvl(x.dpfava,0)*(ln_pagdpf/100) End,
                      1,0 
                 from dual;
               Commit;       
                    
          End Loop;

          -- 2022.06.28 INSERTA ANALISTAS QUE NO CAPTARON
          Begin
              INSERT INTO tmp_fact_pasivo_prodinc_res
                         (tiempo_key,geografia_key,analista_key,fec_saldo,
                          cod_producto,imp_capdep,ind_tipmet,ind_regcap,ind_LogTod,des_tipana,
                          imp_capret,fec_sldren,imp_pagmes
                         )
                   Select ln_tieant,ge.geografia_key,an.analista_key,ld_fecsdo, 
                          '21' codpro,0,2,0,0,  
                           (SElect nvl(trim(tp1desc),'JUNIOR') 
                                            From DWEXTRA.fst198 z where tp1cod1=10819 and tp1corr1=303 
                                            and z.tp1corr2 = p.tp1nro1) tipo,
                          0,PD_FECHA,0                                    
                    From DWEXTRA.fst198 p 
                    Join dwhouse.dm_analista an on an.codigo_analista = trim(p.tp1desc)
                    Join dwhouse.dm_geografia ge on to_number(ge.codigo_agencia) = p.tp1imp2
                     and ge.tipo_region = 'R'
                   Where tp1cod1=10819 and tp1corr1=302 
                     and tp1corr3 = ln_period
                       and not exists (select 1 from tmp_fact_pasivo_prodinc_res r 
                                      where r.ind_tipmet = 2 and r.analista_key = an.analista_key);
               Commit;     
           Exception When Others Then
              Null;
           End;              
          -----------   
          -----------------------------------------
          --- ANALISTAS: LOGROS
          -----------------------------------------
          --- CUMPLE TODOS LOS PRODUCTOS/PAGO
          BEGIN
             Update  tmp_fact_pasivo_prodinc_res res set ind_logtod = 1
             Where ind_tipmet in (2,7)
               and exists (select 1 
                             from (select analista_key,sum(nvl(imp_capdep,0)) imp_capdep
                                     from tmp_fact_pasivo_prodinc_res
                                    where ind_tipmet in (2,7)
                                    group by analista_key
                                    having sum(nvl(imp_capdep,0)) > 0
                                  ) tab 
                            where tab.analista_key= res.analista_key);
             COMMIT;    
          EXCEPTION WHEN OTHERS THEN
              NULL;
          END;      
          --- PAGOS
          BEGIN
              Update tmp_fact_pasivo_prodinc_res
                 set imp_pagmes = (case when cod_producto = '21' and (des_tipana like 'SENIOR%' or des_tipana like 'MASTER%')
                                        and nvl(imp_pagmes,0) > 300 then 300 
                                       when cod_producto = '21' and (des_tipana not like 'SENIOR%' and des_tipana not like 'MASTER%')
                                        and nvl(imp_pagmes,0) > 200 then 200
                                       when cod_producto = '22' and (des_tipana like 'SENIOR%' or des_tipana like 'MASTER%')
                                        and nvl(imp_pagmes,0) > 350 then 350 
                                       when cod_producto = '22' and (des_tipana not like 'SENIOR%' and des_tipana not like 'MASTER%')
                                        and nvl(imp_pagmes,0) > 250 then 250
                                       else nvl(imp_pagmes,0)
                                    end     
                                   ) 
                Where ind_tipmet = 2;
               Commit;
                  
               Update tmp_fact_pasivo_prodinc_res
                 set imp_pagmes = (case when cod_producto = '21' and nvl(imp_pagmes,0) > 200 then 200 
                                        when cod_producto = '22' and nvl(imp_pagmes,0) > 250 then 250 
                                       else nvl(imp_pagmes,0)
                                    end      
                                   ) 
                Where ind_tipmet = 7; 
                Commit;                   
          EXCEPTION WHEN OTHERS THEN
              NULL;
          END;
        /*Update tmp_fact_pasivo_prodinc_res 
            set ind_LogTod = 1
         Where ind_tipmet in (2,7);
        COMMIT;
        */ 
  END SP_INC_RETENCION;
  ----------------------------------------------------------------------------------------
  PROCEDURE SP_INC_SALDOS_AGE(PD_FECHA In Date)
    -- DESDE JULIO 2022 YA NO SE EXCLUYEN APERTURAS DIGITALES
  IS
      ln_existe number(10);
      ln_period number(6) := 202112;
      ld_fecini date := to_date(to_char(PD_FECHA,'rrrrmm')||'01','rrrrmmdd');
      ld_fecfin date := PD_FECHA;
      ln_tipcam number(7,6) := pq_tmp_productividadase.fn_tipo_cambio_fijo(ld_fecfin);
      ln_tiempo number(10) := dwhouse.pq_carga_facts.fn_tiempo_key(ld_fecfin);
      ln_tieuno number(10) := dwhouse.pq_carga_facts.fn_tiempo_key(ld_fecini);
  BEGIN
      -- LIMPIA TABLAS
      Delete From tmp_fact_pasivo_prodinc Where tiempo_key = ln_tiempo and ind_tipinc = 9;
      Commit; 
      Delete From tmp_fact_pasivo_prodinc_metas Where tiempo_key = ln_tiempo and ind_tipmet = 9;
      Commit;
      
      /*   
      -- APERTURAS DIGITALES
      Select count(*) Into ln_existe from user_tables where table_name = 'TMP_APERTURA_DIGITAL';
      If ln_existe > 0 Then
         Execute Immediate 'drop table TMP_APERTURA_DIGITAL purge';
      End If;
      
      Begin
          Execute Immediate 'Create table TMP_APERTURA_DIGITAL tablespace dwstage as '||
                            'Select tr.cuentas_key, tr.cnt_transacc ind_apedig '||
                              'From dwhouse.fact_op_transaccion tr '||
                              'Join dwhouse.dm_transaccion xs on xs.transacc_key = tr.transacc_key '||
                              'Join dwhouse.dm_tiempo tm on tm.tiempo_key = tr.tiempo_key '||
                              'Join dwhouse.dm_cuentas ct on ct.cuentas_key = tr.cuentas_key '||
                              'Join dwhouse.dm_detcanal dc on dc.key_detcanal = tr.key_detcanal '||
                              'Join dwhouse.dm_canal m on m.key_canal = dc.key_canal '||
                              'Join dwhouse.dm_producto pr on pr.producto_key = tr.key_prodpas_reg '||
                              'Join dwhouse.dm_cuentas kt on kt.cuentas_key = tr.cuentas_key '||
                             'Where xs.cod_grupo in (7,8,9) '||
                               'and xs.des_clase like ''%APERTURA%'' '||
                               'and m.cod_canal <> 1 '|| 
                               'and tr.ind_estado = 0 '||
                               'and tm.periodo > '||ln_period;
         Execute Immediate 'Create index IX_TMP_APEDIG1 on TMP_APERTURA_DIGITAL(cuentas_key)';
     Exception When Others Then
         dbms_output.put_line(sqlerrm);
     End;
     */
     --- DESEMBOLSOS
     Begin
         Insert Into tmp_fact_pasivo_prodinc(tiempo_key,ind_tipinc,cuenta_key,aocta,fec_aperen,imp_desemb,saldo_reten_mn)
         
         select ln_tiempo,9,cts.cuentas_key,hcta,hfcon,sum(hcimp1) hcimp1,
                sum(case when hmda = 101 then hcimp1 * ln_tipcam else hcimp1 end) impdes
           From dwstage.TMP_TRX_DESEM_CUENTA ds
           Join dwstage.tmp_dm_cuenta ct on ct.aocta = ds.hcta
            and ct.aoope = ds.hoper and ct.aomod = ds.hmodul
            and ct.aomda = ds.hmda and ct.aosbo = ds.hsubop and ct.aotop = ds.htoper
           Join dwhouse.dm_cuentas cts on cts.codigo_cuenta = ct.codigo_cuenta
            and cts.cuenta_unica = ct.cuenta_unica  
          Where hfcon between ld_fecini and ld_fecfin 
          Group by cts.cuentas_key,hfcon,hcta;
         Commit; 
     Exception When Others Then
         dbms_output.put_line(sqlerrm);
     End;             
  
     --- SALDOS DESEMBOLSOS
     Execute Immediate 'INSERT INTO tmp_fact_pasivo_prodinc_metas'||
                                   '(tiempo_key,codigo_producto,geografia_key,ind_tipmet,fec_saldo,'||
                                    'imp_sdoavan,imp_sdobase,imp_apecta,imp_desemb,imp_meta) '||
             'Select ps.tiempo_key,pr.codigo_producto,ps.geografia_key,9,:1,sum(ps.saldo_mn),'||
                    'sum(case when nvl(ps.saldo_mn,0) >= nvl(des.impdes,0) '||
                             'then nvl(ps.saldo_mn,0) -  nvl(des.impdes,0) '||
                             'else 0 end '||
                        ') saldo_neto,'||
                    'sum(0) importe_apedig,'|| 
                    'sum(case when nvl(ps.saldo_mn,0) >= nvl(des.impdes,0) Then nvl(des.impdes,0) '||
                             'else nvl(ps.saldo_mn,0) '||
                        'end) imp_desemb,met.imp_meta '||       
               'From dwhouse.fact_pasivo ps '||
               'Join dwhouse.dm_producto pr on pr.producto_key = ps.producto_key '||
               'Left Join (select ds.cuenta_key,sum(ds.saldo_reten_mn) impdes '||
                            'from tmp_fact_pasivo_prodinc ds '||
                           'Where ds.tiempo_key = :2 '||--
                             'and ds.ind_tipinc = 9 '||
                        'group by ds.cuenta_key '||
                          ') des on des.cuenta_key = ps.cuentas_key '||   
               'Left Join (Select geografia_key,pm.codigo_producto,sum(meta_saldo_mn) imp_meta '||
                            'from dwhouse.fact_pasivo_meta_agencia mt '||
                            'Join dwhouse.dm_producto pm on pm.producto_key = mt.producto_key '||
                           'where tiempo_key =  :3'||-- 
                        'Group By tiempo_key,geografia_key,pm.codigo_producto '||
                          ') met on met.geografia_key = ps.geografia_key '||
                               'and met.codigo_producto = pr.codigo_producto '||
               'Where ps.tiempo_key = :4 '|| --
                 'and ps.estado_key <> 72 '||
            'Group by ps.tiempo_key,pr.codigo_producto,ps.geografia_key,met.imp_meta'
            Using ld_fecfin,ln_tiempo,ln_tieuno,ln_tiempo;
    Commit;
 
  END SP_INC_SALDOS_AGE;
----------------------------------------------------------------------------------------
  PROCEDURE SP_INC_SALDOS_AGE_OLD(PD_FECHA In Date)
    -- HASTA JUNIO200
  IS
      ln_existe number(10);
      ln_period number(6) := 202112;
      ld_fecini date := to_date(to_char(PD_FECHA,'rrrrmm')||'01','rrrrmmdd');
      ld_fecfin date := PD_FECHA;
      ln_tipcam number(7,6) := pq_tmp_productividadase.fn_tipo_cambio_fijo(ld_fecfin);
      ln_tiempo number(10) := dwhouse.pq_carga_facts.fn_tiempo_key(ld_fecfin);
      ln_tieuno number(10) := dwhouse.pq_carga_facts.fn_tiempo_key(ld_fecini);
  BEGIN
      -- LIMPIA TABLAS
      Delete From tmp_fact_pasivo_prodinc Where tiempo_key = ln_tiempo and ind_tipinc = 9;
      Commit; 
      Delete From tmp_fact_pasivo_prodinc_metas Where tiempo_key = ln_tiempo and ind_tipmet = 9;
      Commit;
         
      -- APERTURAS DIGITALES
      Select count(*) Into ln_existe from user_tables where table_name = 'TMP_APERTURA_DIGITAL';
      If ln_existe > 0 Then
         Execute Immediate 'drop table TMP_APERTURA_DIGITAL purge';
      End If;
      
      Begin
          Execute Immediate 'Create table TMP_APERTURA_DIGITAL tablespace dwstage as '||
                            'Select tr.cuentas_key, tr.cnt_transacc ind_apedig '||
                              'From dwhouse.fact_op_transaccion tr '||
                              'Join dwhouse.dm_transaccion xs on xs.transacc_key = tr.transacc_key '||
                              'Join dwhouse.dm_tiempo tm on tm.tiempo_key = tr.tiempo_key '||
                              'Join dwhouse.dm_cuentas ct on ct.cuentas_key = tr.cuentas_key '||
                              'Join dwhouse.dm_detcanal dc on dc.key_detcanal = tr.key_detcanal '||
                              'Join dwhouse.dm_canal m on m.key_canal = dc.key_canal '||
                              'Join dwhouse.dm_producto pr on pr.producto_key = tr.key_prodpas_reg '||
                              'Join dwhouse.dm_cuentas kt on kt.cuentas_key = tr.cuentas_key '||
                             'Where xs.cod_grupo in (7,8,9) '||
                               'and xs.des_clase like ''%APERTURA%'' '||
                               'and m.cod_canal <> 1 '|| 
                               'and tr.ind_estado = 0 '||
                               'and tm.periodo > '||ln_period;
         Execute Immediate 'Create index IX_TMP_APEDIG1 on TMP_APERTURA_DIGITAL(cuentas_key)';
     Exception When Others Then
         dbms_output.put_line(sqlerrm);
     End;

     --- DESEMBOLSOS
     Begin
         Insert Into tmp_fact_pasivo_prodinc(tiempo_key,ind_tipinc,cuenta_key,aocta,fec_aperen,imp_desemb,saldo_reten_mn)
         
         select ln_tiempo,9,cts.cuentas_key,hcta,hfcon,sum(hcimp1) hcimp1,
                sum(case when hmda = 101 then hcimp1 * ln_tipcam else hcimp1 end) impdes
           From dwstage.TMP_TRX_DESEM_CUENTA ds
           Join dwstage.tmp_dm_cuenta ct on ct.aocta = ds.hcta
            and ct.aoope = ds.hoper and ct.aomod = ds.hmodul
            and ct.aomda = ds.hmda and ct.aosbo = ds.hsubop and ct.aotop = ds.htoper
           Join dwhouse.dm_cuentas cts on cts.codigo_cuenta = ct.codigo_cuenta
            and cts.cuenta_unica = ct.cuenta_unica  
          Where hfcon between ld_fecini and ld_fecfin 
          Group by cts.cuentas_key,hfcon,hcta;
         Commit; 
     Exception When Others Then
         dbms_output.put_line(sqlerrm);
     End;             
  
     --- SALDOS, APETURAS Y DESEMBOLSOS
     Execute Immediate 'INSERT INTO tmp_fact_pasivo_prodinc_metas'||
                                   '(tiempo_key,codigo_producto,geografia_key,ind_tipmet,fec_saldo,'||
                                    'imp_sdoavan,imp_sdobase,imp_apecta,imp_desemb,imp_meta) '||
             'Select ps.tiempo_key,pr.codigo_producto,ps.geografia_key,9,:1,sum(ps.saldo_mn),'||
                    'sum(case when nvl(ad.ind_apedig,0) = 1 then 0 '||
                             'when nvl(ad.ind_apedig,0) = 0 and nvl(ps.saldo_mn,0) >= nvl(des.impdes,0) '||
                             'then nvl(ps.saldo_mn,0) -  nvl(des.impdes,0) '||
                             'else 0 end '||
                        ') saldo_neto,'||
                    'sum(case when nvl(ad.ind_apedig,0) = 1 then nvl(ps.saldo_mn,0) '||
                             'else 0 '|| 
                         'end) importe_apedig,'|| 
                    'sum(case when nvl(ad.ind_apedig,0) = 1 then 0 '||
                             'when nvl(ps.saldo_mn,0) >= nvl(des.impdes,0) Then nvl(des.impdes,0) '||
                             'else nvl(ps.saldo_mn,0) '||
                        'end) imp_desemb,met.imp_meta '||       
               'From dwhouse.fact_pasivo ps '||
               'Join dwhouse.dm_producto pr on pr.producto_key = ps.producto_key '||
               'Left Join (select ds.cuenta_key,sum(ds.saldo_reten_mn) impdes '||
                            'from tmp_fact_pasivo_prodinc ds '||
                           'Where ds.tiempo_key = :2 '||--
                             'and ds.ind_tipinc = 9 '||
                        'group by ds.cuenta_key '||
                          ') des on des.cuenta_key = ps.cuentas_key '||   
               'Left Join TMP_APERTURA_DIGITAL ad on ad.cuentas_key = ps.cuentas_key '||
               'Left Join (Select geografia_key,pm.codigo_producto,sum(meta_saldo_mn) imp_meta '||
                            'from dwhouse.fact_pasivo_meta_agencia mt '||
                            'Join dwhouse.dm_producto pm on pm.producto_key = mt.producto_key '||
                           'where tiempo_key =  :3'||-- 
                        'Group By tiempo_key,geografia_key,pm.codigo_producto '||
                          ') met on met.geografia_key = ps.geografia_key '||
                               'and met.codigo_producto = pr.codigo_producto '||
               'Where ps.tiempo_key = :4 '|| --
                 'and ps.estado_key <> 72 '||
            'Group by ps.tiempo_key,pr.codigo_producto,ps.geografia_key,met.imp_meta'
            Using ld_fecfin,ln_tiempo,ln_tieuno,ln_tiempo;
    Commit;
 
  END SP_INC_SALDOS_AGE_OLD;
  ----------------------------------------------------------------------------------------
  PROCEDURE SP_INC_RESULTADOS_AGE(PD_FECHA In date)
  IS
    ln_tiempo number(10) := dwhouse.pq_carga_facts.fn_tiempo_key(PD_FECHA);
    ln_period number(8) := to_number(to_char(PD_FECHA,'yyyymm'));
    ld_diauno date := to_date(to_char(PD_FECHA,'yyyymm')||'01','rrrrmmdd');
    ln_tieuno number(10) := dwhouse.pq_carga_facts.fn_tiempo_key(ld_diauno);
    ln_minage number(15,6) := 0.95;
    ln_porana number(15,6) := 0.80;
    ln_pagage number(12,2) := 500;
    ln_minzon number(15,6) := 0.95;
    ln_pagzon number(12,2) := 700;
    ln_minreg number(15,6) := 0.95;
    ln_pagreg number(12,2) := 1000;
    
    Cursor c_metas(ln_tie in Number)
        is Select geografia_key,sum(meta_saldo_mn) imp_meta 
             from dwhouse.fact_pasivo_meta_agencia mt 
            Where tiempo_key =  ln_tie
            Group By tiempo_key,geografia_key;

  BEGIN
    Delete from tmp_fact_pasivo_prodinc_res where tiempo_key = ln_tiempo and ind_tipmet in (90,91,92);
    Commit;
    --90:Agencia / 91:Zonas / 92:Regiones
    
    -- Agencias
    Insert Into tmp_fact_pasivo_prodinc_res
                (tiempo_key,geografia_key,ind_tipmet,fec_saldo,cod_zona,
                 des_zona,imp_metaho,imp_basaho,imp_avaaho,por_logaho,
                 cod_region,des_region,imp_avacts,imp_avadpf)
         Select ps.tiempo_key,ps.geografia_key,90,ps.fec_saldo,ge.codigo_zona,
                ge.nombre_zona,sum(ps.imp_meta),sum(ps.imp_sdoavan) sdobruto,
                sum(ps.imp_sdobase) sdoneto,
                (case when sum(ps.imp_meta) <> 0 then round(sum(ps.imp_sdobase)/sum(ps.imp_meta),8) else 0 end) logro,
                ge.codigo_region,ge.nombre_region,
                (select count(an.tp1desc) from DWEXTRA.fst198 an 
                   Join dwhouse.dm_geografia ge on to_number(ge.codigo_agencia) = an.tp1imp2 and ge.tipo_region = 'R'
                  where tp1cod1=10819 
                    and tp1corr1=302 and tp1corr3 = ln_period 
                    and tp1imp1=1 and ge.geografia_key = ps.geografia_key
                 ) tot_analistas,
                 (select count(distinct analista_key) 
                    from tmp_fact_pasivo_prodinc_res  
                   Where ind_tipmet = 2 and tiempo_key = ln_tieuno
                     and fec_saldo = PD_FECHA
                     and geografia_key = ps.geografia_key
                     and ind_regcap = 1
                     and nvl(ind_logtod,0) = 1
                 ) num_anacap  
           From tmp_fact_pasivo_prodinc_metas ps
           Join dwhouse.dm_geografia ge on ge.geografia_key = ps.geografia_key
          Where ind_tipmet = 9
            and ge.tipo_region = 'R'
            and ge.codigo_agencia <> '904'
          Group by ps.tiempo_key,ps.geografia_key,ps.fec_saldo,ge.codigo_zona,ge.nombre_zona,
                   ge.codigo_region,ge.nombre_region;
    Commit;
    -- Actualiza Metas
    For x In c_metas(ln_tieuno) Loop
        Update tmp_fact_pasivo_prodinc_res rs
           set imp_metaho = nvl(x.imp_meta,0)
         Where rs.geografia_key = x.geografia_key
           and rs.ind_tipmet = 90
           and rs.tiempo_key = ln_tiempo;      
    End Loop;
    Commit;
    
    -- Zonas
    Insert Into tmp_fact_pasivo_prodinc_res
                (tiempo_key,cod_zona,des_zona,ind_tipmet,fec_saldo,
                 imp_metaho,imp_basaho,imp_avaaho,por_logaho)
         Select tiempo_key,cod_zona,des_zona,91,fec_saldo,
                sum(imp_metaho),sum(imp_basaho),sum(imp_avaaho),
                case when sum(imp_metaho) <> 0 Then sum(imp_avaaho)/sum(imp_metaho) else 0 end
           From tmp_fact_pasivo_prodinc_res
          Where ind_tipmet = 90
            and tiempo_key = ln_tiempo
          Group By tiempo_key,cod_zona,des_zona,fec_saldo;                
    Commit;             
                 
    -- Regiones 
    Insert Into tmp_fact_pasivo_prodinc_res
                (tiempo_key,cod_region,des_region,ind_tipmet,fec_saldo,
                 imp_metaho,imp_basaho,imp_avaaho,por_logaho)
         Select tiempo_key,cod_region,des_region,92,fec_saldo,
                sum(imp_metaho),sum(imp_basaho),sum(imp_avaaho),
                case when sum(imp_metaho) <> 0 Then round(sum(imp_avaaho)/sum(imp_metaho),8) else 0 end
           From tmp_fact_pasivo_prodinc_res
          Where ind_tipmet = 90
            and tiempo_key = ln_tiempo
          Group By tiempo_key,cod_region,des_region,fec_saldo;                
    Commit;     
    
    --- Logros y Pagos
    Update tmp_fact_pasivo_prodinc_res m
       set m.ind_logtod = (case when nvl(m.por_logaho,0) >= ln_minzon Then 1 else 0 end),
           m.imp_pagmes = (case when nvl(m.por_logaho,0) >= ln_minzon Then ln_pagzon else 0 end)
     Where ind_tipmet = 91
       and tiempo_key = ln_tiempo;  
    Commit;
    
    Update tmp_fact_pasivo_prodinc_res m
       set m.ind_logtod = (case when nvl(m.por_logaho,0) >= ln_minreg Then 1 else 0 end),
           m.imp_pagmes = (case when nvl(m.por_logaho,0) >= ln_minreg Then ln_pagreg else 0 end)
     Where ind_tipmet = 92
       and tiempo_key = ln_tiempo;  
    Commit;     

    Update tmp_fact_pasivo_prodinc_res m
       set m.ind_logtod = (case when nvl(m.por_logaho,0) >= ln_minage  
                                 and decode(nvl(m.imp_avacts,0),0,0,nvl(m.imp_avadpf,0)/nvl(m.imp_avacts,0)) >= ln_porana
                                Then 1 else 0 end),
           m.imp_pagmes = (case when nvl(m.por_logaho,0) >= ln_minage  
                                 and decode(nvl(m.imp_avacts,0),0,0,nvl(m.imp_avadpf,0)/nvl(m.imp_avacts,0)) >= ln_porana
                                Then ln_pagage else 0 end),
           m.por_logdpf = (case when nvl(m.imp_avacts,0) = 0 then 0 else round(nvl(m.imp_avadpf,0)/nvl(m.imp_avacts,0),8) end)                       
     Where ind_tipmet = 90
       and tiempo_key = ln_tiempo;  
    Commit;
    
  END SP_INC_RESULTADOS_AGE;
  ----------------------------------------------------------------------------------------
  PROCEDURE SP_REGISTRO_CLIENTES(PD_FECHA In Date)
  IS
    ld_feccon date := PD_FECHA;
    ld_inimes date := to_date(to_char(ld_feccon,'rrrrmm')||'01','rrrrmmdd');
      
  BEGIN
      Execute Immediate 'Truncate table TMP_AGECOM';
      Execute Immediate 'INSERT INTO dwstage.TMP_AGECOM(FECEVA,USUREG,NPAIS,NTDOC,VNDOC,VOBSE,FECPRO) '||
                        'Select to_date(to_char(aqpa134fer,''rrrrmmdd'')||'' ''||aqpa134hor,''rrrrmmdd hh24:mi:ss'') fecha,'||
                              'trim(aqpa134usr),'||
                              'decode(aqpb508pain,null,aqpa134pai,aqpb508pain),'||
                              'decode(aqpb508ptdn,null,aqpa134tpo,aqpb508ptdn),'||
                              'decode(aqpb508docn,null,aqpa134num,rpad(aqpb508docn,12,'' '')) ,'||
                              'aqpa134est,'||
                              'to_date(to_char(aqpa134fer,''rrrrmmdd'')||'' ''||aqpa134hor,''rrrrmmdd hh24:mi:ss'') '||
                         'From aqpa134@produ a '||
                         'LEFT JOIN dwextra.aqpb508 r '||  
                         'on r.aqpb508paio = a.aqpa134pai '|| 
                           'and r.aqpb508ptdo= a.aqpa134tpo '|| 
                           'and r.aqpb508doco= trim(a.aqpa134num) '|| 
                           'and r.aqpb508fcho= a.aqpa134fer '|| 
                           'and r.aqpb508est = ''V'' '||
                        'Where aqpa134fer between :1 and :2 '||
                          'and aqpa134est = ''P'' '
         Using ld_inimes,ld_feccon;
      If ld_feccon <= to_date('20220630','rrrrmmdd') Then
         Execute Immediate 'INSERT INTO TMP_AGECOM(FECEVA,USUREG,NPAIS,NTDOC,VNDOC,VOBSE,FECPRO) '||
                           'Select eva.dfeceva,eva.cusuing,eva.npaicli,eva.ntipdoc,eva.cnumdoc,'||
                                  'trim(upper(replace(rev.cobserv,'' '','''')))||'' (AC)'' cobserv,sysdate '||
                             'From agecom.acdeval@produ eva '||
                             'Join agecom.acdrevi@produ rev on '||
                                  'rev.npaicli = eva.npaicli '||
                               'and rev.ntipdoc = eva.ntipdoc '||
                               'and rev.cnumdoc = eva.cnumdoc '||
                               'and rev.ncodact = eva.ncodact '||
                               'and rev.ncodbas = eva.ncodbas '||
                             'where eva.ncodact = 1 '||
                               'and eva.ncodbas = 5 '||
                               'and trunc(eva.dfeceva) between :1 and :2 '||
                               'and rev.cobserv is not null '||
                               'and trim(upper(replace(rev.cobserv,'' '',''''))) in (''P'',''PC'',''CP'',''P.C'',''C.P'',''C-P'',''P-C'') '||
                               'UNION ALL '||
                           'Select eva.dfeceva,eva.cusuing,eva.npaicli,eva.ntipdoc,eva.cnumdoc,'||
                                  'trim(upper(replace(rev.cobserv,'' '','''')))||'' (AC)'' cobserv,sysdate '||
                             'From agecom.acdeval@produ eva '||
                             'Join agecom.achrevi@produ rev on '||
                                  'rev.npaicli = eva.npaicli '||
                              'and rev.ntipdoc = eva.ntipdoc '||
                              'and rev.cnumdoc = eva.cnumdoc '||
                              'and rev.ncodact = eva.ncodact '||
                              'and rev.ncodbas = eva.ncodbas '||
                            'Where eva.ncodact = 1 '||
                              'and eva.ncodbas = 5 '||
                              'and trunc(eva.dfeceva) between :3 and :4 '||
                              'and rev.cobserv is not null  '||
                              'and trim(upper(replace(rev.cobserv,'' '',''''))) in (''P'',''PC'',''CP'',''P.C'',''C.P'',''C-P'',''P-C'') '
           Using ld_inimes,ld_feccon,ld_inimes,ld_feccon;
           Commit;
                 
           Execute Immediate 'INSERT INTO TMP_AGECOM(FECEVA,USUREG,NPAIS,NTDOC,VNDOC,VOBSE,FECPRO) '||
                   'Select distinct to_date(to_char(p.jaql108fch,''rrrrmmdd'')||'' ''||trim(p.jaql108a04),''rrrrmmdd hh24:mi:ss''),'||
                          'trim(p.jaql108usu),'||
                          'decode(aqpb508pain,null,p.jaql108pai,aqpb508pain) jaql108pai,'||
                          'decode(r.aqpb508ptdn,null,p.jaql108ptd,r.aqpb508ptdn) jaql108ptd,'||
                          'decode(r.aqpb508docn,null,p.jaql108doc,rpad(r.aqpb508docn,12,'' '')) jaql108doc,'||
                          '''HA'',to_date(to_char(p.jaql108fch,''rrrrmmdd'')||'' ''||trim(p.jaql108a04),''rrrrmmdd hh24:mi:ss'') '||
                    'From dwextra.jaql108 p '||        
               'Left Join dwextra.aqpb508 r '||   
                      'on r.aqpb508paio = p.jaql108pai '||
                     'and r.aqpb508ptdo= p.jaql108ptd '||
                     'and r.aqpb508doco= trim(p.jaql108doc) '||
                     'and r.aqpb508fcho= p.jaql108fch '||
                     'and r.aqpb508est = ''V'' '||
                   'Where jaql108fch between :1 and :2'
           Using ld_inimes,ld_feccon;
           Commit;
           
           
           -- Solicitud Karolina 31/Ene/2023 No considerar el DNI 06744336 de EQUIROZ 
           If to_char(ld_feccon,'rrrrmm') = '202301' Then
              Begin
                  Delete from TMP_AGECOM where trim(vndoc) = '06744336' and usureg = 'EQUIROZ';
                  Commit;
              Exception When Others Then
                  Null;      
              End;
           End If;
      End If;    
      
       -- Solicitud de Lorena y aprobado por Karolina 30/11/2023
       -- Error de ejecutivos al registras la captacion de clientes
       If to_char(ld_feccon,'rrrrmm') = '202311' Then
          Update TMP_AGECOM set usureg = 'VGUZMANM' 
          where trim(vndoc) in ('08569510','06685046') and usureg = 'GCHAVARRY';
          Commit;
          
          Delete from TMP_AGECOM where trim(vndoc) = '29533565' 
             and usureg = 'CVIZCARRA';
          Commit;
       End If;     
       
       -- Solicitud Karolina 28/02/2024 para productivida de febrero
       If to_char(ld_feccon,'rrrrmm') = '202402' Then
           Update TMP_AGECOM set usureg = 'APERRY' 
           where trim(vndoc) in ('02368160','02368386') and usureg = 'KDIAZMI';
           Commit;
           
           -- Solicitud Karolina 28/02/2024 eliminar los clientes 
           Delete from dwstage.tmp_agecom 
            where trim(vndoc) in ('29524941','42749017','00799332','07705159');
           Commit;
       End If;
       
       --- Solicitu Karolina 31/03/2024 para productivida marzo 2024
       If to_char(ld_feccon,'rrrrmm') = '202403' Then
          -- Cambio por actualización de nro y tipo de documento 
          Update TMP_AGECOM d
             set d.ntdoc = 9,
                 d.vndoc = '20612317721'
          Where usureg = 'KLEDESMA'        
            and trim(vndoc) = '22174';
          Commit;  
          -- Eliminar registro de cliente por error de ejecutivo
          Delete from TMP_AGECOM
          Where trim(vndoc) = '20600793935'
          and usureg = 'CVIZCARRA';
          Commit; 
          
       End If;
       
       --- Solicitu Lorena 31/07/2024 para productivida Julio 2024  
       If to_char(ld_feccon,'rrrrmm') = '202407' Then
          -- Eliminar registro de cliente por error de ejecutivo
          Delete from TMP_AGECOM
          Where trim(vndoc) = '29448076'
          and usureg = 'APERRY';
          Commit;          
       End If;       

  END SP_REGISTRO_CLIENTES;                    
  ----------------------------------------------------------------------------------------  
  PROCEDURE SP_INC_SALDOMETA_AGEN(PD_FECHA in Date,PD_FECMET out Date, PN_INDMET out Number)
  IS
     ld_fecha  date := PD_FECHA;
     ld_inifec date ;
     ld_inibas date;
     ln_meses  number(3);
     ln_numtri number(3);
  Begin
     ld_inifec := to_date(to_char(ld_fecha,'rrrrmm')||'01','rrrrmmdd');
     PN_INDMET := 0;
     -- Mes Base de productividad
     If to_char(ld_fecha,'rrrr') = '2022' Then
        ld_inibas := to_date('20220301','rrrrmmdd');
     Else
        ld_inibas := to_date(to_char(to_number(to_char(ld_fecha,'rrrr'),'9999')-1)||'1201','rrrrmmdd');
     End If;
     -- Revisar trimestre
     ln_meses  := months_between(ld_inifec,ld_inibas);
     ln_numtri := trunc(ln_meses/3,0);
     If mod(ln_meses,3) = 0 Then
        ln_numtri := ln_numtri - 1;
     End If;
     ln_numtri := ln_numtri * 3;
     ld_inibas := add_months(ld_inibas,ln_numtri);
   
     If months_between(ld_inifec,ld_inibas) = 1 Then
        PN_INDMET := 1;
     End If;
     IF PN_INDMET = 1 THEN
        PD_FECMET :=  ld_inibas;
     ELSE
        PD_FECMET := to_Date(to_char(add_months(ld_inibas,1),'rrrrmm')||'01','rrrrmmdd');
     END IF;    
     --PD_FECMET := to_date(to_char(add_months(ld_fecha,-1),'rrrrmm')||'01','rrrrmmdd');
  End SP_INC_SALDOMETA_AGEN;
  ----------------------------------------------------------------------------------------  
  PROCEDURE SP_INC_INSSDOMET_AGE(PD_FECHA In DATE)
  IS
       ld_fecha  date := PD_FECHA;
       ld_mesan  date := last_day(add_months(ld_fecha,-1));
       ld_fecmet date;
       ln_indmet number(1);
       ln_existe number(10);
       ln_perant number(8);
       ln_period number(8);
  Begin
       PQ_TMP_PRODUCTIVIDADASE.SP_INC_SALDOMETA_AGEN(ld_fecha,ld_fecmet,ln_indmet);
       ln_period := to_number(to_char(ld_fecha,'rrrrmm'),'999999');
       ln_perant := to_number(to_char(ld_fecmet,'rrrrmm'),'999999');
       
       -- Revisa si existen registros para el periodo
       Select count(*) Into ln_existe
         From DWEXTRA.fst198 x Where x.tp1cod1=10819 and x.tp1corr1=304 and x.tp1corr3 = ln_period;
   
       If ln_existe = 0 Or (ln_existe > 0 and to_number(to_char(ld_fecha,'dd')) <= 25) Then
          If ln_indmet = 0 Then
             If ln_existe > 0 Then
                Delete From DWEXTRA.fst198 x Where x.tp1cod1=10819 and x.tp1corr1=304 and x.tp1corr3 = ln_period;
                Commit;
             End If;
         
             Begin
                   Insert Into DWEXTRA.fst198(TP1COD,TP1COD1,TP1CORR1,TP1CORR2,TP1CORR3,TP1DESC,TP1IMP1,TP1IMP2,TP1IMP3,TP1NRO1)
                          Select x.tp1cod,x.tp1cod1,x.tp1corr1,x.tp1corr2,ln_period,
                                'Saldo Meta '||ln_period tp1desc,
                                nvl(x.tp1imp1,0) + nvl(i.tp1imp1,0),
                                nvl(x.tp1imp2,0) + nvl(i.tp1imp2,0),
                                nvl(x.tp1imp3,0) + nvl(i.tp1imp3,0),
                                x.tp1nro1
                           From DWEXTRA.fst198 x 
                           Left Join DWEXTRA.fst198 i 
                             on i.tp1cod = x.tp1cod     and i.tp1cod1 = x.tp1cod1 
                            and i.tp1corr2 = x.tp1corr2 and i.tp1corr3 = x.tp1corr3 
                            and i.tp1corr1 = 301
                          Where x.tp1cod1=10819 and x.tp1corr1=304 
                            and x.tp1corr3 = to_number(to_char(ld_mesan,'rrrrmm'));--ln_perant;
                    Commit;
              Exception When Others Then
                Null;
              End;
          Else
              If ln_existe = 0 Then
                 Insert Into DWEXTRA.fst198(TP1COD,TP1COD1,TP1CORR1,TP1CORR2,TP1CORR3,TP1DESC,TP1IMP1,TP1IMP2,TP1IMP3)
                 Select 1,10819,304,to_number(ge.codigo_Agencia),ln_period,'Saldo Met Inicio TRIM '||trim(to_char(ln_period)),
                        sum(case when pr.codigo_producto = '21' then ps.saldo_mn else 0 end),
                        sum(case when pr.codigo_producto = '22' then ps.saldo_mn else 0 end),
                        sum(case when pr.codigo_producto = '211' then ps.saldo_mn else 0 end)   
                   From dwhouse.fact_pasivo ps
                   Join dwhouse.dm_tiempo tm on tm.tiempo_key = ps.tiempo_key
                   Join dwhouse.dm_geografia ge on ge.geografia_key = ps.geografia_key
                   Join dwhouse.dm_producto pr on pr.producto_key = ps.producto_key
                  Where tm.fecha = last_day(ld_fecmet)
                    and ps.estado_key <> 72
                    and ge.tipo_region = 'R'
                    --and not exists (select 1 from tmp_
                    group by to_number(ge.codigo_Agencia);  
              End If;      
          End If; 
       End If;     
       
       --- INSERTAR AGENCIAS NUEVAS SIN METAS
       IF ln_existe > 0 THEN 
          BEGIN
              Insert Into DWEXTRA.fst198(TP1COD,TP1COD1,TP1CORR1,TP1CORR2,TP1CORR3,TP1DESC,TP1IMP1,TP1IMP2,TP1IMP3,TP1NRO1)
                       Select 1,10819,304,to_number(ge.codigo_Agencia),ln_period,'Saldo Met Inicio TRIM '||trim(to_char(ln_period)),
                              sum(case when pr.codigo_producto = '21' then ps.saldo_mn else 0 end),
                              sum(case when pr.codigo_producto = '22' then ps.saldo_mn else 0 end),
                              sum(case when pr.codigo_producto = '211' then ps.saldo_mn else 0 end),
                              to_number(to_char(ld_mesan,'rrrrmmdd')) 
                         From dwhouse.fact_pasivo ps
                         Join dwhouse.dm_tiempo tm on tm.tiempo_key = ps.tiempo_key
                         Join dwhouse.dm_geografia ge on ge.geografia_key = ps.geografia_key
                         Join dwhouse.dm_producto pr on pr.producto_key = ps.producto_key
                        Where tm.fecha = last_day(ld_mesan)
                          and ps.estado_key <> 72
                          and ge.tipo_region = 'R'
                          and not exists(select 1 From DWEXTRA.fst198 x Where x.tp1cod1=10819 and x.tp1corr1=304 and x.tp1corr3 =ln_period
                                       and x.tp1corr2 = to_number(ge.codigo_agencia))
                     group by to_number(ge.codigo_Agencia),to_number(to_char(ld_mesan,'rrrrmmdd')) ; 
              Commit;       
           EXCEPTION WHEN OTHERS THEN
               Null;
           END;       
        END IF;
  END SP_INC_INSSDOMET_AGE;
  ----------------------------------------------------------------------------------------  
  FUNCTION FN_CARGO(PV_CODUSU In Varchar2,PN_PERIOD In Number) RETURN Varchar2
  IS
    lv_usureg Varchar2(20) := trim(PV_CODUSU);
    ln_perdia Number(8) := PN_PERIOD;
    ln_regana Number(10);
    ln_tipo   varchar2(10);
  BEGIN
       -- REVISAR SI ES EJECUTIVO / ANALISTA / 
       Select count(*) Into ln_regana from DWEXTRA.fst198 
        Where tp1cod1=10819 and tp1corr1=302 and tp1corr3 = ln_perdia
          and trim(tp1desc) = lv_usureg;
       
       If ln_regana > 0 Then
          ln_tipo := 'ANALISTA';
       Else    
          --- Buscar si es Ejecutivo
          Select count(*) Into ln_regana from dwhouse.dm_asesor
            where codigo_asesor  = lv_usureg;
          
          If ln_regana > 0 Then  
             ln_tipo := 'EJECUTIVO';
          Else
                 -- Buscar si es asesor comercial
                 select count(*) Into ln_regana
                  from prfu00@produ where trim(ubuser) = lv_usureg 
                   and PRFGCOD like 'PCRE%';
                 
                 If ln_regana > 0 Then
                    ln_tipo := 'ASECOM';
                 Else
                    ln_tipo := 'AENCIA';
                 End If;   
          End If;
      End If;
      Return ln_tipo;
  END FN_CARGO;    
  ----------------------------------------------------------------------------------------  
  FUNCTION FN_TIPO_ANALISTA(PN_PAIS In Number, PN_TDOC In Number, 
                            PV_NUMDOC In Varchar2, PD_FECHA In Date)
  Return Number
  Is
    ln_tipana number(5);
  Begin  
       Begin
           IF PD_FECHA = last_day(PD_FECHA) and to_number(to_char(PD_FECHA,'rrrrmm')) < to_number(to_char(trunc(sysdate-1),'rrrrmm')) 
           THEN
               Execute Immediate '
               Select tipana 
                 From (
                       Select case when upper(an.de_pues_trab) like ''%SENIOR%EXPERTO%'' then 9
                                   when upper(an.de_pues_trab) like ''%AVANZADO%EXPERTO%'' then 5
                                   when upper(an.de_pues_trab) like ''%AVANZADO%SUPERIOR%'' then 4
                                   when upper(an.de_pues_trab) like ''%AVANZADO%'' and upper(an.de_pues_trab) not like ''%SUPERIOR%'' and 
                                        upper(an.de_pues_trab) not like ''%EXPERTO%'' then 6
                                   when upper(an.de_pues_trab) like ''%SUPERIOR%'' and upper(an.de_pues_trab) not like ''%AVANZADO%'' and 
                                        upper(an.de_pues_trab) not like ''%SENIOR%'' then 1 
                                   when upper(an.de_pues_trab) like ''%MASTER%'' then 2   
                                   when upper(an.de_pues_trab) like ''%EXPERTO%'' and upper(an.de_pues_trab) not like ''%AVANZADO%'' and 
                                        upper(an.de_pues_trab) not like ''%SENIOR%'' then 3
                                   when upper(an.de_pues_trab) like ''%SENIOR%'' and upper(an.de_pues_trab) not like ''%AVANZADO%'' and 
                                        upper(an.de_pues_trab) not like ''%EXPERTO%'' then 7
                                   when upper(an.de_pues_trab) like ''%JUNIOR%'' or upper(an.de_pues_trab) like ''%FORMACION%'' then 8
                                   when upper(an.de_pues_trab) like ''ANALISTA%CR_DITO'' or upper(an.de_pues_trab) like ''ANALISTA%CR_DITOS'' then 8  
                                   else null
                               end tipana
                              from dwbkext.v_anexo17a_'||to_char(PD_FECHA,'rrrrmmdd')||' an
                             Where to_date(an.fe_ingr_emp,''rrrr.mm.dd'') <= :1
                               and (an.emp_estado = ''ACTIVO''
                                    OR  an.emp_estado = ''CESADO'' and to_date(an.fe_cese_trab,''rrrr.mm.dd'') > :2
                                   )
                               and an.pais = :3 
                               and an.tipodoc = :4
                               and trim(an.nu_docu_iden) = trim(:5) 
                             Order by to_date(an.fe_ingr_emp,''rrrr.mm.dd'') desc
                      )
                 Where rownum = 1'
                 Into ln_tipana Using PD_FECHA,PD_FECHA,PN_PAIS,PN_TDOC,PV_NUMDOC;      
           ELSE    
               Select tipana Into ln_tipana
                 From (
                       Select case when upper(an.de_pues_trab) like '%SENIOR%EXPERTO%' then 9
                                   when upper(an.de_pues_trab) like '%AVANZADO%EXPERTO%' then 5
                                   when upper(an.de_pues_trab) like '%AVANZADO%SUPERIOR%' then 4
                                   when upper(an.de_pues_trab) like '%AVANZADO%' and upper(an.de_pues_trab) not like '%SUPERIOR%' and 
                                        upper(an.de_pues_trab) not like '%EXPERTO%' then 6
                                   when upper(an.de_pues_trab) like '%SUPERIOR%' and upper(an.de_pues_trab) not like '%AVANZADO%' and 
                                        upper(an.de_pues_trab) not like '%SENIOR%' then 1 
                                   when upper(an.de_pues_trab) like '%MASTER%' then 2   
                                   when upper(an.de_pues_trab) like '%EXPERTO%' and upper(an.de_pues_trab) not like '%AVANZADO%' and 
                                        upper(an.de_pues_trab) not like '%SENIOR%' then 3
                                   when upper(an.de_pues_trab) like '%SENIOR%' and upper(an.de_pues_trab) not like '%AVANZADO%' and 
                                        upper(an.de_pues_trab) not like '%EXPERTO%' then 7
                                   when upper(an.de_pues_trab) like '%JUNIOR%' or upper(an.de_pues_trab) like '%FORMACION%' then 8
                                   when upper(an.de_pues_trab) like 'ANALISTA%CR_DITO' or upper(an.de_pues_trab) like 'ANALISTA%CR_DITOS' then 8  
                                   else null
                               end tipana
                               
                              from dwextra.v_anexo17a an
                             Where to_date(an.fe_ingr_emp,'rrrr.mm.dd') <= PD_FECHA
                               and (an.emp_estado = 'ACTIVO'
                                    OR  an.emp_estado = 'CESADO' and to_date(an.fe_cese_trab,'rrrr.mm.dd') > PD_FECHA
                                   )
                               and an.pais = PN_PAIS 
                               and an.tipodoc = PN_TDOC
                               and trim(an.nu_docu_iden) = trim(PV_NUMDOC) 
                             Order by to_date(an.fe_ingr_emp,'rrrr.mm.dd') desc
                      )
                 Where rownum = 1;        
             END IF;     
      Exception When Others Then
         ln_tipana := Null;
      End;
      Return ln_tipana;
  End FN_TIPO_ANALISTA;  
  -----------------------------------------------------------------------------
  FUNCTION FN_CODAGE_ANALISTA(PN_PAIS In Number, PN_TDOC In Number, 
                              PV_NUMDOC In Varchar2, PD_FECHA In Date,
                              PN_CODAGE In Number)
  Return Number
  Is
    ln_codage number(5);
    lv_desage varchar2(100);
    ln_tipana number(5);
  Begin  
       Begin
           Select desage Into lv_desage
             From (
                   SElect trim(replace(upper(an.de_unid),'AGENCIA','')) desage
                   from dwextra.v_anexo17a an
                   Where to_date(an.fe_ingr_emp,'rrrr.mm.dd') <= PD_FECHA
                     and (an.emp_estado = 'ACTIVO'
                          OR  an.emp_estado = 'CESADO' and to_date(an.fe_cese_trab,'rrrr.mm.dd') > PD_FECHA
                         )
                     and an.pais = PN_PAIS 
                     and an.tipodoc = PN_TDOC
                     and trim(an.nu_docu_iden) = trim(PV_NUMDOC) 
                   Order by to_date(an.fe_ingr_emp,'rrrr.mm.dd') desc
                  )
             Where rownum = 1;             
      Exception When Others Then
         ln_tipana := Null;
      End;
      
      -- CODIGO DE AGENCIA
      Begin
      Execute Immediate 'Select to_number(ge.codigo_agencia) '||
                          'From dwhouse.dm_geografia ge '||
                         'Where ge.tipo_region = ''R'' '||
                           'and ge.nombre_agencia like ''%'||lv_desage||'%'''
      Into ln_codage;                     
      Exception When Others Then
         ln_codage := null;
      End;    
      Return nvl(ln_codage,PN_CODAGE);
  End FN_CODAGE_ANALISTA;  
  -----------------------------------------------------------------------------
  PROCEDURE SP_INC_RETENCION_V2023(PD_FECHA In Date)
  --- Fecha: 2023.04.20
  --- Autor: Paola Vargas
  --- Uso  : Nueva metodologia de incentivos para negocios (analistas/asesores)
  IS
    Cursor c_sdo
        is select t.cuenta_key, t.tiempo_key from TMP_FACT_PASIVO_PRODINC t;
    
    ld_mesant date := to_date(to_char(add_months(PD_FECHA,-1),'rrrrmm')||'01','rrrrmmdd');
    ln_tieant number(10) := dwhouse.pq_carga_facts.fn_tiempo_key(ld_mesant);
    ld_fecha  date := PD_FECHA;
    ln_tiepk number(10) := dwhouse.pq_carga_facts.fn_tiempo_key(ld_fecha);
    ln_saldo number(12,2);
    ln_period number(8) := to_number(to_char(ld_mesant,'rrrrmm'),999999);
    ln_perant number(8) := to_number(to_char(add_months(ld_mesant,-1),'rrrrmm'),999999);
    ld_fecsdo date;
    
    -- Analistas
    Cursor c_ana
        is Select distinct a.codigo_analista,k.analista_key
             From TMP_FACT_PASIVO_PRODINC k
             Join dwhouse.dm_analista a 
               on a.analista_key = k.analista_key
            Where ind_tipinc = 2;
              
    --- Pago
    Cursor c_resana 
            is Select tiempo_key,analista_key,geografia_key,des_tipana,fec_saldo,ind_tipmet,fec_sldren,
                      sum(nvl(AHO_C,0)) ahoava,sum(nvl(DPF_C,0)) dpfava,
                      sum(nvl(AHO_R,0)) ahoret,sum(nvl(DPF_R,0)) dpfret
                      from
                      (
               Select dat.*,
                      case when imp_capclit <= 0 Then 0
                           when imp_capclit > 0 and  aho <= 0 then 0  
                           when imp_capclit > 0 and  aho > 0 and dpf <= 0 then imp_capclit 
                           else aho 
                       end AHO_C, 
                      case when imp_capclit <= 0 Then 0
                           when imp_capclit > 0 and  dpf <= 0 then 0  
                           when imp_capclit > 0 and  aho <= 0 and dpf > 0 then imp_capclit 
                           else dpf
                       end DPF_C,
                        case when imp_retclit <= 0 Then 0
                           when imp_retclit > 0 and  AHOR <= 0 then 0  
                           when imp_retclit > 0 and  AHOR > 0 and DPFR <= 0 then imp_retclit 
                           else AHOR 
                       end AHO_R, 
                      case when imp_retclit <= 0 Then 0
                           when imp_retclit > 0 and  DPFR <= 0 then 0  
                           when imp_retclit > 0 and  AHOR <= 0 and DPFR > 0 then imp_retclit 
                           else DPFR
                       end DPF_R         
                 From (
               select tiempo_key,analista_key,
                      (case when ind_tipmet = 7 then 86 else  geografia_key end) geografia_key,des_tipana,fec_saldo,
                      cliente_key,imp_capclit,ind_tipmet,imp_retclit,fec_sldren,
                      sum(case when codigo_producto <> '22' then imp_sdoavan - imp_sdobase else 0 end) AHO,
                      sum(case when codigo_producto = '22' then imp_sdoavan - imp_sdobase else 0 end) DPF,
                      sum(case when codigo_producto <> '22' then imp_sdorete - imp_sdobase else 0 end) AHOR,
                      sum(case when codigo_producto = '22' then imp_sdorete - imp_sdobase else 0 end) DPFR
                from dwstage.TMP_FACT_PASIVO_PRODINC_METAS where ind_tipmet in (2,7)
               group by tiempo_key,analista_key,(case when ind_tipmet = 7 then 86 else  geografia_key end),
               des_tipana,fec_saldo,cliente_key,
                        ind_tipmet,imp_capclit,imp_retclit,fec_sldren
                ) dat)
               group by tiempo_key,analista_key,geografia_key,des_tipana,fec_saldo,ind_tipmet,fec_sldren;
     
     ln_agetip number(2) := 1;   -- Cantidad de agencias por tipo
     ln_pagaho number(7,3); -- Pago ahorros negocio
     ln_pagdpf number(7,3);-- Pago DPF negocio
     
     ln_pahoas number(7,3) := 0.50; -- Pago ahorros asesores
     ln_pdpfas number(7,3) := 0.25; -- Pago DPF asesores
     ln_pahoan number(7,3) := 0.50; -- Pago ahorros analista
     ln_pdpfan number(7,3) := 0.25; -- Pago DPF analista
     ln_topase number(12,2);
     ln_topana number(12,2);
     ln_guiapr number(5) := 10819;
     
     lv_tippag varchar2(20);
     lv_motrnk varchar2(20);
     ln_pagmes number(5);
     lv_tipana varchar(20);
     ln_existe number(5);
  Begin
     -----------------------------------
     --- Porcentaje de pago de asesores 
     -----------------------------------
     --- Revisar si existen parametros para el periodo de cálculo
     select count(*) Into ln_existe From DWEXTRA.fst198 
      Where tp1cod1=ln_guiapr and tp1corr1 = 300 and tp1corr2 = 3 and tp1nro1 = ln_period;
     
     If ln_existe = 0 Then
        Insert into DWEXTRA.fst198(TP1COD,TP1COD1,TP1CORR1,TP1CORR2,TP1CORR3,TP1NRO1,
                                   TP1DESC,TP1IMP1,TP1IMP2,TP1IMP3,TP1NRO2)
        Select TP1COD,TP1COD1,TP1CORR1,TP1CORR2,TP1CORR3,ln_period,
               TP1DESC,TP1IMP1,TP1IMP2,TP1IMP3,TP1NRO2 
          From DWEXTRA.fst198      
         Where tp1cod1=ln_guiapr and tp1corr1 = 300 and tp1corr2 = 3 
           and tp1nro1 = ln_perant;
        Commit;          
     End If;
     
     --- Obtiene porcentajes de pago de asesores   
     Begin
         select d.tp1imp1,d.tp1imp2,d.tp1imp3 Into ln_pahoan,ln_pdpfan,ln_topana
          from DWEXTRA.fst198 d
         where tp1cod1=ln_guiapr 
           and tp1corr1 = 300 
           and tp1corr2 = 3
           and tp1corr3 = 1 -- Analistas
           and tp1nro1  = ln_period;
     Exception When Others Then
        ln_pahoan := 0.7;
        ln_pdpfan := 0.25;
        ln_topana := 1000; 
     End;   
     
     Begin
         select d.tp1imp1,d.tp1imp2,d.tp1imp3 Into ln_pahoas,ln_pdpfas,ln_topase
          from DWEXTRA.fst198 d
         where tp1cod1=ln_guiapr 
           and tp1corr1 = 300 
           and tp1corr2 = 3
           and tp1corr3 = 2 -- Asesores
           and tp1nro1  = ln_period;
     Exception When Others Then
        ln_pahoas := 0.7;
        ln_pdpfas := 0.25;
        ln_topase := 1000; 
     End;
     ------------------------------
     Execute Immediate 'truncate table TMP_FACT_PASIVO_PRODINC';
     
     Begin
         INSERT INTO TMP_FACT_PASIVO_PRODINC
               (tiempo_key, cliente_key, producto_key, geografia_key, cuenta_key, 
                empleador_key, saldo_base_mn, tiempo_sld_key, saldo_avan_mn, 
                fec_proceso, ind_finmes, ind_tipinc, cod_ejeaho, cod_anacre, 
                analista_key, imp_tragob, cod_tipage, regionop_key, imp_meta_aho, 
                imp_meta_dpf, imp_meta_cts, ind_permet, cod_opeape, des_trxape, 
                geoape_key, geoape_desc, fec_aperen, ind_tipape, cod_usuage, 
                fec_regage, imp_desemb, des_tipana, ind_anainc, ageana_key, 
                imp_bonafp_mant, imp_desemb_mant,
                cod_producto,
                fec_saldo,cod_asecre,asecre_key,
                ind_numtit,ind_regcli,fec_regcli,cod_usureg,pais,tdoc,ndoc,aocta,
                fec_sldren)
         Select x.tiempo_key, cliente_key, producto_key, geografia_key, cuenta_key, 
                empleador_key, saldo_base_mn, tiempo_sld_key, saldo_avan_mn, 
                fec_proceso, ind_finmes, ind_tipinc, cod_ejeaho, cod_anacre, 
                analista_key, imp_tragob, cod_tipage, regionop_key, imp_meta_aho, 
                imp_meta_dpf, imp_meta_cts, ind_permet, cod_opeape, des_trxape, 
                geoape_key, geoape_desc, fec_aperen, ind_tipape, cod_usuage, 
                fec_regage, imp_desemb, des_tipana, ind_anainc, ageana_key, 
                imp_bonafp_mant, imp_desemb_mant,cod_producto,fec_saldo,
                cod_asecre,asecre_key,
                ind_numtit,ind_regcli,fec_regcli,cod_usureg,pais,tdoc,ndoc,cuenta,
                PD_FECHA
           From dwhouse.fact_pasivo_prodinc x
           Join dwhouse.dm_tiempo t on t.tiempo_key = x.tiempo_key
           Where t.fecha = ld_mesant 
             and x.ind_tipinc in (2,7);
           Commit;
     Exception When Others Then
        Null;
     End;    
     
     --- Actualiza saldo a fecha de retención
     For x in c_sdo Loop
        Begin
            Select saldo_mn Into ln_saldo
              From dwhouse.fact_pasivo p
              Where p.tiempo_key = ln_tiepk
                and p.cuentas_key = x.cuenta_key; 
        Exception When Others Then
           ln_saldo := 0;
        End;  
        
        Update TMP_FACT_PASIVO_PRODINC s
           set s.saldo_reten_mn = ln_saldo,s.fec_sldren = PD_FECHA
          Where s.cuenta_key = x.cuenta_key
            and s.tiempo_key = x.tiempo_key;
        Commit;        
    End Loop;
    
    -- ACTUALIZA TIPO DE ANALISTA
    For x in c_ana Loop
        --- Busca agencia en tabla de metas
            Begin
                SElect trim(z.tp1desc)  
                  Into lv_tipana
                  From DWEXTRA.fst198 p
                  Join DWEXTRA.fst198 z 
                    on z.tp1corr2 = p.tp1nro1 and z.tp1cod1 = p.tp1cod1
                   and z.tp1corr1=303
                 Where p.tp1cod1=10819 and p.tp1corr1=302 
                   and p.tp1corr3 = ln_period 
                   and trim(p.tp1desc) = x.codigo_analista;
            Exception When Others Then
                lv_tipana := null;
            End;
            Update TMP_FACT_PASIVO_PRODINC an
               set an.des_tipana =lv_tipana
              Where an.analista_key = x.analista_key;
              Commit;
       End Loop;     
       
    -- PAGOS DE ANALISTAS Y ASESORES
    Execute Immediate 'Truncate table tmp_fact_pasivo_prodinc_metas';
    Execute Immediate 'Truncate table tmp_fact_pasivo_prodinc_res';

    Insert Into tmp_fact_pasivo_prodinc_metas
                (TIEMPO_KEY,CODIGO_PRODUCTO,GEOGRAFIA_KEY,REGIONOP_KEY,
                 IND_TIPMET,ANALISTA_KEY,DES_TIPANA,FEC_SALDO,cliente_key,
                 imp_sdobase,imp_sdoavan,imp_sdorete,fec_sldren,IMP_CAPCLIT,imp_retclit)  
          Select dat.*,
                 sum(dat.avance-dat.base) over(partition by analista_key,cliente_key) poscli,
                 sum(dat.reten-dat.base) over(partition by analista_key,cliente_key) posret
            from(      
                  Select p.tiempo_key,p.cod_producto,
                         (case when p.ind_tipinc = 7 then p.geografia_key else p.ageana_key end) ageana_key,
                         p.regionop_key,
                         p.ind_tipinc,
                         (case when p.ind_tipinc = 2 then p.analista_key else p.asecre_key end) analista_key,
                         NVL(p.des_tipana,'NO CLASIFICADO'),
                         fec_saldo,p.cliente_key,
                         sum(case when p.cod_producto <>  '22' Then
                                       Case When (nvl(p.imp_bonafp_mant,0) + nvl(p.imp_desemb_mant,0)) > nvl(p.saldo_base_mn,0) 
                                            then 0 
                                            else (nvl(p.saldo_base_mn,0) - (nvl(p.imp_bonafp_mant,0) + nvl(p.imp_desemb_mant,0)))/(nvl(p.ind_numtit,1))
                                       end
                               When p.cod_producto='22' Then
                                   case when (nvl(p.imp_bonafp_mant,0) + nvl(p.imp_desemb_mant,0)) > nvl(p.saldo_base_mn,0) 
                                   then 0 
                                   else (nvl(p.saldo_base_mn,0) - (nvl(p.imp_bonafp_mant,0) + nvl(p.imp_desemb_mant,0)))/(nvl(p.ind_numtit,1))
                                   End
                               Else 0     
                             end) base,     
                             sum(case when p.cod_producto <> '22' Then
                                      case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_avan_mn,0) 
                                           then 0 
                                       else (nvl(p.saldo_avan_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/(nvl(p.ind_numtit,1))
                                  end
                                  when p.cod_producto='22' Then
                                  case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_avan_mn,0) 
                                       then 0 
                                       else (nvl(p.saldo_avan_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/(nvl(p.ind_numtit,1))
                                  end
                          Else 0     
                          end) avance,
                          sum(case when p.cod_producto<>'22' Then
                                  case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_reten_mn,0) 
                                       then 0 
                                       else (nvl(p.saldo_reten_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/(nvl(p.ind_numtit,1))
                                  end
                                  when p.cod_producto='22' Then
                                  case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_reten_mn,0) 
                                       then 0 
                                       else (nvl(p.saldo_reten_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/(nvl(p.ind_numtit,1))
                                  end
                              Else 0     
                              end) reten,fec_sldren
                    FROM dwstage.TMP_FACT_PASIVO_PRODINC P
                    JOIN dwhouse.dm_geografia G ON G.Geografia_Key = P.Geografia_Key
                   Where p.ind_tipinc in (2,7)  --Analistas y Asesores
                     and g.tipo_region = 'R'
                   Group by p.tiempo_key,p.cod_producto,p.ageana_key,p.regionop_key,p.ind_tipinc,
                            p.analista_key,NVL(p.des_tipana,'NO CLASIFICADO'),fec_saldo,p.cliente_key,
                            (case when p.ind_tipinc = 7 then p.geografia_key else p.ageana_key end),
                            (case when p.ind_tipinc = 2 then p.analista_key else p.asecre_key end),fec_sldren  
                            )dat;  
                           
                COMMIT;
                
          ------------------------
          -- ANALISTAS Y ASESORES: RESULTADOS
          ------------------------ 
          For x in c_resana Loop
              ld_fecsdo := x.fec_saldo;
              If x.ind_tipmet = 2 Then 
                 ln_pagaho := ln_pahoan;
                 ln_pagdpf := ln_pdpfan;
              Else
                 ln_pagaho := ln_pahoas;
                 ln_pagdpf := ln_pdpfas;
              End If;    

              INSERT INTO tmp_fact_pasivo_prodinc_res
                     (tiempo_key,geografia_key,analista_key,des_tipana,fec_saldo,cod_producto,
                      imp_capdep,ind_tipmet,imp_capret,fec_sldren,imp_pagmes,ind_regcap,ind_LogTod
                     )
               Select x.tiempo_key,x.geografia_key,x.analista_key,x.des_tipana,x.fec_saldo,'21',
                      x.ahoava,x.ind_tipmet,nvl(x.ahoret,0),x.fec_sldren,
                      case when nvl(x.ahoret,0) < nvl(x.ahoava,0) then nvl(x.ahoret,0)*(ln_pagaho/100) Else nvl(x.ahoava,0)*(ln_pagaho/100) End,
                      1,0  
                 from dual
               union all
               Select x.tiempo_key,x.geografia_key,x.analista_key,x.des_tipana,x.fec_saldo,'22',
                      x.dpfava,x.ind_tipmet,nvl(x.dpfret,0),x.fec_sldren,
                      case when nvl(x.dpfret,0) < nvl(x.dpfava,0) Then nvl(x.dpfret,0)*(ln_pagdpf/100) Else nvl(x.dpfava,0)*(ln_pagdpf/100) End,
                      1,0 
                 from dual;
               Commit;       
                    
          End Loop;

          -- 2022.06.28 INSERTA ANALISTAS QUE NO CAPTARON
          Begin
              INSERT INTO tmp_fact_pasivo_prodinc_res
                         (tiempo_key,geografia_key,analista_key,fec_saldo,
                          cod_producto,imp_capdep,ind_tipmet,ind_regcap,ind_LogTod,des_tipana,
                          imp_capret,fec_sldren,imp_pagmes
                         )
                   Select ln_tieant,ge.geografia_key,an.analista_key,ld_fecsdo, 
                          '21' codpro,0,2,0,0,  
                           (SElect nvl(trim(tp1desc),'JUNIOR') 
                                            From DWEXTRA.fst198 z where tp1cod1=10819 and tp1corr1=303 
                                            and z.tp1corr2 = p.tp1nro1) tipo,
                          0,PD_FECHA,0                                    
                    From DWEXTRA.fst198 p 
                    Join dwhouse.dm_analista an on an.codigo_analista = trim(p.tp1desc)
                    Join dwhouse.dm_geografia ge on to_number(ge.codigo_agencia) = p.tp1imp2
                     and ge.tipo_region = 'R'
                   Where tp1cod1=10819 and tp1corr1=302 
                     and tp1corr3 = ln_period
                       and not exists (select 1 from tmp_fact_pasivo_prodinc_res r 
                                      where r.ind_tipmet = 2 and r.analista_key = an.analista_key);
               Commit;     
           Exception When Others Then
              Null;
           End;              
          -----------   
          
          -----------------------------------------
          --- ANALISTAS: LOGROS
          -----------------------------------------
          --- CUMPLE TODOS LOS PRODUCTOS/PAGO
          BEGIN
             Update  tmp_fact_pasivo_prodinc_res res set ind_logtod = 1
             Where ind_tipmet in (2,7)
               and exists (select 1 
                             from (select analista_key,sum(nvl(imp_capdep,0)) imp_capdep
                                     from tmp_fact_pasivo_prodinc_res
                                    where ind_tipmet in (2,7)
                                    group by analista_key
                                    having sum(nvl(imp_capdep,0)) > 0
                                  ) tab 
                            where tab.analista_key= res.analista_key);
             COMMIT;    
          EXCEPTION WHEN OTHERS THEN
              NULL;
          END;      
          
          --- PAGOS
          BEGIN
              Update tmp_fact_pasivo_prodinc_res
                 set imp_pagmes = (case when cod_producto = '21' and nvl(imp_pagmes,0) > ln_topana then ln_topana 
                                        when cod_producto = '22' and nvl(imp_pagmes,0) > ln_topana then ln_topana 
                                        else nvl(imp_pagmes,0)
                                   end) 
                Where ind_tipmet = 2;
               Commit;
                  
               Update tmp_fact_pasivo_prodinc_res
                 set imp_pagmes = (case when cod_producto = '21' and nvl(imp_pagmes,0) > ln_topase then ln_topase 
                                        when cod_producto = '22' and nvl(imp_pagmes,0) > ln_topase then ln_topase  
                                       else nvl(imp_pagmes,0)
                                    end      
                                   ) 
                Where ind_tipmet = 7; 
                Commit;                   
          EXCEPTION WHEN OTHERS THEN
              NULL;
          END;

  END SP_INC_RETENCION_V2023;
  ----------------------------------------------------------------------------------------
----------------------------------------- 
  --- PROCESO: clasifica depositos
  -----------------------------------------
  PROCEDURE SP_INC_CLASIFICA_DEP_v2023(PD_FECDIA In Date)
  IS
      PD_FECCIE date := last_day(add_months(PD_FECDIA,-1));
      ld_fecpro date := PD_FECDIA;--dwextra.pq_tmp_extrae_fuentes.fn_lee_fecha_cierre;
      ld_feimes date := to_date(to_char(PD_FECDIA,'rrrrmm')||'01','rrrrmmdd');
      ld_feiman date := to_date(to_char(PD_FECCIE,'rrrrmm')||'01','rrrrmmdd');
      ln_tiemes number := dwhouse.pq_carga_facts.fn_tiempo_key(ld_feimes);
    
      ln_tiecie number(10) := DWHOUSE.PQ_CARGA_FACTS.fn_tiempo_key(PD_FECCIE);
      ln_tiedia number(10) := DWHOUSE.PQ_CARGA_FACTS.fn_tiempo_key(PD_FECDIA);
      ln_period number(6)  := to_number(to_char(PD_FECDIA,'rrrrmm'));
      ln_peract number(6)  := to_number(to_char(ld_fecpro,'rrrrmm'));
      lv_fecdat varchar2(10);
      
      lv_ruccaja varchar2(11) := '20100209641';
      ln_empcaja number(10);
      lv_script varchar2(1000);
     
      TYPE tp_codase IS TABLE OF VARCHAR2(10);
      TYPE tp_client IS TABLE OF NUMBER(10);
      TYPE tp_codana IS TABLE OF VARCHAR2(10);
      TYPE tp_keyana IS TABLE OF NUMBER(10);
      TYPE tp_nroana IS TABLE OF NUMBER(5);
    
      lv_codase tp_codase;
      ln_client tp_client;
      lv_codana tp_codana;
      ln_keyana tp_keyana;
      ln_nroana tp_nroana;
      ln_ctakey number(10);
  
      Cursor c_gob(fini in date, ffin in date)
          is Select aqpa118amod aomod,aqpa118amda aomda,aqpa118acta aocta,
                    aqpa118aope aoope,aqpa118asbo aosbo,aqpa118atop aotop,
                    sum(MTO_TRANSF) mto_tranf
              From (
                     Select x.aqpa118apgc,
                            x.aqpa118amod,
                            x.aqpa118asuc,
                            x.aqpa118amda,
                            x.aqpa118apap,
                            x.aqpa118acta,
                            x.aqpa118aope,
                            x.aqpa118asbo,
                            x.aqpa118atop,
                            w.fch_reg ,
                            w.MTO_TRANSF,
                            w.hora_Reg,'A' tippro
                      from (Select max(x.aqpa118aseq),
                                   x.aqpa118apgc,x.aqpa118amod,
                                   x.aqpa118asuc,x.aqpa118amda,
                                   x.aqpa118apap,x.aqpa118acta,
                                   x.aqpa118aope,x.aqpa118asbo,
                                   x.aqpa118atop,x.aqpa118acci
                        from aqpa118a@produ x
                       where x.aqpa118acta > 0
                      group by x.aqpa118apgc,x.aqpa118amod,
                               x.aqpa118asuc,x.aqpa118amda,
                               x.aqpa118apap,x.aqpa118acta,
                               x.aqpa118aope,x.aqpa118asbo,
                               x.aqpa118atop,x.aqpa118acci
                       ) x,
                       jaql380@produ w
                 where w.cci_des = x.aqpa118acci
                   and w.cod_esttra = 5
                   and (w.nom_ori like '%AFP%' or w.nom_ori like '%HA%-%FONDO%' or
                        w.nom_ori like '%IN%-%FONDO%' or w.nom_ori like '%PR%-%FONDO%' or
                        w.nom_ori like 'RI')
                        
                        UNION    
               Select z.jaql72pgco,  
                      z.jaql72scmo,
                      z.jaql72scsu,              
                      z.jaql72scmd,
                      z.jaql72scpa,
                      z.jaql72scct,
                      z.jaql72scop,
                      z.jaql72scsb,
                      z.jaql72scto,
                      y.jaql71fepr,
                      z.jaql72impo,
                      y.jaql71hopr,
                      'B' tippro
                 from jaql071@produ y,
                      jaql072@produ z,
                      aqpa124@produ w 
                where y.jaql71nuim = z.jaql72nuim
                  and z.jaql72nuim = w.aqpa124imp
                  and z.jaql72ax02 = 1
                  and z.jaql72impo > 0
                  and y.jaql71esta = 'P'
                )  
           Where fch_reg between fini and ffin   
           Group By aqpa118amod,aqpa118amda,aqpa118acta,aqpa118aope,aqpa118asbo,aqpa118atop;
       
      Cursor c_clireg 
          is select * from TMP_FACT_PASIVO_CLICAP Where ind_increg = 1;
          
          lv_pendoc varchar2(12);    
  BEGIN
       Execute Immediate 'Truncate table TMP_FACT_PASIVO_PRODINC';
       
       --- CLIENTES REGISTRADOS PARA CAPTACION
       FOR x IN c_clireg LOOP
             lv_pendoc := rpad(trim(x.ndoc),12,' ');
             BEGIN
                   INSERT INTO TMP_FACT_PASIVO_PRODINC
                      (TIEMPO_KEY,PRODUCTO_KEY,GEOGRAFIA_KEY,CUENTA_KEY,EMPLEADOR_KEY,
                       Saldo_Base_Mn,Tiempo_Sld_Key,SALDO_AVAN_MN,Fec_Proceso,Ind_Finmes,Imp_Tragob,
                       Cod_Tipage,Regionop_Key,fec_saldo,cod_producto,Aocta,fec_aperen,ind_tipape,
                       des_cliente,ind_numtit,
                       -----
                       Ind_Tipinc,Cod_Ejeaho,Cod_Anacre,analista_key,ageana_key,cod_asecre,asecre_key,
                       fec_regcli,ind_regcli,pais,tdoc,ndoc,cod_usuage,CLIENTE_KEY,COD_USUREG
                      ) 
              SElect TIEMPO_KEY,inc.PRODUCTO_KEY,GEOGRAFIA_KEY,inc.CUENTA_KEY,EMPLEADOR_KEY,
                     Saldo_Base_Mn,Tiempo_Sld_Key,SALDO_AVAN_MN,Fec_Proceso,Ind_Finmes,Imp_Tragob,
                     Cod_Tipage,Regionop_Key,fec_saldo,cod_producto,Aocta,
                     nvl(ct.fecha_renovaci,ct.fecha_apertura),
                     case when inc.ind_finmes = 'N' and inc.cod_producto = '22' and ct.fecha_apertura < ld_feimes
                          then 'REN'
                          when inc.ind_finmes = 'N' and inc.cod_producto = '22' and ct.fecha_renovaci is null
                          then 'APE'
                          when inc.ind_finmes = 'N' and inc.cod_producto <> '22' then 'APE'
                          else null
                     end,         
                     PQ_TMP_PRODUCTIVIDADASE.FN_NOMBRE_CLIENTE(x.pais,x.tdoc,trim(x.ndoc)), 
                     (select count(*) From dwextra.fsr008 where ctnro = inc.aocta) nrotit
                      -------------------
                      ,x.ind_regcli,
                      decode(x.ind_regcli,3,x.cod_usureg),
                      decode(x.ind_regcli,2,x.cod_usureg),decode(x.ind_regcli,2,x.analista_key),
                      decode(x.ind_regcli,2,x.ageana_key),
                      decode(x.ind_regcli,7,x.cod_usureg),decode(x.ind_regcli,7,x.asesor_key),
                      x.fec_regcli,1,x.pais,x.tdoc,trim(x.ndoc),
                      decode(x.ind_regcli,1,x.cod_usureg),
                      x.cliente_key,x.cod_usureg
                from TMP_FACT_PASIVO_INCSALD inc
                Join dwhouse.dm_cuentas ct on ct.cuentas_key  = inc.cuenta_key
               Where exists (select 1 from dwextra.fsr008 cl 
                             where cl.pepais = x.pais and cl.petdoc=x.tdoc and cl.pendoc = lv_pendoc
                               and cl.ctnro = inc.aocta);
               COMMIT;
             EXCEPTION WHEN OTHERS THEN
                NULL;
             END;                    
         END LOOP;
         
         ---- INSERTA TODAS LAS CUENTAS DE CLIENTES QUE NO SE REGISTRARON PARA CAPTACION
         Begin
         INSERT INTO TMP_FACT_PASIVO_PRODINC
                     (TIEMPO_KEY,CLIENTE_KEY,PRODUCTO_KEY,GEOGRAFIA_KEY,CUENTA_KEY,EMPLEADOR_KEY,
                      SALDO_BASE_MN,TIEMPO_SLD_KEY,SALDO_AVAN_MN,FEC_PROCESO,ind_finmes,IND_TIPINC,
                      Regionop_Key,Ind_Anainc,imp_bonafp_mant,imp_desemb_mant,FEC_SALDO,cod_producto,
                      Aocta,ind_regcli,ind_numtit,
                      -- nuevo
                      pais,tdoc,ndoc
                     ) 
              SELECT TIEMPO_KEY,CLIENTE_KEY,sld.PRODUCTO_KEY,GEOGRAFIA_KEY,CUENTA_KEY,EMPLEADOR_KEY,
                      SALDO_BASE_MN,TIEMPO_SLD_KEY,SALDO_AVAN_MN,FEC_PROCESO,ind_finmes,IND_TIPINC,
                      Regionop_Key,Ind_Anainc,imp_bonafp_mant,imp_desemb_mant,FEC_SALDO,cod_producto,
                      Aocta,0,
                      --1
                      --nuevo
                      (select count(*) From dwextra.fsr008 where ctnro = ct.cuenta) nrotit,
                      r8.pepais,r8.petdoc,r8.pendoc
                 FROM TMP_FACT_PASIVO_INCSALD sld
                 Join dwhouse.dm_cuentas ct on ct.cuentas_key = sld.cuenta_key
                 Join dwextra.fsr008 r8 on r8.ctnro = ct.cuenta
                Where not exists (select 1 from TMP_FACT_PASIVO_PRODINC t where CUENTA_KEY = sld.cuenta_key
                                   and  t.pais = r8.pepais and t.tdoc = r8.petdoc and trim(t.ndoc) = trim(r8.pendoc)
                                 );
                /* NUEV FROM TMP_FACT_PASIVO_INCSALD sld
               WHERE not exists (select 1 from TMP_FACT_PASIVO_PRODINC where CUENTA_KEY = sld.cuenta_key);
              */
              COMMIT;
         Exception When Others Then
            Null;
         End;  
         
         -- Obtiene codigo empleador Caja Arequipa
         Begin
            Select empleador_key Into ln_empcaja From dwhouse.dm_empleador Where ruc = lv_ruccaja;
         Exception When Others Then
            ln_empcaja := Null;
         End;
     
         -- Actualiza Registros de depositos donde el Empleador es Caja Arequipa
         Update TMP_FACT_PASIVO_PRODINC Set ind_tipinc=4 Where empleador_key = ln_empcaja;
         Commit;
         
         -- Actualiza Registros de depositos donde el cliente es colaborador de Caja Arequipa
         Update TMP_FACT_PASIVO_PRODINC z Set ind_tipinc=4 
          Where exists (select 1 from dwhouse.dm_cliente where nvl(ind_colbco,'N') = 'S'
                           and cliente_key = z.cliente_key);
         Commit;
      
         --- Identificar Clientes con Ejecutivo
         Select trim(jaql61user),cl.cliente_key
          BULK COLLECT INTO lv_codase, ln_client
          From TMP_EXT_JAQL061 e
          Join dwhouse.dm_cliente cl
            on cl.pais = e.jaql61pais
           and cl.tipo_docum = e.jaql61tdoc
           and cl.numero_documento = e.jaql61ndoc  
         Where jaql61esta = 'S' 
           and (trim(jaql61user) is not null or trim(jaql61user) <> 'SIN ASESOR');
         
         For idx in 1 .. lv_codase.COUNT Loop
             Update TMP_FACT_PASIVO_PRODINC 
                Set ind_tipinc = 3,
                    cod_ejeaho  = lv_codase(idx) 
              Where cliente_key = ln_client(idx);
             Commit;       
         End Loop;  
     
         -- Depositos del Gobierno MES EN CURSO(AFP/BONO)
         For x in c_gob(ld_feimes,PD_FECDIA) Loop
                 -- Busca Cuenta_Key
                 Begin
                      Select c.cuentas_key INTO ln_ctakey
                        from dwhouse.dm_cuentas c
                        Join dwstage.tmp_dm_cuenta k
                          on k.cuenta_unica = c.cuenta_unica
                         and k.codigo_cuenta = c.codigo_cuenta
                       Where k.aomod = x.aomod
                         and k.aomda = x.aomda
                         and k.aocta = x.aocta
                         and k.aoope = x.aoope
                         and k.aosbo = x.aosbo
                         and k.aotop = x.aotop;
                 Exception When Others Then
                    ln_ctakey := Null;
                 End;
         
                 If ln_ctakey Is Not Null Then
                    Update TMP_FACT_PASIVO_PRODINC
                       set imp_tragob = x.mto_tranf
                     Where CUENTA_KEY = ln_ctakey;
                    Commit;    
                 End If;
                  
             End Loop;
     
       --- INSERTA CAPTACIONES QUE NO APERTURARON ANALISTAS
       BEGIN
            INSERT INTO TMP_FACT_PASIVO_PRODINC
                        (TIEMPO_KEY,GEOGRAFIA_KEY,Saldo_Base_Mn,Tiempo_Sld_Key,SALDO_AVAN_MN,
                         Fec_Proceso,Ind_Finmes,Imp_Tragob,fec_saldo,ind_numtit,
                         -----
                         Ind_Tipinc,Cod_Anacre,analista_key,ageana_key,cod_usureg,
                         fec_regcli,ind_regcli,pais,tdoc,ndoc,cod_usuage,CLIENTE_KEY,
                         producto_key,cuenta_key
                        )  
                        
                  Select ln_tiemes,geografia_key,0,ln_tiedia,0,trunc(sysdate),'N',0,PD_FECDIA,1,
                         ind_regcli,cod_anacre,analista_key,ageana_key,cod_usureg,
                         fec_Regcli,nvl(ind_increg,0),
                         pais,tdoc,ndoc,cod_usuage,
                         nvl(pq_tmp_carga_key.fn_cliente_key(trim(pais||tdoc||trim(ndoc))),1549761484),
                         37,1404121192
                    from TMP_FACT_PASIVO_CLICAP ca 
                   Where ind_regcli = 2
                     and not exists (select 1 from TMP_FACT_PASIVO_PRODINC where analista_key = ca.analista_key
                                      and ind_Tipinc = 2
                                      and cliente_key = ca.cliente_key); ---LINEA AGREGADA
                   Commit; 
                   
                   
       EXCEPTION WHEN OTHERS THEN
            NULL;
       END;      
       --- ASESORES: INSERTA CLIENTES QUE NO APERTURAN
        BEGIN
            INSERT INTO TMP_FACT_PASIVO_PRODINC
                        (TIEMPO_KEY,GEOGRAFIA_KEY,Saldo_Base_Mn,Tiempo_Sld_Key,SALDO_AVAN_MN,
                         Fec_Proceso,Ind_Finmes,Imp_Tragob,fec_saldo,ind_numtit,
                         -----
                         Ind_Tipinc,Cod_Anacre,analista_key,ageana_key,cod_usureg,
                         fec_regcli,ind_regcli,pais,tdoc,ndoc,cod_usuage,CLIENTE_KEY,
                         producto_key,cuenta_key,asecre_key
                        )  
                        
                  Select ln_tiemes,geografia_key,0,ln_tiedia,0,trunc(sysdate),'N',0,PD_FECDIA,1,
                         ind_regcli,cod_anacre,analista_key,ageana_key,cod_usureg,
                         fec_Regcli,nvl(ind_increg,0),
                         pais,tdoc,ndoc,cod_usuage,
                         nvl(pq_tmp_carga_key.fn_cliente_key(trim(pais||tdoc||trim(ndoc))),1549761484),
                         37,1404121192,ca.asesor_key
                    from TMP_FACT_PASIVO_CLICAP ca 
                   Where ind_regcli = 7 and ca.analista_key is null
                     and not exists (select 1 from TMP_FACT_PASIVO_PRODINC  d 
                                      where d.asecre_key = ca.asesor_key
                                      and ind_Tipinc = 7
                                      and cliente_key = ca.cliente_key
                                      ); 
                   Commit; 
       EXCEPTION WHEN OTHERS THEN
            NULL;
       END;                 
                                           
       --- Depositos con ejecutivo el mes anterior y están en agencia
       
       If ln_period = 202206 Then
          ln_tiemes := dwhouse.pq_carga_facts.fn_tiempo_key(ld_feiman);
          ld_feiman := last_day(ld_feiman);
          Update TMP_FACT_PASIVO_PRODINC p
             set p.ind_tipinc = 8       
           Where p.ind_tipinc = 1
             and exists (select 1 from dwhouse.fact_pasivo_prodinc ma
                         Where ma.cuenta_key = p.cuenta_key
                           and ma.ind_tipinc = 3
                           and ma.tiempo_key = ln_tiemes
                           and ma.fec_saldo = ld_feiman
                         );
                       
           Commit;                     
       End If;   
  END SP_INC_CLASIFICA_DEP_v2023;  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- -- --   
  PROCEDURE SP_INC_METAS_V2023(PD_FECHA In Date)
  ----------------------------------------------------------------------
  -- Fecha: 2023.04.19
  -- Autor: Paola Vargas
  -- Uso  : Metas para nueva metodologia de incentivos desde abril 2023
  ----------------------------------------------------------------------  
  IS
      ld_fmes date := PD_FECHA;
      ld_imes date := to_date(to_char(ld_fmes,'rrrrmm')||'01','rrrrmmdd');
      ln_fmes number(6) := to_number(to_char(PD_FECHA,'rrrrmm'));
      ln_exist number(5);
      lv_err varchar2(200);
      lv_script varchar2(3000);
      ln_perio number(8) := to_number(to_char(ld_fmes,'rrrrmm'));
  BEGIN
       -----------------
       -- ANALISTAS
       -----------------
       IF ld_fmes = last_day(ld_fmes) and
          trunc(sysdate-1) > ld_fmes Then
          --and to_number(to_char(ld_fmes,'rrrrmm')) < to_number(to_char(trunc(sysdate-1),'rrrrmm')) Then
           delete from DWEXTRA.fst198 where tp1cod1=10819 and tp1corr1=302 and tp1corr3 = ln_fmes;
           commit;   
           
           lv_script := 'Insert Into DWEXTRA.fst198(tp1cod,tp1cod1,tp1corr1,tp1corr2,tp1corr3, '||
                                      'tp1desc,tp1nro1,tp1nro2,tp1imp1,tp1imp2) '|| 
                'Select 1 tp1cod,10819 tp1cod1,302 tp1corr1,rownum tp1corr2, :1 tp1corr3, '||
                       'trim(s.sng057usr), '||
                       'dwstage.pq_tmp_productividadase.FN_TIPO_ANALISTA(d.jaqn002pai,d.jaqn002tdo,trim(d.jaqn002ndo),:2) tipana, '||
                       ':3 tp1nro2,  '||
                       '1 tp1imp1, '||
                       'case when ag.ubsuc = 904 then '||
                            'dwstage.pq_tmp_productividadase.FN_CODAGE_ANALISTA(d.jaqn002pai,d.jaqn002tdo,trim(d.jaqn002ndo),:4,ag.ubsuc) '||
                            'else ag.ubsuc  '||
                       'end '||  
                  'From dwbkext.sng057_'||to_char(ld_fmes,'rrrrmmdd')||' s '||
                  'Join dwbkext.fst046_'||to_char(ld_fmes,'rrrrmmdd')||' ag on ag.ubuser = s.sng057usr '||
                  'Join jaqn002@produ d on d.jaqn002usr = s.sng057usr '||
                 'Where s.sng055car in (200,201) '||
                   'and (s.sng057fin is null or s.sng057fin = ''1/01/0001'' or s.sng057fin >= :5) '||
                   'and ag.ubprd <> ''0'' '||
                   'and exists (select 1 from dwbkext.v_anexo17a_'||to_char(ld_fmes,'rrrrmmdd')||' an '||
                                'Where an.pais = d.jaqn002pai and an.tipodoc = d.jaqn002tdo and trim(an.nu_docu_iden) = trim(d.jaqn002ndo) '||
                                  'and to_date(an.fe_ingr_emp,''rrrr.mm.dd'') <= :6 '||
                                  'and (an.emp_estado = ''ACTIVO'' '||
                                  'OR  an.emp_estado = ''CESADO'' and to_date(an.fe_cese_trab,''rrrr.mm.dd'') > :7 '||
                                  ') '||
                               ')';
                   Execute Immediate lv_script Using ln_perio,ld_fmes,ln_perio,ld_fmes,ld_fmes,ld_fmes,ld_fmes;  
               
       ELSE 
           delete from DWEXTRA.fst198 where tp1cod1=10819 and tp1corr1=302 and tp1corr3 = ln_fmes;
           commit;   
          
           Insert Into DWEXTRA.fst198(tp1cod,tp1cod1,tp1corr1,tp1corr2,tp1corr3,
                                      tp1desc,tp1nro1,tp1nro2,tp1imp1,tp1imp2) 
                Select 1 tp1cod,10819 tp1cod1,302 tp1corr1,rownum tp1corr2, ln_perio tp1corr3,
                       trim(s.sng057usr),
                       dwstage.pq_tmp_productividadase.FN_TIPO_ANALISTA(d.jaqn002pai,d.jaqn002tdo,trim(d.jaqn002ndo),ld_fmes) tipana,
                       ln_perio tp1nro2, 
                       1 tp1imp1,
                       case when ag.ubsuc = 904 then
                            dwstage.pq_tmp_productividadase.FN_CODAGE_ANALISTA(d.jaqn002pai,d.jaqn002tdo,trim(d.jaqn002ndo),ld_fmes,ag.ubsuc)
                            else ag.ubsuc 
                       end  
                  From sng057@produ s 
                  Join fst046@produ ag on ag.ubuser = s.sng057usr
                  Join jaqn002@produ d on d.jaqn002usr = s.sng057usr
                 Where s.sng055car in (200,201)
                   and ag.ubprd <> '0'
                   and (s.sng057fin is null or s.sng057fin = '1/01/0001' or s.sng057fin = ld_fmes)
                   and exists (select 1 from dwextra.v_anexo17a an
                                Where an.pais = d.jaqn002pai and an.tipodoc = d.jaqn002tdo and trim(an.nu_docu_iden) = trim(d.jaqn002ndo)
                                  and to_date(an.fe_ingr_emp,'rrrr.mm.dd') <= ld_fmes
                                  and (an.emp_estado = 'ACTIVO'
                                  OR  an.emp_estado = 'CESADO' and to_date(an.fe_cese_trab,'rrrr.mm.dd') > ld_fmes
                                  )
                               );  
       END IF;
       
       -----------------
       -- METAS AGENCIAS
       -----------------
       select count(*) Into ln_exist from DWEXTRA.fst198 where tp1cod1=10819 and tp1corr1=301 and tp1corr3 = ln_fmes;
       If ln_exist > 0 Then
          delete from DWEXTRA.fst198 where tp1cod1=10819 and tp1corr1=301 and tp1corr3 = ln_fmes;
          commit;
       End If;
       
       Begin
            Insert Into DWEXTRA.fst198(tp1cod,tp1cod1,tp1corr1,tp1corr2,tp1corr3,tp1desc,tp1imp1,tp1imp2,tp1imp3)
            SELECT tpcod,tp1cod1,tp1corr1,cod_sucurs,periodo,tipsuc,"'21'" metaho,"'22'" metdpf, "'211'" metcts
              FROM
               (
                   Select 1 tpcod, 10819 tp1cod1, 301 tp1corr1,
                          g.cod_sucurs,t.periodo, r.codigo_producto,nvl(c.tipsuc,'D') tipsuc, sum(a.meta_saldo_mn) meta_mn
                     From dwhouse.fact_pasivo_meta_agencia a
                     Join dwhouse.dm_tiempo t on t.tiempo_key = a.tiempo_key
                     Join dwhouse.dm_geografia g on g.geografia_key = a.geografia_key
                     Join dwhouse.dm_producto r on r.producto_key = a.producto_key
                     Left Join (Select tp1corr3 codsuc,trim(tp1desc) tipsuc 
                                  from DWEXTRA.fst198 
                                 where tp1cod1=10819 and tp1corr1 = 300 and tp1corr2 = 2
                               ) c on c.codsuc = g.cod_sucurs
                    Where t.fecha = ld_imes 
                    Group by  g.cod_sucurs,t.periodo, r.codigo_producto,nvl(c.tipsuc,'D') 
               ) 
              PIVOT (
                      SUM(meta_mn)
                      FOR codigo_producto
                       IN ('21','22','211')
                    )
            Commit;       
       Exception When Others Then
          lv_err := substr(sqlerrm,200);
          dbms_output.put_line(lv_err);
       End;
       
  End SP_INC_METAS_V2023;
  ----------------------------------------------------------------------------------------
  PROCEDURE SP_INC_ACT_METAAGE_V2023(PD_FECDIA In Date)
  --------------------------------------------------------------- 
  --- PROCESO: Actualiza Metas por agencia/producto y region operaciones
  ---------------------------------------------------------------
  Is
      ln_perdia number(6) := to_number(to_char(PD_FECDIA,'rrrrmm'));
      ln_guiapr number(5) := 10819;
      ln_per number(6) := to_number(to_char(PD_FECDIA,'rrrrmm'));
           
      Cursor c_tipage(ln_guia in Number,ln_per in Number)
          is Select tp1corr2 codage, tp1corr3 permet,trim(upper(tp1desc)) tipage, 
                    tp1imp1 metaho,tp1imp2 metdpf,tp1imp3 metcts
               from dwextra.fst198 u 
              where u.tp1cod = 1 and u.tp1cod1 = ln_guia and u.tp1corr1 = 301
                and tp1corr3 = ln_per
                    UNION ALL
             Select to_number(codigo_agencia),ln_per,Null,0,0,0 
               From dwhouse.dm_geografia
              Where cod_sucurs not in (Select tp1corr2 
                                        From dwextra.fst198 
                                       Where tp1cod = 1 
                                         and tp1cod1 = ln_guia 
                                         and tp1corr1 = 301
                                         and tp1corr2 = ln_per)
                and tipo_region = 'R' 
                and to_number(codigo_agencia) < 800 
                and to_number(codigo_agencia) <> 0;
      
      Cursor c_ana
          is Select distinct a.codigo_analista,k.analista_key
               From TMP_FACT_PASIVO_PRODINC k
               Join dwhouse.dm_analista a 
                 on a.analista_key = k.analista_key
              Where ind_tipinc = 2;
           
       
      ln_regkey Number(10);
      ln_agekey Number(10);     
      ln_agetes Number(10);  
      lv_tipana Varchar2(20);  
  BEGIN
       -- Actualiza Metas y Tipo de Agencia
       For x In c_tipage(ln_guiapr,ln_perdia) Loop
           
           Begin
              Select h.geografia_key Into ln_agekey
                From dwhouse.dm_geografia h
               Where h.tipo_region = 'R'
                 and h.cod_sucurs = x.codage; 
           Exception When Others Then
              ln_agekey := Null;
           End;
         
           Begin
              Select h.geografia_key Into ln_agetes
                From dwhouse.dm_geografia h
               Where h.tipo_region <> 'R'
                 and h.cod_sucurs = x.codage; 
           Exception When Others Then
              ln_agetes := Null;
           End;
         
           ln_regkey := dwstage.pq_tmp_carga_transacc.fn_key_region_op(x.codage,PD_FECDIA);
         
           Update TMP_FACT_PASIVO_PRODINC u
              Set u.cod_tipage   = x.tipage,
                  u.regionop_key = ln_regkey,
                  u.imp_meta_aho = nvl(x.metaho,0),
                  u.imp_meta_dpf = nvl(x.metdpf,0),
                  u.imp_meta_cts = nvl(x.metcts,0),
                  u.ind_permet   = x.permet
            Where u.geografia_key = ln_agekey;
            Commit;      
          
            If ln_agetes Is Not Null Then
               Update TMP_FACT_PASIVO_PRODINC u
                Set u.cod_tipage   = x.tipage,
                    u.regionop_key = ln_regkey,
                    u.imp_meta_aho = nvl(x.metaho,0),
                    u.imp_meta_dpf = nvl(x.metdpf,0),
                    u.imp_meta_cts = nvl(x.metcts,0),
                    u.ind_permet   = x.permet
              Where u.geografia_key = ln_agetes;
              Commit;    
            End If;
       End Loop; 
     
       Update TMP_FACT_PASIVO_PRODINC u
          Set u.regionop_key = 0
        Where u.regionop_key Is Null;
       COMMIT;   
        
       ----
       -- Agencia de Analista
       ----
       For x in c_ana Loop
            --- Busca agencia en tabla de metas
            Begin
                SElect g.geografia_key,
                       (SElect nvl(trim(tp1desc),'') 
                          From DWEXTRA.fst198 z where tp1cod1=10819 and tp1corr1=303 
                          and z.tp1corr2 = p.tp1nro1) Tipo   
                  Into ln_agekey,lv_tipana
                  From DWEXTRA.fst198 p
                  Join dwhouse.dm_geografia g on to_number(g.codigo_agencia) = p.tp1imp2
                 Where tp1cod1=10819 and tp1corr1=302 
                   and tp1corr3 = ln_perdia 
                   and trim(p.tp1desc) = x.codigo_analista
                   and g.tipo_region = 'R';
            Exception When Others Then
                ln_agekey := Null;
                lv_tipana := null;
            End;
            
            --- Si no encuentra en tabla de analista, obtiene agencia de tabla de usuarios
            IF ln_agekey is null Or ln_agekey = 117893 Then
                Begin
                    Select ge.geografia_key
                      Into ln_agekey
                      From fst046@produ ag
                      Join dwhouse.dm_geografia ge on to_number(ge.codigo_agencia) = ag.ubsuc
                     Where ag.ubuser = rpad(x.codigo_analista,10,' ')
                       and ge.tipo_region = 'R';
                Exception When Others Then
                    ln_agekey := Null;
                End;
            End If;
            
            ---- TIPO DE ANALISTA
            Update TMP_FACT_PASIVO_PRODINC u
              Set u.des_tipana   = lv_tipana,
                  u.ageana_key   = nvl(ln_agekey,u.ageana_key)
            Where u.analista_key = x.analista_key;
            
            COMMIT;
          
       End Loop;  
  END SP_INC_ACT_METAAGE_V2023;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- -- --  
  /*PROCEDURE SP_INC_RESULTADOS_V2023(PD_FECHA In Date)
  -----------------------------------------------------------------------------  
  --- Creación:
  --- Fecha : 2023.04.19
  --- Autor : Paola Vargas
  --- Motivo: Resultados de acuerdo a nueva metodologia de incetivos abril 2023
  -----------------------------------------------------------------------------
  IS  
     Cursor c_tipage
       is Select distinct cod_tipage From tmp_fact_pasivo_prodinc_res 
           Where cod_tipage Is not null and ind_tipmet = 1;
       
     Cursor c_logtod(lv_tipage in Varchar2)
         is Select * From tmp_fact_pasivo_prodinc_res 
             Where cod_tipage = lv_tipage and ind_tipmet = 1 and IND_LogTod=1
             Order By (Por_LogAHO+Por_LogDPF) desc;  

     Cursor c_analista
       is Select distinct des_tipana From tmp_fact_pasivo_prodinc_res 
           Where des_tipana Is not null and ind_tipmet = 2;
       
   Cursor c_logtod_an(lv_tipa in varchar2)
       is Select * From tmp_fact_pasivo_prodinc_res 
          Where des_tipana = lv_tipa and ind_tipmet = 2 and IND_LogTod=1
          Order By (Por_LogAHO+Por_LogDPF) desc;  
          
   Cursor c_logacu_an(lv_tipa in varchar2)
       is Select * From tmp_fact_pasivo_prodinc_res 
          Where des_tipana = lv_tipa 
            and ind_tipmet = 2 
            and IND_LogTod=0
          Order By Por_LogACUM desc;    
   
     
     Cursor c_pagoana(ln_tot in Number)
         is  Select * From (
             select analista_key,des_tipana,to_number(to_char(fec_saldo,'rrrrmm')) periodo
               from tmp_fact_pasivo_prodinc_res 
              where ind_tipmet = 2 
                and des_tipana  in ('MASTER','SENIOR','SENIOR EXPERTO')
                and (Por_LogAho + Por_LogDPF) > 0
               Order by ind_logtod desc,(Por_LogAho + Por_LogDPF) desc
              ) Where Rownum <= ln_tot;
     
     Cursor c_pagoana2(ln_tot in Number)
         is  Select * From (
             select analista_key,des_tipana,to_number(to_char(fec_saldo,'rrrrmm')) periodo 
               from tmp_fact_pasivo_prodinc_res 
              where ind_tipmet = 2 
                and des_tipana not in ('MASTER','SENIOR','SENIOR EXPERTO')
                and (Por_LogAho + Por_LogDPF) > 0
               Order by ind_logtod desc,(Por_LogAho + Por_LogDPF) desc
              ) Where Rownum <= ln_tot;
                          
      Cursor c_resana 
            is Select tiempo_key,analista_key,geografia_key,des_tipana,fec_saldo,ind_tipmet,
                      sum(nvl(AHO_C,0)) ahoava,sum(nvl(DPF_C,0)) dpfava
                      from
                      (
               Select dat.*,
                      case when imp_capclit <= 0 Then 0
                           when imp_capclit > 0 and  aho <= 0 then 0  
                           when imp_capclit > 0 and  aho > 0 and dpf <= 0 then imp_capclit 
                           else aho 
                       end AHO_C, 
                      case when imp_capclit <= 0 Then 0
                           when imp_capclit > 0 and  dpf <= 0 then 0  
                           when imp_capclit > 0 and  aho <= 0 and dpf > 0 then imp_capclit 
                           else dpf
                       end DPF_C       
                 From (
               select tiempo_key,analista_key,geografia_key,des_tipana,fec_saldo,
                      cliente_key,imp_capclit,ind_tipmet,
                      sum(case when codigo_producto = '21' then imp_sdoavan - imp_sdobase else 0 end) AHO,
                      sum(case when codigo_producto = '22' then imp_sdoavan - imp_sdobase else 0 end) DPF
                from dwstage.TMP_FACT_PASIVO_PRODINC_METAS where ind_tipmet in (2,7)
               group by tiempo_key,analista_key,geografia_key,des_tipana,fec_saldo,cliente_key,ind_tipmet,imp_capclit
                ) dat)
               group by tiempo_key,analista_key,geografia_key,des_tipana,fec_saldo,ind_tipmet;
                  
               
     --- nuevo: saldo avance y base otros
     Cursor c_otros
         is Select i.cod_producto,i.geografia_key,sum(i.saldo_base_mn/i.ind_numtit) sbase,
                    sum(case when (nvl(i.imp_tragob,0) + nvl(i.imp_desemb,0))>nvl(i.saldo_avan_mn,0) then 0 
                             else (nvl(i.saldo_avan_mn,0) - (nvl(i.imp_tragob,0) + nvl(i.imp_desemb,0)))/nvl(i.ind_numtit,1)
                       end) savance,
                    to_number(g.codigo_agencia) codage   
              from dwstage.TMP_FACT_PASIVO_PRODINC i
              Join dwhouse.dm_geografia g on g.geografia_key = i.geografia_key
              Where g.tipo_region ='R'
                and i.ind_tipinc <>  1
                and i.cod_producto is not null
                group by i.cod_producto,i.geografia_key,to_number(g.codigo_agencia);
     ----------
     ln_rnkage Number(5) := 0;  
     ln_pesaho number(7,3) := 0.6; -- Peso ahorros
     ln_pespfc number(7,3) := 0.4; -- Peso DPF + CTS
     ln_agetip number(2) := 1;   -- Cantidad de agencias por tipo
     ln_cntage number(3) := 0;
     ln_anagr1 number(3) := 10;  -- Cantidad de analistas G1 
     ln_anagr2 number(3) := 15;  -- Cantidad de analistas G2
     lv_tippag varchar2(20);
     lv_motrnk varchar2(20);
     ln_pagmes number(5);
     ln_period number(6) := to_number(to_char(PD_FECHA,'rrrrmm'));
     
     ld_FecTri date;
     ln_indmet number(2);
     ln_sdobas number(20,4);
  BEGIN
       -- INSERTA SALDO META DE AGENCIAS
       PQ_TMP_PRODUCTIVIDADASE.SP_INC_INSSDOMET_AGE(PD_FECHA);   
  
       Execute Immediate 'Truncate table tmp_fact_pasivo_prodinc_metas';
       Insert Into tmp_fact_pasivo_prodinc_metas
                   (tiempo_key,codigo_producto,geografia_key,regionop_key,imp_meta,
                    cod_tipage,ind_tipmet,analista_key,des_tipana,fec_saldo,imp_sdobase,
                    imp_sdoavan,imp_sdometat,imp_sdometa,IMP_SDOBASO
                   )
       -- AGENCIAS: Metas de Ahorros 
       Select TIEMPO_KEY,codpro,GEOGRAFIA_KEY,REGIONOP_KEY,imp_meta,
              cod_tipage,ind_tipmet,anakey,desana,fec_saldo,nvl(imp_base,0),
              nvl(imp_avance,0),
              case when nvl(imp_meta,0) <> 0 Then nvl(imp_meta,0)+nvl(imp_sdomet,0) else 0 end,
              case when nvl(imp_meta,0) <> 0 Then nvl(imp_meta,0)+nvl(imp_sdomet,0) else 0 end,
              --0,
              0
         from (
       SELECT TIEMPO_KEY,'21' codpro,p.GEOGRAFIA_KEY,REGIONOP_KEY,
              max(nvl(P.IMP_META_AHO,0)) imp_meta,
              p.cod_tipage,1 ind_tipmet,
              0 anakey,'NO CLASIFICADO' desana,p.fec_saldo,
              --sum(nvl(p.saldo_base_mn,0)/nvl(p.ind_numtit,1)) imp_base, -- Saldo sin descuentos    
              sum(case when p.cod_producto='21' Then
                       case when (nvl(p.imp_bonafp_mant,0) + nvl(p.imp_desemb_mant,0))>nvl(p.saldo_base_mn,0) 
                            then 0 
                            else (nvl(p.saldo_base_mn,0) - (nvl(p.imp_bonafp_mant,0) + nvl(p.imp_desemb_mant,0)))/nvl(p.ind_numtit,1)
                       end
                  else 0     
                  end) imp_base,
                  
              sum(case when p.cod_producto='21' Then
                       case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_avan_mn,0) 
                            then 0 
                            else (nvl(p.saldo_avan_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/nvl(p.ind_numtit,1)
                       end
                  else 0     
                  end) imp_avance,
              nvl(max(x.tp1imp1),0)imp_sdomet     
         FROM dwstage.TMP_FACT_PASIVO_PRODINC P
         JOIN dwhouse.dm_geografia G ON G.Geografia_Key = P.Geografia_Key
         Left Join DWEXTRA.fst198 x on x.tp1corr2 = to_number(g.Codigo_Agencia) and x.tp1cod1=10819 and x.tp1corr1=304
                   and x.tp1corr3 = ln_period
        Where p.ind_tipinc = 1 
          and g.tipo_region = 'R'
          and p.cod_producto = '21'
        Group By TIEMPO_KEY,p.GEOGRAFIA_KEY,REGIONOP_KEY,p.cod_tipage,p.fec_saldo
                 UNION ALL
       --AGENCIA: Metas DPF
       SELECT TIEMPO_KEY,'22',p.GEOGRAFIA_KEY,REGIONOP_KEY,
              max(nvl(P.IMP_META_DPF,0)),
              p.cod_tipage,1 ind_tipmet,
              0,'NO CLASIFICADO',p.fec_saldo,
              --sum(nvl(p.saldo_base_mn,0)/nvl(p.ind_numtit,1)), 
               sum(case when p.cod_producto='22' Then
                       case when (nvl(p.imp_bonafp_mant,0) + nvl(p.imp_desemb_mant,0))>nvl(p.saldo_base_mn,0) 
                            then 0 
                            else (nvl(p.saldo_base_mn,0) - (nvl(p.imp_bonafp_mant,0) + nvl(p.imp_desemb_mant,0)))/nvl(p.ind_numtit,1)
                       end
                  else 0     
                  end) imp_base,
                      
              sum(case when p.cod_producto='22' Then
                      case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_avan_mn,0) 
                           then 0 
                           else (nvl(p.saldo_avan_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/nvl(p.ind_numtit,1)
                      end
                  Else 0     
                  End),
              nvl(max(x.tp1imp2),0)imp_sdomet     
         FROM dwstage.TMP_FACT_PASIVO_PRODINC P
         JOIN dwhouse.dm_geografia G ON G.Geografia_Key = P.Geografia_Key
         Left Join DWEXTRA.fst198 x on x.tp1corr2 = to_number(g.Codigo_Agencia) and x.tp1cod1=10819 and x.tp1corr1=304
                   and x.tp1corr3 = ln_period
        Where p.ind_tipinc = 1 
          and g.tipo_region = 'R'
          and p.cod_producto = '22'
        Group By TIEMPO_KEY,p.GEOGRAFIA_KEY,REGIONOP_KEY,p.cod_tipage,p.fec_saldo
                 UNION ALL
       --AGENCIAS: Metas CTS
       SELECT TIEMPO_KEY,'211',p.GEOGRAFIA_KEY,REGIONOP_KEY,
              max(nvl(P.IMP_META_CTS,0)),
              p.cod_tipage,1 ind_tipmet,
              0,'NO CLASIFICADO',p.fec_saldo,
              --sum(nvl(p.saldo_base_mn,0)/nvl(p.ind_numtit,1)), ---Saldo sin descuentos    
               sum(case when p.cod_producto='211' Then
                       case when (nvl(p.imp_bonafp_mant,0) + nvl(p.imp_desemb_mant,0))>nvl(p.saldo_base_mn,0) 
                            then 0 
                            else (nvl(p.saldo_base_mn,0) - (nvl(p.imp_bonafp_mant,0) + nvl(p.imp_desemb_mant,0)))/nvl(p.ind_numtit,1)
                       end
                  else 0     
                  end) imp_base,
                  
              sum(case when p.cod_producto='211' Then
                      case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_avan_mn,0) 
                           then 0 
                           else (nvl(p.saldo_avan_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/nvl(p.ind_numtit,1)
                      end
                      Else 0     
                      end),
              nvl(max(x.tp1imp3),0)imp_sdomet        
         FROM dwstage.TMP_FACT_PASIVO_PRODINC P
         JOIN dwhouse.dm_geografia G ON G.Geografia_Key = P.Geografia_Key
         Left Join DWEXTRA.fst198 x on x.tp1corr2 = to_number(g.Codigo_Agencia) and x.tp1cod1=10819 and x.tp1corr1=304
                   and x.tp1corr3 = ln_period
        Where p.ind_tipinc = 1 
          and g.tipo_region = 'R'
          and p.cod_producto = '211'
        Group By TIEMPO_KEY,p.GEOGRAFIA_KEY,REGIONOP_KEY,p.cod_tipage,p.fec_saldo
        );
       COMMIT;
       
       ---- Nuevo: actualiza otros en agencias
       -- Obtiene mes Inicial Trimestre
       dwstage.PQ_TMP_PRODUCTIVIDADASE.SP_INC_SALDOMETA_AGEN(PD_FECHA =>  PD_FECHA,
                                                             PD_FECMET => ld_FecTri,
                                                             PN_INDMET => ln_indmet);
                                                        
       For x In c_otros loop
           ln_sdobas := nvl(x.sbase,0);
           If ln_indmet = 0 Then
              select to_date(to_char(add_months(to_date(to_char(f.tp1nro1),'rrrrmmdd'),1),'rrrrmm')||'01','rrrrmmdd') 
                Into ld_FecTri
                from dwextra.fst198  f
               where tp1cod1=10819 and tp1corr1=304
                 and tp1corr2 = x.codage
                 and tp1corr3 = ln_period;
              If  to_char(ld_FecTri,'rrrrmm') <>  to_char(PD_FECHA,'rrrrmm') Then  
              dbms_output.put_line('Agencia:'|| x.codage);
              select nvl(sum(f.imp_sdobaso),0) Into ln_sdobas
                from dwhouse.fact_pasivo_prodinc_meta f 
                where ind_tipmet = 1 and geografia_key = x.geografia_key 
                and f.codigo_producto = x.cod_producto
                and tiempo_key = (select tiempo_key 
                                    from dwhouse.dm_tiempo 
                                   where fecha = ld_FecTri);
               End If;                                               
           End If;
           
           Update tmp_fact_pasivo_prodinc_metas p
              set IMP_SDOBASO = ln_sdobas, 
                  IMP_SDOAVAO =  nvl(x.savance,0),                        
                  imp_SDOMETA = (case when nvl(imp_sdometat,0) <> 0 then nvl(imp_sdometat,0)- nvl(ln_sdobas,0) else 0 end)
            Where p.codigo_producto = x.cod_producto
              and p.geografia_key = x.geografia_key 
              and p.ind_tipmet = 1;
              commit;    
       End Loop;
       ----------
  --select * from tmp_fact_pasivo_prodinc_metas where ind_Tipmet = 2 and analista_key = 11083502
  --select * from dwhouse.dm_analista where codigo_analista like 'JMOSCO%'
       ----
       -- ANALISTAS
       ----
       Insert Into tmp_fact_pasivo_prodinc_metas
                   (TIEMPO_KEY,CODIGO_PRODUCTO,GEOGRAFIA_KEY,REGIONOP_KEY,
                    IND_TIPMET,ANALISTA_KEY,DES_TIPANA,FEC_SALDO,cliente_key,imp_sdobase,imp_sdoavan,IMP_CAPCLIT)  
              
               Select dat.*,
                      sum(dat.avance-dat.base) over(partition by analista_key,cliente_key) poscli
                  from(      
              Select p.tiempo_key,p.cod_producto,
                     (case when p.ind_tipinc = 7 then p.geografia_key else p.ageana_key end) ageana_key,
                     p.regionop_key,
                     p.ind_tipinc,
                     (case when p.ind_tipinc = 2 then p.analista_key else p.asecre_key end) analista_key,
                     NVL(p.des_tipana,'NO CLASIFICADO'),
                     fec_saldo,p.cliente_key,
                     sum(nvl(p.saldo_base_mn,0)/nvl(p.ind_numtit,1)) base,  --sin descuentos   
                     sum(case when p.cod_producto='21' Then
                              case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_avan_mn,0) 
                                   then 0 
                                   else (nvl(p.saldo_avan_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/nvl(p.ind_numtit,1)
                              end
                              when p.cod_producto='22' Then
                              case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_avan_mn,0) 
                                   then 0 
                                   else (nvl(p.saldo_avan_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/nvl(p.ind_numtit,1)
                              end
                              when p.cod_producto='211' Then
                              case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_avan_mn,0) 
                              then 0 
                              else (nvl(p.saldo_avan_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/nvl(p.ind_numtit,1)
                              end
                      Else 0     
                      end) avance
                FROM dwstage.TMP_FACT_PASIVO_PRODINC P
                JOIN dwhouse.dm_geografia G ON G.Geografia_Key = P.Geografia_Key
               Where p.ind_tipinc in (2,7)  --Analistas y Asesores
                 and g.tipo_region = 'R'
               Group by p.tiempo_key,p.cod_producto,p.ageana_key,p.regionop_key,p.ind_tipinc,
                        p.analista_key,NVL(p.des_tipana,'NO CLASIFICADO'),fec_saldo,p.cliente_key,
                        (case when p.ind_tipinc = 7 then p.geografia_key else p.ageana_key end),
                        (case when p.ind_tipinc = 2 then p.analista_key else p.asecre_key end)  
                        )dat;  
                       
            COMMIT;
   
           ------------------------
           -- AGENCIAS: RESULTADOS
           ------------------------
           EXECUTE IMMEDIATE 'TRUNCATE TABLE tmp_fact_pasivo_prodinc_res';
           
           INSERT INTO tmp_fact_pasivo_prodinc_res
                       (tiempo_key,geografia_key,regionop_key,cod_tipage,ind_tipmet,analista_key,
                        des_tipana,fec_saldo,imp_metcts,imp_metaho,imp_metdpf,
                        imp_bascts,imp_basaho,imp_basdpf,imp_avacts,imp_avaaho,imp_avadpf,
                        imp_logcts,imp_logaho,imp_logdpf,por_logcts,por_logaho,por_logdpf,
                        imp_sdometcts,imp_sdometaho,imp_sdometdpf
                       ) 
                SELECT m.tiempo_key,m.geografia_key,m.regionop_key,m.cod_tipage,m.ind_tipmet,
                       m.analista_key,m.des_tipana,m.fec_saldo,
                       sum(Case when m.codigo_producto = 211 Then nvl(m.imp_meta,0) End) IMP_MetCTS, 
                       sum(Case when m.codigo_producto = 21 Then nvl(m.imp_meta,0) End) IMP_MetAHO, 
                       sum(Case when m.codigo_producto = 22 Then nvl(m.imp_meta,0) End) IMP_MetDPF, 
                   
                   
                       sum(Case when m.codigo_producto = 211 Then nvl(m.imp_sdobase,0) End) IMP_BasCTS, 
                       sum(Case when m.codigo_producto = 21 Then nvl(m.imp_sdobase,0) End) IMP_BasAHO, 
                       sum(Case when m.codigo_producto = 22 Then nvl(m.imp_sdobase,0) End) IMP_BasDPF, 
                   
                       sum(Case when m.codigo_producto = 211 Then nvl(m.imp_sdoavan,0) End) IMP_AvaCTS, 
                       sum(Case when m.codigo_producto = 21 Then nvl(m.imp_sdoavan,0) End) IMP_AvaAHO, 
                       sum(Case when m.codigo_producto = 22 Then nvl(m.imp_sdoavan,0) End) IMP_AvaDPF, 
                   
                       sum(Case when m.codigo_producto = 211 Then nvl(m.imp_sdoavan,0)- (nvl(m.imp_sdobase,0)) End) IMP_LogCTS, 
                       sum(Case when m.codigo_producto = 21 Then nvl(m.imp_sdoavan,0) - nvl(m.imp_sdobase,0) End) IMP_LogAHO,
                       sum(Case when m.codigo_producto = 22 Then nvl(m.imp_sdoavan,0) - nvl(m.imp_sdobase,0) End) IMP_LogDPF,
                      
                       
                       sum(Case when m.codigo_producto = 211 and nvl(m.imp_meta,0) = 0 Then 0
                                When m.codigo_producto = 211 and nvl(m.imp_meta,0) <> 0 and
                                     nvl(m.imp_sdometa,0) <> 0 
                                Then nvl(m.imp_sdoavan,0)/nvl(m.imp_sdometa,0)  
                                When m.codigo_producto = 211 and nvl(m.imp_meta,0) <> 0 and
                                     nvl(m.imp_sdometa,0) = 0
                                Then nvl(m.imp_sdoavan,0)/(nvl(m.imp_sdobase,0) + nvl(m.imp_meta,0))       
                           End) POR_LogCTS,  
                       sum(Case when m.codigo_producto = 21 and nvl(m.imp_meta,0)=0 Then 0
                                When m.codigo_producto = 21 and nvl(m.imp_meta,0)<> 0 and 
                                     nvl(m.imp_sdometa,0) <> 0 
                                Then nvl(m.imp_sdoavan,0)/nvl(m.imp_sdometa,0)  
                                When m.codigo_producto = 21 and nvl(m.imp_meta,0)<> 0 and 
                                     nvl(m.imp_sdometa,0) = 0      
                                Then nvl(m.imp_sdoavan,0)/(nvl(m.imp_sdobase,0) + nvl(m.imp_meta,0)) 
                           End) POR_LogAHO,    
                       sum(Case when m.codigo_producto = 22 and nvl(m.imp_meta,0)=0 Then 0
                                When m.codigo_producto = 22 and nvl(m.imp_meta,0)<> 0 and 
                                     nvl(m.imp_sdometa,0) <> 0 
                                Then nvl(m.imp_sdoavan,0)/nvl(m.imp_sdometa,0)  
                                When m.codigo_producto = 22 and nvl(m.imp_meta,0)<> 0 and 
                                     nvl(m.imp_sdometa,0) = 0      
                                Then nvl(m.imp_sdoavan,0)/(nvl(m.imp_sdobase,0) + nvl(m.imp_meta,0)) 
                           End) POR_LogDPF, 
                           
                       sum(Case when m.codigo_producto = 211 and nvl(m.imp_meta,0) = 0
                                Then 0
                                when m.codigo_producto = 211 and nvl(m.imp_sdometa,0) = 0 
                                Then nvl(m.imp_sdobase,0) + nvl(m.imp_meta,0) 
                                when m.codigo_producto = 211 and nvl(m.imp_sdometa,0) <> 0 
                                Then nvl(m.imp_sdometa,0)     
                                Else 0 End) IMP_SdoMetCTS, 
                       sum(Case when m.codigo_producto = 21 and nvl(m.imp_meta,0) = 0
                                Then 0
                                when m.codigo_producto = 21 and nvl(m.imp_sdometa,0) = 0 
                                Then nvl(m.imp_sdobase,0) + nvl(m.imp_meta,0) 
                                when m.codigo_producto = 21 and nvl(m.imp_sdometa,0) <> 0 
                                Then nvl(m.imp_sdometa,0)
                                Else 0 End) IMP_SdoMetAHO,
                       sum(Case when m.codigo_producto = 22 and nvl(m.imp_meta,0) = 0
                                Then 0
                                when m.codigo_producto = 22 and nvl(m.imp_sdometa,0) = 0 
                                Then nvl(m.imp_sdobase,0) + nvl(m.imp_meta,0) 
                                when m.codigo_producto = 22 and nvl(m.imp_sdometa,0) <> 0
                                Then nvl(m.imp_sdometa,0)   
                                Else 0 End) IMP_SdoMetdPF 
                                 
                 FROM tmp_fact_pasivo_prodinc_metas m
                Where ind_tipmet = 1 
                Group By m.tiempo_key,m.geografia_key,m.regionop_key,m.cod_tipage,m.ind_tipmet,
                         m.analista_key,m.des_tipana,m.fec_saldo;
           COMMIT;
           
          ------------------------
          -- ANALISTAS: RESULTADOS
          ------------------------ 
          
          For x in c_resana Loop
               INSERT INTO tmp_fact_pasivo_prodinc_res
                     (tiempo_key,geografia_key,analista_key,des_tipana,fec_saldo,
                      cod_producto,imp_capdep,ind_tipmet,ind_regcap,ind_LogTod
                     ) 
               Select x.tiempo_key,x.geografia_key,x.analista_key,x.des_tipana,x.fec_saldo,
                      '21',x.ahoava,x.ind_tipmet,1,0 from dual
               union all
               Select x.tiempo_key,x.geografia_key,x.analista_key,x.des_tipana,x.fec_saldo,
                      '22',x.dpfava,x.ind_tipmet,1,0 from dual;
               Commit;       
           End Loop;
           
           -- 2022.06.28 INSERTA ANALISTAS QUE NO CAPTARON
           Begin
               INSERT INTO tmp_fact_pasivo_prodinc_res
                         (tiempo_key,geografia_key,analista_key,fec_saldo,
                          cod_producto,imp_capdep,ind_tipmet,ind_regcap,ind_LogTod,des_tipana
                         )
                  SELECT tiempo_key,ageana_key,analista_key,PD_FECHA,
                         '21' codpro,0,ind_regcli,0,0,
                         (SElect nvl(trim(tp1desc),'JUNIOR') 
                                            From DWEXTRA.fst198 z where tp1cod1=10819 and tp1corr1=303 
                                            and z.tp1corr2 = p.tp1nro1) Tipo  
                    From TMP_FACT_PASIVO_CLICAP an
                    Join DWEXTRA.fst198 p on tp1cod1=10819 and tp1corr1=302 
                     and tp1corr3 = ln_period
                     and trim(p.tp1desc) = an.cod_anacre
                    Where ind_regcli = 2 and fec_regcli is null
                          UNION ALL
                  SELECT distinct tiempo_key,ageana_key,analista_key,PD_FECHA,
                         '21' codpro,0,ind_regcli,1,0,
                         (SElect nvl(trim(tp1desc),'JUNIOR') 
                                            From DWEXTRA.fst198 z where tp1cod1=10819 and tp1corr1=303 
                                            and z.tp1corr2 = p.tp1nro1) Tipo  
                    From TMP_FACT_PASIVO_CLICAP an
                    Join DWEXTRA.fst198 p on tp1cod1=10819 and tp1corr1=302 
                     and tp1corr3 = ln_period
                     and trim(p.tp1desc) = an.cod_anacre
                    Where ind_regcli = 2 and fec_Regcli is not null
                      and not exists (select 1 from tmp_fact_pasivo_prodinc_res r 
                                       where r.ind_tipmet = 2 and r.analista_key = an.analista_key);        
               Commit;     
           Exception When Others Then
              Null;
           End;              
           -----------           
          
        -----------------------------------------
        --- ANALISTAS: CAPTACIONES
        -----------------------------------------
        --- CUMPLE TODOS LOS PRODUCTOS
        Update  tmp_fact_pasivo_prodinc_res res set ind_logtod = 1
         Where ind_tipmet = 2
           and exists (select 1 
                         from (select analista_key,sum(nvl(imp_capdep,0)) imp_capdep
                                 from tmp_fact_pasivo_prodinc_res
                                where ind_tipmet = 2
                                group by analista_key
                                having sum(nvl(imp_capdep,0)) > 0
                              ) tab 
                        where tab.analista_key= res.analista_key);
        COMMIT;                
       -----------------------------------------
       --- AGENCIAS: CUMPLE TODOS LOS PRODUCTOS
       -----------------------------------------
       Update tmp_fact_pasivo_prodinc_res 
          set ind_LogTod = 1 
        Where ind_tipmet = 1 
          and ((Por_LogAHO >=1 and nvl(imp_sdometaho,0) > 0) Or (Por_LogAHO = 0 and nvl(imp_sdometaho,0)=0))
          and ((Por_LogDPF >=1 and nvl(imp_sdometdpf,0) > 0) Or (Por_LogDPF = 0 and nvl(imp_sdometdpf,0)=0));
      
       Update tmp_fact_pasivo_prodinc_res set ind_LogTod = 0 
        Where ind_tipmet = 1 
          and nvl(ind_LogTod,0) <> 1 ;
       COMMIT;
       
       -------------------------
       -- RANKIG AGENCIAS
       -------------------------
       Update tmp_fact_pasivo_prodinc_res set rnk_logage = null Where ind_tipmet = 1;
       Commit;
   
       For x In c_tipage Loop
           ln_rnkage := 0;
           ln_cntage := 0;
           ln_pagmes := 0;
           
           For z In c_logtod(x.cod_tipage) Loop
               If x.cod_tipage = 'A' Then
                  ln_cntage := 4;
               ElsIf x.cod_tipage = 'B' Then
                  ln_cntage := 8;
               ElsIf x.cod_tipage = 'C' Then
                  ln_cntage := 10;  
               Else       
                  ln_cntage := 30;
               End If;
               
               ln_rnkage := ln_rnkage + 1;
               lv_tippag := Null;
               ln_pagmes := 0;
               
               If ln_cntage < ln_agetip Then
                  lv_tippag := 'Pago 100%';
               End If;
               ln_cntage := ln_cntage + 1;
               
               Update tmp_fact_pasivo_prodinc_res
                  Set rnk_logage = ln_rnkage,
                      Por_ImpPago= lv_tippag,
                      des_motrnk = 'Cumple Metas'
                Where tiempo_key = z.tiempo_key
                  and geografia_key = z.geografia_key
                  and ind_tipmet = 1;
               Commit;   
           End Loop;
       End Loop;
  END SP_INC_RESULTADOS_V2023;
  */
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE SP_INC_RESULTADOS_OPE_V2023(PD_FECHA In Date)
  -----------------------------------------------------------------------------  
  --- Creación:
  --- Fecha : 2023.04.19
  --- Autor : Paola Vargas
  --- Motivo: Resultados de acuerdo a nueva metodologia de incetivos abril 2023
  -----------------------------------------------------------------------------
  IS  
     cursor c_rnksuc
         is Select geografia_key,
            RANK() OVER (ORDER BY por_logacum + por_ahomes1 desc) rnksuc
            from dwstage.tmp_fact_pasivo_prodinc_res 
           where ind_tipmet = 1 and geografia_key <> 7;

     cursor c_rnkreg
         is Select regionop_key,
            RANK() OVER (ORDER BY por_logacum + por_ahomes1 desc) rnkreg
            from dwstage.tmp_fact_pasivo_prodinc_res 
           where ind_tipmet = 11
             and nvl(regionop_key,0) <> 0;   
             
     ln_period number(6) := to_number(to_char(PD_FECHA,'rrrrmm'));

     --> Version 2023
     ln_cummet number(7,3);  -- porcentaje cumplimiento meta consolidada
     ln_cumaho number(7,3);  -- porcentaje cumplimiento en ahorros
     ln_adiaho number(7,3);  -- porcentaje cumplimiento adicional en ahorros
     ln_inmet1 number(7,3);  -- pago incentivo RS por cumplimiento de meta
     ln_inaho1 number(7,3);  -- pago adicional RS por cumplimiento en ahorros
     ln_inmet2 number(7,3);  -- pago incentivo JP por cumplimiento de meta
     ln_inaho2 number(7,3);  -- pago adicional JP por cumplimiento en ahorros
     ln_inmet3 number(7,3);  -- pago incentivo SOP por cumplimiento de meta
     ln_inaho3 number(7,3);  -- pago adicional SOP por cumplimiento en ahorros
     ln_guiapr number(5) := 10819;
     ln_existe number(3);
     ln_perant number(8) := to_number(to_char(add_months(PD_FECHA,-1),'rrrrmm'));
     --< Version 2023
     
  BEGIN
       -- REVISA E INSERTA METAS DE AGENCIAS PARA EL PERIODO
          -- PORCENTAJES EN CUMPLIMIENTO DE METAS
          Select count(*) Into ln_existe
           From DWEXTRA.fst198 
          Where tp1cod1=ln_guiapr and tp1corr1 = 300 and tp1corr2 = 0
            and TP1NRO1 = ln_period;
            
          If ln_existe = 0 Then
             Insert Into DWEXTRA.fst198(TP1COD,TP1COD1,TP1CORR1,TP1CORR2,TP1CORR3,TP1NRO1,TP1DESC,TP1IMP1,TP1IMP2,TP1IMP3)
             Select TP1COD,TP1COD1,TP1CORR1,TP1CORR2,TP1CORR3,ln_period,TP1DESC,TP1IMP1,TP1IMP2,TP1IMP3
               From DWEXTRA.fst198 
              Where tp1cod1=ln_guiapr and tp1corr1 = 300 and tp1corr2 = 0
                and TP1NRO1=ln_perant;
             Commit;
          End If;
          
          -- PAGO DE INCENTIVOS
          Select count(*) Into ln_existe
            from DWEXTRA.fst198 
           Where tp1cod1=ln_guiapr and tp1corr1 = 300 and tp1corr2 = 1
             and TP1NRO1 = ln_period;
          
          If ln_existe = 0 Then
             Insert Into DWEXTRA.fst198(TP1COD,TP1COD1,TP1CORR1,TP1CORR2,TP1CORR3,TP1NRO1,TP1DESC,TP1IMP1,TP1IMP2)
             Select TP1COD,TP1COD1,TP1CORR1,TP1CORR2,TP1CORR3,ln_period,TP1DESC,TP1IMP1,TP1IMP2
               From DWEXTRA.fst198 
              Where tp1cod1=ln_guiapr and tp1corr1 = 300 and tp1corr2 = 1
                and TP1NRO1=ln_perant;
             Commit;
          End If;   
 
       --- INICIA CALCULO DE LOGROS  
       Execute Immediate 'Truncate table tmp_fact_pasivo_prodinc_metas';
       Insert Into tmp_fact_pasivo_prodinc_metas
                   (tiempo_key,codigo_producto,geografia_key,regionop_key,imp_meta,
                    cod_tipage,ind_tipmet,analista_key,des_tipana,fec_saldo,imp_sdobase,
                    imp_sdoavan,imp_sdometat,imp_sdometa,IMP_SDOBASO
                   )
       -- AGENCIAS: Metas de Ahorros 
       Select TIEMPO_KEY,codpro,GEOGRAFIA_KEY,REGIONOP_KEY,imp_meta,
              cod_tipage,ind_tipmet,anakey,desana,fec_saldo,nvl(imp_base,0),
              nvl(imp_avance,0),
              imp_meta,
              imp_meta,
              0
         from (
       SELECT TIEMPO_KEY,'21' codpro,p.GEOGRAFIA_KEY,REGIONOP_KEY,
              max(m.impmeta) imp_meta,
              p.cod_tipage,1 ind_tipmet,
              0 anakey,'NO CLASIFICADO' desana,p.fec_saldo,
              0 imp_base,
              sum(case when p.cod_producto='21' 
                       then nvl(p.saldo_avan_mn,0)/nvl(p.ind_numtit,1) 
                       else 0 end) imp_avance    
         FROM dwstage.TMP_FACT_PASIVO_PRODINC P
         JOIN dwhouse.dm_geografia G ON G.Geografia_Key = P.Geografia_Key
         Left Join (select tp1corr2 codsuc, sum(nvl(tp1imp1,0)) impmeta
                      From dwextra.fst198  
                     where tp1cod = 1 and tp1cod1 = 10819 
                      and tp1corr1 = 301 and tp1corr3 = ln_period 
                     group by  tp1corr2  
                   ) m on m.codsuc = g.cod_sucurs
        Where g.tipo_region = 'R'
          and p.cod_producto = '21'
          and g.geografia_key <> 7 -- Excluye Padre Aldamis
        Group By TIEMPO_KEY,p.GEOGRAFIA_KEY,REGIONOP_KEY,p.cod_tipage,p.fec_saldo
                 UNION ALL
       --AGENCIA: Metas DPF
       SELECT TIEMPO_KEY,'22' codpro,p.GEOGRAFIA_KEY,REGIONOP_KEY,
              max(m.impmeta) imp_meta,
              p.cod_tipage,1 ind_tipmet,
              0 anakey,'NO CLASIFICADO' desana,p.fec_saldo,
              0 imp_base,
              sum(case when p.cod_producto='22' 
                       then nvl(p.saldo_avan_mn,0)/nvl(p.ind_numtit,1) 
                       else 0 end) imp_avance    
         FROM dwstage.TMP_FACT_PASIVO_PRODINC P
         JOIN dwhouse.dm_geografia G ON G.Geografia_Key = P.Geografia_Key
         Left Join (select tp1corr2 codsuc, sum(nvl(tp1imp2,0)) impmeta
                      From dwextra.fst198  
                     where tp1cod = 1 and tp1cod1 = 10819 
                      and tp1corr1 = 301 and tp1corr3 = ln_period 
                    group by  tp1corr2   
                   ) m on m.codsuc = g.cod_sucurs
        Where g.tipo_region = 'R'
          and p.cod_producto = '22'
          and g.geografia_key <> 7 -- Excluye Padre Aldamis
        Group By TIEMPO_KEY,p.GEOGRAFIA_KEY,REGIONOP_KEY,p.cod_tipage,p.fec_saldo
        --AGENCIAS: Metas CTS
       UNION ALL
       SELECT TIEMPO_KEY,'211' codpro,p.GEOGRAFIA_KEY,REGIONOP_KEY,
              max(m.impmeta) imp_meta,
              p.cod_tipage,1 ind_tipmet,
              0 anakey,'NO CLASIFICADO' desana,p.fec_saldo,
              0 imp_base,
              sum(case when p.cod_producto='211' 
                       then nvl(p.saldo_avan_mn,0)/nvl(p.ind_numtit,1) 
                       else 0 end) imp_avance    
         FROM dwstage.TMP_FACT_PASIVO_PRODINC P
         JOIN dwhouse.dm_geografia G ON G.Geografia_Key = P.Geografia_Key
         Left Join (select tp1corr2 codsuc, sum(nvl(tp1imp3,0)) impmeta
                      From dwextra.fst198  
                     where tp1cod = 1 and tp1cod1 = 10819 
                      and tp1corr1 = 301 and tp1corr3 = ln_period 
                     group by  tp1corr2  
                   ) m on m.codsuc = g.cod_sucurs
        Where g.tipo_region = 'R'
          and p.cod_producto = '211'
          and g.geografia_key <> 7 -- Excluye Padre Aldamis
        Group By TIEMPO_KEY,p.GEOGRAFIA_KEY,REGIONOP_KEY,p.cod_tipage,p.fec_saldo
        );
        COMMIT;
        
        ------------------------
        -- AGENCIAS: RESULTADOS
        ------------------------
        EXECUTE IMMEDIATE 'TRUNCATE TABLE tmp_fact_pasivo_prodinc_res';
           
        INSERT INTO tmp_fact_pasivo_prodinc_res
                       (tiempo_key,geografia_key,regionop_key,cod_tipage,ind_tipmet,analista_key,
                        des_tipana,fec_saldo,imp_metcts,imp_metaho,imp_metdpf,
                        imp_bascts,imp_basaho,imp_basdpf,imp_avacts,imp_avaaho,imp_avadpf,
                        imp_logcts,imp_logaho,imp_logdpf,por_logcts,por_logaho,por_logdpf,
                        imp_sdometcts,imp_sdometaho,imp_sdometdpf
                       ) 
                SELECT m.tiempo_key,m.geografia_key,m.regionop_key,m.cod_tipage,m.ind_tipmet,
                       m.analista_key,m.des_tipana,m.fec_saldo,
                       sum(Case when m.codigo_producto = 211 Then nvl(m.imp_meta,0) End) IMP_MetCTS, 
                       sum(Case when m.codigo_producto = 21 Then nvl(m.imp_meta,0) End) IMP_MetAHO, 
                       sum(Case when m.codigo_producto = 22 Then nvl(m.imp_meta,0) End) IMP_MetDPF, 
                   
                   
                       sum(Case when m.codigo_producto = 211 Then nvl(m.imp_sdobase,0) End) IMP_BasCTS, 
                       sum(Case when m.codigo_producto = 21 Then nvl(m.imp_sdobase,0) End) IMP_BasAHO, 
                       sum(Case when m.codigo_producto = 22 Then nvl(m.imp_sdobase,0) End) IMP_BasDPF, 
                   
                       sum(Case when m.codigo_producto = 211 Then nvl(m.imp_sdoavan,0) End) IMP_AvaCTS, 
                       sum(Case when m.codigo_producto = 21 Then nvl(m.imp_sdoavan,0) End) IMP_AvaAHO, 
                       sum(Case when m.codigo_producto = 22 Then nvl(m.imp_sdoavan,0) End) IMP_AvaDPF, 
                   
                       sum(Case when m.codigo_producto = 211 Then nvl(m.imp_sdoavan,0)- (nvl(m.imp_meta,0)) End) IMP_LogCTS, 
                       sum(Case when m.codigo_producto = 21 Then nvl(m.imp_sdoavan,0) - nvl(m.imp_meta,0) End) IMP_LogAHO,
                       sum(Case when m.codigo_producto = 22 Then nvl(m.imp_sdoavan,0) - nvl(m.imp_meta,0) End) IMP_LogDPF,
                      
                       
                       sum(Case when m.codigo_producto = 211 and nvl(m.imp_meta,0) = 0 Then 0
                                When m.codigo_producto = 211 and nvl(m.imp_meta,0) <> 0 Then 
                                     nvl(m.imp_sdoavan,0)/nvl(m.imp_meta,0)  
                           End) POR_LogCTS,  
                       sum(Case when m.codigo_producto = 21 and nvl(m.imp_meta,0)=0 Then 0
                                When m.codigo_producto = 21 and nvl(m.imp_meta,0)<> 0 Then 
                                     nvl(m.imp_sdoavan,0)/nvl(m.imp_meta,0)  
                           End) POR_LogAHO,    
                       sum(Case when m.codigo_producto = 22 and nvl(m.imp_meta,0)=0 Then 0
                                When m.codigo_producto = 22 and nvl(m.imp_meta,0)<> 0 Then 
                                     nvl(m.imp_sdoavan,0)/nvl(m.imp_meta,0)  
                           End) POR_LogDPF, 
                       
                       sum(Case when m.codigo_producto = 211 Then nvl(m.imp_meta,0) End) IMP_SdoMetCTS, 
                       sum(Case when m.codigo_producto = 21 Then nvl(m.imp_meta,0) End) IMP_SdoMetAHO, 
                       sum(Case when m.codigo_producto = 22 Then nvl(m.imp_meta,0) End) IMP_SdoMetdPF 
                 FROM tmp_fact_pasivo_prodinc_metas m
                Where ind_tipmet = 1 
                Group By m.tiempo_key,m.geografia_key,m.regionop_key,m.cod_tipage,m.ind_tipmet,
                         m.analista_key,m.des_tipana,m.fec_saldo;
           COMMIT;
           
       -----------------------------------------
       --- AGENCIAS: CUMPLE TODOS LOS PRODUCTOS
       -----------------------------------------
       --- Obtiene porcentajes de cumplimiento
       Begin
           Select tp1imp1/100,tp1imp2/100 Into ln_cummet,ln_cumaho from DWEXTRA.fst198 
            Where tp1cod1=ln_guiapr and tp1corr1 = 300 
              and tp1corr2 = 0 and tp1corr3 = 1
              and TP1NRO1 = ln_period;
       Exception When Others Then
           ln_cummet := 0; 
           ln_cumaho := 0;
       End;
       
       --- Obtiene porcentajes de cumplimiento adicional en ahorros
       Begin   
         Select tp1imp1/100 Into ln_adiaho 
           from DWEXTRA.fst198 
          Where tp1cod1=ln_guiapr and tp1corr1 = 300 
            and tp1corr2 = 0 and tp1corr3 = 2
            and TP1NRO1 = ln_period;
       Exception When Others Then
           ln_adiaho := 0; 
       End;
       
       -- Actualiza porcentajes de cumplimiento
       
        Update tmp_fact_pasivo_prodinc_res 
           set por_logacum = (case when (nvl(IMP_MetCTS,0) + nvl(IMP_MetAHO,0) + nvl(IMP_MetDPF,0)) <> 0 
                                  Then (NVL(imp_avacts,0)+nvl(imp_avaaho,0)+nvl(imp_avadpf,0))/(nvl(IMP_MetCTS,0) + nvl(IMP_MetAHO,0) + nvl(IMP_MetDPF,0))
                                  Else 0 End),  
               por_ahomes1 = (case when nvl(IMP_MetAHO,0) <> 0 
                                  Then nvl(imp_avaaho,0)/nvl(IMP_MetAHO,0)
                                  Else 0 End),
               por_pesdpc = ln_cummet,
               por_pesaho = ln_cumaho, 
               por_logcts = ln_adiaho                    
         Where ind_tipmet = 1;
        Commit; 
       
       --- AGENCIAS: CUMPLE CONSOLIDADO Y AHORROS
       Update tmp_fact_pasivo_prodinc_res 
          set ind_LogTod = 1 
        Where ind_tipmet = 1 
          and nvl(por_logacum,0) >= nvl(ln_cummet,0) 
          and nvl(por_ahomes1,0) >= nvl(ln_cumaho,0);
        Commit;  
          
       Update tmp_fact_pasivo_prodinc_res set ind_LogTod = 0 
        Where ind_tipmet = 1 
          and nvl(ind_LogTod,0) <> 1 ;
       Commit;
       
       -----------------------------
        -- REGIONES: SALDOS Y  METAS
        -----------------------------
        Begin
            Insert Into tmp_fact_pasivo_prodinc_res
                       (tiempo_key,regionop_key,fec_saldo,ind_tipmet,POR_AHOMES2,
                        imp_metcts,imp_metaho,imp_metdpf,
                        imp_avacts,imp_avaaho,imp_avadpf
                       )
                Select TIEMPO_KEY, REGIONOP_KEY,fec_saldo, 11 ind_tipmet,count(distinct geografia_key) numage,
                       sum(imp_metcts) imp_metcts, sum(imp_metaho) imp_metaho,sum(imp_metdpf) imp_metdpf,
                       sum(imp_avacts) imp_avacts, sum(imp_avaaho) imp_avaaho,sum(imp_avadpf) imp_avadpf
                  From tmp_fact_pasivo_prodinc_res where ind_tipmet = 1
              group by TIEMPO_KEY, REGIONOP_KEY,fec_saldo;
            Commit;  
        Exception When Others Then
           Null; 
        End;
        --- REGIONES: CUMPLE CONSOLIDADO Y AHORROS
        Begin
            Update tmp_fact_pasivo_prodinc_res 
               set por_logacum = (case when (nvl(IMP_MetCTS,0) + nvl(IMP_MetAHO,0) + nvl(IMP_MetDPF,0)) <> 0 
                                      Then (NVL(imp_avacts,0)+nvl(imp_avaaho,0)+nvl(imp_avadpf,0))/(nvl(IMP_MetCTS,0) + nvl(IMP_MetAHO,0) + nvl(IMP_MetDPF,0))
                                      Else 0 End),  
                   por_ahomes1 = (case when nvl(IMP_MetAHO,0) <> 0 
                                      Then nvl(imp_avaaho,0)/nvl(IMP_MetAHO,0)
                                      Else 0 End),
                   por_pesdpc = ln_cummet,
                   por_pesaho = ln_cumaho,
                   por_logcts = ln_adiaho                           
             Where ind_tipmet = 11;
            Commit; 
            
             Update tmp_fact_pasivo_prodinc_res 
                set ind_LogTod = 1 
              Where ind_tipmet = 11 
                and nvl(por_logacum,0) >= nvl(ln_cummet,0)
                and nvl(por_ahomes1,0) >= nvl(ln_cumaho,0);
              Commit;  
              
             Update tmp_fact_pasivo_prodinc_res set ind_LogTod = 0 
              Where ind_tipmet = 11
                and nvl(ind_LogTod,0) <> 1 ;
             Commit;
        Exception When Others Then
           Null; 
        End;   
       
       -------------------------------------
       -- RANKING DE AGENCIAS Y REGIONES
       -------------------------------------
       -- RANKING DE AGENCIAS
       For x in c_rnksuc Loop
           Update tmp_fact_pasivo_prodinc_res d
              set d.rnk_logage = x.rnksuc
            Where d.geografia_key = x.geografia_key
              and d.ind_tipmet = 1;  
       End Loop;  
       Commit;
       
       -- RANKING DE REGIONES
       For x in c_rnkreg Loop
           Update tmp_fact_pasivo_prodinc_res d
              set d.rnk_logage = x.rnkreg
            Where d.regionop_key = x.regionop_key
              and d.ind_tipmet = 11;  
       End Loop;  
       Commit;
       -------------------------
       -- INCENTIVOS
       -------------------------
       --- Obtiene importes pago por incentivo
       Begin
           Select tp1imp1,tp1imp2 Into ln_inmet1,ln_inaho1 
             from DWEXTRA.fst198 
            Where tp1cod1=ln_guiapr and tp1corr1 = 300 
              and tp1corr2 = 1 and trim(tp1desc) = 'RS'
              and TP1NRO1 = ln_period;
       Exception When Others Then
           ln_inmet1 := 0; 
           ln_inaho1 := 0;
       End;
       
       Begin
           Select tp1imp1,tp1imp2 Into ln_inmet2,ln_inaho2 
             from DWEXTRA.fst198 
            Where tp1cod1=ln_guiapr and tp1corr1 = 300 
              and tp1corr2 = 1 and trim(tp1desc) = 'JP'
              and TP1NRO1 = ln_period;
       Exception When Others Then
           ln_inmet2 := 0; 
           ln_inaho2 := 0;
       End;
       
       Begin
           Select tp1imp1,tp1imp2 Into ln_inmet3,ln_inaho3 
             from DWEXTRA.fst198 
            Where tp1cod1=ln_guiapr and tp1corr1 = 300 
              and tp1corr2 = 1 and trim(tp1desc) = 'SOP'
              and TP1NRO1 = ln_period;
       Exception When Others Then
           ln_inmet3 := 0; 
           ln_inaho3 := 0;
       End;
       
       Begin
           -- AGENCIAS
           Update tmp_fact_pasivo_prodinc_res r
              set r.por_dpfmes1 = ln_inmet1,
                  r.por_dpfmes2 = (case when nvl(por_ahomes1,0) >= nvl(ln_adiaho,0) 
                                        then ln_inaho1 else 0 end),
                  r.por_ctsmes1 = ln_inmet2,
                  r.por_ctsmes2 = (case when nvl(por_ahomes1,0) >= nvl(ln_adiaho,0) 
                                       then ln_inaho2 else 0 end)                      
            Where ind_tipmet = 1 
              and r.ind_logtod = 1;
           Commit; 
           
           -- REGIONES
           Update tmp_fact_pasivo_prodinc_res r
              set r.por_dpfmes1 = ln_inmet3,
                  r.por_dpfmes2 = (case when nvl(por_ahomes1,0) >= nvl(ln_adiaho,0) 
                                       then ln_inaho3 else 0 end)                    
            Where ind_tipmet = 11 
              and r.ind_logtod = 1;
           Commit; 
       Exception When Others Then
           Null;
       End;
  
  END SP_INC_RESULTADOS_OPE_V2023;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE SP_INC_RESULTADOS_NEG_V2023(PD_FECHA In Date)
  --------------------------------------------------------------
  --- Creación:
  --- Fecha: 2023.04.20
  --- Auotr: Paola Vargas 
  --- Uso  : Nueva metodología incentivos analistas y asesores
  --------------------------------------------------------------
  IS  
      Cursor c_resana 
            is Select tiempo_key,analista_key,geografia_key,des_tipana,fec_saldo,ind_tipmet,
                      sum(nvl(AHO_C,0)) ahoava,sum(nvl(DPF_C,0)) dpfava
                      from
                      (
               Select dat.*,
                      case when imp_capclit <= 0 Then 0
                           when imp_capclit > 0 and  aho <= 0 then 0  
                           when imp_capclit > 0 and  aho > 0 and dpf <= 0 then imp_capclit 
                           else aho 
                       end AHO_C, 
                      case when imp_capclit <= 0 Then 0
                           when imp_capclit > 0 and  dpf <= 0 then 0  
                           when imp_capclit > 0 and  aho <= 0 and dpf > 0 then imp_capclit 
                           else dpf
                       end DPF_C       
                 From (
               select tiempo_key,analista_key,geografia_key,des_tipana,fec_saldo,
                      cliente_key,imp_capclit,ind_tipmet,
                      sum(case when codigo_producto = '21' then imp_sdoavan - imp_sdobase else 0 end) AHO,
                      sum(case when codigo_producto = '22' then imp_sdoavan - imp_sdobase else 0 end) DPF
                from dwstage.TMP_FACT_PASIVO_PRODINC_METAS where ind_tipmet in (2,7)
               group by tiempo_key,analista_key,geografia_key,des_tipana,fec_saldo,cliente_key,ind_tipmet,imp_capclit
                ) dat)
               group by tiempo_key,analista_key,geografia_key,des_tipana,fec_saldo,ind_tipmet;

     ln_period number(6) := to_number(to_char(PD_FECHA,'rrrrmm'));
     
  BEGIN
       Delete from TMP_FACT_PASIVO_PRODINC_METAS Where IND_TIPMET in (2,7);
       Commit;
       
       ----
       -- ANALISTAS
       ----
       Insert Into TMP_FACT_PASIVO_PRODINC_METAS
                   (TIEMPO_KEY,CODIGO_PRODUCTO,GEOGRAFIA_KEY,REGIONOP_KEY,
                    IND_TIPMET,ANALISTA_KEY,DES_TIPANA,FEC_SALDO,cliente_key,
                    imp_sdobase,imp_sdoavan,IMP_CAPCLIT
                   )  
            Select dat.*,
                   sum(dat.avance-dat.base) over(partition by analista_key,cliente_key) poscli
              From(      
                   Select p.tiempo_key,p.cod_producto,
                          (case when p.ind_tipinc = 7 then p.geografia_key 
                                else p.ageana_key end) ageana_key,
                          p.regionop_key,
                          p.ind_tipinc,
                          (case when p.ind_tipinc = 2 then p.analista_key 
                                else p.asecre_key end) analista_key,
                          NVL(p.des_tipana,'NO CLASIFICADO'),
                          fec_saldo,p.cliente_key,
                          sum(nvl(p.saldo_base_mn,0)/nvl(p.ind_numtit,1)) base,  
                          sum(case when p.cod_producto='21' Then
                                   case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_avan_mn,0) 
                                        then 0 
                                        else (nvl(p.saldo_avan_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/nvl(p.ind_numtit,1)
                                   end
                                   when p.cod_producto='22' Then
                                   case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_avan_mn,0) 
                                        then 0 
                                        else (nvl(p.saldo_avan_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/nvl(p.ind_numtit,1)
                                   end
                                   when p.cod_producto='211' Then
                                   case when (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0))>nvl(p.saldo_avan_mn,0) 
                                        then 0 
                                        else (nvl(p.saldo_avan_mn,0) - (nvl(p.imp_tragob,0) + nvl(p.imp_desemb,0)))/nvl(p.ind_numtit,1)
                                   end
                                   Else 0     
                              end) avance
                         FROM TMP_FACT_PASIVO_PRODINC P
                         JOIN dwhouse.dm_geografia G ON G.Geografia_Key = P.Geografia_Key
                        Where p.ind_tipinc in (2,7)  --Analistas y Asesores
                          and g.tipo_region = 'R'
                        Group by p.tiempo_key,p.cod_producto,p.ageana_key,p.regionop_key,p.ind_tipinc,
                                 p.analista_key,NVL(p.des_tipana,'NO CLASIFICADO'),fec_saldo,p.cliente_key,
                                 (case when p.ind_tipinc = 7 then p.geografia_key else p.ageana_key end),
                                 (case when p.ind_tipinc = 2 then p.analista_key else p.asecre_key end)  
                  )dat;  
       COMMIT;
       
       ------------------------
       -- ANALISTAS: RESULTADOS
       ------------------------ 
       Delete from tmp_fact_pasivo_prodinc_res where ind_tipmet in (7,2);
       Commit;
       
       For x in c_resana Loop
           INSERT INTO TMP_FACT_PASIVO_PRODINC_RES
                 (tiempo_key,geografia_key,analista_key,des_tipana,fec_saldo,
                  cod_producto,imp_capdep,ind_tipmet,ind_regcap,ind_LogTod
                 ) 
           Select x.tiempo_key,x.geografia_key,x.analista_key,x.des_tipana,x.fec_saldo,
                  '21',x.ahoava,x.ind_tipmet,1,0 from dual
           union all
           Select x.tiempo_key,x.geografia_key,x.analista_key,x.des_tipana,x.fec_saldo,
                  '22',x.dpfava,x.ind_tipmet,1,0 from dual;
           Commit;       
       End Loop;
           
       -- INSERTA ANALISTAS QUE NO CAPTARON
       Begin
           INSERT INTO tmp_fact_pasivo_prodinc_res
                     (tiempo_key,geografia_key,analista_key,fec_saldo,
                      cod_producto,imp_capdep,ind_tipmet,ind_regcap,ind_LogTod,des_tipana
                     )
              SELECT tiempo_key,ageana_key,analista_key,PD_FECHA,
                     '21' codpro,0,ind_regcli,0,0,
                     (SElect nvl(trim(tp1desc),'JUNIOR') 
                        From DWEXTRA.fst198 z where tp1cod1=10819 and tp1corr1=303 
                         and z.tp1corr2 = p.tp1nro1
                     ) Tipo  
                From TMP_FACT_PASIVO_CLICAP an
                Join DWEXTRA.fst198 p on tp1cod1=10819 and tp1corr1=302 
                 and tp1corr3 = ln_period
                 and trim(p.tp1desc) = an.cod_anacre
               Where ind_regcli = 2 and fec_regcli is null
                     UNION ALL
              SELECT distinct tiempo_key,ageana_key,analista_key,PD_FECHA,
                     '21' codpro,0,ind_regcli,1,0,
                      (SElect nvl(trim(tp1desc),'JUNIOR') 
                         From DWEXTRA.fst198 z where tp1cod1=10819 and tp1corr1=303 
                          and z.tp1corr2 = p.tp1nro1
                      ) Tipo  
                 From TMP_FACT_PASIVO_CLICAP an
                 Join DWEXTRA.fst198 p on tp1cod1=10819 and tp1corr1=302 
                  and tp1corr3 = ln_period
                  and trim(p.tp1desc) = an.cod_anacre
                Where ind_regcli = 2 and fec_Regcli is not null
                  and not exists (select 1 from tmp_fact_pasivo_prodinc_res r 
                                   where r.ind_tipmet = 2 
                                     and r.analista_key = an.analista_key
                                  );        
           Commit;     
       Exception When Others Then
          Null;
       End;              
       
       -----------------------------------------
       --- ANALISTAS: CAPTACIONES
       -----------------------------------------
       --- CUMPLE TODOS LOS PRODUCTOS
       BEGIN
           Update TMP_FACT_PASIVO_PRODINC_RES res 
              set ind_logtod = 1
            Where ind_tipmet = 2
              and exists (select 1 
                             from (select analista_key,sum(nvl(imp_capdep,0)) imp_capdep
                                     from tmp_fact_pasivo_prodinc_res
                                    where ind_tipmet = 2
                                    group by analista_key
                                    having sum(nvl(imp_capdep,0)) > 0
                                  ) tab 
                            where tab.analista_key= res.analista_key);
            COMMIT;  
       Exception When Others Then
          Null;
       End;                 
  END SP_INC_RESULTADOS_NEG_V2023;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE SP_INC_SALDOS_AGE_V2023(PD_FECHA In Date)
  -- Fecha: 2023.04.20
  -- Autor: Paola Vargas
  -- Uso  : Nueva metodología de incentivos para gerentes de agencia
  IS
      ld_fecini date := to_date(to_char(PD_FECHA,'rrrrmm')||'01','rrrrmmdd');
      ld_fecfin date := PD_FECHA;
      ln_tiempo number(10) := dwhouse.pq_carga_facts.fn_tiempo_key(ld_fecfin);
      ln_tieuno number(10) := dwhouse.pq_carga_facts.fn_tiempo_key(ld_fecini);
  BEGIN
      -- LIMPIA TABLAS
      Delete From tmp_fact_pasivo_prodinc_metas Where tiempo_key = ln_tiempo and ind_tipmet = 9;
      Commit;
      
      --- SALDOS 
      Execute Immediate 
             'INSERT INTO tmp_fact_pasivo_prodinc_metas'||
                         '(tiempo_key,codigo_producto,geografia_key,ind_tipmet,fec_saldo,'||
                         'imp_sdoavan,imp_sdobase,imp_apecta,imp_desemb,imp_meta) '||
                 'Select ps.tiempo_key,pr.codigo_producto,ps.geografia_key,9,:1,sum(ps.saldo_mn),'||
                        'sum(ps.saldo_mn) saldo_neto,'||
                        '0 importe_apedig,'|| 
                        '0 imp_desemb, met.imp_meta '||       
                  'From dwhouse.fact_pasivo ps '||
                  'Join dwhouse.dm_producto pr on pr.producto_key = ps.producto_key '||
                  'Left Join (Select geografia_key,pm.codigo_producto,sum(meta_saldo_mn) imp_meta '||
                              'from dwhouse.fact_pasivo_meta_agencia mt '||
                              'Join dwhouse.dm_producto pm on pm.producto_key = mt.producto_key '||
                             'where tiempo_key =  :3'||
                             'Group By tiempo_key,geografia_key,pm.codigo_producto '||
                             ') met on met.geografia_key = ps.geografia_key '||
                                  'and met.codigo_producto = pr.codigo_producto '||
               'Where ps.tiempo_key = :4 '|| --
                 'and ps.estado_key <> 72 '||
                 'and ps.geografia_key <> 7 '||
               'Group by ps.tiempo_key,pr.codigo_producto,ps.geografia_key,met.imp_meta'
            Using ld_fecfin,ln_tieuno,ln_tiempo;
    Commit;
 
  END SP_INC_SALDOS_AGE_V2023;
  ----------------------------------------------------------------------------------------
  PROCEDURE SP_INC_RESULTADOS_AGE_V2023(PD_FECHA In date)
  -- Fecha: 2023.04.20
  -- Autor: Paola Vargas
  -- Uso  : Nueva metodología de pago de incentivos a gerentes de agencia, zona y región
  IS
    ln_tiempo number(10) := dwhouse.pq_carga_facts.fn_tiempo_key(PD_FECHA);
    ln_period number(8) := to_number(to_char(PD_FECHA,'yyyymm'));
    ld_diauno date := to_date(to_char(PD_FECHA,'yyyymm')||'01','rrrrmmdd');
    ln_tieuno number(10) := dwhouse.pq_carga_facts.fn_tiempo_key(ld_diauno);
    ln_minage number(15,6) := 0.95;
    ln_porana number(15,6) := 0.80;
    ln_pagage number(12,2) := 500;
    ln_minzon number(15,6) := 0.95;
    ln_pagzon number(12,2) := 700;
    ln_minreg number(15,6) := 0.95;
    ln_pagreg number(12,2) := 1000;
    ln_guiapr number(5) := 10819;
    ln_capana number(12,2) := 500;
    
    Cursor c_metas(ln_tie in Number)
        is Select geografia_key,sum(meta_saldo_mn) imp_meta 
             from dwhouse.fact_pasivo_meta_agencia mt 
            Where tiempo_key =  ln_tie
            Group By tiempo_key,geografia_key;

  BEGIN
    
    --- Limpia tabla
    --90:Agencia / 91:Zonas / 92:Regiones
    Delete from tmp_fact_pasivo_prodinc_res where tiempo_key = ln_tiempo and ind_tipmet in (90,91,92);
    Commit;
    
    
    --- Limpia e Inserta tabla de captacion por analistas
    Begin
          Execute Immediate 'Truncate table TMP_FACT_PASIVO_PRODINC_ANA';
          
          
          Insert Into TMP_FACT_PASIVO_PRODINC_ANA(fecha,analista_key,geografia_key,imp_captado)          
               Select fec_saldo,analista_key,geografia_key, sum(nvl(imp_capdep,0))
                 From tmp_fact_pasivo_prodinc_res
                Where ind_tipmet = 2 
                  and tiempo_key = ln_tieuno
                  and fec_saldo = PD_FECHA
                  and nvl(ind_logtod,0) = 1
                  and nvl(ind_logtod,0) = 1
             Group By fec_saldo,analista_key,geografia_key;
    Exception When Others Then
        Null;
    End;  
    
    
    -- Agencias
    Insert Into tmp_fact_pasivo_prodinc_res
                (tiempo_key,geografia_key,ind_tipmet,fec_saldo,cod_zona,
                 des_zona,imp_metaho,imp_basaho,imp_avaaho,por_logaho,
                 cod_region,des_region,imp_avacts,imp_avadpf)
         Select ps.tiempo_key,ps.geografia_key,90,ps.fec_saldo,ge.codigo_zona,
                ge.nombre_zona,
                sum(ps.imp_meta),
                sum(ps.imp_sdoavan) sdobruto,
                sum(ps.imp_sdobase) sdoneto,
                (case when sum(ps.imp_meta) <> 0 then round(sum(ps.imp_sdobase)/sum(ps.imp_meta),8) else 0 end) logro,
                ge.codigo_region,ge.nombre_region,
                (select count(an.tp1desc) from DWEXTRA.fst198 an 
                   Join dwhouse.dm_geografia ge on to_number(ge.codigo_agencia) = an.tp1imp2 and ge.tipo_region = 'R'
                  where tp1cod1=10819 
                    and tp1corr1=302 and tp1corr3 = ln_period 
                    and tp1imp1=1 and ge.geografia_key = ps.geografia_key
                 ) tot_analistas,
                 (select count(distinct analista_key) 
                    From TMP_FACT_PASIVO_PRODINC_ANA
                   Where geografia_key = ps.geografia_key
                     and nvl(imp_captado,0) >= 500 
                    /*from tmp_fact_pasivo_prodinc_res  
                   Where ind_tipmet = 2 and tiempo_key = ln_tieuno
                     and fec_saldo = PD_FECHA
                     and geografia_key = ps.geografia_key
                     and ind_regcap = 1
                     and nvl(ind_logtod,0) = 1
                     and (nvl(imp_capdep,0)) > 500*/
                 ) num_anacap  
           From tmp_fact_pasivo_prodinc_metas ps
           Join dwhouse.dm_geografia ge on ge.geografia_key = ps.geografia_key
          Where ind_tipmet = 9
            and ge.tipo_region = 'R'
            and ge.codigo_agencia <> '904'
          Group by ps.tiempo_key,ps.geografia_key,ps.fec_saldo,ge.codigo_zona,ge.nombre_zona,
                   ge.codigo_region,ge.nombre_region;
    Commit;
    
    -- Actualiza Metas
    /*For x In c_metas(ln_tieuno) Loop
        Update tmp_fact_pasivo_prodinc_res rs
           set imp_metaho = nvl(x.imp_meta,0)
         Where rs.geografia_key = x.geografia_key
           and rs.ind_tipmet = 90
           and rs.tiempo_key = ln_tiempo;      
    End Loop;
    Commit;*/
    
    -- Zonas
    Insert Into tmp_fact_pasivo_prodinc_res
                (tiempo_key,cod_zona,des_zona,ind_tipmet,fec_saldo,
                 imp_metaho,imp_basaho,imp_avaaho,por_logaho)
         Select tiempo_key,cod_zona,des_zona,91,fec_saldo,
                sum(imp_metaho),sum(imp_basaho),sum(imp_avaaho),
                case when sum(imp_metaho) <> 0 Then sum(imp_avaaho)/sum(imp_metaho) else 0 end
           From tmp_fact_pasivo_prodinc_res
          Where ind_tipmet = 90
            and tiempo_key = ln_tiempo
          Group By tiempo_key,cod_zona,des_zona,fec_saldo;                
    Commit;             
                 
    -- Regiones 
    Insert Into tmp_fact_pasivo_prodinc_res
                (tiempo_key,cod_region,des_region,ind_tipmet,fec_saldo,
                 imp_metaho,imp_basaho,imp_avaaho,por_logaho)
         Select tiempo_key,cod_region,des_region,92,fec_saldo,
                sum(imp_metaho),sum(imp_basaho),sum(imp_avaaho),
                case when sum(imp_metaho) <> 0 Then round(sum(imp_avaaho)/sum(imp_metaho),8) else 0 end
           From tmp_fact_pasivo_prodinc_res
          Where ind_tipmet = 90
            and tiempo_key = ln_tiempo
          Group By tiempo_key,cod_region,des_region,fec_saldo;                
    Commit;     
    
    -------------------------
    --- Parametros de logros
    -------------------------
    --- Obtiene porcentaje de logro y pago de gerentes de agencia   
     Begin
         select d.tp1imp1/100,d.tp1imp2/100,d.tp1imp3,tp1nro2
          Into ln_minage,ln_porana,ln_pagage,ln_capana
          from DWEXTRA.fst198 d
         where tp1cod1=ln_guiapr 
           and tp1corr1 = 300 
           and tp1corr2 = 3
           and tp1corr3 = 3 -- Ger.Agencia
           and tp1nro1  = ln_period;
     Exception When Others Then
        ln_minage := 1;
        ln_porana := 0.8;
        ln_pagage := 500; 
        ln_capana := 500;
     End;   
     
     --- Obtiene porcentaje de logro y pago de gerentes de zona
     Begin
         select d.tp1imp1/100,d.tp1imp3 Into ln_minzon,ln_pagzon
          from DWEXTRA.fst198 d
         where tp1cod1=ln_guiapr 
           and tp1corr1 = 300 
           and tp1corr2 = 3
           and tp1corr3 = 4 -- Ger.Zona
           and tp1nro1  = ln_period;
     Exception When Others Then
        ln_minzon := 1;
        ln_pagzon := 700;
     End;   
     
     --- Obtiene porcentaje de logro y pago de gerentes de region
     Begin
         select d.tp1imp1/100,d.tp1imp3 Into ln_minreg,ln_pagreg
          from DWEXTRA.fst198 d
         where tp1cod1=ln_guiapr 
           and tp1corr1 = 300 
           and tp1corr2 = 3
           and tp1corr3 = 5 -- Ger.Region
           and tp1nro1  = ln_period;
     Exception When Others Then
        ln_minreg := 1;
        ln_pagzon := 1000;
     End;  
     
    
    --- Logros y Pagos
    Update tmp_fact_pasivo_prodinc_res m
       set m.ind_logtod = (case when nvl(m.por_logaho,0) >= ln_minzon Then 1 else 0 end),
           m.imp_pagmes = (case when nvl(m.por_logaho,0) >= ln_minzon Then ln_pagzon else 0 end)
     Where ind_tipmet = 91
       and tiempo_key = ln_tiempo;  
    Commit;
    
    Update tmp_fact_pasivo_prodinc_res m
       set m.ind_logtod = (case when nvl(m.por_logaho,0) >= ln_minreg Then 1 else 0 end),
           m.imp_pagmes = (case when nvl(m.por_logaho,0) >= ln_minreg Then ln_pagreg else 0 end)
     Where ind_tipmet = 92
       and tiempo_key = ln_tiempo;  
    Commit;     

    Update tmp_fact_pasivo_prodinc_res m
       set m.ind_logtod = (case when nvl(m.por_logaho,0) >= ln_minage  
                                 and decode(nvl(m.imp_avacts,0),0,0,nvl(m.imp_avadpf,0)/nvl(m.imp_avacts,0)) >= ln_porana
                                Then 1 else 0 end),
           m.imp_pagmes = (case when nvl(m.por_logaho,0) >= ln_minage  
                                 and decode(nvl(m.imp_avacts,0),0,0,nvl(m.imp_avadpf,0)/nvl(m.imp_avacts,0)) >= ln_porana
                                Then ln_pagage else 0 end),
           m.por_logdpf = (case when nvl(m.imp_avacts,0) = 0 then 0 else round(nvl(m.imp_avadpf,0)/nvl(m.imp_avacts,0),8) end)                       
     Where ind_tipmet = 90
       and tiempo_key = ln_tiempo;  
    Commit;
    
  END SP_INC_RESULTADOS_AGE_V2023;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- ---- -- -- -- -- -- -- -- -- -- -- -- --
  
  PROCEDURE SP_INC_EJECUTA_V2023(PD_FECHA In Date)
  ----------------------------------------------------------------------
  -- Fecha: 2023.04.19
  -- Autor: Paola Vargas
  -- Uso  : Nueva metodología de incentivos desde abril 2023
  ----------------------------------------------------------------------    
  IS
        ld_fecha date := PD_FECHA;
  BEGIN
       PQ_TMP_PRODUCTIVIDADASE.SP_INC_METAS_V2023(ld_fecha);
       PQ_TMP_PRODUCTIVIDADASE.SP_INC_REGCLI(ld_fecha);
       PQ_TMP_PRODUCTIVIDADASE.SP_INC_SALDOS(ld_fecha);
       PQ_TMP_PRODUCTIVIDADASE.SP_INC_CLASIFICA_DEP(ld_fecha);
       PQ_TMP_PRODUCTIVIDADASE.SP_INC_APERTURA_DIG(ld_fecha);
       PQ_TMP_PRODUCTIVIDADASE.SP_INC_ACT_METAAGE_V2023(ld_fecha);
       PQ_TMP_PRODUCTIVIDADASE.SP_INC_RESULTADOS_OPE_V2023(ld_fecha);
       PQ_TMP_PRODUCTIVIDADASE.SP_INC_RESULTADOS_NEG_V2023(ld_fecha);
       
       PQ_TMP_PRODUCTIVIDADASE.SP_INC_SALDOS_AGE_V2023(ld_fecha);
       PQ_TMP_PRODUCTIVIDADASE.SP_INC_RESULTADOS_AGE_V2023(ld_fecha);

  End SP_INC_EJECUTA_V2023;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- -- --   
  PROCEDURE SP_EJECUTA_PRODEJE_INCEN(PD_FECHA In date)
  IS
    ld_fecha  date := PD_FECHA;--trunc(sysdate-1);
    ln_timek  number(10) := dwhouse.pq_carga_facts.fn_tiempo_key(ld_fecha);
    ln_exist  number(10);
    ln_ejepre varchar2(2);
    ln_ejeinc varchar2(2);
  BEGIN
       -- Revisa si ejecuta productividad de ejecutivos
       Begin
           Select p.valor Into ln_ejepre
             From dwhouse.bi_parametro p
            Where p.parametro_key = '12';
       Exception When Others Then
           ln_ejepre := 'N';
       End;
       
       -- Revisa si ejecuta productividad de ejecutivos
       Begin
           Select p.valor Into ln_ejeinc
             From dwhouse.bi_parametro p
            Where p.parametro_key = '13';
       Exception When Others Then
           ln_ejeinc := 'N';
       End;
        
       Select count(*) Into ln_exist From dwhouse.fact_pasivo where tiempo_key = ln_timek; 
       
       If ln_exist > 0 Then 
          dwstage.PQ_TMP_PRODUCTIVIDADASE.SP_REGISTRO_CLIENTES(ld_fecha);
          /*
          IF ln_ejepre = 'S' Then
             dbms_scheduler.create_job(
                  job_name=> 'SQJ_PROD_EJECUTIVOS',
                  job_type=> 'PLSQL_BLOCK',
                  job_action=> 'Begin PQ_TMP_PRODUCTIVIDADASE.SP_JOB_PRODEJE('''||to_char(ld_fecha,'rrrrmmdd')||'''); End;',
                  start_date => sysdate+1/(24*180),
                  enabled => true, 
                  auto_drop=> TRUE,
                  comments => 'SJOB PROD.EJECUTIVOS'
                 );   
          End If;
          */
          If ln_ejeinc = 'S' Then
             dbms_scheduler.create_job(
                  job_name=> 'SQJ_PPAS_INCENTIVOS',
                  job_type=> 'PLSQL_BLOCK',
                  job_action=> 'Begin PQ_TMP_PRODUCTIVIDADASE.SP_JOB_INCENTIVOS('''||to_char(ld_fecha,'rrrrmmdd')||'''); End;',
                  start_date => sysdate+1/(24*180),
                  enabled => true, 
                  auto_drop=> TRUE,
                  comments => 'SJOB PPAS INCENTIVOS'
                  ); 
           End If;
       
        End If;
         
  END SP_EJECUTA_PRODEJE_INCEN;
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- -- --
  PROCEDURE SP_JOB_DESEM_CUENTA(PD_FECHA In Date)
  IS
    ld_fecha date := PD_FECHA;
  BEGIN
     dbms_scheduler.create_job(
                  job_name=> 'SQJ_DESEM_CUENTA',
                  job_type=> 'PLSQL_BLOCK',
                  job_action=> 'Begin PQ_TMP_PRODUCTIVIDADASE.SP_DESEM_CUENTA('''||to_char(ld_fecha,'rrrrmmdd')||'''); End;',
                  start_date => sysdate+1/(24*180),
                  enabled => true, 
                  auto_drop=> TRUE,
                  comments => 'SJOB DESEMBOLSO EN CUENTA'
                 );   
  END SP_JOB_DESEM_CUENTA;   
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- -- --
  PROCEDURE SP_JOB_PRODEJE(PV_FECHA In Varchar2)
  IS
    ld_fecha date := to_date(PV_FECHA,'rrrrmmdd');
  BEGIN
     pq_tmp_productividadase.SP_PRAS_EJECUTA(ld_fecha);
     dwhouse.PQ_CARGA_PRODUCTIVIDAD.fact_pasivos_proase_v2(ld_fecha); 
  END SP_JOB_PRODEJE;  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- -- --
  PROCEDURE SP_JOB_INCENTIVOS(PV_FECHA In Varchar2)
  IS
    ld_fecha date := to_date(PV_FECHA,'rrrrmmdd');
    --ln_job number(5);
  BEGIN
     PQ_TMP_PRODUCTIVIDADASE.SP_INC_EJECUTA_V2023(ld_fecha);
     dwhouse.pq_carga_productividad.SP_CARGA_PRODINC_V2023(ld_fecha);
     -- RETENCION        
     If to_number(to_char(ld_fecha,'DD'))<= 20 Then
        PQ_TMP_PRODUCTIVIDADASE.SP_INC_RETENCION_V2023(ld_fecha);
        dwhouse.PQ_CARGA_PRODUCTIVIDAD.SP_PRODINC_RETENCION(ld_fecha); 
     End If;
     
        
     dbms_scheduler.create_job(
                  job_name=> 'SQJ_PROD_EJECUTIVOS',
                  job_type=> 'PLSQL_BLOCK',
                  job_action=> 'Begin PQ_TMP_PRODUCTIVIDADASE.SP_JOB_PRODEJE('''||to_char(ld_fecha,'rrrrmmdd')||'''); End;',
                  start_date => sysdate+1/(24*180),
                  enabled => true, 
                  auto_drop=> TRUE,
                  comments => 'SJOB PROD.EJECUTIVOS'
                 );   
     
     
     
  END SP_JOB_INCENTIVOS;   
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- -- --
  FUNCTION FN_PRAS_SALDO_DESFASE(PN_TIEMPO In Number, -- MES ANTERIOR
                                 PD_FECSDO In Date,   -- MES ANTERIOR
                                 PN_ASEKEY In Number,
                                 PN_TIPREG In Number,
                                 PN_NIVEJE In Number,
                                 PN_INDDES In Number,
                                 PN_IMPDES In Number 
                                )
  RETURN Number
  -- 2023.08.20
  Is
    ln_sdodes Number(12,2);
    lv_codase varchar2(20);
    ln_inddes Number(1) := 1;
    ln_mes    number(2) := to_number(to_char(PD_FECSDO,'mm'));
  Begin
    
     If PN_INDDES = 1 THEN  
        ln_sdodes := 0;
     Elsif ln_mes <> 12 and PD_FECSDO >= to_date('20230930','rrrrmmdd') 
        --and PN_NIVEJE <> 4 and PN_INDDES = 1 
     Then 
        IF to_char(PD_FECSDO,'MM') = '10' Then
           ln_inddes := 0;
           ln_sdodes := 0;
           Begin
               Select trim(f.codigo_asesor) Into lv_codase
                 From dwhouse.dm_asesor f
                Where f.asesor_key = PN_ASEKEY; 
           Exception When Others Then
               lv_codase := null;
           End;   
        END IF;  
        
        If /*(ln_inddes = 0 and lv_codase not in ('MVALLEA','HDELC','ZCARDENAS'))
            Or*/ ln_inddes = 1
        Then    
            
                Begin                                  
                    Select (nvl(saldo_avance,0) + nvl(saldo_captado,0)) - nvl(saldo_meta,0) 
                      Into ln_sdodes
                      From dwhouse.fact_pasivos_proase 
                     Where tiempo_key = PN_TIEMPO
                       and fecha_sld = PD_FECSDO 
                       and asesor_key = PN_ASEKEY 
                       and tipreg = PN_TIPREG;
                Exception When Others Then
                    ln_sdodes := 0;
                End;     
            
        End IF;
        
        If NVL(PN_IMPDES,0) > 0 THEN 
           ln_sdodes := PN_IMPDES;
        ElsIf ln_sdodes < 0 Then ln_sdodes := ln_sdodes * -1;
        Elsif ln_sdodes >= 0 Then ln_sdodes := 0;
        End If;
     ELSE
        ln_sdodes := 0; 
     END IF;  
     
     Return ln_sdodes; 
  
  End FN_PRAS_SALDO_DESFASE;       
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- -- --
  Procedure SP_FACT_PRODASE_RENDPF(PD_FECHA In Date)
  Is
   Cursor c_venc(ld_fec in Date)  is
           Select d.cuentas_key,d.cliente_key,d.fecha_vencimie,d.saldo_mn,d.moneda_key,c.fecha_cancelac,c.cuenta,
                  c.codigo_cuenta,c.cuenta_unica,k.pais,to_number(k.tipo_documento) tdoc, k.numero_documento ndoc,
                  d.geografia_key
            From TMP_FACT_PRODASE_ASIGCLI d
            Join dwhouse.dm_cuentas c on c.cuentas_key = d.cuentas_key
            Join dwhouse.dm_cliente k on k.cliente_key = d.cliente_key
           Where d.codigo_producto = '22'  
             and d.est_asesor = 'S'
             --and d.codigo_cliente = '6042129658290'
             --and d.codigo_cliente = '6042144218114' 
             --and d.fecha_cancela is not null
             and d.fecha = ld_fec;
   
   Cursor c_renm(ld_fec In Date) is
          Select --distinct d.cliente_key,k.pais,to_number(k.tipo_documento) tdoc, k.numero_documento ndoc
            d.cliente_key,k.pais,to_number(k.tipo_documento) tdoc, k.numero_documento ndoc,
            min(d.fecha_vencimie) fecven
            From TMP_FACT_PRODASE_ASIGCLI d
            Join dwhouse.dm_cliente k on k.cliente_key = d.cliente_key
           Where d.codigo_producto = '22'  
             and d.est_asesor = 'S'
             and d.fecha_cancela is not null
             and d.cuenta_ren_key is Null
             and d.fecha = ld_fec
             --and d.codigo_cliente = '6042129658290'
             group by d.cliente_key,k.pais,to_number(k.tipo_documento) , k.numero_documento 
             ;--and d.codigo_cliente = '6042107831309';
             
   Cursor c_ctanue(ln_ppais in Number,ln_ptdoc in Number, lc_pndoc In Char, 
                   ln_tc in Number,ld_fpr in Date,ld_fin in Date) is
          Select c.fecha_apertura,decode(c.moneda_key,1,c.imp_apertura,c.imp_apertura*ln_tc) imp_mn,
                 c.cuentas_key,c.codigo_cuenta,c.cod_cuenta,c.cuenta
            From dwhouse.dm_cuentas c
           Where c.codigo_cuenta like '22-%'
             --and to_number(to_char(c.fecha_apertura,'rrrrmm')) = ln_per
             and c.fecha_apertura >= ld_fin
             and c.fecha_apertura <= ld_fpr
             and (c.fecha_cancelac is null or c.fecha_cancelac > ld_fpr)
             and c.cuenta in (select ctnro from dwextra.fsr008 r 
                               Where r.pepais = ln_ppais and r.petdoc=ln_ptdoc 
                                 and r.pendoc = lc_pndoc
                                 --and r.cttfir = 'T'
                              )
           Order by c.fecha_apertura asc,c.moneda_key desc;
                   
   Cursor c_renc(ln_cli in Number,ld_fec in Date,ld_fecp In Date) is 
          Select d.cuentas_key,d.cliente_key,d.fecha_vencimie,d.moneda_key,
                 c.fecha_cancelac,/*d.saldo_mn,*/
                 (nvl(d.saldo_mn,0)- nvl(d.imp_renovmn,0)) saldo_mn,
                 c.codigo_cuenta, count(*) over(partition by d.cliente_key) ctacan 
            From TMP_FACT_PRODASE_ASIGCLI d
            Join dwhouse.dm_cuentas c on c.cuentas_key = d.cuentas_key
           Where d.codigo_producto = '22'  
             and d.est_asesor = 'S'
             and d.fecha_cancela is not null
             and d.cliente_key = ln_cli
             and nvl(d.ind_insact,0) <> 2
             --and ld_fec >= c.fecha_cancelac 
             --and d.cuenta_ren_key Is Null
             and ((d.cuenta_ren_key Is Null) or (nvl(d.imp_renovmn,0) < nvl(d.saldo_mn,0))) --NUEVO
             and d.fecha = ld_fecp 
           Order By d.fecha_vencimie asc,
                    c.fecha_cancelac,c.moneda_key asc,d.saldo_mn Desc ;    
     
     ld_diauno date := to_date(to_char(PD_FECHA,'rrrrmm')||'01','rrrrmmdd');
     ld_feccon date := PD_FECHA; 
     ln_cntkey number(10);
     ln_tcambi number(7,3) := pq_tmp_productividadase.fn_tipo_cambio_fijo(ld_feccon);
     ln_sldren number(12,2);
     lv_ctaren varchar2(40);
     ld_candpf date;
     --ld_feccal date := to_date(to_char(add_months(ld_feccon,1),'rrrrmm')||'20','rrrrmmdd');
     ld_feccal date := ld_feccon;
     ln_tickey number(10);
     ln_sldape number(12,2);
     ln_ultren number(10);
     ln_period number(6) := to_number(to_char(PD_FECHA,'rrrrmm'));
     ln_indren Number(1);
     ln_ctaren Number(5);
     ld_aperen date;
     ln_plazo  number(5);
     ld_Fecsld date;
     ln_ren number(10);
     --> 2023.10.30
     ln_ctacli number(10);
     ln_titcta number(5);
     --< 2023.10.30
Begin
     Update TMP_FACT_PRODASE_ASIGCLI d 
        set d.Codigo_Ctaren=null, d.cuenta_ren_key=null,d.imp_renovmn=null,
            d.ind_tipren = null, d.ind_ctaren = null
      Where d.codigo_producto = '22';
     Commit;
     
     For x In c_venc(ld_diauno) Loop
         ln_titcta := null;
         ld_Fecsld := x.fecha_vencimie;
         -- Renovacion automática
         Begin 
              Select c.cuentas_key,c.cod_cuenta,
                     c.fecha_cancelac, c.fecha_renovaci,c.plazo,c.cuenta
                Into ln_cntkey,lv_ctaren,ld_candpf,ld_aperen,ln_plazo,ln_ctacli
                From dwhouse.dm_cuentas c
               Where c.cuenta_unica = x.cuenta_unica
                 and (c.fecha_renovaci = x.fecha_cancelac or
                      c.fecha_renovaci = x.fecha_vencimie
                     );
         Exception When Others Then
           ln_cntkey := null;
         End;
         
         -- Plazo Fijo con renovacion menor a 50 días
         IF (ld_candpf Is Not Null and ld_candpf <=ld_feccal and ln_plazo<=50)
         Then
             Begin 
                  Select c.cuentas_key,c.cod_cuenta,
                         c.fecha_cancelac, c.fecha_renovaci,c.cuenta
                    Into ln_cntkey,lv_ctaren,ld_candpf,ld_aperen,ln_ctacli
                    From dwhouse.dm_cuentas c
                   Where c.cuenta_unica = x.cuenta_unica
                     and c.fecha_renovaci = ld_candpf;
                  
                  ld_Fecsld :=  ld_aperen;  
             Exception When Others Then
               ln_cntkey := null;
             End;
             
         End If;
         
         If (ln_cntkey Is Not Null and 
             ((ld_candpf Is Null) Or
              (ld_candpf Is Not Null and ld_candpf >=ld_feccal) 
             )
            )
         Then
            -- Importe de capital
            Begin
               If ld_candpf Is Null Then
                 
                  ln_tickey := dwhouse.pq_carga_facts.fn_tiempo_key(ld_Fecsld);
                  Begin
                    Select s.saldo_mn Into ln_sldren
                      From dwhouse.fact_pasivo s
                     Where s.cuentas_key = ln_cntkey
                       and s.tiempo_key = ln_tickey;
                  Exception When Others Then
                    ln_sldren := 0;
                       --- Buscar un día posterior a la renovación
                       ln_tickey := dwhouse.pq_carga_facts.fn_tiempo_key(ld_Fecsld+1);
                       Begin
                          Select s.saldo_mn Into ln_sldren
                            From dwhouse.fact_pasivo s
                           Where s.cuentas_key = ln_cntkey
                             and s.tiempo_key = ln_tickey;
                       Exception When Others Then
                          ln_sldren := 0;
                    
                       End;  
                  End;    
                   
                  If nvl(ln_sldren,0) = 0 Then
                     ln_tickey := dwhouse.pq_carga_facts.fn_tiempo_key(x.fecha_cancelac);
                     Begin
                        Select s.saldo_mn Into ln_sldren
                          From dwhouse.fact_pasivo s
                         Where s.cuentas_key = ln_cntkey
                           and s.tiempo_key = ln_tickey;
                     Exception When Others Then
                        ln_sldren:= 0;
                     End;      
                  End If;     
               Else 
                   ln_tickey := dwhouse.pq_carga_facts.fn_tiempo_key(ld_candpf-1);
                   Select s.saldo_mn Into ln_sldren
                     From dwhouse.fact_pasivo s
                    Where s.cuentas_key = ln_cntkey
                      and s.tiempo_key = ln_tickey;
               End If;
            Exception When Others Then
                      ln_sldren := 0 ;
            End;
            
            If ln_sldren >= 0 Then       
               --> 2023.10.29 Nro titulares cuenta renovada
               Select count(*)
                 Into ln_titcta
                 From dwextra.fsr008 
                Where ctnro = ln_ctacli; 
               --< 2023.10.29   
            
             
                Update TMP_FACT_PRODASE_ASIGCLI d
                   set d.cuenta_ren_key = ln_cntkey,
                       d.codigo_ctaren = lv_ctaren,
                       d.imp_renovmn  = ln_sldren,
                       d.ind_tipren   = 0,
                       d.ind_ctaren   = 1,
                       d.ind_tipreg   = 2,
                       d.ind_insact   = 1,
                       d.imp_tipcam   = ln_tcambi, 
                       d.fecha_cancela= x.fecha_cancelac,
                       d.fecha_apre   = ld_aperen,
                       d.ind_titren   = ln_titcta
                 Where d.cuentas_key = x.cuentas_key
                   and nvl(ind_insact,0) <> 2 ;
                 Commit;    
             End If;  
       End If;
     End Loop; --FIN:Renovacion Automática
   
     -- Renovacion Manual
     ln_ultren := null;
     ld_aperen := null;
     For x in c_renm(ld_diauno) Loop
         For y In c_ctanue(x.pais,x.tdoc,x.ndoc,ln_tcambi,ld_feccal,/*ld_diauno*/x.fecven) Loop
             
             ln_sldape := y.imp_mn;
             ld_aperen := y.fecha_apertura;
             ln_ctaren := 0;  
             
             For z In c_renc(x.cliente_key,y.fecha_apertura,ld_diauno) Loop
                 ln_ctaren := ln_ctaren + 1;
                 
                 If nvl(ln_sldape,0) >= nvl(z.saldo_mn,0) and ln_ctaren = z.ctacan Then 
                   ln_sldren := ln_sldape;
                   ln_sldape := 0;
                 ElsIf nvl(ln_sldape,0) >= nvl(z.saldo_mn,0) and ln_ctaren < z.ctacan Then
                   ln_sldren := nvl(z.saldo_mn,0);
                   ln_sldape := ln_sldape - nvl(z.saldo_mn,0); 
                 Else
                   ln_sldren := nvl(ln_sldape,0);
                   ln_sldape := 0;
                 End If; 
                 
                 ln_ultren := z.cuentas_key;
                 ln_indren := 1;
                 
                 If nvl(ln_sldren,0) > 0 and ln_ctaren > 0 Then
                    --> 2023.06.20 Revisar si ya tiene dato actualizado 
                    /*Begin
                        Select cuenta_ren_key Into ln_ren
                          From TMP_FACT_PRODASE_ASIGCLI g 
                         Where g.cuentas_key = z.cuentas_key
                         and rownum = 1;
                    Exception When Others Then
                       ln_ren := null;
                    End;   
                    If ln_ren Is not Null Then
                       Insert Into TMP_FACT_PRODASE_ASIGCLI
                                  (fecha,tiempo_key,codigo_asesor,asesor_key,cliente_key,
                                   codigo_cliente,saldo_mn,saldo_mo,cuentas_key,
                                   codigo_cuenta,imp_renovmn,ind_ctaren,ind_tipren,
                                   codigo_producto,codigo_subproducto,fecha_vencimie,fecha_cancela,cod_cuenta,
                                   imp_tipcam,ind_tipreg,ind_insact,nombre_subproducto,
                                   fecha_renovaci,estado_key,nombre_producto,producto_key,empleador_key,
                                   moneda_key,codigo_empleador,est_asesor,fecha_apre,Geografia_Key,
                                   cuenta_ren_key,codigo_ctaren
                                  )
                           Select fecha,tiempo_key,codigo_asesor,asesor_key,cliente_key,codigo_cliente,0 saldo_mn, 0 saldo_mo,
                                  m.cuentas_key,m.codigo_cuenta,(ln_sldren + nvl(m.imp_renovmn,0))
                                  ,1,1,m.codigo_producto,m.codigo_subproducto,m.fecha_vencimie,m.fecha_cancela,m.cod_cuenta,ln_tcambi,2,1,
                                  m.nombre_subproducto,
                                  m.fecha_renovaci,m.estado_key,m.nombre_producto,m.producto_key,m.empleador_key,
                                  m.moneda_key,m.codigo_empleador,m.est_asesor,ld_aperen,m.geografia_key,
                                  y.cuentas_key,y.cod_cuenta
                             From TMP_FACT_PRODASE_ASIGCLI m
                            Where m.cuentas_key = z.cuentas_key;                              
               Commit; 
                    Else  */
                    --< 2023.06.20
                    
                    
                    --> 2023.10.29 Nro titulares cuenta renovada
                     Select count(*)
                       Into ln_titcta
                       From dwextra.fsr008 
                      Where ctnro = y.cuenta; 
                    --< 2023.10.29   
               
                    Update TMP_FACT_PRODASE_ASIGCLI g
                       set g.cuenta_ren_key = y.cuentas_key,
                           g.codigo_ctaren  = y.cod_cuenta,
                           g.imp_renovmn  = (ln_sldren + nvl(g.imp_renovmn,0)),
                           g.ind_tipren   = 1,
                           g.ind_ctaren   = 1,
                           g.ind_tipreg   = 2,
                           g.ind_insact   = 1,
                           g.imp_tipcam   = ln_tcambi,
                           g.fecha_apre   = y.fecha_apertura,
                           g.ind_titren   = ln_titcta 
                     Where g.cuentas_key = z.cuentas_key
                       and g.cliente_key = z.cliente_key;
                     Commit; 
                    -- End If;
                 End If; 
                 --End If;
           End Loop;
           
           If ln_ctaren = 0 and ln_ultren IS not null Then
              --> Nro de titulares de cuenta de renovación
              begin
                  select count(*)
                    Into ln_titcta
                    from dwhouse.dm_cuentas k
                    Join dwextra.fsr008 r on r.ctnro = k.cuenta
                   Where k.cuentas_key = y.cuentas_key;   
              Exception When Others Then
                 ln_titcta := null;
              End;
                
              Insert Into TMP_FACT_PRODASE_ASIGCLI(fecha,tiempo_key,codigo_asesor,asesor_key,cliente_key,
                                                   codigo_cliente,saldo_mn,saldo_mo,cuentas_key,cuenta_ren_key,
                                                   codigo_cuenta,codigo_ctaren,imp_renovmn,ind_ctaren,ind_tipren,
                                                   codigo_producto,fecha_vencimie,fecha_cancela,cod_cuenta,
                                                   imp_tipcam,ind_tipreg,ind_insact,nombre_subproducto,
                                                   fecha_renovaci,estado_key,nombre_producto,producto_key,empleador_key,
                                                   moneda_key,codigo_empleador,est_asesor,fecha_apre,Geografia_Key,
                                                   Codigo_Subproducto,Periodo,cod_ctacli,Ndoc,pais,tdoc,Ind_Colcaj,
                                                   ind_titren)
               Select fecha,tiempo_key,codigo_asesor,asesor_key,cliente_key,codigo_cliente,saldo_mn,saldo_mo,
                      m.cuentas_key,y.cuentas_key,m.codigo_cuenta,y.cod_cuenta,
                      ln_sldape,1,1,m.codigo_producto,m.fecha_vencimie,m.fecha_cancela,m.cod_cuenta,
                      ln_tcambi,2,2,
                      m.nombre_subproducto,
                      m.fecha_renovaci,m.estado_key,m.nombre_producto,m.producto_key,m.empleador_key,
                      m.moneda_key,m.codigo_empleador,m.est_asesor,ld_aperen,m.geografia_key,
                      m.codigo_subproducto,m.periodo,m.cod_ctacli,m.ndoc,m.pais,m.tdoc,m.Ind_Colcaj,
                      ln_titcta 
                 From TMP_FACT_PRODASE_ASIGCLI m
                Where m.cuentas_key = ln_ultren
                  and m.cliente_key = x.cliente_key
                  and nvl(ind_insact,0) <> 2;                               
               Commit;
                                
           End IF;
           
       End Loop;
     End Loop;
 End SP_FACT_PRODASE_RENDPF;
 ------------------------------------------------------------------------------------------------------------------      
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- -- --  
  PROCEDURE SP_PRAS_LOGROS_V5(PD_FECHA IN DATE)
  IS
   Cursor c_asesor(ln_per in Number,ln_guia in Number)
     is  select trim(tp1desc) jaql61user,tp1nro1 nivase,tp1nro2 ubsuc,tp1nro3 sucsec,
                to_number(g.Codigo_Region) codreg,
                nvl(d.tp1imp2,0) exmetcre -- excluye meta de crecimiento 1   
           from dwextra.fst198 d  
           Left Join dwhouse.dm_geografia g 
             on g.cod_sucurs = d.tp1nro2
            and g.tipo_region = 'R'
          where tp1cod1 = ln_guia
            and d.tp1corr1 = 35 
            and d.tp1corr2=1 
            and d.tp1corr3 = ln_per
            
            --and trim(tp1desc) in ('EQUIROZ','CVIZCARRA','CZEGARRA','JMODESTO','MBARRANTES')      
            --and trim(tp1desc) = 'AQUINTANIL'
           ;
     
     Cursor c_rnk Is
            Select tiempo_key,
                   nvl(POR_LOGRO,0) por_logro,
                   codigo_asesor,niveje,
                   d.codsuc,d.sucsec,d.ponaho,d.PONREN,d.metnue,
                   nvl(saldo_logro,0)-nvl(saldo_meta,0) sobcum,PONRE1,
                   saldo_base,saldo_avance, imp_metren,imp_logren 
              from TMP_FACT_PASIVOS_PROASE d WHERE TIPREG = 0 
             and ind_version = 2
             Order by nvl(POR_LOGRO,0) desc;
     
     Cursor c_orden 
         Is Select tiempo_key,
                   nvl(d.ind1_peso,0)*nvl(d.ind1_pago,0)+
                   nvl(d.ind2_peso,0)*nvl(d.ind2_pago,0)+
                   nvl(d.ind3_peso,0)*nvl(d.ind3_pago,0)+
                   nvl(d.ind4_peso,0)*nvl(d.ind4_pago,0) por_logro,
                   codigo_asesor,niveje 
              from TMP_FACT_PASIVOS_PROASE d WHERE TIPREG = 0 
             and ind_version = 2
             Order by 2 desc;
                     
     ld_feccon date := PD_FECHA;                                 
     ld_inimes date := to_date(to_char(ld_feccon,'rrrrmm')||'01','rrrrmmdd');
     ln_inimes number(10) := dwhouse.pq_carga_facts.fn_tiempo_key(ld_inimes);
     ln_period  number(6) := to_number(to_char(ld_feccon,'rrrrmm'));
     ln_tipcam number(7,3) := pq_tmp_productividadase.fn_tipo_cambio_fijo(ld_feccon);        
     lv_perf varchar2(20);  
     ln_limp number(12,2);  
     ln_pontp number(7,3);
     ln_ponsld number(7,3);
     ln_poncli number(7,3);  
     ln_metsld number(7,3);
     ln_metcli number(7,3);
     lv_err varchar2(200);
     ln_mancli number(12,2);
     ln_metslr number(7,3);
     ln_metctr number(7,3);
     ln_ponren number(7,3);
     ln_prnsld number(7,3);
     ln_prncli number(7,3);
     
     ln_niveje number(3); -- nivel de ejecutivo
     ln_poncre number(7,3); -- ponderado crecimiento
     ln_metaho number(12,2);-- meta ahorros
     ln_ponaho number(7,3);-- ponderado ahorros
     ln_metdpf number(12,2);-- meta dpf
     ln_pondpf number(7,3);-- ponderado dpf
     ln_metcts number(12,2);-- meta cts
     ln_poncts number(7,3);-- ponderado cts
     ln_ponnue number(7,3);-- ponderado nuevos
     ln_metnue number(12,2);-- meta nuevos
     ln_indvar number(3);
     ln_guiapr number(10) := 10819; --guia de proceso
     ln_pagpro number(12,2);
     ln_rnkase number(5);
     ln_ubsuc number(3);
     ln_creg number(3);
     ln_geok number(10);
     ln_porpag number(9,4);
     
     ld_mesant date := last_day(add_months(ld_feccon,-1));
     ln_iniman number := dwhouse.pq_carga_facts.fn_tiempo_key(to_date(to_char(ld_mesant,'rrrrmm')||'01','rrrrmmdd'));
     ln_sucsec number(4); -- Sucursal secundaria
     
     lnpeso1 number(7,3); lnmeta1 number(7,3); lnpago1 number(7,3);
     lnpeso2 number(7,3); lnmeta2 number(7,3); lnpago2 number(7,3);
     lnpeso3 number(7,3); lnmeta3 number(7,3); lnpago3 number(7,3);
     lnpeso4 number(7,3); lnmeta4 number(7,3); lnpago4 number(7,3);
     lnpeso5 number(7,3); lnmeta5 number(7,3); lnpago5 number(7,3);
     ln_psuc2 number(9,5);ln_psuc1 number(9,5);
     ln_msuc1 number(12,2); ln_isuc1 number(12,2);
     ln_msuc2 number(12,2); ln_isuc2 number(12,2);
     ln_bono  number(12,2);
     ln_rnkcc number(5);
     ln_rnkas number(5); 
     lnpsob number(12,2);
     ln_capaho number(12,2);
     ln_manaho number(12,2);
     ln_creaho number(7,3);
     ln_totcah number(12,2); --- Crecimiento total de ahorros
     
     ln_cont   number(10);
     ln_tmplog number(7,3);
     ln_ponren2 number(7,3);
     
     ln_inddes number(2);
     
     Cursor c_renov(lvA in Varchar2)
      is select fecha,tiempo_key,codigo_cliente,codigo_asesor,
               (nvl(d.imp_logren,0)/nvl(d.ind_titren,1)) logren,
               (nvl(d.imp_metren,0)/nvl(d.num_titcta,1)) metren,
               (nvl(d.imp_metren,0)/nvl(d.ind_titren,1)) MetaT
          from tmp_fact_pasivos_proase d 
         where codigo_asesor = lvA 
           and tipreg = 1 and nvl(d.imp_metren,0) <> 0
          -- and codigo_cliente = '6042129622729'
           and (nvl(d.imp_logren,0)/nvl(d.ind_titren,1)) < (nvl(d.imp_metren,0)/nvl(d.num_titcta,1));

          
      lnMeta number(12,2);
      lnLogr number(12,2);     
      lnSbas number(12,2); lnSava number(12,2);
      lnLogT number(12,2);
      lnRenF number(12,2);
      ln_impdes Number(12,2);
      lnVenP number(12,2); -- Importe vencido DPF 
      
      nMetVac Number(8,4);
      nBonVac Number(8,4);
      nDiaVac Number(5);
      
  BEGIN
    
     -- REVISA METAS 
     PQ_TMP_PRODUCTIVIDADASE.SP_PRAS_METAS(ld_feccon);
     

       
     DelETE FROM TMP_FACT_PASIVOS_PROASE WHERE TIPREG = 0 and ind_version = 2;
     COMMIT;
     
     -- ELIMINA RENOVACIONES
     Delete from TMP_FACT_PASIVOS_PROASE n where n.tipreg=2 and ind_version = 2;
     Commit;
       
     
     For x in c_asesor(ln_period,ln_guiapr) Loop
         -- PERFIL DE ASESOR  
           
             -- Nive, Sucursal principal, Sucursal secundaria
             Begin  
                 select d.tp1nro1,d.tp1nro2,d.tp1nro3,d.tp1imp1,d.tp1imp2,nvl(d.tp1imp3,0)
                   Into ln_niveje,ln_ubsuc,ln_sucsec,ln_inddes,ln_impdes,nDiaVac
                   from dwextra.fst198 d  where tp1cod1 = ln_guiapr
                    and d.tp1corr1 = 35 and d.tp1corr2=1 
                    and d.tp1corr3 = ln_period 
                    and trim(d.tp1desc) = trim(x.jaql61user); 
             Exception When Others Then
                ln_niveje := null;
                ln_ubsuc := null;
                ln_sucsec := null;
             End;     
             
             -- Nivel de Ejecutivo
             Begin
               Select trim(d.tp1desc) 
                 Into lv_perf
                 From dwextra.fst198 d  where tp1cod1 = ln_guiapr
                  and d.tp1corr1 = 35 and d.tp1corr2=0 
                  and d.tp1corr3 = ln_period and d.tp1nro1 = ln_niveje;
             Exception When Others Then
                lv_perf := null;
             End;    
               
             Begin   
               select case when x.exmetcre = -1 then 0 else d.tp1imp1 end tp1imp1,
                      d.tp1imp2,d.tp1imp3 
                 Into ln_metnue,ln_pagpro,ln_bono
                 from dwextra.fst198 d  where d.tp1cod1 = ln_guiapr
                  and d.tp1corr1 = 35 and d.tp1corr2 = ln_period 
                  and d.tp1corr3=x.codreg and d.tp1nro1=ln_niveje;
               Exception When Others Then
                ln_metnue := null; ln_pagpro := null;
             End;       
             
             --- VACACIONES
             Begin   
                  Select tp1imp1 ,tp1imp2 
                    Into nMetVac,nBonVac
                    from dwextra.fst198 
                   where tp1cod1 = 10819 and tp1corr1 = 38 and tp1nro1 = ln_period
                   and nDiaVac between tp1nro2 and tp1nro3;
               Exception When Others Then
                nMetVac := 1; nBonVac := 1;
             End;  
             ln_metnue := ln_metnue * nMetVac;
             --ln_bono := ln_bono * nBonVac;
               
               -- REGION
               Begin
                  Select g.geografia_key,to_number(g.codigo_region) Into ln_geok, ln_creg
                    From dwhouse.dm_geografia g
                  Where to_number(g.codigo_agencia) = ln_ubsuc
                    and g.tipo_region = 'R'; 
               Exception When Others Then
                    ln_geok := 117893;
                    ln_creg :=  0;  
                    ln_ubsuc:= 0; 
               End;
               
               --- ACTUALIZA DATOS DE CARTERA ASIGNADA
               BEGIN
               UPDATE dwstage.TMP_FACT_PASIVOS_PROASE y 
                   set y.saldo_base = (case when ind_tipren is null and nvl(y.ind_clirec,0) = 0 Then
                                            case when nvl(saldo_aho,0) >= nvl(y.imp_desbas,0) 
                                                 Then ((nvl(saldo_aho,0)- nvl(y.imp_desbas,0))+nvl(y.saldo_dpf,0) + nvl(y.saldo_cts,0))/num_titcta 
                                                 Else (nvl(y.saldo_dpf,0) + nvl(y.saldo_cts,0))/num_titcta  
                                            End
                                            when ind_tipren is null and nvl(y.ind_clirec,0) = 1 Then  nvl(saldo_dpf,0)/num_titcta 
                                            else 0
                                       end),
                       y.saldo_avance = (case when ind_tipren is null and nvl(ind_clirec,0) = 1 
                                              Then nvl(slddpf,0)/num_titcta
                                              when (
                                                    (ind_tipren is null and nvl(ind_clirec,0) = 0)   
                                                    --(ind_tipren is null and nvl(ind_colcaj,'N') = 'N')
                                                   )
                                              then (case when nvl(sldaho,0) >= nvl(y.imp_desava,0)  
                                                         then ((nvl(sldaho,0) - nvl(imp_desava,0))+nvl(slddpf,0)+nvl(sldcts,0))/num_titcta 
                                                         else (nvl(slddpf,0)+nvl(sldcts,0))/num_titcta     
                                                    end 
                                                   )
                                              else 0
                                         end
                                        ),                   
                                        /*(case when ind_tipren is null and nvl(ind_clirec,0) = 1 Then nvl(slddpf,0)/num_titcta
                                            when ind_tipren is null and (nvl(ind_clirec,0) =0 and nvl(ind_colcaj,'N') = 'N') Then
                                                 (case when nvl(sldaho,0) >= nvl(y.imp_desava,0) Then
                                                           ((nvl(sldaho,0) - nvl(imp_desava,0))+nvl(slddpf,0)+nvl(sldcts,0))/num_titcta 
                                                      else (nvl(slddpf,0)+nvl(sldcts,0))/num_titcta     
                                                  end )      
                                            Else 0
                                       End)*/ 
                       y.sldbaho = (case when ind_tipren is null /*and nvl(y.ind_clirec,0) = 0*/ Then
                                            case when nvl(saldo_aho,0) >= nvl(y.imp_desbas,0) 
                                                 Then (nvl(saldo_aho,0)- nvl(y.imp_desbas,0))/num_titcta 
                                                 Else 0
                                                 End
                                        else 0
                                        end),
                       y.sldbdpf = (case when ind_tipren is null Then nvl(y.saldo_dpf,0) /num_titcta 
                                         else 0
                                         end),
                       y.sldbcts = (case when ind_tipren is null 
                                               and nvl(y.ind_clirec,0) = 0 --204.12.09
                                         Then nvl(y.saldo_cts,0) /num_titcta 
                                         else 0
                                       end),
                       y.sldcaho = /*(case when ((ind_tipren is null and nvl(ind_clirec,0) =0) and  
                                              (ind_tipren is null and  nvl(ind_colcaj,'N') = 'N')
                                              )  
                                         Then
                                                 (case when nvl(sldaho,0) >= nvl(y.imp_desava,0) Then
                                                           (nvl(sldaho,0) - nvl(imp_desava,0))/num_titcta 
                                                      else 0   
                                                  end )      
                                            Else 0
                                       End),*/
                                     (case when ind_tipren is null --and nvl(ind_clirec,0) = 0 
                                                --or nvl(ind_colcaj,'N') = 'N') --2024.12.09
                                                Then
                                                 (case when nvl(sldaho,0) >= nvl(y.imp_desava,0) Then
                                                           (nvl(sldaho,0) - nvl(imp_desava,0))/num_titcta 
                                                      else 0   
                                                  end )      
                                            Else 0
                                       End),
                       y.sldcdpf = (case when ind_tipren is null --and nvl(ind_colcaj,'N') = 'N' 
                                         Then nvl(slddpf,0)/num_titcta
                                         Else 0
                                    End),
                       y.sldccts = (case when ind_tipren is null-- and nvl(ind_colcaj,'N') = 'N' 
                                         and nvl(ind_clirec,0) =0 --- 2024.12.09 
                                         Then nvl(sldcts,0)/num_titcta
                                             Else 0
                                       End),
                       y.imp_desbas = (nvl(imp_desbas,0)/num_titcta),
                       y.imp_desava = (nvl(imp_desava,0)/num_titcta),
                       y.ind_colcaj = NVL(ind_colcaj,'N'),
                       y.saldo_desfase = pq_tmp_productividadase.fn_pras_saldo_desfase(pn_tiempo => ln_iniman,
                                                                   pd_fecsdo => ld_mesant,
                                                                   pn_asekey => y.asesor_key,
                                                                   pn_tipreg => 0,
                                                                   pn_niveje => ln_niveje,
                                                                   pn_inddes => ln_inddes,
                                                                   PN_IMPDES => ln_impdes)
                WHERE TIPREG = 1  and y.Codigo_Asesor = trim(x.jaql61user) and ind_version = 2;
               Commit;
               Exception WHen Others Then
                lv_err := substr(sqlerrm,1,200);
                dbms_output.put_line('INS-'||trim(x.jaql61user)||':'||lv_err);
               End;     
               
               --- INSERTA LOGROS     
               BEGIN
                Insert INTO TMP_FACT_PASIVOS_PROASE
                       (FECHA,TIEMPO_KEY,FECHA_SLD,CODIGO_ASESOR,
                        METNUE,PAGPRO,ASESOR_KEY,CODSUC,REGEJE,
                        KEY_GEOGRAFIA,SALDO_BASE,IMP_DESBAS,
                        SALDO_AVANCE,SALDO_CAPTADO,IMP_DESAVA,
                        SALDO_META,SALDO_LOGRO,POR_LOGRO,TIPREG,
                        IND_VERSION,TIPASE,NUM_TITCTA,COD_CTACLI,
                        SUCSEC,SLDCAHO,SALDO_DESFASE,NIVEJE,
                        PONAHO,PONREN,IMP_METREN,IMP_LOGREN,PONRE1,
                        imp_totren
                        )
                Select fecha, tiempo_key, fecha_sld,codigo_asesor,
                       ln_metnue,ln_pagpro,asesor_key,ln_ubsuc,ln_creg,
                       ln_geok,sdobas,imp_desbas,sdoava,
                       nvl(sdocap,0)-nvl(sdocapbas,0), imp_desava,
                       sdobas + ln_metnue + nvl(Saldo_Desfase,0),
                       sdoava + (nvl(sdocap,0)-nvl(sdocapbas,0)),
                       case when sdobas + ln_metnue + nvl(Saldo_Desfase,0) > 0 
                            Then (sdoava + (nvl(sdocap,0)-nvl(sdocapbas,0)))/(sdobas + ln_metnue + nvl(Saldo_Desfase,0))
                            else 0
                       end,0,2,
                       lv_perf,nclie,nclim,ln_sucsec,
                       Sldcaho,
                       SALDO_DESFASE,ln_niveje,
                       case when Sldbaho <> 0 and Sldcaho >= Sldbaho Then (Sldcaho/Sldbaho)-1
                            Else 0
                       end METCAHO, 
                       --> 2023.10.31 Cambio en cálculo
                       /*case when imp_metren <> 0 and imp_logren >= imp_metren Then (imp_logren/imp_metren)
                            Else 0
                       end METRDPF,*/
                       case when imp_metren <> 0 Then (imp_logren/imp_metren)
                            Else 0
                       end METRDPF,
                       --< Cambio en cálculo
                       imp_metren,imp_logren,ln_bono,imp_logren         
                       
                From(                                             
                  select tiempo_key,codigo_asesor,fecha_sld,fecha,asesor_key,
                         sum(nvl(sdobas,0))sdobas, 
                         sum(nvl(imp_desbas,0)) imp_desbas,
                         sum(nvl(sdoava,0)) sdoava,
                         sum(nvl(sdocap,0)) sdocap,
                         sum(nvl(imp_desava,0)) imp_desava,
                         sum(nvl(sdocapbas,0)) sdocapbas,
                         count(distinct cliente_key) nclie, -- total clientes
                         count(distinct case when ind_nuevo = 0 then cliente_key end) nclim, -- clientes mantenimiento  
                         sum(nvl(Sldbaho,0)) Sldbaho,
                         sum(nvl(Sldcaho,0)) Sldcaho,
                         max(nvl(SALDO_DESFASE,0)) SALDO_DESFASE,
                         sum(nvl(imp_metren,0)) imp_metren,
                         sum(nvl(imp_logren,0)) imp_logren
                         /*sum(case when nvl(imp_logren,0) >= nvl(imp_metren,0) 
                            then nvl(imp_logren,0)
                            when nvl(imp_logren,0) <> 0 and
                                 nvl(imp_logren,0) < nvl(imp_metren,0) and 
                                 nvl(sdobas,0) <= nvl(sdoava,0) 
                            Then nvl(imp_metren,0)
                            when nvl(imp_logren,0) = 0 and
                                 nvl(sdobas,0) <= nvl(sdoava,0) 

                            Then nvl(imp_metren,0)
                            Else nvl(imp_logren,0)
                         end) imp_logren*/
                    From (   
                  Select tiempo_key, codigo_asesor,fecha_sld,fecha,asesor_key,
                            (case when ind_tipren is null and nvl(y.ind_clirec,0) = 0 
                                     Then Case when nvl(saldo_aho,0) >= nvl(y.imp_desbas,0) 
                                          Then ((nvl(saldo_aho,0)- nvl(y.imp_desbas,0))+nvl(y.saldo_dpf,0) + nvl(y.saldo_cts,0))/num_titcta 
                                          Else (nvl(y.saldo_dpf,0) + nvl(y.saldo_cts,0))/num_titcta  
                                          End
                                     when ind_tipren is null and nvl(y.ind_clirec,0) = 1 
                                     Then  nvl(saldo_dpf,0)/num_titcta 
                                     else 0
                                end
                               ) sdobas,
                            (nvl(imp_desbas,0)/num_titcta) imp_desbas,       
                            (case when ind_tipren is null and  nvl(ind_clirec,0) = 1 
                                  Then nvl(slddpf,0)/num_titcta
                                  when (
                                        --(nvl(ind_clirec,0) = 0 and ind_colcaj = 'N') and
                                        (nvl(ind_clirec,0) = 0 and nvl(ind_clirec,0) = 0)
                                       ) 
                                  Then (case when nvl(sldaho,0) >= nvl(y.imp_desava,0) 
                                             Then ((nvl(sldaho,0) - nvl(imp_desava,0))+nvl(slddpf,0)+nvl(sldcts,0))/num_titcta 
                                             else (nvl(slddpf,0)+nvl(sldcts,0))/num_titcta     
                                         end 
                                       )      
                                  Else 0
                                End
                               ) sdoava,
                            /*(case when ind_tipren is null and  nvl(ind_clirec,0) = 1 Then nvl(slddpf,0)/num_titcta
                                  when ind_tipren is null and ((nvl(ind_clirec,0) = 0 and ind_colcaj = 'N')) Then
                                     (case when nvl(sldaho,0) >= nvl(y.imp_desava,0) Then
                                               ((nvl(sldaho,0) - nvl(imp_desava,0))+nvl(slddpf,0)+nvl(sldcts,0))/num_titcta 
                                          else (nvl(slddpf,0)+nvl(sldcts,0))/num_titcta     
                                      end )      
                                Else 0
                                End
                               ) sdoava,*/
                       (Case when ind_tipren is not null and (nvl(ind_clirec,0) = 0 and ind_colcaj = 'N') Then
                                nvl(imp_renmn,0)/num_titcta 
                       Else 0 End) sdocap,
                       (nvl(imp_desava,0)/num_titcta) imp_desava,
                       (Case when ind_tipren is not null and (nvl(ind_clirec,0) = 0 and ind_colcaj = 'N') Then
                            (nvl(saldo,0))/num_titcta
                       Else 0 End) sdocapbas,
                       y.cliente_key,
                       y.ind_nuevo,  
                       (nvl(Sldbaho,0)/nvl(num_titcta,1)) Sldbaho,
                       (nvl(Sldcaho,0)/nvl(num_titcta,1)) Sldcaho,
                       (nvl(SALDO_DESFASE,0)) SALDO_DESFASE,
                       (nvl(imp_metren,0)/nvl(num_titcta,1)) imp_metren,
                       --> 2023.10.30
                       case when y.codigo_asesor = 'RVEGAA' and y.codigo_cliente = '6042107918760' and y.fecha =  to_date('20231001','rrrrmmdd') 
                            then (nvl(imp_logren,0)/1)
                            when y.codigo_asesor = 'KLEDESMA' and y.codigo_cliente = '6042140142490' and y.fecha =  to_date('20231101','rrrrmmdd') 
                            then (nvl(imp_logren,0)/1)  
                            else (nvl(imp_logren,0)/nvl(ind_titren,1))  
                       end imp_logren, 
                       --(nvl(imp_logren,0)/nvl(num_titcta,1)) imp_logren,
                       --< 2023.10.30  
                       num_titcta
                  from dwstage.TMP_FACT_PASIVOS_PROASE  y 
                  WHERE TIPREG = 1 and codigo_asesor =trim(x.jaql61user)
                  and ind_version = 2
                  )
                group by tiempo_key, codigo_asesor,fecha_sld,fecha,asesor_key
                );
                Commit;
               
           Exception WHen Others Then
              lv_err := substr(sqlerrm,1,200);
              dbms_output.put_line('INS-'||trim(x.jaql61user)||':'||lv_err);
           End;     
           
           
          --Inserta DETALLE DE DPF RENOVADOS
          PQ_TMP_PRODUCTIVIDADASE.SP_PRAS_RENOV_ASESOR(ld_feccon,ln_tipcam,trim(x.jaql61user));
     
           /*
           ---- RENOVACIONES DE DPF
           --- RENOVACION MAYOR O IGUAL A LA META
           Begin
                select sum((nvl(d.imp_logren,0)/nvl(d.ind_titren,1))),
                       sum((nvl(d.imp_metren,0)/nvl(d.num_titcta,1)))
                  Into lnLogr,lnMeta
                  From tmp_fact_pasivos_proase d 
                 Where codigo_asesor = trim(x.jaql61user) 
                   and tipreg = 1 and nvl(d.imp_metren,0) <> 0
                   and (nvl(d.imp_logren,0)/nvl(d.ind_titren,1)) >= (nvl(d.imp_metren,0)/nvl(d.num_titcta,1));
           Exception When Others Then
               lnLogr := 0; lnMeta := 0;
           End;  
           

           
           --- RENOVACION MENOR A LA META
           For z in c_renov(trim(x.jaql61user)) Loop
               lnSbas := 0; lnSava := 0; lnLogT := 0; lnRenF := 0;
               lnMeta := nvl(lnMeta,0) + nvl(z.metren,0); 
               
               -- Saldo base y avance
               Begin
                  select sum(nvl(saldo_base,0)),sum(nvl(saldo_avance,0))
                    into lnSbas,lnSava
                    from tmp_fact_pasivos_proase d 
                   where codigo_asesor = z.codigo_asesor
                     and codigo_cliente = z.codigo_cliente 
                     and tipreg=1; 
               Exception When Others Then
                  lnSbas := 0; lnSava := 0;
               End;   

               --- Logro total DPF
               Begin
                  select --sum(nvl(imp_logren,0))
                         (nvl(imp_logren,0)/nvl(ind_titren,1))
                    into lnLogT
                    from tmp_fact_pasivos_proase d 
                   where codigo_asesor = z.codigo_asesor
                     and codigo_cliente = z.codigo_cliente 
                     and tipreg=1
                     and nvl(imp_metren,0) <> 0; 
               Exception When Others Then
                  lnLogT := 0;
               End;   
               
               --- Revisar posición
               If lnSava >=  lnSbas Then
                  If lnLogT <=  nvl(z.metren,0) Then 
                     lnRenF := nvl(z.metren,0);
                  Else 
                     lnRenF := nvl(lnLogT,0);
                  End If;  
                  lnLogr := nvl(lnLogr,0) + nvl(lnRenF,0);   
               Else
                  lnRenF := nvl(z.logren,0);
                  lnLogr := nvl(lnLogr,0) + nvl(z.logren,0);  
               End If;     
               
           End Loop;     
           
           Update tmp_fact_pasivos_proase
              set IMP_METREN = lnMeta,
                  IMP_LOGREN = lnLogr,
                  PONREN = (lnLogr/lnMeta) 
           Where codigo_asesor = trim(x.jaql61user)
             and tipreg = 0  
             and ind_version = 2;
           Commit;  */
           
           
           --- META RENOVACIONES
           BEGIN
               SELECT sum(nvl(saldo,0)/nvl(num_titcta,1)),
                      sum(case when fec_vencta <= PD_FECHA then nvl(saldo,0)/nvl(num_titcta,1) else 0 end) 
                 INTO lnMeta,lnVenP
                 FROM(                 
                      Select distinct cliente_key,codigo_cliente,
                             saldo,cuentas_key,cod_ctacli,d.num_titcta,
                             d.fec_vencta
                        From tmp_fact_pasivos_proase d
                       Where tipreg = 2
                         and codigo_asesor = trim(x.jaql61user)
                         and ind_venmes = 'Si'
                      );
           Exception when others then
              lnMeta := 0;
              lnVenP := 0;
           End;   
           
           --- LOGRO RENOVACIONES
           Begin
                select sum(nvl(d.imp_renmn,0)/nvl(d.ind_titren,1))
                  Into lnLogr
                  From tmp_fact_pasivos_proase d
                 where tipreg = 2
                   and codigo_asesor = trim(x.jaql61user)
                   and ind_venmes = 'Si';
           Exception when others then
              lnLogr := 0;
           End;  
           
           Update tmp_fact_pasivos_proase
              set IMP_METREN = lnMeta,
                  IMP_LOGREN = lnLogr,
                  PONREN = (lnLogr/lnMeta),
                  IMP_VENDPF = lnVenP 
           Where codigo_asesor = trim(x.jaql61user)
             and tipreg = 0  
             and ind_version = 2;
           Commit;       

           
       End Loop;
       
       
       
       
       ln_rnkase := 0;
       ln_rnkcc  := 0;
       ln_rnkas  := 0;
       ln_cont   := 0;
       ln_tmplog := null;
       
       For x in c_rnk Loop
           ln_metnue := x.metnue;

           If x.niveje = 4 Then
              ln_rnkcc := ln_rnkcc + 1;
              ln_rnkase:= ln_rnkcc;
           Else
              ln_cont := ln_cont + 1;
              If ln_tmplog Is null Or ln_tmplog <> x.por_logro Then  
                 --ln_rnkas := ln_rnkas + 1;
                 ln_rnkas := ln_cont;
                 ln_rnkase:= ln_rnkas;
                 ln_tmplog := x.por_logro;
              End If;   
           End If;      
           
           -- PESO/META/PAGO INDIC1:TOTAL
           BEGIN
             select d.tp1imp2,d.tp1imp1,r.tp1imp3/100 
               Into lnpeso1,lnmeta1,lnpago1
               from dwextra.fst198 d 
               Join dwextra.fst198 r on r.tp1cod = d.tp1cod
                                    and r.tp1cod1 = d.tp1cod1
                                    and r.tp1corr1 = d.tp1corr1
                                    and r.tp1corr2 = d.tp1nro2
                                    and r.tp1corr3 = d.tp1corr3
                                   
                where d.tp1cod1 = ln_guiapr                      
                and d.tp1corr1 = 36 
                and d.tp1nro1 = 1--tabla1
                and d.tp1corr2 = x.niveje --codigo perfil
                and d.tp1corr3 =ln_period --periodo  
                and round((nvl(x.por_logro,0)/d.tp1imp1)*100,2) between r.tp1imp1 and r.tp1imp2;
           exception when others then
              lnpeso1 := 0; lnmeta1 :=0; lnpago1:=0;
           end;     
           
           -- PESO/META/PAGO INDIC1:TOTAL
           BEGIN
             select r.tp1imp3
               Into lnpsob
               from dwextra.fst198 d 
               Join dwextra.fst198 r on r.tp1cod = d.tp1cod
                                    and r.tp1cod1 = d.tp1cod1
                                    and r.tp1corr1 = d.tp1corr1
                                    and r.tp1corr2 = d.tp1nro2
                                    and r.tp1corr3 = d.tp1corr3
                                   
                where d.tp1cod1 = ln_guiapr                      
                and d.tp1corr1 = 36 
                and d.tp1nro1 = 6--tabla6
                and d.tp1corr2 = x.niveje --codigo perfil
                and d.tp1corr3 =ln_period --periodo  
                and x.sobcum between r.tp1imp1 and r.tp1imp2;
           exception when others then
              lnpsob := 0; 
           end;  
           
           --- PESO/META
           BEGIN
             select d.tp1imp2,d.tp1imp1
               Into lnpeso2,lnmeta2
               from dwextra.fst198 d 
              where d.tp1cod1 = ln_guiapr                      
                and d.tp1corr1 = 36 
                and d.tp1nro1 = 2--tabla2
                and d.tp1corr2 = x.niveje --codigo perfil
                and d.tp1corr3 =ln_period;
           exception when others then
              lnpeso2 := 0; lnmeta2 :=0;
           end;     
           
           
           
           --- CRECIMIENTO AHORROS
           -- CAPTACION
           Begin
               select /*sum(case when nvl(y.ind_clirec,0) = 0 or nvl(y.ind_colcaj,'N')= 'N' 
                               then (y.imp_renmn - y.saldo)/nvl(y.num_titcta,1)
                               else 0
                           end)*/
                           
                           
                      nvl(Sum(Case when nvl(ind_colcaj,'N') = 'S'  
                                      or y.cod_aseasi Is not null  
                                      Or (y.ind_clirec = 1 and y.cod_modcta = 21)
                                      Or y.val_rucemp in ('20100209641','20509815501')
                               Then 0
                               Else (nvl(y.imp_renmn,0) - nvl(y.saldo,0))/nvl(y.num_titcta,1)
                          End),0)
                 Into ln_capaho               
                 From tmp_fact_pasivos_proase y
                 Where codigo_asesor = x.codigo_asesor
                   and tipreg = 3 and cod_modcta = 21;
           exception when others then
              ln_capaho :=0;
           end; 
           -- MANTENIMIENTO  
           Begin
                select sum(nvl(y.sldcaho,0))-sum(nvl(y.sldbaho,0))    
                  into ln_manaho
                  from dwstage.tmp_fact_pasivos_proase y
                  where codigo_asesor = x.codigo_asesor
                  and tipreg = 1;
            exception when others then
              ln_manaho :=0;
            end;  
            
            --> 2023.09.29 Formula Nueva
            ln_totcah := (ln_manaho+ln_capaho);
            If ln_manaho <= 0 Then
               If nvl(ln_capaho,0) > 0 Then
                  If ln_metnue <> 0 Then -- Nuevo
                     ln_creaho := (ln_capaho)/(ln_metnue*lnmeta2);
                  Else
                     ln_creaho := 1; -- Nuevo
                  End If;   -- Nuevo
                  ln_totcah :=  ln_capaho;
               Else
                  ln_creaho := 0;
                  ln_totcah := 0;
               End If;     
            Else 
               If ln_metnue <> 0 Then
                  ln_creaho := ((ln_manaho+ln_capaho)/(ln_metnue*lnmeta2));
               Else
                  ln_creaho := 1;
               End If;  
            End If;
                 
            /*if ln_manaho+ln_capaho < 0 Then
               ln_creaho := 0;
            else    
               ln_creaho := ((ln_manaho+ln_capaho)/(ln_metnue*lnmeta2));
            end If;*/
            --< 2023.09.29 Formula Nueva
            
           -- PESO/META/PAGO INDIC2:AHORROS
           BEGIN
             select d.tp1imp2,d.tp1imp1,r.tp1imp3/100 
               Into lnpeso2,lnmeta2,lnpago2
               from dwextra.fst198 d 
               Join dwextra.fst198 r on r.tp1cod = d.tp1cod
                                    and r.tp1cod1 = d.tp1cod1
                                    and r.tp1corr1 = d.tp1corr1
                                    and r.tp1corr2 = d.tp1nro2
                                    and r.tp1corr3 = d.tp1corr3
                                   
                where d.tp1cod1 = ln_guiapr                      
                and d.tp1corr1 = 36 
                and d.tp1nro1 = 2--tabla2
                and d.tp1corr2 = x.niveje --codigo perfil
                and d.tp1corr3 =ln_period --periodo  
                --and (nvl(x.PONAHO,0)/d.tp1imp1)*100 between r.tp1imp1 and r.tp1imp2;
                and ln_creaho*100 between r.tp1imp1 and r.tp1imp2;
           exception when others then
              lnpeso2 := 0; 
              lnmeta2 :=0; 
              --lnmeta2 := ln_metnue*lnmeta2;
              lnpago2:=0;
           end;     
           
           
           --> 2023.10.29 Version 5 Renovaciones
           /*IF nvl(x.imp_logren,0) = 0 and  nvl(x.saldo_avance,0) >= nvl(x.saldo_base,0) THEN
               ln_ponren2 := 1;
           ELSIF nvl(x.imp_logren,0) = 0 and  nvl(x.saldo_avance,0) < nvl(x.saldo_base,0) THEN
               ln_ponren2 := 0;    
           ELSIF nvl(x.imp_logren, 0) > 0 and nvl(x.imp_logren,0) < nvl(x.imp_metren,0) Then
               ln_ponren2 := 0;
           ELSE
               ln_ponren2 := nvl(x.PONREN,0);    
           End IF;  */
           --<
           
           -- Logro agencia1
           -- PESO/META/PAGO INDIC3:RENOV DPF
           BEGIN
             select d.tp1imp2,d.tp1imp1,r.tp1imp3/100 
               Into lnpeso3,lnmeta3,lnpago3
               from dwextra.fst198 d 
               Join dwextra.fst198 r on r.tp1cod = d.tp1cod
                                    and r.tp1cod1 = d.tp1cod1
                                    and r.tp1corr1 = d.tp1corr1
                                    and r.tp1corr2 = d.tp1nro2
                                    and r.tp1corr3 = d.tp1corr3
                                   
                where d.tp1cod1 = ln_guiapr                      
                and d.tp1corr1 = 36 
                and d.tp1nro1 = 3 --tabla2
                and d.tp1corr2 = x.niveje --codigo perfil
                and d.tp1corr3 =ln_period --periodo  
                and round((nvl(x.PONREN,0)/d.tp1imp1)*100,2) between r.tp1imp1 and r.tp1imp2;
           exception when others then
              lnpeso3 := 0; lnmeta3 :=0; lnpago3:=0;
           end;          
           
           
           begin
              select e.por_logacum,
                     nvl(e.imp_avaaho,0)+nvl(e.imp_avacts,0)+nvl(e.imp_avadpf,0) impacu,
                     nvl(e.imp_metaho,0)+nvl(e.imp_metcts,0)+nvl(e.imp_metdpf,0) metacu
                Into ln_psuc1,ln_msuc1,ln_isuc1
                from dwhouse.fact_pasivo_prodinc_res e 
                Join dwhouse.dm_geografia ge on ge.geografia_key = e.geografia_key
               where e.tiempo_key = ln_inimes
                 and e.ind_tipmet = 1
                 and ge.cod_sucurs = x.codsuc;
           exception when others then
              ln_psuc1 := 0;
              ln_msuc1 := 0;
              ln_isuc1 := 0;
           end;   

     
           -- PESO/META/PAGO INDIC4:AGENCIA1
           BEGIN
             select d.tp1imp2,d.tp1imp1,r.tp1imp3/100 
               Into lnpeso4,lnmeta4,lnpago4
               from dwextra.fst198 d 
               Join dwextra.fst198 r on r.tp1cod = d.tp1cod
                                    and r.tp1cod1 = d.tp1cod1
                                    and r.tp1corr1 = d.tp1corr1
                                    and r.tp1corr2 = d.tp1nro2
                                    and r.tp1corr3 = d.tp1corr3
                                   
                where d.tp1cod1 = ln_guiapr                      
                and d.tp1corr1 = 36 
                and d.tp1nro1 = 4 --tabla2
                and d.tp1corr2 = x.niveje --codigo perfil
                and d.tp1corr3 =ln_period --periodo  
                and (nvl(ln_psuc1,0)/d.tp1imp1)*100 between r.tp1imp1 and r.tp1imp2;
           exception when others then
              lnpeso4 := 0; lnmeta4 :=0; lnpago4:=0;
           end;    
           
           
           -- Logro agencia2
           begin
              select e.por_logacum,
                     nvl(e.imp_avaaho,0)+nvl(e.imp_avacts,0)+nvl(e.imp_avadpf,0) impacu,
                     nvl(e.imp_metaho,0)+nvl(e.imp_metcts,0)+nvl(e.imp_metdpf,0) metacu
                Into ln_psuc2,ln_msuc2,ln_isuc2
                from dwhouse.fact_pasivo_prodinc_res e 
                Join dwhouse.dm_geografia ge on ge.geografia_key = e.geografia_key
               where e.tiempo_key = ln_inimes
                 and e.ind_tipmet = 1
                 and ge.cod_sucurs = x.sucsec;
           exception when others then
              ln_psuc2 := 0;
              ln_msuc2 := 0;
              ln_isuc2 := 0;
           end;
           -- PESO/META/PAGO INDIC4:AGENCIA2
           BEGIN
             select d.tp1imp2,d.tp1imp1,r.tp1imp3/100 
               Into lnpeso5,lnmeta5,lnpago5
               from dwextra.fst198 d 
               Join dwextra.fst198 r on r.tp1cod = d.tp1cod
                                    and r.tp1cod1 = d.tp1cod1
                                    and r.tp1corr1 = d.tp1corr1
                                    and r.tp1corr2 = d.tp1nro2
                                    and r.tp1corr3 = d.tp1corr3
                                   
                where d.tp1cod1 = ln_guiapr                      
                and d.tp1corr1 = 36 
                and d.tp1nro1 = 5 --tabla2
                and d.tp1corr2 = x.niveje --codigo perfil
                and d.tp1corr3 =ln_period --periodo  
                and (nvl(ln_psuc2,0)/d.tp1imp1)*100 between r.tp1imp1 and r.tp1imp2;
           exception when others then
              lnpeso5 := 0; lnmeta5 :=0; lnpago5:=0;
           end;  
           
           
           
         

           Begin
               Update TMP_FACT_PASIVOS_PROASE d 
                  set d.rnk_logro = ln_rnkase,
                      ind1_peso = lnpeso1,
                      ind1_meta = lnmeta1,
                      ind1_pago = lnpago1,
                      ind1_logro= nvl(x.por_logro,0),
                      ind2_peso = lnpeso2,
                      ind2_meta = lnmeta2,
                      ind2_logro= ln_creaho, --nvl(x.PONAHO,0),
                      ind2_pago = lnpago2,
                      ind3_peso = lnpeso3,
                      ind3_meta = lnmeta3,
                      ind3_logro= nvl(x.PONREN,0),
                      ind3_pago = lnpago3,
                      ind4_logro = nvl(ln_psuc1,0),
                      ind4_peso = lnpeso4,
                      ind4_meta = lnmeta4,
                      ind4_pago = lnpago4,
                      ind5_logro  = nvl(ln_psuc2,0),
                      ind5_peso = lnpeso5,
                      ind5_meta = lnmeta5,
                      ind5_pago = lnpago5,
                      saldo_aho = ln_msuc1,
                      sldaho    = ln_isuc1,
                      saldo_dpf = ln_msuc2,
                      slddpf    = ln_isuc2,
                      --ponnue    = (Case when nvl(ln_psuc2,0) < 1 then 0 else ln_bono end), -- bono segunda agencia
                      ponnue    = (Case when nvl(ln_psuc2,0) < 1 then 0 else x.PONRE1 end),
                      ponsld    = lnpsob,   --bono sobrecumpliemnto saldo
                      sldbaho   = (lnmeta2 * metnue), --metaaho
                      sldcaho   = ln_totcah, --nvl(ln_capaho,0) + nvl(ln_manaho,0),
                      ponaho    = ln_creaho
                 Where d.codigo_asesor = x.codigo_asesor
                   and d.tiempo_key = x.tiempo_key
                   and ind_version = 2
                   and d.tipreg = 0;
               Commit;  
           Exception WHen Others Then
              lv_err := substr(sqlerrm,1,200);
              dbms_output.put_line('UPD-LOGROS:'||lv_err);
           End;     
       End Loop;
       
       --- Rnaking Final
       ln_rnkase := 0;
       ln_rnkcc  := 0;
       ln_rnkas  := 0;
       ln_cont   := 0;
       ln_tmplog := null;
       
       For z in c_orden Loop
       
           If z.niveje = 4 Then
              ln_rnkcc := ln_rnkcc + 1; 
              ln_rnkase := ln_rnkcc;
           Else
               ln_cont := ln_cont + 1;
               If ln_tmplog is Null Or ln_tmplog <> z.por_logro Then
                  ln_rnkas := ln_cont;
                  ln_rnkase := ln_rnkas;
                  ln_tmplog := z.por_logro;
               End If;   
           End If;  
           
           Update TMP_FACT_PASIVOS_PROASE d 
                  set d.rnk_logro = ln_rnkase
            Where d.codigo_asesor = z.codigo_asesor
                   and d.tiempo_key = z.tiempo_key
                   and ind_version = 2
                   and d.tipreg = 0;       
                  
       End Loop;  
       

         
         
         
         
  END SP_PRAS_LOGROS_V5;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- -- --
  PROCEDURE SP_PRAS_RENOV_ASESOR(PD_FECHA In Date, PN_TIPCAM In Number, PV_CODASE In Varchar2)
  IS
       Cursor c_dpfnoren
               is select * 
                   from (select codigo_cliente, codigo_asesor,sum(nvl(imp_renmn,0)) imp_renmn,
                                sum(nvl(saldo,0)) saldo ,num_titcta,ind_titren
                          from (select codigo_cliente, codigo_asesor,
                                       sum(nvl(imp_renmn,0)) imp_renmn,nvl(saldo,0) saldo,
                                       num_titcta,ind_titren,cuentas_key
                                  from tmp_fact_pasivos_proase f
                                 where tipreg = 2 and ind_venmes = 'Si' 
                                   and (fec_vencta <= PD_FECHA or 
                                        ((fec_vencta > PD_FECHA) and cuentas_ren_key is not null))
                                -- and f.codigo_cliente = '6042141593401'
                                  and codigo_asesor = PV_CODASE
                                 group by codigo_cliente, codigo_asesor,nvl(saldo,0) ,
                                          num_titcta,ind_titren,cuentas_key
                               )
                         group by codigo_cliente, codigo_asesor,num_titcta,ind_titren,cuentas_key
                        ) 
                  Where nvl(imp_renmn,0)/ind_titren < (nvl(saldo,0)/num_titcta);      
                /*select distinct codigo_cliente, codigo_asesor, cuentas_key, nvl(imp_renmn,0) imp_renmn,nvl(saldo,0) saldo
                                  ,num_titcta,ind_titren
                  from tmp_fact_pasivos_proase f
                 where tipreg = 2 and ind_venmes = 'Si' 
                  and nvl(imp_renmn,0)/ind_titren < nvl(saldo,0)/num_titcta;*/ 
      
  
       Cursor c_dpf(lvC in Varchar2,lvA in Varchar2) 
           is select DAT.*,saldo-imp_renmn DIF from (
                select codigo_cliente, codigo_asesor,sum(nvl(imp_renmn,0)/ind_titren) imp_renmn,nvl(saldo,0)/num_titcta saldo
                       ,num_titcta,ind_titren,f.cuentas_key,sum(nvl(imp_renmn,0)) RenTot
                  from tmp_fact_pasivos_proase f
                 where tipreg = 2 and ind_venmes = 'Si' 
                   and codigo_cliente = lvC
                   and codigo_asesor = lvA
                group by codigo_cliente, codigo_asesor,nvl(saldo,0)/num_titcta ,num_titcta,ind_titren,f.cuentas_key
                )DAT where imp_renmn < saldo;

       lnSbas    Number(12,2);
       lnSava    Number(12,2);
       lnPorc    Number(20,6); 
       lnImpr    Number(12,2);     
       lnRenO    Number(12,2);  
       ln_tipcam Number(7,3) := PN_TIPCAM;
       ld_feccon Date := PD_FECHA;
       lv_err    Varchar2(200);
       lnDif     Number(12,2);
       TotRen    Number(12,2); 
       TotMet    Number(12,2);
       DifTot    Number(12,2);
       
  BEGIN
       -- INSERTA DETALLE DE RENOVACIONES
       Delete from TMP_FACT_PASIVOS_PROASE n where n.tipreg=2 and ind_version = 2
       and codigo_asesor = PV_CODASE;
       --and codigo_asesor = 'CVIZCARRA';
       Commit;
       
       Begin
       Insert Into TMP_FACT_PASIVOS_PROASE
                  (fecha,tiempo_key,periodo,codigo_asesor,asesor_key,
                   cliente_key,codigo_cliente,saldo,
                   cuentas_key,cuentas_ren_key,
                   codigo_cuenta,codigo_cuenta_ren,imp_renmn,
                   ind_ctaren,ind_tipren,tipreg,fec_vencta,
                   ind_venmes,fec_cancela,cod_cuenta,imp_tipcam,
                   Fecha_Sld,Fecha_Apre,Cod_Ctacli,Num_Titcta,
                   ind_version,Key_Geografia,ind_titren
                  )
           Select s.fecha,s.tiempo_key,to_number(to_char(s.fecha,'rrrrmm')),
                  s.codigo_asesor,s.asesor_key,s.cliente_key,
                  s.codigo_cliente, s.saldo_mn,s.cuentas_key,s.cuenta_ren_key,
                  s.codigo_cuenta,s.codigo_ctaren,sum(s.imp_renovmn),s.ind_ctaren,
                  s.ind_tipren,2,s.fecha_vencimie,
                  Case when to_char(s.fecha_vencimie,'rrrrmm') = to_char(s.fecha,'rrrrmm') 
                       Then 'Si' Else 'No' End,
                  s.fecha_cancela,s.cod_cuenta,ln_tipcam,ld_feccon,s.fecha_apre,
                  s.cod_ctacli,s.num_intcta,2,s.geografia_key,s.ind_titren
          From TMP_FACT_PRODASE_ASIGCLI s       
         Where s.codigo_producto = '22'      
           and s.est_asesor = 'S'
           and codigo_asesor = PV_CODASE
         Group By s.fecha,s.tiempo_key,to_number(to_char(s.fecha,'rrrrmm')),
                  s.codigo_asesor,s.asesor_key,s.cliente_key,
                  s.codigo_cliente, s.saldo_mn,s.cuentas_key,s.cuenta_ren_key,
                  s.codigo_cuenta,s.codigo_ctaren,s.ind_ctaren,
                  s.ind_tipren,2,s.fecha_vencimie,
                  Case when to_char(s.fecha_vencimie,'rrrrmm') = to_char(s.fecha,'rrrrmm') 
                       Then 'Si' Else 'No' End,
                  s.fecha_cancela,s.cod_cuenta,s.fecha_apre,
                  s.cod_ctacli,s.num_intcta,2,s.geografia_key,s.ind_titren  
          ;
          -- and s.fecha = ld_inimes;
         Commit;
         Exception WHen Others Then
              lv_err := substr(sqlerrm,1,200);
         End;      
         
         For x in c_dpfnoren Loop
            lnRenO := 0;
            lnImpr := x.imp_renmn;
              
            Begin
                select sum(nvl(saldo_base,0)),sum(nvl(saldo_avance,0))
                  into lnSbas,lnSava
                  from dwstage.tmp_fact_pasivos_proase d 
                 where codigo_asesor = x.codigo_asesor
                   and codigo_cliente = x.codigo_cliente 
                   and tipreg=1; 
            Exception When Others Then
               lnSbas := 0; lnSava := 0; lnPorc := 0;
            End;     
              
            If nvl(lnSbas,0) <> 0 Then
               lnPorc := nvl(lnSava,0)/nvl(lnSbas,0); 
            End If;   
              
            If nvl(lnSava,0) >= nvl(lnSbas,0)  Then
               
               If x.ind_titren > x.num_titcta Then
                   lnDif := (x.Saldo*x.ind_titren) - x.imp_renmn; 
                   --lnImpr := x.Saldo * x.ind_titren;
                   --lnRenO := x.imp_renmn;                 
               Else  
                   lnDif := x.Saldo - x.imp_renmn;
                   --lnImpr := x.Saldo;
                   --lnRenO := x.imp_renmn;
               End If;    
              
            -- TOTALES POR CLIENTE
            DifTot := 0;
            Begin
                Select sum(nvl(imp_renmn,0)/nvl(ind_titren,1))TotRen,
                       sum(nvl(saldo,0)/nvl(num_titcta,1)) MetRen
                  Into TotRen, TotMet     
                  From tmp_fact_pasivos_proase f
                 Where tipreg = 2 
                   and ind_venmes = 'Si' 
                   and f.codigo_cliente = x.codigo_cliente
                   and codigo_asesor = x.codigo_asesor;
            Exception When Others Then
               TotRen:=0; TotMet := 0;
            End;
            DifTot :=  (TotMet - TotRen) * nvl(x.ind_titren,1);
            
            If DifTot > 0 Then 
              If lnDif > DifTot Then
                 lnDif := DifTot;
              End If;  
            -- 
                 
              For z in c_dpf(x.codigo_cliente,x.codigo_asesor) Loop
                   lnRenO := z.RenTot;
                   lnImpr := z.RenTot + lnDif;
                   
                   Update dwstage.tmp_fact_pasivos_proase s
                      set s.saldo_base = nvl(lnSbas,0),
                          s.saldo_avance = nvl(lnSava,0),
                          s.por_logro = nvl(lnPorc,0),
                          s.saldo_logro = lnRenO,
                          s.imp_renmn   = lnImpr
                    Where s.codigo_asesor = z.codigo_asesor
                      and s.codigo_cliente = z.codigo_cliente       
                      and s.tipreg = 2 
                      and s.ind_venmes = 'Si' 
                      and s.cuentas_key = z.cuentas_key
                      and nvl(s.imp_renmn,0) = nvl(z.RenTot,0);
                    Commit;
                    Exit;
              End Loop;
            End If;
           End If;  
           
           Commit;
        End Loop;
          
  END SP_PRAS_RENOV_ASESOR;  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- -- --
  PROCEDURE SP_PRAS_COPIA_RENOV(PD_FECHA In Date, PN_TIPCAM In Number)
  IS
       Cursor c_dpfnoren
               is select * 
                   from (select codigo_cliente, codigo_asesor,sum(nvl(imp_renmn,0)) imp_renmn,
                                sum(nvl(saldo,0)) saldo ,num_titcta,ind_titren
                          from (select codigo_cliente, codigo_asesor,
                                       sum(nvl(imp_renmn,0)) imp_renmn,nvl(saldo,0) saldo,
                                       num_titcta,ind_titren,cuentas_key
                                  from tmp_fact_pasivos_proase f
                                 where tipreg = 2 and ind_venmes = 'Si' 
                                   and (fec_vencta <= PD_FECHA or 
                                        ((fec_vencta > PD_FECHA) and cuentas_ren_key is not null))
                                -- and f.codigo_cliente = '6042141593401'
                               -- and codigo_asesor = 'CVIZCARRA'
                                 group by codigo_cliente, codigo_asesor,nvl(saldo,0) ,
                                          num_titcta,ind_titren,cuentas_key
                               )
                         group by codigo_cliente, codigo_asesor,num_titcta,ind_titren,cuentas_key
                        ) 
                  Where nvl(imp_renmn,0)/ind_titren < (nvl(saldo,0)/num_titcta);      
                /*select distinct codigo_cliente, codigo_asesor, cuentas_key, nvl(imp_renmn,0) imp_renmn,nvl(saldo,0) saldo
                                  ,num_titcta,ind_titren
                  from tmp_fact_pasivos_proase f
                 where tipreg = 2 and ind_venmes = 'Si' 
                  and nvl(imp_renmn,0)/ind_titren < nvl(saldo,0)/num_titcta;*/ 
      
  
       Cursor c_dpf(lvC in Varchar2,lvA in Varchar2) 
           is select DAT.*,saldo-imp_renmn DIF from (
                select codigo_cliente, codigo_asesor,sum(nvl(imp_renmn,0)/ind_titren) imp_renmn,nvl(saldo,0)/num_titcta saldo
                       ,num_titcta,ind_titren,f.cuentas_key,sum(nvl(imp_renmn,0)) RenTot
                  from tmp_fact_pasivos_proase f
                 where tipreg = 2 and ind_venmes = 'Si' 
                   and codigo_cliente = lvC
                   and codigo_asesor = lvA
                group by codigo_cliente, codigo_asesor,nvl(saldo,0)/num_titcta ,num_titcta,ind_titren,f.cuentas_key
                )DAT where imp_renmn < saldo;

       lnSbas    Number(12,2);
       lnSava    Number(12,2);
       lnPorc    Number(20,6); 
       lnImpr    Number(12,2);     
       lnRenO    Number(12,2);  
       ln_tipcam Number(7,3) := PN_TIPCAM;
       ld_feccon Date := PD_FECHA;
       lv_err    Varchar2(200);
       lnDif     Number(12,2);
       TotRen    Number(12,2); 
       TotMet    Number(12,2);
       DifTot    Number(12,2);
       
  BEGIN
       -- INSERTA DETALLE DE RENOVACIONES
       Delete from TMP_FACT_PASIVOS_PROASE n where n.tipreg=2 and ind_version = 2
       ;--and codigo_asesor = 'CVIZCARRA';
       Commit;
       
       Begin
       Insert Into TMP_FACT_PASIVOS_PROASE
                  (fecha,tiempo_key,periodo,codigo_asesor,asesor_key,
                   cliente_key,codigo_cliente,saldo,
                   cuentas_key,cuentas_ren_key,
                   codigo_cuenta,codigo_cuenta_ren,imp_renmn,
                   ind_ctaren,ind_tipren,tipreg,fec_vencta,
                   ind_venmes,fec_cancela,cod_cuenta,imp_tipcam,
                   Fecha_Sld,Fecha_Apre,Cod_Ctacli,Num_Titcta,
                   ind_version,Key_Geografia,ind_titren
                  )
           Select s.fecha,s.tiempo_key,to_number(to_char(s.fecha,'rrrrmm')),
                  s.codigo_asesor,s.asesor_key,s.cliente_key,
                  s.codigo_cliente, s.saldo_mn,s.cuentas_key,s.cuenta_ren_key,
                  s.codigo_cuenta,s.codigo_ctaren,sum(s.imp_renovmn),s.ind_ctaren,
                  s.ind_tipren,2,s.fecha_vencimie,
                  Case when to_char(s.fecha_vencimie,'rrrrmm') = to_char(s.fecha,'rrrrmm') 
                       Then 'Si' Else 'No' End,
                  s.fecha_cancela,s.cod_cuenta,ln_tipcam,ld_feccon,s.fecha_apre,
                  s.cod_ctacli,s.num_intcta,2,s.geografia_key,s.ind_titren
          From TMP_FACT_PRODASE_ASIGCLI s       
         Where s.codigo_producto = '22'      
           and s.est_asesor = 'S'
         --  and codigo_asesor = 'CVIZCARRA'
         Group By s.fecha,s.tiempo_key,to_number(to_char(s.fecha,'rrrrmm')),
                  s.codigo_asesor,s.asesor_key,s.cliente_key,
                  s.codigo_cliente, s.saldo_mn,s.cuentas_key,s.cuenta_ren_key,
                  s.codigo_cuenta,s.codigo_ctaren,s.ind_ctaren,
                  s.ind_tipren,2,s.fecha_vencimie,
                  Case when to_char(s.fecha_vencimie,'rrrrmm') = to_char(s.fecha,'rrrrmm') 
                       Then 'Si' Else 'No' End,
                  s.fecha_cancela,s.cod_cuenta,s.fecha_apre,
                  s.cod_ctacli,s.num_intcta,2,s.geografia_key,s.ind_titren  
          ;
          -- and s.fecha = ld_inimes;
         Commit;
         Exception WHen Others Then
              lv_err := substr(sqlerrm,1,200);
         End;      
         
         For x in c_dpfnoren Loop
            lnRenO := 0;
            lnImpr := x.imp_renmn;
              
            Begin
                select sum(nvl(saldo_base,0)),sum(nvl(saldo_avance,0))
                  into lnSbas,lnSava
                  from dwstage.tmp_fact_pasivos_proase d 
                 where codigo_asesor = x.codigo_asesor
                   and codigo_cliente = x.codigo_cliente 
                   and tipreg=1; 
            Exception When Others Then
               lnSbas := 0; lnSava := 0; lnPorc := 0;
            End;     
              
            If nvl(lnSbas,0) <> 0 Then
               lnPorc := nvl(lnSava,0)/nvl(lnSbas,0); 
            End If;   
              
            If nvl(lnSava,0) >= nvl(lnSbas,0)  Then
               
               If x.ind_titren > x.num_titcta Then
                   lnDif := (x.Saldo*x.ind_titren) - x.imp_renmn; 
                   --lnImpr := x.Saldo * x.ind_titren;
                   --lnRenO := x.imp_renmn;                 
               Else  
                   lnDif := x.Saldo - x.imp_renmn;
                   --lnImpr := x.Saldo;
                   --lnRenO := x.imp_renmn;
               End If;    
              
            -- TOTALES POR CLIENTE
            DifTot := 0;
            Begin
                Select sum(nvl(imp_renmn,0)/nvl(ind_titren,1))TotRen,
                       sum(nvl(saldo,0)/nvl(num_titcta,1)) MetRen
                  Into TotRen, TotMet     
                  From tmp_fact_pasivos_proase f
                 Where tipreg = 2 
                   and ind_venmes = 'Si' 
                   and f.codigo_cliente = x.codigo_cliente
                   and codigo_asesor = x.codigo_asesor;
            Exception When Others Then
               TotRen:=0; TotMet := 0;
            End;
            DifTot :=  (TotMet - TotRen) * nvl(x.ind_titren,1);
            
            If DifTot > 0 Then 
              If lnDif > DifTot Then
                 lnDif := DifTot;
              End If;  
            -- 
                 
              For z in c_dpf(x.codigo_cliente,x.codigo_asesor) Loop
                   lnRenO := z.RenTot;
                   lnImpr := z.RenTot + lnDif;
                   
                   Update dwstage.tmp_fact_pasivos_proase s
                      set s.saldo_base = nvl(lnSbas,0),
                          s.saldo_avance = nvl(lnSava,0),
                          s.por_logro = nvl(lnPorc,0),
                          s.saldo_logro = lnRenO,
                          s.imp_renmn   = lnImpr
                    Where s.codigo_asesor = z.codigo_asesor
                      and s.codigo_cliente = z.codigo_cliente       
                      and s.tipreg = 2 
                      and s.ind_venmes = 'Si' 
                      and s.cuentas_key = z.cuentas_key
                      and nvl(s.imp_renmn,0) = nvl(z.RenTot,0);
                    Commit;
                    Exit;
              End Loop;
            End If;
           End If;  
           
           Commit;
        End Loop;
          
  END SP_PRAS_COPIA_RENOV;  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- -- --
  PROCEDURE SP_PRAS_LOGRO_JEF(PD_FECHA In Date)
  IS
    ld_fecin date := to_date(to_char(PD_FECHA,'rrrrmm')||'01','rrrrmmdd');
    ln_perio number(10) := to_number(to_char(PD_FECHA,'rrrrmm'));
    ln_peran number(10) := to_number(to_char(add_months(ld_fecin,-1),'rrrrmm'));
    
    Cursor c_suplog(ln_per in Number)
        is Select trim(tp1desc) codsup,tp1imp2 porbas,tp1imp3 imppag
             from dwextra.fst198 d where d.tp1cod1 = 10819 and d.tp1corr1 = 35 
              and tp1corr3=ln_per and  tp1corr2 = 2 and tp1nro2 = 1;
 
    Cursor c_pagsup(ldf1 in Date, ldf2 in Date)
       is select fecha,codigo_asesor, fecha_sld,tipreg,
                 saldo_meta metac,
                 saldo_logro logroc,nvl(d.ind1_logro,0) ind1_logro,
                 imp_metren metar,
                 imp_logren logror,nvl(d.ind2_logro,0) ind2_logro,
                 sldaho metaa,
                 saldo_aho logroa,nvl(d.ind3_logro,0) ind3_logro
            from tmp_fact_pasivos_proase d
            where fecha = ldf1
              and fecha_sld = ldf2
              and tipreg = 9; 
    
    lnUsrK Number(10);     
    lnCod  Number(5) := 10819;
    lnPorV Number(8,4); lnImpV Number(12,2); lnCodA Number(2);
    lnRemB Number(12,2);
    lnPorC Number(8,4);
    lnPorR Number(8,4);
    lnPorA Number(8,4);
    lv_err Varchar2(200);
    ln_exi number(5);
    
  BEGIN
    -- REVISA SALDOS
    select count(*) Into ln_exi From dwextra.fst198 
     where tp1cod1 = 10819 and tp1corr1 = 37
       and tp1nro1 = ln_perio;
    
    If ln_exi = 0 Then    
       Begin
           Insert into dwextra.fst198
                  (tp1cod, tp1cod1, tp1corr1, tp1corr2, tp1corr3, tp1nro1, 
                   tp1nro2, tp1nro3, tp1desc, tp1imp1, tp1imp2, tp1imp3)
           Select tp1cod, tp1cod1, tp1corr1,  tp1corr2, tp1corr3, ln_perio tp1nro1, 
                  tp1nro2, tp1nro3, tp1desc, tp1imp1, tp1imp2, tp1imp3 
             from dwextra.fst198 where tp1cod1 = 10819 and tp1corr1 = 37
              and tp1nro1 = ln_peran;
            Commit;    
       Exception When Others Then
          Null;
       End;             
    End If;
    
    Delete from tmp_fact_pasivos_proase where tipreg = 9;
    Commit;
            
    --- INSERT SALDOS
    Begin
        Insert Into tmp_fact_pasivos_proase 
                    (fecha,tiempo_key,codigo_asesor,asesor_key,saldo_meta,saldo_logro,
                     imp_metren,imp_logren,sldaho,saldo_aho,tipreg,ind_version,fecha_sld
                    )
            Select f.fecha, f.tiempo_key,j.codsup,j.usuario_key,
                    sum(nvl(f.saldo_meta,0)) metacrec,
                    sum(nvl(f.saldo_logro,0)) logrocrec,
                    sum(nvl(f.imp_metren,0)) metaretencion,
                    sum(nvl(f.imp_logren,0)) logroretencion,
                    sum(nvl(f.sldaho,0)) metaagencia,
                    sum(nvl(f.saldo_aho,0)) logroagencia, 
                    9 tipreg,2 indver,f.fecha_sld
               From tmp_fact_pasivos_proase  f
               Join (select tp1nro1,trim(tp1desc) codsup,u.usuario_key  
                       from dwextra.fst198 d
                       join dwhouse.dm_usuario u on u.codigo_usuario = trim(tp1desc) 
                      where tp1cod=1 and tp1cod1 = 10819 and tp1corr1 = 35 
                        and tp1corr3=ln_perio and tp1corr2 = 2 
                    ) j on j.tp1nro1 = f.niveje
            Where f.fecha = ld_fecin
              and f.fecha_sld = PD_FECHA
              and tipreg = 0
              and nvl(IND_VERSION,1) = 2 
            group by  f.fecha, f.tiempo_key,j.codsup,f.fecha_sld,j.usuario_key; 
          Commit;
      Exception When Others Then
         lv_err := substr(sqlerrm,1,200);
      End;        
      
      For x In c_suplog(ln_perio) Loop
          Begin
              Update tmp_fact_pasivos_proase 
                 set ind1_logro = nvl(saldo_logro,0)/nvl(saldo_meta,0) ,
                     ind2_logro = nvl(imp_logren,0)/nvl(imp_metren,0),
                     ind3_logro = nvl(saldo_aho,0)/nvl(sldaho,0),
                     por_logro  = x.porbas,
                     metnue    = x.imppag
               Where codigo_asesor = x.codsup
                 and fecha = ld_fecin
                 and fecha_sld = PD_FECHA 
                 and tipreg = 9; 
               Commit;
          Exception When Others Then
             lv_err := substr(sqlerrm,1,200);
          End;             
      End Loop;       
      
      --- Pago
      For x in c_pagsup(ld_fecin, PD_FECHA) Loop
          -- Porcentaje y Variable
          Begin
              Select d.tp1imp2,d.tp1imp3,d.tp1nro3
                Into lnPorV, lnImpV,lnCodA
                from dwextra.fst198 d 
               where d.tp1cod1 = lnCod 
                 and d.tp1corr1 = 35 
                 and tp1corr3 = ln_perio
                 and tp1corr2 = 2
                 and trim(tp1desc) = trim(x.codigo_asesor)
                 and d.tp1nro2 = 1;
              
              lnRemB := lnImpV/lnPorV;
          Exception When Others then
             lnPorV :=0; lnImpV :=0; lnCodA :=0; lnRemB :=0;
          End;   
        
          Begin
              -- Rango Crecimiento
              Select d.tp1imp3 Into lnPorC
                from dwextra.fst198 d 
               where d.tp1cod1 = lnCod 
                 and d.tp1corr1 = 37 
                 and d.tp1corr2 = 1 --tabla
                 and tp1nro1=ln_perio 
                 and d.tp1nro2 = lnCodA
                 and (x.ind1_logro*100) between d.tp1imp1 and d.tp1imp2;
          Exception When Others then
              lnPorC := 0;
          End;   
        
          Begin
              -- Rango Renovacion
              Select d.tp1imp3 Into lnPorR
                from dwextra.fst198 d 
               where d.tp1cod1 = lnCod 
                 and d.tp1corr1 = 37 
                 and d.tp1corr2 = 2 --tabla
                 and tp1nro1=ln_perio 
                 and d.tp1nro2 = lnCodA
                 and (x.ind2_logro*100) between d.tp1imp1 and d.tp1imp2;
          Exception When Others then
              lnPorR := 0;
          End;      
        
          Begin        
              -- Rango Agencia   
              Select d.tp1imp3 Into lnPorA
                from dwextra.fst198 d 
               where d.tp1cod1 = lnCod 
                 and d.tp1corr1 = 37 
                 and d.tp1corr2 = 3 --tabla
                 and tp1nro1=ln_perio 
                 and d.tp1nro2 = lnCodA
                 and (x.ind3_logro*100) between d.tp1imp1 and d.tp1imp2;
          Exception When Others then
             lnPorA := 0;
          End;   
          
          Begin 
              Update tmp_fact_pasivos_proase s
                 set por_logro = lnPorV, 
                     metnue = lnImpV,
                     s.niveje = lnCodA,
                     s.ind1_peso = (lnPorC/100),
                     s.ind1_pago = lnRemB * (lnPorC/100),
                     s.ind2_peso = (lnPorR/100),
                     s.ind2_pago = lnRemB * (lnPorR/100),
                     s.ind3_peso = (lnPorA/100),
                     s.ind3_pago = lnRemB * (lnPorA/100)
               Where s.codigo_asesor = x.codigo_asesor
                 and s.fecha =  x.fecha
                 and s.tipreg = x.tipreg
                 and s.fecha_sld = x.fecha_sld;
          Exception When Others then
             lv_err := substr(sqlerrm,1,200);
          End;                  
      End Loop;  
  END SP_PRAS_LOGRO_JEF; 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- -- --   
  PROCEDURE SP_PRAS_CAPTACIONES_BASE_DIAANT(PD_FECHA In Date)
  IS
    ld_feccon date := PD_FECHA;    
    ld_inimes date := to_date(to_char(ld_feccon,'rrrrmm')||'01','rrrrmmdd');
    ld_iniman date := ld_inimes;
    ln_tipcam number(7,3) := pq_tmp_productividadase.fn_tipo_cambio_fijo(ld_feccon);
    ln_tiemp  number(10)  := dwhouse.pq_carga_facts.fn_tiempo_key(ld_inimes);  
    ln_tiesld number(10)  := dwhouse.pq_carga_facts.fn_tiempo_key(ld_feccon); 
    ln_period number(6)   := to_number(to_char(ld_feccon,'rrrrmm'));
    ln_tieman number(10)  := dwhouse.pq_carga_facts.fn_tiempo_key(last_day(add_months(ld_inimes,-1))); 
    ld_fecact date := trunc(sysdate);
    ld_regcli date := last_day(ld_feccon) + 0; -- Registro de clientes hasta fin de mes
    ln_keycl  number(10); 
    lv_codase varchar2(10);  
    ln_keyase Number(10);    
    ln_tipcli Number(1);    
    ln_nuev   Number(5);
    ln_inac   Number(5);
    ln_vige   Number(5);
    ln_slddpf Number(12,2);     
    ln_sldaho Number(12,2);    
    ln_sldcts Number(12,2);    
    ld_actcta Date;   
    ld_fecape Date;
    ln_ctakey Number(10);
    lv_codcta varchar2(40);
    ln_sldcre number(12,2);
    ln_rucemp varchar2(12);
    ln_empkey number(10);
    ld_feccan date; 
    ld_ultcan date;
    ld_fecage date;
    ld_feccar date := dwextra.pq_tmp_extrae_fuentes.fn_lee_fecha_cierre;
    lv_indcol varchar2(1);  
    lv_msg varchar2(200);
    ln_sldcdpf number(12,2);
    ln_sldcaho number(12,2);
    ln_sldccts number(12,2);
    lv_aseasi  varchar2(12);
    ln_saldo number(12,2);
    ln_indins number(2);
    ln_ininac number(2);
    
    ld_iniape date;
    
    ln_tdiaan number(10); 
    
    
    -- Clientes Registrados en Herramienta Autogesti/Agenda Comercial
    Cursor c_cliage(ld_ini in Date, ld_fin in Date,ln_per in Number,ld_fmax in date) is
           SELECT DISTINCT NPAIS jaql108pai,NTDOC jaql108ptd,RPAD(trim(VNDOC),12,' ') jaql108doc,
                             TRIM(NPAIS||NTDOC||VNDOC) codcli,
                             NPAIS pais,NTDOC tdoc,RPAD(trim(VNDOC),12,' ') ndoc
             FROM TMP_AGECOM
            WHERE trunc(feceva) between ld_ini and ld_fmax
            -- and trim(VNDOC) = '18087072'
             --and usureg = 'MYDROGO'
            ;
           

                            
    Cursor c_detdep(ln_tie In number,lv_cli In Varchar2,ln_tipc In Number)
        Is  Select k.cuentas_key,k.codigo_cuenta,k.cod_cuenta,
                  m.codigo_producto,m.codigo_subproducto,
                  decode(p.moneda_key,1,p.saldo_mo,p.saldo_mo*ln_tipc) saldo,
                  k.fecha_apertura,k.fecha_cancelac,e.ruc,
                  i.aosuc ln_suc, i.aomda ln_mda, i.aocta ln_cta, i.aoope ln_ope,
                  i.aosbo ln_sbo,i.aotop ln_top,i.aomod ln_mod,k.cuenta,
                  case when m.codigo_producto = '21' 
                       Then decode(p.moneda_key,1,p.saldo_mo,p.saldo_mo*ln_tipc) else 0 End sldaho,
                  case when m.codigo_producto = '22' 
                       Then decode(p.moneda_key,1,p.saldo_mo,p.saldo_mo*ln_tipc) else 0 End slddpf,  
                  case when m.codigo_producto = '211' 
                       Then decode(p.moneda_key,1,p.saldo_mo,p.saldo_mo*ln_tipc) else 0 End sldcts ,
                       p.estado_key,
                       (select count(*) from dwextra.fsr008 Where ctnro = r.ctnro) nro_tit 
             From dwhouse.fact_pasivo p
             Join dwhouse.dm_producto m on m.producto_key = p.producto_key
             Join dwhouse.dm_cuentas k on k.cuentas_key = p.cuentas_key
             Join dwextra.fsr008 r on r.ctnro = k.cuenta
             Join dwhouse.dm_cliente c on c.pais = r.pepais
                                and c.tipo_docum = r.petdoc
                          and c.nro_docum = trim(r.pendoc) 
             Join dwhouse.dm_empleador e on e.empleador_key = p.empleador_key  
             Join dwstage.tmp_dm_cuenta i on i.codigo_cuenta = k.codigo_cuenta
             and i.cuenta_unica = k.cuenta_unica            
           Where p.tiempo_key     = ln_tie 
             and c.codigo_cliente = lv_cli 
             and p.estado_key <> 72;
             --and (p.estado_key <> 72 and k.fecha_cancelac Is Null);
                                       
    Cursor c_depcap(ln_tie In number,lv_cli In Varchar2,ln_tipc In Number,
                    ld_inif Date,ld_ffi In Date,
                    ln_pai In Number, ln_tdo In Number, lc_ndo In Char)
        Is Select /*+index(temp_fact_saldos,IX_TEMP_FSALDOS_1)*/
                  cuentas_key,codigo_cuenta,cod_cuenta,
                  codigo_producto,codigo_subproducto,
                  saldo,fecha_apertura,fecha_cancelac,ruc,
                  ln_suc, ln_mda, ln_cta, ln_ope,
                  ln_sbo,ln_top,ln_mod,estado_key,nro_tit,  
                  nrotit,cuenta  
             From temp_fact_saldos
            Where tiempo_key = ln_tie 
              and pepais = ln_pai
              and petdoc = ln_tdo
              and pendoc = lc_ndo
              and (estado_key <> 72 
                  and (fecha_cancelac is null or fecha_cancelac > fecha)
                 );
              /* 2024.02.28
                 and (
                   (fecha_apertura between ld_inif and ld_ffi) OR
                   (fecha_renovaci between ld_inif and ld_ffi)
                  ); 
                 2024.02.28
              */
        
        
            
    ln_sldava number(12,2);
    ln_excta number(3);
    ln_sldbas number(12,2);
    ln_codreg number(4);
    ln_codsuc number(4);
    
    ln_clirec number(1);
    lv_clirec varchar2(2);
    
 Begin
   -- Excepcion solicitada por Karolina solo para Abril 2022 
   IF to_char(ld_feccon,'rrrrmm') <= '202205' Then
      ld_regcli := ld_regcli + 5;
   End IF;
       
   Delete from TMP_FACT_PASIVOS_PROASE where fecha = ld_inimes and nvl(tipreg,0) = 3 and ind_version = 2;
   Commit;

   --- INSERTA DATOS DE FACT_PASIVOS
   Begin
         Execute Immediate 'Truncate table temp_fact_pasivos';
         Execute Immediate 'Insert into temp_fact_pasivos '||
                     '(moneda_key,saldo_mo,estado_key,producto_key,cuentas_key,empleador_key,'||
                      'tiempo_key,cliente_key) '||   
                     'Select moneda_key,saldo_mo,estado_key,producto_key,cuentas_key,empleador_key,'||
                            'tiempo_key,cliente_key  '||
                        'From dwhouse.fact_pasivo partition(fact_pasivo_'||to_char(ld_feccon,'rrrrmmdd')||') '||
                       'Where estado_key <> 72';
         Commit;  
   Exception When Others Then
      Null;
   End;    
   
   --- INSERTA DATOS COMPLETOS
   Begin
         Execute Immediate 'Truncate table temp_fact_saldos';
         Execute Immediate 'Insert into temp_fact_saldos '||
                          '(fecha, cuentas_key, codigo_cuenta, cod_cuenta, codigo_producto, codigo_subproducto,'|| 
                           'saldo, fecha_apertura, fecha_cancelac, ruc, ln_suc, ln_mda, ln_cta, ln_ope, ln_sbo, '||
                           'ln_top, ln_mod, estado_key, nro_tit, nrotit, cuenta, pepais, petdoc, pendoc, '||
                           'fecha_renovaci,sldaho,slddpf,sldcts,codigo_cliente,tiempo_key) '||
                          'Select tm.fecha,k.cuentas_key,k.codigo_cuenta,k.cod_cuenta,'||
                                 'm.codigo_producto,m.codigo_subproducto, '||
                                 'decode(p.moneda_key,1,p.saldo_mo,p.saldo_mo*:1) saldo, '||
                                 'k.fecha_apertura,k.fecha_cancelac,e.ruc, '||
                                 'i.aosuc ln_suc, i.aomda ln_mda, i.aocta ln_cta, i.aoope ln_ope, '||
                                 'i.aosbo ln_sbo,i.aotop ln_top,i.aomod ln_mod, '||
                                 'p.estado_key, '||
                                 '(select count(*) from dwextra.fsr008 Where  ctnro = r.ctnro) nro_tit, '||  
                                 '1 nrotit,k.cuenta     ,r.pepais,r.petdoc,r.pendoc,k.fecha_renovaci, '||
                                 'Case when m.codigo_producto = ''21'' '|| 
                                  'Then decode(p.moneda_key,1,p.saldo_mo,p.saldo_mo*:2) else 0 End, '||
                                 'Case when m.codigo_producto = ''22'' '|| 
                                  'Then decode(p.moneda_key,1,p.saldo_mo,p.saldo_mo*:3) else 0 End, '||  
                                 'Case when m.codigo_producto = ''211'' '||
                                  'Then decode(p.moneda_key,1,p.saldo_mo,p.saldo_mo*:4) else 0 End,'||
                                 'cl.codigo_cliente,p.tiempo_key '|| 
                           'From temp_fact_pasivos p '||             
                           'Join dwhouse.dm_producto m on m.producto_key = p.producto_key '||
                           'Join dwhouse.dm_empleador e on e.empleador_key = p.empleador_key '|| 
                           'Join dwhouse.dm_cuentas k on k.cuentas_key = p.cuentas_key '||
                           'Join dwstage.tmp_dm_cuenta i on i.codigo_cuenta = k.codigo_cuenta '||
                            'and i.cuenta_unica = k.cuenta_unica '||
                           'Join dwextra.fsr008 r on r.ctnro = k.cuenta '|| 
                           'Join dwhouse.dm_tiempo tm on tm.tiempo_key = p.tiempo_key '||
                           'Join dwhouse.dm_cliente cl on cl.cliente_key = p.cliente_key '
                            
         Using ln_tipcam,ln_tipcam,ln_tipcam,ln_tipcam;  
         Commit;  
   Exception When Others Then
      Null;
   End;     
             

   For x in c_cliage(ld_inimes,ld_feccon,ln_period,ld_regcli) Loop
       ln_indins := 0;
       -- ¿ESTA ASIGNADO?
       Begin
           select distinct a.codigo_asesor Into lv_aseasi 
             from TMP_FACT_PRODASE_ASIGCLI a 
            where a.periodo = ln_period
              and a.est_asesor = 'S'
              and a.codigo_cliente = x.codcli;
       Exception When Others Then
            lv_aseasi := Null;
       End;
       
       -- Asesor/Analista que lo Registra Primero
       If ld_feccon <= to_date('20220531','rrrrmmdd') Then
           Begin
                Select trim(jaql108usu),fecha Into lv_codase,ld_fecage
                  From (
                        Select j.jaql108usu,
                               to_Date(to_char(j.jaql108fch,'rrrrmmdd')||' '||j.jaql108a04,'rrrrmmdd hh24:mi:ss') fecha
                          From dwextra.jaql108 j
                         Where j.jaql108pai = x.pais
                           and j.jaql108ptd = x.tdoc
                           and j.jaql108doc = x.ndoc
                           and j.jaql108fch between ld_iniman and ld_regcli
                        UNION ALL
                        Select cusuing,dfeceva
                          from dwextra.acdeval ac 
                         where npaicli=x.jaql108pai 
                           and ntipdoc=x.jaql108ptd 
                           and cnumdoc=trim(x.jaql108doc)
                           and d_feceva between ld_iniman and ld_regcli
                           and exists (select 1 
                                         from dwextra.fst198 u 
                                        where u.tp1cod = 1 
                                          and u.tp1cod1 = 10819 
                                          and u.tp1corr1 = 302
                                          and tp1corr3 = ln_period
                                          and trim(upper(tp1desc))  = trim(ac.cusuing)
                                      )
                        Order by 2
                       )
                 Where rownum = 1;      
           Exception When Others Then
             lv_codase := null;
             ld_fecage := null;
           End;
       Else 
           Begin
                Select USUREG,FECEVA
                  Into lv_codase,ld_fecage
                  From (SELECT UPPER(USUREG) USUREG ,FECEVA
                          FROM TMP_AGECOM
                         where NPAIS=x.pais and NTDOC=x.tdoc 
                           and trim(VNDOC) = trim(x.ndoc)
                         Order by 2
                        ) 
                  Where Rownum = 1;
           Exception When Others Then
             lv_codase := null;
             ld_fecage := null;
           End;
       End If;
                   
       -- TIPO DE CLIENTE
       -- ¿Es Nuevo - integra cuenta cliente?

       -- ES COLABORADOR CAJA
       Begin
         Select nvl(c.pfebco,'N') Into lv_indcol
           From dwextra.fsd002 c
          Where c.pfpais = x.jaql108pai 
            and c.pftdoc = x.jaql108ptd
            and c.pfndoc = x.jaql108doc;
       Exception When Others Then
          lv_indcol := 'N';
       End;   
       
              
       ln_keyase := pq_tmp_carga_key.fn_asesor_key(lv_codase);
       ln_keycl  := pq_tmp_carga_key.fn_cliente_key(x.codcli);
       
       -- Cuentas Aperturadas/Renovadas en el mes en curso
       ln_tiesld := dwhouse.pq_carga_facts.fn_tiempo_key(ld_feccon);
       
       --- CLIENTE RECAUDACION
       ln_clirec := 0;
       lv_clirec:=dwstage.pq_tmp_productividadase.FN_CLIENTE_RECAUDACION(x.jaql108pai,x.jaql108ptd,x.jaql108doc,ln_keycl);
       If lv_clirec = 'R' Then
          ln_clirec := 1;
       End If;        
       
       
       --ld_iniape := (trunc(ld_fecage) - 1); 
       ld_iniape := trunc(ld_fecage); 
       For u In c_depcap(ln_tiesld, 
                         x.codcli, 
                         ln_tipcam, 
                         ld_iniape, --ld_inimes, 
                         ld_feccon,
                         x.jaql108pai, 
                         x.jaql108ptd, 
                         x.jaql108doc)
          Loop
              ld_actcta := Null;
              ln_saldo  := 0;

              --- 2021.10.21: REVISAR SI OTRO TITULAR DE LA CUENTA FUE REGISTRADO ANTES EN HA
              ln_excta  := 0;

              --- 2021.08.20 REVISAR SI CUENTA YA FUE CONSIDERADA EN OTRO TITULAR
              ln_sldava := nvl(u.saldo,0);
              --ln_sldava := nvl(u.saldo/u.nrotit,0);
             
              --- 2021.08.20
              --- 2021.10.21----
              Insert Into TMP_FACT_PASIVOS_PROASE(fecha, tiempo_key, 
                                                  codigo_asesor, asesor_key, codigo_cliente, cliente_key,
                                                  periodo, tipreg, codigo_cuenta, ind_ctaren, cod_cuenta, fec_vencta,
                                                  fec_cancela, cuentas_key, val_rucemp, fec_actcta, cod_modcta, 
                                                  cod_topcta, imp_renmn, saldo, fec_heraut, Ind_Colcaj, Fecha_Sld, Imp_Tipcam, Numdoc,
                                                  COD_ASEASI, IND_CTACRE, Codsuc, Regeje, cod_ctacli, num_titcta, ind_clirec,
                                                  ind_version
                                                 )  
                                           Values(ld_inimes, ln_tiemp,
                                                  lv_codase, ln_keyase, x.codcli, ln_keycl,
                                                  ln_period, 3, u.codigo_cuenta, ln_tipcli, u.cod_cuenta, u.fecha_apertura,
                                                  u.fecha_cancelac, u.cuentas_key, u.ruc, ld_actcta, u.codigo_producto,
                                                  u.codigo_subproducto, ln_sldava, ln_saldo, ld_fecage, lv_indcol,
                                                  ld_feccon,ln_tipcam,trim(x.jaql108doc),lv_aseasi,ln_excta,
                                                  ln_codsuc,ln_codreg,u.cuenta,u.nro_tit,ln_clirec,2
                                                 );  
              Commit;    
              ln_indins := 1;                                 
          End Loop;
             
          
       
          --- Detalle de Cuentas cierre de día anterior
          ln_tdiaan := dwhouse.pq_carga_facts.fn_tiempo_key(trunc(ld_fecage)-1); 
          
          For u In c_detdep(/*ln_tieman*/ln_tdiaan,x.codcli,ln_tipcam)Loop
              ln_indins := 1;
              ld_actcta := Null;
              If ln_indins = 1 Then
                  --- Saldo Avance
                  Begin
                     Select decode(p.moneda_key,1,p.saldo_mo,p.saldo_mo*ln_tipcam) 
                       Into ln_sldcre
                       From dwhouse.fact_pasivo p
                      Where p.tiempo_key = ln_tiesld
                        and p.cuentas_key = u.cuentas_key
                        and p.estado_key <> 72;
                  Exception When Others Then
                    ln_sldcre:= 0;
                  End;  
              
                  --- 2021.08.20 REVISAR SI CUENTA YA FUE CONSIDERADA EN OTRO TITULAR
                  ln_sldava := nvl(ln_sldcre,0);--/u.nrotit;
                  ln_sldbas := nvl(u.saldo,0);--/u.nrotit;
 
                  --- 2021.08.20
              
                  Insert Into TMP_FACT_PASIVOS_PROASE(fecha,tiempo_key,codigo_asesor,asesor_key,codigo_cliente,cliente_key,
                                                  periodo,tipreg,codigo_cuenta,ind_ctaren,cod_cuenta,fec_vencta,
                                                  fec_cancela,cuentas_key,val_rucemp,fec_actcta,cod_modcta,cod_topcta,
                                                  imp_renmn,saldo,fec_heraut,Ind_Colcaj,Fecha_Sld,Imp_Tipcam,Numdoc,
                                                  COD_ASEASI,Codsuc,Regeje,cod_ctacli,Num_Titcta,ind_clirec,ind_version
                                                 )  
                                           Values(ld_inimes,ln_tiemp,lv_codase,ln_keyase,x.codcli,ln_keycl,
                                                  ln_period,3,u.codigo_cuenta,ln_tipcli,u.cod_cuenta,u.fecha_apertura,
                                                  u.fecha_cancelac,u.cuentas_key,u.ruc,ld_actcta,u.codigo_producto,
                                                  u.codigo_subproducto,ln_sldava,ln_sldbas,ld_fecage,lv_indcol,
                                                  ld_feccon,ln_tipcam,trim(x.jaql108doc),lv_aseasi,ln_codsuc,ln_codreg,
                                                  u.cuenta,u.nro_tit,ln_clirec,2
                                                 );  
                  Commit;
                  --ln_indins := 1;  COMENTADO AQUI
              End If;   
              
              -- CAMBIO
              
          End Loop;
          
          -- NO TIENE SALDO ACTUAL NI EN MES ANTERIOR
          If (ln_indins = 0 and trunc(ld_fecage) between ld_inimes and ld_feccon)Then
              ln_saldo := 0;
                  Insert Into TMP_FACT_PASIVOS_PROASE(fecha,tiempo_key,codigo_asesor,asesor_key,codigo_cliente,cliente_key,
                                                      periodo,tipreg,codigo_cuenta,ind_ctaren,cod_cuenta,fec_vencta,
                                                      fec_cancela,cuentas_key,val_rucemp,fec_actcta,cod_modcta,cod_topcta,
                                                      imp_renmn,saldo,fec_heraut,Ind_Colcaj,Fecha_Sld,Imp_Tipcam,Numdoc,
                                                      COD_ASEASI,Codsuc,Regeje,Cod_Ctacli,Num_Titcta,ind_clirec,ind_version
                                                      )  
                                           Values(ld_inimes,ln_tiemp,lv_codase,ln_keyase,x.codcli,ln_keycl,
                                                  ln_period,3,null,ln_tipcli,null,null,
                                                  null,null,null,null,null,
                                                  null,null,ln_saldo,ld_fecage,lv_indcol,
                                                  ld_feccon,ln_tipcam,trim(x.jaql108doc),lv_aseasi,
                                                  ln_codsuc,ln_codreg,null,1,ln_clirec,2
                                                 );  
                    Commit;   
           End If; 
               
      End Loop;     
  END SP_PRAS_CAPTACIONES_BASE_DIAANT;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- -- --  

END PQ_TMP_PRODUCTIVIDADASE;
/
