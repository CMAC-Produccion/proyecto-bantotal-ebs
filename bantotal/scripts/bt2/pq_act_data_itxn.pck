create or replace package PQ_ACT_DATA_ITXN is
  -- Author  : Fpinto
  -- Created : 25/09/2024 
  -- Purpose : Actualizacion de Fecha de cumpleaños en ITXN
  -- Fecha Modificación         : 21/10/2024
  -- Autor de Modificación      : Fpinto
  -- Descripcion Modificacion   : Correccion de SP_ACT_BIRTHDAY_INI
  -- Fecha Modificación         : 
  -- Autor de Modificación      : 
  -- Descripcion Modificacion   : 
  -- Public type declarations

procedure SP_ACT_BIRTHDAY(p_n_fecha in date);
procedure SP_ACT_BIRTHDAY_INI(p_n_fecha in date, p_n_fechafin in date);
end PQ_ACT_DATA_ITXN;
/

create or replace package body PQ_ACT_DATA_ITXN is

  procedure SP_ACT_BIRTHDAY(p_n_fecha in date) is

    -- *****************************************************************
    -- Nombre                     : SP_ACT_BIRTHDAY
    -- Sistema                    : BANTOTAL
    -- Módulo                     : ATM
    -- Versión                    : 1.0
    -- Fecha de Creación          : 27/08/2024
    -- Autor de Creación          : Frank Pinto Carpio
    -- Uso                        : Actualiza campo de cumpleaños en tabla CARD de ITXN
    -- Estado                     : Activo
    -- Fecha Modificación         : 21/10/2024
    -- Autor de Modificación      : Fpinto
    -- Descripcion Modificacion   : Correccion de SP_ACT_BIRTHDAY_INI
    -- *****************************************************************

     cursor tarjetas_fecha(fnac date)  is
     select a.z0e478nro,b.PFFNAC from z0e478 a
     inner join fsd002 b on a.Z0E478THP = b.PFPAIS and a.Z0E478THT=b.PFTDOC and Z0E478THD=b.PFNDOC
     where a.z0e463cod in (1,7) and a.z0e478fal=fnac;

     p_N_TOTAL NUMERIC (9);
     p_N_ERROR numeric (9);
     lc_fecha date;
     --fechaMod char(10);
     lc_hora char(10);
     error exception;
     Coderr char(5);
     DescErr varchar2(100);
  begin
    
    --SI NO SE INGRESA FECHA TOMA EL VALOR DE LA TABLA FST017       
    if p_n_fecha is null then
      select pgfape into lc_fecha from fst017 where pgcod = 1;
    else
      lc_fecha := p_n_fecha;
    end if;  
    --fechaMod := to_char(lc_fecha,'DD/MM/YYYY');
    Coderr := '00000';
    DescErr := 'Proceso Correcto';
    p_N_TOTAL:= 0;
    p_N_ERROR:= 0;
    for i in tarjetas_fecha(lc_fecha) loop
      begin 
        update card@cajero a set a.BIRTHDATE=i.PFFNAC where a.pan = i.z0e478nro; --1 registro
        commit;
        p_N_TOTAL:= p_N_TOTAL + 1;
       exception
           when error then
             p_N_ERROR := p_N_ERROR +1;    
       end;     
    end loop;
    
    if p_N_ERROR>0 then
       Coderr := '00001';
       DescErr := 'Error de Actualizacion';   
    end if;
    
    select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;   
    insert into AQPB145 (aqpb145fepro, aqpb145hopro, aqpb145cant, aqpb145pro, aqpb145coderr, aqpb145desc,
                            aqpb145aux1, aqpb145aux2, aqpb145aux3) 
                values (lc_fecha, lc_hora,p_N_TOTAL,'UPDATE BIRTHDAY',Coderr,DescErr,'',' ',p_N_ERROR);
    commit;

  end SP_ACT_BIRTHDAY;

  procedure SP_ACT_BIRTHDAY_INI(p_n_fecha in date, p_n_fechafin in date) is

    -- *****************************************************************
    -- Nombre                     : SP_ACT_BIRTHDAY
    -- Sistema                    : BANTOTAL
    -- Módulo                     : ATM
    -- Versión                    : 1.0
    -- Fecha de Creación          : 27/08/2024
    -- Autor de Creación          : Frank Pinto Carpio
    -- Uso                        : Actualiza todos los cumpleaños en tabla CARD de ITXN segun fecha enviada
    -- Estado                     : Activo
    -- Fecha Modificación         : fpinto
    -- Autor de Creación          : 21/10/2024
    -- Descripcion Modificacion   : se corrige datos faltantes een llenado  de tabla log
    -- *****************************************************************

     cursor tarjetas_fecha  is
     select a.z0e478nro,b.PFFNAC from z0e478 a
     inner join fsd002 b on a.Z0E478THP = b.PFPAIS and a.Z0E478THT=b.PFTDOC and Z0E478THD=b.PFNDOC
     where a.z0e463cod in (1,7) and a.z0e478fal between p_n_fecha and p_n_fechafin;

     p_N_TOTAL NUMERIC (9);
     p_N_ERROR numeric (9);
     lc_fecha date;
     --fechaMod char(10);
     lc_hora char(10);
     error exception;
     Coderr char(5);
     DescErr varchar2(100);
  begin
    
    --fechaMod := to_char(lc_fecha,'DD/MM/YYYY');
    Coderr := '00000';
    DescErr := 'Proceso Correcto';
    p_N_TOTAL:= 0;
    p_N_ERROR:= 0;
    for i in tarjetas_fecha loop
      begin 
        update card@cajero a set a.BIRTHDATE=i.PFFNAC where a.pan = i.z0e478nro; --1 registro
        commit;
        p_N_TOTAL:= p_N_TOTAL + 1;
       exception
           when error then
             p_N_ERROR := p_N_ERROR +1;    
       end;     
    end loop;
    
    if p_N_ERROR>0 then
       Coderr := '00001';
       DescErr := 'Error de Actualizacion';   
    end if;
    select sysdate() into lc_fecha from dual; --fpinto 21/10/2024
    select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;   
    insert into AQPB145 (aqpb145fepro, aqpb145hopro, aqpb145cant, aqpb145pro, aqpb145coderr, aqpb145desc,
                            aqpb145aux1, aqpb145aux2, aqpb145aux3) 
                values (lc_fecha, lc_hora,p_N_TOTAL,'UPDATE BIRTHDAY',Coderr,DescErr,p_n_fecha,p_n_fechafin,p_N_ERROR); --fpinto 21/10/2024
    commit;

  end SP_ACT_BIRTHDAY_INI;

end PQ_ACT_DATA_ITXN;
/

