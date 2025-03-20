create or replace package PQ_CR_NAVIDAD_II is
    -- *****************************************************************
    -- Nombre                     : paquete para CUPONES
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2015.10.02
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
procedure SP_CR_INSERT_JAQY774(
                                  P_JAQY774Pgc in JAQY774.JAQY774PGC%TYPE,
                                  P_JAQY774Mod in JAQY774.JAQY774MOD%TYPE,
                                  P_JAQY774Suc in JAQY774.JAQY774SUC%TYPE,
                                  P_JAQY774Mda in JAQY774.JAQY774MDA%TYPE,
                                  P_JAQY774Pap in JAQY774.JAQY774PAP%TYPE,
                                  P_JAQY774Cta in JAQY774.JAQY774CTA%TYPE,
                                  P_JAQY774Ope in JAQY774.JAQY774OPE%TYPE,
                                  P_JAQY774Sbo in JAQY774.JAQY774SBO%TYPE,
                                  P_JAQY774Top in JAQY774.JAQY774TOP%TYPE,
                                  P_JAQY774Cre in JAQY774.JAQY774CRE%TYPE,
                                  --P_JAQY774Hora in JAQY774.JAQY774HORA%TYPE,
                                  P_JAQY774Fec in JAQY774.JAQY774FEC%TYPE,
                                  P_JAQY774Fop in JAQY774.JAQY774FOP%TYPE,
                                  P_JAQY774Est in JAQY774.JAQY774EST%TYPE,
                                  P_JAQY774Usr in JAQY774.JAQY774USR%TYPE,
                                  P_JAQY774Age in JAQY774.JAQY774AGE%TYPE,
                                  P_JAQY774Dpt in JAQY774.JAQY774DPT%TYPE,
                                  P_JAQY774Ant in JAQY774.JAQY774ANT%TYPE,
                                  P_JAQY774Atr in JAQY774.JAQY774ATR%TYPE,
                                  P_JAQY774Cal in JAQY774.JAQY774CAL%TYPE,
                                  P_JAQY774Tip in JAQY774.JAQY774TIP%TYPE,
                                  P_JAQY774EXCUP  in JAQY774.JAQY774EXCUP%TYPE,
                                  P_JAQY774TSBOR  in JAQY774.JAQY774TSBOR%TYPE,
                                  P_JAQY774TORD   in JAQY774.JAQY774TORD%TYPE,
                                  P_JAQY774TNREL  in JAQY774.JAQY774TNREL%TYPE,
                                  P_JAQY774TTRAN  in JAQY774.JAQY774TTRAN%TYPE,
                                  P_JAQY774TMOD   in JAQY774.JAQY774TMOD%TYPE,
                                  P_JAQY774TSUC   in JAQY774.JAQY774TSUC%TYPE,
                                  P_JAQY774FCTA   in JAQY774.JAQY774FCTA%TYPE,      
                                  P_JAQY774NUMP   in JAQY774.JAQY774NUMP%TYPE, --numero de cuota a pagar
                                  P_JAQY774CUPNUM in JAQY774.JAQY774CUPNUM%TYPE,
                                  P_JAQY774OPC    in JAQY774.JAQY774OPC%TYPE
                                 
                         ) ;   
