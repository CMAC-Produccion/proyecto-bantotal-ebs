create or replace package pq_cr_reglas_calificacion_rcc_rp is

  -- Author  : APACHECOH
  -- Created : 9/06/2022 13:04:02
  
   procedure sp_pr_calif_cpp_ultimo_mes(vi_tdoc in number,
                                        vi_ndoc in varchar2,
                                        vo_calf out number);
                                               
   procedure sp_pr_calif_cpp_anterior_mes(vi_tdoc in number,
                                          vi_ndoc in varchar2,
                                          vo_calf out number);
                                               
   procedure sp_pr_calif_nordef_ultimo_mes(vi_tdoc in number,
                                           vi_ndoc in varchar2,
                                           vo_calf out number);
                                               
   procedure sp_pr_calif_nordef_anterior_mes(vi_tdoc in number,
                                             vi_ndoc in varchar2,
                                             vo_calf out number);
                                             
   procedure sp_pr_calif_nordef_ultimo_mes_cyg(vi_tdoc in number,
                                               vi_ndoc in varchar2,
                                               vo_calf out number);
                                               
   procedure sp_pr_calif_nordef_anterior_mes_cyg(vi_tdoc in number,
                                                 vi_ndoc in varchar2,
                                                 vo_calf out number);
                                                                                            
   function fn_equivalenviaDoc(p_tdoc in number) return varchar2;

end pq_cr_reglas_calificacion_rcc_rp;
/

