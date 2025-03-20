create or replace package PQ_AH_OPERA_BIM is

  -- Author  : SMARQUEZ
  -- Created : 20/07/2016 11:43:07
  -- Purpose : OPERACIONES BIM

  -- Public type declarations
  PROCEDURE GENERA_DATOS(p_usuario  in varchar2,
                         p_fecha    in date,
                         p_fechafin in date);
end PQ_AH_OPERA_BIM;
/

create or replace package body PQ_AH_OPERA_BIM is

PROCEDURE GENERA_DATOS (p_usuario  in varchar2,
                        p_fecha    in date,
                        p_fechafin in date)IS

--Usuarios Registrados y Activos
   cursor Usuarios_Reg is
      select trunc(b.jaql615fetrx) Fecha,---,'dd/mm/yyyy') FECHA,
             sum(case
                   when jaql615misdn in
                        (select jaql615misdn
                           from jaql615 yy
                          where jaql615titrx = 'BLOQUSR') then
                    0
                   else
                    1
                 end) ACTIVOS,
             count(1) REGISTRADOS
        from jaql615 b
       Where b.JAQL615TITRX = 'ACTIVA'
         and b.JAQL615TIDOC = 'DNI'
         and trunc(b.jaql615fetrx) between p_fecha and p_fechafin ---- + 1 --p_fecha + 1
       group by trunc(b.jaql615fetrx)--,'dd/mm/yyyy')
       order by 1 ASC;

--Saldos Billeteras
   cursor Billeteras(fecha1 in date )is
      select substr(trim(a.jaqz312msisdn),3,11) CELULAR,
             b.jaql615nudoc  DOCUMENTO,
             b.jaql615fetrx  FECHA_REG,
             a.jaqz312balan  SALDO,
             a.jaqz312profi  PERFIL
        from jaqz312 a
       inner join jaql615 b
          on a.JAQZ312ACHID = b.JAQL615IDUSU
         and b.JAQL615TITRX = 'ACTIVA'
       where a.JAQZ312FEARC = fecha1 ---  between p_fecha and p_fechafin  ---- >= p_fecha
----         and a.JAQZ312FEARC < p_fechafin --- p_fecha + 1
       order by 5,3 desc;

--Saldos Totales

   cursor Totales IS ---(fecha2 in date) is
      select dISTINCT upper(a.jaqz312profi) PERFIL, sum(a.jaqz312balan) SALDO
        from jaqz312 a
       where a.JAQZ312FEARC between p_fecha and (p_fechafin-1)  ---= fecha2     /*>= p_fecha   and a.JAQZ312FEARC  < p_fechafin ---p_fecha + 1---to_date('13/07/2016','dd/mm/yyyy')---TO_DATE(CURRENT_DATE)cambiar en produccion TO_DATE(CURRENT_DATE)*/
       group by upper(a.jaqz312profi), a.JAQZ312FEARC  --24.08.2016
       order by 1 desc;

--Ususarios registrados por Agentes
   cursor U_agentes is
      select JAQZ314MARCA PERFIL,
             JAQZ314IDUSU ID_AGENTE,
             substr(trim(JAQZ314MSISDN),3,11) CEL_AGENTE,
             JAQZ314USNAM USU_AGENTE,
             JAQZ314AIDUSU ID_USUARIO,
             substr(trim(JAQZ314AMSISDN),3,11) CEL_USUARIO,
             JAQZ314AFECREG FEC_REGISTRO,
             upper(JAQZ314ATELCO) EMPRESA
        from jaqz314 a
       inner join jaqz314a b
          on a.jaqz314idusu = b.jaqz314aidage
         and a.jaqz314fgest = 'S'
         and b.JAQZ314AFECREG between p_fecha and p_fechafin /*>=  p_fecha
         and b.JAQZ314AFECREG < p_fechafin  -- p_fecha + 1*/
       order by 1 desc;

cont   number := 0;
cont1  number := 0;
cont2  number := 0;
cont3  number := 0;
Total1 number := 0;
Total2 number := 0;
Total3 number := 0;
correl3 number := 0;
hora   varchar2(12) := null;
fechauno date;

BEGIN
  delete jaqy687 WHERE JAQY687USU = p_usuario;
  delete jaqy688 WHERE JAQY688USU = p_usuario;
  delete jaqy689 WHERE JAQY689USU = p_usuario;
  delete fst198
   where tp1cod = 1
     and tp1cod1 = 10849
     and tp1corr1 = 16
     and tp1corr2 = 1;
    -- and tp1desc = rpad(p_usuario,30,' ');
  commit;
