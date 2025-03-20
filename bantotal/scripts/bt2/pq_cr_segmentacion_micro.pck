create or replace package PQ_CR_SEGMENTACION_MICRO is

  -- Author  : ABERNEDO
  -- Created : 16/03/2016 01:09:55 p.m.
  -- Purpose : 

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
  Procedure Sp_Resolutores_NS(pn_pai      in number,
                              pn_tdo      in number,
                              pc_ndo      in char,
                              pd_fecpro   in date,
                              ln_histCred out number,
                              ln_promAtr  out number,
                              ln_segcod   out number,
                              lc_refinan  out char,
                              lc_tipHN    out char,
                              pn_cal      out number,
                              c_TipHist   out char --mod@abr20170127
                              );
  procedure sp_cr_evalua_clientes_1_NS(P_N_REGLA   IN NUMBER,
                                       P_A_NOMVAR  IN PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar,
                                       P_A_VALVAR  IN PQ_CR_SEGMENTACION_CLIENTES.tp_valvar,
                                       P_N_VAR     IN number,
                                       P_A_REGLAS  in PQ_CR_SEGMENTACION_CLIENTES.tb_reglas,
                                       P_N_REG     in number,
                                       p_c_retorno out varchar2);

  Function Fn_cant_instit(TipDocSbs in char,
                          pc_ndo    in char,
                          pd_fecRcc in date,
                          lc_tiper  in char) return number;

end PQ_CR_SEGMENTACION_MICRO;
/

