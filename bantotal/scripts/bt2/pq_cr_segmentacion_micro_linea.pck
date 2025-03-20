create or replace package PQ_CR_SEGMENTACION_MICRO_LINEA is

  -- Author  : APACHECOH
  -- Created : 26/04/2023 10:00:51
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

end PQ_CR_SEGMENTACION_MICRO_LINEA;
/

create or replace package body PQ_CR_SEGMENTACION_MICRO_LINEA is

  procedure sp_cr_NS_LINEA(P_D_FECPRO in date,
                           PN_PAIS    IN NUMBER,
                           PN_TDOC    IN NUMBER,
                           PC_NDOC    IN VARCHAR2,
                           PC_USR     IN VARCHAR2,
                           PN_SEGM    OUT NUMBER,
                           PV_SEGM    OUT VARCHAR2) IS
  
    cursor c_clientes(p_fecpro date) is
      select AQPB914pais, AQPB914tdoc, AQPB914ndoc
        from AQPB914 l
       where l.AQPB914pais = PN_PAIS
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
       where t.RNG49Cod = 1623
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
  
    execute immediate 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
    execute immediate 'ALTER SESSION SET OPTIMIZER_MODE=ALL_ROWS'; --jflor 2014.01.17  
    execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE'; --jflor 2014.05.05
  
    begin
      delete from AQPB915 a
       where a.AQPB915paic = PN_PAIS
         and a.AQPB915tdoc = PN_TDOC
         and a.AQPB915tndoc = PC_NDOC
         and a.AQPB915usr = PC_USR;
      commit;
    exception
      when others then
        null;
    end;
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
  
    --carga de variables en tabla log
    begin
      PQ_CR_SEGMENTACION_MICRO_LINEA.sp_cr_cargar_data_cliente(P_D_FECPRO,
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
      INTO la_AQPB914pais, la_AQPB914tdoc, la_AQPB914ndoc;
  
    IF la_AQPB914ndoc.count > 0 THEN
      FOR c IN la_AQPB914ndoc.FIRST .. la_AQPB914ndoc.LAST LOOP
      
        la_nomvar := la_nomnul;
        la_valvar := la_valnul;
        begin
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
        exception
          when others then
            null;
        end;
      
        --DBMS_OUTPUT.put_line('SegmentoRegla: ' || SegmentoRegla);
      
        Tp1cod      := 1;
        Tp1cod1     := 10823;
        Tp1corr1    := 300;
        Tp1corr2    := 1; -- Equivalencia resultado reglas - calificacion
        Tp1desc     := Trim(SegmentoRegla);
        AQPB916CCAL := null;
      
        For g in c_guia(Tp1cod, Tp1cod1, Tp1corr1, Tp1corr2) loop
          If g.tp1desc = Tp1desc Then
            AQPB916CCAL := g.tp1nro1;
          End If;
        End Loop;
      
        PN_SEGM := 0;
        PV_SEGM := Tp1desc;
      
        If AQPB916CCAL is not null then
          -- Califica
          l_AQPB915paic  := la_AQPB914pais(c);
          l_AQPB915tdoc  := la_AQPB914tdoc(c);
          l_AQPB915tndoc := la_AQPB914ndoc(c);
          l_AQPB915calf  := AQPB916CCAL;
          --l_AQPB915horp := to_char(sysdate(),'HH24:MI:SS');
          l_AQPB915tcal := 'P';
        
          begin
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
          exception
            when others then
              PN_SEGM := 0;
          end;
        
          PN_SEGM := l_AQPB915calf; --  
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
    ln_segmentac     number(5); --mod@abr 20201003
    ln_segpymeant    varchar2(100);
    lc_AQPB914VAR1   varchar2(100);
    lc_AQPB914VAR2   varchar2(100);
    lc_AQPB914VAR3   varchar2(100);
    lc_AQPB914VAR4   varchar2(100);
    lc_AQPB914VAR5   varchar2(100);
    lc_AQPB914VAR6   varchar2(100);
    lc_AQPB914VAR7   varchar2(100);
    lc_AQPB914VAR8   varchar2(100);
    lc_AQPB914VAR9   varchar2(100);
    lc_AQPB914VAR10  varchar2(100);
    lc_AQPB914VAR11  varchar2(100);
    lc_AQPB914VAR12  varchar2(100);
    lc_AQPB914VAR13  varchar2(100); --mod@abr20170127
    lc_AQPB914VAR14  varchar2(100); --mod@abr20181123
    lc_AQPB914VAR15  varchar2(100); --mod@abr20181123
  
    lc_AQPB914VAR16 varchar2(100); --mod@abr 20180110
    lc_AQPB914VAR17 varchar2(100); --mod@abr 20180110
    lc_AQPB914VAR18 varchar2(100); --mod@abr 20180110
    lc_AQPB914VAR19 varchar2(100); --mod@abr 20180110
    lc_AQPB914VAR20 varchar2(100); --mod@abr 20180110
    lc_AQPB914VAR21 varchar2(100); --mod@abr 20180110
    lc_AQPB914VAR22 varchar2(100); --mod@abr 20180110
    lc_AQPB914VAR23 varchar2(100); --mod@abr 20180110
    lc_AQPB914VAR24 varchar2(100); --mod@abr 20180110
    lc_AQPB914VAR25 varchar2(100); --mod@abr 20180110
    lc_AQPB914VAR26 varchar2(100); --mod@abr 20180110
    lc_AQPB914VAR27 varchar2(100); --mod@abr 20180110
  
    lc_AQPB914VAR28 varchar2(100); --mod@abr 20201003
    lc_AQPB914VAR29 varchar2(100);
    lc_lista        char(1);
    lc_hora         char(8);
  
    --apachecoh 2023.02.23
    ln_afdatr    number(17, 2);
    ln_afcalif   number(10, 2);
    ln_afcalif2  number(10, 2);
    ln_afecta    number(5);
    lv_afecta    varchar2(50);
    lv_ndocum    varchar2(12);
    lv_user      varchar2(10);
    ln_instancia number(10);
  
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
      pq_cr_segmentacion_micro_mens.Sp_cr_Resolutores(PN_PAIS,
                                                      PN_TDOC,
                                                      PC_NDOC,
                                                      P_D_FECPRO,
                                                      pn_cal,
                                                      ln_CntInsRep,
                                                      lc_fin_sobend,
                                                      lc_castigado,
                                                      ln_CntAntRcc);
    exception
      when others then
        null;
    end;
    begin
      pq_cr_segmentacion_micro_mens.Sp_Resolutores_NS(PN_PAIS,
                                                      PN_TDOC,
                                                      PC_NDOC,
                                                      P_D_FECPRO,
                                                      ln_histCred,
                                                      ln_promAtr,
                                                      ln_segcod,
                                                      lc_refinan,
                                                      lc_tipHN,
                                                      pn_cal2,
                                                      hist_pyme --mod@abr20170127
                                                      );
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
                                         PC_USR,
                                         lv_afecta);
      exception
        when others then
          null;
      end;
      begin
        PQ_CR_VAR_SEGMENTACION_CONG_RP.sp_cr_variables_cong(PN_PAIS,
                                                            PN_TDOC,
                                                            lv_ndocum,
                                                            3,
                                                            ln_afdatr,
                                                            ln_afcalif,
                                                            ln_afcalif2);
      exception
        when others then
          null;
      end;
    end if;
    --apachecoh 2023.02.23
  
    lc_AQPB914VAR1 := 'REL_CREDI' || '=' || trim(to_char(ln_histCred));
  
    if ln_promAtr = 0 then
      lc_AQPB914VAR5 := 'DIA_ATRASO=0.00';
    else
      case
        when ln_promAtr < 1 and ln_promAtr > 0 then
          lc_AQPB914VAR5 := 'DIA_ATRASO=' || '0' ||
                            TRIM(TO_CHAR(ln_promAtr));
        else
          lc_AQPB914VAR5 := 'DIA_ATRASO=' || TRIM(TO_CHAR(ln_promAtr));
      end case;
    end if;
    --lc_AQPB914VAR3  := 'CANT_INSTREP'||'='||trim(to_char(ln_CntInsRep));
    lc_AQPB914VAR4 := 'NRO_ENT_SEGMICRO' || '=' ||
                      trim(to_char(ln_CntInsRep)); --mod@abr 20190708
    lc_AQPB914VAR3 := 'CALIFICACION_RCC' || '=' || trim(to_char(pn_cal));
    --lc_AQPB914VAR5  := 'HIST_NR' || '=' || trim(lc_tipHN);
    --lc_AQPB914VAR6  := 'SOBRE_ENDEUDADO' || '=' || trim(lc_fin_sobend);
    --lc_AQPB914VAR7  := 'REFINANCIADO' || '=' || trim(lc_refinan);
    --lc_AQPB914VAR8  := 'CASTIGADO' || '=' || trim(lc_castigado);
    --lc_AQPB914VAR9  := 'LISTA_NEGRA' || '=' || trim(lc_lista);
    --lc_AQPB914VAR10 := 'SEGMENTO' || '=' || trim(to_char(ln_segcod));
    lc_AQPB914VAR2 := 'CAL_RCC_2' || '=' || trim(to_char(pn_cal2));
    lc_AQPB914VAR6 := 'ANTIGUEDAD_RCC' || '=' ||
                      trim(to_char(ln_CntAntRcc));
    --lc_AQPB914VAR13 := 'HIST_PYME' || '=' || trim(hist_pyme); --mod@abr20170127
  
    --apachecoh 2023.02.23        
    if ln_afecta = 1 then
      lc_AQPB914VAR7 := 'DATR_M_CEN_RN' || '=' || trim(to_char(ln_afdatr));
      lc_AQPB914VAR8 := 'CALF_M_CEN_RN' || '=' || trim(to_char(ln_afcalif));
      lc_AQPB914VAR9 := 'SEGMENCOM_RN' || '=' || trim(lv_afecta);
    end if;
  
    ln_cal  := 0;
    lc_hora := TO_CHAR(SYSDATE, 'hh:mm:ss');
  
    --LIMPIEZA
    begin
      delete from AQPB914
       where AQPB914PAIS = PN_PAIS
         and AQPB914TDOC = PN_TDOC
         and AQPB914NDOC = PC_NDOC
         and AQPB914USR = PC_USR;
      commit;
    exception
      when others then
        null;
    end;
    --INSERCION
    begin
      insert into AQPB914
        (AQPB914FECH,
         AQPB914PAIS,
         AQPB914TDOC,
         AQPB914NDOC,
         AQPB914HORA,
         AQPB914CCAL,
         AQPB914VAR1,
         AQPB914VAR2,
         AQPB914VAR3,
         AQPB914VAR4,
         AQPB914VAR5,
         AQPB914VAR6,
         AQPB914VAR7,
         AQPB914VAR8,
         AQPB914VAR9,
         AQPB914USR)
      values
        (P_D_FECPRO,
         PN_PAIS,
         PN_TDOC,
         PC_NDOC,
         lc_hora,
         ln_cal,
         lc_AQPB914VAR1,
         lc_AQPB914VAR2,
         lc_AQPB914VAR3,
         lc_AQPB914VAR4,
         lc_AQPB914VAR5,
         lc_AQPB914VAR6,
         lc_AQPB914VAR7,
         lc_AQPB914VAR8,
         lc_AQPB914VAR9,
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

end PQ_CR_SEGMENTACION_MICRO_LINEA;
/

