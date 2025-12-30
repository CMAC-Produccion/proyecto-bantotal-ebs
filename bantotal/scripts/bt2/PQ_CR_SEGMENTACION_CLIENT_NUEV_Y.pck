create or replace package PQ_CR_SEGMENTACION_CLIENT_NUEV_Y is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_SEGMENTACION_CLIENT_NUEV
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Clientes
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2022.09.13
  -- Autor de Creación          : RCASTRO
  -- Uso                        : Evaluador para la Segmentacion de créditos
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de Modificación      : 
  -- Descripción de Modificación: 
  --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

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

  procedure sp_cr_carga_clientes_NS(P_D_FECPRO in date,
                                    P_N_LIMITE IN NUMBER,
                                    P_N_JOBS   IN NUMBER,
                                    P_Y_PAIS   IN NUMBER,
                                    P_Y_TDOC   IN NUMBER,
                                    P_Y_NDOC   IN CHAR);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_segmenta_clientes_job_NS(P_D_FECPRO IN DATE,
                                           P_N_JOBS   IN NUMBER,
                                           PC_USR     IN VARCHAR2,
                                           pc_ndoc    in char);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_segmenta_clientes_NS(P_D_FECPRO in date,
                                       P_N_DIGITO in number,
                                       PC_USR     in varchar2,
                                       pc_docu    in char);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_evalua_clientes_1_NS(P_N_REGLA   IN NUMBER,
                                       P_A_NOMVAR  IN PQ_CR_SEGMENTACION_CLIENT_NUEV.tp_nomvar,
                                       P_A_VALVAR  IN PQ_CR_SEGMENTACION_CLIENT_NUEV.tp_valvar,
                                       P_N_VAR     IN number,
                                       P_A_REGLAS  in PQ_CR_SEGMENTACION_CLIENT_NUEV.tb_reglas,
                                       P_N_REG     in number,
                                       p_c_retorno out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_evalua_clientes_2_NS(P_N_REGLA   IN NUMBER,
                                       P_A_NOMVAR  IN PQ_CR_SEGMENTACION_CLIENT_NUEV.tp_nomvar,
                                       P_A_VALVAR  IN PQ_CR_SEGMENTACION_CLIENT_NUEV.tp_valvar,
                                       P_N_VAR     IN number,
                                       P_A_REGLAS  in PQ_CR_SEGMENTACION_CLIENT_NUEV.tb_reglas,
                                       P_N_REG     in number,
                                       p_c_retorno out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_evalua_clientes_3_NS(P_N_REGLA   IN NUMBER,
                                       P_A_NOMVAR  IN PQ_CR_SEGMENTACION_CLIENT_NUEV.tp_nomvar,
                                       P_A_VALVAR  IN PQ_CR_SEGMENTACION_CLIENT_NUEV.tp_valvar,
                                       P_N_VAR     IN number,
                                       P_A_REGLAS  in PQ_CR_SEGMENTACION_CLIENT_NUEV.tb_reglas,
                                       P_N_REG     in number,
                                       p_c_retorno out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  procedure sp_cr_cargar_variables_NS_MENS(P_D_FECPRO IN DATE,
                                           P_N_PAIS   IN JAQZ082.JAQZ082PAIS%type,
                                           P_N_TDOC   IN JAQZ082.JAQZ082TDOC%type,
                                           P_C_NDOC   IN JAQZ082.JAQZ082NDOC%type,
                                           P_C_USR    IN JAQZ082.JAQZ082USR%type,
                                           p_a_nomvar out PQ_CR_SEGMENTACION_CLIENT_NUEV.tp_nomvar,
                                           p_a_valvar out PQ_CR_SEGMENTACION_CLIENT_NUEV.tp_valvar,
                                           p_n_var    out number);

end PQ_CR_SEGMENTACION_CLIENT_NUEV_Y;
/
create or replace package body PQ_CR_SEGMENTACION_CLIENT_NUEV_Y is
  --**************************************************************************************---
  procedure sp_cr_carga_clientes_NS(P_D_FECPRO in date,
                                    P_N_LIMITE IN NUMBER,
                                    P_N_JOBS   IN NUMBER,
                                    P_Y_PAIS   IN NUMBER,
                                    P_Y_TDOC   IN NUMBER,
                                    P_Y_NDOC   IN CHAR) IS
  
    cursor c_clientes is
      select /*+parallel (c,4,1)*/
       a.pepais, a.petdoc, a.pendoc
        from fsd010 c, fsr008 a
       where c.pgcod = a.pgcod
         and (aomod in (select modulo
                          from fst111
                         where dscod = 50
                           and modulo not in (33, 120, 142, 200)) or
             aomod = 117)
         and aofval <= P_D_FECPRO
         and c.aocta = a.ctnro
         and a.ttcod = 1
         and a.cttfir = 'T'
         and a.pepais = P_Y_PAIS
         and a.petdoc = P_Y_TDOC
         and a.pendoc = P_Y_NDOC
       group by a.pepais, a.petdoc, a.pendoc;
  
    ln_dig    number(3) := null;
    ln_cont   number(10) := null;
    ln_limite number(10) := null;
    lb_flag   boolean := null;
    lc_cadtmp varchar2(15) := null;
    ln_numtmp number(10) := 0;
    ln_dig2   number(3) := null;
  
  BEGIN
  
    ln_limite := nvl(P_N_LIMITE, 0);
    ln_cont   := 0;
    lb_flag   := true;
    --delete from crdtcap;
    begin
      DELETE FROM AQPD783 WHERE AQPD783ndoc = P_Y_NDOC; --apachecoh 2023.07.03
    exception
      when others then
        null;
    end;
    /*for c in c_clientes loop
        INSERT INTO crdtcap (c_descri) VALUES (c.aocta);
        commit;             
    end loop;*/
  
    for c in c_clientes loop
      /*ln_cont := ln_cont + 1;
      if ln_limite > 0 then
        if ln_cont <= ln_limite then
          lb_flag := true;
        else
          lb_flag := false;
          exit;
        end if;
      end if;*/
    
      --If lb_flag Then
      /*if ln_cont = 1 then
         c.pendoc := '01324324';
          c.petdoc := 21;
          c.pepais := 604;
      end if;*/
      begin
        ln_dig  := to_number(substr(trim(c.pendoc), -2, 2));
        ln_dig2 := round(substr(trim(c.pendoc), -3, 3) * P_N_JOBS / 999, 0);
      exception
        when others then
          ln_dig  := 0;
          ln_dig2 := 0;
      end;
      begin
        INSERT INTO AQPD783
          (AQPD783pais,
           AQPD783tdoc,
           AQPD783ndoc,
           AQPD783nume,
           AQPD783nume2)
        VALUES
          (c.pepais, c.petdoc, c.pendoc, ln_dig, ln_dig2);
        commit;
      exception
        when others then
          null;
      end;
    
    end loop;
  
  END sp_cr_carga_clientes_NS;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  procedure sp_cr_segmenta_clientes_job_NS(P_D_FECPRO IN DATE,
                                           P_N_JOBS   IN NUMBER,
                                           PC_USR     IN VARCHAR2,
                                           pc_ndoc    in char) is
  
    /*cursor c_clientes_job(p_fecpro date) is
    select substr(trim(j.AQPD785ndoc), -1, 1) digito, j.AQPD785usr
      from AQPD785 j
     where j.AQPD785fech = p_fecpro
       and j.AQPD785usr = PC_USR
     group by substr(trim(j.AQPD785ndoc), -1, 1), j.AQPD785usr;*/
  
    lc_hostname   varchar2(64);
    lc_fecpro     varchar2(10);
    lc_variable   varchar2(4000);
    ln_job        number := 0;
    l_AQPD784pano aqpd784.AQPD784pano%type;
    l_AQPD784pmes aqpd784.AQPD784pmes%type;
    ln_cont       number(2) := 0;
    ln_inst       number(1) := 1;
    ln_limit      number(3) := 20;
    ln_numjob     number(5);
  BEGIN
  
    begin
      select host_name into lc_hostname from v$instance;
    exception
      when others then
        null;
    end;
  
    execute immediate 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
    lc_fecpro     := to_char(P_D_FECPRO, 'RRRR.MM.DD');
    l_AQPD784pano := to_number(to_char(P_D_FECPRO, 'RRRR'));
    l_AQPD784pmes := to_number(to_char(P_D_FECPRO, 'MM'));
    --l_AQPD784pano := to_number(to_char(add_months(P_D_FECPRO, -1),'RRRR'));
    --l_AQPD784pmes := to_number(to_char(add_months(P_D_FECPRO, -1),'MM')); 
    begin
      delete from aqpd784 A
       where AQPD784pano = l_AQPD784pano
         and AQPD784pmes = l_AQPD784pmes
         and a.AQPD784nse = 'S'
         and a.AQPD784tse = 'N'
         and a.AQPD784tndoc = pc_ndoc; --N : para segmentación nueva 2022
      commit;
    exception
      when others then
        null;
    end;
  
    --apachecoh 2023.07.03
    --Limite de JOBS parametrizado en guia
    begin
      select tp1nro1
        into ln_limit
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11169
         and tp1corr1 = 10
         and tp1corr2 = 1
         and tp1corr3 = 1;
    exception
      when others then
        ln_limit := 20;
    end;
    PQ_CR_SEGMENTACION_CLIENT_NUEV_Y.sp_cr_segmenta_clientes_NS(P_D_FECPRO => P_D_FECPRO,
                                                                P_N_DIGITO => 0,
                                                                PC_USR     => PC_USR,
                                                                pc_docu    => pc_ndoc);
    /*
      for i in 0 .. P_N_JOBS loop
      
        lc_variable := ' begin ' ||
                       ' PQ_CR_SEGMENTACION_CLIENT_NUEV_Y.sp_cr_segmenta_clientes_NS(TO_DATE(''' ||
                       lc_fecpro || ''',''RRRR.MM.DD''),''' || i || ''',''' ||
                       PC_USR || ''','''||pc_ndoc ||''');' || ' End; ';
      
        ln_job := ln_job + 1;
      
        --              DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*60));
        --if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then
        --if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
        BEGIN
          IF SYS.FN_BD_ISRAC = 'TRUE' THEN
            DBMS_JOB.SUBMIT(job       => ln_job,
                            what      => lc_variable,
                            next_date => sysdate + 1 / (24 * 60),
                            interval  => null,
                            no_parse  => false,
                            instance  => 1,
                            --instance => 2,--Solo por hoy 01.07.2015 hmev new 01/01/2024
                            force => false);
          else
            DBMS_JOB.SUBMIT(job       => ln_job,
                            what      => lc_variable,
                            next_date => sysdate + 1 / (24 * 60),
                            interval  => null,
                            no_parse  => false,
                            force     => false);
          end if;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        commit;
      
        --apachecoh 2023.07.03  
        BEGIN
          SELECT count(*)
            INTO ln_numjob
            FROM dba_jobs x
           WHERE upper(x.what) LIKE
                 upper('%PQ_CR_SEGMENTACION_CLIENT_NUEV_Y.sp_cr_segmenta_clientes_NS%');
        EXCEPTION
          WHEN OTHERS THEN
            ln_numjob := 0;
        END;
      
        WHILE ln_numjob = ln_limit LOOP
          BEGIN
            SELECT count(*)
              INTO ln_numjob
              FROM dba_jobs x
             WHERE upper(x.what) LIKE
                   upper('%PQ_CR_SEGMENTACION_CLIENT_NUEV_Y.sp_cr_segmenta_clientes_NS%');
          EXCEPTION
            WHEN OTHERS THEN
              ln_numjob := 0;
          END;
        END LOOP;
      
      end loop;
    */
  end sp_cr_segmenta_clientes_job_NS;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  procedure sp_cr_segmenta_clientes_NS(P_D_FECPRO in date,
                                       P_N_DIGITO in number,
                                       PC_USR     in varchar2,
                                       pc_docu    in char) IS
  
    cursor c_clientes(p_fecpro date,
                      p_anio   number,
                      p_mes    number,
                      PC_DOCU  char) is
      select /*+all_rows index_ss(l)*/
       AQPD785pais, AQPD785tdoc, AQPD785ndoc
        from AQPD785 l
       where AQPD785fech = p_fecpro
         and l.AQPD785usr = PC_USR
         and l.AQPD785ndoc = pc_docu
         and not exists (select 1
                from aqpd784 c
               where c.AQPD784paic = l.AQPD785pais
                 and c.AQPD784tdoc = l.AQPD785tdoc
                 and c.AQPD784tndoc = l.AQPD785ndoc
                 and c.AQPD784tndoc = pc_docu
                 and c.AQPD784pano = p_anio
                 and c.AQPD784pmes = p_mes
                 and c.AQPD784NSE = 'S'
                 and c.AQPD784tse = 'N'); -- 'N' : Nueva codificac para identificar segmentacion 2022
    --and AQPD785NUME = P_N_DIGITO;
  
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
      --   where t.RNG49Cod in (1620, 1621) --mod@abr20180110
       where t.RNG49Cod in (1621, 1626, 1627) --(1620, 1621, 1624) --mod@abr20180110
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
  
    Regla          frng51.rng49cod%type;
    SegmentoRegla  frng50.rng50ret%type;
    la_nomvar      PQ_CR_SEGMENTACION_CLIENT_NUEV.tp_nomvar;
    la_valvar      PQ_CR_SEGMENTACION_CLIENT_NUEV.tp_valvar;
    la_nomnul      PQ_CR_SEGMENTACION_CLIENT_NUEV.tp_nomvar;
    la_valnul      PQ_CR_SEGMENTACION_CLIENT_NUEV.tp_valvar;
    ln_var         number(3) := 0;
    Tp1cod         fst198.tp1cod%type;
    Tp1cod1        fst198.tp1cod1%type;
    Tp1corr1       fst198.tp1corr1%type;
    Tp1corr2       fst198.tp1corr2%type;
    Tp1desc        fst198.tp1desc%type;
    JAQY067CCAL    jaqy067.jaqy067ccal%type;
    l_AQPD784pano  aqpd784.AQPD784pano%type;
    l_AQPD784pmes  aqpd784.AQPD784pmes%type;
    l_AQPD784paic  aqpd784.AQPD784paic%type;
    l_AQPD784tdoc  aqpd784.AQPD784tdoc%type;
    l_AQPD784tndoc aqpd784.AQPD784tndoc%type;
    l_AQPD784calf  aqpd784.AQPD784calf%type;
    l_AQPD784fecp  aqpd784.AQPD784fecp%type;
    l_AQPD784horp  aqpd784.AQPD784horp%type;
    l_AQPD784tcal  aqpd784.AQPD784tcal%type;
    ln_AQPD785pais number;
    ln_AQPD785tdoc number;
    ln_AQPD785ndoc char(12);
  
    TYPE tp_pais IS TABLE OF jaqy162.jaqy162pais%type INDEX BY BINARY_INTEGER;
    TYPE tp_tdoc IS TABLE OF jaqy162.jaqy162tdoc%type INDEX BY BINARY_INTEGER;
    TYPE tp_ndoc IS TABLE OF jaqy162.jaqy162ndoc%type INDEX BY BINARY_INTEGER;
  
    la_AQPD785pais tp_pais;
    la_AQPD785tdoc tp_tdoc;
    la_AQPD785ndoc tp_ndoc;
    la_reglas      PQ_CR_SEGMENTACION_CLIENT_NUEV.tb_reglas;
    ln_reg         number(5);
  
  BEGIN
  
    execute immediate 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
    execute immediate 'ALTER SESSION SET OPTIMIZER_MODE=ALL_ROWS'; --jflor 2014.01.17  
    execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE'; --jflor 2014.05.05
  
    l_AQPD784fecp := P_D_FECPRO;
    l_AQPD784pano := to_number(to_char(P_D_FECPRO, 'RRRR'));
    l_AQPD784pmes := to_number(to_char(P_D_FECPRO, 'MM'));
    --l_AQPD784pano := to_number(to_char(add_months(P_D_FECPRO, -1),'RRRR'));
    --l_AQPD784pmes := to_number(to_char(add_months(P_D_FECPRO, -1),'MM'));    
    Regla := 1626; --1620; RC
  
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
    /*
    OPEN c_clientes(P_D_FECPRO, l_AQPD784pano, l_AQPD784pmes, PC_DOCU); -- Clientes Bulk
    FETCH c_clientes BULK COLLECT
      INTO la_AQPD785pais, la_AQPD785tdoc, la_AQPD785ndoc;
      */
    SELECT AQPD785pais, AQPD785tdoc, AQPD785ndoc
      INTO ln_AQPD785pais, ln_AQPD785tdoc, ln_AQPD785ndoc
      FROM AQPD785
     WHERE AQPD785fech = P_D_FECPRO
       AND AQPD785usr = PC_USR
       AND AQPD785ndoc = PC_DOCU;
  
    --IF la_AQPD785ndoc.count > 0 THEN
     -- FOR c IN la_AQPD785ndoc.FIRST .. la_AQPD785ndoc.LAST LOOP
      
        la_nomvar := la_nomnul;
        la_valvar := la_valnul;
        BEGIN
          PQ_CR_SEGMENTACION_CLIENT_NUEV_Y.sp_cr_cargar_variables_NS_MENS(P_D_FECPRO => P_D_FECPRO,
                                                                        P_N_PAIS   => ln_AQPD785pais,
                                                                        P_N_TDOC   => ln_AQPD785tdoc,
                                                                        P_C_NDOC   => ln_AQPD785ndoc,
                                                                        P_C_USR    => PC_USR,
                                                                        p_a_nomvar => la_nomvar,
                                                                        p_a_valvar => la_valvar,
                                                                        p_n_var    => ln_var);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        SegmentoRegla := null;
        BEGIN
          PQ_CR_SEGMENTACION_CLIENT_NUEV_Y.sp_cr_evalua_clientes_1_NS(P_N_REGLA   => Regla,
                                                                    P_A_NOMVAR  => la_nomvar,
                                                                    P_A_VALVAR  => la_valvar,
                                                                    P_N_VAR     => ln_var,
                                                                    P_A_REGLAS  => la_reglas,
                                                                    P_N_REG     => ln_reg,
                                                                    p_c_retorno => SegmentoRegla);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        Tp1cod      := 1;
        Tp1cod1     := 10823;
        Tp1corr1    := 2;
        Tp1corr2    := 13; --12; -- Equivalencia resultado reglas - calificacion RC
        Tp1desc     := Trim(SegmentoRegla);
        JAQY067CCAL := null;
      
        For g in c_guia(Tp1cod, Tp1cod1, Tp1corr1, Tp1corr2) loop
          If g.tp1desc = Tp1desc Then
            JAQY067CCAL := g.tp1nro1;
          End If;
        End Loop;
      
        If JAQY067CCAL is not null then
          -- Califica
          l_AQPD784paic  := ln_AQPD785pais;
          l_AQPD784tdoc  := ln_AQPD785tdoc;
          l_AQPD784tndoc := ln_AQPD785ndoc;
          l_AQPD784calf  := JAQY067CCAL;
          l_AQPD784horp  := to_char(sysdate(), 'HH24:MI:SS');
          l_AQPD784tcal  := 'P';
        
          BEGIN
            insert into aqpd784
              (AQPD784PANO,
               AQPD784PMES,
               AQPD784PAIC,
               AQPD784TDOC,
               AQPD784TNDOC,
               AQPD784CALF,
               AQPD784FECP,
               AQPD784HORP,
               AQPD784TCAL,
               AQPD784nse,
               AQPD784TSE)
            values
              (l_AQPD784pano,
               l_AQPD784pmes,
               l_AQPD784paic,
               l_AQPD784tdoc,
               l_AQPD784tndoc,
               l_AQPD784calf,
               l_AQPD784fecp,
               l_AQPD784horp,
               l_AQPD784tcal,
               'S',
               'N'); --'N' nueva codificac para segmentación 2022
            commit;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
        End If;
      
      --END LOOP; -- clientes
    --END IF;
  
  END sp_cr_segmenta_clientes_NS;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_cr_evalua_clientes_1_NS(P_N_REGLA   IN NUMBER,
                                       P_A_NOMVAR  IN PQ_CR_SEGMENTACION_CLIENT_NUEV.tp_nomvar,
                                       P_A_VALVAR  IN PQ_CR_SEGMENTACION_CLIENT_NUEV.tp_valvar,
                                       P_N_VAR     IN number,
                                       P_A_REGLAS  in PQ_CR_SEGMENTACION_CLIENT_NUEV.tb_reglas,
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
    la_nomvar      PQ_CR_SEGMENTACION_CLIENT_NUEV.tp_nomvar;
    la_valvar      PQ_CR_SEGMENTACION_CLIENT_NUEV.tp_valvar;
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
    la_reglas      PQ_CR_SEGMENTACION_CLIENT_NUEV.tb_reglas;
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
         and tp1corr3 = 3; -- 1;RC
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
            -- DBMS_OUTPUT.put_line('------- si se cumple');
            --DBMS_OUTPUT.put_line('la_reglas(ln_ind).RNG50GRP: ' || la_reglas(ln_ind).RNG50GRP);
            -- DBMS_OUTPUT.put_line('ResReglaGrupo: ' || ResReglaGrupo);
            --DBMS_OUTPUT.put_line('p_c_retorno tru: ' || p_c_retorno);
            --DBMS_OUTPUT.put_line('------- ');
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
          
            /*DBMS_OUTPUT.put_line('------- no se cumple ');
            DBMS_OUTPUT.put_line('ResReglaGrupo: ' || ResReglaGrupo);
            DBMS_OUTPUT.put_line('------- ');
            DBMS_OUTPUT.put_line('p_c_retorno tru siguiente: ' || l_RNG50Ret);
            DBMS_OUTPUT.put_line('------- ');*/
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
          BEGIN
            PQ_CR_SEGMENTACION_CLIENT_NUEV.sp_cr_evalua_clientes_2_NS(P_N_REGLA   => Regla2,
                                                                      P_A_NOMVAR  => la_nomvar,
                                                                      P_A_VALVAR  => la_valvar,
                                                                      P_N_VAR     => ln_var,
                                                                      P_A_REGLAS  => la_reglas,
                                                                      P_N_REG     => ln_reg,
                                                                      p_c_retorno => SegmentoRegla2);
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
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
      
        /*DBMS_OUTPUT.put_line('la_reglas(ln_ind).RNG68ATR: ' || la_reglas(ln_ind).RNG68ATR);
        DBMS_OUTPUT.put_line('lc_valResuelto: ' || lc_valResuelto);
        DBMS_OUTPUT.put_line('l_RNG51OPE: ' || l_RNG51OPE);
        DBMS_OUTPUT.put_line('l_RNG51Val: ' || l_RNG51Val);*/
      
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
            For lis in c_lista(la_reglas(ln_ind).RNG49COD, l_RNG50Grp, la_reglas(ln_ind).RNG51COD) loop
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
            For lis in c_lista(la_reglas(ln_ind).RNG49COD, l_RNG50Grp, la_reglas(ln_ind).RNG51COD) loop
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
      
        --DBMS_OUTPUT.put_line('ResReglaGrupo: ' || ResReglaGrupo);
        --END IF; -- regla evaluada
        ln_ind := ln_ind + 1;
      
      END LOOP; -- reglas
    
    End If; -- existe grupo
  
  END sp_cr_evalua_clientes_1_NS;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_cr_evalua_clientes_2_NS(P_N_REGLA   IN NUMBER,
                                       P_A_NOMVAR  IN PQ_CR_SEGMENTACION_CLIENT_NUEV.tp_nomvar,
                                       P_A_VALVAR  IN PQ_CR_SEGMENTACION_CLIENT_NUEV.tp_valvar,
                                       P_N_VAR     IN number,
                                       P_A_REGLAS  in PQ_CR_SEGMENTACION_CLIENT_NUEV.tb_reglas,
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
    la_nomvar      PQ_CR_SEGMENTACION_CLIENT_NUEV.tp_nomvar;
    la_valvar      PQ_CR_SEGMENTACION_CLIENT_NUEV.tp_valvar;
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
    la_reglas  PQ_CR_SEGMENTACION_CLIENT_NUEV.tb_reglas;
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
        --PQ_CR_SEGMENTACION_CLIENT_NUEV.sp_cr_evalua_clientes_3_NS( P_N_REGLA => Regla3,
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
            For lis in c_lista(la_reglas(ln_ind).RNG49COD, l_RNG50Grp, la_reglas(ln_ind).RNG51COD) loop
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
            For lis in c_lista(la_reglas(ln_ind).RNG49COD, l_RNG50Grp, la_reglas(ln_ind).RNG51COD) loop
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
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_cr_evalua_clientes_3_NS(P_N_REGLA   IN NUMBER,
                                       P_A_NOMVAR  IN PQ_CR_SEGMENTACION_CLIENT_NUEV.tp_nomvar,
                                       P_A_VALVAR  IN PQ_CR_SEGMENTACION_CLIENT_NUEV.tp_valvar,
                                       P_N_VAR     IN number,
                                       P_A_REGLAS  in PQ_CR_SEGMENTACION_CLIENT_NUEV.tb_reglas,
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
    la_nomvar      PQ_CR_SEGMENTACION_CLIENT_NUEV.tp_nomvar;
    la_valvar      PQ_CR_SEGMENTACION_CLIENT_NUEV.tp_valvar;
    ln_var         number(3) := 0;
    lc_valResuelto varchar2(30);
    i              number(3);
    ln_NumTmp1     number(10, 2);
    ln_NumTmp2     number(10, 2);
    --l_RNG68Tda frng68.rng68tda%type;
    l_RNG51Val varchar2(30);
    l_RNG67val varchar2(30);
    l_RNG51OPE varchar2(2);
    la_reglas  PQ_CR_SEGMENTACION_CLIENT_NUEV.tb_reglas;
    ln_reg     number(5);
    ln_ind     number(5);
  
  BEGIN
  
    Regla     := nvl(P_N_REGLA, 0);
    la_nomvar := p_a_nomvar;
    la_valvar := p_a_valvar;
    ln_var    := nvl(p_n_var, 0);
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
      
        -- Insertar codigo para resolver Regla anidada Nivel 4
      
        --Msg('niv uno evalua atributo/expres : ' + reg.RNG68ATR)
      
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
            For lis in c_lista(la_reglas(ln_ind).RNG49COD, l_RNG50Grp, la_reglas(ln_ind).RNG51COD) loop
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
            For lis in c_lista(la_reglas(ln_ind).RNG49COD, l_RNG50Grp, la_reglas(ln_ind).RNG51COD) loop
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
  
  END sp_cr_evalua_clientes_3_NS;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_cargar_variables_NS_MENS(P_D_FECPRO IN DATE,
                                           P_N_PAIS   IN JAQZ082.JAQZ082PAIS%type,
                                           P_N_TDOC   IN JAQZ082.JAQZ082TDOC%type,
                                           P_C_NDOC   IN JAQZ082.JAQZ082NDOC%type,
                                           P_C_USR    IN JAQZ082.JAQZ082USR%type,
                                           p_a_nomvar out PQ_CR_SEGMENTACION_CLIENT_NUEV.tp_nomvar,
                                           p_a_valvar out PQ_CR_SEGMENTACION_CLIENT_NUEV.tp_valvar,
                                           p_n_var    out number) is
  
    cursor c_cliente is
      select AQPD785fech,
             AQPD785pais,
             AQPD785tdoc,
             AQPD785ndoc,
             AQPD785var1,
             AQPD785var2,
             AQPD785var3,
             AQPD785var4,
             AQPD785var5,
             AQPD785var6,
             AQPD785var7,
             AQPD785var8,
             AQPD785var9,
             AQPD785var10,
             AQPD785var11,
             AQPD785var12,
             AQPD785var13,
             AQPD785var14,
             AQPD785var15,
             AQPD785var16,
             AQPD785var17,
             AQPD785var18,
             AQPD785var19,
             AQPD785var20,
             AQPD785var21,
             AQPD785var22,
             AQPD785var23,
             AQPD785var24,
             AQPD785var25,
             AQPD785var26,
             AQPD785var27,
             AQPD785var28,
             AQPD785var29,
             AQPD785var30,
             AQPD785var31,
             AQPD785var32,
             AQPD785var33,
             AQPD785var34,
             AQPD785var35,
             AQPD785var36,
             AQPD785var37,
             AQPD785var38,
             AQPD785var39,
             AQPD785var40
        from AQPD785
       where AQPD785fech = P_D_FECPRO
         and AQPD785pais = P_N_PAIS
         and AQPD785tdoc = P_N_TDOC
         and AQPD785ndoc = P_C_NDOC
         and AQPD785usr = P_C_USR;
    ln_tmpnum number(3);
  
  begin
  
    for cli in c_cliente loop
      -- Cargando Variables Resuletas
      if trim(cli.AQPD785var1) is not null then
        p_n_var := 1;
        ln_tmpnum := instr(cli.AQPD785var1, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var1, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var1, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var2) is not null then
        p_n_var := 2;
        ln_tmpnum := instr(cli.AQPD785var2, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var2, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var2, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var3) is not null then
        p_n_var := 3;
        ln_tmpnum := instr(cli.AQPD785var3, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var3, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var3, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var4) is not null then
        p_n_var := 4;
        ln_tmpnum := instr(cli.AQPD785var4, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var4, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var4, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var5) is not null then
        p_n_var := 5;
        ln_tmpnum := instr(cli.AQPD785var5, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var5, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var5, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var6) is not null then
        p_n_var := 6;
        ln_tmpnum := instr(cli.AQPD785var6, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var6, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var6, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var7) is not null then
        p_n_var := 7;
        ln_tmpnum := instr(cli.AQPD785var7, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var7, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var7, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var8) is not null then
        p_n_var := 8;
        ln_tmpnum := instr(cli.AQPD785var8, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var8, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var8, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var9) is not null then
        p_n_var := 9;
        ln_tmpnum := instr(cli.AQPD785var9, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var9, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var9, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var10) is not null then
        p_n_var := 10;
        ln_tmpnum := instr(cli.AQPD785var10, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var10, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var10, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var11) is not null then
        p_n_var := 11;
        ln_tmpnum := instr(cli.AQPD785var11, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var11, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var11, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var12) is not null then
        p_n_var := 12;
        ln_tmpnum := instr(cli.AQPD785var12, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var12, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var12, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var13) is not null then
        p_n_var := 13;
        ln_tmpnum := instr(cli.AQPD785var13, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var13, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var13, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var14) is not null then
        p_n_var := 14;
        ln_tmpnum := instr(cli.AQPD785var14, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var14, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var14, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var15) is not null then
        p_n_var := 15;
        ln_tmpnum := instr(cli.AQPD785var15, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var15, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var15, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var16) is not null then
        p_n_var := 16;
        ln_tmpnum := instr(cli.AQPD785var16, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var16, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var16, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var17) is not null then
        p_n_var := 17;
        ln_tmpnum := instr(cli.AQPD785var17, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var17, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var17, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var18) is not null then
        p_n_var := 18;
        ln_tmpnum := instr(cli.AQPD785var18, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var18, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var18, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var19) is not null then
        p_n_var := 19;
        ln_tmpnum := instr(cli.AQPD785var19, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var19, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var19, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var20) is not null then
        p_n_var := 20;
        ln_tmpnum := instr(cli.AQPD785var20, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var20, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var20, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var21) is not null then
        p_n_var := 21;
        ln_tmpnum := instr(cli.AQPD785var21, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var21, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var21, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var22) is not null then
        p_n_var := 22;
        ln_tmpnum := instr(cli.AQPD785var22, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var22, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var22, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var23) is not null then
        p_n_var := 23;
        ln_tmpnum := instr(cli.AQPD785var23, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var23, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var23, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var24) is not null then
        p_n_var := 24;
        ln_tmpnum := instr(cli.AQPD785var24, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var24, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var24, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var25) is not null then
        p_n_var := 25;
        ln_tmpnum := instr(cli.AQPD785var25, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var25, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var25, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var26) is not null then
        p_n_var := 26;
        ln_tmpnum := instr(cli.AQPD785var26, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var26, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var26, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var27) is not null then
        p_n_var := 27;
        ln_tmpnum := instr(cli.AQPD785var27, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var27, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var27, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var28) is not null then
        p_n_var := 28;
        ln_tmpnum := instr(cli.AQPD785var28, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var28, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var28, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var29) is not null then
        p_n_var := 29;
        ln_tmpnum := instr(cli.AQPD785var29, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var29, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var29, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var30) is not null then
        p_n_var := 30;
        ln_tmpnum := instr(cli.AQPD785var30, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var30, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var30, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var31) is not null then
        p_n_var := 31;
        ln_tmpnum := instr(cli.AQPD785var31, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var31, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var31, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var32) is not null then
        p_n_var := 32;
        ln_tmpnum := instr(cli.AQPD785var32, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var32, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var32, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var33) is not null then
        p_n_var := 33;
        ln_tmpnum := instr(cli.AQPD785var33, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var33, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var33, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var34) is not null then
        p_n_var := 34;
        ln_tmpnum := instr(cli.AQPD785var34, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var34, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var34, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var35) is not null then
        p_n_var := 35;
        ln_tmpnum := instr(cli.AQPD785var35, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var35, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var35, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var36) is not null then
        p_n_var := 36;
        ln_tmpnum := instr(cli.AQPD785var36, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var36, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var36, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var37) is not null then
        p_n_var := 37;
        ln_tmpnum := instr(cli.AQPD785var37, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var37, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var37, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var38) is not null then
        p_n_var := 38;
        ln_tmpnum := instr(cli.AQPD785var38, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var38, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var38, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var39) is not null then
        p_n_var := 39;
        ln_tmpnum := instr(cli.AQPD785var39, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var39, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var39, ln_tmpnum + 1);
      end if;
    
      if trim(cli.AQPD785var40) is not null then
        p_n_var := 40;
        ln_tmpnum := instr(cli.AQPD785var40, '=');
        p_a_nomvar(p_n_var) := substr(cli.AQPD785var40, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.AQPD785var40, ln_tmpnum + 1);
      end if;
    
    end loop;
  
  end sp_cr_cargar_variables_NS_MENS;

end PQ_CR_SEGMENTACION_CLIENT_NUEV_Y;
/
