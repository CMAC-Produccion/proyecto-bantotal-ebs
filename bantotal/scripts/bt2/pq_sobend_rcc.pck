create or replace package PQ_SOBEND_RCC is

  -- Author  : PVARGAS
  -- Created : 30/04/2016 10:30:26 a.m.
  -- Purpose : Cálculo de variables en base a datos del sistema financiero
  
  -- Modificaciones:
  -- Fecha  : 07/03/2017 10:25 am
  -- Autor  : PVARGAS
  -- Cambios: 
  -- Fecha  : 09/05/2017 11:43 am
  -- Autor  : DRODRIGUEE
  -- Cambios: Requerimiento 4388
  -- Fecha  : 05/2018
  -- Autor  : DRODRIGUEE
  -- Cambios: Requerimiento 1110
  
  Procedure SP_CREA_BASE;
  Function FN_FECHA_RCC Return date;
  Procedure SP_JOB_DATOS_VARIABLES (PD_FECHA in date);
  Procedure SP_DATOS_VARIABLES (PN_CTAINI in number,PN_CTAFIN in number,PC_FECHA in varchar2);
  Procedure SP_SALDO_MAXIMO(PN_INI in number,PN_FIN in number,PV_FECHA in varchar2);
  Procedure SP_JOB_SALDO_MAXIMO (PD_FECHA in date);
  Procedure SP_SALDOS (PN_INI in number,PN_FIN in number,
                       PN_MES in number,PC_FECHA in varchar2);
                       Procedure SP_JOB_SALDOS (PD_FECHA in date, PN_MES in number); 
  Procedure SP_VALOR_VARIABLE(PN_INI in number, PN_FIN in number, PV_FECHA in varchar2);                     
  Procedure SP_JOB_VALOR_VARIABLE (PD_FECHA in date);
  Procedure SP_RETORNA_VARIABLES(PN_CODSEG in Number,
                                 PN_TIPDOC in Number,
                                 PV_NUMDOC in varchar2,
                                 PN_CUOPOT out Number, --Cuota Potencial
                                 PN_LINTAR out Number, --Linea de líneas en tarjetas crédito
                                 PN_MONLTC out Number, --Monto líneas TC
                                 PN_VARSDE out Number, --Variación saldo deudor
                                 PN_VARNEN out Number, --Variacion Nro entidades
                                 PN_NUMENS out Number, --Nro entidad saldo > X
                                 PN_DEUTOT out Number, --Deuda total
                                 PN_CUOOCO out Number  --Cuota otros convenios
                                );
                                
  Procedure SP_ACTUALIZA_VARIABLES(PN_TIPDOC in Number,
                                   PV_NUMDOC in varchar2,
                                   PN_CUOPOT in Number,
                                   PN_CUOSFI in Number
                                  ); 
                                  
  Procedure SP_VERIFICA_ESTADO(PN_TIPDOC in Number,
                               PV_NUMDOC in varchar2,
                               PN_ESTACT out Char                                                                   
                              );                                                                 
                                
  Procedure SP_RETORNA_VARIABLES_SEG(PN_CODSEG in Number,
                                 PN_TIPDOC in Number,
                                 PV_NUMDOC in varchar2,
                                 PN_CUOPOT out Number, --Cuota Potencial
                                 PN_LINTAR out Number, --Linea de líneas en tarjetas crédito
                                 PN_MONLTC out Number, --Monto líneas TC
                                 PN_VARSDE out Number, --Variación saldo deudor
                                 PN_VARNEN out Number, --Variacion Nro entidades
                                 PN_NUMENS out Number, --Nro entidad saldo > X
                                 PN_DEUTOT out Number, --Deuda total
                                 PN_CUOOCO out Number,  --Cuota otros convenios
                                 PN_NUMENT out Number, --Nro. de entidades
                                 PN_CUOSIF out Number, --Cuota sistema financiero
                                 PN_SALDEU out Number,
                                 PN_SUT out Number,
                                 PN_SUN out Number,                                 
                                 PN_LCN out Number,
                                 PN_LTN out Number,
                                 PN_PMR out Number,
                                 PN_LTP out Number,
                                 PN_LNP out Number,                                                                                                   
                                 PV_CODSBS out Varchar2,
                                 PD_FECRCC out Date
                                );                                
   
end PQ_SOBEND_RCC;
/

