create or replace package PQ_CR_CUPONES is
    -- *****************************************************************
    -- Nombre                     : paquete para CUPONES
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.09.02
    -- Autor de Creación          : DCASTRO
    -- Uso                        : Realiza Calculos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_D_FECPRO (FECHA De PROCESO)
    --                              
    -- Retorno                    : 
    -- Fecha de Modificación      : 2013.10.15
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    --                              
    --
    -- *****************************************************************


---------------------------------------------------------------------------------------------
procedure SP_CR_INSERT_JAQL406(
                                  P_JAQL406Pgc in JAQL406.JAQL406PGC%TYPE,
                                  P_JAQL406Mod in JAQL406.JAQL406MOD%TYPE,
                                  P_JAQL406Suc in JAQL406.JAQL406SUC%TYPE,
                                  P_JAQL406Mda in JAQL406.JAQL406MDA%TYPE,
                                  P_JAQL406Pap in JAQL406.JAQL406PAP%TYPE,
                                  P_JAQL406Cta in JAQL406.JAQL406CTA%TYPE,
                                  P_JAQL406Ope in JAQL406.JAQL406OPE%TYPE,
                                  P_JAQL406Sbo in JAQL406.JAQL406SBO%TYPE,
                                  P_JAQL406Top in JAQL406.JAQL406TOP%TYPE,
                                  P_JAQL406Cre in JAQL406.JAQL406CRE%TYPE,
                                  P_JAQL406Fec in JAQL406.JAQL406FEC%TYPE,
                                  P_JAQL406Fop in JAQL406.JAQL406FOP%TYPE,
                                  P_JAQL406Est in JAQL406.JAQL406EST%TYPE,
                                  P_JAQL406Usr in JAQL406.JAQL406USR%TYPE,
                                  P_JAQL406Age in JAQL406.JAQL406AGE%TYPE,
                                  P_JAQL406Dpt in JAQL406.JAQL406DPT%TYPE,
                                  P_JAQL406Ant in JAQL406.JAQL406ANT%TYPE,
                                  P_JAQL406Atr in JAQL406.JAQL406ATR%TYPE,
                                  P_JAQL406Cal in JAQL406.JAQL406CAL%TYPE,
                                  P_JAQL406Tip in JAQL406.JAQL406TIP%TYPE,
                                  P_JAQL406EXCUP  in JAQL406.JAQL406EXCUP%TYPE,
                                  P_JAQL406TSBOR  in JAQL406.JAQL406TSBOR%TYPE,
                                  P_JAQL406TORD   in JAQL406.JAQL406TORD%TYPE,
                                  P_JAQL406TNREL  in JAQL406.JAQL406TNREL%TYPE,
                                  P_JAQL406TTRAN  in JAQL406.JAQL406TTRAN%TYPE,
                                  P_JAQL406TMOD   in JAQL406.JAQL406TMOD%TYPE,
                                  P_JAQL406TSUC   in JAQL406.JAQL406TSUC%TYPE,
                                  P_JAQL406FCTA   in JAQL406.JAQL406FCTA%TYPE,      
                                  P_JAQL406NUMP   in JAQL406.JAQL406NUMP%TYPE, --numero de cuota a pagar
                                  P_JAQL406CUPNUM in JAQL406.JAQL406CUPNUM%TYPE,
                                  P_JAQL406OPC    in JAQL406.JAQL406OPC%TYPE
                                 
                         ) ;   
