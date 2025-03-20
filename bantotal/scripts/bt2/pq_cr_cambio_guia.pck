create or replace package pq_cr_cambio_guia is
  -- *****************************************************************
  -- Nombre                     : pq_cr_cambio_guia
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Creditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2024.10.25
  -- Autor de Creación          : YYAMPI
  -- Uso                        : insertar excepciones en la guia especial de procesos
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : 
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- *****************************************************************

  Procedure sp_insert_excepcion_guia(pn_instancia in number,
                                     pv_descrip   in varchar,
                                     pn_coderr    out number,
                                     pv_meserr    out varchar);

end pq_cr_cambio_guia;
/

create or replace package body pq_cr_cambio_guia is

  ------------------------------------------------------------------

  Procedure sp_insert_excepcion_guia(pn_instancia in number,
                                     pv_descrip   in varchar,
                                     pn_coderr    out number,
                                     pv_meserr    out varchar) is
  
    -- *****************************************************************
    -- Nombre                     : sp_insert_excepcion_guia
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.10.25
    -- Autor de Creación          : YYAMPI
    -- Uso                        : INSERTA EN GUIA DE EXCEPCIONES POR INSTANCIAS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_instancia ( INSTANCIA )
    --                            : pv_descrip ( DESCRIPCION )
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
  begin
    /*obtener el ultimo correlativo 3 */
    begin
    
      select nvl(max(nvl(f.tp1corr3, 0)), 0) + 1
        into ln_tp1corr3
        from fst198 f
       where f.tp1cod = ln_tp1cod
         and f.tp1cod1 = ln_tp1cod1
         and f.tp1corr1 = ln_tp1corr1
         and f.tp1corr2 = ln_tp1corr2
      --and f.tp1nro1 = 114603970
      ;
    exception
      when others then
        ln_tp1corr3 := 0;
        pn_coderr   := sqlcode;
        pv_meserr   := sqlerrm;
        dbms_output.put_line('error correlativo:' || sqlerrm);
    end;
  
    /*insertar el instancia y comentario */
    begin
    
      insert into fst198
        (TP1COD,
         TP1COD1,
         TP1CORR1,
         TP1CORR2,
         TP1CORR3,
         TP1NRO1,
         TP1NRO2,
         TP1NRO3,
         TP1DESC,
         TP1IMP1,
         TP1IMP2,
         TP1IMP3)
      values
        (ln_tp1cod,
         ln_tp1cod1,
         ln_tp1corr1,
         ln_tp1corr2,
         ln_tp1corr3,
         pn_instancia,
         0,
         0,
         substr(nvl(pv_descrip, ''), 1, 30),
         0.00,
         0.00,
         0.00);
    
      commit;
      dbms_output.put_line('se registro exitosamente');

      begin
        insert into AQPB876 values (user,sysdate,'PQ_CR_CAMBIO_GUIA.SP_INSERT_EXCEPCION_GUIA',  pn_instancia||'-'||substr(nvl(pv_descrip, ''), 1, 30));
        commit;
      exception when others then null;  
      end;

    
    exception
      when others then
      
        pn_coderr := sqlcode;
        pv_meserr := sqlerrm;
        dbms_output.put_line('error correlativo:' || sqlerrm);
    end;
  
  end sp_insert_excepcion_guia;

-----------------------------------------------------------------------------------
end pq_cr_cambio_guia;
/

