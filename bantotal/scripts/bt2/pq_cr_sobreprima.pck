create or replace package PQ_CR_SOBREPRIMA is

    -- *****************************************************************
    -- Nombre                     : PAQUETES PARA OBTENER INFORMACION DE SOBREPRIMAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2017.09.20
    -- Autor de Creación          : CRISTHIAN CERPA
    -- Uso                        : Insercion, eliminacion , actulizacion
    -- Estado                     : Activo
    -- Acceso                     : Público
    --
    --
    -- *****************************************************************

-------------------------------------------------------------
  PROCEDURE SP_INSERTAR_SOBREPRIMAJAQZ724 ( LN_JAQZ724INS IN NUMBER,
                                            LN_JAQZ724TDOC IN NUMBER,
                                            LC_JAQZ724DOC IN VARCHAR2,
                                            LN_JAQZ724MOD IN NUMBER,
                                            LN_JAQZ724CTA in NUMBER,                                            
                                            LN_JAQZ724MDA IN NUMBER,
                                            LD_JAQZ724FECI IN DATE,
                                            LN_JAQZ724MONH IN NUMBER,
                                            LD_JAQZ724FECC IN DATE,
                                            LN_VJAQZ724TASS IN NUMBER,
                                            LC_JAQZ724IND   IN VARCHAR2,
                                            LC_jaqz724user in VARCHAR2,
                                            LN_INDICADOR  OUT varchar2
                                            
                                             );
-------------------------------------------------------------
PROCEDURE SP_UPDATE_SOBREPRIMAJAQZ724(    LN_JAQZ724TDOC IN NUMBER,
                                          LC_JAQZ724DOC IN VARCHAR2,
                                          LN_JAQZ724MOD IN NUMBER,
                                          LN_JAQZ724CTA IN NUMBER,
                                          LN_JAQZ724MDA IN NUMBER,
                                          LD_JAQZ724FECI IN DATE,
                                          LN_JAQZ724MONH IN NUMBER,
                                          LD_JAQZ724FECC IN DATE,
                                          LN_JAQZ724TASS IN NUMBER,
                                          LC_jaqz724user in VARCHAR2,
                                          LN_INDICADOR  OUT VARCHAR2);
-------------------------------------------------------------
PROCEDURE SP_INSERTAR_SOBREPRIMA(         ln_fsp026pgcod IN NUMBER,
                                          ln_fsp026comod IN NUMBER,
                                          ln_fsp026cocod IN NUMBER,
                                          ln_fsp026cocta IN NUMBER, 
                                          ln_fsp026copap IN NUMBER,
                                          ln_fsp026comda IN NUMBER,
                                          ld_dfechini IN date,
                                          ld_dfechcad IN date,
                                          ln_dmontohasta IN NUMBER,
                                          ln_fsd026cotasa IN NUMBER,
                                          ln_fsd026comin IN NUMBER,
                                          ln_fsd026comax IN NUMBER,
                                          ln_coimp IN NUMBER,
                                          lc_fsr026covig IN varchar2,
                                           ln_fsp026copzo IN NUMBER,
                                          ln_dtasasob IN NUMBER,
                                          ln_fsp026cominp IN NUMBER,
                                          ln_fsp026comaxp IN NUMBER,
                                          ln_fsp026coimpp IN NUMBER,
                                          lc_indicador out varchar2 );
-------------------------------------------------------------
PROCEDURE SP_ELIMNAR_SOBREPRIMA(          ln_fsp026pgcod IN NUMBER,
                                          ln_fsp026comod IN NUMBER,
                                          ln_fsp026cocod IN NUMBER,
                                          ln_fsp026cocta IN NUMBER, 
                                          ln_fsp026copap IN NUMBER,
                                          ln_fsp026comda IN NUMBER,
                                          ld_dfechini IN date,
                                          ln_dmontohasta IN NUMBER,
                                          lc_indicador out varchar2);
