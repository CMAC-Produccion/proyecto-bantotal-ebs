CREATE OR REPLACE PACKAGE PQ_CR_RELCREDITICIA_RP IS

  -- **************************************************************************************
  -- NOMBRE                      : PQ_CR_RELCREDITICIA_RP
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 2025.07.03
  -- AUTOR DE CREACION           : DCASTRO
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -----------------------------------------------------------------------------------------
  -- FECHA DE MODIFICACION       : 
  --                             : 
  -- **************************************************************************************

  /*==================================================================================================================*/
  PROCEDURE SP_CR_RELCRED_CAMPNAV(pn_pais in number,
                                  pn_tdo in number,
                                  pc_ndo in char,
                                  pd_fecpro in date,
                                  ln_valor out number,
                                  lc_estado out number,
                                  ld_fecha  out date,
                                  lc_existe out char) ;

 
END PQ_CR_RELCREDITICIA_RP;
/
CREATE OR REPLACE PACKAGE BODY PQ_CR_RELCREDITICIA_RP IS

  PROCEDURE SP_CR_RELCRED_CAMPNAV(pn_pais in number,
                                  pn_tdo in number,
                                  pc_ndo in char,
                                  pd_fecpro in date,
                                  ln_valor out number,
                                  lc_estado out number,
                                  ld_fecha  out date,
                                  lc_existe out char) is
  
    -- **************************************************************************************
    -- NOMBRE                      : SP_CR_RELCRED_CAMPNAV
    -- SISTEMA                     : BANTOTAL
    -- MODULO                      : CREDITOS - ACTIVAS
    -- VERSION                     : 1.0
    -- FECHA DE CREACION           : 2025.07.03
    -- AUTOR DE CREACION           : DCASTRO
    -- USO                         : RETORNA DATOS DE TABLA JAQZ740
    -- PARAMETROS                  : pn_pais, pn_tdo, pc_ndo
    -- ESTADO                      : ACTIVO
    -- ACCESO                      : PUBLICO
    -----------------------------------------------------------------------------------------
    -- FECHA DE MODIFICACION       : 
    -- AUTOR DE LA MODIFICACION    : 
    -- DESCRIPCION DE MODIFICACION : 
    --
    -- **************************************************************************************

  BEGIN
      lc_existe := 'N';
      BEGIN
          SELECT j.JAQZ540HIS, j.JAQZ540EST, j.JAQZ540FEC, 'S'
            into ln_valor , lc_estado, ld_fecha , lc_existe 
            from JAQZ540 j
        Where JAQZ540PAI = pn_pais
          and JAQZ540TDO = pn_tdo
          and JAQZ540NDO = pc_ndo
          and JAQZ540FEP = pd_fecpro;
      EXCEPTION
        WHEN OTHERS THEN
          lc_existe := 'N';
          ln_valor  := NULL;
          lc_estado := NULL; 
          ld_fecha  := NULL;
      END;
  
  END SP_CR_RELCRED_CAMPNAV;


END PQ_CR_RELCREDITICIA_RP;
/