---------------------------------------------------------------------------------------------
procedure SP_CR_REGULARIZAR_JAQL406(      
                                  P_JAQL406Pgc in JAQL406.JAQL406PGC%TYPE,
                                  P_JAQL406Mod in JAQL406.JAQL406MOD%TYPE,
                                  P_JAQL406Suc in JAQL406.JAQL406SUC%TYPE,
                                  P_JAQL406Mda in JAQL406.JAQL406MDA%TYPE,
                                  P_JAQL406Pap in JAQL406.JAQL406PAP%TYPE,
                                  P_JAQL406Cta in JAQL406.JAQL406CTA%TYPE,
                                  P_JAQL406Ope in JAQL406.JAQL406OPE%TYPE,
                                  P_JAQL406Sbo in JAQL406.JAQL406SBO%TYPE,
                                  P_JAQL406Top in JAQL406.JAQL406TOP%TYPE,
                                  P_JAQL406Cre in JAQL406.JAQL406CRE%TYPE,
                                  P_JAQL406Fec in JAQL406.JAQL406FEC%TYPE,
                                  P_JAQL406Fop in JAQL406.JAQL406FOP%TYPE,
                                  P_JAQL406Est in JAQL406.JAQL406EST%TYPE,
                                  P_JAQL406Usr in JAQL406.JAQL406USR%TYPE,
                                  P_JAQL406Age in JAQL406.JAQL406AGE%TYPE,
                                  P_JAQL406Dpt in JAQL406.JAQL406DPT%TYPE,
                                  P_JAQL406Ant in JAQL406.JAQL406ANT%TYPE,
                                  P_JAQL406Atr in JAQL406.JAQL406ATR%TYPE,
                                  P_JAQL406Cal in JAQL406.JAQL406CAL%TYPE,
                                  P_JAQL406Tip in JAQL406.JAQL406TIP%TYPE,
                                  P_JAQL406EXCUP  in JAQL406.JAQL406EXCUP%TYPE,
                                  P_JAQL406TSBOR  in JAQL406.JAQL406TSBOR%TYPE,
                                  P_JAQL406TORD   in JAQL406.JAQL406TORD%TYPE,
                                  P_JAQL406TNREL  in JAQL406.JAQL406TNREL%TYPE,
                                  P_JAQL406TTRAN  in JAQL406.JAQL406TTRAN%TYPE,
                                  P_JAQL406TMOD   in JAQL406.JAQL406TMOD%TYPE,
                                  P_JAQL406TSUC   in JAQL406.JAQL406TSUC%TYPE,
                                  P_JAQL406FCTA   in JAQL406.JAQL406FCTA%TYPE,      
                                  P_JAQL406NUMP   in JAQL406.JAQL406NUMP%TYPE, --numero de cuota a pagar
                                  P_JAQL406CUPNUM in JAQL406.JAQL406CUPNUM%TYPE,
                                  P_JAQL406OPC    in JAQL406.JAQL406OPC%TYPE
                                 
                         ) ;                
---------------------------------------------------------------------------------------------

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                             
procedure SP_CR_BUSCA_JAQL406(
                                  P_JAQL406Pgc in JAQL406.JAQL406PGC%TYPE,
                                  P_JAQL406Mod in JAQL406.JAQL406MOD%TYPE,
                                  P_JAQL406Suc in JAQL406.JAQL406SUC%TYPE,
                                  P_JAQL406Mda in JAQL406.JAQL406MDA%TYPE,
                                  P_JAQL406Pap in JAQL406.JAQL406PAP%TYPE,
                                  P_JAQL406Cta in JAQL406.JAQL406CTA%TYPE,
                                  P_JAQL406Ope in JAQL406.JAQL406OPE%TYPE,
                                  P_JAQL406Sbo in JAQL406.JAQL406SBO%TYPE,
                                  P_JAQL406Top in JAQL406.JAQL406TOP%TYPE,
                                  P_C_IND out varchar2
                                  );
      
end PQ_CR_CUPONES;
/

create or replace package body PQ_CR_CUPONES is
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

