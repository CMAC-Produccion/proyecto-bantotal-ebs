CREATE OR REPLACE PACKAGE bk_pq_riesgo_unico_bt is
  -- *****************************************************************
  -- Nombre                       : PQ_CR_ADJUDICAR
  -- Sistema                      : SORFY
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 18/05/2007
  -- Autor de Creación            : yyampi
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Fecha de Modificación        : 
  -- Autor de Modificación        : 
  -- Descripción de Modificación  : 
  -- Descripción de Modificación  : 
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

   procedure SP_CR_RIESGO_UNICO(P_PERANO in varchar2, P_PERMES in varchar2);
   
   procedure SP_CLIENTE_CONYUGE(pa_perano number, pa_permes number);
   
   FUNCTION FN_CORRELATIVO(pa_perano number, pa_permes number)
     RETURN NUMBER;
     
     procedure SP_CLIENTE_AVAL(pa_perano number,
                             pa_permes number
                            );

procedure SP_CLIENTE_GRUPO1(pa_perano number,
                             pa_permes number
                            );
                            
procedure SP_CLIENTE_GRUPO2(pa_perano number,
                             pa_permes number
                            );

procedure SP_CLIENTE_GRUPO3(pa_perano number,
                             pa_permes number
                            );

procedure SP_CLIENTE_GRUPO4(pa_perano number,
                             pa_permes number
                            );

procedure SP_CLIENTE_GRUPO5(pa_perano number,
                             pa_permes number
                            );
                            
procedure SP_CLIENTE_GRUPO6(pa_perano number,
                            pa_permes number
                            );

PROCEDURE SP_JURIDICA_GRUPO1(pa_perano number, pa_permes number);

PROCEDURE SP_JURIDICA_GRUPO2(pa_perano number, pa_permes number) ;

PROCEDURE SP_JURIDICA_GRUPO3(pa_perano number, pa_permes number);

PROCEDURE SP_JURIDICA_GRUPO4(pa_perano number, pa_permes number) ;

PROCEDURE SP_JURIDICA_GRUPO5(pa_perano number, pa_permes number);

PROCEDURE SP_JURIDICA_GRUPO6(pa_perano number, pa_permes number);                                                                                                                                                                                                    

end bk_pq_riesgo_unico_bt;
/

CREATE OR REPLACE PACKAGE BODY bk_pq_riesgo_unico_bt is

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure SP_CR_RIESGO_UNICO(P_PERANO in varchar2,
                                    P_PERMES in varchar2
                                    ) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_GRUPOS_ECONOMICOS
    -- Sistema                    : SORFY
    -- Módulo                     : Créditos
    -- Versión                    : 
    -- Fecha de Creación          : 
    -- Autor de Creación          : yyampi
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_PERANO ( año del proceso )
    --                              P_PERMES ( mes del proceso )                            
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- Descripción de Modificación: 
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Crédito.   
    
     
  begin
  
--  DELETE JAQY055 T WHERE T.JAQY055PERANO = P_PERANO AND T.JAQY055PERMES = P_PERMES;
  
  --SP_CLIENTE_CONYUGE(P_PERANO,P_PERMES);
  --SP_CLIENTE_AVAL(P_PERANO,P_PERMES);
  
  --SP_CLIENTE_GRUPO1(P_PERANO,P_PERMES);
  --  SP_CLIENTE_GRUPO2(P_PERANO,P_PERMES);
  --  SP_CLIENTE_GRUPO3(P_PERANO,P_PERMES);
  -- SP_CLIENTE_GRUPO4(P_PERANO,P_PERMES);
  --SP_CLIENTE_GRUPO5(P_PERANO,P_PERMES);
  --SP_CLIENTE_GRUPO6(P_PERANO,P_PERMES);
  --SP_JURIDICA_GRUPO1(P_PERANO,P_PERMES);
  --SP_JURIDICA_GRUPO2(P_PERANO,P_PERMES);
  --SP_JURIDICA_GRUPO3(P_PERANO,P_PERMES);
  --SP_JURIDICA_GRUPO4(P_PERANO,P_PERMES);
  --SP_JURIDICA_GRUPO6(P_PERANO,P_PERMES);
  SP_JURIDICA_GRUPO5(P_PERANO,P_PERMES);
  
  COMMIT;
  
  exception when others then 
    dbms_output.put_line('SP_CR_RIESGO_UNICO '||sqlerrm);
    rollback;
  
  end ;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure SP_CLIENTE_CONYUGE(pa_perano number,
                             pa_permes number
                            ) IS
  -- *****************************************************************
  -- Nombre                     : SP_INT_COMUN
  -- Sistema                    : SORFY
  -- Módulo                     : Créditos
  -- Versión                    : 
  -- Fecha de Creación          : 
  -- Autor de Creación          : yyampi
  -- Uso                        : formacion de grupos
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :                           
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- Descripción de Modificación: 
  -- *****************************************************************                        

cursor cur_clientec is 
SELECT pa_perano, pa_permes, a.pfpais, a.pftdoc, a.pfndoc , '' tipo , b.rppais , b.rptdoc, b.rpndoc
  FROM fsd002 a , fsr002 b
 where ( b.pepais = a.pfpais
           and b.petdoc = a.pftdoc
           and b.pendoc = a.pfndoc
           and b.rpccyg in (66))
   and exists (SELECT 1
          FROM fsr008 t, fsd010 r
         where t.pgcod = r.pgcod
           and t.ctnro = r.aocta
           and a.pfpais = t.pepais
           and a.pftdoc = t.petdoc
           and a.pfndoc = t.pendoc
           and r.aostat <> 99); 
           
ln_coor number(15);

BEGIN


  ln_coor := FN_CORRELATIVO(pa_perano,pa_permes);

  for rec_clientec in cur_clientec loop
    --ln_coor := FN_CORRELATIVO(pa_perano,pa_permes);
    ln_coor := ln_coor +1;
    insert into jaqy055
      (jaqy055perano,
       jaqy055permes,
       jaqy055corr,
       jaqy055pais,
       jaqy055tdoc,
       jaqy055ndoc,
       jaqy055tipo,
       jaqy055tipe,
       jaqy055paiv,
       jaqy055tdov,
       jaqy055ndov
       )
    values
      (rec_clientec.pa_perano,
       rec_clientec.pa_permes,
       ln_coor,
       rec_clientec.pfpais,
       rec_clientec.pftdoc,
       rec_clientec.pfndoc,
       rec_clientec.tipo,
       'F',
       rec_clientec.rppais,
       rec_clientec.rptdoc,
       rec_clientec.rpndoc);
       
        
  end loop;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('SP_CLIENTE_CONYUGE ' || SQLERRM);
END;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure SP_CLIENTE_AVAL(pa_perano number,
                             pa_permes number
                            ) IS
  -- *****************************************************************
  -- Nombre                     : SP_INT_COMUN
  -- Sistema                    : SORFY
  -- Módulo                     : Créditos
  -- Versión                    : 
  -- Fecha de Creación          : 
  -- Autor de Creación          : yyampi
  -- Uso                        : formacion de grupos
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :                           
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- Descripción de Modificación: 
  -- *****************************************************************                        

cursor cur_clientec is 

SELECT distinct aval.pa_perano, aval.pa_permes, aval.pfpais, aval.pftdoc, aval.pfndoc , aval.tipo , rel.pepais , rel.petdoc, rel.pendoc FROM (
SELECT distinct pa_perano pa_perano, pa_permes pa_permes, a.pfpais, a.pftdoc, a.pfndoc , 'H' TIPO  ,  r.sng001inst 
  FROM fsd002 a , fsr008 t, sng003 r  
 where ( t.pgcod = r.sng003pgc
           and t.ctnro = r.sng003cta
           and t.pepais = a.pfpais
           and t.petdoc = a.pftdoc
           and t.pendoc = a.pfndoc
           and t.ttcod = 1           
           )
   and exists (SELECT 1
          FROM fsr008 t, fsd010 r
         where t.pgcod = r.pgcod
           and t.ctnro = r.aocta
           and a.pfpais = t.pepais
           and a.pftdoc = t.petdoc
           and a.pfndoc = t.pendoc
           and t.ttcod = 1
           and r.aostat <> 99)) aval , xwf700 cred , fsr008 rel  , fsd010 ope        
           where cred.xwfprcins = aval.sng001inst  
           and (ope.pgcod = cred.xwfempresa and ope.aomod = cred.xwfmodulo and ope.aosuc = cred.xwfsucursal 
           and ope.aomda = cred.xwfmoneda and ope.aopap = cred.xwfmoneda and ope.aocta = cred.xwfcuenta
           and ope.aooper = cred.xwfoperacion and ope.aosbop = cred.xwfsubope and ope.aotope = cred.xwftipope )         
           and ope.aostat <> 99
           and rel.ctnro = cred.xwfcuenta           
           and exists (SELECT 1
              FROM fsr008 t, fsd010 r
             where t.pgcod = r.pgcod
               and t.ctnro = r.aocta
               and rel.pepais = t.pepais
               and rel.petdoc = t.petdoc
               and rel.pendoc = t.pendoc
               and t.ttcod = 1
               and r.aostat <> 99)
               ;

           
ln_coor number(15);

