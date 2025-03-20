create or replace package PQ_CR_PRCLINEAS is

  -- Author  : ABERNEDO
  -- Created : 22/09/2016 05:10:55 p.m.
  -- Purpose : 
  type tp_nomvar is table of varchar2(30) index by binary_integer;
  type tp_valvar is table of varchar2(30) index by binary_integer;
  type tp_regla is record ( RNG49COD FRNG51.RNG49COD%type,
                            RNG50GRP FRNG51.RNG50GRP%type,
                            RNG51COD FRNG51.RNG51COD%type,
                            RNG68COD FRNG51.RNG68COD%type,
                            RNG51OPE FRNG51.RNG51OPE%type,
                            RNG51VAL FRNG51.RNG51VAL%type,
                            RNG68ATR FRNG68.RNG68ATR%type,
                            RNG68TDA FRNG68.RNG68TDA%type,
                            RNG50Ret FRNG50.RNG50RET%type  );
  type tb_reglas is table of tp_regla index by binary_integer;
  Procedure Sp_carga(pd_fecpro in date);
  Procedure Sp_Procesa;
  procedure sp_cr_job_CargaVariables(P_D_FECPRO IN DATE);
  Procedure Sp_Carga_Variables(pd_fecpro in date/*,P_C_DIGITO in number*/);
  Procedure Sp_MoraMaxima(pn_diaMax in number,
                        pn_emp in number,
                        pn_mod in number,
                        pn_suc in number,
                        pn_mda in number,
                        pn_pap in number,
                        pn_cta in number,
                        pc_ope in number,
                        pn_sbo in number,
                        pn_top in number,
                        pn_pai in number,
                        pn_tdo in number,
                        pc_ndo in char ,
                        pd_fecpro in date   
                                 );
  Procedure Sp_JudCast(pc_EsJudicial in char,
                     pn_emp in number,
                     pn_mod in number,
                     pn_suc in number,
                     pn_mda in number,
                     pn_pap in number,
                     pn_cta in number,
                     pc_ope in number,
                     pn_sbo in number,
                     pn_top in number,
                     pn_pai in number,
                     pn_tdo in number,
                     pc_ndo in char ,
                     pd_fecpro in date );
  Procedure Sp_CalRCC(pc_CalRCC in char,
                    pn_emp in number,
                    pn_mod in number,
                    pn_suc in number,
                    pn_mda in number,
                    pn_pap in number,
                    pn_cta in number,
                    pc_ope in number,
                    pn_sbo in number,
                    pn_top in number,
                    pn_pai in number,
                    pn_tdo in number,
                    pc_ndo in char ,
                    pd_fecpro in date) ;
  Procedure Sp_ListasNegr(pc_ListaNegra in char,
                        pn_emp in number,
                        pn_mod in number,
                        pn_suc in number,
                        pn_mda in number,
                        pn_pap in number,
                        pn_cta in number,
                        pc_ope in number,
                        pn_sbo in number,
                        pn_top in number,
                        pn_pai in number,
                        pn_tdo in number,
                        pc_ndo in char ,
                        pd_fecpro in date);
  procedure sp_cr_RNG1701( P_D_FECPRO in date);
  procedure sp_cr_cargar_variables( P_D_FECPRO IN DATE,
                                    PN_EMP IN JAQZ506.JAQZ506EMP%type,
                                    PN_MOD IN JAQZ506.JAQZ506MOD%type,
                                    PN_SUC IN JAQZ506.JAQZ506SUC%type,
                                    PN_MDA IN JAQZ506.JAQZ506MDA%type,
                                    PN_PAP IN JAQZ506.JAQZ506PAP%type,
                                    PN_CTA IN JAQZ506.JAQZ506CTA%type,
                                    PN_OPE IN JAQZ506.JAQZ506OPE%type,
                                    PN_SBO IN JAQZ506.JAQZ506SBO%type,
                                    PN_TOP IN JAQZ506.JAQZ506TOP%type,
                                    p_a_nomvar out pq_cr_prclineas.tp_nomvar,
                                    p_a_valvar out pq_cr_prclineas.tp_valvar, 
                                    p_n_var out number );
  procedure sp_cr_evalua_clientes_1( P_N_REGLA IN NUMBER,  
                                     P_A_NOMVAR IN pq_cr_prclineas.tp_nomvar,
                                     P_A_VALVAR IN pq_cr_prclineas.tp_valvar, 
                                     P_N_VAR IN number,
                                     P_A_REGLAS in pq_cr_prclineas.tb_reglas, 
                                     P_N_REG in number,
                                     p_c_retorno out varchar2);        
  Procedure sp_ubigeo (pn_pais in number, pn_tdoc in number,pc_ndoc in char,
                       ln_dis out number,ln_provin out number,ln_dpto out number);   
                       
  Procedure Sp_CargaTabla(P_C_IDCONX IN VARCHAR2,
                        P_C_CODUSU IN VARCHAR2,
                        P_N_TIPDOC IN NUMBER,
                        P_C_NUMDOC IN VARCHAR2);   
  Procedure Sp_LineaAdicional(/*pn_emp in number,
                            pn_mod in number,
                            pn_suc in number,
                            pn_mda in number,
                            pn_pap in number,
                            pn_cta in number,
                            pn_ope in number,
                            pn_sbo in number,*/
                            pn_top in number,
                            pn_ins in number,
                            pn_mtoTot out number,
                            pn_mtoDP  out number,
                            pn_mtoDA  out number,
                            pn_mtoUP  out number,
                            pn_mtoUA  out number,
                            pc_flg    out varchar2);  
  Procedure Sp_CargaTabCalor(P_C_IDCONX IN VARCHAR2,
                        P_C_CODUSU IN VARCHAR2,
                        P_N_DISTRI IN NUMBER);   
  end PQ_CR_PRCLINEAS;
/

create or replace package body PQ_CR_PRCLINEAS is

Procedure Sp_carga(pd_fecpro in date) is
begin
  Execute immediate('Truncate table JAQZ505');
  begin
          insert into JAQZ505(JAQZ505EMP,
                              JAQZ505MOD,
                              JAQZ505SUC,
                              JAQZ505MDA,
                              JAQZ505PAP,
                              JAQZ505CTA,
                              JAQZ505OPE,
                              JAQZ505SBO,
                              JAQZ505TOP,
                              JAQZ505INS,
                              JAQZ505FEC,
                              JAQZ505LTO,
                              JAQZ505FEV,
                              JAQZ505ANA)
          select a.pgcod,
                 a.aomod,
                 a.aosuc,
                 a.aomda,
                 a.aopap,
                 a.aocta,
                 a.aooper,
                 a.aosbop,
                 a.aotope,
                 fn_instancia_credito(a.aomod,a.aosuc,a.aomda,a.aopap,a.aocta,a.aooper,a.aosbop,a.aotope),
                 a.aofval,
                 a.aoimp,
                 a.aofvto,
                 fn_analista_credito(a.aomod,a.aosuc,a.aomda,a.aopap,a.aocta,a.aooper,a.aosbop,a.aotope)
            from fsd010 a 
           where a.aomod=117
             and aostat=0
             and aofval <= pd_fecpro;
             
             commit;
  end;
  
end Sp_carga;
Procedure Sp_Procesa is
cursor cupo is
select * from jaqz505;

cursor linea(pn_emp in number,
             pn_mod in number,
             pn_suc in number,
             pn_mda in number,
             pn_pap in number,
             pn_cta in number,
             pn_ope in number,
             pn_sbo in number,
             pn_top in number) is
select a.r1cod ,
       a.r1mod ,
       a.r1suc ,
       a.r1mda ,
       a.r1pap ,
       a.r1cta ,
       a.r1oper,
       a.r1sbop,
       a.r1tope
  from fsr011 a
 where a.r2cod  = pn_emp
   and a.r2mod  = pn_mod
   and a.r2suc  = pn_suc
   and a.r2mda  = pn_mda
   and a.r2pap  = pn_pap
   and a.r2cta  = pn_cta
   and a.r2oper = pn_ope
   and a.r2sbop = pn_sbo
   and a.r2tope = pn_top;
   
ln_mtoUtTot number(18,2)   ;
ln_mtoUt number(18,2)   ;
ln_mtoDisTot number(18,2)   ;
ln_pai number(3);
ln_tdo number(2);
lc_ndo char(12);
ln_dis number(9);
ln_provin number(5);
ln_dpto number(5);

begin
  begin
       for i in cupo loop
           ln_mtoUtTot := 0;
           ln_dis := null;
           ln_provin := null;
           ln_dpto := null;
           for j in linea(i.jaqz505emp,
                          i.jaqz505mod,
                          i.jaqz505suc,
                          i.jaqz505mda,
                          i.jaqz505pap,
                          i.jaqz505cta,
                          i.jaqz505ope,
                          i.jaqz505sbo,
                          i.jaqz505top)loop
            
                begin
                     select sum(-b.scsdo)
                       into ln_mtoUt
                       from fsd011 b
                      where b.pgcod  = j.r1cod 
                        and b.scmod  = j.r1mod 
                        and b.scsuc  = j.r1suc 
                        and b.scmda  = j.r1mda 
                        and b.scpap  = j.r1pap 
                        and b.sccta  = j.r1cta 
                        and b.scoper = j.r1oper
                        and b.scsbop = j.r1sbop
                        and b.sctope = j.r1tope;
                exception
                   when others then
                     ln_mtoUt := 0;
                end;
                
                ln_mtoUtTot := ln_mtoUtTot + nvl(ln_mtoUt,0);
            end loop;
            
            ln_mtoDisTot := i.jaqz505lto - ln_mtoUtTot;
            
            begin
               select pepais,
                      petdoc,
                      pendoc
                 into ln_pai,
                      ln_tdo,
                      lc_ndo
                 from fsr008 a
                where ctnro = i.jaqz505cta
                  and cttfir = 'T';
          exception
                  when no_data_found then
                    begin
                         select pepais,
                                petdoc,
                                pendoc
                           into ln_pai,
                                ln_tdo,
                                lc_ndo
                           from fsr008 a
                          where ctnro = i.jaqz505cta;
                    exception
                            when no_data_found then null;
                              
                    end;
                    
          end;
          --ubigeo
          pq_cr_prclineas.sp_ubigeo(ln_pai,ln_tdo,lc_ndo,ln_dis,ln_provin,ln_dpto);
          
            begin
                 update jaqz505 a
                    set a.jaqz505ldi = ln_mtoDisTot,
                        a.jaqz505lut = ln_mtoUtTot,
                        a.jaqz505pai = ln_pai,
                        a.jaqz505tdo = ln_tdo,
                        a.jaqz505ndo = lc_ndo,
                        a.jaqz505dis = ln_dis,
                        a.jaqz505pro = ln_provin,
                        a.jaqz505dto = ln_dpto
                  where a.jaqz505emp = i.jaqz505emp
                    and a.jaqz505mod = i.jaqz505mod
                    and a.jaqz505suc = i.jaqz505suc
                    and a.jaqz505mda = i.jaqz505mda
                    and a.jaqz505pap = i.jaqz505pap
                    and a.jaqz505cta = i.jaqz505cta
                    and a.jaqz505ope = i.jaqz505ope
                    and a.jaqz505sbo = i.jaqz505sbo
                    and a.jaqz505top = i.jaqz505top;
            end;
            commit;
       end loop;
       commit;
  end;
  
end Sp_Procesa;

