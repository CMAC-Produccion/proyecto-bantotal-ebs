create or replace package PQ_CARGA_DATA_RIE_CAMPAÑA is

    procedure sp_job_carga_data;
    PROCEDURE sp_carga_data_job (x in number ); 
    procedure sp_job_carga_desembolso (pc_fecpro in varchar2);
    PROCEDURE sp_carga_desembolso (P_FECHA in varchar2) ; 
    function fn_tipo_cambio_fijo(P_FECHA in date) return number;
    function fn_ciiu2 (pn_cta in number ) return number;
    function fn_tipo_vivienda(p_pais number,p_tdoc number,p_ndoc char) return varchar; 
    function fn_csbs (pn_pepais in number,pn_petdoc in number, pc_pendoc in varchar2, pd_fecpro in date) return varchar2; 
    function fn_cuenta_cred (NROCTA IN VARCHAR2, FECHA IN DATE)RETURN NUMBER; 
    function fn_saldo_cred (NROCTA IN VARCHAR2,TC IN FLOAT, FECHA IN DATE)RETURN NUMBER;
    function fn_ocupacion_cli(p_pepais in number,p_tipdoc in number,p_nrodoc in varchar2)RETURN VARCHAR2;
    function fn_tasa_cred (p_pgcod in number,
                                            p_scsus in number,
                                            p_scmod in number,
                                            p_scmda in number,
                                            p_scpap in number,
                                            p_sccta in number,
                                            p_scope in number,
                                            p_scsbo in number,
                                            p_sctop in number
                                           ) return number;
    function fn_plazo_cred (p_pgcod in number,
                                            p_scsus in number,
                                            p_scmod in number,
                                            p_scmda in number,
                                            p_scpap in number,
                                            p_sccta in number,
                                            p_scope in number,
                                            p_scsbo in number,
                                            p_sctop in number
                                           ) return number;  
    function fn_instancia_credito(
                                               v_Scmod  in number,
                                               v_Scsuc  in number,
                                               v_Scmda  in number,
                                               v_Scpap  in number,
                                               v_Sccta  in number,
                                               v_Scoper in number,
                                               v_Scsbop in number,
                                               v_Sctope in number
                                             ) return number;                                                                            
    function fn_Saldo_garantia(p_Pgcod  in number,
                              p_Scmod  in number,
                              p_Scsuc  in number,
                              p_Scmda  in number,
                              p_Scpap  in number,
                              p_Sccta  in number,
                              p_Scoper in number,
                              p_Scsbop in number,
                              p_Sctope in number,
                              pd_fecha in date
                                           ) return number;
    
    function fn_garantia_cred_ins(p_Pgcod  in number,
                                  p_Scmod  in number,
                                  p_Scsuc  in number,
                                  p_Scmda  in number,
                                  p_Scpap  in number,
                                  p_Sccta  in number,
                                  p_Scoper in number,
                                  p_Scsbop in number,
                                  p_Sctope in number
                                 ) return varchar2;                                                                          
   
   PROCEDURE sp_evaluacion( ld_fecha in date, inst in number, ln_eval out number, ln_sal_bru_tit out number,
                                    ln_sal_bru_cony out number,ln_otros_ing out number,ln_total_ing out number,
                                    ln_total_activo out number,ln_total_patri out number,ln_total_ven out number,
                                    ln_tot_otro_ing out number,ln_util_net out number, ln_tot_gas_fam out number,
                                    ln_res_neto out number,ln_exc_men out number,ln_feceval out date);
                                    
 procedure sp_rcc( p_codsbs in varchar2,
                  p_fecdes in date,                  
                  ln_ent out number,                   
                  ln_salcapprov_12 out number, 
                  ln_salcapprov_9 out number, 
                  ln_salcapprov_6 out number, 
                  ln_salcapprov_3 out number, 
                  ln_salcapprov out number,                 
                  ln_califrcc   out varchar,
                  ln_califrcc3  out varchar, 
                  ln_califrcc6  out varchar,   
                  ln_califrcc9  out varchar,   
                  ln_califrcc12  out varchar  
                 );
                 
procedure atrasodias (p_pgcod in number,
                      p_scsus in number,
                      p_scmod in number,
                      p_scmda in number,
                      p_scpap in number,
                      p_sccta in number,
                      p_scope in number,
                      p_scsbo in number,
                      p_sctop in number,
                      p_fecha in date,                    
                      ln_saldo out number             
                      );             
----------------------------------------------------------------------------------
procedure actualiza_desembolso (inst in number,
                                cta  in number,
                                oper  in number,
                                pais  in number,
                                numdoc in number,
                                tipdoc in varchar,
                                ln_eval in number,
                                codsbs  in varchar2,
                                pgcod in number,
                                scsus in number,
                                scmod in number,
                                scmda in number,
                                scpap in number,
                                sccta in number,
                                scope in number,
                                scsbo in number,
                                sctop in number,
                                /*ln_saldo_1 in number, */
                                ln_saldo in number,  
                                ln_sal_bru_tit in number,
                                ln_sal_bru_cony in number,
                                ln_otros_ing in number,
                                ln_total_ing in number,
                                ln_total_activo in number,
                                ln_total_patri in number,
                                ln_total_ven in number,
                                ln_tot_otro_ing in number,
                                ln_util_net in number,
                                ln_tot_gas_fam  in number,
                                ln_res_neto in number,
                                ln_exc_men in number,
                                ln_feceval in date,      
                                ln_tip_viv  in varchar,
                                ln_ent in number,                               
                                ln_salcapprov_12 in number, 
                                ln_salcapprov_9 in number, 
                                ln_salcapprov_6 in number, 
                                ln_salcapprov_3 in number, 
                                ln_salcapprov in number,                                 
                                ln_mto_gar in number,
                                ln_tip_gar in varchar2,
                                ln_califrcc in varchar,
                                ln_califrcc3 in varchar,
                                ln_califrcc6 in varchar,
                                ln_califrcc9 in varchar,
                                ln_califrcc12 in varchar
                                );
-----------------------------------------------------------------------------
procedure sp_carga_data ;
-----------------------------------------------------------                                                                    
   end PQ_CARGA_DATA_RIE_CAMPAÑA;
/

create or replace package body pq_carga_data_rie_campaña is

   procedure sp_job_carga_desembolso (pc_fecpro in varchar2) is
  
  lc_hostname varchar2(64);
  lc_coderr varchar2(2000);
  lc_variable   varchar2(4000);
  ln_job        number:= 0;
  ln_ini number:=0;
  ln_fin number:=0;
  --ln_max number;
  ln_rango number;
  x number;
  --ln_nrojob   number := 0;  
  cursor fecha is
    select distinct to_char(xx.ffecha,'yyyymmdd') fecha from fst028 xx
  where  xx.ffecha   between to_date((substr(pc_fecpro,1,6)||'01'),'yyyymmdd') and 
  last_day( to_date((substr(pc_fecpro,1,6)||'01'),'yyyymmdd')) ;
  
  begin 
   for i in fecha loop
      ln_ini := x+1;
      x:= x+ ln_rango;
      ln_fin := x;
      lc_variable := ' begin '||'  pq_carga_data_rie_campaña.sp_carga_desembolso('|| ''''||i.fecha||''''|| ');'|| ' End; ';
      ln_job := ln_job +1; 
      
       dbms_scheduler.create_job(
         job_name=> 'DESEMB'||LPAD(TO_CHAR(ln_job),5,'0'),
         job_type=> 'PLSQL_BLOCK',
         job_action=> lc_variable,
         start_date => sysdate+0.5/(24*60),
         enabled => true, 
         auto_drop=> TRUE,
         comments => 'ACTIVAS'
         );
       commit;  
       
         
         
         begin
              select host_name
              into lc_hostname
              from v$instance;
          end;
          
