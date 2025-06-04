create or replace PACKAGE USRECOSISTEMAS.PKG_WORKSHOP IS 

    TYPE CURSOR_WORKSHOP IS REF CURSOR; -- Definición del cursor

PROCEDURE WKS_GET_WORKSHOP_CURRENT(cursorOut OUT CURSOR_WORKSHOP);
PROCEDURE WSK_WORKSHOP_REGISTRATION_INSERT(
    pworkshopid IN NUMBER,
    pfullname IN VARCHAR2,
    pdocument IN VARCHAR2,
    pcellphone IN VARCHAR2,
    pemail IN VARCHAR2,
    pisuser IN NUMBER,
    pisacceptterms IN NUMBER,
    IDOUT OUT NUMBER
);
PROCEDURE WKS_GET_WORKSHOP_REGISTRATION_FOR_JOB(cursorOut OUT CURSOR_WORKSHOP);

PROCEDURE WSK_CONTACT_REGISTRATION_INSERT(
    pmoduleid IN NUMBER,
    pfullname IN VARCHAR2,
    pemail IN VARCHAR2,
    pmessage IN VARCHAR2,
    pisacceptterms IN NUMBER,
    IDOUT OUT NUMBER
);

PROCEDURE WSK_WORKSHOP_FILTER_PAGINATED(pmoduleid IN number,psearch IN VARCHAR2,prow IN NUMBER, ptotalRecord IN NUMBER,cursorOut OUT CURSOR_WORKSHOP);
PROCEDURE WSK_WORKSHOP_REGISTRATION_INSERT_ADMIN(
    pworkshopid IN NUMBER,
    pfullname IN VARCHAR2,
    pdocument IN VARCHAR2,
    pcellphone IN VARCHAR2,
    pemail IN VARCHAR2,
    IDOUT OUT NUMBER
);
PROCEDURE WKS_GET_WORKSHOP_REGISTRATION_FOR_EMAIL(pworshopid IN NUMBER, cursorOut OUT CURSOR_WORKSHOP);
PROCEDURE WSK_WORKSHOP_INSERT(
    ptitle IN VARCHAR2,
    pdescription IN VARCHAR2,
    pcharacteristics IN VARCHAR2,
    pworkshopdate IN DATE,
    plink IN VARCHAR2,
    pdescriptionlink IN VARCHAR2,
    pmoduleid IN NUMBER,
    pcreatedby IN NUMBER,
    IDOUT OUT NUMBER 
);
PROCEDURE WSK_WORKSHOP_REGISTRATION_GET_BY_ID_ADMIN(pid IN NUMBER,cursorOut OUT CURSOR_WORKSHOP);
PROCEDURE WSK_WORKSHOP_REGISTRATION_UPDATE_ADMIN(
    pid IN NUMBER,
    pworkshopid IN NUMBER,
    pfullname IN VARCHAR2,
    pdocument IN VARCHAR2,
    pcellphone IN VARCHAR2,
    pemail IN VARCHAR2,
    puserid IN NUMBER,
    rowsOut OUT NUMBER 
);
PROCEDURE WSK_WORKSHOP_REGISTRATION_UPDATE_STATUS_ADMIN(
pid IN NUMBER,
pstatusid IN NUMBER,
puserid IN NUMBER,
rowsOut out NUMBER);
PROCEDURE WSK_WORKSHOP_REGISTRATION_FILTER_PAGINATED(pdate IN VARCHAR2,psearch IN VARCHAR2,prow IN NUMBER, ptotalRecord IN NUMBER,cursorOut OUT CURSOR_WORKSHOP);
PROCEDURE WSK_WORKSHOP_GETACTIVE_DATES(cursorOut OUT CURSOR_WORKSHOP);
PROCEDURE WSK_WORKSHOP_UPDATE(
    pid IN NUMBER,
    ptitle IN VARCHAR2,
    pdescription IN VARCHAR2,
    pcharacteristics IN VARCHAR2,
    pworkshopdate IN DATE,
    plink IN VARCHAR2,
    pdescriptionlink IN VARCHAR2,
    pmoduleid IN NUMBER,
    pstatusid IN NUMBER,
    pupdatedby IN NUMBER,
    rowsOut OUT NUMBER 
);
PROCEDURE WSK_WORKSHOP_UPDATE_STATUS(
    pid IN NUMBER,
    pstatusid IN NUMBER,
    pupdatedby IN NUMBER,
    rowsOut OUT NUMBER 
);
PROCEDURE WSK_WORKSHOPGET_BY_ID(pid IN number,cursorOut OUT CURSOR_WORKSHOP);
END PKG_WORKSHOP;