-------------------------------------------------------------
PROCEDURE SP_SELECT_VIGENTES   (          ln_fsr026pgcod IN NUMBER,
                                          ln_fsr026comod IN NUMBER,
                                          ln_fsr026cocod IN NUMBER,
                                          ln_fsr026cocta IN NUMBER, 
                                          ln_fsr026copap IN NUMBER,
                                          ln_fsr026comda IN NUMBER,
                                          ld_fsr026cofech IN date,
                                          lv_indicador out varchar2);

end PQ_CR_SOBREPRIMA;
/

create or replace package body PQ_CR_SOBREPRIMA is

PROCEDURE SP_INSERTAR_SOBREPRIMAJAQZ724(  LN_JAQZ724INS IN NUMBER,
                                              LN_JAQZ724TDOC IN NUMBER,
                                              LC_JAQZ724DOC IN VARCHAR2,
                                              LN_JAQZ724MOD IN NUMBER,
                                              LN_JAQZ724CTA IN NUMBER,
                                              LN_JAQZ724MDA IN NUMBER,
                                              LD_JAQZ724FECI IN DATE,
                                              LN_JAQZ724MONH IN NUMBER,
                                              LD_JAQZ724FECC IN DATE,
                                              LN_VJAQZ724TASS IN NUMBER,
                                              LC_JAQZ724IND   IN VARCHAR2,
                                               LC_jaqz724user in varchar2,
                                                LN_INDICADOR  OUT varchar2 )IS
   -- *****************************************************************
    -- Nombre                     : SP_CR_INSERT_JAQL406
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2017/09/20
    -- Autor de Creación          : Cristhian Cerpa
    -- Uso                        : insertar en la tabla log jaqz724
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --                              LN_JAQZ724INS
    --                              LN_JAQZ724TDOC
    --                              LC_JAQZ724DOC
    --                              LN_JAQZ724MOD
    --                              LN_JAQZ724CTA
    --                              LN_JAQZ724MDA
    --                              LD_JAQZ724FECI      
    --                              LN_JAQZ724MONH
    --                              LD_JAQZ724FECC      
    --                              LN_VJAQZ724TASS
    --                              LC_JAQZ724IND
    --                              LC_jaqz724user
    
    -- Retorno                    :  LN_INDICADOR Si se insecto correctamente
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- *****************************************************************

  contarjaqz724 number(10);
  contarexitencia number(10);
  lc_pendoc char(12);
 
  ln_xwfempresa number(3);
  ln_xwfsucursal number(3);
  ln_xwfmodulo number(3);
  ln_xwfmoneda number(4);
  ln_xwfpapel number(4);
  ln_xwfcuenta number(9);
  ln_xwfoperacion number(9);
  ln_wfsubope number(3);
  ln_wftipope number(3);
  
 
  begin
    lc_pendoc := RPAD(LC_JAQZ724DOC,12,' ');
      Begin
             LN_INDICADOR  :=' ';
             
        select count(*)
          into contarexitencia
          from jaqz724
         where jaqz724.jaqz724ins = LN_JAQZ724INS
           and jaqz724.jaqz724tdoc = LN_JAQZ724TDOC
           and jaqz724.jaqz724doc = lc_pendoc
           and JAQZ724IND <> 'D';
        if contarexitencia = 0 then
          insert into jaqz724
            (jaqz724ins,
             jaqz724tdoc,
             jaqz724doc,
             jaqz724mod,
             jaqz724cta,
             jaqz724mda,
             jaqz724feci,
             jaqz724monh,
             jaqz724fecc,
             jaqz724tass,
             jaqz724user,
             jaqz724ind)
          values
            (LN_JAQZ724INS,
             LN_JAQZ724TDOC,
             LC_JAQZ724DOC,
             LN_JAQZ724MOD,
             LN_JAQZ724CTA,
             LN_JAQZ724MDA,
             LD_JAQZ724FECI,
             LN_JAQZ724MONH,
             LD_JAQZ724FECC,
             LN_VJAQZ724TASS,
             LC_jaqz724user,
             LC_JAQZ724IND);
          commit;
          select count(*)
            into contarjaqz724
            from jaqz724 x
           where x.jaqz724ins = LN_JAQZ724INS
             and x.jaqz724tdoc = LN_JAQZ724TDOC
             and x.jaqz724doc = lc_pendoc;
          if contarjaqz724 <> 0 then
            LN_INDICADOR := 'S';
          else
            LN_INDICADOR := 'N';
          end if;
        else
          LN_INDICADOR := 'E';
        end if;
       
        ln_xwfempresa := 0;       
        select XWFEMPRESA, XWFSUCURSAL, XWFMODULO, XWFMONEDA, XWFPAPEL, XWFCUENTA, XWFOPERACION, XWFSUBOPE, XWFTIPOPE  
        into ln_xwfempresa, ln_xwfsucursal, ln_xwfmodulo, ln_xwfmoneda, ln_xwfpapel, ln_xwfcuenta, ln_xwfoperacion, ln_wfsubope, ln_wftipope 
        from XWF700 w
        where w.XWFPRCINS = LN_JAQZ724INS
        and w.XWFCAR3 = 1;
       
        if ln_xwfempresa <> 0 then
	        update FPP001 f
		    set f.PP001PORC = LN_VJAQZ724TASS
		    WHERE f.PGCOD = ln_xwfempresa
		    and f.AOMOD = ln_xwfmodulo 
		    and f.AOSUC = ln_xwfsucursal
		    and f.AOMDA = ln_xwfmoneda
		    and f.AOPAP = ln_xwfpapel
		    and f.AOCTA = ln_xwfcuenta
		    and f.AOOPER = ln_xwfoperacion
		    and f.AOSBOP = ln_wfsubope
		    and f.AOTOPE = ln_wftipope;
		    commit;
	    end if;
	   
      end;
  END SP_INSERTAR_SOBREPRIMAJAQZ724;
