create or replace PACKAGE USRECOSISTEMAS.PKG_UBIGEO is

type UB_CURSOR_UBIGEO IS REF CURSOR;

PROCEDURE UB_DEPARTMENT_GET(cursorUbigeoOut OUT UB_CURSOR_UBIGEO);
PROCEDURE UB_PROVINCE_GET_DEPARMENTID(pid in NUMBER,cursorUbigeoOut OUT UB_CURSOR_UBIGEO);
PROCEDURE UB_DISTRICT_GET_PROVINCEID(pid in NUMBER,cursorUbigeoOut OUT UB_CURSOR_UBIGEO);
PROCEDURE UB_UBIGEO_GETALL(
  cursorDepartments OUT UB_CURSOR_UBIGEO,
  cursorProvinces OUT UB_CURSOR_UBIGEO,
  cursorDistricts OUT UB_CURSOR_UBIGEO
  );
  
END PKG_UBIGEO;

/
create or replace PACKAGE BODY USRECOSISTEMAS.PKG_UBIGEO IS


PROCEDURE UB_DEPARTMENT_GET(cursorUbigeoOut OUT UB_CURSOR_UBIGEO)
IS
BEGIN
  OPEN cursorUbigeoOut FOR
  SELECT a.id,a.name FROM department a where  a.statusid = 1 order by a.name asc;
END UB_DEPARTMENT_GET;

PROCEDURE UB_PROVINCE_GET_DEPARMENTID(pid in NUMBER,cursorUbigeoOut OUT UB_CURSOR_UBIGEO)
IS
BEGIN
  OPEN cursorUbigeoOut FOR
  SELECT p.id,p.name FROM province p where p.departmentid = pid and p.statusid = 1 order by p.name asc;
END UB_PROVINCE_GET_DEPARMENTID;

PROCEDURE UB_DISTRICT_GET_PROVINCEID(pid in NUMBER,cursorUbigeoOut OUT UB_CURSOR_UBIGEO)
IS
BEGIN
  OPEN cursorUbigeoOut FOR
  SELECT d.id,d.name FROM district d where d.provinceid = pid and d.statusid = 1 order by d.name asc;
END UB_DISTRICT_GET_PROVINCEID;

PROCEDURE UB_UBIGEO_GETALL(
  cursorDepartments OUT UB_CURSOR_UBIGEO,
  cursorProvinces OUT UB_CURSOR_UBIGEO,
  cursorDistricts OUT UB_CURSOR_UBIGEO
  )
IS
BEGIN
  OPEN cursorDepartments FOR
  SELECT * FROM Department WHERE STATUSID = 1 
  ORDER BY Name ASC;
  
  OPEN cursorProvinces FOR
    SELECT * FROM Province
    WHERE STATUSID = 1
    ORDER BY Name ASC;
    
    OPEN cursorDistricts FOR
    SELECT * FROM District
    WHERE STATUSID = 1
    ORDER BY Name ASC;
END UB_UBIGEO_GETALL;
END PKG_UBIGEO;

/