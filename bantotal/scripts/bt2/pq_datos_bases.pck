create or replace package agecombt.pq_datos_bases as
  procedure sp_genera_inactivos;
  procedure sp_genera_lineas0;
  procedure sp_genera_ampliaciones;
  procedure sp_genera_inactivos_cc;--callcenter
  procedure sp_genera_lineas0_cc;--callcenter
  procedure sp_genera_ampliaciones_cc;--callcenter
  procedure sp_genera_inactivos_cc_ext;--callcenter externo
  procedure sp_genera_lineas0_cc_ext;--callcenter externo
  procedure sp_genera_ampliaciones_cc_ext;--callcenter externo
  procedure sp_procesa_desembolsos;
  procedure sp_act_seguimiento(codact number,
                               codbas number,
                               corr number, --correlativo cliente
                               ases varchar2, --analista
                               rpta varchar2, --estado de solicitud
                               nsol number, --instancia 
                               ultr number, --último resultado agenda comercial
                               uact varchar2 --usuario actual
                              );
  function fn_cl_telefonosxcod_call(  lv_pepais in number,
                                              lv_petdoc in number,
                                              lv_pendoc in varchar2,
                                              lv_docod  in number
                                            ) return varchar2;
  function fn_direccion_cliente(
                                                  lv_pepais in number,
                                                  lv_petdoc in number,
                                                  lv_pendoc in varchar2,
                                                  lv_docod  in number,
                                                  lv_tipo   in varchar2--,
                                                  --lv_flgact in varchar2
                                                 ) return varchar2;
  function fn_nomcli(v_pepais  in number,
                                       v_petdoc  in number,
                                       v_pendoc in varchar2
                                       ) return varchar2;
  function fn_tipo_solicitud (p_pgcod  in fsd010.pgcod%type,
                             p_aomod  in fsd010.aomod%type,
                             p_aosuc  in fsd010.aosuc%type,
                             p_aomda  in fsd010.aomda%type,
                             p_aopap  in fsd010.aopap%type,
                             p_aocta  in fsd010.aocta%type,
                             p_aooper in fsd010.aooper%type,
                             p_aosbop in fsd010.aosbop%type,
                             p_aotope in fsd010.aotope%type
                            ) return number;
  function fn_cantidad_cuotas(
                                 v_Pgcod  in number,
                                 v_Scmod  in number,
                                 v_Scsuc  in number,
                                 v_Scmda  in number,
                                 v_Scpap  in number,
                                 v_Sccta  in number,
                                 v_Scoper in number,
                                 v_Scsbop in number,
                                 v_Sctope in number
                               ) return number;
  function fn_row_ultcred (ln_pepais in number,
                         ln_petdoc in number,
                         lv_pendoc in char
                        )return varchar2;
  function fn_fec_ultcred (ln_pepais in number,
                         ln_petdoc in number,
                         lv_pendoc in char
                        )return date;
  FUNCTION CRE_FN_ATR_PROM_CLI_NUMDOC(PD_FECPRO IN DATE,
                                      PD_FECINI IN DATE,
                                      PC_NUMDOC IN VARCHAR2
                                     ) RETURN NUMBER;
  function fn_tipo_cambio_fijo(P_FECHA in date) return number;
  function fn_capital_total(v_Pgcod  in number,
                          v_Scmod  in number,
                          v_Scsuc  in number,
                          v_Scmda  in number,
                          v_Scpap  in number,
                          v_Sccta  in number,
                          v_Scoper in number,
                          v_Scsbop in number,
                          v_Sctope in number
                          ) return number;
  function fn_capdeu_cuoven(v_Pgfape in date, --fecha de proceso
                                     v_Pgcod  in number,
                                     v_Scmod  in number,
                                     v_Scsuc  in number,
                                     v_Scmda  in number,
                                     v_Scpap  in number,
                                     v_Sccta  in number,
                                     v_Scoper in number,
                                     v_Scsbop in number,
                                     v_Sctope in number
                                   ) return number;
  function fn_cant_cuoxven(v_Pgcod  in number,
                           v_Scmod  in number,
                           v_Scsuc  in number,
                           v_Scmda  in number,
                           v_Scpap  in number,
                           v_Sccta  in number,
                           v_Scoper in number,
                           v_Scsbop in number,
                           v_Sctope in number
                          ) return number;
  function fn_fecha_solicitudxinst_min (ln_instancia  in xwf700.xwfprcins%type,
                                        p_estado in number            
                                       ) return date;
  function fn_tipcli (P_NDOC in char, P_FECPRO in date) return varchar2;
  function fn_ult_tipcre( lv_rowid varchar2) return varchar2;
  function fn_instancia_credito(  v_Scmod  in number,
                                  v_Scsuc  in number,
                                  v_Scmda  in number,
                                  v_Scpap  in number,
                                  v_Sccta  in number,
                                  v_Scoper in number,
                                  v_Scsbop in number,
                                  v_Sctope in number
                                ) return number;
  function fn_analista_credito(  v_Scmod  in number,
                                 v_Scsuc  in number,
                                 v_Scmda  in number,
                                 v_Scpap  in number,
                                 v_Sccta  in number,
                                 v_Scoper in number,
                                 v_Scsbop in number,
                                 v_Sctope in number
                               ) return varchar2;
  procedure sp_tracli (ps_corcli number, ps_usuant varchar2, ps_usuact varchar2);
  procedure sp_insvis (ps_codpai number,ps_tipdoc number, ps_numdoc varchar2,ps_codact number,
                     ps_codusu varchar2,ps_codres number);
  procedure sp_genera_campana;
