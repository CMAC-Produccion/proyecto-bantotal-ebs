create or replace package PQ_CR_VARIABLES_REPRO is
 
    -- *****************************************************************
    -- Nombre                     : VARIABLES REPROGRAMACION RN 90-91
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2021.09.18
    -- Autor de Creación          : DCASTRO 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure SP_ESTADO_RPG(PN_INSTANCIA in number,
                        PC_ESTADO out varchar2
                        );
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

procedure SP_IND_PRODUCTO_RN(PN_INSTANCIA in number,
                            PC_INDICADOR out varchar2
                            );
                            
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

procedure SP_PLAZO_MIN(PN_INSTANCIA in number,
                        PN_PLAZO out number
                            );
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                            
procedure SP_EXONER_CAP(PN_INSTANCIA in number,
                           PN_EXISTE out number
                           );
                            
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 
end PQ_CR_VARIABLES_REPRO;
/

create or replace package body PQ_CR_VARIABLES_REPRO is
 
    -- *****************************************************************
    -- Nombre                     : VARIABLES REPROGRAMACION RN 90-91
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2021.09.18
    -- Autor de Creación          : DCASTRO 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************      
 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

procedure SP_ESTADO_RPG(PN_INSTANCIA in number,
                        PC_ESTADO out varchar2
                        ) is
                           

begin

 --VARIABLE:            ESTADO_RPG 
 --REPORTEADOR:         50000  -  NORMALIZACION  - 22
 
  begin
    select j.jaqa400est             
         into PC_ESTADO
         from jaqa400 j, xwf700 x
    where x.xwfprcins = PN_INSTANCIA
       and j.jaqa400emp = x.xwfempresa
       and j.jaqa400mod = x.xwfmodulo
       and j.jaqa400suc = x.xwfsucursal
       and j.jaqa400mda = x.xwfmoneda
       and j.jaqa400pap = x.xwfpapel
       and j.jaqa400cta = x.xwfcuenta
       and j.jaqa400ope = x.xwfoperacion
       and j.jaqa400sbo = x.xwfsubope
       and j.jaqa400top = x.xwftipope
       and x.xwfcar3 = '1'
       and j.jaqa400fec in (select max(j.jaqa400fec)
                              from jaqa400 j, xwf700 x
                             where x.xwfprcins = PN_INSTANCIA
                               and j.jaqa400emp = x.xwfempresa
                               and j.jaqa400mod = x.xwfmodulo
                               and j.jaqa400suc = x.xwfsucursal
                               and j.jaqa400mda = x.xwfmoneda
                               and j.jaqa400pap = x.xwfpapel
                               and j.jaqa400cta = x.xwfcuenta
                               and j.jaqa400ope = x.xwfoperacion
                               and j.jaqa400sbo = x.xwfsubope
                               and j.jaqa400top = x.xwftipope
                               and x.xwfcar3 = '1');
  exception when others then
       PC_ESTADO := NULL;        
  end;


end SP_ESTADO_RPG;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

procedure SP_IND_PRODUCTO_RN(PN_INSTANCIA in number,
                            PC_INDICADOR out varchar2
                            ) is
                           

begin

 --VARIABLE:            IND_PRODUCTO_RN 
 --REPORTEADOR:         50003  -  ESTADO 
 
  begin
    select trim(b.aqpa869ind)
       INTO PC_INDICADOR
       FROM xwf700 a, aqpa869 b
       where a.xwfprcins = PN_INSTANCIA
         and a.xwfcar3 = '1'
         and b.aqpa869mod = a.xwfmodulo
         and b.aqpa869top = a.xwftipope;
         

  exception when others then
       PC_INDICADOR := NULL;        
  end;


end SP_IND_PRODUCTO_RN;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

procedure SP_PLAZO_MIN(PN_INSTANCIA in number,
                       PN_PLAZO out number
                       ) is
                           

begin

 --VARIABLE:            SP_PLAZO_MIN 
 --REPORTEADOR:         5000 ,   32  -  PLAZO_MIN 
 
  begin 
    select max(y.ppfpag) - trunc(sysdate)
       INTO PN_PLAZO
       FROM xwf700 x , fsd601  y
      where x.xwfprcins = PN_INSTANCIA
      and  x.xwfcar3 = '1'
      and y.pgcod = x.xwfempresa
      and y.ppmod = x.xwfmodulo
      and y.ppsuc = x.xwfsucursal
      and y.ppmda = x.xwfmoneda
      and y.pppap = x.xwfpapel
      and y.ppcta = x.xwfcuenta
      and y.ppoper = x.xwfoperacion
      and y.ppsbop = 609;
  exception when others then
       PN_PLAZO := NULL;        
  end;


end SP_PLAZO_MIN;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

procedure SP_EXONER_CAP(PN_INSTANCIA in number,
                        PN_EXISTE out number
                       ) is
                               

begin

 --VARIABLE:            SP_EXONER_CAP
 --REPORTEADOR:          50000 ,   26  -  EXONER_CAP 
 
  begin 
    select COUNT(*)
       INTO PN_EXISTE
       FROM LEY31050 L,
        LEY31050_CREDITOSFACILIDAD F,
           XWF700 X
        WHERE L.IDLEY31050 = F.IDLEY31050  
           AND L.ESTADOSOLICITUD = 'BT'
           AND L.TIPOFACILIDAD = 'CAJA'
           AND upper(F.FACILIDAD) like '%CAPI%'
           AND X.XWFPRCINS = PN_INSTANCIA
           AND X.XWFCAR3 = '1'
          AND X.XWFCUENTA = SUBSTR(F.CUENTAOPERACION,0,
                      INSTR(F.CUENTAOPERACION, '-') - 1)
              AND X.XWFOPERACION = SUBSTR(F.CUENTAOPERACION,
                      INSTR(F.CUENTAOPERACION, '-') + 1,99)
           AND F.EMPRESA = X.XWFEMPRESA
           AND F.SUCURSAL = X.XWFSUCURSAL
           AND F.MODULO = X.XWFMODULO
           AND F.MONEDA = X.XWFMONEDA
           AND F.PAPEL = X.XWFPAPEL
           AND F.SUBOPERACION = X.XWFSUBOPE
           AND F.TIPOOPERACION = X.XWFTIPOPE;
  exception when others then
       PN_EXISTE := NULL;        
  end;


end SP_EXONER_CAP;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

end PQ_CR_VARIABLES_REPRO;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
/

