create or replace package USRECOSISTEMAS.PKG_COMMON is

  type COM_CURSOR_COMMON IS REF CURSOR;

  PROCEDURE COM_FREQUENTQUESTION_GETALL(
  pModuleId IN NUMBER,
  cursorOutFrequenQuestionCategory OUT COM_CURSOR_COMMON, 
  cursorOutFrequenQuestion OUT COM_CURSOR_COMMON);
  PROCEDURE COM_FREQUENTQUESTION_SEARCH(
  psearch IN VARCHAR2,
  cursorOutFrequenQuestion OUT COM_CURSOR_COMMON);
  PROCEDURE COM_MASTERTABLE_GETALL(cursorOut OUT COM_CURSOR_COMMON);
  PROCEDURE COM_MASTERTABLEDETAIL_GETALL(cursorOut OUT COM_CURSOR_COMMON);
  PROCEDURE COM_MASTERTABLEDETAIL_GETBYMASTERTABLEID(pMasterTableId IN NUMBER, cursorOut OUT COM_CURSOR_COMMON);
  PROCEDURE COM_USERSTEP_INSERT( 
    puserid IN NUMBER,
    pstepid IN NUMBER,
    pmoduleid IN VARCHAR2,
    pstatusid IN NUMBER,
    pcreatedby IN NUMBER,
    IDOUT out NUMBER);
  PROCEDURE COM_USERSTEP_GET_BY_USER(puserid IN NUMBER,cursorOut OUT COM_CURSOR_COMMON);
  PROCEDURE COM_EXECUTE_QUERY_DYNAMIC(pquery IN VARCHAR2,cursorOut OUT COM_CURSOR_COMMON);
  PROCEDURE COM_EXECUTE_DML_DYNAMIC(pquery IN VARCHAR2,pcount OUT NUMBER);

    PROCEDURE COM_FAQ_GETALL (
    pModuleId IN NUMBER,
    cursorOutSections OUT COM_CURSOR_COMMON,
    cursorOutItems OUT COM_CURSOR_COMMON
  );

  PROCEDURE COM_FAQ_SEARCH (
    pModuleId IN NUMBER,
    pSearchTerm IN VARCHAR2,
    cursorOutItems OUT COM_CURSOR_COMMON
  );
PROCEDURE GET_HELP_CONTENT(
    pModuleId         IN  NUMBER,
    cursorOutSections OUT COM_CURSOR_COMMON,
    cursorOutVideos   OUT COM_CURSOR_COMMON
  );
PROCEDURE COM_INSERT_HELP_VIDEO (
    p_section_id   IN NUMBER,
    p_title        IN VARCHAR2,
    p_description  IN VARCHAR2,
    p_video_url    IN VARCHAR2,
    p_image_url    IN VARCHAR2,
    p_order_index  IN NUMBER,
    p_created_by   IN NUMBER,
    IDOUT          out NUMBER
);
PROCEDURE COM_GETBYSEARCH_PAGINATED_HELP_VIDEO(
    pModuleId     IN NUMBER,
    pTextSearch   IN VARCHAR2,
    pRow          IN NUMBER,
    pTotalRecord  IN NUMBER,
    cursorOut     OUT COM_CURSOR_COMMON
);
PROCEDURE COM_UPDATESTATUS_HELP_VIDEO(
    pid IN NUMBER,
    pstatusid IN NUMBER,
    pupdatedby IN NUMBER,
    IDOUT OUT NUMBER
);
PROCEDURE COM_UPDATE_HELP_VIDEO(
    pid            IN NUMBER,
    psectionid     IN NUMBER,
    ptitle         IN VARCHAR2,
    pdescription   IN VARCHAR2,
    pvideoUrl  IN VARCHAR2,
    pimageUrl  IN VARCHAR2,
    porderindex    IN NUMBER,
    pupdatedby     IN NUMBER,
    IDOUT OUT NUMBER
);
PROCEDURE COM_GET_ALL_HELP_SECTION(
    cursorOut OUT COM_CURSOR_COMMON
);
end PKG_COMMON;

/
create or replace PACKAGE BODY USRECOSISTEMAS.PKG_COMMON IS

PROCEDURE COM_FREQUENTQUESTION_GETALL(
  pModuleId IN NUMBER,
  cursorOutFrequenQuestionCategory OUT COM_CURSOR_COMMON, 
  cursorOutFrequenQuestion OUT COM_CURSOR_COMMON)