---------------------------------------------------------------------------------------------
/*procedure SP_CR_REGULARIZAR_JAQY774(      
                                  P_JAQY774Pgc in JAQY774.JAQY774PGC%TYPE,
                                  P_JAQY774Mod in JAQY774.JAQY774MOD%TYPE,
                                  P_JAQY774Suc in JAQY774.JAQY774SUC%TYPE,
                                  P_JAQY774Mda in JAQY774.JAQY774MDA%TYPE,
                                  P_JAQY774Pap in JAQY774.JAQY774PAP%TYPE,
                                  P_JAQY774Cta in JAQY774.JAQY774CTA%TYPE,
                                  P_JAQY774Ope in JAQY774.JAQY774OPE%TYPE,
                                  P_JAQY774Sbo in JAQY774.JAQY774SBO%TYPE,
                                  P_JAQY774Top in JAQY774.JAQY774TOP%TYPE,
                                  P_JAQY774Cre in JAQY774.JAQY774CRE%TYPE,
                                  P_JAQY774Hora in JAQY774.JAQY774HORA%TYPE,
                                  P_JAQY774Fec in JAQY774.JAQY774FEC%TYPE,
                                  P_JAQY774Fop in JAQY774.JAQY774FOP%TYPE,
                                  P_JAQY774Est in JAQY774.JAQY774EST%TYPE,
                                  P_JAQY774Usr in JAQY774.JAQY774USR%TYPE,
                                  P_JAQY774Age in JAQY774.JAQY774AGE%TYPE,
                                  P_JAQY774Dpt in JAQY774.JAQY774DPT%TYPE,
                                  P_JAQY774Ant in JAQY774.JAQY774ANT%TYPE,
                                  P_JAQY774Atr in JAQY774.JAQY774ATR%TYPE,
                                  P_JAQY774Cal in JAQY774.JAQY774CAL%TYPE,
                                  P_JAQY774Tip in JAQY774.JAQY774TIP%TYPE,
                                  P_JAQY774EXCUP  in JAQY774.JAQY774EXCUP%TYPE,
                                  P_JAQY774TSBOR  in JAQY774.JAQY774TSBOR%TYPE,
                                  P_JAQY774TORD   in JAQY774.JAQY774TORD%TYPE,
                                  P_JAQY774TNREL  in JAQY774.JAQY774TNREL%TYPE,
                                  P_JAQY774TTRAN  in JAQY774.JAQY774TTRAN%TYPE,
                                  P_JAQY774TMOD   in JAQY774.JAQY774TMOD%TYPE,
                                  P_JAQY774TSUC   in JAQY774.JAQY774TSUC%TYPE,
                                  P_JAQY774FCTA   in JAQY774.JAQY774FCTA%TYPE,      
                                  P_JAQY774NUMP   in JAQY774.JAQY774NUMP%TYPE, --numero de cuota a pagar
                                  P_JAQY774CUPNUM in JAQY774.JAQY774CUPNUM%TYPE,
                                  P_JAQY774OPC    in JAQY774.JAQY774OPC%TYPE
                                 
                         ) ;   */             
---------------------------------------------------------------------------------------------

 procedure SP_CR_INSERT_JAQY775(
                                  P_JAQY775Pg  in JAQY775.JAQY775PG%TYPE,
                                  P_JAQY775Mod in JAQY775.JAQY775MOD%TYPE,
                                  P_JAQY775Suc in JAQY775.JAQY775SUC%TYPE,
                                  P_JAQY775Mda in JAQY775.JAQY775MDA%TYPE,
                                  P_JAQY775Pap in JAQY775.JAQY775PAP%TYPE,
                                  P_JAQY775Cta in JAQY775.JAQY775CTA%TYPE,
                                  P_JAQY775Ope in JAQY775.JAQY775OPE%TYPE,
                                  P_JAQY775Sbo in JAQY775.JAQY775SBO%TYPE,
                                  P_JAQY775Top in JAQY775.JAQY775TOP%TYPE,
                                  P_JAQY775Cre in JAQY775.JAQY775CRE%TYPE,
                                  P_JAQY775Fec in JAQY775.JAQY775FEC%TYPE,--
                                  P_JAQY775Fop in JAQY775.JAQY775FOP%TYPE,--
                                  P_JAQY775Estd in JAQY775.JAQY775ESTd%TYPE,
                                  P_JAQY775Usr in JAQY775.JAQY775USR%TYPE,
                                  P_JAQY775Age in JAQY775.JAQY775AGE%TYPE,
                                  P_JAQY775Dpt in JAQY775.JAQY775DPT%TYPE,
                                  P_JAQY775Ant in JAQY775.JAQY775ANT%TYPE,
                                  P_JAQY775Atr in JAQY775.JAQY775ATR%TYPE,
                                  P_JAQY775Cal in JAQY775.JAQY775CAL%TYPE,
                                  P_JAQY775Tip in JAQY775.JAQY775TIP%TYPE,
                                  P_JAQY775Tsuc   in JAQY775.JAQY775TSUC%TYPE,-- 
                                  P_JAQY775Tmod   in JAQY775.JAQY775TMOD%TYPE,
                                  P_JAQY775Ttran  in JAQY775.JAQY775TTRAN%TYPE,
                                  P_JAQY775tnrel  in JAQY775.JAQY775TNREL%TYPE,
                                  P_JAQY775Tord   in JAQY775.JAQY775TORD%TYPE,
                                  P_JAQY775Tsbord in JAQY775.JAQY775TSBORD%TYPE,--
                                  P_JAQY775Nump   in JAQY775.JAQY775NUMP%TYPE,
                                  P_JAQY775Exto   in JAQY775.JAQY775EXTO%TYPE, 
                                  P_JAQY775Foper  in JAQY775.JAQY775FOPER%TYPE,
                                  P_JAQY775Numcup in JAQY775.JAQY775NUMCUP%TYPE, --
                                  P_JAQY775OPC    in JAQY775.JAQY775OPC%TYPE
                                );                       
                                   
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                             
/*procedure SP_CR_BUSCA_JAQY774(
                                  P_JAQY774Pgc in JAQY774.JAQY774PGC%TYPE,
                                  P_JAQY774Mod in JAQY774.JAQY774MOD%TYPE,
                                  P_JAQY774Suc in JAQY774.JAQY774SUC%TYPE,
                                  P_JAQY774Mda in JAQY774.JAQY774MDA%TYPE,
                                  P_JAQY774Pap in JAQY774.JAQY774PAP%TYPE,
                                  P_JAQY774Cta in JAQY774.JAQY774CTA%TYPE,
                                  P_JAQY774Ope in JAQY774.JAQY774OPE%TYPE,
                                  P_JAQY774Sbo in JAQY774.JAQY774SBO%TYPE,
                                  P_JAQY774Top in JAQY774.JAQY774TOP%TYPE,
                                  P_C_IND out varchar2
                                  );*/