--        if UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052') then
--        if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101') then
          IF SYS.FN_BD_ISRAC='TRUE' THEN
          begin        
            dbms_scheduler.set_attribute(
              'DESEMB'||LPAD(TO_CHAR(ln_job),5,'0'),
              'instance_id',
              2);
          end; 
          else
                begin
                  dbms_scheduler.set_attribute(
                    'DESEMB'||LPAD(TO_CHAR(ln_job),5,'0'),
                    'instance_id',
                    1);
                end; 
          end if;



      /* begin
        dbms_scheduler.set_attribute('DESEMB'||LPAD(TO_CHAR(ln_job),5,'0'),'instance_id',2);
       end; */

      /*
       -- Verifica que no exceda el limiete de jobs
       Loop 
             select count(*) 
               into ln_nrojob
               from DBA_SCHEDULER_JOBS 
              where owner = 'DWSTAGE'; -- CAMBIAR PROPIETARIO
       Exit when ln_nrojob <= 900;
       End Loop;*/
  end loop;
  exception
  when others then
  lc_coderr := sqlerrm;
  --p_c_error:=  lc_variable;
  end;
  
   PROCEDURE sp_carga_desembolso (P_FECHA in varchar2 ) 
 IS
       TYPE desembolso_dia IS REF CURSOR;
       c_desembolso_dia desembolso_dia;
       
       TYPE tp_segclie     IS TABLE OF desembolso_pe.segclie%type INDEX BY PLS_INTEGER;
       TYPE tp_fecnac     IS TABLE OF desembolso_pe.fecnac%type INDEX BY PLS_INTEGER;
       TYPE tp_feccon     IS TABLE OF desembolso_pe.feccon%type INDEX BY PLS_INTEGER;
       TYPE tp_tasa      IS TABLE OF desembolso_pe.tasa%type INDEX BY PLS_INTEGER;
       TYPE tp_plazo      IS TABLE OF desembolso_pe.plazo%type INDEX BY PLS_INTEGER;
       TYPE tp_codreg      IS TABLE OF desembolso_pe.cod_reg%type INDEX BY PLS_INTEGER;
       TYPE tp_nomreg     IS TABLE OF desembolso_pe.nom_reg%type INDEX BY PLS_INTEGER;        
       TYPE tp_tipo      IS TABLE OF desembolso_pe.tipo_cli%type INDEX BY PLS_INTEGER;
       TYPE tp_codsbs    IS TABLE OF desembolso_pe.codigo_sbs%type INDEX BY PLS_INTEGER;
       TYPE tp_ctacli    IS TABLE OF desembolso_pe.cuenta_cliente%type INDEX BY PLS_INTEGER;
       TYPE tp_codciiu   IS TABLE OF desembolso_pe.codigo_ciiu%type INDEX BY PLS_INTEGER;
       TYPE tp_numoper   IS TABLE OF desembolso_pe.operacion%type INDEX BY PLS_INTEGER;
       TYPE tp_fecdes    IS TABLE OF desembolso_pe.fecha_desembolso%type INDEX BY PLS_INTEGER;       
       TYPE tp_impdesmo  IS TABLE OF desembolso_pe.importe_desembolso_mo%type INDEX BY PLS_INTEGER;
       TYPE tp_impdesmn  IS TABLE OF desembolso_pe.importe_desembolso_mn%type INDEX BY PLS_INTEGER;       
       TYPE tp_cuota     IS TABLE OF desembolso_pe.cuota%type INDEX BY PLS_INTEGER;  
       TYPE tp_moneda    IS TABLE OF desembolso_pe.codigo_moneda%type INDEX BY PLS_INTEGER;    
       TYPE tp_codpro    IS TABLE OF desembolso_pe.codigo_producto%type INDEX BY PLS_INTEGER;
       TYPE tp_despro    IS TABLE OF desembolso_pe.producto%type INDEX BY PLS_INTEGER;
       TYPE tp_descam    IS TABLE OF desembolso_pe.des_producto%type INDEX BY PLS_INTEGER;
       TYPE tp_rubro     IS TABLE OF desembolso_pe.codigo_rubro%type INDEX BY PLS_INTEGER;
       TYPE tp_desrubro  IS TABLE OF desembolso_pe.desrubro%type INDEX BY PLS_INTEGER;
       TYPE tp_t_codcre  IS TABLE OF desembolso_pe.codigo_tipo_credito%type INDEX BY PLS_INTEGER;
       TYPE tp_tipo_sbs  IS TABLE OF desembolso_pe.tipo_sbs%type INDEX BY PLS_INTEGER;
       TYPE tp_modtra    IS TABLE OF desembolso_pe.modulo_transaccion%type INDEX BY PLS_INTEGER;
       TYPE tp_codtra    IS TABLE OF desembolso_pe.codigo_transaccion%type INDEX BY PLS_INTEGER;
       TYPE tp_nroinst   IS TABLE OF desembolso_pe.nro_instancia%type INDEX BY PLS_INTEGER;
       TYPE tp_tipdoc    IS TABLE OF desembolso_pe.tipo_doc%type INDEX BY PLS_INTEGER;
       TYPE tp_nrodoc    IS TABLE OF desembolso_pe.num_doc%type INDEX BY PLS_INTEGER;       
       TYPE tp_pais      IS TABLE OF desembolso_pe.pais%type INDEX BY PLS_INTEGER;          
       TYPE tp_pgcod     IS TABLE OF desembolso_pe.pgcod%type INDEX BY PLS_INTEGER; 
       TYPE tp_htoper    IS TABLE OF desembolso_pe.htoper%type INDEX BY PLS_INTEGER; 
       TYPE tp_hpap      IS TABLE OF desembolso_pe.hpap%type INDEX BY PLS_INTEGER; 
       TYPE tp_hsucur    IS TABLE OF desembolso_pe.hsucur%type INDEX BY PLS_INTEGER; 
       TYPE tp_hsubop    IS TABLE OF desembolso_pe.hsubop%type INDEX BY PLS_INTEGER; 
       TYPE tp_totcred    IS TABLE OF desembolso_pe.totcred%type INDEX BY PLS_INTEGER; 
       TYPE tp_salcredant    IS TABLE OF desembolso_pe.salcredant%type INDEX BY PLS_INTEGER; 
       TYPE tp_ocup    IS TABLE OF desembolso_pe.ocup%type INDEX BY PLS_INTEGER; 
        
       segclie   tp_segclie  ;
       fecnac    tp_fecnac   ;
       feccon    tp_feccon   ;
       tasa      tp_tasa     ;
       plazo     tp_plazo    ;              
       codreg    tp_codreg   ;
       nomreg    tp_nomreg   ;
       tipo      tp_tipo     ;
       codsbs    tp_codsbs   ;
       ctacli    tp_ctacli   ;
       codciiu   tp_codciiu  ;
       numoper   tp_numoper  ;
       fecdes    tp_fecdes   ;
       impdesmo  tp_impdesmo ; 
       impdesmn  tp_impdesmn ;
       cuota     tp_cuota    ;         
       moneda    tp_moneda   ;    
       codpro    tp_codpro   ;
       despro    tp_despro   ;
       descam    tp_descam   ;
       rubro     tp_rubro    ;
       desrubro  tp_desrubro ;
       codcre    tp_t_codcre ; 
       tipo_sbs  tp_tipo_sbs ;
       modtra    tp_modtra   ;
       codtra    tp_codtra   ;             
       nroinst   tp_nroinst  ;
       tipdoc    tp_tipdoc   ;
       nrodoc    tp_nrodoc   ;
       pais      tp_pais     ;
       pgcod     tp_pgcod ;
       htoper    tp_htoper ;
       hpap      tp_hpap ;
       hsucur    tp_hsucur;
       hsubop    tp_hsubop;
       totcred   tp_totcred;
       salcredant tp_salcredant;
       ocup       tp_ocup;
       
       ld_fecha date:= to_date(p_fecha,'yyyymmdd');
       ln_tipcam number(7,3) := fn_tipo_cambio_fijo(ld_fecha);

  BEGIN
   OPEN c_desembolso_dia FOR 
   select /*+all_rows*/
     (SELECT MAX (j.jaqy066calf) FROM jaqy066 j
         WHERE j.jaqy066pano=to_number(TO_char(h15.hfcon,'yyyy')) 
         and j.jaqy066pmes=to_number(TO_char(h15.hfcon,'mm')) 
         --and j.jaqy066fecp=last_day(h15.hfcon)
         and j.jaqy066paic=fr8.pepais
         and j.jaqy066tdoc=fr8.petdoc
         and j.jaqy066tndoc=fr8.pendoc),  
     (select d_002.pffnac
         from fsd002 d_002 
         where d_002.pfpais = fr8.pepais
           and d_002.pftdoc = fr8.petdoc
           and d_002.pfndoc = fr8.pendoc),
       (SELECT J.PJFCON FROM FSD003 J
          WHERE j.pjpais=fr8.pepais
           and j.pjtdoc=fr8.petdoc
           and j.pjndoc=fr8.pendoc) ,
    pq_carga_data_rie_campaña.fn_tasa_cred(h16.pgcod,h16.hsucur,h16.hmodul,h16.hmda,h16.hpap,h16.hcta,h16.hoper,h16.hsubop,h16.htoper),
    pq_carga_data_rie_campaña.fn_plazo_cred(h16.pgcod,h16.hsucur,h16.hmodul,h16.hmda,h16.hpap,h16.hcta,h16.hoper,h16.hsubop,h16.htoper), 
    r2.regcod,
    upper(r2.RegNOM) region,
    (SELECT decode(sng001seg,1,'independiente',2,'dependiente') FROM sng001 s
    WHERE s.sng001cta= h16.hcta and fr8.pendoc=s.sng001ndoc
    and s.sng001inst=pq_carga_data_rie_campaña.fn_instancia_credito(h16.hmodul,h16.hsucur,h16.hmda,h16.hpap,h16.hcta,h16.hoper,h16.hsubop,h16.htoper)),
   pq_carga_data_rie_campaña.fn_csbs(fr8.pepais , fr8.petdoc ,fr8.pendoc, h15.hfcon),
   h16.hcta,
   pq_carga_data_rie_campaña.fn_ciiu2(h16.hcta),   
   h16.hoper,
   h15.hfcon,
   h16.hcimp1 ,
   decode(h16.hmda, 0, h16.hcimp1, h16.hcimp1 * ln_tipcam) , 
   (select  STATS_MODE(d601.ppcap + d601.ppint)                     
           from fsd601 d601
           where d601.pgcod    = h16.pgcod
             and d601.ppmod    = h16.hmodul
             and d601.ppsuc    = h16.hsucur 
             and d601.ppmda    = h16.hmda
             and d601.pppap    = h16.hpap
             and d601.ppcta    = h16.hcta
             and d601.ppoper   = h16.hoper
             and d601.ppsbop   = h16.hsubop
             and d601.pptope   = h16.htoper),  
   h16.hmda,   
   h16.hmodul,  
   (select t_003.mdnom 
                         from fst003 t_003
                         where t_003.modulo=h16.hmodul), 
   (select t_004.tonom 
                        from fst004 t_004 
                        where t_004.modulo=h16.hmodul
                        and t_004.totope=h16.htoper), 
   h16.hrubro,
   (select d014.pcnomr
                  from fsd014 d014
                  where d014.rubro=h16.hrubro),
   TO_NUMBER(SUBSTR(H16.HRUBRO, 5, 2)) ,
   Case When Substr(H16.HRUBRO, 5, 2) = '02' then 'MICRO EMPRESA'
        When Substr(H16.HRUBRO, 5, 2) = '03' then 'CONSUMO'
        When Substr(H16.HRUBRO, 5, 2) = '04' then 'HIPOTECARIO'
        When Substr(H16.HRUBRO, 5, 2) = '09' then 'CORPORATIVO E.I.F.'
        When Substr(H16.HRUBRO, 5, 2) = '11' then 'GRANDES EMPRESAS'
        When Substr(H16.HRUBRO, 5, 2) = '12' then 'MEDIANA EMPRESA'
        When Substr(H16.HRUBRO, 5, 2) = '13' then 'PEQUEÑA EMPRESA'
    end case,      
   h16.hcmod,
   h16.htran,
   pq_carga_data_rie_campaña.fn_instancia_credito(h16.hmodul,h16.hsucur,h16.hmda,h16.hpap,h16.hcta,h16.hoper,h16.hsubop,h16.htoper),
   fr8.petdoc,
   fr8.pendoc,
   fr8.pepais, 
   h16.pgcod, 
   h16.htoper,
   h16.hpap,
   h16.hsucur,
   h16.hsubop,
   pq_carga_data_rie_campaña.fn_cuenta_cred(h16.hcta,h15.hfcon),
   nvl(abs(pq_carga_data_rie_campaña.fn_saldo_cred(h16.hcta,ln_tipcam,h15.hfcon)),0),
   pq_carga_data_rie_campaña.fn_ocupacion_cli(fr8.pepais,fr8.petdoc,fr8.pendoc)
    from fsh015   h15,
         fsh016   h16,
         fsr008   fr8,
         fst811   r,
         fst810   r2 
   where h16.pgcod = h15.pgcod
     and h16.hcmod = h15.hcmod
     and h16.hsucor = h15.hsucor
     and h16.htran = h15.htran
     and h16.hnrel = h15.hnrel
     and h16.hfcon = h15.hfcon
     and h16.hcodmo = 1 -- egreso
        --and h16.hsucur = 11
     and h16.hrubro in (select rubro
                          from fsd014
                         where pcimpu = 'S'
                           and pcnivc in
                               (select modulo
                                  from fst111
                                 where dscod = 50
                                   and modulo not in (29, 120, 141, 144, 33))
                           and pmtit <> 9
                           /*and pmgru not in (11,5,6,7,8,9,12)*/)--excluir corporativo grande y mediana empresa
     and h16.hfvco = h15.hfcon
     and h16.pgcod = fr8.pgcod
     and h16.hcta = fr8.ctnro
     and fr8.cttfir = 'T'
     and h15.pgcod = 1
     and h15.hccorr <> 99
     and h15.hfcon = ld_fecha
     and ((h15.hcmod = 116 and h15.htran in (50,60)) OR
          (h15.hcmod =  30 and h15.htran in (350,360,951,351,355,356))
         )
     and h16.hcodmo = 1 
     /*and Substr(H16.HRUBRO, 5, 2) = '13'*/
     and r.pgcod = 1
     and r.oficod = h16.hsucur
     and r.RegCod < 100
     and r2.regcod = r.regcod
     and r2.regcod < 100
     and h16.hmodul in (115,106,101,102);--campaña-personal-capital trabajo-activo fijo
         
     LOOP
           FETCH c_desembolso_dia  BULK COLLECT INTO segclie,fecnac,feccon,tasa,plazo,codreg,nomreg,tipo,codsbs ,ctacli  ,codciiu ,numoper ,fecdes  ,impdesmo,
                                                     impdesmn,cuota,moneda, codpro,despro,descam,rubro,desrubro,codcre,tipo_sbs,modtra ,codtra,nroinst , tipdoc , nrodoc,pais,pgcod,
                                                     htoper,hpap,hsucur,hsubop,totcred,salcredant,ocup 
               
                                           LIMIT 1000; 
           
           
           IF codcre.count > 0 THEN                         
              FORALL x IN codcre.FIRST .. codcre.LAST
                
                INSERT INTO desembolso_pe (segclie,fecnac,feccon,tasa,plazo,cod_reg,nom_reg,tipo_cli,codigo_sbs,cuenta_cliente,codigo_ciiu,operacion,fecha_desembolso,
                                        importe_desembolso_mo,importe_desembolso_mn,cuota,codigo_moneda,codigo_producto,producto,des_producto,codigo_rubro,desrubro,
                                        codigo_tipo_credito,tipo_sbs,modulo_transaccion,codigo_transaccion,nro_instancia,tipo_doc, num_doc,pais,pgcod,htoper,hpap,hsucur,hsubop,totcred,salcredant,ocup )
                                     VALUES(segclie(x),fecnac(x),feccon(x),tasa(x),plazo(x),codreg(x),nomreg(x),tipo(x),codsbs(x),ctacli(x),codciiu(x),numoper(x),fecdes(x),impdesmo(x),impdesmn(x),
                                            cuota(x),moneda(x),codpro(x),despro(x),descam(x),rubro(x),desrubro(x),codcre(x),tipo_sbs(x),modtra(x),codtra(x),nroinst(x),
                                            tipdoc(x),nrodoc(x),pais(x),pgcod(x),htoper(x),hpap(x),hsucur(x),hsubop(x),totcred(x),salcredant(x),ocup(x)); 
                                                                           
                commit; 
           END IF;                        
        EXIT WHEN c_desembolso_dia%notfound;
        END LOOP;
  END sp_carga_desembolso;  
 
 function fn_tipo_cambio_fijo(P_FECHA in date) return number
  is
    ln_tipcam fsh005.cotcbi%type;
  Begin
       Select cotcbi

         Into ln_tipcam
         From (
                 select u.cotcbi
                   From fsh005 u
                  Where moneda=101
                    And cofdes <= P_FECHA
               Order by cofdes desc
              )
        Where rownum = 1;

       Return ln_tipcam;
  Exception when others then
            return 0;
  end fn_tipo_cambio_fijo;
  
