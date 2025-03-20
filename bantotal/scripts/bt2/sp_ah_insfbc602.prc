create or replace procedure SP_AH_INSFBC602(Pepais1   IN NUMBER,
                                            Petdoc1   IN NUMBER,
                                            Pendoc1   IN VARCHAR2,
                                            nombre    IN VARCHAR2,
                                            Direccion IN VARCHAR2,
                                            Existe1   IN VARCHAR2,
                                            bc602ape1 IN VARCHAR2,
                                            bc602apem1 IN VARCHAR2,
                                            BC602NOM1 IN VARCHAR2,
                                            BC602Dire1 IN VARCHAR2,
                                            sexo1     IN VARCHAR2,
                                            pgcod     IN NUMBER,
                                            itsuc     IN NUMBER,
                                            itmod     IN NUMBER,
                                            ittran    IN NUMBER,
                                            itnrel    IN NUMBER,
                                            itord     IN NUMBER,
                                            itsbor    IN NUMBER,
                                            canceL    OUT VARCHAR2) is
FECHA      DATE;
nombre1    VARCHAR2(65);
varnom     varchar2(150);
direccion1 VARCHAR2(65);
ORDINAL    NUMBER(2);
begin
    SELECT PGFAPE
      INTO FECHA
      FROM fst017
     where PgCod = 1;

 If Existe1 ='N' THEN

    varnom :=  trim(bc602ape1)|| ' '|| trim(bc602apem1)|| ' '|| trim(bc602nom1);
    nombre1 := substr(varnom,1,65);
    direccion1 := substr(bc602dire1,1,65);
    BEGIN
      insert into fbc602  (BC602PAIS,
                           BC602TDOC,
                           BC602NDOC,
                           BC602NOM,
                           BC602APE,
                           BC602APEM,
                           BC602SEXO,
                           BC602DIRE)
                        values
                          (Pepais1,
                           Petdoc1,
                           Pendoc1,
                           BC602NOM1,
                           bc602ape1,
                           bc602apem1,
                           sexo1,
                           BC602Dire1);
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
        NULL;
    END;
 END IF;
     if Existe1 = 'S' then
        nombre1 := substr(nombre,1,65) ;
        direccion1 := substr(direccion,1,65) ;
      end if;  

      if ittran = 535 THEN
         ordinal := 52;
      else
         ordinal := 50;
      end if;

      BEGIN
          insert into fsx016(PGCOD,
                             HCMOD,
                             HSUCOR,
                             HTRAN,
                             HNREL,
                             HFCON,
                             HCORD,
                             HCSUBO,
                             TXCOD,
                             TXOREN,
                             TXTORD)
                          values
                            (Pgcod,
                             itmod,
                             itsuc,
                             ittran,
                             itnrel,
                             FECHA,
                             ordinal,
                             1,
                             5,
                             1,
                             NOMBRE1);
       EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
          NULL;
      END;
      
      


      BEGIN
          insert into fsx016(PGCOD,
                             HCMOD,
                             HSUCOR,
                             HTRAN,
                             HNREL,
                             HFCON,
                             HCORD,
                             HCSUBO,
                             TXCOD,
                             TXOREN,
                             TXTORD)
                          values
                            (Pgcod,
                             itmod,
                             itsuc,
                             ittran,
                             itnrel,
                             FECHA,
                             ordinal,
                             1,
                             6,
                             1,
                             Pendoc1);
       EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
          NULL;
      END;

      BEGIN
          insert into fsx016(PGCOD,
                             HCMOD,
                             HSUCOR,
                             HTRAN,
                             HNREL,
                             HFCON,
                             HCORD,
                             HCSUBO,
                             TXCOD,
                             TXOREN,
                             TXTORD)
                          values
                            (Pgcod,
                             itmod,
                             itsuc,
                             ittran,
                             itnrel,
                             FECHA,
                             ordinal,
                             1,
                             7,
                             1,
                             substr(direccion1,1,65));
       EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
          NULL;
      END;
      COMMIT;
end SP_AH_INSFBC602;
/

