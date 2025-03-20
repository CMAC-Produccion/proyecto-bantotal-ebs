create or replace package PQ_APL_SEGMENTACION is

  --*********************************************************
  -- Author  : ABERNEDO
  -- Created : 16/03/2016 01:09:55 p.m.
  -- Purpose : 
  --*********************************************************  

  Procedure Sp_Carga_data(pd_fecpro in date,
                          pn_pai    in number,
                          pn_tdo    in number,
                          pc_doc    in char,
                          pc_usr    in varchar2);
  procedure sp_cr_NS_LINEA_APL(P_D_FECPRO in date,
                               PN_PAIS    IN NUMBER,
                               PN_TDOC    IN NUMBER,
                               PC_NDOC    IN CHAR,
                               PC_USR     IN VARCHAR2);
  procedure sp_cr_cargar_variables_NS_APL(P_D_FECPRO IN DATE,
                                          P_N_PAIS   IN JAQZ095_APL.JAQZ095PAIS%type,
                                          P_N_TDOC   IN JAQZ095_APL.JAQZ095TDOC%type,
                                          P_C_NDOC   IN JAQZ095_APL.JAQZ095NDOC%type,
                                          P_C_USR    IN JAQZ095_APL.JAQZ095USR%type,
                                          p_a_nomvar out PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar,
                                          p_a_valvar out PQ_CR_SEGMENTACION_CLIENTES.tp_valvar,
                                          p_n_var    out number);
  Procedure Sp_cr_Resolutores(pn_pai        in number,
                              pn_tdo        in number,
                              pc_ndo        in char,
                              pd_fecpro     in date,
                              pn_cal        out number,
                              ln_CntInsRep  out number,
                              lc_fin_sobend out varchar2,
                              lc_castigado  out varchar2,
                              ln_CntAntRcc  out number);
  Procedure Sp_Resolutores_NS(pn_pai           in number,
                              pn_tdo           in number,
                              pc_ndo           in char,
                              pd_fecpro        in date,
                              ln_histCred      out number,
                              ln_promAtr       out number,
                              ln_segcod        out number,
                              lc_refinan       out char,
                              lc_tipHN         out char,
                              pn_cal           out number,
                              c_TipHist        out char, --mod@abr20170127
                              c_sdoTit         out char, --mod@abr 20181123
                              c_sdoCyg         out char, --mod@abr 20181123
                              n_segori         out number, --mod@abr 20181123
                              lc_premium_unico out char, --mod@abr 20180110
                              lc_premium       out char, --mod@abr 20180110
                              lc_preferencialA out char, --mod@abr 20180110
                              lc_preferencialb out char, --mod@abr 20180110
                              lc_preferencialC out char, --mod@abr 20180110
                              lc_Forjador      out char, --mod@abr 20180110
                              lc_Emprendedor   out char, --mod@abr 20180110
                              lc_PrefExclusivo out char, --mod@abr 20180110
                              lc_PreferenteA   out char, --mod@abr 20180110
                              lc_PreferenteB   out char, --mod@abr 20180110
                              lc_Recurrente    out char, --mod@abr 20180110
                              lc_Nuevo         out char --mod@abr 20180110
                              );

end PQ_APL_SEGMENTACION;
/

