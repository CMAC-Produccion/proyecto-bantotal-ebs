create or replace package PQ_AR_CONTADORES is

  -- Sistema : BANTOTAL 
  -- Modulo : Reportes
  -- Version : 1.0
  -- Author  : Hernan Laqui
  -- Created : 
  -- Purpose : Contadores ATMs
  -- Estado : Diseño
  -- Autor Modificacion:   FRANK PINTO
  -- Fecha Modificacion:  28/10/2021 08:59:18
  -- Descripcion Modificacion:  Paquete que obtiene retiros despues de contadores
  -- Autor Modificacion:   FRANK PINTO
  -- Fecha Modificacion:  18/01/2023
  -- Descripcion Modificacion:  Se añade contadores de monedas.

  Procedure sp_procesar(P_D_FECHA  IN DATE,
                        P_N_UNIT   IN NUMBER,
                        P_C_CODERR OUT VARCHAR2,
                        P_C_MSGERR OUT VARCHAR2);
                        
  procedure sp_obtener_transacciones(p_d_atm number, 
                                     p_d_hora varchar2,
                                     pc_moneda number,
                                     pc_retiros out number); 
end PQ_AR_CONTADORES;
/

create or replace package body PQ_AR_CONTADORES is

  Procedure sp_procesar(P_D_FECHA  IN DATE,
                        P_N_UNIT   IN NUMBER,
                        P_C_CODERR OUT VARCHAR2,
                        P_C_MSGERR OUT VARCHAR2) is
    cursor c1 is
      select x.unit, x.cnt_date, x.cnt_time
        from (select unit,
                     cnt_date,
                     cnt_time,
                     row_number() over(partition by unit, cnt_date order by cnt_time desc) orden
                from jaql351
               where cnt_date = P_D_FECHA
                 and (unit = P_N_UNIT or P_N_UNIT = 0)) x
       where x.orden = 1;
  
    cursor c2(punit number, pdate date, ptime number) is
      select unit,
             cnt_date,
             cnt_time,
             case
               when currency = 604 then
                0
               else
                101
             end currency,
             denom,
             sum(remain) remain,
             sum(dispen) dispen,
             sum(rejectt) rejectt,
             sum(total) total,
             timon
        from (select unit,
                     cnt_date,
                     cnt_time,
                     currency1 currency,
                     denom1    denom,
                     remain1   remain,
                     dispen1   dispen,
                     reject1   rejectt,
                     total1    total,
                     'B' timon
                from jaql351
               where unit = punit
                 and cnt_date = pdate
                 and cnt_time = ptime
              union all
              select unit,
                     cnt_date,
                     cnt_time,
                     currency2,
                     denom2,
                     remain2,
                     dispen2,
                     reject2,
                     total2,
                     'B'
                from jaql351
               where unit = punit
                 and cnt_date = pdate
                 and cnt_time = ptime
              union all
              select unit,
                     cnt_date,
                     cnt_time,
                     currency3,
                     denom3,
                     remain3,
                     dispen3,
                     reject3,
                     total3,
                     'B'
                from jaql351
               where unit = punit
                 and cnt_date = pdate
                 and cnt_time = ptime
              union all
              select unit,
                     cnt_date,
                     cnt_time,
                     currency4,
                     denom4,
                     remain4,
                     dispen4,
                     reject4,
                     total4,
                     'B'
                from jaql351
               where unit = punit
                 and cnt_date = pdate
                 and cnt_time = ptime
              union all -- 10 soles Lonchera 1
              select unit,
                     cnt_date,
                     cnt_time,
                     DP0_CURR1,
                     DP0_DENOM1,
                     DP0_NOTES1,
                     0,
                     0,
                     0,
                     'B'
                from jaql351
               where unit = punit
                 and cnt_date = pdate
                 and cnt_time = ptime
              union all -- 20 soles Lonchera 1
              select unit,
                     cnt_date,
                     cnt_time,
                     DP0_CURR1,
                     DP0_DENOM2,
                     DP0_NOTES2,
                     0,
                     0,
                     0,
                     'B'
                from jaql351
               where unit = punit
                 and cnt_date = pdate
                 and cnt_time = ptime
              union all -- 50 soles
              select unit,
                     cnt_date,
                     cnt_time,
                     DP0_CURR1,
                     DP0_DENOM3,
                     DP0_NOTES3,
                     0,
                     0,
                     0,
                     'B'
                from jaql351
               where unit = punit
                 and cnt_date = pdate
                 and cnt_time = ptime
              union all -- 100 soles
              select unit,
                     cnt_date,
                     cnt_time,
                     DP0_CURR1,
                     DP0_DENOM4,
                     DP0_NOTES4,
                     0,
                     0,
                     0,
                     'B'
                from jaql351
               where unit = punit
                 and cnt_date = pdate
                 and cnt_time = ptime
              union all -- 200 soles
              select unit,
                     cnt_date,
                     cnt_time,
                     DP0_CURR1,
                     DP0_DENOM5,
                     DP0_NOTES5,
                     0,
                     0,
                     0,
                     'B'
                from jaql351
               where unit = punit
                 and cnt_date = pdate
                 and cnt_time = ptime
              union all -- 10 soles Lonchera 2
              select unit,
                     cnt_date,
                     cnt_time,
                     DP1_CURR1,
                     DP1_DENOM1,
                     DP1_NOTES1,
                     0,
                     0,
                     0,
                     'B'
                from jaql351
               where unit = punit
                 and cnt_date = pdate
                 and cnt_time = ptime
              union all -- 20 soles Lonchera 2
              select unit,
                     cnt_date,
                     cnt_time,
                     DP1_CURR1,
                     DP1_DENOM2,
                     DP1_NOTES2,
                     0,
                     0,
                     0,
                     'B'
                from jaql351
               where unit = punit
                 and cnt_date = pdate
                 and cnt_time = ptime
              union all -- 50 soles
              select unit,
                     cnt_date,
                     cnt_time,
                     DP1_CURR1,
                     DP1_DENOM3,
                     DP1_NOTES3,
                     0,
                     0,
                     0,
                     'B'
                from jaql351
               where unit = punit
                 and cnt_date = pdate
                 and cnt_time = ptime
              union all -- 100 soles
              select unit,
                     cnt_date,
                     cnt_time,
                     DP1_CURR1,
                     DP1_DENOM4,
                     DP1_NOTES4,
                     0,
                     0,
                     0,
                     'B'
                from jaql351
               where unit = punit
                 and cnt_date = pdate
                 and cnt_time = ptime
               union all --moneda 1
               select unit,
                      cnt_date,
                      cnt_time,
                      COIN_CUR1,
                      COIN_DEN1/100,
                      COIN_REM1,
                      COIN_DIS1,
                      COIN_REJ1,
                      COIN_TOT1,
                      'M'
                from jaql351
                where unit = punit
                 and cnt_date = pdate
                 and cnt_time = ptime
               union all --moneda 2
               select unit,
                      cnt_date,
                      cnt_time,
                      COIN_CUR2,
                      COIN_DEN2/100,
                      COIN_REM2,
                      COIN_DIS2,
                      COIN_REJ2,
                      COIN_TOT2,
                      'M'
                from jaql351
                where unit = punit
                 and cnt_date = pdate
                 and cnt_time = ptime
               union all --moneda 3
               select unit,
                      cnt_date,
                      cnt_time,
                      COIN_CUR3,
                      COIN_DEN3/100,
                      COIN_REM3,
                      COIN_DIS3,
                      COIN_REJ3,
                      COIN_TOT3,
                      'M'
                from jaql351
                where unit = punit
                 and cnt_date = pdate
                 and cnt_time = ptime
               union all --moneda 4
               select unit,
                      cnt_date,
                      cnt_time,
                      COIN_CUR4,
                      COIN_DEN4/100,
                      COIN_REM4,
                      COIN_DIS4,
                      COIN_REJ4,
                      COIN_TOT4,
                      'M'
                from jaql351
                where unit = punit
                 and cnt_date = pdate
                 and cnt_time = ptime) x
       group by unit, cnt_date, cnt_time, currency, denom, timon;
  
    ln_unit number;
    ld_date date;
    ln_time number;
  begin
    P_C_CODERR := '0000';
    P_C_MSGERR := 'Proceso Correcto';
  
    for j in c1 loop
      ln_unit := j.unit;
      ld_date := j.cnt_date;
      ln_time := j.cnt_time;
      for i in c2(ln_unit, ld_date, ln_time) loop
        Case 
          when (i.timon='B') then
            update jaql504
               set jaql504canti = i.remain + i.rejectt
             where JAQL504COUSU = ln_unit
               and JAQL504FEPRO = ld_date
               and JAQL504TIMON = i.timon
               and JAQL504DENOM = i.denom
               and JAQL504COMON = i.currency
               and JAQL504PGCOD = 1
               and JAQL504COOFI = 1;
          when (i.timon='M') then
             update jaql504
               set jaql504canti = i.remain + i.rejectt
             where JAQL504COUSU = ln_unit
               and JAQL504FEPRO = ld_date
               and JAQL504TIMON = i.timon
               and JAQL504DENOM = i.denom*100
               and JAQL504COMON = i.currency
               and JAQL504PGCOD = 1
               and JAQL504COOFI = 1;           
         End case
         commit;
      End Loop;
    End Loop;
    commit;
    

    commit;    
  
  end sp_procesar;

  procedure sp_obtener_transacciones(p_d_atm number, 
                                   p_d_hora varchar2, 
                                   pc_moneda number, 
                                   pc_retiros out number) is 

     begin
            
          select sum(ITIMP1) into pc_retiros from fsd016 a, fsd015 b
          where a.pgcod=1 
          and a.itmod=66 
          and a.MODULO=23 
          and a.ITDBHA=2 
          and a.ITSUBO=p_d_atm 
          and a.pgcod=b.pgcod 
          and a.itsuc=b.itsuc 
          and a.itmod=b.itmod 
          and a.ittran=b.ittran 
          and a.itnrel=b.itnrel 
          and ITCORR=0 
          and ITHORA>=p_d_hora
          and MONEDA= pc_moneda;
  
          
end sp_obtener_transacciones;

end PQ_AR_CONTADORES;
/