BEGIN

  
  ln_coor := FN_CORRELATIVO(pa_perano,pa_permes);


  for rec_clientec in cur_clientec loop
    --ln_coor := FN_CORRELATIVO(pa_perano,pa_permes);
    ln_coor := ln_coor + 1;
    insert into jaqy055
      (jaqy055perano,
       jaqy055permes,
       jaqy055corr,
       jaqy055pais,
       jaqy055tdoc,
       jaqy055ndoc,
       jaqy055tipo,
       jaqy055tipe,
       jaqy055paiv,
       jaqy055tdov,
       jaqy055ndov )
    values
      (rec_clientec.pa_perano,
       rec_clientec.pa_permes,
       ln_coor,
       rec_clientec.pepais, 
       rec_clientec.petdoc, 
       rec_clientec.pendoc,  
       rec_clientec.tipo,
       'F',
       rec_clientec.pfpais,
       rec_clientec.pftdoc,
       rec_clientec.pfndoc  );
       
  end loop;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('SP_CLIENTE_CONYUGE ' || SQLERRM);
END;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure SP_CLIENTE_GRUPO1(pa_perano number,
                             pa_permes number
                            ) IS
  -- *****************************************************************
  -- Nombre                     : SP_CLIENTE_GRUPO1
  -- Sistema                    : SORFY
  -- Módulo                     : Créditos
  -- Versión                    : 
  -- Fecha de Creación          : 
  -- Autor de Creación          : yyampi
  -- Uso                        : formacion de grupos
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :                           
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- Descripción de Modificación: 
  -- *****************************************************************                        

cursor cur_clientec is 
SELECT distinct dat.pa_perano,
dat.pa_permes,
dat.pfpais pfpaisv,
dat.pftdoc pftdocv,
dat.pfndoc pfndocv,
dat.tipo,
pef.pfpais ,
pef.pftdoc , 
pef.pfndoc     FROM 
(
SELECT pa_perano , pa_permes , r.pfpais, r.pftdoc, r.pfndoc , 'B' TIPO , t.pjpais, t.pjtdoc, t.pjndoc
  FROM fsr003 t, fsd002 r
 where r.pfpais = t.pfpai1
   and r.pftdoc = t.pftdo1
   and r.pfndoc = t.pfndo1
   and t.vicod in (1,8,9,10,11,12,13,29,30,31,32,33,34,35,36,37,38,49,50,51,52,53,54,55,56,57,58,83,84)
   and nvl(t.pfpart,0) >= 4
   and exists (SELECT 1
          FROM fsr008 a, fsd010 b
         where a.pgcod = b.pgcod
           and a.ctnro = b.aocta
           and r.pfpais = a.pepais
           and r.pftdoc = a.petdoc
           and r.pfndoc = a.pendoc
           and b.aostat <> 99) ) dat , Fsd002 pef , fsr003 rel where 
           pef.pfpais= rel.pfpai1 and
           pef.pftdoc= rel.pftdo1 and
           pef.pfndoc= rel.pfndo1 and
           dat.pjpais = rel.pjpais and
           dat.pjtdoc = rel.pjtdoc and
           dat.pjndoc = rel.pjndoc and
           rel.vicod in (9,35,33,34,84,32,13,55,53,52,21,19,20,22,14,45,43,44,4,33,10,37,36,29,55,54,57,49,51,19,24,23,25,15,43,47,46,40,86,2,8,14,15,16,17,18,29,30,32,39,40,41,42,58,83,6,8,11,12,13,17,21,24,26,28,35,37,42,45,47,48,5,11,16,20,23,26,27,30,31,34,36,41,44,46,48,50)
           and ( dat.pfpais <> pef.pfpais or dat.pftdoc <> pef.pftdoc or dat.pfndoc <> pef.pfndoc  )
           
           ;  
/*
SELECT pa_perano, pa_permes, r.pfpais, r.pftdoc, r.pfndoc , 'B' TIPO 
  FROM fsr003 t, fsd002 r
 where r.pfpais = t.pfpai1
   and r.pftdoc = t.pftdo1
   and r.pfndoc = t.pfndo1
   and t.vicod in (9,35,33,34,84,32,13,55,53,52,21,19,20,22,14,45,43,44,4,33,10,37,36,29,55,54,57,49,51,19,24,23,25,15,43,47,46,40,86,2,8,14,15,16,17,18,29,30,32,39,40,41,42,58,83,6,8,11,12,13,17,21,24,26,28,35,37,42,45,47,48,5,11,16,20,23,26,27,30,31,34,36,41,44,46,48,50)
   and nvl(t.pfpart,0) >= 4
   and exists (SELECT 1
          FROM fsr008 a, fsd010 b
         where a.pgcod = b.pgcod
           and a.ctnro = b.aocta
           and r.pfpais = a.pepais
           and r.pftdoc = a.petdoc
           and r.pfndoc = a.pendoc
           and b.aostat <> 99);*/
           
ln_coor number(15);

BEGIN

  ln_coor := FN_CORRELATIVO(pa_perano,pa_permes);
 

  for rec_clientec in cur_clientec loop
    --ln_coor := FN_CORRELATIVO(pa_perano,pa_permes);
    ln_coor := ln_coor +1;
    insert into jaqy055
      (jaqy055perano,
       jaqy055permes,
       jaqy055corr,
       jaqy055pais,
       jaqy055tdoc,
       jaqy055ndoc,
       jaqy055tipo,
       jaqy055tipe,
       jaqy055paiv,
       jaqy055tdov,
       jaqy055ndov
       )
    values
      (rec_clientec.pa_perano,
       rec_clientec.pa_permes,
       ln_coor,
       rec_clientec.pfpais,
       rec_clientec.pftdoc,
       rec_clientec.pfndoc,
       rec_clientec.tipo,
       'F',
       rec_clientec.pfpaisv,
       rec_clientec.pftdocv,
       rec_clientec.pfndocv);
       
  end loop;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('SP_CLIENTE_GRUPO1 ' || SQLERRM);
END;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure SP_CLIENTE_GRUPO2(pa_perano number,
                             pa_permes number
                            ) IS
  -- *****************************************************************
  -- Nombre                     : SP_CLIENTE_GRUPO1
  -- Sistema                    : SORFY
  -- Módulo                     : Créditos
  -- Versión                    : 
  -- Fecha de Creación          : 
  -- Autor de Creación          : yyampi
  -- Uso                        : formacion de grupos
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :                           
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- Descripción de Modificación: 
  -- *****************************************************************                        

cursor cur_clientec is 
SELECT pa_perano, pa_permes,  t.pjpais , t.pjtdoc, t.pjndoc, 'M' TIPO, r.pfpais, r.pftdoc, r.pfndoc    
  FROM fsr003 t, fsd002 r
 where r.pfpais = t.pfpai1
   and r.pftdoc = t.pftdo1
   and r.pfndoc = t.pfndo1
   and t.vicod in (9,35,33,34,84,32,13,55,53,52,21,19,20,22,14,45,43,44,4,33,10,37,36,29,54,57,49,51,19,24,23,25,15,43,47,46,40,86,2,83,8,32,29,30,58,17,14,15,16,18,42,39,40,41)
   --and nvl(t.pfpart,0) >= 4
   and exists (SELECT 1  --si existe como grupo economico
          FROM JAQY052 a
         where a.jaqy052pais = r.pfpais 
           and a.jaqy052tdoc = r.pftdoc           
           and a.jaqy052ndoc = r.pfndoc
           )
   and exists (SELECT 1  --si existe como grupo economico
          FROM JAQY052 a
         where a.jaqy052pais = t.pjpais
           and a.jaqy052tdoc = t.pjtdoc         
           and a.jaqy052ndoc = t.pjndoc           
           )        
   and exists (SELECT 1
          FROM fsr008 a, fsd010 b
         where a.pgcod = b.pgcod
           and a.ctnro = b.aocta
           and r.pfpais = a.pepais
           and r.pftdoc = a.petdoc
           and r.pfndoc = a.pendoc
           and b.aostat <> 99);
/*
SELECT pa_perano, pa_permes, r.pfpais, r.pftdoc, r.pfndoc , 'M' TIPO,  
  FROM fsr003 t, fsd002 r
 where r.pfpais = t.pfpai1
   and r.pftdoc = t.pftdo1
   and r.pfndoc = t.pfndo1
   and t.vicod in (9,35,33,34,84,32,13,55,53,52,21,19,20,22,14,45,43,44,4,33,10,37,36,29,54,57,49,51,19,24,23,25,15,43,47,46,40,86)
   and nvl(t.pfpart,0) >= 4
   and exists (SELECT 1  --si existe como grupo economico
          FROM JAQY052 a
         where a.jaqy052pais = r.pfpais 
           and a.jaqy052tdoc = r.pftdoc           
           and a.jaqy052ndoc = r.pfndoc
           )
   and exists (SELECT 1
          FROM fsr008 a, fsd010 b
         where a.pgcod = b.pgcod
           and a.ctnro = b.aocta
           and r.pfpais = a.pepais
           and r.pftdoc = a.petdoc
           and r.pfndoc = a.pendoc
           and b.aostat <> 99);*/
           
ln_coor number(15);

