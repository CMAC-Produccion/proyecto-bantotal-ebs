create or replace force view jaql523 as
select D_FECREA,
       C_HORREA,
       N_NUMINS,
       C_CODUSU,
       C_IPCELU,
       C_IMEIEQ,
       C_ESTREG,
       N_LATITU,
       N_LONGIT,
       C_DETREA,
       N_CODMOT,
       N_CODACC,
       N_MOTREA,
       N_MOTNPA,
       D_FECCOM,
       C_TIPREA,
       C_CODERR,
       C_MSGERR
  from wap.wpdreac;

