create or replace package PQ_CR_DEUDACLIENTE is

  -- Author  : MCANDIA
  -- Created : 03/06/2016 17:12:46
  -- Purpose : 

  
  Procedure Sp_cr_job_cabecera;
  procedure Sp_cr_cagaCabecera( P_C_DIGITO in varchar2,pd_fecpro in date);
  
  Procedure Sp_cr_job_detalle;
  procedure Sp_cr_cagaDetalle/*( P_C_DIGITO in varchar2,pd_fecpro in date)*/;
  Procedure sp_job_Carga (pd_fecpro in date ) ;
  procedure sp_cr_carga_clientes(P_C_DIGITO in varchar2,P_D_FECPRO in date);
  

                                  
  procedure sp_deudaTotal(cod_sbs in varchar2,  ln_salcap out number  );
  procedure sp_deudaPatrimonio(cod_sbs in varchar2, ln_salcap out number  );                                

  Procedure sp_job_deudabantotal (pd_fecpro in date ) ;
  procedure sp_deudabantotal (P_C_DIGITO in varchar2 ,pd_fecpro in date);
  procedure sp_cuentas(ln_Pepais     in number,
                       ln_Petdoc     in number,
                       ln_Pendoc     in char,
                       pd_fecpro     in date,
                       ln_captotcaja out number,
                       ln_saldoTot   out number) ;
 --procedure sp_cuentas_SalCap(ln_Pepais     in number,
   --                    ln_Petdoc     in number,
     --                  ln_Pendoc     in char,
       --                pd_fecpro     in date,
                       --ln_captotcaja out number,
         --              ln_saldoTot   out number) ;                       
 procedure sp_SaldoCapital(ln_Pepais     in number,
                       ln_Petdoc     in number,
                       ln_Pendoc     in char,
                       pd_fecpro     in date,
                       ln_captotcaja out number);
   --------------------------------------------------
  procedure sp_cal_lin_venc(ln_pgcod10   in number,
                         ln_mod10     in number,
                         ln_suc10     in number,
                         ln_mda10     in number,
                         ln_pap10     in number,
                         ln_cta10     in number,
                         ln_oper10    in number,
                         ln_sbop10    in number,
                         ln_tope10    in number,
                         tipocambio   in number,
                         ln_capacidad out number) ;
  -----------------------------------------------------
  procedure sp_resolutor(ln_pgcod10   in number,
                         ln_mod10     in number,
                         ln_suc10     in number,
                         ln_mda10     in number,
                         ln_pap10     in number,
                         ln_cta10     in number,
                         ln_oper10    in number,
                         ln_sbop10    in number,
                         ln_tope10    in number,
                         ln_peri10    in number,
                         tipocambio   in number,
                         ln_indicador in number, -- mod 2016.04.13
                         ln_capacidad out number);  

  --------------------------------------------------
  procedure sp_resolutor_venc(ln_pgcod10   in number,
                         ln_mod10     in number,
                         ln_suc10     in number,
                         ln_mda10     in number,
                         ln_pap10     in number,
                         ln_cta10     in number,
                         ln_oper10    in number,
                         ln_sbop10    in number,
                         ln_tope10    in number,
                         --ln_peri10    in number,
                         tipocambio   in number,
                        -- ln_indicador in number,
                         ln_capacidad out number,
                         ln_sdoTot out number)           ;    
  ----------------------------------------------------------
  Procedure Sp_TipOpe_CK(pn_mod in number,pn_top in number, Pc_flag out varchar2);
  --mod 2016.04.13
  Procedure Sp_ampliados_CK(ln_emp10  in number,
                            ln_mod10  in number,
                            ln_suc10  in number,
                            ln_mda10  in number,
                            ln_pap10  in number,
                            ln_cta10  in number,
                            ln_oper10 in number,
                            ln_sbop10 in number,
                            ln_tope10 in number,
                            Pc_flag   out varchar2);                                                
  ----------------------------------------------------------
  --mod 2016.04.13
  Procedure Sp_Adicional_CK(pn_mod in number,pn_top in number, Pc_flag out varchar2);
  --Procedure Sp_TipOpe_CK(pn_mod in number,pn_top in number, Pc_flag out varchar2);                       
                 
  ------------------------------------------------------
  
  procedure sp_cuotas(ln_pgcod10    in number,
                      ln_mod10      in number,
                      ln_suc10      in number,
                      ln_mda10      in number,
                      ln_pap10      in number,
                      ln_cta10      in number,
                      ln_oper10     in number,
                      ln_sbop10     in number,
                      ln_tope10     in number,
                      ln_NRO_CUOTAS out number);
                      
  -------------------------------------------------------
  procedure sp_instancia(ln_mod10     in number,
                         ln_suc10     in number,
                         ln_mda10     in number,
                         ln_pap10     in number,
                         ln_cta10     in number,
                         ln_oper10    in number,
                         ln_sbop10    in number,
                         ln_tope10    in number,
                         ln_SNG001Ori out number,
                         ln_instancia out number);
  -------------------------------------------------------
  procedure sp_cuota_impaga(ln_pgcod10    in number,
                            ln_mod10      in number,
                            ln_suc10      in number,
                            ln_mda10      in number,
                            ln_pap10      in number,
                            ln_cta10      in number,
                            ln_oper10     in number,
                            ln_sbo10      in number,
                            ln_tip10      in number,
                            tipocambio    in number,
                            ln_cuoimp     out number,
                            fech_maxcuota out date);
  ---------------------------------------------------------
  procedure sp_seguro(ln_mod10        in number,
                      ln_suc10        in number,
                      ln_mda10        in number,
                      ln_pap10        in number,
                      ln_cta10        in number,
                      ln_oper10       in number,
                      ln_sbop10       in number,
                      ln_tope10       in number,
                      tipocambio      in number,
                      fech_maxcuota   in date,
                      ln_monto_seguro out number);
  ----------------------------------------------------------

  procedure sp_capacidadlinea(ln_mod10   in number,
                              ln_suc10   in number,
                              ln_mda10   in number,
                              ln_pap10   in number,
                              ln_cta10   in number,
                              ln_oper10  in number,
                              ln_sbop10  in number,
                              ln_tope10  in number,
                              tipocambio in number,
                              ln_formula out number);
  --------------------------------------------------

  procedure sp_capacidadpago(ln_MAX_CUOTA    in number,
                             ln_NRO_CUOTAS   in number,
                             ln_SNG001Ori    in number,
                             ln_peri10       in number,
                             ln_monto_seguro in number,
                             ln_mod10        in number,
                             ln_instancia    in number,
                             tipocambio      in number,
                             ln_suc10        in number, --mod 2016.04.12
                             ln_mda10        in number, --mod 2016.04.12
                             ln_pap10        in number, --mod 2016.04.12
                             ln_cta10        in number, --mod 2016.04.12
                             ln_oper10       in number, --mod 2016.04.12 
                             ln_sbop10       in number, --mod 2016.04.12
                             ln_tope10       in number, --mod 2016.04.12
                             ln_indicador    in number, --mod 2016.04.12
                             ln_capacidad    out number);
  
  
  ------------------------------------------------------------
  procedure sp_cuota_impaga_Lin(ln_pgcod10    in number,
                                ln_mod10      in number,
                                ln_suc10      in number,
                                ln_mda10      in number,
                                ln_pap10      in number,
                                ln_cta10      in number,
                                ln_oper10     in number,
                                ln_sbop10     in number,
                                ln_tipo10     in number,
                                tipocambio    in number,
                                ln_cuoimp     out number,
                                fech_maxcuota out date);
  ------------------------------------------------------------                            

  procedure sp_capacidadpago_Lin(ln_MAX_CUOTA    in number,
                                 ln_NRO_CUOTAS   in number,
                                 ln_peri10       in number,
                                 ln_monto_seguro in number,
                                 ln_mod10        in number,
                                 ln_capacidad    out number);
                      
  
  
  
  Procedure Sp_Segmentacion_var (pn_pai in number,
                            pn_tdo in number,
                            pc_ndo in char,
                            pn_cal out number,
                            ln_CntInsRep out number);
  Procedure Sp_Segmentacion  (pc_codsbs in varchar2,
                            pn_cal out number) ;                            
  Function Fn_calificacion_PRY(c_CodSbsIn IN varchar2,
                             pd_fecRcc in date,
                             MesRcc in number
                             )return number;                            
  Function Fn_calificacion_RCC(TipDocSbs in char,
                             pc_ndo_FN in char,
                             pd_fecRcc in date,
                             MesRcc in number,
                             lc_tiper_FN in char
                             )return number;
  Function Fn_cant_instit(lc_CodSbs in char)return number; 
  Function Fn_cant_instit_T(lc_CodSbs in char )return number  ;
  Procedure Sp_calRCC2(pn_pai in number,
                            pn_tdo in number,
                            pc_ndo in char,
                            pn_cal out number);
  Procedure Sp_Hist_NR_INI(pd_Fecpro in date);                            
  Function Fn_RelCredi_NR(pn_pai in number,pn_tdo in number,pc_ndo in char,pd_Fecpro in date)
                        return number;
  Procedure Sp_Hist_NR_MENS(pd_Fecpro in date);        
  Function fn_inserta(pn_pai in number,pn_tdo in number,pc_ndo in char,pd_fec in date)return number ;                  
  Function Fn_Refinanciado(pn_pai in number,pn_tdo in number,pc_ndo in char) return char;                                                               
  Procedure Sp_JudiCast(pn_pai in number,pn_tdo in number,pc_ndo in char,
                      ln_exfin out varchar2);         
  Procedure Sp_Venta(pn_pai in number,pn_tdo in number,pc_ndo in char,
                      ln_exfin out varchar2);                    
  Function Fn_cant_instit_Segm(TipDocSbs in char,
                        pc_ndo in char,
                        pd_fecRcc in date,
                        lc_tiper in char
                        )return number; 
  -----------------------------------------------------------
  Procedure Sp_Consolida_I;
  Procedure sp_job_Sp_Consolida_II (pd_fecpro in date );
  procedure Sp_Consolida_II (P_C_DIGITO in varchar2 ,pd_fecpro in date)  ;    
  procedure Sp_Consolida_III (pd_fecpro in date);                  
  Procedure Sp_cr_carga_ini(pd_Fecpro in date);    
  Procedure sp_job_Carga_Eval;
  Procedure Sp_cr_carga_Eval(P_C_DIGITO in varchar2);  
  
  Procedure Sp_ResNeto_ExcMens(pn_pai in number,pn_tip in number,pc_ndo in char,pn_ind in number,
                               pn_res out number,pn_pat out number); 
  Procedure Sp_ResNeto_ExcMens_Dia(pn_pai in number,pn_tip in number,pc_ndo in char,pd_fecpro in date,
                              pn_ind in number,pn_res out number,pn_pat out number);                                                            
  Procedure Sp_cr_job_SaldDiv;
  Procedure Sp_cr_SaldDiv(P_C_DIGITO in varchar2); 
  Procedure Sp_HipConPym(cod_sbs in char,ln_sdoPyme out number,ln_sdoCon out number,
                   ln_sdoHipo out number);                                                        
end PQ_CR_DEUDACLIENTE;
/

create or replace package body PQ_CR_DEUDACLIENTE is



Procedure Sp_cr_job_cabecera is

    
  ln_ini number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);  
  ld_fecrcc date;
  
  lc_hostname varchar2(64);

  cursor c_cabecera_job(ld_fec in date) is 

      select substr(trim(j.c_codsbs), -1, 1) digito
          from cldrcci j
         where j.d_fecpre = ld_fec
         group by substr(trim(j.c_codsbs), -1, 1);

  begin
     execute immediate('Truncate table JAQY346CAB');
     delete Tab_jobs where  c_Codage = 'DB1';
     commit;
     delete from log_error_bandeja a where a.c_codbdj ='DB1';
     commit;
     
     --fecha RCC
     begin
         select to_date(tpnro,'dd/mm/yyyy')
           into ld_fecrcc
           from fst098
          where pgcod = 1
            and tpcod = 7647
            and tpcorr = 12;
     exception
            when no_data_found then
                 ld_fecrcc := null;
     end;
     
    begin
      select host_name
        into lc_hostname
        from v$instance;
    end;


     for i in c_cabecera_job(ld_fecrcc) loop
        ln_ini := i.digito;
        lc_variable := ' begin '|| '  PQ_CR_DEUDACLIENTE.Sp_cr_cagaCabecera('||ln_ini||','||''''||ld_fecrcc||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
        
        
--        if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then             
--        if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
IF SYS.FN_BD_ISRAC='TRUE' THEN
           DBMS_JOB.SUBMIT(job => ln_job, 
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
                        instance => 1,
                        --instance => 2, 01/01/2024
                        force => false
                        );
          else
            DBMS_JOB.SUBMIT(job => ln_job, 
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
                        force => false
                        );
          end if;


        INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
        VALUES('DB1',ln_ini,lc_variable);
        COMMIT;
      end loop;
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'DB1',lc_coderr, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;
         

end Sp_cr_job_cabecera;

procedure Sp_cr_cagaCabecera( P_C_DIGITO in varchar2,pd_fecpro in date) is

  cursor Cabecera is
  select * from cldrcci j
  WHERE j.d_fecpre = pd_fecpro
    and substr(trim(j.C_CODSBS), -1, 1) = P_C_DIGITO
    ;

    lc_coderr VARCHAR2(100);     
    lc_flag char(1);
  
    BEGIN
      update tab_jobs g
         set g.d_fecini = sysdate
       where g.n_numer1 = P_C_DIGITO
         and g.c_codage = 'DB1';
    commit;

       
   begin
      
     for c in Cabecera loop
         lc_flag := 'N';
         if c.c_doctri is null and c.c_docide is null then
            lc_flag := 'S';
         end if;
         
         If lc_flag = 'N' then
             INSERT INTO JAQY346CAB
             values(c.C_CODSBS,
                    c.C_TIPREG,
                    c.C_TIPDET,
                    c.D_FECPRE,
                    c.C_TDOCTR,
                    c.C_DOCTRI,
                    c.C_TDOCID,
                    c.C_DOCIDE,
                    c.C_PERSON,
                    c.C_TIPEMP,
                    c.N_CANENT,
                    c.N_CALIF0,
                    c.N_CALIF1,
                    c.N_CALIF2,
                    c.N_CALIF3,
                    c.N_CALIF4,
                    c.C_NOMDEU,
                    c.C_APEMAT,
                    c.C_APECAS,
                    c.C_PRINOM,
                    c.C_SEGNOM
                    );

                commit; 
          end if;
                                  
     end loop;
     commit;
     
     
      update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  P_C_DIGITO
       and g.c_codage = 'DB1';
    commit;
    end;
    
     EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = P_C_DIGITO
         and g.c_codage = 'DB1';
    commit;
    return;
  

end Sp_cr_cagaCabecera;

Procedure Sp_cr_job_detalle is


  ln_ini number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  ld_fecrcc date;
  lc_hostname varchar2(64);
  cursor c_detalle_job is 
      select substr(trim(j.c_codsbs), -1, 1) digito
          from JAQY346CAB j
         --where j.d_fecpre = ld_fec
         group by substr(trim(j.c_codsbs), -1, 1);
         
  begin
     execute immediate('Truncate table JAQY346DET');
     delete Tab_jobs where  c_Codage = 'DB2';
     commit;
     delete from log_error_bandeja a where a.c_codbdj ='DB2';
     commit;
     
     --fecha RCC
     begin
         select to_date(tpnro,'dd/mm/yyyy')
           into ld_fecrcc
           from fst098
          where pgcod = 1
            and tpcod = 7647
            and tpcorr = 12;
     exception
            when no_data_found then
                 ld_fecrcc := null;
     end;
     
     begin
    select host_name
      into lc_hostname
      from v$instance;
  end;


     for i in c_detalle_job loop
        ln_ini := i.digito;
        lc_variable := ' begin '|| '  PQ_CR_DEUDACLIENTE.Sp_cr_cagaDetalle('||ln_ini||','||''''||ld_fecrcc||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
--         if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then             
--         if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
IF SYS.FN_BD_ISRAC='TRUE' THEN
           DBMS_JOB.SUBMIT(job => ln_job, 
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
                        instance => 1,
                        --instance => 2, 01/01/2024
                        force => false
                        );
          else
            DBMS_JOB.SUBMIT(job => ln_job, 
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
                        force => false
                        );
          end if;

        INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
        VALUES('DB2',ln_ini,lc_variable);
        COMMIT;
      end loop;
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'DB2',lc_coderr, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;
         

end Sp_cr_job_detalle;


procedure Sp_cr_cagaDetalle/*( P_C_DIGITO in varchar2,pd_fecpro in date)*/ is

/*  cursor Cabecera is
  select j.* from cldrccs j
  WHERE j.d_fecpre = pd_fecpro
    and substr(trim(j.C_CODSBS), -1, 1) = P_C_DIGITO

    ;*/
    

    ld_fecrcc date;
    --lc_coderr VARCHAR2(100);
    LC_MES VARCHAR2(20);
   
    BEGIN
      execute immediate('Truncate table JAQY346DET');
      execute immediate('drop index IDX_JAQY346DET_01');
      execute immediate('drop index IDX_JAQY346DET_02');
      execute immediate('drop index IDX_JAQY346DET_03');
     /* update tab_jobs g
         set g.d_fecini = sysdate
       where g.n_numer1 = P_C_DIGITO
         and g.c_codage = 'DB2';
    commit;*/
         --ultima rcc
    begin
      select to_date(tpnro,'ddmmyyyy')
        into ld_fecrcc
        from FST098 f
       Where Pgcod = 1
         and Tpcod = 7647 
         and Tpcorr = 12;         
    end;
    LC_MES :=  to_char('CLDRCCS_'||TO_CHAR(ld_fecrcc,'MMYYYY'));
    begin
      execute immediate('ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE');

      execute immediate
      'insert into JAQY346DET 
        select /*+parallel(a,10)*/ a.* 
          from cldrccs partition('||LC_MES||') a ';
  
      --8minutos
      commit;
      --recrear índice de tabla temporal JAQY346DET
      execute immediate('create index IDX_JAQY346DET_01 on JAQY346DET (D_FECPRE, C_CODSBS) parallel 10 tablespace bantprod_c_idx');
      execute immediate('alter index IDX_JAQY346DET_01 parallel 1');
      execute immediate('create index IDX_JAQY346DET_02 on JAQY346DET (C_CODSBS, C_CUENTA) parallel 10 tablespace bantprod_c_idx');
      execute immediate('alter index IDX_JAQY346DET_02 parallel 1');
      execute immediate('create index IDX_JAQY346DET_03 on JAQY346DET (C_CODSBS, C_CRETIP, C_CODEMP, C_CUENTA) parallel 10 tablespace bantprod_c_idx');
      execute immediate('alter index IDX_JAQY346DET_03 parallel 1');


      --estadísticas a tabla

      begin
        DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                      tabname          => 'JAQY346DET',
                                      degree           => 8,
                                      granularity      => 'ALL',
                                      estimate_percent => dbms_stats.auto_sample_size,
                                      cascade          => TRUE);
      end;
      end;
  /* begin
     for c in Cabecera loop
         
             INSERT INTO JAQY346DET
             values(c.C_CODSBS,
                    c.C_TIPREG,
                    c.C_TIPDET,
                    c.C_CODEMP,
                    c.C_CRETIP,
                    c.C_CUENTA,
                    c.N_DIAATR,
                    c.N_SALCAP,
                    c.C_CALVIG,
                    c.D_FECPRE
                    );
            commit;     
     end loop;
     commit;
         
      update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  P_C_DIGITO
       and g.c_codage = 'DB2';
    commit;
    end;
    
     EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = P_C_DIGITO
         and g.c_codage = 'DB2';
    commit;
    return;*/
  

end Sp_cr_cagaDetalle;
        
Procedure sp_job_Carga (pd_fecpro in date ) is
  --ln_max number;
  --ln_inc number;
  ln_ini number;
  --ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor c_clientes_job is 
      select substr(trim(j.c_codsbs), -1, 1) digito
          from JAQY346CAB j
         group by substr(trim(j.c_codsbs), -1, 1);
         
  begin
     execute immediate('Truncate table JAQY346');
     execute immediate('Truncate table JAQY346_ERR');
     delete Tab_jobs where  c_Codage = 'DBM';
     commit;
     delete from log_error_bandeja a where a.c_codbdj ='DBM';
     commit;
     
     begin
    select host_name
      into lc_hostname
      from v$instance;
  end;



     for i in c_clientes_job loop
        ln_ini := i.digito;
        lc_variable := ' begin '|| '  PQ_CR_DEUDACLIENTE.sp_cr_carga_clientes('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
        --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
--         if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then             
--         if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
IF SYS.FN_BD_ISRAC='TRUE' THEN
           DBMS_JOB.SUBMIT(job => ln_job, 
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
                        instance => 1,
                        --instance => 2, 01/01/2024
                        force => false
                        );
          else
            DBMS_JOB.SUBMIT(job => ln_job, 
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
                        force => false
                        );
          end if;

        INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
        VALUES('DBM',ln_ini,lc_variable);
        COMMIT;
      end loop;
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'DBM',lc_coderr, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