IS
BEGIN

  OPEN cursorOutFrequenQuestionCategory FOR
  SELECT fcc.*
  FROM frequentquestioncategory fcc
  WHERE fcc.statusid = 1
  AND (fcc.moduleid = case when pModuleId>0 then pModuleId else fcc.moduleid end)
  ORDER BY fcc.sort ASC;

  OPEN cursorOutFrequenQuestion FOR
  SELECT fc.*
  FROM frequentquestion fc
  WHERE fc.statusid = 1
  ORDER BY fc.orderrecord ASC;
END COM_FREQUENTQUESTION_GETALL;

PROCEDURE COM_FREQUENTQUESTION_SEARCH(
  psearch IN VARCHAR2,
  cursorOutFrequenQuestion OUT COM_CURSOR_COMMON)
IS
BEGIN
  OPEN cursorOutFrequenQuestion FOR
  SELECT fc.*
FROM frequentquestion fc
WHERE fc.statusid = 1 
  AND (LOWER(fc.question) LIKE LOWER('%' || psearch || '%')
       OR LOWER(DBMS_LOB.SUBSTR(fc.answer, 4000)) LIKE LOWER('%' || psearch || '%'))
ORDER BY fc.orderrecord ASC;
END COM_FREQUENTQUESTION_SEARCH;

PROCEDURE COM_MASTERTABLE_GETALL(cursorOut OUT COM_CURSOR_COMMON)
IS
BEGIN
  OPEN cursorOut FOR
  select * from mastertable where status=1 order by id asc; 
END COM_MASTERTABLE_GETALL;

PROCEDURE COM_MASTERTABLEDETAIL_GETALL(cursorOut OUT COM_CURSOR_COMMON)
IS
BEGIN
  OPEN cursorOut FOR
  select * from mastertabledetail where status=1 order by id asc; 
END COM_MASTERTABLEDETAIL_GETALL;

PROCEDURE COM_MASTERTABLEDETAIL_GETBYMASTERTABLEID(pMasterTableId IN NUMBER, cursorOut OUT COM_CURSOR_COMMON)
IS
BEGIN
OPEN cursorOut FOR
   select * from mastertabledetail where mastertableid=pMasterTableId and status=1 order by id asc;
END COM_MASTERTABLEDETAIL_GETBYMASTERTABLEID;

PROCEDURE COM_USERSTEP_INSERT( 
puserid IN NUMBER,
pstepid IN NUMBER,
pmoduleid IN VARCHAR2,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER)
IS 
  v_count NUMBER;

BEGIN
  -- Validar si ya existe un registro con los mismos valores
  SELECT COUNT(*)
  INTO v_count
  FROM USERSTEP
  WHERE USERID = puserid AND STEPID = pstepid AND MODULEID = pmoduleid;

    -- Si ya existe, retornar -1 y no realizar la insercion
  IF v_count > 0 THEN
    IDOUT := -1;
  ELSE
    -- Si no existe, realizar la insercion
    INSERT INTO USERSTEP (
      USERID,
      STEPID,
      MODULEID,
      STATUSID,
      CREATEDBY,
      CREATEDDATE
    )
    VALUES (
      puserid,
      pstepid,
      pmoduleid,
      pstatusid,
      pcreatedby,
      SYSDATE
    )
    RETURNING ID INTO IDOUT;

    COMMIT;
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;

END COM_USERSTEP_INSERT;

PROCEDURE COM_USERSTEP_GET_BY_USER(puserid IN NUMBER,cursorOut OUT COM_CURSOR_COMMON)
IS
BEGIN
  OPEN cursorOut FOR
  SELECT * FROM USERSTEP WHERE USERID = puserid and STATUSID = 1;
END COM_USERSTEP_GET_BY_USER;

PROCEDURE COM_EXECUTE_QUERY_DYNAMIC(pquery IN VARCHAR2,cursorOut OUT COM_CURSOR_COMMON)
IS
BEGIN
  OPEN cursorOut FOR pquery;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END COM_EXECUTE_QUERY_DYNAMIC;

PROCEDURE COM_EXECUTE_DML_DYNAMIC(
    pquery IN VARCHAR2,
    pcount OUT NUMBER
) IS
BEGIN
    IF UPPER(TRIM(pquery)) LIKE 'DELETE%' THEN
        RAISE_APPLICATION_ERROR(-20001, 'DELETE operations are not allowed.');
    END IF;
    EXECUTE IMMEDIATE pquery;
    pcount := SQL%ROWCOUNT;

    commit;

EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END COM_EXECUTE_DML_DYNAMIC;

-- Obtener secciones y preguntas frecuentes por módulo
-- CURSORES DE SALIDA:
-- cursorOutSections: lista de secciones
-- cursorOutItems: lista de preguntas/respuestas

 PROCEDURE COM_FAQ_GETALL (
  pModuleId IN NUMBER,
  cursorOutSections OUT COM_CURSOR_COMMON,
  cursorOutItems OUT COM_CURSOR_COMMON
) IS
BEGIN
  -- Secciones activas por módulo
  OPEN cursorOutSections FOR
    SELECT 
      ID AS SECTIONID,
      TITLE,
      ICONNAME,
      ORDERINDEX
    FROM FAQ_SECTIONS
    WHERE ACTIVE = 1
      AND (MODULEID = CASE WHEN pModuleId > 0 THEN pModuleId ELSE MODULEID END)
    ORDER BY ORDERINDEX;

  -- FAQ activas relacionadas a esas secciones
  OPEN cursorOutItems FOR
    SELECT 
      I.ID AS FAQID,
      I.SECTIONID,
      I.QUESTION,
      I.ANSWER,
      I.ORDERINDEX
    FROM FAQ_ITEMS I
    JOIN FAQ_SECTIONS S ON I.SECTIONID = S.ID
    WHERE I.ACTIVE = 1 AND S.ACTIVE = 1
      AND (S.MODULEID = CASE WHEN pModuleId > 0 THEN pModuleId ELSE S.MODULEID END)
    ORDER BY S.ORDERINDEX, I.ORDERINDEX;
END COM_FAQ_GETALL;


-- Buscar preguntas por texto y módulo
PROCEDURE COM_FAQ_SEARCH (
  pModuleId IN NUMBER,
  pSearchTerm IN VARCHAR2,
  cursorOutItems OUT COM_CURSOR_COMMON
) IS
BEGIN
  OPEN cursorOutItems FOR
    SELECT 
      I.ID AS FAQID,
      I.SECTIONID,
      I.QUESTION,
      I.ANSWER
    FROM FAQ_ITEMS I
    JOIN FAQ_SECTIONS S ON I.SECTIONID = S.ID
    WHERE I.ACTIVE = 1 AND S.ACTIVE = 1
      AND (S.MODULEID = CASE WHEN pModuleId > 0 THEN pModuleId ELSE S.MODULEID END)
      AND (
        LOWER(I.QUESTION) LIKE '%' || LOWER(pSearchTerm) || '%' OR
        LOWER(DBMS_LOB.SUBSTR(I.ANSWER, 4000)) LIKE '%' || LOWER(pSearchTerm) || '%'
      )
    ORDER BY S.ORDERINDEX, I.ORDERINDEX;
END COM_FAQ_SEARCH;

PROCEDURE GET_HELP_CONTENT(
    pModuleId         IN  NUMBER,
    cursorOutSections OUT COM_CURSOR_COMMON,
    cursorOutVideos   OUT COM_CURSOR_COMMON
  ) IS
  BEGIN
    OPEN cursorOutSections FOR
      SELECT 
        ID AS SECTIONID,
        MODULEID,
        TITLE,
        DESCRIPTION,
        URLALLVIDEOS,
        ORDERINDEX
      FROM HELP_SECTIONS
      WHERE ACTIVE = 1
        AND MODULEID = pModuleId
      ORDER BY ORDERINDEX;

    OPEN cursorOutVideos FOR
      SELECT 
        ID AS VIDEOID,
        SECTIONID,
        TITLE,
        DESCRIPTION,
        VIDEOURL,
        IMAGEURL,
        ORDERINDEX
      FROM HELP_VIDEOS
      WHERE ACTIVE = 1
        AND SECTIONID IN (
          SELECT ID FROM HELP_SECTIONS WHERE MODULEID = pModuleId AND ACTIVE = 1
        )
      ORDER BY SECTIONID, ORDERINDEX;

  END GET_HELP_CONTENT;

 PROCEDURE COM_INSERT_HELP_VIDEO (
    p_section_id   IN NUMBER,
    p_title        IN VARCHAR2,
    p_description  IN VARCHAR2,
    p_video_url    IN VARCHAR2,
    p_image_url    IN VARCHAR2,
    p_order_index  IN NUMBER,
    p_created_by   IN NUMBER,
    IDOUT          out NUMBER
)
IS
BEGIN
    INSERT INTO HELP_VIDEOS (
        SECTIONID, TITLE, DESCRIPTION, VIDEOURL, IMAGEURL,
        ORDERINDEX, ACTIVE, CREATEDBY, CREATEDDATE
    )
    VALUES (
        p_section_id,
        p_title,
        p_description,
        p_video_url,
        p_image_url,
        p_order_index,
        1,  -- Activo
        p_created_by,
        SYSDATE
    )
    RETURNING ID INTO IDOUT;
    COMMIT;