-------------------------------------------------------------------------------------------------------------------------------------      

  PROCEDURE SP_SELECT_VIGENTES   (        ln_fsr026pgcod IN NUMBER,
                                          ln_fsr026comod IN NUMBER,
                                          ln_fsr026cocod IN NUMBER,
                                          ln_fsr026cocta IN NUMBER, 
                                          ln_fsr026copap IN NUMBER,
                                          ln_fsr026comda IN NUMBER,
                                          ld_fsr026cofech IN date,
                                          lv_indicador out varchar2) is
   -- *****************************************************************
    -- Nombre                     : SP_SELECT_VIGENTES
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2017/09/20
    -- Autor de Creación          : Cristhian Cerpa
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :
    --                              ln_fsr026pgcod
    --                              ln_fsr026comod
    --                              ln_fsr026cocod
    --                              ln_fsr026cocta
    --                              ln_fsr026copap
    --                              ln_fsr026comda
    --                              ld_fsr026cofech      

    
    -- Retorno                    :  lv_indicador Si se insecto correctamente
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- *****************************************************************                                          
 begin
       SELECT fsr026.covig
         into lv_indicador
         FROM fsr026
        where fsr026.pgcod = ln_fsr026pgcod
          and fsr026.comod = ln_fsr026comod
          and fsr026.cocod = ln_fsr026cocod
          and fsr026.cocta = ln_fsr026cocta
          and fsr026.copap = ln_fsr026copap
          and fsr026.comda = ln_fsr026comda
          and fsr026.cofech = ld_fsr026cofech;
