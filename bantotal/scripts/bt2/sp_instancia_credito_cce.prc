create or replace procedure sp_instancia_credito_cce(
                                               v_Scmod  in number,
                                               v_Scsuc  in number,
                                               v_Scmda  in number,
                                               v_Scpap  in number,
                                               v_Sccta  in number,
                                               v_Scoper in number,
                                               v_Scsbop in number,
                                               v_Sctope in number,
                                               v_instancia out number
                                             ) is


  -- *****************************************************************
  -- Nombre                     : paquete para obtener cartera de creditos
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     : Cr¿ditos - Activas
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2018.02.07
  -- Autor de Creaci¿n          : DCASTRO
  -- Uso                        : Realiza Calculos
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Entrada      : P_D_FECPRO (FECHA De PROCESO)
  --
  -- Retorno                    :
  -- Fecha de Modificaci¿n      : 2018.02.07
  -- Autor de la Modificaci¿n   : DCASTRO
  -- Descripci¿n de Modificaci¿n: Se invoca a SP_INSTANCIA_CREDITO para obtener instancia, si no existe no busca por sucursal
  --
  -- *****************************************************************


    ln_instancia sng001.sng001inst%type;

  begin

        begin
          sp_instancia_credito(v_scmod => v_scmod,
                               v_scsuc => v_scsuc,
                               v_scmda => v_scmda,
                               v_scpap => v_scpap,
                               v_sccta => v_sccta,
                               v_scoper => v_scoper,
                               v_scsbop => v_scsbop,
                               v_sctope => v_sctope,
                               v_instancia => v_instancia);
        end;

        if nvl(ln_instancia,0) = 0 then

            Begin
              select max(xw2.xwfprcins)
                into ln_instancia
                from  xwf700 xw2
               where xw2.xwfempresa   = 1
                 and xw2.xwfmoneda    = v_Scmda
                 and xw2.xwfpapel     = v_Scpap
                 and xw2.xwfcuenta    = v_Sccta
                 and xw2.xwfoperacion = v_Scoper
                 and rownum = 1;
            exception when no_data_found then
                 ln_instancia := 0;
           end;


       end if;

       v_instancia := nvl(ln_instancia,0);

end sp_instancia_credito_cce;
/

