create or replace package Pq_Cr_Segmentacion_Consumo is

  type tp_nomvar is table of varchar2(30) index by binary_integer;
  type tp_valvar is table of varchar2(30) index by binary_integer;
  type tp_regla is record(
    RNG49COD FRNG51.RNG49COD%type,
    RNG50GRP FRNG51.RNG50GRP%type,
    RNG51COD FRNG51.RNG51COD%type,
    RNG68COD FRNG51.RNG68COD%type,
    RNG51OPE FRNG51.RNG51OPE%type,
    RNG51VAL FRNG51.RNG51VAL%type,
    RNG68ATR FRNG68.RNG68ATR%type,
    RNG68TDA FRNG68.RNG68TDA%type,
    RNG50Ret FRNG50.RNG50RET%type);
  type tb_reglas is table of tp_regla index by binary_integer;
  procedure sp_cr_NS_LINEA(P_D_FECPRO in date,
                           PN_PAIS    IN NUMBER,
                           PN_TDOC    IN NUMBER,
                           PC_NDOC    IN VARCHAR2,
                           PC_USR     IN VARCHAR2);
  procedure sp_cr_cargar_variables_NS(P_D_FECPRO IN DATE,
                                      P_N_PAIS   IN JAQZ661.JAQZ661PAIS%type,
                                      P_N_TDOC   IN JAQZ661.JAQZ661TDOC%type,
                                      P_C_NDOC   IN JAQZ661.JAQZ661NDOC%type,
                                      P_C_USR    IN JAQZ661.JAQZ661USR%type,
                                      p_a_nomvar out pq_cr_segmentacion_consumo.tp_nomvar,
                                      p_a_valvar out pq_cr_segmentacion_consumo.tp_valvar,
                                      p_n_var    out number);
  procedure sp_cr_evalua_clientes_1_NS(P_N_REGLA   IN NUMBER,
                                       P_A_NOMVAR  IN pq_cr_segmentacion_consumo.tp_nomvar,
                                       P_A_VALVAR  IN pq_cr_segmentacion_consumo.tp_valvar,
                                       P_N_VAR     IN number,
                                       P_A_REGLAS  in pq_cr_segmentacion_consumo.tb_reglas,
                                       P_N_REG     in number,
                                       p_c_retorno out varchar2);
  procedure sp_cr_evalua_clientes_2_NS(P_N_REGLA   IN NUMBER,
                                       P_A_NOMVAR  IN pq_Cr_segmentacion_consumo.tp_nomvar,
                                       P_A_VALVAR  IN pq_Cr_segmentacion_consumo.tp_valvar,
                                       P_N_VAR     IN number,
                                       P_A_REGLAS  in pq_Cr_segmentacion_consumo.tb_reglas,
                                       P_N_REG     in number,
                                       p_c_retorno out varchar2);

  Procedure Sp_calificacion_normal_cpp(pn_pai    in number,
                                       pn_tdo    in number,
                                       pc_ndo    in char,
                                       pd_fecpro in date,
                                       pn_cal    out number);

  Function Fn_calificacion_RCC(TipDocSbs   in char,
                               pc_ndo_FN   in char,
                               pd_fecRcc   in date,
                               MesRcc      in number,
                               lc_tiper_FN in char) return number;
  procedure sp_cuentas(ln_Pepais     in number,
                       ln_Petdoc     in number,
                       ln_Pendoc     in char,
                       Instancia     in number,
                       pd_fecpro     in date,
                       ln_captotcaja out number);
  Function Fn_garantia(pn_ins in number) return char;

end;
/