End SP_SELECT_VIGENTES;                                          
-------------------------------------------------------------------------------------------------------------------------------------  
PROCEDURE SP_UPDATE_SOBREPRIMAJAQZ724(  
                                          LN_JAQZ724TDOC IN NUMBER,
                                          LC_JAQZ724DOC IN VARCHAR2,
                                          LN_JAQZ724MOD IN NUMBER,
                                          LN_JAQZ724CTA IN NUMBER,
                                          LN_JAQZ724MDA IN NUMBER,
                                          LD_JAQZ724FECI IN DATE,
                                          LN_JAQZ724MONH IN NUMBER,
                                          LD_JAQZ724FECC IN DATE,
                                          LN_JAQZ724TASS IN NUMBER,
                                          LC_jaqz724user in VARCHAR2,
                                          LN_INDICADOR  OUT VARCHAR2)IS
    -- *****************************************************************
    -- Nombre                     : SP_UPDATE_SOBREPRIMAJAQZ724
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2017/09/20
    -- Autor de Creación          : Cristhian Cerpa
    -- Uso                        : actilizar las sobreprimas grabadas en la jaqz724
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --                              LN_JAQZ724TDOC
    --                              LC_JAQZ724DOC
    --                              LN_JAQZ724MOD
    --                              LN_JAQZ724CTA
    --                              LN_JAQZ724MDA
    --                              LD_JAQZ724FECI
    --                              LN_JAQZ724MONH      
    --                              LD_JAQZ724FECC
    --                              LN_JAQZ724TASS
    --                              LC_jaqz724user        

    
    -- Retorno                    :  LN_INDICADOR Si se a actualizados correctamente
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- *****************************************************************                                          

  contarjaqz724 number(10);
  contarexitencia number(10);
  lc_pendoc char(12); 
  begin
    lc_pendoc := RPAD(LC_JAQZ724DOC,12,' ');
      Begin
             LN_INDICADOR  :=' ';
             
        select count(*)
          into contarexitencia
          from jaqz724
         where jaqz724.jaqz724tdoc = LN_JAQZ724TDOC
           and jaqz724.jaqz724doc = lc_pendoc
           AND JAQZ724.JAQZ724MOD = LN_JAQZ724MOD
           AND JAQZ724.JAQZ724CTA = LN_JAQZ724CTA
           AND JAQZ724.JAQZ724MDA = LN_JAQZ724MDA
           AND JAQZ724.JAQZ724FECI = LD_JAQZ724FECI
           AND JAQZ724.JAQZ724MONH = LN_JAQZ724MONH
           AND JAQZ724.JAQZ724FECC = LD_JAQZ724FECC
           AND JAQZ724.JAQZ724TASS = LN_JAQZ724TASS
           and JAQZ724IND = 'I';
        if contarexitencia <> 0 then
          update jaqz724
             set jaqz724.jaqz724ind  = 'D',
                 JAQZ724.JAQZ724USER = LC_jaqz724user
           where jaqz724.jaqz724tdoc = LN_JAQZ724TDOC
             and jaqz724.jaqz724doc = lc_pendoc
             AND JAQZ724.JAQZ724MOD = LN_JAQZ724MOD
             AND JAQZ724.JAQZ724CTA = LN_JAQZ724CTA
             AND JAQZ724.JAQZ724MDA = LN_JAQZ724MDA
             AND JAQZ724.JAQZ724FECI = LD_JAQZ724FECI
             AND JAQZ724.JAQZ724MONH = LN_JAQZ724MONH
             AND JAQZ724.JAQZ724FECC = LD_JAQZ724FECC
             AND JAQZ724.JAQZ724TASS = LN_JAQZ724TASS;
          commit;
          select count(*)
            into contarjaqz724
            from jaqz724
           where jaqz724.jaqz724tdoc = LN_JAQZ724TDOC
             and jaqz724.jaqz724doc = lc_pendoc
             AND JAQZ724.JAQZ724MOD = LN_JAQZ724MOD
             AND JAQZ724.JAQZ724CTA = LN_JAQZ724CTA
             AND JAQZ724.JAQZ724MDA = LN_JAQZ724MDA
             AND JAQZ724.JAQZ724FECI = LD_JAQZ724FECI
             AND JAQZ724.JAQZ724MONH = LN_JAQZ724MONH
             AND JAQZ724.JAQZ724FECC = LD_JAQZ724FECC
             AND JAQZ724.JAQZ724TASS = LN_JAQZ724TASS
             AND JAQZ724.JAQZ724IND = 'I';
          if contarjaqz724 = 0 then
            LN_INDICADOR := 'S';
          else
            LN_INDICADOR := 'N';
          end if;
        else
          LN_INDICADOR := 'E';
        end if;
      end;
  END SP_UPDATE_SOBREPRIMAJAQZ724;    
