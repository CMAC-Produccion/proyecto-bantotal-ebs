create or replace package pq_mg_producto_act is

procedure sp_mapeo_prod /*(\*p_n_ctaini in number, 
                         p_n_ctafin in number,*\
                         p_c_fecpro in varchar2,
                         p_n_proceso in number,
                         p_n_tipcam in number
                        )*/ ;

procedure sp_cr_batch_btctaprd(P_C_FECPRO in varchar2, p_n_proceso in number);

--procedure sp_pr_act_numeradores;
procedure sp_pr_equivalencia;
function fn_tipcamb(PD_FECPRO in date) return number;
end;
/
create or replace package body pq_mg_producto_act is
procedure sp_mapeo_prod /*(p_n_ctaini in number, 
                         p_n_ctafin in number,*\
                         p_c_fecpro in varchar2,
                         p_n_proceso in number,
                         p_n_tipcam in number
                        )*/ IS
  -- ****************************************************************
  -- Nombre                     : sp_mapeo_prod
  -- Sistema                    : SORFY
  -- Modulo                     : Personas
  -- Version                    : 1.0
  -- Fecha de Creacion          : 25/04/2011
  -- Autor de Creacion          : LLLOSA
  -- Uso                        :  
  -- Estado                     : Activo
  -- Acceso                     : Publico
  -- Parametros de Entrada      : p_n_ctaini (NUMERO DE CUENTA INICIAL)
  --                              p_n_ctafin (NUMERO DE CUENTA FINAL)
  -- Parametros de Salida       : 
  -- Fecha de modificacion      :
  -- Autor de Modificacion      :
  -- Descripcion de Modificacion:
  -- ****************************************************************    
  cursor cliente is
  select DISTINCT 
       a.c_codper,
       a.n_ctabtt,
       b.c_numcta ,
       B.C_INDPRO,
       c.mda n_moneda,
       c.suc n_sucurs,
       a.c_perpri,
       c.tit ,
       c.ope modulo,
       c.sbop tipope,
       a.c_esprov 
  from bandejas.btctacli a,
       bandejas.btctaman b,
       bandejas.mig$cta_cli c
 where a.c_codper  = b.c_codper 
   and c.cuenta = b.c_numcta
   AND C.Tit = 1
   and c. tipo in ('C','G','F')
   --and c.suc = p_n_ctaini
   --AND C_NUMCTA = '00412000522646851'
 order by 1,8;
   

cursor cuentas_aho (lc_numcta in varchar2) is
SELECT cuenta, 
       c.ope modulo,
       c.sbop tipope,
       c.mda ,
       c.cliente, 
       pais, 
       tdoc, 
       ndoc, 
       decode(tit,1,'S','N') c_indpri, 
       null TIPPER
  FROM BANDEJAS.mig$cta_cli C
 WHERE cuenta =  lc_numcta;

   
cursor renova is
select * from renovacion;