function fn_ciiu2 (pn_cta in number ) return number is
ln_activi number;
begin
  begin
  select /*+parallel(aa,2)*/xx.actcod1--15.03.2013
    into ln_activi
    from sngc60 aa, fst750 xx, fsr008 pp
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
  
function fn_ocupacion_cli(p_pepais in number,p_tipdoc in number,p_nrodoc in varchar2)
return varchar2 is
ocupacion  varchar2(5000);
    
begin
     ocupacion := '';
     for l_ocu in (select trim(sngc07dsc) ocu from sngc60 c, sngc07 d
where c.sngc60ndoc=p_nrodoc
  and c.sngc60tdoc=p_tipdoc  
  and c.sngc60pais=p_pepais  
  and c.sngc60ocup=d.sngc07cod)  loop
         ocupacion := l_ocu.ocu ||' | '|| ocupacion;
     end loop;
     return ocupacion;
end;  
  
function fn_saldo_cred (nrocta in varchar2,tc in float, fecha in date)
return number is
ln_variable number;

begin
 select /*+parallel (s,2,1) (a,2,1)*/
        sum(decode(a.scmda,0,a.scsdo,a.scsdo*tc)) 
   into ln_variable
                             from 
                                   fsd010 s,
                                   fsd011 a
                      where  s.aocta <> 999999999
                           and s.aomod not in (33,141) --no castigados no cartas fianzas
                           and s.aostat <> 99 --cancelados                          
                           and s.aomod in (select modulo from fst111 where dscod=50) --creditos
                           and s.pgcod=a.pgcod
                           and s.aomod=a.scmod
                           and s.aosuc=a.scsuc
                           and s.aomda=a.scmda
                           and s.aopap=a.scpap
                           and s.aocta=a.sccta
                           and s.aooper=a.scoper
                           and s.aosbop=a.scsbop
                           and s.aotope=a.sctope
                           and s.aocta=nrocta
                           and a.scfval<fecha; 
  return ln_variable;
end;

function fn_cuenta_cred (nrocta in varchar2, fecha in date)
return number is
ln_pos_nuevo number;
ln_variable number;

begin
  
  select count(s.aocta||s.aooper)
into ln_variable
        from fsd010 s             
        where  s.aocta <> 999999999
             and s.aomod not in (33,141) --no castigados no cartas fianzas
             and s.aostat <> 99 --cancelados            
             and s.aomod in (select modulo from fst111 where dscod=50) --creditos
             and s.aofval < fecha  
             and s.aocta=nrocta;            
   if ln_variable  >= 1  then
   ln_pos_nuevo := ln_variable;
   else
     ln_pos_nuevo := 0;
     
  end if;  
  return ln_pos_nuevo;
end;  
  
function fn_csbs (pn_pepais in number,pn_petdoc in number, pc_pendoc in varchar2, pd_fecpro in date) return varchar2
is
lc_codsbs varchar2(10);

begin
 
  begin
    select lpad(to_char(c.bc739sbs),10,0)
      into lc_codsbs
      from fbc739 c
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
                and d_fecpre = last_day(pd_fecpro)
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
                and d_fecpre = last_day(pd_fecpro)
                and rownum = 1;
           exception
              when others then
                   lc_codsbs := null;
           end;
        end if;
  end;
   return lc_codsbs;
end fn_csbs;  
  