/
create or replace PACKAGE BODY USRECOSISTEMAS.PKG_WORKSHOP IS

PROCEDURE WKS_GET_WORKSHOP_CURRENT(cursorOut OUT CURSOR_WORKSHOP) AS
  BEGIN
     OPEN cursorOut FOR
    SELECT * FROM WORKSHOP WHERE STATUSID = 1 and currentworkshop = 1;
END WKS_GET_WORKSHOP_CURRENT;


PROCEDURE WSK_WORKSHOP_REGISTRATION_INSERT(
    pworkshopid IN NUMBER,
    pfullname IN VARCHAR2,
    pdocument IN VARCHAR2,
    pcellphone IN VARCHAR2,
    pemail IN VARCHAR2,
    pisuser IN NUMBER,
    pisacceptterms IN NUMBER,
    IDOUT OUT NUMBER 
)
IS
    vUserId NUMBER; 
BEGIN
    BEGIN
        SELECT ID
        INTO vUserId
        FROM USERPERSON
        WHERE DOCUMENTNUMBER = pdocument AND STATUSID = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            vUserId := NULL; 
    END;

    -- Insertar el registro en WORKSHOPREGISTRATION
    INSERT INTO WORKSHOPREGISTRATION (
        WorkshopID,
        USERID,
        FULLNAME,
        DOCUMENTNUMBER,
        CELLPHONE,
        EMAIL,
        ISUSER,
        STATUSID,
        CREATEDBY,
        CREATEDDATE,
        IsAcceptTerms
    ) 
    VALUES (
        pworkshopid,
        vUserId, -- Usar el USERID si existe, de lo contrario NULL
        pfullname,
        pdocument,
        pcellphone,
        pemail,
        pisuser,
        1,
        99,
        SYSDATE,
        pisacceptterms
    )
    RETURNING ID INTO IDOUT;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END WSK_WORKSHOP_REGISTRATION_INSERT;
PROCEDURE WKS_GET_WORKSHOP_REGISTRATION_FOR_JOB(cursorOut OUT CURSOR_WORKSHOP) AS
BEGIN
    -- Abrir el cursor con los registros encontrados para uso externo
    OPEN cursorOut FOR
    SELECT 
        wr.id AS id,
        wr.email,
        w.workshopdate,
        w.link
    FROM 
        workshopregistration wr
    INNER JOIN 
        workshop w ON wr.workshopid = w.id -- Relación entre workshopregistration y workshop
    INNER JOIN 
        mastertabledetail mtd ON mtd.mastertableid = 40 -- Obtiene la hora configurada
    WHERE
        wr.statusid = 1 AND w.statusid = 1 AND
        (wr.SendEmail IS NULL OR wr.SendEmail = 0) AND
        TRUNC(SYSDATE) = TRUNC(w.workshopdate) -- Compara la fecha del sistema con workshopdate
        AND TO_CHAR(SYSDATE, 'HH24:MI') = mtd.value1 -- Compara la hora del sistema con value1 en mastertabledetail
    ORDER BY 
        wr.id;

    -- Usar un cursor interno explícito para iterar y actualizar registros
    FOR rec IN (
        SELECT 
            wr.id
        FROM 
            workshopregistration wr
        INNER JOIN 
            workshop w ON wr.workshopid = w.id
        INNER JOIN 
            mastertabledetail mtd ON mtd.mastertableid = 40
        WHERE
            wr.statusid = 1 AND w.statusid = 1 AND
            (wr.SendEmail IS NULL OR wr.SendEmail = 0) AND
            TRUNC(SYSDATE) = TRUNC(w.workshopdate) 
            AND TO_CHAR(SYSDATE, 'HH24:MI') = mtd.value1
    ) LOOP
        UPDATE workshopregistration
        SET SendEmail = 1, UpdatedBy = 99, UpdatedDate = sysdate
        WHERE id = rec.id; -- Actualizar solo el registro correspondiente
    END LOOP;

    COMMIT; -- Confirmar los cambios
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK; -- Revertir los cambios en caso de error
        RAISE; -- Relanzar la excepción
