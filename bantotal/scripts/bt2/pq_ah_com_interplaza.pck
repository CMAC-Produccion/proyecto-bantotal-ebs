CREATE OR REPLACE PACKAGE PQ_AH_COM_INTERPLAZA IS
    -- *********************************************************************************
    -- Nombre                     : FUNCIONES PARA COBRO DE COMISIONES INTERPLAZAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : PASIVAS
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.06.24
    -- Autor de Creación          : SMARQUEZ
    -- Uso                        : VERIFICACIONES Y COBRO DE COMISION
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 24/06/2014
    -- *********************************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_ah_verif_tablas16(ln_cuenta in number,
                                 ln_scsuc  in number,
                                 ln_modulo in number,
                                 ln_opera  in number,--
                                 ln_tipo   in number,--
                                 ln_moneda in number,--
                                 ln_subope in number,--
                                 ln_trans  in number,
                                 ln_rel    in number,
                                 ld_fecha  in date,
                                 ln_pitsuc in number,
                                 ln_pitmod in number,
                                 ln_pitord in number,
                                 ln_pitsbor in number,
                                 ln_monto  in number,
                                 ln_canal  in number,
                                 ln_plaza1 in number,
                                 ln_plaza2 in number,
                                 lc_rpta   out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- --
  function fn_ah_verif_monto(monto   in number,
                             moneda  in number,
                             fecha   in date,
                             moncol  in number,
                             tipoper in number) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- --
  function fn_ah_verif_nroope(ope in number) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- --

  Function fn_monto_comision(ln_cuenta in number,-- datos de la cuenta
                             ln_scsuc  in number,--
                             ln_modulo in number,--
                             ln_opera  in number,--
                             ln_tipo   in number,--
                             ln_moneda in number,--
                             ln_subope in number, --datos de la cuenta
                             ld_fecfin in date,
                             ln_canal  in number,
                             ln_monto  in number
                            ) return number;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- --

  Function fn_valida_cobrocom(ln_cuenta in number,-- datos de la cuenta
                              ln_scsuc  in number,--
                              ln_modulo in number,--
                              ln_opera  in number,--
                              ln_tipo   in number,--
                              ln_moneda in number,--
                              ln_subope in number, --datos de la cuenta
                              ld_fecfin in date,
                              ln_canal  in number
                             )return varchar2;

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- --
  Function fn_ah_ind_data return varchar2;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- --
  Procedure sp_ah_calcula_comision(P_N_PGCOD  IN NUMBER,
                                   P_N_CTNRO  IN NUMBER,
                                   P_N_ITOPER IN NUMBER,
                                   P_N_ITSUBO IN NUMBER,
                                   P_N_SUCDES IN NUMBER,
                                   P_N_ITTOPE IN NUMBER,
                                   P_N_MODULO IN NUMBER,
                                   P_N_MONEDA IN NUMBER,
                                   P_N_PAPEL  IN NUMBER,
                                   P_N_ITMOD  IN NUMBER,
                                   P_N_ITTRAN IN NUMBER,
                                   P_N_CANSUC IN NUMBER,
                                   P_N_MONTO  IN NUMBER,
                                   p_n_moncom out number,
                                   p_n_nummov out number
                                  );
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --- -- -- -- --
  FUNCTION fn_ah_verif_interplaza(P_SUCPAGO IN NUMBER,
                                  P_SUCORIG IN NUMBER)return number;
  Procedure sp_ah_monto_intplz_tipo9(ln_cuenta in number,-- da
                                     ln_scsuc  in number,--
                                     ln_modulo in number,--
                                     ln_opera  in number,--
                                     ln_tipo   in number,--
                                     ln_moneda in number,--
                                     ln_subope in number,--dat
                                     ln_trans  in number,
                                     ln_rel    in number,
                                     ld_fecha  in date,
                                     ln_pitsuc in number,
                                     ln_pitmod in number,
                                     ln_pitord in number,
                                     ln_pitsbor in number,
                                     ln_monto  in number,
                                     ln_canal  in number,
                                     ln_plaza1 in number,
                                     ln_plaza2 in number,
                                     lc_rpta   out number
                                     );

END PQ_AH_COM_INTERPLAZA;
/

CREATE OR REPLACE PACKAGE BODY PQ_AH_COM_INTERPLAZA IS
    -- *********************************************************************************
    -- Nombre                     : FUNCIONES PARA COBRO DE COMISIONES INTERPLAZAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : PASIVAS
    -- Versión                    : 1.01
    -- Fecha de Creación          : 2014.06.24
    -- Autor de Creación          : SMARQUEZ
    -- Uso                        : VERIFICACIONES Y COBRO DE COMISION
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 24/06/2014
    -- Uso                        : ADICION DE CONTROL DE NO COBRO INTERPLAZA PARA TIPO 12 EN CORRESPONSAL
    -- Autor de Creación          : YLOZADA
    -- Fecha de Modificación      : 19/10/2020    
    -- *********************************************************************************
  procedure sp_ah_verif_tablas16(ln_cuenta in number,-- datos de la cuenta
                                 ln_scsuc  in number,--
                                 ln_modulo in number,--
                                 ln_opera  in number,--
                                 ln_tipo   in number,--
                                 ln_moneda in number,--
                                 ln_subope in number,--datos de la cuenta
                                 ln_trans  in number,
                                 ln_rel    in number,
                                 ld_fecha  in date,
                                 ln_pitsuc in number,
                                 ln_pitmod in number,
                                 ln_pitord in number,
                                 ln_pitsbor in number,
                                 ln_monto  in number,
                                 ln_canal  in number,
                                 ln_plaza1 in number,
                                 ln_plaza2 in number,
                                 lc_rpta   out number)is



---------------------------------------------------------------------------------------------------------------------------------
  cursor BuscaDiaT16 is
       select  trunc(f6.itimp3),
               f6.itsuc,
               decode(f6.modulo,174,((f6.itimp1)*-1),f6.itimp1) itimp1,
               f6.itimp9,
               f6.itimp13,
               f6.itmod,
               f6.ittran,
               f6.itnrel,
               (select jaqy657pza  from jaqy657 where jaqy657suc = trunc(f6.itimp3)) as plaza1,
               (select jaqy657pza  from jaqy657 where jaqy657suc = f6.itsucd ) as plaza2
          from fsd016 f6,
               fsd015 f5,
               (Select * 
                  from fst198 
                 where tp1cod   = 1
                   and tp1cod1  = 10884
                   and TP1CORR1 = 3
                   and TP1CORR2 = 1
                   and tp1imp1  = 1
                   and tp1nro1  <> 490
                 union all    
                 Select * 
                  from fst198 
                 where tp1cod   = 1
                   and tp1cod1  = 10884
                   and TP1CORR1 = 3
                   and TP1CORR2 = 1
                   and tp1imp1  = 1
                   and tp1nro1  = 490    
                   and ln_tipo  <> 12                           
               )f8               
         where f6.pgcod = f8.tp1cod
           and f6.itmod = f8.tp1nro1
           and f6.ittran = f8.tp1nro2
           and f6.itnrel <> ln_rel
           and f6.itord = f8.tp1nro3         
---           and f6.modulo  in (21,22,174)---= ln_modulo 24/05/2019
           and (f6.modulo  in (21,22) or (f6.modulo =174 and f6.rubro = 9300070800001))
           and f6.itsucd = ln_scsuc
           and f6.moneda = ln_moneda
           and f6.papel = 0
           and f6.itimp3 <> 0.00
           and f6.itimp1 <> 0.00
           and f6.ctnro =  ln_cuenta
           and f6.itoper = ln_opera
           and f6.itsubo = ln_subope
           and f5.itsuc = f6.itsuc
           and f5.itmod = f6.itmod
           and f5.ittran = f6.ittran
           and f5.itnrel = f6.itnrel
           and f5.itcorr <> 99
           and f5.itcont = 'S'
           and (select jaqy657pza  from jaqy657 where jaqy657suc = f6.itimp3) <>(select jaqy657pza  from jaqy657 where jaqy657suc = f6.itsucd );

  cursor BuscaHisT16 (FechaIn in date,FechaFin in date) is
        select trunc(f.hcimp3),
               f.hsucor,
               decode(f.hmodul,174,((f.hcimp1)*-1),f.hcimp1) hcimp1,
               f.hfcon,
               (select jaqy657pza  from jaqy657 where jaqy657suc = trunc(f.hcimp3)) as plaza1, ---f6.itimp3
               (select jaqy657pza  from jaqy657 where jaqy657suc = f.hsucur ) as plaza2
          from fsh016 f,
               fsh015 h,
               (Select * 
                  from fst198 
                 where tp1cod   = 1
                   and tp1cod1  = 10884
                   and TP1CORR1 = 3
                   and TP1CORR2 = 1
                   and tp1imp1  = 1
                   and tp1nro1  <> 490
                 union all    
                 Select * 
                  from fst198 
                 where tp1cod   = 1
                   and tp1cod1  = 10884
                   and TP1CORR1 = 3
                   and TP1CORR2 = 1
                   and tp1imp1  = 1
                   and tp1nro1  = 490    
                   and ln_tipo  <> 12                           
               )f8
         where f.pgcod = f8.tp1cod
           and f.hcmod = f8.tp1nro1 --moduno
           and f.htran = f8.tp1nro2 ---tranuno
           and f.hcord = f8.tp1nro3 --orduno
           and f.hfcon between FechaIn and FechaFin ---ld_fecfin
           and (f.hmodul in (21,22) or (f.hmodul =174 and f.hrubro =9300070800001 )) --- 24/05/2019
          -- and f.htoper = ln_tipo
           and f.hsucur = ln_scsuc
           and f.hmda   = ln_moneda
           and f.hpap   = 0
           and f.hcta   = ln_cuenta
           and f.hoper  = ln_opera
           and f.hsubop = ln_subope
           and f.hcimp3 <> 0.00
           and h.pgcod  = f.pgcod
           and h.hcmod  = f.hcmod
           and h.hsucor = f.hsucor
           and h.htran = f.htran
           and h.hnrel = f.hnrel
           and h.hfcon = f.hfcon
           and h.hccorr <> 99          
           and (select jaqy657pza  from jaqy657 where jaqy657suc = f.hcimp3) <> (select jaqy657pza  from jaqy657 where jaqy657suc = f.hsucur );

   cursor BuscaOffline(P_fecha in date) is
     select nvl(sum(decode(z1.z0e4gcesm,1,1,-1)),0) operacion ,
            nvl(sum(decode(z1.z0e4gcesm,1,1* z1.z0e4gcimd,-1*z1.z0e4gcimd)),0) monto
          from z0e4gc z1,
               z0e475 z2
         where z1.z0e4gcest = 'ZZ'
           and z1.z0e4gcesm in (1,3)
           and z1.z0e4gctop in (1,2)
           and z1.z0e4gcfec = P_fecha
           and z1.z0e4gcdpg = 1
           and z1.z0e4gcdmd = ln_modulo
           and z1.z0e4gcdmo = ln_moneda
           and z1.z0e4gcdpa = 0
           and z1.z0e4gcdct = ln_cuenta
           and z1.z0e4gcdop = ln_opera
           and z1.z0e4gcdsc = ln_subope
           and z1.z0e4gcdto = ln_tipo
           and z1.z0e4gcdsu = ln_scsuc
           and z2.z0e475cod = z1.z0e4gcter
           and (select jaqy657pza  from jaqy657 where jaqy657suc = z2.z0e475suc) <> (select jaqy657pza  from jaqy657 where jaqy657suc = z1.z0e4gcdsu );

  v_cont1    number;
  v_monto    number(17,2);
  v_ctrl1    number;
  v_ctrl2    number;
  control    number;
  FechaInicial date;
  FechaFin   date;
  ln_moncom  number(17,2):= 0;
  lc_indcob  char(1):= 'S';
  MontoEx    number(17,2);
  NroOpe     number(1);

  lc_indoff  char(1);
  ln_monsal  number(17,2) := 0;
  ln_monrub  number(17,2) := 0;
  ln_monexo  number(17,2) := 0;
  ln_monret  number(17,2) := 0;
  ln_marca   number(17,2) := 0;
  ln_monto1  number(17,2) := 0;
  valor      number(1)    := 0;
  ln_tp1imp2 number(1)    := 0;
  ln_montoV  number(17,2) := 0;
  ld_fechaB  date;
  montoCol   number(17,2) := 0;
  ln_salrem  number(17,2) := 0;
  ln_salter  number(17,2) := 0;
  SaldoMtoB  number(17,2) := 0;
  ln_monrub1 number(17,2) := 0;
  sucursal   number(3):=0;
  -------------------------------
  monto_cte  number;
  IndCredVi  char(1);
  ln_monmov  number;
  ingreso9   char(1):='N';
  lc_error   varchar2(500);

  Begin
    if ln_tipo <> 12 or ln_pitmod <> 490 then
    
            v_monto := 0;
            v_cont1 := 1;
            v_ctrl1 := 0;
            v_ctrl2 := 0;
            control := 0;
            MontoEx := 0;
            NroOpe  := 0;

            lc_indoff := null;
            select pgfape
              into ld_fechaB
              from fst017
             where pgcod = 1;

            /*--CAMBIOS MONTO EXONERADO*/
            begin
              select --tp1imp2
                     tp1imp1,tp1imp2
                into valor,ln_tp1imp2
                from fst198
               where tp1cod = 1
                 and tp1cod1 = 10884
                 and TP1CORR1 = 3
                 and TP1CORR2 = 1
                 and tp1nro1 = ln_pitmod
                 and tp1nro2 = ln_trans
                 and tp1nro3 = ln_pitord
                 and tp1imp1 = 1
                 and tp1imp3 = ln_canal;
            exception
              when no_data_found then
                valor := 0;
            end;
            if ln_tipo = 9 then
             --CON ESTE PROCEDIMIENTO TE RETORNA EL MONTO ACTUAL DISPONIBLE DE LA BOLSA Y EL INDICADOR SI AUN TIENNE CREDITOS VIGENTES ASOCIADOS A DICHA CUENTA DE AHORRO CORRIENTE
             -- Call the procedure
              pq_ah_comision.sp_ah_consu_bolsa(p_n_pgcod => 1,
                                               p_n_modulo => ln_modulo,
                                               p_n_sucdes => ln_scsuc,
                                               p_n_moneda => ln_moneda,
                                               p_n_papel => 0,
                                               p_n_ctnro => ln_cuenta,
                                               p_n_itoper => ln_opera,
                                               p_n_itsubo => ln_subope,
                                               p_n_ittope => ln_tipo,
                                               p_d_fecpro => ld_fecha,
                                               p_n_mtosal => monto_cte, --SALDO RESTANTE EN BOLSA
                                               p_c_indcre => IndCredVi); --INDICADOR DE CREDITO S= SI TIENE N= NO TIENE



            end if;

            if valor = 1 then

              lc_indcob := Pq_Ah_Com_Interplaza.fn_valida_cobrocom (ln_cuenta,-- datos de la cuenta
                                                                    ln_scsuc,--
                                                                    ln_modulo,--
                                                                    ln_opera,--
                                                                    ln_tipo,--
                                                                    ln_moneda,--
                                                                    ln_subope,
                                                                    ld_fecha,
                                                                    ln_canal);
              Begin
              select 'N'
                into lc_indcob
                from fst198
               where TP1COD = 1
                 and TP1COD1 = 10884
                 and TP1CORR1 = 1
                 and TP1CORR2 = 1
                 and tp1nro1 = ln_tipo
                 and tp1nro2 = ln_modulo;
            Exception
              When no_data_found then
                lc_indcob := 'S';
            end;

              if lc_indcob = 'S' and ln_tp1imp2 = 1 and  ln_tipo <> 9  then ---2016/11/25
                   --verificamos si la cuenta cliente es dependiente o independiente para a partir de eso determinar el monto exonerado
                   --obtenemos el monto del rubro de exoneracion
                 if  ln_tipo <> 6 then

                      pq_ah_comision.sp_ah_monto_rubro(p_n_pgcod  => 1,
                                                       p_n_ctnro  => ln_cuenta,
                                                       p_n_itoper => ln_opera,
                                                       p_n_itsubo => ln_subope,
                                                       p_n_sucdes => ln_scsuc,
                                                       p_n_moneda => ln_moneda,
                                                       p_n_papel  => 0,
                                                       p_n_monto  => ln_monrub
                                                       );

                 else
                     if ln_tipo = 6 then ---23.03.2017
                        pq_ah_comision.sp_ah_saldos_remu(p_n_pgcod  => 1,
                                                         p_n_modulo => ln_modulo,
                                                         p_n_ctnro  => ln_cuenta,
                                                         p_n_itoper => ln_opera,
                                                         p_n_itsubo => ln_subope,
                                                         p_n_ittope => ln_tipo,
                                                         p_n_sucdes => ln_scsuc,
                                                         p_n_moneda => ln_moneda,
                                                         p_n_papel  => 0,
                                                         p_n_saldo  => ln_salrem,
                                                         p_n_salte  => ln_salter
                                                        );
                         --monto exonerado por rubro
                      pq_ah_comision.sp_ah_monto_rubro(p_n_pgcod  => 1,
                                                       p_n_ctnro  => ln_cuenta,
                                                       p_n_itoper => ln_opera,
                                                       p_n_itsubo => ln_subope,
                                                       p_n_sucdes => ln_scsuc,
                                                       p_n_moneda => ln_moneda,
                                                       p_n_papel  => 0,
                                                       p_n_monto  => ln_monrub1
                                                       );

                         if (ln_salrem + ln_monrub1) > 0  and ln_tp1imp2 = 1 then
                           ln_monrub := ln_salrem+ln_monrub1 ;
                         else
                            ln_monrub := 0;
                         end if;
                      end if;
                 end if;
                   ln_monexo := ln_monsal + ln_monrub;
                    --obtenemos total monto retirado SIN AFECTO A COMISION

                   ln_monret := ln_monret + ln_monto; --total retirado incluido movimiento actual

                   if ln_monexo >= ln_monret then ---ln_monto then ----
                      lc_indcob := 'N';
                      ln_marca := 0;
                      SaldoMtoB := ln_monret;

                   else
                      lc_indcob := 'S';
                      if ln_monexo <> 0 then
                         ln_marca := ln_monto - ln_monexo;
                         SaldoMtoB :=ln_monexo;
                      else
                         ln_marca := ln_monto;--0;
                      end if;
                   end if;
                   if SaldoMtoB > 0 and ln_tipo = 6 then
                        begin
                            if ln_pitsuc = 902 then
                                Begin
                                   select PfdSu03
                                     into sucursal
                                     from fsd603
                                    where PgCod = 1
                                      and Itsuc = ln_pitsuc
                                      and Itmod = ln_pitmod
                                      and Ittran = ln_trans
                                      and Itnrel = ln_rel;
                                exception
                                  when no_data_found then
                                    sucursal:= 0;
                                end;
                            else
                              sucursal:= ln_pitsuc;
                            end if;

                            insert into fsd016(pgcod, itsuc,itmod,ittran, itnrel, itord, itsbor, modulo,ittope,itsucd,rubro, moneda,papel, ctnro,
                                               itoper,itsubo, itfval, itfvto, itpzo, itper, itttas, ittasa, ittmor, ittdia, ittvto,  ittano,
                                               ittint, itarb, itarb1, itmd, itmd1, ittcbi, ittcbi1, itpre, itpre1, itdrev, itafiv,itafgt, itplus,
                                               itcodm, itser, itcheq, itimp1,itimp2, itimp3, itimp4, itimp5, itimp6, itimp7, itimp8, itimp9, itimp10,
                                               itimp11, itimp12, itimp13, itimp14, itimp15, itimp16, itimp17, itimp18,itimp19, itimp20,
                                               itimpo, itmdao,  itdbha, itncor, itbbtt, itfunc, itsegm, itccos, itcbcu, itccli,itref, itanu,
                                               itposic, itvalua,itcltcod, itpza, itdcom)
                                            values
                                              (1, ln_pitsuc,ln_pitmod, ln_trans, ln_rel, 45 ,2 , --ln_pitord, ln_pitsbor,
                                               174, 0, ln_scsuc,9300070800001, ln_moneda, 0, ln_cuenta, ln_opera, ln_subope, ld_fecha,
                                               to_date('01/01/0001', 'dd/mm/yyyy'), 0, 0, 0, 0, 0, 0, 'N', 0, null, 0, 0, null, null, 0,
                                               1,0, 0, 0, 'N', 'N', 0, 0, null, 0,  SaldoMtoB, --impt1
                                               0,
                                               sucursal,--ln_pitsuc, ---bolsa
                                               0, 0, 0, 0, 0, 0,  0, 0, --impt11
                                               0, 0, 0,0, 0,0,0,0,0, --fin importes
                                               0,0,2, 0,null, 0,0, 0, 0,0, null,'N', 0, 0,0,0, 0);

                             insert into fsd016(pgcod, itsuc,itmod,ittran, itnrel, itord, itsbor, modulo,ittope,itsucd,rubro, moneda,papel, ctnro,
                                               itoper,itsubo, itfval, itfvto, itpzo, itper, itttas, ittasa, ittmor, ittdia, ittvto,  ittano,
                                               ittint, itarb, itarb1, itmd, itmd1, ittcbi, ittcbi1, itpre, itpre1, itdrev, itafiv,itafgt, itplus,
                                               itcodm, itser, itcheq, itimp1,itimp2, itimp3, itimp4, itimp5, itimp6, itimp7, itimp8, itimp9, itimp10,
                                               itimp11, itimp12, itimp13, itimp14, itimp15, itimp16, itimp17, itimp18,itimp19, itimp20,
                                               itimpo, itmdao,  itdbha, itncor, itbbtt, itfunc, itsegm, itccos, itcbcu, itccli,itref, itanu,
                                               itposic, itvalua,itcltcod, itpza, itdcom)
                                            values
                                              (1, ln_pitsuc,ln_pitmod, ln_trans, ln_rel,53,2,-- ln_pitord, ln_pitsbor,
                                               457, 0, ln_scsuc,9300071800001, ln_moneda, 0, 0, ln_opera, 0, to_date('01/01/0001', 'dd/mm/yyyy'),
                                               to_date('01/01/0001', 'dd/mm/yyyy'), 0, 0, 0, 0, 0, 0, 'N', 0, null, 0, 0, null, null, 0,
                                               1,0, 0, 0, 'N', 'N', 0, 0, null, 0,  SaldoMtob, --impt1
                                               0,
                                               0, ---bolsa
                                               0, 0, 0, 0, 0, 0,  0, 0, --impt11
                                               0, 0, 0,0, 0,0,0,0,0, --fin importes
                                               0,0,1, 0,null, 0,0, 0, 0,0, null,'N', 0, 0,0,0, 0);
                               commit;
                        exception
                          when dup_val_on_index then
                            null;
                        end;
                   end if;
              end if;
             /*-FIN CAMBIOS -*/
          else
             Begin
              select 'N'
                into lc_indcob
                from fst198
               where TP1COD = 1
                 and TP1COD1 = 10884
                 and TP1CORR1 = 1
                 and TP1CORR2 = 1
                 and tp1nro1 = ln_tipo
                 and tp1nro2 = ln_modulo;
            Exception
              When no_data_found then
                lc_indcob := 'S';
            end;
          end if;
          IF lc_indcob = 'S' THEN
                begin
                  insert into jaqy670
                    (jaqy670pgc,
                     jaqy670suc,
                     JAQY670mod,
                     JAQY670trx,
                     JAQY670rel,
                     JAQY670fec,
                     JAQY670ini)
                  values
                    (1,
                     ln_pitsuc,
                     ln_pitmod,
                     ln_trans,
                     ln_rel,
                     ld_fecha,
                     sysdate
                     );
                     commit;
                Exception
                When others then
                     null;
                end;
                /*--fin registro inicio*/

                -- Fecha Inicial y Final -- FechaInicial := to_date('01'||TO_CHAR(SYSDATE,'MM')||TO_CHAR(SYSDATE,'YYYY'),'dd/mm/yyyy');
                select to_date('01' || TO_CHAR(pgfape, 'MM') || TO_CHAR(pgfape, 'YYYY'),'dd/mm/yyyy'),
                       last_day(pgfape)
                  into FechaInicial,
                       FechaFin
                  from fst017
                 where pgcod = 1;

                --- Monto Exonerado 2016/11/25

                if ln_moneda = 101 then
                  IF ln_tipo <> 9 then
                    select round(TP1IMP1/ fn_tipo_cambio(fecha  => trunc(sysdate),
                                                                    monori => ln_moneda,
                                                                    mondes => 0,
                                                                    tipo   => 500
                                                                    ),2)
                      into MontoEx
                      from fst198
                     where TP1COD = 1
                       and TP1COD1 = 10884
                       and TP1CORR1 = 2
                       and TP1CORR2 = 1
                       and TP1CORR3 = 1;
                  end if;
                else
                  select TP1IMP1
                    into MontoEx
                    from fst198
                   where TP1COD = 1
                     and TP1COD1 = 10884
                     and TP1CORR1 = 2
                     and TP1CORR2 = 1
                     and TP1CORR3 = 1;
                end if;
                -- Nro operaciones Permitidas
                select TP1NRO1
                  into NroOpe
                  from fst198
                 where TP1COD = 1
                   and TP1COD1 = 10884
                   and TP1CORR1 = 2
                   and TP1CORR2 = 1
                   and TP1CORR3 = 2;

                ---****** Nueva Forma de Cobro Interplaza ***------
                select opgval into lc_indoff from fst200 where opgcod=544;

                if lc_indoff = 'S' then --online
                   if ld_fecha = ld_fechaB then ----trunc(sysdate) then ----to_date('01/06/2015','dd/mm/yyyy') then--- para pruebas solamente trunc(sysdate) then
                      if substr(to_char(ld_fecha,'dd/mm/yyyy'),1,2) = '01'then  -- verif 1er dia

                          For reg in BuscaDiaT16 loop
                             if (monto_cte > 0) and (IndCredVi = 'S') then
                                if reg.itimp1 > 0 then ---new
                                    v_cont1 := v_cont1 + 1;
                                    v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                 end if;
                             else
                                 if ln_tipo <> 9 then
                                     v_monto := v_monto + reg.itimp1 ;
                                     v_ctrl1 := fn_ah_verif_monto(v_monto, ln_moneda,ld_fecha ,  montoCol,ln_tipo);

                                     if reg.itimp1 > 0 then ---new
                                       v_cont1 := v_cont1 + 1;
                                        v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                      else
                                       v_cont1 := v_cont1 - 1;
                                       v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                     end if;
                                 else
                                   if reg.itimp1 > 0 then ---new
                                      v_cont1 := v_cont1 + 1;
                                      v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                   end if;
                                 end if;
                             end if;
                          end loop;

                          IF ln_tipo = 9 THEN ---sma 19032019
                            if (monto_cte - ln_monto)> 0 and (IndCredVi = 'S') then
                              v_ctrl1 := 0;
                            elsif (monto_cte - ln_monto)> 0  then
                               v_ctrl1 := 0;
                            else
                               v_ctrl1 := 1;
                            end if;
                          END IF;

                          if ln_marca <> 0 then ---2016/11/03
                            ln_montoV := ln_marca;
                          else
                            ln_montoV := ln_monto;
                          end if;

                          if  (v_ctrl1 = 1) or (v_ctrl2 = 1) then
                               if ln_tipo = 9 then
                                 if IndCredVi = 'S' then
                                    if (monto_cte - ln_monto)> 0 then
                                      control := 0;
                                    else
                                      control := 1;
                                    end if;
                                 else

                                   control := 1;
                                 end if;
                               else
                                 control := 1;
                               end if;

                          elsif  fn_ah_verif_monto(ln_montov, ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then --ln_montov
                               control := 1;
                          elsif fn_ah_verif_monto((ln_montov + v_monto), ln_moneda, ld_fecha,  montoCol,ln_tipo )= 1 then --ln_montov
                               control := 1;
                          end if;
                      else

                          For reg in BuscaDiaT16 loop
                               if (monto_cte > 0) and (IndCredVi = 'S') then
                                 if reg.itimp1  > 0 then
                                    v_cont1 := v_cont1 + 1;
                                   v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                 end if;
                               else
                                 if ln_tipo <> 9 then
                                     v_monto := v_monto + reg.itimp1 ;
                                     v_ctrl1 := fn_ah_verif_monto(v_monto, ln_moneda,ld_fecha, montoCol,ln_tipo);

                                     if reg.itimp1  > 0 then
                                       v_cont1 := v_cont1 + 1;
                                       v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                     else
                                       v_cont1 := v_cont1 - 1;
                                       v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                     end if;
                                  else
                                     if reg.itimp1  > 0 then
                                        v_cont1 := v_cont1 + 1;
                                        v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                     end if;
                                  end if;
                               end if;
                          end loop;

                          IF ln_tipo = 9 THEN
                            if ((monto_cte - ln_monto)> 0) and (IndCredVi = 'S') then
                               v_ctrl1 := 0;
                             elsif (monto_cte - ln_monto)> 0  then
                               v_ctrl1 := 0;
                            else
                               v_ctrl1 := 1;
                            end if;
                          END IF;

                          if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
                               if ln_tipo = 9 then
                                 if IndCredVi = 'S' then
                                    if (monto_cte - ln_monto)> 0 then
                                      control := 0;
                                    else
                                      control := 1;
                                    end if;
                                 else
                                   control := 1;
                                 end if;
                               else
                                  control := 1;
                               end if;
                          end if;

                          -- Busca Movimientos Historicos
                          For reh in BuscaHisT16(FechaInicial,FechaFin) loop
                            if (monto_cte > 0) and (IndCredVi = 'S') then
                                 if reh.hcimp1 > 0 then
                                   v_cont1 := v_cont1 + 1;
                                   v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                end if;
                            else
                               if ln_tipo <> 9 then
                                  v_monto := v_monto +  reh.hcimp1;
                                  v_ctrl1 := fn_ah_verif_monto(v_monto, ln_moneda, reh.hfcon, montoCol,ln_tipo );

                                  if reh.hcimp1 > 0 then
                                     v_cont1 := v_cont1 + 1;
                                     v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                   else
                                       v_cont1 := v_cont1 - 1;
                                       v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                  end if;
                               else
                                 if reh.hcimp1 > 0 then
                                     v_cont1 := v_cont1 + 1;
                                     v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                 end if;
                               end if;
                            end if;
                          end loop;
                          IF ln_tipo = 9 THEN
                            if ((monto_cte - ln_monto)> 0) and (IndCredVi = 'S') then
                               v_ctrl1 := 0;
                             elsif (monto_cte - ln_monto)> 0  then
                               v_ctrl1 := 0;
                            else
                               v_ctrl1 := 1;
                            end if;
                          END IF;
                          if ln_marca <> 0 then ---2016/11/03
                            ln_montoV := ln_marca;
                          else
                            ln_montoV := ln_monto;
                          end if;

                          if (v_ctrl1 = 1) or (v_ctrl2 = 1) then

                                 if ln_tipo = 9 then
                                   if IndCredVi = 'S' then
                                      if (monto_cte - ln_monto)> 0 then
                                        control := 0;
                                      else
                                        control := 1;
                                      end if;
                                   else
                                     control := 1;
                                   end if;
                                 else
                                   control := 1;
                                 end if;

                          elsif  fn_ah_verif_monto(ln_montov, ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then
                               control := 1;
                          elsif fn_ah_verif_monto((ln_montov + v_monto), ln_moneda, ld_fecha, montoCol,ln_tipo)= 1 then
                               control := 1;
                          end if;
                      end if;
                   Else
                     IF fn_ah_ind_data ='N' then
                        -- Busca Movimientos Historicos
                        For reh in BuscaHisT16(FechaInicial,FechaFin) loop
                          IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                            if reh.hcimp1 >0 then
                               v_cont1 := v_cont1 + 1;
                               v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                            end if;
                          ELSE
                            if ln_tipo <> 9 then
                                v_monto := v_monto +  reh.hcimp1;
                                v_ctrl1 := fn_ah_verif_monto(v_monto, ln_moneda, reh.hfcon, montoCol,ln_tipo );

                                if reh.hcimp1 >0 then
                                    v_cont1 := v_cont1 + 1;
                                   v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                else
                                     v_cont1 := v_cont1 - 1;
                                     v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                end if;
                            else
                                if reh.hcimp1 >0 then
                                   v_cont1 := v_cont1 + 1;
                                   v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                end if;
                            end if;
                          END IF;
                        end loop;
                        IF ln_tipo = 9 THEN --2019/03/19
                            if ((monto_cte - ln_monto)> 0) and (IndCredVi = 'S') then
                              v_ctrl1 := 0;
                             elsif (monto_cte - ln_monto)> 0  then
                               v_ctrl1 := 0;
                            else
                               v_ctrl1 := 1;
                            end if;
                        END IF;
                        if ln_marca <> 0 then ---2016/11/03
                            ln_montoV := ln_marca;
                          else
                            ln_montoV := ln_monto;
                          end if;
                        if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
                             if ln_tipo = 9 then
                                 if IndCredVi = 'S' then
                                    if (monto_cte - ln_monto)> 0 then
                                      control := 0;
                                    else
                                      control := 1;
                                    end if;
                                 else
                                   control := 1;
                                 end if;
                               else
                                 control := 1;
                             end if;
                        elsif  fn_ah_verif_monto(ln_montov, ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then
                             control := 1;
                        elsif fn_ah_verif_monto((ln_montov + v_monto), ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then
                             control := 1;
                        end if;
                     Else
                       if substr(to_char(ld_fecha,'dd/mm/yyyy'),1,2) = '01' then
                          For reg in BuscaDiaT16 loop
                            IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                                 if reg.itimp1 > 0 then
                                    v_cont1 := v_cont1 + 1;
                                    v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                 end if;
                            ELSE
                               if ln_tipo = 9 then
                                   v_monto := v_monto + reg.itimp1 ;
                                   v_ctrl1 := fn_ah_verif_monto(v_monto, ln_moneda,ld_fecha, montoCol,ln_tipo);

                                   if reg.itimp1 > 0 then
                                     v_cont1 := v_cont1 + 1;
                                      v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                   else
                                     v_cont1 := v_cont1 - 1;
                                     v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                   end if;
                               else
                                  if reg.itimp1 > 0 then
                                    v_cont1 := v_cont1 + 1;
                                    v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                  end if;
                               end if;

                             END IF;
                          end loop;
                          IF ln_tipo = 9 THEN --2019/03/19
                            if ((monto_cte - ln_monto)> 0) and (IndCredVi = 'S') then
                               v_ctrl1 := 0;
                             elsif (monto_cte - ln_monto)> 0  then
                               v_ctrl1 := 0;
                            else
                               v_ctrl1 := 1;
                            end if;
                          END IF;
                          if ln_marca <> 0 then ---2016/11/03
                            ln_montoV := ln_marca;
                          else
                            ln_montoV := ln_monto;
                          end if;
                          if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
                                if ln_tipo = 9 then
                                   if IndCredVi = 'S' then
                                      if (monto_cte - ln_monto)> 0 then
                                        control := 0;
                                      else
                                        control := 1;
                                      end if;
                                   else
                                     control := 1;
                                   end if;
                               else
                                 control := 1;
                               end if;
                          elsif  fn_ah_verif_monto(ln_montov, ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then
                               control := 1;
                          elsif fn_ah_verif_monto((ln_montov + v_monto), ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then
                               control := 1;
                          end if;
                       Else
                          For reg in BuscaDiaT16 loop
                            IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                                if reg.itimp1 > 0 then
                                    v_cont1 := v_cont1 + 1;
                                    v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                 end if;
                            eLSE
                              if ln_tipo <> 9 then
                                 v_monto := v_monto + reg.itimp1 ;
                                 v_ctrl1 := fn_ah_verif_monto(v_monto, ln_moneda,ld_fecha, montoCol,ln_tipo);

                                 if reg.itimp1 > 0 then
                                    v_cont1 := v_cont1 + 1;
                                    v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                 else
                                   v_cont1 := v_cont1 - 1;
                                   v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                 end if;
                              else
                                 if reg.itimp1 > 0 then
                                    v_cont1 := v_cont1 + 1;
                                    v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                 end if;
                              end if;
                            END IF;
                          end loop;
                          IF ln_tipo = 9 THEN --2019/03/19
                            if ((monto_cte - ln_monto)> 0)and (IndCredVi = 'S') then
                               v_ctrl1 := 0;
                             elsif (monto_cte - ln_monto)> 0  then
                               v_ctrl1 := 0;
                            else
                               v_ctrl1 := 1;
                            end if;
                          END IF;
                          if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
                                if ln_tipo = 9 then
                                   if IndCredVi = 'S' then
                                      if (monto_cte - ln_monto)> 0 then
                                        control := 0;
                                      else
                                        control := 1;
                                      end if;
                                   else
                                     control := 1;
                                   end if;
                               else
                                 control := 1;
                               end if;
                          end if;
                          -- Busca Movimientos Historicos
                          For reh in BuscaHisT16(FechaInicial,FechaFin) loop
                            IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                                 if reh.hcimp1 > 0 then
                                   v_cont1 := v_cont1 + 1;
                                   v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                end if;
                            ELSE
                              if ln_tipo <>9 then
                                  v_monto := v_monto +  reh.hcimp1;
                                  v_ctrl1 := fn_ah_verif_monto(v_monto, ln_moneda, reh.hfcon, montoCol,ln_tipo );
                                  if reh.hcimp1 > 0 then
                                     v_cont1 := v_cont1 + 1;
                                     v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                  else
                                     v_cont1 := v_cont1 - 1;
                                     v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                  end if;
                              else
                                  if reh.hcimp1 > 0 then
                                     v_cont1 := v_cont1 + 1;
                                     v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                   end if;
                              end if;
                            END IF;
                          end loop;
                          IF ln_tipo = 9 THEN --2019/03/19
                            if ((monto_cte - ln_monto)> 0) and (IndCredVi = 'S') then
                               v_ctrl1 := 0;
                             elsif (monto_cte - ln_monto)> 0  then
                               v_ctrl1 := 0;
                            else
                               v_ctrl1 := 1;
                            end if;
                          END IF;
                          if ln_marca <> 0 then ---2016/11/03
                            ln_montoV := ln_marca;
                          else
                            ln_montoV := ln_monto;
                          end if;
                          if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
                               if ln_tipo = 9 then
                                   if IndCredVi = 'S' then
                                      if (monto_cte - ln_monto)> 0 then
                                        control := 0;
                                      else
                                        control := 1;
                                      end if;
                                   else
                                     control := 1;
                                   end if;
                               else
                                 control := 1;
                               end if;
                          elsif  fn_ah_verif_monto(ln_montov, ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then
                               control := 1;
                          elsif fn_ah_verif_monto((ln_montov + v_monto), ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then
                               control := 1;
                          end if;
                       end if;
                     end if;
                   end if;
                 Else
                     if fn_ah_ind_data = 'S' then
                        if substr(to_char(ld_fecha,'dd/mm/yyyy'),1,2) = '01' then

                           For reg in BuscaDiaT16 loop
                               IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                                 if reg.itimp1 > 0 then
                                    v_cont1 := v_cont1 + 1;
                                    v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                 end if;
                               ELSE
                                 if ln_tipo <> 9 then
                                     v_monto := v_monto + reg.itimp1 ;
                                     v_ctrl1 := fn_ah_verif_monto(v_monto, ln_moneda,ld_fecha, montoCol,ln_tipo);
                                   ---  v_cont1 := v_cont1 + 1;
                                     if reg.itimp1 > 0 then
                                        v_cont1 := v_cont1 + 1;
                                        v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                     else
                                       v_cont1 := v_cont1 - 1;
                                       v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                     end if;
                                 else
                                     if reg.itimp1 > 0 then
                                        v_cont1 := v_cont1 + 1;
                                        v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                     end if;
                                 end if;
                               END IF;
                            end loop;
                            IF ln_tipo = 9 THEN --2019/03/19
                              if ((monto_cte - ln_monto)> 0) and (IndCredVi = 'S') then
                                 v_ctrl1 := 0;
                               elsif (monto_cte - ln_monto)> 0  then
                               v_ctrl1 := 0;
                               else
                               v_ctrl1 := 1;
                              end if;
                            END IF;
                            if ln_marca <> 0 then ---2016/11/03
                              ln_montoV := ln_marca;
                            else
                              ln_montoV := ln_monto;
                            end if;
                            if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
                               if ln_tipo = 9 then
                                   if IndCredVi = 'S' then
                                      if (monto_cte - ln_monto)> 0 then
                                        control := 0;
                                      else
                                        control := 1;
                                      end if;
                                   else
                                     control := 1;
                                   end if;
                                 else
                                   control := 1;
                                 end if;
                            elsif  fn_ah_verif_monto(ln_montov, ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then
                               control := 1;
                            elsif fn_ah_verif_monto((ln_montov + v_monto), ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then
                                 control := 1;
                            end if;
                        else

                           For reg in BuscaDiaT16 loop
                             IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                                if reg.itimp1 > 0 then
                                    v_cont1 := v_cont1 + 1;
                                    v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                 end if;
                             ELSE
                               if ln_tipo <> 9 then
                                   v_monto := v_monto + reg.itimp1 ;
                                   v_ctrl1 := fn_ah_verif_monto(v_monto, ln_moneda,ld_fecha, montoCol,ln_tipo);

                                   if reg.itimp1 > 0 then
                                       v_cont1 := v_cont1 + 1;
                                      v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                    else
                                     v_cont1 := v_cont1 - 1;
                                     v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                   end if;
                               else
                                   if reg.itimp1 > 0 then
                                      v_cont1 := v_cont1 + 1;
                                      v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                   end if;
                               end if;
                             END IF;
                          end loop;
                          IF ln_tipo = 9 THEN --2019/03/19
                              if ((monto_cte - ln_monto)> 0) and (IndCredVi = 'S') then
                                 v_ctrl1 := 0;
                               elsif (monto_cte - ln_monto)> 0  then
                               v_ctrl1 := 0;
                               else
                               v_ctrl1 := 1;
                              end if;
                          END IF;
                          if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
                              if ln_tipo = 9 then
                                   if IndCredVi = 'S' then
                                      if (monto_cte - ln_monto)> 0 then
                                        control := 0;
                                      else
                                        control := 1;
                                      end if;
                                   else
                                     control := 1;
                                   end if;
                                 else
                                   control := 1;
                                 end if;
                          end if;

                          -- Busca Movimientos Historicos
                          For reh in BuscaHisT16(FechaInicial,FechaFin) loop
                            IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                               if reh.hcimp1 > 0 then
                                 v_cont1 := v_cont1 + 1;
                                 v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                               end if;
                            ELSE
                              if ln_tipo <> 9 then
                                  v_monto := v_monto +  reh.hcimp1;
                                  v_ctrl1 := fn_ah_verif_monto(v_monto, ln_moneda, reh.hfcon, montoCol,ln_tipo );

                                  if reh.hcimp1 > 0 then
                                     v_cont1 := v_cont1 + 1;
                                     v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                   else
                                       v_cont1 := v_cont1 - 1;
                                       v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                  end if;
                              else
                                if reh.hcimp1 > 0 then
                                     v_cont1 := v_cont1 + 1;
                                     v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                end if;
                              end if;
                            END IF;
                          end loop;
                          IF ln_tipo = 9 THEN --2019/03/19
                              if ((monto_cte - ln_monto)> 0) and (IndCredVi = 'S') then
                                 v_ctrl1 := 0;
                               elsif (monto_cte - ln_monto)> 0  then
                                  v_ctrl1 := 0;
                               else
                                   v_ctrl1 := 1;
                              end if;
                            END IF;
                           if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
                               if ln_tipo = 9 then
                                   if IndCredVi = 'S' then
                                      if (monto_cte - ln_monto)> 0 then
                                        control := 0;
                                      else
                                        control := 1;
                                      end if;
                                   else
                                     control := 1;
                                   end if;
                                 else
                                   control := 1;
                                 end if;
                          elsif  fn_ah_verif_monto(ln_montov, ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then
                               control := 1;
                          elsif fn_ah_verif_monto((ln_montov + v_monto), ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then
                               control := 1;
                          end if;

                          -- Busca Offline
                          For reo in BuscaOffline (trunc(sysdate))loop
                            IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                              if reo.monto > 0 then
                                 v_cont1 := v_cont1 + reo.operacion ;
                                 v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                              end if;
                            ELSE
                              if ln_tipo <> 9 then
                                  v_monto := v_monto + reo.monto;
                                  v_ctrl1 := fn_ah_verif_monto(v_monto, ln_moneda, ld_fecha, montoCol,ln_tipo );

                                  if reo.monto > 0 then
                                     v_cont1 := v_cont1 + 1;
                                     v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                  else
                                       v_cont1 := v_cont1 - 1;
                                       v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                  end if;
                              else
                                  if reo.monto > 0 then
                                     v_cont1 := v_cont1 + reo.operacion ;
                                     v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                  end if;
                              end if;
                            END IF;
                          end Loop;
                          IF ln_tipo = 9 THEN --2019/03/19
                              if ((monto_cte - ln_monto)> 0) and (IndCredVi = 'S') then
                                 v_ctrl1 := 0;
                               elsif (monto_cte - ln_monto)> 0  then
                                 v_ctrl1 := 0;
                              else
                                 v_ctrl1 := 1;
                              end if;
                            END IF;
                          if ln_marca <> 0 then ---2016/11/03
                            ln_montoV := ln_marca;
                          else
                            ln_montoV := ln_monto;
                          end if;
                          if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
                                if ln_tipo = 9 then
                                   if IndCredVi = 'S' then
                                      if (monto_cte - ln_monto)> 0 then
                                        control := 0;
                                      else
                                        control := 1;
                                      end if;
                                   else
                                     control := 1;
                                   end if;
                                 else
                                   control := 1;
                                 end if;
                          elsif  fn_ah_verif_monto(ln_montov, ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then
                               control := 1;
                          elsif fn_ah_verif_monto((ln_montov + v_monto), ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then
                               control := 1;
                          end if;

                        end if;
                     else
                        -- Busca Movimientos Historicos
                          For reh in BuscaHisT16(FechaInicial,FechaFin) loop
                            IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                               if reh.hcimp1 > 0 then
                                   v_cont1 := v_cont1 + 1;
                                   v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                end if;
                            ELSE
                              if ln_tipo <> 9 then
                                  v_monto := v_monto +  reh.hcimp1;
                                  v_ctrl1 := fn_ah_verif_monto(v_monto, ln_moneda, reh.hfcon, montoCol,ln_tipo );

                                  if reh.hcimp1 > 0 then
                                     v_cont1 := v_cont1 + 1;
                                     v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                  else
                                     v_cont1 := v_cont1 - 1;
                                     v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                  end if;
                              else
                                if reh.hcimp1 > 0 then
                                     v_cont1 := v_cont1 + 1;
                                     v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                end if;
                              end if;
                            END IF;
                          end loop;
                          IF ln_tipo = 9 THEN --2019/03/19
                              if ((monto_cte - ln_monto)> 0)  and (IndCredVi = 'S') then
                                 v_ctrl1 := 0;
                               elsif (monto_cte - ln_monto)> 0  then
                                 v_ctrl1 := 0;
                              else
                                 v_ctrl1 := 1;
                              end if;
                           END IF;
                           if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
                              if ln_tipo = 9 then
                                   if IndCredVi = 'S' then
                                      if (monto_cte - ln_monto)> 0 then
                                        control := 0;
                                      else
                                        control := 1;
                                      end if;
                                   else
                                     control := 1;
                                   end if;
                                 else
                                   control := 1;
                                 end if;
                          end if;
                          -- Busca Offline
                          For reo in BuscaOffline (trunc(sysdate))loop
                            IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                               if reo.monto > 0 then
                                  v_cont1 := v_cont1 + reo.operacion ;
                                  v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                end if;
                            ELSE
                              if ln_tipo <> 9 then
                                  v_monto := v_monto + reo.monto;
                                  v_ctrl1 := fn_ah_verif_monto(v_monto, ln_moneda, ld_fecha, montoCol,ln_tipo );---reh.hfcon

                                  if reo.monto > 0 then
                                    v_cont1 := v_cont1 + 1;
                                    v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                 else
                                     v_cont1 := v_cont1 - 1;
                                     v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                  end if;
                              else
                                  if reo.monto > 0 then
                                    v_cont1 := v_cont1 + reo.operacion ;
                                    v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                  end if;
                              end if;
                            END IF;
                          end Loop;
                          IF ln_tipo = 9 THEN --2019/03/19
                              if ((monto_cte - ln_monto)> 0) and (IndCredVi = 'S') then
                                 v_ctrl1 := 0;
                               elsif (monto_cte - ln_monto)> 0  then
                                 v_ctrl1 := 0;
                              else
                                 v_ctrl1 := 1;
                              end if;
                          END IF;
                          if ln_marca <> 0 then ---2016/11/03
                            ln_montoV := ln_marca;
                          else
                            ln_montoV := ln_monto;
                          end if;

                          if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
                                if ln_tipo = 9 then
                                   if IndCredVi = 'S' then
                                      if (monto_cte - ln_monto)> 0 then
                                        control := 0;
                                      else
                                        control := 1;
                                      end if;
                                   else
                                     control := 1;
                                   end if;
                                 else
                                   control := 1;
                                 end if;
                          elsif  fn_ah_verif_monto(ln_montov, ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then --ln_monto
                               control := 1;
                          elsif fn_ah_verif_monto((ln_montov + v_monto), ln_moneda, ld_fecha, montoCol,ln_tipo )= 1 then --ln_monto
                               control := 1;
                          end if;
                     end if;
                   End if;


                if control = 1 then
                  lc_rpta := 1;

                  --VERIFICAMOS EXONERACIÓN
                  lc_indcob := pq_ah_com_interplaza.fn_valida_cobrocom(ln_cuenta => ln_cuenta,
                                                                       ln_scsuc  => ln_scsuc,
                                                                       ln_modulo => ln_modulo,
                                                                       ln_opera  => ln_opera,
                                                                       ln_tipo   => ln_tipo,
                                                                       ln_moneda => ln_moneda,
                                                                       ln_subope => ln_subope,
                                                                       ld_fecfin => ld_fecha,--ld_fecfin
                                                                       ln_canal  => ln_canal
                                                                       );
                  -- Aplica comisión
                  If lc_indcob = 'S' then
                     if ln_tipo <> 9 then
                         ln_monto1 :=  ln_monto - ln_monexo;---ln_marca ;

                           --OBTENEMOS MONTO DE COMISION--nuevo
                           if  v_cont1 >  NroOpe then
                              IF ln_monexo > 0 or montoCol > 0 THEN
                                  -- v_monto := ln_monto1;---07/11/2016
                                   if  v_monto = 0 then
                                      --if ln_monto >= MontoEx then
                                        v_monto := ln_monto1 - MontoEx ;
                                      --end if;
                                   else
                                     if v_monto < MontoEx  then ---19/11/2016
                                       -- if (v_monto + ln_monto )>= MontoEx then

                                           v_monto := (v_monto + ln_monto1)-MontoEx;
                                       -- end if;
                                     else
                                       if v_monto >= MontoEx then
                                         v_monto := ln_monto1;
                                       end if;
                                     end if;
                                   end if;
                              ELSE
                                v_monto := ln_monto1;
                              END IF;
                           else
                             if  v_monto = 0 then
                                --if ln_monto >= MontoEx then
                                  v_monto := ln_monto1 - MontoEx ;
                                --end if;
                             else
                               if v_monto < MontoEx then
                                 -- if (v_monto + ln_monto )>= MontoEx then
                                     v_monto := (v_monto + ln_monto1)-MontoEx;
                                 -- end if;
                               else
                                 if v_monto >= MontoEx then
                                   v_monto := ln_monto1;
                                 end if;
                               end if;
                             end if;
                           end if;
                     else --sma 22.01.19 aqui llamar la funcion del Yrving
                       ingreso9 := 'S';
                       ln_monto1 :=   monto_cte - ln_monto ;

                       if IndCredVi = 'S' then
                          if  ln_monto1 >= 0 then-- :=  ln_monto - monto_cte;---verificar
                              v_monto := 0;
                              ln_monmov := ln_monto;--ln_monto1;
                          else
                              v_monto := ABS(ln_monto1);
                              ln_monmov := monto_cte;
                          end if;
                       else
                           --OBTENEMOS MONTO DE COMISION--nuevo
                           if  v_cont1 >  NroOpe then
                               v_monto := ln_monto;
                             --  ln_monmov := ln_monto;
                                if  ln_monto1 >= 0 then-- :=  ln_monto - monto_cte;---verificar
                                    ln_monmov := ln_monto;--ln_monto1;
                                else
                                    ln_monmov := monto_cte;
                                end if;
                           else
                              if  v_monto = 0 then
                               /* if ln_monto1 >= 0 then

                                  v_monto := ln_monto;
                                  ln_monmov := ln_monto;
                                ELSE*/
                                    v_monto := ABS(ln_monto1);
                                    if  ln_monto1 >= 0 then-- :=  ln_monto - monto_cte;---verificar
                                       ln_monmov := ln_monto;--ln_monto1;
                                    else
                                        ln_monmov := monto_cte;
                                    end if;

--                                end if;
                              end if;
                           end if;
                       end if;



                     end if;----

                        If ln_moneda = 101 Then
                          v_monto := round(v_monto* fn_tipo_cambio(fecha   => ld_fecha, ---ld_fecfin,
                                                                    monori => ln_moneda,
                                                                    mondes => 0,
                                                                    tipo   => 500
                                                                   ),2);
                        End If;

                        ln_moncom := pq_ah_com_interplaza.fn_monto_comision(ln_cuenta => ln_cuenta,
                                                                            ln_scsuc  => ln_scsuc,
                                                                            ln_modulo => ln_modulo,
                                                                            ln_opera  => ln_opera,
                                                                            ln_tipo   => ln_tipo,
                                                                            ln_moneda => ln_moneda,
                                                                            ln_subope => ln_subope,
                                                                            ld_fecfin => ld_fecha, --ld_fecfin,
                                                                            ln_canal  => ln_canal,
                                                                            ln_monto  => v_monto
                                                                            );
                        If ln_moneda = 101 Then
                          ln_moncom := round(ln_moncom/ fn_tipo_cambio(fecha  => ld_fecha,--ld_fecfin,
                                                                       monori => ln_moneda,
                                                                       mondes => 0,
                                                                       tipo   => 500
                                                                      ),2);
                        End If;
                  Else
                      ln_moncom := 0;
                  End If;

                 Begin
                  Update FSD016
                     set Itimp11 = ln_moncom --,    /*v_monto*/
                        -- Itimp4  = nvl(ln_marca,0)--v_monto
                   Where Pgcod = 1
                     and Itsuc = ln_pitsuc
                     and Itmod = ln_pitmod
                     and Ittran = ln_trans
                     and Itnrel = ln_rel
                     and Itord = ln_pitord
                     and Itsbor = ln_pitsbor;


                    exception
                      when others then

                       null;
                    end;

                else
                  lc_rpta := 0;
                  ln_marca := 0;
                end if;

                /*--registramos tiempo final de ejecucion*/
                begin
                 update JAQY670
                    set JAQY670fin = sysdate,
                        JAQY670mco = ln_moncom,
                        JAQY670nmo = v_cont1,
                        jaqy670mto = v_monto
                  where JAQY670pgc = 1
                    and JAQY670suc = ln_pitsuc
                    and JAQY670mod = ln_pitmod
                    and JAQY670trx = ln_trans
                    and JAQY670rel = ln_rel
                    and JAQY670fec = ld_fecha;
                    commit;
                Exception
                When others then
                     null;
                end;
                /*
                begin

                    insert into fsd016(pgcod, itsuc,itmod,ittran, itnrel, itord, itsbor, modulo,ittope,itsucd,rubro, moneda,papel, ctnro,
                                       itoper,itsubo, itfval, itfvto, itpzo, itper, itttas, ittasa, ittmor, ittdia, ittvto,  ittano,
                                       ittint, itarb, itarb1, itmd, itmd1, ittcbi, ittcbi1, itpre, itpre1, itdrev, itafiv,itafgt, itplus,
                                       itcodm, itser, itcheq, itimp1,itimp2, itimp3, itimp4, itimp5, itimp6, itimp7, itimp8, itimp9, itimp10,
                                       itimp11, itimp12, itimp13, itimp14, itimp15, itimp16, itimp17, itimp18,itimp19, itimp20,
                                       itimpo, itmdao,  itdbha, itncor, itbbtt, itfunc, itsegm, itccos, itcbcu, itccli,itref, itanu,
                                       itposic, itvalua,itcltcod, itpza, itdcom)
                                    values
                                      (1, ln_pitsuc,ln_pitmod, ln_trans, ln_rel, 45,2, --ln_pitord, ln_pitsbor,
                                       174, 0, ln_scsuc,9300070800001, ln_moneda, 0, ln_cuenta, ln_opera, ln_subope, ld_fecha,
                                       to_date('01/01/0001', 'dd/mm/yyyy'), 0, 0, 0, 0, 0, 0, 'N', 0, null, 0, 0, null, null, 0,
                                       1,0, 0, 0, 'N', 'N', 0, 0, null, 0,  SaldoMtoB, --impt1
                                       0,
                                       ln_pitsuc, ---bolsa
                                       0, 0, 0, 0, 0, 0,  0, 0, --impt11
                                       0, 0, 0,0, 0,0,0,0,0, --fin importes
                                       0,0,2, 0,null, 0,0, 0, 0,0, null,'N', 0, 0,0,0, 0);

                     insert into fsd016(pgcod, itsuc,itmod,ittran, itnrel, itord, itsbor, modulo,ittope,itsucd,rubro, moneda,papel, ctnro,
                                       itoper,itsubo, itfval, itfvto, itpzo, itper, itttas, ittasa, ittmor, ittdia, ittvto,  ittano,
                                       ittint, itarb, itarb1, itmd, itmd1, ittcbi, ittcbi1, itpre, itpre1, itdrev, itafiv,itafgt, itplus,
                                       itcodm, itser, itcheq, itimp1,itimp2, itimp3, itimp4, itimp5, itimp6, itimp7, itimp8, itimp9, itimp10,
                                       itimp11, itimp12, itimp13, itimp14, itimp15, itimp16, itimp17, itimp18,itimp19, itimp20,
                                       itimpo, itmdao,  itdbha, itncor, itbbtt, itfunc, itsegm, itccos, itcbcu, itccli,itref, itanu,
                                       itposic, itvalua,itcltcod, itpza, itdcom)
                                    values
                                      (1, ln_pitsuc,ln_pitmod, ln_trans, ln_rel,53,2,-- ln_pitord, ln_pitsbor,
                                       457, 0, ln_scsuc,9300071800001, ln_moneda, 0, 0, ln_opera, 0, to_date('01/01/0001', 'dd/mm/yyyy'),
                                       to_date('01/01/0001', 'dd/mm/yyyy'), 0, 0, 0, 0, 0, 0, 'N', 0, null, 0, 0, null, null, 0,
                                       1,0, 0, 0, 'N', 'N', 0, 0, null, 0,  SaldoMtob, --impt1
                                       0,
                                       0, ---bolsa
                                       0, 0, 0, 0, 0, 0,  0, 0, --impt11
                                       0, 0, 0,0, 0,0,0,0,0, --fin importes
                                       0,0,1, 0,null, 0,0, 0, 0,0, null,'N', 0, 0,0,0, 0);
                       commit;
                exception
                  when dup_val_on_index then
                    null;
                end;
                */
                /*--fin registro inicio*/
            END IF;
            if ingreso9 = 'N' then
               ln_monto1 :=   monto_cte - ln_monto ;
               if  ln_monto1 >= 0 then-- :=  ln_monto - monto_cte;---verificar
                   ln_monmov := ln_monto;--ln_monto1;
               else
                   ln_monmov := monto_cte;
               end if;
            end if;
            if ln_tipo = 9 then
             --CON ESTE PROCEDIMIENTO ACTUALIZAS LA BOLSA, ENVIARLE EL MONTO QUE DEBE DE DISMINUIR DE LA BOLSA.
                       pq_ah_comision.sp_ah_graba_bolsa(p_d_fecpro => ld_fecha,
                                                         p_n_pgcod => 1,
                                                         p_n_modulo => ln_modulo,
                                                         p_n_sucdes => ln_scsuc,
                                                         p_n_moneda => ln_moneda,
                                                         p_n_papel => 0,
                                                         p_n_ctnro => ln_cuenta,
                                                         p_n_itoper => ln_opera,
                                                         p_n_itsubo => ln_subope,
                                                         p_n_ittope => ln_tipo,
                                                         p_c_tiptrx => 'D',---lc_tiptrx,
                                                         p_n_monmov => 0,--MONTO
                                                         p_n_montem => ln_monmov,
                                                         p_n_pgemp => 1,  -- EMPRESA
                                                         p_n_itsuc => ln_pitsuc,  --SUCURSAL DEL ASIENTO
                                                         p_n_itmod => ln_pitmod,  --MODULO DEL ASIENTO
                                                         p_n_ittran => ln_trans,  -- TRANSACCION DEL ASIENTO
                                                         p_n_itnrel => ln_rel,    --RELACION DEL ASIENTO
                                                         p_n_itnord => ln_pitord  --ORDINAL DEL ASIENTO
                                                         );

             --REGISTRAMOS EN LA FSX016 EL MONTO DEBITADO DE LA BOLSA PARA UTILIZARLO EN EL EXTORNO DE SER EL CASO
             begin
               insert into fsx016 (PGCOD,
                                   HCMOD,
                                   HSUCOR,
                                   HTRAN,
                                   HNREL,
                                   HFCON,
                                   HCORD,
                                   HCSUBO,
                                   TXCOD,
                                   TXOREN,
                                   TXTORD
                                  )
                           values (1,
                                  ln_pitmod,
                                  ln_pitsuc,
                                  ln_trans,
                                  ln_rel,
                                  ld_fecha,
                                  ln_pitord,
                                  ln_pitsbor,
                                  0,
                                  999,
                                  trim(to_char(ln_monmov,'9,999,999.90'))
                                  );
               commit;
             exception
             when others then
              null;
             end;
            end if;

    -- end if;
    End if;    
  end;

  Function fn_ah_verif_monto(monto   in number,
                             moneda  in number,
                             fecha   in date,
                             moncol  in number,
                             tipoper in number)  return number is
    ln_rpta   number;
    v_importe number(17, 2);
    t_cambio  number(10,7);
    ult_fecha date;
  Begin
    select TP1IMP1
      into v_importe
      from fst198
     where TP1COD = 1
       and TP1COD1 = 10884
       and TP1CORR1 = 2
       and TP1CORR2 = 1
       and TP1CORR3 = 1;
     if  moneda = 101 then
        begin
          select tccpa into t_cambio
            from fsd120
           where tcfch = fecha
             and tchor = (select max(tchor) from fsd120  where tcfch = fecha );
         exception
           when no_data_found then
            select max(tcfch)into ult_fecha
            from fsd120;
            select tccpa into t_cambio
            from fsd120
           where tcfch = ult_fecha
             and tchor = (select max(tchor) from fsd120  where tcfch = ult_fecha  );
         end;
         ---2016/11/25
        /* if tipoper = 9 then
             v_importe := v_importe + moncol;
         end if;*/ --sma.22.01.19
         -----
         v_importe := v_importe / t_cambio;
       ----  v_importe := v_importe + m_bolsa;
         if monto <= v_importe then
            ln_rpta := 0;
         else
            ln_rpta := 1;
         end if;
     end if;
     if moneda = 0 then
       /* if tipoper = 9 then
             v_importe := v_importe + moncol;
         end if;*/
        if monto <= v_importe then
          ln_rpta := 0;
        else
          ln_rpta := 1;
        end if;
     end if;
     return(ln_rpta);
  end fn_ah_verif_monto;

  Function fn_ah_verif_nroope(ope in number) return number is
    v_nro  number;
    v_rpta number;
  Begin
    select TP1NRO1
      into v_nro
      from fst198
     where TP1COD = 1
       and TP1COD1 = 10884
       and TP1CORR1 = 2
       and TP1CORR2 = 1
       and TP1CORR3 = 2;
    if ope <= v_nro  then
      v_rpta := 0;
    else
      v_rpta := 1;
    end if;
    return(v_rpta);
  end fn_ah_verif_nroope;

  Function fn_monto_comision(ln_cuenta in number,-- datos de la cuenta
                             ln_scsuc  in number,--
                             ln_modulo in number,--
                             ln_opera  in number,--
                             ln_tipo   in number,--
                             ln_moneda in number,--
                             ln_subope in number, --datos de la cuenta
                             ld_fecfin in date,
                             ln_canal  in number,
                             ln_monto  in number
                            ) return number is
  ln_tp1nro1 number(9);
  ln_tp1nro2 number(9);
  ln_cotasap number(10,6);
  ln_cominp  number(17,2);
  ln_comaxp  number(17,2);
  ln_coimpp  number(17,2);
  ln_moncom  number(17,2):= 0;
  ln_tipcom  number(9):=1;
  begin
    if ln_monto <> 0 then
   --- if ln_canal = 1 then
      begin --Tarifarios Especiales Interplaza
       select b.jaql481com,b.jaql481coc
         into ln_tp1nro1, ln_tp1nro2
         from jaql482 a,
              jaql481 b
        where a.jaql482cct = b.jaql481cct
          and a.jaql482pge = 1
          and a.jaql482suc = ln_scsuc
          and a.jaql482cta = ln_cuenta
          and a.jaql482mod = ln_modulo
          and a.jaql482mda = ln_moneda
          and a.jaql482pap = 0
          and a.jaql482ope = ln_opera
          and a.jaql482sbo = ln_subope
          and a.jaql482top = ln_tipo
          and a.jaql482fei <= ld_fecfin
          and a.jaql482fef >= ld_fecfin
          and b.jaql481fei <= ld_fecfin
          and b.jaql481fef >= ld_fecfin
          and b.jaql481ax1 = ln_canal
          and a.jaql482ax1 = ln_tipcom --se agrego comisiones de deposito
          ;
      Exception
      When no_data_found then
        begin  --obtenemos codigo de comision por defecto
          select tp1nro1, tp1nro2
            into ln_tp1nro1, ln_tp1nro2
            from fst198
           where tp1cod1  = 10825
             and tp1corr1 = 3
             and tp1corr2 = 1
             and tp1corr3 = ln_canal;
        Exception
        When others then
             return ln_moncom;
        end;
      When others then
           return ln_moncom;
      end;
  /* else   --si no es ventanilla

      begin  --obtenemos codigo de comision por defecto
          select tp1nro1, tp1nro2
            into ln_tp1nro1, ln_tp1nro2
            from fst198
           where tp1cod1  = 10825
             and tp1corr1 = 3
             and tp1corr2 = 1
             and tp1corr3 = ln_canal;
        Exception
        When others then
             return ln_moncom;
        end;
   end if;*/

/*    begin --obtenemos parametros de comision
      select c.cotasap,c.cominp,c.comaxp,c.coimpp
        into ln_cotasap,ln_cominp,ln_comaxp,ln_coimpp
       from fsp026 c
       where c.pgcod = 1
         and c.comod = ln_tp1nro1
         and c.cocod = ln_tp1nro2
         and c.cocta = 0
         and c.copap = 0
         and c.comda = 0;
    exception
    when others then
         return ln_moncom;
    end;*/

    begin --obtenemos parametros de comision
      select w.cotasap,w.cominp,w.comaxp,w.coimpp
        into ln_cotasap,ln_cominp,ln_comaxp,ln_coimpp
        from (
              select c.cotasap,c.cominp,c.comaxp,c.coimpp
               from fsp026 c
               where c.pgcod = 1
                 and c.comod = ln_tp1nro1
                 and c.cocod = ln_tp1nro2
                 and c.cocta = 0
                 and c.copap = 0
                 and c.comda = 0
                 and c.comto >= ln_monto
            order by  c.cofech desc,c.comto asc
             ) w
       where rownum = 1;
    exception
    when others then
         return ln_moncom;
    end;


    If ln_coimpp = 0 then
        ln_moncom := round((ln_monto*ln_cotasap)/100,2);
        If ln_cominp >= ln_moncom Then        --valor minimo de comision
           ln_moncom := ln_cominp;
        ElsIf ln_comaxp <= ln_moncom Then     --valor maximo de comision
           ln_moncom := ln_comaxp;
        Else
           ln_moncom := ln_moncom;
       End If;
    Else
       ln_moncom := ln_coimpp;
    End If;
  else
    ln_moncom := 0;
  end if;
  return ln_moncom;
  end fn_monto_comision;

  --Verifica cuentas exoneradas
  Function fn_valida_cobrocom(ln_cuenta in number,-- datos de la cuenta
                              ln_scsuc  in number,--
                              ln_modulo in number,--
                              ln_opera  in number,--
                              ln_tipo   in number,--
                              ln_moneda in number,--
                              ln_subope in number, --datos de la cuenta
                              ld_fecfin in date,
                              ln_canal  in number
                             )return varchar2 is
  lc_indcob char(1):= 'S';
  LN_TP1IMP1 Number(1); ---:= 1;
  begin
     LN_TP1IMP1 := ln_canal;
     if ln_modulo = 21 then
         select 'N'
           into lc_indcob
           from jaql485
          where JAQL485PGE = 1
            and JAQL485SUC = ln_scsuc
            and JAQL485CTA = ln_cuenta
            and JAQL485MOD = ln_modulo
            and JAQL485MDA = ln_moneda
            and JAQL485PAP = 0
            and JAQL485OPE = ln_opera
            and JAQL485SBO = ln_subope
            and JAQL485TOP = ln_tipo
            and JAQL485TCO = 1
            and JAQL485FEI <= ld_fecfin
            and JAQL485FEF >= ld_fecfin
            and JAQL485AX2 = LN_TP1IMP1;
/*            and case
                when LN_TP1IMP1 = 1 then
                     JAQL485CNV
                when LN_TP1IMP1 = 2 then
                     JAQL485CNA
                when LN_TP1IMP1 = 3 then
                     JAQL485CNC
                Else
                     0
                end = 1;*/
        else
         select 'N'
           into lc_indcob
           from jaql485
          where JAQL485PGE = 1
            and JAQL485SUC = ln_scsuc
            and JAQL485CTA = ln_cuenta
            and JAQL485MOD = ln_modulo
            and JAQL485MDA = ln_moneda
            and JAQL485PAP = 0
            and JAQL485OPE = ln_opera
            --and JAQL485SBO = ln_subope
            and JAQL485TOP = ln_tipo
            and JAQL485TCO = 1
            and JAQL485FEI <= ld_fecfin
            and JAQL485FEF >= ld_fecfin
            and JAQL485AX2 = LN_TP1IMP1            
/*            and case
                when LN_TP1IMP1 = 1 then
                     JAQL485CNV
                when LN_TP1IMP1 = 2 then
                     JAQL485CNA
                when LN_TP1IMP1 = 3 then
                     JAQL485CNC
                Else
                     0
                end = 1*/
            and rownum <2;
        end if;
  return lc_indcob;
  Exception
  When others then
    lc_indcob := 'S';
    return lc_indcob;
  end fn_valida_cobrocom;
Function fn_ah_ind_data return varchar2 is
  lc_inddat char(1):='N';
  begin
     begin
            select 'S' into lc_inddat from FSD016 where rownum =1;
     Exception
     when others then
          lc_inddat := 'N';
     end;
  return lc_inddat;
  End fn_ah_ind_data;

Procedure sp_ah_calcula_comision(P_N_PGCOD  IN NUMBER,
                                   P_N_CTNRO  IN NUMBER,
                                   P_N_ITOPER IN NUMBER,
                                   P_N_ITSUBO IN NUMBER,
                                   P_N_SUCDES IN NUMBER,
                                   P_N_ITTOPE IN NUMBER,
                                   P_N_MODULO IN NUMBER,
                                   P_N_MONEDA IN NUMBER,
                                   P_N_PAPEL  IN NUMBER,
                                   P_N_ITMOD  IN NUMBER,
                                   P_N_ITTRAN IN NUMBER,
                                   P_N_CANSUC IN NUMBER,
                                   P_N_MONTO  IN NUMBER,
                                   p_n_moncom out number,
                                   p_n_nummov out number
                                  ) is
   cursor BuscaDiaT16 is
       select  trunc(f6.itimp3),
               f6.itsuc,
               decode(f6.modulo,174,((f6.itimp1)*-1),f6.itimp1) itimp1,
               f6.itimp9,
               f6.itimp13,
               f6.itmod,
               f6.ittran,
               f6.itnrel,
               (select jaqy657pza  from jaqy657 where jaqy657suc = trunc(f6.itimp3)) as plaza1, ---f6.itimp3
               (select jaqy657pza  from jaqy657 where jaqy657suc = f6.itsucd ) as plaza2
          from fsd016 f6,
               fst198 f8,
               fsd015 f5
         where f8.tp1cod = 1
           and f6.pgcod = f8.tp1cod
           and f6.itmod = f8.tp1nro1
           and f6.ittran = f8.tp1nro2
         --  and f6.itnrel <> P_N_ITNREL
           and f6.itord = f8.tp1nro3
           and f8.tp1cod1 = 10884
           and f8.TP1CORR1 = 3
           and f8.TP1CORR2 = 1
           and f8.tp1imp1 = 1
---           and f6.modulo in (21,22,174) 24/05/2019
           and (f6.modulo  in (21,22) or (f6.modulo =174 and f6.rubro = 9300070800001))
          -- and f6.ittope = P_N_ITTOPE
           and f6.itsucd = P_N_SUCDES
           and f6.moneda = P_N_MONEDA
           and f6.papel = 0
           and f6.itimp3 <> 0.00
           and f6.ctnro =  P_N_CTNRO
           and f6.itoper = P_N_ITOPER
           and f6.itsubo = P_N_ITSUBO
           and f5.itsuc = f6.itsuc
           and f5.itmod = f6.itmod
           and f5.ittran = f6.ittran
           and f5.itnrel = f6.itnrel
           and f5.itcorr <>99
           and f5.itcont = 'S'
           and (select jaqy657pza  from jaqy657 where jaqy657suc = f6.itimp3) <>(select jaqy657pza  from jaqy657 where jaqy657suc = f6.itsucd );

  cursor BuscaHisT16 (FechaIn in date,FechaFin in date) is
        select trunc(f.hcimp3),
               f.hsucor,
               decode(f.hmodul,174,((f.hcimp1)*-1),f.hcimp1) hcimp1,
               f.hfcon,
               (select jaqy657pza  from jaqy657 where jaqy657suc = trunc(f.hcimp3)) as plaza1, ---f6.itimp3
               (select jaqy657pza  from jaqy657 where jaqy657suc = f.hsucur ) as plaza2
          from fsh016 f,
               fsh015 h,
               fst198 f8
         where f8.tp1cod = 1
           and f8.tp1cod1 = 10884
           and f8.TP1CORR1 = 3
           and f8.TP1CORR2 = 1
           and f8.tp1imp1 = 1
           and f.pgcod = f8.tp1cod
           and f.hcmod = f8.tp1nro1 --moduno
           and f.htran = f8.tp1nro2 ---tranuno
           and f.hcord = f8.tp1nro3 --orduno
           and f.hfcon between FechaIn and FechaFin ---ld_fecfin
          --- and f.hmodul in (21,22,174) 24/05/2019
           and (f.hmodul in (21,22) or (f.hmodul =174 and f.hrubro =9300070800001 ))
           and f.hsucur = P_N_SUCDES
           and f.hmda   = P_N_MONEDA
           and f.hpap   = 0
           and f.hcta   = P_N_CTNRO
           and f.hoper  = P_N_ITOPER
           and f.hsubop = P_N_ITSUBO
           and f.hcimp3 <> 0.00
           and h.pgcod  = f.pgcod
           and h.hcmod  = f.hcmod
           and h.hsucor = f.hsucor
           and h.htran = f.htran
           and h.hnrel = f.hnrel
           and h.hfcon = f.hfcon
           and h.hccorr <> 99
           and (select jaqy657pza  from jaqy657 where jaqy657suc = f.hcimp3) <> (select jaqy657pza  from jaqy657 where jaqy657suc = f.hsucur );

   cursor BuscaOffline(P_fecha in date) is
     select nvl(sum(decode(z1.z0e4gcesm,1,1,-1)),0) operacion ,
            nvl(sum(decode(z1.z0e4gcesm,1,1* z1.z0e4gcimd,-1*z1.z0e4gcimd)),0) monto
          from z0e4gc z1,
               z0e475 z2
         where z1.z0e4gcest = 'ZZ'
           and z1.z0e4gcesm in (1,3)
           and z1.z0e4gctop in (1,2)
           and z1.z0e4gcfec = P_fecha
           and z1.z0e4gcdpg = P_N_PGCOD
           and z1.z0e4gcdmd = P_N_MODULO
           and z1.z0e4gcdmo = P_N_MONEDA
           and z1.z0e4gcdpa = 0
           and z1.z0e4gcdct = P_N_CTNRO
           and z1.z0e4gcdop = P_N_ITOPER
           and z1.z0e4gcdsc = P_N_ITSUBO
           and z1.z0e4gcdto = P_N_ITTOPE
           and z1.z0e4gcdsu = P_N_SUCDES
           and z2.z0e475cod = z1.z0e4gcter
           and (select jaqy657pza  from jaqy657 where jaqy657suc = z2.z0e475suc) <> (select jaqy657pza  from jaqy657 where jaqy657suc = z1.z0e4gcdsu );

  v_cont1 number := 1;
  v_monto number(17,2):= 0;
  v_ctrl1 number := 0;
  v_ctrl2 number := 0;
  control number := 0;
  FechaInicial date;
  FechaFin  date;
  FechaHoy  date;
  MontoEx number(10) := 0;
  NroOpe number(1) := 0;
  lc_indoff char(1);
  LN_TP1NRO1   number(9);
  LN_TP1NRO2   number(9);
  LN_TP1NRO3   number(9);
  LN_TP1IMP3   number(17,2);
  ln_monto     number(17,2) := 0;
  lc_indcob    char(1):= 'N';
  ln_tipocta   char(1);
  v_canal      number;
  ln_monsal    number(17,2) := 0;
  ln_monrub    number(17,2) := 0;
  ln_monexo    number(17,2) := 0;
  ln_monret    number(17,2) := 0;
  ln_monto1    number(17,2) := 0;
  ln_marca     number(17,2) := 0;
  ln_montoV    number(17,2) := 0;
  montocol     number(17,2) := 0;
  ln_tp1imp2   number:= 0;
  ln_salrem    number(17,2) := 0;
  ln_salter    number(17,2) := 0;
  ld_fechaB    date;
  valor        number := 0;
  SaldoMtoB    number(17,2) := 0;
  ln_monrub1 number(17,2) := 0;
------------------------------------
  monto_cte    number;
  IndCredVi    char(1);
  ln_monmov  number;
  ingreso9   char(1):='N';

  Begin
  if P_N_ITTOPE = 12 then
    p_n_moncom := 0;
    p_n_nummov := 0;
  Else
    p_n_moncom := 0;
    ln_monto   := P_N_MONTO;
      Begin
        select 'S'
          into ln_tipocta
          from fst198
         where TP1COD = 1
           and TP1COD1 = 10884
           and TP1CORR1 = 1
           and TP1CORR2 = 1
           and tp1nro1 = P_N_ITTOPE
           and tp1nro2 = P_N_MODULO; -- Adición de modulo 17032020 para exonerar ctas.
      Exception
        When no_data_found then
          ln_tipocta := 'N';
      end;
      select pgfape
        into ld_fechaB
        from fst017
       where pgcod = 1;

        Begin
        Select  TRUNC(TP1IMP3)
          into v_canal
          from fst198
         where TP1COD = 1
           and TP1COD1 = 10884
           and TP1CORR1 = 3
           and TP1CORR2 = 1
           and TP1NRO1 = P_N_ITMOD
           AND TP1NRO2 = P_N_ITTRAN
           and rownum = 1; -------21//11/2016
      Exception
           when no_data_found then
             v_canal := 0;
      End;
         -- Verifica tipo de Operacion
     if ln_tipocta = 'N' then
        -- verifica si transaccion esta en la guia
        If v_canal <> 0 Then
          -- Verifica interplaza
           if fn_ah_verif_interplaza(P_N_SUCDES,P_N_CANSUC) = 1 then
                  Begin
                     Select TP1NRO1,
                            TP1NRO2,
                            TP1NRO3,
                            TP1IMP3
                       into LN_TP1NRO1,  --modulo
                            LN_TP1NRO2,  -- transaccion
                            LN_TP1NRO3,  --ordinal
                            LN_TP1IMP3   -- canal
                       from fst198
                      where tp1cod      = 1
                        and tp1cod1     = 10884
                        and tp1corr1    = 3
                        and TP1NRO1     = P_N_ITMOD
                        and TP1NRO2     = P_N_ITTRAN
                        and rownum      = 1;
                        lc_indcob := 'S';
                  Exception
                    When no_data_found then
                     lc_indcob := 'N';
                    When others then
                     lc_indcob := 'N';
                  End;

                -- verificamos si esta exonerado
                If lc_indcob = 'S' then
                  begin
                   select 'N'
                     into lc_indcob
                     from jaql485
                    where JAQL485PGE = P_N_PGCOD
                      and JAQL485SUC = P_N_SUCDES
                      and JAQL485CTA = P_N_CTNRO
                      and JAQL485MOD = P_N_MODULO
                      and JAQL485MDA = P_N_MONEDA
                      and JAQL485PAP = P_N_PAPEL
                      and JAQL485OPE = P_N_ITOPER
                      and JAQL485SBO = P_N_ITSUBO
                      and JAQL485TOP = P_N_ITTOPE
                      and JAQL485TCO = 3
                      and JAQL485FEI <= trunc(sysdate)
                      and JAQL485FEF >= trunc(sysdate)
                      and JAQL485AX2 = LN_TP1IMP3
/*                      and case
                          when LN_TP1IMP3 = 1 then
                               JAQL485CNV
                          when LN_TP1IMP3 = 2 then
                               JAQL485CNA
                          when LN_TP1IMP3 = 3 then
                               JAQL485CNC
                          Else
                               0
                          end = 1*/;
                  Exception
                  When others then
                    lc_indcob := 'S';
                  end;

                  /*--CAMBIOS MONTO EXONERADO*/
                  begin
                      select --tp1imp2
                             tp1imp1,tp1imp2
                        into valor,ln_tp1imp2
                        from fst198
                       where tp1cod = 1
                         and tp1cod1 = 10884
                         and TP1CORR1 = 3
                         and TP1CORR2 = 1
                         and tp1nro1 = P_N_ITMOD
                         and tp1nro2 = P_N_ITTRAN
                         and tp1nro3 = 10--ln_pitord
                         and tp1imp1 = 1
                         and tp1imp3 = v_canal;
                    exception
                      when no_data_found then
                        valor := 0;
                    end;
                    if P_N_ITTOPE = 9 then

                      /*montoCol := pq_ah_comision.fn_ah_monto_ac ( P_N_PGCOD,
                                                                 P_N_MODULO,
                                                                 P_N_CTNRO,
                                                                 P_N_ITOPER,
                                                                 P_N_ITSUBO,
                                                                 P_N_ITTOPE,
                                                                 P_N_SUCDES,
                                                                 P_N_MONEDA,
                                                                 P_N_PAPEL);*/
                       --CON ESTE PROCEDIMIENTO TE RETORNA EL MONTO ACTUAL DISPONIBLE DE LA BOLSA Y EL INDICADOR SI AUN TIENNE CREDITOS VIGENTES ASOCIADOS A DICHA CUENTA DE AHORRO CORRIENTE
                   -- Call the procedure
                        select pgfape
                          into FechaHoy
                          from fst017
                         where pgcod = P_N_PGCOD;
                     pq_ah_comision.sp_ah_consu_bolsa(p_n_pgcod => P_N_PGCOD,
                                                     p_n_modulo => P_N_MODULO,
                                                     p_n_sucdes => P_N_SUCDES,
                                                     p_n_moneda => P_N_MONEDA,
                                                     p_n_papel => 0,
                                                     p_n_ctnro => P_N_CTNRO,
                                                     p_n_itoper => P_N_ITOPER,
                                                     p_n_itsubo => P_N_ITSUBO,
                                                     p_n_ittope => P_N_ITTOPE,
                                                     p_d_fecpro => FechaHoy,
                                                     p_n_mtosal => monto_cte, --SALDO RESTANTE EN BOLSA
                                                     p_c_indcre => IndCredVi); --INDICADOR DE CREDITO S= SI TIENE N= NO TIENE

                    end if;
                    if lc_indcob = 'S' and ln_tp1imp2 = 1 and P_N_ITTOPE <> 9 then

                         --obtenemos el monto del rubro de exoneracion
                         if P_N_ITTOPE <> 6 then

                            pq_ah_comision.sp_ah_monto_rubro(p_n_pgcod  => P_N_PGCOD,
                                                             p_n_ctnro  => P_N_CTNRO,
                                                             p_n_itoper => P_N_ITOPER,
                                                             p_n_itsubo => P_N_ITSUBO,
                                                             p_n_sucdes => P_N_SUCDES,
                                                             p_n_moneda => P_N_MONEDA,
                                                             p_n_papel  => P_N_PAPEL,
                                                             p_n_monto  => ln_monrub
                                                             );
                         else
                           if P_N_ITTOPE = 6 then
                             pq_ah_comision.sp_ah_saldos_remu(P_N_PGCOD => P_N_PGCOD,
                                                              P_N_MODULO => P_N_MODULO,
                                                              P_N_CTNRO => P_N_CTNRO,
                                                              P_N_ITOPER => P_N_ITOPER,
                                                              P_N_ITSUBO => P_N_ITSUBO,
                                                              P_N_ITTOPE => P_N_ITTOPE,
                                                              P_N_SUCDES => P_N_SUCDES,
                                                              P_N_MONEDA => P_N_MONEDA,
                                                              P_N_PAPEL => P_N_PAPEL,
                                                              p_n_saldo => ln_salrem,
                                                              p_n_salte => ln_salter
                                                             );
                            pq_ah_comision.sp_ah_monto_rubro(p_n_pgcod  => P_N_PGCOD,
                                                             p_n_ctnro  => P_N_CTNRO,
                                                             p_n_itoper => P_N_ITOPER,
                                                             p_n_itsubo => P_N_ITSUBO,
                                                             p_n_sucdes => P_N_SUCDES,
                                                             p_n_moneda => P_N_MONEDA,
                                                             p_n_papel  => P_N_PAPEL,
                                                             p_n_monto  => ln_monrub1
                                                             );

                               if (ln_salrem + ln_monrub1)> 0  and ln_tp1imp2 = 1 then
                                 ln_monrub := ln_salrem + ln_monrub1;
                               else
                                  ln_monrub := 0;
                               end if;
                            end if;
                        end if;
                         ln_monexo := ln_monsal + ln_monrub;
                          --obtenemos total monto retirado SIN AFECTO A COMISION

                         ln_monret := ln_monret + ln_monto; --total retirado incluido movimiento actual

                         if ln_monexo >= ln_monret then
                            lc_indcob := 'N';
                            ln_marca  := 0;
                            p_n_nummov := 0;
                            SaldoMtoB := ln_monret;
                         else
                            lc_indcob := 'S';
                            if ln_monexo <> 0 then
                               ln_marca := ln_monto - ln_monexo;
                               SaldoMtoB :=ln_monexo;
                            else
                               ln_marca := ln_monto;--0;
                            end if;
                         end if;
                        /* if SaldoMtoB > 0 and P_N_ITTOPE = 6 then
                            begin

                                  insert into fsd016(pgcod, itsuc,itmod,ittran, itnrel, itord, itsbor, modulo,ittope,itsucd,rubro, moneda,papel, ctnro,
                                                     itoper,itsubo, itfval, itfvto, itpzo, itper, itttas, ittasa, ittmor, ittdia, ittvto,  ittano,
                                                     ittint, itarb, itarb1, itmd, itmd1, ittcbi, ittcbi1, itpre, itpre1, itdrev, itafiv,itafgt, itplus,
                                                     itcodm, itser, itcheq, itimp1,itimp2, itimp3, itimp4, itimp5, itimp6, itimp7, itimp8, itimp9, itimp10,
                                                     itimp11, itimp12, itimp13, itimp14, itimp15, itimp16, itimp17, itimp18,itimp19, itimp20,
                                                     itimpo, itmdao,  itdbha, itncor, itbbtt, itfunc, itsegm, itccos, itcbcu, itccli,itref, itanu,
                                                     itposic, itvalua,itcltcod, itpza, itdcom)
                                                  values
                                                    (1, P_N_CANSUC,P_n_itmod, p_n_ittran, p_n_, 45 ,2 , --ln_pitord, ln_pitsbor,
                                                     174, 0, ln_scsuc,9300070800001, p_n_moneda, 0, p_n_ctnro, P_N_ITOPER, P_N_ITSUBO, ld_fecha,
                                                     to_date('01/01/0001', 'dd/mm/yyyy'), 0, 0, 0, 0, 0, 0, 'N', 0, null, 0, 0, null, null, 0,
                                                     1,0, 0, 0, 'N', 'N', 0, 0, null, 0,  SaldoMtoB, --impt1
                                                     0,
                                                     P_N_CANSUC, ---bolsa
                                                     0, 0, 0, 0, 0, 0,  0, 0, --impt11
                                                     0, 0, 0,0, 0,0,0,0,0, --fin importes
                                                     0,0,2, 0,null, 0,0, 0, 0,0, null,'N', 0, 0,0,0, 0);

                                   insert into fsd016(pgcod, itsuc,itmod,ittran, itnrel, itord, itsbor, modulo,ittope,itsucd,rubro, moneda,papel, ctnro,
                                                     itoper,itsubo, itfval, itfvto, itpzo, itper, itttas, ittasa, ittmor, ittdia, ittvto,  ittano,
                                                     ittint, itarb, itarb1, itmd, itmd1, ittcbi, ittcbi1, itpre, itpre1, itdrev, itafiv,itafgt, itplus,
                                                     itcodm, itser, itcheq, itimp1,itimp2, itimp3, itimp4, itimp5, itimp6, itimp7, itimp8, itimp9, itimp10,
                                                     itimp11, itimp12, itimp13, itimp14, itimp15, itimp16, itimp17, itimp18,itimp19, itimp20,
                                                     itimpo, itmdao,  itdbha, itncor, itbbtt, itfunc, itsegm, itccos, itcbcu, itccli,itref, itanu,
                                                     itposic, itvalua,itcltcod, itpza, itdcom)
                                                  values
                                                    (1, ln_pitsuc,ln_pitmod, ln_trans, ln_rel,53,2,-- ln_pitord, ln_pitsbor,
                                                     457, 0, ln_scsuc,9300071800001, ln_moneda, 0, 0, ln_opera, 0, to_date('01/01/0001', 'dd/mm/yyyy'),
                                                     to_date('01/01/0001', 'dd/mm/yyyy'), 0, 0, 0, 0, 0, 0, 'N', 0, null, 0, 0, null, null, 0,
                                                     1,0, 0, 0, 'N', 'N', 0, 0, null, 0,  SaldoMtob, --impt1
                                                     0,
                                                     0, ---bolsa
                                                     0, 0, 0, 0, 0, 0,  0, 0, --impt11
                                                     0, 0, 0,0, 0,0,0,0,0, --fin importes
                                                     0,0,1, 0,null, 0,0, 0, 0,0, null,'N', 0, 0,0,0, 0);
                                     commit;
                              exception
                                when dup_val_on_index then
                                  null;
                              end;
                         end if;*/
                    end if;
                   /*-FIN CAMBIOS -*/

    ----VERIFICACION DE LOS MONTOS
                  If lc_indcob = 'S' then
                    /*begin
                        insert into jaqy670
                          (jaqy670pgc,
                           jaqy670suc,
                           JAQY670mod,
                           JAQY670trx,
                           JAQY670rel,
                           JAQY670fec,
                           JAQY670ini)
                        values
                          (1,
                           ln_pitsuc,
                           ln_pitmod,
                           ln_trans,
                           ln_rel,
                           ld_fecha,
                           sysdate
                           );
                           commit;
                      Exception
                      When others then
                           null;
                  end;*/
                  -- Fecha Inicial y Final
                        select to_date('01' || TO_CHAR(pgfape, 'MM') || TO_CHAR(pgfape, 'YYYY'),'dd/mm/yyyy'),
                               last_day(pgfape),
                               pgfape
                          into FechaInicial,
                               FechaFin,
                               FechaHoy
                          from fst017
                         where pgcod = P_N_PGCOD;

                        --- Monto Exonerado
                          if P_N_MONEDA = 101 then
                            if P_N_ITTOPE <> 9 then
                                select round(TP1IMP1/ fn_tipo_cambio(fecha  => trunc(sysdate),
                                                                                monori => P_N_MONEDA,
                                                                                mondes => 0,
                                                                                tipo   => 500
                                                                                ),2)
                                  into MontoEx
                                  from fst198
                                 where TP1COD = 1
                                   and TP1COD1 = 10884
                                   and TP1CORR1 = 2
                                   and TP1CORR2 = 1
                                   and TP1CORR3 = 1;
                          /*  else
                               select round((TP1IMP1 + montocol)/ fn_tipo_cambio(fecha  => trunc(sysdate),
                                                                                  monori => P_N_MONEDA,
                                                                                  mondes => 0,
                                                                                  tipo   => 500
                                                                                  ),2)
                                  into MontoEx
                                  from fst198
                                 where TP1COD = 1
                                   and TP1COD1 = 10884
                                   and TP1CORR1 = 2
                                   and TP1CORR2 = 1
                                   and TP1CORR3 = 1;*/

                            end if;
                          else
                            select TP1IMP1
                              into MontoEx
                              from fst198
                             where TP1COD = 1
                               and TP1COD1 = 10884
                               and TP1CORR1 = 2
                               and TP1CORR2 = 1
                               and TP1CORR3 = 1;
                            /* if P_N_ITTOPE = 9 then
                               MontoEx := MontoEx + montocol;
                             end if;*/
                          end if;

                        -- Nro operaciones Permitidas
                        select TP1NRO1
                          into NroOpe
                          from fst198
                         where TP1COD = 1
                           and TP1COD1 = 10884
                           and TP1CORR1 = 2
                           and TP1CORR2 = 1
                           and TP1CORR3 = 2;

                      ---****** Nueva Forma de Cobro Interplaza ***------
                        select opgval into lc_indoff from fst200 where opgcod=544;

                        if lc_indoff = 'S' then --online
                           if FechaHoy = trunc(sysdate) then
                              if substr(to_char(FechaHoy,'dd/mm/yyyy'),1,2) = '01'then  -- verif 1er dia
                                  For reg in BuscaDiaT16 loop
                                       if (monto_cte > 0) and (IndCredVi = 'S') then
                                           if reg.itimp1 > 0 then ---new
                                              v_cont1 := v_cont1 + 1;
                                              v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                           end if;
                                       else
                                          if P_N_ITTOPE <> 9 then
                                             v_monto := v_monto + reg.itimp1 ;
                                             v_ctrl1 := fn_ah_verif_monto(v_monto, P_N_MONEDA,FechaHoy, montoCol,P_N_ITTOPE);

                                             if reg.itimp1 > 0 then ---new
                                                v_cont1 := v_cont1 + 1;
                                                v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                              else
                                               v_cont1 := v_cont1 - 1;
                                               v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                             end if;
                                          else
                                            if reg.itimp1 > 0 then ---new
                                              v_cont1 := v_cont1 + 1;
                                              v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                            end if;
                                          end if;
                                       end if;
                                  end loop;
                                  IF P_N_ITTOPE  = 9 THEN ---sma 19032019
                                    if (monto_cte - ln_monto)> 0 and (IndCredVi = 'S') then
                                      v_ctrl1 := 0;
                                     elsif (monto_cte - ln_monto)> 0  then
                                       v_ctrl1 := 0;
                                    else
                                       v_ctrl1 := 1;
                                    end if;
                                  END IF;
                                  if ln_marca <> 0 then ---2016/11/03
                                      ln_montoV := ln_marca;
                                  else
                                    ln_montoV := P_N_MONTO;
                                  end if;
                                    if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
                                           if P_N_ITTOPE = 9 then
                                               if IndCredVi = 'S' then
                                                  if (monto_cte - ln_monto)> 0 then
                                                    control := 0;
                                                  else
                                                    control := 1;
                                                  end if;
                                               else
                                                 control := 1;
                                               end if;
                                             else
                                               control := 1;
                                             end if;
                                    elsif  fn_ah_verif_monto(ln_montoV, P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE )= 1 then --P_N_MONTO
                                         control := 1;
                                    elsif fn_ah_verif_monto((ln_montoV + v_monto), P_N_MONEDA, FechaHoy, montoCol,P_N_ITTOPE )= 1 then --P_N_MONTO
                                         control := 1;
                                    end if;
                              else
                                  For reg in BuscaDiaT16 loop
                                     if(monto_cte > 0) and (IndCredVi = 'S')then
                                        if reg.itimp1  > 0 then
                                            v_cont1 := v_cont1 + 1;
                                            v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                         end if;
                                     else
                                       if P_N_ITTOPE <> 9 then
                                           v_monto := v_monto + reg.itimp1 ;
                                           v_ctrl1 := fn_ah_verif_monto(v_monto, P_N_MONEDA,FechaHoy, montoCol,P_N_ITTOPE);
                                           v_cont1 := v_cont1 + 1;
                                           if reg.itimp1  > 0 then

                                             v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                           else
                                             v_cont1 := v_cont1 - 1;
                                             v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                           end if;
                                       else
                                         if reg.itimp1  > 0 then
                                              v_cont1 := v_cont1 + 1;
                                             v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                         end if;
                                       end if;
                                     end if;
                                  end loop;
                                  IF P_N_ITTOPE = 9 THEN ---sma 19032019
                                    if (monto_cte - ln_monto)> 0 and (IndCredVi = 'S') then
                                      v_ctrl1 := 0;
                                     elsif (monto_cte - ln_monto)> 0  then
                                         v_ctrl1 := 0;
                                      else
                                         v_ctrl1 := 1;
                                    end if;
                                  END IF;
                                  if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
                                       if P_N_ITTOPE = 9 then
                                         if IndCredVi = 'S' then
                                            if (monto_cte - ln_monto)> 0 then
                                              control := 0;
                                            else
                                              control := 1;
                                            end if;
                                         else
                                           control := 1;
                                         end if;
                                       else
                                         control := 1;
                                       end if;
                                  end if;
                                  -- Busca Movimientos Historicos
                                  For reh in BuscaHisT16(FechaInicial,FechaFin) loop
                                    if (monto_cte > 0) and (IndCredVi = 'S') then
                                        if reh.hcimp1 > 0 then
                                           v_cont1 := v_cont1 + 1;
                                           v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                        end if;
                                    else
                                        if P_N_ITTOPE <> 9 then
                                            v_monto := v_monto +  reh.hcimp1;
                                            v_ctrl1 :=  fn_ah_verif_monto(v_monto, P_N_MONEDA, reh.hfcon,montoCol,P_N_ITTOPE );

                                            if reh.hcimp1 > 0 then
                                               v_cont1 := v_cont1 + 1;
                                               v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                             else
                                                 v_cont1 := v_cont1 - 1;
                                                 v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                            end if;
                                        else
                                          if reh.hcimp1 > 0 then
                                               v_cont1 := v_cont1 + 1;
                                               v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                          end if;
                                        end if;
                                    end if;
                                  end loop;
                                  IF P_N_ITTOPE = 9 THEN ---sma 19032019
                                    if (monto_cte - ln_monto)> 0 and (IndCredVi = 'S') then
                                      v_ctrl1 := 0;
                                     elsif (monto_cte - ln_monto)> 0  then
                                         v_ctrl1 := 0;
                                      else
                                         v_ctrl1 := 1;
                                    end if;
                                  END IF;
                                  if ln_marca <> 0 then ---2016/11/03
                                    ln_montoV := ln_marca;
                                  else
                                    ln_montoV := P_N_MONTO;
                                  end if;
                                  if (v_ctrl1 = 1) or (v_ctrl2 = 1) then--
                                           if P_N_ITTOPE = 9 then
                                             if IndCredVi = 'S' then
                                                if (monto_cte - ln_monto)> 0 then
                                                  control := 0;
                                                else
                                                  control := 1;
                                                end if;
                                             else
                                               control := 1;
                                             end if;
                                           else
                                             control := 1;
                                           end if;
                                  elsif  fn_ah_verif_monto(ln_montoV, P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE )= 1 then
                                       control := 1;
                                  elsif fn_ah_verif_monto((ln_montoV + v_monto), P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE )= 1 then
                                       control := 1;
                                  end if;
                              end if;
                           Else
                             IF fn_ah_ind_data ='N' then
                                -- Busca Movimientos Historicos
                                For reh in BuscaHisT16(FechaInicial,FechaFin) loop
                                    IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                                       if reh.hcimp1 >0 then
                                         v_cont1 := v_cont1 + 1;
                                         v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                       end if;
                                    ELSE
                                      if P_N_ITTOPE <> 9 then
                                          v_monto := v_monto +  reh.hcimp1;
                                          v_ctrl1 := fn_ah_verif_monto(v_monto, P_N_MONEDA, reh.hfcon, montoCol,P_N_ITTOPE );

                                          if reh.hcimp1 >0 then
                                             v_cont1 := v_cont1 + 1;
                                             v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                          else
                                               v_cont1 := v_cont1 - 1;
                                               v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                          end if;
                                      else
                                         if reh.hcimp1 >0 then
                                             v_cont1 := v_cont1 + 1;
                                             v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                         end if;
                                      end if;
                                    END IF;
                                end loop;
                                IF P_N_ITTOPE= 9 THEN ---sma 19032019
                                  if (monto_cte - ln_monto)> 0 and (IndCredVi = 'S') then
                                    v_ctrl1 := 0;
                                  elsif (monto_cte - ln_monto)> 0  then
                                     v_ctrl1 := 0;
                                  else
                                     v_ctrl1 := 1;
                                  end if;
                                END IF;

                                if ln_marca <> 0 then ---2016/11/03
                                    ln_montoV := ln_marca;
                                else
                                    ln_montoV := P_N_MONTO;
                                end if;

                                if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
                                         if P_N_ITTOPE = 9 then
                                             if IndCredVi = 'S' then
                                                if (monto_cte - ln_monto)> 0 then
                                                  control := 0;
                                                else
                                                  control := 1;
                                                end if;
                                             else
                                               control := 1;
                                             end if;
                                           else
                                             control := 1;
                                           end if;
                                elsif  fn_ah_verif_monto(ln_montoV, P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE )= 1 then
                                     control := 1;
                                elsif fn_ah_verif_monto((ln_montoV + v_monto), P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE )= 1 then
                                     control := 1;
                                end if;
                             Else
                               if substr(to_char(FechaHoy,'dd/mm/yyyy'),1,2) = '01' then
                                  For reg in BuscaDiaT16 loop
                                      IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                                         if reg.itimp1 > 0 then
                                             v_cont1 := v_cont1 + 1;
                                              v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                           end if;
                                      ELSE
                                           v_monto := v_monto + reg.itimp1 ;
                                           v_ctrl1 := fn_ah_verif_monto(v_monto, P_N_MONEDA,FechaHoy,montoCol,P_N_ITTOPE);
                                           if reg.itimp1 > 0 then
                                              v_cont1 := v_cont1 + 1;
                                              v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                            else
                                               v_cont1 := v_cont1 - 1;
                                               v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                           end if;
                                       END IF;
                                  end loop;
                                    IF P_N_ITTOPE= 9 THEN ---sma 19032019
                                      if (monto_cte - ln_monto)> 0 and (IndCredVi = 'S') then
                                        v_ctrl1 := 0;
                                      elsif (monto_cte - ln_monto)> 0  then
                                         v_ctrl1 := 0;
                                      else
                                         v_ctrl1 := 1;
                                      end if;
                                    END IF;
                                    if ln_marca <> 0 then ---2016/11/03
                                      ln_montoV := ln_marca;
                                    else
                                      ln_montoV := P_N_MONTO;
                                    end if;
                                    if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
                                           if P_N_ITTOPE = 9 then
                                               if IndCredVi = 'S' then
                                                  if (monto_cte - ln_monto)> 0 then
                                                    control := 0;
                                                  else
                                                    control := 1;
                                                  end if;
                                               else
                                                 control := 1;
                                               end if;
                                             else
                                               control := 1;
                                             end if;
                                    elsif  fn_ah_verif_monto(ln_montov, P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE )= 1 then
                                         control := 1;
                                    elsif fn_ah_verif_monto((ln_montov + v_monto), P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE )= 1 then
                                         control := 1;
                                    end if;
                               Else
                                  For reg in BuscaDiaT16 loop
                                      IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                                           if reg.itimp1 > 0 then
                                              v_cont1 := v_cont1 + 1;
                                              v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                           end if;
                                      eLSE
                                          if P_N_ITTOPE <> 9 then
                                             v_monto := v_monto + reg.itimp1 ;
                                             v_ctrl1 := fn_ah_verif_monto(v_monto, P_N_MONEDA,FechaHoy,montoCol,P_N_ITTOPE);

                                             if reg.itimp1 > 0 then
                                                v_cont1 := v_cont1 + 1;
                                                v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                             else
                                               v_cont1 := v_cont1 - 1;
                                               v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                             end if;
                                          else
                                            if reg.itimp1 > 0 then
                                                v_cont1 := v_cont1 + 1;
                                                v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                            end if;
                                          end if;
                                       END IF;
                                  end loop;
                                  IF P_N_ITTOPE= 9 THEN ---sma 19032019
                                    if (monto_cte - ln_monto)> 0 and (IndCredVi = 'S') then
                                      v_ctrl1 := 0;
                                    elsif (monto_cte - ln_monto)> 0  then
                                     v_ctrl1 := 0;
                                    else
                                     v_ctrl1 := 1;
                                    end if;
                                  END IF;
                                  if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
                                         if P_N_ITTOPE = 9 then
                                           if IndCredVi = 'S' then
                                              if (monto_cte - ln_monto)> 0 then
                                                control := 0;
                                              else
                                                control := 1;
                                              end if;
                                           else
                                             control := 1;
                                           end if;
                                         else
                                           control := 1;
                                         end if;
                                  end if;
                                  -- Busca Movimientos Historicos
                                  For reh in BuscaHisT16(FechaInicial,FechaFin) loop
                                    IF(monto_cte > 0) and (IndCredVi = 'S') THEN
                                        if reh.hcimp1 > 0 then
                                           v_cont1 := v_cont1 + 1;
                                           v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                        end if;
                                    ELSE
                                      if P_N_ITTOPE <> 9 then
                                          v_monto := v_monto +  reh.hcimp1;
                                          v_ctrl1 := fn_ah_verif_monto(v_monto, P_N_MONEDA, reh.hfcon ,montoCol,P_N_ITTOPE);

                                          if reh.hcimp1 > 0 then
                                             v_cont1 := v_cont1 + 1;
                                             v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                          else
                                             v_cont1 := v_cont1 - 1;
                                             v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                          end if;
                                       else
                                         if reh.hcimp1 > 0 then
                                             v_cont1 := v_cont1 + 1;
                                             v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                         end if;
                                       end if;
                                    END IF;
                                  end loop;
                                  IF P_N_ITTOPE= 9 THEN ---sma 19032019
                                    if (monto_cte - ln_monto)> 0 and (IndCredVi = 'S') then
                                      v_ctrl1 := 0;
                                    elsif (monto_cte - ln_monto)> 0  then
                                     v_ctrl1 := 0;
                                    else
                                     v_ctrl1 := 1;
                                    end if;
                                  END IF;
                                  if ln_marca <> 0 then ---2016/11/03
                                    ln_montoV := ln_marca;
                                  else
                                    ln_montoV := P_N_MONTO;
                                  end if;
                                  if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
                                         if P_N_ITTOPE = 9 then
                                             if IndCredVi = 'S' then
                                                if (monto_cte - ln_monto)> 0 then
                                                  control := 0;
                                                else
                                                  control := 1;
                                                end if;
                                             else
                                               control := 1;
                                             end if;
                                           else
                                             control := 1;
                                           end if;
                                  elsif  fn_ah_verif_monto(ln_montoV, P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE )= 1 then
                                       control := 1;
                                  elsif fn_ah_verif_monto((ln_montoV + v_monto), P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE )= 1 then
                                       control := 1;
                                  end if;
                               end if;
                             end if;
                           end if;
                         Else
                             if fn_ah_ind_data = 'S' then
                                if substr(to_char(FechaHoy,'dd/mm/yyyy'),1,2) = '01' then
                                   For reg in BuscaDiaT16 loop
                                      IF(monto_cte > 0) and (IndCredVi = 'S') THEN
                                          if reg.itimp1 > 0 then
                                            v_cont1 := v_cont1 + 1;
                                            v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                          end if;
                                       ELSE
                                         if P_N_ITTOPE <> 9 then
                                             v_monto := v_monto + reg.itimp1 ;
                                             v_ctrl1 := fn_ah_verif_monto(v_monto, P_N_MONEDA,FechaHoy,montoCol,P_N_ITTOPE);

                                             if reg.itimp1 > 0 then
                                                 v_cont1 := v_cont1 + 1;
                                                v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                             else
                                               v_cont1 := v_cont1 - 1;
                                               v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                             end if;
                                         else
                                            if reg.itimp1 > 0 then
                                                v_cont1 := v_cont1 + 1;
                                                v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                            end if;
                                         end if;
                                       END IF;
                                    end loop;
                                    IF P_N_ITTOPE= 9 THEN ---sma 19032019
                                      if (monto_cte - ln_monto)> 0 and (IndCredVi = 'S') then
                                        v_ctrl1 := 0;
                                      elsif (monto_cte - ln_monto)> 0  then
                                         v_ctrl1 := 0;
                                      else
                                         v_ctrl1 := 1;
                                      end if;
                                    END IF;
                                    if ln_marca <> 0 then ---2016/11/03
                                      ln_montoV := ln_marca;
                                    else
                                      ln_montoV := P_N_MONTO;
                                    end if;
                                    if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
                                           if P_N_ITTOPE = 9 then
                                             if IndCredVi = 'S' then
                                                if (monto_cte - ln_monto)> 0 then
                                                  control := 0;
                                                else
                                                  control := 1;
                                                end if;
                                             else
                                               control := 1;
                                             end if;
                                           else
                                             control := 1;
                                           end if;
                                    elsif  fn_ah_verif_monto(ln_montov, P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE )= 1 then
                                       control := 1;
                                    elsif fn_ah_verif_monto((ln_montov + v_monto), P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE )= 1 then
                                         control := 1;
                                    end if;
                                else
                                   For reg in BuscaDiaT16 loop
                                       IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                                           if reg.itimp1 > 0 then
                                              v_cont1 := v_cont1 + 1;
                                              v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                           end if;
                                       ELSE
                                          if P_N_ITTOPE <> 9 then
                                               v_monto := v_monto + reg.itimp1 ;
                                               v_ctrl1 := fn_ah_verif_monto(v_monto, P_N_MONEDA,FechaHoy, montoCol,P_N_ITTOPE);

                                               if reg.itimp1 > 0 then
                                                  v_cont1 := v_cont1 + 1;
                                                  v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                                else
                                                 v_cont1 := v_cont1 - 1;
                                                 v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                               end if;
                                           else
                                              if reg.itimp1 > 0 then
                                                  v_cont1 := v_cont1 + 1;
                                                  v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                              end if;
                                           end if;
                                       End if;
                                  end loop;
                                  IF P_N_ITTOPE= 9 THEN ---sma 19032019
                                    if (monto_cte - ln_monto)> 0 and (IndCredVi = 'S') then
                                      v_ctrl1 := 0;
                                    elsif (monto_cte - ln_monto)> 0  then
                                     v_ctrl1 := 0;
                                    else
                                     v_ctrl1 := 1;
                                    end if;
                                  END IF;
                                  if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
                                       if P_N_ITTOPE = 9 then
                                             if IndCredVi = 'S' then
                                                if (monto_cte - ln_monto)> 0 then
                                                  control := 0;
                                                else
                                                  control := 1;
                                                end if;
                                             else
                                               control := 1;
                                             end if;
                                           else
                                             control := 1;
                                           end if;
                                  end if;
                                  -- Busca Movimientos Historicos
                                  For reh in BuscaHisT16(FechaInicial,FechaFin) loop
                                    IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                                       if reh.hcimp1 > 0 then
                                         v_cont1 := v_cont1 + 1;
                                         v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                      end if;
                                    ELSE
                                      if  P_N_ITTOPE <> 9 then
                                          v_monto := v_monto +  reh.hcimp1;
                                          v_ctrl1 := fn_ah_verif_monto(v_monto, P_N_MONEDA, reh.hfcon,montoCol,P_N_ITTOPE );

                                          if reh.hcimp1 > 0 then
                                             v_cont1 := v_cont1 + 1;
                                             v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                           else
                                               v_cont1 := v_cont1 - 1;
                                               v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                          end if;
                                       else
                                         if reh.hcimp1 > 0 then
                                             v_cont1 := v_cont1 + 1;
                                             v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                         end if;
                                       end if;
                                    END IF;
                                  end loop;
                                    IF P_N_ITTOPE= 9 THEN ---sma 19032019
                                      if (monto_cte - ln_monto)> 0 and (IndCredVi = 'S') then
                                        v_ctrl1 := 0;
                                     elsif (monto_cte - ln_monto)> 0  then
                                         v_ctrl1 := 0;
                                      else
                                         v_ctrl1 := 1;
                                      end if;
                                    END IF;
                                   if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
                                         if P_N_ITTOPE = 9 then
                                             if IndCredVi = 'S' then
                                                if (monto_cte - ln_monto)> 0 then
                                                  control := 0;
                                                else
                                                  control := 1;
                                                end if;
                                             else
                                               control := 1;
                                             end if;
                                           else
                                             control := 1;
                                         end if;
                                  end if;
                                  -- Busca Offline
                                  For reo in BuscaOffline (trunc(sysdate))loop
                                    IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                                      if reo.monto > 0 then
                                         v_cont1 := v_cont1 + reo.operacion ;
                                         v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                      end if;
                                    ELSE
                                      if P_N_ITTOPE <> 9 then
                                          v_monto := v_monto + reo.monto;
                                          v_ctrl1 := fn_ah_verif_monto(v_monto, P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE );

                                          if reo.monto > 0 then
                                             v_cont1 := v_cont1 + 1 ;
                                             v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                          else
                                               v_cont1 := v_cont1 - 1;
                                               v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                          end if;
                                       else
                                          if reo.monto > 0 then
                                             v_cont1 := v_cont1 + reo.operacion ;
                                             v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                          end if;
                                       end if;
                                    END IF;
                                  end Loop;
                                  if ln_marca <> 0 then ---2016/11/03
                                    ln_montoV := ln_marca;
                                  else
                                    ln_montoV := P_N_MONTO;
                                  end if;
                                  IF P_N_ITTOPE= 9 THEN ---sma 19032019
                                      if (monto_cte - ln_monto)> 0 and (IndCredVi = 'S') then
                                        v_ctrl1 := 0;
                                      elsif (monto_cte - ln_monto)> 0  then
                                         v_ctrl1 := 0;
                                      else
                                         v_ctrl1 := 1;
                                      end if;
                                  END IF;
                                  if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
                                         if P_N_ITTOPE = 9 then
                                             if IndCredVi = 'S' then
                                                if (monto_cte - ln_monto)> 0 then
                                                  control := 0;
                                                else
                                                  control := 1;
                                                end if;
                                             else
                                               control := 1;
                                             end if;
                                           else
                                             control := 1;
                                           end if;
                                  elsif  fn_ah_verif_monto(ln_montov, P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE )= 1 then
                                       control := 1;
                                  elsif fn_ah_verif_monto((ln_montov + v_monto), P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE )= 1 then
                                       control := 1;
                                  end if;
                                end if;
                             else
                                -- Busca Movimientos Historicos
                                  For reh in BuscaHisT16(FechaInicial,FechaFin) loop
                                    IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                                      if reh.hcimp1 > 0 then
                                         v_cont1 := v_cont1 + 1;
                                         v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                      end if;
                                    ELSE
                                      if P_N_ITTOPE <> 9 then
                                          v_monto := v_monto +  reh.hcimp1;
                                          v_ctrl1 := fn_ah_verif_monto(v_monto, P_N_MONEDA, reh.hfcon,montoCol,P_N_ITTOPE );

                                          if reh.hcimp1 > 0 then
                                             v_cont1 := v_cont1 + 1;
                                             v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                         else
                                             v_cont1 := v_cont1 - 1;
                                             v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                          end if;
                                       else
                                          if reh.hcimp1 > 0 then
                                             v_cont1 := v_cont1 + 1;
                                             v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                          end if;
                                       end if;
                                    END IF;
                                  end loop;
                                  IF P_N_ITTOPE= 9 THEN ---sma 19032019
                                      if (monto_cte - ln_monto)> 0 and (IndCredVi = 'S') then
                                        v_ctrl1 := 0;
                                      elsif (monto_cte - ln_monto)> 0  then
                                         v_ctrl1 := 0;
                                      else
                                        v_ctrl1 := 1;
                                      end if;
                                   END IF;
                                   if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
                                         if P_N_ITTOPE = 9 then
                                             if IndCredVi = 'S' then
                                                if (monto_cte - ln_monto)> 0 then
                                                  control := 0;
                                                else
                                                  control := 1;
                                                end if;
                                             else
                                               control := 1;
                                             end if;
                                           else
                                             control := 1;
                                           end if;
                                  end if;
                                  -- Busca Offline
                                  For reo in BuscaOffline (trunc(sysdate))loop
                                    IF (monto_cte > 0) and (IndCredVi = 'S') THEN
                                        if reo.monto > 0 then
                                          v_cont1 := v_cont1 + reo.operacion ;
                                          v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                        end if;
                                    ELSE
                                      if P_N_ITTOPE <> 9 then
                                          v_monto := v_monto + reo.monto;
                                          v_ctrl1 := fn_ah_verif_monto(v_monto, P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE );

                                          if reo.monto > 0 then
                                            v_cont1 := v_cont1 + 1;
                                            v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                         else
                                             v_cont1 := v_cont1 - 1;
                                             v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                          end if;
                                      ELSE
                                         if reo.monto > 0 then
                                            v_cont1 := v_cont1 + reo.operacion ;
                                            v_ctrl2 := fn_ah_verif_nroope(v_cont1);
                                         END IF;
                                      END IF;
                                    END IF;
                                  end Loop;
                                  IF P_N_ITTOPE= 9 THEN ---sma 19032019
                                    if (monto_cte - ln_monto)> 0 and (IndCredVi = 'S') then
                                      v_ctrl1 := 0;
                                    elsif (monto_cte - ln_monto)> 0  then
                                       v_ctrl1 := 0;
                                    else
                                       v_ctrl1 := 1;
                                    end if;
                                  END IF;
                                  if ln_marca <> 0 then ---2016/11/03
                                    ln_montoV := ln_marca;
                                  else
                                    ln_montoV := P_N_MONTO;
                                  end if;
                                  if (v_ctrl1 = 1) or (v_ctrl2 = 1) then
                                         if P_N_ITTOPE = 9 then
                                             if IndCredVi = 'S' then
                                                if (monto_cte - ln_monto)> 0 then
                                                  control := 0;
                                                else
                                                  control := 1;
                                                end if;
                                             else
                                               control := 1;
                                             end if;
                                           else
                                             control := 1;
                                           end if;

                                  elsif  fn_ah_verif_monto(ln_montoV, P_N_MONEDA, FechaHoy ,montoCol,P_N_ITTOPE)= 1 then
                                       control := 1;
                                  elsif fn_ah_verif_monto((ln_montoV + v_monto), P_N_MONEDA, FechaHoy,montoCol,P_N_ITTOPE )= 1 then
                                       control := 1;
                                  end if;
                             end if;
                        End if;
                        if control = 1 then
                           --lc_rpta := 1;
                           --VERIFICAMOS EXONERACIÓN
                            lc_indcob := pq_ah_com_interplaza.fn_valida_cobrocom(ln_cuenta => P_N_CTNRO,
                                                                                 ln_scsuc  => P_N_SUCDES,
                                                                                 ln_modulo => P_N_MODULO,
                                                                                 ln_opera  => P_N_ITOPER,
                                                                                 ln_tipo   => P_N_ITTOPE,
                                                                                 ln_moneda => P_N_MONEDA,
                                                                                 ln_subope => P_N_ITSUBO,
                                                                                 ld_fecfin => FechaHoy,--ld_fecfin
                                                                                 ln_canal  => v_canal
                                                                                 );
                           -- Aplica comisión
                           If lc_indcob = 'S' then
                             if P_N_ITTOPE <> 9 then
                               ln_monto1 := P_N_MONTO - ln_monexo;
                               --OBTENEMOS MONTO DE COMISION--nuevo

                               if  v_cont1 >  NroOpe then
                                  IF ln_monexo > 0 or montoCol > 0 THEN
                                    -- v_monto := ln_monto1;---07/11/2016
                                     if  v_monto = 0 then
                                        --if ln_monto >= MontoEx then
                                          v_monto := ln_monto1 - MontoEx ;
                                        --end if;
                                     else
                                         if v_monto < MontoEx  then ---19/11/2016
                                           -- if (v_monto + ln_monto )>= MontoEx then

                                               v_monto := (v_monto + ln_monto1)-MontoEx;
                                           -- end if;
                                         else
                                           if v_monto >= MontoEx then
                                             v_monto := ln_monto1;
                                           end if;
                                         end if;
                                     end if;
                                  ELSE
                                     v_monto := ln_monto1; -- P_N_MONTO;
                                  end if;
                               else
                                 if  v_monto = 0 then
                                    --if ln_monto >= MontoEx then
                                      v_monto := ln_monto1 - MontoEx ; --P_N_MONTO - MontoEx ;
                                    --end if;
                                 else
                                   if v_monto < MontoEx then
                                     -- if (v_monto + P_N_MONTO )>= MontoEx then
                                         v_monto := (v_monto + ln_monto1)-MontoEx;
                                     -- end if;
                                   else
                                     if v_monto >= MontoEx then
                                       v_monto := ln_monto1;
                                     end if;
                                   end if;
                                 end if;
                               end if;               ----
                            else
                              ingreso9 := 'S';
                                 ln_monto1 :=   monto_cte - ln_monto ;
                                 if IndCredVi = 'S' then
                                    if  ln_monto1 >= 0 then-- :=  ln_monto - monto_cte;---verificar
                                        v_monto := 0;
                                        ln_monmov := P_N_MONTO;--ln_monto1;
                                    else
                                        v_monto := ABS(ln_monto1);
                                        ln_monmov := monto_cte;
                                    end if;
                                 else
                                     --OBTENEMOS MONTO DE COMISION--nuevo
                                     if  v_cont1 >  NroOpe then
                                         v_monto := P_N_MONTO;
                                          if  ln_monto1 >= 0 then-- :=  P_N_MONTO - monto_cte;---verificar
                                              ln_monmov := P_N_MONTO;--ln_monto1;
                                          else
                                              ln_monmov := monto_cte;
                                          end if;
                                     else
                                       if  v_monto = 0 then
                                          v_monto := ABS(ln_monto1);
                                          if  ln_monto1 >= 0 then-- :=  ln_monto - monto_cte;---verificar
                                             ln_monmov := ln_monto;--ln_monto1;
                                          else
                                              ln_monmov := monto_cte;
                                          end if;
                                       end if;
                                     end if;
                                 end if;
                            end if;

                                If P_N_MONEDA = 101 Then
                                  v_monto := round(v_monto* fn_tipo_cambio(fecha   => FechaHoy, ---ld_fecfin,
                                                                            monori => P_N_MONEDA,
                                                                            mondes => 0,
                                                                            tipo   => 500
                                                                           ),2);
                                End If;

                                p_n_moncom := pq_ah_com_interplaza.fn_monto_comision(ln_cuenta => P_N_CTNRO,
                                                                                    ln_scsuc  => P_N_SUCDES,
                                                                                    ln_modulo => P_N_MODULO,
                                                                                    ln_opera  => P_N_ITOPER,
                                                                                    ln_tipo   => P_N_ITTOPE,
                                                                                    ln_moneda => P_N_MONEDA,
                                                                                    ln_subope => P_N_ITSUBO,
                                                                                    ld_fecfin => FechaHoy, --ld_fecfin,
                                                                                    ln_canal  => v_canal,
                                                                                    ln_monto  => v_monto
                                                                                    );
                                If P_N_MONEDA = 101 Then
                                  p_n_moncom := round(p_n_moncom/ fn_tipo_cambio(fecha  => FechaHoy,--ld_fecfin,
                                                                                 monori => P_N_MONEDA,
                                                                                 mondes => 0,
                                                                                 tipo   => 500
                                                                                ),2);
                                End If;
                                p_n_nummov := v_cont1;

                         end if;
                      Else
                          p_n_moncom := 0;
                      End If;
                end if;
              end if;
           end if;
        end if;
    end if;
  end if;
  ---------------------
            if ingreso9 = 'N' then
               ln_monto1 :=   monto_cte - ln_monto ;
               if  ln_monto1 >= 0 then-- :=  ln_monto - monto_cte;---verificar
                   ln_monmov := ln_monto;--ln_monto1;
               else
                   ln_monmov := monto_cte;
               end if;
            end if;
             --CON ESTE PROCEDIMIENTO ACTUALIZAS LA BOLSA, ENVIARLE EL MONTO QUE DEBE DE DISMINUIR DE LA BOLSA.
             If P_N_ITTOPE = 9 then
                       pq_ah_comision.sp_ah_graba_bolsa(p_d_fecpro => ld_fechaB,
                                                         p_n_pgcod => P_N_PGCOD,
                                                         p_n_modulo => P_N_MODULO,
                                                         p_n_sucdes => P_N_SUCDES,
                                                         p_n_moneda => P_N_MONEDA,
                                                         p_n_papel => 0,
                                                         p_n_ctnro => P_N_CTNRO,
                                                         p_n_itoper => P_N_ITOPER,
                                                         p_n_itsubo => P_N_ITSUBO,
                                                         p_n_ittope => P_N_ITTOPE,
                                                         p_c_tiptrx => 'D',---lc_tiptrx,
                                                         p_n_monmov => 0,--MONTO
                                                         p_n_montem => ln_monmov,
                                                         p_n_pgemp => 1,  -- EMPRESA
                                                         p_n_itsuc => P_N_CANSUC,  --SUCURSAL DEL ASIENTO
                                                         p_n_itmod => P_N_ITMOD,  --MODULO DEL ASIENTO
                                                         p_n_ittran => P_N_ITTRAN, -- TRANSACCION DEL ASIENTO
                                                         p_n_itnrel => 0,  --RELACION DEL ASIENTO
                                                         p_n_itnord => 0  --ORDINAL DEL ASIENTO
                                                         );
             End If;

  ----------------------
  end sp_ah_calcula_comision;
  FUNCTION fn_ah_verif_interplaza(P_SUCPAGO IN NUMBER,
                                  P_SUCORIG IN NUMBER)
    return number is
    plaza1 number;
    plaza2 number;
    valor  number := 0;
  Begin
    Begin
      select jaqy657pza
        into plaza1
        from jaqy657
       where jaqy657suc = p_sucpago;
    Exception
      When others then
        plaza1 := 0;
    end;
    Begin
      select jaqy657pza
        into plaza2
        from jaqy657
       where jaqy657suc = p_sucorig;
    Exception
      When others then
        plaza2 := 0;
    end;
    if plaza1 <> 0 and plaza2 <> 0 then
        if plaza1 = plaza2 then
          valor := 0;
        else
          valor := 1;
        end if;
    end if;
    return(valor);
  END FN_AH_VERIF_INTERPLAZA;
  Procedure sp_ah_monto_intplz_tipo9(ln_cuenta in number,-- da
                                     ln_scsuc  in number,--
                                     ln_modulo in number,--
                                     ln_opera  in number,--
                                     ln_tipo   in number,--
                                     ln_moneda in number,--
                                     ln_subope in number,--dat
                                     ln_trans  in number,
                                     ln_rel    in number,
                                     ld_fecha  in date,
                                     ln_pitsuc in number,
                                     ln_pitmod in number,
                                     ln_pitord in number,
                                     ln_pitsbor in number,
                                     ln_monto  in number,
                                     ln_canal  in number,
                                     ln_plaza1 in number,
                                     ln_plaza2 in number,
                                     lc_rpta   out number
                                     )is

  cursor BuscaDiaT16 is
       select  trunc(f6.itimp3),
               f6.itsuc,
               decode(f6.modulo,174,((f6.itimp1)*-1),f6.itimp1) itimp1,
               f6.itimp9,
               f6.itimp13,
               f6.itmod,
               f6.ittran,
               f6.itnrel,
               (select jaqy657pza  from jaqy657 where jaqy657suc = trunc(f6.itimp3)) as plaza1,
               (select jaqy657pza  from jaqy657 where jaqy657suc = f6.itsucd ) as plaza2
          from fsd016 f6,
               fst198 f8,
               fsd015 f5
         where f8.tp1cod = 1
           and f6.pgcod = f8.tp1cod
           and f6.itmod = f8.tp1nro1
           and f6.ittran = f8.tp1nro2
           and f6.itnrel <> ln_rel
           and f6.itord = f8.tp1nro3
           and f8.tp1cod1 = 10884
           and f8.TP1CORR1 = 3
           and f8.TP1CORR2 = 1
           and f8.tp1imp1 = 1
           and f6.modulo  in (21,22,174)
           and f6.itsucd = ln_scsuc
           and f6.moneda = ln_moneda
           and f6.papel = 0
           and f6.itimp3 <> 0.00
           and f6.ctnro =  ln_cuenta
           and f6.itoper = ln_opera
           and f6.itsubo = ln_subope
           and f5.itsuc = f6.itsuc
           and f5.itmod = f6.itmod
           and f5.ittran = f6.ittran
           and f5.itnrel = f6.itnrel
           and f5.itcorr <>99
           and f5.itcont = 'S'
           and (select jaqy657pza  from jaqy657 where jaqy657suc = f6.itimp3) <>(select jaqy657pza  from jaqy657 where jaqy657suc = f6.itsucd );

  cursor BuscaHisT16 (FechaIn in date,FechaFin in date) is
        select trunc(f.hcimp3),
               f.hsucor,
               decode(f.hmodul,174,((f.hcimp1)*-1),f.hcimp1) hcimp1,
               f.hfcon,
               (select jaqy657pza  from jaqy657 where jaqy657suc = trunc(f.hcimp3)) as plaza1,
               (select jaqy657pza  from jaqy657 where jaqy657suc = f.hsucur ) as plaza2
          from fsh016 f,
               fsh015 h,
               fst198 f8
         where f8.tp1cod = 1
           and f8.tp1cod1 = 10884
           and f8.TP1CORR1 = 3
           and f8.TP1CORR2 = 1
           and f8.tp1imp1 = 1
           and f.pgcod = f8.tp1cod
           and f.hcmod = f8.tp1nro1 --moduno
           and f.htran = f8.tp1nro2 ---tranuno
           and f.hcord = f8.tp1nro3 --orduno
           and f.hfcon between FechaIn and FechaFin ---ld_fecfin
           and f.hmodul in (21,22,174)---= ln_modulo
           and f.hsucur = ln_scsuc
           and f.hmda   = ln_moneda
           and f.hpap   = 0
           and f.hcta   = ln_cuenta
           and f.hoper  = ln_opera
           and f.hsubop = ln_subope
           and f.hcimp3 <> 0.00
           and h.pgcod  = f.pgcod
           and h.hcmod  = f.hcmod
           and h.hsucor = f.hsucor
           and h.htran = f.htran
           and h.hnrel = f.hnrel
           and h.hfcon = f.hfcon
           and h.hccorr <> 99
           and (select jaqy657pza  from jaqy657 where jaqy657suc = f.hcimp3) <> (select jaqy657pza  from jaqy657 where jaqy657suc = f.hsucur );
  begin
    null;
  end;
END PQ_AH_COM_INTERPLAZA;
/

