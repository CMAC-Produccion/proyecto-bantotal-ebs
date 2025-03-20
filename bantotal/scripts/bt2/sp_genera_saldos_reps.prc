create or replace procedure "SP_GENERA_SALDOS_REPS"(P_FECHA in date)
is
	lv_query  varchar2(1000);
	lv_bcemp  fsh012.bcemp%type;
	lv_bcmod  fsh012.bcmod%type;
	lv_bcsuc  fsh012.bcsuc%type;
	lv_bcmda  fsh012.bcmda%type;
	lv_bcpap  fsh012.bcpap%type;
	lv_bccta  fsh012.bccta%type;
	lv_bcoper fsh012.bcoper%type;
	lv_bcsbop fsh012.bcsbop%type;
	lv_bctop  fsh012.bctop%type;   
	ld_fecnue date;
	ln_messeg number(2);
	ln_aniseg number(4);

  Cursor agencias
		 Is select sucurs
	 				from /*pvargas.*/regsuc;

  Cursor dias (ln_codage in number)
           Is select bcemp, bcsuc, bcmda, bcpap, bccta, bcoper, bcsbop, bctop, bcmod, bcprod, bcfvto,BCGpo,bcrubr
                from FSH012_BI
               where n_diaatr is null
                 and bcsuc = ln_codage;

  Cursor conv (ln_codage in number)
           Is select bcemp,bcsuc ,bcmda ,bcpap ,bccta ,bcoper,bcsbop,bctop ,bcmod,
                     bcemp_ori, bcmod_ori, bcsuc_ori, bcmda_ori, bcpap_ori, bccta_ori,
										 bcoper_ori,bcsbop_ori, bctop_ori
                from FSH012_BI
                where bcsuc = ln_codage
                  and producto='CONVENIO CON DESCUENTO POR PLANILLA';

   Cursor orig (ln_codage in number)
           Is select bcemp,bcmod,bcsuc,bcmda,bcpap,bccta,bcoper,bcsbop,bctop,
                     bcemp_ori,bcmod_ori,bcsuc_ori,bcmda_ori,bcpap_ori,bccta_ori,bcoper_ori,bcsbop_ori,bctop_ori,pepais,petdoc,pendoc,bcrubr
                from FSH012_BI
               where d_fecsol is null
                 and bcsuc = ln_codage;   
								 
 Cursor peque (ln_codage in number)
           Is select bcemp, bcsuc, bcmda, bcpap, bccta, bcoper, bcsbop, bctop, bcmod, bcprod, bcfvto,BCGpo,bcrubr,numins
                from FSH012_BI 
                where c_tipcre like 'PEQU%' and sector is null
                  and sector is null
                  and bcsuc=ln_codage;								 

	nreg number(5) := 0;
	ld_fecval date;

