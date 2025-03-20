create or replace package pq_cr_res_segmentacion_micro is

  -- Author  : APACHECOH
  -- Created : 01/06/2022 16:27:59
  -- Purpose : Almacenamientos de Inclusivos
  
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
                                      P_N_PAIS   IN AQPB914.AQPB914PAIS%type,
                                      P_N_TDOC   IN AQPB914.AQPB914TDOC%type,
                                      P_C_NDOC   IN AQPB914.AQPB914NDOC%type,
                                      P_C_USR    IN AQPB914.AQPB914USR%type,
                                      p_a_nomvar out pq_cr_res_segmentacion_micro.tp_nomvar,
                                      p_a_valvar out pq_cr_res_segmentacion_micro.tp_valvar,
                                      p_n_var    out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_evalua_clientes_1_NS(P_N_REGLA   IN NUMBER,
                                       P_A_NOMVAR  IN pq_cr_res_segmentacion_micro.tp_nomvar,
                                       P_A_VALVAR  IN pq_cr_res_segmentacion_micro.tp_valvar,
                                       P_N_VAR     IN number,
                                       P_A_REGLAS  in pq_cr_res_segmentacion_micro.tb_reglas,
                                       P_N_REG     in number,
                                       p_c_retorno out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_evalua_clientes_2_NS(P_N_REGLA   IN NUMBER,
                                       P_A_NOMVAR  IN pq_cr_res_segmentacion_micro.tp_nomvar,
                                       P_A_VALVAR  IN pq_cr_res_segmentacion_micro.tp_valvar,
                                       P_N_VAR     IN number,
                                       P_A_REGLAS  in pq_cr_res_segmentacion_micro.tb_reglas,
                                       P_N_REG     in number,
                                       p_c_retorno out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure Sp_cr_nroEntidades (pn_pai in number,
                            pn_tdo in number,
                            pc_ndo in char,
                            ln_CntInsRep out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                            
  Function Fn_cant_instit(TipDocSbs in char,
                        pc_ndo in char,
                        pd_fecRcc in date,
                        lc_tiper in char
                        )return number;                            
                            
end pq_cr_res_segmentacion_micro;
/

create or replace package body pq_cr_res_segmentacion_micro is

-- *****************************************************************
-- Sistema                    : BANTOTAL
-- Módulo                     : Créditos - Activas
-- Versión                    : 1.0
-- Fecha de Creación          : 2022.06.27
-- Autor de Creación          : Alonso Pacheco Huachaca
-- Uso                        : Proceso de Segmentación Micro
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
  
    cursor c_clientes(p_fecpro date /*,p_ndoc varchar2*/ /*, p_anio number, p_mes number*/) is

      select 
       AQPB914pais, AQPB914tdoc, AQPB914ndoc
        from AQPB914 l
       where 
       --AQPB914fech = P_D_FECPRO and 
           l.AQPB914pais = PN_PAIS
       and l.AQPB914tdoc = PN_TDOC
       and l.AQPB914ndoc = PC_NDOC
       and l.AQPB914usr = PC_USR;
  
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
      -- where t.RNG49Cod in (1620, 1621) mod@abr 20170110
       where t.RNG49Cod in (1623) --mod@abr 20170110
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
    la_nomvar     pq_cr_res_segmentacion_micro.tp_nomvar;
    la_valvar     pq_cr_res_segmentacion_micro.tp_valvar;
    la_nomnul     pq_cr_res_segmentacion_micro.tp_nomvar;
    la_valnul     pq_cr_res_segmentacion_micro.tp_valvar;
    ln_var        number(3) := 0;
    Tp1cod        fst198.tp1cod%type;
    Tp1cod1       fst198.tp1cod1%type;
    Tp1corr1      fst198.tp1corr1%type;
    Tp1corr2      fst198.tp1corr2%type;
    Tp1desc       fst198.tp1desc%type;
    AQPB916CCAL   AQPB916.AQPB916ccal%type;
    --l_jaqy066pano  jaqy066.jaqy066pano%type;
    --l_jaqy066pmes  jaqy066.jaqy066pmes%type;
    l_AQPB915paic  AQPB915.AQPB915paic%type;
    l_AQPB915tdoc  AQPB915.AQPB915tdoc%type;
    l_AQPB915tndoc AQPB915.AQPB915tndoc%type;
    l_AQPB915calf  AQPB915.AQPB915calf%type;
    --l_jaqy066fecp  jaqy066.jaqy066fecp%type;
    --l_jaqy066horp  jaqy066.jaqy066horp%type;
    l_AQPB915tcal AQPB915.AQPB915tcal%type;
  
    TYPE tp_pais IS TABLE OF AQPB914.AQPB914pais%type INDEX BY BINARY_INTEGER;
    TYPE tp_tdoc IS TABLE OF AQPB914.AQPB914tdoc%type INDEX BY BINARY_INTEGER;
    TYPE tp_ndoc IS TABLE OF AQPB914.AQPB914ndoc%type INDEX BY BINARY_INTEGER;
  
    la_AQPB914pais tp_pais;
    la_AQPB914tdoc tp_tdoc;
    la_AQPB914ndoc tp_ndoc;
    la_reglas      pq_cr_res_segmentacion_micro.tb_reglas;
    ln_reg         number(5);
  
    --p_ndoc char(12);
    --ln_tamdoc number(2);
  BEGIN
  
--    execute immediate 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
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
  
    delete from AQPB915 a
     where a.AQPB915paic = PN_PAIS
       and a.AQPB915tdoc = PN_TDOC
       and a.AQPB915tndoc = PC_NDOC
       and a.AQPB915usr = PC_USR;
    commit;
    --l_jaqy066fecp := P_D_FECPRO;
    --l_jaqy066pano := to_number(to_char(add_months(P_D_FECPRO, -1),'RRRR'));
    --l_jaqy066pmes := to_number(to_char(add_months(P_D_FECPRO, -1),'MM'));  
  
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
      INTO la_AQPB914pais, la_AQPB914tdoc, la_AQPB914ndoc;
   
    DBMS_OUTPUT.put_line('Encontrado en la AQPB914: ' || la_AQPB914ndoc.count);
    
    IF la_AQPB914ndoc.count > 0 THEN
      FOR c IN la_AQPB914ndoc.FIRST .. la_AQPB914ndoc.LAST LOOP
      
        la_nomvar := la_nomnul;
        la_valvar := la_valnul;
        pq_cr_res_segmentacion_micro.sp_cr_cargar_variables_NS(P_D_FECPRO => P_D_FECPRO,
                                                              P_N_PAIS   => la_AQPB914pais(c),
                                                              P_N_TDOC   => la_AQPB914tdoc(c),
                                                              P_C_NDOC   => la_AQPB914ndoc(c),
                                                              P_C_USR    => PC_USR,
                                                              p_a_nomvar => la_nomvar,
                                                              p_a_valvar => la_valvar,
                                                              p_n_var    => ln_var);
                                                              
        SegmentoRegla := null;
        pq_cr_res_segmentacion_micro.sp_cr_evalua_clientes_1_NS(P_N_REGLA   => Regla,
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
        AQPB916CCAL := null;
      
        DBMS_OUTPUT.put_line('SegmentoRegla: ' || Tp1desc);
        
        For g in c_guia(Tp1cod, Tp1cod1, Tp1corr1, Tp1corr2) loop
          If g.tp1desc = Tp1desc Then
            AQPB916CCAL := g.tp1nro1;
          End If;
        End Loop;
      
        DBMS_OUTPUT.put_line('AQPB916CCAL: ' || AQPB916CCAL);
    
        If AQPB916CCAL is not null then
          -- Califica
          l_AQPB915paic  := la_AQPB914pais(c);
          l_AQPB915tdoc  := la_AQPB914tdoc(c);
          l_AQPB915tndoc := la_AQPB914ndoc(c);
          l_AQPB915calf  := AQPB916CCAL;
          --l_AQPB915horp := to_char(sysdate(),'HH24:MI:SS');
          l_AQPB915tcal := 'P';
        
          insert into AQPB915
            (AQPB915PAIC,
             AQPB915TDOC,
             AQPB915TNDOC,
             AQPB915CALF,
             AQPB915TCAL,
             AQPB915usr)
          values
            (l_AQPB915paic,
             l_AQPB915tdoc,
             l_AQPB915tndoc,
             l_AQPB915calf,
             l_AQPB915tcal,
             PC_USR);
          commit;
        
        End If;
      
      END LOOP; -- clientes
    END IF;
  
  END sp_cr_NS_LINEA;
  
  procedure sp_cr_cargar_variables_NS(P_D_FECPRO IN DATE,
                                      P_N_PAIS   IN AQPB914.AQPB914PAIS%type,
                                      P_N_TDOC   IN AQPB914.AQPB914TDOC%type,
                                      P_C_NDOC   IN AQPB914.AQPB914NDOC%type,
                                      P_C_USR    IN AQPB914.AQPB914USR%type,
                                      p_a_nomvar out pq_cr_res_segmentacion_micro.tp_nomvar,
                                      p_a_valvar out pq_cr_res_segmentacion_micro.tp_valvar,
                                      p_n_var    out number) is
  
    cursor c_cliente is
      select AQPB914fech,
             AQPB914pais,
             AQPB914tdoc,
             AQPB914ndoc,
             AQPB914var1,
             AQPB914var2,
             AQPB914var3,
             AQPB914var4,
             AQPB914var5,
             AQPB914var6,
             AQPB914var7,
             AQPB914var8,
             AQPB914var9,
             AQPB914var10,
             AQPB914var11,
             AQPB914var12,
             AQPB914var13,
             AQPB914var14,
             AQPB914var15,
             AQPB914var16,
             AQPB914var17,
             AQPB914var18,
             AQPB914var19,
             AQPB914var20,
             AQPB914var21,
             AQPB914var22,
             AQPB914var23,
             AQPB914var24,
             AQPB914var25,
             AQPB914var26,
             AQPB914var27,
             AQPB914var28,
             AQPB914var29,
             AQPB914var30,
             AQPB914var31,
             AQPB914var32,
             AQPB914var33,
             AQPB914var34,
             AQPB914var35,
             AQPB914var36,
             AQPB914var37,
             AQPB914var38,
             AQPB914var39,
             AQPB914var40
        from AQPB914
       where /*AQPB914fech = P_D_FECPRO
         and*/ AQPB914pais = P_N_PAIS
         and AQPB914tdoc = P_N_TDOC
         and AQPB914ndoc = P_C_NDOC
         and AQPB914usr = P_C_USR;
    ln_tmpnum number(3);
  
  begin
  
    for cli in c_cliente loop
      -- Cargando Variables Resuletas
      if trim(cli.AQPB914var1) is not null then
        p_n_var := 1;
        ln_tmpnum := instr(cli.AQPB914var1, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var1, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var1, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var2) is not null then
        p_n_var := 2;
        ln_tmpnum := instr(cli.AQPB914var2, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var2, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var2, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var3) is not null then
        p_n_var := 3;
        ln_tmpnum := instr(cli.AQPB914var3, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var3, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var3, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var4) is not null then
        p_n_var := 4;
        ln_tmpnum := instr(cli.AQPB914var4, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var4, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var4, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var5) is not null then
        p_n_var := 5;
        ln_tmpnum := instr(cli.AQPB914var5, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var5, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var5, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var6) is not null then
        p_n_var := 6;
        ln_tmpnum := instr(cli.AQPB914var6, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var6, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var6, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var7) is not null then
        p_n_var := 7;
        ln_tmpnum := instr(cli.AQPB914var7, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var7, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var7, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var8) is not null then
        p_n_var := 8;
        ln_tmpnum := instr(cli.AQPB914var8, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var8, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var8, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var9) is not null then
        p_n_var := 9;
        ln_tmpnum := instr(cli.AQPB914var9, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var9, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var9, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var10) is not null then
        p_n_var := 10;
        ln_tmpnum := instr(cli.AQPB914var10, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var10, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var10, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var11) is not null then
        p_n_var := 11;
        ln_tmpnum := instr(cli.AQPB914var11, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var11, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var11, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var12) is not null then
        p_n_var := 12;
        ln_tmpnum := instr(cli.AQPB914var12, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var12, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var12, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var13) is not null then
        p_n_var := 13;
        ln_tmpnum := instr(cli.AQPB914var13, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var13, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var13, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var14) is not null then
        p_n_var := 14;
        ln_tmpnum := instr(cli.AQPB914var14, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var14, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var14, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var15) is not null then
        p_n_var := 15;
        ln_tmpnum := instr(cli.AQPB914var15, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var15, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var15, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var16) is not null then
        p_n_var := 16;
        ln_tmpnum := instr(cli.AQPB914var16, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var16, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var16, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var17) is not null then
        p_n_var := 17;
        ln_tmpnum := instr(cli.AQPB914var17, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var17, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var17, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var18) is not null then
        p_n_var := 18;
        ln_tmpnum := instr(cli.AQPB914var18, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var18, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var18, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var19) is not null then
        p_n_var := 19;
        ln_tmpnum := instr(cli.AQPB914var19, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var19, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var19, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var20) is not null then
        p_n_var := 20;
        ln_tmpnum := instr(cli.AQPB914var20, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var20, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var20, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var21) is not null then
        p_n_var := 21;
        ln_tmpnum := instr(cli.AQPB914var21, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var21, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var21, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var22) is not null then
        p_n_var := 22;
        ln_tmpnum := instr(cli.AQPB914var22, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var22, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var22, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var23) is not null then
        p_n_var := 23;
        ln_tmpnum := instr(cli.AQPB914var23, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var23, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var23, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var24) is not null then
        p_n_var := 24;
        ln_tmpnum := instr(cli.AQPB914var24, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var24, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var24, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var25) is not null then
        p_n_var := 25;
        ln_tmpnum := instr(cli.AQPB914var25, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var25, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var25, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var26) is not null then
        p_n_var := 26;
        ln_tmpnum := instr(cli.AQPB914var26, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var26, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var26, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var27) is not null then
        p_n_var := 27;
        ln_tmpnum := instr(cli.AQPB914var27, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var27, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var27, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var28) is not null then
        p_n_var := 28;
        ln_tmpnum := instr(cli.AQPB914var28, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var28, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var28, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var29) is not null then
        p_n_var := 29;
        ln_tmpnum := instr(cli.AQPB914var29, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var29, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var29, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var30) is not null then
        p_n_var := 30;
        ln_tmpnum := instr(cli.AQPB914var30, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var30, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var30, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var31) is not null then
        p_n_var := 31;
        ln_tmpnum := instr(cli.AQPB914var31, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var31, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var31, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var32) is not null then
        p_n_var := 32;
        ln_tmpnum := instr(cli.AQPB914var32, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var32, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var32, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var33) is not null then
        p_n_var := 33;
        ln_tmpnum := instr(cli.AQPB914var33, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var33, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var33, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var34) is not null then
        p_n_var := 34;
        ln_tmpnum := instr(cli.AQPB914var34, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var34, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var34, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var35) is not null then
        p_n_var := 35;
        ln_tmpnum := instr(cli.AQPB914var35, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var35, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var35, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var36) is not null then
        p_n_var := 36;
        ln_tmpnum := instr(cli.AQPB914var36, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var36, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var36, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var37) is not null then
        p_n_var := 37;
        ln_tmpnum := instr(cli.AQPB914var37, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var37, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var37, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var38) is not null then
        p_n_var := 38;
        ln_tmpnum := instr(cli.AQPB914var38, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var38, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var38, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var39) is not null then
        p_n_var := 39;
        ln_tmpnum := instr(cli.AQPB914var39, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var39, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var39, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPB914var40) is not null then
        p_n_var := 40;
        ln_tmpnum := instr(cli.AQPB914var40, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPB914var40, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPB914var40, ln_tmpnum + 1);
      end if;
    
    end loop;
  
  end sp_cr_cargar_variables_NS;
  
  procedure sp_cr_evalua_clientes_1_NS(P_N_REGLA   IN NUMBER,
                                       P_A_NOMVAR  IN pq_cr_res_segmentacion_micro.tp_nomvar,
                                       P_A_VALVAR  IN pq_cr_res_segmentacion_micro.tp_valvar,
                                       P_N_VAR     IN number,
                                       P_A_REGLAS  in pq_cr_res_segmentacion_micro.tb_reglas,
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
    la_nomvar      pq_cr_res_segmentacion_micro.tp_nomvar;
    la_valvar      pq_cr_res_segmentacion_micro.tp_valvar;
    ln_var         number(3) := 0;
    lc_valResuelto varchar2(30);
    i              number(5);
    ln_NumTmp1     number(10, 2);
    ln_NumTmp2     number(10, 2);
    --l_RNG68Tda     frng68.rng68tda%type;
    SegmentoRegla2 frng51.rng51val%type;
    l_RNG51Val     varchar2(30);
    l_RNG67val     varchar2(30);
    l_RNG51OPE     varchar2(2);
    la_reglas      pq_cr_res_segmentacion_micro.tb_reglas;
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
         and tp1corr3 = 2;
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
    
      --DBMS_OUTPUT.put_line('l_RNG50Grp ' || l_RNG50Grp);
      --DBMS_OUTPUT.put_line('l_RNG50Ret ' || l_RNG50Ret);
      WHILE la_reglas(ln_ind).RNG49COD = Regla LOOP
      
        --DBMS_OUTPUT.put_line('RNG50GRP: ' || la_reglas(ln_ind).RNG50GRP);
          
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
            DBMS_OUTPUT.put_line('------- si se cumple');
            --DBMS_OUTPUT.put_line('la_reglas(ln_ind).RNG50GRP: ' || la_reglas(ln_ind).RNG50GRP);
            DBMS_OUTPUT.put_line('ResReglaGrupo: ' || ResReglaGrupo);
            DBMS_OUTPUT.put_line('p_c_retorno tru: ' || p_c_retorno);
            DBMS_OUTPUT.put_line('------- ');
            --ResReglaGrupo := 'S'; 
            --Msg(p_c_retorno)
            Exit;
          Else
            --evaluar el siguiente grupo de la regla
            --Msg('cambio de grupo')
            l_RNG50Grp := la_reglas(ln_ind).RNG50GRP;
            l_RNG50Ret := la_reglas(ln_ind).RNG50Ret;
            DBMS_OUTPUT.put_line('------- no se cumple ');
            DBMS_OUTPUT.put_line('ResReglaGrupo: ' || ResReglaGrupo);
            --DBMS_OUTPUT.put_line('la_reglas(ln_ind).RNG50GRP: ' || la_reglas(ln_ind).RNG50GRP);
            DBMS_OUTPUT.put_line('------- ');
            DBMS_OUTPUT.put_line('p_c_retorno tru siguiente: ' || l_RNG50Ret);
            DBMS_OUTPUT.put_line('------- ');
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
        If la_reglas(ln_ind).RNG68ATR = 'EXP1623' then
        
          Regla2 := to_number(substr(la_reglas(ln_ind).RNG68ATR, 4, 4));
          --Msg('rutina regla anidada ' + Str(&Regla2))
          SegmentoRegla2 := null;
          pq_cr_res_segmentacion_micro.sp_cr_evalua_clientes_2_NS(P_N_REGLA   => Regla2,
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
        
        DBMS_OUTPUT.put_line('la_reglas(ln_ind).RNG68ATR: ' || la_reglas(ln_ind).RNG68ATR);
        DBMS_OUTPUT.put_line('lc_valResuelto: ' || lc_valResuelto);
        DBMS_OUTPUT.put_line('l_RNG51OPE: ' || l_RNG51OPE);
        DBMS_OUTPUT.put_line('l_RNG51Val: ' || l_RNG51Val);
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
      
        DBMS_OUTPUT.put_line('ResReglaGrupo: ' || ResReglaGrupo);
        --END IF; -- regla evaluada
        ln_ind := ln_ind + 1;
      
      END LOOP; -- reglas
    
    End If; -- existe grupo
  
  END sp_cr_evalua_clientes_1_NS;

  procedure sp_cr_evalua_clientes_2_NS(P_N_REGLA   IN NUMBER,
                                       P_A_NOMVAR  IN pq_cr_res_segmentacion_micro.tp_nomvar,
                                       P_A_VALVAR  IN pq_cr_res_segmentacion_micro.tp_valvar,
                                       P_N_VAR     IN number,
                                       P_A_REGLAS  in pq_cr_res_segmentacion_micro.tb_reglas,
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
    la_nomvar      pq_cr_res_segmentacion_micro.tp_nomvar;
    la_valvar      pq_cr_res_segmentacion_micro.tp_valvar;
    ln_var         number(3) := 0;
    lc_valResuelto varchar2(30);
    i              number(3);
    ln_NumTmp1     number(10, 2);
    ln_NumTmp2     number(10, 2);
    --l_RNG68Tda     frng68.rng68tda%type;
    l_RNG51Val     varchar2(30);
    l_RNG67val     varchar2(30);
    --SegmentoRegla3 frng51.rng51val%type;
    --Regla3 frng51.rng49cod%type;
    l_RNG51OPE varchar2(2);
    la_reglas  pq_cr_res_segmentacion_micro.tb_reglas;
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
        --pq_cr_res_segmentacion_micro.sp_cr_evalua_clientes_3_NS( P_N_REGLA => Regla3,
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

Procedure Sp_cr_nroEntidades (pn_pai in number,
                            pn_tdo in number,
                            pc_ndo in char,
                            ln_CntInsRep out number) is

ln_CntOpeRccCy number(10);
ln_CntOpeRccTi number(10);
DocSbs number(10);
DocSbsTit char(1);
fecNum_rcc number(9);
fec_rcc date;
DocSbs_Cyg number(10);
DocSbsCyg char(1);
ln_paiC  number(3);
ln_tdoC  number(2);
lc_ndoC  char(12);
ln_Rpccyg number(2);
lc_tiper_Cyg char(1);
lc_tiper char(1);

begin

--***************CANT_ENTIDADES**********----
    
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
     fec_rcc := to_date(fecNum_rcc,'dd/mm/yyyy');
     
     --tipo de persona
     begin
         select a.petipo
           into lc_tiper
           from fsd001 a
          where a.pepais =pn_pai
            and a.petdoc =pn_tdo
            and a.pendoc =pc_ndo;
     exception
            when no_data_found then
                 lc_tiper:=null;
     end;
     
     --obtiene conyugue
       
       begin
           select a.tp1corr3 
             into ln_Rpccyg
             from fst198 a 
            where a.tp1cod = 1 
             and a.tp1cod1=10823 
             and Tp1corr1 = 3
             and Tp1corr2 = 1;
       exception
              when no_data_found then
                   ln_Rpccyg := null;
       end;
     
       begin
              select a.rppais,
                     a.rptdoc,
                     a.rpndoc
                into ln_paiC,
                     ln_tdoC,
                     lc_ndoC
                from fsr002 a
               where a.pepais = pn_pai
                 and a.petdoc = pn_tdo
                 and a.pendoc = pc_ndo
                 and a.rpccyg = ln_Rpccyg
                 and rownum   = 1;
       exception 
                 when no_data_found then
                      ln_paiC :=null;
                      ln_tdoC :=null;
                      lc_ndoC :=null;
       end;
       
       --Guia equivalencia tipo de documento conyugue
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
       
       --tipo de persona conyugue
       begin
           select a.petipo
             into lc_tiper_Cyg
             from fsd001 a
            where a.pepais =ln_paiC
              and a.petdoc =ln_tdoC
              and a.pendoc =lc_ndoC;
       exception
              when no_data_found then
                   lc_tiper_Cyg:=null;
       end;
       
    --ln_CntOpeRccTi := 0;
    ln_CntOpeRccCy := 0;
    ln_CntInsRep := 0;
    
    ln_CntOpeRccTi :=pq_cr_res_segmentacion_micro.Fn_cant_instit(DocSbsTit,
                                        pc_ndo,
                                        fec_rcc,
                                        lc_tiper);
    
    
       if lc_ndoC is not null then
         ln_CntOpeRccCy :=pq_cr_res_segmentacion_micro.Fn_cant_instit(DocSbsCyg,
                                          lc_ndoC,
                                          fec_rcc,
                                          lc_tiper_Cyg);
       end if;                                 
                                               
       ln_CntInsRep := ln_CntOpeRccTi + ln_CntOpeRccCy ;
end Sp_cr_nroEntidades;

Function Fn_cant_instit(TipDocSbs in char,
                        pc_ndo in char,
                        pd_fecRcc in date,
                        lc_tiper in char
                        )return number is
                        
ln_NumEnt number(10);
lc_CodSbs char(10);

cursor entidades(lc_CodSbs in char) is
select distinct C_CODEMP
  from CLDRCCS
 Where C_CODSBS = lc_CodSbs
   and C_CODEMP <> '00104'
   and (C_CUENTA like '14_1%'
       Or C_CUENTA like '14_2%'  
       Or C_CUENTA like '14_3%' 
       Or C_CUENTA like '14_4%'  
       Or C_CUENTA like '14_5%' 
       Or C_CUENTA like '14_6%' 
       Or C_CUENTA like '71_1%' 
       Or C_CUENTA like '71_2%' 
       Or C_CUENTA like '71_3%' 
       Or C_CUENTA like '71_4%' 
       Or C_CUENTA like '81_302%')
   and D_FECPRE = pd_fecRcc
   ;
 
              
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
            for i in entidades (lc_CodSbs) loop 
                ln_NumEnt := ln_NumEnt + 1;
                
            end loop;
         End;
      
      end;
      return ln_NumEnt;

end Fn_cant_instit;




end pq_cr_res_segmentacion_micro;
/