create or replace package body pq_cr_reglas_calificacion_rcc_rp is

 procedure sp_pr_calif_cpp_ultimo_mes(vi_tdoc in number,
                                      vi_ndoc in varchar2,
                                      vo_calf out number) is
    -- *****************************************************************
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.06.09
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Obtener calificacion CPP del ultimo mes
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : vi_tdoc ( Tipo documento )
    --                              vi_tdoc ( Numero documento )
    -- Parámetros de Salida       : vo_calf ( Porcentaje de calificacion )
    -- ******************************************************************
    
    ln_tdoc         varchar2(1);
    ld_FchRCC       date;
  begin
    --buscar la fecha del rcc actual
    begin
      select to_date(Tpnro, 'dd/MM/yyyy')
        into ld_FchRCC
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    end;
    --buscar la calificacion cpp del titular
    ln_tdoc := pq_cr_reglas_calificacion_rcc_rp.fn_equivalenviaDoc(vi_tdoc);
    if vi_tdoc <> 9 then
      begin
        select N_CALIF1 into vo_calf 
                from cldrcci 
              where c_tipreg = '1' and c_tipdet = 'Z'
                and d_fecpre = ld_FchRCC
                and c_tdocid = ln_tdoc
                and c_docide = vi_ndoc;
      exception
        when others then
          vo_calf := 0;
      end;
    else
      if vi_tdoc = 9 then
        begin
          select N_CALIF1 into vo_calf 
                  from cldrcci 
                where c_tipreg = '1' and c_tipdet = 'Z'
                  and d_fecpre = ld_FchRCC
                  and c_tdoctr = ln_tdoc
                  and c_doctri = vi_ndoc;          
        exception
          when others then
              vo_calf := 0;
        end;
      end if;
    end if;    
    
  end sp_pr_calif_cpp_ultimo_mes;  
 
  procedure sp_pr_calif_cpp_anterior_mes(vi_tdoc in number,
                                         vi_ndoc in varchar2,
                                         vo_calf out number) is
    -- *****************************************************************
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.06.09
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Obtener calificacion CPP de los anteriores 3 meses al ult
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : vi_tdoc ( Tipo documento )
    --                              vi_tdoc ( Numero documento )
    -- Parámetros de Salida       : vo_calf ( Porcentaje de calificacion )
    -- ******************************************************************
            
    ln_tdoc         varchar2(1);
    ld_FchRCC       date;
    vi_meses        number;
    ln_calif1       number;
  begin
    vi_meses := 3;
    --buscar la fecha actual del rcc
    begin
      select to_date(Tpnro, 'DD/MM/YYYY')
        into ld_FchRCC
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    end;
    ln_tdoc := pq_cr_reglas_calificacion_rcc_rp.fn_equivalenviaDoc(vi_tdoc);
    vo_calf := 100;
    --buscar la calificacion cpp de los ultimos meses anteriores del titular
    for i in 1..vi_meses loop
      select ADD_MONTHS(ld_FchRCC,-1)
             into ld_FchRCC from DUAL;
      begin
        if vi_tdoc <> 9 then
          ln_tdoc := pq_cr_reglas_calificacion_rcc_rp.fn_equivalenviaDoc(vi_tdoc);
          begin
              select N_CALIF1 into ln_calif1 
                      from cldrcci 
                    where c_tipreg = '1' and c_tipdet = 'Z'
                      and c_tdocid = ln_tdoc
                      and c_docide = vi_ndoc
                      and d_fecpre = ld_FchRCC;
            exception
              when others then
                ln_calif1 := 0;
          end;
        else
            if vi_tdoc = 9 then
              begin
                select N_CALIF1 into ln_calif1 
                        from cldrcci 
                      where c_tipreg = '1' and c_tipdet = 'Z'
                        and d_fecpre = ld_FchRCC
                        and c_tdoctr = ln_tdoc
                        and c_doctri = vi_ndoc;          
              exception
                when others then
                    ln_calif1 := 0;
              end;
            end if;
        end if;             
      end; 
      --obtener la minima calificacion en los ultimos tres meses
      if ln_calif1 < vo_calf then
         vo_calf := ln_calif1;  
      end if;  
    end loop;    
    
  end sp_pr_calif_cpp_anterior_mes;  
 
  procedure sp_pr_calif_nordef_ultimo_mes(vi_tdoc in number,
                                          vi_ndoc in varchar2,
                                          vo_calf out number) is
    -- *****************************************************************
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.06.09
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Obtener calificacion Normal del ultimo mes
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : vi_tdoc ( Tipo documento )
    --                              vi_tdoc ( Numero documento )
    -- Parámetros de Salida       : vo_calf ( Porcentaje de calificacion )
    -- ******************************************************************
    
    ln_tdoc         varchar2(1);
    ln_tdoc_cyg     number;
    lv_ndoc_cyg     varchar2(12);
    ld_FchRCC       date;
    ln_calif0       number;
    ln_suma         number;
  begin
    --buscar la fecha del rcc actual
    begin
      select to_date(Tpnro, 'DD/MM/YYYY')
        into ld_FchRCC
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    end;
    --buscar la calificacion normal del titular
    ln_tdoc := pq_cr_reglas_calificacion_rcc_rp.fn_equivalenviaDoc(vi_tdoc);
    if vi_tdoc <> 9 then
      begin
        select N_CALIF0 into vo_calf 
                from cldrcci 
              where c_tipreg = '1' and c_tipdet = 'Z'
                and d_fecpre = ld_FchRCC
                and c_tdocid = ln_tdoc
                and c_docide = vi_ndoc;        
      exception
        when others then
          vo_calf := 100;
      end;
      if vo_calf = 0 then
          begin
            select N_CALIF0 + N_CALIF1 + N_CALIF2 + N_CALIF3 + N_CALIF4 into ln_suma 
                    from cldrcci 
                  where c_tipreg = '1' and c_tipdet = 'Z'
                    and d_fecpre = ld_FchRCC
                    and c_tdocid = ln_tdoc
                    and c_docide = vi_ndoc;
          exception 
            when others then
               ln_suma := 0;
          end;
          if ln_suma = 0 then
             vo_calf := 100;
          end if;
       end if;
    else
      if vi_tdoc = 9 then
        begin
          select N_CALIF0 into vo_calf 
                  from cldrcci 
                where c_tipreg = '1' and c_tipdet = 'Z'
                  and d_fecpre = ld_FchRCC
                  and c_tdoctr = ln_tdoc
                  and c_doctri = vi_ndoc;                  
        exception
          when others then
              vo_calf := 100;
        end;
        if vo_calf = 0 then
            begin
              select N_CALIF0 + N_CALIF1 + N_CALIF2 + N_CALIF3 + N_CALIF4 into ln_suma 
                      from cldrcci 
                    where c_tipreg = '1' and c_tipdet = 'Z'
                      and d_fecpre = ld_FchRCC
                      and c_tdoctr = ln_tdoc
                      and c_doctri = vi_ndoc;
            exception 
              when others then
                 ln_suma := 0;
            end;
            if ln_suma = 0 then
               vo_calf := 100;
            end if;
         end if;  
      end if;
    end if;          
  end sp_pr_calif_nordef_ultimo_mes; 
  
  procedure sp_pr_calif_nordef_ultimo_mes_cyg(vi_tdoc in number,
                                              vi_ndoc in varchar2,
                                              vo_calf out number) is
    -- *****************************************************************
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.06.09
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Obtener calificacion Normal del ultimo mes - Conyuge
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : vi_tdoc ( Tipo documento )
    --                              vi_tdoc ( Numero documento )
    -- Parámetros de Salida       : vo_calf ( Porcentaje de calificacion )
    -- ******************************************************************
    
    ln_tdoc         varchar2(1);
    ln_tdoc_cyg     number;
    lv_ndoc_cyg     varchar2(12);
    ld_FchRCC       date;
    ln_suma         number;
  begin
    --buscar la fecha del rcc actual
    begin
      select to_date(Tpnro, 'DD/MM/YYYY')
        into ld_FchRCC
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    end;
    --verificar si tiene conyuge
    begin          
       select rptdoc, rpndoc into ln_tdoc_cyg, lv_ndoc_cyg 
              from fsr002 
              where petdoc = vi_tdoc and pendoc = rpad(vi_ndoc, 12, ' ')              
                and rpccyg = 66;--apachecoh 2022.07.06 solo conyuge
    exception when others then
       ln_tdoc_cyg := 0;
    end;   
    if ln_tdoc_cyg <> 0 then
       if ln_tdoc_cyg <> 9 then
          ln_tdoc := pq_cr_reglas_calificacion_rcc_rp.fn_equivalenviaDoc(ln_tdoc_cyg);
          begin
            select N_CALIF0 into vo_calf 
                    from cldrcci 
                  where c_tipreg = '1' and c_tipdet = 'Z'
                    and d_fecpre = ld_FchRCC
                    and c_tdocid = ln_tdoc
                    and c_docide = trim(lv_ndoc_cyg);
          exception
            when others then
              vo_calf := 100;
          end;        
        end if;
    else    
       vo_calf := 100;
    end if;   
  end sp_pr_calif_nordef_ultimo_mes_cyg; 
  
  procedure sp_pr_calif_nordef_anterior_mes(vi_tdoc in number,
                                            vi_ndoc in varchar2,
                                            vo_calf out number) is
    -- *****************************************************************
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.06.09
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Obtener calificacion def de los anteriores 3 meses al ult
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : vi_tdoc ( Tipo documento )
    --                              vi_tdoc ( Numero documento )
    -- Parámetros de Salida       : vo_calf ( Porcentaje de calificacion )
    -- ******************************************************************
            
    ln_tdoc         varchar2(1);
    ln_tdoc_cyg     number;
    lv_ndoc_cyg     varchar2(12);
    ld_FchRCC       date;
    vi_meses        number;
    ln_calif2       number;
  begin
    vi_meses := 3;
    --buscar la fecha actual del rcc
    begin
      select to_date(Tpnro, 'DD/MM/YYYY')
        into ld_FchRCC
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    end;
    ln_tdoc := pq_cr_reglas_calificacion_rcc_rp.fn_equivalenviaDoc(vi_tdoc);
    vo_calf := 100;
    --buscar la calificacion def de los ultimos meses anteriores del titular
    for i in 1..vi_meses loop
      select ADD_MONTHS(ld_FchRCC,-1)
             into ld_FchRCC from DUAL;
      begin       
        if vi_tdoc <> 9 then
          begin
              select N_CALIF2 into ln_calif2 
                      from cldrcci 
                    where c_tipreg = '1' and c_tipdet = 'Z'
                      and d_fecpre = ld_FchRCC
                      and c_tdocid = ln_tdoc
                      and c_docide = vi_ndoc;
            exception
              when others then
                ln_calif2 := 0;
          end;
        else
            if vi_tdoc = 9 then
              begin
                select N_CALIF2 into ln_calif2 
                        from cldrcci 
                      where c_tipreg = '1' and c_tipdet = 'Z'
                        and d_fecpre = ld_FchRCC
                        and c_tdoctr = ln_tdoc
                        and c_doctri = vi_ndoc;          
              exception
                when others then
                    ln_calif2 := 0;
              end;
            end if;
        end if;             
      end; 
      --obtener la minima calificacion en los ultimos tres meses
      if ln_calif2 < vo_calf then
         vo_calf := ln_calif2;  
      end if;
    end loop;
  end sp_pr_calif_nordef_anterior_mes;
    
  procedure sp_pr_calif_nordef_anterior_mes_cyg(vi_tdoc in number,
                                                vi_ndoc in varchar2,
                                                vo_calf out number) is
    -- *****************************************************************
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.06.09
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Obtener calificacion def de los anteriores 3 meses al ult - Conyuge
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : vi_tdoc ( Tipo documento )
    --                              vi_tdoc ( Numero documento )
    -- Parámetros de Salida       : vo_calf ( Porcentaje de calificacion )
    -- ******************************************************************
            
    ln_tdoc         varchar2(1);
    ln_tdoc_cyg     number;
    lv_ndoc_cyg     varchar2(12);
    ld_FchRCC       date;
    vi_meses        number;
    ln_calif2       number;
  begin
    vi_meses := 3;
    --verificar si tiene conyuge
    begin          
       select rptdoc, rpndoc into ln_tdoc_cyg, lv_ndoc_cyg 
              from fsr002 
              where petdoc = vi_tdoc and pendoc = rpad(vi_ndoc, 12, ' ')
                and rpccyg = 66;--apachecoh 2022.07.06 solo conyuge
    exception when others then
       ln_tdoc_cyg := 0;
    end;   
    if ln_tdoc_cyg <> 0 then      
      --buscar la fecha actual del rcc
      begin
        select to_date(Tpnro, 'DD/MM/YYYY')
          into ld_FchRCC
          from FST098
         Where Pgcod = 1
           and Tpcod = 7647
           and Tpcorr = 12;
      end;
      vo_calf := 100;
      --buscar la calificacion def de los ultimos meses anteriores del conyuge
      ln_tdoc := pq_cr_reglas_calificacion_rcc_rp.fn_equivalenviaDoc(ln_tdoc_cyg);
      for i in 1..vi_meses loop
          select ADD_MONTHS(ld_FchRCC,-1)
                 into ld_FchRCC from DUAL;
          begin
            if vi_tdoc <> 9 then
              begin
                  select N_CALIF2 into ln_calif2 
                          from cldrcci 
                        where c_tipreg = '1' and c_tipdet = 'Z'
                          and d_fecpre = ld_FchRCC
                          and c_tdocid = ln_tdoc
                          and c_docide = trim(lv_ndoc_cyg);
                exception
                  when others then
                    ln_calif2 := 0;
              end;
            end if;             
          end;            
          --obtener la minima calificacion en el ultimo mes
          if ln_calif2 < vo_calf then
             vo_calf := ln_calif2;  
          end if;                     
       end loop;  
    else
      vo_calf := 0; 
    end if;
  end sp_pr_calif_nordef_anterior_mes_cyg; 
  
  function fn_equivalenviaDoc(p_tdoc in number) return varchar2 is
      cursor datos is
        select tp1nro2
          from fst198
         where tp1cod = 1
           and tp1cod1 = 11111
           and tp1corr1 = 1
           and tp1corr2 = 5
           and tp1nro1 = p_tdoc;
      resp  number(5);
      respc varchar2(1);
    begin
      resp := 1;
      for i in datos loop
        resp := i.tp1nro2;
      end loop;
      respc := to_char(resp);
      return respc;
  end fn_equivalenviaDoc; 
  
end pq_cr_reglas_calificacion_rcc_rp;
/

