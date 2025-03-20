create or replace package pq_Cr_segmentacion_mens_cons is

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
                                    P_N_JOBS   IN NUMBER);
  procedure sp_job_carga(P_D_FECPRO IN DATE,
                         PC_USR     IN VARCHAR2,
                         P_N_JOBS   IN NUMBER);
  Procedure Sp_Carga_data(pd_fecpro  in date,
                          P_C_DIGITO in number,
                          pc_usr     in varchar2);
  procedure sp_cr_segmenta_clientes_job_NS(P_D_FECPRO IN DATE,
                                           PC_USR     IN VARCHAR2,
                                           P_N_JOBS   IN NUMBER);
  procedure sp_cr_segmenta_clientes_NS(P_D_FECPRO in date,
                                       P_C_DIGITO in varchar2,
                                       PC_USR     in varchar2);

  procedure sp_cr_evalua_clientes_1_NS(P_N_REGLA   IN NUMBER,
                                       P_A_NOMVAR  IN pq_cr_segmentacion_mens_cons.tp_nomvar,
                                       P_A_VALVAR  IN pq_cr_segmentacion_mens_cons.tp_valvar,
                                       P_N_VAR     IN number,
                                       P_A_REGLAS  in pq_cr_segmentacion_mens_cons.tb_reglas,
                                       P_N_REG     in number,
                                       p_c_retorno out varchar2);
  procedure sp_cr_evalua_clientes_2_NS(P_N_REGLA   IN NUMBER,
                                       P_A_NOMVAR  IN pq_cr_segmentacion_mens_cons.tp_nomvar,
                                       P_A_VALVAR  IN pq_cr_segmentacion_mens_cons.tp_valvar,
                                       P_N_VAR     IN number,
                                       P_A_REGLAS  in pq_cr_segmentacion_mens_cons.tb_reglas,
                                       P_N_REG     in number,
                                       p_c_retorno out varchar2);
  procedure sp_cr_evalua_clientes_3_NS(P_N_REGLA   IN NUMBER,
                                       P_A_NOMVAR  IN pq_cr_segmentacion_mens_cons.tp_nomvar,
                                       P_A_VALVAR  IN pq_cr_segmentacion_mens_cons.tp_valvar,
                                       P_N_VAR     IN number,
                                       P_A_REGLAS  in pq_cr_segmentacion_mens_cons.tb_reglas,
                                       P_N_REG     in number,
                                       p_c_retorno out varchar2);
  procedure sp_cr_cargar_variables_NS_MENS(P_D_FECPRO IN DATE,
                                           P_N_PAIS   IN JAQZ680.JAQZ680PAIS%type,
                                           P_N_TDOC   IN JAQZ680.JAQZ680TDOC%type,
                                           P_C_NDOC   IN JAQZ680.JAQZ680NDOC%type,
                                           P_C_USR    IN JAQZ680.JAQZ680USR%type,
                                           p_a_nomvar out pq_cr_segmentacion_mens_cons.tp_nomvar,
                                           p_a_valvar out pq_cr_segmentacion_mens_cons.tp_valvar,
                                           p_n_var    out number);
  Procedure Sp_cr_Resolutores(pn_pai        in number,
                              pn_tdo        in number,
                              pc_ndo        in char,
                              pd_fecpro     in date,
                              pn_cal        out number,
                              lc_fin_sobend out varchar2,
                              lc_castigado  out varchar2,
                              ln_CntAntRcc  out number);
  Procedure Sp_Resolutores_NS(pn_pai      in number,
                              pn_tdo      in number,
                              pc_ndo      in char,
                              pd_fecpro   in date,
                              Ln_nrobanks out number,
                              ln_promMax  out number,
                              ln_calNor   out number,
                              ln_segcod   out number,
                              lc_refinan  out char,
                              ln_histCred out number,
                              ln_porcUso  out number,
                              pn_cal      out number, --mod@abr 20190827
                              pc_flgVen   out char --mod@abr 20190827
                              );
  Function Fn_cant_instit(TipDocSbs in char,
                          pc_ndo    in char,
                          pd_fecRcc in date,
                          lc_tiper  in char) return number;
  Procedure Sp_cr_rccLineas(pd_Fec     in date,
                            pc_docsbs  in char,
                            pn_porcUso out number);
  Function Fn_Verifica_Linea(lc_subCuenta3 in varchar2) return char;
  Function Fn_Verifica_Castigo(lc_subCuenta4 in char) return char;

end pq_Cr_segmentacion_mens_cons;
/

