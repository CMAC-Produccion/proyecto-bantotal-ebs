create or replace package PQ_ACT_CLI_SERVICIOS is
procedure SP_OP_CLIENTE_SERVICIO(p_n_codesv in number,p_n_codtsv in number,p_opcion in number);
procedure SP_OP_JOB_CLIENTE_SERVICIO_MEN;
procedure SP_OP_JOB_CLIENTE_SERVICIO;
end PQ_ACT_CLI_SERVICIOS;
/

create or replace package body PQ_ACT_CLI_SERVICIOS is

procedure sp_op_cliente_servicio(p_n_codesv number,p_n_codtsv number,p_opcion number) is

  -- *****************************************************************
  -- Nombre                     : sp_op_cliente_servicio
  -- Sistema                    : BANTOTAL
  -- Módulo                     : CANALES DE ATENCION Y OPERACIONES
  -- Versión                    : 1.0
  -- Fecha de Creación          : 16/01/2014
  -- Autor de Creación          : Chernandez.
  -- Uso                        : IDENTIFICA SI DEUDORES DE SERVICIOS SON CLIENTES CMAC
  -- Estado                     : Activo
  -- Fecha Modificación         : 07/02/2014
  -- Autor de Creación          : Chernandez.
  -- Descripcion Modificacion   : Optimizacion proceso.
  -- *****************************************************************

  cursor recibo is
    select distinct a.jaqy561nrcon as c_nrocon,
           replace(replace(a.jaqy561clien, '.', '%'), ' ', '%') || '%' c_nomcon
      from jaqy561 a
     where a.jaqy561coent = p_n_codesv and a.jaqy561cotse = p_n_codtsv
     order by a.jaqy561nrcon;
     
  cursor recibo_despues_carga is
    select distinct a.jaqy561nrcon as c_nrocon,
           replace(replace(a.jaqy561clien, '.', '%'), ' ', '%') || '%' c_nomcon
      from jaqy561 a
     where a.jaqy561coent = p_n_codesv and a.jaqy561cotse = p_n_codtsv 
     and a.jaqy561flag = 'S'
     order by a.jaqy561nrcon;
    
  cursor relacion_personas(pc_nomcon in varchar2) is
    select t.c_descri8 as codcli,
           t.c_descri6 as codpai,
           t.c_descri7 as codtdo
      from begreps t
     where c_descri13 like pc_nomcon; --si la persona existe en la fsd001
  
  cursor relacion_cuentas_dni(pc_codcli in varchar2,pc_codpai in varchar2,pc_codtdo in varchar2) is
  select ctnro
    from fsr008 b
   where b.pendoc = pc_codcli
     and b.pepais = pc_codpai
     and b.petdoc = pc_codtdo;
     
--  lc_codcli varchar2(20);
  lc_codcli varchar2(20);
  lc_execut varchar2(8000);
  --lc_codpai varchar2(3);
  --lc_codtdo varchar2(2);
  lc_nrocta number(9);

