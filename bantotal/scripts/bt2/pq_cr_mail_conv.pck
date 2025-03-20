create or replace package pq_cr_mail_conv is
	-- *****************************************************************
	-- Nombre                     : PAQUETES PARA OBTENER INFORMACION DE LOS PRENDARIOS
	-- Sistema                    : BANTOTAL
	-- Módulo                     : Créditos - Activas
	-- Versión                    : 1.0
	-- Fecha de Creación          : 2017.07.04
	-- Autor de Creación          : HSUAREZ
	-- Uso                        : Realiza Calculos
	-- Estado                     : Activo
	-- Acceso                     : Público
	-- Parámetros de Entrada      :
	--
	--
	--
	-- *****************************************************************
	-----------------------------------------------------------------------

	-----------------------------------------------------------------------
	procedure sp_cr_pagos(fecha_proceso in date);
	-----------------------------------------------------------------------
	procedure sp_cr_devolucion(fecha_proceso in date);
	-----------------------------------------------------------------------
	procedure sp_cr_pagos_cons(fecha_proceso in date);
	----------------------------------------------------------------------- 
	procedure sp_cr_devol_cons(fecha_proceso in date);
	-----------------------------------------------------------------------
	procedure sp_cr_config_mail( ------------------------
	                             p_c_de in varchar2,        -- De    
	                             p_c_recipiente in varchar2,-- Para
														   subject in varchar2,       -- Subject
															 -------------------------														
	                             fecha_proceso in date,     -- Fecha de proceso
														   --------------------														
														   v_header in varchar2,      -- Cabecera
														   rawdata  in clob           -- Detalle Excel
	                           );
	-----------------------------------------------------------------------
	procedure sp_cr_mail_root(p_c_de in varchar2,        -- De
	                          p_c_recipiente in varchar2,-- Para
														subject in varchar2,       -- Subject
	                          fecha_proceso in date,     -- Fecha de Proceso
														--------------------
														c_smtp_server in varchar2, -- Ip
														port in NUMBER,            -- Puerto
														host in varchar2,          -- Host
														--------------------														
														v_header in varchar2,  -- Cabecera
														rawdata  in clob       -- Detalle Excel
													  );
  -----------------------------------------------------------------------
end pq_cr_mail_conv;
/

