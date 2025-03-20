CREATE OR REPLACE PROCEDURE SP_AH_REC_RESDIAAPROX(P_FECPRO IN DATE, P_DIAS IN NUMBER, P_MOD IN VARCHAR, P_FAPROX OUT DATE, P_ERRCOD OUT VARCHAR, P_ERRMSG OUT VARCHAR) AS

  ld_pdiahab DATE; -- Primer dia Habil

  BEGIN
    ---*** CALC 1er DIA HABIL LUEGO DE REGISTRO DE RECLAMO
    SP_AH_CALC_DIAHABIL(P_FECPRO, 1, ld_pdiahab);
    --dbms_output.put_line('1er Dia Habil: ' || ld_pdiahab);
    ---***
    ---*** CALC 15 DIAS HABILES (Fecha Resp. Aproximada)
    IF (P_MOD = 'S') THEN
      -- ES TIPO SEGUROS -- DIAS CALENDARIO (DESDE 1er DIA HABIL)
      P_FAPROX := ld_pdiahab + (P_DIAS - 1);
      --dbms_output.put_line('Tipo Seguro, Dias Calendario ...');
    ELSE
      -- NO TIPO SEGUROS -- DIAS HABILES (DESDE 1er DIA HABIL)
      SP_AH_CALC_DIAHABIL(ld_pdiahab, P_DIAS - 1, P_FAPROX);
      --dbms_output.put_line('Tipo Normal, Dias Habiles ...');
    END IF;
    --dbms_output.put_line('Fecha Resp APROX: ' || P_FAPROX);

    EXCEPTION
      when others then
        P_ERRCOD := '030';
        P_ERRMSG := sqlcode||'->'||sqlerrm;
  END SP_AH_REC_RESDIAAPROX;
/

