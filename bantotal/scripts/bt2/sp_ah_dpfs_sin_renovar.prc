CREATE OR REPLACE PROCEDURE "SP_AH_DPFS_SIN_RENOVAR"
is
  -- *****************************************************************
  -- NOMBRE                     : SP_AH_DPFS_SIN_RENOVAR
  -- SISTEMA                    : BANTOTAL
  -- MÓDULO                     : AHORROS
  -- VERSIÓN                    : 1.0
  -- FECHA DE CREACIÓN          : 01/12/2023
  -- AUTOR DE CREACIÓN          : LUIS CARPIO/ERIKA HIDALGO
  -- USO                        : CORREGIR DPFS SIN RENOVAR
  -- ESTADO                     : ACTIVO
  -- PARÁMETROS DE ENTRADA      :
  -- FECHA DE MODIFICACIÓN      :
  -- AUTOR DE MODIFICACIÓN      :

  vfval date;
  vfven date;
  vta   number(17, 4);
  vtae  number(17, 4);
  vsal  number(17, 4);
  ca1   number(17, 4);
  ca2   number(17, 4);
  ca3   number(17, 4);
  ca4   number(17, 4);
  ca5   number(17, 4);
  ca6   number(9);
  rubro number(9);
  vpzo  number(9);
  n_contloop number:=0;
  cursor base is
    select a.*,
           (select sum(u.AOPZO)
              from fsd010 u
             where u.PGCOD = 1
               and u.AOMOD = 22
               and u.AOCTA = a.SCCTA
               and u.AOOPER = a.SCOPER
               and u.AOTOPE = a.SCTOPE
               and u.AOSBOP >= a.SCSBOP - 1) PLAZO,
           scfvto - (select min(u.AOFVAL)
                       from fsd010 u
                      where u.PGCOD = 1
                        and u.AOMOD = 22
                        and u.AOCTA = a.SCCTA
                        and u.AOOPER = a.SCOPER
                        and u.AOTOPE = a.SCTOPE
                        and u.AOSBOP >= a.SCSBOP - 1) TOTAL
      from fsd011 a
     where pgcod = 1
       and scmod = 22
       and scsbop > 0
       and (select sum(u.AOPZO)
              from fsd010 u
             where u.PGCOD = 1
               and u.AOMOD = 22
               and u.AOCTA = a.SCCTA
               and u.AOOPER = a.SCOPER
               and u.AOTOPE = a.SCTOPE
               and u.AOSBOP >= a.SCSBOP - 1) <>
           scfvto - (select min(u.AOFVAL)
                       from fsd010 u
                      where u.PGCOD = 1
                        and u.AOMOD = 22
                        and u.AOCTA = a.SCCTA
                        and u.AOOPER = a.SCOPER
                        and u.AOTOPE = a.SCTOPE
                        and u.AOSBOP >= a.SCSBOP - 1);

BEGIN
  for i in base loop
    -- dbms_output.put_line('inicio cta: ' || i.DVCTA || '  ' || systimestamp  );
    ca1   := i.scsuc;
    ca2   := i.scmda;
    ca3   := i.sccta;
    ca4   := i.scsbop;
    ca5   := i.sctope;
    ca6   := i.scoper;
    vpzo  := i.scpzo;
    rubro := 1;
    begin
      select aofvto
        into vfval
        from fsd010 l
       where l.PGCOD = 1
         and l.aoSUC = ca1
         and l.aoMDA = ca2
         and l.aoCTA = ca3
         and l.aoOPER = ca6
         and l.aoSBOP = ca4 - 1
         and l.aoTOPE = ca5
         and aomod = 22;
      vfven := vfval + vpzo;
    exception
      when others then
        rubro := 0;
    end;
    if rubro = 1 then
      update fsd010 o
         set AOFVAL = vfval, AOFVTO = vfven
       where o.PGCOD = 1
         and o.AOMOD = 22
         and o.AOCTA = ca3
         and o.AOOPER = ca6
         and aosbop = ca4;
      update fsd011 m
         set SCFVAL = vfval, SCFVTO = vfven
       where m.PGCOD = 1
         and m.SCMOD = 22
         and m.SCCTA = ca3
         and m.SCOPER = ca6
         and scsbop = ca4;
      update fsd601 p
         set PPFPAG = vfven, PPFVAL = vfval, PPFVTO = vfven
       where p.PGCOD = 1
         and p.ppMOD = 22
         and p.ppCTA = ca3
         and p.ppOPER = ca6
         and ppsbop = ca4;
      update fsd602 q
         set PPFPAG = vfven
       where q.PGCOD = 1
         and q.ppMOD = 22
         and q.ppCTA = ca3
         and q.ppOPER = ca6
         and ppsbop = ca4;
      commit;
      n_contloop := n_contloop +1;
      --dbms_output.put_line(' cta: ' || ca3 || '  ' || systimestamp  || '  || );
    end if;
  end loop;
  if n_contloop>0 then
    insert into AQPB876 values (user,sysdate,'SP_AH_DPFS_SIN_RENOVAR',  'Número de registros actualizados del cursor : '||n_contloop);
    commit;
    begin
      sys.sp_sy_enviamail('bantoem@cajaarequipa.pe',
                          'lcarpio@cajaarequipa.pe',
                          'SP_AH_DPFS_SIN_RENOVAR ejecutado',
                          'BD=' || sys_context('USERENV', 'DB_NAME') ||
                          CHR(13) || 'INSTANCIA=' ||
                          sys_context('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                          'Hora Actual en Servidor : ' ||
                          to_char(sysdate, 'HH24:MI:SS') || CHR(13) ||
                          CHR(13) || 'Número de registros actualizados del cursor : ' || n_contloop);
      sys.sp_sy_enviamail('bantoem@cajaarequipa.pe',
                          'ehidalgom@cajaarequipa.pe',
                          'SP_AH_DPFS_SIN_RENOVAR ejecutado',
                          'BD=' || sys_context('USERENV', 'DB_NAME') ||
                          CHR(13) || 'INSTANCIA=' ||
                          sys_context('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                          'Hora Actual en Servidor : ' ||
                          to_char(sysdate, 'HH24:MI:SS') || CHR(13) ||
                          CHR(13) || 'Número de registros actualizados del cursor : ' || n_contloop);
      sys.sp_sy_enviamail('bantoem@cajaarequipa.pe',
                          'kcabrerac@cajaarequipa.pe',
                          'SP_AH_DPFS_SIN_RENOVAR ejecutado',
                          'BD=' || sys_context('USERENV', 'DB_NAME') ||
                          CHR(13) || 'INSTANCIA=' ||
                          sys_context('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                          'Hora Actual en Servidor : ' ||
                          to_char(sysdate, 'HH24:MI:SS') || CHR(13) ||
                          CHR(13) || 'Número de registros actualizados del cursor : ' || n_contloop);
    exception
      when others then
        null;
    end;
  end if;
END SP_AH_DPFS_SIN_RENOVAR;
 /* GOLDENGATE_DDL_REPLICATION */
/