cursor credito (lc_numcta in varchar2) is
SELECT cuenta, 
       c.ope modulo,
       c.sbop tipope,
       c.mda ,
       c.cliente, 
       pais, 
       tdoc, 
       ndoc, 
       decode(tit,1,'S','N') c_indpri, 
       null TIPPER
  FROM BANDEJAS.mig$cta_cli C
 WHERE cuenta =  lc_numcta;

     --------------------------------------------------------   
     
  --ln_ctaadj number;
     
  --lc_aval   varchar2(1);  
  --ln_ctagar number;
  ----  
  
  --lc_extpag varchar2(1);
  --ln_cappag number;

  ln_operac number;
  ln_subcta number;
  ln_modulo number;
  ln_totope number;
  lc_msgerr varchar2(300);
 
  ln_ctaaho number;
  ln_ctacre number;
  ln_ctagar number;
  --ln_ctacre number;

  --lv_ctasal varchar2(50);
  --lv_ctaint varchar2(50);
  --ln_coderr varchar2(100);
  --
  ln_mtoblq number;
  ln_salcon number;
  --lv_ctagar varchar2(50);
  --lv_ctachq varchar2(50);
  --lc_indgar varchar2(1);
  --ld_fecact date;
  --ld_fecmov date;

 
  --lc_tippla varchar2(2);
  --lc_caspag varchar2(1);
  --lc_rubsbs varchar2(2);
  --ls_estado varchar2(2);
  --ls_calfin varchar2(1);
  --ls_cobint varchar2(1);
  --ln_intdev number;
  --ln_intsus number;
  --ln_monpro number;
  --ln_propro number;
  lc_error varchar2(100);
  --


  --ln_ano number;
  --ln_mes number;
  -- garantias
  --lc_indpri varchar2(1);
 
  --lc_inserta varchar2(1);
  --ln_tipcam number;
  
  lc_indtra char(1);
  ln_cuenta number;
  --ln_nroist number(10);
  -----------------------------
  --lc_rubpsi varchar2(13);
  --ln_prvsdi number;
  --lc_rubpsd varchar2(13);
  --ln_prvsin number;
  ------------------------------
  --lc_rubprod varchar2(13);
  --lc_concre varchar2(1);
  --lc_demanda varchar2(1);
  ln_maxdpf number;
  ln_maxcre number;
  ln_maxgar number;
  ln_numsub number;
  lc_esprov varchar2(1);
  ln_instancia number;
  
  ---------------------------- 
  -- Se agrego reproceso -----
 /* cursor reprocesa is
  select  max(n_operac) n_maxope, 
          case when n_modulo between 101 and 117 or n_modulo = 141 then 50
               else n_modulo end n_modulo 
    from btprdclv --btctaprd 
   group by case when n_modulo between 101 and 117 or n_modulo = 141 then 50
                 else n_modulo end ;*/
  ----------------------------               
  --Reproceso---
  lc_existe varchar2(1);  
  --n number;                        
  begin
  execute immediate('alter session  set SORT_AREA_SIZE=4000000');-- para afinamiento
  execute immediate ('truncate table btctaprd');
    -- inicio de job
  
  update tab_jobs g
     set g.d_fecini = sysdate
   where /*g.n_numer1 =  p_n_ctaini
     and */g.c_codage = 'PRD';
  commit;
  --ln_ano := to_number(SUBSTR(P_C_FECPRO,1,4));
  --ln_mes := to_number(SUBSTR(P_C_FECPRO,5,2)); 
  --ln_tipcam := p_n_tipcam; --pq_sy_syttica.fn_sy_cambfj@migra2('004','011',to_date(P_C_FECPRO,'YYYYMMDD'));
  ---------------------------- 
  -- Se agrego reproceso -----
  /*if p_n_proceso = 2 then
     for r in reprocesa loop
         Case when r.n_modulo = 21 then
                   ln_subcta := r.n_maxope;    
              when r.n_modulo = 22 then
                   ln_ctaaho := r.n_maxope;    
              when r.n_modulo = 50 then
                   ln_ctacre := r.n_maxope;    
              when r.n_modulo = 70 then
                   ln_ctagar := r.n_maxope;    
              when r.n_modulo = 79 then
                   ln_ctaadj := r.n_maxope;         
              else
                  null;
         end case;              
     end loop;
  else*/
      ln_subcta :=0;    
      ln_ctaaho :=0;    
      --ln_ctacre :=0;    
      --ln_ctagar :=0;    
      --ln_ctaadj :=0;
      ln_maxdpf :=0;
      ln_maxcre :=0; 
      ln_maxgar :=0;
      ln_instancia := 0;
  --end if;
  ---------------------------- 
    ln_cuenta := 0;
      
    -- numjerador credito
    begin
       select ngnum 
         into ln_maxcre
         from fsn999 
        where pgcod = 1  
          and ngsuc = 1 
          and ngtipo = 39;
    exception
      when others then 
        ln_maxcre:=0;
    end;
     -- numjerador garantia
    begin
       select ngnum 
         into ln_maxgar
         from fsn999 
        where pgcod = 1  
          and ngsuc = 1 
          and ngtipo = 70;
    exception
      when others then 
        ln_maxgar:=0;
    end;
    
    ln_ctacre:= ln_maxcre;
    ln_ctagar:= ln_maxgar;
    select WFINSPRCID.nextval into ln_instancia from dual;
    for i in cliente loop
        -- Verificar si la cuenta cliente existe
         lc_esprov := null;
        Begin 
          select 'E' 
            into lc_esprov
            from fsd008
           where pgcod = 1
             and ctnro = i.n_ctabtt;
        exception
          when others then 
            lc_esprov := 'N';
        end;    
        ln_cuenta:= ln_cuenta + 1;
          if i.c_indpro in ('D','A') then -- depositos
                /* lc_existe := 'N'; 
                 ln_operac := null;
                 ln_subcta := null;
                 ln_modulo := i.mod;
                 ln_totope := i.tipope;
                 
             if lc_existe = 'N' then 
                 if i.mod <> '22' and lc_esprov = 'E' then --i.c_esprov ='E' then
                     select max(scsbop)
                       into ln_subcta
                       from fsd011 
                      where pgcod = 1 
                        and sccta = i.n_ctabtt
                        and scmod = i.mod ;
                        
                     select count(n_subope)  
                       into ln_numsub
                       from btctaprd 
                      where n_ctabtt = i.n_ctabtt
                        and c_indpri ='S'
                        and n_modulo = i.mod;
                        
                     ln_subcta := nvl(ln_subcta,0) + nvl(ln_numsub,0) + 1;    
                     ln_operac := 0;
                  elsif i.mod <> '22' and lc_esprov = 'N' then --i.c_esprov ='N' then
                     select max(n_subope)  
                       into ln_subcta
                       from btctaprd 
                      where n_ctabtt = i.n_ctabtt;
                     ln_subcta := nvl(ln_subcta,0) +1;   
                     ln_operac := 0;
                  else
                      --ln_ctaaho:=nvl(ln_ctaaho,0) +1;             
                      -- Se agrego secuencial---------------------------
                      ln_ctaaho:= ln_ctaaho + 1;
                      --------------------------------------------------
                      ln_operac := ln_ctaaho;
                      ln_subcta := 0;
                  End if;  
             end if;
             --------------------
        
           for j in cuentas_aho (i.c_numcta) loop
               -- Busca Cuenta contable 
             begin 
               --
               insert into btctaprd 
                 (n_sucurs,
                  n_moneda,
                  n_papel,
                  n_ctabtt,
                  n_operac,
                  n_subope,
                  n_modulo,
                  n_totope,
                  c_percom,
                  c_codper,
                  c_numcta,
                  c_indpro,
                  n_codpai,
                  n_tipdoc,
                  n_numdoc,
                  c_indpri,
                  c_codtcu,
                  n_numfir,
                  n_numfio,
                  c_tipper
                  )
               values
                 (i.n_sucurs,
                  i.n_moneda,
                  0,
                  i.n_ctabtt,
                  ln_operac,
                  ln_subcta,
                  ln_modulo,
                  ln_totope, 
                  i.c_codper,
                  j.cliente,
                  i.c_numcta,
                  'A',
                  j.pais,
                  j.tdoc,
                  j.ndoc,
                  j.c_indpri,
                  j.codtcu,
                  j.numfir,
                  j.numfio,
                  j.tipper
                   );
               --commit;
             exception 
               when others then
                  lc_error:=sqlerrm;                      
                --insertar a una tabla generica de excepciones (dato y la bandeja)
                insert into LOG_ERROR_BANDEJA
                  (n_nro,c_codbdj,c_deserr,d_fecerr)
                values
                  (\*p_n_ctaini*\1,'sp_mapeo_p',i.c_numcta || ' : ' || lc_error,sysdate);
                --commit;               
             end;    
             
               
           end loop;
           --lv_ctasal := null;
           --lv_ctaint := null;
           --lv_ctagar := null;
           --lv_ctachq := null;
           --lv_ctasus := null;
           lc_indtra := null;
           --ln_salint := 0;
           ln_mtoblq := 0;
           --ln_salsus := 0;
           ln_salcon := 0;*/
           null;
           
        elsif i.c_indpro = 'C' then
              lc_existe := 'N'; 
              ln_operac := null;
              ln_subcta := null;
              ln_modulo := i.modulo;
              ln_totope := i.tipope;
              if lc_existe = 'N' then
                 ln_ctacre := ln_ctacre + 1; 
                 ln_operac := ln_ctacre;   
                 ln_subcta := 0;
              end if;
              -- genera nro de solisitud --
               --select bantprod.WFINSPRCID.nextval into ln_instancia from dual;
               ln_instancia := ln_instancia +1;
              -----------------------------
              for j in credito (i.c_numcta) loop
               -- Busca Cuenta contable 
             begin 
               --
               insert into btctaprd 
                 (n_sucurs,
                  n_moneda,
                  n_papel,
                  n_ctabtt,
                  n_operac,
                  n_subope,
                  n_modulo,
                  n_totope,
                  c_percom,
                  c_codper,
                  c_numcta,
                  c_indpro,
                  n_codpai,
                  n_tipdoc,
                  n_numdoc,
                  c_indpri,
                  c_tipper,
                  N_NROIST
                  )
               values
                 (i.n_sucurs,
                  i.n_moneda,
                  0,
                  i.n_ctabtt,
                  ln_operac,
                  ln_subcta,
                  ln_modulo,
                  ln_totope, 
                  i.c_codper,
                  j.cliente,
                  i.c_numcta,
                  'C',
                  j.pais,
                  j.tdoc,
                  j.ndoc,
                  j.c_indpri,
                  j.tipper,
                  ln_instancia
                   );
               --commit;
             exception 
               when others then
                  lc_error:=sqlerrm;                      
                --insertar a una tabla generica de excepciones (dato y la bandeja)
                insert into LOG_ERROR_BANDEJA
                  (n_nro,c_codbdj,c_deserr,d_fecerr)
                values
                  (1,'sp_mapeo_p',i.c_numcta || ' : ' || lc_error,sysdate);
                --commit;               
             end;    
           end loop;  
         elsif i.c_indpro = 'G' then
              lc_existe := 'N'; 
              ln_operac := null;
              ln_subcta := null;
              ln_modulo := i.modulo;
              ln_totope := i.tipope;
              if lc_existe = 'N' then
                 ln_ctagar := ln_ctagar + 1; 
                 ln_operac := ln_ctagar;   
                 ln_subcta := 0;
              end if;
              for j in credito (i.c_numcta) loop
               -- Busca Cuenta contable 
             begin 
               --
               insert into btctaprd 
                 (n_sucurs,
                  n_moneda,
                  n_papel,
                  n_ctabtt,
                  n_operac,
                  n_subope,
                  n_modulo,
                  n_totope,
                  c_percom,
                  c_codper,
                  c_numcta,
                  c_indpro,
                  n_codpai,
                  n_tipdoc,
                  n_numdoc,
                  c_indpri,
                  c_tipper
                  )
               values
                 (i.n_sucurs,
                  i.n_moneda,
                  0,
                  i.n_ctabtt,
                  ln_operac,
                  ln_subcta,
                  ln_modulo,
                  ln_totope, 
                  i.c_codper,
                  j.cliente,
                  i.c_numcta,
                  'G',
                  j.pais,
                  j.tdoc,
                  j.ndoc,
                  j.c_indpri,
                  j.tipper
                   );
               --commit;
             exception 
               when others then
                  lc_error:=sqlerrm;                      
                --insertar a una tabla generica de excepciones (dato y la bandeja)
                insert into LOG_ERROR_BANDEJA
                  (n_nro,c_codbdj,c_deserr,d_fecerr)
                values
                  (1,'sp_mapeo_p',i.c_numcta || ' : ' || lc_error,sysdate);
                --commit;               
             end;    
           end loop; 
        elsif  i.c_indpro = 'F' then
              lc_existe := 'N'; 
              ln_operac := null;
              ln_subcta := null;
              ln_modulo := i.modulo;
              ln_totope := i.tipope;
              if lc_existe = 'N' then
                 ln_ctagar := ln_ctagar + 1; 
                 ln_operac := ln_ctagar;   
                 ln_subcta := 0;
              end if;
              for j in credito (i.c_numcta) loop
               -- Busca Cuenta contable 
             begin 
               --
               insert into btctaprd 
                 (n_sucurs,
                  n_moneda,
                  n_papel,
                  n_ctabtt,
                  n_operac,
                  n_subope,
                  n_modulo,
                  n_totope,
                  c_percom,
                  c_codper,
                  c_numcta,
                  c_indpro,
                  n_codpai,
                  n_tipdoc,
                  n_numdoc,
                  c_indpri,
                  c_tipper
                  )
               values
                 (i.n_sucurs,
                  i.n_moneda,
                  0,
                  i.n_ctabtt,
                  ln_operac,
                  ln_subcta,
                  ln_modulo,
                  ln_totope, 
                  i.c_codper,
                  j.cliente,
                  i.c_numcta,
                  'F',
                  j.pais,
                  j.tdoc,
                  j.ndoc,
                  j.c_indpri,
                  j.tipper
                   );
               --commit;
             exception 
               when others then
                  lc_error:=sqlerrm;                      
                --insertar a una tabla generica de excepciones (dato y la bandeja)
                insert into LOG_ERROR_BANDEJA
                  (n_nro,c_codbdj,c_deserr,d_fecerr)
                values
                  (1,'sp_mapeo_p',i.c_numcta || ' : ' || lc_error,sysdate);
                --commit;               
             end;   
             end loop;    
        else
           lc_error:=sqlerrm;
            insert into LOG_ERROR_BANDEJA
              (n_nro,c_codbdj,c_deserr,d_fecerr)
            values
              (/*p_n_ctaini*/1,'sp_mapeo_p',i.c_numcta || ' : ' || lc_error,sysdate);
            --commit;             

        end if;
        if mod(ln_cuenta,1000) = 0 then
           commit;
        end if;
    end loop;
    COMMIT;
    begin
      
     for i in renova loop
       update btctaprd d
          set d.n_subope = i.ren
        where d.c_numcta = i.cuenta;
     end loop;
     commit;
    end; 
    
    update tab_jobs g
     set g.d_fecfin = sysdate
   where /*g.n_numer1 =  p_n_ctaini
     and*/ g.c_codage = 'PRD';
  commit;
  EXCEPTION
    when others then
      lc_msgerr := sqlerrm;
      update tab_jobs g
       set g.c_inderr = 'S',
           g.c_deserr = lc_msgerr
     where /*g.n_numer1 = p_n_ctaini
       and*/ g.c_codage = 'PRD';
    commit;
    return;
   
  end;
  procedure sp_cr_batch_btctaprd(P_C_FECPRO in varchar2, p_n_proceso in number) is
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

  --ln_max number;
  --ln_inc number;
  --ln_ini number;
  --ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  ln_tipcam number(5,3);
  lc_error varchar2(500);
  cursor agencia is
  select distinct suc sucurs from mig$cta_cli x where x.tipo in ('C','G') order by 1;

  --NUM_JOB_PENDIENTES NUMBER(10);
  
  begin 
  -- VERIFCA QUE HALLA TERMINAOD PROCESO DEPENDIENTE
 /* NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
   pi_vc2_nomjob => 'CTACLI_INSERTA',
   pi_vc2_nomusr => 'MIGRA2'
   );

  WHILE NUM_JOB_PENDIENTES >0 LOOP
  
  NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
   pi_vc2_nomjob => 'CTACLI_INSERTA',
   pi_vc2_nomusr => 'MIGRA2'
   );
  END LOOP;*/
  
  
    execute immediate ('delete from tab_jobs where C_DETJOB LIKE ''%sp_mapeo_prod%''');
    /*if p_n_proceso = 2 then 
       -- inserta claves en tabla 
       begin
           execute immediate ('truncate table btprdclv');
           insert into btprdclv 
           select n_sucurs, n_moneda, n_papel, n_ctabtt, n_operac, n_subope, n_modulo, n_totope, c_numcta, c_indpro, n_nroist, c_rubpro
             from btctaprd 
            where c_indpri='S' and c_indpro <> 'V';
           execute immediate ('truncate table btctaprd');
       exception
         when others then 
          null;
          return;
       end;      
    else*/
       execute immediate ('truncate table btctaprd');
    --End if;
  --  execute immediate ('analyze table btctaman compute statistics');
    
  
    i:=0;
    ln_tipcam:= pq_mg_producto.fn_tipcamb(to_date(P_C_FECPRO,'YYYYMMDD'));
    for i in agencia loop
        begin
        lc_variable := ' begin '|| '  pq_mg_producto.sp_mapeo_prod('
          ||i.sucurs||','
          ||i.sucurs||','
          ||''''
          ||P_C_FECPRO||''''||','
          ||p_n_proceso||','
          ||ln_tipcam||');'|| ' End; ';
        ln_job := ln_job +1;