BEGIN

  ln_coor := FN_CORRELATIVO(pa_perano,pa_permes);

  for rec_clientec in cur_clientec loop
    --ln_coor := FN_CORRELATIVO(pa_perano,pa_permes);
    ln_coor := ln_coor +1 ;
    insert into jaqy055
      (jaqy055perano,
       jaqy055permes,
       jaqy055corr,
       jaqy055pais,
       jaqy055tdoc,
       jaqy055ndoc,
       jaqy055tipo,
       jaqy055tipe,
       jaqy055paiv,
       jaqy055tdov,
       jaqy055ndov
       )
    values
      (rec_clientec.pa_perano,
       rec_clientec.pa_permes,
       ln_coor,
       rec_clientec.pfpais,
       rec_clientec.pftdoc,
       rec_clientec.pfndoc,
       rec_clientec.tipo,
       'J',
       rec_clientec.pjpais ,
       rec_clientec.pjtdoc ,
       rec_clientec.pjndoc  
       );
       
  end loop;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('SP_CLIENTE_GRUPO2 ' || SQLERRM);
END;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure SP_CLIENTE_GRUPO3(pa_perano number,
                             pa_permes number
                            ) IS
  -- *****************************************************************
  -- Nombre                     : SP_CLIENTE_GRUPO1
  -- Sistema                    : SORFY
  -- Módulo                     : Créditos
  -- Versión                    : 
  -- Fecha de Creación          : 
  -- Autor de Creación          : yyampi
  -- Uso                        : formacion de grupos
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :                           
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- Descripción de Modificación: 
  -- *****************************************************************                        

cursor cur_clientec is 
SELECT pa_perano, pa_permes,  t.pjpais, t.pjtdoc, t.pjndoc,  'L' TIPO  , r.pfpais, r.pftdoc, r.pfndoc
/*buscar en personas pj a los clientes que tengan cargo de presidente , director, gerente, asesor principal y funcionario*/ 
  FROM fsr003 t, fsd002 r
 where r.pfpais = t.pfpai1
   and r.pftdoc = t.pftdo1
   and r.pfndoc = t.pfndo1
   and t.vicod in (9,35,33,34,84,32,13,55,53,52,21,19,20,22,14,45,43,44,4,33,10,37,36,29,55,54,57,49,51,19,24,23,25,15,43,47,46,40,86,2,8,14,15,16,17,18,29,30,32,39,40,41,42,58,83,6,8,11,12,13,17,21,24,26,28,35,37,42,45,47,48,5,11,16,20,23,26,27,30,31,34,36,41,44,46,48,50)
   --and nvl(t.pfpart,0) >= 4
   and exists (SELECT 1
          FROM fsr008 a, fsd010 b
         where a.pgcod = b.pgcod
           and a.ctnro = b.aocta
           and r.pfpais = a.pepais
           and r.pftdoc = a.petdoc
           and r.pfndoc = a.pendoc
           and b.aostat <> 99)
   and not exists (   
   /***************************/
       
select 1 from 
 (SELECT   pa_perano,  pa_permes,  t.pjpais , t.pjtdoc, t.pjndoc, 'M' TIPO, r.pfpais, r.pftdoc, r.pfndoc    
         FROM fsr003 t,fsd002 r
        where r.pfpais = t.pfpai1
          and r.pftdoc = t.pftdo1
          and r.pfndoc = t.pfndo1
              and t.vicod in (9,35,33,34,84,32,13,55,53,52,21,19,20,22,14,45,43,44,4,33,10,37,36,29,54,57,49,51,19,24,23,25,15,43,47,46,40,86,2,83,8,32,29,30,58,17,14,15,16,18,42,39,40,41)            
          and exists (SELECT 1 --si existe como grupo economico
                 FROM JAQY052 a
                where a.jaqy052pais = r.pfpais
                  and a.jaqy052tdoc = r.pftdoc
                  and a.jaqy052ndoc = r.pfndoc)
          and exists (SELECT 1 --si existe como grupo economico
                 FROM JAQY052 a
                where a.jaqy052pais = t.pjpais
                  and a.jaqy052tdoc = t.pjtdoc
                  and a.jaqy052ndoc = t.pjndoc)
          and exists (SELECT 1
                 FROM fsr008 a,fsd010 b
                where a.pgcod = b.pgcod
                  and a.ctnro = b.aocta
                  and r.pfpais = a.pepais
                  and r.pftdoc = a.petdoc
                  and r.pfndoc = a.pendoc
                  and b.aostat <> 99)) dat1 where 
                  
                  dat1.pfpais = r.pfpais
                  and dat1.pftdoc = r.pftdoc
                  and dat1.pfndoc = r.pfndoc
                  and dat1.pjpais = t.pjpais
                  and dat1.pjtdoc = t.pjtdoc
                  and dat1.pjndoc = t.pjndoc                  
                   );      
   /***************************/
   
   
   /*    SELECT * FROM jaqy055 w where 
       w.jaqy055pais = r.pfpais
       and w.jaqy055tdoc = r.pftdoc
       and w.jaqy055ndoc = r.pfndoc
       and w.jaqy055perano = pa_perano
       and w.jaqy055permes = pa_permes
       and w.jaqy055tipe= 'M');*/
           
ln_coor number(15);

BEGIN

        ln_coor := FN_CORRELATIVO(pa_perano,pa_permes);

  for rec_clientec in cur_clientec loop
    ln_coor := ln_coor +1;
    insert into jaqy055
      (jaqy055perano,
       jaqy055permes,
       jaqy055corr,
       jaqy055pais,
       jaqy055tdoc,
       jaqy055ndoc,
       jaqy055tipo,
       jaqy055tipe,
       jaqy055paiv,
       jaqy055tdov,
       jaqy055ndov
       )
    values
      (rec_clientec.pa_perano,
       rec_clientec.pa_permes,
       ln_coor,
       rec_clientec.pfpais,
       rec_clientec.pftdoc,
       rec_clientec.pfndoc,
       rec_clientec.tipo,
       'F',
       rec_clientec.pjpais,
       rec_clientec.pjtdoc,
       rec_clientec.pjndoc 
       );
       
  end loop;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('SP_CLIENTE_GRUPO3 ' || SQLERRM);
END;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure SP_CLIENTE_GRUPO4(pa_perano number,
                             pa_permes number
                            ) IS
  -- *****************************************************************
  -- Nombre                     : SP_CLIENTE_GRUPO4
  -- Sistema                    : SORFY
  -- Módulo                     : Créditos
  -- Versión                    : 
  -- Fecha de Creación          : 
  -- Autor de Creación          : yyampi
  -- Uso                        : formacion de grupos
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :                           
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- Descripción de Modificación: 
  -- *****************************************************************   
  
  cursor garantias  is 
    SELECT distinct t.r2mod, t.r2cta, t.r2oper, t.r2sbop, t.r2cod, t.r2suc, t.r2mda, t.r2pap , t.r2tope, count(*)
        FROM fsr011 t , fsr008 a, fsd010  b where t.r1cod = a.pgcod 
        and t.r1cta = a.ctnro 
        and t.relcod = 50
        and t.r1cod = b.pgcod
        and t.r1mod = b.aomod
        and t.r1suc = b.aosuc
        and t.r1mda = b.aomda
        and t.r1pap = b.aopap
        and t.r1cta = b.aocta
        and t.r1sbop = b.aosbop
        and t.r1tope = b.aotope
        and t.r1oper = b.aooper
        and b.aostat <> 99
        --and t.r1cta <> t.r2cta
        and  (SELECT count(*) FROM fsr008 r where r.ctnro = a.ctnro and r.ttcod =1   ) > 1
        group by t.r2mod, t.r2cta, t.r2oper, t.r2sbop, t.r2cod, t.r2suc, t.r2mda, t.r2pap , t.r2tope        
        having count(*) > 1;
        

  cursor integrantes(pa_r2mod in number, pa_r2cta in number, pa_r2oper in number, pa_r2sbop in number, 
  pa_r2cod in number, pa_r2suc in number, pa_r2mda in number, pa_r2pap in number, pa_r2tope in number) is          
  SELECT DISTINCT a.pepais , a.petdoc, a.pendoc
  FROM fsr008 a,
       (SELECT distinct t.r2cta, t.r1cta   --, (SELECT count(*) FROM fsr008 a where a.ctnro = t.r1cta )  
          from fsr011 t, fsd010 s
         where relcod = 50
           and s.pgcod = t.r1cod
           and t.r1mod = s.aomod
           and t.r1suc = s.aosuc
           and t.r1mda = s.aomda
           and t.r1pap = s.aopap
           and t.r1cta = s.aocta
           and t.r1oper = s.aooper
           and t.r1sbop = s.aosbop
           and t.r1tope = s.aotope
           and s.aostat <> 99
           and t.r2mod =  pa_r2mod
           and t.r2cta =  pa_r2cta
           and t.r2oper = pa_r2oper
           and t.r2sbop = pa_r2sbop
           and t.r2cod =  pa_r2cod
           and t.r2suc =  pa_r2suc
           and t.r2mda =  pa_r2mda
           and t.r2pap =  pa_r2pap
           and t.r2tope = pa_r2tope                         
         group by t.r2cta, t.r1cta) dat
 where a.ctnro = dat.r1cta
 and a.ttcod = 1 ;
                      
 cursor cur_clientec(
 pa_r2mod in number, pa_r2cta in number, pa_r2oper in number, pa_r2sbop in number, 
  pa_r2cod in number, pa_r2suc in number, pa_r2mda in number, pa_r2pap in number, pa_r2tope in number,
  pa_pais number, pa_tdoc number, pa_ndoc varchar2
 ) is  
 SELECT distinct a.pepais, a.petdoc, a.pendoc, 'I' tipo, pa_pais pfpais, pa_tdoc pftdoc, pa_ndoc pfndoc
         FROM fsr008 a,
       (SELECT distinct t.r2cta, t.r1cta   --, (SELECT count(*) FROM fsr008 a where a.ctnro = t.r1cta )  
          from fsr011 t, fsd010 s
         where relcod = 50
           and s.pgcod = t.r1cod
           and t.r1mod = s.aomod
           and t.r1suc = s.aosuc
           and t.r1mda = s.aomda
           and t.r1pap = s.aopap
           and t.r1cta = s.aocta
           and t.r1oper = s.aooper
           and t.r1sbop = s.aosbop
           and t.r1tope = s.aotope
           and s.aostat <> 99
           and t.r2mod =  pa_r2mod
           and t.r2cta =  pa_r2cta
           and t.r2oper = pa_r2oper
           and t.r2sbop = pa_r2sbop
           and t.r2cod =  pa_r2cod
           and t.r2suc =  pa_r2suc
           and t.r2mda =  pa_r2mda
           and t.r2pap =  pa_r2pap
           and t.r2tope = pa_r2tope         
                                   
         group by t.r2cta, t.r1cta ) dat
         where a.ctnro = dat.r1cta
          and (a.pepais <> pa_pais
          or a.petdoc <> pa_tdoc 
          or a.pendoc <> pa_ndoc)
          and a.ttcod = 1;
 
