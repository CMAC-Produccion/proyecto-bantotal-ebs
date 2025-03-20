create or replace package PQ_CR_DESGRAVAMEN is
    -- *****************************************************************
    -- Nombre                     : PAQUETES PARA OBTENER INFORMACION DE LOS PRENDARIOS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.07.21
    -- Autor de Creación          : HSUAREZ
    -- Uso                        : Realiza Calculos PARA SEGURO DESGRAVAMEN DIARIO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : FECHA DE PROCESO
    -- Fecha de Modificación      : 14/08/2024
    -- Autor de la Modificación   : eninah
    -- Descripción de Modificación: se modifico código del procedimiento sp_transf_sigs_retail_pagos
    -- *****************************************************************
-----------------------------------------------------------------------
procedure sp_cr_seg_desg_diario(pd_fecini in date);
-----------------------------------------------------------------------
procedure sp_cr_altaseg_desg_diario(P_C_DIGITO in varchar2, pd_fecini in date);
-----------------------------------------------------------------------
procedure sp_cr_bajaseg_desg_diario(P_C_DIGITO in varchar2, pd_fecini in date);
-----------------------------------------------------------------------
procedure sp_cr_pagoseg_desg_diario(p_c_digito in varchar2, pd_fecini in date);
----------------------------------------------------------------------------
procedure sp_transf_sigs_retail_altabaja;
------------------------------
procedure sp_transf_sigs_retail_pagos;
-----------------------------------------------------------------------
Procedure Sp_monto_calendario(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                             pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                             pn_top in number,pn_tip in number,pd_fecpro in date,ln_mtoprima out number,
                             lc_tip out varchar2,flag_sd out char);
-----------------------------------------------------------------------.
Function Fn_montoPag_calendario(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                             pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                             pn_top in number,pd_Fecpro in date,pn_mto in number,
                             pn_ord in number) return varchar2;
-----------------------------------------------------------------------
procedure sp_cr_validapago(ln_pgcod     in number,
                             ln_modulo    in number,
                             ln_sucursal  in number,
                             ln_moneda    in number,
                             ln_papel     in number,
                             ln_cuenta    in number,
                             ln_operacion in number,
                             ln_suboper   in number,
                             ln_tope      in number,
                             ld_fechpag   in date,
                             ld_pd_fecini in date,
                             --ln_codvar    in number,
                             ln_monto     in number,
														 ln_valor     out varchar --lc_indica    in varchar2
														 );
-----------------------------------------------------------------------
procedure sp_saldocapital(ln_pgcod     in number,
                          ln_modulo    in number,
                          ln_sucursal  in number,
                          ln_moneda    in number,
                          ln_papel     in number,
                          ln_cuenta    in number,
                          ln_operacion in number,
                          ln_suboper   in number,
                          ln_tope      in number,
                          ld_fechpag   in date,
													ln_saldo    out number);
-----------------------------------------------------------------------
procedure sp_cr_carga_job_baja(pd_fecpro IN date);
-----------------------------------------------------------------------
procedure sp_cr_carga_job_pago(pd_fecpro IN date);
-----------------------------------------------------------------------
procedure sp_cr_carga_job_alta(pd_fecpro IN date);
-----------------------------------------------------------------------
procedure sp_cr_pagosegxfpago(ln_pgcod     in number,
                              ln_modulo    in number,
                              ln_sucursal  in number,
                              ln_moneda    in number,
                              ln_papel     in number,
                              ln_cuenta    in number,
                              ln_operacion in number,
                              ln_suboper   in number,
                              ln_tope      in number,
															ln_tasaaux   in number,
                              ld_fechpag   in date);
-----------------------------------------------------------------------
--mod@abr 20170202
Function Fn_montoPag_calendarioT(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                             pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                             pn_top in number,pd_Fecpro in date,pn_mto in number,
                             pn_ord in number) return varchar2 ;
--mod@abr 20170202
end PQ_CR_DESGRAVAMEN;
/

create or replace package body PQ_CR_DESGRAVAMEN is

procedure sp_cr_seg_desg_diario(pd_fecini in date)is
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
    -- Fecha de Modificación      : 14/08/2024
    -- Autor de la Modificación   : eninah
    -- Descripción de Modificación: se modifico código del procedimiento sp_transf_sigs_retail_pagos
    --                              
  -- *****************************************************************
ln_temp number(3);
begin
          -- limpia tablas antes de procesar la fecha
					execute immediate('Truncate table JAQZ428');
					execute immediate('Truncate table JAQZ428p');
					commit;	 
          --proceso para generar el alta del seguro desgravamen diario
					sp_cr_carga_job_alta(pd_fecini);
					--sp_cr_altaseg_desg_diario(pd_fecini);
					commit;
					--proceso para generar la baja del seguro desgravamen, en simultaneo usando jobs.
					DBMS_LOCK.Sleep( 10 );
					---------- BAJAS
					ln_temp:=1;
					while ln_temp>0 loop
					   select count(*) into ln_temp from dba_jobs where upper(what) like '%SP_CR_ALTASEG_DESG_DIARIO%';
						 if ln_temp=0 then
								sp_cr_carga_job_baja(pd_fecini);
						 end if;
					end loop;
					commit;
					---------PAGOS
					DBMS_LOCK.Sleep( 10 );
					
					ln_temp:=1;
					while ln_temp>0 loop
					   select count(*) into ln_temp from dba_jobs where upper(what) like '%SP_CR_BAJASEG_DESG_DIARIO%';
						 if ln_temp=0 then
								sp_cr_carga_job_pago(pd_fecini);
						 end if;
					end loop;
					commit;
					----- comprobar que termino el jobs de pagos.
					DBMS_LOCK.Sleep( 1 );
					ln_temp:=1;
					while ln_temp>0 loop
					   select count(*) into ln_temp from dba_jobs where upper(what) like '%SP_CR_PAGOSEG_DESG_DIARIO%';
						 if ln_temp=0 then
								exit;
						 end if;
					end loop;
					commit;
					
					--proceso para realizar la transferencia de los procesos de alta,baja y pagos al SIGSRETAIL.
          sp_transf_sigs_retail_altabaja;
					sp_transf_sigs_retail_pagos;
					commit;
end sp_cr_seg_desg_diario;
---------------------------------------------------------------------------------------------------------
procedure sp_transf_sigs_retail_altabaja is
CURSOR c1 IS
    SELECT * FROM jaqz428;
BEGIN
  FOR i IN c1 LOOP  
    INSERT INTO "CMAC_CargaDiaria"@sisretail  
      ("ITEM","PLAN_SEGURO", "PATCLIENTE","MATCLIENTE","NOMBRECLIENTE","IDC","TIP_IDC","EMAIL",
       "ESTADOCIVIL","SEXO","FECHA_NAC","TELEFONO","OCUPACION","UBIGEO_CLIENTE","DIRECCION","PRODUCTO","CODIGO_SUCURSAL",
       "FUNCIONARIO","ESTADO_CREDITO","NRO_CREDITO","MONEDA_CUENTA","FECHA_CANCELACION","FECHA_DESEMBOLSO","COSTO_SEGURO","IMPORTE_CREDITO","TASA","SOBRETASA","FECHA_AFILIACION") 
    VALUES
      (i.JAQZ428ITM,i.JAQZ428PSG,i.JAQZ428PAT,i.JAQZ428MAT ,i.JAQZ428NME,i.JAQZ428IDC,i.JAQZ428TIDC,i.JAQZ428MAI,
       i.JAQZ428STC,i.JAQZ428SEX,i.JAQZ428FNC,i.JAQZ428TEL,i.JAQZ428OCU,i.JAQZ428UCL,i.JAQZ428DIR,i.JAQZ428PRD,i.JAQZ428SUC,
       i.JAQZ428FUN,i.JAQZ428ETC,i.JAQZ428NCR,i.JAQZ428MND,i.JAQZ428FCA,i.JAQZ428FDE,i.JAQZ428CSG,i.JAQZ428ICR,i.JAQZ428TSA,i.JAQZ428STSA,i.jaqz428faf);
    COMMIT;
   
  END loop;
  COMMIT;
end sp_transf_sigs_retail_altabaja;

procedure sp_transf_sigs_retail_pagos is

CURSOR c1 IS

    SELECT * FROM JAQZ428P;

begin
  
--Se comento debido a que la tabla en mencion ya no existe.
/*
  FOR i IN c1 LOOP  
    INSERT INTO "CMAC_RespuestaDesgravamen"@sisretail 
      ("CodProducto","NumCertificado","NumCuota","FecPagoCuota","MontoPrimaCuota","SaldoInsoluto","Tasa","SobreTasa")
    VALUES
      (i.JAQZ428CPRD,i.JAQZ428NCRD,i.JAQZ428NCUO ,i.JAQZ428FPGO,i.JAQZ428MTPR,i.JAQZ428SDOI,i.jaqz428tsa,i.jaqz428stsa);
    COMMIT;
  END loop;
  COMMIT;*/
  null;

end sp_transf_sigs_retail_pagos;

