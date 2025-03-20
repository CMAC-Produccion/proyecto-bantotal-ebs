create or replace procedure SP_CR_SEGLINEA_NVDD2016(P_D_FECHA   IN DATE,
                                                    P_N_PAIS    in number,
                                                    p_n_tipdoc  in number,
                                                    p_c_numdoc  in char,
                                                    p_c_usuario in varchar2,
                                                    P_N_CODCAl  out number,
                                                    P_C_DESCAL  out varchar2) is

  -- *****************************************************************
  -- Nombre                     : PROCEDIMIENTO PARA IDENTIFICAR LA SEGMENTACION DE UN CLIENTE INDEPENDIENTE Y DEPENDIENTE
  -- Sistema                    : BANTOTAL
  -- Módulo                     : 
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2016.10.28
  -- Autor de Creación          : MPOSTIGOC
  -- Uso                        : GENERACION DE DATA
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 02/01/2017
  -- Autor de la Modificación   : MPOSTIGOC  
  -- Descripción de Modificación: Verifica si ya existe un registro de calificacion con la misma PK, si existe ya no invoca al procedimiento.
  -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  ln_SegLinea number;

begin

  begin
    select b.segcod
      into ln_SegLinea
      from sngc60 a, sngc07 b
     where a.sngc60pais = P_N_PAIS
       and a.sngc60tdoc = p_n_tipdoc
       and a.sngc60ndoc = p_c_numdoc
       and a.sngc60ocup = b.sngc07cod;
  exception
    when too_many_rows then
      begin
        select b.segcod
          into ln_SegLinea
          from sngc60 a, sngc07 b
         where a.sngc60pais = P_N_PAIS
           and a.sngc60tdoc = p_n_tipdoc
           and a.sngc60ndoc = p_c_numdoc
           and a.sngc60ocup = b.sngc07cod
           and a.sngc60corr =
               (select max(a.sngc60corr)
                  from sngc60 a, sngc07 b
                 where a.sngc60pais = P_N_PAIS
                   and a.sngc60tdoc = p_n_tipdoc
                   and a.sngc60ndoc = p_c_numdoc
                   and a.sngc60ocup = b.sngc07cod);
      
      end;
    when no_data_found then
      null;
  end;

  if p_n_tipdoc = 9 then
    ln_SegLinea := 1;
  end if;

  if ln_SegLinea = 1 then
  
    begin
      begin
        select j.jaqz086calf
          into P_N_CODCAl
          from jaqz086_APL j
         where j.jaqz086paic = P_N_PAIS
           and j.jaqz086tdoc = p_n_tipdoc
           and j.jaqz086tndoc = p_c_numdoc
           and j.jaqz086usr = p_c_usuario;
      
      exception
        when others then
          null;
      end;
    
      if P_N_CODCAl is null then
        pq_cr_segmentacion_aplic.sp_carga_data(pd_fecpro => P_D_FECHA, --fecha del dia
                                               pn_pai    => P_N_PAIS, --pais
                                               pn_tdo    => p_n_tipdoc, --tipo de documento
                                               pc_doc    => p_c_numdoc, --nro de documento
                                               pc_usr    => p_c_usuario); --usuario que esta ejecutando el paquete
      
      end if;
    
      begin
      
        begin
          select jaqz086CALF
            into P_N_CODCAl
            from jaqz086_APL
           where jaqz086paic = P_N_PAIS
             and jaqz086tdoc = P_N_TIPDOC
             and jaqz086tndoc = rpad(P_C_NUMDOC, 12, ' ')
             and JAQZ086USR = P_C_USUARIO;
        exception
          when no_data_found then
            P_N_CODCAl := 0;
        end;
      
        begin
          select c1.jaqy067ncal
            into P_C_DESCAL
            from jaqy067 c1
           where c1.jaqy067ccal = P_N_CODCAl;
        exception
          when no_data_found then
            If P_N_CODCAl = 0 then
              P_C_DESCAL := 'SIN CALIFICACION';
            Else
              P_C_DESCAL := 'NO DEFINIDA';
            End If;
        end;
      end;
    
    end;
  
  else
    if ln_SegLinea = 2 then
    
      begin
        select trim(v.pae71val)
          into P_C_DESCAL
          from fpae70 n, fpae71 v
         where n.pae70nro = v.pae70nro
           and v.pae71ite = 265
           and n.pae51eva = v.pae51eva
           and v.pae51eva = 1
           and n.pae70pdoc = P_N_PAIS
           and n.pae70tdoc = p_n_tipdoc
           and n.pae70ndoc = p_c_numdoc
           and n.pae70nro = (select max(pae70nro)
                               from fpae70 f
                              where f.pae70pdoc = n.pae70pdoc
                                and f.pae70tdoc = n.pae70tdoc
                                and f.pae70ndoc = n.pae70ndoc);
      exception
        when others then
          null;
      end;
    
      begin
      
        select tp1nro1, tp1desc
          into P_N_CODCAl, P_C_DESCAL
          from fst198
         where Tp1cod = 1
           and Tp1cod1 = 10823
           and Tp1corr1 = 2
           and Tp1corr2 = 7
           and tp1nro1 >= 22
           and trim(tp1desc) = TRIM(P_C_DESCAL);
      exception
        when others then
          null;
      end;
    
      begin
        select c1.jaqy067ncal
          into P_C_DESCAL
          from jaqy067 c1
         where c1.jaqy067ccal = P_N_CODCAl;
      exception
        when no_data_found then
          If P_N_CODCAl = 0 then
            P_C_DESCAL := 'SIN CALIFICACION';
          Else
            P_C_DESCAL := 'NO DEFINIDA';
          End If;
      end;
    
    End If;
  
  end if;

end SP_CR_SEGLINEA_NVDD2016;
/

