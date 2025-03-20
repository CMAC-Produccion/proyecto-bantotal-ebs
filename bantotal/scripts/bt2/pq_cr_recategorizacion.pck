create or replace package PQ_CR_RECATEGORIZACION is

 -- *****************************************************************
  -- Nombre                     : PQ_CR_RECATEGORIZACION
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 
  -- Uso                        : PROCESOS DE RECATEGORIZACION DE ANALISTAS
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Autor de la Modificación   : EFUENTES
  -- Descripción de Modificación: 
  -- Fecha de Modificación      : 09/11/2021 13:06:25
  --                              2023.12.06 DCASTRO SE MODIFICO CONDICION DE PERMANENCIA
  --                              2024.01.12 DCASTRO se modifico sp_generar_recate
  ---                             2024.01.18 dcastro se comento exit en sp_generar_recate
  --                              2024.04.24 dcastro se modificó procedimiento sp_generar_recate
  --                              2024.05.09 dcastro se modificó procedimiento sp_generar_recate
  --                              2024.06.05 dcastro se modificó procedimiento fn_get_cantope, fn_get_mntdesem se modifico condicion de fecha

  -- *****************************************************************

  ------------------------------------------------------------------------------  
  function fn_get_cantope(pv_codana in varchar2,
                          pd_fecini in date,
                          pd_fecfin in date,
                          pd_fecdia in date) return number;
  ------------------------------------------------------------------------------  
  function fn_get_mntdesem(pv_codana in varchar2,
                           pd_fecini in date,
                           pd_fecfin in date,
                           pd_fecdia in date) return number;
  ------------------------------------------------------------------------------  
  function fn_get_sldRecibido(pv_codana in varchar2,
                              pd_fecini in date,
                              pd_fecfin in date) return number;                              
  ------------------------------------------------------------------------------  
  procedure sp_actualizar_metas(pn_catego in NUMBER,
                                pv_nomcat in VARCHAR2,
                                pv_tipage in VARCHAR2,
                                pn_monope in NUMBER,
                                pn_mondes in NUMBER,
                                pv_user   in VARCHAR2,
                                pd_fecpro in DATE,
                                pn_flag   out Varchar2);
  ------------------------------------------------------------------------------  
  procedure sp_nivel_analista(pv_codana   in varchar2,
                              pv_nivelAna out varchar2);
  ------------------------------------------------------------------------------  
  procedure sp_califi_analista(pv_codsbs  in varchar2,
                               pd_fecha   in date,
                               pn_normal  out number,
                               pn_cpp     out number,
                               pn_defici  out number,
                               pn_dudoso  out number,
                               pn_perdida out number);
  ------------------------------------------------------------------------------ 
  procedure sp_codigo_sbs(pn_pais in number,
                          pn_tdoc in number,
                          pv_ndoc in varchar2,
                          pv_csbs out varchar2);
  ------------------------------------------------------------------------------ 
  procedure sp_generar_recate(pd_fpro     in date,
                              pn_Analista in varchar2,
                              pn_flag     out Varchar2);

 ------------------------------------------------------------------------------ 
  procedure sp_fechasvalidas( pd_fpro     in date,
                              pd_fechaini out varchar2,
                              pd_fechafin out Varchar2) ;
-------------------------------------------------------------
  procedure sp_retorna_com_rrhh(pd_fpro     in date,
                              pn_Analista in varchar2,
                              pc_com1     out char,
                              pc_com2     out char,                              
                              pc_com3     out char,                              
                              pc_com4     out char,
                              pc_com5     out char,
                              pc_codt     out char                                                                                           
                              );
----------------------------------------------------------------
function fn_dias_suspension(pv_codana in varchar2,
                          pd_fecini in date,
                          pd_fecfin in date) return number;
-----------------------------------------------------------

procedure sp_generar_recate1(pd_fpro     in date,
                              pn_Analista in varchar2,
                              pn_flag     out Varchar2);
----------------------------------------------------------- 
 FUNCTION FN_CR_CANTIDAD_CLIENTES_ACTIVOS(P_CODIGO_ANALISTA IN VARCHAR2,
                                          P_FECHA_INICIO    IN DATE,
                                          P_FECHA_FIN       IN DATE,
                                          P_FECHA_DIA       IN DATE)
    RETURN NUMBER;
 ------------------------------------------------------------------------------            
end PQ_CR_RECATEGORIZACION;
/