end sp_job_Carga;        
procedure sp_cr_carga_clientes( P_C_DIGITO in varchar2,P_D_FECPRO in date) IS

     cursor c_clientes is
      select * from jaqy346CAB A
      WHERE substr(trim(a.c_codsbs), -1, 1) = P_C_DIGITO
       
      ;
      
     ln_salcap number(17,2);


     pn_res number(17,2);
     ld_fecrcc date;
     lc_coderr VARCHAR2(100);
     ln_ent number(10);
     ln_entTot number(10);
     ln_salcapTot number(17,2);
     
     ln_pai number(3);
     ln_tdoc number(2);
     lc_ndoc char(12);
     
     pn_cal number(10,5);
     pn_calSeg number(10,5);
     LC_PAC VARCHAR2(100);
     
     ln_sdoPyme number(17,2);
     ln_sdoCon  number(17,2);     
     ln_sdoHipo number(17,2);
     
  BEGIN
     update tab_jobs g
       set g.d_fecini = sysdate
     where g.n_numer1 = P_C_DIGITO
       and g.c_codage = 'DBM';
    commit;
    
   begin
     pn_cal := 100.00;
     pn_calSeg := 100.00;
     for c in c_clientes loop
         
              ln_salcapTot := null;  
              ln_ent := null;  
              ln_entTot := null;  
              pn_res := null;   
              ln_sdoPyme  := 0;
              ln_sdoCon   := 0;
              ln_sdoHipo  := 0;
              --ultima rcc
              begin
                select to_date(tpnro,'ddmmyyyy')
                  into ld_fecrcc
                  from FST098 f
                  Where Pgcod = 1
                    and Tpcod = 7647 
                    and  Tpcorr = 12;         
              end;
             
              --Calificacion
              If c.N_CALIF0 = 100.00 then
                        pn_cal := 100.00;
                    Else
                        If (c.N_CALIF0+ c.N_CALIF1+c.N_CALIF2+c.N_CALIF3+c.N_CALIF4=0) then
                            pn_cal := 100.00;
                        Else
                            pn_cal := 0.00;
                           
                        End If  ;          
             End If ;
              
             --nro de entidades
             ln_ent := pq_cr_deudacliente.fn_cant_instit(c.c_codsbs);
             
             --nro de entidades totales
             ln_entTot := pq_cr_deudacliente.fn_cant_instit_T(c.c_codsbs);
             --saldo total
             pq_cr_deudacliente.Sp_deudaTotal(c.c_codsbs, ln_salcapTot);
             
     
             ln_salcap := null;
             --deuda Bancos   
             pq_cr_deudacliente.sp_deudaPatrimonio(c.c_codsbs, ln_salcap );
             
             --calificacion segmetnacion   
             pq_cr_deudacliente.sp_segmentacion(c.c_codsbs,pn_calSeg);
                
             --equivalencia Bantotal  
              case
                when c.C_TDOCTR is not null and c.C_TDOCID is null then 
                      lc_ndoc := c.C_DOCTRI;
                      case
                        when c.C_TDOCTR = '1' then
                          ln_tdoc := 21;
                        when LENGTH(c.C_DOCTRI) < 11 and c.C_TDOCTR = '2' then 
                          ln_tdoc := 9;
                        when LENGTH(c.C_DOCTRI) >= 11 and c.C_TDOCTR = '2' then                     
                          ln_tdoc := 2;
                        when c.C_TDOCTR = '3' then 
                          ln_tdoc := 9;
                        when c.C_TDOCTR = '4' then 
                          ln_tdoc := 15;
                        when c.C_TDOCTR = '5' then 
                          ln_tdoc := 5;
                        when c.C_TDOCTR = '8' then 
                          ln_tdoc := 6;
                        else null;
                      end case;
                    
                when c.C_TDOCID is not null and c.C_TDOCTR is null then
                  lc_ndoc := c.C_DOCIDE;
                  case
                    when c.C_TDOCID = '1' then
                      ln_tdoc := 21;
                    when LENGTH(c.C_DOCIDE) < 11 and c.C_TDOCID = '2' then 
                      ln_tdoc := 9;
                    when LENGTH(c.C_DOCIDE) >= 11 and c.C_TDOCID = '2' then                     
                      ln_tdoc := 2;
                    when c.C_TDOCID = '3' then 
                      ln_tdoc := 9;
                    when c.C_TDOCID = '4' then 
                      ln_tdoc := 15;
                    when c.C_TDOCID = '5' then 
                      ln_tdoc := 5;
                    when c.C_TDOCID = '8' then 
                      ln_tdoc := 6;
                    else null;
                  end case;
                    
                when c.C_TDOCTR is not null and c.C_TDOCID is not null then
                   lc_ndoc := c.C_DOCIDE;
                   case
                     when c.C_TDOCID = '1' then
                       ln_tdoc := 21;
                     when LENGTH(c.C_DOCIDE) < 11 and c.C_TDOCID = '2' then 
                       ln_tdoc := 9;
                     when LENGTH(c.C_DOCIDE) >= 11 and c.C_TDOCID = '2' then                     
                       ln_tdoc := 2;
                     when c.C_TDOCID = '3' then 
                       ln_tdoc := 9;
                     when c.C_TDOCID = '4' then 
                       ln_tdoc := 15;
                     when c.C_TDOCID = '5' then 
                       ln_tdoc := 5;
                     when c.C_TDOCID = '8' then 
                       ln_tdoc := 6;
                     else null;
                   end case;
                else 
                  LC_PAC := 'sp_cr_carga_clientes';
                  INSERT INTO JAQY346_ERR
                  Values(LC_PAC,c.C_TDOCID,c.C_TDOCTR);
                  COMMIT;
                  lc_ndoc := null;
                  ln_tdoc := null;
                      
              end case;
               
                 
              if lc_ndoc is null then
                LC_PAC := 'sp_cr_carga_clientes_2';
                  INSERT INTO JAQY346_ERR
                  Values(LC_PAC,c.C_DOCIDE,c.C_DOCTRI);
                  COMMIT;
                      
              end if;
            
              --pais Bantotal
              begin
                select a.pepais
                  into ln_pai
                  from fsd001 a
                 where a.petdoc = ln_tdoc
                   and a.pendoc = lc_ndoc;
              exception
                when others then null;
              end;
              
              --saldo separado
              pq_cr_deudacliente.sp_hipconpym(c.c_codsbs,ln_sdoPyme,
                                                          ln_sdoCon ,
                                                          ln_sdoHipo);
                  
              BEGIN
                      INSERT INTO JAQY346 (JAQY346PAI, JAQY346TDO, JAQY346NDO, JAQY346FEC, JAQY346PAT,
                                          JAQY346ENT,JAQY346SDO,JAQY346CAL,JAQY346CAS,
                                          JAQY346SBS,JAQY346CPE,JAQY346HIP,JAQY346CON,JAQY346PYM,
                                          JAQY346ETO) 
                      VALUES (ln_pai, ln_tdoc, lc_ndoc, P_D_FECPRO, ln_salcap,
                             ln_ent,ln_salcapTot,pn_cal,pn_calSeg,c.c_codsbs,
                            c.C_PERSON,ln_sdoHipo,ln_sdoCon ,ln_sdoPyme,ln_entTot);
                      commit; 
                                                  
                      exception
                   when others then
                         lc_coderr:=sqlerrm;
                         INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
                         VALUES(0,'DBM',P_C_DIGITO||lc_coderr, TRUNC(SYSDATE));
                         COMMIT;
                                               
                END;
   
     end loop;
     commit;
     
     
      update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  P_C_DIGITO
       and g.c_codage = 'DBM';
    commit;
    end;
    
     EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = P_C_DIGITO
         and g.c_codage = 'DBM';
    commit;
    return;

END sp_cr_carga_clientes;

procedure sp_deudaTotal(cod_sbs in varchar2,  ln_salcap out number  ) is 

--cod_sbs varchar2(10);
ln_monto1 number(18,2);
ln_monto2 number(18,2);

begin
    
    begin
          
        select nvl(sum(n_salcap), 0)
          into ln_monto1
          from jaqy346det
         where c_codsbs = cod_sbs 
           and c_cretip <> 13
           and (substr(c_cuenta, 1, 4) IN
               ('1411', '1421', '1413', '1423', '1414', '1424', '1415',
                '1425', '1416', '1426') or
               substr(c_cuenta, 1, 4) in
               ('7111', '7121', '7112', '7122', '7113', '7123', '7114',
                '7124'));
      exception
      when no_Data_found then
        ln_monto1 := 0;
    end;
              
             
    begin
        select nvl(sum(n_salcap), 0)
          into ln_monto2
          from jaqy346det
         where c_codsbs = cod_sbs 
           and c_cretip <> 13
           and substr(c_cuenta, 1, 6) IN
             ('291101', '292101', '291102', '292102', '291104', '292104');  
    
    
    exception
      when no_Data_found then
        ln_monto2 := 0;
    end;
        
    ln_salcap:= ln_monto1 - ln_monto2;
               

           
end sp_deudaTotal;


procedure sp_deudaPatrimonio(cod_sbs in varchar2, ln_salcap out number  ) is 

--cod_sbs varchar2(10);

ln_monto1 number(18,2);
ln_monto2 number(18,2);

begin
    
    begin
          
        select nvl(sum(n_salcap), 0)
          into ln_monto1
          from jaqy346det
         where c_codsbs = cod_sbs 
           and c_cretip in ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10')
           and C_CODEMP <> '00104'
           and (substr(c_cuenta, 1, 4) IN
               ('1411', '1421', '1413', '1423', '1414', '1424', '1415',
                '1425', '1416', '1426') or
               substr(c_cuenta, 1, 4) in
               ('7111', '7121', '7112', '7122', '7113', '7123', '7114',
                '7124'));
      exception
      when no_Data_found then
        ln_monto1 := 0;
    end;
              
             
    begin
        select nvl(sum(n_salcap), 0)
          into ln_monto2
          from jaqy346det
         where c_codsbs = cod_sbs 
           and c_cretip in ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10')
           and C_CODEMP <> '00104'
           and substr(c_cuenta, 1, 6) IN
             ('291101', '292101', '291102', '292102', '291104', '292104');  
    
    
    exception
      when no_Data_found then
        ln_monto2 := 0;
    end;
        
    ln_salcap:= ln_monto1 - ln_monto2;
          
    
           
end sp_deudaPatrimonio;
/*procedure sp_carga_deuda is
  cursor credito is 
  select * from jaqy345_aux;
  
  ln_emp number(3);
  ln_mod number(3);
  ln_suc number(3);
  ln_mda number(4);
  ln_pap number(4);
  ln_cta number(9);
  ln_ope number(9);
  ln_sbo number(3);
  ln_top number(3);
  
begin  
 begin
            insert into pru_fec 
            select b.pepais,
                   b.petdoc,
                   b.pendoc,
                   max(aofval)
              from fsd010 a,fsr008 b
             where a.pgcod=1
               and a.aomod in (select modulo from fst111 where dscod = 50)
               and a.aostat <> 99
               and a.aocta = b.ctnro
               and b.cttfir = 'T';
              commit;
    end;
    begin
              for i in creditos loop
                  begin
                    select a.pgcod,
                           a.aomod,
                           a.aosuc,
                           a.aomda,
                           a.aopap,
                           a.aocta,
                           a.aooper,
                           a.aosbop,
                           a.aotope
                      into ln_emp,
                           ln_mod,
                           ln_suc,
                           ln_mda,
                           ln_pap,
                           ln_cta,
                           ln_ope,
                           ln_sbo,
                           ln_top
                      from fsd010 a,fsr008 b
                     where a.pgcod=1
                       and a.aomod in (select modulo from fst111 where dscod = 50)
                       and a.aostat <> 99
                       and a.aocta = b.ctnro
                       and b.cttfir = 'T'
                       and b.pepais = i.jaqy345pai
                       and b.petdoc = i.jaqy345tdo
                       and b.pendoc = i.jaqy345ndo
                       and a.aofval = 
                       and rownum = 1
                      
                  end;
                
              end loop;
    end;
end;*/
Procedure sp_job_deudabantotal (pd_fecpro in date ) is
  --ln_max number;
  --ln_inc number;
  ln_ini number;
  --ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  --lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor c_clientes_job is 
		  select distinct j.jaqy345dig digito
          from jaqy345_aux j;
         
  begin
     execute immediate('Truncate table JAQY345');
     execute immediate('Truncate table JAQY345_AUX');
     delete Tab_jobs where  c_Codage = 'DB';
     commit;
     delete from log_error_bandeja a where a.c_codbdj ='DB';
     commit;
     begin
            insert into jaqy345_aux
            select a.jaql982pais,
                   a.jaql982tid,
                   a.jaql982doc,
                   substr(trim(a.jaql982doc), -1, 1),
                   sum(a.jaql982scap)
              from jaql982 a
             group by a.jaql982pais,
                   a.jaql982tid,
                   a.jaql982doc,
                   substr(trim(a.jaql982doc), -1, 1);
              commit;
    end;
  
  begin
    select host_name
      into lc_hostname
      from v$instance;
  end;


     for i in c_clientes_job loop
        ln_ini := i.digito;
        lc_variable := ' begin '|| '  PQ_CR_DEUDACLIENTE.sp_deudabantotal('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
        --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
--         if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then             
--         if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
IF SYS.FN_BD_ISRAC='TRUE' THEN
           DBMS_JOB.SUBMIT(job => ln_job, 
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
                      --  instance => 2, -- 24/10/2023
                        instance => 1,
                        force => false
                        );
          else
            DBMS_JOB.SUBMIT(job => ln_job, 
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
                        force => false
                        );
          end if;

        INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
        VALUES('DB',ln_ini,lc_variable);
        COMMIT;
      end loop;
  exception
     when others then
           --lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'DB',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

  end sp_job_deudabantotal;    
procedure sp_deudabantotal (P_C_DIGITO in varchar2 ,pd_fecpro in date)is
  
  cursor creditos is
   select *
    from jaqy345_aux a
    WHERE a.jaqy345dig = P_C_DIGITO;
    
    
  ln_captotcaja number(17,2);
 
  ln_SegLinea number(2);
  pn_res number(17,2);
  pn_pat number(17,2);
  
  ln_sacap number(17,2);
  lc_coderr varchar2(300);
  
begin
/*    select j.jaql983cor ln_corr, j.jaql983ffi ln_fecf
      from jaql983 j
     where j.jaql983cor > 14
       and j.jaql983ffi <> null;*/
       
    update tab_jobs g
       set g.d_fecini = sysdate
     where g.n_numer1 = P_C_DIGITO
       and g.c_codage = 'DB';
    commit;
  begin
    
     for i in creditos loop
       

     
      begin
        select b.segcod
        into ln_SegLinea
        from sngc60 a,sngc07 b
        where a.sngc60pais = i.jaqy345pai
         and a.sngc60tdoc  = i.jaqy345tdo
         and a.sngc60ndoc = i.jaqy345ndo
         and a.sngc60ocup = b.sngc07cod;
        exception 
        when others then null;
      end; 

      if i.jaqy345tdo = 9 then
      ln_SegLinea := 1;
      end if;

      if ln_SegLinea = 1 then
        
        --pyme
                         
        pq_cr_deudacliente.sp_cuentas(i.jaqy345pai,i.jaqy345tdo,i.jaqy345ndo,pd_fecpro,ln_captotcaja,ln_sacap);
        pq_cr_deudacliente.Sp_ResNeto_ExcMens_Dia(i.jaqy345pai,i.jaqy345tdo,i.jaqy345ndo,pd_fecpro,
                                                  1,pn_res,pn_pat);
        
        begin          
            insert into JAQY345 (JAQY345PAI, JAQY345TDO, JAQY345NDO,JAQY345FEC,JAQY345CUR,
                                 JAQY345RES,JAQY345PAT,JAQY345BAN)   
            values(i.jaqy345pai,i.jaqy345tdo,i.jaqy345ndo,pd_fecpro,ln_captotcaja,
                   pn_res,pn_pat,ln_sacap);
            commit;
        exception
             when others then
                   lc_coderr:=sqlerrm;
                   INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
                   VALUES(0,'DB',P_C_DIGITO||lc_coderr, TRUNC(SYSDATE));
                   COMMIT;
             
        end;
        
        
  
      else 
      --consumo
       pq_cr_deudacliente.sp_cuentas(i.jaqy345pai,i.jaqy345tdo,i.jaqy345ndo,pd_fecpro,ln_captotcaja,ln_sacap);
       pq_cr_deudacliente.Sp_ResNeto_ExcMens_Dia(i.jaqy345pai,i.jaqy345tdo,i.jaqy345ndo,pd_fecpro,
                                                 2,pn_res,pn_pat);
        
        BEGIN          
        insert into JAQY345 (JAQY345PAI, JAQY345TDO, JAQY345NDO,JAQY345FEC,JAQY345CUR,JAQY345RES,
                             JAQY345PAT,JAQY345BAN)   
        values(i.jaqy345pai,i.jaqy345tdo,i.JAQY345NDO,pd_fecpro,ln_captotcaja,pn_res,pn_pat,ln_sacap);
        commit;
        
         exception
             when others then
                   lc_coderr:=sqlerrm;
                   INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
                   VALUES(0,'DB',P_C_DIGITO||lc_coderr, TRUNC(SYSDATE));
                   COMMIT;
             
        end;
        
               
      end if;    

  end loop;
  commit;
  
  end;
  
    update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  P_C_DIGITO
       and g.c_codage = 'DB';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = P_C_DIGITO
         and g.c_codage = 'DB';
    commit;
    return;

end sp_deudabantotal;


