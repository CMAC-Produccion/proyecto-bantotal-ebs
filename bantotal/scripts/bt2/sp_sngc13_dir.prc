CREATE OR REPLACE PROCEDURE SP_SNGC13_DIR(
                                          
                                          ppais       IN NUMBER, -- Empresa
                                          tipo        IN NUMBER, -- Fecha en DD/MM/YYYY
                                          numdoc      IN VARCHAR2, -- Rubro
                                          cuenta      IN NUMBER,
                                          VDOCOD      in NUMBER,
                                          VSNGC13CORR in NUMBER,
                                          nsngc13pdoc number,
                                          nsngc12vivc char,
                                          nsngc01id   number,
                                          nsngc02id   number,
                                          nsngc03id   number,
                                          nsngc04id   number,
                                          nsngc05id   number,
                                          nsngc06id   number,
                                          nsngc13dsc2 char,
                                          nsngc13dsc3 char,
                                          nsngc13dsc1 char,
                                          nsngc13dsc4 char,
                                          nsngc13dsc5 char,
                                          nsngc13dsc6 char,
                                          nsngc13ugeo char,
                                          nsngc13dpto number,
                                          nsngc13prov number,
                                          nsngc13dist number,
                                          nsngc13cneg char,
                                          nsngc13ref  varchar2,
                                          nsngc13ref1 varchar2,
                                          nsngc13dir  char,
                                          nsngc13rdes date,
                                          nsngc13arr  char,
                                          nsngc13atel char,
                                          nsngc13fhab date,
                                          nsngc13est  char,
                                          nsngc13dest number,
                                          nsngc13fdir date,
                                          nsngc13user char,
                                          nsngc13col  number,
                                          nsngc13tas  number
                                          
                                          ) is
  pragma autonomous_transaction;
BEGIN
  commit;
  --grabo la direccion, telefono y correo anterior de cuenta cliente
  /*insert into SNGC13COP
  select a.*,sysdate from sngc13 a
   where a.sngc13pais = 0
     and a.sngc13tdoc = 0
     and a.sngc13ndoc = rpad(to_char(cuenta), 12, ' ');
  insert into SNGC17COP
  select a.*,sysdate from SNGC17 a
   where a.sngc17pais = 0
     and a.sngc17tdoc = 0
     and a.sngc17ndoc = rpad(to_char(cuenta), 12, ' ');
  insert into fsr006COP
  select a.*,sysdate from fsr006 a
   where a.pgcod = 1
     and a.ctnro = rpad(to_char(cuenta), 12, ' ');
  insert into fsx008COP
  select a.*,sysdate from fsx008 a
   where a.pgcod = 1
     and a.ctnro = rpad(to_char(cuenta), 12, ' ');     */          
--borro todo la informacion de la cuenta cliente
  delete from sngc13 a
   where a.sngc13pais = 0
     and a.sngc13tdoc = 0
     and a.sngc13ndoc = rpad(to_char(cuenta), 12, ' ');
  delete from SNGC17 a
   where a.sngc17pais = 0
     and a.sngc17tdoc = 0
     and a.sngc17ndoc = rpad(to_char(cuenta), 12, ' ');
  delete from fsr006 a
   where a.pgcod = 1
     and a.ctnro = rpad(to_char(cuenta), 12, ' ');
  delete from fsx008 a
   where a.pgcod = 1
     and a.ctnro = rpad(to_char(cuenta), 12, ' ');   
--inserto informacion de la persona en cuenta cliente
  --Domicilio
  insert into sngc13
    SELECT 0,
           0,
           cuenta,
           docod,
           sngc13corr,
           sngc13pdoc,
           sngc12vivc,
           sngc01id,
           sngc02id,
           sngc03id,
           sngc04id,
           sngc05id,
           sngc06id,
           sngc13dsc2,
           sngc13dsc3,
           sngc13dsc1,
           sngc13dsc4,
           sngc13dsc5,
           sngc13dsc6,
           sngc13ugeo,
           sngc13dpto,
           sngc13prov,
           sngc13dist,
           sngc13cneg,
           sngc13ref,
           sngc13ref1,
           sngc13dir,
           sngc13rdes,
           sngc13arr,
           sngc13atel,
           sngc13fhab,
           sngc13est,
           sngc13dest,
           sngc13fdir,
           sngc13user,
           sngc13col,
           sngc13tas
      from sngc13 a
     where a.sngc13pais = ppais
       and a.sngc13tdoc = tipo
       and a.sngc13ndoc = rpad(to_char(numdoc), 12, ' ');
  commit;
--telefono
  insert into sngc17
  select 0,cuenta ,0,sngc17dcod,sngc17corr,sngc16ttel from sngc17 
  where sngc17pais=ppais and sngc17tdoc=tipo and sngc17ndoc=rpad(to_char(numdoc), 12, ' ');
  insert into fsr006
  select 1,cuenta ,b.docod ,DOORDP,b.dotelfp,b.dotlexp,b.dofaxp from fsr005 b
  where b.pepais=ppais and b.petdoc=tipo and b.pendoc=rpad(to_char(numdoc), 12, ' ');
--correo
  insert into fsx008
  select 1,cuenta,s.txcod,s.pexren,s.pextxt,s.pexusu,s.pexfch from fsx001 s
  where s.pepais=ppais and s.petdoc=tipo and s.pendoc=rpad(to_char(numdoc), 12, ' ');


--elimino la direccion a actualizar  
  delete from sngc13 a
   where a.sngc13pais = 0
     and a.sngc13tdoc = 0
     and a.sngc13ndoc = rpad(to_char(cuenta), 12, ' ')
     and a.docod = vdocod
     and a.sngc13corr = VSNGC13CORR;

  insert into sngc13
  values
    (0,
     0,
     cuenta,
     VDOCOD,
     VSNGC13CORR,
     nsngc13pdoc,
     nsngc12vivc,
     nsngc01id,
     nsngc02id,
     nsngc03id,
     nsngc04id,
     nsngc05id,
     nsngc06id,
     nsngc13dsc2,
     nsngc13dsc3,
     nsngc13dsc1,
     nsngc13dsc4,
     nsngc13dsc5,
     nsngc13dsc6,
     nsngc13ugeo,
     nsngc13dpto,
     nsngc13prov,
     nsngc13dist,
     nsngc13cneg,
     nsngc13ref,
     nsngc13ref1,
     nsngc13dir,
     nsngc13rdes,
     nsngc13arr,
     nsngc13atel,
     nsngc13fhab,
     nsngc13est,
     nsngc13dest,
     nsngc13fdir,
     nsngc13user,
     nsngc13col,
     nsngc13tas);
  commit;
END;
/