-------------------------------------------------------------------------------------

-----------------------------------------------------------------------             
end PQ_CR_NAVIDAD_II;
/

create or replace package body PQ_CR_NAVIDAD_II is
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
---------------------------------------------------------------------------------------------
procedure SP_CR_INSERT_JAQY774(

                                  P_JAQY774Pgc in JAQY774.JAQY774PGC%TYPE,
                                  P_JAQY774Mod in JAQY774.JAQY774MOD%TYPE,
                                  P_JAQY774Suc in JAQY774.JAQY774SUC%TYPE,
                                  P_JAQY774Mda in JAQY774.JAQY774MDA%TYPE,
                                  P_JAQY774Pap in JAQY774.JAQY774PAP%TYPE,
                                  P_JAQY774Cta in JAQY774.JAQY774CTA%TYPE,
                                  P_JAQY774Ope in JAQY774.JAQY774OPE%TYPE,
                                  P_JAQY774Sbo in JAQY774.JAQY774SBO%TYPE,
                                  P_JAQY774Top in JAQY774.JAQY774TOP%TYPE,
                                  P_JAQY774Cre in JAQY774.JAQY774CRE%TYPE,
                                  --P_JAQY774Hora in JAQY774.JAQY774HORA%TYPE,
                                  P_JAQY774Fec in JAQY774.JAQY774FEC%TYPE,
                                  P_JAQY774Fop in JAQY774.JAQY774FOP%TYPE,
                                  P_JAQY774Est in JAQY774.JAQY774EST%TYPE,
                                  P_JAQY774Usr in JAQY774.JAQY774USR%TYPE,
                                  P_JAQY774Age in JAQY774.JAQY774AGE%TYPE,
                                  P_JAQY774Dpt in JAQY774.JAQY774DPT%TYPE,
                                  P_JAQY774Ant in JAQY774.JAQY774ANT%TYPE,
                                  P_JAQY774Atr in JAQY774.JAQY774ATR%TYPE,
                                  P_JAQY774Cal in JAQY774.JAQY774CAL%TYPE,
                                  P_JAQY774Tip in JAQY774.JAQY774TIP%TYPE,
                                  P_JAQY774EXCUP  in JAQY774.JAQY774EXCUP%TYPE,
                                  P_JAQY774TSBOR  in JAQY774.JAQY774TSBOR%TYPE,
                                  P_JAQY774TORD   in JAQY774.JAQY774TORD%TYPE,
                                  P_JAQY774TNREL  in JAQY774.JAQY774TNREL%TYPE,
                                  P_JAQY774TTRAN  in JAQY774.JAQY774TTRAN%TYPE,
                                  P_JAQY774TMOD   in JAQY774.JAQY774TMOD%TYPE,
                                  P_JAQY774TSUC   in JAQY774.JAQY774TSUC%TYPE,
                                  P_JAQY774FCTA   in JAQY774.JAQY774FCTA%TYPE,      
                                  P_JAQY774NUMP   in JAQY774.JAQY774NUMP%TYPE, --numero de cuota a pagar
                                  P_JAQY774CUPNUM in JAQY774.JAQY774CUPNUM%TYPE,
                                  P_JAQY774OPC    in JAQY774.JAQY774OPC%TYPE
                                 
                         ) is
   -- *****************************************************************
    -- Nombre                     : SP_CR_INSERT_JAQY774
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
                                              
      insert into JAQY774
      (
          JAQY774Cup,
          JAQY774Pgc,
          JAQY774Mod,
          JAQY774Suc,
          JAQY774Mda,
          JAQY774Pap,
          JAQY774Cta,
          JAQY774Ope,
          JAQY774Sbo,
          JAQY774Top,
          JAQY774Cre,
          --JAQY774Hora,
          JAQY774Fec,
          JAQY774Fop,
          JAQY774Est,
          JAQY774Usr,
          JAQY774Age,
          JAQY774Dpt,
          JAQY774Ant,
          JAQY774Atr,
          JAQY774Cal,
          JAQY774Tip,
          JAQY774EXCUP,
          JAQY774TSBOR,
          JAQY774TORD,
          JAQY774TNREL,
          JAQY774TTRAN,
          JAQY774TMOD,
          JAQY774TSUC,
          JAQY774FCTA,
          JAQY774NUMP,
          JAQY774CUPNUM,
          JAQY774OPC
      )
      values
      (
          SQ_AH_JAQY774.NEXTVAL,
          --SQ_AH_JAQl406.NEXTVAL,
          P_JAQY774Pgc,
          P_JAQY774Mod,
          P_JAQY774Suc,
          P_JAQY774Mda,
          P_JAQY774Pap,
          P_JAQY774Cta,
          P_JAQY774Ope,
          P_JAQY774Sbo,
          P_JAQY774Top,
          P_JAQY774Cre,
          --P_JAQY774Hora,
          P_JAQY774Fec,
          P_JAQY774Fop,
        --  null,
          P_JAQY774Est,
          P_JAQY774Usr,
          P_JAQY774Age,
          P_JAQY774Dpt,
          P_JAQY774Ant,
          P_JAQY774Atr,
          P_JAQY774Cal,
          P_JAQY774Tip,
          P_JAQY774EXCUP,
          P_JAQY774TSBOR,
          P_JAQY774TORD,
          P_JAQY774TNREL,
          P_JAQY774TTRAN,
          P_JAQY774TMOD,
          P_JAQY774TSUC,
          P_JAQY774FCTA,
          P_JAQY774NUMP,
          P_JAQY774CUPNUM,
          P_JAQY774OPC
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
                    P_JAQY774Mod,
                    P_JAQY774Suc,
                    P_JAQY774Mda,
                    P_JAQY774Pap,
                    P_JAQY774Cta,
                    P_JAQY774Ope,
                    P_JAQY774Sbo,
                    P_JAQY774Top,
                    P_JAQY774Cre,
                    P_JAQY774Fec,
                    P_JAQY774Fop,
                  --  null,
                    P_JAQY774Est,
                    P_JAQY774Usr,
                    P_JAQY774Age,
                    P_JAQY774Dpt,
                    P_JAQY774Ant,
                    P_JAQY774Atr,
                    P_JAQY774Cal,
                    P_JAQY774Tip,
                    P_JAQY774EXCUP,
                    P_JAQY774TSBOR,
                    P_JAQY774TORD,
                    P_JAQY774TNREL,
                    P_JAQY774TTRAN,
                    P_JAQY774TMOD,
                    P_JAQY774TSUC,
                    P_JAQY774FCTA,
                    P_JAQY774NUMP,
                    P_JAQY774CUPNUM,
                    P_JAQY774OPC,
                    lc_hora,
                    lc_error);
                 exception when others  then dbms_output.put_line(sqlerrm);
                 commit;
              end;
       ------------------------------------------------------------------------
      commit;
      
  end SP_CR_INSERT_JAQY774;
