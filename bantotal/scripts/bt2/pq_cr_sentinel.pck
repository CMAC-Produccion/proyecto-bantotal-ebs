CREATE OR REPLACE PACKAGE PQ_CR_SENTINEL is
-- *****************************************************************
-- Nombre                     : PQ_CR_SENTINEL
-- Sistema                    : BANTOTAL
-- Módulo                     : Créditos
-- Versión                    : 1.0
-- Fecha de Creación          : 22/05/2017
-- Autor de Creación          : Cinthya Liz Hernandez Ortega
-- Uso                        : Extrae información para reporte Crediticio Sentinel
-- Estado                     : Activo
-- Acceso                     : Público
-- Fecha de Modificación      : 
-- Autor de Modificación      : 
-- Descripción de Modificación: 
-- 
--  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  PROCEDURE sp_cr_res_endeudam_entidad( P_N_SERIAL IN NUMBER, P_D_FECHA IN DATE, 
                                        P_C_USUARIO IN VARCHAR2, P_C_MAQUINA IN VARCHAR2); 

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_cr_his_endeudamiento( P_N_SERIAL IN NUMBER, P_N_MESES IN NUMBER,
                                     P_C_USUARIO IN VARCHAR2, P_C_MAQUINA IN VARCHAR2); 
    
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  PROCEDURE sp_cr_his_deudasbs_tipo( P_N_SERIAL IN NUMBER, P_N_MESES IN NUMBER,
                                     P_C_USUARIO IN VARCHAR2, P_C_MAQUINA IN VARCHAR2); 

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_cr_fecha_mora_max( P_N_SERIAL IN NUMBER, P_C_CODSU IN VARCHAR2, 
                                  P_C_NUMER IN VARCHAR2, P_D_ULTAC IN DATE,
                                  p_c_fecha out varchar2, p_d_fecmor out date); 

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_cr_res_deudasbs_calif( P_N_SERIAL IN NUMBER, P_N_MESES IN NUMBER,
                                      P_C_USUARIO IN VARCHAR2, P_C_MAQUINA IN VARCHAR2,
                                      p_n_candat out number ); 
                                          
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_cr_fecha_saldo_sector( P_N_SERIAL IN NUMBER, 
                                      p_n_salfsb out number, p_n_salfnr out number,
                                      p_n_salemp out number, p_n_saltel out number); 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_cr_importacion_exportacion( P_N_SERIAL IN NUMBER, 
                                       P_C_USUARIO IN VARCHAR2, P_C_MAQUINA IN VARCHAR2); 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  /*PROCEDURE sp_cr_AFP( P_N_SERIAL IN NUMBER, 
                       P_C_USUARIO IN VARCHAR2, P_C_MAQUINA IN VARCHAR2);*/
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
end PQ_CR_SENTINEL;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_SENTINEL is
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  
  procedure sp_cr_res_endeudam_entidad( P_N_SERIAL IN NUMBER, P_D_FECHA IN DATE, 
                                        P_C_USUARIO IN VARCHAR2, P_C_MAQUINA IN VARCHAR2)
  IS
  -- *****************************************************************
  -- Nombre                     : sp_cr_res_endeudam_entidad
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Creditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 22/05/2017
  -- Autor de Creación          : Cinthya Liz Hernandez Ortega
  -- Uso                        : CARGAR DATOS PARA RESUMEN DE ENDEUDAMIENTO POR ENTIDAD
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_N_SERIAL ( IDENTIFICADOR CONSULTA sentinel )
  --                            : P_D_FECPRO ( FECHA DE PROCESO )
  -- Parámetros de Salida       :
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  --  
  -- *****************************************************************
  
     cursor c_deuda_sbs(pn_serial number, pd_fecha date) is
         select s.JAQZ237tobli tobli,
                s.jaqy764desel,
                s.JAQZ237noent,
                sum(s.d_direc) d_direc,
                sum(s.d_indir) d_indir,
                sum(s.d_venci) d_venci,
                sum(s.d_judic) d_judic,
                sum(s.d_casti) d_casti,
                sum(s.d_lincr1) d_lincr1,
                sum(s.d_lincr2) d_lincr2,
                sum(s.d_lincr3) d_lincr3,
                sum(s.d_garan) d_garan,
                sum(s.d_provi) d_provi
           from (
                  select sb.JAQZ237tobli,
                         t.jaqy764desel,
                         sb.JAQZ237noent,
                         sum(case 
                                when sb.JAQZ237copuc like '14_1%' or sb.JAQZ237copuc like '14_3%' 
                                  or sb.JAQZ237copuc like '14_4%' or sb.JAQZ237copuc like '14_5%'
                                  or sb.JAQZ237copuc like '14_6%' then
                                 sb.JAQZ237saldo else 0 end) d_direc, -- Deuda Directa            
                         sum(case
                                when sb.JAQZ237copuc like '71_1%' or sb.JAQZ237copuc like '71_2%' 
                                  or sb.JAQZ237copuc like '71_3%' or sb.JAQZ237copuc like '71_4%' then
                                 sb.JAQZ237saldo else 0 end) d_indir, -- Deuda Indirecta
                         sum(case
                                when sb.JAQZ237copuc like '14_5%' then
                                 sb.JAQZ237saldo else 0 end) d_venci, -- Vencida
                         sum(case
                                when sb.JAQZ237copuc like '14_6%' then
                                 sb.JAQZ237saldo else 0 end) d_judic, -- Judicial
                         sum(case
                                when sb.JAQZ237copuc like '81_302%' or sb.JAQZ237copuc like '81_925%' then
                                 sb.JAQZ237saldo else 0 end) d_casti, -- Castigada
                         sum(case
                                when sb.JAQZ237copuc like '81_923%' then 
                                 sb.JAQZ237saldo else 0 end) d_lincr1, -- Linea de Credito
                         sum(case
                                when sb.JAQZ237copuc like '72_5%' then
                                 sb.JAQZ237saldo else 0 end) d_lincr2, -- Linea de Credito
                         sum(case
                                when sb.JAQZ237copuc like '14_1__02%' or sb.JAQZ237copuc like '14_3__02%' 
                                  or sb.JAQZ237copuc like '14_4__02%' or sb.JAQZ237copuc like '14_5__02%' 
                                  or sb.JAQZ237copuc like '14_6__02%' then
                                 sb.JAQZ237saldo else 0 end) d_lincr3, -- Linea de Credito
                         sum(case
                                when sb.JAQZ237copuc like '84_4%' then
                                 sb.JAQZ237saldo else 0 end) d_garan, -- Garantias
                         sum(case
                                when sb.JAQZ237copuc like '14_9__01%' or sb.JAQZ237copuc like '14_9__02%'
                                  or sb.JAQZ237copuc like '14_9__03%' or sb.JAQZ237copuc like '14_9__04%'
                                  or sb.JAQZ237copuc like '14_9__05%' then
                                 sb.JAQZ237saldo else 0 end) d_provi -- Provisiones
                    from JAQZ237 sb,  --inner join 
                         jaqy764 t  --on t.jaqy764codel = sb.JAQZ237tobli
                   where t.jaqy764codel(+) = sb.JAQZ237tobli
                     and t.jaqy764tipat(+) = 1
                     and t.jaqy764cotab(+) = '830'
                     and sb.JAQZ237serial = pn_serial
                     and sb.JAQZ237ferep = pd_fecha
                   group by sb.JAQZ237tobli, t.jaqy764desel, sb.JAQZ237noent
                  UNION ALL
                  select sb.JAQZ237tobli,
                         t.jaqy764desel,
                         sb.JAQZ237noent,
                         sum(case 
                                when sb.JAQZ237copuc like '14_1%' or sb.JAQZ237copuc like '14_3%' 
                                  or sb.JAQZ237copuc like '14_4%' or sb.JAQZ237copuc like '14_5%' 
                                  or sb.JAQZ237copuc like '14_6%' then
                                 (sb.JAQZ237saldo*-1) else 0 end) d_direc, -- Deuda Directa            
                         sum(case
                                when sb.JAQZ237copuc like '71_1%' or sb.JAQZ237copuc like '71_2%' 
                                  or sb.JAQZ237copuc like '71_3%' or sb.JAQZ237copuc like '71_4%' then
                                 (sb.JAQZ237saldo*-1) else 0 end) d_indir, -- Deuda Indirecta
                         sum(case
                                when sb.JAQZ237copuc like '14_5%' then
                                 (sb.JAQZ237saldo*-1) else 0 end) d_venci, -- Vencida
                         sum(case
                                when sb.JAQZ237copuc like '14_6%' then
                                 (sb.JAQZ237saldo*-1) else 0 end) d_judic, -- Judicial
                         sum(case
                                when sb.JAQZ237copuc like '81_302%' or sb.JAQZ237copuc like '81_925%' then
                                 (sb.JAQZ237saldo*-1) else 0 end) d_casti, -- Castigada
                         sum(case
                                when sb.JAQZ237copuc like '81_923%' then 
                                 (sb.JAQZ237saldo*-1) else 0 end) d_lincr1, -- Linea de Credito
                         sum(case
                                when sb.JAQZ237copuc like '72_5%' then
                                 (sb.JAQZ237saldo*-1) else 0 end) d_lincr2, -- Linea de Credito
                         sum(case
                                when sb.JAQZ237copuc like '14_1__02%' or sb.JAQZ237copuc like '14_3__02%' 
                                  or sb.JAQZ237copuc like '14_4__02%' or sb.JAQZ237copuc like '14_5__02%' 
                                  or sb.JAQZ237copuc like '14_6__02%' then
                                 (sb.JAQZ237saldo*-1) else 0 end) d_lincr3, -- Linea de Credito
                         sum(case
                                when sb.JAQZ237copuc like '84_4%' then
                                 (sb.JAQZ237saldo*-1) else 0 end) d_garan, -- Garantias
                         sum(case
                                when sb.JAQZ237copuc like '14_9__01%' or sb.JAQZ237copuc like '14_9__02%'
                                  or sb.JAQZ237copuc like '14_9__03%' or sb.JAQZ237copuc like '14_9__04%'
                                  or sb.JAQZ237copuc like '14_9__05%' then
                                 (sb.JAQZ237saldo*-1) else 0 end) d_provi -- Provisiones
                    from JAQZ237 sb,  --inner join 
                         jaqy764 t  --on t.jaqy764codel = sb.JAQZ237tobli
                   where t.jaqy764codel(+) = sb.JAQZ237tobli
                     and t.jaqy764tipat(+) = 1
                     and t.jaqy764cotab(+) = '830'
                     and sb.JAQZ237serial = pn_serial
                     and sb.JAQZ237ferep = pd_fecha
                     and nvl(sb.JAQZ237indle, 0) = 1
                   group by sb.JAQZ237tobli, t.jaqy764desel, sb.JAQZ237noent 
                ) s
          group by s.JAQZ237tobli, s.jaqy764desel, s.JAQZ237noent
          order by s.jaqy764desel, s.JAQZ237noent;	
     
     cursor c_deuda_nosbs(pn_serial number, ld_fecha date) is
           select       Ns.JAQZ243nosus as JAQZ238entid,
                          sum(ns.JAQZ243vasde) as JAQZ238SALAC
                          from JAQZ243 ns
                         where ns.JAQZ243serial = pn_serial--982
                           and ns.JAQZ243inend = '0'
                           and ns.JAQZ243fenov =ld_fecha --'01/10/2014'    
                           and ns.JAQZ243cocta <> '23'  -- No Telcos   
                         group by ns.JAQZ243fenov, ns.JAQZ243cocta,JAQZ243nosus;
		 
     
     ld_fecha date;
     ln_corr JAQZ222.JAQZ222nro%type;
     ln_tipo JAQZ222.JAQZ222tip%type; 
     ln_lincr JAQZ237.JAQZ237saldo%type;
       
  BEGIN
       
     ln_tipo := 1; 
	  delete from JAQZ222
		where JAQZ222usu = P_C_USUARIO
		  and JAQZ222maq = P_C_MAQUINA
		  and JAQZ222tip = ln_tipo;     
     commit;
     
     ln_corr := 0;
     
     -- Deuda SBS
     for d in c_deuda_sbs(P_N_SERIAL, P_D_FECHA) loop    
     
         if d.d_lincr1 > 0 then
            ln_lincr := d.d_lincr1;
         elsif d.tobli = 1 then
            ln_lincr := d.d_lincr2;
         else
            ln_lincr := d.d_lincr2 + d.d_lincr3;
         end if;
         
         ln_corr := ln_corr + 1;     
			insert into JAQZ222
				(JAQZ222usu,
             JAQZ222maq,
             JAQZ222tip,
             JAQZ222nro,
             JAQZ222txt1, -- Tipo de crédito
             JAQZ222txt2, -- Entidad
             JAQZ222txt3, -- para calculos, tipo de deuda regulada o no regulada
             JAQZ222num1, -- Deuda directa
             JAQZ222num2, -- Deuda indirecta
             JAQZ222num3, -- Deuda vencida
             JAQZ222num4, -- Deuda judicial
             JAQZ222num5, -- Deuda castigada
             JAQZ222num6, -- Linea de credito
             JAQZ222num7, -- Garantias
             JAQZ222num8, -- Provisiones
             JAQZ222num9  -- Deuda No Sbs 
             )  
         values       
				(P_C_USUARIO,
             P_C_MAQUINA,
             ln_tipo,
             ln_corr,
             d.jaqy764desel,
				 d.JAQZ237noent,
             'REG',
				 d.d_direc,
				 d.d_indir,
				 d.d_venci,
				 d.d_judic,
				 d.d_casti,
				 ln_lincr,
				 d.d_garan,
				 d.d_provi,
             0.00 );  
         COMMIT;  
     end loop;
     
     -- Deuda No Regulada
     ld_fecha := to_date('01.'||to_char(P_D_FECHA,'mm.rrrr'),'dd.mm.rrrr');
     for e in c_deuda_nosbs(P_N_SERIAL,ld_fecha) loop    
     
         ln_corr := ln_corr + 1;
         insert into JAQZ222
				(JAQZ222usu,
             JAQZ222maq,
             JAQZ222tip,
             JAQZ222nro,
             JAQZ222txt1, -- Tipo de crédito
             JAQZ222txt2, -- Entidad
             JAQZ222txt3, -- para calculos, tipo de deuda regulada o no regulada
             JAQZ222num1, -- Deuda directa
             JAQZ222num2, -- Deuda indirecta
             JAQZ222num3, -- Deuda vencida
             JAQZ222num4, -- Deuda judicial
             JAQZ222num5, -- Deuda castigada
             JAQZ222num6, -- Linea de credito
             JAQZ222num7, -- Garantias
             JAQZ222num8, -- Provisiones
             JAQZ222num9  -- Deuda No Sbs 
             )  
			values
				(P_C_USUARIO,
             P_C_MAQUINA,
             ln_tipo,
             ln_corr,
            'Cartera No Regulada',
             e.JAQZ238entid,
				 'NOR',
             0.00,
             0.00,
             0.00,
             0.00,
             0.00,
             0.00,
             0.00,
             0.00,
				 E.JAQZ238SALAC );         
         COMMIT;                  
     end loop;

  END sp_cr_res_endeudam_entidad;
  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                              
