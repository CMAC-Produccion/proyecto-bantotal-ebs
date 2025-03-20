CREATE OR REPLACE PROCEDURE SP_SNGC13_MAIL(
                                          
                                          ppais       IN NUMBER, -- Empresa
                                          tipo        IN NUMBER, -- Fecha en DD/MM/YYYY
                                          numdoc      IN VARCHAR2, -- Rubro
                                          cuenta      IN NUMBER,
                                          ntxcod      in NUMBER,
                                          nctxren     in NUMBER,
                                          nctxtxt     in char,
                                          nctxusu     in char,
                                          nctxfch     in date,
                                          elimina  in number
                                          ) is
  pragma autonomous_transaction;
  
BEGIN
  commit;
/*  --grabo la direccion, telefono y correo anterior de cuenta cliente
  insert into SNGC13COP
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

--elimino el correo a actualizar  
  delete from fsx008 a
   where a.pgcod=1
     and a.txcod=ntxcod
     and a.ctxren=nctxren
     and a.ctnro = rpad(to_char(cuenta), 12, ' ');
     commit;

--actualizo correo
if elimina>0 then
  insert into fsx008
  values
    (1,
     cuenta,
     ntxcod,
     nctxren,
     nctxtxt,
     nctxusu,
     nctxfch
    );
end if;
  commit;

END;
/