---------------------------------------------------------------------------------------------
/*procedure SP_CR_REGULARIZAR_JAQY774( 
                                  P_JAQY774Pgc in JAQY774.JAQY774PGC%TYPE,
                                  P_JAQY774Mod in JAQY774.JAQY774MOD%TYPE,
                                  P_JAQY774Suc in JAQY774.JAQY774SUC%TYPE,
                                  P_JAQY774Mda in JAQY774.JAQY774MDA%TYPE,
                                  P_JAQY774Pap in JAQY774.JAQY774PAP%TYPE,
                                  P_JAQY774Cta in JAQY774.JAQY774CTA%TYPE,
                                  P_JAQY774Ope in JAQY774.JAQY774OPE%TYPE,
                                  P_JAQY774Sbo in JAQY774.JAQY774SBO%TYPE,
                                  P_JAQY774Top in JAQY774.JAQY774TOP%TYPE,
                                  P_JAQY774Cre in JAQY774.JAQY774CRE%TYPE,
                                  P_JAQY774Hora in JAQY774.JAQY774HORA%TYPE,
                                  P_JAQY774Fec in JAQY774.JAQY774FEC%TYPE,
                                  P_JAQY774Fop in JAQY774.JAQY774FOP%TYPE,
                                  P_JAQY774Est in JAQY774.JAQY774EST%TYPE,
                                  P_JAQY774Usr in JAQY774.JAQY774USR%TYPE,
                                  P_JAQY774Age in JAQY774.JAQY774AGE%TYPE,
                                  P_JAQY774Dpt in JAQY774.JAQY774DPT%TYPE,
                                  P_JAQY774Ant in JAQY774.JAQY774ANT%TYPE,
                                  P_JAQY774Atr in JAQY774.JAQY774ATR%TYPE,
                                  P_JAQY774Cal in JAQY774.JAQY774CAL%TYPE,
                                  P_JAQY774Tip in JAQY774.JAQY774TIP%TYPE,
                                  P_JAQY774EXCUP  in JAQY774.JAQY774EXCUP%TYPE,
                                  P_JAQY774TSBOR  in JAQY774.JAQY774TSBOR%TYPE,
                                  P_JAQY774TORD   in JAQY774.JAQY774TORD%TYPE,
                                  P_JAQY774TNREL  in JAQY774.JAQY774TNREL%TYPE,
                                  P_JAQY774TTRAN  in JAQY774.JAQY774TTRAN%TYPE,
                                  P_JAQY774TMOD   in JAQY774.JAQY774TMOD%TYPE,
                                  P_JAQY774TSUC   in JAQY774.JAQY774TSUC%TYPE,
                                  P_JAQY774FCTA   in JAQY774.JAQY774FCTA%TYPE,      
                                  P_JAQY774NUMP   in JAQY774.JAQY774NUMP%TYPE, --numero de cuota a pagar
                                  P_JAQY774CUPNUM in JAQY774.JAQY774CUPNUM%TYPE,
                                  P_JAQY774OPC    in JAQY774.JAQY774OPC%TYPE
                                 
                         ) is
   -- *****************************************************************
    -- Nombre                     : SP_CR_REGULARIZAR_JAQY774
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
                                   
                                                
      insert into JAQY774
      (
          JAQY774Cup,
          JAQY774Pgc,
          JAQY774Mod,
          JAQY774Suc,
          JAQY774Mda,
          JAQY774Pap,
          JAQY774Cta,
          JAQY774Ope,
          JAQY774Sbo,
          JAQY774Top,
          JAQY774Cre,
          --JAQY774Hora,
          JAQY774Fec,
          JAQY774Fop,
          JAQY774Est,
          JAQY774Usr,
          JAQY774Age,
          JAQY774Dpt,
          JAQY774Ant,
          JAQY774Atr,
          JAQY774Cal,
          JAQY774Tip,
          JAQY774EXCUP,
          JAQY774TSBOR,
          JAQY774TORD,
          JAQY774TNREL,
          JAQY774TTRAN,
          JAQY774TMOD,
          JAQY774TSUC,
          JAQY774FCTA,
          JAQY774NUMP,
          JAQY774CUPNUM,
          JAQY774OPC

      )
      values
      (
          SQ_AH_JAQY774_1.NEXTVAL,
          P_JAQY774Pgc,
          P_JAQY774Mod,
          P_JAQY774Suc,
          P_JAQY774Mda,
          P_JAQY774Pap,
          P_JAQY774Cta,
          P_JAQY774Ope,
          P_JAQY774Sbo,
          P_JAQY774Top,
          P_JAQY774Cre,
          P_JAQY774Hora,
          P_JAQY774Fec,
          P_JAQY774Fop,
        --  null,
          P_JAQY774Est,
          P_JAQY774Usr,
          P_JAQY774Age,
          P_JAQY774Dpt,
          P_JAQY774Ant,
          P_JAQY774Atr,
          P_JAQY774Cal,
          P_JAQY774Tip,
          P_JAQY774EXCUP,
          P_JAQY774TSBOR,
          P_JAQY774TORD,
          P_JAQY774TNREL,
          P_JAQY774TTRAN,
          P_JAQY774TMOD,
          P_JAQY774TSUC,
          P_JAQY774FCTA,
          P_JAQY774NUMP,
          P_JAQY774CUPNUM,
          P_JAQY774OPC
      );

      commit;

  end SP_CR_REGULARIZAR_JAQY774; */
