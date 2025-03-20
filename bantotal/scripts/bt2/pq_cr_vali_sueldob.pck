create or replace package pq_cr_vali_SueldoB is

  -- Author  : EFUENTES
  -- Created : 12/10/2021 09:23:25
  -- Purpose : 
  ------------------------------------------------------
  procedure sp_vali_Sueldo_CSP(pn_instancia in number,
                               pc_Flag      out varchar2);
  ------------------------------------------------------
  PROCEDURE sp_sueldo(pn_instancia    in number,
                      pn_sueldo_soles out number,
                      pn_sueldo_dolar out number,
                      pn_sueldo_total out number);

end pq_cr_vali_SueldoB;
/

create or replace package body pq_cr_vali_SueldoB is

  ------------------------------------------------------
  --validacion sueldo Campaña Segmento Personas
  PROCEDURE sp_vali_Sueldo_CSP(pn_instancia in number,
                               pc_Flag      out varchar2) IS
  
    ln_moneda_sol   number;
    ln_num_eva    number;
    ln_monto_ins  number;
    ln_suel_sol   number;
    ln_suel_dol   number;
    ln_suel_bru   number;
    ln_suel_cal   number;
    ln_tip_cam    number;
    ln_val        number; --(Valor almacenado en una guía de procesos)
    ln_val_limite number;
    ld_fecha_sys  date;
    lc_hora       varchar2(20);
    ln_correl     number;
    ln_coderr     number;
    my_errm       varchar2(32000);
    
  BEGIN
    --multiplicador
    begin
      select t.tp1imp1
      into ln_val
        from FST198 t
       where t.tp1cod = 1
         and t.tp1cod1 = 10899
         and t.tp1corr1 = 752
         and t.tp1corr3 = 1
         and t.tp1corr2 = 1;
    exception
      when others then
        ln_coderr := -3;
        my_errm   := SQLERRM;
        DBMS_OUTPUT.put_line(my_errm);
    end;
    
    --limite desembolso
    begin
      select t.tp1imp1
        into ln_val_limite
        from FST198 t
       where t.tp1cod = 1
         and t.tp1cod1 = 10899
         and t.tp1corr1 = 752
         and t.tp1corr3 = 1
         and t.tp1corr2 = 2;
    exception
      when others then
        ln_coderr := -2;
        my_errm   := SQLERRM;
        DBMS_OUTPUT.put_line(my_errm);
    end;

    -- fecha del sistema
    begin
      select f.pgfape
        into ld_fecha_sys
        from fst017 f 
       where f.pgcod = 1;
    exception
      when others then
        ln_coderr  := -1;
        my_errm    := SQLERRM;
        DBMS_OUTPUT.put_line(my_errm);
    end;
    
    -- numero de evaluacion
    begin
      select s21.sng021eval
        into ln_num_eva
        from sng021 s21
       where s21.sng021sol = pn_instancia;
    exception
      when others then
        ln_num_eva := 0;
    end;
    
    -- tipo de cambio
    begin
      select s120.sng120tcbi
        into ln_tip_cam
        from sng120 s120
       where s120.sng120tsk = 'EVALUACION'
         and s120.sng120ins = pn_instancia;
      ln_tip_cam := nvl(ln_tip_cam, 0);
    exception
      when others then
        ln_tip_cam := 0;
        ln_coderr  := 2;
        my_errm    := SQLERRM;
        DBMS_OUTPUT.put_line(my_errm);
    end;
   
    if ln_tip_cam = 0 then 
      begin
        ln_tip_cam := fn_tipo_cambio_fijo(P_FECHA => ld_fecha_sys);
      exception
        when others then
          ln_tip_cam := 1;
          ln_coderr := 3;
          my_errm := SQLERRM;
          DBMS_OUTPUT.put_line (my_errm);
      end;
    end if;
    
    -- monto de la solicitud
    begin
      select f.xwfmonto1, f.xwfmoneda
      into ln_monto_ins, ln_moneda_sol
      from xwf700 f 
      where f.xwfcar3 = '1' and f.xwfprcins = pn_instancia;
    exception
      when others then
        ln_monto_ins := 0;
        ln_coderr    := 4;
        my_errm      := SQLERRM;
        DBMS_OUTPUT.put_line(ln_coderr);
        DBMS_OUTPUT.put_line(my_errm);
    end;
    
    if ln_moneda_sol <> 0 then
      ln_monto_ins := ln_monto_ins * ln_tip_cam;
    end if;
    
    -- obtener sueldos
    sp_sueldo(pn_instancia, ln_suel_sol, ln_suel_dol, ln_suel_bru);
    ln_suel_cal := ln_suel_bru * ln_val;
    --ln_suel_cal := ln_suel_bru + ln_suel_cal;
    
    -- no debe superar el monto limite 
    if ln_monto_ins <= ln_val_limite then
      
      if ln_monto_ins <= ln_suel_cal then 
        pc_Flag := 'S';
      else
        pc_Flag := 'N';
      end if;
      
    else
      pc_Flag := 'N'; 
    end if;
    
    --REGISTRO LOG
    lc_hora := to_char(sysdate, 'HH24:MI:SS');
    begin
      update aqpb614 a set a.aqpb614estado = 'S'
      where a.aqpb614instan = pn_instancia;
      COMMIT;
    exception
      when others then
        null;
    end;

    begin
      select max (a.AQPB614CORREL)
      into ln_correl
      from aqpb614 a
      where a.aqpb614instan = pn_instancia;
    exception
      when others then
        null;
    end;   
    
    ln_correl := nvl(ln_correl, 0);
    ln_correl := ln_correl + 1;
    begin
      INSERT INTO AQPB614
        (AQPB614CORREL,
         AQPB614INSTAN,
         AQPB614TIPSOL,
         AQPB614NUMEVA,
         AQPB614MONINS,
         AQPB614SUESOL,
         AQPB614SUEDOL,
         AQPB614SUEBRU,
         AQPB614SUECAL,
         AQPB614VALCAL,
         AQPB614VALLIM,
         AQPB614TIPCAM,
         AQPB614FLAG,
         AQPB614ESTADO,
         AQPB614AUX1N,
         AQPB614AUX2C,
         AQPB614FECHA,
         AQPB614HORA)
      VALUES
        (ln_correl,
         pn_instancia,
         ln_moneda_sol,
         ln_num_eva,
         ln_monto_ins,
         ln_suel_sol,
         ln_suel_dol,
         ln_suel_bru,
         ln_suel_cal,
         ln_val,
         ln_val_limite,
         ln_tip_cam,
         TRIM(pc_Flag),
         'G',
         NULL,
         NULL,
         ld_fecha_sys,
         lc_hora);
      commit;
    exception
      when others then
        my_errm    := SQLERRM;
        DBMS_OUTPUT.put_line(my_errm);
        null;
    end;

  END sp_vali_Sueldo_CSP;

  ------------------------------------------------------
  PROCEDURE sp_sueldo(pn_instancia    in number,
                      pn_sueldo_soles out number,
                      pn_sueldo_dolar out number,
                      pn_sueldo_total out number) IS
    ln_num_eva    number;
    ln_tip_cam    number;
    ld_fecha_sys  date;
    my_errm       varchar2(32000);
  BEGIN
    -- fecha del sistema
    begin
      select f.pgfape
        into ld_fecha_sys
        from fst017 f 
       where f.pgcod = 1;
    exception
      when others then
        my_errm    := SQLERRM;
        DBMS_OUTPUT.put_line(my_errm);
    end;
    
    -- numero de evaluacion
    begin
      select s21.sng021eval
        into ln_num_eva
        from sng021 s21
       where s21.sng021sol = pn_instancia;
    exception
      when others then
        ln_num_eva := 0;
    end;
    
    -- tipo de cambio
    begin
      select s120.sng120tcbi
        into ln_tip_cam
        from sng120 s120
       where s120.sng120tsk = 'EVALUACION'
         and s120.sng120ins = pn_instancia;
      ln_tip_cam := nvl(ln_tip_cam, 0);
    exception
      when others then
        ln_tip_cam := 0;
    end;
   
    if ln_tip_cam = 0 then 
      begin
        ln_tip_cam := fn_tipo_cambio_fijo(P_FECHA => ld_fecha_sys);
      exception
        when others then
          ln_tip_cam := 1;
      end;
    end if;
    
    --sueldo -- concepto 1 (S/.)    
    begin
      select s23.sng023mto 
      into pn_sueldo_soles
      from SNG023 s23
      where s23.sng026cod in (1) and s23.sng021eval = ln_num_eva;

    exception
      when others then
        pn_sueldo_soles := 0;
    end;

    --sueldo -- concepto 501 ($.)
    begin
      select s23.sng023mto
      into pn_sueldo_dolar
      from SNG023 s23
      where s23.sng026cod in (501) and s23.sng021eval = ln_num_eva;
    exception
      when others then
        pn_sueldo_dolar := 1;
    end;
    
    --sueldo -- concepto 501 ($.)
    begin
      pn_sueldo_total := pn_sueldo_soles + (pn_sueldo_dolar * ln_tip_cam);
    exception
      when others then
        pn_sueldo_total := 0;
    end;
    
  END sp_sueldo;

end pq_cr_vali_SueldoB;
/