create or replace package body PQ_APL_SEGMENTACION is

  --*********************************************************
  -- Author  : ABERNEDO
  -- Created : 16/03/2016 01:09:55 p.m.
  -- Purpose : 
  -- Modificacion: Se agrego nvl a variables mod@abr20190408
  -- Modificado por: Abernedo
  -- Fecha de modificacion: 20190408
  --*********************************************************  

  Procedure Sp_Carga_data(pd_fecpro in date,
                          pn_pai    in number,
                          pn_tdo    in number,
                          pc_doc    in char,
                          pc_usr    in varchar2) is
  
    pn_cal           number(5, 2);
    ln_CntInsRep     number(10);
    lc_fin_sobend    char(1);
    lc_castigado     char(1);
    ln_histCred      number(5);
    ln_promAtr       number(18, 2);
    ln_segcod        number(2);
    lc_refinan       char(1);
    lc_tipHN         char(1);
    pn_cal2          number(5, 2);
    ln_CntAntRcc     number(10);
    ln_cal           number(5);
    hist_pyme        char(1); --mod@abr20170127
    saldo_Tit        char(1); --mod@abr20181123
    saldo_Cyg        char(1); --mod@abr20181123
    seg_ori          number(5); --mod@abr20181123
    lc_premium_unico char(1); --mod@abr 20180110
    lc_premium       char(1); --mod@abr 20180110
    lc_preferencialA char(1); --mod@abr 20180110
    lc_preferencialb char(1); --mod@abr 20180110
    lc_preferencialC char(1); --mod@abr 20180110
    lc_Forjador      char(1); --mod@abr 20180110
    lc_Emprendedor   char(1); --mod@abr 20180110
    lc_PrefExclusivo char(1); --mod@abr 20180110
    lc_PreferenteA   char(1); --mod@abr 20180110
    lc_PreferenteB   char(1); --mod@abr 20180110
    lc_Recurrente    char(1); --mod@abr 20180110
    lc_Nuevo         char(1); --mod@abr 20180110
  
    lc_JAQZ082VAR1  varchar2(100);
    lc_JAQZ082VAR2  varchar2(100);
    lc_JAQZ082VAR3  varchar2(100);
    lc_JAQZ082VAR4  varchar2(100);
    lc_JAQZ082VAR5  varchar2(100);
    lc_JAQZ082VAR6  varchar2(100);
    lc_JAQZ082VAR7  varchar2(100);
    lc_JAQZ082VAR8  varchar2(100);
    lc_JAQZ082VAR9  varchar2(100);
    lc_JAQZ082VAR10 varchar2(100);
    lc_JAQZ082VAR11 varchar2(100);
    lc_JAQZ082VAR12 varchar2(100);
    lc_JAQZ082VAR13 varchar2(100); --mod@abr20170127
    lc_JAQZ082VAR14 varchar2(100); --mod@abr20181123
    lc_JAQZ082VAR15 varchar2(100); --mod@abr20181123
    lc_JAQZ082VAR16 varchar2(100); --mod@abr 20180110
    lc_JAQZ082VAR17 varchar2(100); --mod@abr 20180110
    lc_JAQZ082VAR18 varchar2(100); --mod@abr 20180110
    lc_JAQZ082VAR19 varchar2(100); --mod@abr 20180110
    lc_JAQZ082VAR20 varchar2(100); --mod@abr 20180110
    lc_JAQZ082VAR21 varchar2(100); --mod@abr 20180110
    lc_JAQZ082VAR22 varchar2(100); --mod@abr 20180110
    lc_JAQZ082VAR23 varchar2(100); --mod@abr 20180110
    lc_JAQZ082VAR24 varchar2(100); --mod@abr 20180110
    lc_JAQZ082VAR25 varchar2(100); --mod@abr 20180110
    lc_JAQZ082VAR26 varchar2(100); --mod@abr 20180110
    lc_JAQZ082VAR27 varchar2(100); --mod@abr 20180110
  
    lc_lista char(1);
    lc_hora  char(8);
  
  begin
  
    Delete from jaqz095_aplinea a
     where a.jaqz095pais = pn_pai
       and a.jaqz095tdoc = pn_tdo
       and a.jaqz095ndoc = pc_doc
       and a.jaqz095usr = pc_usr;
    commit;
  
    lc_lista := 'N';
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS=". "';
  
    PQ_APL_SEGMENTACION.Sp_cr_Resolutores(pn_pai,
                                          pn_tdo,
                                          pc_doc,
                                          pd_fecpro,
                                          pn_cal,
                                          ln_CntInsRep,
                                          lc_fin_sobend,
                                          lc_castigado,
                                          ln_CntAntRcc);
    PQ_APL_SEGMENTACION.Sp_Resolutores_NS(pn_pai,
                                          pn_tdo,
                                          pc_doc,
                                          pd_fecpro,
                                          ln_histCred,
                                          ln_promAtr,
                                          ln_segcod,
                                          lc_refinan,
                                          lc_tipHN,
                                          pn_cal2,
                                          hist_pyme, --mod@abr20170127
                                          saldo_Tit,
                                          saldo_Cyg,
                                          seg_ori, --mod@abr 20181123
                                          lc_premium_unico, --mod@abr 20180110
                                          lc_premium, --mod@abr 20180110
                                          lc_preferencialA, --mod@abr 20180110
                                          lc_preferencialb, --mod@abr 20180110
                                          lc_preferencialC, --mod@abr 20180110
                                          lc_Forjador, --mod@abr 20180110
                                          lc_Emprendedor, --mod@abr 20180110
                                          lc_PrefExclusivo, --mod@abr 20180110
                                          lc_PreferenteA, --mod@abr 20180110
                                          lc_PreferenteB, --mod@abr 20180110
                                          lc_Recurrente, --mod@abr 20180110
                                          lc_Nuevo --mod@abr 20180110
                                          );
  
    lc_JAQZ082VAR1 := 'REL_CREDI' || '=' || trim(to_char(ln_histCred));
    if ln_promAtr = 0 then
      lc_JAQZ082VAR2 := 'DIA_ATRASO=0.00';
    else
      case
        when ln_promAtr < 1 and ln_promAtr > 0 then
          lc_JAQZ082VAR2 := 'DIA_ATRASO=' || '0' ||
                            TRIM(TO_CHAR(ln_promAtr));
        else
          lc_JAQZ082VAR2 := 'DIA_ATRASO=' || TRIM(TO_CHAR(ln_promAtr));
      end case;
    end if;
    lc_JAQZ082VAR3  := 'NRO_ENTIDADES_PSD' || '=' || trim(to_char(ln_CntInsRep)); --MOD@ABR 20190920
    lc_JAQZ082VAR4  := 'CALIFICACION_RCC' || '=' || trim(to_char(pn_cal));
    lc_JAQZ082VAR5  := 'HIST_NR' || '=' || trim(lc_tipHN);
    lc_JAQZ082VAR6  := 'SOBRE_ENDEUDADO' || '=' || trim(lc_fin_sobend);
    lc_JAQZ082VAR7  := 'REFINANCIADO' || '=' || trim(lc_refinan);
    lc_JAQZ082VAR8  := 'CASTIGADO' || '=' || trim(lc_castigado);
    lc_JAQZ082VAR9  := 'LISTA_NEGRA' || '=' || trim(lc_lista);
    lc_JAQZ082VAR10 := 'SEGMENTO' || '=' || trim(to_char(ln_segcod));
    lc_JAQZ082VAR11 := 'CAL_RCC_2' || '=' || trim(to_char(pn_cal2));
    lc_JAQZ082VAR12 := 'ANTIGUEDAD_RCC' || '=' ||
                       trim(to_char(ln_CntAntRcc));
    --        lc_JAQZ082VAR13 := 'HIST_PYME'||'='||trim(hist_pyme);--mod@abr20170127
    --        lc_JAQZ082VAR14 := 'SDODEUDA3_TIT'||'='||trim(saldo_Tit);--mod@abr20181123
    --        lc_JAQZ082VAR15 := 'SEGMENTO_ORI'||'='||trim(seg_ori);--mod@abr20181123
  
    lc_JAQZ082VAR13 := 'HIST_PYME' || '=' || trim(nvl(hist_pyme, 0)); --mod@abr20170127 --mod@abr20190408
    lc_JAQZ082VAR14 := 'SDODEUDA3_TIT' || '=' || trim(nvl(saldo_Tit, 0)); --mod@abr20181123 --mod@abr20190408
    lc_JAQZ082VAR15 := 'SEGMENTO_ORI' || '=' || trim(nvl(seg_ori, 0)); --mod@abr20181123 --mod@abr20190408
    lc_JAQZ082VAR16 := 'SEG_PREMIUM_UNICO' || '=' || trim(lc_premium_unico); --mod@abr20180110
    lc_JAQZ082VAR17 := 'SEG_PREMIUM' || '=' || trim(lc_premium); --mod@abr20180110
    lc_JAQZ082VAR18 := 'SEG_PREFERENCIAL_A' || '=' ||
                       trim(lc_preferencialA); --mod@abr20180110
    lc_JAQZ082VAR19 := 'SEG_PREFERENCIAL_B' || '=' ||
                       trim(lc_preferencialb); --mod@abr20180110
    lc_JAQZ082VAR20 := 'SEG_PREFERENCIAL_C' || '=' ||
                       trim(lc_preferencialC); --mod@abr20180110
    lc_JAQZ082VAR21 := 'SEG_FORJADOR' || '=' || trim(lc_Forjador); --mod@abr20180110
    lc_JAQZ082VAR22 := 'SEG_EMPRENDEDOR' || '=' || trim(lc_Emprendedor); --mod@abr20180110
    lc_JAQZ082VAR23 := 'SEG_PREFERENTE_EXCLUSIVO' || '=' ||
                       trim(lc_PrefExclusivo); --mod@abr20180110
    lc_JAQZ082VAR24 := 'SEG_PREFERENTE_A' || '=' || trim(lc_PreferenteA); --mod@abr20180110
    lc_JAQZ082VAR25 := 'SEG_PREFERENTE_B' || '=' || trim(lc_PreferenteB); --mod@abr20180110
    lc_JAQZ082VAR26 := 'SEG_RECURRENTE' || '=' || trim(lc_Recurrente); --mod@abr20180110
    lc_JAQZ082VAR27 := 'SEG_NUEVO' || '=' || trim(lc_Nuevo); --mod@abr20180110
  
    ln_cal  := 0;
    lc_hora := TO_CHAR(SYSDATE, 'hh:mm:ss');
  
    insert into jaqz095_aplinea
      (JAQZ095FECH,
       JAQZ095PAIS,
       JAQZ095TDOC,
       JAQZ095NDOC,
       JAQZ095HORA,
       JAQZ083CCAL,
       JAQZ095VAR1,
       JAQZ095VAR2,
       JAQZ095VAR3,
       JAQZ095VAR4,
       JAQZ095VAR5,
       JAQZ095VAR6,
       JAQZ095VAR7,
       JAQZ095VAR8,
       JAQZ095VAR9,
       JAQZ095VAR10,
       JAQZ095VAR11,
       JAQZ095VAR12,
       JAQZ095VAR13, --mod@abr20170127
       jaqz095VAR14,
       JAQZ095VAR15, --mod@abr 20181123
       JAQZ095VAR16,
       JAQZ095VAR17,
       JAQZ095VAR18,
       JAQZ095VAR19, --mod@abr20180110
       JAQZ095VAR20,
       JAQZ095VAR21,
       JAQZ095VAR22,
       JAQZ095VAR23,
       JAQZ095VAR24,
       JAQZ095VAR25, --mod@abr20180110
       JAQZ095VAR26,
       JAQZ095VAR27,
       JAQZ095USR)
    values
      (pd_fecpro,
       pn_pai,
       pn_tdo,
       pc_doc,
       lc_hora,
       ln_cal,
       lc_JAQZ082VAR1,
       lc_JAQZ082VAR2,
       lc_JAQZ082VAR3,
       lc_JAQZ082VAR4,
       lc_JAQZ082VAR5,
       lc_JAQZ082VAR6,
       lc_JAQZ082VAR7,
       lc_JAQZ082VAR8,
       lc_JAQZ082VAR9,
       lc_JAQZ082VAR10,
       lc_JAQZ082VAR11,
       lc_JAQZ082VAR12,
       lc_JAQZ082VAR13, --mod@abr20170127
       lc_JAQZ082VAR14,
       lc_JAQZ082VAR15, --mod@abr 20181123
       lc_JAQZ082VAR16,
       lc_JAQZ082VAR17,
       lc_JAQZ082VAR18,
       lc_JAQZ082VAR19, --mod@abr20180110
       lc_JAQZ082VAR20,
       lc_JAQZ082VAR21,
       lc_JAQZ082VAR22,
       lc_JAQZ082VAR23,
       lc_JAQZ082VAR24,
       lc_JAQZ082VAR25, --mod@abr20180110
       lc_JAQZ082VAR26,
       lc_JAQZ082VAR27,
       pc_usr);
  
    commit;
  
    PQ_APL_SEGMENTACION.sp_cr_NS_LINEA_APL(pd_fecpro,
                                           pn_pai,
                                           pn_tdo,
                                           pc_doc,
                                           pc_usr);
  
  end Sp_Carga_data;

  procedure sp_cr_NS_LINEA_APL(P_D_FECPRO in date,
                               PN_PAIS    IN NUMBER,
                               PN_TDOC    IN NUMBER,
                               PC_NDOC    IN CHAR,
                               PC_USR     IN VARCHAR2) IS
  
    cursor c_clientes(p_fecpro date) is
      select /*+all_rows index_ss(l)*/
       jaqz095pais, jaqz095tdoc, jaqz095ndoc
        from JAQZ095_aplinea l
       where l.jaqz095pais = PN_PAIS
         and l.jaqz095tdoc = PN_TDOC
         and l.jaqz095ndoc = PC_NDOC
         and l.jaqz095usr = PC_USR;
    --and jaqy162ndoc = '43716599';
  
    cursor c_reglas is
    
      select /*+ALL_ROWS*/
       g.RNG50ORD,
       t.RNG49COD,
       t.RNG50GRP,
       t.RNG51COD,
       t.RNG68COD,
       t.RNG51OPE,
       t.RNG51VAL,
       a.RNG68ATR,
       a.RNG68TDA,
       g.RNG50Ret
        from FRNG50 g
       inner join frng51 t
          on g.rng49cod = t.rng49cod
         and g.rng50grp = t.rng50grp
       inner join frng68 a
          on t.rng49cod = a.rng49cod
         and t.rng68cod = a.rng68cod
      --          where t.RNG49Cod in (1611, 1612, 1613, 1614, 1617)
      -- where t.RNG49Cod in (1620, 1621) mod@abr 20180110
       where t.RNG49Cod in (1620, 1621, 1624) --mod@abr 20180110
       order by g.RNG49COD, g.RNG50ORD, t.RNG50GRP, t.RNG51COD;
  
    cursor c_guia(p_tp1cod   number,
                  p_Tp1cod1  number,
                  p_Tp1corr1 number,
                  p_Tp1corr2 number) is
      select tp1nro1, tp1nro2, tp1nro3, tp1desc, tp1imp1, tp1imp2, tp1imp3
        from fst198
       where Tp1cod = p_tp1cod
         and Tp1cod1 = p_Tp1cod1
         and Tp1corr1 = p_Tp1corr1
         and Tp1corr2 = p_Tp1corr2;
  
    Regla         frng51.rng49cod%type;
    SegmentoRegla frng50.rng50ret%type;
    la_nomvar     PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar;
    la_valvar     PQ_CR_SEGMENTACION_CLIENTES.tp_valvar;
    la_nomnul     PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar;
    la_valnul     PQ_CR_SEGMENTACION_CLIENTES.tp_valvar;
    ln_var        number(3) := 0;
    Tp1cod        fst198.tp1cod%type;
    Tp1cod1       fst198.tp1cod1%type;
    Tp1corr1      fst198.tp1corr1%type;
    Tp1corr2      fst198.tp1corr2%type;
    Tp1desc       fst198.tp1desc%type;
    JAQY067CCAL   jaqy067.jaqy067ccal%type;
    --l_jaqy066pano  jaqy066.jaqy066pano%type;
    --l_jaqy066pmes  jaqy066.jaqy066pmes%type;
    l_jaqz086paic  jaqz086_APL.jaqz086paic%type;
    l_jaqz086tdoc  jaqz086_APL.jaqz086tdoc%type;
    l_jaqz086tndoc jaqz086_APL.jaqz086tndoc%type;
    l_jaqz086calf  jaqz086_APL.jaqz086calf%type;
    --l_jaqy066fecp  jaqy066.jaqy066fecp%type;
    --l_jaqy066horp  jaqy066.jaqy066horp%type;
    l_jaqz086tcal jaqz086_APL.jaqz086tcal%type;
  
    TYPE tp_pais IS TABLE OF jaqz082.jaqz082pais%type INDEX BY BINARY_INTEGER;
    TYPE tp_tdoc IS TABLE OF jaqz082.jaqz082tdoc%type INDEX BY BINARY_INTEGER;
    TYPE tp_ndoc IS TABLE OF jaqz082.jaqz082ndoc%type INDEX BY BINARY_INTEGER;
  
    la_JAQZ082pais tp_pais;
    la_JAQZ082tdoc tp_tdoc;
    la_JAQZ082ndoc tp_ndoc;
    la_reglas      pq_cr_segmentacion_clientes.tb_reglas;
    ln_reg         number(5);
  
    --p_ndoc char(12);
    --ln_tamdoc number(2);
  BEGIN
  
    execute immediate 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
    execute immediate 'ALTER SESSION SET OPTIMIZER_MODE=ALL_ROWS'; --jflor 2014.01.17  
    execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE'; --jflor 2014.05.05
  
    delete from JAQZ086_APLINEA a
     where a.jaqz086paic = PN_PAIS
       and a.jaqz086tdoc = PN_TDOC
       and a.jaqz086tndoc = PC_NDOC
       and a.jaqz086usr = PC_USR;
    commit;
  
    Regla := 1620;
  
    -- Cargar reglas
    ln_reg := 0;
    for r in c_reglas loop
      ln_reg := ln_reg + 1;
      la_reglas(ln_reg).RNG49COD := r.rng49cod;
      la_reglas(ln_reg).RNG50GRP := r.rng50grp;
      la_reglas(ln_reg).RNG51COD := r.rng51cod;
      la_reglas(ln_reg).RNG68COD := r.rng68cod;
      la_reglas(ln_reg).RNG51OPE := r.rng51ope;
      la_reglas(ln_reg).RNG51VAL := r.rng51val;
      la_reglas(ln_reg).RNG68ATR := r.rng68atr;
      la_reglas(ln_reg).RNG68TDA := r.rng68tda;
      la_reglas(ln_reg).RNG50Ret := r.rng50ret;
    end loop;
  
    OPEN c_clientes(P_D_FECPRO); -- Clientes Bulk
    FETCH c_clientes BULK COLLECT
      INTO la_JAQZ082pais, la_JAQZ082tdoc, la_JAQZ082ndoc;
  
    IF la_JAQZ082ndoc.count > 0 THEN
      FOR c IN la_JAQZ082ndoc.FIRST .. la_JAQZ082ndoc.LAST LOOP
      
        la_nomvar := la_nomnul;
        la_valvar := la_valnul;
        PQ_APL_SEGMENTACION.sp_cr_cargar_variables_NS_APL(P_D_FECPRO => P_D_FECPRO,
                                                          P_N_PAIS   => la_JAQZ082pais(c),
                                                          P_N_TDOC   => la_JAQZ082tdoc(c),
                                                          P_C_NDOC   => la_JAQZ082ndoc(c),
                                                          P_C_USR    => PC_USR,
                                                          p_a_nomvar => la_nomvar,
                                                          p_a_valvar => la_valvar,
                                                          p_n_var    => ln_var);
        SegmentoRegla := null;
        PQ_CR_SEGMENTACION_CLIENTES.sp_cr_evalua_clientes_1_NS(P_N_REGLA   => Regla,
                                                               P_A_NOMVAR  => la_nomvar,
                                                               P_A_VALVAR  => la_valvar,
                                                               P_N_VAR     => ln_var,
                                                               P_A_REGLAS  => la_reglas,
                                                               P_N_REG     => ln_reg,
                                                               p_c_retorno => SegmentoRegla);
      
        Tp1cod      := 1;
        Tp1cod1     := 10823;
        Tp1corr1    := 2;
        Tp1corr2    := 12; -- Equivalencia resultado reglas - calificacion
        Tp1desc     := Trim(SegmentoRegla);
        JAQY067CCAL := null;
      
        For g in c_guia(Tp1cod, Tp1cod1, Tp1corr1, Tp1corr2) loop
          If g.tp1desc = Tp1desc Then
            JAQY067CCAL := g.tp1nro1;
          End If;
        End Loop;
      
        If JAQY067CCAL is not null then
          -- Califica
          l_jaqz086paic  := la_JAQZ082pais(c);
          l_jaqz086tdoc  := la_JAQZ082tdoc(c);
          l_jaqz086tndoc := la_JAQZ082ndoc(c);
          l_jaqz086calf  := JAQY067CCAL;
          --l_jaqz086horp := to_char(sysdate(),'HH24:MI:SS');
          l_jaqz086tcal := 'P';
        
          insert into JAQZ086_APLINEA
            (jaqz086PAIC,
             jaqz086TDOC,
             jaqz086TNDOC,
             jaqz086CALF,
             jaqz086TCAL,
             jaqz086usr)
          values
            (l_jaqz086paic,
             l_jaqz086tdoc,
             l_jaqz086tndoc,
             l_jaqz086calf,
             l_jaqz086tcal,
             PC_USR);
          commit;
        
        End If;
      
      END LOOP; -- clientes
    END IF;
  
  END sp_cr_NS_LINEA_APL;

  procedure sp_cr_cargar_variables_NS_APL(P_D_FECPRO IN DATE,
                                          P_N_PAIS   IN JAQZ095_APL.JAQZ095PAIS%type,
                                          P_N_TDOC   IN JAQZ095_APL.JAQZ095TDOC%type,
                                          P_C_NDOC   IN JAQZ095_APL.JAQZ095NDOC%type,
                                          P_C_USR    IN JAQZ095_APL.JAQZ095USR%type,
                                          p_a_nomvar out PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar,
                                          p_a_valvar out PQ_CR_SEGMENTACION_CLIENTES.tp_valvar,
                                          p_n_var    out number) is
  
    cursor c_cliente is
      select jaqz095fech,
             JAQZ095pais,
             JAQZ095tdoc,
             JAQZ095ndoc,
             JAQZ095var1,
             jaqz095var2,
             JAQZ095var3,
             JAQZ095var4,
             JAQZ095var5,
             JAQZ095var6,
             JAQZ095var7,
             JAQZ095var8,
             JAQZ095var9,
             JAQZ095var10,
             JAQZ095var11,
             JAQZ095var12,
             JAQZ095var13,
             JAQZ095var14,
             JAQZ095var15,
             JAQZ095var16,
             JAQZ095var17,
             JAQZ095var18,
             JAQZ095var19,
             JAQZ095var20,
             JAQZ095var21,
             JAQZ095var22,
             JAQZ095var23,
             JAQZ095var24,
             JAQZ095var25,
             JAQZ095var26,
             JAQZ095var27,
             JAQZ095var28,
             JAQZ095var29,
             JAQZ095var30,
             JAQZ095var31,
             JAQZ095var32,
             JAQZ095var33,
             JAQZ095var34,
             JAQZ095var35,
             JAQZ095var36,
             JAQZ095var37,
             JAQZ095var38,
             JAQZ095var39,
             JAQZ095var40
        from JAQZ095_APLINEA
       where JAQZ095fech = P_D_FECPRO
         and JAQZ095pais = P_N_PAIS
         and JAQZ095tdoc = P_N_TDOC
         and JAQZ095ndoc = P_C_NDOC
         and JAQZ095usr = P_C_USR;
    ln_tmpnum number(3);
  
  begin
  
    for cli in c_cliente loop
      -- Cargando Variables Resuletas
      if trim(cli.JAQZ095var1) is not null then
        p_n_var := 1;
        ln_tmpnum := instr(cli.JAQZ095var1, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var1, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var1, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var2) is not null then
        p_n_var := 2;
        ln_tmpnum := instr(cli.JAQZ095var2, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var2, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var2, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var3) is not null then
        p_n_var := 3;
        ln_tmpnum := instr(cli.JAQZ095var3, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var3, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var3, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var4) is not null then
        p_n_var := 4;
        ln_tmpnum := instr(cli.JAQZ095var4, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var4, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var4, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var5) is not null then
        p_n_var := 5;
        ln_tmpnum := instr(cli.JAQZ095var5, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var5, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var5, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var6) is not null then
        p_n_var := 6;
        ln_tmpnum := instr(cli.JAQZ095var6, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var6, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var6, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var7) is not null then
        p_n_var := 7;
        ln_tmpnum := instr(cli.JAQZ095var7, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var7, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var7, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var8) is not null then
        p_n_var := 8;
        ln_tmpnum := instr(cli.JAQZ095var8, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var8, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var8, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var9) is not null then
        p_n_var := 9;
        ln_tmpnum := instr(cli.JAQZ095var9, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var9, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var9, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var10) is not null then
        p_n_var := 10;
        ln_tmpnum := instr(cli.JAQZ095var10, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var10, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var10, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var11) is not null then
        p_n_var := 11;
        ln_tmpnum := instr(cli.JAQZ095var11, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var11, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var11, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var12) is not null then
        p_n_var := 12;
        ln_tmpnum := instr(cli.JAQZ095var12, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var12, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var12, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var13) is not null then
        p_n_var := 13;
        ln_tmpnum := instr(cli.JAQZ095var13, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var13, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var13, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var14) is not null then
        p_n_var := 14;
        ln_tmpnum := instr(cli.JAQZ095var14, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var14, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var14, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var15) is not null then
        p_n_var := 15;
        ln_tmpnum := instr(cli.JAQZ095var15, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var15, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var15, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var16) is not null then
        p_n_var := 16;
        ln_tmpnum := instr(cli.JAQZ095var16, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var16, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var16, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var17) is not null then
        p_n_var := 17;
        ln_tmpnum := instr(cli.JAQZ095var17, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var17, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var17, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var18) is not null then
        p_n_var := 18;
        ln_tmpnum := instr(cli.JAQZ095var18, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var18, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var18, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var19) is not null then
        p_n_var := 19;
        ln_tmpnum := instr(cli.JAQZ095var19, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var19, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var19, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var20) is not null then
        p_n_var := 20;
        ln_tmpnum := instr(cli.JAQZ095var20, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var20, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var20, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var21) is not null then
        p_n_var := 21;
        ln_tmpnum := instr(cli.JAQZ095var21, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var21, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var21, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var22) is not null then
        p_n_var := 22;
        ln_tmpnum := instr(cli.JAQZ095var22, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var22, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var22, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var23) is not null then
        p_n_var := 23;
        ln_tmpnum := instr(cli.JAQZ095var23, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var23, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var23, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var24) is not null then
        p_n_var := 24;
        ln_tmpnum := instr(cli.JAQZ095var24, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var24, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var24, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var25) is not null then
        p_n_var := 25;
        ln_tmpnum := instr(cli.JAQZ095var25, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var25, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var25, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var26) is not null then
        p_n_var := 26;
        ln_tmpnum := instr(cli.JAQZ095var26, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var26, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var26, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var27) is not null then
        p_n_var := 27;
        ln_tmpnum := instr(cli.JAQZ095var27, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var27, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var27, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var28) is not null then
        p_n_var := 28;
        ln_tmpnum := instr(cli.JAQZ095var28, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var28, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var28, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var29) is not null then
        p_n_var := 29;
        ln_tmpnum := instr(cli.JAQZ095var29, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var29, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var29, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var30) is not null then
        p_n_var := 30;
        ln_tmpnum := instr(cli.JAQZ095var30, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var30, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var30, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var31) is not null then
        p_n_var := 31;
        ln_tmpnum := instr(cli.JAQZ095var31, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var31, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var31, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var32) is not null then
        p_n_var := 32;
        ln_tmpnum := instr(cli.JAQZ095var32, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var32, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var32, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var33) is not null then
        p_n_var := 33;
        ln_tmpnum := instr(cli.JAQZ095var33, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var33, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var33, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var34) is not null then
        p_n_var := 34;
        ln_tmpnum := instr(cli.JAQZ095var34, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var34, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var34, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var35) is not null then
        p_n_var := 35;
        ln_tmpnum := instr(cli.JAQZ095var35, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var35, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var35, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var36) is not null then
        p_n_var := 36;
        ln_tmpnum := instr(cli.JAQZ095var36, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var36, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var36, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var37) is not null then
        p_n_var := 37;
        ln_tmpnum := instr(cli.JAQZ095var37, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var37, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var37, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var38) is not null then
        p_n_var := 38;
        ln_tmpnum := instr(cli.JAQZ095var38, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var38, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var38, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var39) is not null then
        p_n_var := 39;
        ln_tmpnum := instr(cli.JAQZ095var39, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var39, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var39, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ095var40) is not null then
        p_n_var := 40;
        ln_tmpnum := instr(cli.JAQZ095var40, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ095var40, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ095var40, ln_tmpnum + 1);
      end if;
    
    end loop;
  
  end sp_cr_cargar_variables_NS_APL;

  Procedure Sp_cr_Resolutores(pn_pai        in number,
                              pn_tdo        in number,
                              pc_ndo        in char,
                              pd_fecpro     in date,
                              pn_cal        out number,
                              ln_CntInsRep  out number,
                              lc_fin_sobend out varchar2,
                              lc_castigado  out varchar2,
                              ln_CntAntRcc  out number) is
    DocSbs_Cyg   number(10);
    DocSbsCyg    char(1);
    DocSbs       number(10);
    DocSbsTit    char(1);
    lc_tiper_Cyg char(1);
  
    fecNum_rcc number(9);
    MesRcc     number(9);
    ln_Rpccyg  number(2);
    lc_tiper   char(1);
    fec_rcc    date;
    ln_paiC    number(3);
    ln_tdoC    number(2);
    lc_ndoC    char(12);
    --------------------
    --ln_CntOpeRccTi number(10); --mod@abr20180116
    --ln_CntOpeRccCy number(10); --mod@abr20180116
    -------------------
    lc_conyu      char(1);
    lc_tit_sobend char(1);
    lc_con_sobend char(1);
    ld_fecdob     date;
    ln_anio       number(4);
    ln_mes        number(2);
    ------------------
    ln_estaCan number(9);
    cursor cuentas is
      select a.ctnro
        from fsr008 a
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo;
    ln_aoemp   number(3);
    ln_aomod   number(3);
    ln_aosuc   number(3);
    ln_aomda   number(4);
    ln_aopap   number(4);
    ln_aocta   number(9);
    ln_aooper  number(9);
    ln_aosbop  number(3);
    ln_aotope  number(3);
    ln_aostat  number(2);
    ld_fecrec  date;
    ln_r1mod   number(3);
    ln_r1suc   number(3);
    ln_r1mda   number(4);
    ln_r1pap   number(4);
    ln_r1cta   number(9);
    ln_r1oper  number(9);
    ln_r1sbop  number(3);
    ln_r1tope  number(3);
    ln_evento  number(10);
    ld_FechaRL date;
    ------------------------
    ln_lim       number(9);
    ln_ic        number(3);
    ld_fecantrcc date;
    lc_flgEx     char(1);
  
    --pn_doc varchar2(12);  
  
  begin
    --*******CALIFICACION_RCC********--------
    --Guia equivalencia tipo de documento
    begin
      select a.tp1corr3
        into DocSbs
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11111
         and a.tp1corr1 = 1
         and a.tp1corr2 = 3
         and tp1nro1 = pn_tdo;
    exception
      when no_data_found then
        DocSbs := null;
    end;
    DocSbsTit := Trim(to_char(DocSbs));
  
    --fecha RCC
    begin
      select tpnro
        into fecNum_rcc
        from fst098
       where pgcod = 1
         and tpcod = 7647
         and tpcorr = 12;
    exception
      when no_data_found then
        fecNum_rcc := null;
    end;
    fec_rcc := to_date(fecNum_rcc, 'dd/mm/yyyy');
    --Meses a evaluar RCC
    begin
      select tpnro
        into MesRcc
        from fst098
       where pgcod = 1
         and tpcod = 7647
         and tpcorr = 13;
    exception
      when no_data_found then
        MesRcc := null;
    end;
    --vinculo conyugue
    begin
      select a.tp1corr3
        into ln_Rpccyg
        from fst198 a
       where a.tp1cod1 = 10823
         and Tp1corr1 = 3
         and Tp1corr2 = 1;
    exception
      when no_data_found then
        ln_Rpccyg := null;
    end;
    --tipo de persona
    begin
      select a.petipo
        into lc_tiper
        from fsd001 a
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo;
    exception
      when no_data_found then
        lc_tiper := null;
    end;
    pn_cal := 100.00;
  
    pn_cal := pq_cr_segm_mens_nuev.Fn_calificacion_RCC(DocSbsTit,
                                                       pc_ndo,
                                                       fec_rcc,
                                                       MesRcc,
                                                       lc_tiper);
  
    --evalua conyugue si la calificacion es normal para el titular
  
    begin
      select a.rppais, a.rptdoc, a.rpndoc
        into ln_paiC, ln_tdoC, lc_ndoC
        from fsr002 a
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo
         and a.rpccyg = ln_Rpccyg
         and rownum = 1;
    exception
      when no_data_found then
        ln_paiC := null;
        ln_tdoC := null;
        lc_ndoC := null;
    end;
  
    --Guia equivalencia tipo de documento
    begin
      select a.tp1corr3
        into DocSbs_Cyg
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11111
         and a.tp1corr1 = 1
         and a.tp1corr2 = 3
         and tp1nro1 = ln_tdoC;
    exception
      when no_data_found then
        DocSbs_Cyg := null;
    end;
    DocSbsCyg := Trim(to_char(DocSbs_Cyg));
  
    --tipo de persona
    begin
      select a.petipo
        into lc_tiper_Cyg
        from fsd001 a
       where a.pepais = ln_paiC
         and a.petdoc = ln_tdoC
         and a.pendoc = lc_ndoC;
    exception
      when no_data_found then
        lc_tiper_Cyg := null;
    end;
  
    if pn_cal = 100.00 and lc_ndoC is not null then
      if lc_ndoC is null then
        insert into jaqz082_aux
          (jaqz082ndo, JAQZ082TPO)
        values
          (pc_ndo, 'CYG');
        commit;
      end if;
    
      pn_cal := pq_cr_segm_mens_nuev.Fn_calificacion_RCC(DocSbsCyg,
                                                         lc_ndoC,
                                                         fec_rcc,
                                                         MesRcc,
                                                         lc_tiper_Cyg);
    
    end if;
  
    --***************CANT_ENTIDADES**********----
    --ln_CntOpeRccTi := 0;
    --ln_CntOpeRccCy := 0; --mod@abr20180115
    --ln_CntInsRep   := 0; --mod@abr20180115
  
    --ln_CntOpeRccTi := pq_cr_segm_mens_nuev.Fn_cant_instit(DocSbsTit,  --mod@abr20180115
    --                                                      pc_ndo,  --mod@abr20180115
    --                                                      fec_rcc,  --mod@abr20180115
    --                                                      lc_tiper);  --mod@abr20180115
  
    --if lc_ndoC is not null then  --mod@abr20180115
  
    --ln_CntOpeRccCy := pq_cr_segm_mens_nuev.Fn_cant_instit(DocSbsCyg,  --mod@abr20180115
    --                                                      lc_ndoC,  --mod@abr20180115
    ---                                                      fec_rcc,  --mod@abr20180115
    --                                                      lc_tiper_Cyg);  --mod@abr20180115
  
    --end if;  --mod@abr20180115
  
    --ln_CntInsRep := ln_CntOpeRccTi + ln_CntOpeRccCy;  --mod@abr20180115
  
    pq_cr_deurcc.sp_cr_rcc(pn_pai, pn_tdo, pc_ndo, ln_CntInsRep); --mod@abr 20180116
  
    --*******SOBREENDEUDAMIENTO******-----
    lc_tit_sobend := 'N';
    lc_con_sobend := 'N';
    lc_fin_sobend := 'N';
  
    --determinar fecha de proceso
    ld_fecdob := add_months(pd_fecpro, -1);
    ln_anio   := to_number(to_char(ld_fecdob, 'yyyy'));
    ln_mes    := to_number(to_char(ld_fecdob, 'mm'));
    --guia si se debe incluir al conyugue
    begin
      select trim(a.tp1desc)
        into lc_conyu
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10823
         and a.tp1corr1 = 1
         and a.tp1corr2 = 5;
    exception
      when no_data_found then
        lc_conyu := null;
    end;
    begin
      select jaql157sob
        into lc_tit_sobend
        from JAQL157
       Where jaql157pai = pn_pai
         and jaql157tdo = pn_tdo
         and jaql157ndo = pc_ndo
         and jaql157ani = ln_anio
         and jaql157mes = ln_mes;
    exception
      when no_data_found then
        lc_tit_sobend := null;
    end;
    ---analisis conyugue
    if lc_conyu = 'S' then
      begin
        select a.rppais, a.rptdoc, a.rpndoc
          into ln_paiC, ln_tdoC, lc_ndoC
          from fsr002 a
         where a.pepais = pn_pai
           and a.petdoc = pn_tdo
           and a.pendoc = pc_ndo
           and a.rpccyg = ln_Rpccyg
           and rownum = 1;
      exception
        when no_data_found then
          ln_paiC := null;
          ln_tdoC := null;
          lc_ndoC := null;
      end;
    
      begin
        select jaql157sob
          into lc_con_sobend
          from JAQL157
         Where jaql157pai = ln_paiC
           and jaql157tdo = ln_tdoC
           and jaql157ndo = lc_ndoC
           and jaql157ani = ln_anio
           and jaql157mes = ln_mes;
      exception
        when no_data_found then
          lc_con_sobend := null;
      end;
    
    end if;
  
    If lc_tit_sobend = 'S' or lc_con_sobend = 'S' then
      lc_fin_sobend := 'S';
    Else
      If lc_tit_sobend = 'E' or lc_con_sobend = 'E' then
        lc_fin_sobend := 'E';
      Else
        lc_fin_sobend := 'N';
      End If;
    End IF;
  
    ----*******CASTIGADOS*****----------
    lc_castigado := 'N';
    ld_FechaRL   := null;
    --Estado credito castigado
    begin
      select a.tp1nro1
        into ln_estaCan
        from fst198 a
       where a.tp1cod1 = 10823
         and Tp1corr1 = 3
         and Tp1corr2 = 2
         and tp1corr3 = 1;
    exception
      when no_data_found then
        ln_estaCan := null;
    end;
  
    begin
      for i in cuentas loop
        begin
          select a.pgcod,
                 a.aomod,
                 a.aosuc,
                 a.aomda,
                 a.aopap,
                 a.aocta,
                 a.aooper,
                 a.aosbop,
                 a.aotope,
                 a.aostat,
                 'S'
            into ln_aoemp,
                 ln_aomod,
                 ln_aosuc,
                 ln_aomda,
                 ln_aopap,
                 ln_aocta,
                 ln_aooper,
                 ln_aosbop,
                 ln_aotope,
                 ln_aostat,
                 lc_castigado
            from fsd010 a
           where a.pgcod = 1
             and a.aocta = i.ctnro
             and (a.aomod in (select modulo from fst111 b where dscod = 50) or
                 aomod = 117)
             and a.aomod not in (33, 108, 120, 142, 200, 144, 29)
             and a.aofval <= pd_fecpro
             and aostat = ln_estaCan
             and rownum = 1;
        exception
          when no_data_found then
            ln_aoemp     := null;
            ln_aomod     := null;
            ln_aosuc     := null;
            ln_aomda     := null;
            ln_aopap     := null;
            ln_aocta     := null;
            ln_aooper    := null;
            ln_aosbop    := null;
            ln_aotope    := null;
            ln_aostat    := null;
            lc_castigado := 'N';
          
        end;
      
        if lc_castigado = 'S' then
          begin
            select a.r1mod,
                   a.r1suc,
                   a.r1mda,
                   a.r1pap,
                   a.r1cta,
                   a.r1oper,
                   a.r1sbop,
                   a.r1tope
              into ln_r1mod,
                   ln_r1suc,
                   ln_r1mda,
                   ln_r1pap,
                   ln_r1cta,
                   ln_r1oper,
                   ln_r1sbop,
                   ln_r1tope
              from fsr011 a
             where a.r2cod = ln_aoemp
               and a.r2mod = ln_aomod
               and a.r2suc = ln_aosuc
               and a.r2mda = ln_aomda
               and a.r2pap = ln_aopap
               and a.r2cta = ln_aocta
               and a.r2oper = ln_aooper
               and a.r2sbop = ln_aosbop
               and a.r2tope = ln_aotope
               and a.relcod = 52;
          exception
            when no_data_found then
              ln_r1mod  := null;
              ln_r1suc  := null;
              ln_r1mda  := null;
              ln_r1pap  := null;
              ln_r1cta  := null;
              ln_r1oper := null;
              ln_r1sbop := null;
              ln_r1tope := null;
          end;
        end if;
      
        if ln_r1oper is null then
          ln_r1mod  := ln_aomod;
          ln_r1suc  := ln_aosuc;
          ln_r1mda  := ln_aomda;
          ln_r1pap  := ln_aopap;
          ln_r1cta  := ln_aocta;
          ln_r1oper := ln_aooper;
          ln_r1sbop := ln_aosbop;
          ln_r1tope := ln_aotope;
        end if;
        ln_evento := 1100;
        while ln_evento <= 1101 loop
          begin
            select max(SNG410FecG)
              into ld_fecrec
              from sng410 a
             Where SNG400Cod = 1
               and SNG400Evto = ln_evento
               and SNG410Mod = ln_r1mod
               and SNG410Top = ln_r1tope
               and SNG410Cta = ln_r1cta
               and SNG410Suc = ln_r1suc
               and SNG410Mda = ln_r1mda
               and SNG410Pap = ln_r1pap
               and SNG410Op = ln_r1oper
               and SNG410Sbop = ln_r1sbop
               and SNG410Its <> 999;
          exception
            when no_data_found then
              ld_fecrec := null;
          end;
        
          ln_evento := ln_evento + 1;
        end loop;
        If ld_fecrec > ld_FechaRL then
          ld_FechaRL := ld_fecrec;
        End If;
      
      end loop;
    
      if lc_castigado = 'N' then
        begin
          select 'S'
            into lc_castigado
            from jaqy164 a
           where a.jaqy164pais = pn_pai
             and a.jaqy164tdoc = pn_tdo
             and a.jaqy164ndoc = pc_ndo
             and rownum = 1;
        exception
          when no_data_found then
            lc_castigado := 'N';
        end;
      end if;
      --Validacion si ha tenido créditos después
      if lc_castigado = 'S' then
        for j in cuentas loop
          if ld_FechaRL is not null then
            begin
              select 'N'
                into lc_castigado
                from fsd010 a
               where a.pgcod = 1
                 and a.aocta = j.ctnro
                 and (a.aomod in
                     (select modulo from fst111 where dscod = 50) or
                     aomod = 117)
                 and a.aomod not in (33, 108, 120, 142, 200, 144, 29)
                 and a.aofval <= pd_fecpro
                 and aofval > ld_FechaRL
                 and rownum = 1;
            exception
              when no_data_found then
                lc_castigado := 'S';
            end;
          
          else
          
            begin
              select 'N'
                into lc_castigado
                from fsd010 a
               where a.pgcod = 1
                 and a.aocta = j.ctnro
                 and (a.aomod in
                     (select modulo from fst111 where dscod = 50) or
                     aomod = 117)
                 and a.aomod not in (33, 108, 120, 142, 200, 144, 29)
                 and a.aofval <= pd_fecpro
                 and aofval >= to_date('01/07/2013', 'dd/mm/yyyy')
                 and rownum = 1;
            exception
              when no_data_found then
                lc_castigado := 'S';
            end;
          
          end if;
          If lc_castigado = 'N' then
            Exit;
          End If;
        end loop;
      end if;
    
    end;
  
    --********ANTIGUEDAD RCC********---------
    ln_CntAntRcc := 0;
    ln_ic        := 0;
  
    --limite antiguedad rcc
    begin
      select tp1nro1
        into ln_lim
        from fst198
       where Tp1cod1 = 10854
         and Tp1corr1 = 2
         and Tp1corr2 = 1
         and tp1corr3 = 2;
    exception
      when no_data_found then
        ln_lim := null;
    end;
    --fecha rcc
    begin
      select to_date(tpnro, 'dd/mm/yyyy')
        into ld_fecantrcc
        from fst098
       where pgcod = 1
         and tpcod = 7647
         and tpcorr = 12;
    exception
      when no_data_found then
        ld_fecantrcc := null;
    end;
  
    while ln_ic <= ln_lim loop
      case
        when lc_tiper = 'F' then
          begin
            select 'S'
              into lc_flgEx
              from CLDRCCI
             Where D_FECPRE = ld_fecantrcc
               and C_TDOCID = DocSbsTit
               and C_DOCIDE = trim(pc_ndo)
               and rownum = 1;
          exception
            when no_data_found then
              lc_flgEx := 'N';
          end;
          if lc_flgEx = 'S' then
            ln_CntAntRcc := ln_CntAntRcc + 1;
          end if;
        when lc_tiper = 'J' then
          begin
            select 'S'
              into lc_flgEx
              from CLDRCCI
             Where D_FECPRE = ld_fecantrcc
               and C_TDOCTR = DocSbsTit
               and C_DOCTRI = trim(pc_ndo)
               and rownum = 1;
          exception
            when no_data_found then
              lc_flgEx := 'N';
          end;
          if lc_flgEx = 'S' then
            ln_CntAntRcc := ln_CntAntRcc + 1;
          end if;
        else
          null;
      end case;
      ld_fecantrcc := last_day(add_months(ld_fecantrcc, -1));
      ln_ic        := ln_ic + 1;
    
    end loop;
  
  end Sp_cr_Resolutores;

  Procedure Sp_Resolutores_NS(pn_pai           in number,
                              pn_tdo           in number,
                              pc_ndo           in char,
                              pd_fecpro        in date,
                              ln_histCred      out number,
                              ln_promAtr       out number,
                              ln_segcod        out number,
                              lc_refinan       out char,
                              lc_tipHN         out char,
                              pn_cal           out number,
                              c_TipHist        out char, --mod@abr20170127
                              c_sdoTit         out char, --mod@abr 20181123
                              c_sdoCyg         out char, --mod@abr 20181123
                              n_segori         out number, --mod@abr 20181123
                              lc_premium_unico out char, --mod@abr 20180110
                              lc_premium       out char, --mod@abr 20180110
                              lc_preferencialA out char, --mod@abr 20180110
                              lc_preferencialb out char, --mod@abr 20180110
                              lc_preferencialC out char, --mod@abr 20180110
                              lc_Forjador      out char, --mod@abr 20180110
                              lc_Emprendedor   out char, --mod@abr 20180110
                              lc_PrefExclusivo out char, --mod@abr 20180110
                              lc_PreferenteA   out char, --mod@abr 20180110
                              lc_PreferenteB   out char, --mod@abr 20180110
                              lc_Recurrente    out char, --mod@abr 20180110
                              lc_Nuevo         out char --mod@abr 20180110
                              ) is
  
    ln_hist     number(5);
    ln_estado   number(2);
    ld_fect     date;
    lc_existe   char(1);
    ld_fecrel   date;
    ld_fecvac   date;
    ld_fectmp   date;
    ln_contador number(5);
  
    DocSbs    number(10);
    DocSbsTit char(1);
  
    DocSbs_Cyg number(10);
    DocSbsCyg  char(1);
  
    lc_tiper     char(1);
    lc_tiper_Cyg char(1);
  
    fecNum_rcc number(9);
    MesRcc     number(9);
    ln_Rpccyg  number(2);
  
    fec_rcc   date;
    ln_paiC   number(3);
    ln_tdoC   number(2);
    lc_ndoC   char(12);
    ld_fecant date;
    lc_hisAnt char(1);
  
    --pn_doc varchar2(12);
  begin
  
    --******RELACION CREDITICIA*****--------
    ld_fecvac := to_date('01010001', 'ddmmyyyy');
    lc_existe := 'N';
    ld_fectmp := to_date(to_number(to_char(to_char(add_months(pd_fecpro,
                                                              -12),
                                                   'yyyy') ||
                                           to_char(add_months(pd_fecpro,
                                                              -12),
                                                   'mm') || '01')),
                         'yyyymmdd');
    --verifica fecha de proceso de relacion crediticia
    begin
      select to_date(tp1nro1, 'ddmmyyyy')
        into ld_fecrel
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10823
         and a.tp1corr1 = 8;
    exception
      when no_data_found then
        ld_fecrel := null;
    end;
    --verifica si existe en la tabla de relacion crediticia
  
    begin
      select a.jaqz074his, a.jaqz074est, a.jaqz074fec, 'S'
        into ln_hist, ln_estado, ld_fect, lc_existe
        from jaqz074 a
       where a.jaqz074pai = pn_pai
         and a.jaqz074tdo = pn_tdo
         and a.jaqz074ndo = pc_ndo
         and a.jaqz074fep = ld_fecrel;
    exception
      when no_data_found then
        ln_hist   := null;
        ln_estado := null;
        ld_fect   := null;
        lc_existe := 'N';
      
    end;
  
    if lc_existe = 'S' then
      if ln_estado = 99 then
        if ld_fect = ld_fecvac or ld_fect >= ld_fectmp then
          ln_histCred := ln_hist;
        else
          pq_cr_relcrediticia.sp_cr_recalcula(pn_pai,
                                              pn_tdo,
                                              pc_ndo,
                                              pd_fecpro,
                                              ln_histCred);
        
        end if;
      else
        ln_histCred := ln_hist + 1;
      end if;
    else
      ln_histCred := 0;
    end if;
  
    ---*******DIAS DE ATRASO******------
    ln_promAtr := 0;
    pq_cr_relcrediticia.sp_diaatraso_linea(pn_pai,
                                           pn_tdo,
                                           pc_ndo,
                                           pd_fecpro,
                                           ln_promAtr);
  
    --********SEGMENTO**********------
  
    begin
      select b.segcod
        into ln_segcod
        from sngc60 a, sngc07 b
       where a.sngc60pais = pn_pai
         and a.sngc60tdoc = pn_tdo
         and a.sngc60ndoc = pc_ndo
         and a.sngc60ocup = sngc07cod
         and rownum = 1;
    exception
      when no_data_found then
        ln_segcod := null;
    end;
  
    --******REFINANCIADO*******------
    begin
      select 'S'
        into lc_refinan
        from fsr008 a, fsd010 b
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo
         and b.pgcod = 1
         and b.aocta = a.ctnro
         and b.aostat in (61, 33, 34)
         and rownum = 1;
    exception
      when no_data_found then
        lc_refinan := 'N';
    end;
  
    --******HISTORIAL NUEVO RECURRENTE*****-----
    --mod 20160706
    ld_fecant := last_day(add_months(pd_Fecpro, -1));
  
    begin
      select a.jaqy349his
        into lc_hisAnt
        from jaqy349 a
       where a.jaqy349pai = pn_pai
         and a.jaqy349tdo = pn_tdo
         and a.jaqy349ndo = pc_ndo
         and a.jaqy349fec = ld_fecant;
    Exception
      when no_data_found then
        lc_hisAnt := null;
    end;
  
    if lc_hisAnt = 'A' then
      lc_tipHN := 'A';
    else
      pq_cr_relcrediticia.Sp_RelCredi_NR(pn_pai,
                                         pn_tdo,
                                         pc_ndo,
                                         pd_fecpro,
                                         ln_contador);
      if ln_contador > 18 then
        lc_tipHN := 'A';
      else
        if ln_contador <= 18 and ln_contador >= 6 then
          lc_tipHN := 'B';
        else
          if ln_contador < 6 then
            lc_tipHN := 'C';
          end if;
        end if;
      end if;
    end if;
    --fin mod 20160706
  
    --*******CALIFICACION RCC 2 ****--------------
    --Guia equivalencia tipo de documento
    begin
      select a.tp1corr3
        into DocSbs
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11111
         and a.tp1corr1 = 1
         and a.tp1corr2 = 3
         and tp1nro1 = pn_tdo;
    exception
      when no_data_found then
        DocSbs := null;
    end;
    DocSbsTit := Trim(to_char(DocSbs));
  
    --fecha RCC
    begin
      select tpnro
        into fecNum_rcc
        from fst098
       where pgcod = 1
         and tpcod = 7647
         and tpcorr = 12;
    exception
      when no_data_found then
        fecNum_rcc := null;
    end;
    fec_rcc := to_date(fecNum_rcc, 'dd/mm/yyyy');
    --Meses a evaluar RCC
    begin
      select tpnro
        into MesRcc
        from fst098
       where pgcod = 1
         and tpcod = 7702
         and tpcorr = 13;
    exception
      when no_data_found then
        MesRcc := null;
    end;
    --vinculo conyugue
    begin
      select a.tp1corr3
        into ln_Rpccyg
        from fst198 a
       where a.tp1cod1 = 10823
         and Tp1corr1 = 3
         and Tp1corr2 = 1;
    exception
      when no_data_found then
        ln_Rpccyg := null;
    end;
    --tipo de persona
    begin
      select a.petipo
        into lc_tiper
        from fsd001 a
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo;
    exception
      when no_data_found then
        lc_tiper := null;
    end;
    pn_cal := 100.00;
  
    pn_cal := pq_cr_segm_mens_nuev.Fn_calificacion_RCC(DocSbsTit,
                                                       pc_ndo,
                                                       fec_rcc,
                                                       MesRcc,
                                                       lc_tiper);
  
    --evalua conyugue si la calificacion es normal para el titular
  
    if pn_cal = 100.00 then
      begin
        select a.rppais, a.rptdoc, a.rpndoc
          into ln_paiC, ln_tdoC, lc_ndoC
          from fsr002 a
         where a.pepais = pn_pai
           and a.petdoc = pn_tdo
           and a.pendoc = pc_ndo
           and a.rpccyg = ln_Rpccyg
           and rownum = 1;
      exception
        when no_data_found then
          ln_paiC := null;
          ln_tdoC := null;
          lc_ndoC := null;
      end;
    
      --Guia equivalencia tipo de documento
      begin
        select a.tp1corr3
          into DocSbs_Cyg
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 11111
           and a.tp1corr1 = 1
           and a.tp1corr2 = 3
           and tp1nro1 = ln_tdoC;
      exception
        when no_data_found then
          DocSbs_Cyg := null;
      end;
      DocSbsCyg := Trim(to_char(DocSbs_Cyg));
    
      --tipo de persona
      begin
        select a.petipo
          into lc_tiper_Cyg
          from fsd001 a
         where a.pepais = ln_paiC
           and a.petdoc = ln_tdoC
           and a.pendoc = lc_ndoC;
      exception
        when no_data_found then
          lc_tiper_Cyg := null;
      end;
    
      If lc_ndoC is not null then
      
        pn_cal := pq_cr_segm_mens_nuev.Fn_calificacion_RCC(DocSbsCyg,
                                                           lc_ndoC,
                                                           fec_rcc,
                                                           MesRcc,
                                                           lc_tiper_Cyg);
      
      end if;
    end if;
  
    --Mod @abr 20170127
  
    begin
      pq_cr_relcrediticia.Sp_Obtiene_HistPyme(pn_pai,
                                              pn_tdo,
                                              pc_ndo,
                                              c_TipHist);
    end;
    -- fin Mod @abr 20170127     
  
    --Mod @abr 20181123
  
    begin
      pq_cr_segmentacion_variable.sp_cr_saldo3(pn_pai    => pn_pai,
                                               pn_tdo    => pn_tdo,
                                               pc_ndo    => pc_ndo,
                                               pc_flgTit => c_sdoTit,
                                               pc_flgCyg => c_sdoCyg);
    end;
    -- fin Mod @abr 20181123   
  
    --Mod @abr 20181123
  
    begin
      pq_cr_campanianav2018.sp_cr_resolutor4_so(pn_pai => pn_pai,
                                                pn_tdo => pn_tdo,
                                                pc_ndo => pc_ndo,
                                                pn_seg => n_segori);
    end;
    -- fin Mod @abr 20181123   
  
    --Mod@abr20180110
    begin
      pQ_CR_SEGMENTACION_PERMAN.Sp_cr_variables(pn_pai,
                                                pn_tdo,
                                                pc_ndo,
                                                lc_premium_unico,
                                                lc_premium,
                                                lc_preferencialA,
                                                lc_preferencialb,
                                                lc_preferencialC,
                                                lc_Forjador,
                                                lc_Emprendedor,
                                                lc_PrefExclusivo,
                                                lc_PreferenteA,
                                                lc_PreferenteB,
                                                lc_Recurrente,
                                                lc_Nuevo);
    
    end;
    --Fin Mod@abr20180110 
  
  end Sp_Resolutores_NS;

end PQ_APL_SEGMENTACION;
/