function fn_instancia_credito(
                                               v_Scmod  in number,
                                               v_Scsuc  in number,
                                               v_Scmda  in number,
                                               v_Scpap  in number,
                                               v_Sccta  in number,
                                               v_Scoper in number,
                                               v_Scsbop in number,
                                               v_Sctope in number
                                             ) return number is

    ln_instancia sng001.sng001inst%type;

  begin

       If v_Scmod = 116 THEN
          Begin
                select max(xw2.xwfprcins)
                  into ln_instancia
                  From Fsr011 rel  join  xwf700 xw2 on xw2.xwfempresa   = rel.r2cod  
                                                  and xw2.xwfmodulo    = rel.r2mod  
                                                  and xw2.xwfsucursal  = rel.r2suc  
                                                  and xw2.xwfmoneda    = rel.r2mda  
                                                  and xw2.xwfpapel     = rel.r2pap  
                                                  and xw2.xwfcuenta    = rel.r2cta  
                                                  and xw2.xwfoperacion = rel.r2oper  
                                                  and xw2.xwfsubope    = rel.r2sbop  
                                                  and xw2.xwftipope    = rel.r2tope 
                                                  and rel.relcod       = 46     
                                                  and xw2.xwfcar3      = '1'
                 where rel.r1cod = 1
                   and rel.r1mod = v_Scmod                  
                   and rel.r1mda = v_Scmda
                   and rel.r1pap = v_Scpap
                   and rel.r1cta = v_Sccta
                   and rel.r1oper= v_Scoper
                   and rel.r1sbop= v_Scsbop
                   and rel.r1tope= v_Sctope;
          
              If ln_instancia is null Then
                    Begin
                        select max(xw2.xwfprcins)
                          into ln_instancia
                          From Fsr011 rel  join  xwf700 xw2 on xw2.xwfempresa   = rel.r2cod  
                                                          and xw2.xwfmodulo    = rel.r2mod  
                                                          and xw2.xwfsucursal  = rel.r2suc  
                                                          and xw2.xwfmoneda    = rel.r2mda  
                                                          and xw2.xwfpapel     = rel.r2pap  
                                                          and xw2.xwfcuenta    = rel.r2cta  
                                                          and xw2.xwfoperacion = rel.r2oper  
                                                          and xw2.xwfsubope    = rel.r2sbop  
                                                          and xw2.xwftipope    = rel.r2tope 
                                                          and rel.relcod       = 46     
                         where rel.r1cod = 1
                           and rel.r1mod = v_Scmod
                           and rel.r1suc = v_Scsuc
                           and rel.r1mda = v_Scmda
                           and rel.r1pap = v_Scpap
                           and rel.r1cta = v_Sccta
                           and rel.r1oper= v_Scoper
                           and rel.r1tope= v_Sctope;
                    End;   
              End If;  
          End;         
                     
       Else
           Begin
               select xw2.xwfprcins
                 into ln_instancia
                 from  xwf700 xw2
                where xw2.xwfempresa   = 1
                 -- and xw2.xwfsucursal  = v_Scsuc
                  and xw2.xwfmodulo    = v_Scmod
                  and xw2.xwfmoneda    = v_Scmda
                  and xw2.xwfpapel     = v_Scpap
                  and xw2.xwfcuenta    = v_Sccta
                  and xw2.xwfoperacion = v_Scoper
                  and xw2.xwfsubope    = v_Scsbop
                  and xw2.xwftipope    = v_Sctope
                  and xw2.xwfcar3      = '1';
           Exception When Others Then
                      If v_Scmod in (200,33) or  v_Sctope = 550  Then
                         Begin
                                 select max(xw2.xwfprcins)
                                   into ln_instancia
                                   from  xwf700 xw2
                                  where xw2.xwfempresa   = 1
                                    and xw2.xwfsucursal  = v_Scsuc
                                    and xw2.xwfmoneda    = v_Scmda
                                    and xw2.xwfpapel     = v_Scpap
                                    and xw2.xwfcuenta    = v_Sccta
                                    and xw2.xwfoperacion = v_Scoper;
                           end;
                      Else
                      
                           Begin
                                 select xw2.xwfprcins
                                   into ln_instancia
                                   from  xwf700 xw2
                                  where xw2.xwfempresa   = 1
                                    and xw2.xwfsucursal  = v_Scsuc
                                    and xw2.xwfmodulo    = v_Scmod
                                    and xw2.xwfmoneda    = v_Scmda
                                    and xw2.xwfpapel     = v_Scpap
                                    and xw2.xwfcuenta    = v_Sccta
                                    and xw2.xwfoperacion = v_Scoper
                                    and xw2.xwftipope    = v_Sctope
                                    and xw2.xwfcar3      = '1';
                           Exception When Others Then
                                  begin
                                       select max(xw2.xwfprcins)
                                         into ln_instancia
                                         from  xwf700 xw2
                                        where xw2.xwfempresa   = 1
                                          and xw2.xwfsucursal  = v_Scsuc
                                          and xw2.xwfmodulo    = v_Scmod
                                          and xw2.xwfmoneda    = v_Scmda
                                          and xw2.xwfpapel     = v_Scpap
                                          and xw2.xwfcuenta    = v_Sccta
                                          and xw2.xwfoperacion = v_Scoper
                                          and xw2.xwftipope    = v_Sctope
                                          and xw2.xwfcar3      = '1';
                                    end;
                           End;         
                           End IF;                           
           End ;
       End IF;
       if nvl(ln_instancia,0) = 0 then 
          Begin
            select max(xw2.xwfprcins)
              into ln_instancia
              from  xwf700 xw2
             where xw2.xwfempresa   = 1
               and xw2.xwfsucursal  = v_Scsuc
               and xw2.xwfmoneda    = v_Scmda
               and xw2.xwfpapel     = v_Scpap
               and xw2.xwfcuenta    = v_Sccta
               and xw2.xwfoperacion = v_Scoper;
           end;
       end if;
       
       
           
  return ln_instancia;
  
end fn_instancia_credito;  
function fn_plazo_cred (p_pgcod in number,
                                            p_scsus in number,
                                            p_scmod in number,
                                            p_scmda in number,
                                            p_scpap in number,
                                            p_sccta in number,
                                            p_scope in number,
                                            p_scsbo in number,
                                            p_sctop in number
                                           ) return number
is
   ln_plazo fsd010.aopzo%type;
begin
     Select d.aopzo
       into ln_plazo
       from fsd010 d
      where d.pgcod =p_pgcod
        and d.aosuc =p_scsus
        and d.aomda =p_scmda
        and d.aopap =p_scpap
        and d.aocta =p_sccta
        and d.aooper=p_scope
        and d.aosbop=p_scsbo
        and d.aotope =p_sctop
        and d.aomod =p_scmod;


      Return ln_plazo;
exception when others then
          Return ln_plazo;
end;
  
function fn_tasa_cred (p_pgcod in number,
                                            p_scsus in number,
                                            p_scmod in number,
                                            p_scmda in number,
                                            p_scpap in number,
                                            p_sccta in number,
                                            p_scope in number,
                                            p_scsbo in number,
                                            p_sctop in number
                                           ) return number
is
   ln_tasa fsd010.aotasa%type;
begin
     Select d.aotasa
       into ln_tasa
       from fsd010 d
      where d.pgcod =p_pgcod
        and d.aosuc =p_scsus
        and d.aomda =p_scmda
        and d.aopap =p_scpap
        and d.aocta =p_sccta
        and d.aooper=p_scope
        and d.aosbop=p_scsbo
        and d.aotope =p_sctop
        and d.aomod =p_scmod;
      Return ln_tasa;
exception when others then
          Return ln_tasa;
end;

function fn_tipo_vivienda(p_pais number,p_tdoc number,p_ndoc char) return varchar
  is
    ln_tipviv sngc12.sngc12dsc%type;
  Begin
  select 
         s.sngc12dsc
         into ln_tipviv
      from sngc12 s, sngc13 gc13
           where gc13.sngc13tdoc=p_tdoc
                  and gc13.sngc13ndoc=p_ndoc 
                  and gc13.sngc13pais= p_pais
                  and gc13.sngc13corr=1
                  and gc13.docod=1    
                  and s.sngc12vivc=gc13.sngc12vivc;
                        
  Return ln_tipviv;
  Exception when others then
            return null;
  end fn_tipo_vivienda;

