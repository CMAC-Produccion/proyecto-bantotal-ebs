create or replace package PQ_CR_CARGARIESGOS is

  -- Author  : MPOSTIGOC
  -- Created : 23/03/2023 15:18:21
  -- Purpose : 

  -- *****************************************************************
  -- Nombre                     : PQ_CR_CARGARIESGOS
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 23/03/2023 15:18:21
  -- Autor de Creación          : Maria Postigo MPOSTIGOC
  -- Uso                        : Carga de información por riesgos
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : 
  --
  -- Retorno                    : 
  -- Fecha de Modificación      : 08/01/2023
  -- Autor de la Modificación   : Maria Postigo MPOSTIGOC
  -- Descripción de Modificación: se agrego el procedimiento sp_Cr_Carga_Ind_cont, para carga de info solicitada por riesgos.
  --
  -- *****************************************************************
  -- FECHA DE MODIFICACION       : 14/05/2024
  -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
  -- DESCRIPCION DE MODIFICACION : SE AGREGARON LOS SIGUIENTES PROCEDIMIENTOS:
  --                                   - SP_CR_CSAYCO_ANX_TABLA_1
  --                                   - SP_CR_CSAYCO_ANX_TABLA_2
  --                                   - SP_CR_CSAYCO_ANX_TABLA_3
  --                                   - SP_CR_CSAYCO_ANX_TABLA_4
  -- *****************************************************************
  -- FECHA DE MODIFICACION       : 02/12/2024
  -- AUTOR DE LA MODIFICACION    : MILTON CORDOVA HERRWERA
  -- DESCRIPCION DE MODIFICACION : SE AGREGARON LOS SIGUIENTES PROCEDIMIENTOS:
  --                                   - sp_cr_CargaCosechaPoliticas
  procedure sp_cr_CargaCosecha;
  ------------------------------------------
  procedure sp_Cr_BaseDesembolsosCampania;
  ------------------------------------------
  procedure sp_cr_BasePoltExcepBloque;
  ------------------------------------------
  procedure sp_cr_TablaSaldos;
  ------------------------------------------
  procedure sp_cr_ClientesCompartids;
  ------------------------------------------
  procedure sp_Cr_CargaLGD;
  ------------------------------------------
  procedure sp_Cr_CargaRML;
  --------------------------------------------
  procedure sp_cr_CargaCOSPD;
  -----------------------------------------
  procedure sp_Cr_Carga_Ind_cont;
  ------------------------------------------
  PROCEDURE SP_CR_CSAYCO_ANX_TABLA_1;
  ------------------------------------------
  PROCEDURE SP_CR_CSAYCO_ANX_TABLA_2;
  ------------------------------------------
  PROCEDURE SP_CR_CSAYCO_ANX_TABLA_3;
  ------------------------------------------
  PROCEDURE SP_CR_CSAYCO_ANX_TABLA_4;
  ------------------------------------------
  procedure sp_cr_CargaCosechaPoliticas;
  
end PQ_CR_CARGARIESGOS;
/