-------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE SP_INSERTAR_SOBREPRIMA(         ln_fsp026pgcod IN NUMBER,
                                          ln_fsp026comod IN NUMBER,
                                          ln_fsp026cocod IN NUMBER,
                                          ln_fsp026cocta IN NUMBER, 
                                          ln_fsp026copap IN NUMBER,
                                          ln_fsp026comda IN NUMBER,
                                          ld_dfechini IN date,
                                          ld_dfechcad IN date,
                                          ln_dmontohasta IN NUMBER,
                                          ln_fsd026cotasa IN NUMBER,
                                          ln_fsd026comin IN NUMBER,
                                          ln_fsd026comax IN NUMBER,
                                          ln_coimp IN NUMBER,
                                          lc_fsr026covig IN varchar2,
                                          ln_fsp026copzo IN NUMBER,
                                          ln_dtasasob IN NUMBER,
                                          ln_fsp026cominp IN NUMBER,
                                          ln_fsp026comaxp IN NUMBER,
                                          ln_fsp026coimpp IN NUMBER,
                                          lc_indicador out varchar2)IS
  -- *****************************************************************
    -- Nombre                     : SP_CR_INSERT_JAQL406
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2017/09/20
    -- Autor de Creación          : Cristhian Cerpa
    -- Uso                        : insertar sobre primas en las tablas de dlya
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :
    --                              ln_fsp026pgcod
    --                              ln_fsp026comod
    --                              ln_fsp026cocod
    --                              LN_JAQZ724MOD
    --                              ln_fsp026cocta
    --                              ln_fsp026copap
    --                              ln_fsp026comda      
    --                              ld_dfechini
    --                              ld_dfechcad      
    --                              ln_dmontohasta
    --                              ln_fsd026cotasa
    --                              ln_fsd026comin
    --                              ln_fsd026comax
    --                              ln_coimp
    --                              lc_fsr026covig
    --                              ln_dtasasob
    --                              ln_fsp026cominp
    --                              ln_fsp026comaxp
    --                              ln_fsp026comaxp

    -- Retorno                    :  lc_indicador Si se insecto correctamente
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- *****************************************************************                                          
contadorfsd426 number(10):=0;
contadorfsd426ins number(10):=0;
contadorfsd026 number(10):=0;
contadorfsd026ins number(10):=0;
contadorfsr026 number(10):=0;
contadorfsr026ins number(10):=0;
contadorfsp026 number(10):=0;
contadorfsp026ins number(10):=0;
caso1 character(1);
caso2 character(1);
caso3 character(1);
caso4 character(1);
  begin
  --------------------------------FSD426----------------------------------------------------------------------
 select count(*)
   into contadorfsd426
   from fsd426
  where VCPGCOD = ln_fsp026pgcod
    and VCMOD = ln_fsp026comod
    and VCCOD = ln_fsp026cocod
    and VCCTA = ln_fsp026cocta
    and VCPAP = ln_fsp026copap
    and VCMDA = ln_fsp026comda
    AND VCFECH = ld_dfechini;
 if contadorfsd426 = 0 then
   INSERT INTO fsd426
     (VCPGCOD, VCMOD, VCCOD, VCCTA, VCPAP, VCMDA, VCFECH, VCFCHVTO)
   VALUES
     (ln_fsp026pgcod,
      ln_fsp026comod,
      ln_fsp026cocod,
      ln_fsp026cocta,
      ln_fsp026copap,
      ln_fsp026comda,
      ld_dfechini,
      ld_dfechcad);
   commit;
   select count(*)
     into contadorfsd426ins
     from fsd426
    where VCPGCOD = ln_fsp026pgcod
      and VCMOD = ln_fsp026comod
      and VCCOD = ln_fsp026cocod
      and VCCTA = ln_fsp026cocta
      and VCPAP = ln_fsp026copap
      and VCMDA = ln_fsp026comda
      AND VCFECH = ld_dfechini;
   if contadorfsd426ins = 1 then
     caso1 := 'S';
   else
     caso1 := 'N';
   end if;
 else
   caso1 := 'E';
 end if;
    ------------------------------------------------------------------------------------------------------------
    --------------------------------FSD026----------------------------------------------------------------------                                       
SELECT count(*)
  into contadorfsd026
  FROM fSD026
 where PGCOD = ln_fsp026pgcod
   and COMOD = ln_fsp026comod
   and COCOD = ln_fsp026cocod
   and COCTA = ln_fsp026cocta
   and COPAP = ln_fsp026copap
   and COMDA = ln_fsp026comda
   and COFECH = ld_dfechini
   and COMTO = ln_dmontohasta;