function fn_Saldo_garantia(p_Pgcod  in number,
                              p_Scmod  in number,
                              p_Scsuc  in number,
                              p_Scmda  in number,
                              p_Scpap  in number,
                              p_Sccta  in number,
                              p_Scoper in number,
                              p_Scsbop in number,
                              p_Sctope in number,
                              pd_fecha in date
                                           ) return number is

    lv_desgar number:=0;    
    saldo number:=0; 
        
    cursor c_relgar
        is select r11.r2mod, r11.r2cta,r11.r2oper,r11.r2sbop,r11.r2cod,r11.r2suc,r11.r2mda,
                  r11.r2pap,r11.r2tope
             from fsr011 r11 join fst004 t04 on t04.modulo = r11.r2mod
                                            and t04.totope = r11.r2tope
            where r11.r1cod = p_Pgcod
              and r11.r1mod = p_Scmod
              and r11.r1suc = p_Scsuc
              and r11.r1mda = p_Scmda
              and r11.r1pap = p_Scpap 
              and r11.r1cta = p_Sccta
              and r11.r1oper= p_Scoper
              and r11.r1sbop= p_Scsbop
              and r11.r1tope= p_Sctope
              and r11.relcod= 50
              and r11.r011co= 'S'
              and r11.r2mod = 70 
              and r11.r2tope in (10,15,20,25,30,40,42,45,47,50,55,60,65,70/*,80,85*/); 
              
    cursor c_garlin
        is select r11_2.r2mod, r11_2.r2cta,r11_2.r2oper,r11_2.r2sbop,r11_2.r2cod,r11_2.r2suc,r11_2.r2mda,
                  r11_2.r2pap, r11_2.r2tope
             from fsr011 r11 join fsr011 r11_2 on r11_2.r1cod= r11.r2cod
                                              and r11_2.r1mod= r11.r2mod
                                              and r11_2.r1suc= r11.r2suc
                                              and r11_2.r1mda= r11.r2mda
                                              and r11_2.r1pap= r11.r2pap
                                              and r11_2.r1cta= r11.r2cta
                                              and r11_2.r1oper=r11.r2oper
                                              and r11_2.r1sbop=r11.r2sbop
                                              and r11_2.r1tope=r11.r2tope
                                              and r11_2.relcod=50
                                              and r11_2.r011co='S'
                                              and r11_2.r2tope in (10,15,20,25,30,40,42,45,47,50,55,60,65,70/*,80,85*/)
                               join fst004 t04 on t04.modulo = r11_2.r2mod
                                              and t04.totope = r11_2.r2tope
            where r11.r1cod = p_Pgcod
              and r11.r1mod = p_Scmod
              and r11.r1suc = p_Scsuc
              and r11.r1mda = p_Scmda
              and r11.r1pap = p_Scpap 
              and r11.r1cta = p_Sccta
              and r11.r1oper= p_Scoper
              and r11.r1sbop= p_Scsbop
              and r11.r1tope= p_Sctope
              and r11.relcod= 46
              and r11.r011co= 'S';               

  begin
      If p_Scmod = 116 Then
          for x in c_garlin loop
              begin
                select nvl(h.bcsdmn,0) 
                 into saldo
                 from fsh012 h 
                WHERE h.bcemp=x.r2cod
                and h.bcsuc=x.r2suc
                and h.bcmda=x.r2mda
                and h.bcpap=x.r2pap
                and h.bccta=x.r2cta
                and h.bcoper=x.r2oper
                and h.bcsbop=x.r2sbop
                and h.bctop=x.r2tope
                and h.bcmod=x.r2mod
                and h.bcfech=(last_day(pd_fecha));              
              Exception when others then
                saldo:=0;
              end;              
              lv_desgar := lv_desgar+ saldo;
          End loop;      
      Else
          for x in c_relgar loop
              begin
                select nvl(h.bcsdmn,0)  
                 into saldo
                 from fsh012 h 
                WHERE h.bcemp=x.r2cod
                and h.bcsuc=x.r2suc
                and h.bcmda=x.r2mda
                and h.bcpap=x.r2pap
                and h.bccta=x.r2cta
                and h.bcoper=x.r2oper
                and h.bcsbop=x.r2sbop
                and h.bctop=x.r2tope
                and h.bcmod=x.r2mod
                and h.bcfech=(last_day(pd_fecha));
              Exception when others then
                saldo:=0;
              end;
              lv_desgar := lv_desgar+ saldo;
          End loop;
      End If;       
      --lv_desgar := substr(lv_desgar,1,length(lv_desgar)-1);
      Return lv_desgar; 
end fn_Saldo_garantia;                  
  
function fn_garantia_cred_ins(p_Pgcod  in number,
                              p_Scmod  in number,
                              p_Scsuc  in number,
                              p_Scmda  in number,
                              p_Scpap  in number,
                              p_Sccta  in number,
                              p_Scoper in number,
                              p_Scsbop in number,
                              p_Sctope in number
                                           ) return varchar2 is

    lv_desgar varchar2(10000);    
    
    cursor c_relgar
        is select trim(t04.tonom) gara
             from fsr011 r11 join fst004 t04 on t04.modulo = r11.r2mod
                                            and t04.totope = r11.r2tope
            where r11.r1cod = p_Pgcod
              and r11.r1mod = p_Scmod
              and r11.r1suc = p_Scsuc
              and r11.r1mda = p_Scmda
              and r11.r1pap = p_Scpap 
              and r11.r1cta = p_Sccta
              and r11.r1oper= p_Scoper
              and r11.r1sbop= p_Scsbop
              and r11.r1tope= p_Sctope
              and r11.relcod= 50
              and r11.r011co= 'S'
              and r11.r2mod = 70 
              and r11.r2tope in (10,15,20,25,30,40,42,45,47,50,55,60,65,70/*,80,85*/); 
              
    cursor c_garlin
        is select trim(t04.tonom) gara
             from fsr011 r11 join fsr011 r11_2 on r11_2.r1cod= r11.r2cod
                                              and r11_2.r1mod= r11.r2mod
                                              and r11_2.r1suc= r11.r2suc
                                              and r11_2.r1mda= r11.r2mda
                                              and r11_2.r1pap= r11.r2pap
                                              and r11_2.r1cta= r11.r2cta
                                              and r11_2.r1oper=r11.r2oper
                                              and r11_2.r1sbop=r11.r2sbop
                                              and r11_2.r1tope=r11.r2tope
                                              and r11_2.relcod=50
                                              and r11_2.r011co='S'
                                              and r11_2.r2tope in (10,15,20,25,30,40,42,45,47,50,55,60,65,70/*,80,85*/)
                               join fst004 t04 on t04.modulo = r11_2.r2mod
                                              and t04.totope = r11_2.r2tope
            where r11.r1cod = p_Pgcod
              and r11.r1mod = p_Scmod
              and r11.r1suc = p_Scsuc
              and r11.r1mda = p_Scmda
              and r11.r1pap = p_Scpap 
              and r11.r1cta = p_Sccta
              and r11.r1oper= p_Scoper
              and r11.r1sbop= p_Scsbop
              and r11.r1tope= p_Sctope
              and r11.relcod= 46
              and r11.r011co= 'S';               

  begin
      If p_Scmod = 116 Then
          for x in c_garlin loop
              lv_desgar := lv_desgar||x.gara||'|';
          End loop;      
      Else
          for x in c_relgar loop
              lv_desgar := lv_desgar||x.gara||'|';
          End loop;
      End If;       
      lv_desgar := substr(lv_desgar,1,length(lv_desgar)-1);
      Return lv_desgar; 
end fn_garantia_cred_ins;

 -------------------------------------- 
procedure sp_evaluacion(ld_fecha in date, inst in number, ln_eval out number, ln_sal_bru_tit out number,
                                    ln_sal_bru_cony out number,ln_otros_ing out number,ln_total_ing out number,
                                    ln_total_activo out number,ln_total_patri out number,ln_total_ven out number,
                                    ln_tot_otro_ing out number,ln_util_net out number, ln_tot_gas_fam out number,
                                    ln_res_neto out number,ln_exc_men out number,ln_feceval out date) is
                                    
 ln_tipcam number(7,3) := fn_tipo_cambio_fijo(ld_fecha);
 
  begin       
      select --346497                              
                  min (g021.sng021eval),
                  (select sum (decode(c.sng026cod,1,c.sng023mto,0)+ decode(c.sng026cod,501,c.sng023mto*ln_tipcam,0)) 
                  from sng023 c where c.sng021eval=g021.sng021eval and c.sng026cod in (1,501)) sal_bru_tit ,
                  (select sum (decode(c.sng026cod,2,c.sng023mto,0)+ decode(c.sng026cod,502,c.sng023mto*ln_tipcam,0)) 
                  from sng023 c where c.sng021eval=g021.sng021eval and c.sng026cod in (2,502)) sal_bru_cony,
                  (select sum (decode(c.sng026cod,9,c.sng023mto,0)+ decode(c.sng026cod,509,c.sng023mto*ln_tipcam,0)+
                               decode(c.sng026cod,10,c.sng023mto,0)+ decode(c.sng026cod,510,c.sng023mto*ln_tipcam,0)+
                               decode(c.sng026cod,12,c.sng023mto,0)+ decode(c.sng026cod,512,c.sng023mto*ln_tipcam,0)) 
                  from sng023 c where c.sng021eval=g021.sng021eval and c.sng026cod in (9,509,10,510,12,512)) otros_ing,
                  (select sum (decode(c.sng026cod,22,c.sng023mto,0)+ decode(c.sng026cod,522,c.sng023mto*ln_tipcam,0)) 
                  from sng023 c where c.sng021eval=g021.sng021eval and c.sng026cod in (22,522)) total_ing,    
                  (select sum (decode(c.sng026cod,23,c.sng023mto,0)+ decode(c.sng026cod,52,c.sng023mto,0)) 
                  from sng023 c where c.sng021eval=g021.sng021eval and c.sng026cod in (23,52)) total_activo,
                  (select sum (decode(c.sng026cod,25,c.sng023mto,0)+ decode(c.sng026cod,70,c.sng023mto,0)) 
                  from sng023 c where c.sng021eval=g021.sng021eval and c.sng026cod in (25,70)) total_patri,
                  (select sum (decode(c.sng026cod,73,c.sng023mto,0)+ decode(c.sng026cod,573,c.sng023mto*ln_tipcam,0)) 
                  from sng023 c where c.sng021eval=g021.sng021eval and c.sng026cod in (73,573)) total_ven,
                  (select sum (decode(c.sng026cod,53,c.sng023mto,0)+ decode(c.sng026cod,553,c.sng023mto*ln_tipcam,0)) 
                  from sng023 c where c.sng021eval=g021.sng021eval and c.sng026cod in (53,553)) tot_otro_ing,
                  (select sum (decode(c.sng026cod,84,c.sng023mto,0)+ decode(c.sng026cod,584,c.sng023mto*ln_tipcam,0)) 
                  from sng023 c where c.sng021eval=g021.sng021eval and c.sng026cod in (84,584)) util_net,
                  (select sum (decode(c.sng026cod,54,c.sng023mto,0)+ decode(c.sng026cod,554,c.sng023mto*ln_tipcam,0)) 
                  from sng023 c where c.sng021eval=g021.sng021eval and c.sng026cod in (54,554)) tot_gas_fam,
                  (select sum (decode(c.sng026cod,40,c.sng023mto,0)+ decode(c.sng026cod,540,c.sng023mto*ln_tipcam,0)) 
                  from sng023 c where c.sng021eval=g021.sng021eval and c.sng026cod in (40,540)) res_neto,
                  (select sum (decode(c.sng026cod,27,c.sng023mto,0)+ decode(c.sng026cod,527,c.sng023mto*ln_tipcam,0)) 
                  from sng023 c where c.sng021eval=g021.sng021eval and c.sng026cod in (27,527)) exc_men,
                  g021.sng021fec feceval
               into          
                   ln_eval,ln_sal_bru_tit,ln_sal_bru_cony,ln_otros_ing,ln_total_ing,ln_total_activo,
                  ln_total_patri,ln_total_ven,ln_tot_otro_ing,ln_util_net,ln_tot_gas_fam,
                  ln_res_neto,ln_exc_men,ln_feceval                  
               from 
                      sng021 g021 
              where  g021.sng021sol =inst /*153492*/
              group by g021.sng021eval,g021.sng021fec;
          exception when others then
               NULL;
   
  end sp_evaluacion;
  