create or replace package body PQ_CR_CARGARIESGOS is

  procedure sp_cr_CargaCosecha is
    -- AQPB152 ¿ Cosecha de Cartera 
  
  begin
  
    begin
      delete from aqpb152 q
       where q.aqpb152mdesmb in
             (select distinct q.aqpb152amdesmb from USRBNDJ.aqpb152a q);
      commit;
    end;
  
    begin
      insert into aqpb152
        select * from USRBNDJ.aqpb152a; --aqpb152
      commit;
    end;
  
  end sp_cr_CargaCosecha;
  ----------------------------------------------------
  procedure sp_Cr_BaseDesembolsosCampania is
    -- AQPB153 ¿ Base de desembolsos campaña
  
  begin
    insert into aqpb153
      select * from USRBNDJ.aqpb153a; --aqpb153
    commit;
  
  end sp_Cr_BaseDesembolsosCampania;
  ----------------------------------------------------
  procedure sp_cr_BasePoltExcepBloque is
    -- AQPB154 ¿ Base de politicas de excepciones bloqueantes.
  
  begin
    insert into aqpb154
      select * from USRBNDJ.aqpb154a; --aqpb154
    commit;
  end sp_cr_BasePoltExcepBloque;
  ----------------------------------------------------
  procedure sp_cr_TablaSaldos is
    -- AQPB155 ¿ Tabla de Saldos, atrasos historicos (2018 - 2022)
  begin
    insert into aqpb155
      select * from USRBNDJ.aqpb155a; --aqpb155
    commit; -- AQPB155
  end sp_cr_TablaSaldos;
  -----------------------------------------------
  procedure sp_cr_ClientesCompartids is
  
  begin
    -- AQPB156   clientes compartidos.
    insert into aqpb156
      select * from USRBNDJ.aqpb156a; -- AQPB156 
    commit;
  end sp_cr_ClientesCompartids;
  ---------------------------------------------------
  procedure sp_Cr_CargaLGD is
  begin
    -- AQPB159 Carga LGD
    insert into aqpb159
      select * from USRBNDJ.aqpb159a; -- AQPB156 
    commit;
  
  end sp_cr_CargaLGD;
  ----------------------------------------------------
  procedure sp_Cr_CargaRML is
  begin
    -- aqpc590 Carga RML
    insert into aqpc590
      select * from USRBNDJ.aqpc591; -- aqpc590 
    commit;
  
  end sp_Cr_CargaRML;
  ----------------------------------------------------
  procedure sp_cr_CargaCOSPD is
  
    lc_hora        varchar2(8) := '00:00:00';
    ld_fchaSist    date;
    ln_CInfoPuente number(17);
  
  begin
  
    begin
      select f.pgfape into ld_fchaSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
    end;
  
    begin
      select count(*) into ln_CInfoPuente from USRBNDJ.aqpb172A a;
    exception
      when others then
        null;
    end;
  
    if ln_CInfoPuente > 0 then
    
      begin
        -- aqpb172A Carga de informacion de COS4, COS6 y PD para Opinion de Riesgos
        insert into aqpb172
          select a.*, ld_fchaSist, lc_hora from USRBNDJ.aqpb172A a;
        commit;
      end;
    end if;
  end;
  ----------------------------------------------------
  procedure sp_Cr_Carga_Ind_cont is
  
  begin
  
    begin
      insert into aqpb176
        select rownum,
               (select f.pgfape from fst017 f where f.pgcod = 1) Fecha_Insert,
               to_char(sysdate, 'HH24:MI:SS') Hora_Reg,
               a.*
          from usrbndj.aqpb176a a;
    end;
    commit;
  end sp_Cr_Carga_Ind_cont;
  ----------------------------------------------------
  
   PROCEDURE SP_CR_CSAYCO_ANX_TABLA_1 IS
   
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_CSAYCO_ANX_TABLA_1
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 14/05/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : GENERA LA CARGA DE LA TABLA USRBNDJ.AQPC787A
   --                               A LA TABLA DE BANTOTAL AQPC787
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************
   
      FECHA_SISTEMA DATE;
      HORA_SISTEMA  VARCHAR2(8);
   BEGIN
      BEGIN
         SELECT A.PGFAPE, TO_CHAR(SYSDATE, 'HH24:MI:SS')
           INTO FECHA_SISTEMA, HORA_SISTEMA
           FROM FST017 A
          WHERE A.PGCOD = 1;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      BEGIN
         INSERT INTO AQPC787
            SELECT ROWNUM, FECHA_SISTEMA, HORA_SISTEMA, A.*
              FROM USRBNDJ.AQPC787A A;
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   END SP_CR_CSAYCO_ANX_TABLA_1;
   
   PROCEDURE SP_CR_CSAYCO_ANX_TABLA_2 IS
   
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_CSAYCO_ANX_TABLA_2
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 14/05/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : GENERA LA CARGA DE LA TABLA USRBNDJ.AQPC788A
   --                               A LA TABLA DE BANTOTAL AQPC788
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************
   
      FECHA_SISTEMA DATE;
      HORA_SISTEMA  VARCHAR2(8);
   BEGIN
      BEGIN
         SELECT A.PGFAPE, TO_CHAR(SYSDATE, 'HH24:MI:SS')
           INTO FECHA_SISTEMA, HORA_SISTEMA
           FROM FST017 A
          WHERE A.PGCOD = 1;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
       
      BEGIN
         INSERT INTO AQPC788 
            SELECT ROWNUM, FECHA_SISTEMA, HORA_SISTEMA, A.*
              FROM USRBNDJ.AQPC788A A;
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   END SP_CR_CSAYCO_ANX_TABLA_2;
   
   PROCEDURE SP_CR_CSAYCO_ANX_TABLA_3 IS
   
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_CSAYCO_ANX_TABLA_3
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 14/05/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : GENERA LA CARGA DE LA TABLA USRBNDJ.AQPC789A
   --                               A LA TABLA DE BANTOTAL AQPC789
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************
   
      FECHA_SISTEMA DATE;
      HORA_SISTEMA  VARCHAR2(8);
   BEGIN
      BEGIN
         SELECT A.PGFAPE, TO_CHAR(SYSDATE, 'HH24:MI:SS')
           INTO FECHA_SISTEMA, HORA_SISTEMA
           FROM FST017 A
          WHERE A.PGCOD = 1;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      BEGIN
         INSERT INTO AQPC789
            SELECT ROWNUM, FECHA_SISTEMA, HORA_SISTEMA, A.*
              FROM USRBNDJ.AQPC789A A;
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   END SP_CR_CSAYCO_ANX_TABLA_3;
   
   PROCEDURE SP_CR_CSAYCO_ANX_TABLA_4 IS
   
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_CSAYCO_ANX_TABLA_4
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 14/05/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : GENERA LA CARGA DE LA TABLA USRBNDJ.AQPC790A
   --                               A LA TABLA DE BANTOTAL AQPC790
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************
   
      FECHA_SISTEMA DATE;
      HORA_SISTEMA  VARCHAR2(8);
   BEGIN
      BEGIN
         SELECT A.PGFAPE, TO_CHAR(SYSDATE, 'HH24:MI:SS')
           INTO FECHA_SISTEMA, HORA_SISTEMA
           FROM FST017 A
          WHERE A.PGCOD = 1;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      BEGIN
         INSERT INTO AQPC790
            SELECT ROWNUM, FECHA_SISTEMA, HORA_SISTEMA, A.*
              FROM USRBNDJ.AQPC790A A;
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   END SP_CR_CSAYCO_ANX_TABLA_4;
 
   -- *****************************************************************
   -- NOMBRE                      : sp_cr_CargaCosechaPoliticas
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 03/12/2024
   -- AUTOR DE CREACION           : MILTON CORDOVA HERRERA
   -- USO                         : GENERA LA CARGA DE LA TABLA USRBNDJ.AQPC233A
   --                               A LA TABLA DE BANTOTAL AQPC233
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************  
   procedure sp_cr_CargaCosechaPoliticas is
   FECHA_SISTEMA DATE;
      HORA_SISTEMA  VARCHAR2(8);
  begin
  
      begin
        delete from AQPC233 A
         where A.AQPC233mde in
               (select distinct A.AQPC233Amde from USRBNDJ.AQPC233A A);
        commit;
      end;
      
      BEGIN
         SELECT A.PGFAPE, TO_CHAR(SYSDATE, 'HH24:MI:SS')
           INTO FECHA_SISTEMA, HORA_SISTEMA
           FROM FST017 A
          WHERE A.PGCOD = 1;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      BEGIN
         INSERT INTO AQPC233
            SELECT ROWNUM, FECHA_SISTEMA, HORA_SISTEMA, A.*
              FROM USRBNDJ.AQPC233A A;
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
  
  end sp_cr_CargaCosechaPoliticas;
  
end PQ_CR_CARGARIESGOS;
/