end pq_datos_bases;
/
create or replace package body agecombt.pq_datos_bases as
  procedure sp_procesa_desembolsos is
  begin
    EXECUTE IMMEDIATE 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
    --1.Obtener los clientes de Agenda Comercial que aún estén en gestión (retirar los cerrados).
    EXECUTE IMMEDIATE 'truncate table JAQZ916';
    insert /*+append*/ into JAQZ916 (ncodact,ncodbas,corrac,pepais,petdoc,pendoc,fecreg,ultrpta,usuact)
    select distinct ncodact,ncodbas,ncorcli,npaicli,ntipdoc,cnumdoc,dfeceva,ncodres,ccodusu from
    ( select RANK() OVER (PARTITION BY  eva.npaicli,eva.ntipdoc,eva.cnumdoc  ORDER BY rev.ncorage,pue.ncodres DESC) as ra,
             eva.ncodact,
             eva.ncodbas,
             eva.ncorcli,
             eva.npaicli,
             eva.ntipdoc,
             eva.cnumdoc,
             eva.dfeceva, --Fecha Registro
             pue.ncodres, --Cod. Ult. Rpta
             upper(asi.ccodusu) as ccodusu  --Usuario Actual
        from (select ncodact,ncodbas,ncorcli,npaicli,ntipdoc,cnumdoc,dfeceva,nindcier from acdeval where nindcier = '0'
               union         
              select ncodact,ncodbas,ncorcli,npaicli,ntipdoc,cnumdoc,dfeceva,nindcier from acheval where nindcier = '0')
              eva
       inner join (select ncorcli,ncorasi,ccodusu from acdasig
                    union
                   select ncorcli,ncorasi,ccodusu from achasig)
                   asi
         on eva.ncorcli = asi.ncorcli
       inner join (select ncorasi,ncorage,ncodact,ccodusu from acdagen
                   union
                   select ncorasi,ncorage,ncodact,ccodusu from achagen
                   )age
               on age.ncorasi = asi.ncorasi
        left join acdrevi rev
          on rev.ncorage = age.ncorage
        left join acdrepu rep
          on rev.nrespue = rep.nrespue  
        left join acdprre pue
          on pue.npreres = rep.npreres
       where eva.nindcier = '0'
         and (rep.nrescod = '4' or 
              rep.nrescod is null)
         --and age.ncodact in (1,4) 20171003 lgarcia para que considere
          ) a where ra = 1 ;
    commit;
    --2.Cargamos estado de la solicitud de crédito de cada cliente
    EXECUTE IMMEDIATE 'truncate table JAQZ917';
    insert /*+append*/ into JAQZ917 (ncodact,ncodbas,corrac,pais,tdoc,ndoc,regnom,deszon,scnom,codase,fecsol,instancia,tipclides,tipcre,aoimp,pgcod,aomod,aosuc,aomda,aopap,aocta,aooper,aosbop,aotope,aofval,estado,ultrpta,usuact,aotasa)
    select /*+all_rows*/
           t.ncodact,
           t.ncodbas,
           t.corrac,
           r8_tit.pepais pais, r8_tit.petdoc tdoc, r8_tit.pendoc ndoc, --20170518
           rs.regnom,
           rs.deszon,
           rs.scnom,
           pq_datos_bases.fn_analista_credito(d10.aomod,d10.aosuc,d10.aomda,d10.aopap,d10.aocta,d10.aooper,d10.aosbop,d10.aotope) codase,
           pq_datos_bases.fn_fecha_solicitudxinst_min(pq_datos_bases.fn_instancia_credito(d10.aomod,d10.aosuc,d10.aomda,d10.aopap,d10.aocta,d10.aooper,d10.aosbop,d10.aotope),3) fecsol,
           pq_datos_bases.fn_instancia_credito(d10.aomod,d10.aosuc,d10.aomda,d10.aopap,d10.aocta,d10.aooper,d10.aosbop,d10.aotope) instancia,
           decode(pq_datos_bases.fn_tipcli(r8_tit.pendoc,d10.aofval-1),'N','NUEVO','I','INACTIVO','R','RECURRENTE') tipclides,
           pq_datos_bases.fn_ult_tipcre(d10.rowid) tipcre,
           d10.aoimp,
           d10.pgcod,
           d10.aomod,
           d10.aosuc,
           d10.aomda,
           d10.aopap,
           d10.aocta,
           d10.aooper,
           d10.aosbop,
           d10.aotope,
           d10.aofval,
           --to_date('20170512','rrrrmmdd'),--d10.aofval, --PRUEBAAA 20170515
           'DESEMBOLSADO' estado,
           t.ultrpta,
           t.usuact,
           d10.aotasa
      from fsd010 d10 
      join fsr008 r8
        on d10.pgcod=r8.pgcod
       and d10.aocta=r8.ctnro
       and r8.ttcod=1
      join fsr008 r8_tit--20170518
        on d10.pgcod=r8_tit.pgcod
       and d10.aocta=r8_tit.ctnro
       and r8_tit.ttcod=1
       and r8_tit.cttfir = 'T'
      join JAQZ916 t
        on r8.pepais=t.pepais
       and r8.petdoc=t.petdoc
       and r8.pendoc=t.pendoc
      left join regsuc rs
        on rs.sucurs = d10.aosuc
     where d10.pgcod=1
       and d10.aomod in (select modulo from fst111 where dscod=50 and modulo not in (29,120,142,144,33,200,108))
       and pq_datos_bases.fn_fecha_solicitudxinst_min(pq_datos_bases.fn_instancia_credito(d10.aomod,d10.aosuc,d10.aomda,d10.aopap,d10.aocta,d10.aooper,d10.aosbop,d10.aotope),3) >= trunc(t.fecreg)--20170518
    union all   
    select /*+all_rows*/
           t.ncodact,
           t.ncodbas,
           t.corrac,
           r8_tit.pepais pais, r8_tit.petdoc tdoc, r8_tit.pendoc ndoc,--20170518
           rs.regnom,
           rs.deszon,
           rs.scnom,
           pq_datos_bases.fn_analista_credito(x.xwfmodulo,x.xwfsucursal,x.xwfmoneda,x.xwfpapel,x.xwfcuenta,x.xwfoperacion,x.xwfsubope,x.xwftipope),
           pq_datos_bases.fn_fecha_solicitudxinst_min(pq_datos_bases.fn_instancia_credito(x.xwfmodulo,x.xwfsucursal,x.xwfmoneda,x.xwfpapel,x.xwfcuenta,x.xwfoperacion,x.xwfsubope,x.xwftipope),3),
           x.xwfprcins,
           null,
           null,
           null,
           null,
           null,
           null,
           null,
           null,
           null,
           null,
           null,
           null,
           null,
           case when w.wfstscod in ('C','B','E','D') then 'DENEGADO'
                when w.wftaskcod = 3 then 'EN SOLICITUD'
                when w.wftaskcod = 7 then 'EN EVALUACION'
                when w.wftaskcod = 11 then 'EN APROBACION'
                when w.wftaskcod = 55 then 'POR DESEMBOLSAR'
                else 'EN SOLICITUD' end estado,
           t.ultrpta,
           t.usuact,
           null
      from xwf700 x
      join fsr008 r8
        on x.xwfempresa = r8.pgcod
       and x.xwfcuenta = r8.ctnro
       and r8.ttcod=1
       and x.xwfcar3 = '1'
      join fsr008 r8_tit --20170518
        on x.xwfempresa=r8_tit.pgcod
       and x.xwfcuenta=r8_tit.ctnro
       and r8_tit.ttcod=1
       and r8_tit.cttfir = 'T'
      join JAQZ916 t
        on r8.pepais=t.pepais
       and r8.petdoc=t.petdoc
       and r8.pendoc=t.pendoc
      join wfwrkitems w
        on w.wfinsprcid = x.xwfprcins
       and w.wftaskcod in (3, 7, 11, 55)
       and (w.wfstscod not in ('C','B','E','D') /*caido wfstate1*/ or exists(select 1 from Sngm10 c where c.sngm01tipm = 1 and c.sngm02motc in (15,30,35) and c.sngm10inst = w.wfinsprcid)/*Denegado*/)
       and w.wfitemid = (select max(m.wfitemid)
                           from wfwrkitems m
                          where m.wfinsprcid = w.wfinsprcid)
      left join regsuc rs
        on rs.sucurs = x.xwfsucursal
     where pq_datos_bases.fn_fecha_solicitudxinst_min(pq_datos_bases.fn_instancia_credito(x.xwfmodulo,x.xwfsucursal,x.xwfmoneda,x.xwfpapel,x.xwfcuenta,x.xwfoperacion,x.xwfsubope,x.xwftipope),3) >= trunc(t.fecreg);--20170518
    commit;

    --3.1.Retirar tipos de crédito excepcionales:
    delete from JAQZ917 a
     where exists (select 1 from fst004 t4 where upper(t4.tonom) like '%PARALELO%' and t4.modulo = a.aomod and t4.totope = a.aotope)--paralelos
        or (a.aomod=116 and a.aotope = 25)--seguros
        or (a.aomod = 116 and a.aotope = 550)--lineas judiciales
        or exists (select 1 from fst004 t4 where upper(tonom) like '%ADICIO%' and t4.modulo = 116 and t4.modulo = a.aomod and t4.totope = a.aotope);--líneas adicionales
    commit;

    --3.2.Retirar créditos con solicitudes ya asignadas en la agenda comercial:
    delete from JAQZ917 a where instancia in (select nnumsol from ACDDESE);
    commit;

    --3.3.Retirar desembolsos de lineas que no sean el 1er desembolso:
    delete from JAQZ917 a 
     where a.aomod = 116 
       and aofval <> (select min(d10.aofval)
                        from fsd010 d10
                        join fsr011 r
                          on r.r1cod  = d10.pgcod 
                         and r.r1mod  = d10.aomod 
                         --and r.r1suc  = d10.aosuc 
                         and r.r1mda  = d10.aomda 
                         and r.r1pap  = d10.aopap 
                         and r.r1cta  = d10.aocta 
                         and r.r1oper = d10.aooper
                         --and r.r1sbop = d10.aosbop
                         and r.r1tope = d10.aotope
                         and r.relcod = 46
                         and r.r011co = 'S'
                        join fsr011 x
                          on x.r2cod  = r.r2cod 
                         and x.r2mod  = r.r2mod 
                         --and x.r2suc  = r.r2suc 
                         and x.r2mda  = r.r2mda 
                         and x.r2pap  = r.r2pap 
                         and x.r2cta  = r.r2cta 
                         and x.r2oper = r.r2oper
                         --and x.r2sbop = r.r2sbop
                         and x.r2tope = r.r2tope
                         and x.relcod = 46
                         and x.r011co = 'S'
                       where x.r1cod  = a.pgcod
                         and x.r1mod  = a.aomod
                         and x.r1suc  = a.aosuc
                         and x.r1mda  = a.aomda
                         and x.r1pap  = a.aopap
                         and x.r1cta  = a.aocta
                         and x.r1oper = a.aooper
                         and x.r1sbop = a.aosbop
                         and x.r1tope = a.aotope
                         and x.relcod = 46
                         and x.r011co = 'S');
    commit;

    --3.4.Retirar desembolsos adicionales para una misma captación:
    DECLARE
      CURSOR crs
          IS select t.corrac from JAQZ917 t group by corrac having count(*)>1; 
    BEGIN
      FOR x IN crs LOOP           
        delete 
          from JAQZ917
         where corrac = x.corrac
           and rowid not in (select id
                              from (select rowid id
                                      from JAQZ917
                                     where corrac = x.corrac
                                     order by corrac,aofval,fecsol,instancia,aoimp desc) where rownum = 1);
        commit;  
      END LOOP;  
    END;
	
	--3.5.Retirar mismo desembolso para distintas captaciones:
	DECLARE
	  CURSOR crs
		  IS select t.instancia from JAQZ917 t group by instancia,ncodact having count(*)>1;
	BEGIN
	  FOR x IN crs LOOP           
		delete 
		  from JAQZ917
		 where instancia = x.instancia
		   and rowid not in (select id
							  from (select rowid id
									  from JAQZ917
									 where instancia = x.instancia
									 order by corrac,aofval,fecsol,instancia,aoimp desc) where rownum = 1);
		commit;  
	  END LOOP;  
	END;

    --4.Insertar desembolsos en la agenda comercial
    insert /*+append*/ into ACDDESE (ncorcli,npaicli,ntipdoc,cnumdoc,cnomreg,cnomzon,cnomage,cnomana,nnumsol,ctipcli,ncanimp,ncodmon,dfecdes,cnompro,npgcod,naomod,naosuc,naopap,naocta,naooper,naosbop,naotope,ctelana,aotasa)
    select x.corrac,x.pais,x.tdoc,x.ndoc,x.regnom,x.deszon,x.scnom,x.codase,
           x.instancia,x.tipclides,x.aoimp,x.aomda,x.aofval,x.tipcre,x.pgcod,
           x.aomod,x.aosuc,x.aopap,x.aocta,x.aooper,x.aosbop,x.aotope,null,x.aotasa
      from JAQZ917 x
     where x.estado = 'DESEMBOLSADO';--20170515
    commit;
    
    --5.Insertar respuestas en la agenda comercial
    DECLARE
      CURSOR crs
          IS select t.corrac,t.codase,t.estado,t.instancia,t.ultrpta,t.usuact,t.ncodact,t.ncodbas from JAQZ917 t; 
    BEGIN
      FOR x IN crs LOOP
        --dbms_output.put_line('corrac: |'||'-'||'|'||x.corrac);
        --dbms_output.put_line('codase:|'||'-'||'|'||x.codase);
        --dbms_output.put_line('estado:|'||'-'||'|'||x.estado);
        --dbms_output.put_line('instancia:|'||'-'||'|'||x.instancia);
        --dbms_output.put_line('ultrpta:|'||'-'||'|'||x.ultrpta);
        --dbms_output.put_line('usuact:|'||'-'||'|'||x.usuact);
        pq_datos_bases.sp_act_seguimiento(x.ncodact,x.ncodbas,x.corrac,x.codase,x.estado,x.instancia,x.ultrpta,x.usuact);
        commit;  
      END LOOP;  
    END;
  end sp_procesa_desembolsos;


  procedure sp_genera_inactivos is
  begin
    EXECUTE IMMEDIATE 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
    EXECUTE IMMEDIATE 'truncate table JAQZ918';
    
    insert /*+append*/ into JAQZ918
    select w.pepais, w.petdoc, w.pendoc
      from (select /*+ PARALLEL(d10,2) PARALLEL(r8,2)*/
                   r8.pepais,r8.petdoc,r8.pendoc,
                   count(case when d10.aostat <> 99 then 1 end) n_CreVig,
                   max(d10.aofval)
              from fsd010 d10
              join fsr008 r8
                on r8.pgcod = d10.pgcod
               and r8.ctnro = d10.aocta
             where d10.aofe99 > (sysdate-365)
               and d10.aomod in (select modulo from fst111 where dscod = 50 and modulo not in (29/*GARANTIAS*/,120/*P PASIVOS*/,108/*PRENDARIOS*/))
             group by r8.pepais,r8.petdoc,r8.pendoc) w
      where w.n_CreVig = 0
        and not exists ( --No creditos vigentes, como TITULAR y CONYUGE o integrante
                        select /*+PARALLEL(a,2) PARALLEL(b,2)*/
                               1 
                          from fsd011 a
                          join fsr008 b 
                            on b.pgcod = a.pgcod
                           and b.ctnro = a.sccta
                         where a.sccta <> 999999999 
                           and substr(a.scrub,1,4) in (1411,1414,1415,1416,1421,1424,1425,1426)
                           and a.scmod not in (108,141)                            
                           and b.pepais = w.pepais
                           and b.petdoc = w.petdoc
                           and b.pendoc = w.pendoc
                      )
       and not exists ( --no lineas vigentes con saldo 0
                        select /*+PARALLEL(a,2) PARALLEL(b,2)*/
                               1 
                          from fsd010 a
                          join fsr008 b 
                            on b.pgcod = a.pgcod
                           and b.ctnro = a.aocta
                         where a.aomod = 117
                           and a.aostat <> 99    
                           and b.pepais = w.pepais
                           and b.petdoc = w.petdoc
                           and b.pendoc = w.pendoc
                      )               
       and not exists (--no tienen credito judiciales, castigados, con demanda cancelados
                        select /*+PARALLEL(a,2) PARALLEL(b,2)*/
                               1 
                          from fsd010 a
                          join fsr008 b 
                            on b.pgcod = a.pgcod
                           and b.ctnro = a.aocta
                         where a.aocta <> 999999999 
                           and (a.aomod in (33,200) or --castigados, judiciales
                                a.aotope = 550 or --con demanda 
                                a.aostat in (71,66,64,23,25,22,21,33,34))--PJ
                           and a.aomod <> 120 --Prestamos pasivos
                           and b.pepais = w.pepais
                           and b.petdoc = w.petdoc
                           and b.pendoc = w.pendoc
                      );
    commit;
    delete from JAQZ918 w
     where exists (--En proceso de solicitud en los últimos 15 días
                   select /*+PARALLEL(a,2) PARALLEL(b,2)*/ 1
                     FROM wfwrkitems u 
                     join (select s.wfinsprcid,min(s.wfitemid) min_wfitemid
                           from wfwrkitems s 
                           where s.wftaskcod = 3
                             and trunc(s.WFITEMINIT)>= trunc(sysdate-15)
                           group by s.wfinsprcid       
                          )m
                       on m.wfinsprcid = u.wfinsprcid
                      and m.min_wfitemid = u.wfitemid
                     join xwf700 f700 
                       on f700.xwfprcins = u.wfinsprcid 
                     join fsr008 r8
                       on r8.pgcod = f700.xwfempresa
                      and r8.ctnro = f700.xwfcuenta
                    where f700.xwfcar3 = '1'
                      and u.wftaskcod = 3
                      and r8.pepais = w.pepais
                      and r8.petdoc = w.petdoc
                      and r8.pendoc = w.pendoc);
    commit;
    
    begin
        DBMS_STATS.gather_table_stats(ownname          => 'AGECOMBT',
                                      tabname          => 'JAQZ918',
                                      degree           => 4,
                                      granularity      => 'ALL',
                                      estimate_percent => dbms_stats.auto_sample_size,
                                      cascade          => TRUE);
      end;
    --Limpiamos la ejecución anterior
    delete from acdbase_temp 
     where nidebas = 1
       and nidepro = 3
       and ncoding = 1
       and ncodact = 1
       and ncodbas = 1
       and cestado = '1';
    commit;
    
    begin
        DBMS_STATS.gather_table_stats(ownname          => 'AGECOMBT',
                                      tabname          => 'ACDBASE_TEMP',
                                      degree           => 4,
                                      granularity      => 'ALL',
                                      estimate_percent => dbms_stats.auto_sample_size,
                                      cascade          => TRUE);
      end;
      
    insert /*+append*/ into acdbase_temp (nidebas,nidepro,ncoding,ncodact,ncodbas,cestado,
                                     nnumpas,ntipdoc,cnumdoc,npascon,ntipcon,cdoccon,
                                     cnombre,czonfij,cdirfij,creffij,czonneg,cdirneg,
                                     crefneg,ctelfij,ctelmov,ncodage,ncodana,cusuing,
                                     dfecing,ncodpri)
    select 1,3,1,1,1,'1',--#REVISAR TI
           w.pepais, w.petdoc, w.pendoc,
           decode((select max(r2.rpndoc) from fsr002 r2 where r2.pepais = w.pepais and r2.petdoc = w.petdoc and r2.pendoc = w.pendoc and r2.rpccyg = 66),null,null,604),
           decode((select max(r2.rpndoc) from fsr002 r2 where r2.pepais = w.pepais and r2.petdoc = w.petdoc and r2.pendoc = w.pendoc and r2.rpccyg = 66),null,null,21),
           (select max(r2.rpndoc) from fsr002 r2 where r2.pepais = w.pepais and r2.petdoc = w.petdoc and r2.pendoc = w.pendoc and r2.rpccyg = 66),
           pq_datos_bases.fn_nomcli(w.pepais, w.petdoc, w.pendoc) nomcli,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,1,'UBIG') UBIG_DOM,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,1,'DIR') DIR_DOM, 
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,1,'REF') REF_DOM,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,3,'UBIG') UBIG_NEG,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,3,'DIR') DIR_NEG,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,3,'REF') REF_NEG,
           pq_datos_bases.fn_cl_telefonosxcod_call(w.pepais,w.petdoc,w.pendoc,1) TELEF_DOM,
           pq_datos_bases.fn_cl_telefonosxcod_call(w.pepais,w.petdoc,w.pendoc,3) TELEF_NEG,
           d10.aosuc,
           pq_datos_bases.fn_analista_credito(d10.aomod,d10.aosuc,d10.aomda,d10.aopap,d10.aocta,d10.aooper,d10.aosbop,d10.aotope) codase,
           'SYSADM',
           sysdate,
           1
      from (select pepais,petdoc,pendoc from JAQZ918) w
       left join fsd010 d10
         on d10.rowid = pq_datos_bases.fn_row_ultcred(w.pepais,w.petdoc,w.pendoc);
    commit;
  end sp_genera_inactivos;

  procedure sp_genera_lineas0 is
  begin
    EXECUTE IMMEDIATE 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
    EXECUTE IMMEDIATE 'truncate table JAQZ918';
    insert /*+append*/ into JAQZ918
    select /*+paralell(w,2) parallel(r8,2)*/
           distinct r8.pepais, r8.petdoc, r8.pendoc
      from (select d11.sccta aocta, d11.scoper aooper, sum(case when d11.scmod=443 then decode(d11.scmda,0,d11.scsdo,d11.scsdo*pq_datos_bases.fn_tipo_cambio_fijo(d11.scfval)) end) usa
              from fsd011 d11
             where d11.scstat <> 99
               and d11.scfvto > trunc(sysdate)
               and d11.scmod in (117,443)
             group by d11.sccta,d11.scoper) w
      join fsr008 r8
        on r8.pgcod = 1
       and r8.ctnro = w.aocta
       and r8.ttcod = 1
       and r8.cttfir = 'T'
     where nvl(w.usa,0) = 0
       and not exists (--no tienen credito judiciales, castigados, con demanda cancelados
                        select /*+PARALLEL(a,2) PARALLEL(b,2)*/
                               1 
                          from fsd010 a
                          join fsr008 b 
                            on b.pgcod = a.pgcod
                           and b.ctnro = a.aocta
                         where a.aocta <> 999999999 
                           and (a.aomod in (33,200) or --castigados, judiciales
                                a.aotope = 550 or --con demanda 
                                a.aostat in (71,66,64,23,25,22,21,33,34))--PJ
                           and a.aomod <> 120 --Prestamos pasivos
                           and b.pepais = r8.pepais
                           and b.petdoc = r8.petdoc
                           and b.pendoc = r8.pendoc
                      );
    commit;
    
    begin
        DBMS_STATS.gather_table_stats(ownname          => 'AGECOMBT',
                                      tabname          => 'JAQZ918',
                                      degree           => 4,
                                      granularity      => 'ALL',
                                      estimate_percent => dbms_stats.auto_sample_size,
                                      cascade          => TRUE);
      end;

    --Limpiamos la ejecución anterior
    delete from acdbase_temp 
     where nidebas = 1
       and nidepro = 5
       and ncoding = 1
       and ncodact = 1
       and ncodbas = 3
       and cestado = '1';
    commit;
    
    begin
        DBMS_STATS.gather_table_stats(ownname          => 'AGECOMBT',
                                      tabname          => 'ACDBASE_TEMP',
                                      degree           => 4,
                                      granularity      => 'ALL',
                                      estimate_percent => dbms_stats.auto_sample_size,
                                      cascade          => TRUE);
      end;
      
    insert /*+append*/ into acdbase_temp (nidebas,nidepro,ncoding,ncodact,ncodbas,cestado,
                                     nnumpas,ntipdoc,cnumdoc,npascon,ntipcon,cdoccon,
                                     cnombre,czonfij,cdirfij,creffij,czonneg,cdirneg,
                                     crefneg,ctelfij,ctelmov,ncodage,ncodana,cusuing,
                                     dfecing,ncodpri)
    select 1,5,1,1,3,'1',--#REVISAR TI
           w.pepais, w.petdoc, w.pendoc,
           decode((select max(r2.rpndoc) from fsr002 r2 where r2.pepais = w.pepais and r2.petdoc = w.petdoc and r2.pendoc = w.pendoc and r2.rpccyg = 66),null,null,604),
           decode((select max(r2.rpndoc) from fsr002 r2 where r2.pepais = w.pepais and r2.petdoc = w.petdoc and r2.pendoc = w.pendoc and r2.rpccyg = 66),null,null,21),
           (select max(r2.rpndoc) from fsr002 r2 where r2.pepais = w.pepais and r2.petdoc = w.petdoc and r2.pendoc = w.pendoc and r2.rpccyg = 66),
           pq_datos_bases.fn_nomcli(w.pepais, w.petdoc, w.pendoc) nomcli,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,1,'UBIG') UBIG_DOM,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,1,'DIR') DIR_DOM, 
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,1,'REF') REF_DOM,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,3,'UBIG') UBIG_NEG,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,3,'DIR') DIR_NEG,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,3,'REF') REF_NEG,
           pq_datos_bases.fn_cl_telefonosxcod_call(w.pepais,w.petdoc,w.pendoc,1) TELEF_DOM,
           pq_datos_bases.fn_cl_telefonosxcod_call(w.pepais,w.petdoc,w.pendoc,3) TELEF_NEG,
           d10.aosuc,
           pq_datos_bases.fn_analista_credito(d10.aomod,d10.aosuc,d10.aomda,d10.aopap,d10.aocta,d10.aooper,d10.aosbop,d10.aotope) codase,
           'SYSADM',
           sysdate,
           1
      from (select pepais,petdoc,pendoc from JAQZ918) w
       left join fsd010 d10
         on d10.rowid = pq_datos_bases.fn_row_ultcred(w.pepais,w.petdoc,w.pendoc);
    commit;
  end sp_genera_lineas0;

 procedure sp_genera_ampliaciones is
  begin
    EXECUTE IMMEDIATE 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
    EXECUTE IMMEDIATE 'truncate table JAQZ918';
    insert /*+append*/ into JAQZ918
    select /*+all_rows parallel(w,2)*/ w.pepais,w.petdoc,w.pendoc
      from fsh012_bi w
     where w.bcfech = trunc(sysdate-1)
       and w.n_diaatr = 0
       and ((trunc(sysdate)-bcfval)/30)>=6
       and  pq_datos_bases.CRE_FN_ATR_PROM_CLI_NUMDOC(trunc(sysdate),trunc(sysdate-185),w.pendoc)<3 --prom. días atraso < 3, últ. 6 meses
       and (nvl(pq_datos_bases.fn_cantidad_cuotas(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0) > 0 and nvl(pq_datos_bases.fn_cant_cuoxven(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0)/nvl( pq_datos_bases.fn_cantidad_cuotas(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0) < 0.5)
       and nvl(pq_datos_bases.fn_cant_cuoxven(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0)>0
       and producto not in ('CARTA FIANZA','SUPERATE MUJER','AGRÍCOLA','AGROPECUARIO','COSECHANDO',
                            'MOVITAXI', 'VEHICULAR PARA TRABAJADORES CAJA AREQUIPA', 'VEHICULAR',
                            'MOVIGAS', 'MI BAÑO', 'PARALELO', 'ADMINISTRATIVO','CREDILUZ',  
                            'PERSONAL DIRECTO PARA TRABAJADORES', 'MI VIVIENDA', 'TECHO PROPIO', 
                            'HIPOTECARIO PARA TRABAJADORES', 'ARROZ','PAPA',
                            'GANADERO','PECUARIO','PRENDARIO','PARALELO')
       and (case when producto in ('MICROPYMES','MICROPYMES PUNTUALITO') and nvl( pq_datos_bases.fn_cantidad_cuotas(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0)-nvl( pq_datos_bases.fn_cant_cuoxven(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0)>=8 then 1
                 when producto in ('CREDIOFICIOS') and not(nvl( pq_datos_bases.fn_capital_total(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0) > 0 and nvl(pq_datos_bases.fn_capdeu_cuoven(w.bcfvto,w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0)/nvl( pq_datos_bases.fn_capital_total(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0) >= 0.35) then 1
                 when producto not in ('CREDIOFICIOS','MICROPYMES','MICROPYMES PUNTUALITO') and nvl( pq_datos_bases.fn_cantidad_cuotas(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0)-nvl( pq_datos_bases.fn_cant_cuoxven(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0)>=6 then 1 --20170621 (cntcuo-cuopen)<6 then 1
                 else 0 end) = 1
       and w.bccta <> 999999999 
       and substr(w.bcrubr,1,4) in (1411,1414,1415,1416, 1421,1424,1425,1426) 
       and w.bcmod not in (33,141,107,108,116) ---Se excluye castigos, carta fianza y convenios, prendario, líneas
       and NVL(pq_datos_bases.fn_tipo_solicitud(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0) not in (4,12)--No ampliaciones
       and w.bcprod <>99
       and (select count(distinct d11.scmod||'-'||d11.scsuc||'-'||d11.scmda||'-'||d11.scpap||'-'||d11.sccta||'-'||d11.scoper||'-'||d11.scsbop||'-'||d11.sctope)
              from fsd011 d11
              join fsr008 r8
                on r8.pgcod = 1
               and r8.ctnro = d11.sccta
               and r8.ttcod = 1
               and r8.cttfir = 'T'
              join JAQZ918 li 
                on li.pepais = r8.pepais
               and li.petdoc = r8.petdoc
               and li.pendoc = r8.pendoc
             where d11.sccta <> 999999999 
               and substr(d11.scrub,1,4) in (1411,1414,1415,1416, 1421,1424,1425,1426)
               and d11.scmod not in (33,141,108/*PRENDARIO*/,29/*GARANTIAS*/,120/*P PASIVOS*/)
               and d11.scstat <> 99
               and r8.pepais = w.pepais
               and r8.petdoc = w.petdoc
               and r8.pendoc = w.pendoc) <= 2--número créditos vigentes <=2
       and not exists (--no tienen credito judiciales, castigados, con demanda cancelados
                        select /*+PARALLEL(a,2) PARALLEL(b,2)*/
                               1 
                          from fsd010 a
                          join fsr008 b 
                            on b.pgcod = a.pgcod
                           and b.ctnro = a.aocta
                         where a.aocta <> 999999999 
                           and (a.aomod in (33,200) or --castigados, judiciales
                                a.aotope = 550 or --con demanda 
                                a.aostat in (71,66,64,23,25,22,21,33,34))--PJ
                           and a.aomod <> 120 --Prestamos pasivos
                           and b.pepais = w.pepais
                           and b.petdoc = w.petdoc
                           and b.pendoc = w.pendoc
                      );
    commit;
    delete from JAQZ918 w
     where exists (--En proceso de solicitud en los últimos 15 días
                   select /*+PARALLEL(a,2) PARALLEL(b,2)*/ 1
                     FROM wfwrkitems u 
                     join (select s.wfinsprcid,min(s.wfitemid) min_wfitemid
                           from wfwrkitems s 
                           where s.wftaskcod = 3
                             and trunc(s.WFITEMINIT)>= trunc(sysdate-15)
                           group by s.wfinsprcid       
                          )m
                       on m.wfinsprcid = u.wfinsprcid
                      and m.min_wfitemid = u.wfitemid
                     join xwf700 f700 
                       on f700.xwfprcins = u.wfinsprcid 
                     join fsr008 r8
                       on r8.pgcod = f700.xwfempresa
                      and r8.ctnro = f700.xwfcuenta
                    where f700.xwfcar3 = '1'
                      and u.wftaskcod = 3
                      and r8.pepais = w.pepais
                      and r8.petdoc = w.petdoc
                      and r8.pendoc = w.pendoc);
    commit;

    begin
        DBMS_STATS.gather_table_stats(ownname          => 'AGECOMBT',
                                      tabname          => 'JAQZ918',
                                      degree           => 4,
                                      granularity      => 'ALL',
                                      estimate_percent => dbms_stats.auto_sample_size,
                                      cascade          => TRUE);
      end;

    --Limpiamos la ejecución anterior
    delete from acdbase_temp 
     where nidebas = 1
       and nidepro = 6
       and ncoding = 1
       and ncodact = 1
       and ncodbas = 2
       and cestado = '1';
    commit;

    begin
        DBMS_STATS.gather_table_stats(ownname          => 'AGECOMBT',
                                      tabname          => 'ACDBASE_TEMP',
                                      degree           => 4,
                                      granularity      => 'ALL',
                                      estimate_percent => dbms_stats.auto_sample_size,
                                      cascade          => TRUE);
      end;

    insert /*+append*/ into acdbase_temp (nidebas,nidepro,ncoding,ncodact,ncodbas,cestado,
                                          nnumpas,ntipdoc,cnumdoc,npascon,ntipcon,cdoccon,
                                          cnombre,czonfij,cdirfij,creffij,czonneg,cdirneg,
                                          crefneg,ctelfij,ctelmov,ncodage,ncodana,cusuing,
                                          dfecing,ncodpri)
    select 1,6,1,1,2,'1',--#REVISAR TI
           w.pepais, w.petdoc, w.pendoc,
           decode((select max(r2.rpndoc) from fsr002 r2 where r2.pepais = w.pepais and r2.petdoc = w.petdoc and r2.pendoc = w.pendoc and r2.rpccyg = 66),null,null,604),
           decode((select max(r2.rpndoc) from fsr002 r2 where r2.pepais = w.pepais and r2.petdoc = w.petdoc and r2.pendoc = w.pendoc and r2.rpccyg = 66),null,null,21),
           (select max(r2.rpndoc) from fsr002 r2 where r2.pepais = w.pepais and r2.petdoc = w.petdoc and r2.pendoc = w.pendoc and r2.rpccyg = 66),
           pq_datos_bases.fn_nomcli(w.pepais, w.petdoc, w.pendoc) nomcli,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,1,'UBIG') UBIG_DOM,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,1,'DIR') DIR_DOM, 
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,1,'REF') REF_DOM,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,3,'UBIG') UBIG_NEG,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,3,'DIR') DIR_NEG,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,3,'REF') REF_NEG,
           pq_datos_bases.fn_cl_telefonosxcod_call(w.pepais,w.petdoc,w.pendoc,1) TELEF_DOM,
           pq_datos_bases.fn_cl_telefonosxcod_call(w.pepais,w.petdoc,w.pendoc,3) TELEF_NEG,
           d10.aosuc,
           pq_datos_bases.fn_analista_credito(d10.aomod,d10.aosuc,d10.aomda,d10.aopap,d10.aocta,d10.aooper,d10.aosbop,d10.aotope) codase,
           'SYSADM',
           sysdate,
           1
      from (select pepais,petdoc,pendoc from JAQZ918) w
       left join fsd010 d10
         on d10.rowid = pq_datos_bases.fn_row_ultcred(w.pepais,w.petdoc,w.pendoc);
    commit;
  end sp_genera_ampliaciones;

  procedure sp_genera_inactivos_cc is
  lv_jfcall varchar2(4000);
  ln_fl number := 0;
  begin
    EXECUTE IMMEDIATE 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
    EXECUTE IMMEDIATE 'truncate table JAQZ918';
    select count(*) into ln_fl from user_indexes where index_name = 'IX_JAQZ918_1';
    if ln_fl = 1 then EXECUTE IMMEDIATE 'drop index ix_jaqz918_1'; end if;
    insert /*+append*/ into JAQZ918
    select w.pepais, w.petdoc, w.pendoc
      from (select /*+ PARALLEL(d10,10) PARALLEL(r8,10)*/
                   r8.pepais,r8.petdoc,r8.pendoc,
                   count(case when d10.aostat <> 99 then 1 end) n_CreVig,
                   max(d10.aofval) aofval
              from fsd010 d10
              join fsr008 r8
                on r8.pgcod = d10.pgcod
               and r8.ctnro = d10.aocta
             where d10.aofe99 > (sysdate-365)
               and d10.aomod in (select modulo from fst111 where dscod = 50 and modulo not in (29/*GARANTIAS*/,120/*P PASIVOS*/,108/*PRENDARIOS*/))
             group by r8.pepais,r8.petdoc,r8.pendoc) w
     where pq_datos_bases.CRE_FN_ATR_PROM_CLI_NUMDOC(trunc(w.aofval),trunc(w.aofval-185),w.pendoc)<=5
       and w.n_CreVig = 0
       and not exists ( --No creditos vigentes, como TITULAR y CONYUGE o integrante
                        select /*+PARALLEL(a,4) PARALLEL(b,4)*/
                               1 
                          from fsd011 a
                          join fsr008 b 
                            on b.pgcod = a.pgcod
                           and b.ctnro = a.sccta
                         where a.sccta <> 999999999 
                           and substr(a.scrub,1,4) in (1411,1414,1415,1416,1421,1424,1425,1426)
                           and a.scmod not in (108,141)                            
                           and b.pepais = w.pepais
                           and b.petdoc = w.petdoc
                           and b.pendoc = w.pendoc
                      );
    commit;
    EXECUTE IMMEDIATE 'create index ix_jaqz918_1 on jaqz918 (pepais,petdoc,pendoc)';
--02.10.2019
begin
  DBMS_STATS.gather_table_stats(ownname          => 'agecombt',
                                tabname          => 'JAQZ918',
                                degree           => 8,
                                granularity      => 'ALL',
                                estimate_percent => 100,
                                cascade          => TRUE);
end;
    delete from JAQZ918 w
     where exists ( --no lineas vigentes con saldo 0
                        select /*+PARALLEL(a,4) PARALLEL(b,4)*/
                               1 
                          from fsd010 a
                          join fsr008 b 
                            on b.pgcod = a.pgcod
                           and b.ctnro = a.aocta
                         where a.aomod = 117
                           and a.aostat <> 99    
                           and b.pepais = w.pepais
                           and b.petdoc = w.petdoc
                           and b.pendoc = w.pendoc
                      );
    commit;
    delete from JAQZ918 w
     where exists ( --no tienen credito judiciales, castigados, con demanda cancelados
                    select /*+PARALLEL(a,4) PARALLEL(b,4)*/
                           1 
                      from fsd010 a
                      join fsr008 b 
                        on b.pgcod = a.pgcod
                       and b.ctnro = a.aocta
                     where a.aocta <> 999999999 
                       and (a.aomod in (33,200) or --castigados, judiciales
                            a.aotope = 550 or --con demanda 
                            a.aostat in (71,66,64,23,25,22,21,33,34))--PJ
                       and a.aomod <> 120 --Prestamos pasivos
                       and b.pepais = w.pepais
                       and b.petdoc = w.petdoc
                       and b.pendoc = w.pendoc
                  );
    commit;
    delete from JAQZ918 w
     where exists (--En proceso de solicitud en los últimos 15 días
                   select /*+PARALLEL(a,4) PARALLEL(b,4)*/ 1
                     FROM wfwrkitems u 
                     join (select s.wfinsprcid,min(s.wfitemid) min_wfitemid
                           from wfwrkitems s 
                           where s.wftaskcod = 3
                             and trunc(s.WFITEMINIT)>= trunc(sysdate-15)
                           group by s.wfinsprcid       
                          )m
                       on m.wfinsprcid = u.wfinsprcid
                      and m.min_wfitemid = u.wfitemid
                     join xwf700 f700 
                       on f700.xwfprcins = u.wfinsprcid 
                     join fsr008 r8
                       on r8.pgcod = f700.xwfempresa
                      and r8.ctnro = f700.xwfcuenta
                    where f700.xwfcar3 = '1'
                      and u.wftaskcod = 3
                      and r8.pepais = w.pepais
                      and r8.petdoc = w.petdoc
                      and r8.pendoc = w.pendoc);
    commit;
    delete from JAQZ918 w
     where exists (select /*+PARALLEL(a,4)*/
                          1 --Que se encuentren en gestión por otro usuario (De actividad 1/4 que no sean bases de ana)
                     from (select nindcier, ncodact, ncodbas, npaicli, ntipdoc, cnumdoc from acdeval
                           union
                           select nindcier, ncodact, ncodbas, npaicli, ntipdoc, cnumdoc from acheval) a
                    where a.nindcier ='0' 
                      and (case when a.ncodact = 1 
                                 and a.ncodbas in (1,2,3) then 0
                                else 1 end)=1
                      and a.npaicli = w.pepais
                      and a.ntipdoc = w.petdoc
                      and rpad(a.cnumdoc,12) = w.pendoc);
    commit;
    delete from JAQZ918 w
     where exists (select /*+PARALLEL(x,4)*/
                          1 --Que tengan teléfonos erróneos o no existan
                     from (select npaicli,ntipdoc,cnumdoc,nrespue from acdrevi
                           union
                           select npaicli,ntipdoc,cnumdoc,nrespue from achrevi) x
                    where x.nrespue = 116
                      and x.npaicli = w.pepais
                      and x.ntipdoc = w.petdoc
                      and rpad(x.cnumdoc,12) = w.pendoc);
    commit;
	delete from JAQZ918 w --Quienes hayan tenido la respuesta "R- NO CONTESTÓ / NO ENCONTRADO" en más de una fecha. 20180416
	 where (w.pepais,w.petdoc,w.pendoc) in (select e.npaicli,e.ntipdoc,rpad(e.cnumdoc,12) 
											  from (select /*+parallel(x,4) parallel(z,4)*/
											 			   x.npaicli,x.ntipdoc,x.cnumdoc
										 			  from (select ncorage,npaicli,ntipdoc,cnumdoc,nrespue,dfecvis from acdrevi
															 union
														    select ncorage,npaicli,ntipdoc,cnumdoc,nrespue,dfecvis from achrevi) x
													  join JAQZ918 z
													    on z.pepais = x.npaicli
													   and z.petdoc = x.ntipdoc
													   and z.pendoc = rpad(x.cnumdoc,12)
													 where x.nrespue = 87
													 group by x.npaicli,x.ntipdoc,x.cnumdoc,x.dfecvis) e
											 group by e.npaicli,e.ntipdoc,e.cnumdoc
										    having count(*)>1);
    commit;
    delete from JAQZ918 w
     where exists (select /*+PARALLEL(x,4)*/
                          1 --Retirar clientes en lista negra migrada de AC1
                     from JAQZ919 x
                    where rpad(x.JAQZ919numdoc,12) = w.pendoc);
    commit;
    delete from JAQZ918 w
     where exists (select /*+PARALLEL(d2,4)*/ 
                          1 --Retirar clientes con >= 70 años
                     from fsd002 d2
                    where d2.pfpais = w.pepais
                      and d2.pftdoc = w.petdoc
                      and d2.pfndoc = w.pendoc
                      and (trunc(sysdate)-d2.pffnac)/360 >= 70);
    commit;
    select count(*) into ln_fl from user_indexes where index_name = 'IX_JAQZ918_1';
    if ln_fl = 1 then EXECUTE IMMEDIATE 'drop index ix_jaqz918_1'; end if;
    begin
        DBMS_STATS.gather_table_stats(ownname          => 'AGECOMBT',
                                      tabname          => 'JAQZ918',
                                      degree           => 4,
                                      granularity      => 'ALL',
                                      estimate_percent => dbms_stats.auto_sample_size,
                                      cascade          => TRUE);
      end;
    --Limpiamos la ejecución anterior
    delete from acdbase_temp 
     where nidebas = 1
       and nidepro = 4
       and ncoding = 1
       and ncodact = 4
       and ncodbas = 1
       and cestado = '1';
    commit;
    
    begin
        DBMS_STATS.gather_table_stats(ownname          => 'AGECOMBT',
                                      tabname          => 'ACDBASE_TEMP',
                                      degree           => 4,
                                      granularity      => 'ALL',
                                      estimate_percent => dbms_stats.auto_sample_size,
                                      cascade          => TRUE);
      end;
	
	--Jefe Call Center
    select jf 
      into lv_jfcall
      from (select ccodjef jf , count(*) ct
              from acmoper
             where ccodcar = 107
               and ccodest = 1
             group by ccodjef
             order by ct desc)
     where rownum = 1;
	
    insert /*+append*/ into acdbase_temp (nidebas,nidepro,ncoding,ncodact,ncodbas,cestado,
                                          nnumpas,ntipdoc,cnumdoc,npascon,ntipcon,cdoccon,
                                          cnombre,czonfij,cdirfij,creffij,czonneg,cdirneg,
                                          crefneg,ctelfij,ctelmov,ncodage,ncodana,cusuing,
                                          dfecing,ncodpri)
    select 1,4,1,4,1,'1',--#REVISAR TI
           w.pepais, w.petdoc, w.pendoc,
           decode((select max(r2.rpndoc) from fsr002 r2 where r2.pepais = w.pepais and r2.petdoc = w.petdoc and r2.pendoc = w.pendoc and r2.rpccyg = 66),null,null,604),
           decode((select max(r2.rpndoc) from fsr002 r2 where r2.pepais = w.pepais and r2.petdoc = w.petdoc and r2.pendoc = w.pendoc and r2.rpccyg = 66),null,null,21),
           (select max(r2.rpndoc) from fsr002 r2 where r2.pepais = w.pepais and r2.petdoc = w.petdoc and r2.pendoc = w.pendoc and r2.rpccyg = 66),
           pq_datos_bases.fn_nomcli(w.pepais, w.petdoc, w.pendoc) nomcli,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,1,'UBIG') UBIG_DOM,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,1,'DIR') DIR_DOM, 
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,1,'REF') REF_DOM,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,3,'UBIG') UBIG_NEG,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,3,'DIR') DIR_NEG,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,3,'REF') REF_NEG,
           pq_datos_bases.fn_cl_telefonosxcod_call(w.pepais,w.petdoc,w.pendoc,1) TELEF_DOM,
           pq_datos_bases.fn_cl_telefonosxcod_call(w.pepais,w.petdoc,w.pendoc,3) TELEF_NEG,
           d10.aosuc,
		       lv_jfcall,
           'SYSADM',
           sysdate,
           1
      from (select pepais,petdoc,pendoc from JAQZ918) w
       left join fsd010 d10
         on d10.rowid = pq_datos_bases.fn_row_ultcred(w.pepais,w.petdoc,w.pendoc);
    commit;
    --Retirar clientes sin teléfono
    delete from acdbase_temp w
     where length(trim(nvl(ctelfij,0))) < 6 
       and length(trim(nvl(ctelmov,0))) < 6
       and nidebas = 1
       and nidepro = 4
       and ncoding = 1
       and ncodact = 4
       and ncodbas = 1
       and cestado = '1';
    commit;
    
	  --Inactivos: 900 x 8 (Promotoras) x 1.05 (5% más por mala calificación) = 7560
    --Retirar exceso de clientes para call (no más de 8k)
    delete from acdbase_temp w
     where rownum <= (select greatest(count(*)-8000,0) from acdbase_temp  where ncodact = 4 and ncodbas = 1)
       and nidebas = 1
       and nidepro = 4
       and ncoding = 1
       and ncodact = 4
       and ncodbas = 1
       and cestado = '1';
    commit;
  end sp_genera_inactivos_cc;

  procedure sp_genera_lineas0_cc is
  lv_jfcall varchar2(4000);
  ln_fl number := 0;
  begin
    EXECUTE IMMEDIATE 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
    EXECUTE IMMEDIATE 'truncate table JAQZ918';
    select count(*) into ln_fl from user_indexes where index_name = 'IX_JAQZ918_1';
    if ln_fl = 1 then EXECUTE IMMEDIATE 'drop index ix_jaqz918_1'; end if;
    insert /*+append*/ into JAQZ918
    select /*+paralell(w,10) parallel(r8,10)*/
           distinct r8.pepais, r8.petdoc, r8.pendoc
      from fsd011 d11
      join fsr008 r8
        on r8.pgcod = 1
       and r8.ctnro = d11.sccta
       and r8.ttcod = 1
       and r8.cttfir = 'T'
     where d11.scmod = 117
       and d11.scstat = 0
       and not exists (--no tiene saldo usado en la línea
                       select /*+PARALLEL(x,10)*/
                              1 
                         from fsd011 x 
                        where x.scmod = 443 
                          and x.scstat = 0
                          and abs(scsdo) > 0
                          and x.sccta = d11.sccta 
                          and x.scoper = d11.scoper);
     commit;
    EXECUTE IMMEDIATE 'create index ix_jaqz918_1 on jaqz918 (pepais,petdoc,pendoc)';
    