---------------------------------------------------------------------------------------------------------
procedure sp_cr_altaseg_desg_diario(P_C_DIGITO in varchar2, pd_fecini in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_altaseg_desg_diario
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.08.16
    -- Autor de Creación          : HSUAREZ
    -- Uso                        : Ejecuta el proceso de altas con seguro degravamen segun fecha de proceso.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --                              
    -- *****************************************************************
     cursor c_clientes_job is 
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
                 a.aostat,
                 a.aofe99,
                 a.aoimp,
                 a.aoperiod,
								 b.pp001aux2
            from fsd010 a,FPP001 b
           where a.aofval=pd_fecini
             and a.aomod in (select modulo from fst111 where dscod = 50)
             and a.pgcod  = b.pgcod
             and a.aomod  = b.aomod
             and a.aosuc  = b.aosuc
             and a.aomda  = b.aomda
             and a.aopap  = b.aopap
             and a.aocta  = b.aocta
             and a.aooper = b.aooper
             and a.aosbop = b.aosbop
             and a.aotope = b.aotope
             and b.SGCOD in (select tp1imp1 
                               from fst198 
                              where tp1cod=1 
                                and tp1cod1= 10898 
                                and tp1corr1=8)
						 AND to_char(substr(trim(a.aocta), -1, 1)) = P_C_DIGITO; --2016.09.08 EJECUCION JOBS.

     ln_patcliente varchar(50);
     ln_matcliente varchar(50);
     ln_nombrecli  varchar(80);
     ln_fecnac     char(10);  
     ln_sex        char(1);
     ln_est_cv     varchar(20);
     ln_ndoc       varchar(12);  
     ln_tdoc       char(3);
		 ln_ppai       char(3); 
		  --juridica
		 lc_razsoc     char(70); 
		 ln_paij       char(3);
		 ln_tdoj       char(3);
		 lc_ndoj       varchar(12);      
     --finjuridica                   
     ln_mail       varchar(100);
     ln_telf       varchar(50);
     ln_ocupacion  varchar(50);   
     ln_ubigeo     varchar(8);
     ln_direccion  varchar(200);
     ln_grupo      number(2);
     ln_tasa       number(17,6);
     ln_stasa      number(3);
		 ln_cstasa     char(2);
     ln_instancia  number(10);
     ln_mtoapr     number(17,2);
		 
		 lc_coderr varchar2(150);
     lc_msgerr varchar2(100);      
  BEGIN
       
       for job in c_clientes_job loop
       begin
        select 
               SUBSTR(F.PENDOC,1,12),    	    -- Mumero de Documento
				       SUBSTR(F.PETDOC,1,3),          -- Tipo de Documento
							 substr(f.pepais,1,3),          -- PAIS del Documento.  
               SUBSTR(FN_MAIL(F.CTNRO),1,50), -- Email
               SUBSTR(FN_TELCLIE(TRIM(F.PENDOC)),1,50)-- Telefono      
          into
               ln_ndoc,
               ln_tdoc,
							 ln_ppai,
               ln_mail,
               ln_telf  
          from FSR008 F -- CUENTA DOCOMENTOS
          WHERE    F.CTNRO=job.aocta
						   AND F.CTTFIR = 'T';
          exception
          when no_data_found then
               ln_ndoc :='-';
               ln_tdoc :='-';
							 ln_ppai :='-';
               ln_mail :='-';
               ln_telf :='-';
        end;
				
				--- EN CASO QUE SEA PERSONA JURIDICA
				if ln_tdoc=9 then 
				    begin
				         select trim(j.pjrazs) 
                  into lc_razsoc
                  from fsd003 j 
                 where j.pjpais = ln_ppai
                   and j.pjtdoc = ln_tdoc
                   and j.pjndoc = ln_ndoc;
            exception
                   when no_data_found then
                   lc_razsoc := '-';
            end;    
            --OBTIENE AL REPRESENTANTE LEGAL
            /*
						begin
               select a.pfpai1,
                      a.pftdo1,
                      a.pfndo1
                 into ln_paij,
                      ln_tdoj,
                      lc_ndoj
                 from fsr003 a
                where a.pjpais = ln_ppai
                  and a.pjtdoc = ln_tdoc
                  and a.pjndoc = ln_ndoc;
            exception
                  when too_many_rows then
                       begin
                           select a.pfpai1,
                                  a.pftdo1,
                                  a.pfndo1
                             into ln_paij,
                                  ln_tdoj,
                                  lc_ndoj
                             from fsr003 a
                            where a.pjpais = ln_ppai
                              and a.pjtdoc = ln_tdoc
                              and a.pjndoc = ln_ndoc
                              and a.vicod  <> 1
                              and rownum = 1;
                       exception
                              when no_data_found then null;
                                                 
                       end; 
                  when no_data_found then null;          
             end;
				   ln_ppai := ln_paij;
					 ln_tdoc := ln_tdoj;
					 ln_ndoc := lc_ndoj;
					 */					 
				end if;
				
				--PERSONA JURIDICA.
				if ln_tdoc<>9 then
					begin     
					select 
								 SUBSTR(P.PFAPE1,1,30)  PATCLIENTE,  -- Apellido Paterno
								 SUBSTR (P.PFAPE2,1,30) MATCLIENTE,  -- Apellido Materno
								 SUBSTR(trim(P.PFNOM1) ||' '|| trim(P.PFNOM2),1,30) NOMBRECLIENTE,
								 TO_CHAR(P.PFFNAC,'DD/MM/YYYY') FECHA_NAC,-- Fecha de Nacimiento
								 SUBSTR(P.PFCANT,1,1) SEXO,          -- Sexo
								 SUBSTR((SELECT ECNOM FROM FST009 WHERE ECCOD=P.PFECIV),1,20) ESTADOCIVIL -- Estado Civil
						into 
								 ln_patcliente,
								 ln_matcliente,
								 ln_nombrecli,
								 ln_fecnac,
								 ln_sex,
								 ln_est_cv
						from FSD002 P -- DATOS PERSONA - ESTADO CIVIL
						where
										 p.pfpais=ln_ppai and
										 p.Pftdoc=ln_tdoc and
										 P.PFNDOC=ln_ndoc;
								 --AND P.PFTDOC=trim(ln_tdoc);
						exception
						when no_data_found then
								 ln_patcliente :='-';
								 ln_matcliente :='-';
								 ln_nombrecli  :='-';
								 ln_fecnac     :='-';
								 ln_sex        :='-';
								 ln_est_cv     :='-';
					end;
				else
				         ln_patcliente :='-';
								 ln_matcliente :='-';
								 ln_nombrecli  :=SUBSTR (lc_razsoc,1,30);
								 ln_fecnac     :='-';
								 ln_sex        :='-';
								 ln_est_cv     :='-';
			  end if;
        begin  
       	select 
               SUBSTR((SELECT SNGC07DSC FROM SNGC07 WHERE SNGC07COD=O.OCUCOD),1,50) OCUPACION-- Ocupación
				  into
               ln_ocupacion 
          from FSE002 O -- OCUPACION
       	  where
                   O.PFXNDOC=ln_ndoc
						   AND O.PFXTDOC=ln_tdoc
							 and o.pfxpais=ln_ppai;
          exception
          when no_data_found then
               ln_ocupacion :='-';
        end;
				--DIRECCION Y UBIGEO
        begin 
				select 
               SUBSTR(D.SNGC13UGEO,1,8) UBIGEO_CLIENTE,   -- Ubigeo de la dirección
				       SUBSTR(D.SNGC13DIR,1,100) DIRECCION       -- Direccion
				  into
               ln_ubigeo,
               ln_direccion                            
          from SNGC13 D -- DIRECCION
				  where
                   D.docod=1
               AND D.SNGC13NDOC=ln_ndoc
							 and D.SNGC13PAIS=ln_ppai
							 and d.Sngc13tdoc=ln_tdoc
							 and d.sngc13corr= (select max(sngc13corr) from sngc13 where docod=1 
																															 AND SNGC13NDOC=ln_ndoc
																															 and SNGC13PAIS=ln_ppai
																															 and Sngc13tdoc=ln_tdoc
																															 and sngc13est='H'
							                   	)
               and rownum=1;
          exception
          when no_data_found then
               ln_ubigeo :='-';
               ln_direccion :='-';
        end; 
        --grupo
          ln_grupo := pq_cr_tramdesgra.Fn_tipoSBS(job.pgcod,job.aomod,job.aosuc,job.aomda,job.aopap,
                                                  job.aocta,job.aooper,job.aosbop,job.aotope);                                                      
        --tipo SBS RCC si es nulo
          if ln_grupo is null then
             ln_grupo := pq_cr_tramdesgra.Fn_tipoSBS_Des(job.pgcod,job.aomod,job.aosuc,job.aomda,job.aopap,
                                                         job.aocta,job.aooper,job.aosbop,job.aotope);
          end if;
					if ln_grupo=1 or ln_grupo=2 or ln_grupo=12 or ln_grupo=13 then
					   if job.aoimp<=20000 then
						    ln_grupo:=1;
						 else
						    ln_grupo:=2;
						 end if;
					end if;                                 
          --plan
          --case  
          --    when ln_grupo in (2,12,13) then lc_plan := 'PYME';
          --    when ln_grupo = 3 then lc_plan := 'CONSUMO';
          --    when ln_grupo = 4 then lc_plan := 'HIPOTECARIO';
          --else null;
          -- end case;          
        ln_instancia := fn_instancia_credito(job.aomod,job.aosuc,job.aomda,job.aopap,
                                             job.aocta,job.aooper,job.aosbop,job.aotope);
        --monto aprobado
        ln_mtoapr := pq_cr_tramdesgra.fn_montoAprobado(ln_instancia); 
        ln_tasa   := pq_cr_seguro_desgravamen.FN_TASA_DESGRAVAMEN(job.pgcod,job.aomod,job.aosuc,job.aomda,job.aopap,
                                                                job.aocta,job.aooper,job.aosbop,job.aotope,
                                                                ln_mtoapr); -- nota el maximo de decimales que devuelve la funcion es 6 y 17 enteros
        --sobretasa
        /*if ln_tasa<>job.pp001aux2 then
           --ln_stasa :=(job.pp001aux2*100);
					 ln_stasa :=1;
					 ln_cstasa:='si';
        else
           ln_stasa :=0;
					 ln_cstasa:='no';					 
        end if;*/ 
				if ln_tasa not in (0.1,0.05) then
							 --ln_stasa :=(job.pp001aux2*100);
							 ln_stasa :=1;
							 ln_cstasa:='si';
						else
							 ln_stasa :=0;
							 ln_cstasa:='no';					 
						end if; 
			 begin
			 
			 --
						------------------------------------------------------------------------------
						------------------------------------------------------------------------------
						if ln_patcliente is null then ln_patcliente:='-'; end if;
						if ln_matcliente is null then ln_matcliente:='-'; end if;
						if ln_nombrecli is null then ln_nombrecli:='-'; end if;
						if ln_ndoc is null then ln_ndoc:='-'; end if;
						if ln_tdoc is null then ln_tdoc:='-'; end if;
						if ln_mail is null then ln_mail:='-'; end if;
						if ln_est_cv is null then ln_est_cv:='-'; end if;
						if ln_sex is null then ln_sex:='-'; end if;
						if ln_telf is null then ln_telf:='-'; end if;
						if ln_ocupacion is null then ln_ocupacion:='-'; end if;
						if trim(ln_ubigeo) is null then ln_ubigeo:='-'; end if;
						if trim(ln_direccion) is null then ln_direccion:='-'; end if;
						
						-------------------------------------------------------------------------------
						
       INSERT INTO JAQZ428 
       (
          JAQZ428ITM ,    -- ITEM
          JAQZ428PAT ,    -- Apellido Paterno     
          JAQZ428MAT ,    -- Apellido Materno
          JAQZ428NME ,    -- Nombre
          JAQZ428IDC ,    -- num. doc.
          JAQZ428TIDC,    -- tipo doc.
          JAQZ428MAI ,    -- email
          JAQZ428STC ,    -- estado civil
          JAQZ428SEX ,    -- sexo
          JAQZ428FNC ,    -- fecha de nacimiento
          JAQZ428TEL ,    -- telefono
          JAQZ428OCU ,    -- ocupacion
          JAQZ428UCL ,    -- ubigeo
          JAQZ428DIR ,    -- direccion
          JAQZ428PRD ,    -- Código del Producto (fijo)
          JAQZ428SUC ,    -- Sucursal
          JAQZ428FUN ,    -- Funcionario
          JAQZ428ETC ,    -- Estado credito 
          JAQZ428NCR ,    -- nro. del credito
          JAQZ428MND ,    -- moneda 
          JAQZ428FCA ,    -- fecha de cancelacion del credito
          JAQZ428FDE ,    -- fecha de desembolso                                          
          JAQZ428PSG , 	  -- PLAN SEGURO
          JAQZ428CSG ,    -- COSTO SEGURO
          --JAQZ428CFL , 
          JAQZ428ICR ,    -- IMPORTE CREDITO
          --JAQZ428PMS ,
          --JAQZ428NCA ,
          --JAQZ428HDS ,
          JAQZ428TSA,     -- TASA
          jaqz428stsa,    -- SOBRETASA
					jaqz428faf      -- FECHA_AFILIACION
					--tbcuenta,
					--tboperacion
       )
       values
       (
          '1',           -- Item
          ln_patcliente, -- Apellido Paterno
          ln_matcliente, -- Apellido Materno 
          ln_nombrecli,  -- Nombre
          ln_ndoc,       -- num. doc.
          ln_tdoc,       -- tipo doc.
          ln_mail,       -- email
          ln_est_cv,     -- estado civil
          ln_sex,        -- sexo
          ln_fecnac,     -- fecha de nacimiento
          ln_telf,       -- telefono
          ln_ocupacion,  -- ocupacion
          ln_ubigeo,     -- ubigeo
          ln_direccion,  -- direccion
          '0006',        -- Código del Producto (fijo)
				  job.aosuc,     -- Sucursal
          FN_ANALISTA_CREDITO(job.aomod,job.AOSUC,job.AOMDA,job.AOPAP,job.AOCTA,job.AOOPER,job.AOSBOP,job.aotope),-- Funcionario
				  SUBSTR((SELECT T.CENOM FROM FST026 T WHERE T.CECOD=job.AOSTAT),1,1),-- Estado Credito
				  SUBSTR(LPAD(job.AOCTA, 9, '0') || LPAD(job.AOMOD, 3, '0') || LPAD(job.AOMDA, 3, '0') ||
          LPAD(job.AOOPER, 9, '0') || LPAD(job.AOTOPE, 3, '0'),1,30),-- Nro del Credito
				  DECODE(job.AOMDA,'0','001','002'),    -- Moneda
				  TO_CHAR(job.AOFE99,'DD/MM/YYYY'),     -- Fecha de cancelacion del credito
				  TO_CHAR(job.AOFVAL,'DD/MM/YYYY'),      -- Fecha de desembolso del credito   
          ln_grupo, -- plan seguro
          1,        -- costo seguro
          LPAD((job.aoimp*100),16,0),-- importe credito -- se multiplica x100 ya que el aoimp solo tiene maximo 2 decimales
          LPAD((ln_tasa*100000000),12,0),--se multiplica x100000000 por que la tasa puede tener máximo 8 decimales --ln_tasa,  -- tasa
					ln_stasa,--ln_cstasa,--ln_stasa,  -- sobretasa
					TO_CHAR(job.AOFVAL,'DD/MM/YYYY') --fecha de afiliacion.  
					-- borrar solo para pruebas
					--job.aocta, -- borrar solo para pruebas.
					--job.aooper-- borrar solo para pruebas.
       );
			 exception												
							when others then
								   lc_coderr := sqlcode;
								   lc_msgerr := sqlerrm;
									 INSERT INTO jaqz428aux 
                   (
									  jaqz428cta, 
										jaqz428ope,
										jaqz428fc , 
										jaqz428err, 
										jaqz428msg, 
										jaqz428fec 
                   )
									 values
									 (
									  job.aocta,
										job.aooper,
										pd_fecini,
									  lc_coderr,
                    lc_msgerr,
										sysdate
									 );
			 end;       
       end loop;
			 
       commit;

end sp_cr_altaseg_desg_diario;
---------------------------------------------------------------------------------------------------------
procedure sp_cr_bajaseg_desg_diario(P_C_DIGITO in varchar2, pd_fecini in date) is

    -- *****************************************************************
    -- Nombre                     : sp_cr_bajaseg_desg_diario
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.08.16
    -- Autor de Creación          : HSUAREZ
    -- Uso                        : Ejecuta el proceso para obtener las cancelaciones con seguro desgravamen(bajas).
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --                              
    -- *****************************************************************

     cursor c_clientes_job  is 
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
                 a.aostat,
                 a.aofe99,
                 a.aoimp,
                 a.aoperiod,
								 b.pp001aux2
            from fsd010 a,FPP001 b
            where a.aofe99=pd_fecini -- esta condicion define solo se define cuando buscamos creditos en baja(cancelados)
					   and a.aomod in (select modulo from fst111 where dscod = 50)
             and a.pgcod  = b.pgcod
             and a.aomod  = b.aomod
             and a.aosuc  = b.aosuc
             and a.aomda  = b.aomda
             and a.aopap  = b.aopap
             and a.aocta  = b.aocta
             and a.aooper = b.aooper
             -- estas dos condiciones no se cumplen por que no necesarimente se mantienen
						 -- las mismas suboperaciones solo se mantiene cuando se desembolsa.
             --and a.aosbop = b.aosbop
             --and a.aotope = b.aotope
             and a.aostat = 99 -- esta condicion define solo los creditos en baja. es decir ya cancelados.
             and b.SGCOD in (select tp1imp1 
                               from fst198 
                              where tp1cod=1 
                                and tp1cod1= 10898 
                                and tp1corr1=8)
             AND to_char(substr(trim(a.aocta), -1, 1)) = P_C_DIGITO; 
     --Variables temporales
     ln_patcliente varchar(50);
     ln_matcliente varchar(50);
     ln_nombrecli  varchar(80);
     ln_fecnac     char(10);  
     ln_sex        char(1);
     ln_est_cv     varchar(20);
     ln_ndoc       varchar(12);  
     ln_tdoc       char(3);   		 
		 ln_ppai       char(3);
		  --juridica
		 lc_razsoc     char(70); 
		 ln_paij       char(3);
		 ln_tdoj       char(3);
		 lc_ndoj       varchar(12);      
     --finjuridica                           
     ln_mail       varchar(100);
     ln_telf       varchar(50);
     ln_ocupacion  varchar(50);   
     ln_ubigeo     varchar(8);
     ln_direccion  varchar(200);
     ln_grupo      number(2);
     ln_tasa       number(17,6);
     ln_stasa      number(3);
		 ln_cstasa     char(2);
     ln_instancia  number(10);
     ln_mtoapr     number(17,2);
		 lc_coderr varchar2(150);
     lc_msgerr varchar2(100);     
  BEGIN
       
       for job in c_clientes_job loop
       begin
        select 
               SUBSTR(F.PENDOC,1,12),    	       -- Mumero de Documento
				       SUBSTR(F.PETDOC,1,3),             -- Tipo de Documento  
							 substr(f.pepais,1,3),             -- PAIS del Documento. 
               SUBSTR(FN_MAIL(F.CTNRO),1,50),    -- Email
               SUBSTR(FN_TELCLIE(TRIM(F.PENDOC)),1,50)-- Telefono      
          into
               ln_ndoc,
               ln_tdoc,
							 ln_ppai,
               ln_mail,
               ln_telf  
          from FSR008 F -- CUENTA DOCUMENTOS
          WHERE    f.ctnro  = job.aocta
						   AND F.CTTFIR = 'T';
          exception
          when no_data_found then
               ln_ndoc :='-';
               ln_tdoc :='-';
							 ln_ppai :='-';
               ln_mail :='-';
               ln_telf :='-';
        end;
				--- EN CASO QUE SEA PERSONA JURIDICA
				if ln_tdoc=9 then 
				    begin
				         select trim(j.pjrazs) 
                  into lc_razsoc
                  from fsd003 j 
                 where j.pjpais = ln_ppai
                   and j.pjtdoc = ln_tdoc
                   and j.pjndoc = ln_ndoc;
            exception
                   when no_data_found then
                   lc_razsoc := '-';
            end;    
            --OBTIENE AL REPRESENTANTE LEGAL
            /*
						begin
               select a.pfpai1,
                      a.pftdo1,
                      a.pfndo1
                 into ln_paij,
                      ln_tdoj,
                      lc_ndoj
                 from fsr003 a
                where a.pjpais = ln_ppai
                  and a.pjtdoc = ln_tdoc
                  and a.pjndoc = ln_ndoc;
            exception
                  when too_many_rows then
                       begin
                           select a.pfpai1,
                                  a.pftdo1,
                                  a.pfndo1
                             into ln_paij,
                                  ln_tdoj,
                                  lc_ndoj
                             from fsr003 a
                            where a.pjpais = ln_ppai
                              and a.pjtdoc = ln_tdoc
                              and a.pjndoc = ln_ndoc
                              and a.vicod  <> 1
                              and rownum = 1;
                       exception
                              when no_data_found then null;
                                                 
                       end; 
                  when no_data_found then null;          
             end;
				   ln_ppai := ln_paij;
					 ln_tdoc := ln_tdoj;
					 ln_ndoc := lc_ndoj;
					 */					 
				end if;
				
				--PERSONA JURIDICA.
				if ln_tdoc<>9 then				
						begin     
						select 
									 SUBSTR(P.PFAPE1,1,30)  PATCLIENTE,  -- Apellido Paterno
									 SUBSTR (P.PFAPE2,1,30) MATCLIENTE,  -- Apellido Materno
									 SUBSTR(trim(P.PFNOM1) ||' '|| trim(P.PFNOM2),1,30) NOMBRECLIENTE,
									 TO_CHAR(P.PFFNAC,'DD/MM/YYYY') FECHA_NAC,-- Fecha de Nacimiento
									 SUBSTR(P.PFCANT,1,1) SEXO,          -- Sexo
									 SUBSTR((SELECT ECNOM FROM FST009 WHERE ECCOD=P.PFECIV),1,20) ESTADOCIVIL -- Estado Civil
							into 
									 ln_patcliente,
									 ln_matcliente,
									 ln_nombrecli,
									 ln_fecnac,
									 ln_sex,
									 ln_est_cv
							from FSD002 P -- DATOS PERSONA - ESTADO CIVIL
						 where
											 p.pfpais=ln_ppai and
											 p.Pftdoc=ln_tdoc and
											 P.PFNDOC=ln_ndoc;
									 --AND P.PFTDOC=trim(ln_tdoc);
							exception
							when no_data_found then
									 ln_patcliente :='-';
									 ln_matcliente :='-';
									 ln_nombrecli  :='-';
									 ln_fecnac     :='-';
									 ln_sex        :='-';
									 ln_est_cv     :='-';
						end;
				else
				    ln_patcliente :='-';
						ln_matcliente :='-';
						ln_nombrecli  :=SUBSTR (lc_razsoc,1,30);
						ln_fecnac     :='-';
						ln_sex        :='-';
						ln_est_cv     :='-';
				end if;
				begin
				if ln_nombrecli is not null then
						begin  
						select 
									 SUBSTR((SELECT SNGC07DSC FROM SNGC07 WHERE SNGC07COD=O.OCUCOD),1,50) OCUPACION-- Ocupación
							into
									 ln_ocupacion 
							from FSE002 O -- OCUPACION
							where
											 O.PFXNDOC=ln_ndoc
									 AND O.PFXTDOC=ln_tdoc
									 and O.PFXPAIS=ln_ppai;
							exception
							when no_data_found then
									 ln_ocupacion :='-';
						end;
						begin 
						select 
									 SUBSTR(D.SNGC13UGEO,1,8) UBIGEO_CLIENTE,  -- Ubigeo de la dirección
									 SUBSTR(D.SNGC13DIR,1,100) DIRECCION       -- Direccion
							into
									 ln_ubigeo,
									 ln_direccion                            
							from SNGC13 D -- DIRECCION
							where
											 D.docod=1
									 AND D.SNGC13NDOC=ln_ndoc
									 and d.sngc13pais=ln_ppai
									 and d.sngc13tdoc=ln_tdoc
									 and d.sngc13corr= (select max(sngc13corr) from sngc13 where docod=1 
																															 AND sngc13ndoc=ln_ndoc
																															 and SNGC13PAIS=ln_ppai
																															 and Sngc13tdoc=ln_tdoc
																															 and sngc13est='H' 
							                   	)
									 and rownum=1;
							exception
							when no_data_found then
									 ln_ubigeo :='-';
									 ln_direccion :='-';
						end; 
						--grupo 
						ln_grupo :=1;--temporal borrar
						-- COMENTADO EN BAJAS YA QUE NO ES NECESARIO SEGUN CORREO DE JORGE CHIRINOS.
						--	ln_grupo := pq_cr_tramdesgra.Fn_tipoSBS(job.pgcod,job.aomod,job.aosuc,job.aomda,job.aopap,
						--																					job.aocta,job.aooper,job.aosbop,job.aotope);                                                      
						--tipo SBS RCC si es nulo
						--	if ln_grupo is null then
						--		 ln_grupo := pq_cr_tramdesgra.Fn_tipoSBS_Des(job.pgcod,job.aomod,job.aosuc,job.aomda,job.aopap,
						--																								 job.aocta,job.aooper,job.aosbop,job.aotope);
						--	end if;
							if ln_grupo=1 or ln_grupo=2 or ln_grupo=12 or ln_grupo=13 then
								 if job.aoimp<=20000 then
										ln_grupo:=1;
								 else
										ln_grupo:=2;
								 end if;
							end if;                                 
						--plan
							/*case  
							    when ln_grupo in (2,12,13) then lc_plan := 'PYME';
							    when ln_grupo = 3 then lc_plan := 'CONSUMO';
							    when ln_grupo = 4 then lc_plan := 'HIPOTECARIO';
							else null;
							end case;          */
						ln_instancia := fn_instancia_credito(job.aomod,job.aosuc,job.aomda,job.aopap,
																								 job.aocta,job.aooper,job.aosbop,job.aotope);
						--monto aprobado
						ln_mtoapr := pq_cr_tramdesgra.fn_montoAprobado(ln_instancia); 
						ln_tasa   := pq_cr_seguro_desgravamen.FN_TASA_DESGRAVAMEN(job.pgcod,job.aomod,job.aosuc,job.aomda,job.aopap,
																																		job.aocta,job.aooper,job.aosbop,job.aotope,
																																		ln_mtoapr);
						--sobretasa
						/*if ln_tasa<>job.pp001aux2 then
							 --ln_stasa :=(job.pp001aux2*100);
							 ln_stasa :=1;
							 ln_cstasa:='si';
						else
							 ln_stasa :=0;
							 ln_cstasa:='no';					 
						end if; */
						if ln_tasa not in (0.1,0.05) then
							 --ln_stasa :=(job.pp001aux2*100);
							 ln_stasa :=1;
							 ln_cstasa:='si';
						else
							 ln_stasa :=0;
							 ln_cstasa:='no';					 
						end if; 
						--
						------------------------------------------------------------------------------
						------------------------------------------------------------------------------
						if ln_patcliente is null then ln_patcliente:='-'; end if;
						if ln_matcliente is null then ln_matcliente:='-'; end if;
						if ln_nombrecli is null then ln_nombrecli:='-'; end if;
						if ln_ndoc is null then ln_ndoc:='-'; end if;
						if ln_tdoc is null then ln_tdoc:='-'; end if;
						if ln_mail is null then ln_mail:='-'; end if;
						if ln_est_cv is null then ln_est_cv:='-'; end if;
						if ln_sex is null then ln_sex:='-'; end if;
						if ln_telf is null then ln_telf:='-'; end if;
						if ln_ocupacion is null then ln_ocupacion:='-'; end if;
						if trim(ln_ubigeo) is null then ln_ubigeo:='-'; end if;
						if trim(ln_direccion) is null then ln_direccion:='-'; end if;
						
						-------------------------------------------------------------------------------
						-------------------------------------------------------------------------------
			      begin
						 INSERT INTO jaqz428 
						 (
								JAQZ428ITM ,    -- ITEM
								JAQZ428PAT ,    -- Apellido Paterno     
								JAQZ428MAT ,    -- Apellido Materno
								JAQZ428NME ,    -- Nombre
								JAQZ428IDC ,    -- num. doc.
								JAQZ428TIDC,    -- tipo doc.
								JAQZ428MAI ,    -- email
								JAQZ428STC ,    -- estado civil
								JAQZ428SEX ,    -- sexo
								JAQZ428FNC ,    -- fecha de nacimiento
								JAQZ428TEL ,    -- telefono
								JAQZ428OCU ,    -- ocupacion
								JAQZ428UCL ,    -- ubigeo
								JAQZ428DIR ,    -- direccion
								JAQZ428PRD ,    -- Código del Producto (fijo)
								JAQZ428SUC ,    -- Sucursal
								JAQZ428FUN ,    -- Funcionario
								JAQZ428ETC ,    -- Estado credito 
								JAQZ428NCR ,    -- nro. del credito
								JAQZ428MND ,    -- moneda 
								JAQZ428FCA ,    -- fecha de cancelacion del credito
								JAQZ428FDE ,    -- fecha de desembolso                                          
								JAQZ428PSG , 	  -- PLAN SEGURO
								JAQZ428CSG ,    -- COSTO SEGURO
								--JAQZ428CFL , 
								JAQZ428ICR ,    -- IMPORTE CREDITO
								--JAQZ428PMS ,
								--JAQZ428NCA ,
								--JAQZ428HDS ,
								JAQZ428TSA,     -- TASA
								jaqz428stsa,    -- SOBRETASA
								jaqz428faf      -- FECHA_AFILIACION
								--tbcuenta,
								--tboperacion
						 )
						 values
						 (
								'1',           -- Item
								ln_patcliente, -- Apellido Paterno
								ln_matcliente, -- Apellido Materno 
								ln_nombrecli,  -- Nombre
								ln_ndoc,       -- num. doc.
								ln_tdoc,       -- tipo doc.
								ln_mail,       -- email
								ln_est_cv,     -- estado civil
								ln_sex,        -- sexo
								ln_fecnac,     -- fecha de nacimiento
								ln_telf,       -- telefono
								ln_ocupacion,  -- ocupacion
								ln_ubigeo,     -- ubigeo
								ln_direccion,  -- direccion
								'0006',        -- Código del Producto (fijo)
								job.aosuc,     -- Sucursal
								FN_ANALISTA_CREDITO(job.aomod,job.AOSUC,job.AOMDA,job.AOPAP,job.AOCTA,job.AOOPER,job.AOSBOP,job.aotope),-- Funcionario
								SUBSTR((SELECT T.CENOM FROM FST026 T WHERE T.CECOD=job.AOSTAT),1,1),-- Estado Credito
								SUBSTR(LPAD(job.AOCTA, 9, '0') || LPAD(job.AOMOD, 3, '0') || LPAD(job.AOMDA, 3, '0') ||
								LPAD(job.AOOPER, 9, '0') || LPAD(job.AOTOPE, 3, '0'),1,30),-- Nro del Credito
								DECODE(job.AOMDA,'0','001','002'),    -- Moneda
								TO_CHAR(job.AOFE99,'DD/MM/YYYY'),     -- Fecha de cancelacion del credito
								TO_CHAR(job.AOFVAL,'DD/MM/YYYY'),     -- Fecha de desembolso del credito   
								ln_grupo, -- plan seguro
								1,        -- costo seguro
								LPAD((job.aoimp*100),16,0),-- importe credito -- se multiplica x100 ya que el aoimp solo tiene maximo 2 decimales
                LPAD((ln_tasa*100000000),12,0),--se multiplica x100000000 por que la tasa puede tener máximo 8 decimales --ln_tasa,  -- tasa
								ln_stasa,--,--ln_cstasa,--ln_stasa,  -- sobretasa
								TO_CHAR(job.AOFVAL,'DD/MM/YYYY')
								-- borrar solo para pruebas
								--job.aocta, -- borrar solo para pruebas.
								--job.aooper-- borrar solo para pruebas.
						 );
						 exception												
							when others then
								   lc_coderr := sqlcode;
								   lc_msgerr := sqlerrm;
									 INSERT INTO jaqz428aux 
                   (
									  jaqz428cta, 
										jaqz428ope,
										jaqz428fc , 
										jaqz428err, 
										jaqz428msg, 
										jaqz428fec 
                   )
									 values
									 (
									  job.aocta,
										job.aooper,
										pd_fecini,
									  lc_coderr,
                    lc_msgerr,
										sysdate
									 );
						 end;
						 commit;
			 end if;
			 end;
     end loop;

end sp_cr_bajaseg_desg_diario;
---------------------------------------------------------------------------------------------------------
procedure sp_cr_pagoseg_desg_diario(P_C_DIGITO in varchar2,pd_fecini in date) is
     lc_coderr varchar2(150);
     lc_msgerr varchar2(100);
    cursor c_clientes_job is 
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
                 a.aostat,
                 a.aofe99,
                 a.aoimp,
                 a.aoperiod,
								 b.pp001aux2
            from fsd010 a,FPP001 b
            --where a.aofe99=pd_fecini	// se estraen todos los pagos no hay fecha.				      
             where 
						     a.aomod in (select modulo from fst111 where dscod = 50)
             and a.pgcod  = b.pgcod
             and a.aomod  = b.aomod
             and a.aosuc  = b.aosuc
             and a.aomda  = b.aomda
             and a.aopap  = b.aopap
             and a.aocta  = b.aocta
             and a.aooper = b.aooper
             -- estas dos condiciones no se cumplen por que no necesarimente se mantienen
						 -- las mismas suboperaciones solo se mantiene cuando se desembolsa.
             --and a.aosbop = b.aosbop
             --and a.aotope = b.aotope
             --and a.aostat = 99						 
						 --and a.aocta  = 1149583 --1538852--1899971--1433634--1901179---1775582--185338--393778--102333 
						 --and a.aooper = 2407393--2421649--2421374--2424371--2418713--2421364--2266330--2272562
             and b.SGCOD in (select tp1imp1 
                               from fst198 
                              where tp1cod=1 
                                and tp1cod1= 10898 
                                and tp1corr1=8)
						 AND to_char(substr(trim(a.aocta), -1, 1)) = P_C_DIGITO; -- 08-09-2016 JOBS SIMULTANEO.
  
     ln_credito varchar(27);
     ln_cuota varchar(30);
     ln_fpgoc varchar(8);
     ln_valor_r char(1);
		 ln_mtoprima number(17,2);--ln_mtoprima number(17,5); 
		 lc_tip varchar2(1);  
		 ln_ppfpag varchar(8) ;
		 ln_saldo number(17,2);
		 ln_mtoppago number(17,2);
		 lc_flagsd varchar2(1);
  begin
	    for job in c_clientes_job loop
			 
			-- VALIDAR  PAGOS SI EXISTEN O NO EN EL PAGO DIARIO.
			begin								 
			   pq_cr_desgravamen.sp_cr_validapago( job.pgcod,
				                   job.aomod,
													 job.aosuc,
													 job.aomda,
													 job.aopap,
													 job.aocta,
													 job.aooper,
													 job.aosbop,
													 job.aotope,
													 job.aofe99,
													 pd_fecini,
													 job.aoimp,
													 ln_valor_r);               
			end;
			
			begin
			--dbms_output.put_line('probando valor :');
			--dbms_output.put_line(ln_valor_r);
			if (ln_valor_r<>'N') then
			   
			   pq_cr_desgravamen.sp_cr_pagosegxfpago(job.pgcod,
																							 job.aomod,
																							 job.aosuc,
																							 job.aomda,
																							 job.aopap,
																							 job.aocta,
																							 job.aooper,
																							 job.aosbop,	
																							 job.aotope,
																							 job.pp001aux2,
																							 pd_fecini);
																							 
			   
				
			  end if;
				end;
			
       end loop;			 
			
			 commit;	 
end sp_cr_pagoseg_desg_diario;
---------------------------------------------------------------------------------------------------------
Procedure Sp_monto_calendario(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                             pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                             pn_top in number,pn_tip in number,pd_fecpro in date,ln_mtoprima out number,
                             lc_tip out varchar2,flag_sd out char)  is
                             
cursor seguros is
select tp1imp1 tp1nro1 
 from fst198 
where tp1cod   = 1 
  and tp1cod1  = 10898 
  and tp1corr1 = 8;

cursor seguros_ii is
select *
  from fpp001 a 
 where a.pgcod  = pn_emp
   and a.aomod  = pn_mod
   and a.aosuc  = pn_suc
   and a.aomda  = pn_mda
   and a.aopap  = pn_pap
   and a.aocta  = pn_cta
   and a.aooper = pn_ope
   and a.aosbop = pn_sbo
   and a.aotope = pn_top;

cursor calendario_vida is
select *
  from fsd611 a
where a.pgcod  = pn_emp
   and a.ppmod  = pn_mod
   and a.ppsuc  = pn_suc
   and a.ppmda  = pn_mda
   and a.pppap  = pn_pap
   and a.ppcta  = pn_cta
   and a.ppoper = pn_ope
   and a.ppsbop = pn_sbo
   and a.pptope = pn_top;
      
ln_canSeg number(2);     
ln_codVar number(2);          
ld_fecan  date;    

ld_fecini date;

--ln_mtoprima number(17,2) ;
ln_mto11 number(17,2) ;
ln_mto12 number(17,2) ;
ln_mto13 number(17,2) ;
ln_mto14 number(17,2) ;
ln_mto15 number(17,2) ;
--mis variables auxiliares
ln_mtops1 number(17,2);
ln_mtops2 number(17,2);
ln_mtops3 number(17,2);
ln_mtops4 number(17,2);
ln_mtops5 number(17,2);

flag_ptsg char(1);
-- fim
lc_flag char(1);
ln_impAux number(17,2);

lc_flag11 char(1);
ln_impAux11 number(17,2);

lc_flag13 char(1);
ln_impAux13 number(17,2);

ld_pago date;
--lc_tip char(1);
begin

     ld_fecini := to_date('01'||to_char(pd_fecpro,'mmyyyy'),'ddmmyyyy');
     lc_tip :=  null;          

     
     begin

       for i in seguros loop
           ln_canSeg := 0;
           ln_codVar := 0;
           for j in seguros_ii loop
               ln_canSeg := ln_canSeg+1;
               if i.tp1nro1 = j.SgCod then
                  ln_codVar := ln_canSeg;
                  exit;
               end if;
           end loop;
           
           if ln_codVar <> 0 then
                 
                 begin
                     if pn_tip = 1 then --desembolsos
                        lc_tip :=  null;
												
                        begin
                               select min(a.ppfpag)
                                 into ld_fecan
                                 from fsd611 a
                                where a.pgcod  = pn_emp
                                  and a.ppmod  = pn_mod
                                  and a.ppsuc  = pn_suc
                                  and a.ppmda  = pn_mda
                                  and a.pppap  = pn_pap
                                  and a.ppcta  = pn_cta
                                  and a.ppoper = pn_ope
                                  and a.ppsbop = pn_sbo
                                  and a.pptope = pn_top;
                        exception
                            when others then
                                 insert into jaqz097_error
                                 values(pn_cta,pn_ope,1,SYSDATE); 
                                 commit;
                        end;
                        
                        begin
                               select ppimp11,
                                      ppimp12,
                                      ppimp13,
                                      ppimp14,
                                      ppimp15
                                 into ln_mto11,
                                      ln_mto12,
                                      ln_mto13,
                                      ln_mto14,
                                      ln_mto15                                    
                                 from fsd611 a
                                where a.pgcod  = pn_emp
                                  and a.ppmod  = pn_mod
                                  and a.ppsuc  = pn_suc
                                  and a.ppmda  = pn_mda
                                  and a.pppap  = pn_pap
                                  and a.ppcta  = pn_cta
                                  and a.ppoper = pn_ope
                                  and a.ppsbop = pn_sbo
                                  and a.pptope = pn_top
                                  and a.ppfpag = ld_fecan;
                        exception
                            when others then
                                 insert into jaqz097_error
                                 values(pn_cta,pn_ope,2,SYSDATE); 
                                 commit;
                        end;
                                  
                                  
                        
                        case
                            when ln_codVar = 1 then
                                 ln_mtoprima := ln_mto11;
                                 if ln_mtoprima = 2.5 then
                                   ln_impAux := 2.5;
                                   for h in calendario_vida loop
                                       if ln_impAux = h.ppimp11 then
                                                
                                          lc_flag := 'S'; 
                                          else
                                              lc_flag := 'N';
                                              exit;  
                                       end if;
                                       ln_impAux := h.ppimp11;
                                   end loop;
                                   ---      
                                   if lc_flag = 'S' then
                                      ln_mtoprima := ln_mto12;
																			---
																			--if ln_mtoprima = ln_mtops2 then -- Hsuarez - para comparar si = el monto total del SD.
																			--	 flag_ptsg:='S';
																			--end if;
																			---
                                   end if;
                                          
                                 end if;
                                  when ln_codVar = 2 then
                                       ln_mtoprima := ln_mto12;
                                       if ln_mtoprima = 2.5 then
                                             ln_impAux := 2.5;
                                             for h in calendario_vida loop
                                                 if ln_impAux = h.ppimp12 then
                                                    
                                                    lc_flag := 'S'; 
                                                    else
                                                        lc_flag := 'N';
                                                        exit;  
                                                 end if;
                                                 ln_impAux := h.ppimp12;
                                             end loop;
                                             
                                             if lc_flag = 'S' then
                                                 ln_impAux11 := 2.5;
                                                 for h in calendario_vida loop
                                                     if ln_impAux11 = h.ppimp11 then
                                                        
                                                        lc_flag11 := 'S'; 
                                                        else
                                                            lc_flag11 := 'N';
                                                            exit;  
                                                     end if;
                                                     ln_impAux11 := h.ppimp11;
                                                 end loop;
                                                 
                                                 ln_impAux13 := 2.5;
                                                 for h in calendario_vida loop
                                                     if ln_impAux13 = h.ppimp13 then
                                                        
                                                        lc_flag13 := 'S'; 
                                                        else
                                                            lc_flag13 := 'N';
                                                            exit;  
                                                     end if;
                                                     ln_impAux13 := h.ppimp13;
                                                 end loop;
                                                 
                                                 if lc_flag11 = 'S' then
                                                    ln_mtoprima := ln_mto13;
																										     ---
																												 -- if ln_mtoprima = ln_mtops3 then -- Hsuarez - para comparar si = el monto total del SD.
																												 --	 flag_ptsg:='S';
																												 -- end if;
																												 ---
                                                    else
                                                         ln_mtoprima := ln_mto11;
																												  ---
																													--if ln_mtoprima = ln_mtops1 then -- Hsuarez - para comparar si = el monto total del SD.
																													--	 flag_ptsg:='S';
																													--end if;
																													---     
                                                 end if;
                                             end if;
                                           
                               end if;
                            when ln_codVar = 3 then
                                 ln_mtoprima := ln_mto13;
                                 if ln_mtoprima = 2.5 then
                                   ln_impAux := 2.5;
                                   for h in calendario_vida loop
                                       if ln_impAux = h.ppimp13 then
                                            
                                          lc_flag := 'S'; 
                                          else
                                              lc_flag := 'N';
                                              exit;  
                                       end if;
                                       ln_impAux := h.ppimp13;
                                   end loop;
                                     
                                   if lc_flag = 'S' then
                                      ln_mtoprima := ln_mto12;
                                   end if;
                                     
                                      
                                 end if;
                            when ln_codVar = 4 then
                                 ln_mtoprima := ln_mto14;
                            when ln_codVar = 5 then
                                 ln_mtoprima := ln_mto15;
                            else ln_mtoprima := 0;
                                          
                       end case;
                        
                        else
                                  begin
                                         select sum(ppimp11),
                                                sum(ppimp12),
                                                sum(ppimp13),
                                                sum(ppimp14),
                                                sum(ppimp15)
                                           into ln_mto11,
                                                ln_mto12,
                                                ln_mto13,
                                                ln_mto14,
                                                ln_mto15                                    
                                           from fsd611 a
                                          where a.pgcod  = pn_emp
                                            and a.ppmod  = pn_mod
                                            and a.ppsuc  = pn_suc
                                            and a.ppmda  = pn_mda
                                            and a.pppap  = pn_pap
                                            and a.ppcta  = pn_cta
                                            and a.ppoper = pn_ope
                                            and a.ppsbop = pn_sbo
                                            and a.pptope = pn_top
                                            and a.ppfpag between ld_fecini and pd_fecpro;
                                  exception
                                      when others then
                                           insert into jaqz097_error
                                           values(pn_cta,pn_ope,3,SYSDATE); 
                                           commit;
                                  end;
																	
																	----TEMPORAL <_	
																	 ---- agregado para validar si la suma de los pagos de la cuota total es igual al monto del
																	 ---- seguro o no.
																  /* 
												          select sum(pp1imp11),
																        sum(pp1imp12),
																				sum(pp1imp13),
																				sum(pp1imp14),
																				sum(pp1imp15) 
																	into
																	      ln_mtops1,
																				ln_mtops2,
																				ln_mtops3,
																				ln_mtops4,
																				ln_mtops5
																	from 
																	      fsd612 a
																	where         a.pgcod   = pn_emp
                                            and a.ppmod   = pn_mod
                                            and a.ppsuc   = pn_suc
                                            and a.ppmda   = pn_mda
                                            and a.pppap   = pn_pap
                                            and a.ppcta   = pn_cta
                                            and a.ppoper  = pn_ope
                                            and a.ppsbop  = pn_sbo
                                            and a.pptope  = pn_top
                                            and a.ppfpag  = pd_fecpro;																
																	----TEMPORAL _>
                                 */ 
                                  begin
                                         select ppfpag
                                           into ld_pago                                    
                                           from fsd611 a
                                          where a.pgcod  = pn_emp
                                            and a.ppmod  = pn_mod
                                            and a.ppsuc  = pn_suc
                                            and a.ppmda  = pn_mda
                                            and a.pppap  = pn_pap
                                            and a.ppcta  = pn_cta
                                            and a.ppoper = pn_ope
                                            and a.ppsbop = pn_sbo
                                            and a.pptope = pn_top
                                            and a.ppfpag between ld_fecini and pd_fecpro;
                                  exception
                                      when too_many_rows then
                                           insert into jaqz097_error
                                           values(pn_cta,pn_ope,55,SYSDATE); 
                                           commit;
                                           
                                           begin
                                                   select max(ppfpag)
                                                     into ld_pago                                    
                                                     from fsd611 a
                                                    where a.pgcod  = pn_emp
                                                      and a.ppmod  = pn_mod
                                                      and a.ppsuc  = pn_suc
                                                      and a.ppmda  = pn_mda
                                                      and a.pppap  = pn_pap
                                                      and a.ppcta  = pn_cta
                                                      and a.ppoper = pn_ope
                                                      and a.ppsbop = pn_sbo
                                                      and a.pptope = pn_top
                                                      and a.ppfpag between ld_fecini and pd_fecpro
                                                      and rownum = 1;
                                            exception
                                                when others then
                                                     null;
                                                     
                                            end;
                                       when others then null;                                           
                                  end;
                                  
                                  case
                                      when ln_codVar = 1 then
                                           ln_mtoprima := ln_mto11;
                                           if ln_mtoprima = 2.5 then
                                               ln_impAux := 2.5;
                                               for h in calendario_vida loop
                                                   if ln_impAux = h.ppimp11 then
                                                            
                                                      lc_flag := 'S'; 
                                                      else
                                                          lc_flag := 'N';
                                                          exit;  
                                                   end if;
                                                   ln_impAux := h.ppimp11;
                                               end loop;
                                                     
                                               if lc_flag = 'S' then
                                                  ln_mtoprima := ln_mto12;
                                                  ln_codVar := 2;
                                               end if;
                                           --else -- se agrego. 2016.08.18
																					     --if ln_mtoprima <= ln_mtops1 then -- Hsuarez - para comparar si = el monto total del SD.
																							 --	flag_ptsg:='S'; --hsuarez si es igual si pago todo el seguro de la cuota correspondiente.
																							 --end if;          
                                           end if;
                                      when ln_codVar = 2 then
                                           ln_mtoprima := ln_mto12;
                                           if ln_mtoprima = 2.5 then
                                             ln_impAux := 2.5;
                                             for h in calendario_vida loop
                                                 if ln_impAux = h.ppimp12 then
                                                    
                                                    lc_flag := 'S'; 
                                                    else
                                                        lc_flag := 'N';
                                                        exit;  
                                                 end if;
                                                 ln_impAux := h.ppimp12;
                                             end loop;
                                             
                                             if lc_flag = 'S' then
                                                 ln_impAux11 := 2.5;
                                                 for h in calendario_vida loop
                                                     if ln_impAux11 = h.ppimp11 then
                                                        
                                                        lc_flag11 := 'S'; 
                                                        else
                                                            lc_flag11 := 'N';
                                                            exit;  
                                                     end if;
                                                     ln_impAux11 := h.ppimp11;
                                                 end loop;
                                                 
                                                 ln_impAux13 := 2.5;
                                                 for h in calendario_vida loop
                                                     if ln_impAux13 = h.ppimp13 then
                                                        
                                                        lc_flag13 := 'S'; 
                                                        else
                                                            lc_flag13 := 'N';
                                                            exit;  
                                                     end if;
                                                     ln_impAux13 := h.ppimp13;
                                                 end loop;
                                                 
                                                 if lc_flag11 = 'S' then
                                                    ln_mtoprima := ln_mto13;
                                                    ln_codVar := 3;
																										---
																										--	if ln_mtoprima <= ln_mtops3 then -- Hsuarez - para comparar si = el monto total del SD.
																										--		 flag_ptsg:='S';
																										--	end if;
																										---
                                                    else
                                                         ln_mtoprima := ln_mto11;
                                                         ln_codVar := 1;
																												 ---
																												 --		if ln_mtoprima <= ln_mtops1 then -- Hsuarez - para comparar si = el monto total del SD.
																												 --			 flag_ptsg:='S';
																												 --		end if;
																												 ---      
                                                 end if;
																						 --else---
																						     ---
																							--	 if ln_mtoprima <= ln_mtops2 then -- Hsuarez - para comparar si = el monto total del SD.
																							--			 flag_ptsg:='S';
																							--	 end if;
																								 ---  
                                             end if;
																			 ---		 
                                       --else -- se agrego. 2016.08.18
																				--	     if ln_mtoprima <= ln_mtops2 then -- Hsuarez - para comparar si = el monto total del SD.
																				--					flag_ptsg:='S';
																				--			 end if;
																			 ---				 
                                       end if;
                                      when ln_codVar = 3 then
                                           ln_mtoprima := ln_mto13;
                                           if ln_mtoprima = 2.5 then
                                               ln_impAux := 2.5;
                                               for h in calendario_vida loop
                                                   if ln_impAux = h.ppimp13 then
                                                        
                                                      lc_flag := 'S'; 
                                                      else
                                                          lc_flag := 'N';
                                                          exit;  
                                                   end if;
                                                   ln_impAux := h.ppimp13;
                                               end loop;
                                                 
                                               if lc_flag = 'S' then
                                                  ln_mtoprima := ln_mto12;
																									---
																									--if ln_mtoprima <= ln_mtops2 then -- Hsuarez - para comparar si = el monto total del SD.
																									--  flag_ptsg:='S';
																							    --end if;
																									---
                                                  ln_codVar := 2;
                                               end if;
																					 ---		 
                                          -- else -- se agrego. 2016.08.18
																					  --   if ln_mtoprima <= ln_mtops3 then -- Hsuarez - para comparar si = el monto total del SD.
																						--			flag_ptsg:='S';
																						--	 end if;
																			     ---			  
                                           end if;
                                      when ln_codVar = 4 then
                                           ln_mtoprima := ln_mto14;
																					 ---
																					 --if ln_mtoprima <= ln_mtops4 then -- Hsuarez - para comparar si = el monto total del SD.
																					 --				flag_ptsg:='S';
																					 --end if;
																					 ---                         -- 
                                      when ln_codVar = 5 then
                                           ln_mtoprima := ln_mto15;
																					 ---
																					 --if ln_mtoprima <= ln_mtops5 then -- Hsuarez - para comparar si = el monto total del SD.
																					 --				flag_ptsg:='S';
																					 --end if;
																					 ---
                                      else ln_mtoprima := 0;    
                                 end case;
                                 
																 
																
                                 lc_tip := pq_cr_desgravamen.Fn_montoPag_calendarioT(pn_emp,--mod@abr 20170202
                                                                         pn_mod,
                                                                         pn_suc,
                                                                         pn_mda,
                                                                         pn_pap,
                                                                         pn_cta,
                                                                         pn_ope,
                                                                         pn_sbo,
                                                                         pn_top,
                                                                         pd_fecpro,
                                                                         ln_mtoprima,
                                                                         ln_codVar);
                                flag_sd:=lc_tip;        
                             
                     end if;
                     
                     end;
           end if;

       end loop;
     end;
   
end Sp_monto_calendario;
---------------------------------------------------------------------------------------------------------
Function fn_montopag_calendario(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                             pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                             pn_top in number,pd_Fecpro in date,pn_mto in number,
                             pn_ord in number) return varchar2 is
                             



ld_fecini date;

ln_mtopag number(17,2) ;
ln_mto11 number(17,2) ;
ln_mto12 number(17,2) ;
ln_mto13 number(17,2) ;
ln_mto14 number(17,2) ;
ln_mto15 number(17,2) ;
lc_ind varchar2(1);


begin

     ld_fecini := to_date('01'||to_char(pd_fecpro,'mmyyyy'),'ddmmyyyy');
          

     
     begin
           
         begin
           select sum(a.pp1imp11),
                  sum(a.pp1imp12),
                  sum(a.pp1imp13),
                  sum(a.pp1imp14),
                  sum(a.pp1imp15)
             into ln_mto11,
                  ln_mto12,
                  ln_mto13,
                  ln_mto14,
                  ln_mto15                     
             from fsd612 a,fsd602 b
            where a.pgcod  = pn_emp
              and a.ppmod  = pn_mod
              and a.ppsuc  = pn_suc
              and a.ppmda  = pn_mda
              and a.pppap  = pn_pap
              and a.ppcta  = pn_cta
              and a.ppoper = pn_ope
              and a.ppsbop = pn_sbo
              and a.pptope = pn_top
              and a.pgcod  = b.pgcod
              and a.ppmod  = b.ppmod 
              and a.ppsuc  = b.ppsuc 
              and a.ppmda  = b.ppmda 
              and a.pppap  = b.pppap 
              and a.ppcta  = b.ppcta 
              and a.ppoper = b.ppoper
              and a.ppsbop = b.ppsbop
              and a.pptope = b.pptope
              and a.ppfpag = b.ppfpag
              and a.pp1nump = b.pp1nump
              and b.d602co = 'S'
              and a.ppfpag between ld_fecini and pd_fecpro;
                      
           end;
           if pn_ord <> 0 then 
               case
                  when pn_ord = 1 then
                    ln_mtopag := ln_mto11;
                  when pn_ord = 2 then
                    ln_mtopag := ln_mto12;
                  when pn_ord = 3 then
                    ln_mtopag := ln_mto13;
                  when pn_ord = 4 then
                    ln_mtopag := ln_mto14;
                  when pn_ord = 5 then
                    ln_mtopag := ln_mto15;
                end case;    
            end if;
            
            if ln_mtopag = pn_mto then
               lc_ind := 'P';
               else
                      lc_ind := 'C';
            end if;
              
     end;
     return lc_ind;
end Fn_montoPag_calendario;
---------------------------------------------------------------------------------------------------------
procedure sp_cr_validapago(ln_pgcod     in number,
                             ln_modulo    in number,
                             ln_sucursal  in number,
                             ln_moneda    in number,
                             ln_papel     in number,
                             ln_cuenta    in number,
                             ln_operacion in number,
                             ln_suboper   in number,
                             ln_tope      in number,
                             ld_fechpag   in date,
                             ld_pd_fecini in date,
                             ln_monto     in number,
														 ln_valor     out varchar) is
  
     -- *****************************************************************
    -- Nombre                     : sp_cr_validapago
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.05.16
    -- Autor de Creación          : DCASTRO
    -- Uso                        : VALIDA PAGO DE CUOTA FSD602, FSD612, FSH016
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --                              
  -- *****************************************************************

  
    cursor cuotas is
    
      select /*+ parallel(h,2)*/
       h.d602mo modulo,
       h.d602su sucursal,
       h.d602tr transaccion,
       h.d602re relacion,
       h.d602fc fchcontable,
       h.pp1nump ppnum,
			 h.ppmda moneda,
			 h.pppap papel,
       h.pp1stat lc_estado,
       i.ppfpag ld_fchcuo,
       h.d602fc ld_fchpago,
       to_char(to_date(i.ppfpag, 'dd/mm/rrrr'), 'RRRRMM') lc_mespago,
       to_char(to_date(ld_pd_fecini, 'dd/mm/rrrr'), 'RRRRMM') lc_mescuot,
       sum(i.pp1imp11) ln_imp1,
       sum(i.pp1imp12) ln_imp2,
       sum(i.pp1imp13) ln_imp3,
       sum(i.pp1imp14) ln_imp4,
       sum(i.pp1imp15) ln_imp5
       
        from fsd602 h, fsd612 i,fpp001 f
       where h.d602cd = i.pgcod
         and h.d602co = 'S'
         and h.d602fc = ld_pd_fecini --between (ld_pd_fecini) and (ld_pd_fecfin)
         
				 and i.pgcod = h.pgcod
         and i.ppcta = h.ppcta
         and i.ppoper = h.ppoper
         and i.ppfpag = h.ppfpag
         and i.ppmod = h.ppmod
         and i.ppsuc = h.ppsuc
         and i.ppmda = h.ppmda
         and i.pppap = h.pppap
         and i.pp1nump = h.pp1nump
         --- cambiado i por h revertir de ser necesario
				 and h.pgcod = ln_pgcod
         and h.ppmod = ln_modulo
         and h.ppsuc = ln_sucursal
         and h.ppmda = ln_moneda
         and h.pppap = ln_papel
         and h.ppcta = ln_cuenta
         and h.ppoper = ln_operacion
         and h.ppsbop = ln_suboper
         and h.pptope = ln_tope
				 --
				 --and i.ppcta  = 393778  -- solo para pruebas
				 --and i.ppoper = 2266330 -- solo para pruebas
				 and i.pgcod = f.pgcod
         and i.ppcta = f.aocta
         and i.ppoper = f.aooper
         and i.ppmod = f.aomod
         and i.ppsuc = f.aosuc
         and i.ppmda = f.aomda
         and i.pppap = f.aopap
         -- and h.ppmod = f.aomod --  25502  917245778 borrar
         and h.ppmod in (select modulo from fst111 where dscod = 50) --  28577  270547625 borrar
         and f.aomod in (select modulo from fst111 where dscod = 50)
         and f.sgcod in (select tp1imp1 
                               from fst198 
                              where tp1cod=1 
                                and tp1cod1= 10898 
                                and tp1corr1=8)

       group by h.d602mo,
                h.d602su,
                h.d602tr,
                h.d602re,
                h.d602fc,
                h.pp1nump,
								h.ppmda,
								h.pppap,
                h.pp1stat,
                i.ppfpag,
                h.d602fc;
  
    lc_flag     varchar2(2) := 'N';
    ln_corr     number := 1;
    ln_imp      number(10, 2);
    lc_variable varchar2(2);
    ln_pago1    number(17, 2);
    ln_pago2    number(17, 2);
    ln_pago3    number(17, 2);
    ln_pago4    number(17, 2);
    ln_pago5    number(17, 2);
  
  begin
  
    /*ln_monto  := 2.5; para pruebas
    ln_codvar := 1;*/
  
    for j in cuotas loop
      lc_flag := 'N';
      
      ln_pago1 := 0;
      ln_pago2 := 0;
      ln_pago3 := 0;
      ln_pago4 := 0;
      ln_pago5 := 0;
    
      begin
      
      select distinct ('S')
          into lc_variable
          from fsh016
         where PGCOD = 1
           and HCMOD = j.modulo
           and HSUCOR = j.sucursal
           and HTRAN = j.transaccion
           and HNREL = j.relacion
           and HFCON = j.fchcontable
					 
           and hrubro in ('2524020000005', '2514020000005');
      exception
			  when no_data_found then
				   begin
						 select distinct ('S')
										into lc_variable
						 from fsd016
						 where PGCOD = 1
							 and itmod = j.modulo
							 and itsuc = j.sucursal
							 and ittran = j.transaccion
							 and itnrel = j.relacion
							 and moneda = j.moneda
							 and papel  = j.papel
							 --and itfcon = j.fchcontable
							 and rubro in ('2524020000005', '2514020000005');
					  exception
						   when others then
                    lc_variable := 'N';         
					  end; 
        when others then
          lc_variable := 'N';        
      end;
      ln_valor := lc_variable;    
    end loop;
  
  end sp_cr_validapago;
---------------------------------------------------------------------------------------------------------
procedure sp_saldocapital(ln_pgcod     in number,
                          ln_modulo    in number,
                          ln_sucursal  in number,
                          ln_moneda    in number,
                          ln_papel     in number,
                          ln_cuenta    in number,
                          ln_operacion in number,
                          ln_suboper   in number,
                          ln_tope      in number,
                          ld_fechpag   in date,
													ln_saldo    out number)
as
ln_monto_total number(17,2);
ln_pagos       number(17,2);
ln_saldocap    number(17,2);

begin
                          -- Capital total del Cronograma
                          select sum(ppcap) into ln_monto_total 
													from   fsd601
													where  pgcod  = ln_pgcod
													  and  ppmod   = ln_modulo
														and  ppsuc   = ln_sucursal
														and  ppmda   = ln_moneda
														and  pppap    = ln_papel
													  and  ppcta   = ln_cuenta
													  and  ppoper  = ln_operacion
														and  ppsbop  = ln_suboper
														and  pptope  = ln_tope; 
													-- Pagos de la cronograma 	
												  select sum(ppcap) into ln_pagos
													from   fsd601
													where  pgcod  = ln_pgcod
													  and  ppmod   = ln_modulo
														and  ppsuc   = ln_sucursal
														and  ppmda   = ln_moneda
														and  pppap    = ln_papel
													  and  ppcta   = ln_cuenta
													  and  ppoper  = ln_operacion
														and  ppsbop  = ln_suboper
														and  pptope  = ln_tope 
														and  ppfpag  <=ld_fechpag;
												  -- Calculo el Saldo Capital
													ln_saldocap := ln_monto_total-ln_pagos;
													ln_saldo    := ln_saldocap;
													    
end sp_saldocapital;
---------------------------------------------------------------------------------------------------------
procedure sp_cr_carga_job_alta(pd_fecpro IN date) is
-- job que permite ejecutar varias instancias en simultaneo.
     
     --lc_fecpro varchar2(10);
     lc_variable   varchar2(4000);
     ln_job        number:= 0;
     --l_jaqy066pano  jaqy066.jaqy066pano%type;
     --l_jaqy066pmes  jaqy066.jaqy066pmes%type;
     ln_cont number(2):=0;
     ln_inst number(1):=1;
     
     lc_hostname varchar2(64);
     x number;
  BEGIN

      
     --Obtener hostname
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;
        
     x:= 0;
     while  x <10  loop
         lc_variable := ' begin '||
              ' PQ_CR_DESGRAVAMEN.sp_cr_altaseg_desg_diario('''||X||''','''||pd_fecpro||''');'||
                                                                  ' End; ';
              ln_cont := ln_cont +1;
              
              ln_job := ln_job +1;
              
--            DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*60));
              if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
              DBMS_JOB.SUBMIT(job => ln_job, 
                      what => lc_variable,
                      next_date => sysdate+1/(24*60),
                      interval => null,
                      no_parse => false,
                      instance => 2,--ln_inst,
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
        x := x +1;
     end loop;

end sp_cr_carga_job_alta;


procedure sp_cr_carga_job_baja(pd_fecpro IN date) is
-- job que permite ejecutar varias instancias en simultaneo.
     
     --lc_fecpro varchar2(10);
     lc_variable   varchar2(4000);
     ln_job        number:= 0;
     --l_jaqy066pano  jaqy066.jaqy066pano%type;
     --l_jaqy066pmes  jaqy066.jaqy066pmes%type;
     ln_cont number(2):=0;
     ln_inst number(1):=1;
     
     lc_hostname varchar2(64);
     x number;
  BEGIN

      
     --Obtener hostname
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;
        
     x:= 0;
     while  x <10  loop
         lc_variable := ' begin '||
              ' PQ_CR_DESGRAVAMEN.sp_cr_bajaseg_desg_diario('''||X||''','''||pd_fecpro||''');'||
                                                                  ' End; ';
              ln_cont := ln_cont +1;
              
              ln_job := ln_job +1;
              
--            DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*60));
              if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
              DBMS_JOB.SUBMIT(job => ln_job, 
                      what => lc_variable,
                      next_date => sysdate+1/(24*60),
                      interval => null,
                      no_parse => false,
                      instance => 2,--ln_inst,
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
        x := x +1;
     end loop;

end sp_cr_carga_job_baja;

procedure sp_cr_carga_job_pago(pd_fecpro IN date) is
-- job que permite ejecutar varias instancias en simultaneo.
     
     --lc_fecpro varchar2(10);
     lc_variable   varchar2(4000);
     ln_job        number:= 0;
     --l_jaqy066pano  jaqy066.jaqy066pano%type;
     --l_jaqy066pmes  jaqy066.jaqy066pmes%type;
     ln_cont number(2):=0;
     ln_inst number(1):=1;
     
     lc_hostname varchar2(64);
     x number;
  BEGIN

      
     --Obtener hostname
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;
        
     x:= 0;
     while  x <10  loop
         lc_variable := ' begin '||
              ' PQ_CR_DESGRAVAMEN.sp_cr_pagoseg_desg_diario('''||X||''','''||pd_fecpro||''');'||
                                                                  ' End; ';
              ln_cont := ln_cont +1;
              
              ln_job := ln_job +1;
              
--            DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*60));
              if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
              DBMS_JOB.SUBMIT(job => ln_job, 
                      what => lc_variable,
                      next_date => sysdate+1/(24*60),
                      interval => null,
                      no_parse => false,
                      instance => 2,--ln_inst,
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
        x := x +1;
     end loop;

end sp_cr_carga_job_pago;

procedure sp_cr_pagosegxfpago(ln_pgcod     in number,
                              ln_modulo    in number,
                              ln_sucursal  in number,
                              ln_moneda    in number,
                              ln_papel     in number,
                              ln_cuenta    in number,
                              ln_operacion in number,
                              ln_suboper   in number,
                              ln_tope      in number,
															ln_tasaaux   in number,      
                              ld_fechpag   in date
															)
is
lc_coderr varchar2(150);
lc_msgerr varchar2(100);
cursor pagossd is
 select distinct ppfpag from fsd602 
							where pgcod = ln_pgcod
							  and ppmod = ln_modulo   --
								and ppsuc = ln_sucursal --
								and ppmda = ln_moneda   --
								and pppap = ln_papel    --
							  and ppcta = ln_cuenta 
								and ppoper= ln_operacion
								and ppsbop= ln_suboper 
								and d602fc= ld_fechpag
								and d602co='S';
								
     ln_credito varchar(27);
     ln_cuota varchar(30);
     ln_fpgoc varchar(8);
     ln_valor_r char(1);
		 ln_mtoprima number(17,2);--ln_mtoprima number(17,5); 
		 ln_instancia  number(10);
     ln_mtoapr     number(17,2);
		 lc_tip varchar2(1);  
		 ln_ppfpag varchar(8) ;
		 ln_saldo number(17,2);
		 ln_mtoppago number(17,2);
		 lc_flagsd varchar2(1);
		 ln_stasa  number(3);
		 ln_tasa   number(17,6);      
		 ln_cstasa char(2);
begin
     
		 
          for job in pagossd loop         
						--NUMERO DE CERTIFICADO (NUMERO DE CREDITO 27 DIGITOS)
						ln_credito :=  lpad(trim(to_char(ln_cuenta)), 9, '0')  ||
													 lpad(trim(to_char(ln_modulo)), 3, '0')  ||
													 lpad(trim(to_char(ln_moneda)), 3, '0')  ||
													 lpad(trim(to_char(ln_operacion)), 9, '0') ||
													 lpad(trim(to_char(ln_tope)), 3, '0');  
						
						
						begin
								select count(*) into ln_cuota
								from fsd601 
								where ppcta  = ln_cuenta 
									and ppoper = ln_operacion
									and ppsbop = ln_suboper 
									and ppfpag<= job.ppfpag;
								exception
								when no_data_found then
										 ln_cuota:=1;
						end;
						--FECHA EN QUE PAGO LA CUOTA
								ln_fpgoc:=ld_fechpag;
						--MONTO DE LA PRIMA COBRADA
								pq_cr_desgravamen.sp_monto_calendario(1,ln_modulo,ln_sucursal,ln_moneda,
																		ln_papel,ln_cuenta,ln_operacion,ln_suboper,
																		ln_tope,2,job.ppfpag,ln_mtoprima,lc_tip,lc_flagsd);
						   
						--SALDO INSOLUTO (SALDO CAPITAL DE LA CUOTA ANTERIOR)
								pq_cr_desgravamen.sp_saldocapital(1,ln_modulo,ln_sucursal,ln_moneda,ln_papel,ln_cuenta,ln_operacion,
																	ln_suboper,ln_tope,job.ppfpag,ln_saldo);	
						---------------------------------------------------------------------
						--TASA Y SOBRETASA
						ln_instancia := fn_instancia_credito(ln_modulo,ln_sucursal,ln_moneda,ln_papel,
																								 ln_cuenta,ln_operacion,ln_suboper,ln_tope);
						ln_mtoapr := pq_cr_tramdesgra.fn_montoAprobado(ln_instancia);
						
			      ln_tasa   := pq_cr_seguro_desgravamen.FN_TASA_DESGRAVAMEN(1,ln_modulo,ln_sucursal,ln_moneda,
						                                                         ln_papel,ln_cuenta,ln_operacion,ln_suboper,
																																		 ln_tope,ln_mtoapr);
						--sobretasa
						/*if ln_tasa<>ln_tasaaux then
							 --ln_stasa :=(job.pp001aux2*100);
							 ln_stasa :=1;
							 ln_cstasa:='si';
						else
							 ln_stasa :=0;
							 ln_cstasa:='no';					 
						end if; */
						--,1
						if ln_tasa not in (0.1,0.05) then
							 --ln_stasa :=(job.pp001aux2*100);
							 ln_stasa :=1;
							 ln_cstasa:='si';
						else
							 ln_stasa :=0;
							 ln_cstasa:='no';					 
						end if; 
						
						--INSERTANDO LA INFORMACION A LA TABLA TEMPORAL
						if lc_flagsd='P' then
							begin
							  
								    
									INSERT INTO jaqz428p 
									(
											jaqz428cprd , -- CodProducto
											jaqz428ncrd , -- Num. Credito     
											jaqz428ncuo , -- Num. de cuota pagada 
											jaqz428fpgo , -- Fecha de pago de la cuota
											--jaqz428nope , -- Numero de operacion del deposito
											--jaqz428fdpt , -- fecha de deposito a la aseguradora
											jaqz428mtpr , -- Monto de la prima cobrada
											--jaqz428cder , -- 
											--jaqz428dser , -- 
											jaqz428sdoi,   -- Saldo Capital
											jaqz428tsa,
											jaqz428stsa
											--BORRAR
											--tbcuenta,  -- Cuenta
											--tboperacion-- Operacion
									)
									values
									(
											'0006',--CODIGO DE PRODUCTO FIJO 0006
											ln_credito,--NUMERO DE CERTIFICADO (NUMERO DE CREDITO 27 DIGITOS)
											ln_cuota,--QUE NUMERO DE CUOTA PAGO
											ln_fpgoc,--FECHA EN PQUE PAGO LA CUOTA
											LPAD((ln_mtoprima*100),7,0),--ln_mtoprima, --MONTO DE LA PRIMA COBRADA
											LPAD((ln_saldo*100),16,0),--ln_saldo--SALDO INSOLUTO (SALDO CAPITAL DE LA CUOTA ANTERIOR)
											LPAD((ln_tasa*100000000),12,0),
											ln_stasa--,--ln_cstasa, -- si si es sobretasa y no si no lo es.
											--ln_cuenta, ---borrar solo para pruebas
											--ln_operacion ---borrar solo para pruebas
									);
									exception												
									when others then
											 lc_coderr := sqlcode;
											 lc_msgerr := sqlerrm;
											 INSERT INTO jaqz428aux 
											 (
												jaqz428cta, 
												jaqz428ope,
												jaqz428fc , 
												jaqz428err, 
												jaqz428msg, 
												jaqz428fec 
											 )
											 values
											 (
												ln_cuenta,
												ln_operacion,
												ld_fechpag,
												lc_coderr,
												lc_msgerr,
												sysdate
											 );
											 
							  
							end;
						 end if;
				  end loop;		
end sp_cr_pagosegxfpago;

--mod@abr 20170202

Function Fn_montoPag_calendarioT(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                             pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                             pn_top in number,pd_Fecpro in date,pn_mto in number,
                             pn_ord in number) return varchar2 is
                             



ld_fecini date;

ln_mtopag number(17,2) ;
ln_mto11 number(17,2) ;
ln_mto12 number(17,2) ;
ln_mto13 number(17,2) ;
ln_mto14 number(17,2) ;
ln_mto15 number(17,2) ;
lc_ind varchar2(1);


begin

     ld_fecini := to_date('01'||to_char(pd_fecpro,'mmyyyy'),'ddmmyyyy');
          

     
     begin
           
         begin
           select sum(a.pp1imp11),
                  sum(a.pp1imp12),
                  sum(a.pp1imp13),
                  sum(a.pp1imp14),
                  sum(a.pp1imp15)
             into ln_mto11,
                  ln_mto12,
                  ln_mto13,
                  ln_mto14,
                  ln_mto15                     
             from fsd612 a,fsd602 b
            where a.pgcod  = pn_emp
              and a.ppmod  = pn_mod
              and a.ppsuc  = pn_suc
              and a.ppmda  = pn_mda
              and a.pppap  = pn_pap
              and a.ppcta  = pn_cta
              and a.ppoper = pn_ope
              and a.ppsbop = pn_sbo
              and a.pptope = pn_top
              and a.pgcod  = b.pgcod
              and a.ppmod  = b.ppmod 
              and a.ppsuc  = b.ppsuc 
              and a.ppmda  = b.ppmda 
              and a.pppap  = b.pppap 
              and a.ppcta  = b.ppcta 
              and a.ppoper = b.ppoper
              and a.ppsbop = b.ppsbop
              and a.pptope = b.pptope
              and a.ppfpag = b.ppfpag
              and a.pp1nump = b.pp1nump
              and b.d602co = 'S'
              and a.ppfpag between ld_fecini and pd_fecpro;
           exception
             when others then null;           
           end;
           if pn_ord <> 0 then 
               case
                  when pn_ord = 1 then
                    ln_mtopag := ln_mto11;
                  when pn_ord = 2 then
                    ln_mtopag := ln_mto12;
                  when pn_ord = 3 then
                    ln_mtopag := ln_mto13;
                  when pn_ord = 4 then
                    ln_mtopag := ln_mto14;
                  when pn_ord = 5 then
                    ln_mtopag := ln_mto15;
                end case;    
            end if;
            
            if ln_mtopag = pn_mto then
               lc_ind := 'P';
               else
                      lc_ind := 'C';
            end if;
              
     end;
     return lc_ind;
end Fn_montoPag_calendarioT;


--mod@abr 20170202
				 
END PQ_CR_DESGRAVAMEN;
/