create or replace package body PQ_CR_SEGMENTACION_MICRO is

  Procedure Sp_Carga_data(pd_fecpro in date,
                          pn_pai    in number,
                          pn_tdo    in number,
                          pc_doc    in char,
                          pc_usr    in varchar2) is
  
    pn_cal        number(5, 2);
    ln_CntInsRep  number(10);
    lc_fin_sobend char(1);
    lc_castigado  char(1);
    ln_histCred   number(5);
    ln_promAtr    number(18, 2);
    ln_segcod     number(2);
    lc_refinan    char(1);
    lc_tipHN      char(1);
    pn_cal2       number(5, 2);
    ln_CntAntRcc  number(10);
    ln_cal        number(5);
    hist_pyme     char(1); --mod@abr20170127
  
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
  
    lc_lista char(1);
    lc_hora  char(8);
  
  begin
  
    Delete from JAQZ656 a
     where a.JAQZ656pais = pn_pai
       and a.JAQZ656tdoc = pn_tdo
       and a.JAQZ656ndoc = pc_doc
       and a.JAQZ656usr = pc_usr;
    commit;
  
    lc_lista := 'N';
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS=". "';
  
    PQ_CR_SEGMENTACION_MICRO.Sp_cr_Resolutores(pn_pai,
                                               pn_tdo,
                                               pc_doc,
                                               pd_fecpro,
                                               pn_cal,
                                               ln_CntInsRep,
                                               lc_fin_sobend,
                                               lc_castigado,
                                               ln_CntAntRcc);
    PQ_CR_SEGMENTACION_MICRO.Sp_Resolutores_NS(pn_pai,
                                               pn_tdo,
                                               pc_doc,
                                               pd_fecpro,
                                               ln_histCred,
                                               ln_promAtr,
                                               ln_segcod,
                                               lc_refinan,
                                               lc_tipHN,
                                               pn_cal2,
                                               hist_pyme --mod@abr20170127
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
    lc_JAQZ082VAR3  := 'CANT_INSTREP' || '=' || trim(to_char(ln_CntInsRep));
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
    lc_JAQZ082VAR13 := 'HIST_PYME' || '=' || trim(hist_pyme); --mod@abr20170127
  
    ln_cal  := 0;
    lc_hora := TO_CHAR(SYSDATE, 'hh:mm:ss');
  
    insert into JAQZ656
      (JAQZ656FECH,
       JAQZ656PAIS,
       JAQZ656TDOC,
       JAQZ656NDOC,
       JAQZ656HORA,
       JAQZ083CCAL,
       JAQZ656VAR1,
       JAQZ656VAR2,
       JAQZ656VAR3,
       JAQZ656VAR4,
       JAQZ656VAR5,
       JAQZ656VAR6,
       JAQZ656VAR7,
       JAQZ656VAR8,
       JAQZ656VAR9,
       JAQZ656VAR10,
       JAQZ656VAR11,
       JAQZ656VAR12,
       JAQZ656VAR13, --mod@abr20170127
       JAQZ656USR)
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
       lc_JAQZ082VAR13,
       pc_usr); --mod@abr20170127
  
    commit;
  
    PQ_CR_SEGMENTACION_MICRO.sp_cr_NS_LINEA_APL(pd_fecpro,
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
       JAQZ656pais, JAQZ656tdoc, JAQZ656ndoc
        from JAQZ656 l
       where l.JAQZ656pais = PN_PAIS
         and l.JAQZ656tdoc = PN_TDOC
         and l.JAQZ656ndoc = PC_NDOC
         and l.JAQZ656usr = PC_USR;
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
       where t.RNG49Cod in (1623)
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
    JAQZ658CCAL   JAQZ658.JAQZ658ccal%type;
    --l_jaqy066pano  jaqy066.jaqy066pano%type;
    --l_jaqy066pmes  jaqy066.jaqy066pmes%type;
    l_JAQZ657paic  JAQZ657.JAQZ657paic%type;
    l_JAQZ657tdoc  JAQZ657.JAQZ657tdoc%type;
    l_JAQZ657tndoc JAQZ657.JAQZ657tndoc%type;
    l_JAQZ657calf  JAQZ657.JAQZ657calf%type;
    --l_jaqy066fecp  jaqy066.jaqy066fecp%type;
    --l_jaqy066horp  jaqy066.jaqy066horp%type;
    l_JAQZ657tcal JAQZ657.JAQZ657tcal%type;
  
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
  
    delete from JAQZ657 a
     where a.JAQZ657paic = PN_PAIS
       and a.JAQZ657tdoc = PN_TDOC
       and a.JAQZ657tndoc = PC_NDOC
       and a.JAQZ657usr = PC_USR;
    commit;
  
    Regla := 1623;
  
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
        PQ_CR_SEGMENTACION_MICRO.sp_cr_cargar_variables_NS_APL(P_D_FECPRO => P_D_FECPRO,
                                                               P_N_PAIS   => la_JAQZ082pais(c),
                                                               P_N_TDOC   => la_JAQZ082tdoc(c),
                                                               P_C_NDOC   => la_JAQZ082ndoc(c),
                                                               P_C_USR    => PC_USR,
                                                               p_a_nomvar => la_nomvar,
                                                               p_a_valvar => la_valvar,
                                                               p_n_var    => ln_var);
        SegmentoRegla := null;
        PQ_CR_SEGMENTACION_MICRO.sp_cr_evalua_clientes_1_NS(P_N_REGLA   => Regla,
                                                            P_A_NOMVAR  => la_nomvar,
                                                            P_A_VALVAR  => la_valvar,
                                                            P_N_VAR     => ln_var,
                                                            P_A_REGLAS  => la_reglas,
                                                            P_N_REG     => ln_reg,
                                                            p_c_retorno => SegmentoRegla);
      
        Tp1cod      := 1;
        Tp1cod1     := 10823;
        Tp1corr1    := 300;
        Tp1corr2    := 1; -- Equivalencia resultado reglas - calificacion
        Tp1desc     := Trim(SegmentoRegla);
        JAQZ658CCAL := null;
      
        For g in c_guia(Tp1cod, Tp1cod1, Tp1corr1, Tp1corr2) loop
          If g.tp1desc = Tp1desc Then
            JAQZ658CCAL := g.tp1nro1;
          End If;
        End Loop;
      
        If JAQZ658CCAL is not null then
          -- Califica
          l_JAQZ657paic  := la_JAQZ082pais(c);
          l_JAQZ657tdoc  := la_JAQZ082tdoc(c);
          l_JAQZ657tndoc := la_JAQZ082ndoc(c);
          l_JAQZ657calf  := JAQZ658CCAL;
          --l_jaqz086horp := to_char(sysdate(),'HH24:MI:SS');
          l_JAQZ657tcal := 'P';
        
          insert into JAQZ657
            (JAQZ657PAIC,
             JAQZ657TDOC,
             JAQZ657TNDOC,
             JAQZ657CALF,
             JAQZ657TCAL,
             JAQZ657usr)
          values
            (l_JAQZ657paic,
             l_JAQZ657tdoc,
             l_JAQZ657tndoc,
             l_JAQZ657calf,
             l_JAQZ657tcal,
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
      select JAQZ656fech,
             JAQZ656pais,
             JAQZ656tdoc,
             JAQZ656ndoc,
             JAQZ656var1,
             JAQZ656var2,
             JAQZ656var3,
             JAQZ656var4,
             JAQZ656var5,
             JAQZ656var6,
             JAQZ656var7,
             JAQZ656var8,
             JAQZ656var9,
             JAQZ656var10,
             JAQZ656var11,
             JAQZ656var12,
             JAQZ656var13,
             JAQZ656var14,
             JAQZ656var15,
             JAQZ656var16,
             JAQZ656var17,
             JAQZ656var18,
             JAQZ656var19,
             JAQZ656var20,
             JAQZ656var21,
             JAQZ656var22,
             JAQZ656var23,
             JAQZ656var24,
             JAQZ656var25,
             JAQZ656var26,
             JAQZ656var27,
             JAQZ656var28,
             JAQZ656var29,
             JAQZ656var30,
             JAQZ656var31,
             JAQZ656var32,
             JAQZ656var33,
             JAQZ656var34,
             JAQZ656var35,
             JAQZ656var36,
             JAQZ656var37,
             JAQZ656var38,
             JAQZ656var39,
             JAQZ656var40
        from JAQZ656
       where JAQZ656fech = P_D_FECPRO
         and JAQZ656pais = P_N_PAIS
         and JAQZ656tdoc = P_N_TDOC
         and JAQZ656ndoc = P_C_NDOC
         and JAQZ656usr = P_C_USR;
    ln_tmpnum number(3);
  
  begin
  
    for cli in c_cliente loop
      -- Cargando Variables Resuletas
      if trim(cli.JAQZ656var1) is not null then
        p_n_var := 1;
        ln_tmpnum := instr(cli.JAQZ656var1, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var1, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var1, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var2) is not null then
        p_n_var := 2;
        ln_tmpnum := instr(cli.JAQZ656var2, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var2, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var2, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var3) is not null then
        p_n_var := 3;
        ln_tmpnum := instr(cli.JAQZ656var3, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var3, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var3, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var4) is not null then
        p_n_var := 4;
        ln_tmpnum := instr(cli.JAQZ656var4, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var4, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var4, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var5) is not null then
        p_n_var := 5;
        ln_tmpnum := instr(cli.JAQZ656var5, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var5, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var5, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var6) is not null then
        p_n_var := 6;
        ln_tmpnum := instr(cli.JAQZ656var6, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var6, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var6, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var7) is not null then
        p_n_var := 7;
        ln_tmpnum := instr(cli.JAQZ656var7, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var7, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var7, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var8) is not null then
        p_n_var := 8;
        ln_tmpnum := instr(cli.JAQZ656var8, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var8, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var8, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var9) is not null then
        p_n_var := 9;
        ln_tmpnum := instr(cli.JAQZ656var9, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var9, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var9, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var10) is not null then
        p_n_var := 10;
        ln_tmpnum := instr(cli.JAQZ656var10, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var10, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var10, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var11) is not null then
        p_n_var := 11;
        ln_tmpnum := instr(cli.JAQZ656var11, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var11, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var11, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var12) is not null then
        p_n_var := 12;
        ln_tmpnum := instr(cli.JAQZ656var12, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var12, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var12, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var13) is not null then
        p_n_var := 13;
        ln_tmpnum := instr(cli.JAQZ656var13, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var13, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var13, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var14) is not null then
        p_n_var := 14;
        ln_tmpnum := instr(cli.JAQZ656var14, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var14, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var14, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var15) is not null then
        p_n_var := 15;
        ln_tmpnum := instr(cli.JAQZ656var15, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var15, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var15, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var16) is not null then
        p_n_var := 16;
        ln_tmpnum := instr(cli.JAQZ656var16, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var16, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var16, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var17) is not null then
        p_n_var := 17;
        ln_tmpnum := instr(cli.JAQZ656var17, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var17, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var17, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var18) is not null then
        p_n_var := 18;
        ln_tmpnum := instr(cli.JAQZ656var18, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var18, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var18, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var19) is not null then
        p_n_var := 19;
        ln_tmpnum := instr(cli.JAQZ656var19, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var19, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var19, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var20) is not null then
        p_n_var := 20;
        ln_tmpnum := instr(cli.JAQZ656var20, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var20, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var20, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var21) is not null then
        p_n_var := 21;
        ln_tmpnum := instr(cli.JAQZ656var21, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var21, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var21, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var22) is not null then
        p_n_var := 22;
        ln_tmpnum := instr(cli.JAQZ656var22, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var22, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var22, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var23) is not null then
        p_n_var := 23;
        ln_tmpnum := instr(cli.JAQZ656var23, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var23, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var23, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var24) is not null then
        p_n_var := 24;
        ln_tmpnum := instr(cli.JAQZ656var24, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var24, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var24, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var25) is not null then
        p_n_var := 25;
        ln_tmpnum := instr(cli.JAQZ656var25, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var25, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var25, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var26) is not null then
        p_n_var := 26;
        ln_tmpnum := instr(cli.JAQZ656var26, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var26, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var26, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var27) is not null then
        p_n_var := 27;
        ln_tmpnum := instr(cli.JAQZ656var27, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var27, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var27, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var28) is not null then
        p_n_var := 28;
        ln_tmpnum := instr(cli.JAQZ656var28, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var28, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var28, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var29) is not null then
        p_n_var := 29;
        ln_tmpnum := instr(cli.JAQZ656var29, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var29, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var29, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var30) is not null then
        p_n_var := 30;
        ln_tmpnum := instr(cli.JAQZ656var30, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var30, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var30, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var31) is not null then
        p_n_var := 31;
        ln_tmpnum := instr(cli.JAQZ656var31, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var31, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var31, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var32) is not null then
        p_n_var := 32;
        ln_tmpnum := instr(cli.JAQZ656var32, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var32, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var32, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var33) is not null then
        p_n_var := 33;
        ln_tmpnum := instr(cli.JAQZ656var33, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var33, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var33, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var34) is not null then
        p_n_var := 34;
        ln_tmpnum := instr(cli.JAQZ656var34, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var34, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var34, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var35) is not null then
        p_n_var := 35;
        ln_tmpnum := instr(cli.JAQZ656var35, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var35, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var35, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var36) is not null then
        p_n_var := 36;
        ln_tmpnum := instr(cli.JAQZ656var36, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var36, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var36, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var37) is not null then
        p_n_var := 37;
        ln_tmpnum := instr(cli.JAQZ656var37, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var37, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var37, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var38) is not null then
        p_n_var := 38;
        ln_tmpnum := instr(cli.JAQZ656var38, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var38, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var38, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var39) is not null then
        p_n_var := 39;
        ln_tmpnum := instr(cli.JAQZ656var39, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var39, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var39, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ656var40) is not null then
        p_n_var := 40;
        ln_tmpnum := instr(cli.JAQZ656var40, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ656var40, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ656var40, ln_tmpnum + 1);
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
    ln_CntOpeRccTi number(10);
    ln_CntOpeRccCy number(10);
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
       where a.tp1cod = 1
         and a.tp1cod1 = 10823
         and a.Tp1corr1 = 3
         and a.Tp1corr2 = 1;
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
    ln_CntOpeRccCy := 0;
    ln_CntInsRep   := 0;
  
    ln_CntOpeRccTi := pq_cr_segmentacion_micro.Fn_cant_instit(DocSbsTit,
                                                              pc_ndo,
                                                              fec_rcc,
                                                              lc_tiper);
  
    if lc_ndoC is not null then
    
      ln_CntOpeRccCy := pq_Cr_segmentacion_micro.Fn_cant_instit(DocSbsCyg,
                                                                lc_ndoC,
                                                                fec_rcc,
                                                                lc_tiper_Cyg);
    
    end if;
  
    ln_CntInsRep := ln_CntOpeRccTi + ln_CntOpeRccCy;
  
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
       where a.tp1cod = 1
         and a.tp1cod1 = 10823
         and a.Tp1corr1 = 3
         and a.Tp1corr2 = 2
         and a.tp1corr3 = 1;
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
       where tp1cod = 1
         and Tp1cod1 = 10854
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

  Procedure Sp_Resolutores_NS(pn_pai      in number,
                              pn_tdo      in number,
                              pc_ndo      in char,
                              pd_fecpro   in date,
                              ln_histCred out number,
                              ln_promAtr  out number,
                              ln_segcod   out number,
                              lc_refinan  out char,
                              lc_tipHN    out char,
                              pn_cal      out number,
                              c_TipHist   out char --mod@abr20170127
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
       where a.tp1cod = 1
         and a.tp1cod1 = 10823
         and a.Tp1corr1 = 3
         and a.Tp1corr2 = 1;
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
  end Sp_Resolutores_NS;

  procedure sp_cr_evalua_clientes_1_NS(P_N_REGLA   IN NUMBER,
                                       P_A_NOMVAR  IN PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar,
                                       P_A_VALVAR  IN PQ_CR_SEGMENTACION_CLIENTES.tp_valvar,
                                       P_N_VAR     IN number,
                                       P_A_REGLAS  in PQ_CR_SEGMENTACION_CLIENTES.tb_reglas,
                                       P_N_REG     in number,
                                       p_c_retorno out varchar2) IS
  
    cursor c_lista(p_RNG49Cod number, p_RNG50Grp number, p_RNG51COD number) is
      select RNG49Cod, RNG50Grp, RNG51COD, RNG67COR, RNG67VAL
        from FRNG67
       where RNG49Cod = p_RNG49Cod
         and RNG50Grp = p_RNG50Grp
         and RNG51COD = p_RNG51COD
       order by RNG67COR;
  
    ExisteGrupo   char(1) := null;
    ResReglaGrupo char(1) := null;
    ResReglaLista char(1) := null;
    Regla         frng51.rng49cod%type;
    --Regla2 frng51.rng49cod%type;
    l_RNG50Grp     frng51.rng50grp%type;
    l_RNG50Ret     frng50.rng50ret%type;
    la_nomvar      PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar;
    la_valvar      PQ_CR_SEGMENTACION_CLIENTES.tp_valvar;
    ln_var         number(3) := 0;
    lc_valResuelto varchar2(30);
    i              number(5);
    ln_NumTmp1     number(10, 2);
    ln_NumTmp2     number(10, 2);
    --l_RNG68Tda frng68.rng68tda%type;
    --SegmentoRegla2 frng51.rng51val%type;
    l_RNG51Val   varchar2(30);
    l_RNG67val   varchar2(30);
    l_RNG51OPE   varchar2(2);
    la_reglas    pq_cr_segmentacion_clientes.tb_reglas;
    ln_reg       number(5);
    ln_ind       number(5);
    ln_grupoExcp number(4); --mod@abr 20180227
  
  BEGIN
  
    Regla     := nvl(P_N_REGLA, 0);
    la_nomvar := p_a_nomvar;
    la_valvar := p_a_valvar;
    ln_var    := nvl(p_n_var, 0);
    la_reglas := P_A_REGLAS;
    ln_reg    := nvl(P_N_REG, 0);
  
    --mod@abr 20180227
    begin
      select tp1nro1
        into ln_grupoExcp
        from fst198
       where Tp1cod = 1
         and Tp1cod1 = 10823
         and Tp1corr1 = 40
         and tp1corr2 = 1
         and tp1corr3 = 1;
    exception
      when others then
        null;
    end;
    --fin mod@20180227
    For reg in 1 .. ln_reg loop
      If la_reglas(reg).RNG49COD = Regla then
        l_RNG50Ret := la_reglas(reg).RNG50Ret;
        l_RNG50Grp := la_reglas(reg).RNG50GRP;
        if l_RNG50Grp <> ln_grupoExcp then
          --mod@br 20180227
          ExisteGrupo := 'S';
          ln_ind      := reg;
          Exit;
        end if; --mod@br 20180227
      End If;
    End loop;
  
    If ExisteGrupo = 'S' then
      --existe grupo
    
      -- Evaluando Variables
      ResReglaGrupo := 'S';
    
      WHILE la_reglas(ln_ind).RNG49COD = Regla LOOP
      
        If la_reglas(ln_ind).RNG50GRP <> l_RNG50Grp then
          --evaluar cambio de grupo
          --Msg('Diferente grupo')
          If ResReglaGrupo = 'N' And la_reglas(ln_ind).RNG50GRP = 999 then
            --Retorno Default (Condición ELSE)
            --Msg('Retorno Default (Condición ELSE)')
            p_c_retorno := la_reglas(ln_ind).RNG50Ret;
            --ResReglaGrupo := 'S'; 
            --Msg(p_c_retorno)                         
            Exit;
          End If;
        
          If ResReglaGrupo = 'S' then
            --se cumple la regla para el grupo anterior
            --Msg('grupo cumplido')
            p_c_retorno := l_RNG50Ret;
            --ResReglaGrupo := 'S'; 
            --Msg(p_c_retorno)
            Exit;
          Else
            --evaluar el siguiente grupo de la regla
            --Msg('cambio de grupo')
            l_RNG50Grp := la_reglas(ln_ind).RNG50GRP;
            l_RNG50Ret := la_reglas(ln_ind).RNG50Ret;
            --Msg('grupo : '+Str(RNG50Grp))
            ResReglaGrupo := 'S';
            --Do 'Limpiar VExpresion'
          End If;
        End If;
      
        -- Encontrar valor resuelto de atributo
        lc_valResuelto := '0';
        For i in 1 .. ln_var loop
          If la_nomvar(i) = trim(la_reglas(ln_ind).RNG68ATR) then
            lc_valResuelto := trim(la_valvar(i));
            Exit;
          End If;
        End loop;
      
        -- Resolver Regla anidada Nivel 2
        --                If la_reglas(ln_ind).RNG68ATR in ('EXP1612','EXP1613','EXP1614','EXP1617') then
        -- If la_reglas(ln_ind).RNG68ATR = 'EXP1621' then
      
        --  Regla2 := to_number(substr(la_reglas(ln_ind).RNG68ATR,4,4));
        --Msg('rutina regla anidada ' + Str(&Regla2))
        --  SegmentoRegla2 := null;
        --  PQ_CR_SEGMENTACION_CLIENTES.sp_cr_evalua_clientes_2_NS( P_N_REGLA => Regla2,
        --                                                       P_A_NOMVAR => la_nomvar,
        --                                                       P_A_VALVAR => la_valvar, 
        --                                                       P_N_VAR => ln_var,
        --                                                       P_A_REGLAS => la_reglas,
        --                                                       P_N_REG => ln_reg,
        --                                                       p_c_retorno => SegmentoRegla2);
        -- lc_valResuelto := Trim(SegmentoRegla2);
      
        --End If;
      
        -- Evaluacion de condiciones
        l_RNG51Val := nvl(trim(la_reglas(ln_ind).RNG51VAL), '0');
      
        if lc_valResuelto = '100' then
          lc_valResuelto := '100.00';
        end if;
        if l_RNG51Val = '100' then
          l_RNG51Val := '100.00';
        end if;
      
        l_RNG51OPE := trim(la_reglas(ln_ind).RNG51OPE);
        Case l_RNG51OPE
          When '>=' then
            --Msg('es mayor igual que ' + l_RNG51Val)
            --Msg(ValResuelto)
            ln_NumTmp1 := to_number(lc_valResuelto);
            ln_NumTmp2 := to_number(l_RNG51Val);
            If ln_NumTmp1 < ln_NumTmp2 then
              --Msg('no cumple ' + reg.RNG68ATR)
              ResReglaGrupo := 'N';
            End If;
          
          When '>' then
            --Msg('es mayor que ' + l_RNG51Val)
            --Msg(lc_lc_valResuelto)
            ln_NumTmp1 := to_number(lc_valResuelto);
            ln_NumTmp2 := to_number(l_RNG51Val);
            If ln_NumTmp1 <= ln_NumTmp2 then
              --Msg('no cumple ' + reg.RNG68ATR)
              ResReglaGrupo := 'N';
            End If;
          
          When '<=' then
            --Msg('es menor igual que ' + l_RNG51Val)
            --Msg(lc_valResuelto)
            ln_NumTmp1 := to_number(lc_valResuelto);
            ln_NumTmp2 := to_number(l_RNG51Val);
            If ln_NumTmp1 > ln_NumTmp2 then
              --to_number(lc_valResuelto) > to_number(l_RNG51Val)
              --Msg('no cumple ' + reg.RNG68ATR)
              ResReglaGrupo := 'N';
            End If;
          
          When '<' then
            --Msg('es menor que ' + l_RNG51Val)
            --Msg(lc_valResuelto)
            ln_NumTmp1 := to_number(lc_valResuelto);
            ln_NumTmp2 := to_number(l_RNG51Val);
            If ln_NumTmp1 >= ln_NumTmp2 then
              --to_number(lc_valResuelto) >= to_number(reg.RNG51VAL)
              --Msg('no cumple ' + reg.RNG68ATR)
              ResReglaGrupo := 'N';
            End If;
          
          When '=' then
            --Msg('es igual que ' + VeRNG51VAL(j))
            --Msg(ValResuelto)                 
            If lc_valResuelto <> l_RNG51Val then
              --Msg('no cumple ' + VeRNG68ATR(j))
              ResReglaGrupo := 'N';
            End If;
          
          When '<>' then
            --Msg('es diferente que ' + VeRNG51VAL(j))
            --Msg(ValResuelto)
          
            If lc_valResuelto = l_RNG51Val then
              --Msg('no cumple ' + VeRNG68ATR(j))
              ResReglaGrupo := 'N';
            End If;
          
          When 'EN' then
            ResReglaLista := 'N';
            -- valores de evaluacion lista
            For lis in c_lista(la_reglas (ln_ind).RNG49COD,
                               l_RNG50Grp,
                               la_reglas (ln_ind).RNG51COD) loop
              --Msg('esta EN ' + MVaLista(i, 4)) 
              l_RNG67val := trim(lis.rng67val);
              If lc_valResuelto = l_RNG67val then
                ResReglaLista := 'S';
                Exit;
              End If;
            End Loop;
            --Msg(lc_valResuelto)
            If ResReglaLista = 'N' then
              --Msg('no cumple ' + reg.RNG68ATR)
              ResReglaGrupo := 'N';
            End If;
          
          When 'NE' then
            ResReglaLista := 'N';
            For lis in c_lista(la_reglas (ln_ind).RNG49COD,
                               l_RNG50Grp,
                               la_reglas (ln_ind).RNG51COD) loop
              --Msg('NO esta EN ' + MVaLista(i, 4)) 
              l_RNG67val := trim(lis.rng67val);
              If lc_valResuelto = l_RNG67val then
                ResReglaLista := 'S';
                Exit;
              End If;
            End Loop;
            --Msg(lc_valResuelto)
            If ResReglaLista = 'S' then
              --Msg('no cumple ' + reg.RNG68ATR)
              ResReglaGrupo := 'N';
            End If;
          
          Else
            ResReglaGrupo := 'N'; --faltan variaciones de like y not like
        
        End Case;
      
        --END IF; -- regla evaluada
        ln_ind := ln_ind + 1;
      
      END LOOP; -- reglas
    
    End If; -- existe grupo
  
  END sp_cr_evalua_clientes_1_NS;

  Function Fn_cant_instit(TipDocSbs in char,
                          pc_ndo    in char,
                          pd_fecRcc in date,
                          lc_tiper  in char) return number is
  
    ln_NumEnt number(10);
    lc_CodSbs char(10);
  
    cursor entidades(lc_CodSbs in char) is
      select distinct C_CODEMP
        from CLDRCCS
       Where C_CODSBS = lc_CodSbs
         and C_CODEMP <> '00104'
         and (C_CUENTA like '14_1%' Or C_CUENTA like '14_2%' Or
             C_CUENTA like '14_3%' Or C_CUENTA like '14_4%' Or
             C_CUENTA like '14_5%' Or C_CUENTA like '14_6%' Or
             C_CUENTA like '71_1%' Or C_CUENTA like '71_2%' Or
             C_CUENTA like '71_3%' Or C_CUENTA like '71_4%' Or
             C_CUENTA like '81_302%')
         and D_FECPRE = pd_fecRcc;
  
  begin
    ln_NumEnt := 0;
    begin
      case
        when lc_tiper = 'F' then
          begin
            select C_CODSBS
              into lc_CodSbs
              from CLDRCCI
             Where D_FECPRE = pd_fecRcc
               and C_TDOCID = TipDocSbs
               and C_DOCIDE = trim(pc_ndo)
               and rownum = 1;
          exception
            when no_data_found then
              lc_CodSbs := NULL;
          end;
        when lc_tiper = 'J' then
          begin
            select C_CODSBS
              into lc_CodSbs
              from CLDRCCI
             Where D_FECPRE = pd_fecRcc
               and C_TDOCTR = TipDocSbs
               and C_DOCTRI = trim(pc_ndo)
               and rownum = 1;
          exception
            when no_data_found then
              lc_CodSbs := NULL;
          end;
        else
          begin
            select C_CODSBS
              into lc_CodSbs
              from CLDRCCI
             Where D_FECPRE = pd_fecRcc
               and C_DOCIDE = trim(pc_ndo)
               and rownum = 1;
          exception
            when no_data_found then
              lc_CodSbs := NULL;
          end;
          if lc_CodSbs is null then
            begin
              select C_CODSBS
                into lc_CodSbs
                from CLDRCCI
               Where D_FECPRE = pd_fecRcc
                 and C_DOCTRI = trim(pc_ndo)
                 and rownum = 1;
            exception
              when no_data_found then
                lc_CodSbs := NULL;
            end;
          end if;
        
      end case;
    
      begin
        for i in entidades(lc_CodSbs) loop
          ln_NumEnt := ln_NumEnt + 1;
        
        end loop;
      End;
    
    end;
    return ln_NumEnt;
  
  end Fn_cant_instit;

end PQ_CR_SEGMENTACION_MICRO;
/

