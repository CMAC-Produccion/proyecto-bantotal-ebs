create or replace package pq_cr_campana_ctsuenos is

	-- Author  : HSUAREZ
	-- Created : 16/05/2017 12:27:38 a.m.
	-- Purpose : 

	procedure sp_relacion_cred(pn_pais in fsr008.pepais%type,
														 pn_tdoc in fsr008.petdoc%type,
														 pn_ndoc in varchar,
														 pd_fecp in date,
														 pd_flag out varchar);
	procedure sp_cr_dias_atraso(ln_pepais in number,
															ln_petdoc in number,
															ln_pendoc in varchar,
															ld_fchprc in date,
															lc_flag   out varchar);
	procedure sp_adatraso_fsd601_602(
	                       pn_aocta  in fsd010.aocta%type,
												 pn_aomod  in fsd010.aomod%type,
												 pn_aosuc  in fsd010.aosuc%type,
												 pn_aomda  in fsd010.aomda%type,
												 pd_aopap  in fsd010.aopap%type,
												 pd_aooper in fsd010.aooper%type,
												 pd_aosbop in fsd010.aosbop%type,
												 pd_aotope in fsd010.aotope%type,
												 f_ini     in fsd010.aofval%type,
												 f_fin     in fsd010.aofval%type,
												 ld_fchprc in date,
												 ln_nromora out number,
												 ln_registros out number);
	procedure sp_tasa_baja(pn_pais  in fsr008.pepais%type,
												 pn_tdoc  in fsr008.petdoc%type,
												 pn_ndoc  in varchar,
												 pn_fecp  in date,
												 pd_flag  out varchar,
												 pd_monto out fsd010.aoimp%type,
												 pd_plazo out fsd010.aopzo%type,
												 pd_tasa  out fsd010.aotasa%type);
												 
  procedure sp_cr_garantias(instancia  in xwf700.xwfprcins%type,ln_flag out char);
end pq_cr_campana_ctsuenos;
/