if contadorfsd026 = 0 then
  INSERT INTO fSD026
    (PGCOD,
     COMOD,
     COCOD,
     COCTA,
     COPAP,
     COMDA,
     COFECH,
     COMTO,
     COTASA,
     COMIN,
     COMAX,
     COIMP)
  VALUES
    (ln_fsp026pgcod,
     ln_fsp026comod,
     ln_fsp026cocod,
     ln_fsp026cocta,
     ln_fsp026copap,
     ln_fsp026comda,
     ld_dfechini,
     ln_dmontohasta,
     ln_fsd026cotasa,
     ln_fsd026comin,
     ln_fsd026comax,
     ln_coimp);
  commit;
  SELECT count(*)
    into contadorfsd026ins
    FROM fSD026
   where PGCOD = ln_fsp026pgcod
     and COMOD = ln_fsp026comod
     and COCOD = ln_fsp026cocod
     and COCTA = ln_fsp026cocta
     and COPAP = ln_fsp026copap
     and COMDA = ln_fsp026comda
     and COFECH = ld_dfechini
     and COMTO = ln_dmontohasta;
  if contadorfsd026ins = 1 then
    caso2 := 'S';
  else
    caso2 := 'N';
  end if;

else
  caso2 := 'E';
end if;

-------------------------------------------------------------------------------------------------------------------------------------  
    --------------------------------FSR026----------------------------------------------------------------------                                       
SELECT count(*)
  into contadorfsr026
  FROM FSR026
 where PGCOD = ln_fsp026pgcod
   and COMOD = ln_fsp026comod
   and COCOD = ln_fsp026cocod
   and COCTA = ln_fsp026cocta
   and COPAP = ln_fsp026copap
   and COMDA = ln_fsp026comda
   and COFECH = ld_dfechini;
if contadorfsr026 = 0 then

  --select 99999999-TO_NUMBER(REPLACE(TO_CHAR(ld_dfechini,'DD-MM-YYYY'),'-','')) into temp from dual;
  INSERT INTO fSr026
    (PGCOD, COMOD, COCOD, COCTA, COPAP, COMDA, COFECH, COFEIN, COVIG)
  VALUES
    (ln_fsp026pgcod,
     ln_fsp026comod,
     ln_fsp026cocod,
     ln_fsp026cocta,
     ln_fsp026copap,
     ln_fsp026comda,
     ld_dfechini,
     99999999 -
     TO_NUMBER(REPLACE(TO_CHAR(ld_dfechini, 'YYYY-MM-DD'), '-', '')),
     lc_fsr026covig);
  commit;
  SELECT count(*)
    into contadorfsr026ins
    FROM FSR026
   where PGCOD = ln_fsp026pgcod
     and COMOD = ln_fsp026comod
     and COCOD = ln_fsp026cocod
     and COCTA = ln_fsp026cocta
     and COPAP = ln_fsp026copap
     and COMDA = ln_fsp026comda
     and COFECH = ld_dfechini;
  if contadorfsr026ins = 1 then
    caso3 := 'S';
  else
    caso3 := 'N';
  end if;

else
  caso3 := 'E';
end if;

-------------------------------------------------------------------------------------------------------------------------------------  
--------------------------------FSP026----------------------------------------------------------------------                                       
SELECT count(*)
  into contadorfsp026
  FROM FSP026
 where PGCOD = ln_fsp026pgcod
   and COMOD = ln_fsp026comod
   and COCOD = ln_fsp026cocod
   and COCTA = ln_fsp026cocta
   and COPAP = ln_fsp026copap
   and COMDA = ln_fsp026comda
   and COFECH = ld_dfechini
   AND COMTO = ln_dmontohasta
   AND COPZO = ln_fsp026copzo; --99999