procedure sp_cuentas(ln_Pepais     in number,
                       ln_Petdoc     in number,
                       ln_Pendoc     in char,
                       pd_fecpro     in date,
                       ln_captotcaja out number,
                       ln_saldoTot   out number) is
  
    ln_capacidad   number;
    
    lc_fgAdic    varchar2(1); --mod 2016.04.12
    lc_fgAmpl    varchar2(1); --mod 2016.04.12
    lc_ven       char(1); --mod 2016.04.12
    ln_indicador number; --mod 2016.04.12
  
    tipocambio number(14,8);
    ln_sdo number(17,2);
    ln_parciales  number;
    ln_instancia  number;
    lc_fgtip varchar2(1);
    
    cursor inserta is
      select d10.pgcod    ln_pgcod10,
             d10.aomod    ln_mod10,
             d10.aosuc    ln_suc10,
             d10.aomda    ln_mda10,
             d10.aopap    ln_pap10,
             d10.aocta    ln_cta10,
             d10.aooper   ln_oper10,
             d10.aosbop   ln_sbop10,
             d10.aotope   ln_tope10,
             d10.aoperiod ln_peri10
      
        from fsd010 d10
       where Pgcod = 1
         and Aocta in (select Ctnro
                         from fsr008
                        where pepais = ln_Pepais
                          and Petdoc = ln_Petdoc
                          and pendoc = ln_Pendoc
                          and Ttcod = 1
                          and Cttfir = 'T'
                       )
          and (Aomod in (select modulo
                         from fst111
                        where dscod = 50
                       and modulo not in ((select a.tp1nro1
                               from fst198 a
                              where a.tp1cod = 1 --mod@abr 20180308
                                and a.tp1cod1 = 10899
                                and a.tp1corr1 = 23
                                and a.tp1corr2 = 3))
                           )or Aomod=117)
         and Aostat <> 99
         and aofvto > pd_fecpro;
     
  
    cursor vuelo is
    
      select x.xwfempresa ln_pgcod10,
             x.xwfmodulo ln_mod10,
             x.xwfsucursal ln_suc10,
             x.xwfmoneda ln_mda10,
             x.xwfpapel ln_pap10,
             x.xwfcuenta ln_cta10,
             x.xwfoperacion ln_oper10,
             x.xwfsubope ln_sbop10,
             x.xwftipope ln_tope10,
             max(s.sng120per) ln_peri10
        from xwf700 x, sng120 s
       where x.xwfempresa = 1
          and xwfcuenta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc
                              and Ttcod = 1
                              and Cttfir = 'T'
                           )
                           
           and (xwfmodulo in (select modulo
                         from fst111
                        where dscod = 50
                       and modulo not in ((select a.tp1nro1
                               from fst198 a
                              where a.tp1cod = 1 --mod@abr 20180308
                                and a.tp1cod1 = 10899
                                and a.tp1corr1 = 23
                                and a.tp1corr2 = 3))
                          ) or xwfmodulo=117)                 
                           
        and XWFPRCINS in
             (select wfinsprcid
                from wfwrkitems wf
               where wf.wfinsprcid = x.xwfprcins
                 and wf.WFSTSCOD not in ('C', 'D', 'B', 'E','T')
                 and wf.wfiteminit =
                     (select max(wfiteminit)
                        from wfwrkitems w
                       where w.wfinsprcid = x.xwfprcins
                         and w.WFSTSCOD not in ('C', 'D', 'B', 'E','T')
                         and w.wfiteminit >=to_date('2013.07.01','yyyy.mm.dd'))--20160519
                 and wf.wfiteminit >=to_date('2013.07.01','yyyy.mm.dd'))--20160519
         and sng120ins = XWFPRCINS
         and x.xwfcar3 = '1'
      
       group by x.xwfempresa,
                x.xwfmodulo,
                x.xwfsucursal,
                x.xwfmoneda,
                x.xwfpapel,
                x.xwfcuenta,
                x.xwfoperacion,
                x.xwfsubope,
                x.xwftipope
      ;
  
    cursor lineas_ven is
    
      select d10.pgcod    ln_pgcod10,
             d10.aomod    ln_mod10,
             d10.aosuc    ln_suc10,
             d10.aomda    ln_mda10,
             d10.aopap    ln_pap10,
             d10.aocta    ln_cta10,
             d10.aooper   ln_oper10,
             d10.aosbop   ln_sbop10,
             d10.aotope   ln_tope10,
             d10.aoperiod ln_peri10
      
        from fsd010 d10
       where Pgcod = 1
         and Aocta in (select Ctnro
                         from fsr008
                        where pepais = ln_Pepais
                          and Petdoc = ln_Petdoc
                          and pendoc = ln_Pendoc
                          and Ttcod = 1
                          and Cttfir = 'T'
                       )
         and Aomod = 117
         and aofvto < pd_fecpro
         --and Aostat = 99
      
     ;
  
  begin
  
    ln_captotcaja := 0;
    ln_saldoTot := 0;
    for i in inserta loop
      lc_fgtip     := null; 
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      ln_capacidad := 0;
      ln_sdo       := 0;
      --tipo de cambio
      begin
          select cotcbi
            into tipocambio
            from fsh005 f
           where cofdes in (select max(cofdes)
                             from fsh005 g
                            where g.cofdes <= to_Date(pd_fecpro ,'yyyy.mm.dd')
                              and moneda = 101)
             and moneda = 101;
        exception when no_data_found then
           tipocambio := 0;            
           when others then
           tipocambio := 0;  
        end;
            
      pq_cr_deudacliente.Sp_Adicional_CK(i.ln_mod10,i.ln_tope10, lc_fgAdic);
      pq_cr_deudacliente.Sp_ampliados_CK(i.ln_pgcod10,
                                              i.ln_mod10,
                                              i.ln_suc10,
                                              i.ln_mda10,
                                              i.ln_pap10,
                                              i.ln_cta10,
                                              i.ln_oper10,
                                              i.ln_sbop10,
                                              i.ln_tope10,
                                              lc_fgAmpl);
      pq_cr_deudacliente.sp_tipOpe_ck(i.ln_mod10,i.ln_tope10,lc_fgtip);
      --pq_cr_deudacliente
      if lc_fgAdic <> 'S' and lc_fgAmpl <> 'S' then
        pq_cr_deudacliente.sp_resolutor(i.ln_pgcod10,
                                             i.ln_mod10,
                                             i.ln_suc10,
                                             i.ln_mda10,
                                             i.ln_pap10,
                                             i.ln_cta10,
                                             i.ln_oper10,
                                             i.ln_sbop10,
                                             i.ln_tope10,
                                             i.ln_peri10,
                                             tipocambio,
                                             ln_indicador,
                                             ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
        
   
         
      end if;
      --SALDO CAPITAL
      if lc_fgAmpl <> 'S' and lc_fgtip = 'S' then
         pq_cr_deudacliente.sp_instancia(i.ln_mod10,
                                         i.ln_suc10,
                                         i.ln_mda10,
                                         i.ln_pap10,
                                         i.ln_cta10,
                                         i.ln_oper10,
                                         i.ln_sbop10,
                                         i.ln_tope10,
                                         ln_parciales,
                                         ln_instancia);  
          if i.ln_mod10 <> 117 then
             begin
              select - a.scsdo
                into ln_sdo
                from fsd011 a
               where a.pgcod  = i.ln_pgcod10
                 and a.scmod  = i.ln_mod10
                 and a.scsuc  = i.ln_suc10
                 and a.scmda  = i.ln_mda10
                 and a.scpap  = i.ln_pap10
                 and a.sccta  = i.ln_cta10
                 and a.scoper = i.ln_oper10
                 and a.scsbop = i.ln_sbop10
                 and a.sctope = i.ln_tope10;
             exception
               when others then
                    ln_sdo := 0; 
             end;
             
             if ln_parciales = 7 then
                --Desembolsos parciales contabilizados
                
                begin
                  select a.sng120mto
                    into ln_sdo
                    from sng120 a
                   where a.sng120ins = ln_instancia
                     and a.sng120tsk like 'APROBAC%'
                     and rownum = 1;
                exception
                  when others then
                    ln_sdo := 0; 
                end;
                  
                
                 
             end if;
        
      
          end if;
          
          if i.ln_mod10 = 117 then
             begin
              select aoimp
                into ln_sdo
                from fsd010 a
               where a.pgcod  = i.ln_pgcod10
                 and a.aomod  = i.ln_mod10
                 and a.aosuc  = i.ln_suc10
                 and a.aomda  = i.ln_mda10
                 and a.aopap  = i.ln_pap10
                 and a.aocta  = i.ln_cta10
                 and a.aooper = i.ln_oper10
                 and a.aosbop = i.ln_sbop10
                 and a.aotope = i.ln_tope10;
             exception
               when others then
                    ln_sdo := 0;    
             end;

          end if;
          if i.ln_mda10 = 101 then
             ln_sdo := ln_sdo * tipocambio;
          end if;
          ln_saldoTot := nvl(ln_saldoTot, 0) + nvl(ln_sdo, 0);
         end if; 
    end loop;
  
    for c in vuelo loop
      ln_indicador := 2;
      lc_fgtip     := null; 
      ln_capacidad := 0;
      ln_sdo       := 0;
      pq_cr_deudacliente.sp_resolutor(c.ln_pgcod10,
                                           c.ln_mod10,
                                           c.ln_suc10,
                                           c.ln_mda10,
                                           c.ln_pap10,
                                           c.ln_cta10,
                                           c.ln_oper10,
                                           c.ln_sbop10,
                                           c.ln_tope10,
                                           c.ln_peri10,
                                           tipocambio,
                                           ln_indicador,
                                           ln_capacidad);
    
      ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      pq_cr_deudacliente.sp_tipOpe_ck(c.ln_mod10,c.ln_tope10,lc_fgtip);
      
      if lc_fgtip = 'S' then
          --SALDO CAPITAL
          begin
            select a.xwfmonto1
              into ln_sdo
              from xwf700 a
             where a.xwfempresa   = c.ln_pgcod10
               and a.xwfsucursal  = c.ln_suc10
               and a.xwfmodulo    = c.ln_mod10
               and a.xwfmoneda    = c.ln_mda10
               and a.xwfpapel     = c.ln_pap10
               and a.xwfcuenta    = c.ln_cta10
               and a.xwfoperacion = c.ln_oper10
               and a.xwfsubope    = c.ln_sbop10
               and a.xwftipope    = c.ln_tope10
               and a.xwfcar3      = '1';
          exception
               when others then ln_sdo := 0;
          end;
          
          pq_cr_deudacliente.sp_instancia(c.ln_mod10,
                                          c.ln_suc10,
                                          c.ln_mda10,
                                          c.ln_pap10,
                                          c.ln_cta10,
                                          c.ln_oper10,
                                          c.ln_sbop10,
                                          c.ln_tope10,
                                          ln_parciales,
                                          ln_instancia);  
          if ln_parciales = 7 then
             --Desembolsos parciales en vuelo
                
              begin
                select a.sng120mto
                  into ln_sdo
                  from sng120 a
                 where a.sng120ins = ln_instancia
                   and a.sng120tsk like 'PROPUES%'
                   and rownum = 1;
              exception
                when others then
                  ln_sdo := 0;
              end;
                       
                     
                      
          end if;                                     
         
          if c.ln_mda10 = 101 then
             ln_sdo := ln_sdo * tipocambio;
          end if;
          
          ln_saldoTot := nvl(ln_saldoTot, 0) + nvl(ln_sdo, 0);
      end if;
      
    end loop;
  
    --mod 2016.04.13
    for j in lineas_ven loop
      ln_indicador := 3;
      ln_capacidad := 0;
      ln_sdo       := 0;
      
      begin
        select 'S'
          into lc_ven
          from fsr011 a, fsd010 b
         where a.r2cod = j.ln_pgcod10
           and a.r2mod = j.ln_mod10
           and a.r2suc = j.ln_suc10
           and a.r2mda = j.ln_mda10
           and a.r2pap = j.ln_pap10
           and a.r2cta = j.ln_cta10
           and a.r2oper = j.ln_oper10
           and a.r2sbop = j.ln_sbop10
           and a.r2tope = j.ln_tope10
           and a.r1cod = b.pgcod
           and a.r1mod = b.aomod
           and a.r1suc = b.aosuc
           and a.r1mda = b.aomda
           and a.r1pap = b.aopap
           and a.r1cta = b.aocta
           and a.r1oper = b.aooper
           and a.r1sbop = b.aosbop
           and a.r1tope = b.aotope
           and b.aostat <> 99
           and relcod = 46
           and rownum = 1;
      exception
        when no_data_found then
          lc_ven := 'N';
      end;
    
      lc_fgAdic := null;
    
      pq_cr_deudacliente.Sp_Adicional_CK(j.ln_mod10,j.ln_tope10, lc_fgAdic);
      
      if lc_ven = 'S' then
        pq_cr_deudacliente.sp_resolutor_venc(j.ln_pgcod10,
                                             j.ln_mod10,
                                             j.ln_suc10,
                                             j.ln_mda10,
                                             j.ln_pap10,
                                             j.ln_cta10,
                                             j.ln_oper10,
                                             j.ln_sbop10,
                                             j.ln_tope10,
                                            -- j.ln_peri10,
                                             tipocambio,
                                            -- ln_indicador,
                                             ln_capacidad,
                                             ln_sdo);
        ln_saldoTot := nvl(ln_saldoTot, 0) + nvl(ln_sdo, 0);   
        
        if lc_fgAdic <> 'S'  then
        
      
          ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
        end if;                                  
         
      end if;  
      
    
    end loop;
  

  
  end sp_cuentas;
------------------------------------------------------------------------
procedure sp_SaldoCapital(ln_Pepais     in number,
                       ln_Petdoc     in number,
                       ln_Pendoc     in char,
                       pd_fecpro     in date,
                       ln_captotcaja out number) is
  
    lc_fgAdic    varchar2(1); --mod 2016.04.12
    lc_fgAmpl    varchar2(1); --mod 2016.04.12
    lc_ven       char(1); --mod 2016.04.12
    ln_indicador number; --mod 2016.04.12
    ln_parciales  number;
    ln_instancia  number;
    ln_sdo number(17,2);
    tipocambio number(14,8);
    
    cursor inserta is
      select d10.pgcod    ln_pgcod10,
             d10.aomod    ln_mod10,
             d10.aosuc    ln_suc10,
             d10.aomda    ln_mda10,
             d10.aopap    ln_pap10,
             d10.aocta    ln_cta10,
             d10.aooper   ln_oper10,
             d10.aosbop   ln_sbop10,
             d10.aotope   ln_tope10,
             d10.aoperiod ln_peri10
      
        from fsd010 d10
       where Pgcod = 1
         and Aocta in (select Ctnro
                         from fsr008
                        where pepais = ln_Pepais
                          and Petdoc = ln_Petdoc
                          and pendoc = ln_Pendoc
                          and Ttcod = 1
                          and Cttfir = 'T'
                       )
          and (Aomod in (select modulo
                         from fst111
                        where dscod = 50
                       and modulo not in ((select a.tp1nro1
                               from fst198 a
                              where a.tp1cod = 1 --mod@abr 20180308
                                and a.tp1cod1 = 10899
                                and a.tp1corr1 = 13
                                and a.tp1corr2 = 1))
                           )or Aomod=117)
         and Aostat <> 99
         and aofvto > pd_fecpro;
     
  
    cursor vuelo is
    
      select x.xwfempresa ln_pgcod10,
             x.xwfmodulo ln_mod10,
             x.xwfsucursal ln_suc10,
             x.xwfmoneda ln_mda10,
             x.xwfpapel ln_pap10,
             x.xwfcuenta ln_cta10,
             x.xwfoperacion ln_oper10,
             x.xwfsubope ln_sbop10,
             x.xwftipope ln_tope10,
             max(s.sng120per) ln_peri10
        from xwf700 x, sng120 s
       where x.xwfempresa = 1
          and xwfcuenta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc
                              and Ttcod = 1
                              and Cttfir = 'T'
                           )
                           
           and (xwfmodulo in (select modulo
                         from fst111
                        where dscod = 50
                       and modulo not in ((select a.tp1nro1
                               from fst198 a
                              where a.tp1cod = 1 --mod@abr 20180308
                                and a.tp1cod1 = 10899
                                and a.tp1corr1 = 13
                                and a.tp1corr2 = 1))
                          ) or xwfmodulo=117)                 
                           
        and XWFPRCINS in
             (select wfinsprcid
                from wfwrkitems wf
               where wf.wfinsprcid = x.xwfprcins
                 and wf.WFSTSCOD not in ('C', 'D', 'B', 'E','T')
                 and wf.wfiteminit =
                     (select max(wfiteminit)
                        from wfwrkitems w
                       where w.wfinsprcid = x.xwfprcins
                         and w.WFSTSCOD not in ('C', 'D', 'B', 'E','T')
                         and w.wfiteminit >=to_date('2013.07.01','yyyy.mm.dd'))--20160519
                 and wf.wfiteminit >=to_date('2013.07.01','yyyy.mm.dd'))--20160519
         and sng120ins = XWFPRCINS
         and x.xwfcar3 = '1'
      
       group by x.xwfempresa,
                x.xwfmodulo,
                x.xwfsucursal,
                x.xwfmoneda,
                x.xwfpapel,
                x.xwfcuenta,
                x.xwfoperacion,
                x.xwfsubope,
                x.xwftipope
      ;
  
    cursor lineas_ven is
    
      select d10.pgcod    ln_pgcod10,
             d10.aomod    ln_mod10,
             d10.aosuc    ln_suc10,
             d10.aomda    ln_mda10,
             d10.aopap    ln_pap10,
             d10.aocta    ln_cta10,
             d10.aooper   ln_oper10,
             d10.aosbop   ln_sbop10,
             d10.aotope   ln_tope10,
             d10.aoperiod ln_peri10
      
        from fsd010 d10
       where Pgcod = 1
         and Aocta in (select Ctnro
                         from fsr008
                        where pepais = ln_Pepais
                          and Petdoc = ln_Petdoc
                          and pendoc = ln_Pendoc
                          and Ttcod = 1
                          and Cttfir = 'T'
                       )
         and Aomod = 117
         and aofvto < pd_fecpro
         --and Aostat = 99
      
     ;
  
  begin
  
    ln_captotcaja := 0;
  
    for i in inserta loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      
      --tipo de cambio
      begin
          select cotcbi
            into tipocambio
            from fsh005 f
           where cofdes in (select max(cofdes)
                             from fsh005 g
                            where g.cofdes <= to_Date(pd_fecpro ,'yyyy.mm.dd')
                              and moneda = 101)
             and moneda = 101;
        exception when no_data_found then
           tipocambio := 0;
           when others then            
             tipocambio := 0;
        end;
            
      pq_cr_deudacliente.Sp_ampliados_CK(i.ln_pgcod10,
                                              i.ln_mod10,
                                              i.ln_suc10,
                                              i.ln_mda10,
                                              i.ln_pap10,
                                              i.ln_cta10,
                                              i.ln_oper10,
                                              i.ln_sbop10,
                                              i.ln_tope10,
                                              lc_fgAmpl);
    
      if lc_fgAmpl <> 'S' then
         pq_cr_deudacliente.sp_instancia(i.ln_mod10,
                                         i.ln_suc10,
                                         i.ln_mda10,
                                         i.ln_pap10,
                                         i.ln_cta10,
                                         i.ln_oper10,
                                         i.ln_sbop10,
                                         i.ln_tope10,
                                         ln_parciales,
                                         ln_instancia);  
          if i.ln_mod10 <> 117 then
             begin
              select - a.scsdo
                into ln_sdo
                from fsd011 a
               where a.pgcod  = i.ln_pgcod10
                 and a.scmod  = i.ln_mod10
                 and a.scsuc  = i.ln_suc10
                 and a.scmda  = i.ln_mda10
                 and a.scpap  = i.ln_pap10
                 and a.sccta  = i.ln_cta10
                 and a.scoper = i.ln_oper10
                 and a.scsbop = i.ln_sbop10
                 and a.sctope = i.ln_tope10;
             exception
               when others then
                    ln_sdo := 0; 
             end;
             
             if ln_parciales = 7 then
                --Desembolsos parciales contabilizados
                
                begin
                  select a.sng120mto
                    into ln_sdo
                    from sng120 a
                   where a.sng120ins = ln_instancia
                     and a.sng120tsk like 'APROBAC%'
                     and rownum = 1;
                exception
                  when others then
                    null;
                end;
                  
                
                 
             end if;
        
      
          end if;
          
          if i.ln_mod10 = 117 then
             begin
              select aoimp
                into ln_sdo
                from fsd010 a
               where a.pgcod  = i.ln_pgcod10
                 and a.aomod  = i.ln_mod10
                 and a.aosuc  = i.ln_suc10
                 and a.aomda  = i.ln_mda10
                 and a.aopap  = i.ln_pap10
                 and a.aocta  = i.ln_cta10
                 and a.aooper = i.ln_oper10
                 and a.aosbop = i.ln_sbop10
                 and a.aotope = i.ln_tope10;
             exception
               when others then
                    ln_sdo := 0;    
             end;

          end if;
          if i.ln_mda10 = 101 then
             ln_sdo := ln_sdo * tipocambio;
          end if;
            
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_sdo, 0);
      end if;
    
    end loop;
  
    for c in vuelo loop
      ln_indicador := 2;
      begin
        select a.xwfmonto1
          into ln_sdo
          from xwf700 a
         where a.xwfempresa   = c.ln_pgcod10
           and a.xwfsucursal  = c.ln_suc10
           and a.xwfmodulo    = c.ln_mod10
           and a.xwfmoneda    = c.ln_mda10
           and a.xwfpapel     = c.ln_pap10
           and a.xwfcuenta    = c.ln_cta10
           and a.xwfoperacion = c.ln_oper10
           and a.xwfsubope    = c.ln_sbop10
           and a.xwftipope    = c.ln_tope10
           and a.xwfcar3      = '1';
      exception
           when others then ln_sdo := 0;
      end;
      
      pq_cr_deudacliente.sp_instancia(c.ln_mod10,
                                      c.ln_suc10,
                                      c.ln_mda10,
                                      c.ln_pap10,
                                      c.ln_cta10,
                                      c.ln_oper10,
                                      c.ln_sbop10,
                                      c.ln_tope10,
                                      ln_parciales,
                                      ln_instancia);  
      if ln_parciales = 7 then
         --Desembolsos parciales en vuelo
            
          begin
            select a.sng120mto
              into ln_sdo
              from sng120 a
             where a.sng120ins = ln_instancia
               and a.sng120tsk like 'PROPUES%'
               and rownum = 1;
          exception
            when others then
              null;
          end;
                   
                 
                  
      end if;                                     
     
      if c.ln_mda10 = 101 then
         ln_sdo := ln_sdo * tipocambio;
      end if;
      
      ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_sdo, 0);
    end loop;
  
    --mod 2016.04.13
    for j in lineas_ven loop
      ln_indicador := 3;
      begin
        select 'S'
          into lc_ven
          from fsr011 a, fsd010 b
         where a.r2cod = j.ln_pgcod10
           and a.r2mod = j.ln_mod10
           and a.r2suc = j.ln_suc10
           and a.r2mda = j.ln_mda10
           and a.r2pap = j.ln_pap10
           and a.r2cta = j.ln_cta10
           and a.r2oper = j.ln_oper10
           and a.r2sbop = j.ln_sbop10
           and a.r2tope = j.ln_tope10
           and a.r1cod = b.pgcod
           and a.r1mod = b.aomod
           and a.r1suc = b.aosuc
           and a.r1mda = b.aomda
           and a.r1pap = b.aopap
           and a.r1cta = b.aocta
           and a.r1oper = b.aooper
           and a.r1sbop = b.aosbop
           and a.r1tope = b.aotope
           and b.aostat <> 99
           and relcod = 46
           and rownum = 1;
      exception
        when no_data_found then
          lc_ven := 'N';
      end;
    
    
    
      
    
      if lc_ven = 'S' then
        pq_cr_deudacliente.sp_cal_lin_venc(j.ln_pgcod10,
                                             j.ln_mod10,
                                             j.ln_suc10,
                                             j.ln_mda10,
                                             j.ln_pap10,
                                             j.ln_cta10,
                                             j.ln_oper10,
                                             j.ln_sbop10,
                                             j.ln_tope10,
                                             tipocambio,
                                             ln_sdo);
        
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_sdo, 0);
      end if;
    
    end loop;
  

  
end sp_SaldoCapital; 
--------------------------------------------------
  procedure sp_cal_lin_venc(ln_pgcod10   in number,
                         ln_mod10     in number,
                         ln_suc10     in number,
                         ln_mda10     in number,
                         ln_pap10     in number,
                         ln_cta10     in number,
                         ln_oper10    in number,
                         ln_sbop10    in number,
                         ln_tope10    in number,
                         tipocambio   in number,
                         ln_capacidad out number) is

    lc_ven        char(1);
  
    cursor creditos is
      select a.r1cod  ln_pgcod10,
             a.r1mod  ln_mod10,
             a.r1suc  ln_suc10,
             a.r1mda  ln_mda10,
             a.r1pap  ln_pap10,
             a.r1cta  ln_cta10,
             a.r1oper ln_oper10,
             a.r1sbop ln_sbop10,
             a.r1tope ln_tope10
        from fsr011 a, fsd010 b
       where a.r2cod = ln_pgcod10
         and a.r2mod = ln_mod10
         and a.r2suc = ln_suc10
         and a.r2mda = ln_mda10
         and a.r2pap = ln_pap10
         and a.r2cta = ln_cta10
         and a.r2oper = ln_oper10
         and a.r2sbop = ln_sbop10
         and a.r2tope = ln_tope10
         and a.r1cod = b.pgcod
         and a.r1mod = b.aomod
         and a.r1suc = b.aosuc
         and a.r1mda = b.aomda
         and a.r1pap = b.aopap
         and a.r1cta = b.aocta
         and a.r1oper = b.aooper
         and a.r1sbop = b.aosbop
         and a.r1tope = b.aotope
         and b.aostat <> 99
         and relcod = 46;
 
    ln_capTem number;
  
  begin
  
    begin
      select 'S'
        into lc_ven
        from fsr011 a, fsd010 b
       where a.r2cod = ln_pgcod10
         and a.r2mod = ln_mod10
         and a.r2suc = ln_suc10
         and a.r2mda = ln_mda10
         and a.r2pap = ln_pap10
         and a.r2cta = ln_cta10
         and a.r2oper = ln_oper10
         and a.r2sbop = ln_sbop10
         and a.r2tope = ln_tope10
         and a.r1cod = b.pgcod
         and a.r1mod = b.aomod
         and a.r1suc = b.aosuc
         and a.r1mda = b.aomda
         and a.r1pap = b.aopap
         and a.r1cta = b.aocta
         and a.r1oper = b.aooper
         and a.r1sbop = b.aosbop
         and a.r1tope = b.aotope
         and b.aostat <> 99
         and relcod = 46
         and rownum = 1;
    exception
      when no_data_found then
        lc_ven := 'N';
    end;
  
    if lc_ven = 'S' then
      for i in creditos loop
      
        begin
          select - a.scsdo
            into ln_capTem
            from fsd011 a
           where a.pgcod  = i.ln_pgcod10
             and a.scsuc  = i.ln_mod10
             and a.scmod  = i.ln_suc10
             and a.scmda  = i.ln_mda10
             and a.scpap  = i.ln_pap10
             and a.sccta  = i.ln_cta10
             and a.scoper = i.ln_oper10
             and a.scsbop = i.ln_sbop10
             and a.sctope = i.ln_tope10;
        exception when others then ln_capTem := 0;   
        end;
        if i.ln_mda10 = 101 then
           ln_capTem := ln_capTem * tipocambio;
        end if;
        
        ln_capacidad := nvl(ln_capacidad, 0) + nvl(ln_capTem, 0);
      
      end loop;
    end if;
  
  end sp_cal_lin_venc;
