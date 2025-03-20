create or replace package PQ_CR_COMISION_REACTIVA is

  -- Author  : SMARQUEZ
  -- Created : 9/12/2020 5:37:33 p. m.
  -- Purpose : Comision de Credito Reactiva  Peru

  procedure  SP_CR_CalculoComision(v1_Pgcod  in number,
                                   v1_Scmod  in number,
                                   v1_Scsuc  in number,
                                   v1_Scmda  in number,
                                   v1_Scpap  in number,
                                   v1_Sccta  in number,
                                   v1_Scoper in number,
                                   v1_Scsbop in number,
                                   v1_Sctope in number,
                                   v1_tran   in number,
                                   V1_MtoCom out number);

  procedure SP_CR_DatosPago(v_Pgcod  in number,
                           v_Scmod  in number,
                           v_Scsuc  in number,
                           v_Scmda  in number,
                           v_Scpap  in number,
                           v_Sccta  in number,
                           v_Scoper in number,
                           v_Scsbop in number,
                           v_Sctope in number,
                           v_anio   out number,
                           v_fpago  out date,
                           v_SdoCap out number,
                           f_inicio out date,
                           f_fin    out date,
                           v_numpag out number,
                           v_mtocal out number,
                           v_porceGA out number,
                           v_interes out number);  --fecha menos 90) return number;



  Procedure SP_CR_constantes(Tasa_subasta out number,
                             Tasa_BCRP out number,
                             Com_Financia out number,
                             Tasa_cliente out number,
                             Tasa_REPO out number,
                             Tasa_GARANTIA out number);

  Procedure SP_Verifica_Com (v1_Pgcod  in number,
                             v1_Scmod  in number,
                             v1_Scsuc  in number,
                             v1_Scmda  in number,
                             v1_Scpap  in number,
                             v1_Sccta  in number,
                             v1_Scoper in number,
                             v1_Scsbop in number,
                             v1_Sctope in number,
                             v1_tran   in number,
                             V1_FlagPa out varchar2,
                             V1_FlagNro  out number);

  procedure SP_CR_DatPagoReg(v_Pgcod  in number,
                             v_Scmod  in number,
                             v_Scsuc  in number,
                             v_Scmda  in number,
                             v_Scpap  in number,
                             v_Sccta  in number,
                             v_Scoper in number,
                             v_Scsbop in number,
                             v_Sctope in number,
                             v_anio   out number,
                             v_fpago  out date,
                             v_SdoCap out number,
                             f_inicio out date,
                             f_fin    out date,
                             v_numpag out number,
                             v_porgar out number,
                             v_mtocal out number);


  procedure  SP_CR_ComisionHonrado(v1_Pgcod  in number,
                                   v1_Scmod  in number,
                                   v1_Scsuc  in number,
                                   v1_Scmda  in number,
                                   v1_Scpap  in number,
                                   v1_Sccta  in number,
                                   v1_Scoper in number,
                                   v1_Scsbop in number,
                                   v1_Sctope in number,
                                   v1_tran   in number,
                                   v1_existe out number,
                                   V1_MtoCom out number,
                                   v1_DEBE   out varchar2);

procedure sp_cr_verlogs(ln_pgcod    in number,
                         ln_suc      in number,
                         ln_itmod    in number,
                         ln_ittran   in number,
                         ln_itrel    in number,
                         ln_itord    in number,
                         ln_itsbor   in number,
                         ln_cuenta   in number,
                         ln_monto    in number,
                         Lc_nompro   in varchar2);
                         
end PQ_CR_COMISION_REACTIVA;
/

