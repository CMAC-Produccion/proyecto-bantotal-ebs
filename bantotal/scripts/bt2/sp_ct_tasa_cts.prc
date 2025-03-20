create or replace procedure SP_CT_TASA_CTS(P_PGCO number,
                                           P_FECH date,
                                           P_SCCT number,
                                           P_SCSB number,
                                           P_SCMO number,
                                           P_FEAP date,
                                           P_FEVC date,
                                           P_FETA date,
                                           P_FEPR date,
                                           P_TITA varchar2,
                                           P_TASA number,
                                           P_TIPO varchar2,
                                           P_SALD number,
                                           P_TASN out number,
                                           P_MSGE out varchar2) is
   -- *****************************************************************
    -- Nombre                     : SP_CT_TASA_CTS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 01/01/2022
    -- Autor de Creación          : Mersali Araujo
    -- Uso                        : Tasas de CTS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Retorno                    : 
    -- Fecha modificación         : 22/10/2024
    -- Usuario modificacón        : Mersali Araujo
    -- Modificación               : se agregó filtro para cuentas migradas en jaql054
    -- *****************************************************************    
  /************************************************************************

  ************************************************************************/

  pragma autonomous_transaction;

  v_HORA   char(8) := to_char(sysdate, 'HH24:mi:ss');
  vmigrada char(1);

begin

  begin
    select 'S'
      into vmigrada
      from jaql054
     where jaql54enti = 230
       and JAQL54TIMI = 'M'
       and jaql54scmo = 21
       and jaql54scto = 2
       and jaql54scct = P_SCCT
       and jaql54scsb = P_SCSB
       and JAQl54SCMD = P_SCMO;
  exception
    when no_data_found then
      vmigrada := 'N';
  end;

  If vmigrada = 'S' then
     P_TASN := P_TASA;
     P_MSGE := 'Cuenta migrada';    
     
      insert into jaqz605
        (jaqz605pgco,
         jaqz605fech,
         jaqz605hora,
         jaqz605scct,
         jaqz605scsb,
         jaqz605scmd,
         jaqz605feap,
         jaqz605fevc,
         jaqz605feta,
         jaqz605fepr,
         jaqz605tita,
         jaqz605tasa,
         jaqz605tipo,
         jaqz605tasn,
         jaqz605sald,
         jaqz605au01)
      values
        (P_PGCO,
         P_FECH,
         v_HORA,
         P_SCCT,
         P_SCSB,
         P_SCMO,
         P_FEAP,
         P_FEVC,
         P_FETA,
         P_FEPR,
         P_TITA,
         P_TASA,
         P_TIPO,
         P_TASN,
         P_SALD,
         P_MSGE);

      commit;     
     
     Return;
  End If;
  
  begin
    If P_FEAP is not null and P_TIPO = 'M' then
      -- si es el proceso mensual y está parametrizada una fecha especial 
      If P_FEVC <= P_FEAP then
        -- si la fecha de apertura de la cts es antes de la fecha especial
        begin
          select JAQL91TASA
            into P_TASN
            from (select JAQL91TASA
                    from jaql091
                   Where JAQL91TITA = P_TITA
                     and JAQL91SCMO = 21
                     and JAQL91SCMD = P_SCMO
                     and JAQL91SCTO = 2
                     and JAQL91AU10 = P_FETA
                     and JAQL91MTMI <= P_SALD
                     and JAQL91MTMA >= P_SALD
                   order by JAQL91AU10 desc, JAQL91MTMI, JAQL91MTMA)
           where rownum = 1;
        
        exception
          when no_data_found then
            P_MSGE := 'No se encontró tasa para tipo de tarifario';
        End;
      Else
        -- tasa de tarifario
        begin
          select JAQL91TASA
            into P_TASN
            from (select JAQL91TASA
                    from jaql091
                   Where JAQL91TITA = P_TITA
                     and JAQL91SCMO = 21
                     and JAQL91SCMD = P_SCMO
                     and JAQL91SCTO = 2
                     and JAQL91AU10 <= P_FEPR
                     and JAQL91MTMI <= P_SALD
                     and JAQL91MTMA >= P_SALD
                   order by JAQL91AU10 desc, JAQL91MTMI, JAQL91MTMA)
           where rownum = 1;
        
        exception
          when no_data_found then
            P_MSGE := 'No se encontró tasa para tipo de tarifario';
        End;
      End if;
    Else
      -- si no hay tasa por fecha especial toma fecha tarifario
      begin
        select JAQL91TASA
          into P_TASN
          from (select JAQL91TASA
                  from jaql091
                 Where JAQL91TITA = P_TITA
                   and JAQL91SCMO = 21
                   and JAQL91SCMD = P_SCMO
                   and JAQL91SCTO = 2
                   and JAQL91AU10 <= P_FEPR
                   and JAQL91MTMI <= P_SALD
                   and JAQL91MTMA >= P_SALD
                 order by JAQL91AU10 desc, JAQL91MTMI, JAQL91MTMA)
         where rownum = 1;
      
      exception
        when no_data_found then
          P_MSGE := 'No se encontró tasa para tipo de tarifario';
      End;
    End If;
  
  exception
    when others then
      P_TASN := 0;
      P_MSGE := sqlerrm;
  end;

  insert into jaqz605
    (jaqz605pgco,
     jaqz605fech,
     jaqz605hora,
     jaqz605scct,
     jaqz605scsb,
     jaqz605scmd,
     jaqz605feap,
     jaqz605fevc,
     jaqz605feta,
     jaqz605fepr,
     jaqz605tita,
     jaqz605tasa,
     jaqz605tipo,
     jaqz605tasn,
     jaqz605sald,
     jaqz605au01)
  values
    (P_PGCO,
     P_FECH,
     v_HORA,
     P_SCCT,
     P_SCSB,
     P_SCMO,
     P_FEAP,
     P_FEVC,
     P_FETA,
     P_FEPR,
     P_TITA,
     P_TASA,
     P_TIPO,
     P_TASN,
     P_SALD,
     P_MSGE);

  commit;

exception
  when others then
    P_TASN := 0;
    P_MSGE := sqlerrm;
end SP_CT_TASA_CTS;
/