END WKS_GET_WORKSHOP_REGISTRATION_FOR_JOB;


PROCEDURE WSK_CONTACT_REGISTRATION_INSERT(
    pmoduleid IN NUMBER,
    pfullname IN VARCHAR2,
    pemail IN VARCHAR2,
    pmessage IN VARCHAR2,
    pisacceptterms IN NUMBER,
    IDOUT OUT NUMBER 
) 
IS
BEGIN 
    INSERT INTO ContactRegistration (
        FULLNAME,
        EMAIL,
        MESSAGE,
        STATUSID, 
        CREATEDBY,
        CREATEDDATE,
        IsAcceptTerms,
        MODULEID
    ) 
    VALUES (
        pfullname,
        pemail,
        pmessage,
        1,
        99,
        SYSDATE,
        pisacceptterms,
        pmoduleid
    )
    RETURNING ID INTO IDOUT;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END WSK_CONTACT_REGISTRATION_INSERT;

PROCEDURE WSK_WORKSHOP_FILTER_PAGINATED(pmoduleid IN number,psearch IN VARCHAR2,prow IN NUMBER, ptotalRecord IN NUMBER,cursorOut OUT CURSOR_WORKSHOP)
IS
BEGIN
  OPEN cursorOut FOR
  select * from
  (select distinct tc.id,tc.moduleid, tc.title,tc.description, tc.characteristics,tc.workshopdate,tc.statusid,tc.link,tc.descriptionlink, tc.currentworkshop,tc.createddate,
  row_number() over (order by tc.createddate asc) as NroRow,
  (select count(*) from workshop tct where tct.statusid=1 AND (tc.moduleid = case when pmoduleid>0 then pmoduleid else tc.moduleid end) AND UPPER(tct.title) LIKE UPPER('%'||psearch||'%')) as TotalRow
  from workshop tc where tc.statusid=1 AND (tc.moduleid = case when pmoduleid>0 then pmoduleid else tc.moduleid end) AND UPPER(tc.title) LIKE UPPER('%'||psearch||'%')) where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord)
  order by nrorow;
END WSK_WORKSHOP_FILTER_PAGINATED;

PROCEDURE WSK_WORKSHOP_REGISTRATION_INSERT_ADMIN(
    pworkshopid IN NUMBER,
    pfullname IN VARCHAR2,
    pdocument IN VARCHAR2,
    pcellphone IN VARCHAR2,
    pemail IN VARCHAR2,
    IDOUT OUT NUMBER 
)
IS
    vUserId NUMBER; 
BEGIN
    BEGIN
        SELECT ID
        INTO vUserId
        FROM USERPERSON
        WHERE DOCUMENTNUMBER = pdocument AND STATUSID = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            vUserId := NULL; 
    END;

    -- Insertar el registro en WORKSHOPREGISTRATION
    INSERT INTO WORKSHOPREGISTRATION (
        WorkshopID,
        USERID,
        FULLNAME,
        DOCUMENTNUMBER,
        CELLPHONE,
        EMAIL,
        ISUSER,
        STATUSID,
        CREATEDBY,
        CREATEDDATE,
        IsAcceptTerms
    ) 
    VALUES (
        pworkshopid,
        vUserId, -- Usar el USERID si existe, de lo contrario NULL
        pfullname,
        pdocument,
        pcellphone,
        pemail,
        0,
        1,
        99,
        SYSDATE,
        0
    )
    RETURNING ID INTO IDOUT;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END WSK_WORKSHOP_REGISTRATION_INSERT_ADMIN;