create or replace package body PQ_CR_COMISION_REACTIVA is
  -- Author  : SMARQUEZ
  -- Created : 9/12/2020 5:37:33 p. m.
  -- Purpose : Comision de Credito Reactiva  Peru
  -- Author  : SMARQUEZ
  -- Modificación: Se quito la sucursal para las consultas por la transferencia de cartera
  -- Fecha: 08/11/2021
  -- Modificación: se remplazo NVL(max(pp1nump ),0) por count(*)
  -- Fecha: 10/01/2022
  -- SMARQUEZ
  -- Modificación: calculo correcto del monto de comision anter de cumplir la fecha de aniversario
  -- Fecha: 10/01/2022
  --  Author  : SMARQUEZ
  -- Modificación: Se quito la suboperacion  en la tabla aqpa551 en las consultas para reprogramacion 2022 reactiva
  -- Fecha: 17/08/2022
  --  Author  : SMARQUEZ
  -- Modificación: logs para ver  actualización de la tabla aqpa551
  -- Fecha: 18/11/2022


  procedure  SP_CR_CalculoComision(v1_Pgcod  in number,
                                   v1_Scmod  in number,
                                   v1_Scsuc  in number,
                                   v1_Scmda  in number,
                                   v1_Scpap  in number,
                                   v1_Sccta  in number,
                                   v1_Scoper in number,
                                   v1_Scsbop in number,
                                   v1_Sctope in number,
                                   v1_tran   in number,
                                   V1_MtoCom out number)is


  ln_anio number;
  ld_fpag date;
  ln_sldo number(17,2);
  ld_feini date;
  ld_fefin date;
  ln_monto number;
  T_subasta number(10,6);
  T_BCRP number(10,6);
  Com_Fin number(10,6);
  T_cliente number(10,6);
  T_REPO number(10,6);
  T_GARANTIA number(10,6);
  ln_PorceGA number;
  ln_interes number;
  dias number;
  CapCubierto number(17,3):=0;
  SdoIniInteres number(17,3):=0;
  IntDeven number(17,3):=0;
  ComGaran number(17,3):=0;
  ComSobInt number(17,3):=0;
  TotalCom number(17,3):=0;
  A_monto number(17,3) :=0;
  B_monto number(17,3) :=0;
  C_monto number(17,3) :=0;
  C_ajustado number(17,3) :=0;
  numeropago number(17):=0;
  factual date;
  flagDebe varchar2(1);
  numCom number;
  ln_Existe1 number :=0;
  ld_FechaNewFin date;
  v1_capital number(17,3);
  v1_porceGA number(17,2);
  Begin

      select pgfape into factual from fst017 where pgcod = 1  ;
     -- datos iniciales
      SP_CR_constantes( T_subasta, -- se debe obtener de otra manera
                         T_BCRP,
                         Com_Fin,
                         T_cliente,
                         T_REPO,
                         T_GARANTIA);

    if v1_tran <> 150 then --- pagos regulares
    -- 1 verificar si es Honramiento
    -- 2 Cálculo de comisión Garantía
     -- Calculo A

     SP_CR_DatPagoReg(v1_Pgcod,
                      v1_Scmod,
                      v1_Scsuc,
                      v1_Scmda,
                      v1_Scpap,
                      v1_Sccta,
                      v1_Scoper,
                      v1_Scsbop,
                      v1_Sctope,
                      ln_anio,
                      ld_fpag,--fecha pago
                      ln_sldo,
                      ld_feini,
                      ld_fefin,
                      numeropago, --numero cuota pagada
                      ln_PorceGA,
                      ln_monto);
       --A=Capital coberturado Inicial * Tasa Comisión Garantía
       A_monto := (ln_monto * ln_PorceGA )* T_GARANTIA  ;
     -- Calculo B
       CapCubierto:=  ln_monto *  ln_PorceGA;
     -- Dias transcurridos
       ------------------------------------------
        if factual >   ld_fefin then
          ld_fefin := factual;
        end if;
       ------------------------------------------
       dias := 365;--ld_fefin -ld_feini;
     -- calculo Ajustado
      -- C_ajustado := ((power((1 + T_REPO), (dias/360)))-1)* ln_monto;
        C_ajustado := round(((power((1 + T_REPO), (1/360)))-1)* CapCubierto,2)*dias;
        B_monto := C_ajustado * T_GARANTIA;
     -- Calculo C
        if   ln_anio = 1 THEN
          C_monto := 0;
        else
      -- PAGO DE SEGUNDA COMISIÓN PAGO REGULAR (SIN PREPAGOS), EL CLIENTE SE APROXIMA A
      -- CAJA A REALIZAR EL PAGO DE SU CUOTA SEGÚN CRONOGRAMA , LA CUAL PUEDE COINCIDIR O ESTAR CERCA A LA FECHA DE SEGUNDO ANIVERSARIO.
           C_monto :=  CapCubierto * T_REPO *(90/360)*T_GARANTIA;
        end if;
       V1_MtoCom := A_monto + B_monto + C_monto;
       SP_Verifica_Com(v1_Pgcod,
                      v1_Scmod,
                      v1_Scsuc,
                      v1_Scmda,
                      v1_Scpap,
                      v1_Sccta,
                      v1_Scoper,
                      v1_Scsbop,
                      v1_Sctope,
                      v1_tran,
                      flagDebe,
                      numCom);
    if flagDebe = 'S' then
       update aqpa551
         set  aqpa551fpro = factual,
              aqpa551saldo = ln_monto,
              aqpa551fecini = ld_feini,
              aqpa551fecfin = ld_fefin,
              aqpa551dias  = dias,
              aqpa551cubierto = CapCubierto,
              aqpa551interes = C_ajustado,
              aqpa551CA1 = A_monto,
              aqpa551CA2 = B_monto,
              aqpa551CA3 = C_monto
        where aqpa551cod = v1_Pgcod
          and aqpa551mod = v1_Scmod
        --  and aqpa551suc = v1_Scsuc
          and aqpa551mda = v1_Scmda
          and aqpa551pap = v1_Scpap
          and aqpa551cta = v1_Sccta
          and aqpa551oper = v1_Scoper
        --  and aqpa551sbop = v1_Scsbop sma 17.08.22
          and aqpa551tope = v1_Sctope
          and aqpa551nro  = numCom
          and aqpa551au1 = v1_tran;
           commit;
     end if;
    else  ----  30/150 Cancelación total

           SP_CR_DatosPago(v1_Pgcod,
                          v1_Scmod,
                          v1_Scsuc,
                          v1_Scmda,
                          v1_Scpap,
                          v1_Sccta,
                          v1_Scoper,
                          v1_Scsbop,
                          v1_Sctope,
                          ln_anio,
                          ld_fpag, --fecha pago
                          ln_sldo,
                          ld_feini,
                          ld_fefin,
                          numeropago, -- numero pago
                          ln_monto,--  monto
                          ln_PorceGA,--porcentaje
                          ln_interes);

          -- aDICION DE VERIFICACION DE PAGOS SMA 08062022
            bEGIN
              select 1, aqpa551fecfin
                into ln_Existe1, ld_FechaNewFin
                from aqpa551
              where aqpa551cod = v1_Pgcod
                and aqpa551mod = v1_Scmod
               -- and aqpa551suc = v1_Scsuc
                and aqpa551mda = v1_Scmda
                and aqpa551pap = v1_Scpap
                and aqpa551cta = v1_Sccta
                and aqpa551oper = v1_Scoper
              --  and aqpa551sbop = v1_Scsbop sma 17.08.22
                and aqpa551tope = v1_Sctope
                and aqpa551nro  = ( select Max(aqpa551nro)
                                      from aqpa551
                                    where aqpa551cod = v1_Pgcod
                                      and aqpa551mod = v1_Scmod
                                     -- and aqpa551suc = v1_Scsuc
                                      and aqpa551mda = v1_Scmda
                                      and aqpa551pap = v1_Scpap
                                      and aqpa551cta = v1_Sccta
                                      and aqpa551oper = v1_Scoper
                                     -- and aqpa551sbop = v1_Scsbop
                                      and aqpa551tope = v1_Sctope
                                      and aqpa551au3 = 'S'
                                      and aqpa551nro < 99)
                and aqpa551au3 = 'S';
            Exception
              when no_data_found then
                ln_Existe1 := 0;
                ld_FechaNewFin := null;
            End;

            if ln_Existe1 = 1 then
               v1_capital := 0;

               Select sum(ppcap)
                 into v1_capital
                 from fsd601
                where pgcod = v1_Pgcod
                  and ppmod = v1_Scmod
                  and ppsuc = v1_Scsuc
                  and ppmda = v1_Scmda
                  and pppap = v1_Scpap
                  and ppcta = v1_Sccta
                  and ppoper = v1_Scoper
                  and ppsbop = v1_Scsbop
                  and pptope = v1_Sctope
                  and ppfpag >  ld_FechaNewFin ;
              if v1_capital<> 0 then
                Begin
                  select tp1nro1/100
                    into v1_porceGA
                    from fst198
                   where tp1cod = 1
                     and tp1cod1 = 10884
                     and tp1corr1 = 50
                     and v1_capital between tp1imp1 and tp1imp2;
               exception
                 when no_data_found then
                   v1_porceGA := 1;
               end;
               ln_monto := v1_capital;
               ln_PorceGA := v1_porceGA;
              end if;
           end if;
              ---------------
          if ld_fpag is not null then
              ld_feini := ld_fefin; --ld_fpag;---
              ld_fefin := factual; --
          else

            ld_fefin := factual;

            if ld_FechaNewFin <> null AND ld_FechaNewFin <= factual then
               ld_feini := ld_FechaNewFin;

            end if;

          end if;

           ---- CALCULAMOS--------------------------
      --     Dias transcurridos
           dias := ld_fefin - ld_feini; --(b-c)
      --   Capital Cubierto
           CapCubierto:=  ln_monto *  ln_PorceGA; --(a X d)
      -- SALDO INICIAL DE INTERESES DEVENGADOS DEL BCRP PARA EL CALCULO DE LA  COMISION
           SdoIniInteres:= ((power((1 + T_REPO), (dias/360)))-1)* ln_monto;-- e
      ---   Interes := ln_interes * T_BCRP; -- e
           IntDeven:= SdoIniInteres * ln_PorceGA; -- (a x e)
           --- ln_anio identificacion del año
      --  1 (COMISION DE GARANTIA/360*DIAS TRANSCURRIDOS)*CAPITAL CUBIERTO
           ComGaran:= (T_GARANTIA /360*dias)*CapCubierto;
      --  2  COMISION DE GARANTIA SOBRE EL INTERES BCRP CUBIERTO
      --  (COMISION DE GARANTIA/360*DIAS TRANSCURRIDOS)*INTERES DEVENGADO/PRORRATEADO BCRP CUBIERTO
          ComSobInt := (T_GARANTIA /360*dias)* IntDeven;
      ---  3 COMISION INTERES BCRP CUBIERTO POR IMPAGO ¿ 3 MESES (0.5%)
          --SI EL PREPAGO ES TOTAL EL VALOR ES CERO EN CUALQUIER AÑO
      --  Total comision
          TotalCom := ComGaran + ComSobInt;
          V1_MtoCom :=  TotalCom;
             SP_Verifica_Com(v1_Pgcod,
                        v1_Scmod,
                        v1_Scsuc,
                        v1_Scmda,
                        v1_Scpap,
                        v1_Sccta,
                        v1_Scoper,
                        v1_Scsbop,
                        v1_Sctope,
                        v1_tran,
                        flagDebe,
                        numCom);
    if flagDebe = 'S' then

       update aqpa551
         set  aqpa551fpro  = factual,
              aqpa551saldo = ln_monto,
              aqpa551fecini = ld_feini,
              aqpa551fecfin = ld_fefin,
              aqpa551dias  = dias,
              aqpa551cubierto = CapCubierto,
              aqpa551interes = SdoIniInteres,
              aqpa551CA1 = ComGaran,
              aqpa551CA2 = ComSobInt,
              aqpa551CA3 = C_monto
        where aqpa551cod = v1_Pgcod
          and aqpa551mod = v1_Scmod
          --and aqpa551suc = v1_Scsuc
          and aqpa551mda = v1_Scmda
          and aqpa551pap = v1_Scpap
          and aqpa551cta = v1_Sccta
          and aqpa551oper = v1_Scoper
          --and aqpa551sbop = v1_Scsbop sma 17.08.22
          and aqpa551tope = v1_Sctope
          and aqpa551nro  = 99
          and aqpa551au1 = v1_tran;
           commit;
     end if;
   end if;

  end SP_CR_CalculoComision;

 procedure SP_CR_DatosPago(v_Pgcod  in number,
                           v_Scmod  in number,
                           v_Scsuc  in number,
                           v_Scmda  in number,
                           v_Scpap  in number,
                           v_Sccta  in number,
                           v_Scoper in number,
                           v_Scsbop in number,
                           v_Sctope in number,
                           v_anio   out number,
                           v_fpago  out date,
                           v_SdoCap out number,
                           f_inicio out date,
                           f_fin    out date,
                           v_numpag out number,
                           v_mtocal out number,
                           v_porceGA out number,
                           v_interes out number)is
  cursor capital is
   select * from fsd601
    where pgcod = v_Pgcod
      and ppmod = v_Scmod
      and ppsuc = v_Scsuc
      and ppmda = v_Scmda
      and pppap = v_Scpap
      and ppcta = v_Sccta
      and ppoper = v_Scoper
      and ppsbop = v_Scsbop
      and pptope = v_Sctope
      order by  ppfpag;

  v_pp1nump number;
  v_fecha date;
  v_capital number(17,2);
  v_cuotas number:= 1;
  suma1 number(17,2) :=0;
  suma2 number(17,2) :=0;
  suma3 number(17,2) :=0;
  fecha_pago1 date;
  fecha_pago2 date;
  fecha_pago3 date;
  fecha_fin1 date;
  fecha_fin2 date;
  fecha_fin3 date;
  v_fedes date;
  v_fevto date;
  v_monto number(17,2):=0;
  modulo number;
  tipope number;
  cont1 number :=0;
  cont2 number :=0;
  cont3 number :=0;
  interes1 number(17,2):=0;
  interes2 number(17,2):=0;
  interes3 number(17,2):=0;
  interesV1 number(17,2):=0;
  interesV2 number(17,2):=0;
  interesV3 number(17,2):=0;
  fecha_f1 date;
  fecha_f2 date;
  fecha_f3 date;
  v_indi number := 1;
  Sinsoluto number(17,2):=0;
  estado number;
  ln_pp1nump number;
  begin

   -- verifica modulo y transaccion
     select c.tp1nro1, c.tp1nro2
       into modulo, tipope
       from fst198 c
      where c.tp1cod = 1
        and c.tp1cod1 = 11141
        and c.tp1corr1 = 11
        and c.tp1corr2 = 1;

    if v_Scmod = modulo and v_Sctope = tipope then
   ---Datos de la 10
      begin

        select aofval, aofvto, aoimp, aostat
         into  v_fedes, v_fevto, v_monto, estado
         from fsd010
        where pgcod = v_Pgcod
          and aomod = v_Scmod
          and aosuc = v_Scsuc
          and aomda = v_Scmda
          and aopap = v_Scpap
          and aocta = v_Sccta
          and aooper = v_Scoper
          and aosbop = v_Scsbop
          and aotope = v_Sctope
          and aostat <> 99;
      exception
        when no_data_found then
          null;
      end;
   --   numcuotas
        cont1 := 1;
        cont2 := 1;
        cont3 := 1;
        for a in capital loop
          if v_cuotas <= 12 then
            suma1 := suma1 + a.ppcap;
            fecha_pago1 := a.ppfpag;
            if cont1 = 1 then
              interes1 := a.ppint;
              interesV1 := a.ppint;
              cont1 := cont1 + 1;
              fecha_f1 := a.ppfpag;
            else
              interesV1 := interesV1 +a.ppint;
              cont1 := cont1 + 1;
            end if;
          end if;

          if v_cuotas = 13 then
            fecha_fin1 := a.ppfpag;
          end if;

          if v_cuotas> 12 and v_cuotas <= 24 then
            suma2 := suma2 + a.ppcap;
            fecha_pago2 := a.ppfpag;
            if cont2 = 1 then
              interes2 := interesV1 +a.ppint;
              interesV2 :=interes2;
              cont2 := cont2 + 1;
              fecha_f2 := a.ppfpag;
            else
              interesV2 := interesV2 +a.ppint;
              cont2 := cont2 + 1;
            end if;
          end if;

          if v_cuotas = 25 then
            fecha_fin2 := a.ppfpag;
          end if;

          if v_cuotas > 24 and v_cuotas <= 36 then
            suma3 := suma3 + a.ppcap;
            fecha_pago3 := a.ppfpag;
            if cont3 = 1 then
              interes3 := interesV2 +a.ppint;
              interesV3 :=interes3;
              fecha_f3 := a.ppfpag;
              cont3 := cont3 + 1;
            else
              interesV3 := interesV3 +a.ppint;
              cont3 := cont3 + 1;
            end if;
          end if;

          if v_cuotas = 36 then
            fecha_fin3 := a.ppfpag;
          end if;

          v_cuotas := v_cuotas + 1;
       end loop;

        select count(*) +1 ,max(pp1nump)
         into v_pp1nump, ln_pp1nump
         from fsd602
        where pgcod = v_Pgcod
          and ppmod = v_Scmod
          and ppsuc = v_Scsuc
          and ppmda = v_Scmda
          and pppap = v_Scpap
          and ppcta = v_Sccta
          and ppoper = v_Scoper
          and ppsbop = v_Scsbop
          and pptope = v_Sctope
          and pp1stat ='T'          
          and d602co='S' 
          and not exists (select 1
                            from fst198
                           where tp1cod = 1 
                             and tp1cod1 =10884 
                             and tp1corr1 = 68  
                             and tp1corr2 = 0
                             and tp1nro1 = d602mo 
                             and tp1nro2 = d602tr ) ;


          v_numpag := v_pp1nump;
  --- Busca Rango

           if v_pp1nump = 0   then
              v_anio:= 1;
              v_mtocal := v_monto;
              v_interes := interes1;
              f_inicio := v_fedes;
              f_fin    := fecha_f1;--fecha_fin1;--- fecha_f1;
           end if;

           if (v_pp1nump >= 1 and v_pp1nump < 13)  then
              v_anio:= 1;
              v_mtocal := v_monto;
              v_interes := interes1;
              f_inicio := v_fedes;
              f_fin    := fecha_f1; --fecha_fin1;

           end if;

           if v_pp1nump >= 13 and v_pp1nump < 25 then
              v_anio:= 2;
              v_fpago := fecha_pago1;
              f_inicio := fecha_f1; -- fecha_pago1;
              f_fin    := fecha_pago1;--fecha_fin1; -- fecha_f2;

              pq_cr_reporte_fondos_p3.sp_obtener_sald_insol2(v_pgcod, ----> Entrada
                                                             v_scmod, ----> Entrada
                                                             v_scsuc, ----> Entrada
                                                             v_scmda, ----> Entrada
                                                             v_scpap, ----> Entrada
                                                             v_sccta, ----> Entrada
                                                             v_scoper, ----> Entrada
                                                             v_scsbop, ----> Entrada
                                                             v_sctope, ----> Entrada
                                                             fecha_pago1, ----> Entrada: Fecha de corte
                                                             v_indi,  ----> Entrada: Indicador = 1 (REACTIVA)
                                                             estado,
                                                             Sinsoluto);
               v_mtocal := Sinsoluto;
           end if;

           if v_pp1nump >= 25 and v_pp1nump <= 36 then
              v_anio:= 3;
              v_fpago := fecha_pago2;
              f_inicio := fecha_f2; --fecha_pago2; --verificar inicio
              f_fin    := fecha_fin2; --fecha_f3; ---fecha_fin3;

              pq_cr_reporte_fondos_p3.sp_obtener_sald_insol2(v_pgcod, ----> Entrada
                                                             v_scmod, ----> Entrada
                                                             v_scsuc, ----> Entrada
                                                             v_scmda, ----> Entrada
                                                             v_scpap, ----> Entrada
                                                             v_sccta, ----> Entrada
                                                             v_scoper, ----> Entrada
                                                             v_scsbop, ----> Entrada
                                                             v_sctope, ----> Entrada
                                                             fecha_pago2, ----> Entrada: Fecha de corte
                                                             v_indi,  ----> Entrada: Indicador = 1 (REACTIVA)
                                                             estado,
                                                             Sinsoluto);

               v_mtocal := Sinsoluto;
           end if;
  -- porcentaje de Garantía

        Begin

          select tp1nro1/100
            into v_porceGA
            from fst198
           where tp1cod = 1
             and tp1cod1 = 10884
             and tp1corr1 = 50
             and v_mtocal between tp1imp1 and tp1imp2;
         exception
           when no_data_found then
             v_porceGA := 0;
         end;
 -- porcentaje
          Begin
           Select ppfpag
             into v_fecha
             from fsd602
            where pgcod = v_Pgcod
              and ppmod = v_Scmod
              and ppsuc = v_Scsuc
              and ppmda = v_Scmda
              and pppap = v_Scpap
              and ppcta = v_Sccta
              and ppoper = v_Scoper
              and ppsbop = v_Scsbop
              and pptope = v_Sctope
              and pp1nump = ln_pp1nump --v_pp1nump
              and pp1stat = 'T'
              and d602co = 'S' 
              and not exists (select 1
                            from fst198
                           where tp1cod = 1 
                             and tp1cod1 =10884 
                             and tp1corr1 = 68  
                             and tp1corr2 = 0
                             and tp1nro1 = d602mo 
                             and tp1nro2 = d602tr );
              v_fpago := v_fecha;

             begin

               Select sum(ppcap), sum (ppint)
                 into v_capital,v_interes
                 from fsd601
                where pgcod = v_Pgcod
                  and ppmod = v_Scmod
                  and ppsuc = v_Scsuc
                  and ppmda = v_Scmda
                  and pppap = v_Scpap
                  and ppcta = v_Sccta
                  and ppoper = v_Scoper
                  and ppsbop = v_Scsbop
                  and pptope = v_Sctope
                  and ppfpag >  v_fecha ;

                  v_SdoCap := v_capital;
              Exception
                when no_Data_found then
                  v_SdoCap := v_capital;
              End;
         exception

           when no_data_found then
             begin
               Select sum(ppcap), sum (ppint)
                 into v_capital,v_interes
                 from fsd601
                where pgcod = v_Pgcod
                  and ppmod = v_Scmod
                  and ppsuc = v_Scsuc
                  and ppmda = v_Scmda
                  and pppap = v_Scpap
                  and ppcta = v_Sccta
                  and ppoper = v_Scoper
                  and ppsbop = v_Scsbop
                  and pptope = v_Sctope
                  and ppfpag >  v_fecha ;
                  v_SdoCap := v_capital;
              Exception
                when no_Data_found then
                  v_SdoCap := v_capital;
              End;
             v_fpago := null;
         end;
    end if;
  end SP_CR_DatosPago;

  Procedure SP_CR_constantes(Tasa_subasta out number,
                             Tasa_BCRP    out number,
                             Com_Financia out number,
                             Tasa_cliente out number,
                             Tasa_REPO    out number,
                             Tasa_GARANTIA out number)is

    begin
       SELECT tp1imp1 /100
         into Tasa_subasta
         from fst198
        where tp1cod = 1
          and tp1cod1 = 10884
          and tp1corr1 = 51
          and tp1corr2 = 0
          and tp1corr3 = 1;

       SELECT tp1imp1/100
         into Tasa_BCRP
         from fst198
        where tp1cod = 1
          and tp1cod1 = 10884
          and tp1corr1 = 51
          and tp1corr2 = 0
          and tp1corr3 = 2;

       SELECT tp1imp1/100
         into Com_Financia
         from fst198
        where tp1cod = 1
          and tp1cod1 = 10884
          and tp1corr1 = 51
          and tp1corr2 = 0
          and tp1corr3 = 3;

       SELECT tp1imp1/100
         into Tasa_cliente
         from fst198
        where tp1cod = 1
          and tp1cod1 = 10884
          and tp1corr1 = 51
          and tp1corr2 = 0
          and tp1corr3 = 4;


       SELECT tp1imp1/100
         into Tasa_REPO
         from fst198
        where tp1cod = 1
          and tp1cod1 = 10884
          and tp1corr1 = 51
          and tp1corr2 = 0
          and tp1corr3 = 5;

       SELECT tp1imp1/100
         into Tasa_GARANTIA
         from fst198
        where tp1cod = 1
          and tp1cod1 = 10884
          and tp1corr1 = 51
          and tp1corr2 = 0
          and tp1corr3 = 6;
    exception
      when others then
      Tasa_subasta := 0;
      Tasa_BCRP := 0;
      Tasa_REPO :=0;
      Tasa_GARANTIA := 0;
      Tasa_cliente:= 0;
      Com_Financia :=0;
    end SP_CR_constantes;

  Procedure SP_Verifica_Com (v1_Pgcod  in number,
                             v1_Scmod  in number,
                             v1_Scsuc  in number,
                             v1_Scmda  in number,
                             v1_Scpap  in number,
                             v1_Sccta  in number,
                             v1_Scoper in number,
                             v1_Scsbop in number,
                             v1_Sctope in number,
                             v1_tran   in number,
                             V1_FlagPa out varchar2,--'S' Debe pagar 'N' No Debe
                             V1_FlagNro out number)is

   existe number:=0;
   nro number:=0;
   fecha date;
   cont number:=0;
   nroprima number:=0;
   nropago number:=0;
   flag char(1);

   begin

     select pgfape into fecha from fst017 where pgcod = 1;
     if v1_tran <> 150 then -- Pago Regular
        delete aqpa551
            where aqpa551cod = v1_Pgcod
              and aqpa551mod = v1_Scmod
            --  and aqpa551suc = v1_Scsuc
              and aqpa551mda = v1_Scmda
              and aqpa551pap = v1_Scpap
              and aqpa551cta = v1_Sccta
              and aqpa551oper = v1_Scoper
             -- and aqpa551sbop = v1_Scsbop sma 17.08.22
              and aqpa551tope = v1_Sctope
              and aqpa551nro = 99
              and aqpa551au3 = 'N';
            commit;
         Begin
           select 1
             into existe
             from aqpa551
            where aqpa551cod = v1_Pgcod
              and aqpa551mod = v1_Scmod
             -- and aqpa551suc = v1_Scsuc
              and aqpa551mda = v1_Scmda
              and aqpa551pap = v1_Scpap
              and aqpa551cta = v1_Sccta
              and aqpa551oper = v1_Scoper
             -- and aqpa551sbop = v1_Scsbop sma 17.08.22
              and aqpa551tope = v1_Sctope
              and rownum = 1;
         exception
          when no_data_found then
            existe := 0;
         end;
         cont:= 1;
         if  existe = 0 then
           ---insert en la tabla
           Begin
             select nvl(abs((aofvto - aofval)/360),0)
               into nro
               from fsd010
              where pgcod = v1_Pgcod
                and aomod = v1_Scmod
               -- and aosuc = v1_Scsuc
                and aomda = v1_Scmda
                and aopap = v1_Scpap
                and aocta = v1_Sccta
                and aooper = v1_Scoper
              --  and aosbop = v1_Scsbop sma 17.08.22
                and aotope = v1_Sctope;
           exception
             when no_data_found then
               nro := 0;
           end;

           if nro <> 0 then
             while cont <= nro loop
               insert into aqpa551(aqpa551cod,
                                   aqpa551mod,
                                   aqpa551suc,
                                   aqpa551mda,
                                   aqpa551pap,
                                   aqpa551cta,
                                   aqpa551oper,
                                   aqpa551sbop,
                                   aqpa551tope,
                                   aqpa551nro,
                                   aqpa551fpro,
                                   aqpa551au1,
                                   aqpa551au3,
                                   Aqpa551au4)
                            values (v1_Pgcod,
                                    v1_Scmod,
                                    v1_Scsuc,
                                    v1_Scmda,
                                    v1_Scpap,
                                    v1_Sccta,
                                    v1_Scoper,
                                    v1_Scsbop,
                                    v1_Sctope,
                                    cont,
                                    fecha,
                                    v1_tran,
                                    'N',
                                    'PREGULAR');
               commit;
               cont := cont + 1;
             end loop;
             V1_FlagPa := 'S';
             V1_FlagNRO := 1;
           end if;
         else

           -- Obtenemos el maximo numero de pago
             Select count(*) +1
               into nroprima
               from fsd602
              where pgcod = v1_Pgcod
                and ppmod = v1_Scmod
            --    and ppsuc = v1_Scsuc
                and ppmda = v1_Scmda
                and pppap = v1_Scpap
                and ppcta = v1_Sccta
                and ppoper = v1_Scoper
             --   and ppsbop = v1_Scsbop
                and pptope = v1_Sctope
                and pp1stat = 'T'
                and d602co = 'S'
                and not exists (select 1
                            from fst198
                           where tp1cod = 1 
                             and tp1cod1 =10884 
                             and tp1corr1 = 68  
                             and tp1corr2 = 0
                             and tp1nro1 = d602mo 
                             and tp1nro2 = d602tr )  ;
           if nroprima >= 0 and nroprima <= 12 then
              nropago := 1;
           elsif nroprima >= 13 and nroprima <= 24 then
              nropago := 2;
           else
              nropago := 3;

           end if;

           Begin

             select trim(aqpa551au3)
               into flag
               from aqpa551
              where aqpa551cod = v1_Pgcod
                and aqpa551mod = v1_Scmod
              --  and aqpa551suc = v1_Scsuc
                and aqpa551mda = v1_Scmda
                and aqpa551pap = v1_Scpap
                and aqpa551cta = v1_Sccta
                and aqpa551oper = v1_Scoper
               -- and aqpa551sbop = v1_Scsbop sma 17.08.22
                and aqpa551tope = v1_Sctope
                and aqpa551nro  = nropago;
            exception
              when no_data_found then
                null; ---verificar que hacer
            end;
            if flag ='N' then
              V1_FlagPa := 'S';
              V1_FlagNRO := nropago;
            else
              V1_FlagPa := 'N';
              V1_FlagNRO := 0;
            end if;
         end if;

     else -- cANCELACION tOTAL ANTES DE  TIEMPO

        Begin
           select 1
             into existe
             from aqpa551
            where aqpa551cod = v1_Pgcod
              and aqpa551mod = v1_Scmod
            ---  and aqpa551suc = v1_Scsuc
              and aqpa551mda = v1_Scmda
              and aqpa551pap = v1_Scpap
              and aqpa551cta = v1_Sccta
              and aqpa551oper = v1_Scoper
             -- and aqpa551sbop = v1_Scsbop sma 17.08.22
              and aqpa551tope = v1_Sctope
              and aqpa551nro  = 99
              and aqpa551au1 = 150;
         exception
          when no_data_found then
            existe := 0;
         end;
         cont:= 1;
         if  existe = 0 then
           ---insert en la tabla
           cont := 99;
           begin

               insert into aqpa551(aqpa551cod,
                                   aqpa551mod,
                                   aqpa551suc,
                                   aqpa551mda,
                                   aqpa551pap,
                                   aqpa551cta,
                                   aqpa551oper,
                                   aqpa551sbop,
                                   aqpa551tope,
                                   aqpa551nro,
                                   aqpa551fpro,
                                   aqpa551au1,
                                   aqpa551au3,
                                   Aqpa551au4)
                            values (v1_Pgcod,
                                    v1_Scmod,
                                    v1_Scsuc,
                                    v1_Scmda,
                                    v1_Scpap,
                                    v1_Sccta,
                                    v1_Scoper,
                                    v1_Scsbop,
                                    v1_Sctope,
                                    cont,
                                    fecha,
                                    150,
                                    'N',
                                    'PREPAGOTOTAL');
               commit;
             EXCEPTION
               WHEN DUP_VAL_ON_INDEX THEN
                 NULL;
             END;

             V1_FlagPa := 'S';
             V1_FlagNRO := 1;

         else

           -- Obtenemos el maximo numero de pago

             Select count(*) +1 ---NVL(Max(pp1nump),0) + 1 sma
               into nroprima
               from fsd602
              where pgcod = v1_Pgcod
                and ppmod = v1_Scmod
               -- and ppsuc = v1_Scsuc
                and ppmda = v1_Scmda
                and pppap = v1_Scpap
                and ppcta = v1_Sccta
                and ppoper = v1_Scoper
                and ppsbop = v1_Scsbop
                and pptope = v1_Sctope
                and pp1stat = 'T'
                and d602co = 'S' 
                and not exists (select 1
                            from fst198
                           where tp1cod = 1 
                             and tp1cod1 =10884 
                             and tp1corr1 = 68  
                             and tp1corr2 = 0
                             and tp1nro1 = d602mo 
                             and tp1nro2 = d602tr ) ;

           if nroprima >= 0 and nroprima <= 12 then
              nropago := 1;
           elsif nroprima >= 13 and nroprima <= 24 then
              nropago := 2;
           else
              nropago := 3;
           end if;

           Begin

             select trim(aqpa551au3)
               into flag
               from aqpa551
              where aqpa551cod = v1_Pgcod
                and aqpa551mod = v1_Scmod
              ---  and aqpa551suc = v1_Scsuc
                and aqpa551mda = v1_Scmda
                and aqpa551pap = v1_Scpap
                and aqpa551cta = v1_Sccta
                and aqpa551oper = v1_Scoper
              --  and aqpa551sbop = v1_Scsbop sma 17.08.22
                and aqpa551tope = v1_Sctope
                and aqpa551AU1  = 150;

            exception

              when no_data_found then

                null; ---verificar que hacer

            end;

            if flag ='N' then
              V1_FlagPa := 'S';
              V1_FlagNRO := nropago;
            else
              V1_FlagPa := 'N';
              V1_FlagNRO := 0;
            end if;
         end if;
     end if;

   end SP_Verifica_Com;


   procedure SP_CR_DatPagoReg(v_Pgcod  in number,
                             v_Scmod  in number,
                             v_Scsuc  in number,
                             v_Scmda  in number,
                             v_Scpap  in number,
                             v_Sccta  in number,
                             v_Scoper in number,
                             v_Scsbop in number,
                             v_Sctope in number,
                             v_anio   out number,
                             v_fpago  out date,
                             v_SdoCap out number,
                             f_inicio out date,
                             f_fin    out date,
                             v_numpag out number,
                             v_porgar out number,
                             v_mtocal out number)is
  cursor capital is
   select * from fsd601
    where pgcod = v_Pgcod
      and ppmod = v_Scmod
      and ppsuc = v_Scsuc
      and ppmda = v_Scmda
      and pppap = v_Scpap
      and ppcta = v_Sccta
      and ppoper = v_Scoper
      and ppsbop = v_Scsbop
      and pptope = v_Sctope
      order by  ppfpag;
  v_pp1nump number;
  v_fecha date;
  v_capital number(17,2);