procedure sp_cr_his_endeudamiento( P_N_SERIAL IN NUMBER, P_N_MESES IN NUMBER,
                                   P_C_USUARIO IN VARCHAR2, P_C_MAQUINA IN VARCHAR2 )
  IS
  -- *****************************************************************
  -- Nombre                     : sp_cr_his_endeudamiento
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Creditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 22/05/2017
  -- Autor de Creación          : Cinthya Liz Hernandez Ortega
  -- Uso                        : CARGAR DATOS PARA HISTORIAL DE ENDEUDAMIENTO POR CUENTA CONTABLE
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_N_SERIAL ( IDENTIFICADOR CONSULTA sentinel )
  --                            : P_N_MESES ( CANTIDAD DE MESES A DEVOLVER )
  -- Parámetros de Salida       :
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  --  
  -- *****************************************************************
  
     ld_fech1 date;
     ld_fech2 date;
     
     cursor c_deuda(pn_serial number, pd_fech1 date, pd_fech2 date) is
          select d.fec_corte,
                 sum(d.n_ent_sbs)   n_ent_sbs,
                 sum(d.d_direc)     d_direc,
                 sum(d.d_venci)     d_venci,
                 sum(d.d_judic)     d_judic,
                 sum(d.d_casti)     d_casti,
                 sum(d.d_indir)     d_indir,
                 sum(d.d_garan)     d_garan,
                 sum(d.d_provi)     d_provi,
                 sum(d.n_ent_nosbs) n_ent_nosbs,
                 sum(d.d_nosbs)     d_nosbs
            from (
                 -- Deuda SBS
                 select t.fec_corte, 
                        sum(t.n_ent_sbs) n_ent_sbs, 
                        sum(t.d_direc)   d_direc, 
                        sum(t.d_venci)   d_venci,
                        sum(t.d_judic)   d_judic,
                        sum(t.d_casti)   d_casti,
                        sum(t.d_indir)   d_indir,
                        sum(t.d_garan)   d_garan,
                        sum(t.d_provi)   d_provi,
                        sum(t.n_ent_nosbs) n_ent_nosbs,
                        sum(t.d_nosbs)     d_nosbs
                    from (
                         select sb.JAQZ237ferep fec_corte,
                               count(distinct sb.JAQZ237coent) n_ent_sbs,
                               sum(case
                                      when sb.JAQZ237copuc like '14_1%' or sb.JAQZ237copuc like '14_3%' 
                                        or sb.JAQZ237copuc like '14_4%' or sb.JAQZ237copuc like '14_5%'
                                        or sb.JAQZ237copuc like '14_6%' then
                                       sb.JAQZ237saldo else 0 end) d_direc, -- Deuda Directa            
                               sum(case
                                      when sb.JAQZ237copuc like '14_5%' then
                                       sb.JAQZ237saldo else 0 end) d_venci, -- Vencida
                               sum(case
                                      when sb.JAQZ237copuc like '14_6%' then
                                       sb.JAQZ237saldo else 0 end) d_judic, -- Judicial
                               sum(case
                                      when sb.JAQZ237copuc like '81_302%' or sb.JAQZ237copuc like '81_925%' then
                                       sb.JAQZ237saldo else 0 end) d_casti, -- Castigada
                               sum(case
                                      when sb.JAQZ237copuc like '71_1%' or sb.JAQZ237copuc like '71_2%' 
                                        or sb.JAQZ237copuc like '71_3%' or sb.JAQZ237copuc like '71_4%' then
                                       sb.JAQZ237saldo else 0 end) d_indir, -- Deuda Indirecta
                               sum(case
                                      when sb.JAQZ237copuc like '84_4%' then
                                       sb.JAQZ237saldo else 0 end) d_garan, -- Garantias
                               sum(case
                                      when sb.JAQZ237copuc like '14_9__01%' or sb.JAQZ237copuc like '14_9__02%'
                                        or sb.JAQZ237copuc like '14_9__03%' or sb.JAQZ237copuc like '14_9__04%'
                                        or sb.JAQZ237copuc like '14_9__05%' then
                                       sb.JAQZ237saldo else 0 end) d_provi, -- Provisiones
                               0 n_ent_nosbs, 
                               0.00 d_nosbs
                          from JAQZ237 sb
                         where sb.JAQZ237serial = pn_serial
                           and sb.JAQZ237ferep = pd_fech1
                         group by sb.JAQZ237ferep
                         UNION ALL
                         select sb.JAQZ237ferep fec_corte,
                               0 n_ent_sbs,
                               sum(case
                                      when sb.JAQZ237copuc like '14_1%' or sb.JAQZ237copuc like '14_3%' 
                                        or sb.JAQZ237copuc like '14_4%' or sb.JAQZ237copuc like '14_5%'
                                        or sb.JAQZ237copuc like '14_6%' then
                                       (sb.JAQZ237saldo*-1) else 0 end) d_direc, -- Deuda Directa            
                               sum(case
                                      when sb.JAQZ237copuc like '14_5%' then
                                       (sb.JAQZ237saldo*-1) else 0 end) d_venci, -- Vencida
                               sum(case
                                      when sb.JAQZ237copuc like '14_6%' then
                                       (sb.JAQZ237saldo*-1) else 0 end) d_judic, -- Judicial
                               sum(case
                                      when sb.JAQZ237copuc like '81_302%' or sb.JAQZ237copuc like '81_925%' then
                                       (sb.JAQZ237saldo*-1) else 0 end) d_casti, -- Castigada
                               sum(case
                                      when sb.JAQZ237copuc like '71_1%' or sb.JAQZ237copuc like '71_2%' 
                                        or sb.JAQZ237copuc like '71_3%' or sb.JAQZ237copuc like '71_4%' then
                                       (sb.JAQZ237saldo*-1) else 0 end) d_indir, -- Deuda Indirecta
                               sum(case
                                      when sb.JAQZ237copuc like '84_4%' then
                                       (sb.JAQZ237saldo*-1) else 0 end) d_garan, -- Garantias
                               sum(case
                                      when sb.JAQZ237copuc like '14_9__01%' or sb.JAQZ237copuc like '14_9__02%'
                                        or sb.JAQZ237copuc like '14_9__03%' or sb.JAQZ237copuc like '14_9__04%' 
                                        or sb.JAQZ237copuc like '14_9__05%' then
                                       (sb.JAQZ237saldo*-1) else 0 end) d_provi, -- Provisiones
                               0 n_ent_nosbs, 
                               0.00 d_nosbs
                          from JAQZ237 sb
                         where sb.JAQZ237serial = pn_serial
                           and sb.JAQZ237ferep = pd_fech1
                           and nvl(sb.JAQZ237indle, 0) = 1
                         group by sb.JAQZ237ferep 
                  ) t  
                  group by t.fec_corte                 
                  UNION ALL   
                  -- Deuda No SBS       
                  --mod sfer             
                  select fec_corte, n_ent_sbs, d_direc, d_venci, d_judic, d_casti,d_indir, d_garan,d_provi, sum(n_ent_nosbs),sum(d_nosbs ) from(             
                        select last_day(ns.JAQZ243fenov) fec_corte,
                               0 n_ent_sbs,
                               0.00 d_direc,
                               0.00 d_venci,
                               0.00 d_judic,
                               0.00 d_casti,
                               0.00 d_indir,
                               0.00 d_garan,
                               0.00 d_provi,
                               count(distinct ns.JAQZ243nosus) n_ent_nosbs,
                               sum(ns.JAQZ243vasde) d_nosbs
                          from JAQZ243 ns
                         where ns.JAQZ243serial = pn_serial
                           and ns.JAQZ243inend = '0'
                           and ns.JAQZ243fenov = pd_fech2    
                           and ns.JAQZ243cocta <> '23'  -- No Telcos   
                         group by ns.JAQZ243fenov, ns.JAQZ243cocta
                         union
                         select last_day(ns.JAQZ243fenov) fec_corte,
                               0 n_ent_sbs,
                               0.00 d_direc,
                               0.00 d_venci,
                               0.00 d_judic,
                               0.00 d_casti,
                               0.00 d_indir,
                               0.00 d_garan,
                               0.00 d_provi,
                               count(distinct ns.JAQZ243nosus) n_ent_nosbs,
                               sum(ns.JAQZ243vasde) d_nosbs
                          from JAQZ243 ns
                         where ns.JAQZ243serial = pn_serial
                           and ns.JAQZ243inend = '0'
                           and ns.JAQZ243fenov = pd_fech2    
                           and ns.JAQZ243cocta = '23'  -- No Telcos   
                           and ns.JAQZ243moros>=180
                         group by ns.JAQZ243fenov, ns.JAQZ243cocta
                         )
                  group by fec_corte, n_ent_sbs, d_direc, d_venci, d_judic, d_casti, d_indir, d_garan,d_provi    
                  --mod sfer 
               ) d 
          group by d.fec_corte;       
          
     ln_corr JAQZ222.JAQZ222nro%type;
     ln_tipo JAQZ222.JAQZ222tip%type; 
     ln_mes number(3) := null;
     ln_nro number(3) := null;
     ln_lim number(3) := 60; -- limite: hasta 5 años de historia
        
  BEGIN
     
     ln_tipo := 2; 
	  delete from JAQZ222
		where JAQZ222usu = P_C_USUARIO
		  and JAQZ222maq = P_C_MAQUINA
		  and JAQZ222tip = ln_tipo;     
     commit;
     
     ln_corr := 0;
     
     begin
        SELECT max(j.JAQZ237ferep) INTO ld_fech1 
          FROM JAQZ237 j
         WHERE j.JAQZ237serial = P_N_SERIAL;         
     exception when others then
        ld_fech1 := null;
     end;
     
     IF ld_fech1 is not null and P_N_MESES > 0 THEN
     
        ln_nro := 1;
        ln_mes := 0;
        While ln_mes < P_N_MESES and ln_nro <= ln_lim Loop
           ld_fech2 := to_date('01.'||to_char(ld_fech1,'mm.rrrr'),'dd.mm.rrrr');
           
           for de in c_deuda(P_N_SERIAL, ld_fech1, ld_fech2) loop    
           
               ln_corr := ln_corr + 1;
               insert into JAQZ222 
                  (JAQZ222usu,
                   JAQZ222maq,
                   JAQZ222tip,
                   JAQZ222nro,
                   JAQZ222fec1,
                   JAQZ222Txt1,
                   JAQZ222num1,
                   JAQZ222num2,
                   JAQZ222num3,
                   JAQZ222num4,
                   JAQZ222num5,
                   JAQZ222num6,
                   JAQZ222num7,
                   JAQZ222num8,             
                   JAQZ222num9,
                   JAQZ222num10)  
               values
                  (P_C_USUARIO,
                   P_C_MAQUINA,
                   ln_tipo,
                   ln_corr,
                   de.fec_corte,
                   to_char(de.fec_corte, 'MON-RRRR'),
                   de.n_ent_sbs,
                   de.d_direc,
                   de.d_venci,
                   de.d_judic,
                   de.d_casti,
                   de.d_indir,
                   de.d_garan,
                   de.d_provi,
                   de.n_ent_nosbs,
                   de.d_nosbs );    
               COMMIT;    
               ln_mes := ln_mes + 1;
           end loop;
           
           ld_fech1 := last_day(add_months(ld_fech1, -1));   
           ln_nro := ln_nro + 1;
        End Loop;
     END IF;

  END sp_cr_his_endeudamiento;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                              
