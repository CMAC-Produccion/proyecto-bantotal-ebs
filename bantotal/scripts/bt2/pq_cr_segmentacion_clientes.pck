CREATE OR REPLACE PACKAGE PQ_CR_SEGMENTACION_CLIENTES is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_SEGMENTACION_CLIENTES
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Clientes
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2013.10.31
  -- Autor de Creación          : CMAC-APACHECO
  -- Uso                        : Evaluador para la Segmentacion de créditos
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2013.11.05
  -- Autor de Modificación      : APACHECO
  -- Descripción de Modificación: AGREGAR ALTER SESSION PARA PUNTO DECIMAL
  --                              2013.11.14 APACHECO -> Modificacion sp_cr_segmenta_clientes, sp_cr_evalua_clientes_1, sp_cr_evalua_clientes_2, sp_cr_evalua_clientes_3 
  --                              2014.06.03 APACHECO -> Modificacion sp_cr_segmenta_clientes
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

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_carga_clientes(P_D_FECPRO in date, P_N_LIMITE IN NUMBER);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_segmenta_clientes_job(P_D_FECPRO in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_segmenta_clientes(P_D_FECPRO in date,
                                    P_C_DIGITO in varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_evalua_clientes_1(P_N_REGLA   IN NUMBER,
                                    P_A_NOMVAR  in PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar,
                                    P_A_VALVAR  in PQ_CR_SEGMENTACION_CLIENTES.tp_valvar,
                                    P_N_VAR     in number,
                                    P_A_REGLAS  in PQ_CR_SEGMENTACION_CLIENTES.tb_reglas,
                                    P_N_REG     in number,
                                    p_c_retorno out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_evalua_clientes_2(P_N_REGLA   IN NUMBER,
                                    P_A_NOMVAR  in PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar,
                                    P_A_VALVAR  in PQ_CR_SEGMENTACION_CLIENTES.tp_valvar,
                                    P_N_VAR     in number,
                                    P_A_REGLAS  in PQ_CR_SEGMENTACION_CLIENTES.tb_reglas,
                                    P_N_REG     in number,
                                    p_c_retorno out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_evalua_clientes_3(P_N_REGLA   IN NUMBER,
                                    P_A_NOMVAR  in PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar,
                                    P_A_VALVAR  in PQ_CR_SEGMENTACION_CLIENTES.tp_valvar,
                                    P_N_VAR     in number,
                                    P_A_REGLAS  in PQ_CR_SEGMENTACION_CLIENTES.tb_reglas,
                                    P_N_REG     in number,
                                    p_c_retorno out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_cargar_variables(P_D_FECPRO IN DATE,
                                   P_N_PAIS   IN JAQY162.JAQY162PAIS%type,
                                   P_N_TDOC   IN JAQY162.JAQY162TDOC%type,
                                   P_C_NDOC   IN JAQY162.JAQY162NDOC%type,
                                   p_a_nomvar out PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar,
                                   p_a_valvar out PQ_CR_SEGMENTACION_CLIENTES.tp_valvar,
                                   p_n_var    out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_carga_clientes_NS(P_D_FECPRO in date,
                                    P_N_LIMITE IN NUMBER);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_segmenta_clientes_job_NS(P_D_FECPRO IN DATE,
                                           PC_USR     IN VARCHAR2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_segmenta_clientes_NS(P_D_FECPRO in date,
                                       P_C_DIGITO in varchar2,
                                       PC_USR     in varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_evalua_clientes_1_NS(P_N_REGLA   IN NUMBER,
                                       P_A_NOMVAR  IN PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar,
                                       P_A_VALVAR  IN PQ_CR_SEGMENTACION_CLIENTES.tp_valvar,
                                       P_N_VAR     IN number,
                                       P_A_REGLAS  in PQ_CR_SEGMENTACION_CLIENTES.tb_reglas,
                                       P_N_REG     in number,
                                       p_c_retorno out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_evalua_clientes_2_NS(P_N_REGLA   IN NUMBER,
                                       P_A_NOMVAR  IN PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar,
                                       P_A_VALVAR  IN PQ_CR_SEGMENTACION_CLIENTES.tp_valvar,
                                       P_N_VAR     IN number,
                                       P_A_REGLAS  in PQ_CR_SEGMENTACION_CLIENTES.tb_reglas,
                                       P_N_REG     in number,
                                       p_c_retorno out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_evalua_clientes_3_NS(P_N_REGLA   IN NUMBER,
                                       P_A_NOMVAR  IN PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar,
                                       P_A_VALVAR  IN PQ_CR_SEGMENTACION_CLIENTES.tp_valvar,
                                       P_N_VAR     IN number,
                                       P_A_REGLAS  in PQ_CR_SEGMENTACION_CLIENTES.tb_reglas,
                                       P_N_REG     in number,
                                       p_c_retorno out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_cargar_variables_NS(P_D_FECPRO IN DATE,
                                      P_N_PAIS   IN JAQZ082.JAQZ082PAIS%type,
                                      P_N_TDOC   IN JAQZ082.JAQZ082TDOC%type,
                                      P_C_NDOC   IN JAQZ082.JAQZ082NDOC%type,
                                      P_C_USR    IN JAQZ082.JAQZ082USR%type,
                                      p_a_nomvar out PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar,
                                      p_a_valvar out PQ_CR_SEGMENTACION_CLIENTES.tp_valvar,
                                      p_n_var    out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --       
  procedure sp_cr_NS_LINEA(P_D_FECPRO in date,
                           PN_PAIS    IN NUMBER,
                           PN_TDOC    IN NUMBER,
                           PC_NDOC    IN VARCHAR2,
                           PC_USR     IN VARCHAR2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  procedure sp_cr_cargar_variables_NS_MENS(P_D_FECPRO IN DATE,
                                           P_N_PAIS   IN JAQZ082.JAQZ082PAIS%type,
                                           P_N_TDOC   IN JAQZ082.JAQZ082TDOC%type,
                                           P_C_NDOC   IN JAQZ082.JAQZ082NDOC%type,
                                           P_C_USR    IN JAQZ082.JAQZ082USR%type,
                                           p_a_nomvar out PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar,
                                           p_a_valvar out PQ_CR_SEGMENTACION_CLIENTES.tp_valvar,
                                           p_n_var    out number);

end PQ_CR_SEGMENTACION_CLIENTES;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_SEGMENTACION_CLIENTES is
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_carga_clientes(P_D_FECPRO in date, P_N_LIMITE IN NUMBER) IS
    -- *****************************************************************
    -- Nombre                     : SP_CL_CLASIFICA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.10.28
    -- Autor de Creación          : CMAC - APACHECO
    -- Uso                        : CARGAR CLIENTES PARA SEGMENTAR
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_D_FECPRO ( FECHA DE PROCESO )
    -- Parámetros de Salida       :
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************
  
    -- cursor c_clientes is
    --  select /*+parallel (c,4,1)*/ aocta--mod@abr 20160905
    --    from fsd010 c--mod@abr 20160905
    --   where (aomod in (select modulo--mod@abr 20160905
    --               from fst111--mod@abr 20160905
    --              where dscod = 50--mod@abr 20160905
    --                and modulo not in (33, 120, 142, 200))--mod@abr 20160905
    --         or aomod = 117)--mod@abr 20160905
    --        and aofval <= P_D_FECPRO;--mod@abr 20160905
    --             
    -- cursor c_ctas is--mod@abr 20160905
    --  select /*+parallel (t,4,1)(c,4,1)*/--mod@abr 20160905
    --   c.pepais, c.petdoc, c.pendoc--mod@abr 20160905
    --    from crdtcap t--mod@abr 20160905
    --   inner join fsr008 c on c.ctnro = t.c_descri--mod@abr 20160905
    --   where c.ttcod = 1--mod@abr 20160905
    --    and c.cttfir = 'T'--mod@abr 20160905
    --   group by c.pepais, c.petdoc, c.pendoc;  --mod@abr 20160905
  
    cursor c_clientes is
      select /*+parallel (c,4,1)*/
       a.pepais, a.petdoc, a.pendoc --aocta
        from fsd010 c, fsr008 a, sngc60 d, sngc07 e
       where (aomod in (select modulo
                          from fst111
                         where dscod = 50
                           and modulo not in (33, 120, 142, 200)) or
             aomod = 117)
         and aofval <= P_D_FECPRO
         and c.aocta = a.ctnro
         and a.ttcod = 1
         and a.cttfir = 'T'
         and a.pepais = d.sngc60pais
         and a.petdoc = d.sngc60tdoc
         and a.pendoc = d.sngc60ndoc
         and d.sngc60ocup = e.sngc07cod
         and e.segcod <> 1
         and a.petdoc <> 9
      --and aocta =52431
       group by a.pepais, a.petdoc, a.pendoc;
    ln_dig    number(3) := null;
    ln_cont   number(10) := null;
    ln_limite number(10) := null;
    lb_flag   boolean := null;
    lc_cadtmp varchar2(15) := null;
    ln_numtmp number(10) := 0;
  
  BEGIN
  
    ln_limite := nvl(P_N_LIMITE, 0);
    ln_cont   := 0;
    lb_flag   := true;
    --delete from crdtcap;
    delete from JAQY163;
    commit;
  
    --for c in c_clientes loop--mod@abr 20160905
    --    INSERT INTO crdtcap (c_descri) VALUES (c.aocta);--mod@abr 20160905
    --    commit;    --mod@abr 20160905         
    --end loop;--mod@abr 20160905
  
    --for c in c_ctas loop --mod@abr 20160905
    for c in c_clientes loop
      ln_cont := ln_cont + 1;
      if ln_limite > 0 then
        if ln_cont <= ln_limite then
          lb_flag := true;
        else
          lb_flag := false;
          exit;
        end if;
      end if;
    
      If lb_flag Then
        begin
          lc_cadtmp := trim(c.pendoc);
          ln_numtmp := length(lc_cadtmp) - 1;
          ln_dig    := to_number(substr(lc_cadtmp, ln_numtmp, 2));
        exception
          when others then
            ln_dig := 0;
        end;
        INSERT INTO JAQY163
          (jaqy163pais, jaqy163tdoc, jaqy163ndoc, jaqy163nume)
        VALUES
          (c.pepais, c.petdoc, c.pendoc, ln_dig);
        commit;
      End If;
    end loop;
  
  END sp_cr_carga_clientes;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  procedure sp_cr_segmenta_clientes_job(P_D_FECPRO IN DATE) is
    -- ******************************************************************************************************
    -- Nombre                     : sp_cr_segmenta_clientes_job
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Clientes
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.10.31
    -- Autor de Creación          : CMAC APACHECO
    -- Uso                        : JOBS PARA SEGMETNACION MENSUAL DE CREDITOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_D_FECPRO ( FECHA DE PROCESO )
    -- Parámetros de Salida       :
    -- Fecha de Modificación      : 2013.11.05
    -- Autor de la Modificación   : APACHECO
    -- Descripción de Modificación: AGREGAR ALTER SESSION
    --                                                         
    -- ********************************************************************************************************
  
    cursor c_clientes_job(p_fecpro date) is
    -- select substr(trim(j.jaqy162ndoc), -1, 1) digito --mod@abr 20160905
    --     from jaqy162 j --mod@abr 20160905
    --    where j.jaqy162fech = p_fecpro --mod@abr 20160905
    --    group by substr(trim(j.jaqy162ndoc), -1, 1); --mod@abr 20160905
    
      select substr(trim(j.jaqy162ndoc), -2, 2) digito
        from jaqy162 j
       where j.jaqy162fech = p_fecpro
         and substr(trim(j.jaqy162ndoc), -2, 2) is not null
       group by substr(trim(j.jaqy162ndoc), -2, 2);
  
    lc_hostname   varchar2(64);
    lc_fecpro     varchar2(10);
    lc_variable   varchar2(4000);
    ln_job        number := 0;
    l_jaqy066pano jaqy066.jaqy066pano%type;
    l_jaqy066pmes jaqy066.jaqy066pmes%type;
    ln_cont       number(5) := 0;
    ln_inst       number(1) := 1;
  BEGIN
  
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    execute immediate 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
    lc_fecpro     := to_char(P_D_FECPRO, 'RRRR.MM.DD');
    l_jaqy066pano := to_number(to_char(add_months(P_D_FECPRO, -1), 'RRRR'));
    l_jaqy066pmes := to_number(to_char(add_months(P_D_FECPRO, -1), 'MM'));
  
    delete from jaqy066
     where jaqy066pano = l_jaqy066pano
       and jaqy066pmes = l_jaqy066pmes
       and jaqy066tse = 'A';
    commit;
  
    for job in c_clientes_job(P_D_FECPRO) loop
    
      lc_variable := ' begin ' ||
                     ' PQ_CR_SEGMENTACION_CLIENTES.sp_cr_segmenta_clientes(TO_DATE(''' ||
                     lc_fecpro || ''',''RRRR.MM.DD''),''' || job.digito ||
                     ''');' || ' End; ';
      ln_cont     := ln_cont + 1;
    
      if (ln_cont >= 6) then
        ln_inst := 2;
      end if;
    
      ln_job := ln_job + 1;
    
      --              DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*60));
      --if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then 
      --if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        --                     instance => ln_inst,
                        --instance => 2,--Solo por hoy 01.07.2015 hmev new 01/01/2024
                        instance => 1,
                        force    => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      commit;
    
    end loop;
  
  end sp_cr_segmenta_clientes_job;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  procedure sp_cr_segmenta_clientes(P_D_FECPRO in date,
                                    P_C_DIGITO in varchar2) IS
    -- *****************************************************************
    -- Nombre                     : SP_CL_CLASIFICA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.10.28
    -- Autor de Creación          : CMAC - APACHECO
    -- Uso                        : CARGAR CLIENTES PARA SEGMENTAR
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_D_FECPRO ( FECHA DE PROCESO )
    -- Parámetros de Salida       :
    -- Fecha de Modificación      : 2013.11.05
    -- Autor de la Modificación   : APACHECO
    -- Descripción de Modificación: AGREGAR ALTER SESSION
    --                              2013.11.14 APACHECO -> Usar arrays para consulta de reglas
    --                              2014.06.03 APACHECO -> Agregar tipo de calificación P=proceso
    -- *****************************************************************
  
    cursor c_clientes(p_fecpro date, p_anio number, p_mes number) is
      select /*+all_rows index_ss(l)*/
       jaqy162pais, jaqy162tdoc, jaqy162ndoc
        from jaqy162 l
       where jaqy162fech = p_fecpro
         and not exists
       (select 1
                from jaqy066 c
               where c.jaqy066paic = l.jaqy162pais
                 and c.jaqy066tdoc = l.jaqy162tdoc
                 and c.jaqy066tndoc = l.jaqy162ndoc
                 and c.jaqy066pano = p_anio
                 and c.jaqy066pmes = p_mes
                 and c.jaqy066tse = 'A')
         and substr(trim(jaqy162ndoc), -2, 2) = P_C_DIGITO;
    --and jaqy162ndoc = '43716599';
  
    cursor c_reglas is
    /*select \*+ALL_ROWS*\ 
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
              inner join frng51 t on g.rng49cod = t.rng49cod
                                 and g.rng50grp = t.rng50grp
              inner join frng68 a on t.rng49cod = a.rng49cod
                                 and t.rng68cod = a.rng68cod                   
              where t.RNG49Cod in (1611, 1612, 1613, 1614, 1617)
    --and g.RNG50ORD>=49--
              order by g.RNG49COD, g.RNG50ORD; */
    
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
       where t.RNG49Cod in (1611, 1612, 1613, 1614, 1617)
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
    la_nomvar      PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar;
    la_valvar      PQ_CR_SEGMENTACION_CLIENTES.tp_valvar;
    la_nomnul      PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar;
    la_valnul      PQ_CR_SEGMENTACION_CLIENTES.tp_valvar;
    ln_var         number(3) := 0;
    Tp1cod         fst198.tp1cod%type;
    Tp1cod1        fst198.tp1cod1%type;
    Tp1corr1       fst198.tp1corr1%type;
    Tp1corr2       fst198.tp1corr2%type;
    Tp1desc        fst198.tp1desc%type;
    JAQY067CCAL    jaqy067.jaqy067ccal%type;
    l_jaqy066pano  jaqy066.jaqy066pano%type;
    l_jaqy066pmes  jaqy066.jaqy066pmes%type;
    l_jaqy066paic  jaqy066.jaqy066paic%type;
    l_jaqy066tdoc  jaqy066.jaqy066tdoc%type;
    l_jaqy066tndoc jaqy066.jaqy066tndoc%type;
    l_jaqy066calf  jaqy066.jaqy066calf%type;
    l_jaqy066fecp  jaqy066.jaqy066fecp%type;
    l_jaqy066horp  jaqy066.jaqy066horp%type;
    l_jaqy066tcal  jaqy066.jaqy066tcal%type;
  
    TYPE tp_pais IS TABLE OF jaqy162.jaqy162pais%type INDEX BY BINARY_INTEGER;
    TYPE tp_tdoc IS TABLE OF jaqy162.jaqy162tdoc%type INDEX BY BINARY_INTEGER;
    TYPE tp_ndoc IS TABLE OF jaqy162.jaqy162ndoc%type INDEX BY BINARY_INTEGER;
  
    la_jaqy162pais tp_pais;
    la_jaqy162tdoc tp_tdoc;
    la_jaqy162ndoc tp_ndoc;
    la_reglas      pq_cr_segmentacion_clientes.tb_reglas;
    ln_reg         number(5);
  
  BEGIN
  
    execute immediate 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
    execute immediate 'ALTER SESSION SET OPTIMIZER_MODE=ALL_ROWS'; --jflor 2014.01.17  
    execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE'; --jflor 2014.05.05
  
    l_jaqy066fecp := P_D_FECPRO;
    l_jaqy066pano := to_number(to_char(add_months(P_D_FECPRO, -1), 'RRRR'));
    l_jaqy066pmes := to_number(to_char(add_months(P_D_FECPRO, -1), 'MM'));
    Regla         := 1611;
  
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
  
    OPEN c_clientes(P_D_FECPRO, l_jaqy066pano, l_jaqy066pmes); -- Clientes Bulk
    FETCH c_clientes BULK COLLECT
      INTO la_jaqy162pais, la_jaqy162tdoc, la_jaqy162ndoc;
  
    IF la_jaqy162ndoc.count > 0 THEN
      FOR c IN la_jaqy162ndoc.FIRST .. la_jaqy162ndoc.LAST LOOP
      
        la_nomvar := la_nomnul;
        la_valvar := la_valnul;
        pq_cr_segmentacion_clientes.sp_cr_cargar_variables(P_D_FECPRO => P_D_FECPRO,
                                                           P_N_PAIS   => la_jaqy162pais(c),
                                                           P_N_TDOC   => la_jaqy162tdoc(c),
                                                           P_C_NDOC   => la_jaqy162ndoc(c),
                                                           p_a_nomvar => la_nomvar,
                                                           p_a_valvar => la_valvar,
                                                           p_n_var    => ln_var);
        SegmentoRegla := null;
        pq_cr_segmentacion_clientes.sp_cr_evalua_clientes_1(P_N_REGLA   => Regla,
                                                            P_A_NOMVAR  => la_nomvar,
                                                            P_A_VALVAR  => la_valvar,
                                                            P_N_VAR     => ln_var,
                                                            P_A_REGLAS  => la_reglas,
                                                            P_N_REG     => ln_reg,
                                                            p_c_retorno => SegmentoRegla);
      
        Tp1cod      := 1;
        Tp1cod1     := 10823;
        Tp1corr1    := 2;
        Tp1corr2    := 7; -- Equivalencia resultado reglas - calificacion
        Tp1desc     := Trim(SegmentoRegla);
        JAQY067CCAL := null;
      
        For g in c_guia(Tp1cod, Tp1cod1, Tp1corr1, Tp1corr2) loop
          If g.tp1desc = Tp1desc Then
            JAQY067CCAL := g.tp1nro1;
          End If;
        End Loop;
      
        If JAQY067CCAL is not null then
          -- Califica
          l_jaqy066paic  := la_jaqy162pais(c);
          l_jaqy066tdoc  := la_jaqy162tdoc(c);
          l_jaqy066tndoc := la_jaqy162ndoc(c);
          l_jaqy066calf  := JAQY067CCAL;
          l_jaqy066horp  := to_char(sysdate(), 'HH24:MI:SS');
          l_jaqy066tcal  := 'P';
        
          insert into jaqy066
            (JAQY066PANO,
             JAQY066PMES,
             JAQY066PAIC,
             JAQY066TDOC,
             JAQY066TNDOC,
             JAQY066CALF,
             JAQY066FECP,
             JAQY066HORP,
             JAQY066TCAL,
             jaqy066tse)
          values
            (l_jaqy066pano,
             l_jaqy066pmes,
             l_jaqy066paic,
             l_jaqy066tdoc,
             l_jaqy066tndoc,
             l_jaqy066calf,
             l_jaqy066fecp,
             l_jaqy066horp,
             l_jaqy066tcal,
             'A');
          commit;
        
        End If;
      
      END LOOP; -- clientes
    END IF;
  
  END sp_cr_segmenta_clientes;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_cr_evalua_clientes_1(P_N_REGLA   IN NUMBER,
                                    P_A_NOMVAR  IN PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar,
                                    P_A_VALVAR  IN PQ_CR_SEGMENTACION_CLIENTES.tp_valvar,
                                    P_N_VAR     IN number,
                                    P_A_REGLAS  in PQ_CR_SEGMENTACION_CLIENTES.tb_reglas,
                                    P_N_REG     in number,
                                    p_c_retorno out varchar2) IS
    -- *****************************************************************
    -- Nombre                     : SP_CL_CLASIFICA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.10.28
    -- Autor de Creación          : CMAC - APACHECO
    -- Uso                        : EVALUAR REGLAS 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_D_FECPRO ( FECHA DE PROCESO )
    -- Parámetros de Salida       :
    -- Fecha de Modificación      : 2013.11.05
    -- Autor de la Modificación   : APACHECO
    -- Descripción de Modificación: QUITAR MASCARA DE CONVERSION
    --                              2013.11.14 APACHECO -> Usar arrays para las reglas
    -- *****************************************************************
  
    /*cursor c_reglas -- (p_RNG49Cod number) 
    is 
        select t.RNG49COD,
               t.RNG50GRP,
               t.RNG51COD,
               t.RNG68COD,
               t.RNG51OPE,
               t.RNG51VAL,
               a.RNG68ATR,
               a.RNG68TDA,
               g.RNG50Ret
          from FRNG50 g
         inner join frng51 t on g.rng49cod = t.rng49cod
                            and g.rng50grp = t.rng50grp
         inner join frng68 a on t.rng49cod = a.rng49cod
                            and t.rng68cod = a.rng68cod                   
         where t.RNG49Cod in (1611, 1612, 1613, 1614, 1617)
         -- = p_RNG49Cod
         order by g.RNG49COD, g.RNG50ORD;  */
  
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
    la_nomvar      PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar;
    la_valvar      PQ_CR_SEGMENTACION_CLIENTES.tp_valvar;
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
    la_reglas      pq_cr_segmentacion_clientes.tb_reglas;
    ln_reg         number(5);
    ln_ind         number(5);
  
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
        If la_reglas(ln_ind)
         .RNG68ATR in ('EXP1612', 'EXP1613', 'EXP1614', 'EXP1617') then
        
          Regla2 := to_number(substr(la_reglas(ln_ind).RNG68ATR, 4, 4));
          --Msg('rutina regla anidada ' + Str(&Regla2))
          SegmentoRegla2 := null;
          PQ_CR_SEGMENTACION_CLIENTES.sp_cr_evalua_clientes_2(P_N_REGLA   => Regla2,
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
            /*
            l_RNG68Tda := reg.rng68tda;
            -- Evaluacion para números
            If (l_RNG68Tda in ('E','N')) then 
                ln_NumTmp1 := to_number(lc_valResuelto);
                ln_NumTmp2 := to_number(l_RNG51Val);
                If ln_NumTmp1 <> ln_NumTmp2 then --to_number(ValResuelto) <> to_number(ReglaNegocioN2.RNG51VAL)
                    --Msg('no cumple num ' + VeRNG68ATR(j))
                    ResReglaGrupo := 'N';
                End If;
            End If;
            -- Evaluacion para caracteres                
            If l_RNG68Tda = 'C' And lc_valResuelto <> l_RNG51Val then 
                 --Msg('no cumple ' + VeRNG68ATR(j))
                ResReglaGrupo := 'N';
            End If;*/
        
          When '<>' then
            --Msg('es diferente que ' + VeRNG51VAL(j))
            --Msg(ValResuelto)
          
            If lc_valResuelto = l_RNG51Val then
              --Msg('no cumple ' + VeRNG68ATR(j))
              ResReglaGrupo := 'N';
            End If;
          
        /*l_RNG68Tda := reg.rng68tda;
                            -- Evaluacion para números
                            If (l_RNG68Tda in ('E','N')) then 
                                ln_NumTmp1 := to_number(lc_valResuelto);
                                ln_NumTmp2 := to_number(l_RNG51Val);             
                                If ln_NumTmp1 = ln_NumTmp2 then --Val(ValResuelto) = Val(ReglaNegocioN2.RNG51VAL)
                                    --Msg('no cumple ' + VeRNG68ATR(j))
                                    ResReglaGrupo := 'N';
                                End If;
                            End If;
                            -- Evaluacion para caracteres
                            If l_RNG68Tda = 'C' And lc_valResuelto = l_RNG51Val then
                                --Msg('no cumple ' + VeRNG68ATR(j))
                                ResReglaGrupo := 'N';
                            End If;*/
        
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
  
  END sp_cr_evalua_clientes_1;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_cr_evalua_clientes_2(P_N_REGLA   IN NUMBER,
                                    P_A_NOMVAR  IN PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar,
                                    P_A_VALVAR  IN PQ_CR_SEGMENTACION_CLIENTES.tp_valvar,
                                    P_N_VAR     IN number,
                                    P_A_REGLAS  in PQ_CR_SEGMENTACION_CLIENTES.tb_reglas,
                                    P_N_REG     in number,
                                    p_c_retorno out varchar2) IS
    -- *****************************************************************
    -- Nombre                     : SP_CL_CLASIFICA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.10.28
    -- Autor de Creación          : CMAC - APACHECO
    -- Uso                        : EVALUAR REGLAS DE NIVEL 2 ANIDAMIENTO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_D_FECPRO ( FECHA DE PROCESO )
    -- Parámetros de Salida       :
    -- Fecha de Modificación      : 2013.11.05
    -- Autor de la Modificación   : APACHECO
    -- Descripción de Modificación: QUITAR MASCARA DE CONVERSION
    --                              2013.11.08 APACHECO -> Agregar codigo para 3er nivel de anidamiento de las reglas
    --                              2013.11.14 APACHECO -> Usar arrays para las reglas
    -- *****************************************************************
  
    /*cursor c_reglas(p_RNG49Cod number) is 
    select t.RNG49COD,
           t.RNG50GRP,
           t.RNG51COD,
           t.RNG68COD,
           t.RNG51OPE,
           t.RNG51VAL,
           a.RNG68ATR,
           a.RNG68TDA,
           g.RNG50Ret
      from FRNG50 g
     inner join frng51 t on g.rng49cod = t.rng49cod
                        and g.rng50grp = t.rng50grp
     inner join frng68 a on t.rng49cod = a.rng49cod
                        and t.rng68cod = a.rng68cod                   
     where t.RNG49Cod = p_RNG49Cod
     order by g.RNG49COD, g.RNG50ORD; */
  
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
    la_nomvar      PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar;
    la_valvar      PQ_CR_SEGMENTACION_CLIENTES.tp_valvar;
    ln_var         number(3) := 0;
    lc_valResuelto varchar2(30);
    i              number(3);
    ln_NumTmp1     number(10, 2);
    ln_NumTmp2     number(10, 2);
    l_RNG68Tda     frng68.rng68tda%type;
    l_RNG51Val     varchar2(30);
    l_RNG67val     varchar2(30);
    SegmentoRegla3 frng51.rng51val%type;
    Regla3         frng51.rng49cod%type;
    l_RNG51OPE     varchar2(2);
    la_reglas      pq_cr_segmentacion_clientes.tb_reglas;
    ln_reg         number(5);
    ln_ind         number(5);
  
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
        If la_reglas(ln_ind)
         .RNG68ATR in ('EXP1612', 'EXP1613', 'EXP1614', 'EXP1617') then
        
          Regla3 := to_number(substr(la_reglas(ln_ind).RNG68ATR, 4, 4));
          --Msg('rutina regla anidada ' + Str(&Regla2))
          SegmentoRegla3 := null;
          PQ_CR_SEGMENTACION_CLIENTES.sp_cr_evalua_clientes_3(P_N_REGLA   => Regla3,
                                                              P_A_NOMVAR  => la_nomvar,
                                                              P_A_VALVAR  => la_valvar,
                                                              P_N_VAR     => ln_var,
                                                              P_A_REGLAS  => la_reglas,
                                                              P_N_REG     => ln_reg,
                                                              p_c_retorno => SegmentoRegla3);
          lc_valResuelto := Trim(SegmentoRegla3);
        
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
          
        /*l_RNG68Tda := reg.rng68tda;
                            -- Evaluacion para números
                            If (l_RNG68Tda in ('E','N')) then 
                                ln_NumTmp1 := to_number(lc_valResuelto);
                                ln_NumTmp2 := to_number(l_RNG51Val);
                                If ln_NumTmp1 <> ln_NumTmp2 then --to_number(ValResuelto) <> to_number(ReglaNegocioN2.RNG51VAL)
                                    --Msg('no cumple num ' + VeRNG68ATR(j))
                                    ResReglaGrupo := 'N';
                                End If;
                            End If;
                            -- Evaluacion para caracteres                
                            If l_RNG68Tda = 'C' And lc_valResuelto <> l_RNG51Val then 
                                 --Msg('no cumple ' + VeRNG68ATR(j))
                                ResReglaGrupo := 'N';
                            End If;
                            */
        
          When '<>' then
            --Msg('es diferente que ' + VeRNG51VAL(j))
            --Msg(ValResuelto)
          
            If lc_valResuelto = l_RNG51Val then
              --Msg('no cumple ' + VeRNG68ATR(j))
              ResReglaGrupo := 'N';
            End If;
            /*
            l_RNG68Tda := reg.rng68tda;
            -- Evaluacion para números
            If (l_RNG68Tda in ('E','N')) then 
                ln_NumTmp1 := to_number(lc_valResuelto);
                ln_NumTmp2 := to_number(l_RNG51Val);             
                If ln_NumTmp1 = ln_NumTmp2 then --Val(ValResuelto) = Val(ReglaNegocioN2.RNG51VAL)
                    --Msg('no cumple ' + VeRNG68ATR(j))
                    ResReglaGrupo := 'N';
                End If;
            End If;
            -- Evaluacion para caracteres
            If l_RNG68Tda = 'C' And lc_valResuelto = l_RNG51Val then
                --Msg('no cumple ' + VeRNG68ATR(j))
                ResReglaGrupo := 'N';
            End If;
            */
        
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
  
  END sp_cr_evalua_clientes_2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_cr_evalua_clientes_3(P_N_REGLA   IN NUMBER,
                                    P_A_NOMVAR  IN PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar,
                                    P_A_VALVAR  IN PQ_CR_SEGMENTACION_CLIENTES.tp_valvar,
                                    P_N_VAR     IN number,
                                    P_A_REGLAS  in PQ_CR_SEGMENTACION_CLIENTES.tb_reglas,
                                    P_N_REG     in number,
                                    p_c_retorno out varchar2) IS
    -- *****************************************************************
    -- Nombre                     : SP_CL_CLASIFICA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.11.08
    -- Autor de Creación          : CMAC - APACHECO
    -- Uso                        : EVALUAR REGLAS DE NIVEL 3 ANIDAMIENTO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_D_FECPRO ( FECHA DE PROCESO )
    -- Parámetros de Salida       :
    -- Fecha de Modificación      : 2013.11.14
    -- Autor de la Modificación   : APACHECO 
    -- Descripción de Modificación: Usar arrays para las reglas
    --  
    -- *****************************************************************
  
    /*cursor c_reglas(p_RNG49Cod number) is 
    select t.RNG49COD,
           t.RNG50GRP,
           t.RNG51COD,
           t.RNG68COD,
           t.RNG51OPE,
           t.RNG51VAL,
           a.RNG68ATR,
           a.RNG68TDA,
           g.RNG50Ret
      from FRNG50 g
     inner join frng51 t on g.rng49cod = t.rng49cod
                        and g.rng50grp = t.rng50grp
     inner join frng68 a on t.rng49cod = a.rng49cod
                        and t.rng68cod = a.rng68cod                   
     where t.RNG49Cod = p_RNG49Cod
     order by g.RNG49COD, g.RNG50ORD; */
  
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
    la_nomvar      PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar;
    la_valvar      PQ_CR_SEGMENTACION_CLIENTES.tp_valvar;
    ln_var         number(3) := 0;
    lc_valResuelto varchar2(30);
    i              number(3);
    ln_NumTmp1     number(10, 2);
    ln_NumTmp2     number(10, 2);
    l_RNG68Tda     frng68.rng68tda%type;
    l_RNG51Val     varchar2(30);
    l_RNG67val     varchar2(30);
    l_RNG51OPE     varchar2(2);
    la_reglas      pq_cr_segmentacion_clientes.tb_reglas;
    ln_reg         number(5);
    ln_ind         number(5);
  
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
          
        /*l_RNG68Tda := reg.rng68tda;
                         -- Evaluacion para números
                         If (l_RNG68Tda in ('E','N')) then 
                             ln_NumTmp1 := to_number(lc_valResuelto);
                             ln_NumTmp2 := to_number(l_RNG51Val);
                             If ln_NumTmp1 <> ln_NumTmp2 then --to_number(ValResuelto) <> to_number(ReglaNegocioN2.RNG51VAL)
                                 --Msg('no cumple num ' + VeRNG68ATR(j))
                                 ResReglaGrupo := 'N';
                             End If;
                         End If;
                         -- Evaluacion para caracteres                
                         If l_RNG68Tda = 'C' And lc_valResuelto <> l_RNG51Val then 
                              --Msg('no cumple ' + VeRNG68ATR(j))
                             ResReglaGrupo := 'N';
                         End If;
                         */
        
          When '<>' then
            --Msg('es diferente que ' + VeRNG51VAL(j))
            --Msg(ValResuelto)
          
            If lc_valResuelto = l_RNG51Val then
              --Msg('no cumple ' + VeRNG68ATR(j))
              ResReglaGrupo := 'N';
            End If;
            /*
            l_RNG68Tda := reg.rng68tda;
            -- Evaluacion para números
            If (l_RNG68Tda in ('E','N')) then 
                ln_NumTmp1 := to_number(lc_valResuelto);
                ln_NumTmp2 := to_number(l_RNG51Val);             
                If ln_NumTmp1 = ln_NumTmp2 then --Val(ValResuelto) = Val(ReglaNegocioN2.RNG51VAL)
                    --Msg('no cumple ' + VeRNG68ATR(j))
                    ResReglaGrupo := 'N';
                End If;
            End If;
            -- Evaluacion para caracteres
            If l_RNG68Tda = 'C' And lc_valResuelto = l_RNG51Val then
                --Msg('no cumple ' + VeRNG68ATR(j))
                ResReglaGrupo := 'N';
            End If;
            */
        
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
  
  END sp_cr_evalua_clientes_3;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_cr_cargar_variables(P_D_FECPRO IN DATE,
                                   P_N_PAIS   IN JAQY162.JAQY162PAIS%type,
                                   P_N_TDOC   IN JAQY162.JAQY162TDOC%type,
                                   P_C_NDOC   IN JAQY162.JAQY162NDOC%type,
                                   p_a_nomvar out PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar,
                                   p_a_valvar out PQ_CR_SEGMENTACION_CLIENTES.tp_valvar,
                                   p_n_var    out number) is
    -- *****************************************************************
    -- Nombre                     : SP_CL_CLASIFICA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.10.28
    -- Autor de Creación          : CMAC - APACHECO
    -- Uso                        : CARGAR CLIENTES PARA SEGMENTAR
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_D_FECPRO ( FECHA DE PROCESO )
    -- Parámetros de Salida       :
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************
  
    cursor c_cliente is
      select jaqy162fech,
             jaqy162pais,
             jaqy162tdoc,
             jaqy162ndoc,
             jaqy162var1,
             jaqy162var2,
             jaqy162var3,
             jaqy162var4,
             jaqy162var5,
             jaqy162var6,
             jaqy162var7,
             jaqy162var8,
             jaqy162var9,
             jaqy162var10,
             jaqy162var11,
             jaqy162var12,
             jaqy162var13,
             jaqy162var14,
             jaqy162var15,
             jaqy162var16,
             jaqy162var17,
             jaqy162var18,
             jaqy162var19,
             jaqy162var20,
             jaqy162var21,
             jaqy162var22,
             jaqy162var23,
             jaqy162var24,
             jaqy162var25,
             jaqy162var26,
             jaqy162var27,
             jaqy162var28,
             jaqy162var29,
             jaqy162var30,
             jaqy162var31,
             jaqy162var32,
             jaqy162var33,
             jaqy162var34,
             jaqy162var35,
             jaqy162var36,
             jaqy162var37,
             jaqy162var38,
             jaqy162var39,
             jaqy162var40
        from jaqy162
       where jaqy162fech = P_D_FECPRO
         and jaqy162pais = P_N_PAIS
         and jaqy162tdoc = P_N_TDOC
         and jaqy162ndoc = P_C_NDOC;
    ln_tmpnum number(3);
  
  begin
  
    for cli in c_cliente loop
      -- Cargando Variables Resuletas
      if trim(cli.jaqy162var1) is not null then
        p_n_var := 1;
        ln_tmpnum := instr(cli.jaqy162var1, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var1, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var1, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var2) is not null then
        p_n_var := 2;
        ln_tmpnum := instr(cli.jaqy162var2, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var2, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var2, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var3) is not null then
        p_n_var := 3;
        ln_tmpnum := instr(cli.jaqy162var3, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var3, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var3, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var4) is not null then
        p_n_var := 4;
        ln_tmpnum := instr(cli.jaqy162var4, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var4, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var4, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var5) is not null then
        p_n_var := 5;
        ln_tmpnum := instr(cli.jaqy162var5, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var5, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var5, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var6) is not null then
        p_n_var := 6;
        ln_tmpnum := instr(cli.jaqy162var6, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var6, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var6, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var7) is not null then
        p_n_var := 7;
        ln_tmpnum := instr(cli.jaqy162var7, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var7, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var7, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var8) is not null then
        p_n_var := 8;
        ln_tmpnum := instr(cli.jaqy162var8, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var8, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var8, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var9) is not null then
        p_n_var := 9;
        ln_tmpnum := instr(cli.jaqy162var9, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var9, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var9, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var10) is not null then
        p_n_var := 10;
        ln_tmpnum := instr(cli.jaqy162var10, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var10, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var10, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var11) is not null then
        p_n_var := 11;
        ln_tmpnum := instr(cli.jaqy162var11, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var11, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var11, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var12) is not null then
        p_n_var := 12;
        ln_tmpnum := instr(cli.jaqy162var12, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var12, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var12, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var13) is not null then
        p_n_var := 13;
        ln_tmpnum := instr(cli.jaqy162var13, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var13, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var13, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var14) is not null then
        p_n_var := 14;
        ln_tmpnum := instr(cli.jaqy162var14, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var14, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var14, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var15) is not null then
        p_n_var := 15;
        ln_tmpnum := instr(cli.jaqy162var15, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var15, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var15, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var16) is not null then
        p_n_var := 16;
        ln_tmpnum := instr(cli.jaqy162var16, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var16, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var16, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var17) is not null then
        p_n_var := 17;
        ln_tmpnum := instr(cli.jaqy162var17, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var17, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var17, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var18) is not null then
        p_n_var := 18;
        ln_tmpnum := instr(cli.jaqy162var18, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var18, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var18, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var19) is not null then
        p_n_var := 19;
        ln_tmpnum := instr(cli.jaqy162var19, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var19, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var19, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var20) is not null then
        p_n_var := 20;
        ln_tmpnum := instr(cli.jaqy162var20, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var20, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var20, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var21) is not null then
        p_n_var := 21;
        ln_tmpnum := instr(cli.jaqy162var21, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var21, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var21, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var22) is not null then
        p_n_var := 22;
        ln_tmpnum := instr(cli.jaqy162var22, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var22, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var22, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var23) is not null then
        p_n_var := 23;
        ln_tmpnum := instr(cli.jaqy162var23, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var23, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var23, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var24) is not null then
        p_n_var := 24;
        ln_tmpnum := instr(cli.jaqy162var24, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var24, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var24, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var25) is not null then
        p_n_var := 25;
        ln_tmpnum := instr(cli.jaqy162var25, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var25, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var25, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var26) is not null then
        p_n_var := 26;
        ln_tmpnum := instr(cli.jaqy162var26, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var26, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var26, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var27) is not null then
        p_n_var := 27;
        ln_tmpnum := instr(cli.jaqy162var27, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var27, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var27, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var28) is not null then
        p_n_var := 28;
        ln_tmpnum := instr(cli.jaqy162var28, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var28, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var28, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var29) is not null then
        p_n_var := 29;
        ln_tmpnum := instr(cli.jaqy162var29, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var29, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var29, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var30) is not null then
        p_n_var := 30;
        ln_tmpnum := instr(cli.jaqy162var30, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var30, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var30, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var31) is not null then
        p_n_var := 31;
        ln_tmpnum := instr(cli.jaqy162var31, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var31, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var31, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var32) is not null then
        p_n_var := 32;
        ln_tmpnum := instr(cli.jaqy162var32, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var32, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var32, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var33) is not null then
        p_n_var := 33;
        ln_tmpnum := instr(cli.jaqy162var33, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var33, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var33, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var34) is not null then
        p_n_var := 34;
        ln_tmpnum := instr(cli.jaqy162var34, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var34, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var34, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var35) is not null then
        p_n_var := 35;
        ln_tmpnum := instr(cli.jaqy162var35, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var35, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var35, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var36) is not null then
        p_n_var := 36;
        ln_tmpnum := instr(cli.jaqy162var36, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var36, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var36, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var37) is not null then
        p_n_var := 37;
        ln_tmpnum := instr(cli.jaqy162var37, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var37, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var37, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var38) is not null then
        p_n_var := 38;
        ln_tmpnum := instr(cli.jaqy162var38, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var38, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var38, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var39) is not null then
        p_n_var := 39;
        ln_tmpnum := instr(cli.jaqy162var39, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var39, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var39, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqy162var40) is not null then
        p_n_var := 40;
        ln_tmpnum := instr(cli.jaqy162var40, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqy162var40, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqy162var40, ln_tmpnum + 1);
      end if;
    
    end loop;
  
  end sp_cr_cargar_variables;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -------------------------------------------------------------------------------------------
  --**************************************************************************************---
  procedure sp_cr_carga_clientes_NS(P_D_FECPRO in date,
                                    P_N_LIMITE IN NUMBER) IS
  
    cursor c_clientes is
      select /*+parallel (c,4,1)*/
       a.pepais, a.petdoc, a.pendoc --aocta
        from fsd010 c, fsr008 a
       where (aomod in (select modulo
                          from fst111
                         where dscod = 50
                           and modulo not in (33, 120, 142, 200)) or
             aomod = 117)
         and aofval <= P_D_FECPRO
         and c.aocta = a.ctnro
         and a.ttcod = 1
         and a.cttfir = 'T'
      --and aocta =52431
       group by a.pepais, a.petdoc, a.pendoc;
  
    /*  cursor c_ctas is
    select \*+parallel (t,4,1)(c,4,1)*\
     c.pepais, c.petdoc, c.pendoc
      from crdtcap t
     inner join fsr008 c on c.ctnro = t.c_descri
     where c.ttcod = 1
      and c.cttfir = 'T'
     group by c.pepais, c.petdoc, c.pendoc;  */
  
    ln_dig    number(3) := null;
    ln_cont   number(10) := null;
    ln_limite number(10) := null;
    lb_flag   boolean := null;
    lc_cadtmp varchar2(15) := null;
    ln_numtmp number(10) := 0;
  
  BEGIN
  
    ln_limite := nvl(P_N_LIMITE, 0);
    ln_cont   := 0;
    lb_flag   := true;
    --delete from crdtcap;
    delete from JAQY163;
    commit;
  
    /* for c in c_clientes loop
        INSERT INTO crdtcap (c_descri) VALUES (c.aocta);
        commit;             
    end loop;*/
  
    for c in c_clientes loop
      ln_cont := ln_cont + 1;
      if ln_limite > 0 then
        if ln_cont <= ln_limite then
          lb_flag := true;
        else
          lb_flag := false;
          exit;
        end if;
      end if;
    
      If lb_flag Then
        begin
          lc_cadtmp := trim(c.pendoc);
          ln_numtmp := length(lc_cadtmp) - 1;
          ln_dig    := to_number(substr(lc_cadtmp, ln_numtmp, 2));
        exception
          when others then
            ln_dig := 0;
        end;
        INSERT INTO JAQY163
          (jaqy163pais, jaqy163tdoc, jaqy163ndoc, jaqy163nume)
        VALUES
          (c.pepais, c.petdoc, c.pendoc, ln_dig);
        commit;
      End If;
    end loop;
  
  END sp_cr_carga_clientes_NS;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  procedure sp_cr_segmenta_clientes_job_NS(P_D_FECPRO IN DATE,
                                           PC_USR     IN VARCHAR2) is
  
    cursor c_clientes_job(p_fecpro date) is
      select substr(trim(j.JAQZ095ndoc), -1, 1) digito, j.jaqz095usr
        from JAQZ095 j
       where j.JAQZ095fech = p_fecpro
         and j.jaqz095usr = PC_USR
       group by substr(trim(j.JAQZ095ndoc), -1, 1), j.jaqz095usr;
  
    lc_hostname   varchar2(64);
    lc_fecpro     varchar2(10);
    lc_variable   varchar2(4000);
    ln_job        number := 0;
    l_JAQY066pano JAQY066.JAQY066pano%type;
    l_JAQY066pmes JAQY066.JAQY066pmes%type;
    ln_cont       number(2) := 0;
    ln_inst       number(1) := 1;
  BEGIN
  
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    execute immediate 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
    lc_fecpro     := to_char(P_D_FECPRO, 'RRRR.MM.DD');
    l_JAQY066pano := to_number(to_char(P_D_FECPRO, 'RRRR'));
    l_JAQY066pmes := to_number(to_char(P_D_FECPRO, 'MM'));
    --l_JAQY066pano := to_number(to_char(add_months(P_D_FECPRO, -1),'RRRR'));
    --l_JAQY066pmes := to_number(to_char(add_months(P_D_FECPRO, -1),'MM')); 
  
    delete from JAQY066 A
     where JAQY066pano = l_JAQY066pano
       and JAQY066pmes = l_JAQY066pmes
       and a.JAQY066nse = 'S';
    commit;
  
    for job in c_clientes_job(P_D_FECPRO) loop
    
      lc_variable := ' begin ' ||
                     ' PQ_CR_SEGMENTACION_CLIENTES.sp_cr_segmenta_clientes_NS(TO_DATE(''' ||
                     lc_fecpro || ''',''RRRR.MM.DD''),''' || job.digito ||
                     ''',''' || job.jaqz095usr || ''');' || ' End; ';
      ln_cont     := ln_cont + 1;
    
      if (ln_cont >= 50) then
        ln_inst := 2;
      end if;
    
      ln_job := ln_job + 1;
    
      --              DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*60));
      --if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then
      --if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
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
      commit;
    
    end loop;
  
  end sp_cr_segmenta_clientes_job_NS;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  procedure sp_cr_segmenta_clientes_NS(P_D_FECPRO in date,
                                       P_C_DIGITO in varchar2,
                                       PC_USR     in varchar2) IS
  
    cursor c_clientes(p_fecpro date, p_anio number, p_mes number) is
      select /*+all_rows index_ss(l)*/
       JAQZ095pais, JAQZ095tdoc, JAQZ095ndoc
        from JAQZ095 l
       where JAQZ095fech = p_fecpro
         and not exists (select 1
                from JAQY066 c
               where c.JAQY066paic = l.JAQZ095pais
                 and c.JAQY066tdoc = l.JAQZ095tdoc
                 and c.JAQY066tndoc = l.JAQZ095ndoc
                 and c.JAQY066pano = p_anio
                 and c.JAQY066pmes = p_mes
                 and c.JAQY066NSE = 'S') --ANDREA Bernedo 16.03.2016
         and substr(trim(JAQZ095ndoc), -1, 1) = P_C_DIGITO
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
      --   where t.RNG49Cod in (1620, 1621) --mod@abr20180110
       where t.RNG49Cod in (1620, 1621, 1624) --mod@abr20180110
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
    la_nomvar      PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar;
    la_valvar      PQ_CR_SEGMENTACION_CLIENTES.tp_valvar;
    la_nomnul      PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar;
    la_valnul      PQ_CR_SEGMENTACION_CLIENTES.tp_valvar;
    ln_var         number(3) := 0;
    Tp1cod         fst198.tp1cod%type;
    Tp1cod1        fst198.tp1cod1%type;
    Tp1corr1       fst198.tp1corr1%type;
    Tp1corr2       fst198.tp1corr2%type;
    Tp1desc        fst198.tp1desc%type;
    JAQY067CCAL    jaqy067.jaqy067ccal%type;
    l_JAQY066pano  JAQY066.JAQY066pano%type;
    l_JAQY066pmes  JAQY066.JAQY066pmes%type;
    l_JAQY066paic  JAQY066.JAQY066paic%type;
    l_JAQY066tdoc  JAQY066.JAQY066tdoc%type;
    l_JAQY066tndoc JAQY066.JAQY066tndoc%type;
    l_JAQY066calf  JAQY066.JAQY066calf%type;
    l_JAQY066fecp  JAQY066.JAQY066fecp%type;
    l_JAQY066horp  JAQY066.JAQY066horp%type;
    l_JAQY066tcal  JAQY066.JAQY066tcal%type;
  
    TYPE tp_pais IS TABLE OF jaqy162.jaqy162pais%type INDEX BY BINARY_INTEGER;
    TYPE tp_tdoc IS TABLE OF jaqy162.jaqy162tdoc%type INDEX BY BINARY_INTEGER;
    TYPE tp_ndoc IS TABLE OF jaqy162.jaqy162ndoc%type INDEX BY BINARY_INTEGER;
  
    la_JAQZ095pais tp_pais;
    la_JAQZ095tdoc tp_tdoc;
    la_JAQZ095ndoc tp_ndoc;
    la_reglas      pq_cr_segmentacion_clientes.tb_reglas;
    ln_reg         number(5);
  
  BEGIN
  
    execute immediate 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
    execute immediate 'ALTER SESSION SET OPTIMIZER_MODE=ALL_ROWS'; --jflor 2014.01.17  
    execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE'; --jflor 2014.05.05
  
    l_JAQY066fecp := P_D_FECPRO;
    l_JAQY066pano := to_number(to_char(P_D_FECPRO, 'RRRR'));
    l_JAQY066pmes := to_number(to_char(P_D_FECPRO, 'MM'));
    --l_JAQY066pano := to_number(to_char(add_months(P_D_FECPRO, -1),'RRRR'));
    --l_JAQY066pmes := to_number(to_char(add_months(P_D_FECPRO, -1),'MM'));    
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
  
    OPEN c_clientes(P_D_FECPRO, l_JAQY066pano, l_JAQY066pmes); -- Clientes Bulk
    FETCH c_clientes BULK COLLECT
      INTO la_JAQZ095pais, la_JAQZ095tdoc, la_JAQZ095ndoc;
  
    IF la_JAQZ095ndoc.count > 0 THEN
      FOR c IN la_JAQZ095ndoc.FIRST .. la_JAQZ095ndoc.LAST LOOP
      
        la_nomvar := la_nomnul;
        la_valvar := la_valnul;
        pq_cr_segmentacion_clientes.sp_cr_cargar_variables_NS_MENS(P_D_FECPRO => P_D_FECPRO,
                                                                   P_N_PAIS   => la_JAQZ095pais(c),
                                                                   P_N_TDOC   => la_JAQZ095tdoc(c),
                                                                   P_C_NDOC   => la_JAQZ095ndoc(c),
                                                                   P_C_USR    => PC_USR,
                                                                   p_a_nomvar => la_nomvar,
                                                                   p_a_valvar => la_valvar,
                                                                   p_n_var    => ln_var);
        SegmentoRegla := null;
        pq_cr_segmentacion_clientes.sp_cr_evalua_clientes_1_NS(P_N_REGLA   => Regla,
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
          l_JAQY066paic  := la_JAQZ095pais(c);
          l_JAQY066tdoc  := la_JAQZ095tdoc(c);
          l_JAQY066tndoc := la_JAQZ095ndoc(c);
          l_JAQY066calf  := JAQY067CCAL;
          l_JAQY066horp  := to_char(sysdate(), 'HH24:MI:SS');
          l_JAQY066tcal  := 'P';
        
          insert into JAQY066
            (JAQY066PANO,
             JAQY066PMES,
             JAQY066PAIC,
             JAQY066TDOC,
             JAQY066TNDOC,
             JAQY066CALF,
             JAQY066FECP,
             JAQY066HORP,
             JAQY066TCAL,
             JAQY066nse,
             JAQY066TSE)
          values
            (l_JAQY066pano,
             l_JAQY066pmes,
             l_JAQY066paic,
             l_JAQY066tdoc,
             l_JAQY066tndoc,
             l_JAQY066calf,
             l_JAQY066fecp,
             l_JAQY066horp,
             l_JAQY066tcal,
             'S',
             'S');
          commit;
        
        End If;
      
      END LOOP; -- clientes
    END IF;
  
  END sp_cr_segmenta_clientes_NS;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

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
  
    ExisteGrupo    char(1) := null;
    ResReglaGrupo  char(1) := null;
    ResReglaLista  char(1) := null;
    Regla          frng51.rng49cod%type;
    Regla2         frng51.rng49cod%type;
    l_RNG50Grp     frng51.rng50grp%type;
    l_RNG50Ret     frng50.rng50ret%type;
    la_nomvar      PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar;
    la_valvar      PQ_CR_SEGMENTACION_CLIENTES.tp_valvar;
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
    la_reglas      pq_cr_segmentacion_clientes.tb_reglas;
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
        If la_reglas(ln_ind).RNG68ATR = 'EXP1621' then
        
          Regla2 := to_number(substr(la_reglas(ln_ind).RNG68ATR, 4, 4));
          --Msg('rutina regla anidada ' + Str(&Regla2))
          SegmentoRegla2 := null;
          PQ_CR_SEGMENTACION_CLIENTES.sp_cr_evalua_clientes_2_NS(P_N_REGLA   => Regla2,
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
    
    End If; -- existe grupo
  
  END sp_cr_evalua_clientes_1_NS;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_cr_evalua_clientes_2_NS(P_N_REGLA   IN NUMBER,
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
  
    ExisteGrupo    char(1) := null;
    ResReglaGrupo  char(1) := null;
    ResReglaLista  char(1) := null;
    Regla          frng51.rng49cod%type;
    l_RNG50Grp     frng51.rng50grp%type;
    l_RNG50Ret     frng50.rng50ret%type;
    la_nomvar      PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar;
    la_valvar      PQ_CR_SEGMENTACION_CLIENTES.tp_valvar;
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
    la_reglas  pq_cr_segmentacion_clientes.tb_reglas;
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
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_cr_evalua_clientes_3_NS(P_N_REGLA   IN NUMBER,
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
  
    ExisteGrupo    char(1) := null;
    ResReglaGrupo  char(1) := null;
    ResReglaLista  char(1) := null;
    Regla          frng51.rng49cod%type;
    l_RNG50Grp     frng51.rng50grp%type;
    l_RNG50Ret     frng50.rng50ret%type;
    la_nomvar      PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar;
    la_valvar      PQ_CR_SEGMENTACION_CLIENTES.tp_valvar;
    ln_var         number(3) := 0;
    lc_valResuelto varchar2(30);
    i              number(3);
    ln_NumTmp1     number(10, 2);
    ln_NumTmp2     number(10, 2);
    --l_RNG68Tda frng68.rng68tda%type;
    l_RNG51Val varchar2(30);
    l_RNG67val varchar2(30);
    l_RNG51OPE varchar2(2);
    la_reglas  pq_cr_segmentacion_clientes.tb_reglas;
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
  
  END sp_cr_evalua_clientes_3_NS;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_cr_cargar_variables_NS(P_D_FECPRO IN DATE,
                                      P_N_PAIS   IN JAQZ082.JAQZ082PAIS%type,
                                      P_N_TDOC   IN JAQZ082.JAQZ082TDOC%type,
                                      P_C_NDOC   IN JAQZ082.JAQZ082NDOC%type,
                                      P_C_USR    IN JAQZ082.JAQZ082USR%type,
                                      p_a_nomvar out PQ_CR_SEGMENTACION_CLIENTES.tp_nomvar,
                                      p_a_valvar out PQ_CR_SEGMENTACION_CLIENTES.tp_valvar,
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

  procedure sp_cr_NS_LINEA(P_D_FECPRO in date,
                           PN_PAIS    IN NUMBER,
                           PN_TDOC    IN NUMBER,
                           PC_NDOC    IN VARCHAR2,
                           PC_USR     IN VARCHAR2) IS
  
    cursor c_clientes(p_fecpro date /*,p_ndoc varchar2*/ /*, p_anio number, p_mes number*/) is
      select /*+all_rows index_ss(l)*/
       JAQZ082pais, JAQZ082tdoc, JAQZ082ndoc
        from JAQZ082 l
       where /*JAQZ082fech = p_fecpro  
                 and */
       l.jaqz082pais = PN_PAIS
       and l.jaqz082tdoc = PN_TDOC
       and l.jaqz082ndoc = PC_NDOC --p_ndoc
       and l.jaqz082usr = PC_USR;
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
      -- where t.RNG49Cod in (1620, 1621) mod@abr 20170110
       where t.RNG49Cod in (1620, 1621, 1624) --mod@abr 20170110
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
    la_reglas      pq_cr_segmentacion_clientes.tb_reglas;
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
        pq_cr_segmentacion_clientes.sp_cr_cargar_variables_NS(P_D_FECPRO => P_D_FECPRO,
                                                              P_N_PAIS   => la_JAQZ082pais(c),
                                                              P_N_TDOC   => la_JAQZ082tdoc(c),
                                                              P_C_NDOC   => la_JAQZ082ndoc(c),
                                                              P_C_USR    => PC_USR,
                                                              p_a_nomvar => la_nomvar,
                                                              p_a_valvar => la_valvar,
                                                              p_n_var    => ln_var);
        SegmentoRegla := null;
        pq_cr_segmentacion_clientes.sp_cr_evalua_clientes_1_NS(P_N_REGLA   => Regla,
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

  procedure sp_cr_cargar_variables_NS_MENS(P_D_FECPRO IN DATE,
                                           P_N_PAIS   IN JAQZ082.JAQZ082PAIS%type,
                                           P_N_TDOC   IN JAQZ082.JAQZ082TDOC%type,
                                           P_C_NDOC   IN JAQZ082.JAQZ082NDOC%type,
                                           P_C_USR    IN JAQZ082.JAQZ082USR%type,
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
        from JAQZ095
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
  
  end sp_cr_cargar_variables_NS_MENS;

end PQ_CR_SEGMENTACION_CLIENTES;
/