----------------------------------------------------------------   
procedure sp_resolutor(ln_pgcod10   in number,
                         ln_mod10     in number,
                         ln_suc10     in number,
                         ln_mda10     in number,
                         ln_pap10     in number,
                         ln_cta10     in number,
                         ln_oper10    in number,
                         ln_sbop10    in number,
                         ln_tope10    in number,
                         ln_peri10    in number,
                         tipocambio   in number,
                         ln_indicador in number,
                         ln_capacidad out number) is
    ln_nrocuotas  number;
    ln_parciales  number;
    ln_cuotimp    number;
    ln_seguro     number;
    fech_maxcuota date;
    ln_instancia  number;
    --lc_ven        char(1);
  
  begin
  
  
    
      pq_cr_deudacliente.sp_cuotas(ln_pgcod10,
                                        ln_mod10,
                                        ln_suc10,
                                        ln_mda10,
                                        ln_pap10,
                                        ln_cta10,
                                        ln_oper10,
                                        ln_sbop10,
                                        ln_tope10,
                                        ln_nrocuotas);
    
      pq_cr_deudacliente.sp_instancia(ln_mod10,
                                           ln_suc10,
                                           ln_mda10,
                                           ln_pap10,
                                           ln_cta10,
                                           ln_oper10,
                                           ln_sbop10,
                                           ln_tope10,
                                           ln_parciales,
                                           ln_instancia);
    
      if ln_mod10 <> 117 then
        pq_cr_deudacliente.sp_cuota_impaga(ln_pgcod10,
                                                ln_mod10,
                                                ln_suc10,
                                                ln_mda10,
                                                ln_pap10,
                                                ln_cta10,
                                                ln_oper10,
                                                ln_sbop10,
                                                ln_tope10,
                                                tipocambio,
                                                ln_cuotimp,
                                                fech_maxcuota);
      end if;
    
      pq_cr_deudacliente.sp_seguro(ln_mod10,
                                        ln_suc10,
                                        ln_mda10,
                                        ln_pap10,
                                        ln_cta10,
                                        ln_oper10,
                                        ln_sbop10,
                                        ln_tope10,
                                        tipocambio,
                                        fech_maxcuota,
                                        ln_seguro);
    
      if ln_mod10 = 117 then
        pq_cr_deudacliente.sp_capacidadlinea(ln_mod10,
                                                  ln_suc10,
                                                  ln_mda10,
                                                  ln_pap10,
                                                  ln_cta10,
                                                  ln_oper10,
                                                  ln_sbop10,
                                                  ln_tope10,
                                                  tipocambio,
                                                  ln_capacidad);
      end if;
    
      if ln_mod10 <> 117 then
        pq_cr_deudacliente.sp_capacidadpago(ln_cuotimp,
                                                 ln_nrocuotas,
                                                 ln_parciales,
                                                 ln_peri10,
                                                 ln_seguro,
                                                 ln_mod10,
                                                 ln_instancia,
                                                 tipocambio,
                                                 ln_suc10,
                                                 ln_mda10,
                                                 ln_pap10,
                                                 ln_cta10,
                                                 ln_oper10,
                                                 ln_sbop10,
                                                 ln_tope10,
                                                 ln_indicador,
                                                 ln_capacidad);
      end if;
  
  
  end sp_resolutor;
  
  --------------------------------------------------
  procedure sp_resolutor_venc(ln_pgcod10   in number,
                         ln_mod10     in number,
                         ln_suc10     in number,
                         ln_mda10     in number,
                         ln_pap10     in number,
                         ln_cta10     in number,
                         ln_oper10    in number,
                         ln_sbop10    in number,
                         ln_tope10    in number,
                         --ln_peri10    in number,
                         tipocambio   in number,
                        -- ln_indicador in number,
                         ln_capacidad out number,
                         ln_sdoTot out number) is
    ln_nrocuotas  number;
   -- ln_parciales  number;
    ln_cuotimp    number;
    ln_seguro     number;
    fech_maxcuota date;
 --   ln_instancia  number;
    lc_ven        char(1);
  
    cursor creditos is
      select a.r1cod  ln_pgcod10,
             a.r1mod  ln_mod10,
             a.r1suc  ln_suc10,
             a.r1mda  ln_mda10,
             a.r1pap  ln_pap10,
             a.r1cta  ln_cta10,
             a.r1oper ln_oper10,
             a.r1sbop ln_sbop10,
             a.r1tope ln_tope10
        from fsr011 a, fsd010 b
       where a.r2cod = ln_pgcod10
         and a.r2mod = ln_mod10
         and a.r2suc = ln_suc10
         and a.r2mda = ln_mda10
         and a.r2pap = ln_pap10
         and a.r2cta = ln_cta10
         and a.r2oper = ln_oper10
         and a.r2sbop = ln_sbop10
         and a.r2tope = ln_tope10
         and a.r1cod = b.pgcod
         and a.r1mod = b.aomod
         and a.r1suc = b.aosuc
         and a.r1mda = b.aomda
         and a.r1pap = b.aopap
         and a.r1cta = b.aocta
         and a.r1oper = b.aooper
         and a.r1sbop = b.aosbop
         and a.r1tope = b.aotope
         and b.aostat <> 99
         and relcod = 46;
  
    ln_pr116  number;
    ln_capTem number;
    Ln_sdo number(17,2);
  begin
  
    begin
      select 'S'
        into lc_ven
        from fsr011 a, fsd010 b
       where a.r2cod = ln_pgcod10
         and a.r2mod = ln_mod10
         and a.r2suc = ln_suc10
         and a.r2mda = ln_mda10
         and a.r2pap = ln_pap10
         and a.r2cta = ln_cta10
         and a.r2oper = ln_oper10
         and a.r2sbop = ln_sbop10
         and a.r2tope = ln_tope10
         and a.r1cod = b.pgcod
         and a.r1mod = b.aomod
         and a.r1suc = b.aosuc
         and a.r1mda = b.aomda
         and a.r1pap = b.aopap
         and a.r1cta = b.aocta
         and a.r1oper = b.aooper
         and a.r1sbop = b.aosbop
         and a.r1tope = b.aotope
         and b.aostat <> 99
         and relcod = 46
         and rownum = 1;
    exception
      when no_data_found then
        lc_ven := 'N';
    end;
    ln_sdoTot :=0;
    if lc_ven = 'S' then
      for i in creditos loop
      
        pq_cr_deudacliente.sp_cuotas(i.ln_pgcod10,
                                          i.ln_mod10,
                                          i.ln_suc10,
                                          i.ln_mda10,
                                          i.ln_pap10,
                                          i.ln_cta10,
                                          i.ln_oper10,
                                          i.ln_sbop10,
                                          i.ln_tope10,
                                          ln_nrocuotas);
        begin
          select a.aoperiod
            into ln_pr116
            from fsd010 a
           where a.pgcod = i.ln_pgcod10
             and a.aomod = i.ln_mod10
             and a.aosuc = i.ln_suc10
             and a.aomda = i.ln_mda10
             and a.aopap = i.ln_pap10
             and a.aocta = i.ln_cta10
             and a.aooper = i.ln_oper10
             and a.aosbop = i.ln_sbop10
             and a.aotope = i.ln_tope10;
        exception
          when others then
            null;
        end;
      
        pq_cr_deudacliente.sp_cuota_impaga_lin(i.ln_pgcod10,
                                                    i.ln_mod10,
                                                    i.ln_suc10,
                                                    i.ln_mda10,
                                                    i.ln_pap10,
                                                    i.ln_cta10,
                                                    i.ln_oper10,
                                                    i.ln_sbop10,
                                                    i.ln_tope10,
                                                    tipocambio,
                                                    ln_cuotimp,
                                                    fech_maxcuota);
      
        pq_cr_deudacliente.sp_seguro(i.ln_mod10,
                                          i.ln_suc10,
                                          i.ln_mda10,
                                          i.ln_pap10,
                                          i.ln_cta10,
                                          i.ln_oper10,
                                          i.ln_sbop10,
                                          i.ln_tope10,
                                          tipocambio,
                                          fech_maxcuota,
                                          ln_seguro);
        pq_cr_deudacliente.sp_capacidadpago_lin(ln_cuotimp,
                                                     ln_nrocuotas,
                                                     ln_pr116,
                                                     ln_seguro,
                                                     i.ln_mod10,
                                                     ln_capTem);
      
        ln_capacidad := nvl(ln_capacidad, 0) + nvl(ln_capTem, 0);
        
        
        begin
          select - a.scsdo
            into Ln_sdo
            from fsd011 a
           where a.pgcod  = i.ln_pgcod10
             and a.scsuc  = i.ln_mod10
             and a.scmod  = i.ln_suc10
             and a.scmda  = i.ln_mda10
             and a.scpap  = i.ln_pap10
             and a.sccta  = i.ln_cta10
             and a.scoper = i.ln_oper10
             and a.scsbop = i.ln_sbop10
             and a.sctope = i.ln_tope10;
        exception when others then Ln_sdo := 0;   
        end;
        if i.ln_mda10 = 101 then
           Ln_sdo := Ln_sdo * tipocambio;
        end if;
        
        ln_sdoTot := nvl(ln_sdoTot, 0) + nvl(Ln_sdo, 0); 
      end loop;
    end if;
  
  end sp_resolutor_venc;
-------------------------------------------------------------------------------------------
Procedure Sp_TipOpe_CK(pn_mod in number,pn_top in number, Pc_flag out varchar2) is --mod 2016.04.12
  
  begin
    if pn_mod = 106  then 
        Pc_flag := 'N';
        begin
          select 'S'
            into Pc_flag
            from fst198 a
           where a.tp1cod = 1 --mod@abr 20180308
             and a.tp1cod1 = 10899
             and a.tp1corr1 = 23
             and a.tp1corr2 = 2
             and a.tp1nro1 = pn_top;
        
        exception
          when no_data_found then
            Pc_flag := 'N';
        end;
        else
          Pc_flag := 'S';
     end if;
     
     if pn_mod = 107 then
        Pc_flag := 'N';
     end if;
  
end Sp_TipOpe_CK;

Procedure Sp_ampliados_CK(ln_emp10  in number,
                            ln_mod10  in number,
                            ln_suc10  in number,
                            ln_mda10  in number,
                            ln_pap10  in number,
                            ln_cta10  in number,
                            ln_oper10 in number,
                            ln_sbop10 in number,
                            ln_tope10 in number,
                            Pc_flag   out varchar2) is --mod 2016.04.12
  
  begin
  
    begin
      select 'S'
        into Pc_flag
        from xwf700 a
       where a.xwfempresa = ln_emp10
         and a.xwfsucursal = ln_suc10
         and a.xwfmodulo = ln_mod10
         and a.xwfmoneda = ln_mda10
         and a.xwfpapel = ln_pap10
         and a.xwfcuenta = ln_cta10
         and a.xwfoperacion = ln_oper10
         and a.xwfsubope = ln_sbop10
         and a.xwftipope = ln_tope10
         and a.xwfcar3 not in ('1', 'A')
         and rownum = 1;
    exception
      when no_data_found then
        Pc_flag := 'N';
    end;
  
  end Sp_ampliados_CK;

  --------------------------------------------------------------------------

  Procedure Sp_Adicional_CK(pn_mod in number,pn_top in number, Pc_flag out varchar2) is --mod 2016.04.12
  
  begin
    if pn_mod = 117 then 
        begin
          select 'S'
            into Pc_flag
            from fst198 a
           where a.tp1cod = 1 --mod@abr 20180308
             and a.tp1cod1 = 20001
             and a.tp1corr1 = 1
             and a.tp1corr2 = 1211
             and a.tp1nro1 = pn_top;
        
        exception
          when no_data_found then
            Pc_flag := 'N';
        end;
        else
          Pc_flag := 'N';
     end if;
  
  end Sp_Adicional_CK;
  --------------------------------------------------------------------------------

  procedure sp_cuotas(ln_pgcod10    in number,
                      ln_mod10      in number,
                      ln_suc10      in number,
                      ln_mda10      in number,
                      ln_pap10      in number,
                      ln_cta10      in number,
                      ln_oper10     in number,
                      ln_sbop10     in number,
                      ln_tope10     in number,
                      ln_NRO_CUOTAS out number) is
  begin
    begin
    
      select count(*)
        into ln_NRO_CUOTAS
        from fsd601
       where Pgcod = ln_pgcod10
         and Ppmod = ln_mod10
         and Ppsuc = ln_suc10
         and Ppmda = ln_mda10
         and Pppap = ln_pap10
         and Ppcta = ln_cta10
         and Ppoper = ln_oper10
         and Ppsbop = ln_sbop10
         and Pptope = ln_tope10
         and D601co in ('S', 'X');
    exception
      when others then
        null;
    end;
  
  end sp_cuotas;
  ----------------------------------------------------
  procedure sp_instancia(ln_mod10     in number,
                         ln_suc10     in number,
                         ln_mda10     in number,
                         ln_pap10     in number,
                         ln_cta10     in number,
                         ln_oper10    in number,
                         ln_sbop10    in number,
                         ln_tope10    in number,
                         ln_SNG001Ori out number,
                         ln_instancia out number) is
  
    --- ln_instancia number;
  
  begin
    begin
      sp_instancia_credito(v_Scmod     => ln_mod10,
                           v_Scsuc     => ln_suc10,
                           v_Scmda     => ln_mda10,
                           v_Scpap     => ln_pap10,
                           v_Sccta     => ln_cta10,
                           v_Scoper    => ln_oper10,
                           v_Scsbop    => ln_sbop10,
                           v_Sctope    => ln_tope10,
                           v_instancia => ln_instancia);
    end;
  
    begin
      select SNG001Ori
        into ln_SNG001Ori
        from sng001 s01
       where s01.sng001inst = ln_instancia;
    exception
      when others then
        null;
    end;
  
  end sp_instancia;

  ---CUOTA IMPAGA --------------------------
  procedure sp_cuota_impaga(ln_pgcod10    in number,
                            ln_mod10      in number,
                            ln_suc10      in number,
                            ln_mda10      in number,
                            ln_pap10      in number,
                            ln_cta10      in number,
                            ln_oper10     in number,
                            ln_sbo10      in number,
                            ln_tip10      in number,
                            tipocambio    in number,
                            ln_cuoimp     out number,
                            fech_maxcuota out date) is
  
    lc_estado character(1);
    ld_fecha  date;
    /*ln_r1mod  number;
    ln_r1suc  number;
    ln_r1mda  number;
    ln_r1pap  number;
    ln_r1cta  number;
    ln_r1oper number;
    ln_r1cod  number;*/
  
  begin
  
    if ln_mod10 <> 117 then
    
      BEGIN
        select max(ppfpag)
          into ld_fecha
          from fsd602
         where pgcod = ln_pgcod10
           and ppmod = ln_mod10
           and ppsuc = ln_suc10
           and ppmda = ln_mda10
           and pppap = ln_pap10
           and ppcta = ln_cta10
           and ppoper = ln_oper10
           and ppsbop = ln_sbo10
           and pptope = ln_tip10;
      exception
        when others then
          NULL;
        
      END;
    
      begin
        select max(f602.pp1stat) --, ppfpag
          into lc_estado
          from fsd602 f602
         where f602.pgcod = ln_pgcod10
           and f602.ppmod = ln_mod10
           and f602.ppsuc = ln_suc10
           and f602.ppmda = ln_mda10
           and f602.pppap = ln_pap10
           and f602.ppcta = ln_cta10
           and f602.ppoper = ln_oper10
           and f602.ppsbop = ln_sbo10
           and f602.pptope = ln_tip10
           and f602.ppfpag = ld_fecha;
      exception
        when others then
          NULL;
      end;
    
      if lc_estado = 'T' or lc_estado = 'P' then
        begin
          select max(ppcap + ppint)
            into ln_cuoimp
            from fsd601
           where pgcod = ln_pgcod10
             and ppmod = ln_mod10
             and ppsuc = ln_suc10
             and ppmda = ln_mda10
             and pppap = ln_pap10
             and ppcta = ln_cta10
             and ppoper = ln_oper10
             and ppsbop = ln_sbo10
             and pptope = ln_tip10
             and ppfpag > ld_fecha;
          -- and rownum = 1;
        exception
          when too_many_rows then
            begin
              select max(ppcap + ppint)
                into ln_cuoimp
                from fsd601
               where pgcod = ln_pgcod10
                 and ppmod = ln_mod10
                 and ppsuc = ln_suc10
                 and ppmda = ln_mda10
                 and pppap = ln_pap10
                 and ppcta = ln_cta10
                 and ppoper = ln_oper10
                 and ppsbop = ln_sbo10
                 and pptope = ln_tip10
                 and ppfpag > ld_fecha
                 and rownum = 1;
            exception
              when others then
              
                NULL;
            end;
        end;
      
      else
        if lc_estado is null then
          begin
            select max(ppcap + ppint)
              into ln_cuoimp
              from fsd601 d
             where pgcod = ln_pgcod10
               and ppmod = ln_mod10
               and ppsuc = ln_suc10
               and ppmda = ln_mda10
               and pppap = ln_pap10
               and ppcta = ln_cta10
               and ppoper = ln_oper10
               and ppsbop = ln_sbo10
               and pptope = ln_tip10;
               exception
              when others then
              
                NULL;
          
          end;
        
        end if;
      
      end if;
    
      begin
        select d.ppfpag
          into fech_maxcuota
          from fsd601 d
         where pgcod = ln_pgcod10
           and ppmod = ln_mod10
           and ppsuc = ln_suc10
           and ppmda = ln_mda10
           and pppap = ln_pap10
           and ppcta = ln_cta10
           and ppoper = ln_oper10
           and ppsbop = ln_sbo10
           and pptope = ln_tip10
           and (ppcap + ppint) = ln_cuoimp
           and rownum = 1;
           exception
              when others then
              
                NULL;
      
      end;
    
      if ln_mda10 = 101 then
        ln_cuoimp := nvl(ln_cuoimp, 0) * tipocambio;
      end if;
    
    end if;
  
  end sp_cuota_impaga;
  --------------------------------------------------
  procedure sp_seguro(ln_mod10        in number,
                      ln_suc10        in number,
                      ln_mda10        in number,
                      ln_pap10        in number,
                      ln_cta10        in number,
                      ln_oper10       in number,
                      ln_sbop10       in number,
                      ln_tope10       in number,
                      tipocambio      in number,
                      fech_maxcuota   in date,
                      ln_monto_seguro out number) is
  
  begin
    begin
      select sum(ppimp10 + ppimp11 + ppimp12 + ppimp13)
        into ln_monto_seguro
        from fsd611
       where Pgcod = 1
         and Ppmod = ln_mod10
         and Ppsuc = ln_suc10
         and Ppmda = ln_mda10
         and Pppap = ln_pap10
         and Ppcta = ln_cta10
         and Ppoper = ln_oper10
         and Ppsbop = ln_sbop10
         and Pptope = ln_tope10
         and ppfpag = fech_maxcuota;
    exception
      when others then
        null;
    end;
  
    if ln_mda10 = 101 then
      ln_monto_seguro := nvl(ln_monto_seguro, 0) * nvl(tipocambio, 0);
    end if;
  
    ln_monto_seguro := nvl(ln_monto_seguro, 0);
  
  end sp_seguro;
  --------------------------------------------------

  procedure sp_capacidadlinea(ln_mod10   in number,
                              ln_suc10   in number,
                              ln_mda10   in number,
                              ln_pap10   in number,
                              ln_cta10   in number,
                              ln_oper10  in number,
                              ln_sbop10  in number,
                              ln_tope10  in number,
                              tipocambio in number,
                              ln_formula out number) is
  
    ln_plazo  number(10, 2);
    ln_tasa   number(10, 3);
    ln_saldo  number(10, 2);
    instancia number;
  
  begin
  
    begin
      select f.pp028maxn
        into ln_plazo
        from fpp028 f
       where f.pp017par = 103
         and f.pp028mod = 116
         and f.pp028top = ln_tope10
         and f.pp028mda = ln_mda10; -- plazo
    exception
      when others then
        null;
    end;
  
    begin
      select aotasa, aoimp
        into ln_tasa, ln_saldo
        from fsd010
       where pgcod = 1
         and aocta = ln_cta10
         and aooper = ln_oper10
         and aomod = ln_mod10
         and aosuc = ln_suc10
         and aomda = ln_mda10
         and aopap = ln_pap10
         and aosbop = ln_sbop10
         and aotope = ln_tope10; --tasa
    exception
      when others then
        null;
    end;
  
    if ln_saldo is null then
      begin
        select x.xwfmonto1, x.xwfprcins
          into ln_saldo, instancia
          from xwf700 x
         where x.xwfempresa = 1
           and x.xwfsucursal = ln_suc10
           and x.xwfmodulo = ln_mod10
           and x.xwfmoneda = ln_mda10
           and x.xwfpapel = ln_pap10
           and x.xwfcuenta = ln_cta10
           and x.xwfoperacion = ln_oper10
           and x.xwfsubope = ln_sbop10
           and x.xwftipope = ln_tope10;
      exception
        when others then
          null;
        
      end;
    
      begin
        select max(sng120tasa)
          into ln_tasa
          from sng120
         where sng120ins = instancia;
         exception
              when others then
              
                NULL;
      
      end;
    end if;
  
    begin
      select x.xwfprcins
        into instancia
        from xwf700 x
       where x.xwfempresa = 1
         and x.xwfsucursal = ln_suc10
         and x.xwfmodulo = ln_mod10
         and x.xwfmoneda = ln_mda10
         and x.xwfpapel = ln_pap10
         and x.xwfcuenta = ln_cta10
         and x.xwfoperacion = ln_oper10
         and x.xwfsubope = ln_sbop10
         and x.xwftipope = ln_tope10;
    exception
      when others then
        null;
      
    end;
  
    if ln_mda10 = 101 then
      ln_saldo := ln_saldo * tipocambio;
    end if;
  

    begin
    
      ln_formula := (ln_saldo *
                    ((power((1 + (ln_tasa / 100)), (1 / 12))) - 1)) /
                    (1 - power((1 +
                               ((power((1 + (ln_tasa / 100)), (1 / 12))) - 1)),
                               -ln_plazo));
    
    end;
  
  end sp_capacidadlinea;

  -----------------------------------------------------------
  procedure sp_capacidadpago(ln_MAX_CUOTA    in number,
                             ln_NRO_CUOTAS   in number,
                             ln_SNG001Ori    in number,
                             ln_peri10       in number,
                             ln_monto_seguro in number,
                             ln_mod10        in number,
                             ln_instancia    in number,
                             tipocambio      in number,
                             ln_suc10        in number, --mod 2016.04.12
                             ln_mda10        in number, --mod 2016.04.12
                             ln_pap10        in number, --mod 2016.04.12
                             ln_cta10        in number, --mod 2016.04.12
                             ln_oper10       in number, --mod 2016.04.12 
                             ln_sbop10       in number, --mod 2016.04.12
                             ln_tope10       in number, --mod 2016.04.12
                             ln_indicador    in number, --mod 2016.04.12
                             ln_capacidad    out number) is
    ln_mensual number;
    ln_cuota   number;
    -- ln_sngmda  number;
    -- ln_cuotaimp number;
  
    ln_mtoPar number(17, 2); --mod 2016.04.12
    ln_plazo  number(10, 2); --mod 2016.04.12
    ln_tasa   number(10, 3); --mod 2016.04.12
    ln_period number; --mod 2016.04.12
    ln_cuo    number;
  begin
  
    begin
    
      if ln_mod10 <> 117 then
      
        if ln_NRO_CUOTAS > 1 and ln_SNG001Ori <> 7 then
        
          ln_mensual := ln_peri10 / 30;
          
          if ln_mensual = 0 then
            ln_cuota :=0;
          else            
            ln_cuota := ln_MAX_CUOTA / ln_mensual; --mensualisa la cuota
          end if;
          ln_capacidad := nvl(ln_cuota, 0) + nvl(ln_monto_seguro, 0);
        
        end if;
        --mod 2016.04.12
        if ln_NRO_CUOTAS > 1 and ln_SNG001Ori = 7 then
        
          if ln_indicador = 2 then
            --Desembolsos parciales en vuelo
          
            begin
              select a.sng120mto, A.SNG120TASA, A.SNG120CUO, a.sng120per
                into ln_mtoPar, ln_tasa, ln_plazo, ln_period
                from sng120 a
               where a.sng120ins = ln_instancia
                 and a.sng120tsk like 'PROPUES%'
                 and rownum = 1;
            exception
              when others then
                null;
            end;
            if ln_mda10 = 101 then
              ln_mtoPar := ln_mtoPar * tipocambio;
            end if;
          
            begin
            
              ln_cuo := (ln_mtoPar *
                        ((power((1 + (ln_tasa / 100)), (1 / 12))) - 1)) /
                        (1 - power((1 +
                                   ((power((1 + (ln_tasa / 100)), (1 / 12))) - 1)),
                                   -ln_plazo));
            
              ln_mensual := ln_period / 30;
            
              ln_cuota     := ln_cuo / ln_mensual; --mensualisa la cuota
              ln_capacidad := nvl(ln_cuota, 0) + nvl(ln_monto_seguro, 0);
            
            end;
          end if;
        
          if ln_indicador = 1 then
            --Desembolsos parciales contabilizados
          
            begin
              select a.aotasa, a.aoperiod
                into ln_tasa, ln_period
                from fsd010 a
               where a.pgcod = 1
                 and a.aomod = ln_mod10
                 and a.aosuc = ln_suc10
                 and a.aomda = ln_mda10
                 and a.aopap = ln_pap10
                 and a.aocta = ln_cta10
                 and a.aooper = ln_oper10
                 and a.aosbop = ln_sbop10
                 and a.aotope = ln_tope10;
            exception
              when others then
                null;
            end;
            begin
              select count(*)
                into ln_plazo
                from fsd601 a
               where a.pgcod = 1
                 and a.ppmod = ln_mod10
                 and a.ppsuc = ln_suc10
                 and a.ppmda = ln_mda10
                 and a.pppap = ln_pap10
                 and a.ppcta = ln_cta10
                 and a.ppoper = ln_oper10
                 and a.ppsbop = ln_sbop10
                 and a.pptope = ln_tope10
                 and a.d601co = 'S'
                 and (a.ppcap + a.ppint) <> 0;
            exception
              when others then
                null;
            end;
            begin
              select a.sng120mto
                into ln_mtoPar
                from sng120 a
               where a.sng120ins = ln_instancia
                 and a.sng120tsk like 'APROBAC%'
                 and rownum = 1;
            exception
              when others then
                null;
            end;
            if ln_mda10 = 101 then
              ln_mtoPar := ln_mtoPar * tipocambio;
            end if;
          
            begin
            
              ln_cuo := (ln_mtoPar *
                        ((power((1 + (ln_tasa / 100)), (1 / 12))) - 1)) /
                        (1 - power((1 +
                                   ((power((1 + (ln_tasa / 100)), (1 / 12))) - 1)),
                                   -ln_plazo));
            
              ln_mensual := ln_period / 30;
            
              ln_cuota     := ln_cuo / ln_mensual; --mensualisa la cuota
              ln_capacidad := nvl(ln_cuota, 0) + nvl(ln_monto_seguro, 0);
            
            end;
          end if;
        
        end if;
      
      end if;
    end;
  end sp_capacidadpago;
  
