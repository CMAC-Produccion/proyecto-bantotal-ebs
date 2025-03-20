create or replace package PQ_CL_VOLCADO_CAMPANA is

  -- Author  : YLOZADA
  -- Created : 10/02/2014 11:52:18 a.m.
  -- Purpose : 

  Procedure sp_genera_scheduler(p_c_coderr out varchar2);
  Procedure sp_cl_volcado_job(P_C_DIGITO1 IN VARCHAR2,
                              P_C_DIGITO2 IN VARCHAR2,
                              ln_ini      in number);
  Procedure sp_valida_telefono(P_C_NUMTEL IN VARCHAR2,
                               P_N_TIPCEL IN NUMBER,
                               P_C_ERROR  OUT VARCHAR2);

  Procedure sp_valida_mail(P_C_MAIL IN VARCHAR2, P_C_ERROR OUT VARCHAR2);
  Procedure sp_llena_jaql467;

end PQ_CL_VOLCADO_CAMPANA;
/

create or replace package body PQ_CL_VOLCADO_CAMPANA is

  procedure sp_genera_scheduler(p_c_coderr out varchar2) is
    lc_coderr varchar2(2000);
  
    cursor c_job is
    
      SELECT /*+PARALLEL(T,4)*/
       SUBSTR(trim(JAQL466NDO), -1, 1) C_DIGITO1,
       SUBSTR(trim(JAQL466NDO), -2, 1) C_DIGITO2
        FROM JAQL466 T
      -- where JAQL466NDO = '41097320'
       GROUP BY SUBSTR(trim(JAQL466NDO), -1, 1),
                SUBSTR(trim(JAQL466NDO), -2, 1);
  
    lc_variable varchar2(4000);
    ln_job      number := 0;
    ln_ini      number := 0;
  
  begin
  
    --
    -- Barridos de jobs
    --
    execute immediate ('truncate table schedulers');
    execute immediate ('truncate table log_actu_datos');
  
    for job in c_job loop
      ln_ini      := ln_ini + 1;
      lc_variable := ' begin ' ||
                     '  pq_cl_volcado_campana.sp_cl_volcado_job(' || '''' ||
                     job.C_DIGITO1 || '''' || ',' || '''' || job.C_DIGITO2 || '''' || ',' ||
                     ln_ini || ');' || ' End; ';
      ln_job      := ln_job + 1;
    
      dbms_scheduler.create_job(job_name   => 'VOLCADO_DATA' ||
                                              LPAD(TO_CHAR(ln_job), 5, '0'),
                                job_type   => 'PLSQL_BLOCK',
                                job_action => lc_variable,
                                start_date => sysdate + 1 / (24 * 180),
                                enabled    => true,
                                auto_drop  => TRUE,
                                comments   => 'VOLCADO DE INFORMACION DE CAMPAÑA');
    
      INSERT INTO Schedulers
        (c_codage, n_Numer1, c_detjob)
      VALUES
        ('CAM', ln_ini, lc_variable);
      COMMIT;
    
    end loop;
  exception
    when others then
      lc_coderr  := sqlerrm;
      p_c_coderr := lc_coderr;
  end sp_genera_scheduler;

  -------------------------------------------------------------------------------

  Procedure sp_cl_volcado_job(P_C_DIGITO1 IN VARCHAR2,
                              P_C_DIGITO2 IN VARCHAR2,
                              ln_ini      in number) is
    cursor c_direccion is
      select *
        from JAQL463
       where substr(trim(JAQL463NDO), -1, 1) = P_C_DIGITO1
         and substr(trim(JAQL463NDO), -2, 1) = P_C_DIGITO2
         and JAQL463TCL = 'R'
         and JAQL463TCA = 'A';
  
    /*    cursor c_telefonos is
    select distinct jaql464pai, jaql464tdo, jaql464ndo
      from JAQL464
     where substr(trim(JAQL464NDO), -1, 1) = P_C_DIGITO1
       and substr(trim(JAQL464NDO), -2, 1) = P_C_DIGITO2
       and JAQL464TCL = 'R'
       and JAQL464TCA = 'A';*/
  
    cursor c_telefonos1(documento char, tipodir number) is
      select *
        from JAQL464
       where /* substr(trim(JAQL464NDO), -1, 1) = P_C_DIGITO1
                                                                           and substr(trim(JAQL464NDO), -2, 1) = P_C_DIGITO2
                                                                           and */
       JAQL464NDO = documento
       and jaql464dco = tipodir
       and JAQL464TCL = 'R'
       and JAQL464TCA = 'A';
  
    /*    cursor c_mail is
    select distinct jaql465pai, jaql465tdo, jaql465ndo
      from JAQL465
     where substr(trim(JAQL465NDO), -1, 1) = P_C_DIGITO1
       and substr(trim(JAQL465NDO), -2, 1) = P_C_DIGITO2
       and JAQL465TCL = 'R'
       and JAQL465TCA = 'A';*/
  
    cursor c_mail1 is
      select *
        from JAQL465
       where substr(trim(JAQL465NDO), -1, 1) = P_C_DIGITO1
         and substr(trim(JAQL465NDO), -2, 1) = P_C_DIGITO2
         and JAQL465TCL = 'R'
         and JAQL465TCA = 'A';
  
    ln_correl     number := 0;
    ln_correlt    number := 0;
    LN_SNGC13PDOC NUMBER(3);
    LC_SNGC12VIVC CHAR(1);
    LC_SNGC13CNEG CHAR(1);
    LC_SNGC13REF  VARCHAR2(140);
    LD_SNGC13RDES DATE;
    LC_SNGC13ARR  CHAR(50);
    LC_SNGC13ATEL CHAR(50);
    LD_SNGC13FHAB DATE;
    LC_SNGC13EST  CHAR(1);
    LN_SNGC13DEST NUMBER(1);
    LD_SNGC13FDIR DATE;
    LC_SNGC13USER CHAR(10);
    LN_SNGC13COL  NUMBER(9);
    LN_SNGC13TAS  NUMBER(3);
    lc_msgerr     VARCHAR2(400);
    lc_msgerr2    VARCHAR2(400);
  
    VDOCOD    number(2);
    lc_existe char(1);
  
  begin
  
    update schedulers g
       set g.d_fecini = sysdate
     where g.n_numer1 = ln_ini
       and g.c_codage = 'CAM';
    commit;
  
    For i in c_direccion loop
    
      lc_msgerr := '';
      begin
        select SNGC13PDOC,
               SNGC12VIVC,
               SNGC13CNEG,
               SNGC13REF,
               SNGC13RDES,
               SNGC13ARR,
               SNGC13ATEL,
               SNGC13FHAB,
               SNGC13EST,
               SNGC13DEST,
               SNGC13FDIR,
               SNGC13USER,
               SNGC13COL,
               SNGC13TAS
          into LN_SNGC13PDOC,
               LC_SNGC12VIVC,
               LC_SNGC13CNEG,
               LC_SNGC13REF,
               LD_SNGC13RDES,
               LC_SNGC13ARR,
               LC_SNGC13ATEL,
               LD_SNGC13FHAB,
               LC_SNGC13EST,
               LN_SNGC13DEST,
               LD_SNGC13FDIR,
               LC_SNGC13USER,
               LN_SNGC13COL,
               LN_SNGC13TAS
          from sngc13
         where SNGC13PAIS = i.jaql463pai
           and SNGC13TDOC = i.jaql463tdo
           and SNGC13NDOC = i.jaql463ndo
           and DOCOD = i.jaql463dco
              --and SNGC13CORR = 1
           and SNGC13EST = 'H'
           and rownum = 1;
      Exception
        When no_data_found then
          ln_correl     := 0;
          LN_SNGC13PDOC := 604;
          LC_SNGC12VIVC := '6';
          LC_SNGC13CNEG := '';
          LC_SNGC13REF  := '';
          LD_SNGC13RDES := null;
          LC_SNGC13ARR  := '';
          LC_SNGC13ATEL := '';
          LD_SNGC13FHAB := null;
          LC_SNGC13EST  := 'H';
          LN_SNGC13DEST := '2';
        
          case
            When trim(i.jaql463usa) is null then
              LD_SNGC13FDIR := i.jaql463fei;
              LC_SNGC13USER := i.jaql463usi;
            Else
              LD_SNGC13FDIR := i.jaql463fea;
              LC_SNGC13USER := i.jaql463usa;
          end case;
          LN_SNGC13COL := null;
          LN_SNGC13TAS := null;
        when others then
          lc_msgerr  := substr(sqlerrm, 1, 50);
          lc_msgerr2 := substr(sqlerrm, 51, 50);
          insert into log_actu_datos
            (jaql63nu01,
             jaql63ch01,
             jaql63ch02,
             jaql63nu02,
             jaql63ch03,
             jaql63nu05)
          values
            (i.jaql463ndo,
             lc_msgerr,
             lc_msgerr2,
             4,
             to_char(sysdate, 'HH24:mi:ss'),
             20);
          commit;
      end;
    
      If lc_msgerr is null then
      
        if i.jaql463dco = 1 then
          ln_correl := 5;
          VDOCOD    := 7;
        else
          ln_correl := 6;
          VDOCOD    := 8;
        end If;
      
        begin
          insert into sngc13
            (SNGC13PAIS,
             SNGC13TDOC,
             SNGC13NDOC,
             DOCOD,
             SNGC13CORR,
             SNGC13PDOC,
             SNGC12VIVC,
             SNGC01ID,
             SNGC02ID,
             SNGC03ID,
             SNGC04ID,
             SNGC05ID,
             SNGC06ID,
             SNGC13DSC1,
             SNGC13DSC2,
             SNGC13DSC3,
             SNGC13DSC4,
             SNGC13DSC5,
             SNGC13DSC6,
             SNGC13UGEO,
             SNGC13DPTO,
             SNGC13PROV,
             SNGC13DIST,
             SNGC13CNEG,
             SNGC13REF,
             SNGC13REF1,
             SNGC13DIR,
             SNGC13RDES,
             SNGC13ARR,
             SNGC13ATEL,
             SNGC13FHAB,
             SNGC13EST,
             SNGC13DEST,
             SNGC13FDIR,
             SNGC13USER,
             SNGC13COL,
             SNGC13TAS)
          values
            (i.jaql463pai,
             i.jaql463tdo,
             i.jaql463ndo,
             VDOCOD,
             ln_correl,
             LN_SNGC13PDOC,
             LC_SNGC12VIVC,
             i.jaql463co1,
             i.jaql463co2,
             i.jaql463co3,
             i.jaql463co4,
             i.jaql463co5,
             i.jaql463co6,
             i.jaql463ds1,
             i.jaql463ds2,
             i.jaql463ds3,
             i.jaql463ds4,
             i.jaql463ds5,
             i.jaql463ds6,
             i.jaql463ugo,
             i.jaql463dep,
             i.jaql463pro,
             i.jaql463dis,
             LC_SNGC13CNEG,
             LC_SNGC13REF,
             substr(i.jaql463ref || ' / ' || i.jaql463dir, 1, 200),
             i.jaql463dir,
             LD_SNGC13RDES,
             LC_SNGC13ARR,
             LC_SNGC13ATEL,
             LD_SNGC13FHAB,
             'H',
             LN_SNGC13DEST,
             LD_SNGC13FDIR,
             LC_SNGC13USER,
             LN_SNGC13COL,
             LN_SNGC13TAS);
        Exception
          when others then
            lc_msgerr  := substr(sqlerrm, 1, 50);
            lc_msgerr2 := substr(sqlerrm, 51, 50);
            insert into log_actu_datos
              (jaql63nu01,
               jaql63ch01,
               jaql63ch02,
               jaql63nu02,
               jaql63ch03,
               jaql63nu05)
            values
              (i.jaql463ndo,
               lc_msgerr,
               lc_msgerr2,
               1,
               to_char(sysdate, 'HH24:mi:ss'),
               20);
            commit;
            --return;  
        
        end;
      
        If lc_msgerr is null then
        
          ln_correlt := 0;
          For j in c_telefonos1(i.jaql463ndo, i.jaql463dco) loop
          
            if j.jaql464dco = 1 then
              VDOCOD := 7;
            else
              VDOCOD := 8;
            end If;
          
            begin
              select nvl(max(doordp), 0)
                into ln_correlt
                from fsr005
               where pepais = j.jaql464pai
                 and petdoc = j.jaql464tdo
                 and pendoc = j.jaql464ndo
                 and docod = VDOCOD;
            exception
              when no_data_found then
                ln_correlt := 0;
              when others then
                lc_msgerr  := substr(sqlerrm, 1, 50);
                lc_msgerr2 := substr(sqlerrm, 51, 50);
                insert into log_actu_datos
                  (jaql63nu01,
                   jaql63ch01,
                   jaql63ch02,
                   jaql63nu02,
                   jaql63ch03,
                   jaql63nu05)
                values
                  (j.jaql464ndo,
                   lc_msgerr,
                   lc_msgerr2,
                   2,
                   to_char(sysdate, 'HH24:mi:ss'),
                   20);
                commit;
            end;
          
            If lc_msgerr is null then
            
              ln_correlt := ln_correlt + 1;
            
              begin
                insert into fsr005
                  (PEPAIS,
                   PETDOC,
                   PENDOC,
                   DOCOD,
                   DOORDP,
                   DOTELFP,
                   DOTLEXP,
                   DOFAXP)
                values
                  (j.jaql464pai,
                   j.jaql464tdo,
                   j.jaql464ndo,
                   VDOCOD,
                   ln_correlt,
                   j.jaql464tel,
                   null,
                   null);
              Exception
                when others then
                  lc_msgerr  := substr(sqlerrm, 1, 50);
                  lc_msgerr2 := substr(sqlerrm, 51, 50);
                  insert into log_actu_datos
                    (jaql63nu01,
                     jaql63ch01,
                     jaql63ch02,
                     jaql63nu02,
                     jaql63ch03,
                     jaql63nu05)
                  values
                    (j.jaql464ndo,
                     lc_msgerr,
                     lc_msgerr2,
                     2,
                     to_char(sysdate, 'HH24:mi:ss'),
                     20);
                  commit;
              end;
            
              begin
                insert into sngc17
                  (sngc17pais,
                   sngc17ndoc,
                   sngc17tdoc,
                   sngc17dcod,
                   sngc17corr,
                   sngc16ttel)
                values
                  (j.jaql464pai,
                   j.jaql464ndo,
                   j.jaql464tdo,
                   VDOCOD,
                   ln_correlt,
                   j.jaql464ren);
              Exception
                when others then
                  lc_msgerr  := substr(sqlerrm, 1, 50);
                  lc_msgerr2 := substr(sqlerrm, 51, 50);
                  insert into log_actu_datos
                    (jaql63nu01,
                     jaql63ch01,
                     jaql63ch02,
                     jaql63nu02,
                     jaql63ch03,
                     jaql63nu05)
                  values
                    (j.jaql464ndo,
                     lc_msgerr,
                     lc_msgerr2,
                     3,
                     to_char(sysdate, 'HH24:mi:ss'),
                     20);
                  commit;
              end;
            
            end if;
          
          End loop;
        
        End If;
      End IF;
    
    End loop;
    /*  For i in c_telefonos loop
      begin
      delete from fsr005
       where pepais = i.jaql464pai
         and petdoc = i.jaql464tdo
         and pendoc = i.jaql464ndo;       
      end;
    End loop;*/
  
    /*  For i in c_mail loop
      begin
      delete from fsx001
       where txcod  = 0
         and pepais = i.jaql465pai
         and petdoc = i.jaql465tdo
         and pendoc = i.jaql465ndo;       
      end;
    
    End loop;  */
  
    ln_correl := 0;
    For i in c_mail1 loop
    
      begin
        select 'S'
          into lc_existe
          from fsx001
         where txcod = 0
           and pepais = i.jaql465pai
           and petdoc = i.jaql465tdo
           and pendoc = i.jaql465ndo
           and trim(upper(PEXTXT)) = trim(upper(i.jaql465txt)) || '\'
           and rownum = 1;
      exception
        when no_data_found then
          lc_existe := 'N';
      end;
    
      if lc_existe = 'N' then
        begin
          select nvl(max(pexren), 0)
            into ln_correl
            from fsx001
           where txcod = 0
             and pepais = i.jaql465pai
             and petdoc = i.jaql465tdo
             and pendoc = i.jaql465ndo;
        exception
          when no_data_found then
            ln_correl := 0;
        end;
      
        ln_correl := ln_correl + 1;
      
        begin
          insert into fsx001
            (PEPAIS, PETDOC, PENDOC, TXCOD, PEXREN, PEXTXT, PEXUSU, PEXFCH)
          values
            (i.jaql465pai,
             i.jaql465tdo,
             i.jaql465ndo,
             0,
             ln_correl,
             trim(i.jaql465txt) || '\',
             i.jaql465usu,
             i.jaql465fch);
        Exception
          when others then
            lc_msgerr  := substr(sqlerrm, 1, 50);
            lc_msgerr2 := substr(sqlerrm, 51, 50);
            insert into log_actu_datos
              (jaql63nu01,
               jaql63ch01,
               jaql63ch02,
               jaql63nu02,
               jaql63ch03,
               jaql63nu05)
            values
              (i.jaql465ndo,
               lc_msgerr,
               lc_msgerr2,
               4,
               to_char(sysdate, 'HH24:mi:ss'),
               20);
            commit;
        end;
      end if;
    End loop;
    commit;
  
    update schedulers g
       set g.d_fecfin = sysdate
     where g.n_numer1 = ln_ini
       and g.c_codage = 'CAM';
    commit;
  Exception
    when others then
      lc_msgerr := sqlerrm;
      update schedulers g
         set g.c_inderr = 'S', g.c_deserr = lc_msgerr
       where g.n_numer1 = ln_ini
         and g.c_codage = 'CAM';
      commit;
    
  end;

  ------------------------------------------------------------------

  Procedure sp_valida_telefono(P_C_NUMTEL IN VARCHAR2,
                               P_N_TIPCEL IN NUMBER,
                               P_C_ERROR  OUT VARCHAR2) is
  begin
    If length(P_C_NUMTEL) > 9 then
      P_C_ERROR := 'N';
    else
      if P_N_TIPCEL = 2 then
        If length(P_C_NUMTEL) > 7 or length(P_C_NUMTEL) < 6 then
          P_C_ERROR := 'N';
        else
          select case
                   when REGEXP_LIKE(P_C_NUMTEL, '[^0-9]') then
                    'N'
                   else
                    'S'
                 end c_codane
            into P_C_ERROR
            from dual;
        End If;
      else
        If length(P_C_NUMTEL) <> 9 then
          P_C_ERROR := 'N';
        Else
          if TRIM(P_C_NUMTEL) = '999999999' or substr(TRIM(P_C_NUMTEL),1,1) <> '9' then
              P_C_ERROR := 'N';
          else  
            select case
                     when REGEXP_LIKE(P_C_NUMTEL, '[^0-9]') then
                      'N'
                     else
                      'S'
                   end c_codane
              into P_C_ERROR
            from dual;
         End if;   
        End If;
      End if;
    End if;
  End sp_valida_telefono;

  Procedure sp_valida_mail(P_C_MAIL IN VARCHAR2, P_C_ERROR OUT VARCHAR2) is