begin
  if p_opcion = 1 then
   --PROCESO MENSUAL
     delete from jaql519 where jaql519coent = p_n_codesv and jaql519cotsv = p_n_codtsv;

     if p_n_codesv = '1' then

        lc_execut :=
          'insert /*+append*/ into begreps(c_descri6,c_descri7,c_descri8,c_descri13)' ||
          'SELECT ' ||
          ' PEPAIS,PETDOC, PENDOC, replace(PENOM,''Ñ'',''N'') ' ||
          'FROM fsd001';
      else 
        lc_execut :=
          'insert /*+append*/ into begreps(c_descri6,c_descri7,c_descri8,c_descri13)' ||
          'SELECT ' ||
          ' PEPAIS,PETDOC, PENDOC, PENOM ' ||
          'FROM fsd001';
      end if;
      execute immediate lc_execut;
      commit;
      --Para cada contrato.
      for i in recibo loop
        --buscamos las personas que coinciden en fsd001 y obtenemos el dni
        for j in relacion_personas(i.c_nomcon) loop
            --buscamos las cuentas que tengan relacion con el dni
            for k in relacion_cuentas_dni(j.codcli,j.codpai,j.codtdo) loop
                lc_nrocta := null;
                begin
                  select 1 into lc_nrocta from Fsd011 where scstat <> 99
                  and sccta = k.ctnro and rownum = 1;
                  if lc_nrocta is not null then
                         
                      insert into jaql519
                        (jaql519coent, jaql519cotsv, jaql519nrcon, jaql519fepro, jaql519hopro, jaql519ppais, jaql519ptdoc, jaql519nrdoc)
                      values
                        (p_n_codesv, p_n_codtsv, i.c_nrocon, trunc(sysdate), TO_CHAR(sysdate,'HH24:MI:SS'), j.codpai, j.codtdo, j.codcli);
                  end if; 
                       
                exception
                when others then
                 lc_codcli := null;
                end;
            EXIT WHEN lc_nrocta is not null;
            end loop;
        EXIT WHEN lc_nrocta is not null;
        end loop;
      end loop;
   
    commit;
  end if;
  
  if p_opcion = 2 then
     
     --proceso despues de carga
     
      if p_n_codesv = '1' then

        lc_execut :=
          'insert /*+append*/ into begreps(c_descri6,c_descri7,c_descri8,c_descri13)' ||
          'SELECT ' ||
          ' PEPAIS,PETDOC, PENDOC, replace(PENOM,''Ñ'',''N'') ' ||
          'FROM fsd001';
      else 
        lc_execut :=
          'insert /*+append*/ into begreps(c_descri6,c_descri7,c_descri8,c_descri13)' ||
          'SELECT ' ||
          ' PEPAIS,PETDOC, PENDOC, PENOM ' ||
          'FROM fsd001';
      end if;
      execute immediate lc_execut;
      commit;
      --Para cada contrato.
      for i in recibo_despues_carga loop
        --buscamos las personas que coinciden en fsd001 y obtenemos el dni
        for j in relacion_personas(i.c_nomcon) loop
            --buscamos las cuentas que tengan relacion con el dni
            for k in relacion_cuentas_dni(j.codcli,j.codpai,j.codtdo) loop
                lc_nrocta := null;
                begin
                  select 1 into lc_nrocta from Fsd011 where scstat <> 99
                  and sccta = k.ctnro and rownum = 1;
                  if lc_nrocta is not null then
                         
                      insert into jaql519
                        (jaql519coent, jaql519cotsv, jaql519nrcon, jaql519fepro, jaql519hopro, jaql519ppais, jaql519ptdoc, jaql519nrdoc)
                      values
                        (p_n_codesv, p_n_codtsv, i.c_nrocon, trunc(sysdate), TO_CHAR(sysdate,'HH24:MI:SS'), j.codpai, j.codtdo, j.codcli);
                  end if; 
                       
                exception
                when others then
                 lc_codcli := null;
                end;
            EXIT WHEN lc_nrocta is not null;
            end loop;
        EXIT WHEN lc_nrocta is not null;
        end loop;
      end loop;
     commit;
     update jaqy561 set jaqy561flag = 'N'
     where jaqy561coent = p_n_codesv and jaqy561cotse = p_n_codtsv;
    commit;
  end if;
  

end sp_op_cliente_servicio;

procedure sp_op_job_cliente_servicio_men is

  -- *****************************************************************
  -- Nombre                     : sp_op_job_cliente_servicio_men
  -- Sistema                    : BANTOTAL
  -- Módulo                     : BELE
  -- Versión                    : 1.0
  -- Fecha de Creación          : 17/01/2014
  -- Autor de Creación          : Chernandez.
  -- Uso                        : Job para relacionar cliente con servicio proceso Mensual
  -- Estado                     : Activo
  -- Acceso                     :
  -- Parámetros de Entrada      :
  -- Retorno                    :
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- *****************************************************************

  cursor empre is
    select jaql508coent,jaql509cotse from jaql509 where jaql509estse = 'V';
begin

  for i in empre loop
    -- Call the procedure
    sp_op_cliente_servicio(p_n_codesv => i.jaql508coent,p_n_codtsv => i.jaql509cotse,p_opcion =>1);
  end loop;

end sp_op_job_cliente_servicio_men;

procedure sp_op_job_cliente_servicio is

  -- *****************************************************************
  -- Nombre                     : sp_op_job_cliente_servicio
  -- Sistema                    : BANTOTAL
  -- Módulo                     : BELE
  -- Versión                    : 1.0
  -- Fecha de Creación          : 17/01/2014
  -- Autor de Creación          : Chernandez.
  -- Uso                        : Job para relacionar cliente con servicio
  -- Estado                     : Activo
  -- Acceso                     :
  -- Parámetros de Entrada      :
  -- Retorno                    :
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- *****************************************************************

  cursor empre is
    select jaql508coent,jaql509cotse from jaql509 where jaql509estse = 'V';
begin

  for i in empre loop
    -- Call the procedure
    sp_op_cliente_servicio(p_n_codesv => i.jaql508coent,p_n_codtsv => i.jaql509cotse,p_opcion =>2);
  end loop;

end sp_op_job_cliente_servicio;


end PQ_ACT_CLI_SERVICIOS;
/