/*
cursor cur_clientec is 
SELECT distinct ab.pepais,ab.petdoc, ab.pendoc, ab.tipo, xt.pfpais , xt.pftdoc, xt.pfndoc      FROM 
 (SELECT distinct t.pfpais, t.pftdoc, t.pfndoc, r.ctnro
   FROM fsd002 t, fsr008 r
  where t.pfpais = r.pepais
    and t.pftdoc = r.petdoc
    and t.pfndoc = r.pendoc    
    and ((SELECT count(*)
           FROM fsr008 a
          where( a.pepais <> r.pepais
            or a.petdoc <> r.petdoc
            or a.pendoc <> r.pendoc)
            and a.ctnro = r.ctnro) > 1)            
    and exists (SELECT 1
          FROM fsr008 a, fsd010 b
         where a.pgcod = b.pgcod
           and a.ctnro = b.aocta
           and t.pfpais = a.pepais
           and t.pftdoc = a.petdoc
           and t.pfndoc = a.pendoc
           and b.aostat <> 99)) xt,

(SELECT a.pepais, a.petdoc, a.pendoc, 'I' tipo , dat.r1cta , dat.r2cta
  FROM fsr008 a,
       (SELECT distinct t.r2cta, t.r1cta --, (SELECT count(*) FROM fsr008 a where a.ctnro = t.r1cta )  
          from fsr011 t, fsd010 s
         where relcod = 50
           and s.pgcod = t.r1cod
           and t.r1mod = s.aomod
           and t.r1suc = s.aosuc
           and t.r1mda = s.aomda
           and t.r1pap = s.aopap
           and t.r1cta = s.aocta
           and t.r1oper = s.aooper
           and t.r1sbop = s.aosbop
           and t.r1tope = s.aotope
           and s.aostat <> 99
        --   and pa_ncta = t.r1cta
        --and (r.pepais <> 604 or r.petdoc <> 21 or r.pendoc <> '29581478' ) and t.r2cta =  ) 
         group by t.r2cta, t.r1cta) dat
 where a.ctnro = dat.r2cta )  ab where ab.r1cta =xt.ctnro and (ab.pepais <> xt.pfpais or ab.petdoc <> xt.pftdoc or ab.pendoc <> pfndoc );
 */


/*
SELECT distinct pa_perano, pa_permes, b.pepais pfpais , b.petdoc pftdoc, b.pendoc pfndoc , 'I' TIPO  
 FROM ( 
 SELECT  t.r2cta , t.r1cta , count(*) from fsr011 t , fsd010 s  where relcod = 50
 and s.pgcod = t.r1cod
    and t.r1mod = s.aomod
    and t.r1suc = s.aosuc
    and t.r1mda = s.aomda
    and t.r1pap = s.aopap
    and t.r1cta = s.aocta
    and t.r1oper = s.aooper
    and t.r1sbop = s.aosbop
    and t.r1tope = s.aotope
    and s.aostat <> 99
 group by t.r2cta , t.r1cta 
 having count(*) > 1) a , fsr008 b , fsd002 c  where 
 a.r1cta = b.ctnro
 and c.pfpais = b.pepais
 and c.pftdoc = b.petdoc
 and c.pfndoc = b.pendoc
 and b.ttcod = 1 ;*/
           
ln_coor number(15);
counter number(17);

BEGIN

--dat.r1mod , dat.r1cta, dat.r1oper, dat.r1sbop, dat.r1cod, dat.r1suc, dat.r1mda, dat.r1pap, dat.r1tope

   ln_coor := FN_CORRELATIVO(pa_perano,pa_permes);         

  for gar_cur in garantias loop  
      for int_cur in integrantes(gar_cur.r2mod,gar_cur.r2cta,gar_cur.r2oper,gar_cur.r2sbop,gar_cur.r2cod,
        gar_cur.r2suc,gar_cur.r2mda,gar_cur.r2pap,gar_cur.r2tope) loop
                                                                                                                                                                                     
           for rec_clientec in cur_clientec(
             gar_cur.r2mod,gar_cur.r2cta,gar_cur.r2oper,gar_cur.r2sbop,gar_cur.r2cod,
             gar_cur.r2suc,gar_cur.r2mda,gar_cur.r2pap,gar_cur.r2tope,
              int_cur.pepais , int_cur.petdoc , int_cur.pendoc
             )loop             
              --ln_coor := FN_CORRELATIVO(pa_perano,pa_permes);
              ln_coor := ln_coor +1;
              
              select COUNT(*) INTO counter  FROM jaqy055 T WHERE 
              T.JAQY055PERANO = pa_perano
              AND T.JAQY055PERMES = pa_permes 
              AND T.JAQY055PAIS = rec_clientec.pfpais
              AND T.JAQY055TDOC = rec_clientec.pftdoc              
              AND T.JAQY055NDOC = rec_clientec.pfndoc
              AND T.JAQY055TIPO = 'I'
              AND T.JAQY055PAIV = rec_clientec.pepais
              AND T.JAQY055TDOV = rec_clientec.petdoc
              AND T.JAQY055NDOV = rec_clientec.pendoc;
               
              
              if counter = 0 then 
              
                insert into jaqy055
                  (jaqy055perano,
                   jaqy055permes,
                   jaqy055corr,
                   jaqy055pais,
                   jaqy055tdoc,
                   jaqy055ndoc,
                   jaqy055tipo,
                   jaqy055tipe,
                   jaqy055paiv,
                   jaqy055tdov,
                   jaqy055ndov
                   )
                values
                  (pa_perano,
                   pa_permes,
                   ln_coor,
                   rec_clientec.pfpais,
                   rec_clientec.pftdoc,
                   rec_clientec.pfndoc, 
                   rec_clientec.tipo,
                   'F',
                   rec_clientec.pepais, 
                   rec_clientec.petdoc, 
                   rec_clientec.pendoc );     
                commit;
              end if;
              
              
              end loop;        
        end loop;
  end loop;


  /*for rec_clientec in cur_clientec loop
       ln_coor := FN_CORRELATIVO(pa_perano,pa_permes);
        insert into jaqy055
          (jaqy055perano,
           jaqy055permes,
           jaqy055corr,
           jaqy055pais,
           jaqy055tdoc,
           jaqy055ndoc,
           jaqy055tipo,
           jaqy055tipe,
           jaqy055paiv,
           jaqy055tdov,
           jaqy055ndov
           )
        values
          (pa_perano,
           pa_permes,
           ln_coor,
           rec_clientec.pepais,
           rec_clientec.petdoc,
           rec_clientec.pendoc,
           rec_clientec.tipo,
           'F',
           rec_clientec.pfpais,
           rec_clientec.pftdoc,
           rec_clientec.pfndoc);     
  end loop;*/

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('SP_CLIENTE_GRUPO4 ' || SQLERRM);
END;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure SP_CLIENTE_GRUPO5(pa_perano number,
                             pa_permes number
                            ) IS
  -- *****************************************************************
  -- Nombre                     : SP_CLIENTE_GRUPO5
  -- Sistema                    : SORFY
  -- Módulo                     : Créditos
  -- Versión                    : 
  -- Fecha de Creación          : 
  -- Autor de Creación          : yyampi
  -- Uso                        : formacion de grupos
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :                           
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- Descripción de Modificación: 
  -- *****************************************************************                        