END COM_INSERT_HELP_VIDEO;
PROCEDURE COM_GETBYSEARCH_PAGINATED_HELP_VIDEO(
    pModuleId     IN NUMBER,
    pTextSearch   IN VARCHAR2,
    pRow          IN NUMBER,
    pTotalRecord  IN NUMBER,
    cursorOut     OUT COM_CURSOR_COMMON
)
IS
BEGIN
  OPEN cursorOut FOR
    SELECT *
    FROM (
      SELECT 
        hp.id, 
        hs.moduleid,
        CASE 
          WHEN UPPER(TRIM(mtd.value1)) = 'FINANZAS' THEN 'Mi Negocio'
          WHEN UPPER(TRIM(mtd.value1)) = 'MARKET PLACE' THEN 'Marketplace'
          ELSE mtd.value1
        END AS ModuleName,
        hp.title as name,
        hs.title as sectionName,
        hp.description,
        hp.imageUrl,
        hp.videoUrl as videoUrl,
        hp.orderindex as position,
        hp.active as statusid,
        hp.createdby,
        hp.createddate,
        ROW_NUMBER() OVER (ORDER BY hp.orderindex ASC) AS NroRow,
        COUNT(*) OVER() AS TotalRow
      FROM help_videos hp inner join  help_sections hs
      on hp.sectionid = hs.id
      LEFT JOIN mastertabledetail mtd ON hs.moduleid = mtd.idparameter
      WHERE hp.active = 1
        AND mtd.mastertableid = 12
        AND mtd.status = 1
        AND (pModuleId = 0 OR hs.moduleid = pModuleId)
        AND (pTextSearch IS NULL OR UPPER(hp.title) LIKE '%' || UPPER(pTextSearch) || '%')
    )
    WHERE NroRow BETWEEN ((pRow - 1) * pTotalRecord + 1) AND (pRow * pTotalRecord)
    ORDER BY NroRow;
END;
PROCEDURE COM_UPDATESTATUS_HELP_VIDEO(
    pid IN NUMBER,
    pstatusid IN NUMBER,
    pupdatedby IN NUMBER, 
    IDOUT OUT NUMBER
)
IS
BEGIN 
  UPDATE help_videos
  SET
    active = pstatusid,
    updatedby = pupdatedby,
    updateddate = SYSDATE
  WHERE id = pid;

  IDOUT := SQL%ROWCOUNT;
END;

PROCEDURE COM_UPDATE_HELP_VIDEO(
    pid            IN NUMBER,
    psectionid     IN NUMBER,
    ptitle         IN VARCHAR2,
    pdescription   IN VARCHAR2,
    pvideoUrl  IN VARCHAR2,
    pimageUrl  IN VARCHAR2,
    porderindex    IN NUMBER,
    pupdatedby     IN NUMBER,
    IDOUT OUT NUMBER
)
IS
BEGIN
  UPDATE help_videos
  SET
    title = ptitle,
    --description = pdescription,
    imageurl = pimageUrl,
    videourl = pvideoUrl,
    orderindex = porderindex,
    sectionid = psectionid,
    updatedby = pupdatedby, 
    updateddate = SYSDATE
  WHERE id = pid;
  IDOUT := SQL%rowcount;
END;
PROCEDURE COM_GET_ALL_HELP_SECTION(
    cursorOut OUT COM_CURSOR_COMMON
)
IS
BEGIN
  OPEN cursorOut FOR
    SELECT 
    hs.id,
    hs.title as sectionname
    FROM help_sections hs
    WHERE  hs.active = 1;
END;
END PKG_COMMON;
/