-------usuarios registrados---
  SELECT MAX(jaqy687cod)
    INTO cont1
    FROM JAQY687;
 IF cont1 IS NULL THEN
   CONT1 := 0;
 END IF;

  For usu in Usuarios_Reg  loop
    begin
      cont1 := cont1 + 1;
      insert into jaqy687(jaqy687cod,
                          jaqy687fec,
                          jaqy687act,
                          jaqy687reg,
                          jaqy687usu)
                   values(cont1,
                          usu.fecha,
                          usu.activos,
                          usu.registrados,
                          p_usuario);

    exception
      when dup_val_on_index then
        null;
    end;
  end loop;
  commit;
--------bILLETERA--------------
    select max(jaqz312fearc)
     into fechauno
     from jaqz312;

  fOR BI IN Billeteras (fechauno) lOOP
    begin
      cont2 := cont2 + 1;
      SELECT TO_CHAR(bi.fecha_reg,'HH24:MI:SS')
        into hora
        FROM dual;
      insert into jaqy688(jaqy688cod,
                          jaqy688usu,
                          jaqy688cel,
                          jaqy688doc,
                          jaqy688fec,
                          jaqy688hor,
                          jaqy688sal,
                          jaqy688per
                          )
                   values(cont2,
                          p_usuario,
                          bi.celular,
                          bi.documento,
                          bi.fecha_reg,
                          hora,
                          bi.saldo,
                          bi.perfil
                          );
    exception
      when dup_val_on_index then
        null;
    end;
  End loop;
  commit;
--------totales-------
cont   := 0;
cont3  := 0;
Total1 := 0;
Total2 := 0;
Total3 := 0;
  for reg in Totales LOOP ----(fechauno) loop
   /* cont := cont + 1;
    if cont = 1 then
      Total1 := reg.saldo ;
    elsif cont = 2 then
      Total2 := reg.saldo;
    elsif cont = 3 then
      Total3 := reg.saldo;
    end if;*/
    if reg.perfil = 'COMMISSIONING ACCOUNT PROFILE' then
       Total1 := reg.saldo;
    elsif  reg.perfil ='CAREQUIPA OPERATIONAL ACCOUNT PROFILE' then
       Total2 := reg.saldo;
    elsif reg.perfil ='CAREQUIPA NORMAL ACCOUNT PROFILE'  then
       Total3 := reg.saldo;
    end if;   
  end loop;

  select max(tp1corr3)
   into  correl3
    from fst198
   where tp1cod = 1
     and tp1cod1 = 10849
     and tp1corr1 = 16
     and tp1corr2 = 1;

   if correl3 is null then
     correl3 := 0;
   end if;

   correl3 := correl3 + 1;

  insert into fst198 (tp1cod,
                      tp1cod1,
                      tp1corr1,
                      tp1corr2,
                      tp1corr3,
                      tp1desc,
                      tp1imp1,
                      tp1imp2,
                      tp1imp3)
              values(1,
                     10849,
                     16,
                     1,
                     correl3,
                     p_usuario,
                     Total1,
                     Total2,
                     Total3);

  commit;
--Ususarios registrados por Agentes
  for ag in U_agentes loop
    begin
      cont3 := cont3 + 1;
      SELECT TO_CHAR(ag.fec_registro,'HH24:MI:SS')
        into hora
        FROM dual;
      insert into jaqy689(jaqy689cod,
                          jaqy689usu,
                          jaqy689per,
                          jaqy689ida,
                          jaqy689cela,
                          jaqy689usa,
                          jaqy689idu,
                          jaqy689celu,
                          jaqy689fec,
                          jaqy689hra,
                          jaqy689emp)
                   values(cont3,
                          p_usuario,
                          ag.perfil,
                          ag.id_agente,
                          ag.cel_agente,
                          ag.usu_agente,
                          ag.id_usuario,
                          AG.CEL_USUARIO,
                          ag.fec_registro,
                          hora,
                          ag.empresa
                          );
    exception
      when dup_val_on_index then
        null;
    end;
  end loop;
  COMMIT;
END GENERA_DATOS;


end PQ_AH_OPERA_BIM;
/