--  fecha1 date;
--  fecha2 date;
--  numcuotas number := 0;
  v_meses number:= 1;
  suma1 number(17,2) :=0;
  suma2 number(17,2) :=0;
  suma3 number(17,2) :=0;
  fecha_pago1 date;
  fecha_pago2 date;
  fecha_pago3 date;
  fecha_fin1 date;
  fecha_fin2 date;
  fecha_fin3 date;
--  a1 number :=0;
--  a2 number :=0;
--  montodes number(17,2) :=0;
  v_fedes date;
  v_fevto date;
--  v_flag  char := 'N';
  v_monto number(17,2):=0;
  modulo number;
  tipope number;
--  porcentajeGA number(17,2) :=0;
  cont1 number :=0;
  cont2 number :=0;
  cont3 number :=0;
  interes1 number(17,2):=0;
  interes2 number(17,2):=0;
  interes3 number(17,2):=0;
  interesV1 number(17,2):=0;
  interesV2 number(17,2):=0;
  interesV3 number(17,2):=0;
  fecha_f1 date;
  fecha_f2 date;
  fecha_f3 date;
  v_indi number := 1;
  Sinsoluto number(17,2):=0;
  estado number;
  v_fechaaux date;
  begin
   -- verifica modulo y transaccion

     select c.tp1nro1, c.tp1nro2
       into modulo, tipope
       from fst198 c
      where c.tp1cod = 1
        and c.tp1cod1 = 11141
        and c.tp1corr1 = 11
        and c.tp1corr2 = 1;

    if v_Scmod = modulo and v_Sctope = tipope then
   ---Datos de la 10

        select aofval, aofvto, aoimp, aostat
         into  v_fedes, v_fevto, v_monto, estado
         from fsd010
        where pgcod = v_Pgcod
          and aomod = v_Scmod
     --     and aosuc = v_Scsuc
          and aomda = v_Scmda
          and aopap = v_Scpap
          and aocta = v_Sccta
          and aooper = v_Scoper
      --    and aosbop = v_Scsbop
          and aotope = v_Sctope
          and aostat <> 99;
   --   numcuotas :=  round((fecha2 - fecha1)/360)* 12;
        cont1 := 1;
        cont2 := 1;
        cont3 := 1;
        for a in capital loop

          if v_meses <= 12 then
            suma1 := suma1 + a.ppcap;
            fecha_pago1 := a.ppfpag;
            if cont1 = 1 then
              interes1 := a.ppint;
              interesV1 := a.ppint;
              cont1 := cont1 + 1;
              fecha_f1 := a.ppfpag;
            else
              interesV1 := interesV1 +a.ppint;
              cont1 := cont1 + 1;
            end if;
          end if;

          if v_meses = 13 then
            fecha_fin1 := a.ppfpag;
          end if;

          if v_meses> 12 and v_meses <= 24 then
            suma2 := suma2 + a.ppcap;
            fecha_pago2 := a.ppfpag;
            if cont2 = 1 then
              interes2 := interesV1 +a.ppint;
              interesV2 :=interes2;
              cont2 := cont2 + 1;
              fecha_f2 := a.ppfpag;
            else
              interesV2 := interesV2 +a.ppint;
              cont2 := cont2 + 1;
            end if;
          end if;

          if v_meses = 25 then
            fecha_fin2 := a.ppfpag;
          end if;

          if v_meses > 24 and v_meses <= 36 then
            suma3 := suma3 + a.ppcap;
            fecha_pago3 := a.ppfpag;
            if cont3 = 1 then
              interes3 := interesV2 +a.ppint;
              interesV3 :=interes3;
              fecha_f3 := a.ppfpag;
              cont3 := cont3 + 1;
            else
              interesV3 := interesV3 +a.ppint;
              cont3 := cont3 + 1;
            end if;
          end if;

          if v_meses = 36 then
             fecha_fin3 := a.ppfpag;
          end if;
          v_meses := v_meses + 1;
       end loop;

        select count(*) + 1, max(ppfpag)
         into v_pp1nump , v_fechaaux---- no siempre concuerda
         from fsd602
        where pgcod = v_Pgcod
          and ppmod = v_Scmod
          and ppsuc = v_Scsuc
          and ppmda = v_Scmda
          and pppap = v_Scpap
          and ppcta = v_Sccta
          and ppoper = v_Scoper
          and ppsbop = v_Scsbop
          and pptope = v_Sctope
          and pp1stat ='T'
          and d602co='S'
          and not exists (select 1
                            from fst198
                           where tp1cod = 1 
                             and tp1cod1 =10884 
                             and tp1corr1 = 68  
                             and tp1corr2 = 0
                             and tp1nro1 = d602mo 
                             and tp1nro2 = d602tr ) ;
          v_numpag := v_pp1nump;
  --- Busca Rango

           if v_pp1nump = 0   then
              v_anio:= 1;
              v_mtocal := v_monto; --monto desembolsado
              --v_interes := interes1;
              f_inicio := v_fedes;
              f_fin    := fecha_f1;--fecha_fin1;--- fecha_f1;
           end if;

           if (v_pp1nump >= 1 and v_pp1nump < 13)  then -- pago de la comision 2
              v_anio:= 1;
              v_mtocal := v_monto;
              --v_interes := interes1;
              f_inicio := v_fedes;
              f_fin    := fecha_f1; --fecha_fin1;
           end if;

           if v_pp1nump >= 13 and v_pp1nump < 25 then
              v_anio:= 2;
              v_fpago := fecha_pago1;
              f_inicio := fecha_f1; -- fecha_pago1;
              f_fin    := fecha_fin1; -- fecha_f2;

              pq_cr_reporte_fondos_p3.sp_obtener_sald_insol2(v_pgcod, ----> Entrada
                                                             v_scmod, ----> Entrada
                                                             v_scsuc, ----> Entrada
                                                             v_scmda, ----> Entrada
                                                             v_scpap, ----> Entrada
                                                             v_sccta, ----> Entrada
                                                             v_scoper, ----> Entrada
                                                             v_scsbop, ----> Entrada
                                                             v_sctope, ----> Entrada ---prueba linea abajo
                                                             fecha_fin1,---fecha_pago2, ----> Entrada: Fecha de corte
                                                             v_indi,  ----> Entrada: Indicador = 1 (REACTIVA)
                                                             estado,
                                                             Sinsoluto);
  
                --  v_mtocal := Sinsoluto; sma 05122022
            
           end if;

           if v_pp1nump >= 25 and v_pp1nump <= 36 then
              v_anio:= 3;
              v_fpago := fecha_pago2;
              f_inicio := fecha_f2; --fecha_pago2; --verificar inicio
              f_fin    := fecha_fin2; --fecha_f3; ---fecha_fin3;
               pq_cr_reporte_fondos_p3.sp_obtener_sald_insol2(v_pgcod, ----> Entrada
                                                             v_scmod, ----> Entrada
                                                             v_scsuc, ----> Entrada
                                                             v_scmda, ----> Entrada
                                                             v_scpap, ----> Entrada
                                                             v_sccta, ----> Entrada
                                                             v_scoper, ----> Entrada
                                                             v_scsbop, ----> Entrada
                                                             v_sctope, ----> Entrada
                                                             fecha_fin2,---fecha de corte
                                                             v_indi,  ----> Entrada: Indicador = 1 (REACTIVA)
                                                             estado, ----> estado credito
                                                             Sinsoluto);

          ---    v_mtocal := Sinsoluto; sma 051222
           end if;
 
     
         Begin
           begin
             Select ppfpag
               into v_fecha
               from fsd602
              where pgcod = v_Pgcod
                and ppmod = v_Scmod
                and ppsuc = v_Scsuc
                and ppmda = v_Scmda
                and pppap = v_Scpap
                and ppcta = v_Sccta
                and ppoper = v_Scoper
                and ppsbop = v_Scsbop
                and pptope = v_Sctope
                and pp1nump = v_pp1nump
                and pp1stat = 'T'
                and d602co = 'S'
                and not exists (select 1
                            from fst198
                           where tp1cod = 1 
                             and tp1cod1 =10884 
                             and tp1corr1 = 68  
                             and tp1corr2 = 0
                             and tp1nro1 = d602mo 
                             and tp1nro2 = d602tr ) ;
                v_fpago := v_fecha;
           exception 
             when no_data_found then
               v_fpago := v_fechaaux;
          end;
          if v_fpago  <> null then
             begin
               Select sum(ppcap)--, sum (ppint)
                 into v_capital--,v_interes
                 from fsd601
                where pgcod = v_Pgcod
                  and ppmod = v_Scmod
                  and ppsuc = v_Scsuc
                  and ppmda = v_Scmda
                  and pppap = v_Scpap
                  and ppcta = v_Sccta
                  and ppoper = v_Scoper
                  and ppsbop = v_Scsbop
                  and pptope = v_Sctope
                  and ppfpag > v_fpago;--  v_fecha ; sma051222
                  v_SdoCap := v_capital;
              Exception
                when no_Data_found then
                  v_SdoCap := v_capital;
              End;
           Else
             v_SdoCap := v_mtocal;
           end if;  
           exception
             when no_data_found then
               begin
                 Select sum(ppcap)--, sum (ppint)
                   into v_capital--,v_interes
                   from fsd601
                  where pgcod = v_Pgcod
                    and ppmod = v_Scmod
                    and ppsuc = v_Scsuc
                    and ppmda = v_Scmda
                    and pppap = v_Scpap
                    and ppcta = v_Sccta
                    and ppoper = v_Scoper
                    and ppsbop = v_Scsbop
                    and pptope = v_Sctope
                    and ppfpag >  v_fecha ;
                    v_SdoCap := v_capital;
                Exception
                  when no_Data_found then
                    v_SdoCap := v_capital;
                End;
               v_fpago := null;
           end;
          
           if Sinsoluto <> 0 then
             v_mtocal :=  Sinsoluto;
           else
             v_mtocal := v_SdoCap;
           end if;  
  -- porcentaje de Garantía 
        Begin
          select tp1nro1/100
            into v_porgar
            from fst198
           where tp1cod = 1
             and tp1cod1 = 10884
             and tp1corr1 = 50
             and v_mtocal between tp1imp1 and tp1imp2;
         exception
           when no_data_found then
             v_porgar := 0;
         end;

  -- porcentaje     
    end if;

  end SP_CR_DatPagoReg;
  procedure  SP_CR_ComisionHonrado(v1_Pgcod  in number,
                                   v1_Scmod  in number,
                                   v1_Scsuc  in number,
                                   v1_Scmda  in number,
                                   v1_Scpap  in number,
                                   v1_Sccta  in number,
                                   v1_Scoper in number,
                                   v1_Scsbop in number,
                                   v1_Sctope in number,
                                   v1_tran   in number,
                                   v1_existe out number,
                                   V1_MtoCom out number,
                                   v1_DEBE   out varchar2)is
  ln_anio number;
  ld_fpag date;
  ln_sldo number(17,2);
 -- lc_flag varchar2(1);
  ---ln_x100 number(17,2);
  ld_feini date;
  ld_fefin date;
  ln_monto number;
  T_subasta number(10,6);
  T_BCRP number(10,6);
  Com_Fin number(10,6);
  T_cliente number(10,6);
  T_REPO number(10,6);
  T_GARANTIA number(10,6);
  ln_PorceGA number;
  ln_interes number;
  dias number;
  CapCubierto number(17,3):=0;
  SdoIniInteres number(17,3):=0;
  IntDeven number(17,3):=0;
  ComGaran number(17,3):=0;
  ComSobInt number(17,3):=0;
  TotalCom number(17,3):=0;
  A_monto number(17,3) :=0;
  B_monto number(17,3) :=0;
  C_monto number(17,3) :=0;
  C_ajustado number(17,3) :=0;
  numeropago number(17):=0;
  factual date;
  flagDebe varchar2(1);
  numCom number;
  flagPago varchar2(1);
  existe number;
  modulo number;
  tipope number;
  v_feini date;
  v_fefin date;
  v_monto number(17,2):=0;
  v_porceGA number(17,2);
  Monto number(17,2):=0;

  Begin
   --  select pgfape into factual from fst017 where pgcod = 1  ;

        modulo := 101;
        tipope := 550;

    if v1_Scmod = modulo and v1_Sctope = tipope then

      Begin
         select 1
           into v1_existe
           from aqpb434
          where aqpb434cod = v1_Pgcod
            and aqpb434mod = v1_Scmod
            and aqpb434mda = v1_Scmda
            and aqpb434pap = v1_Scpap
            and aqpb434cta = v1_Sccta
            and aqpb434ope = v1_Scoper
            and aqpb434sbo <> 0
            and aqpb434top = 550
            and aqpb434tip ='R'
            and aqpb434est='C';
       exception
         when no_data_found then
           v1_existe := 0;
       end;
       if v1_existe = 1 then
         ---Verifiacams si existe en nuestra tabla
          Begin
           select 1
             into existe
             from aqpa551
            where aqpa551cod = v1_Pgcod
              and aqpa551mod = v1_Scmod
             -- and aqpa551suc = v1_Scsuc
              and aqpa551mda = v1_Scmda
              and aqpa551pap = v1_Scpap
              and aqpa551cta = v1_Sccta
              and aqpa551oper = v1_Scoper
             -- and aqpa551sbop = v1_Scsbop sma 17.08.22
              and aqpa551tope = v1_Sctope
              and rownum = 1;
         exception
          when no_data_found then
            existe := 0;
         end;

         if existe = 0 then
             -- datos iniciales
              SP_CR_constantes(T_subasta, -- se debe obtener de otra manera
                               T_BCRP,
                               Com_Fin,
                               T_cliente,
                               T_REPO,
                               T_GARANTIA);


             -- si esta cancelado por la contabilizacion de  tran 98/396
              bEGIN
                select aofval, aofe99 , aoimp
                 into  v_feini, v_fefin, v_monto
                 from fsd010
                where pgcod = v1_Pgcod
                  and aomod = v1_Scmod
               --   and aosuc = v1_Scsuc
                  and aomda = v1_Scmda
                  and aopap = v1_Scpap
                  and aocta = v1_Sccta
                  and aooper = v1_Scoper
               --   and aosbop = v1_Scsbop
                  and aotope = 353
                  and aostat = 99
                  and exists (select 1
                                 from fsd010
                                where pgcod = v1_Pgcod
                                  and aomod = v1_Scmod
                                  and aosuc = v1_Scsuc
                                  and aomda = v1_Scmda
                                  and aopap = v1_Scpap
                                  and aocta = v1_Sccta
                                  and aooper = v1_Scoper
                                  and aosbop <> 0
                                  and aotope = 550
                                  and aostat = 23);
               EXCEPTION
                 when no_data_found then
                  null; ---verificar si colocar monto 0 y fechas null
               END;

               -- porcentaje de Garantía

              Begin
                select tp1nro1/100
                  into v_porceGA
                  from fst198
                 where tp1cod = 1
                   and tp1cod1 = 10884
                   and tp1corr1 = 50
                   and v_monto between tp1imp1 and tp1imp2;
               exception
                 when no_data_found then
                   v_porceGA := 0;
               end;

             --A=Capital coberturado Inicial * Tasa Comisión Garantía
             A_monto := (v_monto * v_PorceGA )* T_GARANTIA  ;
           -- Calculo B
             CapCubierto:=  v_monto *  v_PorceGA;
           -- Dias transcurridos
             -- verificar si tiene que ser la fecha de la aqpb434
             --- v_fefin := factual;
             dias := v_fefin -v_feini;
             dias := dias - 90;
           -- calculo Ajustado
            -- C_ajustado := ((power((1 + T_REPO), (dias/360)))-1)* ln_monto;
              C_ajustado := round(((power((1 + T_REPO), (1/360)))-1)* CapCubierto,2)*dias;
              B_monto := C_ajustado * T_GARANTIA;
           -- Calculo C
              C_monto :=  CapCubierto * T_REPO *(90/360)*T_GARANTIA;

             V1_MtoCom := A_monto + B_monto + C_monto;

          begin
                   insert into aqpa551(aqpa551cod,
                                       aqpa551mod,
                                       aqpa551suc,
                                       aqpa551mda,
                                       aqpa551pap,
                                       aqpa551cta,
                                       aqpa551oper,
                                       aqpa551sbop,
                                       aqpa551tope,
                                       aqpa551nro,
                                       aqpa551fpro,
                                       aqpa551au1,
                                       aqpa551au3,
                                       aqpa551au4,
                                       aqpa551saldo,
                                       aqpa551fecini,
                                       aqpa551fecfin,
                                       aqpa551dias,
                                       aqpa551cubierto,
                                       aqpa551interes,
                                       aqpa551CA1,
                                       aqpa551CA2,
                                       aqpa551CA3,
                                       aqpa551CA4
                                       )
                                values (v1_Pgcod,
                                        v1_Scmod,
                                        v1_Scsuc,
                                        v1_Scmda,
                                        v1_Scpap,
                                        v1_Sccta,
                                        v1_Scoper,
                                        v1_Scsbop,
                                        v1_Sctope,
                                        23,
                                        factual,
                                        000,
                                        'N',
                                        'HONRADO',
                                        v_monto,
                                        v_feini,
                                        factual,
                                        dias,
                                        CapCubierto,
                                        C_ajustado,
                                        A_monto,
                                        B_monto,
                                        C_monto,
                                        V1_MtoCom);
                                       commit;
                   EXCEPTION
                     WHEN DUP_VAL_ON_INDEX THEN
                       NULL;
                   END;
                   flagDebe :='S';
              else
                 Begin
                   select aqpa551ca4 ,trim(aqpa551au3)
                     into Monto, FlagPago
                     from aqpa551
                    where aqpa551cod = v1_Pgcod
                      and aqpa551mod = v1_Scmod