--------------------
procedure sp_rcc( p_codsbs in varchar2,
                  p_fecdes in date,                  
                  ln_ent out number,                 
                  ln_salcapprov_12 out number,  
                  ln_salcapprov_9 out number,  
                  ln_salcapprov_6 out number,  
                  ln_salcapprov_3 out number,                                    
                  ln_salcapprov out number,                  
                  ln_califrcc   out varchar,
                  ln_califrcc3  out varchar, 
                  ln_califrcc6  out varchar,   
                  ln_califrcc9  out varchar,   
                  ln_califrcc12  out varchar                  
                 ) is
  begin

   begin
      SELECT i.n_canent --nro entidades acreedoras
        into ln_ent
        FROM cldrcci i
       WHERE i.d_fecpre = last_day(p_fecdes)
         and i.c_codsbs = p_codsbs;
      exception when others then NULL;
  end;
           
   begin      
           SELECT sum(n_salcap) --saldo rcc exeptuando provisiones 1409 y rendimiento 1408
             into ln_salcapprov_12
             FROM cldrccs s, cldrcci i
            WHERE i.c_codsbs = s.c_codsbs
              and i.d_fecpre = s.d_fecpre
              and i.d_fecpre = add_months(last_day(p_fecdes),-12)
              and i.c_codsbs = p_codsbs
              AND s.c_tipreg = '2'
              AND (substr(s.c_cuenta, 1, 2) = '14' AND
                  substr(s.c_cuenta, 4, 1) IN
                  ('1', '3', '4', '5', '6' ,'8' /*,'9'*/));
    exception when others then NULL;   
   end;  
   begin      
           SELECT sum(n_salcap) --saldo rcc exeptuando provisiones 1409 y rendimiento 1408
             into ln_salcapprov_9
             FROM cldrccs s, cldrcci i
            WHERE i.c_codsbs = s.c_codsbs
              and i.d_fecpre = s.d_fecpre
              and i.d_fecpre = add_months(last_day(p_fecdes),-9)
              and i.c_codsbs = p_codsbs
              AND s.c_tipreg = '2'
              AND (substr(s.c_cuenta, 1, 2) = '14' AND
                  substr(s.c_cuenta, 4, 1) IN
                  ('1', '3', '4', '5', '6' ,'8' /*,'9'*/));
    exception when others then NULL;   
   end; 
     begin      
           SELECT sum(n_salcap) --saldo rcc exeptuando provisiones 1409 y rendimiento 1408
             into ln_salcapprov_6
             FROM cldrccs s, cldrcci i
            WHERE i.c_codsbs = s.c_codsbs
              and i.d_fecpre = s.d_fecpre
              and i.d_fecpre = add_months(last_day(p_fecdes),-6)
              and i.c_codsbs = p_codsbs
              AND s.c_tipreg = '2'
              AND (substr(s.c_cuenta, 1, 2) = '14' AND
                  substr(s.c_cuenta, 4, 1) IN
                  ('1', '3', '4', '5', '6' ,'8' /*,'9'*/));
    exception when others then NULL;   
   end; 
    begin      
           SELECT sum(n_salcap) --saldo rcc exeptuando provisiones 1409 y rendimiento 1408
             into ln_salcapprov_3
             FROM cldrccs s, cldrcci i
            WHERE i.c_codsbs = s.c_codsbs
              and i.d_fecpre = s.d_fecpre
              and i.d_fecpre = add_months(last_day(p_fecdes),-3)
              and i.c_codsbs = p_codsbs
              AND s.c_tipreg = '2'
              AND (substr(s.c_cuenta, 1, 2) = '14' AND
                  substr(s.c_cuenta, 4, 1) IN
                  ('1', '3', '4', '5', '6' ,'8' /*,'9'*/));
    exception when others then NULL;   
   end;         
     begin      
           SELECT sum(n_salcap) --saldo rcc exeptuando provisiones 1409 y rendimiento 1408
             into ln_salcapprov
             FROM cldrccs s, cldrcci i
            WHERE i.c_codsbs = s.c_codsbs
              and i.d_fecpre = s.d_fecpre
              and i.d_fecpre = last_day(p_fecdes)
              and i.c_codsbs = p_codsbs
              AND s.c_tipreg = '2'
              AND (substr(s.c_cuenta, 1, 2) = '14' AND
                  substr(s.c_cuenta, 4, 1) IN
                  ('1', '3', '4', '5', '6' ,'8' /*,'9'*/));
    exception when others then NULL;   
   end; 
   
    begin   
       
        SELECT distinct i.c_calvig             
        into ln_califrcc
        FROM cldrccs i
       WHERE i.d_fecpre = last_day(p_fecdes) --last_day(p_fecdes)
         and i.c_codsbs =  p_codsbs; 
    exception when others then NULL;   
   end; 
   
    begin      
        SELECT distinct i.c_calvig             
        into ln_califrcc3
        FROM cldrccs i
       WHERE i.d_fecpre = add_months(last_day(p_fecdes),-3)
         and i.c_codsbs =  p_codsbs; 
    exception when others then NULL;   
   end; 
    begin      
        SELECT distinct i.c_calvig             
        into ln_califrcc6
        FROM cldrccs i
       WHERE i.d_fecpre = add_months(last_day(p_fecdes),-6)
         and i.c_codsbs =  p_codsbs; 
    exception when others then NULL;   
   end;
    begin      
        SELECT distinct i.c_calvig             
        into ln_califrcc9
        FROM cldrccs i
       WHERE i.d_fecpre = add_months(last_day(p_fecdes),-9)
         and i.c_codsbs =  p_codsbs; 
    exception when others then NULL;   
   end;
    begin      
        SELECT distinct i.c_calvig             
        into ln_califrcc12
        FROM cldrccs i
       WHERE i.d_fecpre = add_months(last_day(p_fecdes),-12)
         and i.c_codsbs =  p_codsbs; 
    exception when others then NULL;   
   end;
   
end sp_rcc;
------------------------------------------------------------  
procedure atrasodias (p_pgcod in number,
                      p_scsus in number,
                      p_scmod in number,
                      p_scmda in number,
                      p_scpap in number,
                      p_sccta in number,
                      p_scope in number,
                      p_scsbo in number,
                      p_sctop in number,
                      p_fecha in date,                     
                      ln_saldo out number
                      )
is
      
begin  
    
      begin
         Select abs(bcsdmn)
           into ln_saldo
           from fsh012
          where bcemp =p_pgcod
            and bcsuc =p_scsus
            and bcmda =p_scmda
            and bcpap =p_scpap
            and bccta =p_sccta
            and bcoper=p_scope
            and bcsbop=p_scsbo
            and bctop =p_sctop
            and bcmod =p_scmod
            and bcfech=last_day(p_fecha);
       
    exception when others then
               NULL;
    end;   
    
 end atrasodias;  
    
------------------------------------------------------------------
procedure actualiza_desembolso (inst in number,
                                cta  in number,
                                oper  in number,
                                pais  in number,
                                numdoc in number,
                                tipdoc in varchar,
                                ln_eval in number,
                                codsbs  in varchar2,
                                pgcod in number,
                                scsus in number,
                                scmod in number,
                                scmda in number,
                                scpap in number,
                                sccta in number,
                                scope in number,
                                scsbo in number,
                                sctop in number,                                  
                                ln_saldo in number,
                                ln_sal_bru_tit in number,
                                ln_sal_bru_cony in number,
                                ln_otros_ing in number,
                                ln_total_ing in number,
                                ln_total_activo in number,
                                ln_total_patri in number,
                                ln_total_ven in number,
                                ln_tot_otro_ing in number,
                                ln_util_net in number,
                                ln_tot_gas_fam  in number,
                                ln_res_neto in number,
                                ln_exc_men in number,
                                ln_feceval in date,  
                                ln_tip_viv  in varchar,
                                ln_ent in number,                             
                                ln_salcapprov_12 in number, 
                                ln_salcapprov_9 in number, 
                                ln_salcapprov_6 in number, 
                                ln_salcapprov_3 in number, 
                                ln_salcapprov in number,                                
                                ln_mto_gar in number,
                                ln_tip_gar in varchar2,
                                ln_califrcc in varchar,
                                ln_califrcc3 in varchar,
                                ln_califrcc6 in varchar,
                                ln_califrcc9 in varchar,
                                ln_califrcc12 in varchar                   
                                ) is
  