/*  begin
    select case
             when REGEXP_LIKE(P_C_MAIL,
                              '^[a-z0-9._-]+@[a-z0-9.-]+\.[a-z]{2,6}$',
                              'i') then
              'S'
             else
              'N'
           end
      into P_C_ERROR
      from dual;*/
  cursor c_patrones is
  select a.* 
    from fst198 a
   where a.tp1cod = 1
     and a.tp1cod1 = 10825
     and a.tp1corr1 = 128;
        
  lv_patron  varchar2(30):='';   
  ln_valor   number(9):=0;                              
  begin
    select case
             when REGEXP_LIKE(P_C_MAIL,
                              '^[a-z0-9._-]+@[a-z0-9.-]+\.[a-z]{2,6}$',
                              'i') then
              'S'
             else
              'N'
           end
      into P_C_ERROR
      from dual;
      
   --VALIDAMOS PATRONES INCORRECTOS   
   if P_C_ERROR = 'S' then
     for i in c_patrones loop
       lv_patron := trim(upper(i.tp1desc));
       ln_valor := instr(upper(P_C_MAIL),lv_patron,1);
       if ln_valor > 0 then
          P_C_ERROR := 'N';
          Exit;
       End If;
     End loop;
   End If;  
  Exception
  When others then    
    P_C_ERROR := 'N';      
  end sp_valida_mail;

  -----------------------------------------------------------------------------------

  Procedure sp_llena_jaql467 is
  
    TYPE tp_jaql467cor IS TABLE OF JAQL467.JAQL467COR%type INDEX BY BINARY_INTEGER;
    TYPE tp_jaql467pai IS TABLE OF JAQL467.JAQL467PAI%type INDEX BY BINARY_INTEGER;
    TYPE tp_jaql467tdo IS TABLE OF JAQL467.JAQL467TDO%type INDEX BY BINARY_INTEGER;
    TYPE tp_jaql467ndo IS TABLE OF JAQL467.JAQL467NDO%type INDEX BY BINARY_INTEGER;
    TYPE tp_jaql467ase IS TABLE OF JAQL467.JAQL467ASE%type INDEX BY BINARY_INTEGER;
  
    ln_jaql467cor tp_jaql467cor;
    ln_jaql467pai tp_jaql467pai;
    ln_jaql467tdo tp_jaql467tdo;
    lc_jaql467ndo tp_jaql467ndo;
    lc_jaql467ase tp_jaql467ase;
    lc_error      varchar2(400);
  
    cursor det_ah is
      select rownum, x.pepais, x.petdoc, x.pendoc, x.asesor
        from (
              --ahorros
              select /*+PARALLEL(a,8)*/
              distinct b.pepais, b.petdoc, b.pendoc, c.jaql61user asesor
                from fsd011 a, fsr008 b, jaql061 c, fsd002 d
               where a.pgcod = b.pgcod
                 and b.pgcod = c.jaql61pgco
                 and a.sccta = b.ctnro
                 and c.jaql61pais = b.pepais
                 and c.jaql61tdoc = b.petdoc
                 and c.jaql61ndoc = b.pendoc
                 and b.pepais = d.pfpais
                 and b.petdoc = d.pftdoc
                 and b.pendoc = d.pfndoc
                 and a.scmod in (21, 22)
                 and a.scstat <> '99'
                 and b.ttcod = 1
                 and c.jaql61user is not null --49328
              UNION
              -- creditos
              select /*+PARALLEL(a,8)*/
              distinct b.pepais,
                       b.petdoc,
                       b.pendoc,
                       fn_analista_credito(a.scmod,
                                           a.scsuc,
                                           a.scmda,
                                           a.scpap,
                                           a.sccta,
                                           a.scoper,
                                           a.scsbop,
                                           a.sctope) asesor
                from fsd011 a, fsr008 b, fsd002 d
               where a.pgcod = b.pgcod
                 and a.sccta = b.ctnro
                 and a.scmod in (select modulo from fst111 where dscod = 50)
                 and b.pepais = d.pfpais
                 and b.petdoc = d.pftdoc
                 and b.pendoc = d.pfndoc
                 and a.scstat <> '99'
                 and b.ttcod = 1 --452000
              ) x;
  begin
    execute immediate 'truncate table JAQL467';
  
    OPEN det_ah;
    LOOP
      FETCH det_ah BULK COLLECT
        INTO ln_jaql467cor, ln_jaql467pai, ln_jaql467tdo, lc_jaql467ndo, lc_jaql467ase LIMIT 10000;
      EXIT WHEN ln_jaql467cor.count = 0;
      NULL; -- PRUEBAS                                     
      begin
        FORALL z IN 1 .. ln_jaql467cor.COUNT
          INSERT /*+ append */
          INTO JAQL467
            (JAQL467COR, JAQL467PAI, JAQL467TDO, JAQL467NDO, JAQL467ASE)
          VALUES
            (ln_jaql467cor(z),
             ln_jaql467pai(z),
             ln_jaql467tdo(z),
             lc_jaql467ndo(z),
             lc_jaql467ase(z));
        commit;
      exception
        when others then
          lc_error := sqlerrm;
          INSERT INTO Schedulers
            (c_codage, n_Numer1, c_detjob)
          VALUES
            ('LLE', 999, lc_error);
          commit;
      end;
    END LOOP;
  
    CLOSE det_ah;
    commit;
  
    delete from jaql467 where jaql467ase is null;
    commit;
  
  end sp_llena_jaql467;

end PQ_CL_VOLCADO_CAMPANA;
/

