create or replace package PQ_CR_POLIZA_DESGRA is
    -- *****************************************************************
    -- Nombre                     : PAQUETES PARA OBTENER INFORMACIONpara poliza desgravamen
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2020.03.18
    -- Autor de Creación          : DCASTRO
    -- Uso                        : Realiza Calculos PARA SEGURO DESGRAVAMEN 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : FECHA DE PROCESO
    --
    --
    --
    -- *****************************************************************
-----------------------------------------------------------------------
procedure sp_cr_seg_desgra(pn_instancia in number,
                         /*  ln_pgcod out number,
                           ln_aomod out number,
                           ln_aosuc out number,
                           ln_aomda out number,
                           ln_aopap out number,
                           ln_aocta out number,
                           ln_aooper out number,
                           ln_aosbop out number,
                           ln_aotope out number,*/
                           ln_sgcod out number,
                           ln_monto out number
  ) ;
-----------------------------------------------------------------------
procedure sp_cr_seg_datos(pn_cuenta in number,
                           vNombre out varchar2,
                           vmail out varchar2,
                           vfecnac out date,
                           vDepNom out varchar2,
                           vLocNom out varchar2,
                           Distrito out varchar2,
                           Dir2Pres out varchar2
  );
-----------------------------------------------------------------------

end PQ_CR_POLIZA_DESGRA;
/

create or replace package body PQ_CR_POLIZA_DESGRA is

procedure sp_cr_seg_desgra(pn_instancia in number,
                          /* ln_pgcod out number,
                           ln_aomod out number,
                           ln_aosuc out number,
                           ln_aomda out number,
                           ln_aopap out number,
                           ln_aocta out number,
                           ln_aooper out number,
                           ln_aosbop out number,
                           ln_aotope out number,*/
                           ln_sgcod out number,
                           ln_monto out number
  ) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_seg_desgra
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2020.03.18
    -- Autor de Creación          : DCASTRO
    -- Uso                        : Ejecuta el proceso de altas,bajas y pagos diarios.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --                              
  -- *****************************************************************


begin

begin
  select /*f.pgcod,
         f.aomod,
         f.aosuc,
         f.aomda,
         f.aopap,
         f.aocta,
         f.aooper,
         f.aosbop,
         f.aotope,*/
         f.sgcod, 
         x.xwfmonto1
    into /*ln_pgcod,
         ln_aomod,
         ln_aosuc,
         ln_aomda,
         ln_aopap,
         ln_aocta,
         ln_aooper,
         ln_aosbop,
         ln_aotope,*/
         ln_sgcod,
         ln_monto
    from fpp001 f, xwf700 x
   where f.pgcod = x.xwfempresa
     and f.aomod = x.xwfmodulo
     and f.aosuc = x.xwfsucursal
     and f.aomda = x.xwfmoneda
     and f.aopap = x.xwfpapel
     and f.aocta = x.xwfcuenta
     and f.aooper = x.xwfoperacion
     and f.aosbop = x.xwfsubope
     and f.aotope = x.xwftipope
     and f.sgcod in (select tp1imp1
                       from fst198 x
                      where x.tp1cod = 1
                        and x.tp1cod1 = 10898
                        and tp1corr1 = 8)
     and x.xwfprcins = pn_instancia;
 exception when others then
    ln_sgcod := 0;   
 end;
end sp_cr_seg_desgra;
---------------------------------------------------------------------------------------------------------

procedure sp_cr_seg_datos(pn_cuenta in number,
                           vNombre out varchar2,
                           vmail out varchar2,
                           vfecnac out date,
                           vDepNom out varchar2,
                           vLocNom out varchar2,
                           Distrito out varchar2,
                           Dir2Pres out varchar2
  ) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_seg_datos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2020.03.18
    -- Autor de Creación          : DCASTRO
    -- Uso                        : Datos del cliente
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --                              
  -- *****************************************************************