--02.10.2019
begin
  DBMS_STATS.gather_table_stats(ownname          => 'agecombt',
                                tabname          => 'JAQZ918',
                                degree           => 8,
                                granularity      => 'ALL',
                                estimate_percent => 100,
                                cascade          => TRUE);
end;    
    
    delete from JAQZ918 w
     where exists ( --no tienen credito judiciales, castigados, con demanda cancelados
                    select /*+PARALLEL(a,4) PARALLEL(b,4)*/
                           1 
                      from fsd010 a
                      join fsr008 b 
                        on b.pgcod = a.pgcod
                       and b.ctnro = a.aocta
                     where a.aocta <> 999999999 
                       and (a.aomod in (33,200) or --castigados, judiciales
                            a.aotope = 550 or --con demanda 
                            a.aostat in (71,66,64,23,25,22,21,33,34))--PJ
                       and a.aomod <> 120 --Prestamos pasivos
                       and b.pepais = w.pepais
                       and b.petdoc = w.petdoc
                       and b.pendoc = w.pendoc
                  );
    commit;
    delete from JAQZ918 w
     where exists (select /*+PARALLEL(a,4)*/
                          1 --Que se encuentren en gestión por otro usuario (De actividad 1/4 que no sean bases de ana)
                     from (select nindcier, ncodact, ncodbas, npaicli, ntipdoc, cnumdoc from acdeval
                           union
                           select nindcier, ncodact, ncodbas, npaicli, ntipdoc, cnumdoc from acheval) a
                    where a.nindcier ='0' 
                      and (case when a.ncodact = 1 
                                 and a.ncodbas in (1,2,3) then 0
                                else 1 end)=1
                      and a.npaicli = w.pepais
                      and a.ntipdoc = w.petdoc
                      and rpad(a.cnumdoc,12) = w.pendoc);
    commit;
    delete from JAQZ918 w
     where exists (select /*+PARALLEL(x,4)*/
                          1 --Que tengan teléfonos erróneos o no existan
                     from (select npaicli,ntipdoc,cnumdoc,nrespue from acdrevi
                           union
                           select npaicli,ntipdoc,cnumdoc,nrespue from achrevi) x
                    where x.nrespue = 116
                      and x.npaicli = w.pepais
                      and x.ntipdoc = w.petdoc
                      and rpad(x.cnumdoc,12) = w.pendoc);
    commit;
	delete from JAQZ918 w --Quienes hayan tenido la respuesta "R- NO CONTESTÓ / NO ENCONTRADO" en más de una fecha. 20180416
	 where (w.pepais,w.petdoc,w.pendoc) in (select e.npaicli,e.ntipdoc,rpad(e.cnumdoc,12) 
											  from (select /*+parallel(x,4) parallel(z,4)*/
											 			   x.npaicli,x.ntipdoc,x.cnumdoc
										 			  from (select ncorage,npaicli,ntipdoc,cnumdoc,nrespue,dfecvis from acdrevi
															 union
														    select ncorage,npaicli,ntipdoc,cnumdoc,nrespue,dfecvis from achrevi) x
													  join JAQZ918 z
													    on z.pepais = x.npaicli
													   and z.petdoc = x.ntipdoc
													   and z.pendoc = rpad(x.cnumdoc,12)
													 where x.nrespue = 87
													 group by x.npaicli,x.ntipdoc,x.cnumdoc,x.dfecvis) e
											 group by e.npaicli,e.ntipdoc,e.cnumdoc
										    having count(*)>1);
    commit;
    delete from JAQZ918 w
     where exists (select /*+PARALLEL(x,4)*/
                          1 --Retirar clientes en lista negra migrada de AC1
                     from JAQZ919 x
                    where rpad(x.jaqz919numdoc,12) = w.pendoc);
    commit;
    delete from JAQZ918 w
     where exists (select /*+PARALLEL(d2,4)*/ 
                          1 --Retirar clientes con >= 70 años
                     from fsd002 d2
                    where d2.pfpais = w.pepais
                      and d2.pftdoc = w.petdoc
                      and d2.pfndoc = w.pendoc
                      and (trunc(sysdate)-d2.pffnac)/360 >= 70);
    commit;
    select count(*) into ln_fl from user_indexes where index_name = 'IX_JAQZ918_1';
    if ln_fl = 1 then EXECUTE IMMEDIATE 'drop index ix_jaqz918_1'; end if;
    begin
        DBMS_STATS.gather_table_stats(ownname          => 'AGECOMBT',
                                      tabname          => 'JAQZ918',
                                      degree           => 4,
                                      granularity      => 'ALL',
                                      estimate_percent => dbms_stats.auto_sample_size,
                                      cascade          => TRUE);
      end;

    --Limpiamos la ejecución anterior
    delete from acdbase_temp 
     where nidebas = 1
       and nidepro = 5
       and ncoding = 1
       and ncodact = 4
       and ncodbas = 2
       and cestado = '1';
    commit;
    
    begin
        DBMS_STATS.gather_table_stats(ownname          => 'AGECOMBT',
                                      tabname          => 'ACDBASE_TEMP',
                                      degree           => 4,
                                      granularity      => 'ALL',
                                      estimate_percent => dbms_stats.auto_sample_size,
                                      cascade          => TRUE);
      end;
	
	--Jefe Call Center
    select jf 
      into lv_jfcall
      from (select ccodjef jf , count(*) ct
              from acmoper
             where ccodcar = 107
               and ccodest = 1
             group by ccodjef
             order by ct desc)
     where rownum = 1;
	
    insert /*+append*/ into acdbase_temp (nidebas,nidepro,ncoding,ncodact,ncodbas,cestado,
                                     nnumpas,ntipdoc,cnumdoc,npascon,ntipcon,cdoccon,
                                     cnombre,czonfij,cdirfij,creffij,czonneg,cdirneg,
                                     crefneg,ctelfij,ctelmov,ncodage,ncodana,cusuing,
                                     dfecing,ncodpri)
    select 1,5,1,4,2,'1',--#REVISAR TI
           w.pepais, w.petdoc, w.pendoc,
           decode((select max(r2.rpndoc) from fsr002 r2 where r2.pepais = w.pepais and r2.petdoc = w.petdoc and r2.pendoc = w.pendoc and r2.rpccyg = 66),null,null,604),
           decode((select max(r2.rpndoc) from fsr002 r2 where r2.pepais = w.pepais and r2.petdoc = w.petdoc and r2.pendoc = w.pendoc and r2.rpccyg = 66),null,null,21),
           (select max(r2.rpndoc) from fsr002 r2 where r2.pepais = w.pepais and r2.petdoc = w.petdoc and r2.pendoc = w.pendoc and r2.rpccyg = 66),
           pq_datos_bases.fn_nomcli(w.pepais, w.petdoc, w.pendoc) nomcli,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,1,'UBIG') UBIG_DOM,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,1,'DIR') DIR_DOM, 
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,1,'REF') REF_DOM,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,3,'UBIG') UBIG_NEG,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,3,'DIR') DIR_NEG,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,3,'REF') REF_NEG,
           pq_datos_bases.fn_cl_telefonosxcod_call(w.pepais,w.petdoc,w.pendoc,1) TELEF_DOM,
           pq_datos_bases.fn_cl_telefonosxcod_call(w.pepais,w.petdoc,w.pendoc,3) TELEF_NEG,
           d10.aosuc,
		       lv_jfcall,
           'SYSADM',
           sysdate,
           1
      from (select pepais,petdoc,pendoc from JAQZ918) w
       left join fsd010 d10
         on d10.rowid = pq_datos_bases.fn_row_ultcred(w.pepais,w.petdoc,w.pendoc);
    commit;
    --Retirar clientes sin teléfono
    delete from acdbase_temp w
     where length(trim(nvl(ctelfij,0))) < 6 
       and length(trim(nvl(ctelmov,0))) < 6
       and nidebas = 1
       and nidepro = 5
       and ncoding = 1
       and ncodact = 4
       and ncodbas = 2
       and cestado = '1';
    commit;
    
	  --Líneas: 200 x 8 (Promotoras) x 1.05 (5% más por mala calificación) = 1680
    --Retirar exceso de clientes para call (no más de 3k)
    delete from acdbase_temp w
     where rownum <= (select greatest(count(*)-3000,0) from acdbase_temp where ncodact = 4 and ncodbas = 2)
       and nidebas = 1
       and nidepro = 5
       and ncoding = 1
       and ncodact = 4
       and ncodbas = 2
       and cestado = '1';
    commit;
  end sp_genera_lineas0_cc;

  procedure sp_genera_ampliaciones_cc is
  lv_jfcall varchar2(4000);
  ln_fl number :=0;
  begin
    EXECUTE IMMEDIATE 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
    EXECUTE IMMEDIATE 'truncate table JAQZ918';
    select count(*) into ln_fl from user_indexes where index_name = 'IX_JAQZ918_1';
    if ln_fl = 1 then EXECUTE IMMEDIATE 'drop index ix_jaqz918_1'; end if;
    insert /*+append*/ into JAQZ918
    select /*+all_rows parallel(w,10)*/ w.pepais,w.petdoc,w.pendoc
      from fsh012_bi w
     where w.bcfech = trunc(sysdate-1)
       and w.n_diaatr = 0
       and ((trunc(sysdate)-bcfval)/30)>=6
       and pq_datos_bases.CRE_FN_ATR_PROM_CLI_NUMDOC(trunc(sysdate),trunc(sysdate-185),w.pendoc)<=5 --prom. días atraso < 5, últ. 6 meses
       and producto not in ('CARTA FIANZA','SUPERATE MUJER','AGRÍCOLA','AGROPECUARIO','COSECHANDO','MOVITAXI', 'VEHICULAR PARA TRABAJADORES CAJA AREQUIPA', 
                            'VEHICULAR','MOVIGAS', 'MI BAÑO', 'PARALELO', 'ADMINISTRATIVO','CREDILUZ','PERSONAL DIRECTO PARA TRABAJADORES', 'MI VIVIENDA', 
                            'TECHO PROPIO', 'HIPOTECARIO PARA TRABAJADORES', 'ARROZ','PAPA','GANADERO','PECUARIO','PRENDARIO','PARALELO')
       and (case when producto in ('MICROPYMES','MICROPYMES PUNTUALITO') 
                  and nvl(pq_datos_bases.fn_cantidad_cuotas(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0)
                     -nvl(pq_datos_bases.fn_cant_cuoxven(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0)
                     >=8 then 1 --que hayan pagado por lo menos 8 cuotas del total
                 when producto in ('CREDIOFICIOS') 
                  and nvl(pq_datos_bases.fn_capital_total(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0) > 0
                  and nvl(pq_datos_bases.fn_capdeu_cuoven(w.bcfvto,w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0)
                     /nvl(pq_datos_bases.fn_capital_total(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0) 
                     <=0.3 then 1 --que quede pendiente por pagar <=30% del saldo
                 when producto not in ('CREDIOFICIOS','MICROPYMES','MICROPYMES PUNTUALITO') 
                  and nvl(pq_datos_bases.fn_cantidad_cuotas(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0)
                     -nvl(pq_datos_bases.fn_cant_cuoxven(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0)
                     >=5 then 1 --que hayan pagado por lo menos 5 cuotas del total
                 when nvl(pq_datos_bases.fn_cantidad_cuotas(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0) > 0 
                  and nvl(pq_datos_bases.fn_cant_cuoxven(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0)
                     /nvl(pq_datos_bases.fn_cantidad_cuotas(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0) 
                     <0.5 then 1 --que queden pendientes como máximo el 50% de las cuotas
                 else 0 end) = 1
       and w.bccta <> 999999999 
       and substr(w.bcrubr,1,4) in (1411,1414,1415,1416, 1421,1424,1425,1426) 
       and w.bcmod not in (33,141,107,108,116) ---Se excluye castigos, carta fianza, convenios, prendario, líneas
       and NVL(pq_datos_bases.fn_tipo_solicitud(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0) not in (4,12)--No ampliaciones
       and w.bcprod <>99;
    commit;
    EXECUTE IMMEDIATE 'create index ix_jaqz918_1 on jaqz918 (pepais,petdoc,pendoc)';

--02.10.2019
begin
  DBMS_STATS.gather_table_stats(ownname          => 'agecombt',
                                tabname          => 'JAQZ918',
                                degree           => 8,
                                granularity      => 'ALL',
                                estimate_percent => 100,
                                cascade          => TRUE);
end;

    delete from JAQZ918 w 
     where (--número créditos vigentes <=2
            select /*+PARALLEL(d11,4) PARALLEL(r8,4)*/
                   count(distinct d11.scmod||'-'||d11.scsuc||'-'||d11.scmda||'-'||d11.scpap||'-'||d11.sccta||'-'||d11.scoper||'-'||d11.scsbop||'-'||d11.sctope)
              from fsd011 d11
              join fsr008 r8
                on r8.pgcod  = d11.pgcod
               and r8.ctnro  = d11.sccta
               and r8.ttcod  = 1
               and r8.cttfir = 'T'
             where d11.sccta <> 999999999 
               and substr(d11.scrub,1,4) in (1411,1414,1415,1416, 1421,1424,1425,1426)
               and d11.scmod not in (33,141,108/*PRENDARIO*/,29/*GARANTIAS*/,120/*P PASIVOS*/)
               and d11.scstat <> 99
               and r8.pepais = w.pepais
               and r8.petdoc = w.petdoc
               and r8.pendoc = w.pendoc) > 2;
    commit;
    delete from JAQZ918 w 
     where exists (--no tienen credito judiciales, castigados, con demanda cancelados
                    select /*+PARALLEL(d10,4) PARALLEL(r8,4)*/ 1 
                      from fsd010 d10
                      join fsr008 r8
                        on r8.pgcod  = d10.pgcod
                       and r8.ctnro  = d10.aocta
                     where d10.aocta <> 999999999 
                       and (d10.aomod in (33,200) or --castigados, judiciales
                            d10.aotope = 550 or --con demanda 
                            d10.aostat in (71,66,64,23,25,22,21,33,34))--PJ
                       and d10.aomod <> 120
                       and r8.pepais = w.pepais
                       and r8.petdoc = w.petdoc
                       and r8.pendoc = w.pendoc);--Prestamos pasivos
    commit;
    delete from JAQZ918 w
     where exists (--En proceso de solicitud en los últimos 15 días
                   select /*+PARALLEL(u,4) PARALLEL(f700,4) PARALLEL(r8,4)*/ 1
                     FROM wfwrkitems u 
                     join (select /*+PARALLEL(s,4)*/
                                  s.wfinsprcid,min(s.wfitemid) min_wfitemid
                             from wfwrkitems s 
                            where s.wftaskcod = 3
                              and trunc(s.WFITEMINIT)>= trunc(sysdate-15)
                           group by s.wfinsprcid       
                          )m
                       on m.wfinsprcid = u.wfinsprcid
                      and m.min_wfitemid = u.wfitemid
                     join xwf700 f700 
                       on f700.xwfprcins = u.wfinsprcid 
                     join fsr008 r8
                       on r8.pgcod = f700.xwfempresa
                      and r8.ctnro = f700.xwfcuenta
                    where f700.xwfcar3 = '1'
                      and u.wftaskcod = 3
                      and r8.pepais = w.pepais
                      and r8.petdoc = w.petdoc
                      and r8.pendoc = w.pendoc);
    commit;
    delete from JAQZ918 w
     where exists (select /*+PARALLEL(a,4)*/
                          1 --Que se encuentren en gestión por otro usuario (De actividad 1/4 que no sean bases de ana)
                     from (select nindcier, ncodact, ncodbas, npaicli, ntipdoc, cnumdoc from acdeval
                           union
                           select nindcier, ncodact, ncodbas, npaicli, ntipdoc, cnumdoc from acheval) a
                    where a.nindcier ='0' 
                      and (case when a.ncodact = 1 
                                 and a.ncodbas in (1,2,3) then 0
                                else 1 end)=1
                      and a.npaicli = w.pepais
                      and a.ntipdoc = w.petdoc
                      and rpad(a.cnumdoc,12) = w.pendoc);
    commit;
    delete from JAQZ918 w
     where exists (select /*+PARALLEL(x,4)*/
                          1 --Que tengan teléfonos erróneos o no existan
                     from (select npaicli,ntipdoc,cnumdoc,nrespue from acdrevi
                           union
                           select npaicli,ntipdoc,cnumdoc,nrespue from achrevi) x
                    where x.nrespue = 116
                      and x.npaicli = w.pepais
                      and x.ntipdoc = w.petdoc
                      and rpad(x.cnumdoc,12) = w.pendoc);
    commit;
	delete from JAQZ918 w --Quienes hayan tenido la respuesta "R- NO CONTESTÓ / NO ENCONTRADO" en más de una fecha. 20180416
	 where (w.pepais,w.petdoc,w.pendoc) in (select e.npaicli,e.ntipdoc,rpad(e.cnumdoc,12) 
											  from (select /*+parallel(x,4) parallel(z,4)*/
											 			   x.npaicli,x.ntipdoc,x.cnumdoc
										 			  from (select ncorage,npaicli,ntipdoc,cnumdoc,nrespue,dfecvis from acdrevi
															 union
														    select ncorage,npaicli,ntipdoc,cnumdoc,nrespue,dfecvis from achrevi) x
													  join JAQZ918 z
													    on z.pepais = x.npaicli
													   and z.petdoc = x.ntipdoc
													   and z.pendoc = rpad(x.cnumdoc,12)
													 where x.nrespue = 87
													 group by x.npaicli,x.ntipdoc,x.cnumdoc,x.dfecvis) e
											 group by e.npaicli,e.ntipdoc,e.cnumdoc
										    having count(*)>1);
    commit;
    delete from JAQZ918 w
     where exists (select /*+PARALLEL(x,4)*/
                          1 --Retirar clientes en lista negra migrada de AC1
                     from JAQZ919 x
                    where rpad(x.jaqz919numdoc,12) = w.pendoc);
    commit;
    delete from JAQZ918 w
     where exists (select /*+PARALLEL(d2,4)*/ 
                          1 --Retirar clientes con >= 70 años
                     from fsd002 d2
                    where d2.pfpais = w.pepais
                      and d2.pftdoc = w.petdoc
                      and d2.pfndoc = w.pendoc
                      and (trunc(sysdate)-d2.pffnac)/360 >= 70);
    commit;
    select count(*) into ln_fl from user_indexes where index_name = 'IX_JAQZ918_1';
    if ln_fl = 1 then EXECUTE IMMEDIATE 'drop index ix_jaqz918_1'; end if;
    
    begin
        DBMS_STATS.gather_table_stats(ownname          => 'AGECOMBT',
                                      tabname          => 'JAQZ918',
                                      degree           => 4,
                                      granularity      => 'ALL',
                                      estimate_percent => dbms_stats.auto_sample_size,
                                      cascade          => TRUE);
      end;

    --Limpiamos la ejecución anterior
    delete from acdbase_temp 
     where nidebas = 1
       and nidepro = 7
       and ncoding = 1
       and ncodact = 4
       and ncodbas = 3
       and cestado = '1';
    commit;

    begin
        DBMS_STATS.gather_table_stats(ownname          => 'AGECOMBT',
                                      tabname          => 'ACDBASE_TEMP',
                                      degree           => 4,
                                      granularity      => 'ALL',
                                      estimate_percent => dbms_stats.auto_sample_size,
                                      cascade          => TRUE);
      end;
	
    --Jefe Call Center
    select jf 
      into lv_jfcall
      from (select ccodjef jf , count(*) ct
              from acmoper
             where ccodcar = 107
               and ccodest = 1
             group by ccodjef
             order by ct desc)
     where rownum = 1;
	
    insert /*+append*/ into acdbase_temp (nidebas,nidepro,ncoding,ncodact,ncodbas,cestado,
                                          nnumpas,ntipdoc,cnumdoc,npascon,ntipcon,cdoccon,
                                          cnombre,czonfij,cdirfij,creffij,czonneg,cdirneg,
                                          crefneg,ctelfij,ctelmov,ncodage,ncodana,cusuing,
                                          dfecing,ncodpri)
    select 1,7,1,4,3,'1',--#REVISAR TI
           w.pepais, w.petdoc, w.pendoc,
           decode((select max(r2.rpndoc) from fsr002 r2 where r2.pepais = w.pepais and r2.petdoc = w.petdoc and r2.pendoc = w.pendoc and r2.rpccyg = 66),null,null,604),
           decode((select max(r2.rpndoc) from fsr002 r2 where r2.pepais = w.pepais and r2.petdoc = w.petdoc and r2.pendoc = w.pendoc and r2.rpccyg = 66),null,null,21),
           (select max(r2.rpndoc) from fsr002 r2 where r2.pepais = w.pepais and r2.petdoc = w.petdoc and r2.pendoc = w.pendoc and r2.rpccyg = 66),
           pq_datos_bases.fn_nomcli(w.pepais, w.petdoc, w.pendoc) nomcli,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,1,'UBIG') UBIG_DOM,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,1,'DIR') DIR_DOM, 
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,1,'REF') REF_DOM,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,3,'UBIG') UBIG_NEG,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,3,'DIR') DIR_NEG,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,3,'REF') REF_NEG,
           pq_datos_bases.fn_cl_telefonosxcod_call(w.pepais,w.petdoc,w.pendoc,1) TELEF_DOM,
           pq_datos_bases.fn_cl_telefonosxcod_call(w.pepais,w.petdoc,w.pendoc,3) TELEF_NEG,
           d10.aosuc,
		       lv_jfcall,
           'SYSADM',
           sysdate,
           1
      from (select pepais,petdoc,pendoc from JAQZ918) w
       left join fsd010 d10
         on d10.rowid = pq_datos_bases.fn_row_ultcred(w.pepais,w.petdoc,w.pendoc);
    commit;

    --Retirar clientes sin teléfono
    delete from acdbase_temp w
     where length(trim(nvl(ctelfij,0))) < 6 
       and length(trim(nvl(ctelmov,0))) < 6
       and nidebas = 1
       and nidepro = 7
       and ncoding = 1
       and ncodact = 4
       and ncodbas = 3
       and cestado = '1';
    commit;
    
	  --Ampliaciones: 1700 x 8 (Promotoras) x 1.05 (5% más por mala calificación) = 14280
    --Retirar exceso de clientes para call (no más de 16k)
    delete from acdbase_temp w
     where rownum <= (select greatest(count(*)-16000,0) from acdbase_temp  where ncodact = 4 and ncodbas = 3)
       and nidebas = 1
       and nidepro = 7
       and ncoding = 1
       and ncodact = 4
       and ncodbas = 3
       and cestado = '1';
    commit;

  end sp_genera_ampliaciones_cc;

  procedure sp_genera_inactivos_cc_ext is
  lv_jfcall varchar2(4000);
  ln_fl number := 0;
  begin
    EXECUTE IMMEDIATE 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
    EXECUTE IMMEDIATE 'truncate table JAQZ918';
    select count(*) into ln_fl from user_indexes where index_name = 'IX_JAQZ918_1';
    if ln_fl = 1 then EXECUTE IMMEDIATE 'drop index ix_jaqz918_1'; end if;
    insert /*+append*/ into JAQZ918
    select w.pepais, w.petdoc, w.pendoc
      from (select /*+ PARALLEL(d10,10) PARALLEL(r8,10)*/
                   r8.pepais,r8.petdoc,r8.pendoc,
                   count(case when d10.aostat <> 99 then 1 end) n_CreVig,
                   max(d10.aofval) aofval
              from fsd010 d10
              join fsr008 r8
                on r8.pgcod = d10.pgcod
               and r8.ctnro = d10.aocta
             where d10.aofe99 > (sysdate-365)
               and d10.aomod in (select modulo from fst111 where dscod = 50 and modulo not in (29/*GARANTIAS*/,120/*P PASIVOS*/,108/*PRENDARIOS*/))
             group by r8.pepais,r8.petdoc,r8.pendoc) w
     where pq_datos_bases.CRE_FN_ATR_PROM_CLI_NUMDOC(trunc(w.aofval),trunc(w.aofval-185),w.pendoc)<=5
       and w.n_CreVig = 0
       and not exists ( --No creditos vigentes, como TITULAR y CONYUGE o integrante
                        select /*+PARALLEL(a,4) PARALLEL(b,4)*/
                               1 
                          from fsd011 a
                          join fsr008 b 
                            on b.pgcod = a.pgcod
                           and b.ctnro = a.sccta
                         where a.sccta <> 999999999 
                           and substr(a.scrub,1,4) in (1411,1414,1415,1416,1421,1424,1425,1426)
                           and a.scmod not in (108,141)                            
                           and b.pepais = w.pepais
                           and b.petdoc = w.petdoc
                           and b.pendoc = w.pendoc
                      );
    commit;
    EXECUTE IMMEDIATE 'create index ix_jaqz918_1 on jaqz918 (pepais,petdoc,pendoc)';
    
--02.10.2019
begin
  DBMS_STATS.gather_table_stats(ownname          => 'agecombt',
                                tabname          => 'JAQZ918',
                                degree           => 8,
                                granularity      => 'ALL',
                                estimate_percent => 100,
                                cascade          => TRUE);
end;    
    delete from JAQZ918 w
     where exists ( --no lineas vigentes con saldo 0
                        select /*+PARALLEL(a,4) PARALLEL(b,4)*/
                               1 
                          from fsd010 a
                          join fsr008 b 
                            on b.pgcod = a.pgcod
                           and b.ctnro = a.aocta
                         where a.aomod = 117
                           and a.aostat <> 99    
                           and b.pepais = w.pepais
                           and b.petdoc = w.petdoc
                           and b.pendoc = w.pendoc
                      );
    commit;
    delete from JAQZ918 w
     where exists ( --no tienen credito judiciales, castigados, con demanda cancelados
                    select /*+PARALLEL(a,4) PARALLEL(b,4)*/
                           1 
                      from fsd010 a
                      join fsr008 b 
                        on b.pgcod = a.pgcod
                       and b.ctnro = a.aocta
                     where a.aocta <> 999999999 
                       and (a.aomod in (33,200) or --castigados, judiciales
                            a.aotope = 550 or --con demanda 
                            a.aostat in (71,66,64,23,25,22,21,33,34))--PJ
                       and a.aomod <> 120 --Prestamos pasivos
                       and b.pepais = w.pepais
                       and b.petdoc = w.petdoc
                       and b.pendoc = w.pendoc
                  );
    commit;
    delete from JAQZ918 w
     where exists (--En proceso de solicitud en los últimos 15 días
                   select /*+PARALLEL(a,4) PARALLEL(b,4)*/ 1
                     FROM wfwrkitems u 
                     join (select s.wfinsprcid,min(s.wfitemid) min_wfitemid
                           from wfwrkitems s 
                           where s.wftaskcod = 3
                             and trunc(s.WFITEMINIT)>= trunc(sysdate-15)
                           group by s.wfinsprcid       
                          )m
                       on m.wfinsprcid = u.wfinsprcid
                      and m.min_wfitemid = u.wfitemid
                     join xwf700 f700 
                       on f700.xwfprcins = u.wfinsprcid 
                     join fsr008 r8
                       on r8.pgcod = f700.xwfempresa
                      and r8.ctnro = f700.xwfcuenta
                    where f700.xwfcar3 = '1'
                      and u.wftaskcod = 3
                      and r8.pepais = w.pepais
                      and r8.petdoc = w.petdoc
                      and r8.pendoc = w.pendoc);
    commit;
    delete from JAQZ918 w
     where exists (select /*+PARALLEL(a,4)*/
                          1 --Que se encuentren en gestión por otro usuario (De actividad 1/4 que no sean bases de ana)
                     from (select nindcier, ncodact, ncodbas, npaicli, ntipdoc, cnumdoc from acdeval
                           union
                           select nindcier, ncodact, ncodbas, npaicli, ntipdoc, cnumdoc from acheval) a
                    where a.nindcier ='0' 
                      and (case when a.ncodact = 1 
                                 and a.ncodbas in (1,2,3) then 0
                                else 1 end)=1
                      and a.npaicli = w.pepais
                      and a.ntipdoc = w.petdoc
                      and rpad(a.cnumdoc,12) = w.pendoc);
    commit;
    delete from JAQZ918 w
     where exists (select /*+PARALLEL(x,4)*/
                          1 --Que tengan teléfonos erróneos o no existan
                     from (select npaicli,ntipdoc,cnumdoc,nrespue from acdrevi
                           union
                           select npaicli,ntipdoc,cnumdoc,nrespue from achrevi) x
                    where x.nrespue = 116
                      and x.npaicli = w.pepais
                      and x.ntipdoc = w.petdoc
                      and rpad(x.cnumdoc,12) = w.pendoc);
    commit;
    delete from JAQZ918 w
     where exists (select /*+PARALLEL(x,4)*/
                          1 --Retirar clientes en lista negra migrada de AC1
                     from JAQZ919 x
                    where rpad(x.JAQZ919numdoc,12) = w.pendoc);
    commit;
    delete from JAQZ918 w
     where exists (select /*+PARALLEL(d2,4)*/ 
                          1 --Retirar clientes con >= 70 años
                     from fsd002 d2
                    where d2.pfpais = w.pepais
                      and d2.pftdoc = w.petdoc
                      and d2.pfndoc = w.pendoc
                      and (trunc(sysdate)-d2.pffnac)/360 >= 70);
    commit;
    select count(*) into ln_fl from user_indexes where index_name = 'IX_JAQZ918_1';
    if ln_fl = 1 then EXECUTE IMMEDIATE 'drop index ix_jaqz918_1'; end if;
    begin
        DBMS_STATS.gather_table_stats(ownname          => 'AGECOMBT',
                                      tabname          => 'JAQZ918',
                                      degree           => 4,
                                      granularity      => 'ALL',
                                      estimate_percent => dbms_stats.auto_sample_size,
                                      cascade          => TRUE);
      end;
    --Limpiamos la ejecución anterior
    delete from acdbase_temp 
     where nidebas = 1
       and nidepro = 8
       and ncoding = 1
       and ncodact = 4
       and ncodbas = 11
       and cestado = '1';
    commit;
    
    begin
        DBMS_STATS.gather_table_stats(ownname          => 'AGECOMBT',
                                      tabname          => 'ACDBASE_TEMP',
                                      degree           => 4,
                                      granularity      => 'ALL',
                                      estimate_percent => dbms_stats.auto_sample_size,
                                      cascade          => TRUE);
      end;
  
  --Jefe Call Center
    select jf 
      into lv_jfcall
      from (select ccodjef jf , count(*) ct
              from acmoper
             where ccodcar = 12
               and ccodest = 1
             group by ccodjef
             order by ct desc)
     where rownum = 1;
  
    insert /*+append*/ into acdbase_temp (nidebas,nidepro,ncoding,ncodact,ncodbas,cestado,
                                          nnumpas,ntipdoc,cnumdoc,npascon,ntipcon,cdoccon,
                                          cnombre,czonfij,cdirfij,creffij,czonneg,cdirneg,
                                          crefneg,ctelfij,ctelmov,ncodage,ncodana,cusuing,
                                          dfecing,ncodpri)
    select 1,8,1,4,11,'1',--#REVISAR TI
           w.pepais, w.petdoc, w.pendoc,
           decode((select max(r2.rpndoc) from fsr002 r2 where r2.pepais = w.pepais and r2.petdoc = w.petdoc and r2.pendoc = w.pendoc and r2.rpccyg = 66),null,null,604),
           decode((select max(r2.rpndoc) from fsr002 r2 where r2.pepais = w.pepais and r2.petdoc = w.petdoc and r2.pendoc = w.pendoc and r2.rpccyg = 66),null,null,21),
           (select max(r2.rpndoc) from fsr002 r2 where r2.pepais = w.pepais and r2.petdoc = w.petdoc and r2.pendoc = w.pendoc and r2.rpccyg = 66),
           pq_datos_bases.fn_nomcli(w.pepais, w.petdoc, w.pendoc) nomcli,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,1,'UBIG') UBIG_DOM,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,1,'DIR') DIR_DOM, 
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,1,'REF') REF_DOM,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,3,'UBIG') UBIG_NEG,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,3,'DIR') DIR_NEG,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,3,'REF') REF_NEG,
           pq_datos_bases.fn_cl_telefonosxcod_call(w.pepais,w.petdoc,w.pendoc,1) TELEF_DOM,
           pq_datos_bases.fn_cl_telefonosxcod_call(w.pepais,w.petdoc,w.pendoc,3) TELEF_NEG,
           d10.aosuc,
           lv_jfcall,
           'SYSADM',
           sysdate,
           1
      from (select pepais,petdoc,pendoc from JAQZ918) w
       left join fsd010 d10
         on d10.rowid = pq_datos_bases.fn_row_ultcred(w.pepais,w.petdoc,w.pendoc);
    commit;
    --Retirar clientes sin teléfono
    delete from acdbase_temp w
     where length(trim(nvl(ctelfij,0))) < 6 
       and length(trim(nvl(ctelmov,0))) < 6
       and nidebas = 1
       and nidepro = 8
       and ncoding = 1
       and ncodact = 4
       and ncodbas = 11
       and cestado = '1';
    commit;
    
    --Retirar exceso de clientes para call (no más de 10k)
    delete from acdbase_temp w
     where rownum <= (select greatest(count(*)-10000,0) from acdbase_temp  where ncodact = 4 and ncodbas = 11)
       and nidebas = 1
       and nidepro = 8
       and ncoding = 1
       and ncodact = 4
       and ncodbas = 11
       and cestado = '1';
    commit;
  end sp_genera_inactivos_cc_ext;

  procedure sp_genera_lineas0_cc_ext is
  lv_jfcall varchar2(4000);
  ln_fl number := 0;
  begin
    EXECUTE IMMEDIATE 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
    EXECUTE IMMEDIATE 'truncate table JAQZ918';
    select count(*) into ln_fl from user_indexes where index_name = 'IX_JAQZ918_1';
    if ln_fl = 1 then EXECUTE IMMEDIATE 'drop index ix_jaqz918_1'; end if;
    insert /*+append*/ into JAQZ918
    select /*+paralell(w,10) parallel(r8,10)*/
           distinct r8.pepais, r8.petdoc, r8.pendoc
      from fsd011 d11
      join fsr008 r8
        on r8.pgcod = 1
       and r8.ctnro = d11.sccta
       and r8.ttcod = 1
       and r8.cttfir = 'T'
     where d11.scmod = 117
       and d11.scstat = 0
       and not exists (--no tiene saldo usado en la línea
                       select /*+PARALLEL(x,10)*/
                              1 
                         from fsd011 x 
                        where x.scmod = 443 
                          and x.scstat = 0
                          and abs(scsdo) > 0
                          and x.sccta = d11.sccta 
                          and x.scoper = d11.scoper);
     commit;
    EXECUTE IMMEDIATE 'create index ix_jaqz918_1 on jaqz918 (pepais,petdoc,pendoc)';
    
