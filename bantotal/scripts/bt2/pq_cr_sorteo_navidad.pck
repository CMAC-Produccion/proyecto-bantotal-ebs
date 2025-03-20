create or replace package pq_cr_sorteo_navidad is
    -- *********************************************************************************
    -- Nombre                     : FUNCIONES PARA OPBTENER LOS DATOS DEL SORTEO NAVIDAD.
    -- Sistema                    : BANTOTAL
    -- Módulo                     : ACTIVAS
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.12.20
    -- Autor de Creación          : HSUAREZ
    -- Uso                        : OBTENCION DE DATA PARA EL SORTEO DE CAMPAÑA NAVIDAD.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- *********************************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_obtener_calificacion_cn(fcalif in date,fcierre in date);
  procedure sp_cr_obtener_cupon(pd_fecini in date,pd_fecfin in date);
	-------------------------------------------------------------------------------------------
	procedure sp_job_llenar_crd(fsorteo in date, fcierre in date);
	procedure sp_job_llenar_aho(fsorteo in date, fcierre in date);
	procedure sp_job_llenar_tar(fsorteo in date, fcierre in date);
	--------------------------------------------------------------------------------------------
	PROCEDURE sp_llenar_reg_creditos(fsorteo in date,fcierre in date,p_c_digito in char);
	procedure sp_llenar_reg_ahorro(fsorteo in date,fcierre in date,p_c_digito in char);
	procedure sp_llenar_reg_tarjetas(fsorteo in date, fcierre in date,p_c_digito in char);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
	
end pq_cr_sorteo_navidad;
/

create or replace package body pq_cr_sorteo_navidad is

PROCEDURE sp_obtener_calificacion_cn(fcalif in date,fcierre in date) 
is
-- 1 validar si cumple calificacion 100% normal ultimo mes ---12 minutos
cursor creditos_jaql406 is
select 
       distinct 
				jaql406pgc,
				jaql406mod,
				jaql406suc,
				jaql406mda,
				jaql406pap,
				jaql406cta,
				jaql406ope,
				jaql406sbo,
				jaql406top 
from jaql406
where jaql406excup='C';