---------------------------------------------------------------------------------------------

 procedure SP_CR_INSERT_JAQY775(
                                  P_JAQY775Pg  in JAQY775.JAQY775PG%TYPE,
                                  P_JAQY775Mod in JAQY775.JAQY775MOD%TYPE,
                                  P_JAQY775Suc in JAQY775.JAQY775SUC%TYPE,
                                  P_JAQY775Mda in JAQY775.JAQY775MDA%TYPE,
                                  P_JAQY775Pap in JAQY775.JAQY775PAP%TYPE,
                                  P_JAQY775Cta in JAQY775.JAQY775CTA%TYPE,
                                  P_JAQY775Ope in JAQY775.JAQY775OPE%TYPE,
                                  P_JAQY775Sbo in JAQY775.JAQY775SBO%TYPE,
                                  P_JAQY775Top in JAQY775.JAQY775TOP%TYPE,
                                  P_JAQY775Cre in JAQY775.JAQY775CRE%TYPE,
                                  P_JAQY775Fec in JAQY775.JAQY775FEC%TYPE,--
                                  P_JAQY775Fop in JAQY775.JAQY775FOP%TYPE,--
                                  P_JAQY775Estd in JAQY775.JAQY775ESTd%TYPE,
                                  P_JAQY775Usr in JAQY775.JAQY775USR%TYPE,
                                  P_JAQY775Age in JAQY775.JAQY775AGE%TYPE,
                                  P_JAQY775Dpt in JAQY775.JAQY775DPT%TYPE,
                                  P_JAQY775Ant in JAQY775.JAQY775ANT%TYPE,
                                  P_JAQY775Atr in JAQY775.JAQY775ATR%TYPE,
                                  P_JAQY775Cal in JAQY775.JAQY775CAL%TYPE,
                                  P_JAQY775Tip in JAQY775.JAQY775TIP%TYPE,
                                  P_JAQY775Tsuc   in JAQY775.JAQY775TSUC%TYPE,-- 
                                  P_JAQY775Tmod   in JAQY775.JAQY775TMOD%TYPE,
                                  P_JAQY775Ttran  in JAQY775.JAQY775TTRAN%TYPE,
                                  P_JAQY775tnrel  in JAQY775.JAQY775TNREL%TYPE,
                                  P_JAQY775Tord   in JAQY775.JAQY775TORD%TYPE,
                                  P_JAQY775Tsbord in JAQY775.JAQY775TSBORD%TYPE,--
                                  P_JAQY775Nump   in JAQY775.JAQY775NUMP%TYPE,
                                  P_JAQY775Exto   in JAQY775.JAQY775EXTO%TYPE, 
                                  P_JAQY775Foper  in JAQY775.JAQY775FOPER%TYPE,
                                  P_JAQY775Numcup in JAQY775.JAQY775NUMCUP%TYPE, --
                                  P_JAQY775OPC    in JAQY775.JAQY775OPC%TYPE
                                                                   
                                         
                         ) is
   -- *****************************************************************
    -- Nombre                     : SP_CR_INSERT_JAQY775
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
  
   
      delete from JAQY774 where JAQY774Pgc    = P_JAQY775Pg 
                            and JAQY774Mod    = P_JAQY775Mod 
                            and JAQY774Suc    = P_JAQY775Suc 
                            and JAQY774Mda    = P_JAQY775Mda 
                            and JAQY774Pap    = P_JAQY775Pap  
                            and JAQY774Cta    = P_JAQY775Cta 
                            and JAQY774Ope    = P_JAQY775Ope 
                            and JAQY774Sbo    = P_JAQY775Sbo 
                            and JAQY774Top    = P_JAQY775Top 
                            and JAQY774Cre    = P_JAQY775Cre 
                            and JAQY774Fec    = P_JAQY775Fec 
                            and JAQY774Fop    = P_JAQY775FOP
                            and JAQY774Est    = P_JAQY775Estd 
                            and JAQY774Usr    = P_JAQY775Usr 
                            and JAQY774Age    = P_JAQY775Age 
                            and JAQY774Dpt    = P_JAQY775Dpt 
                            and JAQY774Ant    = P_JAQY775Ant 
                            and JAQY774Atr    = P_JAQY775Atr 
                            and JAQY774Cal    = P_JAQY775Cal 
                            and JAQY774Tip    = P_JAQY775Tip 
                            and JAQY774TSUC   = P_JAQY775TSUC  --1
                            and JAQY774TMOD   = P_JAQY775TMOD --2
                            and JAQY774TTRAN  = P_JAQY775TTRAN  --3
                            and JAQY774TNREL  = P_JAQY775TNREL --4
                            and JAQY774TORD   = P_JAQY775TORD --5
                            and JAQY774TSBOR  = P_JAQY775TSBORD -- 6
                            and JAQY774NUMP   = P_JAQY775NUMP --7
                            and JAQY774EXCUP  = P_JAQY775EXTO --8
                            and JAQY774FCTA   = P_JAQY775FOPER --9
                            and JAQY774CUPNUM = P_JAQY775NUMCUP
                            and JAQY774OPC    = P_JAQY775OPC
                            ;   
     /* delete from JAQY774 where JAQY774Pgc    = P_JAQY775Pg 
                            and JAQY774Mod    = P_JAQY775Mod 
                            and JAQY774Suc    = P_JAQY775Suc 
                            and JAQY774Mda    = P_JAQY775Mda 
                            and JAQY774Pap    = P_JAQY775Pap  
                            and JAQY774Cta    = P_JAQY775Cta 
                            and JAQY774Ope    = P_JAQY775Ope 
                            and JAQY774Sbo    = P_JAQY775Sbo 
                            and JAQY774Top    = P_JAQY775Top 
                            and JAQY774Cre    = P_JAQY775Cre 
                            and JAQY774Fec    = P_JAQY775Fec 
                            and JAQY774Fop    = P_JAQY775FOP
                            and JAQY774Est    = P_JAQY775Estd 
                            and JAQY774Usr    = P_JAQY775Usr 
                            and JAQY774Age    = P_JAQY775Age 
                            and JAQY774Dpt    = P_JAQY775Dpt 
                            and JAQY774Ant    = P_JAQY775Ant 
                            and JAQY774Atr    = P_JAQY775Atr 
                            and JAQY774Cal    = P_JAQY775Cal 
                            and JAQY774Tip    = P_JAQY775Tip 
                            and JAQY774TSUC   = P_JAQY775TSUC
                            and JAQY774TMOD   = P_JAQY775TMOD
                            and JAQY774TTRAN  = P_JAQY775TTRAN
                            and JAQY774TNREL  = P_JAQY775TNREL
                            and JAQY774TORD   = P_JAQY775TORD
                            and JAQY774TSBOR  = P_JAQY775TSBORD
                            and JAQY774NUMP   = P_JAQY775NUMP
                            and JAQY774EXCUP  = P_JAQY775EXTO
                            and JAQY774FCTA   = P_JAQY775FOPER
                            and JAQY774CUPNUM = P_JAQY775NUMCUP

                            ;*/
 
      insert into JAQY775
      (
          JAQY775Cupon,
          JAQY775Pg,
          JAQY775Mod,
          JAQY775Suc,
          JAQY775Mda,
          JAQY775Pap,
          JAQY775Cta,
          JAQY775Ope,
          JAQY775Sbo,
          JAQY775Top,
          JAQY775Cre,
          JAQY775Fec,
          JAQY775Fop,
          JAQY775Estd,
          JAQY775Usr,
          JAQY775Age,
          JAQY775Dpt,
          JAQY775Ant,
          JAQY775Atr,
          JAQY775Cal,
          JAQY775Tip,
          JAQY775Tsuc,
          JAQY775Tmod,
          JAQY775Ttran,
          JAQY775tnrel,
          JAQY775Tord,
          JAQY775Tsbord,
          JAQY775Nump,--
          JAQY775Exto, --no valee
          JAQY775Foper,
          JAQY775Numcup,
          JAQY775OPC
      )
      values
      (
          SQ_AH_JAQY775.NEXTVAL,
          P_JAQY775Pg,
          P_JAQY775Mod,
          P_JAQY775Suc,
          P_JAQY775Mda,
          P_JAQY775Pap,
          P_JAQY775Cta,
          P_JAQY775Ope,
          P_JAQY775Sbo,
          P_JAQY775Top,
          P_JAQY775Cre,
          P_JAQY775Fec,
          P_JAQY775Fop,
          P_JAQY775Estd,
          P_JAQY775Usr,
          P_JAQY775Age,
          P_JAQY775Dpt,
          P_JAQY775Ant,
          P_JAQY775Atr,
          P_JAQY775Cal,
          P_JAQY775Tip,
          P_JAQY775Tsuc,
          P_JAQY775Tmod,
          P_JAQY775Ttran,
          P_JAQY775tnrel,
          P_JAQY775Tord,
          P_JAQY775Tsbord,
          P_JAQY775Nump,
          P_JAQY775Exto,-- no vale
          P_JAQY775Foper,
          P_JAQY775Numcup,
          P_JAQY775OPC
      );

      commit;



  end SP_CR_INSERT_JAQY775;
