create or replace package pq_cr_repr_novacion is
  -- *****************************************************************
  -- Nombre                     : PCK - REPROGRAMACION DE CREDITOS POR NOVACION
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 16.11.2020
  -- Autor de Creación          : CMAC-GCARRANZAS
  -- Uso                        :
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      :
  -- Autor de Modificación      :
  -- Descripción de Modificación:
  --
  --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_verificarcreditovinculado(pd_Pgfape    in date,
                                         pn_instancia in number,
                                         pv_respuesta out varchar2,
                                         pv_credito   out varchar2);

end pq_cr_repr_novacion;
/

create or replace package body pq_cr_repr_novacion is

  procedure sp_verificarcreditovinculado(pd_Pgfape    in date,
                                         pn_instancia in number,
                                         pv_respuesta out varchar2,
                                         pv_credito   out varchar2) IS
  
    LN_CUENTA     NUMBER;
    LN_MONEDA     NUMBER;
    LN_OPERACION  NUMBER;
    LN_INSTANCIA2 NUMBER;
    LN_MONTOM     NUMBER;
    LN_RESPUESTA  NUMBER;
  BEGIN
  
    BEGIN
      SELECT J.JAQY800CTA, J.JAQY800MOD, J.JAQY800OPE, J.JAQY800INS2
        INTO LN_CUENTA, LN_MONEDA, LN_OPERACION, LN_INSTANCIA2
        FROM JAQY800 J
       WHERE J.JAQY800INS = pn_instancia
         AND J.JAQY800VINC = 'S';
    EXCEPTION
      WHEN OTHERS THEN
        pv_respuesta := 'N';
    END;
  
    IF LN_INSTANCIA2 > 0 THEN
      BEGIN
        pq_cr_rep_control.sp_control(vd_pgfape      => pd_Pgfape,
                                     vn_instancia   => pn_instancia,
                                     vn_montominimo => LN_MONTOM,
                                     vn_existe      => LN_RESPUESTA);
      END;
    
      IF LN_RESPUESTA > 0 THEN
        pv_respuesta := 'S';
      
        SELECT --LPAD(TRIM(to_char(LN_CUENTA)), 9, '0') ||
               --LPAD(TRIM(to_char(LN_MONEDA)), 3, '0') ||
               LPAD(TRIM(to_char(LN_OPERACION)), 9, '0')
          into pv_credito
          FROM DUAL;
      ELSE
        pv_respuesta := 'N';
      END IF;
    END IF;
    
    /*pv_respuesta := 'S';
    pv_credito := 'XXXXXXXXXx';*/
  
  END sp_verificarcreditovinculado;
end pq_cr_repr_novacion;
/