cursor clientes(lpgcod number, 
                lmod number, 
								lsuc number, 
								lmda number, 
								lpap number, 
								lcta number, 
								lope number,
								lsbo number,
								ltop number) is
		select 
		    ctnro,  n.penom, t.tdocum,
				t.tdnom, trim(n.pendoc) numdoc,
        sum(fn_dias_atraso (to_char(fcierre,'dd/mm/yyyy'),--(to_date('2016.10.16','yyyy.mm.dd'),
                       f.pgcod,f.aomod,f.aosuc,f.aomda,f.aopap,
                       f.aocta,f.aooper,f.aosbop,f.aotope,f.aostat,
                       f.aofvto)) dias
		from fsd010 f,fsr008 r,fsd001 n, fst014 t 
		    where f.pgcod = lpgcod--c.jaql406pgc
				  and f.aomod = lmod--c.jaql406mod
				  and f.aosuc = lsuc--c.jaql406suc
				  and f.aomda = lmda--c.jaql406mda
				  and f.aopap = lpap--c.jaql406pap
				  and f.aocta = lcta--c.jaql406cta
				  and f.aooper = lope--c.jaql406ope
				  and f.aosbop = lsbo--c.jaql406sbo
					and f.aotope = ltop--c.jaql406top
				  
					and r.pgcod = f.pgcod--c.jaql406pgc
          and r.ctnro = f.aocta--c.jaql406cta
          and r.cttfir = 'T'
          
					and n.pepais = r.pepais
          and n.petdoc = r.petdoc
          and n.pendoc = r.pendoc
          
					and t.tdocum = n.petdoc
        
          and ( f.aostat <> 99
                or (f.aostat = 99 and f.aofe99 > fcierre)--to_date('2016.10.16', 'yyyy.mm.dd')
              )   
     group by  ctnro,  n.penom, t.tdocum, t.tdnom, trim(n.pendoc);
    /*
		select
        ctnro,  n.penom, t.tdocum,t.tdnom, trim(n.pendoc) numdoc,
        sum(fn_dias_atraso (fcierre,--(to_date('2016.10.16','yyyy.mm.dd'),
                       f.pgcod,f.aomod,f.aosuc,f.aomda,f.aopap,
                       f.aocta,f.aooper,f.aosbop,f.aotope,f.aostat,
                       f.aofvto)) dias
        from jaql406 c
        join fsr008 r on r.pgcod = c.jaql406pgc
                     and r.ctnro = c.jaql406cta
                     and r.cttfir = 'T'
        join fsd001 n on n.pepais = r.pepais
                     and n.petdoc = r.petdoc
                     and n.pendoc = r.pendoc
        join fst014 t on t.tdocum = n.petdoc
        join fsd010 f on f.pgcod = c.jaql406pgc
                     and f.aomod = c.jaql406mod
                     and f.aosuc = c.jaql406suc
                     and f.aomda = c.jaql406mda
                     and f.aopap = c.jaql406pap
                     and f.aocta = c.jaql406cta
                     and f.aooper = c.jaql406ope
                     and f.aosbop = c.jaql406sbo
                     and f.aotope = c.jaql406top
       where ( f.aostat <> 99
                or (f.aostat = 99 and f.aofe99 > fcierre)--to_date('2016.10.16', 'yyyy.mm.dd')
             )   
    group by  ctnro,  n.penom, t.tdocum, t.tdnom, trim(n.pendoc);
    */
ln_calif number  := 0; 
ln_calif1 number := 0; 
ln_calif2 number := 0; 
ln_calif3 number := 0; 
ln_calif4 number := 0; 

begin
    execute immediate('Truncate table JAQZ437t');
		---OBTENGO LOS CREDITOS DE LA JAQL406.
		for x in creditos_jaql406 loop
--- VALIDA CALIFICACION RCC
     for i in clientes(x.jaql406pgc,x.jaql406mod,x.jaql406suc,
		                   x.jaql406mda,x.jaql406pap,
											 x.jaql406cta,x.jaql406ope,x.jaql406sbo,
											 x.jaql406top) loop
        --if trim(i.tdnom) = 'DNI/LE' then
				
        if i.tdocum = 21 then
           --calificacion
           begin
            select n_calif0, n_calif1, n_calif2, n_calif3, n_calif4 
              into ln_calif, ln_calif1, ln_calif2, ln_calif3, ln_calif4 
              from cldrcci c 
            where d_fecpre = fcalif--to_date('2016.06.30','yyyy.mm.dd')
              and c_tdocid = '1'
              and c_docide = i.numdoc;
           exception when no_data_found then
              ln_calif :=0;
              ln_calif1:=0; 
              ln_calif2:=0;
              ln_calif3:=0;
              ln_calif4:=0; 
              when too_many_rows then
                   dbms_output.put_line(i.numdoc);
           end;   
        else
        
          if i.tdocum = 2 then
             --calificacion
             begin
              select n_calif0, n_calif1, n_calif2, n_calif3, n_calif4 
                into ln_calif, ln_calif1, ln_calif2, ln_calif3, ln_calif4 
                from cldrcci c 
              where d_fecpre = fcalif--to_date('2016.06.30','yyyy.mm.dd')
                and c_tdocid = '2'
                and c_docide = i.numdoc;
             exception when no_data_found then
                ln_calif :=0;
                ln_calif1:=0; 
                ln_calif2:=0;
                ln_calif3:=0;
                ln_calif4:=0; 
                when too_many_rows then
                     dbms_output.put_line(i.numdoc);
             end;   
          /* else 
               --calificacion
               begin
                select n_calif0, n_calif1, n_calif2, n_calif3, n_calif4 
                  into ln_calif, ln_calif1, ln_calif2, ln_calif3, ln_calif4
                  from cldrcci c 
                where d_fecpre = fcalif--to_date('2016.06.30','yyyy.mm.dd')
                  and c_tdocid = '3'
                  and c_doctri = i.numdoc;
               exception when no_data_found then
                  ln_calif :=0;
                  ln_calif1:=0; 
                  ln_calif2:=0;
                  ln_calif3:=0;
                  ln_calif4:=0;              
                  when too_many_rows then
                       dbms_output.put_line(i.numdoc);
               end;*/ 
            end if;   
        end if;
				if i.tdocum=21 or i.tdocum=2 then
					if ln_calif = 100 or (ln_calif = 0 and (ln_calif1+ln_calif2+ln_calif3+ln_calif4)=0 )  then
						 if i.dias = 0 then
								 insert into jaqz437t (jaqz437ds, jaqz437ds1, jaqz437ds2, jaqz437ds3, jaqz437ds4)
								 values(i.numdoc, i.penom, i.tdnom, ln_calif, i.ctnro);
								 commit;
						 end if;
					end if;
				end if;
				
     end loop;
		end loop;
		 commit;
end sp_obtener_calificacion_cn;
-----fin paso 1

----------------------------------
procedure sp_cr_obtener_cupon(pd_fecini in date,pd_fecfin in date)is
    -- *****************************************************************
    -- Nombre                     : sp_cr_seg_desg_diario
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.08.16
    -- Autor de Creación          : HSUAREZ
    -- Uso                        : Ejecuta el proceso de altas,bajas y pagos diarios.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --                              
  -- *****************************************************************
ln_temp number(3);
begin
          -- limpia tablas antes de procesar la fecha
					execute immediate('Truncate table JAQZ437');
					
					commit;	 
          --proceso para generar el alta del seguro desgravamen diario
					sp_job_llenar_crd(pd_fecini,pd_fecfin);
					
					commit;
					--proceso para generar data para el sorteo de TIEMPO DE CELEBRAR
					DBMS_LOCK.Sleep( 10 );
					
					---------- BAJAS
					ln_temp:=1;
					while ln_temp>0 loop
					   select count(*) into ln_temp from dba_jobs where upper(what) like '%SP_LLENAR_REG_CREDITOS%';
						 if ln_temp=0 then
						 	exit;
              --sp_job_llenar_aho(pd_fecini,pd_fecfin);
						 end if;
					end loop;
					commit;
					---------PAGOS
					/*
					DBMS_LOCK.Sleep( 10 );
					
					ln_temp:=1;
					while ln_temp>0 loop
					   select count(*) into ln_temp from dba_jobs where upper(what) like '%SP_LLENAR_REG_AHORRO%';
						 if ln_temp=0 then
								sp_job_llenar_tar(pd_fecini,pd_fecfin);
						 end if;
					end loop;
					commit;
					----- comprobar que termino el jobs de pagos.
					DBMS_LOCK.Sleep( 10 );
					ln_temp:=1;
					while ln_temp>0 loop
					   select count(*) into ln_temp from dba_jobs where upper(what) like '%SP_LLENAR_REG_TARJETAS%';
						 if ln_temp=0 then
								exit;
						 end if;
					end loop;
					
					commit;
          */
					
end sp_cr_obtener_cupon;
---------------------------------------------------------------------------------------------------------
----------------------------------
---------
procedure sp_job_llenar_crd(fsorteo in date, fcierre in date)
is

/*
cursor departamento is
	select
						 distinct tp1nro2 cdepartamento
				from fst198 
				where tp1cod=1
					and tp1cod1=10871
					and tp1corr1=7
					and tp1corr2=12;
*/			
		-- job que permite ejecutar varias instancias en simultaneo.
     lc_variable   varchar2(4000);
     ln_job        number:= 0;
     ln_cont number(2):=0;
     ln_inst number(1):=1;
     primero number;
		 ultimo  number;
		 vt_contador char(2);
     lc_hostname varchar2(64);
     x number; 
begin
      --execute immediate('Truncate table JAQZ437');
			 
     --Obtener hostname
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;
			primero:=0;
      ultimo:=100;

      FOR contador IN primero..ultimo
      loop
			    begin
					      SELECT 
								   LPAD(contador,2,'0') 
								into
								   vt_contador
								FROM DUAL; 
					end;
			    lc_variable := ' begin '||
								'pq_cr_sorteo_navidad.sp_llenar_reg_creditos('''||fsorteo||''','''||fcierre||''','''||vt_contador||''');'||
																																		' End; ';
								--ln_cont := ln_cont +1;
	              
								ln_job := ln_job +1;
	              
	--            DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*60));
--								if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then   
                  IF SYS.FN_BD_ISRAC='TRUE' THEN
								DBMS_JOB.SUBMIT(ln_job, 
												what => lc_variable,
												next_date => sysdate+1/(24*60),
												interval => null,
												no_parse => false,
												instance => 2,--ln_inst,
												--instance => 1,--Solo por hoy 01.07.2015 hmev
												force => false
												);
												else
															DBMS_JOB.SUBMIT(ln_job, 
																							what => lc_variable,
																							next_date => sysdate+1/(24*60),
																							interval => null,
																							no_parse => false,
																							force => false
																							);
								end if;
	         
					commit;		      
			end loop;      
      /*
			for i in departamento loop				
					 lc_variable := ' begin '||
								'pq_cr_sorteo_navidad.sp_llenar_registro_nav('''||fsorteo||''','''||fcierre||''','''||i.cdepartamento||''');'||
																																		' End; ';
								ln_cont := ln_cont +1;
	              
								ln_job := ln_job +1;
	              
	--            DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*60));
								if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then   
								DBMS_JOB.SUBMIT(ln_job, 
												what => lc_variable,
												next_date => sysdate+1/(24*60),
												interval => null,
												no_parse => false,
												instance => 2,--ln_inst,
												--instance => 1,--Solo por hoy 01.07.2015 hmev
												force => false
												);
												else
															DBMS_JOB.SUBMIT(ln_job, 
																							what => lc_variable,
																							next_date => sysdate+1/(24*60),
																							interval => null,
																							no_parse => false,
																							force => false
																							);
								end if;
	         
					commit;
				end loop;
       */
end;  
---------
procedure sp_job_llenar_aho(fsorteo in date, fcierre in date)
is

/*
cursor departamento is
	select
						 distinct tp1nro2 cdepartamento
				from fst198 
				where tp1cod=1
					and tp1cod1=10871
					and tp1corr1=7
					and tp1corr2=12;
*/			
		-- job que permite ejecutar varias instancias en simultaneo.
     lc_variable   varchar2(4000);
     ln_job        number:= 0;
     ln_cont number(2):=0;
     ln_inst number(1):=1;
     primero number;
		 ultimo  number;
		 vt_contador char(2);
     lc_hostname varchar2(64);
     x number; 
begin
      --execute immediate('Truncate table JAQZ437');
			 
     --Obtener hostname
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;
			primero:=0;
      ultimo:=100;

      FOR contador IN primero..ultimo
      loop
			    begin
					      SELECT 
								   LPAD(contador,2,'0') 
								into
								   vt_contador
								FROM DUAL; 
					end;
			    lc_variable := ' begin '||
								'pq_cr_sorteo_navidad.sp_llenar_reg_ahorro('''||fsorteo||''','''||fcierre||''','''||vt_contador||''');'||
																																		' End; ';
								--ln_cont := ln_cont +1;
	              
								ln_job := ln_job +1;
	              
	--            DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*60));
--								if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then   
                  IF SYS.FN_BD_ISRAC='TRUE' THEN
								DBMS_JOB.SUBMIT(ln_job, 
												what => lc_variable,
												next_date => sysdate+1/(24*60),
												interval => null,
												no_parse => false,
												instance => 2,--ln_inst,
												--instance => 1,--Solo por hoy 01.07.2015 hmev
												force => false
												);
												else
															DBMS_JOB.SUBMIT(ln_job, 
																							what => lc_variable,
																							next_date => sysdate+1/(24*60),
																							interval => null,
																							no_parse => false,
																							force => false
																							);
								end if;
	         
					commit;		      
			end loop;      
      /*
			for i in departamento loop				
					 lc_variable := ' begin '||
								'pq_cr_sorteo_navidad.sp_llenar_registro_nav('''||fsorteo||''','''||fcierre||''','''||i.cdepartamento||''');'||
																																		' End; ';
								ln_cont := ln_cont +1;
	              
								ln_job := ln_job +1;
	              
	--            DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*60));
								if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then   
								DBMS_JOB.SUBMIT(ln_job, 
												what => lc_variable,
												next_date => sysdate+1/(24*60),
												interval => null,
												no_parse => false,
												instance => 2,--ln_inst,
												--instance => 1,--Solo por hoy 01.07.2015 hmev
												force => false
												);
												else
															DBMS_JOB.SUBMIT(ln_job, 
																							what => lc_variable,
																							next_date => sysdate+1/(24*60),
																							interval => null,
																							no_parse => false,
																							force => false
																							);
								end if;
	         
					commit;
				end loop;
       */
end;  
---------
procedure sp_job_llenar_tar(fsorteo in date, fcierre in date)
is

/*
cursor departamento is
	select
						 distinct tp1nro2 cdepartamento
				from fst198 
				where tp1cod=1
					and tp1cod1=10871
					and tp1corr1=7
					and tp1corr2=12;
*/			
		-- job que permite ejecutar varias instancias en simultaneo.
     lc_variable   varchar2(4000);
     ln_job        number:= 0;
     ln_cont number(2):=0;
     ln_inst number(1):=1;
     primero number;
		 ultimo  number;
		 vt_contador char(2);
     lc_hostname varchar2(64);
     x number; 
begin
      --execute immediate('Truncate table JAQZ437');
			 
     --Obtener hostname
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;
			primero:=0;
      ultimo:=100;

      FOR contador IN primero..ultimo
      loop
			    begin
					      SELECT 
								   LPAD(contador,2,'0') 
								into
								   vt_contador
								FROM DUAL; 
					end;
			    lc_variable := ' begin '||
								'pq_cr_sorteo_navidad.sp_llenar_reg_tarjetas('''||fsorteo||''','''||fcierre||''','''||vt_contador||''');'||
																																		' End; ';
								--ln_cont := ln_cont +1;
	              
								ln_job := ln_job +1;
	              
	--            DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*60));
--								if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then   
                  IF SYS.FN_BD_ISRAC='TRUE' THEN
								DBMS_JOB.SUBMIT(ln_job, 
												what => lc_variable,
												next_date => sysdate+1/(24*60),
												interval => null,
												no_parse => false,
												instance => 2,--ln_inst,
												--instance => 1,--Solo por hoy 01.07.2015 hmev
												force => false
												);
												else
															DBMS_JOB.SUBMIT(ln_job, 
																							what => lc_variable,
																							next_date => sysdate+1/(24*60),
																							interval => null,
																							no_parse => false,
																							force => false
																							);
								end if;
	         
					commit;		      
			end loop;
end;  
---------
---------
PROCEDURE sp_llenar_reg_creditos(fsorteo in date,fcierre in date,p_c_digito in char)
is 
/*
cursor registro is
    select
           tp1corr3 correlativo,tp1nro1 sucursal,tp1nro2 departamento
      from fst198 
 	    where tp1cod=1
			and tp1cod1=10871
			and tp1corr1=7
			and tp1corr2=12
			and tp1nro2=cdepartamento;
			*/
/*
cursor dataf(sucurs number) is
      select
			    c.jaql406cup cupon,
					c.jaql406cre credito,
					c.jaql406fop fpago,
					c.jaql406suc sucursal,
					c.jaql406pgc pgc,
			    c.jaql406mod mod,
					c.jaql406mda mda,
					c.jaql406pap pap,
					c.jaql406cta cta,
					c.jaql406dpt dpt,
					c.jaql406ope ope,
					c.jaql406sbo sbo,
					c.jaql406top top
					from jaql406 c, jaqz437t a 
					where c.jaql406cta = a.jaqz437ds4--;
					and c.jaql406suc = sucurs
					and c.jaql406excup='C';
*/
cursor dni(digito in char) is
select 
       distinct
				f.pepais,
				f.petdoc,
				f.pendoc
				--substr(trim(f.pendoc), -2, 2)       
from fsr008 f,jaql406 c
where c.jaql406pgc  =  1
  and c.jaql406excup= 'C'
  and c.jaql406tip  in ('P','D','M','CD') -- Creditos
	--and c.jaql406cta = f.ctnro
	and f.pgcod = c.jaql406pgc
  and f.ctnro = c.jaql406cta
  and f.cttfir= 'T'
  AND substr(trim(f.pendoc), -2, 2) = digito; --2018.04.12 EJECUCION JOBS.
	--and c.jaql406suc  = 11
  
	--order by pendoc;

cursor data_credito(c_pepais in number,c_petdoc in number,c_pendoc in char) is
select        
				  c.jaql406cup cupon,
					c.jaql406cre credito,
					c.jaql406fop fpago,
					c.jaql406suc sucursal,
					c.jaql406pgc pgc,
			    c.jaql406mod mod,
					c.jaql406mda mda,
					c.jaql406pap pap,
					c.jaql406cta cta,
					c.jaql406dpt dpt,
					c.jaql406ope ope,
					c.jaql406sbo sbo,
					c.jaql406top top,
					c.jaql406tip tipo,
          c.jaql406tipcredpc tipcrd --2018.11.05 - TIPO DE CREDITO. 
from jaql406 c,fsr008 f
where c.jaql406pgc  =  1  -- 
  and c.jaql406excup= 'C' -- 
  and c.jaql406tip in  ('P','D','M','CD')--'A' -- Ahorros
  --and c.jaql406suc  = 11
  and f.pgcod  = c.jaql406pgc
	and f.pepais = c_pepais
	and f.petdoc = c_petdoc
	and f.pendoc = c_pendoc
	and f.cttfir = 'T'
	and c.jaql406cta = f.ctnro;
	--order by pendoc;
					
ln_nombreape varchar(30):='';
ln_tipodoc varchar(20):='';
ln_nrodoc varchar (12):='';
ln_telefono varchar(20) :='';
ln_agencia varchar(50):='';
ln_region varchar(50):='';
ln_direccion varchar(150) :='';
ln_departamento varchar(30) :='';
ln_cont number(10) :=0;
ln_flag varchar(1) :='N';
flag_grupo varchar(1):='S';
lv_grupo number:=0;
ln_desc_tdoc varchar(100);
flag_rcc char(1):='S';

ln_mora number(10) :=0;

ln_aostat number(2);
ln_aofvto date;
													
ln_cdepartamento number;
contador number:=0;

begin

      --execute immediate('Truncate table JAQZ437');
			
      --for i in registro loop
			--    for j in dataf(i.sucursal) loop
		  for i in dni(p_c_digito) loop
		     contador :=1;
				 --? verificar si cumple las condiciones por lo menos uno de los creditos
						 begin -- cambiando el codigo de tipo documento por la descripcion
							 select 
										tdnom
								 into
										ln_desc_tdoc
								 from fst014
								where tdocum  = i.petdoc;
						 end;
						 begin
								select 
								      'S'
								into 
											flag_rcc
								from jaqz437t t
								where trim(t.jaqz437ds2) = trim(ln_desc_tdoc)--t.jaqz437ds2 = --ln_desc_tdoc --
									and trim(t.jaqz437ds) = trim(i.pendoc) --t.jaqz437ds  = --i.pendoc --
									and rownum =1;								 
						 exception
						  when no_data_found then
							     flag_rcc := 'N';	
						 end;
				 -- fin de la verificación.
				 if flag_rcc = 'S' then
			      for j in data_credito(i.pepais, i.petdoc, i.pendoc) loop
				      -- ? Crear condicion para verificar si tiene un credito vigente el titular. pra considerar los cupones de
							--los demas creditos que hayan sido cancelados.
							
							-- ? fin de la condicion adicional de verificación.
					    --ln_flag := 'N';
					    --SE CAMBIA POSICION DEL FLAG. PARA AHORRAR EN CONSULTAS. --04012017
							
							begin
							    ln_mora :=0;
							    begin
									  select
										      aostat,
													aofvto 
										  into 
								          ln_aostat,
													ln_aofvto
										  from  fsd010 a
										 where a.pgcod =  j.pgc
                       and a.aomod =  j.mod
                       and a.aosuc =  j.sucursal
                       and a.aomda =  j.mda
                       and a.aopap =  j.pap
                       and a.aocta =  j.cta
                       and a.aooper=  j.ope
                       and a.aosbop=  j.sbo
                       and a.aotope=  j.top
											 and rownum = 1;	
									exception 
									when no_data_found then
									          ln_aostat:=0;    
                            ln_aofvto:='01/01/2001';
									end;
									
							    ln_mora := (fn_dias_atraso (to_char(fcierre,'dd/mm/yyyy'),--(to_date('2016.10.16','yyyy.mm.dd'),
                                                 j.pgc,
																								 j.mod,
																								 j.sucursal,
																								 j.mda,
																								 j.pap,
                                                 j.cta,
																								 j.ope,
																								 j.sbo,
																								 j.top,
																								 ln_aostat,
																								 ln_aofvto));
							end;
							begin 		
									--if ln_flag='S' then
											begin
													select 
															n.penom,
															t.tdnom,
															n.pendoc,
															(select m.dotelfp from fsr005 m where m.pepais = r.pepais and m.petdoc = r.petdoc and m.pendoc = r.pendoc and rownum = 1),
															(select d.sngc13dir from sngc13 d where d.sngc13pais = r.pepais and d.sngc13tdoc = r.petdoc and d.sngc13ndoc = r.pendoc and rownum = 1 and d.sngc13est = 'H')
													into 
															ln_nombreape,
															ln_tipodoc,
															ln_nrodoc,
															ln_telefono,
															ln_direccion											
													from fsr008 r
													join fsd001 n on n.pepais = r.pepais and n.petdoc = r.petdoc and n.pendoc = r.pendoc
													join fst014 t on t.tdocum = n.petdoc
													where r.pgcod = j.pgc 
														and r.ctnro = j.cta 
														and r.cttfir = 'T';
											exception
											when no_data_found then
														 ln_nombreape:='';    
														 ln_tipodoc:='';
														 ln_nrodoc:='';
														 ln_telefono:='';
														 ln_direccion:=''; 		   
											end;
											begin
														select 
															scnom,
															'AGENCIA '||(H.scnom) 
														into
															ln_departamento,
															ln_agencia
														from FST001 H 
														WHERE H.PGCOD = 1 
															AND H.SUCURS = j.sucursal;
											exception
											when no_data_found then
															ln_departamento :='';       
															ln_agencia :='';
											
											end;
											begin
														 select 
															'REGION '||(upper(re.regnom))
														 into
															ln_region
														 from fst810 re 
														 where re.regcod = j.dpt;
											exception
											when no_data_found then
													 ln_region :='';
											end;
											flag_grupo := 'S'; --POR DEFECTO S para indicar que si ingresa y no pertenece al corporativo.
											begin
											     select
													  bcgpo
													 into
													  lv_grupo  
													 from  
													 fsh012 h12
													 where h12.bcemp   = j.pgc
													 and   h12.bcsuc   = j.sucursal
													 and   h12.bcmda   = j.mda
													 and   h12.bcpap   = j.pap
													 and   h12.bccta   = j.cta
													 and   h12.bcoper  = j.ope
													 and   h12.bcsbop  = j.sbo
													 and   h12.bctop   = j.top
													 and   h12.bcfech= fcierre
													 and   rownum=1;
											exception
											    when others then
													   flag_grupo:='S';
											end;
											--DEPARTAMENTO.
											begin
											     select
																tp1nro2 codigo_departamento
													into 
													      ln_cdepartamento
															from fst198 
															where tp1cod=1
															and tp1cod1=10871
															and tp1corr1=7
															and tp1corr2=12
															and tp1nro1=j.sucursal
															and rownum=1;
											exception 
											when no_data_found then
													    ln_cdepartamento :=0;
											end;
											
											
											if lv_grupo = 5 or lv_grupo = 6 or lv_grupo = 7 or lv_grupo=8 or lv_grupo=9 or lv_grupo=10 then
											   flag_grupo := 'N';
											end if;
							   --end if;
					    end;			    			
					    begin
							      if /* ln_flag='S' and */ flag_grupo='S' and ln_mora=0  then
											insert into jaqz437 
											( 
														 jaqz437fil,
														 jaqz437ncup,
														 jaqz437ncr,
														 jaqz437ayn,
														 jaqz437tpd,
														 jaqz437doc,
														 jaqz437tlf,
														 jaqz437age,
														 jaqz437reg,
														 jaqz437fpg,
														 jaqz437tpc,
														 jaqz437fsrt,
														 jaqz437dir,
														 jaqz437dep,
														 jaqz437csu,
														 jaqz437cdp,
														 jaqz437prd,
                             jaqz437czon,
                             jaqz437tipc                             
														 
											)values 
											(
											       ln_cont,
											       j.cupon,
														 j.credito,
														 ln_nombreape,
														 ln_tipodoc,
														 ln_nrodoc,
														 ln_telefono,
														 trim(ln_agencia),
														 trim(ln_region),
														 j.fpago,
														 '',
														 fsorteo,
														 ln_direccion,
														 ln_departamento,
														 j.sucursal,
														 ln_cdepartamento,--i.departamento,
														 j.tipo,  -- 2018.11.05 - Tipo de Pago.
                             j.dpt,   -- 2018.11.05 - Agregado campos adicionales PARA LA ZONA.
                             j.tipcrd -- 2018.11.05 - Agregado campos adicionales PARA EL TIPO DE CREDITO P o C.
											);
											commit;
											
                    end if;
							           								
					     end;
               
					end loop;
			   end if;
			end loop;
			commit;
end;
---------
procedure sp_llenar_reg_ahorro(fsorteo in date,fcierre in date,p_c_digito in char)
is
		
cursor dni(digito in char) is
select 
       distinct
				f.pepais,
				f.petdoc,
				f.pendoc
				--substr(trim(f.pendoc), -2, 2)       
from fsr008 f,jaql406 c
where c.jaql406pgc  =  1
  and c.jaql406excup= 'C'
  and c.jaql406tip  = 'A' -- Ahorro
	and c.jaql406cta = f.ctnro
	and f.cttfir= 'T'
  AND substr(trim(f.pendoc), -2, 2) = digito; --2018.04.12 EJECUCION JOBS.

cursor data_ahorros(c_pepais in number,c_petdoc in number,c_pendoc in char) is
select        
				  c.jaql406cup cupon,
					c.jaql406cre credito,
					c.jaql406fop fpago,
					c.jaql406suc sucursal,
					c.jaql406pgc pgc,
			    c.jaql406mod mod,
					c.jaql406mda mda,
					c.jaql406pap pap,
					c.jaql406cta cta,
					c.jaql406dpt dpt,
					c.jaql406ope ope,
					c.jaql406sbo sbo,
					c.jaql406top top      
from jaql406 c,fsr008 f
where c.jaql406pgc  =  1  -- 
  and c.jaql406excup= 'C' -- 
  and c.jaql406tip  = 'A'--'A'-- Ahorros
  --and c.jaql406suc  = 11
  and f.pgcod  = c.jaql406pgc
	and f.pepais = c_pepais
	and f.petdoc = c_petdoc
	and f.pendoc = c_pendoc
	and f.cttfir = 'T'
	and c.jaql406cta = f.ctnro
	order by pendoc;
------------------------------------------------------
ln_nombreape varchar(30):='';
ln_tipodoc varchar(20):='';
ln_nrodoc varchar (12):='';
ln_telefono varchar(20) :='';
ln_agencia varchar(50):='';
ln_region varchar(50):='';
ln_direccion varchar(150) :='';
ln_departamento varchar(30) :='';
ln_cdepartamento number;
ln_cont number(10) :=0;
ln_flag_a varchar(1) :='N';
flag_grupo varchar(1):='S';
lv_grupo number:=0;
var_limite number:=0;
contador number:=0;

begin
     begin
		     select 
				  tp1nro1 
					into 
					var_limite
				 from fst198 
				 where tp1cod  = 1 
				   and tp1cod1 = 10871  
					 and tp1corr1= 7 
					 and tp1corr2= 200;
		 exception
		 when no_data_found then
				  var_limite :=15;
		 end;
     for i in dni(p_c_digito) loop
		     contador :=1;
			   for j in data_ahorros(i.pepais, i.petdoc, i.pendoc) loop
				     --contador para los cupones para no seguir procesando en caso se llegue al limite de cupones
						 --para ahorros.
				     if contador = var_limite then
						    exit;
						 end if;
				     begin
						      ln_flag_a := 'N';
									--SE CAMBIA POSICION DEL FLAG. PARA AHORRAR EN CONSULTAS. --04012017
									begin
											select 
													'S' 
											into 
													ln_flag_a
											from fsd011 f 
											where f.pgcod  = j.pgc 
												and f.scmod  = j.mod
												and f.scsuc  = j.sucursal
												and f.scmda  = j.mda
												and f.scpap  = j.pap
												and f.sccta  = j.cta 
												and f.scoper = j.ope 
												and f.scsbop = j.sbo
												and f.sctope = j.top
												and f.scstat <>99
												and rownum =1;
												--and f.aosuc = i.sucursal;
									exception
									when no_data_found then
											 ln_flag_a :='N';
									end;
							begin 		
									if ln_flag_a='S' then
											begin
													select 
															n.penom,
															t.tdnom,
															n.pendoc,
															(select m.dotelfp from fsr005 m where m.pepais = r.pepais and m.petdoc = r.petdoc and m.pendoc = r.pendoc and rownum = 1),
															(select d.sngc13dir from sngc13 d where d.sngc13pais = r.pepais and d.sngc13tdoc = r.petdoc and d.sngc13ndoc = r.pendoc and rownum = 1 and d.sngc13est = 'H')
													into 
															ln_nombreape,
															ln_tipodoc,
															ln_nrodoc,
															ln_telefono,
															ln_direccion											
													from fsr008 r
													join fsd001 n on n.pepais = r.pepais and n.petdoc = r.petdoc and n.pendoc = r.pendoc
													join fst014 t on t.tdocum = n.petdoc
													where r.pgcod = j.pgc 
														and r.ctnro = j.cta
														and r.cttfir = 'T';
											exception
											when no_data_found then
														 ln_nombreape:='';    
														 ln_tipodoc:='';
														 ln_nrodoc:='';
														 ln_telefono:='';
														 ln_direccion:=''; 		   
											end;
											begin
														select 
															scnom,
															'AGENCIA '||(H.scnom) 
														into
															ln_departamento,
															ln_agencia
														from FST001 H 
														WHERE H.PGCOD = 1 
															AND H.SUCURS = j.sucursal;
											exception
											when no_data_found then
															ln_departamento :='';       
															ln_agencia :='';
											
											end;
											begin
														 select 
															'REGION '||(upper(re.regnom))
														 into
															ln_region
														 from fst810 re 
														 where re.regcod = j.dpt;
											exception
											when no_data_found then
													 ln_region :='';
											end;
											begin
											     select
																tp1nro2 codigo_departamento
													into 
													      ln_cdepartamento
															from fst198 
															where tp1cod=1
															and tp1cod1=10871
															and tp1corr1=7
															and tp1corr2=12
															and tp1nro1=j.sucursal
															and rownum=1;
											exception 
											when no_data_found then
													    ln_cdepartamento :=0;
											end;
											
										 
											flag_grupo := 'S'; --POR DEFECTO S para indicar que si ingresa y no pertenece al corporativo.
											
											
							   end if;
					    end;			    			
					    begin
							      if ln_flag_a='S' and flag_grupo='S' and (contador < var_limite)  then
										  	
											insert into jaqz437 
											( 
														 jaqz437fil,
														 jaqz437ncup,
														 jaqz437ncr,
														 jaqz437ayn,
														 jaqz437tpd,
														 jaqz437doc,
														 jaqz437tlf,
														 jaqz437age,
														 jaqz437reg,
														 jaqz437fpg,
														 jaqz437tpc,
														 jaqz437fsrt,
														 jaqz437dir,
														 jaqz437dep,
														 jaqz437csu,
														 jaqz437cdp,
														 jaqz437prd -- PRODUCTO
											)values 
											(
											       ln_cont,
											       j.cupon,
														 j.credito,
														 ln_nombreape,
														 ln_tipodoc,
														 ln_nrodoc,
														 ln_telefono,
														 trim(ln_agencia),
														 trim(ln_region),
														 j.fpago,
														 '',
														 fsorteo,
														 ln_direccion,
														 ln_departamento,
														 j.sucursal,
														 ln_cdepartamento,
														 'A'
											);
											--contador auxilar llegado a 15 segun guia de proceso especial. 
											--se cambia a otra persona
											--es decir solo para ahorros se ingresaran los primeros 15 cupones 
											--para el sorteo.
											contador:= contador + 1;
																					    
											commit;											
                    end if;							           								
					     end;						 
						 end;
				 end loop; 
		 end loop; 
end;
---------
procedure sp_llenar_reg_tarjetas(fsorteo in date, fcierre in date,p_c_digito in char)
is

cursor dni(digito in char) is
select 
       distinct
				f.pepais,
				f.petdoc,
				f.pendoc
				--substr(trim(f.pendoc), -2, 2)       
from fsr008 f,jaql406 c
where c.jaql406pgc  =  1
  and c.jaql406excup= 'C'
  and c.jaql406tip  in ('C') -- Ahorro
	and c.jaql406cta = f.ctnro
	and f.cttfir= 'T'
  AND substr(trim(f.pendoc), -2, 2) = digito; --2018.04.12 EJECUCION JOBS.

cursor dni_ct(digito in char) is
select 
       distinct
				f.z0e478thp pepais,
				f.z0e478tht petdoc,
				f.z0e478thd pendoc,
				c.jaql406tip tipo,
				c.jaql406cre credito,
				c.jaql406cup cupon     
from z0e478 f,jaql406 c
where c.jaql406pgc  =  1
  and c.jaql406excup= 'C'
  and c.jaql406tip  in ('T') -- Ahorro
	and z0e478nro = C.JAQL406CRE
	--and c.jaql406cta = f.ctnro
	--and f.cttfir= 'T'
  AND substr(trim(f.z0e478thd), -2, 2) = digito; --2018.04.12 EJECUCION JOBS.


cursor data_tarjeta(c_pepais in number,c_petdoc in number,c_pendoc in char) is
select        
				  c.jaql406cup cupon,
					c.jaql406cre credito,
					c.jaql406fop fpago,
					c.jaql406suc sucursal,
					c.jaql406pgc pgc,
			    c.jaql406mod mod,
					c.jaql406mda mda,
					c.jaql406pap pap,
					c.jaql406cta cta,
					c.jaql406dpt dpt,
					c.jaql406ope ope,
					c.jaql406sbo sbo,
					c.jaql406top top,
					c.jaql406tip tipo     
from jaql406 c,fsr008 f
where c.jaql406pgc  =  1  -- 
  and c.jaql406excup= 'C' -- 
  and c.jaql406tip  in ('C','T')--'A'-- Tarjetas y Actualizacion de Tarjeta
  --and c.jaql406suc  = 11
  and f.pgcod  = c.jaql406pgc
	and f.pepais = c_pepais
	and f.petdoc = c_petdoc
	and f.pendoc = c_pendoc
	and f.cttfir = 'T'
	and c.jaql406cta = f.ctnro
	order by pendoc;
	
ln_creditot char(19);
ln_nombreape varchar(30):='';
ln_pepais number(3);
ln_petdoc number(2);
ln_tipodoc varchar(20):='';
ln_nrodoc varchar (12):='';
ln_telefono varchar(20) :='';
ln_agencia varchar(50):='';
ln_region varchar(50):='';
ln_direccion varchar(150) :='';
ln_departamento varchar(30) :='';
ln_cdepartamento number;
ln_cont number(10) :=0;
ln_flag_c varchar(1) :='N';
flag_grupo varchar(1):='S';
lv_grupo number:=0;
var_limite number:=0;
contador number:=0;
flag_trb number;

begin
      for i in dni(p_c_digito) loop
    	   for j in data_tarjeta(i.pepais, i.petdoc, i.pendoc) loop
				     begin
						 
						      ln_flag_c := 'N';
									flag_trb := 0;
									--SE CAMBIA POSICION DEL FLAG. PARA AHORRAR EN CONSULTAS. --04012017
									if j.tipo='C' then
										begin
												select 
														'S' 
												into 
														ln_flag_c
												from fsd011 f 
												where f.pgcod  = j.pgc 
													and f.scmod  = j.mod
													and f.scsuc  = j.sucursal
													and f.scmda  = j.mda
													and f.scpap  = j.pap
													and f.sccta  = j.cta 
													and f.scoper = j.ope 
													and f.scsbop = j.sbo
													and f.sctope = j.top
													and f.scstat <>99;
										exception
										when no_data_found then
												 ln_flag_c :='N';
										end;
									end if;
									
									--validar que no sea trabajador
										begin
										     flag_trb := pq_op_cammunrus.FN_AH_VALCTA(P_C_NUMTAR => j.credito);
												 if flag_trb=0 then
												    ln_flag_c := 'S';
												 else
												    ln_flag_c := 'N';
												 end if;

										end;
							begin 		
									if ln_flag_c='S' then
											begin
													select 
															n.penom,
															t.tdnom,
															n.pendoc,
															(select m.dotelfp from fsr005 m where m.pepais = r.pepais and m.petdoc = r.petdoc and m.pendoc = r.pendoc and rownum = 1),
															(select d.sngc13dir from sngc13 d where d.sngc13pais = r.pepais and d.sngc13tdoc = r.petdoc and d.sngc13ndoc = r.pendoc and rownum = 1 and d.sngc13est = 'H')
													into 
															ln_nombreape,
															ln_tipodoc,
															ln_nrodoc,
															ln_telefono,
															ln_direccion											
													from fsr008 r
													join fsd001 n on n.pepais = r.pepais and n.petdoc = r.petdoc and n.pendoc = r.pendoc
													join fst014 t on t.tdocum = n.petdoc
													where r.pgcod = j.pgc 
														and r.ctnro = j.cta
														and r.cttfir = 'T';
											exception
											when no_data_found then
														 ln_nombreape:='';    
														 ln_tipodoc:='';
														 ln_nrodoc:='';
														 ln_telefono:='';
														 ln_direccion:=''; 		   
											end;
											begin
														select 
															scnom,
															'AGENCIA '||(H.scnom) 
														into
															ln_departamento,
															ln_agencia
														from FST001 H 
														WHERE H.PGCOD = 1 
															AND H.SUCURS = j.sucursal;
											exception
											when no_data_found then
															ln_departamento :='';       
															ln_agencia :='';
											
											end;
											begin
														 select 
															'REGION '||(upper(re.regnom))
														 into
															ln_region
														 from fst810 re 
														 where re.regcod = j.dpt;
											exception
											when no_data_found then
													 ln_region :='';
											end;
											begin
											     select
																tp1nro2 codigo_departamento
													into 
													      ln_cdepartamento
															from fst198 
															where tp1cod=1
															and tp1cod1=10871
															and tp1corr1=7
															and tp1corr2=12
															and tp1nro1=j.sucursal;
											exception 
											when no_data_found then
													    ln_cdepartamento :=0;
											end;
											
											flag_grupo := 'S'; --POR DEFECTO S para indicar que si ingresa y no pertenece al corporativo.
											
											
							   end if;
					    end;			    			
					    begin
							      if ln_flag_c='S' and flag_grupo='S'  then
											insert into jaqz437 
											( 
														 jaqz437fil,
														 jaqz437ncup,
														 jaqz437ncr,
														 jaqz437ayn,
														 jaqz437tpd,
														 jaqz437doc,
														 jaqz437tlf,
														 jaqz437age,
														 jaqz437reg,
														 jaqz437fpg,
														 jaqz437tpc,
														 jaqz437fsrt,
														 jaqz437dir,
														 jaqz437dep,
														 jaqz437csu,
														 jaqz437cdp,
														 jaqz437prd -- PRODUCTO
														 
											)values 
											(
											       ln_cont,
											       j.cupon,
														 j.credito,
														 ln_nombreape,
														 ln_tipodoc,
														 ln_nrodoc,
														 ln_telefono,
														 trim(ln_agencia),
														 trim(ln_region),
														 j.fpago,
														 '',
														 fsorteo,
														 ln_direccion,
														 ln_departamento,
														 j.sucursal,
														 ln_cdepartamento,
														 j.tipo
											);
																					    
											commit;											
                    end if;							           								
					     end;						 
						 end;
				 end loop;
     end loop;
		 --Para tarjetas solo cambio
		 for i in dni_ct(p_c_digito) loop
		    ------------------------------
				------------------------------
				--para cambio de tarjeta.
				------------------------------
				ln_flag_c := 'N';
				flag_trb := 0;
				if i.tipo='T' then
						ln_creditot := trim(i.credito);
						begin
							select
								z.z0e478thp,
								z.z0e478tht,
								z.z0e478thd,
								'S'
							into 
								ln_pepais,
								ln_petdoc,
								ln_nrodoc,
								ln_flag_c
							from z0e478 z
							where z.z0e478nro = ln_creditot
								and z.z0e463cod in (1,7);--verifico vigente; 
						exception
						when no_data_found then
								ln_pepais := 0;
								ln_petdoc := 0;
								ln_nrodoc :='';
								ln_flag_c :='N';
						end;
						flag_trb := pq_op_cammunrus.FN_AH_VALCTA(P_C_NUMTAR => ln_creditot);
						if flag_trb=0 then
						   ln_flag_c := 'S';
						else
						   ln_flag_c := 'N';
						end if;
												 
						if ln_flag_c = 'S' then
							begin
								select 
									 n.penom,
									 t.tdnom,
									 (select m.dotelfp from fsr005 m where m.pepais = ln_pepais and m.petdoc = ln_petdoc and m.pendoc = ln_nrodoc and rownum = 1),
									 (select d.sngc13dir from sngc13 d where d.sngc13pais = ln_pepais and d.sngc13tdoc = ln_petdoc and d.sngc13ndoc = ln_nrodoc and rownum = 1 and d.sngc13est = 'H')
								into
									 ln_nombreape,
									 ln_tipodoc,
									 ln_telefono,
									 ln_direccion
								from fsd001 n,fst014 t
								where n.pepais = ln_pepais
									and n.petdoc = ln_petdoc
									and n.pendoc = ln_nrodoc
									and t.tdocum = ln_petdoc;
							exception 
							when no_data_found then
									 ln_nombreape :='';
							end;
						end if;											
				    --relleno la informacion
						begin
							      if ln_flag_c='S' and flag_grupo='S'  then
											insert into jaqz437 
											( 
														 jaqz437fil,
														 jaqz437ncup,
														 jaqz437ncr,
														 jaqz437ayn,
														 jaqz437tpd,
														 jaqz437doc,
														 jaqz437tlf,
														 jaqz437age,
														 jaqz437reg,
														 jaqz437fpg,
														 jaqz437tpc,
														 jaqz437fsrt,
														 jaqz437dir,
														 jaqz437dep,
														 jaqz437csu,
														 jaqz437cdp,
														 jaqz437prd -- PRODUCTO
														 
											)values 
											(
											       ln_cont,
											       i.cupon,
														 i.credito,
														 ln_nombreape,
														 ln_tipodoc,
														 ln_nrodoc,
														 ln_telefono,
														 trim(ln_agencia),
														 trim(ln_region),
														 null,--j.fpago,
														 '',
														 fsorteo,
														 ln_direccion,
														 ln_departamento,
														 0,--j.sucursal,
														 '',--ln_cdepartamento,
														 i.tipo
											);
																					    
											commit;											
                    end if;							           								
					     end;	
							 								  
				end if;    
		 end loop;
		 
		  
end;
---------


end pq_cr_sorteo_navidad;
/

