CREATE OR REPLACE PACKAGE pq_migra_Activas IS
  --                      :lllosa 2012.04.09 Se agrego historico de creditos
  --                      :lllosa 2012.04.11 se agrego relacion de garatias
  procedure sp_plan_pagos_BNJ002 (p_n_ctabtti in number, p_n_ctabttf in number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  FUNCTION FN_NUM_CUOCAN (P_C_NUMCRE IN varchar2 ) RETURN NUMBER;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
   procedure sp_cr_batch_bnj002 (p_c_error out varchar2);
   procedure SP_Fch_Valor_pripag (P_C_NUMCRE IN varchar2 , P_D_FECDES IN DATE,P_C_CODPAC IN VARCHAR, p_d_fecval out date, p_d_pripag out date);
end pq_migra_Activas;
/