procedure sp_cr_job_CargaVariables(P_D_FECPRO IN DATE) is

     cursor c_clientes_job is 
		  select substr(trim(j.jaqz505cta), -1, 1) digito
          from JAQZ505 j
         --where j.jaqz505cta is not null 
         --where j.jaqz505cta =50722 and j.jaqz505ope=716148
         group by substr(trim(j.jaqz505cta), -1, 1);

   lc_hostname varchar2(64);
     lc_fecpro varchar2(10);
     lc_variable   varchar2(4000);
     ln_job        number:= 0;
     ln_cont number(2):=0;
     ln_inst number(1):=1;
     ln_ini number(2);
     lc_coderr varchar2(300);
  BEGIN
     delete Tab_jobs where  c_Codage = 'L1';
     commit;
     delete from log_error_bandeja a where a.c_codbdj ='L1';
     commit;
begin
    select host_name
      into lc_hostname
      from v$instance;
  end;
  
     execute immediate 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
     Execute immediate('Truncate table JAQZ506');  
     lc_fecpro := to_char(P_D_FECPRO,'RRRR.MM.DD');  
   
  
     for job in c_clientes_job loop
         ln_ini :=job.digito;
         lc_variable := ' begin '||
              ' PQ_CR_PRCLINEAS.Sp_Carga_Variables(TO_DATE('''||lc_fecpro||''',''RRRR.MM.DD''),'''||job.digito||''');'||
                                                                  ' End; ';
              ln_cont := ln_cont +1;
              
              if(ln_cont>=50) then
                  ln_inst:=2;    
              end if;        
                                                            
              ln_job := ln_job +1;
              
--              DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*60));
--if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
	IF SYS.FN_BD_ISRAC='TRUE' THEN
              DBMS_JOB.SUBMIT(job => ln_job, 
                      what => lc_variable,
                      next_date => sysdate+1/(24*60),
                      interval => null,
                      no_parse => false,
                      instance => 2,
                      --instance => 1,--Solo por hoy 01.07.2015 hmev
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
        commit;
        INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
        VALUES('L1',ln_ini,lc_variable);
        COMMIT;
     end loop;
     
      exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'L1',lc_coderr, TRUNC(SYSDATE));
           COMMIT;
           
end sp_cr_job_CargaVariables;


Procedure Sp_Carga_Variables(pd_fecpro in date/*,P_C_DIGITO in number*/) is --mod@abr 20171115

cursor creditos is
select a.jaqz505emp pn_emp,
       a.jaqz505mod pn_mod,
       a.jaqz505suc pn_suc,
       a.jaqz505mda pn_mda,
       a.jaqz505pap pn_pap,
       a.jaqz505cta pn_cta,
       a.jaqz505ope pn_ope,
       a.jaqz505sbo pn_sbo,
       a.jaqz505top pn_top,
       a.jaqz505ins pn_ins
  from jaqz505 a
 --where substr(trim(jaqz505cta), -1, 1) =P_C_DIGITO --mod@abr 20171115
  ;

lc_coderr varchar2(300);
lc_hora char(8);

---
lc_EsJudicial varchar2(1);
lc_Paralelo   char(1);
ln_empP number(3);
ln_modP number(3);
ln_sucP number(3);
ln_mdaP number(4);
ln_papP number(4);
ln_ctaP number(9);
ln_opeP number(9);
ln_sboP number(3);
ln_topP number(3);
ln_promAtr number(10,2);
ln_diaMax number(10);
lc_CalRCC varchar2(1):='N';
lc_ListaNegra varchar2(1);
ln_contBloqueos number(10);
ln_Bloqueo_Vig number(1);
lc_BloqMora varchar2(1);
ln_pai number(3);
ln_tdo number(2);
lc_ndo char(12);
lc_Flag_Ex char(1);
lc_JAQZ506VAR1 varchar2(100);
lc_JAQZ506VAR2 varchar2(100);
lc_JAQZ506VAR3 varchar2(100);
lc_JAQZ506VAR4 varchar2(100);
lc_JAQZ506VAR5 varchar2(100);
lc_JAQZ506VAR6 varchar2(100);
lc_JAQZ506VAR7 varchar2(100);
lc_JAQZ506VAR8 varchar2(100);
ln_cal number(5);
lc_aplica char(1);
lc_EsJudicialF varchar2(1);
begin
 /*update tab_jobs g
         set g.d_fecini = sysdate
       where g.n_numer1 = P_C_DIGITO
         and g.c_codage = 'L1';
    commit;*/ --mod@abr 20171115
       
 begin
 
   --mod@abr 20171115
   execute immediate 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
   Execute immediate('Truncate table JAQZ506');  
   --mod@abr 20171115
   
   
   for i in creditos loop  
        lc_aplica := 'N';
        begin
          select 'S'
            into lc_aplica
            from fst198
           where tp1cod   = 1 --mod@abr 20170601 optimizacion
             and Tp1cod1  = 10823 
             and Tp1corr1 = 9 
             and Tp1corr2 = 1
             and tp1nro1  = i.pn_top;
        exception
        when others then
          lc_aplica := 'N'     ;
        end;
        
        if lc_aplica = 'N' then
          --lc_EsJudicial := 'N';
          lc_Paralelo   := 'N';
          
          begin
               select XWfEmpresa  ,
                      XWfModulo   ,
                      XWfSucursal ,
                      XWfMoneda   ,
                      XWfPapel    ,
                      XWfCuenta   ,
                      XWfOperacion,
                      XWfSubope   ,
                      XWfTipOpe
                 into ln_empP,
                      ln_modP,
                      ln_sucP,
                      ln_mdaP,
                      ln_papP,
                      ln_ctaP,
                      ln_opeP,
                      ln_sboP,
                      ln_topP
                 from xwf700
                where XWFPRCINS = i.pn_ins
                  and XWFCar3 <> '1';
          exception
            when others then null;
          end;


          Begin
               select 'S'
                 into lc_Paralelo
                 from fst198
                Where Tp1cod   = 1
                  and Tp1cod1  = 20001
                  and Tp1corr1 = 1
                  and Tp1corr2 = 1211
                  and Tp1corr3 = i.pn_top
                  and Tp1nro1  = ln_topP;
                  exception
            when others then 
                 lc_Paralelo := 'N';
          end;

          begin
               select pepais,
                      petdoc,
                      pendoc
                 into ln_pai,
                      ln_tdo,
                      lc_ndo
                 from fsr008 a
                where ctnro = i.pn_cta
                  and cttfir = 'T';
          exception
                  when no_data_found then
                    begin
                         select pepais,
                                petdoc,
                                pendoc
                           into ln_pai,
                                ln_tdo,
                                lc_ndo
                           from fsr008 a
                          where ctnro = i.pn_cta;
                    exception
                            when no_data_found then null;
                              
                    end;
                    
          end;
          --DIAS DE ATRASO
          pq_cr_relcrediticia.sp_diasatrasolineas(i.pn_emp,
                                                  i.pn_mod,      
                                                  i.pn_suc,     
                                                  i.pn_mda,    
                                                  i.pn_pap,       
                                                  i.pn_cta,      
                                                  i.pn_ope,       
                                                  i.pn_sbo,       
                                                  i.pn_top,   
                                                  pd_fecpro,
                                                  i.pn_ins,  
                                                  ln_promAtr);
          
          --Mora Maxima 
          pq_cr_relcrediticia.sp_moramaxcuotas(i.pn_cta,pd_fecpro,ln_diaMax);
          
          --Judicial
          pq_cr_relcrediticia.sp_judicast(i.pn_cta,i.pn_ins,lc_EsJudicial);
          if lc_EsJudicial <> 'S' then
             lc_EsJudicialF := 'N';
             else
               lc_EsJudicialF := 'S';
          end if;
          
          --Calificacion RCC
          lc_CalRCC :='N';
          pq_cr_relcrediticia.sp_calificacion_rcc(i.pn_cta,
                                                  i.pn_emp,
                                                  i.pn_mod,      
                                                  i.pn_suc,     
                                                  i.pn_mda,    
                                                  i.pn_pap,       
                                                  i.pn_cta,      
                                                  i.pn_ope,       
                                                  i.pn_sbo,       
                                                  i.pn_top,
                                                  lc_CalRCC);
                                                  
          --paralelo
          if  lc_Paralelo = 'S' and lc_CalRCC = 'N' then
              pq_cr_relcrediticia.sp_calificacion_rcc(ln_ctaP,
                                                  ln_empP,
                                                  ln_modP,      
                                                  ln_sucP,     
                                                  ln_mdaP,    
                                                  ln_papP,       
                                                  ln_ctaP,      
                                                  ln_opeP,       
                                                  ln_sboP,       
                                                  ln_topP,
                                                  lc_CalRCC);
                          

          end if;
          
          
          --Lista Negra
          pq_cr_relcrediticia.sp_listas_negras(i.pn_cta,lc_ListaNegra);
          
          --Numero de bloqueos
          pq_cr_relcrediticia.sp_conteo_bloqueos(ln_pai,ln_tdo,lc_ndo,1,ln_contBloqueos);
          
          --Bloqueo vigente
          pq_cr_relcrediticia.sp_bloqueo_vigente(ln_pai,ln_tdo,lc_ndo,pd_fecpro,i.pn_cta,
                                                 i.pn_ope,ln_Bloqueo_Vig);
          
          lc_BloqMora := 'N';
          if ln_Bloqueo_Vig = 0 then

              pq_cr_relcrediticia.sp_bloqueomora(ln_pai,ln_tdo,lc_ndo,lc_BloqMora,lc_Flag_Ex);
              /*pq_cr_prclineas.sp_MoraMaxima(ln_diaMax,
                                            i.pn_emp,
                                            i.pn_mod,      
                                            i.pn_suc,     
                                            i.pn_mda,    
                                            i.pn_pap,       
                                            i.pn_cta,      
                                            i.pn_ope,       
                                            i.pn_sbo,       
                                            i.pn_top,
                                            ln_pai,ln_tdo,lc_ndo,
                                            pd_fecpro
                                            );
              pq_cr_prclineas.sp_JudCast(lc_EsJudicial,
                                         i.pn_emp,
                                         i.pn_mod,      
                                         i.pn_suc,     
                                         i.pn_mda,    
                                         i.pn_pap,       
                                         i.pn_cta,      
                                         i.pn_ope,       
                                         i.pn_sbo,       
                                         i.pn_top,
                                         ln_pai,ln_tdo,lc_ndo,
                                         pd_fecpro);
              pq_cr_prclineas.sp_CalRCC(lc_CalRCC,
                                        i.pn_emp,
                                        i.pn_mod,      
                                        i.pn_suc,     
                                        i.pn_mda,    
                                        i.pn_pap,       
                                        i.pn_cta,      
                                        i.pn_ope,       
                                        i.pn_sbo,       
                                        i.pn_top,
                                        ln_pai,ln_tdo,lc_ndo,
                                        pd_fecpro);
              pq_cr_prclineas.sp_ListasNegr(lc_ListaNegra,
                                            i.pn_emp,
                                            i.pn_mod,      
                                            i.pn_suc,     
                                            i.pn_mda,    
                                            i.pn_pap,       
                                            i.pn_cta,      
                                            i.pn_ope,       
                                            i.pn_sbo,       
                                            i.pn_top,
                                            ln_pai,ln_tdo,lc_ndo,
                                            pd_fecpro);*/


          end if;

              
              if ln_promAtr = 0 then
                 lc_JAQZ506VAR1:= 'PROM_ATR=0.00';
                 else
                    case 
                        when ln_promAtr < 1 and ln_promAtr > 0 
                             then lc_JAQZ506VAR1 := 'PROM_ATR='||'0'||TRIM(TO_CHAR(ln_promAtr));
                        else lc_JAQZ506VAR1 :='PROM_ATR='||TRIM(TO_CHAR(ln_promAtr));
                    end case;
              end if;
              lc_JAQZ506VAR2  := 'MOR_MAX'||'='||trim(to_char(ln_diaMax));
              lc_JAQZ506VAR3  := 'JUD_CAST'||'='||trim(lc_EsJudicialF);
              lc_JAQZ506VAR4  := 'CAL_RCC_LIN'||'='||trim(lc_CalRCC);
              lc_JAQZ506VAR5  := 'LIST_NG'||'='||trim(lc_ListaNegra);
              lc_JAQZ506VAR6  := 'CANT_BLOQ'||'='||trim(to_char(ln_contBloqueos));
              lc_JAQZ506VAR7  := 'BLOQ_VIG'||'='||trim(to_char(ln_Bloqueo_Vig));
              lc_JAQZ506VAR8  := 'BLOQ_MOR'||'='||trim(lc_BloqMora);
             
              
              ln_cal := 0;
              lc_hora := TO_CHAR(SYSDATE,'hh:mm:ss') ;
              
              begin                                       
              insert into jaqz506 (JAQZ506FECH,
                                   JAQZ506EMP,
                                   JAQZ506MOD,
                                   JAQZ506SUC,
                                   JAQZ506MDA,
                                   JAQZ506PAP,
                                   JAQZ506CTA,
                                   JAQZ506OPE,
                                   JAQZ506SBO,
                                   JAQZ506TOP,
                                   JAQZ506HORA,
                                   JAQZ506CCAL,
                                   JAQZ506VAR1,
                                   JAQZ506VAR2,
                                   JAQZ506VAR3,
                                   JAQZ506VAR4,
                                   JAQZ506VAR5,
                                   JAQZ506VAR6,
                                   JAQZ506VAR7,
                                   JAQZ506VAR8)
              values(pd_fecpro,
                     i.pn_emp,
                     i.pn_mod,      
                     i.pn_suc,     
                     i.pn_mda,    
                     i.pn_pap,       
                     i.pn_cta,      
                     i.pn_ope,       
                     i.pn_sbo,       
                     i.pn_top,
                     lc_hora,ln_cal,lc_JAQZ506VAR1,lc_JAQZ506VAR2,lc_JAQZ506VAR3,
                     lc_JAQZ506VAR4,lc_JAQZ506VAR5,lc_JAQZ506VAR6,lc_JAQZ506VAR7,lc_JAQZ506VAR8);
              
              commit;
              exception
                when others then 
                  null;
                 
              end;
              
          end if;
              
              
              
     end loop;
      /* update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  P_C_DIGITO
       and g.c_codage = 'L1';
    commit; */ --mod@abr 20171115
        
    end;       
      
     EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      /*update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = P_C_DIGITO
         and g.c_codage = 'L1';
    commit;*/--mod@abr 20171115
                                                                      
end Sp_Carga_Variables;




Procedure Sp_MoraMaxima(pn_diaMax in number,
                        pn_emp in number,
                        pn_mod in number,
                        pn_suc in number,
                        pn_mda in number,
                        pn_pap in number,
                        pn_cta in number,
                        pc_ope in number,
                        pn_sbo in number,
                        pn_top in number,
                        pn_pai in number,
                        pn_tdo in number,
                        pc_ndo in char ,
                        pd_fecpro in date   
                                 )is
ln_jaqz090con number(5);
lc_JAQZ090VAC char(2);
ld_Aofvto date;
begin

   If pn_diaMax > 30 then
        
        ln_jaqz090con := 1;
        lc_JAQZ090VAC := null;

        begin
        select Aofvto
          into ld_Aofvto
          from fsd010
         Where Pgcod  = pn_emp
           and Aomod  = pn_mod 
           and Aosuc  = pn_suc 
           and Aomda  = pn_mda 
           and Aopap  = pn_pap 
           and Aocta  = pn_cta 
           and Aooper = pc_ope 
           and Aosbop = pn_sbo 
           and Aotope = pn_top;
        exception
          when others then null;
        end;
       

        insert into jaqz090(JAQZ090PAI ,
                            JAQZ090TDO ,
                            JAQZ090NDO ,
                            JAQZ090CVA ,
                            JAQZ090FEI ,
                            JAQZ090FEF ,
                            JAQZ090CMO ,
                            JAQZ090CON ,
                            JAQZ090VAN ,
                            JAQZ090VAC ,
                            JAQZ090EMP ,
                            JAQZ090MOD ,
                            JAQZ090SUC ,
                            JAQZ090MDA ,
                            JAQZ090PAP ,
                            JAQZ090CTA ,
                            JAQZ090OPE ,
                            JAQZ090SBO ,
                            JAQZ090TOP )
                    values (pn_pai,
                            pn_tdo,
                            pc_ndo,
                            2,
                            pd_fecpro,
                            ld_Aofvto,
                            3,
                            ln_jaqz090con,
                            pn_diaMax,
                            lc_JAQZ090VAC,
                            pn_emp,
                            pn_mod,
                            pn_suc,
                            pn_mda,
                            pn_pap,
                            pn_cta,
                            pc_ope,
                            pn_sbo,
                            pn_top);
                            
                   commit;  


   end if;

End Sp_MoraMaxima;

Procedure Sp_JudCast(pc_EsJudicial in char,
                     pn_emp in number,
                     pn_mod in number,
                     pn_suc in number,
                     pn_mda in number,
                     pn_pap in number,
                     pn_cta in number,
                     pc_ope in number,
                     pn_sbo in number,
                     pn_top in number,
                     pn_pai in number,
                     pn_tdo in number,
                     pc_ndo in char ,
                     pd_fecpro in date )is
                     
ln_jaqz090con number(5);
ln_JAQZ090VAN number(10,2);
ld_Aofvto date;  

begin

   If pc_EsJudicial   = 'S' then

        ln_jaqz090con := 1;
        ln_JAQZ090VAN := null;

        begin
             select Aofvto
               into ld_Aofvto
               from fsd010
              Where Pgcod  = pn_emp
                and Aomod  = pn_mod
                and Aosuc  = pn_suc
                and Aomda  = pn_mda
                and Aopap  = pn_pap
                and Aocta  = pn_cta
                and Aooper = pc_ope
                and Aosbop = pn_sbo
                and Aotope = pn_top;
        exception
            when others then null;
        end;
   

        insert into jaqz090(JAQZ090PAI ,
                            JAQZ090TDO ,
                            JAQZ090NDO ,
                            JAQZ090CVA ,
                            JAQZ090FEI ,
                            JAQZ090FEF ,
                            JAQZ090CMO ,
                            JAQZ090CON ,
                            JAQZ090VAN ,
                            JAQZ090VAC ,
                            JAQZ090EMP ,
                            JAQZ090MOD ,
                            JAQZ090SUC ,
                            JAQZ090MDA ,
                            JAQZ090PAP ,
                            JAQZ090CTA ,
                            JAQZ090OPE ,
                            JAQZ090SBO ,
                            JAQZ090TOP )
                    values (pn_pai,
                            pn_tdo,
                            pc_ndo,
                            3,
                            pd_fecpro,
                            ld_Aofvto,
                            3,
                            ln_jaqz090con,
                            ln_JAQZ090VAN,
                            pc_EsJudicial,
                            pn_emp,
                            pn_mod,
                            pn_suc,
                            pn_mda,
                            pn_pap,
                            pn_cta,
                            pc_ope,
                            pn_sbo,
                            pn_top);
                   commit;  
   end if;
End Sp_JudCast;

Procedure Sp_CalRCC(pc_CalRCC in char,
                    pn_emp in number,
                    pn_mod in number,
                    pn_suc in number,
                    pn_mda in number,
                    pn_pap in number,
                    pn_cta in number,
                    pc_ope in number,
                    pn_sbo in number,
                    pn_top in number,
                    pn_pai in number,
                    pn_tdo in number,
                    pc_ndo in char ,
                    pd_fecpro in date) is
ln_jaqz090con number(5);
ln_JAQZ090VAN number(10,2);
ld_Aofvto date;  
begin  
   
   If pc_CalRCC = 'S' then

        ln_jaqz090con := 1;
        ln_JAQZ090VAN := null;

        begin
             select Aofvto
               into ld_Aofvto
               from fsd010
              Where Pgcod  = pn_emp
                and Aomod  = pn_mod
                and Aosuc  = pn_suc
                and Aomda  = pn_mda
                and Aopap  = pn_pap
                and Aocta  = pn_cta
                and Aooper = pc_ope
                and Aosbop = pn_sbo
                and Aotope = pn_top;
        exception
            when others then null;
        end;
  

        insert into jaqz090(JAQZ090PAI ,
                            JAQZ090TDO ,
                            JAQZ090NDO ,
                            JAQZ090CVA ,
                            JAQZ090FEI ,
                            JAQZ090FEF ,
                            JAQZ090CMO ,
                            JAQZ090CON ,
                            JAQZ090VAN ,
                            JAQZ090VAC ,
                            JAQZ090EMP ,
                            JAQZ090MOD ,
                            JAQZ090SUC ,
                            JAQZ090MDA ,
                            JAQZ090PAP ,
                            JAQZ090CTA ,
                            JAQZ090OPE ,
                            JAQZ090SBO ,
                            JAQZ090TOP )
                    values (pn_pai,
                            pn_tdo,
                            pc_ndo,
                            4,
                            pd_fecpro,
                            ld_Aofvto,
                            3,
                            ln_jaqz090con,
                            ln_JAQZ090VAN,
                            pc_CalRCC,
                            pn_emp,
                            pn_mod,
                            pn_suc,
                            pn_mda,
                            pn_pap,
                            pn_cta,
                            pc_ope,
                            pn_sbo,
                            pn_top);
                            
          commit;                            
   end if;
End Sp_CalRCC;

Procedure Sp_ListasNegr(pc_ListaNegra in char,
                        pn_emp in number,
                        pn_mod in number,
                        pn_suc in number,
                        pn_mda in number,
                        pn_pap in number,
                        pn_cta in number,
                        pc_ope in number,
                        pn_sbo in number,
                        pn_top in number,
                        pn_pai in number,
                        pn_tdo in number,
                        pc_ndo in char ,
                        pd_fecpro in date)is
ln_jaqz090con number(5);
ln_JAQZ090VAN number(10,2);
ld_Aofvto date;  
begin

   If pc_ListaNegra = 'S' then

        ln_jaqz090con := 1;
        ln_JAQZ090VAN := null;

        begin
             select Aofvto
               into ld_Aofvto
               from fsd010
              Where Pgcod  = pn_emp
                and Aomod  = pn_mod
                and Aosuc  = pn_suc
                and Aomda  = pn_mda
                and Aopap  = pn_pap
                and Aocta  = pn_cta
                and Aooper = pc_ope
                and Aosbop = pn_sbo
                and Aotope = pn_top;
        exception
            when others then null;
        end;

        insert into jaqz090(JAQZ090PAI ,
                            JAQZ090TDO ,
                            JAQZ090NDO ,
                            JAQZ090CVA ,
                            JAQZ090FEI ,
                            JAQZ090FEF ,
                            JAQZ090CMO ,
                            JAQZ090CON ,
                            JAQZ090VAN ,
                            JAQZ090VAC ,
                            JAQZ090EMP ,
                            JAQZ090MOD ,
                            JAQZ090SUC ,
                            JAQZ090MDA ,
                            JAQZ090PAP ,
                            JAQZ090CTA ,
                            JAQZ090OPE ,
                            JAQZ090SBO ,
                            JAQZ090TOP )
                    values (pn_pai,
                            pn_tdo,
                            pc_ndo,
                            5,
                            pd_fecpro,
                            ld_Aofvto,
                            3,
                            ln_jaqz090con,
                            ln_JAQZ090VAN,
                            pc_ListaNegra,
                            pn_emp,
                            pn_mod,
                            pn_suc,
                            pn_mda,
                            pn_pap,
                            pn_cta,
                            pc_ope,
                            pn_sbo,
                            pn_top);
       commit;
   end if;

End Sp_ListasNegr;

procedure sp_cr_RNG1701( P_D_FECPRO in date/*, 
                                     P_C_DIGITO in varchar2,
                                     PC_USR in varchar2*/ )
  IS

     cursor c_clientes/*(p_fecpro date)*/ is 
        select /*+all_rows index_ss(l)*/
               l.jaqz505emp,
               l.jaqz505mod,
               l.jaqz505suc,
               l.jaqz505mda,
               l.jaqz505pap,
               l.jaqz505cta,
               l.jaqz505ope,
               l.jaqz505sbo,
               l.jaqz505top
          from JAQZ505 l
         --where l.jaqz505cta=50722
          /*
         where l.jaqz506fech = p_fecpro*/ ;    
--           and l.jaqz506cta=109546;      
--           and substr(trim(l.jaqz505cta), -1, 1) = P_C_DIGITO
           
     cursor c_reglas is 

         
 select /*+ALL_ROWS*/ g.RNG50ORD, 
                t.RNG49COD, 
                t.RNG50GRP,
                t.RNG51COD,
                t.RNG68COD,
                t.RNG51OPE,
                t.RNG51VAL,
                a.RNG68ATR,
                a.RNG68TDA,
                g.RNG50Ret
           from FRNG50 g
          inner join frng51 t on g.rng49cod = t.rng49cod
                             and g.rng50grp = t.rng50grp
          inner join frng68 a on t.rng49cod = a.rng49cod
                             and t.rng68cod = a.rng68cod                   
--          where t.RNG49Cod in (1611, 1612, 1613, 1614, 1617)
          where t.RNG49Cod = 1701
          order by g.RNG49COD, g.RNG50ORD, t.RNG50GRP, t.RNG51COD;   
       
   
     Regla frng51.rng49cod%type;
     SegmentoRegla frng50.rng50ret%type;
     la_nomvar PQ_CR_PRCLINEAS.tp_nomvar;
     la_valvar PQ_CR_PRCLINEAS.tp_valvar;
     la_nomnul PQ_CR_PRCLINEAS.tp_nomvar;
     la_valnul PQ_CR_PRCLINEAS.tp_valvar;
     ln_var number(3) := 0;
     
     l_JAQZ505DPE JAQZ505.JAQZ505DPE%type;
     l_JAQZ505PEN JAQZ505.JAQZ505PEN%type;
     l_JAQZ505emp JAQZ505.JAQZ505EMP%type;
     l_JAQZ505mod JAQZ505.JAQZ505MOD%type;
     l_JAQZ505suc JAQZ505.JAQZ505SUC%type;
     l_JAQZ505mda JAQZ505.JAQZ505MDA%type;
     l_JAQZ505pap JAQZ505.JAQZ505PAP%type;
     l_JAQZ505cta JAQZ505.JAQZ505CTA%type;
     l_JAQZ505ope JAQZ505.JAQZ505OPE%type;
     l_JAQZ505sbo JAQZ505.JAQZ505SBO%type;
     l_JAQZ505top JAQZ505.JAQZ505TOP%type;

          
     TYPE tp_emp IS TABLE OF jaqz506.jaqz506emp%type INDEX BY BINARY_INTEGER; 
     TYPE tp_mod IS TABLE OF jaqz506.jaqz506mod%type INDEX BY BINARY_INTEGER; 
     TYPE tp_suc IS TABLE OF jaqz506.jaqz506suc%type INDEX BY BINARY_INTEGER; 
     TYPE tp_mda IS TABLE OF jaqz506.jaqz506mda%type INDEX BY BINARY_INTEGER; 
     TYPE tp_pap IS TABLE OF jaqz506.jaqz506pap%type INDEX BY BINARY_INTEGER; 
     TYPE tp_cta IS TABLE OF jaqz506.jaqz506cta%type INDEX BY BINARY_INTEGER; 
     TYPE tp_ope IS TABLE OF jaqz506.jaqz506ope%type INDEX BY BINARY_INTEGER; 
     TYPE tp_sbo IS TABLE OF jaqz506.jaqz506sbo%type INDEX BY BINARY_INTEGER; 
     TYPE tp_top IS TABLE OF jaqz506.jaqz506top%type INDEX BY BINARY_INTEGER; 
     
     
     la_JAQZ506emp tp_emp;
     la_JAQZ506mod tp_mod;
     la_JAQZ506suc tp_suc;
     la_JAQZ506mda tp_mda;
     la_JAQZ506pap tp_pap;
     la_JAQZ506cta tp_cta;
     la_JAQZ506ope tp_ope;
     la_JAQZ506sbo tp_sbo;
     la_JAQZ506top tp_top;
     
     la_reglas PQ_CR_PRCLINEAS.tb_reglas;
     ln_reg number(5);
     lc_aplica char(1);
     
     
  BEGIN
  
     execute immediate 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
     execute immediate 'ALTER SESSION SET OPTIMIZER_MODE=ALL_ROWS';         --jflor 2014.01.17  
     execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';       --jflor 2014.05.05
   
    -- l_JAQY066fecp := P_D_FECPRO;
     --l_JAQY066pano := to_number(to_char(P_D_FECPRO,'RRRR'));
     --l_JAQY066pmes := to_number(to_char(P_D_FECPRO,'MM'));    
  
     Regla := 1701;
     
     -- Cargar reglas
     ln_reg := 0;     
     for r in c_reglas loop
         ln_reg := ln_reg + 1;
         la_reglas(ln_reg).RNG49COD := r.rng49cod;
         la_reglas(ln_reg).RNG50GRP := r.rng50grp;
         la_reglas(ln_reg).RNG51COD := r.rng51cod;
         la_reglas(ln_reg).RNG68COD := r.rng68cod;
         la_reglas(ln_reg).RNG51OPE := r.rng51ope;
         la_reglas(ln_reg).RNG51VAL := r.rng51val;
         la_reglas(ln_reg).RNG68ATR := r.rng68atr;
         la_reglas(ln_reg).RNG68TDA := r.rng68tda;
         la_reglas(ln_reg).RNG50Ret := r.rng50ret;                
     end loop;   
     
     OPEN c_clientes/*(P_D_FECPRO)*/;  -- Clientes Bulk
     FETCH c_clientes BULK COLLECT INTO la_JAQZ506emp,la_JAQZ506mod,la_JAQZ506suc,la_JAQZ506mda,la_JAQZ506pap,la_JAQZ506cta,la_JAQZ506ope,la_JAQZ506sbo,la_JAQZ506top;

     IF la_JAQZ506cta.count > 0 THEN
        FOR c IN la_JAQZ506cta.FIRST..la_JAQZ506cta.LAST LOOP
             lc_aplica := 'N';
              begin
                select 'S'
                  into lc_aplica
                  from fst198
                 where Tp1cod   = 1 --mod@abr 20170601 optimizacion 
                   and Tp1cod1  = 10823 
                   and Tp1corr1 = 9 
                   and Tp1corr2 = 1
                   and tp1nro1  = la_JAQZ506top(c);
              exception
              when others then
                lc_aplica := 'N'     ;
              end;
              l_JAQZ505emp := la_JAQZ506emp(c);
              l_JAQZ505mod := la_JAQZ506mod(c);
              l_JAQZ505suc := la_JAQZ506suc(c);
              l_JAQZ505mda := la_JAQZ506mda(c);
              l_JAQZ505pap := la_JAQZ506pap(c);
              l_JAQZ505cta := la_JAQZ506cta(c);
              l_JAQZ505ope := la_JAQZ506ope(c);
              l_JAQZ505sbo := la_JAQZ506sbo(c);
              l_JAQZ505top := la_JAQZ506top(c);
              if lc_aplica = 'N' then
                    la_nomvar := la_nomnul; 
                    la_valvar := la_valnul; 
                      pq_cr_prclineas.sp_cr_cargar_variables(p_d_fecpro => P_D_FECPRO,
                                                 pn_emp => la_JAQZ506emp(c),
                                                 pn_mod => la_JAQZ506mod(c),
                                                 pn_suc => la_JAQZ506suc(c),
                                                 pn_mda => la_JAQZ506mda(c),
                                                 pn_pap => la_JAQZ506pap(c),
                                                 pn_cta => la_JAQZ506cta(c),
                                                 pn_ope => la_JAQZ506ope(c),
                                                 pn_sbo => la_JAQZ506sbo(c),
                                                 pn_top => la_JAQZ506top(c),
                                                 p_a_nomvar => la_nomvar,
                                                 p_a_valvar => la_valvar,
                                                 p_n_var => ln_var);
               
                    SegmentoRegla := null;                                                   
                    PQ_CR_PRCLINEAS.sp_cr_evalua_clientes_1( P_N_REGLA => Regla,
                                                                         P_A_NOMVAR => la_nomvar,
                                                                         P_A_VALVAR => la_valvar,
                                                                         P_N_VAR => ln_var,
                                                                         P_A_REGLAS => la_reglas,
                                                                         P_N_REG => ln_reg,
                                                                         p_c_retorno => SegmentoRegla);
                    
              
                    l_JAQZ505DPE := Trim(SegmentoRegla);
                    If substr(Trim(SegmentoRegla),1,1) = '0' then
                       l_JAQZ505PEN := 'N';
                       else
                         l_JAQZ505PEN := 'S';
                    end if;
                    /*
                    l_JAQZ505emp := la_JAQZ506emp(c);
                    l_JAQZ505mod := la_JAQZ506mod(c);
                    l_JAQZ505suc := la_JAQZ506suc(c);
                    l_JAQZ505mda := la_JAQZ506mda(c);
                    l_JAQZ505pap := la_JAQZ506pap(c);
                    l_JAQZ505cta := la_JAQZ506cta(c);
                    l_JAQZ505ope := la_JAQZ506ope(c);
                    l_JAQZ505sbo := la_JAQZ506sbo(c);
                    l_JAQZ505top := la_JAQZ506top(c);*/
                    
                    UPDATE JAQZ505 A
                       SET A.JAQZ505PEN = l_JAQZ505PEN,
                           A.JAQZ505DPE = l_JAQZ505DPE
                     WHERE A.JAQZ505EMP = l_JAQZ505emp
                       AND A.JAQZ505MOD = l_JAQZ505mod
                       AND A.JAQZ505SUC = l_JAQZ505suc
                       AND A.JAQZ505MDA = l_JAQZ505mda
                       AND A.JAQZ505PAP = l_JAQZ505pap
                       AND A.JAQZ505CTA = l_JAQZ505cta
                       AND A.JAQZ505OPE = l_JAQZ505ope
                       AND A.JAQZ505SBO = l_JAQZ505sbo
                       AND A.JAQZ505TOP = l_JAQZ505top;
                       
                       commit;  
                   else
                     l_JAQZ505DPE := '0;SIN RESTRICCION';
                     l_JAQZ505PEN := 'N';
                     UPDATE JAQZ505 A
                       SET A.JAQZ505PEN = l_JAQZ505PEN,
                           A.JAQZ505DPE = l_JAQZ505DPE
                     WHERE A.JAQZ505EMP = l_JAQZ505emp
                       AND A.JAQZ505MOD = l_JAQZ505mod
                       AND A.JAQZ505SUC = l_JAQZ505suc
                       AND A.JAQZ505MDA = l_JAQZ505mda
                       AND A.JAQZ505PAP = l_JAQZ505pap
                       AND A.JAQZ505CTA = l_JAQZ505cta
                       AND A.JAQZ505OPE = l_JAQZ505ope
                       AND A.JAQZ505SBO = l_JAQZ505sbo
                       AND A.JAQZ505TOP = l_JAQZ505top;
                       
                       commit;  
              end if;
        END LOOP; -- clientes
    END IF;
     
end sp_cr_RNG1701;


procedure sp_cr_cargar_variables( P_D_FECPRO IN DATE,
                                    PN_EMP IN JAQZ506.JAQZ506EMP%type,
                                    PN_MOD IN JAQZ506.JAQZ506MOD%type,
                                    PN_SUC IN JAQZ506.JAQZ506SUC%type,
                                    PN_MDA IN JAQZ506.JAQZ506MDA%type,
                                    PN_PAP IN JAQZ506.JAQZ506PAP%type,
                                    PN_CTA IN JAQZ506.JAQZ506CTA%type,
                                    PN_OPE IN JAQZ506.JAQZ506OPE%type,
                                    PN_SBO IN JAQZ506.JAQZ506SBO%type,
                                    PN_TOP IN JAQZ506.JAQZ506TOP%type,
                                    p_a_nomvar out pq_cr_prclineas.tp_nomvar,
                                    p_a_valvar out pq_cr_prclineas.tp_valvar, 
                                    p_n_var out number )
  is
 
     cursor c_cliente is 
      select JAQZ506fech,JAQZ506EMP,JAQZ506MOD,JAQZ506SUC,JAQZ506MDA,jaqz506pap,jaqz506cta,
             jaqz506ope,jaqz506sbo,jaqz506top,JAQZ506var1, 
               JAQZ506var2, JAQZ506var3, JAQZ506var4, JAQZ506var5, JAQZ506var6, 
               JAQZ506var7, JAQZ506var8, JAQZ506var9, JAQZ506var10, JAQZ506var11, 
               JAQZ506var12, JAQZ506var13, JAQZ506var14, JAQZ506var15, JAQZ506var16, 
               JAQZ506var17, JAQZ506var18, JAQZ506var19, JAQZ506var20, JAQZ506var21, 
               JAQZ506var22, JAQZ506var23, JAQZ506var24, JAQZ506var25, JAQZ506var26, 
               JAQZ506var27, JAQZ506var28, JAQZ506var29, JAQZ506var30, JAQZ506var31, 
               JAQZ506var32, JAQZ506var33, JAQZ506var34, JAQZ506var35, JAQZ506var36, 
               JAQZ506var37, JAQZ506var38, JAQZ506var39, JAQZ506var40
          from JAQZ506 A
         where A.JAQZ506FECH = P_D_FECPRO
           and A.JAQZ506EMP = PN_EMP
           and A.JAQZ506MOD = PN_MOD
           and A.JAQZ506SUC = PN_SUC
           and A.JAQZ506MDA = PN_MDA
           and a.jaqz506pap = PN_PAP
           and a.jaqz506cta = PN_CTA
           and a.jaqz506ope = PN_OPE
           and a.jaqz506sbo = PN_SBO
           and a.jaqz506top = PN_TOP;
    ln_tmpnum number(3);
    
  begin
         
     for cli in c_cliente loop
         -- Cargando Variables Resuletas
         if trim(cli.JAQZ506var1) is not null then
            p_n_var := 1;
            ln_tmpnum := instr(cli.JAQZ506var1, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var1, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var1, ln_tmpnum + 1);
         end if;
         
         if trim(cli.JAQZ506var2) is not null then
            p_n_var := 2;
            ln_tmpnum := instr(cli.JAQZ506var2, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var2, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var2, ln_tmpnum + 1);
         end if;
               
         if trim(cli.JAQZ506var3) is not null then
            p_n_var := 3;
            ln_tmpnum := instr(cli.JAQZ506var3, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var3, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var3, ln_tmpnum + 1);
         end if;
         
         if trim(cli.JAQZ506var4) is not null then
            p_n_var := 4;
            ln_tmpnum := instr(cli.JAQZ506var4, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var4, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var4, ln_tmpnum + 1);
         end if;
             
         if trim(cli.JAQZ506var5) is not null then  
            p_n_var := 5;
            ln_tmpnum := instr(cli.JAQZ506var5, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var5, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var5, ln_tmpnum + 1);
         end if;      
         
         if trim(cli.JAQZ506var6) is not null then   
            p_n_var := 6;
            ln_tmpnum := instr(cli.JAQZ506var6, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var6, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var6, ln_tmpnum + 1);
         end if;
         
         if trim(cli.JAQZ506var7) is not null then      
            p_n_var := 7;
            ln_tmpnum := instr(cli.JAQZ506var7, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var7, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var7, ln_tmpnum + 1);
         end if;
         
         if trim(cli.JAQZ506var8) is not null then      
            p_n_var := 8;
            ln_tmpnum := instr(cli.JAQZ506var8, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var8, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var8, ln_tmpnum + 1);
         end if;
         
         if trim(cli.JAQZ506var9) is not null then      
            p_n_var := 9;
            ln_tmpnum := instr(cli.JAQZ506var9, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var9, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var9, ln_tmpnum + 1);
         end if;
         
         if trim(cli.JAQZ506var10) is not null then      
            p_n_var := 10;
            ln_tmpnum := instr(cli.JAQZ506var10, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var10, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var10, ln_tmpnum + 1);
         end if;
         
         if trim(cli.JAQZ506var11) is not null then      
            p_n_var := 11;
            ln_tmpnum := instr(cli.JAQZ506var11, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var11, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var11, ln_tmpnum + 1);
         end if;
         
         if trim(cli.JAQZ506var12) is not null then      
            p_n_var := 12;
            ln_tmpnum := instr(cli.JAQZ506var12, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var12, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var12, ln_tmpnum + 1);
         end if;
         
         if trim(cli.JAQZ506var13) is not null then      
            p_n_var := 13;
            ln_tmpnum := instr(cli.JAQZ506var13, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var13, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var13, ln_tmpnum + 1);
         end if;
         
         if trim(cli.JAQZ506var14) is not null then               
            p_n_var := 14;
            ln_tmpnum := instr(cli.JAQZ506var14, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var14, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var14, ln_tmpnum + 1);
         end if;
         
         if trim(cli.JAQZ506var15) is not null then      
            p_n_var := 15;
            ln_tmpnum := instr(cli.JAQZ506var15, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var15, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var15, ln_tmpnum + 1);
         end if;
         
         if trim(cli.JAQZ506var16) is not null then               
            p_n_var := 16;
            ln_tmpnum := instr(cli.JAQZ506var16, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var16, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var16, ln_tmpnum + 1);
         end if;
         
         if trim(cli.JAQZ506var17) is not null then      
            p_n_var := 17;
            ln_tmpnum := instr(cli.JAQZ506var17, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var17, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var17, ln_tmpnum + 1);
         end if;
         
         if trim(cli.JAQZ506var18) is not null then
            p_n_var := 18;
            ln_tmpnum := instr(cli.JAQZ506var18, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var18, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var18, ln_tmpnum + 1);
         end if;
         
         if trim(cli.JAQZ506var19) is not null then      
            p_n_var := 19;
            ln_tmpnum := instr(cli.JAQZ506var19, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var19, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var19, ln_tmpnum + 1);
         end if;
         
         if trim(cli.JAQZ506var20) is not null then      
            p_n_var := 20;
            ln_tmpnum := instr(cli.JAQZ506var20, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var20, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var20, ln_tmpnum + 1);
         end if;
               
         if trim(cli.JAQZ506var21) is not null then
            p_n_var := 21;
            ln_tmpnum := instr(cli.JAQZ506var21, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var21, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var21, ln_tmpnum + 1);
         end if;
               
         if trim(cli.JAQZ506var22) is not null then
            p_n_var := 22;
            ln_tmpnum := instr(cli.JAQZ506var22, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var22, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var22, ln_tmpnum + 1);
         end if;
               
         if trim(cli.JAQZ506var23) is not null then
            p_n_var := 23;
            ln_tmpnum := instr(cli.JAQZ506var23, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var23, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var23, ln_tmpnum + 1);
         end if;
             
         if trim(cli.JAQZ506var24) is not null then  
            p_n_var := 24;
            ln_tmpnum := instr(cli.JAQZ506var24, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var24, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var24, ln_tmpnum + 1);
         end if;
               
         if trim(cli.JAQZ506var25) is not null then
            p_n_var := 25;
            ln_tmpnum := instr(cli.JAQZ506var25, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var25, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var25, ln_tmpnum + 1);
         end if;
               
         if trim(cli.JAQZ506var26) is not null then
            p_n_var := 26;
            ln_tmpnum := instr(cli.JAQZ506var26, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var26, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var26, ln_tmpnum + 1);
         end if;
               
         if trim(cli.JAQZ506var27) is not null then
            p_n_var := 27;
            ln_tmpnum := instr(cli.JAQZ506var27, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var27, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var27, ln_tmpnum + 1);
         end if;
         
         if trim(cli.JAQZ506var28) is not null then                        
            p_n_var := 28;
            ln_tmpnum := instr(cli.JAQZ506var28, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var28, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var28, ln_tmpnum + 1);
         end if;
         
         if trim(cli.JAQZ506var29) is not null then         
            p_n_var := 29;
            ln_tmpnum := instr(cli.JAQZ506var29, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var29, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var29, ln_tmpnum + 1);
         end if;
         
         if trim(cli.JAQZ506var30) is not null then   
            p_n_var := 30;
            ln_tmpnum := instr(cli.JAQZ506var30, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var30, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var30, ln_tmpnum + 1);
         end if;
                
         if trim(cli.JAQZ506var31) is not null then  
            p_n_var := 31;
            ln_tmpnum := instr(cli.JAQZ506var31, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var31, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var31, ln_tmpnum + 1);
         end if;
            
         if trim(cli.JAQZ506var32) is not null then       
            p_n_var := 32;
            ln_tmpnum := instr(cli.JAQZ506var32, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var32, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var32, ln_tmpnum + 1);
         end if;
                
         if trim(cli.JAQZ506var33) is not null then  
            p_n_var := 33;
            ln_tmpnum := instr(cli.JAQZ506var33, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var33, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var33, ln_tmpnum + 1);
         end if;      
            
         if trim(cli.JAQZ506var34) is not null then
            p_n_var := 34;
            ln_tmpnum := instr(cli.JAQZ506var34, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var34, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var34, ln_tmpnum + 1);
         end if;
         
         if trim(cli.JAQZ506var35) is not null then         
            p_n_var := 35;
            ln_tmpnum := instr(cli.JAQZ506var35, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var35, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var35, ln_tmpnum + 1);
         end if;      
            
         if trim(cli.JAQZ506var36) is not null then
            p_n_var := 36;
            ln_tmpnum := instr(cli.JAQZ506var36, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var36, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var36, ln_tmpnum + 1);
         end if;      
            
         if trim(cli.JAQZ506var37) is not null then
            p_n_var := 37;
            ln_tmpnum := instr(cli.JAQZ506var37, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var37, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var37, ln_tmpnum + 1);
         end if;      
            
         if trim(cli.JAQZ506var38) is not null then
            p_n_var := 38;
            ln_tmpnum := instr(cli.JAQZ506var38, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var38, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var38, ln_tmpnum + 1);
         end if;
                
         if trim(cli.JAQZ506var39) is not null then  
            p_n_var := 39;
            ln_tmpnum := instr(cli.JAQZ506var39, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var39, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var39, ln_tmpnum + 1);       
         end if;
         
         if trim(cli.JAQZ506var40) is not null then  
            p_n_var := 40;
            ln_tmpnum := instr(cli.JAQZ506var40, '=');
            p_a_nomvar(p_n_var) := substr(cli.JAQZ506var40, 1, ln_tmpnum - 1);
            p_a_valvar(p_n_var) := substr(cli.JAQZ506var40, ln_tmpnum + 1);       
         end if;
         
     end loop;
     
end sp_cr_cargar_variables;

procedure sp_cr_evalua_clientes_1( P_N_REGLA IN NUMBER,  
                                     P_A_NOMVAR IN PQ_CR_PRCLINEAS.tp_nomvar,
                                     P_A_VALVAR IN PQ_CR_PRCLINEAS.tp_valvar, 
                                     P_N_VAR IN number,
                                     P_A_REGLAS in PQ_CR_PRCLINEAS.tb_reglas, 
                                     P_N_REG in number,
                                     p_c_retorno out varchar2)
  IS
    
          
     cursor c_lista(p_RNG49Cod number, p_RNG50Grp number, p_RNG51COD number) is 
        select RNG49Cod, RNG50Grp, RNG51COD, RNG67COR, RNG67VAL
          from FRNG67
         where RNG49Cod = p_RNG49Cod
           and RNG50Grp = p_RNG50Grp
           and RNG51COD = p_RNG51COD
         order by RNG67COR;     
     
     ExisteGrupo char(1) := null;
     ResReglaGrupo char(1) := null;
     ResReglaLista char(1) := null;
     Regla frng51.rng49cod%type;
     --Regla2 frng51.rng49cod%type;
     l_RNG50Grp frng51.rng50grp%type;     
     l_RNG50Ret frng50.rng50ret%type;
     la_nomvar pq_cr_prclineas.tp_nomvar;
     la_valvar pq_cr_prclineas.tp_valvar;
     ln_var number(3) := 0;
     lc_valResuelto varchar2(30); 
     i number(5);
     ln_NumTmp1 number(10,2);
     ln_NumTmp2 number(10,2);
     --l_RNG68Tda frng68.rng68tda%type;
     --SegmentoRegla2 frng51.rng51val%type;
     l_RNG51Val varchar2(30);
     l_RNG67val varchar2(30);
     l_RNG51OPE varchar2(2);
     la_reglas pq_cr_prclineas.tb_reglas;
     ln_reg number(5);
     ln_ind number(5);
     
  BEGIN
  
     Regla := nvl(P_N_REGLA, 0);
     la_nomvar := p_a_nomvar; 
     la_valvar := p_a_valvar; 
     ln_var    := nvl(p_n_var, 0); 
     la_reglas := P_A_REGLAS; 
     ln_reg    := nvl(P_N_REG, 0); 
     
     For reg in 1..ln_reg loop 
        If la_reglas(reg).RNG49COD = Regla then 
            l_RNG50Ret := la_reglas(reg).RNG50Ret; 
            l_RNG50Grp := la_reglas(reg).RNG50GRP; 
            ExisteGrupo := 'S'; 
            ln_ind := reg; 
            Exit;
        End If;
     End loop;
     
     If ExisteGrupo = 'S' then --existe grupo
           
        -- Evaluando Variables
        ResReglaGrupo := 'S';           
        
                  
        WHILE la_reglas(ln_ind).RNG49COD = Regla LOOP
           
                If la_reglas(ln_ind).RNG50GRP <> l_RNG50Grp then --evaluar cambio de grupo
                    --Msg('Diferente grupo')
                    If ResReglaGrupo = 'N' And la_reglas(ln_ind).RNG50GRP = 999 then --Retorno Default (Condición ELSE)
                        --Msg('Retorno Default (Condición ELSE)')
                        p_c_retorno := la_reglas(ln_ind).RNG50Ret; 
                        --ResReglaGrupo := 'S'; 
                        --Msg(p_c_retorno)                         
                        Exit;
                    End If;
                      
                    If ResReglaGrupo = 'S' then --se cumple la regla para el grupo anterior
                        --Msg('grupo cumplido')
                        p_c_retorno := l_RNG50Ret ;
                        --ResReglaGrupo := 'S'; 
                        --Msg(p_c_retorno)
                        Exit;
                    Else --evaluar el siguiente grupo de la regla
                        --Msg('cambio de grupo')
                        l_RNG50Grp := la_reglas(ln_ind).RNG50GRP;
                        l_RNG50Ret := la_reglas(ln_ind).RNG50Ret;
                        --Msg('grupo : '+Str(RNG50Grp))
                        ResReglaGrupo := 'S';
                        --Do 'Limpiar VExpresion'
                    End If;
                End If;  

                -- Encontrar valor resuelto de atributo
                lc_valResuelto := '0';
                For i in 1..ln_var loop
                    If la_nomvar(i) = trim(la_reglas(ln_ind).RNG68ATR) then
                        lc_valResuelto := trim(la_valvar(i));
                        Exit;
                    End If; 
                End loop;
                               
                -- Resolver Regla anidada Nivel 2
--                If la_reglas(ln_ind).RNG68ATR in ('EXP1612','EXP1613','EXP1614','EXP1617') then
                --If la_reglas(ln_ind).RNG68ATR = 'EXP1621' then
                       
                    --Regla2 := to_number(substr(la_reglas(ln_ind).RNG68ATR,4,4));
                    --Msg('rutina regla anidada ' + Str(&Regla2))
                    --SegmentoRegla2 := null;
                    --PQ_CR_SEGMENTACION_CLIENTES.sp_cr_evalua_clientes_2_NS( P_N_REGLA => Regla2,
                    --                                                     P_A_NOMVAR => la_nomvar,
                    --                                                     P_A_VALVAR => la_valvar, 
                     --                                                    P_N_VAR => ln_var,
                     --                                                    P_A_REGLAS => la_reglas,
                     --                                                    P_N_REG => ln_reg,
                     --                                                    p_c_retorno => SegmentoRegla2);
                    --lc_valResuelto := Trim(SegmentoRegla2);

               -- End If;

                -- Evaluacion de condiciones
                l_RNG51Val := nvl(trim(la_reglas(ln_ind).RNG51VAL),'0');
                
                if lc_valResuelto = '100' then
                   lc_valResuelto := '100.00';   
                end if;                               
                if l_RNG51Val = '100' then
                   l_RNG51Val := '100.00';   
                end if;
                    
                l_RNG51OPE := trim(la_reglas(ln_ind).RNG51OPE); 
                Case l_RNG51OPE
                When '>=' then 
                    --Msg('es mayor igual que ' + l_RNG51Val)
                    --Msg(ValResuelto)
                    ln_NumTmp1 := to_number(lc_valResuelto);
                    ln_NumTmp2 := to_number(l_RNG51Val);
                    If ln_NumTmp1 < ln_NumTmp2 then 
                        --Msg('no cumple ' + reg.RNG68ATR)
                        ResReglaGrupo := 'N';
                    End If;

                When '>' then
                    --Msg('es mayor que ' + l_RNG51Val)
                    --Msg(lc_lc_valResuelto)
                    ln_NumTmp1 := to_number(lc_valResuelto);
                    ln_NumTmp2 := to_number(l_RNG51Val);
                    If ln_NumTmp1 <= ln_NumTmp2 then 
                        --Msg('no cumple ' + reg.RNG68ATR)
                        ResReglaGrupo := 'N';
                    End If;

                When '<=' then
                    --Msg('es menor igual que ' + l_RNG51Val)
                    --Msg(lc_valResuelto)
                    ln_NumTmp1 := to_number(lc_valResuelto);
                    ln_NumTmp2 := to_number(l_RNG51Val);
                    If ln_NumTmp1 > ln_NumTmp2  then --to_number(lc_valResuelto) > to_number(l_RNG51Val)
                        --Msg('no cumple ' + reg.RNG68ATR)
                        ResReglaGrupo := 'N';
                    End If;

                When '<' then 
                    --Msg('es menor que ' + l_RNG51Val)
                    --Msg(lc_valResuelto)
                    ln_NumTmp1 := to_number(lc_valResuelto);
                    ln_NumTmp2 := to_number(l_RNG51Val);
                    If ln_NumTmp1 >= ln_NumTmp2 then --to_number(lc_valResuelto) >= to_number(reg.RNG51VAL)
                        --Msg('no cumple ' + reg.RNG68ATR)
                        ResReglaGrupo := 'N';
                    End If;
                                  
                When '=' then
                    --Msg('es igual que ' + VeRNG51VAL(j))
                    --Msg(ValResuelto)                 
                    If lc_valResuelto <> l_RNG51Val then 
                        --Msg('no cumple ' + VeRNG68ATR(j))
                        ResReglaGrupo := 'N';
                    End If;
                   

                When '<>' then
                    --Msg('es diferente que ' + VeRNG51VAL(j))
                    --Msg(ValResuelto)
                    
                    If lc_valResuelto = l_RNG51Val then 
                         --Msg('no cumple ' + VeRNG68ATR(j))
                        ResReglaGrupo := 'N';
                     End If;
                    
                                         
                When 'EN' then                        
                     ResReglaLista := 'N';
                     -- valores de evaluacion lista
                     For lis in c_lista(la_reglas(ln_ind).RNG49COD, l_RNG50Grp, la_reglas(ln_ind).RNG51COD) loop                          
                         --Msg('esta EN ' + MVaLista(i, 4)) 
                         l_RNG67val := trim(lis.rng67val);
                         If lc_valResuelto = l_RNG67val then
                             ResReglaLista := 'S';
                             Exit;   
                         End If;
                     End Loop;
                     --Msg(lc_valResuelto)
                     If ResReglaLista = 'N' then
                        --Msg('no cumple ' + reg.RNG68ATR)
                        ResReglaGrupo := 'N';
                     End If;
                               
                When 'NE' then
                    ResReglaLista := 'N';
                    For lis in c_lista(la_reglas(ln_ind).RNG49COD, l_RNG50Grp, la_reglas(ln_ind).RNG51COD) loop                                        
                        --Msg('NO esta EN ' + MVaLista(i, 4)) 
                        l_RNG67val := trim(lis.rng67val);
                        If lc_valResuelto = l_RNG67val then
                           ResReglaLista := 'S';
                           Exit;
                        End If; 
                    End Loop;
                    --Msg(lc_valResuelto)
                    If ResReglaLista = 'S' then 
                        --Msg('no cumple ' + reg.RNG68ATR)
                        ResReglaGrupo := 'N';
                    End If;

                Else
                    ResReglaGrupo := 'N'; --faltan variaciones de like y not like
                    
                End Case; 
             
             --END IF; -- regla evaluada
             ln_ind := ln_ind + 1;
              
          END LOOP; -- reglas

     End If; -- existe grupo
     
END sp_cr_evalua_clientes_1;     

Procedure sp_ubigeo (pn_pais in number, pn_tdoc in number,pc_ndoc in char,
                       ln_dis out number,ln_provin out number,ln_dpto out number)is
--ln_dis number(9);
--ln_provin number(5);
--ln_dpto number(5);
begin
  begin
  select sngc13dist,sngc13prov,sngc13dpto
    into ln_dis,ln_provin,ln_dpto
    from sngc13 aa
   where aa.sngc13pais = pn_pais
     and aa.sngc13tdoc = pn_tdoc
     and aa.sngc13ndoc = pc_ndoc
     and aa.docod = 1
     and aa.sngc13est = 'H';
  exception 
      when no_data_found then 
         ln_dis    := null;
         ln_provin := null;
         ln_dpto   := null;
      when too_many_rows then
         begin
        select sngc13dist,sngc13prov,sngc13dpto
          into ln_dis,ln_provin,ln_dpto
          from sngc13 aa
         where aa.sngc13pais = pn_pais
           and aa.sngc13tdoc = pn_tdoc
           and aa.sngc13ndoc = pc_ndoc
           and aa.docod = 1
           and aa.sngc13est = 'H'
           and rownum = 1;
        exception 
            when no_data_found then 
               ln_dis    := null;
               ln_provin := null;
               ln_dpto   := null;
           end;   
     end;   
    
end sp_ubigeo;

Procedure Sp_CargaTabla(P_C_IDCONX IN VARCHAR2,
                        P_C_CODUSU IN VARCHAR2,
                        P_N_TIPDOC IN NUMBER,
                        P_C_NUMDOC IN VARCHAR2)is

cursor lineas (ln_pai in number,lc_num in char) is
select *
  from jaqz505 a
 where a.jaqz505pai = ln_pai
   and a.jaqz505tdo = P_N_TIPDOC
   and a.jaqz505ndo = lc_num;--TRIM(P_C_NUMDOC);                       
ln_pai number(3) := 604;
ld_fecpro date :=null;
lc_nompro varchar2(30);
lc_moneda varchar(3);
lc_nom varchar2(110);
lc_tiper char(1);
ln_cuotas number(5);
ln_mtoTo number(17,2);
ln_mtoDA number(17,2);
ln_mtoDP number(17,2);
ln_mtoUA number(17,2);
ln_mtoUP number(17,2);
flg_est varchar2(1);
lc_estado varchar2(1);
lc_desc varchar2(50);
lc_numdoc char(12);
begin
  
     
    begin
       select a.pgfape into ld_fecpro from fst017 a where a.pgcod = 1;
    end;
  
    delete from JAQZ508
     where JAQZ508IDC = P_C_IDCONX
       and JAQZ508USR = P_C_CODUSU;
  
    commit;
    ln_pai := 604;
    lc_numdoc := trim(P_C_NUMDOC);
    For i in lineas (ln_pai,lc_numdoc )loop
        lc_estado:=null;
        lc_desc:= null;
        --producto
        begin
          select a.tonom
            into lc_nompro
            from fst004 a
           where a.modulo = i.jaqz505mod
             and a.totope = i.jaqz505top;
        exception
             when others then null;
        end;
        
        if i.jaqz505mda = 0 then
          lc_moneda := 'S/.';
          else
            lc_moneda := '$';
        end if;
        
        --nombre
        begin
            select a.petipo
              into lc_tiper
              from fsd001 a
             where a.pepais = ln_pai
               and a.petdoc = P_N_TIPDOC
               and a.pendoc = lc_numdoc;
        exception
             when others then null;
        end;
        if lc_tiper = 'F' then
          begin
              select trim(a.pfape1) || ' ' || trim(a.pfape2) || ', ' ||
                     trim(a.pfnom1) || ' ' || trim(a.pfnom2)
                into lc_nom
                from fsd002 a
               where a.pfpais = ln_pai
                 and a.pftdoc = P_N_TIPDOC
                 and a.pfndoc = lc_numdoc;
          exception 
            when others then null;
          end;
          
          else
            begin
              select trim(a.pjrazs)
                into lc_nom
                from fsd003 a
               where a.pjpais = ln_pai
                 and a.pjtdoc = P_N_TIPDOC
                 and a.pjndoc = lc_numdoc;
            exception
             when others then null;
            end;
        end if;
        --plazo en meses
        ln_cuotas := null;
        begin

        select pp028defn 
          into ln_cuotas
          from fpp028 a
         where a.pp028emp = 1 --mod@abr 20170605
           and a.pp017par = 103 
           and a.pp028mod = 116 
           and a.pp028top = i.jaqz505top
           and a.pp028mda = i.jaqz505mda;
        exception when others then
                    ln_cuotas := 0;
        end;
        --
        
        --adicional
        pq_cr_prclineas.Sp_LineaAdicional(/*i.jaqz505emp,
                                          i.jaqz505mod,
                                          i.jaqz505suc,
                                          i.jaqz505mda,
                                          i.jaqz505pap,
                                          i.jaqz505cta,
                                          i.jaqz505ope,
                                          i.jaqz505sbo,*/
                                          i.jaqz505top,
                                          i.jaqz505ins,
                                          ln_mtoTo,
                                          ln_mtoDP,
                                          ln_mtoDA,
                                          ln_mtoUP,
                                          ln_mtoUA,
                                          flg_est);
        --Flag de estado
        if i.jaqz505pen = 'S' then
           lc_estado := 'S';
        end if;
        
        if i.jaqz505pen = 'N' then
           lc_estado := 'N';
           lc_desc := 'Sin penalidad';
        end if;
        
        
        
        if flg_est = 'N' then
        
          insert into jaqz508(jaqz508idc,jaqz508usr,jaqz508pai,jaqz508tdo,jaqz508ndo,jaqz508nom,jaqz508fec,jaqz508hor,jaqz508pro,
                              jaqz508mda,jaqz508mot,jaqz508pzo,jaqz508modp,jaqz508moda,jaqz508moup,jaqz508moua,
                              jaqz508fvt,jaqz508est,jaqz508vac)
                      values(P_C_IDCONX,
                             P_C_CODUSU,
                             ln_pai,
                             i.jaqz505tdo,
                             i.jaqz505ndo,
                             lc_nom,
                             trunc(sysdate),
                             to_char(sysdate, 'HH24:MI:SS'),
                             lc_nompro,
                             lc_moneda,
                             ln_mtoTo,
                             ln_cuotas,
                             ln_mtoDP,
                             ln_mtoDA,
                             ln_mtoUP,
                             ln_mtoUA,
                             i.jaqz505fev,
                             lc_estado,
                             lc_desc
                             )     ;   
                             
           commit;
        end if;                
    end loop;
  

  

end Sp_CargaTabla;

Procedure Sp_LineaAdicional(/*pn_emp in number,
                            pn_mod in number,
                            pn_suc in number,
                            pn_mda in number,
                            pn_pap in number,
                            pn_cta in number,
                            pn_ope in number,
                            pn_sbo in number,*/
                            pn_top in number,
                            pn_ins in number,
                            pn_mtoTot out number,
                            pn_mtoDP  out number,
                            pn_mtoDA  out number,
                            pn_mtoUP  out number,
                            pn_mtoUA  out number,
                            pc_flg    out varchar2)is

ln_adic number(5);
ln_mtoA number(18,2);
ln_mtoP number(18,2);
begin
     
     pc_flg := 'N';
     ln_mtoA  := 0;
     ln_mtoP  := 0;
     begin
       select 'S'
         into pc_flg
         from fst198 a
        where a.Tp1cod   = 1 --mod@abr 20170601 optimizacion
          and a.tp1cod1 = 20001
          and a.tp1corr1 = 1
          and a.tp1corr2 = 1211
          and tp1nro1    = pn_top;     
     exception
       when others then
         pc_flg := 'N';
     end;
     
     begin
          select count(*)
            into ln_adic
            from jaqz505 a
           where a.jaqz505ins = pn_ins;
     exception
       when others then
            ln_adic := 0;
     end;
     
     if ln_adic > 1 then
        
        begin
          select a.jaqz505lto,
                 a.jaqz505ldi,
                 a.jaqz505lut
            into ln_mtoA,
                 pn_mtoDA,
                 pn_mtoUA
            from jaqz505 a
           where a.jaqz505ins = pn_ins
             and a.jaqz505top in (select tp1nro1
                                    from fst198 r
                                   where r.Tp1cod   = 1 --mod@abr 20170601 optimizacion
                                     and r.tp1cod1 = 20001
                                     and r.tp1corr1 = 1
                                     and r.tp1corr2 = 1211);
         exception
           when others then
                ln_mtoA  := 0;
                pn_mtoDA := 0;
                pn_mtoUA := 0;
         end;  
         
         begin
          select a.jaqz505lto,
                 a.jaqz505ldi,
                 a.jaqz505lut
            into ln_mtoP,
                 pn_mtoDP,
                 pn_mtoUP
            from jaqz505 a
           where a.jaqz505ins = pn_ins
             and a.jaqz505top in (select tp1corr3
                                    from fst198 r
                                   where r.Tp1cod   = 1 --mod@abr 20170601 optimizacion
                                     and r.tp1cod1 = 20001
                                     and r.tp1corr1 = 1
                                     and r.tp1corr2 = 1211);
         exception
           when others then
                ln_mtoP  := 0;
                pn_mtoDP := 0;
                pn_mtoUP := 0;
         end;  
         
         pn_mtoTot := nvl(ln_mtoA,0)+nvl(ln_mtoP,0);
         
         else
             --ln_mtoA  := 0;     
             pn_mtoDA := 0;
             pn_mtoUA := 0;
             
             begin
                select a.jaqz505lto,
                       a.jaqz505ldi,
                       a.jaqz505lut
                  into ln_mtoP,
                       pn_mtoDP,
                       pn_mtoUP
                  from jaqz505 a
                 where a.jaqz505ins = pn_ins/*
                   and a.jaqz505top in (select tp1corr3
                                          from fst198 a
                                         where a.tp1cod1 = 20001
                                           and a.tp1corr1 = 1
                                           and a.tp1corr2 = 1211)*/;
               exception
                 when others then
                      ln_mtoP  := 0;
                      pn_mtoDP := 0;
                      pn_mtoUP := 0;
               end;  
               
               pn_mtoTot := nvl(ln_mtoP,0);
             
         
     end if;
    /* select 'S'
          into Pc_flag
          from fst198 a
         where a.tp1cod1 = 20001
           and a.tp1corr1 = 1
           and a.tp1corr2 = 1211
           and a.tp1nro1 = pn_top;*/
     
     
end Sp_LineaAdicional;

Procedure Sp_CargaTabCalor(P_C_IDCONX IN VARCHAR2,
                        P_C_CODUSU IN VARCHAR2,
                        P_N_DISTRI IN NUMBER)is

cursor lineas(lv_usuario varchar2) is
select *
  from jaqz505 a
 where a.jaqz505dis = P_N_DISTRI
   and trim(a.jaqz505ana) = lv_usuario;--TRIM(P_C_NUMDOC); 

--mod@abr 20171024   
cursor lineas_tot(lv_usuario varchar2) is
select *
  from jaqz505 a
 where /*a.jaqz505dis = P_N_DISTRI
   and */trim(a.jaqz505ana) = lv_usuario;                         
--mod@abr 20171024   

ld_fecpro date :=null;
lc_nompro varchar2(30);
lc_moneda varchar(3);
lc_nom varchar2(110);
lc_tiper char(1);
ln_cuotas number(5);
ln_mtoTo number(17,2);
ln_mtoDA number(17,2);
ln_mtoDP number(17,2);
ln_mtoUA number(17,2);
ln_mtoUP number(17,2);
flg_est varchar2(1);
lc_estado varchar2(1);
lc_desc varchar2(50);
lv_latitud varchar2(140);
lv_longitud varchar2(200);
lv_usu varchar2(12);
begin
  
     
    begin
       select a.pgfape into ld_fecpro from fst017 a where a.pgcod = 1;
    end;
    
    if P_C_CODUSU = 'ZSALASL' then --mod@abr
       lv_usu := 'JPONCE';
       else
             if P_C_CODUSU = 'RANGULO' then --mod@abr
               lv_usu := 'HTACO';
               else
                 if P_C_CODUSU = 'RDSBMOBILE' then --mod@abr
                     lv_usu := 'HTACO';
                      else
                    lv_usu := P_C_CODUSU;
                 end if;           
             end if;
    end if;
    delete from JAQZ508
     where JAQZ508IDC = P_C_IDCONX
       and JAQZ508USR = P_C_CODUSU;
  
    commit;
    
    if P_N_DISTRI = 0 then 
    
       For i in lineas_tot(lv_usu) loop
        lc_estado:=null;
        lc_desc:= null;
        --producto
        begin
          select a.tonom
            into lc_nompro
            from fst004 a
           where a.modulo = i.jaqz505mod
             and a.totope = i.jaqz505top;
        exception
             when others then null;
        end;
        
        if i.jaqz505mda = 0 then
          lc_moneda := 'S/.';
          else
            lc_moneda := '$';
        end if;
        
        --nombre
        begin
            select a.petipo
              into lc_tiper
              from fsd001 a
             where a.pepais = i.jaqz505pai
               and a.petdoc = i.jaqz505tdo
               and a.pendoc = i.jaqz505ndo;
        exception
             when others then null;
        end;
        if lc_tiper = 'F' then
          begin
              select trim(a.pfape1) || ' ' || trim(a.pfape2) || ', ' ||
                     trim(a.pfnom1) || ' ' || trim(a.pfnom2)
                into lc_nom
                from fsd002 a
               where a.pfpais = i.jaqz505pai
                 and a.pftdoc = i.jaqz505tdo
                 and a.pfndoc = i.jaqz505ndo;
          exception 
            when others then null;
          end;
          
          else
            begin
              select trim(a.pjrazs)
                into lc_nom
                from fsd003 a
               where a.pjpais = i.jaqz505pai
                 and a.pjtdoc = i.jaqz505tdo
                 and a.pjndoc = i.jaqz505ndo;
            exception
             when others then null;
            end;
        end if;
        --plazo en meses
        ln_cuotas := null;
        begin

        select pp028defn 
          into ln_cuotas
          from fpp028 a
         where a.pp028emp = 1 --mod@abr 20170605
           and a.pp017par = 103 
           and a.pp028mod = 116 
           and a.pp028top = i.jaqz505top
           and a.pp028mda = i.jaqz505mda;
        exception when others then
                    ln_cuotas := 0;
        end;
        --
        
        --adicional
        pq_cr_prclineas.Sp_LineaAdicional(/*i.jaqz505emp,
                                          i.jaqz505mod,
                                          i.jaqz505suc,
                                          i.jaqz505mda,
                                          i.jaqz505pap,
                                          i.jaqz505cta,
                                          i.jaqz505ope,
                                          i.jaqz505sbo,*/
                                          i.jaqz505top,
                                          i.jaqz505ins,
                                          ln_mtoTo,
                                          ln_mtoDP,
                                          ln_mtoDA,
                                          ln_mtoUP,
                                          ln_mtoUA,
                                          flg_est);
        --Flag de estado
        if i.jaqz505pen = 'S' then
           lc_estado := 'S';
        end if;
        
        if i.jaqz505pen = 'N' then
           lc_estado := 'N';
           lc_desc := 'Sin penalidad';
        end if;
        
        --LATITUD/LONGITUD
        Begin
            select sngc13ref
              into lv_latitud
              from sngc13
             where SNGC13PAIS = i.jaqz505pai
               and SNGC13TDOC = i.jaqz505tdo
               and sngc13ndoc = i.jaqz505ndo
               and sngc13est  = 'I'
               and docod      = 1
               and sngc13corr = 500;
        exception
          when others then null;
        end;
        
        begin
          select sngc13ref1
            into lv_longitud
            from sngc13
           where SNGC13PAIS = i.jaqz505pai
             and SNGC13TDOC = i.jaqz505tdo
             and sngc13ndoc = i.jaqz505ndo
             and sngc13est = 'I'
             and docod = 1
             and sngc13corr = 500;
        exception
          when others then null;
        end;
        
        if flg_est = 'N' then
        
          insert into JAQZ512(JAQZ512idc,JAQZ512usr,JAQZ512pai,JAQZ512tdo,JAQZ512ndo,JAQZ512nom,JAQZ512fec,JAQZ512hor,JAQZ512pro,
                              JAQZ512mda,JAQZ512mot,JAQZ512pzo,JAQZ512modp,JAQZ512moda,JAQZ512moup,JAQZ512moua,
                              JAQZ512fvt,JAQZ512est,JAQZ512vac,JAQZ512LAT,JAQZ512LON)
                      values(P_C_IDCONX,
                             P_C_CODUSU,
                             i.jaqz505pai,
                             i.jaqz505tdo,
                             i.jaqz505ndo,
                             lc_nom,
                             trunc(sysdate),
                             to_char(sysdate, 'HH24:MI:SS'),
                             lc_nompro,
                             lc_moneda,
                             ln_mtoTo,
                             ln_cuotas,
                             ln_mtoDP,
                             ln_mtoDA,
                             ln_mtoUP,
                             ln_mtoUA,
                             i.jaqz505fev,
                             lc_estado,
                             lc_desc,
                             lv_latitud,
                             lv_longitud
                             )     ;   
                             
           commit;
        end if;                
    end loop;
    
    
    else
    
              For i in lineas(lv_usu) loop
                  lc_estado:=null;
                  lc_desc:= null;
                  --producto
                  begin
                    select a.tonom
                      into lc_nompro
                      from fst004 a
                     where a.modulo = i.jaqz505mod
                       and a.totope = i.jaqz505top;
                  exception
                       when others then null;
                  end;
                  
                  if i.jaqz505mda = 0 then
                    lc_moneda := 'S/.';
                    else
                      lc_moneda := '$';
                  end if;
                  
                  --nombre
                  begin
                      select a.petipo
                        into lc_tiper
                        from fsd001 a
                       where a.pepais = i.jaqz505pai
                         and a.petdoc = i.jaqz505tdo
                         and a.pendoc = i.jaqz505ndo;
                  exception
                       when others then null;
                  end;
                  if lc_tiper = 'F' then
                    begin
                        select trim(a.pfape1) || ' ' || trim(a.pfape2) || ', ' ||
                               trim(a.pfnom1) || ' ' || trim(a.pfnom2)
                          into lc_nom
                          from fsd002 a
                         where a.pfpais = i.jaqz505pai
                           and a.pftdoc = i.jaqz505tdo
                           and a.pfndoc = i.jaqz505ndo;
                    exception 
                      when others then null;
                    end;
                    
                    else
                      begin
                        select trim(a.pjrazs)
                          into lc_nom
                          from fsd003 a
                         where a.pjpais = i.jaqz505pai
                           and a.pjtdoc = i.jaqz505tdo
                           and a.pjndoc = i.jaqz505ndo;
                      exception
                       when others then null;
                      end;
                  end if;
                  --plazo en meses
                  ln_cuotas := null;
                  begin

                  select pp028defn 
                    into ln_cuotas
                    from fpp028 a
                   where a.pp028emp = 1 --mod@abr 20170605
                     and a.pp017par = 103 
                     and a.pp028mod = 116 
                     and a.pp028top = i.jaqz505top
                     and a.pp028mda = i.jaqz505mda;
                  exception when others then
                              ln_cuotas := 0;
                  end;
                  --
                  
                  --adicional
                  pq_cr_prclineas.Sp_LineaAdicional(/*i.jaqz505emp,
                                                    i.jaqz505mod,
                                                    i.jaqz505suc,
                                                    i.jaqz505mda,
                                                    i.jaqz505pap,
                                                    i.jaqz505cta,
                                                    i.jaqz505ope,
                                                    i.jaqz505sbo,*/
                                                    i.jaqz505top,
                                                    i.jaqz505ins,
                                                    ln_mtoTo,
                                                    ln_mtoDP,
                                                    ln_mtoDA,
                                                    ln_mtoUP,
                                                    ln_mtoUA,
                                                    flg_est);
                  --Flag de estado
                  if i.jaqz505pen = 'S' then
                     lc_estado := 'S';
                  end if;
                  
                  if i.jaqz505pen = 'N' then
                     lc_estado := 'N';
                     lc_desc := 'Sin penalidad';
                  end if;
                  
                  --LATITUD/LONGITUD
                  Begin
                      select sngc13ref
                        into lv_latitud
                        from sngc13
                       where SNGC13PAIS = i.jaqz505pai
                         and SNGC13TDOC = i.jaqz505tdo
                         and sngc13ndoc = i.jaqz505ndo
                         and sngc13est  = 'I'
                         and docod      = 1
                         and sngc13corr = 500;
                  exception
                    when others then null;
                  end;
                  
                  begin
                    select sngc13ref1
                      into lv_longitud
                      from sngc13
                     where SNGC13PAIS = i.jaqz505pai
                       and SNGC13TDOC = i.jaqz505tdo
                       and sngc13ndoc = i.jaqz505ndo
                       and sngc13est = 'I'
                       and docod = 1
                       and sngc13corr = 500;
                  exception
                    when others then null;
                  end;
                  
                  if flg_est = 'N' then
                  
                    insert into JAQZ512(JAQZ512idc,JAQZ512usr,JAQZ512pai,JAQZ512tdo,JAQZ512ndo,JAQZ512nom,JAQZ512fec,JAQZ512hor,JAQZ512pro,
                                        JAQZ512mda,JAQZ512mot,JAQZ512pzo,JAQZ512modp,JAQZ512moda,JAQZ512moup,JAQZ512moua,
                                        JAQZ512fvt,JAQZ512est,JAQZ512vac,JAQZ512LAT,JAQZ512LON)
                                values(P_C_IDCONX,
                                       P_C_CODUSU,
                                       i.jaqz505pai,
                                       i.jaqz505tdo,
                                       i.jaqz505ndo,
                                       lc_nom,
                                       trunc(sysdate),
                                       to_char(sysdate, 'HH24:MI:SS'),
                                       lc_nompro,
                                       lc_moneda,
                                       ln_mtoTo,
                                       ln_cuotas,
                                       ln_mtoDP,
                                       ln_mtoDA,
                                       ln_mtoUP,
                                       ln_mtoUA,
                                       i.jaqz505fev,
                                       lc_estado,
                                       lc_desc,
                                       lv_latitud,
                                       lv_longitud
                                       )     ;   
                                       
                     commit;
                  end if;                
              end loop;
  
      end if;
  

end Sp_CargaTabCalor;


end PQ_CR_PRCLINEAS;
/