---------------------------------------------------------------------------------------------
procedure SP_CR_INSERT_JAQL406(
                                  P_JAQL406Pgc in JAQL406.JAQL406PGC%TYPE,
                                  P_JAQL406Mod in JAQL406.JAQL406MOD%TYPE,
                                  P_JAQL406Suc in JAQL406.JAQL406SUC%TYPE,
                                  P_JAQL406Mda in JAQL406.JAQL406MDA%TYPE,
                                  P_JAQL406Pap in JAQL406.JAQL406PAP%TYPE,
                                  P_JAQL406Cta in JAQL406.JAQL406CTA%TYPE,
                                  P_JAQL406Ope in JAQL406.JAQL406OPE%TYPE,
                                  P_JAQL406Sbo in JAQL406.JAQL406SBO%TYPE,
                                  P_JAQL406Top in JAQL406.JAQL406TOP%TYPE,
                                  P_JAQL406Cre in JAQL406.JAQL406CRE%TYPE,
                                  P_JAQL406Fec in JAQL406.JAQL406FEC%TYPE,
                                  P_JAQL406Fop in JAQL406.JAQL406FOP%TYPE,
                                  P_JAQL406Est in JAQL406.JAQL406EST%TYPE,
                                  P_JAQL406Usr in JAQL406.JAQL406USR%TYPE,
                                  P_JAQL406Age in JAQL406.JAQL406AGE%TYPE,
                                  P_JAQL406Dpt in JAQL406.JAQL406DPT%TYPE,
                                  P_JAQL406Ant in JAQL406.JAQL406ANT%TYPE,
                                  P_JAQL406Atr in JAQL406.JAQL406ATR%TYPE,
                                  P_JAQL406Cal in JAQL406.JAQL406CAL%TYPE,
                                  P_JAQL406Tip in JAQL406.JAQL406TIP%TYPE,
                                  P_JAQL406EXCUP  in JAQL406.JAQL406EXCUP%TYPE,
                                  P_JAQL406TSBOR  in JAQL406.JAQL406TSBOR%TYPE,
                                  P_JAQL406TORD   in JAQL406.JAQL406TORD%TYPE,
                                  P_JAQL406TNREL  in JAQL406.JAQL406TNREL%TYPE,
                                  P_JAQL406TTRAN  in JAQL406.JAQL406TTRAN%TYPE,
                                  P_JAQL406TMOD   in JAQL406.JAQL406TMOD%TYPE,
                                  P_JAQL406TSUC   in JAQL406.JAQL406TSUC%TYPE,
                                  P_JAQL406FCTA   in JAQL406.JAQL406FCTA%TYPE,      
                                  P_JAQL406NUMP   in JAQL406.JAQL406NUMP%TYPE, --numero de cuota a pagar
                                  P_JAQL406CUPNUM in JAQL406.JAQL406CUPNUM%TYPE,
                                  P_JAQL406OPC    in JAQL406.JAQL406OPC%TYPE
                                 
                         ) is
   -- *****************************************************************
    -- Nombre                     : SP_CR_INSERT_JAQL406
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : MSOLARI
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --                              
    -- Retorno                    : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************                              
    lc_error char(1);
    lc_hora char(8);
  begin
                                              
      insert into jaql406
      (
          JAQL406Cup,
          JAQL406Pgc,
          JAQL406Mod,
          JAQL406Suc,
          JAQL406Mda,
          JAQL406Pap,
          JAQL406Cta,
          JAQL406Ope,
          JAQL406Sbo,
          JAQL406Top,
          JAQL406Cre,
          JAQL406Fec,
          JAQL406Fop,
          JAQL406Est,
          JAQL406Usr,
          JAQL406Age,
          JAQL406Dpt,
          JAQL406Ant,
          JAQL406Atr,
          JAQL406Cal,
          JAQL406Tip,
          JAQL406EXCUP,
          JAQL406TSBOR,
          JAQL406TORD,
          JAQL406TNREL,
          JAQL406TTRAN,
          JAQL406TMOD,
          JAQL406TSUC,
          JAQL406FCTA,
          JAQL406NUMP,
          JAQL406CUPNUM,
          JAQL406OPC
      )
      values
      (
          SQ_CR_JAQL406_2.NEXTVAL,
          P_JAQL406Pgc,
          P_JAQL406Mod,
          P_JAQL406Suc,
          P_JAQL406Mda,
          P_JAQL406Pap,
          P_JAQL406Cta,
          P_JAQL406Ope,
          P_JAQL406Sbo,
          P_JAQL406Top,
          P_JAQL406Cre,
          P_JAQL406Fec,
          P_JAQL406Fop,
        --  null,
          P_JAQL406Est,
          P_JAQL406Usr,
          P_JAQL406Age,
          P_JAQL406Dpt,
          P_JAQL406Ant,
          P_JAQL406Atr,
          P_JAQL406Cal,
          P_JAQL406Tip,
          P_JAQL406EXCUP,
          P_JAQL406TSBOR,
          P_JAQL406TORD,
          P_JAQL406TNREL,
          P_JAQL406TTRAN,
          P_JAQL406TMOD,
          P_JAQL406TSUC,
          P_JAQL406FCTA,
          P_JAQL406NUMP,
          P_JAQL406CUPNUM,
          P_JAQL406OPC
      );
      ------------------***** 05102015 ****----------------------------
      exception when others  then     
         select to_char(sysdate,'hh24:mi:ss') 
         into lc_hora
         from dual;   
                 
         begin
             -- lc_ob := 'Capital,interes,mora y saldo en cero';
             lc_error := 'S';
              insert into JAQY773 --->>>Tabla auxiliar
                (--JAQY773Cup,
                  JAQY773cod,
                  JAQY773Mod,
                  JAQY773Suc,
                  JAQY773Mda,
                  JAQY773Pap,
                  JAQY773Cta,
                  JAQY773Ope,
                  JAQY773Sbo,
                  JAQY773Top,
                  JAQY773Cre,
                  JAQY773Fec,
                  JAQY773Fop,
                  JAQY773Est,
                  JAQY773Usr,
                  JAQY773Age,
                  JAQY773Dpt,
                  JAQY773Ant,
                  JAQY773Atr,
                  JAQY773Cal,
                  JAQY773Tip,
                  JAQY773EXCUP,
                  JAQY773TSBOR,
                  JAQY773TORD,
                  JAQY773TNREL,
                  JAQY773TTRAN,
                  JAQY773TMOD,
                  JAQY773TSUC,
                  JAQY773FCTA,
                  JAQY773NUMP,
                  JAQY773CUPNUM,
                  JAQY773OPC,
                  JAQY773HORA,
                  JAQY773ERROR
              )
              values
              (
                  SQ_AH_JAQY773.NEXTVAL,
                    P_JAQL406Mod,
                    P_JAQL406Suc,
                    P_JAQL406Mda,
                    P_JAQL406Pap,
                    P_JAQL406Cta,
                    P_JAQL406Ope,
                    P_JAQL406Sbo,
                    P_JAQL406Top,
                    P_JAQL406Cre,
                    P_JAQL406Fec,
                    P_JAQL406Fop,
                  --  null,
                    P_JAQL406Est,
                    P_JAQL406Usr,
                    P_JAQL406Age,
                    P_JAQL406Dpt,
                    P_JAQL406Ant,
                    P_JAQL406Atr,
                    P_JAQL406Cal,
                    P_JAQL406Tip,
                    P_JAQL406EXCUP,
                    P_JAQL406TSBOR,
                    P_JAQL406TORD,
                    P_JAQL406TNREL,
                    P_JAQL406TTRAN,
                    P_JAQL406TMOD,
                    P_JAQL406TSUC,
                    P_JAQL406FCTA,
                    P_JAQL406NUMP,
                    P_JAQL406CUPNUM,
                    P_JAQL406OPC,
                    lc_hora,
                    lc_error);
                 exception when others  then dbms_output.put_line(sqlerrm);
                 commit;
              end;
       ------------------------------------------------------------------------
      commit;
      
  end SP_CR_INSERT_JAQL406;
