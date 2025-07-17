CREATE OR REPLACE PACKAGE PQ_CR_EXPERIAN is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_EXPERIAN
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2014.11.24
  -- Autor de Creación          : CMAC-APACHECO
  -- Uso                        : Extrae información para reporte Crediticio Experian
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 13.04.2015
  -- Autor de Modificación      : SFERNANDEM
  -- Descripción de Modificación: 
  -- Fecha de Modificación      : 07.12.2023
  -- Autor de Modificación      : APACHECOH
  -- Descripción de Modificación: NUEVO EXPERIAN
  -- Fecha de Modificación      : 07.05.2024
  -- Autor de Modificación      : APACHECOH
  -- Descripción de Modificación: NUEVO EXPERIAN - IMPORTACIONES Y EXPORTACIONES
  -- Fecha de Modificación      : 30.05.2024
  -- Autor de Modificación      : APACHECOH
  -- Descripción de Modificación: NUEVO EXPERIAN - DEUDA TRIBUTARIA
  -- Fecha de Modificación      : 18.06.2024
  -- Autor de Modificación      : APACHECOH
  -- Descripción de Modificación: MAPEO DE ENTIDADES EN LA AQPB908D
  --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  PROCEDURE sp_cr_res_endeudam_entidad(P_N_SERIAL  IN NUMBER,
                                       P_D_FECHA   IN DATE,
                                       P_C_USUARIO IN VARCHAR2,
                                       P_C_MAQUINA IN VARCHAR2);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_cr_his_endeudamiento(P_N_SERIAL  IN NUMBER,
                                    P_N_MESES   IN NUMBER,
                                    P_C_USUARIO IN VARCHAR2,
                                    P_C_MAQUINA IN VARCHAR2);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  PROCEDURE sp_cr_his_deudasbs_tipo(P_N_SERIAL  IN NUMBER,
                                    P_N_MESES   IN NUMBER,
                                    P_C_USUARIO IN VARCHAR2,
                                    P_C_MAQUINA IN VARCHAR2);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_cr_fecha_mora_max(P_N_SERIAL IN NUMBER,
                                 P_C_CODSU  IN VARCHAR2,
                                 P_C_NUMER  IN VARCHAR2,
                                 P_D_ULTAC  IN DATE,
                                 p_c_fecha  out varchar2,
                                 p_d_fecmor out date);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_cr_res_deudasbs_calif(P_N_SERIAL  IN NUMBER,
                                     P_N_MESES   IN NUMBER,
                                     P_C_USUARIO IN VARCHAR2,
                                     P_C_MAQUINA IN VARCHAR2,
                                     p_n_candat  out number);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_cr_fecha_saldo_sector(P_N_SERIAL IN NUMBER,
                                     p_n_salfsb out number,
                                     p_n_salfnr out number,
                                     p_n_salemp out number,
                                     p_n_saltel out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_cr_importacion_exportacion(P_N_SERIAL  IN NUMBER,
                                          P_N_SERIAL2 IN NUMBER,
                                          P_C_USUARIO IN VARCHAR2,
                                          P_C_MAQUINA IN VARCHAR2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  /*PROCEDURE sp_cr_AFP( P_N_SERIAL IN NUMBER, 
  P_C_USUARIO IN VARCHAR2, P_C_MAQUINA IN VARCHAR2);*/

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_cr_fecha_mora_max(P_N_SERIAL IN NUMBER,
                                 P_V_ENTID  IN VARCHAR2,
                                 P_N_SECUE  IN NUMBER,
                                 P_C_FECHA  OUT VARCHAR2,
                                 P_D_FECMOR OUT DATE);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  PROCEDURE sp_cr_actualizar_mora(P_N_SERIAL IN NUMBER);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  PROCEDURE sp_cr_actualizar_mora_reg(P_N_SERIAL IN NUMBER);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  PROCEDURE sp_cr_actualizar_deuda_trib(P_N_SERIAL IN NUMBER);

end PQ_CR_EXPERIAN;
/
CREATE OR REPLACE PACKAGE BODY PQ_CR_EXPERIAN is
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_cr_res_endeudam_entidad(P_N_SERIAL  IN NUMBER,
                                       P_D_FECHA   IN DATE,
                                       P_C_USUARIO IN VARCHAR2,
                                       P_C_MAQUINA IN VARCHAR2) IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_res_endeudam_entidad
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.11.24
    -- Autor de Creación          : CMAC - APACHECO
    -- Uso                        : CARGAR DATOS PARA RESUMEN DE ENDEUDAMIENTO POR ENTIDAD
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_N_SERIAL ( IDENTIFICADOR CONSULTA EXPERIAN )
    --                            : P_D_FECPRO ( FECHA DE PROCESO )
    -- Parámetros de Salida       :
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************
  
    cursor c_deuda_sbs(pn_serial number, pd_fecha date) is
      select s.jaql547tobli tobli,
             s.jaqy764desel,
             s.jaql547noent,
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
        from (select sb.jaql547tobli,
                     t.jaqy764desel,
                     sb.jaql547noent,
                     sum(case
                           when sb.jaql547copuc like '14_1%' or
                                sb.jaql547copuc like '14_3%' or
                                sb.jaql547copuc like '14_4%' or
                                sb.jaql547copuc like '14_5%' or
                                sb.jaql547copuc like '14_6%' then
                            sb.jaql547saldo
                           else
                            0
                         end) d_direc, -- Deuda Directa            
                     sum(case
                           when sb.jaql547copuc like '71_1%' or
                                sb.jaql547copuc like '71_2%' or
                                sb.jaql547copuc like '71_3%' or
                                sb.jaql547copuc like '71_4%' then
                            sb.jaql547saldo
                           else
                            0
                         end) d_indir, -- Deuda Indirecta
                     sum(case
                           when sb.jaql547copuc like '14_5%' then
                            sb.jaql547saldo
                           else
                            0
                         end) d_venci, -- Vencida
                     sum(case
                           when sb.jaql547copuc like '14_6%' then
                            sb.jaql547saldo
                           else
                            0
                         end) d_judic, -- Judicial
                     sum(case
                           when sb.jaql547copuc like '81_302%' or
                                sb.jaql547copuc like '81_925%' then
                            sb.jaql547saldo
                           else
                            0
                         end) d_casti, -- Castigada
                     sum(case
                           when sb.jaql547copuc like '81_923%' then
                            sb.jaql547saldo
                           else
                            0
                         end) d_lincr1, -- Linea de Credito
                     sum(case
                           when sb.jaql547copuc like '72_5%' then
                            sb.jaql547saldo
                           else
                            0
                         end) d_lincr2, -- Linea de Credito
                     sum(case
                           when sb.jaql547copuc like '14_1__02%' or
                                sb.jaql547copuc like '14_3__02%' or
                                sb.jaql547copuc like '14_4__02%' or
                                sb.jaql547copuc like '14_5__02%' or
                                sb.jaql547copuc like '14_6__02%' then
                            sb.jaql547saldo
                           else
                            0
                         end) d_lincr3, -- Linea de Credito
                     sum(case
                           when sb.jaql547copuc like '84_4%' then
                            sb.jaql547saldo
                           else
                            0
                         end) d_garan, -- Garantias
                     sum(case
                           when sb.jaql547copuc like '14_9__01%' or
                                sb.jaql547copuc like '14_9__02%' or
                                sb.jaql547copuc like '14_9__03%' or
                                sb.jaql547copuc like '14_9__04%' or
                                sb.jaql547copuc like '14_9__05%' then
                            sb.jaql547saldo
                           else
                            0
                         end) d_provi -- Provisiones
                from jaql547 sb, --inner join 
                     jaqy764 t --on t.jaqy764codel = sb.jaql547tobli
               where t.jaqy764codel(+) = sb.jaql547tobli
                 and t.jaqy764tipat(+) = 1
                 and t.jaqy764cotab(+) = '830'
                 and sb.jaql546serial = pn_serial
                 and sb.jaql547ferep = pd_fecha
               group by sb.jaql547tobli, t.jaqy764desel, sb.jaql547noent
              UNION ALL
              select sb.jaql547tobli,
                     t.jaqy764desel,
                     sb.jaql547noent,
                     sum(case
                           when sb.jaql547copuc like '14_1%' or
                                sb.jaql547copuc like '14_3%' or
                                sb.jaql547copuc like '14_4%' or
                                sb.jaql547copuc like '14_5%' or
                                sb.jaql547copuc like '14_6%' then
                            (sb.jaql547saldo * -1)
                           else
                            0
                         end) d_direc, -- Deuda Directa            
                     sum(case
                           when sb.jaql547copuc like '71_1%' or
                                sb.jaql547copuc like '71_2%' or
                                sb.jaql547copuc like '71_3%' or
                                sb.jaql547copuc like '71_4%' then
                            (sb.jaql547saldo * -1)
                           else
                            0
                         end) d_indir, -- Deuda Indirecta
                     sum(case
                           when sb.jaql547copuc like '14_5%' then
                            (sb.jaql547saldo * -1)
                           else
                            0
                         end) d_venci, -- Vencida
                     sum(case
                           when sb.jaql547copuc like '14_6%' then
                            (sb.jaql547saldo * -1)
                           else
                            0
                         end) d_judic, -- Judicial
                     sum(case
                           when sb.jaql547copuc like '81_302%' or
                                sb.jaql547copuc like '81_925%' then
                            (sb.jaql547saldo * -1)
                           else
                            0
                         end) d_casti, -- Castigada
                     sum(case
                           when sb.jaql547copuc like '81_923%' then
                            (sb.jaql547saldo * -1)
                           else
                            0
                         end) d_lincr1, -- Linea de Credito
                     sum(case
                           when sb.jaql547copuc like '72_5%' then
                            (sb.jaql547saldo * -1)
                           else
                            0
                         end) d_lincr2, -- Linea de Credito
                     sum(case
                           when sb.jaql547copuc like '14_1__02%' or
                                sb.jaql547copuc like '14_3__02%' or
                                sb.jaql547copuc like '14_4__02%' or
                                sb.jaql547copuc like '14_5__02%' or
                                sb.jaql547copuc like '14_6__02%' then
                            (sb.jaql547saldo * -1)
                           else
                            0
                         end) d_lincr3, -- Linea de Credito
                     sum(case
                           when sb.jaql547copuc like '84_4%' then
                            (sb.jaql547saldo * -1)
                           else
                            0
                         end) d_garan, -- Garantias
                     sum(case
                           when sb.jaql547copuc like '14_9__01%' or
                                sb.jaql547copuc like '14_9__02%' or
                                sb.jaql547copuc like '14_9__03%' or
                                sb.jaql547copuc like '14_9__04%' or
                                sb.jaql547copuc like '14_9__05%' then
                            (sb.jaql547saldo * -1)
                           else
                            0
                         end) d_provi -- Provisiones
                from jaql547 sb, --inner join 
                     jaqy764 t --on t.jaqy764codel = sb.jaql547tobli
               where t.jaqy764codel(+) = sb.jaql547tobli
                 and t.jaqy764tipat(+) = 1
                 and t.jaqy764cotab(+) = '830'
                 and sb.jaql546serial = pn_serial
                 and sb.jaql547ferep = pd_fecha
                 and nvl(sb.jaql547indle, 0) = 1
               group by sb.jaql547tobli, t.jaqy764desel, sb.jaql547noent) s
       group by s.jaql547tobli, s.jaqy764desel, s.jaql547noent
       order by s.jaqy764desel, s.jaql547noent;
  
    cursor c_deuda_nosbs(pn_serial number, ld_fecha date) is
      select Ns.jaql603nosus as jaql548entid,
             sum(ns.jaql603vasde) as JAQL548SALAC
        from jaql603 ns
       where ns.jaql546serial = pn_serial --982
         and ns.jaql603inend = '0'
         and ns.jaql603fenov = ld_fecha --'01/10/2014'    
         and ns.jaql603cocta <> '23' -- No Telcos   
       group by ns.jaql603fenov, ns.jaql603cocta, jaql603nosus;
    /*select --ns.jaql548ticta,
             ns.jaql548entid, 
        sum(case
          when ns.jaql548ticta in ('CTC', 'CDC') and ns.jaql548estado = '52' then -- Por homologar Experian Web
           0  else ns.jaql548salac end) jaql548salac
     from jaql548 ns
    where ns.jaql546serial = pn_serial
      and nvl(ns.jaql548indbo, 0) = 0
      and ns.jaql548estado <> '06' 
       group by ns.jaql548entid
       order by ns.jaql548entid;    */
  
    ld_fecha date;
    ln_corr  jaqy173.jaqy173nro%type;
    ln_tipo  jaqy173.jaqy173tip%type;
    ln_lincr jaql547.jaql547saldo%type;
  
  BEGIN
  
    ln_tipo := 1;
    delete from JAQY173
     where jaqy173usu = P_C_USUARIO
       and jaqy173maq = P_C_MAQUINA
       and jaqy173tip = ln_tipo;
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
      insert into JAQY173
        (jaqy173usu,
         jaqy173maq,
         jaqy173tip,
         jaqy173nro,
         jaqy173txt1, -- Tipo de crédito
         jaqy173txt2, -- Entidad
         jaqy173txt3, -- para calculos, tipo de deuda regulada o no regulada
         jaqy173num1, -- Deuda directa
         jaqy173num2, -- Deuda indirecta
         jaqy173num3, -- Deuda vencida
         jaqy173num4, -- Deuda judicial
         jaqy173num5, -- Deuda castigada
         jaqy173num6, -- Linea de credito
         jaqy173num7, -- Garantias
         jaqy173num8, -- Provisiones
         jaqy173num9 -- Deuda No Sbs 
         )
      values
        (P_C_USUARIO,
         P_C_MAQUINA,
         ln_tipo,
         ln_corr,
         d.jaqy764desel,
         d.jaql547noent,
         'REG',
         d.d_direc,
         d.d_indir,
         d.d_venci,
         d.d_judic,
         d.d_casti,
         ln_lincr,
         d.d_garan,
         d.d_provi,
         0.00);
      COMMIT;
    end loop;
  
    -- Deuda No Regulada
    ld_fecha := to_date('01.' || to_char(P_D_FECHA, 'mm.rrrr'),
                        'dd.mm.rrrr');
    for e in c_deuda_nosbs(P_N_SERIAL, ld_fecha) loop
    
      ln_corr := ln_corr + 1;
      insert into JAQY173
        (jaqy173usu,
         jaqy173maq,
         jaqy173tip,
         jaqy173nro,
         jaqy173txt1, -- Tipo de crédito
         jaqy173txt2, -- Entidad
         jaqy173txt3, -- para calculos, tipo de deuda regulada o no regulada
         jaqy173num1, -- Deuda directa
         jaqy173num2, -- Deuda indirecta
         jaqy173num3, -- Deuda vencida
         jaqy173num4, -- Deuda judicial
         jaqy173num5, -- Deuda castigada
         jaqy173num6, -- Linea de credito
         jaqy173num7, -- Garantias
         jaqy173num8, -- Provisiones
         jaqy173num9 -- Deuda No Sbs 
         )
      values
        (P_C_USUARIO,
         P_C_MAQUINA,
         ln_tipo,
         ln_corr,
         'Cartera No Regulada',
         e.jaql548entid,
         'NOR',
         0.00,
         0.00,
         0.00,
         0.00,
         0.00,
         0.00,
         0.00,
         0.00,
         E.JAQL548SALAC);
      COMMIT;
    end loop;
  
  END sp_cr_res_endeudam_entidad;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                              
  procedure sp_cr_his_endeudamiento(P_N_SERIAL  IN NUMBER,
                                    P_N_MESES   IN NUMBER,
                                    P_C_USUARIO IN VARCHAR2,
                                    P_C_MAQUINA IN VARCHAR2) IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_his_endeudamiento
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.11.28
    -- Autor de Creación          : CMAC - APACHECO
    -- Uso                        : CARGAR DATOS PARA HISTORIAL DE ENDEUDAMIENTO POR CUENTA CONTABLE
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_N_SERIAL ( IDENTIFICADOR CONSULTA EXPERIAN )
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
             sum(d.n_ent_sbs) n_ent_sbs,
             sum(d.d_direc) d_direc,
             sum(d.d_venci) d_venci,
             sum(d.d_judic) d_judic,
             sum(d.d_casti) d_casti,
             sum(d.d_indir) d_indir,
             sum(d.d_garan) d_garan,
             sum(d.d_provi) d_provi,
             sum(d.n_ent_nosbs) n_ent_nosbs,
             sum(d.d_nosbs) d_nosbs
        from (
              -- Deuda SBS
              select t.fec_corte,
                      sum(t.n_ent_sbs) n_ent_sbs,
                      sum(t.d_direc) d_direc,
                      sum(t.d_venci) d_venci,
                      sum(t.d_judic) d_judic,
                      sum(t.d_casti) d_casti,
                      sum(t.d_indir) d_indir,
                      sum(t.d_garan) d_garan,
                      sum(t.d_provi) d_provi,
                      sum(t.n_ent_nosbs) n_ent_nosbs,
                      sum(t.d_nosbs) d_nosbs
                from (select sb.jaql547ferep fec_corte,
                              count(distinct sb.jaql547coent) n_ent_sbs,
                              sum(case
                                    when sb.jaql547copuc like '14_1%' or
                                         sb.jaql547copuc like '14_3%' or
                                         sb.jaql547copuc like '14_4%' or
                                         sb.jaql547copuc like '14_5%' or
                                         sb.jaql547copuc like '14_6%' then
                                     sb.jaql547saldo
                                    else
                                     0
                                  end) d_direc, -- Deuda Directa            
                              sum(case
                                    when sb.jaql547copuc like '14_5%' then
                                     sb.jaql547saldo
                                    else
                                     0
                                  end) d_venci, -- Vencida
                              sum(case
                                    when sb.jaql547copuc like '14_6%' then
                                     sb.jaql547saldo
                                    else
                                     0
                                  end) d_judic, -- Judicial
                              sum(case
                                    when sb.jaql547copuc like '81_302%' or
                                         sb.jaql547copuc like '81_925%' then
                                     sb.jaql547saldo
                                    else
                                     0
                                  end) d_casti, -- Castigada
                              sum(case
                                    when sb.jaql547copuc like '71_1%' or
                                         sb.jaql547copuc like '71_2%' or
                                         sb.jaql547copuc like '71_3%' or
                                         sb.jaql547copuc like '71_4%' then
                                     sb.jaql547saldo
                                    else
                                     0
                                  end) d_indir, -- Deuda Indirecta
                              sum(case
                                    when sb.jaql547copuc like '84_4%' then
                                     sb.jaql547saldo
                                    else
                                     0
                                  end) d_garan, -- Garantias
                              sum(case
                                    when sb.jaql547copuc like '14_9__01%' or
                                         sb.jaql547copuc like '14_9__02%' or
                                         sb.jaql547copuc like '14_9__03%' or
                                         sb.jaql547copuc like '14_9__04%' or
                                         sb.jaql547copuc like '14_9__05%' then
                                     sb.jaql547saldo
                                    else
                                     0
                                  end) d_provi, -- Provisiones
                              0 n_ent_nosbs,
                              0.00 d_nosbs
                         from jaql547 sb
                        where sb.jaql546serial = pn_serial
                          and sb.jaql547ferep = pd_fech1
                        group by sb.jaql547ferep
                       UNION ALL
                       select sb.jaql547ferep fec_corte,
                              0 n_ent_sbs,
                              sum(case
                                    when sb.jaql547copuc like '14_1%' or
                                         sb.jaql547copuc like '14_3%' or
                                         sb.jaql547copuc like '14_4%' or
                                         sb.jaql547copuc like '14_5%' or
                                         sb.jaql547copuc like '14_6%' then
                                     (sb.jaql547saldo * -1)
                                    else
                                     0
                                  end) d_direc, -- Deuda Directa            
                              sum(case
                                    when sb.jaql547copuc like '14_5%' then
                                     (sb.jaql547saldo * -1)
                                    else
                                     0
                                  end) d_venci, -- Vencida
                              sum(case
                                    when sb.jaql547copuc like '14_6%' then
                                     (sb.jaql547saldo * -1)
                                    else
                                     0
                                  end) d_judic, -- Judicial
                              sum(case
                                    when sb.jaql547copuc like '81_302%' or
                                         sb.jaql547copuc like '81_925%' then
                                     (sb.jaql547saldo * -1)
                                    else
                                     0
                                  end) d_casti, -- Castigada
                              sum(case
                                    when sb.jaql547copuc like '71_1%' or
                                         sb.jaql547copuc like '71_2%' or
                                         sb.jaql547copuc like '71_3%' or
                                         sb.jaql547copuc like '71_4%' then
                                     (sb.jaql547saldo * -1)
                                    else
                                     0
                                  end) d_indir, -- Deuda Indirecta
                              sum(case
                                    when sb.jaql547copuc like '84_4%' then
                                     (sb.jaql547saldo * -1)
                                    else
                                     0
                                  end) d_garan, -- Garantias
                              sum(case
                                    when sb.jaql547copuc like '14_9__01%' or
                                         sb.jaql547copuc like '14_9__02%' or
                                         sb.jaql547copuc like '14_9__03%' or
                                         sb.jaql547copuc like '14_9__04%' or
                                         sb.jaql547copuc like '14_9__05%' then
                                     (sb.jaql547saldo * -1)
                                    else
                                     0
                                  end) d_provi, -- Provisiones
                              0 n_ent_nosbs,
                              0.00 d_nosbs
                         from jaql547 sb
                        where sb.jaql546serial = pn_serial
                          and sb.jaql547ferep = pd_fech1
                          and nvl(sb.jaql547indle, 0) = 1
                        group by sb.jaql547ferep) t
               group by t.fec_corte
              UNION ALL
              -- Deuda No SBS       
              --mod sfer             
              select fec_corte,
                      n_ent_sbs,
                      d_direc,
                      d_venci,
                      d_judic,
                      d_casti,
                      d_indir,
                      d_garan,
                      d_provi,
                      sum(n_ent_nosbs),
                      sum(d_nosbs)
                from (select last_day(ns.jaql603fenov) fec_corte,
                              0 n_ent_sbs,
                              0.00 d_direc,
                              0.00 d_venci,
                              0.00 d_judic,
                              0.00 d_casti,
                              0.00 d_indir,
                              0.00 d_garan,
                              0.00 d_provi,
                              count(distinct ns.jaql603nosus) n_ent_nosbs,
                              sum(ns.jaql603vasde) d_nosbs
                         from jaql603 ns
                        where ns.jaql546serial = pn_serial
                          and ns.jaql603inend = '0'
                          and ns.jaql603fenov = pd_fech2
                          and ns.jaql603cocta <> '23' -- No Telcos   
                        group by ns.jaql603fenov, ns.jaql603cocta
                       union
                       select last_day(ns.jaql603fenov) fec_corte,
                              0 n_ent_sbs,
                              0.00 d_direc,
                              0.00 d_venci,
                              0.00 d_judic,
                              0.00 d_casti,
                              0.00 d_indir,
                              0.00 d_garan,
                              0.00 d_provi,
                              count(distinct ns.jaql603nosus) n_ent_nosbs,
                              sum(ns.jaql603vasde) d_nosbs
                         from jaql603 ns
                        where ns.jaql546serial = pn_serial
                          and ns.jaql603inend = '0'
                          and ns.jaql603fenov = pd_fech2
                          and ns.jaql603cocta = '23' -- No Telcos   
                          and ns.jaql603moros >= 180
                        group by ns.jaql603fenov, ns.jaql603cocta)
               group by fec_corte,
                         n_ent_sbs,
                         d_direc,
                         d_venci,
                         d_judic,
                         d_casti,
                         d_indir,
                         d_garan,
                         d_provi
              --mod sfer 
              ) d
       group by d.fec_corte;
  
    ln_corr jaqy173.jaqy173nro%type;
    ln_tipo jaqy173.jaqy173tip%type;
    ln_mes  number(3) := null;
    ln_nro  number(3) := null;
    ln_lim  number(3) := 60; -- limite: hasta 5 años de historia
  
  BEGIN
  
    ln_tipo := 2;
    delete from JAQY173
     where jaqy173usu = P_C_USUARIO
       and jaqy173maq = P_C_MAQUINA
       and jaqy173tip = ln_tipo;
    commit;
  
    ln_corr := 0;
  
    begin
      SELECT max(j.jaql547ferep)
        INTO ld_fech1
        FROM jaql547 j
       WHERE j.jaql546serial = P_N_SERIAL;
    exception
      when others then
        ld_fech1 := null;
    end;
  
    IF ld_fech1 is not null and P_N_MESES > 0 THEN
    
      ln_nro := 1;
      ln_mes := 0;
      While ln_mes < P_N_MESES and ln_nro <= ln_lim Loop
        ld_fech2 := to_date('01.' || to_char(ld_fech1, 'mm.rrrr'),
                            'dd.mm.rrrr');
      
        for de in c_deuda(P_N_SERIAL, ld_fech1, ld_fech2) loop
        
          ln_corr := ln_corr + 1;
          insert into JAQY173
            (jaqy173usu,
             jaqy173maq,
             jaqy173tip,
             jaqy173nro,
             jaqy173fec1,
             jaqy173Txt1,
             jaqy173num1,
             jaqy173num2,
             jaqy173num3,
             jaqy173num4,
             jaqy173num5,
             jaqy173num6,
             jaqy173num7,
             jaqy173num8,
             jaqy173num9,
             jaqy173num10)
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
             de.d_nosbs);
          COMMIT;
          ln_mes := ln_mes + 1;
        end loop;
      
        ld_fech1 := last_day(add_months(ld_fech1, -1));
        ln_nro   := ln_nro + 1;
      End Loop;
    END IF;
  
  END sp_cr_his_endeudamiento;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                              
  procedure sp_cr_his_deudasbs_tipo(P_N_SERIAL  IN NUMBER,
                                    P_N_MESES   IN NUMBER,
                                    P_C_USUARIO IN VARCHAR2,
                                    P_C_MAQUINA IN VARCHAR2) IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_his_endeuda_tcred
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.12.04
    -- Autor de Creación          : CMAC - APACHECO
    -- Uso                        : CARGAR DATOS PARA HISTORIAL DE ENDEUDAMIENTO POR TIPO DE CREDITO
    --                              CONSIDERA COMO TOTAL SÓLO DEUDA DIRECTA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_N_SERIAL ( IDENTIFICADOR CONSULTA EXPERIAN )
    --                            : P_N_MESES ( CANTIDAD DE MESES A DEVOLVER )
    -- Parámetros de Salida       :
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************
  
    ld_fecha date;
  
    cursor c_deuda(pn_serial number, pd_fecha date) is
      select sb.jaql547ferep fec_corte,
             sum(case
                   when sb.jaql547copuc like '14__02%' or
                        sb.jaql547copuc like '14__12%' or
                        sb.jaql547copuc like '14__13%' or
                        sb.jaql547copuc like '14__10%' or
                        sb.jaql547copuc like '14__11%' then
                    sb.jaql547saldo
                   else
                    0
                 end) d_pymes, -- Pymes           
             sum(case
                   when sb.jaql547copuc like '14__03%' then
                    sb.jaql547saldo
                   else
                    0
                 end) d_consu, -- Consumo
             sum(case
                   when sb.jaql547copuc like '14__04%' then
                    sb.jaql547saldo
                   else
                    0
                 end) d_hipot, -- Hipotecario
             
             sum(sb.jaql547saldo) d_total -- Total
        from jaql547 sb
       where sb.jaql546serial = pn_serial
         and sb.jaql547ferep = pd_fecha
         and (sb.jaql547copuc like '14_1%' or sb.jaql547copuc like '14_3%' or
             sb.jaql547copuc like '14_4%' or sb.jaql547copuc like '14_5%' or
             sb.jaql547copuc like '14_6%')
         and nvl(sb.jaql547indle, 0) = 1
       group by sb.jaql547ferep;
  
    ln_corr jaqy173.jaqy173nro%type;
    ln_tipo jaqy173.jaqy173tip%type;
  
  BEGIN
  
    ln_tipo := 3;
    delete from JAQY173
     where jaqy173usu = P_C_USUARIO
       and jaqy173maq = P_C_MAQUINA
       and jaqy173tip = ln_tipo;
    commit;
  
    ln_corr := 0;
  
    begin
      SELECT max(j.jaql547ferep)
        INTO ld_fecha
        FROM jaql547 j
       WHERE j.jaql546serial = P_N_SERIAL;
    exception
      when others then
        ld_fecha := null;
    end;
  
    IF ld_fecha is not null and P_N_MESES > 0 THEN
    
      for m in 1 .. P_N_MESES loop
        for de in c_deuda(P_N_SERIAL, ld_fecha) loop
        
          ln_corr := ln_corr + 1;
          insert into JAQY173
            (jaqy173usu,
             jaqy173maq,
             jaqy173tip,
             jaqy173nro,
             jaqy173fec1,
             jaqy173Txt1,
             jaqy173num1,
             jaqy173num2,
             jaqy173num3,
             jaqy173num4)
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
             de.d_total);
          COMMIT;
        end loop;
      
        ld_fecha := last_day(add_months(ld_fecha, -1));
      end loop;
    
    END IF;
  
  END sp_cr_his_deudasbs_tipo;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                              
  procedure sp_cr_fecha_mora_max(P_N_SERIAL IN NUMBER,
                                 P_C_CODSU  IN VARCHAR2,
                                 P_C_NUMER  IN VARCHAR2,
                                 P_D_ULTAC  IN DATE,
                                 p_c_fecha  out varchar2,
                                 p_d_fecmor out date) IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_fecha_mora_max
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.12.11
    -- Autor de Creación          : CMAC - APACHECO
    -- Uso                        : CALCULA LA FECHA EN LA QUE OCURRIÓ LA MORA MÁXIMA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_N_SERIAL ( IDENTIFICADOR CONSULTA EXPERIAN )
    --                              P_N_CODSU ( CODIGO DE EMPRESA QUE REPORTA ) 
    --                              P_N_NUMER ( IDENTIFICACION DE LA DEUDA )
    --                              P_D_ULTAC ( FECHA DE ACTUALIZACION )
    -- Parámetros de Salida       : p_d_fecha ( fecha de maxima mora )
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************
  
    lc_compo  jaql548.jaql548compor%type := null;
    lc_estad  jaql548.jaql548estado%type := null;
    ln_atrult fst198.tp1nro1%type := 0;
    ln_len    number(10) := null;
    lc_tmp    char(1);
    ln_tmp    number(9);
    ln_max    number(9);
    lc_let    char(1);
    ln_mes    number(9);
  
    cursor c_compo(pn_serial number,
                   pn_codsu  VARCHAR2,
                   pn_numer  VARCHAR2,
                   pd_ultac  date) is
      select sb.jaql548compor, sb.jaql548estado
        from jaql548 sb
       where sb.jaql546serial = pn_serial
         and sb.jaql548codsu = pn_codsu
         and sb.jaql548ultac = pd_ultac
         and sb.jaql548numer = pn_numer;
  
  BEGIN
  
    for c in c_compo(P_N_SERIAL, P_C_CODSU, P_C_NUMER, P_D_ULTAC) LOOP
      EXIT WHEN(c_compo%NOTFOUND);
      lc_compo := c.jaql548compor;
      lc_estad := c.jaql548estado;
    end loop;
  
    ln_len := nvl(length(lc_compo), 0);
    ln_max := 0;
    ln_tmp := 0;
    lc_let := null;
  
    if ln_len > 0 then
      for i in 1 .. ln_len loop
        lc_tmp := substr(lc_compo, i, 1);
      
        begin
          ln_tmp := to_number(lc_tmp);
        exception
          when others then
            ln_tmp := 0;
            if lc_tmp not in ('N', 'n', '-') and lc_let is null then
              lc_let := lc_tmp;
            end if;
        end;
      
        if ln_tmp > ln_max then
          ln_max := ln_tmp;
        end if;
      
      end loop;
    end if;
  
    if lc_let is null and ln_max = 0 then
      p_c_fecha  := null;
      p_d_fecmor := null;
    else
      if ln_max > 0 then
        ln_mes := instr(lc_compo, to_char(ln_max));
      else
        ln_mes := instr(lc_compo, lc_let);
      end if;
      p_c_fecha  := to_char(add_months(P_D_ULTAC, -1 * ln_mes),
                            'MON-RRRR',
                            'NLS_DATE_LANGUAGE = Spanish');
      p_d_fecmor := add_months(P_D_ULTAC, -1 * ln_mes);
    end if;
  
    -- Para estado actual
    if lc_estad <> '06' then
      -- para vigentes
      begin
        select tp1nro1
          into ln_atrult
          from fst198
         where tp1cod1 = 10892
           and tp1corr1 = 5
           and tp1corr2 = 10
           and tp1desc = lc_estad
           and rownum = 1;
      exception
        when others then
          ln_atrult := 0;
      end;
      if ln_atrult >= ln_max and ln_atrult > 0 then
        p_c_fecha  := to_char(P_D_ULTAC,
                              'MON-RRRR',
                              'NLS_DATE_LANGUAGE = Spanish');
        p_d_fecmor := P_D_ULTAC;
      end if;
    end if;
  
  END sp_cr_fecha_mora_max;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  procedure sp_cr_res_deudasbs_calif(P_N_SERIAL  IN NUMBER,
                                     P_N_MESES   IN NUMBER,
                                     P_C_USUARIO IN VARCHAR2,
                                     P_C_MAQUINA IN VARCHAR2,
                                     p_n_candat  out number) IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_res_endeudam_entidad
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.11.24
    -- Autor de Creación          : CMAC - APACHECO
    -- Uso                        : CARGAR DATOS PARA RESUMEN DE ENDEUDAMIENTO POR ENTIDAD
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_N_SERIAL ( IDENTIFICADOR CONSULTA EXPERIAN )
    --                            : P_D_FECPRO ( FECHA DE PROCESO )
    -- Parámetros de Salida       :
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************
  
    cursor c_salcal_sbs(pn_serial number, pd_fecha date) is
      select *
        from (select sb.jaql547ferep,
                     sb.jaql547calif calif,
                     sb.jaql547saldo saldo,
                     sb.jaql547copuc
                from jaql547 sb
               where sb.jaql546serial = pn_serial
                 and sb.jaql547ferep = pd_fecha
              UNION ALL
              select sb.jaql547ferep,
                     sb.jaql547calif calif,
                     (sb.jaql547saldo * -1) saldo,
                     sb.jaql547copuc
                from jaql547 sb
               where sb.jaql546serial = pn_serial
                 and sb.jaql547ferep = pd_fecha
                 and nvl(sb.jaql547indle, 0) = 1) t
      pivot(sum(case when t.jaql547copuc like '14_1%' or t.jaql547copuc like '14_3%' or t.jaql547copuc like '14_4%' or t.jaql547copuc like '14_5%' or t.jaql547copuc like '14_6%' or t.jaql547copuc like '71_1%' or t.jaql547copuc like '71_2%' or t.jaql547copuc like '71_3%' or t.jaql547copuc like '71_4%' or t.jaql547copuc like '81_302%' or t.jaql547copuc like '81_925%' then t.saldo else 0 end)
         for calif in('0' norm, '1' cpp, '2' defi, '3' dudo, '4' perd));
  
    ld_fecha date;
    ln_corr  jaqy173.jaqy173nro%type;
    ln_tipo  jaqy173.jaqy173tip%type;
    ln_nro   number(3) := null;
    ln_lim   number(3) := 60; -- limite: hasta 5 años de historia
  
  BEGIN
  
    p_n_candat := 0;
  
    ln_tipo := 4;
    delete from JAQY173
     where jaqy173usu = P_C_USUARIO
       and jaqy173maq = P_C_MAQUINA
       and jaqy173tip = ln_tipo;
    commit;
  
    ln_corr := 0;
  
    begin
      SELECT max(j.jaql547ferep)
        INTO ld_fecha
        FROM jaql547 j
       WHERE j.jaql546serial = P_N_SERIAL;
    exception
      when others then
        ld_fecha := null;
    end;
  
    IF ld_fecha is not null and P_N_MESES > 0 THEN
    
      ln_nro := 1;
      WHILE p_n_candat < P_N_MESES and ln_nro <= ln_lim LOOP
      
        -- Deuda SBS
        for d in c_salcal_sbs(P_N_SERIAL, ld_fecha) loop
        
          ln_corr := ln_corr + 1;
          insert into JAQY173
            (jaqy173usu,
             jaqy173maq,
             jaqy173tip,
             jaqy173nro,
             jaqy173fec1, -- Fecha RCC
             jaqy173Txt1, -- Fecha RCC en texto
             jaqy173num1, -- Normal Saldo
             jaqy173num2, -- CPP Saldo
             jaqy173num3, -- Deficiente Saldo
             jaqy173num4, -- Dudoso Saldo
             jaqy173num5 -- Perdida Saldo                  
             )
          values
            (substr(P_C_USUARIO, 1, 10),
             substr(P_C_MAQUINA, 1, 30),
             ln_tipo,
             ln_corr,
             d.jaql547ferep,
             to_char(d.jaql547ferep, 'MON-RRRR'), -- null,null,null,null,null
             nvl(d.norm, 0),
             nvl(d.cpp, 0),
             nvl(d.defi, 0),
             nvl(d.dudo, 0),
             nvl(d.perd, 0));
          COMMIT;
          p_n_candat := p_n_candat + 1;
        end loop;
      
        ld_fecha := last_day(add_months(ld_fecha, -1));
        ln_nro   := ln_nro + 1;
      END LOOP;
    
    END IF;
  
  END sp_cr_res_deudasbs_calif;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_cr_fecha_saldo_sector(P_N_SERIAL IN NUMBER,
                                     p_n_salfsb out number,
                                     p_n_salfnr out number,
                                     p_n_salemp out number,
                                     p_n_saltel out number) IS
  
  BEGIN
  
    begin
      -- Sector Financiero SBS
      select sum(j.jaql548salac)
        into p_n_salfsb
        from jaql548 j
       where j.jaql546serial = P_N_SERIAL
         and j.jaql548indbo = '1'; -- cuentaCartera y tarjetaCredito 
    
    exception
      when others then
        p_n_salfsb := 0;
    end;
  
    begin
      -- Sector Financiero No Regulado
      select sum(t.salac)
        into p_n_salfnr
        from (select sum(j.jaql548salac) salac
                from jaql548 j
               where j.jaql546serial = P_N_SERIAL
                 and j.jaql548tidet = '18' -- cuentaCartera 
                 and j.jaql548indbo = '0'
                 and j.jaql548ticta in ('TDC', 'CAC', 'FUN')
                 and j.jaql548estado <> '06'
              union all
              select sum(j.jaql548salac) salac
                from jaql548 j
               where j.jaql546serial = P_N_SERIAL
                 and j.jaql548tidet = '15' -- tarjetaCredito
                 and j.jaql548indbo = '0'
                 and j.jaql548estado <> '06') t;
    
    exception
      when others then
        p_n_salfnr := 0;
    end;
  
    begin
      -- Sector Empresarial
      select sum(j.jaql548salac)
        into p_n_salemp
        from jaql548 j
       where j.jaql546serial = P_N_SERIAL
         and j.jaql548tidet = '18' -- cuentaCartera
         and j.jaql548indbo = '0'
         and j.jaql548ticta in ('SFI', 'CSP', 'CMZ')
         and j.jaql548estado <> '06';
    
    exception
      when others then
        p_n_salemp := 0;
    end;
  
    begin
      -- Sector Telcos
      select sum(j.jaql548salac)
        into p_n_saltel
        from jaql548 j
       where j.jaql546serial = P_N_SERIAL
         and j.jaql548tidet = '18' -- cuentaCartera
         and j.jaql548indbo = '0'
         and j.jaql548ticta in ('CTC', 'CDC')
         and j.jaql548estado not in ('06', '52'); -- Por homologar Experian Web: No se muestran deudas con 52=mora < 180 dias, 06=canceladas 
    
    exception
      when others then
        p_n_saltel := 0;
    end;
  
  END sp_cr_fecha_saldo_sector;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_cr_importacion_exportacion(P_N_SERIAL  IN NUMBER,
                                          P_N_SERIAL2 IN NUMBER,
                                          P_C_USUARIO IN VARCHAR2,
                                          P_C_MAQUINA IN VARCHAR2) IS
    cursor c_imp_exp is
      select jaql546serial,
             anio,
             sum(num_op_imp) as num_op_imp,
             sum(totfob_imp) as totfob_imp,
             sum(fob_flet_imp) as fob_flet_imp,
             sum(cant_pai_imp) as cant_pai_imp,
             sum(num_op_exp) as num_op_exp,
             sum(totfob_exp) as totfob_exp,
             sum(cant_pai_exp) as cant_pai_exp
        from (select jaql546serial,
                     anio,
                     sum(num_op_imp) as num_op_imp,
                     sum(jaql606tofob) as totfob_imp,
                     sum(jaql606fofls) as fob_flet_imp,
                     count(jaql606copao) as cant_pai_imp,
                     0 num_op_exp,
                     0 totfob_exp,
                     0 cant_pai_exp
                from (select jaql546serial,
                             EXTRACT(year FROM jaql606fepre) as anio,
                             count(*) as num_op_imp,
                             sum(jaql606tofob) as jaql606tofob,
                             sum(jaql606fofls) as jaql606fofls,
                             jaql606copao
                        from jaql606
                       where jaql546serial = P_N_SERIAL
                       group by jaql546serial,
                                EXTRACT(year FROM jaql606fepre),
                                jaql606copao)
               group by jaql546serial, anio --importaciones
              union
              select jaql546serial,
                     anio,
                     0 num_op_imp,
                     0 totfob_imp,
                     0 fob_flet_imp,
                     0 cant_pai_imp,
                     sum(num_op_exp) num_op_exp,
                     sum(jaql607tofob) as totfob_exp,
                     count(jaql607copao) as cant_pai_exp
                from (select jaql546serial,
                             EXTRACT(year FROM jaql607feexp) as anio,
                             count(*) as num_op_exp,
                             sum(jaql607tofob) as jaql607tofob,
                             jaql607copao
                        from jaql607
                       where jaql546serial = P_N_SERIAL
                       group by jaql546serial,
                                EXTRACT(year FROM jaql607feexp),
                                jaql607copao)
               group by jaql546serial, anio -- exportaciones
              )
       group by jaql546serial, anio
       order by anio desc;
  
    cursor c_imp_exp2 is
      select jaql546serial,
             ANIO,
             sum(JAQL606TOFOB) totfob_imp,
             sum(JAQL606FOFLS) fob_flet_imp,
             sum(JAQL606NUOPE) num_op_imp,
             sum(JAQL606NPAI) cant_pai_imp,
             sum(JAQL607NUOPE) num_op_exp,
             sum(JAQL607TOFOB) totfob_exp,
             sum(JAQL607NPAI) cant_pai_exp
        from (select jaql546serial,
                     EXTRACT(YEAR FROM JAQL606FEPRE) ANIO,
                     sum(JAQL606TOFOB) JAQL606TOFOB,
                     sum(JAQL606FOFLS) JAQL606FOFLS,
                     sum(JAQL606NUOPE) JAQL606NUOPE,
                     sum(JAQL606NPAI) JAQL606NPAI,
                     0 JAQL607NUOPE,
                     0 JAQL607TOFOB,
                     0 JAQL607NPAI
                from jaql606
               where jaql546serial = P_N_SERIAL2
               group by jaql546serial, EXTRACT(YEAR FROM JAQL606FEPRE)
              union
              select jaql546serial,
                     EXTRACT(YEAR FROM JAQL607FEEXP) ANIO,
                     0 JAQL606TOFOB,
                     0 JAQL606FOFLS,
                     0 JAQL606NUOPE,
                     0 JAQL606NPAI,
                     sum(JAQL607NUOPE) JAQL607NUOPE,
                     sum(JAQL607TOFOB) JAQL607TOFOB,
                     sum(JAQL607NPAI) JAQL607NPAI
                from jaql607
               where jaql546serial = P_N_SERIAL2
               group by jaql546serial, EXTRACT(YEAR FROM JAQL607FEEXP))
       group by jaql546serial, ANIO
       order by anio desc;
  
    ln_tipo jaqy173.jaqy173tip%type;
    ln_corr jaqy173.jaqy173nro%type;
    V_ANIO  VARCHAR2(4);
  
  BEGIN
    ln_tipo := 5;
    ln_corr := 0;
  
    delete from JAQY173
     where jaqy173usu = P_C_USUARIO
       and jaqy173maq = P_C_MAQUINA
       and jaqy173tip = ln_tipo;
    commit;
  
    IF P_N_SERIAL <> 0 THEN
      --ANTIGUO EXPERIAN
      for de in c_imp_exp loop
        ln_corr := ln_corr + 1;
        begin
          insert into JAQY173
            (jaqy173usu,
             jaqy173maq,
             jaqy173tip,
             jaqy173nro,
             JAQY173num1,
             JAQY173num2,
             JAQY173num3,
             JAQY173num4,
             JAQY173num5,
             JAQY173num6,
             JAQY173num7,
             JAQY173num8)
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
             de.cant_pai_exp);
          commit;
        exception
          when others then
            null;
        end;
      end loop;
    ELSE
      --NUEVO EXPERIAN      
      for de in c_imp_exp2 loop
        ln_corr := ln_corr + 1;
        begin
          insert into JAQY173
            (jaqy173usu,
             jaqy173maq,
             jaqy173tip,
             jaqy173nro,
             JAQY173num1,
             JAQY173num2,
             JAQY173num3,
             JAQY173num4,
             JAQY173num5,
             JAQY173num6,
             JAQY173num7,
             JAQY173num8)
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
             de.cant_pai_exp);
          commit;
        exception
          when others then
            null;
        end;
      end loop;
    END IF;
  
  END sp_cr_importacion_exportacion;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  /*PROCEDURE sp_cr_AFP( P_N_SERIAL IN NUMBER, 
                       P_C_USUARIO IN VARCHAR2, P_C_MAQUINA IN VARCHAR2)
  IS     
  cursor c_imp_exp is 
      select jaql546serial,
             jaql608pedev,
             sum(jaql608mtodf_J) as deudafondoJ,
             sum(jaql608mtoda_J) as deudaafpJ,
             sum(jaql608mtodf_DF) as deudafondoDF,
             sum(jaql608mtoda_DF) as deudaafpDF,
             sum(cant_J) as cant_deujud,
             sum(cant_DF) as cant_deuadm,
             tipdeu
        from (select jaql546serial,
                     jaql608pedev,
                     jaql608mtodf as jaql608mtodf_J,
                     jaql608mtoda as jaql608mtoda_J,
                     count(*) as cant_J,
                     0 as jaql608mtodf_DF,
                     0 as jaql608mtoda_DF,
                     0 as cant_DF,
                     decode(jaql608tipde, 3, 'CIERTA', 'DECLARACION S/PAGO') as tipdeu--deuda=3 PRESUNTA ;deuda=1/2 CIERTA
                from jaql608
               where jaql546serial =P_N_SERIAL
                 and jaql608indde = 'J'
               group by jaql546serial,
                        jaql608pedev,
                        jaql608mtodf,
                        jaql608mtoda,
                        decode(jaql608tipde, 3, 'CIERTA', 'DECLARACION S/PAGO')
              union
              select jaql546serial,
                     jaql608pedev,
                     0 as jaql608mtodf_J,
                     0 as jaql608mtoda_J,
                     0 as cant_J,
                     jaql608mtodf as jaql608mtodf_DF,
                     jaql608mtoda as jaql608mtoda_DF,
                     count(*) as cant_DF,
                     decode(jaql608tipde, 3, 'CIERTA', 'DECLARACION S/PAGO')
                from jaql608
               where jaql546serial = P_N_SERIAL
                 and jaql608indde <> 'J'
               group by jaql546serial,
                        jaql608pedev,
                        jaql608mtodf,
                        jaql608mtoda,
                        decode(jaql608tipde, 3, 'CIERTA', 'DECLARACION S/PAGO'))
       group by jaql546serial, jaql608pedev, tipdeu
       order by jaql608pedev desc; -- AFP
      
      ln_tipo jaqy173.jaqy173tip%type; 
       ln_corr jaqy173.jaqy173nro%type;                     
  BEGIN
  ln_tipo:=6;
  ln_corr:=0;
  
      delete from JAQY173
    where jaqy173usu = P_C_USUARIO
      and jaqy173maq = P_C_MAQUINA
      and jaqy173tip = ln_tipo;     
     commit;
     
     
   for afp in c_imp_exp loop    
           
              ln_corr := ln_corr + 1;
               insert into JAQY173 
                  (jaqy173usu,
                   jaqy173maq,
                   jaqy173tip,
                   jaqy173nro,
                   JAQY173fec1,
                   JAQY173num1,
                   JAQY173num2,
                   JAQY173num3,
                   JAQY173num4,
                   JAQY173num5,
                   JAQY173num6,
                   JAQY173txt1
                   )  
               values
                  (P_C_USUARIO,
                   P_C_MAQUINA,
                   ln_tipo,
                   ln_corr,
                   afp.jaql608pedev,
                   afp.deudafondoJ,--fondo judicial
                   afp.deudaafpJ,--afp jud
                   afp.deudafondoDF,--fondo adm
                   afp.deudaafpDF,--afp adm
                   afp.cant_deujud,--cant deuda jud
                   afp.cant_deuadm,--cant deuda adm
                   afp.tipdeu
                    );    
               COMMIT;                              
           end loop;
                                                 
  END sp_cr_AFP;  */
  --APACHECO 

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  PROCEDURE sp_cr_fecha_mora_max(P_N_SERIAL IN NUMBER,
                                 P_V_ENTID  IN VARCHAR2,
                                 P_N_SECUE  IN NUMBER,
                                 P_C_FECHA  OUT VARCHAR2,
                                 P_D_FECMOR OUT DATE) IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_fecha_mora_max
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 12/12/2023
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : CALCULA LA FECHA EN LA QUE OCURRIÓ LA MORA MÁXIMA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_N_SERIAL ( IDENTIFICADOR CONSULTA )
    --                              P_V_ENTID ( ENTIDAD ) 
    --                              P_N_SECUE ( SECUENCIAL ) 
    -- Parámetros de Salida       : P_C_FECHA ( fecha varchar de maxima mora )
    --                            : P_D_FECMOR ( fecha de maxima mora )
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
    ln_maximora number(5) := 0;
    ld_maximora date;
  BEGIN
    BEGIN
      SELECT JAQL548MAXMO, JAQL548FMXMOR
        INTO ln_maximora, ld_maximora
        FROM JAQL548
       WHERE JAQL546SERIAL = P_N_SERIAL
         AND JAQL548SECUE = P_N_SECUE;
    EXCEPTION
      WHEN OTHERS THEN
        ld_maximora := to_date('01/01/0001', 'DD/MM/YYYY');
    END;
    P_C_FECHA  := to_char(ld_maximora,
                          'MON-RRRR',
                          'NLS_DATE_LANGUAGE = Spanish');
    P_D_FECMOR := ld_maximora;
  
  END sp_cr_fecha_mora_max;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  PROCEDURE sp_cr_actualizar_deuda_trib(P_N_SERIAL IN NUMBER) IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_actualizar_deuda_trib
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 30/05/2024
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : ACTUALIZAR REGISTRO FINAL EN LA JAQL604
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_N_SERIAL ( IDENTIFICADOR CONSULTA )
    -- Parámetros de Salida       : 
    -- ***************************************************************** 
    V_JAQL604SECUE  NUMBER(10) := 0;
    V_JAQL604MTODE  NUMBER(17, 2);
    V_JAQL604FENUA  DATE;
    V_JAQL604FEINP  DATE;
    V_JAQL604DVEN   NUMBER(10);
    V_JAQL604TIDET  VARCHAR2(10);
    V_JAQL604DESCR  VARCHAR2(100);
    V_JAQL604CONCOD VARCHAR2(16);
    V_JAQL604CREUSR VARCHAR2(30);
    V_JAQL604CRETIM TIMESTAMP(6);
  
    lv_err VARCHAR2(2000);
  
    CURSOR ENTIDADES IS
      SELECT JAQL604ENTID,
             MAX(JAQL604PERIO) JAQL604PERIO1,
             MIN(JAQL604PERIO) JAQL604PERIO2
        FROM JAQL604
       WHERE JAQL546SERIAL = P_N_SERIAL
       GROUP BY JAQL604ENTID;
  
  BEGIN
    FOR I IN ENTIDADES LOOP
      --Obtener datos de la ultima fecha reportada
      BEGIN
        SELECT JAQL604MTODE,
               JAQL604FENUA,
               JAQL604TIDET,
               JAQL604DVEN,
               JAQL604CONCOD,
               JAQL604CREUSR,
               JAQL604CRETIM,
               JAQL604DESCR
          INTO V_JAQL604MTODE,
               V_JAQL604FENUA,
               V_JAQL604TIDET,
               V_JAQL604DVEN,
               V_JAQL604CONCOD,
               V_JAQL604CREUSR,
               V_JAQL604CRETIM,
               V_JAQL604DESCR
          FROM JAQL604
         WHERE JAQL546SERIAL = P_N_SERIAL
           AND JAQL604ENTID = I.JAQL604ENTID
           AND JAQL604PERIO = I.JAQL604PERIO1;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      --Obtener el secuencial maximo siguiente
      BEGIN
        SELECT MAX(JAQL604SECUE) + 1
          INTO V_JAQL604SECUE
          FROM JAQL604
         WHERE JAQL546SERIAL = P_N_SERIAL;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      --Obtener fecha de inicio de cobranza
      BEGIN
        SELECT TO_DATE(SUBSTR(I.JAQL604PERIO2, 1, 4) ||
                       SUBSTR(TO_CHAR(I.JAQL604PERIO2), 5, 2) || '01',
                       'YYYYMMDD')
          INTO V_JAQL604FEINP
          FROM DUAL;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      --Insercion casi final         
      BEGIN
        INSERT INTO JAQL604
          (JAQL546SERIAL,
           JAQL604SECUE,
           JAQL604MTODE,
           JAQL604PERIO,
           JAQL604FEINP,
           JAQL604ENTID,
           JAQL604FENUA,
           JAQL604TIDET,
           JAQL604DVEN,
           JAQL604CONCOD,
           JAQL604CREUSR,
           JAQL604CRETIM,
           JAQL604DESCR,
           JAQL604AUX1)
        VALUES
          (P_N_SERIAL,
           V_JAQL604SECUE,
           V_JAQL604MTODE,
           I.JAQL604PERIO1,
           V_JAQL604FEINP,
           I.JAQL604ENTID,
           V_JAQL604FENUA,
           V_JAQL604TIDET,
           V_JAQL604DVEN,
           V_JAQL604CONCOD,
           V_JAQL604CREUSR,
           V_JAQL604CRETIM,
           V_JAQL604DESCR,
           999);
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          lv_err := SQLERRM;
          DBMS_OUTPUT.put_line('Error al insertar: ' || lv_err);
      END;
    END LOOP;
  
  END sp_cr_actualizar_deuda_trib;

  PROCEDURE sp_cr_actualizar_mora(P_N_SERIAL IN NUMBER) IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_actualizar_mora
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 11/12/2023
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : ACTUALIZAR LA EDAD MORA Y MAXIMA MORA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_N_SERIAL ( IDENTIFICADOR CONSULTA )
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- ***************************************************************** 
    ln_edadmora     number(5);
    ln_maximora     number(5);
    lc_edmora       varchar2(5);
    lc_estado       varchar2(5);
    lc_compor       varchar2(50);
    ln_cont         number(5);
    ln_atraso       number(5);
    lc_atraso       varchar2(10);
    ld_maxFecha     date;
    ld_maxFechaU    date;
    V_JAQL548COMPOR VARCHAR2(50);
    V_JAQL548ESTADO VARCHAR2(2);
    V_JAQL548FECVE  DATE;
    V_JAQL548FECAP  DATE;
    V_JAQL548ULTAC  DATE;
    V_JAQL548EMORA  VARCHAR2(3);
    V_JAQL548SALMO  NUMERIC(17, 2);
    V_JAQL548CUOTA  NUMERIC(17, 2);
    V_JAQL548VALIN  NUMERIC(17, 2);
    V_JAQL548CUOCA  NUMERIC(17, 2);
    V_JAQL548TOCUO  NUMERIC(17, 2);
    V_JAQL548CODSU  VARCHAR2(10);
    V_JAQL548INDBO  VARCHAR2(3);
    V_JAQL548MAXMO  NUMERIC(10, 2);
    V_JAQL548FMXMOR DATE;
    V_JAQL548SALAC  NUMERIC(10, 2);
    V_JAQL548CUPO   NUMERIC(10, 2);
    V_JAQL548CONCOD VARCHAR2(16);
    V_JAQL548CREUSR VARCHAR2(30);
    V_JAQL548CRETIM TIMESTAMP(6);
    V_JAQL548AMPAR  VARCHAR2(30);
    V_JAQL548MONED  VARCHAR2(10);
    lv_err          VARCHAR2(2000);
    V_JAQL548TICTA  VARCHAR2(10);
    V_JAQL548SECUE  NUMBER(10);
    V_JAQL548REGU   VARCHAR2(2);
  
    CURSOR ENTIDADES IS
      SELECT DISTINCT A.JAQL548ENTID,
                      A.JAQL548FECVE,
                      T.JAQL548ULTAC,
                      A.JAQL548MAXMO
        FROM JAQL548 A
       INNER JOIN (SELECT JAQL548ENTID, MAX(JAQL548ULTAC) JAQL548ULTAC
                     FROM JAQL548
                    WHERE JAQL546SERIAL = P_N_SERIAL
                      AND JAQL548INDBO = '0'
                    GROUP BY JAQL548ENTID) T
          ON A.JAQL548ENTID = T.JAQL548ENTID
         AND A.JAQL548ULTAC = T.JAQL548ULTAC
       WHERE A.JAQL546SERIAL = P_N_SERIAL
         AND A.JAQL548INDBO = '0';
  
    /*CURSOR ENTIDADES_2 IS
    SELECT JAQL548ENTID, MAX(JAQL548ULTAC) JAQL548ULTAC
      FROM JAQL548
     WHERE JAQL546SERIAL = P_N_SERIAL
       AND JAQL548INDBO = '7'
       AND JAQL548NUMER = '998'
     GROUP BY JAQL548ENTID
     ORDER BY JAQL548ENTID;*/
  
  BEGIN
    --OBTENER MAXIMA FECHA REPORTADA         
    BEGIN
      SELECT MAX(JAQL548ULTAC)
        INTO ld_maxFecha
        FROM JAQL548
       WHERE JAQL546SERIAL = P_N_SERIAL;
    EXCEPTION
      WHEN OTHERS THEN
        ld_maxFecha := TO_DATE('01/01/0001', 'dd/MM/yyyy');
    END;
    --Ultima fecha de proceso
    BEGIN
      SELECT TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM')
        INTO ld_maxFechaU
        FROM dual;
    EXCEPTION
      WHEN OTHERS THEN
        ld_maxFechaU := TO_DATE('01/01/0001', 'dd/MM/yyyy');
    END;
  
    --ITERACIÓN DE ENTIDADES NO REGULADAS ADICIONALES
    FOR I IN ENTIDADES LOOP
      ln_edadmora := 0;
      ln_atraso   := 0;
      ln_cont     := 0;
      lc_atraso   := '';
      lc_estado   := '17';
      lc_compor   := '';
      BEGIN
        --Dias de atraso a la ultima fecha reportada
        SELECT I.JAQL548ULTAC - I.JAQL548FECVE INTO ln_edadmora FROM DUAL;
        --Estado de la mora maxima
        IF ln_edadmora >= 0 AND ln_edadmora < 30 THEN
          lc_estado := '01';
        ELSIF ln_edadmora >= 30 AND ln_edadmora < 60 THEN
          lc_estado := '17';
        ELSIF ln_edadmora >= 60 AND ln_edadmora < 90 THEN
          lc_estado := '18';
        ELSIF ln_edadmora >= 90 AND ln_edadmora < 120 THEN
          lc_estado := '19';
        ELSE
          lc_estado := '20';
        END IF;
        V_JAQL548MAXMO  := ln_edadmora;
        V_JAQL548FMXMOR := I.JAQL548ULTAC;
        /*IF I.JAQL548AMPAR = 'CARTCAST' AND ln_edadmora < 120 THEN
           lc_estado := '45';
        END IF;*/
        --Calcular el comportamiento de la deuda   
        FOR E IN 0 .. ABS(TRUNC(MONTHS_BETWEEN(I.JAQL548FECVE, I.JAQL548ULTAC))) LOOP
          ln_cont := ln_cont + 1;
          /*SELECT ADD_MONTHS(I.JAQL548ULTAC, -E) - I.JAQL548FECVE
            INTO ln_atraso
          FROM DUAL;*/
          ln_atraso := I.JAQL548MAXMO;
          IF ln_atraso >= 0 AND ln_atraso < 30 THEN
            lc_atraso := 'N';
          ELSIF ln_atraso >= 30 AND ln_atraso < 60 THEN
            lc_atraso := '1';
          ELSIF ln_atraso >= 60 AND ln_atraso < 90 THEN
            lc_atraso := '2';
          ELSIF ln_atraso >= 90 AND ln_atraso < 120 THEN
            lc_atraso := '3';
          ELSIF ln_atraso >= 120 AND ln_atraso < 150 THEN
            lc_atraso := '4';
          ELSIF ln_atraso >= 150 AND ln_atraso < 180 THEN
            lc_atraso := 'J';
          ELSE
            lc_atraso := 'J';
          END IF;
          IF ln_cont = 0 THEN
            --Estado de la ultima mora 
            IF ln_edadmora >= 0 AND ln_edadmora < 30 THEN
              lc_estado := '01';
            ELSIF ln_edadmora >= 30 AND ln_edadmora < 60 THEN
              lc_estado := '17';
            ELSIF ln_edadmora >= 60 AND ln_edadmora < 90 THEN
              lc_estado := '18';
            ELSIF ln_edadmora >= 90 AND ln_edadmora < 120 THEN
              lc_estado := '19';
            ELSE
              lc_estado := '20';
            END IF;
          END IF;
          /*IF I.JAQL548AMPAR = 'PER' THEN
             lc_atraso := 'J';
          END IF;*/
          IF ln_cont < 30 THEN
            lc_compor := concat(lc_compor, lc_atraso);
          END IF;
        END LOOP;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      V_JAQL548COMPOR := lc_compor;
      --V_JAQL548ESTADO := '01';
      V_JAQL548CODSU := ' ';
      V_JAQL548EMORA := '000';
      V_JAQL548SALAC := 0.00;
      V_JAQL548CUPO  := 0.00;
      V_JAQL548AMPAR := '';
      V_JAQL548TICTA := '';
      V_JAQL548REGU  := 'NR';
    
      --Buscar datos de la entidad 
      BEGIN
        SELECT JAQL548SALAC,
               JAQL548TICTA,
               JAQL548REGU,
               JAQL548EMORA,
               JAQL548AMPAR,
               JAQL548SALMO,
               JAQL548CUOTA,
               JAQL548VALIN,
               JAQL548CUOCA,
               JAQL548TOCUO,
               JAQL548CONCOD,
               JAQL548CREUSR,
               JAQL548CRETIM
          INTO V_JAQL548SALAC,
               V_JAQL548TICTA,
               V_JAQL548REGU,
               V_JAQL548EMORA,
               V_JAQL548AMPAR,
               V_JAQL548SALMO,
               V_JAQL548CUOTA,
               V_JAQL548VALIN,
               V_JAQL548CUOCA,
               V_JAQL548TOCUO,
               V_JAQL548CONCOD,
               V_JAQL548CREUSR,
               V_JAQL548CRETIM
          FROM JAQL548
         WHERE JAQL546SERIAL = P_N_SERIAL
           AND JAQL548ENTID = I.JAQL548ENTID
           AND JAQL548ULTAC = I.JAQL548ULTAC
           AND JAQL548FECVE = I.JAQL548FECVE
           AND JAQL548INDBO = '0'
           AND ROWNUM = 1;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
          /*DBMS_OUTPUT.put_line('No se encontro datos: ' || I.JAQL548ENTID);
          DBMS_OUTPUT.put_line('No se encontro datos: ' || I.JAQL548ULTAC);
          DBMS_OUTPUT.put_line('No se encontro datos: ' || I.JAQL548FECVE);*/
      END;
      IF V_JAQL548TICTA = 'OTR' THEN
        BEGIN
          SELECT AQPB908DTICTA
            INTO V_JAQL548TICTA
            FROM AQPB908D
           WHERE AQPB908DBURO = 2
             AND AQPB908DENTID = TRIM(I.JAQL548ENTID)
             AND ROWNUM = 1;
        EXCEPTION
          WHEN OTHERS THEN
            V_JAQL548TICTA := 'OTR';
        END;
      END IF;
      --Hallar Maxima Mora y Fecha Maxima Mora
      BEGIN
        SELECT JAQL548ULTAC, JAQL548MAXMO
          INTO V_JAQL548FMXMOR, V_JAQL548MAXMO
          FROM JAQL548
         WHERE JAQL546SERIAL = P_N_SERIAL
           AND JAQL548ENTID = I.JAQL548ENTID
           AND JAQL548MAXMO = (SELECT MAX(JAQL548MAXMO)
                                 FROM JAQL548
                                WHERE JAQL546SERIAL = P_N_SERIAL
                                  AND JAQL548ENTID = I.JAQL548ENTID
                                  AND JAQL548INDBO = '0')
           AND JAQL548INDBO = '0';
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      BEGIN
        --Hallar el estado de la deuda
        IF ld_maxFecha = I.JAQL548ULTAC THEN
          V_JAQL548ESTADO := lc_estado;
        ELSE
          V_JAQL548ESTADO := '06';
        END IF;
        --Obtener el secuencial maximo siguiente
        BEGIN
          SELECT MAX(JAQL548SECUE) + 1
            INTO V_JAQL548SECUE
            FROM JAQL548
           WHERE JAQL546SERIAL = P_N_SERIAL;
          V_JAQL548CODSU := TO_CHAR(V_JAQL548SECUE);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      
        --Insercion casi final         
        BEGIN
          INSERT INTO JAQL548
            (JAQL546SERIAL,
             JAQL548CODSU,
             JAQL548ULTAC,
             JAQL548SECUE,
             JAQL548NUMER,
             JAQL548ENTID,
             JAQL548ESTADO,
             JAQL548FECVE,
             JAQL548COMPOR,
             JAQL548EMORA,
             JAQL548TICTA,
             JAQL548INDBO,
             JAQL548SALAC,
             JAQL548CUPO,
             JAQL548TIDET,
             JAQL548CONCOD,
             JAQL548CREUSR,
             JAQL548CRETIM,
             JAQL548AMPAR,
             JAQL548FECAP,
             JAQL548SALMO,
             JAQL548CUOTA,
             JAQL548VALIN,
             JAQL548CUOCA,
             JAQL548TOCUO,
             JAQL548REGU,
             JAQL548FMXMOR,
             JAQL548MAXMO)
          VALUES
            (P_N_SERIAL,
             V_JAQL548CODSU,
             I.JAQL548ULTAC,
             V_JAQL548SECUE,
             '998',
             I.JAQL548ENTID,
             V_JAQL548ESTADO,
             I.JAQL548FECVE,
             V_JAQL548COMPOR,
             V_JAQL548EMORA,
             V_JAQL548TICTA,
             '4', --SE MANEJARA ESTE ESTADO INTERMEDIO --apachecoh 2024.05.07
             V_JAQL548SALAC,
             0,
             '18',
             V_JAQL548CONCOD,
             V_JAQL548CREUSR,
             V_JAQL548CRETIM,
             V_JAQL548AMPAR,
             I.JAQL548FECVE,
             V_JAQL548SALMO,
             V_JAQL548CUOTA,
             V_JAQL548VALIN,
             V_JAQL548CUOCA,
             V_JAQL548TOCUO,
             V_JAQL548REGU,
             V_JAQL548FMXMOR,
             V_JAQL548MAXMO);
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            lv_err := SQLERRM;
            /*DBMS_OUTPUT.put_line('Error al insertar: ' || lv_err);
            DBMS_OUTPUT.put_line('Error al insertar: ' || I.JAQL548ENTID);
            DBMS_OUTPUT.put_line('Error al insertar: ' || I.JAQL548ULTAC);
            DBMS_OUTPUT.put_line('Error al insertar: ' || I.JAQL548FECVE);
            DBMS_OUTPUT.put_line('Error al insertar: ' || V_JAQL548SALAC);*/
        END;
      END;
    END LOOP;
    --Insercion Final
    /*FOR L IN ENTIDADES_2 LOOP
      BEGIN
        INSERT INTO JAQL548
          (JAQL546SERIAL,
           JAQL548CODSU,
           JAQL548ULTAC,
           JAQL548SECUE,
           JAQL548NUMER,
           JAQL548ENTID,
           JAQL548ESTADO,
           JAQL548FECVE,
           JAQL548COMPOR,
           JAQL548EMORA,
           JAQL548TICTA,
           JAQL548INDBO,
           JAQL548SALAC,
           JAQL548CUPO,
           JAQL548MAXMO,
           JAQL548TIDET,
           JAQL548CONCOD,
           JAQL548CREUSR,
           JAQL548CRETIM,
           JAQL548AMPAR,
           JAQL548FECAP)
          SELECT JAQL546SERIAL,
                 JAQL548CODSU,
                 JAQL548ULTAC,
                 JAQL548SECUE,
                 '999',
                 JAQL548ENTID,
                 JAQL548ESTADO,
                 JAQL548FECVE,
                 JAQL548COMPOR,
                 JAQL548EMORA,
                 JAQL548TICTA,
                 '4',
                 JAQL548SALAC,
                 JAQL548CUPO,
                 JAQL548MAXMO,
                 JAQL548TIDET,
                 JAQL548CONCOD,
                 JAQL548CREUSR,
                 JAQL548CRETIM,
                 JAQL548AMPAR,
                 JAQL548FECAP
            FROM JAQL548
           WHERE JAQL546SERIAL = P_N_SERIAL
             AND JAQL548ENTID = L.JAQL548ENTID
             AND JAQL548ULTAC = L.JAQL548ULTAC
             AND JAQL548INDBO = '7'
             AND JAQL548NUMER = '998';
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END LOOP;*/
  END sp_cr_actualizar_mora;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_cr_actualizar_mora_reg(P_N_SERIAL IN NUMBER) IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_actualizar_mora_reg
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 07/12/2023
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : ACTUALIZAR LA EDAD MORA Y MAXIMA MORA JAQL547
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_N_SERIAL( IDENTIFICADOR CONSULTA )
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- ***************************************************************** 
    ln_edadmora     number(5);
    ln_maximora     number(5);
    lc_estado       varchar2(5);
    lc_compor       varchar2(50);
    lc_condic       varchar2(50);
    ln_cont         number(5);
    ln_atraso       number(5);
    lc_atraso       varchar2(10);
    ld_maxFecha     date;
    ld_maxFechaU    date;
    ld_minFecha     date;
    ld_maxfecALL    date;
    ln_flagEst      number(3);
    ln_flagRCC      number(2);
    V_JAQL548COMPOR VARCHAR2(50);
    V_JAQL548ESTADO VARCHAR2(2);
    V_JAQL548FECVE  DATE;
    V_JAQL548FECAP  DATE;
    V_JAQL548ULTAC  DATE;
    V_JAQL548EMORA  VARCHAR2(3);
    V_JAQL548CODSU  VARCHAR2(10);
    V_JAQL548INDBO  VARCHAR2(3);
    V_JAQL548MAXMO  NUMERIC(10, 2);
    V_JAQL548FMXMOR DATE;
    V_JAQL548SALAC  NUMERIC(10, 2);
    V_JAQL548CUPO   NUMERIC(10, 2);
    V_JAQL548CONCOD VARCHAR2(16);
    V_JAQL548CREUSR VARCHAR2(30);
    V_JAQL548CRETIM TIMESTAMP(6);
    V_JAQL548AMPAR  VARCHAR2(30);
    V_JAQL548MONED  VARCHAR2(10);
    V_JAQL548TICTA  VARCHAR2(10);
    V_JAQL548SECUE  NUMBER(10);
    L_JAQL548ENTID  VARCHAR2(150);
    L_JAQL548TICTA  VARCHAR2(10);
    L_JAQL548CODCT  NUMBER(5);
    L_JAQL547COPUC  VARCHAR2(20);
    L_JAQL547EMORA  VARCHAR2(5);
    V_JAQL548REGU   VARCHAR2(2);
  
    lv_err VARCHAR2(1000);
  
    --TODOS LOS CRÉDITOS VALIDOS   
    CURSOR ENTIDADES_1 IS
      SELECT DISTINCT JAQL547NOENT, JAQL547COPUC, JAQL547DESCR
        FROM JAQL547
       WHERE JAQL546SERIAL = P_N_SERIAL
         AND ((REGEXP_LIKE(JAQL547COPUC, '^14.[1-6]') OR
             REGEXP_LIKE(JAQL547COPUC, '^71.[1-4]')) AND NOT
              REGEXP_LIKE(JAQL547COPUC,
                                                                       '^14.[1-6]..02|^14.[1-6]020601|^141[1-6]130601|^141[1-6]120601') OR
             JAQL547COPUC LIKE '81_3%') --CASTIGADOS
       ORDER BY JAQL547NOENT, JAQL547COPUC, JAQL547DESCR;
  
    CURSOR ENTIDADES_1_5(P_V_CODENT VARCHAR2, P_V_COPUC VARCHAR2) IS
      SELECT DISTINCT JAQL547NOENT,
                      JAQL547COPUC,
                      JAQL547DESCR,
                      JAQL547FEACT,
                      JAQL547FEREP,
                      JAQL547DVEN
        FROM JAQL547
       WHERE JAQL546SERIAL = P_N_SERIAL
         AND JAQL547NOENT = P_V_CODENT
         AND JAQL547COPUC = P_V_COPUC
       ORDER BY JAQL547NOENT, JAQL547FEACT DESC, JAQL547FEREP;
  
    --SALDOS TARJETAS DE CRÉDITO
    CURSOR ENTIDADES_2 IS
      SELECT DISTINCT JAQL547NOENT, JAQL547COPUC, JAQL547DESCR
        FROM JAQL547
       WHERE JAQL546SERIAL = P_N_SERIAL
         AND (REGEXP_LIKE(JAQL547copuc,
                          '^14.[1-6]0302|^14.[1-6]0202|^14.[1-6]1202|^14.[1-6]1302') OR
             REGEXP_LIKE(JAQL547COPUC,
                          '^14.[1-6]020601|^14.[1-6]130601|^14.[1-6]120601') OR
             REGEXP_LIKE(JAQL547COPUC, '^14.[1-6]0303') OR
             REGEXP_LIKE(JAQL547COPUC, '^14.[1-6]0308'))
       ORDER BY JAQL547NOENT, JAQL547COPUC, JAQL547DESCR;
  
    CURSOR ENTIDADES_3(P_D_FECHA DATE) IS
      SELECT DISTINCT JAQL547NOENT, JAQL547COPUC, JAQL547DESCR
        FROM JAQL547
       WHERE JAQL546SERIAL = P_N_SERIAL
         AND JAQL547COPUC LIKE '81_923%'
         AND JAQL547FEACT = P_D_FECHA
       ORDER BY JAQL547NOENT, JAQL547COPUC, JAQL547DESCR;
  
  BEGIN
  
    ld_maxFecha := TO_DATE('01/01/0001', 'dd/MM/yyyy');
    ln_flagRCC  := 0;
    --Obtener maxima fecha reportada         
    BEGIN
      SELECT MAX(JAQL547FEACT)
        INTO ld_maxFecha
        FROM JAQL547
       WHERE JAQL546SERIAL = P_N_SERIAL;
    EXCEPTION
      WHEN OTHERS THEN
        ld_maxFecha := TO_DATE('01/01/0001', 'dd/MM/yyyy');
    END;
    --Ultima fecha de proceso
    BEGIN
      SELECT TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM')
        INTO ld_maxFechaU
        FROM dual;
    EXCEPTION
      WHEN OTHERS THEN
        ld_maxFechaU := TO_DATE('01/01/0001', 'dd/MM/yyyy');
    END;
  
    --ITERACIÓN ENTIDADES MODULO SBS     
    FOR J IN ENTIDADES_1 LOOP
      L_JAQL547EMORA := '000';
      ln_cont        := 0;
      lc_compor      := '';
      lc_estado      := '17';
    
      FOR I IN ENTIDADES_1_5(J.JAQL547NOENT, J.JAQL547COPUC) LOOP
        ln_edadmora := 0;
        lc_atraso   := '';
        lc_condic   := '';
        BEGIN
          --Hallar los dias de mora             
          IF I.JAQL547DVEN > 730 AND I.JAQL547DVEN <= 1095 THEN
            L_JAQL547EMORA := '903';
          ELSIF I.JAQL547DVEN > 1095 AND I.JAQL547DVEN <= 1460 THEN
            L_JAQL547EMORA := '904';
          ELSIF I.JAQL547DVEN > 1460 AND I.JAQL547DVEN <= 1825 THEN
            L_JAQL547EMORA := '905';
          ELSIF I.JAQL547DVEN > 1825 THEN
            L_JAQL547EMORA := '906';
          ELSIF I.JAQL547DVEN <= 730 THEN
            L_JAQL547EMORA := LPAD(TO_CHAR(I.JAQL547DVEN), 3, '0');
          END IF;
          ln_edadmora := CAST(L_JAQL547EMORA AS INT);
          IF ln_cont = 0 THEN
            --Estado de la ultima mora 
            IF ln_edadmora >= 0 AND ln_edadmora < 30 THEN
              lc_estado := '01';
            ELSIF ln_edadmora >= 30 AND ln_edadmora < 60 THEN
              lc_estado := '17';
            ELSIF ln_edadmora >= 60 AND ln_edadmora < 90 THEN
              lc_estado := '18';
            ELSIF ln_edadmora >= 90 AND ln_edadmora < 120 THEN
              lc_estado := '19';
            ELSE
              lc_estado := '20';
            END IF;
            IF I.JAQL547DESCR LIKE '%Castigadas%' AND ln_edadmora < 120 THEN
              lc_estado := '45';
            END IF;
            /*IF I.JAQL547DESCR LIKE '%CRÉDITOS VENCIDOS%' THEN
              lc_estado := '06';
            END IF;*/
            V_JAQL548EMORA := L_JAQL547EMORA;
          END IF;
          ln_cont := ln_cont + 1;
          --Hallar el comportamiento                                
          IF ln_edadmora >= 0 AND ln_edadmora < 30 THEN
            IF I.JAQL547DESCR LIKE '%Castigadas%' THEN
              lc_atraso := 'J';
            ELSE
              lc_atraso := 'N';
            END IF;
          ELSIF ln_edadmora >= 30 AND ln_edadmora < 60 THEN
            lc_atraso := '1';
          ELSIF ln_edadmora >= 60 AND ln_edadmora < 90 THEN
            lc_atraso := '2';
          ELSIF ln_edadmora >= 90 AND ln_edadmora < 120 THEN
            lc_atraso := '3';
          ELSIF ln_edadmora >= 120 AND ln_edadmora < 150 THEN
            lc_atraso := '4';
          ELSIF ln_edadmora >= 150 AND ln_edadmora < 180 THEN
            lc_atraso := 'J';
          ELSE
            lc_atraso := 'J';
          END IF;
          IF ln_cont < 30 THEN
            lc_compor := concat(lc_compor, lc_atraso);
          END IF;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      END LOOP;
    
      V_JAQL548COMPOR := lc_compor;
      V_JAQL548ESTADO := '01';
      V_JAQL548CODSU  := ' ';
      V_JAQL548FECVE  := TO_DATE('01/01/0001', 'dd/MM/yyyy');
      V_JAQL548ULTAC  := TO_DATE('01/01/0001', 'dd/MM/yyyy');
      V_JAQL548SALAC  := 0.00;
      V_JAQL548CUPO   := 0.00;
      V_JAQL548AMPAR  := '';
      V_JAQL548TICTA  := '';
      V_JAQL548REGU   := '';
      L_JAQL548CODCT  := 0;
    
      --Buscar la mora Maxima
      BEGIN
        SELECT MAX(JAQL547DVEN), MAX(JAQL547FEACT)
          INTO V_JAQL548MAXMO, V_JAQL548FMXMOR
          FROM JAQL547
         WHERE JAQL546SERIAL = P_N_SERIAL
           AND JAQL547NOENT = J.JAQL547NOENT
           AND JAQL547COPUC = J.JAQL547COPUC;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      --Busca el tipo de cuenta cartera   
      BEGIN
        SELECT F.TP1NRO1
          INTO L_JAQL548CODCT
          FROM FST198 F
         WHERE F.TP1COD = 1
           AND F.TP1COD1 = 11171
           AND F.TP1CORR1 = 5
           AND F.TP1CORR2 = 5
           AND F.TP1CORR3 > 0
           AND F.TP1DESC = RPAD(TRIM(J.JAQL547DESCR), 30, ' ');
      EXCEPTION
        WHEN OTHERS THEN
          L_JAQL548CODCT := 0;
          /*DBMS_OUTPUT.put_line('Error al encontrar el código de cuenta cartera.');
          DBMS_OUTPUT.put_line('cta cartera: ' || J.JAQL547DESCR);*/
      END;
      BEGIN
        SELECT SUBSTR(TP1DESC, 1, 3)
          INTO V_JAQL548TICTA
          FROM FST198 F
         WHERE F.TP1COD = 1
           AND F.TP1COD1 = 11146
           AND F.TP1CORR1 = 1
           AND F.TP1CORR2 = 29
           AND F.TP1CORR3 > 0
           AND F.TP1CORR3 = L_JAQL548CODCT;
      EXCEPTION
        WHEN OTHERS THEN
          BEGIN
            SELECT AQPB908DTICTA
              INTO V_JAQL548TICTA
              FROM AQPB908D
             WHERE AQPB908DBURO = 2
               AND AQPB908DENTID = TRIM(J.JAQL547NOENT)
               AND ROWNUM = 1;
          EXCEPTION
            WHEN OTHERS THEN
              V_JAQL548TICTA := 'OTR';
          END;
          --DBMS_OUTPUT.put_line('Error al encontrar la descripción de cuenta cartera.');
      END;
      --Busca el periodo máximo de la entidad       
      BEGIN
        SELECT MAX(JAQL547FEACT)
          INTO V_JAQL548ULTAC
          FROM JAQL547
         WHERE JAQL546SERIAL = P_N_SERIAL
           AND JAQL547NOENT = J.JAQL547NOENT
           AND JAQL547COPUC = J.JAQL547COPUC;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
          --DBMS_OUTPUT.put_line('Error al buscar la fecha maxima.');
      END;
      --Busca el periodo mínimo de la entidad
      BEGIN
        SELECT MIN(JAQL547FEREP)
          INTO V_JAQL548FECVE
          FROM JAQL547
         WHERE JAQL546SERIAL = P_N_SERIAL
           AND JAQL547NOENT = J.JAQL547NOENT
           AND JAQL547COPUC = J.JAQL547COPUC;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
          --DBMS_OUTPUT.put_line('Error al buscar la fecha minima.');
      END;
      --Buscar datos de la entidad 
      BEGIN
        SELECT JAQL547SALDO,
               JAQL547REGU,
               JAQL547CONCOD,
               JAQL547CREUSR,
               JAQL547CRETIM
          INTO V_JAQL548SALAC,
               V_JAQL548REGU,
               V_JAQL548CONCOD,
               V_JAQL548CREUSR,
               V_JAQL548CRETIM
          FROM JAQL547
         WHERE JAQL546SERIAL = P_N_SERIAL
           AND JAQL547NOENT = J.JAQL547NOENT
           AND JAQL547COPUC = J.JAQL547COPUC
           AND JAQL547FEACT = V_JAQL548ULTAC
           AND ROWNUM = 1;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
          /*DBMS_OUTPUT.put_line('No se encontro datos: ' || J.JAQL547NOENT);
          DBMS_OUTPUT.put_line('No se encontro datos: ' || V_JAQL548FECVE);
          DBMS_OUTPUT.put_line('No se encontro datos: ' || V_JAQL548ULTAC);*/
      END;
      --Busca si es de tipo Regulada o No Regulada     
      IF V_JAQL548REGU = 'D' OR V_JAQL548REGU IS NULL THEN
        BEGIN
          SELECT AQPB908DAUX3
            INTO V_JAQL548REGU
            FROM AQPB908D
           WHERE AQPB908DBURO = 1
             AND AQPB908DENTID = TRIM(J.JAQL547NOENT)
             AND ROWNUM = 1;
        EXCEPTION
          WHEN OTHERS THEN
            V_JAQL548REGU := 'NR';
        END;
      END IF;
      BEGIN
        --Hallar el estado de la deuda
        IF ld_maxFechaU <= V_JAQL548ULTAC THEN
          V_JAQL548ESTADO := lc_estado;
        ELSE
          V_JAQL548ESTADO := '06';
        END IF;
        --Obtener el secuencial maximo siguiente
        BEGIN
          SELECT MAX(JAQL548SECUE) + 1
            INTO V_JAQL548SECUE
            FROM JAQL548
           WHERE JAQL546SERIAL = P_N_SERIAL;
          V_JAQL548CODSU := TO_CHAR(V_JAQL548SECUE);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        --Insercion final         
        BEGIN
          INSERT INTO JAQL548
            (JAQL546SERIAL,
             JAQL548CODSU,
             JAQL548ULTAC,
             JAQL548SECUE,
             JAQL548NUMER,
             JAQL548ENTID,
             JAQL548ESTADO,
             JAQL548FECVE,
             JAQL548COMPOR,
             JAQL548EMORA,
             JAQL548TICTA,
             JAQL548INDBO,
             JAQL548SALAC,
             JAQL548CUPO,
             JAQL548MAXMO,
             JAQL548TIDET,
             JAQL548REGU,
             JAQL548CONCOD,
             JAQL548CREUSR,
             JAQL548CRETIM,
             JAQL548AMPAR,
             JAQL548FECAP,
             JAQL548FMXMOR)
          VALUES
            (P_N_SERIAL,
             V_JAQL548CODSU,
             V_JAQL548ULTAC,
             V_JAQL548SECUE,
             '998',
             J.JAQL547NOENT,
             V_JAQL548ESTADO,
             V_JAQL548FECVE,
             V_JAQL548COMPOR,
             V_JAQL548EMORA,
             V_JAQL548TICTA,
             '3',
             V_JAQL548SALAC,
             0,
             V_JAQL548MAXMO,
             '18',
             V_JAQL548REGU,
             V_JAQL548CONCOD,
             V_JAQL548CREUSR,
             V_JAQL548CRETIM,
             V_JAQL548AMPAR,
             V_JAQL548FECVE,
             V_JAQL548FMXMOR);
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            lv_err := SQLERRM;
            /*DBMS_OUTPUT.put_line('Error al insertar: ' || lv_err);
            DBMS_OUTPUT.put_line('Error al insertar: ' || V_JAQL548ULTAC);
            DBMS_OUTPUT.put_line('Error al insertar: ' || V_JAQL548FECVE);
            DBMS_OUTPUT.put_line('Error al insertar: ' || V_JAQL548SALAC);
            DBMS_OUTPUT.put_line('Error al insertar: ' || J.JAQL547NOENT);*/
        END;
      END;
    END LOOP;
  
    --ITERACIÓN ENTIDADES TARJETAS DE CRÉDITO  
    FOR J IN ENTIDADES_2 LOOP
      L_JAQL547EMORA := '000';
      ln_cont        := 0;
      lc_compor      := '';
      lc_estado      := '17';
    
      FOR I IN ENTIDADES_1_5(J.JAQL547NOENT, J.JAQL547COPUC) LOOP
        ln_edadmora := 0;
        lc_atraso   := '';
        lc_condic   := '';
        BEGIN
          --Hallar los dias de mora             
          IF I.JAQL547DVEN > 730 AND I.JAQL547DVEN <= 1095 THEN
            L_JAQL547EMORA := '903';
          ELSIF I.JAQL547DVEN > 1095 AND I.JAQL547DVEN <= 1460 THEN
            L_JAQL547EMORA := '904';
          ELSIF I.JAQL547DVEN > 1460 AND I.JAQL547DVEN <= 1825 THEN
            L_JAQL547EMORA := '905';
          ELSIF I.JAQL547DVEN > 1825 THEN
            L_JAQL547EMORA := '906';
          ELSIF I.JAQL547DVEN <= 730 THEN
            L_JAQL547EMORA := LPAD(TO_CHAR(I.JAQL547DVEN), 3, '0');
          END IF;
          ln_edadmora := CAST(L_JAQL547EMORA AS INT);
          IF ln_cont = 0 THEN
            --Estado de la ultima mora 
            IF ln_edadmora >= 0 AND ln_edadmora < 30 THEN
              lc_estado := '01';
            ELSIF ln_edadmora >= 30 AND ln_edadmora < 60 THEN
              lc_estado := '17';
            ELSIF ln_edadmora >= 60 AND ln_edadmora < 90 THEN
              lc_estado := '18';
            ELSIF ln_edadmora >= 90 AND ln_edadmora < 120 THEN
              lc_estado := '19';
            ELSE
              lc_estado := '20';
            END IF;
            IF I.JAQL547DESCR LIKE '%Castigadas%' AND ln_edadmora < 120 THEN
              lc_estado := '45';
            END IF;
            /*IF I.JAQL547DESCR LIKE '%CRÉDITOS VENCIDOS%' THEN
              lc_estado := '06';
            END IF;*/
            V_JAQL548EMORA := L_JAQL547EMORA;
          END IF;
          ln_cont := ln_cont + 1;
          --Hallar el comportamiento                                
          IF ln_edadmora >= 0 AND ln_edadmora < 30 THEN
            IF I.JAQL547DESCR LIKE '%Castigadas%' THEN
              lc_atraso := 'J';
            ELSE
              lc_atraso := 'N';
            END IF;
          ELSIF ln_edadmora >= 30 AND ln_edadmora < 60 THEN
            lc_atraso := '1';
          ELSIF ln_edadmora >= 60 AND ln_edadmora < 90 THEN
            lc_atraso := '2';
          ELSIF ln_edadmora >= 90 AND ln_edadmora < 120 THEN
            lc_atraso := '3';
          ELSIF ln_edadmora >= 120 AND ln_edadmora < 150 THEN
            lc_atraso := '4';
          ELSIF ln_edadmora >= 150 AND ln_edadmora < 180 THEN
            lc_atraso := 'J';
          ELSE
            lc_atraso := 'J';
          END IF;
          IF ln_cont < 30 THEN
            lc_compor := concat(lc_compor, lc_atraso);
          END IF;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      END LOOP;
    
      V_JAQL548COMPOR := lc_compor;
      V_JAQL548ESTADO := '01';
      V_JAQL548CODSU  := ' ';
      V_JAQL548FECVE  := TO_DATE('01/01/0001', 'dd/MM/yyyy');
      V_JAQL548ULTAC  := TO_DATE('01/01/0001', 'dd/MM/yyyy');
      V_JAQL548SALAC  := 0.00;
      V_JAQL548CUPO   := 0.00;
      V_JAQL548AMPAR  := '';
      V_JAQL548TICTA  := '';
      L_JAQL548CODCT  := 0;
      V_JAQL548REGU   := '';
    
      --Buscar la mora Maxima
      BEGIN
        SELECT MAX(JAQL547DVEN), MAX(JAQL547FEACT)
          INTO V_JAQL548MAXMO, V_JAQL548FMXMOR
          FROM JAQL547
         WHERE JAQL546SERIAL = P_N_SERIAL
           AND JAQL547NOENT = J.JAQL547NOENT
           AND JAQL547COPUC = J.JAQL547COPUC;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      --Busca el tipo de cuenta cartera   
      BEGIN
        SELECT F.TP1NRO1
          INTO L_JAQL548CODCT
          FROM FST198 F
         WHERE F.TP1COD = 1
           AND F.TP1COD1 = 11171
           AND F.TP1CORR1 = 5
           AND F.TP1CORR2 = 5
           AND F.TP1CORR3 > 0
           AND F.TP1DESC = RPAD(TRIM(J.JAQL547DESCR), 30, ' ');
      EXCEPTION
        WHEN OTHERS THEN
          L_JAQL548CODCT := 0;
          /*DBMS_OUTPUT.put_line('Error al encontrar el código de cuenta cartera.');
          DBMS_OUTPUT.put_line('cta cartera: ' || J.JAQL547DESCR);*/
      END;
      BEGIN
        SELECT SUBSTR(TP1DESC, 1, 3)
          INTO V_JAQL548TICTA
          FROM FST198 F
         WHERE F.TP1COD = 1
           AND F.TP1COD1 = 11146
           AND F.TP1CORR1 = 1
           AND F.TP1CORR2 = 29
           AND F.TP1CORR3 > 0
           AND F.TP1CORR3 = L_JAQL548CODCT;
      EXCEPTION
        WHEN OTHERS THEN
          BEGIN
            SELECT AQPB908DTICTA
              INTO V_JAQL548TICTA
              FROM AQPB908D
             WHERE AQPB908DBURO = 2
               AND AQPB908DENTID = TRIM(J.JAQL547NOENT)
               AND ROWNUM = 1;
          EXCEPTION
            WHEN OTHERS THEN
              V_JAQL548TICTA := 'OTR';
          END;
          --DBMS_OUTPUT.put_line('Error al encontrar la descripción de cuenta cartera.');
      END;
      --Busca el periodo máximo de la entidad       
      BEGIN
        SELECT MAX(JAQL547FEACT)
          INTO V_JAQL548ULTAC
          FROM JAQL547
         WHERE JAQL546SERIAL = P_N_SERIAL
           AND JAQL547NOENT = J.JAQL547NOENT
           AND JAQL547COPUC = J.JAQL547COPUC;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
          --DBMS_OUTPUT.put_line('Error al buscar la fecha maxima.');
      END;
      --Busca el periodo mínimo de la entidad
      BEGIN
        SELECT MIN(JAQL547FEREP)
          INTO V_JAQL548FECVE
          FROM JAQL547
         WHERE JAQL546SERIAL = P_N_SERIAL
           AND JAQL547NOENT = J.JAQL547NOENT
           AND JAQL547COPUC = J.JAQL547COPUC;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
          --DBMS_OUTPUT.put_line('Error al buscar la fecha minima.');
      END;
      --Buscar datos de la entidad 
      BEGIN
        SELECT JAQL547SALDO,
               JAQL547REGU,
               JAQL547CONCOD,
               JAQL547CREUSR,
               JAQL547CRETIM
          INTO V_JAQL548SALAC,
               V_JAQL548REGU,
               V_JAQL548CONCOD,
               V_JAQL548CREUSR,
               V_JAQL548CRETIM
          FROM JAQL547
         WHERE JAQL546SERIAL = P_N_SERIAL
           AND JAQL547NOENT = J.JAQL547NOENT
           AND JAQL547COPUC = J.JAQL547COPUC
           AND JAQL547FEACT = V_JAQL548ULTAC
           AND ROWNUM = 1;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
          /*DBMS_OUTPUT.put_line('No se encontro datos: ' || J.JAQL547NOENT);
          DBMS_OUTPUT.put_line('No se encontro datos: ' || V_JAQL548FECVE);
          DBMS_OUTPUT.put_line('No se encontro datos: ' || V_JAQL548ULTAC);*/
      END;
      --Busca si es de tipo Regulada o No Regulada     
      IF V_JAQL548REGU = 'D' OR V_JAQL548REGU IS NULL THEN
        BEGIN
          SELECT AQPB908DAUX3
            INTO V_JAQL548REGU
            FROM AQPB908D
           WHERE AQPB908DBURO = 1
             AND AQPB908DENTID = TRIM(J.JAQL547NOENT)
             AND ROWNUM = 1;
        EXCEPTION
          WHEN OTHERS THEN
            V_JAQL548REGU := 'NR';
        END;
      END IF;
      BEGIN
        --Hallar el estado de la deuda
        IF ld_maxFechaU <= V_JAQL548ULTAC THEN
          V_JAQL548ESTADO := lc_estado;
        ELSE
          V_JAQL548ESTADO := '06';
        END IF;
        --Obtener el secuencial maximo siguiente
        BEGIN
          SELECT MAX(JAQL548SECUE) + 1
            INTO V_JAQL548SECUE
            FROM JAQL548
           WHERE JAQL546SERIAL = P_N_SERIAL;
          V_JAQL548CODSU := TO_CHAR(V_JAQL548SECUE);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        --Insercion final         
        BEGIN
          INSERT INTO JAQL548
            (JAQL546SERIAL,
             JAQL548CODSU,
             JAQL548ULTAC,
             JAQL548SECUE,
             JAQL548NUMER,
             JAQL548ENTID,
             JAQL548ESTADO,
             JAQL548FECVE,
             JAQL548COMPOR,
             JAQL548EMORA,
             JAQL548TICTA,
             JAQL548INDBO,
             JAQL548SALAC,
             JAQL548CUPO,
             JAQL548MAXMO,
             JAQL548TIDET,
             JAQL548REGU,
             JAQL548CONCOD,
             JAQL548CREUSR,
             JAQL548CRETIM,
             JAQL548AMPAR,
             JAQL548FECAP,
             JAQL548FMXMOR)
          VALUES
            (P_N_SERIAL,
             V_JAQL548CODSU,
             V_JAQL548ULTAC,
             V_JAQL548SECUE,
             '998',
             J.JAQL547NOENT,
             V_JAQL548ESTADO,
             V_JAQL548FECVE,
             V_JAQL548COMPOR,
             V_JAQL548EMORA,
             V_JAQL548TICTA,
             '3',
             V_JAQL548SALAC,
             0,
             V_JAQL548MAXMO,
             '15',
             V_JAQL548REGU,
             V_JAQL548CONCOD,
             V_JAQL548CREUSR,
             V_JAQL548CRETIM,
             V_JAQL548AMPAR,
             V_JAQL548FECVE,
             V_JAQL548FMXMOR);
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            lv_err := SQLERRM;
            /*DBMS_OUTPUT.put_line('Error al insertar: ' || lv_err);
            DBMS_OUTPUT.put_line('Error al insertar: ' || V_JAQL548ULTAC);
            DBMS_OUTPUT.put_line('Error al insertar: ' || V_JAQL548FECVE);
            DBMS_OUTPUT.put_line('Error al insertar: ' || V_JAQL548SALAC);
            DBMS_OUTPUT.put_line('Error al insertar: ' || J.JAQL547NOENT);*/
        END;
      END;
    END LOOP;
  
    --ITERACIÓN ENTIDADES LÍNEAS DE CRÉDITO
    FOR J IN ENTIDADES_3(ld_maxFecha) LOOP
      L_JAQL547EMORA := '000';
      ln_cont        := 0;
      lc_compor      := '';
      lc_estado      := '17';
    
      FOR I IN ENTIDADES_1_5(J.JAQL547NOENT, J.JAQL547COPUC) LOOP
        ln_edadmora := 0;
        lc_atraso   := '';
        lc_condic   := '';
        BEGIN
          --Hallar los dias de mora             
          IF I.JAQL547DVEN > 730 AND I.JAQL547DVEN <= 1095 THEN
            L_JAQL547EMORA := '903';
          ELSIF I.JAQL547DVEN > 1095 AND I.JAQL547DVEN <= 1460 THEN
            L_JAQL547EMORA := '904';
          ELSIF I.JAQL547DVEN > 1460 AND I.JAQL547DVEN <= 1825 THEN
            L_JAQL547EMORA := '905';
          ELSIF I.JAQL547DVEN > 1825 THEN
            L_JAQL547EMORA := '906';
          ELSIF I.JAQL547DVEN <= 730 THEN
            L_JAQL547EMORA := LPAD(TO_CHAR(I.JAQL547DVEN), 3, '0');
          END IF;
          ln_edadmora := CAST(L_JAQL547EMORA AS INT);
          IF ln_cont = 0 THEN
            --Estado de la ultima mora 
            IF ln_edadmora >= 0 AND ln_edadmora < 30 THEN
              lc_estado := '01';
            ELSIF ln_edadmora >= 30 AND ln_edadmora < 60 THEN
              lc_estado := '17';
            ELSIF ln_edadmora >= 60 AND ln_edadmora < 90 THEN
              lc_estado := '18';
            ELSIF ln_edadmora >= 90 AND ln_edadmora < 120 THEN
              lc_estado := '19';
            ELSE
              lc_estado := '20';
            END IF;
            IF I.JAQL547DESCR LIKE '%Castigadas%' AND ln_edadmora < 120 THEN
              lc_estado := '45';
            END IF;
            /*IF I.JAQL547DESCR LIKE '%CRÉDITOS VENCIDOS%' THEN
              lc_estado := '06';
            END IF;*/
            V_JAQL548EMORA := L_JAQL547EMORA;
          END IF;
          ln_cont := ln_cont + 1;
          --Hallar el comportamiento                                
          IF ln_edadmora >= 0 AND ln_edadmora < 30 THEN
            IF I.JAQL547DESCR LIKE '%Castigadas%' THEN
              lc_atraso := 'J';
            ELSE
              lc_atraso := 'N';
            END IF;
          ELSIF ln_edadmora >= 30 AND ln_edadmora < 60 THEN
            lc_atraso := '1';
          ELSIF ln_edadmora >= 60 AND ln_edadmora < 90 THEN
            lc_atraso := '2';
          ELSIF ln_edadmora >= 90 AND ln_edadmora < 120 THEN
            lc_atraso := '3';
          ELSIF ln_edadmora >= 120 AND ln_edadmora < 150 THEN
            lc_atraso := '4';
          ELSIF ln_edadmora >= 150 AND ln_edadmora < 180 THEN
            lc_atraso := 'J';
          ELSE
            lc_atraso := 'J';
          END IF;
          IF ln_cont < 30 THEN
            lc_compor := concat(lc_compor, lc_atraso);
          END IF;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      END LOOP;
    
      V_JAQL548COMPOR := lc_compor;
      V_JAQL548ESTADO := '01';
      V_JAQL548CODSU  := ' ';
      V_JAQL548FECVE  := TO_DATE('01/01/0001', 'dd/MM/yyyy');
      V_JAQL548ULTAC  := TO_DATE('01/01/0001', 'dd/MM/yyyy');
      V_JAQL548SALAC  := 0.00;
      V_JAQL548CUPO   := 0.00;
      V_JAQL548AMPAR  := '';
      V_JAQL548TICTA  := '';
      L_JAQL548CODCT  := 0;
      V_JAQL548REGU   := '';
    
      --Buscar la mora Maxima
      BEGIN
        SELECT MAX(JAQL547DVEN), MAX(JAQL547FEACT)
          INTO V_JAQL548MAXMO, V_JAQL548FMXMOR
          FROM JAQL547
         WHERE JAQL546SERIAL = P_N_SERIAL
           AND JAQL547NOENT = J.JAQL547NOENT
           AND JAQL547COPUC = J.JAQL547COPUC;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      --Busca el tipo de cuenta cartera   
      BEGIN
        SELECT F.TP1NRO1
          INTO L_JAQL548CODCT
          FROM FST198 F
         WHERE F.TP1COD = 1
           AND F.TP1COD1 = 11171
           AND F.TP1CORR1 = 5
           AND F.TP1CORR2 = 5
           AND F.TP1CORR3 > 0
           AND F.TP1DESC = RPAD(TRIM(J.JAQL547DESCR), 30, ' ');
      EXCEPTION
        WHEN OTHERS THEN
          L_JAQL548CODCT := 0;
          /*DBMS_OUTPUT.put_line('Error al encontrar el código de cuenta cartera.');
          DBMS_OUTPUT.put_line('cta cartera: ' || J.JAQL547DESCR);*/
      END;
      BEGIN
        SELECT SUBSTR(TP1DESC, 1, 3)
          INTO V_JAQL548TICTA
          FROM FST198 F
         WHERE F.TP1COD = 1
           AND F.TP1COD1 = 11146
           AND F.TP1CORR1 = 1
           AND F.TP1CORR2 = 29
           AND F.TP1CORR3 > 0
           AND F.TP1CORR3 = L_JAQL548CODCT;
      EXCEPTION
        WHEN OTHERS THEN
          BEGIN
            SELECT AQPB908DTICTA
              INTO V_JAQL548TICTA
              FROM AQPB908D
             WHERE AQPB908DBURO = 2
               AND AQPB908DENTID = TRIM(J.JAQL547NOENT)
               AND ROWNUM = 1;
          EXCEPTION
            WHEN OTHERS THEN
              V_JAQL548TICTA := 'OTR';
          END;
          --DBMS_OUTPUT.put_line('Error al encontrar la descripción de cuenta cartera.');
      END;
      --Busca el periodo mínimo de la entidad
      BEGIN
        SELECT MIN(JAQL547FEREP)
          INTO V_JAQL548FECVE
          FROM JAQL547
         WHERE JAQL546SERIAL = P_N_SERIAL
           AND JAQL547NOENT = J.JAQL547NOENT
           AND JAQL547COPUC = J.JAQL547COPUC;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
          --DBMS_OUTPUT.put_line('Error al buscar la fecha minima.');
      END;
      --Buscar datos de la entidad 
      BEGIN
        SELECT JAQL547REGU, JAQL547CONCOD, JAQL547CREUSR, JAQL547CRETIM
          INTO V_JAQL548REGU,
               V_JAQL548CONCOD,
               V_JAQL548CREUSR,
               V_JAQL548CRETIM
          FROM JAQL547
         WHERE JAQL546SERIAL = P_N_SERIAL
           AND JAQL547NOENT = J.JAQL547NOENT
           AND JAQL547COPUC = J.JAQL547COPUC
           AND JAQL547FEACT = ld_maxFecha;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
          /*DBMS_OUTPUT.put_line('No se encontro datos: ' || J.JAQL547NOENT);
          DBMS_OUTPUT.put_line('No se encontro datos: ' || V_JAQL548FECVE);
          DBMS_OUTPUT.put_line('No se encontro datos: ' || V_JAQL548ULTAC);*/
      END;
      --Busca si es de tipo Regulada o No Regulada     
      IF V_JAQL548REGU = 'D' OR V_JAQL548REGU IS NULL THEN
        BEGIN
          SELECT AQPB908DAUX3
            INTO V_JAQL548REGU
            FROM AQPB908D
           WHERE AQPB908DBURO = 1
             AND AQPB908DENTID = TRIM(J.JAQL547NOENT)
             AND ROWNUM = 1;
        EXCEPTION
          WHEN OTHERS THEN
            V_JAQL548REGU := 'NR';
        END;
      END IF;
      --Buscar saldo de linea de credito por entidad acorde a la tabla de RCC           
      BEGIN
        SELECT NVL(SUM(JAQL547SALDO), 0)
          INTO V_JAQL548CUPO
          FROM JAQL547
         WHERE JAQL546SERIAL = P_N_SERIAL
           AND JAQL547NOENT = J.JAQL547NOENT
           AND JAQL547COPUC = J.JAQL547COPUC
           AND JAQL547FEACT = ld_maxFecha;
      EXCEPTION
        WHEN OTHERS THEN
          V_JAQL548CUPO := 0.00;
      END;
      IF V_JAQL548CUPO <> 0 THEN
        --Existe en el modulo de SBS               
        SELECT COUNT(*)
          INTO ln_flagEst
          FROM JAQL548
         WHERE JAQL546SERIAL = P_N_SERIAL
           AND JAQL548ENTID = J.JAQL547NOENT
           AND JAQL548ULTAC = ld_maxFecha
           AND JAQL548TICTA = 'TDC'
           AND JAQL548INDBO = '3';
        IF ln_flagEst = 0 THEN
          --Obtener el secuencial maximo siguiente
          BEGIN
            SELECT MAX(JAQL548SECUE) + 1
              INTO V_JAQL548SECUE
              FROM JAQL548
             WHERE JAQL546SERIAL = P_N_SERIAL;
            V_JAQL548CODSU := TO_CHAR(V_JAQL548SECUE);
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
          --Insercion final         
          BEGIN
            INSERT INTO JAQL548
              (JAQL546SERIAL,
               JAQL548CODSU,
               JAQL548ULTAC,
               JAQL548SECUE,
               JAQL548NUMER,
               JAQL548ENTID,
               JAQL548ESTADO,
               JAQL548FECVE,
               JAQL548COMPOR,
               JAQL548EMORA,
               JAQL548TICTA,
               JAQL548INDBO,
               JAQL548SALAC,
               JAQL548CUPO,
               JAQL548MAXMO,
               JAQL548TIDET,
               JAQL548REGU,
               JAQL548CONCOD,
               JAQL548CREUSR,
               JAQL548CRETIM,
               JAQL548AMPAR,
               JAQL548FECAP,
               JAQL548FMXMOR)
            VALUES
              (P_N_SERIAL,
               V_JAQL548CODSU,
               ld_maxFecha,
               V_JAQL548SECUE,
               '998',
               J.JAQL547NOENT,
               V_JAQL548ESTADO,
               V_JAQL548FECVE,
               V_JAQL548COMPOR,
               V_JAQL548EMORA,
               V_JAQL548TICTA,
               '3',
               0,
               V_JAQL548CUPO,
               V_JAQL548MAXMO,
               '15',
               V_JAQL548REGU,
               V_JAQL548CONCOD,
               V_JAQL548CREUSR,
               V_JAQL548CRETIM,
               V_JAQL548AMPAR,
               V_JAQL548FECVE,
               V_JAQL548FMXMOR);
            COMMIT;
          EXCEPTION
            WHEN OTHERS THEN
              lv_err := SQLERRM;
              /*DBMS_OUTPUT.put_line('Error al insertar: ' || lv_err);
              DBMS_OUTPUT.put_line('Error al insertar: ' || V_JAQL548ULTAC);
              DBMS_OUTPUT.put_line('Error al insertar: ' || V_JAQL548FECVE);
              DBMS_OUTPUT.put_line('Error al insertar: ' || V_JAQL548CUPO);
              DBMS_OUTPUT.put_line('Error al insertar: ' || J.JAQL547NOENT);*/
          END;
        ELSE
          BEGIN
            UPDATE JAQL548
               SET JAQL548CUPO = V_JAQL548CUPO
             WHERE JAQL546SERIAL = P_N_SERIAL
               AND JAQL548ENTID = J.JAQL547NOENT
               AND JAQL548INDBO = '3'
               AND JAQL548TICTA = 'TDC'
               AND JAQL548NUMER = '998'
               AND JAQL548ULTAC = ld_maxFecha;
          EXCEPTION
            WHEN OTHERS THEN
              lv_err := SQLERRM;
          END;
        END IF;
      END IF;
    END LOOP;
  
  END sp_cr_actualizar_mora_reg;
  -----------------------------------------------------------------------------------------  

end PQ_CR_EXPERIAN;
/
