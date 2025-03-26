CREATE OR REPLACE PACKAGE pq_migra_facultades IS
  Procedure sp_migra_job_facultades(p_d_fecha in date /*,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   p_c_error out varchar2*/);

  Procedure sp_asgina_facultades_BJR(P_C_DIGITO1 IN VARCHAR2,
                                     P_C_DIGITO2 IN VARCHAR2,
                                     P_N_INI     IN NUMBER,
                                     P_C_FECPRO  IN VARCHAR2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_genera_grupos(P_N_CTABTT in number,
                             P_N_NUMFIR in number,
                             P_C_NUMCTA in varchar2);

  Procedure sp_genera_grupos_obli(P_N_CTABTT in number,
                                  P_N_NUMFIR in number,
                                  P_C_NUMCTA in varchar2);

  Procedure sp_asgina_facultades_BJR_una(P_C_FECPRO IN VARCHAR2,
                                         P_N_INI    IN NUMBER,
                                         CUENTA     IN NUMBER);

  function fn_existe_bt(N_CTABTT in number) return char;

  Procedure sp_asgina_facultades_BJR_todas(P_C_FECPRO IN VARCHAR2,
                                           P_N_INI    IN NUMBER);
    Procedure sp_bandeja_ahdrecu;      
      Procedure sp_bandeja_fsd313;                                   

/*CREATE OR REPLACE TYPE T_VARCHAR2 IS VARRAY(50) OF VARCHAR2(400)                               */
end pq_migra_facultades;
/
CREATE OR REPLACE PACKAGE BODY pq_migra_facultades IS

  procedure sp_migra_job_facultades(p_d_fecha in date) is
    -- ****************************************************************
    -- Nombre                     : sp_cr_batch_btctaprd
    -- Sistema                    : SORFY
    -- Modulo                     : Personas
    -- Version                    : 1.0
    -- Fecha de Creacion          : 25/04/2011
    -- Autor de Creacion          : LLLOSA
    -- Uso                        : GENERACION DE JOBS  PARA BTCTAPRD PRODUCTOS
    -- Estado                     : Activo
    -- Acceso                     : Publico
    -- Parametros de Entrada      : 
    -- Parametros de Salida       : 
    -- Fecha de modificacion      :
    -- Autor de Modificacion      :
    -- Descripcion de Modificacion:
    -- ****************************************************************    
  
    cursor c_job is
      select /*+PARALLEL(a,2,1)*/
      --n_sucurs,
       SUBSTR(N_CTABTT, -1, 1) C_DIGITO1,
       NVL(SUBSTR(N_CTABTT, -2, 1), -1) C_DIGITO2
        from btctaprd a
       where a.c_indpro = 'A'
       group by --n_sucurs,
                SUBSTR(N_CTABTT, -1, 1),
                NVL(SUBSTR(N_CTABTT, -2, 1), -1);
  
    lc_variable varchar2(4000);
    ln_job      number := 0;
    ln_ini      number := 0;
    lc_fecha    varchar2(10);
  
  begin
  
    execute immediate ('truncate table bandejas.bje130');
    execute immediate ('truncate table bandejas.bjr130');
    execute immediate ('truncate table bandejas.ahdrecu');
    delete from bandejas.bjr011 where bnjcod = 1100;
    delete from mgfacju;
    delete from tab_jobs where c_codage = 'FAC';
    commit;
    -- Actualiza datos fuente 
    pq_migra_facultades.sp_bandeja_ahdrecu;
    pq_migra_facultades.sp_bandeja_fsd313;
    --
    -- Barridos de jobs
    --
    lc_fecha := to_char(p_d_fecha, 'rrrr.mm.dd');
    for job in c_job loop
      ln_ini      := ln_ini + 1;
      lc_variable := ' begin ' ||
                     '  pq_migra_facultades.sp_asgina_facultades_BJR(' ||
                     job.C_DIGITO1 || ',' || job.C_DIGITO2 || ',' || ln_ini || ',' || '''' ||
                     lc_fecha || '''' || ');' || ' End; ';
      ln_job      := ln_job + 1;
    
      --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
      dbms_scheduler.create_job(job_name   => 'FACULTX_' || ln_ini ||
                                              LPAD(TO_CHAR(ln_job), 5, '0'),
                                job_type   => 'PLSQL_BLOCK',
                                job_action => lc_variable,
                                start_date => sysdate + 1 / (24 * 1800),
                                enabled    => true,
                                auto_drop  => TRUE,
                                comments   => 'PROCESA DATOS DE FACULTADES ' ||
                                              ln_ini);
      COMMIT;
    
      -- INSERTA TABLA CONTROL
    
      INSERT INTO Tab_jobs
        (c_codage, n_Numer1, c_detjob)
      VALUES
        ('FAC', ln_ini, lc_variable);
      COMMIT;
      commit;
    end loop;
  exception
    when others then
      --p_c_error:=  lc_variable;
      nulL;
  end sp_migra_job_facultades;

  ----------------------------------------------------------------------

  Procedure sp_asgina_facultades_BJR(P_C_DIGITO1 IN VARCHAR2,
                                     P_C_DIGITO2 IN VARCHAR2,
                                     P_N_INI     IN NUMBER,
                                     P_C_FECPRO  IN VARCHAR2) is
  
    -- cursor para clientes con indistintas y mancomunos
    cursor cli_ind_man is
      select n_ctabtt,
             count(distinct case
                     when c_codtcu = '2' then
                      c_numcta
                     else
                      null
                   end) n_ctaind,
             count(distinct case
                     when c_codtcu = '3' then
                      c_numcta
                     else
                      null
                   end) n_ctaman
        from btctaprd  a
       where c_indpro = 'A'
         and c_codtcu in (2, 3)
         and substr(a.N_CTABTT, -1, 1) = P_C_DIGITO1
         and nvl(substr(a.N_CTABTT, -2, 1), -1) = P_C_DIGITO2
       group by a.n_ctabtt;
  
    cursor cli_ind_man_j is
      select n_ctabtt,
             count(distinct case
                     when c_codtcu = '2' then
                      c_numcta
                     else
                      null
                   end) n_ctaind,
             count(distinct case
                     when n_numfir >= 1 then
                      c_numcta
                     else
                      null
                   end) n_ctaman
        from btctaprd  a
       where c_indpro = 'A'
         and c_tipper = 'J'
         and substr(a.N_CTABTT, -1, 1) = P_C_DIGITO1
         and nvl(substr(a.N_CTABTT, -2, 1), -1) = P_C_DIGITO2
       group by a.n_ctabtt;
  
    -- cursor para datos de personas por cliente 
    cursor ctacli(ln_ctabtt in number) is
      select n_ctabtt, a.n_codpai, a.n_tipdoc, a.n_numdoc
        from btctaprd  a
       where c_indpro = 'A'
         and a.n_ctabtt = ln_ctabtt
       group by n_ctabtt, a.n_codpai, a.n_tipdoc, a.n_numdoc;
  
    cursor ctacli_j(ln_ctabtt in number) is
      select n_ctabtt, b.pais n_codpai, b.tdocum n_tipdoc, b.ndoc n_numdoc
        from btctaprd  a, ahdrecu b
       where a.c_numcta = b.c_numcta
         and a.c_indpro = 'A'
         and a.n_ctabtt = ln_ctabtt
       group by n_ctabtt, b.pais, b.tdocum, b.ndoc;
  
    cursor individ is
      select distinct 1, A.N_CTABTT, A.N_CODPAI, A.N_TIPDOC, A.N_NUMDOC
        from btctaprd  A
       WHERE C_INDPRO = 'A'
         AND C_CODTCU = 1
         and a.c_tipper = 'N'
         and substr(a.N_CTABTT, -1, 1) = P_C_DIGITO1
         and nvl(substr(a.N_CTABTT, -2, 1), -1) = P_C_DIGITO2;
  
    cursor ctacliope(ln_ctabtt in number) is
      select n_ctabtt,
             a.c_numcta,
             a.n_sucurs,
             a.n_moneda,
             a.n_papel,
             a.n_operac,
             a.n_subope,
             a.n_modulo,
             a.n_totope
        from btctaprd  a
       where c_indpro = 'A'
         and a.n_ctabtt = ln_ctabtt
       group by n_ctabtt,
                a.c_numcta,
                a.n_sucurs,
                a.n_moneda,
                a.n_papel,
                a.n_operac,
                a.n_subope,
                a.n_modulo,
                a.n_totope
       order by 2, 3, 7;
  
    ln_grup  number;
    ln_fac   number := 1;
    ld_fecha date := to_date(p_c_fecpro, 'rrrr.mm.dd');
  
    lc_error  varchar2(200);
    ln_ctabtt number;
    ln_contad number := 0;
    lc_msgerr varchar2(400);
  
    existebt char(1);
  
  begin
  
    update tab_jobs g
       set g.d_fecini = sysdate
     where g.n_numer1 = P_N_INI
       and g.c_codage = 'FAC';
    commit;
  
    -- INDIVIDUALES
  
    ln_grup := 1;
    for p in individ loop
    
      existebt := fn_existe_bt(p.N_CTABTT);
    
      If existebt = 'N' then
        begin
          insert into bandejas.bje130
            (BE130ECod,
             BE130NCta,
             BE130FCod,
             BE130GFac,
             BE130FDes,
             BE130LFac,
             BE130FVig,
             BE130LMnN,
             BE130Est)
          values
            (1,
             p.N_CTABTT,
             ln_fac,
             ln_grup,
             ld_fecha,
             999999999999,
             'S',
             999999999999,
             'P');
        exception
          when others then
            lc_error := sqlerrm;
            insert into LOG_ERROR_BANDEJA
              (n_nro, c_codbdj, c_deserr, d_fecerr)
            values
              (P_N_INI, 'bje130', lc_error, sysdate);
            commit;
        end;
        begin
          insert into bandejas.bjr130
            (BR130ECod,
             BR130NCta,
             BR130FCod,
             BR130RFac,
             BR130FDes,
             BR130Pais,
             BR130TDoc,
             BR130NDoc,
             BR130Est)
          values
            (1,
             p.N_CTABTT,
             ln_fac,
             ln_grup,
             ld_fecha,
             p.N_CODPAI,
             p.N_TIPDOC,
             p.N_NUMDOC,
             'P');
        exception
          when others then
            lc_error := sqlerrm;
            insert into LOG_ERROR_BANDEJA
              (n_nro, c_codbdj, c_deserr, d_fecerr)
            values
              (P_N_INI, 'bjr130', p.n_ctabtt || ' : ' || lc_error, sysdate);
            commit;
        end;
        ln_contad := ln_contad + 2;
      
        if ln_contad = 100 then
          commit;
          ln_contad := 0;
        end if;
      end if;
    end loop;
    commit;
  
    ---------------------------JURIDICAS-------------------------
  
    for i in cli_ind_man_j loop
    
      existebt := fn_existe_bt(i.n_ctabtt);
    
      ln_grup := 501;
    
      -- Cliente con indistinta unicamente
      for j in ctacli_j(i.n_ctabtt) loop
        -- recorremos las cuentas de ahorros del cliente 
        /*        ln_grup := ln_grup + 1;
        
        if ln_grup = 511 then
          ln_grup := ln_grup + 1;
        end if;*/
        If existebt = 'N' then
          begin
            insert into bandejas.bje130
              (be130ecod,
               be130ncta,
               be130fcod,
               be130gfac,
               be130fdes,
               be130lfac,
               be130fvig,
               be130lmnn,
               be130est)
            values
              (1,
               i.n_ctabtt,
               ln_fac,
               ln_grup,
               ld_fecha,
               999999999999,
               'S',
               999999999999,
               'P');
          exception
            when others then
              lc_error := sqlerrm;
              --insertar a una tabla generica de excepciones (dato y la bandeja)
              insert into LOG_ERROR_BANDEJA
                (n_nro, c_codbdj, c_deserr, d_fecerr)
              values
                (P_N_INI,
                 'bje130',
                 i.n_ctabtt || ' 0: ' || lc_error,
                 sysdate);
              commit;
          end;
          --
          begin
            insert into bandejas.bjr130
              (br130ecod,
               br130ncta,
               br130fcod,
               br130rfac,
               br130fdes,
               br130pais,
               br130tdoc,
               br130ndoc,
               br130est)
            values
              (1,
               i.n_ctabtt,
               ln_fac,
               ln_grup,
               ld_fecha,
               j.n_codpai,
               j.n_tipdoc,
               j.n_numdoc,
               'P');
          exception
            when others then
              lc_error := sqlerrm;
              --insertar a una tabla generica de excepciones (dato y la bandeja)
              insert into LOG_ERROR_BANDEJA
                (n_nro, c_codbdj, c_deserr, d_fecerr)
              values
                (P_N_INI,
                 'bjr130',
                 i.n_ctabtt || ' 1: ' || lc_error,
                 sysdate);
              commit;
          end;
        end if;
      
        for f in ctacliope(i.n_ctabtt) loop
          -- recorremos las cuentas de ahorros del cliente 
          begin
          
            -- operacion
            insert into bandejas.bjr011
              (BnjEmp,
               BnjCod,
               BnjR1suc,
               BnjR1mda,
               BNJR1COD,
               BNJR1MOD,
               BnjR1pap,
               BnjR1cta,
               BnjR1oper,
               BnjR1sbop,
               BnjR1tope,
               BnjRelcod,
               BnjR2mod,
               BnjR2cta,
               BnjR2oper,
               BnjR2sbop,
               BnjR1rub,
               BnjR2cod,
               BnjR2suc,
               BnjR2mda,
               BnjR2pap,
               BnjR2tope,
               BnjR2rub,
               BnjR011cd,
               BnjR011mo,
               BnjR011su,
               BnjR011tr,
               BnjR011re,
               BnjR011fc,
               BnjR011or,
               BnjR011sb,
               BnjR011co,
               BnjR011Est)
            values
              (1,
               1100,
               f.n_sucurs,
               f.n_moneda,
               1,
               f.n_modulo,
               f.n_papel,
               f.n_ctabtt,
               f.n_operac,
               f.n_subope,
               f.n_totope,
               5,
               ln_fac,
               f.n_ctabtt,
               to_number(to_char(ld_fecha, 'YYYYMMDD')),
               ln_grup,
               null,
               1,
               f.n_modulo,
               
               null,
               null,
               null,
               null,
               null,
               null,
               null,
               null,
               null,
               null,
               null,
               null,
               'S',
               'P');
          exception
            when others then
              lc_error := sqlerrm;
              --insertar a una tabla generica de excepciones (dato y la bandeja)
              insert into LOG_ERROR_BANDEJA
                (n_nro, c_codbdj, c_deserr, d_fecerr)
              values
                (P_N_INI,
                 'bjr011',
                 i.n_ctabtt || ' 2: ' || lc_error,
                 sysdate);
              commit;
          end;
        end loop;
      end loop;
      commit;
    end loop;
  
    ------------- INDISTINTAS Y MANCOMUNADAS PERSONAS NATURALES------------
  
    for i in cli_ind_man loop
    
      existebt := fn_existe_bt(i.n_ctabtt);
    
      ln_grup := 500;
      -- recorremos los clientes mancomunos e indistintos
      case
        when i.n_ctaind > 0 and i.n_ctaman = 0 then
          -- Cliente con indistinta unicamente
          for j in ctacli(i.n_ctabtt) loop
            -- recorremos las cuentas de ahorros del cliente 
            If existebt = 'N' then
            
              ln_grup := ln_grup + 1;
            
              if ln_grup = 500 then
                ln_grup := ln_grup + 1;
              end if;
            
              begin
                insert into bandejas.bje130
                  (be130ecod,
                   be130ncta,
                   be130fcod,
                   be130gfac,
                   be130fdes,
                   be130lfac,
                   be130fvig,
                   be130lmnn,
                   be130est)
                values
                  (1,
                   i.n_ctabtt,
                   ln_fac,
                   ln_grup,
                   ld_fecha,
                   999999999999,
                   'S',
                   999999999999,
                   'P');
              exception
                when others then
                  lc_error := sqlerrm;
                  --insertar a una tabla generica de excepciones (dato y la bandeja)
                  insert into LOG_ERROR_BANDEJA
                    (n_nro, c_codbdj, c_deserr, d_fecerr)
                  values
                    (P_N_INI,
                     'bje130',
                     i.n_ctabtt || ' 0: ' || lc_error,
                     sysdate);
                  commit;
              end;
              --
              begin
                insert into bandejas.bjr130
                  (br130ecod,
                   br130ncta,
                   br130fcod,
                   br130rfac,
                   br130fdes,
                   br130pais,
                   br130tdoc,
                   br130ndoc,
                   br130est)
                values
                  (1,
                   i.n_ctabtt,
                   ln_fac,
                   ln_grup,
                   ld_fecha,
                   j.n_codpai,
                   j.n_tipdoc,
                   j.n_numdoc,
                   'P');
              exception
                when others then
                  lc_error := sqlerrm;
                  --insertar a una tabla generica de excepciones (dato y la bandeja)
                  insert into LOG_ERROR_BANDEJA
                    (n_nro, c_codbdj, c_deserr, d_fecerr)
                  values
                    (P_N_INI,
                     'bjr130',
                     i.n_ctabtt || ' 1: ' || lc_error,
                     sysdate);
                  commit;
              end;
            end if;
          
            for f in ctacliope(i.n_ctabtt) loop
              -- recorremos las cuentas de ahorros del cliente 
              begin
              
                -- operacion
                insert into bandejas.bjr011
                  (BnjEmp,
                   BnjCod,
                   BnjR1suc,
                   BnjR1mda,
                   BNJR1COD,
                   BNJR1MOD,
                   BnjR1pap,
                   BnjR1cta,
                   BnjR1oper,
                   BnjR1sbop,
                   BnjR1tope,
                   BnjRelcod,
                   BnjR2mod,
                   BnjR2cta,
                   BnjR2oper,
                   BnjR2sbop,
                   BnjR1rub,
                   BnjR2cod,
                   BnjR2suc,
                   BnjR2mda,
                   BnjR2pap,
                   BnjR2tope,
                   BnjR2rub,
                   BnjR011cd,
                   BnjR011mo,
                   BnjR011su,
                   BnjR011tr,
                   BnjR011re,
                   BnjR011fc,
                   BnjR011or,
                   BnjR011sb,
                   BnjR011co,
                   BnjR011Est)
                values
                  (1,
                   1100,
                   f.n_sucurs,
                   f.n_moneda,
                   1,
                   f.n_modulo,
                   f.n_papel,
                   f.n_ctabtt,
                   f.n_operac,
                   f.n_subope,
                   f.n_totope,
                   5,
                   ln_fac,
                   f.n_ctabtt,
                   to_number(to_char(ld_fecha, 'YYYYMMDD')),
                   ln_grup,
                   null,
                   1,
                   f.n_modulo,
                   
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   'S',
                   'P');
              exception
                when others then
                  lc_error := sqlerrm;
                  --insertar a una tabla generica de excepciones (dato y la bandeja)
                  insert into LOG_ERROR_BANDEJA
                    (n_nro, c_codbdj, c_deserr, d_fecerr)
                  values
                    (P_N_INI,
                     'bjr011',
                     i.n_ctabtt || ' 2: ' || lc_error,
                     sysdate);
                  commit;
              end;
            end loop;
          end loop;
          commit;
        when i.n_ctaind = 0 and i.n_ctaman > 0 then
          -- Cliente con mancomunados unicamente
          ln_grup := 511;
          begin
            insert into bandejas.bje130
              (be130ecod,
               be130ncta,
               be130fcod,
               be130gfac,
               be130fdes,
               be130lfac,
               be130fvig,
               be130lmnn,
               be130est)
            values
              (1,
               i.n_ctabtt,
               ln_fac,
               ln_grup,
               ld_fecha,
               999999999999,
               'S',
               999999999999,
               'P');
          exception
            when others then
              lc_error := sqlerrm;
              --insertar a una tabla generica de excepciones (dato y la bandeja)
              insert into LOG_ERROR_BANDEJA
                (n_nro, c_codbdj, c_deserr, d_fecerr)
              values
                (P_N_INI,
                 'bje130',
                 i.n_ctabtt || ' 3: ' || lc_error,
                 sysdate);
              commit;
          end;
        
          for k in ctacli(i.n_ctabtt) loop
            --integrantes
            begin
              insert into bandejas.bjr130
                (br130ecod,
                 br130ncta,
                 br130fcod,
                 br130rfac,
                 br130fdes,
                 br130pais,
                 br130tdoc,
                 br130ndoc,
                 br130est)
              values
                (1,
                 i.n_ctabtt,
                 ln_fac,
                 ln_grup,
                 ld_fecha,
                 k.n_codpai,
                 k.n_tipdoc,
                 k.n_numdoc,
                 'P');
            exception
              when others then
                lc_error := sqlerrm;
                --insertar a una tabla generica de excepciones (dato y la bandeja)
                insert into LOG_ERROR_BANDEJA
                  (n_nro, c_codbdj, c_deserr, d_fecerr)
                values
                  (P_N_INI,
                   'bjr130',
                   i.n_ctabtt || ' 4: ' || lc_error,
                   sysdate);
                commit;
            end;
          end loop;
          commit;
          for f in ctacliope(i.n_ctabtt) loop
            -- recorremos las cuentas de ahorros del cliente 
            begin
            
              -- operacion
              insert into bandejas.bjr011
                (BnjEmp,
                 BnjCod,
                 BnjR1suc,
                 BnjR1mda,
                 BNJR1COD,
                 BNJR1MOD,
                 BnjR1pap,
                 BnjR1cta,
                 BnjR1oper,
                 BnjR1sbop,
                 BnjR1tope,
                 BnjRelcod,
                 BnjR2mod,
                 BnjR2cta,
                 BnjR2oper,
                 BnjR2sbop,
                 BnjR1rub,
                 BnjR2cod,
                 BnjR2suc,
                 BnjR2mda,
                 BnjR2pap,
                 BnjR2tope,
                 BnjR2rub,
                 BnjR011cd,
                 BnjR011mo,
                 BnjR011su,
                 BnjR011tr,
                 BnjR011re,
                 BnjR011fc,
                 BnjR011or,
                 BnjR011sb,
                 BnjR011co,
                 BnjR011Est)
              values
                (1,
                 1100,
                 f.n_sucurs,
                 f.n_moneda,
                 1,
                 f.n_modulo,
                 f.n_papel,
                 f.n_ctabtt,
                 f.n_operac,
                 f.n_subope,
                 f.n_totope,
                 5,
                 ln_fac,
                 f.n_ctabtt,
                 to_number(to_char(ld_fecha, 'YYYYMMDD')),
                 ln_grup,
                 null,
                 1,
                 f.n_modulo,
                 
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 'S',
                 'P');
            exception
              when others then
                lc_error := sqlerrm;
                --insertar a una tabla generica de excepciones (dato y la bandeja)
                insert into LOG_ERROR_BANDEJA
                  (n_nro, c_codbdj, c_deserr, d_fecerr)
                values
                  (P_N_INI,
                   'bjr011',
                   i.n_ctabtt || ' 5: ' || lc_error,
                   sysdate);
                commit;
            end;
          end loop;
          commit;
        else
          -- clientes con cuentas mixtas mancomunadas e indistintas
        
          ln_grup := 500;
          for j in ctacli(i.n_ctabtt) loop
            -- recorremos las cuentas de ahorros del cliente 
            ln_grup := ln_grup + 1;
          
            if ln_grup = 511 then
              ln_grup := ln_grup + 1;
            end if;
          
            begin
              insert into bandejas.bje130
                (be130ecod,
                 be130ncta,
                 be130fcod,
                 be130gfac,
                 be130fdes,
                 be130lfac,
                 be130fvig,
                 be130lmnn,
                 be130est)
              values
                (1,
                 i.n_ctabtt,
                 ln_fac,
                 ln_grup,
                 ld_fecha,
                 999999999999,
                 'S',
                 999999999999,
                 'P');
            exception
              when others then
                lc_error := sqlerrm;
                --insertar a una tabla generica de excepciones (dato y la bandeja)
                insert into LOG_ERROR_BANDEJA
                  (n_nro, c_codbdj, c_deserr, d_fecerr)
                values
                  (P_N_INI,
                   'bje130',
                   i.n_ctabtt || ' 6: ' || lc_error,
                   sysdate);
                commit;
            end;
            --
            begin
              insert into bandejas.bjr130
                (br130ecod,
                 br130ncta,
                 br130fcod,
                 br130rfac,
                 br130fdes,
                 br130pais,
                 br130tdoc,
                 br130ndoc,
                 br130est)
              values
                (1,
                 i.n_ctabtt,
                 ln_fac,
                 ln_grup,
                 ld_fecha,
                 j.n_codpai,
                 j.n_tipdoc,
                 j.n_numdoc,
                 'P');
            exception
              when others then
                lc_error := sqlerrm;
                --insertar a una tabla generica de excepciones (dato y la bandeja)
                insert into LOG_ERROR_BANDEJA
                  (n_nro, c_codbdj, c_deserr, d_fecerr)
                values
                  (P_N_INI,
                   'bjr130',
                   i.n_ctabtt || ' 7: ' || lc_error,
                   sysdate);
                commit;
            end;
            for f in ctacliope(i.n_ctabtt) loop
              -- recorremos las cuentas de ahorros del cliente 
              begin
              
                -- operacion
                insert into bandejas.bjr011
                  (BnjEmp,
                   BnjCod,
                   BnjR1suc,
                   BnjR1mda,
                   BNJR1COD,
                   BNJR1MOD,
                   BnjR1pap,
                   BnjR1cta,
                   BnjR1oper,
                   BnjR1sbop,
                   BnjR1tope,
                   BnjRelcod,
                   BnjR2mod,
                   BnjR2cta,
                   BnjR2oper,
                   BnjR2sbop,
                   BnjR1rub,
                   BnjR2cod,
                   BnjR2suc,
                   BnjR2mda,
                   BnjR2pap,
                   BnjR2tope,
                   BnjR2rub,
                   BnjR011cd,
                   BnjR011mo,
                   BnjR011su,
                   BnjR011tr,
                   BnjR011re,
                   BnjR011fc,
                   BnjR011or,
                   BnjR011sb,
                   BnjR011co,
                   BnjR011Est)
                values
                  (1,
                   1100,
                   f.n_sucurs,
                   f.n_moneda,
                   1,
                   f.n_modulo,
                   f.n_papel,
                   f.n_ctabtt,
                   f.n_operac,
                   f.n_subope,
                   f.n_totope,
                   5,
                   ln_fac,
                   f.n_ctabtt,
                   to_number(to_char(ld_fecha, 'YYYYMMDD')),
                   ln_grup,
                   null,
                   1,
                   f.n_modulo,
                   
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   'S',
                   'P');
              exception
                when others then
                  lc_error := sqlerrm;
                  --insertar a una tabla generica de excepciones (dato y la bandeja)
                  insert into LOG_ERROR_BANDEJA
                    (n_nro, c_codbdj, c_deserr, d_fecerr)
                  values
                    (P_N_INI,
                     'bjr011',
                     i.n_ctabtt || ' 8: ' || lc_error,
                     sysdate);
                  commit;
              end;
            end loop;
          end loop;
        
          ln_grup := 511;
          begin
            insert into bandejas.bje130
              (be130ecod,
               be130ncta,
               be130fcod,
               be130gfac,
               be130fdes,
               be130lfac,
               be130fvig,
               be130lmnn,
               be130est)
            values
              (1,
               i.n_ctabtt,
               ln_fac,
               ln_grup,
               ld_fecha,
               999999999999,
               'S',
               999999999999,
               'P');
          exception
            when others then
              lc_error := sqlerrm;
              --insertar a una tabla generica de excepciones (dato y la bandeja)
              insert into LOG_ERROR_BANDEJA
                (n_nro, c_codbdj, c_deserr, d_fecerr)
              values
                (P_N_INI,
                 'bje130',
                 i.n_ctabtt || ' 9: ' || lc_error,
                 sysdate);
              commit;
          end;
        
          for k in ctacli(i.n_ctabtt) loop
            --integrantes
            begin
              insert into bandejas.bjr130
                (br130ecod,
                 br130ncta,
                 br130fcod,
                 br130rfac,
                 br130fdes,
                 br130pais,
                 br130tdoc,
                 br130ndoc,
                 br130est)
              values
                (1,
                 i.n_ctabtt,
                 ln_fac,
                 ln_grup,
                 ld_fecha,
                 k.n_codpai,
                 k.n_tipdoc,
                 k.n_numdoc,
                 'P');
            exception
              when others then
                lc_error := sqlerrm;
                --insertar a una tabla generica de excepciones (dato y la bandeja)
                insert into LOG_ERROR_BANDEJA
                  (n_nro, c_codbdj, c_deserr, d_fecerr)
                values
                  (P_N_INI,
                   'bjr130',
                   i.n_ctabtt || ' 10: ' || lc_error,
                   sysdate);
                commit;
            end;
          end loop;
          for f in ctacliope(i.n_ctabtt) loop
            -- recorremos las cuentas de ahorros del cliente 
            begin
            
              -- operacion
              insert into bandejas.bjr011
                (BnjEmp,
                 BnjCod,
                 BnjR1suc,
                 BnjR1mda,
                 BNJR1COD,
                 BNJR1MOD,
                 BnjR1pap,
                 BnjR1cta,
                 BnjR1oper,
                 BnjR1sbop,
                 BnjR1tope,
                 BnjRelcod,
                 BnjR2mod,
                 BnjR2cta,
                 BnjR2oper,
                 BnjR2sbop,
                 BnjR1rub,
                 BnjR2cod,
                 BnjR2suc,
                 BnjR2mda,
                 BnjR2pap,
                 BnjR2tope,
                 BnjR2rub,
                 BnjR011cd,
                 BnjR011mo,
                 BnjR011su,
                 BnjR011tr,
                 BnjR011re,
                 BnjR011fc,
                 BnjR011or,
                 BnjR011sb,
                 BnjR011co,
                 BnjR011Est)
              values
                (1,
                 1100,
                 f.n_sucurs,
                 f.n_moneda,
                 1,
                 f.n_modulo,
                 f.n_papel,
                 f.n_ctabtt,
                 f.n_operac,
                 f.n_subope,
                 f.n_totope,
                 5,
                 ln_fac,
                 f.n_ctabtt,
                 to_number(to_char(ld_fecha, 'YYYYMMDD')),
                 ln_grup,
                 null,
                 1,
                 f.n_modulo,
                 
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 'S',
                 'P');
            exception
              when others then
                lc_error := sqlerrm;
                --insertar a una tabla generica de excepciones (dato y la bandeja)
                insert into LOG_ERROR_BANDEJA
                  (n_nro, c_codbdj, c_deserr, d_fecerr)
                values
                  (P_N_INI,
                   'bjr011',
                   i.n_ctabtt || ' 11: ' || lc_error,
                   sysdate);
                commit;
            end;
          end loop;
      end case;
      commit;
    end loop;
    commit;
  
    update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 = P_N_INI
       and g.c_codage = 'FAC';
    commit;
  EXCEPTION
    when others then
      lc_msgerr := sqlerrm;
      update tab_jobs g
         set g.c_inderr = 'S', g.c_deserr = lc_msgerr
       where g.n_numer1 = P_N_INI
         and g.c_codage = 'FAC';
      commit;
      return;
    
  end;

  --------------------------------------------------------------

  Procedure sp_genera_grupos(P_N_CTABTT in number,
                             P_N_NUMFIR in number,
                             P_C_NUMCTA in varchar2) is
  
    t_combina T_VARCHAR2 := T_VARCHAR2();
    lc_error  VARCHAR2(400);
    cursor c_limpia is
      select /*+PARALLEL(g,2,1)*/
       g.*
        from mgfacju g
       where g.n_orden = 0;
    --and n_ini = P_N_INI;
  
    cursor c_caso_xxx is
      select v.c_codrel
        from ahdrecu v
       where c_numcta = P_C_NUMCTA
         and rownum <= P_N_NUMFIR
       order by c_codrel;
  
    ln_ctabtt number;
    lc_numcta varchar2(17);
    LV_1      varchar2(10);
    LV_2      varchar2(10);
    LV_3      varchar2(10);
    LV_4      varchar2(10);
    LV_5      varchar2(10);
    LV_6      varchar2(10);
    LV_7      varchar2(10);
    lv_tmp    varchar2(10);
    --ln_cont NUMBER (12):=0;   
    ln_cant   number := 0;
    ln_numfio number := 0;
  begin
  
    ln_ctabtt := P_N_CTABTT;
    lc_numcta := P_C_NUMCTA;
    case
      when P_N_NUMFIR = 1 then
      
        for i in (select distinct A.N_CTABTT,
                                  b.c_codrel,
                                  b.pais,
                                  b.tdocum,
                                  b.ndoc
                    from BTCTAPRD A, AHDRECU b
                   WHERE C_INDPRO = 'A'
                     AND C_CODTCU = 1
                     and n_ctabtt = ln_ctabtt
                     and a.c_numcta = lc_numcta -- se agrego
                     and a.c_tipper = 'J'
                     and a.c_numcta = b.c_numcta) loop
          insert into mgfacju (lv_01, n_orden) values (i.c_codrel, 1);
        end loop;
      when P_N_NUMFIR = 2 then
        for i in (select distinct A.N_CTABTT,
                                  b.c_codrel,
                                  b.pais,
                                  b.tdocum,
                                  b.ndoc
                    from BTCTAPRD A, AHDRECU b
                   WHERE C_INDPRO = 'A'
                     AND C_CODTCU = 1
                     and n_ctabtt = ln_ctabtt
                     and a.c_numcta = lc_numcta -- se agrego
                     and a.c_tipper = 'J'
                     and a.c_numcta = b.c_numcta) loop
          for j in (select distinct A.N_CTABTT,
                                    b.c_codrel,
                                    b.pais,
                                    b.tdocum,
                                    b.ndoc
                      from BTCTAPRD A, AHDRECU b
                     WHERE C_INDPRO = 'A'
                       AND C_CODTCU = 1
                       and n_ctabtt = ln_ctabtt
                       and a.c_numcta = lc_numcta -- se agrego                                 
                       and a.c_tipper = 'J'
                       and a.c_numcta = b.c_numcta) loop
            insert into mgfacju
              (lv_01, lv_02, n_orden)
            values
              (i.c_codrel, j.c_codrel, 0);
          end loop;
        end loop;
      
        -- ELIMINA CAMPOS IGUALES
        for k in c_limpia loop
          LV_1 := k.lv_01;
          LV_2 := k.lv_02;
          if LV_1 = LV_2 then
            delete from mgfacju
             where n_orden = 0
               and lv_01 = LV_1
               and lv_02 = LV_2;
          end if;
        end loop;
      
        --ORDENANDO DE NUEVO
        FOR W IN c_limpia LOOP
          LV_1 := W.lv_01;
          LV_2 := W.lv_02;
          IF LV_1 > LV_2 THEN
            LV_1 := W.lv_02;
            LV_2 := W.lv_01;
          end if;
          insert into mgfacju
            (lv_01, lv_02, n_orden)
          values
            (LV_1, LV_2, 2);
        end loop;
      
      when P_N_NUMFIR = 3 then
      
        for i in (select distinct A.N_CTABTT,
                                  b.c_codrel,
                                  b.pais,
                                  b.tdocum,
                                  b.ndoc
                    from BTCTAPRD A, AHDRECU b
                   WHERE C_INDPRO = 'A'
                     AND C_CODTCU = 1
                     and n_ctabtt = ln_ctabtt
                     and a.c_numcta = lc_numcta -- se agrego                                 
                     and a.c_tipper = 'J'
                     and a.c_numcta = b.c_numcta) loop
          for j in (select distinct A.N_CTABTT,
                                    b.c_codrel,
                                    b.pais,
                                    b.tdocum,
                                    b.ndoc
                      from BTCTAPRD A, AHDRECU b
                     WHERE C_INDPRO = 'A'
                       AND C_CODTCU = 1
                       and n_ctabtt = ln_ctabtt
                       and a.c_numcta = lc_numcta -- se agrego                                 
                       and a.c_tipper = 'J'
                       and a.c_numcta = b.c_numcta) loop
            for x in (select distinct A.N_CTABTT,
                                      b.c_codrel,
                                      b.pais,
                                      b.tdocum,
                                      b.ndoc
                        from BTCTAPRD A, AHDRECU b
                       WHERE C_INDPRO = 'A'
                         AND C_CODTCU = 1
                         and n_ctabtt = ln_ctabtt
                         and a.c_numcta = lc_numcta -- se agrego                                 
                         and a.c_tipper = 'J'
                         and a.c_numcta = b.c_numcta) loop
              insert into mgfacju
                (lv_01, lv_02, lv_03, n_orden)
              values
                (i.c_codrel, j.c_codrel, x.c_codrel, 0);
            end loop;
          end loop;
        end loop;
      
        -- ELIMINA CAMPOS IGUALES
        for k in c_limpia loop
          LV_1 := k.lv_01;
          LV_2 := k.lv_02;
          LV_3 := k.lv_03;
          if LV_1 = LV_2 or LV_1 = LV_3 or LV_2 = LV_3 then
            delete from mgfacju
             where n_orden = 0
               and lv_01 = LV_1
               and lv_02 = LV_2
               and lv_03 = LV_3;
          end if;
        end loop;
        t_combina.EXTEND(3);
        --ORDENANDO DE NUEVO
        FOR W IN c_limpia LOOP
          t_combina(1) := W.lv_01;
          t_combina(2) := W.lv_02;
          t_combina(3) := W.lv_03;
          for a in 1 .. 3 loop
            for b in 2 .. 3 loop
              if t_combina(a) > t_combina(b) then
                lv_tmp := t_combina(a);
                t_combina(a) := t_combina(b);
                t_combina(b) := lv_tmp;
              end if;
            end loop;
          end loop;
          LV_1 := t_combina(1);
          LV_2 := t_combina(2);
          LV_3 := t_combina(3);
          insert into mgfacju
            (lv_01, lv_02, lv_03, n_orden)
          values
            (LV_1, LV_2, lv_3, 3);
        END LOOP;
      when P_N_NUMFIR = 4 then
        for i in (select distinct A.N_CTABTT,
                                  b.c_codrel,
                                  b.pais,
                                  b.tdocum,
                                  b.ndoc
                    from BTCTAPRD A, AHDRECU b
                   WHERE C_INDPRO = 'A'
                     AND C_CODTCU = 1
                     and n_ctabtt = ln_ctabtt
                     and a.c_numcta = lc_numcta -- se agrego                                 
                     and a.c_tipper = 'J'
                     and a.c_numcta = b.c_numcta) loop
          for j in (select distinct A.N_CTABTT,
                                    b.c_codrel,
                                    b.pais,
                                    b.tdocum,
                                    b.ndoc
                      from BTCTAPRD A, AHDRECU b
                     WHERE C_INDPRO = 'A'
                       AND C_CODTCU = 1
                       and n_ctabtt = ln_ctabtt
                       and a.c_numcta = lc_numcta -- se agrego                                 
                       and a.c_tipper = 'J'
                       and a.c_numcta = b.c_numcta) loop
            for x in (select distinct A.N_CTABTT,
                                      b.c_codrel,
                                      b.pais,
                                      b.tdocum,
                                      b.ndoc
                        from BTCTAPRD A, AHDRECU b, mgmpers c
                       WHERE C_INDPRO = 'A'
                         AND C_CODTCU = 1
                         and n_ctabtt = ln_ctabtt
                         and a.c_numcta = lc_numcta -- se agrego                                 
                         and a.c_tipper = 'J'
                         and a.c_numcta = b.c_numcta) loop
              for y in (select distinct A.N_CTABTT,
                                        b.c_codrel,
                                        b.pais,
                                        b.tdocum,
                                        b.ndoc
                          from BTCTAPRD A, AHDRECU b
                         WHERE C_INDPRO = 'A'
                           AND C_CODTCU = 1
                           and n_ctabtt = ln_ctabtt
                           and a.c_numcta = lc_numcta -- se agrego                                 
                           and a.c_tipper = 'J'
                           and a.c_numcta = b.c_numcta) loop
                insert into mgfacju
                  (lv_01, lv_02, lv_03, lv_04, n_orden)
                values
                  (i.c_codrel, j.c_codrel, x.c_codrel, y.c_codrel, 0);
              end loop;
            end loop;
          end loop;
        end loop;
      
        -- ELIMINA CAMPOS IGUALES
        for k in c_limpia loop
          LV_1 := k.lv_01;
          LV_2 := k.lv_02;
          LV_3 := k.lv_03;
          LV_4 := k.lv_04;
          if LV_1 = LV_2 or LV_1 = LV_3 or LV_1 = LV_4 or LV_2 = LV_3 or
             LV_2 = LV_4 or LV_3 = LV_4 then
            delete from mgfacju
             where n_orden = 0
               and lv_01 = LV_1
               and lv_02 = LV_2
               and lv_03 = LV_3
               and lv_04 = LV_4;
          end if;
        end loop;
        t_combina.EXTEND(4);
        --ORDENANDO DE NUEVO
        FOR W IN c_limpia LOOP
          t_combina(1) := W.lv_01;
          t_combina(2) := W.lv_02;
          t_combina(3) := W.lv_03;
          t_combina(4) := W.lv_04;
          for a in 1 .. 4 loop
            for b in 2 .. 4 loop
              if t_combina(a) > t_combina(b) then
                lv_tmp := t_combina(a);
                t_combina(a) := t_combina(b);
                t_combina(b) := lv_tmp;
              end if;
            end loop;
          end loop;
          LV_1 := t_combina(1);
          LV_2 := t_combina(2);
          LV_3 := t_combina(3);
          LV_4 := t_combina(4);
          insert into mgfacju
            (lv_01, lv_02, lv_03, lv_04, n_orden)
          values
            (LV_1, LV_2, lv_3, lv_4, 4);
        END LOOP;
      
      when P_N_NUMFIR = 5 then
        for i in (select distinct A.N_CTABTT,
                                  b.c_codrel,
                                  b.pais,
                                  b.tdocum,
                                  b.ndoc
                    from BTCTAPRD A, AHDRECU b
                   WHERE C_INDPRO = 'A'
                     AND C_CODTCU = 1
                     and n_ctabtt = ln_ctabtt
                     and a.c_numcta = lc_numcta -- se agrego                                 
                     and a.c_tipper = 'J'
                     and a.c_numcta = b.c_numcta) loop
          for j in (select distinct A.N_CTABTT,
                                    b.c_codrel,
                                    b.pais,
                                    b.tdocum,
                                    b.ndoc
                      from BTCTAPRD A, AHDRECU b
                     WHERE C_INDPRO = 'A'
                       AND C_CODTCU = 1
                       and n_ctabtt = ln_ctabtt
                       and a.c_numcta = lc_numcta -- se agrego                                 
                       and a.c_tipper = 'J'
                       and a.c_numcta = b.c_numcta) loop
            for x in (select distinct A.N_CTABTT,
                                      b.c_codrel,
                                      b.pais,
                                      b.tdocum,
                                      b.ndoc
                        from BTCTAPRD A, AHDRECU b
                       WHERE C_INDPRO = 'A'
                         AND C_CODTCU = 1
                         and n_ctabtt = ln_ctabtt
                         and a.c_numcta = lc_numcta -- se agrego                                 
                         and a.c_tipper = 'J'
                         and a.c_numcta = b.c_numcta) loop
              for y in (select distinct A.N_CTABTT,
                                        b.c_codrel,
                                        b.pais,
                                        b.tdocum,
                                        b.ndoc
                          from BTCTAPRD A, AHDRECU b
                         WHERE C_INDPRO = 'A'
                           AND C_CODTCU = 1
                           and n_ctabtt = ln_ctabtt
                           and a.c_numcta = lc_numcta -- se agrego                                 
                           and a.c_tipper = 'J'
                           and a.c_numcta = b.c_numcta) loop
                for t in (select distinct A.N_CTABTT,
                                          b.c_codrel,
                                          b.pais,
                                          b.tdocum,
                                          b.ndoc
                            from BTCTAPRD A, AHDRECU b
                           WHERE C_INDPRO = 'A'
                             AND C_CODTCU = 1
                             and n_ctabtt = ln_ctabtt
                             and a.c_numcta = lc_numcta -- se agrego                                           
                             and a.c_tipper = 'J'
                             and a.c_numcta = b.c_numcta) loop
                  insert into mgfacju
                    (lv_01, lv_02, lv_03, lv_04, lv_05, n_orden)
                  values
                    (i.c_codrel,
                     j.c_codrel,
                     x.c_codrel,
                     y.c_codrel,
                     t.c_codrel,
                     0);
                end loop;
              end loop;
            end loop;
          end loop;
        end loop;
        -- ELIMINA CAMPOS IGUALES
        for k in c_limpia loop
          LV_1 := k.lv_01;
          LV_2 := k.lv_02;
          LV_3 := k.lv_03;
          LV_4 := k.lv_04;
          LV_5 := k.lv_05;
          if LV_1 = LV_2 or LV_1 = LV_3 or LV_1 = LV_4 or LV_1 = LV_5 or
             LV_2 = LV_3 or LV_2 = LV_4 or LV_2 = LV_5 or LV_3 = LV_4 or
             LV_3 = LV_5 or LV_4 = LV_5 then
            delete from mgfacju
             where n_orden = 0
               and lv_01 = LV_1
               and lv_02 = LV_2
               and lv_03 = LV_3
               and lv_04 = LV_4
               and lv_05 = LV_5;
          end if;
        end loop;
        t_combina.EXTEND(5);
        --ORDENANDO DE NUEVO
        FOR W IN c_limpia LOOP
          t_combina(1) := W.lv_01;
          t_combina(2) := W.lv_02;
          t_combina(3) := W.lv_03;
          t_combina(4) := W.lv_04;
          t_combina(5) := W.lv_05;
          for a in 1 .. 5 loop
            for b in 2 .. 5 loop
              if t_combina(a) > t_combina(b) then
                lv_tmp := t_combina(a);
                t_combina(a) := t_combina(b);
                t_combina(b) := lv_tmp;
              end if;
            end loop;
          end loop;
          LV_1 := t_combina(1);
          LV_2 := t_combina(2);
          LV_3 := t_combina(3);
          LV_4 := t_combina(4);
          LV_5 := t_combina(5);
          insert into mgfacju
            (lv_01, lv_02, lv_03, lv_04, lv_05, n_orden)
          values
            (LV_1, LV_2, lv_3, lv_4, lv_5, 5);
        END LOOP;
      
      when P_N_NUMFIR = 6 then
        ln_cant := 0;
        begin
          select n_numfio
            into ln_numfio
            from btctaprd
           where c_numcta = lc_numcta;
        end;
        if ln_numfio = P_N_NUMFIR then
          begin
            for n in c_caso_xxx loop
              ln_cant := ln_cant + 1;
              case
                when ln_cant = 1 then
                  LV_1 := n.c_codrel;
                when ln_cant = 2 then
                  LV_2 := n.c_codrel;
                when ln_cant = 3 then
                  LV_3 := n.c_codrel;
                when ln_cant = 4 then
                  LV_4 := n.c_codrel;
                when ln_cant = 5 then
                  LV_5 := n.c_codrel;
                when ln_cant = 6 then
                  LV_6 := n.c_codrel;
              end case;
            end loop;
            insert into mgfacju
              (lv_01, lv_02, lv_03, lv_04, lv_05, lv_06, n_orden)
            values
              (LV_1, LV_2, lv_3, lv_4, lv_5, lv_6, 6);
            insert into mgfacju
              (lv_01, lv_02, lv_03, lv_04, lv_05, lv_06, n_numfio)
            values
              (LV_1, LV_2, lv_3, lv_4, lv_5, lv_6, 6);
          end;
        else
          lc_error := 'NO MAPEADO: numero de firmas N_NUMFIR-N_NUMFIO ';
          --insertar a una tabla generica de excepciones (dato y la bandeja)
          insert into LOG_ERROR_BANDEJA
            (n_nro, c_codbdj, c_deserr, d_fecerr)
          values
            (-1, 'FACULT', P_N_NUMFIR || ' --: ' || lc_error, sysdate);
          commit;
        end if;
      when P_N_NUMFIR = 7 then
        ln_cant := 0;
        begin
          select n_numfio
            into ln_numfio
            from btctaprd
           where c_numcta = lc_numcta;
        end;
        if ln_numfio = P_N_NUMFIR then
          begin
            for n in c_caso_xxx loop
              ln_cant := ln_cant + 1;
              case
                when ln_cant = 1 then
                  LV_1 := n.c_codrel;
                when ln_cant = 2 then
                  LV_2 := n.c_codrel;
                when ln_cant = 3 then
                  LV_3 := n.c_codrel;
                when ln_cant = 4 then
                  LV_4 := n.c_codrel;
                when ln_cant = 5 then
                  LV_5 := n.c_codrel;
                when ln_cant = 6 then
                  LV_6 := n.c_codrel;
                when ln_cant = 7 then
                  LV_7 := n.c_codrel;
              end case;
            end loop;
            insert into mgfacju
              (lv_01, lv_02, lv_03, lv_04, lv_05, lv_06, lv_07, n_orden)
            values
              (LV_1, LV_2, lv_3, lv_4, lv_5, lv_6, lv_7, 7);
            insert into mgfacju
              (lv_01, lv_02, lv_03, lv_04, lv_05, lv_06, lv_07, n_numfio)
            values
              (LV_1, LV_2, lv_3, lv_4, lv_5, lv_6, lv_7, 7);
          
          end;
        else
          lc_error := 'NO MAPEADO: numero de firmas N_NUMFIR-N_NUMFIO ';
          --insertar a una tabla generica de excepciones (dato y la bandeja)
          insert into LOG_ERROR_BANDEJA
            (n_nro, c_codbdj, c_deserr, d_fecerr)
          values
            (-1, 'FACULT', P_N_NUMFIR || ' --: ' || lc_error, sysdate);
          commit;
        end if;
      
      else
        lc_error := 'NO MAPEADO: numero de firmas ';
        --insertar a una tabla generica de excepciones (dato y la bandeja)
        insert into LOG_ERROR_BANDEJA
          (n_nro, c_codbdj, c_deserr, d_fecerr)
        values
          (-1, 'FACULT', P_N_NUMFIR || ' --: ' || lc_error, sysdate);
        commit;
    end case;
  end sp_genera_grupos;

  ------------------------------------------------------------

  Procedure sp_genera_grupos_obli(P_N_CTABTT in number,
                                  P_N_NUMFIR in number,
                                  P_C_NUMCTA in varchar2) is
  
    t_combina T_VARCHAR2 := T_VARCHAR2();
    cursor c_limpia is
      select * from mgfacju where n_orden = 100;
    --and n_ini = P_N_INI;
  
    ln_ctabtt number;
    lc_numcta varchar2(17);
    LV_1      varchar2(10);
    LV_2      varchar2(10);
    LV_3      varchar2(10);
    LV_4      varchar2(10);
    LV_5      varchar2(10);
    --LV_6      varchar2(10); 
    --  LV_7      varchar2(10);   
    lv_tmp   varchar2(10);
    lc_error VARCHAR2(400);
  begin
  
    ln_ctabtt := P_N_CTABTT;
    lc_numcta := P_C_NUMCTA;
    case
      when P_N_NUMFIR = 0 then
        null;
      when P_N_NUMFIR = 1 then
      
        for i in (select distinct A.N_CTABTT,
                                  b.c_codrel,
                                  b.pais,
                                  b.tdocum,
                                  b.ndoc
                    from BTCTAPRD A, AHDRECU b
                   WHERE C_INDPRO = 'A'
                     AND C_CODTCU = 1
                     and n_ctabtt = ln_ctabtt
                     and a.c_numcta = lc_numcta -- se agrego
                     and a.c_tipper = 'J'
                     and b.c_tipfir = 'O'
                     and a.c_numcta = b.c_numcta) loop
          insert into mgfacju (lv_01, n_numfio) values (i.c_codrel, 1);
        end loop;
      when P_N_NUMFIR = 2 then
        for i in (select distinct A.N_CTABTT,
                                  b.c_codrel,
                                  b.pais,
                                  b.tdocum,
                                  b.ndoc
                    from BTCTAPRD A, AHDRECU b
                   WHERE C_INDPRO = 'A'
                     AND C_CODTCU = 1
                     and n_ctabtt = ln_ctabtt
                     and a.c_numcta = lc_numcta -- se agrego                                 
                     and a.c_tipper = 'J'
                     and b.c_tipfir = 'O'
                     and a.c_numcta = b.c_numcta) loop
          for j in (select distinct A.N_CTABTT,
                                    b.c_codrel,
                                    b.pais,
                                    b.tdocum,
                                    b.ndoc
                      from BTCTAPRD A, AHDRECU b
                     WHERE C_INDPRO = 'A'
                       AND C_CODTCU = 1
                       and n_ctabtt = ln_ctabtt
                       and a.c_numcta = lc_numcta -- se agrego                                 
                       and a.c_tipper = 'J'
                       and b.c_tipfir = 'O'
                       and a.c_numcta = b.c_numcta) loop
            insert into mgfacju
              (lv_01, lv_02, n_orden)
            values
              (i.c_codrel, j.c_codrel, 100);
          end loop;
        end loop;
      
        -- ELIMINA CAMPOS IGUALES
        for k in c_limpia loop
          LV_1 := k.lv_01;
          LV_2 := k.lv_02;
          if LV_1 = LV_2 then
            delete from mgfacju
             where n_orden = 100
               and lv_01 = LV_1
               and lv_02 = LV_2;
          end if;
        end loop;
      
        --ORDENANDO DE NUEVO
        FOR W IN c_limpia LOOP
          LV_1 := W.lv_01;
          LV_2 := W.lv_02;
          IF LV_1 > LV_2 THEN
            LV_1 := W.lv_02;
            LV_2 := W.lv_01;
          end if;
          insert into mgfacju
            (lv_01, lv_02, n_numfio)
          values
            (LV_1, LV_2, 2);
        end loop;
      
      when P_N_NUMFIR = 3 then
      
        for i in (select distinct A.N_CTABTT,
                                  b.c_codrel,
                                  b.pais,
                                  b.tdocum,
                                  b.ndoc
                    from BTCTAPRD A, AHDRECU b
                   WHERE C_INDPRO = 'A'
                     AND C_CODTCU = 1
                     and n_ctabtt = ln_ctabtt
                     and a.c_numcta = lc_numcta -- se agrego                                 
                     and a.c_tipper = 'J'
                     and b.c_tipfir = 'O'
                     and a.c_numcta = b.c_numcta) loop
          for j in (select distinct A.N_CTABTT,
                                    b.c_codrel,
                                    b.pais,
                                    b.tdocum,
                                    b.ndoc
                      from BTCTAPRD A, AHDRECU b
                     WHERE C_INDPRO = 'A'
                       AND C_CODTCU = 1
                       and n_ctabtt = ln_ctabtt
                       and a.c_numcta = lc_numcta -- se agrego                                 
                       and a.c_tipper = 'J'
                       and b.c_tipfir = 'O'
                       and a.c_numcta = b.c_numcta) loop
            for x in (select distinct A.N_CTABTT,
                                      b.c_codrel,
                                      b.pais,
                                      b.tdocum,
                                      b.ndoc
                        from BTCTAPRD A, AHDRECU b
                       WHERE C_INDPRO = 'A'
                         AND C_CODTCU = 1
                         and n_ctabtt = ln_ctabtt
                         and a.c_numcta = lc_numcta -- se agrego                                 
                         and a.c_tipper = 'J'
                         and b.c_tipfir = 'O'
                         and a.c_numcta = b.c_numcta) loop
              insert into mgfacju
                (lv_01, lv_02, lv_03, n_orden)
              values
                (i.c_codrel, j.c_codrel, x.c_codrel, 100);
            end loop;
          end loop;
        end loop;
      
        -- ELIMINA CAMPOS IGUALES
        for k in c_limpia loop
          LV_1 := k.lv_01;
          LV_2 := k.lv_02;
          LV_3 := k.lv_03;
          if LV_1 = LV_2 or LV_1 = LV_3 or LV_2 = LV_3 then
            delete from mgfacju
             where n_orden = 100
               and lv_01 = LV_1
               and lv_02 = LV_2
               and lv_03 = LV_3;
          end if;
        end loop;
        t_combina.EXTEND(3);
        --ORDENANDO DE NUEVO
        FOR W IN c_limpia LOOP
          t_combina(1) := W.lv_01;
          t_combina(2) := W.lv_02;
          t_combina(3) := W.lv_03;
          for a in 1 .. 3 loop
            for b in 2 .. 3 loop
              if t_combina(a) > t_combina(b) then
                lv_tmp := t_combina(a);
                t_combina(a) := t_combina(b);
                t_combina(b) := lv_tmp;
              end if;
            end loop;
          end loop;
          LV_1 := t_combina(1);
          LV_2 := t_combina(2);
          LV_3 := t_combina(3);
          insert into mgfacju
            (lv_01, lv_02, lv_03, n_numfio)
          values
            (LV_1, LV_2, lv_3, 3);
        END LOOP;
      when P_N_NUMFIR = 4 then
        for i in (select distinct A.N_CTABTT,
                                  b.c_codrel,
                                  b.pais,
                                  b.tdocum,
                                  b.ndoc
                    from BTCTAPRD A, AHDRECU b
                   WHERE C_INDPRO = 'A'
                     AND C_CODTCU = 1
                     and n_ctabtt = ln_ctabtt
                     and a.c_numcta = lc_numcta -- se agrego                                 
                     and a.c_tipper = 'J'
                     and b.c_tipfir = 'O'
                     and a.c_numcta = b.c_numcta) loop
          for j in (select distinct A.N_CTABTT,
                                    b.c_codrel,
                                    b.pais,
                                    b.tdocum,
                                    b.ndoc
                      from BTCTAPRD A, AHDRECU b
                     WHERE C_INDPRO = 'A'
                       AND C_CODTCU = 1
                       and n_ctabtt = ln_ctabtt
                       and a.c_numcta = lc_numcta -- se agrego                                 
                       and a.c_tipper = 'J'
                       and b.c_tipfir = 'O'
                       and a.c_numcta = b.c_numcta) loop
            for x in (select distinct A.N_CTABTT,
                                      b.c_codrel,
                                      b.pais,
                                      b.tdocum,
                                      b.ndoc
                        from BTCTAPRD A, AHDRECU b
                       WHERE C_INDPRO = 'A'
                         AND C_CODTCU = 1
                         and n_ctabtt = ln_ctabtt
                         and a.c_numcta = lc_numcta -- se agrego                                 
                         and a.c_tipper = 'J'
                         and b.c_tipfir = 'O'
                         and a.c_numcta = b.c_numcta) loop
              for y in (select distinct A.N_CTABTT,
                                        b.c_codrel,
                                        b.pais,
                                        b.tdocum,
                                        b.ndoc
                          from BTCTAPRD A, AHDRECU b
                         WHERE C_INDPRO = 'A'
                           AND C_CODTCU = 1
                           and n_ctabtt = ln_ctabtt
                           and a.c_numcta = lc_numcta -- se agrego                                 
                           and a.c_tipper = 'J'
                           and b.c_tipfir = 'O'
                           and a.c_numcta = b.c_numcta) loop
                insert into mgfacju
                  (lv_01, lv_02, lv_03, lv_04, n_orden)
                values
                  (i.c_codrel, j.c_codrel, x.c_codrel, y.c_codrel, 100);
              end loop;
            end loop;
          end loop;
        end loop;
      
        -- ELIMINA CAMPOS IGUALES
        for k in c_limpia loop
          LV_1 := k.lv_01;
          LV_2 := k.lv_02;
          LV_3 := k.lv_03;
          LV_4 := k.lv_04;
          if LV_1 = LV_2 or LV_1 = LV_3 or LV_1 = LV_4 or LV_2 = LV_3 or
             LV_2 = LV_4 or LV_3 = LV_4 then
            delete from mgfacju
             where n_orden = 100
               and lv_01 = LV_1
               and lv_02 = LV_2
               and lv_03 = LV_3
               and lv_04 = LV_4;
          end if;
        end loop;
        t_combina.EXTEND(4);
        --ORDENANDO DE NUEVO
        FOR W IN c_limpia LOOP
          t_combina(1) := W.lv_01;
          t_combina(2) := W.lv_02;
          t_combina(3) := W.lv_03;
          t_combina(4) := W.lv_04;
          for a in 1 .. 4 loop
            for b in 2 .. 4 loop
              if t_combina(a) > t_combina(b) then
                lv_tmp := t_combina(a);
                t_combina(a) := t_combina(b);
                t_combina(b) := lv_tmp;
              end if;
            end loop;
          end loop;
          LV_1 := t_combina(1);
          LV_2 := t_combina(2);
          LV_3 := t_combina(3);
          LV_4 := t_combina(4);
          insert into mgfacju
            (lv_01, lv_02, lv_03, lv_04, n_numfio)
          values
            (LV_1, LV_2, lv_3, lv_4, 4);
        END LOOP;
      
      when P_N_NUMFIR = 5 then
        for i in (select distinct A.N_CTABTT,
                                  b.c_codrel,
                                  b.pais,
                                  b.tdocum,
                                  b.ndoc
                    from BTCTAPRD A, AHDRECU b
                   WHERE C_INDPRO = 'A'
                     AND C_CODTCU = 1
                     and n_ctabtt = ln_ctabtt
                     and a.c_numcta = lc_numcta -- se agrego                                 
                     and a.c_tipper = 'J'
                     and b.c_tipfir = 'O'
                     and a.c_numcta = b.c_numcta) loop
          for j in (select distinct A.N_CTABTT,
                                    b.c_codrel,
                                    b.pais,
                                    b.tdocum,
                                    b.ndoc
                      from BTCTAPRD A, AHDRECU b
                     WHERE C_INDPRO = 'A'
                       AND C_CODTCU = 1
                       and n_ctabtt = ln_ctabtt
                       and a.c_numcta = lc_numcta -- se agrego                                 
                       and a.c_tipper = 'J'
                       and b.c_tipfir = 'O'
                       and a.c_numcta = b.c_numcta) loop
            for x in (select distinct A.N_CTABTT,
                                      b.c_codrel,
                                      b.pais,
                                      b.tdocum,
                                      b.ndoc
                        from BTCTAPRD A, AHDRECU b
                       WHERE C_INDPRO = 'A'
                         AND C_CODTCU = 1
                         and n_ctabtt = ln_ctabtt
                         and a.c_numcta = lc_numcta -- se agrego                                 
                         and a.c_tipper = 'J'
                         and b.c_tipfir = 'O'
                         and a.c_numcta = b.c_numcta) loop
              for y in (select distinct A.N_CTABTT,
                                        b.c_codrel,
                                        b.pais,
                                        b.tdocum,
                                        b.ndoc
                          from BTCTAPRD A, AHDRECU b
                         WHERE C_INDPRO = 'A'
                           AND C_CODTCU = 1
                           and n_ctabtt = ln_ctabtt
                           and a.c_numcta = lc_numcta -- se agrego                                 
                           and a.c_tipper = 'J'
                           and b.c_tipfir = 'O'
                           and a.c_numcta = b.c_numcta) loop
                for t in (select distinct A.N_CTABTT,
                                          b.c_codrel,
                                          b.pais,
                                          b.tdocum,
                                          b.ndoc
                            from BTCTAPRD A, AHDRECU b
                           WHERE C_INDPRO = 'A'
                             AND C_CODTCU = 1
                             and n_ctabtt = ln_ctabtt
                             and a.c_numcta = lc_numcta -- se agrego                                           
                             and a.c_tipper = 'J'
                             and b.c_tipfir = 'O'
                             and a.c_numcta = b.c_numcta) loop
                  insert into mgfacju
                    (lv_01, lv_02, lv_03, lv_04, lv_05, n_orden)
                  values
                    (i.c_codrel,
                     j.c_codrel,
                     x.c_codrel,
                     y.c_codrel,
                     t.c_codrel,
                     100);
                end loop;
              end loop;
            end loop;
          end loop;
        end loop;
        -- ELIMINA CAMPOS IGUALES
        for k in c_limpia loop
          LV_1 := k.lv_01;
          LV_2 := k.lv_02;
          LV_3 := k.lv_03;
          LV_4 := k.lv_04;
          LV_5 := k.lv_05;
          if LV_1 = LV_2 or LV_1 = LV_3 or LV_1 = LV_4 or LV_1 = LV_5 or
             LV_2 = LV_3 or LV_2 = LV_4 or LV_2 = LV_5 or LV_3 = LV_4 or
             LV_3 = LV_5 or LV_4 = LV_5 then
            delete from mgfacju
             where n_orden = 100
               and lv_01 = LV_1
               and lv_02 = LV_2
               and lv_03 = LV_3
               and lv_04 = LV_4
               and lv_05 = LV_5;
          end if;
        end loop;
        t_combina.EXTEND(5);
        --ORDENANDO DE NUEVO
        FOR W IN c_limpia LOOP
          t_combina(1) := W.lv_01;
          t_combina(2) := W.lv_02;
          t_combina(3) := W.lv_03;
          t_combina(4) := W.lv_04;
          t_combina(5) := W.lv_05;
          for a in 1 .. 5 loop
            for b in 2 .. 5 loop
              if t_combina(a) > t_combina(b) then
                lv_tmp := t_combina(a);
                t_combina(a) := t_combina(b);
                t_combina(b) := lv_tmp;
              end if;
            end loop;
          end loop;
          LV_1 := t_combina(1);
          LV_2 := t_combina(2);
          LV_3 := t_combina(3);
          LV_4 := t_combina(4);
          LV_5 := t_combina(5);
          insert into mgfacju
            (lv_01, lv_02, lv_03, lv_04, lv_05, n_numfio)
          values
            (LV_1, LV_2, lv_3, lv_4, lv_5, 5);
        END LOOP;
      when P_N_NUMFIR = 6 then
      
        null;
      when P_N_NUMFIR = 7 then
      
        null;
      else
        lc_error := 'NO MAPEADO: numero de firmas OBLIGATORIAS';
        --insertar a una tabla generica de excepciones (dato y la bandeja)
        insert into LOG_ERROR_BANDEJA
          (n_nro, c_codbdj, c_deserr, d_fecerr)
        values
          (-2, 'FAC-OBL', P_N_NUMFIR || ' --: ' || lc_error, sysdate);
        commit;
    end case;
  end sp_genera_grupos_obli;

  --------------------------------------------------------------------
  Procedure sp_asgina_facultades_BJR_una(P_C_FECPRO IN VARCHAR2,
                                         P_N_INI    IN NUMBER,
                                         CUENTA     IN NUMBER) is
  
    -- cursor para clientes con indistintas y mancomunos
    cursor cli_ind_man is
      select n_ctabtt,
             count(distinct case
                     when c_codtcu = '2' then
                      c_numcta
                     else
                      null
                   end) n_ctaind,
             count(distinct case
                     when c_codtcu = '3' then
                      c_numcta
                     else
                      null
                   end) n_ctaman
        from btctaprd a
       where c_indpro = 'A'
         and c_codtcu in (2, 3)
         and a.N_CTABTT = CUENTA
       group by a.n_ctabtt;
  
    cursor cli_ind_man_j is
      select n_ctabtt,
             count(distinct case
                     when c_codtcu = '2' then
                      c_numcta
                     else
                      null
                   end) n_ctaind,
             count(distinct case
                     when n_numfir >= 1 then
                      c_numcta
                     else
                      null
                   end) n_ctaman
        from btctaprd a
       where c_indpro = 'A'
         and c_tipper = 'J'
         and a.N_CTABTT = CUENTA
       group by a.n_ctabtt;
  
    -- cursor para datos de personas por cliente 
    cursor ctacli(ln_ctabtt in number) is
      select n_ctabtt, a.n_codpai, a.n_tipdoc, a.n_numdoc
        from btctaprd a
       where c_indpro = 'A'
         and a.n_ctabtt = ln_ctabtt
       group by n_ctabtt, a.n_codpai, a.n_tipdoc, a.n_numdoc;
  
    cursor ctacli_j(ln_ctabtt in number) is
      select n_ctabtt, b.pais n_codpai, b.tdocum n_tipdoc, b.ndoc n_numdoc
        from btctaprd a, ahdrecu b
       where a.c_numcta = b.c_numcta
         and a.c_indpro = 'A'
         and a.n_ctabtt = ln_ctabtt
       group by n_ctabtt, b.pais, b.tdocum, b.ndoc;
  
    cursor individ is
      select distinct 1, A.N_CTABTT, A.N_CODPAI, A.N_TIPDOC, A.N_NUMDOC
        from BTCTAPRD A
       WHERE C_INDPRO = 'A'
         AND C_CODTCU = 1
         and a.c_tipper = 'N'
         and a.N_CTABTT = CUENTA;
  
    cursor ctacliope(ln_ctabtt in number) is
      select n_ctabtt,
             a.c_numcta,
             a.n_sucurs,
             a.n_moneda,
             a.n_papel,
             a.n_operac,
             a.n_subope,
             a.n_modulo,
             a.n_totope
        from btctaprd a
       where c_indpro = 'A'
         and a.n_ctabtt = ln_ctabtt
       group by n_ctabtt,
                a.c_numcta,
                a.n_sucurs,
                a.n_moneda,
                a.n_papel,
                a.n_operac,
                a.n_subope,
                a.n_modulo,
                a.n_totope
       order by 2, 3, 7;
  
    ln_grup  number;
    ln_fac   number := 1;
    ld_fecha date := to_date(p_c_fecpro, 'rrrr.mm.dd');
  
    lc_error  varchar2(200);
    ln_ctabtt number;
    ln_contad number := 0;
    lc_msgerr varchar2(400);
  
    existebt char(1);
  
  begin
  
    update tab_jobs g
       set g.d_fecini = sysdate
     where g.n_numer1 = P_N_INI
       and g.c_codage = 'FAC';
    commit;
  
    -- INDIVIDUALES
  
    ln_grup := 1;
    for p in individ loop
    
      existebt := fn_existe_bt(p.N_CTABTT);
    
      If existebt = 'N' then
        begin
          insert into bandejas.bje130
            (BE130ECod,
             BE130NCta,
             BE130FCod,
             BE130GFac,
             BE130FDes,
             BE130LFac,
             BE130FVig,
             BE130LMnN,
             BE130Est)
          values
            (1,
             p.N_CTABTT,
             ln_fac,
             ln_grup,
             ld_fecha,
             999999999999,
             'S',
             999999999999,
             'P');
        exception
          when others then
            lc_error := sqlerrm;
            insert into LOG_ERROR_BANDEJA
              (n_nro, c_codbdj, c_deserr, d_fecerr)
            values
              (P_N_INI, 'bje130', lc_error, sysdate);
            commit;
        end;
        begin
          insert into bandejas.bjr130
            (BR130ECod,
             BR130NCta,
             BR130FCod,
             BR130RFac,
             BR130FDes,
             BR130Pais,
             BR130TDoc,
             BR130NDoc,
             BR130Est)
          values
            (1,
             p.N_CTABTT,
             ln_fac,
             ln_grup,
             ld_fecha,
             p.N_CODPAI,
             p.N_TIPDOC,
             p.N_NUMDOC,
             'P');
        exception
          when others then
            lc_error := sqlerrm;
            insert into LOG_ERROR_BANDEJA
              (n_nro, c_codbdj, c_deserr, d_fecerr)
            values
              (P_N_INI, 'bjr130', p.n_ctabtt || ' : ' || lc_error, sysdate);
            commit;
        end;
        ln_contad := ln_contad + 2;
      
        if ln_contad = 100 then
          commit;
          ln_contad := 0;
        end if;
      end if;
    end loop;
    commit;
  
    ---------------------------JURIDICAS-------------------------
  
    for i in cli_ind_man_j loop
    
      existebt := fn_existe_bt(i.n_ctabtt);
    
      ln_grup := 500;
    
      -- Cliente con indistinta unicamente
      for j in ctacli_j(i.n_ctabtt) loop
        -- recorremos las cuentas de ahorros del cliente 
        /*        ln_grup := ln_grup + 1;
        
        if ln_grup = 511 then
          ln_grup := ln_grup + 1;
        end if;*/
        If existebt = 'N' then
          begin
            insert into bandejas.bje130
              (be130ecod,
               be130ncta,
               be130fcod,
               be130gfac,
               be130fdes,
               be130lfac,
               be130fvig,
               be130lmnn,
               be130est)
            values
              (1,
               i.n_ctabtt,
               ln_fac,
               ln_grup,
               ld_fecha,
               999999999999,
               'S',
               999999999999,
               'P');
          exception
            when others then
              lc_error := sqlerrm;
              --insertar a una tabla generica de excepciones (dato y la bandeja)
              insert into LOG_ERROR_BANDEJA
                (n_nro, c_codbdj, c_deserr, d_fecerr)
              values
                (P_N_INI,
                 'bje130',
                 i.n_ctabtt || ' 0: ' || lc_error,
                 sysdate);
              commit;
          end;
          --
          begin
            insert into bandejas.bjr130
              (br130ecod,
               br130ncta,
               br130fcod,
               br130rfac,
               br130fdes,
               br130pais,
               br130tdoc,
               br130ndoc,
               br130est)
            values
              (1,
               i.n_ctabtt,
               ln_fac,
               ln_grup,
               ld_fecha,
               j.n_codpai,
               j.n_tipdoc,
               j.n_numdoc,
               'P');
          exception
            when others then
              lc_error := sqlerrm;
              --insertar a una tabla generica de excepciones (dato y la bandeja)
              insert into LOG_ERROR_BANDEJA
                (n_nro, c_codbdj, c_deserr, d_fecerr)
              values
                (P_N_INI,
                 'bjr130',
                 i.n_ctabtt || ' 1: ' || lc_error,
                 sysdate);
              commit;
          end;
        end if;
      
        for f in ctacliope(i.n_ctabtt) loop
          -- recorremos las cuentas de ahorros del cliente 
          begin
          
            -- operacion
            insert into bandejas.bjr011
              (BnjEmp,
               BnjCod,
               BnjR1suc,
               BnjR1mda,
               BNJR1COD,
               BNJR1MOD,
               BnjR1pap,
               BnjR1cta,
               BnjR1oper,
               BnjR1sbop,
               BnjR1tope,
               BnjRelcod,
               BnjR2mod,
               BnjR2cta,
               BnjR2oper,
               BnjR2sbop,
               BnjR1rub,
               BnjR2cod,
               BnjR2suc,
               BnjR2mda,
               BnjR2pap,
               BnjR2tope,
               BnjR2rub,
               BnjR011cd,
               BnjR011mo,
               BnjR011su,
               BnjR011tr,
               BnjR011re,
               BnjR011fc,
               BnjR011or,
               BnjR011sb,
               BnjR011co,
               BnjR011Est)
            values
              (1,
               1100,
               f.n_sucurs,
               f.n_moneda,
               1,
               f.n_modulo,
               f.n_papel,
               f.n_ctabtt,
               f.n_operac,
               f.n_subope,
               f.n_totope,
               5,
               ln_fac,
               f.n_ctabtt,
               to_number(to_char(ld_fecha, 'YYYYMMDD')),
               ln_grup,
               null,
               1,
               f.n_modulo,
               
               null,
               null,
               null,
               null,
               null,
               null,
               null,
               null,
               null,
               null,
               null,
               null,
               'S',
               'P');
          exception
            when others then
              lc_error := sqlerrm;
              --insertar a una tabla generica de excepciones (dato y la bandeja)
              insert into LOG_ERROR_BANDEJA
                (n_nro, c_codbdj, c_deserr, d_fecerr)
              values
                (P_N_INI,
                 'bjr011',
                 i.n_ctabtt || ' 2: ' || lc_error,
                 sysdate);
              commit;
          end;
        end loop;
      end loop;
      commit;
    end loop;
  
    ------------- INDISTINTAS Y MANCOMUNADAS PERSONAS NATURALES------------
  
    for i in cli_ind_man loop
    
      existebt := fn_existe_bt(i.n_ctabtt);
    
      ln_grup := 500;
      -- recorremos los clientes mancomunos e indistintos
      case
        when i.n_ctaind > 0 and i.n_ctaman = 0 then
          -- Cliente con indistinta unicamente
          for j in ctacli(i.n_ctabtt) loop
            -- recorremos las cuentas de ahorros del cliente 
            If existebt = 'N' then
            
              ln_grup := ln_grup + 1;
            
              if ln_grup = 500 then
                ln_grup := ln_grup + 1;
              end if;
            
              begin
                insert into bandejas.bje130
                  (be130ecod,
                   be130ncta,
                   be130fcod,
                   be130gfac,
                   be130fdes,
                   be130lfac,
                   be130fvig,
                   be130lmnn,
                   be130est)
                values
                  (1,
                   i.n_ctabtt,
                   ln_fac,
                   ln_grup,
                   ld_fecha,
                   999999999999,
                   'S',
                   999999999999,
                   'P');
              exception
                when others then
                  lc_error := sqlerrm;
                  --insertar a una tabla generica de excepciones (dato y la bandeja)
                  insert into LOG_ERROR_BANDEJA
                    (n_nro, c_codbdj, c_deserr, d_fecerr)
                  values
                    (P_N_INI,
                     'bje130',
                     i.n_ctabtt || ' 0: ' || lc_error,
                     sysdate);
                  commit;
              end;
              --
              begin
                insert into bandejas.bjr130
                  (br130ecod,
                   br130ncta,
                   br130fcod,
                   br130rfac,
                   br130fdes,
                   br130pais,
                   br130tdoc,
                   br130ndoc,
                   br130est)
                values
                  (1,
                   i.n_ctabtt,
                   ln_fac,
                   ln_grup,
                   ld_fecha,
                   j.n_codpai,
                   j.n_tipdoc,
                   j.n_numdoc,
                   'P');
              exception
                when others then
                  lc_error := sqlerrm;
                  --insertar a una tabla generica de excepciones (dato y la bandeja)
                  insert into LOG_ERROR_BANDEJA
                    (n_nro, c_codbdj, c_deserr, d_fecerr)
                  values
                    (P_N_INI,
                     'bjr130',
                     i.n_ctabtt || ' 1: ' || lc_error,
                     sysdate);
                  commit;
              end;
            end if;
          
            for f in ctacliope(i.n_ctabtt) loop
              -- recorremos las cuentas de ahorros del cliente 
              begin
              
                -- operacion
                insert into bandejas.bjr011
                  (BnjEmp,
                   BnjCod,
                   BnjR1suc,
                   BnjR1mda,
                   BNJR1COD,
                   BNJR1MOD,
                   BnjR1pap,
                   BnjR1cta,
                   BnjR1oper,
                   BnjR1sbop,
                   BnjR1tope,
                   BnjRelcod,
                   BnjR2mod,
                   BnjR2cta,
                   BnjR2oper,
                   BnjR2sbop,
                   BnjR1rub,
                   BnjR2cod,
                   BnjR2suc,
                   BnjR2mda,
                   BnjR2pap,
                   BnjR2tope,
                   BnjR2rub,
                   BnjR011cd,
                   BnjR011mo,
                   BnjR011su,
                   BnjR011tr,
                   BnjR011re,
                   BnjR011fc,
                   BnjR011or,
                   BnjR011sb,
                   BnjR011co,
                   BnjR011Est)
                values
                  (1,
                   1100,
                   f.n_sucurs,
                   f.n_moneda,
                   1,
                   f.n_modulo,
                   f.n_papel,
                   f.n_ctabtt,
                   f.n_operac,
                   f.n_subope,
                   f.n_totope,
                   5,
                   ln_fac,
                   f.n_ctabtt,
                   to_number(to_char(ld_fecha, 'YYYYMMDD')),
                   ln_grup,
                   null,
                   1,
                   f.n_modulo,
                   
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   'S',
                   'P');
              exception
                when others then
                  lc_error := sqlerrm;
                  --insertar a una tabla generica de excepciones (dato y la bandeja)
                  insert into LOG_ERROR_BANDEJA
                    (n_nro, c_codbdj, c_deserr, d_fecerr)
                  values
                    (P_N_INI,
                     'bjr011',
                     i.n_ctabtt || ' 2: ' || lc_error,
                     sysdate);
                  commit;
              end;
            end loop;
          end loop;
          commit;
        when i.n_ctaind = 0 and i.n_ctaman > 0 then
          -- Cliente con mancomunados unicamente
          ln_grup := 511;
          begin
            insert into bandejas.bje130
              (be130ecod,
               be130ncta,
               be130fcod,
               be130gfac,
               be130fdes,
               be130lfac,
               be130fvig,
               be130lmnn,
               be130est)
            values
              (1,
               i.n_ctabtt,
               ln_fac,
               ln_grup,
               ld_fecha,
               999999999999,
               'S',
               999999999999,
               'P');
          exception
            when others then
              lc_error := sqlerrm;
              --insertar a una tabla generica de excepciones (dato y la bandeja)
              insert into LOG_ERROR_BANDEJA
                (n_nro, c_codbdj, c_deserr, d_fecerr)
              values
                (P_N_INI,
                 'bje130',
                 i.n_ctabtt || ' 3: ' || lc_error,
                 sysdate);
              commit;
          end;
        
          for k in ctacli(i.n_ctabtt) loop
            --integrantes
            begin
              insert into bandejas.bjr130
                (br130ecod,
                 br130ncta,
                 br130fcod,
                 br130rfac,
                 br130fdes,
                 br130pais,
                 br130tdoc,
                 br130ndoc,
                 br130est)
              values
                (1,
                 i.n_ctabtt,
                 ln_fac,
                 ln_grup,
                 ld_fecha,
                 k.n_codpai,
                 k.n_tipdoc,
                 k.n_numdoc,
                 'P');
            exception
              when others then
                lc_error := sqlerrm;
                --insertar a una tabla generica de excepciones (dato y la bandeja)
                insert into LOG_ERROR_BANDEJA
                  (n_nro, c_codbdj, c_deserr, d_fecerr)
                values
                  (P_N_INI,
                   'bjr130',
                   i.n_ctabtt || ' 4: ' || lc_error,
                   sysdate);
                commit;
            end;
          end loop;
          commit;
          for f in ctacliope(i.n_ctabtt) loop
            -- recorremos las cuentas de ahorros del cliente 
            begin
            
              -- operacion
              insert into bandejas.bjr011
                (BnjEmp,
                 BnjCod,
                 BnjR1suc,
                 BnjR1mda,
                 BNJR1COD,
                 BNJR1MOD,
                 BnjR1pap,
                 BnjR1cta,
                 BnjR1oper,
                 BnjR1sbop,
                 BnjR1tope,
                 BnjRelcod,
                 BnjR2mod,
                 BnjR2cta,
                 BnjR2oper,
                 BnjR2sbop,
                 BnjR1rub,
                 BnjR2cod,
                 BnjR2suc,
                 BnjR2mda,
                 BnjR2pap,
                 BnjR2tope,
                 BnjR2rub,
                 BnjR011cd,
                 BnjR011mo,
                 BnjR011su,
                 BnjR011tr,
                 BnjR011re,
                 BnjR011fc,
                 BnjR011or,
                 BnjR011sb,
                 BnjR011co,
                 BnjR011Est)
              values
                (1,
                 1100,
                 f.n_sucurs,
                 f.n_moneda,
                 1,
                 f.n_modulo,
                 f.n_papel,
                 f.n_ctabtt,
                 f.n_operac,
                 f.n_subope,
                 f.n_totope,
                 5,
                 ln_fac,
                 f.n_ctabtt,
                 to_number(to_char(ld_fecha, 'YYYYMMDD')),
                 ln_grup,
                 null,
                 1,
                 f.n_modulo,
                 
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 'S',
                 'P');
            exception
              when others then
                lc_error := sqlerrm;
                --insertar a una tabla generica de excepciones (dato y la bandeja)
                insert into LOG_ERROR_BANDEJA
                  (n_nro, c_codbdj, c_deserr, d_fecerr)
                values
                  (P_N_INI,
                   'bjr011',
                   i.n_ctabtt || ' 5: ' || lc_error,
                   sysdate);
                commit;
            end;
          end loop;
          commit;
        else
          -- clientes con cuentas mixtas mancomunadas e indistintas
        
          ln_grup := 500;
          for j in ctacli(i.n_ctabtt) loop
            -- recorremos las cuentas de ahorros del cliente 
            ln_grup := ln_grup + 1;
          
            if ln_grup = 511 then
              ln_grup := ln_grup + 1;
            end if;
          
            begin
              insert into bandejas.bje130
                (be130ecod,
                 be130ncta,
                 be130fcod,
                 be130gfac,
                 be130fdes,
                 be130lfac,
                 be130fvig,
                 be130lmnn,
                 be130est)
              values
                (1,
                 i.n_ctabtt,
                 ln_fac,
                 ln_grup,
                 ld_fecha,
                 999999999999,
                 'S',
                 999999999999,
                 'P');
            exception
              when others then
                lc_error := sqlerrm;
                --insertar a una tabla generica de excepciones (dato y la bandeja)
                insert into LOG_ERROR_BANDEJA
                  (n_nro, c_codbdj, c_deserr, d_fecerr)
                values
                  (P_N_INI,
                   'bje130',
                   i.n_ctabtt || ' 6: ' || lc_error,
                   sysdate);
                commit;
            end;
            --
            begin
              insert into bandejas.bjr130
                (br130ecod,
                 br130ncta,
                 br130fcod,
                 br130rfac,
                 br130fdes,
                 br130pais,
                 br130tdoc,
                 br130ndoc,
                 br130est)
              values
                (1,
                 i.n_ctabtt,
                 ln_fac,
                 ln_grup,
                 ld_fecha,
                 j.n_codpai,
                 j.n_tipdoc,
                 j.n_numdoc,
                 'P');
            exception
              when others then
                lc_error := sqlerrm;
                --insertar a una tabla generica de excepciones (dato y la bandeja)
                insert into LOG_ERROR_BANDEJA
                  (n_nro, c_codbdj, c_deserr, d_fecerr)
                values
                  (P_N_INI,
                   'bjr130',
                   i.n_ctabtt || ' 7: ' || lc_error,
                   sysdate);
                commit;
            end;
            for f in ctacliope(i.n_ctabtt) loop
              -- recorremos las cuentas de ahorros del cliente 
              begin
              
                -- operacion
                insert into bandejas.bjr011
                  (BnjEmp,
                   BnjCod,
                   BnjR1suc,
                   BnjR1mda,
                   BNJR1COD,
                   BNJR1MOD,
                   BnjR1pap,
                   BnjR1cta,
                   BnjR1oper,
                   BnjR1sbop,
                   BnjR1tope,
                   BnjRelcod,
                   BnjR2mod,
                   BnjR2cta,
                   BnjR2oper,
                   BnjR2sbop,
                   BnjR1rub,
                   BnjR2cod,
                   BnjR2suc,
                   BnjR2mda,
                   BnjR2pap,
                   BnjR2tope,
                   BnjR2rub,
                   BnjR011cd,
                   BnjR011mo,
                   BnjR011su,
                   BnjR011tr,
                   BnjR011re,
                   BnjR011fc,
                   BnjR011or,
                   BnjR011sb,
                   BnjR011co,
                   BnjR011Est)
                values
                  (1,
                   1100,
                   f.n_sucurs,
                   f.n_moneda,
                   1,
                   f.n_modulo,
                   f.n_papel,
                   f.n_ctabtt,
                   f.n_operac,
                   f.n_subope,
                   f.n_totope,
                   5,
                   ln_fac,
                   f.n_ctabtt,
                   to_number(to_char(ld_fecha, 'YYYYMMDD')),
                   ln_grup,
                   null,
                   1,
                   f.n_modulo,
                   
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   'S',
                   'P');
              exception
                when others then
                  lc_error := sqlerrm;
                  --insertar a una tabla generica de excepciones (dato y la bandeja)
                  insert into LOG_ERROR_BANDEJA
                    (n_nro, c_codbdj, c_deserr, d_fecerr)
                  values
                    (P_N_INI,
                     'bjr011',
                     i.n_ctabtt || ' 8: ' || lc_error,
                     sysdate);
                  commit;
              end;
            end loop;
          end loop;
        
          ln_grup := 511;
          begin
            insert into bandejas.bje130
              (be130ecod,
               be130ncta,
               be130fcod,
               be130gfac,
               be130fdes,
               be130lfac,
               be130fvig,
               be130lmnn,
               be130est)
            values
              (1,
               i.n_ctabtt,
               ln_fac,
               ln_grup,
               ld_fecha,
               999999999999,
               'S',
               999999999999,
               'P');
          exception
            when others then
              lc_error := sqlerrm;
              --insertar a una tabla generica de excepciones (dato y la bandeja)
              insert into LOG_ERROR_BANDEJA
                (n_nro, c_codbdj, c_deserr, d_fecerr)
              values
                (P_N_INI,
                 'bje130',
                 i.n_ctabtt || ' 9: ' || lc_error,
                 sysdate);
              commit;
          end;
        
          for k in ctacli(i.n_ctabtt) loop
            --integrantes
            begin
              insert into bandejas.bjr130
                (br130ecod,
                 br130ncta,
                 br130fcod,
                 br130rfac,
                 br130fdes,
                 br130pais,
                 br130tdoc,
                 br130ndoc,
                 br130est)
              values
                (1,
                 i.n_ctabtt,
                 ln_fac,
                 ln_grup,
                 ld_fecha,
                 k.n_codpai,
                 k.n_tipdoc,
                 k.n_numdoc,
                 'P');
            exception
              when others then
                lc_error := sqlerrm;
                --insertar a una tabla generica de excepciones (dato y la bandeja)
                insert into LOG_ERROR_BANDEJA
                  (n_nro, c_codbdj, c_deserr, d_fecerr)
                values
                  (P_N_INI,
                   'bjr130',
                   i.n_ctabtt || ' 10: ' || lc_error,
                   sysdate);
                commit;
            end;
          end loop;
          for f in ctacliope(i.n_ctabtt) loop
            -- recorremos las cuentas de ahorros del cliente 
            begin
            
              -- operacion
              insert into bandejas.bjr011
                (BnjEmp,
                 BnjCod,
                 BnjR1suc,
                 BnjR1mda,
                 BNJR1COD,
                 BNJR1MOD,
                 BnjR1pap,
                 BnjR1cta,
                 BnjR1oper,
                 BnjR1sbop,
                 BnjR1tope,
                 BnjRelcod,
                 BnjR2mod,
                 BnjR2cta,
                 BnjR2oper,
                 BnjR2sbop,
                 BnjR1rub,
                 BnjR2cod,
                 BnjR2suc,
                 BnjR2mda,
                 BnjR2pap,
                 BnjR2tope,
                 BnjR2rub,
                 BnjR011cd,
                 BnjR011mo,
                 BnjR011su,
                 BnjR011tr,
                 BnjR011re,
                 BnjR011fc,
                 BnjR011or,
                 BnjR011sb,
                 BnjR011co,
                 BnjR011Est)
              values
                (1,
                 1100,
                 f.n_sucurs,
                 f.n_moneda,
                 1,
                 f.n_modulo,
                 f.n_papel,
                 f.n_ctabtt,
                 f.n_operac,
                 f.n_subope,
                 f.n_totope,
                 5,
                 ln_fac,
                 f.n_ctabtt,
                 to_number(to_char(ld_fecha, 'YYYYMMDD')),
                 ln_grup,
                 null,
                 1,
                 f.n_modulo,
                 
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 'S',
                 'P');
            exception
              when others then
                lc_error := sqlerrm;
                --insertar a una tabla generica de excepciones (dato y la bandeja)
                insert into LOG_ERROR_BANDEJA
                  (n_nro, c_codbdj, c_deserr, d_fecerr)
                values
                  (P_N_INI,
                   'bjr011',
                   i.n_ctabtt || ' 11: ' || lc_error,
                   sysdate);
                commit;
            end;
          end loop;
      end case;
      commit;
    end loop;
    commit;
  
    update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 = P_N_INI
       and g.c_codage = 'FAC';
    commit;
  EXCEPTION
    when others then
      lc_msgerr := sqlerrm;
      update tab_jobs g
         set g.c_inderr = 'S', g.c_deserr = lc_msgerr
       where g.n_numer1 = P_N_INI
         and g.c_codage = 'FAC';
      commit;
      return;
    
  end;

  -------------------------------------------------------------
  function fn_existe_bt(N_CTABTT in number) return char is
    existe char(1);
  
  begin
    existe := 'N';
    begin
      select 'S'
        into existe
        from FSE130
       where pgcod = 1
         and ctnro = N_CTABTT;
    exception
      when no_data_found then
        existe := 'N';
      when too_many_rows then
        existe := 'S';
    end;
  
    return(existe);
  end;

  -------------------------------------------------------------

  Procedure sp_asgina_facultades_BJR_todas(P_C_FECPRO IN VARCHAR2,
                                           P_N_INI    IN NUMBER) is
  
    -- cursor para clientes con indistintas y mancomunos
    cursor cli_ind_man is
      select n_ctabtt,
             count(distinct case
                     when c_codtcu = '2' then
                      c_numcta
                     else
                      null
                   end) n_ctaind,
             count(distinct case
                     when c_codtcu = '3' then
                      c_numcta
                     else
                      null
                   end) n_ctaman
        from btctaprd a
       where c_indpro = 'A'
         and c_codtcu in (2, 3)
       group by a.n_ctabtt;
  
    cursor cli_ind_man_j is
      select n_ctabtt,
             count(distinct case
                     when c_codtcu = '2' then
                      c_numcta
                     else
                      null
                   end) n_ctaind,
             count(distinct case
                     when n_numfir >= 1 then
                      c_numcta
                     else
                      null
                   end) n_ctaman
        from btctaprd a
       where c_indpro = 'A'
         and c_tipper = 'J'
       group by a.n_ctabtt;
  
    -- cursor para datos de personas por cliente 
    cursor ctacli(ln_ctabtt in number) is
      select n_ctabtt, a.n_codpai, a.n_tipdoc, a.n_numdoc
        from btctaprd a
       where c_indpro = 'A'
         and a.n_ctabtt = ln_ctabtt
       group by n_ctabtt, a.n_codpai, a.n_tipdoc, a.n_numdoc;
  
    cursor ctacli_j(ln_ctabtt in number) is
      select n_ctabtt, b.pais n_codpai, b.tdocum n_tipdoc, b.ndoc n_numdoc
        from btctaprd a, ahdrecu b
       where a.c_numcta = b.c_numcta
         and a.c_indpro = 'A'
         and a.n_ctabtt = ln_ctabtt
       group by n_ctabtt, b.pais, b.tdocum, b.ndoc;
  
    cursor individ is
      select distinct 1, A.N_CTABTT, A.N_CODPAI, A.N_TIPDOC, A.N_NUMDOC
        from BTCTAPRD A
       WHERE C_INDPRO = 'A'
         AND C_CODTCU = 1
         and a.c_tipper = 'N';
  
    cursor ctacliope(ln_ctabtt in number) is
      select n_ctabtt,
             a.c_numcta,
             a.n_sucurs,
             a.n_moneda,
             a.n_papel,
             a.n_operac,
             a.n_subope,
             a.n_modulo,
             a.n_totope
        from btctaprd a
       where c_indpro = 'A'
         and a.n_ctabtt = ln_ctabtt
       group by n_ctabtt,
                a.c_numcta,
                a.n_sucurs,
                a.n_moneda,
                a.n_papel,
                a.n_operac,
                a.n_subope,
                a.n_modulo,
                a.n_totope
       order by 2, 3, 7;
  
    ln_grup  number;
    ln_fac   number := 1;
    ld_fecha date := to_date(p_c_fecpro, 'rrrr.mm.dd');
  
    lc_error  varchar2(200);
    ln_ctabtt number;
    ln_contad number := 0;
    lc_msgerr varchar2(400);
  
    existebt char(1);
  
  begin
  
    update tab_jobs g
       set g.d_fecini = sysdate
     where g.n_numer1 = P_N_INI
       and g.c_codage = 'FAC';
    commit;
    
    -- INDIVIDUALES
  
    ln_grup := 1;
    for p in individ loop
    
      existebt := fn_existe_bt(p.N_CTABTT);
    
      If existebt = 'N' then
        begin
          insert into bandejas.bje130
            (BE130ECod,
             BE130NCta,
             BE130FCod,
             BE130GFac,
             BE130FDes,
             BE130LFac,
             BE130FVig,
             BE130LMnN,
             BE130Est)
          values
            (1,
             p.N_CTABTT,
             ln_fac,
             ln_grup,
             ld_fecha,
             999999999999,
             'S',
             999999999999,
             'P');
        exception
          when others then
            lc_error := sqlerrm;
            insert into LOG_ERROR_BANDEJA
              (n_nro, c_codbdj, c_deserr, d_fecerr)
            values
              (P_N_INI, 'bje130', lc_error, sysdate);
            commit;
        end;
        begin
          insert into bandejas.bjr130
            (BR130ECod,
             BR130NCta,
             BR130FCod,
             BR130RFac,
             BR130FDes,
             BR130Pais,
             BR130TDoc,
             BR130NDoc,
             BR130Est)
          values
            (1,
             p.N_CTABTT,
             ln_fac,
             ln_grup,
             ld_fecha,
             p.N_CODPAI,
             p.N_TIPDOC,
             p.N_NUMDOC,
             'P');
        exception
          when others then
            lc_error := sqlerrm;
            insert into LOG_ERROR_BANDEJA
              (n_nro, c_codbdj, c_deserr, d_fecerr)
            values
              (P_N_INI, 'bjr130', p.n_ctabtt || ' : ' || lc_error, sysdate);
            commit;
        end;
        ln_contad := ln_contad + 2;
      
        if ln_contad = 100 then
          commit;
          ln_contad := 0;
        end if;
      end if;
    end loop;
    commit;
  
    ---------------------------JURIDICAS-------------------------
  
    for i in cli_ind_man_j loop
    
      existebt := fn_existe_bt(i.n_ctabtt);
    
      ln_grup := 500;
    
      -- Cliente con indistinta unicamente
      for j in ctacli_j(i.n_ctabtt) loop
        -- recorremos las cuentas de ahorros del cliente 
        /*        ln_grup := ln_grup + 1;
        
        if ln_grup = 511 then
          ln_grup := ln_grup + 1;
        end if;*/
        If existebt = 'N' then
          begin
            insert into bandejas.bje130
              (be130ecod,
               be130ncta,
               be130fcod,
               be130gfac,
               be130fdes,
               be130lfac,
               be130fvig,
               be130lmnn,
               be130est)
            values
              (1,
               i.n_ctabtt,
               ln_fac,
               ln_grup,
               ld_fecha,
               999999999999,
               'S',
               999999999999,
               'P');
          exception
            when others then
              lc_error := sqlerrm;
              --insertar a una tabla generica de excepciones (dato y la bandeja)
              insert into LOG_ERROR_BANDEJA
                (n_nro, c_codbdj, c_deserr, d_fecerr)
              values
                (P_N_INI,
                 'bje130',
                 i.n_ctabtt || ' 0: ' || lc_error,
                 sysdate);
              commit;
          end;
          --
          begin
            insert into bandejas.bjr130
              (br130ecod,
               br130ncta,
               br130fcod,
               br130rfac,
               br130fdes,
               br130pais,
               br130tdoc,
               br130ndoc,
               br130est)
            values
              (1,
               i.n_ctabtt,
               ln_fac,
               ln_grup,
               ld_fecha,
               j.n_codpai,
               j.n_tipdoc,
               j.n_numdoc,
               'P');
          exception
            when others then
              lc_error := sqlerrm;
              --insertar a una tabla generica de excepciones (dato y la bandeja)
              insert into LOG_ERROR_BANDEJA
                (n_nro, c_codbdj, c_deserr, d_fecerr)
              values
                (P_N_INI,
                 'bjr130',
                 i.n_ctabtt || ' 1: ' || lc_error,
                 sysdate);
              commit;
          end;
        end if;
      
        for f in ctacliope(i.n_ctabtt) loop
          -- recorremos las cuentas de ahorros del cliente 
          begin
          
            -- operacion
            insert into bandejas.bjr011
              (BnjEmp,
               BnjCod,
               BnjR1suc,
               BnjR1mda,
               BNJR1COD,
               BNJR1MOD,
               BnjR1pap,
               BnjR1cta,
               BnjR1oper,
               BnjR1sbop,
               BnjR1tope,
               BnjRelcod,
               BnjR2mod,
               BnjR2cta,
               BnjR2oper,
               BnjR2sbop,
               BnjR1rub,
               BnjR2cod,
               BnjR2suc,
               BnjR2mda,
               BnjR2pap,
               BnjR2tope,
               BnjR2rub,
               BnjR011cd,
               BnjR011mo,
               BnjR011su,
               BnjR011tr,
               BnjR011re,
               BnjR011fc,
               BnjR011or,
               BnjR011sb,
               BnjR011co,
               BnjR011Est)
            values
              (1,
               1100,
               f.n_sucurs,
               f.n_moneda,
               1,
               f.n_modulo,
               f.n_papel,
               f.n_ctabtt,
               f.n_operac,
               f.n_subope,
               f.n_totope,
               5,
               ln_fac,
               f.n_ctabtt,
               to_number(to_char(ld_fecha, 'YYYYMMDD')),
               ln_grup,
               null,
               1,
               f.n_modulo,
               
               null,
               null,
               null,
               null,
               null,
               null,
               null,
               null,
               null,
               null,
               null,
               null,
               'S',
               'P');
          exception
            when others then
              lc_error := sqlerrm;
              --insertar a una tabla generica de excepciones (dato y la bandeja)
              insert into LOG_ERROR_BANDEJA
                (n_nro, c_codbdj, c_deserr, d_fecerr)
              values
                (P_N_INI,
                 'bjr011',
                 i.n_ctabtt || ' 2: ' || lc_error,
                 sysdate);
              commit;
          end;
        end loop;
      end loop;
      commit;
    end loop;
  
    ------------- INDISTINTAS Y MANCOMUNADAS PERSONAS NATURALES------------
  
    for i in cli_ind_man loop
    
      existebt := fn_existe_bt(i.n_ctabtt);
    
      ln_grup := 500;
      -- recorremos los clientes mancomunos e indistintos
      case
        when i.n_ctaind > 0 and i.n_ctaman = 0 then
          -- Cliente con indistinta unicamente
          for j in ctacli(i.n_ctabtt) loop
            -- recorremos las cuentas de ahorros del cliente 
            If existebt = 'N' then
            
              ln_grup := ln_grup + 1;
            
              if ln_grup = 500 then
                ln_grup := ln_grup + 1;
              end if;
            
              begin
                insert into bandejas.bje130
                  (be130ecod,
                   be130ncta,
                   be130fcod,
                   be130gfac,
                   be130fdes,
                   be130lfac,
                   be130fvig,
                   be130lmnn,
                   be130est)
                values
                  (1,
                   i.n_ctabtt,
                   ln_fac,
                   ln_grup,
                   ld_fecha,
                   999999999999,
                   'S',
                   999999999999,
                   'P');
              exception
                when others then
                  lc_error := sqlerrm;
                  --insertar a una tabla generica de excepciones (dato y la bandeja)
                  insert into LOG_ERROR_BANDEJA
                    (n_nro, c_codbdj, c_deserr, d_fecerr)
                  values
                    (P_N_INI,
                     'bje130',
                     i.n_ctabtt || ' 0: ' || lc_error,
                     sysdate);
                  commit;
              end;
              --
              begin
                insert into bandejas.bjr130
                  (br130ecod,
                   br130ncta,
                   br130fcod,
                   br130rfac,
                   br130fdes,
                   br130pais,
                   br130tdoc,
                   br130ndoc,
                   br130est)
                values
                  (1,
                   i.n_ctabtt,
                   ln_fac,
                   ln_grup,
                   ld_fecha,
                   j.n_codpai,
                   j.n_tipdoc,
                   j.n_numdoc,
                   'P');
              exception
                when others then
                  lc_error := sqlerrm;
                  --insertar a una tabla generica de excepciones (dato y la bandeja)
                  insert into LOG_ERROR_BANDEJA
                    (n_nro, c_codbdj, c_deserr, d_fecerr)
                  values
                    (P_N_INI,
                     'bjr130',
                     i.n_ctabtt || ' 1: ' || lc_error,
                     sysdate);
                  commit;
              end;
            end if;
          
            for f in ctacliope(i.n_ctabtt) loop
              -- recorremos las cuentas de ahorros del cliente 
              begin
              
                -- operacion
                insert into bandejas.bjr011
                  (BnjEmp,
                   BnjCod,
                   BnjR1suc,
                   BnjR1mda,
                   BNJR1COD,
                   BNJR1MOD,
                   BnjR1pap,
                   BnjR1cta,
                   BnjR1oper,
                   BnjR1sbop,
                   BnjR1tope,
                   BnjRelcod,
                   BnjR2mod,
                   BnjR2cta,
                   BnjR2oper,
                   BnjR2sbop,
                   BnjR1rub,
                   BnjR2cod,
                   BnjR2suc,
                   BnjR2mda,
                   BnjR2pap,
                   BnjR2tope,
                   BnjR2rub,
                   BnjR011cd,
                   BnjR011mo,
                   BnjR011su,
                   BnjR011tr,
                   BnjR011re,
                   BnjR011fc,
                   BnjR011or,
                   BnjR011sb,
                   BnjR011co,
                   BnjR011Est)
                values
                  (1,
                   1100,
                   f.n_sucurs,
                   f.n_moneda,
                   1,
                   f.n_modulo,
                   f.n_papel,
                   f.n_ctabtt,
                   f.n_operac,
                   f.n_subope,
                   f.n_totope,
                   5,
                   ln_fac,
                   f.n_ctabtt,
                   to_number(to_char(ld_fecha, 'YYYYMMDD')),
                   ln_grup,
                   null,
                   1,
                   f.n_modulo,
                   
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   'S',
                   'P');
              exception
                when others then
                  lc_error := sqlerrm;
                  --insertar a una tabla generica de excepciones (dato y la bandeja)
                  insert into LOG_ERROR_BANDEJA
                    (n_nro, c_codbdj, c_deserr, d_fecerr)
                  values
                    (P_N_INI,
                     'bjr011',
                     i.n_ctabtt || ' 2: ' || lc_error,
                     sysdate);
                  commit;
              end;
            end loop;
          end loop;
          commit;
        when i.n_ctaind = 0 and i.n_ctaman > 0 then
          -- Cliente con mancomunados unicamente
          ln_grup := 511;
          begin
            insert into bandejas.bje130
              (be130ecod,
               be130ncta,
               be130fcod,
               be130gfac,
               be130fdes,
               be130lfac,
               be130fvig,
               be130lmnn,
               be130est)
            values
              (1,
               i.n_ctabtt,
               ln_fac,
               ln_grup,
               ld_fecha,
               999999999999,
               'S',
               999999999999,
               'P');
          exception
            when others then
              lc_error := sqlerrm;
              --insertar a una tabla generica de excepciones (dato y la bandeja)
              insert into LOG_ERROR_BANDEJA
                (n_nro, c_codbdj, c_deserr, d_fecerr)
              values
                (P_N_INI,
                 'bje130',
                 i.n_ctabtt || ' 3: ' || lc_error,
                 sysdate);
              commit;
          end;
        
          for k in ctacli(i.n_ctabtt) loop
            --integrantes
            begin
              insert into bandejas.bjr130
                (br130ecod,
                 br130ncta,
                 br130fcod,
                 br130rfac,
                 br130fdes,
                 br130pais,
                 br130tdoc,
                 br130ndoc,
                 br130est)
              values
                (1,
                 i.n_ctabtt,
                 ln_fac,
                 ln_grup,
                 ld_fecha,
                 k.n_codpai,
                 k.n_tipdoc,
                 k.n_numdoc,
                 'P');
            exception
              when others then
                lc_error := sqlerrm;
                --insertar a una tabla generica de excepciones (dato y la bandeja)
                insert into LOG_ERROR_BANDEJA
                  (n_nro, c_codbdj, c_deserr, d_fecerr)
                values
                  (P_N_INI,
                   'bjr130',
                   i.n_ctabtt || ' 4: ' || lc_error,
                   sysdate);
                commit;
            end;
          end loop;
          commit;
          for f in ctacliope(i.n_ctabtt) loop
            -- recorremos las cuentas de ahorros del cliente 
            begin
            
              -- operacion
              insert into bandejas.bjr011
                (BnjEmp,
                 BnjCod,
                 BnjR1suc,
                 BnjR1mda,
                 BNJR1COD,
                 BNJR1MOD,
                 BnjR1pap,
                 BnjR1cta,
                 BnjR1oper,
                 BnjR1sbop,
                 BnjR1tope,
                 BnjRelcod,
                 BnjR2mod,
                 BnjR2cta,
                 BnjR2oper,
                 BnjR2sbop,
                 BnjR1rub,
                 BnjR2cod,
                 BnjR2suc,
                 BnjR2mda,
                 BnjR2pap,
                 BnjR2tope,
                 BnjR2rub,
                 BnjR011cd,
                 BnjR011mo,
                 BnjR011su,
                 BnjR011tr,
                 BnjR011re,
                 BnjR011fc,
                 BnjR011or,
                 BnjR011sb,
                 BnjR011co,
                 BnjR011Est)
              values
                (1,
                 1100,
                 f.n_sucurs,
                 f.n_moneda,
                 1,
                 f.n_modulo,
                 f.n_papel,
                 f.n_ctabtt,
                 f.n_operac,
                 f.n_subope,
                 f.n_totope,
                 5,
                 ln_fac,
                 f.n_ctabtt,
                 to_number(to_char(ld_fecha, 'YYYYMMDD')),
                 ln_grup,
                 null,
                 1,
                 f.n_modulo,
                 
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 'S',
                 'P');
            exception
              when others then
                lc_error := sqlerrm;
                --insertar a una tabla generica de excepciones (dato y la bandeja)
                insert into LOG_ERROR_BANDEJA
                  (n_nro, c_codbdj, c_deserr, d_fecerr)
                values
                  (P_N_INI,
                   'bjr011',
                   i.n_ctabtt || ' 5: ' || lc_error,
                   sysdate);
                commit;
            end;
          end loop;
          commit;
        else
          -- clientes con cuentas mixtas mancomunadas e indistintas
        
          ln_grup := 500;
          for j in ctacli(i.n_ctabtt) loop
            -- recorremos las cuentas de ahorros del cliente 
            ln_grup := ln_grup + 1;
          
            if ln_grup = 511 then
              ln_grup := ln_grup + 1;
            end if;
          
            begin
              insert into bandejas.bje130
                (be130ecod,
                 be130ncta,
                 be130fcod,
                 be130gfac,
                 be130fdes,
                 be130lfac,
                 be130fvig,
                 be130lmnn,
                 be130est)
              values
                (1,
                 i.n_ctabtt,
                 ln_fac,
                 ln_grup,
                 ld_fecha,
                 999999999999,
                 'S',
                 999999999999,
                 'P');
            exception
              when others then
                lc_error := sqlerrm;
                --insertar a una tabla generica de excepciones (dato y la bandeja)
                insert into LOG_ERROR_BANDEJA
                  (n_nro, c_codbdj, c_deserr, d_fecerr)
                values
                  (P_N_INI,
                   'bje130',
                   i.n_ctabtt || ' 6: ' || lc_error,
                   sysdate);
                commit;
            end;
            --
            begin
              insert into bandejas.bjr130
                (br130ecod,
                 br130ncta,
                 br130fcod,
                 br130rfac,
                 br130fdes,
                 br130pais,
                 br130tdoc,
                 br130ndoc,
                 br130est)
              values
                (1,
                 i.n_ctabtt,
                 ln_fac,
                 ln_grup,
                 ld_fecha,
                 j.n_codpai,
                 j.n_tipdoc,
                 j.n_numdoc,
                 'P');
            exception
              when others then
                lc_error := sqlerrm;
                --insertar a una tabla generica de excepciones (dato y la bandeja)
                insert into LOG_ERROR_BANDEJA
                  (n_nro, c_codbdj, c_deserr, d_fecerr)
                values
                  (P_N_INI,
                   'bjr130',
                   i.n_ctabtt || ' 7: ' || lc_error,
                   sysdate);
                commit;
            end;
            for f in ctacliope(i.n_ctabtt) loop
              -- recorremos las cuentas de ahorros del cliente 
              begin
              
                -- operacion
                insert into bandejas.bjr011
                  (BnjEmp,
                   BnjCod,
                   BnjR1suc,
                   BnjR1mda,
                   BNJR1COD,
                   BNJR1MOD,
                   BnjR1pap,
                   BnjR1cta,
                   BnjR1oper,
                   BnjR1sbop,
                   BnjR1tope,
                   BnjRelcod,
                   BnjR2mod,
                   BnjR2cta,
                   BnjR2oper,
                   BnjR2sbop,
                   BnjR1rub,
                   BnjR2cod,
                   BnjR2suc,
                   BnjR2mda,
                   BnjR2pap,
                   BnjR2tope,
                   BnjR2rub,
                   BnjR011cd,
                   BnjR011mo,
                   BnjR011su,
                   BnjR011tr,
                   BnjR011re,
                   BnjR011fc,
                   BnjR011or,
                   BnjR011sb,
                   BnjR011co,
                   BnjR011Est)
                values
                  (1,
                   1100,
                   f.n_sucurs,
                   f.n_moneda,
                   1,
                   f.n_modulo,
                   f.n_papel,
                   f.n_ctabtt,
                   f.n_operac,
                   f.n_subope,
                   f.n_totope,
                   5,
                   ln_fac,
                   f.n_ctabtt,
                   to_number(to_char(ld_fecha, 'YYYYMMDD')),
                   ln_grup,
                   null,
                   1,
                   f.n_modulo,
                   
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   'S',
                   'P');
              exception
                when others then
                  lc_error := sqlerrm;
                  --insertar a una tabla generica de excepciones (dato y la bandeja)
                  insert into LOG_ERROR_BANDEJA
                    (n_nro, c_codbdj, c_deserr, d_fecerr)
                  values
                    (P_N_INI,
                     'bjr011',
                     i.n_ctabtt || ' 8: ' || lc_error,
                     sysdate);
                  commit;
              end;
            end loop;
          end loop;
        
          ln_grup := 511;
          begin
            insert into bandejas.bje130
              (be130ecod,
               be130ncta,
               be130fcod,
               be130gfac,
               be130fdes,
               be130lfac,
               be130fvig,
               be130lmnn,
               be130est)
            values
              (1,
               i.n_ctabtt,
               ln_fac,
               ln_grup,
               ld_fecha,
               999999999999,
               'S',
               999999999999,
               'P');
          exception
            when others then
              lc_error := sqlerrm;
              --insertar a una tabla generica de excepciones (dato y la bandeja)
              insert into LOG_ERROR_BANDEJA
                (n_nro, c_codbdj, c_deserr, d_fecerr)
              values
                (P_N_INI,
                 'bje130',
                 i.n_ctabtt || ' 9: ' || lc_error,
                 sysdate);
              commit;
          end;
        
          for k in ctacli(i.n_ctabtt) loop
            --integrantes
            begin
              insert into bandejas.bjr130
                (br130ecod,
                 br130ncta,
                 br130fcod,
                 br130rfac,
                 br130fdes,
                 br130pais,
                 br130tdoc,
                 br130ndoc,
                 br130est)
              values
                (1,
                 i.n_ctabtt,
                 ln_fac,
                 ln_grup,
                 ld_fecha,
                 k.n_codpai,
                 k.n_tipdoc,
                 k.n_numdoc,
                 'P');
            exception
              when others then
                lc_error := sqlerrm;
                --insertar a una tabla generica de excepciones (dato y la bandeja)
                insert into LOG_ERROR_BANDEJA
                  (n_nro, c_codbdj, c_deserr, d_fecerr)
                values
                  (P_N_INI,
                   'bjr130',
                   i.n_ctabtt || ' 10: ' || lc_error,
                   sysdate);
                commit;
            end;
          end loop;
          for f in ctacliope(i.n_ctabtt) loop
            -- recorremos las cuentas de ahorros del cliente 
            begin
            
              -- operacion
              insert into bandejas.bjr011
                (BnjEmp,
                 BnjCod,
                 BnjR1suc,
                 BnjR1mda,
                 BNJR1COD,
                 BNJR1MOD,
                 BnjR1pap,
                 BnjR1cta,
                 BnjR1oper,
                 BnjR1sbop,
                 BnjR1tope,
                 BnjRelcod,
                 BnjR2mod,
                 BnjR2cta,
                 BnjR2oper,
                 BnjR2sbop,
                 BnjR1rub,
                 BnjR2cod,
                 BnjR2suc,
                 BnjR2mda,
                 BnjR2pap,
                 BnjR2tope,
                 BnjR2rub,
                 BnjR011cd,
                 BnjR011mo,
                 BnjR011su,
                 BnjR011tr,
                 BnjR011re,
                 BnjR011fc,
                 BnjR011or,
                 BnjR011sb,
                 BnjR011co,
                 BnjR011Est)
              values
                (1,
                 1100,
                 f.n_sucurs,
                 f.n_moneda,
                 1,
                 f.n_modulo,
                 f.n_papel,
                 f.n_ctabtt,
                 f.n_operac,
                 f.n_subope,
                 f.n_totope,
                 5,
                 ln_fac,
                 f.n_ctabtt,
                 to_number(to_char(ld_fecha, 'YYYYMMDD')),
                 ln_grup,
                 null,
                 1,
                 f.n_modulo,
                 
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 'S',
                 'P');
            exception
              when others then
                lc_error := sqlerrm;
                --insertar a una tabla generica de excepciones (dato y la bandeja)
                insert into LOG_ERROR_BANDEJA
                  (n_nro, c_codbdj, c_deserr, d_fecerr)
                values
                  (P_N_INI,
                   'bjr011',
                   i.n_ctabtt || ' 11: ' || lc_error,
                   sysdate);
                commit;
            end;
          end loop;
      end case;
      commit;
    end loop;
    commit;
  
    update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 = P_N_INI
       and g.c_codage = 'FAC';
    commit;
  EXCEPTION
    when others then
      lc_msgerr := sqlerrm;
      update tab_jobs g
         set g.c_inderr = 'S', g.c_deserr = lc_msgerr
       where g.n_numer1 = P_N_INI
         and g.c_codage = 'FAC';
      commit;
      return;
    
  end;
  Procedure sp_bandeja_ahdrecu is
    lc_error VARCHAR2(400);
  begin    
    insert /*+append */  into ahdrecu
    select * from ahdrecu@credinka; --bandejas.BJR011_TMP;        
  commit;      
  Exception
  when others then 
  lc_error := sqlerrm;
    --insertar a una tabla generica de excepciones (dato y la bandeja)
    insert into LOG_ERROR_BANDEJA
      (n_nro,c_codbdj,c_deserr,d_fecerr)
    values
      (999,'ahdrecu',lc_error,sysdate);
    commit;     
  end sp_bandeja_ahdrecu;     
  Procedure sp_bandeja_fsd313 is
    lc_error VARCHAR2(400);
  begin    
    insert /*+append */  into fsd313 (PGCOD,DVMOD,DVMDA,DVPAP,DVCTA,DVSUC,
                     DVOPER,DVSBOP,DVTOPE,DVTINT,DVFULTDEV,DVRUBDEV,DVIMPAX1)

    select PGCOD,DVMOD,DVMDA,DVPAP,DVCTA,DVSUC,
           DVOPER,DVSBOP,DVTOPE,DVTINT,DVFULTDEV,DVRUBDEV,DVIMPAX1 
      from fsd313@credinka;       
  commit;      
  Exception
  when others then 
  lc_error := sqlerrm;
    --insertar a una tabla generica de excepciones (dato y la bandeja)
    insert into LOG_ERROR_BANDEJA
      (n_nro,c_codbdj,c_deserr,d_fecerr)
    values
      (999,'fsd313',lc_error,sysdate);
    commit;     
  end sp_bandeja_fsd313;     
  
end pq_migra_facultades;
/