--02.10.2019
begin
  DBMS_STATS.gather_table_stats(ownname          => 'agecombt',
                                tabname          => 'JAQZ918',
                                degree           => 8,
                                granularity      => 'ALL',
                                estimate_percent => 100,
                                cascade          => TRUE);
end;    
    delete from JAQZ918 w
     where exists ( --no tienen credito judiciales, castigados, con demanda cancelados
                    select /*+PARALLEL(a,4) PARALLEL(b,4)*/
                           1 
                      from fsd010 a
                      join fsr008 b 
                        on b.pgcod = a.pgcod
                       and b.ctnro = a.aocta
                     where a.aocta <> 999999999 
                       and (a.aomod in (33,200) or --castigados, judiciales
                            a.aotope = 550 or --con demanda 
                            a.aostat in (71,66,64,23,25,22,21,33,34))--PJ
                       and a.aomod <> 120 --Prestamos pasivos
                       and b.pepais = w.pepais
                       and b.petdoc = w.petdoc
                       and b.pendoc = w.pendoc
                  );
    commit;
    delete from JAQZ918 w
     where exists (select /*+PARALLEL(a,4)*/
                          1 --Que se encuentren en gestión por otro usuario (De actividad 1/4 que no sean bases de ana)
                     from (select nindcier, ncodact, ncodbas, npaicli, ntipdoc, cnumdoc from acdeval
                           union
                           select nindcier, ncodact, ncodbas, npaicli, ntipdoc, cnumdoc from acheval) a
                    where a.nindcier ='0' 
                      and (case when a.ncodact = 1 
                                 and a.ncodbas in (1,2,3) then 0
                                else 1 end)=1
                      and a.npaicli = w.pepais
                      and a.ntipdoc = w.petdoc
                      and rpad(a.cnumdoc,12) = w.pendoc);
    commit;
    delete from JAQZ918 w
     where exists (select /*+PARALLEL(x,4)*/
                          1 --Que tengan teléfonos erróneos o no existan
                     from (select npaicli,ntipdoc,cnumdoc,nrespue from acdrevi
                           union
                           select npaicli,ntipdoc,cnumdoc,nrespue from achrevi) x
                    where x.nrespue = 116
                      and x.npaicli = w.pepais
                      and x.ntipdoc = w.petdoc
                      and rpad(x.cnumdoc,12) = w.pendoc);
    commit;
    delete from JAQZ918 w
     where exists (select /*+PARALLEL(x,4)*/
                          1 --Retirar clientes en lista negra migrada de AC1
                     from JAQZ919 x
                    where rpad(x.jaqz919numdoc,12) = w.pendoc);
    commit;
    delete from JAQZ918 w
     where exists (select /*+PARALLEL(d2,4)*/ 
                          1 --Retirar clientes con >= 70 años
                     from fsd002 d2
                    where d2.pfpais = w.pepais
                      and d2.pftdoc = w.petdoc
                      and d2.pfndoc = w.pendoc
                      and (trunc(sysdate)-d2.pffnac)/360 >= 70);
    commit;
    select count(*) into ln_fl from user_indexes where index_name = 'IX_JAQZ918_1';
    if ln_fl = 1 then EXECUTE IMMEDIATE 'drop index ix_jaqz918_1'; end if;
    begin
        DBMS_STATS.gather_table_stats(ownname          => 'AGECOMBT',
                                      tabname          => 'JAQZ918',
                                      degree           => 4,
                                      granularity      => 'ALL',
                                      estimate_percent => dbms_stats.auto_sample_size,
                                      cascade          => TRUE);
      end;

    --Limpiamos la ejecución anterior
    delete from acdbase_temp 
     where nidebas = 1
       and nidepro = 9
       and ncoding = 1
       and ncodact = 4
       and ncodbas = 12
       and cestado = '1';
    commit;
    
    begin
        DBMS_STATS.gather_table_stats(ownname          => 'AGECOMBT',
                                      tabname          => 'ACDBASE_TEMP',
                                      degree           => 4,
                                      granularity      => 'ALL',
                                      estimate_percent => dbms_stats.auto_sample_size,
                                      cascade          => TRUE);
      end;
  
  --Jefe Call Center
    select jf 
      into lv_jfcall
      from (select ccodjef jf , count(*) ct
              from acmoper
             where ccodcar = 12
               and ccodest = 1
             group by ccodjef
             order by ct desc)
     where rownum = 1;
  
    insert /*+append*/ into acdbase_temp (nidebas,nidepro,ncoding,ncodact,ncodbas,cestado,
                                     nnumpas,ntipdoc,cnumdoc,npascon,ntipcon,cdoccon,
                                     cnombre,czonfij,cdirfij,creffij,czonneg,cdirneg,
                                     crefneg,ctelfij,ctelmov,ncodage,ncodana,cusuing,
                                     dfecing,ncodpri)
    select 1,9,1,4,12,'1',--#REVISAR TI
           w.pepais, w.petdoc, w.pendoc,
           decode((select max(r2.rpndoc) from fsr002 r2 where r2.pepais = w.pepais and r2.petdoc = w.petdoc and r2.pendoc = w.pendoc and r2.rpccyg = 66),null,null,604),
           decode((select max(r2.rpndoc) from fsr002 r2 where r2.pepais = w.pepais and r2.petdoc = w.petdoc and r2.pendoc = w.pendoc and r2.rpccyg = 66),null,null,21),
           (select max(r2.rpndoc) from fsr002 r2 where r2.pepais = w.pepais and r2.petdoc = w.petdoc and r2.pendoc = w.pendoc and r2.rpccyg = 66),
           pq_datos_bases.fn_nomcli(w.pepais, w.petdoc, w.pendoc) nomcli,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,1,'UBIG') UBIG_DOM,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,1,'DIR') DIR_DOM, 
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,1,'REF') REF_DOM,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,3,'UBIG') UBIG_NEG,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,3,'DIR') DIR_NEG,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,3,'REF') REF_NEG,
           pq_datos_bases.fn_cl_telefonosxcod_call(w.pepais,w.petdoc,w.pendoc,1) TELEF_DOM,
           pq_datos_bases.fn_cl_telefonosxcod_call(w.pepais,w.petdoc,w.pendoc,3) TELEF_NEG,
           d10.aosuc,
           lv_jfcall,
           'SYSADM',
           sysdate,
           1
      from (select pepais,petdoc,pendoc from JAQZ918) w
       left join fsd010 d10
         on d10.rowid = pq_datos_bases.fn_row_ultcred(w.pepais,w.petdoc,w.pendoc);
    commit;
    --Retirar clientes sin teléfono
    delete from acdbase_temp w
     where length(trim(nvl(ctelfij,0))) < 6 
       and length(trim(nvl(ctelmov,0))) < 6
       and nidebas = 1
       and nidepro = 9
       and ncoding = 1
       and ncodact = 4
       and ncodbas = 12
       and cestado = '1';
    commit;
    
    --Retirar exceso de clientes para call (no más de 10k)
    delete from acdbase_temp w
     where rownum <= (select greatest(count(*)-10000,0) from acdbase_temp where ncodact = 4 and ncodbas = 12)
       and nidebas = 1
       and nidepro = 9
       and ncoding = 1
       and ncodact = 4
       and ncodbas = 12
       and cestado = '1';
    commit;
  end sp_genera_lineas0_cc_ext;

  procedure sp_genera_ampliaciones_cc_ext is
  lv_jfcall varchar2(4000);
  ln_fl number :=0;
  begin
    EXECUTE IMMEDIATE 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
    EXECUTE IMMEDIATE 'truncate table JAQZ918';
    select count(*) into ln_fl from user_indexes where index_name = 'IX_JAQZ918_1';
    if ln_fl = 1 then EXECUTE IMMEDIATE 'drop index ix_jaqz918_1'; end if;
    insert /*+append*/ into JAQZ918
    select /*+all_rows parallel(w,10)*/ w.pepais,w.petdoc,w.pendoc
      from fsh012_bi w
     where w.bcfech = trunc(sysdate-1)
       and w.n_diaatr = 0
       and ((trunc(sysdate)-bcfval)/30)>=6
       and pq_datos_bases.CRE_FN_ATR_PROM_CLI_NUMDOC(trunc(sysdate),trunc(sysdate-185),w.pendoc)<=5 --prom. días atraso < 5, últ. 6 meses
       and producto not in ('CARTA FIANZA','SUPERATE MUJER','AGRÍCOLA','AGROPECUARIO','COSECHANDO','MOVITAXI', 'VEHICULAR PARA TRABAJADORES CAJA AREQUIPA', 
                            'VEHICULAR','MOVIGAS', 'MI BAÑO', 'PARALELO', 'ADMINISTRATIVO','CREDILUZ','PERSONAL DIRECTO PARA TRABAJADORES', 'MI VIVIENDA', 
                            'TECHO PROPIO', 'HIPOTECARIO PARA TRABAJADORES', 'ARROZ','PAPA','GANADERO','PECUARIO','PRENDARIO','PARALELO')
       and (case when producto in ('MICROPYMES','MICROPYMES PUNTUALITO') 
                  and nvl(pq_datos_bases.fn_cantidad_cuotas(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0)
                     -nvl(pq_datos_bases.fn_cant_cuoxven(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0)
                     >=8 then 1 --que hayan pagado por lo menos 8 cuotas del total
                 when producto in ('CREDIOFICIOS') 
                  and nvl(pq_datos_bases.fn_capital_total(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0) > 0
                  and nvl(pq_datos_bases.fn_capdeu_cuoven(w.bcfvto,w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0)
                     /nvl(pq_datos_bases.fn_capital_total(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0) 
                     <=0.3 then 1 --que quede pendiente por pagar <=30% del saldo
                 when producto not in ('CREDIOFICIOS','MICROPYMES','MICROPYMES PUNTUALITO') 
                  and nvl(pq_datos_bases.fn_cantidad_cuotas(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0)
                     -nvl(pq_datos_bases.fn_cant_cuoxven(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0)
                     >=5 then 1 --que hayan pagado por lo menos 5 cuotas del total
                 when nvl(pq_datos_bases.fn_cantidad_cuotas(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0) > 0 
                  and nvl(pq_datos_bases.fn_cant_cuoxven(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0)
                     /nvl(pq_datos_bases.fn_cantidad_cuotas(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0) 
                     <0.5 then 1 --que queden pendientes como máximo el 50% de las cuotas
                 else 0 end) = 1
       and w.bccta <> 999999999 
       and substr(w.bcrubr,1,4) in (1411,1414,1415,1416, 1421,1424,1425,1426) 
       and w.bcmod not in (33,141,107,108,116) ---Se excluye castigos, carta fianza, convenios, prendario, líneas
       and NVL(pq_datos_bases.fn_tipo_solicitud(w.bcemp,w.bcmod,w.bcsuc,w.bcmda,w.bcpap,w.bccta,w.bcoper,w.bcsbop,w.bctop),0) not in (4,12)--No ampliaciones
       and w.bcprod <>99;
    commit;
    EXECUTE IMMEDIATE 'create index ix_jaqz918_1 on jaqz918 (pepais,petdoc,pendoc)';

--02.10.2019
begin
  DBMS_STATS.gather_table_stats(ownname          => 'agecombt',
                                tabname          => 'JAQZ918',
                                degree           => 8,
                                granularity      => 'ALL',
                                estimate_percent => 100,
                                cascade          => TRUE);
end;
    delete from JAQZ918 w 
     where (--número créditos vigentes <=2
            select /*+PARALLEL(d11,4) PARALLEL(r8,4)*/
                   count(distinct d11.scmod||'-'||d11.scsuc||'-'||d11.scmda||'-'||d11.scpap||'-'||d11.sccta||'-'||d11.scoper||'-'||d11.scsbop||'-'||d11.sctope)
              from fsd011 d11
              join fsr008 r8
                on r8.pgcod  = d11.pgcod
               and r8.ctnro  = d11.sccta
               and r8.ttcod  = 1
               and r8.cttfir = 'T'
             where d11.sccta <> 999999999 
               and substr(d11.scrub,1,4) in (1411,1414,1415,1416, 1421,1424,1425,1426)
               and d11.scmod not in (33,141,108/*PRENDARIO*/,29/*GARANTIAS*/,120/*P PASIVOS*/)
               and d11.scstat <> 99
               and r8.pepais = w.pepais
               and r8.petdoc = w.petdoc
               and r8.pendoc = w.pendoc) > 2;
    commit;
    delete from JAQZ918 w 
     where exists (--no tienen credito judiciales, castigados, con demanda cancelados
                    select /*+PARALLEL(d10,4) PARALLEL(r8,4)*/ 1 
                      from fsd010 d10
                      join fsr008 r8
                        on r8.pgcod  = d10.pgcod
                       and r8.ctnro  = d10.aocta
                     where d10.aocta <> 999999999 
                       and (d10.aomod in (33,200) or --castigados, judiciales
                            d10.aotope = 550 or --con demanda 
                            d10.aostat in (71,66,64,23,25,22,21,33,34))--PJ
                       and d10.aomod <> 120
                       and r8.pepais = w.pepais
                       and r8.petdoc = w.petdoc
                       and r8.pendoc = w.pendoc);--Prestamos pasivos
    commit;
    delete from JAQZ918 w
     where exists (--En proceso de solicitud en los últimos 15 días
                   select /*+PARALLEL(u,4) PARALLEL(f700,4) PARALLEL(r8,4)*/ 1
                     FROM wfwrkitems u 
                     join (select /*+PARALLEL(s,4)*/
                                  s.wfinsprcid,min(s.wfitemid) min_wfitemid
                             from wfwrkitems s 
                            where s.wftaskcod = 3
                              and trunc(s.WFITEMINIT)>= trunc(sysdate-15)
                           group by s.wfinsprcid       
                          )m
                       on m.wfinsprcid = u.wfinsprcid
                      and m.min_wfitemid = u.wfitemid
                     join xwf700 f700 
                       on f700.xwfprcins = u.wfinsprcid 
                     join fsr008 r8
                       on r8.pgcod = f700.xwfempresa
                      and r8.ctnro = f700.xwfcuenta
                    where f700.xwfcar3 = '1'
                      and u.wftaskcod = 3
                      and r8.pepais = w.pepais
                      and r8.petdoc = w.petdoc
                      and r8.pendoc = w.pendoc);
    commit;
    delete from JAQZ918 w
     where exists (select /*+PARALLEL(a,4)*/
                          1 --Que se encuentren en gestión por otro usuario (De actividad 1/4 que no sean bases de ana)
                     from (select nindcier, ncodact, ncodbas, npaicli, ntipdoc, cnumdoc from acdeval
                           union
                           select nindcier, ncodact, ncodbas, npaicli, ntipdoc, cnumdoc from acheval) a
                    where a.nindcier ='0' 
                      and (case when a.ncodact = 1 
                                 and a.ncodbas in (1,2,3) then 0
                                else 1 end)=1
                      and a.npaicli = w.pepais
                      and a.ntipdoc = w.petdoc
                      and rpad(a.cnumdoc,12) = w.pendoc);
    commit;
    delete from JAQZ918 w
     where exists (select /*+PARALLEL(x,4)*/
                          1 --Que tengan teléfonos erróneos o no existan
                     from (select npaicli,ntipdoc,cnumdoc,nrespue from acdrevi
                           union
                           select npaicli,ntipdoc,cnumdoc,nrespue from achrevi) x
                    where x.nrespue = 116
                      and x.npaicli = w.pepais
                      and x.ntipdoc = w.petdoc
                      and rpad(x.cnumdoc,12) = w.pendoc);
    commit;
    delete from JAQZ918 w
     where exists (select /*+PARALLEL(x,4)*/
                          1 --Retirar clientes en lista negra migrada de AC1
                     from JAQZ919 x
                    where rpad(x.jaqz919numdoc,12) = w.pendoc);
    commit;
    delete from JAQZ918 w
     where exists (select /*+PARALLEL(d2,4)*/ 
                          1 --Retirar clientes con >= 70 años
                     from fsd002 d2
                    where d2.pfpais = w.pepais
                      and d2.pftdoc = w.petdoc
                      and d2.pfndoc = w.pendoc
                      and (trunc(sysdate)-d2.pffnac)/360 >= 70);
    commit;
    select count(*) into ln_fl from user_indexes where index_name = 'IX_JAQZ918_1';
    if ln_fl = 1 then EXECUTE IMMEDIATE 'drop index ix_jaqz918_1'; end if;
    
    begin
        DBMS_STATS.gather_table_stats(ownname          => 'AGECOMBT',
                                      tabname          => 'JAQZ918',
                                      degree           => 4,
                                      granularity      => 'ALL',
                                      estimate_percent => dbms_stats.auto_sample_size,
                                      cascade          => TRUE);
      end;

    --Limpiamos la ejecución anterior
    delete from acdbase_temp 
     where nidebas = 1
       and nidepro = 10
       and ncoding = 1
       and ncodact = 4
       and ncodbas = 13
       and cestado = '1';
    commit;

    begin
        DBMS_STATS.gather_table_stats(ownname          => 'AGECOMBT',
                                      tabname          => 'ACDBASE_TEMP',
                                      degree           => 4,
                                      granularity      => 'ALL',
                                      estimate_percent => dbms_stats.auto_sample_size,
                                      cascade          => TRUE);
      end;
  
    --Jefe Call Center
    select jf 
      into lv_jfcall
      from (select ccodjef jf , count(*) ct
              from acmoper
             where ccodcar = 12
               and ccodest = 1
             group by ccodjef
             order by ct desc)
     where rownum = 1;
  
    insert /*+append*/ into acdbase_temp (nidebas,nidepro,ncoding,ncodact,ncodbas,cestado,
                                          nnumpas,ntipdoc,cnumdoc,npascon,ntipcon,cdoccon,
                                          cnombre,czonfij,cdirfij,creffij,czonneg,cdirneg,
                                          crefneg,ctelfij,ctelmov,ncodage,ncodana,cusuing,
                                          dfecing,ncodpri)
    select 1,10,1,4,13,'1',--#REVISAR TI
           w.pepais, w.petdoc, w.pendoc,
           decode((select max(r2.rpndoc) from fsr002 r2 where r2.pepais = w.pepais and r2.petdoc = w.petdoc and r2.pendoc = w.pendoc and r2.rpccyg = 66),null,null,604),
           decode((select max(r2.rpndoc) from fsr002 r2 where r2.pepais = w.pepais and r2.petdoc = w.petdoc and r2.pendoc = w.pendoc and r2.rpccyg = 66),null,null,21),
           (select max(r2.rpndoc) from fsr002 r2 where r2.pepais = w.pepais and r2.petdoc = w.petdoc and r2.pendoc = w.pendoc and r2.rpccyg = 66),
           pq_datos_bases.fn_nomcli(w.pepais, w.petdoc, w.pendoc) nomcli,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,1,'UBIG') UBIG_DOM,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,1,'DIR') DIR_DOM, 
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,1,'REF') REF_DOM,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,3,'UBIG') UBIG_NEG,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,3,'DIR') DIR_NEG,
           pq_datos_bases.fn_direccion_cliente(w.pepais,w.petdoc,w.pendoc,3,'REF') REF_NEG,
           pq_datos_bases.fn_cl_telefonosxcod_call(w.pepais,w.petdoc,w.pendoc,1) TELEF_DOM,
           pq_datos_bases.fn_cl_telefonosxcod_call(w.pepais,w.petdoc,w.pendoc,3) TELEF_NEG,
           d10.aosuc,
           lv_jfcall,
           'SYSADM',
           sysdate,
           1
      from (select pepais,petdoc,pendoc from JAQZ918) w
       left join fsd010 d10
         on d10.rowid = pq_datos_bases.fn_row_ultcred(w.pepais,w.petdoc,w.pendoc);
    commit;

    --Retirar clientes sin teléfono
    delete from acdbase_temp w
     where length(trim(nvl(ctelfij,0))) < 6 
       and length(trim(nvl(ctelmov,0))) < 6
       and nidebas = 1
       and nidepro = 10
       and ncoding = 1
       and ncodact = 4
       and ncodbas = 13
       and cestado = '1';
    commit;
    
    --Retirar exceso de clientes para call (no más de 10k)
    delete from acdbase_temp w
     where rownum <= (select greatest(count(*)-10000,0) from acdbase_temp  where ncodact = 4 and ncodbas = 13)
       and nidebas = 1
       and nidepro = 10
       and ncoding = 1
       and ncodact = 4
       and ncodbas = 13
       and cestado = '1';
    commit;

  end sp_genera_ampliaciones_cc_ext;

  procedure sp_act_seguimiento(codact number,
                               codbas number,
                               corr number, --correlativo cliente
                               ases varchar2, --analista
                               rpta varchar2, --estado de solicitud
                               nsol number, --instancia 
                               ultr number, --último resultado agenda comercial
                               uact varchar2 --usuario actual
                              ) is
  rpta_code_fin number := 0;
  ln_corasi number;
  ln_corage number;
  ln_paicli number;
  ln_tipdoc number;
  ls_numdoc varchar2(12);
  ln_codact number;
  ls_usufin varchar(12);
  ls_codrol char(3);
  begin
    -- Se obtiene el cargo
    
    if trim(uact) = 'VALIDA' then 
      ls_codrol :=52;
    else
       begin
          select ccodcar into ls_codrol from acmoper 
           where ccodope = trim(upper(uact));
       exception
          when no_data_found then
             return;
          when others then
             return;
       end;
    end if ;
    --1.Codificamos la respuesta
    if rpta = 'DENEGADO' then rpta_code_fin := 91; end if;--Código de la respuesta 'C- DENEGADO (Sistema)'
    if rpta = 'EN SOLICITUD' then rpta_code_fin := 87; end if;--Código de la respuesta 'R- EN SOLICITUD  (Sistema)'
    if rpta = 'EN EVALUACION' then rpta_code_fin := 88; end if;--Código de la respuesta 'R- EN EVALUACIÓN (Sistema)'
    if rpta = 'EN APROBACION' then rpta_code_fin := 89; end if;--Código de la respuesta 'R- EN APROBACIÓN (Sistema)'
    if rpta = 'POR DESEMBOLSAR' then rpta_code_fin := 90; end if;--Código de la respuesta 'R- POR DESEMBOLSAR (Sistema)'
    if rpta = 'DESEMBOLSADO' then rpta_code_fin := 92; end if;--Código de la respuesta 'C- DESEMBOLSADO  (Sistema)'

      --#REVISAR TI
    if ls_codrol =101 and  ultr <> 79  and rpta_code_fin not in (92,91) then return; end if;
    
    --2.Validamos si la respuesta (rpta) es la misma que la anterior (ultr)
    if rpta_code_fin = ultr then return; end if;

    --3.Validamos si lo está gestionando el mismo analista (ases)
    if upper(trim(ases)) <> upper(trim(uact)) then
      /*transferir cliente(a partir de corr) a ases*/ 
       if ls_codrol <> 107 then
          sp_tracli (corr,uact,ases);
       end if;
       ls_usufin :=trim(upper(ases));
    else
       ls_usufin:=trim(upper(uact));
    end if;
    
    --4.Actualizar
    ---Si la respuesta es R
    select asi.ncorasi,age.ncorage,eva.npaicli,eva.ntipdoc,eva.cnumdoc,eva.ncodact
      into ln_corasi,ln_corage,ln_paicli,ln_tipdoc,ls_numdoc,ln_codact
      from (select * from acdeval where ncorcli = corr
             union
            select * from acheval where ncorcli = corr) eva
    left join acdasig asi
        on asi.ncorcli = eva.ncorcli
    left join acdagen age
        on age.ncorasi = asi.ncorasi
    where eva.ncorcli = corr;
       
    if rpta_code_fin in (87,88,89,90) then
       -----Si no está programado, se debe programar para hoy, ingresar la respuesta (R) para la misma y agendarlo nuevamente para hoy.
       if ln_corage is null then
          insert into achagen
          select * from acdagen
           where npaicli = ln_paicli
             and ntipdoc = ln_tipdoc
             and trim(cnumdoc) = ls_numdoc
             and ncodact = ln_codact;
          commit;
          delete acdagen
           where npaicli = ln_paicli
             and ntipdoc = ln_tipdoc
             and trim(cnumdoc) = ls_numdoc
             and ncodact = ln_codact;
          commit;   
          insert into acdagen 
          select supplier_seq.NEXTVAL,nidebas,nidepro,ncoding,ncodact,ncodbas,npaicli,
                 ntipdoc,cnumdoc,'1',to_char(sysdate,'DD/MM/YYYY'),dfecasi,trunc(sysdate),
                 '09:00',ases,ases,sysdate,'0',ncorasi,0,0
            from acdasig
           where ncorasi = ln_corasi
             and npaicli = ln_paicli
             and ntipdoc = ln_tipdoc
             and trim(cnumdoc) = ls_numdoc
             and ncodact = ln_codact;
          commit;
       end if;         
       sp_insvis (ln_paicli,ln_tipdoc, ls_numdoc,ln_codact,ls_usufin,rpta_code_fin);
       -----Si está programado, ingresar la respuesta (R) para la última programación y programar nuevamente para hoy.      
       ---Si la respuesta es C
    elsif rpta_code_fin in (91,92) then
       if ln_corage is null then
          insert into achagen
          select * 
            from acdagen
           where npaicli = ln_paicli
             and ntipdoc = ln_tipdoc
             and trim(cnumdoc) = ls_numdoc
             and ncodact = ln_codact;
          commit;
          delete acdagen
           where npaicli = ln_paicli
             and ntipdoc = ln_tipdoc
             and trim(cnumdoc) = ls_numdoc
             and ncodact = ln_codact;
          commit; 
          insert into acdagen 
          select supplier_seq.NEXTVAL,nidebas,nidepro,ncoding,ncodact,ncodbas,npaicli,
                 ntipdoc,cnumdoc,'1',to_char(sysdate,'DD/MM/YYYY'),dfecasi,trunc(sysdate),
                 '09:00',ases,ases,sysdate,'0',ncorasi,0,0
            from acdasig
           where ncorasi = ln_corasi
             and ncodact = ln_codact;
          commit;
       end if;
       sp_insvis (ln_paicli,ln_tipdoc, ls_numdoc,ln_codact,ls_usufin,rpta_code_fin);
       -----Si está programado, ingresar la respuesta (C) para la última programación.      
     end if;
  end sp_act_seguimiento;

--Adicionales
  function fn_cl_telefonosxcod_call(  lv_pepais in number,
                                              lv_petdoc in number,
                                              lv_pendoc in varchar2,
                                              lv_docod  in number
                                            ) return varchar2
    IS

      lv_pendoc2 char(12);
      lv_telefonos varchar2(50);

      cursor c_tele_pers(lc_flgant char) is
             select Dotelfp
               from Fsr005
              Where Pepais = lv_pepais
                and Petdoc = lv_petdoc
                and Pendoc = lv_pendoc2
                and (case
                           when lv_docod=1 and docod<>3 then 1 
                           when lv_docod=3 and docod=3 then 1  
                           when lv_docod=0 then 1  
                     end 
                    )=1
                and lc_flgant = 'N'
               UNION
               select Dotelfp
                 from Fsr005
                Where Pepais = lv_pepais
                  and Petdoc = lv_petdoc
                  and Pendoc = lv_pendoc2
                  and (case
                           when lv_docod=1 and docod<>8 then 1 
                           when lv_docod=3 and docod=8 then 1  
                           when lv_docod=0 then 1  
                     end 
                    )=1                         ;
      lc_letra varchar2(1);
      ln_cont number:=0;
      lc_letini varchar2(1);
      ln_contrep number:=0;

      lc_telerr char(1):='N';

      lc_telact char(1):='N';

    BEGIN
      lv_pendoc2 := lv_pendoc;

      begin
             select distinct 'S'
                    into lc_telact
               from Fsr005
              Where Pepais = lv_pepais
                and Petdoc = lv_petdoc
                and Pendoc = lv_pendoc2
                and (case
                           when lv_docod=1 and docod<>8 then 1 
                           when lv_docod=3 and docod=8 then 1  
                           when lv_docod=0 then 1  
                     end 
                    )=1;
      exception
        when no_data_found then
          lc_telact := 'N';
      end;

      for i in c_tele_pers(lc_telact)  loop

          --verificar telefonos
          lc_letra :=null;
          ln_cont := 0;

          lc_letini := Substr(trim(i.Dotelfp),1,1);
          ln_contrep :=0;

          for j in 1..length(trim(i.Dotelfp)) loop

            lc_letra := Substr(trim(i.Dotelfp),j,1);
            if lc_letra in ('0','1','2','3','4','5','6','7','8','9') then
                ln_cont := ln_cont+1;
            end if;

            if(lc_letini = lc_letra) then
               ln_contrep:= ln_contrep+1;
            end if;

          end loop;

          --concatenar telefonos
          if ln_cont>=6 and ln_contrep<>length(trim(i.Dotelfp)) and lc_telerr = 'N' then
             lv_telefonos := lv_telefonos || trim(i.Dotelfp)|| ',';
          end if;

      end loop;
      lv_telefonos := substr(lv_telefonos, 1, length(lv_telefonos) - 1);
      return lv_telefonos;
  EXCEPTION
    when others then
      return null;
  END fn_cl_telefonosxcod_call;
  
  function fn_direccion_cliente( lv_pepais in number,
                                 lv_petdoc in number,
                                 lv_pendoc in varchar2,
                                 lv_docod  in number,
                                 lv_tipo   in varchar2
                                ) return varchar2 is

      lc_direccion varchar2(200);
      lv_pendoc2 char(12);
      lc_flgact varchar(1):='N';
      
    begin
      lv_pendoc2 := lv_pendoc;

      begin
        SELECT distinct 'S'
               into lc_flgact
          FROM SNGC13 c13
         WHERE Docod = (case lv_docod
                          when 1 then 7
                          when 3 then 8
                         end)
          and sngc13Pais = lv_pepais
          and sngc13Tdoc = lv_petdoc
          and sngc13Ndoc = lv_pendoc
          and c13.sngc13est = 'H';
      exception
        when no_data_found then
          lc_flgact := 'N';
      end;

      begin
        if lc_flgact = 'S' then
          SELECT DIR
            into lc_direccion
            FROM (SELECT
                    CASE lv_tipo
                         WHEN 'DIR'  THEN trim(replace(sngc13Dir,'NO CONSIGNADO',''))
                         WHEN 'REF'  THEN trim(replace(NVL(SNGC13REF1,SNGC13REF),'NO CONSIGNADO',''))
                         WHEN 'DPTO' THEN (select DepNom from FST068 where Pais = nvl(c13.sngc13pdoc, lv_pepais) and DepCod = sngc13Dpto)
                         WHEN 'PROV' THEN (select LocNom from FST070 where Pais = nvl(c13.sngc13pdoc, lv_pepais) and DepCod = sngc13Dpto and LocCod =sngc13Prov)
                         WHEN 'DIS'  THEN (select Fst071Dsc from FST071 where Fst071Pai = nvl(c13.sngc13pdoc, lv_pepais) and Fst071Dpt = sngc13Dpto and Fst071Loc =sngc13Prov and Fst071Col=sngc13Dist)
                         WHEN 'TVIV' THEN (select c12.sngc12dsc from sngc12 c12 where c12.sngc12vivc= c13.sngc12vivc)
                         WHEN 'UBIG' THEN SNGC13UGEO
                     END DIR
                    FROM SNGC13 c13
                   WHERE Docod = (case lv_docod
                                  when 1 then 7
                                  when 3 then 8
                                end)
                     and sngc13Pais = lv_pepais
                     and sngc13Tdoc = lv_petdoc
                     and sngc13Ndoc = lv_pendoc
                     and c13.sngc13est = 'H'
                   ORDER BY sngc13Corr desc)
          WHERE ROWNUM = 1;
        else
          SELECT DIR
            into lc_direccion
            FROM (SELECT
                    CASE lv_tipo
                         WHEN 'DIR'  THEN trim(replace(sngc13Dir,'NO CONSIGNADO',''))
                         WHEN 'REF'  THEN trim(replace(NVL(SNGC13REF1,SNGC13REF),'NO CONSIGNADO',''))
                         WHEN 'DPTO' THEN (select DepNom from FST068 where Pais = nvl(c13.sngc13pdoc, lv_pepais) and DepCod = sngc13Dpto)
                         WHEN 'PROV' THEN (select LocNom from FST070 where Pais = nvl(c13.sngc13pdoc, lv_pepais) and DepCod = sngc13Dpto and LocCod =sngc13Prov)
                         WHEN 'DIS'  THEN (select Fst071Dsc from FST071 where Fst071Pai = nvl(c13.sngc13pdoc, lv_pepais) and Fst071Dpt = sngc13Dpto and Fst071Loc =sngc13Prov and Fst071Col=sngc13Dist)
                         WHEN 'TVIV' THEN (select c12.sngc12dsc from sngc12 c12 where c12.sngc12vivc= c13.sngc12vivc)
                         WHEN 'UBIG' THEN SNGC13UGEO
                     END DIR
                    FROM SNGC13 c13
                   WHERE Docod = lv_docod
                     and sngc13Pais = lv_pepais
                     and sngc13Tdoc = lv_petdoc
                     and sngc13Ndoc = lv_pendoc
                     and c13.sngc13est = 'H'
                   ORDER BY sngc13Corr desc)
           WHERE ROWNUM = 1;
        end if;
      exception
        when no_data_found then
          lc_direccion := null;
        end;
    return lc_direccion;
  end;

  function fn_nomcli(v_pepais  in number,
                                       v_petdoc  in number,
                                       v_pendoc in varchar2
                                       ) return varchar2 is
  lv_nombre varchar2(4000);

  begin

      select
       case d1.petipo
         when 'F' then trim(d2.pfape1)||' '||trim(d2.pfape2)||', '||trim(d2.pfnom1)||' '||trim(d2.pfnom2)
         when 'J' then d3.pjrazs
       end
       into lv_nombre
      from fsd001 d1
      left join fsd002 d2
        on d1.pepais = d2.pfpais
       and d1.petdoc = d2.pftdoc
       and d1.pendoc = d2.pfndoc
      left join fsd003 d3
        on d1.pepais = d3.pjpais
       and d1.petdoc = d3.pjtdoc
       and d1.pendoc = d3.pjndoc
      join fsr008 r8
        on r8.pepais = d1.pepais
       and r8.petdoc = d1.petdoc
       and r8.pendoc = d1.pendoc
      where r8.pepais = v_pepais
       and r8.petdoc = v_petdoc
       and r8.pendoc = rpad(v_pendoc,12)
       and rownum = 1;
      return lv_nombre;

  exception
    when no_data_found then
    return '';
    when others then
    return null;
  end fn_nomcli;
  
  function fn_tipo_solicitud (p_pgcod  in fsd010.pgcod%type,
                               p_aomod  in fsd010.aomod%type,
                               p_aosuc  in fsd010.aosuc%type,
                               p_aomda  in fsd010.aomda%type,
                               p_aopap  in fsd010.aopap%type,
                               p_aocta  in fsd010.aocta%type,
                               p_aooper in fsd010.aooper%type,
                               p_aosbop in fsd010.aosbop%type,
                               p_aotope in fsd010.aotope%type
                              ) return number
  is
  /*
  0 Normal
  1 Cartas Fianzas
  3 Refinanciación
  4 Ampliación de Crédito
  7 Cupo de Desembolsos
  10 Convenios
  11 Línea de Crédito
  12 Ampliación de LíneasFinal del formulario
  Principio del formulario
  13Final del formulario Reprog. x Cambio de
  14 Reprog. x Desastre N
  */  
  
  sng001ori       sng001.sng001ori%type;        
  ln_instancia    xwf700.xwfprcins%type;                 
  begin
    
      --entontrar instancia
       select
            max(xw2.xwfprcins) xwfprcins
            into ln_instancia
       from xwf700 xw2
       where
               xw2.xwfempresa          =  p_pgcod
           and xw2.xwfsucursal         =  p_aosuc
           and xw2.xwfmoneda           =  p_aomda
           and xw2.xwfpapel            =  p_aopap
           and xw2.xwfcuenta           =  p_aocta
           and xw2.xwfoperacion        =  p_aooper
           and xw2.xwfsubope           =  p_aosbop
           and (xw2.xwfmodulo          =  p_aomod 
                or xw2.xwfmodulo       =  (case p_aomod when 116 then 117 else p_aomod end)                 
               )
           and xw2.xwftipope           =  p_aotope
           and xw2.xwfcar3             = '1';
           
        if ln_instancia is null then    
           select /*+use_nl(XW2) parallel(rel,2,1)*/ 
                max(xw2.xwfprcins) xwfprcins
                into ln_instancia
           from xwf700 xw2,
                Fsr011 rel
           where
                   xw2.xwfempresa   =  rel.r2cod           
               and xw2.xwfsucursal  =  rel.r2suc
               and xw2.xwfmoneda    =  rel.r2mda
               and xw2.xwfpapel     =  rel.r2pap
               and xw2.xwfcuenta    =  rel.r2cta
               and xw2.xwfoperacion =  rel.r2oper
               and xw2.xwfsubope    =  rel.r2sbop
               and (xw2.xwfmodulo    =  p_aomod 
                    or xw2.xwfmodulo    =  (case p_aomod when 116 then 117 else p_aomod end)                 
                   )
               and xw2.xwftipope    =  rel.r2tope
               and xw2.xwfcar3      = '1'
               and rel.r1cod        = p_pgcod               
               and rel.r1mod        = p_aomod
               and rel.r1suc        = p_aosuc
               and rel.r1mda        = p_aomda
               and rel.r1pap        = p_aopap
               and rel.r1cta        = p_aocta
               and rel.r1oper       = p_aooper
               and rel.r1sbop       = p_aosbop
               and rel.r1tope       = p_aotope;
         end if; 

     begin    

        select sng001ori
          into sng001ori
         from  sng001
        where  sng001inst =  ln_instancia;

     exception when others then                                     
               sng001ori:= null;
     end;       

     return sng001ori;   
      
  end fn_tipo_solicitud;

function fn_cantidad_cuotas(v_Pgcod  in number,
                            v_Scmod  in number,
                            v_Scsuc  in number,
                            v_Scmda  in number,
                            v_Scpap  in number,
                            v_Sccta  in number,
                            v_Scoper in number,
                            v_Scsbop in number,
                            v_Sctope in number) return number is
    --Cuotas plazo del Plan de Pagos
    ln_cantcuo number;
    
  begin
        begin
          --vigente y refinanciado
          Select count(*) 
            Into ln_cantcuo           
            From FSD601 a 
          where a.Pgcod  = v_Pgcod
            and a.Ppmod  = v_Scmod
            and a.Ppsuc  = v_Scsuc
            and a.Ppmda  = v_Scmda
            and a.Pppap  = v_Scpap
            and a.Ppcta  = v_Sccta
            and a.Ppoper = v_Scoper
            and a.Ppsbop = v_Scsbop
            and a.Pptope = v_Sctope
            and a.D601co = 'S'
            and (a.ppcap + a.ppint ) > 0;
      exception when others then
                ln_cantcuo := null;
      end;
      Return ln_cantcuo;
  end fn_cantidad_cuotas;
  
  function fn_row_ultcred (ln_pepais in number,
                           ln_petdoc in number,
                           lv_pendoc in char
                          )return varchar2
  is
      ld_ultrow varchar2(4000);
  begin
    select max(x.rowid)
     into ld_ultrow
     from fsd010 x
     join fsr008 r8
       on x.pgcod = 1
      and r8.ctnro = x.aocta
      and r8.pgcod = x.pgcod
      and r8.pepais = ln_pepais
      and r8.petdoc = ln_petdoc
      and r8.pendoc = lv_pendoc
      and r8.ttcod = 1
      and r8.cttfir = 'T'
    where x.aomod in (select modulo from fst111 where dscod=50 and modulo not in (29/*Garantías*/,120/*PrestPasivos*/,144/*PrestCapitalØ*/))--módulos de crédito
      and x.aofval = pq_datos_bases.fn_fec_ultcred(ln_pepais,ln_petdoc,lv_pendoc);
    Return ld_ultrow;
  exception when others then
      return null;
  end fn_row_ultcred;
  
  function fn_fec_ultcred (ln_pepais in number,
                         ln_petdoc in number,
                         lv_pendoc in char
                        )return date
  is
      ld_ultcred date;
  begin
    select max(x.aofval)
     into ld_ultcred
     from fsd010 x
     join fsr008 r8
       on x.pgcod = 1
      and r8.ctnro = x.aocta
      and r8.pgcod = x.pgcod
      and r8.pepais = ln_pepais
      and r8.petdoc = ln_petdoc
      and r8.pendoc = lv_pendoc
      and r8.ttcod = 1
      and r8.cttfir = 'T'
    where x.aomod in (select modulo from fst111 where dscod=50 and modulo not in (29/*Garantías*/,120/*PrestPasivos*/,144/*PrestCapitalØ*/));--módulos de crédito
    Return ld_ultcred;
  exception when others then
      return null;
  end fn_fec_ultcred;

  FUNCTION CRE_FN_ATR_PROM_CLI_NUMDOC(PD_FECPRO IN DATE,
                                      PD_FECINI IN DATE,
                                      PC_NUMDOC IN VARCHAR2
                                     )
  RETURN NUMBER
  IS
    LN_PROATR NUMBER;
  BEGIN
    SELECT CASE
             WHEN SUM(NROCUO)>0 THEN ROUND(SUM(ATRACUM)/SUM(NROCUO),2)
             ELSE 0
           END
    INTO LN_PROATR
    FROM
    (
      SELECT SUM(CASE
                   WHEN NVL(B.PP1FECH, PD_FECPRO) - A.PPFPAG > 0
                      THEN NVL(B.PP1FECH, PD_FECPRO) - A.PPFPAG
                   ELSE 0
                 END) ATRACUM,
             COUNT(*) NROCUO
      FROM FSD601 A LEFT JOIN FSD602 B ON B.PGCOD  = A.PGCOD
                                      AND B.PPMOD  = A.PPMOD
                                      AND B.PPSUC  = A.PPSUC
                                      AND B.PPMDA  = A.PPMDA
                                      AND B.PPPAP  = A.PPPAP
                                      AND B.PPCTA  = A.PPCTA
                                      AND B.PPOPER = A.PPOPER
                                      AND B.PPSBOP = A.PPSBOP
                                      AND B.PPTOPE = A.PPTOPE
                                      AND B.PPFPAG = A.PPFPAG
                                      AND B.PPTIPO = A.PPTIPO
                                      AND B.PP1STAT = 'T'
                                      AND B.D602CO  = 'S'
                                      AND B.PP1FECH <= PD_FECPRO
      WHERE A.PPFPAG >= PD_FECINI
        AND A.PPFPAG <= PD_FECPRO
        AND A.D601CO = 'S'
        AND (A.PPCAP + A.PPINT ) > 0
        AND EXISTS (SELECT 1
                    FROM FSR008 R8,
                         FSD010 D10
                    WHERE D10.PGCOD = R8.PGCOD
                      AND D10.AOCTA = R8.CTNRO
                      AND D10.AOMOD IN (SELECT MODULO FROM FST111 WHERE DSCOD=50 AND MODULO NOT IN (29,120))
                      AND D10.AOMOD NOT IN (33,141,200)
                      AND D10.AOTOPE<>550
                      AND (CASE
                             WHEN D10.AOSTAT <> 99 THEN 1
                             WHEN (D10.AOSTAT = 99 AND D10.AOFE99 > TO_DATE('2013.06.30','RRRR.MM.DD')) THEN 1
                             ELSE 0
                           END
                          ) = 1
                      AND R8.PENDOC = RPAD(PC_NUMDOC,12,' ')
                      AND D10.PGCOD  = A.PGCOD
                      AND D10.AOMOD  = A.PPMOD
                      AND D10.AOSUC  = A.PPSUC
                      AND D10.AOMDA  = A.PPMDA
                      AND D10.AOPAP  = A.PPPAP
                      AND D10.AOCTA  = A.PPCTA
                      AND D10.AOOPER = A.PPOPER
                      AND D10.AOSBOP = A.PPSBOP
                      AND D10.AOTOPE = A.PPTOPE
                   )
    );
    RETURN NVL(LN_PROATR,0);
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END;
  
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
  
  function fn_capital_total(v_Pgcod  in number,
                            v_Scmod  in number,
                            v_Scsuc  in number,
                            v_Scmda  in number,
                            v_Scpap  in number,
                            v_Sccta  in number,
                            v_Scoper in number,
                            v_Scsbop in number,
                            v_Sctope in number
                            ) return number is
      ln_capital fsd011.scsdo%type;

    begin
               Select sum(nvl(a.ppcap,0))
                 into ln_capital
                 From FSD601 a
                where a.Pgcod  = v_Pgcod
                  and a.Ppmod  = v_Scmod
                  and a.Ppsuc  = v_Scsuc
                  and a.Ppmda  = v_Scmda
                  and a.Pppap  = v_Scpap
                  and a.Ppcta  = v_Sccta
                  and a.Ppoper = v_Scoper
                  and a.Ppsbop = v_Scsbop
                  and a.Pptope = v_Sctope
                  and a.D601co = 'S'
                  and (a.ppcap + a.ppint ) > 0
                  and a.ppcap > 0;
        Return ln_capital;
  exception when others then
            Return null;
  end fn_capital_total;

  function fn_capdeu_cuoven(v_Pgfape in date, --fecha de proceso
                                     v_Pgcod  in number,
                                     v_Scmod  in number,
                                     v_Scsuc  in number,
                                     v_Scmda  in number,
                                     v_Scpap  in number,
                                     v_Sccta  in number,
                                     v_Scoper in number,
                                     v_Scsbop in number,
                                     v_Sctope in number
                                   ) return number is

      ln_capven fsd011.scsdo%type;

    begin
          begin
            --vigente y refinanciado
            Select sum(nvl(ppcap,0)-nvl(cappga,0))
              Into ln_capven
              From (
            Select a.ppfpag,
                    case when a.ppcap < 0 then 0 else a.ppcap end ppcap,
                   sum(nvl(b.pp1cap,0))cappga
              From FSD601 a left join FSD602 b on b.Pgcod  = a.Pgcod
                                            and b.Ppmod  = a.Ppmod
                                            and b.Ppsuc  = a.Ppsuc
                                            and b.Ppmda  = a.Ppmda
                                            and b.Pppap  = a.Pppap
                                            and b.Ppcta  = a.Ppcta
                                            and b.Ppoper = a.Ppoper
                                            and b.Ppsbop = a.Ppsbop
                                            and b.Pptope = a.Pptope
                                            and b.Ppfpag = a.Ppfpag
                                            and b.Pptipo = a.Pptipo
                                            --and b.pp1cap >= 0
                                            --and b.Pp1stat = 'T'
                                            and b.D602co  = 'S'
                                            and b.pp1fech <= v_Pgfape
            where a.Pgcod  = v_Pgcod
              and a.Ppmod  = v_Scmod
             -- and a.Ppsuc  = v_Scsuc
              and a.Ppmda  = v_Scmda
              and a.Pppap  = v_Scpap
              and a.Ppcta  = v_Sccta
              and a.Ppoper = v_Scoper
              and a.Ppsbop = v_Scsbop
              and a.Pptope = v_Sctope
              and a.Ppfpag <= v_Pgfape
              and a.D601co = 'S'
              and (a.ppcap + a.ppint ) > 0
              --and a.ppcap > 0
           Group by a.ppfpag,a.ppcap   
            );
              
        exception when others then
                  ln_capven := null;
        end;
        
        Return ln_capven;
  end fn_capdeu_cuoven;
  
  function fn_cant_cuoxven(v_Pgcod  in number,
                           v_Scmod  in number,
                           v_Scsuc  in number,
                           v_Scmda  in number,
                           v_Scpap  in number,
                           v_Sccta  in number,
                           v_Scoper in number,
                           v_Scsbop in number,
                           v_Sctope in number
                          ) return number is
      ln_cuoxven number(10);
  begin
           select count(*) 
             into ln_cuoxven
             from FSD601 a 
            where a.Pgcod  = v_Pgcod
              and a.Ppmod  = v_Scmod
              and a.Ppsuc  = v_Scsuc
              and a.Ppmda  = v_Scmda
              and a.Pppap  = v_Scpap
              and a.Ppcta  = v_Sccta
              and a.Ppoper = v_Scoper
              and a.Ppsbop = v_Scsbop
              and a.Pptope = v_Sctope
              and a.D601co = 'S'
              and not exists (select 1 from FSD602 b where  b.Pgcod  = a.Pgcod
                                            and b.Ppmod  = a.Ppmod
                                            and b.Ppsuc  = a.Ppsuc
                                            and b.Ppmda  = a.Ppmda
                                            and b.Pppap  = a.Pppap
                                            and b.Ppcta  = a.Ppcta
                                            and b.Ppoper = a.Ppoper
                                            and b.Ppsbop = a.Ppsbop
                                            and b.Pptope = a.Pptope
                                            and b.Ppfpag = a.Ppfpag
                                            and b.Pptipo = a.Pptipo
                                            --and b.pp1fech <= trunc(sysdate)
                                            and b.Pp1stat = 'T'
                                            and b.D602co  = 'S'
                              );  
              return ln_cuoxven;                
                              
  exception when others then
            return null;
  end fn_cant_cuoxven;

  function fn_fecha_solicitudxinst_min (ln_instancia  in xwf700.xwfprcins%type,
                                        p_estado in number            
                                       ) return date
  is
  --Retorna la fecha de creacion de una estado  
  /*
    3    solicitud
    7    evaluacion
    11   aprobacion
    55   desembolso
  */  

  ld_fecsol date;        
              
  begin
    
     begin    
          SELECT 
                 case when trunc(u.WFITEMINIT)= to_date('0001.01.01','rrrr.mm.dd') 
                      then trunc(u.wfitemend)
                      else trunc(u.WFITEMINIT)
                 end       
                 into ld_fecsol
          FROM 
                 wfwrkitems u 
          where  
                 u.wftaskcod = p_estado    
             and u.wfitemid = (select min(s.wfitemid) from wfwrkitems s where s.wfinsprcid=u.wfinsprcid and s.wftaskcod = p_estado)
             and u.wfinsprcid=ln_instancia;
     exception when others then                                     
               ld_fecsol:= null;
     end;       

     return ld_fecsol;   
      
  end fn_fecha_solicitudxinst_min;  

  function fn_tipcli (P_NDOC in char, P_FECPRO in date) return varchar2 is
    ln_crecan number(4);
    ln_crevig number(4);
    ld_feccan date;
  Begin
    Begin
      select count(case when d.aostat = 99 and d.aofe99<=P_FECPRO then 1 end) n_CreCan,
             count(case when d.aostat <> 99 or (d.aostat = 99 and d.aofe99>P_FECPRO) then 1 end) n_CreVig,
             max(d.aofe99) d_maxcan
             into ln_crecan,ln_crevig,ld_feccan
        from fsr008 r 
        join fsd010 d 
          on d.pgcod = r.pgcod
         and d.aocta = r.ctnro
         and r.ttcod = 1
         and r.cttfir = 'T'
         and d.aomod in (select modulo from fst111 where dscod = 50 and modulo not in (29,120,108) union all select 117 from dual)
       where r.pendoc in (P_NDOC)
         and d.aofval < P_FECPRO;
    Exception When Others Then
      ln_CreCan := 0;
      ln_CreVig := 0;
      ld_feccan := null;
    End;
      IF ln_crevig = 0 and  ln_crecan>0 and P_FECPRO - ld_feccan>=15 THEN
          return 'I';
      ELSIF ln_crevig = 0 and ln_crecan = 0 then
          return 'N';
      ELSIF ln_crevig >0  or ln_crecan>=0 then
          returN 'R';
      End IF;
  end fn_tipcli;

  function fn_ult_tipcre( lv_rowid varchar2
                         ) return varchar2
  is
    lv_rubro varchar2(4000);
    ln_mod number;
  begin
    begin
      select substr(d11.scrub,5,2)||substr(d11.scrub,11,3), d10.aomod
        into lv_rubro, ln_mod
        from fsd010 d10 
        join fsd011 d11
          on d10.pgcod = d11.pgcod
         and d10.aomod = d11.scmod
         and d10.aosuc = d11.scsuc
         and d10.aomda = d11.scmda
         and d10.aopap = d11.scpap
         and d10.aocta = d11.sccta
         and d10.aooper = d11.scoper
         and d10.aosbop = d11.scsbop
         and d10.aotope = d11.sctope
       where d10.rowid = lv_rowid
         and substr(d11.scrub,1,4) in (1411,1414,1415,1416, 1421,1424,1425,1426) 
         and d11.scstat <>99;

    exception when no_data_found then
      --select substr(d11.scrub,5,2)||substr(d11.scrub,11,3), d10.aomod
        select max(substr(d11.scrub,5,2)||substr(d11.scrub,11,3)) keep (dense_rank last order by -d11.scsdo),
               max(d10.aomod) keep (dense_rank last order by -d10.aomod)
        into lv_rubro, ln_mod
        from fsd010 d10 
        join fsd011 d11
          on d10.pgcod = d11.pgcod
         and d10.aomod = d11.scmod
         --and d10.aosuc = d11.scsuc
         and d10.aomda = d11.scmda
         and d10.aopap = d11.scpap
         and d10.aocta = d11.sccta
         and d10.aooper = d11.scoper
         --and d10.aosbop = d11.scsbop
         and d10.aotope = d11.sctope
       where d10.rowid = lv_rowid
         and substr(d11.scrub,1,4) in (1411,1414,1415,1416, 1421,1424,1425,1426);
    end;

  return (case when ln_mod =107 then 'CONVENIO'   
               when substr(lv_rubro,1,2) = '03' then 'CONSUMO'
               when substr(lv_rubro,1,2) = '04' then 'HIPOTECARIO'
               when substr(lv_rubro,1,2) in ('02','12','13') then 'PYME'
               else null
           end);
  exception when no_data_found then
      return null;
  end fn_ult_tipcre;
  
  function fn_instancia_credito(  v_Scmod  in number,
                                  v_Scsuc  in number,
                                  v_Scmda  in number,
                                  v_Scpap  in number,
                                  v_Sccta  in number,
                                  v_Scoper in number,
                                  v_Scsbop in number,
                                  v_Sctope in number
                                ) return number is
      ln_instancia number(10);

  begin
    If v_Scmod = 116 THEN
      Begin
        select max(xw2.xwfprcins)
          into ln_instancia
          From Fsr011 rel  join   xwf700 xw2 on xw2.xwfempresa   = rel.r2cod
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
           and rel.r1suc = v_Scsuc
           and rel.r1mda = v_Scmda
           and rel.r1pap = v_Scpap
           and rel.r1cta = v_Sccta
           and rel.r1oper= v_Scoper
           and rel.r1sbop= v_Scsbop
           and rel.r1tope= v_Sctope;
           If nvl(ln_instancia,0) = 0 Then
            Begin
                select max(xw2.xwfprcins)
                  into ln_instancia
                  From Fsr011 rel  join   xwf700 xw2 on xw2.xwfempresa   = rel.r2cod
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
         End IF;
      End;
    Else
      Begin
          select xw2.xwfprcins
            into ln_instancia
            from   xwf700 xw2
           where xw2.xwfempresa   = 1
             and xw2.xwfsucursal  = v_Scsuc
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
                              from   xwf700 xw2
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
                              from   xwf700 xw2
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
                                    from   xwf700 xw2
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
      End;

      --2015.11.23 cuando instancia es 0 verificar si es judicial
      if nvl(ln_instancia,0) = 0 and v_Scmod in (200,33) then
        begin
             select max(xw2.xwfprcins)
               into ln_instancia
               From Fsr011 rel  join   xwf700 xw2 on xw2.xwfempresa   = rel.r2cod
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
                and rel.r1suc = v_Scsuc
                and rel.r1mda = v_Scmda
                and rel.r1pap = v_Scpap
                and rel.r1cta = v_Sccta
                and rel.r1oper= v_Scoper
                and rel.r1sbop= v_Scsbop
                and rel.r1tope= v_Sctope;
         --2016.08.09
        if nvl(ln_instancia,0) = 0 then
            begin
                 select max(xw2.xwfprcins)
                   into ln_instancia
                   From Fsr011 rel  join   xwf700 xw2 on xw2.xwfempresa = rel.r2cod
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
                    and rel.r1sbop= v_Scsbop
                    and rel.r1tope= v_Sctope;
           exception when no_Data_found then
              ln_instancia := 0;
            end;
          end if;
        end;
      end if;
    End IF;

    if nvl(ln_instancia,0) = 0 then
       Begin
         select max(xw2.xwfprcins)
           into ln_instancia
           from xwf700 xw2
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

  function fn_analista_credito(  v_Scmod  in number,
                                 v_Scsuc  in number,
                                 v_Scmda  in number,
                                 v_Scpap  in number,
                                 v_Sccta  in number,
                                 v_Scoper in number,
                                 v_Scsbop in number,
                                 v_Sctope in number
                               ) return varchar2 is

     /*  2015.11.23 DCASTRO Se agrego condicion cuando instancia es 0 y es judicial, castigado - busca en FSR011 */
     /* 2016.06.09 DCASTRO Se agrego condicion cuando instancia es 0 es judicial y proviene de una linea*/

      lc_analista fst046.ubuser%type;
      ln_instancia number(10);
      ln_lote fpp175.pp174cod%type;

    begin

      --para prendario nombre del tasador
     if (v_Scmod = 108) then
       begin
        SELECT max(pp174cod)
               into ln_lote
        FROM fpp175 d
        where
             d.pp175suc  = v_Scsuc
         and d.pp175mda  = v_Scmda
         and d.pp175pap  = v_Scpap
         and d.pp175cta  = v_Sccta
         and d.pp175oper = v_Scoper
         and d.pp175sbop = v_Scsbop
         and d.pp175mod  = v_Scmod
         and d.pp175tope = v_Sctope;
      exception
        when no_data_found then
             ln_lote := null;
       end;

        begin
         select max(substr(pp178dtext,1,10))
                into lc_analista
         from fpp178
         where
              pp174cod = ln_lote
          and pp177codd = 7;
        exception
          when no_data_found then
               lc_analista := null;
        end;
     else
         If v_Scmod = 116 THEN
            Begin
                  select max(xw2.xwfprcins)
                    into ln_instancia
                    From Fsr011 rel  join   xwf700 xw2 on xw2.xwfempresa   = rel.r2cod
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
                     and rel.r1suc = v_Scsuc
                     and rel.r1mda = v_Scmda
                     and rel.r1pap = v_Scpap
                     and rel.r1cta = v_Sccta
                     and rel.r1oper= v_Scoper
                     and rel.r1sbop= v_Scsbop
                     and rel.r1tope= v_Sctope;
                     If nvl(ln_instancia,0) = 0 Then
                      Begin
                          select max(xw2.xwfprcins)
                            into ln_instancia
                            From Fsr011 rel  join   xwf700 xw2 on xw2.xwfempresa   = rel.r2cod
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
                   End IF;
            End;

         Else
             Begin
                 select xw2.xwfprcins
                   into ln_instancia
                   from   xwf700 xw2
                  where xw2.xwfempresa   = 1
                    and xw2.xwfsucursal  = v_Scsuc
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
                                     from   xwf700 xw2
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
                                     from   xwf700 xw2
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
                                           from   xwf700 xw2
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

             --2015.11.23 cuando instancia es 0 verificar si es judicial
             if nvl(ln_instancia,0) = 0 and v_Scmod in (200,33) then
                 begin
                      select max(xw2.xwfprcins)
                        into ln_instancia
                        From Fsr011 rel  join   xwf700 xw2 on xw2.xwfempresa   = rel.r2cod
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
                         and rel.r1suc = v_Scsuc
                         and rel.r1mda = v_Scmda
                         and rel.r1pap = v_Scpap
                         and rel.r1cta = v_Sccta
                         and rel.r1oper= v_Scoper
                         and rel.r1sbop= v_Scsbop
                         and rel.r1tope= v_Sctope;
                  --2016.08.09        
                 if nvl(ln_instancia,0) = 0 then 
                     begin        
                          select max(xw2.xwfprcins)
                            into ln_instancia
                            From Fsr011 rel  join   xwf700 xw2 on xw2.xwfempresa   = rel.r2cod  
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
                             and rel.r1sbop= v_Scsbop
                             and rel.r1tope= v_Sctope;
                    exception when no_Data_found then
                       ln_instancia := 0;       
                     end;        
                   end if;  
                 end; 
                 --2016.08.09   


             end if;
             --2015.11.23

         End IF;
         if nvl(ln_instancia,0) = 0 then
            Begin
              select max(xw2.xwfprcins)
                into ln_instancia
                from xwf700 xw2
               where xw2.xwfempresa   = 1
                 and xw2.xwfsucursal  = v_Scsuc
                 and xw2.xwfmoneda    = v_Scmda
                 and xw2.xwfpapel     = v_Scpap
                 and xw2.xwfcuenta    = v_Sccta
                 and xw2.xwfoperacion = v_Scoper;
             end;
         end if;

         If ln_instancia is not null then
             Begin
                   select sng001ase
                     into lc_analista
                     from sng001  --Cambiar la tabla para producción
                    where sng001inst =  ln_instancia;
             Exception when no_data_found then
                        lc_analista := null;
             end;
         End If;
       end if;
    return lc_analista;
  end fn_analista_credito;
  procedure sp_tracli (ps_corcli number, ps_usuant varchar2, ps_usuact varchar2)
  -- *****************************************************************
  -- Nombre                     : sp_tracli
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 12/04/2017
  -- Autor de Creación          : BDEG
  -- Uso                        : Transferencia de clientes
  -- Estado                     : Activo
  -- Fecha Modificación         :
  -- Autor de Modificación      :
  -- Descripcion Modificacion   :
  -- *****************************************************************  
as
ln_corasi number;
ln_corage number;
ln_paicli number;
ln_tipdoc number;
ln_codact number;
ls_numdoc varchar(12);
begin
 
 select npaicli,
        ntipdoc,
        cnumdoc,
        ncodact
   into ln_paicli,ln_tipdoc,ls_numdoc,ln_codact
   from acdasig 
  where ncorcli = ps_corcli;

  select asi.ncorasi,
         age.ncorage 
    into ln_corasi,ln_corage
    from acdasig asi
    left join acdagen age
    on age.ncorasi = asi.ncorasi
  where asi.ncorcli =ps_corcli;
  
  insert into acdtran
    select nidebas,
           nidepro,
           ncoding,
           ncodact,
           ncodbas,
           npaicli,
           ntipdoc,
           cnumdoc,
           upper(ps_usuant),
           upper(ps_usuact),
           dfeceva,
           sysdate
    from (
    select * from acdeval where ncorcli = ps_corcli
    union
    select * from acheval where ncorcli = ps_corcli)
   where ncorcli = ps_corcli;
  commit;

   insert into achasig
       select nidebas,
              nidepro,
              ncoding,
              ncodact,
              ncodbas,
              npaicli,
              ntipdoc,
              cnumdoc,
              cestado,
              sysdate,
              dfecasi,
              ccodusu,
              cusuasi,
              chorasi,
              cusumod,
              dfecmod,
              nindasi,
              ncorcli,
              ncorasi
        from acdasig
       where ncorasi = ln_corasi;
       commit;
       
       delete acdasig 
       where  npaicli = ln_paicli 
         and ntipdoc = ln_tipdoc 
         and cnumdoc = ls_numdoc
         and ncodact = ln_codact;
       commit;
       
       insert into acdasig
        select nidebas,
               nidepro,
               ncoding,
               ncodact,
               ncodbas,
               npaicli,
               ntipdoc,
               cnumdoc,
               '1',
               to_char(sysdate,'yyyy/mm/dd'),
               ps_usuact,
               'SYSADM',
               to_char(sysdate,'hh24:mi:ss'),
               'SYSADM',
               sysdate,
               0,
               ncorcli,
               SEQ_CORASI.NEXTVAL
          from 
          (
               select * from acdeval where ncorcli = ps_corcli and npaicli = ln_paicli and ntipdoc = ln_tipdoc and ls_numdoc = ls_numdoc
               union
               select * from acheval where ncorcli = ps_corcli and npaicli = ln_paicli and ntipdoc = ln_tipdoc and ls_numdoc = ls_numdoc
               ) 
         where ncorcli = ps_corcli;
             commit;      
             
  if (ln_corasi is not null) then
       update acdagen
          set cestado = '2'
        where ncorasi = ln_corasi;
        commit;
     
  end if;
  exception
      when no_data_found then
           ln_corasi :=0;
      when others then
           ln_corasi :=0;
end sp_tracli;



procedure sp_insvis (ps_codpai number,ps_tipdoc number, ps_numdoc varchar2,ps_codact number,
                     ps_codusu varchar2,ps_codres number)
  -- *****************************************************************
  -- Nombre                     : sp_insvis
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 23/12/2016
  -- Autor de Creación          : BDEG
  -- Uso                        : Insertar resultado de visita
  -- Estado                     : Activo
  -- Fecha Modificación         : 02/09/2025
  -- Autor de Modificación      : Sergio Gamero
  -- Descripcion Modificacion   : Se elimina trim de resutaldo de visita
  -- *****************************************************************  
as  

ls_tipcas number;
ln_indbas number;
ln_indpro number;
ln_inding number;
ln_indact number;
ln_codbas number;
ln_corage number;
ld_fecage date;
ln_codpre number;
ln_codfec number;
ln_codobs number;
ps_codvis char(10);
ps_desobs varchar2(100);
ls_horvis char(5);
begin  
      
  select 
  case when to_char(sysdate,'hh24') =23 then '00:00' else 
    case when to_char(sysdate,'hh24')+1 < 10 then 
      cast('0' as char(1))||cast(to_char(sysdate,'hh24')+1 as char(1)) ||':00' 
      else  to_char(sysdate,'hh24')+1 ||':00' end 
   end 
   into ls_horvis
  from dual;

  select to_char(sysdate,'YYYY-MM-DD'),'Envio Proceso automatico'
    into ps_codvis,ps_desobs
    from dual;

  select ncorage,
         nidebas,
         nidepro,
         ncoding,
         ncodact,
         ncodbas
    into ln_corage,ln_indbas,ln_indpro,ln_inding,ln_indact,ln_codbas
    from acdagen
   where npaicli = ps_codpai
     and ntipdoc = ps_tipdoc
     and cnumdoc = trim(ps_numdoc)
     and ncodact = ps_codact
     and cestado = '1';
   commit;
   
   
   insert into ACHREVI  
   select * 
     from acdrevi
    where npaicli = ps_codpai
      and ntipdoc = ps_tipdoc
      and cnumdoc = trim(ps_numdoc)
      and ncodact = ps_codact
      and cestado = '1';
   commit;
   delete ACDREVI
    where npaicli = ps_codpai
      and ntipdoc = ps_tipdoc
      and cnumdoc = trim(ps_numdoc)
      and ncodact = ps_codact
      and cestado = '1';
   commit;   
   
   select nindcas 
     into ls_tipcas
     from acdresu
    where ncodres=ps_codres;
    

    
    if ls_tipcas ='2' then

    select npreres into ln_codpre from acdprre where ncodres=ps_codres;
    select nrespue into ln_codobs from acdrepu where npreres=ln_codpre and nrescod = 4; -- Observaciones
    select nrespue into ln_codfec from acdrepu where npreres=ln_codpre and nrescod = 6;-- Fecha

      insert into acdrevi values (ln_corage,ln_indbas,ln_indpro,ln_inding,ln_indact,ln_codbas,ps_codpai,ps_tipdoc,
         trim(ps_numdoc),ln_codfec,ps_codvis,'1',upper(ps_codusu),to_char(sysdate,'DD/MM/YYYY'),to_char(sysdate,'hh24:mm'),0,0);
         commit;
      insert into acdrevi values (ln_corage,ln_indbas,ln_indpro,ln_inding,ln_indact,ln_codbas,ps_codpai,ps_tipdoc,
         trim(ps_numdoc),ln_codobs,ps_desobs,'1',upper(ps_codusu),to_char(sysdate,'DD/MM/YYYY'),to_char(sysdate,'hh24:mm'),0,0);
         commit;
       select to_date(ps_codvis,'YYYY-MM-DD')
         into ld_fecage
         from dual;
    end if;  

    if ls_tipcas ='1' then
      select npreres into ln_codpre from acdprre where ncodres=ps_codres;
    select nrespue into ln_codobs from acdrepu where npreres=ln_codpre and nrescod = 4; -- Observaciones
    
      insert into acdrevi values (ln_corage,ln_indbas,ln_indpro,ln_inding,ln_indact,ln_codbas,ps_codpai,ps_tipdoc,
         trim(ps_numdoc),ln_codobs,ps_desobs,'1',upper(ps_codusu),to_char(sysdate,'DD/MM/YYYY'),to_char(sysdate,'hh24:mm'),0,0);    
         commit;
     
     update acdeval 
       set nindcier = '1'
      where nidebas = ln_indbas
        and nidepro = ln_indpro
        and ncoding = ln_inding
        and ncodact = ln_indact
        and ncodbas = ln_codbas
        and npaicli = ps_codpai
        and ntipdoc = ps_tipdoc
        and cnumdoc = trim(ps_numdoc);
      update acheval 
       set nindcier = '1'
      where nidebas = ln_indbas
        and nidepro = ln_indpro
        and ncoding = ln_inding
        and ncodact = ln_indact
        and ncodbas = ln_codbas
        and npaicli = ps_codpai
        and ntipdoc = ps_tipdoc
        and cnumdoc = trim(ps_numdoc);   
     
        commit;
    end if;
    
    if ls_tipcas <> 2 then
      update acdagen
         set cestado='2'
       where npaicli = ps_codpai
         and ntipdoc = ps_tipdoc
         and cnumdoc = trim(ps_numdoc)
         and ncodact = ln_indact
         and cestado = '1';
      commit;
   else
     update acdagen
        set dfecmod = sysdate,
            cusumod = upper(trim (ps_codusu)),
            cestado = '2'
     where npaicli = ps_codpai
       and ntipdoc = ps_tipdoc
       and cnumdoc = trim(ps_numdoc)
       and ncodact = ln_indact
       and cestado = '1';
       commit;
       
       insert into achagen
         select * 
           from acdagen
          where npaicli = ps_codpai
            and ntipdoc = ps_tipdoc
            and cnumdoc = ps_numdoc
            and ncodact = ln_indact;
         commit;
         
         
         delete acdagen
          where npaicli = ps_codpai
            and ntipdoc = ps_tipdoc
            and cnumdoc = trim(ps_numdoc)
            and ncodact = ln_indact;
           commit; 
           
       
        insert into acdagen 
        select supplier_seq.NEXTVAL,
               nidebas,
               nidepro,
               ncoding,
               ncodact,
               ncodbas,
               npaicli,
               ntipdoc,
               cnumdoc,
               '1',
               to_char(sysdate,'DD/MM/YYYY'),
               dfecasi,
               trunc(sysdate),
               ls_horvis,
               ps_codusu,
               ps_codusu,
               sysdate,
               '0',
               ncorasi,
               0,
               0
        from acdasig
   where npaicli = ps_codpai
     and ntipdoc = ps_tipdoc
     and cnumdoc = trim(ps_numdoc)
     and ncodact = ln_indact;
     commit;      
   end if;
   exception
      when no_data_found then
           ln_indact :=0;
      when others then
           ln_indact :=0;   
 end sp_insvis;
 
 procedure sp_genera_campana is
  begin
      
    insert /*+append*/ into acdbase_temp (nidebas,nidepro,ncoding,ncodact,ncodbas,cestado,
                                     nnumpas,ntipdoc,cnumdoc,npascon,ntipcon,cdoccon,
                                     cnombre,czonfij,cdirfij,creffij,czonneg,cdirneg,
                                     crefneg,ctelfij,ctelmov,ncodage,ncodana,cusuing,
                                     dfecing,ncodpri,
                                     nmonsol,cdespro,cestpro,cinipro,cfinpro,nmonapr,nsalcap)
    select jaqz924idebas,jaqz924idepro,jaqz924coding,jaqz924codact,jaqz924codbas,jaqz924estado,--#REVISAR TI
           jaqz924numpas,jaqz924tipdoc,trim(jaqz924numdoc),jaqz924pascon,jaqz924tipcon,trim(jaqz924doccon),
           jaqz924nombre,jaqz924zonfij,jaqz924dirfij,jaqz924reffij,jaqz924zonneg,jaqz924dirneg,
           jaqz924refneg,jaqz924telfij,jaqz924telmov,jaqz924codage,trim(jaqz924codana),'SYSADM',
           sysdate,1,
           jaqz924monsol,jaqz924despro,jaqz924estpro,jaqz924inipro,jaqz924finpro,jaqz924monapr,jaqz924salcap
      from jaqz924;
    commit;
  end sp_genera_campana;
  
END pq_datos_bases;
/
