create or replace package PQ_CR_SEGMENTACION_MYPE22 is

  -- Author  : APACHECOH
  -- Created : 8/09/2022 12:29:06
  -- Purpose : Segmentacion Mype22
  
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

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --       
  procedure sp_cr_NS_LINEA(P_D_FECPRO IN DATE,
                           PN_PAIS    IN NUMBER,
                           PN_TDOC    IN NUMBER,
                           PC_NDOC    IN VARCHAR2,
                           PC_USR     IN VARCHAR2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_cargar_variables_NS(P_D_FECPRO IN DATE,
                                      P_N_PAIS   IN JAQZ082.JAQZ082PAIS%type,
                                      P_N_TDOC   IN JAQZ082.JAQZ082TDOC%type,
                                      P_C_NDOC   IN JAQZ082.JAQZ082NDOC%type,
                                      P_C_USR    IN JAQZ082.JAQZ082USR%type,
                                      p_a_nomvar out pq_cr_segmentacion_mype22.tp_nomvar,
                                      p_a_valvar out pq_cr_segmentacion_mype22.tp_valvar,
                                      p_n_var    out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_evalua_clientes_1_NS(P_N_REGLA   IN NUMBER,
                                       P_A_NOMVAR  IN pq_cr_segmentacion_mype22.tp_nomvar,
                                       P_A_VALVAR  IN pq_cr_segmentacion_mype22.tp_valvar,
                                       P_N_VAR     IN number,
                                       P_A_REGLAS  in pq_cr_segmentacion_mype22.tb_reglas,
                                       P_N_REG     in number,
                                       p_c_retorno out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_evalua_clientes_2_NS(P_N_REGLA   IN NUMBER,
                                       P_A_NOMVAR  IN pq_cr_segmentacion_mype22.tp_nomvar,
                                       P_A_VALVAR  IN pq_cr_segmentacion_mype22.tp_valvar,
                                       P_N_VAR     IN number,
                                       P_A_REGLAS  in pq_cr_segmentacion_mype22.tb_reglas,
                                       P_N_REG     in number,
                                       p_c_retorno out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

end PQ_CR_SEGMENTACION_MYPE22;
/

create or replace package body PQ_CR_SEGMENTACION_MYPE22 is

-- *****************************************************************
-- Sistema                    : BANTOTAL
-- Módulo                     : Créditos - Activas
-- Versión                    : 1.0
-- Fecha de Creación          : 2022.09.08
-- Autor de Creación          : Alonso Pacheco Huachaca
-- Uso                        : Proceso de Segmentación MYPE22
-- Estado                     : Activo
-- Acceso                     : Público
-- Parámetros de Entrada      : P_D_FECPRO ( Fecha RCC )
--                            : PN_PAIS ( Pais )
--                            : PN_TDOC ( Tipo de Documento )
--                            : PC_NDOC ( Numero de Documento )
--                            : PC_USR ( Usuario )
-- Parámetros de Salida       : 
-- ******************************************************************

  procedure sp_cr_NS_LINEA(P_D_FECPRO in date,
                           PN_PAIS    IN NUMBER,
                           PN_TDOC    IN NUMBER,
                           PC_NDOC    IN VARCHAR2,
                           PC_USR     IN VARCHAR2) IS
  
    cursor c_clientes(p_fecpro date) is
      select JAQZ082pais, JAQZ082tdoc, JAQZ082ndoc
        from JAQZ082 l
       where l.jaqz082pais = PN_PAIS
         and l.jaqz082tdoc = PN_TDOC
         and l.jaqz082ndoc = PC_NDOC --p_ndoc
         and l.jaqz082usr = PC_USR;
  
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
       where t.RNG49Cod in (1621, 1626, 1627) --mod@abr 20170110
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
    la_nomvar     pq_cr_segmentacion_mype22.tp_nomvar;
    la_valvar     pq_cr_segmentacion_mype22.tp_valvar;
    la_nomnul     pq_cr_segmentacion_mype22.tp_nomvar;
    la_valnul     pq_cr_segmentacion_mype22.tp_valvar;
    ln_var        number(3) := 0;
    Tp1cod        fst198.tp1cod%type;
    Tp1cod1       fst198.tp1cod1%type;
    Tp1corr1      fst198.tp1corr1%type;
    Tp1corr2      fst198.tp1corr2%type;
    Tp1desc       fst198.tp1desc%type;
    JAQY067CCAL   jaqy067.jaqy067ccal%type;
    --l_jaqy066pano  jaqy066.jaqy066pano%type;
    --l_jaqy066pmes  jaqy066.jaqy066pmes%type;
    l_jaqz086paic  jaqz086.jaqz086paic%type;
    l_jaqz086tdoc  jaqz086.jaqz086tdoc%type;
    l_jaqz086tndoc jaqz086.jaqz086tndoc%type;
    l_jaqz086calf  jaqz086.jaqz086calf%type;
    --l_jaqy066fecp  jaqy066.jaqy066fecp%type;
    --l_jaqy066horp  jaqy066.jaqy066horp%type;
    l_jaqz086tcal jaqz086.jaqz086tcal%type;
  
    TYPE tp_pais IS TABLE OF jaqz082.jaqz082pais%type INDEX BY BINARY_INTEGER;
    TYPE tp_tdoc IS TABLE OF jaqz082.jaqz082tdoc%type INDEX BY BINARY_INTEGER;
    TYPE tp_ndoc IS TABLE OF jaqz082.jaqz082ndoc%type INDEX BY BINARY_INTEGER;
  
    la_JAQZ082pais tp_pais;
    la_JAQZ082tdoc tp_tdoc;
    la_JAQZ082ndoc tp_ndoc;
    la_reglas      pq_cr_segmentacion_mype22.tb_reglas;
    ln_reg         number(5);
  
    --p_ndoc char(12);
    --ln_tamdoc number(2);
  BEGIN
  
    execute immediate 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
    execute immediate 'ALTER SESSION SET OPTIMIZER_MODE=ALL_ROWS'; --jflor 2014.01.17  
    execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE'; --jflor 2014.05.05
  
    --ln_tamdoc := length(trim(PC_NDOC));
  
    /*case  
        when ln_tamdoc = 6 then 
             p_ndoc := PC_NDOC||'      ';
        when ln_tamdoc = 7 then 
             p_ndoc := PC_NDOC||'     ';
        when ln_tamdoc = 8 then 
             p_ndoc := PC_NDOC||'    ';
        when ln_tamdoc = 9 then 
             p_ndoc := PC_NDOC||'   ';
        when ln_tamdoc = 10 then 
             p_ndoc := PC_NDOC||'  ';
        when ln_tamdoc = 11 then 
             p_ndoc := PC_NDOC||' ';
        --else p_ndoc := PC_NDOC;
    end case;*/
  
    delete from jaqz086 a
     where a.jaqz086paic = PN_PAIS
       and a.jaqz086tdoc = PN_TDOC
       and a.jaqz086tndoc = PC_NDOC
       and a.jaqz086usr = PC_USR;
    commit;
    --l_jaqy066fecp := P_D_FECPRO;
    --l_jaqy066pano := to_number(to_char(add_months(P_D_FECPRO, -1),'RRRR'));
    --l_jaqy066pmes := to_number(to_char(add_months(P_D_FECPRO, -1),'MM'));  
  
    Regla := 1626;
  
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
        pq_cr_segmentacion_mype22.sp_cr_cargar_variables_NS(P_D_FECPRO => P_D_FECPRO,
                                                            P_N_PAIS   => la_JAQZ082pais(c),
                                                            P_N_TDOC   => la_JAQZ082tdoc(c),
                                                            P_C_NDOC   => la_JAQZ082ndoc(c),
                                                            P_C_USR    => PC_USR,
                                                            p_a_nomvar => la_nomvar,
                                                            p_a_valvar => la_valvar,
                                                            p_n_var    => ln_var);
        SegmentoRegla := null;
        pq_cr_segmentacion_mype22.sp_cr_evalua_clientes_1_NS(P_N_REGLA   => Regla,
                                                             P_A_NOMVAR  => la_nomvar,
                                                             P_A_VALVAR  => la_valvar,
                                                             P_N_VAR     => ln_var,
                                                             P_A_REGLAS  => la_reglas,
                                                             P_N_REG     => ln_reg,
                                                             p_c_retorno => SegmentoRegla);      
        Tp1cod      := 1;
        Tp1cod1     := 10823;
        Tp1corr1    := 2;
        Tp1corr2    := 13; -- Equivalencia resultado reglas - calificacion
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
        
          insert into jaqz086
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
  
  END sp_cr_NS_LINEA;
  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_cargar_variables_NS(P_D_FECPRO IN DATE,
                                      P_N_PAIS   IN JAQZ082.JAQZ082PAIS%type,
                                      P_N_TDOC   IN JAQZ082.JAQZ082TDOC%type,
                                      P_C_NDOC   IN JAQZ082.JAQZ082NDOC%type,
                                      P_C_USR    IN JAQZ082.JAQZ082USR%type,
                                      p_a_nomvar out pq_cr_segmentacion_mype22.tp_nomvar,
                                      p_a_valvar out pq_cr_segmentacion_mype22.tp_valvar,
                                      p_n_var    out number) is
  
    cursor c_cliente is
      select jaqz082fech,
             jaqz082pais,
             jaqz082tdoc,
             jaqz082ndoc,
             jaqz082var1,
             jaqz082var2,
             jaqz082var3,
             jaqz082var4,
             jaqz082var5,
             jaqz082var6,
             jaqz082var7,
             jaqz082var8,
             jaqz082var9,
             jaqz082var10,
             jaqz082var11,
             jaqz082var12,
             jaqz082var13,
             jaqz082var14,
             jaqz082var15,
             jaqz082var16,
             jaqz082var17,
             jaqz082var18,
             jaqz082var19,
             jaqz082var20,
             jaqz082var21,
             jaqz082var22,
             jaqz082var23,
             jaqz082var24,
             jaqz082var25,
             jaqz082var26,
             jaqz082var27,
             jaqz082var28,
             jaqz082var29,
             jaqz082var30,
             jaqz082var31,
             jaqz082var32,
             jaqz082var33,
             jaqz082var34,
             jaqz082var35,
             jaqz082var36,
             jaqz082var37,
             jaqz082var38,
             jaqz082var39,
             jaqz082var40
        from jaqz082
       where jaqz082fech = P_D_FECPRO
         and jaqz082pais = P_N_PAIS
         and jaqz082tdoc = P_N_TDOC
         and jaqz082ndoc = P_C_NDOC
         and jaqz082usr = P_C_USR;
    ln_tmpnum number(3);
  
  begin
  
    for cli in c_cliente loop
      -- Cargando Variables Resuletas
      if trim(cli.jaqz082var1) is not null then
        p_n_var := 1;
        ln_tmpnum := instr(cli.jaqz082var1, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var1, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var1, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var2) is not null then
        p_n_var := 2;
        ln_tmpnum := instr(cli.jaqz082var2, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var2, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var2, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var3) is not null then
        p_n_var := 3;
        ln_tmpnum := instr(cli.jaqz082var3, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var3, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var3, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var4) is not null then
        p_n_var := 4;
        ln_tmpnum := instr(cli.jaqz082var4, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var4, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var4, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var5) is not null then
        p_n_var := 5;
        ln_tmpnum := instr(cli.jaqz082var5, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var5, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var5, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var6) is not null then
        p_n_var := 6;
        ln_tmpnum := instr(cli.jaqz082var6, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var6, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var6, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var7) is not null then
        p_n_var := 7;
        ln_tmpnum := instr(cli.jaqz082var7, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var7, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var7, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var8) is not null then
        p_n_var := 8;
        ln_tmpnum := instr(cli.jaqz082var8, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var8, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var8, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var9) is not null then
        p_n_var := 9;
        ln_tmpnum := instr(cli.jaqz082var9, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var9, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var9, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var10) is not null then
        p_n_var := 10;
        ln_tmpnum := instr(cli.jaqz082var10, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var10, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var10, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var11) is not null then
        p_n_var := 11;
        ln_tmpnum := instr(cli.jaqz082var11, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var11, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var11, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var12) is not null then
        p_n_var := 12;
        ln_tmpnum := instr(cli.jaqz082var12, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var12, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var12, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var13) is not null then
        p_n_var := 13;
        ln_tmpnum := instr(cli.jaqz082var13, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var13, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var13, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var14) is not null then
        p_n_var := 14;
        ln_tmpnum := instr(cli.jaqz082var14, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var14, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var14, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var15) is not null then
        p_n_var := 15;
        ln_tmpnum := instr(cli.jaqz082var15, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var15, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var15, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var16) is not null then
        p_n_var := 16;
        ln_tmpnum := instr(cli.jaqz082var16, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var16, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var16, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var17) is not null then
        p_n_var := 17;
        ln_tmpnum := instr(cli.jaqz082var17, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var17, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var17, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var18) is not null then
        p_n_var := 18;
        ln_tmpnum := instr(cli.jaqz082var18, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var18, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var18, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var19) is not null then
        p_n_var := 19;
        ln_tmpnum := instr(cli.jaqz082var19, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var19, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var19, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var20) is not null then
        p_n_var := 20;
        ln_tmpnum := instr(cli.jaqz082var20, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var20, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var20, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var21) is not null then
        p_n_var := 21;
        ln_tmpnum := instr(cli.jaqz082var21, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var21, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var21, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var22) is not null then
        p_n_var := 22;
        ln_tmpnum := instr(cli.jaqz082var22, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var22, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var22, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var23) is not null then
        p_n_var := 23;
        ln_tmpnum := instr(cli.jaqz082var23, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var23, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var23, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var24) is not null then
        p_n_var := 24;
        ln_tmpnum := instr(cli.jaqz082var24, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var24, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var24, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var25) is not null then
        p_n_var := 25;
        ln_tmpnum := instr(cli.jaqz082var25, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var25, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var25, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var26) is not null then
        p_n_var := 26;
        ln_tmpnum := instr(cli.jaqz082var26, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var26, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var26, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var27) is not null then
        p_n_var := 27;
        ln_tmpnum := instr(cli.jaqz082var27, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var27, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var27, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var28) is not null then
        p_n_var := 28;
        ln_tmpnum := instr(cli.jaqz082var28, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var28, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var28, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var29) is not null then
        p_n_var := 29;
        ln_tmpnum := instr(cli.jaqz082var29, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var29, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var29, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var30) is not null then
        p_n_var := 30;
        ln_tmpnum := instr(cli.jaqz082var30, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var30, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var30, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var31) is not null then
        p_n_var := 31;
        ln_tmpnum := instr(cli.jaqz082var31, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var31, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var31, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var32) is not null then
        p_n_var := 32;
        ln_tmpnum := instr(cli.jaqz082var32, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var32, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var32, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var33) is not null then
        p_n_var := 33;
        ln_tmpnum := instr(cli.jaqz082var33, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var33, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var33, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var34) is not null then
        p_n_var := 34;
        ln_tmpnum := instr(cli.jaqz082var34, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var34, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var34, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var35) is not null then
        p_n_var := 35;
        ln_tmpnum := instr(cli.jaqz082var35, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var35, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var35, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var36) is not null then
        p_n_var := 36;
        ln_tmpnum := instr(cli.jaqz082var36, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var36, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var36, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var37) is not null then
        p_n_var := 37;
        ln_tmpnum := instr(cli.jaqz082var37, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var37, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var37, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var38) is not null then
        p_n_var := 38;
        ln_tmpnum := instr(cli.jaqz082var38, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var38, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var38, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var39) is not null then
        p_n_var := 39;
        ln_tmpnum := instr(cli.jaqz082var39, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var39, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var39, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz082var40) is not null then
        p_n_var := 40;
        ln_tmpnum := instr(cli.jaqz082var40, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz082var40, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz082var40, ln_tmpnum + 1);
      end if;
    
    end loop;
  
  end sp_cr_cargar_variables_NS;
  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_evalua_clientes_1_NS(P_N_REGLA   IN NUMBER,
                                       P_A_NOMVAR  IN pq_cr_segmentacion_mype22.tp_nomvar,
                                       P_A_VALVAR  IN pq_cr_segmentacion_mype22.tp_valvar,
                                       P_N_VAR     IN number,
                                       P_A_REGLAS  in pq_cr_segmentacion_mype22.tb_reglas,
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
    la_nomvar      pq_cr_segmentacion_mype22.tp_nomvar;
    la_valvar      pq_cr_segmentacion_mype22.tp_valvar;
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
    la_reglas      pq_cr_segmentacion_mype22.tb_reglas;
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
         and Tp1corr1 = 40
         and tp1corr2 = 1
         and tp1corr3 = 3;
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
      -- Evaluando Variables
      ResReglaGrupo := 'S';
    
      WHILE la_reglas(ln_ind).RNG49COD = Regla LOOP
      
        --DBMS_OUTPUT.put_line('RNG50GRP: ' || la_reglas(ln_ind).RNG50GRP);          
        If la_reglas(ln_ind).RNG50GRP <> l_RNG50Grp then
    
          If ResReglaGrupo = 'N' And la_reglas(ln_ind).RNG50GRP = 999 then

            p_c_retorno := la_reglas(ln_ind).RNG50Ret;                   
            Exit;
          End If;
        
          If ResReglaGrupo = 'S' then
            p_c_retorno := l_RNG50Ret;
            --DBMS_OUTPUT.put_line('------- si se cumple');
            --DBMS_OUTPUT.put_line('la_reglas(ln_ind).RNG50GRP: ' || la_reglas(ln_ind).RNG50GRP);
            --DBMS_OUTPUT.put_line('ResReglaGrupo: ' || ResReglaGrupo);
            --DBMS_OUTPUT.put_line('p_c_retorno tru: ' || p_c_retorno);
            --DBMS_OUTPUT.put_line('------- ');
            Exit;
          Else
            l_RNG50Grp := la_reglas(ln_ind).RNG50GRP;
            l_RNG50Ret := la_reglas(ln_ind).RNG50Ret;
            --DBMS_OUTPUT.put_line('------- no se cumple ');
            --DBMS_OUTPUT.put_line('ResReglaGrupo: ' || ResReglaGrupo);
            --DBMS_OUTPUT.put_line('------- ');
            --DBMS_OUTPUT.put_line('p_c_retorno tru siguiente: ' || l_RNG50Ret);
            --DBMS_OUTPUT.put_line('------- ');
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
          SegmentoRegla2 := null;
          pq_cr_segmentacion_mype22.sp_cr_evalua_clientes_2_NS(P_N_REGLA   => Regla2,
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
        --lc_valResuelto := REPLACE(lc_valResuelto,'.',','); --apachecoh 2022.06.03
        --l_RNG51Val := REPLACE(l_RNG51Val,'.',','); --apachecoh 2022.06.03
        
        --DBMS_OUTPUT.put_line('la_reglas(ln_ind).RNG68ATR: ' || la_reglas(ln_ind).RNG68ATR);
        --DBMS_OUTPUT.put_line('lc_valResuelto: ' || lc_valResuelto);
        --DBMS_OUTPUT.put_line('l_RNG51OPE: ' || l_RNG51OPE);
        --DBMS_OUTPUT.put_line('l_RNG51Val: ' || l_RNG51Val);
        Case l_RNG51OPE
          When '>=' then
            ln_NumTmp1 := to_number(lc_valResuelto);
            ln_NumTmp2 := to_number(l_RNG51Val);
            If ln_NumTmp1 < ln_NumTmp2 then
              ResReglaGrupo := 'N';
            End If;
          
          When '>' then
            ln_NumTmp1 := to_number(lc_valResuelto);
            ln_NumTmp2 := to_number(l_RNG51Val);
            If ln_NumTmp1 <= ln_NumTmp2 then
              ResReglaGrupo := 'N';
            End If;
          
          When '<=' then
            ln_NumTmp1 := to_number(lc_valResuelto);
            ln_NumTmp2 := to_number(l_RNG51Val);
            If ln_NumTmp1 > ln_NumTmp2 then
              ResReglaGrupo := 'N';
            End If;
          
          When '<' then
            ln_NumTmp1 := to_number(lc_valResuelto);
            ln_NumTmp2 := to_number(l_RNG51Val);
            If ln_NumTmp1 >= ln_NumTmp2 then
              ResReglaGrupo := 'N';
            End If;
          
          When '=' then     
            If lc_valResuelto <> l_RNG51Val then
              ResReglaGrupo := 'N';
            End If;
          
          When '<>' then       
            If lc_valResuelto = l_RNG51Val then
              ResReglaGrupo := 'N';
            End If;
          
          When 'EN' then
            ResReglaLista := 'N';
            -- valores de evaluacion lista
            For lis in c_lista(la_reglas (ln_ind).RNG49COD,
                               l_RNG50Grp,
                               la_reglas (ln_ind).RNG51COD) loop
              l_RNG67val := trim(lis.rng67val);
              If lc_valResuelto = l_RNG67val then
                ResReglaLista := 'S';
                Exit;
              End If;
            End Loop;
            If ResReglaLista = 'N' then
              ResReglaGrupo := 'N';
            End If;
          
          When 'NE' then
            ResReglaLista := 'N';
            For lis in c_lista(la_reglas (ln_ind).RNG49COD,
                               l_RNG50Grp,
                               la_reglas (ln_ind).RNG51COD) loop
              l_RNG67val := trim(lis.rng67val);
              If lc_valResuelto = l_RNG67val then
                ResReglaLista := 'S';
                Exit;
              End If;
            End Loop;
            If ResReglaLista = 'S' then
              ResReglaGrupo := 'N';
            End If;
          
          Else
            ResReglaGrupo := 'N'; --faltan variaciones de like y not like
        
        End Case;
      
        --DBMS_OUTPUT.put_line('ResReglaGrupo: ' || ResReglaGrupo);
        --END IF; -- regla evaluada
        ln_ind := ln_ind + 1;
      
      END LOOP; -- reglas
    
    End If; -- existe grupo
  
  END sp_cr_evalua_clientes_1_NS;
  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_evalua_clientes_2_NS(P_N_REGLA   IN NUMBER,
                                       P_A_NOMVAR  IN pq_cr_segmentacion_mype22.tp_nomvar,
                                       P_A_VALVAR  IN pq_cr_segmentacion_mype22.tp_valvar,
                                       P_N_VAR     IN number,
                                       P_A_REGLAS  in pq_cr_segmentacion_mype22.tb_reglas,
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
    la_nomvar      pq_cr_segmentacion_mype22.tp_nomvar;
    la_valvar      pq_cr_segmentacion_mype22.tp_valvar;
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
    la_reglas  pq_cr_segmentacion_mype22.tb_reglas;
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
          If ResReglaGrupo = 'N' And la_reglas(ln_ind).RNG50GRP = 999 then
            p_c_retorno   := la_reglas(ln_ind).RNG50Ret;
            ResReglaGrupo := 'S';                  
            Exit;
          End If;
        
          If ResReglaGrupo = 'S' then
            p_c_retorno   := l_RNG50Ret;
            ResReglaGrupo := 'S';
            Exit;
          Else
            --evaluar el siguiente grupo de la regla
            l_RNG50Grp := la_reglas(ln_ind).RNG50GRP;
            l_RNG50Ret := la_reglas(ln_ind).RNG50Ret;
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
        --pq_cr_segmentacion_mype22.sp_cr_evalua_clientes_3_NS( P_N_REGLA => Regla3,
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
            ln_NumTmp1 := to_number(lc_valResuelto);
            ln_NumTmp2 := to_number(l_RNG51Val);
            If ln_NumTmp1 < ln_NumTmp2 then
              ResReglaGrupo := 'N';
            End If;
          
          When '>' then
            ln_NumTmp1 := to_number(lc_valResuelto);
            ln_NumTmp2 := to_number(l_RNG51Val);
            If ln_NumTmp1 <= ln_NumTmp2 then
              ResReglaGrupo := 'N';
            End If;
          
          When '<=' then
            ln_NumTmp1 := to_number(lc_valResuelto);
            ln_NumTmp2 := to_number(l_RNG51Val);
            If ln_NumTmp1 > ln_NumTmp2 then
              ResReglaGrupo := 'N';
            End If;
          
          When '<' then
            ln_NumTmp1 := to_number(lc_valResuelto);
            ln_NumTmp2 := to_number(l_RNG51Val);
            If ln_NumTmp1 >= ln_NumTmp2 then
              ResReglaGrupo := 'N';
            End If;
          
          When '=' then          
            If lc_valResuelto <> l_RNG51Val then
              ResReglaGrupo := 'N';
            End If;
          
          When '<>' then          
            If lc_valResuelto = l_RNG51Val then
              ResReglaGrupo := 'N';
            End If;
          
          When 'EN' then
            ResReglaLista := 'N';
            -- valores de evaluacion lista
            For lis in c_lista(la_reglas (ln_ind).RNG49COD,
                               l_RNG50Grp,
                               la_reglas (ln_ind).RNG51COD) loop
              l_RNG67val := trim(lis.rng67val);
              If lc_valResuelto = l_RNG67val then
                ResReglaLista := 'S';
                Exit;
              End If;
            End Loop;
            If ResReglaLista = 'N' then
              ResReglaGrupo := 'N';
            End If;
          
          When 'NE' then
            ResReglaLista := 'N';
            For lis in c_lista(la_reglas (ln_ind).RNG49COD,
                               l_RNG50Grp,
                               la_reglas (ln_ind).RNG51COD) loop
              l_RNG67val := trim(lis.rng67val);
              If lc_valResuelto = l_RNG67val then
                ResReglaLista := 'S';
                Exit;
              End If;
            End Loop;
            If ResReglaLista = 'S' then
              ResReglaGrupo := 'N';
            End If;
          
          Else
            ResReglaGrupo := 'N'; --faltan variaciones de like y not like  
        
        End Case;
      
        ln_ind := ln_ind + 1;
      
      END LOOP; -- reglas
    
    End If; -- existe grupo
  
  END sp_cr_evalua_clientes_2_NS;
 
end PQ_CR_SEGMENTACION_MYPE22;
/