create or replace package body PQ_CR_RECATEGORIZACION is
  ------------------------------------------------------------------------------
  function fn_get_cantope(pv_codana in varchar2,
                          pd_fecini in date,
                          pd_fecfin in date,
                          pd_fecdia in date) return number is
 --     2024.06.05 dcastro se modifico condición para validacion fecha                       
    ln_CantOpe number;
    my_errm    VARCHAR2(32000);
    cantidad_meses      number(10);
    fecha_concatenacion date;
    cantidad_operaciones number;
    total_cantidad_operaciones number;
  begin
 
    total_cantidad_operaciones := 0;
    
    cantidad_meses := months_between(pd_fecfin, pd_fecini);
    
    For f in 0 .. cantidad_meses loop

       fecha_concatenacion := ADD_MONTHS(pd_fecini, f);
        
          --dbms_output.put_line(fecha_concatenacion);
       begin   
          /*select count(*) into cantidad_operaciones
            from aqpb617a a17
           where (a17.aqpb617aase = RPAD(pv_codana, 10, ' ') or a17.aqpb617aase = pv_codana )
             and a17.aqpb617afpro = fecha_concatenacion;*/
           select /* +all_rows*/count(distinct AOOPER ) into cantidad_operaciones
            from fsd010 f, aqpb617a a17
           where f.pgcod = a17.AQPB617ACOD
             and f.aomda = a17.AQPB617AMDA
             and f.aopap = 0
             and f.aocta = a17.AQPB617ACTA
             --and f.aosuc = a17.AQPB617ASUCU
             and f.aooper = a17.AQPB617AOPER 
             and (a17.aqpb617aase = RPAD(pv_codana, 10, ' ') or a17.aqpb617aase = pv_codana )
             and a17.aqpb617afpro = fecha_concatenacion
             and (f.aostat <> 99 or (f.aostat = 99 and f.aofe99 > fecha_concatenacion) );
               
       exception when others then
             cantidad_operaciones := 0;  
       end;      
       total_cantidad_operaciones:= total_cantidad_operaciones + cantidad_operaciones;
             --dbms_output.put_line(cantidad_operaciones);
             --dbms_output.put_line(total_cantidad_operaciones);
      end loop;
 
     
      if pd_fecdia > pd_fecfin
        or  ( pd_fecdia < pd_fecfin  and pd_fecdia <> last_day(pd_fecdia) ) --2024.06.05 se agregó ocndicion
        --or (pd_fecdia < pd_fecfin /*or pd_fecfin = last_day(pd_fecdia)*/) --- 2023.12.06 se agrego condicion  
       then --obtener la data al dia ayer
          fecha_concatenacion := pd_fecdia;
          begin   
               select /* +all_rows*/count(distinct AOOPER ) into cantidad_operaciones
                from fsd010 f, aqpb617a a17
               where f.pgcod = a17.AQPB617ACOD
                 and f.aomda = a17.AQPB617AMDA
                 and f.aopap = 0
                 and f.aocta = a17.AQPB617ACTA
                 --and f.aosuc = a17.AQPB617ASUCU
                 and f.aooper = a17.AQPB617AOPER 
                 and (a17.aqpb617aase = RPAD(pv_codana, 10, ' ') or a17.aqpb617aase = pv_codana )
                 and a17.aqpb617afpro = fecha_concatenacion
                 and (f.aostat <> 99 or (f.aostat = 99 and f.aofe99 > fecha_concatenacion) );
           exception when others then
                 cantidad_operaciones := 0;  
           end; 
             total_cantidad_operaciones:= total_cantidad_operaciones + cantidad_operaciones;
      
      end if;
      
      ln_CantOpe:= total_cantidad_operaciones;
      
    return ln_CantOpe;
  end fn_get_cantope;

  ------------------------------------------------------------------------------  
  function fn_get_mntdesem(pv_codana in varchar2,
                           pd_fecini in date,
                           pd_fecfin in date,
                           pd_fecdia in date) return number is
 --     2024.06.05 dcastro se modifico condición para validacion fecha                       
                            
    ln_mntdesem number;
    my_errm     VARCHAR2(32000);
    cantidad_meses      number(10);
    fecha_concatenacion date;
    fecha_inimes date;
    lc_fechaini char(8);
    suma_operaciones number;
    total_suma_operaciones number;
    --ld_fecini   date;
    --ld_fecfin   date;
    --ln_meses    number;
    --ln_MesHis   number;
    --ld_FecPer date;
    --ln_MesPer number(10);
  begin
  
    total_suma_operaciones := 0;
      
    cantidad_meses := months_between(pd_fecfin, pd_fecini);
  
    For f in 0 .. cantidad_meses loop
    
      fecha_concatenacion := ADD_MONTHS(pd_fecini, f);     
      lc_fechaini := to_char(fecha_concatenacion,'MMYYYY');   
      fecha_inimes := to_date('01'||lc_fechaini, 'DDMMYYYY');   
      --dbms_output.put_line(fecha_concatenacion);
      
      begin
      /*  select nvl(sum(AQPB617AIMP1),0) into suma_operaciones
          from aqpb617a a17
         where (a17.aqpb617aase = RPAD(pv_codana, 10, ' ') or a17.aqpb617aase = pv_codana )
           and a17.aqpb617afpro = fecha_concatenacion;*/
           select /* +all_rows*/nvl(sum(AQPB617AIMP1),0) into suma_operaciones
            from fsd010 f, aqpb617a a17
           where f.pgcod = a17.AQPB617ACOD
             and f.aomda = a17.AQPB617AMDA
             and f.aopap = 0
             and f.aocta = a17.AQPB617ACTA
             --and f.aosuc = a17.AQPB617ASUCU
             and f.aooper = a17.AQPB617AOPER 
             and f.aomod in (select f.modulo from fst111 f where f.dscod =50 )
             and f.aofval between  fecha_inimes and  fecha_concatenacion 
             and (a17.aqpb617aase = RPAD(pv_codana, 10, ' ') or a17.aqpb617aase = pv_codana )
             and a17.aqpb617afpro = fecha_concatenacion
             and ( (f.aostat <>99 ) or (f.aostat = 99 and f.aofe99 > fecha_concatenacion) );
       exception when others then
          suma_operaciones := 0;   
       end;     
       total_suma_operaciones:= total_suma_operaciones + suma_operaciones;
           --dbms_output.put_line(cantidad_operaciones);
           --dbms_output.put_line(total_cantidad_operaciones);
    end loop;
    
    if pd_fecdia > pd_fecfin 
       or  ( pd_fecdia < pd_fecfin  and pd_fecdia <> last_day(pd_fecdia) ) --2024.06.05 se agregó ocndicion
  --     or (pd_fecdia < pd_fecfin /*or pd_fecfin = last_day(pd_fecdia)*/) --- 2023.12.06 se agrego condicion  
      then
      fecha_inimes := add_months(last_day(pd_fecdia),-1)+1;
      fecha_concatenacion := pd_fecdia;
      begin
           select nvl(sum(AQPB617AIMP1),0) into suma_operaciones
            from fsd010 f, aqpb617a a17
           where f.pgcod = a17.AQPB617ACOD
             and f.aomda = a17.AQPB617AMDA
             and f.aopap = 0
             and f.aocta = a17.AQPB617ACTA
             --and f.aosuc = a17.AQPB617ASUCU
             and f.aooper = a17.AQPB617AOPER 
             and f.aomod in (select f.modulo from fst111 f where f.dscod =50 )
             and f.aofval between  fecha_inimes and  fecha_concatenacion 
             and (a17.aqpb617aase = RPAD(pv_codana, 10, ' ') or a17.aqpb617aase = pv_codana )
             and a17.aqpb617afpro = fecha_concatenacion
             and ( (f.aostat <>99 ) or (f.aostat = 99 and f.aofe99 > fecha_concatenacion) );
       exception when others then
          suma_operaciones := 0;   
       end;  
       total_suma_operaciones:= total_suma_operaciones + suma_operaciones;
    end if;
    
    
    ln_mntdesem:= total_suma_operaciones;
    return ln_mntdesem;
  end fn_get_mntdesem;

  ------------------------------------------------------------------------------  
  function fn_get_sldRecibido(pv_codana in varchar2,
                              pd_fecini in date,
                              pd_fecfin in date) return number is
    ln_sldrec number;
    my_errm   VARCHAR2(32000);
  begin
    begin
      select sum(a.jaqz455sdmn) * -1
        into ln_sldrec
        from JAQZ455 a
       where JAQZ455FECH between pd_fecini and pd_fecfin
         and a.JAQZ455ASED = pv_codana;
    exception
      when others then
        ln_sldrec := null;
        my_errm   := SQLERRM;
      
    end;
  
    return ln_sldrec;
  end fn_get_sldRecibido;

  ------------------------------------------------------------------------------  
  procedure sp_actualizar_metas(pn_catego in NUMBER,--(10)
                                pv_nomcat in VARCHAR2,--(50)
                                pv_tipage in VARCHAR2,--(20)
                                pn_monope in NUMBER,--(18)
                                pn_mondes in NUMBER,--(18,2)
                                pv_user   in VARCHAR2,--(15)
                                pd_fecpro in DATE,
                                pn_flag   out Varchar2) is  
    my_errm VARCHAR2(32000);
    
    ln_corr NUMBER(10);
    lc_hora varchar2(10);
    lc_tipage CHAR(20);
    lv_nomcat varchar2(50);
    ln_contador number(10);
    
    lv_temp varchar2(2000);
    
    ln_val1 number;
    ln_val2 number;
    ln_val3 number;
    ln_val4 number;
    ln_val5 number;
    ln_val6 number;
    ln_val7 number;
    ln_val8 number;
    ln_val9 number;
    ln_val10 number;
    ln_val11 number;
    ln_val12 number;
  begin
    ln_val1 := INSTR(pv_nomcat,'@');
    ln_val2 := INSTR(pv_nomcat,'#');
    ln_val3 := INSTR(pv_nomcat,'*');
    ln_val4 := INSTR(pv_nomcat,'.');
    ln_val5 := INSTR(pv_nomcat,',');
    
    ln_val6 := INSTR(pv_tipage,'@');
    ln_val7 := INSTR(pv_tipage,'#');
    ln_val8 := INSTR(pv_tipage,'*');
    ln_val9 := INSTR(pv_tipage,'.');
    ln_val10 := INSTR(pv_tipage,',');
    
    /*lv_temp := RTRIM(pv_nomcat);
    lv_temp := LTRIM(lv_temp);*/
    lv_temp := pv_nomcat;
    lv_temp := TRIM(lv_temp);    
    ln_val11 := LENGTH(lv_temp);
    lv_temp := RTRIM(pv_tipage);
    lv_temp := LTRIM(lv_temp);
    ln_val12 := LENGTH(lv_temp);
      
    if    ln_val1 = 0 and ln_val2 = 0 and ln_val3 = 0 and ln_val4 = 0 and ln_val5 = 0
      and ln_val6 = 0 and ln_val7 = 0 and ln_val8 = 0 and ln_val9 = 0 and ln_val10 = 0
      /*and (ln_val11 >= 10 and ln_val11 <= 50)
      and (ln_val12 >= 10 and ln_val12 <= 20)
      /*and TRIM(pv_nomcat) <> ''
      and TRIM(pv_tipage) <> ''*/
      
      and pn_catego > 0
      and pn_monope >= 0
      and pn_mondes >= 0
      then
      
      lc_hora := to_char(sysdate, 'HH24:MI:SS');
      pn_flag := 'S';
      lc_tipage := upper(trim(pv_tipage));
      lv_nomcat := upper(trim(pv_nomcat));
      
      --correlativo
      begin
        select MAX(A.AQPB617COR) into ln_corr from AQPB617 A;
      exception
        when others then
          my_errm    := SQLERRM;
      end;
      ln_corr := nvl(ln_corr, 0);
      
      begin
        update aqpb617 a set a.aqpb617est = 'N'
        where (a.aqpb617cat = pn_catego or a.aqpb617ncat = lv_nomcat)
        and a.aqpb617tage = lc_tipage;
      exception
        when others then
          my_errm    := SQLERRM;
      end;
      
      begin
        ln_corr := ln_corr + 1;
        insert into aqpb617 (AQPB617COR,
                             AQPB617CAT, AQPB617NCAT, AQPB617TAGE,
                             AQPB617MOPE, AQPB617MMON,
                             AQPB617UCAR, AQPB617EST, AQPB617FCAR, AQPB617HCAR)
        values (ln_corr,
                pn_catego, lv_nomcat, lc_tipage,
                pn_monope, pn_mondes,
                pv_user, 'S', pd_fecpro, lc_hora);

        select count(*) 
        into ln_contador
        from aqpb617 a
        where (a.aqpb617cat = pn_catego or a.aqpb617ncat = lv_nomcat)
        and a.aqpb617tage = lc_tipage
        and a.AQPB617EST = 'S';
        
        IF ln_contador > 1 THEN
          ROLLBACK;
        ELSE
          COMMIT;
        END IF;
      exception
        when others then
          rollback;
          pn_flag := 'N';
          my_errm    := SQLERRM;
      end;
    else 
      pn_flag := 'N';      
    end if;
  end sp_actualizar_metas;

  ------------------------------------------------------------------------------  
  procedure sp_nivel_analista(pv_codana   in varchar2,
                              pv_nivelAna out varchar2) is
    my_errm VARCHAR2(32000);
  begin
  
  /* 
  begin
      select j.jaqz839rating
        into pv_nivelAna
        from jaqz839 j
       where j.jaqz839analst = trim(pv_codana)
         and j.jaqz839fch in (select max(k.jaqz839fch)
                                 from jaqz839 k
                             where k.jaqz839analst = trim(pv_codana));
   end;
   */                          
      -- Rating Analista  
    pv_nivelAna := ' ';
    BEGIN
      SELECT substr(a.AQPB883RAT, 3, 11) -- 2023.08.21 dcastro
        into pv_nivelAna
        FROM AQPB883 a
       WHERE AQPB883ANA = UPPER(TRIM(pv_codana))
         AND AQPB883FEC =
             (SELECT MAX(AQPB883FEC)
                FROM AQPB883
               WHERE AQPB883ANA = UPPER(TRIM(pv_codana)))
         and rownum < 2;
    EXCEPTION
      WHEN OTHERS THEN
            pv_nivelAna := '';
            my_errm     := SQLERRM;
    END;
                       
  
  end sp_nivel_analista;

  ------------------------------------------------------------------------------  
  procedure sp_califi_analista(pv_codsbs  in varchar2,
                               pd_fecha   in date,
                               pn_normal  out number,
                               pn_cpp     out number,
                               pn_defici  out number,
                               pn_dudoso  out number,
                               pn_perdida out number) is
    my_errm   VARCHAR2(32000);
    ld_inimes date;
    ld_finmes date;
  
  begin
    --fechas
    begin
      ld_inimes := TRUNC(pd_fecha, 'MM');
      ld_finmes := last_day(pd_fecha);
    exception
      when others then
        my_errm := SQLERRM;
        return;
    end;
  
    begin
      select c.n_calif0, c.n_calif1, c.n_calif2, c.n_calif3, c.n_calif4
        into pn_normal, pn_cpp, pn_defici, pn_dudoso, pn_perdida
        from cldrcci c
       where c.c_codsbs = pv_codsbs
         and c.d_fecpre between ld_inimes and ld_finmes;
    exception
      when no_data_found then
        pn_normal  := 100;
        pn_cpp     := 0;
        pn_defici  := 0;
        pn_dudoso  := 0;
        pn_perdida := 0;
      when too_many_rows then
        pn_normal  := 100;
        pn_cpp     := 0;
        pn_defici  := 0;
        pn_dudoso  := 0;
        pn_perdida := 0;
      when others then
        pn_normal  := null;
        pn_cpp     := null;
        pn_defici  := null;
        pn_dudoso  := null;
        pn_perdida := null;
        my_errm    := SQLERRM;
      
    end;
  end sp_califi_analista;

  ------------------------------------------------------------------------------ 
  procedure sp_codigo_sbs(pn_pais in number,
                          pn_tdoc in number,
                          pv_ndoc in varchar2,
                          pv_csbs out varchar2) is
    my_errm   VARCHAR2(32000);
    lv_eqtdoc VARCHAR2(10);
    ld_FchRCC date;
  begin
    begin
      select to_date(Tpnro, 'DD/MM/YYYY')
        into ld_FchRCC
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    exception
      when others then
        my_errm := SQLERRM;
      
    end;
  
    if pn_tdoc <> 9 then
      /*EQUIVALENCIA TIPO DOC*/
      lv_eqtdoc := PQ_CR_RCC_Resolutor.fn_equivalenviaDoc(pn_tdoc);
      begin
        select c.c_codsbs
          into pv_csbs
          from cldrcci c
         where c.c_docide = trim(pv_ndoc)
           and c.c_tdocid = lv_eqtdoc
           and c.d_fecpre = ld_FchRCC;
      exception
        when others then
          my_errm := SQLERRM;
        
      end;
    
    elsif pn_tdoc = 9 then
      begin
        select c.c_codsbs
          into pv_csbs
          from cldrcci c
         where c.c_doctri = trim(pv_ndoc)
           and c.d_fecpre = ld_FchRCC;
      exception
        when others then
          null;
      end;
    end if;
  
  end sp_codigo_sbs;

  ------------------------------------------------------------------------------ 
  procedure sp_generar_recate(pd_fpro     in date,
                              pn_Analista in varchar2,
                              pn_flag     out Varchar2) is
  -- 2023.12.06 DCASTRO SE MODIFICO CONDICION DE PERMANENCIA
  -- 2024.01.12 DCASTRO se modificon condicion cuando Fecha_Asc es mayor a fecha de proceso. 
  ---2024.01.18 dcastro se comento exit 
  ---2024.04.24 dcastro se modifico procedimiento para obtener fecha de ascenso.
  ---2024.05.29 dcastro se modifico condicion >= por > para dias de suspencion.
  
    my_errm VARCHAR2(32000);
  
    lc_Temp   CHAR(20);
    lc_CodAna Char(10);
    lc_NomAna Varchar2(50);
    lc_NumDoc Char(12);
  
    ln_CodCat Number(3);
    lv_NomCat Varchar2(50);
    ln_CodAge Number(3);
    lc_TipAge char(20);
    lc_NomAge varchar2(50);
  
    lv_catP    Number(3);
    lv_nomcatP Varchar2(50);
  
    ln_CantOpe  Number;
    ln_mntdesem Number(18, 2);
    ln_sldrec   Number(18, 2);
  
    ld_inimes date;
    ld_finmes date;
  
    ln_pais Number(3);
    ln_tdoc Number(3);
    lc_ndoc char(12);
  
    lv_codsbs Varchar2(15);
  
    ln_normal  Number;
    ln_cpp     Number;
    ln_defici  Number;
    ln_dudoso  Number;
    ln_perdida Number;
  
    ln_mope  Number(10); --META NÚMERO DE OPERACIONES
    ln_mmon  Number(18, 2); --META MONTO DESEMBOLSADO
    ln_Corre Number;
  
    lc_hora   Varchar2(15);
    ln_FecAsc Date;
  
    ln_CarHer Number(10, 2); --Porcentaje cartera Heredada.
  
    ld_FecPer         Date;
    ln_MesReca        Number(10);
    ln_MesPermanencia Number(10);
  
    ln_MesTot    Number(10);
    ln_ResOpe    Number(18);
    ln_ResMnt    Number(18, 2);
    lv_NivAna    Varchar2(30);
    lv_flagNivel Varchar2(1);
    lv_flagCalif Varchar2(1);
  
    ld_fecDiaSus  date;
    ln_TotDiaSus  Number(18);
    ln_DiaSus     Number(18);
    ln_MesDiaSus  Number(18);
    lv_flagDiaSus Char(1);
    lv_Res1       Char(1);
    lv_Res2       Char(1);
    lv_Res3       Char(1);
    lv_Res4       Char(1);
      
    sql_stmt VARCHAR2(500);
    TYPE EmpCurTyp IS REF CURSOR;
    Cur_Ana   EmpCurTyp;
    lv_estqry char(1);
  
    ld_fecRant     date;
    ln_CodCatRant  number(10);
    ln_CodCatPRant number(10);
    ld_FecCatPRant date;
  
    ld_fInicio  date;
    ld_fFin     date;
    ln_TotalMnt number;
  
    ld_Fec830 date;
    ln_ConTem number;
    
    ln_pgusu    NUMBER(9);
    ln_CodSuc   NUMBER(3);
    lc_NomSuc   CHAR(30);
    ln_CodZon   NUMBER(3);
    lc_NomZon   CHAR(40);    
    ln_CodReg   NUMBER(9);
    lc_NomReg   CHAR(30);

    
    ld_FecPer_cambio_cargo date;
    validacion_cambio_cargo varchar(10);
    ld_FecPer_fin date;
    ln_CodCat_inicio number;
    
    lc_com1  char(1);
    lc_com2  char(1);
    lc_com3  char(1);
    lc_com4  char(20);
    lc_com5  char(20);
    lc_codt  char(11);
    
    ld_fecdia date;
    
    lc_habilcom char(1);
    
    ld_fecant_fm date; --2023.09.08 se agrego
    ln_nummes number;
    ld_fecha_inicio date; --2024.04.17 

    
    /*=== INI - MAYCOL - 23/10/2023 - IGS - NEW ===*/
    CANTIDAD_CLIENTES_ACTIVOS NUMBER(18);
    /*=== FIN - MAYCOL - 23/10/2023 - IGS - NEW ===*/
    
    cursor cambio_cargo(usuario jaqy830.jaqy830codana%type, fecha_inicial jaqy830.jaqy830fini%type,
    fecha_final jaqy830.jaqy830fini%type)  is 
    /*select * from  jaqy830 where 
           (jaqy830codana = usuario or jaqy830codana = rpad(usuario,20,' ') ) 
        and jaqy830fini between fecha_inicial and fecha_final 
        --order by jaqy830fini asc;
        order by jaqy830fini desc; -- 2023.09.07 se cambio*/
    --2024.04.24 se cambio cursor    
    select JAQY830CODCAT, MIN(jaqy830fini) jaqy830fini, MAX(jaqy830fini) FECHAFIN from  JAQY830 where 
            (jaqy830codana = usuario or jaqy830codana = rpad(usuario,20,' ') )
        and jaqy830fini between fecha_inicial and fecha_final
        GROUP BY JAQY830CODCAT
        ORDER BY jaqy830fini desc;     




  begin
    lc_hora := to_char(sysdate, 'HH24:MI:SS');
    pn_flag := 'S';
    validacion_cambio_cargo := 'N';
  
    --fechas
    begin
      ld_finmes := last_day(pd_fpro);
      --ld_finmes := ADD_MONTHS(ld_finmes,-1); 2024.04.24 dcastro se comento
      ld_inimes := TRUNC(ld_finmes, 'MM');
      ld_fecdia := pd_fpro;
      
    exception
      when others then
        my_errm := SQLERRM;
        return;
    end;
  
    begin
            pq_cr_recategorizacion.sp_fechasvalidas(pd_fpro => pd_fpro,
                                                     pd_fechaini => ld_fInicio,
                                                     pd_fechafin => ld_fFin);
    end;

  
    if pn_flag = 'S' then
      --Periocidad Categorizacion
    /*  begin
        select tp1nro1
          into ln_MesReca
          from fst198
         where tp1cod = 1
           and tp1cod1 = 10847
           and tp1corr1 = 21
           and tp1corr2 = 3;
      exception
        when others then
          ln_MesReca := 12;
          my_errm    := SQLERRM;
          return;
      end;
      ld_FecPer := ADD_MONTHS(ld_inimes, (ln_MesReca * -1));
      ld_FecPer_fin := ADD_MONTHS(ld_finmes, (ln_MesReca * -1));
    */
    ld_FecPer := lpad('01'||to_char(ld_fInicio,'MMYYYY'), 8, '0');--ld_fInicio;
    ld_FecPer_fin := ld_fInicio;
    
    
      --Porcentaje cartera Heredada.
      begin
        select tp1nro1 / 100
          into ln_CarHer
          from fst198
         where tp1cod = 1
           and tp1cod1 = 10847
           and tp1corr1 = 21
           and tp1corr2 = 2;
      exception
        when others then
          ln_CarHer := 0.75;
          my_errm   := SQLERRM;
      end;
    
      --Meses de permanecia.
      begin
        select tp1nro1
          into ln_MesPermanencia
          from fst198
         where tp1cod = 1
           and tp1cod1 = 10847
           and tp1corr1 = 21
           and tp1corr2 = 4;
      exception
        when others then
          ln_MesPermanencia := 6;
          my_errm           := SQLERRM;
      end;
    
      --Meses evaluar dias suspension.
      begin
        select tp1nro1
          into ln_MesDiaSus
          from fst198
         where tp1cod = 1
           and tp1cod1 = 10847
           and tp1corr1 = 21
           and tp1corr2 = 5;
      exception
        when others then
          ln_MesDiaSus := 8;
          my_errm      := SQLERRM;
      end;
      ld_fecDiaSus := last_day(ADD_MONTHS(ld_inimes, (ln_MesDiaSus * -1)));
    
      begin
        select f.tp1nro1
           into ln_nummes
           from fst198 f
          where TP1COD = 1 and TP1COD1 =10847 and TP1CORR1 = 26 and TP1CORR2 = 1;
        exception when others then
            ln_nummes := 0;      
      end;
    
      lv_estqry := 'S';
      if trim(pn_Analista) <> '' or pn_Analista is null then
        sql_stmt := 'select distinct jaqy830fini, jaqy830codana, JAQY830NDOC, JAQY830codcat, JAQY830catana, JAQY830codage, JAQY830antage, jaqy830dsus, JAQY830AGEN
                    from jaqy830 
                    WHERE JAQY830EST = ''' || lv_estqry || '''';
                    --WHERE JAQY830EST = ''' || lv_estqry ||''' and jaqy830codana = ''VCACERES  ''';
                    --WHERE JAQY830EST = ''' || lv_estqry ||''' and jaqy830codana = ''ASALDANAS ''';

      else
        sql_stmt := 'select distinct jaqy830fini, jaqy830codana, JAQY830NDOC, JAQY830codcat, JAQY830catana, JAQY830codage, JAQY830antage, jaqy830dsus, JAQY830AGEN
                    from jaqy830 
                    WHERE JAQY830EST =  ''' || lv_estqry ||
                    ''' and jaqy830codana = RPAD(''' || pn_Analista ||''',20,'' '')';
      end if;
      
      /*=== INI - MAYCOL - 20/10/2023 - IGS - NEW ===*/
      if  trim(pn_Analista) <> '' or pn_Analista is null then     
        BEGIN
           DELETE FROM AQPB617B WHERE AQPB617BFPRO = pd_fpro; --2024 se agrego condicion de eliminar por analista
           COMMIT;
        EXCEPTION
           WHEN OTHERS THEN
              NULL;
        END;
      else
        BEGIN
           DELETE FROM AQPB617B WHERE AQPB617BFPRO = pd_fpro and aqpb617bana  = RPAD( pn_Analista ,10,' '); --20224 se agrego condicion de eliminar por analista
           COMMIT;
        EXCEPTION
           WHEN OTHERS THEN
              NULL;
        END;

      end if;  
      /*=== FIN - MAYCOL - 20/10/2023 - IGS - NEW ===*/
      
      OPEN Cur_Ana FOR sql_stmt;
      LOOP
        FETCH Cur_Ana
          INTO ld_Fec830,
               lc_Temp,
               lc_NumDoc, --Documento
               ln_CodCat, --Codigo categoria
               lv_NomCat, --cargo actual
               ln_CodAge, --codigo agencia
               lc_TipAge, --tipo de agencia
               ln_DiaSus, --dia de suspension
               lc_NomAge; --nombre agencia
        EXIT WHEN Cur_Ana%NOTFOUND;-- or pn_flag = 'N';
        pn_flag := 'S';
        lc_CodAna := RPAD(lc_Temp, 10, ' '); --Codigo Analista
      
      
        ln_DiaSus := nvl(ln_DiaSus,0);
        
        --inactivar registros
        begin
          update aqpb617b
             set aqpb617best = 'N'
           where aqpb617bana = lc_CodAna
             and aqpb617bfpro = pd_fpro;--ld_finmes;
          commit;
        exception
          when others then
            my_errm := SQLERRM;
        end;
      
        --nombre analista
        begin
          select ubnom into lc_NomAna from fst746 where ubuser = lc_CodAna;
        exception
          when others then
            my_errm   := SQLERRM;
            lc_NomAna := '';
        end;
      
        --documento del analista
        begin
          select jaqn002pai, jaqn002tdo, jaqn002ndo
            into ln_pais, ln_tdoc, lc_ndoc
            from jaqn002
           where jaqn002usr = lc_CodAna;
        exception
          when others then
            ln_pais := 0;
            ln_tdoc := 0;
            lc_ndoc := '';
            my_errm := SQLERRM;
        end;
      
        --nombre de la agencia
        /*begin
          select scnom
            into lc_NomAge
            from FST001
           where pgcod = 1
             and scnom = lc_NomAge;
        exception
          when others then
            my_errm   := SQLERRM;
            lc_NomAge := '';
        end;*/
        
        --codigo agencia
        begin
          select ubsuc  into ln_CodAge from fst046 where ubuser = lc_CodAna;
        exception
          when others then
            my_errm   := SQLERRM;
            ln_CodAge := null;
        end;
      
      
        --total de meses permanecia
        /*begin
          select COUNT(*)
            into ln_MesTot
            from AQPB617B
           where AQPB617Bana = lc_CodAna
             and AQPB617Bcata = ln_CodCat
             and AQPB617Btage = lc_TipAge
             and AQPB617BFPRO < ld_finmes --verificar
             AND AQPB617Best = 'S';
        exception
          when others then
            my_errm := SQLERRM;
        end;
        if ln_MesTot = 0 then
          select COUNT(*)
            into ln_ConTem
            from AQPB617B
           where AQPB617Bana = lc_CodAna
             AND AQPB617Best = 'S';
          if ln_ConTem > 0 then
            ln_MesTot := 1;
          end if;
        else
          ln_MesTot := ln_MesTot + 1;
        end if;
        se comento calculo
       */
        --nivel analista
        sp_nivel_analista(lc_CodAna, lv_NivAna);
        lv_NivAna    := lower(trim(lv_NivAna));
        lv_flagNivel := case
                          when lv_NivAna = 'coachee' or lv_NivAna = 'seguimiento' then
                           'E' --Excluido
                          when lv_NivAna = 'coach' or lv_NivAna = 'top' then  'A' --Ascenso
                          else
                           'E' -- Excluido
                        end;
        lv_NivAna    := upper(lv_NivAna);
      
        --datos recategorización inmediata anterior anterior
        ld_fecant_fm := add_months(last_day( pd_fpro ), -1);
        begin
          select a.aqpb617bfpro,
                 a.AQPB617BCATA,
                 a.AQPB617BCATP,
                 a.AQPB617BFASC
            into ld_fecRant, ln_CodCatRant, ln_CodCatPRant, ld_FecCatPRant
            from aqpb617b a
           where a.aqpb617best = 'S'
             and a.aqpb617bana = lc_CodAna
             --and a.aqpb617bfpro < pd_fpro---ld_finmes se comento 2023.09.08
             and a.aqpb617bfpro <= ld_fecant_fm --pd_fpro---ld_finmes
           order by a.aqpb617bfpro desc 
           OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;
        exception
          when others then
            my_errm := SQLERRM;
            null;
        end;
      
        if ln_CodCat > ln_CodCatRant then
          ln_FecAsc := ld_Fec830;
        else
          ln_FecAsc := ld_fecRant;
        end if;

        --categoria de la fecha
        begin
        select jaqy830codcat into ln_CodCat_inicio from  jaqy830 where 
               (jaqy830codana = lc_CodAna or jaqy830codana = rpad(lc_CodAna,20,' ') ) 
               and jaqy830fini = ld_FecPer_fin;
        exception when others then
           ln_CodCat_inicio := ln_CodCat; -- 2023.09.07 se comento null;
        end;

        -----2024.04.27 minima fecha 
        begin
        select min(jaqy830fini) into ld_fecha_inicio from  JAQY830 where 
               (jaqy830codana = lc_CodAna or jaqy830codana = rpad(lc_CodAna,20,' ') )
               and jaqy830fini >= ld_FecPer_fin ;
        exception when others then
           ld_fecha_inicio := ld_FecPer_fin; 
        end;

        --verificando
        --if ln_MesTot >= ln_MesPermanencia then
        ld_FecPer_cambio_cargo := null;
        ln_FecAsc := null;