PROCEDURE WKS_GET_WORKSHOP_REGISTRATION_FOR_EMAIL(pworshopid IN NUMBER,cursorOut OUT CURSOR_WORKSHOP) AS
BEGIN
    -- Abrir el cursor con los registros encontrados para uso externo
    OPEN cursorOut FOR
    SELECT 
        wr.id AS id,
        wr.email,
        w.workshopdate,
        w.link,
        w.descriptionlink
    FROM 
        workshopregistration wr
    INNER JOIN 
        workshop w ON wr.workshopid = w.id -- Relación entre workshopregistration y workshop
    WHERE
        wr.statusid = 1 AND w.statusid = 1 AND
        w.id = pworshopid
    ORDER BY 
        wr.id;

END WKS_GET_WORKSHOP_REGISTRATION_FOR_EMAIL;
PROCEDURE WSK_WORKSHOP_REGISTRATION_UPDATE_ADMIN(
    pid IN NUMBER,
    pworkshopid IN NUMBER,
    pfullname IN VARCHAR2,
    pdocument IN VARCHAR2,
    pcellphone IN VARCHAR2,
    pemail IN VARCHAR2,
    puserid IN NUMBER,
    rowsOut OUT NUMBER 
)
IS
BEGIN
     UPDATE WORKSHOPREGISTRATION SET 
     Workshopid = pworkshopid,
     fullname = pfullname,
     documentnumber=pdocument,
     cellphone = pcellphone,
     email = pemail,
      UPDATEDBY = puserid, 
      UPDATEDDATE = sysdate
      WHERE ID = pid;
    rowsOut := SQL%rowcount; 
    COMMIT;

END WSK_WORKSHOP_REGISTRATION_UPDATE_ADMIN;
PROCEDURE WSK_WORKSHOP_REGISTRATION_UPDATE_STATUS_ADMIN(
pid IN NUMBER,
pstatusid IN NUMBER,
puserid IN NUMBER,
rowsOut out NUMBER)
IS
BEGIN
  UPDATE WORKSHOPREGISTRATION SET 
  statusid = pstatusid,
  UPDATEDBY = puserid, 
  UPDATEDDATE = sysdate WHERE ID = pid;
rowsOut := SQL%rowcount; 
 COMMIT;
END WSK_WORKSHOP_REGISTRATION_UPDATE_STATUS_ADMIN;
PROCEDURE WSK_WORKSHOP_REGISTRATION_GET_BY_ID_ADMIN(pid IN NUMBER,cursorOut OUT CURSOR_WORKSHOP)
IS
BEGIN
 OPEN cursorOut FOR
 SELECT 
 r.*
 FROM WORKSHOPREGISTRATION r 
 where r.id = pid and r.statusid = 1;
END WSK_WORKSHOP_REGISTRATION_GET_BY_ID_ADMIN;
PROCEDURE WSK_WORKSHOP_INSERT(
    ptitle IN VARCHAR2,
    pdescription IN VARCHAR2,
    pcharacteristics IN VARCHAR2,
    pworkshopdate IN DATE,
    plink IN VARCHAR2,
    pdescriptionlink IN VARCHAR2,
    pmoduleid IN NUMBER,
    pcreatedby IN NUMBER,
    IDOUT OUT NUMBER 
)
IS
BEGIN
    INSERT INTO workshop (
        title,
        description,
        characteristics,
        workshopdate,
        link,
        descriptionlink,
        currentworkshop,
        moduleid,
        statusid,
        CREATEDBY,
        CREATEDDATE
    ) 
    VALUES (
        ptitle,
        pdescription,
        pcharacteristics,
        pworkshopdate,
        plink,
        pdescriptionlink,
        1,
        pmoduleid,
        1,
        pcreatedby,
        SYSDATE
    )
    RETURNING ID INTO IDOUT;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END WSK_WORKSHOP_INSERT;