----------------------------------------------------------------------------------------
/*procedure SP_CR_BUSCA_JAQY774(
                                  P_JAQY774Pgc in JAQY774.JAQY774PGC%TYPE,
                                  P_JAQY774Mod in JAQY774.JAQY774MOD%TYPE,
                                  P_JAQY774Suc in JAQY774.JAQY774SUC%TYPE,
                                  P_JAQY774Mda in JAQY774.JAQY774MDA%TYPE,
                                  P_JAQY774Pap in JAQY774.JAQY774PAP%TYPE,
                                  P_JAQY774Cta in JAQY774.JAQY774CTA%TYPE,
                                  P_JAQY774Ope in JAQY774.JAQY774OPE%TYPE,
                                  P_JAQY774Sbo in JAQY774.JAQY774SBO%TYPE,
                                  P_JAQY774Top in JAQY774.JAQY774TOP%TYPE,
                                  P_C_IND out varchar2
                         ) is
   -- *****************************************************************
    -- Nombre                     : SP_CR_BUSCA_JAQY774
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
  ln_num number;
  ln_cupones number;
  
  begin
  
  
  begin
    select tp1imp1 
      into ln_num
      from fst198 
      where Tp1cod = 1
        and Tp1cod1 = 10871
        and tp1corr1 = 4
        and tp1corr2 = 1
        and tp1corr3 = 2;
  exception when no_data_found then
       ln_num := 0;           
  end;

  
   begin
      select count(*) 
       into ln_cupones      
       from JAQY774          
      where JAQY774PGC = P_JAQY774Pgc
        and JAQY774MOD = P_JAQY774Mod
        and JAQY774SUC = P_JAQY774Suc
        and JAQY774MDA = P_JAQY774Mda
        and JAQY774PAP = P_JAQY774Pap
        and JAQY774CTA = P_JAQY774Cta
        and JAQY774OPE = P_JAQY774Ope
        and JAQY774SBO = P_JAQY774Sbo
        and JAQY774TOP = P_JAQY774Top;
        
   exception when no_Data_found then
        ln_cupones := 0  ;        
   end;
      
   if ln_cupones < ln_num then
      P_C_IND :=  'S'; --otorgar cupones
   else
      P_C_IND :=  'N'; --NO otorgar cupones excedio el limite
   end if;          


  end SP_CR_BUSCA_JAQY774;*/

----------------------------------------------------------------------------------------

end PQ_CR_NAVIDAD_II;
/