cursor cur_clientec is 
SELECT ab.pa_perano, ab.pa_permes, ab.pfpais, ab.pftdoc , ab.pfndoc , ab.tipo , ac.pfpai1 , ac.pftdo1 , ac.pfndo1 FROM 
(SELECT distinct  pa_perano,  pa_permes, d.pfpai1 pfpais , d.pftdo1 pftdoc, d.pfndo1 pfndoc , 
   d.pjpais , d.pjtdoc , d.pjndoc
 , 'B' TIPO  
   FROM fsr003 d where 
  d.vicod in (9,35,33,34,84,32,13,55,53,52,21,19,20,22,14,45,43,44,4,33,10,37,36,29,55,54,57,49,51,19,24,23,25,15,43,47,46,40,86,2,8,14,15,16,17,18,29,30,32,39,40,41,42,58,83,6,8,11,12,13,17,21,24,26,28,35,37,42,45,47,48,5,11,16,20,23,26,27,30,31,34,36,41,44,46,48,50)
  ) ab,    
  (SELECT distinct t.pjpais , t.pjtdoc, t.pjndoc , t.pfpai1, t.pftdo1, t.pfndo1 FROM fsr003 t where t.pfpart >= 4 -- 
 and exists (SELECT 1
          FROM fsr008 a, fsd010 b
         where a.pgcod = b.pgcod
           and a.ctnro = b.aocta
           and t.pfpai1 = a.pepais
           and t.pftdo1 = a.petdoc
           and t.pfndo1 = a.pendoc
           and a.ttcod = 1
           and b.aostat <> 99)
  and t.vicod in (1,8,9,10,11,12,13,29,30,31,32,33,34,35,36,37,38,49,50,51,52,53,54,55,56,57,58,83,84)) ac
  where ab.pjpais = ac.pjpais 
  and ab.pjtdoc = ac.pjtdoc
  and ab.pjndoc = ac.pjndoc  
  and ( ab.pfpais <> ac.pfpai1 or ab.pftdoc <> ac.pftdo1 or ab.pfndoc <> ac.pfndo1 )
  ; 
           
ln_coor number(15);
counter number(15);

BEGIN


    ln_coor := FN_CORRELATIVO(pa_perano,pa_permes);
        
  for rec_clientec in cur_clientec loop
    
     select COUNT(*) INTO counter  FROM jaqy055 T WHERE 
      T.JAQY055PERANO = pa_perano
      AND T.JAQY055PERMES = pa_permes 
      AND T.JAQY055PAIS = rec_clientec.pfpais
      AND T.JAQY055TDOC = rec_clientec.pftdoc              
      AND T.JAQY055NDOC = rec_clientec.pfndoc
      AND T.JAQY055TIPO = 'B'
      AND T.JAQY055PAIV = rec_clientec.pfpai1
      AND T.JAQY055TDOV = rec_clientec.pftdo1
      AND T.JAQY055NDOV = rec_clientec.pfndo1;
    
      if counter = 0 then 
        --ln_coor := FN_CORRELATIVO(pa_perano,pa_permes);
        ln_coor := ln_coor +1;
        insert into jaqy055
          (jaqy055perano,
           jaqy055permes,
           jaqy055corr,
           jaqy055pais,
           jaqy055tdoc,
           jaqy055ndoc,
           jaqy055tipo,
           jaqy055tipe,
           jaqy055paiv,
           jaqy055tdov,
           jaqy055ndov
           )
        values
          (rec_clientec.pa_perano,
           rec_clientec.pa_permes,
           ln_coor,
           rec_clientec.pfpais,
           rec_clientec.pftdoc,
           rec_clientec.pfndoc,       
           rec_clientec.tipo, 
           'F',
           rec_clientec.pfpai1,
           rec_clientec.pftdo1,
           rec_clientec.pfndo1
           );
       end if;
  end loop;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('SP_CLIENTE_GRUPO5 ' || SQLERRM);
END;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure SP_CLIENTE_GRUPO6(pa_perano number,
                            pa_permes number
                            ) IS
  -- *****************************************************************
  -- Nombre                     : SP_CLIENTE_GRUPO6
  -- Sistema                    : SORFY
  -- Módulo                     : Créditos
  -- Versión                    : 
  -- Fecha de Creación          : 
  -- Autor de Creación          : yyampi
  -- Uso                        : formacion de grupos con presuncion de control
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :                           
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- Descripción de Modificación: 
  -- *****************************************************************                        

cursor cur_clientec is 
SELECT distinct dat.pa_perano , dat.pa_permes,  dat.pfpais, dat.pftdoc, dat.pfndoc , dat.tipo,  abc.jaqy052pais pfpai1 , abc.jaqy052tdoc pftdo1, abc.jaqy052ndoc pfndo1
  FROM (SELECT distinct  pa_perano,
                         pa_permes,
                        t.jaqy052pais pfpais,
                        t.jaqy052tdoc pftdoc,
                        t.jaqy052ndoc pfndoc,
                        'A' TIPO,
                        t.jaqy051corr
          FROM jaqy052 t 
         where t.jaqy052erel = '1'
           and t.jaqy051pano = pa_perano
           and t.jaqy051pmes = pa_permes
           and nvl(t.jaqy052esre, 'B') = 'B') dat,
       (SELECT a.jaqy051corr, a.jaqy052pais, a.jaqy052tdoc, a.jaqy052ndoc
          FROM jaqy052 a
         where a.jaqy052erel = 1
           and a.jaqy051pano = pa_perano
           and a.jaqy051pmes = pa_permes
           and nvl(a.jaqy052esre, 'B') = 'B') abc
 where dat.jaqy051corr = abc.jaqy051corr
 and ( dat.pfpais <> abc.jaqy052pais or dat.pftdoc <> abc.jaqy052tdoc or dat.pfndoc <> abc.jaqy052ndoc )
 
 ;
           
ln_coor number(15);

BEGIN

  ln_coor := FN_CORRELATIVO(pa_perano,pa_permes);

  for rec_clientec in cur_clientec loop
    --ln_coor := FN_CORRELATIVO(pa_perano,pa_permes);
    ln_coor := ln_coor +1;
    insert into jaqy055
      (jaqy055perano,
       jaqy055permes,
       jaqy055corr,
       jaqy055pais,
       jaqy055tdoc,
       jaqy055ndoc,
       jaqy055tipo,
       jaqy055tipe,
       jaqy055paiv,
       jaqy055tdov,
       jaqy055ndov
       )
    values
      (rec_clientec.pa_perano,
       rec_clientec.pa_permes,
       ln_coor,
       rec_clientec.pfpais,
       rec_clientec.pftdoc,
       rec_clientec.pfndoc,
       rec_clientec.tipo,
       'F',
       rec_clientec.pfpai1,
       rec_clientec.pftdo1,
       rec_clientec.pfndo1       
       );       
  end loop;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('SP_CLIENTE_GRUPO6 ' || SQLERRM);
END;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

FUNCTION FN_CORRELATIVO(pa_perano number, pa_permes number) RETURN NUMBER IS
  -- *****************************************************************
  -- Nombre                     : SP_INT_COMUN
  -- Sistema                    : SORFY
  -- Módulo                     : Créditos
  -- Versión                    : 
  -- Fecha de Creación          : 
  -- Autor de Creación          : yyampi
  -- Uso                        : formacion de grupos
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :                           
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- Descripción de Modificación: 
  -- *****************************************************************                        

  LN_CORR NUMBER(15) := 0;

BEGIN

  SELECT nvl(max(nvl(t.jaqy055corr, 0)),0) + 1
    into LN_CORR
    FROM JAQY055 T
   WHERE T.JAQY055PERANO = pa_perano
     AND T.JAQY055PERMES = pa_permes;
     
  return LN_CORR   ;
  
EXCEPTION
  WHEN OTHERS THEN
    return 0;
    DBMS_OUTPUT.put_line('FN_CORRELATIVO ' || SQLERRM);
END;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

PROCEDURE SP_JURIDICA_GRUPO1(pa_perano number, pa_permes number)  IS
  -- *****************************************************************
  -- Nombre                     : SP_INT_COMUN
  -- Sistema                    : SORFY
  -- Módulo                     : Créditos
  -- Versión                    : 
  -- Fecha de Creación          : 
  -- Autor de Creación          : yyampi
  -- Uso                        : formacion de grupos REP LEGALES
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :                           
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- Descripción de Modificación: 
  -- *****************************************************************                        

 cursor cur_clientec is 
 SELECT distinct pa_perano,
                 pa_permes,
                 r.pjpais pfpais,
                 r.pjtdoc pftdoc,
                 r.pjndoc pfndoc,
                 'D' TIPO,
                 t.pfpai1 pfpai1, 
                 t.pftdo1 pftdo1, 
                 t.pfndo1 pfndo1  
   from fsd003 r, fsr003 t
  where r.pjpais = t.pjpais
    and r.pjtdoc = t.pjtdoc
    and r.pjndoc = t.pjndoc
    and exists (SELECT 1
           FROM fsr008 a, fsd010 b
          where a.pgcod = b.pgcod
            and a.ctnro = b.aocta
            and r.pjpais = a.pepais
            and r.pjtdoc = a.petdoc
            and r.pjndoc = a.pendoc
            and a.ttcod = 1
            and b.aostat <> 99)
   and t.vicod in (7,18,22,25,27,38,39,40,41,42,43,44,45,46,47,48,51,84);
 /*
 SELECT distinct pa_perano,
                 pa_permes,
                 t.pfpai1 pfpais,
                 t.pftdo1 pftdoc,
                 t.pfndo1 pfndoc,
                 'D' TIPO
   from fsd003 r, fsr003 t
  where r.pjpais = t.pjpais
    and r.pjtdoc = t.pjtdoc
    and r.pjndoc = t.pjndoc
    and exists (SELECT 1
           FROM fsr008 a, fsd010 b
          where a.pgcod = b.pgcod
            and a.ctnro = b.aocta
            and r.pjpais = a.pepais
            and r.pjtdoc = a.petdoc
            and r.pjndoc = a.pendoc
            and a.ttcod = 1
            and b.aostat <> 99)
   and t.vicod in (7,18,22,25,27,38,39,40,41,42,43,44,45,46,47,48,51,84);
   */
           