procedure sp_cr_his_deudasbs_tipo( P_N_SERIAL IN NUMBER, P_N_MESES IN NUMBER, 
                                   P_C_USUARIO IN VARCHAR2, P_C_MAQUINA IN VARCHAR2 )
  IS
  -- *****************************************************************
  -- Nombre                     : sp_cr_his_endeuda_tcred
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Creditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 22/05/2017
  -- Autor de Creación          : Cinthya Liz Hernandez Ortega
  -- Uso                        : CARGAR DATOS PARA HISTORIAL DE ENDEUDAMIENTO POR TIPO DE CREDITO
  --                              CONSIDERA COMO TOTAL SÓLO DEUDA DIRECTA
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_N_SERIAL ( IDENTIFICADOR CONSULTA sentinel )
  --                            : P_N_MESES ( CANTIDAD DE MESES A DEVOLVER )
  -- Parámetros de Salida       :
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  --  
  -- *****************************************************************
  
     ld_fecha date;
     
     cursor c_deuda(pn_serial number, pd_fecha date) is
         select sb.JAQZ237ferep fec_corte,  
                sum(case 
                        when sb.JAQZ237copuc like '14__02%' or sb.JAQZ237copuc like '14__12%' 
                          or sb.JAQZ237copuc like '14__13%' or sb.JAQZ237copuc like '14__10%'
                          or sb.JAQZ237copuc like '14__11%' then
                        sb.JAQZ237saldo else 0 end) d_pymes, -- Pymes           
                sum(case 
                        when sb.JAQZ237copuc like '14__03%' then
                        sb.JAQZ237saldo else 0 end) d_consu, -- Consumo
                sum(case 
                        when sb.JAQZ237copuc like '14__04%' then
                        sb.JAQZ237saldo else 0 end) d_hipot, -- Hipotecario
                        
                sum(sb.JAQZ237saldo) d_total -- Total
           from JAQZ237 sb
          where sb.JAQZ237serial = pn_serial
            and sb.JAQZ237ferep = pd_fecha
            and ( sb.JAQZ237copuc like '14_1%' or sb.JAQZ237copuc like '14_3%' 
               or sb.JAQZ237copuc like '14_4%' or sb.JAQZ237copuc like '14_5%' 
               or sb.JAQZ237copuc like '14_6%' )
            and nvl(sb.JAQZ237indle, 0) = 1
          group by sb.JAQZ237ferep;       	
      
     ln_corr JAQZ222.JAQZ222nro%type;
     ln_tipo JAQZ222.JAQZ222tip%type; 
     
  BEGIN
     
     ln_tipo := 3; 
	  delete from JAQZ222
		where JAQZ222usu = P_C_USUARIO
		  and JAQZ222maq = P_C_MAQUINA
		  and JAQZ222tip = ln_tipo;     
     commit;

     ln_corr := 0;
     
     begin
        SELECT max(j.JAQZ237ferep) INTO ld_fecha 
          FROM JAQZ237 j
         WHERE j.JAQZ237serial = P_N_SERIAL;         
     exception when others then
        ld_fecha := null;
     end;
      
     IF ld_fecha is not null and P_N_MESES > 0 THEN
     
        for m in 1..P_N_MESES loop           
           for de in c_deuda(P_N_SERIAL, ld_fecha) loop    
           
               ln_corr := ln_corr + 1;
               insert into JAQZ222 
                  (JAQZ222usu,
                   JAQZ222maq,
                   JAQZ222tip,
                   JAQZ222nro,
                   JAQZ222fec1,
                   JAQZ222Txt1,
                   JAQZ222num1,
                   JAQZ222num2,
                   JAQZ222num3,
                   JAQZ222num4 )  
               values
                  (P_C_USUARIO,
                   P_C_MAQUINA,
                   ln_tipo,
                   ln_corr,
                   de.fec_corte,
                   to_char(de.fec_corte, 'MON-RRRR'),
                   de.d_pymes,
                   de.d_consu,
                   de.d_hipot,
                   de.d_total );    
               COMMIT;                              
           end loop;
           
           ld_fecha := last_day(add_months(ld_fecha, -1));   
        end loop;
        
     END IF;

  END sp_cr_his_deudasbs_tipo;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                              
