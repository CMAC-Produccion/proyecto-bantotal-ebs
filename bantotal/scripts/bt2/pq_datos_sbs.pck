create or replace package pq_datos_sbs is
    -- *****************************************************************
    -- Nombre                     : PAQUETES PARA OBTENER INFORMACION PARA SBS BDC01 BDC02
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.08.10
    -- Autor de Creación          : LLLOSA
    -- Uso                        : Realiza cálculos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :
    --
    --
    --
    -- *****************************************************************
-----------------------------------------------------------------------

  function fn_csbs (pn_pepais in number,pn_petdoc in number, pc_pendoc in varchar2, pd_fecpro in date) return varchar2;
  function fn_ncl (pn_pepais in number,pn_petdoc in number, pc_pendoc in varchar2) return varchar2;
  function fn_morg (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                        pn_pap in number, pn_cta in number, pn_oper in number,
                        pn_sbop in number,pn_top in number, pn_aoimp in number,
                        pn_tipcam in number, pn_salcap in number  ) return number;
  function fn_cal (pn_emp in number, pn_cta in number, pd_feccat in date, pn_codcat in number ) return varchar2;
  Procedure sp_job_procesa_datos (pd_fecpro in varchar2 );
  Procedure sp_procesa_datos (pn_numsuc in number, pd_fecpro in varchar2 );
  function fn_Saldo_relacion(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                           pn_pap in number, pn_cta in number, pn_oper in number,
                           pn_sbop in number,pn_top in number, pd_fecpro in date, pn_nrorel in number, pn_rubro in number) return number;
  function fn_Saldo_relacion2(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                           pn_pap in number, pn_cta in number, pn_oper in number,
                           pn_sbop in number,pn_top in number, pd_fecpro in date, pn_nrorel in number,
                           pn_rubro in number) return number;

  function fn_Saldo_relacion3(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                           pn_pap in number, pn_cta in number, pn_oper in number,
                           pn_sbop in number,pn_top in number, pd_fecpro in date, pn_nrorel in number,
                           pn_rubro in varchar2) return number ;
  function fn_Saldo_relacion4(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                           pn_pap in number, pn_cta in number, pn_oper in number,
                           pn_sbop in number,pn_top in number, pd_fecpro in date, pn_nrorel in number,
                           pn_rubro in varchar2 ) return number;
  function fn_tcr(pn_rubro in number) return varchar2;
  function fn_skcr(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                 pn_pap in number, pn_cta in number, pn_oper in number,
                 pn_sbop in number,pn_top in number, pd_fecpro in date ) return number;
  function  fn_dapr(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                  pn_pap in number, pn_cta in number, pn_oper in number,
                  pn_sbop in number,pn_top in number, pd_fecpro in date) return number;
  procedure sp_cta_saldo_relacion(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                               pn_pap in number, pn_cta in number, pn_oper in number,
                               pn_sbop in number,pn_top in number, pd_fecpro in date, pn_nrorel in number,
                               pc_rubro in varchar2, pn_saldo out number, pn_rubro out number);
  procedure sp_cta_saldo_relacion2(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                               pn_pap in number, pn_cta in number, pn_oper in number,
                               pn_sbop in number,pn_top in number, pd_fecpro in date, pn_nrorel in number,
                               pc_rubro in varchar2, pn_saldo out number, pn_rubro out number);
  function  fn_fot(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                  pn_pap in number, pn_cta in number, pn_oper in number,
                  pn_sbop in number,pn_top in number, pn_nrpg in number) return date;
  function  fn_esam(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                  pn_pap in number, pn_cta in number, pn_oper in number,
                  pn_sbop in number,pn_top in number) return number ;
  procedure sp_dgr_pcuo_ncpr(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                 pn_pap in number, pn_cta in number, pn_oper in number,
                 pn_sbop in number,pn_top in number, pn_nrprg in number,pn_diagra out number, pn_period out number, pn_cancuo out number ) ;
  function fn_fppk (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                  pn_pap in number, pn_cta in number, pn_oper in number,
                  pn_sbop in number,pn_top in number, pn_nrpg in number, pd_fecdes in date ) return date;
  function fn_fvep (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number, pd_fecpro in date ) return date;
  function fn_ncpr (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                        pn_pap in number, pn_cta in number, pn_oper in number,
                        pn_sbop in number,pn_top in number ) return number;
  function fn_ncpa(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                 pn_pap in number, pn_cta in number, pn_oper in number,
                 pn_sbop in number,pn_top in number,  pn_nrpg in number, pd_fecpro in date ) return number;
  function fn_ciiu (pn_cta in number ) return number;
  function fn_mdcr(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                 pn_pap in number, pn_cta in number, pn_oper in number,
                 pn_sbop in number,pn_top in number, pd_fecpro in date,
                 pn_rubro in number, pn_stat in number, pn_instac in number, 
                 pc_indamp in varchar2 , pn_numrpr in number, pn_pais in number, 
                 pn_tipdoc in number, pc_numdoc in varchar2 ) return varchar2;
  procedure  sp_nrprg_fultrprg (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                 pn_pap in number, pn_cta in number, pn_oper in number,
                 pn_sbop in number,pn_top in number, pn_instac in number,pd_fecpro in date,
                 pn_totcam out number, pd_fulcam out varchar2 , pc_indamp out varchar2 );
  function fn_indic(pn_mod in number,pn_rubro in number) return number;
  procedure  sp_lco_lcnu_cclcnu(pn_emp in number, pn_mod in number, pn_suc in number,
                 pn_mda in number,pn_pap in number, pn_cta in number,
                 pn_oper in number,pn_sbop in number,pn_top in number,
                 pd_fecpro in date, pn_sdmn in number,pn_rubro in number,
                 pn_lco out number, pn_lcnu out number, pn_cclcnu out number );
  function fn_tcrint(pn_rubro in number, pn_sector in number) return varchar2;
  function fn_tcri(pn_rubro in number, pn_sector in number) return varchar2;
  function fn_rom(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                           pn_pap in number, pn_cta in number, pn_oper in number,
                           pn_sbop in number,pn_top in number, pd_fecpro in date) return number ;
  function fn_tspi(pn_modulo in number, pn_toper in number) return varchar2;
  function fn_deslin(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                   pn_pap in number, pn_cta in number, pn_oper in number,
                   pn_sbop in number,pn_top in number) return varchar2;
  Procedure sp_job_procesa_BDC01 (pd_fecpro in varchar2 );
  Procedure sp_procesa_BDC01 (pn_numsuc in number, pd_fecpro in varchar2 );
  function fn_scom(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                           pn_pap in number, pn_cta in number, pn_oper in number,
                           pn_sbop in number,pn_top in number, pd_fecpro in date) return number;

  function fn_sim(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                           pn_pap in number, pn_cta in number, pn_oper in number,
                           pn_sbop in number,pn_top in number, pn_capcuo in number, pn_diaatr in number) return number;
  Procedure sp_job_procesa_BDC02 (pd_fecpro in varchar2 );
  Procedure sp_procesa_BDC02 (pn_numsuc in number,  pd_fecpro in varchar2 );
  Procedure sp_job_procesa_BDC01P (pd_fecpro in varchar2 );
  Procedure sp_procesa_BDC01P (pn_numsuc in number, pd_fecpro in varchar2 );
  function fn_tipo_garantia(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                          pn_pap in number, pn_cta in number, pn_oper in number,
                          pn_sbop in number,pn_top in number ) return varchar2;
  function fn_Saldo_garantia(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                          pn_pap in number, pn_cta in number, pn_oper in number,
                          pn_sbop in number,pn_top in number, pd_fecha in date ) return number ;

  Procedure sp_job_procesa_BDC01_GP (pd_fecpro in varchar2 );
  Procedure sp_procesa_BDC01_GP (pn_numsuc in number, pd_fecpro in varchar2 );
  function fn_ncpend(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                 pn_pap in number, pn_cta in number, pn_oper in number,
                 pn_sbop in number,pn_top in number, pd_fecpro in date ) return number;
  Procedure sp_job_procesa_BDC01_DIF (pd_fecpro in varchar2 );
  Procedure sp_procesa_BDC01_DIF (pn_numsuc in number, pd_fecpro in varchar2 );
  function fn_cartrasferida(pn_cta in number, pn_oper in number ) return varchar2 ;
  PROCEDURE SP_IRCP(pn_inst in number,
                  pn_tcr in number,
                  pn_nrodoc in varchar2,
                  pn_ircp out number,
                  pn_rcp out number,
                  pn_rpcn out number,
                  pn_resul out number,
                  pn_ting out number,
                  pc_sting out varchar2,
                  pc_oing out varchar2,
                  pn_gneg out number,
                  pn_gfam out number,
                  pn_nrodep out number);
  Procedure sp_job_procesa_BDC01_0102 (pd_fecpro in varchar2 );
  Procedure sp_procesa_BDC01_0102 (pn_numsuc in number, pd_fecpro in varchar2 );
  PROCEDURE SP_DATOS_ED01(pd_fecpro in date,
                        pc_codsbs in varchar2,
                        tipocambio    in number,
                        pn_ctacli in number,
                        pn_inst in number,
                        ----------
                        pn_nde  out number,
                        pn_ddes  out number,
                        pn_dies  out number,
                        pn_cdds  out number,
                        pn_cdis  out number,
                        pn_ddee  out number,
                        pn_diee  out number,
                        pn_cdde  out number,
                        pn_cdie  out number,
                        pn_ing  out number,
                        pn_fting out number,
                        pd_fing  out date,
                        pn_sdda out number,
                        pc_cmma out varchar2,
                        pn_fmma out number,
                        pn_fdda out number,
                        pn_pdda out number,
                        pn_sdds out number,
                        pc_cmms out varchar2,
                        pn_fmms out number,
                        pn_fdds out number,
                        pn_pdds out number,
                        pn_rse  out number,
                        pn_acse out number,
                        pn_cce  out number,
                        pn_tdx  out number,
                        pn_nae out number);
  Procedure sp_job_procesa_ED01 (pd_fecpro in varchar2 );
  Procedure sp_procesa_ED01 (pn_numsuc in number, pd_fecpro in varchar2 );
  ---------
  Procedure sp_Valida_BDC01;
  function fn_cambia_tea (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                      pn_pap in number, pn_cta in number, pn_oper in number,
                      pn_sbop in number,pn_top in number, pd_fecpro in date) return number;
  Procedure Sp_RelCredi_NR(pn_pai in number,pn_tdo in number,pc_ndo in char,pd_Fecpro in date,
                         ln_contador out number); 
  function fn_Tipdoc_sbs(pn_tipdoc in number) return number;
  Procedure sp_job_procesa_BDC01_O (pd_fecpro in varchar2 );
  Procedure sp_procesa_BDC01_O (pn_numsuc in number, pd_fecpro in varchar2 );
  --------------------
  
  function   fn_ult_rprg (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                 pn_pap in number, pn_cta in number, pn_oper in number,
                 pn_sbop in number,pn_top in number, pn_instac in number,pd_fecpro in date, pn_rubro in number) return varchar2 ;

function fn_califica (pn_emp in number, pn_cta in number, pd_feccat in date, pn_codcat in number ) return varchar2;
Procedure sp_job_procesa_BDC02_todo (pd_fecpro in varchar2 );
Procedure sp_procesa_BDC02_todo (pn_numsuc in number,  pd_fecpro in varchar2 );
function fn_tea (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                 pn_pap in number, pn_cta in number, pn_oper in number,
                 pn_sbop in number,pn_top in number) return number;
function fn_reprogramado (pn_mod in number, pn_suc in number, pn_mda in number,
                          pn_pap in number, pn_cta in number, pn_oper in number,
                          pn_sbop in number,pn_top in number, pd_Fecpro in date )return number;                 

function fn_tipli_cierre(pn_pais in number, pn_tipdoc in number, pc_numdoc in varchar2, pd_Fecpro in date ) return varchar2 ;
procedure  sp_TIPCLI(P_D_FECHA   IN DATE,
                        P_N_PAIS    in number,
                        p_n_tipdoc  in number,
                        p_c_numdoc  in char,
                        p_c_usuario in varchar2,
                        P_N_CODCAl  out number,
                        P_C_DESCAL  out varchar2);
 end pq_datos_sbs;
/

create or replace package body pq_datos_sbs is


function fn_csbs (pn_pepais in number,pn_petdoc in number, pc_pendoc in varchar2, pd_fecpro in date) return varchar2
is
lc_codsbs varchar2(10);
--lc_numdoc char(12);
begin
 --lc_numdoc:= pc_pendoc;
  begin
    select lpad(to_char(c.bc739sbs),10,0)
      into lc_codsbs
      from  fbc739 c
     where c.bc739pais = pn_pepais
       and c.bc739tdoc = pn_petdoc
       and c.bc739ndoc = pc_pendoc
       and rownum = 1;
  exception
      when others then
         if pn_petdoc = 9 then -- judiciales
           begin
             select c_codsbs
               into lc_codsbs
               from cldrcci
              where c_doctri = pc_pendoc
                and d_fecpre = pd_fecpro
                and rownum = 1;
           exception
              when others then
                   lc_codsbs := null;
           end;
         else
           begin
             select c_codsbs
               into lc_codsbs
               from cldrcci
              where c_docide = pc_pendoc
                and d_fecpre = pd_fecpro
                and rownum = 1;
           exception
              when others then
                   lc_codsbs := null;
           end;
        end if;
  end;
   return lc_codsbs;
end fn_csbs;
function fn_ncl (pn_pepais in number,pn_petdoc in number, pc_pendoc in varchar2) return varchar2
is
lc_ncl varchar2(100);
begin
  begin
    select c.penom
      into lc_ncl
      from  fsd001 c
     where c.pepais = pn_pepais
       and c.petdoc = pn_petdoc
       and c.pendoc = pc_pendoc;
  exception
      when others then
         lc_ncl := null;
  end;
   return lc_ncl;
end fn_ncl;

function fn_morg (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                        pn_pap in number, pn_cta in number, pn_oper in number,
                        pn_sbop in number,pn_top in number, pn_aoimp in number,
                        pn_tipcam in number, pn_salcap in number ) return number is
ln_numcuo number;
ln_mtodes number;
begin
  begin
    if pn_mod = 108 then
       ln_numcuo:=pn_aoimp;
    else

        select m.xllcapital
          into ln_numcuo
          from  X054023 m
         where m.xllpgcod  = pn_emp
           and m.xllaocta  = pn_cta
           and m.xllaooper = pn_oper
           and m.xllaosbop = pn_sbop
           and m.xllaotop  = pn_top
           and m.xllaomod  = pn_mod
           and m.xllaosuc  = pn_suc
           and m.xllaomda  = pn_mda
           and m.xllaopap  = pn_pap;
     end if;
  exception
      when no_data_found then
        begin
         select m.xllcapital
          into ln_numcuo
          from  X054023 m
         where m.xllpgcod  = pn_emp
           and m.xllaocta  = pn_cta
           and m.xllaooper = pn_oper
           and m.xllaosuc  = pn_suc
           and m.xllaomda  = pn_mda
           and m.xllaopap  = pn_pap
           and rownum = 1;
        exception
          when no_data_found then
               begin
                   select m.xllcapital
                    into ln_numcuo
                    from  X054023 m
                   where m.xllpgcod  = pn_emp
                     and m.xllaocta  = pn_cta
                     and m.xllaooper = pn_oper
                     and m.xllaomda  = pn_mda
                     and m.xllaopap  = pn_pap
                     and rownum = 1;
               exception
                 when others then
                    ln_numcuo := null;
               end;
          when others then
             ln_numcuo := null;
        end;
      when too_many_rows then
         ln_numcuo := null;
  end;
  if pn_salcap > ln_numcuo and pn_mod not in (116,108) then
      begin
          select abs(sum(pp1cap))
            into ln_mtodes
           from   fsd602
            where PGCOD	= pn_emp
              and PPMOD	= pn_mod
              and PPSUC	= pn_suc
              and PPMDA	= pn_mda
              and PPPAP	= pn_pap
              and PPCTA	= pn_cta
              and PPOPER= pn_oper
              and PPSBOP= pn_sbop
              and PPTOPE= pn_top
              and D602CO=	'S'
              and pp1cap < 0;
       exception
         when others then
            ln_mtodes:=0;
       end ;
       if nvl(ln_mtodes,0) <> 0 then
          ln_numcuo := pn_aoimp + ln_mtodes;
       end if;
   end if;
   if pn_mda = 101 then
      ln_numcuo := round(ln_numcuo * pn_tipcam,2);
   end if;
   return ln_numcuo;
end fn_morg;

function fn_cal (pn_emp in number, pn_cta in number, pd_feccat in date, pn_codcat in number ) return varchar2 is
lc_categoria varchar2(20);
begin
  if pn_codcat = 9 then
    begin
      select substr(l.catcateg,1,1)
        into lc_categoria
        from  fsd212 l
       where l.pgcod     = pn_emp
         and l.catcta    = pn_cta
         and l.catfchdes = pd_feccat
         and l.catcod    = 5;
     exception
       when no_data_found then
          begin
            select substr(l.catcateg,1,1)
              into lc_categoria
              from  fsd212 l
             where l.pgcod     = pn_emp
               and l.catcta    = pn_cta
               and l.catfchdes = pd_feccat
               and l.catcod    = pn_codcat;
          exception
              when no_data_found then
                 lc_categoria := null;
              when too_many_rows then
                 lc_categoria := null;
          end;
     end;
   else
      begin
        select substr(l.catcateg,1,1)
          into lc_categoria
          from  fsd212 l
         where l.pgcod     = pn_emp
           and l.catcta    = pn_cta
           and l.catfchdes = pd_feccat
           and l.catcod    = pn_codcat;
      exception
          when no_data_found then
             lc_categoria := null;
          when too_many_rows then
             lc_categoria := null;
      end;
   end if ;
   return lc_categoria;
end fn_cal;



Procedure sp_job_procesa_datos (pd_fecpro in varchar2 ) is
--  ln_max number;
--  ln_inc number;
  ln_ini number;
--  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
--  lc_hostname varchar2(64);
  cursor sucursal is
  select sucurs from  fst001 where pgcod =1 ;
  begin
     /*begin
         select host_name
           into lc_hostname
           from  v$instance;
     end;*/
--     lc_hostname := 'SC01ZDBADM010101';

     execute immediate ('truncate table  JAQL120 ');
     execute immediate ('alter session set parallel_force_local=TRUE');--jflor 2014.01.16
     delete  tab_jobs  where  c_Codage = 'SBS';
     commit;
     for i in sucursal loop
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_sbs.sp_procesa_datos('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
        --if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
        if sys.fn_bd_IsRAC='TRUE' then
            --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
            DBMS_JOB.SUBMIT(job => ln_job,
                          what => lc_variable,
                          next_date => sysdate+1/(24*180),
                          interval => null,
                          no_parse => false,
                          instance => 2,
                          force => false
                          );
            INSERT INTO  tab_jobs  (c_Codage,n_Numer1,c_detjob)
            VALUES('SBS',ln_ini,lc_variable);
            COMMIT;
        else
            DBMS_JOB.SUBMIT(job => ln_job,
                          what => lc_variable,
                          next_date => sysdate+1/(24*180),
                          interval => null,
                          no_parse => false,
                          force => false
                          );
            INSERT INTO  tab_jobs  (c_Codage,n_Numer1,c_detjob)
            VALUES('SBS',ln_ini,lc_variable);
            COMMIT;
        end if;
      end loop;
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'DATOSBS',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

  end;
Procedure sp_procesa_datos (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecpro date ;
lc_coderr varchar2(300);
ln_tipcam number;
ld_fecini date;
cursor rubro is
select /*+parallel(fsd014,2)*/rubro --15.03.2015
 from  fsd014
where pcnivc in (select modulo from  fst111 where dscod = 50 and modulo not in (29, 33, 120/*, 144*/) union all select 117 from dual
                  union all select 141 from dual)
  and pcimpu = 'S'
  and substr(rubro,1,1) <> 9  ;

begin
execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
  update  tab_jobs  g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'SBS';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');
  ld_fecini := ld_fecpro - (to_number(to_char(ld_fecpro,'DD')) - 1);
   begin
       select cotcbi
         into ln_tipcam
         from  fsh005
        where cofdes  = ld_fecpro
          and moneda = 101;
   exception
      when others then
        begin
          select cotcbi
            into ln_tipcam
            from  fsh005
           where cofdes between ld_fecini and ld_fecpro
             and moneda = 101
             and rownum = 1
           order by  cofdes desc;
        exception
           when others then
              ln_tipcam := 2.844;
        end;
   end;
  for i in rubro loop
     begin
       insert into  JAQL120  (ccl,csbs,tid,nid,ncl,
                            ccr,mon,morg,cal,calint,
                            kvi,ccvi,kre,ccre,krf,
                            ccrf,kve,ccve,kju,ccju,
                            kco,ccco,fcc,fveg,tpr,
                            cage,csec,tea,D_FECPRO,
                            bcmod,bcemp,bcpap,bccta,
                            bcsbop,bctop,BCPROD,n_instan,bcrubr,AOTMOR )
       select/*+all_rows parallel(sal,2,1)*/
             to_char(cta.pepais) || to_char(cta.petdoc)||cta.pendoc ,--ccl
             pq_datos_sbs.fn_csbs ( cta.pepais, cta.petdoc, cta.pendoc,ld_fecpro),--csbs
             /*case when cta.petdoc = 21 then 1
                  when cta.petdoc = 9 then 6
                  when cta.petdoc = 5 then 5
                  else 0 end*/
             pq_datos_sbs.fn_tipdoc_sbs(cta.petdoc), --tid
             cta.pendoc, --nid
             pq_datos_sbs.fn_ncl ( cta.pepais, cta.petdoc, cta.pendoc),--ncl
             sal.bcoper, --ccr
             sal.bcmda, --mon
             pq_datos_sbs.fn_morg(sal.bcemp , sal.bcmod , sal.bcsuc , sal.bcmda ,
                                  sal.bcpap , sal.bccta , sal.bcoper, sal.bcsbop,
                                  sal.bctop , pro.aoimp, ln_tipcam, abs(sal.bcsdmo) ), -- morg
             --skcr
             -- tcr
             substr(sal.bccate,1,1), --cal
             pq_datos_sbs.fn_cal(sal.bcemp, sal.bccta, sal.bcfech,9),-- calint
             --dak,
             --dakr
             --dapr
             --pci
             Case when substr(sal.bcrubr,1,4) in ('1411','1421') then abs(sal.bcsdmn)
                  else 0 end,--kvi
             Case when substr(sal.bcrubr,1,4) in ('1411','1421') then substr(sal.bcrubr,1,10)
                  else '0' end ,--ccvi
             Case when substr(sal.bcrubr,1,4) in ('1413','1423') then abs(sal.bcsdmn)
                  else 0 end,--kre
             Case when substr(sal.bcrubr,1,4) in ('1413','1423') then substr(sal.bcrubr,1,10)
                  else '0' end ,--ccre
             Case when substr(sal.bcrubr,1,4) in ('1414','1424') then abs(sal.bcsdmn)
                  else 0 end,--krf
             Case when substr(sal.bcrubr,1,4) in ('1414','1424') then substr(sal.bcrubr,1,10)
                  else '0' end ,--ccrf
             Case when substr(sal.bcrubr,1,4) in ('1415','1425') then abs(sal.bcsdmn)
                  else 0 end,--kve
             Case when substr(sal.bcrubr,1,4) in ('1415','1425') then substr(sal.bcrubr,1,10)
                  else '0' end ,--ccve
             Case when substr(sal.bcrubr,1,4) in ('1416','1426') then abs(sal.bcsdmn)
                  else 0 end,--kju
             Case when substr(sal.bcrubr,1,4) in ('1416','1426') then substr(sal.bcrubr,1,10)
                  else '0' end ,--ccju
             Case when substr(sal.bcrubr,1,4) in ('7112','7122') then abs(sal.bcsdmn)
                  else 0 end,--kco
             Case when substr(sal.bcrubr,1,4) in ('7112','7122') then substr(sal.bcrubr,1,10)
                  else '0' end ,--ccco
             case when sal.bcmod = 141 then 3 else 0 end,--fcc 50%
             --sin
             --csin
             --sid
             --ccsid,
             --sis
             --ccsis
             --fot
             --esam
             --Dgr
             --fppk
             sal.bcfvto,--fveg
             --fvep
             --pcuo
             --ncpr
             --ncpa
             --ciiu
             modu.mdnom,--tpr
             --rfa
             sal.bcsuc,--cage
              fn_analista_credito(sal.bcmod,sal.bcsuc,sal.bcmda,
             sal.bcpap,sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop), --csec
             pro.aotasa, --tea
             --mdcr
             --nrprg
             --fultrprg
             --indic
             /*case when sal.bcmod = 116 then 0
                  when sal.bcmod = 117 then sal.bcsdmn
                  else 0 end,*/ --lco
             /*case when sal.bcmod = 116 then 0
                  when sal.bcmod = 117 then 1
                  else 0 end,*/ --lcnu
            /* case when sal.bcmod = 116 then 0
                  when sal.bcmod = 117 then 1
                  else 0 end*/ --cclcnu
             --tcrint
             ld_fecpro,
             sal.bcmod,
             sal.bcemp,
             sal.bcpap,
             sal.bccta,
             sal.bcsbop,
             sal.bctop,
             sal.bcprod,
             fn_instancia_credito(sal.bcmod,sal.bcsuc,sal.bcmda,sal.bcpap, sal.bccta,
                                  sal.bcoper,sal.bcsbop,sal.bctop),
             sal.bcrubr,
             PRO.AOTMOR
        from   fsh012 sal,   fsr008 cta,   fsd010 pro,
               fst004 top,   fst003 modu
       where sal.bcemp = 1
         and sal.bcsuc = pn_numsuc
         and sal.bcfech = ld_fecpro
         and sal.bcrubr = i.rubro
         and sal.bcemp  = pro.pgcod (+)
         and sal.bcsuc  = pro.aosuc (+)
         and sal.bcmda  = pro.aomda (+)
         and sal.bcpap  = pro.aopap (+)
         and sal.bccta  = pro.aocta (+)
         and sal.bcoper = pro.aooper (+)
         and sal.bcsbop = pro.aosbop (+)
         and sal.bctop  = pro.aotope (+)
         and sal.bcmod  = pro.aomod (+)
         and sal.bcmod  = top.modulo
         and sal.bctop  = top.totope
         and sal.bcmod  = modu.modulo
         and top.modulo = modu.modulo
         and sal.bccta  = cta.ctnro (+)
         and cta.pgcod (+) = 1
         and cta.cttfir (+) = 'T';
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,' JAQL120 ',i.rubro||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;
     commit;
  end loop;
  commit;
  update  tab_jobs  g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'SBS';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update  tab_jobs  g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'SBS';
    commit;
    return;

end sp_procesa_datos;
function fn_Saldo_relacion(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                           pn_pap in number, pn_cta in number, pn_oper in number,
                           pn_sbop in number,pn_top in number, pd_fecpro in date, pn_nrorel in number,
                           pn_rubro in number) return number is
ln_saldo number;
begin
  begin
   select sum(s.bcsdmn)
     into ln_saldo
     from  fsr014 r,  fsh012 s
    where s.bcemp = pn_emp
      and s.bcsuc = pn_suc
      and r.rubro in ( select rubro
                         from  fsd014
                        where /*pcnivc in (select modulo
                                           from  fst111 where dscod = 50
                                            and modulo not in (29, 33, 120, 144)
                                         union all select 117 from dual   )*/
                              rubro =  pn_rubro
                          and pcimpu = 'S'
                          and substr(rubro,1,1) <> 9 )
      and r.rrrubr= s.bcrubr
      and r.rrcod = pn_nrorel
      and s.bcmda = pn_mda
      and s.bcpap = pn_pap
      and s.bccta = pn_cta
      and s.bcoper= pn_oper
      and s.bcsbop= pn_sbop
      --and s.bcmod = pn_mod
      --and s.bctop = pn_top
      and s.bcfech= pd_fecpro;
  exception
      when others then
         ln_saldo := 0;
  end;
   return nvl(ln_saldo,0);
end fn_Saldo_relacion;

function fn_Saldo_relacion2(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                           pn_pap in number, pn_cta in number, pn_oper in number,
                           pn_sbop in number,pn_top in number, pd_fecpro in date, pn_nrorel in number,
                           pn_rubro in number) return number is
ln_saldo number;
begin
  begin
   select /*+ parallel(r,2)*/--15.03.2015
          sum(s.bcsdmn)
     into ln_saldo
     from  fsr014 r,  fsh012 s
    where s.bcemp = pn_emp
      and s.bcsuc = pn_suc
      and r.rubro in ( --select /*+all_rows index_rs_asc(migra2. JAQL120  XN_OPERACION)*/ bcrubr
                            select bcrubr
                             from jaql120
                            where bcemp  = pn_emp
                              and cage   = pn_suc
                              and bcmod  = pn_mod
                              and mon    = pn_mda
                              and bcpap  = pn_pap
                              and bccta  = pn_cta
                              and ccr    = pn_oper
                              and bcsbop = pn_sbop
                              and bctop  = pn_top )
      and r.rrrubr= s.bcrubr
      and r.rrcod = pn_nrorel
      and s.bcmda = pn_mda
      and s.bcpap = pn_pap
      and s.bccta = pn_cta
      and s.bcoper= pn_oper
      and s.bcsbop= pn_sbop
      --and s.bcmod = pn_mod
      --and s.bctop = pn_top
      and s.bcfech= pd_fecpro;
  exception
      when others then
         ln_saldo := 0;
  end;
   return nvl(ln_saldo,0);
end fn_Saldo_relacion2;

function fn_Saldo_relacion3(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                           pn_pap in number, pn_cta in number, pn_oper in number,
                           pn_sbop in number,pn_top in number, pd_fecpro in date, pn_nrorel in number,
                           pn_rubro in varchar2 ) return number is
ln_saldo number:=0;
ln_cuenta number :=0;
begin

  begin

   select sum(bcsdmn), count(*)
     into ln_saldo, ln_cuenta
      from (
      select --/*+ index( fsh012 fsh1204) */ --15.03.2015
            --/*+parallel(r,2) */ --12.05.2015
            distinct  s.bcsdmn, s.bcrubr
                 from  fsr014 r,  fsh012 s
                where s.bcemp = pn_emp
                  and s.bcsuc = pn_suc
                  and r.rrrubr= s.bcrubr
                  and r.rrcod = pn_nrorel
                  and r.rrrubr like pn_rubro
                  and s.bcrubr like pn_rubro
      --            and s.bcrubr like '29_1%'
                  and s.bcmda = pn_mda
                  and s.bcpap = pn_pap
                  and s.bccta = pn_cta
                  and s.bcoper= pn_oper
                  and s.bcsbop= pn_sbop
                  and s.bcfech=  pd_fecpro);
  exception
      when others then
         ln_saldo := 0;
  end;
  /*if ln_cuenta > 1 then
      insert into  JAQL121  ( CCR,MON,CCRE,CAGE,BCMOD,BCEMP,BCPAP,BCCTA,BCSBOP,BCTOP,BCRUBR)
      values(pn_oper,pn_mda,pn_oper,pn_suc,pn_mod,pn_emp,pn_pap,pn_cta,pn_sbop,pn_top,pn_rubro);
      commit;
  end if;*/
   return nvl(ln_saldo,0);
end fn_Saldo_relacion3;
function fn_Saldo_relacion4(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                           pn_pap in number, pn_cta in number, pn_oper in number,
                           pn_sbop in number,pn_top in number, pd_fecpro in date, pn_nrorel in number,
                           pn_rubro in varchar2 ) return number is
ln_saldo number:=0;
ln_cuenta number :=0;
begin

  begin

   select sum(bcsdmn), count(*)
     into ln_saldo, ln_cuenta
      from (
      select --/*+ index( fsh012 fsh1204) */ --15.03.2015
            /*+parallel(r,2) */ distinct  s.bcsdmn, s.bcrubr
                 from  fsr014 r,  fsh012 s
                where s.bcemp = pn_emp
                  and s.bcsuc = pn_suc
                  and r.rrrubr= s.bcrubr
                  and r.rrcod = pn_nrorel
                  and r.rrrubr like pn_rubro
                  and s.bcrubr like pn_rubro
      --            and s.bcrubr like '29_1%'
                  and s.bcmda = pn_mda
                  and s.bcpap = pn_pap
                  and s.bccta = pn_cta
                  and s.bcoper= pn_oper
                  and s.bcsbop= pn_sbop
                  and s.bcfech=  pd_fecpro);
  exception
      when others then
         ln_saldo := 0;
  end;

   return nvl(ln_saldo,0);
end fn_Saldo_relacion4;


function fn_tcr(pn_rubro in number) return varchar2 is
lc_tcr varchar2(2);
begin
  begin
    select lpad(b.incol,2,'0')
      into lc_tcr
      from  fsi006 a,  fsi003 b
     where a.cicpo like 'ANEXO6%'
       and a.rubro = pn_rubro
       and a.cicpo = b.cicpo
       and b.pgcod = 1
       and b.inprg = 'ANEXO6';
   exception
    when others then
        lc_tcr := null;
   end;
   return lc_tcr;
end ;
function fn_skcr(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                 pn_pap in number, pn_cta in number, pn_oper in number,
                 pn_sbop in number,pn_top in number, pd_fecpro in date ) return number is
ln_saldo number;
ln_rubro number;
begin
  ln_rubro := 0;
  /*if pn_mod = 117 then
     ln_saldo := 0;
  else */
    begin
       select sum(s.bcsdmn)
         into ln_saldo
         from  fsh012 s
        where s.bcemp = pn_emp
          and s.bcsuc = pn_suc
          and s.bcmda = pn_mda
          and s.bcpap = pn_pap
          and s.bccta = pn_cta
          and s.bcoper= pn_oper
          and s.bcsbop= pn_sbop
          and s.bcmod = pn_mod
          and s.bctop = pn_top
          and s.bcfech= pd_fecpro
          and s.bcrubr in (--select /*+all_rows index_rs_asc(migra2. JAQL120  XN_OPERACION)*/ bcrubr
              select bcrubr
                             from jaql120
                            where s.bcemp  = pn_emp
                              and cage   = pn_suc
                              and bcmod  = pn_mod
                              and mon    = pn_mda
                              and bcpap  = pn_pap
                              and bccta  = pn_cta
                              and ccr    = pn_oper
                              and bcsbop = pn_sbop
                              and bctop  = pn_top
                               );
    exception
      when no_data_found then
           begin
             select sum(s.bcsdmn)
               into ln_saldo
               from  fsh012 s
              where s.bcemp = pn_emp
                and s.bcsuc = pn_suc
                and s.bcmda = pn_mda
                and s.bcpap = pn_pap
                and s.bccta = pn_cta
                and s.bcoper= pn_oper
                and s.bcsbop= pn_sbop
                and s.bcmod = pn_mod
                and s.bctop = pn_top
                and s.bcfech= pd_fecpro
                and s.bcrubr in (select rubro
                                   from  fsd014
                                  where pcnivc in (select modulo from  fst111 where dscod = 50 and modulo not in (29, 33, 120, 144) /*union all select 117 from dual*/ union all select 141 from dual)
                                    and pcimpu = 'S'
                                    and substr(rubro,1,1) <> 9 );
            exception
                when others then
                   ln_saldo := 0;
            end;
       when others then
           ln_saldo := 0;
     end;
   --end if;
   return abs(ln_saldo);
end fn_skcr;

function  fn_dapr(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                  pn_pap in number, pn_cta in number, pn_oper in number,
                  pn_sbop in number,pn_top in number, pd_fecpro in date) return number is

ln_prodia number;
Begin
   ln_prodia := 0;
   Begin
--08/2018
     select  round(avg(case when nvl(d602.pp1fech,pd_fecpro/*trunc(sysdate)*/) - d601.ppfpag < 0 then 0
                           else nvl(d602.pp1fech,pd_fecpro/*trunc(sysdate)*/) - d601.ppfpag end))
       into ln_prodia
       from  fsd602 d602,  fsd601 d601
      where d602.pgcod (+)   = d601.pgcod
        and d602.ppmod (+)   = d601.ppmod
        and d602.ppsuc (+)   = d601.ppsuc
        and d602.ppmda (+)   = d601.ppmda
        and d602.pppap (+)   = d601.pppap
        and d602.ppcta (+)   = d601.ppcta
        and d602.ppoper (+)  = d601.ppoper
        and d602.ppsbop (+)  = d601.ppsbop
        and d602.pptope  (+) = d601.pptope
        and d602.ppfpag (+)  = d601.ppfpag
        and d602.pp1fech (+) <= pd_fecpro
        and d601.ppfpag between add_months(pd_fecpro, -6) and pd_fecpro  -- add_months(trunc(sysdate),-6) and trunc(sysdate)
        and d602.pp1stat (+) = 'T'
        and d602.d602co  (+) = 'S'
        and d601.ppcap + d601.ppint <> 0 --08/2018
        and d601.pgcod    = pn_emp
        and d601.ppmod    = pn_mod
        and d601.ppsuc    = pn_suc
        and d601.ppmda    = pn_mda
        and d601.pppap    = pn_pap
        and d601.ppcta    = pn_cta
        and d601.ppoper   = pn_oper
        and d601.ppsbop   = pn_sbop
        and d601.pptope   = pn_top;
    exception
      when others then
           ln_prodia := 0;
    end;
    return nvl(ln_prodia,0);
end;


procedure sp_cta_saldo_relacion(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                               pn_pap in number, pn_cta in number, pn_oper in number,
                               pn_sbop in number,pn_top in number, pd_fecpro in date, pn_nrorel in number,
                               pc_rubro in varchar2, pn_saldo out number, pn_rubro out number) is
ln_saldo number;
ln_rubro1 number;
ln_rubro number;
lc_error varchar2(300);
begin
  ln_rubro1 :=0;
  begin
       select distinct s.bcsdmn, s.bcrubr
           into ln_saldo, ln_rubro
           from  fsr014 r,  fsh012 s
          where s.bcemp = pn_emp
            and s.bcsuc = pn_suc
            and r.rubro in(select /*+all_rows index_rs_asc(migra2. JAQL120  XN_OPERACION)*/ bcrubr
                             from jaql120
                            where bcemp  = pn_emp
                              and cage   = pn_suc
                              and bcmod  = pn_mod
                              and mon    = pn_mda
                              and bcpap  = pn_pap
                              and bccta  = pn_cta
                              and ccr    = pn_oper
                              and bcsbop = pn_sbop
                              and bctop  = pn_top)
            and r.rrrubr= s.bcrubr
            and r.rrcod = pn_nrorel
            and s.bcrubr like pc_rubro
            and s.bcmda = pn_mda
            and s.bcpap = pn_pap
            and s.bccta = pn_cta
            and s.bcoper= pn_oper
            and s.bcsbop= pn_sbop
            --and s.bcmod = pn_mod
            --and s.bctop = pn_top
            and s.bcfech= pd_fecpro;
  exception
     when no_data_found then
        begin
--         select /*+ index( fsh012 fsh1204) */ distinct s.bcsdmn, s.bcrubr--15.03.2015
         /*select distinct s.bcsdmn, s.bcrubr
           into ln_saldo, ln_rubro
           from  fsr014 r,  fsh012 s
          where s.bcemp = pn_emp
            and s.bcsuc = pn_suc
            and r.rubro in ( --select \*+ALL_ROWS*\ rubro
                             select \*+parallel(fsd014,2)*\ rubro
                               from  fsd014
                              where pcnivc in (select \*+index_ss(fst111)*\ modulo
                                                 from  fst111 where dscod = 50
                                                  and modulo not in (29, 33, 120, 144)
                                                union all select 117 from dual
                                                union all select 141 from dual   )
                                and pcimpu = 'S'
                                and substr(rubro,1,1) <> 9
                                \*and rubro like pc_rubro*\ )
            and r.rrrubr= s.bcrubr
            and r.rrcod = pn_nrorel
            and s.bcrubr like pc_rubro
            and s.bcmda = pn_mda
            and s.bcpap = pn_pap
            and s.bccta = pn_cta
            and s.bcoper= pn_oper
            and s.bcsbop= pn_sbop
            --and s.bcmod = pn_mod
            --and s.bctop = pn_top
            and s.bcfech= pd_fecpro;*/
         --12.05.2015
         select distinct s.bcsdmn, s.bcrubr
           into ln_saldo, ln_rubro
           from  fsr014 r,  fsh012 s,
                             (select rubro
                               from   fsd014
                              where pcnivc in (select modulo
                                                 from   fst111 where dscod = 50
                                                  and modulo not in (29, 33, 120, 144)
                                                union all select 117 from dual
                                                union all select 141 from dual   )
                                and pcimpu = 'S'
                                and substr(rubro,1,1) <> 9
                                GROUP BY FSD014.RUBRO) f
          where s.bcemp = pn_emp
            and s.bcsuc = pn_suc
            and r.rubro = f.rubro
            and r.rrrubr= s.bcrubr
            and r.rrcod = pn_nrorel
            and s.bcrubr like pc_rubro
            and s.bcmda = pn_mda
            and s.bcpap = pn_pap
            and s.bccta = pn_cta
            and s.bcoper= pn_oper
            and s.bcsbop= pn_sbop
            --and s.bcmod = pn_mod
            --and s.bctop = pn_top
            and s.bcfech= pd_fecpro;

        exception
            when no_data_found then
                 begin
                     select distinct s.bcsdmn, s.bcrubr
                         into ln_saldo, ln_rubro
                         from  fsr014 r,  fsh012 s
                        where s.bcemp = pn_emp
                          and s.bcsuc = pn_suc
                          and r.rubro in(select /*+all_rows index_rs_asc(migra2. JAQL120  XN_OPERACION)*/ bcrubr
                                           from jaql120
                                          where bcemp  = pn_emp
                                            and cage   = pn_suc
                                            and bcmod  = pn_mod
                                            and mon    = pn_mda
                                            and bcpap  = pn_pap
                                            and bccta  = pn_cta
                                            and ccr    = pn_oper
                                            and bcsbop = pn_sbop
                                            and bctop  = pn_top)
                          and r.rrrubr= s.bcrubr
                          and r.rrcod = pn_nrorel
                          and s.bcmda = pn_mda
                          and s.bcpap = pn_pap
                          and s.bccta = pn_cta
                          and s.bcoper= pn_oper
                          and s.bcsbop= pn_sbop
                          --and s.bcmod = pn_mod
                          --and s.bctop = pn_top
                          and s.bcfech= pd_fecpro;
                 exception
                    when others then
                       --lc_error := sqlerrm;
                       ln_saldo := null;
                       ln_rubro := null;
                 end;
            when others then
               --lc_error := sqlerrm;
               ln_saldo := null;
               ln_rubro := null;
        end;
     when others then
          --lc_error := sqlerrm;
          ln_saldo := null;
          ln_rubro := null;
   end;
  pn_saldo := nvl(ln_saldo,0);
  pn_rubro := ln_rubro;
end;

procedure sp_cta_saldo_relacion2(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                               pn_pap in number, pn_cta in number, pn_oper in number,
                               pn_sbop in number,pn_top in number, pd_fecpro in date, pn_nrorel in number,
                               pc_rubro in varchar2, pn_saldo out number, pn_rubro out number) is
ln_saldo number;
ln_rubro1 number;
ln_rubro number;
lc_error varchar2(300);
ln_cuenta number:=0;
begin
  ln_rubro1 :=0;
  begin
       select sum(bcsdmn), max(bcrubr), count(*)
         into ln_saldo, ln_rubro, ln_cuenta
         from (--select /*+ index( fsh012 fsh1204) */
                select /*+ parallel(r,2)  */ --15.03.2015
                      distinct  s.bcsdmn, s.bcrubr
                 from  fsr014 r,  fsh012 s
                where s.bcemp = pn_emp
                  and s.bcsuc = pn_suc
                  and r.rrrubr= s.bcrubr
                  and r.rrcod = pn_nrorel
                  and r.rrrubr like pc_rubro
                  and s.bcrubr like pc_rubro
                  and s.bcmda = pn_mda
                  and s.bcpap = pn_pap
                  and s.bccta = pn_cta
                  and s.bcoper= pn_oper
                  --and s.bcsbop= pn_sbop
                  and s.bcfech=  pd_fecpro);
  exception
     when others then
          --lc_error := sqlerrm;
          ln_saldo := null;
          ln_rubro := null;
  end;
  if ln_cuenta > 1 then
      insert into  JAQL121  ( CCR,MON,CCRE,CAGE,BCMOD,BCEMP,BCPAP,BCCTA,BCSBOP,BCTOP,BCRUBR)
      values(pn_oper,pn_mda,pn_oper,pn_suc,pn_mod,pn_emp,pn_pap,pn_cta,pn_sbop,pn_top,pc_rubro);
      commit;
  end if;

  pn_saldo := nvl(ln_saldo,0);
  pn_rubro := ln_rubro;
end;

function  fn_fot(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                  pn_pap in number, pn_cta in number, pn_oper in number,
                  pn_sbop in number,pn_top in number, pn_nrpg in number) return date is

ld_fecdes date;
Begin
   ld_fecdes := null;
   --- Se agrego para reprogramados 
   if pn_nrpg > 0 then
      begin
           select x.xllfvalor
              into ld_fecdes
              from  X054023 x
             where x.xllpgcod  = pn_emp
               and x.xllaomod  = pn_mod
               and x.xllaosuc  = pn_suc
               and x.xllaomda  = pn_mda
               and x.xllaopap  = pn_pap
               and x.xllaocta  = pn_cta
               and x.xllaooper = pn_oper
               and x.xllaosbop = 0
               and x.xllaotop  = pn_top;
      exception
        when others then
            begin 
                  select x.xllfvalor
                    into ld_fecdes
                    from  X054023 x
                   where x.xllpgcod  = pn_emp
                     and x.xllaomod  = pn_mod
                     and x.xllaomda  = pn_mda
                     and x.xllaopap  = pn_pap
                     and x.xllaocta  = pn_cta
                     and x.xllaooper = pn_oper
                     and x.xllaosbop = 0;
            exception 
              when others then
                ld_fecdes := null;
            end;   
      end; 
   ---------------------------------------       
   else 
       if  pn_mod not in (117,200) or ( pn_mod <> 200 and  pn_top not in (550) and pn_mod <> 117) then
           Begin
            select a.aofval
              into ld_fecdes
              from  fsd010 a
             where a.pgcod    = pn_emp
               and a.aomod    = pn_mod
               and a.aosuc    = pn_suc
               and a.aomda    = pn_mda
               and a.aopap    = pn_pap
               and a.aocta    = pn_cta
               and a.aooper   = pn_oper
               and a.aosbop   = pn_sbop
               and a.aotope   = pn_top;
           exception
              when others then
                   Begin
                      select a.aofval
                        into ld_fecdes
                        from  fsd010 a
                       where a.pgcod    = pn_emp
                         and a.aomod    = pn_mod
                         --and a.aosuc    = pn_suc
                         and a.aomda    = pn_mda
                         and a.aopap    = pn_pap
                         and a.aocta    = pn_cta
                         and a.aooper   = pn_oper
                         and a.aosbop   = pn_sbop
                         and a.aotope   = pn_top;
                     exception
                        when others then
                             ld_fecdes := null;
                     end;
           end;
        elsif pn_mod in (117)  then
           begin
             select min(b.aofval)
               into ld_fecdes
               from  fsr011 a,  fsd010 b
              where a.relcod = 46
                and a.R2MOD	 = pn_mod
                and a.R2CTA  = pn_cta
                --and a.R2OPER = to_number(substr(pn_oper,6,10))
                and a.R2OPER = pn_oper
                and a.R2SBOP = pn_sbop
                and a.R2COD	 = pn_emp
                --and a.R2SUC	 = pn_suc
                and a.R2MDA	 = pn_mda
                and a.R2PAP	 = pn_pap
                and a.R2TOPE = pn_top
                and a.R011CO = 'S'
                and a.R1COD	 = b.pgcod
                and a.R1MOD	= b.aomod
                and a.R1SUC	= b.aosuc
                and a.R1MDA	= b.aomda
                and a.R1PAP	= b.aopap
                and a.R1CTA	= b.aocta
                and a.R1OPER= b.aooper
                and a.R1SBOP= b.aosbop
                and a.R1TOPE= b.aotope;
                if ld_fecdes is null then
                   begin
                       select min(b.aofval)
                         into ld_fecdes
                         from  fsr011 a,  fsd010 b
                        where a.relcod = 46
                          and a.R2MOD	 = pn_mod
                          and a.R2CTA  = pn_cta
                          and a.R2OPER = to_number(substr(pn_oper,6,10))
                          and a.R2SBOP = pn_sbop
                          and a.R2COD	 = pn_emp
                          and a.R2MDA	 = pn_mda
                          and a.R2PAP	 = pn_pap
                          and a.R2TOPE = pn_top
                          and a.R011CO = 'S'
                          and a.R1COD	 = b.pgcod
                          and a.R1MOD	= b.aomod
                          and a.R1SUC	= b.aosuc
                          and a.R1MDA	= b.aomda
                          and a.R1PAP	= b.aopap
                          and a.R1CTA	= b.aocta
                          and a.R1OPER= b.aooper
                          and a.R1SBOP= b.aosbop
                          and a.R1TOPE= b.aotope;
                   exception
                     when others then
                        ld_fecdes := null;
                   end;
                end if;
           exception
             when others then
                ld_fecdes := null;
           end;
           -- agregar
           if ld_fecdes is null then
             begin
               select min(a.aofval)
                        into ld_fecdes
                        from  fsd010 a
                       where a.pgcod    = pn_emp
                         and a.aomod    = pn_mod
                         --and a.aosuc    = pn_suc
                         and a.aomda    = pn_mda
                         and a.aopap    = pn_pap
                         and a.aocta    = pn_cta
                         and a.aooper   = pn_oper
                         and a.aosbop   = pn_sbop
                         and a.aotope   = pn_top;
              exception
                when others then
                   ld_fecdes := null;
              end;
           end if;
         elsif pn_mod in (200) or  pn_top  in (550) then
           begin
             select min(b.aofval)
               into ld_fecdes
               from  fsr011 a,   fsd010 b
              where a.relcod = 52
                and a.R2MOD	 = pn_mod
                and a.R2CTA  = pn_cta
                and a.R2OPER = pn_oper
                and a.R2SBOP = pn_sbop
                and a.R2COD	 = pn_emp
                and a.R2SUC	 = pn_suc
                and a.R2MDA	 = pn_mda
                and a.R2PAP	 = pn_pap
                and a.R2TOPE = pn_top
                and a.R011CO = 'S'
                and a.R1COD	 = b.pgcod
                and a.R1MOD	= b.aomod
                and a.R1SUC	= b.aosuc
                and a.R1MDA	= b.aomda
                and a.R1PAP	= b.aopap
                and a.R1CTA	= b.aocta
                and a.R1OPER= b.aooper
                and a.R1SBOP= b.aosbop
                and a.R1TOPE= b.aotope;
           exception
             when others then
                ld_fecdes := null;
           end;
        end if;
    end if;    
    return ld_fecdes;
end;

function  fn_esam(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                  pn_pap in number, pn_cta in number, pn_oper in number,
                  pn_sbop in number,pn_top in number) return number is

ln_esam number;
cursor plan is
 select  STATS_MODE(ppcap + ppint) cuota, count(*) nro_cuotas
   from   fsd601 d601
   where d601.pgcod    = pn_emp
     and d601.ppmod    = pn_mod
     and d601.ppsuc    = pn_suc
     and d601.ppmda    = pn_mda
     and d601.pppap    = pn_pap
     and d601.ppcta    = pn_cta
     and d601.ppoper   = pn_oper
     and d601.ppsbop   = pn_sbop
     and d601.pptope   = pn_top;


Begin
   for i in plan loop
     if i.nro_cuotas = 1 then
        ln_esam := 1;
     else
        ln_esam := 3;
     end if;
     exit;
   end loop;
   return ln_esam;
end;
procedure sp_dgr_pcuo_ncpr(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                 pn_pap in number, pn_cta in number, pn_oper in number,
                 pn_sbop in number,pn_top in number, pn_nrprg in number, pn_diagra out number, pn_period out number, pn_cancuo out number ) is
  ln_diagra number;
  ln_periodo number;
  ln_cancuo number;
  ld_fecal date;
  begin
    if pn_nrprg > 0 then 
       begin 
             select ((select min(n.ppfpag)
                        from  fsd601 n
                       where m.xllaocta  = n.ppcta
                         and m.xllaooper = n.ppoper
                         and m.xllaosbop = n.ppsbop
                         and m.xllaotop  = n.pptope
                         and m.xllaomod  = n.ppmod
                         and m.xllaosuc  = n.ppsuc
                         and m.xllaomda  = n.ppmda
                         and m.xllaopap  = n.pppap
                         AND n.ppcap + n.ppint <> 0)-m.xllfvalor)-m.xllperiodo,m.xllfvalor, m.xllperiodo,
                         nvl(pq_datos_sbs.fn_ncpr(pn_emp,pn_mod, pn_suc,pn_mda,
                                              pn_pap,pn_cta, pn_oper,0, pn_top),m.xllcantcuo)
               into ln_diagra, ld_fecal, ln_periodo, ln_cancuo
               from  X054023 m
              where m.xllpgcod  = pn_emp
                and m.xllaocta  = pn_cta
                and m.xllaooper = pn_oper
                and m.xllaosbop = 0
                and m.xllaotop  = pn_top
                and m.xllaomod  = pn_mod
                and m.xllaosuc  = pn_suc
                and m.xllaomda  = pn_mda
                and m.xllaopap  = pn_pap;
            exception 
               when no_data_found then 
                    select ((select min(n.ppfpag)
                        from  fsd601 n
                       where m.xllaocta  = n.ppcta
                         and m.xllaooper = n.ppoper
                         and m.xllaosbop = n.ppsbop
                         and m.xllaotop  = n.pptope
                         and m.xllaomod  = n.ppmod
                         and m.xllaosuc  = n.ppsuc
                         and m.xllaomda  = n.ppmda
                         and m.xllaopap  = n.pppap
                         AND n.ppcap + n.ppint <> 0)-m.xllfvalor)-m.xllperiodo, m.xllfvalor,m.xllperiodo,
                         nvl(pq_datos_sbs.fn_ncpr(pn_emp,pn_mod, pn_suc,pn_mda,
                                              pn_pap,pn_cta, pn_oper,0, pn_top),m.xllcantcuo)
                     into ln_diagra,ld_fecal, ln_periodo, ln_cancuo
                     from  X054023 m
                    where m.xllpgcod  = pn_emp
                      and m.xllaocta  = pn_cta
                      and m.xllaooper = pn_oper
                      and m.xllaosbop = 0
                      and m.xllaomod <> 117
                      and m.xllaomda  = pn_mda
                      and m.xllaopap  = pn_pap;
               when others then 
                  null;
            end; 
    else 
      begin
        if pn_TOP = 550 or pn_mod in (200,33) then
           ln_diagra:= 0;
           ln_periodo:=0;
           begin
             select ((select min(n.ppfpag)
                      from  fsd601 n
                     where m.xllaocta  = n.ppcta
                       and m.xllaooper = n.ppoper
                       and m.xllaosbop = n.ppsbop
                       and m.xllaotop  = n.pptope
                       and m.xllaomod  = n.ppmod
                       and m.xllaosuc  = n.ppsuc
                       and m.xllaomda  = n.ppmda
                       and m.xllaopap  = n.pppap
                       AND n.ppcap + n.ppint <> 0)-m.xllfvalor)-m.xllperiodo,m.xllfvalor, m.xllperiodo,
                       nvl(pq_datos_sbs.fn_ncpr(pn_emp,pn_mod, pn_suc,pn_mda,
                                            pn_pap,pn_cta, pn_oper,pn_sbop, pn_top),m.xllcantcuo)
               into ln_diagra,ld_fecal, ln_periodo, ln_cancuo
             from  X054023 m
            where m.xllpgcod  = pn_emp
              and m.xllaocta  = pn_cta
              and m.xllaooper = pn_oper
              and m.xllaosbop = 0
              and m.xllaosuc  = pn_suc
              and m.xllaomda  = pn_mda
              and m.xllaopap  = pn_pap;
           exception
             when others then
                  ln_cancuo := 0;
           end;

        else
            begin 
             select ((select min(n.ppfpag)
                        from  fsd601 n
                       where m.xllaocta  = n.ppcta
                         and m.xllaooper = n.ppoper
                         and m.xllaosbop = n.ppsbop
                         and m.xllaotop  = n.pptope
                         and m.xllaomod  = n.ppmod
                         and m.xllaosuc  = n.ppsuc
                         and m.xllaomda  = n.ppmda
                         and m.xllaopap  = n.pppap
                         AND n.ppcap + n.ppint <> 0)-m.xllfvalor)-m.xllperiodo,m.xllfvalor, m.xllperiodo,
                         nvl(pq_datos_sbs.fn_ncpr(pn_emp,pn_mod, pn_suc,pn_mda,
                                              pn_pap,pn_cta, pn_oper,pn_sbop, pn_top),m.xllcantcuo)
               into ln_diagra, ld_Fecal, ln_periodo, ln_cancuo
               from  X054023 m
              where m.xllpgcod  = pn_emp
                and m.xllaocta  = pn_cta
                and m.xllaooper = pn_oper
                and m.xllaosbop = pn_sbop
                and m.xllaotop  = pn_top
                and m.xllaomod  = pn_mod
                and m.xllaosuc  = pn_suc
                and m.xllaomda  = pn_mda
                and m.xllaopap  = pn_pap;
            exception 
               when no_data_found then 
                    select ((select min(n.ppfpag)
                        from  fsd601 n
                       where m.xllaocta  = n.ppcta
                         and m.xllaooper = n.ppoper
                         and m.xllaosbop = n.ppsbop
                         and m.xllaotop  = n.pptope
                         and m.xllaomod  = n.ppmod
                         and m.xllaosuc  = n.ppsuc
                         and m.xllaomda  = n.ppmda
                         and m.xllaopap  = n.pppap
                         AND n.ppcap + n.ppint <> 0)-m.xllfvalor)-m.xllperiodo, m.xllfvalor, m.xllperiodo,
                         nvl(pq_datos_sbs.fn_ncpr(pn_emp,pn_mod, pn_suc,pn_mda,
                                              pn_pap,pn_cta, pn_oper,pn_sbop, pn_top),m.xllcantcuo)
                     into ln_diagra, ld_fecal, ln_periodo, ln_cancuo
                     from  X054023 m
                    where m.xllpgcod  = pn_emp
                      and m.xllaocta  = pn_cta
                      and m.xllaooper = pn_oper
  --                    and m.xllaosbop = pn_sbop
  --                    and m.xllaotop  = pn_top
                        and m.xllaomod <> 117
  --                    and m.xllaosuc  = pn_suc
                      and m.xllaomda  = pn_mda
                      and m.xllaopap  = pn_pap;
               when others then 
                  null;
            end; 
         end if;
         if nvl(ln_cancuo,0)=0 then
         begin
                   select ((select min(n.ppfpag)
                      from  fsd601 n
                     where m.xllaocta  = n.ppcta
                       and m.xllaooper = n.ppoper
                       and m.xllaosbop = n.ppsbop
                       and m.xllaotop  = n.pptope
                       and m.xllaomod  = n.ppmod
                       and m.xllaosuc  = n.ppsuc
                       and m.xllaomda  = n.ppmda
                       and m.xllaopap  = n.pppap
                       AND n.ppcap + n.ppint <> 0 )-m.xllfvalor)-m.xllperiodo,m.xllfvalor, m.xllperiodo,
                       nvl(pq_datos_sbs.fn_ncpr(pn_emp,pn_mod, pn_suc,pn_mda,
                                            pn_pap,pn_cta, pn_oper,pn_sbop, pn_top),m.xllcantcuo)
                     into ln_diagra,ld_fecal, ln_periodo, ln_cancuo
                     from  X054023 m
                    where m.xllpgcod  = pn_emp
                      and m.xllaocta  = pn_cta
                      and m.xllaooper = pn_oper
                      --and m.xllaosbop = pn_sbop
                      --and m.xllaotop  = pn_top
                      and m.xllaomod  <> 117
                      and m.xllaosuc  = pn_suc
                      and m.xllaomda  = pn_mda
                      and m.xllaopap  = pn_pap;
               exception
                 when others then
                     ln_diagra := null;
                     ln_periodo:= 0;
                     ln_cancuo := null;
               end;
           end if;
      exception
          when no_data_found then
               begin
                   select ((select min(n.ppfpag)
                      from  fsd601 n
                     where m.xllaocta  = n.ppcta
                       and m.xllaooper = n.ppoper
                       and m.xllaosbop = n.ppsbop
                       and m.xllaotop  = n.pptope
                       and m.xllaomod  = n.ppmod
                       and m.xllaosuc  = n.ppsuc
                       and m.xllaomda  = n.ppmda
                       and m.xllaopap  = n.pppap
                       AND n.ppcap + n.ppint <> 0)-m.xllfvalor)-m.xllperiodo,m.xllfvalor, m.xllperiodo,
                       nvl(pq_datos_sbs.fn_ncpr(pn_emp,pn_mod, pn_suc,pn_mda,
                                            pn_pap,pn_cta, pn_oper,pn_sbop, pn_top),m.xllcantcuo)
                     into ln_diagra, ld_Fecal, ln_periodo, ln_cancuo
                     from  X054023 m
                    where m.xllpgcod  = pn_emp
                      and m.xllaocta  = pn_cta
                      and m.xllaooper = pn_oper
                      --and m.xllaosbop = pn_sbop
                      --and m.xllaotop  = pn_top
                      and m.xllaomod  <> 117
                      and m.xllaosuc  = pn_suc
                      and m.xllaomda  = pn_mda
                      and m.xllaopap  = pn_pap;
               exception
                 when others then
                     ln_diagra := null;
                     ln_periodo:= 0;
                     ln_cancuo := null;
               end;
          when too_many_rows then
             ln_diagra := 0;
             ln_periodo:= 0;
             ln_cancuo := 0;
          when others then
             ln_diagra := 0;
             ln_periodo:= 0;
             ln_cancuo := 0;
      end;
    end if;
    if ln_diagra < 0 then
       ln_diagra := 0;
    end if;
    if nvl(ln_cancuo,0) = 0 then
      ln_cancuo := pq_datos_sbs.fn_ncpr(pn_emp,pn_mod, pn_suc,pn_mda,
                                          pn_pap,pn_cta, pn_oper,pn_sbop, pn_top);
    end if;
    if pn_mod in (200,117,141) then
       ln_periodo := 0;
    end if;   
    pn_diagra := nvl(ln_diagra,0);
    pn_period := nvl(ln_periodo,0);
    pn_cancuo := nvl(ln_cancuo,0);

  end ;

function fn_fppk (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                  pn_pap in number, pn_cta in number, pn_oper in number,
                  pn_sbop in number,pn_top in number, pn_nrpg in number, pd_fecdes in date ) return date is
ld_fecpxv date;
begin
  if pn_nrpg > 0 then
     begin
          select /*+ parallel(n,2,1)*/
                 min(n.ppfpag)
            into ld_fecpxv
            from  fsd601 n
           where n.pgcod  = pn_emp
             and n.ppcta  = pn_cta
             and n.ppmda  = pn_mda
             and n.ppsuc  = pn_suc
             and n.pppap  = pn_pap
             and n.ppoper = pn_oper
             and n.ppsbop = 0
             and n.pptope = pn_top
             and n.ppmod  = pn_mod
             and n.d601co = 'S'
             and n.ppcap > 0
             ;
        exception
            when no_data_found then
               begin
                  select /*+ parallel(n,2,1)*/
                         min(n.ppfpag)
                    into ld_fecpxv
                    from  fsd601 n
                   where n.pgcod  = pn_emp
                     and n.ppcta  = pn_cta
                     and n.ppmda  = pn_mda
                     and n.pppap  = pn_pap
                     and n.ppoper = pn_oper
                     and n.ppsbop = 0
                     and n.d601co = 'S'
                     and n.ppcap > 0
                     ;
                exception
                    when no_data_found then
                       ld_fecpxv := null;
                    when too_many_rows then
                       ld_fecpxv := null;
                end;
            when too_many_rows then
               ld_fecpxv := null;
        end;
  else 
      if pn_top = 550 then -- recuperacion legal
         begin
        select /*+ parallel(n,2,1)*/
               min(n.ppfpag)
          into ld_fecpxv
          from  fsd601 n
         where n.pgcod  = pn_emp
           and n.ppcta  = pn_cta
           and n.ppmda  = pn_mda
           and n.ppsuc  = pn_suc
           and n.pppap  = pn_pap
           and n.ppoper = pn_oper
           --and n.ppsbop = pn_sbop
           --and n.pptope = pn_top
           and n.ppmod  = pn_mod
           and n.d601co = 'S'
           and n.ppcap > 0
           and n.ppfpag > pd_fecdes
           ;
      exception
          when no_data_found then
             ld_fecpxv := null;
          when too_many_rows then
             ld_fecpxv := null;
      end;
      else
        begin
          select /*+ parallel(n,2,1)*/
                 min(n.ppfpag)
            into ld_fecpxv
            from  fsd601 n
           where n.pgcod  = pn_emp
             and n.ppcta  = pn_cta
             and n.ppmda  = pn_mda
             and n.ppsuc  = pn_suc
             and n.pppap  = pn_pap
             and n.ppoper = pn_oper
             and n.ppsbop = pn_sbop
             and n.pptope = pn_top
             and n.ppmod  = pn_mod
             and n.d601co = 'S'
             and n.ppcap > 0
             ;
        exception
            when no_data_found then
               ld_fecpxv := null;
            when too_many_rows then
               ld_fecpxv := null;
        end;
      end if;
      if ld_fecpxv is null then
         begin
            select /*+ parallel(n,2,1)*/
                   min(n.ppfpag)
              into ld_fecpxv
              from  fsd601 n
             where n.pgcod  = pn_emp
               and n.ppcta  = pn_cta
               and n.ppmda  = pn_mda
               and n.pppap  = pn_pap
               and n.ppoper = pn_oper
               and n.d601co = 'S'
               and n.ppcap > 0
               and n.ppfpag > pd_fecdes
               ;
          exception
              when no_data_found then
                 ld_fecpxv := null;
              when too_many_rows then
                 ld_fecpxv := null;
          end;
      end if;
   end if;   
   return ld_fecpxv;
end ;
function fn_fvep (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number, pd_fecpro in date ) return date is
ld_fecpxv date;
begin
  if pn_mod in (200,141,117,144) then
      begin
        select /*+ parallel(n,2,1)*/
             min(n.aofvto)
        into ld_fecpxv
        from  fsd010 n
       where n.pgcod  = pn_emp
         and n.aocta  = pn_cta
         and n.aomda  = pn_mda
         and n.aosuc  = pn_suc
         and n.aopap  = pn_pap
         and n.aooper = pn_oper
         and n.aosbop = pn_sbop
         and n.aotope = pn_top
         and n.aomod  = pn_mod;

         if ld_fecpxv is null then
           begin
             select /*+ parallel(n,2,1)*/
                min(n.aofvto)
              into ld_fecpxv
              from  fsd010 n
             where n.pgcod  = pn_emp
               and n.aocta  = pn_cta
               and n.aomda  = pn_mda
               and n.aopap  = pn_pap
               and n.aooper = pn_oper
               and n.aosbop = pn_sbop
               and n.aotope = pn_top
               and n.aomod  = pn_mod;
           exception
               when others then
                  ld_fecpxv := null;
           end;
         end if;
        exception
        when others then
            ld_fecpxv := null;
      end;
  else
  begin
    select /*+ parallel(n,2,1)*/
           min(n.ppfpag)
      into ld_fecpxv
      from  fsd601 n
     where n.pgcod  = pn_emp
       and n.ppcta  = pn_cta
       and n.ppmda  = pn_mda
       and n.ppsuc  = pn_suc
       and n.pppap  = pn_pap
       and n.ppoper = pn_oper
       and n.ppsbop = pn_sbop
       and n.pptope = pn_top
       and n.ppmod  = pn_mod
       and n.ppcap + n.ppint <> 0 -- se agrego 08/2018
       -- se modifico 20150401
       --and n.ppfpag > pd_fecpro
       --
       and n.d601co = 'S'
       and not exists
                (select /*+ parallel(o,2,1)*/  ppmod, ppcta,ppoper, pptope,ppfpag
                   from  fsd602 o
                  where o.pgcod   = n.pgcod
                    and o.ppmod   = n.ppmod
                    and o.ppsuc   = n.ppsuc
                    and o.ppmda   = n.ppmda
                    and o.pppap   = n.pppap
                    and o.ppcta   = n.ppcta
                    and o.ppoper  = n.ppoper
                    and o.ppsbop  = n.ppsbop
                    and o.pptope  = n.pptope
                    and o.ppfpag  = n.ppfpag
                    and o.pp1fech  <= pd_fecpro
                    and o.pp1stat = 'T'
                    and o.d602co  = 'S');
     if ld_fecpxv is null then
        begin
          select /*+ parallel(n,2,1)*/
             min(n.ppfpag)
            into ld_fecpxv
            from  fsd601 n
           where n.pgcod  = pn_emp
             and n.ppcta  = pn_cta
             and n.ppmda  = pn_mda
             and n.pppap  = pn_pap
             and n.ppoper = pn_oper
             and n.ppsbop = pn_sbop
             and n.pptope = pn_top
             and n.ppmod  = pn_mod
             and n.d601co = 'S'
             and n.ppcap + n.ppint <> 0 -- se agrego 08/2018
             -- se modifico 20150401
             --and n.ppfpag > pd_fecpro
             --
             and not exists
                      (select /*+ parallel(o,2,1)*/  ppmod, ppcta,ppoper, pptope,ppfpag
                         from  fsd602 o
                        where o.pgcod   = n.pgcod
                          and o.ppmod   = n.ppmod
                          and o.ppsuc   = n.ppsuc
                          and o.ppmda   = n.ppmda
                          and o.pppap   = n.pppap
                          and o.ppcta   = n.ppcta
                          and o.ppoper  = n.ppoper
                          and o.ppsbop  = n.ppsbop
                          and o.pptope  = n.pptope
                          and o.ppfpag  = n.ppfpag
                          --and o.ppfpag  <= pd_fecpro
                          and o.pp1fech  <= pd_fecpro
                          and o.pp1stat = 'T'
                          and o.d602co  = 'S');
        exception
          when others then
               ld_fecpxv := null;
        end;
       end if;
        if ld_fecpxv is null then
            begin
              select /*+ parallel(n,2,1)*/
                   min(n.aofvto)
              into ld_fecpxv
              from  fsd010 n
             where n.pgcod  = pn_emp
               and n.aocta  = pn_cta
               and n.aomda  = pn_mda
               and n.aosuc  = pn_suc
               and n.aopap  = pn_pap
               and n.aooper = pn_oper
               and n.aosbop = pn_sbop
               and n.aotope = pn_top
               and n.aomod  = pn_mod;
            exception
              when others then
                  ld_fecpxv := null;
            end;
            if ld_fecpxv is null then
              begin
                select /*+ parallel(n,2,1)*/
                     min(n.aofvto)
                into ld_fecpxv
                from  fsd010 n
               where n.pgcod  = pn_emp
                 and n.aocta  = pn_cta
                 and n.aomda  = pn_mda
                 and n.aopap  = pn_pap
                 and n.aooper = pn_oper
                 and n.aosbop = pn_sbop
                 and n.aotope = pn_top
                 and n.aomod  = pn_mod;
              exception
                when others then
                    ld_fecpxv := null;
              end;
            end if;
        end if;


  exception
      when no_data_found then
          ld_fecpxv := null;
      when too_many_rows then
         ld_fecpxv := null;
  end;
  end if;
   return ld_fecpxv;
end ;
function fn_ncpr (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                        pn_pap in number, pn_cta in number, pn_oper in number,
                        pn_sbop in number,pn_top in number ) return number is
ln_numcuo number;
begin
  begin
    if pn_mod = 108 then
       ln_numcuo:=1;
    else

       /* select m.xllcantcuo
          into ln_numcuo
          from  X054023 m
         where m.xllpgcod  = pn_emp
           and m.xllaocta  = pn_cta
           and m.xllaooper = pn_oper
           and m.xllaosbop = pn_sbop
           and m.xllaotop  = pn_top
           and m.xllaomod  = pn_mod
           and m.xllaosuc  = pn_suc
           and m.xllaomda  = pn_mda
           and m.xllaopap  = pn_pap;*/
        select /*+ parallel(n,2,1)*/
           count(n.ppfpag)
            into ln_numcuo
            from  fsd601 n
           where n.pgcod  = pn_emp
             and n.ppcta  = pn_cta
             and n.ppmda  = pn_mda
             and n.ppsuc  = pn_suc
             and n.pppap  = pn_pap
             and n.ppoper = pn_oper
             and n.ppsbop = pn_sbop
             and n.pptope = pn_top
             and n.ppmod  = pn_mod
             and n.d601co = 'S';
     end if;
  exception
     /* when no_data_found then
          begin
             select m.xllcantcuo
              into ln_numcuo
              from  X054023 m
             where m.xllpgcod  = pn_emp
               and m.xllaocta  = pn_cta
               and m.xllaooper = pn_oper
               and m.xllaosbop = pn_sbop
               and m.xllaotop  = pn_top
               and m.xllaomod  = pn_mod
               and m.xllaosuc  = pn_suc
               and m.xllaomda  = pn_mda
               and m.xllaopap  = pn_pap;
          exception*/
             /*when others then
                  ln_numcuo := null;*/
          --end;

      when too_many_rows then
         ln_numcuo := null;
      when others then
         ln_numcuo := null;
  end;
  if nvl(ln_numcuo,0) = 0 then
     begin
        select /*+ parallel(n,2,1)*/
           count(n.ppfpag)
            into ln_numcuo
            from  fsd601 n
           where n.pgcod  = pn_emp
             and n.ppcta  = pn_cta
             and n.ppmda  = pn_mda
             --and n.ppsuc  = pn_suc
             and n.pppap  = pn_pap
             and n.ppoper = pn_oper
             and n.ppsbop = pn_sbop
             and n.pptope = pn_top
             and n.ppmod  = pn_mod
             and n.d601co = 'S';
     exception
        when too_many_rows then
         ln_numcuo := null;
      when others then
         ln_numcuo := null;
     end;
  end if;
   return ln_numcuo;
end ;
function fn_ncpa(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                 pn_pap in number, pn_cta in number, pn_oper in number,
                 pn_sbop in number,pn_top in number, pn_nrpg in number, pd_fecpro in date ) return number is
ln_cuopag number;
ln_totpag number; --08/2018
begin
  if pn_nrpg >0 then 
     begin
        select /*+ parallel(n,2,1)*/
               count(n.ppfpag)
          into ln_cuopag
          from  fsd601 n
         where n.pgcod  = pn_emp
           and n.ppcta  = pn_cta
           and n.ppmda  = pn_mda
           and n.ppsuc  = pn_suc
           and n.pppap  = pn_pap
           and n.ppoper = pn_oper
           and n.ppsbop <> pn_sbop
           and n.pptope = pn_top
           and n.ppmod  = pn_mod
           -- Se agrego como control visita SBS 2017 x observacion en calendarios
           and n.ppcap + n.ppint <> 0
           and n.d601co = 'S'
           and exists
                    (select /*+ parallel(o,2,1)*/  ppmod, ppcta,ppoper, pptope,ppfpag
                       from  fsd602 o
                      where o.pgcod   = n.pgcod
                        and o.ppmod   = n.ppmod
                        and o.ppsuc   = n.ppsuc
                        and o.ppmda   = n.ppmda
                        and o.pppap   = n.pppap
                        and o.ppcta   = n.ppcta
                        and o.ppoper  = n.ppoper
                        and o.ppsbop  = n.ppsbop
                        and o.pptope  = n.pptope
                        and o.ppfpag  = n.ppfpag
                        --and o.ppfpag  <= pd_fecpro
                        and o.pp1fech  <= pd_fecpro
                        and o.pp1stat = 'T'
                        and o.d602co  = 'S'
                        and (o.d602mo, o.d602tr)  not in ( select tp1nro1, tp1nro2
                                                   from fst198
                                                  where tp1cod1 = 11124
                                                    and tp1cod = 1
                                                    and tp1corr1 = 1
                                                    and tp1corr2 = 1 )
                                                    );
      exception
          when no_data_found then
             begin
                select /*+ parallel(n,2,1)*/
                       count(n.ppfpag)
                  into ln_cuopag
                  from  fsd601 n
                 where n.pgcod  = pn_emp
                   and n.ppcta  = pn_cta
                   and n.ppmda  = pn_mda
                   and n.pppap  = pn_pap
                   and n.ppoper = pn_oper
                   and n.ppsbop <> pn_sbop
                   -- Se agrego como control visita SBS 2017 x observacion en calendarios
                   and n.ppcap + n.ppint <> 0
                   and n.d601co = 'S'
                   and exists
                            (select /*+ parallel(o,2,1)*/  ppmod, ppcta,ppoper, pptope,ppfpag
                               from  fsd602 o
                              where o.pgcod   = n.pgcod
                                and o.ppmod   = n.ppmod
                                and o.ppsuc   = n.ppsuc
                                and o.ppmda   = n.ppmda
                                and o.pppap   = n.pppap
                                and o.ppcta   = n.ppcta
                                and o.ppoper  = n.ppoper
                                and o.ppsbop  = n.ppsbop
                                and o.pptope  = n.pptope
                                and o.ppfpag  = n.ppfpag
                                --and o.ppfpag  <= pd_fecpro
                                and o.pp1fech  <= pd_fecpro
                                and o.pp1stat = 'T'
                                and o.d602co  = 'S'
                                and (o.d602mo, o.d602tr)  not in ( select tp1nro1, tp1nro2
                                                   from fst198
                                                  where tp1cod1 = 11124
                                                    and tp1cod = 1
                                                    and tp1corr1 = 1
                                                    and tp1corr2 = 1 )
                                                    );
              exception
                  when no_data_found then
                     ln_cuopag := 0;
                  when too_many_rows then
                     ln_cuopag := null;
              end;
          when too_many_rows then
             ln_cuopag := null;
      end;
      --if nvl(ln_cuopag,0) = 0 then 
         begin
                select /*+ parallel(n,2,1)*/
                       count(n.ppfpag)
                  into ln_totpag
                  from  fsd601 n
                 where n.pgcod  = pn_emp
                   and n.ppcta  = pn_cta
                   and n.ppmda  = pn_mda
                   and n.ppsuc  = pn_suc
                   and n.pppap  = pn_pap
                   and n.ppoper = pn_oper
                   and n.ppsbop = pn_sbop
                   and n.pptope = pn_top
                   and n.ppmod  = pn_mod
                   -- Se agrego como control visita SBS 2017 x observacion en calendarios
                   and n.ppcap + n.ppint <> 0
                   and n.d601co = 'S'
                   and exists
                            (select /*+ parallel(o,2,1)*/  ppmod, ppcta,ppoper, pptope,ppfpag
                               from  fsd602 o
                              where o.pgcod   = n.pgcod
                                and o.ppmod   = n.ppmod
                                and o.ppsuc   = n.ppsuc
                                and o.ppmda   = n.ppmda
                                and o.pppap   = n.pppap
                                and o.ppcta   = n.ppcta
                                and o.ppoper  = n.ppoper
                                and o.ppsbop  = n.ppsbop
                                and o.pptope  = n.pptope
                                and o.ppfpag  = n.ppfpag
                                --and o.ppfpag  <= pd_fecpro
                                and o.pp1fech  <= pd_fecpro
                                and o.pp1stat = 'T'
                                and o.d602co  = 'S');
              exception
                  when no_data_found then
                     ln_totpag := 0;
                  when too_many_rows then
                     ln_totpag := null;
              end;
              if nvl(ln_totpag,0) = 0 then
                  begin
                    select /*+ parallel(n,2,1)*/
                           count(n.ppfpag)
                      into ln_totpag
                      from  fsd601 n
                     where n.pgcod  = pn_emp
                       and n.ppcta  = pn_cta
                       and n.ppmda  = pn_mda
                       --and n.ppsuc  = pn_suc
                       and n.pppap  = pn_pap
                       and n.ppoper = pn_oper
                       and n.ppsbop = pn_sbop
                       and n.pptope = pn_top
                       and n.ppmod  = pn_mod
                       and n.d601co = 'S'
                       and n.ppcap + n.ppint <> 0
                       and exists
                                (select /*+ parallel(o,2,1)*/  ppmod, ppcta,ppoper, pptope,ppfpag
                                   from  fsd602 o
                                  where o.pgcod   = n.pgcod
                                    and o.ppmod   = n.ppmod
                                    and o.ppsuc   = n.ppsuc
                                    and o.ppmda   = n.ppmda
                                    and o.pppap   = n.pppap
                                    and o.ppcta   = n.ppcta
                                    and o.ppoper  = n.ppoper
                                    and o.ppsbop  = n.ppsbop
                                    and o.pptope  = n.pptope
                                    and o.ppfpag  = n.ppfpag
                                    --and o.ppfpag  <= pd_fecpro
                                    and o.pp1fech  <= pd_fecpro
                                    and o.pp1stat = 'T'
                                    and o.d602co  = 'S');
                  exception
                      when no_data_found then
                         ln_totpag := 0;
                      when too_many_rows then
                         ln_totpag := null;
                  end;
               end if;
      ln_cuopag :=  nvl(ln_totpag,0) + nvl(ln_cuopag,0);        
      --end if;
      
  else 
      begin
        select /*+ parallel(n,2,1)*/
               count(n.ppfpag)
          into ln_cuopag
          from  fsd601 n
         where n.pgcod  = pn_emp
           and n.ppcta  = pn_cta
           and n.ppmda  = pn_mda
           and n.ppsuc  = pn_suc
           and n.pppap  = pn_pap
           and n.ppoper = pn_oper
           and n.ppsbop = pn_sbop
           and n.pptope = pn_top
           and n.ppmod  = pn_mod
           -- Se agrego como control visita SBS 2017 x observacion en calendarios
           and n.ppcap + n.ppint <> 0
           and n.d601co = 'S'
           and exists
                    (select /*+ parallel(o,2,1)*/  ppmod, ppcta,ppoper, pptope,ppfpag
                       from  fsd602 o
                      where o.pgcod   = n.pgcod
                        and o.ppmod   = n.ppmod
                        and o.ppsuc   = n.ppsuc
                        and o.ppmda   = n.ppmda
                        and o.pppap   = n.pppap
                        and o.ppcta   = n.ppcta
                        and o.ppoper  = n.ppoper
                        and o.ppsbop  = n.ppsbop
                        and o.pptope  = n.pptope
                        and o.ppfpag  = n.ppfpag
                        --and o.ppfpag  <= pd_fecpro
                        and o.pp1fech  <= pd_fecpro
                        and o.pp1stat = 'T'
                        and o.d602co  = 'S');
      exception
          when no_data_found then
             ln_cuopag := 0;
          when too_many_rows then
             ln_cuopag := null;
      end;
      if nvl(ln_cuopag,0) = 0 then
          begin
            select /*+ parallel(n,2,1)*/
                   count(n.ppfpag)
              into ln_cuopag
              from  fsd601 n
             where n.pgcod  = pn_emp
               and n.ppcta  = pn_cta
               and n.ppmda  = pn_mda
               --and n.ppsuc  = pn_suc
               and n.pppap  = pn_pap
               and n.ppoper = pn_oper
               and n.ppsbop = pn_sbop
               and n.pptope = pn_top
               and n.ppmod  = pn_mod
               and n.d601co = 'S'
               and n.ppcap + n.ppint <> 0
               and exists
                        (select /*+ parallel(o,2,1)*/  ppmod, ppcta,ppoper, pptope,ppfpag
                           from  fsd602 o
                          where o.pgcod   = n.pgcod
                            and o.ppmod   = n.ppmod
                            and o.ppsuc   = n.ppsuc
                            and o.ppmda   = n.ppmda
                            and o.pppap   = n.pppap
                            and o.ppcta   = n.ppcta
                            and o.ppoper  = n.ppoper
                            and o.ppsbop  = n.ppsbop
                            and o.pptope  = n.pptope
                            and o.ppfpag  = n.ppfpag
                            --and o.ppfpag  <= pd_fecpro
                            and o.pp1fech  <= pd_fecpro
                            and o.pp1stat = 'T'
                            and o.d602co  = 'S');
          exception
              when no_data_found then
                 ln_cuopag := 0;
              when too_many_rows then
                 ln_cuopag := null;
          end;
       end if;
   end if;    
   return ln_cuopag;
end ;
function fn_ciiu (pn_cta in number ) return number is
ln_activi number;
begin
  begin
  select xx.actcod2--15.03.2013
    into ln_activi
    from  sngc60 aa,   fst750 xx,   fsr008 pp
   where pp.pgcod = 1
     and pp.ctnro = pn_cta
     and pp.cttfir ='T'
     and aa.sngc60pais = pp.pepais
     and aa.sngc60tdoc = pp.petdoc
     and aa.sngc60ndoc = pp.pendoc
     and aa.sngc60corr = 0
     and aa.sngc60acte = xx.actcod1;
  exception
      when no_data_found then
         ln_activi := null;
      when too_many_rows then
         ln_activi := null;
  end;
   return ln_activi;
end ;

function fn_mdcr(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                 pn_pap in number, pn_cta in number, pn_oper in number,
                 pn_sbop in number,pn_top in number, pd_fecpro in date,
                 pn_rubro in number, pn_stat in number, pn_instac in number, 
                 pc_indamp in varchar2, pn_numrpr in number, pn_pais in number, 
                 pn_tipdoc in number, pc_numdoc in varchar2 ) return varchar2 is
ln_clinew number;
lc_modalid varchar2(20);
lc_existe  varchar2(1);
ln_contador number;
lc_numdoc fsd001.pendoc%type;
begin
     /*begin
        select nvl(sng001tpcr,0)
          into ln_clinew
          from  sng001
         where sng001inst = pn_instac; --ln_clinew;
     exception
         when no_data_found then
               ln_clinew := 0;
         when others then
               null;
     end;*/
     -- Reprogramados Asia
     lc_existe := null;
     begin
        select distinct 'S'
          into lc_existe
          from  jaql125 s
         where s.bcemp = pn_emp
           and s.bcsuc = pn_suc
           and s.bcmod = pn_mod
           and s.bcmda = pn_mda
           and s.bcpap = pn_pap
           and s.bccta = pn_cta
           and s.bcoper= pn_oper
           and s.bcsbop= pn_sbop
           and s.bctop = pn_top;
     exception
         when no_data_found then
             begin
               select distinct 'S'
                 into lc_existe
                 from  jaqz519 j
                where j.jaqz519ind in ('S', 'P' , 'C') -- Reprogrmados Convenios
                  and j.jaqz519pro10 = 'S'
                  and j.jaqz519pro11 = 'S'
                  and j.jaqz519pro601 = 'S'
                  and j.jaqz519pro611 = 'S'
                  and nvl(j.jaqz519revr,'X') <> 'S'
                  and j.jaqz519emp = pn_emp
                  and j.jaqz519suc = pn_suc
                  and j.jaqz519mod = pn_mod
                  and j.jaqz519mda = pn_mda
                  and j.jaqz519pap = pn_pap
                  and j.jaqz519cta = pn_cta
                  and j.jaqz519ope = pn_oper
                  and j.jaqz519sbo = pn_sbop
                  and j.jaqz519top = pn_top; 
             exception
               when no_data_found then
                    -- Se agrego lista Mabel consumos manuales
                    begin
                      select distinct 'S' 
                        into lc_existe
                        from jaql125 x
                       where x.bcemp = 2
                         and x.bccta = pn_cta
                         and x.bcoper = pn_oper;
                    exception 
                      when no_data_found then
                           lc_existe := 'N';
                      when others then
                           null; 
                    end; 
                   -----------------------------            
               when others then
                 null;
             end;
         when others then
               null;
     end;
     lc_numdoc := trim(pc_numdoc);
     pq_datos_sbs.sp_relcredi_nr(pn_pai => pn_pais,-- pais
                                     pn_tdo => pn_tipdoc,--  tipo documwento
                                     pc_ndo => lc_numdoc, -- numero documento
                                     pd_fecpro => pd_fecpro, -- fecha de proceso
                                     ln_contador => ln_contador);
                                                              
    if ln_contador <= 6 then 
      ln_clinew := 1;
    Else
      ln_clinew := 0;  
    End if;

     case when substr(pn_rubro,4,1) IN (5,6) and substr(pn_rubro,7,2) = 19 then
               lc_modalid:= 'REFINANCIADO';
          when substr(pn_rubro,4,1) = 4 /*and pn_stat in (61,34)*/ then
               lc_modalid:= 'REFINANCIADO';
         /* when substr(pn_rubro,4,1) = 4 and pn_stat  = 33 then
               lc_modalid:= 'TRANSADO';*/
          when pn_mod = 105 or ( pn_mod = 106 and pn_top in(2,4,6)) then
               lc_modalid:= 'PARALELO';
          when pq_datos_sbs.fn_reprogramado (pn_mod,pn_suc,pn_mda,
                     pn_pap,pn_cta,pn_oper,pn_sbop,pn_top,pd_fecpro) = 860 or ( pn_numrpr <> 0 and  nvl(pc_indamp,'N') <> 'S')  then
               lc_modalid:= 'REP_CAMBIO_FECHA';
          when pq_datos_sbs.fn_reprogramado (pn_mod,pn_suc,pn_mda,
                     pn_pap,pn_cta,pn_oper,pn_sbop,pn_top,pd_fecpro) = 870 then
               lc_modalid:= 'REP_DESASTRES';
          when lc_existe = 'S' then
               lc_modalid:= 'REP_CAMBIO_FECHA';
          When pc_indamp = 'S' then 
               lc_modalid:= 'AMPLIADO';  
          When pn_mod = 108 and pn_sbop > 0 then
               lc_modalid:= 'RENOVADO';
          when ln_clinew = 1 then
               lc_modalid:= 'NUEVO';
          else lc_modalid:= 'RECURRENTE';
      END case ;

   return lc_modalid;
end ;

procedure  sp_nrprg_fultrprg (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                 pn_pap in number, pn_cta in number, pn_oper in number,
                 pn_sbop in number,pn_top in number, pn_instac in number,pd_fecpro in date,
                 pn_totcam out number, pd_fulcam out varchar2, pc_indamp out varchar2 ) is
ln_amplia number;
lc_modalid varchar2(20);
ld_fecamp date;
ln_numrep number;
ld_fulrep date;
ln_totcam number;
ld_fulcam varchar2(10);
lc_indamp varchar2(1);
ld_fdesatre date;
begin
     -- Ampliacion
     begin
    /*    select nvl(SNG001ORI,0), SNG001FIN
          into ln_amplia, ld_fecamp
          from  sng001
         where sng001inst = pn_instac;*/
       select 4,a.HFCON
         into ln_amplia, ld_fecamp
         from  fsh016 a,  fsh015 b 
        where a.pgcod = b.pgcod
          and a.hcmod = b.hcmod
          and a.hsucor = b.hsucor
          and a.htran = b.htran
          and a.hnrel = b.hnrel
          and a.hfcon = b.hfcon
          and a.hcta  = pn_cta
          and a.hoper = pn_oper
           /**/
               and hmda = pn_mda
               and hpap = pn_pap
               /**/
          and b.hcmod = 30
          and b.htran in (360,357)
          and b.hccorr = 0
          and b.hfvc <= pd_fecpro
          and a.hrubro in (select /*+all_rows*/rubro 
                             from  fsd014 
                            where pcimpu ='S' 
                              and pcnivc in(select modulo from   fst111 
                                             where dscod = 50 and modulo not in (29,120,144)
                                             union all
                                            select modulo from   fst003 where modulo in (117,141))
                                               and pmtit <> 9) ;

                   
         
     exception
         when no_data_found then
               ln_amplia := 0;
               ld_fecamp := null;
         when others then
               null;
     end;
     -- REprogramacion

      if pn_mod = 200  or pn_top = 550 then 
         begin
              select count(*), max (d.r011fc)
                into ln_numrep, ld_fulrep
               from  fsr011 s,  fsr011 d
              where s.relcod = 52
                and s.r2cod  = 1
                and s.r2mod  = pn_mod
                and s.r2suc  = pn_suc
                and s.r2mda  = pn_mda
                and s.r2pap  = pn_pap
                and s.r2cta  = pn_cta
                and s.r2oper = pn_oper
                and s.r2sbop = pn_sbop
                and s.r2tope = pn_top
                and s.r011co = 'S'
                and d.relcod in (860,870)
                and d.r1cod  = s.r1cod 
                and d.r1mod  = s.r1mod 
                and d.r1suc  = s.r1suc 
                and d.r1mda  = s.r1mda 
                and d.r1pap  = s.r1pap 
                and d.r1cta  = s.r1cta 
                and d.r1oper = s.r1oper
                and d.r1sbop = s.r1sbop
                and d.r1tope = s.r1tope
                and d.r011co = 'S'
                and d.r011fc <= pd_fecpro;
          exception
              when no_data_found then
                 ln_numrep := 0;
                 ld_fulrep := null;
          end;
      else 
          begin
              select count(*), max (r011fc)
                into ln_numrep, ld_fulrep
               from  fsr011 s
              where relcod in (860,870)
                and s.r1cod  = 1
                and s.r1mod  = pn_mod
                and s.r1suc  = pn_suc
                and s.r1mda  = pn_mda
                and s.r1pap  = pn_pap
                and s.r1cta  = pn_cta
                and s.r1oper = pn_oper
                and s.r1sbop = pn_sbop
                and s.r1tope = pn_top
                and s.r011co = 'S'
                and NVL(s.r011fc,'19010101') <= pd_fecpro;
          exception
              when no_data_found then
                 ln_numrep := 0;
                 ld_fulrep := null;
          end;
          ---- Se agrego para desastres reprogramaciones masivas 
          if nvl(ln_numrep,0) = 0 then 
          begin
              select 1,to_date('20161129','yyyymmdd')
                into ln_numrep, ld_fdesatre
                from  jaql125 s
               where s.bcemp = pn_emp
                 and s.bcsuc = pn_suc
                 and s.bcmod = pn_mod
                 and s.bcmda = pn_mda
                 and s.bcpap = pn_pap
                 and s.bccta = pn_cta
                 and s.bcoper= pn_oper
                 and s.bcsbop= pn_sbop
                 and s.bctop = pn_top;
           exception
               when no_data_found then
                   begin
                     select count(*) , max(j.jaqz519fep)
                       into ln_numrep, ld_fdesatre
                       from  jaqz519 j
                      where j.jaqz519ind in ('S', 'P' , 'C') -- Reprogrmados Convenios
                        and j.jaqz519pro10 = 'S'
                        and j.jaqz519pro11 = 'S'
                        and j.jaqz519pro601 = 'S'
                        and j.jaqz519pro611 = 'S'
                        and nvl(j.jaqz519revr,'X') <> 'S'
                        and j.jaqz519emp = pn_emp
                        and j.jaqz519suc = pn_suc
                        and j.jaqz519mod = pn_mod
                        and j.jaqz519mda = pn_mda
                        and j.jaqz519pap = pn_pap
                        and j.jaqz519cta = pn_cta
                        and j.jaqz519ope = pn_oper
                        and j.jaqz519sbo = pn_sbop
                        and j.jaqz519top = pn_top; 
                       if ld_fdesatre is null then
                          begin
                              select  1,to_date('20170929','yyyymmdd')
                                into ln_numrep, ld_fdesatre
                                from jaql125 x
                               where x.bcemp = 2
                                 and x.bccta = pn_cta
                                 and x.bcoper = pn_oper;
                            exception 
                              when no_data_found then
                                   ld_fdesatre := null;
                                   ln_numrep := 0;
                              when others then
                                   null; 
                            end; 
                       end if;    
                   exception
                     when no_data_found then
                          -- Se agrego lista Mabel consumos manuales
                          begin
                            select  1,to_date('20170929','yyyymmdd')
                              into ln_numrep, ld_fdesatre
                              from jaql125 x
                             where x.bcemp = 2
                               and x.bccta = pn_cta
                               and x.bcoper = pn_oper;
                          exception 
                            when no_data_found then
                                 ld_fdesatre := null;
                                 ln_numrep := 0;
                            when others then
                                 null; 
                          end; 
                         -----------------------------            
                          
                     when others then
                       ld_fdesatre := null;
                       ln_numrep := 0;
                   end;
           when others then
               null;
           end;
         end if; 
          
          
        end if;  

     if  ln_numrep > 0 and  ld_fulrep is null and ld_fdesatre is null then
        -- busca en sorfy
        begin
           select max(s.d_fecrrp), count(*)
             into ld_fulrep, ln_numrep
             from   JAQL122/*MIGRA2.crdaprr */s,  bnj096 b
            where s.c_numcre = b.bnj096sor
              and b.bnj096suc = pn_suc
              and b.bnj096mda = pn_mda
              and b.bnj096pap = pn_pap
              and b.bnj096cta = pn_cta
              and b.bnj096ope = pn_oper
              and s.d_fecrrp <= pd_fecpro;
        exception
           when no_data_found then
             ln_numrep := 0;
             ld_fulrep := null;
        end;
     end if;
     if  ln_amplia in (4,12) then
       ln_totcam := 1;
       lc_indamp := 'S';
     else
       ln_totcam := 0;
       lc_indamp := 'N';
     end if;
     -- Se modifico 
     if ld_fulrep is not null and ld_fulrep > nvl(ld_fecamp,to_date('19000101','yyyymmdd')) then
        ld_fulcam := to_char(ld_fulrep,'dd/mm/yyyy');
     elsif ld_fdesatre is not null and ld_fdesatre <> to_date('19010101','yyyymmdd') then 
        ld_fulcam := to_char(ld_fdesatre,'dd/mm/yyyy');
     elsif ld_fdesatre = to_date('19010101','yyyymmdd') then 
        ld_fulcam := '00/00/0000'; 
     else
        ld_fulcam := nvl(to_char(ld_fecamp,'dd/mm/yyyy'),'00/00/0000');
     end if;
     ---
     ln_totcam := ln_totcam + ln_numrep;
     pn_totcam := ln_totcam;
     pd_fulcam := ld_fulcam;
     pc_indamp := lc_indamp;

end ;

function fn_indic(pn_mod in number,pn_rubro in number) return number is
ln_indic number;
begin
     case when pn_mod = 107 and  substr(pn_rubro,5,6) = '03' then
               ln_indic:= 3;
          when pn_mod = 116 then
               ln_indic:= 2;
          when pn_mod = 115 then
               ln_indic:= 1;
          else ln_indic:= 0;
      END case ;

   return ln_indic;
end ;

procedure  sp_lco_lcnu_cclcnu(pn_emp in number, pn_mod in number, pn_suc in number,
                 pn_mda in number,pn_pap in number, pn_cta in number,
                 pn_oper in number,pn_sbop in number,pn_top in number,
                 pd_fecpro in date, pn_sdmn in number,pn_rubro in number,
                 pn_lco out number, pn_lcnu out number, pn_cclcnu out number ) is
ln_emp  number;
ln_mod number;
ln_suc  number;
ln_mda  number;
ln_pap  number;
ln_cta  number;
ln_oper number;
ln_sbop number;
ln_top  number;
ln_rubro number;
ln_lco number;
ln_lcnu number;
ln_cclcnu number;
begin
     -- Lineas
     if pn_mod in (/*116,*/117) then
        if pn_mod  = 116 then
        -- prestamo
        begin
            select/*+parallel(b,2)*/  b.bcemp ,b.bcsuc ,b.bcmda ,b.bcpap, --15.03.2015
                   b.bccta ,b.bcoper,b.bcsbop,b.bctop,
                   b.bcrubr,b.bcsdmn
              into ln_emp ,ln_suc ,ln_mda ,ln_pap,
                   ln_cta ,ln_oper,ln_sbop,ln_top,
                   ln_rubro,ln_lco
              from  fsr011 a,  fsh012 b
             where a.r1cod  = pn_emp
               and a.r1mod  = pn_mod
               and a.r1suc  = pn_suc
               and a.r1mda  = pn_mda
               and a.r1pap  = pn_pap
               and a.r1cta  = pn_cta
               and a.r1oper = pn_oper
               and a.r1sbop = pn_sbop
               and a.r1tope = pn_top
               and a.relcod = 46
               and a.r011co = 'S'
               and b.bcemp  = a.r2cod
               and b.bcsuc  = a.r2suc
               and b.bcmda  = a.r2mda
               and b.bcpap  = a.r2pap
               and b.bccta  = a.r2cta
               and b.bcoper = a.r2oper
               and b.bcsbop = a.r2sbop
               and b.bctop  = a.r2tope
               and b.bcfech = pd_fecpro
               and b.bcrubr in (select rubro from   fsd014 where pcnivc = 117 and pcimpu ='S');
           exception
              when no_data_found then
                  null;
              when too_many_rows then
                 begin
                    select b.bcemp ,b.bcsuc ,b.bcmda ,b.bcpap,
                           b.bccta ,b.bcoper,b.bcsbop,b.bctop,
                           max(b.bcrubr),sum(b.bcsdmn)
                      into ln_emp ,ln_suc ,ln_mda ,ln_pap,
                           ln_cta ,ln_oper,ln_sbop,ln_top,
                           ln_rubro,ln_lco
                      from  fsr011 a,  fsh012 b
                     where a.r1cod  = pn_emp
                       and a.r1mod  = pn_mod
                       and a.r1suc  = pn_suc
                       and a.r1mda  = pn_mda
                       and a.r1pap  = pn_pap
                       and a.r1cta  = pn_cta
                       and a.r1oper = pn_oper
                       and a.r1sbop = pn_sbop
                       and a.r1tope = pn_top
                       and a.relcod = 46
                       and a.r011co = 'S'
                       and b.bcemp  = a.r2cod
                       and b.bcsuc  = a.r2suc
                       and b.bcmda  = a.r2mda
                       and b.bcpap  = a.r2pap
                       and b.bccta  = a.r2cta
                       and b.bcoper = a.r2oper
                       and b.bcsbop = a.r2sbop
                       and b.bctop  = a.r2tope
                       and b.bcfech = pd_fecpro
                       and b.bcrubr in (select rubro from   fsd014 where pcnivc = 117 and pcimpu ='S')
                     group by b.bcemp ,b.bcsuc ,b.bcmda ,b.bcpap,
                           b.bccta ,b.bcoper,b.bcsbop,b.bctop ;
                 exception
                   when others then
                      null;
                      ln_lco    := 0;
                      ln_lcnu   := 0;
                      ln_cclcnu := 0;
                 end;
           end;
           pq_datos_sbs.sp_cta_saldo_relacion(ln_emp, ln_mod, ln_suc, ln_mda,
                                              ln_pap, ln_cta, ln_oper,ln_sbop,
                                              ln_top, pd_fecpro, 18,
                                              to_char(ln_rubro), ln_lcnu , ln_cclcnu);
        else
           ln_lco    := pn_sdmn;
           pq_datos_sbs.sp_cta_saldo_relacion(pn_emp, pn_mod, pn_suc, pn_mda,
                                              pn_pap, pn_cta, pn_oper,pn_sbop,
                                              pn_top, pd_fecpro, 18,
                                              to_char(pn_rubro), ln_lcnu , ln_cclcnu);
        end if;

     else
         ln_lco    := 0;
         ln_lcnu   := 0;
         ln_cclcnu := 0;
     end if;
     pn_lco    := ln_lco;
     pn_lcnu   := ln_lcnu;
     if substr(pn_rubro,1,1) = 7 then
        pn_cclcnu := substr(pn_rubro,1,10);
     else
        pn_cclcnu := 0;
     end if;

end ;

function fn_tcrint(pn_rubro in number, pn_sector in number) return varchar2 is
lc_tcrint varchar2(2);
begin
  begin
        select Case
               when pn_sector not in (1, 2, 3) and b.incol < 9 then
                lpad(b.incol, 2, '0')
               when b.incol = 9 and pn_sector = 1 then '09'
               when b.incol = 9 and pn_sector = 2 then '10'
               when b.incol = 9 and pn_sector = 3 then '11'
               when b.incol = 10 then '12'
               when b.incol = 11 then '13'
               when b.incol = 12 then '14'
               when b.incol = 13 then '15' end
        into lc_tcrint
        from  fsi006 a,  fsi003 b
       where a.cicpo like 'ANEXO6%'
         and a.rubro = pn_rubro
         and a.cicpo = b.cicpo
         and b.pgcod = 1
         and b.inprg = 'ANEXO6';
   exception
      when others then
           lc_tcrint := null;
   end;
   return lc_tcrint;
end ;

function fn_tcri(pn_rubro in number, pn_sector in number) return varchar2 is
lc_tcri varchar2(40);
ln_rubini number;
ln_rubsbs number;
ln_rubsbs2 number;
begin
    ln_rubini := substr(pn_rubro,1,2);
    ln_rubsbs := substr(pn_rubro,5,2);
    ln_rubsbs2 := substr(pn_rubro,7,2);
    Case
         when pn_sector in (1, 2, 3) and  ln_rubini = 14 and ln_rubsbs = 13  then
              if pn_sector = 1 then
                 lc_tcri := 'Pequeña Empresa 1';
              elsif pn_sector = 2 then
                 lc_tcri := 'Pequeña Empresa 2';
              elsif pn_sector = 3 then
                 lc_tcri := 'Pequeña Empresa 3';
              else
                 lc_tcri := null;
              end if;
         when pn_sector = 0 and  ln_rubini = 14 and ln_rubsbs = 13  then
              lc_tcri := 'Pequeña Empresa 1';
         when pn_sector in (1, 2, 3) and  ln_rubini in (72,71) and ln_rubsbs2 = 13  then
              if pn_sector = 1 then
                 lc_tcri := 'Pequeña Empresa 1';
              elsif pn_sector = 2 then
                 lc_tcri := 'Pequeña Empresa 2';
              elsif pn_sector = 3 then
                 lc_tcri := 'Pequeña Empresa 3';
              else
                 lc_tcri := null;
              end if;
         when pn_sector = 0 and  ln_rubini in (72,71) and ln_rubsbs2 = 13  then
                 lc_tcri := 'Pequeña Empresa 1';
         when (ln_rubini = 14 and ln_rubsbs  = '02') or
              (ln_rubini in (72,71) and ln_rubsbs2 = '02') then
              lc_tcri := 'Micro Empresa';
         when (ln_rubini = 14 and ln_rubsbs  = '03') or
              (ln_rubini in (72,71) and ln_rubsbs2 = '03') then
              lc_tcri := 'Consumo';
         when (ln_rubini = 14 and ln_rubsbs  = '04') or
              (ln_rubini in (72,71) and ln_rubsbs2 = '04') then
              lc_tcri := 'Hipotecario';
         when (ln_rubini = 14 and ln_rubsbs  = '09') or
              (ln_rubini in (72,71) and ln_rubsbs2 = '09') then
              lc_tcri := 'Emp. Sistema Financiero';
         when (ln_rubini = 14 and ln_rubsbs  = '11') or
              (ln_rubini in (72,71) and ln_rubsbs2 = '11') then
              lc_tcri := 'Grandes Empresas';
         when (ln_rubini = 14 and ln_rubsbs  = '12') or
              (ln_rubini in (72,71) and ln_rubsbs2 = '12') then
              lc_tcri := 'Mediana Empresa';
         else  lc_tcri := null;
         end case;

   return lc_tcri;
end ;

function fn_tspi(pn_modulo in number, pn_toper in number) return varchar2 is
lc_tspi varchar2(40);
begin
   begin
       select a.tonom
         into lc_tspi
         from  fst004 a
        where a.modulo = pn_modulo
          and a.totope = pn_toper;
   exception
      when others then
           lc_tspi := null;
   end;
   return lc_tspi;
end ;

function fn_rom(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                           pn_pap in number, pn_cta in number, pn_oper in number,
                           pn_sbop in number,pn_top in number, pd_fecpro in date) return number is
ln_saldo number;
begin
  begin
    select sum(s.bcsdmn)
         into ln_saldo
         from  fsh012 s
        where s.bcemp = pn_emp
          and s.bcsuc = pn_suc
          and s.bcrubr in ( 8119270000001,8129270000001 )
          /*( select rubro
                             from  fsd014
                            where rubro like '81_927%'
                              and pcimpu = 'S'
                              and substr(rubro,1,1) <> 9 )*/
          and s.bcmda = pn_mda
          and s.bcpap = pn_pap
          and s.bccta = pn_cta
          and s.bcoper= pn_oper
          and s.bcfech= pd_fecpro;
  exception
      when others then
         ln_saldo := null;
  end;
   return ln_saldo;
end fn_rom;

function fn_deslin(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                   pn_pap in number, pn_cta in number, pn_oper in number,
                   pn_sbop in number,pn_top in number) return varchar2 is
lc_deslin varchar2(1);
begin
     if pn_mod = 116 then
       lc_deslin := 'S';
     else
       begin
          select 'S'
            into lc_deslin
            from  fsr011 a
           where a.r2cod  = pn_emp
             and a.r2mod  = pn_mod
             and a.r2suc  = pn_suc
             and a.r2mda  = pn_mda
             and a.r2pap  = pn_pap
             and a.r2cta  = pn_cta
             and a.r2oper = pn_oper
             and a.r2sbop = pn_sbop
             and a.r2tope = pn_top
             and a.relcod = 46
             and a.r011co = 'S';
       exception
         when no_data_found then
              lc_deslin := 'N';
         when too_many_rows then
              lc_deslin := 'S';
       end;
    end if;
   return lc_deslin;
end ;
Procedure sp_job_procesa_BDC01 (pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  x number;
  cursor sucursal is
  select sucurs from  fst001 where pgcod =1 ;
  begin
    execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
    /*begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                    tabname          => 'JAQL120',
                                    degree           => 4,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;*/
    /*begin
         select host_name
           into lc_hostname
           from v$instance;
    end;*/
--     lc_hostname := 'SC01ZDBADM010101';

     execute immediate ('truncate table  BDC01 ');
     execute immediate ('truncate table  JAQL121 ');
     execute immediate ('alter session set parallel_force_local=TRUE');--jflor 2014.01.16
     delete  tab_jobs  where  c_Codage = 'BDC1';
     commit;
     --x:= 0; 
     for i in sucursal loop
            ln_ini := i.sucurs;
            lc_variable := ' begin '|| '  pq_datos_sbs.sp_procesa_BDC01('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
            ln_job := ln_job +1;
        
--             if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
             if sys.fn_bd_IsRAC='TRUE' then
                   --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
                   DBMS_JOB.SUBMIT(job => ln_job,
                                what => lc_variable,
                                next_date => sysdate,
                                interval => null,
                                no_parse => false,
                                instance => 2,
                                force => false
                                );
                  INSERT INTO  tab_jobs  (c_Codage,n_Numer1,c_detjob)
                  VALUES('BDC1',ln_ini,lc_variable);
                  COMMIT;
             else
                 DBMS_JOB.SUBMIT(job => ln_job,
                                what => lc_variable,
                                next_date => sysdate,
                                interval => null,
                                no_parse => false,
                                force => false
                                );
                  INSERT INTO  tab_jobs  (c_Codage,n_Numer1,c_detjob)
                  VALUES('BDC1',ln_ini,lc_variable);
                  COMMIT;
             end if;
             select count(*) 
              into x
              from user_jobs;
            while x = 20 loop
              select count(*) 
              into x
              from user_jobs; 
            end loop;
         
      end loop;
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'BDC01',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

  end;
Procedure sp_procesa_BDC01 (pn_numsuc in number, pd_fecpro in varchar2 ) is

  ld_fecpro date ;
  lc_coderr varchar2(300);
  cursor prestamo is

select ccl,csbs,tid,nid,ncl ,
       bcemp,bcpap,bccta,bcsbop,
       mon,
       bctop,bcmod,ccr,case when mon = 0 then 'PEN' else 'USD' end mone, cage,
       morg,cal,calint,
       sum(kvi)kvi,max(ccvi)ccvi,
       sum(kre)kre,max(ccre)ccre,
       sum(krf)krf,max(ccrf)ccrf,
       sum(kve)kve,max(ccve)ccve,
       sum(kju)kju,max(ccju)ccju,
       sum(kco)kco,max(ccco)ccco,
       fcc,fveg,tpr,csec,tea, d_fecpro, bcprod,
       count(distinct(substr(bcrubr,1,3)||substr(bcrubr,5,8))),
       case when count(distinct(substr(bcrubr,1,3)||substr(bcrubr,5,8))) = 1  then min(bcrubr) else max(bcrubr) end bcrubr,
       n_instan
  from JAQL120 x
 where cage = pn_numsuc
   and d_fecpro = ld_fecpro --to_date('20170228','yyyymmdd')
   -- /*and csbs = '0074281630'*/ and ccr = '2300121'
   --and bcmod =117
   --and ccr in (1754696)
   --and not exists ( select * from bdc01 a where a.ccl = x.ccl  and a.ccr = ccr)
 group by ccl,csbs,tid,nid,ncl ,
          bcmod,ccr,mon,morg,cal,calint,
          fcc,fveg,tpr,cage,csec,tea,
          bcemp,bcpap,bccta,bcsbop,bctop,d_fecpro, bcprod,n_instan;
ln_skcr  number;
ln_dak   number;
ln_dakr  number;
ln_dapr  number;
ln_pci   number;
ln_sin   number;
ln_csin  number;
ln_sid   number;
ln_sid2   number;
ln_ccsid number;
ln_ccsid2 number;
ln_sis   number;
ln_ccsis number;
ld_fot   date;
ln_Dgr   number;
ld_fppk  date;
ld_fep   date;
ln_pcuo  number;
ln_ncpr  number;
ld_fvep  date;
ln_ncpa  number;
ln_ciiu  number;
lc_mdcr  varchar2(20);
ln_nrprg number;
ld_fultrprg varchar2(10);
ln_indic number;
ln_lco   number;
ln_lcnu  number;
ln_cclcnu number;
lc_tcr   varchar2(2);
ln_secint number;
lc_tcrint varchar2(2);
ln_esam number;
ln_rfa number;
lc_TCRI   varchar2(40);
lc_TSPR   varchar2(100);
ln_CCND   number;
lc_CCCCND varchar2(40);
ln_ROM    number;
lc_deslin varchar2(1);
ln_ccr VARCHAR2(17);
lc_tipoc varchar2(20);
lc_trasf varchar2(1);
ln_cbtea number;
ln_tea number;
lc_indamp varchar2(1);
ln_pais number;
ln_tipdoc number;
lc_numdoc varchar2(12);
begin

  update  tab_jobs  g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'BDC1';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');

  for i in prestamo loop
      -- inicializa variables 
     lc_deslin:=null;
     lc_tipoc := null;
     ld_fvep  := null;
     lc_mdcr  := null;
     ln_cbtea := null;
     ln_tea   := null;
     lc_indamp:= null;
     ln_nrprg := null;
     ld_fultrprg := null;
     ln_pais   := null;
     ln_tipdoc := null;
     lc_numdoc := null;
     ln_Dgr    := null;
     --
     ln_skcr   := null;
     ln_dak    := null;
     ln_dakr   := null;
     ln_dapr   := null;
     ln_pci    := null;
     ln_sin    := null;
     ln_csin   := null;
     ln_sid    := null;
     ln_sid2   := null;
     ln_ccsid  := null;
     ln_ccsid2 := null;
     ln_sis    := null;
     ln_ccsis  := null;
     ld_fot    := null;
     ld_fppk   := null;
     ld_fep    := null;
     ln_pcuo   := null;
     ln_ncpr   := null;
     ln_ncpa   := null;
     ln_ciiu   := null;
     ln_indic  := null;
     ln_lco    := null;
     ln_lcnu   := null;
     ln_cclcnu := null;
     lc_tcr    := null;
     ln_secint := null;
     lc_tcrint := null;
     ln_esam   := null;
     ln_rfa    := null;
     lc_TCRI   := null;
     lc_TSPR   := null;
     ln_CCND   := null;
     lc_CCCCND := null;
     ln_ROM    := null;
     ln_ccr    := null;
     lc_trasf  := null;
--
     
     if i.bcmod not in (144) then
         ln_skcr := pq_datos_sbs.fn_skcr(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                         i.bccta, i.ccr, i.bcsbop,i.bctop, ld_fecpro );
     else
         ln_skcr := 0;
     end if;
     if i.bcmod = 144 then
        begin
            select Case when cc.bnj096tcr = '02' then '10'
                        when cc.bnj096tcr = '03' and cc.bnj096pas = 7 then '11'
                        when cc.bnj096tcr = '03' and cc.bnj096pas = 2 then '12'
                        when cc.bnj096tcr = '04' then '13'
                        when cc.bnj096tcr = '05' then '03'
                        when cc.bnj096tcr = '06' then '01'
                        when cc.bnj096tcr = '07' then '02'
                        when cc.bnj096tcr = '08' then '05'
                        when cc.bnj096tcr = '09' then '04'
                        when cc.bnj096tcr = '10' then '06'
                        when cc.bnj096tcr = '11' then '07'
                        when cc.bnj096tcr = '12' then '08'
                        when cc.bnj096tcr = '13' then '09'
                        else cc.bnj096tcr end
              into lc_tcr
              from  bnj096 cc
             where BNJ096CTA = i.bccta
               and BNJ096OPE = i.ccr;
        exception
          when others then
            lc_tcr := null;
        end ;

     else
        lc_tcr := pq_datos_sbs.fn_tcr(i.bcrubr);
     end if;
     
     ln_cbtea := pq_datos_sbs.fn_cambia_tea(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                        i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro);
     if nvl(ln_cbtea,0) <> 0 then 
        ln_tea := ln_cbtea;
     else
        ln_tea := i.tea;
     end if;  
     if nvl(ln_tea,0) =0 then 
        ln_tea := pq_datos_sbs.fn_tea(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                        i.bccta, i.ccr, i.bcsbop,i.bctop); 
     end if;   
     ln_dak  :=  fn_dias_atraso(ld_fecpro, i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                        i.bccta, i.ccr, i.bcsbop,i.bctop,i.bcprod,i.fveg);
     --08/2018
     ln_dakr :=  fn_dias_atraso_up(ld_fecpro/*trunc(sysdate)*/, i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                        i.bccta, i.ccr, i.bcsbop,i.bctop,i.bcprod,i.fveg);
     ln_dapr := pq_datos_sbs.fn_dapr(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                     i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro);
     if i.bcmod not in (117) then
         if i.bcmod  = 141 then
            ln_pci  :=  pq_datos_sbs.fn_Saldo_relacion3(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                             i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro, 35,'27_1%'/*i.bcrubr */) +
                        pq_datos_sbs.fn_Saldo_relacion3(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                             i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro, 335,'27_1%'/*i.bcrubr */)+
                        pq_datos_sbs.fn_Saldo_relacion3(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                             i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro, 635,'27_1%'/*i.bcrubr */);
         else
             ln_pci  := pq_datos_sbs.fn_Saldo_relacion3(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                             i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro, 35,'14_9%'/*i.bcrubr */) +
                        pq_datos_sbs.fn_Saldo_relacion3(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                             i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro, 335,'14_9%'/*i.bcrubr */)+
                        pq_datos_sbs.fn_Saldo_relacion3(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                             i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro, 635,'14_9%'/*i.bcrubr */)                     ;
         end if;
         if i.bcmod not in (141) then
             pq_datos_sbs.sp_cta_saldo_relacion2(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                                i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro, 1,
                                                '14_8%', ln_sin, ln_csin);
             pq_datos_sbs.sp_cta_saldo_relacion2(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                                i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro, 430,
                                                '29_1%', ln_sid, ln_ccsid);
             pq_datos_sbs.sp_cta_saldo_relacion2(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                                i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro, 330,
                                                '29_1%', ln_sid2, ln_ccsid2);
             if nvl(ln_ccsid,0) = 0 then
                ln_ccsid := ln_ccsid2;
             end if;
             ln_sid := nvl(ln_sid,0) + nvl(ln_sid2,0);

         else
             ln_sin   := 0;
             ln_csin  := 0;
             ln_sid   := 0;
             ln_ccsid := 0;
         end if;
         if i.bcmod = 200 then
           pq_datos_sbs.sp_cta_saldo_relacion2(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                              i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro, 148,
                                              '81_4%', ln_sis, ln_ccsis);
                                           
         elsif i.bcmod not in (141)  then
           pq_datos_sbs.sp_cta_saldo_relacion2(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                              i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro, 203,
                                              '81_4%', ln_sis, ln_ccsis);
         else
           ln_sis   := 0;
           ln_ccsis := 0;

         end if;
     else
         ln_pci  := 0/*pq_datos_sbs.fn_Saldo_relacion3(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                    i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro, 735,'27_1%'\*i.bcrubr *\)*/;
         ln_sin  := 0;
         ln_csin := 0;
         ln_sid  := 0;
         ln_ccsid:= 0;
         ln_sis  := 0;
         ln_ccsis:= 0;

     end if;
     pq_datos_sbs.sp_nrprg_fultrprg (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                     i.bccta, i.ccr, i.bcsbop,i.bctop, nvl(i.n_instan,0),ld_fecpro,
                                     ln_nrprg, ld_fultrprg, lc_indamp);
     if nvl(ln_nrprg,0) = 0 then
        ld_fultrprg := null;
     else
        ld_fultrprg := pq_datos_sbs.fn_ult_rprg (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                     i.bccta, i.ccr, i.bcsbop,i.bctop, nvl(i.n_instan,0),ld_fecpro,i.bcrubr);
     end if;                                
                                     
     ld_fot  := pq_datos_sbs.fn_fot(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                    i.bccta, i.ccr, i.bcsbop,i.bctop, nvl(ln_nrprg,0) );
     pq_datos_sbs.sp_dgr_pcuo_ncpr(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                   i.bccta, i.ccr, i.bcsbop,i.bctop,nvl(ln_nrprg,0) ,ln_Dgr,ln_pcuo,ln_ncpr );
     ld_fppk := pq_datos_sbs.fn_fppk(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                    i.bccta, i.ccr, i.bcsbop,i.bctop,nvl(ln_nrprg,0), ld_fot);
     ld_fvep := pq_datos_sbs.fn_fvep(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                    i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro);
     ln_ncpa := pq_datos_sbs.fn_ncpa (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                    i.bccta, i.ccr, i.bcsbop,i.bctop,nvl(ln_nrprg,0),ld_fecpro);
     ln_ciiu := pq_datos_sbs.fn_ciiu(i.bccta);
     begin
       select w.pepais, w.petdoc, w.pendoc
         into ln_pais, ln_tipdoc, lc_numdoc 
         from  fsr008 w
        where w.pgcod = 1
          and w.ctnro = i.bccta
          and w.cttfir = 'T';
         
     exception
       when others then
          ln_pais :=604;
          ln_tipdoc:= i.tid;
          lc_numdoc:= i.nid;
     end;  
     
     ln_pais := to_number(substr(i.ccl,1,3));
     lc_mdcr := pq_datos_sbs.fn_mdcr(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                    i.bccta, i.ccr, i.bcsbop,i.bctop, ld_fecpro,
                                    i.bcrubr, i.bcprod, i.n_instan,lc_indamp,nvl(ln_nrprg,0),
                                    ln_pais, ln_tipdoc, lc_numdoc );
    
     ln_indic := pq_datos_sbs.fn_indic(i.bcmod,i.bcrubr);

     pq_datos_sbs.sp_lco_lcnu_cclcnu(i.bcemp, i.bcmod, i.cage, i.mon,
                                     i.bcpap, i.bccta, i.ccr, i.bcsbop,
                                     i.bctop, ld_fecpro, ln_skcr,i.bcrubr,
                                     ln_lco , ln_lcnu ,ln_cclcnu);
     ln_secint := pq_datos_fin_mes.fn_cod_interno_pqn (i.bcmod, i.cage, i.mon,
                                     i.bcpap, i.bccta, i.ccr, i.bcsbop,
                                     i.bctop,ld_fecpro);
     lc_tcrint := pq_datos_sbs.fn_tcrint(i.bcrubr,nvl(ln_secint,0));
     ln_esam   := pq_datos_sbs.fn_esam(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                    i.bccta, i.ccr, i.bcsbop,i.bctop);
     ln_rfa    := 1; -- No refianicamos con recate agropecuario
     lc_tcri   := pq_datos_sbs.fn_tcri(i.bcrubr,nvl(ln_secint,0));
     lc_TSPR   := pq_datos_sbs.fn_tspi(i.bcmod,i.bctop);
     /*ln_CCND   := ln_lcnu;
     lc_CCCCND := ln_cclcnu;*/
     ln_rom    := pq_datos_sbs.fn_rom(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                     i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro);
     -- verifica si la linea fue desembolsada
     lc_deslin := pq_datos_sbs.fn_deslin(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                    i.bccta, i.ccr, i.bcsbop,i.bctop);
     if nvl(lc_deslin,'N') = 'S' and  i.bcmod in (116,117) then
        ln_CCND   := null;
        lc_CCCCND := null;
     elsif nvl(lc_deslin,'N') = 'N' and  i.bcmod in (116,117) then
        ln_CCND   := ln_lcnu;
        lc_CCCCND := ln_cclcnu;
        ln_lcnu   := null;
        ln_cclcnu := null;
     else
        ln_CCND   := null;
        lc_CCCCND := null;
        ln_lcnu   := null;
        ln_cclcnu := null;
     end if;
     if i.bcmod = 117 then
        ln_skcr := 0;
        ln_ccr  := '117'||lpad(i.bctop,2,0)||i.ccr;
        ln_pcuo := 0;
     else
        ln_ccr  := i.ccr;
     end if;
     Case when substr(i.bcrubr,9,2) = '01' then
               lc_tipoc :='Revolvente' ;
          else
               lc_tipoc :=null;
     end case;
     lc_trasf := pq_datos_sbs.fn_cartrasferida(i.bccta,i.ccr);
     --- Quitar los que no tienen saldo
     if ln_skcr = 0
         and ln_pci = 0
         and i.kvi = 0
         and i.kre = 0
         and i.krf = 0
         and i.kve = 0
         and i.kju = 0
         and i.kco = 0
         and ln_sin = 0
         and ln_sid = 0
         and ln_sis = 0
         and nvl(ln_lco, 0) = 0
         and nvl(ln_lcnu, 0) = 0
         and i.bcprod = 99 then 
         null;
     else     
     
     begin
       insert into  BDC01  (ccl,csbs,tid,nid,ncl,ccr,mon,morg,
                          skcr,tcr,cal,calint,dak,dakr,dapr,
                          pci,kvi,ccvi,kre,ccre,krf,ccrf,
                          kve,ccve,kju,ccju,kco,ccco,fcc,
                          sin,ccsin,sid,ccsid,sis,ccsis,fot,
                          esam,Dgr,fppk,fveg,fvep,pcuo,ncpr,
                          ncpa,ciiu,tpr,rfa,cage,csec,tea,
                          mdcr,nrprg,fultrprg,indic,
                          lco,lcnu,cclcnu ,tcrint,D_FECPRO,
                          TCRI,TSPR,CCND,CCCCND,ROM,TIPOC,CRACL)--- ultimos
        values (i.ccl,nvl(i.csbs,'0000000000'),i.tid,i.nid,i.ncl,ln_ccr,i.mone,
             Case when i.bcmod <> 116 and ln_skcr > i.morg then ln_skcr else i.morg end,
             ln_skcr,
             lc_tcr,
             i.cal,i.calint,
             case when ln_dak < 0 then 0 else ln_dak end,
             ln_dakr,
             ln_dapr,
             ln_pci,
             i.kvi,i.ccvi,i.kre,i.ccre,i.krf,i.ccrf,
             i.kve,i.ccve,i.kju,i.ccju,i.kco,i.ccco,
             i.fcc,
             ln_sin,
             ln_csin,
             ln_sid,
             ln_ccsid,
             ln_sis,
             ln_ccsis,
             nvl(ld_fot,ld_fvep),
             ln_esam,
             ln_Dgr,
             ld_fppk,
             i.fveg,
             ld_fvep,
             ln_pcuo,
             ln_ncpr,
             ln_ncpa,
             ln_ciiu,
             i.tpr,
             ln_rfa,
             i.cage,i.csec,ln_tea,--i.tea,
             lc_mdcr,
             ln_nrprg,
             ld_fultrprg,
             ln_indic,
             ln_lco,
             ln_lcnu,
             ln_cclcnu,
             lc_tcrint,
             i.d_fecpro,
             ---
             lc_TCRI,
             lc_TSPR,
             ln_CCND,
             lc_CCCCND,
             ln_ROM,
             lc_tipoc,
             lc_trasf
             );
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'DATABCD1',lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;
     commit;
    end if; 
  end loop;
  commit;
  update  tab_jobs  g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'BDC1';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update  tab_jobs  g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'BDC1';
    commit;
    return;

end sp_procesa_BDC01;
function fn_scom(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                           pn_pap in number, pn_cta in number, pn_oper in number,
                           pn_sbop in number,pn_top in number, pd_fecpro in date) return number is
ln_611 number;
ln_002 number;
ln_scom number;
begin
  begin
      select sum((PP1IMP1 +/*PPIMP2+PPIMP3+*/PP1IMP4+PP1IMP5+PP1IMP6+PP1IMP7+PP1IMP8+PP1IMP9+
              PP1IMP10	+PP1IMP11+PP1IMP12+PP1IMP13+PP1IMP14+PP1IMP15+PP1IMP16+PP1IMP17+
              PP1IMP18	+PP1IMP19+PP1IMP20))
       into ln_611
       from  fsd612
      where PGCOD	= pn_emp
        and PPMOD	= pn_mod
        and PPSUC	= pn_suc
        and PPMDA	= pn_mda
        and PPPAP	= pn_pap
        and PPCTA	= pn_cta
        and PPOPER = pn_oper
        and PPSBOP = pn_sbop
        and PPTOPE = pn_top
        and PPFPAG = pd_fecpro;
  exception
      when others then
         ln_611 := 0;
  end;
  begin
      select sum(pp002imp)
       into ln_002
       from  fpp002
      where PGCOD	= pn_emp
        and PPMOD	= pn_mod
        and PPSUC	= pn_suc
        and PPMDA	= pn_mda
        and PPPAP	= pn_pap
        and PPCTA	= pn_cta
        and PPOPER = pn_oper
        and PPSBOP = pn_sbop
        and PPTOPE = pn_top
        and PPFPAG = pd_fecpro;
  exception
      when others then
         ln_002 := 0;
  end;
   ln_scom := nvl(ln_611,0) + nvl(ln_002,0);
   return ln_scom;
end fn_scom;

function fn_sim(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                           pn_pap in number, pn_cta in number, pn_oper in number,
                           pn_sbop in number,pn_top in number, pn_capcuo in number, pn_diaatr in number) return number is
ln_sim number;
ln_tasmor number;
begin
  begin
   select ((aotmor/360)/100)
     into ln_tasmor
     from  FSD010
    WHERE PGCOD = pn_emp
      and AOMOD	= pn_mod
      and AOSUC	= pn_suc
      and AOMDA	= pn_mda
      and AOPAP	= pn_pap
      and AOCTA	= pn_cta
      and AOOPER	= pn_oper
      and AOSBOP	= pn_sbop
      and AOTOPE	= pn_top;
  exception
      when others then
         ln_tasmor := 0;
  end;
  ln_sim := round((pn_capcuo * ln_tasmor)* pn_diaatr,2);
  return ln_sim;
end fn_sim;
Procedure sp_job_procesa_BDC02 (pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is
  select sucurs from   fst001 where pgcod =1 ;
  begin
     /*begin
         select host_name
           into lc_hostname
           from v$instance;
     end;*/
--      lc_hostname := 'SC01ZDBADM010101';
     execute immediate ('truncate table  BDC02 ');
     execute immediate ('alter session set parallel_force_local=TRUE');--jflor 2014.01.16
     delete  tab_jobs  where  c_Codage = 'BDC2';
     commit;
     for i in sucursal loop
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_sbs.sp_procesa_BDC02('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
        --if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
        if sys.fn_bd_IsRAC='TRUE' then
            --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
            DBMS_JOB.SUBMIT(job => ln_job,
                          what => lc_variable,
                          next_date => sysdate+1/(24*180),
                          interval => null,
                          no_parse => false,
                          instance => 2,
                          force => false
                          );
            INSERT INTO  tab_jobs  (c_Codage,n_Numer1,c_detjob)
            VALUES('BDC2',ln_ini,lc_variable);
            COMMIT;
         else
            DBMS_JOB.SUBMIT(job => ln_job,
                          what => lc_variable,
                          next_date => sysdate+1/(24*180),
                          interval => null,
                          no_parse => false,
                          force => false
                          );
            INSERT INTO  tab_jobs  (c_Codage,n_Numer1,c_detjob)
            VALUES('BDC2',ln_ini,lc_variable);
            COMMIT;
         end if;
      end loop;
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'BDC02',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

  end;

Procedure sp_procesa_BDC02 (pn_numsuc in number,  pd_fecpro in varchar2 ) is

  ld_fecpro date ;
  lc_coderr varchar2(300);

  cursor prestamo is
    /*select distinct ccl,bcemp,bcpap,bccta,bcsbop,
           bctop,bcmod,ccr,mon,cage,bcprod
      from JAQL120
     where cage = pn_numsuc
       and d_fecpro = ld_fecpro;*/
    select distinct a.ccl,a.bcemp,a.bcpap,a.bccta,a.bcsbop,
           a.bctop,a.bcmod,a.ccr,a.mon,a.cage,a.bcprod,a.d_fecpro, b.nrprg
      from jaql120 a, bdc01 b
     where a.cage = pn_numsuc
       and a.d_fecpro = ld_fecpro
       and a.ccr = b.ccr (+)
       and a.ccl = b.ccl (+);   


  cursor calendario (ln_emp in number, ln_suc in number, ln_mod in number,
                     ln_pap in number, ln_mda in number, ln_cta in number,
                     ln_oper in number, ln_sbop in number, ln_tope in number  ) is
  select case when d601.ppmda = 0 then 'PEN' else 'USD' end moneda,
         decode(sum(d602.pp1cap),null,sum(d601.ppcap),sum(d602.pp1cap) )  capital,
         sum(d601.ppcap) capital_c,
         sum(d601.ppcap) - sum(d602.pp1cap)  capital_m,
         decode(sum(d602.pp1int),null,sum(d601.ppint),sum(d602.pp1int) ) interes,
         sum(d601.ppint) interes_c,
         sum(d602.pp1intm) mora, max(d602.pp1stat) stat,d601.ppsbop,
         d601.ppfvto fecvto, max(d602.pp1fech) fecpag
 from    FSD602 d602,   FSD601 d601
      where d602.pgcod (+)   = d601.pgcod
        and d602.ppmod (+)   = d601.ppmod
        and d602.ppsuc (+)   = d601.ppsuc
        and d602.ppmda (+)   = d601.ppmda
        and d602.pppap (+)   = d601.pppap
        and d602.ppcta (+)   = d601.ppcta
        and d602.ppoper (+)  = d601.ppoper
        and d602.ppsbop (+)  = d601.ppsbop
        and d602.pptope  (+) = d601.pptope
        and d602.ppfpag (+)  = d601.ppfpag
        and d602.pp1fech (+) <= ld_fecpro
        -- 08/2018
        and d601.ppcap + d601.ppint <> 0
        and d602.pp1salmor (+) = 0
        and d601.d601co   = 'S'
        --- 08/2018
        and d601.ppfpag <=  ld_fecpro --between add_months( to_date('20140531','yyyymmdd'), -6) and  to_date('20140531','yyyymmdd')  -- add_months(trunc(sysdate),-6) and trunc(sysdate)
        and d601.ppfvto <=  ld_fecpro
        --and d602.pp1stat (+) = 'T'
        and d602.d602co  (+) = 'S'
        and d601.pgcod    = ln_emp
        and d601.ppmod    = ln_mod
        and d601.ppsuc    = ln_suc
        and d601.ppmda    = ln_mda
        and d601.pppap    = ln_pap
        and d601.ppcta    = ln_cta
        and d601.ppoper   = ln_oper
        and d601.ppsbop   = ln_sbop
        and d601.pptope   = ln_tope
group by d601.ppmda, d601.ppfvto,d601.ppsbop
order by d601.ppfvto  ;

cursor calendario2 (ln_emp in number, ln_suc in number, ln_mod in number,
                     ln_pap in number, ln_mda in number, ln_cta in number,
                     ln_oper in number, ln_sbop in number, ln_tope in number  ) is
  select case when d601.ppmda = 0 then 'PEN' else 'USD' end moneda,
         decode(sum(d602.pp1cap),null,sum(d601.ppcap),sum(d602.pp1cap) )  capital,
         sum(d601.ppcap) capital_c,
         sum(d601.ppcap) - sum(d602.pp1cap)  capital_m,
         decode(sum(d602.pp1int),null,sum(d601.ppint),sum(d602.pp1int) ) interes,
         sum(d601.ppint) interes_c,
         sum(d602.pp1intm) mora,max(d602.pp1stat) stat, d601.ppsbop,
         d601.ppfvto fecvto, max(d602.pp1fech) fecpag
 from    FSD602 d602,    FSD601 d601
      where d602.pgcod (+)   = d601.pgcod
        and d602.ppmod (+)   = d601.ppmod
        and d602.ppsuc (+)   = d601.ppsuc
        and d602.ppmda (+)   = d601.ppmda
        and d602.pppap (+)   = d601.pppap
        and d602.ppcta (+)   = d601.ppcta
        and d602.ppoper (+)  = d601.ppoper
        and d602.ppsbop (+)  = d601.ppsbop
        and d602.pptope  (+) = d601.pptope
        and d602.ppfpag (+)  = d601.ppfpag
        and d602.pp1fech (+) <= ld_fecpro
        -- 08/2018
        and d601.ppcap + d601.ppint <> 0
        and d602.pp1salmor (+) = 0
        and d601.d601co   = 'S'
        --- 08/2018
        and d601.ppfpag <=  ld_fecpro --between add_months( to_date('20140531','yyyymmdd'), -6) and  to_date('20140531','yyyymmdd')  -- add_months(trunc(sysdate),-6) and trunc(sysdate)
        and d601.ppfvto <=  ld_fecpro
        --and d602.pp1stat (+) = 'T'
        and d602.d602co  (+) = 'S'
        and d601.pgcod    = ln_emp
        and d601.ppmod    = ln_mod
        --and d601.ppsuc    = ln_suc
        and d601.ppmda    = ln_mda
        and d601.pppap    = ln_pap
        and d601.ppcta    = ln_cta
        and d601.ppoper   = ln_oper
        and d601.ppsbop   = ln_sbop
        and d601.pptope   = ln_tope
group by d601.ppmda, d601.ppfvto, d601.ppsbop
order by d601.ppfvto  ;

cursor cal_reprogra (ln_emp in number, ln_suc in number, ln_mod in number,
                     ln_pap in number, ln_mda in number, ln_cta in number,
                     ln_oper in number, ln_sbop in number, ln_tope in number  ) is
  select case when d601.ppmda = 0 then 'PEN' else 'USD' end moneda,
         decode(sum(d602.pp1cap),null,sum(d601.ppcap),sum(d602.pp1cap) )  capital,
         sum(d601.ppcap) capital_c,
         sum(d601.ppcap) - sum(d602.pp1cap)  capital_m,
         decode(sum(d602.pp1int),null,sum(d601.ppint),sum(d602.pp1int) ) interes,
         sum(d601.ppint) interes_c,
         sum(d602.pp1intm) mora,d601.ppsbop,max(d602.pp1stat) stat,
         d601.ppfvto fecvto, max(d602.pp1fech) fecpag
 from    FSD602 d602,    FSD601 d601
      where d602.pgcod (+)   = d601.pgcod
        and d602.ppmod (+)   = d601.ppmod
        and d602.ppsuc (+)   = d601.ppsuc
        and d602.ppmda (+)   = d601.ppmda
        and d602.pppap (+)   = d601.pppap
        and d602.ppcta (+)   = d601.ppcta
        and d602.ppoper (+)  = d601.ppoper
        and d602.ppsbop (+)  = d601.ppsbop
        and d602.pptope  (+) = d601.pptope
        and d602.ppfpag (+)  = d601.ppfpag
        -- 08/2018
        and d601.ppcap + d601.ppint <> 0
        and d602.pp1salmor (+) = 0
        and d601.d601co   = 'S'
        --- 08/2018
        and d602.pp1fech (+) <= ld_fecpro
        --and d601.ppfpag <=  ld_fecpro --between add_months( to_date('20140531','yyyymmdd'), -6) and  to_date('20140531','yyyymmdd')  -- add_months(trunc(sysdate),-6) and trunc(sysdate)
        --and d601.ppfvto <=  ld_fecpro
        --and d602.pp1stat (+) = 'T'
        and d602.d602co  (+) = 'S'
        and d601.pgcod    = ln_emp
        and d601.ppmod    = ln_mod
        --and d601.ppsuc    = ln_suc
        and d601.ppmda    = ln_mda
        and d601.pppap    = ln_pap
        and d601.ppcta    = ln_cta
        and d601.ppoper   = ln_oper
        and d601.ppsbop   <> ln_sbop
        and d601.pptope   = ln_tope
         --- excluir reprogrmaciones ampleaciones refinanciaciones 
        and (d602.d602mo, d602.d602tr)  not in ( select tp1nro1, tp1nro2
                                                   from fst198
                                                  where tp1cod1 = 11124
                                                    and tp1cod = 1
                                                    and tp1corr1 = 1
                                                    and tp1corr2 = 1 )
group by d601.ppmda, d601.ppfvto,d601.ppsbop 
order by d601.ppfvto ;

 cursor pagadela (ln_emp in number, ln_suc in number, ln_mod in number,
                     ln_pap in number, ln_mda in number, ln_cta in number,
                     ln_oper in number, ln_sbop in number, ln_tope in number  ) is
  select case when d601.ppmda = 0 then 'PEN' else 'USD' end moneda,
         decode(sum(d602.pp1cap),null,sum(d601.ppcap),sum(d602.pp1cap) )  capital,
         sum(d601.ppcap) capital_c,
         sum(d601.ppcap) - sum(d602.pp1cap)  capital_m,
         decode(sum(d602.pp1int),null,sum(d601.ppint),sum(d602.pp1int) ) interes,
         sum(d601.ppint) interes_c,
         sum(d602.pp1intm) mora,d601.ppsbop,
         d601.ppfvto fecvto, max(d602.pp1fech) fecpag
 from   FSD602 d602,   FSD601 d601
      where d602.pgcod  = d601.pgcod
        and d602.ppmod  = d601.ppmod
        and d602.ppsuc  = d601.ppsuc
        and d602.ppmda  = d601.ppmda
        and d602.pppap  = d601.pppap
        and d602.ppcta  = d601.ppcta
        and d602.ppoper = d601.ppoper
        and d602.ppsbop = d601.ppsbop
        and d602.pptope = d601.pptope
        and d602.ppfpag = d601.ppfpag
        -- 08/2018
        and d601.ppcap + d601.ppint <> 0
        and d602.pp1salmor = 0
        and d601.d601co   = 'S'
        --- 08/2018
        and d602.pp1fech <= ld_fecpro
        and d602.ppfpag > ld_fecpro
        and d602.pp1stat  = 'T'
        and d602.d602co   = 'S'
        and d601.pgcod    = ln_emp
        and d601.ppmod    = ln_mod
        and d601.ppsuc    = ln_suc
        and d601.ppmda    = ln_mda
        and d601.pppap    = ln_pap
        and d601.ppcta    = ln_cta
        and d601.ppoper   = ln_oper
        and d601.ppsbop   = ln_sbop
        and d601.pptope   = ln_tope
group by d601.ppmda, d601.ppfvto,d601.ppsbop
order by d601.ppfvto  ;

ln_scom  number;
ln_sim   number;
ln_diaart number;
ln_cap number;
ln_int number;
ln_mor number;
ln_otr number;
ln_tipcam number;
ld_fecini date;
ln_numcuo number;
lc_trasf varchar2(1);
begin

  update  tab_jobs  g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'BDC2';
  commit;

  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');
  ld_fecini := ld_fecpro - (to_number(to_char(ld_fecpro,'DD')) - 1);

  begin
       select cotcbi
         into ln_tipcam
         from  fsh005
        where cofdes  = ld_fecpro
          and moneda = 101;
  exception
      when others then
        begin
          select cotcbi
            into ln_tipcam
            from  fsh005
           where cofdes between ld_fecini and ld_fecpro
             and moneda = 101
             and rownum = 1
           order by  cofdes desc;
        exception
           when others then
              ln_tipcam :=  3.273;
        end;
  end;

  for i in prestamo loop
     ln_numcuo := 0;
     if nvl(i.nrprg,0) = 0 then 
     for f in calendario (i.bcemp,i.cage, i.bcmod, i.bcpap, i.mon, i.bccta, i.ccr, i.bcsbop, i.bctop) loop
         ln_numcuo := ln_numcuo + 1;
         ln_sim := null;
         ln_scom := null;
         ln_cap := null;
         ln_int := null;
         ln_mor := null;
         ln_otr := null;
         begin
           ln_scom := pq_datos_sbs.fn_scom (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                            i.bccta, i.ccr, i.bcsbop,i.bctop,f.fecvto);
           
           --08/2018
           if nvl(f.stat,'X') = 'P'  then 
              ln_diaart :=  (ld_fecpro - f.fecvto);
           else
              ln_diaart :=  (nvl(f.fecpag,ld_fecpro) - f.fecvto);
           end if; 
           --08/2018
           if ln_diaart < 0 then
              ln_diaart := 0;
           else
              --08/2018
              if nvl(f.stat,'X') = 'P' /*f.fecpag is null */ and ln_diaart > 0 then 
                  ln_sim  := abs(pq_datos_sbs.fn_sim (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                                  i.bccta, i.ccr, i.bcsbop,i.bctop,f.capital_m,ln_diaart));
              elsif f.fecpag is null  and ln_diaart > 0 then 
                  ln_sim  := abs(pq_datos_sbs.fn_sim (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                                  i.bccta, i.ccr, i.bcsbop,i.bctop,f.capital,ln_diaart));
            
              elsif f.fecpag is not null  then 
                  ln_sim := f.mora;
              end if;   
              --08/2018
              /*if f.fecpag is null and ln_diaart > 0 then 
                  ln_sim  := abs(pq_datos_sbs.fn_sim (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                                  i.bccta, i.ccr, i.bcsbop,i.bctop,f.capital,ln_diaart));
              elsif f.fecpag is not null then 
                  ln_sim := f.mora;
              end if;*/    
           end if;
           if i.mon = 101 then
              --08/2018
              if nvl(f.stat,'X') = 'P'  then 
                  ln_cap := round(f.capital_c * ln_tipcam,2);
                  ln_int := round(f.interes_c * ln_tipcam,2);
              else
                  ln_cap := round(f.capital * ln_tipcam,2);
                  ln_int := round(f.interes * ln_tipcam,2);
              end if; 
              --08/2018
              
              ln_mor := round(ln_sim * ln_tipcam,2);
              ln_otr := round(ln_scom * ln_tipcam,2);
           else
              --08/2018
              if nvl(f.stat,'X') = 'P'  then 
                  ln_cap := round(f.capital_c,2);
                  ln_int := round(f.interes_c,2);
              else
                  ln_cap := round(f.capital,2);
                  ln_int := round(f.interes,2);
              end if; 
              --08/2018
              
              ln_mor := round(ln_sim ,2);
              ln_otr := round(ln_scom,2);
           end if;
           lc_trasf := pq_datos_sbs.fn_cartrasferida(i.bccta,i.ccr);
           if nvl(f.stat,'X') <> 'P' and  f.fecvto <= ld_fecpro then  
               insert into  BDC02  (ccl,ccr,ncuo,mon,mcuo,
                                  sic, scom, sim, fvep, fcan,CRACL,Hora)
                values (i.ccl, i.ccr,ln_numcuo,f.moneda,ln_cap,
                        ln_int,ln_otr,ln_mor, f.fecvto, f.fecpag,lc_trasf,f.ppsbop);
           elsif nvl(f.stat,'X') = 'P' and  f.fecvto <= ld_fecpro then 
               insert into  BDC02  (ccl,ccr,ncuo,mon,mcuo,
                                  sic, scom, sim, fvep, fcan,CRACL,Hora)
                values (i.ccl, i.ccr,ln_numcuo,f.moneda,ln_cap,
                        ln_int,ln_otr,ln_mor, f.fecvto, null,lc_trasf,f.ppsbop);
           end if;             
         exception
         when others then
               lc_coderr:=sqlerrm;
               INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
               VALUES(0,'DATABDC2',lc_coderr, TRUNC(SYSDATE));
               COMMIT;
         end;
         commit;
      end loop;
      if   ln_numcuo = 0 then
        for f in calendario2 (i.bcemp,i.cage, i.bcmod, i.bcpap, i.mon, i.bccta, i.ccr, i.bcsbop, i.bctop) loop
         ln_numcuo := ln_numcuo + 1;
         ln_sim := null;
         ln_scom := null;
         ln_cap := null;
         ln_int := null;
         ln_mor := null;
         ln_otr := null;
         begin
           ln_scom := pq_datos_sbs.fn_scom (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                            i.bccta, i.ccr, i.bcsbop,i.bctop,f.fecvto);
           --08/2018
           if nvl(f.stat,'X') = 'P'  then 
              ln_diaart :=  (ld_fecpro - f.fecvto);
           else
              ln_diaart :=  (nvl(f.fecpag,ld_fecpro) - f.fecvto);
           end if; 
           --08/2018
           if ln_diaart < 0 then
              ln_diaart := 0;
           else
              ln_sim  := pq_datos_sbs.fn_sim (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                              i.bccta, i.ccr, i.bcsbop,i.bctop,f.capital,ln_diaart);
           end if;
           /*if f.mora is null then
              ln_sim:=0;
           else
              ln_sim := f.mora;
           end if; */
           if i.mon = 101 then
              --08/2018
              if nvl(f.stat,'X') = 'P'  then 
                  ln_cap := round(f.capital_c * ln_tipcam,2);
                  ln_int := round(f.interes_c * ln_tipcam,2);
              else
                  ln_cap := round(f.capital * ln_tipcam,2);
                  ln_int := round(f.interes * ln_tipcam,2);
              end if; 
              --08/2018
              
              ln_mor := round(ln_sim * ln_tipcam,2);
              ln_otr := round(ln_scom * ln_tipcam,2);
           else
              --08/2018
              if nvl(f.stat,'X') = 'P'  then 
                  ln_cap := round(f.capital_c,2);
                  ln_int := round(f.interes_c,2);
              else
                  ln_cap := round(f.capital,2);
                  ln_int := round(f.interes,2);
              end if; 
              --08/2018
              
              ln_mor := round(ln_sim ,2);
              ln_otr := round(ln_scom,2);
           end if;
           lc_trasf := pq_datos_sbs.fn_cartrasferida(i.bccta,i.ccr);
           /*lc_hortra := pq_datos_sbs.fn_hora_trasn(i.bcemp, i.bcmod,i.cage, i.bcpap,
                                                    i.mon, i.bccta, i.ccr, i.bcsbop,
                                                    i.bctop, f.fecpag);*/
           
                    
           if nvl(f.stat,'X') <> 'P' and  f.fecvto <= ld_fecpro then  
              insert into  BDC02  (ccl,ccr,ncuo,mon,mcuo,
                              sic, scom, sim, fvep, fcan,CRACL,Hora)
              values (i.ccl, i.ccr,ln_numcuo,f.moneda,ln_cap,
                    ln_int,ln_otr,ln_mor, f.fecvto, f.fecpag,lc_trasf,f.ppsbop);
           elsif nvl(f.stat,'X') = 'P' and  f.fecvto <= ld_fecpro then 
               insert into  BDC02  (ccl,ccr,ncuo,mon,mcuo,
                                  sic, scom, sim, fvep, fcan,CRACL,Hora)
                values (i.ccl, i.ccr,ln_numcuo,f.moneda,ln_cap,
                        ln_int,ln_otr,ln_mor, f.fecvto, null,lc_trasf,f.ppsbop);
           end if;
                    
         exception
         when others then
               lc_coderr:=sqlerrm;
               INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
               VALUES(0,'DATABDC2',lc_coderr, TRUNC(SYSDATE));
               COMMIT;
         end;
         commit;
      end loop;
      end if;
      else
         for f in cal_reprogra (i.bcemp,i.cage, i.bcmod, i.bcpap, i.mon, i.bccta, i.ccr, i.bcsbop, i.bctop) loop
         ln_numcuo := ln_numcuo + 1;
         ln_sim := null;
         ln_scom := null;
         ln_cap := null;
         ln_int := null;
         ln_mor := null;
         ln_otr := null;
         begin
           ln_scom := pq_datos_sbs.fn_scom (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                            i.bccta, i.ccr, f.ppsbop,i.bctop,f.fecvto);
           --08/2018
           if nvl(f.stat,'X') = 'P'  then 
              ln_diaart :=  (ld_fecpro - f.fecvto);
           else
              ln_diaart :=  (nvl(f.fecpag,ld_fecpro) - f.fecvto);
           end if; 
           --08/2018
           if ln_diaart < 0 then
              ln_diaart := 0;
           else
              ln_sim  := f.mora;/*pq_datos_sbs.fn_sim (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                              i.bccta, i.ccr, f.ppsbop,i.bctop,f.capital,ln_diaart);*/
           end if;
           /*if f.mora is null then
              ln_sim:=0;
           else
              ln_sim := f.mora;
           end if; */
           if i.mon = 101 then
              --08/2018
              if nvl(f.stat,'X') = 'P'  then 
                  ln_cap := round(f.capital_c * ln_tipcam,2);
                  ln_int := round(f.interes_c * ln_tipcam,2);
              else
                  ln_cap := round(f.capital * ln_tipcam,2);
                  ln_int := round(f.interes * ln_tipcam,2);
              end if; 
              --08/2018
              
              ln_mor := round(ln_sim * ln_tipcam,2);
              ln_otr := round(ln_scom * ln_tipcam,2);
           else
              --08/2018
              if nvl(f.stat,'X') = 'P'  then 
                  ln_cap := round(f.capital_c,2);
                  ln_int := round(f.interes_c,2);
              else
                  ln_cap := round(f.capital,2);
                  ln_int := round(f.interes,2);
              end if; 
              --08/2018
              
              ln_mor := round(ln_sim ,2);
              ln_otr := round(ln_scom,2);
           end if;
           lc_trasf := pq_datos_sbs.fn_cartrasferida(i.bccta,i.ccr);
           /*lc_hortra := pq_datos_sbs.fn_hora_trasn(i.bcemp, i.bcmod,i.cage, i.bcpap,
                                                    i.mon, i.bccta, i.ccr, i.bcsbop,
                                                    i.bctop, f.fecpag);*/
           
           if nvl(f.stat,'X') <> 'P' /*and  f.fecvto <= ld_fecpro*/ then  
                -- aqui para cuotas reprogramadas aparesca sin pago
                --
                insert into  BDC02  (ccl,ccr,ncuo,mon,mcuo,
                              sic, scom, sim, fvep, fcan,CRACL,Hora)
                values (i.ccl, i.ccr,ln_numcuo,f.moneda,ln_cap,
                    ln_int,ln_otr,ln_mor, f.fecvto, f.fecpag,lc_trasf,f.ppsbop);
           end if; 
           
          
         exception
         when others then
               lc_coderr:=sqlerrm;
               INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
               VALUES(0,'DATABDC2',lc_coderr, TRUNC(SYSDATE));
               COMMIT;
         end;
         commit;
      end loop;
      ln_numcuo := 0;
      for f in calendario (i.bcemp,i.cage, i.bcmod, i.bcpap, i.mon, i.bccta, i.ccr, i.bcsbop, i.bctop) loop
         ln_numcuo := ln_numcuo + 1;
         ln_sim := null;
         ln_scom := null;
         ln_cap := null;
         ln_int := null;
         ln_mor := null;
         ln_otr := null;
         begin
           ln_scom := pq_datos_sbs.fn_scom (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                            i.bccta, i.ccr, i.bcsbop,i.bctop,f.fecvto);
           --08/2018
           if nvl(f.stat,'X') = 'P'  then 
              ln_diaart :=  (ld_fecpro - f.fecvto);
           else
              ln_diaart :=  (nvl(f.fecpag,ld_fecpro) - f.fecvto);
           end if;
           --08/2018
           if ln_diaart < 0 then
              ln_diaart := 0;
           else
              --08/2018
              if nvl(f.stat,'X') = 'P' /*f.fecpag is null */ and ln_diaart > 0 then 
                  ln_sim  := abs(pq_datos_sbs.fn_sim (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                                  i.bccta, i.ccr, i.bcsbop,i.bctop,f.capital_m,ln_diaart));
              elsif f.fecpag is null  and ln_diaart > 0 then 
                  ln_sim  := abs(pq_datos_sbs.fn_sim (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                                  i.bccta, i.ccr, i.bcsbop,i.bctop,f.capital,ln_diaart));
            
              elsif f.fecpag is not null  then 
                  ln_sim := f.mora;
              end if;   
              --08/2018
           end if;
           /*if f.mora is null then
              ln_sim:=0;
           else
              ln_sim := f.mora;
           end if; */
           if i.mon = 101 then
              --08/2018
              if nvl(f.stat,'X') = 'P'  then 
                  ln_cap := round(f.capital_c * ln_tipcam,2);
                  ln_int := round(f.interes_c * ln_tipcam,2);
              else
                  ln_cap := round(f.capital * ln_tipcam,2);
                  ln_int := round(f.interes * ln_tipcam,2);
              end if;
              --08/2018
              
              ln_mor := round(ln_sim * ln_tipcam,2);
              ln_otr := round(ln_scom * ln_tipcam,2);
           else
              --08/2018
              if nvl(f.stat,'X') = 'P'  then 
                  ln_cap := round(f.capital_c ,2);
                  ln_int := round(f.interes_c,2);
              else
                  ln_cap := round(f.capital ,2);
                  ln_int := round(f.interes,2);
              end if;
              --08/2018
              
              ln_mor := round(ln_sim ,2);
              ln_otr := round(ln_scom,2);
           end if;
           lc_trasf := pq_datos_sbs.fn_cartrasferida(i.bccta,i.ccr);
           if nvl(f.stat,'X') <> 'P' and  f.fecvto <= ld_fecpro then  
               insert into  BDC02  (ccl,ccr,ncuo,mon,mcuo,
                                  sic, scom, sim, fvep, fcan,CRACL,HORA)
                values (i.ccl, i.ccr,ln_numcuo,f.moneda,ln_cap,
                        ln_int,ln_otr,ln_mor, f.fecvto, f.fecpag,lc_trasf,f.ppsbop);
           elsif nvl(f.stat,'X') = 'P' and  f.fecvto <= ld_fecpro then 
               insert into  BDC02  (ccl,ccr,ncuo,mon,mcuo,
                                  sic, scom, sim, fvep, fcan,CRACL,Hora)
                values (i.ccl, i.ccr,ln_numcuo,f.moneda,ln_cap,
                        ln_int,ln_otr,ln_mor, f.fecvto, null,lc_trasf,f.ppsbop);
           end if;  
         exception
         when others then
               lc_coderr:=sqlerrm;
               INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
               VALUES(0,'DATABDC2',lc_coderr, TRUNC(SYSDATE));
               COMMIT;
         end;
         commit;
      end loop;
      if   ln_numcuo = 0 then
        for f in calendario2 (i.bcemp,i.cage, i.bcmod, i.bcpap, i.mon, i.bccta, i.ccr, i.bcsbop, i.bctop) loop
         ln_numcuo := ln_numcuo + 1;
         ln_sim := null;
         ln_scom := null;
         ln_cap := null;
         ln_int := null;
         ln_mor := null;
         ln_otr := null;
         begin
           ln_scom := pq_datos_sbs.fn_scom (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                            i.bccta, i.ccr, i.bcsbop,i.bctop,f.fecvto);
           --08/2018
           if nvl(f.stat,'X') = 'P'  then 
              ln_diaart :=  (ld_fecpro - f.fecvto);
           else
              ln_diaart :=  (nvl(f.fecpag,ld_fecpro) - f.fecvto);
           end if;
           --08/2018
           if ln_diaart < 0 then
              ln_diaart := 0;
           else
              ln_sim  := pq_datos_sbs.fn_sim (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                              i.bccta, i.ccr, i.bcsbop,i.bctop,f.capital,ln_diaart);
           end if;
           /*if f.mora is null then
              ln_sim:=0;
           else
              ln_sim := f.mora;
           end if; */
           if i.mon = 101 then
              --08/2018
              if nvl(f.stat,'X') = 'P'  then 
                  ln_cap := round(f.capital_c * ln_tipcam,2);
                  ln_int := round(f.interes_c * ln_tipcam,2);
              else
                  ln_cap := round(f.capital * ln_tipcam,2);
                  ln_int := round(f.interes * ln_tipcam,2);
              end if;
              --08/2018
              ln_mor := round(ln_sim * ln_tipcam,2);
              ln_otr := round(ln_scom * ln_tipcam,2);
           else
              --08/2018
              if nvl(f.stat,'X') = 'P'  then 
                  ln_cap := round(f.capital_c ,2);
                  ln_int := round(f.interes_c,2);
              else
                  ln_cap := round(f.capital ,2);
                  ln_int := round(f.interes,2);
              end if;
              --08/2018
              
              
              ln_mor := round(ln_sim ,2);
              ln_otr := round(ln_scom,2);
           end if;
           lc_trasf := pq_datos_sbs.fn_cartrasferida(i.bccta,i.ccr);
           /*lc_hortra := pq_datos_sbs.fn_hora_trasn(i.bcemp, i.bcmod,i.cage, i.bcpap,
                                                    i.mon, i.bccta, i.ccr, i.bcsbop,
                                                    i.bctop, f.fecpag);*/
           insert into  BDC02  (ccl,ccr,ncuo,mon,mcuo,
                              sic, scom, sim, fvep, fcan,CRACL,Hora)
            values (i.ccl, i.ccr,ln_numcuo,f.moneda,ln_cap,
                    ln_int,ln_otr,ln_mor, f.fecvto, decode( nvl(f.stat,'X'),'P', null, f.fecpag),lc_trasf,f.ppsbop);
         exception
         when others then
               lc_coderr:=sqlerrm;
               INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
               VALUES(0,'DATABDC2',lc_coderr, TRUNC(SYSDATE));
               COMMIT;
         end;
         commit;
      end loop;
      end if;
      end if; 
      for f in pagadela (i.bcemp,i.cage, i.bcmod, i.bcpap, i.mon, i.bccta, i.ccr, i.bcsbop, i.bctop) loop
         ln_numcuo := ln_numcuo + 1;
         ln_sim := null;
         ln_scom := null;
         ln_cap := null;
         ln_int := null;
         ln_mor := null;
         ln_otr := null;
         begin
           ln_scom := pq_datos_sbs.fn_scom (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                            i.bccta, i.ccr, i.bcsbop,i.bctop,f.fecvto);
           ln_diaart :=  (nvl(f.fecpag,ld_fecpro) - f.fecvto);
           if ln_diaart < 0 then
              ln_diaart := 0;
           else
              ln_sim  := pq_datos_sbs.fn_sim (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                              i.bccta, i.ccr, i.bcsbop,i.bctop,f.capital,ln_diaart);
           end if;
           /*if f.mora is null then
              ln_sim:=0;
           else
              ln_sim := f.mora;
           end if; */
           if i.mon = 101 then
              ln_cap := round(f.capital * ln_tipcam,2);
              ln_int := round(f.interes * ln_tipcam,2);
              ln_mor := round(ln_sim * ln_tipcam,2);
              ln_otr := round(ln_scom * ln_tipcam,2);
           else
              ln_cap := round(f.capital,2);
              ln_int := round(f.interes,2);
              ln_mor := round(ln_sim ,2);
              ln_otr := round(ln_scom,2);
           end if;
           lc_trasf := pq_datos_sbs.fn_cartrasferida(i.bccta,i.ccr);
           insert into  BDC02  (ccl,ccr,ncuo,mon,mcuo,
                              sic, scom, sim, fvep, fcan,CRACL,HORA)
            values (i.ccl, i.ccr,ln_numcuo,f.moneda,ln_cap,
                    ln_int,ln_otr,ln_mor, f.fecvto, f.fecpag,lc_trasf,f.ppsbop);
         exception
         when others then
               lc_coderr:=sqlerrm;
               INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
               VALUES(0,'DATABDC2',lc_coderr, TRUNC(SYSDATE));
               COMMIT;
         end;
         commit;
      end loop;
  end loop;
  commit;
  update  tab_jobs  g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'BDC2';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update  tab_jobs  g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'BDC2';
    commit;
    return;

end sp_procesa_BDC02;

Procedure sp_procesa_BDC02_a (pn_numsuc in number,  pd_fecpro in varchar2 ) is

  ld_fecpro date ;
  lc_coderr varchar2(300);

  cursor prestamo is
    /*select distinct ccl,bcemp,bcpap,bccta,bcsbop,
           bctop,bcmod,ccr,mon,cage,bcprod
      from JAQL120
     where cage = pn_numsuc
       and d_fecpro = ld_fecpro;*/
    select distinct a.ccl,a.bcemp,a.bcpap,a.bccta,a.bcsbop,
           a.bctop,a.bcmod,a.ccr,a.mon,a.cage,a.bcprod,a.d_fecpro, b.nrprg
      from JAQL120 a, bdc01 b
     where a.cage = pn_numsuc
       and a.d_fecpro = ld_fecpro
       and a.ccr = b.ccr (+)
       and a.ccl = b.ccl (+);   


  cursor calendario (ln_emp in number, ln_suc in number, ln_mod in number,
                     ln_pap in number, ln_mda in number, ln_cta in number,
                     ln_oper in number, ln_sbop in number, ln_tope in number  ) is
  select case when d601.ppmda = 0 then 'PEN' else 'USD' end moneda,
         decode(sum(d602.pp1cap),null,sum(d601.ppcap),sum(d602.pp1cap) )  capital,
         sum(d601.ppcap) capital_c,
         sum(d601.ppcap) - sum(d602.pp1cap)  capital_m,
         decode(sum(d602.pp1int),null,sum(d601.ppint),sum(d602.pp1int) ) interes,
         sum(d601.ppint) interes_c,
         sum(d602.pp1intm) mora, max(d602.pp1stat) stat,d601.ppsbop,
         d601.ppfvto fecvto, max(d602.pp1fech) fecpag
 from    fsd602 d602,   fsd601 d601
      where d602.pgcod (+)   = d601.pgcod
        and d602.ppmod (+)   = d601.ppmod
        and d602.ppsuc (+)   = d601.ppsuc
        and d602.ppmda (+)   = d601.ppmda
        and d602.pppap (+)   = d601.pppap
        and d602.ppcta (+)   = d601.ppcta
        and d602.ppoper (+)  = d601.ppoper
        and d602.ppsbop (+)  = d601.ppsbop
        and d602.pptope  (+) = d601.pptope
        and d602.ppfpag (+)  = d601.ppfpag
        and d602.pp1fech (+) <= ld_fecpro
        -- 08/2018
        and d601.ppcap + d601.ppint <> 0
        and d602.pp1salmor (+) = 0
        and d601.d601co   = 'S'
        --- 08/2018
        and d601.ppfpag <=  ld_fecpro --between add_months( to_date('20140531','yyyymmdd'), -6) and  to_date('20140531','yyyymmdd')  -- add_months(trunc(sysdate),-6) and trunc(sysdate)
        and d601.ppfvto <=  ld_fecpro
        --and d602.pp1stat (+) = 'T'
        and d602.d602co  (+) = 'S'
        and d601.pgcod    = ln_emp
        and d601.ppmod    = ln_mod
        and d601.ppsuc    = ln_suc
        and d601.ppmda    = ln_mda
        and d601.pppap    = ln_pap
        and d601.ppcta    = ln_cta
        and d601.ppoper   = ln_oper
        and d601.ppsbop   = ln_sbop
        and d601.pptope   = ln_tope
group by d601.ppmda, d601.ppfvto,d601.ppsbop
order by d601.ppfvto  ;

cursor calendario2 (ln_emp in number, ln_suc in number, ln_mod in number,
                     ln_pap in number, ln_mda in number, ln_cta in number,
                     ln_oper in number, ln_sbop in number, ln_tope in number  ) is
  select case when d601.ppmda = 0 then 'PEN' else 'USD' end moneda,
         decode(sum(d602.pp1cap),null,sum(d601.ppcap),sum(d602.pp1cap) )  capital,
         sum(d601.ppcap) capital_c,
         sum(d601.ppcap) - sum(d602.pp1cap)  capital_m,
         decode(sum(d602.pp1int),null,sum(d601.ppint),sum(d602.pp1int) ) interes,
         sum(d601.ppint) interes_c,
         sum(d602.pp1intm) mora,max(d602.pp1stat) stat, d601.ppsbop,
         d601.ppfvto fecvto, max(d602.pp1fech) fecpag
 from     fsd602 d602,   fsd601 d601
      where d602.pgcod (+)   = d601.pgcod
        and d602.ppmod (+)   = d601.ppmod
        and d602.ppsuc (+)   = d601.ppsuc
        and d602.ppmda (+)   = d601.ppmda
        and d602.pppap (+)   = d601.pppap
        and d602.ppcta (+)   = d601.ppcta
        and d602.ppoper (+)  = d601.ppoper
        and d602.ppsbop (+)  = d601.ppsbop
        and d602.pptope  (+) = d601.pptope
        and d602.ppfpag (+)  = d601.ppfpag
        and d602.pp1fech (+) <= ld_fecpro
        -- 08/2018
        and d601.ppcap + d601.ppint <> 0
        and d602.pp1salmor (+) = 0
        and d601.d601co   = 'S'
        --- 08/2018
        and d601.ppfpag <=  ld_fecpro --between add_months( to_date('20140531','yyyymmdd'), -6) and  to_date('20140531','yyyymmdd')  -- add_months(trunc(sysdate),-6) and trunc(sysdate)
        and d601.ppfvto <=  ld_fecpro
        --and d602.pp1stat (+) = 'T'
        and d602.d602co  (+) = 'S'
        and d601.pgcod    = ln_emp
        and d601.ppmod    = ln_mod
        --and d601.ppsuc    = ln_suc
        and d601.ppmda    = ln_mda
        and d601.pppap    = ln_pap
        and d601.ppcta    = ln_cta
        and d601.ppoper   = ln_oper
        and d601.ppsbop   = ln_sbop
        and d601.pptope   = ln_tope
group by d601.ppmda, d601.ppfvto, d601.ppsbop
order by d601.ppfvto  ;

cursor cal_reprogra (ln_emp in number, ln_suc in number, ln_mod in number,
                     ln_pap in number, ln_mda in number, ln_cta in number,
                     ln_oper in number, ln_sbop in number, ln_tope in number  ) is
  select case when d601.ppmda = 0 then 'PEN' else 'USD' end moneda,
         decode(sum(d602.pp1cap),null,sum(d601.ppcap),sum(d602.pp1cap) )  capital,
         sum(d601.ppcap) capital_c,
         sum(d601.ppcap) - sum(d602.pp1cap)  capital_m,
         decode(sum(d602.pp1int),null,sum(d601.ppint),sum(d602.pp1int) ) interes,
         sum(d601.ppint) interes_c,
         sum(d602.pp1intm) mora,d601.ppsbop,max(d602.pp1stat) stat,
         d601.ppfvto fecvto, max(d602.pp1fech) fecpag
 from    fsd602 d602,   fsd601 d601
      where d602.pgcod (+)   = d601.pgcod
        and d602.ppmod (+)   = d601.ppmod
        and d602.ppsuc (+)   = d601.ppsuc
        and d602.ppmda (+)   = d601.ppmda
        and d602.pppap (+)   = d601.pppap
        and d602.ppcta (+)   = d601.ppcta
        and d602.ppoper (+)  = d601.ppoper
        and d602.ppsbop (+)  = d601.ppsbop
        and d602.pptope  (+) = d601.pptope
        and d602.ppfpag (+)  = d601.ppfpag
        -- 08/2018
        and d601.ppcap + d601.ppint <> 0
        and d602.pp1salmor (+) = 0
        and d601.d601co   = 'S'
        --- 08/2018
        and d602.pp1fech (+) <= ld_fecpro
        --and d601.ppfpag <=  ld_fecpro --between add_months( to_date('20140531','yyyymmdd'), -6) and  to_date('20140531','yyyymmdd')  -- add_months(trunc(sysdate),-6) and trunc(sysdate)
        --and d601.ppfvto <=  ld_fecpro
        --and d602.pp1stat (+) = 'T'
        and d602.d602co  (+) = 'S'
        and d601.pgcod    = ln_emp
        and d601.ppmod    = ln_mod
        --and d601.ppsuc    = ln_suc
        and d601.ppmda    = ln_mda
        and d601.pppap    = ln_pap
        and d601.ppcta    = ln_cta
        and d601.ppoper   = ln_oper
        and d601.ppsbop   <> ln_sbop
        and d601.pptope   = ln_tope
group by d601.ppmda, d601.ppfvto,d601.ppsbop 
order by d601.ppfvto ;

 cursor pagadela (ln_emp in number, ln_suc in number, ln_mod in number,
                     ln_pap in number, ln_mda in number, ln_cta in number,
                     ln_oper in number, ln_sbop in number, ln_tope in number  ) is
  select case when d601.ppmda = 0 then 'PEN' else 'USD' end moneda,
         decode(sum(d602.pp1cap),null,sum(d601.ppcap),sum(d602.pp1cap) )  capital,
         sum(d601.ppcap) capital_c,
         sum(d601.ppcap) - sum(d602.pp1cap)  capital_m,
         decode(sum(d602.pp1int),null,sum(d601.ppint),sum(d602.pp1int) ) interes,
         sum(d601.ppint) interes_c,
         sum(d602.pp1intm) mora,d601.ppsbop,
         d601.ppfvto fecvto, max(d602.pp1fech) fecpag
 from    fsd602 d602,  fsd601 d601
      where d602.pgcod  = d601.pgcod
        and d602.ppmod  = d601.ppmod
        and d602.ppsuc  = d601.ppsuc
        and d602.ppmda  = d601.ppmda
        and d602.pppap  = d601.pppap
        and d602.ppcta  = d601.ppcta
        and d602.ppoper = d601.ppoper
        and d602.ppsbop = d601.ppsbop
        and d602.pptope = d601.pptope
        and d602.ppfpag = d601.ppfpag
        -- 08/2018
        and d601.ppcap + d601.ppint <> 0
        and d602.pp1salmor = 0
        and d601.d601co   = 'S'
        --- 08/2018
        and d602.pp1fech <= ld_fecpro
        and d602.ppfpag > ld_fecpro
        and d602.pp1stat  = 'T'
        and d602.d602co   = 'S'
        and d601.pgcod    = ln_emp
        and d601.ppmod    = ln_mod
        and d601.ppsuc    = ln_suc
        and d601.ppmda    = ln_mda
        and d601.pppap    = ln_pap
        and d601.ppcta    = ln_cta
        and d601.ppoper   = ln_oper
        and d601.ppsbop   = ln_sbop
        and d601.pptope   = ln_tope
group by d601.ppmda, d601.ppfvto,d601.ppsbop
order by d601.ppfvto  ;

ln_scom  number;
ln_sim   number;
ln_diaart number;
ln_cap number;
ln_int number;
ln_mor number;
ln_otr number;
ln_tipcam number;
ld_fecini date;
ln_numcuo number;
lc_trasf varchar2(1);
begin

  update  tab_jobs  g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'BDC2';
  commit;

  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');
  ld_fecini := ld_fecpro - (to_number(to_char(ld_fecpro,'DD')) - 1);

  begin
       select cotcbi
         into ln_tipcam
         from  fsh005
        where cofdes  = ld_fecpro
          and moneda = 101;
  exception
      when others then
        begin
          select cotcbi
            into ln_tipcam
            from  fsh005
           where cofdes between ld_fecini and ld_fecpro
             and moneda = 101
             and rownum = 1
           order by  cofdes desc;
        exception
           when others then
              ln_tipcam :=  3.273;
        end;
  end;

  for i in prestamo loop
     ln_numcuo := 0;
     if nvl(i.nrprg,0) = 0 then 
     for f in calendario (i.bcemp,i.cage, i.bcmod, i.bcpap, i.mon, i.bccta, i.ccr, i.bcsbop, i.bctop) loop
         ln_numcuo := ln_numcuo + 1;
         ln_sim := null;
         ln_scom := null;
         ln_cap := null;
         ln_int := null;
         ln_mor := null;
         ln_otr := null;
         begin
           ln_scom := pq_datos_sbs.fn_scom (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                            i.bccta, i.ccr, i.bcsbop,i.bctop,f.fecvto);
           
           --08/2018
           if nvl(f.stat,'X') = 'P'  then 
              ln_diaart :=  (ld_fecpro - f.fecvto);
           else
              ln_diaart :=  (nvl(f.fecpag,ld_fecpro) - f.fecvto);
           end if; 
           --08/2018
           if ln_diaart < 0 then
              ln_diaart := 0;
           else
              --08/2018
              if nvl(f.stat,'X') = 'P' /*f.fecpag is null */ and ln_diaart > 0 then 
                  ln_sim  := abs(pq_datos_sbs.fn_sim (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                                  i.bccta, i.ccr, i.bcsbop,i.bctop,f.capital_m,ln_diaart));
              elsif f.fecpag is null  and ln_diaart > 0 then 
                  ln_sim  := abs(pq_datos_sbs.fn_sim (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                                  i.bccta, i.ccr, i.bcsbop,i.bctop,f.capital,ln_diaart));
            
              elsif f.fecpag is not null  then 
                  ln_sim := f.mora;
              end if;   
              --08/2018
              /*if f.fecpag is null and ln_diaart > 0 then 
                  ln_sim  := abs(pq_datos_sbs.fn_sim (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                                  i.bccta, i.ccr, i.bcsbop,i.bctop,f.capital,ln_diaart));
              elsif f.fecpag is not null then 
                  ln_sim := f.mora;
              end if;*/    
           end if;
           if i.mon = 101 then
              --08/2018
              if nvl(f.stat,'X') = 'P'  then 
                  ln_cap := round(f.capital_c * ln_tipcam,2);
                  ln_int := round(f.interes_c * ln_tipcam,2);
              else
                  ln_cap := round(f.capital * ln_tipcam,2);
                  ln_int := round(f.interes * ln_tipcam,2);
              end if; 
              --08/2018
              
              ln_mor := round(ln_sim * ln_tipcam,2);
              ln_otr := round(ln_scom * ln_tipcam,2);
           else
              --08/2018
              if nvl(f.stat,'X') = 'P'  then 
                  ln_cap := round(f.capital_c,2);
                  ln_int := round(f.interes_c,2);
              else
                  ln_cap := round(f.capital,2);
                  ln_int := round(f.interes,2);
              end if; 
              --08/2018
              
              ln_mor := round(ln_sim ,2);
              ln_otr := round(ln_scom,2);
           end if;
           lc_trasf := pq_datos_sbs.fn_cartrasferida(i.bccta,i.ccr);
           if nvl(f.stat,'X') <> 'P' and  f.fecvto <= ld_fecpro then  
               insert into  BDC02  (ccl,ccr,ncuo,mon,mcuo,
                                  sic, scom, sim, fvep, fcan,CRACL,Hora)
                values (i.ccl, i.ccr,ln_numcuo,f.moneda,ln_cap,
                        ln_int,ln_otr,ln_mor, f.fecvto, f.fecpag,lc_trasf,f.ppsbop);
           elsif nvl(f.stat,'X') = 'P' and  f.fecvto <= ld_fecpro then 
               insert into  BDC02  (ccl,ccr,ncuo,mon,mcuo,
                                  sic, scom, sim, fvep, fcan,CRACL,Hora)
                values (i.ccl, i.ccr,ln_numcuo,f.moneda,ln_cap,
                        ln_int,ln_otr,ln_mor, f.fecvto, null,lc_trasf,f.ppsbop);
           end if;             
         exception
         when others then
               lc_coderr:=sqlerrm;
               INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
               VALUES(0,'DATABDC2',lc_coderr, TRUNC(SYSDATE));
               COMMIT;
         end;
         commit;
      end loop;
      if   ln_numcuo = 0 then
        for f in calendario2 (i.bcemp,i.cage, i.bcmod, i.bcpap, i.mon, i.bccta, i.ccr, i.bcsbop, i.bctop) loop
         ln_numcuo := ln_numcuo + 1;
         ln_sim := null;
         ln_scom := null;
         ln_cap := null;
         ln_int := null;
         ln_mor := null;
         ln_otr := null;
         begin
           ln_scom := pq_datos_sbs.fn_scom (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                            i.bccta, i.ccr, i.bcsbop,i.bctop,f.fecvto);
           --08/2018
           if nvl(f.stat,'X') = 'P'  then 
              ln_diaart :=  (ld_fecpro - f.fecvto);
           else
              ln_diaart :=  (nvl(f.fecpag,ld_fecpro) - f.fecvto);
           end if; 
           --08/2018
           if ln_diaart < 0 then
              ln_diaart := 0;
           else
              ln_sim  := pq_datos_sbs.fn_sim (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                              i.bccta, i.ccr, i.bcsbop,i.bctop,f.capital,ln_diaart);
           end if;
           /*if f.mora is null then
              ln_sim:=0;
           else
              ln_sim := f.mora;
           end if; */
           if i.mon = 101 then
              --08/2018
              if nvl(f.stat,'X') = 'P'  then 
                  ln_cap := round(f.capital_c * ln_tipcam,2);
                  ln_int := round(f.interes_c * ln_tipcam,2);
              else
                  ln_cap := round(f.capital * ln_tipcam,2);
                  ln_int := round(f.interes * ln_tipcam,2);
              end if; 
              --08/2018
              
              ln_mor := round(ln_sim * ln_tipcam,2);
              ln_otr := round(ln_scom * ln_tipcam,2);
           else
              --08/2018
              if nvl(f.stat,'X') = 'P'  then 
                  ln_cap := round(f.capital_c,2);
                  ln_int := round(f.interes_c,2);
              else
                  ln_cap := round(f.capital,2);
                  ln_int := round(f.interes,2);
              end if; 
              --08/2018
              
              ln_mor := round(ln_sim ,2);
              ln_otr := round(ln_scom,2);
           end if;
           lc_trasf := pq_datos_sbs.fn_cartrasferida(i.bccta,i.ccr);
           /*lc_hortra := pq_datos_sbs.fn_hora_trasn(i.bcemp, i.bcmod,i.cage, i.bcpap,
                                                    i.mon, i.bccta, i.ccr, i.bcsbop,
                                                    i.bctop, f.fecpag);*/
           
                    
           if nvl(f.stat,'X') <> 'P' and  f.fecvto <= ld_fecpro then  
              insert into  BDC02  (ccl,ccr,ncuo,mon,mcuo,
                              sic, scom, sim, fvep, fcan,CRACL,Hora)
              values (i.ccl, i.ccr,ln_numcuo,f.moneda,ln_cap,
                    ln_int,ln_otr,ln_mor, f.fecvto, f.fecpag,lc_trasf,f.ppsbop);
           elsif nvl(f.stat,'X') = 'P' and  f.fecvto <= ld_fecpro then 
               insert into  BDC02  (ccl,ccr,ncuo,mon,mcuo,
                                  sic, scom, sim, fvep, fcan,CRACL,Hora)
                values (i.ccl, i.ccr,ln_numcuo,f.moneda,ln_cap,
                        ln_int,ln_otr,ln_mor, f.fecvto, null,lc_trasf,f.ppsbop);
           end if;
                    
         exception
         when others then
               lc_coderr:=sqlerrm;
               INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
               VALUES(0,'DATABDC2',lc_coderr, TRUNC(SYSDATE));
               COMMIT;
         end;
         commit;
      end loop;
      end if;
      else
         for f in cal_reprogra (i.bcemp,i.cage, i.bcmod, i.bcpap, i.mon, i.bccta, i.ccr, i.bcsbop, i.bctop) loop
         ln_numcuo := ln_numcuo + 1;
         ln_sim := null;
         ln_scom := null;
         ln_cap := null;
         ln_int := null;
         ln_mor := null;
         ln_otr := null;
         begin
           ln_scom := pq_datos_sbs.fn_scom (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                            i.bccta, i.ccr, f.ppsbop,i.bctop,f.fecvto);
           --08/2018
           if nvl(f.stat,'X') = 'P'  then 
              ln_diaart :=  (ld_fecpro - f.fecvto);
           else
              ln_diaart :=  (nvl(f.fecpag,ld_fecpro) - f.fecvto);
           end if; 
           --08/2018
           if ln_diaart < 0 then
              ln_diaart := 0;
           else
              ln_sim  := f.mora;/*pq_datos_sbs.fn_sim (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                              i.bccta, i.ccr, f.ppsbop,i.bctop,f.capital,ln_diaart);*/
           end if;
           /*if f.mora is null then
              ln_sim:=0;
           else
              ln_sim := f.mora;
           end if; */
           if i.mon = 101 then
              --08/2018
              if nvl(f.stat,'X') = 'P'  then 
                  ln_cap := round(f.capital_c * ln_tipcam,2);
                  ln_int := round(f.interes_c * ln_tipcam,2);
              else
                  ln_cap := round(f.capital * ln_tipcam,2);
                  ln_int := round(f.interes * ln_tipcam,2);
              end if; 
              --08/2018
              
              ln_mor := round(ln_sim * ln_tipcam,2);
              ln_otr := round(ln_scom * ln_tipcam,2);
           else
              --08/2018
              if nvl(f.stat,'X') = 'P'  then 
                  ln_cap := round(f.capital_c,2);
                  ln_int := round(f.interes_c,2);
              else
                  ln_cap := round(f.capital,2);
                  ln_int := round(f.interes,2);
              end if; 
              --08/2018
              
              ln_mor := round(ln_sim ,2);
              ln_otr := round(ln_scom,2);
           end if;
           lc_trasf := pq_datos_sbs.fn_cartrasferida(i.bccta,i.ccr);
           /*lc_hortra := pq_datos_sbs.fn_hora_trasn(i.bcemp, i.bcmod,i.cage, i.bcpap,
                                                    i.mon, i.bccta, i.ccr, i.bcsbop,
                                                    i.bctop, f.fecpag);*/
           
           if nvl(f.stat,'X') <> 'P' /*and  f.fecvto <= ld_fecpro*/ then  
                -- aqui para cuotas reprogramadas aparesca sin pago
                --
                insert into  BDC02  (ccl,ccr,ncuo,mon,mcuo,
                              sic, scom, sim, fvep, fcan,CRACL,Hora)
                values (i.ccl, i.ccr,ln_numcuo,f.moneda,ln_cap,
                    ln_int,ln_otr,ln_mor, f.fecvto, f.fecpag,lc_trasf,f.ppsbop);
           end if; 
           
          
         exception
         when others then
               lc_coderr:=sqlerrm;
               INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
               VALUES(0,'DATABDC2',lc_coderr, TRUNC(SYSDATE));
               COMMIT;
         end;
         commit;
      end loop;
      ln_numcuo := 0;
      for f in calendario (i.bcemp,i.cage, i.bcmod, i.bcpap, i.mon, i.bccta, i.ccr, i.bcsbop, i.bctop) loop
         ln_numcuo := ln_numcuo + 1;
         ln_sim := null;
         ln_scom := null;
         ln_cap := null;
         ln_int := null;
         ln_mor := null;
         ln_otr := null;
         begin
           ln_scom := pq_datos_sbs.fn_scom (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                            i.bccta, i.ccr, i.bcsbop,i.bctop,f.fecvto);
           --08/2018
           if nvl(f.stat,'X') = 'P'  then 
              ln_diaart :=  (ld_fecpro - f.fecvto);
           else
              ln_diaart :=  (nvl(f.fecpag,ld_fecpro) - f.fecvto);
           end if;
           --08/2018
           if ln_diaart < 0 then
              ln_diaart := 0;
           else
              --08/2018
              if nvl(f.stat,'X') = 'P' /*f.fecpag is null */ and ln_diaart > 0 then 
                  ln_sim  := abs(pq_datos_sbs.fn_sim (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                                  i.bccta, i.ccr, i.bcsbop,i.bctop,f.capital_m,ln_diaart));
              elsif f.fecpag is null  and ln_diaart > 0 then 
                  ln_sim  := abs(pq_datos_sbs.fn_sim (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                                  i.bccta, i.ccr, i.bcsbop,i.bctop,f.capital,ln_diaart));
            
              elsif f.fecpag is not null  then 
                  ln_sim := f.mora;
              end if;   
              --08/2018
           end if;
           /*if f.mora is null then
              ln_sim:=0;
           else
              ln_sim := f.mora;
           end if; */
           if i.mon = 101 then
              --08/2018
              if nvl(f.stat,'X') = 'P'  then 
                  ln_cap := round(f.capital_c * ln_tipcam,2);
                  ln_int := round(f.interes_c * ln_tipcam,2);
              else
                  ln_cap := round(f.capital * ln_tipcam,2);
                  ln_int := round(f.interes * ln_tipcam,2);
              end if;
              --08/2018
              
              ln_mor := round(ln_sim * ln_tipcam,2);
              ln_otr := round(ln_scom * ln_tipcam,2);
           else
              --08/2018
              if nvl(f.stat,'X') = 'P'  then 
                  ln_cap := round(f.capital_c ,2);
                  ln_int := round(f.interes_c,2);
              else
                  ln_cap := round(f.capital ,2);
                  ln_int := round(f.interes,2);
              end if;
              --08/2018
              
              ln_mor := round(ln_sim ,2);
              ln_otr := round(ln_scom,2);
           end if;
           lc_trasf := pq_datos_sbs.fn_cartrasferida(i.bccta,i.ccr);
           if nvl(f.stat,'X') <> 'P' and  f.fecvto <= ld_fecpro then  
               insert into  BDC02  (ccl,ccr,ncuo,mon,mcuo,
                                  sic, scom, sim, fvep, fcan,CRACL,HORA)
                values (i.ccl, i.ccr,ln_numcuo,f.moneda,ln_cap,
                        ln_int,ln_otr,ln_mor, f.fecvto, f.fecpag,lc_trasf,f.ppsbop);
           elsif nvl(f.stat,'X') = 'P' and  f.fecvto <= ld_fecpro then 
               insert into  BDC02  (ccl,ccr,ncuo,mon,mcuo,
                                  sic, scom, sim, fvep, fcan,CRACL,Hora)
                values (i.ccl, i.ccr,ln_numcuo,f.moneda,ln_cap,
                        ln_int,ln_otr,ln_mor, f.fecvto, null,lc_trasf,f.ppsbop);
           end if;  
         exception
         when others then
               lc_coderr:=sqlerrm;
               INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
               VALUES(0,'DATABDC2',lc_coderr, TRUNC(SYSDATE));
               COMMIT;
         end;
         commit;
      end loop;
      if   ln_numcuo = 0 then
        for f in calendario2 (i.bcemp,i.cage, i.bcmod, i.bcpap, i.mon, i.bccta, i.ccr, i.bcsbop, i.bctop) loop
         ln_numcuo := ln_numcuo + 1;
         ln_sim := null;
         ln_scom := null;
         ln_cap := null;
         ln_int := null;
         ln_mor := null;
         ln_otr := null;
         begin
           ln_scom := pq_datos_sbs.fn_scom (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                            i.bccta, i.ccr, i.bcsbop,i.bctop,f.fecvto);
           --08/2018
           if nvl(f.stat,'X') = 'P'  then 
              ln_diaart :=  (ld_fecpro - f.fecvto);
           else
              ln_diaart :=  (nvl(f.fecpag,ld_fecpro) - f.fecvto);
           end if;
           --08/2018
           if ln_diaart < 0 then
              ln_diaart := 0;
           else
              ln_sim  := pq_datos_sbs.fn_sim (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                              i.bccta, i.ccr, i.bcsbop,i.bctop,f.capital,ln_diaart);
           end if;
           /*if f.mora is null then
              ln_sim:=0;
           else
              ln_sim := f.mora;
           end if; */
           if i.mon = 101 then
              --08/2018
              if nvl(f.stat,'X') = 'P'  then 
                  ln_cap := round(f.capital_c * ln_tipcam,2);
                  ln_int := round(f.interes_c * ln_tipcam,2);
              else
                  ln_cap := round(f.capital * ln_tipcam,2);
                  ln_int := round(f.interes * ln_tipcam,2);
              end if;
              --08/2018
              ln_mor := round(ln_sim * ln_tipcam,2);
              ln_otr := round(ln_scom * ln_tipcam,2);
           else
              --08/2018
              if nvl(f.stat,'X') = 'P'  then 
                  ln_cap := round(f.capital_c ,2);
                  ln_int := round(f.interes_c,2);
              else
                  ln_cap := round(f.capital ,2);
                  ln_int := round(f.interes,2);
              end if;
              --08/2018
              
              
              ln_mor := round(ln_sim ,2);
              ln_otr := round(ln_scom,2);
           end if;
           lc_trasf := pq_datos_sbs.fn_cartrasferida(i.bccta,i.ccr);
           /*lc_hortra := pq_datos_sbs.fn_hora_trasn(i.bcemp, i.bcmod,i.cage, i.bcpap,
                                                    i.mon, i.bccta, i.ccr, i.bcsbop,
                                                    i.bctop, f.fecpag);*/
           insert into  BDC02  (ccl,ccr,ncuo,mon,mcuo,
                              sic, scom, sim, fvep, fcan,CRACL,Hora)
            values (i.ccl, i.ccr,ln_numcuo,f.moneda,ln_cap,
                    ln_int,ln_otr,ln_mor, f.fecvto, decode( nvl(f.stat,'X'),'P', null, f.fecpag),lc_trasf,f.ppsbop);
         exception
         when others then
               lc_coderr:=sqlerrm;
               INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
               VALUES(0,'DATABDC2',lc_coderr, TRUNC(SYSDATE));
               COMMIT;
         end;
         commit;
      end loop;
      end if;
      end if; 
      for f in pagadela (i.bcemp,i.cage, i.bcmod, i.bcpap, i.mon, i.bccta, i.ccr, i.bcsbop, i.bctop) loop
         ln_numcuo := ln_numcuo + 1;
         ln_sim := null;
         ln_scom := null;
         ln_cap := null;
         ln_int := null;
         ln_mor := null;
         ln_otr := null;
         begin
           ln_scom := pq_datos_sbs.fn_scom (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                            i.bccta, i.ccr, i.bcsbop,i.bctop,f.fecvto);
           ln_diaart :=  (nvl(f.fecpag,ld_fecpro) - f.fecvto);
           if ln_diaart < 0 then
              ln_diaart := 0;
           else
              ln_sim  := pq_datos_sbs.fn_sim (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                              i.bccta, i.ccr, i.bcsbop,i.bctop,f.capital,ln_diaart);
           end if;
           /*if f.mora is null then
              ln_sim:=0;
           else
              ln_sim := f.mora;
           end if; */
           if i.mon = 101 then
              ln_cap := round(f.capital * ln_tipcam,2);
              ln_int := round(f.interes * ln_tipcam,2);
              ln_mor := round(ln_sim * ln_tipcam,2);
              ln_otr := round(ln_scom * ln_tipcam,2);
           else
              ln_cap := round(f.capital,2);
              ln_int := round(f.interes,2);
              ln_mor := round(ln_sim ,2);
              ln_otr := round(ln_scom,2);
           end if;
           lc_trasf := pq_datos_sbs.fn_cartrasferida(i.bccta,i.ccr);
           insert into  BDC02  (ccl,ccr,ncuo,mon,mcuo,
                              sic, scom, sim, fvep, fcan,CRACL,HORA)
            values (i.ccl, i.ccr,ln_numcuo,f.moneda,ln_cap,
                    ln_int,ln_otr,ln_mor, f.fecvto, f.fecpag,lc_trasf,f.ppsbop);
         exception
         when others then
               lc_coderr:=sqlerrm;
               INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
               VALUES(0,'DATABDC2',lc_coderr, TRUNC(SYSDATE));
               COMMIT;
         end;
         commit;
      end loop;
  end loop;
  commit;
  update  tab_jobs  g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'BDC2';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update  tab_jobs  g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'BDC2';
    commit;
    return;

end sp_procesa_BDC02_a;

Procedure sp_job_procesa_BDC01P (pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is
  select sucurs from  fst001 where pgcod =1 ;
  begin
     /*begin
         select host_name
           into lc_hostname
           from v$instance;
     end;*/
--      lc_hostname := 'SC01ZDBADM010101';
     --execute immediate ('truncate table migra2.BDC02');
     execute immediate ('alter session set parallel_force_local=TRUE');--jflor 2014.01.16
     delete  tab_jobs  where  c_Codage = 'BDC1P';
     commit;
     for i in sucursal loop
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_sbs.sp_procesa_BDC01P('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
--        if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
        if sys.fn_bd_IsRAC='TRUE' then
        --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
            DBMS_JOB.SUBMIT(job => ln_job,
                          what => lc_variable,
                          next_date => sysdate+1/(24*180),
                          interval => null,
                          no_parse => false,
                          instance => 2,
                          force => false
                          );
            INSERT INTO  tab_jobs  (c_Codage,n_Numer1,c_detjob)
            VALUES('BDC1P',ln_ini,lc_variable);
            COMMIT;
        else
            DBMS_JOB.SUBMIT(job => ln_job,
                          what => lc_variable,
                          next_date => sysdate+1/(24*180),
                          interval => null,
                          no_parse => false,
                          force => false
                          );
            INSERT INTO  tab_jobs  (c_Codage,n_Numer1,c_detjob)
            VALUES('BDC1P',ln_ini,lc_variable);
            COMMIT;
        end if;
      end loop;
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'BDC1P',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

  end;

  Procedure sp_procesa_BDC01P (pn_numsuc in number, pd_fecpro in varchar2 ) is

  ld_fecpro date ;
  lc_coderr varchar2(300);
  cursor prestamo is

select /*+parallel(a,2)*/distinct b.bcemp,b.bcpap,b.bccta,b.bcsbop,--15.03.2015
       b.mon,b.bctop,b.bcmod,b.ccr,b.cage,
       a.ccl,a.ccr ccra
       from  BDC01  a,  JAQL120  b-- ,  fsh012 c
      where a.ccl = b.ccl
        and a.ccr = b.ccr
        AND B.CAGE = pn_numsuc
        --AND A.PCI <> 0
        --and a.kco = 0
        and a.pci3 is null
        and b.bcmod not in (117);


ln_pci   number;

begin

  update  tab_jobs  g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'BDC1P';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');

  for i in prestamo loop
     if i.bcmod not in (117) then
         if i.bcmod  = 141 then
            ln_pci  :=  pq_datos_sbs.fn_Saldo_relacion3(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                             i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro, 35,'27_1%'/*i.bcrubr */) +
                        pq_datos_sbs.fn_Saldo_relacion3(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                             i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro, 335,'27_1%'/*i.bcrubr */)+
                        pq_datos_sbs.fn_Saldo_relacion3(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                             i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro, 635,'27_1%'/*i.bcrubr */);
         else
             ln_pci  := pq_datos_sbs.fn_Saldo_relacion3(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                             i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro, 35,'14_9%'/*i.bcrubr */) +
                        pq_datos_sbs.fn_Saldo_relacion3(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                             i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro, 335,'14_9%'/*i.bcrubr */)+
                        pq_datos_sbs.fn_Saldo_relacion3(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                             i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro, 635,'14_9%'/*i.bcrubr */)                     ;
         end if;
     else
         ln_pci  := 0 ; /*pq_datos_sbs.fn_Saldo_relacion3(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                    i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro, 735,'27_1%'\*i.bcrubr *\);  */

     end if;



     begin
       UPDATE  BDC01
          SET PCI3 = ln_pci
        WHERE ccr = i.ccr
          and trim(ccl) = trim(i.ccl);
       commit;
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'DATABCD1P',lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;
     commit;
  end loop;
  commit;
  update  tab_jobs  g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'BDC1P';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update  tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'BDC1P';
    commit;
    return;

end sp_procesa_BDC01P;

function fn_tipo_garantia(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                          pn_pap in number, pn_cta in number, pn_oper in number,
                          pn_sbop in number,pn_top in number ) return varchar2 is
ln_tipgar number;
lc_desgar varchar2(200);
cursor garantias is
select distinct r.r2tope tipgar
  from   fsr011 r
 where r.relcod = 50
   and r.r011co = 'S'
   and r.r1cod  = pn_emp
   and r.r1suc  = pn_suc
   and r.r1mda  = pn_mda
   and r.r1pap  = pn_pap
   and r.r1cta  = pn_cta
   and r.r1oper = pn_oper
   and r.r1sbop = pn_sbop
   and r.r1tope = pn_top
   and r.r1mod  = pn_mod
   and r.r2mod = 70
   --and r.r2tope not in (10,15,20,25,30,40,42,50,55,60,65,70,80,85)
   ;

begin
  begin
     for i in garantias  loop
         if i.tipgar in (10,15)  then
            lc_desgar := lc_desgar ||'Inmueble ';
         elsif i.tipgar in (20,25)  then
            lc_desgar := lc_desgar ||'Maq. y Equipo  ';
         elsif i.tipgar in (30)  then
            lc_desgar := lc_desgar ||'Mercaderia ';
         elsif i.tipgar in (40,42)  then
            lc_desgar := lc_desgar ||'Vehicular ';
         elsif i.tipgar in (50,55)  then
            lc_desgar := lc_desgar ||'Buques ';
         elsif i.tipgar in (60,65)  then
            lc_desgar := lc_desgar ||'Nv. Aeronav. ';
         elsif i.tipgar in (70)  then
            lc_desgar := lc_desgar ||'Joyas ';
         elsif i.tipgar in (80,85)  then
            lc_desgar := lc_desgar ||'Deposito ';
         elsif i.tipgar in (90)  then
            lc_desgar := lc_desgar ||'Bines Declarados ';
         elsif i.tipgar in (91)  then
            lc_desgar := lc_desgar ||'Avales ';
         end if;
     end loop;
  exception
      when others then
         null;
  end;
  return lc_desgar;
end fn_tipo_garantia;

function fn_Saldo_garantia(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                          pn_pap in number, pn_cta in number, pn_oper in number,
                          pn_sbop in number,pn_top in number, pd_fecha in date ) return number is
ln_tipgar number;
 ln_salgar number;
begin
  begin
    select /*+index_ss(h12)*/ sum(h12.bcsdmn)
      into ln_salgar
      from  fsr011 r,  fsh012 h12
     where r.relcod = 50
       and r.r011co = 'S'
       and r.r1cod  = pn_emp
       and r.r1suc  = pn_suc
       and r.r1mda  = pn_mda
       and r.r1pap  = pn_pap
       and r.r1cta  = pn_cta
       and r.r1oper = pn_oper
       and r.r1sbop = pn_sbop
       and r.r1tope = pn_top
       and r.r1mod  = pn_mod
       and r.r2mod = 70
       --and r.r2tope not in (10,15,20,25,30,40,42,50,55,60,65,70,80,85)
       and h12.bcemp = r.r2cod
       and h12.bcsuc = r.r2suc
       and h12.bcmda = r.r2mda
       and h12.bcpap = r.r2pap
       and h12.bccta = r.r2cta
       and h12.bcoper= r.r2oper
       and h12.bcsbop= r.r2sbop
       and h12.bctop = r.r2tope
       and h12.bcmod = r.r2mod
       and h12.bcfech =  pd_fecha;

  exception
      when others then
         null;
  end;
  return nvl(ln_salgar,0);
end fn_Saldo_garantia;
----
Procedure sp_job_procesa_BDC01_GP (pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is
  select sucurs from   fst001 where pgcod =1 ;
  begin
     /*begin
         select host_name
           into lc_hostname
           from v$instance;
     end;*/
--      lc_hostname := 'SC01ZDBADM010101';
     --execute immediate ('truncate table migra2.BDC02');
     execute immediate ('alter session set parallel_force_local=TRUE');--jflor 2014.01.16
     delete  tab_jobs  where  c_Codage = 'BDC1P';
     commit;
     for i in sucursal loop
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_sbs.sp_procesa_BDC01_GP('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
--       if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
        if sys.fn_bd_IsRAC='TRUE' then
            --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
            DBMS_JOB.SUBMIT(job => ln_job,
                          what => lc_variable,
                          next_date => sysdate+1/(24*180),
                          interval => null,
                          no_parse => false,
                          instance => 2,
                          force => false
                          );
            INSERT INTO  tab_jobs  (c_Codage,n_Numer1,c_detjob)
            VALUES('BDC1P',ln_ini,lc_variable);
            COMMIT;
         else
            DBMS_JOB.SUBMIT(job => ln_job,
                          what => lc_variable,
                          next_date => sysdate+1/(24*180),
                          interval => null,
                          no_parse => false,
                          force => false
                          );
            INSERT INTO  tab_jobs  (c_Codage,n_Numer1,c_detjob)
            VALUES('BDC1P',ln_ini,lc_variable);
            COMMIT;
         end if;
      end loop;

  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'BDC1P',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

  end;
  Procedure sp_job_procesa_BDC01_DIF (pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is
  select sucurs from  fst001 where pgcod =1 ;
  begin
     /*begin
         select host_name
           into lc_hostname
           from v$instance;
     end;*/
--      lc_hostname := 'SC01ZDBADM010101';
     --execute immediate ('truncate table migra2.BDC02');
     execute immediate ('alter session set parallel_force_local=TRUE');--jflor 2014.01.16
     delete  tab_jobs  where  c_Codage = 'BDC1P';
     commit;
     for i in sucursal loop
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_sbs.sp_procesa_BDC01_DIF('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
--        if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
        if sys.fn_bd_IsRAC='TRUE' then
            --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
            DBMS_JOB.SUBMIT(job => ln_job,
                          what => lc_variable,
                          next_date => sysdate+1/(24*180),
                          interval => null,
                          no_parse => false,
                          instance => 2,
                          force => false
                          );
            INSERT INTO  tab_jobs  (c_Codage,n_Numer1,c_detjob)
            VALUES('BDC1D',ln_ini,lc_variable);
            COMMIT;
         else
            DBMS_JOB.SUBMIT(job => ln_job,
                          what => lc_variable,
                          next_date => sysdate+1/(24*180),
                          interval => null,
                          no_parse => false,
                          force => false
                          );
            INSERT INTO  tab_jobs  (c_Codage,n_Numer1,c_detjob)
            VALUES('BDC1D',ln_ini,lc_variable);
            COMMIT;

         end if;
      end loop;
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'BDC1D',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

  end;

  Procedure sp_procesa_BDC01_GP (pn_numsuc in number, pd_fecpro in varchar2 ) is

  ld_fecpro date ;
  lc_coderr varchar2(300);
  cursor prestamo is

select /*+parallel(a,2)*/ distinct b.bcemp,b.bcpap,b.bccta,b.bcsbop,
       b.mon,b.bctop,b.bcmod,b.ccr,b.cage,
       a.ccl,a.ccr ccra, a.dapr, a.nrprg                 
       from  BDC01  a,  JAQL120  b-- ,  fsh012 c
      where a.ccl = b.ccl
        and a.ccr = b.ccr
        AND B.CAGE = pn_numsuc
        --AND A.PCI <> 0
        --and a.kco = 0
        and a.pcuo is null
        and b.bcmod not in (117,144,141);



ln_Dgr number;
ln_pcuo number;
ln_ncpr number;
ln_dapr number;

begin

  update  tab_jobs  g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'BDC1P';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');

  for i in prestamo loop
     ln_Dgr  :=null;
     ln_pcuo :=null;
     ln_ncpr :=null;
     ln_dapr := i.dapr;
     pq_datos_sbs.sp_dgr_pcuo_ncpr(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                   i.bccta, i.ccr, i.bcsbop,i.bctop,i.nrprg ,ln_Dgr,ln_pcuo,ln_ncpr );

     if i.dapr is null then
        ln_dapr := pq_datos_sbs.fn_dapr(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                        i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro);
     end if;
     begin
       UPDATE  BDC01
          SET dgr  = ln_Dgr,
              pcuo = ln_pcuo,
              ncpr = ln_ncpr,
              dapr = ln_dapr
        WHERE ccr = i.ccr
          and trim(ccl) = trim(i.ccl);
       commit;
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'DATABCD1P',lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;
     commit;
  end loop;
  commit;
  update  tab_jobs  g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'BDC1P';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update  tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'BDC1P';
    commit;
    return;

end sp_procesa_BDC01_GP;

Procedure sp_procesa_BDC01_DIF (pn_numsuc in number, pd_fecpro in varchar2 ) is

  ld_fecpro date ;
  lc_coderr varchar2(300);
  cursor prestamo is

select /*+parallel(a,2)*/ distinct b.bcemp,b.bcpap,b.bccta,b.bcsbop,
       b.mon,b.bctop,b.bcmod,b.ccr,b.cage,
       a.ccl,a.ccr ccra, a.dapr
       from  BDC01  a,  JAQL120  b-- ,  fsh012 c
      where a.ccl = b.ccl
        and a.ccr = b.ccr
        AND B.CAGE = pn_numsuc
        --AND A.PCI <> 0
        --and a.kco = 0
        --and a.pcuo is null
        and b.bcmod not in (117,144,141);



ln_sid number;
ln_sid2 number;
ln_ccsid number;
ln_ccsid2 number;

begin

  update  tab_jobs  g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'BDC1D';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');

  for i in prestamo loop
     pq_datos_sbs.sp_cta_saldo_relacion2(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                        i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro, 430,
                                        '29_1%', ln_sid, ln_ccsid);
     pq_datos_sbs.sp_cta_saldo_relacion2(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                        i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro, 330,
                                        '29_1%', ln_sid2, ln_ccsid2);
     if nvl(ln_ccsid,0) = 0 then
        ln_ccsid := ln_ccsid2;
     end if;
     ln_sid := nvl(ln_sid,0) + nvl(ln_sid2,0);

     begin
       UPDATE  BDC01
          SET sid   = ln_sid,
              ccsid = ln_ccsid
        WHERE ccr = i.ccr
          and trim(ccl) = trim(i.ccl);
       commit;
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'DATABCD1D',lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;
     commit;
  end loop;
  commit;
  update  tab_jobs  g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'BDC1D';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update  tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'BDC1D';
    commit;
    return;

end sp_procesa_BDC01_DIF;

function fn_ncpend(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                 pn_pap in number, pn_cta in number, pn_oper in number,
                 pn_sbop in number,pn_top in number, pd_fecpro in date ) return number is
ln_cuopag number;
begin
  begin
    select /*+ parallel(n,2,1)*/
           count(n.ppfpag)
      into ln_cuopag
      from  fsd601 n
     where n.pgcod  = pn_emp
       and n.ppcta  = pn_cta
       and n.ppmda  = pn_mda
       and n.ppsuc  = pn_suc
       and n.pppap  = pn_pap
       and n.ppoper = pn_oper
       and n.ppsbop = pn_sbop
       and n.pptope = pn_top
       and n.ppmod  = pn_mod
       and n.d601co = 'S'
       and not exists
                (select /*+ parallel(o,2,1)*/  ppmod, ppcta,ppoper, pptope,ppfpag
                   from   fsd602 o
                  where o.pgcod   = n.pgcod
                    and o.ppmod   = n.ppmod
                    and o.ppsuc   = n.ppsuc
                    and o.ppmda   = n.ppmda
                    and o.pppap   = n.pppap
                    and o.ppcta   = n.ppcta
                    and o.ppoper  = n.ppoper
                    and o.ppsbop  = n.ppsbop
                    and o.pptope  = n.pptope
                    and o.ppfpag  = n.ppfpag
                    --and o.ppfpag  <= pd_fecpro
                    and o.pp1fech  <= pd_fecpro
                    and o.pp1stat = 'T'
                    and o.d602co  = 'S');
  exception
      when no_data_found then
         ln_cuopag := 0;
      when too_many_rows then
         ln_cuopag := null;
  end;
   return ln_cuopag;
end ;

function fn_cartrasferida(pn_cta in number, pn_oper in number ) return varchar2 is
lc_trasferida varchar2(1);
begin
  begin
     select '1'
       into lc_trasferida
       from  bnj096 c
      where c.bnj096ope = pn_oper
        and c.bnj096cta = pn_cta
        and c.bnj096cpe = 159;
  exception
      when no_data_found then
         lc_trasferida := '0';
      when too_many_rows then
         lc_trasferida := null;
  end;
   return lc_trasferida;
end ;
----
--BDC01-0102
PROCEDURE SP_IRCP(pn_inst in number,
                  pn_tcr in number,
                  pn_nrodoc in varchar2,
                  pn_ircp out number,
                  pn_rcp out number,
                  pn_rpcn out number,
                  pn_resul out number,
                  pn_ting out number,
                  pc_sting out varchar2,
                  pc_oing out varchar2,
                  pn_gneg out number,
                  pn_gfam out number,
                  pn_nrodep out number)is
ln_ircp number;
ln_rcp number;
ln_rpcn number;
ln_resul number;
ln_ting number;
lc_sting varchar2(50);
lc_oing varchar2(50);
ln_gneg number;
ln_gfam number;
ln_nrodep number;
--ln_cuota number;
ln_exede number;
begin
--  begin
     -- Buscar Cuota
     begin
          SELECT SUM(CASE WHEN  D.SNG026COD = 526 AND D.SNG023MTO <> 0 THEN Y.SNG120TCBI * D.SNG023MTO
                    ELSE  D.SNG023MTO END)
            INTO ln_rpcn
            FROM  SNG023 D,  SNG021 X,  SNG120 Y
           WHERE D.SNG021EVAL = X.SNG021EVAL
             AND Y.SNG120TSK = 'EVALUACION'
             AND X.SNG021SOL = pn_inst
             AND X.SNG021SOL = Y.SNG120INS
             AND D.SNG026COD IN (26,526);
       exception
          when no_data_found then
             ln_rpcn := 0;

          when too_many_rows then
             ln_rpcn := null;
      end;
     -- buscar si es consumo o pyme
     if pn_tcr in (11,12,13) then -- Consumo
        ln_ircp := 38;
        begin
          SELECT SUM(CASE WHEN  D.SNG026COD = 527 AND D.SNG023MTO <> 0 THEN Y.SNG120TCBI * D.SNG023MTO
                    ELSE  D.SNG023MTO END)
            INTO ln_resul
            FROM  SNG023 D,  SNG021 X,  SNG120 Y
           WHERE D.SNG021EVAL = X.SNG021EVAL
             AND Y.SNG120TSK = 'EVALUACION'
             AND X.SNG021SOL = pn_inst
             AND X.SNG021SOL = Y.SNG120INS
             AND D.SNG026COD IN (27,527);
        exception
          when no_data_found then
             ln_resul := 0;

          when too_many_rows then
             ln_resul := null;
        end;
        ln_ting := 2; -- sustentado
        lc_sting := 'Boleta Pago';
        lc_oing  := 'N.A';
     Else -- Pymes
        ln_ircp := 115;
        begin
            SELECT SUM(CASE WHEN  D.SNG026COD = 540 AND D.SNG023MTO <> 0 THEN Y.SNG120TCBI * D.SNG023MTO
                      ELSE  D.SNG023MTO END)
              INTO ln_resul
              FROM  SNG023 D,  SNG021 X,  SNG120 Y
             WHERE D.SNG021EVAL = X.SNG021EVAL
               AND Y.SNG120TSK = 'EVALUACION'
               AND X.SNG021SOL = pn_inst
               AND X.SNG021SOL = Y.SNG120INS
               AND D.SNG026COD IN (40,540);
         exception
            when no_data_found then
               ln_resul := 0;

            when too_many_rows then
               ln_resul := null;
        end;
        ln_ting := 1; -- Ventas
        lc_sting := 'N.A';
        lc_oing  := 'N.A';
        -- gastos familiar
        begin
            SELECT SUM(CASE WHEN  D.SNG026COD in (554) AND D.SNG023MTO <> 0 THEN Y.SNG120TCBI * D.SNG023MTO
                      ELSE  D.SNG023MTO END)
              INTO ln_gfam
              FROM  SNG023 D,  SNG021 X,  SNG120 Y
             WHERE D.SNG021EVAL = X.SNG021EVAL
               AND Y.SNG120TSK = 'EVALUACION'
               AND X.SNG021SOL = pn_inst
               AND X.SNG021SOL = Y.SNG120INS
               AND D.SNG026COD IN (54,554);
        exception
            when no_data_found then
               ln_gfam := 0;
            when too_many_rows then
               ln_gfam := null;
        end;
        -- numero de hijos de titular principal
        begin
            select paiscon
              into ln_nrodep
              from  fse001
             where d511ndoc = pn_nrodoc;

        exception
           when others then
             ln_nrodep := 0;
        end;
        -- gastos pymes
        begin
          SELECT SUM(CASE WHEN  D.SNG026COD in (574,576,577,519,581) AND D.SNG023MTO <> 0 THEN Y.SNG120TCBI * D.SNG023MTO
                    ELSE  D.SNG023MTO END)
            INTO ln_gneg
            FROM  SNG023 D,  SNG021 X,  SNG120 Y
           WHERE D.SNG021EVAL = X.SNG021EVAL
             AND Y.SNG120TSK = 'EVALUACION'
             AND X.SNG021SOL = pn_inst
             AND X.SNG021SOL = Y.SNG120INS
             AND D.SNG026COD IN (74,574,76,576,77,577,19,519,81,581);
        exception
          when no_data_found then
             ln_gneg := 0;

          when too_many_rows then
             ln_gneg := null;
        end;
     end if;
   begin
     ln_rcp := nvl(ln_rpcn,0) / nvl(ln_resul,1);
   exception
     when others then
       ln_rcp := null;
   end;
   pn_ircp := ln_ircp;
   pn_rcp  := ln_rcp;
   pn_rpcn := ln_rpcn;
   pn_resul:= ln_resul;
   pn_ting := ln_ting ;
   pc_sting:= lc_sting;
   pc_oing := lc_oing ;
   pn_gneg := ln_gneg ;
   pn_gfam := ln_gfam ;
   pn_nrodep := ln_nrodep;

end ;

Procedure sp_job_procesa_BDC01_0102 (pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is
  select sucurs from   fst001 where pgcod =1 ;
  begin
     /*begin
         select host_name
           into lc_hostname
           from v$instance;
     end;*/
--      lc_hostname := 'SC01ZDBADM010101';
     execute immediate ('truncate table JAQL126');
     execute immediate ('alter session set parallel_force_local=TRUE');--jflor 2014.01.16
     delete  tab_jobs  where  c_Codage = 'BDC12';
     commit;
     for i in sucursal loop
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_sbs.sp_procesa_BDC01_0102('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
--        if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
        if sys.fn_bd_IsRAC='TRUE' then
            --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
            DBMS_JOB.SUBMIT(job => ln_job,
                          what => lc_variable,
                          next_date => sysdate+1/(24*180),
                          interval => null,
                          no_parse => false,
                          instance => 2,
                          force => false
                          );
            INSERT INTO  tab_jobs  (c_Codage,n_Numer1,c_detjob)
            VALUES('BDC12',ln_ini,lc_variable);
            COMMIT;
        else
            DBMS_JOB.SUBMIT(job => ln_job,
                          what => lc_variable,
                          next_date => sysdate+1/(24*180),
                          interval => null,
                          no_parse => false,
                          force => false
                          );
            INSERT INTO  tab_jobs  (c_Codage,n_Numer1,c_detjob)
            VALUES('BDC12',ln_ini,lc_variable);
            COMMIT;
        end if;
      end loop;
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'BDC12',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

  end;

  Procedure sp_procesa_BDC01_0102 (pn_numsuc in number, pd_fecpro in varchar2 ) is

  ld_fecpro date ;
  lc_coderr varchar2(500);
  cursor prestamo is
  select distinct a.ccr, a.nid,b.n_instan, a.tcr
    from BDC01  a,  JAQL120  b
   where a.ccl = b.ccl
     and a.ccr = b.ccr
     AND B.CAGE = pn_numsuc
     and tcr <> '08'
union all
    select distinct a.ccr, a.nid,b.n_instan, a.tcr
    from BDC01  a,  JAQL120  b
   where a.ccl = b.ccl
     and a.ccr like '117%'||b.ccr
     and b.bcmod = 117
     and B.CAGE = pn_numsuc
     and tcr <> '08';

  ln_ircp   number;
  ln_rcp    number;
  ln_rpcn   number;
  ln_resul  number;
  ln_ting   number;
  lc_sting  varchar2(50);
  lc_oing   varchar2(50);
  ln_gneg   number;
  ln_gfam   number;
  ln_nrodep number;

begin

  update  tab_jobs  g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'BDC12';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');

  for i in prestamo loop
     begin
       pq_datos_sbs.SP_IRCP( i.n_instan, i.tcr, i.nid,
                           ln_ircp,ln_rcp,ln_rpcn,
                           ln_resul,ln_ting,lc_sting,
                           lc_oing,ln_gneg,ln_gfam,ln_nrodep);



       insert into JAQL126 (d_fecpro,CCR,ircp,rcp,rpcn,
                             rcpd,ing,ting,sting,
                             oing,gneg,gfam,numdep)
       values(ld_fecpro,i.ccr,ln_ircp,ln_rcp,ln_rpcn,
              ln_resul,ln_resul,ln_ting,lc_sting,
              lc_oing,ln_gneg,ln_gfam,ln_nrodep);
       commit;
     exception
        when others then
           lc_coderr:= i.n_instan ||'-'|| i.nid ||'-'|| sqlerrm ;
           INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'BCD102',lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;
  end loop;
  commit;
  update  tab_jobs  g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'BDC12';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update  tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'BDC12';
    commit;
    return;
end sp_procesa_BDC01_0102;
--------------------------------
-- ED01
--------------------------------
PROCEDURE SP_DATOS_ED01(pd_fecpro in date,
                        pc_codsbs in varchar2,
                        tipocambio    in number,
                        pn_ctacli in number,
                        pn_inst in number,
                        ----------
                        pn_nde  out number,
                        pn_ddes  out number,
                        pn_dies  out number,
                        pn_cdds  out number,
                        pn_cdis  out number,
                        pn_ddee  out number,
                        pn_diee  out number,
                        pn_cdde  out number,
                        pn_cdie  out number,
                        pn_ing  out number,
                        pn_fting out number,
                        pd_fing  out date,
                        pn_sdda out number,
                        pc_cmma out varchar2,
                        pn_fmma out number,
                        pn_fdda out number,
                        pn_pdda out number,
                        pn_sdds out number,
                        pc_cmms out varchar2,
                        pn_fmms out number,
                        pn_fdds out number,
                        pn_pdds out number,
                        pn_rse  out number,
                        pn_acse out number,
                        pn_cce  out number,
                        pn_tdx  out number,
                        pn_nae out number
                  )is
ln_ircp number;
ln_rcp number;
ln_rpcn number;
ln_resul number;
ln_ting number;
lc_sting varchar2(50);
lc_oing varchar2(50);
ln_gneg number;
ln_gfam number;
ln_nrodep number;
--ed01--
ln_nroent number;
ln_deuDSF number;
ln_deuISF number;
ln_cuotaDSF number;
ln_cuota  number;
ln_plazo number;
ln_taza number;
ln_cuotaISF number;
ln_deudca number;
ln_deuICA number;
ln_cuotaICA number;
ln_cuotaDCA number;
ln_ingneg number;
ld_fing date;
ln_fting number;
ln_rse  number;
lc_acse varchar2(50);
ln_tdx number;
ln_cce number;
ln_nae number;
ln_ingper number;

--------

-- Cursosor Deuda Directa SF
cursor deudaDSF is
select sum(case when  substr(c_cuenta,3,1) = 2 then n_salcap * tipocambio else n_salcap end ) saldo_mn,
       Case when substr(c_cuenta,5,2) = '03' then 2
            when substr(c_cuenta,5,2) = '04' then 3
            else 1 end tipo_pres,
       Case when substr(c_cuenta,3,1) = '1' then 0 else 101 end moneda
      from cldrccs x
     where c_codsbs = pc_codsbs
       and d_fecpre = pd_fecpro
       and substr(c_cuenta,1,4) in ('1411','1412','1414','1424','1415','1425','1416','1426')
group by substr(c_cuenta,5,2),  Case when substr(c_cuenta,3,1) = '1' then 0 else 101 end;
-- Cursosor Deuda Indirecta SF
cursor deudaISF is
select sum(case when  substr(c_cuenta,3,1) = 2 then n_salcap * 3.39 else n_salcap end ) saldo_mn,
       Case when substr(c_cuenta,5,2) = '03' then 2
            else 1 end tipo_pres,
       Case when substr(c_cuenta,3,1) = '1' then 0 else 101 end moneda,
       Sum(Case when substr(c_cuenta,5,2) = '03' and substr(c_cuenta,3,1) = 2 then (n_salcap * 3.39) * 0.5
                when substr(c_cuenta,5,2) = '03' and substr(c_cuenta,3,1) = 1 then n_salcap  * 0.5
                when substr(c_cuenta,5,2) <> '03' and substr(c_cuenta,3,1) = 2 then (n_salcap * 3.39) * 0.3
                when substr(c_cuenta,5,2) <> '03' and substr(c_cuenta,3,1) = 1 then n_salcap  * 0.3 end) Saldo_cuota
      from cldrccs x
     where c_codsbs = pc_codsbs
       and d_fecpre = pd_fecpro
       and substr(c_cuenta,1,2) in ('72')
group by substr(c_cuenta,5,2),  Case when substr(c_cuenta,3,1) = '1' then 0 else 101 end;

begin
  -- nro entidades
  begin
    select n_canent
      into ln_nroent
      from cldrcci
     where c_codsbs = pc_codsbs
       and d_fecpre = pd_fecpro;
  exception
    when others then
      ln_nroent := 0;
  end;
 --  Deuda Directa SF
    ln_deuDSF  := 0;
    ln_cuotaDSF:= 0;
    for i in deudaDSF loop
       ln_cuota := 0;
       ln_deuDSF  := ln_deuDSF + i.saldo_mn;
       begin
         select JAQZ063PZO,JAQZ063TZA
           into ln_plazo, ln_taza
           from  JAQZ063
          where JAQZ063CTI = i.tipo_pres
            and JAQZ063MDA = i.moneda
            and JAQZ063FEC = (select max(JAQZ063FEC)
                               from  JAQZ063
                              where JAQZ063CTI = 1
                                and JAQZ063MDA = 0);

       exception
         when others then
           ln_plazo :=0;
           ln_taza  :=0;
       end;
       sp_Cr_FormulaGastos( i.saldo_mn, ln_taza, ln_plazo, ln_cuota);
       ln_cuotaDSF:= ln_cuotaDSF + ln_cuota;
    end loop;
 --  Deuda Indirecta SF
    ln_deuISF  := 0;
    ln_cuotaISF:= 0;
    for j in deudaISF loop
       ln_cuota := 0;
       ln_deuISF  := ln_deuISF + j.saldo_mn;
       begin
         select JAQZ063PZO,JAQZ063TZA
           into ln_plazo, ln_taza
           from  JAQZ063
          where JAQZ063CTI = j.tipo_pres
            and JAQZ063MDA = j.moneda
            and JAQZ063FEC = (select max(JAQZ063FEC)
                               from  JAQZ063
                              where JAQZ063CTI = 1
                                and JAQZ063MDA = 0);

       exception
         when others then
           ln_plazo :=0;
           ln_taza  :=0;
       end;
       sp_Cr_FormulaGastos( j.saldo_mn, ln_taza, ln_plazo, ln_cuota);
       ln_cuotaISF:= ln_cuotaISF + ln_cuota;
    end loop;
  -- Capital Caja
  ln_deuDCA := 0;
  ln_deuICA := 0;
  begin
    select sum(skcr), sum(lcnu)
      into ln_deuDCA,  ln_deuICA
      from bdc01
     where csbs = pc_codsbs;
  exception
    when others then
      ln_deuDCA := 0;
      ln_deuICA := 0;
  end;
  -- Cuota Caja

   ln_cuotaICA := 0;
   ln_cuotaDCA := 0;
   begin
      select max(a.ppcap + a.ppint)
        into ln_cuotaDCA
        from  fsd601 a, JAQL120 b
       where a.pgcod = b.bcemp
         and a.ppmod = b.bcmod
         and a.ppsuc = b.cage
         and a.ppmda = b.mon
         and a.pppap = b.bcpap
         and a.ppcta = b.bccta
         and a.ppoper = b.ccr
         and a.ppsbop = b.bcsbop
         and a.pptope = b.bctop
         and a.d601co = 'S'
         and b.csbs = pc_codsbs;
   exception
     when others then
       ln_cuotaDCA := 0;
   end;
   -- INGRESOS EBDITA
    ln_ingneg := 0;
    begin
          SELECT SUM(CASE WHEN  D.SNG026COD in (574,576,577,581) AND D.SNG023MTO <> 0 THEN Y.SNG120TCBI * D.SNG023MTO
                          WHEN  D.SNG026COD in (573) AND D.SNG023MTO <> 0 THEN (Y.SNG120TCBI * D.SNG023MTO) *-1
                          WHEN  D.SNG026COD in (73) AND D.SNG023MTO <> 0 THEN Y.SNG120TCBI *-1
                    ELSE  D.SNG023MTO END), max(x.sng021fec)
            INTO ln_ingneg ,  ld_fing
            FROM  SNG023 D,  SNG021 X,  SNG120 Y
           WHERE D.SNG021EVAL = X.SNG021EVAL
             AND Y.SNG120TSK = 'EVALUACION'
             AND X.SNG021SOL = pn_inst
             AND X.SNG021SOL = Y.SNG120INS
             AND D.SNG026COD IN (74,574,76,576,77,577,81,581,73,573);
       exception
          when no_data_found then
             ln_ingneg := 0;

          when too_many_rows then
             ln_ingneg := null;
      end;
  -- INGRESOS personas
    ln_ingper:=0;
    begin
          SELECT SUM(CASE WHEN  D.SNG026COD in (501) AND D.SNG023MTO <> 0 THEN Y.SNG120TCBI * D.SNG023MTO
                          WHEN  D.SNG026COD in (505) AND D.SNG023MTO <> 0 THEN (Y.SNG120TCBI * D.SNG023MTO) *-1
                          WHEN  D.SNG026COD in (5) AND D.SNG023MTO <> 0 THEN Y.SNG120TCBI *-1
                    ELSE  D.SNG023MTO END), max(x.sng021fec)
            INTO ln_ingper, ld_fing
            FROM  SNG023 D,  SNG021 X,  SNG120 Y
           WHERE D.SNG021EVAL = X.SNG021EVAL
             AND Y.SNG120TSK = 'EVALUACION'
             AND X.SNG021SOL = pn_inst
             AND X.SNG021SOL = Y.SNG120INS
             AND D.SNG026COD IN (1,5,501,505);
       exception
          when no_data_found then
             ln_ingneg := 0;

          when too_many_rows then
             ln_ingneg := null;
      end;
      ln_fting := 2;


  -- Sobreendeudado RCD
  begin
    select xx.ctxtxt
      into ln_rse
      from  fsx008 xx
     where xx.pgcod = 1
       and xx.ctnro = pn_ctacli
       and xx.ctxren = 14
       and xx.txcod = 208
       and xx.ctxfch = (select max(ctxfch)
                          from  fsx008
                         where pgcod = 1
                           and ctnro = pn_ctacli
                           and ctxren = 14
                           and txcod = 208);
  exception
    when others then
         ln_rse := 0;
  end;
  lc_acse := null;
  ln_tdx := 1;-- Bloqueante por Excepcion
  begin
    select 0,  E.SNG065CAR --H.SNG055DSC
      into ln_cce, ln_nae
      from   sng091 a,  sng065 e,  xwf700 g,  SNG055 H,  FPAE90 K,
             fsr008 d,  fsd001 f,  fst014 j
     where a.sng091aut = e.sng062aut --xx
       AND A.SNG091NUM = K.PAE90POL
       and a.sng001inst = g.xwfprcins
       AND E.SNG065CAR = H.SNG055CAR --xx
       and a.sng091res = 'A'
       and a.sng091tpo = 'P' --
       and g.xwfcuenta = d.ctnro
       and d.cttfir ='T'
       and d.pepais = f.pepais
       and d.petdoc = f.petdoc
       and d.pendoc = f.pendoc
       and d.petdoc = j.tdocum
       and a.sng001inst  = pn_inst;
  exception
    when others then
       ln_cce := 1;
       ln_nae := null;
  end;

  pn_nde  := ln_nae;
  pn_ddes := ln_deuDSF;
  pn_dies := ln_deuISF;
  pn_cdds  := ln_cuotaDSF;
  pn_cdis  := ln_cuotaISF;
  pn_ddee  := ln_deudca;
  pn_diee  := ln_deuICA;
  pn_cdde  := ln_cuotaDCA;
  pn_cdie  := ln_cuotaICA;
  pn_ing   := nvl(ln_ingneg,ln_ingper);
  pn_fting := ln_fting;
  pd_fing  := ld_fing;
  pn_sdda := null;
  pc_cmma := null;
  pn_fmma := null;
  pn_fdda := null;
  pn_pdda := null;
  pn_sdds := null;
  pc_cmms := null;
  pn_fmms := null;
  pn_fdds := null;
  pn_pdds := null;
  pn_rse  := ln_rse;
  pn_acse := null;
  pn_cce  := ln_cce;
  pn_tdx  := ln_tdx;
  pn_nae  := ln_nae;
end ;


  Procedure sp_job_procesa_ED01 (pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is
  select sucurs from   fst001 where pgcod =1 ;
  begin
     /*begin
         select host_name
           into lc_hostname
           from v$instance;
     end;*/
--      lc_hostname := 'SC01ZDBADM010101';

     --execute immediate ('truncate table JAQL127');
     execute immediate ('alter session set parallel_force_local=TRUE');--jflor 2014.01.16
     delete  tab_jobs  where  c_Codage = 'BDCED1';
     commit;
     for i in sucursal loop
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_sbs.sp_procesa_ED01('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
--        if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
        if sys.fn_bd_IsRAC='TRUE' then
            --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
            DBMS_JOB.SUBMIT(job => ln_job,
                          what => lc_variable,
                          next_date => sysdate+1/(24*180),
                          interval => null,
                          no_parse => false,
                          instance => 2,
                          force => false
                          );
            INSERT INTO  tab_jobs  (c_Codage,n_Numer1,c_detjob)
            VALUES('BDCED1',ln_ini,lc_variable);
            COMMIT;
         else
            DBMS_JOB.SUBMIT(job => ln_job,
                          what => lc_variable,
                          next_date => sysdate+1/(24*180),
                          interval => null,
                          no_parse => false,
                          force => false
                          );
            INSERT INTO  tab_jobs  (c_Codage,n_Numer1,c_detjob)
            VALUES('BDCED1',ln_ini,lc_variable);
            COMMIT;
         end if;
      end loop;
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'BDCED1',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

  end;

  Procedure sp_procesa_ED01 (pn_numsuc in number, pd_fecpro in varchar2 ) is

  ld_fecpro date ;
  lc_coderr varchar2(500);
  cursor prestamo is
  select distinct a.ccl, a.csbs, a.tid, a.nid, b.bccta, a.ccr,a.mon, b.n_instan, a.morg,
         a.skcr, a.tea, a.tcr, a.tpr, a.fot
    from BDC01  a,  JAQL120  b
   where a.ccl = b.ccl
     and a.ccr = b.ccr
     AND B.CAGE = pn_numsuc
  union all
     select distinct a.ccl, a.csbs, a.tid, a.nid, b.bccta, a.ccr,a.mon, b.n_instan, a.morg,
         a.skcr, a.tea, a.tcr, a.tpr, a.fot
    from BDC01  a,  JAQL120  b
   where a.ccl = b.ccl
     and a.ccr like '117%'||b.ccr
     and b.bcmod = 117
     AND B.CAGE = pn_numsuc;

  ln_ircp   number;
  ln_rcp    number;
  ln_rpcn   number;
  ln_resul  number;
  ln_ting   number;
  lc_sting  varchar2(50);
  lc_oing   varchar2(50);
  ln_gneg   number;
  ln_gfam   number;
  ln_nrodep number;
  --
  ln_nde  number;
  ln_ddes number;
  ln_dies number;
  ln_cdds number;
  ln_cdis number;
  ln_ddee number;
  ln_diee number;
  ln_cdde number;
  ln_cdie number;
  ln_ing  number;
  ln_fting number;
  ld_fing  date;
  ln_sdda number;
  lc_cmma varchar2(50);
  ln_fmma number;
  ln_fdda number;
  ln_pdda number;
  ln_sdds number;
  lc_cmms varchar2(50);
  ln_fmms number;
  ln_fdds number;
  ln_pdds number;
  ln_rse  number;
  ln_acse number;
  ln_cce  number;
  ln_tdx  number;
  ln_nae  number;
  ld_fecrcc date;
  ln_tipcam number;
  ld_fecini date;


begin

  update  tab_jobs  g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'BDCED1';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');
  ld_Fecrcc := add_months(ld_fecpro,-1);
  ld_fecini := trunc(ld_fecpro,'MONTH') - 1;
  begin
       select cotcbi
         into ln_tipcam
         from  fsh005
        where cofdes  = ld_fecpro
          and moneda = 101;
   exception
      when others then
        begin
          select cotcbi
            into ln_tipcam
            from  fsh005
           where cofdes between ld_fecini and ld_fecpro
             and moneda = 101
             and rownum = 1
           order by  cofdes desc;
        exception
           when others then
              ln_tipcam := 2.844;
        end;
   end;

  for i in prestamo loop
     begin
       pq_datos_sbs.SP_IRCP( i.n_instan, i.tcr, i.nid,
                           ln_ircp,ln_rcp,ln_rpcn,
                           ln_resul,ln_ting,lc_sting,
                           lc_oing,ln_gneg,ln_gfam,ln_nrodep);


      pq_datos_sbs.SP_DATOS_ED01(ld_Fecrcc,
                        i.csbs,
                        ln_tipcam,
                        i.bccta,
                        i.n_instan,
                        ----------
                        ln_nde ,
                        ln_ddes,
                        ln_dies,
                        ln_cdds,
                        ln_cdis,
                        ln_ddee,
                        ln_diee,
                        ln_cdde,
                        ln_cdie,
                        ln_ing,
                        ln_fting,
                        ld_fing,
                        ln_sdda,
                        lc_cmma,
                        ln_fmma,
                        ln_fdda,
                        ln_pdda,
                        ln_sdds,
                        lc_cmms,
                        ln_fmms,
                        ln_fdds,
                        ln_pdds,
                        ln_rse ,
                        ln_acse,
                        ln_cce ,
                        ln_tdx ,
                        ln_nae );

       insert into JAQL127 (d_fecpro,ccl, csbs, tid, nid,ccr,mon,
                              morg,skcr, tea, tcr, tpr, fot,
                              nde ,ddes,dies,fecrcd,cdds,cdis,
                              ddee,diee,cdde,cdie,ing,ting,
                              sting,fting,fing,oing,rcp,rpcn,
                              rcpd,
                              sdda,cmma,fmma,fdda,pdda,sdds,
                              cmms,fmms,fdds,pdds,rse ,acse,
                              cce ,tdx ,nae)
       values(ld_fecpro,i.ccl, i.csbs, i.tid, i.nid,i.ccr,i.mon,
              i.morg,i.skcr, i.tea, i.tcr, i.tpr, i.fot,
              ln_nde ,ln_ddes,ln_dies, ld_Fecrcc,ln_cdds,ln_cdis,
              ln_ddee,ln_diee,ln_cdde,ln_cdie,ln_ing,ln_ting,
              lc_sting,ln_fting, ld_fing,lc_oing,ln_rcp,ln_rpcn,
              ln_resul,
              ln_sdda,lc_cmma,ln_fmma,ln_fdda,ln_pdda,ln_sdds,
              lc_cmms,ln_fmms,ln_fdds,ln_pdds,ln_rse ,ln_acse,
              ln_cce ,ln_tdx ,ln_nae );
       commit;
     exception
        when others then
           lc_coderr:= i.n_instan ||'-'|| i.nid ||'-'|| sqlerrm ;
           INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'BDCED1',lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;
  end loop;
  commit;
  update  tab_jobs  g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'BDCED1';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update  tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'BDCED1';
    commit;
    return;

end sp_procesa_ED01;
 Procedure sp_Valida_BDC01 is
  lc_coderr varchar2(500);

-- Clave duplicada
  cursor Duplica is
  select x.ccl, x.ccr , count(*) 
    from bdc01 x 
   group by x.ccl, x.ccr 
  having count(*) > 1;
-- NCuotas 
  cursor ncprcero is
  select d_fecpro,ccl,csbs,tid,nid,ncl,ccr   
    from  bdc01 
    where nvl(NCPR,0) = 0 and tipoc is null and trim(tpr) not in ('CARTERA JUDICIAL',
    'LINEA DE CREDITO-OTORGADA','CARTA FIANZA');  
-- NCuotas pagagas > a las programadas  
  cursor pagpro is
  select d_fecpro,ccl,csbs,tid,nid,ncl,ccr     
    from  bdc01 
    where nvl(NCPA,0) > nvl(NCPR,0);
-- Prestamos que tienen pagos y no existen registro en BDC02
   cursor pagsinbdc2 is
    select d_fecpro,ccl,csbs,tid,nid,ncl,ccr 
    from  bdc01 a
    where nvl(NCPA,0) = 0 and  exists (select * from  bdc02 b 
                                        where b.ccl = a.ccl and b.ccr = a.ccr 
                                          and b.fcan is not null) ;    

-- Prestamos que no tienen pagos pero si tienen registro en BDC02
   cursor bdc2sinpag is
    select d_fecpro,ccl,csbs,tid,nid,ncl,ccr 
    from  bdc01 a
    where nvl(NCPA,0) = 0 and  exists (select * from  bdc02 b 
                                        where b.ccl = a.ccl and b.ccr = a.ccr 
                                          and b.fcan is not null) ;
-- saldo Capital > saldo Otorgado  
  cursor Salcap is
  select d_fecpro,ccl,csbs,tid,nid,ncl,ccr 
    from  bdc01 
   where SKCR > MORG and tipoc is null;
-- SAldo Capital no pagado con Nro cuotas pagadas
  cursor capnocuo is 
  select a.d_fecpro,a.ccl,a.csbs,a.tid,a.nid,a.ncl,a.ccr,
         b.bccta, b.bcsbop, b.bctop, b.bcmod, b.mon
    from bdc01 a , jaql120 b
   where a.SKCR = a.MORG and a.tipoc is null and a.ncpa > 0
     and b.ccl = a.ccl
     and b.ccr = b.ccr
   ; ---***--- 457
-- Monto Otorgado igual a cero
   cursor mtodescero is 
   select d_fecpro,ccl,csbs,tid,nid,ncl,ccr 
     from  bdc01 where MORG = 0;
-- Calificacion interna mayor a la final
   cursor calint is 
   select d_fecpro,ccl,csbs,tid,nid,ncl,ccr 
     from  bdc01 where CALINT > CAL;
-- Fecha Otorgamiento es nula 
   cursor fotnul is
   select d_fecpro,ccl,csbs,tid,nid,ncl,ccr 
     from  bdc01 where FOT is null;
-- FEcha de primer pago kapital nula 
   cursor fppknul is
   select d_fecpro,ccl,csbs,tid,nid,ncl,ccr 
     from  bdc01 where FPPK is null and cclcnu not like '72_5%';--
-- FEcha de proximo vencimiento
   cursor fvepnul is
   select d_fecpro,ccl,csbs,tid,nid,ncl,ccr 
     from  bdc01 where FVEP is  null ;
-- FEcha de primer pago no puede ser menor a la fecha de desembolso
   cursor fppkmay is
   select d_fecpro,ccl,csbs,tid,nid,ncl,ccr 
     from  bdc01 where FPPK < FOT; --*-*-*-*- 
-- Periodo de cuota igual a cero con nro de cuotas programadas mayor a 1
   cursor pcuocero is
   select d_fecpro,ccl,csbs,tid,nid,ncl,ccr 
     from  bdc01 a where PCUO = 0 and NCPR > 1; ---***---973453;3
-- Tipo de ]Credito no puede ser igual a cero
   cursor tcrcero is
   select d_fecpro,ccl,csbs,tid,nid,ncl,ccr 
     from  bdc01 where nvl(TCR,0) = 0 ;
-- Dias de atraso no puede ser menoa a cero
   cursor dakmenor is
   select d_fecpro,ccl,csbs,tid,nid,ncl,ccr 
     from  bdc01 where dak < 0;
-- Calificacion perdida sin suspenso
   cursor calper is
   select d_fecpro,ccl,csbs,tid,nid,ncl,ccr 
     from  bdc01 where cal in (3,4) and sin <> 0; 
-- Vencidos o refinanciados sin suspenso
   cursor refsinsus is
   select d_fecpro,ccl,csbs,tid,nid,ncl,ccr 
    from  bdc01 where (kre <> 0 or Kve <> 0) and sin <> 0;
ln_err number;  
  
begin
  execute immediate ('truncate table  JAQZ474 ');
  -- Actualiza Inconsistencia
  Begin
    update bdc01 
       set pcuo = case when fppk - fot < 50 then 30 
                       when fppk - fot between 80 and 100 then 90
                       else 180 end  
     where PCUO = 0 and NCPR >= 1 ;
     commit;
     update bdc01
         set tcr = case when substr(ccco,7,2) = 02 then '10'
                                        when substr(ccco,7,2) = 12 then '08'
                                        when substr(ccco,7,2) = 13 then '09'
                                        else tcr end 
       where tcr = 99;
     commit;
     Update bdc01 
        set MDCR = 'REFINANCIADO'
      where ccrf like '14_4%' and nvl(MDCR,'X') NOT LIKE 'REFINANCIA%' and krf <> 0;
    commit;  
commit;    
     
  Exception
    when others then
      null;
  end;    
  -- Clave duplicada
  begin 
   
    insert into jaqz474 (jaqz474fpro,jaqz474ccl,jaqz474csbs,jaqz474tid,jaqz474nid,
                         jaqz474ncl,jaqz474ccr,jaqz474nerr,jaqz474derr)
    select d_fecpro,ccl,csbs,tid,nid,ncl,ccr,1,'Prestamo Duplicado en BDC01'  
      from bdc01 where (ccl, ccr) in 
    (  select x.ccl, x.ccr 
      from bdc01 x 
     group by x.ccl, x.ccr 
    having count(*) > 1 );
    commit;
  exception 
     when others then 
        null;
  end;      
  -- NCuotas 
  begin
  insert into jaqz474 (jaqz474fpro,jaqz474ccl,jaqz474csbs,jaqz474tid,jaqz474nid,
                       jaqz474ncl,jaqz474ccr,jaqz474nerr,jaqz474derr)
  select d_fecpro,ccl,csbs,tid,nid,ncl,ccr, 2,'NCPR Cuotas Igual a Cero'   
    from bdc01 
    where nvl(NCPR,0) = 0 and tipoc is null and trim(tpr) not in ('CARTERA JUDICIAL',
    'LINEA DE CREDITO-OTORGADA','CARTA FIANZA');  
  commit;
  exception 
     when others then 
        null;
  end;        
  -- Nro cuotas pagagas > a las programadas  
  begin
   insert into jaqz474 (jaqz474fpro,jaqz474ccl,jaqz474csbs,jaqz474tid,jaqz474nid,
                        jaqz474ncl,jaqz474ccr,jaqz474nerr,jaqz474derr)  
  select d_fecpro,ccl,csbs,tid,nid,ncl,ccr,3,'NCPA > NCPR Nro cuotas pagagas > a las programadas'     
    from bdc01 
    where nvl(NCPA,0) > nvl(NCPR,0);
  commit;
  exception 
     when others then 
        null;
  end;        
  -- Prestamos que tienen pagos y no existen registro en BDC02
  begin
   insert into jaqz474 (jaqz474fpro,jaqz474ccl,jaqz474csbs,jaqz474tid,jaqz474nid,
                        jaqz474ncl,jaqz474ccr,jaqz474nerr,jaqz474derr)  
 
    select d_fecpro,ccl,csbs,tid,nid,ncl,ccr,4,'Prestamos que tienen pagos y no existen registro en BDC02' 
      from bdc01 a
    where nvl(NCPA,0) > 0 and not exists (select * from  bdc02 b 
                                        where b.ccl = a.ccl and b.ccr = a.ccr 
                                          and b.fcan is not null) ;    
  commit;
  exception 
     when others then 
        null;
  end; 
-- Prestamos que no tienen pagos pero si tienen registro en BDC02
  begin
    insert into jaqz474 (jaqz474fpro,jaqz474ccl,jaqz474csbs,jaqz474tid,jaqz474nid,
                         jaqz474ncl,jaqz474ccr,jaqz474nerr,jaqz474derr)  
 
    select d_fecpro,ccl,csbs,tid,nid,ncl,ccr,5,'Prestamos que no tienen pagos pero si tienen registro en BDC02' 
    from bdc01 a
    where nvl(NCPA,0) = 0 and  exists (select * from  bdc02 b 
                                        where b.ccl = a.ccl and b.ccr = a.ccr 
                                          and b.fcan is not null) ;
     commit;
  exception 
     when others then 
        null;
  end;                                       
  -- saldo Capital > saldo Otorgado  
  begin
    insert into jaqz474 (jaqz474fpro,jaqz474ccl,jaqz474csbs,jaqz474tid,jaqz474nid,
                         jaqz474ncl,jaqz474ccr,jaqz474nerr,jaqz474derr)  
  select d_fecpro,ccl,csbs,tid,nid,ncl,ccr,6,'SKCR > MORG saldo Capital > saldo Otorgado' 
    from bdc01 
   where SKCR > MORG and tipoc is null;
    commit;
  exception 
     when others then 
        null;
  end;           
-- SAldo Capital no pagado con Nro cuotas pagadas
 for i in capnocuo loop
     ln_err := 0;
     -- Verifica que los pagos no sean de interes
     begin 
       select /*+ parallel(n,2,1)*/
              count(n.ppfpag)
         into ln_err
         from  fsd601 n
        where n.pgcod  = 1
          and n.ppcta  = i.bccta
          and n.ppmda  = i.mon
          and n.pppap  = 0
          and n.ppoper = i.ccr
          and n.ppsbop = i.bcsbop
          and n.pptope = i.bctop
          and n.ppmod  = i.bcmod
          -- Se agrego como control visita SBS 2017 x observacion en calendarios
          and n.ppcap + n.ppint <> 0
          and n.ppcap > 0 
          and n.d601co = 'S'
          and exists (select /*+ parallel(o,2,1)*/  ppmod, ppcta,ppoper, pptope,ppfpag
                        from  fsd602 o
                       where o.pgcod   = n.pgcod
                         and o.ppmod   = n.ppmod
                         and o.ppsuc   = n.ppsuc
                         and o.ppmda   = n.ppmda
                         and o.pppap   = n.pppap
                         and o.ppcta   = n.ppcta
                         and o.ppoper  = n.ppoper
                         and o.ppsbop  = n.ppsbop
                         and o.pptope  = n.pptope
                         and o.ppfpag  = n.ppfpag
                         --and o.ppfpag  <= pd_fecpro
                         and o.pp1fech  <= i.d_fecpro
                         and o.pp1stat = 'T'
                         and o.d602co  = 'S');
         -- Verificar que no se traten de desembolsos programados                 
     exception
         when no_data_found then
             ln_err := 0;
          when too_many_rows then
             ln_err := 1;
     end; 
   
     if ln_err <> 0 then 
        begin
          insert into jaqz474 (jaqz474fpro,jaqz474ccl,jaqz474csbs,jaqz474tid,jaqz474nid,
                               jaqz474ncl,jaqz474ccr,jaqz474nerr,jaqz474derr)
          values (i.d_fecpro,i.ccl,i.csbs,i.tid,i.nid,i.ncl,i.ccr ,7,'SKCR = MORG SAldo Capital no pagado con Nro cuotas pagadas');
          commit;
        exception 
           when others then 
              null;
        end;           
      end if;
  end loop;      
-- Monto Otorgado igual a cero
   begin
    insert into jaqz474 (jaqz474fpro,jaqz474ccl,jaqz474csbs,jaqz474tid,jaqz474nid,
                         jaqz474ncl,jaqz474ccr,jaqz474nerr,jaqz474derr)
   select d_fecpro,ccl,csbs,tid,nid,ncl,ccr,8,'MORG Monto Otorgado igual a cero' 
     from bdc01 where MORG = 0;
    commit;
  exception 
     when others then 
        null;
  end;   
-- Calificacion interna mayor a la final
begin
   insert into jaqz474 (jaqz474fpro,jaqz474ccl,jaqz474csbs,jaqz474tid,jaqz474nid,
                        jaqz474ncl,jaqz474ccr,jaqz474nerr,jaqz474derr)
   select d_fecpro,ccl,csbs,tid,nid,ncl,ccr ,9,'CALINT > CAL Calificacion interna mayor a la final'
     from bdc01 where CALINT > CAL;
  commit;
  exception 
     when others then 
        null;
  end;        
-- Fecha Otorgamiento es nula 
   begin
   insert into jaqz474 (jaqz474fpro,jaqz474ccl,jaqz474csbs,jaqz474tid,jaqz474nid,
                        jaqz474ncl,jaqz474ccr,jaqz474nerr,jaqz474derr)
    select d_fecpro,ccl,csbs,tid,nid,ncl,ccr,10,'FOT Fecha Otorgamiento es nula' 
     from  bdc01 where FOT is null;
 commit;
  exception 
     when others then 
        null;
  end;             
-- FEcha de primer pago kapital nula 
begin
   insert into jaqz474 (jaqz474fpro,jaqz474ccl,jaqz474csbs,jaqz474tid,jaqz474nid,
                        jaqz474ncl,jaqz474ccr,jaqz474nerr,jaqz474derr)
   select d_fecpro,ccl,csbs,tid,nid,ncl,ccr ,11,'FPPK FEcha de primer pago kapital nula'
     from  bdc01 where FPPK is null and cclcnu not like '72_5%';--
commit;
  exception 
     when others then 
        null;
  end;            
-- FEcha de proximo vencimiento
 begin
   insert into jaqz474 (jaqz474fpro,jaqz474ccl,jaqz474csbs,jaqz474tid,jaqz474nid,
                        jaqz474ncl,jaqz474ccr,jaqz474nerr,jaqz474derr)
    select d_fecpro,ccl,csbs,tid,nid,ncl,ccr,12,'FVEP Fecha de proximo vencimiento nula'
     from  bdc01 where FVEP is  null ;
commit;
  exception 
     when others then 
        null;
  end;     
-- FEcha de primer pago no puede ser menor a la fecha de desembolso
 begin
   insert into jaqz474 (jaqz474fpro,jaqz474ccl,jaqz474csbs,jaqz474tid,jaqz474nid,
                        jaqz474ncl,jaqz474ccr,jaqz474nerr,jaqz474derr)
   select d_fecpro,ccl,csbs,tid,nid,ncl,ccr,13,'FPPK < FOT FEcha de primer pago no puede ser menor a la fecha de desembolso' 
     from  bdc01 where FPPK < FOT; --*-*-*-*- 
commit;
  exception 
     when others then 
        null;
  end;      
-- Periodo de cuota igual a cero con nro de cuotas programadas mayor a 1
  begin
   insert into jaqz474 (jaqz474fpro,jaqz474ccl,jaqz474csbs,jaqz474tid,jaqz474nid,
                        jaqz474ncl,jaqz474ccr,jaqz474nerr,jaqz474derr)
 select d_fecpro,ccl,csbs,tid,nid,ncl,ccr ,14,'PCUO,NCPR Periodo de cuota igual a cero con nro de cuotas programadas mayor a 1'
     from  bdc01 a where PCUO = 0 and NCPR > 1; ---***---973453;3
commit;
  exception 
     when others then 
        null;
  end;     
-- Tipo de Credito no puede ser igual a cero
  begin
   insert into jaqz474 (jaqz474fpro,jaqz474ccl,jaqz474csbs,jaqz474tid,jaqz474nid,
                        jaqz474ncl,jaqz474ccr,jaqz474nerr,jaqz474derr)
   select d_fecpro,ccl,csbs,tid,nid,ncl,ccr ,15,'TCR Tipo de Credito no puede ser igual a cero'
     from  bdc01 where nvl(TCR,0) = 0 ;
commit;
  exception 
     when others then 
        null;
  end;       
-- Dias de atraso no puede ser menoa a cero
  begin
   insert into jaqz474 (jaqz474fpro,jaqz474ccl,jaqz474csbs,jaqz474tid,jaqz474nid,
                        jaqz474ncl,jaqz474ccr,jaqz474nerr,jaqz474derr)
   select d_fecpro,ccl,csbs,tid,nid,ncl,ccr,16,'DAK Dias de atraso no puede ser menoa a cero' 
     from  bdc01 where dak < 0;
commit;
  exception 
     when others then 
        null;
  end;        
-- Calificacion perdida sin suspenso
  begin
   insert into jaqz474 (jaqz474fpro,jaqz474ccl,jaqz474csbs,jaqz474tid,jaqz474nid,
                        jaqz474ncl,jaqz474ccr,jaqz474nerr,jaqz474derr)
   select d_fecpro,ccl,csbs,tid,nid,ncl,ccr,17,'CAL,SIN Calificacion perdida sin suspenso' 
     from  bdc01 where cal in (3,4) and sin <> 0; 
commit;
  exception 
     when others then 
        null;
  end;       
-- Vencidos o refinanciados sin suspenso
  begin
   insert into jaqz474 (jaqz474fpro,jaqz474ccl,jaqz474csbs,jaqz474tid,jaqz474nid,
                        jaqz474ncl,jaqz474ccr,jaqz474nerr,jaqz474derr)
   select d_fecpro,ccl,csbs,tid,nid,ncl,ccr ,18,'KRE O KVE, SIN Vencidos o refinanciados sin suspenso'
    from  bdc01 where (kre <> 0 or Kve <> 0) and sin <> 0;
commit;
  exception 
     when others then 
        null;
  end; 
  begin
   insert into jaqz474 (jaqz474fpro,jaqz474ccl,jaqz474csbs,jaqz474tid,jaqz474nid,
                        jaqz474ncl,jaqz474ccr,jaqz474nerr,jaqz474derr)
   select d_fecpro,ccl,csbs,tid,nid,ncl,ccr ,19,'MDCR debe ser refinanciado'
      from bdc01 a
    where nvl(MDCR,'X')  not like 'REFINANCIADO%'  and  (a.ccju like '14_6__19%' or a.ccve like '14_5__19%');
  commit;
  exception 
     when others then 
        null;
  end; 
  
  -- REfinanciados con otra modalidad
    begin
         insert into jaqz474 (jaqz474fpro,jaqz474ccl,jaqz474csbs,jaqz474tid,jaqz474nid,
                              jaqz474ncl,jaqz474ccr,jaqz474nerr,jaqz474derr)
         select d_fecpro,ccl,csbs,tid,nid,ncl,ccr ,19,'MDCR debe ser refinanciado'
            from bdc01 a
              where ccrf like '14_4%'  and nvl(MDCR,'X') NOT LIKE 'REFINANCIA%';
        commit;
    exception 
      when others then 
        null;
    end; 
    -- sin modalidad
     begin
         insert into jaqz474 (jaqz474fpro,jaqz474ccl,jaqz474csbs,jaqz474tid,jaqz474nid,
                              jaqz474ncl,jaqz474ccr,jaqz474nerr,jaqz474derr)
         select d_fecpro,ccl,csbs,tid,nid,ncl,ccr ,20,'MDCR en blanco'
            from bdc01 a
           where MDCR is null;
        commit;
    exception 
      when others then 
        null;
    end; 
    -- modalidad
     begin
         insert into jaqz474 (jaqz474fpro,jaqz474ccl,jaqz474csbs,jaqz474tid,jaqz474nid,
                              jaqz474ncl,jaqz474ccr,jaqz474nerr,jaqz474derr)
         select d_fecpro,ccl,csbs,tid,nid,ncl,ccr ,21,'MDCR no corresponde NCPRG'
           from bdc01 a
           where NRPRG <> 0  and mdcr in ('NUEVO','RECURRENTE');
        commit;
    exception 
      when others then 
        null;
    end; 
 EXCEPTION
    when others then
    null;

end sp_Valida_BDC01;

function fn_cambia_tea (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                      pn_pap in number, pn_cta in number, pn_oper in number,
                      pn_sbop in number,pn_top in number, pd_fecpro in date) return number is
ln_tasa number;
begin
   begin
        select Evtasa
          into ln_tasa
          from (select Evtasa
                  from  fsd012 -- Evtasa      
                 Where Pgcod = pn_emp
                   and Aomod = pn_mod
                   and Aosuc = pn_suc
                   and Aomda = pn_mda
                   and Aopap = pn_pap
                   and Aocta = pn_cta
                   and Aooper = pn_oper
                   and Aosbop = pn_sbop
                   and Aotope = pn_top
                   and Evtipo = 3 --fijo interes
                   and D012co = 'S'
                   and D012fc <= pd_fecpro
                 order by D012fc desc)
         where rownum = 1;
   exception
     when others then 
         ln_tasa :=null;     
   end; 
   return ln_tasa;
end fn_cambia_tea;

---
Procedure Sp_RelCredi_NR(pn_pai in number,pn_tdo in number,pc_ndo in char,pd_Fecpro in date,
                         ln_contador out number)  is

cursor creditos is
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
       --a.aofe99,
       pq_cr_relcrediticia.Fn_DiaPago(a.PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,
                                                          AOSBOP,AOTOPE,aostat,aofe99)aofe99,
       a.aostat
  from  fsd010 a,  fsr008 b
 where aomod in (select modulo from  fst111 where dscod = 50 and modulo not in (200,33,108))
   --and (aofe99 >= ld_fecini or aofe99 = to_date('0001.01.01','yyyy.mm.dd'))
   and aotope <> 550
   and a.pgcod = 1
   and a.pgcod = b.pgcod
   and a.aocta = b.ctnro
   and b.pepais = pn_pai
   and b.petdoc = pn_tdo
   and b.pendoc = pc_ndo
   and a.aofval <= pd_Fecpro
order by aofval;   
                    
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


   
end Sp_RelCredi_NR;      

function fn_Tipdoc_sbs(pn_tipdoc in number) return number is
ln_tipdoc number ;
begin
  begin
        select BC206NRO2	
          into ln_tipdoc
          from  fbc206 
         where bc205cod = 414
           and BC206ID1	= pn_tipdoc;
   exception
      when others then
           ln_tipdoc := 0;
   end;
   return ln_tipdoc;
end ;
/**/

Procedure sp_job_procesa_BDC02_todo (pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is
  select sucurs from   fst001 where pgcod =1 ;
  begin
     /*begin
         select host_name
           into lc_hostname
           from v$instance;
     end;*/
--      lc_hostname := 'SC01ZDBADM010101';
     execute immediate ('truncate table  BDC02 ');
     execute immediate ('alter session set parallel_force_local=TRUE');--jflor 2014.01.16
     delete  tab_jobs  where  c_Codage = 'BDC2';
     commit;
     for i in sucursal loop
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_sbs.sp_procesa_BDC02_todo('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
--        if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
        if sys.fn_bd_IsRAC='TRUE' then
            --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
            DBMS_JOB.SUBMIT(job => ln_job,
                          what => lc_variable,
                          next_date => sysdate+1/(24*180),
                          interval => null,
                          no_parse => false,
                          instance => 2,
                          force => false
                          );
            INSERT INTO  tab_jobs  (c_Codage,n_Numer1,c_detjob)
            VALUES('BDC2',ln_ini,lc_variable);
            COMMIT;
         else
            DBMS_JOB.SUBMIT(job => ln_job,
                          what => lc_variable,
                          next_date => sysdate+1/(24*180),
                          interval => null,
                          no_parse => false,
                          force => false
                          );
            INSERT INTO  tab_jobs  (c_Codage,n_Numer1,c_detjob)
            VALUES('BDC2',ln_ini,lc_variable);
            COMMIT;
         end if;
      end loop;
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'BDC02',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

  end;


Procedure sp_procesa_BDC02_todo (pn_numsuc in number,  pd_fecpro in varchar2 ) is

  ld_fecpro date ;
  lc_coderr varchar2(300);

  cursor prestamo is
    /*select distinct ccl,bcemp,bcpap,bccta,bcsbop,
           bctop,bcmod,ccr,mon,cage,bcprod
      from JAQL120
     where cage = pn_numsuc
       and d_fecpro = ld_fecpro;*/
   select distinct a.ccl,a.bcemp,a.bcpap,a.bccta,a.bcsbop,
           a.bctop,a.bcmod,a.ccr,a.mon,a.cage,a.bcprod,a.d_fecpro, b.nrprg
      from jaql120 a, bdc01 b
     where a.cage = pn_numsuc
       and a.d_fecpro = ld_fecpro
       and a.ccr = b.ccr (+)
       and a.ccl = b.ccl (+);   

/*select distinct to_char(b.pepais) || to_char(b.petdoc)||b.pendoc  ccl,  
           a.bcemp,a.bcpap,a.bccta,a.bcsbop, a.bcfech, 
           a.bctop,a.bcmod,a.bcoper ccr,a.bcmda mon,a.bcsuc cage,a.bcprod,
           pq_datos_sbs.fn_ncpr (a.bcemp, a.bcmod, a.bcsuc, a.bcmda,
                                 a.bcpap, a.bccta, a.bcoper, a.bcsbop, 
                                 a.bctop) nrprg
      from  fsh012 a,  fsr008 b, opebdc c
     where a.bcfech = ld_fecpro --to_date('20181031','yyyymmdd')
       and a.bccta  = b.ctnro
       and a.bcemp  = b.pgcod
       and b.cttfir = 'T'
       and a.bccta  = c.sccta
       and a.bcoper = c.scoper
       and a.bcsuc  = pn_numsuc
       and a.bcemp = 1
       and a.bcrubr in ( select \*+parallel(fsd014,2)*\rubro 
                           from  fsd014
                          where pcnivc in (select modulo 
                                             from fst111 
                                            where dscod = 50 and modulo not in (29, 33, 120\*, 144*\) 
                                            union all select 117 from dual
                                            union all select 141 from dual
                                            union all select 33 from dual)
                            and pcimpu = 'S'
                            and substr(rubro,1,1) <> 9 );*/
                            
  cursor calendario (ln_emp in number, ln_suc in number, ln_mod in number,
                     ln_pap in number, ln_mda in number, ln_cta in number,
                     ln_oper in number, ln_sbop in number, ln_tope in number  ) is
  select case when d601.ppmda = 0 then 'PEN' else 'USD' end moneda,
         decode(sum(d602.pp1cap),null,sum(d601.ppcap),sum(d602.pp1cap) )  capital,
         sum(d601.ppcap) capital_c,
         sum(d601.ppcap) - sum(nvl(d602.pp1cap,0)) capital_m,
         decode(sum(d602.pp1int),null,sum(d601.ppint),sum(d602.pp1int) ) interes,
         sum(d601.ppint) interes_c,
         sum(d602.pp1intm) mora, max(d602.pp1stat) stat,d601.ppsbop,
         d601.ppfvto fecvto, max(d602.pp1fech) fecpag
 from    FSD602 d602,   FSD601 d601
      where d602.pgcod (+)   = d601.pgcod
        and d602.ppmod (+)   = d601.ppmod
        and d602.ppsuc (+)   = d601.ppsuc
        and d602.ppmda (+)   = d601.ppmda
        and d602.pppap (+)   = d601.pppap
        and d602.ppcta (+)   = d601.ppcta
        and d602.ppoper (+)  = d601.ppoper
        and d602.ppsbop (+)  = d601.ppsbop
        and d602.pptope  (+) = d601.pptope
        and d602.ppfpag (+)  = d601.ppfpag
        and d602.pp1fech (+) <= ld_fecpro
        --and d601.ppfpag <=  ld_fecpro --between add_months( to_date('20140531','yyyymmdd'), -6) and  to_date('20140531','yyyymmdd')  -- add_months(trunc(sysdate),-6) and trunc(sysdate)
        --and d601.ppfvto <=  ld_fecpro
        --and d602.pp1stat (+) = 'T'
        and d602.d602co  (+) = 'S'
        and d602.pp1salmor (+) = 0
        and d601.d601co   = 'S'
        and d601.pgcod    = ln_emp
        --and d601.ppmod    = ln_mod
        --and d601.ppsuc    = ln_suc
        and d601.ppmda    = ln_mda
        and d601.pppap    = ln_pap
        and d601.ppcta    = ln_cta
        and d601.ppoper   = ln_oper
        --and d601.ppsbop   = ln_sbop
        --and d601.pptope   = ln_tope
        and d601.ppcap + d601.ppint <> 0 
group by d601.ppmda, d601.ppfvto,d601.ppsbop
order by d601.ppfvto  ;

cursor calendario2 (ln_emp in number, ln_suc in number, ln_mod in number,
                     ln_pap in number, ln_mda in number, ln_cta in number,
                     ln_oper in number, ln_sbop in number, ln_tope in number  ) is
  select case when d601.ppmda = 0 then 'PEN' else 'USD' end moneda,
         decode(sum(d602.pp1cap),null,sum(d601.ppcap),sum(d602.pp1cap) )  capital,
         sum(d601.ppcap) capital_c,
         sum(d601.ppcap) - sum(nvl(d602.pp1cap,0)) capital_m,
         decode(sum(d602.pp1int),null,sum(d601.ppint),sum(d602.pp1int) ) interes,
         sum(d601.ppint) interes_c,
         sum(d602.pp1intm) mora,max(d602.pp1stat) stat, d601.ppsbop,
         d601.ppfvto fecvto, max(d602.pp1fech) fecpag
 from   FSD602 d602,  FSD601 d601
      where d602.pgcod (+)   = d601.pgcod
        and d602.ppmod (+)   = d601.ppmod
        and d602.ppsuc (+)   = d601.ppsuc
        and d602.ppmda (+)   = d601.ppmda
        and d602.pppap (+)   = d601.pppap
        and d602.ppcta (+)   = d601.ppcta
        and d602.ppoper (+)  = d601.ppoper
        and d602.ppsbop (+)  = d601.ppsbop
        and d602.pptope  (+) = d601.pptope
        and d602.ppfpag (+)  = d601.ppfpag
        and d602.pp1fech (+) <= ld_fecpro
        --and d601.ppfpag <=  ld_fecpro --between add_months( to_date('20140531','yyyymmdd'), -6) and  to_date('20140531','yyyymmdd')  -- add_months(trunc(sysdate),-6) and trunc(sysdate)
        --and d601.ppfvto <=  ld_fecpro
        --and d602.pp1stat (+) = 'T'
        and d602.d602co  (+) = 'S'
        and d602.pp1salmor (+) = 0
        and d601.pgcod    = ln_emp
        --and d601.ppmod    = ln_mod
        --and d601.ppsuc    = ln_suc
        and d601.ppmda    = ln_mda
        and d601.pppap    = ln_pap
        and d601.ppcta    = ln_cta
        and d601.ppoper   = ln_oper
        --and d601.ppsbop   = ln_sbop
        --and d601.pptope   = ln_tope
        and d601.ppcap + d601.ppint <> 0
        and d601.d601co   = 'S'
group by d601.ppmda, d601.ppfvto, d601.ppsbop
order by d601.ppfvto  ;

cursor cal_reprogra (ln_emp in number, ln_suc in number, ln_mod in number,
                     ln_pap in number, ln_mda in number, ln_cta in number,
                     ln_oper in number, ln_sbop in number, ln_tope in number  ) is
  select case when d601.ppmda = 0 then 'PEN' else 'USD' end moneda,
         decode(sum(d602.pp1cap),null,sum(d601.ppcap),sum(d602.pp1cap) )  capital,
         sum(d601.ppcap) capital_c,
         sum(d601.ppcap) - sum(nvl(d602.pp1cap,0)) capital_m,
         decode(sum(d602.pp1int),null,sum(d601.ppint),sum(d602.pp1int) ) interes,
         sum(d601.ppint) interes_c,
         sum(d602.pp1intm) mora,d601.ppsbop,max(d602.pp1stat) stat,
         d601.ppfvto fecvto, max(d602.pp1fech) fecpag
 from   FSD602 d602,  FSD601 d601
      where d602.pgcod (+)   = d601.pgcod
        and d602.ppmod (+)   = d601.ppmod
        and d602.ppsuc (+)   = d601.ppsuc
        and d602.ppmda (+)   = d601.ppmda
        and d602.pppap (+)   = d601.pppap
        and d602.ppcta (+)   = d601.ppcta
        and d602.ppoper (+)  = d601.ppoper
        and d602.ppsbop (+)  = d601.ppsbop
        and d602.pptope  (+) = d601.pptope
        and d602.ppfpag (+)  = d601.ppfpag
        --and d602.pp1fech (+) <= ld_fecpro
        --and d601.ppfpag <=  ld_fecpro --between add_months( to_date('20140531','yyyymmdd'), -6) and  to_date('20140531','yyyymmdd')  -- add_months(trunc(sysdate),-6) and trunc(sysdate)
        --and d601.ppfvto <=  ld_fecpro
        --and d602.pp1stat (+) = 'T'
        and d602.d602co  (+) = 'S'
        and d602.pp1salmor (+) = 0
        and d601.pgcod    = ln_emp
        --and d601.ppmod    = ln_mod
        --and d601.ppsuc    = ln_suc
        and d601.ppmda    = ln_mda
        and d601.pppap    = ln_pap
        and d601.ppcta    = ln_cta
        and d601.ppoper   = ln_oper
        and d601.ppsbop   <> ln_sbop
        --and d601.pptope   = ln_tope
        and d601.ppcap + d601.ppint <> 0
        and d601.d601co   = 'S'
        --- excluir reprogrmaciones ampleaciones refinanciaciones 
        and (d602.d602mo, d602.d602tr)  not in ( select tp1nro1, tp1nro2
                                                   from fst198
                                                  where tp1cod1 = 11124
                                                    and tp1cod = 1
                                                    and tp1corr1 = 1
                                                    and tp1corr2 = 1 )
                                                    
group by d601.ppmda, d601.ppfvto,d601.ppsbop 
order by d601.ppfvto ;


 cursor pagadela (ln_emp in number, ln_suc in number, ln_mod in number,
                     ln_pap in number, ln_mda in number, ln_cta in number,
                     ln_oper in number, ln_sbop in number, ln_tope in number  ) is
  select case when d601.ppmda = 0 then 'PEN' else 'USD' end moneda,
         decode(sum(d602.pp1cap),null,sum(d601.ppcap),sum(d602.pp1cap) )  capital,
         sum(d601.ppcap) capital_c,
         sum(d601.ppcap) - sum(nvl(d602.pp1cap,0)) capital_m,
         decode(sum(d602.pp1int),null,sum(d601.ppint),sum(d602.pp1int) ) interes,
         sum(d601.ppint) interes_c,
         sum(d602.pp1intm) mora,d601.ppsbop,
         d601.ppfvto fecvto, max(d602.pp1fech) fecpag
 from    FSD602 d602,   FSD601 d601
      where d602.pgcod  = d601.pgcod
        and d602.ppmod  = d601.ppmod
        and d602.ppsuc  = d601.ppsuc
        and d602.ppmda  = d601.ppmda
        and d602.pppap  = d601.pppap
        and d602.ppcta  = d601.ppcta
        and d602.ppoper = d601.ppoper
        and d602.ppsbop = d601.ppsbop
        and d602.pptope = d601.pptope
        and d602.ppfpag = d601.ppfpag
        and d602.pp1fech <= ld_fecpro
        and d602.ppfpag > ld_fecpro
        and d602.pp1stat  = 'T'
        and d602.d602co   = 'S'
        and d602.pp1salmor = 0
        and d601.pgcod    = ln_emp
        and d601.ppmod    = ln_mod
        and d601.ppsuc    = ln_suc
        and d601.ppmda    = ln_mda
        and d601.pppap    = ln_pap
        and d601.ppcta    = ln_cta
        and d601.ppoper   = ln_oper
        and d601.ppsbop   = ln_sbop
        and d601.pptope   = ln_tope
        and d601.ppcap + d601.ppint <> 0
        and d601.d601co   = 'S'
group by d601.ppmda, d601.ppfvto,d601.ppsbop
order by d601.ppfvto  ;

ln_scom  number;
ln_sim   number;
ln_diaart number;
ln_cap number;
ln_int number;
ln_mor number;
ln_otr number;
ln_tipcam number;
ld_fecini date;
ln_numcuo number;
lc_trasf varchar2(1);
ln_sigue varchar2(1);
begin

  update  tab_jobs  g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'BDC2';
  commit;

  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');
  ld_fecini := ld_fecpro - (to_number(to_char(ld_fecpro,'DD')) - 1);

  begin
       select cotcbi
         into ln_tipcam
         from  fsh005
        where cofdes  = ld_fecpro
          and moneda = 101;
  exception
      when others then
        begin
          select cotcbi
            into ln_tipcam
            from  fsh005
           where cofdes between ld_fecini and ld_fecpro
             and moneda = 101
             and rownum = 1
           order by  cofdes desc;
        exception
           when others then
              ln_tipcam := 3.273;
        end;
  end;

  for i in prestamo loop
     ln_numcuo := 0;
     if nvl(i.nrprg,0) = 0 then 
     for f in calendario (i.bcemp,i.cage, i.bcmod, i.bcpap, i.mon, i.bccta, i.ccr, i.bcsbop, i.bctop) loop
         ln_numcuo := ln_numcuo + 1;
         ln_sim := null;
         ln_scom := null;
         ln_cap := null;
         ln_int := null;
         ln_mor := null;
         ln_otr := null;
         begin
           ln_scom := pq_datos_sbs.fn_scom (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                            i.bccta, i.ccr, i.bcsbop,i.bctop,f.fecvto);
           if nvl(f.stat,'X') = 'P'  then 
              ln_diaart :=  (ld_fecpro - f.fecvto);
           else
              ln_diaart :=  (nvl(f.fecpag,ld_fecpro) - f.fecvto);
           end if;   
           if ln_diaart < 0 then
              ln_diaart := 0;
           else
              if nvl(f.stat,'X') = 'P' /*f.fecpag is null */ and ln_diaart > 0 then 
                  ln_sim  := abs(pq_datos_sbs.fn_sim (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                                  i.bccta, i.ccr, i.bcsbop,i.bctop,f.capital_m,ln_diaart));
              elsif f.fecpag is null  and ln_diaart > 0 then 
                  ln_sim  := abs(pq_datos_sbs.fn_sim (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                                  i.bccta, i.ccr, i.bcsbop,i.bctop,f.capital,ln_diaart));
            
              elsif f.fecpag is not null  then 
                  ln_sim := f.mora;
              end if;    
           end if;
           /*if f.mora is null then
              ln_sim:=0;
           else
              ln_sim := f.mora;
           end if; */
           if i.mon = 101 then
              if nvl(f.stat,'X') = 'P'  then 
                  ln_cap := round(f.capital_c * ln_tipcam,2);
                  ln_int := round(f.interes_c * ln_tipcam,2);
              else
                  ln_cap := round(f.capital * ln_tipcam,2);
                  ln_int := round(f.interes * ln_tipcam,2);
              end if;    
              --ln_int := round(f.interes * ln_tipcam,2);
              ln_mor := round(ln_sim * ln_tipcam,2);
              ln_otr := round(ln_scom * ln_tipcam,2);

           else
              if nvl(f.stat,'X') = 'P'  then 
                 ln_cap := round(f.capital_c,2);
                 ln_int := round(f.interes_c,2);
              else
                 ln_cap := round(f.capital,2);
                 ln_int := round(f.interes,2);
              end if;   
              
              ln_mor := round(ln_sim ,2);
              ln_otr := round(ln_scom,2);
           end if;
           
           lc_trasf := pq_datos_sbs.fn_cartrasferida(i.bccta,i.ccr);
           --if nvl(f.stat,'X') <> 'P' and  f.fecvto <= ld_fecpro then  
               insert into  BDC02  (ccl,ccr,ncuo,mon,mcuo,
                                  sic, scom, sim, fvep, fcan,CRACL,Hora)
                values (i.ccl, i.ccr,ln_numcuo,f.moneda,ln_cap,
                        ln_int,ln_otr,ln_mor, f.fecvto, decode( nvl(f.stat,'X'),'P', null, f.fecpag),lc_trasf,f.ppsbop);
           --end if;             
         exception
         when others then
               lc_coderr:=sqlerrm;
               INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
               VALUES(0,'DATABDC2',lc_coderr, TRUNC(SYSDATE));
               COMMIT;
         end;
         commit;
      end loop;
      if   ln_numcuo = 0 then
        for f in calendario2 (i.bcemp,i.cage, i.bcmod, i.bcpap, i.mon, i.bccta, i.ccr, i.bcsbop, i.bctop) loop
         ln_numcuo := ln_numcuo + 1;
         ln_sim := null;
         ln_scom := null;
         ln_cap := null;
         ln_int := null;
         ln_mor := null;
         ln_otr := null;
         begin
           ln_scom := pq_datos_sbs.fn_scom (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                            i.bccta, i.ccr, i.bcsbop,i.bctop,f.fecvto);
           if nvl(f.stat,'X') = 'P'  then 
              ln_diaart :=  (ld_fecpro - f.fecvto);
           else
              ln_diaart :=  (nvl(f.fecpag,ld_fecpro) - f.fecvto);
           end if;
           if ln_diaart < 0 then
              ln_diaart := 0;
           else
              ln_sim  := pq_datos_sbs.fn_sim (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                              i.bccta, i.ccr, i.bcsbop,i.bctop,f.capital,ln_diaart);
           end if;
           /*if f.mora is null then
              ln_sim:=0;
           else
              ln_sim := f.mora;
           end if; */
           if i.mon = 101 then
              if nvl(f.stat,'X') = 'P'  then 
                  ln_cap := round(f.capital_c * ln_tipcam,2);
                  ln_int := round(f.interes_c * ln_tipcam,2);
              else
                  ln_cap := round(f.capital * ln_tipcam,2);
                  ln_int := round(f.interes * ln_tipcam,2);
              end if;
              
              ln_mor := round(ln_sim * ln_tipcam,2);
              ln_otr := round(ln_scom * ln_tipcam,2);
           else
              if nvl(f.stat,'X') = 'P'  then 
                 ln_cap := round(f.capital_c,2);
                 ln_int := round(f.interes_c,2);
              else
                 ln_cap := round(f.capital,2);
                 ln_int := round(f.interes,2);
              end if; 
              
              ln_mor := round(ln_sim ,2);
              ln_otr := round(ln_scom,2);
           end if;
           lc_trasf := pq_datos_sbs.fn_cartrasferida(i.bccta,i.ccr);
           /*lc_hortra := pq_datos_sbs.fn_hora_trasn(i.bcemp, i.bcmod,i.cage, i.bcpap,
                                                    i.mon, i.bccta, i.ccr, i.bcsbop,
                                                    i.bctop, f.fecpag);*/
           
                    
           if nvl(f.stat,'X') <> 'P' and  f.fecvto <= ld_fecpro then  
              insert into  BDC02  (ccl,ccr,ncuo,mon,mcuo,
                              sic, scom, sim, fvep, fcan,CRACL,Hora)
              values (i.ccl, i.ccr,ln_numcuo,f.moneda,ln_cap,
                    ln_int,ln_otr,ln_mor, f.fecvto, f.fecpag,lc_trasf,f.ppsbop);
           end if;
                    
         exception
         when others then
               lc_coderr:=sqlerrm;
               INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
               VALUES(0,'DATABDC2',lc_coderr, TRUNC(SYSDATE));
               COMMIT;
         end;
         commit;
      end loop;
      end if;
      else
         for f in cal_reprogra (i.bcemp,i.cage, i.bcmod, i.bcpap, i.mon, i.bccta, i.ccr, i.bcsbop, i.bctop) loop
               ln_numcuo := ln_numcuo + 1;
               ln_sim := null;
               ln_scom := null;
               ln_cap := null;
               ln_int := null;
               ln_mor := null;
               ln_otr := null;
               begin
                 ln_scom := pq_datos_sbs.fn_scom (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                                  i.bccta, i.ccr, f.ppsbop,i.bctop,f.fecvto);
                 if nvl(f.stat,'X') = 'P'  then 
                    ln_diaart :=  (ld_fecpro - f.fecvto);
                 else
                    ln_diaart :=  (nvl(f.fecpag,ld_fecpro) - f.fecvto);
                 end if;
                 if ln_diaart < 0 then
                    ln_diaart := 0;
                 else
                    ln_sim  := f.mora;/*pq_datos_sbs.fn_sim (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                                    i.bccta, i.ccr, f.ppsbop,i.bctop,f.capital,ln_diaart);*/
                 end if;
                 /*if f.mora is null then
                    ln_sim:=0;
                 else
                    ln_sim := f.mora;
                 end if; */
                  if i.mon = 101 then
                    if nvl(f.stat,'X') = 'P'  then 
                        ln_cap := round(f.capital_c * ln_tipcam,2);
                        ln_int := round(f.interes_c * ln_tipcam,2);
                    else
                        ln_cap := round(f.capital * ln_tipcam,2);
                        ln_int := round(f.interes * ln_tipcam,2);
                    end if;
                    
                    ln_mor := round(ln_sim * ln_tipcam,2);
                    ln_otr := round(ln_scom * ln_tipcam,2);
                 else
                    if nvl(f.stat,'X') = 'P'  then 
                       ln_cap := round(f.capital_c,2);
                       ln_int := round(f.interes_c,2);
                    else
                       ln_cap := round(f.capital,2);
                       ln_int := round(f.interes,2);
                    end if; 
                    
                    ln_mor := round(ln_sim ,2);
                    ln_otr := round(ln_scom,2);
                 end if;
                 lc_trasf := pq_datos_sbs.fn_cartrasferida(i.bccta,i.ccr);
                 /*lc_hortra := pq_datos_sbs.fn_hora_trasn(i.bcemp, i.bcmod,i.cage, i.bcpap,
                                                          i.mon, i.bccta, i.ccr, i.bcsbop,
                                                          i.bctop, f.fecpag);*/
                 
                 --if nvl(f.stat,'X') <> 'P' /*and  f.fecvto <= ld_fecpro*/ then  
                      insert into  BDC02  (ccl,ccr,ncuo,mon,mcuo,
                                    sic, scom, sim, fvep, fcan,CRACL,Hora)
                      values (i.ccl, i.ccr,ln_numcuo,f.moneda,ln_cap,
                          ln_int,ln_otr,ln_mor, f.fecvto,decode(nvl(f.stat,'X'),'P', null, f.fecpag),lc_trasf,f.ppsbop);
                 --end if; 
                 
                
               exception
               when others then
                     lc_coderr:=sqlerrm;
                     INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
                     VALUES(0,'DATABDC2',lc_coderr, TRUNC(SYSDATE));
                     COMMIT;
               end;
               commit;
          
      end loop;
      ln_numcuo := 0;
      for f in calendario (i.bcemp,i.cage, i.bcmod, i.bcpap, i.mon, i.bccta, i.ccr, i.bcsbop, i.bctop) loop
         ln_numcuo := ln_numcuo + 1;
         ln_sim := null;
         ln_scom := null;
         ln_cap := null;
         ln_int := null;
         ln_mor := null;
         ln_otr := null;
         begin
           ln_scom := pq_datos_sbs.fn_scom (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                            i.bccta, i.ccr, i.bcsbop,i.bctop,f.fecvto);
           if nvl(f.stat,'X') = 'P'  then 
              ln_diaart :=  (ld_fecpro - f.fecvto);
           else
              ln_diaart :=  (nvl(f.fecpag,ld_fecpro) - f.fecvto);
           end if;
           if ln_diaart < 0 then
              ln_diaart := 0;
           else
              if nvl(f.stat,'X') = 'P' /*f.fecpag is null */ and ln_diaart > 0 then 
                  ln_sim  := abs(pq_datos_sbs.fn_sim (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                                  i.bccta, i.ccr, i.bcsbop,i.bctop,f.capital_m,ln_diaart));
              elsif f.fecpag is null  and ln_diaart > 0 then 
                  ln_sim  := abs(pq_datos_sbs.fn_sim (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                                  i.bccta, i.ccr, i.bcsbop,i.bctop,f.capital,ln_diaart));
            
              elsif f.fecpag is not null  then 
                  ln_sim := f.mora;
              end if;    
   
           end if;
           /*if f.mora is null then
              ln_sim:=0;
           else
              ln_sim := f.mora;
           end if; */
            if i.mon = 101 then
              if nvl(f.stat,'X') = 'P'  then 
                  ln_cap := round(f.capital_c * ln_tipcam,2);
                  ln_int := round(f.interes_c * ln_tipcam,2);
              else
                  ln_cap := round(f.capital * ln_tipcam,2);
                  ln_int := round(f.interes * ln_tipcam,2);
              end if;
              
              ln_mor := round(ln_sim * ln_tipcam,2);
              ln_otr := round(ln_scom * ln_tipcam,2);
           else
              if nvl(f.stat,'X') = 'P'  then 
                 ln_cap := round(f.capital_c,2);
                 ln_int := round(f.interes_c,2);
              else
                 ln_cap := round(f.capital,2);
                 ln_int := round(f.interes,2);
              end if; 
              
              ln_mor := round(ln_sim ,2);
              ln_otr := round(ln_scom,2);
           end if;
           lc_trasf := pq_datos_sbs.fn_cartrasferida(i.bccta,i.ccr);
           --if nvl(f.stat,'X') <> 'P' and  f.fecvto <= ld_fecpro then  
               insert into  BDC02  (ccl,ccr,ncuo,mon,mcuo,
                                  sic, scom, sim, fvep, fcan,CRACL,HORA)
                values (i.ccl, i.ccr,ln_numcuo,f.moneda,ln_cap,
                        ln_int,ln_otr,ln_mor, f.fecvto, decode( nvl(f.stat,'X'),'P', null, f.fecpag),lc_trasf,f.ppsbop);
           --end if;  
         exception
         when others then
               lc_coderr:=sqlerrm;
               INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
               VALUES(0,'DATABDC2',lc_coderr, TRUNC(SYSDATE));
               COMMIT;
         end;
         commit;
      end loop;
      if   ln_numcuo = 0 then
        for f in calendario2 (i.bcemp,i.cage, i.bcmod, i.bcpap, i.mon, i.bccta, i.ccr, i.bcsbop, i.bctop) loop
         ln_numcuo := ln_numcuo + 1;
         ln_sim := null;
         ln_scom := null;
         ln_cap := null;
         ln_int := null;
         ln_mor := null;
         ln_otr := null;
         begin
           ln_scom := pq_datos_sbs.fn_scom (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                            i.bccta, i.ccr, i.bcsbop,i.bctop,f.fecvto);
           if nvl(f.stat,'X') = 'P'  then 
              ln_diaart :=  (ld_fecpro - f.fecvto);
           else
              ln_diaart :=  (nvl(f.fecpag,ld_fecpro) - f.fecvto);
           end if;
           if ln_diaart < 0 then
              ln_diaart := 0;
           else
              ln_sim  := pq_datos_sbs.fn_sim (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                              i.bccta, i.ccr, i.bcsbop,i.bctop,f.capital,ln_diaart);
           end if;
           /*if f.mora is null then
              ln_sim:=0;
           else
              ln_sim := f.mora;
           end if; */
            if i.mon = 101 then
              if nvl(f.stat,'X') = 'P'  then 
                  ln_cap := round(f.capital_c * ln_tipcam,2);
                  ln_int := round(f.interes_c * ln_tipcam,2);
              else
                  ln_cap := round(f.capital * ln_tipcam,2);
                  ln_int := round(f.interes * ln_tipcam,2);
              end if;
              
              ln_mor := round(ln_sim * ln_tipcam,2);
              ln_otr := round(ln_scom * ln_tipcam,2);
           else
              if nvl(f.stat,'X') = 'P'  then 
                 ln_cap := round(f.capital_c,2);
                 ln_int := round(f.interes_c,2);
              else
                 ln_cap := round(f.capital,2);
                 ln_int := round(f.interes,2);
              end if; 
              
              ln_mor := round(ln_sim ,2);
              ln_otr := round(ln_scom,2);
           end if;
           lc_trasf := pq_datos_sbs.fn_cartrasferida(i.bccta,i.ccr);
           /*lc_hortra := pq_datos_sbs.fn_hora_trasn(i.bcemp, i.bcmod,i.cage, i.bcpap,
                                                    i.mon, i.bccta, i.ccr, i.bcsbop,
                                                    i.bctop, f.fecpag);*/
           insert into  BDC02  (ccl,ccr,ncuo,mon,mcuo,
                              sic, scom, sim, fvep, fcan,CRACL,Hora)
            values (i.ccl, i.ccr,ln_numcuo,f.moneda,ln_cap,
                    ln_int,ln_otr,ln_mor, f.fecvto, decode( nvl(f.stat,'X'),'P', null, f.fecpag),lc_trasf,f.ppsbop);
         exception
         when others then
               lc_coderr:=sqlerrm;
               INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
               VALUES(0,'DATABDC2',lc_coderr, TRUNC(SYSDATE));
               COMMIT;
         end;
         commit;
      end loop;
      end if;
      end if; 
      /*for f in pagadela (i.bcemp,i.cage, i.bcmod, i.bcpap, i.mon, i.bccta, i.ccr, i.bcsbop, i.bctop) loop
         ln_numcuo := ln_numcuo + 1;
         ln_sim := null;
         ln_scom := null;
         ln_cap := null;
         ln_int := null;
         ln_mor := null;
         ln_otr := null;
         begin
           ln_scom := pq_datos_sbs.fn_scom (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                            i.bccta, i.ccr, i.bcsbop,i.bctop,f.fecvto);
           ln_diaart :=  (nvl(f.fecpag,trunc(sysdate)) - f.fecvto);
           if ln_diaart < 0 then
              ln_diaart := 0;
           else
              ln_sim  := pq_datos_sbs.fn_sim (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                              i.bccta, i.ccr, i.bcsbop,i.bctop,f.capital,ln_diaart);
           end if;
           \*if f.mora is null then
              ln_sim:=0;
           else
              ln_sim := f.mora;
           end if; *\
           if i.mon = 101 then
              ln_cap := round(f.capital * ln_tipcam,2);
              ln_int := round(f.interes * ln_tipcam,2);
              ln_mor := round(ln_sim * ln_tipcam,2);
              ln_otr := round(ln_scom * ln_tipcam,2);
           else
              ln_cap := round(f.capital,2);
              ln_int := round(f.interes,2);
              ln_mor := round(ln_sim ,2);
              ln_otr := round(ln_scom,2);
           end if;
           lc_trasf := pq_datos_sbs.fn_cartrasferida(i.bccta,i.ccr);
           insert into  BDC02  (ccl,ccr,ncuo,mon,mcuo,
                              sic, scom, sim, fvep, fcan,CRACL,HORA)
            values (i.ccl, i.ccr,ln_numcuo,f.moneda,ln_cap,
                    ln_int,ln_otr,ln_mor, f.fecvto, f.fecpag,lc_trasf,f.ppsbop);
         exception
         when others then
               lc_coderr:=sqlerrm;
               INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
               VALUES(0,'DATABDC2',lc_coderr, TRUNC(SYSDATE));
               COMMIT;
         end;
         commit;
      end loop;*/
  end loop;
  commit;
  update  tab_jobs  g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'BDC2';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update  tab_jobs  g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'BDC2';
    commit;
    return;

end sp_procesa_BDC02_todo;
/*REprocessa datos observados*/
Procedure sp_procesa_BDC01_O (pn_numsuc in number, pd_fecpro in varchar2 ) is

  ld_fecpro date ;
  lc_coderr varchar2(300);
  cursor prestamo is

select a.D_FECPRO,a.CCL,a.CSBS,a.TID,a.NID,a.NCL,a.CCR,a.MON moneda,a.MORG,a.SKCR,a.DAK,a.DAKR,a.DAPR,
       a.FOT,a.ESAM,a.DGR,a.FPPK,a.FVEG,a.FVEP,a.PCUO,a.NCPR,a.NCPA,a.CIIU,a.TPR,a.RFA,--a.CAGE,
       a.MDCR,a.NRPRG,a.FULTRPRG, b.mon,b.cage, b.bccta, b.bcmod, b.bcemp, b.bcpap, b.bcsbop,
       b.bctop, b.bcprod, b.n_instan, b.bcrubr
 from bdc01 a, jaql120 b
where a.ccl = b.ccl
  and a.ccr = b.ccr
  and b.cage = pn_numsuc
  --and a.segc is null
  --and a.mdcr like 'REP%' and a.nrprg =  0
  --and b.d_fecpro = to_date('20180831','yyyymmdd')
   -- /*and csbs = '0074281630'*/ and ccr = '2300121'
   --and bcmod =117
  -- and a.ccr in (3563447)
  
  union all
select a.D_FECPRO,a.CCL,a.CSBS,a.TID,a.NID,a.NCL,a.CCR,a.MON moneda,a.MORG,a.SKCR,a.DAK,a.DAKR,a.DAPR,
       a.FOT,a.ESAM,a.DGR,a.FPPK,a.FVEG,a.FVEP,a.PCUO,a.NCPR,a.NCPA,a.CIIU,a.TPR,a.RFA,--a.CAGE,
       a.MDCR,a.NRPRG,a.FULTRPRG, b.mon,b.cage, b.bccta, b.bcmod, b.bcemp, b.bcpap, b.bcsbop,
       b.bctop, b.bcprod, b.n_instan, b.bcrubr
    from BDC01  a,  JAQL120  b
   where a.ccl = b.ccl
     and a.ccr like '117%'||b.ccr
     and b.bcmod = 117
     and B.CAGE = pn_numsuc
     /*and a.segc is null*/;
   
ln_dak   number;
ln_dakr  number;
ln_dapr  number;
ln_Dgr   number;
ld_fvep  date;
ln_ncpa  number;
--
ln_skcr  number;
ln_pci   number;
ln_sin   number;
ln_csin  number;
ln_sid   number;
ln_sid2   number;
ln_ccsid number;
ln_ccsid2 number;
ln_sis   number;
ln_ccsis number;
ld_fot   date;--
ld_fppk  date;--
ld_fep   date;
ln_pcuo  number;---
ln_ncpr  number;--
ln_ciiu  number;
lc_mdcr  varchar2(20);--
ln_nrprg number;--
ld_fultrprg varchar2(10);--
ln_indic number;
ln_lco   number;
ln_lcnu  number;
ln_cclcnu number;
lc_tcr   varchar2(2);
ln_secint number;
lc_tcrint varchar2(2);
ln_esam number;
ln_rfa number;
lc_TCRI   varchar2(40);
lc_TSPR   varchar2(100);
ln_CCND   number;
lc_CCCCND varchar2(40);
ln_ROM    number;
lc_deslin varchar2(1);
ln_ccr VARCHAR2(17);
lc_tipoc varchar2(20);
lc_trasf varchar2(1);
ln_cbtea number;
ln_tea number;
lc_indamp varchar2(1);--
ln_pais number;--
ln_tipdoc number;--
lc_numdoc varchar2(12);--
lc_tipcli varchar2(50);
ln_segmen number;
lc_tipclic varchar2(50);
lc_segcre  varchar2(50);
ln_segmer number;
ld_fecsol date;
begin

  update  tab_jobs  g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'BDC1';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');

  for i in prestamo loop
      -- inicializa variables 
     ld_fvep  := null;
     ln_Dgr    := null;
     --
     ln_dak    := null;
     ln_dakr   := null;
     ln_dapr   := null;
     ln_ncpa   := null;
     ln_nrprg  := null;
     ld_fultrprg:= null;
     lc_indamp:= null;
     ld_fppk := null;
     ld_fvep := null;
     ln_pais := null;
     ln_tipdoc:= null;
     lc_numdoc := null;
      lc_mdcr := null;
      lc_tipcli := null;
     ln_segmen := null; 
     lc_tipclic := null;
     lc_segcre := null;
     ln_segmer := null;
     ld_fecsol := null;
--
     
   /*     
     ln_dak  :=  fn_dias_atraso(ld_fecpro, i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                        i.bccta, i.ccr, i.bcsbop,i.bctop,i.bcprod,i.fveg);
     --08/2018
     \*ln_dakr :=  fn_dias_atraso_up(ld_fecpro\*trunc(sysdate)*\, i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                        i.bccta, i.ccr, i.bcsbop,i.bctop,i.bcprod,i.fveg);
     ln_dapr := pq_datos_sbs.fn_dapr(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                     i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro);
     ld_fvep := pq_datos_sbs.fn_fvep(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                    i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro);*\
 
     pq_datos_sbs.sp_nrprg_fultrprg (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                     i.bccta, i.ccr, i.bcsbop,i.bctop, nvl(i.n_instan,0),ld_fecpro,
                                     ln_nrprg, ld_fultrprg, lc_indamp);
     if nvl(ln_nrprg,0) = 0 then
        ld_fultrprg := null;
     else
        ld_fultrprg := pq_datos_sbs.fn_ult_rprg (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                     i.bccta, i.ccr, i.bcsbop,i.bctop, nvl(i.n_instan,0),ld_fecpro,i.bcrubr);
     end if;                                
                                     
     ld_fot  := pq_datos_sbs.fn_fot(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                    i.bccta, i.ccr, i.bcsbop,i.bctop, nvl(ln_nrprg,0) );
     pq_datos_sbs.sp_dgr_pcuo_ncpr(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                   i.bccta, i.ccr, i.bcsbop,i.bctop,nvl(ln_nrprg,0) ,ln_Dgr,ln_pcuo,ln_ncpr );
     ld_fppk := pq_datos_sbs.fn_fppk(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                    i.bccta, i.ccr, i.bcsbop,i.bctop,nvl(ln_nrprg,0), ld_fot);
     ld_fvep := pq_datos_sbs.fn_fvep(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                    i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro);
     ln_ncpa := pq_datos_sbs.fn_ncpa (i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                    i.bccta, i.ccr, i.bcsbop,i.bctop,nvl(ln_nrprg,0),ld_fecpro);*/
      begin
       select w.pepais, w.petdoc, w.pendoc
         into ln_pais, ln_tipdoc, lc_numdoc 
         from  fsr008 w
        where w.pgcod = 1
          and w.ctnro = i.bccta
          and w.cttfir = 'T';
         
     exception
       when others then
          ln_pais :=604;
          ln_tipdoc:= i.tid;
          lc_numdoc:= i.nid;
     end;  
     
  /*   ln_pais := to_number(substr(i.ccl,1,3));                               
     lc_mdcr := pq_datos_sbs.fn_mdcr(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap,
                                    i.bccta, i.ccr, i.bcsbop,i.bctop, ld_fecpro,
                                    i.bcrubr, i.bcprod, i.n_instan,lc_indamp,nvl(ln_nrprg,0),
                                    ln_pais, ln_tipdoc, lc_numdoc );
     
*/     
     pq_datos_sbs.sp_TIPCLI(ld_fecpro,
                                       ln_pais,
                                       ln_tipdoc,
                                       lc_numdoc,
                                       'BANTPROD',
                                       ln_segmen,
                                       lc_tipcli); 
     
     lc_tipclic:= pq_datos_sbs.fn_tipli_cierre(ln_pais,ln_tipdoc,lc_numdoc, ld_fecpro) ;   
     --- 
     begin 
        select nvl(trunc(max(w.wfiteminit)), i.FOT)
         into ld_Fecsol
         from  WFWRKITEMS w 
        where w.WFINSPRCID = i.n_instan 
          and w.WFTASKCOD  = 3 ;
     exception 
       when others then 
         ld_Fecsol := i.FOT;
     end ;  
     
     
    /* 
     begin
           select q.jaqy067ncal 
             into lc_segcre
             from  jaqy066 z,  jaqy067 q 
            where z.jaqy066paic  = ln_pais 
              and z.jaqy066tdoc  = ln_tipdoc 
              and z.jaqy066tndoc = lc_numdoc
              and z.jaqy066pano  = to_number(to_char(i.fot,'yyyy'))
              and z.jaqy066pmes  = to_number(to_char(i.fot,'mm'))
              and z.jaqy066nse   = 'S'
              and z.jaqy066calf  = q.jaqy067ccal;

        exception
          when others then 
             lc_segcre := null;
        end;*/
        -- Segmento Persona
       
           begin
              select to_number(p.pae71val)
                into ln_segmer
                from  fpae70 r,  fpae71 p
               where r.pae70ins = i.n_instan
                 and r.pae51eva = p.pae51eva
                 and r.pae70nro = p.pae70nro
                 and p.pae71ite in (43)
                 and r.pae51eva = 1--2
                 and r.pae70nro = (select max(d.pae70nro)
                                     from  fpae70 d
                                    where d.pae70ins = r.pae70ins
                                      and d.pae51eva = 1 /*2*/)
                 and trim(p.pae71val) in('2','1')
              group by p.pae71val ;  
               
           exception
             when others then
               ln_segmer:= null;
           end; 
           
           -- buscar en la pae segmento desembolso
           if ln_segmer = 1 then
              begin  
                  select p.pae71val
                    into lc_segcre
                    from  fpae70 r,  fpae71 p
                   where r.pae70ins = i.n_instan
                     and r.pae51eva = p.pae51eva
                     and r.pae70nro = p.pae70nro
                     and p.pae71ite in (380)
                     and r.pae51eva = 1 --2
                     and r.pae70nro = (select max(d.pae70nro)
                                         from  fpae70 d
                                        where d.pae70ins = r.pae70ins
                                          and d.pae51eva = 1 /*2*/)
                  group by p.pae71val ;
               exception
                 when others then 
                      lc_segcre := null;
               end;        

           else 
             
              begin 
                  select p.pae71val
                    into lc_segcre
                    from  xwf070 x,  fpae70 r,  fpae71 p
                   where r.pae70ins = x.xwfprcin
                     and x.xwfprcin = i.n_instan
                     and r.pae51eva = p.pae51eva
                     and r.pae70nro = p.pae70nro
                     and p.pae71ite in (443)
                     and r.pae51eva = 1 --2
                     and r.pae70nro = (select max(d.pae70nro)
                                         from  fpae70 d
                                        where d.pae70ins = r.pae70ins
                                          and d.pae51eva = 1/*2*/)
                  group by p.pae71val ;
               exception
                 when others then 
                      lc_segcre := null;
               end;    
           end if; 
           
           -- 
           /* begin
           select sn07.sngc07dsc
             into lc_sececo_pae
            from  sngc07 sn07
           where sn07.sngc07cod = to_number(lc_sececo_pae);  
            exception
             when others then
               lc_sececo:= null;
           end;   */
     
                                   
     begin
       null;
/*       update BDC01
          set tcli  = lc_tipcli,
              segc  = ln_segmen,
              tclic = lc_tipclic,
              segcd  = ln_segmer,
              tclid  = lc_segcre,
              fecsol = nvl(ld_Fecsol,i.FOT)
         \* set FVEP = ld_fvep, 
              DAK  = ln_dak, 
              nrprg = ln_nrprg, 
              fultrprg = ld_fultrprg,
              FOT  = ld_fot,
              NCPA = ln_ncpa,
              DGR  = ln_Dgr,
              PCUO = ln_pcuo,
              NCPR = ln_ncpr,
              fppk = ld_fppk,
              MDCR = lc_mdcr*\
       where ccl = i.ccl
         and ccr = i.ccr; */
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'DATABCD1',lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;
     commit;
  end loop;
  commit;
  update  tab_jobs  g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'BDC1';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update  tab_jobs  g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'BDC1';
    commit;
    return;

end sp_procesa_BDC01_O;
Procedure sp_job_procesa_BDC01_O (pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is
  select sucurs from  fst001 where pgcod =1 and sucurs < 800 ;
  begin
    execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
    /*begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                    tabname          => 'JAQL120',
                                    degree           => 4,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;*/
    /*begin
         select host_name
           into lc_hostname
           from v$instance;
    end;*/
--     lc_hostname := 'SC01ZDBADM010101';

     execute immediate ('alter session set parallel_force_local=TRUE');--jflor 2014.01.16
     delete  tab_jobs  where  c_Codage = 'BDC1';
     commit;
     for i in sucursal loop
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_sbs.sp_procesa_BDC01_O('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
--        if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
        if sys.fn_bd_IsRAC='TRUE' then
             --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
             DBMS_JOB.SUBMIT(job => ln_job,
                          what => lc_variable,
                          next_date => sysdate+1/(24*180),
                          interval => null,
                          no_parse => false,
                          instance => 2,
                          force => false
                          );
            INSERT INTO  tab_jobs  (c_Codage,n_Numer1,c_detjob)
            VALUES('BDC1',ln_ini,lc_variable);
            COMMIT;
       else
           DBMS_JOB.SUBMIT(job => ln_job,
                          what => lc_variable,
                          next_date => sysdate+1/(24*180),
                          interval => null,
                          no_parse => false,
                          force => false
                          );
            INSERT INTO  tab_jobs  (c_Codage,n_Numer1,c_detjob)
            VALUES('BDC1',ln_ini,lc_variable);
            COMMIT;
       end if;
      end loop;
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'BDC01',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

  end;
  
  ----- parche
  
  function   fn_ult_rprg (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                 pn_pap in number, pn_cta in number, pn_oper in number,
                 pn_sbop in number,pn_top in number, pn_instac in number,pd_fecpro in date, pn_rubro in number) return varchar2 is
ln_amplia number;
lc_modalid varchar2(20);
ld_fecamp date;
ln_numrep number;
ld_fulrep date;
ld_fecref date;
ln_totcam number;
ld_fulcam varchar2(10);
lc_indamp varchar2(1);
ld_fdesatre date;
begin
     -- refinanciados
     if (substr(pn_rubro,4,1) IN (5,6) and substr(pn_rubro,7,2) = 19 ) or 
               ( substr(pn_rubro,4,1) = 4 ) then
         begin 
            select max(hfvco)
              into ld_fecref
              from  fsh016 d
             where hcta = pn_cta
               and hoper = pn_oper
               /**/
               and d.hmda = pn_mda
               and d.hpap = pn_pap
               /**/
               and hcmod not in (99, 98)
               and (hcmod, htran) in (select tp1nro1, tp1nro2
                                        from fst198
                                       where tp1cod1 = 11124
                                         and tp1cod = 1
                                         and tp1corr1 = 1
                                         and tp1corr2 = 1)
               and hrubro in
                   (select /*+parallel(fsd014,2)*/
                     rubro --15.03.2015
                      from  fsd014
                     where pcnivc in (select modulo
                                        from fst111
                                       where dscod = 50
                                         and modulo not in (29, 33, 120 /*, 144*/)
                                      union all
                                      select 117
                                        from dual
                                      union all
                                      select 141 from dual)
                       and pcimpu = 'S'
                       and ( substr(rubro,4,1 ) = 4 or  substr(rubro,7,2 )  = 19 ));
         
         exception
           --when no_data_found then 
                
           when others then 
             ld_fecref := null;
             
         end; 
     end if;
     
                
     
     
     -- Ampliacion
     begin
    /*    select nvl(SNG001ORI,0), SNG001FIN
          into ln_amplia, ld_fecamp
          from  sng001
         where sng001inst = pn_instac;*/
       select 4,a.HFCON
         into ln_amplia, ld_fecamp
         from  fsh016 a,  fsh015 b 
        where a.pgcod = b.pgcod
          and a.hcmod = b.hcmod
          and a.hsucor = b.hsucor
          and a.htran = b.htran
          and a.hnrel = b.hnrel
          and a.hfcon = b.hfcon
          and a.hcta  = pn_cta
          and a.hoper = pn_oper
           /**/
               and hmda = pn_mda
               and hpap = pn_pap
               /**/
          and b.hcmod = 30
          and b.htran in (360,357)
          and b.hccorr = 0
          and b.hfvc <= pd_fecpro
          and a.hrubro in (select /*+all_rows*/rubro 
                             from  fsd014 
                            where pcimpu ='S' 
                              and pcnivc in(select modulo from   fst111 
                                             where dscod = 50 and modulo not in (29,120,144)
                                             union all
                                            select modulo from   fst003 where modulo in (117,141))
                                               and pmtit <> 9) ;

                   
         
     exception
         when no_data_found then
               ln_amplia := 0;
               ld_fecamp := null;
         when others then
               null;
     end;
     -- REprogramacion

      if pn_mod = 200  or pn_top = 550 then 
         begin
              select count(*), max (d.r011fc)
                into ln_numrep, ld_fulrep
               from  fsr011 s,  fsr011 d
              where s.relcod = 52
                and s.r2cod  = 1
                and s.r2mod  = pn_mod
                and s.r2suc  = pn_suc
                and s.r2mda  = pn_mda
                and s.r2pap  = pn_pap
                and s.r2cta  = pn_cta
                and s.r2oper = pn_oper
                and s.r2sbop = pn_sbop
                and s.r2tope = pn_top
                and s.r011co = 'S'
                and d.relcod in (860,870)
                and d.r1cod  = s.r1cod 
                and d.r1mod  = s.r1mod 
                and d.r1suc  = s.r1suc 
                and d.r1mda  = s.r1mda 
                and d.r1pap  = s.r1pap 
                and d.r1cta  = s.r1cta 
                and d.r1oper = s.r1oper
                and d.r1sbop = s.r1sbop
                and d.r1tope = s.r1tope
                and d.r011co = 'S'
                and d.r011fc <= pd_fecpro;
          exception
              when no_data_found then
                 ln_numrep := 0;
                 ld_fulrep := null;
          end;
      else 
          begin
              select count(*), max (r011fc)
                into ln_numrep, ld_fulrep
               from  fsr011 s
              where relcod in (860,870)
                and s.r1cod  = 1
                and s.r1mod  = pn_mod
                and s.r1suc  = pn_suc
                and s.r1mda  = pn_mda
                and s.r1pap  = pn_pap
                and s.r1cta  = pn_cta
                and s.r1oper = pn_oper
                and s.r1sbop = pn_sbop
                and s.r1tope = pn_top
                and s.r011co = 'S'
                and s.r011fc <= pd_fecpro;
          exception
              when no_data_found then
                 ln_numrep := 0;
                 ld_fulrep := null;
          end;
        end if;  
        -- desatres
        begin
        select 1,to_date('20161129','yyyymmdd')
          into ln_numrep, ld_fdesatre
          from  jaql125 s
         where s.bcemp = pn_emp
           and s.bcsuc = pn_suc
           and s.bcmod = pn_mod
           and s.bcmda = pn_mda
           and s.bcpap = pn_pap
           and s.bccta = pn_cta
           and s.bcoper= pn_oper
           and s.bcsbop= pn_sbop
           and s.bctop = pn_top;
     exception
         when no_data_found then
             begin
               select 1 , max(j.jaqz519fep)
                 into ln_numrep, ld_fdesatre
                 from  jaqz519 j
                where j.jaqz519ind in ('S', 'P' , 'C') -- Reprogrmados Convenios
                  and j.jaqz519pro10 = 'S'
                  and j.jaqz519pro11 = 'S'
                  and j.jaqz519pro601 = 'S'
                  and j.jaqz519pro611 = 'S'
                  and nvl(j.jaqz519revr,'X') <> 'S'
                  and j.jaqz519emp = pn_emp
                  and j.jaqz519suc = pn_suc
                  and j.jaqz519mod = pn_mod
                  and j.jaqz519mda = pn_mda
                  and j.jaqz519pap = pn_pap
                  and j.jaqz519cta = pn_cta
                  and j.jaqz519ope = pn_oper
                  and j.jaqz519sbo = pn_sbop
                  and j.jaqz519top = pn_top; 
               if ld_fdesatre is null then
                  begin
                      select  1,to_date('20170929','yyyymmdd')
                        into ln_numrep, ld_fdesatre
                        from jaql125 x
                       where x.bcemp = 2
                         and x.bccta = pn_cta
                         and x.bcoper = pn_oper;
                    exception 
                      when no_data_found then
                           ld_fdesatre := null;
                           ln_numrep := 0;
                      when others then
                           null; 
                    end; 
               end if;    
             exception
               when no_data_found then
                    -- Se agrego lista Mabel consumos manuales
                    begin
                      select  1,to_date('20170929','yyyymmdd')
                        into ln_numrep, ld_fdesatre
                        from jaql125 x
                       where x.bcemp = 2
                         and x.bccta = pn_cta
                         and x.bcoper = pn_oper;
                    exception 
                      when no_data_found then
                           ld_fdesatre := null;
                           ln_numrep := 0;
                      when others then
                           null; 
                    end; 
                   -----------------------------            
                    
               when others then
                 ld_fdesatre := null;
                 ln_numrep := 0;
             end;
         when others then
               null;
     end;
     

     if  ln_numrep > 0 and  ld_fulrep is null then
        -- busca en sorfy
        begin
           select max(s.d_fecrrp), count(*)
             into ld_fulrep, ln_numrep
             from  JAQL122/*MIGRA2.crdaprr */s,  bnj096 b
            where s.c_numcre = b.bnj096sor
              and b.bnj096suc = pn_suc
              and b.bnj096mda = pn_mda
              and b.bnj096pap = pn_pap
              and b.bnj096cta = pn_cta
              and b.bnj096ope = pn_oper
              and s.d_fecrrp <= pd_fecpro;
        exception
           when no_data_found then
             ln_numrep := 0;
             ld_fulrep := null;
        end;
     end if;
     if  ln_amplia in (4,12) then
       ln_totcam := 1;
       lc_indamp := 'S';
     else
       ln_totcam := 0;
       lc_indamp := 'N';
     end if;
     if ld_fecref is not null then 
        ld_fulcam := to_char(ld_fecref,'dd/mm/yyyy');
     elsif ld_fdesatre is not null and ld_fdesatre <> to_date('19010101','yyyymmdd') then 
        ld_fulcam := to_char(ld_fdesatre,'dd/mm/yyyy');
     elsif ld_fdesatre = to_date('19010101','yyyymmdd') then 
        ld_fulcam := '00/00/0000';   
     elsif  ld_fulrep is not null and ld_fulrep > nvl(ld_fecamp,to_date('19010101','yyyymmdd')) then
        ld_fulcam := to_char(ld_fulrep,'dd/mm/yyyy');
     else
        ld_fulcam := nvl(to_char(ld_fecamp,'dd/mm/yyyy'),'00/00/0000');
     end if;
     return ld_fulcam;

end ;
function fn_califica (pn_emp in number, pn_cta in number, pd_feccat in date, pn_codcat in number ) return varchar2 is
lc_categoria varchar2(20);
begin
  if pn_codcat = 9 then
    begin
      select trim(l.catcateg)
        into lc_categoria
        from  fsd212 l
       where l.pgcod     = pn_emp
         and l.catcta    = pn_cta
         and l.catfchdes = pd_feccat
         and l.catcod    = 5;
     exception
       when no_data_found then
          begin
            select trim(l.catcateg)
              into lc_categoria
              from  fsd212 l
             where l.pgcod     = pn_emp
               and l.catcta    = pn_cta
               and l.catfchdes = pd_feccat
               and l.catcod    = pn_codcat;
          exception
              when no_data_found then
                 lc_categoria := null;
              when too_many_rows then
                 lc_categoria := null;
          end;
     end;
   else
      begin
        select trim(l.catcateg)
          into lc_categoria
          from  fsd212 l
         where l.pgcod     = pn_emp
           and l.catcta    = pn_cta
           and l.catfchdes = pd_feccat
           and l.catcod    = pn_codcat;
      exception
          when no_data_found then
             lc_categoria := null;
          when too_many_rows then
             lc_categoria := null;
      end;
   end if ;
   return lc_categoria;
end fn_califica;
function fn_tea (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                 pn_pap in number, pn_cta in number, pn_oper in number,
                 pn_sbop in number,pn_top in number) return number is
ln_tasa number;
begin
   begin
          select a.aotasa
            into ln_tasa
            from  fsd010 a -- Evtasa      
           Where Pgcod = pn_emp
             and Aomod = pn_mod
             and Aosuc = pn_suc
             and Aomda = pn_mda
             and Aopap = pn_pap
             and Aocta = pn_cta
             and Aooper = pn_oper
             and Aosbop = pn_sbop
             and Aotope = pn_top;
   exception
     when others then 
         begin  
          select a.aotasa
            into ln_tasa
            from  fsd010 a -- Evtasa      
           Where Pgcod = pn_emp
             and Aomod = pn_mod
             and Aomda = pn_mda
             and Aopap = pn_pap
             and Aocta = pn_cta
             and Aooper = pn_oper
             and Aosbop = pn_sbop
             and Aotope = pn_top;
        exception
         when others then     
           ln_tasa := null;
        end;    
   end; 
   return ln_tasa;
end fn_tea;

-- Se agrego 
function fn_reprogramado (pn_mod in number, pn_suc in number, pn_mda in number,
                          pn_pap in number, pn_cta in number, pn_oper in number,
                          pn_sbop in number,pn_top in number, pd_Fecpro in date ) return number is
ln_tiprep number;
begin
  begin
  select max(s.relcod)
    into ln_tiprep
   from  fsr011 s
  where relcod in (860,870) 
    and s.r1cod  = 1
    and s.r1mod  = pn_mod
    and s.r1suc  = pn_suc
    and s.r1mda  = pn_mda
    and s.r1pap  = pn_pap
    and s.r1cta  = pn_cta 
    and s.r1oper = pn_oper
    and s.r1sbop = pn_sbop
    and s.r1tope = pn_top
    and s.r011co = 'S'
    and nvl(s.r011fc,'19010101') <= pd_Fecpro;
  exception 
      when no_data_found then 
         ln_tiprep := null;
      when too_many_rows then
         ln_tiprep := null;
  end;   
   return ln_tiprep;
end fn_reprogramado;

function fn_tipli_cierre(pn_pais in number, pn_tipdoc in number, pc_numdoc in varchar2, pd_Fecpro in date ) return varchar2 is
lc_segcre varchar2(50);


begin
  begin
    select q.jaqy067ncal 
             into lc_segcre
             from  jaqy066 z,  jaqy067 q 
            where z.jaqy066paic  = pn_pais 
              and z.jaqy066tdoc  = pn_tipdoc 
              and z.jaqy066tndoc = pc_numdoc
              and z.jaqy066pano  = to_number(to_char(pd_Fecpro,'yyyy'))
              and z.jaqy066pmes  = to_number(to_char(pd_Fecpro,'mm'))
              and z.jaqy066nse   = 'S'
              and z.jaqy066calf  = q.jaqy067ccal;
  exception 
      when no_data_found then 
         lc_segcre := null;
      when too_many_rows then
         lc_segcre := null;
  end;
 
  return lc_segcre;
  
end fn_tipli_cierre;

procedure  sp_TIPCLI(P_D_FECHA   IN DATE,
                        P_N_PAIS    in number,
                        p_n_tipdoc  in number,
                        p_c_numdoc  in char,
                        p_c_usuario in varchar2,
                        P_N_CODCAl  out number,
                        P_C_DESCAL  out varchar2) is

  -- *****************************************************************
  -- Nombre                     : PROCEDIMIENTO PARA IDENTIFICAR LA SEGMENTACION DE UN CLIENTE INDEPENDIENTE Y DEPENDIENTE
  -- Sistema                    : BANTOTAL
  -- Módulo                     : 
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2016.10.28
  -- Autor de Creación          : MPOSTIGOC
  -- Uso                        : GENERACION DE DATA
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 02/01/2017
  -- Autor de la Modificación   : MPOSTIGOC  
  -- Descripción de Modificación: Verifica si ya existe un registro de calificacion con la misma PK, si existe ya no invoca al procedimiento.
  -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  ln_SegLinea number;
  --P_N_CODCAl NUMBER;
  --P_C_DESCAL VARCHAR2(50);
begin

  begin
    select b.segcod
      into ln_SegLinea
      from  sngc60 a,  sngc07 b
     where a.sngc60pais = P_N_PAIS
       and a.sngc60tdoc = p_n_tipdoc
       and a.sngc60ndoc = p_c_numdoc
       and a.sngc60ocup = b.sngc07cod;
  exception
    when too_many_rows then
      begin
        select b.segcod
          into ln_SegLinea
          from  sngc60 a,  sngc07 b
         where a.sngc60pais = P_N_PAIS
           and a.sngc60tdoc = p_n_tipdoc
           and a.sngc60ndoc = p_c_numdoc
           and a.sngc60ocup = b.sngc07cod
           and a.sngc60corr =
               (select max(a.sngc60corr)
                  from  sngc60 a,  sngc07 b
                 where a.sngc60pais = P_N_PAIS
                   and a.sngc60tdoc = p_n_tipdoc
                   and a.sngc60ndoc = p_c_numdoc
                   and a.sngc60ocup = b.sngc07cod);
      
      end;
    when no_data_found then
      null;
  end;

  if p_n_tipdoc = 9 then
    ln_SegLinea := 1;
  end if;

  if ln_SegLinea = 1 then
  
    begin
      begin
        select j.jaqz086calf
          into P_N_CODCAl
          from  jaqz086_APL j
         where j.jaqz086paic = P_N_PAIS
           and j.jaqz086tdoc = p_n_tipdoc
           and j.jaqz086tndoc = p_c_numdoc
           and j.jaqz086usr = p_c_usuario;
      
      exception
        when others then
          null;
      end;
    
      if P_N_CODCAl is null then
          pq_cr_segmentacion_aplic.sp_carga_data(pd_fecpro => P_D_FECHA, --fecha del dia
                                               pn_pai    => P_N_PAIS, --pais
                                               pn_tdo    => p_n_tipdoc, --tipo de documento
                                               pc_doc    => p_c_numdoc, --nro de documento
                                               pc_usr    => p_c_usuario); --usuario que esta ejecutando el paquete
      null;
      end if;
    
      begin
      
        begin
          select jaqz086CALF
            into P_N_CODCAl
            from  jaqz086_APL
           where jaqz086paic = P_N_PAIS
             and jaqz086tdoc = P_N_TIPDOC
             and jaqz086tndoc = rpad(P_C_NUMDOC, 12, ' ')
             and JAQZ086USR = P_C_USUARIO;
        exception
          when no_data_found then
            P_N_CODCAl := 0;
        end;
      
        begin
          select c1.jaqy067ncal
            into P_C_DESCAL
            from  jaqy067 c1
           where c1.jaqy067ccal = P_N_CODCAl;
          /* select tp1desc
             into P_C_DESCAL
             from fst198
            where tp1cod1 = 11124
              and tp1cod = 1
              and tp1corr1 = 1
              and tp1corr2 = 2
              and TP1NRO1	= P_N_CODCAl;*/
        exception
          when no_data_found then
            If P_N_CODCAl = 0 then
              P_C_DESCAL := 'SIN CALIFICACION';
            Else
              P_C_DESCAL := 'NO DEFINIDA';
            End If;
        end;
      end;
    
    end;
  
  else
    if ln_SegLinea = 2 then
    
      /*begin
        select trim(v.pae71val)
          into P_C_DESCAL
          from  fpae70 n,  fpae71 v
         where n.pae70nro = v.pae70nro
           and v.pae71ite = 265
           and n.pae51eva = v.pae51eva
           and v.pae51eva = 1
           and n.pae70pdoc = P_N_PAIS
           and n.pae70tdoc = p_n_tipdoc
           and n.pae70ndoc = p_c_numdoc
           and n.pae70nro = (select max(pae70nro)
                               from  fpae70 f
                              where f.pae70pdoc = n.pae70pdoc
                                and f.pae70tdoc = n.pae70tdoc
                                and f.pae70ndoc = n.pae70ndoc);
      exception
        when others then
          null;
      end;
    
      begin
      
        select tp1nro1, tp1desc
          into P_N_CODCAl, P_C_DESCAL
          from  fst198
         where Tp1cod = 1
           and Tp1cod1 = 10823
           and Tp1corr1 = 2
           and Tp1corr2 = 7
           and tp1nro1 >= 22
           and trim(tp1desc) = TRIM(P_C_DESCAL);
      exception
        when others then
          null;
      end;*/
    
      begin
        select c1.jaqy067ncal
          into P_C_DESCAL
          from  jaqy067 c1
         where c1.jaqy067ccal = P_N_CODCAl;
          /*select tp1desc
             into P_C_DESCAL
             from fst198
            where tp1cod1 = 11124
              and tp1cod = 1
              and tp1corr1 = 1
              and tp1corr2 = 2
              and TP1NRO1	= P_N_CODCAl;*/
      exception
        when no_data_found then
          If P_N_CODCAl = 0 then
            P_C_DESCAL := NULL;--'SIN CALIFICACION';
          Else
            P_C_DESCAL := NULL;--'NO DEFINIDA';
          End If;
      end;
    
    End If;
  
  end if;
  P_N_CODCAl := ln_SegLinea;
  --RETURN P_C_DESCAL;
end ;
end pq_datos_sbs;
/