create or replace package body Pq_Cr_Segmentacion_Consumo is

  procedure sp_cr_NS_LINEA(P_D_FECPRO in date,
                           PN_PAIS    IN NUMBER,
                           PN_TDOC    IN NUMBER,
                           PC_NDOC    IN VARCHAR2,
                           PC_USR     IN VARCHAR2) IS
  
    cursor c_clientes(p_fecpro date /*,p_ndoc varchar2*/ /*, p_anio number, p_mes number*/) is
      select /*+all_rows index_ss(l)*/
       jaqz661pais, jaqz661tdoc, jaqz661ndoc
        from JAQZ661 l
       where /*jaqz661fech = p_fecpro  
                                   and */
       l.jaqz661pais = PN_PAIS
       and l.jaqz661tdoc = PN_TDOC
       and l.jaqz661ndoc = PC_NDOC --p_ndoc
       and l.jaqz661usr = PC_USR;
  
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
       where t.RNG49Cod in (1653, 1621)
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
    la_nomvar     Pq_Cr_Segmentacion_Consumo.tp_nomvar;
    la_valvar     Pq_Cr_Segmentacion_Consumo.tp_valvar;
    la_nomnul     Pq_Cr_Segmentacion_Consumo.tp_nomvar;
    la_valnul     Pq_Cr_Segmentacion_Consumo.tp_valvar;
    ln_var        number(3) := 0;
    Tp1cod        fst198.tp1cod%type;
    Tp1cod1       fst198.tp1cod1%type;
    Tp1corr1      fst198.tp1corr1%type;
    Tp1corr2      fst198.tp1corr2%type;
    Tp1desc       fst198.tp1desc%type;
    JAQY067CCAL   jaqy067.jaqy067ccal%type;
    --l_jaqy066pano  jaqy066.jaqy066pano%type;
    --l_jaqy066pmes  jaqy066.jaqy066pmes%type;
    l_JAQZ663paic  JAQZ663.JAQZ663paic%type;
    l_JAQZ663tdoc  JAQZ663.JAQZ663tdoc%type;
    l_JAQZ663tndoc JAQZ663.JAQZ663tndoc%type;
    l_JAQZ663calf  JAQZ663.JAQZ663calf%type;
    --l_jaqy066fecp  jaqy066.jaqy066fecp%type;
    --l_jaqy066horp  jaqy066.jaqy066horp%type;
    l_JAQZ663tcal JAQZ663.JAQZ663tcal%type;
  
    TYPE tp_pais IS TABLE OF JAQZ661.JAQZ661pais%type INDEX BY BINARY_INTEGER;
    TYPE tp_tdoc IS TABLE OF JAQZ661.JAQZ661tdoc%type INDEX BY BINARY_INTEGER;
    TYPE tp_ndoc IS TABLE OF JAQZ661.JAQZ661ndoc%type INDEX BY BINARY_INTEGER;
  
    la_JAQZ661pais tp_pais;
    la_JAQZ661tdoc tp_tdoc;
    la_JAQZ661ndoc tp_ndoc;
    la_reglas      Pq_Cr_Segmentacion_Consumo.tb_reglas;
    ln_reg         number(5);
  
    --p_ndoc char(12);
    --ln_tamdoc number(2);
  BEGIN
  
    execute immediate 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
    execute immediate 'ALTER SESSION SET OPTIMIZER_MODE=ALL_ROWS'; --jflor 2014.01.17  
    execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE'; --jflor 2014.05.05
  
    delete from JAQZ663 a
     where a.JAQZ663paic = PN_PAIS
       and a.JAQZ663tdoc = PN_TDOC
       and a.JAQZ663tndoc = PC_NDOC
       and a.JAQZ663usr = PC_USR;
    commit;
  
    Regla := 1653;
  
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
      INTO la_JAQZ661pais, la_JAQZ661tdoc, la_JAQZ661ndoc;
  
    IF la_JAQZ661ndoc.count > 0 THEN
      FOR c IN la_JAQZ661ndoc.FIRST .. la_JAQZ661ndoc.LAST LOOP
      
        la_nomvar := la_nomnul;
        la_valvar := la_valnul;
        pq_Cr_segmentacion_consumo.sp_cr_cargar_variables_NS(P_D_FECPRO => P_D_FECPRO,
                                                             P_N_PAIS   => la_JAQZ661pais(c),
                                                             P_N_TDOC   => la_JAQZ661tdoc(c),
                                                             P_C_NDOC   => la_JAQZ661ndoc(c),
                                                             P_C_USR    => PC_USR,
                                                             p_a_nomvar => la_nomvar,
                                                             p_a_valvar => la_valvar,
                                                             p_n_var    => ln_var);
        SegmentoRegla := null;
        pq_Cr_segmentacion_consumo.sp_cr_evalua_clientes_1_NS(P_N_REGLA   => Regla,
                                                              P_A_NOMVAR  => la_nomvar,
                                                              P_A_VALVAR  => la_valvar,
                                                              P_N_VAR     => ln_var,
                                                              P_A_REGLAS  => la_reglas,
                                                              P_N_REG     => ln_reg,
                                                              p_c_retorno => SegmentoRegla);
      
        Tp1cod      := 1;
        Tp1cod1     := 10823;
        Tp1corr1    := 400;
        Tp1corr2    := 1; -- Equivalencia resultado reglas - calificacion
        Tp1desc     := Trim(SegmentoRegla);
        JAQY067CCAL := null;
      
        For g in c_guia(Tp1cod, Tp1cod1, Tp1corr1, Tp1corr2) loop
          If g.tp1desc = Tp1desc Then
            JAQY067CCAL := g.tp1nro1;
          End If;
        End Loop;
      
        If JAQY067CCAL is not null then
          -- Califica
          l_JAQZ663paic  := la_JAQZ661pais(c);
          l_JAQZ663tdoc  := la_JAQZ661tdoc(c);
          l_JAQZ663tndoc := la_JAQZ661ndoc(c);
          l_JAQZ663calf  := JAQY067CCAL;
          --l_jaqz086horp := to_char(sysdate(),'HH24:MI:SS');
          l_JAQZ663tcal := 'P';
        
          insert into JAQZ663
            (JAQZ663PAIC,
             JAQZ663TDOC,
             JAQZ663TNDOC,
             JAQZ663CALF,
             JAQZ663TCAL,
             JAQZ663usr)
          values
            (l_JAQZ663paic,
             l_JAQZ663tdoc,
             l_JAQZ663tndoc,
             l_JAQZ663calf,
             l_JAQZ663tcal,
             PC_USR);
          commit;
        
        End If;
      
      END LOOP; -- clientes
    END IF;
  
  END sp_cr_NS_LINEA;

  procedure sp_cr_cargar_variables_NS(P_D_FECPRO IN DATE,
                                      P_N_PAIS   IN JAQZ661.JAQZ661PAIS%type,
                                      P_N_TDOC   IN JAQZ661.JAQZ661TDOC%type,
                                      P_C_NDOC   IN JAQZ661.JAQZ661NDOC%type,
                                      P_C_USR    IN JAQZ661.JAQZ661USR%type,
                                      p_a_nomvar out pq_cr_segmentacion_consumo.tp_nomvar,
                                      p_a_valvar out pq_cr_segmentacion_consumo.tp_valvar,
                                      p_n_var    out number) is
  
    cursor c_cliente is
      select JAQZ661fech,
             JAQZ661pais,
             JAQZ661tdoc,
             JAQZ661ndoc,
             JAQZ661var1,
             JAQZ661var2,
             JAQZ661var3,
             JAQZ661var4,
             JAQZ661var5,
             JAQZ661var6,
             JAQZ661var7,
             JAQZ661var8,
             JAQZ661var9,
             JAQZ661var10,
             JAQZ661var11,
             JAQZ661var12,
             JAQZ661var13,
             JAQZ661var14,
             JAQZ661var15,
             JAQZ661var16,
             JAQZ661var17,
             JAQZ661var18,
             JAQZ661var19,
             JAQZ661var20,
             JAQZ661var21,
             JAQZ661var22,
             JAQZ661var23,
             JAQZ661var24,
             JAQZ661var25,
             JAQZ661var26,
             JAQZ661var27,
             JAQZ661var28,
             JAQZ661var29,
             JAQZ661var30,
             JAQZ661var31,
             JAQZ661var32,
             JAQZ661var33,
             JAQZ661var34,
             JAQZ661var35,
             JAQZ661var36,
             JAQZ661var37,
             JAQZ661var38,
             JAQZ661var39,
             JAQZ661var40
        from JAQZ661
       where JAQZ661fech = P_D_FECPRO
         and JAQZ661pais = P_N_PAIS
         and JAQZ661tdoc = P_N_TDOC
         and JAQZ661ndoc = P_C_NDOC
         and JAQZ661usr = P_C_USR;
    ln_tmpnum number(3);
  
  begin
  
    for cli in c_cliente loop
      -- Cargando Variables Resuletas
      if trim(cli.JAQZ661var1) is not null then
        p_n_var := 1;
        ln_tmpnum := instr(cli.JAQZ661var1, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var1, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var1, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var2) is not null then
        p_n_var := 2;
        ln_tmpnum := instr(cli.JAQZ661var2, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var2, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var2, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var3) is not null then
        p_n_var := 3;
        ln_tmpnum := instr(cli.JAQZ661var3, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var3, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var3, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var4) is not null then
        p_n_var := 4;
        ln_tmpnum := instr(cli.JAQZ661var4, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var4, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var4, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var5) is not null then
        p_n_var := 5;
        ln_tmpnum := instr(cli.JAQZ661var5, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var5, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var5, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var6) is not null then
        p_n_var := 6;
        ln_tmpnum := instr(cli.JAQZ661var6, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var6, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var6, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var7) is not null then
        p_n_var := 7;
        ln_tmpnum := instr(cli.JAQZ661var7, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var7, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var7, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var8) is not null then
        p_n_var := 8;
        ln_tmpnum := instr(cli.JAQZ661var8, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var8, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var8, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var9) is not null then
        p_n_var := 9;
        ln_tmpnum := instr(cli.JAQZ661var9, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var9, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var9, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var10) is not null then
        p_n_var := 10;
        ln_tmpnum := instr(cli.JAQZ661var10, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var10, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var10, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var11) is not null then
        p_n_var := 11;
        ln_tmpnum := instr(cli.JAQZ661var11, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var11, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var11, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var12) is not null then
        p_n_var := 12;
        ln_tmpnum := instr(cli.JAQZ661var12, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var12, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var12, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var13) is not null then
        p_n_var := 13;
        ln_tmpnum := instr(cli.JAQZ661var13, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var13, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var13, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var14) is not null then
        p_n_var := 14;
        ln_tmpnum := instr(cli.JAQZ661var14, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var14, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var14, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var15) is not null then
        p_n_var := 15;
        ln_tmpnum := instr(cli.JAQZ661var15, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var15, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var15, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var16) is not null then
        p_n_var := 16;
        ln_tmpnum := instr(cli.JAQZ661var16, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var16, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var16, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var17) is not null then
        p_n_var := 17;
        ln_tmpnum := instr(cli.JAQZ661var17, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var17, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var17, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var18) is not null then
        p_n_var := 18;
        ln_tmpnum := instr(cli.JAQZ661var18, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var18, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var18, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var19) is not null then
        p_n_var := 19;
        ln_tmpnum := instr(cli.JAQZ661var19, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var19, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var19, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var20) is not null then
        p_n_var := 20;
        ln_tmpnum := instr(cli.JAQZ661var20, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var20, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var20, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var21) is not null then
        p_n_var := 21;
        ln_tmpnum := instr(cli.JAQZ661var21, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var21, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var21, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var22) is not null then
        p_n_var := 22;
        ln_tmpnum := instr(cli.JAQZ661var22, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var22, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var22, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var23) is not null then
        p_n_var := 23;
        ln_tmpnum := instr(cli.JAQZ661var23, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var23, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var23, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var24) is not null then
        p_n_var := 24;
        ln_tmpnum := instr(cli.JAQZ661var24, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var24, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var24, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var25) is not null then
        p_n_var := 25;
        ln_tmpnum := instr(cli.JAQZ661var25, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var25, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var25, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var26) is not null then
        p_n_var := 26;
        ln_tmpnum := instr(cli.JAQZ661var26, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var26, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var26, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var27) is not null then
        p_n_var := 27;
        ln_tmpnum := instr(cli.JAQZ661var27, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var27, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var27, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var28) is not null then
        p_n_var := 28;
        ln_tmpnum := instr(cli.JAQZ661var28, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var28, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var28, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var29) is not null then
        p_n_var := 29;
        ln_tmpnum := instr(cli.JAQZ661var29, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var29, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var29, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var30) is not null then
        p_n_var := 30;
        ln_tmpnum := instr(cli.JAQZ661var30, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var30, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var30, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var31) is not null then
        p_n_var := 31;
        ln_tmpnum := instr(cli.JAQZ661var31, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var31, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var31, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var32) is not null then
        p_n_var := 32;
        ln_tmpnum := instr(cli.JAQZ661var32, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var32, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var32, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var33) is not null then
        p_n_var := 33;
        ln_tmpnum := instr(cli.JAQZ661var33, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var33, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var33, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var34) is not null then
        p_n_var := 34;
        ln_tmpnum := instr(cli.JAQZ661var34, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var34, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var34, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var35) is not null then
        p_n_var := 35;
        ln_tmpnum := instr(cli.JAQZ661var35, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var35, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var35, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var36) is not null then
        p_n_var := 36;
        ln_tmpnum := instr(cli.JAQZ661var36, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var36, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var36, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var37) is not null then
        p_n_var := 37;
        ln_tmpnum := instr(cli.JAQZ661var37, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var37, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var37, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var38) is not null then
        p_n_var := 38;
        ln_tmpnum := instr(cli.JAQZ661var38, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var38, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var38, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var39) is not null then
        p_n_var := 39;
        ln_tmpnum := instr(cli.JAQZ661var39, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var39, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var39, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ661var40) is not null then
        p_n_var := 40;
        ln_tmpnum := instr(cli.JAQZ661var40, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ661var40, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ661var40, ln_tmpnum + 1);
      end if;
    
    end loop;
  
  end sp_cr_cargar_variables_NS;

  procedure sp_cr_evalua_clientes_1_NS(P_N_REGLA   IN NUMBER,
                                       P_A_NOMVAR  IN pq_cr_segmentacion_consumo.tp_nomvar,
                                       P_A_VALVAR  IN pq_cr_segmentacion_consumo.tp_valvar,
                                       P_N_VAR     IN number,
                                       P_A_REGLAS  in pq_cr_segmentacion_consumo.tb_reglas,
                                       P_N_REG     in number,
                                       p_c_retorno out varchar2) IS
  
    cursor c_lista(p_RNG49Cod number, p_RNG50Grp number, p_RNG51COD number) is
      select RNG49Cod, RNG50Grp, RNG51COD, RNG67COR, RNG67VAL
        from FRNG67
       where RNG49Cod = p_RNG49Cod
         and RNG50Grp = p_RNG50Grp
         and RNG51COD = p_RNG51COD
       order by RNG67COR;
  
    ExisteGrupo    char(1) := null;
    ResReglaGrupo  char(1) := null;
    ResReglaLista  char(1) := null;
    Regla          frng51.rng49cod%type;
    Regla2         frng51.rng49cod%type;
    l_RNG50Grp     frng51.rng50grp%type;
    l_RNG50Ret     frng50.rng50ret%type;
    la_nomvar      pq_cr_segmentacion_consumo.tp_nomvar;
    la_valvar      pq_cr_segmentacion_consumo.tp_valvar;
    ln_var         number(3) := 0;
    lc_valResuelto varchar2(30);
    i              number(5);
    ln_NumTmp1     number(10, 2);
    ln_NumTmp2     number(10, 2);
    l_RNG68Tda     frng68.rng68tda%type;
    SegmentoRegla2 frng51.rng51val%type;
    l_RNG51Val     varchar2(30);
    l_RNG67val     varchar2(30);
    l_RNG51OPE     varchar2(2);
    la_reglas      pq_cr_segmentacion_consumo.tb_reglas;
    ln_reg         number(5);
    ln_ind         number(5);
    ln_grupoExcp   number(4); --mod@abr 20180227
  
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
         and Tp1corr1 = 999
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
          --mod@br 20180227--chernandez 13052019
          ExisteGrupo := 'S';
          ln_ind      := reg;
          Exit;
        end if; --mod@br 20180227--chernandez 13052019
      End If;
    End loop;
  
    If ExisteGrupo = 'S' then
      --existe grupo
    
      -- Evaluando Variables
      ResReglaGrupo := 'S';
    
      BEGIN
        --MOD@BR 20180724              
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
          If la_reglas(ln_ind).RNG68ATR = 'EXP1621' then
          
            Regla2 := to_number(substr(la_reglas(ln_ind).RNG68ATR, 4, 4));
            --Msg('rutina regla anidada ' + Str(&Regla2))
            SegmentoRegla2 := null;
            pq_Cr_segmentacion_consumo.sp_cr_evalua_clientes_2_NS(P_N_REGLA   => Regla2,
                                                                  P_A_NOMVAR  => la_nomvar,
                                                                  P_A_VALVAR  => la_valvar,
                                                                  P_N_VAR     => ln_var,
                                                                  P_A_REGLAS  => la_reglas,
                                                                  P_N_REG     => ln_reg,
                                                                  p_c_retorno => SegmentoRegla2);
            lc_valResuelto := Trim(SegmentoRegla2);
          
          End If;
        
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
      EXCEPTION
        --mod@br 20180724
        WHEN OTHERS THEN
          --mod@br 20180724
          p_c_retorno := 'NO SEGMENTADO'; --mod@br 20180724
      END; --mod@br 20180724
    End If; -- existe grupo
  
  END sp_cr_evalua_clientes_1_NS;

  procedure sp_cr_evalua_clientes_2_NS(P_N_REGLA   IN NUMBER,
                                       P_A_NOMVAR  IN pq_Cr_segmentacion_consumo.tp_nomvar,
                                       P_A_VALVAR  IN pq_Cr_segmentacion_consumo.tp_valvar,
                                       P_N_VAR     IN number,
                                       P_A_REGLAS  in pq_Cr_segmentacion_consumo.tb_reglas,
                                       P_N_REG     in number,
                                       p_c_retorno out varchar2) IS
  
    cursor c_lista(p_RNG49Cod number, p_RNG50Grp number, p_RNG51COD number) is
      select RNG49Cod, RNG50Grp, RNG51COD, RNG67COR, RNG67VAL
        from FRNG67
       where RNG49Cod = p_RNG49Cod
         and RNG50Grp = p_RNG50Grp
         and RNG51COD = p_RNG51COD
       order by RNG67COR;
  
    ExisteGrupo    char(1) := null;
    ResReglaGrupo  char(1) := null;
    ResReglaLista  char(1) := null;
    Regla          frng51.rng49cod%type;
    l_RNG50Grp     frng51.rng50grp%type;
    l_RNG50Ret     frng50.rng50ret%type;
    la_nomvar      pq_Cr_segmentacion_consumo.tp_nomvar;
    la_valvar      pq_Cr_segmentacion_consumo.tp_valvar;
    ln_var         number(3) := 0;
    lc_valResuelto varchar2(30);
    i              number(3);
    ln_NumTmp1     number(10, 2);
    ln_NumTmp2     number(10, 2);
    l_RNG68Tda     frng68.rng68tda%type;
    l_RNG51Val     varchar2(30);
    l_RNG67val     varchar2(30);
    --SegmentoRegla3 frng51.rng51val%type;
    --Regla3 frng51.rng49cod%type;
    l_RNG51OPE varchar2(2);
    la_reglas  pq_Cr_segmentacion_consumo.tb_reglas;
    ln_reg     number(5);
    ln_ind     number(5);
  
  BEGIN
  
    Regla     := nvl(P_N_REGLA, 0);
    la_nomvar := P_A_NOMVAR;
    la_valvar := P_A_VALVAR;
    ln_var    := nvl(P_N_VAR, 0);
    la_reglas := P_A_REGLAS;
    ln_reg    := nvl(P_N_REG, 0);
  
    For reg in 1 .. ln_reg loop
      If la_reglas(reg).RNG49COD = Regla then
        l_RNG50Ret  := la_reglas(reg).RNG50Ret;
        l_RNG50Grp  := la_reglas(reg).RNG50GRP;
        ExisteGrupo := 'S';
        ln_ind      := reg;
        Exit;
      End If;
    End loop;
  
    If ExisteGrupo = 'S' then
      --existe grupo
    
      -- Evaluando Variables
      ResReglaGrupo := 'S';
    
      --FOR reg in 1..ln_reg LOOP -- reglas
      --IF la_reglas(reg).RNG49COD = Regla THEN -- regla evaluada                          
      WHILE la_reglas(ln_ind).RNG49COD = Regla LOOP
      
        If la_reglas(ln_ind).RNG50GRP <> l_RNG50Grp then
          --evaluar cambio de grupo
          --Msg('Diferente grupo')
          If ResReglaGrupo = 'N' And la_reglas(ln_ind).RNG50GRP = 999 then
            --Retorno Default (Condición ELSE)
            --Msg('Retorno Default (Condición ELSE)')
            p_c_retorno   := la_reglas(ln_ind).RNG50Ret;
            ResReglaGrupo := 'S';
            --Msg(p_c_retorno)                         
            Exit;
          End If;
        
          If ResReglaGrupo = 'S' then
            --se cumple la regla para el grupo anterior
            --Msg('grupo cumplido')
            p_c_retorno   := l_RNG50Ret;
            ResReglaGrupo := 'S';
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
        for i in 1 .. ln_var loop
          If la_nomvar(i) = trim(la_reglas(ln_ind).RNG68ATR) then
            lc_valResuelto := trim(la_valvar(i));
            Exit;
          End If;
        End loop;
      
        -- Resolver Regla anidada Nivel 3
        --If la_reglas(ln_ind).RNG68ATR in ('EXP1612','EXP1613','EXP1614','EXP1617') then
      
        --  Regla3 := to_number(substr(la_reglas(ln_ind).RNG68ATR,4,4));
        --Msg('rutina regla anidada ' + Str(&Regla2))
        --SegmentoRegla3 := null;
        --PQ_CR_SEGMENTACION_CLIENTES.sp_cr_evalua_clientes_3_NS( P_N_REGLA => Regla3,
        --                                                   P_A_NOMVAR => la_nomvar,
        --                                                 P_A_VALVAR => la_valvar, 
        --                                               P_N_VAR => ln_var,
        --                                             P_A_REGLAS => la_reglas,
        --                                           P_N_REG => ln_reg,
        --                                         p_c_retorno => SegmentoRegla3);
        --lc_valResuelto := Trim(SegmentoRegla3);
      
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
            --Msg('es mayor igual que ' + reg.RNG51VAL)
            --Msg(ValResuelto)
            ln_NumTmp1 := to_number(lc_valResuelto);
            ln_NumTmp2 := to_number(l_RNG51Val);
            If ln_NumTmp1 < ln_NumTmp2 then
              --Msg('no cumple ' + reg.RNG68ATR)
              ResReglaGrupo := 'N';
            End If;
          
          When '>' then
            --Msg('es mayor que ' + reg.RNG51VAL)
            --Msg(lc_lc_valResuelto)
            ln_NumTmp1 := to_number(lc_valResuelto);
            ln_NumTmp2 := to_number(l_RNG51Val);
            If ln_NumTmp1 <= ln_NumTmp2 then
              --Msg('no cumple ' + reg.RNG68ATR)
              ResReglaGrupo := 'N';
            End If;
          
          When '<=' then
            --Msg('es menor igual que ' + reg.RNG51VAL)
            --Msg(lc_valResuelto)
            ln_NumTmp1 := to_number(lc_valResuelto);
            ln_NumTmp2 := to_number(l_RNG51Val);
            If ln_NumTmp1 > ln_NumTmp2 then
              --Msg('no cumple ' + reg.RNG68ATR)
              ResReglaGrupo := 'N';
            End If;
          
          When '<' then
            --Msg('es menor que ' + reg.RNG51VAL)
            --Msg(lc_valResuelto)
            ln_NumTmp1 := to_number(lc_valResuelto);
            ln_NumTmp2 := to_number(l_RNG51Val);
            If ln_NumTmp1 >= ln_NumTmp2 then
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
      
        ln_ind := ln_ind + 1;
      
      --END IF; -- regla evaluada
      END LOOP; -- reglas
    
    End If; -- existe grupo
  
  END sp_cr_evalua_clientes_2_NS;

  Procedure Sp_calificacion_normal_cpp(pn_pai    in number,
                                       pn_tdo    in number,
                                       pc_ndo    in char,
                                       pd_fecpro in date,
                                       pn_cal    out number) is
  
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
    if pd_fecpro = to_date('30.11.2015', 'dd.mm.yyyy') then
      fec_rcc := to_date('31.10.2015', 'dd.mm.yyyy');
    else
      if pd_fecpro = to_date('31.12.2015', 'dd.mm.yyyy') then
        fec_rcc := to_date('30.11.2015', 'dd.mm.yyyy');
      else
        if pd_fecpro = to_date('31.01.2016', 'dd.mm.yyyy') then
          fec_rcc := to_date('31.12.2015', 'dd.mm.yyyy');
        else
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
        end if;
      end if;
    end if;
  
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
  
    pn_cal := pq_cr_segmentacion_consumo.Fn_calificacion_RCC(DocSbsTit,
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
    
      pn_cal := pq_cr_segmentacion_consumo.Fn_calificacion_RCC(DocSbsCyg,
                                                               lc_ndoC,
                                                               fec_rcc,
                                                               MesRcc,
                                                               lc_tiper_Cyg);
    
    end if;
  end Sp_calificacion_normal_cpp;

  Function Fn_calificacion_RCC(TipDocSbs   in char,
                               pc_ndo_FN   in char,
                               pd_fecRcc   in date,
                               MesRcc      in number,
                               lc_tiper_FN in char) return number is
    ln_i         number(5);
    CodSbs       char(10);
    LN_CALIF0    number(5, 2);
    LN_CALIF1    number(5, 2);
    LN_CALIF2    number(5, 2);
    LN_CALIF3    number(5, 2);
    LN_CALIF4    number(5, 2);
    pn_cal       number(10, 5);
    pd_fecRccTmp date;
  
  begin
  
    if pc_ndo_FN is null then
      insert into jaqz082_aux
        (jaqz082ndo, JAQZ082TPO)
      values
        (pc_ndo_FN, 'ANTES');
      commit;
    end if;
  
    if lc_tiper_FN is null then
      insert into jaqz082_aux
        (jaqz082ndo, JAQZ082TPO)
      values
        (pc_ndo_FN, 'lc_tiper');
      commit;
    end if;
  
    pd_fecRccTmp := pd_fecRcc;
    pn_cal       := 100.00;
    ln_i         := 1;
    begin
      while ln_i <= MesRcc loop
        case
          when lc_tiper_FN = 'F' then
            begin
              select c_CodSbs,
                     N_CALIF0,
                     N_CALIF1,
                     N_CALIF2,
                     N_CALIF3,
                     N_CALIF4
                into CodSbs,
                     LN_CALIF0,
                     LN_CALIF1,
                     LN_CALIF2,
                     LN_CALIF3,
                     LN_CALIF4
                from cldrcci a
               where D_FECPRE = pd_fecRccTmp
                 and C_TDOCID = TipDocSbs
                 and C_DOCIDE = trim(pc_ndo_FN)
                 and rownum = 1;
            exception
              when no_data_found then
                CodSbs    := null;
                LN_CALIF0 := null;
                LN_CALIF1 := null;
                LN_CALIF2 := null;
                LN_CALIF3 := null;
                LN_CALIF4 := null;
            end;
          
            If LN_CALIF0 + LN_CALIF1 = 100.00 or CodSbs is null then
              --mod@abr 20180718
              pn_cal := 100.00;
            Else
              If (LN_CALIF0 + LN_CALIF1 + LN_CALIF2 + LN_CALIF3 + LN_CALIF4 = 0) then
                pn_cal := 100.00;
              Else
              
                pn_cal := 0.00;
                Exit;
              End If;
            End If;
          
          when lc_tiper_FN = 'J' then
            begin
              select c_CodSbs,
                     N_CALIF0,
                     N_CALIF1,
                     N_CALIF2,
                     N_CALIF3,
                     N_CALIF4
                into CodSbs,
                     LN_CALIF0,
                     LN_CALIF1,
                     LN_CALIF2,
                     LN_CALIF3,
                     LN_CALIF4
                from cldrcci a
               where D_FECPRE = pd_fecRccTmp
                 and C_TDOCTR = TipDocSbs
                 and C_DOCTRI = trim(pc_ndo_FN)
                 and rownum = 1;
            exception
              when no_data_found then
                CodSbs    := null;
                LN_CALIF0 := null;
                LN_CALIF1 := null;
                LN_CALIF2 := null;
                LN_CALIF3 := null;
                LN_CALIF4 := null;
            end;
            If LN_CALIF0 + LN_CALIF1 = 100.00 or CodSbs is null then
              pn_cal := 100.00;
            Else
              If (LN_CALIF0 + LN_CALIF1 + LN_CALIF2 + LN_CALIF3 + LN_CALIF4 = 0) then
                pn_cal := 100.00;
              Else
                pn_cal := 0.00;
                Exit;
              End If;
            End If;
          else
            begin
              select c_CodSbs,
                     N_CALIF0,
                     N_CALIF1,
                     N_CALIF2,
                     N_CALIF3,
                     N_CALIF4
                into CodSbs,
                     LN_CALIF0,
                     LN_CALIF1,
                     LN_CALIF2,
                     LN_CALIF3,
                     LN_CALIF4
                from cldrcci a
               where D_FECPRE = pd_fecRccTmp
                 and C_DOCIDE = trim(pc_ndo_FN)
                 and rownum = 1;
            exception
              when no_data_found then
                CodSbs    := null;
                LN_CALIF0 := null;
                LN_CALIF1 := null;
                LN_CALIF2 := null;
                LN_CALIF3 := null;
                LN_CALIF4 := null;
            end;
          
            If LN_CALIF0 + LN_CALIF1 = 100.00 or CodSbs is null then
              pn_cal := 100.00;
            Else
              If (LN_CALIF0 + LN_CALIF1 + LN_CALIF2 + LN_CALIF3 + LN_CALIF4 = 0) then
                pn_cal := 100.00;
              Else
                pn_cal := 0.00;
                Exit;
              End If;
            End If;
          
            if CodSbs is null then
              begin
                select c_CodSbs,
                       N_CALIF0,
                       N_CALIF1,
                       N_CALIF2,
                       N_CALIF3,
                       N_CALIF4
                  into CodSbs,
                       LN_CALIF0,
                       LN_CALIF1,
                       LN_CALIF2,
                       LN_CALIF3,
                       LN_CALIF4
                  from cldrcci a
                 where D_FECPRE = pd_fecRccTmp
                   and C_DOCTRI = trim(pc_ndo_FN)
                   and rownum = 1;
              exception
                when no_data_found then
                  CodSbs    := null;
                  LN_CALIF0 := null;
                  LN_CALIF1 := null;
                  LN_CALIF2 := null;
                  LN_CALIF3 := null;
                  LN_CALIF4 := null;
              end;
              If LN_CALIF0 + LN_CALIF1 = 100.00 or CodSbs is null then
                pn_cal := 100.00;
              Else
                If (LN_CALIF0 + LN_CALIF1 + LN_CALIF2 + LN_CALIF3 +
                   LN_CALIF4 = 0) then
                  pn_cal := 100.00;
                Else
                  pn_cal := 0.00;
                  Exit;
                End If;
              End If;
            end if;
          
        end case;
        if pn_cal = 0.00 then
          Exit;
        end if;
        ln_i         := ln_i + 1;
        pd_fecRccTmp := Add_months(pd_fecRccTmp, -1);
        pd_fecRccTmp := last_day(pd_fecRccTmp);
      end loop;
    end;
    return pn_cal;
  end Fn_calificacion_RCC;

  procedure sp_cuentas(ln_Pepais     in number,
                       ln_Petdoc     in number,
                       ln_Pendoc     in char,
                       Instancia     in number,
                       pd_fecpro     in date,
                       ln_captotcaja out number) is
  
    ln_capacidad number;
    /*saldo_extSoles number;
    saldo_extDol   number;
    ln_cajaext     number;
    divisor        number;
    evaluacion     number;
    mntsoles       number;
    mntdolar       number;*/
  
    lc_fgAdic    varchar2(1); --mod 2016.04.12
    lc_fgAmpl    varchar2(1); --mod 2016.04.12
    lc_ven       char(1); --mod 2016.04.12
    ln_indicador number; --mod 2016.04.12
    lc_fgRefLin  varchar2(1) := 'N'; -- 28/06/16 mpostigoc
    lc_fgRepro   varchar2(2);
  
    cursor inserta is
      select d10.pgcod    ln_pgcod10,
             d10.aomod    ln_mod10,
             d10.aosuc    ln_suc10,
             d10.aomda    ln_mda10,
             d10.aopap    ln_pap10,
             d10.aocta    ln_cta10,
             d10.aooper   ln_oper10,
             d10.aosbop   ln_sbop10,
             d10.aotope   ln_tope10,
             d10.aoperiod ln_peri10
      
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc
                              and Ttcod = 1
                              and Cttfir = 'T')
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 17
                                        and a.tp1corr2 = 1))) or
             d10.Aomod in (141))
         and d10.Aostat <> 99;
  
    cursor linea is
      select d10.pgcod    ln_pgcod10,
             d10.aomod    ln_mod10,
             d10.aosuc    ln_suc10,
             d10.aomda    ln_mda10,
             d10.aopap    ln_pap10,
             d10.aocta    ln_cta10,
             d10.aooper   ln_oper10,
             d10.aosbop   ln_sbop10,
             d10.aotope   ln_tope10,
             d10.aoperiod ln_peri10
      
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc
                              and Ttcod = 1
                              and Cttfir = 'T')
         and d10.Aomod = 117
         and d10.Aostat <> 99
         and d10.aofvto > pd_fecpro;
  
    cursor vuelo is
    
      select x.xwfempresa ln_pgcod10,
             x.xwfmodulo ln_mod10,
             x.xwfsucursal ln_suc10,
             x.xwfmoneda ln_mda10,
             x.xwfpapel ln_pap10,
             x.xwfcuenta ln_cta10,
             x.xwfoperacion ln_oper10,
             x.xwfsubope ln_sbop10,
             x.xwftipope ln_tope10,
             x.xwfprcins,
             max(s.sng120per) ln_peri10
        from xwf700 x, sng120 s
       where x.xwfempresa = 1
         and x.xwfcuenta in (select Ctnro
                               from fsr008
                              where pepais = ln_Pepais
                                and Petdoc = ln_Petdoc
                                and pendoc = ln_Pendoc
                                and Ttcod = 1
                                and Cttfir = 'T')
            
         and (x.xwfmodulo in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 17
                                        and a.tp1corr2 = 1))) or
             xwfmodulo in (117, 141))
            
         and x.XWFPRCINS in
             (select wfinsprcid
                from wfwrkitems wf
               where wf.wfinsprcid = x.xwfprcins
                 and wf.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                 and wf.wfiteminit =
                     (select max(wfiteminit)
                        from wfwrkitems w
                       where w.wfinsprcid = x.xwfprcins
                         and w.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                         and w.wfitemstsact = 1
                            -- and wftaskcod <> 55
                         and w.wfiteminit >=
                             to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
                    --and wftaskcod <> 55
                 and wf.wfitemstsact = 1
                 and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
         and s.sng120ins = XWFPRCINS
         and x.xwfcar3 = '1'
      
       group by x.xwfempresa,
                x.xwfmodulo,
                x.xwfsucursal,
                x.xwfmoneda,
                x.xwfpapel,
                x.xwfcuenta,
                x.xwfoperacion,
                x.xwfsubope,
                x.xwftipope,
                x.xwfprcins;
  
    cursor lineas_ven is
    
      select d10.pgcod    ln_pgcod10,
             d10.aomod    ln_mod10,
             d10.aosuc    ln_suc10,
             d10.aomda    ln_mda10,
             d10.aopap    ln_pap10,
             d10.aocta    ln_cta10,
             d10.aooper   ln_oper10,
             d10.aosbop   ln_sbop10,
             d10.aotope   ln_tope10,
             d10.aoperiod ln_peri10
      
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc
                              and Ttcod = 1
                              and Cttfir = 'T')
         and d10.Aomod = 117
         and d10.aofvto < pd_fecpro;
    ln_instancia   number(10);
    lc_flgGarantia char(1);
    tipocambio     number(14, 8);
  
  begin
  
    ln_captotcaja := 0;
  
    tipocambio := FN_TIPO_CAMBIO(FECHA  => pd_fecpro,
                                 MONORI => 101,
                                 MONDES => 0,
                                 TIPO   => 0);
  
    for i in inserta loop
    
      ln_instancia   := fn_instancia_credito(v_Scmod  => i.ln_mod10,
                                             v_Scsuc  => i.ln_suc10,
                                             v_Scmda  => i.ln_mda10,
                                             v_Scpap  => i.ln_pap10,
                                             v_Sccta  => i.ln_cta10,
                                             v_Scoper => i.ln_oper10,
                                             v_Scsbop => i.ln_sbop10,
                                             v_Sctope => i.ln_tope10);
      lc_flgGarantia := pq_cr_segmentacion_consumo.fn_garantia(ln_instancia);
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      if lc_flgGarantia = 'S' then
        PQ_CR_RESOLUTOR_AUTONOMIA.sp_refinanLinea(i.ln_pgcod10,
                                                  i.ln_mod10,
                                                  i.ln_suc10,
                                                  i.ln_mda10,
                                                  i.ln_pap10,
                                                  i.ln_cta10,
                                                  i.ln_oper10,
                                                  lc_fgRefLin);
      
        PQ_CR_RESOLUTOR_AUTONOMIA.Sp_ampliados_CK(i.ln_pgcod10,
                                                  i.ln_mod10,
                                                  i.ln_suc10,
                                                  i.ln_mda10,
                                                  i.ln_pap10,
                                                  i.ln_cta10,
                                                  i.ln_oper10,
                                                  i.ln_sbop10,
                                                  i.ln_tope10,
                                                  lc_fgAmpl);
      
        PQ_CR_RESOLUTOR_AUTONOMIA.sp_cr_Reprogramados(i.ln_pgcod10,
                                                      i.ln_mod10,
                                                      i.ln_suc10,
                                                      i.ln_mda10,
                                                      i.ln_pap10,
                                                      i.ln_cta10,
                                                      i.ln_oper10,
                                                      i.ln_sbop10,
                                                      i.ln_tope10,
                                                      lc_fgRepro);
      
        -- end if;*/
      
        -- if /*lc_fgAdic <> 'S' and*/ lc_fgAmpl <> 'S' then
        if lc_fgRefLin <> 'S' and lc_fgAmpl <> 'S' AND lc_fgRepro <> 'S' then
          PQ_CR_RESOLUTOR_AUTONOMIA.sp_resolutor(i.ln_pgcod10,
                                                 i.ln_mod10,
                                                 i.ln_suc10,
                                                 i.ln_mda10,
                                                 i.ln_pap10,
                                                 i.ln_cta10,
                                                 i.ln_oper10,
                                                 i.ln_sbop10,
                                                 i.ln_tope10,
                                                 tipocambio,
                                                 lc_fgRefLin,
                                                 Instancia,
                                                 
                                                 ln_capacidad);
        
          ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
        end if;
      end if;
    end loop;
  
    for l in linea loop
      ln_instancia   := fn_instancia_credito(v_Scmod  => l.ln_mod10,
                                             v_Scsuc  => l.ln_suc10,
                                             v_Scmda  => l.ln_mda10,
                                             v_Scpap  => l.ln_pap10,
                                             v_Sccta  => l.ln_cta10,
                                             v_Scoper => l.ln_oper10,
                                             v_Scsbop => l.ln_sbop10,
                                             v_Sctope => l.ln_tope10);
      lc_flgGarantia := pq_cr_segmentacion_consumo.fn_garantia(ln_instancia);
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
    
      if lc_flgGarantia = 'S' then
        PQ_CR_RESOLUTOR_AUTONOMIA.sp_refinanLinea(l.ln_pgcod10,
                                                  l.ln_mod10,
                                                  l.ln_suc10,
                                                  l.ln_mda10,
                                                  l.ln_pap10,
                                                  l.ln_cta10,
                                                  l.ln_oper10,
                                                  lc_fgRefLin);
      
        if lc_fgRefLin <> 'S' then
        
          PQ_CR_RESOLUTOR_AUTONOMIA.sp_resolutor(l.ln_pgcod10,
                                                 l.ln_mod10,
                                                 l.ln_suc10,
                                                 l.ln_mda10,
                                                 l.ln_pap10,
                                                 l.ln_cta10,
                                                 l.ln_oper10,
                                                 l.ln_sbop10,
                                                 l.ln_tope10,
                                                 tipocambio,
                                                 lc_fgRefLin,
                                                 Instancia,
                                                 
                                                 ln_capacidad);
        
          ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
        end if;
      end if;
    end loop;
  
    for c in vuelo loop
      ln_instancia   := fn_instancia_credito(v_Scmod  => c.ln_mod10,
                                             v_Scsuc  => c.ln_suc10,
                                             v_Scmda  => c.ln_mda10,
                                             v_Scpap  => c.ln_pap10,
                                             v_Sccta  => c.ln_cta10,
                                             v_Scoper => c.ln_oper10,
                                             v_Scsbop => c.ln_sbop10,
                                             v_Sctope => c.ln_tope10);
      lc_flgGarantia := pq_cr_segmentacion_consumo.fn_garantia(ln_instancia);
    
      ln_indicador := 2;
      if lc_flgGarantia = 'S' then
        PQ_CR_RESOLUTOR_AUTONOMIA.sp_resolutor(c.ln_pgcod10,
                                               c.ln_mod10,
                                               c.ln_suc10,
                                               c.ln_mda10,
                                               c.ln_pap10,
                                               c.ln_cta10,
                                               c.ln_oper10,
                                               c.ln_sbop10,
                                               c.ln_tope10,
                                               tipocambio,
                                               lc_fgRefLin,
                                               --Instancia,
                                               c.xwfprcins,
                                               
                                               ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      end if;
    end loop;
  
    --mod 2016.04.13
    for j in lineas_ven loop
      ln_instancia   := fn_instancia_credito(v_Scmod  => j.ln_mod10,
                                             v_Scsuc  => j.ln_suc10,
                                             v_Scmda  => j.ln_mda10,
                                             v_Scpap  => j.ln_pap10,
                                             v_Sccta  => j.ln_cta10,
                                             v_Scoper => j.ln_oper10,
                                             v_Scsbop => j.ln_sbop10,
                                             v_Sctope => j.ln_tope10);
      lc_flgGarantia := pq_cr_segmentacion_consumo.fn_garantia(ln_instancia);
    
      ln_indicador := 3;
    
      if lc_flgGarantia = 'S' then
      
        begin
          select 'S'
            into lc_ven
            from fsr011 a, fsd010 b
           where a.r2cod = j.ln_pgcod10
             and a.r2mod = j.ln_mod10
             and a.r2suc = j.ln_suc10
             and a.r2mda = j.ln_mda10
             and a.r2pap = j.ln_pap10
             and a.r2cta = j.ln_cta10
             and a.r2oper = j.ln_oper10
             and a.r2sbop = j.ln_sbop10
             and a.r2tope = j.ln_tope10
             and a.r1cod = b.pgcod
             and a.r1mod = b.aomod
             and a.r1suc = b.aosuc
             and a.r1mda = b.aomda
             and a.r1pap = b.aopap
             and a.r1cta = b.aocta
             and a.r1oper = b.aooper
             and a.r1sbop = b.aosbop
             and a.r1tope = b.aotope
             and b.aostat <> 99
             and relcod = 46
             and rownum = 1;
        exception
          when no_data_found then
            lc_ven := 'N';
        end;
      
        lc_fgAdic := null;
      
        if lc_ven = 'S' then
          PQ_CR_RESOLUTOR_AUTONOMIA.sp_resolutor_venc(j.ln_pgcod10,
                                                      j.ln_mod10,
                                                      j.ln_suc10,
                                                      j.ln_mda10,
                                                      j.ln_pap10,
                                                      j.ln_cta10,
                                                      j.ln_oper10,
                                                      j.ln_sbop10,
                                                      j.ln_tope10,
                                                      tipocambio,
                                                      Instancia,
                                                      ln_capacidad);
        
          ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
        end if;
      end if;
    end loop;
  
  end sp_cuentas;

  Function Fn_garantia(pn_ins in number) return char is
    lc_flg char(1) := 'N';
  
  begin
    begin
      select 'S'
        into lc_flg
        from sng122 a
       where a.sng122inst = pn_ins
         and a.sng122tope in (90, 91)
         and rownum = 1;
    exception
      when others then
        lc_flg := 'N';
    end;
    return lc_flg;
  end Fn_garantia;

end Pq_Cr_Segmentacion_Consumo;
/