BEGIN
    begin
	  sys.sp_sy_enviamail('ehidalgom@cajaarequipa.pe','ehidalgom@cajaarequipa.pe','Inicio Ejecución sp_genera_saldos_reps','BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||'Hora Actual en Servidor : '|| to_char(sysdate,'HH24:MI:SS') ||CHR(13)||'Inicio Sp_genera_saldos_reps.');          
    exception when others then null;
    end;
	  --ACTUALIZAR REGSUC 2016.02.01 ebegazo
		begin
      update REGSUC rs
         set rs.scnom = (select initcap(trim(t.scnom))
                           from fst001 t
                          where t.sucurs = rs.sucurs
                        ),
             rs.regcod = NVL((
                            select gr.tp1nro1
                              from fst001 t left join fst811 t81 on t81.pgcod = t.pgcod
                                                              and t81.oficod = t.sucurs
                                                              and t81.regcod < 100
                                               left join fst810 t80 on t80.pgcod = t81.pgcod
                                                              and t80.regcod= t81.regcod                                       
                                               left join FST198 gr 
                                                                 on gr.TP1COD=1 
                                                                and gr.TP1COD1=10872 
                                                                and gr.TP1CORR1=11
                                                                and gr.tp1nro2 = t80.regcod                  
                              where t.sucurs = rs.sucurs       
                              
                         ),0),
             rs.regnom = (
                            select initcap(trim(gr.tp1desc))
                              from fst001 t left join fst811 t81 on t81.pgcod = t.pgcod
                                                              and t81.oficod = t.sucurs
                                                              and t81.regcod < 100
                                               left join fst810 t80 on t80.pgcod = t81.pgcod
                                                              and t80.regcod= t81.regcod                                       
                                               left join FST198 gr 
                                                                 on gr.TP1COD=1 
                                                                and gr.TP1COD1=10872 
                                                                and gr.TP1CORR1=11
                                                                and gr.tp1nro2 = t80.regcod                  
                              where t.sucurs = rs.sucurs        
                         ),
             rs.codzon = (
                            select t80.regcod
                              from fst001 t left join fst811 t81 on t81.pgcod = t.pgcod
                                                              and t81.oficod = t.sucurs
                                                              and t81.regcod < 100
                                               left join fst810 t80 on t80.pgcod = t81.pgcod
                                                              and t80.regcod= t81.regcod                                       
                                               left join FST198 gr 
                                                                 on gr.TP1COD=1 
                                                                and gr.TP1COD1=10872 
                                                                and gr.TP1CORR1=11
                                                                and gr.tp1nro2 = t80.regcod                  
                              where t.sucurs = rs.sucurs                      
                         ),
             rs.deszon = (
                            select initcap(trim(t80.regnom))
                              from fst001 t left join fst811 t81 on t81.pgcod = t.pgcod
                                                              and t81.oficod = t.sucurs
                                                              and t81.regcod < 100
                                               left join fst810 t80 on t80.pgcod = t81.pgcod
                                                              and t80.regcod= t81.regcod                                       
                                               left join FST198 gr 
                                                                 on gr.TP1COD=1 
                                                                and gr.TP1COD1=10872 
                                                                and gr.TP1CORR1=11
                                                                and gr.tp1nro2 = t80.regcod                  
                              where t.sucurs = rs.sucurs       
                         );
      commit;                                                                  

		exception when others then
			  null;
		End; 

    begin
      insert into REGSUC(regcod,regnom,sucurs,scnom,codzon,deszon)
      select nvl(gr.tp1nro1,0) region,
             initcap(trim(gr.tp1desc)) nom_region,     
             t.sucurs, initcap(trim(t.scnom))scnom,
             t80.regcod,initcap(trim(t80.regnom))regnom
        from fst001 t left join fst811 t81 on t81.pgcod = t.pgcod
                                            and t81.oficod = t.sucurs
                                            and t81.regcod < 100
                             left join fst810 t80 on t80.pgcod = t81.pgcod
                                            and t80.regcod= t81.regcod                                       
                             left join FST198 gr 
                                               on gr.TP1COD=1 
                                              and gr.TP1COD1=10872 
                                              and gr.TP1CORR1=11
                                              and gr.tp1nro2 = t80.regcod                  
        where /*t.sucurs  in (
                                SELECT distinct bcsuc FROM bantprod.fsh012_bi 
                            )
          and*/ t.sucurs not in (select sucurs from regsuc)                    
          and t.sucurs<800;   
      commit;			  
      
		exception when others then
			  null;
		End;       
    
    --Actualizacion de ubigeos 2016.03.23 ebegazo
    begin

      --- ACTUALIZA CODIGO DE UBIGEO
      update regsuc r set r.ubig = (select trim(u.bc206chr1)
                                      from fbc206 u
                                     where u.bc205cod=412 
                                       and u.bc206id1 = r.sucurs
                                    );        
        
      --- ACTUALIZA DESCRIPC UBIGEOS
      update regsuc t set (t.dpto,t.prov,t.dist) = (
                                                    select c_desdpt,c_despro,c_desdis
                                                      from (
                                                              select lpad(t71.fst071col,6,'0') c_codubi, trim(depnom) c_desdpt,trim(locnom) c_despro,trim(t71.fst071dsc) c_desdis
                                                                 from fst068 t68
                                                                      left join fst070 t70
                                                                      on t70.pais = t68.pais
                                                                      and t70.depcod = t68.depcod
                                                                      left join fst071 t71
                                                                      on t71.fst071pai = t68.pais
                                                                      and t71.fst071dpt = t68.depcod
                                                                      and t71.fst071loc = t70.loccod
                                                                 where t68.pais=604 
                                                           )
                                                    where substr(c_codubi,1,6) = t.ubig  
                                                   );    
      commit;  		  
      
		exception when others then
			  null;
		End;     
	

    --- ELIMINA TABLA DIA ANTERIOR
		begin
			   lv_query := 'truncate table FSH012_BI';
		     execute immediate lv_query;
		exception when others then
			  null;
		End;
    
    execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
    
    --estadisticas
    begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                    tabname          => 'FSH012_BI',
                                    degree           => 16,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;
    
    
		--- CREA TABLA FSH012
		lv_query := 'Insert Into FSH012_BI ('||
		            'bcemp, bcsuc, bcrubr, bcmda, bcpap, bccta, bcoper, bcsbop, bctop, bcfech,'||
								'bctit, bccap, bcpzo, bcsist, bcmod, bcfvto, bcfval, bcplaz, bcttasa, bctasa,'||
								'bcclta, bctdia, bctano, bcresi, bccate, bcacti, bcprod, bcticu, bctipp,'||
								'bcfatr, bcsdor, bcsdmn, bcsdus, bcsdmo, bcint, bcprev, bcgpo) '||
---		            'select bcemp, bcsuc, bcrubr, bcmda, bcpap, bccta, bcoper, bcsbop, '||
                'select /*+all_rows parallel(d,12)*/ bcemp, bcsuc, bcrubr, bcmda, bcpap, bccta, bcoper, bcsbop, '||
								'bctop, bcfech,bctit, bccap, bcpzo, bcsist, bcmod, bcfvto, bcfval, bcplaz,'|| 
								'bcttasa, bctasa,bcclta, bctdia, bctano, bcresi, bccate, bcacti, bcprod, '||
								'bcticu, bctipp,bcfatr, bcsdor, bcsdmn, bcsdus, bcsdmo, bcint, bcprev,'||
								'bcgpo from fsh012 d '||
								'where substr(d.bcrubr,1,4) in (1411,1421,1414,1424,1415,1425,1416,1426) '||
								'and d.bcprod <> 99 and d.bccta <> 999999999 '||
								'and d.bcfech = :1';

		 execute immediate lv_query using P_FECHA;
     commit;          
		 
    ----- ELIMINA INDICE
		BEGIN       
			   execute immediate 'drop index IX_FSH012_D1';
		EXCEPTION WHEN OTHERS THEN   
			 null;
		END;		
		----- CREA INDICE
/*    lv_query := 'create index IX_FSH012_D1 on FSH012_BI'||
		            '(bcemp, bcsuc, bcmda, bcpap, bccta, bcoper, bcsbop, bctop, bcmod)';                        */
    BEGIN   						
        lv_query := 'create index IX_FSH012_D1 on FSH012_BI'||
		                '(bcemp, bcsuc, bcmda, bcpap, bccta, bcoper, bcsbop, bctop, bcmod) tablespace bantprod_c_idx parallel 12 nologging';                        
     		execute immediate lv_query ;
        lv_query := 'alter index IX_FSH012_D1 parallel 1 logging'; 
        execute immediate lv_query ;
		EXCEPTION WHEN OTHERS THEN 
          begin
            sys.sp_sy_enviamail('ehidalgom@cajaarequipa.pe','ehidalgom@cajaarequipa.pe','ERROR Ejecución sp_genera_saldos_reps','BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||'Hora Actual en Servidor : '|| to_char(sysdate,'HH24:MI:SS') ||CHR(13)||'Error linea 93 Sp_genera_saldos_reps ejecutado.');            
          EXCEPTION WHEN OTHERS THEN
            null;
          end;
			 null;
		END;	
	  -- OTROGAR PRIVILEGIOS A USUARIOS
--    execute immediate 'grant select,update,insert, delete, alter,index on FSH012_BI to ebegazo';
--    execute immediate 'grant select,update,insert, delete, alter,index on FSH012_BI to pvargas';
    
    execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
    
    --estadisticas
    begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                    tabname          => 'FSH012_BI',
                                    degree           => 16,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;

    -- ULTIMA FECHA DE SEGMENTACION
		Begin 
				SELECT /*+ parallel(cal,12)*/  max(jaqy066pano) anio ,
				       max(jaqy066pmes) mes 
					INTO ln_aniseg,	ln_messeg	 
					FROM jaqy066 cal 
				 where cal.jaqy066pano = TO_NUMBER(TO_CHAR(P_FECHA,'RRRR'));
		Exception When Others Then
			 ln_aniseg := null;
			 ln_messeg := null; 
		End;		

			
    -- ACTUALIZA CAMPOS AGREGADOS
    For i in agencias Loop
       For x in dias(i.sucurs) Loop

					nreg := nreg + 1;

					lv_bcemp  := null;
          lv_bcmod  := null;
          lv_bcsuc  := null;
          lv_bcmda  := null;
          lv_bcpap  := null;
          lv_bccta  := null;
          lv_bcoper := null;
          lv_bcsbop := null;
          lv_bctop  := null;      

          If (x.bcmod = 200 or x.bctop = 550) Then
             /*ebegazo.*/pq_datos_credito.sp_credito_original(x.BCEMP,x.BCMOD,x.BCSUC,x.BCMDA,x.BCPAP,
						                                              x.BCCTA,x.BCOPER,x.BCSBOP,x.BCTOP,
                                                          lv_bcemp, lv_bcmod, lv_bcsuc, lv_bcmda,lv_bcpap,
																													lv_bccta,  lv_bcoper,  lv_bcsbop,  lv_bctop
                                                          );
					End If;



           Update FSH012_BI k
              Set --*************************************************************************************
                  --CONGELAMIENTO ATRASO COVID19 [JGOMEZP 04.04.2020]
                  /*k.n_diaatr = usrrepbi.REP_FN_DIAS_ATRASO_CVD19( V_PGFAPE => P_FECHA,
                                                         V_PGCOD  => x.bcemp,
                                                         V_SCMOD  => x.bcmod,
                                                         V_SCSUC  => x.bcsuc,
                                                         V_SCMDA  => x.bcmda,
                                                         V_SCPAP  => x.bcpap,
                                                         V_SCCTA  => x.bccta,
                                                         V_SCOPER => x.bcoper,
                                                         V_SCSBOP => x.bcsbop,
                                                         V_SCTOPE => x.bctop,
                                                         V_SCSTAT => x.bcprod,
                                                         V_FECVEN => x.bcfvto),*/
                  
                  k.n_diaatr = fn_dias_atraso(P_FECHA,x.bcemp,x.bcmod,x.bcsuc,
                                              x.bcmda,x.bcpap,x.bccta,x.bcoper,
                                              x.bcsbop,x.bctop,x.bcprod,x.bcfvto),
                  
                  --*************************************************************************************
                  k.c_codase = /*pvargas.*/fn_analista_credito(x.bcmod,x.bcsuc,x.bcmda,x.bcpap,x.bccta,x.bcoper,
                                                               x.bcsbop,x.bctop),
                  k.c_tipcre = (case  when x.BCGpo = 2 then 'MICRO EMPRESA'
                                      when x.BCGpo = 3 and substr(x.bcrubr,11,3)='015' then 'CONSUMO REVOLVENTE'
                                      when x.BCGpo = 3 and substr(x.bcrubr,11,3)<>'015' then 'CONSUMO NO REVOLVENTE'
                                      when x.BCGpo = 4 then 'HIPOTECARIO'
                                      when x.BCGpo = 12 then 'MEDIANA EMPRESA'
                                      when x.BCGpo = 13 then 'PEQUEÑA EMPRESA'
                                      when x.BCGpo = 11 then 'GRANDES EMPRESAS'
                                      when x.BCGpo = 9  then 'CORPORATIVO E.I.F.'
                                END),
                  (k.pepais,k.petdoc,k.pendoc) = (select r.pepais,r.petdoc,r.pendoc
                                                    from fsr008 r
                                                   where r.pgcod = x.bcemp
                                                     and r.ctnro = x.bccta
                                                     and r.ttcod = 1
                                                     and r.cttfir= 'T'),
                  k.numins = /*pvargas.*/fn_instancia_credito(x.bcmod,x.bcsuc,x.bcmda,x.bcpap,x.bccta,
									                                        x.bcoper,x.bcsbop,x.bctop),
                  k.bcemp_ori  = lv_bcemp,
                  k.bcmod_ori  = lv_bcmod,
                  k.bcsuc_ori  = lv_bcsuc,
                  k.bcmda_ori  = lv_bcmda,
                  k.bcpap_ori  = lv_bcpap,
                  k.bccta_ori  = lv_bccta,
                  k.bcoper_ori = lv_bcoper,
                  k.bcsbop_ori = lv_bcsbop,
                  k.bctop_ori  = lv_bctop
            Where k.bcemp = x.bcemp
              And k.bcsuc = x.bcsuc
              And k.bcmda = x.bcmda
              And k.bcpap = x.bcpap
              And k.bccta = x.bccta
              And k.bcoper= x.bcoper
              And k.bcsbop= x.bcsbop
              And k.bctop = x.bctop
              And k.bcmod = x.bcmod;

           If Mod(nreg,1000) = 0 Then
              Commit;
              nreg := 0;
           End If;

       End Loop;

     End Loop;
    commit;   
    
		--- ACTUALIZA SECTOR DE PEQUEÑA EMPRESA   
		nreg := 0;
    For i in agencias Loop
       For x in peque(i.sucurs) Loop
           nreg := nreg + 1;
           
           Update FSH012_BI k 
              Set k.sector = /*pvargas.*//*fn_sector_credito_bt(x.bcemp,x.bccta,
							                                         x.bcoper,x.numins)*/  --ebegazo 2016.02.02, se cambio de funcion
                             fn_sector_credito(P_FECHA,
                                                        x.bcemp,
                                                        x.bcmod,
                                                        x.bcsuc,
                                                        x.bcmda,
                                                        x.bcpap,
                                                        x.bccta,
                                                        x.bcoper,
                                                        x.bcsbop,
                                                        x.bctop
                                                        )    
            Where k.bcemp = x.bcemp  
              And k.bcsuc = x.bcsuc  
              And k.bcmda = x.bcmda  
              And k.bcpap = x.bcpap  
              And k.bccta = x.bccta  
              And k.bcoper= x.bcoper 
              And k.bcsbop= x.bcsbop 
              And k.bctop = x.bctop  
              And k.bcmod = x.bcmod;  
            
           If Mod(nreg,1000) = 0 Then
              Commit;
              nreg := 0;
           End If;
            
       End Loop;
      commit;
       
     End Loop;		

    ----- ELIMINA INDICE
		BEGIN       
			   execute immediate 'drop index IX_2_FSH012_D2';
		EXCEPTION WHEN OTHERS THEN   
			 null;
		END;	
		
    -- Creando indice PARA CONVENIOS      
		BEGIN
/*		execute immediate 'create index IX_2_FSH012_D2 on FSH012_BI (bcemp_ori, bcsuc_ori, '||
		                  'bcmda_ori, bcpap_ori, bccta_ori, bcoper_ori, bcsbop_ori, bctop_ori, bcmod_ori)';*/
		execute immediate 'create index IX_2_FSH012_D2 on FSH012_BI (bcemp_ori, bcsuc_ori, '||
		                  'bcmda_ori, bcpap_ori, bccta_ori, bcoper_ori, bcsbop_ori, bctop_ori, bcmod_ori) tablespace bantprod_c_idx parallel 12 nologging';
    execute immediate 'alter index IX_2_FSH012_D2 parallel 1 logging';                      
    EXCEPTION WHEN OTHERS THEN
         begin
              sys.sp_sy_enviamail('ehidalgom@cajaarequipa.pe','ehidalgom@cajaarequipa.pe','ERROR Ejecución sp_genera_saldos_reps','BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||'Hora Actual en Servidor : '|| to_char(sysdate,'HH24:MI:SS') ||CHR(13)||'Error linea 245 Sp_genera_saldos_reps ejecutado.');            
         EXCEPTION WHEN OTHERS THEN
              null;
         end;     
			   NULL;
	  END;
		
    --estadisticas
    begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                    tabname          => 'FSH012_BI',
                                    degree           => 16,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;
--26072021    
execute immediate 'ALTER SESSION SET "_optimizer_gather_stats_on_load" = FALSE';--26/07/2021
execute immediate 'ALTER session SET OPTIMIZER_ADAPTIVE_STATISTICS = TRUE';--26/07/2021    
			 
    --Actualizar numero de credito origen
    execute immediate 'Update FSH012_BI k Set '||
											'k.bcemp_ori   = bcemp,'||
											'k.bcmod_ori   = bcmod,'||
											'k.bcsuc_ori   = bcsuc,'||
											'k.bcmda_ori   = bcmda,'||
											'k.bcpap_ori   = bcpap,'||
											'k.bccta_ori   = bccta,'||
											'k.bcoper_ori  = bcoper,'||
											'k.bcsbop_ori  = bcsbop,'||
											'k.bctop_ori   = bctop where k.bcmod_ori is null';
    commit;

    ---- CREDITO ORIGINAL
		nreg := 0;
    For i in agencias Loop
       For x in orig(i.sucurs) Loop
           nreg := nreg + 1; 
					 ld_fecnue := to_date(to_char(P_FECHA,'rrrrmm')||'01','rrrrmmdd') ;
            begin
                 select d10.aofval
                   into ld_fecval
                   from fsd010 d10
                  where d10.pgcod = x.bcemp_ori
                    and d10.aomod = x.bcmod_ori
                    and d10.aomda = x.bcmda_ori
                    and d10.aopap = x.bcpap_ori
                    and d10.aocta = x.bccta_ori
                    and d10.aooper= x.bcoper_ori
                    and d10.aosbop= x.bcsbop_ori
                    and d10.aotope= x.bctop_ori;
            exception
              when others then
                  null;
             end;

           Update /*+parallel(k,8)*/ FSH012_BI k
              Set k.d_fecsol   = NVL(NVL(/*ebegazo.*/pq_datos_solicitud.fn_fecha_solicitudxinst_min(numins,3),
							                           /*ebegazo.*/pq_datos_solicitud.fn_fecha_solicitudxinst(numins,3)),ld_fecval),
                  k.c_tipcli   = case when /*ebegazo.*/pq_datos_solicitud.fn_tipo_credito_desem(x.pepais,x.petdoc,x.pendoc,ld_fecnue) = 1 Then 'Nuevo' Else 'Recurrente' end,
								  k.producto = /*ebegazo.*/pq_datos_credito.fn_producto_regcaja(P_FECHA,
                                                        x.BCEMP,x.BCMOD,x.BCSUC,
																												x.BCMDA,x.BCPAP,x.BCCTA,
																												x.BCOPER,x.BCSBOP,x.BCTOP,
																												x.bcrubr,x.pepais,x.petdoc,
																												x.pendoc,ln_aniseg,ln_messeg  

                                                      ) 									

             Where k.bcemp = x.bcemp
              And k.bcsuc = x.bcsuc
              And k.bcmda = x.bcmda
              And k.bcpap = x.bcpap
              And k.bccta = x.bccta
              And k.bcoper= x.bcoper
              And k.bcsbop= x.bcsbop
              And k.bctop = x.bctop
              And k.bcmod = x.bcmod;

           If Mod(nreg,1000) = 0 Then
              Commit;
              nreg := 0;
           End If;

       End Loop;
     end loop;

    commit;
    
    --ebegazo 2016.02.04, se movio despues del calculo del producto
    For i in agencias Loop
       For x in conv(i.sucurs) Loop
           nreg := nreg + 1;
           Update /*+parallel(k,8)*/FSH012_BI k
              Set k.cartconv = /*ebegazo.*/pq_datos_credito.fn_institucion_conv(x.BCEMP,x.BCMOD,x.BCSUC,x.BCMDA,
							                                                              x.BCPAP,x.BCCTA,x.BCOPER,x.BCSBOP,
																																						x.BCTOP,x.bcemp_ori, x.bcmod_ori,
																																						x.bcsuc_ori, x.bcmda_ori, x.bcpap_ori,
																																						x.bccta_ori, x.bcoper_ori,
																																						x.bcsbop_ori, x.bctop_ori
                                                                           )
              Where k.bcemp = x.bcemp
              And k.bcsuc = x.bcsuc
              And k.bcmda = x.bcmda
              And k.bcpap = x.bcpap
              And k.bccta = x.bccta
              And k.bcoper= x.bcoper
              And k.bcsbop= x.bcsbop
              And k.bctop = x.bctop
              And k.bcmod = x.bcmod;

           If Mod(nreg,1000) = 0 Then
              Commit;
              nreg := 0;
           End If;

       End Loop;
     end loop;

    commit;
    
    begin
    sys.sp_sy_enviamail('ehidalgom@cajaarequipa.pe','ehidalgom@cajaarequipa.pe','Ejecución sp_genera_saldos_reps','BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||'Hora Actual en Servidor : '|| to_char(sysdate,'HH24:MI:SS') ||CHR(13)||'Sp_genera_saldos_reps ejecutado.');          
    sys.sp_sy_enviamail('bantoem@cajaarequipa.pe','kcabrerac@cajaarequipa.pe','Ejecución sp_genera_saldos_reps','BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||'Hora Actual en Servidor : '|| to_char(sysdate,'HH24:MI:SS') ||CHR(13)||'Sp_genera_saldos_reps ejecutado.');          
    sys.sp_sy_enviamail('bantoem@cajaarequipa.pe','jsanchez@cajaarequipa.pe', 'Ejecución sp_genera_saldos_reps','BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||'Hora Actual en Servidor : '|| to_char(sysdate,'HH24:MI:SS') ||CHR(13)||'Sp_genera_saldos_reps ejecutado.');
    exception when others then null;
    end;
end sp_genera_saldos_reps;
 /* GOLDENGATE_DDL_REPLICATION */
/

