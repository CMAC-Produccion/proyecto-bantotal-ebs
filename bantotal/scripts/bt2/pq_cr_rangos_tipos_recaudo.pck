create or replace package pq_cr_rangos_tipos_recaudo is

  -- Author  : ENINAH
  -- Created : 25/08/2023 18:26:35
  -- Purpose : Este paquete se encarga de los rangos de tipo de recaudo
  
  procedure sp_cr_insertar_registros(pFechaN in date,
                                     Moneda  in number,
                                     Ubuser0 in varchar2);
  
  procedure sp_cr_insertar_registros_AQPC448D(pFechaN    in date,
                                              Ubuser     in varchar2,
                                              mnt_desde  in number,
                                              mnt_hasta  in number,
                                              prct_dscto in number,
                                              nro_rango  in number);
  
  procedure sp_cr_validar_monto_maximo(aqpc488dcod in number,
                                       --aqpc448dcor in number,
                                       mnt_desde in number,
                                       mnt_hasta in number,
                                       rpt       out varchar2,
                                       --monto_max1 out number,
                                       monto_max2 out number);
  
  procedure sp_cr_calcular_nuevos_montos(cod_tip_recaudo in number,
                                         monto_soles     in number,
                                         monto_dolares   in number,
                                         Cotcbi          in number,
                                         monto_transferido in number,
                                         grup_ven in number,
                                         fecha_pro in date,
                                         usuario in varchar,
                                         montoSolFocma   out number,
                                         montoSolCaja    out number,
                                         montoDolFocma  out number,
                                         montoDolCaja   out number,
                                         porcentaje_caja out number,
                                         ult_rango out number);

end pq_cr_rangos_tipos_recaudo;
/