ln_coor number(15);

BEGIN

  ln_coor := FN_CORRELATIVO(pa_perano,pa_permes);

  for rec_clientec in cur_clientec loop
    --ln_coor := FN_CORRELATIVO(pa_perano,pa_permes);
    ln_coor := ln_coor +1;
    insert into jaqy055
      (jaqy055perano,
       jaqy055permes,
       jaqy055corr,
       jaqy055pais,
       jaqy055tdoc,
       jaqy055ndoc,
       jaqy055tipo,
       jaqy055tipe,
       jaqy055paiv,
       jaqy055tdov,
       jaqy055ndov)
    values
      (rec_clientec.pa_perano,
       rec_clientec.pa_permes,
       ln_coor,
       rec_clientec.pfpais,
       rec_clientec.pftdoc,
       rec_clientec.pfndoc,

       rec_clientec.tipo,
       'J',       
       rec_clientec.pfpai1,
       rec_clientec.pftdo1,
       rec_clientec.pfndo1        
       );
       
  end loop;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('SP_JURIDICA_GRUPO1 ' || SQLERRM);
END;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

PROCEDURE SP_JURIDICA_GRUPO2(pa_perano number, pa_permes number)  IS
  -- *****************************************************************
  -- Nombre                     : SP_INT_COMUN
  -- Sistema                    : SORFY
  -- Módulo                     : Créditos
  -- Versión                    : 
  -- Fecha de Creación          : 
  -- Autor de Creación          : yyampi
  -- Uso                        : formacion de grupos otros personas juridicas
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :                           
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- Descripción de Modificación: 
  -- *****************************************************************                        

 cursor cur_clientec is 
 SELECT distinct aval.pa_perano, aval.pa_permes, aval.pfpais, aval.pftdoc, aval.pfndoc , aval.tipo , rel.pepais , rel.petdoc, rel.pendoc FROM (
 SELECT distinct pa_perano pa_perano, pa_permes pa_permes, a.pjpais pfpais, a.pjtdoc pftdoc , a.pjndoc pfndoc , 'H' TIPO  ,  r.sng001inst 
  FROM fsd003 a , fsr008 t, sng003 r  
 where ( t.pgcod = r.sng003pgc
           and t.ctnro = r.sng003cta
           and t.pepais = a.pjpais
           and t.petdoc = a.pjtdoc
           and t.pendoc = a.pjndoc  
           and t.ttcod = 1         
           )
   and exists (SELECT 1
          FROM fsr008 t, fsd010 r
         where t.pgcod = r.pgcod
           and t.ctnro = r.aocta
           and a.pjpais = t.pepais
           and a.pjtdoc = t.petdoc
           and a.pjndoc = t.pendoc
            and t.ttcod = 1 
           and r.aostat <> 99)) aval , xwf700 cred , fsr008 rel  , fsd010 ope        
           where cred.xwfprcins = aval.sng001inst  
           and (ope.pgcod = cred.xwfempresa and ope.aomod = cred.xwfmodulo and ope.aosuc = cred.xwfsucursal 
           and ope.aomda = cred.xwfmoneda and ope.aopap = cred.xwfmoneda and ope.aocta = cred.xwfcuenta
           and ope.aooper = cred.xwfoperacion and ope.aosbop = cred.xwfsubope and ope.aotope = cred.xwftipope )         
           and ope.aostat <> 99
           
           and rel.ctnro = cred.xwfcuenta           
           and exists (SELECT 1
              FROM fsr008 t, fsd010 r
             where t.pgcod = r.pgcod
               and t.ctnro = r.aocta
               and rel.pepais = t.pepais
               and rel.petdoc = t.petdoc
               and rel.pendoc = t.pendoc
               and t.ttcod = 1  
               and r.aostat <> 99)
               ;

 
 /* SELECT distinct pa_perano,
                  pa_permes,
                  t.pjpais pfpais,
                  t.pjtdoc pftdoc,
                  t.pjndoc pfndoc,
                  'H' TIPO,
                  t.pfpai1 pfpai1,
                  t.pftdo1 pftdo1,
                  t.pfndo1 pfndo1                 
   FROM FSR003 t
  where exists (SELECT *
           FROM fsr003 r
          where r.pfpai1 = t.pfpai1
            and r.pftdo1 = t.pftdo1
            and r.pfndo1 = t.pfndo1
            and (t.pjpais <> r.pjpais or t.pjtdoc <> r.pjtdoc or
                t.pjndoc <> r.pjndoc))
    and exists (SELECT 1
           FROM fsr008 a, fsd010 b
          where a.pgcod = b.pgcod
            and a.ctnro = b.aocta
            and t.pjpais = a.pepais
            and t.pjtdoc = a.petdoc
            and t.pjndoc = a.pendoc
            and a.ttcod = 1
            and b.aostat <> 99)            
      and t.vicod in (9,35,33,34,84,32,13,55,53,52,21,19,20,22,14,45,43,44,4,33,10,37,36,29,55,54,57,49,51,19,24,23,25,15,43,47,46,40,86,2,8,14,15,16,17,18,29,30,32,39,40,41,42,58,83,6,8,11,12,13,17,21,24,26,28,35,37,42,45,47,48,5,11,16,20,23,26,27,30,31,34,36,41,44,46,48,50);       
*/
 
 /*
  SELECT distinct pa_perano, pa_permes , t.pjpais pfpais , t.pjtdoc pftdoc, t.pjndoc pfndoc , 'H' TIPO      
         FROM FSR003 t where 
      exists (SELECT * FROM fsr003 r where r.pfpai1 = t.pfpai1 and r.pftdo1 = t.pftdo1 and r.pfndo1 = t.pfndo1
      and (t.pjpais <> r.pjpais or t.pjtdoc <> r.pjtdoc or t.pjndoc <> r.pjndoc ) 
      )and exists (SELECT 1
                FROM fsr008 a, fsd010 b
               where a.pgcod = b.pgcod
                 and a.ctnro = b.aocta
                 and t.pjpais = a.pepais
                 and t.pjtdoc = a.petdoc
                 and t.pjndoc = a.pendoc
                 and a.ttcod = 1
                 and b.aostat <> 99)
      and t.vicod in (9,35,33,34,84,32,13,55,53,52,21,19,20,22,14,45,43,44,4,33,10,37,36,29,55,54,57,49,51,19,24,23,25,15,43,47,46,40,86,2,8,14,15,16,17,18,29,30,32,39,40,41,42,58,83,6,8,11,12,13,17,21,24,26,28,35,37,42,45,47,48,5,11,16,20,23,26,27,30,31,34,36,41,44,46,48,50);       
      */

           
ln_coor number(15);

BEGIN

   ln_coor := FN_CORRELATIVO(pa_perano,pa_permes);

  for rec_clientec in cur_clientec loop
    --ln_coor := FN_CORRELATIVO(pa_perano,pa_permes);
    ln_coor := ln_coor +1 ;
    insert into jaqy055
      (jaqy055perano,
       jaqy055permes,
       jaqy055corr,
       jaqy055pais,
       jaqy055tdoc,
       jaqy055ndoc,
       jaqy055tipo,
       jaqy055tipe,
       jaqy055paiv,
       jaqy055tdov,
       jaqy055ndov       
       )
    values
      (rec_clientec.pa_perano,
       rec_clientec.pa_permes,
       ln_coor,
       rec_clientec.pepais,
       rec_clientec.petdoc,
       rec_clientec.pendoc,
       rec_clientec.tipo,
       'J',
       rec_clientec.pfpais,
       rec_clientec.pftdoc,
       rec_clientec.pfndoc
       );
       
  end loop;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('SP_JURIDICA_GRUPO1 ' || SQLERRM);
END;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

