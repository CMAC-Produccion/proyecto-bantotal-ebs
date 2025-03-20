create or replace package "PQ_CR_SEGMENTACION_CREDINKA" is
  -- *****************************************************************
  -- Nombre                     : pq_cr_segmentacion_credinka
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Creditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2024.12.16
  -- Autor de Creación          : YYAMPI
  -- Uso                        : variables de segmentacion credinka
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : 
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- *****************************************************************

  Procedure sp_antiguedad_rcc(pn_instancia in number,
                              pn_descrip   out number,
                              pn_coderr    out number,
                              pv_meserr    out varchar);

  Procedure sp_antiguedad_rcc_cli(pn_pais    in number,
                                  pn_tipdoc  in number,
                                  pv_numdoc  in varchar,
                                  pn_descrip out number,
                                  pn_coderr  out number,
                                  pv_meserr  out varchar);

end pq_cr_segmentacion_credinka;
 /* GOLDENGATE_DDL_REPLICATION */
/

create or replace package body "PQ_CR_SEGMENTACION_CREDINKA" is

  ------------------------------------------------------------------

  Procedure sp_antiguedad_rcc(pn_instancia in number,
                              pn_descrip   out number,
                              pn_coderr    out number,
                              pv_meserr    out varchar) is
  
    -- *****************************************************************
    -- Nombre                     : sp_antiguedad_rcc
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.12.16
    -- Autor de Creación          : YYAMPI
    -- Uso                        : calcula antiguedad rcc credinka
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_instancia ( INSTANCIA )
    --                            : pv_descrip ( Resultado )
    -- Parámetros de Salida       : pn_coderr ( CODIGO ERROR )
    --                            : pv_meserr ( MENSAJE DE ERROR )
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************
  
    ln_tp1cod   number := 1;
    ln_tp1cod1  number := 10847;
    ln_tp1corr1 number := 1000;
    ln_tp1corr2 number := 1;
    ln_tp1corr3 number := 0;
    ln_coderr   number := 0;
    lv_meserr   varchar(60) := 'Ok';
    ln_descrip  number(10) := 0;
  
  begin
    /*obtener el ultimo correlativo 3 */
  
    select nvl(max(t.aqpb298ant), -1)
      into ln_descrip
      from AQPB298 t, sng001 i, fst198 c
     where t.aqpb298pais = i.sng001pais
       and t.aqpb298tdoc = i.sng001tdoc
       and t.aqpb298ndoc = i.sng001ndoc
       and i.sng001inst = pn_instancia
       and t.AQPB298est = 'S'
       and c.tp1cod = 1
       and c.tp1cod1 = 10847
       and c.tp1corr1 = 907
       and c.tp1corr2 = 1
       and t.aqpb298fec = to_date((c.tp1desc), 'dd/mm/rrrr');
  
    pn_descrip := ln_descrip;
  
    if ln_descrip = -1 then
      pn_coderr := 1;
      pv_meserr := 'registro no existe';
    end if;
  
  exception
    when others then
      pn_descrip := -1;
      pn_descrip := ln_descrip;
      pn_coderr  := sqlcode;
      pv_meserr  := sqlerrm;
      --  dbms_output.put_line('error correlativo:' || sqlerrm);
  
  end sp_antiguedad_rcc;

  -----------------------------------------------------------------------------------

  Procedure sp_antiguedad_rcc_cli(pn_pais    in number,
                                  pn_tipdoc  in number,
                                  pv_numdoc  in varchar,
                                  pn_descrip out number,
                                  pn_coderr  out number,
                                  pv_meserr  out varchar) is
  
    -- *****************************************************************
    -- Nombre                     : sp_antiguedad_rcc_cli
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.12.16
    -- Autor de Creación          : YYAMPI
    -- Uso                        : calcula antiguedad rcc credinka
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_instancia ( INSTANCIA )
    --                            : pv_descrip ( Resultado )
    -- Parámetros de Salida       : pn_coderr ( CODIGO ERROR )
    --                            : pv_meserr ( MENSAJE DE ERROR )
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************
  
    ln_tp1cod   number := 1;
    ln_tp1cod1  number := 10847;
    ln_tp1corr1 number := 1000;
    ln_tp1corr2 number := 1;
    ln_tp1corr3 number := 0;
    ln_coderr   number := 0;
    lv_meserr   varchar(60) := 'Ok';
    ln_descrip  number(10) := 0;
    lc_numdoc   char(12) := '';
  
  begin
    /*obtener el ultimo correlativo 3 */
    lc_numdoc := pv_numdoc;
  
    select nvl(max(t.aqpb298ant), -1)
      into ln_descrip
      from AQPB298 t, fst198 c
     where t.aqpb298pais = pn_pais
       and t.aqpb298tdoc = pn_tipdoc
       and t.aqpb298ndoc = lc_numdoc
       and t.AQPB298est = 'S'
       and c.tp1cod = 1
       and c.tp1cod1 = 10847
       and c.tp1corr1 = 907
       and c.tp1corr2 = 1
       and t.aqpb298fec = to_date((c.tp1desc), 'dd/mm/rrrr');
  
    pn_descrip := ln_descrip;
  
    if ln_descrip = -1 then
      pn_coderr := 1;
      pv_meserr := 'registro no existe';
    end if;
  
  exception
    when others then
      pn_descrip := -1;
      pn_descrip := ln_descrip;
      pn_coderr  := sqlcode;
      pv_meserr  := sqlerrm;
      --  dbms_output.put_line('error correlativo:' || sqlerrm);
  
  end sp_antiguedad_rcc_cli;

----------------------------------------------------------------------------------------
end pq_cr_segmentacion_credinka;
 /* GOLDENGATE_DDL_REPLICATION */
/

