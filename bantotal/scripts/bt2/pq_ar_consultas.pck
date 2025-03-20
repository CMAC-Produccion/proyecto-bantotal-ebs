create or replace package PQ_AR_CONSULTAS is
  -- ------------------------------------------------------------------------------------------------
  -- Nombre                : PQ_AR_CONSULTAS
  -- Sistema               : BANTOTAL
  -- Módulo                : ARQUITECTURA
  -- Versión               : 1.0
  -- Estado                : Activo
  -- Acceso                : Público
  --
  -- Fecha de Creación     : 05/11/2019
  -- Autor de Creación     : JPINTO
  -- Uso                   : Consultas Aplicativos ambiente de Arquitectura
  --
  -- ------------------------------------------------------------------------------------------------------------------------------------------------------

  procedure sp_buscarJAQL540(BL_DATOS   IN OUT SYS_REFCURSOR,
                             p_c_numtar in varchar2,
                             p_d_fecini in date,
                             p_d_fecfin in date,
                             p_d_codtrx in char,
                             p_c_coderr out varchar2,
                             p_c_msgerr out varchar2);

  procedure sp_buscarJAQL539(BL_DATOS   IN OUT SYS_REFCURSOR,
                             p_n_codtra in number,
                             p_c_coderr out varchar2,
                             p_c_msgerr out varchar2);

  procedure sp_buscarCuentaSaldoMayor(p_c_numtar    in varchar2,
                                      p_n_codmon    in number,
                                      p_n_produc    in number,
                                      p_n_scsdo     out number,
                                      p_n_z0e479pgc out number,
                                      p_n_z0e479suc out number,
                                      p_n_z0e479cta out number,
                                      p_n_z0e479sct out number,
                                      p_n_z0e479mod out number,
                                      p_n_z0e479mon out number,
                                      p_n_z0e479pap out number,
                                      p_n_z0e479top out number,
                                      p_n_z0e479ope out number,
                                      p_c_coderr    out varchar2,
                                      p_c_msgerr    out varchar2);

--
end PQ_AR_CONSULTAS;
/