--------------------------------------------------

  procedure sp_cuota_impaga_Lin(ln_pgcod10    in number,
                                ln_mod10      in number,
                                ln_suc10      in number,
                                ln_mda10      in number,
                                ln_pap10      in number,
                                ln_cta10      in number,
                                ln_oper10     in number,
                                ln_sbop10     in number,
                                ln_tipo10     in number,
                                tipocambio    in number,
                                ln_cuoimp     out number,
                                fech_maxcuota out date) is
  
    lc_estado character(1);
    ld_fecha  date;
    /*ln_r1mod  number;
    ln_r1suc  number;
    ln_r1mda  number;
    ln_r1pap  number;
    ln_r1cta  number;
    ln_r1oper number;
    ln_r1cod  number;*/
  
  begin
  
    BEGIN
      select max(ppfpag)
        into ld_fecha
        from fsd602
       where pgcod = ln_pgcod10
         and ppmod = ln_mod10
         and ppsuc = ln_suc10
         and ppmda = ln_mda10
         and pppap = ln_pap10
         and ppcta = ln_cta10
         and ppoper = ln_oper10
         and ppsbop = ln_sbop10
         and pptope = ln_tipo10
         
         ;
    exception
      when others then
        NULL;
      
    END;
  
    begin
      select max(f602.pp1stat) --, ppfpag
        into lc_estado
        from fsd602 f602
       where f602.pgcod = ln_pgcod10
         and f602.ppmod = ln_mod10
         and f602.ppsuc = ln_suc10
         and f602.ppmda = ln_mda10
         and f602.pppap = ln_pap10
         and f602.ppcta = ln_cta10
         and f602.ppoper = ln_oper10
         and f602.ppsbop = ln_sbop10
         and f602.pptope = ln_tipo10
         and f602.ppfpag = ld_fecha;
    exception
      when others then
        NULL;
    end;
  
    if lc_estado = 'T' or lc_estado = 'P' then
      begin
        select max(ppcap + ppint)
          into ln_cuoimp
          from fsd601
         where pgcod = ln_pgcod10
           and ppmod = ln_mod10
           and ppsuc = ln_suc10
           and ppmda = ln_mda10
           and pppap = ln_pap10
           and ppcta = ln_cta10
           and ppoper = ln_oper10
           and ppsbop = ln_sbop10
           and pptope = ln_tipo10
           and ppfpag > ld_fecha;
        -- and rownum = 1;
      exception
        when too_many_rows then
          begin
            select max(ppcap + ppint)
              into ln_cuoimp
              from fsd601
             where pgcod = ln_pgcod10
               and ppmod = ln_mod10
               and ppsuc = ln_suc10
               and ppmda = ln_mda10
               and pppap = ln_pap10
               and ppcta = ln_cta10
               and ppoper = ln_oper10
               and ppsbop = ln_sbop10
               and pptope = ln_tipo10
               and ppfpag > ld_fecha
               and rownum = 1;
          exception
            when others then
            
              NULL;
          end;
      end;
    
    else
      if lc_estado is null then
        begin
          select max(ppcap + ppint)
            into ln_cuoimp
            from fsd601 d
           where pgcod = ln_pgcod10
             and ppmod = ln_mod10
             and ppsuc = ln_suc10
             and ppmda = ln_mda10
             and pppap = ln_pap10
             and ppcta = ln_cta10
             and ppoper = ln_oper10
             and ppsbop = ln_sbop10
             and pptope = ln_tipo10;
             exception
              when others then
              
                NULL;
        
        end;
      
      end if;
    
    end if;
  
    begin
      select d.ppfpag
        into fech_maxcuota
        from fsd601 d
       where pgcod = ln_pgcod10
         and ppmod = ln_mod10
         and ppsuc = ln_suc10
         and ppmda = ln_mda10
         and pppap = ln_pap10
         and ppcta = ln_cta10
         and ppoper = ln_oper10
         and ppsbop = ln_sbop10
         and pptope = ln_tipo10
         and (ppcap + ppint) = ln_cuoimp
         and rownum = 1;
         exception
              when others then
              
                NULL;
    
    end;
  
    if ln_mda10 = 101 then
      ln_cuoimp := nvl(ln_cuoimp, 0) * tipocambio;
    end if;
  
  end sp_cuota_impaga_Lin;

  -----------------------------------------------------------
  procedure sp_capacidadpago_Lin(ln_MAX_CUOTA    in number,
                                 ln_NRO_CUOTAS   in number,
                                 ln_peri10       in number,
                                 ln_monto_seguro in number,
                                 ln_mod10        in number,
                                 ln_capacidad    out number) is
    ln_mensual number;
    ln_cuota   number;
    -- ln_sngmda  number;
    -- ln_cuotaimp number;
  
  begin
  
    begin
    
      if ln_mod10 <> 117 then
      
        if ln_NRO_CUOTAS > 1 then
       
          ln_mensual := ln_peri10 / 30;
          
          if ln_mensual = 0 then
            ln_cuota := 0;
          else
        
          ln_cuota := ln_MAX_CUOTA / ln_mensual; --mensualisa la cuota
        end if;
          ln_capacidad := nvl(ln_cuota, 0) + nvl(ln_monto_seguro, 0);
        
        end if;
      
      end if;
    end;
  end sp_capacidadpago_Lin;

Procedure Sp_Segmentacion_var (pn_pai in number,
                            pn_tdo in number,
                            pc_ndo in char,
                            pn_cal out number,
                            ln_CntInsRep out number) is
  
DocSbs_Cyg number(10);
DocSbsCyg char(1);
DocSbs number(10);
DocSbsTit char(1);
lc_tiper_Cyg char(1);

fecNum_rcc number(9);
MesRcc number(9);
ln_Rpccyg number(2);
lc_tiper char(1);
fec_rcc date;
ln_paiC  number(3);
ln_tdoC  number(2);
lc_ndoC  char(12);

ln_CntOpeRccTi number(10);
ln_CntOpeRccCy number(10);
begin
  
          --*******CALIFICACION_RCC********--------
     --Guia equivalencia tipo de documento
     begin
          select a.tp1corr3
            into DocSbs
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 11111
             and a.tp1corr1 = 1
             and a.tp1corr2 = 3
             and a.tp1nro1 = pn_tdo;
     exception
           when no_data_found then
                DocSbs := null;
     end;
     DocSbsTit := Trim(to_char(DocSbs));
     
     --fecha RCC
     begin
         select tpnro
           into fecNum_rcc
           from fst098
          where pgcod = 1
            and tpcod = 7647
            and tpcorr = 12;
     exception
            when no_data_found then
                 fecNum_rcc := null;
     end;
     fec_rcc := to_date(fecNum_rcc,'dd/mm/yyyy');
     --Meses a evaluar RCC
     begin
         select tpnro
           into MesRcc
           from fst098
          where pgcod = 1
            and tpcod = 7647
            and tpcorr = 13;
     exception
            when no_data_found then
                 MesRcc := null;
     end;
     --vinculo conyugue
     begin
         select a.tp1corr3 
           into ln_Rpccyg
           from fst198 a 
          where a.tp1cod = 1 --mod@abr 20180308
            and a.tp1cod1=10823 
            and a.Tp1corr1 = 3
            and a.Tp1corr2 = 1;
     exception
            when no_data_found then
                 ln_Rpccyg := null;
     end;
     --tipo de persona
     begin
         select a.petipo
           into lc_tiper
           from /**/fsd001 a
          where a.pepais =pn_pai
            and a.petdoc =pn_tdo
            and a.pendoc =pc_ndo;
     exception
            when no_data_found then
                 lc_tiper:=null;
     end;
     pn_cal := 100.00;
     
     pn_cal := pq_cr_deudacliente.Fn_calificacion_RCC(DocSbsTit,
                                                        pc_ndo,
                                                        fec_rcc,
                                                        MesRcc,
                                                        lc_tiper
                                                        );
    
    --evalua conyugue si la calificacion es normal para el titular
    
    
       begin
              select a.rppais,
                     a.rptdoc,
                     a.rpndoc
                into ln_paiC,
                     ln_tdoC,
                     lc_ndoC
                from /**/fsr002 a
               where a.pepais = pn_pai
                 and a.petdoc = pn_tdo
                 and a.pendoc = pc_ndo
                 and a.rpccyg = ln_Rpccyg
                 and rownum   = 1;
       exception 
                 when no_data_found then
                      ln_paiC :=null;
                      ln_tdoC :=null;
                      lc_ndoC :=null;
       end;
       
       --Guia equivalencia tipo de documento
       begin
            select a.tp1corr3
              into DocSbs_Cyg
              from fst198 a
             where a.tp1cod = 1
               and a.tp1cod1 = 11111
               and a.tp1corr1 = 1
               and a.tp1corr2 = 3
               and a.tp1nro1 = ln_tdoC;
       exception
             when no_data_found then
                  DocSbs_Cyg := null;
       end;
       DocSbsCyg := Trim(to_char(DocSbs_Cyg));
     
       --tipo de persona
       begin
           select a.petipo
             into lc_tiper_Cyg
             from /**/fsd001 a
            where a.pepais =ln_paiC
              and a.petdoc =ln_tdoC
              and a.pendoc =lc_ndoC;
       exception
              when no_data_found then
                   lc_tiper_Cyg:=null;
       end;
   
    if pn_cal = 100.00 and lc_ndoC is not null then  
       if lc_ndoC is null then
          insert into jaqz082_aux(jaqz082ndo,JAQZ082TPO) values (pc_ndo,'CYG');
                  commit;
       end if;
     
       pn_cal := pq_cr_deudacliente.Fn_calificacion_RCC(DocSbsCyg,
                                                        lc_ndoC,
                                                        fec_rcc,
                                                        MesRcc,
                                                        lc_tiper_Cyg
                                                        );
    
    end if;                                                        
     
     
    --***************CANT_ENTIDADES**********----
    --ln_CntOpeRccTi := 0;
    ln_CntOpeRccCy := 0;
    ln_CntInsRep := 0;
    
    ln_CntOpeRccTi :=pq_cr_deudacliente.Fn_cant_instit_Segm(DocSbsTit,
                                        pc_ndo,
                                        fec_rcc,
                                        lc_tiper);
    
    
       if lc_ndoC is not null then
         ln_CntOpeRccCy :=pq_cr_deudacliente.Fn_cant_instit_segm(DocSbsCyg,
                                          lc_ndoC,
                                          fec_rcc,
                                          lc_tiper_Cyg);
       end if;                                 
                                               
       ln_CntInsRep := ln_CntOpeRccTi + ln_CntOpeRccCy ;
       

end Sp_Segmentacion_var;


Procedure Sp_Segmentacion  (pc_codsbs in varchar2,
                            pn_cal out number) is
  


fecNum_rcc number(9);
MesRcc number(9);


fec_rcc date;

begin
  
          --*******CALIFICACION_RCC********--------
   
     
     --fecha RCC
     begin
         select tpnro
           into fecNum_rcc
           from fst098
          where pgcod = 1
            and tpcod = 7647
            and tpcorr = 12;
     exception
            when no_data_found then
                 fecNum_rcc := null;
     end;
     fec_rcc := to_date(fecNum_rcc,'dd/mm/yyyy');
     --Meses a evaluar RCC
     begin
         select tpnro
           into MesRcc
           from fst098
          where pgcod = 1
            and tpcod = 7647
            and tpcorr = 13;
     exception
            when no_data_found then
                 MesRcc := null;
     end;
     
    
     pn_cal := 100.00;
     
     pn_cal := pq_cr_deudacliente.Fn_calificacion_PRY(pc_codsbs,
                                                        fec_rcc,
                                                        MesRcc
                                                        );
    

      

end Sp_Segmentacion;

Function Fn_calificacion_PRY(c_CodSbsIn IN varchar2,
                             pd_fecRcc in date,
                             MesRcc in number
                             )return number is
ln_i number(5); 
CodSbs char(10);
LN_CALIF0 number(5,2);
LN_CALIF1 number(5,2);
LN_CALIF2 number(5,2);
LN_CALIF3 number(5,2);
LN_CALIF4 number(5,2);                          
pn_cal number(10,5);
pd_fecRccTmp date;

begin
                
  pd_fecRccTmp := pd_fecRcc;
  pn_cal := 100.00;
  ln_i := 1;
  begin
     while ln_i <= MesRcc loop
        
        begin
              select c_CodSbs,
                     N_CALIF0,
                     N_CALIF1,
                     N_CALIF2,
                     N_CALIF3,
                     N_CALIF4
                into CodSbs,
                     LN_CALIF0,
                     LN_CALIF1,
                     LN_CALIF2,
                     LN_CALIF3,
                     LN_CALIF4
                from cldrcci a
               where D_FECPRE = pd_fecRccTmp
                 and c_CodSbs = c_CodSbsIn
                 and rownum = 1;
         exception
              when no_data_found then
                   CodSbs := null;
                   LN_CALIF0 := null;
                   LN_CALIF1 := null;
                   LN_CALIF2 := null;
                   LN_CALIF3 := null;
                   LN_CALIF4 := null;
         end;
             
         If LN_CALIF0 = 100.00 or CodSbs is null then
                    pn_cal := 100.00;
                Else
                    If (LN_CALIF0+ LN_CALIF1+LN_CALIF2+LN_CALIF3+LN_CALIF4=0) then
                        pn_cal := 100.00;
                    Else
                        pn_cal := 0.00;
                        Exit;
                    End If  ;          
         End If ;
      
        if pn_cal = 0.00 then
                Exit;
        end if;
        ln_i := ln_i + 1 ;
        pd_fecRccTmp := Add_months(pd_fecRccTmp,-1);
        pd_fecRccTmp := last_day(pd_fecRccTmp);
     end loop;
  end;
  return pn_cal;
end Fn_calificacion_PRY;         

Function Fn_calificacion_RCC(TipDocSbs in char,
                             pc_ndo_FN in char,
                             pd_fecRcc in date,
                             MesRcc in number,
                             lc_tiper_FN in char
                             )return number is
ln_i number(5); 
CodSbs char(10);
LN_CALIF0 number(5,2);
LN_CALIF1 number(5,2);
LN_CALIF2 number(5,2);
LN_CALIF3 number(5,2);
LN_CALIF4 number(5,2);                          
pn_cal number(10,5);
pd_fecRccTmp date;

begin

  if pc_ndo_FN is null then
        insert into jaqz082_aux(jaqz082ndo,JAQZ082TPO) values (pc_ndo_FN,'ANTES');
                  commit;
     end if;
     
      if lc_tiper_FN is null then
        insert into jaqz082_aux(jaqz082ndo,JAQZ082TPO) values (pc_ndo_FN,'lc_tiper');
                  commit;
     end if;
                
  pd_fecRccTmp := pd_fecRcc;
  pn_cal := 100.00;
  ln_i := 1;
  begin
     while ln_i <= MesRcc loop
        case 
             when lc_tiper_FN = 'F' then
             begin
                  select c_CodSbs,
                         N_CALIF0,
                         N_CALIF1,
                         N_CALIF2,
                         N_CALIF3,
                         N_CALIF4
                    into CodSbs,
                         LN_CALIF0,
                         LN_CALIF1,
                         LN_CALIF2,
                         LN_CALIF3,
                         LN_CALIF4
                    from cldrcci a
                   where D_FECPRE = pd_fecRccTmp
                     and C_TDOCID = TipDocSbs
                     and C_DOCIDE = trim(pc_ndo_FN)
                     and rownum = 1;
             exception
                  when no_data_found then
                       CodSbs := null;
                       LN_CALIF0 := null;
                       LN_CALIF1 := null;
                       LN_CALIF2 := null;
                       LN_CALIF3 := null;
                       LN_CALIF4 := null;
             end;
             
             If LN_CALIF0 = 100.00 or CodSbs is null then
                        pn_cal := 100.00;
                    Else
                        If (LN_CALIF0+ LN_CALIF1+LN_CALIF2+LN_CALIF3+LN_CALIF4=0) then
                            pn_cal := 100.00;
                        Else
                            pn_cal := 0.00;
                            Exit;
                        End If  ;          
             End If ;
        when lc_tiper_FN = 'J' then      
             begin
                  select c_CodSbs,
                         N_CALIF0,
                         N_CALIF1,
                         N_CALIF2,
                         N_CALIF3,
                         N_CALIF4
                    into CodSbs,
                         LN_CALIF0,
                         LN_CALIF1,
                         LN_CALIF2,
                         LN_CALIF3,
                         LN_CALIF4
                    from cldrcci a
                   where D_FECPRE = pd_fecRccTmp
                     and C_TDOCTR = TipDocSbs
                     and C_DOCTRI = trim(pc_ndo_FN)
                     and rownum = 1;
             exception
                  when no_data_found then
                       CodSbs := null;
                       LN_CALIF0 := null;
                       LN_CALIF1 := null;
                       LN_CALIF2 := null;
                       LN_CALIF3 := null;
                       LN_CALIF4 := null;
             end;
             If LN_CALIF0 = 100.00 or CodSbs is null then
                        pn_cal := 100.00;
                    Else
                        If (LN_CALIF0+ LN_CALIF1+LN_CALIF2+LN_CALIF3+LN_CALIF4=0) then
                            pn_cal := 100.00;
                        Else
                            pn_cal := 0.00;
                            Exit;
                        End If  ;          
             End If ;
        else null;
             --insert into jaqz082_aux(jaqz082ndo,JAQZ082TPO) values (pc_ndo_FN,'FNC');
               --   commit;
        
        end case;
        if pn_cal = 0.00 then
                Exit;
        end if;
        ln_i := ln_i + 1 ;
        pd_fecRccTmp := Add_months(pd_fecRccTmp,-1);
        pd_fecRccTmp := last_day(pd_fecRccTmp);
     end loop;
  end;
  return pn_cal;
end Fn_calificacion_RCC;                             

Function Fn_cant_instit(lc_CodSbs in char
                        )return number is
                        
ln_NumEnt number(10);


cursor entidades is
select distinct C_CODEMP
  from jaqy346det
 Where C_CODSBS = lc_CodSbs
   and C_CODEMP <> '00104'
   and (C_CUENTA like '14_1%'
       Or C_CUENTA like '14_2%'  
       Or C_CUENTA like '14_3%' 
       Or C_CUENTA like '14_4%'  
       Or C_CUENTA like '14_5%' 
       Or C_CUENTA like '14_6%' 
       Or C_CUENTA like '71_1%' 
       Or C_CUENTA like '71_2%' 
       Or C_CUENTA like '71_3%' 
       Or C_CUENTA like '71_4%' 
       Or C_CUENTA like '81_302%')
   and C_CRETIP not in (select a.tp1nro1
                          from fst198 a
                         Where a.Tp1cod   = 1
                           and a.Tp1cod1  = 20001
                           and a.Tp1corr1 = 1
                           and a.Tp1corr2 = 1205);
 
              
begin
      ln_NumEnt := 0;
      
         
         begin
            for i in entidades loop 
                ln_NumEnt := ln_NumEnt + 1;
                
            end loop;
         End;
 
      return ln_NumEnt;

end Fn_cant_instit;

Function Fn_cant_instit_T(lc_CodSbs in char
                        )return number is
                        
ln_NumEnt number(10);


cursor entidades is
select distinct C_CODEMP
  from jaqy346det
 Where C_CODSBS = lc_CodSbs
   and (C_CUENTA like '14_1%'
       Or C_CUENTA like '14_2%'  
       Or C_CUENTA like '14_3%' 
       Or C_CUENTA like '14_4%'  
       Or C_CUENTA like '14_5%' 
       Or C_CUENTA like '14_6%' 
       Or C_CUENTA like '71_1%' 
       Or C_CUENTA like '71_2%' 
       Or C_CUENTA like '71_3%' 
       Or C_CUENTA like '71_4%' 
       Or C_CUENTA like '81_302%');
 
              
begin
      ln_NumEnt := 0;
      
         
         begin
            for i in entidades loop 
                ln_NumEnt := ln_NumEnt + 1;
                
            end loop;
         End;
 
      return ln_NumEnt;