vpendoc char(12); 
vpetdoc number;
vpepais number;
NombreTitular varchar2(100);
sngc13Dir2Pres varchar2(140);
sngc13DistPres number(9);
sngc13ProvPrest number(5);
sngc13DptoPres number(5);
sngc13PaisPres number(3);
--vDepNom varchar2(20); 
--vLocnom varchar2(30); 
FST071DSCPrest varchar2(30); 
--Dir2Pres varchar2(220);
--vfecnac date;
--vmail varchar2(60);

begin


--//2017.11.13 - HSUAREZ Incorporado para ingresar nombres y apellidos completos. 
begin
 select Pendoc,  Petdoc, Pepais 
 into vpendoc, vpetdoc, vpepais
 from FSR008 f
        where Ctnro = pn_cuenta 
        and Cttfir = 'T';
exception when others then
    vpendoc := null;        
end; 
 
   If vpetdoc = 21 and vpepais=604 then --//2017.11.23 - Para validar el cambio solo para DNIs.
     begin
        select  --trim(Pfape1)||'-'||trim(Pfape2)||'-'||trim(Pfnom1)||'-'||trim(Pfnom2), pffnac
       trim(Pfnom1)||' '||trim(Pfnom2)||','|| trim(Pfape1)||' '||trim(Pfape2), pffnac
        into   NombreTitular, vfecnac 
        from fsd002
            where Pfpais = vpepais
            and  Pftdoc = vpetdoc--
            and Pfndoc = vpendoc;
      exception when others then
         NombreTitular := null;
     end;             
   end if;
   If vpetdoc = 9 and vpepais=604 then --//2017.11.23 - Para validar el cambio solo para DNIs.
        begin 
         select trim(Pjrazs) 
         into NombreTitular
         from fsd003
            where Pjpais = vpepais
            and Pjtdoc = vpetdoc
            and Pjndoc = vpendoc;
        exception when others then
         NombreTitular := null;
        end;    
   end if;
   
-- direccion

   begin
   select sngc13Dir, sngc13Dist ,  sngc13Prov  , sngc13Dpto, sngc13Pdoc
   into sngc13Dir2Pres, sngc13DistPres, sngc13ProvPrest,sngc13DptoPres, sngc13PaisPres
   from sngc13
     where sngc13Pais = vpepais
           and sngc13Tdoc = vpetdoc
           and sngc13Ndoc = vpendoc
           and Docod      = 1
           and sngc13Est  = 'H' ;
    exception when others then
         sngc13Dir2Pres := null;
   end;  

   begin
        select DepNom 
        into vDepNom 
        from fst068 ---DEPARTAMENTO
            where Pais  = sngc13PaisPres  
            and DepCod  = sngc13DptoPres;
    exception when others then
         vDepNom := null;

   end;

   begin
        select locnom 
        into vLocNom
        from fst070 ----PROVINCIA
            where Pais   = sngc13PaisPres
            and DepCod = sngc13DptoPres
            and LocCod = sngc13ProvPrest;
    exception when others then
         vLocNom := null;
   end;

   begin
     select  Fst071Dsc
       into FST071DSCPrest 
       from fst071----DISTRITO
            where Fst071Pai = sngc13PaisPres
            and Fst071Dpt = sngc13DptoPres
            and Fst071Loc = sngc13ProvPrest
            and Fst071Col = sngc13DistPres;
    exception when others then
         FST071DSCPrest := null;       
   end;

    Dir2Pres := Trim(FST071DSCPrest)||'-'||trim(vLocNom)||'-'||trim(vDepNom); --//Dirección con Distrito del 2do Titular

   ---mail
   begin
   
    select f.pextxt 
    into vmail
    from fsx001 f 
    where f.txcod = 0 and f.pepais = vpepais  and f.petdoc = vpetdoc and f.pendoc = vpendoc;
    exception when others then
         vmail := null;       
   end;


   vNombre := NombreTitular;
   Distrito:= FST071DSCPrest ;
   
end sp_cr_seg_datos;
---------------------------------------------------------------------------------------------------------


				 
END PQ_CR_POLIZA_DESGRA;
/