create or replace package body PQ_AR_CONSULTAS is
  --//
  procedure sp_buscarJAQL540(BL_DATOS   IN OUT SYS_REFCURSOR,
                             p_c_numtar in varchar2,
                             p_d_fecini in date,
                             p_d_fecfin in date,
                             p_d_codtrx in char,
                             p_c_coderr out varchar2,
                             p_c_msgerr out varchar2) is
    -- --------------------------------------------------------------------------------------------------------------
    -- Nombre                : sp_buscarJAQL540
    -- Sistema               : BANTOTAL
    -- Módulo                : ATMs
    -- Versión               : 1.0
    -- Fecha de Creación     : 05/11/2019
    -- Autor de Creación     : JPINTO
    -- Uso                   : Buscar registros en el LOG de transacciones de cajeros automáticos y transacciones VISA  
    -- Estado                : Activo
    -- Acceso                : Público
    -- Fecha de Modificación : 
    -- Autor de Creación     : 
    -- Descripción Modific.  : 
    -- --------------------------------------------------------------------------------------------------------------
  begin
    --// Inicialización 
    p_c_coderr := '00000';
    p_c_msgerr := '';
    --//
    begin
      OPEN BL_DATOS FOR
        select a1.jaql540comsj,
               a1.jaql540cotra,
               a1.jaql540coing,
               a1.jaql540cores,
               a1.jaql540feini,
               a1.jaql540hoini,
               a1.jaql540fefin,
               a1.jaql540hofin,
               a1.jaql540coter,
               a1.jaql540cotrx,
               a1.jaql540nutra,
               a1.jaql540tmout,
               a1.jaql540relac,
               a1.jaql540trans,
               a1.jaql540modul,
               a1.jaql540paist,
               a1.jaql540nutar,
               a1.jaql540userc,
               a1.jaql540coref,
               a1.jaql540auxd2,
               a1.jaql540auxv2,
               a1.jaql540auxv1,
               a1.jaql540auxn2,
               a1.jaql540auxn1,
               a1.jaql540auxc2,
               a1.jaql540auxc1,
               a1.jaql540trama,
               a1.jaql540fetra
          from jaql540 a1
         where a1.jaql540nutar = p_c_numtar
           and a1.jaql540feini >= p_d_fecini
           and a1.jaql540fefin <= p_d_fecfin
           and a1.jaql540cotrx = p_d_codtrx;
    exception
      when others then
        p_c_coderr := '01000';
        p_c_msgerr := 'No Existen registros encontrados';
    end;
    --//    
  exception
    when others then
      p_c_coderr := sqlcode;
      p_c_msgerr := sqlerrm;
  end sp_buscarJAQL540;
  --//
  procedure sp_buscarJAQL539(BL_DATOS   IN OUT SYS_REFCURSOR,
                             p_n_codtra in number,
                             p_c_coderr out varchar2,
                             p_c_msgerr out varchar2) is
    -- --------------------------------------------------------------------------------------------------------------
    -- Nombre                : sp_buscarJAQL539
    -- Sistema               : BANTOTAL
    -- Módulo                : ATMs
    -- Versión               : 1.0
    -- Fecha de Creación     : 05/11/2019
    -- Autor de Creación     : JPINTO
    -- Uso                   : Buscar registros en el LOG de transacciones de cajeros automáticos y transacciones VISA  
    -- Estado                : Activo
    -- Acceso                : Público
    -- Fecha de Modificación : 
    -- Autor de Creación     : 
    -- Descripción Modific.  : 
    -- --------------------------------------------------------------------------------------------------------------
  begin
    --// Inicialización 
    p_c_coderr := '00000';
    p_c_msgerr := '';
    --//
    begin
      OPEN BL_DATOS FOR
        select a1.jaql539cotra,
               a1.jaql539nucam,
               a1.jaql539timsj,
               a1.jaql539valtr
          from jaql539 a1
         where a1.jaql539cotra = p_n_codtra;
    exception
      when others then
        p_c_coderr := '01000';
        p_c_msgerr := 'No Existen registros encontrados';
    end;
    --//    
  exception
    when others then
      p_c_coderr := sqlcode;
      p_c_msgerr := sqlerrm;
  end sp_buscarJAQL539;

  procedure sp_buscarCuentaSaldoMayor(p_c_numtar    in varchar2,
                                      p_n_codmon    in number,
                                      p_n_produc    in number,
                                      p_n_scsdo     out number,
                                      p_n_z0e479pgc out number,
                                      p_n_z0e479suc out number,
                                      p_n_z0e479cta out number,
                                      p_n_z0e479sct out number,
                                      p_n_z0e479mod out number,
                                      p_n_z0e479mon out number,
                                      p_n_z0e479pap out number,
                                      p_n_z0e479top out number,
                                      p_n_z0e479ope out number,
                                      p_c_coderr    out varchar2,
                                      p_c_msgerr    out varchar2) is
    -- --------------------------------------------------------------------------------------------------------------
    -- Nombre                : sp_buscarCuentaSaldoMayor
    -- Sistema               : BANTOTAL
    -- Módulo                : ATMs
    -- Versión               : 1.0
    -- Fecha de Creación     : 05/11/2019
    -- Autor de Creación     : JPINTO
    -- Uso                   : Buscar registros en el LOG de transacciones de cajeros automáticos y transacciones VISA  
    -- Estado                : Activo
    -- Acceso                : Público
    -- Fecha de Modificación : 
    -- Autor de Creación     : 
    -- Descripción Modific.  : 
    -- --------------------------------------------------------------------------------------------------------------
  begin
    --// Inicialización 
    p_c_coderr := '00000';
    p_c_msgerr := '';
    --//
    if p_n_produc = 2 then
      begin
        select scsdo,
               z0e479pgc,
               z0e479suc,
               z0e479cta,
               z0e479sct,
               z0e479mod,
               z0e479mon,
               z0e479pap,
               z0e479top,
               z0e479ope
          into p_n_scsdo,
               p_n_z0e479pgc,
               p_n_z0e479suc,
               p_n_z0e479cta,
               p_n_z0e479sct,
               p_n_z0e479mod,
               p_n_z0e479mon,
               p_n_z0e479pap,
               p_n_z0e479top,
               p_n_z0e479ope
          from (select a3.scsdo,
                       a2.z0e479pgc,
                       a2.z0e479suc,
                       a2.z0e479cta,
                       a2.z0e479sct,
                       a2.z0e479mod,
                       a2.z0e479mon,
                       a2.z0e479pap,
                       a2.z0e479top,
                       a2.z0e479ope
                  from z0e479 a2, fsd011 a3
                 where a2.z0e479pgc = a3.pgcod
                   and a2.z0e479mod = a3.scmod
                   and a2.z0e479mon = a3.scmda
                   and a2.z0e479pap = a3.scpap
                   and a2.z0e479cta = a3.sccta
                   and a2.z0e479suc = a3.scsuc
                   and a2.z0e479ope = a3.scoper
                   and a2.z0e479sct = a3.scsbop
                   and a2.z0e479top = a3.sctope
                   and a2.z0e478nro = rpad(p_c_numtar, 19, ' ')
                   and a2.z0e479est = 'AC'
                   and a2.z0e479mod <> 22
                   and a3.scstat in (0, 5)
                   and a2.z0e479mon = p_n_codmon
                   and a2.z0e479top = p_n_produc
                 order by a3.scsdo desc)
         where rownum <= 1;
      exception
        when others then
          p_c_coderr := '01000';
          p_c_msgerr := sqlerrm;
      end;
    else
      begin
        select scsdo,
               z0e479pgc,
               z0e479suc,
               z0e479cta,
               z0e479sct,
               z0e479mod,
               z0e479mon,
               z0e479pap,
               z0e479top,
               z0e479ope
          into p_n_scsdo,
               p_n_z0e479pgc,
               p_n_z0e479suc,
               p_n_z0e479cta,
               p_n_z0e479sct,
               p_n_z0e479mod,
               p_n_z0e479mon,
               p_n_z0e479pap,
               p_n_z0e479top,
               p_n_z0e479ope
          from (select a3.scsdo,
                       a2.z0e479pgc,
                       a2.z0e479suc,
                       a2.z0e479cta,
                       a2.z0e479sct,
                       a2.z0e479mod,
                       a2.z0e479mon,
                       a2.z0e479pap,
                       a2.z0e479top,
                       a2.z0e479ope
                  from z0e479 a2, fsd011 a3
                 where a2.z0e479pgc = a3.pgcod
                   and a2.z0e479mod = a3.scmod
                   and a2.z0e479mon = a3.scmda
                   and a2.z0e479pap = a3.scpap
                   and a2.z0e479cta = a3.sccta
                   and a2.z0e479suc = a3.scsuc
                   and a2.z0e479ope = a3.scoper
                   and a2.z0e479sct = a3.scsbop
                   and a2.z0e479top = a3.sctope
                   and a2.z0e478nro = rpad(p_c_numtar, 19, ' ')
                   and a2.z0e479mod <> 22
                   and a2.z0e479est = 'AC'
                   and a3.scstat in (0, 5)
                   and a2.z0e479mon = p_n_codmon
                   and a2.z0e479top <> 2
                 order by a3.scsdo desc)
         where rownum <= 1;
      exception
        when others then
          p_c_coderr := '01000';
          p_c_msgerr := sqlerrm;
      end;
    end if;
    --//    
  exception
    when others then
      p_c_coderr := sqlcode;
      p_c_msgerr := sqlerrm;
  end sp_buscarCuentaSaldoMayor;

--//
end PQ_AR_CONSULTAS;
/