PROCEDURE WSK_WORKSHOP_REGISTRATION_FILTER_PAGINATED(pdate IN VARCHAR2,psearch IN VARCHAR2,prow IN NUMBER, ptotalRecord IN NUMBER,cursorOut OUT CURSOR_WORKSHOP)
IS
BEGIN
  OPEN cursorOut FOR
  select * from
  (select distinct wsr.id,tct.moduleid, tct.title,wsr.fullname, wsr.documentnumber,wsr.cellphone,wsr.email,wsr.statusid,tct.workshopdate,wsr.createddate,
  row_number() over (order by wsr.createddate asc) as NroRow,
  (select count(*) from workshopregistration wsr1 inner join workshop tct1 on wsr1.workshopid=tct1.id   
  where tct1.statusid=1 and wsr1.statusid=1 AND UPPER(tct1.title) LIKE UPPER('%'||psearch||'%') AND (pdate IS NULL OR TRIM(pdate) = '' OR TO_CHAR(tct1.workshopdate, 'YYYY-MM-DD') = TO_CHAR(TO_DATE(pdate, 'YYYY-MM-DD'), 'YYYY-MM-DD'))) as TotalRow
  from workshopregistration wsr inner join workshop tct on wsr.workshopid=tct.id 
  where tct.statusid=1 and wsr.statusid=1 AND UPPER(tct.title) LIKE UPPER('%'||psearch||'%') AND (pdate IS NULL OR TRIM(pdate) = '' OR TO_CHAR(tct.workshopdate, 'YYYY-MM-DD') = TO_CHAR(TO_DATE(pdate, 'YYYY-MM-DD'), 'YYYY-MM-DD'))) where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord)
  order by nrorow;
END WSK_WORKSHOP_REGISTRATION_FILTER_PAGINATED;
PROCEDURE WSK_WORKSHOP_GETACTIVE_DATES(cursorOut OUT CURSOR_WORKSHOP)
IS
BEGIN
  OPEN cursorOut FOR
  select wc.id, wc.workshopdate from workshop wc
  where wc.statusid=1;
END WSK_WORKSHOP_GETACTIVE_DATES;
PROCEDURE WSK_WORKSHOP_UPDATE(
    pid IN NUMBER,
    ptitle IN VARCHAR2,
    pdescription IN VARCHAR2,
    pcharacteristics IN VARCHAR2,
    pworkshopdate IN DATE,
    plink IN VARCHAR2,
    pdescriptionlink IN VARCHAR2,
    pmoduleid IN NUMBER,
    pstatusid IN NUMBER,
    pupdatedby IN NUMBER,
    rowsOut OUT NUMBER 
)
IS
BEGIN 
     UPDATE WORKSHOP SET 
     title = ptitle,
     description = pdescription,
     characteristics=pcharacteristics,
     workshopdate = pworkshopdate,
     link = plink,
     descriptionlink=pdescriptionlink,
     moduleid=pmoduleid,
     statusid=pstatusid,
     UPDATEDBY = pupdatedby, 
     UPDATEDDATE = sysdate
     WHERE ID = pid;
    rowsOut := SQL%rowcount; 
    COMMIT;
END WSK_WORKSHOP_UPDATE;
PROCEDURE WSK_WORKSHOP_UPDATE_STATUS(
    pid IN NUMBER,
    pstatusid IN NUMBER,
    pupdatedby IN NUMBER,
    rowsOut OUT NUMBER 
)
IS
BEGIN
UPDATE WORKSHOP SET 
     statusid=pstatusid,
     UPDATEDBY = pupdatedby, 
     UPDATEDDATE = sysdate
     WHERE ID = pid;
    rowsOut := SQL%rowcount; 
    COMMIT;
END WSK_WORKSHOP_UPDATE_STATUS;
PROCEDURE WSK_WORKSHOPGET_BY_ID(pid IN number,cursorOut OUT CURSOR_WORKSHOP)
IS
BEGIN
OPEN cursorOut FOR
  select distinct tc.id,tc.moduleid, tc.title,tc.description, tc.characteristics,tc.workshopdate,tc.statusid,tc.link,tc.currentworkshop,tc.createddate
  from workshop tc where tc.id=pid and tc.statusid=1;
END WSK_WORKSHOPGET_BY_ID;
END PKG_WORKSHOP;
/