--                      and aqpa551suc = v1_Scsuc
                      and aqpa551mda = v1_Scmda
                      and aqpa551pap = v1_Scpap
                      and aqpa551cta = v1_Sccta
                      and aqpa551oper = v1_Scoper
--                      and aqpa551sbop = v1_Scsbop
                      and aqpa551tope = 550;
                       V1_MtoCom := MONTO;
                       if  flagPago = 'N' then
                           flagDebe := 'S';
                       else
                           flagDebe := 'N';
                       end if;
                 exception
                    when no_data_found then
                       V1_MtoCom:=0;
                       flagDebe := 'N';
                 end;
              end if;

           end if;
    end if;
    v1_DEBE := flagDebe;
  end SP_CR_ComisionHonrado;
  procedure sp_cr_verlogs(ln_pgcod    in number,
                         ln_suc      in number,
                         ln_itmod    in number,
                         ln_ittran   in number,
                         ln_itrel    in number,
                         ln_itord    in number,
                         ln_itsbor   in number,
                         ln_cuenta   in number,
                         ln_monto    in number,
                         Lc_nompro   in varchar2
                         )is
   LC_HORA CHAR(8);    
   ld_proceso date;                  
  begin
    
     select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
     select trunc(sysdate) into ld_proceso from dual;
     begin
        insert into jaqz840
          (jaqz840prgm,
           jaqz840nmbvar,
           jaqz840fecproc,
           jaqz840hora,
           jaqz840user,
           jaqz840varin1,
           jaqz840varin2,
           jaqz840varin3,
           jaqz840varin4,
           jaqz840varin5,
           jaqz840varin6,
           jaqz840varin7,
           jaqz840varout1,
           jaqz840varout2)
        values
          (Lc_nompro,
           'COMREACTIVA',
           ld_proceso,
           lc_hora,
           'PRUEBA',
           ln_pgcod,
           ln_suc,
           ln_itmod,
           ln_ittran,
           ln_itrel,
           ln_itord,
           ln_itsbor,
           ln_CUENTA,
           ln_MONTO
          );
        commit;
      EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
          NULL;
      end;
  end sp_cr_verlogs;   
end PQ_CR_COMISION_REACTIVA ;
/