PROCEDURE SP_JURIDICA_GRUPO3(pa_perano number, pa_permes number)  IS
  -- *****************************************************************
  -- Nombre                     : SP_JURIDICA_GRUPO3
  -- Sistema                    : SORFY
  -- Módulo                     : Créditos
  -- Versión                    : 
  -- Fecha de Creación          : 
  -- Autor de Creación          : yyampi
  -- Uso                        : formacion de directivos compartidos
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :                           
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- Descripción de Modificación: 
  -- *****************************************************************                        

 cursor cur_clientec is 
 SELECT distinct pa_perano,
                pa_permes,
                t.pjpais pfpais,
                t.pjtdoc pftdoc,
                t.pjndoc pfndoc,
                'E' TIPO,
                r.pjpais pfpai1,
                r.pjtdoc pftdo1,
                r.pjndoc pfndo1
  FROM FSR003 t,FSR003 r
 where      r.pfpai1 = t.pfpai1
           and r.pftdo1 = t.pftdo1
           and r.pfndo1 = t.pfndo1
           and (t.pjpais <> r.pjpais or t.pjtdoc <> r.pjtdoc or
               t.pjndoc <> r.pjndoc)
   and exists (SELECT 1
          FROM fsr008 a,fsd010 b
         where a.pgcod = b.pgcod
           and a.ctnro = b.aocta
           and t.pjpais = a.pepais
           and t.pjtdoc = a.petdoc
           and t.pjndoc = a.pendoc
           and b.aostat <> 99
           and a.ttcod = 1)      
   and exists (SELECT 1
          FROM fsr008 a,fsd010 b
         where a.pgcod = b.pgcod
           and a.ctnro = b.aocta
           and r.pjpais = a.pepais
           and r.pjtdoc = a.petdoc
           and r.pjndoc = a.pendoc
           and b.aostat <> 99
           and a.ttcod = 1)                                                       
           and t.vicod in (9,35,33,34,84,32,13,55,53,52,21,19,20,22,14,45,43,44,4,33,10,37,36,29,55,54,57,49,51,19,24,23,25,15,43,47,46,40,86,2,8,14,15,16,17,18,29,30,32,39,40,41,42,58,83,6,8,11,12,13,17,21,24,26,28,35,37,42,45,47,48,5,11,16,20,23,26,27,30,31,34,36,41,44,46,48,50)
           and r.vicod in (9,35,33,34,84,32,13,55,53,52,21,19,20,22,14,45,43,44,4,33,10,37,36,29,55,54,57,49,51,19,24,23,25,15,43,47,46,40,86,2,8,14,15,16,17,18,29,30,32,39,40,41,42,58,83,6,8,11,12,13,17,21,24,26,28,35,37,42,45,47,48,5,11,16,20,23,26,27,30,31,34,36,41,44,46,48,50);

 
 
 
 /*
 SELECT distinct pa_perano,
                 pa_permes,
                 t.pjpais pfpais,
                 t.pjtdoc pftdoc,
                 t.pjndoc pfndoc,
                 'E' TIPO ,
                 t.pfpai1 pfpai1, 
                 t.pftdo1 pftdo1, 
                 t.pfndo1 pfndo1                
                   FROM FSR003 t
                  where exists (SELECT *
                           FROM fsr003 r
                          where r.pfpai1 = t.pfpai1
                            and r.pftdo1 = t.pftdo1
                            and r.pfndo1 = t.pfndo1
                            and (t.pjpais <> r.pjpais or
                                t.pjtdoc <> r.pjtdoc or
                                t.pjndoc <> r.pjndoc))
                    and exists (SELECT 1
                           FROM fsr008 a, fsd010 b
                          where a.pgcod = b.pgcod
                            and a.ctnro = b.aocta
                            and t.pjpais = a.pepais
                            and t.pjtdoc = a.petdoc
                            and t.pjndoc = a.pendoc
                            and b.aostat <> 99
                            and a.ttcod = 1)
                            and t.vicod in (9,35,33,34,84,32,13,55,53,52,21,19,20,22,14,45,43,44,4,33,10,37,36,29,55,54,57,49,51,19,24,23,25,15,43,47,46,40,86,2,8,14,15,16,17,18,29,30,32,39,40,41,42,58,83,6,8,11,12,13,17,21,24,26,28,35,37,42,45,47,48,5,11,16,20,23,26,27,30,31,34,36,41,44,46,48,50);

 */
 
/*SELECT distinct pa_perano,
                pa_permes,
                t.pjpais pfpais,
                t.pjtdoc pftdoc,
                t.pjndoc pfndoc,
                'E' TIPO                 
                   FROM FSR003 t
                  where exists (SELECT *
                           FROM fsr003 r
                          where r.pfpai1 = t.pfpai1
                            and r.pftdo1 = t.pftdo1
                            and r.pfndo1 = t.pfndo1
                            and (t.pjpais <> r.pjpais or
                                t.pjtdoc <> r.pjtdoc or
                                t.pjndoc <> r.pjndoc))
                    and exists (SELECT 1
                           FROM fsr008 a, fsd010 b
                          where a.pgcod = b.pgcod
                            and a.ctnro = b.aocta
                            and t.pjpais = a.pepais
                            and t.pjtdoc = a.petdoc
                            and t.pjndoc = a.pendoc
                            and b.aostat <> 99
                            and a.ttcod = 1)
                            and t.vicod in (9,35,33,34,84,32,13,55,53,52,21,19,20,22,14,45,43,44,4,33,10,37,36,29,55,54,57,49,51,19,24,23,25,15,43,47,46,40,86,2,8,14,15,16,17,18,29,30,32,39,40,41,42,58,83,6,8,11,12,13,17,21,24,26,28,35,37,42,45,47,48,5,11,16,20,23,26,27,30,31,34,36,41,44,46,48,50);       
*/
ln_coor number(15);

BEGIN

  ln_coor := FN_CORRELATIVO(pa_perano,pa_permes);

  for rec_clientec in cur_clientec loop
    ln_coor := ln_coor +1 ;
    insert into jaqy055
      (jaqy055perano,
       jaqy055permes,
       jaqy055corr,
       jaqy055pais,
       jaqy055tdoc,
       jaqy055ndoc,
       jaqy055tipo,
       jaqy055tipe,
       jaqy055paiv,
       jaqy055tdov,
       jaqy055ndov)
    values
      (rec_clientec.pa_perano,
       rec_clientec.pa_permes,
       ln_coor,
       rec_clientec.pfpais,
       rec_clientec.pftdoc,
       rec_clientec.pfndoc,

       rec_clientec.tipo,
       'J',
       rec_clientec.pfpai1,
       rec_clientec.pftdo1,
       rec_clientec.pfndo1
       );
       
  end loop;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('SP_JURIDICA_GRUPO3 ' || SQLERRM);
END;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

PROCEDURE SP_JURIDICA_GRUPO4(pa_perano number, pa_permes number)  IS
  -- *****************************************************************
  -- Nombre                     : SP_JURIDICA_GRUPO4
  -- Sistema                    : SORFY
  -- Módulo                     : Créditos
  -- Versión                    : 
  -- Fecha de Creación          : 
  -- Autor de Creación          : yyampi
  -- Uso                        : formacion de grupos garantias
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :                           
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- Descripción de Modificación: 
  -- *****************************************************************                        

 cursor cur_clientec is 
 SELECT distinct pa_perano, pa_permes, ab.pepais pfpais ,ab.petdoc pftdoc , ab.pendoc pfndoc, ab.tipo, xt.pfpais pfpai1 , xt.pftdoc pftdo1, xt.pfndoc pfndo1  FROM 
 (SELECT distinct t.pjpais pfpais, t.pjtdoc pftdoc, t.pjndoc pfndoc, r.ctnro
   FROM fsd003 t, fsr008 r
  where t.pjpais = r.pepais
    and t.pjtdoc = r.petdoc
    and t.pjndoc = r.pendoc    
    and ((SELECT count(*)
           FROM fsr008 a
          where( a.pepais <> r.pepais
            or a.petdoc <> r.petdoc
            or a.pendoc <> r.pendoc)
            and a.ctnro = r.ctnro) > 1)            
    and exists (SELECT 1
          FROM fsr008 a, fsd010 b
         where a.pgcod = b.pgcod
           and a.ctnro = b.aocta
           and t.pjpais = a.pepais
           and t.pjtdoc = a.petdoc
           and t.pjndoc = a.pendoc
           and b.aostat <> 99
           )) xt,

(SELECT a.pepais, a.petdoc, a.pendoc, 'I' tipo , dat.r1cta , dat.r2cta
  FROM fsr008 a,
       (SELECT distinct t.r2cta, t.r1cta --, (SELECT count(*) FROM fsr008 a where a.ctnro = t.r1cta )  
          from fsr011 t, fsd010 s
         where relcod = 50
           and s.pgcod = t.r1cod
           and t.r1mod = s.aomod
           and t.r1suc = s.aosuc
           and t.r1mda = s.aomda
           and t.r1pap = s.aopap
           and t.r1cta = s.aocta
           and t.r1oper = s.aooper
           and t.r1sbop = s.aosbop
           and t.r1tope = s.aotope
           and s.aostat <> 99
        --   and pa_ncta = t.r1cta
        --and (r.pepais <> 604 or r.petdoc <> 21 or r.pendoc <> '29581478' ) and t.r2cta =  ) 
         group by t.r2cta, t.r1cta) dat
 where a.ctnro = dat.r2cta )  ab where ab.r2cta =xt.ctnro and (ab.pepais <> xt.pfpais or ab.petdoc <> xt.pftdoc or ab.pendoc <> pfndoc );
 
 /*SELECT distinct pa_perano,
                 pa_permes,
                 c.pjpais pfpais,
                 c.pjtdoc pftdoc,
                 c.pjndoc pfndoc,
                 'E' TIPO
   FROM (SELECT t.r2cta, t.r1cta, count(*)
           from fsr011 t, fsd010 s
          where relcod = 50
            and s.pgcod = t.r1cod
            and t.r1mod = s.aomod
            and t.r1suc = s.aosuc
            and t.r1mda = s.aomda
            and t.r1pap = s.aopap
            and t.r1cta = s.aocta
            and t.r1oper = s.aooper
            and t.r1sbop = s.aosbop
            and t.r1tope = s.aotope
            and s.aostat <> 99
          group by t.r2cta, t.r1cta
         having count(*) > 1) a,
        fsr008 b,
        fsd003 c
  where a.r1cta = b.ctnro
    and c.pjpais = b.pepais
    and c.pjtdoc = b.petdoc
    and c.pjndoc = b.pendoc
    and b.ttcod = 1;*/
 