create or replace package body pq_Cr_segmentacion_mens_cons is

  procedure sp_cr_carga_clientes_NS(P_D_FECPRO in date,
                                    P_N_LIMITE IN NUMBER,
                                    P_N_JOBS   IN NUMBER) IS
  
    cursor c_clientes is
      select /*+parallel (c,4,1)*/
       a.pepais, a.petdoc, a.pendoc
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
    delete from JAQY163;
    commit;
  
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
        INSERT INTO JAQY163
          (jaqy163pais,
           jaqy163tdoc,
           jaqy163ndoc,
           jaqy163nume,
           jaqy163nume2)
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
  procedure sp_job_carga(P_D_FECPRO IN DATE,
                         PC_USR     IN VARCHAR2,
                         P_N_JOBS   IN NUMBER) is
  
    /*cursor c_clientes_job(p_fecpro date) is
    select substr(trim(j.jaqy163ndoc), -1, 1) digito
      from jaqy163 j
     group by substr(trim(j.jaqy163ndoc), -1, 1);*/
  
    lc_fecpro   varchar2(10);
    lc_variable varchar2(4000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    --l_jaqy163pano  jaqy163.jaqy066pano%type;
    --l_jaqy163pmes  jaqy163..jaqy066pmes%type;
    ln_cont   number(2) := 0;
    ln_inst   number(1) := 1;
    ln_limit  number(3) := 20;
    ln_numjob number(5);
  BEGIN
    begin
      select host_name into lc_hostname from v$instance;
    exception
      when others then
        null;
    end;
    --execute immediate 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
    lc_fecpro := to_char(P_D_FECPRO, 'RRRR.MM.DD');
    --l_jaqy066pano := to_number(to_char(add_months(P_D_FECPRO, -1),'RRRR'));
    --l_jaqy066pmes := to_number(to_char(add_months(P_D_FECPRO, -1),'MM')); 
    begin
      delete from JAQZ680 a where a.JAQZ680fech = P_D_FECPRO;
      commit;
    exception
      when others then
        null;
    end;
  
    --apachecoh 2023.10.10
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
  
    for i in 0 .. P_N_JOBS loop
    
      lc_variable := ' begin ' ||
                     ' pq_Cr_segmentacion_mens_cons.Sp_Carga_data(TO_DATE(''' ||
                     lc_fecpro || ''',''RRRR.MM.DD''),' || i || ',''' ||
                     PC_USR || ''');' || ' End; ';
      ln_job      := ln_job + 1;
    
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
                          --                     instance => ln_inst,
                          instance => 1,
                          -- instance => 2, --Solo por hoy 01.07.2015 hmev new 01/01/2024
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
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      --apachecoh 2023.10.10  
      BEGIN
        SELECT count(*)
          INTO ln_numjob
          FROM dba_jobs x
         WHERE upper(x.what) LIKE
               '%PQ_CR_SEGMENTACION_MENS_CONS.SP_CARGA_DATA%';
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
                 '%PQ_CR_SEGMENTACION_MENS_CONS.SP_CARGA_DATA%';
        EXCEPTION
          WHEN OTHERS THEN
            ln_numjob := 0;
        END;
      END LOOP;
    
    end loop;
  end sp_job_carga;

  Procedure Sp_Carga_data(pd_fecpro  in date,
                          P_C_DIGITO in number,
                          pc_usr     in varchar2) is
  
    cursor c_clientes(p_fecpro date) is
      select /*+all_rows index_ss(l)*/
       l.jaqy163pais, l.jaqy163tdoc, l.jaqy163ndoc
        from JAQY163 l
       where not exists (select 1
                from JAQZ680 c
               where c.JAQZ680pais = l.jaqy163pais
                 and c.JAQZ680tdoc = l.jaqy163tdoc
                 and c.JAQZ680ndoc = l.jaqy163ndoc
                 and c.JAQZ680fech = pd_fecpro)
            --and substr(trim(jaqy163ndoc), -1, 1) = P_C_DIGITO;
         and JAQY163NUME2 = P_C_DIGITO;
  
    pn_cal        number(5, 2);
    lc_fin_sobend char(1);
    lc_castigado  char(1);
    ln_histCred   number(5);
    ln_segcod     number(2);
    lc_refinan    char(1);
    ln_cal        number(5);
  
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
    lc_JAQZ082VAR13 varchar2(100);
    lc_JAQZ082VAR14 varchar2(100);
    lc_JAQZ082VAR15 varchar2(100);
    lc_JAQZ082VAR16 varchar2(100);
    lc_JAQZ082VAR17 varchar2(100);
    lc_JAQZ082VAR18 varchar2(100);
    lc_JAQZ082VAR19 varchar2(100);
  
    lc_lista char(1);
    lc_hora  char(8);
  
    TYPE tp_pais IS TABLE OF jaqy163.jaqy163pais%type INDEX BY BINARY_INTEGER;
    TYPE tp_tdoc IS TABLE OF jaqy163.jaqy163tdoc%type INDEX BY BINARY_INTEGER;
    TYPE tp_ndoc IS TABLE OF jaqy163.jaqy163ndoc%type INDEX BY BINARY_INTEGER;
  
    la_jaqy163pais tp_pais;
    la_jaqy163tdoc tp_tdoc;
    la_jaqy163ndoc tp_ndoc;
  
    --cursor creditos is
    --select * from JAQY163 a
    --where a.jaqy163ndoc = '29524923'
    --;
  
    Ln_nrobanks number(10);
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
    ln_instancia number(10);
  
    lc_coderr varchar2(300);
    ln_dig    number(3);
  
    ln_CntAntRcc number(10);
    ln_cal2      number(5, 2); --mod@abr 20190827
    lc_FlgVen    char(1); --mod@abr 20190827
  
  begin
    ln_dig := to_number(P_C_DIGITO);
  
    update tab_jobs g
       set g.d_fecini = sysdate
     where g.n_numer1 = ln_dig
       and g.c_codage = 'SC';
    commit;
  
    lc_lista := 'N';
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS=". "';
  
    OPEN c_clientes(pd_fecpro); -- Clientes Bulk
    FETCH c_clientes BULK COLLECT
      INTO la_jaqy163pais, la_jaqy163tdoc, la_jaqy163ndoc;
  
    IF la_jaqy163ndoc.count > 0 THEN
      FOR c IN la_jaqy163ndoc.FIRST .. la_jaqy163ndoc.LAST LOOP
      
        --for i in creditos loop
        begin
          pq_Cr_segmentacion_mens_cons.Sp_cr_Resolutores( /*i.jaqy163pais*/la_jaqy163pais(c),
                                                         /*i.jaqy163tdoc*/
                                                         la_jaqy163tdoc(c),
                                                         /*i.jaqy163ndoc*/
                                                         la_jaqy163ndoc(c),
                                                         pd_fecpro,
                                                         pn_cal,
                                                         lc_fin_sobend,
                                                         lc_castigado,
                                                         ln_CntAntRcc);
        exception
          when others then
            null;
        end;
        begin
          pq_Cr_segmentacion_mens_cons.Sp_Resolutores_NS( /*i.jaqy163pais*/la_jaqy163pais(c),
                                                         /*i.jaqy163tdoc*/
                                                         la_jaqy163tdoc(c),
                                                         /*i.jaqy163ndoc*/
                                                         la_jaqy163ndoc(c),
                                                         pd_fecpro,
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
          lv_ndocum := trim(la_jaqy163ndoc(c));
          begin
            PQ_CR_SEGMNXCOMPORT.sp_cr_Inicio(ln_instancia,
                                             la_jaqy163pais(c),
                                             la_jaqy163tdoc(c),
                                             lv_ndocum,
                                             pc_usr,
                                             lv_afecta);
          exception
            when others then
              null;
          end;
          begin
            PQ_CR_VAR_SEGMENTACION_CONG_RP.sp_cr_variables_cong(la_jaqy163pais(c),
                                                                la_jaqy163tdoc(c),
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
      
        lc_JAQZ082VAR1 := 'RELCRED_CAMPNAV' || '=' ||
                          trim(to_char(ln_histCred));
        if ln_promMax = 0 then
          lc_JAQZ082VAR2 := 'PROMD_ATRMAXRN=0.00';
        else
          case
            when ln_promMax < 1 and ln_promMax > 0 then
              lc_JAQZ082VAR2 := 'PROMD_ATRMAXRN=' || '0' ||
                                TRIM(TO_CHAR(ln_promMax));
            else
              lc_JAQZ082VAR2 := 'PROMD_ATRMAXRN=' ||
                                TRIM(TO_CHAR(ln_promMax));
          end case;
        end if;
        lc_JAQZ082VAR3 := 'NRO_BANKSRCC_SNCMAC' || '=' ||
                          trim(to_char(Ln_nrobanks));
        if ln_porcUso = 0 then
          lc_JAQZ082VAR4 := 'PORC_USO=0.00';
        else
          case
            when ln_porcUso < 1 and ln_porcUso > 0 then
              lc_JAQZ082VAR4 := 'PORC_USO=' || '0' ||
                                TRIM(TO_CHAR(ln_porcUso));
            else
              lc_JAQZ082VAR4 := 'PORC_USO=' || TRIM(TO_CHAR(ln_porcUso));
          end case;
        end if;
        lc_JAQZ082VAR5  := 'CALIFICACION_RCC' || '=' ||
                           trim(to_char(pn_cal));
        lc_JAQZ082VAR6  := 'CAL_RCC_NORCPP' || '=' ||
                           trim(to_char(ln_calNor));
        lc_JAQZ082VAR7  := 'SOBRE_ENDEUDADO' || '=' || trim(lc_fin_sobend);
        lc_JAQZ082VAR8  := 'REFINANCIADO' || '=' || trim(lc_refinan);
        lc_JAQZ082VAR9  := 'CASTIGADO' || '=' || trim(lc_castigado);
        lc_JAQZ082VAR10 := 'LISTA_NEGRA' || '=' || trim(lc_lista);
        lc_JAQZ082VAR11 := 'SEGMENTO' || '=' || trim(to_char(ln_segcod));
        lc_JAQZ082VAR12 := 'ANTIGUEDAD_RCC' || '=' ||
                           trim(to_char(ln_CntAntRcc));
        lc_JAQZ082VAR13 := 'CAL_RCC_TIT_6' || '=' || trim(to_char(pn_cal));
        lc_JAQZ082VAR14 := 'CAL_RCC_TIT_12' || '=' ||
                           trim(to_char(ln_cal2));
        lc_JAQZ082VAR15 := 'VENCIDO' || '=' || trim(lc_FlgVen);
      
        --apachecoh 2023.02.23        
        if ln_afecta = 1 then
          lc_JAQZ082VAR16 := 'PRMATRMX_CEN_RN' || '=' ||
                             trim(to_char(ln_afdatr));
          lc_JAQZ082VAR17 := 'CALF6_CEN_RN' || '=' ||
                             trim(to_char(ln_afcalif));
          lc_JAQZ082VAR18 := 'CALF12_CEN_RN' || '=' ||
                             trim(to_char(ln_afcalif2));
          lc_JAQZ082VAR19 := 'SEGMENCOM_RN' || '=' || trim(lv_afecta);
        end if;
      
        ln_cal  := 0;
        lc_hora := TO_CHAR(SYSDATE, 'hh:mm:ss');
      
        begin
          insert into JAQZ680
            (JAQZ680FECH,
             JAQZ680PAIS,
             JAQZ680TDOC,
             JAQZ680NDOC,
             JAQZ680HORA,
             JAQZ083CCAL,
             JAQZ680VAR1,
             JAQZ680VAR2,
             JAQZ680VAR3,
             JAQZ680VAR4,
             JAQZ680VAR5,
             JAQZ680VAR6,
             JAQZ680VAR7,
             JAQZ680VAR8,
             JAQZ680VAR9,
             JAQZ680VAR10,
             JAQZ680VAR11,
             JAQZ680VAR12,
             JAQZ680VAR13,
             JAQZ680VAR14,
             JAQZ680VAR15,
             JAQZ680VAR16,
             JAQZ680VAR17,
             JAQZ680VAR18,
             JAQZ680VAR19,
             JAQZ680USR,
             JAQZ680NUME)
          values
            (pd_fecpro,
             la_jaqy163pais(c),
             la_jaqy163tdoc(c),
             la_jaqy163ndoc(c),
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
             lc_JAQZ082VAR14,
             lc_JAQZ082VAR15,
             lc_JAQZ082VAR16,
             lc_JAQZ082VAR17,
             lc_JAQZ082VAR18,
             lc_JAQZ082VAR19,
             pc_usr,
             P_C_DIGITO);
        
          commit;
        
        exception
          when others then
            lc_coderr := sqlerrm;
            INSERT INTO LOG_ERROR_BANDEJA
              (N_NRO, C_CODBDJ, C_DESERR, D_FECERR)
            VALUES
              (0, 'SC', ln_dig || lc_coderr, TRUNC(SYSDATE));
            COMMIT;
          
        end;
      
      end loop;
      commit;
    
      update tab_jobs g
         set g.d_fecfin = sysdate
       where g.n_numer1 = ln_dig
         and g.c_codage = 'SC';
      commit;
    
    end if;
  
  EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm, 1, 200);
      update tab_jobs g
         set g.c_inderr = 'S', g.c_deserr = lc_coderr
       where g.n_numer1 = ln_dig
         and g.c_codage = 'SC';
      commit;
      return;
    
  end Sp_Carga_data;
  --------------------------------------------------------------------------------------------------
  procedure sp_cr_segmenta_clientes_job_NS(P_D_FECPRO IN DATE,
                                           PC_USR     IN VARCHAR2,
                                           P_N_JOBS   IN NUMBER) is
  
    /*cursor c_clientes_job(p_fecpro date) is
    select substr(trim(j.aqpc187ndoc), -1, 1) digito, j.aqpc187usr
      from AQPC187 j
     where j.AQPC187fech = p_fecpro
       and j.AQPC187usr = PC_USR
     group by substr(trim(j.AQPC187ndoc), -1, 1), j.AQPC187usr;*/
  
    lc_hostname   varchar2(64);
    lc_fecpro     varchar2(10);
    lc_variable   varchar2(4000);
    ln_job        number := 0;
    l_JAQZ681pano JAQZ681.JAQZ681pano%type;
    l_JAQZ681pmes JAQZ681.JAQZ681pmes%type;
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
    l_JAQZ681pano := to_number(to_char(P_D_FECPRO, 'RRRR'));
    l_JAQZ681pmes := to_number(to_char(P_D_FECPRO, 'MM'));
    --l_JAQY066pano := to_number(to_char(add_months(P_D_FECPRO, -1),'RRRR'));
    --l_JAQY066pmes := to_number(to_char(add_months(P_D_FECPRO, -1),'MM')); 
  
    delete from JAQZ681 A
     where JAQZ681pano = l_JAQZ681pano
       and JAQZ681pmes = l_JAQZ681pmes;
    commit;
  
    --apachecoh 2023.10.10
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
  
    for i in 0 .. P_N_JOBS loop
    
      lc_variable := ' begin ' ||
                     ' pq_Cr_segmentacion_mens_cons.sp_cr_segmenta_clientes_NS(TO_DATE(''' ||
                     lc_fecpro || ''',''RRRR.MM.DD''),' || i || ',''' ||
                     PC_USR || ''');' || ' End; ';
    
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
        commit;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      --apachecoh 2023.10.10  
      BEGIN
        SELECT count(*)
          INTO ln_numjob
          FROM dba_jobs x
         WHERE upper(x.what) LIKE
               '%PQ_CR_SEGMENTACION_MENS_CONS.SP_CR_SEGMENTA_CLIENTES_NS%';
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
                 '%PQ_CR_SEGMENTACION_MENS_CONS.SP_CR_SEGMENTA_CLIENTES_NS%';
        EXCEPTION
          WHEN OTHERS THEN
            ln_numjob := 0;
        END;
      END LOOP;
    
    end loop;
  end sp_cr_segmenta_clientes_job_NS;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  procedure sp_cr_segmenta_clientes_NS(P_D_FECPRO in date,
                                       P_C_DIGITO in varchar2,
                                       PC_USR     in varchar2) IS
  
    cursor c_clientes(p_fecpro date, p_anio number, p_mes number) is
      select /*+all_rows index_ss(l)*/
       JAQZ680pais, JAQZ680tdoc, JAQZ680ndoc
        from JAQZ680 l
       where l.JAQZ680FECH = p_fecpro
         and not exists (select 1
                from JAQZ681 c
               where c.JAQZ681paic = l.JAQZ680pais
                 and c.JAQZ681tdoc = l.JAQZ680tdoc
                 and c.JAQZ681tndoc = l.JAQZ680ndoc
                 and c.JAQZ681pano = p_anio
                 and c.JAQZ681pmes = p_mes)
         and l.JAQZ680USR = PC_USR
         and l.JAQZ680NUME = P_C_DIGITO;
  
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
  
    Regla          frng51.rng49cod%type;
    SegmentoRegla  frng50.rng50ret%type;
    la_nomvar      pq_cr_segmentacion_mens_cons.tp_nomvar;
    la_valvar      pq_cr_segmentacion_mens_cons.tp_valvar;
    la_nomnul      pq_cr_segmentacion_mens_cons.tp_nomvar;
    la_valnul      pq_cr_segmentacion_mens_cons.tp_valvar;
    ln_var         number(3) := 0;
    Tp1cod         fst198.tp1cod%type;
    Tp1cod1        fst198.tp1cod1%type;
    Tp1corr1       fst198.tp1corr1%type;
    Tp1corr2       fst198.tp1corr2%type;
    Tp1desc        fst198.tp1desc%type;
    JAQY067CCAL    jaqy067.jaqy067ccal%type;
    l_JAQZ681pano  JAQZ681.JAQZ681pano%type;
    l_JAQZ681pmes  JAQZ681.JAQZ681pmes%type;
    l_JAQZ681paic  JAQZ681.JAQZ681paic%type;
    l_JAQZ681tdoc  JAQZ681.JAQZ681tdoc%type;
    l_JAQZ681tndoc JAQZ681.JAQZ681tndoc%type;
    l_JAQZ681calf  JAQZ681.JAQZ681calf%type;
    l_JAQZ681fecp  JAQZ681.JAQZ681fecp%type;
    l_JAQZ681horp  JAQZ681.JAQZ681horp%type;
  
    TYPE tp_pais IS TABLE OF jaqy162.jaqy162pais%type INDEX BY BINARY_INTEGER;
    TYPE tp_tdoc IS TABLE OF jaqy162.jaqy162tdoc%type INDEX BY BINARY_INTEGER;
    TYPE tp_ndoc IS TABLE OF jaqy162.jaqy162ndoc%type INDEX BY BINARY_INTEGER;
  
    la_JAQZ680pais tp_pais;
    la_JAQZ680tdoc tp_tdoc;
    la_JAQZ680ndoc tp_ndoc;
    la_reglas      pq_cr_segmentacion_mens_cons.tb_reglas;
    ln_reg         number(5);
  
  BEGIN
  
    execute immediate 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
    execute immediate 'ALTER SESSION SET OPTIMIZER_MODE=ALL_ROWS'; --jflor 2014.01.17  
    execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE'; --jflor 2014.05.05
  
    l_JAQZ681fecp := P_D_FECPRO;
    l_JAQZ681pano := to_number(to_char(P_D_FECPRO, 'RRRR'));
    l_JAQZ681pmes := to_number(to_char(P_D_FECPRO, 'MM'));
    Regla         := 1653;
  
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
  
    OPEN c_clientes(P_D_FECPRO, l_JAQZ681pano, l_JAQZ681pmes); -- Clientes Bulk
    FETCH c_clientes BULK COLLECT
      INTO la_JAQZ680pais, la_JAQZ680tdoc, la_JAQZ680ndoc;
  
    IF la_JAQZ680ndoc.count > 0 THEN
      FOR c IN la_JAQZ680ndoc.FIRST .. la_JAQZ680ndoc.LAST LOOP
      
        la_nomvar := la_nomnul;
        la_valvar := la_valnul;
        pq_cr_segmentacion_mens_cons.sp_cr_cargar_variables_NS_MENS(P_D_FECPRO => P_D_FECPRO,
                                                                    P_N_PAIS   => la_JAQZ680pais(c),
                                                                    P_N_TDOC   => la_JAQZ680tdoc(c),
                                                                    P_C_NDOC   => la_JAQZ680ndoc(c),
                                                                    P_C_USR    => PC_USR,
                                                                    p_a_nomvar => la_nomvar,
                                                                    p_a_valvar => la_valvar,
                                                                    p_n_var    => ln_var);
        SegmentoRegla := null;
        pq_cr_segmentacion_mens_cons.sp_cr_evalua_clientes_1_NS(P_N_REGLA   => Regla,
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
          l_JAQZ681paic  := la_JAQZ680pais(c);
          l_JAQZ681tdoc  := la_JAQZ680tdoc(c);
          l_JAQZ681tndoc := la_JAQZ680ndoc(c);
          l_JAQZ681calf  := JAQY067CCAL;
          l_JAQZ681horp  := to_char(sysdate(), 'HH24:MI:SS');
        
          insert into JAQZ681
            (JAQZ681PANO,
             JAQZ681PMES,
             JAQZ681PAIC,
             JAQZ681TDOC,
             JAQZ681TNDOC,
             JAQZ681CALF,
             JAQZ681FECP,
             JAQZ681HORP)
          values
            (l_JAQZ681pano,
             l_JAQZ681pmes,
             l_JAQZ681paic,
             l_JAQZ681tdoc,
             l_JAQZ681tndoc,
             l_JAQZ681calf,
             l_JAQZ681fecp,
             l_JAQZ681horp);
          commit;
        
        End If;
      
      END LOOP; -- clientes
    END IF;
  
  END sp_cr_segmenta_clientes_NS;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_cr_evalua_clientes_1_NS(P_N_REGLA   IN NUMBER,
                                       P_A_NOMVAR  IN pq_cr_segmentacion_mens_cons.tp_nomvar,
                                       P_A_VALVAR  IN pq_cr_segmentacion_mens_cons.tp_valvar,
                                       P_N_VAR     IN number,
                                       P_A_REGLAS  in pq_cr_segmentacion_mens_cons.tb_reglas,
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
    la_nomvar      pq_cr_segmentacion_mens_cons.tp_nomvar;
    la_valvar      pq_cr_segmentacion_mens_cons.tp_valvar;
    ln_var         number(3) := 0;
    lc_valResuelto varchar2(30);
    i              number(5);
    ln_NumTmp1     number(10, 2);
    ln_NumTmp2     number(10, 2);
    --l_RNG68Tda frng68.rng68tda%type;
    SegmentoRegla2 frng51.rng51val%type;
    l_RNG51Val     varchar2(30);
    l_RNG67val     varchar2(30);
    l_RNG51OPE     varchar2(2);
    la_reglas      pq_cr_segmentacion_mens_cons.tb_reglas;
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
    
      begin
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
            pq_cr_segmentacion_mens_cons.sp_cr_evalua_clientes_2_NS(P_N_REGLA   => Regla2,
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
              ResReglaGrupo := 'S';
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
                --'S' then --mod@abr 20190422
                --'N' then
                --Msg('no cumple ' + reg.RNG68ATR)
                ResReglaGrupo := 'N';
              
              End If;
            
            When 'NE' then
              ResReglaLista := 'N';
              ResReglaGrupo := 'S';
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
              If ResReglaLista = 'N' then
                --'S' then --mod@abr 20190422
                --Msg('no cumple ' + reg.RNG68ATR)
                ResReglaGrupo := 'N';
              End If;
            
            Else
              ResReglaGrupo := 'N'; --faltan variaciones de like y not like
          
          End Case;
        
          --END IF; -- regla evaluada
          ln_ind := ln_ind + 1;
        
        END LOOP; -- reglas
      exception
        when others then
          p_c_retorno := 'NO SEGMENTADO';
      end;
    
    End If; -- existe grupo
  
  END sp_cr_evalua_clientes_1_NS;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_cr_evalua_clientes_2_NS(P_N_REGLA   IN NUMBER,
                                       P_A_NOMVAR  IN pq_cr_segmentacion_mens_cons.tp_nomvar,
                                       P_A_VALVAR  IN pq_cr_segmentacion_mens_cons.tp_valvar,
                                       P_N_VAR     IN number,
                                       P_A_REGLAS  in pq_cr_segmentacion_mens_cons.tb_reglas,
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
    la_nomvar      pq_cr_segmentacion_mens_cons.tp_nomvar;
    la_valvar      pq_cr_segmentacion_mens_cons.tp_valvar;
    ln_var         number(3) := 0;
    lc_valResuelto varchar2(30);
    i              number(3);
    ln_NumTmp1     number(10, 2);
    ln_NumTmp2     number(10, 2);
    --l_RNG68Tda frng68.rng68tda%type;
    l_RNG51Val varchar2(30);
    l_RNG67val varchar2(30);
    --SegmentoRegla3 frng51.rng51val%type;
    --Regla3 frng51.rng49cod%type;
    l_RNG51OPE varchar2(2);
    la_reglas  pq_cr_segmentacion_mens_cons.tb_reglas;
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
      BEGIN
      
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
      exception
        when others then
          null;
      END;
    End If; -- existe grupo
  
  END sp_cr_evalua_clientes_2_NS;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_cr_evalua_clientes_3_NS(P_N_REGLA   IN NUMBER,
                                       P_A_NOMVAR  IN pq_cr_segmentacion_mens_cons.tp_nomvar,
                                       P_A_VALVAR  IN pq_cr_segmentacion_mens_cons.tp_valvar,
                                       P_N_VAR     IN number,
                                       P_A_REGLAS  in pq_cr_segmentacion_mens_cons.tb_reglas,
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
    la_nomvar      pq_cr_segmentacion_mens_cons.tp_nomvar;
    la_valvar      pq_cr_segmentacion_mens_cons.tp_valvar;
    ln_var         number(3) := 0;
    lc_valResuelto varchar2(30);
    i              number(3);
    ln_NumTmp1     number(10, 2);
    ln_NumTmp2     number(10, 2);
    --l_RNG68Tda frng68.rng68tda%type;
    l_RNG51Val varchar2(30);
    l_RNG67val varchar2(30);
    l_RNG51OPE varchar2(2);
    la_reglas  pq_cr_segmentacion_mens_cons.tb_reglas;
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

  procedure sp_cr_cargar_variables_NS_MENS(P_D_FECPRO IN DATE,
                                           P_N_PAIS   IN JAQZ680.JAQZ680PAIS%type,
                                           P_N_TDOC   IN JAQZ680.JAQZ680TDOC%type,
                                           P_C_NDOC   IN JAQZ680.JAQZ680NDOC%type,
                                           P_C_USR    IN JAQZ680.JAQZ680USR%type,
                                           p_a_nomvar out pq_cr_segmentacion_mens_cons.tp_nomvar,
                                           p_a_valvar out pq_cr_segmentacion_mens_cons.tp_valvar,
                                           p_n_var    out number) is
  
    cursor c_cliente is
      select JAQZ680fech,
             JAQZ680pais,
             JAQZ680tdoc,
             JAQZ680ndoc,
             JAQZ680var1,
             JAQZ680var2,
             JAQZ680var3,
             JAQZ680var4,
             JAQZ680var5,
             JAQZ680var6,
             JAQZ680var7,
             JAQZ680var8,
             JAQZ680var9,
             JAQZ680var10,
             JAQZ680var11,
             JAQZ680var12,
             JAQZ680var13,
             JAQZ680var14,
             JAQZ680var15,
             JAQZ680var16,
             JAQZ680var17,
             JAQZ680var18,
             JAQZ680var19,
             JAQZ680var20,
             JAQZ680var21,
             JAQZ680var22,
             JAQZ680var23,
             JAQZ680var24,
             JAQZ680var25,
             JAQZ680var26,
             JAQZ680var27,
             JAQZ680var28,
             JAQZ680var29,
             JAQZ680var30,
             JAQZ680var31,
             JAQZ680var32,
             JAQZ680var33,
             JAQZ680var34,
             JAQZ680var35,
             JAQZ680var36,
             JAQZ680var37,
             JAQZ680var38,
             JAQZ680var39,
             JAQZ680var40
        from JAQZ680
       where JAQZ680fech = P_D_FECPRO
         and JAQZ680pais = P_N_PAIS
         and JAQZ680tdoc = P_N_TDOC
         and JAQZ680ndoc = P_C_NDOC
         and JAQZ680usr = P_C_USR;
    ln_tmpnum number(3);
  
  begin
  
    for cli in c_cliente loop
      -- Cargando Variables Resuletas
      if trim(cli.JAQZ680var1) is not null then
        p_n_var := 1;
        ln_tmpnum := instr(cli.JAQZ680var1, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var1, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var1, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var2) is not null then
        p_n_var := 2;
        ln_tmpnum := instr(cli.JAQZ680var2, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var2, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var2, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var3) is not null then
        p_n_var := 3;
        ln_tmpnum := instr(cli.JAQZ680var3, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var3, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var3, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var4) is not null then
        p_n_var := 4;
        ln_tmpnum := instr(cli.JAQZ680var4, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var4, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var4, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var5) is not null then
        p_n_var := 5;
        ln_tmpnum := instr(cli.JAQZ680var5, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var5, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var5, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var6) is not null then
        p_n_var := 6;
        ln_tmpnum := instr(cli.JAQZ680var6, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var6, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var6, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var7) is not null then
        p_n_var := 7;
        ln_tmpnum := instr(cli.JAQZ680var7, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var7, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var7, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var8) is not null then
        p_n_var := 8;
        ln_tmpnum := instr(cli.JAQZ680var8, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var8, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var8, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var9) is not null then
        p_n_var := 9;
        ln_tmpnum := instr(cli.JAQZ680var9, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var9, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var9, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var10) is not null then
        p_n_var := 10;
        ln_tmpnum := instr(cli.JAQZ680var10, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var10, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var10, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var11) is not null then
        p_n_var := 11;
        ln_tmpnum := instr(cli.JAQZ680var11, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var11, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var11, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var12) is not null then
        p_n_var := 12;
        ln_tmpnum := instr(cli.JAQZ680var12, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var12, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var12, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var13) is not null then
        p_n_var := 13;
        ln_tmpnum := instr(cli.JAQZ680var13, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var13, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var13, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var14) is not null then
        p_n_var := 14;
        ln_tmpnum := instr(cli.JAQZ680var14, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var14, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var14, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var15) is not null then
        p_n_var := 15;
        ln_tmpnum := instr(cli.JAQZ680var15, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var15, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var15, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var16) is not null then
        p_n_var := 16;
        ln_tmpnum := instr(cli.JAQZ680var16, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var16, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var16, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var17) is not null then
        p_n_var := 17;
        ln_tmpnum := instr(cli.JAQZ680var17, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var17, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var17, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var18) is not null then
        p_n_var := 18;
        ln_tmpnum := instr(cli.JAQZ680var18, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var18, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var18, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var19) is not null then
        p_n_var := 19;
        ln_tmpnum := instr(cli.JAQZ680var19, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var19, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var19, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var20) is not null then
        p_n_var := 20;
        ln_tmpnum := instr(cli.JAQZ680var20, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var20, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var20, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var21) is not null then
        p_n_var := 21;
        ln_tmpnum := instr(cli.JAQZ680var21, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var21, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var21, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var22) is not null then
        p_n_var := 22;
        ln_tmpnum := instr(cli.JAQZ680var22, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var22, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var22, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var23) is not null then
        p_n_var := 23;
        ln_tmpnum := instr(cli.JAQZ680var23, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var23, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var23, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var24) is not null then
        p_n_var := 24;
        ln_tmpnum := instr(cli.JAQZ680var24, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var24, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var24, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var25) is not null then
        p_n_var := 25;
        ln_tmpnum := instr(cli.JAQZ680var25, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var25, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var25, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var26) is not null then
        p_n_var := 26;
        ln_tmpnum := instr(cli.JAQZ680var26, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var26, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var26, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var27) is not null then
        p_n_var := 27;
        ln_tmpnum := instr(cli.JAQZ680var27, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var27, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var27, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var28) is not null then
        p_n_var := 28;
        ln_tmpnum := instr(cli.JAQZ680var28, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var28, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var28, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var29) is not null then
        p_n_var := 29;
        ln_tmpnum := instr(cli.JAQZ680var29, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var29, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var29, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var30) is not null then
        p_n_var := 30;
        ln_tmpnum := instr(cli.JAQZ680var30, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var30, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var30, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var31) is not null then
        p_n_var := 31;
        ln_tmpnum := instr(cli.JAQZ680var31, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var31, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var31, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var32) is not null then
        p_n_var := 32;
        ln_tmpnum := instr(cli.JAQZ680var32, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var32, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var32, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var33) is not null then
        p_n_var := 33;
        ln_tmpnum := instr(cli.JAQZ680var33, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var33, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var33, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var34) is not null then
        p_n_var := 34;
        ln_tmpnum := instr(cli.JAQZ680var34, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var34, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var34, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var35) is not null then
        p_n_var := 35;
        ln_tmpnum := instr(cli.JAQZ680var35, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var35, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var35, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var36) is not null then
        p_n_var := 36;
        ln_tmpnum := instr(cli.JAQZ680var36, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var36, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var36, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var37) is not null then
        p_n_var := 37;
        ln_tmpnum := instr(cli.JAQZ680var37, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var37, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var37, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var38) is not null then
        p_n_var := 38;
        ln_tmpnum := instr(cli.JAQZ680var38, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var38, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var38, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var39) is not null then
        p_n_var := 39;
        ln_tmpnum := instr(cli.JAQZ680var39, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var39, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var39, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ680var40) is not null then
        p_n_var := 40;
        ln_tmpnum := instr(cli.JAQZ680var40, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ680var40, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ680var40, ln_tmpnum + 1);
      end if;
    
    end loop;
  
  end sp_cr_cargar_variables_NS_MENS;

  Procedure Sp_cr_Resolutores(pn_pai        in number,
                              pn_tdo        in number,
                              pc_ndo        in char,
                              pd_fecpro     in date,
                              pn_cal        out number,
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
  
    ln_ic        number(3);
    ln_lim       number(9);
    ld_fecantrcc date;
    lc_flgEx     char(1);
  
    ------------------------
  
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
         and a.tp1nro1 = ln_tdoC;
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
  
    --mod@abr 20190827
    --if pn_cal = 100.00 and lc_ndoC is not null then
    --  if lc_ndoC is null then
    --    insert into jaqz082_aux
    --     (jaqz082ndo, JAQZ082TPO)
    --    values
    --      (pc_ndo, 'CYG');
    --    commit;
    --  end if;
  
    --  pn_cal := pq_cr_segm_mens_nuev.Fn_calificacion_RCC(DocSbsCyg,
    --                                                     lc_ndoC,
    --                                                     fec_rcc,
    --                                                     MesRcc,
    --                                                     lc_tiper_Cyg);
  
    --end if;
    --mod@abr 20190827
  
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
             and a.aomod not in (108, 120, 142, 200, 144, 29) --apachecoh 2023.05.10
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
        --apachecoh 2023.05.10
        If ld_fecrec > ld_FechaRL or ld_FechaRL is null then
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
                 and a.aomod not in (108, 120, 142, 200, 144, 29) --apachecoh 2023.05.10
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
                 and a.aomod not in (108, 120, 142, 200, 144, 29) --apachecoh 2023.05.10
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
        from fst198 a
       where a.tp1cod = 1
         and a.Tp1cod1 = 10854
         and a.Tp1corr1 = 2
         and a.Tp1corr2 = 1
         and a.tp1corr3 = 2;
    exception
      when no_data_found then
        ln_lim := null;
    end;
    --fecha rcc
    if pd_fecpro = to_date('30.11.2015', 'dd.mm.yyyy') then
      ld_fecantrcc := to_date('31.10.2015', 'dd.mm.yyyy');
    else
      if pd_fecpro = to_date('31.12.2015', 'dd.mm.yyyy') then
        ld_fecantrcc := to_date('30.11.2015', 'dd.mm.yyyy');
      else
        if pd_fecpro = to_date('31.01.2016', 'dd.mm.yyyy') then
          ld_fecantrcc := to_date('31.12.2015', 'dd.mm.yyyy');
        else
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
        end if;
      end if;
    end if;
  
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
          begin
            select 'S'
              into lc_flgEx
              from CLDRCCI
             Where D_FECPRE = ld_fecantrcc
               and C_DOCIDE = trim(pc_ndo)
               and rownum = 1;
          exception
            when no_data_found then
              lc_flgEx := 'N';
          end;
          if lc_flgEx = 'S' then
            ln_CntAntRcc := ln_CntAntRcc + 1;
          end if;
        
          if lc_flgEx = 'N' then
            begin
              select 'S'
                into lc_flgEx
                from CLDRCCI
               Where D_FECPRE = ld_fecantrcc
                 and C_DOCTRI = trim(pc_ndo)
                 and rownum = 1;
            exception
              when no_data_found then
                lc_flgEx := 'N';
            end;
            if lc_flgEx = 'S' then
              ln_CntAntRcc := ln_CntAntRcc + 1;
            end if;
          end if;
        
      end case;
      ld_fecantrcc := last_day(add_months(ld_fecantrcc, -1));
      ln_ic        := ln_ic + 1;
    
    end loop;
  
  end Sp_cr_Resolutores;

  Procedure Sp_Resolutores_NS(pn_pai      in number,
                              pn_tdo      in number,
                              pc_ndo      in char,
                              pd_fecpro   in date,
                              Ln_nrobanks out number,
                              ln_promMax  out number,
                              ln_calNor   out number,
                              ln_segcod   out number,
                              lc_refinan  out char,
                              ln_histCred out number,
                              ln_porcUso  out number,
                              pn_cal      out number, --mod@abr 20190827
                              pc_flgVen   out char --mod@abr 20190827
                              ) is
  
    ln_hist      number(5);
    ln_estado    number(2);
    ld_fect      date;
    lc_existe    char(1);
    ld_fecrel    date;
    ld_fecvac    date;
    ld_fectmp    date;
    ln_promTotal number(10, 2);
    ld_rcc       date;
    lc_CodSbs    char(10);
    lc_DocSbsTit char(1);
    lc_tiper     char(1);
    ln_Rpccyg    number(2); --mod@abr 20190827
    DocSbs       number(10); --mod@abr 20190827
    DocSbsTit    char(1); --mod@abr 20190827
    fec_rcc      date; --mod@abr 20190827
    fecNum_rcc   number(9); --mod@abr 20190827
    MesRcc       number(9); --mod@abr 20190827
  
  begin
  
    --****RELCRED_CAMPNAV****--------
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
         and a.tp1cod1 = 10899
         and a.Tp1corr1 = 500
         and a.Tp1corr2 = 3;
    exception
      when no_data_found then
        ld_fecrel := null;
    end;
    --verifica si existe en la tabla de relacion crediticia
  
    begin
      select a.jaqz540his, a.jaqz540est, a.jaqz540fec, 'S'
        into ln_hist, ln_estado, ld_fect, lc_existe
        from jaqz540 a
       where a.jaqz540pai = pn_pai
         and a.jaqz540tdo = pn_tdo
         and a.jaqz540ndo = pc_ndo
         and a.jaqz540fep = ld_fecrel;
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
          pq_cr_campnavcons.sp_cr_recalcula(pn_pai,
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
  
    --****NRO_BANKSRCC_SNCMAC****--------
  
    pQ_CR_RESOLUTOR_CNSMNVDD17.SP_CR_NROENTIDADESRCC(pn_pai,
                                                     pn_tdo,
                                                     pc_ndo,
                                                     Ln_nrobanks);
  
    --****PROMD_ATRMAXRN****--------
    pQ_CR_RESOLUTOR_CNSMNVDD17.sp_cr_PromeAtrasoMax(pn_pai,
                                                    pn_tdo,
                                                    pc_ndo,
                                                    pd_fecpro,
                                                    ln_promTotal,
                                                    ln_promMax);
  
    --****PORC_USO****-------
    --fecha RCC
    begin
      select to_date(tpnro, 'dd/mm/yyyy')
        into ld_rcc
        from fst098
       where pgcod = 1
         and tpcod = 7647
         and tpcorr = 12;
    exception
      when no_data_found then
        ld_rcc := null;
    end;
  
    --codSBS
    --Guia equivalencia tipo de documento
    begin
      select Trim(to_char(a.tp1corr3))
        into lc_DocSbsTit
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11111
         and a.tp1corr1 = 1
         and a.tp1corr2 = 3
         and a.tp1nro1 = pn_tdo;
    exception
      when no_data_found then
        lc_DocSbsTit := null;
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
  
    case
      when lc_tiper = 'F' then
        begin
          select C_CODSBS
            into lc_CodSbs
            from CLDRCCI
           Where D_FECPRE = ld_rcc
             and C_TDOCID = lc_DocSbsTit
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
           Where D_FECPRE = ld_rcc
             and C_TDOCTR = lc_DocSbsTit
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
           Where D_FECPRE = ld_rcc
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
             Where D_FECPRE = ld_rcc
               and C_DOCTRI = trim(pc_ndo)
               and rownum = 1;
          exception
            when no_data_found then
              lc_CodSbs := NULL;
          end;
        end if;
      
    end case;
  
    pq_cr_segmentacion_mens_cons.Sp_cr_rccLineas(ld_rcc,
                                                 lc_CodSbs,
                                                 ln_porcUso);
  
    --****CAL_RCC_NORCPP****----
    pq_cr_segmentacion_consumo.sp_calificacion_normal_cpp(pn_pai,
                                                          pn_tdo,
                                                          pc_ndo,
                                                          pd_fecpro,
                                                          ln_calNor);
  
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
  
    --mod@abr 20190827
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
    if pc_ndo is null then
      insert into jaqz082_aux
        (jaqz082ndo, JAQZ082TPO)
      values
        (pc_ndo, 'TIT2');
      commit;
    end if;
    pn_cal := pq_cr_segm_mens_nuev.Fn_calificacion_RCC(DocSbsTit,
                                                       pc_ndo,
                                                       fec_rcc,
                                                       MesRcc,
                                                       lc_tiper);
  
    --**********VENCIDO*************---
    pQ_CR_CRED_VENDIDO.sp_cr_Vendido(pn_pai, pn_tdo, pc_ndo, pc_flgVen);
  
    --mod@abr 20190827
  end Sp_Resolutores_NS;

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

  Procedure Sp_cr_rccLineas(pd_Fec     in date,
                            pc_docsbs  in char,
                            pn_porcUso out number) is
  
    cursor bancos is
      select *
        from ahtbanc
      --where C_CODefi in ('00001', '00142')
      
      ;
  
    lc_ind1         char(1) := 0;
    lc_ind2         char(1) := 0;
    lc_ind3         char(1) := 0;
    ln_n_SaldUtil   number(18, 2) := 0;
    ln_n_SaldResp   number(18, 2) := 0;
    ln_n_SaldLinea  number(18, 2) := 0;
    ln_uso          number(18, 2) := 0;
    lc_otro         char(1) := 'N';
    ln_n_SaldUtilT  number(18, 2) := 0;
    ln_n_SaldRespT  number(18, 2) := 0;
    ln_n_SaldLineaT number(18, 2) := 0;
    ln_SaldoResulT  number(18, 2) := 0;
  
  begin
  
    lc_ind1 := '0';
    lc_ind2 := '0';
    lc_ind3 := '0';
  
    for i in bancos loop
    
      Begin
        select sum(N_SALCAP)
          into ln_n_SaldUtil
          from cldrccs a
         where a.D_FECPRE = pd_Fec
           and C_CODSBS = pc_docsbs
           and C_CODEMP = i.c_codefi --'00001' --trim(c_entidad)
           and C_CODEMP <> '00104'
           and SubStr(c_cuenta, 1, 4) in
               (select trim(tp1desc)
                  from fst198
                 Where Tp1cod = 1
                   and Tp1cod1 = 10899
                   and Tp1corr1 = 13
                   and Tp1corr2 = 8)
           and SubStr(c_cuenta, 7, 2) in
               (select trim(tp1desc)
                  from fst198
                 Where Tp1cod = 1
                   and Tp1cod1 = 10899
                   and Tp1corr1 = 13
                   and Tp1corr2 = 11);
      exception
        when others then
          ln_n_SaldUtil := 0;
      end;
    
      if nvl(ln_n_SaldUtil, 0) <> 0 then
        lc_ind1 := '1';
      
      else
        lc_ind1 := '0';
      end if;
    
      --responsabilidad de linea
    
      Begin
        select sum(N_SALCAP)
          into ln_n_SaldResp
          from cldrccs a
         where a.D_FECPRE = pd_Fec
           and C_CODSBS = pc_docsbs
           and C_CODEMP = i.c_codefi --'00001' --trim(c_entidad)
           and C_CODEMP <> '00104'
           and SubStr(c_cuenta, 1, 6) in
               (select trim(tp1desc)
                  from fst198
                 Where Tp1cod = 1
                   and Tp1cod1 = 10899
                   and Tp1corr1 = 13
                   and Tp1corr2 = 9);
      exception
        when others then
          ln_n_SaldResp := 0;
      end;
    
      if nvl(ln_n_SaldResp, 0) <> 0 then
        lc_ind2 := '1';
      
      else
        lc_ind2 := '0';
      end if;
    
      --linea
    
      Begin
        select sum(N_SALCAP)
          into ln_n_SaldLinea
          from cldrccs a
         where a.D_FECPRE = pd_Fec
           and C_CODSBS = pc_docsbs
           and C_CODEMP = i.c_codefi --'00001' --trim(c_entidad)
           and C_CODEMP <> '00104'
           and SubStr(c_cuenta, 1, 4) in
               (select trim(tp1desc)
                  from fst198
                 Where Tp1cod = 1
                   and Tp1cod1 = 10899
                   and Tp1corr1 = 13
                   and Tp1corr2 = 10)
           and SubStr(c_cuenta, 5, 2) not in
               (select trim(tp1desc)
                  from fst198
                 Where Tp1cod = 1
                   and Tp1cod1 = 10899
                   and Tp1corr1 = 13
                   and Tp1corr2 = 16);
      exception
        when others then
          ln_n_SaldLinea := 0;
      end;
    
      if nvl(ln_n_SaldLinea, 0) <> 0 then
        lc_ind3 := '1';
      
      else
        lc_ind3 := '0';
      end if;
    
      --end loop;
      ln_n_SaldUtil  := nvl(ln_n_SaldUtil, 0);
      ln_n_SaldLinea := nvl(ln_n_SaldLinea, 0);
      ln_n_SaldResp  := nvl(ln_n_SaldResp, 0);
    
      case
      
        when lc_ind1 = '0' and lc_ind2 = '1' and lc_ind3 = '1' then
          ln_n_SaldUtil := ln_n_SaldLinea - ln_n_SaldResp;
        when lc_ind1 = '1' and lc_ind2 = '0' and lc_ind3 = '0' then
          ln_n_SaldLinea := ln_n_SaldUtil;
        when lc_ind1 = '0' and lc_ind2 = '1' and lc_ind3 = '0' then
          ln_n_SaldLinea := ln_n_SaldResp;
        when lc_ind1 = '0' and lc_ind2 = '0' and lc_ind3 = '1' then
          ln_n_SaldUtil  := 0;
          ln_n_SaldLinea := 0;
        when lc_ind1 = '1' and lc_ind2 = '1' and lc_ind3 = '0' then
          ln_n_SaldLinea := ln_n_SaldUtil + ln_n_SaldResp;
        else
          lc_otro := 'S';
      end case;
    
      ln_n_SaldUtilT  := ln_n_SaldUtilT + ln_n_SaldUtil;
      ln_n_SaldRespT  := ln_n_SaldRespT + ln_n_SaldResp;
      ln_n_SaldLineaT := ln_n_SaldLineaT + ln_n_SaldLinea;
    
      ln_n_SaldUtil  := null;
      ln_n_SaldResp  := null;
      ln_n_SaldLinea := null;
    
    end loop;
  
    lc_ind1 := null;
    lc_ind2 := null;
    lc_ind3 := null;
    if ln_n_SaldLineaT > 0 then
      ln_SaldoResulT := ln_n_SaldUtilT / ln_n_SaldLineaT;
    else
      ln_SaldoResulT := 0;
    end if;
    --calculo uso
  
    if ln_SaldoResulT <> 0 then
      ln_uso := ln_SaldoResulT;
    else
      ln_uso := 0;
    end if;
  
    if ln_uso < 0 then
      ln_uso := ln_uso * -1;
    end if;
  
    pn_porcUso := ln_uso * 100;
  
  end Sp_cr_rccLineas;

  Function Fn_Verifica_Linea(lc_subCuenta3 in varchar2) return char is
  
    cursor cont8 is
      select *
        from fst198
       Where Tp1cod = 1
         and Tp1cod1 = 10899
         and Tp1corr1 = 13
         and Tp1corr2 = 11;
  
    lc_flagLin char(1) := 'N';
    lc_v78     char(2);
  begin
    for i in cont8 loop
      lc_v78 := trim(i.tp1desc);
    
      if lc_v78 = lc_subCuenta3 then
        lc_flagLin := 'S';
        exit;
      else
        lc_flagLin := 'N';
      end if;
    
    end loop;
    return lc_flagLin;
  end Fn_Verifica_Linea;

  Function Fn_Verifica_Castigo(lc_subCuenta4 in char) return char is
  
    cursor cont9 is
      select *
        from fst198
       Where Tp1cod = 1
         and Tp1cod1 = 10899
         and Tp1corr1 = 13
         and Tp1corr2 = 16;
  
    lc_flagCast char(1) := 'N';
    lc_v56      char(2);
  begin
    for i in cont9 loop
      lc_v56 := trim(i.tp1desc);
    
      if lc_v56 = lc_subCuenta4 then
        lc_flagCast := 'S';
        exit;
      else
        lc_flagCast := 'N';
      end if;
    
    end loop;
    return lc_flagCast;
  end Fn_Verifica_Castigo;

end pq_Cr_segmentacion_mens_cons;
/