create or replace package body PQ_SOBEND_RCC is
  -- modificacion rmontes: se agrego rubro 0303 en lineas 180,183,184,187,196
  ----------------------------------------------------------------------------------------------
  Procedure SP_CREA_BASE
  Is 
    ld_fecrcc date;
    ln_existe number(1);
  Begin
    ld_fecrcc := PQ_SOBEND_RCC.FN_FECHA_RCC;
    
    execute immediate 'truncate table jaqy490';
    -- Busca Indice
    select count(*) into ln_existe from user_indexes where index_name ='IX_JAQY490_1';
    If ln_existe > 0 Then
       Execute Immediate 'drop index ix_jaqy490_1';
    End If;
    
    Insert into JAQY490(Jaqy490nre,Jaqy490fec,Jaqy490sbs,Jaqy490tdi,Jaqy490ndi,Jaqy490tdt,Jaqy490ndt,Jaqy490per,Jaqy490nen)
    Select rownum,x.*
      From (
            Select distinct x.d_fecpre,x.c_codsbs,x.c_tdocid,x.c_docide,x.c_tdoctr,x.c_doctri,x.c_person,x.n_canent
              from cldrcci x
              join cldrccs z on z.d_fecpre = x.d_fecpre and z.c_codsbs = x.c_codsbs
             Where x.d_fecpre = ld_fecrcc
               and (z.c_cuenta like '14%' or z.c_cuenta like '7%')
           ) x;
    
    Commit;  --2min     
    execute immediate 'Create index ix_jaqy490_1 On JAQY490(JAQY490nre,JAQY490fec) tablespace bantprod_C_idx';
    -- Activar y desactivar índice
    pq_sobend_rcc.SP_JOB_DATOS_VARIABLES(ld_fecrcc);
  End SP_CREA_BASE; 
  ----------------------------------------------------------------------------------------------
  Function FN_FECHA_RCC
  Return date
  Is
    ld_FecRcc date;
  Begin
        Select max(d_FecPre)
          Into ld_FecRcc
          From cldrcci;
        --Return add_months(ld_FecRcc,-1);  
        Return ld_FecRcc;
  End FN_FECHA_RCC;    
  ----------------------------------------------------------------------------------------------
  Procedure SP_JOB_DATOS_VARIABLES (PD_FECHA in date)
  IS
     x        number(10) := 0;
     ln_max   number(10);
     ln_rango number(10);
     ln_ini   number(10);
     ln_fin   number(10);
     ln_job   number(10) := 0;
     lv_query varchar2(100);
     lv_fecha varchar2(10) := to_char(PD_FECHA,'rrrrmmdd');
     ln_nrojob number(10);
     lc_hostname varchar2(64);     
  Begin 
       Begin 
            Select max(jaqy490nre),trunc(max(jaqy490nre)/250)   
              Into ln_max,ln_rango
              From jaqy490
             Where jaqy490fec = PD_FECHA;
       Exception When Others then
                  ln_max := 0;
                  ln_rango:=0;
       End; 
       
       -- Verifica que no exceda el limite de jobs
       Loop 
           select count(*) 
             into ln_nrojob
             from DBA_SCHEDULER_JOBS 
            where owner = 'BANTPROD'
              and job_name like 'JAQY490%'; 
       Exit when ln_nrojob = 0;
       End Loop;
        
       x:=0;
       While x <= ln_max Loop
             ln_ini := x+1;
             x:= x+ ln_rango;
             ln_fin := x;
             lv_query := ' begin '||'   PQ_SOBEND_RCC.SP_DATOS_VARIABLES('||ln_ini||','||ln_fin ||',' || lv_fecha || ');'|| ' End; ';
             
             ln_job := ln_job +1;
              
             dbms_scheduler.create_job(job_name=> 'JAQY490_VAR_'||LPAD(TO_CHAR(ln_job),5,'0'),
                                       job_type=> 'PLSQL_BLOCK',
                                       job_action=> lv_query,
                                       start_date => sysdate+1/(24*180),
                                       enabled => true, 
                                       auto_drop=> TRUE,
                                       comments => 'JAQY490'
                                      );

             if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101') then      
               begin        
                 dbms_scheduler.set_attribute('JAQY490_VAR_'||LPAD(TO_CHAR(ln_job),5,'0'),'instance_id',2);
               end; 
             else
               begin
                 dbms_scheduler.set_attribute('JAQY490_VAR_'||LPAD(TO_CHAR(ln_job),5,'0'),'instance_id',1);
               end; 
               end if;                                      
                                      
             commit;
       End Loop;   
       
       -- Verifica que no exceda el limite de jobs
       ln_nrojob:=0;
       Loop 
           select count(*) 
             into ln_nrojob
             from DBA_SCHEDULER_JOBS 
            where owner = 'BANTPROD'
              and job_name like 'JAQY490_VAR_%'; 
       Exit when ln_nrojob = 0;
       End Loop;
       pq_sobend_rcc.sp_job_saldos(PD_FECHA,13);
       
  End SP_JOB_DATOS_VARIABLES;     
  ----------------------------------------------------------------------------------------------
  Procedure SP_DATOS_VARIABLES (PN_CTAINI in number,PN_CTAFIN in number,PC_FECHA in varchar2)
  Is
    Cursor c_datrcc (pd_fecha in date)
        Is Select * 
             from jaqy490 
             where jaqy490fec = pd_fecha 
               and jaqy490nre between PN_CTAINI and PN_CTAFIN;
              
    ld_fecha date := to_date(PC_FECHA,'rrrrmmdd');
    
    ln_numreg number(10) := 0;
    ln_deutot number(12,2);  
    ln_tarnut number(12,2);
    ln_litpre number(12,2);
    ln_linpre number(12,2);
    ln_deucon number(12,2); 
    ln_utitar number(12,2);  
    ln_conveh number(12,2);
    ln_connre number(12,2);
    ln_concon number(12,2);
    ln_crehip number(12,2);
    ln_crepym number(12,2);
    ln_conava number(12,2);
    ln_enthis number(10);
    ln_entsal number(10);
    ln_utitnc number(12,2);
    ln_tarnnc number(12,2);
    ln_cconnc number(12,2);
    ln_salent number(10);
    ln_crepmr number(12,2); --p1864
    ln_cuocon number(12,2);
    
  Begin
    -- Valor de saldo para Variable N° Entidades con saldo mayora a S/.X
    Begin
        Select nvl(tp1imp1,0) Into ln_salent
          From fst198 
         Where tp1cod=1 
           and tp1cod1=11000 
           and tp1corr1=6 
           and tp1corr2=0  
           and tp1corr3=0;
    Exception When Others Then
       ln_salent := 0;
    End;       
  
     For x in c_datrcc(ld_fecha) Loop
        
        -- Importes para variables
        Begin
          select sum(case when c_cuenta like '14_1%' or c_cuenta like '14_4%' or c_cuenta like '14_5%' or c_cuenta like '14_6%' or c_cuenta like '14_8%' then n_salcap else 0 end) deutot, 
                 sum(case when c_cuenta like '72_506%' then n_salcap end) LinTcre,
                 sum(case when c_cuenta like '71_503%' then n_salcap end) LitPcre,
                 sum(case when c_cuenta like '72_503%' then n_salcap end) LinPcre, 
                 sum(case when substr(c_cuenta,1,4) in ('7111','7112','7113','7114','7121','7122','7123','7124') then n_salcap end) DeuCon,  
                 sum(case when c_cuenta like '14__0302%'  then n_salcap end) UtiTar,
                 sum(case when (c_cuenta like '14__030611%' or c_cuenta like '14__030612%' or c_cuenta like '14__030311%' or c_cuenta like '14__030312%' ) then n_salcap end) ConCon, --se agrego rubro 0303

                 sum(case when (c_codemp <> '00104' and 
                               (c_cuenta like '14__0306%' or c_cuenta like '14__0303%' ) and --se agrego rubro 0303
                               (c_cuenta not like '14__030611%' and c_cuenta not like '14__030612%' and c_cuenta not like '14__030602%'--se agrego rubro 0303
                               and c_cuenta not like '14__030311%' and c_cuenta not like '14__030312%' and c_cuenta not like '14__030302%'))
                          then n_salcap end) ConNre,                                                        
                 sum(case when c_codemp <> '00104' and (c_cuenta like '14__030602%' or c_cuenta like '14__030302%') then n_salcap else 0 end) ConVeh,--se agrego rubro 0303
                 sum(case when c_codemp <> '00104' and c_cuenta like '14__04%'  then n_salcap else 0 end) CreHip,  
                 sum(case when c_codemp <> '00104' 
                               and (c_cuenta like '14__12%' or c_cuenta like '14__02%' or c_cuenta like '14__13%') 
                               and (c_cuenta not like '14__020601%' and c_cuenta not like '14__029901%' and c_cuenta not like '14__0202%' and c_cuenta not like '14__130601%' and c_cuenta not like '14__1302%') --p1864
                          then n_salcap else 0 end) CrePym,  
                 sum(case when c_codemp <> '00104' and (c_cuenta like '71_1%' or c_cuenta like '71_2%' or c_cuenta like '71_3%' or c_cuenta like '71_4%') then n_salcap else 0 end) ConAva,
                 sum(case when c_codemp <> '00104' and c_cuenta like '14__0302%'  then n_salcap else 0 end) UtiTar_NC,
                 sum(case when c_codemp <> '00104' and c_cuenta like '72_506%' then n_salcap else 0end) LinTcreNC,
                 sum(case when c_codemp <> '00104' and (c_cuenta like '14__030611%' or c_cuenta like '14__030612%' or c_cuenta like '14__030311%' or c_cuenta like '14__030312%' ) then n_salcap end) ConCon_NC,--se agrego rubro 0303
                 sum(case when c_codemp <> '00104' and (c_cuenta like '14__020601%' or c_cuenta like '14__029901%' or c_cuenta like '14__0202%' or c_cuenta like '14__130601%' or c_cuenta like '14__1302%' or c_cuenta like '14__1202%' or c_cuenta like '14__120601%') --p1864
                          then n_salcap else 0 end) CrePmr             
            Into ln_deutot, ln_tarnut, ln_litpre, ln_linpre, ln_deucon, ln_utitar,
                 ln_concon, ln_connre, ln_conveh, ln_crehip, 
                 ln_crepym, ln_conava, ln_utitnc, ln_tarnnc,
                 ln_cconnc, ln_crepmr
            From cldrccs b
           where d_fecpre = ld_fecha
             and c_codsbs = x.jaqy490sbs 
             and (c_cuenta not like '14_7%' and c_cuenta not like '14_8%' and c_cuenta not like '14_9%' and c_cuenta not like '14_0%');
              
             --- N° Entidades histórico
             Select max(n_canent)
               Into ln_enthis
               From cldrcci
              Where d_fecpre = add_months(ld_fecha,-6)
                and c_codsbs = x.jaqy490sbs; 
                        
             --- N° Entidades por saldo
             Select count(distinct c_codemp)
               Into ln_entsal
               From cldrccs 
              Where c_codsbs = x.jaqy490sbs  
                and d_fecpre = ld_fecha
                and c_cuenta like '14%'
                and c_cuenta not like '14_9%'
                and n_salcap > ln_salent;
                
             ln_cuocon := ln_conava*0.0017;
                
        Exception When Others Then
              ln_deutot := null; 
        End;   
       
        Update jaqy490 
            Set jaqy490std = ln_deutot, 
                jaqy490lcn = ln_tarnut,
                jaqy490dco = ln_deucon,
                jaqy490sut = ln_utitar,
                jaqy490ven = ln_entsal,
                jaqy490neh = ln_enthis,
                jaqy490cvh = ln_conveh, 
                jaqy490cnr = ln_connre,
                jaqy490cco = ln_concon,
                jaqy490hip = ln_crehip, 
                jaqy490pym = ln_crepym,
                jaqy490cav = ln_conava,
                jaqy490ltn = ln_tarnnc,
                jaqy490sun = ln_utitnc,
                jaqy490con = ln_cconnc,
                jaqy490pmr = ln_crepmr,--p1864
                jaqy490cuc = ln_cuocon,
                jaqy490lpr = ln_litpre,
                jaqy490lnp = ln_linpre,
                jaqy490tac = 'V'
          Where jaqy490nre = x.jaqy490nre
            and jaqy490fec = ld_fecha; 
         
         commit;
         ln_numreg := ln_numreg + 1;
         If Mod(ln_numreg,1000) = 0 Then
            Commit;
            ln_numreg := 0;
         End If;   
               
     End Loop;  
     Commit;
  End SP_DATOS_VARIABLES;
  ----------------------------------------------------------------------------------------------  
  Procedure SP_SALDO_MAXIMO(PN_INI in number,
                            PN_FIN in number,
                            PV_FECHA in varchar2
                           )
  IS
     Cursor c_salmax (pd_fecha in date)
        Is Select jaqy490nre,jaqy490sd1,jaqy490sd2,jaqy490sd3,jaqy490sd4,jaqy490sd5,jaqy490sd6,
                  jaqy490sd7,jaqy490sd8,jaqy490sd9,jaqy490s10,jaqy490s11,jaqy490s12,jaqy490s13 
             from jaqy490 
             where jaqy490fec = pd_fecha 
               and jaqy490nre between PN_INI and PN_FIN;
               
      pd_fecha date := to_date(PV_FECHA,'rrrrmmdd');
      ln_maxsal number(12,2); 
      
  Begin
       For x in c_salmax(pd_fecha) Loop
           ln_maxsal := 0;
           If nvl(x.jaqy490sd1,0) > ln_maxsal Then
              ln_maxsal:= nvl(x.jaqy490sd1,0);
           End If; 
           If nvl(x.jaqy490sd2,0) > ln_maxsal Then
              ln_maxsal:= nvl(x.jaqy490sd2,0);
           End If; 
           If nvl(x.jaqy490sd3,0) > ln_maxsal Then
              ln_maxsal:= nvl(x.jaqy490sd3,0);
           End If; 
           If nvl(x.jaqy490sd4,0) > ln_maxsal Then
              ln_maxsal:= nvl(x.jaqy490sd4,0);
           End If; 
           If nvl(x.jaqy490sd5,0) > ln_maxsal Then
              ln_maxsal:= nvl(x.jaqy490sd5,0);
           End If; 
           If nvl(x.jaqy490sd6,0) > ln_maxsal Then
              ln_maxsal:= nvl(x.jaqy490sd6,0);
           End If; 
           If nvl(x.jaqy490sd7,0) > ln_maxsal Then
              ln_maxsal:= nvl(x.jaqy490sd7,0);
           End If; 
           If nvl(x.jaqy490sd8,0) > ln_maxsal Then
              ln_maxsal:= nvl(x.jaqy490sd8,0);
           End If; 
           If nvl(x.jaqy490sd9,0) > ln_maxsal Then
              ln_maxsal:= nvl(x.jaqy490sd9,0);
           End If; 
           If nvl(x.jaqy490s10,0) > ln_maxsal Then
              ln_maxsal:= nvl(x.jaqy490s10,0);
           End If; 
           If nvl(x.jaqy490s11,0) > ln_maxsal Then
              ln_maxsal:= nvl(x.jaqy490s11,0);
           End If; 
           If nvl(x.jaqy490s12,0) > ln_maxsal Then
              ln_maxsal:= nvl(x.jaqy490s12,0);
           End If; 
           If nvl(x.jaqy490s13,0) > ln_maxsal Then
              ln_maxsal:= nvl(x.jaqy490s13,0);
           End If;  
           
           Update jaqy490
              Set jaqy490msd = nvl(ln_maxsal,0)
            Where jaqy490fec = pd_Fecha
              and jaqy490nre = x.jaqy490nre;
           
           Commit;
                
       End Loop;
  End SP_SALDO_MAXIMO;                             
  ----------------------------------------------------------------------------------------------
  Procedure SP_JOB_SALDO_MAXIMO (PD_FECHA in date)
  IS
     x        number(10) := 0;
     ln_max   number(10);
     ln_rango number(10);
     ln_ini   number(10);
     ln_fin   number(10);
     ln_job   number(10) := 0;
     lv_query varchar2(100);
     lv_fecha varchar2(10) := to_char(PD_FECHA,'rrrrmmdd');
     ln_nrojob number(5);
     lc_hostname varchar2(64);
  Begin 
       
       Begin 
            Select max(jaqy490nre),trunc(max(jaqy490nre)/250)   
              Into ln_max,ln_rango
              From jaqy490
             Where jaqy490fec = PD_FECHA;
       Exception When Others then
                  ln_max := 0;
                  ln_rango:=0;
       End; 
       
       -- Verifica que no exceda el limite de jobs
       Loop 
           select count(*) 
             into ln_nrojob
             from DBA_SCHEDULER_JOBS 
            where owner = 'BANTPROD'
              and job_name like 'JAQY490%'; 
       Exit when ln_nrojob = 0;
       End Loop;
             
       x:=0;
       While x <= ln_max Loop
             
             ln_ini := x+1;
             x:= x+ ln_rango;
             ln_fin := x;
             lv_query := ' begin '||'   PQ_SOBEND_RCC.SP_SALDO_MAXIMO('||ln_ini||','||ln_fin ||','||lv_fecha || ');'|| ' End; ';
             
             ln_job := ln_job +1;
              
             dbms_scheduler.create_job(job_name=> 'JAQY490_SMX_'||LPAD(TO_CHAR(ln_job),5,'0'),
                                       job_type=> 'PLSQL_BLOCK',
                                       job_action=> lv_query,
                                       start_date => sysdate+1/(24*180),
                                       enabled => true, 
                                       auto_drop=> TRUE,
                                       comments => 'JAQY490_SALDOS'
                                      );
                                      
             if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101') then      
               begin        
                 dbms_scheduler.set_attribute('JAQY490_SMX_'||LPAD(TO_CHAR(ln_job),5,'0'),'instance_id',2);
               end; 
             else
               begin
                 dbms_scheduler.set_attribute('JAQY490_SMX_'||LPAD(TO_CHAR(ln_job),5,'0'),'instance_id',1);
               end; 
             end if;
                                                     
             commit;
             
             
       end loop; 
       
       -- Verifica que no exceda el limite de jobs
       ln_nrojob:=0;
       Loop 
           select count(*) 
             into ln_nrojob
             from DBA_SCHEDULER_JOBS 
            where owner = 'BANTPROD'
              and job_name like 'JAQY490_SMX_%'; 
       Exit when ln_nrojob = 0;
       End Loop;
       pq_sobend_rcc.sp_job_valor_variable(PD_FECHA);
  
  End SP_JOB_SALDO_MAXIMO;  
  ----------------------------------------------------------------------------------------------   
  Procedure SP_SALDOS (PN_INI in number,PN_FIN in number,
                       PN_MES in number,PC_FECHA in varchar2)
  Is
    Cursor c_datrcc (pd_fecha in date)
        Is Select jaqy490sbs,jaqy490nre 
             from jaqy490 
             where jaqy490fec = pd_fecha 
               and jaqy490nre between PN_INI and PN_FIN;
              
    ld_fecha date := to_date(PC_FECHA,'rrrrmmdd');
    ld_fecrcc date := add_months(ld_fecha,-PN_MES);
    ln_salcap number(12,2);
    lv_query varchar2(100);
    ln_numreg number(5) := 0;
  Begin
        If PN_MES < 10 Then
           lv_query := 'Update jaqy490 Set jaqy490sd'||to_char(PN_MES)||'=:1 Where jaqy490nre=:2';
        Else
           lv_query := 'Update jaqy490 Set jaqy490s'||to_char(PN_MES)||'=:1 Where jaqy490nre=:2';
        End IF;  
        
     For x in c_datrcc(ld_fecha) Loop
        
        -- Importes para variables
        Begin
          select sum(n_salcap) 
            Into ln_salcap
            From cldrccs 
           where d_fecpre = ld_fecrcc
             and c_codsbs = x.jaqy490sbs 
             and c_cuenta like '14%'
             and c_cuenta not like '14_9%';
             
        Exception When Others Then
              ln_salcap := 0; 
        End;   
        
        Execute immediate lv_query Using nvl(ln_salcap,0), x.jaqy490nre;
        
        ln_numreg := ln_numreg + 1;
        If mod(ln_numreg,1000) = 0 Then
           commit;
           ln_numreg := 0;
        End If;   
     End Loop; 
     Commit; 
     
  End SP_SALDOS;
  ----------------------------------------------------------------------------------------------
  Procedure SP_JOB_SALDOS (PD_FECHA in date, PN_MES in number)
  IS
     x        number(10) := 0;
     ln_max   number(10);
     ln_rango number(10);
     ln_ini   number(10);
     ln_fin   number(10);
     ln_job   number(10) := 0;
     lv_query varchar2(100);
     lv_fecha varchar2(10) := to_char(PD_FECHA,'rrrrmmdd');
     ln_nrojob number(5);
     ln_nummes number(2);
     ln_existe number(1);
     lc_hostname varchar2(64);
  Begin 
      -- Crear Indice para actualizar saldos máximos
      Select count(*) into ln_existe from user_indexes where index_name ='IX_JAQY490_2';
      If ln_existe = 0 Then
         Execute Immediate 'create index IX_JAQY490_2 on JAQY490 (JAQY490FEC,JAQY490NRE,JAQY490MSD,JAQY490TAC) tablespace bantprod_C_idx';
      End If;
       
      Begin 
            Select max(jaqy490nre),trunc(max(jaqy490nre)/250)   
              Into ln_max,ln_rango
              From jaqy490
             Where jaqy490fec = PD_FECHA;
       Exception When Others then
                  ln_max := 0;
                  ln_rango:=0;
       End; 
       
     ln_nummes := 0; 
     While ln_nummes <= PN_MES Loop
       -- Verifica que no exceda el limite de jobs
       Loop 
           select count(*) 
             into ln_nrojob
             from DBA_SCHEDULER_JOBS
            Where owner = 'BANTPROD'
              and job_name like 'JAQY490%'; 
       Exit when ln_nrojob <= 260;
       End Loop;
             
       x:=0;
       While x <= ln_max Loop
             ln_ini := x+1;
             x:= x+ ln_rango;
             ln_fin := x;
             lv_query := ' begin '||'   PQ_SOBEND_RCC.SP_SALDOS('||ln_ini||','||ln_fin ||','||ln_nummes ||',' || lv_fecha || ');'|| ' End; ';
             
             ln_job := ln_job +1;
              
             dbms_scheduler.create_job(job_name=> 'JAQY490_SDO_'||LPAD(TO_CHAR(ln_job+ln_nummes),5,'0'),
                                       job_type=> 'PLSQL_BLOCK',
                                       job_action=> lv_query,
                                       start_date => sysdate+1/(24*180),
                                       enabled => true, 
                                       auto_drop=> TRUE,
                                       comments => 'JAQY490_SALDOS'
                                      );
                                      
             if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101') then      
               begin        
                 dbms_scheduler.set_attribute('JAQY490_SDO_'||LPAD(TO_CHAR(ln_job+ln_nummes),5,'0'),'instance_id',2);
               end; 
             else
               begin
                 dbms_scheduler.set_attribute('JAQY490_SDO_'||LPAD(TO_CHAR(ln_job+ln_nummes),5,'0'),'instance_id',1);
               end; 
             end if;             
                         
             commit;
             
             -- Verifica que no exceda el limiete de jobs
             Loop 
                 select count(*) 
                   into ln_nrojob
                   from DBA_SCHEDULER_JOBS
                  where Owner = 'BANTPROD'
                    and job_name like 'JAQY490%'; 
             Exit when ln_nrojob <= 260;
             End Loop;
          end loop;
          ln_nummes := ln_nummes + 1;      
       End Loop;
       
       -- Verifica que no exceda el limite de jobs
       ln_nrojob:=0;
       Loop 
           select count(*) 
             into ln_nrojob
             from DBA_SCHEDULER_JOBS 
            where owner = 'BANTPROD'
              and job_name like 'JAQY490_SDO_%'; 
       Exit when ln_nrojob = 0;
       End Loop;
       pq_sobend_rcc.SP_JOB_SALDO_MAXIMO(PD_FECHA);
  
  End SP_JOB_SALDOS;     
  ----------------------------------------------------------------------------------------------
  Procedure SP_JOB_VALOR_VARIABLE (PD_FECHA in date)
  IS
     x        number(10) := 0;
     ln_max   number(10);
     ln_rango number(10);
     ln_ini   number(10);
     ln_fin   number(10);
     ln_job   number(10) := 0;
     lv_query varchar2(100);
     lv_fecha varchar2(10) := to_char(PD_FECHA,'rrrrmmdd');
     ln_nrojob number(10);
     ln_existe number(1); 
     lc_hostname varchar2(64);     
  Begin 
       Begin 
            Select max(jaqy490nre),trunc(max(jaqy490nre)/250)   
              Into ln_max,ln_rango
              From jaqy490
             Where jaqy490fec = PD_FECHA;
       Exception When Others then
                  ln_max := 0;
                  ln_rango:=0;
       End; 
       
     
       x:=0;
       While x <= ln_max Loop
             -- Verifica que no exceda el limite de jobs
             Loop 
                 select count(*) 
                   into ln_nrojob
                   from DBA_SCHEDULER_JOBS
                  Where Owner = 'BANTPROD'
                    and job_name like 'JAQY490%'; 
             Exit when ln_nrojob <= 260;
             End Loop;
             
             ln_ini := x+1;
             x:= x+ ln_rango;
             ln_fin := x;
             lv_query := ' begin '||'   PQ_SOBEND_RCC.SP_VALOR_VARIABLE('||ln_ini||','||ln_fin ||','|| lv_fecha || ');'|| ' End; ';
             
             ln_job := ln_job +1;
              
             dbms_scheduler.create_job(job_name=> 'JAQY490_VAR_'||LPAD(TO_CHAR(ln_job),5,'0'),
                                       job_type=> 'PLSQL_BLOCK',
                                       job_action=> lv_query,
                                       start_date => sysdate+1/(24*180),
                                       enabled => true, 
                                       auto_drop=> TRUE,
                                       comments => 'JAQY490_SALDOS'
                                      );
                                      
             if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101') then      
               begin        
                 dbms_scheduler.set_attribute('JAQY490_VAR_'||LPAD(TO_CHAR(ln_job),5,'0'),'instance_id',2);
               end; 
             else
               begin
                 dbms_scheduler.set_attribute('JAQY490_VAR_'||LPAD(TO_CHAR(ln_job),5,'0'),'instance_id',1);
               end; 
             end if;
                                                     
             commit;
        End Loop;
        
        -- Crea índice para consultas
        Loop 
           select count(*) 
             into ln_nrojob
             from DBA_SCHEDULER_JOBS
            where owner = 'BANTPROD'
              and Job_Name Like 'JAQY490%'; 
        Exit when ln_nrojob = 0;
        End Loop;
        
        -- Crear Indices para consultas
        Select count(*) into ln_existe from user_indexes where index_name ='IX_JAQY490_3';
        If ln_existe = 0 Then
           Execute Immediate 'create index IX_JAQY490_3 on JAQY490 (JAQY490NDI) tablespace bantprod_C_idx';
        End If;
        
        Select count(*) into ln_existe from user_indexes where index_name ='IX_JAQY490_4';
        If ln_existe = 0 Then
           Execute Immediate 'create index IX_JAQY490_4 on JAQY490 (JAQY490NDT) tablespace bantprod_C_idx';
        End If;
        
        Select count(*) into ln_existe from user_indexes where index_name ='IX_JAQY490_5';
        If ln_existe = 0 Then
           Execute Immediate 'create index IX_JAQY490_5 on JAQY490 (JAQY490FEC,JAQY490SBS) tablespace bantprod_C_idx';
        End If;
        
        -- Estadísticas de tabla

        Begin
           dbms_stats.gather_table_stats(ownname => 'BANTPROD' ,
                                         tabname => 'JAQY490',
                                         estimate_percent =>10 ,
                                         degree => 4,
                                         cascade =>true 
                                        );
        End; 
  
        
        
  End SP_JOB_VALOR_VARIABLE;    
  ----------------------------------------------------------------------------------------------
  Procedure SP_RETORNA_VARIABLES(PN_CODSEG in Number,
                                 PN_TIPDOC in Number,
                                 PV_NUMDOC in varchar2,
                                 PN_CUOPOT out Number, --Cuota Potencial
                                 PN_LINTAR out Number, --Linea de líneas en tarjetas crédito
                                 PN_MONLTC out Number, --Monto líneas TC
                                 PN_VARSDE out Number, --Variación saldo deudor
                                 PN_VARNEN out Number, --Variacion Nro entidades
                                 PN_NUMENS out Number, --Nro entidad saldo > X
                                 PN_DEUTOT out Number, --Deuda total
                                 PN_CUOOCO out Number  --Cuota otros convenios
                                )
  Is
    lv_query varchar2(1000);
    lv_tipdoc varchar2(100);
  Begin
      PN_CUOPOT := 0;
      PN_LINTAR := 0;
      PN_MONLTC := 0;
      PN_VARSDE := 0;
      PN_VARNEN := 0;
      PN_NUMENS := 0;
      PN_DEUTOT := 0;
      PN_CUOOCO := 0;
            
      If PN_TIPDOC = 21 Then
         lv_tipdoc := ' JAQY490NDI=:2'; 
      Else
         lv_tipdoc := ' JAQY490NDT=:2'; 
      End If;
            
       Case When PN_CODSEG = 1 Then  
            lv_query:= 'Select JAQY490CPO,JAQY490LTC,JAQY490VNE,JAQY490VEN,JAQY490VSI,JAQY490DTI '||
                         'From JAQY490 '||
                        'Where '||
                        lv_tipdoc;
            
            Begin
                Execute Immediate lv_query||' and JAQY490PER=''1''' 
                  Into PN_CUOPOT ,PN_LINTAR ,PN_VARNEN ,PN_NUMENS ,PN_VARSDE ,PN_DEUTOT
                  Using TRIM(PV_NUMDOC);
            Exception 
            When No_Data_Found Then
                Begin
                     Execute Immediate lv_query||' and JAQY490PER=''3''' 
                        Into PN_CUOPOT ,PN_LINTAR ,PN_VARNEN ,PN_NUMENS ,PN_VARSDE ,PN_DEUTOT
                        Using TRIM(PV_NUMDOC);
                Exception When Others Then
                    Null;
                End;          
            When Others Then
                Null;
            End;    
       When PN_CODSEG = 2 Then  
            lv_query:= 'Select JAQY490CPO,JAQY490LTC,JAQY490VNE,JAQY490VEN,JAQY490VSD,'||
                              'NVL(JAQY490LCN,0)+NVL(JAQY490SUT,0)'||
                         'From JAQY490 '||
                        'Where '||
                        lv_tipdoc;
                        
                        
            Begin
                Execute Immediate lv_query||' and JAQY490PER=''1'''  
                  Into PN_CUOPOT ,PN_LINTAR ,PN_VARNEN ,PN_NUMENS ,PN_VARSDE,PN_MONLTC
                  Using TRIM(PV_NUMDOC);
            Exception 
            When No_Data_Found Then
                Begin
                     Execute Immediate lv_query||' and JAQY490PER=''3''' 
                        Into PN_CUOPOT ,PN_LINTAR ,PN_VARNEN ,PN_NUMENS ,PN_VARSDE,PN_MONLTC
                        Using TRIM(PV_NUMDOC);
                Exception When Others Then
                    Null;
                End;       
            When Others Then
                Null;
            End; 
       When PN_CODSEG = 3 Then  
            lv_query:= 'Select JAQY490DTC,JAQY490COC '||
                         'From JAQY490 '||
                        'Where '||
                        lv_tipdoc;
            Begin
                Execute Immediate lv_query ||' and JAQY490PER=''1''' 
                  Into PN_DEUTOT, PN_CUOOCO
                  Using TRIM(PV_NUMDOC);
            Exception 
            When No_Data_Found Then
                 Begin
                     Execute Immediate lv_query||' and JAQY490PER=''3''' 
                        Into PN_DEUTOT, PN_CUOOCO
                        Using TRIM(PV_NUMDOC);
                 Exception When Others Then
                    Null;
                 End;
            When Others Then
                Null;
            End;
       Else
           Null;
       End Case;   
             
  End SP_RETORNA_VARIABLES;                                 
  ----------------------------------------------------------------------------------------------
  Procedure SP_ACTUALIZA_VARIABLES(PN_TIPDOC in Number,
                                   PV_NUMDOC in varchar2,
                                   PN_CUOPOT in Number,
                                   PN_CUOSFI in Number                                                                    
                                  )
  Is
  Begin
            
      If PN_TIPDOC = 21 Then
         update jaqy490 
         set jaqy490cpo = PN_CUOPOT,
             jaqy490csf = PN_CUOSFI,
             jaqy490act = 'S'
         where jaqy490ndi = PV_NUMDOC;
         commit; 
      Else
         update jaqy490 
         set jaqy490cpo = PN_CUOPOT,
             jaqy490csf = PN_CUOSFI,
             jaqy490act = 'S'
         where jaqy490ndt = PV_NUMDOC;
         commit;         
      End If;
  Exception When Others Then
    null;             
  End SP_ACTUALIZA_VARIABLES;  
  ----------------------------------------------------------------------------------------------
  Procedure SP_VERIFICA_ESTADO(PN_TIPDOC in Number,
                               PV_NUMDOC in varchar2,
                               PN_ESTACT out Char                                                                   
                              )
  Is
  Begin
            
      If PN_TIPDOC = 21 Then
         select jaqy490act
         into PN_ESTACT
         from jaqy490 
         where jaqy490ndi = PV_NUMDOC;
      Else
         select jaqy490act
         into PN_ESTACT
         from jaqy490  
         where jaqy490ndt = PV_NUMDOC;
      End If;
  Exception When Others Then
    PN_ESTACT := null;
  End SP_VERIFICA_ESTADO;                                 
  ----------------------------------------------------------------------------------------------  
  Procedure SP_VALOR_VARIABLE(PN_INI in number, PN_FIN in number, PV_FECHA in varchar2)
  Is
    Cursor c_variables
        Is select v.tp1cod1,v.tp1corr1,trim(c.tp1desc) campo,c.tp1imp1 valor
            from fst198 v
            join fst198 c on c.tp1cod = v.tp1cod
                         and c.tp1cod1 = v.tp1cod1
                         and c.tp1corr1 = v.tp1corr1
                         and c.tp1corr2 = 0
                         and c.tp1corr3 = 1
                                       
           where v.tp1cod=1 and v.tp1cod1=11000
             and v.tp1corr2 = 0
             and v.tp1corr3 = 0
             and v.tp1nro3  = 1;
             
     TYPE tc_valcam IS REF CURSOR;
     c_valcam tc_valcam;
     lv_qrcam varchar2(2000);
     
     ln_corr1 fst198.tp1corr1%type;
     lv_colum varchar2(100);
     lv_signo varchar2(50);
     ln_facto number(20,10); 
     ln_rango fst198.tp1nro2%type;
     ln_ranant fst198.tp1nro2%type;
     ln_corrc number(10);

     
     TYPE tc_actval IS REF CURSOR;
     c_actval tc_actval;
     lv_query varchar2(7000);
     
     ld_fecha date := to_date(PV_FECHA,'rrrrmmdd');
     lv_scrip varchar2(6000);
     
     Type tp_nre Is Table OF JAQY490.JAQY490NRE%type; 
     Type tp_cpo Is Table OF JAQY490.JAQY490CPO%type;                    
     Type tp_ltc Is Table Of JAQY490.JAQY490LTC%type;                    
     Type tp_vsd Is Table Of JAQY490.JAQY490VSD%type;                    
     Type tp_vsi Is Table Of JAQY490.JAQY490VSI%Type;                    
     Type tp_vne Is Table Of JAQY490.JAQY490VNE%type;                    
     Type tp_ven Is Table Of JAQY490.JAQY490VEN%type;                    
     Type tp_dti Is table Of JAQY490.JAQY490DTI%type;                    
     Type tp_dtc Is Table Of JAQY490.JAQY490DTC%type;                    
     Type tp_coc Is Table Of JAQY490.JAQY490COC%type;                    
     Type tp_csf Is Table Of JAQY490.JAQY490CSF%type;
     Type tp_fst Is Table Of JAQY490.Jaqy490fst%type;
     Type tp_fsl Is Table Of JAQY490.Jaqy490ftc%type;
     Type tp_fcv Is Table Of JAQY490.Jaqy490fcv%type;
     Type tp_fcn Is Table Of JAQY490.jaqy490fcc%type;
     Type tp_fco Is Table Of JAQY490.Jaqy490fco%type;
     Type tp_fch Is Table Of JAQY490.jaqy490fch%type;
     Type tp_fcp Is Table Of JAQY490.Jaqy490fcp%type;
     Type tp_fca Is Table Of JAQY490.jaqy490fca%type;
     
     ln_nre tp_nre;
     ln_cpo tp_cpo;
     ln_ltc tp_ltc;
     ln_vsd tp_vsd;
     ln_vsi tp_vsi;
     ln_vne tp_vne;
     ln_ven tp_ven;
     ln_dti tp_dti;
     ln_dtc tp_dtc;
     ln_coc tp_coc;
     ln_csf tp_csf;
     ln_fst tp_fst;
     ln_fsl tp_fsl;
     ln_fcv tp_fcv;
     ln_fcn tp_fcn;
     ln_fco tp_fco;
     ln_fch tp_fch;
     ln_fcp tp_fcp;
     ln_fca tp_fca;
     
     ln_fcstc number(10,5) := 1;
     ln_fcltc number(10,5) := 1;
     ln_fcchi number(10,5) := 1;
     ln_fccav number(10,5) := 1;
     lv_fccvh varchar2(200);
     lv_fcccn varchar2(200);
     lv_fccco varchar2(200);
     lv_fccpy varchar2(200);
