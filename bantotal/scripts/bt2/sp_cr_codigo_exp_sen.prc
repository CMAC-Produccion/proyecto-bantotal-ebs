create or replace procedure SP_CR_CODIGO_EXP_SEN(P_TDOC IN NUMBER,
                                                 P_NDOC IN VARCHAR2,
                                                 P_CODI IN NUMBER,
                                                 P_EXPERIAN OUT NUMBER,
                                                 P_ESTEXP   OUT NUMBER,
                                                 P_SENTINEL OUT NUMBER,
                                                 P_ESTSEN   OUT NUMBER,
                                                 P_EQUIFAX  OUT NUMBER,
                                                 P_ESTEQUI  OUT NUMBER) is

CURSOR EXPERIAN IS
  SELECT DISTINCT jaql549entid, jaql549fecha, jaql549ciuda
    FROM JAQL549
   Where JAQL546Serial = P_EXPERIAN;

CURSOR SENTINEL IS
  SELECT DISTINCT JAQZ239ENTID, JAQZ239FECHA
    FROM JAQZ239
   Where JAQZ239SERIAL = P_SENTINEL;

CURSOR EQUIFAX IS
  SELECT DISTINCT AQPB515CENTID, AQPB515CFECHA
    FROM AQPB515C
  WHERE AQPB515CSERIAL = P_EQUIFAX;

documento char(12);
contador number;
P_BURO   NUMBER;
P_SERIAL NUMBER;
P_ESTADO NUMBER;

begin
  documento := P_NDOC;
  --delete jaqz566 where jaqz566aux2 = P_NDOC;---11/07/2018SMA
  --commit;
  --TODOS
  --apachecoh 21.06.2022 escoge el primer buro con estado 1, al igual que las reglas
  BEGIN
    select L.aqpa011lburo ,L.aqpa011lseria, L.aqpa011lestad
        INTO P_BURO, P_SERIAL, P_ESTADO
        from AQPA011L L
      where L.aqpa011ltdoc = P_TDOC
        and L.aqpa011lndoc = documento
        and L.aqpa011lnucon = P_CODI
         and L.aqpa011lestad = 1
         and L.aqpa011lhora =
             (select min(b.aqpa011lhora)
                from aqpa011l b
               where b.aqpa011lnucon = P_CODI
                 and b.aqpa011ltdoc = P_TDOC
                 and b.aqpa011lndoc = documento
                 and b.aqpa011lestad = 1)
         and ROWNUM = 1;  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      P_BURO   := 0;
      P_SERIAL := 0;
      P_ESTADO := 0;
  END;  
  P_EXPERIAN := 0;
  P_ESTEXP   := 0;
  P_SENTINEL := 0;
  P_ESTSEN   := 0;
  P_SENTINEL := 0;
  P_ESTSEN   := 0;
  P_EQUIFAX  := 0;
  P_ESTEQUI  := 0;
  IF P_BURO = 1 THEN
      P_EXPERIAN := P_SERIAL;
      P_ESTEXP   := P_ESTADO;
  ELSIF P_BURO = 2 THEN 
      P_SENTINEL := P_SERIAL;
      P_ESTSEN   := P_ESTADO;
  ELSIF P_BURO = 3 THEN
      P_EQUIFAX  := P_SERIAL;
      P_ESTEQUI  := P_ESTADO;
  END IF;
  /*APACHECOH 21.06.2022 CAMBIO DE LOGICA
  --EXPERIAN
  BEGIN
    SELECT aqpa011lseria, aqpa011lestad
      into P_EXPERIAN, P_ESTEXP
      FROM aqpa011l
      where aqpa011ltdoc = P_TDOC
        and aqpa011lndoc = documento
        and aqpa011lburo = 1
        and aqpa011lnucon = P_CODI*/
        /*(SELECT Max(aqpa011lnucon)
                              FROM aqpa011l
                              where aqpa011ltdoc = P_TDOC
                                and aqpa011lndoc = documento
                                and aqpa011lburo = 1);*/
  /*EXCEPTION
    WHEN NO_DATA_FOUND THEN
      P_EXPERIAN := 0;
      P_ESTEXP   := 0;
  END;
  --SENTINEL
  BEGIN
   SELECT aqpa011lseria, aqpa011lestad
    into P_SENTINEL, P_ESTSEN
    FROM aqpa011l
    where aqpa011ltdoc = P_TDOC
      and aqpa011lndoc = documento
      and aqpa011lburo = 2
      and aqpa011lnucon = P_CODI*/
      /*(SELECT Max(aqpa011lnucon)
                            FROM aqpa011l
                            where aqpa011ltdoc = P_TDOC
                              and aqpa011lndoc = documento
                              and aqpa011lburo = 2);*/
  /*EXCEPTION
    WHEN NO_DATA_FOUND THEN
      P_SENTINEL := 0;
      P_ESTSEN   := 0;
  END;
  --EQUIFAX
  BEGIN
    SELECT aqpa011lseria, aqpa011lestad
      into P_EQUIFAX, P_ESTEQUI
      FROM aqpa011l
      where aqpa011ltdoc = P_TDOC
        and aqpa011lndoc = documento
        and aqpa011lburo = 3
        and aqpa011lnucon = P_CODI;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      P_EQUIFAX := 0;
      P_ESTEQUI := 0;
  END;*/
  -------------------------------------------------
  /*FOR EXP IN EXPERIAN LOOP
    select count(*)
      into contador
      FROM JAQL549
     Where JAQL546Serial = P_EXPERIAN
       and jaql549entid = exp.jaql549entid;
    if contador <> 0 then   
      begin
        insert into jaqz566 (jaqz566fech,
                             jaqz566ent,
                             jaqz566ciu,
                             jaqz566cant,
                             jaqz566aux2  )
                     Values(exp.jaql549fecha,
                            exp.jaql549entid,
                            exp.jaql549ciuda,
                            contador,
                            P_NDOC);
        commit;
      exception
          when dup_val_on_index then
            null;
      end;
    end if;  
  End LOOP;
  
  FOR EXP IN SENTINEL LOOP
    select count(*)
      into contador
      FROM JAQZ239
     Where JAQZ239SERIAL = P_SENTINEL
       and jaqz239entid  = exp.jaqz239entid;
    if contador <> 0 then   
        begin
          insert into jaqz566 (jaqz566fech,
                               jaqz566ent,
                              -- jaqz566ciu,
                               jaqz566cant,
                               jaqz566aux2  )
                       Values(exp.jaqz239fecha,
                              exp.jaqz239entid,
                              --exp.jaql549ciuda,
                              contador,
                              P_NDOC);
          commit;
        exception
          when dup_val_on_index then
            null;
        end;
    end if;    
  END LOOP;
  
  FOR EQUI IN EQUIFAX LOOP
    select sum(aqpb515cnume)
        into contador
      FROM AQPB515C
     Where AQPB515CSERIAL = P_EQUIFAX
       and aqpb515centid  = equi.aqpb515centid;
    if contador <> 0 then   
        begin
          insert into jaqz566 (jaqz566fech,
                               jaqz566ent,
                              -- jaqz566ciu,
                               jaqz566cant,
                               jaqz566aux2  )
                       Values(equi.aqpb515cfecha,
                              equi.aqpb515centid,
                              --exp.jaql549ciuda,
                              contador,
                              P_NDOC);
          commit;
        exception
          when dup_val_on_index then
            null;
        end;
    end if;    
  END LOOP;*/  
end SP_CR_CODIGO_EXP_SEN;
/

