create or replace package pq_cr_rs_tasac_rc is

	-- *****************************************************************
	-- Nombre                     : PQ_CR_VIDACAJA
	-- Sistema                    : BANTOTAL
	-- Módulo                     : Créditos - Activas
	-- Versión                    : 1.0
	-- Fecha de Creación          : 2016.05.16
	-- Autor de Creación          : AERNEDO / DCASTRO
	-- Uso                        : OBTENER PAGOS DE CREDITOS CON SEGURO VIDA CAJA
	-- Estado                     : Activo
	-- Acceso                     : Público
	-- *****************************************************************

	----------------------------------------------------------------
	procedure calcular_dias_garantia_real(pn_instancia number,tip_gar number,
																				dias_tas     out number);
	----------------------------------------------------------------  

end pq_cr_rs_tasac_rc;
/

create or replace package body pq_cr_rs_tasac_rc is
	-- *****************************************************************
	-- Nombre                     : pq_cr_rs_tasac_rc
	-- Sistema                    : BANTOTAL
	-- Módulo                     : Créditos - Activas
	-- Versión                    : 1.0
	-- Fecha de Creación          : 2017.06.26
	-- Autor de Creación          : HSUAREZ
	-- Estado                     : Activo
	-- Acceso                     : Público
	-- Fecha de Modificación      : 
	-- Autor de la Modificación   : 
	-- Descripción de Modificación: 
	--                              
	-- *****************************************************************

	procedure calcular_dias_garantia_real(pn_instancia number,tip_gar number,
																				dias_tas     out number)
	
		-- *****************************************************************
		-- Nombre                     : calcular_dias_garantia_real
		-- Sistema                    : BANTOTAL
		-- Módulo                     : Créditos - Activas
		-- Versión                    : 1.0
		-- Fecha de Creación          : 2016.05.16
		-- Autor de Creación          : HSUAREZ
		-- Uso                        : RESOLUTOR DE TASACION - REGLAMENTO DE CREDITOS
		-- Estado                     : Activo
		-- Acceso                     : Público
		-- Fecha de Modificación      : 26/06/2017
		-- Autor de la Modificación   : HSUAREZ
		-- Descripción de Modificación:  RESOLUTOR DE TASACION - REGLAMENTO DE CREDITOS
		--                              
		--*****************************************************************
	 is
		cursor garantias(ln_instancia number,ln_tgar number) is
			select sg12.sng122pgc  ln_pgcod,
						 sg12.sng122mod  ln_modul,
						 sg12.sng122suc  ln_sucur,
						 sg12.sng122mda  ln_mda,
						 sg12.sng122pap  ln_pap,
						 sg12.sng122cta  ln_cta,
						 sg12.sng122oper ln_ope,
						 sg12.sng122sbop ln_sbop,
						 sg12.sng122tope ln_tope
				from sng122 sg12
			 where sg12.sng122inst = ln_instancia
				 and sng122mod = 70
				 and sng122tope in (select tp1nro1
															from fst198 f
														 where tp1cod = 1--1
															 and tp1cod1 = 10881
															 and tp1corr1 = 6
															 and tp1corr2 = ln_tgar);
	
		cursor verifica_gar(ln_pgcod number,
												ln_modul number,
												ln_sucur number,
												ln_mda   number,
												ln_pap   number,
												ln_cta   number,
												ln_ope   number,
												ln_sbop  number,
												ln_tope  number) is
			select pg2.ppg002cod  lv_pgcod,
						 pg2.ppg002mod  lv_modul,
						 pg2.ppg002suc  lv_sucur,
						 pg2.ppg002mda  lv_mda,
						 pg2.ppg002pap  lv_pap,
						 pg2.ppg002cta  lv_cta,
						 pg2.ppg002ope  lv_ope,
						 pg2.ppg002sbo  lv_sbop,
						 pg2.ppg002top  lv_tope,
						 pg2.ppg002frm  lv_frm,
						 pg2.ppg002dato lv_cdato
				from ppg002 pg2
			 where pg2.ppg002cod = ln_pgcod
				 and pg2.ppg002mod = ln_modul
				 and pg2.ppg002suc = ln_sucur
				 and pg2.ppg002mda = ln_mda
				 and pg2.ppg002pap = ln_pap
				 and pg2.ppg002cta = ln_cta
				 and pg2.ppg002ope = ln_ope
				 and pg2.ppg002sbo = ln_sbop
				 and pg2.ppg002top = ln_tope
				 and pg2.ppg002cdat = 77 --atributo fecha de la garantia.
			 order by pg2.ppg002frm desc;--asc;--desc; -- garantia mas antigua
	
		fecha_sis date;
	
		lt_pg_tran   number;
		lt_suc_tran  number;
		lt_mod_tran  number;
		lt_ttran     number;
		lt_nrel_tran number;
		lt_fec_tran  date;
		flag_ex      char;
		lp_cont      number;
		lp_fcon      date;
		lp_hora      char(8);
	
	begin
	
		begin
			select pgfape into fecha_sis from fst017 where pgcod = 1;
		end;
		for g in garantias(pn_instancia,tip_gar) loop
			for v in verifica_gar(g.ln_pgcod,
														g.ln_modul,
														g.ln_sucur,
														g.ln_mda,
														g.ln_pap,
														g.ln_cta,
														g.ln_ope,
														g.ln_sbop,
														g.ln_tope) loop
			
				begin
					select pg0.ppg000tpg,
								 pg0.ppg000tsc,
								 pg0.ppg000tmd,
								 pg0.ppg000ttr,
								 pg0.ppg000tnr,
								 pg0.ppg000tfc
						into lt_pg_tran,
								 lt_suc_tran,
								 lt_mod_tran,
								 lt_ttran,
								 lt_nrel_tran,
								 lt_fec_tran
						from ppg000 pg0
					 where pg0.ppg000pgc = v.lv_pgcod
						 and pg0.ppg000mod = v.lv_modul
						 and pg0.ppg000suc = v.lv_sucur
						 and pg0.ppg000mda = v.lv_mda
						 and pg0.ppg000pap = v.lv_pap
						 and pg0.ppg000cta = v.lv_cta
						 and pg0.ppg000ope = v.lv_ope
						 and pg0.ppg000sbo = v.lv_sbop
						 and pg0.ppg000top = v.lv_tope
						 and pg0.ppg000frm = v.lv_frm;
				Exception
          when others then
               lt_pg_tran  :=0;
							 lt_suc_tran :=0;
							 lt_mod_tran :=0;
							 lt_ttran    :=0;
							 lt_nrel_tran:=0;
							 lt_fec_tran :=null;
        End;
			
				flag_ex := 'N';
			
				if lt_fec_tran < fecha_sis then
					begin
						select 'S', h15.hccorr, h15.hfcon, h15.hhora
							into flag_ex, lp_cont, lp_fcon, lp_hora
							from fsh015 h15
						 where h15.pgcod = lt_pg_tran
							 and h15.hcmod = lt_mod_tran
							 and h15.hsucor = lt_suc_tran
							 and h15.htran = lt_ttran
							 and h15.hnrel = lt_nrel_tran
							 and h15.hfcon = lt_fec_tran
							 and h15.hccorr <> 99;
					Exception
          when others then
               flag_ex := 'N';
							 lp_cont := 0;
							 lp_fcon := null;
							 lp_hora := null;
					end;
				
				else
					begin
						select 'S', d15.itcorr, d15.itfcon, d15.ithora
							into flag_ex, lp_cont, lp_fcon, lp_hora
							from fsd015 d15
						 where d15.pgcod = lt_pg_tran
							 and d15.itsuc = lt_suc_tran
							 and d15.itmod = lt_mod_tran
							 and d15.ittran = lt_ttran
							 and d15.itnrel = lt_nrel_tran
							 and d15.itfcon = lt_fec_tran
							 and d15.itcont = 'S';
					exception
					when others then
               flag_ex := 'N';
							 lp_cont := 0;
							 lp_fcon := null;
							 lp_hora := null;
					end;
				end if;
			
				if flag_ex = 'S' then
					dias_tas := fecha_sis - v.lv_cdato;
					return;
				end if;
			
			end loop;
	
		end loop;
	end calcular_dias_garantia_real;
end pq_cr_rs_tasac_rc;
/