BEGIN
     For x in c_variables Loop
         lv_qrcam := null;
         lv_query := null;
         ln_corrc := null;
         Case When x.campo = 'JAQY490CPO' Then 
                lv_query := 'Select c.tp1corr2,''NVL(''||trim(c.tp1desc)||'',0)'',trim(f.tp1desc),'||
                                   'f.tp1nro1+(f.tp1imp1/f.tp1imp2) '||
                             'From fst198 c '||
                             'Join fst198 f on f.tp1cod  = c.tp1cod '||
                                          'and f.tp1cod1 = c.tp1cod1 '|| 
                                          'and f.tp1corr1= c.tp1corr1 '||
                                          'and f.tp1corr2= c.tp1corr2 '||
                                          'and f.tp1corr3 <> 0 '||
                            'Where c.tp1cod  = 1 '||
                              'and c.tp1cod1 = 11000 '||
                              'and c.tp1corr1 = :1 '||
                              'and c.tp1corr2 <> 0 '||
                              'and c.tp1corr3 = 0';
                    Open c_valcam For lv_query Using x.tp1corr1;
                    Loop
                         Fetch c_valcam Into ln_corr1,lv_colum,lv_signo,ln_facto;
                         Exit When c_valcam%Notfound;
                              If ln_corrc is null  Then
                                 lv_qrcam:=lv_qrcam||'('||lv_colum||lv_signo||to_char(ln_facto,'990.00999','NLS_NUMERIC_CHARACTERS = '',.'''); 
                              ElsIf ln_corrc = ln_corr1 Then
                                    lv_qrcam:=lv_qrcam||lv_signo||to_char(ln_facto,'990.00999','NLS_NUMERIC_CHARACTERS = '',.''');
                              ElsIf ln_corrc <> ln_corr1 Then 
                                    lv_qrcam:=lv_qrcam||')+('||lv_colum||lv_signo||to_char(ln_facto,'990.00999','NLS_NUMERIC_CHARACTERS = '',.''');  
                              End If; 
                              
                              ln_corrc := ln_corr1;
                    End Loop; 
                    Close c_valcam;
                    lv_qrcam := 'Trunc('||lv_qrcam||'),5)';
              When x.campo = 'JAQY490LTC' Then
                   ln_corrc := null;
                   lv_query := 'Select c.tp1corr2,''NVL(''||trim(c.tp1desc)||'',0)'',trim(f.tp1desc) '|| 
                               'From fst198 c '||
                               'LEft Join fst198 f on f.tp1cod  = c.tp1cod '||
                                            'and f.tp1cod1 = c.tp1cod1 '|| 
                                            'and f.tp1corr1= c.tp1corr1 '||
                                            'and f.tp1corr2= c.tp1corr2 '||
                                            'and f.tp1corr3 <> 0 '||
                              'Where c.tp1cod  = 1 '||
                                'and c.tp1cod1 = 11000 '||
                                'and c.tp1corr1 = :1 '||
                                'and c.tp1corr2 <> 0 '||
                                'and c.tp1corr3 = 0 '||
                                'Order by c.tp1corr2,f.tp1corr3';
                    Open c_valcam For lv_query Using x.tp1corr1;
                    Loop
                         Fetch c_valcam Into ln_corr1,lv_colum,lv_signo;
                         Exit When c_valcam%Notfound;
                              If ln_corrc is null  Then
                                 lv_qrcam:=lv_qrcam||'('||lv_colum||lv_signo; 
                              ElsIf ln_corrc <> ln_corr1 Then 
                                    lv_qrcam:=lv_qrcam||lv_colum||lv_signo;  
                              End If; 
                              
                              ln_corrc := ln_corr1; 
                    End Loop;  
                    lv_qrcam:= 'Case when '||substr(lv_qrcam,instr(lv_qrcam,'/',1)+1)||'=0 Then 0 else '||lv_qrcam||'end';
             When x.campo = 'JAQY490VNE' Then
                   ln_corrc := null;
                   lv_query := 'Select c.tp1corr2,''NVL(''||trim(c.tp1desc)||'',0)'',trim(f.tp1desc) '|| 
                               'From fst198 c '||
                               'LEft Join fst198 f on f.tp1cod  = c.tp1cod '||
                                            'and f.tp1cod1 = c.tp1cod1 '|| 
                                            'and f.tp1corr1= c.tp1corr1 '||
                                            'and f.tp1corr2= c.tp1corr2 '||
                                            'and f.tp1corr3 <> 0 '||
                              'Where c.tp1cod  = 1 '||
                                'and c.tp1cod1 = 11000 '||
                                'and c.tp1corr1 = :1 '||
                                'and c.tp1corr2 <> 0 '||
                                'and c.tp1corr3 = 0 '||
                                'Order by c.tp1corr2,f.tp1corr3';
                   Open c_valcam For lv_query Using x.tp1corr1;
                    Loop
                         Fetch c_valcam Into ln_corr1,lv_colum,lv_signo;
                         Exit When c_valcam%Notfound;
                              If ln_corrc is null  Then
                                 lv_qrcam:=lv_qrcam||'('||lv_colum||lv_signo; 
                              ElsIf ln_corrc <> ln_corr1 Then 
                                    lv_qrcam:=lv_qrcam||lv_colum||lv_signo;  
                              End If; 
                              ln_corrc := ln_corr1; 
                    End Loop;   
             When x.campo = 'JAQY490VEN' Or x.campo ='JAQY490DTI' Or x.campo ='JAQY490DTC' Then
                   ln_corrc := null;
                   lv_query := 'Select c.tp1corr2,''NVL(''||trim(c.tp1desc)||'',0)'',trim(f.tp1desc) '|| 
                               'From fst198 c '||
                               'LEft Join fst198 f on f.tp1cod  = c.tp1cod '||
                                            'and f.tp1cod1 = c.tp1cod1 '|| 
                                            'and f.tp1corr1= c.tp1corr1 '||
                                            'and f.tp1corr2= c.tp1corr2 '||
                                            'and f.tp1corr3 <> 0 '||
                              'Where c.tp1cod  = 1 '||
                                'and c.tp1cod1 = 11000 '||
                                'and c.tp1corr1 = :1 '||
                                'and c.tp1corr2 <> 0 '||
                                'and c.tp1corr3 = 0 '||
                                'Order by c.tp1corr2,f.tp1corr3';
                   Open c_valcam For lv_query Using x.tp1corr1;
                    Loop
                         Fetch c_valcam Into ln_corr1,lv_colum,lv_signo;
                         Exit When c_valcam%Notfound;
                              If ln_corrc is null  Then
                                 lv_qrcam:=lv_qrcam||lv_colum||lv_signo; 
                              ElsIf ln_corrc <> ln_corr1 Then 
                                    lv_qrcam:=lv_qrcam||lv_colum||lv_signo;  
                              End If; 
                              ln_corrc := ln_corr1; 
                    End Loop; 
             When x.campo = 'JAQY490COC' Then   
                  lv_query := 'Select c.tp1corr2,''NVL(''||trim(c.tp1desc)||'',0)'',trim(f.tp1desc),'||
                                     'f.tp1nro1+(f.tp1imp1/f.tp1imp2), f.tp1nro2 '||
                               'From fst198 c '||
                               'Join fst198 f on f.tp1cod  = c.tp1cod '||
                                            'and f.tp1cod1 = c.tp1cod1 '|| 
                                            'and f.tp1corr1= c.tp1corr1 '||
                                            'and f.tp1corr2= c.tp1corr2 '||
                                            'and f.tp1corr3 <> 0 '||
                              'Where c.tp1cod  = 1 '||
                                'and c.tp1cod1 = 11000 '||
                                'and c.tp1corr1 = :1 '||
                                'and c.tp1corr2 <> 0 '||
                                'and c.tp1corr3 = 0';
                      Open c_valcam For lv_query Using x.tp1corr1;
                      Loop
                           Fetch c_valcam Into ln_corr1,lv_colum,lv_signo,ln_facto,ln_rango;
                           Exit When c_valcam%Notfound;
                                If ln_corrc is null  Then
                                   lv_qrcam:=lv_qrcam||'Case When '||lv_colum||'<='||ln_rango||' Then '||lv_colum||lv_signo||to_char(ln_facto,'990.00999','NLS_NUMERIC_CHARACTERS = '',.'''); 
                                ElsIf ln_corrc = ln_corr1 Then
                                      lv_qrcam:=lv_qrcam||' When '||lv_colum||'<='||ln_rango||' Then '||lv_colum||lv_signo||to_char(ln_facto,'990.00999','NLS_NUMERIC_CHARACTERS = '',.'''); 
                                End If; 
                                ln_corrc := ln_corr1;
                      End Loop; 
                      Close c_valcam;   
                      lv_qrcam:= lv_qrcam||' End';
             When x.campo = 'JAQY490CSF' Then
                  lv_query := 'Select c.tp1corr2,''NVL(''||trim(c.tp1desc)||'',0)'',trim(f.tp1desc),'||
                                     'f.tp1nro1+(f.tp1imp1/f.tp1imp2), f.tp1nro2 '||
                               'From fst198 c '||
                               'Join fst198 f on f.tp1cod  = c.tp1cod '||
                                            'and f.tp1cod1 = c.tp1cod1 '|| 
                                            'and f.tp1corr1= c.tp1corr1 '||
                                            'and f.tp1corr2= c.tp1corr2 '||
                                            'and f.tp1corr3 <> 0 '||
                              'Where c.tp1cod  = 1 '||
                                'and c.tp1cod1 = 11000 '||
                                'and c.tp1corr1 = :1 '||
                                'and c.tp1corr2 <> 0 '||
                                'and c.tp1corr3 = 0 '||
                                'Order by c.tp1corr2,c.tp1corr3';
                      Open c_valcam For lv_query Using x.tp1corr1;
                      Loop
                           Fetch c_valcam Into ln_corr1,lv_colum,lv_signo,ln_facto,ln_rango;
                           Exit When c_valcam%Notfound;
                                If ln_corrc is null and ln_rango is null Then
                                   lv_qrcam := lv_qrcam||'('||lv_colum||lv_signo||to_char(ln_facto,'990.00999','NLS_NUMERIC_CHARACTERS = '',.''');
                                ElsIf ln_corrc is null and ln_rango is not null Then   
                                   lv_qrcam:=lv_qrcam||'(Case When '||lv_colum||'<='||ln_rango||' Then '||lv_colum||lv_signo||to_char(ln_facto,'990.00999','NLS_NUMERIC_CHARACTERS = '',.'''); 
                                ElsIf ln_corrc=ln_corr1 and ln_rango is null Then 
                                      lv_qrcam:=lv_qrcam||lv_signo||to_char(ln_facto,'990.00999','NLS_NUMERIC_CHARACTERS = '',.''');
                                ElsIf ln_corrc=ln_corr1 and ln_rango is not null Then       
                                      lv_qrcam:=lv_qrcam||' When '||lv_colum||'<='||ln_rango||' Then '||lv_colum||lv_signo||to_char(ln_facto,'990.00999','NLS_NUMERIC_CHARACTERS = '',.'''); 
                                ElsIf ln_corrc<>ln_corr1 and ln_ranant is null and ln_rango is null Then 
                                      lv_qrcam := lv_qrcam||')+('||lv_colum||lv_signo||to_char(ln_facto,'990.00999','NLS_NUMERIC_CHARACTERS = '',.''');
                                ElsIf ln_corrc<>ln_corr1 and ln_ranant is null and ln_rango is not null Then 
                                      lv_qrcam := lv_qrcam||')+('||'Case When '||lv_colum||'<='||ln_rango||' Then '||lv_colum||lv_signo||to_char(ln_facto,'990.00999','NLS_NUMERIC_CHARACTERS = '',.''');
                                ElsIf ln_corrc<>ln_corr1 and ln_ranant is not null and ln_rango is null Then 
                                      lv_qrcam := lv_qrcam||' End)+('||lv_colum||lv_signo||to_char(ln_facto,'990.00999','NLS_NUMERIC_CHARACTERS = '',.''');
                                ElsIf ln_corrc<>ln_corr1 and ln_ranant is not null and ln_rango is not null Then 
                                      lv_qrcam := lv_qrcam||' End)+('||'Case When '||lv_colum||'<='||ln_rango||' Then '||lv_colum||lv_signo||to_char(ln_facto,'990.00999','NLS_NUMERIC_CHARACTERS = '',.''');
                                End If; 
                                
                                -- Factores
                                If ln_corr1 = 1 Then
                                   ln_fcstc := ln_fcstc * ln_facto;
                                Elsif ln_corr1 = 2 Then
                                   ln_fcltc := ln_fcltc * ln_facto;
                                Elsif ln_corr1 = 3 and ln_corrc <> ln_corr1 and ln_ranant is null Then  
                                   lv_fccvh := lv_fccvh||'(Case When '||lv_colum||'<='||ln_rango||' Then '||to_char(ln_facto,'990.00999','NLS_NUMERIC_CHARACTERS = '',.''');
                                Elsif ln_corr1 = 3 and ln_corrc <> ln_corr1 and ln_ranant is not null Then  
                                   lv_fccvh :=lv_fccvh||' End),(Case When '||lv_colum||'<='||ln_rango||' Then '||to_char(ln_facto,'990.00999','NLS_NUMERIC_CHARACTERS = '',.''');
                                Elsif ln_corr1 = 3 and ln_corrc = ln_corr1 Then
                                   lv_fccvh:=lv_fccvh||' When '||lv_colum||'<='||ln_rango||' Then '||to_char(ln_facto,'990.00999','NLS_NUMERIC_CHARACTERS = '',.'''); 
                                
                                Elsif ln_corr1 = 4 and ln_corrc <> ln_corr1 and ln_ranant is null Then  
                                   lv_fcccn :=lv_fcccn||'(Case When '||lv_colum||'<='||ln_rango||' Then '||to_char(ln_facto,'990.00999','NLS_NUMERIC_CHARACTERS = '',.''');
                                Elsif ln_corr1 = 4 and ln_corrc <> ln_corr1 and ln_ranant is not null Then  
                                   lv_fcccn :=lv_fcccn||' End),(Case When '||lv_colum||'<='||ln_rango||' Then '||to_char(ln_facto,'990.00999','NLS_NUMERIC_CHARACTERS = '',.''');
                                Elsif ln_corr1 = 4 and ln_corrc = ln_corr1 Then
                                   lv_fcccn:=lv_fcccn||' When '||lv_colum||'<='||ln_rango||' Then '||to_char(ln_facto,'990.00999','NLS_NUMERIC_CHARACTERS = '',.'''); 
                                
                                Elsif ln_corr1 = 5 and ln_corrc <> ln_corr1 and ln_ranant is null Then  
                                   lv_fccco :=lv_fccco||'(Case When '||lv_colum||'<='||ln_rango||' Then '||to_char(ln_facto,'990.00999','NLS_NUMERIC_CHARACTERS = '',.''');
                                Elsif ln_corr1 = 5 and ln_corrc <> ln_corr1 and ln_ranant is not null Then  
                                   lv_fccco :=lv_fccco||' End),(Case When '||lv_colum||'<='||ln_rango||' Then '||to_char(ln_facto,'990.00999','NLS_NUMERIC_CHARACTERS = '',.''');
                                Elsif ln_corr1 = 5 and ln_corrc = ln_corr1 Then
                                   lv_fccco:=lv_fccco||' When '||lv_colum||'<='||ln_rango||' Then '||to_char(ln_facto,'990.00999','NLS_NUMERIC_CHARACTERS = '',.'''); 
                                
                                Elsif ln_corr1 = 6 Then
                                   ln_fcchi := ln_fcchi * ln_facto;
                                
                                Elsif ln_corr1 = 7 and ln_corrc <> ln_corr1 and ln_ranant is null Then  
                                   lv_fccpy :=lv_fccpy||'(Case When '||lv_colum||'<='||ln_rango||' Then '||to_char(ln_facto,'990.00999','NLS_NUMERIC_CHARACTERS = '',.''');
                                Elsif ln_corr1 = 7 and ln_corrc <> ln_corr1 and ln_ranant is not null Then  
                                   lv_fccpy :=lv_fccpy||'),(Case When '||lv_colum||'<='||ln_rango||' Then '||to_char(ln_facto,'990.00999','NLS_NUMERIC_CHARACTERS = '',.''');
                                Elsif ln_corr1 = 7 and ln_corrc = ln_corr1 Then
                                   lv_fccpy:=lv_fccpy||' When '||lv_colum||'<='||ln_rango||' Then '||to_char(ln_facto,'990.00999','NLS_NUMERIC_CHARACTERS = '',.'''); 
                                Elsif ln_corr1 = 8 Then
                                   ln_fccav := ln_fccav * ln_facto;
                                End If;
                                    
                                ln_corrc := ln_corr1; 
                                ln_ranant := ln_rango; 
                      End Loop; 
                      Close c_valcam;   
                      If ln_ranant Is not Null Then
                         lv_qrcam:= lv_qrcam||' End)';
                      Else
                         lv_qrcam:= lv_qrcam||')';
                      End If; 
                      
                      lv_qrcam:= lv_qrcam||','||to_char(ln_fcstc,'9990.00000','NLS_NUMERIC_CHARACTERS = '',.''')||','||
                                 to_char(ln_fcltc,'9990.00000','NLS_NUMERIC_CHARACTERS = '',.''')||','||
                                 lv_fccvh||lv_fcccn||lv_fccco||' End),'||   
                                 to_char(ln_fcchi,'9990.00000','NLS_NUMERIC_CHARACTERS = '',.''')||','||
                                 lv_fccpy||' End),'|| 
                                 to_char(ln_fccav,'9990.00000','NLS_NUMERIC_CHARACTERS = '',.''');
                                                                   
            When x.campo = 'JAQY490VSD' Or x.campo = 'JAQY490VSI' Then
                 lv_query := 'Select c.tp1corr2,''NVL(''||trim(c.tp1desc)||'',0)'',trim(f.tp1desc),f.tp1nro1 '||
                             'From fst198 c '||
                             'LEft Join fst198 f on f.tp1cod  = c.tp1cod '||
                                          'and f.tp1cod1 = c.tp1cod1 '|| 
                                          'and f.tp1corr1= c.tp1corr1 '||
                                          'and f.tp1corr2= c.tp1corr2 '||
                                          'and f.tp1corr3 <> 0 '||
                            'Where c.tp1cod  = 1 '||
                              'and c.tp1cod1 = 11000 '||
                              'and c.tp1corr1 = :1 '||
                              'and c.tp1corr2 <> 0 '||
                              'and c.tp1corr3 = 0 '||
                              'Order by c.tp1corr2,f.tp1corr3';
                 Open c_valcam For lv_query Using x.tp1corr1;
                 Loop
                     Fetch c_valcam Into ln_corr1,lv_colum,lv_signo,ln_facto;
                     Exit When c_valcam%Notfound;
                          If ln_corrc is null  Then
                             lv_qrcam := lv_qrcam||'Case When '||lv_colum||lv_signo||ln_facto;
                          ElsIf ln_corrc = ln_corr1 Then
                                lv_qrcam := lv_qrcam||' '||lv_signo;
                          ElsIf ln_corrc <> ln_corr1 Then 
                                lv_qrcam := lv_qrcam||lv_colum||lv_signo;
                          End If; 
                          ln_corrc := ln_corr1; 
                End Loop;
                Close c_valcam; 
                lv_qrcam:= 'Case When '||substr(lv_qrcam,instr(lv_qrcam,'/')+1,instr(lv_qrcam,'-')-instr(lv_qrcam,'/')-2)||'=0 Or '
                           ||substr(lv_qrcam,instr(lv_qrcam,'/',instr(lv_qrcam,'*'))+1,instr(lv_qrcam,'Else')-(instr(lv_qrcam,'/',instr(lv_qrcam,'*')))-3)||'=0 Then 0 Else '
                           ||lv_qrcam||' End';
         Else          
             Null;         
         End Case;

         lv_scrip := lv_scrip||' '||lv_qrcam||',';
     End Loop; 
     lv_scrip := substr(lv_scrip,1,length(lv_scrip)-1);
     
     If lv_scrip Is not Null Then
        lv_query:= 'Select jaqy490nre,'||lv_scrip||
                       ' From jaqy490'||
                       ' Where jaqy490fec=:1'||
                       '   and jaqy490nre between :2 and :3';
                                
        Open c_actval For lv_query Using ld_fecha,PN_INI,PN_FIN;
        Loop
            Fetch c_actval Bulk Collect Into ln_nre,ln_cpo,ln_ltc,
                                             ln_vsd,ln_vsi,ln_vne,
                                             ln_ven,ln_dti,ln_dtc,
                                             ln_coc,ln_csf,ln_fst,
                                             ln_fsl,ln_fcv,ln_fcn,
                                             ln_fco,ln_fch,ln_fcp,
                                             ln_fca Limit 1000;
            
            If ln_cpo.count > 0 THEN     
               Forall x In ln_cpo.FIRST .. ln_cpo.LAST
                 Update jaqy490
                    Set jaqy490cpo = ln_cpo(x),
                        jaqy490ltc = ln_ltc(x),
                        jaqy490vsd = ln_vsd(x),
                        jaqy490vsi = ln_vsi(x),
                        jaqy490vne = ln_vne(x),
                        jaqy490ven = ln_ven(x),
                        jaqy490dti = ln_dti(x),
                        jaqy490dtc = ln_dtc(x),
                        jaqy490coc = ln_coc(x),
                        jaqy490csf = ln_csf(x),
                        jaqy490fst = ln_fst(x),
                        jaqy490ftc = ln_fsl(x),
                        jaqy490fcv = ln_fcv(x),
                        jaqy490fcc = ln_fcn(x),
                        jaqy490fco = ln_fco(x),
                        jaqy490fch = ln_fch(x),
                        jaqy490fcp = ln_fcp(x),
                        jaqy490fca = ln_fca(x)
                  Where jaqy490nre = ln_nre(x)
                    and jaqy490fec = ld_fecha;
                  Commit;       
            End If;        
            Exit When c_actval%NotFound;
        End Loop;
        Close c_actval;
        
      End If;
     
  End SP_VALOR_VARIABLE;
  ----------------------------------------------------------------------------------------------
  Procedure SP_RETORNA_VARIABLES_SEG (PN_CODSEG in Number,
                                 PN_TIPDOC in Number,
                                 PV_NUMDOC in varchar2,
                                 PN_CUOPOT out Number, --Cuota Potencial
                                 PN_LINTAR out Number, --Linea de líneas en tarjetas crédito
                                 PN_MONLTC out Number, --Monto líneas TC
                                 PN_VARSDE out Number, --Variación saldo deudor
                                 PN_VARNEN out Number, --Variacion Nro entidades
                                 PN_NUMENS out Number, --Nro entidad saldo > X
                                 PN_DEUTOT out Number, --Deuda total
                                 PN_CUOOCO out Number, --Cuota otros convenios
                                 PN_NUMENT out Number, --Nro. de entidades
                                 PN_CUOSIF out Number, --Cuota sistema financiero
                                 PN_SALDEU out Number,
                                 PN_SUT out Number,
                                 PN_SUN out Number,
                                 PN_LCN out Number,
                                 PN_LTN out Number,
                                 PN_PMR out Number,
                                 PN_LTP out Number,
                                 PN_LNP out Number,                                 
                                 PV_CODSBS out Varchar2,
                                 PD_FECRCC out Date
                                )
  Is
    lv_query varchar2(1000);
    lv_tipdoc varchar2(100);
  Begin
      PN_CUOPOT := 0;
      PN_LINTAR := 0;
      PN_MONLTC := 0;
      PN_VARSDE := 0;
      PN_VARNEN := 0;
      PN_NUMENS := 0;
      PN_DEUTOT := 0;
      PN_CUOOCO := 0;
      PN_NUMENT := 0;
      PN_CUOSIF := 0;
            
      If PN_TIPDOC = 21 Then
         lv_tipdoc := ' JAQY490NDI=:2'; 
      Else
         lv_tipdoc := ' JAQY490NDT=:2'; 
      End If;
            
       Case When PN_CODSEG = 1 Then  
            lv_query:= 'Select JAQY490FEC, JAQY490SBS, JAQY490CPO,JAQY490LTC,JAQY490VNE,JAQY490VEN,JAQY490VSI,JAQY490DTI,JAQY490NEN,JAQY490CSF,JAQY490STD,JAQY490SUT,JAQY490SUN,JAQY490LCN,JAQY490LTN,JAQY490PMR,JAQY490LPR,JAQY490LNP '||
                         'From JAQY490 '||
                        'Where '||
                        lv_tipdoc;
            
            Begin
                Execute Immediate lv_query||' and JAQY490PER=''1''' 
                  Into PD_FECRCC,PV_CODSBS,PN_CUOPOT ,PN_LINTAR ,PN_VARNEN ,PN_NUMENS ,PN_VARSDE ,PN_DEUTOT,PN_NUMENT,PN_CUOSIF,PN_SALDEU,PN_SUT,PN_SUN,PN_LCN,PN_LTN,PN_PMR,PN_LTP,PN_LNP
                  Using TRIM(PV_NUMDOC);
            Exception 
            When No_Data_Found Then
                Begin
                     Execute Immediate lv_query||' and JAQY490PER=''3''' 
                        Into PD_FECRCC,PV_CODSBS,PN_CUOPOT ,PN_LINTAR ,PN_VARNEN ,PN_NUMENS ,PN_VARSDE ,PN_DEUTOT,PN_NUMENT,PN_CUOSIF,PN_SALDEU,PN_SUT,PN_SUN,PN_LCN,PN_LTN,PN_PMR,PN_LTP,PN_LNP
                        Using TRIM(PV_NUMDOC);
                Exception When Others Then
                    Null;
                End;          
            When Others Then
                Null;
            End;    
       When PN_CODSEG = 2 Or PN_CODSEG = 3 Then  
            lv_query:= 'Select JAQY490FEC,JAQY490SBS,JAQY490CPO,JAQY490LTC,JAQY490VNE,JAQY490VEN,JAQY490VSD,'||
                              'NVL(JAQY490LCN,0)+NVL(JAQY490SUT,0),JAQY490NEN,JAQY490CSF '||
                         'From JAQY490 '||
                        'Where '||
                        lv_tipdoc;
                        
                        
            Begin
                Execute Immediate lv_query||' and JAQY490PER=''1'''  
                  Into PD_FECRCC,PV_CODSBS,PN_CUOPOT ,PN_LINTAR ,PN_VARNEN ,PN_NUMENS ,PN_VARSDE,PN_MONLTC,PN_NUMENT,PN_CUOSIF
                  Using TRIM(PV_NUMDOC);
            Exception 
            When No_Data_Found Then
                Begin
                     Execute Immediate lv_query||' and JAQY490PER=''3''' 
                        Into PD_FECRCC,PV_CODSBS,PN_CUOPOT ,PN_LINTAR ,PN_VARNEN ,PN_NUMENS ,PN_VARSDE,PN_MONLTC,PN_NUMENT,PN_CUOSIF
                        Using TRIM(PV_NUMDOC);
                Exception When Others Then
                    Null;
                End;       
            When Others Then
                Null;
            End; 
       
            lv_query:= 'Select JAQY490FEC,JAQY490SBS,JAQY490DTC,JAQY490COC,JAQY490STD,JAQY490SUT,JAQY490SUN,JAQY490LCN,JAQY490LTN,JAQY490PMR,JAQY490LPR,JAQY490LNP '||
                         'From JAQY490 '||
                        'Where '||
                        lv_tipdoc;
            Begin
                Execute Immediate lv_query ||' and JAQY490PER=''1''' 
                  Into PD_FECRCC,PV_CODSBS,PN_DEUTOT, PN_CUOOCO,PN_SALDEU,PN_SUT,PN_SUN,PN_LCN,PN_LTN,PN_PMR,PN_LTP,PN_LNP
                  Using TRIM(PV_NUMDOC);
            Exception 
            When No_Data_Found Then
                 Begin
                     Execute Immediate lv_query||' and JAQY490PER=''3''' 
                        Into PD_FECRCC,PV_CODSBS,PN_DEUTOT, PN_CUOOCO,PN_SALDEU,PN_SUT,PN_SUN,PN_LCN,PN_LTN,PN_PMR,PN_LTP,PN_LNP
                        Using TRIM(PV_NUMDOC);
                 Exception When Others Then
                    Null;
                 End;
            When Others Then
                Null;
            End;
       Else
           Null;
       End Case;   
             
  End SP_RETORNA_VARIABLES_SEG;
  ----------------------------------------------------------------------------------------------
End PQ_SOBEND_RCC;
/