end Fn_cant_instit_T;

Procedure Sp_calRCC2(pn_pai in number,
                            pn_tdo in number,
                            pc_ndo in char,
                            pn_cal out number)is
  
DocSbs number(10);
DocSbsTit char(1);

DocSbs_Cyg number(10);
DocSbsCyg char(1);

lc_tiper char(1);
lc_tiper_Cyg char(1);

fecNum_rcc number(9);
MesRcc number(9);
ln_Rpccyg number(2);

fec_rcc date;
ln_paiC  number(3);
ln_tdoC  number(2);
lc_ndoC  char(12);
begin
  
          --*******CALIFICACION RCC 2 ****--------------
     --Guia equivalencia tipo de documento
     begin
          select a.tp1corr3
            into DocSbs
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 11111
             and a.tp1corr1 = 1
             and a.tp1corr2 = 3
             and a.tp1nro1 = pn_tdo;
     exception
           when no_data_found then
                DocSbs := null;
     end;
     DocSbsTit := Trim(to_char(DocSbs));
     
     --fecha RCC
     begin
         select tpnro
           into fecNum_rcc
           from fst098
          where pgcod = 1
            and tpcod = 7647
            and tpcorr = 12;
     exception
            when no_data_found then
                 fecNum_rcc := null;
     end;
     fec_rcc := to_date(fecNum_rcc,'dd/mm/yyyy');
     --Meses a evaluar RCC
     begin
         select tpnro
           into MesRcc
           from fst098
          where pgcod = 1
            and tpcod = 7702
            and tpcorr = 13;
     exception
            when no_data_found then
                 MesRcc := null;
     end;
     --vinculo conyugue
     begin
         select a.tp1corr3 
           into ln_Rpccyg
           from fst198 a 
          where a.tp1cod = 1 --mod@abr 20180308
            and a.tp1cod1=10823 
            and a.Tp1corr1 = 3
            and a.Tp1corr2 = 1;
     exception
            when no_data_found then
                 ln_Rpccyg := null;
     end;
     --tipo de persona
     begin
         select a.petipo
           into lc_tiper
           from /**/fsd001 a
          where a.pepais =pn_pai
            and a.petdoc =pn_tdo
            and a.pendoc =pc_ndo;
     exception
            when no_data_found then
                 lc_tiper:=null;
     end;
     pn_cal := 100.00;
     if pc_ndo is null then
        insert into jaqz082_aux(jaqz082ndo,JAQZ082TPO) values (pc_ndo,'TIT2');
                  commit;
     end if;
     pn_cal := pq_cr_deudacliente.Fn_calificacion_RCC(DocSbsTit,
                                                        pc_ndo,
                                                        fec_rcc,
                                                        MesRcc,
                                                        lc_tiper
                                                        );
    
    --evalua conyugue si la calificacion es normal para el titular
    
    if pn_cal = 100.00 then
       begin
              select a.rppais,
                     a.rptdoc,
                     a.rpndoc
                into ln_paiC,
                     ln_tdoC,
                     lc_ndoC
                from /**/fsr002 a
               where a.pepais = pn_pai
                 and a.petdoc = pn_tdo
                 and a.pendoc = pc_ndo
                 and a.rpccyg = ln_Rpccyg
                 and rownum = 1;
       exception 
                 when no_data_found then
                      ln_paiC :=null;
                      ln_tdoC :=null;
                      lc_ndoC :=null;
       end;
       
       --Guia equivalencia tipo de documento
       begin
            select a.tp1corr3
              into DocSbs_Cyg
              from fst198 a
             where a.tp1cod = 1
               and a.tp1cod1 = 11111
               and a.tp1corr1 = 1
               and a.tp1corr2 = 3
               and a.tp1nro1 = ln_tdoC;
       exception
             when no_data_found then
                  DocSbs_Cyg := null;
       end;
       DocSbsCyg := Trim(to_char(DocSbs_Cyg));
     
       --tipo de persona
       begin
           select a.petipo
             into lc_tiper_Cyg
             from fsd001 a
            where a.pepais =ln_paiC
              and a.petdoc =ln_tdoC
              and a.pendoc =lc_ndoC;
       exception
              when no_data_found then
                   lc_tiper_Cyg:=null;
       end;
     if pc_ndo is null then
        insert into jaqz082_aux(jaqz082ndo,JAQZ082TPO) values (lc_ndoC,'CYG');
                  commit;
     end if;
     If lc_ndoC is not null then
       pn_cal := pq_cr_deudacliente.Fn_calificacion_RCC(DocSbsCyg,
                                                        lc_ndoC,
                                                        fec_rcc,
                                                        MesRcc,
                                                        lc_tiper_Cyg
                                                    );
    end if;    
    end if; 
end Sp_calRCC2;  

Procedure Sp_Hist_NR_INI(pd_Fecpro in date) is

cursor persona is
select pepais, 
       petdoc, 
       pendoc  
  from jaqy349_aux;
  
ln_contador number(10);
lc_tipHN char(1);
ln_ins number(1);
begin
          execute immediate('truncate table jaqy349_aux');
          execute immediate('truncate table jaqy349_aux_II');
          
          begin
              insert into jaqy349_AUX_II
              
              select a.pgcod,
                     a.aomod,
                     a.aosuc,
                     a.aomda,
                     a.aopap,
                     a.aocta,
                     a.aooper,
                     a.aosbop,
                     a.aotope,
                     a.aofval,
                     a.aofvto,
                     pq_cr_relcrediticia.Fn_DiaPago(a.PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,
                                                                        AOSBOP,AOTOPE,aostat,aofe99)aofe99,
                     a.aostat
                from fsd010 a
               where aomod in (select modulo from fst111 where dscod = 50 and modulo not in (200,33,108))
                 --and (aofe99 >= ld_fecini or aofe99 = to_date('0001.01.01','yyyy.mm.dd'))
                 and aotope <> 550
                 and a.pgcod = 1;   
              commit;
          end;
          
          begin
              insert into jaqy349_AUX
              
              select a.pgcod,
                     a.aomod,
                     a.aosuc,
                     a.aomda,
                     a.aopap,
                     a.aocta,
                     a.aooper,
                     a.aosbop,
                     a.aotope,
                     a.aofval,
                     a.aofvto,
                     aofe99,
                     a.aostat,
                     PEPAIS,
                     PETDOC,
                     PENDOC
                from jaqy349_AUX_II a, fsr008 b
               where a.pgcod = b.pgcod
                 and a.aocta = b.ctnro
                 and b.cttfir = 'T';
  
              commit;
          end;
          
          begin
            for i in persona loop
              ln_ins := pq_cr_deudacliente.fn_inserta(i.pepais,i.petdoc,i.pendoc,pd_fecpro); 
                        
             if ln_ins = 0 then
              begin
                
                ln_contador := pq_cr_deudacliente.Fn_RelCredi_NR(i.pepais,i.petdoc,i.pendoc,pd_fecpro);
                
                if ln_contador > 18 then
                    lc_tipHN := 'A';
                    else
                         if ln_contador <= 18 and ln_contador >= 6 then
                            lc_tipHN := 'B';
                            else
                               if ln_contador < 6 then
                                 lc_tipHN := 'C';
                               end if;
                         end if;
                 end if;   
                insert into jaqy349
                values(i.pepais,i.petdoc,i.pendoc,pd_fecpro,ln_contador,lc_tipHN);
                commit;
              end;
            end if;
              
            end loop;
            
          end;
   
          
end Sp_Hist_NR_INI;

Function Fn_RelCredi_NR(pn_pai in number,pn_tdo in number,pc_ndo in char,pd_Fecpro in date)
                        return number  is

cursor creditos is
select * from jaqy349_aux
where pepais = pn_pai
   and petdoc = pn_tdo
   and pendoc = pc_ndo
   order by aofval;
   
/*select a.pgcod,
       a.aomod,
       a.aosuc,
       a.aomda,
       a.aopap,
       a.aocta,
       a.aooper,
       a.aosbop,
       a.aotope,
       a.aofval,
       a.aofvto,
       --a.aofe99,
       pq_cr_relcrediticia.Fn_DiaPago(a.PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,
                                                          AOSBOP,AOTOPE,aostat,aofe99)aofe99,
       a.aostat
  from fsd010 a, fsr008 b
 where aomod in (select modulo from fst111 where dscod = 50 and modulo not in (200,33,108))
   --and (aofe99 >= ld_fecini or aofe99 = to_date('0001.01.01','yyyy.mm.dd'))
   and aotope <> 550
   and a.pgcod = 1
   and a.pgcod = b.pgcod
   and a.aocta = b.ctnro
   and b.pepais = pn_pai
   and b.petdoc = pn_tdo
   and b.pendoc = pc_ndo
order by aofval;   */
                    
ld_fecantD date;
ld_fecantC date;

ln_mesac number(2);
ln_aniac number(4);
ln_mesan number(2);
ln_anian number(4);
ln_suma number(5);

ld_aofval date;
ld_aofe99 date;
ld_sysdate DATE;

ln_sw number(1);

ln_contador number(10);
begin


    begin
    ln_contador := 0;  
    ld_fecantD := null;
    ld_fecantC := to_date('2000.01.01','yyyy.mm.dd');
    ld_sysdate := last_day(pd_fecpro );
    For i in creditos loop
    
    ln_sw := 0;
      if (i.aofe99 is null or i.aofe99 = to_date('0001.01.01','yyyy.mm.dd'))and i.aostat = 99 then
         ln_sw := 1;
         
      end if;
      if ln_sw = 0 then
      
        ln_mesac := to_number(to_char(i.aofval,'mm'));
        ln_aniac := to_number(to_char(i.aofval,'yyyy'));
        ln_suma := null;
        ld_aofval := i.aofval;
        ld_aofe99 := last_day(i.aofe99);
        
        
        if ld_fecantD is null then
              if i.aostat = 99 then
                 ln_suma := trunc(months_between(ld_aofe99,ld_aofval))+1;
                 if ln_suma <0 then 
                    ln_suma := 0;
                 end if;
                 ln_contador := ln_contador + ln_suma;
                 else 
                     ln_suma := trunc(months_between(ld_sysdate,ld_aofval))+1;
                     if ln_suma <0 then 
                        ln_suma := 0;
                     end if;
                     ln_contador := ln_contador + ln_suma;
                 
              end if;
              
              Else
                   
                  if ld_aofval = ld_fecantC or (ln_mesac = ln_mesan and ln_aniac = ln_anian) then
                     if i.aostat = 99 then
                          ln_suma := trunc(months_between(ld_aofe99,ld_aofval));
                           if ln_suma <0 then 
                              ln_suma := 0;
                           end if;       
                          ln_contador := ln_contador + ln_suma;
                          
                          else
                            ln_suma := trunc(months_between(ld_sysdate,
                                                               ld_aofval));
                             if ln_suma <0 then 
                                ln_suma := 0;
                             end if;          
                            ln_contador := ln_contador + ln_suma;
                      end if;
                      
                      else
                          if ld_aofval < ld_fecantC then
                             --ln_aux := trunc(months_between(ld_fecantC,ld_aofval));  
                             ld_aofval :=  ld_fecantC;
                             if i.aostat = 99 then
                                  ln_suma := trunc(months_between(ld_aofe99,ld_aofval));
                                   if ln_suma <0 then 
                                      ln_suma := 0;
                                   end if;  
                                
                                  ln_contador := ln_contador + ln_suma;-- - ln_aux;
                                  
                                  else
                                    ln_suma := trunc(months_between(ld_sysdate,ld_aofval));
                                     if ln_suma <0 then 
                                        ln_suma := 0;
                                     end if;        
                                    
                                    ln_contador := ln_contador + ln_suma;-- - ln_aux;
                              end if;
                                  
                          
                          
                          end if;
                          
                          if ld_aofval > ld_fecantC then
                             
                             if i.aostat = 99 then
                                  ln_suma := trunc(months_between(ld_aofe99,ld_aofval))+1;
                                   if ln_suma <0 then 
                                      ln_suma := 0;
                                   end if;  
                                  ln_contador := ln_contador + ln_suma;
                                  
                                  else
                                    ln_suma := trunc(months_between(ld_sysdate,ld_aofval))+1;
                                     if ln_suma <0 then 
                                        ln_suma := 0;
                                     end if;  
                                    ln_contador := ln_contador + ln_suma;
                              end if;
                                  
                          
                          
                          end if;
                      
                  
                  end if;
              
        end if;
        
        if i.aofe99 = to_date('0001.01.01','yyyy.mm.dd') then
           if ld_fecantC > i.aofval then
              ld_aofval := ld_fecantC;
           end if;
           ld_fecantC := pd_Fecpro;--trunc(sysdate);
        end if;
        
        if i.aofe99 > ld_fecantC then
                    --ld_fecantD := ld_aofval;
                     ld_fecantC := i.aofe99;
        
        end if;
        ld_fecantD := ld_aofval;
        
        
        
        
        ln_mesan := to_number(to_char(ld_fecantC,'mm'));
        ln_anian := to_number(to_char(ld_fecantC,'yyyy'));
      end if;
    end loop;

    END;
    return ln_contador;
   
end Fn_RelCredi_NR;   

Procedure Sp_Hist_NR_MENS(pd_Fecpro in date) is

cursor persona is
select pepais, 
       petdoc, 
       pendoc  
  from jaqy349_aux;
ln_contador number(10);
lc_tipHN char(1);
ld_fecant date;
lc_hisAnt char(1);
ln_ins number(1);
begin
          execute immediate('truncate table jaqy349_aux');
          ld_fecant := add_months(pd_Fecpro,-1);
          execute immediate('truncate table jaqy349_aux_II');
          
          begin
              insert into jaqy349_AUX_II
              
              select a.pgcod,
                     a.aomod,
                     a.aosuc,
                     a.aomda,
                     a.aopap,
                     a.aocta,
                     a.aooper,
                     a.aosbop,
                     a.aotope,
                     a.aofval,
                     a.aofvto,
                     pq_cr_relcrediticia.Fn_DiaPago(a.PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,
                                                                        AOSBOP,AOTOPE,aostat,aofe99)aofe99,
                     a.aostat
                from fsd010 a
               where aomod in (select modulo from fst111 where dscod = 50 and modulo not in (200,33,108))
                 --and (aofe99 >= ld_fecini or aofe99 = to_date('0001.01.01','yyyy.mm.dd'))
                 and aotope <> 550
                 and a.pgcod = 1;   
              commit;
          end;
          
          begin
              insert into jaqy349_AUX
              
              select a.pgcod,
                     a.aomod,
                     a.aosuc,
                     a.aomda,
                     a.aopap,
                     a.aocta,
                     a.aooper,
                     a.aosbop,
                     a.aotope,
                     a.aofval,
                     a.aofvto,
                     aofe99,
                     a.aostat,
                     PEPAIS,
                     PETDOC,
                     PENDOC
                from jaqy349_AUX_II a, fsr008 b
               where a.pgcod = b.pgcod
                 and a.aocta = b.ctnro
                 and b.cttfir = 'T';
  
              commit;
          end;
          
          begin
            for i in persona loop
             ln_ins := pq_cr_deudacliente.fn_inserta(i.pepais,i.petdoc,i.pendoc,pd_fecpro); 
                        
             if ln_ins = 0 then
              begin
                select a.jaqy349his
                  into lc_hisAnt
                  from jaqy349 a
                 where a.jaqy349pai = i.pepais
                   and a.jaqy349tdo = i.petdoc
                   and a.jaqy349ndo = i.pendoc 
                   and a.jaqy349fec = ld_fecant;
              Exception
              when no_data_found then
                   lc_hisAnt := null;
              end;
            
              if lc_hisAnt = 'A' then
                lc_tipHN := 'A';
                else
                  
                    ln_contador := pq_cr_deudacliente.Fn_RelCredi_NR(i.pepais,i.petdoc,i.pendoc,pd_fecpro);
                      
                    if ln_contador > 18 then
                        lc_tipHN := 'A';
                        else
                             if ln_contador <= 18 and ln_contador >= 6 then
                                lc_tipHN := 'B';
                                else
                                   if ln_contador < 6 then
                                     lc_tipHN := 'C';
                                   end if;
                             end if;
                     end if;   
              end if;
              
              begin
                insert into jaqy349
                values(i.pepais,i.petdoc,i.pendoc,pd_fecpro,ln_contador,lc_tipHN);
                commit;
              end;
            end if;  
            end loop;
            
          end;
   
          
end Sp_Hist_NR_MENS;  

Function fn_inserta(pn_pai in number,pn_tdo in number,pc_ndo in char,pd_fec in date)return number is
ln_existe number(1);

begin
    
         begin
              select 1
                into ln_existe
                from jaqy349 a
               where a.jaqy349pai = pn_pai
                 and a.jaqy349tdo = pn_tdo
                 and a.jaqy349ndo = pc_ndo
                 and a.jaqy349fec = pd_fec;
                 
         exception
                 when others then 
                      ln_existe := 0;
         end;

         if ln_existe is null then
            ln_existe := 0;
         end if;
         return ln_existe;
end fn_inserta;
 
Function Fn_Refinanciado(pn_pai in number,pn_tdo in number,pc_ndo in char) return char is
  
lc_refinan char(1);
begin
         --******REFINANCIADO*******------
     begin
        select 'S'
          into lc_refinan
          from fsr008 a, fsd010 b
         where a.pepais = pn_pai
           and a.petdoc = pn_tdo
           and a.pendoc = pc_ndo
           and b.pgcod  = 1
           and b.aocta  = a.ctnro
           and b.aostat in (61,33,34)
           and a.cttfir = 'T'
           and a.ttcod  = 1
           and rownum = 1;
     exception
           when no_data_found then
                lc_refinan := 'N';
     end;   
     return lc_refinan; 

end Fn_Refinanciado;
  
Procedure Sp_JudiCast(pn_pai in number,pn_tdo in number,pc_ndo in char,
                      ln_exfin out varchar2) is


 
ln_existe number(1);


begin
     ln_existe := 0;
     ln_exfin  := 'N';    
     --titular
     begin
          select 1
            into ln_existe
            from fsr008 a,fsd010 b
           where a.pepais = pn_pai
             and a.petdoc = pn_tdo
             and a.pendoc = pc_ndo
             and a.pgcod = b.pgcod
             and a.ctnro = b.aocta
             and b.aostat in (21,22,23,25,64,90,33,34)
             and a.cttfir = 'T'
             and a.ttcod  = 1
             and b.aomod in (select modulo from fst111 where dscod = 50)
             and rownum = 1;
     Exception   
             when no_data_found then
                  ln_existe := 0;
     end;
        
     
     
     if ln_existe = 1  then
          ln_exfin := 'S';
     end if;
     
end Sp_JudiCast;

Procedure Sp_Venta(pn_pai in number,pn_tdo in number,pc_ndo in char,
                      ln_exfin out varchar2) is


 
ln_existe number(1);


begin
     ln_existe := 0;
     ln_exfin  := 'N';    
     --titular
     begin
          select 1
            into ln_existe
            from fsr008 a,fsd010 b
           where a.pepais = pn_pai
             and a.petdoc = pn_tdo
             and a.pendoc = pc_ndo
             and a.pgcod = b.pgcod
             and a.ctnro = b.aocta
             and b.aostat =27
             and aomod = 65
             and a.cttfir = 'T'
             and a.ttcod  = 1
             and rownum = 1
             ;
     Exception   
             when no_data_found then
                  ln_existe := 0;
     end;
        
     
     
     if ln_existe = 1  then
          ln_exfin := 'S';
     end if;
     
end Sp_Venta;

Function Fn_cant_instit_Segm(TipDocSbs in char,
                        pc_ndo in char,
                        pd_fecRcc in date,
                        lc_tiper in char
                        )return number is
                        
ln_NumEnt number(10);
lc_CodSbs char(10);

cursor entidades(lc_CodSbs in char) is
select distinct C_CODEMP
  from CLDRCCS
 Where C_CODSBS = lc_CodSbs
   and C_CODEMP <> '00104'
   and (C_CUENTA like '14_1%'
       Or C_CUENTA like '14_2%'  
       Or C_CUENTA like '14_3%' 
       Or C_CUENTA like '14_4%'  
       Or C_CUENTA like '14_5%' 
       Or C_CUENTA like '14_6%' 
       Or C_CUENTA like '71_1%' 
       Or C_CUENTA like '71_2%' 
       Or C_CUENTA like '71_3%' 
       Or C_CUENTA like '71_4%' 
       Or C_CUENTA like '81_302%')
   and D_FECPRE = pd_fecRcc
   and C_CRETIP not in (select a.tp1nro1
                          from fst198 a
                         Where a.Tp1cod   = 1
                           and a.Tp1cod1  = 20001
                           and a.Tp1corr1 = 1
                           and a.Tp1corr2 = 1205);
 
              
begin
      ln_NumEnt := 0;
      begin
          case
             when lc_tiper = 'F' then
                  begin
                     select C_CODSBS
                       into lc_CodSbs
                       from CLDRCCI
                      Where D_FECPRE = pd_fecRcc
                        and C_TDOCID = TipDocSbs 
                        and C_DOCIDE = trim(pc_ndo)
                        and rownum = 1;
                  exception
                        when no_data_found then
                             lc_CodSbs := NULL;
                  end;
             when lc_tiper = 'J' then
                  begin
                     select C_CODSBS
                       into lc_CodSbs
                       from CLDRCCI
                      Where D_FECPRE = pd_fecRcc
                        and C_TDOCTR = TipDocSbs 
                        and C_DOCTRI = trim(pc_ndo)
                        and rownum = 1;
                  exception
                        when no_data_found then
                             lc_CodSbs := NULL;
                  end;
              else
                  null;
                  --insert into jaqz082_aux(jaqz082ndo) values (pc_ndo);
                  --commit;
                  --dbms_output.put_line ('case: '||pc_ndo);
         end case;
         
         begin
            for i in entidades (lc_CodSbs) loop 
                ln_NumEnt := ln_NumEnt + 1;
                
            end loop;
         End;
      
      end;
      return ln_NumEnt;

end Fn_cant_instit_Segm;
-----------------------------------------------------------
Procedure Sp_Consolida_I is
cursor creditos is
select * from jaqy345 a /*where a.jaqy345ndo='23923499'*/; 
lc_flag char(1) ;
ln_dig VARCHAR2(2);
begin
  execute immediate ('Truncate table jaqy347_aux');
  begin
       insert into jaqy347_aux(jaqy347pai,jaqy347tdo,jaqy347ndo,jaqy347dig)
          select distinct a.jaqy346pai,
                 a.jaqy346tdo,
                 a.jaqy346ndo,
                 substr(trim(jaqy346ndo), -1, 1)
            from jaqy346 a;
       commit;
  end;
  commit;
  
  begin
    for i in creditos loop
        lc_flag := 'N';
        begin
          select 'S'
            into lc_flag
            from jaqy347_aux a
           where a.jaqy347pai = i.jaqy345pai
             and a.jaqy347tdo = i.jaqy345tdo
             and a.jaqy347ndo = i.jaqy345ndo;
        exception
          when others then 
               lc_flag := 'N';
        end;
        if lc_flag = 'N' then
           ln_dig := null;
           ln_dig := substr(trim(i.jaqy345ndo), -1, 1);
           begin
                 insert into jaqy347_aux
                 values(i.jaqy345pai,i.jaqy345tdo,i.jaqy345ndo,ln_dig);
                 commit;
            end;
            commit;
        end if;
    end loop;
  end; 