/*        for x in cambio_cargo(lc_CodAna,ld_FecPer,ld_finmes) loop
           if ln_CodCat_inicio != x.jaqy830codcat then
                 validacion_cambio_cargo := 'S';
                 --ld_FecPer_cambio_cargo := ADD_MONTHS(x.jaqy830fini,1);
                 --ld_FecPer_cambio_cargo := x.jaqy830fini; -- se considera desde la fecha de ascenso
                 --ln_FecAsc := x.jaqy830fini; --- se agrego

                 ld_FecPer_cambio_cargo := add_months(x.jaqy830fini,ln_nummes); -- se considera desde la fecha de ascenso
                 ln_FecAsc := add_months(x.jaqy830fini,ln_nummes); --- se agrego
                 if ln_FecAsc > ld_finmes then
                   ld_FecPer_cambio_cargo := add_months(ld_FecPer_cambio_cargo,-1); --- 2024.01.12 dcastro se agrego cuando fecha es mayor a la fecha de proceso 
                   ln_FecAsc := add_months(ln_FecAsc,-1); --- 2024.01.12 dcastro se agrego cuando fecha es mayor a la fecha de proceso 
                 end if;
                -------------------------exit; ---2024.01.18 dcastro se comento exit
           end if;
        end loop;
    
      if ld_FecPer_cambio_cargo is null then
         ld_FecPer_cambio_cargo := ld_FecPer_fin;
         ln_FecAsc := ld_FecPer_fin;
      end if;
        
        if validacion_cambio_cargo = 'N' then 
          ld_fInicio := ld_FecPer_fin;
--          ld_fFin    := ld_finmes; se comento 2023.12.01 dcastro
        else
          ld_fInicio := ld_FecPer_cambio_cargo;
--          ld_fFin    := ld_finmes; se comento 2023.12.01 dcastro
        end if;
   
        --meses permanencia
        ln_MesTot := round((ld_fFin - ld_fInicio)/30,0);
se comento 2024.04.24*/

       for x in cambio_cargo(lc_CodAna,ld_FecPer,ld_finmes) loop
           if ln_CodCat_inicio != x.jaqy830codcat then
                 validacion_cambio_cargo := 'S';
                 ld_FecPer_cambio_cargo := add_months(x.jaqy830fini,ln_nummes); -- se considera desde la fecha de ascenso
                 ln_FecAsc := add_months(x.jaqy830fini,ln_nummes); --- se agrego
                 exit; --2024.04.17 
           end if;
        end loop;


      if ld_FecPer_cambio_cargo is null then
         if ld_fecha_inicio > ld_FecPer_fin then ---2024.04.17
           ld_FecPer_cambio_cargo := ld_fecha_inicio;
           ln_FecAsc := ld_fecha_inicio;
         else
           ld_FecPer_cambio_cargo := ld_FecPer_fin;
           ln_FecAsc := ld_FecPer_fin;
         end if;
      end if;
        
        if validacion_cambio_cargo = 'N' then 
             if ld_fecha_inicio > ld_FecPer_fin then ---2024.04.17
               ld_fInicio := ld_fecha_inicio;
             else
               ld_fInicio := ld_FecPer_fin; --se agrego 2024.04.17 linea 924
             end if;

        else
          ld_fInicio := ld_FecPer_cambio_cargo;
        end if;

        --meses permanencia
        ---ln_MesTot := round((ld_fFin - ld_fInicio)/30,0);
        ln_MesTot := round((ld_fFin -  add_months(last_day(ld_fInicio)+1,-1 )  )/30,0);
        
        --cantidad de operacion y monto desembolsado
        ln_CantOpe  := fn_get_cantope(lc_CodAna, ld_fInicio, ld_fFin, ld_fecdia);
        ln_mntdesem := fn_get_mntdesem(lc_CodAna, ld_fInicio, ld_fFin, ld_fecdia);
        
        /*=== INI - MAYCOL - 23/10/2023 - IGS - NEW ===*/
        CANTIDAD_CLIENTES_ACTIVOS := FN_CR_CANTIDAD_CLIENTES_ACTIVOS(lc_CodAna, ld_fInicio, ld_fFin, ld_fecdia);
        /*=== FIN - MAYCOL - 23/10/2023 - IGS - NEW ===*/
      
        --saldo recibido --se quito consideracion cartera heradada solicitada por RRHH
        /*ln_sldrec := fn_get_sldRecibido(lc_CodAna, ld_fInicio, ld_fFin);
        ln_sldrec := ln_sldrec * ln_CarHer;
      */
        ln_mntdesem := nvl(ln_mntdesem, 0);
        ln_sldrec   := nvl(ln_sldrec, 0);
       
        --metas cargo actual
        begin
          select aqpb617mope, aqpb617mmon
            into ln_mope, ln_mmon
            from aqpb617
           where aqpb617est = 'S'
             and aqpb617cat = ln_CodCat
             and aqpb617tage = lc_TipAge;
        exception
          when others then
            ln_mope := null;
            ln_mmon := null;
            my_errm := SQLERRM;
        end;
      
        --calificación analista
        sp_codigo_sbs(ln_pais, ln_tdoc, lc_ndoc, lv_codsbs);
      
        --calificación analista
        sp_califi_analista(lv_codsbs,
                           ld_finmes, --pd_fpro
                           ln_normal,
                           ln_cpp,
                           ln_defici,
                           ln_dudoso,
                           ln_perdida);
      
        lv_flagCalif := 'A'; ---TODOS CALIFICAN PARA RECATEGORIZACION
                     /*case
                          when ln_normal = 100.00 or ln_normal = 0.00 then
                           'A' --Ascenso
                          else
                           'E' --Excluido
                        end;*/
      
        --obtener correlativo
        begin
          select max(AQPB617BCORR)
            into ln_Corre
            from AQPB617B
           where aqpb617bana = lc_CodAna
             and aqpb617bfpro = ld_finmes;
          ln_Corre := nvl(ln_Corre, 0);
        exception
          when others then
            ln_Corre := 0;
            my_errm  := SQLERRM;
        end;
      
        --Total dias de suspensión FALTA
        begin

           ln_TotDiaSus := pq_cr_recategorizacion.fn_dias_suspension(pv_codana => lc_CodAna,
                                                                          pd_fecini => ld_fecDiaSus,
                                                                          pd_fecfin => ld_finmes);
        end;
    /*    begin
           select sum(AQPB617BDSUS)
             into ln_TotDiaSus
             from AQPB617B
            where aqpb617bana = lc_CodAna
              and aqpb617best = 'S'
              and aqpb617bfpro between ld_fecDiaSus and ld_finmes;
              
           select sum(j.jaqy830dsus)
             into ln_TotDiaSus
             from jaqy830 j
            where j.jaqy830codana = rpad(lc_CodAna, 20, ' ')
              and j.jaqy830fini between ld_fecDiaSus and ld_finmes;
        exception
           when others then
             ln_TotDiaSus := 0;
             my_errm      := SQLERRM;
        end;
  */      
        --cargo propuesta
        ln_TotalMnt := ln_mntdesem + ln_sldrec;
        
        -- Si cumplió con la meta tanto en monto como en número (ambos)
        lv_Res1 := case when ln_CantOpe >= ln_mope and ln_TotalMnt >= ln_mmon then 'A' 
                        else 'N' 
                   end;
        -- Si cumple con el resultado 1 y tiene nivel de riesgo coach es apto, caso contrario no apto
        lv_Res2 := case when lv_Res1 = 'A' and lv_NivAna in ( 'COACH', 'TOP') then 'A'
                        else 'N'
                   end;
      
        --  Más de 3 días de suspensión en los últimos 8 meses, no puede re categorizar.  
        -- S: si tiene dias de suspension, N: no tiene dias o son menor a 3 
        /*lv_flagDiaSus := case when ln_TotDiaSus >= 3 then 'S' validacion anterior manda la plantilla*/
        lv_flagDiaSus := case when ln_DiaSus > 3 then 'S'
                              else 'N'
                         end;
      

        --2023.07.04  validacion comisiones rrhh
        lc_habilcom := 'S';  
        begin
          select trim(f.tp1desc)
           into lc_habilcom
           from fst198 f
          where TP1COD = 1 and TP1COD1 =10847 and TP1CORR1 = 24 and TP1CORR2 = 1 and TP1CORR3 = 1;
        exception when others then
            lc_habilcom := 'N';      
        end;

       
        if lc_habilcom = 'S' then
            begin
              pq_cr_recategorizacion.sp_retorna_com_rrhh(pd_fpro => ld_finmes, ---ultima carga de archivo fin mes
                                                         pn_analista => rpad(lc_CodAna, 20, ' '),
                                                         pc_com1 => lc_com1,
                                                         pc_com2 => lc_com2,
                                                         pc_com3 => lc_com3,
                                                         pc_com4 => lc_com4,
                                                         pc_com5 => lc_com5,
                                                         pc_codt => lc_codt);
            end;

            if lc_com1 = 'S' and lc_com2 = 'S' and lc_com3 = 'S' and lc_com4 = 'S' and lc_com5 = 'S' then
               lv_Res4 := 'S';
            else 
               lv_Res4 := 'N';
            end if;        
        else
              lc_com1 := null;
              lc_com2 := null;
              lc_com3 := null;
              lc_com4 := null;
              lc_com5 := null;
              lv_Res4 := null;
              
        end if;    
        --           

        -- Si cumple resultado 1 y 2 más validación días de suspensión 
        lv_Res3 := /*se agrego condicion lv_res4
                case when lv_Res1 = 'A' and lv_Res2 = 'A' and lv_flagDiaSus = 'N' then 'A'
                        else 'N'
                   end;*/
                   case when lv_Res1 = 'A' and lv_Res2 = 'A' and lv_flagDiaSus = 'N' and nvl(lv_Res4,'S') = 'S'
                        then 'A'
                   else 'N'
                   end;
        


        if ln_CantOpe   >= ln_mope and 
           ln_TotalMnt  >= ln_mmon and
           ln_MesTot    >=  ln_MesPermanencia and  --se modifico condicion >= 2023.12.06
           lv_flagNivel  = 'A' and
           lv_flagDiaSus = 'N'
        --and lv_flagCalif = 'A'
         then
            if ln_CodCat IN (6, 9) then
               begin
                  select aqpb617cat, aqpb617ncat
                    into lv_catP, lv_nomcatP
                    from aqpb617
                   where aqpb617tage = lc_TipAge
                     and aqpb617cat = ln_CodCat
                     and rownum = 1
                   order by aqpb617cat;
                exception
                  when others then
                    lv_catP    := '';
                    lv_nomcatP := '';
                    my_errm    := SQLERRM;
                end;
                
                lv_Res3 := 'T'; -- llego a tope  16/08/2023 dcastro
            else         
                begin
                  select aqpb617cat, aqpb617ncat
                    into lv_catP, lv_nomcatP
                    from aqpb617
                   where aqpb617tage = lc_TipAge
                     and aqpb617cat > ln_CodCat
                     and rownum = 1
                   order by aqpb617cat;
                exception
                  when others then
                    lv_catP    := '';
                    lv_nomcatP := '';
                    my_errm    := SQLERRM;
                end;
            end if;  
        else
          lv_catP    := ln_CodCat;
          lv_nomcatP := lv_NomCat;
        end if;
      
        lv_nomcatP := upper(lv_nomcatP);

        if ln_MesTot   <  ln_MesPermanencia then --2023/12/01 dcastro se modifico condicion a < en lugar <=
              lv_Res3 := 'P'; -- no cumple permanencia  16/08/2023 dcastro
        end if;
        
        --FALTA CONSULTAR TABLAS Y LOS NOMBRES AGENCIA
        --PGCOD
        begin
          SELECT PgcodAc into ln_pgusu
          FROM Fst746
          Where Ubuser = lc_CodAna;
        exception
          when others then
            ln_pgusu := 1;
        end;    
        --CODIGO SUCURSAL
        begin
          select ubsuc into ln_CodSuc
          from fst046
          Where Pgcod = ln_pgusu 
          and Ubuser = lc_CodAna;  
        exception
          when others then
            null;
        end;        
        --NOMBRE SUCURSAL
        begin
          select scnom into lc_NomSuc
          from fst001
          where pgcod = ln_pgusu 
            and sucurs = ln_CodSuc;
        exception
          when others then
            null;
        end;    
        --CODIGO ZONA
        begin
          SELECT RegCod into ln_CodZon
          FROM fst811
          Where Pgcod = ln_pgusu
          AND OfiCod = ln_CodSuc
          AND RegCod < 100;
        exception
          when others then
            null;
        end;        
        --NOMBRE ZONA
        begin
          SELECT RegNom into lc_NomZon
          FROM Fst810
          Where Pgcod = ln_pgusu
          AND RegCod = ln_CodZon
          AND RegCod < 100;
        exception
          when others then
            null;
        end;    
        --REGION
        begin
          SELECT Tp1nro1, Tp1desc
            into ln_CodReg, lc_NomReg
          FROM fst198
          Where Tp1cod   = 1
          AND Tp1cod1  = 10872 
          AND Tp1corr1 = 11
          AND Tp1nro2 = ln_CodZon;--&ZonaAux
        exception
          when others then
            null;
        end;
        
        /*
        Query para region, zona, sucursal, 
        SELECT rc.Tp1nro1, rc.Tp1desc, zc.RegCod, zn.regnom, sn.sucurs, sn.scnom
        from fst001 sn --sucursal
        join fst811 zc on zc.Pgcod = sn.pgcod and zc.OfiCod = sn.sucurs --cod zona
        join fst810 zn on zc.Pgcod = zn.Pgcod and zc.RegCod = zn.regcod and zc.RegCod = zn.RegCod --nom zona
        join fst198 rc on rc.Tp1cod = 1 AND rc.Tp1cod1 = 10872 AND rc.Tp1corr1 = 11 AND rc.Tp1nro2 = zc.RegCod --region
        --Where zc.Pgcod = 1 AND zc.OfiCod = 113 AND zc.RegCod < 100;
        Where sn.pgcod = 1 AND sn.sucurs = 2 AND zc.RegCod < 100;
        */

        --insert registro
        begin
          ln_Corre := ln_Corre + 1;
        
          ln_ResOpe := null;
          ln_ResMnt := null;
        
          insert into AQPB617B
            (AQPB617BCORR,
             AQPB617BFPRO, --0
             AQPB617PAIS,
             AQPB617TDOC,
             AQPB617NDOC,
             AQPB617BANA, --1
             AQPB617CSBS,
             AQPB617BNOMANA,
             AQPB617BNUOPE, --2
             AQPB617BMNTDE, --3
             AQPB617BMNTRE, --4
             AQPB617BMOPE, --5
             AQPB617BMDES, --6
             AQPB617BNANA, --7
             
             AQPB617BCREG,
             AQPB617BNREG,
             AQPB617BCZON,
             AQPB617BNZON,
             
             AQPB617BCAGE, --8
             AQPB617BNAGE,
             AQPB617BTAGE, --9
             AQPB617BCATA, --10
             AQPB617BCARA, --11           
             AQPB617BCNOR,
             AQPB617BCCPP,
             AQPB617BCDEF,
             AQPB617BCDUD,
             AQPB617BCPER,
             AQPB617BCATP, --12
             AQPB617BCARP, --13
             AQPB617BFASC, --14
             
             AQPB617BMPER,
             AQPB617BROPE,
             AQPB617BRMNT,
             
             AQPB617BDSUS,
             AQPB617BRES1,
             AQPB617BRES2,
             AQPB617BRES3,
             
             AQPB617BEST,
             AQPB617BFEC,
             AQPB617BHOR,
             AQPB617BRES4,
             AQPB617BCOM1,
             AQPB617BCOM2,
             AQPB617BCOM3,
             AQPB617BCOM4,
             AQPB617BCOM5,
             AQPB617BCODT,                                                   
             AQPB617BCANCA)
          values
            (ln_Corre,
             pd_fpro,-----SE COMENTO SE COLOCO FECHA DE PROCESO ld_finmes, --0
             ln_pais,
             ln_tdoc,
             lc_ndoc,
             lc_CodAna, --1
             TRIM(lv_codsbs),
             lc_NomAna,
             ln_CantOpe, --2
             ln_mntdesem, --3
             ln_sldrec, --4
             ln_mope, --5
             ln_mmon, --6
             lv_NivAna, --7 
             
             ln_CodReg,
             lc_NomReg,
             ln_CodZon,
             lc_NomZon,
             
             --ln_CodSuc, --8
             --lc_NomSuc, 
             ln_CodAge, --8
             lc_NomAge,
             
             lc_TipAge, --9
             ln_CodCat, --10
             lv_NomCat, --11
             ln_normal,
             ln_cpp,
             ln_defici,
             ln_dudoso,
             ln_perdida,
             lv_catP, --12 Codigo Categoria Propuesta
             lv_nomcatP, --13 Cargo Propuesto
             ln_FecAsc, --14 FALTA - fecha ascenso
             
             ln_MesTot,
             ln_ResOpe,
             ln_ResMnt,
             
             ln_DiaSus,
             lv_Res1,
             lv_Res2,
             lv_Res3,
             
             'S',
             pd_fpro,
             lc_hora,
             lv_Res4,
             lc_com1,
             lc_com2,
             lc_com3,
             lc_com4,             
             lc_com5,
             lc_codt,             
             CANTIDAD_CLIENTES_ACTIVOS);
        
          commit;
        exception
          when others then
            pn_flag := 'N';
            my_errm := SQLERRM;
        end;
      
        --rollback
        if pn_flag = 'N' then
          begin
            update aqpb617b
               set aqpb617best = 'S'
             where aqpb617best = 'N'
               and aqpb617bana = RPAD(pn_Analista, 10, ' ')
               and aqpb617bfpro = ld_finmes----SE COMENTO       pd_fpro
               and aqpb617bcorr =
                   (select max(aqpb617bcorr)
                      from aqpb617b
                     where aqpb617bana = RPAD(pn_Analista, 10, ' ')
                       and aqpb617bfpro = ld_finmes  );
                       -- SE COMENTO pd_fpro);
            commit;
          exception
            when others then
              my_errm := SQLERRM;
              null;
          end;
        end if;
      END LOOP;
      CLOSE Cur_Ana;
    end if;
  end sp_generar_recate;


 ------------------------------------------------------------------------------ 
  procedure sp_fechasvalidas( pd_fpro     in date,
                              pd_fechaini out varchar2,
                              pd_fechafin out Varchar2) is

