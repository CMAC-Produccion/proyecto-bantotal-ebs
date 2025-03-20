create or replace package pq_cr_acl_report is

	-- Author  : HSUAREZ
	-- Created : 20/11/2018 4:03:37 p. m.
	-- Purpose : Paquete para crear procesos que generan reportes en plsql
  --         : 2019.03.13 DCASTRO Se modificaron procesos para generacion de tramas

  -----------------------------------------------------------
	procedure sp_cr_arqueo_age_bob(FechaIni in date, FechaFin in date);
  -----------------------------------------------------------
  procedure sp_cr_arqueo_atm(FechaIni in date,FechaFin in date);
  -----------------------------------------------------------
  procedure sp_cr_sobr_falt( FechaIni in date,
                             FechaFin in date
                           );
  -----------------------------------------------------------                           
  procedure sp_cr_detalle_sbr_flt( FechaIni  in date,--f.tp1corr3,
                                   FechaFin  in date,--f.tp1nro1,
                                   ve_itmod  in number,
                                   ve_ittran in number,
                                   ve_itord  in number,
                                   ve_itsbor in number,
                                   ve_txcod  in number,
                                   vi_tip_rpt in varchar
                                 );
  -----------------------------------------------------------                                 
  function trabajador_caja(ve_ctnro in number) return varchar;
  -----------------------------------------------------------
  procedure sp_cr_movimientos_cta(ve_ubuser in char);
  -----------------------------------------------------------
  procedure sp_cr_movimientos_analista(ve_ubuser in char);
  -----------------------------------------------------------
  procedure sp_cr_retiros(/*ve_ubuser in char,*/ve_fecini in date,ve_fecfin in date);
  -----------------------------------------------------------
  procedure sp_cr_grabar_movimientos(ve_ubuser in char,ve_fecini in date, ve_fecfin in date);
  -----------------------------------------------------------
  procedure sp_cr_deposito_plazo_fijo_v(ve_fecini in date, ve_fecfin in date);
  -----------------------------------------------------------
  procedure sp_cr_deposito_plazo_fijo_c(ve_fecini in date, ve_fecfin in date);
  -----------------------------------------------------------
  procedure sp_cr_flujo_prestamo(vec_fecini in date, vec_fecfin in date);
  -----------------------------------------------------------
  procedure sp_cr_cambio_tasa(vec_fecini in date, vec_fecfin in date);
  -----------------------------------------------------------
end pq_cr_acl_report;
/