end Sp_Consolida_I;
----------------------------------------------------------------------------------------------------------------
Procedure sp_job_Sp_Consolida_II (pd_fecpro in date ) is
  --ln_max number;
  --ln_inc number;
  lv_ini varchar2(5);
  --ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor c_clientes_job is 
		  /*select distinct j.jaqy347tdo digito
          from jaqy347_aux j;*/
      select distinct substr(trim(jaqy347ndo), -1, 1) digito
       
          from jaqy347_aux j
         where substr(trim(jaqy347ndo), -1, 1) in
         ('0','1','2','3','4','5','6','7','8','9');
         
  begin
     begin
      select host_name
        into lc_hostname
        from v$instance;
    end;
    
     execute immediate ('Truncate table jaqy347');
     delete Tab_jobs where  c_Codage = 'DBC';
     commit;
     delete from log_error_bandeja a where a.c_codbdj ='DBC';
     commit;
     begin
      -- Call the procedure
      pq_cr_deudacliente.sp_consolida_iii(pd_fecpro);
    end;
     for i in c_clientes_job loop
        lv_ini := i.digito;
        lc_variable := ' begin '|| '  PQ_CR_DEUDACLIENTE.Sp_Consolida_II('||i.digito||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
        --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
--         if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then             
--         if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
IF SYS.FN_BD_ISRAC='TRUE' THEN
           DBMS_JOB.SUBMIT(job => ln_job, 
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
                       -- instance => 2, -- 24/10/2023
                        instance => 1,
                        force => false
                        );
          else
            DBMS_JOB.SUBMIT(job => ln_job, 
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
                        force => false
                        );
          end if;

        INSERT INTO Tab_jobs (c_Codage,c_Dato1,c_detjob)
        VALUES('DBC',lv_ini,lc_variable);
        COMMIT;
      end loop;
  exception
     when others then
           --lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'DBC',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

end sp_job_Sp_Consolida_II;    
procedure Sp_Consolida_II (P_C_DIGITO in varchar2 ,pd_fecpro in date)is
  
  cursor creditos is
   select *
    from jaqy347_aux a
   where substr(trim(jaqy347ndo), -1, 1)=P_C_DIGITO;
    
    
ln_rcc number(17,2);

ln_ent number(10);
ln_sdo number(17,2);
ln_cal number(10,5);
ln_cas number(10,5);
ln_sbs varchar2(12);

ln_cur number(17,2);
ln_res number(17,2);
ln_pat number(17,2);
ln_ban number(17,2);

ln_capend number(17,2);
ln_capago number(17,2);

ln_entTot number(10);
ln_hip number(17,2);
ln_pym number(17,2);
ln_con number(17,2);
lc_coderr varchar2(300);
  
begin
/*    select j.jaql983cor ln_corr, j.jaql983ffi ln_fecf
      from jaql983 j
     where j.jaql983cor > 14
       and j.jaql983ffi <> null;*/
       
    update tab_jobs g
       set g.d_fecini = sysdate
     where g.C_DATO1 = P_C_DIGITO
       and g.c_codage = 'DBC';
    commit;
  begin
     
     
     for i in creditos loop
      ln_pat := null;
      ln_rcc := null;  
      ln_ban := null;
      ln_capend := null;
      ln_res := null;
      ln_cur := null;
      ln_capago := null;
      ln_sdo := null;
      ln_cal := null;
      ln_cas := null;
      ln_ent := null;
      ln_sbs := null;
      ln_entTot := null;
      ln_hip := null;
      ln_pym := null;
      ln_con := null;
      
      if i.jaqy347pai is not null then
        begin
          select a.jaqy346pat,
                 a.jaqy346ent,
                 a.jaqy346sdo,
                 a.jaqy346cal,
                 a.jaqy346cas,
                 a.jaqy346sbs,
                 a.jaqy346hip,
                 a.jaqy346con,
                 a.jaqy346pym,
                 a.jaqy346eto
            into ln_rcc,   --deuda pyme rcc       
                 ln_ent,   --entidades
                 ln_sdo,   --endeudamiento total
                 ln_cal,   --calificacion ultimo mes
                 ln_cas,   --calificacion 6 ultimos meses
                 ln_sbs,    --codigo sbs      
                 ln_hip,   --saldo hipotecario
                 ln_con,   --saldo consumo
                 ln_pym,   --saldo pyme
                 ln_entTot --entidades totales                       
            from jaqy346 a
           where a.jaqy346pai = i.jaqy347pai
             and a.jaqy346tdo = i.jaqy347tdo
             and a.jaqy346ndo = i.jaqy347ndo;
        exception 
          when too_many_rows then
               begin
                  select a.jaqy346pat,
                         a.jaqy346ent,
                         a.jaqy346sdo,
                         a.jaqy346cal,
                         a.jaqy346cas,
                         a.jaqy346sbs,
                         a.jaqy346hip,
                         a.jaqy346con,
                         a.jaqy346pym,
                         a.jaqy346eto
                    into ln_rcc,     
                         ln_ent,
                         ln_sdo,
                         ln_cal,
                         ln_cas,
                         ln_sbs,
                         ln_hip,  
                         ln_con,  
                         ln_pym,  
                         ln_entTot                                          
                    from jaqy346 a
                   where a.jaqy346pai = i.jaqy347pai
                     and a.jaqy346tdo = i.jaqy347tdo
                     and a.jaqy346ndo = i.jaqy347ndo
                     and a.jaqy346cpe = 1;
                exception 
                  when too_many_rows then
                       begin
                            select a.jaqy346pat,
                                   a.jaqy346ent,
                                   a.jaqy346sdo,
                                   a.jaqy346cal,
                                   a.jaqy346cas,
                                   a.jaqy346sbs,
                                   a.jaqy346hip,
                                   a.jaqy346con,
                                   a.jaqy346pym,
                                   a.jaqy346eto
                              into ln_rcc, 
                                   ln_ent, 
                                   ln_sdo, 
                                   ln_cal, 
                                   ln_cas, 
                                   ln_sbs,
                                   ln_hip,  
                                   ln_con,  
                                   ln_pym,  
                                   ln_entTot  
                              from jaqy346 a
                             where a.jaqy346pai = i.jaqy347pai
                               and a.jaqy346tdo = i.jaqy347tdo
                               and a.jaqy346ndo = i.jaqy347ndo
                               and a.jaqy346cpe = 1
                               and rownum = 1;
                          exception 
                            when others then null;                              
                          end;
                   when others then null;
                end;
           when others then null;
        end;
        
        else
                begin
          select a.jaqy346pat,
                 a.jaqy346ent,
                 a.jaqy346sdo,
                 a.jaqy346cal,
                 a.jaqy346cas,
                 a.jaqy346sbs,
                 a.jaqy346hip,
                 a.jaqy346con,
                 a.jaqy346pym,
                 a.jaqy346eto
            into ln_rcc,   --deuda pyme rcc       
                 ln_ent,   --entidades
                 ln_sdo,   --endeudamiento total
                 ln_cal,   --calificacion ultimo mes
                 ln_cas,   --calificacion 6 ultimos meses
                 ln_sbs,    --codigo sbs   
                 ln_hip,  
                 ln_con,  
                 ln_pym,  
                 ln_entTot                          
            from jaqy346 a
           where a.jaqy346tdo = i.jaqy347tdo
             and a.jaqy346ndo = i.jaqy347ndo;
        exception 
          when too_many_rows then
               begin
                  select a.jaqy346pat,
                         a.jaqy346ent,
                         a.jaqy346sdo,
                         a.jaqy346cal,
                         a.jaqy346cas,
                         a.jaqy346sbs,
                         a.jaqy346hip,
                         a.jaqy346con,
                         a.jaqy346pym,
                         a.jaqy346eto
                    into ln_rcc,     
                         ln_ent,
                         ln_sdo,
                         ln_cal,
                         ln_cas,
                         ln_sbs,
                         ln_hip,  
                         ln_con,  
                         ln_pym,  
                         ln_entTot                 
                    from jaqy346 a
                   where a.jaqy346tdo = i.jaqy347tdo
                     and a.jaqy346ndo = i.jaqy347ndo
                     and a.jaqy346cpe = 1;
                exception 
                  when too_many_rows then
                       begin
                            select a.jaqy346pat,
                                   a.jaqy346ent,
                                   a.jaqy346sdo,
                                   a.jaqy346cal,
                                   a.jaqy346cas,
                                   a.jaqy346sbs,
                                   a.jaqy346hip,
                                   a.jaqy346con,
                                   a.jaqy346pym,
                                   a.jaqy346eto
                              into ln_rcc, 
                                   ln_ent, 
                                   ln_sdo, 
                                   ln_cal, 
                                   ln_cas, 
                                   ln_sbs,
                                   ln_hip,  
                                   ln_con,  
                                   ln_pym,  
                                   ln_entTot                                     
                              from jaqy346 a
                             where a.jaqy346tdo = i.jaqy347tdo
                               and a.jaqy346ndo = i.jaqy347ndo
                               and a.jaqy346cpe = 1
                               and rownum = 1;
                          exception 
                            when others then null;                              
                          end;
                   when others then null;
                end;
           when others then null;
        end;
     end if;
     
     
     
        begin
           select a.jaqy345cur,
                  a.jaqy345res,
                  a.jaqy345pat,
                  a.jaqy345ban
             into ln_cur,--cuota bantotal
                  ln_res,--resultado neto
                  ln_pat,--patrimonio
                  ln_ban --deuda bantotal           
             from jaqy345 a
            where a.jaqy345pai = i.jaqy347pai
              and a.jaqy345tdo = i.jaqy347tdo
              and a.jaqy345ndo = i.jaqy347ndo;
        exception 
          when others then null;
        end;
        
        
        ln_capago  := nvl(ln_res,0) - nvl(ln_cur,0);
        if ln_pat is not null then
           ln_capend  := nvl(ln_pat,0) - (nvl(ln_rcc,0) + nvl(ln_ban,0));
           else
             ln_capend  := nvl(ln_rcc,0) + nvl(ln_ban,0);
             
        end if;
        
        begin
        insert into jaqy347(jaqy347pai,
                            jaqy347tdo,
                            jaqy347ndo,
                            jaqy347fec,
                            jaqy347pat,
                            jaqy347rcc,
                            jaqy347ban,
                            jaqy347cen,
                            jaqy347res,
                            jaqy347cba,
                            jaqy347cpa,
                            jaqy347sdt,
                            jaqy347cal,
                            jaqy347cas,
                            jaqy347ent,
                            jaqy347sbs,jaqy347hip,jaqy347con,jaqy347pym,jaqy347eto)
                     values(i.jaqy347pai,
                            i.jaqy347tdo,
                            i.jaqy347ndo,
                            pd_fecpro,
                            ln_pat,
                            ln_rcc,  
                            ln_ban, 
                            ln_capend,
                            ln_res, 
                            ln_cur,
                            ln_capago,
                            ln_sdo,
                            ln_cal,
                            ln_cas,
                            ln_ent,
                            ln_sbs,
                            ln_hip,  
                            ln_con,  
                            ln_pym,  
                            ln_entTot);
                     commit;
        end;
        commit;             
    end loop;
  commit;
  
  end;
  
    update tab_jobs g
       set g.d_fecfin = sysdate
     where g.C_DATO1 =  P_C_DIGITO
       and g.c_codage = 'DBC';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.C_DATO1 = P_C_DIGITO
         and g.c_codage = 'DBC';
    commit;
    return;

end Sp_Consolida_II;

procedure Sp_Consolida_III (pd_fecpro in date)is
  
  cursor creditos is
   select *
    from jaqy347_aux a
   where substr(trim(jaqy347ndo), -1, 1)
   in ('A','a','B','b','C','c','D','d','E','e',
       'F','f','G','g','H','h','I','i','J','j',
       'H','h','I','i','J','j','K','k','L','l',
       'M','m','N','n','O','o','P','p','Q','q',
       'R','r','S','s','T','t','U','u','V','v',
       'W','w','X','x','Y','y','Z','z');
    
    
ln_rcc number(17,2);

ln_ent number(10);
ln_sdo number(17,2);
ln_cal number(10,5);
ln_cas number(10,5);
ln_sbs varchar2(12);

ln_cur number(17,2);
ln_res number(17,2);
ln_pat number(17,2);
ln_ban number(17,2);

ln_capend number(17,2);
ln_capago number(17,2);

ln_entTot number(10);
ln_hip number(17,2);
ln_pym number(17,2);
ln_con number(17,2);

  
begin


  begin
     
     
     for i in creditos loop
      ln_pat := null;
      ln_rcc := null;  
      ln_ban := null;
      ln_capend := null;
      ln_res := null;
      ln_cur := null;
      ln_capago := null;
      ln_sdo := null;
      ln_cal := null;
      ln_cas := null;
      ln_ent := null;
      ln_sbs := null;
      ln_entTot := null;
      ln_hip := null;
      ln_pym := null;
      ln_con := null;
      
      if i.jaqy347pai is not null then
        begin
          select a.jaqy346pat,
                 a.jaqy346ent,
                 a.jaqy346sdo,
                 a.jaqy346cal,
                 a.jaqy346cas,
                 a.jaqy346sbs,
                 a.jaqy346hip,
                 a.jaqy346con,
                 a.jaqy346pym,
                 a.jaqy346eto
            into ln_rcc,   --deuda pyme rcc       
                 ln_ent,   --entidades
                 ln_sdo,   --endeudamiento total
                 ln_cal,   --calificacion ultimo mes
                 ln_cas,   --calificacion 6 ultimos meses
                 ln_sbs,    --codigo sbs      
                 ln_hip,   --saldo hipotecario
                 ln_con,   --saldo consumo
                 ln_pym,   --saldo pyme
                 ln_entTot --entidades totales                       
            from jaqy346 a
           where a.jaqy346pai = i.jaqy347pai
             and a.jaqy346tdo = i.jaqy347tdo
             and a.jaqy346ndo = i.jaqy347ndo;
        exception 
          when too_many_rows then
               begin
                  select a.jaqy346pat,
                         a.jaqy346ent,
                         a.jaqy346sdo,
                         a.jaqy346cal,
                         a.jaqy346cas,
                         a.jaqy346sbs,
                         a.jaqy346hip,
                         a.jaqy346con,
                         a.jaqy346pym,
                         a.jaqy346eto
                    into ln_rcc,     
                         ln_ent,
                         ln_sdo,
                         ln_cal,
                         ln_cas,
                         ln_sbs,
                         ln_hip,  
                         ln_con,  
                         ln_pym,  
                         ln_entTot                                          
                    from jaqy346 a
                   where a.jaqy346pai = i.jaqy347pai
                     and a.jaqy346tdo = i.jaqy347tdo
                     and a.jaqy346ndo = i.jaqy347ndo
                     and a.jaqy346cpe = 1;
                exception 
                  when too_many_rows then
                       begin
                            select a.jaqy346pat,
                                   a.jaqy346ent,
                                   a.jaqy346sdo,
                                   a.jaqy346cal,
                                   a.jaqy346cas,
                                   a.jaqy346sbs,
                                   a.jaqy346hip,
                                   a.jaqy346con,
                                   a.jaqy346pym,
                                   a.jaqy346eto
                              into ln_rcc, 
                                   ln_ent, 
                                   ln_sdo, 
                                   ln_cal, 
                                   ln_cas, 
                                   ln_sbs,
                                   ln_hip,  
                                   ln_con,  
                                   ln_pym,  
                                   ln_entTot  
                              from jaqy346 a
                             where a.jaqy346pai = i.jaqy347pai
                               and a.jaqy346tdo = i.jaqy347tdo
                               and a.jaqy346ndo = i.jaqy347ndo
                               and a.jaqy346cpe = 1
                               and rownum = 1;
                          exception 
                            when others then null;                              
                          end;
                   when others then null;
                end;
           when others then null;
        end;
        
        else
                begin
          select a.jaqy346pat,
                 a.jaqy346ent,
                 a.jaqy346sdo,
                 a.jaqy346cal,
                 a.jaqy346cas,
                 a.jaqy346sbs,
                 a.jaqy346hip,
                 a.jaqy346con,
                 a.jaqy346pym,
                 a.jaqy346eto
            into ln_rcc,   --deuda pyme rcc       
                 ln_ent,   --entidades
                 ln_sdo,   --endeudamiento total
                 ln_cal,   --calificacion ultimo mes
                 ln_cas,   --calificacion 6 ultimos meses
                 ln_sbs,    --codigo sbs   
                 ln_hip,  
                 ln_con,  
                 ln_pym,  
                 ln_entTot                          
            from jaqy346 a
           where a.jaqy346tdo = i.jaqy347tdo
             and a.jaqy346ndo = i.jaqy347ndo;
        exception 
          when too_many_rows then
               begin
                  select a.jaqy346pat,
                         a.jaqy346ent,
                         a.jaqy346sdo,
                         a.jaqy346cal,
                         a.jaqy346cas,
                         a.jaqy346sbs,
                         a.jaqy346hip,
                         a.jaqy346con,
                         a.jaqy346pym,
                         a.jaqy346eto
                    into ln_rcc,     
                         ln_ent,
                         ln_sdo,
                         ln_cal,
                         ln_cas,
                         ln_sbs,
                         ln_hip,  
                         ln_con,  
                         ln_pym,  
                         ln_entTot                 
                    from jaqy346 a
                   where a.jaqy346tdo = i.jaqy347tdo
                     and a.jaqy346ndo = i.jaqy347ndo
                     and a.jaqy346cpe = 1;
                exception 
                  when too_many_rows then
                       begin
                            select a.jaqy346pat,
                                   a.jaqy346ent,
                                   a.jaqy346sdo,
                                   a.jaqy346cal,
                                   a.jaqy346cas,
                                   a.jaqy346sbs,
                                   a.jaqy346hip,
                                   a.jaqy346con,
                                   a.jaqy346pym,
                                   a.jaqy346eto
                              into ln_rcc, 
                                   ln_ent, 
                                   ln_sdo, 
                                   ln_cal, 
                                   ln_cas, 
                                   ln_sbs,
                                   ln_hip,  
                                   ln_con,  
                                   ln_pym,  
                                   ln_entTot                                     
                              from jaqy346 a
                             where a.jaqy346tdo = i.jaqy347tdo
                               and a.jaqy346ndo = i.jaqy347ndo
                               and a.jaqy346cpe = 1
                               and rownum = 1;
                          exception 
                            when others then null;                              
                          end;
                   when others then null;
                end;
           when others then null;
        end;
     end if;
     
     
     
        begin
           select a.jaqy345cur,
                  a.jaqy345res,
                  a.jaqy345pat,
                  a.jaqy345ban
             into ln_cur,--cuota bantotal
                  ln_res,--resultado neto
                  ln_pat,--patrimonio
                  ln_ban --deuda bantotal           
             from jaqy345 a
            where a.jaqy345pai = i.jaqy347pai
              and a.jaqy345tdo = i.jaqy347tdo
              and a.jaqy345ndo = i.jaqy347ndo;
        exception 
          when others then null;
        end;
        
        
        ln_capago  := nvl(ln_res,0) - nvl(ln_cur,0);
        if ln_pat is not null then
           ln_capend  := nvl(ln_pat,0) - (nvl(ln_rcc,0) + nvl(ln_ban,0));
           else
             ln_capend  := nvl(ln_rcc,0) + nvl(ln_ban,0);
             
        end if;
        
        begin
        insert into jaqy347(jaqy347pai,
                            jaqy347tdo,
                            jaqy347ndo,
                            jaqy347fec,
                            jaqy347pat,
                            jaqy347rcc,
                            jaqy347ban,
                            jaqy347cen,
                            jaqy347res,
                            jaqy347cba,
                            jaqy347cpa,
                            jaqy347sdt,
                            jaqy347cal,
                            jaqy347cas,
                            jaqy347ent,
                            jaqy347sbs,jaqy347hip,jaqy347con,jaqy347pym,jaqy347eto)
                     values(i.jaqy347pai,
                            i.jaqy347tdo,
                            i.jaqy347ndo,
                            pd_fecpro,
                            ln_pat,
                            ln_rcc,  
                            ln_ban, 
                            ln_capend,
                            ln_res, 
                            ln_cur,
                            ln_capago,
                            ln_sdo,
                            ln_cal,
                            ln_cas,
                            ln_ent,
                            ln_sbs,
                            ln_hip,  
                            ln_con,  
                            ln_pym,  
                            ln_entTot);
                     commit;
        end;
        commit;             
    end loop;
  commit;
  
  end;
  
  

end Sp_Consolida_III;

Procedure Sp_cr_carga_ini(pd_Fecpro in date) is

begin
  execute immediate ('Truncate table JAQY346_AUX');
  begin
  
    INSERT INTO JAQY346_AUX     

  select /*+parallel (c,4,1)*/ a.pepais, a.petdoc, a.pendoc,substr(trim(a.pendoc), -1, 1)
        from fsd010 c,fsr008 a----fsd010 c,fsr008 a
       where (aomod in (select modulo
                   from fst111 --fst111
                  where dscod = 50
                    and modulo not in (120, 142))
             or aomod = 117)
             and aofval <= pd_Fecpro
             and c.aocta = a.ctnro
             and a.ttcod = 1
             and a.cttfir = 'T'
             and substr(trim(a.pendoc), -1, 1)<>'x'
             --and aostat <>99 --comentar si se quiere procesar toda la cartera

      group by a.pepais, a.petdoc, a.pendoc,substr(trim(a.pendoc), -1, 1)
             ;
             
             COMMIT;
    end;
  
end Sp_cr_carga_ini;
Procedure sp_job_Carga_Eval is
  --ln_max number;
  --ln_inc number;
  lv_ini varchar2(3);
  --ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor c_clientes_job is 
      select distinct j.jaqy346dig digito
          from JAQY346_AUX j;
         
  begin
     execute immediate('Truncate table JAQY346_AUX_II');
     delete Tab_jobs where  c_Codage = 'DBE';
     commit;
     delete from log_error_bandeja a where a.c_codbdj ='DBE';
     commit;
     
     begin
    select host_name
      into lc_hostname
      from v$instance;
  end;



     for i in c_clientes_job loop
        lv_ini := i.digito;
        lc_variable := ' begin '|| '  PQ_CR_DEUDACLIENTE.Sp_cr_carga_Eval('||lv_ini||');'|| ' End; ';
        ln_job := ln_job +1;
        --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