ld_fecha date ;
ln_MESEVA number:=0;
ln_MESFIN number:=0;
ln_MESINI number:=0;
ln_mespro number:=0;
ln_MESEVAINI number:=0;
ld_fechaini date;
ld_fechafin date;
lc_1 varchar2(10);


BEGIN

        ld_fecha  := pd_fpro; 
        ln_mespro := to_char(ld_fecha,'MM');
 
        begin
          select TP1NRO2 MESEVA, TP1NRO3 MESEVAINI, TP1IMP1 MESINI, TP1IMP2 MESFIN
           into ln_MESEVA, ln_MESEVAINI, ln_MESINI, ln_MESFIN 
          from  fst198
                   where tp1cod = 1
                     and tp1cod1 = 10847
                     and tp1corr1 = 23 
                     and ln_mespro between TP1NRO2 and TP1NRO3 ;
         exception when others then
           ln_MESEVAINI := 0;
           ln_MESEVA := 0;
           ln_MESFIN := 0;
           ln_MESINI := 0;
         end;

         lc_1 := lpad(ln_MESINI, 2, '0');
         lc_1 := lpad('01'||lc_1||to_char(ld_fecha,'YYYY')-1, 8, '0');
         ld_fechaini := last_day(lc_1);
         ld_fechafin := lpad('01'||lpad(ln_MESFIN, 2, '0')||to_char(ld_fecha,'YYYY'), 8, '0');
         ld_fechafin := last_day(ld_fechafin);

         pd_fechaini := ld_fechaini;
         pd_fechafin := ld_fechafin;
         
  end ;
-------------------------------------------------------------


  procedure sp_retorna_com_rrhh(pd_fpro     in date,
                              pn_Analista in varchar2,
                              pc_com1     out char,
                              pc_com2     out char,                              
                              pc_com3     out char,                              
                              pc_com4     out char,
                              pc_com5     out char,
                              pc_codt     out char                                                            
                              ) is
  
  lc_com1 char(1);
  lc_com2 char(1); 
  lc_com3 char(1); 
  lc_com4 char(20); 
  lc_com5 char(20);   
  lc_codt char(11);     

  begin
       
    begin
    select jaqy830com1 , jaqy830com2, jaqy830com3, jaqy830com4, jaqy830com5 , lpad(to_char(jaqy830codid),11,'0') 
      into lc_com1, lc_com2, lc_com3, lc_com4, lc_com5 , lc_codt 
      from  jaqy830 where 
           (jaqy830codana = pn_Analista or jaqy830codana = rpad(pn_Analista,20,' ') ) 
        and jaqy830fini = pd_fpro;
    exception when others then         --- 2023.11.03 se agregó excepcion para obtener codigo trabajador
          begin
            select jaqy830com1 , jaqy830com2, jaqy830com3, jaqy830com4, jaqy830com5 , lpad(to_char(jaqy830codid),11,'0') 
              into lc_com1, lc_com2, lc_com3, lc_com4, lc_com5 , lc_codt 
              from  jaqy830 where 
                   (jaqy830codana = pn_Analista or jaqy830codana = rpad(pn_Analista,20,' ') ) 
                and jaqy830est  = 'S'; -- 2023.11.03 fin
          exception when others then
               lc_com1 := null;
               lc_com2 := null;
               lc_com3 := null; 
               lc_com4 := null; 
               lc_com5 := null;
               lc_codt := null;         
          end;    
    end;
   
  
    pc_com1 := nvl(lc_com1, 'S');
    pc_com2 := nvl(lc_com2, 'S');
    pc_com3 := nvl(lc_com3, 'S');
    pc_com4 := nvl(lc_com4, 'S');
    pc_com5 := nvl(lc_com5, 'S');
    pc_codt := lc_codt;
    
  end sp_retorna_com_rrhh; 
