create or replace package pq_cr_historico_pagos_ind is

  -- *****************************************************************
  -- Nombre                       : pq_cr_historico_pagos_ind
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 13/07/2020
  -- Autor de Creación            : jjrodriguej
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Descripción                  : Paquete para procesar y registrar el histórico de reprogramaciones individuales
  -- Fecha de Modificación        : 25/08/2020
  -- Autor de Modificación        : jjrodriguej
  -- Descripción de Modificación  : Actualización del tipo de operación y registros cancelados
  -- *****************************************************************

  PROCEDURE sp_insertar_Individual(pn_fecha_ini in date,
                                   pn_fecha_fin in date);

  PROCEDURE sp_insertar_Individual_BI(pn_fecha in date,
                                      --pn_corr  in number,
                                      
                                      pn_aocta  in number,
                                      pn_aooper in number,
                                      pn_aosbop in number);

  PROCEDURE sp_insertar_JAQA255(pn_fecha_ini in date, pn_fecha_fin in date);

  PROCEDURE sp_insertar_JAQA255_Ind(pn_fecha in date,
                                    --pn_corr  in number,
                                    
                                    pn_pgcod  in number,
                                    pn_aomod  in number,
                                    pn_aosuc  in number,
                                    pn_aomda  in number,
                                    pn_aopap  in number,
                                    pn_aocta  in number,
                                    pn_aooper in number,
                                    pn_aosbop in number,
                                    pn_aotope in number);

  PROCEDURE sp_actualizar_sbop(pn_fecha_ini in date, pn_fecha_fin in date);

 PROCEDURE sp_insertar_FSD601(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number); 


                              
 PROCEDURE sp_insertar_FSD602(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number); 
                         
 PROCEDURE sp_insertar_FSD611(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number);    
                            
 PROCEDURE sp_insertar_FPP001(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number);     
                              
 PROCEDURE sp_insertar_FPP002(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number);     
                              
 PROCEDURE sp_insertar_X054023(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number); 
                            
 PROCEDURE sp_insertar_FSD012(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number);   
                              
 PROCEDURE sp_generar_registros(pn_fecha_ini in date,
                                pn_fecha_fin in date);    
                                
 PROCEDURE sp_actualizar_cancelados;   
 
 PROCEDURE sp_reprocesar_registros;                                                                                                                                                                                                                                                                   


end pq_cr_historico_pagos_ind;
/