create or replace package body pq_cr_mail_conv is
	-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
	----------------------------------------------------------------------------------------
	procedure sp_cr_pagos(fecha_proceso in date) is
		--
		cursor carteras(usuario in varchar2) is 
			select j.jaqa300nco,j.jaqa300agc,j.jaqa300mac,j.jaqa300arc 
			from jaqa300 j
			where jaqa300arc=usuario
			group by j.jaqa300nco,j.jaqa300agc,j.jaqa300mac,j.jaqa300arc order by jaqa300mac,jaqa300nco;
    --
		cursor correos is 
      select distinct jaqa300mac,jaqa300arc
			from jaqa300;
		--
		cursor pagos(cartera in number,usuario in varchar2 ,fecha_pr in date)is
     select 
		        h5.hfcon,--FECHA DE PAGO
						p1.pp101ncart,--NRO CARTERA
						p1.pp101nomc,--NOMBRE CONVENIO
						f8.ctnro,--CUENTA
						ft11.scnom sconvenio,--AGENCIA DEL CONVENIO
						h5.husing,--OPERADOR PROCESO
						h6.hcmod,--MODULO
						h6.htran,--TRANSACCION
						h6.hnrel,--RELACION
						h6.hmda,--MONEDA
						h6.hcimp6,--MONTO
						f1.penom,--TITULAR DEL CREDITO
						j.jaqa300arc--USUARIO		
       from fsh015 h5,fsh016 h6,fpp102 p2,
            fsr008 f8,fsd001 f1,fpp101 p1,
            /*fst001 ft1,*/fst046 ft6,fst001 ft11,jaqa300 j
      where h5.hcmod=  209
        and h5.htran=   65
				and h5.hfcon=   fecha_pr
				and h5.pgcod  = h6.pgcod
				and h5.hsucor = h6.hsucor
				and h5.hcmod  = h6.hcmod
				and h5.htran  = h6.htran
				and h5.hnrel  = h6.hnrel
				and h6.pgcod  = p2.pp102cod
				and h6.hfcon  = h5.hfcon
				and h6.hmodul = p2.pp102mod
				and h6.hsucur = p2.pp102suc
				and h6.hmda   = p2.pp102mda
				and h6.hpap   = p2.pp102pap
				and h6.hcta   = p2.pp102cta
				and h6.hoper  = p2.pp102ope
				and h6.hsubop = p2.pp102sbo
				and h6.htoper = p2.pp102top
				and h6.hcord  = 10 --				
				and p2.pp102ncart = cartera
				and p1.pp101ncart = p2.pp102ncart				
				and j.jaqa300nco  = p1.pp101ncart
				and j.jaqa300arc  = usuario
				--and h5.hcorr <>99
				and f8.pgcod  = p2.pp102cod
				and f8.ctnro  = p2.pp102cta
				and f1.pepais = f8.pepais
				and f1.petdoc = f8.petdoc
				and f1.pendoc = f8.pendoc
				and f8.cttfir = 'T'        
				and ft6.pgcod     = h6.pgcod
				and ft6.ubuser    = j.jaqa300arc
				and ft11.pgcod    = ft6.pgcod
				and ft11.sucurs   = ft6.ubsuc;
		--------------------						
		flag_data char(1);
		ln_pago number(17,6);
		flg_hdata char(1);
		
		--------------------					
		subject varchar2(1000);		
		--------------------							
		v_header varchar2(10000);-- Cabecera
		v_wstring clob;
		data varchar2(32000);
		rawdata long raw;
		--------------------
		ln_analista char(10);
		begin
		    for ma in correos loop
				    flg_hdata := 'N';
				    for cart in carteras(ma.jaqa300arc) loop
						  		--ln_analista := upper(cart.jaqa300arc);
									
									ln_analista := cart.jaqa300arc;
									---------------------------------------------------------------------------------
									--
									---------------------------------------------------------------------------------
									begin
											 select 
															'S'
												 into 
															flag_data
												 from fsh015 h5,fsh016 h6,fpp102 p2,
															fsr008 f8,fsd001 f1,fpp101 p1,
															/*fst001 ft1,*/fst046 ft6,fst001 ft11,jaqa300 j
												where h6.hcmod  =209
													and h6.htran  = 65
													and h5.hfcon  = fecha_proceso
													and h6.pgcod  = p2.pp102cod
													and h6.hfcon  = h5.hfcon
													and h6.hmodul = p2.pp102mod
													and h6.hsucur = p2.pp102suc
													and h6.hmda   = p2.pp102mda
													and h6.hpap   = p2.pp102pap
													and h6.hcta   = p2.pp102cta
													and h6.hoper  = p2.pp102ope
													and h6.hsubop = p2.pp102sbo
													and h6.htoper = p2.pp102top
													and h6.hcord  = 10 --
													and h5.pgcod  = h6.pgcod
													and h5.hsucor = h6.hsucor
													and h5.hcmod  = h6.hcmod
													and h5.htran  = h6.htran
													and h5.hnrel  = h6.hnrel															
													--and h5.hcorr <>99
													and f8.ctnro  = h6.hcta
													and f1.pepais = f8.pepais
													and f1.petdoc = f8.petdoc
													and f1.pendoc = f8.pendoc
													and f8.cttfir = 'T'
													and p2.pp102ncart = cart.jaqa300nco
													and p1.pp101ncart = p2.pp102ncart
													and j.jaqa300nco  = p1.pp101ncart
													and j.jaqa300arc  = ln_analista
													and ft6.pgcod     = h6.pgcod
													and ft6.ubuser    = j.jaqa300arc
													and ft11.sucurs   = ft6.ubsuc
													and rownum = 1;
									exception
													WHEN NO_DATA_FOUND THEN 
															 flag_data := 'N';   			
									end;
									---------------------------------------------------------------------------------
									---------------------------------------------------------------------------------
									--
									if flag_data = 'S' then
									---------------------------------------------------------------------------------
									  	 flg_hdata := 'S';	 
										   subject := 'Relacion de pagos Convenio - '||to_char((sysdate-1), 'yyyy.mm.dd');
										   ------------------------------------------------------------------------------
											 v_header := 'MIME-Version: 1.0' || utl_tcp.crlf                                                                     -- Use MIME mail standard
											 						 ||'Content-Type: multipart/mixed;' ||utl_tcp.crlf
											 						 ||' boundary=-----SECBOUND' || utl_tcp.crlf ||utl_tcp.crlf
											 						 ||'-------SECBOUND' || utl_tcp.crlf
											 						 ||'Content-Type: text/plain;' || utl_tcp.crlf||
											 						 --'Content-Type: text/plain; charset=iso-8859-1' || utl_tcp.crlf);
											 						 'Content-Transfer_Encoding: 8bit' ||--8bit
											 						 utl_tcp.crlf || utl_tcp.crlf || 'Adj. Relación de Pagos Convenio - ' || to_char(sysdate, 'DD-MM-RRRR') ||  CHR(13)
											 						 || CHR(13) || CHR(13) || 'Datos para completar' || utl_tcp.crlf --Message Body
											 						 ||'-------SECBOUND' || utl_tcp.crlf ||
											 						 --'Content-Type: text/plain;' || utl_tcp.crlf);--
											 						 'Content-Type: text/plain; charset=iso-8859-1' || utl_tcp.crlf
											 						 ||' name=RELACION_TRABCESE_' || to_char(sysdate, 'DD-MM-RR') || utl_tcp.crlf --xls
											 						 ||'Content-Transfer_Encoding: 8bit' ||--8bit
											 						 utl_tcp.crlf||'Content-Disposition: attachment;' ||utl_tcp.crlf
											 						 ||' filename=RELACION_PAGOS_CONVENIOS_' || to_char(sysdate, 'DD-MM-RR')||'.xls'|| utl_tcp.crlf || utl_tcp.crlf;
											 ------------------------------------------------------------------------------
											 v_header := v_header||'REPORTE DE PAGOS DE CREDITO CONVENIO'||utl_tcp.crlf;
											 v_header := v_header||'FECHA DE PROCESO'||chr(9)||to_char(sysdate, 'DD-MM-RR')||utl_tcp.crlf;
											 v_header := v_header||'HORA DE PROCESO'||chr(9)||to_char(sysdate, 'hh24:mi:ss')||utl_tcp.crlf;
											 v_header := v_header||'FECHA DE PAGO'||chr(9)||'NRO CARTERA'||chr(9)||'NOMBRE CONVENIO'||chr(9)||'CUENTA'||chr(9)||
											 'AGENCIA CONVENIO'||chr(9)||
											 'MODULO'||chr(9)||'TRANSACCION'||chr(9)||'RELACION'||chr(9)||
											 'MONEDA'||chr(9)||'MONTO'||chr(9)||'TITULAR DEL CREDITO'||chr(9)||'USUARIO'
											 ||chr(9)||'ANALISTA CARTERA';
											 ----------------
											 --v_wstring := '';
											 ------------------------------------------------------------------------------
											 --
											 for r_trab in pagos(cart.jaqa300nco,cart.jaqa300arc,fecha_proceso) loop
												 data := r_trab.hfcon||chr(9)||r_trab.pp101ncart||chr(9)||r_trab.pp101nomc||chr(9)||r_trab.ctnro
																			||chr(9)||r_trab.sconvenio||chr(9)||r_trab.hcmod
																			||chr(9)||r_trab.htran||chr(9)||r_trab.hnrel||chr(9)||r_trab.hmda
																			||chr(9)||REPLACE(r_trab.hcimp6,',','.')||chr(9)||r_trab.penom||chr(9)||r_trab.husing
																			||chr(9)||ma.jaqa300arc||utl_tcp.crlf;																														    
												 v_wstring := v_wstring||to_clob(data);												 
											 end loop;
											 -------------------------------------------------------------------------------
									end if;
				  end loop;
					          if flg_hdata = 'S' and v_wstring is not null	then	
										--	 para pruebas de desarrollo se activa y se desactiva el otro		
										/*										 
												 sp_cr_config_mail('hsuarez@cajaarequipa.pe',  --de
																				   'bsanchez@cajaarequipa.pe', --para
																					 subject,       -- 
																					 fecha_proceso, -- 
																					 --------------------														
																					 v_header,      -- Cabecera
																					 v_wstring      -- Detalle Excel
																				); 
												 sp_cr_config_mail('hsuarez@cajaarequipa.pe',  --de
																				   'hsuarez@cajaarequipa.pe', --para
																					 subject,       -- 
																					 fecha_proceso, -- 
																					 --------------------														
																					 v_header,      -- Cabecera
																					 v_wstring      -- Detalle Excel
																				); 
										*/
										
												 sp_cr_config_mail('conveniosconsumo@cajaarequipa.pe',  --de
																				   ma.jaqa300mac, --para
																					 subject,       -- 
																					 fecha_proceso, -- 
																					 --------------------														
																					 v_header,      -- Cabecera
																					 v_wstring      -- Detalle Excel
																				); 
										
							      end if;
								    --LIMPIANDO LA DATA.
								    v_wstring := ''; 			
					
				end loop;
	end;
  ----------------------------------------------------------------------------------------
  procedure sp_cr_devolucion(fecha_proceso in date) is
		cursor carteras(usuario in varchar2) is 
			select j.jaqa300nco,j.jaqa300agc,j.jaqa300mac,j.jaqa300arc 
			from jaqa300 j
			where jaqa300arc=usuario
			group by j.jaqa300nco,j.jaqa300agc,j.jaqa300mac,j.jaqa300arc order by jaqa300mac,jaqa300nco;
    cursor correos is 
      select distinct jaqa300mac,jaqa300arc
			from jaqa300;
		cursor devolucion(cartera in number,usuario in varchar2 ,fecha_pr in date)is
		  select 
					 h5.hfcon fechadev,--FECHA DE DEVOLUCION
					 j.jaqa300arc analist,--USUARIO
					 p2.pp102ncart cartera,--NRO CARTERA
					 ft11.scnom sconvenio,--AGENCIA
					 f1.penom nombreclient,--NOMBRE CLIENTE
					 f8.ctnro cuenta,--CUENTA CLIENTE
					 h6.hcimp1 monto,--MONTO 
					 h6.hmda moneda,--MONEDA
					 t68.depnom departam,--DEPARTAMENTO
					 t70.locnom ciudad,--CIUDAD
					 s.sngc13dir direccion--DIRECCION            
			from fsh015 h5,fsh016 h6,fpp102 p2,fsd010 d10,
						fsr008 f8,fsd001 f1,--,fpp101 p1
						fst046 ft6,fst001 ft11,--,
						jaqa300 j
						,sngc13 s,fst068 t68,fst070 t70
			where h5.hcmod=50
				and h5.htran=650
				and d10.pgcod=1
				and h5.hfcon=fecha_pr
				and h5.pgcod  = h6.pgcod
				and h5.hsucor = h6.hsucor
				and h5.hcmod  = h6.hcmod
				and h5.htran  = h6.htran
				and h5.hnrel  = h6.hnrel
				and h5.hfcon  = h6.hfcon
				--and h6.pgcod  = p2.pp102cod
				--and h6.hmodul = p2.pp102mod
				--and h6.hsucor = p2.pp102suc
				--and h6.hmda   = p2.pp102mda
				--and h6.hpap   = p2.pp102pap
				--and h6.hcta  = p2.pp102cta	                    
				--and h6.hoper  = p2.pp102ope
				--and h6.hcsubo = p2.pp102sbo
				--and h6.htoper = p2.pp102top
				and h6.hcord  = 10 --
				and p2.pp102ncart = cartera
				and p2.pp102cod = h6.pgcod
				and p2.pp102cta = h6.hcta
				and p2.pp102cod = d10.pgcod 
				and p2.pp102mod = d10.aomod 
				and p2.pp102suc = d10.aosuc 
				and p2.pp102mda = d10.aomda 
				and p2.pp102pap = d10.aopap 
				and p2.pp102cta = d10.aocta 
				and p2.pp102ope = d10.aooper
				and p2.pp102sbo = d10.aosbop
				and p2.pp102top = d10.aotope
				and d10.aostat<>99
				and f8.pgcod  = d10.pgcod                    
				and f8.ctnro  = d10.aocta
				and f8.cttfir = 'T'
				and f1.pepais = f8.pepais
				and f1.petdoc = f8.petdoc
				and f1.pendoc = f8.pendoc
				and j.jaqa300nco  = p2.pp102ncart
				and j.jaqa300arc  = usuario
				and ft6.pgcod     = p2.pp102cod
				and ft6.ubuser    = j.jaqa300arc
				and ft11.pgcod    = ft6.pgcod
				and ft11.sucurs   = ft6.ubsuc
				and s.sngc13pais  = f8.pepais 
				and s.sngc13tdoc  = f8.petdoc
				and s.sngc13ndoc  = f8.pendoc
				and s.docod = 1
				and t68.depcod    = s.sngc13dpto
				and t70.loccod    = s.sngc13prov
				and s.sngc13est   = 'H';
		flag_data char(1);
		flg_hdata char(1);
		ln_pago number(17,6);
		ln_analista char(10);
		--------------------
		c_smtp_server VARCHAR2(30);
		port  number;
		host VARCHAR2(100);
		--------------------	
		subject varchar2(1000);													
		v_header varchar2(10000);-- Cabecera
		
		data varchar2(32000);
		v_wstring clob;
		--v_wstring varchar2(30000);
		rawdata  RAW(32000);
		
		
		begin
		    for ma in correos loop
				    flg_hdata := 'N';
						v_header := '';
				    for cart in carteras(ma.jaqa300arc) loop
						 	--ln_analista := upper(ma.jaqa300arc);
							ln_analista := cart.jaqa300arc;
							begin
									 select 
													'S'
									 into 
									        flag_data 
									 from fsh015 h5,fsh016 h6,fpp102 p2,fsd010 d10,
												fsr008 f8,fsd001 f1,--,fpp101 p1
												fst046 ft6,fst001 ft11,--,
												jaqa300 j
												,sngc13 s,fst068 t68,fst070 t70
									where h5.hcmod=50
										and h5.htran=650
										and d10.pgcod=1
										and h5.hfcon=fecha_proceso
										and h5.pgcod  = h6.pgcod
										and h5.hsucor = h6.hsucor
										and h5.hcmod  = h6.hcmod
										and h5.htran  = h6.htran
										and h5.hnrel  = h6.hnrel
										and h5.hfcon  = h6.hfcon
										and h6.hcord  = 10 --
										and p2.pp102ncart = cart.jaqa300nco
										and p2.pp102cod = h6.pgcod
										and p2.pp102cta = h6.hcta
										and p2.pp102cod = d10.pgcod 
										and p2.pp102mod = d10.aomod 
										and p2.pp102suc = d10.aosuc 
										and p2.pp102mda = d10.aomda 
										and p2.pp102pap = d10.aopap 
										and p2.pp102cta = d10.aocta 
										and p2.pp102ope = d10.aooper
										and p2.pp102sbo = d10.aosbop
										and p2.pp102top = d10.aotope
										and d10.aostat<>99
										and f8.pgcod  = d10.pgcod                    
										and f8.ctnro  = d10.aocta
										and f8.cttfir = 'T'
										and f1.pepais = f8.pepais
										and f1.petdoc = f8.petdoc
										and f1.pendoc = f8.pendoc
										and j.jaqa300nco  = p2.pp102ncart
										and j.jaqa300arc  = ln_analista
										and ft6.pgcod     = p2.pp102cod
										and ft6.ubuser    = j.jaqa300arc
										and ft11.pgcod    = ft6.pgcod
										and ft11.sucurs   = ft6.ubsuc
										and s.sngc13pais  = f8.pepais 
										and s.sngc13tdoc  = f8.petdoc
										and s.sngc13ndoc  = f8.pendoc
										and s.docod = 1
										and t68.depcod    = s.sngc13dpto
										and t70.loccod    = s.sngc13prov
										and s.sngc13est   = 'H'
										and rownum = 1;							
																
							exception
							        WHEN NO_DATA_FOUND THEN 
											     flag_data := 'N';   			
							end;
							
							
							
							if flag_data = 'S' then	
							     flg_hdata := 'S';
								   ----------------------------------------------------
							     subject := 'Relacion de devoluciones Convenio - '||to_char((sysdate-1), 'yyyy.mm.dd');
									 ---------------------
									 
									 -----
									 v_header := 'MIME-Version: 1.0' || utl_tcp.crlf                                                                     -- Use MIME mail standard
                               ||'Content-Type: multipart/mixed;' ||utl_tcp.crlf
                               ||' boundary=-----SECBOUND' || utl_tcp.crlf ||utl_tcp.crlf
                               ||'-------SECBOUND' || utl_tcp.crlf
                               ||'Content-Type: text/plain;' || utl_tcp.crlf||
                               --'Content-Type: text/plain; charset=iso-8859-1' || utl_tcp.crlf);
                               'Content-Transfer_Encoding: 8bit' ||--8bit
                               utl_tcp.crlf || utl_tcp.crlf || 'Adj. Relación de devolucion Convenio - ' || to_char(sysdate, 'DD-MM-RRRR') ||  CHR(13)
                               || CHR(13) || CHR(13) || 'Datos para completar' || utl_tcp.crlf --Message Body
                               ||'-------SECBOUND' || utl_tcp.crlf ||
                               --'Content-Type: text/plain;' || utl_tcp.crlf);--
                               'Content-Type: text/plain; charset=iso-8859-1' || utl_tcp.crlf
                               ||' name=RELACION_TRABCESE_' || to_char(sysdate, 'DD-MM-RR') || utl_tcp.crlf --xls
                               ||'Content-Transfer_Encoding: 8bit' ||--8bit
															 utl_tcp.crlf||'Content-Disposition: attachment;' ||utl_tcp.crlf
                               ||' filename=RELACION_DEVOLUCION_CONVENIOS_' || to_char(sysdate, 'DD-MM-RR')||'.xls'|| utl_tcp.crlf || utl_tcp.crlf;
															
                   v_header := v_header||'REPORTE DE DEVOLUCIONES DE CREDITO CONVENIO'||utl_tcp.crlf;
				           v_header := v_header||'FECHA DE PROCESO'||chr(9)||to_char(sysdate, 'DD-MM-RR')||utl_tcp.crlf;
                   v_header := v_header||'HORA DE PROCESO'||chr(9)||to_char(sysdate, 'hh24:mi:ss')||utl_tcp.crlf;
    
									 v_header := v_header||'FECHA DE DEVOLUCION'||chr(9)||'USUARIO'||chr(9)||'NRO CARTERA'||chr(9)||'AGENCIA'||chr(9)||
                   'NOMBRE CLIENTE'||chr(9)||
                   'CUENTA CLIENTE'||chr(9)||'MONTO'||chr(9)||'MONEDA'||chr(9)||
                   'DEPARTAMENTO'||chr(9)||'CIUDAD'||chr(9)||'DIRECCION'; --||chr(9)||'USUARIO'
									 --||chr(9)||'ANALISTA CARTERA';
									 ------------
									 for r_trab in devolucion(cart.jaqa300nco,cart.jaqa300arc,fecha_proceso) loop
										 data := r_trab.fechadev||chr(9)||r_trab.analist||chr(9)||r_trab.cartera||chr(9)||r_trab.sconvenio
																	||chr(9)||r_trab.nombreclient||chr(9)||r_trab.cuenta
																	||chr(9)||REPLACE(r_trab.monto,',','.')||chr(9)||r_trab.moneda||chr(9)||r_trab.departam
																	||chr(9)||r_trab.ciudad||chr(9)||r_trab.direccion
																	||utl_tcp.crlf;																														    
										 v_wstring := v_wstring||to_clob(data);											 
									 end loop;
									 ------------									
							end if;	
				  end loop;
								--LIMPIANDO LA DATA.
								--v_wstring := ''; 		
								if flg_hdata = 'S' and  v_wstring is not null	then			
								       	-- Para pruebas de desarrollo se activa y se desactiva el otro	
												/*									 
												sp_cr_config_mail('hsuarez@cajaarequipa.pe',  --de
																				  'bsanchez@cajaarequipa.pe', --para
																					 subject,       -- 
																					 fecha_proceso, -- 
																					 --------------------														
																					 v_header,      -- Cabecera
																					 v_wstring      -- Detalle Excel
																				); 
												sp_cr_config_mail('hsuarez@cajaarequipa.pe',  --de
																				  'hsuarez@cajaarequipa.pe', --para
																					 subject,       -- 
																					 fecha_proceso, -- 
																					 --------------------														
																					 v_header,      -- Cabecera
																					 v_wstring      -- Detalle Excel
																				); 
												*/
												
												sp_cr_config_mail('conveniosconsumo@cajaarequipa.pe',  --de
																				   ma.jaqa300mac, --para
																					 subject,       -- 
																					 fecha_proceso, -- 
																					 --------------------														
																					 v_header,      -- Cabecera
																					 v_wstring      -- Detalle Excel
																				); 
												
												flg_hdata := 'N';
							  end if;
								--LIMPIANDO LA DATA.
								v_wstring := '';																	
				end loop;
	end;
  ----------------------------------------------------------------------------------------
  procedure sp_cr_pagos_cons(fecha_proceso in date) is
		cursor carteras(usuario in varchar2) is 
			select j.jaqa300nco,j.jaqa300agc,j.jaqa300mac,j.jaqa300arc 
			from jaqa300 j
			where jaqa300arc=usuario
			group by j.jaqa300nco,j.jaqa300agc,j.jaqa300mac,j.jaqa300arc order by jaqa300mac,jaqa300nco;
    cursor correos is 
      select distinct jaqa300mac,jaqa300arc
			from jaqa300;
		cursor pagos(cartera in number,usuario in varchar2 ,fecha_pr in date)is
     select 
		        h5.hfcon,--FECHA DE PAGO
						p1.pp101ncart,--NRO CARTERA
						p1.pp101nomc,--NOMBRE CONVENIO
						f8.ctnro,--CUENTA
						ft11.scnom sconvenio,--AGENCIA DEL CONVENIO
						h5.husing,--OPERADOR PROCESO
						h6.hcmod,--MODULO
						h6.htran,--TRANSACCION
						h6.hnrel,--RELACION
						h6.hmda,--MONEDA
						h6.hcimp6,--MONTO
						f1.penom,--TITULAR DEL CREDITO
						j.jaqa300arc--USUARIO		
       from fsh015 h5,fsh016 h6,fpp102 p2,
            fsr008 f8,fsd001 f1,fpp101 p1,
            /*fst001 ft1,*/fst046 ft6,fst001 ft11,jaqa300 j
      where h5.hcmod=  209
        and h5.htran=   65
				and h5.hfcon=   fecha_pr
				and h5.pgcod  = h6.pgcod
				and h5.hsucor = h6.hsucor
				and h5.hcmod  = h6.hcmod
				and h5.htran  = h6.htran
				and h5.hnrel  = h6.hnrel
				and h6.pgcod  = p2.pp102cod
				and h6.hfcon  = h5.hfcon
				and h6.hmodul = p2.pp102mod
				and h6.hsucur = p2.pp102suc
				and h6.hmda   = p2.pp102mda
				and h6.hpap   = p2.pp102pap
				and h6.hcta   = p2.pp102cta
				and h6.hoper  = p2.pp102ope
				and h6.hsubop = p2.pp102sbo
				and h6.htoper = p2.pp102top
				and h6.hcord  = 10 --
				
				and p2.pp102ncart = cartera
				and p1.pp101ncart = p2.pp102ncart
				
				and j.jaqa300nco  = p1.pp101ncart
				and j.jaqa300arc  = usuario
				--and h5.hcorr <>99
				and f8.pgcod  = p2.pp102cod
				and f8.ctnro  = p2.pp102cta
				and f1.pepais = f8.pepais
				and f1.petdoc = f8.petdoc
				and f1.pendoc = f8.pendoc
				and f8.cttfir = 'T'        
				and ft6.pgcod     = h6.pgcod
				and ft6.ubuser    = j.jaqa300arc
				and ft11.pgcod    = ft6.pgcod
				and ft11.sucurs   = ft6.ubsuc;
								
		flag_data char(1);
		ln_pago number(17,6);
		c_smtp_server VARCHAR2(30);
		port  number;
		
		--------------------					
		subject varchar2(1000);									
		v_header varchar2(10000);-- Cabecera
		v_wstring clob;
		data varchar2(32000);
		rawdata long raw;
		host VARCHAR2(100);
		ln_analista char(10);
		flg_hdata char(1);
		begin
		    for ma in correos loop
				    --flg_hdata := 'N';
				    for cart in carteras(ma.jaqa300arc) loop
						  		--ln_analista := upper(cart.jaqa300arc);
									ln_analista := cart.jaqa300arc;
									begin
											 select 
															'S'
												 into 
															flag_data
												 from fsh015 h5,fsh016 h6,fpp102 p2,
															fsr008 f8,fsd001 f1,fpp101 p1,
															/*fst001 ft1,*/fst046 ft6,fst001 ft11,jaqa300 j
												where h6.hcmod  =209
													and h6.htran  = 65
													and h5.hfcon  = fecha_proceso
													and h6.pgcod  = p2.pp102cod
													and h6.hfcon  = h5.hfcon
													and h6.hmodul = p2.pp102mod
													and h6.hsucur = p2.pp102suc
													and h6.hmda   = p2.pp102mda
													and h6.hpap   = p2.pp102pap
													and h6.hcta   = p2.pp102cta
													and h6.hoper  = p2.pp102ope
													and h6.hsubop = p2.pp102sbo
													and h6.htoper = p2.pp102top
													and h6.hcord  = 10 --
													and h5.pgcod  = h6.pgcod
													and h5.hsucor = h6.hsucor
													and h5.hcmod  = h6.hcmod
													and h5.htran  = h6.htran
													and h5.hnrel  = h6.hnrel															
													--and h5.hcorr <>99
													and f8.ctnro  = h6.hcta
													and f1.pepais = f8.pepais
													and f1.petdoc = f8.petdoc
													and f1.pendoc = f8.pendoc
													and f8.cttfir = 'T'
													and p2.pp102ncart = cart.jaqa300nco
													and p1.pp101ncart = p2.pp102ncart
													and j.jaqa300nco  = p1.pp101ncart
													and j.jaqa300arc  = ln_analista
													and ft6.pgcod     = h6.pgcod
													and ft6.ubuser    = j.jaqa300arc
													and ft11.sucurs   = ft6.ubsuc
													and rownum = 1;
									exception
													WHEN NO_DATA_FOUND THEN 
															 flag_data := 'N';   			
									end;
									if flag_data = 'S' then
										 flg_hdata := 'S'; 										 
										 subject := 'Relacion de pagos consolidado Convenio - '||to_char((sysdate-1), 'yyyy.mm.dd');
										 
										 v_header := 'MIME-Version: 1.0' || utl_tcp.crlf                                                                     -- Use MIME mail standard
																	 ||'Content-Type: multipart/mixed;' ||utl_tcp.crlf
																	 ||' boundary=-----SECBOUND' || utl_tcp.crlf ||utl_tcp.crlf
																	 ||'-------SECBOUND' || utl_tcp.crlf
																	 ||'Content-Type: text/plain;' || utl_tcp.crlf||
																	 --'Content-Type: text/plain; charset=iso-8859-1' || utl_tcp.crlf);
																	 'Content-Transfer_Encoding: 8bit' ||--8bit
																	 utl_tcp.crlf || utl_tcp.crlf || 'Adj. Relación de Pagos Convenio - ' || to_char(sysdate, 'DD-MM-RRRR') ||  CHR(13)
																	 || CHR(13) || CHR(13) || 'Datos para completar' || utl_tcp.crlf --Message Body
																	 ||'-------SECBOUND' || utl_tcp.crlf ||
																	 --'Content-Type: text/plain;' || utl_tcp.crlf);--
																	 'Content-Type: text/plain; charset=iso-8859-1' || utl_tcp.crlf
																	 ||' name=RELACION_TRABCESE_' || to_char(sysdate, 'DD-MM-RR') || utl_tcp.crlf --xls
																	 ||'Content-Transfer_Encoding: 8bit' ||--8bit
																	 utl_tcp.crlf||'Content-Disposition: attachment;' ||utl_tcp.crlf
																	 ||' filename=RELACION_PAGOS_CONSOLIDADO_CONVENIOS_' || to_char(sysdate, 'DD-MM-RR')||'.xls'|| utl_tcp.crlf || utl_tcp.crlf;
																	
											 v_header := v_header||'REPORTE DE PAGOS DE CREDITO CONVENIO'||utl_tcp.crlf;
											 v_header := v_header||'FECHA DE PROCESO'||chr(9)||to_char(sysdate, 'DD-MM-RR')||utl_tcp.crlf;
											 v_header := v_header||'HORA DE PROCESO'||chr(9)||to_char(sysdate, 'hh24:mi:ss')||utl_tcp.crlf;
											 v_header := v_header||'FECHA DE PAGO'||chr(9)||'NRO CARTERA'||chr(9)||'NOMBRE CONVENIO'||chr(9)||'CUENTA'||chr(9)||
											 'AGENCIA CONVENIO'||chr(9)||
											 'MODULO'||chr(9)||'TRANSACCION'||chr(9)||'RELACION'||chr(9)||
											 'MONEDA'||chr(9)||'MONTO'||chr(9)||'TITULAR DEL CREDITO'||chr(9)||'USUARIO'
											 ||chr(9)||'ANALISTA CARTERA';
											 ------------------------------------------
											 ------------------------------------------
											 for r_trab in pagos(cart.jaqa300nco,cart.jaqa300arc,fecha_proceso) loop
												 data := r_trab.hfcon||chr(9)||r_trab.pp101ncart||chr(9)||r_trab.pp101nomc||chr(9)||r_trab.ctnro
																			||chr(9)||r_trab.sconvenio||chr(9)||r_trab.hcmod
																			||chr(9)||r_trab.htran||chr(9)||r_trab.hnrel||chr(9)||r_trab.hmda
																			||chr(9)||REPLACE(to_char(r_trab.hcimp6),',','.')||chr(9)||r_trab.penom||chr(9)||r_trab.husing
																			||chr(9)||ma.jaqa300arc||utl_tcp.crlf;
																														    
												 v_wstring := v_wstring||to_clob(data);	
											 end loop;	
											 -------------------------------------------
									end if;	
				  end loop;					
				end loop;
				if flg_hdata = 'S'	then
				       --para pruebas de desarrollo se activa y se desactiva el otro
				       /*
							 if  v_wstring is not null	then														 
												 sp_cr_config_mail('hsuarez@cajaarequipa.pe',  --de
																				   'bsanchez@cajaarequipa.pe', --para
																					 subject,       -- 
																					 fecha_proceso, -- 
																					 --------------------														
																					 v_header,      -- Cabecera
																					 v_wstring      -- Detalle Excel
																				); 
							 end if;
							 if  v_wstring is not null	then														 
												 sp_cr_config_mail('hsuarez@cajaarequipa.pe',  --de
																				   'hsuarez@cajaarequipa.pe', --para
																					 subject,       -- 
																					 fecha_proceso, -- 
																					 --------------------														
																					 v_header,      -- Cabecera
																					 v_wstring      -- Detalle Excel
																				); 
							 end if;
							 */
							 
							 if  v_wstring is not null	then
							           sp_cr_config_mail('conveniosconsumo@cajaarequipa.pe',  --de
																				   'conveniosconsumo@cajaarequipa.pe', --para
																					 subject,       -- 
																					 fecha_proceso, -- 
																					 --------------------														
																					 v_header,      -- Cabecera
																					 v_wstring      -- Detalle Excel
																				);
							 end if; 
							 
							 --LIMPIANDO LA DATA.
							 v_wstring := '';	
			end if;	
	end;
	----------------------------------------------------------------------------------------
	
	procedure sp_cr_devol_cons(fecha_proceso in date) is
		cursor carteras(usuario in varchar2) is 
			select j.jaqa300nco,j.jaqa300agc,j.jaqa300mac,j.jaqa300arc 
			from jaqa300 j
			where jaqa300arc=usuario
			group by j.jaqa300nco,j.jaqa300agc,j.jaqa300mac,j.jaqa300arc order by jaqa300mac,jaqa300nco;
    cursor correos is 
      select distinct jaqa300mac,jaqa300arc
			from jaqa300;
		cursor devolucion(cartera in number,usuario in varchar2 ,fecha_pr in date)is
		  select 
					 h5.hfcon fechadev,--FECHA DE DEVOLUCION
					 j.jaqa300arc analist,--USUARIO
					 p2.pp102ncart cartera,--NRO CARTERA
					 ft11.scnom sconvenio,--AGENCIA
					 f1.penom nombreclient,--NOMBRE CLIENTE
					 f8.ctnro cuenta,--CUENTA CLIENTE
					 h6.hcimp1 monto,--MONTO 
					 h6.hmda moneda,--MONEDA
					 t68.depnom departam,--DEPARTAMENTO
					 t70.locnom ciudad,--CIUDAD
					 s.sngc13dir direccion--DIRECCION            
			from fsh015 h5,fsh016 h6,fpp102 p2,fsd010 d10,
						fsr008 f8,fsd001 f1,--,fpp101 p1
						fst046 ft6,fst001 ft11,--,
						jaqa300 j
						,sngc13 s,fst068 t68,fst070 t70
			where h5.hcmod=50
				and h5.htran=650
				and d10.pgcod=1
				and h5.hfcon=fecha_pr
				and h5.pgcod  = h6.pgcod
				and h5.hsucor = h6.hsucor
				and h5.hcmod  = h6.hcmod
				and h5.htran  = h6.htran
				and h5.hnrel  = h6.hnrel
				and h5.hfcon  = h6.hfcon
				--and h6.pgcod  = p2.pp102cod
				--and h6.hmodul = p2.pp102mod
				--and h6.hsucor = p2.pp102suc
				--and h6.hmda   = p2.pp102mda
				--and h6.hpap   = p2.pp102pap
				--and h6.hcta  = p2.pp102cta	                    
				--and h6.hoper  = p2.pp102ope
				--and h6.hcsubo = p2.pp102sbo
				--and h6.htoper = p2.pp102top
				and h6.hcord  = 10 --
				and p2.pp102ncart = cartera
				and p2.pp102cod = h6.pgcod
				and p2.pp102cta = h6.hcta
				and p2.pp102cod = d10.pgcod 
				and p2.pp102mod = d10.aomod 
				and p2.pp102suc = d10.aosuc 
				and p2.pp102mda = d10.aomda 
				and p2.pp102pap = d10.aopap 
				and p2.pp102cta = d10.aocta 
				and p2.pp102ope = d10.aooper
				and p2.pp102sbo = d10.aosbop
				and p2.pp102top = d10.aotope
				and d10.aostat<>99
				and f8.pgcod  = d10.pgcod                    
				and f8.ctnro  = d10.aocta
				and f8.cttfir = 'T'
				and f1.pepais = f8.pepais
				and f1.petdoc = f8.petdoc
				and f1.pendoc = f8.pendoc
				and j.jaqa300nco  = p2.pp102ncart
				and j.jaqa300arc  = usuario
				and ft6.pgcod     = p2.pp102cod
				and ft6.ubuser    = j.jaqa300arc
				and ft11.pgcod    = ft6.pgcod
				and ft11.sucurs   = ft6.ubsuc
				and s.sngc13pais  = f8.pepais 
				and s.sngc13tdoc  = f8.petdoc
				and s.sngc13ndoc  = f8.pendoc
				and s.docod = 1
				and t68.depcod    = s.sngc13dpto
				and t70.loccod    = s.sngc13prov
				and s.sngc13est   = 'H';
		flag_data char(1);
		ln_pago number(17,6);
		ln_analista char(10);
		--------------------
		c_smtp_server VARCHAR2(30);
		port  number;
		--------------------	
		subject varchar2(1000);													
		v_header varchar2(10000);-- Cabecera
		
		data varchar2(32000);
		v_wstring clob;
		--v_wstring varchar2(30000);
		rawdata  RAW(32000);
		host VARCHAR2(100);
		--ln_analista char(10);
		flg_hdata char(1);
		
		begin
		    for ma in correos loop
				    --flg_hdata := 'N';
						--v_header := '';
				    for cart in carteras(ma.jaqa300arc) loop
						 	--ln_analista := upper(ma.jaqa300arc);
							ln_analista := cart.jaqa300arc;
							begin
									 select 
													'S'
									 into 
									        flag_data 
									 from fsh015 h5,fsh016 h6,fpp102 p2,fsd010 d10,
												fsr008 f8,fsd001 f1,--,fpp101 p1
												fst046 ft6,fst001 ft11,--,
												jaqa300 j
												,sngc13 s,fst068 t68,fst070 t70
									where h5.hcmod=50
										and h5.htran=650
										and d10.pgcod=1
										and h5.hfcon=fecha_proceso
										and h5.pgcod  = h6.pgcod
										and h5.hsucor = h6.hsucor
										and h5.hcmod  = h6.hcmod
										and h5.htran  = h6.htran
										and h5.hnrel  = h6.hnrel
										and h5.hfcon  = h6.hfcon
										--and h6.pgcod  = p2.pp102cod
										--and h6.hmodul = p2.pp102mod
										--and h6.hsucor = p2.pp102suc
										--and h6.hmda   = p2.pp102mda
										--and h6.hpap   = p2.pp102pap
										--and h6.hcta  = p2.pp102cta	                    
										--and h6.hoper  = p2.pp102ope
										--and h6.hcsubo = p2.pp102sbo
										--and h6.htoper = p2.pp102top
										and h6.hcord  = 10 --
										and p2.pp102ncart = cart.jaqa300nco
										and p2.pp102cod = h6.pgcod
										and p2.pp102cta = h6.hcta
										and p2.pp102cod = d10.pgcod 
										and p2.pp102mod = d10.aomod 
										and p2.pp102suc = d10.aosuc 
										and p2.pp102mda = d10.aomda 
										and p2.pp102pap = d10.aopap 
										and p2.pp102cta = d10.aocta 
										and p2.pp102ope = d10.aooper
										and p2.pp102sbo = d10.aosbop
										and p2.pp102top = d10.aotope
										and d10.aostat<>99
										and f8.pgcod  = d10.pgcod                    
										and f8.ctnro  = d10.aocta
										and f8.cttfir = 'T'
										and f1.pepais = f8.pepais
										and f1.petdoc = f8.petdoc
										and f1.pendoc = f8.pendoc
										and j.jaqa300nco  = p2.pp102ncart
										and j.jaqa300arc  = ln_analista
										and ft6.pgcod     = p2.pp102cod
										and ft6.ubuser    = j.jaqa300arc
										and ft11.pgcod    = ft6.pgcod
										and ft11.sucurs   = ft6.ubsuc
										and s.sngc13pais  = f8.pepais 
										and s.sngc13tdoc  = f8.petdoc
										and s.sngc13ndoc  = f8.pendoc
										and s.docod = 1
										and t68.depcod    = s.sngc13dpto
										and t70.loccod    = s.sngc13prov
										and s.sngc13est   = 'H'
										and rownum = 1;							
																
							exception
							        WHEN NO_DATA_FOUND THEN 
											     flag_data := 'N';   			
							end;
							
							
							
							if flag_data = 'S' then	
							      flg_hdata := 'S';
								   
							     subject := 'Relacion de devoluciones consolidadas Convenio - '||to_char((sysdate-1), 'yyyy.mm.dd');
									 v_header := 'MIME-Version: 1.0' || utl_tcp.crlf                                                                     -- Use MIME mail standard
                               ||'Content-Type: multipart/mixed;' ||utl_tcp.crlf
                               ||' boundary=-----SECBOUND' || utl_tcp.crlf ||utl_tcp.crlf
                               ||'-------SECBOUND' || utl_tcp.crlf
                               ||'Content-Type: text/plain;' || utl_tcp.crlf||
                               --'Content-Type: text/plain; charset=iso-8859-1' || utl_tcp.crlf);
                               'Content-Transfer_Encoding: 8bit' ||--8bit
                               utl_tcp.crlf || utl_tcp.crlf || 'Adj. Relación de devolucion Convenio - ' || to_char(sysdate, 'DD-MM-RRRR') ||  CHR(13)
                               || CHR(13) || CHR(13) || 'Datos para completar' || utl_tcp.crlf --Message Body
                               ||'-------SECBOUND' || utl_tcp.crlf ||
                               --'Content-Type: text/plain;' || utl_tcp.crlf);--
                               'Content-Type: text/plain; charset=iso-8859-1' || utl_tcp.crlf
                               ||' name=RELACION_TRABCESE_' || to_char(sysdate, 'DD-MM-RR') || utl_tcp.crlf --xls
                               ||'Content-Transfer_Encoding: 8bit' ||--8bit
															 utl_tcp.crlf||'Content-Disposition: attachment;' ||utl_tcp.crlf
                               ||' filename=RELACION_DEVOLUCION_CONVENIOS_' || to_char(sysdate, 'DD-MM-RR')||'.xls'|| utl_tcp.crlf || utl_tcp.crlf;
															
                   v_header := v_header||'REPORTE DE DEVOLUCIONES DE CREDITO CONVENIO'||utl_tcp.crlf;
				           v_header := v_header||'FECHA DE PROCESO'||chr(9)||to_char(sysdate, 'DD-MM-RR')||utl_tcp.crlf;
                   v_header := v_header||'HORA DE PROCESO'||chr(9)||to_char(sysdate, 'hh24:mi:ss')||utl_tcp.crlf;
    
									 v_header := v_header||'FECHA DE DEVOLUCION'||chr(9)||'USUARIO'||chr(9)||'NRO CARTERA'||chr(9)||'AGENCIA'||chr(9)||
                   'NOMBRE CLIENTE'||chr(9)||
                   'CUENTA CLIENTE'||chr(9)||'MONTO'||chr(9)||'MONEDA'||chr(9)||
                   'DEPARTAMENTO'||chr(9)||'CIUDAD'||chr(9)||'DIRECCION'; --||chr(9)||'USUARIO'
									 
									 for r_trab in devolucion(cart.jaqa300nco,cart.jaqa300arc,fecha_proceso) loop
										 data := r_trab.fechadev||chr(9)||r_trab.analist||chr(9)||r_trab.cartera||chr(9)||r_trab.sconvenio
																	||chr(9)||r_trab.nombreclient||chr(9)||r_trab.cuenta
																	||chr(9)||REPLACE(r_trab.monto,',','.')||chr(9)||r_trab.moneda||chr(9)||r_trab.departam
																	||chr(9)||r_trab.ciudad||chr(9)||r_trab.direccion
																	||utl_tcp.crlf;
																	--||chr(9)||r_trab.penom||chr(9)||r_trab.husing
																	--||chr(9)||r_trab.jaqa300arc||utl_tcp.crlf;
																														    
										 v_wstring := v_wstring||to_clob(data);	
										 
									 end loop;
									 
							end if;	
				  end loop;	
			end loop;
			if flg_hdata = 'S'	then			     
					 if /*flag_data = 'S' and */ v_wstring is not null	then
					 	  --para pruebas de desarrollo se activa y se desactiva el otro											 
							/*
							sp_cr_config_mail('hsuarez@cajaarequipa.pe',  --de
							 							    'bsanchez@cajaarequipa.pe', --para
																subject,       -- 
																fecha_proceso, -- 
																--------------------														
																v_header,      -- Cabecera
																v_wstring      -- Detalle Excel
																); 
							sp_cr_config_mail('hsuarez@cajaarequipa.pe',  --de
																				   'hsuarez@cajaarequipa.pe', --para
																					 subject,       -- 
																					 fecha_proceso, -- 
																					 --------------------														
																					 v_header,      -- Cabecera
																					 v_wstring      -- Detalle Excel
																				); 
						  */
							 sp_cr_config_mail('conveniosconsumo@cajaarequipa.pe',  --de
																 'conveniosconsumo@cajaarequipa.pe', --para
																 subject,       -- 
																 fecha_proceso, -- 
																 --------------------														
																 v_header,      -- Cabecera
																 v_wstring      -- Detalle Excel
															);
														
					 end if;
					 --LIMPIANDO LA DATA.
					 v_wstring := '';
				end if;
				--LIMPIANDO LA DATA.
				v_wstring := ''; 			
	end;
	----------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------
	procedure sp_cr_config_mail( ------------------------
	                             p_c_de in varchar2,        -- De    
	                             p_c_recipiente in varchar2,-- Para
														   subject in varchar2,       -- Subject
															 -------------------------														
	                             fecha_proceso in date,     -- Fecha de proceso
														   --------------------														
														   v_header in varchar2,      -- Cabecera
														   rawdata  in clob           -- Detalle Excel
	                           )
	is
	--Cursor
	cursor c_host is
    select * 
      from fst198
     Where Tp1cod  = 1
       and Tp1cod1  = 10825
       and Tp1corr1 = 61
       and Tp1corr2 = 7;
	-- Variables
	c_smtp_server VARCHAR2(30);
	port  number;
	host VARCHAR2(100);
	-- 
  lc_hostname varchar2(64);
  lv_smtp     varchar2(30);
  lv_host     varchar2(30);
  ln_port     number(9); 
  begin     

	    begin
	        select host_name
          into lc_hostname
          from v$instance;
			exception
			WHEN NO_DATA_FOUND then
			    lc_hostname := ''; 
      end;

	        For i in c_host loop
						lv_host := upper(TRIM(substr(i.tp1desc,1,instr(i.tp1desc,'/')-1)));        
						lv_smtp := TRIM(substr(i.tp1desc,instr(i.tp1desc,'/')+1,length(trim(i.tp1desc)))); 
						ln_port := i.tp1nro3;
          
						if upper(lc_hostname) = lv_host then
						  
							Exit;
						 End if;
          End loop;

	         c_smtp_server := lv_smtp;--'10.0.200.68';
					 port          := ln_port;--2530;
					 
					 host          := lv_host;
	
	         sp_cr_mail_root(p_c_de,         --de
													 p_c_recipiente, --para
													 subject,        --subject
													 fecha_proceso,  --fecha de procesamiento
													 -------------------------
													 c_smtp_server,  -- ip del servidor
													 port,           -- puerto del servidor
													 host,           -- host del servidor
													 -------------------------														
													 v_header,       -- Cabecera
													 rawdata       -- Detalle Excel
													);                    
	end;
	----------------------------------------------------------------------------------------
	procedure sp_cr_mail_root(p_c_de in varchar2,
	                          p_c_recipiente in varchar2,
														subject in varchar2,														
	                          fecha_proceso in date,
														--------------------
														c_smtp_server in VARCHAR2,
														port in NUMBER,
														host in varchar2,
														--------------------														
														v_header in varchar2,  -- Cabecera
														rawdata  in clob-- Detalle Excel
													  )	                     
	is
			
	  v_wstring varchar2 (32000);
    auxiliar varchar2 (32000);
    v_From      VARCHAR2(80);
    v_Recipient VARCHAR2(80);
    v_Subject   VARCHAR2(80);
    V_Conexion    utl_smtp.Connection;
		v_clob                     CLOB;
    msg           varchar2(32767);
    p_c_msgerr VARCHAR2(1000);
    vhost_name VARCHAR2( 100 );
		v_found number;
    c_dni VARCHAR2(100);
		datas long raw;
		c_mime_boundary   CONSTANT VARCHAR2 (256)      := '--AAAAA000956--';
    l_n_offset NUMBER:=630;
  begin	
	  v_clob := 'Number' || ',' || 'Name' || UTL_TCP.crlf;
    SELECT HOST_NAME
      INTO VHOST_NAME
    FROM V$INSTANCE;
	
       -- IF UPPER(VHOST_NAME) IN ('BTRAC1051','BTRAC1052',host) then 
			-- IF UPPER(VHOST_NAME) IN  ('SC01ZDBADM010101','SC01ZDBADM020101',host) then
			 -- IF UPPER(VHOST_NAME) IN  ('SC01ZDBADM010101','SC01ZDBADM020101','BTRAC4051') then
				v_From      := p_c_de;
        v_Recipient := P_C_RECIPIENTE;
        v_Subject   := subject;
    		
			SELECT count(*) into v_found
      FROM systabrep.hostnames 
      where habilitado = 'S' and upper(host_name)=UPPER(vhost_name);
  
  if v_found =1 then
        V_Conexion    := UTL_SMTP.OPEN_CONNECTION(C_SMTP_SERVER,Port);
        msg           := 'Date: ' ||to_char(sysdate, 'Dy, DD Mon YYYY hh24:mi:ss') ||utl_tcp.crlf ||
                         'From: ' || v_From || utl_tcp.crlf ||
                         'Subject: ' || v_Subject || utl_tcp.crlf ||
                         'To: ' || v_Recipient || utl_tcp.crlf;

        --Se negocia la transaccion con el servidor SMTP
        utl_smtp.Helo(V_Conexion, C_SMTP_SERVER);
        utl_smtp.Mail(V_Conexion, v_From);
        utl_smtp.Rcpt(V_Conexion, v_Recipient);
        
				UTL_SMTP.OPEN_DATA(V_Conexion);

        --Se escribe la cabecera
        UTL_SMTP.WRITE_DATA(V_Conexion, msg);
        --Se escribe el contenido del mensaje 
        utl_smtp.write_data(V_Conexion,v_header||utl_tcp.crlf);
        FOR loop_att IN 0 .. TRUNC(DBMS_LOB.getlength(rawdata)/l_n_offset)
        LOOP
            auxiliar := DBMS_LOB.substr(rawdata, l_n_offset, loop_att * l_n_offset + 1);
            UTL_SMTP.write_data(V_Conexion, auxiliar);
        END LOOP;
	      
				--UTL_smtp.write_raw_data(V_Conexion, UTL_ENCODE.base64_encode(rawdata));
			  --datas := (CAST(rawdata as long raw);
				--UTL_smtp.write_raw_data(V_Conexion, rawData);
        
				utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
        utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
        utl_smtp.write_data(V_Conexion, '-------SECBOUND--'); -- End MIME mail
        utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
        --Cerramos la conexion
        UTL_SMTP.close_data(V_Conexion);
        UTL_SMTP.quit(V_Conexion);      
    end if;  
  EXCEPTION
  WHEN utl_smtp.Transient_Error OR utl_smtp.Permanent_Error THEN
    p_c_msgerr:='Unable to send mail: ' || sqlerrm;
    raise_application_error(-20000, 'Unable to send mail: ' || p_c_msgerr);  
  end;   
  ----------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------
end pq_cr_mail_conv;
/

