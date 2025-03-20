create or replace package PQ_CN_ENVCERCAN is

  -- Author  : WCRW
  -- Created : 20/07/2021
  -- Purpose : Envio de Data a Masivian
  TYPE lc_liscur IS REF CURSOR;
  PROCEDURE SP_ENVDATCERCAN (PN_NUMREG NUMBER,pc_liscre out lc_liscur,
                           ps_coderr out varchar2,ps_msgerr out varchar2);
  PROCEDURE SP_ACTENVDAT (PD_FECPRO DATE,PN_NUMERA NUMBER,PC_CODCRE VARCHAR2,
                        PN_CODSMS NUMBER,PC_DESURL VARCHAR2,PN_FLCENV NUMBER,
                        ps_coderr out varchar2,ps_msgerr out varchar2);
  PROCEDURE SP_ACTDESCER (PD_FECPRO DATE,PN_NUMERA NUMBER,PC_CODCRE VARCHAR2,
                        PD_FECDES DATE,PC_HORDES CHAR,
                        ps_coderr out varchar2,ps_msgerr out varchar2); 
end PQ_CN_ENVCERCAN;
/

create or replace package body PQ_CN_ENVCERCAN is

PROCEDURE SP_ENVDATCERCAN (PN_NUMREG NUMBER,pc_liscre out lc_liscur,
                           ps_coderr out varchar2,ps_msgerr out varchar2) AS
-- *****************************************************************
-- Nombre                     : SP_ENVDATCERCAN
-- Sistema                    : BANTOTAL
-- Módulo                     : ENVIO DATA MASIVIAN
-- Versión                    : 1.0
-- Fecha de Creación          : 20/07/2021
-- Autor de Creación          : WCRW
-- Uso                        : Carga de data Masivian
-- Estado                     : Activo
-- Fecha Modificación         : 27/098/2022
-- Autor de Modificación      : WCRW
-- Descripcion Modificacion   : Envio de correlativo y codigo de crédito, ya no existe codigo de credito en el nombre del archivo
-- *****************************************************************

-- Ruta Archivo: '/opt/bantotal/archivosbt/spool/extractos/'
begin
   open pc_liscre for
   select jaql845nudoc,jaql845noarc,jaql845teleg,jaql845tecor,jaql845teneg,jaql845nomcli,jaql845fepro,jaql845numer,jaql845codcre
     from jaql845
    where jaql845flcenv = 0
      and jaql845numenv <= 3
      and rownum <= PN_NUMREG
      order by jaql845fepro, jaql845numer;
   ps_coderr := '00000';
   ps_msgerr := '';
 exception
 when no_data_found then
      ps_coderr := '00011';
      ps_msgerr := 'NO HAY DATOS';
 when others then
      ps_coderr := '00099';
      ps_msgerr := SQLERRM;
end SP_ENVDATCERCAN;

PROCEDURE SP_ACTENVDAT (PD_FECPRO DATE,PN_NUMERA NUMBER,PC_CODCRE VARCHAR2,
                        PN_CODSMS NUMBER,PC_DESURL VARCHAR2,PN_FLCENV NUMBER,
                        ps_coderr out varchar2,ps_msgerr out varchar2) AS
-- *****************************************************************
-- Nombre                     : SP_ACTENVDAT
-- Sistema                    : BANTOTAL
-- Módulo                     : ENVIO DATA MASIVIAN
-- Versión                    : 1.0
-- Fecha de Creación          : 20/07/2021
-- Autor de Creación          : WCRW
-- Uso                        : Actualiza registros cargados en Masivian
-- Estado                     : Activo
-- Fecha Modificación         : 
-- Autor de Modificación      : 
-- Descripcion Modificacion   : 
-- *****************************************************************
begin
   ps_coderr := '00000';
   ps_msgerr := '';
   if PN_FLCENV = 1 then
      begin
         update jaql845 
            set jaql845flcenv = 1,jaql845fecenv = trunc(sysdate),
                jaql845codsms = PN_CODSMS,jaql845desurl = PC_DESURL,
                jaql845numenv = jaql845numenv + 1
          where jaql845fepro = PD_FECPRO
            and jaql845numer = PN_NUMERA
            and jaql845codcre = PC_CODCRE;
         commit;
      exception
      when no_data_found then
         ps_coderr := '00011';
         ps_msgerr := 'NO HAY DATOS';
      when others then
        ps_coderr := '00099';
        ps_msgerr := SQLERRM;
      end;
   else
      begin
         update jaql845 
            set jaql845flcenv = 0,jaql845numenv = jaql845numenv + 1,
                jaql845codsms = PN_CODSMS,jaql845desurl = PC_DESURL
          where jaql845fepro = PD_FECPRO
            and jaql845numer = PN_NUMERA
            and jaql845codcre = PC_CODCRE;
         commit;
      exception
      when no_data_found then
         ps_coderr := '00011';
         ps_msgerr := 'NO HAY DATOS';
      when others then
        ps_coderr := '00099';
        ps_msgerr := SQLERRM;
      end;
   end if;
end SP_ACTENVDAT;

PROCEDURE SP_ACTDESCER (PD_FECPRO DATE,PN_NUMERA NUMBER,PC_CODCRE VARCHAR2,
                        PD_FECDES DATE,PC_HORDES CHAR,
                        ps_coderr out varchar2,ps_msgerr out varchar2) AS
-- *****************************************************************
-- Nombre                     : SP_ACTDESCER
-- Sistema                    : BANTOTAL
-- Módulo                     : ENVIO DATA MASIVIAN
-- Versión                    : 1.0
-- Fecha de Creación          : 20/07/2021
-- Autor de Creación          : WCRW
-- Uso                        : Actualiza fecha descargda de pdf
-- Estado                     : Activo
-- Fecha Modificación         : 
-- Autor de Modificación      : 
-- Descripcion Modificacion   : 
-- *****************************************************************
begin
   ps_coderr := '00000';
   ps_msgerr := '';
   update jaql845 
      set jaql845fedes = PD_FECDES,jaql845hodes = PC_HORDES,
          jaql845flcdes = 1
    where jaql845fepro = PD_FECPRO
      and jaql845numer = PN_NUMERA
      and jaql845codcre = PC_CODCRE;
   commit;   
 exception
 when no_data_found then
      ps_coderr := '00011';
      ps_msgerr := 'NO HAY DATOS';
 when others then
      ps_coderr := '00099';
      ps_msgerr := SQLERRM;
end SP_ACTDESCER;

end PQ_CN_ENVCERCAN;
/