---------------------------------------------------------------------------------------------
procedure SP_CR_REGULARIZAR_JAQL406( 
                                  P_JAQL406Pgc in JAQL406.JAQL406PGC%TYPE,
                                  P_JAQL406Mod in JAQL406.JAQL406MOD%TYPE,
                                  P_JAQL406Suc in JAQL406.JAQL406SUC%TYPE,
                                  P_JAQL406Mda in JAQL406.JAQL406MDA%TYPE,
                                  P_JAQL406Pap in JAQL406.JAQL406PAP%TYPE,
                                  P_JAQL406Cta in JAQL406.JAQL406CTA%TYPE,
                                  P_JAQL406Ope in JAQL406.JAQL406OPE%TYPE,
                                  P_JAQL406Sbo in JAQL406.JAQL406SBO%TYPE,
                                  P_JAQL406Top in JAQL406.JAQL406TOP%TYPE,
                                  P_JAQL406Cre in JAQL406.JAQL406CRE%TYPE,
                                  P_JAQL406Fec in JAQL406.JAQL406FEC%TYPE,
                                  P_JAQL406Fop in JAQL406.JAQL406FOP%TYPE,
                                  P_JAQL406Est in JAQL406.JAQL406EST%TYPE,
                                  P_JAQL406Usr in JAQL406.JAQL406USR%TYPE,
                                  P_JAQL406Age in JAQL406.JAQL406AGE%TYPE,
                                  P_JAQL406Dpt in JAQL406.JAQL406DPT%TYPE,
                                  P_JAQL406Ant in JAQL406.JAQL406ANT%TYPE,
                                  P_JAQL406Atr in JAQL406.JAQL406ATR%TYPE,
                                  P_JAQL406Cal in JAQL406.JAQL406CAL%TYPE,
                                  P_JAQL406Tip in JAQL406.JAQL406TIP%TYPE,
                                  P_JAQL406EXCUP  in JAQL406.JAQL406EXCUP%TYPE,
                                  P_JAQL406TSBOR  in JAQL406.JAQL406TSBOR%TYPE,
                                  P_JAQL406TORD   in JAQL406.JAQL406TORD%TYPE,
                                  P_JAQL406TNREL  in JAQL406.JAQL406TNREL%TYPE,
                                  P_JAQL406TTRAN  in JAQL406.JAQL406TTRAN%TYPE,
                                  P_JAQL406TMOD   in JAQL406.JAQL406TMOD%TYPE,
                                  P_JAQL406TSUC   in JAQL406.JAQL406TSUC%TYPE,
                                  P_JAQL406FCTA   in JAQL406.JAQL406FCTA%TYPE,      
                                  P_JAQL406NUMP   in JAQL406.JAQL406NUMP%TYPE, --numero de cuota a pagar
                                  P_JAQL406CUPNUM in JAQL406.JAQL406CUPNUM%TYPE,
                                  P_JAQL406OPC    in JAQL406.JAQL406OPC%TYPE
                                 
                         ) is
   -- *****************************************************************
    -- Nombre                     : SP_CR_REGULARIZAR_JAQL406
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : MSOLARI
    -- Uso                        : Regularizacion de cupones del 05/01/2015 al 04/03/2015
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --                              
    -- Retorno                    : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************                             
  begin
                                   
                                                
      insert into jaql406
      (
          JAQL406Cup,
          JAQL406Pgc,
          JAQL406Mod,
          JAQL406Suc,
          JAQL406Mda,
          JAQL406Pap,
          JAQL406Cta,
          JAQL406Ope,
          JAQL406Sbo,
          JAQL406Top,
          JAQL406Cre,
          JAQL406Fec,
          JAQL406Fop,
          JAQL406Est,
          JAQL406Usr,
          JAQL406Age,
          JAQL406Dpt,
          JAQL406Ant,
          JAQL406Atr,
          JAQL406Cal,
          JAQL406Tip,
          JAQL406EXCUP,
          JAQL406TSBOR,
          JAQL406TORD,
          JAQL406TNREL,
          JAQL406TTRAN,
          JAQL406TMOD,
          JAQL406TSUC,
          JAQL406FCTA,
          JAQL406NUMP,
          JAQL406CUPNUM,
          JAQL406OPC

      )
      values
      (
          SQ_CR_JAQL406_1.NEXTVAL,
          P_JAQL406Pgc,
          P_JAQL406Mod,
          P_JAQL406Suc,
          P_JAQL406Mda,
          P_JAQL406Pap,
          P_JAQL406Cta,
          P_JAQL406Ope,
          P_JAQL406Sbo,
          P_JAQL406Top,
          P_JAQL406Cre,
          P_JAQL406Fec,
          P_JAQL406Fop,
        --  null,
          P_JAQL406Est,
          P_JAQL406Usr,
          P_JAQL406Age,
          P_JAQL406Dpt,
          P_JAQL406Ant,
          P_JAQL406Atr,
          P_JAQL406Cal,
          P_JAQL406Tip,
          P_JAQL406EXCUP,
          P_JAQL406TSBOR,
          P_JAQL406TORD,
          P_JAQL406TNREL,
          P_JAQL406TTRAN,
          P_JAQL406TMOD,
          P_JAQL406TSUC,
          P_JAQL406FCTA,
          P_JAQL406NUMP,
          P_JAQL406CUPNUM,
          P_JAQL406OPC
      );

      commit;

  end SP_CR_REGULARIZAR_JAQL406; 
