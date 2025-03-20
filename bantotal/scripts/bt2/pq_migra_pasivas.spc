create or replace package pq_migra_pasivas is

  -- Author  : MARAUJO
  -- Created : 28/02/2011 09:20:40 a.m.
  -- Purpose : Migra pasivas
  --           lllosa 2011.09.15 05:10 pm Se cmento funcion monto bloqueo en DPF se iguala al saldo cuando es garantia
  --           lllosa 2012.04.04 05:41 pm se mofdifica los importes en bandeja bnj002 CV
  --           lllosa 2012.04.11 01:05 pm se agrego importe para cts convenios
  procedure sp_pasivos_BNJ002_CV(P_C_FECPRO  IN VARCHAR2,
                                 P_C_DIGITO1 IN VARCHAR2,
                                 P_C_DIGITO2 IN VARCHAR2,
                                 ln_ini      in number,
                                 ln_nro      in number                                            
                                 );

  procedure sp_pasivos_BNJ004;

  procedure sp_pasivos_BJD016_CTS(p_d_fecpro date);

  procedure sp_pasivos_BNJ002_DPF(P_C_FECPRO  IN VARCHAR2,
                                 P_C_DIGITO1 IN VARCHAR2,
                                 P_C_DIGITO2 IN VARCHAR2,
                                 ln_ini      in number,
                                 ln_nro      in number                                            
                                 );

  procedure sp_pasivos_BNJ601;

  procedure sp_pasivos_BNJ602;

  procedure sp_pasivos_BJR111;

  procedure sp_pasivos_BJR011;

  procedure sp_pasivos_BJD016_DPF;
  
  procedure sp_pasivos_BNJ012_DPF;
  
  procedure sp_pasivos_BNJ012_CV;

  procedure sp_pasivos_BJCH03;

  procedure sp_pasivos_BNJ003;

  procedure sp_pasivos_BNJ006;

  procedure sp_pasivos_BJD016_AH_2(p_c_ctaini varchar2,
                                   p_c_ctafin varchar2,
                                   p_d_fecmov date
                                   );


  procedure sp_job_movs_ah_1(p_d_fecini date,                                        
                             p_d_fecfin date,
                             p_n_hilos  number
                             );

  procedure sp_pasivos_jaql106;

  procedure sp_pasivos_jaql057(p_d_fecpro date);

  procedure sp_pasivos_jaql060;
                                      
  procedure sp_ah_job_BNJ002(P_C_FECPRO in varchar2,
                             P_C_CODBNJ in varchar2,
                             p_c_error out varchar2);
end pq_migra_pasivas;
/