begin
  update desembolso_pe d
     set d.eval         = ln_eval,
         d.sal_bru_tit  = ln_sal_bru_tit,
         d.sal_bru_cony = ln_sal_bru_cony,
         d.otros_ing    = ln_otros_ing,
         d.total_ing    = ln_total_ing,
         d.total_activo = ln_total_activo,
         d.total_patri  = ln_total_patri,
         d.total_ven    = ln_total_ven,
         d.tot_otro_ing = ln_tot_otro_ing,
         d.util_net     = ln_util_net,
         d.tot_gas_fam  = ln_tot_gas_fam,
         d.res_neto     = ln_res_neto,
         d.exc_men      = ln_exc_men, 
         d.feceval      = ln_feceval
   where d.nro_instancia = inst;
   
   update desembolso_pe d
     set 
         d.mto_gar    = ln_mto_gar,
         d.tip_gar    = ln_tip_gar
   where d.cuenta_cliente = cta
         and d.operacion  = oper;
         
    update desembolso_pe d
     set 
         d.tip_viv    = ln_tip_viv
   where  d.pais = pais
        and d.tipo_doc=tipdoc
        and d.num_doc=numdoc; 
     
   update desembolso_pe d
     set 
           d.ent=ln_ent,         
           d.salcapprov_12=ln_salcapprov_12,
           d.salcapprov_9=ln_salcapprov_9,
           d.salcapprov_6=ln_salcapprov_6,
           d.salcapprov_3=ln_salcapprov_3,
           d.salcapprov=ln_salcapprov,           
           d.califrcc =ln_califrcc, 
           d.califrcc3 =ln_califrcc3,
           d.califrcc6 =ln_califrcc6,
           d.califrcc9 =ln_califrcc9,
           d.califrcc12 =ln_califrcc12  
   where  d.codigo_sbs=codsbs;
           
    update desembolso_pe d
     set          
         d.saldomes =ln_saldo
              
     where d.pgcod=pgcod
           and d.hsucur=scsus
           and d.codigo_producto=scmod
           and d.codigo_moneda=scmda
           and d.hpap=scpap
           and d.cuenta_cliente=sccta
           and d.operacion=scope
           and d.hsubop=scsbo
           and d.htoper=sctop;
                 
  
end actualiza_desembolso;
-------------------------------------------------------------------  
  procedure sp_carga_data is
    
  eval number;
  sal_bru_tit  number;
  sal_bru_cony number;
  otros_ing number;
  total_ing number;
  total_activo number;
  total_patri number;
  total_ven number;
  tot_otro_ing number;
  util_net number;
  tot_gas_fam number;
  res_neto number;
  exc_men number;
  feceval date;
  tip_viv varchar(1000);
  mto_gar number;
  tip_gar varchar2(10000); 
  ent number;
  salcapprov_12 number;
  salcapprov_9 number;
  salcapprov_6 number;
  salcapprov_3 number;
  salcapprov number;  
  saldo number; 
  califrcc varchar2(1);
  califrcc3 varchar2(1);
  califrcc6 varchar2(1);
  califrcc9 varchar2(1);
  califrcc12 varchar2(1);
  
  
   cursor carga_data is
    select 
           codigo_sbs,
           cuenta_cliente,
           codigo_ciiu,
           operacion,
           fecha_desembolso,
           importe_desembolso_mo,
           importe_desembolso_mn,
           cuota,
           codigo_moneda,
           modulo_transaccion,
           codigo_transaccion,
           codigo_producto,
           codigo_rubro,
           codigo_tipo_credito,
           nro_instancia,
           tipo_doc,
           num_doc,
           pais,
           pgcod,
           htoper,
           hpap,
           hsucur,
           hsubop           
    from desembolso_pe d;  
  
  begin        
   for i in carga_data loop
      tip_viv:= PQ_CARGA_DATA_RIE_CAMPAÑA.fn_tipo_vivienda(p_pais=>i.pais,
                                                       p_tdoc=>i.tipo_doc,
                                                       p_ndoc=>i.num_doc); 
      mto_gar:=PQ_CARGA_DATA_RIE_CAMPAÑA.fn_Saldo_garantia(p_Pgcod=>i.pgcod,
                                             p_Scmod=>i.codigo_producto,
                                             p_Scsuc=>i.hsucur,
                                             p_Scmda=>i.codigo_moneda,
                                             p_Scpap=>i.hpap,
                                             p_Sccta=>i.cuenta_cliente,
                                             p_Scoper=>i.operacion,
                                             p_Scsbop=>i.hsubop,
                                             p_Sctope=>i.htoper,
                                             pd_fecha=>i.fecha_desembolso);  
                                             
    tip_gar:=PQ_CARGA_DATA_RIE_CAMPAÑA.fn_garantia_cred_ins(p_Pgcod=>i.pgcod,
                                             p_Scmod=>i.codigo_producto,
                                             p_Scsuc=>i.hsucur,
                                             p_Scmda=>i.codigo_moneda,
                                             p_Scpap=>i.hpap,
                                             p_Sccta=>i.cuenta_cliente,
                                             p_Scoper=>i.operacion,
                                             p_Scsbop=>i.hsubop,
                                             p_Sctope=>i.htoper 
                                             );                                                    
      PQ_CARGA_DATA_RIE_CAMPAÑA.sp_evaluacion(ld_fecha => i.fecha_desembolso ,
                                            inst => i.nro_instancia,
                                            ln_eval => eval,
                                            ln_sal_bru_tit => sal_bru_tit,
                                            ln_sal_bru_cony =>sal_bru_cony ,
                                            ln_otros_ing => otros_ing ,
                                            ln_total_ing => total_ing,
                                            ln_total_activo => total_activo,
                                            ln_total_patri => total_patri,
                                            ln_total_ven => total_ven,
                                            ln_tot_otro_ing => tot_otro_ing ,
                                            ln_util_net => util_net,
                                            ln_tot_gas_fam => tot_gas_fam ,
                                            ln_res_neto => res_neto ,
                                            ln_exc_men => exc_men,
                                            ln_feceval => feceval); 
                                             
     PQ_CARGA_DATA_RIE_CAMPAÑA.sp_rcc(p_codsbs=>i.codigo_sbs,
                                  p_fecdes=>i.fecha_desembolso,                  
                                  ln_ent=>ent,                                 
                                  ln_salcapprov_12=>salcapprov_12,
                                  ln_salcapprov_9=>salcapprov_9,
                                  ln_salcapprov_6=>salcapprov_6,
                                  ln_salcapprov_3=>salcapprov_3,
                                  ln_salcapprov=>salcapprov,                                  
                                  ln_califrcc=>califrcc,
                                  ln_califrcc3=>califrcc3,
                                  ln_califrcc6=>califrcc6,
                                  ln_califrcc9=>califrcc9,
                                  ln_califrcc12=>califrcc12
                                  );
                                  
      PQ_CARGA_DATA_RIE_CAMPAÑA.atrasodias(p_pgcod=>i.pgcod, 
                                       p_scsus=>i.hsucur,
                                       p_scmod=>i.codigo_producto,
                                       p_scmda=>i.codigo_moneda,
                                       p_scpap=>i.hpap,
                                       p_sccta=>i.cuenta_cliente,
                                       p_scope=>i.operacion,
                                       p_scsbo=>i.hsubop,
                                       p_sctop=>i.htoper,
                                       p_fecha=>i.fecha_desembolso,                                       
                                       ln_saldo=>saldo
                                       );    
                                                                   
                              
     PQ_CARGA_DATA_RIE_CAMPAÑA.actualiza_desembolso(inst => i.nro_instancia,
                                               cta  => i.cuenta_cliente, 
                                               oper => i.operacion, 
                                               pais  => i.pais,
                                               numdoc => i.num_doc,
                                               tipdoc => i.tipo_doc,
                                               codsbs=>i.codigo_sbs,
                                               pgcod=>i.pgcod, 
                                               scsus=>i.hsucur,
                                               scmod=>i.codigo_producto,
                                               scmda=>i.codigo_moneda,
                                               scpap=>i.hpap,
                                               sccta=>i.cuenta_cliente,
                                               scope=>i.operacion,
                                               scsbo=>i.hsubop,
                                               sctop=>i.htoper, 
                                               /*ln_saldo_1=>saldo_1,*/
                                               ln_saldo=>saldo,                                                
                                               ln_eval => eval,
                                               ln_sal_bru_tit => sal_bru_tit,
                                               ln_sal_bru_cony =>sal_bru_cony ,
                                               ln_otros_ing => otros_ing ,
                                               ln_total_ing => total_ing,
                                               ln_total_activo => total_activo,
                                               ln_total_patri => total_patri,
                                               ln_total_ven => total_ven,
                                               ln_tot_otro_ing => tot_otro_ing ,
                                               ln_util_net => util_net,
                                               ln_tot_gas_fam => tot_gas_fam ,
                                               ln_res_neto => res_neto ,
                                               ln_exc_men  => exc_men,
                                               ln_feceval => feceval,                     
                                               ln_tip_viv =>tip_viv,
                                               ln_ent=>ent,                                               
                                               ln_salcapprov_12=>salcapprov_12, 
                                               ln_salcapprov_9=>salcapprov_9, 
                                               ln_salcapprov_6=>salcapprov_6, 
                                               ln_salcapprov_3=>salcapprov_3, 
                                               ln_salcapprov=>salcapprov,                                              
                                               ln_mto_gar => mto_gar,
                                               ln_tip_gar => tip_gar,
                                               ln_califrcc=>califrcc,
                                               ln_califrcc3=>califrcc3,
                                               ln_califrcc6=>califrcc6,
                                               ln_califrcc9=>califrcc9,
                                               ln_califrcc12=>califrcc12                                                         
                                                );
      commit;
   end loop;    
 end sp_carga_data;  
 
 -------------------------------------
 -------------------------------------
 procedure sp_job_carga_data is
    
    lc_hostname varchar2(64);
    x number; 
    lc_variable   varchar2(4000);
    ln_job        number:= 0;    
    valgrup       number:=0;
    contador      number:=0;
    aux           number:=0;
    cursor grupo is 
    select * from desembolso_pe d; 
      
   begin  

   update desembolso_pe d
   set d.grupo=rownum; 
                  
   for i in grupo loop
          
         if contador=1000 then             
             
              update desembolso_pe d
              set d.grupo1=(valgrup+1)
              where d.grupo>=contador*(valgrup) and d.grupo<=contador*(valgrup+1);
              valgrup:= valgrup +1;
              contador:=0;           
         end if;      
 
         aux:= aux+1;
         contador:=contador +1;
         
        commit;      
    End loop; 
    
    
          update desembolso_pe d
              set d.grupo1=(valgrup+1)
           WHERE  d.grupo1 is null;  
  
   x:=1; 
   WHILE x<=(valgrup+1)
    LOOP
       
      lc_variable := ' begin '||'  PQ_CARGA_DATA_RIE_CAMPAÑA.sp_carga_data_job('|| ''''||x||''''|| ');'|| ' End; ';
      ln_job := ln_job +1; 
      
       dbms_scheduler.create_job(
         job_name=> 'DESEMB'||LPAD(TO_CHAR(ln_job),5,'0'),
         job_type=> 'PLSQL_BLOCK',
         job_action=> lc_variable,
         start_date => sysdate+0.5/(24*60),
         enabled => true, 
         auto_drop=> TRUE,
         comments => 'ACTIVAS'
         );
       commit;  
       
        begin
              select host_name
              into lc_hostname
              from v$instance;

        end;
          