ln_coor number(15);

BEGIN

  ln_coor := FN_CORRELATIVO(pa_perano,pa_permes);

  for rec_clientec in cur_clientec loop
   -- ln_coor := FN_CORRELATIVO(pa_perano,pa_permes);
   ln_coor := ln_coor +1;
    insert into jaqy055
      (jaqy055perano,
       jaqy055permes,
       jaqy055corr,
       jaqy055pais,
       jaqy055tdoc,
       jaqy055ndoc,
       jaqy055tipo,
       jaqy055tipe,
       jaqy055paiv,
       jaqy055tdov,
       jaqy055ndov
       )
    values
      (rec_clientec.pa_perano,
       rec_clientec.pa_permes,
       ln_coor,
       rec_clientec.pfpais,
       rec_clientec.pftdoc,
       rec_clientec.pfndoc,

       rec_clientec.tipo,
       'J',
       rec_clientec.pfpai1,
       rec_clientec.pftdo1,
       rec_clientec.pfndo1
       );
       
  end loop;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('SP_JURIDICA_GRUPO4 ' || SQLERRM);
END;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

PROCEDURE SP_JURIDICA_GRUPO5(pa_perano number, pa_permes number)  IS
  -- *****************************************************************
  -- Nombre                     : SP_JURIDICA_GRUPO5
  -- Sistema                    : SORFY
  -- Módulo                     : Créditos
  -- Versión                    : 
  -- Fecha de Creación          : 
  -- Autor de Creación          : yyampi
  -- Uso                        : formacion de directivos L
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :                           
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- Descripción de Modificación: 
  -- *****************************************************************                        

 cursor cur_clientec is 
 SELECT distinct pa_perano,
                 pa_permes,
                 a.pfpai1 pfpai1,
                 a.pftdo1 pftdo1,
                 a.pfndo1 pfndo1,
                 'L' TIPO,
                 a.pjpais pfpais,
                 a.pjtdoc pftdoc,
                 a.pjndoc pfndoc
  from fsr003 a 
 where a.vicod in (2, 3,9,35,33,34,84,32,13,55,53,52,21,19,20,22,14,45,43,44,4,33,10,37,36,29,55,54,57,49,51,19,24,23,25,15,43,47,46,40,86,2,8,14,15,16,17,18,29,30,32,39,40,41,42,58,83,6,8,11,12,13,17,21,24,26,28,35,37,42,45,47,48,5,11,16,20,23,26,27,30,31,34,36,41,44,46,48,50,2,83,8,32,29,30,58,17,14,15,16,18,42,39,40,41)
 and exists (SELECT 1
          FROM fsr008 t, fsd010 r 
         where t.pgcod = r.pgcod
           and t.ctnro = r.aocta
           and a.pjpais = t.pepais
           and a.pjtdoc = t.petdoc
           and a.pjndoc = t.pendoc
           and t.ttcod = 1
           and r.aostat <> 99)
          AND NOT EXISTS (
          
          SELECT distinct pa_perano,
                  pa_permes,
                  c.pfpai1 pfpai1,
                  c.pftdo1 pftdo1,
                  c.pfndo1 pfndo1,
                  c.pjpais pfpais,
                  c.pjtdoc pftdoc,
                  a.pjndoc pfndoc,
                  'M' TIPO
          FROM jaqy052 t, fsr003 c
         where t.jaqy052pais = c.pjpais
           and t.jaqy052tdoc = c.pjtdoc
           and t.jaqy052ndoc = c.pjndoc
           AND T.JAQY051PANO = pa_perano
           and t.jaqy051pmes = pa_permes
           --and t.jaqy052erel = 2
      and c.vicod in (2, 3,9,13,14,19,20,21,22,33,34,35,39,43,44,45,52,53,55,84,4,10,15,23,24,25,29,36,37,40,46,47,49,51,54,57)
      and a.pjpais = c.pjpais
      and a.pjtdoc = c.pjtdoc
      and a.pjndoc = c.pjndoc
      and a.pfpai1 = c.pfpai1
      and a.pftdo1 = c.pftdo1
      and a.pfndo1 = c.pfndo1

           )              ;
 
ln_coor number(15);

BEGIN

  ln_coor := FN_CORRELATIVO(pa_perano,pa_permes);

  for rec_clientec in cur_clientec loop
    --ln_coor := FN_CORRELATIVO(pa_perano,pa_permes);
    ln_coor := ln_coor +1;
    insert into jaqy055
      (jaqy055perano,
       jaqy055permes,
       jaqy055corr,
       jaqy055pais,
       jaqy055tdoc,
       jaqy055ndoc,
       jaqy055tipo,
       jaqy055tipe,
       jaqy055paiv,
       jaqy055tdov,
       jaqy055ndov       
       )
    values
      (rec_clientec.pa_perano,
       rec_clientec.pa_permes,
       ln_coor,
       rec_clientec.pfpais,
       rec_clientec.pftdoc,
       rec_clientec.pfndoc,
       rec_clientec.tipo,
       'J',
       rec_clientec.pfpai1,
       rec_clientec.pftdo1,
       rec_clientec.pfndo1       
       );
       
  end loop;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('SP_JURIDICA_GRUPO5 ' || SQLERRM);
END;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

PROCEDURE SP_JURIDICA_GRUPO6(pa_perano number, pa_permes number)  IS
  -- *****************************************************************
  -- Nombre                     : SP_JURIDICA_GRUPO5
  -- Sistema                    : SORFY
  -- Módulo                     : Créditos
  -- Versión                    : 
  -- Fecha de Creación          : 
  -- Autor de Creación          : yyampi
  -- Uso                        : formacion de directivos M
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :                           
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- Descripción de Modificación: 
  -- *****************************************************************                        

 cursor cur_clientec is 
  SELECT distinct pa_perano,
                  pa_permes,
                  a.pfpai1 pfpai1,
                  a.pftdo1 pftdo1,
                  a.pfndo1 pfndo1,
                  a.pjpais pfpais,
                  a.pjtdoc pftdoc,
                  a.pjndoc pfndoc,
                  'M' TIPO
    FROM jaqy052 t, fsr003 a
   where t.jaqy052pais = a.pjpais
     and t.jaqy052tdoc = a.pjtdoc
     and t.jaqy052ndoc = a.pjndoc
     AND T.JAQY051PANO = pa_perano
     and t.jaqy051pmes = pa_permes
     and t.jaqy052erel = 2
     and exists (SELECT 1
          FROM fsr008 t, fsd010 r 
         where t.pgcod = r.pgcod
           and t.ctnro = r.aocta
           and a.pjpais = t.pepais
           and a.pjtdoc = t.petdoc
           and a.pjndoc = t.pendoc
           and t.ttcod = 1
           and r.aostat <> 99)
     
and a.vicod in (2, 3,9,13,14,19,20,21,22,33,34,35,39,43,44,45,52,53,55,84,4,10,15,23,24,25,29,36,37,40,46,47,49,51,54,57)

;
 
ln_coor number(15);

BEGIN

  ln_coor := FN_CORRELATIVO(pa_perano,pa_permes);

  for rec_clientec in cur_clientec loop
    --ln_coor := FN_CORRELATIVO(pa_perano,pa_permes);
    ln_coor := ln_coor +1;
    insert into jaqy055
      (jaqy055perano,
       jaqy055permes,
       jaqy055corr,
       jaqy055pais,
       jaqy055tdoc,
       jaqy055ndoc,
       jaqy055tipo,
       jaqy055tipe,
       jaqy055paiv,
       jaqy055tdov,
       jaqy055ndov
       )
    values
      (rec_clientec.pa_perano,
       rec_clientec.pa_permes,
       ln_coor,
       rec_clientec.pfpais,
       rec_clientec.pftdoc,
       rec_clientec.pfndoc,
       rec_clientec.tipo,
       'J',
       rec_clientec.pfpai1,
       rec_clientec.pftdo1,
       rec_clientec.pfndo1
       );
       
  end loop;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('SP_JURIDICA_GRUPO6 ' || SQLERRM);
END;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  
end bk_pq_riesgo_unico_bt;

/*
   create public synonym pq_cr_adjudicar for pq_cr_adjudicar;
   grant execute on pq_cr_adjudicar to rol_sorfy,rol_sorfy_consulta;

*/
/

