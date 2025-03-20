create or replace package pq_cr_calculo_mora is

  -- Author  : ECOLLADO
  -- Created : 19/08/2022 16:01:38
  -- Purpose :

 procedure pr_cr_calculo_mora(ve_correlativo in number, ve_numerocuota in number, ve_fecha_cuota in date,ve_mora in number,
                              ve_penalidadMora in number,
                              ve_seguro in number,
                              ve_interes_normal in number,
                              ve_interes_compensatorio_vencido in number,
                              ve_itf in number,
                              vs_respuesta out varchar2);
  /*procedure pr_cr_TEST(ve_correlativo in number, ve_numerocuota in number, ve_fecha_cuota in date,ve_1 in number,
                              ve_2 in number,
                              ve_3 in number,
                              ve_4 in number,
                              ve_5 in number,
                              ve_6 in number,
                              ve_7 in number,
                              ve_8 in number,
                              ve_9 in number,
                              ve_10 in number,
                              vs_resp out varchar2);
*/
end pq_cr_calculo_mora;
/

create or replace package body pq_cr_calculo_mora is
  -- *****************************************************************
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2022.08.22
  -- Autor de Creación          : Eduardo Collado Rafael
  -- Uso                        : Procedimiento para el calculo correcta de la Mora
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : ve_correlativo(Correlativo aqpa601codp), ve_numerocuota(Numero de Cuota), ve_fecha_cuota(Fecha de Cuota), ve_mora(Valor de Mora)
  -- Parámetros de Salida       : vs_respuesta ( Respuesta S = 'Actualizo correctamente lso campos aqpb601dmora y aqpb601dtotc en la tabla aqpb601d' o N = 'No actualizo correctamente lso campos aqpb601dmora y aqpb601dtotc en la tabla aqpb601d')
  -- ******************************************************************
  procedure pr_cr_calculo_mora(ve_correlativo                   in number,
                               ve_numerocuota                   in number,
                               ve_fecha_cuota                   in date,
                               ve_mora                          in number,
                               ve_penalidadMora                 in number,
                               ve_seguro                        in number,
                               ve_interes_normal                in number,
                               ve_interes_compensatorio_vencido in number,
                               ve_itf in number,
                               vs_respuesta                     out varchar2) is

    ve_mora_aux                          number;
    ve_penalidadMora_aux                 number;
    ve_seguro_aux                        number;
    ve_interes_normal_aux                number;
    ve_interes_compensatorio_vencido_aux number;

  BEGIN
    BEGIN
      if ve_mora < 0 then
        ve_mora_aux := 0;
      Else
        ve_mora_aux := ve_mora;
      End if;

      if ve_penalidadMora < 0 then
        ve_penalidadMora_aux := 0;
      Else
        ve_penalidadMora_aux := ve_penalidadMora;
      End if;

      if ve_seguro < 0 then
        ve_seguro_aux := 0;
      Else
        ve_seguro_aux := ve_seguro;
      End if;

      if ve_interes_normal < 0 then
        ve_interes_normal_aux := 0;
      Else
        ve_interes_normal_aux := ve_interes_normal;
      End if;

      if ve_interes_compensatorio_vencido < 0 then
        ve_interes_compensatorio_vencido_aux := 0;
      Else
        ve_interes_compensatorio_vencido_aux := ve_interes_compensatorio_vencido;
      End if;
      update aqpb601d
         set aqpb601dmora = ve_mora_aux,
             aqpb601dpena = ve_penalidadMora_aux,
             aqpb601dsegu = ve_seguro_aux,
             aqpb601dic   = ve_interes_normal_aux,
             aqpb601dicv  = ve_interes_compensatorio_vencido_aux,
             aqpb601ditf  = ve_itf,
             aqpb601dtotc =
             (aqpb601dcapi + ve_interes_normal_aux +
             ve_interes_compensatorio_vencido_aux + ve_mora_aux +
             ve_penalidadMora_aux + ve_seguro_aux + aqpb601dotro + ve_itf)
       where aqpb601dcodp = ve_correlativo
         and aqpb601dNCUO = ve_numerocuota
         and aqpb601dfecv = ve_fecha_cuota;
      COMMIT;
      vs_respuesta := 'S';
    EXCEPTION
      WHEN OTHERS THEN
        vs_respuesta := 'N';
        RETURN;
    END;

  end pr_cr_calculo_mora;
  -----------------------------------------------------------------------------------
 /*procedure pr_cr_TEST(ve_correlativo in number, ve_numerocuota in number, ve_fecha_cuota in date,ve_1 in number,
                              ve_2 in number,
                              ve_3 in number,
                              ve_4 in number,
                              ve_5 in number,
                              ve_6 in number,
                              ve_7 in number,
                              ve_8 in number,
                              ve_9 in number,
                              ve_10 in number,
                              vs_resp out varchar2) is
  begin
    insert into aqpc370(aqpc370codp,
  aqpc370ncuo ,
  aqpc370fecv ,
  aqpc370M1 ,
  aqpc370M2 ,
  aqpc370M3 ,
  aqpc370M4 ,
  aqpc370M5 ,
  aqpc370M6 ,
  aqpc370M7 ,
  aqpc370M8, 
  aqpc370M9,
  aqpc370M10)values
  (ve_correlativo,ve_numerocuota, ve_fecha_cuota ,ve_1 ,
                              ve_2,
                              ve_3,
                              ve_4,
                              ve_5,
                              ve_6,
                              ve_7,
                              ve_8,
                              ve_9,
                              ve_10);
  commit;
  end;*/
end pq_cr_calculo_mora;
/