if contadorfsp026 = 0 then

  --select 99999999-TO_NUMBER(REPLACE(TO_CHAR(ld_dfechini,'DD-MM-YYYY'),'-','')) into temp from dual;
  INSERT INTO fSp026
    (PGCOD,
     COMOD,
     COCOD,
     COCTA,
     COPAP,
     COMDA,
     COFECH,
     COMTO,
     COPZO,
     COTASAP,
     COMINP,
     COMAXP,
     COIMPP)
  VALUES
    (ln_fsp026pgcod,
     ln_fsp026comod,
     ln_fsp026cocod,
     ln_fsp026cocta,
     ln_fsp026copap,
     ln_fsp026comda,
     ld_dfechini,
     ln_dmontohasta,
     ln_fsp026copzo,
     ln_dtasasob,
     ln_fsp026cominp,
     ln_fsp026comaxp,
     ln_fsp026coimpp);

  commit;
  SELECT count(*)
    into contadorfsp026ins
    FROM FSP026
   where PGCOD = ln_fsp026pgcod
     and COMOD = ln_fsp026comod
     and COCOD = ln_fsp026cocod
     and COCTA = ln_fsp026cocta
     and COPAP = ln_fsp026copap
     and COMDA = ln_fsp026comda
     and COFECH = ld_dfechini
     AND COMTO = ln_dmontohasta
     AND COPZO = ln_fsp026copzo; ---99999
  if contadorfsp026ins = 1 then
    caso4 := 'S';
  else
    caso4 := 'N';
  end if;

else
  caso4 := 'E';
end if;

-------------------------------------------------------------------------------------------------------------------------------------  
if caso1='S' and caso2='S' and caso3='S' and caso4='S' then
  lc_indicador:='S';
else
    if caso1='E' or caso2='E' or caso3='E' or caso4='E' then
        lc_indicador:='E';
    else
         ----------FSD426
         delete fsd426  where VCPGCOD=ln_fsp026pgcod and  VCMOD=ln_fsp026comod 
          and  VCCOD=ln_fsp026cocod and  VCCTA=ln_fsp026cocta and  VCPAP=ln_fsp026copap and VCMDA=ln_fsp026comda AND  VCFECH=ld_dfechini; 
        ---------------
        -----------FSD026
        delete fSD026  where PGCOD=ln_fsp026pgcod and  COMOD=ln_fsp026comod and  COCOD=ln_fsp026cocod 
        and  COCTA=ln_fsp026cocta and  COPAP=ln_fsp026copap and  COMDA=ln_fsp026comda and  COFECH=ld_dfechini and  COMTO=ln_dmontohasta;
        --------------
        --------fsr026
        delete FSR026  where PGCOD=ln_fsp026pgcod and  COMOD=ln_fsp026comod and  COCOD=ln_fsp026cocod 
        and  COCTA=ln_fsp026cocta and  COPAP=ln_fsp026copap and  COMDA=ln_fsp026comda and  COFECH=ld_dfechini ;
        --------------
          ------fsp026
        delete FSP026  where PGCOD=ln_fsp026pgcod and  COMOD=ln_fsp026comod and  COCOD=ln_fsp026cocod 
        and  COCTA=ln_fsp026cocta and  COPAP=ln_fsp026copap and  COMDA=ln_fsp026comda and  COFECH=ld_dfechini AND COMTO=ln_dmontohasta AND COPZO=ln_fsp026copzo;
          ------------
          commit;
          lc_indicador:='N';
    END IF;