create or replace package body pq_cr_campana_ctsuenos is
	-----------------------------------------------------------------------------------------------
	procedure sp_relacion_cred(pn_pais in fsr008.pepais%type,
														 pn_tdoc in fsr008.petdoc%type,
														 pn_ndoc in varchar,
														 pd_fecp in date,
														 pd_flag out varchar) is

		cursor cuentas(ln_pais number, ln_tdoc number, ln_ndoc char) is
			select ctnro
				from fsr008 f
			 where f.pepais = ln_pais
				 and f.petdoc = ln_tdoc
				 and f.pendoc = ln_ndoc
				 and f.cttfir = 'T';
	  cursor fsd010(ln_ctnro number,ld_fecini date) is
	       select *
				 from fsd010 d
				 where d.pgcod=1
				 and   d.aocta=ln_ctnro
				 and   d.aomod in (select modulo
														 from fst111
														where dscod = 50
															and modulo not in (108))
				 and (aofe99 >= ld_fecini or aofe99 = to_date('0001.01.01','yyyy.mm.dd'));
				 --and   d.aostat<>99;
				 
		ln_inactivo  number(10);
		ln_rel_crd   number(10);
		ln_mes_acum  number(10);
		ld_fecini    date;
		ln_fec_inc   date;
		ln_fec_val   date;
		ln_fec_can   date;
		ln_empresa   xwf700.xwfempresa%type;
		ln_sucursal  xwf700.xwfsucursal%type;
		ln_modulo    xwf700.xwfmodulo%type;
		ln_moneda    xwf700.xwfmoneda%type;
		ln_papel     xwf700.xwfpapel%type;
		ln_cuenta    xwf700.xwfcuenta%type;
		ln_operacion xwf700.xwfoperacion%type;
		ln_subope    xwf700.xwfsubope%type;
		ln_tipope    xwf700.xwftipope%type;
		ln_mes_lv  number(10);
		ln_est_can   number(10);
		err_num      number;
		temp         date;
		err_msg      varchar(250);
	
	begin
		-- Obtener periodo de inactividad del cliente con la caja.
		begin
		-- Desde la fecha de consulta.
		select tp1nro1
			into ln_inactivo
			from fst198
		 where tp1cod = 1
			 and tp1cod1 = 11005
			 and tp1corr1 = 5
			 and tp1corr2 = 1
			 and tp1corr3 = 1;
	  exception
			when others then
				ln_inactivo:=0;
		end;
		begin
		-- Obtener periodo de relacion crediticia minima
		select tp1nro1
			into ln_rel_crd
			from fst198
		 where tp1cod = 1
			 and tp1cod1 = 11005
			 and tp1corr1 = 5
			 and tp1corr2 = 1
			 and tp1corr3 = 2;
	 exception
			when others then
				ln_rel_crd:=0;
		end;
		--Obtener la fecha limite segun guia de proceso.
		ld_fecini:=add_months(pd_fecp,-ln_inactivo);
		--inicializo variables,
	  pd_flag := 'N';
		ln_mes_acum:=0;
		ln_mes_lv :=0;
		--for x in modulo_toperacion loop                             
		for x in cuentas(pn_pais, pn_tdoc, pn_ndoc) loop
			--Obtengo clave del credito a traves de la cuenta obtenida del cursor cuentas y de los modulos.
			for y in fsd010(x.ctnro,ld_fecini) loop
			    if y.aofe99=to_date('0001.01.01','yyyy.mm.dd') then
							begin
								select trunc((months_between(pd_fecp, d10.aofval)))+1
								into ln_mes_lv
								from fsd010 d10 
								where d10.pgcod  = 1
									and d10.aomod  = y.aomod
									and d10.aosuc  = y.aosuc
									and d10.aomda  = y.aomda
									and d10.aopap  = y.aopap
									and d10.aocta  = y.aocta
									and d10.aooper = y.aooper  
									and d10.aosbop = y.aosbop
									and d10.aotope = y.aotope
									and d10.aostat <> 99;
							exception
								when others then
										ln_mes_lv:=0;
						  end;
					else
								begin
								  --select trunc((months_between(d10.aofe99,d10.aofval)))+1
									select d10.aofval,d10.aofe99
									into ln_fec_val,ln_fec_can
									from fsd010 d10 
									where d10.pgcod  = 1
										and d10.aomod  = y.aomod
										and d10.aosuc  = y.aosuc
										and d10.aomda  = y.aomda
										and d10.aopap  = y.aopap
										and d10.aocta  = y.aocta
										and d10.aooper = y.aooper  
										and d10.aosbop = y.aosbop
										and d10.aotope = y.aotope
										and d10.aostat = 99;
								exception
									when others then
											ln_mes_lv:=0;
								end;
								
								if ln_fec_val>=ld_fecini then
								   ln_mes_lv:= months_between(ln_fec_can, ln_fec_val);
								else
								   if ln_fec_val<ld_fecini then
								      ln_mes_lv:= months_between(ln_fec_can, ld_fecini);
									 end if;
								end if;
								
					end if;
					--si la diferencia es menor que 0 se iguala a 0.
					if ln_mes_lv<0 then
					   ln_mes_lv :=0;
					end if;
			      --verificamos la condicion si ya fue cancelado o no. para aplicar.
						  ln_mes_acum := ln_mes_acum + ln_mes_lv;
									  if (ln_mes_acum) >= ln_rel_crd then
											pd_flag := 'S';
											return;
										else
											pd_flag := 'N';
										end if;
		  end loop;
		end loop;
	end sp_relacion_cred;
	-----------------------------------------------------------------------------------------------
	procedure sp_cr_dias_atraso(ln_pepais in number,
															ln_petdoc in number,
															ln_pendoc in varchar,
															ld_fchprc in date,
															lc_flag   out varchar) is
	
		ln_registros number;
		ln_rel_crd   number;
		ln_dias      number;
		resultado    number;
		ln_nromora   number;
		f_ini        date;
		f_fin        date;
		ln_cantidad  number;
	--	
  cursor cuentas(ln_pais number, ln_tdoc number, ln_ndoc char) is
			select ctnro
				from fsr008 f
			 where f.pepais = ln_pais
				 and f.petdoc = ln_tdoc
				 and f.pendoc = ln_ndoc
				 and f.cttfir = 'T';
	--			 
	cursor fsd010(ln_ctnro number) is
	       select *
				 from fsd010 d
				 where d.pgcod=1
				 and   d.aocta=ln_ctnro
				 and   d.aomod in ((select modulo
														 from fst111
														where dscod = 50
															and modulo not in (108)))--se quito 117
				 and   d.aostat=0;				 
	--
	cursor fsd601(laocta number,
	              lppmod number,
								lppsuc number,
								lppmda number, 
								lpppap  number,
								lppcta  number,
								lppoper number,
								lppsbop number,
								lpptope number,
								lf_ini date,
								lf_fin date)is
	select * from fsd601 where 
	    pgcod = 1
	and ppcta = laocta                              
  and ppmod = lppmod 
  and ppsuc = lppsuc 
  and ppmda = lppmda 
  and pppap = lpppap  
  and ppcta = lppcta  
  and ppoper= lppoper 
  and ppsbop= lppsbop 
  and pptope= lpptope
	and ppfpag>=lf_ini
	and ppfpag<=lf_fin;   						 
	
	begin
		begin
		  begin
			-- Obtener periodo de relacion crediticia minima
			select tp1nro1
				into ln_rel_crd
				from fst198
			 where tp1cod = 1
				 and tp1cod1 = 11005
				 and tp1corr1 = 5
				 and tp1corr2 = 1
				 and tp1corr3 = 2;
		  exception
			when others then
				ln_rel_crd:=0;
		  end;
			begin
			-- Obtener los dias de atraso en promedio maximo permitido
			select tp1nro1
				into ln_dias
				from fst198 j
			 where tp1cod = 1
				 and tp1cod1 = 11005
				 and j.tp1corr1 = 5
				 and j.tp1corr2 = 1
				 and tp1corr3 = 3;
		  exception
			when others then
				ln_dias:=0;
			end;	 
		  for x in cuentas(ln_pepais, ln_petdoc, ln_pendoc) loop
			    for y in fsd010(x.ctnro) loop
				      begin
							      if y.aostat=0 then
										    f_ini := add_months(ld_fchprc, -ln_rel_crd);
												f_fin := ld_fchprc;
												ln_registros:=0;
												
												pq_cr_campana_ctsuenos.sp_adatraso_fsd601_602(
												 y.aocta,    
                         y.aomod,
                         y.aosuc,
                         y.aomda,
                         y.aopap,
                         y.aooper,
                         y.aosbop,
                         y.aotope,
												 f_ini,
												 f_fin,
												 ld_fchprc,
												 ln_nromora,
												 ln_registros
												 );
								    end if;
						  exception
								when others then
										ln_nromora:=0;
										ln_registros:=0;
							end;			
								if ln_registros > 0 then
								   resultado := nvl(ln_nromora, 0) / nvl(ln_registros, 0);
										if resultado <= ln_dias then
												lc_flag := 'S';
											
										else
												lc_flag := 'N';
												return; --exit
										end if;
								else
								    lc_flag := 'S';
		            end if;
		     end loop;
	    end loop;	
		exception
			when others then
				 lc_flag := 'S';
		end;
		
	end sp_cr_dias_atraso;
	
	
	procedure sp_adatraso_fsd601_602(
	                       pn_aocta  in fsd010.aocta%type,
												 pn_aomod  in fsd010.aomod%type,
												 pn_aosuc  in fsd010.aosuc%type,
												 pn_aomda  in fsd010.aomda%type,
												 pd_aopap  in fsd010.aopap%type,
												 pd_aooper in fsd010.aooper%type,
												 pd_aosbop in fsd010.aosbop%type,
												 pd_aotope in fsd010.aotope%type,
												 f_ini     in fsd010.aofval%type,
												 f_fin     in fsd010.aofval%type,
												 ld_fchprc in date,
												 ln_nromora out number,
												 ln_registros out number) is
	    nromora number;
			registros number;
			ln_nro number;
			cursor lfsd601(laocta number,
	              lppmod number,
								lppsuc number,
								lppmda number, 
								lpppap  number,
								lppoper number,
								lppsbop number,
								lpptope number,
								lf_ini date,
								lf_fin date)is
			select * from fsd601 where 
					pgcod = 1
			and ppcta = laocta                              
			and ppmod = lppmod 
			and ppsuc = lppsuc 
			and ppmda = lppmda 
			and pppap = lpppap   
			and ppoper= lppoper 
			and ppsbop= lppsbop 
			and pptope= lpptope
			and ppfpag>=lf_ini
			and ppfpag<=lf_fin;
			
			begin
	        begin 
					     nromora:=0;
							 registros:=0;
							 ln_nro :=0;
			         for z in lfsd601(  pn_aocta, 
                                  pn_aomod,
                                  pn_aosuc, 
                                  pn_aomda,
                                  pd_aopap, 
                                  pd_aooper,
																	pd_aosbop,
                                  pd_aotope,
                                  f_ini    ,
                                  f_fin    
							 								) loop												
												    begin
															select /*sum(*/case
																								 when (f602.pp1fech - f602.ppfpag) < 0 then 0
																								 else
																								 (f602.pp1fech - f602.ppfpag)
																								 end/*)*/ as dias_mora
																			into nromora /*ln_registros*/
																				 /*count(*) as cantidad*/
																			 from fsd602 f602
															where  f602.pgcod   =  z.pgcod
                                 and f602.ppcta   =  z.ppcta
                                 and f602.ppmod   =  z.ppmod
                                 and f602.ppsuc   =  z.ppsuc
                                 and f602.ppmda   =  z.ppmda
                                 and f602.pppap   =  z.pppap
                                 and f602.ppcta   =  z.ppcta
                                 and f602.ppoper  =  z.ppoper
                                 and f602.ppsbop  =  z.ppsbop
                                 and f602.pptope  =  z.pptope
																 and f602.pp1stat = 'T'
																 and f602.d602co  = 'S'
																 and f602.ppfpag  = z.ppfpag
																order by f602.pp1fech asc;
														exception
								             WHEN NO_DATA_FOUND THEN
														    nromora :=nromora+(ld_fchprc-z.ppfpag);
																--registros := registros+1;      
														end;
														ln_nro :=ln_nro+nromora;
												    registros := registros+1;    					
											  end loop;
												ln_nromora := ln_nro;
												ln_registros := registros;	
							end;   
	end sp_adatraso_fsd601_602;
	-----------------------------------------------------------------------------------------------
	procedure sp_tasa_baja(pn_pais  in fsr008.pepais%type,
												 pn_tdoc  in fsr008.petdoc%type,
												 pn_ndoc  in varchar,
												 pn_fecp  in date,
												 pd_flag  out varchar,
												 pd_monto out fsd010.aoimp%type,
												 pd_plazo out fsd010.aopzo%type,
												 pd_tasa  out fsd010.aotasa%type) is
		--
		cursor modulo_toperacion is
			select tp1nro1, tp1desc
				from fst198 f
			 where f.tp1cod = 1
				 and f.tp1cod1 = 11005
				 and f.tp1corr1 = 5
				 and f.tp1corr2 = 2
				 and f.tp1corr3 > 0;
		--
		cursor cuentas(ln_pais number, ln_tdoc number, ln_ndoc char) is
			select ctnro
				from fsr008 f
			 where f.pepais = ln_pais
				 and f.petdoc = ln_tdoc
				 and f.pendoc = ln_ndoc
				 and f.cttfir = 'T';
		--
    cursor lfsd010(ln_ctnro number,ln_aomod number) is
	       select *
				 from fsd010 d
				 where d.pgcod=1
				 and   d.aocta=ln_ctnro
				 and   d.aomod=ln_aomod
				 and   d.aomda=0;
															
		ln_inactivo  number;
		ln_fecing    fsd010.aofval%type;
		ln_importe   fsd010.aoimp%type;
		ln_plazo     fsd010.aopzo%type;
		ln_tasa      fsd010.aotasa%type;
		ln_aostat    fsd010.aostat%type;
		ln_cuenta    fsd010.aocta%type;
		ln_operacion fsd010.aooper%type;
		ln_instancia xwf700.xwfprcins%type;
		flag_garantia char;
		f_ini date;
		f_fin date;
	begin
		-- Obtener periodo de cliente con la caja.
		begin
		-- Desde la fecha de consulta. en este caso 24 meses
		select tp1nro1
			into ln_inactivo
			from fst198
		 where tp1cod = 1
			 and tp1cod1 = 11005
			 and tp1corr1 = 5
			 and tp1corr2 = 1
			 and tp1corr3 = 1;
		exception
			when others then
				ln_inactivo:=0;
		end;
		begin
			pd_tasa  := 100;
			pd_monto := 0;
			pd_plazo := 0;
			
		  f_ini := add_months(pn_fecp, -ln_inactivo);
			f_fin := pn_fecp;
			for x in modulo_toperacion loop			  
				for y in cuentas(pn_pais, pn_tdoc, pn_ndoc) loop
				  for z in lfsd010(y.ctnro,x.tp1nro1) loop
							begin
									select 
										x700.xwfprcins
									into
										ln_instancia 
									from 
										xwf700 x700
									where x700.xwfempresa  = 1
										and x700.xwfsucursal = z.aosuc 
										and x700.xwfmodulo   = z.aomod 
										and x700.xwfmoneda   = z.aomda
										and x700.xwfpapel    = z.aopap
										and x700.xwfcuenta   = z.aocta
										and x700.xwfoperacion= z.aooper 
										and x700.xwfsubope   = z.aosbop
										and x700.xwftipope   = z.aotope;
							exception
							when others then
													ln_instancia:=null;   
							end;
							begin
									pq_cr_campana_ctsuenos.sp_cr_garantias(ln_instancia,flag_garantia);                 							
							end;
					    if flag_garantia='S' then 
									 if z.aomod=101 then
										 begin
											 select aotasa,aoimp,aopzo
											 into   ln_tasa,ln_importe,ln_plazo 
											 from fsd010
												where pgcod = 1
													and aocta = z.aocta    
													and aomod = z.aomod
													and aosuc = z.aosuc
													and aomda = z.aomda
													and aopap = z.aopap
													and aooper= z.aooper
													and aosbop= z.aosbop
													and aotope= z.aotope
													and aotope not in (220,221,222)
													and aomda = 0 
													and aostat in (0,99)
													and aofval between f_ini and f_fin;
										exception
											when others then
													ln_tasa:=100;
													ln_importe:=0;
													ln_plazo:=0;
													
										end;
									else
										 begin
												select aotasa,aoimp,aopzo
												into   ln_tasa,ln_importe,ln_plazo 
												from fsd010
												where pgcod = 1
													and aocta = z.aocta    
													and aomod = z.aomod
													and aosuc = z.aosuc
													and aomda = z.aomda
													and aopap = z.aopap
													and aooper= z.aooper
													and aosbop= z.aosbop
													and aotope= z.aotope
													and aomda = 0
													and aostat in (0,99)
													and aofval between f_ini and f_fin;
										 exception
												when others then
													ln_tasa:=100;
													ln_importe:=0;
													ln_plazo:=0;
										 end;  
									 end if;
							 
							 
							 
									 if ln_tasa < pd_tasa then
											pd_tasa  := ln_tasa;
											pd_monto := ln_importe;
											pd_plazo := ln_plazo;
											pd_flag  := 'S';
									 end if;
									 ln_tasa:=100;
								end if;
					   end loop;	
					end loop;			
				end loop;
			if pd_tasa = 100 then
				pd_flag  := 'N';
				pd_tasa  := null;
				pd_monto := null;
				pd_plazo := null;
			end if;
		
		end;
	
	end;
	-----------------------------------------------------------------------------------------------
	procedure sp_cr_garantias(instancia  in xwf700.xwfprcins%type,ln_flag out char) is
	cursor c_sng122(ln_instancia number) is
	       select *
				 from sng122 s122
				 where s122.sng122inst=ln_instancia; 
	begin
	   for x in c_sng122(instancia) loop
		     if x.sng122tope=90 or x.sng122tope=91 then
				    ln_flag := 'S';
				 else
				    ln_flag := 'N';
						return;
				 end if;
				     
		 end loop;                   
	end;	
	------------------------------------------------------------------------------------

	------------------------------------------------------------------------------------										    
end pq_cr_campana_ctsuenos;
/