create or replace package body pq_cr_historico_pagos_ind is

  -- *****************************************************************
  -- Nombre                       : pq_cr_historico_pagos_ind
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 13/07/2020
  -- Autor de Creación            : jjrodriguej
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Descripción                  : Paquete para procesar y registrar el histórico de reprogramaciones individuales
  -- Fecha de Modificación        : 25/08/2020
  -- Autor de Modificación        : jrodriguej
  -- Descripción de Modificación  : Actualización del tipo de operación y registros cancelados
  -- Fecha de Modificación        : 09/03/2021
  -- Autor de Modificación        : jrodriguej
  -- Descripción de Modificación  : Reemplazo de USRREPBI.REP_TOT_REPRO_2020 por AQPB090
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  PROCEDURE sp_insertar_Individual(pn_fecha_ini in date,
                                   pn_fecha_fin in date) is
  
    lc_fecha_ini date;
    lc_fecha_fin date;
  
    --Cursor INDIVIDUALES
    cursor cur_repro_indiv(cr_fecha_ini date, cr_fecha_fin date) is
      select 
       h.*
        from (select row_number() over(
             partition by j.aqpb090cta, 
                          j.aqpb090oper 
             order by j.aqpb090cta, 
                      j.aqpb090oper, 
                      j.aqpb090sbop asc) orden,
                     j.*
                from aqpb090 j      ---- USRREPBI.REP_TOT_REPRO_2020
               where j.aqpb090tipo = 'INDIVIDUAL'
                 and j.aqpb090ext = 'NO') h
       where h.orden = 1
         and (h.aqpb090cta, h.aqpb090oper) not in
             (select distinct x.aqpb009cta, x.aqpb009ope from aqpb009 x)
         and h.aqpb090fec >= cr_fecha_ini
         and h.aqpb090fec <= cr_fecha_fin
       order by h.aqpb090fec asc;    
      /*
      select 
       h.*
        from (select row_number() over(partition by j.bccta, j.bcoper order by j.bccta, j.bcoper, j.bcsbop asc) orden,
                     j.*
                from USRREPBI.REP_TOT_REPRO_2020 j
               where j.tipo = 'INDIVIDUAL'
                 and j.Extorno = 'NO') h
       where h.orden = 1
         and (h.bccta, h.bcoper) not in
             (select distinct x.aqpb009cta, x.aqpb009ope from aqpb009 x)
         and h.fecha_reprogramacion >= cr_fecha_ini
         and h.fecha_reprogramacion <= cr_fecha_fin
       order by h.fecha_reprogramacion asc;
      */
  
  Begin
  
    lc_fecha_ini := pn_fecha_ini;
    lc_fecha_fin := pn_fecha_fin;
    --lc_fecha_ini:= trunc(lc_fecha_fin) - (to_number(to_char(lc_fecha_fin,'DD')) - 1);
  
    --dbms_output.put_line(to_char(lc_fecha_ini, 'YYYY-MM-DD'));
    --dbms_output.put_line(to_char(lc_fecha_fin, 'YYYY-MM-DD'));
  
    begin
    
      ---Recurrido cursor REP_TOT_REPRO_2020: AQPB090
      for i in cur_repro_indiv(lc_fecha_ini, lc_fecha_fin) loop
      
        pq_cr_historico_pagos_ind.sp_insertar_Individual_BI(i.aqpb090fec,
                                                            i.aqpb090cta,
                                                            i.aqpb090oper,
                                                            i.aqpb090sbop);
      
      end loop;
    end;
  
  end sp_insertar_Individual;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_Individual_BI(pn_fecha in date,
                                      --pn_corr  in number,
                                      
                                      pn_aocta  in number,
                                      pn_aooper in number,
                                      pn_aosbop in number) is
    lc_flag char(1);
    lc_corr number;
  
    lx_pgcod  number;
    lx_aomod  number;
    lx_aosuc  number;
    lx_aomda  number;
    lx_aopap  number;
    lx_aocta  number;
    lx_aooper number;
    lx_aosbop number;
    lx_aotope number;
    lx_aoobop number;
  
  begin
  
    begin
      select 'S'
        into lc_flag
        from fsd010 q
       where q.pgcod = 1
         and q.aocta = pn_aocta
         and q.aooper = pn_aooper
         and q.aosbop = 0
         and q.aomod in (select h.modulo from fst111 h where h.dscod = 50);
    exception
      when others then
        lc_flag := 'N';
    end;
  
    if lc_flag = 'S' then
      begin
        /************************/
      
        select q.pgcod, --lx_pgcod,
               q.aomod, --lx_aomod,
               q.aosuc, --lx_aosuc,
               q.aomda, --lx_aomda,
               q.aopap, --lx_aopap,
               q.aocta, --lx_aocta,
               q.aooper, ----lx_aooper,
               pn_aosbop, --lx_aosbop,  <--Suboperación actual
               q.aotope, --lx_aotope,
               q.aosbop --lx_aoobop
        
          into lx_pgcod, --
               lx_aomod, --
               lx_aosuc, -- <== obtener sucursal
               lx_aomda, --
               lx_aopap, --
               lx_aocta, --
               lx_aooper, --
               lx_aosbop, -- <--Suboperación actual
               lx_aotope,
               lx_aoobop -- es 0
          from fsd010 q
         where q.aocta = pn_aocta
           and q.aooper = pn_aooper
           and q.aosbop = 0
           and q.aomod in
               (select h.modulo from fst111 h where h.dscod = 50);
      
        -- Obtención correlativo
        select nvl(max(x.aqpb009cor), 0) + 1
          into lc_corr
          from aqpb009 x
         where x.aqpb009fep = pn_fecha
           and trim(x.aqpb009tref) = 'FSH016';
      
        ---Insertar aqpb064
        insert into aqpb064
          (aqpb064frepro,
           aqpb064ncorre,
           aqpb064pgcod,
           aqpb064aomod,
           aqpb064aosuc,
           aqpb064aomda,
           aqpb064aopap,
           aqpb064aocta,
           aqpb064aooper,
           aqpb064aosbop,
           aqpb064aotope,
           aqpb064proceso,
           aqpb064fcierre,
           aqpb064tablaref,
           aqpb064orden)
        values
          (pn_fecha,
           lc_corr,
           lx_pgcod, --
           lx_aomod, --
           lx_aosuc, --
           lx_aomda, --
           lx_aopap, --
           lx_aocta, --
           lx_aooper, --
           lx_aosbop, --
           lx_aotope,
           'C',
           pn_fecha,
           'FSH016',
           1);
        commit;
      
        ---Insertar aqpb009
        insert into aqpb009
          (aqpb009fep,
           aqpb009cor,
           aqpb009emp,
           aqpb009mod,
           aqpb009suc,
           aqpb009mda,
           aqpb009pap,
           aqpb009cta,
           aqpb009ope,
           aqpb009sbo,
           aqpb009top,
           aqpb009est,
           aqpb009tref)
        values
          (pn_fecha,
           lc_corr,
           lx_pgcod, --
           lx_aomod, --
           lx_aosuc, --
           lx_aomda, --
           lx_aopap, --
           lx_aocta, --
           lx_aooper, --
           lx_aosbop, --
           lx_aotope,
           'C',
           'FSH016');
        commit;
      
        /*********** 1: INSERTAR AQPB061: FSD0601 - BACKUP *****************/
      
        pq_cr_historico_pagos_ind.sp_insertar_FSD601(lx_pgcod, --
                                                     lx_aomod, --
                                                     lx_aosuc, --
                                                     lx_aomda, --
                                                     lx_aopap, --
                                                     lx_aocta, --
                                                     lx_aooper, --
                                                     lx_aosbop, --
                                                     lx_aotope);
      
        /*********** 2: INSERTAR aqpb062: FSD0602 - BACKUP *****************/
      
        pq_cr_historico_pagos_ind.sp_insertar_FSD602(lx_pgcod, --
                                                     lx_aomod, --
                                                     lx_aosuc, --
                                                     lx_aomda, --
                                                     lx_aopap, --
                                                     lx_aocta, --
                                                     lx_aooper, --
                                                     lx_aosbop, --
                                                     lx_aotope);
      
        /*********** 3: INSERTAR aqpb063: FSD0611 - BACKUP *****************/
      
        pq_cr_historico_pagos_ind.sp_insertar_FSD611(lx_pgcod, --
                                                     lx_aomod, --
                                                     lx_aosuc, --
                                                     lx_aomda, --
                                                     lx_aopap, --
                                                     lx_aocta, --
                                                     lx_aooper, --
                                                     lx_aosbop, --
                                                     lx_aotope);
      
        /*********** 4: INSERTAR aqpa974: FPP001 - BACKUP *****************/
      
        pq_cr_historico_pagos_ind.sp_insertar_FPP001(lx_pgcod, --
                                                     lx_aomod, --
                                                     lx_aosuc, --
                                                     lx_aomda, --
                                                     lx_aopap, --
                                                     lx_aocta, --
                                                     lx_aooper, --
                                                     lx_aosbop, --
                                                     lx_aotope);
      
        /*********** 5: INSERTAR aqpa973: FPP002 - BACKUP *****************/
      
        pq_cr_historico_pagos_ind.sp_insertar_FPP002(lx_pgcod, --
                                                     lx_aomod, --
                                                     lx_aosuc, --
                                                     lx_aomda, --
                                                     lx_aopap, --
                                                     lx_aocta, --
                                                     lx_aooper, --
                                                     lx_aosbop, --
                                                     lx_aotope);
      
        /*********** 6: INSERTAR aqpb060: X054023 - BACKUP *****************/
      
        pq_cr_historico_pagos_ind.sp_insertar_X054023(lx_pgcod, --
                                                      lx_aomod, --
                                                      lx_aosuc, --
                                                      lx_aomda, --
                                                      lx_aopap, --
                                                      lx_aocta, --
                                                      lx_aooper, --
                                                      lx_aosbop, --
                                                      lx_aotope);
      
        /*********** 7: INSERTAR aqpa975: FSD012 - BACKUP *****************/
      
        pq_cr_historico_pagos_ind.sp_insertar_FSD012(lx_pgcod, --
                                                     lx_aomod, --
                                                     lx_aosuc, --
                                                     lx_aomda, --
                                                     lx_aopap, --
                                                     lx_aocta, --
                                                     lx_aooper, --
                                                     lx_aosbop, --
                                                     lx_aotope);
      
        --- Final: validación  
      
      end;
    end if;
  
  end sp_insertar_Individual_BI;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  PROCEDURE sp_insertar_JAQA255(pn_fecha_ini in date, pn_fecha_fin in date) is
  
    lc_fecha_ini date;
    lc_fecha_fin date;
  
    --Cursor INDIVIDUALES
    cursor cur_repro_jaqa255(cr_fecha_ini date, cr_fecha_fin date) is
    
      select --(300000 + row_number()
      --over(order by h.jaqa255cta, h.jaqa255ope asc)) nro,
       h.*
        from (select row_number() over(partition by t.jaqa255cta, t.jaqa255ope order by t.jaqa255cta, t.jaqa255ope, t.jaqa255sbo asc) orden,
                     t.*
                from jaqa255 t
               where t.jaqa255est = 'L'
                 and t.jaqa255fec >= cr_fecha_ini
                 and t.jaqa255fec <= cr_fecha_fin) h
       where h.orden = 1
            
         and (h.jaqa255emp, h.jaqa255mod, h.jaqa255mda, h.jaqa255pap,
              h.jaqa255cta, h.jaqa255ope, h.jaqa255tpo) not in
             (select distinct s.aqpb009emp,
                              s.aqpb009mod,
                              s.aqpb009mda,
                              s.aqpb009pap,
                              s.aqpb009cta,
                              s.aqpb009ope,
                              s.aqpb009top
                from aqpb009 s)
       order by h.jaqa255fec asc;
  
  Begin
  
    lc_fecha_ini := pn_fecha_ini;
    lc_fecha_fin := pn_fecha_fin;
    --lc_fecha_ini:= trunc(lc_fecha_fin) - (to_number(to_char(lc_fecha_fin,'DD')) - 1);
  
    dbms_output.put_line(to_char(lc_fecha_ini, 'YYYY-MM-DD'));
    dbms_output.put_line(to_char(lc_fecha_fin, 'YYYY-MM-DD'));
  
    begin
    
      ---Recurrido cursor JAQZ698
      for i in cur_repro_jaqa255(lc_fecha_ini, lc_fecha_fin) loop
      
        pq_cr_historico_pagos_ind.sp_insertar_JAQA255_Ind(i.jaqa255fec,
                                                          --i.nro,
                                                          
                                                          i.jaqa255emp,
                                                          i.jaqa255mod,
                                                          i.jaqa255suc,
                                                          i.jaqa255mda,
                                                          i.jaqa255pap,
                                                          i.jaqa255cta,
                                                          i.jaqa255ope,
                                                          i.jaqa255sbo,
                                                          i.jaqa255tpo
                                                          
                                                          );
      
      end loop;
    end;
  
  end sp_insertar_JAQA255;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  PROCEDURE sp_insertar_JAQA255_Ind(pn_fecha in date,
                                    --pn_corr  in number,
                                    
                                    pn_pgcod  in number,
                                    pn_aomod  in number,
                                    pn_aosuc  in number,
                                    pn_aomda  in number,
                                    pn_aopap  in number,
                                    pn_aocta  in number,
                                    pn_aooper in number,
                                    pn_aosbop in number,
                                    pn_aotope in number) is
    lc_flag char(1);
    lc_corr number;
  
    lx_pgcod  number;
    lx_aomod  number;
    lx_aosuc  number;
    lx_aomda  number;
    lx_aopap  number;
    lx_aocta  number;
    lx_aooper number;
    lx_aosbop number;
    lx_aotope number;
    lx_aoobop number;
  
  begin
  
    begin
      select 'S'
        into lc_flag
        from fsd010 q
       where q.pgcod = pn_pgcod
         and q.aomod = pn_aomod
            --and q.aosuc = pn_aosuc
         and q.aomda = pn_aomda
         and q.aopap = pn_aopap
         and q.aocta = pn_aocta
         and q.aooper = pn_aooper
         and q.aosbop = 0 --q.aosbop = pn_aosbop and
            -- and q.aotope = pn_aotope
         and q.aomod in (select h.modulo from fst111 h where h.dscod = 50);
    exception
      when others then
        lc_flag := 'N';
    end;
  
    if lc_flag = 'S' then
      begin
        /************************/
      
        select q.pgcod, --lx_pgcod,
               q.aomod, --lx_aomod,
               q.aosuc, --lx_aosuc,
               q.aomda, --lx_aomda,
               q.aopap, --lx_aopap,
               q.aocta, --lx_aocta,
               q.aooper, ----lx_aooper,
               pn_aosbop, --lx_aosbop,  <--Suboperación actual
               q.aotope, --lx_aotope,
               q.aosbop --lx_aoobop
        
          into lx_pgcod, --
               lx_aomod, --
               lx_aosuc, -- <--Obtener sucursal
               lx_aomda, --
               lx_aopap, --
               lx_aocta, --
               lx_aooper, --
               lx_aosbop, -- <--Suboperación actual
               lx_aotope,
               lx_aoobop -- es 0
          from fsd010 q
         where q.pgcod = pn_pgcod
           and q.aomod = pn_aomod
           and
              --q.aosuc = pn_aosuc and
               q.aomda = pn_aomda
           and q.aopap = pn_aopap
           and q.aocta = pn_aocta
           and q.aooper = pn_aooper
           and q.aosbop = 0
              --and q.aotope = pn_aotope
           and q.aomod in
               (select h.modulo from fst111 h where h.dscod = 50);
      
        -- Obtención correlativo
        select nvl(max(x.aqpb009cor), 0) + 1
          into lc_corr
          from aqpb009 x
         where x.aqpb009fep = pn_fecha
           and trim(x.aqpb009tref) = 'JAQA255';
      
        ---Insertar aqpb064
        insert into aqpb064
          (aqpb064frepro,
           aqpb064ncorre,
           aqpb064pgcod,
           aqpb064aomod,
           aqpb064aosuc,
           aqpb064aomda,
           aqpb064aopap,
           aqpb064aocta,
           aqpb064aooper,
           aqpb064aosbop,
           aqpb064aotope,
           aqpb064proceso,
           aqpb064fcierre,
           aqpb064tablaref,
           aqpb064orden)
        values
          (pn_fecha,
           lc_corr,
           lx_pgcod, --
           lx_aomod, --
           lx_aosuc, --
           lx_aomda, --
           lx_aopap, --
           lx_aocta, --
           lx_aooper, --
           lx_aosbop, --
           lx_aotope,
           'L',
           pn_fecha,
           'JAQA255',
           1);
        commit;
      
        ---Insertar aqpb009
        insert into aqpb009
          (aqpb009fep,
           aqpb009cor,
           aqpb009emp,
           aqpb009mod,
           aqpb009suc,
           aqpb009mda,
           aqpb009pap,
           aqpb009cta,
           aqpb009ope,
           aqpb009sbo,
           aqpb009top,
           aqpb009est,
           aqpb009tref)
        values
          (pn_fecha,
           lc_corr,
           lx_pgcod, --pn_pgcod,
           lx_aomod, --pn_aomod,
           lx_aosuc, --pn_aosuc,
           lx_aomda, --pn_aomda,
           lx_aopap, --pn_aopap,
           lx_aocta, --pn_aocta,
           lx_aooper, --pn_aooper,
           lx_aosbop, --pn_aosbop,
           lx_aotope, --pn_aotope,
           'C',
           'JAQA255');
        commit;
      
        /*********** 1: INSERTAR AQPB061: FSD0601 - BACKUP *****************/
      
        pq_cr_historico_pagos_ind.sp_insertar_FSD601(lx_pgcod, --
                                                     lx_aomod, --
                                                     lx_aosuc, --
                                                     lx_aomda, --
                                                     lx_aopap, --
                                                     lx_aocta, --
                                                     lx_aooper, --
                                                     lx_aosbop, --
                                                     lx_aotope);
      
        /*********** 2: INSERTAR aqpb062: FSD0602 - BACKUP *****************/
      
        pq_cr_historico_pagos_ind.sp_insertar_FSD602(lx_pgcod, --
                                                     lx_aomod, --
                                                     lx_aosuc, --
                                                     lx_aomda, --
                                                     lx_aopap, --
                                                     lx_aocta, --
                                                     lx_aooper, --
                                                     lx_aosbop, --
                                                     lx_aotope);
      
        /*********** 3: INSERTAR aqpb063: FSD0611 - BACKUP *****************/
      
        pq_cr_historico_pagos_ind.sp_insertar_FSD611(lx_pgcod, --
                                                     lx_aomod, --
                                                     lx_aosuc, --
                                                     lx_aomda, --
                                                     lx_aopap, --
                                                     lx_aocta, --
                                                     lx_aooper, --
                                                     lx_aosbop, --
                                                     lx_aotope);
      
        /*********** 4: INSERTAR aqpa974: FPP001 - BACKUP *****************/
      
        pq_cr_historico_pagos_ind.sp_insertar_FPP001(lx_pgcod, --
                                                     lx_aomod, --
                                                     lx_aosuc, --
                                                     lx_aomda, --
                                                     lx_aopap, --
                                                     lx_aocta, --
                                                     lx_aooper, --
                                                     lx_aosbop, --
                                                     lx_aotope);
      
        /*********** 5: INSERTAR aqpa973: FPP002 - BACKUP *****************/
      
        pq_cr_historico_pagos_ind.sp_insertar_FPP002(lx_pgcod, --
                                                     lx_aomod, --
                                                     lx_aosuc, --
                                                     lx_aomda, --
                                                     lx_aopap, --
                                                     lx_aocta, --
                                                     lx_aooper, --
                                                     lx_aosbop, --
                                                     lx_aotope);
      
        /*********** 6: INSERTAR aqpb060: X054023 - BACKUP *****************/
      
        pq_cr_historico_pagos_ind.sp_insertar_X054023(lx_pgcod, --
                                                      lx_aomod, --
                                                      lx_aosuc, --
                                                      lx_aomda, --
                                                      lx_aopap, --
                                                      lx_aocta, --
                                                      lx_aooper, --
                                                      lx_aosbop, --
                                                      lx_aotope);
      
        /*********** 7: INSERTAR aqpa975: FSD012 - BACKUP *****************/
      
        pq_cr_historico_pagos_ind.sp_insertar_FSD012(lx_pgcod, --
                                                     lx_aomod, --
                                                     lx_aosuc, --
                                                     lx_aomda, --
                                                     lx_aopap, --
                                                     lx_aocta, --
                                                     lx_aooper, --
                                                     lx_aosbop, --
                                                     lx_aotope);
      
        --- Final: validación  
      
      end;
    end if;
  
  end sp_insertar_JAQA255_Ind;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_actualizar_sbop(pn_fecha_ini in date, pn_fecha_fin in date) is
  
    lc_fecha_ini date;
    lc_fecha_fin date;
    lx_aosuc     number;
    lx_sbop      number;
    lc_flag      char(1);
    lx_top       number;
  
    --Cursor INDIVIDUALES
    cursor cur_repro_fsh016 is
    
      select distinct b.aqpb066fep,
                      b.aqpb066cor,
                      b.aqpb066emp,
                      b.aqpb066mod,
                      b.aqpb066suc,
                      b.aqpb066mda,
                      b.aqpb066pap,
                      b.aqpb066cta,
                      b.aqpb066ope,
                      b.aqpb066sbo,
                      b.aqpb066top
        from aqpb066 b;
  
  Begin
  
    lc_fecha_ini := pn_fecha_ini;
    lc_fecha_fin := pn_fecha_fin;
    --lc_fecha_ini:= trunc(lc_fecha_fin) - (to_number(to_char(lc_fecha_fin,'DD')) - 1);
  
    dbms_output.put_line(to_char(lc_fecha_ini, 'YYYY-MM-DD'));
    dbms_output.put_line(to_char(lc_fecha_fin, 'YYYY-MM-DD'));
  
    begin
    
      --1. Eliminar data auxiliar 
      delete from AQPB066;
      commit;
    
      --2. Inserción de data auxiliar
      insert into AQPB066
        (aqpb066fep,
         aqpb066cor,
         aqpb066emp,
         aqpb066mod,
         aqpb066suc,
         aqpb066mda,
         aqpb066pap,
         aqpb066cta,
         aqpb066ope,
         aqpb066sbo,
         aqpb066top,
         aqpb066tref)
        select t.aqpb009fep,
               t.aqpb009cor,
               t.aqpb009emp,
               t.aqpb009mod,
               t.aqpb009suc,
               t.aqpb009mda,
               t.aqpb009pap,
               t.aqpb009cta,
               t.aqpb009ope,
               t.aqpb009sbo,
               t.aqpb009top,
               t.aqpb009tref
          from aqpb009 t
         where (t.aqpb009emp, t.aqpb009cta, t.aqpb009ope) in
               (select 1, j.aqpb090cta, j.aqpb090oper
                  from aqpb090 j --- USRREPBI.REP_TOT_REPRO_2020
                 where j.aqpb090tipo = 'INDIVIDUAL'
                   and j.aqpb090ext = 'NO'
                   and j.aqpb090fec >= lc_fecha_ini
                   and j.aqpb090fec <= lc_fecha_fin)
        
        union all
        
        select t.aqpb009fep,
               t.aqpb009cor,
               t.aqpb009emp,
               t.aqpb009mod,
               t.aqpb009suc,
               t.aqpb009mda,
               t.aqpb009pap,
               t.aqpb009cta,
               t.aqpb009ope,
               t.aqpb009sbo,
               t.aqpb009top,
               t.aqpb009tref
          from aqpb009 t
         where (t.aqpb009emp, t.aqpb009mod, t.aqpb009mda, t.aqpb009pap,
                t.aqpb009cta, t.aqpb009ope, t.aqpb009top) in
               (select j.JAQA255EMP,
                       j.JAQA255MOD,
                       j.JAQA255MDA,
                       j.JAQA255PAP,
                       j.jaqa255cta,
                       j.jaqa255ope,
                       j.JAQA255TPO
                  from jaqa255 j
                 where j.jaqa255est = 'L'
                   and j.jaqa255fec >= lc_fecha_ini
                   and j.jaqa255fec <= lc_fecha_fin); 
        commit;        
        /*
        select t.aqpb009fep,
               t.aqpb009cor,
               t.aqpb009emp,
               t.aqpb009mod,
               t.aqpb009suc,
               t.aqpb009mda,
               t.aqpb009pap,
               t.aqpb009cta,
               t.aqpb009ope,
               t.aqpb009sbo,
               t.aqpb009top,
               t.aqpb009tref
          from aqpb009 t
         where (t.aqpb009emp, t.aqpb009cta, t.aqpb009ope) in
               (select 1, j.bccta, j.bcoper
                  from USRREPBI.REP_TOT_REPRO_2020 j
                 where j.tipo = 'INDIVIDUAL'
                   and j.Extorno = 'NO'
                   and j.fecha_reprogramacion >= lc_fecha_ini
                   and j.fecha_reprogramacion <= lc_fecha_fin)
        
        union all
        
        select t.aqpb009fep,
               t.aqpb009cor,
               t.aqpb009emp,
               t.aqpb009mod,
               t.aqpb009suc,
               t.aqpb009mda,
               t.aqpb009pap,
               t.aqpb009cta,
               t.aqpb009ope,
               t.aqpb009sbo,
               t.aqpb009top,
               t.aqpb009tref
          from aqpb009 t
         where (t.aqpb009emp, t.aqpb009mod, t.aqpb009mda, t.aqpb009pap,
                t.aqpb009cta, t.aqpb009ope, t.aqpb009top) in
               (select j.JAQA255EMP,
                       j.JAQA255MOD,
                       j.JAQA255MDA,
                       j.JAQA255PAP,
                       j.jaqa255cta,
                       j.jaqa255ope,
                       j.JAQA255TPO
                  from jaqa255 j
                 where j.jaqa255est = 'L'
                   and j.jaqa255fec >= lc_fecha_ini
                   and j.jaqa255fec <= lc_fecha_fin);
                   */
      
    
      ---Recurrido cursor JAQZ698
      for i in cur_repro_fsh016 loop
      
        lc_flag := 'S';
      
        begin
          -- Obtener la sucursal y suboperación vigente
          select t.aosuc, t.aosbop, t.aotope
            into lx_aosuc, lx_sbop, lx_top
            from fsd010 t
           where t.pgcod = i.aqpb066emp
             and t.aomod = i.aqpb066mod
             and t.aomda = i.aqpb066mda
             and t.aopap = i.aqpb066pap
             and t.aocta = i.aqpb066cta
             and t.aooper = i.aqpb066ope
             and t.aomod in
                 (select u.modulo from fst111 u where u.dscod = 50)
             and t.aostat <> 99;
        exception
          when others then
            lc_flag := 'N';
        end;
      
        --Si no existe suboperación vigente, obtener la máxima
        if lc_flag = 'N' then
        
          begin
          
            select f.suc, f.sbop, f.top
              into lx_aosuc, lx_sbop, lx_top
              from (select x.aosuc suc, max(x.aosbop) sbop, x.aotope top
                    
                      from fsd010 x
                     where x.pgcod = i.aqpb066emp
                       and x.aomod = i.aqpb066mod
                       and x.aomda = i.aqpb066mda
                       and x.aopap = i.aqpb066pap
                       and x.aocta = i.aqpb066cta
                       and x.aooper = i.aqpb066ope
                       and x.aomod in
                           (select u.modulo from fst111 u where u.dscod = 50)
                     group by x.aosuc, x.aotope
                     order by sbop desc) f
             where rownum = 1;
          
            lc_flag := 'S';
          
          exception
            when others then
              lc_flag := 'N';
          end;
        
        end if;
      
        -- Actualizar datos
        if (lx_sbop <> i.aqpb066sbo or lx_aosuc <> i.aqpb066suc or
           lx_top <> i.aqpb066top) and lc_flag = 'S' then
        
          update aqpb060 t
             set t.aqpb060aosuc  = lx_aosuc,
                 t.aqpb060aosbop = lx_sbop,
                 t.aqpb060aotop  = lx_top
           where t.aqpb060pgcod = i.aqpb066emp
             and t.aqpb060aomod = i.aqpb066mod
             and t.aqpb060aosuc = i.aqpb066suc
             and t.aqpb060aomda = i.aqpb066mda
             and t.aqpb060aopap = i.aqpb066pap
             and t.aqpb060aocta = i.aqpb066cta
             and t.aqpb060aooper = i.aqpb066ope
             and t.aqpb060aosbop = i.aqpb066sbo
             and t.aqpb060aotop = i.aqpb066top;
          commit;
        
          update aqpb061 t
             set t.aqpb061suc  = lx_aosuc,
                 t.aqpb061sbop = lx_sbop,
                 t.aqpb061tope = lx_top
           where t.aqpb061pgcod = i.aqpb066emp
             and t.aqpb061mod = i.aqpb066mod
             and t.aqpb061suc = i.aqpb066suc
             and t.aqpb061mda = i.aqpb066mda
             and t.aqpb061pap = i.aqpb066pap
             and t.aqpb061cta = i.aqpb066cta
             and t.aqpb061oper = i.aqpb066ope
             and t.aqpb061sbop = i.aqpb066sbo
             and t.aqpb061tope = i.aqpb066top;
          commit;
        
          update aqpb062 t
             set t.aqpb062suc  = lx_aosuc,
                 t.aqpb062sbop = lx_sbop,
                 t.aqpb062tope = lx_top
           where t.aqpb062pgcod = i.aqpb066emp
             and t.aqpb062mod = i.aqpb066mod
             and t.aqpb062suc = i.aqpb066suc
             and t.aqpb062mda = i.aqpb066mda
             and t.aqpb062pap = i.aqpb066pap
             and t.aqpb062cta = i.aqpb066cta
             and t.aqpb062oper = i.aqpb066ope
             and t.aqpb062sbop = i.aqpb066sbo
             and t.aqpb062tope = i.aqpb066top;
          commit;
        
          update aqpb063 t
             set t.aqpb063suc  = lx_aosuc,
                 t.aqpb063sbop = lx_sbop,
                 t.aqpb063tope = lx_top
           where t.aqpb063pgcod = i.aqpb066emp
             and t.aqpb063mod = i.aqpb066mod
             and t.aqpb063suc = i.aqpb066suc
             and t.aqpb063mda = i.aqpb066mda
             and t.aqpb063pap = i.aqpb066pap
             and t.aqpb063cta = i.aqpb066cta
             and t.aqpb063oper = i.aqpb066ope
             and t.aqpb063sbop = i.aqpb066sbo
             and t.aqpb063tope = i.aqpb066top;
          commit;
        
          update aqpa973 t
             set t.aqpa973suc  = lx_aosuc,
                 t.aqpa973sbop = lx_sbop,
                 t.aqpa973tope = lx_top
           where t.aqpa973cod = i.aqpb066emp
             and t.aqpa973mod = i.aqpb066mod
             and t.aqpa973suc = i.aqpb066suc
             and t.aqpa973mda = i.aqpb066mda
             and t.aqpa973pap = i.aqpb066pap
             and t.aqpa973cta = i.aqpb066cta
             and t.aqpa973oper = i.aqpb066ope
             and t.aqpa973sbop = i.aqpb066sbo
             and t.aqpa973tope = i.aqpb066top;
          commit;
        
          update aqpa974 t
             set t.aqpa974suc  = lx_aosuc,
                 t.aqpa974sbop = lx_sbop,
                 t.aqpa974tope = lx_top
           where t.aqpa974pgcod = i.aqpb066emp
             and t.aqpa974mod = i.aqpb066mod
             and t.aqpa974suc = i.aqpb066suc
             and t.aqpa974mda = i.aqpb066mda
             and t.aqpa974pap = i.aqpb066pap
             and t.aqpa974cta = i.aqpb066cta
             and t.aqpa974oper = i.aqpb066ope
             and t.aqpa974sbop = i.aqpb066sbo
             and t.aqpa974tope = i.aqpb066top;
          commit;
        
          update aqpa975 t
             set t.aqpa975suc  = lx_aosuc,
                 t.aqpa975sbop = lx_sbop,
                 t.aqpa975tope = lx_top
           where t.aqpa975cod = i.aqpb066emp
             and t.aqpa975mod = i.aqpb066mod
             and t.aqpa975suc = i.aqpb066suc
             and t.aqpa975mda = i.aqpb066mda
             and t.aqpa975pap = i.aqpb066pap
             and t.aqpa975cta = i.aqpb066cta
             and t.aqpa975oper = i.aqpb066ope
             and t.aqpa975sbop = i.aqpb066sbo
             and t.aqpa975tope = i.aqpb066top;
          commit;
        
          update aqpb064 t
             set t.aqpb064aosuc  = lx_aosuc,
                 t.aqpb064aosbop = lx_sbop,
                 t.aqpb064aotope = lx_top
           where t.aqpb064pgcod = i.aqpb066emp
             and t.aqpb064aomod = i.aqpb066mod
             and t.aqpb064aomda = i.aqpb066mda
             and t.aqpb064aopap = i.aqpb066pap
             and t.aqpb064aocta = i.aqpb066cta
             and t.aqpb064aooper = i.aqpb066ope
             and t.aqpb064orden = 1;
          commit;
        
          update aqpb009 t
             set t.aqpb009suc = lx_aosuc,
                 t.aqpb009sbo = lx_sbop,
                 t.aqpb009top = lx_top
           where t.aqpb009fep = i.aqpb066fep
             and t.aqpb009cor = i.aqpb066cor
             and t.aqpb009emp = i.aqpb066emp
             and t.aqpb009mod = i.aqpb066mod
             and t.aqpb009suc = i.aqpb066suc
             and t.aqpb009mda = i.aqpb066mda
             and t.aqpb009pap = i.aqpb066pap
             and t.aqpb009cta = i.aqpb066cta
             and t.aqpb009ope = i.aqpb066ope
             and t.aqpb009sbo = i.aqpb066sbo
             and t.aqpb009top = i.aqpb066top;
          commit;
        
        end if;
      
      end loop;
    
      -- Eliminado de data auxiliar
      delete from AQPB066;
      commit;
    
    end;
  
  end sp_actualizar_sbop;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  PROCEDURE sp_insertar_FSD601(pn_pgcod  in number,
                               pn_aomod  in number,
                               pn_aosuc  in number,
                               pn_aomda  in number,
                               pn_aopap  in number,
                               pn_aocta  in number,
                               pn_aooper in number,
                               pn_aosbop in number,
                               pn_aotope in number) is
  
    lx_cont   number;
    lc_flag   char(1);
    lc_fecha  date;
    lc_coderr char(100);
    lc_msgerr char(100);
  
    ---ACTUAL
    cursor jaqz520_fsd601(cr_pgcod  number,
                          cr_aomod  number,
                          cr_aosuc  number,
                          cr_aomda  number,
                          cr_aopap  number,
                          cr_aocta  number,
                          cr_aooper number,
                          cr_aosbop number,
                          cr_aotope number) is
      select *
        from FSD601 t
       where t.pgcod = cr_pgcod
         and t.ppmod = cr_aomod
         and t.ppsuc = cr_aosuc
         and t.ppmda = cr_aomda
         and t.pppap = cr_aopap
         and t.ppcta = cr_aocta
         and t.ppoper = cr_aooper
         and t.ppsbop = cr_aosbop
         and t.pptope = cr_aotope
       order by t.ppfpag asc;
  
  begin
  
    select t.pgfape into lc_fecha from fst017 t where t.pgcod = 1;
  
    --Evaluar ACTUAL
    select count(*)
      into lx_cont
      from FSD601 t
     where t.pgcod = pn_pgcod
       and t.ppmod = pn_aomod
       and t.ppsuc = pn_aosuc
       and t.ppmda = pn_aomda
       and t.pppap = pn_aopap
       and t.ppcta = pn_aocta
       and t.ppoper = pn_aooper
       and t.ppsbop = 0
       and --pn_aosbop and
           t.pptope = pn_aotope;
  
    if lx_cont > 0 then
    
      for k in jaqz520_fsd601(pn_pgcod,
                              pn_aomod,
                              pn_aosuc,
                              pn_aomda,
                              pn_aopap,
                              pn_aocta,
                              pn_aooper,
                              0, --pn_aosbop, 
                              pn_aotope) loop
        begin
          --Inserción aqpb061
          insert into AQPB061
            (aqpb061pgcod,
             aqpb061mod,
             aqpb061suc,
             aqpb061mda,
             aqpb061pap,
             aqpb061cta,
             aqpb061oper,
             aqpb061sbop,
             aqpb061tope,
             aqpb061fpag,
             aqpb061tipo,
             aqpb061fval,
             aqpb061fvto,
             aqpb061pzo,
             aqpb061cap,
             aqpb061int,
             aqpb061intmex,
             aqpb061icap,
             aqpb061iint,
             aqpb061stat,
             aqpb061nume,
             aqpb061finv,
             aqpb061cd,
             aqpb061mo,
             aqpb061su,
             aqpb061tr,
             aqpb061re,
             aqpb061fc,
             aqpb061or,
             aqpb061sb,
             aqpb061co,
             aqpb061obop)
          
          values
            (k.pgcod,
             k.ppmod,
             k.ppsuc,
             k.ppmda,
             k.pppap,
             k.ppcta,
             k.ppoper,
             pn_aosbop, --k.ppsbop,
             k.pptope,
             k.ppfpag,
             k.pptipo,
             k.ppfval,
             k.ppfvto,
             k.pppzo,
             k.ppcap,
             k.ppint,
             k.ppintmex,
             k.ppicap,
             k.ppiint,
             k.ppstat,
             k.ppnume,
             k.ppfinv,
             k.d601cd,
             k.d601mo,
             k.d601su,
             k.d601tr,
             k.d601re,
             k.d601fc,
             k.d601or,
             k.d601sb,
             k.d601co,
             k.ppsbop);
        exception
          when others then
            -- lc_flag := 'N';
          
            lc_coderr := sqlcode;
            lc_msgerr := substr(trim(sqlerrm), 1, 90);
          
            insert into aqpb066
              (aqpb066fep,
               aqpb066cor,
               aqpb066emp,
               aqpb066mod,
               aqpb066suc,
               aqpb066mda,
               aqpb066pap,
               aqpb066cta,
               aqpb066ope,
               aqpb066sbo,
               aqpb066top,
               aqpb066tref,
               aqpb066etip,
               aqpb066eacoe,
               aqpb066eamsge)
            values
              (lc_fecha,
               200,
               pn_pgcod,
               pn_aomod,
               pn_aosuc,
               pn_aomda,
               pn_aopap,
               pn_aocta,
               pn_aooper,
               pn_aosbop,
               pn_aotope,
               'FSD601',
               'I',
               lc_coderr,
               lc_msgerr);
            commit;
          
        end;
      end loop;
      commit;
    
    else
    
      for k in jaqz520_fsd601(pn_pgcod,
                              pn_aomod,
                              pn_aosuc,
                              pn_aomda,
                              pn_aopap,
                              pn_aocta,
                              pn_aooper,
                              pn_aosbop,
                              pn_aotope) loop
        begin
          --Inserción aqpb061
          insert into AQPB061
            (aqpb061pgcod,
             aqpb061mod,
             aqpb061suc,
             aqpb061mda,
             aqpb061pap,
             aqpb061cta,
             aqpb061oper,
             aqpb061sbop,
             aqpb061tope,
             aqpb061fpag,
             aqpb061tipo,
             aqpb061fval,
             aqpb061fvto,
             aqpb061pzo,
             aqpb061cap,
             aqpb061int,
             aqpb061intmex,
             aqpb061icap,
             aqpb061iint,
             aqpb061stat,
             aqpb061nume,
             aqpb061finv,
             aqpb061cd,
             aqpb061mo,
             aqpb061su,
             aqpb061tr,
             aqpb061re,
             aqpb061fc,
             aqpb061or,
             aqpb061sb,
             aqpb061co,
             aqpb061obop)
          
          values
            (k.pgcod,
             k.ppmod,
             k.ppsuc,
             k.ppmda,
             k.pppap,
             k.ppcta,
             k.ppoper,
             pn_aosbop, --k.ppsbop,
             k.pptope,
             k.ppfpag,
             k.pptipo,
             k.ppfval,
             k.ppfvto,
             k.pppzo,
             k.ppcap,
             k.ppint,
             k.ppintmex,
             k.ppicap,
             k.ppiint,
             k.ppstat,
             k.ppnume,
             k.ppfinv,
             k.d601cd,
             k.d601mo,
             k.d601su,
             k.d601tr,
             k.d601re,
             k.d601fc,
             k.d601or,
             k.d601sb,
             k.d601co,
             k.ppsbop);
        exception
          when others then
            -- lc_flag := 'N';
          
            lc_coderr := sqlcode;
            lc_msgerr := substr(trim(sqlerrm), 1, 90);
          
            insert into aqpb066
              (aqpb066fep,
               aqpb066cor,
               aqpb066emp,
               aqpb066mod,
               aqpb066suc,
               aqpb066mda,
               aqpb066pap,
               aqpb066cta,
               aqpb066ope,
               aqpb066sbo,
               aqpb066top,
               aqpb066tref,
               aqpb066etip,
               aqpb066eacoe,
               aqpb066eamsge)
            values
              (lc_fecha,
               200,
               pn_pgcod,
               pn_aomod,
               pn_aosuc,
               pn_aomda,
               pn_aopap,
               pn_aocta,
               pn_aooper,
               pn_aosbop,
               pn_aotope,
               'FSD601',
               'I',
               lc_coderr,
               lc_msgerr);
            commit;
          
        end;
      end loop;
      commit;
    
    end if;
  
  end sp_insertar_FSD601;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --        

  PROCEDURE sp_insertar_FSD602(pn_pgcod  in number,
                               pn_aomod  in number,
                               pn_aosuc  in number,
                               pn_aomda  in number,
                               pn_aopap  in number,
                               pn_aocta  in number,
                               pn_aooper in number,
                               pn_aosbop in number,
                               pn_aotope in number) is
  
    lx_cont   number;
    lc_flag   char(1);
    lc_fecha  date;
    lc_coderr char(100);
    lc_msgerr char(100);
  
    ---ACTUAL
    cursor jaqz520_fsd602(cr_pgcod  number,
                          cr_aomod  number,
                          cr_aosuc  number,
                          cr_aomda  number,
                          cr_aopap  number,
                          cr_aocta  number,
                          cr_aooper number,
                          cr_aosbop number,
                          cr_aotope number) is
      select *
        from FSD602 t
       where t.pgcod = cr_pgcod
         and t.ppmod = cr_aomod
         and t.ppsuc = cr_aosuc
         and t.ppmda = cr_aomda
         and t.pppap = cr_aopap
         and t.ppcta = cr_aocta
         and t.ppoper = cr_aooper
         and t.ppsbop = cr_aosbop
         and t.pptope = cr_aotope
       order by t.ppfpag asc;
  
  begin
  
    select t.pgfape into lc_fecha from fst017 t where t.pgcod = 1;
  
    --Evaluar ACTUAL
    select count(*)
      into lx_cont
      from FSD602 t
     where t.pgcod = pn_pgcod
       and t.ppmod = pn_aomod
       and t.ppsuc = pn_aosuc
       and t.ppmda = pn_aomda
       and t.pppap = pn_aopap
       and t.ppcta = pn_aocta
       and t.ppoper = pn_aooper
       and t.ppsbop = 0
       and --pn_aosbop and
           t.pptope = pn_aotope;
  
    if lx_cont > 0 then
    
      for m in jaqz520_fsd602(pn_pgcod,
                              pn_aomod,
                              pn_aosuc,
                              pn_aomda,
                              pn_aopap,
                              pn_aocta,
                              pn_aooper,
                              0, --pn_aosbop
                              pn_aotope) loop
        begin
          insert into AQPB062
            (aqpb062pgcod,
             aqpb062mod,
             aqpb062suc,
             aqpb062mda,
             aqpb062pap,
             aqpb062cta,
             aqpb062oper,
             aqpb062sbop,
             aqpb062tope,
             aqpb062fpag,
             aqpb062tipo,
             aqpb062nump,
             aqpb062fech,
             aqpb062cap,
             aqpb062int,
             aqpb062intmex,
             aqpb062intm,
             aqpb062intmmex,
             aqpb062icap,
             aqpb062iint,
             aqpb062iintm,
             aqpb062salcap,
             aqpb062salint,
             aqpb062salade,
             aqpb062salmor,
             aqpb062stat,
             aqpb062salintm,
             aqpb062salmorm,
             aqpb062saladem,
             aqpb062cd,
             aqpb062mo,
             aqpb062su,
             aqpb062tr,
             aqpb062re,
             aqpb062fc,
             aqpb062or,
             aqpb062sb,
             aqpb062co,
             aqpb062obop)
          values
            (m.pgcod,
             m.ppmod,
             m.ppsuc,
             m.ppmda,
             m.pppap,
             m.ppcta,
             m.ppoper,
             pn_aosbop, --m.ppsbop,
             m.pptope,
             m.ppfpag,
             m.pptipo,
             m.pp1nump,
             m.pp1fech,
             m.pp1cap,
             m.pp1int,
             m.pp1intmex,
             m.pp1intm,
             m.pp1intmmex,
             m.pp1icap,
             m.pp1iint,
             m.pp1iintm,
             m.pp1salcap,
             m.pp1salint,
             m.pp1salade,
             m.pp1salmor,
             m.pp1stat,
             m.pp1salintm,
             m.pp1salmorm,
             m.pp1saladem,
             m.d602cd,
             m.d602mo,
             m.d602su,
             m.d602tr,
             m.d602re,
             m.d602fc,
             m.d602or,
             m.d602sb,
             m.d602co,
             m.ppsbop);
        exception
          when others then
            -- lc_flag := 'N';
          
            lc_coderr := sqlcode;
            lc_msgerr := substr(trim(sqlerrm), 1, 90);
          
            insert into aqpb066
              (aqpb066fep,
               aqpb066cor,
               aqpb066emp,
               aqpb066mod,
               aqpb066suc,
               aqpb066mda,
               aqpb066pap,
               aqpb066cta,
               aqpb066ope,
               aqpb066sbo,
               aqpb066top,
               aqpb066tref,
               aqpb066etip,
               aqpb066eacoe,
               aqpb066eamsge)
            values
              (lc_fecha,
               201,
               pn_pgcod,
               pn_aomod,
               pn_aosuc,
               pn_aomda,
               pn_aopap,
               pn_aocta,
               pn_aooper,
               pn_aosbop,
               pn_aotope,
               'FSD602',
               'I',
               lc_coderr,
               lc_msgerr);
            commit;
          
        end;
      end loop;
      commit;
    
    else
    
      for m in jaqz520_fsd602(pn_pgcod,
                              pn_aomod,
                              pn_aosuc,
                              pn_aomda,
                              pn_aopap,
                              pn_aocta,
                              pn_aooper,
                              pn_aosbop,
                              pn_aotope) loop
        begin
          insert into AQPB062
            (aqpb062pgcod,
             aqpb062mod,
             aqpb062suc,
             aqpb062mda,
             aqpb062pap,
             aqpb062cta,
             aqpb062oper,
             aqpb062sbop,
             aqpb062tope,
             aqpb062fpag,
             aqpb062tipo,
             aqpb062nump,
             aqpb062fech,
             aqpb062cap,
             aqpb062int,
             aqpb062intmex,
             aqpb062intm,
             aqpb062intmmex,
             aqpb062icap,
             aqpb062iint,
             aqpb062iintm,
             aqpb062salcap,
             aqpb062salint,
             aqpb062salade,
             aqpb062salmor,
             aqpb062stat,
             aqpb062salintm,
             aqpb062salmorm,
             aqpb062saladem,
             aqpb062cd,
             aqpb062mo,
             aqpb062su,
             aqpb062tr,
             aqpb062re,
             aqpb062fc,
             aqpb062or,
             aqpb062sb,
             aqpb062co,
             aqpb062obop)
          values
            (m.pgcod,
             m.ppmod,
             m.ppsuc,
             m.ppmda,
             m.pppap,
             m.ppcta,
             m.ppoper,
             pn_aosbop, --m.ppsbop,
             m.pptope,
             m.ppfpag,
             m.pptipo,
             m.pp1nump,
             m.pp1fech,
             m.pp1cap,
             m.pp1int,
             m.pp1intmex,
             m.pp1intm,
             m.pp1intmmex,
             m.pp1icap,
             m.pp1iint,
             m.pp1iintm,
             m.pp1salcap,
             m.pp1salint,
             m.pp1salade,
             m.pp1salmor,
             m.pp1stat,
             m.pp1salintm,
             m.pp1salmorm,
             m.pp1saladem,
             m.d602cd,
             m.d602mo,
             m.d602su,
             m.d602tr,
             m.d602re,
             m.d602fc,
             m.d602or,
             m.d602sb,
             m.d602co,
             m.ppsbop);
        exception
          when others then
            -- lc_flag := 'N';
          
            lc_coderr := sqlcode;
            lc_msgerr := substr(trim(sqlerrm), 1, 90);
          
            insert into aqpb066
              (aqpb066fep,
               aqpb066cor,
               aqpb066emp,
               aqpb066mod,
               aqpb066suc,
               aqpb066mda,
               aqpb066pap,
               aqpb066cta,
               aqpb066ope,
               aqpb066sbo,
               aqpb066top,
               aqpb066tref,
               aqpb066etip,
               aqpb066eacoe,
               aqpb066eamsge)
            values
              (lc_fecha,
               201,
               pn_pgcod,
               pn_aomod,
               pn_aosuc,
               pn_aomda,
               pn_aopap,
               pn_aocta,
               pn_aooper,
               pn_aosbop,
               pn_aotope,
               'FSD602',
               'I',
               lc_coderr,
               lc_msgerr);
            commit;
          
        end;
      end loop;
      commit;
    
    end if;
  
  end sp_insertar_FSD602;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   

  PROCEDURE sp_insertar_FSD611(pn_pgcod  in number,
                               pn_aomod  in number,
                               pn_aosuc  in number,
                               pn_aomda  in number,
                               pn_aopap  in number,
                               pn_aocta  in number,
                               pn_aooper in number,
                               pn_aosbop in number,
                               pn_aotope in number) is
  
    lx_cont   number;
    lc_flag   char(1);
    lc_fecha  date;
    lc_coderr char(100);
    lc_msgerr char(100);
  
    ---ACTUAL
    cursor jaqz520_fsd611(cr_pgcod  number,
                          cr_aomod  number,
                          cr_aosuc  number,
                          cr_aomda  number,
                          cr_aopap  number,
                          cr_aocta  number,
                          cr_aooper number,
                          cr_aosbop number,
                          cr_aotope number) is
      select *
        from FSD611 t
       where t.pgcod = cr_pgcod
         and t.ppmod = cr_aomod
         and t.ppsuc = cr_aosuc
         and t.ppmda = cr_aomda
         and t.pppap = cr_aopap
         and t.ppcta = cr_aocta
         and t.ppoper = cr_aooper
         and t.ppsbop = cr_aosbop
         and t.pptope = cr_aotope
       order by t.ppfpag asc;
  
  begin
  
    select t.pgfape into lc_fecha from fst017 t where t.pgcod = 1;
  
    --Evaluar ACTUAL
    select count(*)
      into lx_cont
      from FSD611 t
     where t.pgcod = pn_pgcod
       and t.ppmod = pn_aomod
       and t.ppsuc = pn_aosuc
       and t.ppmda = pn_aomda
       and t.pppap = pn_aopap
       and t.ppcta = pn_aocta
       and t.ppoper = pn_aooper
       and t.ppsbop = 0
       and --pn_aosbop and
           t.pptope = pn_aotope;
  
    if lx_cont > 0 then
    
      for p in jaqz520_fsd611(pn_pgcod,
                              pn_aomod,
                              pn_aosuc,
                              pn_aomda,
                              pn_aopap,
                              pn_aocta,
                              pn_aooper,
                              0, --pn_aosbop
                              pn_aotope) loop
        begin
        
          insert into AQPB063
            (aqpb063pgcod,
             aqpb063mod,
             aqpb063suc,
             aqpb063mda,
             aqpb063pap,
             aqpb063cta,
             aqpb063oper,
             aqpb063sbop,
             aqpb063tope,
             aqpb063fpag,
             aqpb063tipo,
             aqpb063exte,
             aqpb063imp1,
             aqpb063imp2,
             aqpb063imp3,
             aqpb063imp4,
             aqpb063imp5,
             aqpb063imp6,
             aqpb063imp7,
             aqpb063imp8,
             aqpb063imp9,
             aqpb063imp10,
             aqpb063imp11,
             aqpb063imp12,
             aqpb063imp13,
             aqpb063imp14,
             aqpb063imp15,
             aqpb063imp16,
             aqpb063imp17,
             aqpb063imp18,
             aqpb063imp19,
             aqpb063imp20,
             aqpb063obop)
          values
            (p.pgcod,
             p.ppmod,
             p.ppsuc,
             p.ppmda,
             p.pppap,
             p.ppcta,
             p.ppoper,
             pn_aosbop, -- p.ppsbop,
             p.pptope,
             p.ppfpag,
             p.pptipo,
             p.ppexte,
             p.ppimp1,
             p.ppimp2,
             p.ppimp3,
             p.ppimp4,
             p.ppimp5,
             p.ppimp6,
             p.ppimp7,
             p.ppimp8,
             p.ppimp9,
             p.ppimp10,
             p.ppimp11,
             p.ppimp12,
             p.ppimp13,
             p.ppimp14,
             p.ppimp15,
             p.ppimp16,
             p.ppimp17,
             p.ppimp18,
             p.ppimp19,
             p.ppimp20,
             p.ppsbop);
        exception
          when others then
            --  lc_flag := 'N';
          
            lc_coderr := sqlcode;
            lc_msgerr := substr(trim(sqlerrm), 1, 90);
          
            insert into aqpb066
              (aqpb066fep,
               aqpb066cor,
               aqpb066emp,
               aqpb066mod,
               aqpb066suc,
               aqpb066mda,
               aqpb066pap,
               aqpb066cta,
               aqpb066ope,
               aqpb066sbo,
               aqpb066top,
               aqpb066tref,
               aqpb066etip,
               aqpb066eacoe,
               aqpb066eamsge)
            values
              (lc_fecha,
               202,
               pn_pgcod,
               pn_aomod,
               pn_aosuc,
               pn_aomda,
               pn_aopap,
               pn_aocta,
               pn_aooper,
               pn_aosbop,
               pn_aotope,
               'FSD611',
               'I',
               lc_coderr,
               lc_msgerr);
            commit;
          
        end;
      end loop;
      commit;
    
    else
    
      for p in jaqz520_fsd611(pn_pgcod,
                              pn_aomod,
                              pn_aosuc,
                              pn_aomda,
                              pn_aopap,
                              pn_aocta,
                              pn_aooper,
                              pn_aosbop,
                              pn_aotope) loop
        begin
        
          insert into AQPB063
            (aqpb063pgcod,
             aqpb063mod,
             aqpb063suc,
             aqpb063mda,
             aqpb063pap,
             aqpb063cta,
             aqpb063oper,
             aqpb063sbop,
             aqpb063tope,
             aqpb063fpag,
             aqpb063tipo,
             aqpb063exte,
             aqpb063imp1,
             aqpb063imp2,
             aqpb063imp3,
             aqpb063imp4,
             aqpb063imp5,
             aqpb063imp6,
             aqpb063imp7,
             aqpb063imp8,
             aqpb063imp9,
             aqpb063imp10,
             aqpb063imp11,
             aqpb063imp12,
             aqpb063imp13,
             aqpb063imp14,
             aqpb063imp15,
             aqpb063imp16,
             aqpb063imp17,
             aqpb063imp18,
             aqpb063imp19,
             aqpb063imp20,
             aqpb063obop)
          values
            (p.pgcod,
             p.ppmod,
             p.ppsuc,
             p.ppmda,
             p.pppap,
             p.ppcta,
             p.ppoper,
             pn_aosbop, -- p.ppsbop,
             p.pptope,
             p.ppfpag,
             p.pptipo,
             p.ppexte,
             p.ppimp1,
             p.ppimp2,
             p.ppimp3,
             p.ppimp4,
             p.ppimp5,
             p.ppimp6,
             p.ppimp7,
             p.ppimp8,
             p.ppimp9,
             p.ppimp10,
             p.ppimp11,
             p.ppimp12,
             p.ppimp13,
             p.ppimp14,
             p.ppimp15,
             p.ppimp16,
             p.ppimp17,
             p.ppimp18,
             p.ppimp19,
             p.ppimp20,
             p.ppsbop);
        exception
          when others then
            --  lc_flag := 'N';
          
            lc_coderr := sqlcode;
            lc_msgerr := substr(trim(sqlerrm), 1, 90);
          
            insert into aqpb066
              (aqpb066fep,
               aqpb066cor,
               aqpb066emp,
               aqpb066mod,
               aqpb066suc,
               aqpb066mda,
               aqpb066pap,
               aqpb066cta,
               aqpb066ope,
               aqpb066sbo,
               aqpb066top,
               aqpb066tref,
               aqpb066etip,
               aqpb066eacoe,
               aqpb066eamsge)
            values
              (lc_fecha,
               202,
               pn_pgcod,
               pn_aomod,
               pn_aosuc,
               pn_aomda,
               pn_aopap,
               pn_aocta,
               pn_aooper,
               pn_aosbop,
               pn_aotope,
               'FSD611',
               'I',
               lc_coderr,
               lc_msgerr);
            commit;
          
        end;
      end loop;
      commit;
    
    end if;
  
  end sp_insertar_FSD611;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_FPP001(pn_pgcod  in number,
                               pn_aomod  in number,
                               pn_aosuc  in number,
                               pn_aomda  in number,
                               pn_aopap  in number,
                               pn_aocta  in number,
                               pn_aooper in number,
                               pn_aosbop in number,
                               pn_aotope in number) is
  
    lx_cont   number;
    lc_flag   char(1);
    lc_fecha  date;
    lc_coderr char(100);
    lc_msgerr char(100);
  
    ---ACTUAL           
    cursor jaqz520_fpp001(cr_pgcod  number,
                          cr_aomod  number,
                          cr_aosuc  number,
                          cr_aomda  number,
                          cr_aopap  number,
                          cr_aocta  number,
                          cr_aooper number,
                          cr_aosbop number,
                          cr_aotope number) is
      select *
        from FPP001 t
       where t.pgcod = cr_pgcod
         and t.aomod = cr_aomod
         and t.aosuc = cr_aosuc
         and t.aomda = cr_aomda
         and t.aopap = cr_aopap
         and t.aocta = cr_aocta
         and t.aooper = cr_aooper
         and t.aosbop = cr_aosbop
         and t.aotope = cr_aotope;
  
  begin
  
    select t.pgfape into lc_fecha from fst017 t where t.pgcod = 1;
  
    --Evaluar ACTUAL
    select count(*)
      into lx_cont
      from FPP001 t
     where t.pgcod = pn_pgcod
       and t.aomod = pn_aomod
       and t.aosuc = pn_aosuc
       and t.aomda = pn_aomda
       and t.aopap = pn_aopap
       and t.aocta = pn_aocta
       and t.aooper = pn_aooper
       and t.aosbop = 0 --pn_aosbop and
       and t.aotope = pn_aotope;
  
    if lx_cont > 0 then
    
      for q in jaqz520_fpp001(pn_pgcod,
                              pn_aomod,
                              pn_aosuc,
                              pn_aomda,
                              pn_aopap,
                              pn_aocta,
                              pn_aooper,
                              0, --pn_aosbop
                              pn_aotope) loop
        begin
        
          insert into aqpa974
            (aqpa974pgcod,
             aqpa974mod,
             aqpa974suc,
             aqpa974mda,
             aqpa974pap,
             aqpa974cta,
             aqpa974oper,
             aqpa974sbop,
             aqpa974tope,
             aqpa974sgcod,
             aqpa974vc,
             aqpa974imp,
             aqpa974porc,
             aqpa974plus,
             aqpa974part,
             aqpa974veh,
             aqpa974inm,
             aqpa974end,
             aqpa974stat,
             aqpa974co,
             aqpa974aux1,
             aqpa974aux2,
             aqpa974aux3,
             aqpa974aux4,
             aqpa974aux5,
             aqpa974aux6,
             aqpa974aux7,
             aqpa974obop)
          values
            (q.pgcod,
             q.aomod,
             q.aosuc,
             q.aomda,
             q.aopap,
             q.aocta,
             q.aooper,
             pn_aosbop, --q.aosbop,
             q.aotope,
             q.sgcod,
             q.pp001vc,
             q.pp001imp,
             q.pp001porc,
             q.pp001plus,
             q.pp001part,
             q.pp001veh,
             q.pp001inm,
             q.pp001end,
             q.pp001stat,
             q.pp001co,
             q.pp001aux1,
             q.pp001aux2,
             q.pp001aux3,
             q.pp001aux4,
             q.pp001aux5,
             q.pp001aux6,
             q.pp001aux7,
             q.aosbop);
        exception
          when others then
            --lc_flag := 'N';
          
            lc_coderr := sqlcode;
            lc_msgerr := substr(trim(sqlerrm), 1, 90);
          
            insert into aqpb066
              (aqpb066fep,
               aqpb066cor,
               aqpb066emp,
               aqpb066mod,
               aqpb066suc,
               aqpb066mda,
               aqpb066pap,
               aqpb066cta,
               aqpb066ope,
               aqpb066sbo,
               aqpb066top,
               aqpb066tref,
               aqpb066etip,
               aqpb066eacoe,
               aqpb066eamsge)
            values
              (lc_fecha,
               203,
               pn_pgcod,
               pn_aomod,
               pn_aosuc,
               pn_aomda,
               pn_aopap,
               pn_aocta,
               pn_aooper,
               pn_aosbop,
               pn_aotope,
               'FPP001',
               'I',
               lc_coderr,
               lc_msgerr);
            commit;
          
        end;
      end loop;
      commit;
    
    else
    
      for q in jaqz520_fpp001(pn_pgcod,
                              pn_aomod,
                              pn_aosuc,
                              pn_aomda,
                              pn_aopap,
                              pn_aocta,
                              pn_aooper,
                              pn_aosbop,
                              pn_aotope) loop
        begin
        
          insert into aqpa974
            (aqpa974pgcod,
             aqpa974mod,
             aqpa974suc,
             aqpa974mda,
             aqpa974pap,
             aqpa974cta,
             aqpa974oper,
             aqpa974sbop,
             aqpa974tope,
             aqpa974sgcod,
             aqpa974vc,
             aqpa974imp,
             aqpa974porc,
             aqpa974plus,
             aqpa974part,
             aqpa974veh,
             aqpa974inm,
             aqpa974end,
             aqpa974stat,
             aqpa974co,
             aqpa974aux1,
             aqpa974aux2,
             aqpa974aux3,
             aqpa974aux4,
             aqpa974aux5,
             aqpa974aux6,
             aqpa974aux7,
             aqpa974obop)
          values
            (q.pgcod,
             q.aomod,
             q.aosuc,
             q.aomda,
             q.aopap,
             q.aocta,
             q.aooper,
             pn_aosbop, --q.aosbop,
             q.aotope,
             q.sgcod,
             q.pp001vc,
             q.pp001imp,
             q.pp001porc,
             q.pp001plus,
             q.pp001part,
             q.pp001veh,
             q.pp001inm,
             q.pp001end,
             q.pp001stat,
             q.pp001co,
             q.pp001aux1,
             q.pp001aux2,
             q.pp001aux3,
             q.pp001aux4,
             q.pp001aux5,
             q.pp001aux6,
             q.pp001aux7,
             q.aosbop);
        exception
          when others then
            --lc_flag := 'N';
          
            lc_coderr := sqlcode;
            lc_msgerr := substr(trim(sqlerrm), 1, 90);
          
            insert into aqpb066
              (aqpb066fep,
               aqpb066cor,
               aqpb066emp,
               aqpb066mod,
               aqpb066suc,
               aqpb066mda,
               aqpb066pap,
               aqpb066cta,
               aqpb066ope,
               aqpb066sbo,
               aqpb066top,
               aqpb066tref,
               aqpb066etip,
               aqpb066eacoe,
               aqpb066eamsge)
            values
              (lc_fecha,
               203,
               pn_pgcod,
               pn_aomod,
               pn_aosuc,
               pn_aomda,
               pn_aopap,
               pn_aocta,
               pn_aooper,
               pn_aosbop,
               pn_aotope,
               'FPP001',
               'I',
               lc_coderr,
               lc_msgerr);
            commit;
          
        end;
      end loop;
      commit;
    
    end if;
  
  end sp_insertar_FPP001;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   

  PROCEDURE sp_insertar_FPP002(pn_pgcod  in number,
                               pn_aomod  in number,
                               pn_aosuc  in number,
                               pn_aomda  in number,
                               pn_aopap  in number,
                               pn_aocta  in number,
                               pn_aooper in number,
                               pn_aosbop in number,
                               pn_aotope in number) is
  
    lx_cont   number;
    lc_flag   char(1);
    lc_fecha  date;
    lc_coderr char(100);
    lc_msgerr char(100);
  
    ---ACTUAL
    cursor jaqz520_fpp002(cr_pgcod  number,
                          cr_aomod  number,
                          cr_aosuc  number,
                          cr_aomda  number,
                          cr_aopap  number,
                          cr_aocta  number,
                          cr_aooper number,
                          cr_aosbop number,
                          cr_aotope number) is
      select *
        from FPP002 t
       where t.pgcod = cr_pgcod
         and t.ppmod = cr_aomod
         and t.ppsuc = cr_aosuc
         and t.ppmda = cr_aomda
         and t.pppap = cr_aopap
         and t.ppcta = cr_aocta
         and t.ppoper = cr_aooper
         and t.ppsbop = cr_aosbop
         and t.pptope = cr_aotope;
  
  begin
  
    select t.pgfape into lc_fecha from fst017 t where t.pgcod = 1;
  
    --Evaluar ACTUAL
    select count(*)
      into lx_cont
      from FPP002 t
     where t.pgcod = pn_pgcod
       and t.ppmod = pn_aomod
       and t.ppsuc = pn_aosuc
       and t.ppmda = pn_aomda
       and t.pppap = pn_aopap
       and t.ppcta = pn_aocta
       and t.ppoper = pn_aooper
       and t.ppsbop = 0
       and --pn_aosbop
           t.pptope = pn_aotope;
  
    if lx_cont > 0 then
    
      for r in jaqz520_fpp002(pn_pgcod,
                              pn_aomod,
                              pn_aosuc,
                              pn_aomda,
                              pn_aopap,
                              pn_aocta,
                              pn_aooper,
                              0, --pn_aosbop
                              pn_aotope) loop
        begin
        
          insert into aqpa973
            (aqpa973cod,
             aqpa973mod,
             aqpa973suc,
             aqpa973mda,
             aqpa973pap,
             aqpa973cta,
             aqpa973oper,
             aqpa973sbop,
             aqpa973tope,
             aqpa973fpag,
             aqpa973tipo,
             aqpa973estconc,
             aqpa973imp,
             aqpa973stat,
             aqpa973aux1,
             aqpa973aux2,
             aqpa973aux3,
             aqpa973obop)
          values
            (r.pgcod,
             r.ppmod,
             r.ppsuc,
             r.ppmda,
             r.pppap,
             r.ppcta,
             r.ppoper,
             pn_aosbop, --r.ppsbop,
             r.pptope,
             r.ppfpag,
             r.pptipo,
             r.prestconc,
             r.pp002imp,
             r.pp002stat,
             r.pp002aux1,
             r.pp002aux2,
             r.pp002aux3,
             r.ppsbop);
        exception
          when others then
            --   lc_flag := 'N';
          
            lc_coderr := sqlcode;
            lc_msgerr := substr(trim(sqlerrm), 1, 90);
          
            insert into aqpb066
              (aqpb066fep,
               aqpb066cor,
               aqpb066emp,
               aqpb066mod,
               aqpb066suc,
               aqpb066mda,
               aqpb066pap,
               aqpb066cta,
               aqpb066ope,
               aqpb066sbo,
               aqpb066top,
               aqpb066tref,
               aqpb066etip,
               aqpb066eacoe,
               aqpb066eamsge)
            values
              (lc_fecha,
               204,
               pn_pgcod,
               pn_aomod,
               pn_aosuc,
               pn_aomda,
               pn_aopap,
               pn_aocta,
               pn_aooper,
               pn_aosbop,
               pn_aotope,
               'FPP002',
               'I',
               lc_coderr,
               lc_msgerr);
            commit;
          
        end;
      end loop;
      commit;
    
    else
    
      for r in jaqz520_fpp002(pn_pgcod,
                              pn_aomod,
                              pn_aosuc,
                              pn_aomda,
                              pn_aopap,
                              pn_aocta,
                              pn_aooper,
                              pn_aosbop,
                              pn_aotope) loop
        begin
        
          insert into aqpa973
            (aqpa973cod,
             aqpa973mod,
             aqpa973suc,
             aqpa973mda,
             aqpa973pap,
             aqpa973cta,
             aqpa973oper,
             aqpa973sbop,
             aqpa973tope,
             aqpa973fpag,
             aqpa973tipo,
             aqpa973estconc,
             aqpa973imp,
             aqpa973stat,
             aqpa973aux1,
             aqpa973aux2,
             aqpa973aux3,
             aqpa973obop)
          values
            (r.pgcod,
             r.ppmod,
             r.ppsuc,
             r.ppmda,
             r.pppap,
             r.ppcta,
             r.ppoper,
             pn_aosbop, --r.ppsbop,
             r.pptope,
             r.ppfpag,
             r.pptipo,
             r.prestconc,
             r.pp002imp,
             r.pp002stat,
             r.pp002aux1,
             r.pp002aux2,
             r.pp002aux3,
             r.ppsbop);
        exception
          when others then
            --   lc_flag := 'N';
          
            lc_coderr := sqlcode;
            lc_msgerr := substr(trim(sqlerrm), 1, 90);
          
            insert into aqpb066
              (aqpb066fep,
               aqpb066cor,
               aqpb066emp,
               aqpb066mod,
               aqpb066suc,
               aqpb066mda,
               aqpb066pap,
               aqpb066cta,
               aqpb066ope,
               aqpb066sbo,
               aqpb066top,
               aqpb066tref,
               aqpb066etip,
               aqpb066eacoe,
               aqpb066eamsge)
            values
              (lc_fecha,
               204,
               pn_pgcod,
               pn_aomod,
               pn_aosuc,
               pn_aomda,
               pn_aopap,
               pn_aocta,
               pn_aooper,
               pn_aosbop,
               pn_aotope,
               'FPP002',
               'I',
               lc_coderr,
               lc_msgerr);
            commit;
          
        end;
      end loop;
      commit;
    
    end if;
  
  end sp_insertar_FPP002;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    

  PROCEDURE sp_insertar_X054023(pn_pgcod  in number,
                                pn_aomod  in number,
                                pn_aosuc  in number,
                                pn_aomda  in number,
                                pn_aopap  in number,
                                pn_aocta  in number,
                                pn_aooper in number,
                                pn_aosbop in number,
                                pn_aotope in number) is
  
    lx_cont   number;
    lc_flag   char(1);
    lc_fecha  date;
    lc_coderr char(100);
    lc_msgerr char(100);
  
    ---ACTUAL   
    cursor jaqz520_x054023(cr_pgcod  number,
                           cr_aomod  number,
                           cr_aosuc  number,
                           cr_aomda  number,
                           cr_aopap  number,
                           cr_aocta  number,
                           cr_aooper number,
                           cr_aosbop number,
                           cr_aotope number) is
      select *
        from X054023 t
       where t.xllpgcod = cr_pgcod
         and t.xllaomod = cr_aomod
         and t.xllaosuc = cr_aosuc
         and t.xllaomda = cr_aomda
         and t.xllaopap = cr_aopap
         and t.xllaocta = cr_aocta
         and t.xllaooper = cr_aooper
         and t.xllaosbop = cr_aosbop
         and t.xllaotop = cr_aotope;
  
  begin
  
    select t.pgfape into lc_fecha from fst017 t where t.pgcod = 1;
  
    --Evaluar ACTUAL
    select count(*)
      into lx_cont
      from X054023 t
     where t.xllpgcod = pn_pgcod
       and t.xllaomod = pn_aomod
       and t.xllaosuc = pn_aosuc
       and t.xllaomda = pn_aomda
       and t.xllaopap = pn_aopap
       and t.xllaocta = pn_aocta
       and t.xllaooper = pn_aooper
       and t.xllaosbop = 0
       and --pn_aosbop
           t.xllaotop = pn_aotope;
  
    if lx_cont > 0 then
    
      for s in jaqz520_x054023(pn_pgcod,
                               pn_aomod,
                               pn_aosuc,
                               pn_aomda,
                               pn_aopap,
                               pn_aocta,
                               pn_aooper,
                               0, --pn_aosbop,
                               pn_aotope) loop
        begin
        
          insert into aqpb060
            (aqpb060pgcod,
             aqpb060aomod,
             aqpb060aosuc,
             aqpb060aomda,
             aqpb060aopap,
             aqpb060aocta,
             aqpb060aooper,
             aqpb060aosbop,
             aqpb060aotop,
             aqpb060fvalor,
             aqpb060capital,
             aqpb060fprimpa,
             aqpb060cantcuo,
             aqpb060periodo,
             aqpb060tipopre,
             aqpb060tipodia,
             aqpb060tipotas,
             aqpb060tasap,
             aqpb060gradper,
             aqpb060gradpor,
             aqpb060gradimp,
             aqpb060tipoano,
             aqpb060tipdiap,
             aqpb060pcltcod,
             aqpb060pclplus,
             aqpb060pcldrev,
             aqpb060tferp,
             aqpb060cntcuoi,
             aqpb060fpripag,
             aqpb060plazo,
             aqpb060fvto,
             aqpb060modocal,
             aqpb060gracfij,
             aqpb060ciud,
             aqpb060capliq,
             aqpb060medico,
             aqpb060financ,
             aqpb060tasaej,
             aqpb060valcan,
             aqpb060valcuo,
             aqpb060capfin,
             aqpb060impu,
             aqpb060aux1,
             aqpb060aux2,
             aqpb060aux3,
             aqpb060aux4,
             aqpb060aux5,
             aqpb060redon,
             aqpb060aux6,
             aqpb060precio,
             aqpb060aoobop)
          values
            (s.xllpgcod,
             s.xllaomod,
             s.xllaosuc,
             s.xllaomda,
             s.xllaopap,
             s.xllaocta,
             s.xllaooper,
             pn_aosbop, --s.xllaosbop,
             s.xllaotop,
             s.xllfvalor,
             s.xllcapital,
             s.xllfprimpa,
             s.xllcantcuo,
             s.xllperiodo,
             s.xlltipopre,
             s.xlltipodia,
             s.xlltipotas,
             s.xlltasap,
             s.xllgradper,
             s.xllgradpor,
             s.xllgradimp,
             s.xlltipoano,
             s.xlltipdiap,
             s.xllpcltcod,
             s.xllpclplus,
             s.xllpcldrev,
             s.xlltferp,
             s.xllcntcuoi,
             s.xllfpripag,
             s.xllplazo,
             s.xllfvto,
             s.xllmodocal,
             s.xllgracfij,
             s.xllciud,
             s.xllcapliq,
             s.xllmedico,
             s.xllfinanc,
             s.xlltasaej,
             s.xllvalcan,
             s.xllvalcuo,
             s.xllcapfin,
             s.xllimpu,
             s.xllaux1,
             s.xllaux2,
             s.xllaux3,
             s.xllaux4,
             s.xllaux5,
             s.xllredon,
             s.xllaux6,
             s.xllprecio,
             s.xllaosbop);
        exception
          when others then
            --lc_flag := 'N';
          
            lc_coderr := sqlcode;
            lc_msgerr := substr(trim(sqlerrm), 1, 90);
          
            insert into aqpb066
              (aqpb066fep,
               aqpb066cor,
               aqpb066emp,
               aqpb066mod,
               aqpb066suc,
               aqpb066mda,
               aqpb066pap,
               aqpb066cta,
               aqpb066ope,
               aqpb066sbo,
               aqpb066top,
               aqpb066tref,
               aqpb066etip,
               aqpb066eacoe,
               aqpb066eamsge)
            values
              (lc_fecha,
               205,
               pn_pgcod,
               pn_aomod,
               pn_aosuc,
               pn_aomda,
               pn_aopap,
               pn_aocta,
               pn_aooper,
               pn_aosbop,
               pn_aotope,
               'X054023',
               'I',
               lc_coderr,
               lc_msgerr);
            commit;
          
        end;
      end loop;
      commit;
    
    else
    
      for s in jaqz520_x054023(pn_pgcod,
                               pn_aomod,
                               pn_aosuc,
                               pn_aomda,
                               pn_aopap,
                               pn_aocta,
                               pn_aooper,
                               pn_aosbop,
                               pn_aotope) loop
        begin
        
          insert into aqpb060
            (aqpb060pgcod,
             aqpb060aomod,
             aqpb060aosuc,
             aqpb060aomda,
             aqpb060aopap,
             aqpb060aocta,
             aqpb060aooper,
             aqpb060aosbop,
             aqpb060aotop,
             aqpb060fvalor,
             aqpb060capital,
             aqpb060fprimpa,
             aqpb060cantcuo,
             aqpb060periodo,
             aqpb060tipopre,
             aqpb060tipodia,
             aqpb060tipotas,
             aqpb060tasap,
             aqpb060gradper,
             aqpb060gradpor,
             aqpb060gradimp,
             aqpb060tipoano,
             aqpb060tipdiap,
             aqpb060pcltcod,
             aqpb060pclplus,
             aqpb060pcldrev,
             aqpb060tferp,
             aqpb060cntcuoi,
             aqpb060fpripag,
             aqpb060plazo,
             aqpb060fvto,
             aqpb060modocal,
             aqpb060gracfij,
             aqpb060ciud,
             aqpb060capliq,
             aqpb060medico,
             aqpb060financ,
             aqpb060tasaej,
             aqpb060valcan,
             aqpb060valcuo,
             aqpb060capfin,
             aqpb060impu,
             aqpb060aux1,
             aqpb060aux2,
             aqpb060aux3,
             aqpb060aux4,
             aqpb060aux5,
             aqpb060redon,
             aqpb060aux6,
             aqpb060precio,
             aqpb060aoobop)
          values
            (s.xllpgcod,
             s.xllaomod,
             s.xllaosuc,
             s.xllaomda,
             s.xllaopap,
             s.xllaocta,
             s.xllaooper,
             pn_aosbop, --s.xllaosbop,
             s.xllaotop,
             s.xllfvalor,
             s.xllcapital,
             s.xllfprimpa,
             s.xllcantcuo,
             s.xllperiodo,
             s.xlltipopre,
             s.xlltipodia,
             s.xlltipotas,
             s.xlltasap,
             s.xllgradper,
             s.xllgradpor,
             s.xllgradimp,
             s.xlltipoano,
             s.xlltipdiap,
             s.xllpcltcod,
             s.xllpclplus,
             s.xllpcldrev,
             s.xlltferp,
             s.xllcntcuoi,
             s.xllfpripag,
             s.xllplazo,
             s.xllfvto,
             s.xllmodocal,
             s.xllgracfij,
             s.xllciud,
             s.xllcapliq,
             s.xllmedico,
             s.xllfinanc,
             s.xlltasaej,
             s.xllvalcan,
             s.xllvalcuo,
             s.xllcapfin,
             s.xllimpu,
             s.xllaux1,
             s.xllaux2,
             s.xllaux3,
             s.xllaux4,
             s.xllaux5,
             s.xllredon,
             s.xllaux6,
             s.xllprecio,
             s.xllaosbop);
        exception
          when others then
            --lc_flag := 'N';
          
            lc_coderr := sqlcode;
            lc_msgerr := substr(trim(sqlerrm), 1, 90);
          
            insert into aqpb066
              (aqpb066fep,
               aqpb066cor,
               aqpb066emp,
               aqpb066mod,
               aqpb066suc,
               aqpb066mda,
               aqpb066pap,
               aqpb066cta,
               aqpb066ope,
               aqpb066sbo,
               aqpb066top,
               aqpb066tref,
               aqpb066etip,
               aqpb066eacoe,
               aqpb066eamsge)
            values
              (lc_fecha,
               205,
               pn_pgcod,
               pn_aomod,
               pn_aosuc,
               pn_aomda,
               pn_aopap,
               pn_aocta,
               pn_aooper,
               pn_aosbop,
               pn_aotope,
               'X054023',
               'I',
               lc_coderr,
               lc_msgerr);
            commit;
          
        end;
      end loop;
      commit;
    
    end if;
  
  end sp_insertar_X054023;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_FSD012(pn_pgcod  in number,
                               pn_aomod  in number,
                               pn_aosuc  in number,
                               pn_aomda  in number,
                               pn_aopap  in number,
                               pn_aocta  in number,
                               pn_aooper in number,
                               pn_aosbop in number,
                               pn_aotope in number) is
  
    lx_cont   number;
    lc_flag   char(1);
    lc_fecha  date;
    lc_coderr char(100);
    lc_msgerr char(100);
  
    ---MARZO: FSD012   
    cursor jaqz520_fsd012(cr_pgcod  number,
                          cr_aomod  number,
                          cr_aosuc  number,
                          cr_aomda  number,
                          cr_aopap  number,
                          cr_aocta  number,
                          cr_aooper number,
                          cr_aosbop number,
                          cr_aotope number) is
      select *
        from FSD012 t
       where t.pgcod = cr_pgcod
         and t.aomod = cr_aomod
         and t.aosuc = cr_aosuc
         and t.aomda = cr_aomda
         and t.aopap = cr_aopap
         and t.aocta = cr_aocta
         and t.aooper = cr_aooper
         and t.aosbop = cr_aosbop
         and t.aotope = cr_aotope;
  
  begin
  
    select t.pgfape into lc_fecha from fst017 t where t.pgcod = 1;
  
    --Evaluar ACTUAL
    select count(*)
      into lx_cont
      from FSD012 t
     where t.pgcod = pn_pgcod
       and t.aomod = pn_aomod
       and t.aosuc = pn_aosuc
       and t.aomda = pn_aomda
       and t.aopap = pn_aopap
       and t.aocta = pn_aocta
       and t.aooper = pn_aooper
       and t.aosbop = 0
       and --pn_aosbop
           t.aotope = pn_aotope;
  
    if lx_cont > 0 then
    
      for u in jaqz520_fsd012(pn_pgcod,
                              pn_aomod,
                              pn_aosuc,
                              pn_aomda,
                              pn_aopap,
                              pn_aocta,
                              pn_aooper,
                              0, --pn_aosbop,
                              pn_aotope) loop
        begin
        
          insert into AQPA975
            (aqpa975cod,
             aqpa975mod,
             aqpa975suc,
             aqpa975mda,
             aqpa975pap,
             aqpa975cta,
             aqpa975oper,
             aqpa975sbop,
             aqpa975tope,
             aqpa975corr,
             aqpa975tipo,
             aqpa975fval,
             aqpa975fvto,
             aqpa975imp,
             aqpa975ttas,
             aqpa975tasa,
             aqpa975cap,
             aqpa975int,
             aqpa975mor,
             aqpa975scap,
             aqpa975sint,
             aqpa975smor,
             aqpa975intc,
             aqpa975morc,
             aqpa975cd01,
             aqpa975cd02,
             aqpa975inv,
             aqpa975per,
             aqpa975tcbi,
             aqpa975tcbi1,
             aqpa975arb,
             aqpa975arb1,
             aqpa975md,
             aqpa975md1,
             aqpa975pre,
             aqpa975pre1,
             aqpa975cd,
             aqpa975mo,
             aqpa975su,
             aqpa975tr,
             aqpa975re,
             aqpa975fc,
             aqpa975or,
             aqpa975sb,
             aqpa975co,
             aqpa975obop)
          values
            (u.pgcod,
             u.aomod,
             u.aosuc,
             u.aomda,
             u.aopap,
             u.aocta,
             u.aooper,
             pn_aosbop, --u.aosbop,
             u.aotope,
             u.evcorr,
             u.evtipo,
             u.evfval,
             u.evfvto,
             u.evimp,
             u.evttas,
             u.evtasa,
             u.evcap,
             u.evint,
             u.evmor,
             u.evscap,
             u.evsint,
             u.evsmor,
             u.evintc,
             u.evmorc,
             u.evcd01,
             u.evcd02,
             u.evinv,
             u.evper,
             u.evtcbi,
             u.evtcbi1,
             u.evarb,
             u.evarb1,
             u.evmd,
             u.evmd1,
             u.evpre,
             u.evpre1,
             u.d012cd,
             u.d012mo,
             u.d012su,
             u.d012tr,
             u.d012re,
             u.d012fc,
             u.d012or,
             u.d012sb,
             u.d012co,
             u.aosbop);
        exception
          when others then
            --lc_flag := 'N';
            lc_coderr := sqlcode;
            lc_msgerr := substr(trim(sqlerrm), 1, 90);
          
            insert into aqpb066
              (aqpb066fep,
               aqpb066cor,
               aqpb066emp,
               aqpb066mod,
               aqpb066suc,
               aqpb066mda,
               aqpb066pap,
               aqpb066cta,
               aqpb066ope,
               aqpb066sbo,
               aqpb066top,
               aqpb066tref,
               aqpb066etip,
               aqpb066eacoe,
               aqpb066eamsge)
            values
              (lc_fecha,
               206,
               pn_pgcod,
               pn_aomod,
               pn_aosuc,
               pn_aomda,
               pn_aopap,
               pn_aocta,
               pn_aooper,
               pn_aosbop,
               pn_aotope,
               'FSD012',
               'I',
               lc_coderr,
               lc_msgerr);
            commit;
          
        end;
      end loop;
      commit;
    
    else
    
      for u in jaqz520_fsd012(pn_pgcod,
                              pn_aomod,
                              pn_aosuc,
                              pn_aomda,
                              pn_aopap,
                              pn_aocta,
                              pn_aooper,
                              pn_aosbop,
                              pn_aotope) loop
        begin
        
          insert into AQPA975
            (aqpa975cod,
             aqpa975mod,
             aqpa975suc,
             aqpa975mda,
             aqpa975pap,
             aqpa975cta,
             aqpa975oper,
             aqpa975sbop,
             aqpa975tope,
             aqpa975corr,
             aqpa975tipo,
             aqpa975fval,
             aqpa975fvto,
             aqpa975imp,
             aqpa975ttas,
             aqpa975tasa,
             aqpa975cap,
             aqpa975int,
             aqpa975mor,
             aqpa975scap,
             aqpa975sint,
             aqpa975smor,
             aqpa975intc,
             aqpa975morc,
             aqpa975cd01,
             aqpa975cd02,
             aqpa975inv,
             aqpa975per,
             aqpa975tcbi,
             aqpa975tcbi1,
             aqpa975arb,
             aqpa975arb1,
             aqpa975md,
             aqpa975md1,
             aqpa975pre,
             aqpa975pre1,
             aqpa975cd,
             aqpa975mo,
             aqpa975su,
             aqpa975tr,
             aqpa975re,
             aqpa975fc,
             aqpa975or,
             aqpa975sb,
             aqpa975co,
             aqpa975obop)
          values
            (u.pgcod,
             u.aomod,
             u.aosuc,
             u.aomda,
             u.aopap,
             u.aocta,
             u.aooper,
             pn_aosbop, --u.aosbop,
             u.aotope,
             u.evcorr,
             u.evtipo,
             u.evfval,
             u.evfvto,
             u.evimp,
             u.evttas,
             u.evtasa,
             u.evcap,
             u.evint,
             u.evmor,
             u.evscap,
             u.evsint,
             u.evsmor,
             u.evintc,
             u.evmorc,
             u.evcd01,
             u.evcd02,
             u.evinv,
             u.evper,
             u.evtcbi,
             u.evtcbi1,
             u.evarb,
             u.evarb1,
             u.evmd,
             u.evmd1,
             u.evpre,
             u.evpre1,
             u.d012cd,
             u.d012mo,
             u.d012su,
             u.d012tr,
             u.d012re,
             u.d012fc,
             u.d012or,
             u.d012sb,
             u.d012co,
             u.aosbop);
        exception
          when others then
            --lc_flag := 'N';
            lc_coderr := sqlcode;
            lc_msgerr := substr(trim(sqlerrm), 1, 90);
          
            insert into aqpb066
              (aqpb066fep,
               aqpb066cor,
               aqpb066emp,
               aqpb066mod,
               aqpb066suc,
               aqpb066mda,
               aqpb066pap,
               aqpb066cta,
               aqpb066ope,
               aqpb066sbo,
               aqpb066top,
               aqpb066tref,
               aqpb066etip,
               aqpb066eacoe,
               aqpb066eamsge)
            values
              (lc_fecha,
               206,
               pn_pgcod,
               pn_aomod,
               pn_aosuc,
               pn_aomda,
               pn_aopap,
               pn_aocta,
               pn_aooper,
               pn_aosbop,
               pn_aotope,
               'FSD012',
               'I',
               lc_coderr,
               lc_msgerr);
            commit;
          
        end;
      end loop;
      commit;
    
    end if;
  
  end sp_insertar_FSD012;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  PROCEDURE sp_generar_registros(pn_fecha_ini in date,
                                 pn_fecha_fin in date) is
  
    ln_estado number;
    lx_aosuc  number;
    lx_sbop   number;
    lx_top    number;
  
    cursor creditos(fecha_ini date, fecha_fin date) is
      select x.emp, x.modu, x.mda, x.pap, x.cta, x.ope, x.top
        from (select j.jaqz698emp emp,
                     j.jaqz698mod modu,
                     j.jaqz698mda mda,
                     j.jaqz698pap pap,
                     j.jaqz698cta cta,
                     j.jaqz698ope ope,
                     j.jaqz698top top,
                     'JAQZ698' tabla
                from jaqz698 j
               where j.jaqz698est in ('C', 'V')
                 and j.jaqz698fep >= fecha_ini
                 and j.jaqz698fep <= fecha_fin
              
              union all
              
              select t.aqpb002emp emp,
                     t.aqpb002mod modu,
                     t.aqpb002mda mda,
                     t.aqpb002pap pap,
                     t.aqpb002cta cta,
                     t.aqpb002ope ope,
                     t.aqpb002top top,
                     'AQPB002' tabla
                from aqpb002 t
               where t.aqpb002est = 'C'
                 and t.aqpb002fep >= fecha_ini
                 and t.aqpb002fep <= fecha_fin
              
              union all
              
              select s.jaqa255emp emp,
                     s.jaqa255mod modu,
                     s.jaqa255mda mda,
                     s.jaqa255pap pap,
                     s.jaqa255cta cta,
                     s.jaqa255ope ope,
                     s.jaqa255tpo top,
                     'JAQA255' tabla
                from jaqa255 s
               where s.jaqa255est = 'L'
                 and s.jaqa255fec >= fecha_ini
                 and s.jaqa255fec <= fecha_fin) x
       where (x.emp, x.modu, x.mda, x.pap, x.cta, x.ope, x.top) not in
             (select u.aqpb009emp,
                     u.aqpb009mod,
                     u.aqpb009mda,
                     u.aqpb009pap,
                     u.aqpb009cta,
                     u.aqpb009ope,
                     u.aqpb009top
                from aqpb009 u
              
              )
      --and x.emp = 1
      --and x.cta = 3778
      --and x.ope = 9012679
      
      ;
  
  begin
  
    for i in creditos(pn_fecha_ini, pn_fecha_fin) loop
    
      --Obtener dato vigente desde fsd010
      ln_estado := 1;
    
      begin
        select t.aosuc, t.aosbop, t.aotope
          into lx_aosuc, lx_sbop, lx_top
          from fsd010 t
         where t.pgcod = i.emp
           and t.aomod = i.modu
           and t.aomda = i.mda
           and t.aopap = i.pap
           and t.aocta = i.cta
           and t.aooper = i.ope
           and t.aotope = i.top
           and t.aomod in
               (select u.modulo from fst111 u where u.dscod = 50)
           and t.aostat <> 99;
      exception
        when others then
          ln_estado := 0;
      end;
    
      if ln_estado = 0 then
      
        begin
        
          select f.suc, f.sbop, f.top
            into lx_aosuc, lx_sbop, lx_top
            from (select x.aosuc suc, max(x.aosbop) sbop, x.aotope top
                  
                    from fsd010 x
                   where x.pgcod = i.emp
                     and x.aomod = i.modu
                     and x.aomda = i.mda
                     and x.aopap = i.pap
                     and x.aocta = i.cta
                     and x.aooper = i.ope
                        --and x.aotope = i.top
                     and x.aomod in
                         (select u.modulo from fst111 u where u.dscod = 50)
                   group by x.aosuc, x.aotope
                   order by sbop desc) f
           where rownum = 1;
        
          ln_estado := 1;
        
        exception
          when others then
            ln_estado := 0;
        end;
      
      end if;
    
      if ln_estado = 1 then
      
        begin
          -- Call the procedure
          pq_cr_historico_pagos_dia.sp_verificar_cronograma(pn_pgcod  => i.emp,
                                                            pn_aomod  => i.modu,
                                                            pn_aosuc  => lx_aosuc,
                                                            pn_aomda  => i.mda,
                                                            pn_aopap  => i.pap,
                                                            pn_aocta  => i.cta,
                                                            pn_aooper => i.ope,
                                                            pn_aosbop => lx_sbop,
                                                            pn_aotope => lx_top,
                                                            pn_estado => 'C');
        end;
      
      end if;
    
    end loop;
  
  end sp_generar_registros;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  PROCEDURE sp_actualizar_cancelados is
  
    ln_estado   number;
    ln_cantidad number;
  
    cursor creditos is
      select aqpb009emp,
             aqpb009mod,
             aqpb009suc,
             aqpb009mda,
             aqpb009pap,
             aqpb009cta,
             aqpb009ope,
             aqpb009sbo,
             aqpb009top,
             aqpb009est,
             aqpb009tref
        from aqpb009 a
       where a.aqpb009est = 'C';
  
  begin
  
    for i in creditos loop
    
      begin
        select count(*)
          into ln_cantidad
          from fsd010 f
         where f.PGCOD = i.aqpb009emp
           and f.AOMOD = i.aqpb009mod
           and f.AOMDA = i.aqpb009mda
           and f.AOPAP = i.aqpb009pap
           and f.AOCTA = i.aqpb009cta
           and f.AOOPER = i.aqpb009ope
              --and f.AOSBOP = i.aqpb009sbo
              --and f.AOTOPE = i.aqpb009top
           and f.AOSTAT <> 99;
      exception
        when others then
          ln_cantidad := null;
      end;
    
      if nvl(ln_cantidad, 0) = 0 then
        update aqpb009 a
           set a.aqpb009est = 'X'
         where a.aqpb009emp = i.aqpb009emp
           and a.aqpb009mod = i.aqpb009mod
           and a.aqpb009suc = i.aqpb009suc
           and a.aqpb009mda = i.aqpb009mda
           and a.aqpb009pap = i.aqpb009pap
           and a.aqpb009cta = i.aqpb009cta
           and a.aqpb009ope = i.aqpb009ope
           and a.aqpb009sbo = i.aqpb009sbo
           and a.aqpb009top = i.aqpb009top;
        commit;
      end if;
    
    end loop;
  
  end sp_actualizar_cancelados;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Procedimiento para reprocesar reprogramaciones cuya data de origen NO SEA 0
  PROCEDURE sp_reprocesar_registros is
  
    lx_suc    number;
    lx_sbop   number;
    lx_top    number;
    lc_coderr number;
    ln_estado number;
  
    cursor creditos is
      select x.aqpb066fep fep,
             x.aqpb066cor cor,
             x.aqpb066emp emp,
             x.aqpb066mod modu,
             x.aqpb066suc suc,
             x.aqpb066mda mda,
             x.aqpb066pap pap,
             x.aqpb066cta cta,
             x.aqpb066ope ope,
             x.aqpb066sbo sbop,
             x.aqpb066top top
        from aqpb066 x;
  
    --CURSOR 1: FSD601
    cursor cur_fsd601(cr_pgcod number,
                      cr_aomod number,
                      --cr_aosuc number, 
                      cr_aomda  number,
                      cr_aopap  number,
                      cr_aocta  number,
                      cr_aooper number,
                      cr_aosbop number
                      --,cr_aotope number
                      ) is
      select *
        from FSD601 t
       where t.pgcod = cr_pgcod
         and t.ppmod = cr_aomod
            --and t.ppsuc = cr_aosuc
         and t.ppmda = cr_aomda
         and t.pppap = cr_aopap
         and t.ppcta = cr_aocta
         and t.ppoper = cr_aooper
         and t.ppsbop = cr_aosbop
      --and t.pptope = cr_aotope
       order by t.ppfpag asc;
  
    -- CURSOR 2: FSD602
    cursor cur_fsd602(cr_pgcod number,
                      cr_aomod number,
                      --cr_aosuc number, 
                      cr_aomda  number,
                      cr_aopap  number,
                      cr_aocta  number,
                      cr_aooper number,
                      cr_aosbop number --, 
                      --cr_aotope number
                      ) is
      select *
        from FSD602 t
       where t.pgcod = cr_pgcod
         and t.ppmod = cr_aomod
            --and t.ppsuc = cr_aosuc
         and t.ppmda = cr_aomda
         and t.pppap = cr_aopap
         and t.ppcta = cr_aocta
         and t.ppoper = cr_aooper
         and t.ppsbop = cr_aosbop
      --and t.pptope = cr_aotope
       order by t.ppfpag asc;
  
    ---CURSOR 3: FSD611
    cursor cur_fsd611(cr_pgcod number,
                      cr_aomod number,
                      --cr_aosuc  number,
                      cr_aomda  number,
                      cr_aopap  number,
                      cr_aocta  number,
                      cr_aooper number,
                      cr_aosbop number --,
                      --cr_aotope number
                      ) is
      select *
        from FSD611 t
       where t.pgcod = cr_pgcod
         and t.ppmod = cr_aomod
            --and t.ppsuc = cr_aosuc
         and t.ppmda = cr_aomda
         and t.pppap = cr_aopap
         and t.ppcta = cr_aocta
         and t.ppoper = cr_aooper
         and t.ppsbop = cr_aosbop
      --and t.pptope = cr_aotope
       order by t.ppfpag asc;
  
    --CURSOR 4: FPP001
    cursor cur_fpp001(cr_pgcod number,
                      cr_aomod number,
                      -- cr_aosuc  number,
                      cr_aomda  number,
                      cr_aopap  number,
                      cr_aocta  number,
                      cr_aooper number,
                      cr_aosbop number --,
                      -- cr_aotope number
                      ) is
      select *
        from FPP001 t
       where t.pgcod = cr_pgcod
         and t.aomod = cr_aomod
            --and t.aosuc = cr_aosuc
         and t.aomda = cr_aomda
         and t.aopap = cr_aopap
         and t.aocta = cr_aocta
         and t.aooper = cr_aooper
         and t.aosbop = cr_aosbop
      --and t.aotope = cr_aotope
      ;
  
    --CURSOR 5: FPP002
    cursor cur_fpp002(cr_pgcod number,
                      cr_aomod number,
                      --cr_aosuc number, 
                      cr_aomda  number,
                      cr_aopap  number,
                      cr_aocta  number,
                      cr_aooper number,
                      cr_aosbop number --, 
                      --cr_aotope number
                      ) is
      select *
        from FPP002 t
       where t.pgcod = cr_pgcod
         and t.ppmod = cr_aomod
         and
            --t.ppsuc = cr_aosuc and
             t.ppmda = cr_aomda
         and t.pppap = cr_aopap
         and t.ppcta = cr_aocta
         and t.ppoper = cr_aooper
         and t.ppsbop = cr_aosbop --and
      --t.pptope = cr_aotope
      ;
  
    --cursor 6: x054023
    cursor cur_x054023(cr_pgcod number,
                       cr_aomod number,
                       --cr_aosuc number, 
                       cr_aomda  number,
                       cr_aopap  number,
                       cr_aocta  number,
                       cr_aooper number,
                       cr_aosbop number --, 
                       --cr_aotope number
                       ) is
      select *
        from X054023 t
       where t.xllpgcod = cr_pgcod
         and t.xllaomod = cr_aomod
         and
            --t.xllaosuc = cr_aosuc and
             t.xllaomda = cr_aomda
         and t.xllaopap = cr_aopap
         and t.xllaocta = cr_aocta
         and t.xllaooper = cr_aooper
         and t.xllaosbop = cr_aosbop --and
      --t.xllaotop = cr_aotope 
      ;
  
    --CURSOR 7: FSD012
    cursor cur_fsd012(cr_pgcod number,
                      cr_aomod number,
                      --cr_aosuc number, 
                      cr_aomda  number,
                      cr_aopap  number,
                      cr_aocta  number,
                      cr_aooper number,
                      cr_aosbop number --, 
                      --cr_aotope number
                      ) is
      select *
        from FSD012 t
       where t.pgcod = cr_pgcod
         and t.aomod = cr_aomod
         and
            --t.aosuc = cr_aosuc and
             t.aomda = cr_aomda
         and t.aopap = cr_aopap
         and t.aocta = cr_aocta
         and t.aooper = cr_aooper
         and t.aosbop = cr_aosbop --and
      -- t.aotope = cr_aotope
      ;
  
  begin
  
    delete from aqpb066;
    commit;
  
    insert into aqpb066
      (aqpb066fep,
       aqpb066cor,
       aqpb066emp,
       aqpb066mod,
       aqpb066suc,
       aqpb066mda,
       aqpb066pap,
       aqpb066cta,
       aqpb066ope,
       aqpb066sbo,
       aqpb066top)
      select t.aqpb009fep,
             t.aqpb009cor,
             t.aqpb009emp,
             t.aqpb009mod,
             t.aqpb009suc,
             t.aqpb009mda,
             t.aqpb009pap,
             t.aqpb009cta,
             t.aqpb009ope,
             t.aqpb009sbo,
             t.aqpb009top
        from aqpb009 t
       where (t.aqpb009emp, t.aqpb009mod, t.aqpb009suc, t.aqpb009mda,
              t.aqpb009pap, t.aqpb009cta, t.aqpb009ope, t.aqpb009sbo,
              t.aqpb009top) in
             (select x.aqpb060pgcod,
                     x.aqpb060aomod,
                     x.aqpb060aosuc,
                     x.aqpb060aomda,
                     x.aqpb060aopap,
                     x.aqpb060aocta,
                     x.aqpb060aooper,
                     x.aqpb060aosbop,
                     x.aqpb060aotop
                from aqpb060 x
               where x.aqpb060aoobop > 0);
    commit;
  
    for i in creditos loop
      --->>>>
      ---=====A. ELIMINADO DE DATOS
      delete from aqpb060 t
       where t.aqpb060pgcod = i.emp
         and t.aqpb060aomod = i.modu
         and
            --t.aqpb060aosuc = pn_aosuc and
             t.aqpb060aomda = i.mda
         and t.aqpb060aopap = i.pap
         and t.aqpb060aocta = i.cta
         and t.aqpb060aooper = i.ope
         and
            --t.aqpb060aosbop = pn_aosbop and
             t.aqpb060aotop = i.top;
    
      delete from aqpb061 t
       where t.aqpb061pgcod = i.emp
         and t.aqpb061mod = i.modu
         and
            --t.aqpb061suc = pn_aosuc and
             t.aqpb061mda = i.mda
         and t.aqpb061pap = i.pap
         and t.aqpb061cta = i.cta
         and t.aqpb061oper = i.ope
         and
            --t.aqpb061sbop = pn_aosbop and
             t.aqpb061tope = i.top;
    
      delete from aqpb062 t
       where t.aqpb062pgcod = i.emp
         and t.aqpb062mod = i.modu
         and
            --t.aqpb062suc = pn_aosuc and
             t.aqpb062mda = i.mda
         and t.aqpb062pap = i.pap
         and t.aqpb062cta = i.cta
         and t.aqpb062oper = i.ope
         and
            --t.aqpb062sbop = pn_aosbop and
             t.aqpb062tope = i.top;
    
      delete from aqpb063 t
       where t.aqpb063pgcod = i.emp
         and t.aqpb063mod = i.modu
         and
            --t.aqpb063suc = pn_aosuc and
             t.aqpb063mda = i.mda
         and t.aqpb063pap = i.pap
         and t.aqpb063cta = i.cta
         and t.aqpb063oper = i.ope
         and
            --t.aqpb063sbop = pn_aosbop and
             t.aqpb063tope = i.top;
    
      delete from aqpa973 t
       where t.aqpa973cod = i.emp
         and t.aqpa973mod = i.modu
         and
            --t.aqpa973suc = pn_aosuc and
             t.aqpa973mda = i.mda
         and t.aqpa973pap = i.pap
         and t.aqpa973cta = i.cta
         and t.aqpa973oper = i.ope
         and
            --t.aqpa973sbop = pn_aosbop and
             t.aqpa973tope = i.top;
    
      delete from aqpa974 t
       where t.aqpa974pgcod = i.emp
         and t.aqpa974mod = i.modu
         and
            --t.aqpa974suc = pn_aosuc and
             t.aqpa974mda = i.mda
         and t.aqpa974pap = i.pap
         and t.aqpa974cta = i.cta
         and t.aqpa974oper = i.ope
         and
            --t.aqpa974sbop = pn_aosbop and
             t.aqpa974tope = i.top;
    
      delete from aqpa975 t
       where t.aqpa975cod = i.emp
         and t.aqpa975mod = i.modu
         and
            --t.aqpa975suc = pn_aosuc and
             t.aqpa975mda = i.mda
         and t.aqpa975pap = i.pap
         and t.aqpa975cta = i.cta
         and t.aqpa975oper = i.ope
         and
            --t.aqpa975sbop = pn_aosbop and
             t.aqpa975tope = i.top;
    
      commit;
    
      ---=====B. INSERCIÓN DE DATOS
    
      ---1. FSD601
      for k in cur_fsd601(i.emp, i.modu, i.mda, i.pap, i.cta, i.ope, 0) loop
        begin
          --Inserción aqpb061
          insert into AQPB061
            (aqpb061pgcod,
             aqpb061mod,
             aqpb061suc,
             aqpb061mda,
             aqpb061pap,
             aqpb061cta,
             aqpb061oper,
             aqpb061sbop,
             aqpb061tope,
             aqpb061fpag,
             aqpb061tipo,
             aqpb061fval,
             aqpb061fvto,
             aqpb061pzo,
             aqpb061cap,
             aqpb061int,
             aqpb061intmex,
             aqpb061icap,
             aqpb061iint,
             aqpb061stat,
             aqpb061nume,
             aqpb061finv,
             aqpb061cd,
             aqpb061mo,
             aqpb061su,
             aqpb061tr,
             aqpb061re,
             aqpb061fc,
             aqpb061or,
             aqpb061sb,
             aqpb061co,
             aqpb061obop)
          
          values
            (k.pgcod,
             k.ppmod,
             i.suc, --k.ppsuc,
             k.ppmda,
             k.pppap,
             k.ppcta,
             k.ppoper,
             i.sbop, --pn_aosbop,
             i.top, --k.pptope,
             k.ppfpag,
             k.pptipo,
             k.ppfval,
             k.ppfvto,
             k.pppzo,
             k.ppcap,
             k.ppint,
             k.ppintmex,
             k.ppicap,
             k.ppiint,
             k.ppstat,
             k.ppnume,
             k.ppfinv,
             k.d601cd,
             k.d601mo,
             k.d601su,
             k.d601tr,
             k.d601re,
             k.d601fc,
             k.d601or,
             k.d601sb,
             k.d601co,
             k.ppsbop);
        exception
          when others then
            -- lc_flag := 'N';
            lc_coderr := null;
          
        end;
      
      end loop;
      commit;
    
      --2. FSD602
      for m in cur_fsd602(i.emp, i.modu, i.mda, i.pap, i.cta, i.ope, 0) loop
        begin
          insert into AQPB062
            (aqpb062pgcod,
             aqpb062mod,
             aqpb062suc,
             aqpb062mda,
             aqpb062pap,
             aqpb062cta,
             aqpb062oper,
             aqpb062sbop,
             aqpb062tope,
             aqpb062fpag,
             aqpb062tipo,
             aqpb062nump,
             aqpb062fech,
             aqpb062cap,
             aqpb062int,
             aqpb062intmex,
             aqpb062intm,
             aqpb062intmmex,
             aqpb062icap,
             aqpb062iint,
             aqpb062iintm,
             aqpb062salcap,
             aqpb062salint,
             aqpb062salade,
             aqpb062salmor,
             aqpb062stat,
             aqpb062salintm,
             aqpb062salmorm,
             aqpb062saladem,
             aqpb062cd,
             aqpb062mo,
             aqpb062su,
             aqpb062tr,
             aqpb062re,
             aqpb062fc,
             aqpb062or,
             aqpb062sb,
             aqpb062co,
             aqpb062obop)
          values
            (m.pgcod,
             m.ppmod,
             i.suc, --m.ppsuc,
             m.ppmda,
             m.pppap,
             m.ppcta,
             m.ppoper,
             i.sbop, --m.ppsbop,
             i.top, --m.pptope,
             m.ppfpag,
             m.pptipo,
             m.pp1nump,
             m.pp1fech,
             m.pp1cap,
             m.pp1int,
             m.pp1intmex,
             m.pp1intm,
             m.pp1intmmex,
             m.pp1icap,
             m.pp1iint,
             m.pp1iintm,
             m.pp1salcap,
             m.pp1salint,
             m.pp1salade,
             m.pp1salmor,
             m.pp1stat,
             m.pp1salintm,
             m.pp1salmorm,
             m.pp1saladem,
             m.d602cd,
             m.d602mo,
             m.d602su,
             m.d602tr,
             m.d602re,
             m.d602fc,
             m.d602or,
             m.d602sb,
             m.d602co,
             m.ppsbop);
        exception
          when others then
            lc_coderr := null;
          
        end;
      end loop;
      commit;
    
      --3. FSD611
      for p in cur_fsd611(i.emp, i.modu, i.mda, i.pap, i.cta, i.ope, 0) loop
        begin
        
          insert into AQPB063
            (aqpb063pgcod,
             aqpb063mod,
             aqpb063suc,
             aqpb063mda,
             aqpb063pap,
             aqpb063cta,
             aqpb063oper,
             aqpb063sbop,
             aqpb063tope,
             aqpb063fpag,
             aqpb063tipo,
             aqpb063exte,
             aqpb063imp1,
             aqpb063imp2,
             aqpb063imp3,
             aqpb063imp4,
             aqpb063imp5,
             aqpb063imp6,
             aqpb063imp7,
             aqpb063imp8,
             aqpb063imp9,
             aqpb063imp10,
             aqpb063imp11,
             aqpb063imp12,
             aqpb063imp13,
             aqpb063imp14,
             aqpb063imp15,
             aqpb063imp16,
             aqpb063imp17,
             aqpb063imp18,
             aqpb063imp19,
             aqpb063imp20,
             aqpb063obop)
          values
            (p.pgcod,
             p.ppmod,
             i.suc, --p.ppsuc,
             p.ppmda,
             p.pppap,
             p.ppcta,
             p.ppoper,
             i.sbop, --pn_aosbop, -- p.ppsbop,
             i.top, --p.pptope,
             p.ppfpag,
             p.pptipo,
             p.ppexte,
             p.ppimp1,
             p.ppimp2,
             p.ppimp3,
             p.ppimp4,
             p.ppimp5,
             p.ppimp6,
             p.ppimp7,
             p.ppimp8,
             p.ppimp9,
             p.ppimp10,
             p.ppimp11,
             p.ppimp12,
             p.ppimp13,
             p.ppimp14,
             p.ppimp15,
             p.ppimp16,
             p.ppimp17,
             p.ppimp18,
             p.ppimp19,
             p.ppimp20,
             p.ppsbop);
        exception
          when others then
            --  lc_flag := 'N';
          
            lc_coderr := null;
          
        end;
      end loop;
      commit;
    
      --4. FPP001
      for q in cur_fpp001(i.emp, i.modu, i.mda, i.pap, i.cta, i.ope, 0) loop
        begin
        
          insert into aqpa974
            (aqpa974pgcod,
             aqpa974mod,
             aqpa974suc,
             aqpa974mda,
             aqpa974pap,
             aqpa974cta,
             aqpa974oper,
             aqpa974sbop,
             aqpa974tope,
             aqpa974sgcod,
             aqpa974vc,
             aqpa974imp,
             aqpa974porc,
             aqpa974plus,
             aqpa974part,
             aqpa974veh,
             aqpa974inm,
             aqpa974end,
             aqpa974stat,
             aqpa974co,
             aqpa974aux1,
             aqpa974aux2,
             aqpa974aux3,
             aqpa974aux4,
             aqpa974aux5,
             aqpa974aux6,
             aqpa974aux7,
             aqpa974obop)
          values
            (q.pgcod,
             q.aomod,
             i.suc, --q.aosuc,
             q.aomda,
             q.aopap,
             q.aocta,
             q.aooper,
             i.sbop, --pn_aosbop, 
             i.top, -- q.aotope,
             q.sgcod,
             q.pp001vc,
             q.pp001imp,
             q.pp001porc,
             q.pp001plus,
             q.pp001part,
             q.pp001veh,
             q.pp001inm,
             q.pp001end,
             q.pp001stat,
             q.pp001co,
             q.pp001aux1,
             q.pp001aux2,
             q.pp001aux3,
             q.pp001aux4,
             q.pp001aux5,
             q.pp001aux6,
             q.pp001aux7,
             q.aosbop);
        exception
          when others then
          
            lc_coderr := NULL;
          
        end;
      end loop;
      commit;
    
      --5. FPP002
      for r in cur_fpp002(i.emp, i.modu, i.mda, i.pap, i.cta, i.ope, 0) loop
        begin
        
          insert into aqpa973
            (aqpa973cod,
             aqpa973mod,
             aqpa973suc,
             aqpa973mda,
             aqpa973pap,
             aqpa973cta,
             aqpa973oper,
             aqpa973sbop,
             aqpa973tope,
             aqpa973fpag,
             aqpa973tipo,
             aqpa973estconc,
             aqpa973imp,
             aqpa973stat,
             aqpa973aux1,
             aqpa973aux2,
             aqpa973aux3,
             aqpa973obop)
          values
            (r.pgcod,
             r.ppmod,
             i.suc, --r.ppsuc,
             r.ppmda,
             r.pppap,
             r.ppcta,
             r.ppoper,
             i.sbop, --pn_aosbop, 
             i.top, --r.pptope,
             r.ppfpag,
             r.pptipo,
             r.prestconc,
             r.pp002imp,
             r.pp002stat,
             r.pp002aux1,
             r.pp002aux2,
             r.pp002aux3,
             r.ppsbop);
        exception
          when others then
          
            lc_coderr := null;
          
        end;
      end loop;
      commit;
    
      --6. X054023
      for s in cur_x054023(i.emp, i.modu, i.mda, i.pap, i.cta, i.ope, 0) loop
        begin
        
          insert into aqpb060
            (aqpb060pgcod,
             aqpb060aomod,
             aqpb060aosuc,
             aqpb060aomda,
             aqpb060aopap,
             aqpb060aocta,
             aqpb060aooper,
             aqpb060aosbop,
             aqpb060aotop,
             aqpb060fvalor,
             aqpb060capital,
             aqpb060fprimpa,
             aqpb060cantcuo,
             aqpb060periodo,
             aqpb060tipopre,
             aqpb060tipodia,
             aqpb060tipotas,
             aqpb060tasap,
             aqpb060gradper,
             aqpb060gradpor,
             aqpb060gradimp,
             aqpb060tipoano,
             aqpb060tipdiap,
             aqpb060pcltcod,
             aqpb060pclplus,
             aqpb060pcldrev,
             aqpb060tferp,
             aqpb060cntcuoi,
             aqpb060fpripag,
             aqpb060plazo,
             aqpb060fvto,
             aqpb060modocal,
             aqpb060gracfij,
             aqpb060ciud,
             aqpb060capliq,
             aqpb060medico,
             aqpb060financ,
             aqpb060tasaej,
             aqpb060valcan,
             aqpb060valcuo,
             aqpb060capfin,
             aqpb060impu,
             aqpb060aux1,
             aqpb060aux2,
             aqpb060aux3,
             aqpb060aux4,
             aqpb060aux5,
             aqpb060redon,
             aqpb060aux6,
             aqpb060precio,
             aqpb060aoobop)
          values
            (s.xllpgcod,
             s.xllaomod,
             i.suc, --,s.xllaosuc,
             s.xllaomda,
             s.xllaopap,
             s.xllaocta,
             s.xllaooper,
             i.sbop, --pn_aosbop, 
             i.top, --s.xllaotop,
             s.xllfvalor,
             s.xllcapital,
             s.xllfprimpa,
             s.xllcantcuo,
             s.xllperiodo,
             s.xlltipopre,
             s.xlltipodia,
             s.xlltipotas,
             s.xlltasap,
             s.xllgradper,
             s.xllgradpor,
             s.xllgradimp,
             s.xlltipoano,
             s.xlltipdiap,
             s.xllpcltcod,
             s.xllpclplus,
             s.xllpcldrev,
             s.xlltferp,
             s.xllcntcuoi,
             s.xllfpripag,
             s.xllplazo,
             s.xllfvto,
             s.xllmodocal,
             s.xllgracfij,
             s.xllciud,
             s.xllcapliq,
             s.xllmedico,
             s.xllfinanc,
             s.xlltasaej,
             s.xllvalcan,
             s.xllvalcuo,
             s.xllcapfin,
             s.xllimpu,
             s.xllaux1,
             s.xllaux2,
             s.xllaux3,
             s.xllaux4,
             s.xllaux5,
             s.xllredon,
             s.xllaux6,
             s.xllprecio,
             s.xllaosbop);
        exception
          when others then
          
            lc_coderr := null;
          
        end;
      end loop;
      commit;
    
      --7. FSD012
      for u in cur_fsd012(i.emp, i.modu, i.mda, i.pap, i.cta, i.ope, 0) loop
        begin
        
          insert into AQPA975
            (aqpa975cod,
             aqpa975mod,
             aqpa975suc,
             aqpa975mda,
             aqpa975pap,
             aqpa975cta,
             aqpa975oper,
             aqpa975sbop,
             aqpa975tope,
             aqpa975corr,
             aqpa975tipo,
             aqpa975fval,
             aqpa975fvto,
             aqpa975imp,
             aqpa975ttas,
             aqpa975tasa,
             aqpa975cap,
             aqpa975int,
             aqpa975mor,
             aqpa975scap,
             aqpa975sint,
             aqpa975smor,
             aqpa975intc,
             aqpa975morc,
             aqpa975cd01,
             aqpa975cd02,
             aqpa975inv,
             aqpa975per,
             aqpa975tcbi,
             aqpa975tcbi1,
             aqpa975arb,
             aqpa975arb1,
             aqpa975md,
             aqpa975md1,
             aqpa975pre,
             aqpa975pre1,
             aqpa975cd,
             aqpa975mo,
             aqpa975su,
             aqpa975tr,
             aqpa975re,
             aqpa975fc,
             aqpa975or,
             aqpa975sb,
             aqpa975co,
             aqpa975obop)
          values
            (u.pgcod,
             u.aomod,
             i.suc, --u.aosuc,
             u.aomda,
             u.aopap,
             u.aocta,
             u.aooper,
             i.sbop, --pn_aosbop, 
             i.top, --u.aotope,
             u.evcorr,
             u.evtipo,
             u.evfval,
             u.evfvto,
             u.evimp,
             u.evttas,
             u.evtasa,
             u.evcap,
             u.evint,
             u.evmor,
             u.evscap,
             u.evsint,
             u.evsmor,
             u.evintc,
             u.evmorc,
             u.evcd01,
             u.evcd02,
             u.evinv,
             u.evper,
             u.evtcbi,
             u.evtcbi1,
             u.evarb,
             u.evarb1,
             u.evmd,
             u.evmd1,
             u.evpre,
             u.evpre1,
             u.d012cd,
             u.d012mo,
             u.d012su,
             u.d012tr,
             u.d012re,
             u.d012fc,
             u.d012or,
             u.d012sb,
             u.d012co,
             u.aosbop);
        exception
          when others then
          
            lc_coderr := null;
          
        end;
      end loop;
      commit;
    
      --=== 3. ACTUALIZAR SUBOPERACION VIGENTE
      ln_estado := 1;
      begin
        select t.aosuc, t.aosbop, t.aotope
          into lx_suc, lx_sbop, lx_top
          from fsd010 t
         where t.pgcod = i.emp
           and t.aomod = i.modu
           and t.aomda = i.mda
           and t.aopap = i.pap
           and t.aocta = i.cta
           and t.aooper = i.ope
              --and t.aotope = i.top
           and t.aomod in
               (select u.modulo from fst111 u where u.dscod = 50)
           and t.aostat <> 99;
      exception
        when others then
          ln_estado := 0;
      end;
    
      ---
      if ln_estado = 0 then
      
        begin
        
          select f.suc, f.sbop, f.top
            into lx_suc, lx_sbop, lx_top
            from (select x.aosuc suc, max(x.aosbop) sbop, x.aotope top
                  
                    from fsd010 x
                   where x.pgcod = i.emp
                     and x.aomod = i.modu
                     and x.aomda = i.mda
                     and x.aopap = i.pap
                     and x.aocta = i.cta
                     and x.aooper = i.ope
                        --and x.aotope = i.top
                     and x.aomod in
                         (select u.modulo from fst111 u where u.dscod = 50)
                   group by x.aosuc, x.aotope
                   order by sbop desc) f
           where rownum = 1;
        
          ln_estado := 1;
        
        exception
          when others then
            ln_estado := 0;
        end;
      
      end if;
    
      ---
      if ln_estado = 1 then
      
        update aqpb060 t
           set t.aqpb060aosuc  = lx_suc,
               t.aqpb060aosbop = lx_sbop,
               t.aqpb060aotop  = lx_top
         where t.aqpb060pgcod = i.emp
           and t.aqpb060aomod = i.modu
              --and t.aqpb060aosuc = i.aqpb066suc
           and t.aqpb060aomda = i.mda
           and t.aqpb060aopap = i.pap
           and t.aqpb060aocta = i.cta
           and t.aqpb060aooper = i.ope
        --and t.aqpb060aosbop = i.aqpb066sbo
        --and t.aqpb060aotop = pn_aotope
        ;
        commit;
      
        update aqpb061 t
           set t.aqpb061suc  = lx_suc,
               t.aqpb061sbop = lx_sbop,
               t.aqpb061tope = lx_top
         where t.aqpb061pgcod = i.emp
           and t.aqpb061mod = i.modu
              --and t.aqpb061suc = i.aqpb066suc
           and t.aqpb061mda = i.mda
           and t.aqpb061pap = i.pap
           and t.aqpb061cta = i.cta
           and t.aqpb061oper = i.ope
        --and t.aqpb061sbop = i.aqpb066sbo
        --and t.aqpb061tope = pn_aotope
        ;
        commit;
      
        update aqpb062 t
           set t.aqpb062suc  = lx_suc,
               t.aqpb062sbop = lx_sbop,
               t.aqpb062tope = lx_top
         where t.aqpb062pgcod = i.emp
           and t.aqpb062mod = i.modu
              --and t.aqpb062suc = i.aqpb066suc
           and t.aqpb062mda = i.mda
           and t.aqpb062pap = i.pap
           and t.aqpb062cta = i.cta
           and t.aqpb062oper = i.ope
        --and t.aqpb062sbop = i.aqpb066sbo
        --and t.aqpb062tope = pn_aotope
        ;
        commit;
      
        update aqpb063 t
           set t.aqpb063suc  = lx_suc,
               t.aqpb063sbop = lx_sbop,
               t.aqpb063tope = lx_top
         where t.aqpb063pgcod = i.emp
           and t.aqpb063mod = i.modu
              --and t.aqpb063suc = i.aqpb066suc
           and t.aqpb063mda = i.mda
           and t.aqpb063pap = i.pap
           and t.aqpb063cta = i.cta
           and t.aqpb063oper = i.ope
        --and t.aqpb063sbop = i.aqpb066sbo
        --and t.aqpb063tope = pn_aotope
        ;
        commit;
      
        update aqpa973 t
           set t.aqpa973suc  = lx_suc,
               t.aqpa973sbop = lx_sbop,
               t.aqpa973tope = lx_top
         where t.aqpa973cod = i.emp
           and t.aqpa973mod = i.modu
              --and t.aqpa973suc = i.aqpb066suc
           and t.aqpa973mda = i.mda
           and t.aqpa973pap = i.pap
           and t.aqpa973cta = i.cta
           and t.aqpa973oper = i.ope
        --and t.aqpa973sbop = i.aqpb066sbo
        --and t.aqpa973tope = pn_aotope
        ;
        commit;
      
        update aqpa974 t
           set t.aqpa974suc  = lx_suc,
               t.aqpa974sbop = lx_sbop,
               t.aqpa974tope = lx_top
         where t.aqpa974pgcod = i.emp
           and t.aqpa974mod = i.modu
              --and t.aqpa974suc = i.aqpb066suc
           and t.aqpa974mda = i.mda
           and t.aqpa974pap = i.pap
           and t.aqpa974cta = i.cta
           and t.aqpa974oper = i.ope
        --and t.aqpa974sbop = i.aqpb066sbo
        --and t.aqpa974tope = pn_aotope
        ;
        commit;
      
        update aqpa975 t
           set t.aqpa975suc  = lx_suc,
               t.aqpa975sbop = lx_sbop,
               t.aqpa975tope = lx_top
         where t.aqpa975cod = i.emp
           and t.aqpa975mod = i.modu
              --and t.aqpa975suc = i.aqpb066suc
           and t.aqpa975mda = i.mda
           and t.aqpa975pap = i.pap
           and t.aqpa975cta = i.cta
           and t.aqpa975oper = i.ope
        --and t.aqpa975sbop = i.aqpb066sbo
        --and t.aqpa975tope = pn_aotope
        ;
        commit;
      
        update aqpb064 t
           set t.aqpb064aosuc  = lx_suc,
               t.aqpb064aosbop = lx_sbop,
               t.aqpb064aotope = lx_top
         where t.aqpb064pgcod = i.emp
           and t.aqpb064aomod = i.modu
              --and t.aqpb064aosuc = i.aqpb066suc
           and t.aqpb064aomda = i.mda
           and t.aqpb064aopap = i.pap
           and t.aqpb064aocta = i.cta
           and t.aqpb064aooper = i.ope
              --and t.aqpb064aosbop = i.aqpb066sbo
              --and t.aqpb064aotope = pn_aotope
           and t.aqpb064orden = 1;
        commit;
      
        update aqpb009 t
           set t.aqpb009suc = lx_suc,
               t.aqpb009sbo = lx_sbop,
               t.aqpb009top = lx_top
         where
        --t.aqpb009fep = i.aqpb066fep
        --and t.aqpb009cor = i.aqpb066cor
         t.aqpb009emp = i.emp
         and t.aqpb009mod = i.modu
        --and t.aqpb009suc = i.aqpb066suc
         and t.aqpb009mda = i.mda
         and t.aqpb009pap = i.pap
         and t.aqpb009cta = i.cta
         and t.aqpb009ope = i.ope
        --and t.aqpb009sbo = i.aqpb066sbo
        --and t.aqpb009top = pn_aotope
        ;
        commit;
      
      end if;
    
    -->>>>
    end loop;
  
  end sp_reprocesar_registros;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

end pq_cr_historico_pagos_ind;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
/