--        if UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052') then
--        if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101') then
          IF SYS.FN_BD_ISRAC='TRUE' THEN
          begin        
            dbms_scheduler.set_attribute(
              'DESEMB'||LPAD(TO_CHAR(ln_job),5,'0'),
              'instance_id',
              2);
          end; 
          else
                begin
                  dbms_scheduler.set_attribute(
                    'DESEMB'||LPAD(TO_CHAR(ln_job),5,'0'),
                    'instance_id',
                    1);
                end; 
          end if;
           
      /* begin
        dbms_scheduler.set_attribute('DESEMB'||LPAD(TO_CHAR(ln_job),5,'0'),'instance_id',2);
       end; */
      x:=x+1;
    END LOOP; 
    
 end ;  
  
  PROCEDURE sp_carga_data_job (x in number ) 
 IS      
   cursor c_desembolso_dia is 
   select  
           codigo_sbs,
           cuenta_cliente,
           codigo_ciiu,
           operacion,
           fecha_desembolso,
           importe_desembolso_mo,
           importe_desembolso_mn,
           cuota,
           codigo_moneda,
           modulo_transaccion,
           codigo_transaccion,
           codigo_producto,
           codigo_rubro,
           codigo_tipo_credito,
           nro_instancia,
           tipo_doc,
           num_doc,
           pais,
           pgcod,
           htoper,
           hpap,
           hsucur,
           hsubop           
      from desembolso_pe d 
      where d.grupo1=x;        
          eval number;
          sal_bru_tit  number;
          sal_bru_cony number;
          otros_ing number;
          total_ing number;
          total_activo number;
          total_patri number;
          total_ven number;
          tot_otro_ing number;
          util_net number;
          tot_gas_fam number;
          res_neto number;
          exc_men number;
          feceval date;
          tip_viv varchar(1000); 
          ent number;         
          salcapprov_12 number;
          salcapprov_9 number;
          salcapprov_6 number;
          salcapprov_3 number;
          salcapprov number;         
          saldo_1 number;
          saldo number;          
          mto_gar number;
          tip_gar varchar2(10000);
          califrcc varchar2(1);
          califrcc3 varchar2(1);
          califrcc6 varchar2(1);
          califrcc9 varchar2(1);
          califrcc12 varchar2(1);           
                  
          begin          
          for i in c_desembolso_dia loop  
               tip_viv:= PQ_CARGA_DATA_RIE_CAMPAÑA.fn_tipo_vivienda(p_pais=>i.pais,
                                                       p_tdoc=>i.tipo_doc,
                                                       p_ndoc=>i.num_doc); 
               mto_gar:=PQ_CARGA_DATA_RIE_CAMPAÑA.fn_Saldo_garantia(p_Pgcod=>i.pgcod,
                                             p_Scmod=>i.codigo_producto,
                                             p_Scsuc=>i.hsucur,
                                             p_Scmda=>i.codigo_moneda,
                                             p_Scpap=>i.hpap,
                                             p_Sccta=>i.cuenta_cliente,
                                             p_Scoper=>i.operacion,
                                             p_Scsbop=>i.hsubop,
                                             p_Sctope=>i.htoper,
                                             pd_fecha=>i.fecha_desembolso);  
                                             
               tip_gar:=PQ_CARGA_DATA_RIE_CAMPAÑA.fn_garantia_cred_ins(p_Pgcod=>i.pgcod,
                                             p_Scmod=>i.codigo_producto,
                                             p_Scsuc=>i.hsucur,
                                             p_Scmda=>i.codigo_moneda,
                                             p_Scpap=>i.hpap,
                                             p_Sccta=>i.cuenta_cliente,
                                             p_Scoper=>i.operacion,
                                             p_Scsbop=>i.hsubop,
                                             p_Sctope=>i.htoper 
                                             );                                                    
                PQ_CARGA_DATA_RIE_CAMPAÑA.sp_evaluacion(ld_fecha => i.fecha_desembolso ,
                                            inst => i.nro_instancia,
                                            ln_eval => eval,
                                            ln_sal_bru_tit => sal_bru_tit,
                                            ln_sal_bru_cony =>sal_bru_cony ,
                                            ln_otros_ing => otros_ing ,
                                            ln_total_ing => total_ing,
                                            ln_total_activo => total_activo,
                                            ln_total_patri => total_patri,
                                            ln_total_ven => total_ven,
                                            ln_tot_otro_ing => tot_otro_ing ,
                                            ln_util_net => util_net,
                                            ln_tot_gas_fam => tot_gas_fam ,
                                            ln_res_neto => res_neto ,
                                            ln_exc_men => exc_men,
                                            ln_feceval => feceval); 
                                             
               PQ_CARGA_DATA_RIE_CAMPAÑA.sp_rcc(p_codsbs=>i.codigo_sbs,
                                  p_fecdes=>i.fecha_desembolso,                  
                                  ln_ent=>ent,                                 
                                  ln_salcapprov_12=>salcapprov_12,
                                  ln_salcapprov_9=>salcapprov_9,
                                  ln_salcapprov_6=>salcapprov_6,
                                  ln_salcapprov_3=>salcapprov_3,
                                  ln_salcapprov=>salcapprov,                                  
                                  ln_califrcc=>califrcc,
                                  ln_califrcc3=>califrcc3,
                                  ln_califrcc6=>califrcc6,
                                  ln_califrcc9=>califrcc9,
                                  ln_califrcc12=>califrcc12
                                  );
                                  
             PQ_CARGA_DATA_RIE_CAMPAÑA.atrasodias(p_pgcod=>i.pgcod, 
                                       p_scsus=>i.hsucur,
                                       p_scmod=>i.codigo_producto,
                                       p_scmda=>i.codigo_moneda,
                                       p_scpap=>i.hpap,
                                       p_sccta=>i.cuenta_cliente,
                                       p_scope=>i.operacion,
                                       p_scsbo=>i.hsubop,
                                       p_sctop=>i.htoper,
                                       p_fecha=>i.fecha_desembolso,                                       
                                       ln_saldo=>saldo
                                       );    
                                                                   
                              
             PQ_CARGA_DATA_RIE_CAMPAÑA.actualiza_desembolso(inst => i.nro_instancia,
                                               cta  => i.cuenta_cliente, 
                                               oper => i.operacion, 
                                               pais  => i.pais,
                                               numdoc => i.num_doc,
                                               tipdoc => i.tipo_doc,
                                               codsbs=>i.codigo_sbs,
                                               pgcod=>i.pgcod, 
                                               scsus=>i.hsucur,
                                               scmod=>i.codigo_producto,
                                               scmda=>i.codigo_moneda,
                                               scpap=>i.hpap,
                                               sccta=>i.cuenta_cliente,
                                               scope=>i.operacion,
                                               scsbo=>i.hsubop,
                                               sctop=>i.htoper,                                               
                                               ln_saldo=>saldo,                                                
                                               ln_eval => eval,
                                               ln_sal_bru_tit => sal_bru_tit,
                                               ln_sal_bru_cony =>sal_bru_cony ,
                                               ln_otros_ing => otros_ing ,
                                               ln_total_ing => total_ing,
                                               ln_total_activo => total_activo,
                                               ln_total_patri => total_patri,
                                               ln_total_ven => total_ven,
                                               ln_tot_otro_ing => tot_otro_ing ,
                                               ln_util_net => util_net,
                                               ln_tot_gas_fam => tot_gas_fam ,
                                               ln_res_neto => res_neto ,
                                               ln_exc_men  => exc_men,
                                               ln_feceval => feceval,                     
                                               ln_tip_viv =>tip_viv,
                                               ln_ent=>ent,                                               
                                               ln_salcapprov_12=>salcapprov_12, 
                                               ln_salcapprov_9=>salcapprov_9, 
                                               ln_salcapprov_6=>salcapprov_6, 
                                               ln_salcapprov_3=>salcapprov_3, 
                                               ln_salcapprov=>salcapprov,                                              
                                               ln_mto_gar => mto_gar,
                                               ln_tip_gar => tip_gar,
                                               ln_califrcc=>califrcc,
                                               ln_califrcc3=>califrcc3,
                                               ln_califrcc6=>califrcc6,
                                               ln_califrcc9=>califrcc9,
                                               ln_califrcc12=>califrcc12                                                         
                                                );
          commit;
          end loop; 
   end;       
end PQ_CARGA_DATA_RIE_CAMPAÑA;
/