---------------------------------------------------------------------------------------------

/* procedure SP_CR_INSERT_JAQY754(
                                  P_JAQY754Pg  in JAQY754.JAQY754PG%TYPE,
                                  P_JAQY754Mod in JAQY754.JAQY754MOD%TYPE,
                                  P_JAQY754Suc in JAQY754.JAQY754SUC%TYPE,
                                  P_JAQY754Mda in JAQY754.JAQY754MDA%TYPE,
                                  P_JAQY754Pap in JAQY754.JAQY754PAP%TYPE,
                                  P_JAQY754Cta in JAQY754.JAQY754CTA%TYPE,
                                  P_JAQY754Ope in JAQY754.JAQY754OPE%TYPE,
                                  P_JAQY754Sbo in JAQY754.JAQY754SBO%TYPE,
                                  P_JAQY754Top in JAQY754.JAQY754TOP%TYPE,
                                  P_JAQY754Cre in JAQY754.JAQY754CRE%TYPE,
                                  P_JAQY754Fec in JAQY754.JAQY754FEC%TYPE,--
                                  P_JAQY754Fop in JAQY754.JAQY754FOP%TYPE,--
                                  P_JAQY754Estd in JAQY754.JAQY754ESTd%TYPE,
                                  P_JAQY754Usr in JAQY754.JAQY754USR%TYPE,
                                  P_JAQY754Age in JAQY754.JAQY754AGE%TYPE,
                                  P_JAQY754Dpt in JAQY754.JAQY754DPT%TYPE,
                                  P_JAQY754Ant in JAQY754.JAQY754ANT%TYPE,
                                  P_JAQY754Atr in JAQY754.JAQY754ATR%TYPE,
                                  P_JAQY754Cal in JAQY754.JAQY754CAL%TYPE,
                                  P_JAQY754Tip in JAQY754.JAQY754TIP%TYPE,
                                  P_JAQY754Tsuc   in JAQY754.JAQY754TSUC%TYPE,-- 
                                  P_JAQY754Tmod   in JAQY754.JAQY754TMOD%TYPE,
                                  P_JAQY754Ttran  in JAQY754.JAQY754TTRAN%TYPE,
                                  P_JAQY754tnrel  in JAQY754.JAQY754TNREL%TYPE,
                                  P_JAQY754Tord   in JAQY754.JAQY754TORD%TYPE,
                                  P_JAQY754Tsbord in JAQY754.JAQY754TSBORD%TYPE,--
                                  P_JAQY754Nump   in JAQY754.JAQY754NUMP%TYPE,
                                  P_JAQY754Exto   in JAQY754.JAQY754EXTO%TYPE, 
                                  P_JAQY754Foper  in JAQY754.JAQY754FOPER%TYPE,
                                  P_JAQY754Numcup in JAQY754.JAQY754NUMCUP%TYPE, --
                                  P_JAQY754OPC    in JAQY754.JAQY754OPC%TYPE
                                                                   
                                         
                         ) is
   -- *****************************************************************
    -- Nombre                     : SP_CR_INSERT_JAQY754
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : MSOLARI
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --                              
    -- Retorno                    : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************
 
  begin
  
   
      delete from JAQL406 where JAQL406Pgc    = P_JAQY754Pg 
                            and JAQL406Mod    = P_JAQY754Mod 
                            and JAQL406Suc    = P_JAQY754Suc 
                            and JAQL406Mda    = P_JAQY754Mda 
                            and JAQL406Pap    = P_JAQY754Pap  
                            and JAQL406Cta    = P_JAQY754Cta 
                            and JAQL406Ope    = P_JAQY754Ope 
                            and JAQL406Sbo    = P_JAQY754Sbo 
                            and JAQL406Top    = P_JAQY754Top 
                            and JAQL406Cre    = P_JAQY754Cre 
                            and JAQL406Fec    = P_JAQY754Fec 
                            and JAQL406Fop    = P_JAQY754FOP
                            and JAQL406Est    = P_JAQY754Estd 
                            and JAQL406Usr    = P_JAQY754Usr 
                            and JAQL406Age    = P_JAQY754Age 
                            and JAQL406Dpt    = P_JAQY754Dpt 
                            and JAQL406Ant    = P_JAQY754Ant 
                            and JAQL406Atr    = P_JAQY754Atr 
                            and JAQL406Cal    = P_JAQY754Cal 
                            and JAQL406Tip    = P_JAQY754Tip 
                            and JAQL406TSUC   = P_JAQY754TSUC  --1
                            and JAQL406TMOD   = P_JAQY754TMOD --2
                            and JAQL406TTRAN  = P_JAQY754TTRAN  --3
                            and JAQL406TNREL  = P_JAQY754TNREL --4
                            and JAQL406TORD   = P_JAQY754TORD --5
                            and JAQL406TSBOR  = P_JAQY754TSBORD -- 6
                            and JAQL406NUMP   = P_JAQY754NUMP --7
                            and JAQL406EXCUP  = P_JAQY754EXTO --8
                            and JAQL406FCTA   = P_JAQY754FOPER --9
                            and JAQL406CUPNUM = P_JAQY754NUMCUP
                            and JAQL406OPC    = P_JAQY754OPC

                            ;   
     /* delete from JAQL406 where JAQL406Pgc    = P_JAQY754Pg 
                            and JAQL406Mod    = P_JAQY754Mod 
                            and JAQL406Suc    = P_JAQY754Suc 
                            and JAQL406Mda    = P_JAQY754Mda 
                            and JAQL406Pap    = P_JAQY754Pap  
                            and JAQL406Cta    = P_JAQY754Cta 
                            and JAQL406Ope    = P_JAQY754Ope 
                            and JAQL406Sbo    = P_JAQY754Sbo 
                            and JAQL406Top    = P_JAQY754Top 
                            and JAQL406Cre    = P_JAQY754Cre 
                            and JAQL406Fec    = P_JAQY754Fec 
                            and JAQL406Fop    = P_JAQY754FOP
                            and JAQL406Est    = P_JAQY754Estd 
                            and JAQL406Usr    = P_JAQY754Usr 
                            and JAQL406Age    = P_JAQY754Age 
                            and JAQL406Dpt    = P_JAQY754Dpt 
                            and JAQL406Ant    = P_JAQY754Ant 
                            and JAQL406Atr    = P_JAQY754Atr 
                            and JAQL406Cal    = P_JAQY754Cal 
                            and JAQL406Tip    = P_JAQY754Tip 
                            and JAQL406TSUC   = P_JAQY754TSUC
                            and JAQL406TMOD   = P_JAQY754TMOD
                            and JAQL406TTRAN  = P_JAQY754TTRAN
                            and JAQL406TNREL  = P_JAQY754TNREL
                            and JAQL406TORD   = P_JAQY754TORD
                            and JAQL406TSBOR  = P_JAQY754TSBORD
                            and JAQL406NUMP   = P_JAQY754NUMP
                            and JAQL406EXCUP  = P_JAQY754EXTO
                            and JAQL406FCTA   = P_JAQY754FOPER
                            and JAQL406CUPNUM = P_JAQY754NUMCUP

                            ;*/
 
    /*  insert into jaqy754
      (
          JAQY754Cupon,
          JAQY754Pg,
          JAQY754Mod,
          JAQY754Suc,
          JAQY754Mda,
          JAQY754Pap,
          JAQY754Cta,
          JAQY754Ope,
          JAQY754Sbo,
          JAQY754Top,
          JAQY754Cre,
          JAQY754Fec,
          JAQY754Fop,
          JAQY754Estd,
          JAQY754Usr,
          JAQY754Age,
          JAQY754Dpt,
          JAQY754Ant,
          JAQY754Atr,
          JAQY754Cal,
          JAQY754Tip,
          JAQY754Tsuc,
          JAQY754Tmod,
          JAQY754Ttran,
          JAQY754tnrel,
          JAQY754Tord,
          JAQY754Tsbord,
          JAQY754Nump,--
          JAQY754Exto, --no valee
          JAQY754Foper,
          JAQY754Numcup,
          JAQY754OPC
      )
      values
      (
          SQ_AH_JAQY754.NEXTVAL,
          P_JAQY754Pg,
          P_JAQY754Mod,
          P_JAQY754Suc,
          P_JAQY754Mda,
          P_JAQY754Pap,
          P_JAQY754Cta,
          P_JAQY754Ope,
          P_JAQY754Sbo,
          P_JAQY754Top,
          P_JAQY754Cre,
          P_JAQY754Fec,
          P_JAQY754Fop,
          P_JAQY754Estd,
          P_JAQY754Usr,
          P_JAQY754Age,
          P_JAQY754Dpt,
          P_JAQY754Ant,
          P_JAQY754Atr,
          P_JAQY754Cal,
          P_JAQY754Tip,
          P_JAQY754Tsuc,
          P_JAQY754Tmod,
          P_JAQY754Ttran,
          P_JAQY754tnrel,
          P_JAQY754Tord,
          P_JAQY754Tsbord,
          P_JAQY754Nump,
          P_JAQY754Exto,-- no vale
          P_JAQY754Foper,
          P_JAQY754Numcup,
          P_JAQY754OPC
      );

      commit;



  end SP_CR_INSERT_JAQY754;

*/
----------------------------------------------------------------------------------------
procedure SP_CR_BUSCA_JAQL406(
                                  P_JAQL406Pgc in JAQL406.JAQL406PGC%TYPE,
                                  P_JAQL406Mod in JAQL406.JAQL406MOD%TYPE,
                                  P_JAQL406Suc in JAQL406.JAQL406SUC%TYPE,
                                  P_JAQL406Mda in JAQL406.JAQL406MDA%TYPE,
                                  P_JAQL406Pap in JAQL406.JAQL406PAP%TYPE,
                                  P_JAQL406Cta in JAQL406.JAQL406CTA%TYPE,
                                  P_JAQL406Ope in JAQL406.JAQL406OPE%TYPE,
                                  P_JAQL406Sbo in JAQL406.JAQL406SBO%TYPE,
                                  P_JAQL406Top in JAQL406.JAQL406TOP%TYPE,
                                  P_C_IND out varchar2
                         ) is
   -- *****************************************************************
    -- Nombre                     : SP_CR_BUSCA_JAQL406
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : MSOLARI
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --                              
    -- Retorno                    : 
    -- Fecha de Modificación      : 02/11/2016
    -- Autor de la Modificación   : mpostigoc  
    -- Descripción de Modificación: Acondicionamiento Campaña Navidad 2016
    --
    -- *****************************************************************
  ln_num number;
  ln_cupones number;
  
  begin
  
  
  begin
    select tp1nro3
      into ln_num
      from fst198 
      where Tp1cod = 1
        and Tp1cod1 = 10871
        and tp1corr1= 7
        and tp1corr2 = 6;
        
  exception when no_data_found then
       ln_num := 0;           
  end;

  
   begin
      select count(*) 
       into ln_cupones      
       from jaql406          
      where JAQL406PGC = P_JAQL406Pgc
        and JAQL406MOD = P_JAQL406Mod
        and JAQL406SUC = P_JAQL406Suc
        and JAQL406MDA = P_JAQL406Mda
        and JAQL406PAP = P_JAQL406Pap
        and JAQL406CTA = P_JAQL406Cta
        and JAQL406OPE = P_JAQL406Ope
        and JAQL406SBO = P_JAQL406Sbo
        and JAQL406TOP = P_JAQL406Top
        and JAQL406EXCUP = 'C';
        
   exception when no_Data_found then
        ln_cupones := 0  ;        
   end;
      
   if ln_cupones < ln_num then
      P_C_IND :=  'S'; --otorgar cupones
   else
      P_C_IND :=  'N'; --NO otorgar cupones excedio el limite
   end if;          


  end SP_CR_BUSCA_JAQL406;

----------------------------------------------------------------------------------------

end PQ_CR_CUPONES;
/