---------------------------------------------------------
function fn_dias_suspension(pv_codana in varchar2,
                          pd_fecini in date,
                          pd_fecfin in date) return number is
    ln_DiaSus number := 0;
    my_errm    VARCHAR2(32000);
    cantidad_meses      number(10);
    fecha_concatenacion date;
    ln_TotDiaSus number := 0;

  begin
 
    
    
    cantidad_meses := months_between(pd_fecfin, pd_fecini);
    
    For f in 0 .. cantidad_meses loop

       fecha_concatenacion := ADD_MONTHS(pd_fecini, f);
    
        --Total dias de suspensión FALTA
        begin
           select j.jaqy830dsus
             into ln_DiaSus
             from jaqy830 j
            where j.jaqy830fini = fecha_concatenacion
              and (j.jaqy830codana = RPAD(pv_codana, 20, ' ') or
                  j.jaqy830codana = pv_codana)
              and ROWID =
                  (select max(rowid)
                     from jaqy830 j
                    where JAQY830FINI = fecha_concatenacion
                    and (j.jaqy830codana = RPAD(pv_codana, 20, ' ') or
                          j.jaqy830codana = pv_codana)
                  );
        exception
           when others then
             ln_DiaSus := 0;
             my_errm      := SQLERRM;
        end;
 
        ln_TotDiaSus := ln_TotDiaSus + nvl(ln_DiaSus,0);

    end loop;
      
    return ln_TotDiaSus;
    
end fn_dias_suspension;