--         if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then             
--         if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
IF SYS.FN_BD_ISRAC='TRUE' THEN
           DBMS_JOB.SUBMIT(job => ln_job, 
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
                        instance => 1,
                        --instance => 2, 01/01/2024
                        force => false
                        );
          else
            DBMS_JOB.SUBMIT(job => ln_job, 
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
                        force => false
                        );
          end if;

        INSERT INTO Tab_jobs (c_Codage,C_DATO1,c_detjob)
        VALUES('DBE',lv_ini,lc_variable);
        COMMIT;
      end loop;
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'DBE',lc_coderr, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

end sp_job_Carga_Eval;        
Procedure Sp_cr_carga_Eval(P_C_DIGITO in varchar2) is

cursor creDitos is
select * from jaqy346_aux a
where a.jaqy346dig = P_C_DIGITO;

ln_SegLinea number(2);
pn_pat number(17,2);
pn_RES number(17,2);
lc_coderr varchar2(100);
begin
  update tab_jobs g
       set g.d_fecini = sysdate
     where g.n_numer1 = P_C_DIGITO
       and g.c_codage = 'DBE';
    commit;
  begin
    for i in creditos loop
          begin
              select b.segcod
              into ln_SegLinea
              from sngc60 a,sngc07 b
              where a.sngc60pais = i.JAQY346PAI
              and a.sngc60tdoc   = i.JAQY346TDO
              and a.sngc60ndoc   = i.JAQY346NDO
              and a.sngc60ocup   = b.sngc07cod;
              exception 
              when others then null;
          end; 

          if i.JAQY346TDO = 9 then
             ln_SegLinea := 1;
          end if;
          
          if ln_SegLinea = 1 then --PYME
                pq_cr_deudacliente.Sp_ResNeto_ExcMens(i.JAQY346PAI,i.JAQY346TDO,i.JAQY346NDO,
                                                      1,pn_res,pn_pat);
                                          
                BEGIN
                      INSERT INTO JAQY346_AUX_II (JAQY346PAI, JAQY346TDO, JAQY346NDO, JAQY346RES, 
                                                  JAQY346PAT) 
                      VALUES (i.JAQY346PAI,i.JAQY346TDO,i.JAQY346NDO,pn_res,pn_pat);
                      commit; 
                exception
                   when others then
                         lc_coderr:=sqlerrm;
                         INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
                         VALUES(0,'DBE',P_C_DIGITO||lc_coderr, TRUNC(SYSDATE));
                         COMMIT;      
                END;
                                    
            else --CONSUMO
                                          
                   pq_cr_deudacliente.Sp_ResNeto_ExcMens(i.JAQY346PAI,i.JAQY346TDO,i.JAQY346NDO,
                                                         2,pn_res,pn_pat);
                                          
                BEGIN
                                          
                       INSERT INTO JAQY346_AUX_II (JAQY346PAI, JAQY346TDO, JAQY346NDO, JAQY346RES, 
                                                  JAQY346PAT) 
                      VALUES (i.JAQY346PAI,i.JAQY346TDO,i.JAQY346NDO,pn_res,pn_pat);
                      commit; 
                  exception
                   when others then
                         lc_coderr:=sqlerrm;
                         INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
                         VALUES(0,'DBE',P_C_DIGITO||lc_coderr, TRUNC(SYSDATE));
                         COMMIT;
               
                  END;
          end if;
                              
                              
     end loop;
     COMMIT;
     
   update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  P_C_DIGITO
       and g.c_codage = 'DBE';
    commit;
    end;
    
     EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = P_C_DIGITO
         and g.c_codage = 'DBE';
    commit;
    return;
                
end Sp_cr_carga_Eval;
Procedure Sp_ResNeto_ExcMens(pn_pai in number,pn_tip in number,pc_ndo in char,pn_ind in number,
                             pn_res out number,pn_pat out number)is

--ld_fecev date;--mod@abr 20160914
--ld_fecant date;--mod@abr 20160914
--ld_fecact date;--mod@abr 20160914
ln_ins   number(10);
ln_eva   number(10);
--lc_flg   char(1);
ln_mntsoles       number(17,2);
ln_mntdolar       number(17,2);
ln_mntsolesPat       number(17,2);
ln_mntdolarPat       number(17,2);
--ln_tipact number(14,8);--mod@abr 20160914
--ln_tipAnt number(14,8);--mod@abr 20160914
ln_tipfin number(14,8);
--ln_insAnt number(10) ;--mod@abr 20160914


--cursor creditos is --mod@abr 20160914
--select *--mod@abr 20160914
--  from fsr008 a,sng001 b,xwf070 c--mod@abr 20160914
--where a.pepais =  pn_pai--mod@abr 20160914
--   and a.petdoc = pn_tip--mod@abr 20160914
--   and a.pendoc = pc_ndo--'43513431'--mod@abr 20160914
--   and a.cttfir = 'T'--mod@abr 20160914
--   and a.ctnro  = b.sng001cta--mod@abr 20160914
--   and c.xwfprcin = b.sng001inst --mod@abr 20160914
--   and c.xwfcont  = 'S';--mod@abr 20160914

begin
    --si pn_ind = 1 => Pyme
    --si pn_ind = 2 => Consumo
    begin
       --ld_fecant := null;--mod@abr 20160914
       --for i in creditos loop --mod@abr 20160914

             begin
                select max(a.sng021sol)
                  into ln_ins
                  from sng021 a 
                 where a.sng021pdoc = pn_pai
                   and a.sng021tdoc = pn_tip
                   and a.sng021ndoc = pc_ndo;
             exception
                when too_many_rows then
                     begin
                        select max(a.sng021sol)
                          into ln_ins
                          from sng021 a 
                         where a.sng021pdoc = pn_pai
                           and a.sng021tdoc = pn_tip
                           and a.sng021ndoc = pc_ndo
                           and rownum = 1;
                     exception
                        when others then null;
                     end;
                when no_data_found then null; 
             end;
             
              begin
                     select a.sng120tcbi
                       into ln_tipfin
                       from sng120 a
                      where a.sng120ins = ln_ins
                        and a.sng120tsk = 'EVALUACION';
              exception 
                when too_many_rows then 
                     begin
                             select a.sng120tcbi
                               into ln_tipfin
                               from sng120 a
                              where a.sng120ins = ln_ins
                                and a.sng120tsk = 'EVALUACION'
                                and rownum = 1;
                      exception 
                        when others then null;
                  
                      end;
                when others then  
                    null;
              end;

              /*if ld_fecant is null then
                 ld_fecev := ld_fecact;
                 ln_ins   := i.sng001inst;
                 ln_tipfin := ln_tipact;
                 else
                   if ld_fecant > ld_fecact then
                      ld_fecev := ld_fecant;
                      ln_ins   := ln_insAnt;
                      ln_tipfin := ln_tipAnt;
                      else
                        ld_fecev := ld_fecact;
                        ln_ins   := i.sng001inst;
                        ln_tipfin := ln_tipact;
                   end if;

              end if;
              ld_fecant := ld_fecact;
              ln_insAnt := i.sng001inst;
              ln_tipAnt := ln_tipact;*/
           --end if;
       --end loop; --mod@abr 20160914

   end;

   begin
     select a.sng021eval
       into ln_eva
       from sng021 a
      where a.sng021sol = ln_ins;
   exception
     when others then null;
   end;

   if pn_ind = 1 then
      begin
        select a.sng023mto
          into ln_mntsoles
          from sng023 a
         where a.sng021eval = ln_eva
           and a.sng026cod = 40;
      exception
        when others then
          null;
      end;

      begin
        select a.sng023mto
          into ln_mntdolar
          from sng023 a
         where a.sng021eval = ln_eva
           and a.sng026cod = 540;
      exception
        when others then
          null;
      end;
      --patrimonio
      begin
        select a.sng023mto
          into ln_mntsolesPat
          from sng023 a
         where a.sng021eval = ln_eva
           and a.sng026cod = 70;
      exception
        when others then
          null;
      end;

      begin
        select a.sng023mto
          into ln_mntdolarPat
          from sng023 a
         where a.sng021eval = ln_eva
           and a.sng026cod = 570;
      exception
        when others then
          null;
      end;
   
      else
           begin
              select a.sng023mto
                into ln_mntsoles
                from sng023 a
               where a.sng021eval = ln_eva
                 and a.sng026cod = 27;
            exception
              when others then
                null;
            end;

            begin
              select a.sng023mto
                into ln_mntdolar
                from sng023 a
               where a.sng021eval = ln_eva
                 and a.sng026cod = 527;
            exception
              when others then
                null;
            end;

            
   end if;
   
   pn_res := ((ln_mntdolar * ln_tipfin) + ln_mntsoles);
   pn_pat := ((ln_mntdolarPat * ln_tipfin) + ln_mntsolesPat);


end Sp_ResNeto_ExcMens;

Procedure Sp_ResNeto_ExcMens_Dia(pn_pai in number,pn_tip in number,pc_ndo in char,pd_fecpro in date,
                            pn_ind in number,pn_res out number,pn_pat out number)is





ln_eva   number(10);
--lc_flg   char(1);
ln_mntsoles       number(17,2);
ln_mntdolar       number(17,2);
ln_mntsolesPat       number(17,2);
ln_mntdolarPat       number(17,2);

ln_tipfin number(14,8);


ld_fecini date;
ln_emp number(3);
ln_mod number(3);
ln_suc number(3);
ln_mda number(4);
ln_pap number(4);
ln_cta number(9);
ln_ope number(9);
ln_sbo number(3);
ln_top number(3);
ln_ins   number(10);

begin
   ld_fecini := to_date('01'||to_char(pd_fecpro,'mmyyyy'),'ddmmyyyy');
   begin
       select a.jaql982pcod,
              a.jaql982mod,
              a.jaql982suc,
              a.jaql982mda,
              a.jaql982pap,
              a.jaql982cta,
              a.jaql982ope,
              a.jaql982sbop,
              a.jaql982tope
         into ln_emp,
              ln_mod,
              ln_suc,
              ln_mda,
              ln_pap,
              ln_cta,
              ln_ope,
              ln_sbo,
              ln_top                 
         from jaql982 a
        where a.jaql982pais = pn_pai
          and a.jaql982tid  = pn_tip
          and a.jaql982doc  = pc_ndo
          and a.jaql982fval = (select max(aa.jaql982fval)
                                 from jaql982 aa
                                where aa.jaql982pais = a.jaql982pais
                                  and aa.jaql982tid  = a.jaql982tid 
                                  and aa.jaql982doc  = a.jaql982doc 
                                  and aa.jaql982fval between ld_fecini and pd_fecpro
                                  group by aa.jaql982pais
                                  );
   exception
     when others then null;
     
   end;
   
   if ln_cta is null then
      
      begin
        select a.jaqy346res
          into pn_res
          from jaqy346_aux_ii a
         where a.jaqy346pai = pn_pai
           and a.jaqy346tdo = pn_tip
           and a.jaqy346ndo = pc_ndo;
      exception
        when others then null;     
      end;
      
      begin
        select a.jaqy346pat
          into pn_pat
          from jaqy346_aux_ii a
         where a.jaqy346pai = pn_pai
           and a.jaqy346tdo = pn_tip
           and a.jaqy346ndo = pc_ndo;
      exception
        when others then null;     
      end;
      
      else
        ln_ins := fn_instancia_credito(ln_mod,
                                       ln_suc,
                                       ln_mda,
                                       ln_pap,
                                       ln_cta,
                                       ln_ope,
                                       ln_sbo,
                                       ln_top);
        
        begin
               select a.sng120tcbi
                 into ln_tipfin
                 from sng120 a
                where a.sng120ins = ln_ins
                  and a.sng120tsk = 'EVALUACION';
        exception 
          when others then null;
        end;
        begin
         select a.sng021eval
           into ln_eva
           from sng021 a
          where a.sng021sol = ln_ins;
       exception
         when others then null;
       end;

       if pn_ind = 1 then
           begin
              select a.sng023mto
                into ln_mntsoles
                from sng023 a
               where a.sng021eval = ln_eva
                 and a.sng026cod = 40;
            exception
              when others then
                null;
            end;

            begin
              select a.sng023mto
                into ln_mntdolar
                from sng023 a
               where a.sng021eval = ln_eva
                 and a.sng026cod = 540;
            exception
              when others then
                null;
            end;
            --patrimonio
            begin
              select a.sng023mto
                into ln_mntsolesPat
                from sng023 a
               where a.sng021eval = ln_eva
                 and a.sng026cod = 70;
            exception
              when others then
                null;
            end;

            begin
              select a.sng023mto
                into ln_mntdolarPat
                from sng023 a
               where a.sng021eval = ln_eva
                 and a.sng026cod = 570;
            exception
              when others then
                null;
            end;
            
            else
              
                 begin
                    select a.sng023mto
                      into ln_mntsoles
                      from sng023 a
                     where a.sng021eval = ln_eva
                       and a.sng026cod = 27;
                  exception
                    when others then
                      null;
                  end;

                  begin
                    select a.sng023mto
                      into ln_mntdolar
                      from sng023 a
                     where a.sng021eval = ln_eva
                       and a.sng026cod = 527;
                  exception
                    when others then
                      null;
                  end;
        end if;

        pn_res := ((ln_mntdolar * ln_tipfin) + ln_mntsoles);
        pn_pat := ((ln_mntdolarPat * ln_tipfin) + ln_mntsolesPat);
        
   
   end if;


end Sp_ResNeto_ExcMens_Dia;
Procedure Sp_cr_job_SaldDiv  is
  --ln_max number;
  --ln_inc number;
  ln_ini number;
  --ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor c_clientes_job is 
         select substr(trim(j.jaqy347sbs), -1, 1) digito
          from jaqy347 j
         where j.jaqy347sbs is not null
         group by substr(trim(j.jaqy347sbs), -1, 1);
         
  begin
     delete Tab_jobs where  c_Codage = 'DB5';
     commit;
     delete from log_error_bandeja a where a.c_codbdj ='DB5';
     commit;
     
     begin
    select host_name
      into lc_hostname
      from v$instance;
  end;



     for i in c_clientes_job loop
        ln_ini := i.digito;
        lc_variable := ' begin '|| '  PQ_CR_DEUDACLIENTE.Sp_cr_SaldDiv('||ln_ini||');'|| ' End; ';
        ln_job := ln_job +1;
        --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
--        if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then             
--        if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
IF SYS.FN_BD_ISRAC='TRUE' THEN
           DBMS_JOB.SUBMIT(job => ln_job, 
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
                        instance => 1,
                        --instance => 2, 01/01/2024
                        force => false
                        );
          else
            DBMS_JOB.SUBMIT(job => ln_job, 
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
                        force => false
                        );
          end if;

        INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
        VALUES('DB5',ln_ini,lc_variable);
        COMMIT;
      end loop;
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'DB5',lc_coderr, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

end Sp_cr_job_SaldDiv;  
Procedure Sp_cr_SaldDiv(P_C_DIGITO in varchar2) is

cursor creDitos is
      select * from jaqy347 A
      WHERE substr(trim(a.jaqy347sbs), -1, 1) = P_C_DIGITO;

lc_coderr varchar2(100);

ln_entTot number(10);
ln_hip number(17,2);
ln_pym number(17,2);
ln_con number(17,2);

begin
  update tab_jobs g
       set g.d_fecini = sysdate
     where g.n_numer1 = P_C_DIGITO
       and g.c_codage = 'DB5';
    commit;
  begin
    for i in creditos loop
         ln_entTot := null;
          ln_hip := null;
          ln_pym := null;
          ln_con := null;
        
           if i.jaqy347pai is not null then
        begin
          select a.jaqy346hip,
                 a.jaqy346con,
                 a.jaqy346pym,
                 a.jaqy346eto
            into ln_hip,   --saldo hipotecario
                 ln_con,   --saldo consumo
                 ln_pym,   --saldo pyme
                 ln_entTot --entidades totales                       
            from jaqy346 a
           where a.jaqy346pai = i.jaqy347pai
             and a.jaqy346tdo = i.jaqy347tdo
             and a.jaqy346ndo = i.jaqy347ndo;
        exception 
          when too_many_rows then
               begin
                  select a.jaqy346hip,
                         a.jaqy346con,
                         a.jaqy346pym,
                         a.jaqy346eto
                    into ln_hip,  
                         ln_con,  
                         ln_pym,  
                         ln_entTot                                          
                    from jaqy346 a
                   where a.jaqy346pai = i.jaqy347pai
                     and a.jaqy346tdo = i.jaqy347tdo
                     and a.jaqy346ndo = i.jaqy347ndo
                     and a.jaqy346cpe = 1;
                exception 
                  when too_many_rows then
                       begin
                            select a.jaqy346hip,
                                   a.jaqy346con,
                                   a.jaqy346pym,
                                   a.jaqy346eto
                              into ln_hip,  
                                   ln_con,  
                                   ln_pym,  
                                   ln_entTot  
                              from jaqy346 a
                             where a.jaqy346pai = i.jaqy347pai
                               and a.jaqy346tdo = i.jaqy347tdo
                               and a.jaqy346ndo = i.jaqy347ndo
                               and a.jaqy346cpe = 1
                               and rownum = 1;
                          exception 
                            when others then null;                              
                          end;
                   when others then null;
                end;
           when others then null;
        end;
        
        else
                begin
          select a.jaqy346hip,
                 a.jaqy346con,
                 a.jaqy346pym,
                 a.jaqy346eto
            into ln_hip,  
                 ln_con,  
                 ln_pym,  
                 ln_entTot                          
            from jaqy346 a
           where a.jaqy346tdo = i.jaqy347tdo
             and a.jaqy346ndo = i.jaqy347ndo;
        exception 
          when too_many_rows then
               begin
                  select a.jaqy346hip,
                         a.jaqy346con,
                         a.jaqy346pym,
                         a.jaqy346eto
                    into ln_hip,  
                         ln_con,  
                         ln_pym,  
                         ln_entTot                 
                    from jaqy346 a
                   where a.jaqy346tdo = i.jaqy347tdo
                     and a.jaqy346ndo = i.jaqy347ndo
                     and a.jaqy346cpe = 1;
                exception 
                  when too_many_rows then
                       begin
                            select a.jaqy346hip,
                                   a.jaqy346con,
                                   a.jaqy346pym,
                                   a.jaqy346eto
                              into ln_hip,  
                                   ln_con,  
                                   ln_pym,  
                                   ln_entTot                                     
                              from jaqy346 a
                             where a.jaqy346tdo = i.jaqy347tdo
                               and a.jaqy346ndo = i.jaqy347ndo
                               and a.jaqy346cpe = 1
                               and rownum = 1;
                          exception 
                            when others then null;                              
                          end;
                   when others then null;
                end;
           when others then null;
        end;
     end if;
             update jaqy347 a
               set a.jaqy347hip = ln_hip,
                   a.jaqy347con = ln_con,
                   a.jaqy347pym = ln_pym,
                   a.jaqy347eto = ln_entTot
             where a.jaqy347pai = i.jaqy347pai
               and a.jaqy347tdo = i.jaqy347tdo
               and a.jaqy347ndo = i.jaqy347ndo;
               commit;
                              
                              
     end loop;
     COMMIT;
     
   update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  P_C_DIGITO
       and g.c_codage = 'DB5';
    commit;
    end;
    
     EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = P_C_DIGITO
         and g.c_codage = 'DB5';
    commit;
    return;
                
end Sp_cr_SaldDiv;

Procedure Sp_HipConPym(cod_sbs in char,ln_sdoPyme out number,ln_sdoCon out number,
                   ln_sdoHipo out number) is

ln_sdoPyme1 number(18,2);
ln_sdoHipo1 number(18,2);
ln_sdoCon1  number(18,2);

ln_sdoPyme2 number(18,2);
ln_sdoHipo2 number(18,2);
ln_sdoCon2  number(18,2);

          
begin

          begin  
          select nvl(sum(pyme), 0),
                 nvl(sum(cons), 0),
                 nvl(sum(hipo), 0)
                 
              into ln_sdoPyme1,
                   ln_sdoCon1,
                   ln_sdoHipo1
                   
                from(    
            select case
                       when c_cretip in ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10')
                         then nvl(sum(n_salcap), 0)
                   end pyme,
                   case
                       when c_cretip in ('11', '12')
                         then nvl(sum(n_salcap), 0)
                   end cons,
                   case
                       when c_cretip in ('13')
                         then nvl(sum(n_salcap), 0)
                   end hipo    
              
              from jaqy346det a 
             where c_codsbs = cod_sbs
               --and c_cretip in ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10')
               --and C_CODEMP <> '00104' --mod@ABR20160809
               and (substr(c_cuenta, 1, 4) IN
               ('1411', '1421', '1413', '1423', '1414', '1424', '1415',
                '1425', '1416', '1426') or
               substr(c_cuenta, 1, 4) in
               ('7111', '7121', '7112', '7122', '7113', '7123', '7114',
                '7124'))
            group by c_cretip)
           ;
            
            exception
              when no_Data_found then 
                   ln_sdoPyme1 := 0;
                   ln_sdoHipo1 := 0;
                   ln_sdoCon1  := 0;
                
            end;
            
            
          begin  
          select nvl(sum(pyme), 0),
                 nvl(sum(cons), 0),
                 nvl(sum(hipo), 0)
                 
              into ln_sdoPyme2,
                   ln_sdoCon2,
                   ln_sdoHipo2
                   
                from(    
            select case
                       when c_cretip in ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10')
                         then nvl(sum(n_salcap), 0)
                   end pyme,
                   case
                       when c_cretip in ('11', '12')
                         then nvl(sum(n_salcap), 0)
                   end cons,
                   case
                       when c_cretip in ('13')
                         then nvl(sum(n_salcap), 0)
                   end hipo    
              
              from jaqy346det a 
             where c_codsbs = cod_sbs
               --and c_cretip in ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10')
               --and C_CODEMP <> '00104' --mod@ABR20160809
               and substr(c_cuenta, 1, 6) IN
             ('291101', '292101', '291102', '292102', '291104', '292104')
            group by c_cretip)
           ;
            
            exception
              when no_Data_found then 
                   ln_sdoPyme2 := 0;
                   ln_sdoHipo2 := 0;
                   ln_sdoCon2  := 0;
                
            end;
            
         ln_sdoPyme:= ln_sdoPyme1 - ln_sdoPyme2;
         ln_sdoHipo:= ln_sdoHipo1 - ln_sdoHipo2;
         ln_sdoCon:= ln_sdoCon1 - ln_sdoCon2;
  
end Sp_HipConPym;

end PQ_CR_DEUDACLIENTE;
/