--        dbms_output.put_line(lc_variable);
           dbms_scheduler.create_job(
         job_name=> 'INV_PROD'||LPAD(TO_CHAR(ln_job),5,'0'),
         job_type=> 'PLSQL_BLOCK',
         job_action=> lc_variable,
         start_date => sysdate+1/(24*180),
         enabled => true, 
         auto_drop=> TRUE,
         comments => 'MIGRANDO INVEN PROD CA'
         );

 
        INSERT INTO Tab_jobs (c_codage,n_Numer1,c_detjob)
        VALUES('PRD',i.sucurs,lc_variable);
        COMMIT;
        exception
        when others then        
          lc_error := sqlerrm;
          --insertar a una tabla generica de excepciones (dato y la bandeja)
          insert into LOG_ERROR_BANDEJA
            (n_nro,c_codbdj,c_deserr,d_fecerr)
          values
            (10000,'sp_mapeo_prod',lc_variable||' : ' || lc_error,sysdate);
          commit;                
        end;
    end loop;
   
  end;
  
  
 /* 
  procedure sp_pr_act_numeradores is
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

  --ln_max    number;
  ln_maxcre number;
  ln_maxdpf number;
  ln_maxcli number;  
  lc_variable varchar2(200);
  cursor cliente is 
  select n_ctabtt, n_subope, count(*) 
    from btctaprd 
   where n_modulo = 21 
     and c_indpri = 'S'
   group by n_ctabtt, n_subope
  having count(*) > 1;
  
  cursor ahorro (ln_ctabtt in number ) is 
  select * from btctaprd   
   where n_modulo = 21 
   and n_ctabtt  = ln_ctabtt;
  ln_cta number;
  lc_numcta varchar2(17);
  
  cursor clie_DPF is 
   select n_ctabtt, n_operac, count(c_numcta) 
    from btctaprd 
   where n_modulo = 22 
     and c_indpri = 'S'
   group by n_ctabtt, n_operac
  having count(c_numcta) > 1;
  
cursor DPF (ln_ctabtt in number ) is 
  select * from btctaprd   
   where n_modulo = 22 
   and n_ctabtt  = ln_ctabtt;

  cursor c_agencia is
  select distinct pp174suc sucurs from fpp174;  
  --ln_nro number(10):=0; 
  
  
  NUM_JOB_PENDIENTES NUMBER(10);
  
  
  begin 
       -- VERIFCA QUE HALLA TERMINAOD PROCESO DEPENDIENTE
       NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
       pi_vc2_nomjob => 'INV_PROD',
       pi_vc2_nomusr => 'MIGRA2'
       );
    
       WHILE NUM_JOB_PENDIENTES >0 LOOP
      
           NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
           pi_vc2_nomjob => 'INV_PROD',
           pi_vc2_nomusr => 'MIGRA2'
           );
       END LOOP;
       -- atualiza dupicados de ahorros numerador 
       begin 
        for i in cliente loop
          ln_cta := 0;
          for j in ahorro (i.n_ctabtt) loop
              if j.c_numcta <> nvl(lc_numcta,'X') then
                 ln_cta := ln_cta + 1;
                 lc_numcta := j.c_numcta;
              end if;
              update btctaprd
                 set n_subope = ln_cta
               where n_ctabtt = i.n_ctabtt
                 and c_numcta = j.c_numcta
                 and n_modulo = 21;     
          end loop;
          --dbms_output.put_line (i.n_ctabtt);
        end loop;
       end;
       -- Actualiza Duplicados DPF
       begin 
          select max(n_operac) 
            into ln_maxdpf 
            from btctaprd 
           where n_modulo between 21 and 22;
            
       \* for i in clie_DPF loop
          for j in DPF (i.n_ctabtt) loop
              if j.c_numcta <> nvl(lc_numcta,'X') then
                 select sq_ah_dpf.nextval into ln_maxdpf from dual;
--                 ln_maxdpf := ln_maxdpf + 1;
                 lc_numcta := j.c_numcta;
              end if;
              update btctaprd
                 set n_operac = ln_maxdpf
               where n_ctabtt = i.n_ctabtt
                 and c_numcta = j.c_numcta
                 and n_modulo = 22;     
          end loop;
          --dbms_output.put_line (i.n_ctabtt);
        end loop;*\
  end;
       
       
       
       
       ------------------
       begin
           select max(n_operac) 
             into ln_maxcre 
             from btctaprd 
            where n_modulo between 101 and 117 or n_modulo = 141;
           -- select sq_cr_prestamo.nextval into ln_maxcre from dual;
           update fsn999 
              set ngnum = ln_maxcre 
            where pgcod = 1 and ngsuc = 11 and ngtipo = 39;  
            commit;
       exception
           when others then
           lc_variable := 'Error numerador de creditos';
           INSERT INTO Tab_jobs (c_codage,n_Numer1,c_detjob)
           VALUES('PRDN',ln_maxcre,lc_variable);
           COMMIT;
    
       end;          
      
       begin
           \*if nvl(ln_maxdpf,0) = 0 then
             select sq_ah_dpf.nextval into ln_maxdpf from dual;
           end if; *\
           update fsn999 
              set ngnum = ln_maxdpf --+ 1
            where pgcod = 1 and ngsuc = 11 and ngtipo = 22;
            commit;
       exception
           when others then
            
           lc_variable := 'Error numerador de DPF';
           INSERT INTO Tab_jobs (c_codage,n_Numer1,c_detjob)
           VALUES('PRDN',ln_maxdpf,lc_variable);
           COMMIT;
        
       end;
       begin
           select max(n_ctabtt) 
             into ln_maxcli 
             from btctacli;
           update fsn999 
              set ngnum = ln_maxcli + 1
            where pgcod = 1 and ngsuc = 11 and ngtipo = 3;  
            commit;
       exception
           when others then
           lc_variable := 'Error numerador de clientes';
           INSERT INTO Tab_jobs (c_codage,n_Numer1,c_detjob)
           VALUES('PRDN',ln_maxcli,lc_variable);
           COMMIT;
    
       end; 
  --
  -- ACTUALIZA NUMERADORES DE PRENDARIO Y SNG059
  --       
     
  
   
 \*  
   --
   -- NUMERADOR DE EVENTOS
   --   
   
   select migra2.sq_cr_evento.nextval into ln_nro from dual;
   select migra2.sq_cr_evento.currval into ln_nro from dual;
   
   begin
          update bantotal.sng059 set sng059num = ln_nro where SNG059COD = 23;
   commit;
   exception
   when others then
   null;   
   end;  
   
   --
   -- NUMERADOR DE EVALUACIONES
   --
   select migra2.sq_cr_eval.nextval into ln_nro from dual;
   select migra2.sq_cr_eval.currval into ln_nro from dual;
   
   begin
          update bantotal.sng059 set sng059num = ln_nro where SNG059COD = 10;
   commit;
   exception
   when others then
   null;   
   end;     *\
       
       
          
  end; */
  procedure sp_pr_equivalencia is
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

  
  NUM_JOB_PENDIENTES NUMBER(10);
  lc_variable varchar2(200);
 /* cursor agencia is
  select sucurs from fst001;
     ln_newsub number;
     ln_cambia number;*/
     --lc_muchos1 varchar2(17);
  begin 
       -- VERIFCA QUE HALLA TERMINAOD PROCESO DEPENDIENTE
       NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
       pi_vc2_nomjob => 'INV_PROD',
       pi_vc2_nomusr => 'MIGRA2'
       );
    
       WHILE NUM_JOB_PENDIENTES >0 LOOP
      
           NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
           pi_vc2_nomjob => 'INV_PROD',
           pi_vc2_nomusr => 'MIGRA2'
           );
       END LOOP;
       -- borra datos anteriores
       begin
         delete from bnj096 a
          where exists ( select * from btctaprd b where c_numcta = trim(a.bnj096sor));
         commit;
       exception 
          when others then
             null;
       end;      
       begin
           --execute immediate ('truncate table bantotal.bnj096');
           -- borrar indices
      /*     begin execute immediate ('drop index  bantotal.BNJ09602'); exception when others then null; end;
           begin execute immediate ('drop index  bantotal.BNJ09603'); exception when others then null; end;
           begin execute immediate ('drop index  bantotal.BNJ09604'); exception when others then null; end;
           begin execute immediate ('drop index  bantotal.BNJ09606'); exception when others then null; end;
           begin execute immediate ('drop index  bantotal.BNJ09607'); exception when others then null; end;           
           */

           /*insert into bandejas.bnj096 (bnj096suc,bnj096mda,bnj096pap,bnj096cta,bnj096ope,bnj096sub,bnj096mod,bnj096top,bnj096sor,bnj096doc,bnj096nom,bnj096ord,BNJ096CPE)
           select distinct x.n_sucurs, x.n_moneda, x.n_papel, x.n_ctabtt, x.n_operac, x.n_subope, x.n_modulo, x.n_totope, x.c_numcta,
                 --(select s.c_codcci from sorfy_migra.ahmcuen s where s.c_numcta = x.c_numcta) c_codcci,
                 trim(substr(lpad(x.n_numdoc,15,' '),4,12)),y.nom,
                  case
                  when x.n_modulo = 21 and x.n_totope in (1,6,7,8,5) then
                  1
                  when x.n_modulo = 22  then
                  2
                  when x.n_modulo = 21 and x.n_totope = 3 then
                  3
                  when x.n_modulo = 21 and x.n_totope = 2 then                                    
                  4
                  else
                  5
                  end orden ,'159'                                  
             from btctaprd x,
                  bandejas.mig$cta_cli y
            where x.c_numcta = y.cuenta
              and x.c_indpri='S' 
              and y.tit = 1
              and x.c_indpro not in ('V','G','C')
              and x.n_modulo is not null;
           commit; */ 
           insert into bnj096 (bnj096suc,bnj096mda,bnj096pap,bnj096cta,bnj096ope,bnj096sub,bnj096mod,bnj096top,bnj096sor,bnj096doc,bnj096nom,bnj096ord,BNJ096CPE,BNJ096SOL)
           select distinct x.n_sucurs, x.n_moneda, x.n_papel, x.n_ctabtt, x.n_operac, x.n_subope, x.n_modulo, x.n_totope, x.c_numcta,
                 --(select s.c_codcci from sorfy_migra.ahmcuen s where s.c_numcta = x.c_numcta) c_codcci,
                 trim(substr(lpad(x.n_numdoc,15,' '),4,12)),y.nom,
                  case
                  when x.n_modulo = 21 and x.n_totope in (1,6,7,8,5) then
                  1
                  when x.n_modulo = 22  then
                  2
                  when x.n_modulo = 21 and x.n_totope = 3 then
                  3
                  when x.n_modulo = 21 and x.n_totope = 2 then                                    
                  4
                  else
                  5
                  end orden ,'159',
                  to_char(x.n_nummov)--to_char(x.N_NROIST)                                  
             from btctaprd x,
                  bandejas.mig$cta_cli y
            where x.c_numcta = y.cuenta
              and x.c_indpri='S' 
              and y.tit = 1
              and x.c_indpro in ('V','G','C')
              and x.n_modulo is not null;
           commit; 
           -- Actualiza estadisticas.
           begin SYS.dbms_stats.gather_table_stats('BANTOTAL','BNJ096'); end;
           
       exception
       
           when others then
           lc_variable := sqlerrm;
           INSERT INTO Tab_jobs (c_codage,n_Numer1,c_detjob)
           VALUES('EQIV',999,lc_variable);
           COMMIT;
    
       end; 
       
       -- inserta jaql714
              begin 
               --
               insert into JAQL054 
                 (jaql54pgco ,jaql54scsu ,jaql54scmd ,jaql54scpa ,
                  jaql54scct ,jaql54scop ,jaql54scsb ,jaql54scto ,
                  jaql54scmo ,jaql54timi ,jaql54enti ,jaql54fech ,
                  jaql54hora ,jaql54au01 )
                 
                select distinct 1, x.n_sucurs, x.n_moneda, x.n_papel, 
                       x.n_ctabtt, x.n_operac, x.n_subope, x.n_totope,
                       x.n_modulo, 'B',159,trunc(sysdate),
                       to_char(sysdate,'HH24:MI:SS'), 'MIGRACION'   
             from btctaprd x,
                  bandejas.mig$cta_cli y
            where x.c_numcta = y.cuenta
              and x.c_indpri='S' 
              and y.tit = 1
              and x.c_indpro not in ('V','G','C')
              and x.n_modulo is not null;
                  
               --commit;
             exception 
                 when others then
                 lc_variable := sqlerrm;
                 INSERT INTO Tab_jobs (c_codage,n_Numer1,c_detjob)
                 VALUES('EQIV',998,lc_variable);
                 COMMIT;               
             end;         
  end; 
  
function fn_tipcamb(PD_FECPRO in date) return number is

  ld_fecpro date;
  --ln_limite number;
  ln_cotcbi number;
  ln_result number;
begin

  begin
    -- Datos según Parámetros.
    ld_fecpro := trunc(PD_FECPRO);
    --ln_limite := trunc(PD_LIMITE);
    --
    select g.cotcbi
      into ln_cotcbi       
      from fsh005 g 
     where g.moneda = 101 
       and g.cofdes = ld_fecpro;
    
    ln_result := /*PD_LIMITE **/ ln_cotcbi;

    
  exception
    when others then
      return(null);
  end;
  return(ln_result);
end;
end;
/
