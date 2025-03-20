create or replace package PQ_CR_SEGMENTACION_CONSUMO_LINEA is

  -- Author  : APACHECOH
  -- Created : 5/05/2023 16:12:58
  -- Purpose : 

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

  procedure sp_cr_NS_LINEA(P_D_FECPRO IN DATE,
                           PN_PAIS    IN NUMBER,
                           PN_TDOC    IN NUMBER,
                           PC_NDOC    IN VARCHAR2,
                           PC_USR     IN VARCHAR2,
                           PN_SEGM    OUT NUMBER,
                           PV_SEGM    OUT VARCHAR2);

  procedure sp_cr_cargar_data_cliente(P_D_FECPRO IN DATE,
                                      PN_PAIS    IN NUMBER,
                                      PN_TDOC    IN NUMBER,
                                      PC_NDOC    IN VARCHAR2,
                                      PC_USR     IN VARCHAR2);

end PQ_CR_SEGMENTACION_CONSUMO_LINEA;
/

create or replace package body PQ_CR_SEGMENTACION_CONSUMO_LINEA is

  procedure sp_cr_NS_LINEA(P_D_FECPRO in date,
                           PN_PAIS    IN NUMBER,
                           PN_TDOC    IN NUMBER,
                           PC_NDOC    IN VARCHAR2,
                           PC_USR     IN VARCHAR2,
                           PN_SEGM    OUT NUMBER,
                           PV_SEGM    OUT VARCHAR2) IS
  
    cursor c_clientes(p_fecpro date) is
      select JAQZ661pais, JAQZ661tdoc, JAQZ661ndoc
        from JAQZ661 l
       where l.JAQZ661pais = PN_PAIS
         and l.JAQZ661tdoc = PN_TDOC
         and l.JAQZ661ndoc = PC_NDOC
         and l.JAQZ661usr = PC_USR;
  
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
    la_nomvar     pq_cr_segmentacion_consumo.tp_nomvar;
    la_valvar     pq_cr_segmentacion_consumo.tp_valvar;
    la_nomnul     pq_cr_segmentacion_consumo.tp_nomvar;
    la_valnul     pq_cr_segmentacion_consumo.tp_valvar;
    ln_var        number(3) := 0;
    Tp1cod        fst198.tp1cod%type;
    Tp1cod1       fst198.tp1cod1%type;
    Tp1corr1      fst198.tp1corr1%type;
    Tp1corr2      fst198.tp1corr2%type;
    Tp1desc       fst198.tp1desc%type;
    JAQZ662CCAL   JAQZ662.JAQZ662ccal%type;
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
    la_reglas      pq_cr_segmentacion_consumo.tb_reglas;
    ln_reg         number(5);
  
    --p_ndoc char(12);
    --ln_tamdoc number(2);
  BEGIN
  
    execute immediate 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
    execute immediate 'ALTER SESSION SET OPTIMIZER_MODE=ALL_ROWS'; --jflor 2014.01.17  
    execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE'; --jflor 2014.05.05
  
    begin
      delete from JAQZ663 a
       where a.JAQZ663paic = PN_PAIS
         and a.JAQZ663tdoc = PN_TDOC
         and a.JAQZ663tndoc = PC_NDOC
         and a.JAQZ663usr = PC_USR;
      commit;
    exception
      when others then
        null;
    end;
    --l_jaqy066fecp := P_D_FECPRO;
    --l_jaqy066pano := to_number(to_char(add_months(P_D_FECPRO, -1),'RRRR'));
    --l_jaqy066pmes := to_number(to_char(add_months(P_D_FECPRO, -1),'MM'));  
  
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
  
    --carga de variables en tabla log
    begin
      PQ_CR_SEGMENTACION_CONSUMO_LINEA.sp_cr_cargar_data_cliente(P_D_FECPRO,
                                                               PN_PAIS,
                                                               PN_TDOC,
                                                               PC_NDOC,
                                                               PC_USR);
    exception
      when others then
        null;
    end;
  
    --busqueda de tabla log de variables
    OPEN c_clientes(P_D_FECPRO); -- Clientes Bulk
    FETCH c_clientes BULK COLLECT
      INTO la_JAQZ661pais, la_JAQZ661tdoc, la_JAQZ661ndoc;
  
    IF la_JAQZ661ndoc.count > 0 THEN
      FOR c IN la_JAQZ661ndoc.FIRST .. la_JAQZ661ndoc.LAST LOOP
      
        la_nomvar := la_nomnul;
        la_valvar := la_valnul;
        begin
          Pq_Cr_Segmentacion_Consumo.sp_cr_cargar_variables_NS(P_D_FECPRO => P_D_FECPRO,
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
        exception
          when others then
            null;
        end;
      
        DBMS_OUTPUT.put_line('SegmentoRegla: ' || SegmentoRegla);
      
        Tp1cod      := 1;
        Tp1cod1     := 10823;
        Tp1corr1    := 400;
        Tp1corr2    := 1; -- Equivalencia resultado reglas - calificacion
        Tp1desc     := Trim(SegmentoRegla);
        JAQZ662CCAL := null;
      
        For g in c_guia(Tp1cod, Tp1cod1, Tp1corr1, Tp1corr2) loop
          If g.tp1desc = Tp1desc Then
            JAQZ662CCAL := g.tp1nro1;
          End If;
        End Loop;
      
        PN_SEGM := 0;
        PV_SEGM := Tp1desc;
      
        If JAQZ662CCAL is not null then
          -- Califica
          l_JAQZ663paic  := la_JAQZ661pais(c);
          l_JAQZ663tdoc  := la_JAQZ661tdoc(c);
          l_JAQZ663tndoc := la_JAQZ661ndoc(c);
          l_JAQZ663calf  := JAQZ662CCAL;
          --l_JAQZ663horp := to_char(sysdate(),'HH24:MI:SS');
          l_JAQZ663tcal := 'P';
        
          begin
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
          exception
            when others then
              PN_SEGM := 0;
          end;
        
          PN_SEGM := l_JAQZ663calf; --  
        Else
          PN_SEGM := 0; --NO CALIFICA   
          PV_SEGM := 'NO PRECALIFICA';
        End If;
      
      END LOOP; -- clientes
    END IF;
  
  END sp_cr_NS_LINEA;

  Procedure sp_cr_cargar_data_cliente(P_D_FECPRO IN DATE,
                                      PN_PAIS    IN NUMBER,
                                      PN_TDOC    IN NUMBER,
                                      PC_NDOC    IN VARCHAR2,
                                      PC_USR     IN VARCHAR2) is
  
    pn_cal        number(5, 2);
    lc_fin_sobend char(1);
    lc_castigado  char(1);
    ln_histCred   number(5);
    ln_segcod     number(2);
    lc_refinan    char(1);
    ln_cal        number(5);
  
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
    ln_segmentac     number(5); --mod@abr 20201003
    ln_segpymeant    varchar2(100);
    lc_JAQZ661VAR1   varchar2(100);
    lc_JAQZ661VAR2   varchar2(100);
    lc_JAQZ661VAR3   varchar2(100);
    lc_JAQZ661VAR4   varchar2(100);
    lc_JAQZ661VAR5   varchar2(100);
    lc_JAQZ661VAR6   varchar2(100);
    lc_JAQZ661VAR7   varchar2(100);
    lc_JAQZ661VAR8   varchar2(100);
    lc_JAQZ661VAR9   varchar2(100);
    lc_JAQZ661VAR10  varchar2(100);
    lc_JAQZ661VAR11  varchar2(100);
    lc_JAQZ661VAR12  varchar2(100);
    lc_JAQZ661VAR13  varchar2(100); --mod@abr20170127
    lc_JAQZ661VAR14  varchar2(100); --mod@abr20181123
    lc_JAQZ661VAR15  varchar2(100); --mod@abr20181123
  
    lc_JAQZ661VAR16 varchar2(100); --mod@abr 20180110
    lc_JAQZ661VAR17 varchar2(100); --mod@abr 20180110
    lc_JAQZ661VAR18 varchar2(100); --mod@abr 20180110
    lc_JAQZ661VAR19 varchar2(100); --mod@abr 20180110
    lc_JAQZ661VAR20 varchar2(100); --mod@abr 20180110
    lc_JAQZ661VAR21 varchar2(100); --mod@abr 20180110
    lc_JAQZ661VAR22 varchar2(100); --mod@abr 20180110
    lc_JAQZ661VAR23 varchar2(100); --mod@abr 20180110
    lc_JAQZ661VAR24 varchar2(100); --mod@abr 20180110
    lc_JAQZ661VAR25 varchar2(100); --mod@abr 20180110
    lc_JAQZ661VAR26 varchar2(100); --mod@abr 20180110
    lc_JAQZ661VAR27 varchar2(100); --mod@abr 20180110
  
    lc_JAQZ661VAR28 varchar2(100); --mod@abr 20201003
    lc_JAQZ661VAR29 varchar2(100);
    lc_lista        char(1);
    lc_hora         char(8);
  
    ln_nrobanks number(10);
    ln_promMax  number(10, 6);
    ln_calNor   number(5, 2);
    ln_porcUso  number(20, 6);
  
    --apachecoh 2023.02.23
    ln_afdatr    number(17, 2);
    ln_afcalif   number(10, 2);
    ln_afcalif2  number(10, 2);
    ln_afecta    number(5);
    lv_afecta    varchar2(50);
    lv_ndocum    varchar2(12);
    lv_user      varchar2(10);
    ln_instancia number(10);
  
    ln_CntAntRcc number(10);
    ln_cal2      number(5, 2); --mod@abr 20190827
    lc_FlgVen    char(1); --mod@abr 20190827
  
    ERR_MSG VARCHAR2(250);
  
    TYPE tp_pais IS TABLE OF jaqy163.jaqy163pais%type INDEX BY BINARY_INTEGER;
    TYPE tp_tdoc IS TABLE OF jaqy163.jaqy163tdoc%type INDEX BY BINARY_INTEGER;
    TYPE tp_ndoc IS TABLE OF jaqy163.jaqy163ndoc%type INDEX BY BINARY_INTEGER;
  
    la_jaqy163pais tp_pais;
    la_jaqy163tdoc tp_tdoc;
    la_jaqy163ndoc tp_ndoc;
  
  begin
    lc_lista := 'N';
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS=". "';
  
    begin
      pq_Cr_segmentacion_mens_cons.Sp_cr_Resolutores(PN_PAIS,
                                                     PN_TDOC,
                                                     PC_NDOC,
                                                     P_D_FECPRO,
                                                     pn_cal,
                                                     lc_fin_sobend,
                                                     lc_castigado,
                                                     ln_CntAntRcc);
    exception
      when others then
        null;
    end;
    begin
      pq_Cr_segmentacion_mens_cons.Sp_Resolutores_NS(PN_PAIS,
                                                     PN_TDOC,
                                                     PC_NDOC,
                                                     P_D_FECPRO,
                                                     Ln_nrobanks,
                                                     ln_promMax,
                                                     ln_calNor,
                                                     ln_segcod,
                                                     lc_refinan,
                                                     ln_histCred,
                                                     ln_porcUso,
                                                     ln_cal2, --mod@abr 20190827
                                                     lc_FlgVen);
    exception
      when others then
        null;
    end;
  
    /****Variable SEGM_ANTerior***/
    begin
      pQ_cr_segmentacion_PYME_NUEVAR.SP_CR_SEGM_ANT(PN_PAIS,
                                                    PN_TDOC,
                                                    PC_NDOC,
                                                    0,
                                                    ln_segpymeant);
    exception
      when others then
        null;
    end;
    ln_instancia := 0;
    --apachecoh 2023.02.23
    begin
      select tp1nro2
        into ln_afecta
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10823
         and tp1corr1 = 55
         and tp1corr2 = 4
         and tp1corr3 = 0;
    exception
      when others then
        ln_afecta := 0;
    end;
    if ln_afecta = 1 then
      lv_ndocum := trim(PC_NDOC);
      begin
        PQ_CR_SEGMNXCOMPORT.sp_cr_Inicio(ln_instancia,
                                         PN_PAIS,
                                         PN_TDOC,
                                         lv_ndocum,
                                         pc_usr,
                                         lv_afecta);
      exception
        when others then
          null;
      end;
      begin
        PQ_CR_VAR_SEGMENTACION_CONG_RP.sp_cr_variables_cong(PN_PAIS,
                                                            PN_TDOC,
                                                            lv_ndocum,
                                                            2,
                                                            ln_afdatr,
                                                            ln_afcalif,
                                                            ln_afcalif2);
      exception
        when others then
          null;
      end;
    end if;
    --apachecoh 2023.02.23
  
    lc_JAQZ661VAR2 := 'RELCRED_CAMPNAV' || '=' ||
                      trim(to_char(ln_histCred));
    if ln_promMax = 0 then
      lc_JAQZ661VAR4 := 'PROMD_ATRMAXRN=0.00';
    else
      case
        when ln_promMax < 1 and ln_promMax > 0 then
          lc_JAQZ661VAR4 := 'PROMD_ATRMAXRN=' || '0' ||
                            TRIM(TO_CHAR(ln_promMax));
        else
          lc_JAQZ661VAR4 := 'PROMD_ATRMAXRN=' || TRIM(TO_CHAR(ln_promMax));
      end case;
    end if;
    lc_JAQZ661VAR1 := 'NRO_BANKSRCC_SNCMAC' || '=' ||
                      trim(to_char(Ln_nrobanks));
    if ln_porcUso = 0 then
      lc_JAQZ661VAR3 := 'PORC_USO=0.00';
    else
      case
        when ln_porcUso < 1 and ln_porcUso > 0 then
          lc_JAQZ661VAR3 := 'PORC_USO=' || '0' || TRIM(TO_CHAR(ln_porcUso));
        else
          lc_JAQZ661VAR3 := 'PORC_USO=' || TRIM(TO_CHAR(ln_porcUso));
      end case;
    end if;
    lc_JAQZ661VAR8 := 'CALIFICACION_RCC' || '=' || trim(to_char(pn_cal));
    --lc_JAQZ661VAR6 := 'CAL_RCC_NORCPP' || '=' || trim(to_char(ln_calNor));
    
    lc_JAQZ661VAR11  := 'SOBRE_ENDEUDADO' || '=' || trim(lc_fin_sobend);
    lc_JAQZ661VAR5  := 'REFINANCIADO' || '=' || trim(lc_refinan);
    lc_JAQZ661VAR6  := 'CASTIGADO' || '=' || trim(lc_castigado);
    lc_JAQZ661VAR7  := 'LISTA_NEGRA' || '=' || trim(lc_lista);
    lc_JAQZ661VAR10 := 'SEGMENTO' || '=' || trim(to_char(ln_segcod));
    lc_JAQZ661VAR9  := 'ANTIGUEDAD_RCC' || '=' ||
                       trim(to_char(ln_CntAntRcc));
    --lc_JAQZ661VAR7  := 'CAL_RCC_TIT_6' || '=' || trim(to_char(pn_cal));
    --lc_JAQZ661VAR8  := 'CAL_RCC_TIT_12' || '=' || trim(to_char(ln_cal2));
    --lc_JAQZ661VAR15 := 'VENCIDO' || '=' || trim(lc_FlgVen);
  
    --apachecoh 2023.02.23        
    if ln_afecta = 1 then
      lc_JAQZ661VAR12 := 'PRMATRMX_CEN_RN' || '=' ||
                         trim(to_char(ln_afdatr));
      lc_JAQZ661VAR13 := 'CALF6_CEN_RN' || '=' || trim(to_char(ln_afcalif));
      lc_JAQZ661VAR14 := 'CALF12_CEN_RN' || '=' ||
                         trim(to_char(ln_afcalif2));
      lc_JAQZ661VAR15 := 'SEGMENCOM_RN' || '=' || trim(lv_afecta);
    end if;
  
    ln_cal  := 0;
    lc_hora := TO_CHAR(SYSDATE, 'hh:mm:ss');
  
    --LIMPIEZA
    begin
      delete from JAQZ661
       where JAQZ661PAIS = PN_PAIS
         and JAQZ661TDOC = PN_TDOC
         and JAQZ661NDOC = PC_NDOC
         and JAQZ661USR = PC_USR;
      commit;
    exception
      when others then
        null;
    end;
    --INSERCION
    begin
      insert into JAQZ661
        (JAQZ661FECH,
         JAQZ661PAIS,
         JAQZ661TDOC,
         JAQZ661NDOC,
         JAQZ661HORA,
         JAQZ661CCAL,
         JAQZ661VAR1,
         JAQZ661VAR2,
         JAQZ661VAR3,
         JAQZ661VAR4,
         JAQZ661VAR5,
         JAQZ661VAR6,
         JAQZ661VAR7,
         JAQZ661VAR8,
         JAQZ661VAR9,
         JAQZ661VAR10,
         JAQZ661VAR11,
         JAQZ661VAR12,
         JAQZ661VAR13,
         JAQZ661VAR14,
         JAQZ661VAR15,
         JAQZ661USR)
      values
        (P_D_FECPRO,
         PN_PAIS,
         PN_TDOC,
         PC_NDOC,
         lc_hora,
         ln_cal,
         lc_JAQZ661VAR1,
         lc_JAQZ661VAR2,
         lc_JAQZ661VAR3,
         lc_JAQZ661VAR4,
         lc_JAQZ661VAR5,
         lc_JAQZ661VAR6,
         lc_JAQZ661VAR7,
         lc_JAQZ661VAR8,
         lc_JAQZ661VAR9,
         lc_JAQZ661VAR10,
         lc_JAQZ661VAR11,
         lc_JAQZ661VAr12,
         lc_JAQZ661VAR13,
         lc_JAQZ661VAR14,
         lc_JAQZ661VAR15,
         PC_USR);
    
      commit;
    exception
      when others then
        --ERR_MSG := substr(sqlerrm, 1, 200);
        --DBMS_OUTPUT.put_line('ERR_MSG: ' || ERR_MSG);
        --INSERT INTO PRUEBA_LOG_DATA VALUES(5,1,1,1,1,PC_NDOC,ERR_MSG,P_D_FECPRO,SYSDATE);        
        null;
    end;
  end sp_cr_cargar_data_cliente;

end PQ_CR_SEGMENTACION_CONSUMO_LINEA;
/