create or replace package body pq_cr_rangos_tipos_recaudo is

  procedure sp_cr_insertar_registros(pFechaN in date,
                                     Moneda  in number,
                                     Ubuser0 in varchar2) is
    hora varchar2(10);
  begin
    begin
      select SUBSTR(TO_CHAR(sysdate, 'DD-MM-YYYY HH24:MI:SS'), 12, 9)
        into hora
        from dual;
    exception
      when others then
        null;
    end;
  
    begin
      update AQPC448 set aqpc448est = 'I';
      commit;
    exception
      when others then
        null;
    end;
    begin
      insert into aqpc448
        (AQPC448FEC, aqpc448mda, aqpc448usu, aqpc448hor, aqpc448est)
      VALUES
        (pFechaN, Moneda, Ubuser0, hora, 'A');
      commit;
    exception
      when others then
        null;
    end;
  end;

  procedure sp_cr_insertar_registros_AQPC448D(pFechaN    in date,
                                              Ubuser     in varchar2,
                                              mnt_desde  in number,
                                              mnt_hasta  in number,
                                              prct_dscto in number,
                                              nro_rango  in number) is
  
    hora           varchar2(8);
    ln_aqpc448dcor number(4);
  begin
  
    begin
      select SUBSTR(TO_CHAR(sysdate, 'DD-MM-YYYY HH24:MI:SS'), 12, 8)
        into hora
        from dual;
    exception
      when others then
        null;
    end;
  
    begin
      select max(aqpc448dcor) + 1
        into ln_aqpc448dcor
        from aqpc448d
       where aqpc448dcod = nro_rango;
    exception
      when others then
        ln_aqpc448dcor := 1;
    end;
  
    if ln_aqpc448dcor is null then
      ln_aqpc448dcor := 1;
    end if;
  
    begin
      insert into AQPC448D
        (aqpc448dfec,
         aqpc448dusu,
         aqpc448dmtod,
         aqpc448dmtoh,
         aqpc448dpcom,
         aqpc448dcod,
         AQPC448DHOR,
         aqpc448dcor)
      values
        (pFechaN,
         Ubuser,
         mnt_desde,
         mnt_hasta,
         prct_dscto,
         nro_rango,
         hora,
         ln_aqpc448dcor);
      commit;
    exception
      when others then
        null;
    end;
  
  end;

  procedure sp_cr_validar_monto_maximo(aqpc488dcod in number,
                                       --aqpc448dcor in number,
                                       mnt_desde in number,
                                       mnt_hasta in number,
                                       rpt       out varchar2,
                                       --monto_max1 out number,
                                       monto_max2 out number) is
  
    --monto_max number(18, 2);
  
  begin
    --monto_max2 := 0;
    begin
      select max(d.aqpc448dmtoh)
        into monto_max2
        from aqpc448d d
       where d.aqpc448dcod = aqpc488dcod;
    exception
      when others then
        --monto_max1 := 0;
        monto_max2 := 0;
    end;
    if monto_max2 is null then
      monto_max2 := 0;
    End if;
  
    if mnt_desde > monto_max2 then
      rpt := 'S';
    else
      if mnt_desde = 0 then
        rpt := 'S';
      else
        rpt := 'N';
      end if;
    End If;
  
  end;

  procedure sp_cr_calcular_nuevos_montos(cod_tip_recaudo   in number,
                                         monto_soles       in number,
                                         monto_dolares     in number,
                                         Cotcbi            in number,
                                         monto_transferido in number,
                                         grup_ven          in number,
                                         fecha_pro in date,
                                         usuario in varchar,
                                         montoSolFocma     out number,
                                         montoSolCaja      out number,
                                         montoDolFocma     out number,
                                         montoDolCaja      out number,
                                         porcentaje_caja   out number,
                                         ult_rango         out number) is
    monto_min         number(18, 2);
    monto_max         number(18, 2);
    porcentaje_caja_2 number(5, 2);
    porcentaje_focma  number(5, 2);
    monto_de_calculo  number(18, 2);
    --tipo_cambio      number(14, 8);
    --fecha            date;
    monto_total_rs  number(18, 2);
    monto_focma     number(18, 2);
    falta_p         number(18, 2);
    monto_total_rts number(18, 2);
    --monto_cal             number(18, 2); --monto nuevo calculado eninah 03/10/2023
    montoSolFocma_acum  number(18, 2);
    montoSolCaja_acum   number(18, 2);
    montoDolCaja_acum   number(18, 2);
    montoDolFocma_acum  number(18, 2);
    monto_transferido_2 number(18, 2);
    tipo_recau          number(4);
    cor                 number(4);
    hora                varchar2(10);
    fecha               date;
  
  begin
    begin
      monto_total_rs  := monto_soles + (monto_dolares * Cotcbi); -- monto total recaudadito en el mes
      monto_total_rts := monto_soles + (monto_dolares * Cotcbi) +
                         monto_transferido; --monto acumulado total
    end;
    begin
      select pgfape into fecha from fst017 where pgcod = 1;
    exception
      when others then
        fecha := sysdate();
    end;
  
    begin
      select SUBSTR(TO_CHAR(sysdate, 'DD-MM-YYYY HH24:MI:SS'), 12, 8)
        into hora
        from dual;
    exception
      when others then
        hora := '00:00:00';
    end;
  
    begin
      select AQPC424DCOR
        into cor
        from aqpc424
       where AQPC424GUPV = grup_ven
         and rownum = 1
       order by AQPC424FECTRA asc;
    exception
      when others then
        cor := 0;
    end;
    DECLARE
      CURSOR cursor_soles IS
        select *
          from aqpc448d
         where AQPC448DCOD = cod_tip_recaudo
           and aqpc448dcor >= cor
         order by AQPC448DCOR asc;
    begin
    
      montoSolFocma_acum  := 0;
      montoSolCaja_acum   := 0;
      montoDolCaja_acum   := 0;
      montoDolFocma_acum  := 0;
      monto_de_calculo    := 0;
      monto_transferido_2 := monto_transferido;
      FOR V_FILA in cursor_soles LOOP
        monto_min     := V_FILA.AQPC448DMTOD;
        monto_max     := V_FILA.AQPC448DMTOH;
        montoSolFocma := 0;
        montoSolCaja  := 0;
        montoDolCaja  := 0;
        montoDolFocma := 0;
      
        monto_transferido_2 := monto_transferido_2 + monto_de_calculo;
        if monto_transferido_2 < monto_max then
          --eninah 03/10/2023
          if monto_total_rts < monto_max then
            monto_de_calculo := monto_total_rts - monto_transferido_2;
          else
            monto_de_calculo := monto_max - monto_transferido_2;
          end if;
          porcentaje_caja  := V_FILA.AQPC448DPCOM;
          porcentaje_focma := 100 - porcentaje_caja;
        
          --aqui ya calcula los montos correspondientes para focma y caja soles y dolares
          monto_focma := monto_de_calculo * porcentaje_focma / 100;
        
          if (monto_de_calculo >= monto_focma) then
            --if (monto_soles >= monto_focma) then
            montoSolFocma := monto_focma;
            --montoSolCaja  := monto_soles - montoSolFocma;
            montoSolCaja  := monto_de_calculo - montoSolFocma;
            montoDolCaja  := monto_dolares;
            montoDolFocma := 0;
          else
            --montoSolFocma := monto_soles;
            montoSolFocma := monto_de_calculo;
            --calcular cuanto falta para pagar focma
            falta_p       := monto_focma - montoSolFocma;
            montoDolFocma := Round(falta_p / Cotcbi, 2);
            --calcular cuanto te sobra dolares
            --caja         := monto_total_rs - montoSolFocma;
            montoDolCaja := monto_dolares - montoDolFocma; --Round(caja / Cotcbi,2);
            montoSolCaja := 0;
          end if;
          montoSolFocma_acum := montoSolFocma_acum + montoSolFocma;
          montoSolCaja_acum  := montoSolCaja_acum + montoSolCaja;
          montoDolCaja_acum  := montoDolCaja_acum + montoDolCaja;
          montoDolFocma_acum := montoDolFocma_acum + montoDolFocma;
          --Aqui crear un proceso que grabe en mi tabla temporal
          BEGIN
            INSERT INTO AQPC599
              (AQPC599CODREC,
               AQPC599MTRAN,
               AQPC599MACUM,
               AQPC599TRANG,
               AQPC599MCAL,
               AQPC599CMAC,
               AQPC599FOCMA,
               AQPC599CODTRA,
               AQPC599PORC,
               AQPC599CMACD,
               AQPC599FOCMAD,
               AQPC599FEC,
               AQPC599HOR,
               AQPC599FECP,
               AQPC599USER)
            VALUES
              (cod_tip_recaudo,
               monto_transferido_2,
               monto_total_rts,
               monto_max,
               monto_de_calculo,
               montoSolCaja_acum,
               montoSolFocma_acum,
               grup_ven,
               porcentaje_caja,
               montoDolCaja_acum,
               montoDolFocma_acum,
               fecha,
               hora,
               fecha_pro,
               usuario);
            COMMIT;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
          --If monto_total_rts > monto_min and monto_total_rts < monto_max then
          ---montoSolCaja  := monto_soles * porcentaje / 100;
          ---montoSolFocma := monto_soles - montoSolCaja;
          --porcentaje_caja  := V_FILA.AQPC448DPCOM;
          --porcentaje_focma := 100 - porcentaje_caja;
          ult_rango := V_FILA.AQPC448DCOR;
          --exit;
          --continue;
          if monto_max > monto_total_rts then
            exit;
          end if;
        end if;
      
      END LOOP;
    end;
    montoSolFocma := montoSolFocma_acum;
    montoSolCaja  := montoSolCaja_acum;
    montoDolCaja  := montoDolCaja_acum;
    montoDolFocma := montoDolFocma_acum;
  
  end;

end pq_cr_rangos_tipos_recaudo;
/