procedure sp_generar_recate1(pd_fpro     in date,
                              pn_Analista in varchar2,
                              pn_flag     out Varchar2) is
  
    my_errm VARCHAR2(32000);
  
    lc_Temp   CHAR(20);
    lc_CodAna Char(10);
    lc_NomAna Varchar2(50);
    lc_NumDoc Char(12);
  
    ln_CodCat Number(3);
    lv_NomCat Varchar2(50);
    ln_CodAge Number(3);
    lc_TipAge char(20);
    lc_NomAge varchar2(50);
  
    lv_catP    Number(3);
    lv_nomcatP Varchar2(50);
  
    ln_CantOpe  Number;
    ln_mntdesem Number(18, 2);
    ln_sldrec   Number(18, 2);
  
    ld_inimes date;
    ld_finmes date;
  
    ln_pais Number(3);
    ln_tdoc Number(3);
    lc_ndoc char(12);
  
    lv_codsbs Varchar2(15);
  
    ln_normal  Number;
    ln_cpp     Number;
    ln_defici  Number;
    ln_dudoso  Number;
    ln_perdida Number;
  
    ln_mope  Number(10); --META NÚMERO DE OPERACIONES
    ln_mmon  Number(18, 2); --META MONTO DESEMBOLSADO
    ln_Corre Number;
  
    lc_hora   Varchar2(15);
    ln_FecAsc Date;
  
    ln_CarHer Number(10, 2); --Porcentaje cartera Heredada.
  
    ld_FecPer         Date;
    ln_MesReca        Number(10);
    ln_MesPermanencia Number(10);
  
    ln_MesTot    Number(10);
    ln_ResOpe    Number(18);
    ln_ResMnt    Number(18, 2);
    lv_NivAna    Varchar2(30);
    lv_flagNivel Varchar2(1);
    lv_flagCalif Varchar2(1);
  
    ld_fecDiaSus  date;
    ln_TotDiaSus  Number(18);
    ln_DiaSus     Number(18);
    ln_MesDiaSus  Number(18);
    lv_flagDiaSus Char(1);
    lv_Res1       Char(1);
    lv_Res2       Char(1);
    lv_Res3       Char(1);
    lv_Res4       Char(1);
      
    sql_stmt VARCHAR2(500);
    TYPE EmpCurTyp IS REF CURSOR;
    Cur_Ana   EmpCurTyp;
    lv_estqry char(1);
  
    ld_fecRant     date;
    ln_CodCatRant  number(10);
    ln_CodCatPRant number(10);
    ld_FecCatPRant date;
  
    ld_fInicio  date;
    ld_fFin     date;
    ln_TotalMnt number;
  
    ld_Fec830 date;
    ln_ConTem number;
    
    ln_pgusu    NUMBER(9);
    ln_CodSuc   NUMBER(3);
    lc_NomSuc   CHAR(30);
    ln_CodZon   NUMBER(3);
    lc_NomZon   CHAR(40);    
    ln_CodReg   NUMBER(9);
    lc_NomReg   CHAR(30);

    
    ld_FecPer_cambio_cargo date;
    validacion_cambio_cargo varchar(10);
    ld_FecPer_fin date;
    ln_CodCat_inicio number;
    
    lc_com1  char(1);
    lc_com2  char(1);
    lc_com3  char(1);
    lc_com4  char(20);
    lc_com5  char(20);
    lc_codt  char(11);
    
    ld_fecdia date;
    
    lc_habilcom char(1);
    
    cursor cambio_cargo(usuario jaqy830.jaqy830codana%type, fecha_inicial jaqy830.jaqy830fini%type,
    fecha_final jaqy830.jaqy830fini%type)  is select * from  jaqy830 where 
           (jaqy830codana = usuario or jaqy830codana = rpad(usuario,20,' ') ) 
        and jaqy830fini between fecha_inicial and fecha_final order by jaqy830fini asc;
  begin
    lc_hora := to_char(sysdate, 'HH24:MI:SS');
    pn_flag := 'S';
    validacion_cambio_cargo := 'N';
  
    --fechas
    begin
      ld_finmes := last_day(pd_fpro);
      ld_finmes := ADD_MONTHS(ld_finmes,-1);
      ld_inimes := TRUNC(ld_finmes, 'MM');
      ld_fecdia := pd_fpro;
      
    exception
      when others then
        my_errm := SQLERRM;
        return;
    end;
  
    begin
            pq_cr_recategorizacion.sp_fechasvalidas(pd_fpro => pd_fpro,
                                                     pd_fechaini => ld_fInicio,
                                                     pd_fechafin => ld_fFin);
    end;

  
    if pn_flag = 'S' then
      --Periocidad Categorizacion
    /*  begin
        select tp1nro1
          into ln_MesReca
          from fst198
         where tp1cod = 1
           and tp1cod1 = 10847
           and tp1corr1 = 21
           and tp1corr2 = 3;
      exception
        when others then
          ln_MesReca := 12;
          my_errm    := SQLERRM;
          return;
      end;
      ld_FecPer := ADD_MONTHS(ld_inimes, (ln_MesReca * -1));
      ld_FecPer_fin := ADD_MONTHS(ld_finmes, (ln_MesReca * -1));
    */
    ld_FecPer := lpad('01'||to_char(ld_fInicio,'MMYYYY'), 8, '0');--ld_fInicio;
    ld_FecPer_fin := ld_fInicio;
    
    
      --Porcentaje cartera Heredada.
      begin
        select tp1nro1 / 100
          into ln_CarHer
          from fst198
         where tp1cod = 1
           and tp1cod1 = 10847
           and tp1corr1 = 21
           and tp1corr2 = 2;
      exception
        when others then
          ln_CarHer := 0.75;
          my_errm   := SQLERRM;
      end;
    
      --Meses de permanecia.
      begin
        select tp1nro1
          into ln_MesPermanencia
          from fst198
         where tp1cod = 1
           and tp1cod1 = 10847
           and tp1corr1 = 21
           and tp1corr2 = 4;
      exception
        when others then
          ln_MesPermanencia := 6;
          my_errm           := SQLERRM;
      end;
    
      --Meses evaluar dias suspension.
      begin
        select tp1nro1
          into ln_MesDiaSus
          from fst198
         where tp1cod = 1
           and tp1cod1 = 10847
           and tp1corr1 = 21
           and tp1corr2 = 5;
      exception
        when others then
          ln_MesDiaSus := 8;
          my_errm      := SQLERRM;
      end;
      ld_fecDiaSus := last_day(ADD_MONTHS(ld_inimes, (ln_MesDiaSus * -1)));
    
      lv_estqry := 'S';
      if trim(pn_Analista) <> '' or pn_Analista is null then
        sql_stmt := 'select distinct jaqy830fini, jaqy830codana, JAQY830NDOC, JAQY830codcat, JAQY830catana, JAQY830codage, JAQY830antage, jaqy830dsus, JAQY830AGEN
                    from jaqy830 
                    WHERE JAQY830EST = ''' || lv_estqry || '''';
                    --WHERE JAQY830EST = ''' || lv_estqry ||''' and jaqy830codana = ''VCACERES  ''';
                    --WHERE JAQY830EST = ''' || lv_estqry ||''' and jaqy830codana = ''ASALDANAS ''';

      else
        sql_stmt := 'select distinct jaqy830fini, jaqy830codana, JAQY830NDOC, JAQY830codcat, JAQY830catana, JAQY830codage, JAQY830antage, jaqy830dsus, JAQY830AGEN
                    from jaqy830 
                    WHERE JAQY830EST =  ''' || lv_estqry ||
                    ''' and jaqy830codana = RPAD(''' || pn_Analista ||''',20,'' '')';
      end if;
    
      OPEN Cur_Ana FOR sql_stmt;
      LOOP
        FETCH Cur_Ana
          INTO ld_Fec830,
               lc_Temp,
               lc_NumDoc, --Documento
               ln_CodCat, --Codigo categoria
               lv_NomCat, --cargo actual
               ln_CodAge, --codigo agencia
               lc_TipAge, --tipo de agencia
               ln_DiaSus, --dia de suspension
               lc_NomAge; --nombre agencia
        EXIT WHEN Cur_Ana%NOTFOUND;-- or pn_flag = 'N';
        pn_flag := 'S';
        lc_CodAna := RPAD(lc_Temp, 10, ' '); --Codigo Analista
      
      
        ln_DiaSus := nvl(ln_DiaSus,0);
        
        --inactivar registros
        begin
          update aqpb617b
             set aqpb617best = 'N'
           where aqpb617bana = lc_CodAna
             and aqpb617bfpro = pd_fpro;--ld_finmes;
          commit;
        exception
          when others then
            my_errm := SQLERRM;
        end;
      
        --nombre analista
        begin
          select ubnom into lc_NomAna from fst746 where ubuser = lc_CodAna;
        exception
          when others then
            my_errm   := SQLERRM;
            lc_NomAna := '';
        end;
      
        --documento del analista
        begin
          select jaqn002pai, jaqn002tdo, jaqn002ndo
            into ln_pais, ln_tdoc, lc_ndoc
            from jaqn002
           where jaqn002usr = lc_CodAna;
        exception
          when others then
            ln_pais := 0;
            ln_tdoc := 0;
            lc_ndoc := '';
            my_errm := SQLERRM;
        end;
      
        --nombre de la agencia
        /*begin
          select scnom
            into lc_NomAge
            from FST001
           where pgcod = 1
             and scnom = lc_NomAge;
        exception
          when others then
            my_errm   := SQLERRM;
            lc_NomAge := '';
        end;*/
        
        --codigo agencia
        begin
          select ubsuc  into ln_CodAge from fst046 where ubuser = lc_CodAna;
        exception
          when others then
            my_errm   := SQLERRM;
            ln_CodAge := null;
        end;
      
      
        --total de meses permanecia
        /*begin
          select COUNT(*)
            into ln_MesTot
            from AQPB617B
           where AQPB617Bana = lc_CodAna
             and AQPB617Bcata = ln_CodCat
             and AQPB617Btage = lc_TipAge
             and AQPB617BFPRO < ld_finmes --verificar
             AND AQPB617Best = 'S';
        exception
          when others then
            my_errm := SQLERRM;
        end;
        if ln_MesTot = 0 then
          select COUNT(*)
            into ln_ConTem
            from AQPB617B
           where AQPB617Bana = lc_CodAna
             AND AQPB617Best = 'S';
          if ln_ConTem > 0 then
            ln_MesTot := 1;
          end if;
        else
          ln_MesTot := ln_MesTot + 1;
        end if;
        se comento calculo
       */
        --nivel analista
        sp_nivel_analista(lc_CodAna, lv_NivAna);
        lv_NivAna    := lower(trim(lv_NivAna));
        lv_flagNivel := case
                          when lv_NivAna = 'coachee' or lv_NivAna = 'seguimiento' then
                           'E' --Excluido
                          when lv_NivAna = 'coach' or lv_NivAna = 'top' then  'A' --Ascenso
                          else
                           'E' -- Excluido
                        end;
        lv_NivAna    := upper(lv_NivAna);
      
        --datos recategorización inmediata anterior anterior
        begin
          select a.aqpb617bfpro,
                 a.AQPB617BCATA,
                 a.AQPB617BCATP,
                 a.AQPB617BFASC
            into ld_fecRant, ln_CodCatRant, ln_CodCatPRant, ld_FecCatPRant
            from aqpb617b a
           where a.aqpb617best = 'S'
             and a.aqpb617bana = lc_CodAna
             and a.aqpb617bfpro < pd_fpro---ld_finmes
           order by a.aqpb617bfpro desc 
           OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;
        exception
          when others then
            my_errm := SQLERRM;
            null;
        end;
      
        if ln_CodCat > ln_CodCatRant then
          ln_FecAsc := ld_Fec830;
        else
          ln_FecAsc := ld_fecRant;
        end if;

        --categoria de la fecha
        begin
        select jaqy830codcat into ln_CodCat_inicio from  jaqy830 where 
               (jaqy830codana = lc_CodAna or jaqy830codana = rpad(lc_CodAna,20,' ') ) 
               and jaqy830fini = ld_FecPer_fin;
        exception when others then
           ln_CodCat_inicio := null;
        end;

        --verificando
        --if ln_MesTot >= ln_MesPermanencia then
        ld_FecPer_cambio_cargo := null;
        ln_FecAsc := null;
        for x in cambio_cargo(lc_CodAna,ld_FecPer,ld_finmes) loop
           if ln_CodCat_inicio != x.jaqy830codcat then
                 validacion_cambio_cargo := 'S';
                 --ld_FecPer_cambio_cargo := ADD_MONTHS(x.jaqy830fini,1);
                 ld_FecPer_cambio_cargo := x.jaqy830fini; -- se considera desde la fecha de ascenso
                 ln_FecAsc := x.jaqy830fini; --- se agrego

                 exit;
           end if;
        end loop;
    
      if ld_FecPer_cambio_cargo is null then
         ld_FecPer_cambio_cargo := ld_FecPer_fin;
         ln_FecAsc := ld_FecPer_fin;
      end if;
        
        if validacion_cambio_cargo = 'N' then 
          ld_fInicio := ld_FecPer_fin;
          ld_fFin    := ld_finmes;
        else
          ld_fInicio := ld_FecPer_cambio_cargo;
          ld_fFin    := ld_finmes;
        end if;

    /*  if trim(lc_CodAna) = 'AALFARO' then
        dbms_output.put_line(lc_CodAna);
       NULL;
      end if;*/
      
        --meses permanencia
        ln_MesTot := round((ld_fFin - ld_fInicio)/30,0);
        
        --cantidad de operacion y monto desembolsado
        ln_CantOpe  := fn_get_cantope(lc_CodAna, ld_fInicio, ld_fFin, ld_fecdia);
        ln_mntdesem := fn_get_mntdesem(lc_CodAna, ld_fInicio, ld_fFin, ld_fecdia);
      
      
        --saldo recibido --se quito consideracion cartera heradada solicitada por RRHH
        /*ln_sldrec := fn_get_sldRecibido(lc_CodAna, ld_fInicio, ld_fFin);
        ln_sldrec := ln_sldrec * ln_CarHer;
      */
        ln_mntdesem := nvl(ln_mntdesem, 0);
        ln_sldrec   := nvl(ln_sldrec, 0);
       
        --metas cargo actual
        begin
          select aqpb617mope, aqpb617mmon
            into ln_mope, ln_mmon
            from aqpb617
           where aqpb617est = 'S'
             and aqpb617cat = ln_CodCat
             and aqpb617tage = lc_TipAge;
        exception
          when others then
            ln_mope := null;
            ln_mmon := null;
            my_errm := SQLERRM;
        end;
      
        --calificación analista
        sp_codigo_sbs(ln_pais, ln_tdoc, lc_ndoc, lv_codsbs);
      
        --calificación analista
        sp_califi_analista(lv_codsbs,
                           ld_finmes, --pd_fpro
                           ln_normal,
                           ln_cpp,
                           ln_defici,
                           ln_dudoso,
                           ln_perdida);
      
        lv_flagCalif := 'A'; ---TODOS CALIFICAN PARA RECATEGORIZACION
                     /*case
                          when ln_normal = 100.00 or ln_normal = 0.00 then
                           'A' --Ascenso
                          else
                           'E' --Excluido
                        end;*/
      
        --obtener correlativo
        begin
          select max(AQPB617BCORR)
            into ln_Corre
            from AQPB617B
           where aqpb617bana = lc_CodAna
             and aqpb617bfpro = ld_finmes;
          ln_Corre := nvl(ln_Corre, 0);
        exception
          when others then
            ln_Corre := 0;
            my_errm  := SQLERRM;
        end;
      
        --Total dias de suspensión FALTA
        begin

           ln_TotDiaSus := pq_cr_recategorizacion.fn_dias_suspension(pv_codana => lc_CodAna,
                                                                          pd_fecini => ld_fecDiaSus,
                                                                          pd_fecfin => ld_finmes);
        end;
    /*    begin
           select sum(AQPB617BDSUS)
             into ln_TotDiaSus
             from AQPB617B
            where aqpb617bana = lc_CodAna
              and aqpb617best = 'S'
              and aqpb617bfpro between ld_fecDiaSus and ld_finmes;
              
           select sum(j.jaqy830dsus)
             into ln_TotDiaSus
             from jaqy830 j
            where j.jaqy830codana = rpad(lc_CodAna, 20, ' ')
              and j.jaqy830fini between ld_fecDiaSus and ld_finmes;
        exception
           when others then
             ln_TotDiaSus := 0;
             my_errm      := SQLERRM;
        end;
  */      
        --cargo propuesta
        ln_TotalMnt := ln_mntdesem + ln_sldrec;
        
        -- Si cumplió con la meta tanto en monto como en número (ambos)
        lv_Res1 := case when ln_CantOpe >= ln_mope and ln_TotalMnt >= ln_mmon then 'A' 
                        else 'N' 
                   end;
        -- Si cumple con el resultado 1 y tiene nivel de riesgo coach es apto, caso contrario no apto
        lv_Res2 := case when lv_Res1 = 'A' and lv_NivAna in ( 'COACH', 'TOP') then 'A'
                        else 'N'
                   end;
      
        --  Más de 3 días de suspensión en los últimos 8 meses, no puede re categorizar.  
        -- S: si tiene dias de suspension, N: no tiene dias o son menor a 3 
        /*lv_flagDiaSus := case when ln_TotDiaSus >= 3 then 'S' validacion anterior manda la plantilla*/
        lv_flagDiaSus := case when ln_DiaSus >= 3 then 'S'
                              else 'N'
                         end;
      

        --2023.07.04  validacion comisiones rrhh
        lc_habilcom := 'S';  
        begin
          select trim(f.tp1desc)
           into lc_habilcom
           from fst198 f
          where TP1COD = 1 and TP1COD1 =10847 and TP1CORR1 = 24 and TP1CORR2 = 1 and TP1CORR3 = 1;
        exception when others then
            lc_habilcom := 'N';      
        end;
        
        if lc_habilcom = 'S' then
            begin
              pq_cr_recategorizacion.sp_retorna_com_rrhh(pd_fpro => ld_finmes, ---ultima carga de archivo fin mes
                                                         pn_analista => rpad(lc_CodAna, 20, ' '),
                                                         pc_com1 => lc_com1,
                                                         pc_com2 => lc_com2,
                                                         pc_com3 => lc_com3,
                                                         pc_com4 => lc_com4,
                                                         pc_com5 => lc_com5,
                                                         pc_codt => lc_codt);
            end;

            if lc_com1 = 'S' and lc_com2 = 'S' and lc_com3 = 'S' and lc_com4 = 'S' and lc_com5 = 'S' then
               lv_Res4 := 'S';
            else 
               lv_Res4 := 'N';
            end if;        
        else
              lc_com1 := null;
              lc_com2 := null;
              lc_com3 := null;
              lc_com4 := null;
              lc_com5 := null;
              lv_Res4 := null;
              
        end if;    
        --           

        -- Si cumple resultado 1 y 2 más validación días de suspensión 
        lv_Res3 := /*se agrego condicion lv_res4
                case when lv_Res1 = 'A' and lv_Res2 = 'A' and lv_flagDiaSus = 'N' then 'A'
                        else 'N'
                   end;*/
                   case when lv_Res1 = 'A' and lv_Res2 = 'A' and lv_flagDiaSus = 'N' and nvl(lv_Res4,'S') = 'S'
                        then 'A'
                   else 'N'
                   end;
        

        if ln_CantOpe   >= ln_mope and 
           ln_TotalMnt  >= ln_mmon and
           ln_MesTot    > ln_MesPermanencia and 
           lv_flagNivel  = 'A' and
           lv_flagDiaSus = 'N'
        --and lv_flagCalif = 'A'
         then
            if ln_CodCat IN (6, 9) then
               begin
                  select aqpb617cat, aqpb617ncat
                    into lv_catP, lv_nomcatP
                    from aqpb617
                   where aqpb617tage = lc_TipAge
                     and aqpb617cat = ln_CodCat
                     and rownum = 1
                   order by aqpb617cat;
                exception
                  when others then
                    lv_catP    := '';
                    lv_nomcatP := '';
                    my_errm    := SQLERRM;
                end;
            else         
                begin
                  select aqpb617cat, aqpb617ncat
                    into lv_catP, lv_nomcatP
                    from aqpb617
                   where aqpb617tage = lc_TipAge
                     and aqpb617cat > ln_CodCat
                     and rownum = 1
                   order by aqpb617cat;
                exception
                  when others then
                    lv_catP    := '';
                    lv_nomcatP := '';
                    my_errm    := SQLERRM;
                end;
            end if;  
        else
          lv_catP    := ln_CodCat;
          lv_nomcatP := lv_NomCat;
        end if;
      
        lv_nomcatP := upper(lv_nomcatP);
        
        --FALTA CONSULTAR TABLAS Y LOS NOMBRES AGENCIA
        --PGCOD
        begin
          SELECT PgcodAc into ln_pgusu
          FROM Fst746
          Where Ubuser = lc_CodAna;
        exception
          when others then
            ln_pgusu := 1;
        end;    
        --CODIGO SUCURSAL
        begin
          select ubsuc into ln_CodSuc
          from fst046
          Where Pgcod = ln_pgusu 
          and Ubuser = lc_CodAna;  
        exception
          when others then
            null;
        end;        
        --NOMBRE SUCURSAL
        begin
          select scnom into lc_NomSuc
          from fst001
          where pgcod = ln_pgusu 
            and sucurs = ln_CodSuc;
        exception
          when others then
            null;
        end;    
        --CODIGO ZONA
        begin
          SELECT RegCod into ln_CodZon
          FROM fst811
          Where Pgcod = ln_pgusu
          AND OfiCod = ln_CodSuc
          AND RegCod < 100;
        exception
          when others then
            null;
        end;        
        --NOMBRE ZONA
        begin
          SELECT RegNom into lc_NomZon
          FROM Fst810
          Where Pgcod = ln_pgusu
          AND RegCod = ln_CodZon
          AND RegCod < 100;
        exception
          when others then
            null;
        end;    
        --REGION
        begin
          SELECT Tp1nro1, Tp1desc
            into ln_CodReg, lc_NomReg
          FROM fst198
          Where Tp1cod   = 1
          AND Tp1cod1  = 10872 
          AND Tp1corr1 = 11
          AND Tp1nro2 = ln_CodZon;--&ZonaAux
        exception
          when others then
            null;
        end;
        
        /*
        Query para region, zona, sucursal, 
        SELECT rc.Tp1nro1, rc.Tp1desc, zc.RegCod, zn.regnom, sn.sucurs, sn.scnom
        from fst001 sn --sucursal
        join fst811 zc on zc.Pgcod = sn.pgcod and zc.OfiCod = sn.sucurs --cod zona
        join fst810 zn on zc.Pgcod = zn.Pgcod and zc.RegCod = zn.regcod and zc.RegCod = zn.RegCod --nom zona
        join fst198 rc on rc.Tp1cod = 1 AND rc.Tp1cod1 = 10872 AND rc.Tp1corr1 = 11 AND rc.Tp1nro2 = zc.RegCod --region
        --Where zc.Pgcod = 1 AND zc.OfiCod = 113 AND zc.RegCod < 100;
        Where sn.pgcod = 1 AND sn.sucurs = 2 AND zc.RegCod < 100;
        */

        --insert registro
        begin
          ln_Corre := ln_Corre + 1;
        
          ln_ResOpe := null;
          ln_ResMnt := null;
        
          insert into AQPB617B
            (AQPB617BCORR,
             AQPB617BFPRO, --0
             AQPB617PAIS,
             AQPB617TDOC,
             AQPB617NDOC,
             AQPB617BANA, --1
             AQPB617CSBS,
             AQPB617BNOMANA,
             AQPB617BNUOPE, --2
             AQPB617BMNTDE, --3
             AQPB617BMNTRE, --4
             AQPB617BMOPE, --5
             AQPB617BMDES, --6
             AQPB617BNANA, --7
             
             AQPB617BCREG,
             AQPB617BNREG,
             AQPB617BCZON,
             AQPB617BNZON,
             
             AQPB617BCAGE, --8
             AQPB617BNAGE,
             AQPB617BTAGE, --9
             AQPB617BCATA, --10
             AQPB617BCARA, --11           
             AQPB617BCNOR,
             AQPB617BCCPP,
             AQPB617BCDEF,
             AQPB617BCDUD,
             AQPB617BCPER,
             AQPB617BCATP, --12
             AQPB617BCARP, --13
             AQPB617BFASC, --14
             
             AQPB617BMPER,
             AQPB617BROPE,
             AQPB617BRMNT,
             
             AQPB617BDSUS,
             AQPB617BRES1,
             AQPB617BRES2,
             AQPB617BRES3,
             
             AQPB617BEST,
             AQPB617BFEC,
             AQPB617BHOR,
             AQPB617BRES4,
             AQPB617BCOM1,
             AQPB617BCOM2,
             AQPB617BCOM3,
             AQPB617BCOM4,
             AQPB617BCOM5,
             AQPB617BCODT                                                   
             )
          values
            (ln_Corre,
             pd_fpro,-----SE COMENTO SE COLOCO FECHA DE PROCESO ld_finmes, --0
             ln_pais,
             ln_tdoc,
             lc_ndoc,
             lc_CodAna, --1
             TRIM(lv_codsbs),
             lc_NomAna,
             ln_CantOpe, --2
             ln_mntdesem, --3
             ln_sldrec, --4
             ln_mope, --5
             ln_mmon, --6
             lv_NivAna, --7 
             
             ln_CodReg,
             lc_NomReg,
             ln_CodZon,
             lc_NomZon,
             
             --ln_CodSuc, --8
             --lc_NomSuc, 
             ln_CodAge, --8
             lc_NomAge,
             
             lc_TipAge, --9
             ln_CodCat, --10
             lv_NomCat, --11
             ln_normal,
             ln_cpp,
             ln_defici,
             ln_dudoso,
             ln_perdida,
             lv_catP, --12 Codigo Categoria Propuesta
             lv_nomcatP, --13 Cargo Propuesto
             ln_FecAsc, --14 FALTA - fecha ascenso
             
             ln_MesTot,
             ln_ResOpe,
             ln_ResMnt,
             
             ln_DiaSus,
             lv_Res1,
             lv_Res2,
             lv_Res3,
             
             'S',
             pd_fpro,
             lc_hora,
             lv_Res4,
             lc_com1,
             lc_com2,
             lc_com3,
             lc_com4,             
             lc_com5,
             lc_codt             
             );
        
          commit;
        exception
          when others then
            pn_flag := 'N';
            my_errm := SQLERRM;
        end;
      
        --rollback
        if pn_flag = 'N' then
          begin
            update aqpb617b
               set aqpb617best = 'S'
             where aqpb617best = 'N'
               and aqpb617bana = RPAD(pn_Analista, 10, ' ')
               and aqpb617bfpro = ld_finmes----SE COMENTO       pd_fpro
               and aqpb617bcorr =
                   (select max(aqpb617bcorr)
                      from aqpb617b
                     where aqpb617bana = RPAD(pn_Analista, 10, ' ')
                       and aqpb617bfpro = ld_finmes  );
                       -- SE COMENTO pd_fpro);
            commit;
          exception
            when others then
              my_errm := SQLERRM;
              null;
          end;
        end if;
      END LOOP;
      CLOSE Cur_Ana;
    end if;
  end sp_generar_recate1;