create or replace package body pq_cr_acl_report is
--2019.03.13 DCASTRO Se modificaron procesos para generacion de tramas
/*
  -- Private type declarations
  type <TypeName> is <Datatype>;
  
  -- Private constant declarations
  <ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  <VariableName> <Datatype>;

  -- Function and procedure implementations
  function <FunctionName>(<Parameter> <Datatype>) return <Datatype> is
    <LocalVariable> <Datatype>;
  begin
    <Statement>;
    return(<Result>);
  end;
*/
  procedure sp_cr_arqueo_age_bob(FechaIni in date, 
                                 FechaFin in date
                      )
  is 
  str varchar(100);
  begin
        str := 'TRUNCATE TABLE jaqz671';
        execute immediate(str);
        commit;
        str := 'TRUNCATE TABLE jaqz671a';  --2019.03.13
        execute immediate(str);
        commit;

        --Arqueo Bovedad Inopinado
        begin
            insert into JAQZ671
                (
                  jaqz671suc , --Agencia
                  jaqz671usa , --Ejecutor
                  jaqz671fea , --Fecha 
                  jaqz671hor , --Hora
                  jaqz671bmn , --BilletajeMN
                  jaqz671bme , --BilletajeME
                  jaqz671dmn , --DiferenciaMN 
                  jaqz671dme , --DiferenciaME
                  jaqz671usv   --UsuarioVentanilla. 
                )    
                select d.sucursal Agencia, --Agencia
                       d.usuario Ejecutor, --d.Usuario_arqueo Ejecutor,--Ejecutor
                       d.fecha Fecha, -- Fecha Arqueo
                       d.hora Hora,   -- Hora de Arqueo
                       sum(d.Billetaje_MN) Billetaje_MN, -- Billetaje Soles
                       sum(d.Billetaje_ME) Billetaje_ME, -- Billetaje Dolares
                       sum(d.Diferencia_MN) Diferencia_MN, -- Diferencia Soles
                       sum(d.Diferencia_ME) Diferencia_ME, -- Diferencia Dolares
                       d.usuario usuario -- Usuario de Ventanilla
                  from (select m.mbccsuc sucursal, -- Agencia
                               m.mbccusu Ejecutor,  -- o.mbc10spr Usuario_Arqueo,--Ejecutor
                               m.mbccfch fecha,    -- Fecha Arqueo
                               m.mbcchra hora,     -- Hora de Arqueo
                               (case n.mbcdmda
                                 when 0 then
                                  n.mbcdsdo
                                 else
                                  0
                               end) Billetaje_MN, --Billetaje Soles
                               (case n.mbcdmda
                                 when 101 then
                                  n.mbcdsdo
                                 else
                                  0
                               end) Billetaje_ME, --Billetaje Dolares
                               case
                                 when m.mbccest = 'D' and n.mbcdmda = 0 then
                                  (n.mbcdsdo - sum(n.mbcdimp))
                                 else
                                  0
                               end Diferencia_MN, --Diferencia Soles
                               case
                                 when m.mbccest = 'D' and n.mbcdmda = 101 then
                                  (n.mbcdsdo - sum(n.mbcdimp))
                                 else
                                  0
                               end Diferencia_ME, --Diferencia Dolares
                               m.mbccusu usuario --Usuario de Ventanilla           
                          from mbc004 m, mbc005 n
                         where m.mbccemp = n.mbccemp
                           and m.mbccsuc = n.mbccsuc
                           and m.mbccusu = n.mbccusu
                           and m.mbcccaj = n.mbcccaj
                           and m.mbccfch = n.mbccfch
                           and m.mbcchra = n.mbcchra
                           and m.mbccfch >= FechaIni
                           and m.mbccfch <= FechaFin
                           and n.mbcccaj  = 0
                         group by m.mbccsuc, -- Agencia                 
                                  m.mbccfch, -- Fecha Arqueo
                                  m.mbcchra, -- Hora
                                  n.mbcdmda, -- Moneda
                                  m.mbccest, -- Estado
                                  n.mbcdsdo, -- Saldo
                                  m.mbccusu  -- Usuario
                        ) d
                 group by d.sucursal, -- Agencia
                          d.fecha,    -- Fecha Arqueo
                          d.hora,     -- Hora de Arqueo
                          d.usuario;  -- Usuario Ventanilla
          end;
        -------------------------------------------------------------------------
        begin 
              insert into JAQZ671a
              (
                jaqz671asuc , --Agencia
                jaqz671ausa , --Ejecutor
                jaqz671afea , --Fecha 
                jaqz671ahor , --Hora
                jaqz671abmn , --BilletajeMN
                jaqz671abme , --BilletajeME
                jaqz671admn , --DiferenciaMN 
                jaqz671adme , --DiferenciaME
                jaqz671ausv , --UsuarioVentanilla. 
                jaqz671aest   --Estado del Arqueo, (C)
              )                  
              select
                 d.sucursal       Agencia,--Agencia
                 d.Usuario_arqueo Ejecutor,--Ejecutor
                 d.fecha          Fecha,--Fecha Arqueo
                 d.hora           Hora,--Hora de Arqueo
                 sum(d.Billetaje_MN) Billetaje_MN,--Billetaje Soles
                 sum(d.Billetaje_ME) Billetaje_ME,--Billetaje Dolares
                 sum(d.Diferencia_MN) Diferencia_MN, --Diferencia Soles
                 sum(d.Diferencia_ME) Diferencia_ME,--Diferencia Dolares
                 d.usuario            usuario,--Usuario de Ventanilla
                 d.MBCCEST
             from (
                    select
                           m.mbccsuc sucursal,--Agencia
                           o.mbc10spr Usuario_Arqueo,--Ejecutor
                           m.mbccfch fecha,--Fecha Arqueo
                           m.mbcchra hora,--Hora de Arqueo
                           (case n.mbcdmda when 0 then n.mbcdsdo else 0 end) Billetaje_MN,--Billetaje Soles
                           (case n.mbcdmda when 101 then n.mbcdsdo else 0 end)  Billetaje_ME,--Billetaje Dolares
                           case 
                             when m.mbccest='D' and n.mbcdmda=0 then 
                               (n.mbcdsdo - sum(n.mbcdimp)) 
                              else 0 
                                end Diferencia_MN, --Diferencia Soles
                           case 
                             when m.mbccest='D' and n.mbcdmda=101 then 
                               (n.mbcdsdo - sum(n.mbcdimp)) 
                              else 0 
                                end Diferencia_ME,--Diferencia Dolares
                           m.mbccusu usuario,--Usuario de Ventanilla
                           m.MBCCEST
                     from  mbc004 m, mbc005 n, mbc010 o
                     where m.mbccemp = n.mbccemp
                       and m.mbccsuc = n.mbccsuc
                       and m.mbccusu = n.mbccusu
                       and m.mbcccaj = n.mbcccaj
                       and m.mbccfch = n.mbccfch
                       and m.mbcchra = n.mbcchra
                       and m.mbccfch >= FechaIni
                       and m.mbccfch <= FechaFin
                       --and m.mbccusu = 'MANAMURO'
                       --and m.mbccest in ('C','D')
                       and o.mbc10emp = m.mbccemp
                       and o.mbc10suc = m.mbccsuc
                       and o.mbc10usr = m.mbccusu
                       and o.mbc10caj = m.mbcccaj
                       and o.mbc10fech = m.mbccfch
                       and o.mbc10hra = m.mbcchra
                     group by m.mbccsuc,--Agencia
                              o.mbc10spr,--Ejecutor
                              m.mbccfch,--Fecha Arqueo
                              m.mbcchra,
                              n.mbcdmda,
                              m.mbccest,
                              n.mbcdsdo,
                              m.mbccusu --Hora de Arqueo
                  )d
                  group by
                        d.sucursal,           --Agencia
                        d.Usuario_Arqueo,     --Ejecutor
                        d.fecha,              --Fecha Arqueo
                        d.hora,               --Hora de Arqueo
                        d.usuario,             --Usuario Ventanilla.
                        d.MBCCEST ;            ----Estado del Arqueo 2019.03.13
          end;
            
      commit; --2019.03.13 
  exception when others then  --2019.03.13
      null;
  
  end sp_cr_arqueo_age_bob;

  procedure sp_cr_arqueo_atm(FechaIni in date,
                             FechaFin in date)
                             is
      --Arqueo ATM
      str varchar(100);
      begin
       str := 'TRUNCATE TABLE jaqz671b';
       execute immediate(str);
       commit;
       insert into JAQZ671b
              (
                jaqz671bsuc , --Agencia
                jaqz671busa , --Ejecutor
                jaqz671busc , --Confirma.
                jaqz671bfea , --Fecha
                jaqz671bhor , --Hora
                jaqz671bbmn , --Billetaje MN
                jaqz671bbme , --Billetaje ME
                jaqz671bdmn , --Diferencia_MN
                jaqz671bdme , --Diferencia_ME
                jaqz671bdesc, --Descripcion ATM
                jaqz671batm   --Codigo_ATM
              )  
      select 
           jaql527agarq Agencia, --Agencia
					 trim(jaql527usuej) Ejecutor, --Ejecutor   2019.03.13
           trim(jaql527usuco) Confirmador, --Confirma 2019.03.13
					 jaql527fearq Fecha, --Fecha
					 jaql527hoarq Hora, --Hora
					 (select sum(JAQL528DENOM * JAQL528CANTI)
							from jaql528
						 where jaql527idarq = j7.jaql527idarq
							 and jaql528comon = 0
						 group by jaql528comon) Billetaje_MN, --Billetaje_MN
					 (select sum(JAQL528DENOM * JAQL528CANTI)
							from jaql528
						 where jaql527idarq = j7.jaql527idarq
							 and jaql528comon = 101
						 group by jaql528comon) Billetaje_ME, --Billetaje_ME
					 jaql527dspso Diferencia_MN, --Diferencia_MN
					 jaql527dspdo Diferencia_ME, --Diferencia_ME
					 --Descripcion ATM.
					 z0.z0e475dsc Descripcion, --Descripcion ATM.
					 to_char(jaql527atarq) atm --Usuario      
			from jaql527 j7, z0e475 z0
		 where j7.jaql527atarq = z0.z0e475cod
       and j7.jaql527fearq>=FechaIni  --Variable Inicio
       and j7.jaql527fearq<=FechaFin;
      commit; --2019.03.13 
  exception when others then  --2019.03.13
      null;
  end;
  -----------------------------------------------------------
  -----------------------------------------------------------
  procedure sp_cr_sobr_falt( FechaIni in date,
                             FechaFin in date
                           ) is
  ------------------------
  -- Cursor para movimientos diarios. 
  ------------------------           
  cursor mov_diario( cr_itmod in number,
                     cr_ittran in number ) is
                     
  select Itcont, -- Contabilización
         Itfcon, -- Fecha de Transacción (Reporte: Itfcon)
         Ituing, -- Código de Usuario (Reporte: Ituing)
         Itucnf, -- Usuario que Confirmo 
         Itnrel, -- Numero de Relación
         itcorr, -- Correlativo
         itsuc,  -- Sucursal
         pgcod,  -- Codigo de Instancia
         itmod,  -- Modulo de transaccion
         ittran  -- Transaccion .
    from fsd015  f
   where pgcod  = 1
     and itmod  = cr_itmod
     and ittran = cr_ittran;
  ------------------------
  -- Cursor para movimientos historicos. 
  ------------------------      
  cursor mov_historico( cr_itmod in number,
                        cr_ittran in number
                        ) is
                     
  select 
         f.hfcon, -- Fecha de Transacción (Reporte: Itfcon)
         f.husing, -- Código de Usuario (Reporte: Ituing)
         f.huscnf, -- Usuario que Confirmo 
         f.hnrel, -- Numero de Relación
         f.hccorr, -- Correlativo
         f.hsucor,  -- Sucursal
         f.pgcod,  -- Codigo de Instancia
         f.hcmod,  -- Modulo de transaccion
         f.htran  -- Transaccion .
    from fsh015  f
   where pgcod  = 1
     and hcmod  = cr_itmod
     and htran  = cr_ittran
     and hfcon >= FechaIni
     and hfcon <= FechaFin;  
  ------------------------
  -- Cursores para Transacciones.
  ------------------------                              
  cursor Trans_sobrante is
  select f.tp1corr3,
         f.tp1nro1,
         f.tp1nro2,
         f.tp1nro3,
         f.Tp1imp1,
         f.Tp1imp2
  from
  fst198 f
  where f.tp1cod  = 1
    and f.tp1cod1 = 10891
    and f.tp1corr1= 3
    and f.tp1corr2= 1;
  ----------------------
  ----------------------   
  cursor Trans_faltante is
  select f.tp1corr3,
         f.tp1nro1,
         f.tp1nro2,
         f.tp1nro3,
         f.Tp1imp1,
         f.Tp1imp2
  from
  fst198 f
  where f.tp1cod  = 1
    and f.tp1cod1 = 10891
    and f.tp1corr1= 3
    and f.tp1corr2= 2;
 ---------------------------------------------
 ---------------------------------------------
 ---------------------------------------------   
 cursor TrReg_sobrante_caj is
  select f.tp1corr3,
         f.tp1nro1,
         f.tp1nro2,
         f.tp1nro3,
         f.Tp1imp1,
         f.Tp1imp2
  from
  fst198 f
  where f.tp1cod  = 1
    and f.tp1cod1 = 10891
    and f.tp1corr1= 10
    and f.tp1corr2= 1
    and f.tp1corr3>0;
 cursor TrReg_faltante_caj is
  select f.tp1corr3,
         f.tp1nro1,
         f.tp1nro2,
         f.tp1nro3,
         f.Tp1imp1,
         f.Tp1imp2
  from 
  fst198 f
  where f.tp1cod  = 1
    and f.tp1cod1 = 10891
    and f.tp1corr1= 10
    and f.tp1corr2= 2
    and f.tp1corr3> 0;
    
 cursor TrReg_sobrante_atm is
  select f.tp1corr3,
         f.tp1nro1,
         f.tp1nro2,
         f.tp1nro3,
         f.Tp1imp1,
         f.Tp1imp2
  from 
  fst198 f
  where f.tp1cod  = 1
    and f.tp1cod1 = 10891
    and f.tp1corr1= 10
    and f.tp1corr2= 3
    and f.tp1corr3> 0;
 cursor TrReg_faltante_atm is
  select f.tp1corr3,
         f.tp1nro1,
         f.tp1nro2,
         f.tp1nro3,
         f.Tp1imp1,
         f.Tp1imp2
  from 
  fst198 f
  where f.tp1cod  = 1
    and f.tp1cod1 = 10891
    and f.tp1corr1= 10
    and f.tp1corr2= 4
    and f.tp1corr3> 0;
 
 ---------------
 ---------------
 vi_txcod number;
 vi_pgfape date;
 ---------------
 vi_tip_rpt varchar2(50);
 vi_itcont char(1);
 vi_itfcon date;
 vi_itucnf fsd015.itucnf%type;
 vi_ituing fsd015.ituing%type;
 vi_itnrel fsd015.itnrel%type;
 vi_itcorr fsd015.itcorr%type;
 vi_itsuc  fsd015.itsuc%type;
 vi_pgcod  fsd015.pgcod%type;
 vi_itmod  fsd015.itmod%type;
 vi_ittran fsd015.ittran%type;
 vi_Flgreg char(1);
 vi_MtoGen number(17,2);
 vi_Ctnro  fsr008.ctnro%type;
 vi_Moneda fsd010.aocta%type;
 vi_Papel  fsd010.aopap%type;
 vi_Modulo fsd010.aomod%type;
 vi_Itoper fsd010.aooper%type;
 vi_itsucor fsd016.itsuc%type;
 vi_Itsubo fsd010.aosbop%type;
 vi_Ittope fsd010.aotope%type;
 vi_hsubop fsd010.aosbop%type;
 vi_mosign varchar(20);
 vi_Cadmot varchar(10);
 vi_Concad number(12);
 vi_txtord fsx016.txtord%type;
 vi_ubnom  fst746.ubnom%type;
 vi_NumCta varchar(12);
 vi_result varchar(9);
 
 vi_itsucR  fsd016.itsuc%type;
 vi_itmodR  fsd016.itmod%type;
 vi_ittranR fsd016.ittran%type;
 vi_itnrelR fsd016.itnrel%type;
 vi_itfvalR fsd016.itfval%type;
 vi_Monto_Reg fsd016.itimp1%type;
 vi_itordR fsd016.itord%type;
 
 vi_fec_reg   date;
 vi_usui_reg  fsd015.ituing%type;
 vi_usuc_reg  fsd015.itucnf%type;
 --
 str varchar(100);  
 ---------------
 begin
        begin
            select pgfape
            into   vi_pgfape
            from fst017
            where pgcod=1;
          end;  
        
        
        str := 'TRUNCATE TABLE AQPA601';
        execute immediate(str);
         
        --Sobrantes Cargando datos.
        for cv in Trans_sobrante loop
          --Inicializando valores.
          begin
                 select txcod
                 into vi_txcod   
                 from fst235
                 where pgcod = 1
                   and trmod = cv.tp1nro1
                   and trnro = cv.tp1nro2;
            exception 
              when others then
                   vi_txcod := 0;       
              end; 
          vi_tip_rpt := 'Sobrante';
           ---Extrae el motivo asociado al sobrante
           begin
              --Extrae las transacciones de sobrantes o faltantes del día.  
              if vi_Flgreg = 3 then --borrar
                if FechaIni = vi_Pgfape or FechaFin = vi_Pgfape then
                   begin
                       pq_cr_acl_report.sp_cr_detalle_sbr_flt( FechaIni,
                                                               FechaFin,
                                                               cv.tp1nro1,
                                                               cv.tp1nro2,
                                                               cv.tp1nro3,
                                                               cv.tp1imp1,
                                                               vi_txcod,
                                                               vi_tip_rpt
                                                              );
                    end;
                end if;
              end if;--borrar temporal.                 
              --Extrae las transacciones de sobrantes
              if FechaIni <> vi_Pgfape or FechaFin <> vi_Pgfape then
                  begin
                      pq_cr_acl_report.sp_cr_detalle_sbr_flt( FechaIni,
                                                              FechaFin,
                                                              cv.tp1nro1,
                                                              cv.tp1nro2,
                                                              cv.tp1nro3,
                                                              cv.tp1imp1,
                                                              vi_txcod,
                                                              vi_tip_rpt
                                                             );
                    end;
              end if; -- Fin condicion para consultar movimiento Historico                 
           end;          
         end loop;
         --Faltantes Cargando datos.
         for cv in Trans_faltante loop
          --Inicializando valores.
          begin
                 select txcod
                 into vi_txcod   
                 from fst235
                 where pgcod = 1
                   and trmod = cv.tp1nro1
                   and trnro = cv.tp1nro2;
            exception 
              when others then
                   vi_txcod := 0;       
              end; 
          vi_tip_rpt := 'Faltante';
           ---Extrae el motivo asociado al sobrante
           begin
              --Extrae las transacciones de sobrantes o faltantes del día.  
              if vi_Flgreg = 3 then --borrar
                if FechaIni = vi_Pgfape or FechaFin = vi_Pgfape then
                   begin
                       pq_cr_acl_report.sp_cr_detalle_sbr_flt( FechaIni,
                                                               FechaFin,
                                                               cv.tp1nro1,
                                                               cv.tp1nro2,
                                                               cv.tp1nro3,
                                                               cv.tp1imp1,
                                                               vi_txcod,
                                                               vi_tip_rpt
                                                              );
                    end;
                end if;
              end if;--borrar temporal.                 
              --Extrae las transacciones de sobrantes
              if FechaIni <> vi_Pgfape or FechaFin <> vi_Pgfape then
                  begin
                      pq_cr_acl_report.sp_cr_detalle_sbr_flt( FechaIni,
                                                              FechaFin,
                                                              cv.tp1nro1,
                                                              cv.tp1nro2,
                                                              cv.tp1nro3,
                                                              cv.tp1imp1,
                                                              vi_txcod,
                                                              vi_tip_rpt
                                                             );
                    end;
              end if; -- Fin condicion para consultar movimiento Historico                 
           end;          
         end loop;
   end sp_cr_sobr_falt;
   
  -----------------------------------------------------------
  procedure sp_cr_detalle_sbr_flt( FechaIni  in date,--f.tp1corr3,
                                   FechaFin  in date,--f.tp1nro1,
                                   ve_itmod  in number,
                                   ve_ittran in number,
                                   ve_itord  in number,
                                   ve_itsbor in number,
                                   ve_txcod  in number,
                                   vi_tip_rpt in varchar
                                 )is
  ------------------------
  -- Cursor para movimientos diarios. 
  ------------------------           
  cursor mov_diario( cr_itmod in number,
                     cr_ittran in number ) is
                     
  select Itcont, -- Contabilización
         Itfcon, -- Fecha de Transacción (Reporte: Itfcon)
         Ituing, -- Código de Usuario (Reporte: Ituing)
         Itucnf, -- Usuario que Confirmo 
         Itnrel, -- Numero de Relación
         itcorr, -- Correlativo
         itsuc,  -- Sucursal
         pgcod,  -- Codigo de Instancia
         itmod,  -- Modulo de transaccion
         ittran  -- Transaccion .
    from fsd015  f
   where pgcod  = 1
     and itmod  = cr_itmod
     and ittran = cr_ittran;
  ------------------------
  -- Cursor para movimientos historicos. 
  ------------------------      
  cursor mov_historico( cr_itmod in number,
                        cr_ittran in number
                        ) is
                     
  select 
         f.hfcon, -- Fecha de Transacción (Reporte: Itfcon)
         f.husing, -- Código de Usuario (Reporte: Ituing)
         f.huscnf, -- Usuario que Confirmo 
         f.hnrel, -- Numero de Relación
         f.hccorr, -- Correlativo
         f.hsucor,  -- Sucursal
         f.pgcod,  -- Codigo de Instancia
         f.hcmod,  -- Modulo de transaccion
         f.htran  -- Transaccion .
    from fsh015  f
   where pgcod  = 1
     and hcmod  = cr_itmod
     and htran  = cr_ittran
     and hfcon >= FechaIni
     and hfcon <= FechaFin;
  
  vi_pgfape date;
  vi_Flgreg char(1);
  vi_MtoGen number(17,2);
  vi_itcont char(1);
  vi_itfcon date;
  vi_itucnf fsd015.itucnf%type;
  vi_ituing fsd015.ituing%type;
  vi_itnrel fsd015.itnrel%type;
  vi_itcorr fsd015.itcorr%type;
  vi_itsuc  fsd015.itsuc%type;
  vi_pgcod  fsd015.pgcod%type;
  vi_itmod  fsd015.itmod%type;
  vi_ittran fsd015.ittran%type;

  vi_Ctnro  fsr008.ctnro%type;
  vi_Moneda fsd010.aocta%type;
  vi_Papel  fsd010.aopap%type;
  vi_Modulo fsd010.aomod%type;
  vi_Itoper fsd010.aooper%type;
  vi_itsucor fsd016.itsuc%type;
  vi_Itsubo fsd010.aosbop%type;
  vi_Ittope fsd010.aotope%type;
  vi_hsubop fsd010.aosbop%type;
  vi_mosign varchar(20);
  vi_Cadmot varchar(10);
  vi_Concad number(12);
  vi_txtord fsx016.txtord%type;
  vi_ubnom  fst746.ubnom%type;
  vi_NumCta varchar(12);
  vi_result varchar(9);
  vi_itsucR  fsd016.itsuc%type;
  vi_itmodR  fsd016.itmod%type;
  vi_ittranR fsd016.ittran%type;
  vi_itnrelR fsd016.itnrel%type;
  vi_itfvalR fsd016.itfval%type;
  vi_Monto_Reg fsd016.itimp1%type;
  vi_itordR fsd016.itord%type;
   
  vi_fec_reg   date;
  vi_usui_reg  fsd015.ituing%type;
  vi_usuc_reg  fsd015.itucnf%type;
  vi_rubro     fsd016.rubro%type;
  
  
   begin
        --Obtener Fecha Actual del sistema.
         begin
            select pgfape
            into   vi_pgfape
            from fst017
            where pgcod=1;
          end; 
                                       
         if vi_Flgreg = '3' then --borrar
             if FechaIni = vi_Pgfape or FechaFin = vi_Pgfape then
                 for mv in mov_diario(ve_itmod,ve_ittran) loop
                      vi_Flgreg := 0; --Flag de analisis para considerar el registro (0:Registra, 1:No Registra).
                      --Se extraen solo los registros contabilizados
                      if mv.itcorr = 0 and mv.Itcont = 'S' then
                         vi_Flgreg :=0;
                      else
                         vi_Flgreg :=1;
                      End if;
                      --Se Verifica el Rango de Fechas Ingresado con Respecto a la Fecha de contabilización.
                      --if mv.Itfcon < FechaIni then
                      --  vi_Flgreg := 1;
                      --End if;
                      --if mv.Itfcon > FechaFin then
                      --  vi_Flgreg := 1;
                      --End if;
                      if vi_Flgreg = 0 then
                          --Para extraer información de monto y código de moneda
                          vi_Flgreg := 1;
                          vi_MtoGen := 0;
                          --Extrae información de monto y código de moneda fsd016 
                          --Extrae clave del movimiento de la fsd016. tambien el importe.
                          begin
                            select
                                  Itimp1,  --Monto de Sobrante o Faltante (Reporte: MtoGen)
                                  Ctnro ,  --Nro.de cuenta
                                  Moneda,  --Moneda
                                  Papel,   --PAPEL
                                  Modulo,  --Modulo
                                  Itoper,  --Operacion
                                  Itsubo,  --Sub.operac.
                                  Ittope,  --Tipo Operac. 
                                  Itsuc   --Sucursal 
                            into   
                                  vi_MtoGen, 
                                  vi_Ctnro,
                                  vi_Moneda,
                                  vi_Papel,
                                  vi_Modulo,
                                  vi_Itoper,
                                  vi_Itsubo,
                                  vi_Ittope,
                                  vi_itsuc
                            from fsd016 
                            where pgcod = 1
                              and itsuc = mv.itsuc 
                              and itmod = ve_itmod
                              and ittran= ve_ittran
                              and itnrel= mv.itnrel
                              and itord = ve_itord 
                              and itsbor= ve_itsbor;
                          exception 
                             when others then
                                  null;
                          end;
                          
                          vi_Flgreg := 0;
                          if vi_MtoGen < ve_itsbor then--MtoMin
                             vi_Flgreg := 1;
                          End if;
                          
                          -----------------------------------
                          --Extrae descripción de la moneda
                          begin                            
                              select Mosign  
                                into vi_mosign
                                from fst005
                               where Moneda = vi_Moneda;   
                          exception
                           when others then
                                 vi_mosign:='';    
                          end;
                          -----------------------------------
                          --Motivo Desc.
                          --Extrae motivo del sobrante o faltante.
                          begin
                               vi_Cadmot := ' ';
                               vi_Concad := 1;
                               begin
                                 select txtord
                                 into   vi_txtord 
                                 from fsx016
                                 where pgcod = vi_pgcod
                                   and txcod = ve_txcod
                                   and hfcon = vi_itfcon
                                   and hcmod = ve_itmod
                                   and hsucor= vi_itsuc
                                   and htran = ve_ittran
                                   and hnrel = mv.itnrel;
                               exception 
                                 when others then 
                                      vi_Cadmot := '';
                               end;
                             if vi_Concad < 4 then
                               vi_Cadmot := vi_Cadmot + vi_Txtord;  --Motivo de Sobrante o Faltante (Reporte: Cadmot)
                               vi_Concad := vi_Concad + 1;
                             End if; 
                          end;
                          ---------------------------------
                          --Para extraer nombre del usuario
                          begin
                            select ubnom 
                              into vi_ubnom
                              from fst746
                             where ubuser = mv.ituing;
                          exception 
                            when others then
                                 vi_ubnom := '';
                          end;
                          
                          --Regularizacion del Credito.
                          begin
                               Select d.pgcod,
                                      d.itsuc,
                                      d.itmod,
                                      d.ittran,
                                      d.itnrel,
                                      d.itfval
                                 into 
                                      vi_pgcod,
                                      vi_itsucR,
                                      vi_itmodR,
                                      vi_ittranR,
                                      vi_itnrelR,
                                      vi_itfvalR
                                 from fsd016 d 
                                where d.pgcod   = vi_pgcod
                                  and d.modulo  = vi_modulo--371
                                  and d.itsucd  = vi_itsucor--1
                                  and d.moneda  = vi_moneda--0
                                  and d.papel   = vi_papel--0
                                  and d.ctnro   = vi_ctnro--0
                                  and d.itoper  = vi_itoper--6330
                                  and d.ittope  = vi_ittope--0
                                  and rownum    = 1;
                                  --and d.itsubo  = vi_--23
                            exception
                              when no_data_found then
                                     Select d.pgcod,
                                        d.itsuc,
                                        d.itmod,
                                        d.ittran,
                                        d.itnrel,
                                        d.itfval
                                     into 
                                        vi_pgcod,
                                        vi_itsucR,
                                        vi_itmodR,
                                        vi_ittranR,
                                        vi_itnrelR,
                                        vi_itfvalR
                                     from fsd016 d 
                                    where d.pgcod   = vi_pgcod
                                      --and d.modulo  = vi_modulo--371
                                      and d.itsucd  = vi_itsucor--1
                                      and d.moneda  = vi_moneda--0
                                      and d.papel   = vi_papel--0
                                      and d.ctnro   = vi_ctnro--0
                                      and d.itoper  = vi_itoper--6330
                                      and d.ittope  = vi_ittope--0
                                      and rownum    = 1;  
                              when others then
                                  NULL;    
                            end;                             
                                  --Monto Regulatizado.
                                  begin
                                       Select  d.itimp1
                                       into    vi_Monto_Reg
                                       from fsd016 d
                                       where d.pgcod  = vi_pgcod
                                         and d.itsuc  = vi_itsucR
                                         and d.itmod  = vi_itmodR
                                         and d.ittran = vi_ittranR
                                         and d.itnrel = vi_itnrelR
                                         and d.itord  = vi_itordR;
                                  exception
                                    when others then
                                      null; 
                                    end;
                                   --datos cabecera.
                                   begin
                                       Select  d.itfcon,
                                               d.ituing,
                                               d.itucnf
                                               
                                       into    
                                               vi_fec_reg,
                                               vi_usui_reg,
                                               vi_usuc_reg
                                       from fsd015 d
                                       where d.pgcod  = vi_pgcod
                                         and d.itsuc  = vi_itsucR
                                         and d.itmod  = vi_itmodR
                                         and d.ittran = vi_ittranR
                                         and d.itnrel = vi_itnrelR;
                                   exception
                                    when others then
                                      null; 
                                     end; 
                                 --Grabar Información,
                                 begin
                                       insert into aqpa601
                                                  (
                                                    aqpa601fec,  --Fecha de Faltante y/o Sobrante
                                                    aqpa601usu,  --Usuario
                                                    aqpa601mda,  --Moneda
                                                    aqpa601mnt,  --Monto 
                                                    aqpa601ope,  --Operacion
                                                    aqpa601mtv,  --Motivo
                                                    aqpa601tpr,  --Tipo de Reporte
                                                    aqpa601mntr, --Monto Regularizado
                                                    aqpa601fecr, --Fecha de Regularizacion
                                                    aqpa601usur, --Usuario que Regulariza
                                                    aqpa601suc,  --Sucursal
                                                    aqpa601mod,  --Modulo 
                                                    aqpa601tra,  --Transacción
                                                    aqpa601modr, --Modulo de Regularización
                                                    aqpa601trar  --Transaccion de Regularización.
                                                  )
                                                  values
                                                  (
                                                    mv.itfcon,  
                                                    mv.itucnf,
                                                    vi_mosign,
                                                    vi_MtoGen,
                                                    vi_Itoper,
                                                    '',-- Motivo
                                                    vi_tip_rpt,
                                                    vi_Monto_Reg,
                                                    vi_fec_reg,
                                                    vi_usuc_reg,
                                                    mv.itsuc,
                                                    mv.itmod,
                                                    mv.ittran,
                                                    vi_itmodR,
                                                    vi_ittranR
                                                  );
                                 end;
                                 ---------------------------------                          
                    End if;                 
                 end loop;   
                 /*
                    if vi_Flgreg = 0 then
                                                    
                          vi_NumCta := ' ';--Se formatea el número de cuenta.
                          
                          --Regularizacion del Credito.
                          begin
                               Select d.pgcod,
                                      d.itsuc,
                                      d.itmod,
                                      d.ittran,
                                      d.itnrel,
                                      d.itfval
                                 into 
                                      vi_pgcod,
                                      vi_itsucR,
                                      vi_itmodR,
                                      vi_ittranR,
                                      vi_itnrelR,
                                      vi_itfvalR
                                 from fsd016 d 
                                where d.pgcod   = vi_pgcod
                                  and d.modulo  = vi_modulo--371
                                  and d.itsucd  = vi_itsucor--1
                                  and d.moneda  = vi_moneda--0
                                  and d.papel   = vi_papel--0
                                  and d.ctnro   = vi_ctnro--0
                                  and d.itoper  = vi_itoper--6330
                                  and d.ittope  = vi_ittope--0
                                  and rownum    = 1;
                                  --and d.itsubo  = vi_--23
                                   
                            end;                             
                                  --Monto Regulatizado.
                                  begin
                                       Select  d.itimp1
                                       into    vi_Monto_Reg
                                       from fsd016 d
                                       where d.pgcod  = vi_pgcod
                                         and d.itsuc  = vi_itsucR
                                         and d.itmod  = vi_itmodR
                                         and d.ittran = vi_ittranR
                                         and d.itnrel = vi_itnrelR
                                         and d.itord  = vi_itordR;
                                    end;
                                   --datos cabecera.
                                   begin
                                       Select  d.itfcon,
                                               d.ituing,
                                               d.itucnf
                                               
                                       into    
                                               vi_fec_reg,
                                               vi_usui_reg,
                                               vi_usuc_reg
                                       from fsd015 d
                                       where d.pgcod  = vi_pgcod
                                         and d.itsuc  = vi_itsucR
                                         and d.itmod  = vi_itmodR
                                         and d.ittran = vi_ittranR
                                         and d.itnrel = vi_itnrelR;
                                     end;  
                          ---------------------------------
                          
                    End if;
                    */
                 -------------------------------------------------------  
                 end if;
             end if;--borrar temporal.                 
         
         if FechaIni <> vi_Pgfape or FechaFin <> vi_Pgfape then
            for mv in mov_historico(ve_itmod,ve_ittran) loop
                  --Para extraer información de monto y código de moneda
                  vi_Flgreg := 1;
                  vi_MtoGen := 0;
                  --Extrae información de monto y código de moneda fsd016 
                  --Extrae clave del movimiento de la fsd016. tambien el importe.
                  begin
                    select
                          h.hcimp1,  --Monto de Sobrante o Faltante (Reporte: MtoGen)
                          h.hcta,    --Nro.de cuenta
                          h.hmda,    --Moneda
                          h.hpap,    --PAPEL
                          h.hmodul,  --Modulo
                          h.hoper,   --Operacion
                          h.hsubop,  --Sub.operac.
                          h.htoper,  --Tipo Operac. 
                          h.hsucur,  --Sucursal 
                          h.pgcod ,  --Empresa
                          h.hrubro   --Rubro
   
                    into   
                          vi_MtoGen, 
                          vi_Ctnro,
                          vi_Moneda,
                          vi_Papel,
                          vi_Modulo,
                          vi_Itoper,
                          vi_Itsubo,
                          vi_Ittope,
                          vi_itsuc,
                          vi_pgcod,
                          vi_rubro
                    from fsh016  h
                    where pgcod = 1
                      and hsucor = mv.hsucor 
                      and hcmod  = ve_itmod--cv.tp1nro1
                      and htran  = ve_ittran--cv.tp1nro2
                      and hnrel  = mv.hnrel
                      and hfcon  = mv.hfcon
                      and hcord  = ve_itord--cv.tp1nro3 
                      and hcsubo = ve_itsbor--cv.tp1imp1;
                      and rownum = 1;
                  exception 
                     when others then
                          vi_MtoGen  := 0; 
                          vi_Ctnro   := 0;
                          vi_Moneda  := 0;
                          vi_Papel   := 0;
                          vi_Modulo  := 0;
                          vi_Itoper  := 0;
                          vi_Itsubo  := 0;
                          vi_Ittope  := 0;
                          vi_itsuc   := 0;
                          vi_pgcod   := 0;
                  end;
                          
                  vi_Flgreg := 0;
                  --validar que el trailer no haya sido extornado.
                  begin
                       select 0
                       into vi_Flgreg
                       from fsh015
                       where pgcod = vi_pgcod
                         and hcmod = ve_itmod
                         and hsucor= mv.hsucor 
                         and htran = ve_ittran
                         and hnrel = mv.hnrel
                         and hfcon = mv.hfcon
                         and hccorr <>99;
                  exception
                         when no_data_found then
                           vi_Flgreg:=1;
                    end;
                  -- Comentado 2018.12.17 - por problemas de montos menores a 1 en sobrante declarados.
                  if vi_MtoGen <= 0/*ve_itsbor*/ then--MtoMin
                     vi_Flgreg := 1;
                  End if;
                  if vi_Flgreg=0 then --borrar temporal para solo grabar si hay dato.
                    -----------------------------------
                    --Extrae descripción de la moneda
                    begin                            
                        select Mosign  
                          into vi_mosign
                          from fst005
                         where Moneda = vi_Moneda;   
                    exception
                     when others then
                           vi_mosign:='';    
                    end;
                    -----------------------------------
                    --Motivo Desc.
                    --Extrae motivo del sobrante o faltante.
                    begin
                         vi_Cadmot := ' ';
                         vi_Concad := 1;
                         begin
                           select txtord
                           into   vi_txtord 
                           from fsx016
                           where pgcod = vi_pgcod
                             and txcod = ve_txcod
                             and hfcon = vi_itfcon
                             and hcmod = ve_itmod--cv.tp1nro1
                             and hsucor= vi_itsuc
                             and htran = ve_ittran--cv.tp1nro2
                             and hnrel = vi_itnrel;
                         exception 
                           when others then 
                                vi_Cadmot := '';
                                vi_txtord := 0;
                         end;
                       if vi_Concad < 4 then
                         vi_Cadmot := vi_Cadmot + vi_Txtord;  --Motivo de Sobrante o Faltante (Reporte: Cadmot)
                         vi_Concad := vi_Concad + 1;
                       End if; 
                    end;
                    ---------------------------------
                    --Para extraer nombre del usuario
                    begin
                      select ubnom 
                        into vi_ubnom
                        from fst746
                       where ubuser = mv.husing;
                    exception 
                      when others then
                           vi_ubnom := '';
                    end;
                            
                    --Regularizacion del Credito.
                    begin
                         Select d.pgcod,
                                d.hsucor,
                                d.hcmod,
                                d.htran,
                                d.hnrel,
                                d.hfcon
                           into 
                                vi_pgcod,
                                vi_itsucR,
                                vi_itmodR,
                                vi_ittranR,
                                vi_itnrelR,
                                vi_itfvalR
                           from fsh016 d 
                          where d.pgcod   = vi_pgcod
                            and d.hmodul  = vi_modulo--371
                            and d.hsucur  = vi_itsuc--1
                            and d.hmda    = vi_moneda--0
                            and d.hpap    = vi_papel--0
                            and d.hcta    = vi_ctnro--0
                            and d.hoper   = vi_itoper--6330
                            and d.htoper  = vi_ittope--0
                            and d.htran   <> mv.htran
                            and rownum    = 1;
                            --and d.itsubo  = vi_--23
                      exception
                        when no_data_found then
                             begin
                                 Select d.pgcod,
                                        d.hsucor,
                                        d.hcmod,
                                        d.htran,
                                        d.hnrel,
                                        d.hfcon
                                 into 
                                        vi_pgcod,
                                        vi_itsucR,
                                        vi_itmodR,
                                        vi_ittranR,
                                        vi_itnrelR,
                                        vi_itfvalR
                                 from fsh016 d 
                                 --PGCOD, HSUCUR, HRUBRO, HMDA, HCTA, HOPER, HSUBOP, HFCON
                                where d.pgcod   = 1
                                  --and d.hmodul  = vi_modulo--371
                                  and d.hsucur  = vi_itsuc--1
                                  and d.hrubro  = vi_rubro
                                  and d.hmda    = vi_moneda--0
                                  and d.hcta    = vi_ctnro--0
                                  and d.hoper   = vi_itoper--6330
                                  and d.hsubop  = vi_hsubop--6330
                                  and d.htran   <> mv.htran
                                  and rownum    = 1;
                              exception 
                                  when others then
                                       vi_pgcod   := 0;   
                                       vi_itsucR  := 0;
                                       vi_itmodR  := 0;
                                       vi_ittranR := 0;
                                       vi_itnrelR := 0;
                                       vi_itfvalR := null;
                              end;
                        when others then
                                vi_pgcod    := 0;
                                vi_itsucR   := 0;
                                vi_itmodR   := 0;
                                vi_ittranR  := 0;
                                vi_itnrelR  := 0;
                                vi_itfvalR  := null;
                      end;      
                                                            
                            --Monto Regulatizado.
                            vi_Monto_Reg:=0;
                            begin
                                 Select  d.hcimp1
                                 into    vi_Monto_Reg
                                 from fsh016 d
                                 where d.pgcod  = vi_pgcod
                                   and d.hsucor = vi_itsucR
                                   and d.hcmod  = vi_itmodR
                                   and d.htran  = vi_ittranR
                                   and d.hnrel  = vi_itnrelR
                                   and d.hfcon  = vi_itfvalR
                                   and d.hoper  = vi_itoper
                                   and rownum = 1;
                                  -- and d.hcord  = vi_itordR
                            exception
                              when others then
                                   vi_Monto_Reg :=0;
                              end;
                             --datos cabecera.
                             vi_fec_reg:=null;
                             vi_usui_reg:='';
                             vi_usuc_reg:='';
                             begin
                                 Select  d.hfcon,
                                         d.husing,
                                         d.huscnf                                               
                                 into    
                                         vi_fec_reg,
                                         vi_usui_reg,
                                         vi_usuc_reg
                                 from fsh015 d
                                 where d.pgcod  = vi_pgcod
                                   and d.hsucor = vi_itsucR
                                   and d.hcmod  = vi_itmodR
                                   and d.htran  = vi_ittranR
                                   and d.hnrel  = vi_itnrelR
                                   and d.hfcon  = vi_itfvalR;
                             exception
                              when others then
                                vi_fec_reg:=null;
                                vi_usui_reg:='';
                                vi_usuc_reg:=''; 
                               end; 
                           --Grabar Información,
                           begin
                                 insert into aqpa601
                                            (
                                              aqpa601fec,  --Fecha de Faltante y/o Sobrante
                                              aqpa601suc,  --Sucursal donde se registra el sobrante o faltante
                                              aqpa601usr,  --Usuario que registra   
                                              aqpa601usu,  --Usuario que confirma el registro
                                              aqpa601mda,  --Moneda
                                              aqpa601mnt,  --Monto 
                                              aqpa601ope,  --Operacion
                                              aqpa601mtv,  --Motivo
                                              aqpa601tpr,  --Tipo de Reporte
                                              aqpa601mntr, --Monto Regularizado
                                              aqpa601fecr, --Fecha de Regularizacion
                                              aqpa601usrr, --Usuario que registra la Regularizacion
                                              aqpa601usur, --Usuario que confirma la Regularización
                                              aqpa601sucr, --Sucursal donde se registra la Regularización.
                                              aqpa601mod,  --Modulo 
                                              aqpa601tra,  --Transacción
                                              aqpa601modr, --Modulo de Regularización
                                              aqpa601trar, --Transaccion de Regularización.
                                              aqpa601vnt
                                            )
                                            values
                                            (
                                              mv.hfcon,  
                                              mv.hsucor,
                                              mv.husing,
                                              mv.huscnf,
                                              vi_mosign,
                                              vi_MtoGen,
                                              vi_Itoper,
                                              vi_Cadmot,-- Motivo
                                              vi_tip_rpt,
                                              vi_Monto_Reg,
                                              vi_fec_reg,
                                              vi_usui_reg,
                                              vi_usuc_reg,
                                              vi_itsucR,
                                              mv.hcmod,
                                              mv.htran,
                                              vi_itmodR,
                                              vi_ittranR,
                                              vi_Itsubo
                                            );
                                            commit;
                           end;
                         ---------------------------------  
                         end if; -- Fin de la condicion de existencia.                        
             end loop; -- Fin de Bucle Cursor de consulta Movimiento Historicos
         end if; -- Fin condicion para consultar movimiento Historico                 
                  
      end sp_cr_detalle_sbr_flt;
    
  -----------------------------------------------------------
  -----------------------------------------------------------
  -----------------------------------------------------------
  function trabajador_caja(ve_ctnro in number) return varchar
     is 
     flag_trb char(1);
     begin
          select case pfebco when 'S' then 'S'
                    else 'N' end
             into flag_trb
              from fsd002 f2, fsr008 f8
             --where f2.pfebco = 'S'
             where f2.pfpais = f8.pepais
               and f2.pftdoc = f8.petdoc
               and f2.pfndoc = f8.pendoc
               and f8.cttfir = 'T'
               and f8.ctnro = ve_ctnro;
    return flag_trb;
    exception
         when others then
              flag_trb:='N';
              return flag_trb;
    end;
    ------------------------------------------------------------------------
    ------------------------------------------------------------------------
    procedure sp_cr_movimientos_cta(ve_ubuser in char) is
    cursor creditos_vigentes_acl is
    select /*
            n_emp_bcemp     ,
            n_mod_bcmod     ,
            n_suc_bcsuc     ,
            n_mda_bcmda     ,
            n_pap_bcpap     ,
            */
            n_cta_bccta     ,
            /*
            n_oper_bcoper   ,
            n_sbop_bcsbop   ,
            n_tope_bctop    ,
            n_rubr_bcrubr   ,
            n_pais_pepais   ,
            n_tdoc_petdoc   ,
            c_ndoc_pendoc   ,
            c_numsor_bnj096sor,
            n_mtodes_aoimp  ,
            n_period_aoperiod,
            n_estad_aostat  ,
            d_fecval_bcfval ,
            d_fecproxven_ppfpag,
            n_intcuo_ppint  ,
            n_cuopag_ppfpag ,
            n_mtopag_pp1cap ,
            d_fecultpag_pp1fech,
            c_numcre        ,
            d_fecref_bcfval ,
            d_fecven_bcfvto ,
            n_codcont_bcgpo ,
            c_tipdes_bcmod  ,
            n_codlincred    ,
            n_codcond_bcprod,
            n_plazo_bcpzo   ,
            n_rubrant_bcrubr,
            n_mtointe_dif_bcsdmo,
            n_mtogar_bcsdmo ,
            n_mtolinnout_bcsdmo,
            n_mtodeuind_bcsdmo,
            n_mtodeudir_bcsdmo,
            n_salcap_bcsdmo ,
            n_fecultrcc_tpnro,
            n_diasmora      ,
            n_diasmoraref   ,
            c_neg_sngc60nome,
            n_act_sngc60acte,
            */
            n_instancia_xwfprcins --,
            /*
            d_fecpro_bcfech ,
            n_salmn_bcsdmn  ,
            n_tipcorp       ,
            n_tasarefin     ,
            n_mtotot        ,
            n_mtocap        ,
            n_mtoint        ,
            n_mtomor        ,
            n_mtoseg        ,
            n_mtocom        ,
            n_motxt         ,
            n_suctxt        ,
            n_trttxt        ,
            n_reltxt        ,
            d_fectxt        ,
            n_morault       ,
            c_usutran       ,
            c_deshora       
            */
    from uai_aclpre;
    cursor dnis_credito(ci_cuenta in number) is
    select 
           f.pepais,
           f.petdoc,
           f.pendoc           
    from fsr008 f
    where ctnro = ci_cuenta;
    cursor cta_avales( ci_instancia in number) is
    select 
           s.sng122cta
    from sng122 s
    where sng122inst = ci_instancia;
    cursor famil_analista( ci_pepais in number,
                           ci_petdoc in number,
                           ci_pendoc in char
                          ) is
    select f.rppais,
           f.rptdoc,
           f.rpndoc,
           f.rpccyg
    from fsr002 f
    where f.pepais = ci_pepais 
      and f.petdoc = ci_petdoc
      and f.pendoc = ci_pendoc;
    cursor jaqy591_aux(ci_instancia in number) is
    select * from jaqy591 y 
    where y.jaqy591instan=ci_instancia; 
    --------------------------------
    --------------------------------       
    vi_flag_dni char(1);
    --
    vi_pepais fsr008.pepais%type; 
    vi_petdoc fsr008.petdoc%type;
    vi_pendoc fsr008.pendoc%type;
    --datos analista
    vi_apepais fsr008.pepais%type; 
    vi_apetdoc fsr008.petdoc%type;
    vi_apendoc fsr008.pendoc%type;
    vi_analista sng001.sng001ase%type;
    --
    flag_inst char(1);
    flag_jaqy951 char(1);
    str varchar(100);
    --------------------------------
    begin
          str := 'DELETE FROM AQPA610 WHERE AQPA610UBU='''||ve_ubuser||'''';
          execute immediate(str);
          dbms_output.PUT_LINE(str);
          commit;
          for c in creditos_vigentes_acl loop
              --Verificar si las instancias existen en la tabla.
              
              begin
                   select 'S' 
                   into   flag_inst
                   from   aqpa610 a
                   where  a.aqpa610inst = c.n_instancia_xwfprcins
                     and  a.aqpa610ubu  = ve_ubuser
                     and  rownum=1;
              exception 
                when no_data_found then
                     flag_inst := 'N';
                end;
              --Verificar si existe la istancia en la tabla personal, en caso de no existir verificar en la tabla de 
              --cinthya, para obtener la data dnis. de la tabla. 
              if flag_inst='N' then
                begin
                  select   'S'
                  into     flag_jaqy951
                  from jaqy591 j
                  where j.jaqy591instan = c.n_instancia_xwfprcins
                  and rownum=1;
                exception
                  when no_data_found then
                       flag_jaqy951 := 'N';
                end;
              end if;
              --Si hay data enla tabla de Cinthya insertar los dnis e instancias.
              if flag_jaqy951 = 'S' then
                For cc in jaqy591_aux(c.n_instancia_xwfprcins) loop
                    --dbms_output.PUT_LINE(c.n_instancia_xwfprcins);
                    --dbms_output.PUT_LINE(cc.jaqy591ndoc);
                    begin
                      insert into aqpa610 (
                                                 aqpa610pps,
                                                 aqpa610ptd,
                                                 aqpa610pnd,
                                                 aqpa610ubu,
                                                 aqpa610inst
                                                )
                                          values
                                                (
                                                 604,
                                                 cc.jaqy591tdoc,
                                                 cc.jaqy591ndoc,
                                                 ve_ubuser,
                                                 c.n_instancia_xwfprcins
                                                );
                       
                                          commit;
                    exception 
                       when others then
                            null;
                    end; 
                end loop;
              end if;
              --En caso de no encontrar en la tabla de cinthya y en la mia. obtener del proceso de abajo.
              --OBTENER TODOS LOS DNIS DE LOS INTEGRANTES DE LA CUENTA DEL CREDITO ANALIZADO
              for d in dnis_credito(c.n_cta_bccta) loop
                  begin
                       --OBTENER TODOS LOS DNIS DE LOS INTEGRANTES DE LA CUENTA DEL CREDITO ANALIZADO
                       vi_flag_dni := 'N';
                       begin
                            select  'S'
                            into    vi_flag_dni
                            from aqpa610 a
                            where a.aqpa610pps = d.pepais
                              and a.aqpa610ptd = d.petdoc
                              and a.aqpa610pnd = d.pendoc
                              and a.aqpa610ubu = ve_ubuser
                              and rownum=1;
                       exception 
                         when no_data_found then
                              vi_flag_dni := 'N';
                       end;
                       -- en caso de no tener registrado el dni en la tabla 
                       if vi_flag_dni = 'N' then --codicion para registrar dni
                       begin                
                             insert into aqpa610 (
                                                   aqpa610pps,
                                                   aqpa610ptd,
                                                   aqpa610pnd,
                                                   aqpa610ubu
                                                  )
                                            values
                                                  (
                                                   d.pepais,
                                                   d.petdoc,
                                                   d.pendoc,
                                                   ve_ubuser
                                                  );
                                            commit;
                       end;--fin de insercion registro
                       end if; --fin de condicion para registrar dni en tabla
                       --
                       
                    end;
              end loop;
              --OBTENER LOS DNIS DE LOS AVALES.
              for a in cta_avales(c.n_instancia_xwfprcins) loop
                 --OBTENER TODOS LOS DNIS DE LOS AVALES
                 vi_flag_dni := 'N';
                 begin 
                      select pepais,
                             petdoc,
                             pendoc
                      into   
                             vi_pepais,
                             vi_petdoc,
                             vi_pendoc
                      from fsr008 
                      where ctnro  = a.sng122cta 
                        and cttfir = 'T'
                        and rownum=1;
                   end;
                 begin
                      select  'S'
                      into    vi_flag_dni
                      from aqpa610 a
                      where a.aqpa610pps = vi_pepais
                        and a.aqpa610ptd = vi_petdoc
                        and a.aqpa610pnd = vi_pendoc
                        and a.aqpa610ubu = ve_ubuser
                        and rownum=1;
                 exception 
                   when no_data_found then
                        vi_flag_dni := 'N';
                 end;
                 -- en caso de no tener registrado el dni en la tabla 
                 if vi_flag_dni = 'N' then --codicion para registrar dni
                 begin                
                       insert into aqpa610 (
                                             aqpa610pps,
                                             aqpa610ptd,
                                             aqpa610pnd,
                                             aqpa610ubu
                                            )
                                      values
                                            (
                                             vi_pepais,
                                             vi_petdoc,
                                             vi_pendoc,
                                             ve_ubuser
                                            );
                                      commit;
                 end;--fin de insercion registro
                 end if; --fin de condicion para registrar dni en tabla
              end loop;
              --OBTENER TODOS EL DNI DEL ANALISTA
              --Obtener el asesor del credito
              begin
                   select s.sng001ase
                     into vi_analista
                   from sng001 s
                   where s.sng001inst = c.n_instancia_xwfprcins
                     and rownum=1;
              exception
                when others then
                     vi_analista := '';
                end;
              --Obtener el dni del asesor del credito
              begin
                   select j.jaqn002pai,
                          j.jaqn002tdo,
                          j.jaqn002ndo
                   into   vi_apepais,
                          vi_apetdoc,
                          vi_apendoc
                   from jaqn002 j
                   where j.jaqn002usr = vi_analista
                     and rownum=1;
              exception 
                   when others then
                        vi_apepais := 0;
                        vi_apetdoc := 0;
                        vi_apendoc := '';  
                end;
              --registrar el dni en la tabla.
              begin
                      select  'S'
                      into    vi_flag_dni
                      from aqpa610 a
                      where a.aqpa610pps = vi_apepais
                        and a.aqpa610ptd = vi_apetdoc
                        and a.aqpa610pnd = vi_apendoc
                        and a.aqpa610ubu = ve_ubuser;
                 exception 
                   when no_data_found then
                        vi_flag_dni := 'N';
              end;
              -- en caso de no tener registrado el dni en la tabla 
              if vi_flag_dni = 'N' then --codicion para registrar dni
               begin                
                     insert into aqpa610 (
                                           aqpa610pps,
                                           aqpa610ptd,
                                           aqpa610pnd,
                                           aqpa610ubu
                                          )
                                    values
                                          (
                                           vi_apepais,
                                           vi_apetdoc,
                                           vi_apendoc,
                                           ve_ubuser
                                          );
                                    commit;
               end;--fin de insercion registro
              end if; --fin de condicion para registrar dni en tabla
              --OBTENER EL DNI DE LOS FAMILIARES DEL ANALISTA
              for f in famil_analista(vi_apepais,vi_apetdoc,vi_apendoc) loop
                  --registrar el dni en la tabla.
                  begin
                          select  'S'
                          into    vi_flag_dni
                          from aqpa610 a
                          where a.aqpa610pps = f.rppais
                            and a.aqpa610ptd = f.rptdoc
                            and a.aqpa610pnd = f.rpndoc
                            and a.aqpa610ubu = ve_ubuser;
                     exception 
                       when no_data_found then
                            vi_flag_dni := 'N';
                  end;
                  -- en caso de no tener registrado el dni en la tabla 
                  if vi_flag_dni = 'N' then --codicion para registrar dni
                  begin                
                         insert into aqpa610 (
                                               aqpa610pps,
                                               aqpa610ptd,
                                               aqpa610pnd,
                                               aqpa610ubu
                                              )
                                        values
                                              (
                                               f.rppais,
                                               f.rptdoc,
                                               f.rpndoc,
                                               ve_ubuser
                                              );
                                        commit;
                  end;--fin de insercion registro
                  end if; --fin de condicion para registrar dni en tabla  
              end loop;
              
          end loop; --fin del loop de creditos vigentes.
      end;                                    
    ------------------------------------------------------------------------
    procedure sp_cr_movimientos_analista(ve_ubuser in char) is
    CURSOR DNI IS
    select * from fsd002 where pfebco='S';
    CURSOR FAMILIA(ci_pps in number, ci_ptd in number, ci_pnd in char) IS
    select *
     from fsr002 f
     WHERE f.pepais=ci_pps
       and f.petdoc=ci_ptd
       and f.pendoc=ci_pnd;
    LN_DNI nUMBER;
    str varchar(100);
    BEGIN
       
       str := 'DELETE FROM AQPA610 WHERE AQPA610UBU='''||ve_ubuser||'''';
       execute immediate(str);
       commit;
       FOR I IN DNI LOOP
           begin
             insert into aqpa610
                         ( 
                         AQPA610PPS,
                         AQPA610PTD,
                         AQPA610PND,
                         AQPA610UBU,
                         AQPA610NUM
                         )
                         values 
                         (
                         i.pfpais,
                         i.pftdoc,
                         i.pfndoc,
                         ve_ubuser,
                         to_number(ltrim(i.pfndoc,'0'))
                         );
           exception 
             when others then 
                  null;
           end;
           commit; 
           For j in FAMILIA(i.pfpais,i.pftdoc,i.pfndoc) loop
                  begin
                    insert into aqpa610
                         ( 
                         AQPA610PPS,
                         AQPA610PTD,
                         AQPA610PND,
                         AQPA610UBU,
                         aqpa610num
                         )
                         values 
                         (
                         j.rppais,
                         j.rptdoc,
                         j.rpndoc,
                         ve_ubuser,
                         to_number(ltrim(j.rpndoc,'0'))
                         );
                         commit;
                   exception
                     when others then
                       null;
                   end;
             end loop;
       END LOOP;  
    END;
    ------------------------------------------------------------------------
    procedure sp_cr_grabar_movimientos(ve_ubuser in char,ve_fecini in date, ve_fecfin in date)is
    str varchar(100);
    begin
         str := 'TRUNCATE TABLE JAQZ665';
         execute immediate(str);
         commit;
         insert into jaqz665
                            ( JAQZ665PAI,                   
                              JAQZ665TDO,                   
                              JAQZ665NDO,                   
                              JAQZ665CLV,                   
                              JAQZ665CTA,                   
                              JAQZ665PRD,                   
                              JAQZ665FEM,                   
                              JAQZ665HOM,                   
                              JAQZ665PGT,                   
                              JAQZ665MOT,                   
                              JAQZ665SUT,                   
                              JAQZ665TRT,                   
                              JAQZ665NET,                   
                              JAQZ665FET,                   
                              JAQZ665USRI,                  
                              JAQZ665NDP,                   
                              JAQZ665MDA,                   
                              JAQZ665MTO,                   
                              JAQZ665CON                    
                             )               
                       select 
                              JAQZ665PAI,
                              JAQZ665TDO,
                              JAQZ665NDO,
                              JAQZ665CLV,
                              JAQZ665CTA,
                              JAQZ665PRD,
                              JAQZ665FEM,
                              JAQZ665HOM,
                              JAQZ665PGT,
                              JAQZ665MOT,
                              JAQZ665SUT,
                              JAQZ665TRT,
                              JAQZ665NET,
                              JAQZ665FET,
                              JAQZ665USRI,
                              JAQZ665NDP,
                              JAQZ665MDA,
                              JAQZ665MTO,
                              JAQZ665CON
                        from 
                        (
                              select 604 jaqz665pai,
                              (
                               select petdoc
                                 from fsr008
                                where ctnro = substr(regexp_substr(a.jaqy220ch2,'[^-]+', 1,2),1,9)
                                  and cttfir='T'
                              ) jaqz665TDO,
                              (
                                select pendoc
                                  from fsr008
                                 where ctnro = substr(regexp_substr(a.jaqy220ch2,'[^-]+', 1,2),1,9)
                                   and cttfir='T'
                              )JAQZ665NDO,    
                               --regexp_substr(a.jaqy220ch2,'[^-]+', 1,1) jaqz665usr,
                              ltrim(trim(regexp_substr(a.jaqy220ch2,'-[^ ]+')),'-') jaqz665clv,
                              substr(regexp_substr(a.jaqy220ch2,'[^-]+', 1,2),1,9) jaqz665cta,--agregado
                              a.jaqy220dsc jaqz665prd, --AGREGADO PRODUCTO       
                              a.jaqy220fmv jaqz665fem,
                              a.jaqy220hor jaqz665hom,
                              1 jaqz665pgt,
                              a.jaqy220tmo jaqz665mot,
                              a.jaqy220tsu jaqz665sut,
                              a.jaqy220ttr jaqz665trt,
                              a.jaqy220tre jaqz665net,
                              a.jaqy220fmv jaqz665fet,
                              jaqy220ope jaqz665usri, 
                              JAQY220NDP jaqz665ndp,
                              0 jaqz665mda,
                              case when jaqy220dep = 0 then jaqy220ret
                                   else jaqy220dep end jaqz665mto,
                              a.jaqy220dsc jaqz665con
                              from jaqy220 a 
                              where jaqy220fmv>=ve_fecini
                                and jaqy220fmv<=ve_fecfin
                                and jaqy220tre<>0         
                                --and (jaqy220dep <> 0 and jaqy220ret<>0)
                                and jaqy220ch2 like ve_ubuser||'%'
                        )dd 
                              where dd.jaqz665prd not like '%Abono%'
                                and dd.jaqz665prd not like '%Compras%'
                                and dd.jaqz665prd not like '%Pago Periodico%';

                 commit;    
      end;
    ------------------------------------------------------------------------
    procedure sp_cr_retiros(/*ve_ubuser in char,*/ve_fecini in date,ve_fecfin in date)is
--      2019.03.13 DCASTRO Se modificaron procesos para generacion de tramas
    str varchar(100);
    begin
         str := 'TRUNCATE TABLE AQPA611';
         execute immediate(str);
         insert into aqpa611
                           ( aqpa611pai,       
                             aqpa611tdo,
                             aqpa611ndo,
                             aqpa611cta,
                             aqpa611prd,
                             aqpa611fet,
                             aqpa611hom,
                             apqa611pgt,
                             aqpa611sut,
                             aqpa611trt,
                             aqpa611net,
                             aqpa611fev,
                             aqpa611usri,
                             aqpa611ndp,
                             aqpa611mda,
                             aqpa611mto,
                             aqpa611con)
               
         select  f.pepais aqpa611pai,
                 f.petdoc aqpa611tdo,
                 f.pendoc aqpa611ndo,
                 f.ctnro  aqpa611cta,
                 'Retiro Cuenta de Ahorro' aqpa611prd,  
                 c.hfcon  aqpa611fet,
                 c.hhora  aqpa611hom,
                 c.pgcod  apqa611pgt,
                 c.hsucor aqpa611sut,
                 c.htran  aqpa611trt,
                 c.hnrel  aqpa611net,
                 d.hfval  aqpa611fva,
                 c.husing aqpa611usr,
                 (select fx.Txtord 
                    from fsx016 fx
                   where fx.pgcod = c.pgcod
                     and fx.hcmod = c.hcmod
                     and fx.hsucor= c.hsucor
                     and fx.htran = c.htran
                     and fx.hnrel = c.hnrel
                     and fx.hfcon = c.hfcon
                     and fx.txcod = 171) aqpa611ndp,
                 d.hmda   aqpa611mda,
                 d.hcimp1 jaqz665mto,
                 'Retiro Cuenta de Ahorro' aqpa611con
          from fsh016 d,fsh015 c,fsr008 f
          where d.pgcod=c.pgcod
            and d.hcmod=c.hcmod
            and d.hsucor=c.hsucor
            and d.htran=c.htran
            and d.hnrel=c.hnrel
            and d.hfcon=c.hfcon
            and d.hcord in (35,40)
            and c.hcmod=50
            and c.htran=426
            and f.ctnro=d.hcta
            and f.cttfir='T' 
            and c.hfcon>=ve_fecini
            and c.hfcon<=ve_fecfin;              

         commit;     --2019.03.13
    exception when others then  --2019.03.13
      null;

    end;                 
    ------------------------------------------------------------------------
    procedure sp_cr_deposito_plazo_fijo_v(ve_fecini in date, ve_fecfin in date) is
      str varchar(100);
     begin
            str := 'TRUNCATE TABLE JAQZ525_GARPF';
            execute immediate(str);
            insert into JAQZ525_GARPF
                   (
                     N_EMP_R2COD,
                     N_MOD_R2MOD,
                     N_SUC_R2SUC,
                     N_MDA_R2MDA,
                     N_PAP_R2PAP,
                     N_CTA_R2CTA,
                     N_OPE_R2OPER,
                     N_SBO_R2SBOP,
                     N_TIP_R2TOPE,
                     N_EMP_PZOFIJ,
                     N_MOD_PZOFIJ,
                     N_SUC_PZOFIJ,
                     N_MDA_PZOFIJ,
                     N_PAP_PZOFIJ,
                     N_CTA_PZOFIJ,
                     N_OPE_PZOFIJ,
                     N_SBO_PZOFIJ,
                     N_TIP_PZOFIJ,
                     JAQZ525FEP,
                     JAQZ525HOP,
                     JAQZ525USP,
                     JAQZ525MTO,
                     JAQZ525FEA,
                     JAQZ525HOA,
                     JAQZ525MTA,
                     JAQZ525MTD
                   )
            select n_emp_bcemp N_EMP_R2COD,
                   n_mod_bcmod N_MOD_R2MOD,
                   n_suc_bcsuc N_SUC_R2SUC,
                   n_mda_bcmda N_MDA_R2MDA,
                   n_pap_bcpap N_PAP_R2PAP,
                   n_cta_bccta N_CTA_R2CTA,
                   n_ope_bcoper N_OPE_R2OPER,
                   n_sbop_bcsbop N_SBO_R2SBOP,
                   n_tip_bctop N_TIP_R2TOPE,
                   r1cod N_EMP_PZOFIJ,
                   r1mod N_MOD_PZOFIJ,
                   r1suc N_SUC_PZOFIJ,
                   r1mda N_MDA_PZOFIJ,
                   r1pap N_PAP_PZOFIJ,
                   r1cta N_CTA_PZOFIJ,
                   r1oper N_OPE_PZOFIJ,
                   r1sbop N_SBO_PZOFIJ,
                   r1tope N_TIP_PZOFIJ,
                   Fecha_apertura JAQZ525FEP,
                   hora_apertura JAQZ525HOP,
                   usuario_apertura JAQZ525USP,
                   Monto_apertura JAQZ525MTO,
                   fecha_afectacion JAQZ525FEA,
                   hora_afectacion JAQZ525HOA,
                   monto_afectacion JAQZ525MTA,
                   f.Monto_apertura-f.monto_afectacion JAQZ525MTD
           from (
                  select a.n_emp_bcemp,
                         a.n_mod_bcmod,
                         a.n_suc_bcsuc,
                         a.n_mda_bcmda,
                         a.n_pap_bcpap,
                         a.n_cta_bccta,
                         a.n_ope_bcoper,
                         a.n_sbop_bcsbop,
                         a.n_tip_bctop,
                         b.r1cod,
                         b.r1mod,
                         b.r1suc,
                         b.r1mda,
                         b.r1pap,
                         b.r1cta,
                         b.r1oper,
                         b.r1sbop,
                         b.r1tope,
                         --b.r011cd,b.r011mo,b.r011su,b.r011tr,b.r011re,b.r011fc,
                         (select c.AOFVAL
                            from fsd010 c
                            /*
                           where b.r1cod  = c.PGCOD
                             and b.r1mod  = c.AOMOD
                             and b.r1suc  = c.AOSUC
                             and b.r1mda  = c.AOMDA
                             and b.r1pap  = c.AOPAP
                             and b.r1cta  = c.AOCTA
                             and b.r1oper = c.AOOPER
                             and b.r1sbop = 0
                             and b.r1tope = c.AOTOPE
                            */
                             where c.PGCOD  = b.r1cod 
                             and   c.AOMOD  = b.r1mod 
                             and   c.AOSUC  = b.r1suc 
                             and   c.AOMDA  = b.r1mda 
                             and   c.AOPAP  = b.r1pap 
                             and   c.AOCTA  = b.r1cta 
                             and   c.AOOPER = b.r1oper
                             and   c.aosbop = 0
                             and   c.AOTOPE = b.r1tope
                             and rownum = 1) Fecha_apertura,
                         (select bb.hhora from fsh016 s,fsh015 bb ,fsd010 c
                           where s.pgcod=1 
                             and s.hcmod=22 
                             and s.htran in (600,800) 
                             and s.hfcon= c.AOFVAL
                             and s.hmodul=b.r1mod and s.htoper=b.r1tope and s.hsucur=b.r1suc and s.hmda=b.r1mda 
                             and s.hpap=b.r1pap and s.hcta=b.r1cta
                             and s.hoper=b.r1oper and s.hsubop=0
                             and s.pgcod  = bb.pgcod
                             and s.hcmod  = bb.hcmod
                             and s.hsucor = bb.hsucor
                             and s.htran  = bb.htran
                             and s.hnrel  = bb.hnrel
                             and s.hfcon  = bb.hfcon
                             and s.pgcod  = c.PGCOD
                             and s.hmodul  = c.AOMOD
                             and s.hsucur  = c.AOSUC
                             and s.hmda  = c.AOMDA
                             and s.hpap  = c.AOPAP
                             and s.hcta  = c.AOCTA
                             and s.hoper = c.AOOPER
                             and c.AOSBOP = 0
                             and s.htoper = c.AOTOPE)hora_apertura,
                         (select bb.husing from fsh016 s,fsh015 bb,fsd010 cc 
                           where s.pgcod=1 
                             and s.hcmod=22 
                             and s.htran in (600,800) 
                             and s.hfcon= cc.AOFVAL
                             and s.hmodul=b.r1mod and s.htoper=b.r1tope and s.hsucur=b.r1suc and s.hmda=b.r1mda 
                             and s.hpap=b.r1pap and s.hcta=b.r1cta
                             and s.hoper=b.r1oper and s.hsubop=b.r1sbop
                             and s.pgcod  = bb.pgcod
                             and s.hcmod  = bb.hcmod
                             and s.hsucor = bb.hsucor
                             and s.htran  = bb.htran
                             and s.hnrel  = bb.hnrel
                             and s.hfcon  = bb.hfcon
                             and cc.PGCOD  = s.pgcod
                             and cc.AOMOD  = s.hmodul
                             and cc.AOSUC  = s.hsucur
                             and cc.AOMDA  = s.hmda
                             and cc.AOPAP  = s.hpap
                             and cc.AOCTA  = s.hcta
                             and cc.AOOPER = s.hoper
                             and cc.AOSBOP = s.hsubop
                             and cc.AOTOPE = s.htoper)usuario_apertura,
                         (select c.AOIMP
                            from fsd010 c
                            /*
                           where b.r1cod  = c.PGCOD
                             and b.r1mod  = c.AOMOD
                             and b.r1suc  = c.AOSUC
                             and b.r1mda  = c.AOMDA
                             and b.r1pap  = c.AOPAP
                             and b.r1cta  = c.AOCTA
                             and b.r1oper = c.AOOPER
                             and b.r1sbop = 0
                             and b.r1tope = c.AOTOPE
                            */
                              where c.PGCOD  = b.r1cod 
                             and   c.AOMOD  = b.r1mod 
                             and   c.AOSUC  = b.r1suc 
                             and   c.AOMDA  = b.r1mda 
                             and   c.AOPAP  = b.r1pap 
                             and   c.AOCTA  = b.r1cta 
                             and   c.AOOPER = b.r1oper
                             and   c.aosbop = 0
                             and   c.AOTOPE = b.r1tope
                             and rownum = 1) Monto_apertura,
                         b.r011fc fecha_afectacion,
                         (select a.hhora
                            from fsh015 a
                           where a.pgcod  = b.r011cd
                             and a.hcmod  = b.r011mo
                             and a.hsucor = b.r011su
                             and a.htran  = b.r011tr
                             and a.hnrel  = b.r011re
                             and a.hfcon  = b.r011fc) hora_afectacion,
                         (select z.hcimp1
                            from fsh016 z
                           where z.pgcod  = b.r011cd
                             and z.hcmod  = b.r011mo
                             and z.hsucor = b.r011su
                             and z.htran  = b.r011tr
                             and z.hnrel  = b.r011re
                             and z.hfcon  = b.r011fc
                             and z.hcord  = 10) monto_afectacion
                    from uai_aclgar a,fsr011 b 
                   where a.n_emp_r2cod  = b.r2cod
                     and a.n_mod_r2mod  = b.r2mod
                     and a.n_suc_r2suc  = b.r2suc
                     and a.n_mda_r2mda  = b.r2mda
                     and a.n_pap_r2pap  = b.r2pap
                     and a.n_cta_r2cta  = b.r2cta
                     and a.n_ope_r2oper = b.r2oper
                     and a.n_sbo_r2sbop = b.r2sbop
                     and a.n_tip_r2tope = b.r2tope
                     and relcod in (2,25)) f --fin subconsulta principal.
             -----------------------------------
             where Fecha_apertura is not null
               and hora_apertura is not null
               and usuario_apertura is not null
               and Monto_apertura is not null
               and fecha_afectacion  is not null
               and hora_afectacion is not null
               and monto_afectacion is not null;
               
           commit;---2019.03.13    
    exception when others then
      null;
    end;
    ------------------------------------------------------------------------
    procedure sp_cr_deposito_plazo_fijo_c(ve_fecini in date, ve_fecfin in date) is
      str varchar(100);
      begin
              str := 'TRUNCATE TABLE JAQZ667';
              execute immediate(str);
              insert into jaqz667
                          (
                            jaqz667emp,
                            jaqz667mod,
                            jaqz667suc,
                            jaqz667mda,
                            jaqz667pap,
                            jaqz667cta,
                            jaqz667ope,
                            jaqz667sbo,
                            jaqz667top,
                            jaqz667pgp,
                            jaqz667mop,
                            jaqz667sup,
                            jaqz667mdp,
                            jaqz667ppp,
                            jaqz667ctp,
                            jaqz667opp,
                            jaqz667sbp,
                            jaqz667tpp,
                            jaqz667fec,
                            jaqz667hor,
                            jaqz667mto,
                            jaqz667usu,
                            jaqz667sut,
                            jaqz667FED,
                            jaqz667HOD,
                            jaqz667MOF
                          )
              select r2cod jaqz667emp,                                               
                     r2mod jaqz667mod,                                               
                     r2suc jaqz667suc,                                               
                     r2mda jaqz667mda,                                               
                     r2pap jaqz667pap,                                               
                     r2cta jaqz667cta,                                               
                     r2oper jaqz667ope,                                              
                     r2sbop jaqz667sbo,                                              
                     r2tope jaqz667top,                                              
                     r1cod jaqz667pgp,                                               
                     r1mod jaqz667mop,                                               
                     r1suc jaqz667sup,                                               
                     r1mda jaqz667mdp,                                               
                     r1pap jaqz667ppp,                                               
                     r1cta jaqz667ctp,                                               
                     r1oper jaqz667opp,                                              
                     r1sbop jaqz667sbp,                                              
                     r1tope jaqz667tpp,                                
                     fecha_cancelacion jaqz667fec,
                     hora_cancelacion jaqz667hor,
                     monto_cancelacion jaqz667mto,
                     usuario_cancelacion jaqz667usu,
                     sucursal_cancelacion jaqz667sut,
                     fecha_desafectacion jaqz667FED,
                     hora_desafectacion jaqz667HOD,
                     monto_desafectacion jaqz667MOF
               from (
              select y.r2cod ,
                     y.r2mod ,
                     y.r2suc ,
                     y.r2mda ,
                     y.r2pap ,
                     y.r2cta ,
                     y.r2oper,
                     y.r2sbop,
                     y.r2tope,
                     b.r1cod,
                     b.r1mod,
                     b.r1suc,
                     b.r1mda,
                     b.r1pap,
                     b.r1cta,
                     b.r1oper,
                     b.r1sbop,
                     b.r1tope,
                     --b.r011cd,b.r011mo,b.r011su,b.r011tr,b.r011re,b.r011fc,
                     (select c.AOFVAL
                        from fsd010 c
                        /*
                       where b.r1cod  = c.PGCOD
                         and b.r1mod  = c.AOMOD
                         and b.r1suc  = c.AOSUC
                         and b.r1mda  = c.AOMDA
                         and b.r1pap  = c.AOPAP
                         and b.r1cta  = c.AOCTA
                         and b.r1oper = c.AOOPER
                         and b.r1sbop = 0
                         and b.r1tope = c.AOTOPE
                        */
                         where c.PGCOD  = b.r1cod 
                         and   c.AOMOD  = b.r1mod 
                         and   c.AOSUC  = b.r1suc 
                         and   c.AOMDA  = b.r1mda 
                         and   c.AOPAP  = b.r1pap 
                         and   c.AOCTA  = b.r1cta 
                         and   c.AOOPER = b.r1oper
                         and   c.aosbop = 0
                         and   c.AOTOPE = b.r1tope
                         and rownum = 1) Fecha_apertura,
                     (select bb.hhora from fsh016 s,fsh015 bb ,fsd010 c
                       where s.pgcod=1 
                         and s.hcmod=22 
                         and s.htran in (600,800) 
                         and s.hfcon= c.AOFVAL
                         and s.hmodul=b.r1mod and s.htoper=b.r1tope and s.hsucur=b.r1suc and s.hmda=b.r1mda 
                         and s.hpap=b.r1pap and s.hcta=b.r1cta
                         and s.hoper=b.r1oper and s.hsubop=0
                         and s.pgcod  = bb.pgcod
                         and s.hcmod  = bb.hcmod
                         and s.hsucor = bb.hsucor
                         and s.htran  = bb.htran
                         and s.hnrel  = bb.hnrel
                         and s.hfcon  = bb.hfcon
                         and s.pgcod  = c.PGCOD
                         and s.hmodul  = c.AOMOD
                         and s.hsucur  = c.AOSUC
                         and s.hmda  = c.AOMDA
                         and s.hpap  = c.AOPAP
                         and s.hcta  = c.AOCTA
                         and s.hoper = c.AOOPER
                         and c.AOSBOP = 0
                         and s.htoper = c.AOTOPE)hora_apertura,
                      (select c.AOIMP
                        from fsd010 c
                       where b.r1cod  = c.PGCOD
                         and b.r1mod  = c.AOMOD
                         and b.r1suc  = c.AOSUC
                         and b.r1mda  = c.AOMDA
                         and b.r1pap  = c.AOPAP
                         and b.r1cta  = c.AOCTA
                         and b.r1oper = c.AOOPER
                         and b.r1sbop = 0
                         and b.r1tope = c.AOTOPE
                         and rownum = 1) Monto_apertura,   
                     (select bb.husing from fsh016 s,fsh015 bb,fsd010 cc 
                       where s.pgcod=1 
                         and s.hcmod=22 
                         and s.htran in (600,800) 
                         and s.hfcon= cc.AOFVAL
                         and s.hmodul=b.r1mod and s.htoper=b.r1tope and s.hsucur=b.r1suc and s.hmda=b.r1mda 
                         and s.hpap=b.r1pap and s.hcta=b.r1cta
                         and s.hoper=b.r1oper and s.hsubop=b.r1sbop
                         and s.pgcod  = bb.pgcod
                         and s.hcmod  = bb.hcmod
                         and s.hsucor = bb.hsucor
                         and s.htran  = bb.htran
                         and s.hnrel  = bb.hnrel
                         and s.hfcon  = bb.hfcon
                         and cc.PGCOD  = s.pgcod
                         and cc.AOMOD  = s.hmodul
                         and cc.AOSUC  = s.hsucur
                         and cc.AOMDA  = s.hmda
                         and cc.AOPAP  = s.hpap
                         and cc.AOCTA  = s.hcta
                         and cc.AOOPER = s.hoper
                         and cc.AOSBOP = s.hsubop
                         and cc.AOTOPE = s.htoper)usuario_apertura,
                     
                         b.r011fc fecha_afectacion,
                         (select a.hhora
                            from fsh015 a
                           where a.pgcod  = b.r011cd
                             and a.hcmod  = b.r011mo
                             and a.hsucor = b.r011su
                             and a.htran  = b.r011tr
                             and a.hnrel  = b.r011re
                             and a.hfcon  = b.r011fc) hora_afectacion,
                         (select z.hcimp1
                            from fsh016 z
                           where z.pgcod  = b.r011cd
                             and z.hcmod  = b.r011mo
                             and z.hsucor = b.r011su
                             and z.htran  = b.r011tr
                             and z.hnrel  = b.r011re
                             and z.hfcon  = b.r011fc
                             and z.hcord  = 10) monto_afectacion,
                         (select gg.AOFE99
                            from fsd010 gg
                           where gg.PGCOD  = b.r1cod 
                             and gg.AOMOD  = b.r1mod 
                             and gg.AOSUC  = b.r1suc 
                             and gg.AOMDA  = b.r1mda 
                             and gg.AOPAP  = b.r1pap 
                             and gg.AOCTA  = b.r1cta 
                             and gg.AOOPER = b.r1oper
                             and gg.AOSBOP = b.r1sbop
                             and gg.AOTOPE = b.r1tope
                             and rownum = 1) fecha_cancelacion,
                         (select hh.hhora
                            from fsd602 g, fsd010 gg,fsh015 hh
                           where g.pgcod  = gg.PGCOD 
                             and g.ppmod  = gg.AOMOD 
                             and g.ppsuc  = gg.AOSUC 
                             and g.ppmda  = gg.AOMDA 
                             and g.pppap  = gg.AOPAP 
                             and g.ppcta  = gg.AOCTA 
                             and g.ppoper = gg.AOOPER
                             and g.ppsbop = gg.AOSBOP
                             and g.pptope = gg.AOTOPE
                             and gg.PGCOD  = b.r1cod 
                             and gg.AOMOD  = b.r1mod 
                             and gg.AOSUC  = b.r1suc 
                             and gg.AOMDA  = b.r1mda 
                             and gg.AOPAP  = b.r1pap 
                             and gg.AOCTA  = b.r1cta 
                             and gg.AOOPER = b.r1oper
                             and gg.AOSBOP = b.r1sbop
                             and gg.AOTOPE = b.r1tope
                             and g.pp1fech = gg.AOFE99
                             and g.d602mo  = 22
                             and g.d602tr  in (300,310)
                             and g.d602co  = 'S'
                             and hh.pgcod  = g.d602cd
                             and hh.hcmod  = g.d602mo
                             and hh.hsucor = g.d602su
                             and hh.htran  = g.d602tr
                             and hh.hnrel  = g.d602re
                             and hh.hfcon  = g.d602fc
                             and rownum = 1) hora_cancelacion,
                       (select hh.husing
                            from fsd602 g, fsd010 gg,fsh015 hh
                           where g.pgcod  = b.r1cod 
                             and g.ppmod  = b.r1mod 
                             and g.ppsuc  = b.r1suc 
                             and g.ppmda  = b.r1mda 
                             and g.pppap  = b.r1pap 
                             and g.ppcta  = b.r1cta 
                             and g.ppoper = b.r1oper
                             and g.ppsbop = b.r1sbop
                             and g.pptope = b.r1tope
                             and gg.PGCOD  = b.r1cod 
                             and gg.AOMOD  = b.r1mod 
                             and gg.AOSUC  = b.r1suc 
                             and gg.AOMDA  = b.r1mda 
                             and gg.AOPAP  = b.r1pap 
                             and gg.AOCTA  = b.r1cta 
                             and gg.AOOPER = b.r1oper
                             and gg.AOSBOP = b.r1sbop
                             and gg.AOTOPE = b.r1tope
                             and g.pp1fech = gg.AOFE99
                             and g.d602mo  = 22
                             and g.d602tr  in (300,310)
                             and g.d602co  = 'S'
                             and hh.pgcod  = g.d602cd
                             and hh.hcmod  = g.d602mo
                             and hh.hsucor = g.d602su
                             and hh.htran  = g.d602tr
                             and hh.hnrel  = g.d602re
                             and hh.hfcon  = g.d602fc
                             and rownum = 1) usuario_cancelacion,
                             (select i.hcimp6
                            from fsd602 g, fsd010 gg,fsh016 i
                           where g.pgcod  = b.r1cod 
                             and g.ppmod  = b.r1mod 
                             and g.ppsuc  = b.r1suc 
                             and g.ppmda  = b.r1mda 
                             and g.pppap  = b.r1pap 
                             and g.ppcta  = b.r1cta 
                             and g.ppoper = b.r1oper
                             and g.ppsbop = b.r1sbop
                             and g.pptope = b.r1tope
                             and gg.PGCOD  = b.r1cod 
                             and gg.AOMOD  = b.r1mod 
                             and gg.AOSUC  = b.r1suc 
                             and gg.AOMDA  = b.r1mda 
                             and gg.AOPAP  = b.r1pap 
                             and gg.AOCTA  = b.r1cta 
                             and gg.AOOPER = b.r1oper
                             and gg.AOSBOP = b.r1sbop
                             and gg.AOTOPE = b.r1tope
                             and g.pp1fech = gg.AOFE99
                             and g.d602mo  = 22
                             and g.d602tr  in (300,310)
                             and g.d602co  = 'S'
                             and i.pgcod  = g.d602cd
                             and i.hcmod  = g.d602mo
                             and i.hsucor = g.d602su
                             and i.htran  = g.d602tr
                             and i.hnrel  = g.d602re
                             and i.hfcon  = g.d602fc
                             and i.hcord  = 5
                             and rownum = 1) monto_cancelacion,
                             (select g.d602su
                            from fsd602 g, fsd010 gg
                           where g.pgcod  = b.r1cod 
                             and g.ppmod  = b.r1mod 
                             and g.ppsuc  = b.r1suc 
                             and g.ppmda  = b.r1mda 
                             and g.pppap  = b.r1pap 
                             and g.ppcta  = b.r1cta 
                             and g.ppoper = b.r1oper
                             and g.ppsbop = b.r1sbop
                             and g.pptope = b.r1tope
                             and gg.PGCOD  = b.r1cod 
                             and gg.AOMOD  = b.r1mod 
                             and gg.AOSUC  = b.r1suc 
                             and gg.AOMDA  = b.r1mda 
                             and gg.AOPAP  = b.r1pap 
                             and gg.AOCTA  = b.r1cta 
                             and gg.AOOPER = b.r1oper
                             and gg.AOSBOP = b.r1sbop
                             and gg.AOTOPE = b.r1tope
                             and g.pp1fech = gg.AOFE99
                             and g.d602mo  = 22
                             and g.d602tr  in (300,310)
                             and g.d602co  = 'S'
                             and rownum = 1)sucursal_cancelacion,
                            ss.AOFE99 fecha_desafectacion,
                            (select uu.hhora
                               from fsh016 tt,fsh015 uu
                              where tt.pgcod  = b.r1cod 
                                and tt.hmodul = b.r1mod 
                                and tt.hsucur = b.r1suc 
                                and tt.hmda   = b.r1mda 
                                and tt.hpap   = b.r1pap 
                                and tt.hcta   = b.r1cta 
                                and tt.hoper  = b.r1oper
                                and tt.hsubop = b.r1sbop
                                and tt.htoper = b.r1tope
                                and ((tt.hcmod,tt.htran ) = (select 98,810 from dual) or
                                     (tt.hcmod,tt.htran ) = (select 70,120 from dual) or
                                     (tt.hcmod,tt.htran ) = (select 70,125 from dual) or
                                     (tt.hcmod,tt.htran ) = (select 35,75 from dual) or
                                     (tt.hcmod,tt.htran ) = (select 98,657 from dual) )
                                and tt.hfcon  = ss.AOFE99
                                and tt.hcord  = 5
                                and tt.pgcod  = uu.pgcod 
                                and tt.hcmod  = uu.hcmod 
                                and tt.hsucor = uu.hsucor
                                and tt.htran  = uu.htran 
                                and tt.hnrel  = uu.hnrel 
                                and tt.hfcon  = uu.hfcon 
                                )hora_desafectacion,
                            (select tt.hcimp1
                               from fsh016 tt
                              where tt.pgcod  = b.r1cod 
                                and tt.hmodul = b.r1mod 
                                and tt.hsucur = b.r1suc 
                                and tt.hmda   = b.r1mda 
                                and tt.hpap   = b.r1pap 
                                and tt.hcta   = b.r1cta 
                                and tt.hoper  = b.r1oper
                                and tt.hsubop = b.r1sbop
                                and tt.htoper = b.r1tope
                                and ((tt.hcmod,tt.htran ) in (select 98,810 from dual) or
                                     (tt.hcmod,tt.htran ) in (select 70,120 from dual) or
                                     (tt.hcmod,tt.htran ) in (select 70,125 from dual) or
                                     (tt.hcmod,tt.htran ) in (select 35,75 from dual) or
                                     (tt.hcmod,tt.htran ) in (select 98,657 from dual) )
                                and tt.hfcon  = ss.AOFE99
                                and tt.hcord = 5
                                )monto_desafectacion

                     
                from fsd010 ss,fsr011 b, fsr011 y 
               where ss.pgcod  = 1
                 and ss.AOMOD  = y.r1mod
                 and ss.AOSUC  = y.r1suc
                 and ss.AOMDA  = y.r1mda
                 and ss.AOPAP  = y.r1pap
                 and ss.AOCTA  = y.r1cta
                 and ss.AOOPER = y.r1oper
                 and ss.AOSBOP = y.r1sbop
                 and ss.AOTOPE = y.r1tope
                 and ss.AOSTAT = 99
                 and ss.AOFE99 between ve_fecini and ve_fecfin --2019.03.13
                 and ss.AOMOD in (select modulo from fst111 where dscod = 50)
                 and y.relcod  = 50
                 and y.r2cod = b.r2cod
                 and y.r2mod = b.r2mod
                 and y.r2suc = b.r2suc
                 and y.r2mda = b.r2mda
                 and y.r2pap = b.r2pap
                 and y.r2cta = b.r2cta
                 and y.r2oper = b.r2oper
                 and y.r2sbop = b.r2sbop
                 and y.r2tope = b.r2tope
                 and b.relcod in (2,25)) f
                 
                 where Fecha_apertura is not null
                   and hora_apertura is not null
                   and usuario_apertura is not null
                   and Monto_apertura is not null
                   and fecha_afectacion  is not null
                   and hora_afectacion is not null
                   and monto_afectacion is not null;  
              commit; --2019.03.13     
    exception when others then --2019.03.13
      null;
    end;
    ------------------------------------------------------------------------
    procedure sp_cr_flujo_prestamo(vec_fecini in date, vec_fecfin in date) is
      str varchar(100);
      begin
             str := 'TRUNCATE TABLE JAQZ668';
             execute immediate(str);
             insert into jaqz668
                            (
                              jaqz668ins ,
                              jaqz668tas ,
                              jaqz668est ,
                              jaqz668fei ,
                              jaqz668fef ,
                              jaqz668hoi ,
                              jaqz668hof ,
                              jaqz668usu ,
                              jaqz668des 
                            )
             select distinct a.n_instancia_xwfprcins jaqz668ins,
                             b.wftaskcod jaqz668tas,
                             b.wfstscod jaqz668est, --2019.03.13
                             trunc(b.wfiteminit) jaqz668fei,
                             trunc(b.wfitemend) jaqz668fef,
                             to_char(b.wfiteminit,'hh24:mi:ss') jaqz668hoi,
                             to_char(b.wfitemend,'hh24:mi:ss') jaqz668hof,
                             trim(b.wfitemusrcod) jaqz668usu,
                             (select trim(v.wfstsdsc) from WFState1 V where wflngid='spa' and v.wfstscod=b.wfstscod)jaqz668des  --2019.03.13
                             --to_char(b.wfiteminit,'dd/mm/yyyy hh24:mi:ss', 'nls_date_language=SPANISH') jaqz668ini,
                             --to_char(b.wfitemend,'dd/mm/yyyy hh24:mi:ss', 'nls_date_language=SPANISH') jaqz668end
                             --b.wfiteminit jaqz668ini,
                             --b.wfitemend jaqz668end
                        from uai_aclpre a,wfwrkitems b
                       where a.n_instancia_xwfprcins = b.wfinsprcid
                         and trunc(wfiteminit) >= vec_fecini
                         and trunc(wfiteminit) <= vec_fecfin;
                         --and a.n_instancia_xwfprcins=3115084;
                      --order by 1,4,5,9;    
              commit; --2019.03.13              
    exception when others then  --2019.03.13
      null;
    end;
    ------------------------------------------------------------------------
    procedure sp_cr_cambio_tasa(vec_fecini in date, vec_fecfin in date) is
    str varchar(100);
    begin
          str := 'TRUNCATE TABLE jaqz670';
          execute immediate(str);
          commit;
          insert into
          jaqz670
                 ( jaqz670emp , 
                   jaqz670mod ,
                   jaqz670suc ,
                   jaqz670mda ,
                   jaqz670pap ,
                   jaqz670cta ,
                   jaqz670ope ,
                   jaqz670sbo ,
                   jaqz670top ,
                   jaqz670evt ,
                   jaqz670fec ,
                   jaqz670fecr,
                   jaqz670tas ,
                   --jaqz670tta ,
                   --jaqz670usu ,
                   jaqz670est ,
                   jaqz670taso,
                   jaqz670usum,
                   jaqz670tbcj
                 )
           select         
                   a.n_emp_bcemp   jaqz670emp,
                   a.n_mod_bcmod   jaqz670mod,                   
                   a.n_suc_bcsuc   jaqz670suc,                   
                   a.n_mda_bcmda   jaqz670mda,                   
                   a.n_pap_bcpap   jaqz670pap,                   
                   a.n_cta_bccta   jaqz670cta,                  
                   a.n_oper_bcoper jaqz670ope,                  
                   a.n_sbop_bcsbop jaqz670sbo,                  
                   a.n_tope_bctop  jaqz670top,                   
                   x.evtipo jaqz670evt,                         
                   x.evfval jaqz670fec,
                   d.aud_fsd012_uon jaqz670fecr,                         
                   x.evtasa jaqz670tas,
                   --'',--jaqz670tta
                   --'',--jaqz670usu
                   (select aa.AOSTAT                  
                      from fsd010 aa                  
                     where aa.PGCOD  = a.n_emp_bcemp  
                       and aa.AOMOD  = a.n_mod_bcmod  
                       and aa.AOSUC  = a.n_suc_bcsuc  
                       and aa.AOMDA  = a.n_mda_bcmda  
                       and aa.AOPAP  = a.n_pap_bcpap  
                       and aa.AOCTA  = a.n_cta_bccta  
                       and aa.AOOPER = a.n_oper_bcoper
                       and aa.AOSBOP = a.n_sbop_bcsbop
                       and aa.AOTOPE = a.n_tope_bctop   )jaqz670est,
                   (select ab.AOTASA                  
                      from fsd010 ab                  
                     where ab.PGCOD  = a.n_emp_bcemp  
                       and ab.AOMOD  = a.n_mod_bcmod  
                       and ab.AOSUC  = a.n_suc_bcsuc  
                       and ab.AOMDA  = a.n_mda_bcmda  
                       and ab.AOPAP  = a.n_pap_bcpap  
                       and ab.AOCTA  = a.n_cta_bccta  
                       and ab.AOOPER = a.n_oper_bcoper
                       and ab.AOSBOP = a.n_sbop_bcsbop
                       and ab.AOTOPE = a.n_tope_bctop   )jaqz670tsao,--TASA ORIGINAL
                    d.aud_fsd012_ubu jaqz670usum, --usuario que realizo el cambio de tasa.
                    (select case pfebco when 'S' then 'S'
                            else 'N' end
                      from fsd002 f2, fsr008 f8
                     --where f2.pfebco = 'S'
                     where f2.pfpais = f8.pepais
                       and f2.pftdoc = f8.petdoc
                       and f2.pfndoc = f8.pendoc
                       and f8.cttfir = 'T'
                       and f8.ctnro = x.aocta) jaqz670tbcj--Trabajador Caja.                    
             from uai_aclpre a, fsd012 x,aud_FSD012_audit d
            where a.n_emp_bcemp   = x.pgcod
              and a.n_mod_bcmod   = x.aomod 
              and a.n_suc_bcsuc   = x.aosuc
              and a.n_mda_bcmda   = x.aomda
              and a.n_pap_bcpap   = x.aopap
              and a.n_cta_bccta   = x.aocta
              and a.n_oper_bcoper = x.aooper
              and a.n_sbop_bcsbop = x.aosbop
              and a.n_tope_bctop  = x.aotope
              and x.evtipo        in (3,4,6,7)
              and a.n_mod_bcmod not in (200,33)
              and a.n_tope_bctop <> 550
              and trunc(d.aud_fsd012_uon) >=vec_fecini
              and trunc(d.aud_fsd012_uon) <=vec_fecfin
              and d.aud_new_pgcod = x.pgcod
              and d.aud_new_aomod = x.aomod 
              and d.aud_new_aosuc = x.aosuc
              and d.aud_new_aomda = x.aomda
              and d.aud_new_aopap = x.aopap
              and d.aud_new_aocta = x.aocta
              and d.aud_new_aooper= x.aooper
              and d.aud_new_aosbop= x.aosbop
              and d.aud_new_aotope= x.aotope
              and d.aud_new_evtipo= x.evtipo
              and d.aud_new_evfval= x.evfval;
              commit;
    exception 
      when others then
        null;
    end sp_cr_cambio_tasa;
    ------------------------------------------------------------------------  
     
    ------------------------------------------------------------------------

end pq_cr_acl_report;
/