end if;
END SP_INSERTAR_SOBREPRIMA;
----------------------------------------------------------------------------------------------------------
PROCEDURE SP_ELIMNAR_SOBREPRIMA(   ln_fsp026pgcod IN NUMBER,
                                          ln_fsp026comod IN NUMBER,
                                          ln_fsp026cocod IN NUMBER,
                                          ln_fsp026cocta IN NUMBER, 
                                          ln_fsp026copap IN NUMBER,
                                          ln_fsp026comda IN NUMBER,
                                          ld_dfechini IN date,
                                          ln_dmontohasta IN NUMBER,
                                          lc_indicador out varchar2)IS
  -- *****************************************************************
    -- Nombre                     : SP_CR_INSERT_JAQL406
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2017/09/20
    -- Autor de Creación          : Cristhian Cerpa
    -- Uso                        : elimina la sobre prima de las tablas de dlya
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :
    --                              ln_fsp026pgcod
    --                              ln_fsp026comod
    --                              ln_fsp026cocod
    --                              LN_JAQZ724MOD
    --                              ln_fsp026cocta
    --                              ln_fsp026copap
    --                              ln_fsp026comda      
    --                              ld_dfechini
    --                              ld_dfechcad      
    --                              ln_dmontohasta
    --                             

    -- Retorno                    :  lc_indicador Si se a eliminado  correctamente
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- *****************************************************************                                                                                    

  contarFSD426 number(10);
  contarfsd026 number(10);
    contarfsr026 number(10);
      contarfsp026 number(10);

  begin
     ----------FSD426
         delete fsd426  where VCPGCOD=ln_fsp026pgcod and  VCMOD=ln_fsp026comod 
          and  VCCOD=ln_fsp026cocod and  VCCTA=ln_fsp026cocta and  VCPAP=ln_fsp026copap and VCMDA=ln_fsp026comda AND  VCFECH=ld_dfechini; 
          select count(*) into contarFSD426 from fsd426  where VCPGCOD=ln_fsp026pgcod and  VCMOD=ln_fsp026comod 
          and  VCCOD=ln_fsp026cocod and  VCCTA=ln_fsp026cocta and  VCPAP=ln_fsp026copap and VCMDA=ln_fsp026comda AND  VCFECH=ld_dfechini; 
        ---------------
        -----------FSD026
        delete fSD026  where PGCOD=ln_fsp026pgcod and  COMOD=ln_fsp026comod and  COCOD=ln_fsp026cocod 
        and  COCTA=ln_fsp026cocta and  COPAP=ln_fsp026copap and  COMDA=ln_fsp026comda and  COFECH=ld_dfechini and  COMTO=ln_dmontohasta;
        SELECT COUNT(*) INTO contarfsd026 FROM  fSD026  where PGCOD=ln_fsp026pgcod and  COMOD=ln_fsp026comod and  COCOD=ln_fsp026cocod 
        and  COCTA=ln_fsp026cocta and  COPAP=ln_fsp026copap and  COMDA=ln_fsp026comda and  COFECH=ld_dfechini and  COMTO=ln_dmontohasta;        
        --------------
        --------fsr026
        delete FSR026  where PGCOD=ln_fsp026pgcod and  COMOD=ln_fsp026comod and  COCOD=ln_fsp026cocod 
        and  COCTA=ln_fsp026cocta and  COPAP=ln_fsp026copap and  COMDA=ln_fsp026comda and  COFECH=ld_dfechini ;
        
          SELECT COUNT(*) INTO contarfsr026 FROM  FSR026  where PGCOD=ln_fsp026pgcod and  COMOD=ln_fsp026comod and  COCOD=ln_fsp026cocod 
        and  COCTA=ln_fsp026cocta and  COPAP=ln_fsp026copap and  COMDA=ln_fsp026comda and  COFECH=ld_dfechini ;
        --------------
          ------fsp026
        delete FSP026  where PGCOD=ln_fsp026pgcod and  COMOD=ln_fsp026comod and  COCOD=ln_fsp026cocod 
        and  COCTA=ln_fsp026cocta and  COPAP=ln_fsp026copap and  COMDA=ln_fsp026comda and  COFECH=ld_dfechini AND COMTO=ln_dmontohasta AND COPZO=99999;
        SELECT COUNT(*) INTO contarfsp026 FROM FSP026  where PGCOD=ln_fsp026pgcod and  COMOD=ln_fsp026comod and  COCOD=ln_fsp026cocod 
        and  COCTA=ln_fsp026cocta and  COPAP=ln_fsp026copap and  COMDA=ln_fsp026comda and  COFECH=ld_dfechini AND COMTO=ln_dmontohasta AND COPZO=99999;
          ------------
          commit;
         IF contarFSD426=0 AND contarfsd026=0 AND contarfsr026=0 AND contarfsp026=0  THEN
           lc_indicador:='S';
           ELSE
           lc_indicador:='N';             
         END IF ;
          
  END SP_ELIMNAR_SOBREPRIMA;   
end PQ_CR_SOBREPRIMA;
/