------------------------------------------------------------------------------
   FUNCTION FN_CR_CANTIDAD_CLIENTES_ACTIVOS(P_CODIGO_ANALISTA IN VARCHAR2,
                                            P_FECHA_INICIO    IN DATE,
                                            P_FECHA_FIN       IN DATE,
                                            P_FECHA_DIA       IN DATE)
      RETURN NUMBER IS
      CANTIDAD_CLIENTES_ACTIVOS NUMBER(18);
      FECHA_CONCATENACION       DATE;
      CANTIDAD_MESES            NUMBER(10);
      TOTAL_CLIENTES_ACTIVOS    NUMBER(18);
   BEGIN
      TOTAL_CLIENTES_ACTIVOS := 0;
      CANTIDAD_MESES         := MONTHS_BETWEEN(P_FECHA_FIN, P_FECHA_INICIO);
   
      FOR F IN 0 .. CANTIDAD_MESES LOOP
         FECHA_CONCATENACION := ADD_MONTHS(P_FECHA_INICIO, F);
         BEGIN
            SELECT COUNT(DISTINCT AOOPER)
              INTO CANTIDAD_CLIENTES_ACTIVOS
              FROM FSD010 A, AQPB617A B
             WHERE A.PGCOD        = B.AQPB617ACOD
               AND A.AOMDA        = B.AQPB617AMDA
               AND A.AOPAP        = 0
               AND A.AOCTA        = B.AQPB617ACTA
               AND A.AOOPER       = B.AQPB617AOPER
               AND (B.AQPB617AASE = RPAD(P_CODIGO_ANALISTA, 10, ' ') OR
                    B.AQPB617AASE = P_CODIGO_ANALISTA)
               AND B.AQPB617AFPRO = FECHA_CONCATENACION
               AND B.AQPB617ACINA = 'N'
               AND (A.AOSTAT <> 99 OR
                   (A.AOSTAT = 99 AND A.AOFE99 > FECHA_CONCATENACION));
         EXCEPTION
            WHEN OTHERS THEN
               CANTIDAD_CLIENTES_ACTIVOS := 0;
         END;
         TOTAL_CLIENTES_ACTIVOS := TOTAL_CLIENTES_ACTIVOS +
                                   CANTIDAD_CLIENTES_ACTIVOS;
      END LOOP;
      IF P_FECHA_DIA > P_FECHA_FIN THEN
         FECHA_CONCATENACION := P_FECHA_DIA;
         BEGIN
            SELECT COUNT(DISTINCT AOOPER)
              INTO CANTIDAD_CLIENTES_ACTIVOS
              FROM FSD010 A, AQPB617A B
             WHERE A.PGCOD        = B.AQPB617ACOD
               AND A.AOMDA        = B.AQPB617AMDA
               AND A.AOPAP        = 0
               AND A.AOCTA        = B.AQPB617ACTA
               AND A.AOOPER       = B.AQPB617AOPER
               AND (B.AQPB617AASE = RPAD(P_CODIGO_ANALISTA, 10, ' ') OR
                    B.AQPB617AASE  = P_CODIGO_ANALISTA)
               AND B.AQPB617AFPRO = FECHA_CONCATENACION
               AND B.AQPB617ACINA = 'N'
               AND (A.AOSTAT <> 99 OR
                   (A.AOSTAT = 99 AND A.AOFE99 > FECHA_CONCATENACION));
         EXCEPTION
            WHEN OTHERS THEN
               CANTIDAD_CLIENTES_ACTIVOS := 0;
         END;
         TOTAL_CLIENTES_ACTIVOS := TOTAL_CLIENTES_ACTIVOS +
                                   CANTIDAD_CLIENTES_ACTIVOS;
      END IF;
      RETURN TOTAL_CLIENTES_ACTIVOS;
   END FN_CR_CANTIDAD_CLIENTES_ACTIVOS;

end PQ_CR_RECATEGORIZACION;