procedure sp_cr_fecha_mora_max( P_N_SERIAL IN NUMBER, P_C_CODSU IN VARCHAR2, 
                                P_C_NUMER IN VARCHAR2, P_D_ULTAC IN DATE,
                                p_c_fecha out varchar2, p_d_fecmor out date)
  IS
  -- *****************************************************************
  -- Nombre                     : sp_cr_fecha_mora_max
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Creditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 22/05/2017
  -- Autor de Creación          : Cinthya Liz Hernandez Ortega
  -- Uso                        : CALCULA LA FECHA EN LA QUE OCURRIÓ LA MORA MÁXIMA
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_N_SERIAL ( IDENTIFICADOR CONSULTA sentinel )
  --                              P_N_CODSU ( CODIGO DE EMPRESA QUE REPORTA ) 
  --                              P_N_NUMER ( IDENTIFICACION DE LA DEUDA )
  --                              P_D_ULTAC ( FECHA DE ACTUALIZACION )
  -- Parámetros de Salida       : p_d_fecha ( fecha de maxima mora )
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  --  
  -- *****************************************************************
  
     lc_compo JAQZ238.JAQZ238compor%type := null;   
     lc_estad JAQZ238.JAQZ238estado%type := null;
     ln_atrult fst198.tp1nro1%type := 0;
     ln_len number(10) := null;
     lc_tmp char(1);
     ln_tmp number(9);
     ln_max number(9);
     lc_let char(1);
     ln_mes number(9);
     
     cursor c_compo(pn_serial number, pn_codsu VARCHAR2, pn_numer VARCHAR2, pd_ultac date) is
         select sb.JAQZ238compor, sb.JAQZ238estado
           from JAQZ238 sb
          where sb.JAQZ238serial = pn_serial
            and sb.JAQZ238codsu = pn_codsu
            and sb.JAQZ238ultac = pd_ultac
            and sb.JAQZ238numer = pn_numer; 
      
  BEGIN
                    
           
     for c in c_compo(P_N_SERIAL, P_C_CODSU, P_C_NUMER, P_D_ULTAC) LOOP  
          EXIT WHEN (c_compo%NOTFOUND); 
          lc_compo := c.JAQZ238compor;   
         lc_estad := c.JAQZ238estado;                                      
     end loop; 
    
     ln_len := nvl(length(lc_compo),0);
     ln_max := 0;
     ln_tmp := 0;
     lc_let := null;
     
     if ln_len > 0 then
        for i in 1..ln_len loop
             lc_tmp := substr(lc_compo,i,1);
                       
             begin
                ln_tmp := to_number(lc_tmp); 
             exception when others then
                ln_tmp := 0;
                if lc_tmp not in ('N','n','-') and lc_let is null then
                   lc_let := lc_tmp;
                end if;
             end;
                
             if ln_tmp > ln_max then
                ln_max := ln_tmp;   
             end if;
              
         end loop;
     end if;
       
     if lc_let is null and ln_max = 0 then
        p_c_fecha := null;
        p_d_fecmor := null;
     else
        if ln_max > 0 then
           ln_mes := instr(lc_compo, to_char(ln_max)); 
        else
           ln_mes := instr(lc_compo, lc_let);
        end if;
        p_c_fecha := to_char(add_months(P_D_ULTAC, -1*ln_mes),'MON-RRRR');
        p_d_fecmor := add_months(P_D_ULTAC, -1*ln_mes);
     end if;
     
     -- Para estado actual
     if lc_estad <> '06' then -- para vigentes
        begin
           select tp1nro1 into ln_atrult
             from fst198
            where tp1cod1 = 10892
              and tp1corr1 = 5
              and tp1corr2 = 10
              and tp1desc = lc_estad
              and rownum = 1;
        exception when others then
           ln_atrult := 0;
        end;     
        if ln_atrult >= ln_max and ln_atrult > 0 then
           p_c_fecha := to_char(P_D_ULTAC,'MON-RRRR');
           p_d_fecmor := P_D_ULTAC;
        end if; 
     end if;

  END sp_cr_fecha_mora_max;
    
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  procedure sp_cr_res_deudasbs_calif( P_N_SERIAL IN NUMBER, P_N_MESES IN NUMBER,
                                      P_C_USUARIO IN VARCHAR2, P_C_MAQUINA IN VARCHAR2,
                                      p_n_candat out number ) 
  IS
  -- *****************************************************************
  -- Nombre                     : sp_cr_res_endeudam_entidad
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Creditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 22/05/2017
  -- Autor de Creación          : Cinthya Liz Hernandez Ortega
  -- Uso                        : CARGAR DATOS PARA RESUMEN DE ENDEUDAMIENTO POR ENTIDAD
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_N_SERIAL ( IDENTIFICADOR CONSULTA sentinel )
  --                            : P_D_FECPRO ( FECHA DE PROCESO )
  -- Parámetros de Salida       :
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  --  
  -- *****************************************************************
  
     cursor c_salcal_sbs(pn_serial number, pd_fecha date) is
         select *
           from (select sb.JAQZ237ferep, sb.JAQZ237calif calif, sb.JAQZ237saldo saldo, sb.JAQZ237copuc
                   from JAQZ237 sb
                  where sb.JAQZ237serial = pn_serial
                    and sb.JAQZ237ferep = pd_fecha 
                  UNION ALL
                  select sb.JAQZ237ferep, sb.JAQZ237calif calif, (sb.JAQZ237saldo*-1) saldo, sb.JAQZ237copuc
                   from JAQZ237 sb
                  where sb.JAQZ237serial = pn_serial
                    and sb.JAQZ237ferep = pd_fecha 
                    and nvl(sb.JAQZ237indle, 0) = 1  
                 ) t 
                 pivot( sum(case when t.JAQZ237copuc like '14_1%' or t.JAQZ237copuc like '14_3%' 
                               or t.JAQZ237copuc like '14_4%' or t.JAQZ237copuc like '14_5%'
                               or t.JAQZ237copuc like '14_6%' or t.JAQZ237copuc like '71_1%'
                               or t.JAQZ237copuc like '71_2%' or t.JAQZ237copuc like '71_3%'
                               or t.JAQZ237copuc like '71_4%' or t.JAQZ237copuc like '81_302%' 
                               or t.JAQZ237copuc like '81_925%' then t.saldo else 0 end )
                 for calif in ('0' norm, '1' cpp, '2' defi, '3' dudo, '4' perd));   

     ld_fecha date;
     ln_corr JAQZ222.JAQZ222nro%type;
     ln_tipo JAQZ222.JAQZ222tip%type; 
     ln_nro number(3) := null;
     ln_lim number(3) := 60; -- limite: hasta 5 años de historia
           
  BEGIN

     p_n_candat := 0; 
     
     ln_tipo := 4; 
	  delete from JAQZ222
		where JAQZ222usu = P_C_USUARIO
		  and JAQZ222maq = P_C_MAQUINA
		  and JAQZ222tip = ln_tipo;     
     commit;

     ln_corr := 0;
     
     begin
        SELECT max(j.JAQZ237ferep) INTO ld_fecha 
          FROM JAQZ237 j
         WHERE j.JAQZ237serial = P_N_SERIAL;         
     exception when others then
        ld_fecha := null;
     end;
     
     IF ld_fecha is not null and P_N_MESES > 0 THEN
     
        ln_nro := 1;
        WHILE p_n_candat < P_N_MESES and ln_nro <= ln_lim LOOP           

           -- Deuda SBS
           for d in c_salcal_sbs(P_N_SERIAL, ld_fecha) loop  
           
               ln_corr := ln_corr + 1;
               insert into JAQZ222 
                  (JAQZ222usu,
                   JAQZ222maq,
                   JAQZ222tip,
                   JAQZ222nro,
                   JAQZ222fec1,  -- Fecha RCC
                   JAQZ222Txt1,  -- Fecha RCC en texto
                   JAQZ222num1,  -- Normal Saldo
                   JAQZ222num2,  -- CPP Saldo
                   JAQZ222num3,  -- Deficiente Saldo
                   JAQZ222num4,  -- Dudoso Saldo
                   JAQZ222num5   -- Perdida Saldo                  
                  ) 
               values       
                  (substr(P_C_USUARIO,1,10),
                   substr(P_C_MAQUINA,1,30),
                   ln_tipo,
                   ln_corr,
                   d.JAQZ237ferep,
                   to_char(d.JAQZ237ferep, 'MON-RRRR'), -- null,null,null,null,null
                   nvl(d.norm, 0),
                   nvl(d.cpp, 0),
                   nvl(d.defi, 0),
                   nvl(d.dudo, 0),
                   nvl(d.perd, 0) 
                   );         
               COMMIT;  
               p_n_candat := p_n_candat + 1;
           end loop;

           ld_fecha := last_day(add_months(ld_fecha, -1));   
           ln_nro := ln_nro + 1;
        END LOOP;
        
     END IF;
 
  END sp_cr_res_deudasbs_calif;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_cr_fecha_saldo_sector( P_N_SERIAL IN NUMBER, 
                                      p_n_salfsb out number, p_n_salfnr out number,
                                      p_n_salemp out number, p_n_saltel out number) 
  IS
  
  BEGIN

     begin     
     -- Sector Financiero SBS
        select sum(j.JAQZ238salac) into p_n_salfsb
          from JAQZ238 j
         where j.JAQZ238serial = P_N_SERIAL
           and j.JAQZ238indbo = '1';  -- cuentaCartera y tarjetaCredito 
     --eliminar and jaqz238ticta <> 'CRE' OJO chernandez
     exception when others then     
         p_n_salfsb := 0;     
     end;
     
     begin     
     -- Sector Financiero No Regulado
        select sum(t.salac) into p_n_salfnr
          from ( select sum(j.JAQZ238salac) salac
                   from JAQZ238 j
                  where j.JAQZ238serial = P_N_SERIAL
                    and j.JAQZ238tidet = '18' -- cuentaCartera 
                    and j.JAQZ238indbo = '0' 
                    and j.JAQZ238ticta in ('TDC','CAC','FUN')
                    and j.JAQZ238estado <> '06'
                 union all
                 select sum(j.JAQZ238salac) salac
                   from JAQZ238 j
                  where j.JAQZ238serial = P_N_SERIAL
                    and j.JAQZ238tidet = '15' -- tarjetaCredito
                    and j.JAQZ238indbo = '0'
                    and j.JAQZ238estado <> '06'         
               ) t; 
     
     exception when others then     
         p_n_salfnr := 0;     
     end;
  
     begin     
     -- Sector Empresarial
        select sum(j.JAQZ238salac) into p_n_salemp
          from JAQZ238 j
         where j.JAQZ238serial = P_N_SERIAL
           and j.JAQZ238tidet = '18' -- cuentaCartera
           and j.JAQZ238indbo = '0'
           and j.JAQZ238ticta in ('SFI','CSP','CMZ')
           and j.JAQZ238estado <> '06';
     
     exception when others then     
         p_n_salemp := 0;     
     end; 
  
     begin     
     -- Sector Telcos
        select sum(j.JAQZ238salac) into p_n_saltel
          from JAQZ238 j
         where j.JAQZ238serial = P_N_SERIAL
           and j.JAQZ238tidet = '18' -- cuentaCartera
           and j.JAQZ238indbo = '0'
           and j.JAQZ238ticta in ('CTC','CDC') 
           and j.JAQZ238estado not in ('06','52'); -- Por homologar sentinel Web: No se muestran deudas con 52=mora < 180 dias, 06=canceladas 
     
     exception when others then     
         p_n_saltel := 0;     
     end;  

  END sp_cr_fecha_saldo_sector;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_cr_importacion_exportacion( P_N_SERIAL IN NUMBER, 
                                       P_C_USUARIO IN VARCHAR2, P_C_MAQUINA IN VARCHAR2)
  IS     
  cursor c_imp_exp is 
      select JAQZ246serial,anio, sum(num_op_imp) as num_op_imp ,sum(totfob_imp)as totfob_imp,sum(fob_flet_imp)as fob_flet_imp,sum(cant_pai_imp) as cant_pai_imp,sum(num_op_exp)as num_op_exp,sum(totfob_exp)as totfob_exp,sum(cant_pai_exp)as cant_pai_exp
      from 
      (
            select JAQZ246serial,
                   anio,
                   sum(num_op_imp) as num_op_imp,
                   sum(JAQZ246tofob) as totfob_imp,
                   sum(JAQZ246fofls) as fob_flet_imp,
                   count(JAQZ246copao) as cant_pai_imp,
                   0 num_op_exp,
                   0 totfob_exp,
                   0 cant_pai_exp
              from (select JAQZ246serial,
                           EXTRACT(year FROM JAQZ246fepre) as anio,
                           count(*) as num_op_imp,
                           sum(JAQZ246tofob) as JAQZ246tofob,
                           sum(JAQZ246fofls) as JAQZ246fofls,
                           JAQZ246copao
                      from JAQZ246
                     where JAQZ246serial = P_N_SERIAL
                     group by JAQZ246serial,
                              EXTRACT(year FROM JAQZ246fepre),
                              JAQZ246copao)
             group by JAQZ246serial, anio --importaciones
          union
              select JAQZ247serial,
                     anio,
                     0 num_op_imp,
                     0 totfob_imp,
                     0 fob_flet_imp,
                     0 cant_pai_imp,
                     sum(num_op_exp) num_op_exp,
                     sum(JAQZ247tofob) as totfob_exp,
                     count(JAQZ247copao) as cant_pai_exp
                from (select JAQZ247serial,
                             EXTRACT(year FROM JAQZ247feexp) as anio,
                             count(*) as num_op_exp,
                             sum(JAQZ247tofob) as JAQZ247tofob,
                             JAQZ247copao
                        from JAQZ247
                       where JAQZ247serial = P_N_SERIAL
                       group by JAQZ247serial,
                                EXTRACT(year FROM JAQZ247feexp),
                                JAQZ247copao)
               group by JAQZ247serial, anio -- exportaciones
      )group by JAQZ246serial,anio
      order by anio desc;  
      
      ln_tipo JAQZ222.JAQZ222tip%type; 
       ln_corr JAQZ222.JAQZ222nro%type;                     
  BEGIN
  ln_tipo:=5;
  ln_corr:=0;
  
  	  delete from JAQZ222
		where JAQZ222usu = P_C_USUARIO
		  and JAQZ222maq = P_C_MAQUINA
		  and JAQZ222tip = ln_tipo;     
     commit;
     
     
   for de in c_imp_exp loop    
           
              ln_corr := ln_corr + 1;
               insert into JAQZ222 
                  (JAQZ222usu,
                   JAQZ222maq,
                   JAQZ222tip,
                   JAQZ222nro,
                   JAQZ222num1,
                   JAQZ222num2,
                   JAQZ222num3,
                   JAQZ222num4,
                   JAQZ222num5,
                   JAQZ222num6,
                   JAQZ222num7,
                   JAQZ222num8
                   )  
               values
                  (P_C_USUARIO,
                   P_C_MAQUINA,
                   ln_tipo,
                   ln_corr,
                   de.anio,
                   de.num_op_imp,
                   de.totfob_imp,
                   de.fob_flet_imp,
                   de.cant_pai_imp,
                   de.num_op_exp,
                   de.totfob_exp,
                   de.cant_pai_exp
                    );    
               COMMIT;                              
           end loop;
                                                 
  END sp_cr_importacion_exportacion;                                                                                             
  
end PQ_CR_SENTINEL;
/