/*  procedure sp_generar_recate(pd_fpro  in date, pn_Analista in varchar2, pn_flag  out Varchar2) is
  
  my_errm VARCHAR2(32000);
  
  cursor Lista_Analistas is
    select distinct 
           jaqy830codana CodAna, 
           JAQY830NDOC   NumDoc, 
           JAQY830codcat CodCat, 
           JAQY830catana NomCat, 
           JAQY830codage CodAge, 
           JAQY830antage TipAge,
           jaqy830dsus   DiaSus
      from jaqy830 
     WHERE JAQY830EST = 'S'
       and jaqy830codana = 'ASALDANAS '; ---analistas
       
  cursor Lista_AnalistasUno (c_Analista in varchar2) is
    select distinct 
           jaqy830codana CodAna, 
           JAQY830NDOC   NumDoc, 
           JAQY830codcat CodCat, 
           JAQY830catana NomCat, 
           JAQY830codage CodAge, 
           JAQY830antage TipAge
      from jaqy830 
     WHERE JAQY830EST = 'S'
       and jaqy830codana = c_Analista; ---analistas
       
  lc_Temp     CHAR(20);
  lc_CodAna   Char(10);
  lc_NomAna   Varchar2(50);
  lc_NumDoc   Char(12);
  
  ln_CodCat   Number(3); 
  lv_NomCat   Varchar2(50);
  ln_CodAge   Number(3);
  lc_TipAge   char(20);
  lc_NomAge   varchar2(50);
  
  lv_catP     Number(3); 
  lv_nomcatP  Varchar2(50);
  
  ln_CantOpe  Number;
  ln_mntdesem Number(18,2);
  ln_sldrec   Number(18,2);
  
  ld_inimes   date;
  ld_finmes   date;
  
  ln_pais     Number(3);
  ln_tdoc     Number(3);
  lc_ndoc     char(12);
  
  lv_codsbs   Varchar2(15);
  
  ln_normal   Number;
  ln_cpp      Number;
  ln_defici   Number;
  ln_dudoso   Number;
  ln_perdida  Number;
  
  ln_mope     Number(10); --META NÚMERO DE OPERACIONES
  ln_mmon     Number(18,2); --META MONTO DESEMBOLSADO
  ln_Corre    Number;

  lc_hora     Varchar2(15);
  ln_FecAsc   Date;
  
  ln_meses    Number;
  
  ln_CarHer  Number(10,2); --Porcentaje cartera Heredada.
  ld_ultcar  Date;
  
  
  ld_FecPer  Date;
  ln_MesReca Number(10);
  ln_MesPermanencia Number(10);
  
  ln_MesTot  Number(10); 
  ln_ResOpe  Number(18);
  ln_ResMnt  Number(18,2);
  lv_NivAna  Varchar2(30);
  lv_flagNivel Varchar2(1);
  lv_flagCalif Varchar2(1);
  
  ld_fecDiaSus  date;
  ln_TotDiaSus    Number(18);
  ln_DiaSus    Number(18);
  ln_MesDiaSus Number(18);
  lv_flagDiaSus Char(1);
  lv_Res1      Char(1);
  lv_Res2      Char(1);
  lv_Res3      Char(1);
  
  begin
    lc_hora := to_char(sysdate, 'HH24:MI:SS');
    pn_flag := 'S';
    
    --Fecha de ultima carga
    begin
      select max(AQPB617BFPRO)
        into ld_ultcar
        from aqpb617b
       where aqpb617best = 'S';
    exception
      when others then
        my_errm    := SQLERRM;
    end;
    
    --fechas
    begin
      ld_finmes := last_day(pd_fpro);
      --ld_finmes := ADD_MONTHS(ld_finmes,-1);
      ld_inimes := TRUNC(ld_finmes, 'MM');      
    exception
      when others then
        my_errm    := SQLERRM;
        return;
    end;
    
    if pn_flag = 'S' then 
      --Periocidad Categorizacion
      begin
        select tp1nro1
          into ln_MesReca
          from fst198
         where tp1cod = 1
           and tp1cod1 = 10847
           and tp1corr1 = 21
           and tp1corr2 = 3;      
      exception
        when others then
          ln_MesReca := 12;
          my_errm   := SQLERRM;
          return;
      end;
      ld_FecPer := ADD_MONTHS(ld_inimes,(ln_MesReca*-1));
      
      --Porcentaje cartera Heredada.
      begin
        select tp1nro1 / 100
          into ln_CarHer
          from fst198
         where tp1cod = 1
           and tp1cod1 = 10847
           and tp1corr1 = 21
           and tp1corr2 = 2;
      exception
        when others then
          ln_CarHer := 0.75;
          my_errm    := SQLERRM;
      end;
      
      --Meses de permanecia.
      begin
        select tp1nro1
        into ln_MesPermanencia
        from fst198
        where tp1cod = 1
        and tp1cod1 = 10847
        and tp1corr1 = 21
        and tp1corr2 = 4;
      exception
        when others then
          ln_MesPermanencia := 6;
          my_errm    := SQLERRM;
      end;

      --Meses devaluar dias suspension.
      begin
        select tp1nro1
        into ln_MesDiaSus
        from fst198
        where tp1cod = 1
        and tp1cod1 = 10847
        and tp1corr1 = 21
        and tp1corr2 = 5;
      exception
        when others then
          ln_MesDiaSus := 8;
          my_errm    := SQLERRM;
      end;
      ld_fecDiaSus := ADD_MONTHS(ld_inimes,(ln_MesDiaSus*-1));
            
      if trim(pn_Analista) <> '' or pn_Analista is null then
            
        for i in Lista_Analistas loop
          --datos analista
          begin
            lc_Temp   := i.CodAna;
            lc_CodAna := RPAD(lc_Temp,10,' '); --Codigo Analista
            lc_NumDoc := i.NumDoc; --Documento
            ln_CodCat := i.CodCat; --Codigo categoria
            lv_NomCat := i.NomCat; --cargo actual
            ln_CodAge := i.CodAge; --codigo agencia
            lc_TipAge := i.TipAge; --tipo de agencia
            ln_DiaSus := i.DiaSus; --dia de suspension
          exception
            when others then
              my_errm    := SQLERRM;
              return;
          end;
          
          --inactivar registros
          begin
            update aqpb617b set aqpb617best = 'N' 
             where aqpb617bana = lc_CodAna
               and aqpb617bfpro = ld_finmes;
            commit;
          exception
            when others then
              my_errm    := SQLERRM;
          end;
          
          --nombre analista
          begin
            select ubnom into lc_NomAna
            from fst746 where ubuser = lc_CodAna;      
          exception
            when others then
              my_errm := SQLERRM;
              lc_NomAna := '';
          end;
          
          --documento del analista
          begin
            select jaqn002pai, 
                   jaqn002tdo, 
                   jaqn002ndo
              into ln_pais,
                   ln_tdoc,
                   lc_ndoc
              from jaqn002
             where jaqn002usr = lc_CodAna ;
          exception
            when others then
              ln_pais := 0;
              ln_tdoc := 0;
              lc_ndoc := '';
              my_errm    := SQLERRM;
              --DBMS_OUTPUT.put_line(my_errm);
          end;
                
          --nombre de la agencia
          begin
            select scnom
              into lc_NomAge
              from FST001
             where pgcod = 1
               and sucurs = ln_CodAge;
          exception
            when others then
              my_errm   := SQLERRM;
              lc_NomAna := '';
          end;

          --total de meses permanecia
          begin
            select COUNT(*) 
              into ln_MesTot
              from AQPB617B
             where AQPB617Bana = lc_CodAna
               and AQPB617Bcata = ln_CodCat
               and AQPB617Btage = lc_TipAge
               AND AQPB617Best = 'S';
          exception
            when others then
              ln_MesTot := 0;
              my_errm   := SQLERRM;
          end;
          
          --fecha ultimo ascenso
          begin
            select max(AQPB617BFASC)
              into ln_FecAsc
              from AQPB617B
             where aqpb617bana = lc_CodAna
               --and AQPB617Best = 'S'
             order by aqpb617Bfpro desc;
          exception
            when others then
              ln_FecAsc := ld_finmes;
              my_errm   := SQLERRM;
          end;
          
          if ln_FecAsc is null then
            ln_FecAsc := ld_finmes;
          end if;
          
          --nivel analista
          sp_nivel_analista(lc_CodAna, lv_NivAna);
          lv_NivAna := lower(trim(lv_NivAna));
          lv_flagNivel := case
                          when lv_NivAna = 'coachee' or lv_NivAna = 'seguimiento' then 'E' --Excluido
                          else 'A' --Ascenso
                          end;
          lv_NivAna := upper(lv_NivAna);
          
          --cantidad de operacion y monto desembolsado
          ln_CantOpe := fn_get_cantope(lc_CodAna, ld_FecPer, ld_finmes);
          ln_mntdesem := fn_get_mntdesem(lc_CodAna, ld_FecPer, ld_finmes);

          --saldo recibido
          ln_sldrec := fn_get_sldRecibido(lc_CodAna, ld_FecPer, ld_finmes);
          ln_sldrec := ln_sldrec * ln_CarHer;
               
          ln_mntdesem := nvl(ln_mntdesem,0);
          ln_sldrec := nvl(ln_sldrec,0);

          --metas cargo actual
          begin
            select aqpb617mope,
                   aqpb617mmon
              into ln_mope,
                   ln_mmon
            from aqpb617
            where aqpb617est = 'S'
            and aqpb617cat = ln_CodCat 
            and aqpb617tage = lc_TipAge;
          exception
            when others then
              ln_mope := null;
              ln_mmon := null;
              my_errm    := SQLERRM;
          end;
          
          --calificación analista
          sp_codigo_sbs(ln_pais, ln_tdoc, lc_ndoc, lv_codsbs);
          
          --calificación analista
          sp_califi_analista(lv_codsbs,
                             ld_finmes, --pd_fpro
                             ln_normal,
                             ln_cpp,
                             ln_defici,
                             ln_dudoso,
                             ln_perdida);
                             
          lv_flagCalif := case
                          when ln_normal = 100.00 or ln_normal = 0.00 then 'A' --Ascenso
                          else 'E' --Excluido
                          end;
                          
          --obtener correlativo
          begin
            select max(AQPB617BCORR) into ln_Corre 
            from AQPB617B
            where aqpb617bana = lc_CodAna
              and aqpb617bfpro = ld_finmes;
            ln_Corre := nvl(ln_Corre,0);             
          exception
            when others then
              ln_Corre := 0;
              my_errm    := SQLERRM;
              
          end;
          
          --Total dias de suspensión
          begin
            select sum(AQPB617BDSUS) into ln_TotDiaSus 
            from AQPB617B
            where aqpb617bana = lc_CodAna
              and aqpb617best = 'S'
              and aqpb617bfpro between ld_fecDiaSus and  ld_finmes;
          exception
            when others then
              ln_TotDiaSus := 0;
              my_errm    := SQLERRM;
              
          end;
          
          -- Si cumplió con la meta tanto en monto como en número (ambos)
          lv_Res1 := case when ln_CantOpe >= ln_mope and ln_mntdesem + ln_sldrec >= ln_mmon 
                          then 'A'
                          else 'N'
                     end;
          -- Si cumple con el resultado 1 y tiene nivel de riesgo coach es apto, caso contrario no apto
          lv_Res2 := case when lv_Res1 = 'A' and lv_NivAna  = 'COACH' 
                          then 'A'
                          else 'N'
                     end;
          
          --  Más de 3 días de suspensión en los últimos 8 meses, no puede re categorizar.      
          lv_flagDiaSus := case when ln_TotDiaSus >= 3 then 'N' else 'S' end;
               
          -- Si cumple resultado 1 y 2 más validación días de suspensión 
          lv_Res3 := case when lv_Res1 = 'A' and lv_Res2 = 'A' and lv_flagDiaSus  = 'S' 
                          then 'A'
                          else 'N'
                     end;
          
          
          
          --cargo propuesta
          ln_mope := ln_mope/10;
          ln_mmon := ln_mmon/10;
          if ln_CantOpe >= ln_mope and 
             ln_mntdesem + ln_sldrec >= ln_mmon and
             ln_MesTot >= ln_MesPermanencia and
             lv_flagNivel = 'A'
             --and lv_flagCalif = 'A'
          then
            begin
              select aqpb617cat, aqpb617ncat
                into lv_catP, lv_nomcatP
                from aqpb617 
               where aqpb617tage = lc_TipAge
                 and aqpb617cat > ln_CodCat
                 and rownum = 1
               order by aqpb617cat;
            exception
              when others then
                lv_catP    := '';
                lv_nomcatP := '';
                my_errm    := SQLERRM;
                
            end;
            ln_FecAsc := ld_finmes;
          else
            lv_catP    := ln_CodCat;
            lv_nomcatP := lv_NomCat;
          end if;
          
          lv_nomcatP := upper(lv_nomcatP);
          
          --insert registro
          begin
            ln_Corre := ln_Corre +1;

            ln_ResOpe := null;
            ln_ResMnt := null;
               
            insert into AQPB617B
              (AQPB617BCORR,
               AQPB617BFPRO, --0
               AQPB617PAIS,
               AQPB617TDOC,
               AQPB617NDOC,
               AQPB617BANA, --1
               AQPB617CSBS, 
               AQPB617BNOMANA,
               AQPB617BNUOPE, --2
               AQPB617BMNTDE, --3
               AQPB617BMNTRE, --4
               AQPB617BMOPE, --5
               AQPB617BMDES, --6
               AQPB617BNANA, --7
               AQPB617BCAGE, --8
               AQPB617BNAGE,
               AQPB617BTAGE, --9
               AQPB617BCATA, --10
               AQPB617BCARA, --11           
               AQPB617BCNOR,
               AQPB617BCCPP,
               AQPB617BCDEF,
               AQPB617BCDUD,
               AQPB617BCPER,           
               AQPB617BCATP, --12
               AQPB617BCARP, --13
               AQPB617BFASC, --14
               
               AQPB617BMPER,
               AQPB617BROPE,
               AQPB617BRMNT,
               
               AQPB617BDSUS,
               AQPB617BRES1,
               AQPB617BRES2,
               AQPB617BRES3,
      
               AQPB617BEST,
               AQPB617BFEC,
               AQPB617BHOR
               )
            values
              (ln_Corre,
               ld_finmes, --0
               ln_pais,
               ln_tdoc,
               lc_ndoc,
               lc_CodAna, --1
               TRIM(lv_codsbs),
               lc_NomAna,
               ln_CantOpe, --2
               ln_mntdesem, --3
               ln_sldrec, --4
               ln_mope, --5
               ln_mmon, --6
               lv_NivAna, --7 
               ln_CodAge, --8
               lc_NomAge, 
               lc_TipAge, --9
               ln_CodCat, --10
               lv_NomCat, --11
               ln_normal,
               ln_cpp,
               ln_defici,
               ln_dudoso,
               ln_perdida,
               lv_catP, --12 Codigo Categoria Propuesta
               lv_nomcatP, --13 Cargo Propuesto
               ln_FecAsc, --14 FALTA - fecha ascenso
               
               ln_MesTot,
               ln_ResOpe, 
               ln_ResMnt,
               
               ln_DiaSus,
               lv_Res1,
               lv_Res2,
               lv_Res3,
                               
               'S',
               pd_fpro,
               lc_hora
               );

            commit;
          exception
            when others then
              pn_flag    := 'N';
              my_errm    := SQLERRM;
              
              rollback;
          end;
        
        end loop;  
        
        --rollback
        if pn_flag = 'N' then
          begin
            delete from aqpb617b 
                  where aqpb617best = 'S' and AQPB617BFPRO = ld_finmes;
            commit;
          exception
            when others then
              null;
              --my_errm    := SQLERRM;
          end;
          
          begin
            update aqpb617b set aqpb617best = 's' 
             where aqpb617best = 'N'
               and aqpb617bana = RPAD(pn_Analista, 10, ' ')
               and aqpb617bfpro = ld_finmes
               and aqpb617bcorr = (select max(aqpb617bcorr) from aqpb617b where aqpb617bana = RPAD(pn_Analista, 10, ' ') and aqpb617bfpro = ld_finmes);
            commit;             
          exception
            when others then
              null;
              --my_errm    := SQLERRM;
          end;
        end if;        
      
      else
        --inactivar registros
        begin
          update aqpb617b set aqpb617best = 'N' 
           where aqpb617best = 'S'
             and aqpb617bana = RPAD(pn_Analista, 10, ' ')
             and aqpb617bfpro = ld_finmes;
          commit;
        exception
          when others then
            my_errm    := SQLERRM;
        end;    
        
        for i in Lista_AnalistasUno (RPAD(pn_Analista, 10, ' ')) loop
          --datos analista
          begin
            lc_Temp   := i.CodAna;
            lc_CodAna := RPAD(lc_Temp,10,' '); --Codigo Analista
            lc_NumDoc := i.NumDoc; --Documento
            ln_CodCat := i.CodCat; --Codigo categoria
            lv_NomCat := i.NomCat; --cargo actual
            ln_CodAge := i.CodAge; --codigo agencia
            lc_TipAge := i.TipAge; --tipo de agencia
          exception
            when others then
              my_errm    := SQLERRM;
              return;
          end;
          \*
          --eliminar duplicados
          begin
            delete from aqpb617b b where b.aqpb617bfpro = ld_finmes and b.aqpb617bana = lc_CodAna;
            commit;
          end;
          *\
          --nombre analista
          begin
            select ubnom into lc_NomAna
            from fst746 where ubuser = lc_CodAna;      
          exception
            when others then
              my_errm := SQLERRM;
              lc_NomAna := '';
          end;
          
          --documento del analista
          begin
            select jaqn002pai, 
                   jaqn002tdo, 
                   jaqn002ndo
              into ln_pais,
                   ln_tdoc,
                   lc_ndoc
              from jaqn002
             where jaqn002usr = lc_CodAna ;
              -- and jaqn002ndo = lc_NumDoc;
          exception
            when others then
              ln_pais := 0;
              ln_tdoc := 0;
              lc_ndoc := '';
              my_errm    := SQLERRM;
              --DBMS_OUTPUT.put_line(my_errm);
          end;
                
          --nombre de la agencia
          begin
            select scnom
              into lc_NomAge
              from FST001
             where pgcod = 1
               and sucurs = ln_CodAge;
          exception
            when others then
              my_errm   := SQLERRM;
              lc_NomAna := '';
          end;

          --total de meses permanecia
          begin
            select COUNT(*) 
              into ln_MesTot
              from AQPB617B
             where AQPB617Bana = lc_CodAna
               and AQPB617Bcata = ln_CodCat
               and AQPB617Btage = lc_TipAge;
          exception
            when others then
              ln_MesTot := 0;
              my_errm   := SQLERRM;
          end;
          
          --fecha ultimo ascenso
          begin
            select max(AQPB617BFASC)
              into ln_FecAsc
              from AQPB617B
             where aqpb617bana = lc_CodAna
               --and AQPB617Best = 'S'
             order by aqpb617Bfpro desc;
          exception
            when others then
              ln_FecAsc := ld_finmes;
              my_errm   := SQLERRM;
          end;
          
          if ln_FecAsc is null then
            ln_FecAsc := ld_finmes;
          end if;
          
          --nivel analista
          begin
            select jaqz839rating
              into lv_NivAna
              from jaqz839 j
             where j.jaqz839analst = trim(lc_CodAna);
          exception
            when others then
              lv_NivAna := '';
              my_errm    := SQLERRM;
          end;
          
          sp_nivel_analista(lc_CodAna, lv_NivAna);
          lv_NivAna := lower(trim(lv_NivAna));
          lv_flagNivel := case
                          when lv_NivAna = 'coachee' or lv_NivAna = 'seguimiento' then 'E' --Excluido
                          else 'A' --Ascenso
                          end;
          lv_NivAna := upper(lv_NivAna);
          
          --cantidad de operacion y monto desembolsado
          ln_CantOpe := fn_get_cantope(lc_CodAna, ld_FecPer, ld_finmes);
          ln_mntdesem := fn_get_mntdesem(lc_CodAna, ld_FecPer, ld_finmes);

          --saldo recibido
          ln_sldrec := fn_get_sldRecibido(lc_CodAna, ld_FecPer, ld_finmes);
          ln_sldrec := ln_sldrec * ln_CarHer;
               
          ln_mntdesem := nvl(ln_mntdesem,0);
          ln_sldrec := nvl(ln_sldrec,0);

          --metas cargo actual
          begin
            select aqpb617mope,
                   aqpb617mmon
              into ln_mope,
                   ln_mmon
            from aqpb617
            where aqpb617est = 'S'
            and aqpb617cat = ln_CodCat 
            and aqpb617tage = lc_TipAge;
          exception
            when others then
              ln_mope := -1;
              ln_mmon := -1;
              my_errm    := SQLERRM;
          end;
          
          --calificación analista
          sp_codigo_sbs(ln_pais, ln_tdoc, lc_ndoc, lv_codsbs);
          
          --calificación analista
          sp_califi_analista(lv_codsbs,
                             ld_finmes, --pd_fpro
                             ln_normal,
                             ln_cpp,
                             ln_defici,
                             ln_dudoso,
                             ln_perdida);
                             
          lv_flagCalif := case
                          when ln_normal = 100.00 or ln_normal = 0.00 then 'A' --Ascenso
                          else 'E' --Excluido
                          end;
          --obtener correlativo
          begin
            select max(AQPB617BCORR) into ln_Corre 
            from AQPB617B
            where aqpb617bana = lc_CodAna;
            ln_Corre := nvl(ln_Corre,0);
          exception
            when others then
              ln_Corre := 0;
              my_errm    := SQLERRM;
              
          end;
          
          ln_meses := abs(trunc(months_between(ld_finmes , ln_FecAsc)));
          
          --cargo propuesta
          ln_mope:=(ln_mope/10);
          ln_mmon:=ln_mmon/10;
          if ln_CantOpe >= ln_mope and 
             ln_mntdesem + ln_sldrec >= ln_mmon and
             ln_MesTot >= ln_MesPermanencia and
             lv_flagNivel = 'A' and
             lv_flagCalif = 'A'
            then             
          --if 1 = 1 then -- solo para pruebas
            begin
              select aqpb617cat, aqpb617ncat
                into lv_catP, lv_nomcatP
                from aqpb617 
               where aqpb617tage = lc_TipAge
                 and aqpb617cat > ln_CodCat
                 and rownum = 1
               order by aqpb617cat;
            exception
              when others then
                lv_catP    := '';
                lv_nomcatP := '';
                my_errm    := SQLERRM;
                
            end;
            ln_FecAsc := ld_finmes;
          else
            lv_catP    := ln_CodCat;
            lv_nomcatP := lv_NomCat;
          end if;
          
          lv_nomcatP := upper(lv_nomcatP);
          
          --insert registro
          begin
            ln_Corre := ln_Corre +1;

            ln_ResOpe := null;
            ln_ResMnt := null;
               
            insert into AQPB617B
              (AQPB617BCORR,
               AQPB617BFPRO, --0
               AQPB617PAIS,
               AQPB617TDOC,
               AQPB617NDOC,
               AQPB617BANA, --1
               AQPB617CSBS, 
               AQPB617BNOMANA,
               AQPB617BNUOPE, --2
               AQPB617BMNTDE, --3
               AQPB617BMNTRE, --4
               AQPB617BMOPE, --5
               AQPB617BMDES, --6
               AQPB617BNANA, --7
               AQPB617BCAGE, --8
               AQPB617BNAGE,
               AQPB617BTAGE, --9
               AQPB617BCATA, --10
               AQPB617BCARA, --11           
               AQPB617BCNOR,
               AQPB617BCCPP,
               AQPB617BCDEF,
               AQPB617BCDUD,
               AQPB617BCPER,           
               AQPB617BCATP, --12
               AQPB617BCARP, --13
               AQPB617BFASC, --14
               
               AQPB617BMPER,
               AQPB617BROPE,
               AQPB617BRMNT,
      
               AQPB617BEST,
               AQPB617BFEC,
               AQPB617BHOR
               )
            values
              (ln_Corre,
               ld_finmes, --0
               ln_pais,
               ln_tdoc,
               lc_ndoc,
               lc_CodAna, --1
               TRIM(lv_codsbs),
               lc_NomAna,
               ln_CantOpe, --2
               ln_mntdesem, --3
               ln_sldrec, --4
               ln_mope, --5
               ln_mmon, --6
               lv_NivAna, --7 
               ln_CodAge, --8
               lc_NomAge, 
               lc_TipAge, --9
               ln_CodCat, --10
               lv_NomCat, --11
               ln_normal,
               ln_cpp,
               ln_defici,
               ln_dudoso,
               ln_perdida,
               lv_catP, --12 Codigo Categoria Propuesta
               lv_nomcatP, --13 Cargo Propuesto
               ln_FecAsc, --14 FALTA - fecha ascenso
               
               ln_MesTot,
               ln_ResOpe, 
               ln_ResMnt,
               
               'S',
               pd_fpro,
               lc_hora
               );

            commit;
          exception
            when others then
              pn_flag    := 'N';
              my_errm    := SQLERRM;
              
              rollback;
          end;
        
        end loop;  
        
        --rollback
        if pn_flag = 'N' then
          begin
            delete from aqpb617b where aqpb617best = 'S' and AQPB617BFPRO = ld_finmes;
            commit;
          exception
            when others then
              null;
              --my_errm    := SQLERRM;
          end;
          
          begin
            update aqpb617b set aqpb617best = 'S' where aqpb617best = 'N' and AQPB617BFPRO = ld_ultcar;
            commit;
          exception
            when others then
              null;
              --my_errm    := SQLERRM;
          end;
        end if;
      end if;
    end if;
  end sp_generar_recate;*/
/

