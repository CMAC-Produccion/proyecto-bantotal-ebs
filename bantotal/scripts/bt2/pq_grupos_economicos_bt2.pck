CREATE OR REPLACE PACKAGE pq_grupos_economicos_bt2 is
  -- *****************************************************************
  -- Nombre                       : PQ_CR_GRUPOS_ECONOMICOS
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 18/05/2007
  -- Autor de Creación            : yyasmpi
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Fecha de Modificación        : 31/01/2020
  -- Autor de Modificación        : jrodriguej
  -- Descripción de Modificación  : Se optimizo el algoritmo para que tenga un menor tiempo de ejecución
  -- *****************************************************************
   
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  type re_integrantes is record(
       JAQY052TPAIS number(3), 
       JAQY052TTDOC number(2), 
       JAQLY052TNDOC varchar2(12)
  );
  type tb_integrantes is table of re_integrantes;
  type cur_detalle_roles is ref cursor return re_integrantes;
 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure SP_CR_GRUPOS_ECONOMICOS(P_PERANO in varchar2,
                                    P_PERMES in varchar2,
                                    P_COD IN number
                                    );
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure SP_AGREGAR_GRUPO(pa_perano number,
                             pa_permes number,
                             pa_corr   number,
                             pa_pjpais number,
                             pa_pjtdoc number,
                             pa_pjndoc varchar2,
                             pa_estreg varchar2
                             ); 
                                                                                      
  procedure SP_CREAR_GRUPO(  pa_perano number,
                             pa_permes number,                           
                             pa_pjpais number,
                             pa_pjtdoc number,
                             pa_pjndoc varchar2, 
                             pa_pjpaiso number,
                             pa_pjtdoco number,
                             pa_pjndoco varchar2,
                             --P_COD number,
                             pa_cont number                           
                             ); 

  procedure SP_FORMAR_GRUPO( pa_perano number,
                             pa_permes number,
                             pa_pjpaisb number,
                             pa_pjtdocb number,
                             pa_pjndocb varchar2,
                             pa_pjpaiso number,
                             pa_pjtdoco number,
                             pa_pjndoco varchar2,
                             --P_COD number,
                             pa_comun number,
                             pa_cont number ); 
    function FN_PC_MAYORIA(pa_pjpais number,
                          pa_pjtdoc number,
                          pa_pjndoc varchar2,
                          pa_tipmay  number,
                          --P_COD number,
                          pa_perano number,
                          pa_permes number,
                          pa_percor number) return varchar;
   
    procedure SP_PC_PROPIEDAD_GESTION(pa_perano number, pa_permes number
      --,P_COD number
      );
    
    FUNCTION FN_PC_VINCULO(pa_pjpais1 number,
                           pa_pjtdoc1 number,
                           pa_pjndoc1 varchar2,
                           pa_pjpais2 number,
                           pa_pjtdoc2 number,
                           pa_pjndoc2 varchar2) RETURN VARCHAR;
                           
  procedure SP_PC_DIR_INDIR(pa_perano number,
                            pa_permes number,          
                            pa_pjpais number,
                            pa_pjtdoc number,
                            pa_pjndoc varchar2,
                            pa_tipmay number,
                            pa_grupo  number
                            --,P_COD number
                            );
                                                        
 procedure SP_AGREGAR_INTCOMUN(pa_perano number,
                           pa_permes number,
                           pa_corr   number,
                           pa_pjpais number,
                           pa_pjtdoc number,
                           pa_pjndoc varchar2,
                           pa_pjesre varchar2
                           );   

function FN_VALIDAR_GRUPO( pa_perano number,
                           pa_permes number,                           
                           pa_pjpais number,
                           pa_pjtdoc number,
                           pa_pjndoc varchar2, 
                           pa_pjpaiso number,
                           pa_pjtdoco number,
                           pa_pjndoco varchar2,
                           --P_COD number,
                           pa_cont number                           
                           ) return varchar2;                                                    

procedure SP_ACTUALIZAR_GRUPO( pa_perano number,
                           pa_permes number                                                 
                           ) ;


procedure SP_ACTUALIZA_JAQY610;


procedure SP_JOB_GRUPOS( pa_perano number,
                         pa_permes number                                                 
                        ) ;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure SP_INSERTA_REPORTE_INI( pa_perano number,
                              pa_permes number                                                 
                           ) ;                        
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function fn_ciiu_codigo(P_PAIS   in number,
                          P_PETDOC in number,   
                          P_PENDOC in char
                         ) return number;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function FN_SUMA_ACCIONES(pa_pjpaisc number,
                         pa_pjtdocc number,
                         pa_pjndocc varchar2,
                         pa_pfpai1 number,
                         pa_pftdo1 number,
                         pa_pfndo1 varchar2) return number;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function FN_SUMA_MINIMO(pa_min1 number,
                        pa_min2 number) return number;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function FN_CONSULTAR_INTEGRANTES (pa_pjpais number, 
                     pa_pjtdoc number, 
                     pa_pjndoc varchar2,
                     pa_pjpaiso number, 
                     pa_pjtdoco number, 
                     pa_pjndoco varchar2) return tb_integrantes pipelined;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function FN_CONSULTAR_ACCTA (pa_perano number, 
                     pa_permes number, 
                     pa_percor number) return pq_grupos_economicos_bt2.cur_detalle_roles;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function FN_CONSULTAR_DIRET (pa_perano number, 
                     pa_permes number, 
                     pa_percor number) return pq_grupos_economicos_bt2.cur_detalle_roles;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function FN_CONSULTAR_ACCTA_TABLA (pa_perano number, 
                                   pa_permes number, 
                                   pa_percor number) return tb_integrantes pipelined;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function FN_CONSULTAR_DIRET_TABLA (pa_perano number, 
                                   pa_permes number, 
                                   pa_percor number) return tb_integrantes pipelined;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Function fn_cr_verifica_jobs return number;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure SP_INSERTA_REPORTE( pa_perano number,
                              pa_permes number                                                 
                           );
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 function fn_ciiu_codigo4(P_PAIS   in number,
                          P_PETDOC in number,   
                          P_PENDOC in char
                         ) return varchar2;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

 function fn_cr_nombre (P_PAIS   in number,
                          P_PETDOC in number,   
                          P_PENDOC in char
                         ) return varchar2;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure SP_INSERTA_GRUPOS( pa_perano number,
                              pa_permes number                                                 
                           );
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

procedure sp_obtiene_cuenta( pa_pepais in number,
                             pa_petdoc in number, 
                             pa_pendoc in char,
                             pa_fecpro in date,
                             pd_fecdes out date,
                             pn_cuenta out number,
                             pn_operac out number

                           ) ;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
PROCEDURE SP_CR_OBTENER_MAGNITUD_EMPRESARIAL(pANIO IN NUMBER, pMES IN NUMBER);                     
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                           
end pq_grupos_economicos_bt2;
/

CREATE OR REPLACE PACKAGE BODY pq_grupos_economicos_bt2 is
  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure SP_CR_GRUPOS_ECONOMICOS(P_PERANO in varchar2,
                                    P_PERMES in varchar2,
                                    P_COD IN NUMBER
                                    ) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_GRUPOS_ECONOMICOS
    -- Sistema                    : BANTOTAL
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
    -- Fecha de Modificación      : 31/01/2020
    -- Autor de la Modificación   : jrodriguej
    -- Descripción de Modificación: Se optimizó el algoritmo para que tenga un menor tiempo de ejecución
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Crédito.   
    
  FECINI DATE;
  FECFIN DATE;
  pa_comun number(15) := 0;
  sumin1 number(15) := 0;
  sumin2 number(15) := 0;
  totalC3 number(15) := 0;
  
  cursor  cur_pj_base is
  SELECT --2017 /*+ parallel(t,5) */ 
         t.pjpais, 
         t.pjtdoc, 
         (t.pjndoc) pjndoc 
  FROM 
         fsd003 t , jaqy610 r
  where 
         t.pjpais = r.pjpais 
         and t.pjtdoc = r.pjtdoc 
         and t.pjndoc = r.pjndoc 
         ----and r.pjndoc = '20491127857'
         and r.cod = P_COD  
  ORDER BY 
        r.Pjpais, 
        r.Pjtdoc, 
        r.Pjndoc
  /*
  where  trim(t.pjndoc) in (  
  '44556688777',
  '22334455886',
  '12598745631',
  '20508565934')  */

   --yordan test
  ;
  
  
  cursor cur_pj_obj (pa_pjpais number, pa_pjtdoc number, pa_pjndoc varchar2 ) is  

    select 
      distinct s.pjpais pjpais,s.pjtdoc pjtdoc,s.pjndoc pjndoc
    from 
        fsr003 t 
        inner join fsr003 s on 
        concat(concat(to_char(s.pfpai1),to_char(s.pftdo1)),s.pfndo1) =  concat(concat(to_char(t.pfpai1),to_char(t.pftdo1)),t.pfndo1)
        /*s.pfpai1 = t.pfpai1 and
        s.pftdo1 = t.pftdo1 and
        s.pfndo1 = t.pfndo1*/
    where 
        t.vicod in (1,8,9,10,11,12,13,29,30,31,32,33,34,35,36,37,38,49,50,51,52,53,54,55,56,57,58,83,84,2,4,3,7)
        and s.vicod in (1,8,9,10,11,12,13,29,30,31,32,33,34,35,36,37,38,49,50,51,52,53,54,55,56,57,58,83,84,2,4,3,7)
        and t.pjpais = pa_pjpais 
        and t.pjtdoc = pa_pjtdoc 
        and t.pjndoc = pa_pjndoc
        and exists (
            select  
                 'x'
            from 
                 fsd003 f
            where
                 concat(concat(to_char(trim(f.pjpais)),to_char(trim(f.pjtdoc))),trim(f.pjndoc)) <>  
                 concat(concat(to_char(trim(pa_pjpais)),to_char(trim(pa_pjtdoc))),trim(pa_pjndoc))
                 and f.pjpais = s.pjpais 
                 and f.pjtdoc = s.pjtdoc  
                 and f.pjndoc = s.pjndoc
        )
      order by s.pjpais,s.pjtdoc,s.pjndoc;
        
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  cursor cur_pj_int (pa_pjpais number, pa_pjtdoc number, pa_pjndoc varchar2,
                     pa_pjpaiso number, pa_pjtdoco number, pa_pjndoco varchar2) is  
  
  
   /*--jaqy052-t--*/
   SELECT 
       distinct 
            a.pfpai1 tpais, 
            a.pftdo1 ttdoc, 
            a.pfndo1 tndoc
    FROM (SELECT t.pfpai1, t.pftdo1, t.pfndo1
            FROM fsr003 t
           where t.pjpais = pa_pjpais
             and t.pjtdoc = pa_pjtdoc
             and t.pjndoc = pa_pjndoc
             and t.vicod in (1,8,9,10,11,12,13,29,30,31,32,33,34,35,36,37,38,49,50,51,52,53,54,55,56,57,58,83,84
               ,2,4,3,7 
               )  ) a,
         (SELECT 
                 t.pfpai1, t.pftdo1, t.pfndo1
            FROM fsr003 t
           where t.pjpais = pa_pjpaiso
             and t.pjtdoc = pa_pjtdoco
             and t.pjndoc = pa_pjndoco
             and t.vicod in (1,8,9,10,11,12,13,29,30,31,32,33,34,35,36,37,38,49,50,51,52,53,54,55,56,57,58,83,84
             ,2,4,3,7 
             )  ) b
   where a.pfpai1 = b.pfpai1
     and a.pftdo1 = b.pftdo1
     and a.pfndo1 = b.pfndo1; 
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
       
  begin
  
  FECINI := sysdate;  
  
  /*limpiar*/
  --delete jaqy052 t where t.jaqy051pano= P_PERANO and t.jaqy051pmes = P_PERMES;
  --delete jaqy051 t where t.jaqy051pano= P_PERANO and t.jaqy051pmes = P_PERMES;
  
  /*llenado de informacion*/ 
  -- select count(*) into conta10 from table(FN_INTEGRANTES(0)); 
  
 for rec_pj_base in cur_pj_base loop
    for rec_pj_obj in cur_pj_obj( rec_pj_base.pjpais,rec_pj_base.pjtdoc,rec_pj_base.pjndoc ) loop
        
        sumin1 := 0;
        sumin2 := 0;
        totalC3 := 0;
        
        for rec_pj_int in cur_pj_int(rec_pj_base.pjpais,rec_pj_base.pjtdoc,rec_pj_base.pjndoc,rec_pj_obj.pjpais, rec_pj_obj.pjtdoc, rec_pj_obj.pjndoc) loop
           
             sumin1 := sumin1 + FN_SUMA_ACCIONES(rec_pj_base.pjpais, rec_pj_base.pjtdoc, rec_pj_base.pjndoc,
                                                 rec_pj_int.tpais, rec_pj_int.ttdoc, rec_pj_int.tndoc);
             sumin2 := sumin2 + FN_SUMA_ACCIONES(rec_pj_obj.pjpais, rec_pj_obj.pjtdoc, rec_pj_obj.pjndoc,
                                                 rec_pj_int.tpais, rec_pj_int.ttdoc, rec_pj_int.tndoc);
             totalC3 := totalC3 + 1;
        end loop;
         
            --comparar 
            --si existe no hacer nada 
            --en caso contrario entonces insertar par
            pa_comun := FN_SUMA_MINIMO(sumin1,sumin2);
            --dbms_output.put_line('rec_pj_base.pjndoc '||rec_pj_base.pjndoc);
            SP_FORMAR_GRUPO(P_PERANO,P_PERMES,rec_pj_base.pjpais,rec_pj_base.pjtdoc,rec_pj_base.pjndoc, rec_pj_obj.pjpais,rec_pj_obj.pjtdoc,rec_pj_obj.pjndoc, pa_comun, totalC3);
      
    end loop;
  end loop;
  
  
  /*SP_PC_PROPIEDAD_GESTION(pa_perano => P_PERANO, pa_permes => P_PERMES,P_COD => p_cod);
  
  SP_ACTUALIZAR_GRUPO(pa_perano => P_PERANO, pa_permes => P_PERMES);
  */
  FECFIN := sysdate;  
  INSERT INTO JAQY611(JAQY611COD, JAQY611NOM, JAQY611FEI,JAQY611FEF) VALUES( P_COD, 'JOB',FECINI,FECFIN ); 
  commit;
  
  
  
  update JAQZ460
    set JAQZ460FFI = sysdate
  where JAQZ460COD = 'GPE' 
    and JAQZ460NUM = P_COD
    and JAQZ460DES = 'pq_grupos_economicos_bt2';
  COMMIT;
  
  exception when others then 
    --rollback;  
    --DBMS_OUTPUT.put_line('ERROR EN EL PROCESO DE GRUPOS ECONOMICOS');
    null;
  end ;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure SP_FORMAR_GRUPO( pa_perano number,
                           pa_permes number,
                           pa_pjpaisb number,
                           pa_pjtdocb number,
                           pa_pjndocb varchar2,
                           pa_pjpaiso number,
                           pa_pjtdoco number,
                           pa_pjndoco varchar2,
                           --P_COD number,
                           pa_comun number,
                           pa_cont number ) IS
  -- *****************************************************************
  -- Nombre                     : SP_FORMAR_GRUPO
  -- Sistema                    : BANTOTAL
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
                        
cursor cur_int is 
SELECT 
       a.jaqy051pano, 
       a.jaqy051pmes, 
       a.jaqy051corr 
FROM 
       jaqy051 a 
where 
       a.jaqy051pano =  pa_perano 
       and a.jaqy051pmes = pa_permes; --se agrego año y mes  2016.12.27

intSize number(15) := 0;
intSize1 number(15) := 0;
intSize2 number(15) := 0;
esAgr   number (15) := 0;

BEGIN  

/*--Si la validación de la suma es 0, salir--*/
IF pa_comun =0 THEN 
  RETURN ;
END IF;

intSize := pa_cont;

/*existe el grupo del periodo*/
FOR REC_INT IN cur_int LOOP
  
    SELECT 
          count(*)
                into intSize1
    FROM 
          jaqy052 t, (
                     /*--jaqy052-t--*/
                     select d.jaqy052tpais, 
                            d.jaqy052ttdoc, 
                            d.jaqly052tndoc
                     from 
                            table(pq_grupos_economicos_bt2.FN_CONSULTAR_INTEGRANTES(
                            pa_pjpaisb,pa_pjtdocb,pa_pjndocb,pa_pjpaiso,pa_pjtdoco,pa_pjndoco
                            )) d
                     ) r
    where 
          t.jaqy052pais = r.jaqy052tpais
          and t.jaqy052tdoc = r.jaqy052ttdoc
          and t.jaqy052ndoc = r.jaqly052tndoc
          and t.jaqy051corr = REC_INT.jaqy051corr
          and t.jaqy051pano = REC_INT.jaqy051pano
          and t.jaqy051pmes = REC_INT.jaqy051pmes
          and t.jaqy051pano = pa_perano 
          and t.jaqy051pmes = pa_permes;
          --and r.jaqy052tcod = P_COD;
      
   SELECT 
         count(*)
                into intSize2
    FROM 
         jaqy052 t 
    where 
         REC_INT.jaqy051corr = t.jaqy051corr
         and REC_INT.jaqy051pano = t.jaqy051pano
         and REC_INT.jaqy051pmes = t.jaqy051pmes
         and t.jaqy051pano = pa_perano 
         and t.jaqy051pmes = pa_permes;
      
   if intSize = intSize1 and intSize2 = intSize1  then 
       --   dbms_output.put_line('SP_FORMAR_GRUPO '|| pa_pjndocb);
       --   dbms_output.put_line('SP_FORMAR_GRUPO '|| pa_pjndoco);
       /*agregar pj base y obj*/
       SP_AGREGAR_GRUPO(REC_INT.jaqy051pano,REC_INT.jaqy051pmes,REC_INT.jaqy051corr, pa_pjpaisb, pa_pjtdocb, pa_pjndocb,'B');
       SP_AGREGAR_GRUPO(REC_INT.jaqy051pano,REC_INT.jaqy051pmes,REC_INT.jaqy051corr, pa_pjpaiso, pa_pjtdoco, pa_pjndoco,'B');
       esAgr := 1;  
       RETURN;   
   end if;       
END loop;

/*crear el grupo*/
--dbms_output.put_line('SE LLAMO SP_FORMAR_GRUPO '|| pa_pjndocb||' - '||pa_pjndoco);
SP_CREAR_GRUPO(pa_perano,pa_permes,pa_pjpaisb,pa_pjtdocb,pa_pjndocb,pa_pjpaiso,pa_pjtdoco,pa_pjndoco,pa_cont);


EXCEPTION WHEN OTHERS THEN 
--DBMS_OUTPUT.put_line('SP_FORMAR_GRUPO :' ||SQLERRM);
null;
END;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure SP_AGREGAR_GRUPO(pa_perano number,
                           pa_permes number,
                           pa_corr   number,
                           pa_pjpais number,
                           pa_pjtdoc number,
                           pa_pjndoc varchar2,
                           pa_estreg varchar2
                           ) IS
  -- *****************************************************************
  -- Nombre                     : SP_FORMAR_GRUPO
  -- Sistema                    : BANTOTAL
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


intcorr number(15) := 0;
intExiste number(15) :=0;

BEGIN 
  
/*si existe no se agrega - se sale*/
SELECT --/*+ parallel(t,5) */  
       count(*) 
             into intExiste   
  FROM 
       JAQY052 t
 where 
       t.jaqy051pano = pa_perano
       and t.jaqy051pmes = pa_permes
       and t.jaqy052pais = pa_pjpais
       and t.jaqy052tdoc = pa_pjtdoc
       and t.jaqy052ndoc = pa_pjndoc
       and t.jaqy051corr = pa_corr;

if intExiste <> 0 then 
  --dbms_output.put_line('se tiene ya registrado ' ||pa_pjndoc );
  return;
end if;

/*calculamos el correlativo*/  
SELECT 
       nvl(max(jaqy052corr),0) + 1
           into intcorr
  FROM 
       JAQY052 t
 where 
       t.jaqy051pano = pa_perano
       and t.jaqy051pmes = pa_permes
       and t.jaqy051corr = pa_corr;

/*insertar detalle*/
INSERT INTO JAQY052
  (JAQY051PANO,
   JAQY051PMES,
   JAQY051CORR,
   JAQY052CORR,
   JAQY052PAIS,
   JAQY052TDOC,
   JAQY052NDOC,
   JAQY052EREL,
   jaqy052esre
   )
VALUES
  (pa_perano,
   pa_permes,
   pa_corr,
   intcorr,
   pa_pjpais,
   pa_pjtdoc,
   (pa_pjndoc),
   2,
   pa_estreg);
   
   commit; --yordan
END;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure SP_CREAR_GRUPO(  pa_perano number,
                           pa_permes number,                           
                           pa_pjpais number,
                           pa_pjtdoc number,
                           pa_pjndoc varchar2, 
                           pa_pjpaiso number,
                           pa_pjtdoco number,
                           pa_pjndoco varchar2,
                           --P_COD number,
                           pa_cont number                           
                           ) IS
  -- *****************************************************************
  -- Nombre                     : SP_CREAR_GRUPO
  -- Sistema                    : BANTOTAL
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

intCorr number(15) :=0;
indDet number(15)  :=0;


BEGIN 
/*si existe no se agrega - se sale*/
--DBMS_OUTPUT.put_line('LLAMO A VALIDAR '||FN_VALIDAR_GRUPO( pa_perano,pa_permes,pa_pjpais,pa_pjtdoc,pa_pjndoc,pa_pjpaiso,pa_pjtdoco,pa_pjndoco,P_COD));
IF  FN_VALIDAR_GRUPO( pa_perano,pa_permes,pa_pjpais,pa_pjtdoc,pa_pjndoc,pa_pjpaiso,pa_pjtdoco,pa_pjndoco,pa_cont) = 'N' THEN
    RETURN;
END IF;                            


/*obtener correlativo del grupo*/
SELECT 
    nvl(max(t.jaqy051corr),0) + 1 
         into intCorr   
FROM 
    JAQY051 t
where 
    t.jaqy051pano = pa_perano
    and t.jaqy051pmes = pa_permes;
   
   begin 

     /*inserción del grupo*/
     INSERT INTO JAQY051(JAQY051PANO,JAQY051PMES,JAQY051CORR,JAQY051PAIS,JAQY051TDOC,JAQY051NDOC)
     values(pa_perano,pa_permes,intCorr,pa_pjpais, pa_pjtdoc, (pa_pjndoc)); 
     commit;
     
   exception when others then 
     --dbms_output.put_line('ERROR SP_CREAR_GRUPO JAQY051 '||sqlerrm );
     null;
   end;    
   
   /*inserción de los integrantes v.2*/
   begin
       INSERT INTO JAQY052(JAQY051PANO,JAQY051PMES,JAQY051CORR,JAQY052CORR,JAQY052PAIS,JAQY052TDOC,JAQY052NDOC,JAQY052EREL)
       SELECT 
           pa_perano,
           pa_permes,
           intCorr,
           rownum indDet,
           f.jaqy052tpais,
           f.jaqy052ttdoc, 
           f.jaqly052tndoc jaqy052tndoc,
           1  
        FROM 
           ( /*--jaqy052-t--*/
             select d.jaqy052tpais, 
                    d.jaqy052ttdoc, 
                    d.jaqly052tndoc
             from 
                    table(pq_grupos_economicos_bt2.FN_CONSULTAR_INTEGRANTES(
                    pa_pjpais,pa_pjtdoc,pa_pjndoc,pa_pjpaiso,pa_pjtdoco,pa_pjndoco
                    )) d     
            ) f;
       
        commit;
     exception when others then 
       --dbms_output.put_line('ERROR SP_CREAR_GRUPO JAQY052 '||sqlerrm );
       null;
   end;
     
   /*insertamos el pj*/
   SP_AGREGAR_GRUPO(pa_perano,pa_permes,intCorr,pa_pjpais,pa_pjtdoc,pa_pjndoc,'B');
   SP_AGREGAR_GRUPO(pa_perano,pa_permes,intCorr,pa_pjpaiso,pa_pjtdoco,pa_pjndoco,'B');
   
   --commit ;  --yordan 
   
exception when others then 
  --dbms_output.put_line('ERROR SP_CREAR_GRUPO '||sqlerrm );
   null;
END;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure SP_PC_PROPIEDAD_GESTION(pa_perano number , pa_permes number
          --,P_COD number
  ) IS
  -- *****************************************************************
  -- Nombre                     : SP_PC_PROPIEDAD
  -- Sistema                    : BANTOTAL
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
  
  /*pjs*/    
  cursor cur_pjs(pa_percor number) is
    SELECT 
       distinct 
         dat2.pjpaisd pjpais,
         dat2.pjtdocd pjtdoc,
         dat2.pjndocd pjndoc
    FROM (   
     SELECT 
        distinct 
                 t.pjpais, 
                 t.pjtdoc, 
                 t.pjndoc, 
                 r.jaqy051corr, 
                 t.pfpai1, 
                 t.pftdo1, 
                 t.pfndo1  
       FROM 
           fsr003 t, jaqy052 r
      where 
           t.pjpais = r.jaqy052pais
           and t.pjtdoc = r.jaqy052tdoc
           and t.pjndoc = r.jaqy052ndoc
           and r.jaqy052erel = 2
           and r.jaqy052esre = 'B'
           and r.jaqy051pano = pa_perano
           and r.jaqy051pmes = pa_permes
           and r.jaqy051corr = pa_percor
           ) dat1,   
           /*persona externa*/     
          (
           SELECT 
                y.pjpais, 
                y.pjtdoc, 
                y.pjndoc, 
                y.pfpai1, 
                y.pftdo1, 
                y.pfndo1,
                d.pjpais pjpaisd,
                d.pjtdoc pjtdocd,
                d.pjndoc pjndocd 
           FROM  
                fsr003 y, fsd003 d 
           where   
                y.pjpais = d.pjpais 
                and y.pjtdoc = d.pjtdoc
                and y.pjndoc = d.pjndoc 
                and y.vicod IN (1,8,9,10,11,12,13,29,30,31,32,33,34,35,36,37,38,49,50,51,52,53,54,55,56,57,58,83,84
                ,2,4,3,7 --se agrego 2017.05.05
                ,2,8,3,13,14,15,16,17,18,29,30,32,39,40,41,42,58,83,9,19,20,21,22,32,33,34,35,43,44,45,52,53,55,84,49,56,83
           ,4,7,3
                )    
            ) dat2 
      where 
          dat1.pfpai1 = dat2.pfpai1 
          and dat1.pftdo1 = dat2.pftdo1 
          and dat1.pfndo1 =dat2.pfndo1
          and  ( dat1.pjtdoc <> dat2.pjtdoc or dat1.pjndoc <> dat2.pjndoc )
    ; 
    
  /*grupos*/  
  cursor cur_grupos is     
    SELECT t.jaqy051corr FROM JAQY051 t
     where t.jaqy051pano = pa_perano
     and t.jaqy051pmes = pa_permes; --2016.12.27 se agrego mes y año
     
   -- where t.jaqy051corr = 5 --yordan test
    --;  
  
BEGIN
  /*si existe no se agrega - se sale*/
  
  /*para grupos de accionistas*/
  for rec_grupos in cur_grupos loop
      for rec_pjs in cur_pjs(rec_grupos.jaqy051corr) loop  
          
          /*son accionistas mayoritarios?*/
          if  FN_PC_MAYORIA(rec_pjs.pjpais,rec_pjs.pjtdoc,rec_pjs.pjndoc,1,pa_perano,pa_permes,rec_grupos.jaqy051corr) = 'S' then --propiedad
                --dbms_output.put_line('FN_PC_MAYORIA pase y dentro pro'); 
                SP_PC_DIR_INDIR(pa_perano,pa_permes,rec_pjs.pjpais,rec_pjs.pjtdoc,rec_pjs.pjndoc,1,rec_grupos.jaqy051corr) ;                          
         end if;
                       
      end loop;
  end loop;
  
  
  /*para grupo de directores*/
  for rec_grupos in cur_grupos loop
      for rec_pjs in cur_pjs(rec_grupos.jaqy051corr) loop    

        /*son accionistas mayoritarios?*/
        if  FN_PC_MAYORIA(rec_pjs.pjpais,rec_pjs.pjtdoc,rec_pjs.pjndoc,2,pa_perano,pa_permes,rec_grupos.jaqy051corr) = 'S' then --gestion
                --dbms_output.put_line('FN_PC_MAYORIA pase y dentro direc '); 
                 SP_PC_DIR_INDIR(pa_perano,pa_permes,rec_pjs.pjpais,rec_pjs.pjtdoc,rec_pjs.pjndoc,2,rec_grupos.jaqy051corr) ;          
         end if; 
         
      end loop;
  end loop;
  
exception
  when others then
    --dbms_output.put_line('SP_PC_PROPIEDAD_GESTION ' || sqlerrm);
    null;
  
END;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function FN_PC_MAYORIA( pa_pjpais number,
                        pa_pjtdoc number,
                        pa_pjndoc varchar2,
                        pa_tipmay  number,
                        --P_COD number,
                        pa_perano number,
                        pa_permes number,
                        pa_percor number
                        ) return varchar IS
  -- *****************************************************************
  -- Nombre                     : SP_PC_MAYORIA
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos
  -- Versión                    : 
  -- Fecha de Creación          : 
  -- Autor de Creación          : yyampi
  -- Uso                        : es mayoria?
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :                           
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- Descripción de Modificación: 
  -- ***************************************************************** 

numint number(10,2);
totint number(10,2);
porcen number(10,2);

BEGIN
  numint := 0;
  totint := 0;
  if pa_tipmay = 1 then  --accionistas
    
    select --/*+ parallel(t,5) parallel(r,5) */ 
           sum(t.pfpart)/100
      into numint
      --FROM fsr003 t, jaqy052-t r
      from fsr003 t, (table(pq_grupos_economicos_bt2.FN_CONSULTAR_ACCTA_TABLA(
                         pa_perano,pa_permes,pa_percor))) r
     where t.pjpais = pa_pjpais
       and t.pjtdoc = pa_pjtdoc
       and t.pjndoc = pa_pjndoc
       and t.pfpai1 = r.jaqy052tpais
       and t.pftdo1 = r.jaqy052ttdoc
       and t.pfndo1 = r.jaqly052tndoc
--       and r.jaqy052tcod = P_COD --yordan
       and t.vicod in (1,8,9,10,11,12,13,29,30,31,32,33,34,35,36,37,38,49,50,51,52,53,54,55,56,57,58,83,84
       ,2,4,3,7 --2017.05.05
       );
    
    SELECT --/*+ parallel(t,5) */ 
           sum(t.pfpart)/100
      into totint
      FROM fsr003 t
     where t.pjpais = pa_pjpais
       and t.pjtdoc = pa_pjtdoc
       and t.pjndoc = pa_pjndoc
       and t.vicod in (1,8,9,10,11,12,13,29,30,31,32,33,34,35,36,37,38,49,50,51,52,53,54,55,56,57,58,83,84
        ,2,4,3,7 --2017.05.05
       );
    
  elsif pa_tipmay = 2 then  --directivos y presidente direc
    
      select --/*+ parallel(t,5) parallel(r,5) */ 
             count(*)
      into numint
        --FROM fsr003 t, jaqy052-t r
      from fsr003 t, (table(pq_grupos_economicos_bt2.FN_CONSULTAR_DIRET_TABLA(
                         pa_perano,pa_permes,pa_percor))) r
       where 
           t.pjpais = pa_pjpais
           and t.pjtdoc = pa_pjtdoc
           and t.pjndoc = pa_pjndoc
           and t.pfpai1 = r.jaqy052tpais
           and t.pftdo1 = r.jaqy052ttdoc
           and t.pfndo1 = r.jaqly052tndoc
           --and r.jaqy052tcod = P_COD --yordan 
           and t.vicod IN (2,8,3,13,14,15,16,17,18,29,30,32,39,40,41,42,58,83,9,19,20,21,22,32,33,34,35,43,44,45,52,53,55,84,49,56,83
           ,4,7,3 --2017.05.05
           );
           --(2,8,3,14,15,16,17,18,29,30,32,39,40,41,42,58,83,9,19,20,21,22,32,33,34,35,43,44,45,52,53,55,84);
        
      select --/*+ parallel(t,5) parallel(r,5) */ 
             count(*)
      into totint
      from 
           fsr003 t
      where 
           t.pjpais = pa_pjpais
           and t.pjtdoc = pa_pjtdoc
           and t.pjndoc = pa_pjndoc
           and t.vicod IN (2,8,3,13,14,15,16,17,18,29,30,32,39,40,41,42,58,83,9,19,20,21,22,32,33,34,35,43,44,45,52,53,55,84,49,56,83
           ,4,7,3 --2017.05.05
           );
         --(2,8,3,14,15,16,17,18,29,30,32,39,40,41,42,58,83,9,19,20,21,22,32,33,34,35,43,44,45,52,53,55,84);
  end if;
  
  /*son mayoria ?*/
  begin
  porcen := round(numint/totint*100,1);  
  --dbms_output.put_line('numint '||numint|| ' - '||'totint '||totint);
  exception when others then porcen :=0; end;
  if porcen > 50 then
     return 'S';
  end if;  
return 'N';

exception
  when others then
    --dbms_output.put_line('FN_PC_MAYORIA ' || sqlerrm);
    return 'N';
END;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure SP_PC_DIR_INDIR(pa_perano number,
                          pa_permes number,          
                          pa_pjpais number,
                          pa_pjtdoc number,
                          pa_pjndoc varchar2,
                          pa_tipmay number,
                          pa_grupo  number
                          --,P_COD number
                          ) IS
  -- *****************************************************************
  -- Nombre                     : FN_PC_DIR_INDIR
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos
  -- Versión                    : 
  -- Fecha de Creación          : 
  -- Autor de Creación          : yyampi
  -- Uso                        : presuncion de control directa e indirecta
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :                           
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- Descripción de Modificación: 
  -- ***************************************************************** 
  c1        pq_grupos_economicos_bt2.cur_detalle_roles;
  r1        pq_grupos_economicos_bt2.re_integrantes;
  c2        pq_grupos_economicos_bt2.cur_detalle_roles;
  r2        pq_grupos_economicos_bt2.re_integrantes;

  cursor cur_pj_grupo is 
   SELECT  --/*+all_rows parallel(t,5) parallel(r,5) */ 
           distinct r.pjpais , r.pjtdoc, r.pjndoc
      FROM jaqy052 t , fsr003 r
     where t.jaqy051pano = pa_perano
       and t.jaqy051pmes = pa_permes
       and t.jaqy051corr = pa_grupo
       and t.jaqy052erel = 2
       and t.jaqy052esre = 'B'
       and r.pjpais = t.jaqy052pais
       and r.pjtdoc = t.jaqy052tdoc
       and r.pjndoc = t.jaqy052ndoc;   
   
    
  cursor cur_int_grupo(pa_pais number, pa_tdoc number, pa_ndoc number) is --integrantes del grupo eco
    SELECT --/*+all_rows parallel(t,5) parallel(r,5) */ 
           r.pfpai1, r.pftdo1, r.pfndo1
      FROM jaqy052 t , fsr003 r
     where t.jaqy051pano = pa_perano
       and t.jaqy051pmes = pa_permes
       and t.jaqy051corr = pa_grupo
       and t.jaqy052erel = 2
       and t.jaqy052esre = 'B'
       and r.pjpais = t.jaqy052pais
       and r.pjtdoc = t.jaqy052tdoc
       and r.pjndoc = t.jaqy052ndoc
       and t.jaqy052pais = pa_pais
       and t.jaqy052tdoc = pa_tdoc
       and t.jaqy052ndoc = pa_ndoc;
  
  ln_pfpart number(15,4) :=0;
  ln_isdire number(15,4) :=0;
 /* ln_existe number(15,4) :=0;*/
 ls_pais number(3);
 ls_tdoc number(2);
 ls_ndoc varchar2(12);
 ln_part varchar2(1):='N';     --verificar si paso participacion del 4%
 
BEGIN
  
  ln_part := 'N';
  IF pa_tipmay = 1 THEN  --ACCIONISTAS
    
      c1 := pq_grupos_economicos_bt2.FN_CONSULTAR_ACCTA(pa_perano,pa_permes,pa_grupo);
      LOOP 
        FETCH c1
        INTO  r1;
        EXIT WHEN c1%NOTFOUND;
                  
        /*tiene participacion ? mayor al 4%*/ 
        ----------------------------------------------------------------------- 
        for rec_pj in cur_pj_grupo loop --por persona juridica
         
                ln_pfpart :=0;  --yordan test            
                begin       
                      
                      SELECT --/*+ parallel(t,4) parallel(b,4) */ 
                             max(nvl(t.pfpart,0)) into  ln_pfpart            
                         FROM fsr003 t, jaqy052 b
                        where t.pjpais = b.jaqy052pais
                          and t.pjtdoc = b.jaqy052tdoc
                          and t.pjndoc = b.jaqy052ndoc
                          and b.jaqy052esre = 'B'
                          and b.jaqy052erel = 2
                          and t.vicod in (1,8,9,10,11,12,13,29,30,31,32,33,34,35,36,37,38,49,50,51,52,53,54,55,56,57,58,83,84
                          ,2,4,3,7 --2017.05.05
                          )                
                          and b.jaqy051corr = pa_grupo
                          and t.pfpai1 = r1.JAQY052TPAIS
                          and t.pftdo1 = r1.JAQY052TTDOC
                          and t.pfndo1 = rpad(r1.JAQLY052TNDOC,12,' ')-- and trim(t.pfndo1) = trim(REC_INT.JAQLY052TNDOC) 
                          -----
                          and rec_pj.pjpais= b.jaqy052pais
                          and rec_pj.pjtdoc= b.jaqy052tdoc
                          and rec_pj.pjndoc= b.jaqy052ndoc
                          ---
                            ;
                                
                exception when others then 
                  --dbms_output.put_line('SP_PC_DIR_INDIR select '||sqlerrm);
                  null;
                  end;    
                       
                --dbms_output.put_line(' partici indirec pa_pjndoc '||rec_pj.pjndoc|| ' - ' ||pa_pjndoc||' ln_pfpart: '||ln_pfpart);
                       
                 if ln_pfpart < 4 then --si la directa es mejor al 4% entonces ln_pfpart el contador de participacion
                   /*sumar la participacion de algun integrante del grupo que sea familia del integrante comun*/       
                   for rec_int_grupo in cur_int_grupo(rec_pj.pjpais,rec_pj.pjtdoc,rec_pj.pjndoc) loop
                        --dbms_output.put_line('entro a vinculos ') ;
                        /*pregu ntar si es conyuge o familiar*/
                        if FN_PC_VINCULO(r1.JAQY052TPAIS,r1.JAQY052TTDOC,r1.JAQLY052TNDOC,
                          rec_int_grupo.pfpai1,rec_int_grupo.pftdo1, rec_int_grupo.pfndo1) = 'S' then    
                          --dbms_output.put_line('entro a conyugueee') ;          
                         /*verifica si tiene mas del 4% de participacion en el grupo*/
                         ls_pais := rec_int_grupo.pfpai1;
                         ls_tdoc := rec_int_grupo.pftdo1;
                         ls_ndoc := rec_int_grupo.pfndo1;
                        begin                                        
                                  
                          SELECT --/*+ parallel(t,4) parallel(b,4) */ 
                                 max(nvl(t.pfpart,0)) + ln_pfpart into  ln_pfpart            
                             FROM fsr003 t, jaqy052 b
                            where t.pjpais = b.jaqy052pais
                              and t.pjtdoc = b.jaqy052tdoc
                              and t.pjndoc = b.jaqy052ndoc
                              and b.jaqy052esre = 'B'
                              and b.jaqy052erel = 2
                              and t.vicod in (1,8,9,10,11,12,13,29,30,31,32,33,34,35,36,37,38,49,50,51,52,53,54,55,56,57,58,83,84
                              ,2,4,3,7 --2017.05.05
                              )                 
                              and b.jaqy051corr = pa_grupo
                              and t.pfpai1 = rec_int_grupo.pfpai1
                              and t.pftdo1 = rec_int_grupo.pftdo1
                              --and trim(t.pfndo1) = trim(rec_int_grupo.pfndo1)
                              and t.pfndo1 = rpad(rec_int_grupo.pfndo1,12,' ')--
                              -----
                              and rec_pj.pjpais= b.jaqy052pais
                              and rec_pj.pjtdoc= b.jaqy052tdoc
                              and rec_pj.pjndoc= b.jaqy052ndoc
                              ----
                              ;
                                              
                                   
                           --dbms_output.put_line(' partici indirec consan o afini '||rec_pj.pjndoc|| ' - ' ||REC_INT.JAQLY052TNDOC ||' :  ' ||ls_ndoc||' ln_pfpart: '||ln_pfpart);

                           --YORDAN TEST 
                            IF ln_pfpart >= 4 THEN                        
                               SP_AGREGAR_INTCOMUN(pa_perano,pa_permes,pa_grupo,ls_pais,ls_tdoc,ls_ndoc,'R');
                               ln_part := 'S';  
                            END IF;
                            --YORDAN TEST 
                                                              
                        exception when others then 
                          --dbms_output.put_line('SP_PC_DIR_INDIR select  suma '||sqlerrm);
                          null;
                          end;                 
                        end if;          
                   end loop;
                         
                   /*preguntamos si sigue en menor a 4% */
                       if ln_pfpart < 4 then  --entonces preguntamos si es directivo         
                        /*es directivo?*/
                            begin 
                                 SELECT --/*+ parallel(t,4) parallel(r,4) */ 
                                        count(*) into ln_isdire
                                   FROM jaqy052 t, fsr003 r
                                  where t.jaqy051pano = pa_perano
                                    and t.jaqy051pmes = pa_permes
                                    and t.jaqy051corr = pa_grupo
                                    and t.jaqy052erel = 2
                                    and r.pjpais = t.jaqy052pais
                                    and r.pjtdoc = t.jaqy052tdoc
                                    and r.pjndoc = t.jaqy052ndoc
                                    and t.jaqy052esre = 'B'
                                    and r.vicod not in (1)
                                    and r.pfpai1 = r1.JAQY052TPAIS
                                    and r.pftdo1 = r1.JAQY052TTDOC
                                    and r.pfndo1 = r1.JAQLY052TNDOC
                                    --- 
                                    and rec_pj.pjpais= t.jaqy052pais
                                    and rec_pj.pjtdoc= t.jaqy052tdoc
                                    and rec_pj.pjndoc= t.jaqy052ndoc
                                    ---
                                    ; 
                                   -- dbms_output.put_line(' partici es cualquie cargo menos acc '||rec_pj.pjndoc|| ' - ' ||REC_INT.JAQLY052TNDOC ||' :  ');
                             exception when others then 
                                 --dbms_output.put_line('SP_PC_DIR_INDIR select  suma 2'||sqlerrm);
                                 null;
                             end;                                                                
                                if ln_isdire > 0 then     
                                    ln_part := 'S' ; -- no entra al grupo economico
                                end if;   
                                                   
                       end if; 
              else 
                ln_part := 'S';              
              end if; 
                 
         end loop;        
         ---------------------------------------------------------------------------------  
                                        
      END LOOP;
      CLOSE c1;
 
  ELSIF pa_tipmay = 2 THEN  --DIRECTORES
      
      c2 := pq_grupos_economicos_bt2.FN_CONSULTAR_DIRET(pa_perano,pa_permes,pa_grupo);
      LOOP          --por cada empresa pj   
        FETCH c2
        INTO  r2;
        EXIT WHEN c2%NOTFOUND;
        
          ---------------------------------------------------------
          for rec_pj in cur_pj_grupo loop --por persona juridica
                    /*tiene participacion ? mayor al 4%*/  
                    
                    begin            
                       SELECT --/*+ parallel(t,4) parallel(r,4) */ 
                              count(*)
                         into ln_isdire
                         FROM jaqy052 t, fsr003 r
                        where t.jaqy051pano = pa_perano
                          and t.jaqy051pmes = pa_permes
                          and t.jaqy051corr = pa_grupo
                          and t.jaqy052erel = 2
                          and r.pjpais = t.jaqy052pais
                          and r.pjtdoc = t.jaqy052tdoc
                          and r.pjndoc = t.jaqy052ndoc
                          and r.vicod not in (1)
                          and t.jaqy052esre = 'B'
                          and r.pfpai1 = r2.JAQY052TPAIS
                          and r.pftdo1 = r2.JAQY052TTDOC
                          and r.pfndo1 = r2.JAQLY052TNDOC
                          -----
                          and rec_pj.pjpais= t.jaqy052pais
                          and rec_pj.pjtdoc= t.jaqy052tdoc
                          and rec_pj.pjndoc= t.jaqy052ndoc
                          ---
                          ;  
                       exception when others then 
                        -- dbms_output.put_line('SP_PC_DIR_INDIR select 2 '||sqlerrm);              
                        null;
                        end; 
                         
                        
                        -- dbms_output.put_line(' entra a directores es director '||rec_pj.pjndoc|| ' - ' ||REC_INT.JAQLY052TNDOC||' '||ln_isdire);
                        
                         
                        if ln_isdire = 0 then  --no es directivo en el grupo 
                          /***********************************************************/
                         
                        begin 
                          
                           SELECT --/*+ parallel(t,4) parallel(b,4) */ 
                                  nvl(max(nvl(t.pfpart,0)),0) into  ln_pfpart            
                             FROM fsr003 t, jaqy052 b
                            where t.pjpais = b.jaqy052pais
                              and t.pjtdoc = b.jaqy052tdoc
                              --and trim(t.pjndoc) = trim(b.jaqy052ndoc)
                              and t.pjndoc = rpad(b.jaqy052ndoc,12,' ')
                              and b.jaqy052esre = 'B'
                              and b.jaqy052erel = 2
                              and t.vicod in (1,8,9,10,11,12,13,29,30,31,32,33,34,35,36,37,38,49,50,51,52,53,54,55,56,57,58,83,84
                              ,2,4,3,7 --2017.05.05
                              )                 
                              and b.jaqy051corr = pa_grupo
                              and t.pfpai1 = r2.JAQY052TPAIS
                              and t.pftdo1 = r2.JAQY052TTDOC
                              --and trim(t.pfndo1) = trim(REC_INT.JAQLY052TNDOC)
                              and t.pfndo1 = rpad(r2.JAQLY052TNDOC,12,' ')
                              -----
                              and rec_pj.pjpais= b.jaqy052pais
                              and rec_pj.pjtdoc= b.jaqy052tdoc
                              and rec_pj.pjndoc= b.jaqy052ndoc
                              ---
                              ;
                        
                       -- dbms_output.put_line('participacion en el grupo base '||rec_pj.pjndoc|| ' |- ' ||pa_grupo||' - '||REC_INT.JAQY052TPAIS||' - ln_pfpart '|| ln_pfpart||' - '||REC_INT.JAQLY052TNDOC||REC_INT.JAQLY052TNDOC);
                        
                                         
                             
                      --dbms_output.put_line('participacion a directores es director y es menor al 4 % '||rec_pj.pjndoc|| ' - ' ||REC_INT.JAQLY052TNDOC || ' - ' ||ln_pfpart||' - ' ||REC_INT.JAQLY052TNDOC);     
                             
                        exception when others then 
                          --dbms_output.put_line('error en particvipacion en directores '||sqlerrm );
                          null;
                        end;     

                          if ln_pfpart < 4 then --si la directa es mejor entonces 
                            --dbms_output.put_line(' entra a directores ,  vinculos  y es menor al 4 % '||rec_pj.pjndoc|| ' - ' || pa_pjndoc || ' - ' ||ln_pfpart||' - ' ||REC_INT.JAQLY052TNDOC);
                             for rec_int_grupo in cur_int_grupo(rec_pj.pjpais,rec_pj.pjtdoc,rec_pj.pjndoc) loop
                               --dbms_output.put_line('entro a vinculos direc') ;
                                  /*preguntar si es conyuge o familiar*/
                                  if FN_PC_VINCULO(r2.JAQY052TPAIS,r2.JAQY052TTDOC,r2.JAQLY052TNDOC,
                                    rec_int_grupo.pfpai1,rec_int_grupo.pftdo1, rec_int_grupo.pfndo1) = 'S' then              
                                    --dbms_output.put_line('entro a conyugueee') ;
                                   /*verifica si tiene mas del 4% de participacion en el grupo*/
                                   ls_pais := rec_int_grupo.pfpai1;
                                   ls_tdoc := rec_int_grupo.pftdo1;
                                   ls_ndoc := rec_int_grupo.pfndo1;
                                  
                                   begin  
                                       
                                           
                                        SELECT --/*+ parallel(t,4) parallel(b,4) */ 
                                               max(nvl(t.pfpart,0)) + ln_pfpart into  ln_pfpart            
                                         FROM fsr003 t, jaqy052 b
                                        where t.pjpais = b.jaqy052pais
                                          and t.pjtdoc = b.jaqy052tdoc
                                          and t.pjndoc = b.jaqy052ndoc
                                          and b.jaqy052esre = 'B'
                                          and b.jaqy052erel = 2
                                          and t.vicod in (1,8,9,10,11,12,13,29,30,31,32,33,34,35,36,37,38,49,50,51,52,53,54,55,56,57,58,83,84
                                          ,2,4,3,7 --2017.05.05
                                          )                
                                          and b.jaqy051corr = pa_grupo
                                          and t.pfpai1 = rec_int_grupo.pfpai1
                                          and t.pftdo1 = rec_int_grupo.pftdo1
                                          --and trim(t.pfndo1) = trim(rec_int_grupo.pfndo1) 
                                          and t.pfndo1 = rpad(rec_int_grupo.pfndo1,12,' ') 
                                          -----
                                          and rec_pj.pjpais= b.jaqy052pais
                                          and rec_pj.pjtdoc= b.jaqy052tdoc
                                          and rec_pj.pjndoc= b.jaqy052ndoc
                                          ---
                                            ;                          
                                     
                                   
                                       --YORDAN TEST 
                                       --dbms_output.put_line(' partici indirec consan o afini '||rec_pj.pjndoc|| ' - ' || REC_INT.JAQLY052TNDOC ||' :  ' ||ls_ndoc||' ln_pfpart: '||ln_pfpart);
                                       
                                      IF ln_pfpart >= 4 THEN                        
                                         SP_AGREGAR_INTCOMUN(pa_perano,pa_permes,pa_grupo,ls_pais,ls_tdoc,ls_ndoc,'R');  
                                      END IF; 
                                  exception when others then 
                                  --dbms_output.put_line('SP_PC_DIR_INDIR select  suma '||sqlerrm);
                                  null;
                                  end;            
                                                                     
                                 end if;                   
                                           
                             end loop;
                   
                             /*preguntamos si sigue en menor a 4% */
                                 if ln_pfpart >= 4 then                       
                                    ln_part := 'S' ; -- no entra al grupo economico                                                               
                            end if;      
                          /**************************************************************/
                  else                         
                      ln_part := 'S';                            
                  end if;
             else 
               ln_part := 'S';           
             end if; 
        end loop;            
          -------------------------------------------------                    
                                
      END LOOP;
      CLOSE c2;
  
  END IF;
   
 /* insertamos al grupo economico */
 
 if ln_part = 'S' then
   
     SP_AGREGAR_GRUPO(pa_perano,pa_permes,pa_grupo, pa_pjpais, pa_pjtdoc, pa_pjndoc,'P');
     
     if pa_tipmay = 1 then
            c1 := pq_grupos_economicos_bt2.FN_CONSULTAR_ACCTA(pa_perano,pa_permes,pa_grupo);
            LOOP 
                FETCH c1
                INTO  r1;
                EXIT WHEN c1%NOTFOUND;
                
                SP_AGREGAR_INTCOMUN(pa_perano,pa_permes,pa_grupo,r1.JAQY052TPAIS,r1.JAQY052TTDOC,r1.JAQLY052TNDOC,'P');
                                      
              END LOOP;
              CLOSE c1;

     else --if pa_tipmay = 2 then
            c2 := pq_grupos_economicos_bt2.FN_CONSULTAR_DIRET(pa_perano,pa_permes,pa_grupo);
            LOOP 
                FETCH c2
                INTO  r2;
                EXIT WHEN c2%NOTFOUND;
                
                SP_AGREGAR_INTCOMUN(pa_perano,pa_permes,pa_grupo,r2.JAQY052TPAIS,r2.JAQY052TTDOC,r2.JAQLY052TNDOC,'P');
                                      
              END LOOP;
              CLOSE c2;
               
     end if;
     
 
 end if;
   
/* if nvl(ls_ndoc,'N') <> 'N' then  
     SP_AGREGAR_INTCOMUN(pa_perano,pa_permes,pa_grupo,ls_pais,ls_tdoc,ls_ndoc,'P');          
 end if;  */  
    
     
     
exception
  when others then
   -- dbms_output.put_line('SP_PC_DIR_INDIR ' || sqlerrm);
   null;
    

    
END;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
FUNCTION FN_PC_VINCULO(  pa_pjpais1 number,
                          pa_pjtdoc1 number,
                          pa_pjndoc1 varchar2,
                          pa_pjpais2 number,
                          pa_pjtdoc2 number,
                          pa_pjndoc2 varchar2
                          ) RETURN VARCHAR IS
  -- *****************************************************************
  -- Nombre                     : SP_PC_VINCULO
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos
  -- Versión                    : 
  -- Fecha de Creación          : 
  -- Autor de Creación          : yyampi
  -- Uso                        : relacion de hasta 2do grado de consaguinidad y 1ro de afinidad
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :                           
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- Descripción de Modificación: 
  -- ***************************************************************** 

     
  ln_existe1 number(10) := 0;
  ln_existe2 number(10) := 0;
  
BEGIN
  /*( Consanguin) derecha*/
   select --/*+ parallel(t,5) */ 
          COUNT(*)
     INTO ln_existe1
     from fsr002 t
    where t.pepais = pa_pjpais2
      and t.petdoc = pa_pjtdoc2
      and t.pendoc = pa_pjndoc2
      and t.rppais = pa_pjpais1
      and t.rptdoc = pa_pjtdoc1
      and t.rpndoc = pa_pjndoc1
      and t.rpccyg in (71, 69, 68, 63, 70);
      
   /*( afinidad) izquierda*/
   select --/*+ parallel(t,5) */ 
          count(*)
     into ln_existe2
     from fsr002 t
    where t.pepais = pa_pjpais1
      and t.petdoc = pa_pjtdoc1
      and t.pendoc = pa_pjndoc1
      and t.rppais = pa_pjpais2
      and t.rptdoc = pa_pjtdoc2
      and t.rpndoc = pa_pjndoc2
      and t.rpccyg in (66, 75, 67);   
  
   if ln_existe1  <> 0 or ln_existe2 <> 0 then 
     return 'S';
   end if;
  
  return 'N';

exception
  when others then
    --dbms_output.put_line('FN_PC_VINCULO ' || sqlerrm);
    return 'N';
END;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

procedure SP_AGREGAR_INTCOMUN(pa_perano number,
                              pa_permes number,
                              pa_corr   number,
                              pa_pjpais number,
                              pa_pjtdoc number,
                              pa_pjndoc varchar2,
                              pa_pjesre varchar2
                           ) IS
  -- *****************************************************************
  -- Nombre                     : SP_FORMAR_GRUPO
  -- Sistema                    : BANTOTAL
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


intcorr number(15) := 0;
intExiste number(15) :=0;

BEGIN 
  
/*si existe no se agrega - se sale*/
SELECT --/*+ parallel(t,5) */ 
       count(*) into intExiste   
  FROM JAQY052 t
 where t.jaqy051pano = pa_perano
   and t.jaqy051pmes = pa_permes
   and t.jaqy052pais = pa_pjpais
   and t.jaqy052tdoc = pa_pjtdoc
   and t.jaqy052ndoc = pa_pjndoc
   and t.jaqy051corr = pa_corr;

if intExiste <> 0 then 
  --dbms_output.put_line('se tiene ya registrado ' ||pa_pjndoc );
  return;
end if;

/*calculamos el correlativo*/  
SELECT --/*+ parallel(t,5) */ 
       nvl(max(jaqy052corr),0) + 1
  into intcorr
  FROM JAQY052 t
 where t.jaqy051pano = pa_perano
   and t.jaqy051pmes = pa_permes
   and t.jaqy051corr = pa_corr;

/*insertar detalle*/
INSERT INTO JAQY052
  (JAQY051PANO,
   JAQY051PMES,
   JAQY051CORR,
   JAQY052CORR,
   JAQY052PAIS,
   JAQY052TDOC,
   JAQY052NDOC,
   JAQY052EREL,
   JAQY052ESRE)
VALUES
  (pa_perano,
   pa_permes,
   pa_corr,
   intcorr,
   pa_pjpais,
   pa_pjtdoc,
   (pa_pjndoc),
   1,
   pa_pjesre);
   
   commit;   --yordan 
   
END;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
function FN_VALIDAR_GRUPO( pa_perano number,
                           pa_permes number,                           
                           pa_pjpais number,
                           pa_pjtdoc number,
                           pa_pjndoc varchar2, 
                           pa_pjpaiso number,
                           pa_pjtdoco number,
                           pa_pjndoco varchar2,
                           --P_COD NUMBER,
                           pa_cont number                           
                           ) return varchar2 IS
  -- *****************************************************************
  -- Nombre                     : SP_VALIDAR_GRUPO
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos
  -- Versión                    : 
  -- Fecha de Creación          : 
  -- Autor de Creación          : yyampi
  -- Uso                        : VERIFICACION SI EXISTE UN GRUPO
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :                           
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- Descripción de Modificación: 
  -- *****************************************************************                          

conta1 number(15) := 0;
conta2 number(15) := 0;

cursor gruposE is 
SELECT --/*+ parallel(t,5) */ 
       T.JAQY051CORR , 
       COUNT(*) conta 
FROM 
       JAQY052 T 
WHERE 
       T.JAQY051PANO = pa_perano
       AND T.JAQY051PMES = pa_permes
       AND T.JAQY052PAIS in (pa_pjpais, pa_pjpaiso)
       AND T.JAQY052TDOC IN (pa_pjtdoc,pa_pjtdoco)
       --AND TRIM(T.JAQY052NDOC) IN (TRIM(pa_pjndoc),TRIM(pa_pjndoco))  
       AND T.JAQY052NDOC IN (rpad(pa_pjndoc,12,' '),rpad(pa_pjndoco,12,' '))  
       and t.jaqy052erel = 2
GROUP BY 
      T.JAQY051CORR;



BEGIN 
/*si existe no se agrega - se sale*/

conta1 := pa_cont;

for  gruposR in gruposE loop
  
  SELECT 
          count(*) conta
                   into conta2
   FROM 
          JAQY052 t , (/*--jaqy052-t--*/
                       select d.jaqy052tpais, 
                              d.jaqy052ttdoc, 
                              d.jaqly052tndoc
                       from 
                              table(pq_grupos_economicos_bt2.FN_CONSULTAR_INTEGRANTES(
                              pa_pjpais,pa_pjtdoc,pa_pjndoc,pa_pjpaiso,pa_pjtdoco,pa_pjndoco
                              )) d 
                       ) r
   where 
          r.jaqy052tpais = t.jaqy052pais
          and r.jaqy052ttdoc = t.jaqy052tdoc
          and r.jaqly052tndoc = rpad(t.jaqy052ndoc,12,' ')
          and t.jaqy051pano = pa_perano
          and t.jaqy051pmes = pa_permes
          and t.jaqy051corr = gruposR.JAQY051CORR
          AND T.JAQY052EREL = 1;
          
          --and r.jaqy052tcod = P_COD -- yordan 
     

  --DBMS_OUTPUT.put_line('pa_pjndoc '||pa_pjndoc||' - '||'pa_pjndoco'||pa_pjndoco);
  --DBMS_OUTPUT.put_line('conta1 '||conta1 );
  --DBMS_OUTPUT.put_line('conta2 '||conta2 );
  
  if (conta2 = conta1) and (conta1 > 0  and conta2 > 0 ) then   
     return 'N';
  end if;   
end loop;  
  
return 'S';
   
exception when others then   
  --dbms_output.put_line('ERROR SP_CREAR_GRUPO '||sqlerrm );
  return 'N';   
END;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
procedure SP_ACTUALIZAR_GRUPO( pa_perano number,
                           pa_permes number                                                 
                           )  IS
  -- *****************************************************************
  -- Nombre                     : FN_ACTUALIZAR_GRUPO
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos
  -- Versión                    : 
  -- Fecha de Creación          : 
  -- Autor de Creación          : yyampi
  -- Uso                        : VERIFICACION SI EXISTE UN GRUPO
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :                           
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- Descripción de Modificación: 
  -- *****************************************************************                          

 ld_fecha date; 

cursor gruposEcab is
SELECT --2017 /*+ parallel(t,5) */
       t.jaqy051pano,
       t.jaqy051pmes,
       t.jaqy051corr,
       t.jaqy051pais,
       t.jaqy051tdoc,
       t.jaqy051ndoc
  FROM 
       jaqy051 t
 where 
       t.jaqy051pano = pa_perano
       and t.jaqy051pmes = pa_permes;

cursor gruposEdet(pa_corr in number) is
 SELECT 
       dat.jaqy051corr, 
       dat.jaqy052pais, 
       dat.jaqy052tdoc, 
       dat.jaqy052ndoc, 
       min(dat.aofval) aofval 
FROM (  
     SELECT --2017 /*+all_rows parallel(t,5) parallel(a,5) parallel(b,5) */
           t.jaqy051pano, 
           t.jaqy051pmes, 
           t.jaqy051corr, 
           t.jaqy052pais, 
           t.jaqy052tdoc, 
           t.jaqy052ndoc, 
           a.aofval 
     FROM 
           jaqy052 t, 
           fsd010 a , 
           fsr008 b
     where 
           t.jaqy051pano = pa_perano
           and t.jaqy051pmes = pa_permes   
           and b.pepais = t.jaqy052pais
           and b.petdoc = t.jaqy052tdoc
           and b.pendoc = t.jaqy052ndoc
           and a.pgcod = 1
           and a.aocta = b.ctnro
           and b.ttcod = 1  
           and t.jaqy051corr = pa_corr      
           and t.jaqy052esre= 'B'
     ) dat
   group by 
         dat.jaqy051corr,
         dat.jaqy052pais, 
         dat.jaqy052tdoc, 
         dat.jaqy052ndoc ;
  


BEGIN 
/*si existe no se agrega - se sale*/


for  gruposRcab in gruposEcab loop  
    For gruposRdet in gruposEdet(gruposRcab.jaqy051corr) loop 
      if ld_fecha is null then 
        ld_fecha := gruposRdet.Aofval;
      else   
        if gruposRdet.Aofval < ld_fecha  then 
          
          ld_fecha := gruposRdet.Aofval;
          
          UPDATE 
                jaqy051 s 
          SET 
                s.jaqy051pais = gruposRdet.Jaqy052pais, 
                s.jaqy051tdoc = gruposRdet.Jaqy052tdoc, 
                s.jaqy051ndoc = gruposRdet.Jaqy052ndoc
          where 
                s.jaqy051corr = gruposRdet.Jaqy051corr 
                and s.jaqy051pano = pa_perano
                and s.jaqy051pmes = pa_permes;
          
          commit;
                    
        end if; 
      end if; 
    end loop ;    
end loop;  

   
exception when others then   
  --dbms_output.put_line('ERROR FN_ACTUALIZAR_GRUPO '||sqlerrm );     
  null;
END;

procedure SP_ADD_PAR( pa_perano number,
                           pa_permes number                                                 
                           )  IS
  -- *****************************************************************
  -- Nombre                     : FN_ACTUALIZAR_GRUPO
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos
  -- Versión                    : 
  -- Fecha de Creación          : 
  -- Autor de Creación          : yyampi
  -- Uso                        : VERIFICACION SI EXISTE UN GRUPO
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :                           
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- Descripción de Modificación: 
  -- *****************************************************************                          

 ld_fecha date; 

cursor gruposEcab is
SELECT --2017 /*+ parallel(t,5) */
       t.jaqy051pano,
       t.jaqy051pmes,
       t.jaqy051corr,
       t.jaqy051pais,
       t.jaqy051tdoc,
       t.jaqy051ndoc
  FROM jaqy051 t
 where t.jaqy051pano = pa_perano
   and t.jaqy051pmes = pa_permes;

cursor gruposEdet(pa_corr in number) is
 SELECT dat.jaqy051corr, dat.jaqy052pais, dat.jaqy052tdoc, dat.jaqy052ndoc , min(dat.aofval) aofval FROM (  
 SELECT --2017-- /*+all_rows parallel(t,5) parallel(a,5) parallel(b,5) */
        t.jaqy051pano, t.jaqy051pmes, t.jaqy051corr, t.jaqy052pais, t.jaqy052tdoc, t.jaqy052ndoc, a.aofval 
   FROM jaqy052 t, fsd010 a , fsr008 b
  where t.jaqy051pano = pa_perano
    and t.jaqy051pmes = pa_permes   
    and b.pepais = t.jaqy052pais
    and b.petdoc = t.jaqy052tdoc
    and b.pendoc = t.jaqy052ndoc
    and a.aocta = b.ctnro
    and b.ttcod = 1  
    and t.jaqy051corr = pa_corr      
    and t.jaqy052esre= 'B'
    ) dat
   group by dat.jaqy051corr,dat.jaqy052pais, dat.jaqy052tdoc, dat.jaqy052ndoc ;
  


BEGIN 
/*si existe no se agrega - se sale*/


for  gruposRcab in gruposEcab loop  
    For gruposRdet in gruposEdet(gruposRcab.jaqy051corr) loop 
      if ld_fecha is null then 
        ld_fecha := gruposRdet.Aofval;
      else   
        if gruposRdet.Aofval < ld_fecha  then 
          ld_fecha := gruposRdet.Aofval;
          UPDATE jaqy051 s SET s.jaqy051pais = gruposRdet.Jaqy052pais , 
          s.jaqy051tdoc = gruposRdet.Jaqy052tdoc , s.jaqy051ndoc = gruposRdet.Jaqy052ndoc
          where s.jaqy051corr = gruposRdet.Jaqy051corr 
          and s.jaqy051pano = pa_perano
          and s.jaqy051pmes = pa_permes
          ;          
        end if; 
      end if; 
    end loop ;    
end loop;  

   
exception when others then   
  --dbms_output.put_line('ERROR FN_ACTUALIZAR_GRUPO '||sqlerrm ); 
  null;    
END;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure SP_ACTUALIZA_JAQY610  IS
  -- *****************************************************************
  -- Nombre                     : SP_ACTUALIZA_JAQY610
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos
  -- Versión                    : 
  -- Fecha de Creación          : 
  -- Autor de Creación          : 
  -- Uso                        : Inserta en JAQY610
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :                           
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- Descripción de Modificación: 
  -- *****************************************************************                          


  indice number(18) := 0;
  indice2 number(18) := 1;
  limite number(18) := 0;
  cursor persona is 
  SELECT t.pjpais,t.pjtdoc,t.pjndoc FROM fsd003 t ;


BEGIN  
  delete  jaqy610;
  
  ---
  begin
    
    SELECT 
          t.tp1nro1 into limite
    FROM 
          fst198 t
    where 
       t.tp1cod = 1 
       and t.tp1cod1 = 10858
       and t.tp1corr1 = 3
       and t.tp1corr2 = 1
       and t.tp1corr3 = 1 ;
  exception when others then
    limite := 0;
  end;
  ---
  
  
  for persona_cur in persona loop    
      if indice = limite  then 
        indice2 := indice2 + 1 ;
        indice := 1 ;
      else 
        indice := indice +1;
      end if ;        
      INSERT INTO jaqy610 values(indice2, persona_cur.pjpais,persona_cur.pjtdoc,persona_cur.pjndoc);         
  end loop;               

COMMIT; 



END SP_ACTUALIZA_JAQY610;

-- -- -- -
procedure SP_JOB_GRUPOS( pa_perano number,
                         pa_permes number                                                 
                        )  IS
  -- *****************************************************************
  -- Nombre                     : FN_ACTUALIZAR_GRUPO
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos
  -- Versión                    : 
  -- Fecha de Creación          : 
  -- Autor de Creación          : yyampi
  -- Uso                        : VERIFICACION SI EXISTE UN GRUPO
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :                           
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- Descripción de Modificación: 
  -- *****************************************************************                          

--lc_prcsobend varchar2(400);
ln_count number(10);
ln_limit number(18);
lc_variable varchar2(1000);

--ln_indpro NUMBER(18);
job_id number;
ln_numjob number;
lc_hostname varchar2(64);
lc_jobs     number(9) := 0;

BEGIN



     execute immediate 'ALTER SESSION SET commit_wait=''NOWAIT''';
     execute immediate 'ALTER SESSION SET commit_logging=''BATCH''';
    -- execute immediate 'ALTER SESSION SET optimizer_mode=''FIRST_ROWS_10''';

  /*limpiar*/
  delete from jaqy052 t where t.jaqy051pano= pa_perano and t.jaqy051pmes = pa_permes;
  delete from jaqy051 t where t.jaqy051pano= pa_perano and t.jaqy051pmes = pa_permes;
  delete from JAQZ460;
  commit;


  begin
    select host_name
      into lc_hostname
      from v$instance;
  end;
 

   --SELECT max(t.cod) FROM jaqy610 t;
   SELECT max(t.cod) INTO ln_limit  FROM jaqy610 t;   

   FOR i IN 1 .. ln_limit LOOP

      ln_count := i;
      lc_variable := 'begin '||' pq_grupos_economicos_bt2.SP_CR_GRUPOS_ECONOMICOS('||pa_perano||','||pa_permes||','||ln_count||'); '||' end;';
          /*  sys.dbms_job.submit(
                job_id,
                what => lc_variable,
                next_date => sysdate
                 );     */       


--          if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then   
IF SYS.FN_BD_ISRAC='TRUE' THEN          
             DBMS_JOB.SUBMIT(job => job_id, 
                          what => lc_variable,
                          next_date => sysdate+1/(24*60),
                          interval => null,
                          no_parse => false,
                          instance => 1,
                          --instance => 2, 01/01/2024
                          force => false
                          );
            else
              DBMS_JOB.SUBMIT(job => job_id, 
                          what => lc_variable,
                          next_date => sysdate+1/(24*60),
                          interval => null,
                          no_parse => false,
                          force => false
                          );
            end if;
    



           
         --controlar jobs
            begin
               select count(*) 
                 into ln_numjob  
                 from JAQZ460;
            end;
            
            ln_numjob := ln_numjob + 1;
            INSERT INTO JAQZ460 (JAQZ460COR,JAQZ460COD,JAQZ460NUM, JAQZ460DES, JAQZ460FIN)
              VALUES(ln_numjob, 'GPE',ln_count, 'pq_grupos_economicos_bt2', sysdate);
            COMMIT; 
           
     commit;
   END LOOP;  
   
   lc_jobs := fn_cr_verifica_jobs();
  
   While lc_jobs > 0 loop
        lc_jobs := fn_cr_verifica_jobs();
   End loop; 
   
   SP_PC_PROPIEDAD_GESTION(pa_perano, pa_permes);
  
   SP_ACTUALIZAR_GRUPO(pa_perano, pa_permes);

   
exception when others then   
  --dbms_output.put_line('ERROR FN_ACTUALIZAR_GRUPO '||sqlerrm );     
  null;
END SP_JOB_GRUPOS;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure SP_INSERTA_REPORTE_Ini( pa_perano number,
                              pa_permes number                                                 
                           )  IS
  -- *****************************************************************
  -- Nombre                     : SP_INSERTA_REPORTE
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos
  -- Versión                    : 
  -- Fecha de Creación          : 
  -- Autor de Creación          : DCASTRO
  -- Uso                        : INSERTA PARA GENERACION DE REPORTE
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :                           
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación: 
  -- Descripción de Modificación: 
  -- *****************************************************************                          

ld_fecpro  date;
ld_fecrcc  date;

begin


ld_fecpro := last_day(to_date(to_char(pa_perano)|| lpad(to_char(pa_permes),2,'0')||'01','yyyymmdd'));

begin
     select to_date(tpnro,'ddmmyyyy')
          into ld_fecrcc 
     from fst098 where tpcod = 7647 and tpcorr =12; 
end;



  delete from JAQZ461 t where t.jaqz461pano = pa_perano and t.jaqz461pmes = pa_permes; 
  commit;
   
  
  insert into JAQZ461 (
  jaqz461pano, jaqz461pmes, jaqz461cor, jaqz461pais, jaqz461nom, jaqz461sbs, jaqz461tcli, jaqz461dcli, 
  jaqz461ndoc, jaqz461dirc, jaqz461rleg, jaqz461deuc, jaqz461paiv, jaqz461nomv, jaqz461sbsv, jaqz461tcliv, 
  jaqz461dcliv, jaqz461ndocv, jaqz461dirv, jaqz461acci, jaqz461car1, jaqz461car2, jaqz461deuv, jaqz461ges
  )
  select --/*+all_rows parallel(a,5) parallel(b,5) parallel(d,5) parallel(f,5) parallel(g,5)*/
  distinct a.jaqy055perano AÑO,
           a.jaqy055permes MES,
           a.jaqy055nrov CORRELATIVO,
           a.jaqy055pais PAIS_CLIENTE,
           d.penom NOMBRE_CLIENTE,
           (select rcc.c_codsbs
              from cldrcci rcc
             where rcc.d_fecpre = ld_fecrcc
               and (rcc.c_doctri = trim(a.jaqy055ndoc) or
                   rcc.c_docide = trim(a.jaqy055ndoc))
               and rownum = 1) CODIGO_SBS_CLIENTE,
           decode(d.petipo, 'F', 'NAT', 'J', 'JUR', 'NC') TIPO_PER_CLIENTE,
           b.tdnom TIPO_DOC_CLIENTE,
           a.jaqy055ndoc NUMERO_DOC_CLIENTE,
           (select trim(t.Sngc13dir) || ', ' || trim(di.fst071dsc) || ', ' ||
                   trim(pr.locnom) || ', ' || trim(de.depnom) || ', ' ||
                   trim(pa.panom)
              from SNGC13 t, fst071 di, FST070 pr, fst068 de, fst013 pa
             where di.fst071pai = a.jaqy055pais -- dist
               and di.fst071dpt = t.sngc13dpto
               and di.fst071loc = t.sngc13prov
               and di.fst071col = t.sngc13ugeo
               and pr.pais = a.jaqy055pais -- prov
               and pr.depcod = t.sngc13dpto
               and pr.loccod = t.sngc13prov
               and de.pais = a.jaqy055pais -- dep
               and de.depcod = t.sngc13dpto
               and pa.pais = a.jaqy055pais -- pais                     
               and t.docod = 1
               and t.sngc13tdoc = a.jaqy055tdoc
               and t.sngc13ndoc = a.jaqy055ndoc
               AND ROWNUM = 1) DIRECCION_CLIENTE,
           (select pers.penom
              from fsr003 j, fsd001 pers
             WHERE pers.pendoc = j.pfndo1
               and j.pjpais = a.jaqy055pais
               and j.pjtdoc = a.jaqy055tdoc
               and j.pjndoc = a.jaqy055ndoc
               and j.vicod in
                   --(7, 18, 22, 25, 27, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 51, 84)
                   (7,2,3,8,4) --20170505
               and rownum = 1) REPRESENTANTE_LEGAL,
           /*(select\*+parallel(sh,4,1) parallel(cl,4,1)*\ sh.BCActi from fsh012 sh, fsr008 cl where sh.bcemp=1 and sh.bcfech=to_date('31/12/2015','dd/mm/rrrr')
                                     and sh.bcprod = 0 and sh.bccta=cl.ctnro and cl.pepais=a.jaqy055pais and cl.petdoc=a.jaqy055tdoc 
                                     and cl.pendoc=a.jaqy055ndoc and cl.ttcod=1 and cl.cttfir='T' and rownum=1 ) CIIU_CLIENTE, */
           (select SUM(s.jaql114sdmn)
              from jaql114 s
             where s.jaql114fech = ld_fecpro
               and s.jaql114pais = a.jaqy055pais
               and s.jaql114tdoc = a.jaqy055tdoc
               and s.jaql114ndoc = a.jaqy055ndoc
               and s.jaql114mod <> 33) DEUDA_CLIENTE,
           a.jaqy055paiv PAIS_VINCULADO,
           f.penom NOMBRE_VINCULADO,
           (select rcc.c_codsbs
              from cldrcci rcc
             where rcc.d_fecpre = ld_fecrcc
               and (rcc.c_doctri = trim(a.jaqy055ndov) or
                   rcc.c_docide = trim(a.jaqy055ndov))
               and rownum = 1) CODIGO_SBS_VINCULADO,
           decode(f.petipo, 'F', 'NAT', 'J', 'JUR', 'NC') TIPO_PER_VINCULADO,
           g.tdnom TIPO_DOC_VINCULADO,
           a.jaqy055ndov NUMERO_DOC_VINCULADO,
           (select trim(t.Sngc13dir) || ', ' || trim(di.fst071dsc) || ', ' ||
                   trim(pr.locnom) || ', ' || trim(de.depnom) || ', ' ||
                   trim(pa.panom)
              from SNGC13 t, fst071 di, FST070 pr, fst068 de, fst013 pa
             where di.fst071pai = a.jaqy055paiv -- dist
               and di.fst071dpt = t.sngc13dpto
               and di.fst071loc = t.sngc13prov
               and di.fst071col = t.sngc13ugeo
               and pr.pais = a.jaqy055paiv -- prov
               and pr.depcod = t.sngc13dpto
               and pr.loccod = t.sngc13prov
               and de.pais = a.jaqy055paiv -- dep
               and de.depcod = t.sngc13dpto
               and pa.pais = a.jaqy055paiv -- pais                     
               and t.docod = 1
               and t.sngc13est = 'H'
               and t.sngc13tdoc = a.jaqy055tdov
               and t.sngc13ndoc = a.jaqy055ndov
               AND ROWNUM = 1) DIRECCION_VINCULADO,
           (select j.pfpart
              from fsr003 j
             WHERE j.pjpais = a.jaqy055pais
               and j.pjtdoc = a.jaqy055tdoc
               and j.pjndoc = a.jaqy055ndoc
               and j.pfpai1 = a.jaqy055paiv
               and j.pftdo1 = a.jaqy055tdov
               and j.pfndo1 = a.jaqy055ndov
               and rownum = 1) ACCIONISTA,
           (select case
                     when dv.vinom like '%PR DIR%' THEN
                      1
                     when dv.vinom like '%DIR%' THEN
                      2
                     when dv.vinom like '%GER%' THEN
                      3
                     when dv.vinom like '%PR FUN%' THEN
                      4
                     when dv.vinom like '%ASE%' THEN
                      5
                     else
                      0
                   end cargo
              from fsr003 j, fst020 dv
             WHERE dv.vicod = j.vicod
               and j.pjpais = a.jaqy055pais
               and j.pjtdoc = a.jaqy055tdoc
               and j.pjndoc = a.jaqy055ndoc
               and j.pfpai1 = a.jaqy055paiv
               and j.pftdo1 = a.jaqy055tdov
               and j.pfndo1 = a.jaqy055ndov
               and rownum = 1) CARGO,
           
           (select case
                     when dv.vinom not like '%PR DIR%' and
                          dv.vinom not like '%DIR%' and
                          dv.vinom not like '%GER%' and
                          dv.vinom not like '%PR FUN%' and
                          dv.vinom not like '%ASE%' and
                          dv.vinom not like '%ACC%' THEN
                      6
                     else
                      0
                   end cargo
              from fsr003 j, fst020 dv
             WHERE dv.vicod = j.vicod
               and j.pjpais = a.jaqy055pais
               and j.pjtdoc = a.jaqy055tdoc
               and j.pjndoc = a.jaqy055ndoc
               and j.pfpai1 = a.jaqy055paiv
               and j.pftdo1 = a.jaqy055tdov
               and j.pfndo1 = a.jaqy055ndov
               and rownum = 1) OTRO_CARGO,
           (select SUM(s.jaql114sdmn)
              from jaql114 s
             where s.jaql114fech = ld_fecpro
               and s.jaql114pais = a.jaqy055paiv
               and s.jaql114tdoc = a.jaqy055tdov
               and s.jaql114ndoc = a.jaqy055ndov
               and s.jaql114mod <> 33) DEUDA_VINCULADO,
           a.jaqy055tipo GESTION
  
    from jaqy055 a, fst014 b, fsd001 d, fsd001 f, fst014 g
   where a.jaqy055tdoc = b.tdocum
     and a.jaqy055tdov = g.tdocum
     and d.pepais = a.jaqy055pais
     and d.petdoc = a.jaqy055tdoc
     and d.pendoc = a.jaqy055ndoc
     and f.pepais = a.jaqy055paiv
     and f.petdoc = a.jaqy055tdov
     and f.pendoc = a.jaqy055ndov
     and a.jaqy055perano = pa_perano
     and a.jaqy055permes = pa_permes
        --  and a.jaqy055nrov is not null
     and a.jaqy055tipo is not null;

     commit;
   
exception when others then   
  --dbms_output.put_line('ERROR GENERAR REPORTE '||sqlerrm );    
  null; 
END SP_INSERTA_REPORTE_Ini;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

 function fn_ciiu_codigo(P_PAIS   in number,
                          P_PETDOC in number,   
                          P_PENDOC in char
                         ) return number
  is
    ln_codciiu fst750.actcod1%type;
    lv_petipo varchar2(1);
  Begin
     
    lv_petipo := pq_client_ciiu.fn_petipo(P_PAIS,P_PETDOC,P_PENDOC);
    
    If lv_petipo = 'F' Then
       Begin
            Select c60.sngc60acte
              Into ln_codciiu
              From sngc60 c60
             Where c60.sngc60pais = P_PAIS
               And c60.sngc60tdoc = P_PETDOC
               And c60.sngc60ndoc = P_PENDOC
               And c60.sngc60corr = 0;       
       Exception when others then
          ln_codciiu := 0;       
       End;
    End If;                           
    
    If lv_petipo = 'J' Then
       Begin
            Select e001.expnins
              Into ln_codciiu
              From fse001 e001
             Where e001.d511pais = P_PAIS
               And e001.d511tdoc = P_PETDOC
               And e001.d511ndoc = P_PENDOC;       
       Exception when others then
          ln_codciiu := 0;       
       End; 
    End If;
    
    Return ln_codciiu;
        
  end fn_ciiu_codigo;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function FN_SUMA_ACCIONES(pa_pjpaisc number,
                         pa_pjtdocc number,
                         pa_pjndocc varchar2,
                         pa_pfpai1 number,
                         pa_pftdo1 number,
                         pa_pfndo1 varchar2) return number IS
  -- *****************************************************************
  -- Nombre                     : FN_SUMA_ACCIONES
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos
  -- Versión                    : 
  -- Fecha de Creación          : 
  -- Autor de Creación          : jrodriguej
  -- Uso                        : sumatoria de acciones
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :                           
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- Descripción de Modificación: 
  -- *****************************************************************                          

  resultado number(15) := 0;
  
BEGIN
   
  /*-------------------------------------*/
  select 
       sum(nvl(bb.pfpart,0)) into resultado
  FROM 
       fsr003 bb
  where 
       bb.pjpais = pa_pjpaisc
       and bb.pjtdoc = pa_pjtdocc
       and bb.pjndoc = pa_pjndocc 
       and bb.pfpai1 = pa_pfpai1                     
       and bb.pftdo1 = pa_pftdo1                  
       and bb.pfndo1 = pa_pfndo1;
         
  return resultado;   
  
exception
  when others then
    --dbms_output.put_line('SP_CREAR_GRUPO ' || sqlerrm);
    return 0;
  
END;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function FN_SUMA_MINIMO(pa_min1 number,
                        pa_min2 number) return number IS
  -- *****************************************************************
  -- Nombre                     : FN_SUMA_MINIMO
  -- Sistema                    : BANTOTAL
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
  tp1cod1t number(15):= 10858;
  tp1corr1t number(15) := 2;
  tp1corr2t number(15) := 1;
  tp1corr3t number(15) := 1;
  tp1nro1t number(15) := 0; 
  
BEGIN
  /*si existe no se agrega - se sale*/
  
  SELECT t.tp1nro1 into tp1nro1t
    FROM fst198 t
   where 
     t.tp1cod = 1 
     and t.tp1cod1 = tp1cod1t
     and t.tp1corr1 = tp1corr1t
     and t.tp1corr2 = tp1corr2t
     and t.tp1corr3 = tp1corr3t;
   
  if pa_min1 > tp1nro1t and pa_min2 > tp1nro1t then 
    return 1;
  end if;
  
  return 0;   
  
exception
  when others then
    --dbms_output.put_line('SP_CREAR_GRUPO ' || sqlerrm);
    return 0;
  
END;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
FUNCTION FN_CONSULTAR_INTEGRANTES (pa_pjpais number, 
                       pa_pjtdoc number, 
                       pa_pjndoc varchar2,
                       pa_pjpaiso number, 
                       pa_pjtdoco number, 
                       pa_pjndoco varchar2) 
    RETURN tb_integrantes PIPELINED IS
    l_row re_integrantes;
      
   cursor  cur_pj_int is
    select 
         distinct 
              a.pfpai1 tpais, 
              a.pftdo1 ttdoc, 
              a.pfndo1 tndoc
      from (SELECT t.pfpai1, t.pftdo1, t.pfndo1
              FROM fsr003 t
             where t.pjpais = pa_pjpais
               and t.pjtdoc = pa_pjtdoc
               and t.pjndoc = pa_pjndoc
               and t.vicod in (1,8,9,10,11,12,13,29,30,31,32,33,34,35,36,37,38,49,50,51,52,53,54,55,56,57,58,83,84
                 ,2,4,3,7 
                 )  ) a,
           (SELECT 
                   t.pfpai1, t.pftdo1, t.pfndo1
              FROM fsr003 t
             where t.pjpais = pa_pjpaiso
               and t.pjtdoc = pa_pjtdoco
               and t.pjndoc = pa_pjndoco
               and t.vicod in (1,8,9,10,11,12,13,29,30,31,32,33,34,35,36,37,38,49,50,51,52,53,54,55,56,57,58,83,84
               ,2,4,3,7 
               )  ) b
     where a.pfpai1 = b.pfpai1
       and a.pftdo1 = b.pftdo1
       and a.pfndo1 = b.pfndo1; 
      
   BEGIN

     for rec_pj_int in cur_pj_int loop
          
          l_row.JAQY052TPAIS := rec_pj_int.tpais;
          l_row.JAQY052TTDOC := rec_pj_int.ttdoc;
          l_row.JAQLY052TNDOC := rec_pj_int.tndoc;
          PIPE ROW(l_row);
          
     end loop;

     return;
  end;
   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function FN_CONSULTAR_ACCTA (pa_perano number, 
                                     pa_permes number, 
                                     pa_percor number) 
   return pq_grupos_economicos_bt2.cur_detalle_roles is
   curref pq_grupos_economicos_bt2.cur_detalle_roles;
   
   begin
           
     open curref for
     
     select 
           distinct 
             dat1.pfpai1 tpais, 
             dat1.pftdo1 ttdoc, 
             dat1.pfndo1 tndoc
     from (   
       select 
          distinct --r.jaqy051corr ,
                   t.pjpais, 
                   t.pjtdoc, 
                   t.pjndoc, 
                   r.jaqy051corr, 
                   t.pfpai1, 
                   t.pftdo1, 
                   t.pfndo1  --, r.jaqy052erel, t.pjpais, t.pjtdoc, t.pjndoc
         FROM 
             fsr003 t, jaqy052 r
        where 
             t.pjpais = r.jaqy052pais
             and t.pjtdoc = r.jaqy052tdoc
             and t.pjndoc = r.jaqy052ndoc
             and r.jaqy052erel = 2
             and r.jaqy052esre = 'B'
             and r.jaqy051pano = pa_perano
             and r.jaqy051pmes = pa_permes
             and r.jaqy051corr = pa_percor
             ) dat1,   
             --persona externa   
        (
         SELECT 
              y.pjpais, 
              y.pjtdoc, 
              y.pjndoc, 
              y.pfpai1, 
              y.pftdo1, 
              y.pfndo1 
         FROM  
              fsr003 y, fsd003 d 
         where 
              y.pjpais = d.pjpais 
              and y.pjtdoc = d.pjtdoc
              and y.pjndoc = d.pjndoc 
              and y.vicod IN (1,8,9,10,11,12,13,29,30,31,32,33,34,35,36,37,38,49,50,51,52,53,54,55,56,57,58,83,84
              ,2,4,3,7 --se agrego 2017.05.05
                       )    
              ) dat2 
    where 
        dat1.pfpai1 = dat2.pfpai1 
        and dat1.pftdo1 = dat2.pftdo1 
        and dat1.pfndo1 =dat2.pfndo1
        and  ( dat1.pjtdoc <> dat2.pjtdoc or dat1.pjndoc <> dat2.pjndoc );
    /*order by
                dat1.jaqy051corr, 
                dat1.pfpai1, 
                dat1.pftdo1, 
                dat1.pfndo1;*/

     return curref;

  end FN_CONSULTAR_ACCTA;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function FN_CONSULTAR_DIRET (pa_perano number, 
                                     pa_permes number, 
                                     pa_percor number) 
    return pq_grupos_economicos_bt2.cur_detalle_roles is
    curref pq_grupos_economicos_bt2.cur_detalle_roles;

   begin
      open curref for
        
      select 
          distinct 
               /*dat1.jaqy051corr, */
               dat1.pfpai1 tpais, 
               dat1.pftdo1 ttdoc, 
               dat1.pfndo1 tndoc
      from (   
           select 
              distinct /*r.jaqy051corr ,*/ 
                       t.pjpais, 
                       t.pjtdoc, 
                       t.pjndoc, 
                       r.jaqy051corr, 
                       t.pfpai1, 
                       t.pftdo1, 
                       t.pfndo1  /*, r.jaqy052erel, t.pjpais, t.pjtdoc, t.pjndoc*/
            from 
                 fsr003 t, jaqy052 r
            where 
                 t.pjpais = r.jaqy052pais
                 and t.pjtdoc = r.jaqy052tdoc
                 and t.pjndoc = r.jaqy052ndoc
                 and r.jaqy052erel = 2
                 and r.jaqy052esre = 'B'
                 and r.jaqy051pano = pa_perano
                 and r.jaqy051pmes = pa_permes
                 and r.jaqy051corr = pa_percor
                 ) dat1,   
                 /*persona externa*/     
                (
                 select 
                      y.pjpais, 
                      y.pjtdoc, 
                      y.pjndoc, 
                      y.pfpai1, 
                      y.pftdo1, 
                      y.pfndo1 
                 from  
                      fsr003 y, fsd003 d 
                 where 
                      y.pjpais = d.pjpais 
                      and y.pjtdoc = d.pjtdoc
                      and y.pjndoc = d.pjndoc 
                      and y.vicod IN (2,3,14,15,16,17,18,29,30,32,39,40,41,42,58,83,9,19,20,21,22,32,33,34,35,43,44,45,52,53,55,84
                          ,4,7,3
                      )    
                 ) dat2 
            where 
                dat1.pfpai1 = dat2.pfpai1 
                and dat1.pftdo1 = dat2.pftdo1 
                and dat1.pfndo1 =dat2.pfndo1
                and  ( dat1.pjtdoc <> dat2.pjtdoc or dat1.pjndoc <> dat2.pjndoc );
          /*order by
                dat1.jaqy051corr, 
                dat1.pfpai1, 
                dat1.pftdo1, 
                dat1.pfndo1;*/
          
     return curref;
     
  end FN_CONSULTAR_DIRET;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  FUNCTION FN_CONSULTAR_ACCTA_TABLA (pa_perano number, 
                                     pa_permes number, 
                                     pa_percor number) 
    RETURN tb_integrantes PIPELINED IS
    l_row re_integrantes;
      
   cursor  cur_pj_int is
   select 
       distinct 
             dat1.pfpai1 tpais, 
             dat1.pftdo1 ttdoc, 
             dat1.pfndo1 tndoc
     from (   
       select 
          distinct --r.jaqy051corr ,
                   t.pjpais, 
                   t.pjtdoc, 
                   t.pjndoc, 
                   r.jaqy051corr, 
                   t.pfpai1, 
                   t.pftdo1, 
                   t.pfndo1  --, r.jaqy052erel, t.pjpais, t.pjtdoc, t.pjndoc
         FROM 
             fsr003 t, jaqy052 r
        where 
             t.pjpais = r.jaqy052pais
             and t.pjtdoc = r.jaqy052tdoc
             and t.pjndoc = r.jaqy052ndoc
             and r.jaqy052erel = 2
             and r.jaqy052esre = 'B'
             and r.jaqy051pano = pa_perano
             and r.jaqy051pmes = pa_permes
             and r.jaqy051corr = pa_percor
             ) dat1,   
             --persona externa   
        (
         SELECT 
              y.pjpais, 
              y.pjtdoc, 
              y.pjndoc, 
              y.pfpai1, 
              y.pftdo1, 
              y.pfndo1 
         FROM  
              fsr003 y, fsd003 d 
         where 
              y.pjpais = d.pjpais 
              and y.pjtdoc = d.pjtdoc
              and y.pjndoc = d.pjndoc 
              and y.vicod IN (1,8,9,10,11,12,13,29,30,31,32,33,34,35,36,37,38,49,50,51,52,53,54,55,56,57,58,83,84
              ,2,4,3,7 --se agrego 2017.05.05
                       )    
              ) dat2 
    where 
        dat1.pfpai1 = dat2.pfpai1 
        and dat1.pftdo1 = dat2.pftdo1 
        and dat1.pfndo1 =dat2.pfndo1
        and  ( dat1.pjtdoc <> dat2.pjtdoc or dat1.pjndoc <> dat2.pjndoc );
    /*order by
                dat1.jaqy051corr, 
                dat1.pfpai1, 
                dat1.pftdo1, 
                dat1.pfndo1;*/
      
   BEGIN

     for rec_pj_int in cur_pj_int loop
          
          l_row.JAQY052TPAIS := rec_pj_int.tpais;
          l_row.JAQY052TTDOC := rec_pj_int.ttdoc;
          l_row.JAQLY052TNDOC := rec_pj_int.tndoc;
          PIPE ROW(l_row);
          
     end loop;

     return;
  end;
   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  FUNCTION FN_CONSULTAR_DIRET_TABLA (pa_perano number, 
                                     pa_permes number, 
                                     pa_percor number) 
    RETURN tb_integrantes PIPELINED IS
    l_row re_integrantes;
      
   cursor  cur_pj_int is
   select 
          distinct 
               /*dat1.jaqy051corr, */
               dat1.pfpai1 tpais, 
               dat1.pftdo1 ttdoc, 
               dat1.pfndo1 tndoc
      from (   
           select 
              distinct /*r.jaqy051corr ,*/ 
                       t.pjpais, 
                       t.pjtdoc, 
                       t.pjndoc, 
                       r.jaqy051corr, 
                       t.pfpai1, 
                       t.pftdo1, 
                       t.pfndo1  /*, r.jaqy052erel, t.pjpais, t.pjtdoc, t.pjndoc*/
            from 
                 fsr003 t, jaqy052 r
            where 
                 t.pjpais = r.jaqy052pais
                 and t.pjtdoc = r.jaqy052tdoc
                 and t.pjndoc = r.jaqy052ndoc
                 and r.jaqy052erel = 2
                 and r.jaqy052esre = 'B'
                 and r.jaqy051pano = pa_perano
                 and r.jaqy051pmes = pa_permes
                 and r.jaqy051corr = pa_percor
                 ) dat1,   
                 /*persona externa*/     
                (
                 select 
                      y.pjpais, 
                      y.pjtdoc, 
                      y.pjndoc, 
                      y.pfpai1, 
                      y.pftdo1, 
                      y.pfndo1 
                 from  
                      fsr003 y, fsd003 d 
                 where 
                      y.pjpais = d.pjpais 
                      and y.pjtdoc = d.pjtdoc
                      and y.pjndoc = d.pjndoc 
                      and y.vicod IN (2,3,14,15,16,17,18,29,30,32,39,40,41,42,58,83,9,19,20,21,22,32,33,34,35,43,44,45,52,53,55,84
                          ,4,7,3
                      )    
                 ) dat2 
            where 
                dat1.pfpai1 = dat2.pfpai1 
                and dat1.pftdo1 = dat2.pftdo1 
                and dat1.pfndo1 =dat2.pfndo1
                and  ( dat1.pjtdoc <> dat2.pjtdoc or dat1.pjndoc <> dat2.pjndoc );
          /*order by
                dat1.jaqy051corr, 
                dat1.pfpai1, 
                dat1.pftdo1, 
                dat1.pfndo1;*/
      
   BEGIN

     for rec_pj_int in cur_pj_int loop
          
          l_row.JAQY052TPAIS := rec_pj_int.tpais;
          l_row.JAQY052TTDOC := rec_pj_int.ttdoc;
          l_row.JAQLY052TNDOC := rec_pj_int.tndoc;
          PIPE ROW(l_row);
          
     end loop;

     return;
  end;
  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Function fn_cr_verifica_jobs return number is
    ln_numjob number(9) := 0;
 
  begin
    
      select 
              count(*)
              INTO ln_numjob
        from 
              jaqz460 t
       where 
              t.jaqz460ffi is null;

    return ln_numjob;
  end fn_cr_verifica_jobs;

  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure SP_INSERTA_REPORTE( pa_perano number,
                              pa_permes number                                                 
                           )  IS
  -- *****************************************************************
  -- Nombre                     : SP_INSERTA_REPORTE
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos
  -- Versión                    : 
  -- Fecha de Creación          : 
  -- Autor de Creación          : DCASTRO
  -- Uso                        : INSERTA PARA GENERACION DE REPORTE
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :                           
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      : 03/2/2020
  -- Autor de la Modificación   :  DCASTRO
  -- Descripción de Modificación: Modificacion al proceso de insercion de codigo sbs
  -- Descripción de Modificación: 
  -- *****************************************************************         

cursor listado is
--select * from jaqz461 j where j.jaqz461pano =  pa_perano and j.jaqz461pmes = pa_permes;
select j.*  
from jaqz461 j
where j.jaqz461pano = pa_perano
and j.jaqz461pmes = pa_permes;



cursor cuentas(pais in number,  ndoc in char, d_fecpro in date) is
select --lpad(g.AOCTA,9,'0')||lpad(g.AOOPER,9,'0') lc_cuenta , to_char(aofval, 'RRRRMMDD' ) fecdes
       g.AOCTA,g.AOOPER, g.aofval
from fsr008 f , fsd010 g, fst111 h
where f.PEPAIS = pais  and f.PENDOC = ndoc /*and f.TTCOD = 1 and f.CTTFIR = 'T'*/
and g.PGCOD = 1
and g.AOCTA = f.CTNRO
and g.AOMOD = h.modulo 
and h.dscod = 50
and (g.AOSTAT <>99 or (g.AOSTAT =99 and g.AOFE99 > d_fecpro));



ld_fecpro  date;
ld_fecrcc  date;
ld_Fecdes  date;
lc_cuenta  number(9);
lc_operac  number(9);
lc_codsbs  char(10);

begin


ld_fecpro := last_day(to_date(to_char(pa_perano)|| lpad(to_char(pa_permes),2,'0')||'01','yyyymmdd'));


begin
     select to_date(tpnro,'ddmmyyyy')
          into ld_fecrcc 
     from fst098 where tpcod = 7647 and tpcorr =12; 
end;



  delete from JAQZ461 t where t.jaqz461pano = pa_perano and t.jaqz461pmes = pa_permes; 
  commit;
   
  
  insert into JAQZ461
  (
  jaqz461pano, jaqz461pmes, jaqz461cor, jaqz461pais, jaqz461nom, jaqz461sbs, jaqz461tcli, jaqz461dcli, 
  jaqz461ndoc, jaqz461dirc, jaqz461rleg, jaqz461deuc, jaqz461paiv, jaqz461nomv, jaqz461sbsv, jaqz461tcliv, 
  jaqz461dcliv, jaqz461ndocv, jaqz461dirv, jaqz461acci, jaqz461car1, jaqz461car2, jaqz461deuv, jaqz461ges
  )
select --/*+all_rows parallel(a,5) parallel(b,5) parallel(d,5) parallel(f,5) parallel(g,5)*/
  distinct a.jaqy055perano AÑO,
           a.jaqy055permes MES,
           a.jaqy055nrov CORRELATIVO,
           a.jaqy055pais PAIS_CLIENTE,
           d.penom NOMBRE_CLIENTE,
           0/*(select rcc.c_codsbs
              from cldrcci rcc
             where rcc.d_fecpre = ld_fecrcc
               and (rcc.c_doctri = trim(a.jaqy055ndoc) or
                   rcc.c_docide = trim(a.jaqy055ndoc))
               and rownum = 1)*/ CODIGO_SBS_CLIENTE,
           decode(d.petipo, 'F', 'NAT', 'J', 'JUR', 'NC') TIPO_PER_CLIENTE,
           b.tdnom TIPO_DOC_CLIENTE,
           a.jaqy055ndoc NUMERO_DOC_CLIENTE,
           (select trim(t.Sngc13dir) || ', ' || trim(di.fst071dsc) || ', ' ||
                   trim(pr.locnom) || ', ' || trim(de.depnom) || ', ' ||
                   trim(pa.panom)
              from SNGC13 t, fst071 di, FST070 pr, fst068 de, fst013 pa
             where di.fst071pai = a.jaqy055pais -- dist
               and di.fst071dpt = t.sngc13dpto
               and di.fst071loc = t.sngc13prov
               and di.fst071col = t.sngc13ugeo
               and pr.pais = a.jaqy055pais -- prov
               and pr.depcod = t.sngc13dpto
               and pr.loccod = t.sngc13prov
               and de.pais = a.jaqy055pais -- dep
               and de.depcod = t.sngc13dpto
               and pa.pais = a.jaqy055pais -- pais                     
               and t.docod = 1
               and t.sngc13tdoc = a.jaqy055tdoc
               and t.sngc13ndoc = a.jaqy055ndoc
               AND ROWNUM = 1) DIRECCION_CLIENTE,
           (select pers.penom
              from fsr003 j, fsd001 pers
             WHERE pers.pendoc = j.pfndo1
               and j.pjpais = a.jaqy055pais
               and j.pjtdoc = a.jaqy055tdoc
               and j.pjndoc = a.jaqy055ndoc
               and j.vicod in
                   --(7, 18, 22, 25, 27, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 51, 84)
                   (7,2,3,8,4) --20170505
               and rownum = 1) REPRESENTANTE_LEGAL,
           /*(select\*+parallel(sh,4,1) parallel(cl,4,1)*\ sh.BCActi from fsh012 sh, fsr008 cl where sh.bcemp=1 and sh.bcfech=to_date('31/12/2015','dd/mm/rrrr')
                                     and sh.bcprod = 0 and sh.bccta=cl.ctnro and cl.pepais=a.jaqy055pais and cl.petdoc=a.jaqy055tdoc 
                                     and cl.pendoc=a.jaqy055ndoc and cl.ttcod=1 and cl.cttfir='T' and rownum=1 ) CIIU_CLIENTE, */
           (select SUM(s.jaql114sdmn)
              from jaql114 s
             where s.jaql114fech = ld_fecpro
               and s.jaql114pais = a.jaqy055pais
               and s.jaql114tdoc = a.jaqy055tdoc
               and s.jaql114ndoc = a.jaqy055ndoc
               and s.jaql114mod <> 33) DEUDA_CLIENTE,
           a.jaqy055paiv PAIS_VINCULADO,
           f.penom NOMBRE_VINCULADO,
           (select rcc.c_codsbs
              from cldrcci rcc
             where rcc.d_fecpre = ld_fecrcc
               and (rcc.c_doctri = trim(a.jaqy055ndov) or
                   rcc.c_docide = trim(a.jaqy055ndov))
               and rownum = 1) CODIGO_SBS_VINCULADO,
           decode(f.petipo, 'F', 'NAT', 'J', 'JUR', 'NC') TIPO_PER_VINCULADO,
           g.tdnom TIPO_DOC_VINCULADO,
           a.jaqy055ndov NUMERO_DOC_VINCULADO,
           (select trim(t.Sngc13dir) || ', ' || trim(di.fst071dsc) || ', ' ||
                   trim(pr.locnom) || ', ' || trim(de.depnom) || ', ' ||
                   trim(pa.panom)
              from SNGC13 t, fst071 di, FST070 pr, fst068 de, fst013 pa
             where di.fst071pai = a.jaqy055paiv -- dist
               and di.fst071dpt = t.sngc13dpto
               and di.fst071loc = t.sngc13prov
               and di.fst071col = t.sngc13ugeo
               and pr.pais = a.jaqy055paiv -- prov
               and pr.depcod = t.sngc13dpto
               and pr.loccod = t.sngc13prov
               and de.pais = a.jaqy055paiv -- dep
               and de.depcod = t.sngc13dpto
               and pa.pais = a.jaqy055paiv -- pais                     
               and t.docod = 1
               and t.sngc13est = 'H'
               and t.sngc13tdoc = a.jaqy055tdov
               and t.sngc13ndoc = a.jaqy055ndov
               AND ROWNUM = 1) DIRECCION_VINCULADO,
           (select j.pfpart
              from fsr003 j
             WHERE j.pjpais = a.jaqy055pais
               and j.pjtdoc = a.jaqy055tdoc
               and j.pjndoc = a.jaqy055ndoc
               and j.pfpai1 = a.jaqy055paiv
               and j.pftdo1 = a.jaqy055tdov
               and j.pfndo1 = a.jaqy055ndov
               and rownum = 1) ACCIONISTA,
           (select case
                     when dv.vinom like '%PR DIR%' THEN
                      1
                     when dv.vinom like '%DIR%' THEN
                      2
                     when dv.vinom like '%GER%' THEN
                      3
                     when dv.vinom like '%PR FUN%' THEN
                      4
                     when dv.vinom like '%ASE%' THEN
                      5
                     else
                      0
                   end cargo
              from fsr003 j, fst020 dv
             WHERE dv.vicod = j.vicod
               and j.pjpais = a.jaqy055pais
               and j.pjtdoc = a.jaqy055tdoc
               and j.pjndoc = a.jaqy055ndoc
               and j.pfpai1 = a.jaqy055paiv
               and j.pftdo1 = a.jaqy055tdov
               and j.pfndo1 = a.jaqy055ndov
               and rownum = 1) CARGO,
           
           (select case
                     when dv.vinom not like '%PR DIR%' and
                          dv.vinom not like '%DIR%' and
                          dv.vinom not like '%GER%' and
                          dv.vinom not like '%PR FUN%' and
                          dv.vinom not like '%ASE%' and
                          dv.vinom not like '%ACC%' THEN
                      6
                     else
                      0
                   end cargo
              from fsr003 j, fst020 dv
             WHERE dv.vicod = j.vicod
               and j.pjpais = a.jaqy055pais
               and j.pjtdoc = a.jaqy055tdoc
               and j.pjndoc = a.jaqy055ndoc
               and j.pfpai1 = a.jaqy055paiv
               and j.pftdo1 = a.jaqy055tdov
               and j.pfndo1 = a.jaqy055ndov
               and rownum = 1) OTRO_CARGO,
           (select SUM(s.jaql114sdmn)
              from jaql114 s
             where s.jaql114fech = ld_fecpro
               and s.jaql114pais = a.jaqy055paiv
               and s.jaql114tdoc = a.jaqy055tdov
               and s.jaql114ndoc = a.jaqy055ndov
               and s.jaql114mod <> 33) DEUDA_VINCULADO,
           a.jaqy055tipo GESTION
  
    from jaqy055 a, fst014 b, fsd001 d, fsd001 f, fst014 g
   where a.jaqy055tdoc = b.tdocum
     and a.jaqy055tdov = g.tdocum
     and d.pepais = a.jaqy055pais
     and d.petdoc = a.jaqy055tdoc
     and d.pendoc = a.jaqy055ndoc
     and f.pepais = a.jaqy055paiv
     and f.petdoc = a.jaqy055tdov
     and f.pendoc = a.jaqy055ndov
     and a.jaqy055perano = pa_perano
     and a.jaqy055permes = pa_permes
        --  and a.jaqy055nrov is not null
     and a.jaqy055tipo is not null;


     commit;
   
   
   for j in listado loop
      ld_Fecdes := '01/01/1900';
      lc_cuenta := null;
      lc_operac := null;
      --obtiene la ultima fecha de desembolso
      for i in cuentas(j.jaqz461pais,  j.jaqz461ndoc, ld_fecpro) loop 
         if ld_fecdes < i.aofval then 
            ld_Fecdes := i.aofval;
            lc_cuenta := i.aocta;
            lc_operac := i.aooper;
         end if;            
      end loop;   
      
      --obtiene codigo sbs como individual
      begin
        select rcc.c_codsbs
          into lc_codsbs
          from cldrcci rcc
         where rcc.d_fecpre = ld_fecrcc
           and (rcc.c_doctri = trim(j.jaqz461ndoc) or
               rcc.c_docide = trim(j.jaqz461ndoc))
           and c_person in ('1', '2');
      exception
        when too_many_rows then
          if substr(j.jaqz461dcli, 1, 3) = 'DNI' then
            begin
              select max(rcc.c_codsbs)
                into lc_codsbs
                from cldrcci rcc
               where rcc.d_fecpre = ld_fecrcc
                 and (rcc.c_doctri = trim(j.jaqz461ndoc) or
                     rcc.c_docide = trim(j.jaqz461ndoc))
                 and c_person in ('1', '2')
                 and rcc.c_tdocid = '1';
            exception
              when others then
                lc_codsbs := null;
            end;
          
          else
            begin
              select max(rcc.c_codsbs)
                into lc_codsbs
                from cldrcci rcc
               where rcc.d_fecpre = ld_fecrcc
                 and (rcc.c_doctri = trim(j.jaqz461ndoc) or
                     rcc.c_docide = trim(j.jaqz461ndoc))
                 and c_person in ('1', '2');
            exception
              when others then
                lc_codsbs := null;
            end;
          end if;
          
       when others then
                lc_codsbs := null;    
      end;
    
      --actualizando informacion
      update jaqz461 k
         set k.jaqz461fdes = ld_Fecdes,
             k.jaqz461cta  = lc_cuenta,
             k.jaqz461ope  = lc_operac,
             k.jaqz461sbs  = lc_codsbs
       where k.jaqz461pano = pa_perano
         and k.jaqz461pmes = pa_permes
         and k.jaqz461ndoc = j.jaqz461ndoc;
    
      commit; 
      
   end loop;                     
exception when others then   
  --dbms_output.put_line('ERROR GENERAR REPORTE '||sqlerrm );    
  null; 
END SP_INSERTA_REPORTE;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

 function fn_ciiu_codigo4(P_PAIS   in number,
                          P_PETDOC in number,   
                          P_PENDOC in char
                         ) return varchar2
  is
    lc_codciiu NUMBER;--varchar2(4);
    lv_petipo varchar2(1);
  Begin
     
    lv_petipo := pq_client_ciiu.fn_petipo(P_PAIS,P_PETDOC,P_PENDOC);
    
    If lv_petipo = 'F' Then
       Begin
            Select c60.sngc60acte--substr(lpad(trim(to_char(c60.sngc60acte)),6, '0'),1,4)
              Into lc_codciiu
              From sngc60 c60
             Where c60.sngc60pais = P_PAIS
               And c60.sngc60tdoc = P_PETDOC
               And c60.sngc60ndoc = P_PENDOC
               And c60.sngc60corr = 0;       
       Exception when others then
          lc_codciiu := 0;       
       End;
    End If;                           
    
    If lv_petipo = 'J' Then
       Begin
            Select e001.expnins --substr(lpad(trim(to_char(e001.expnins)),6, '0'),1,4) 
              Into lc_codciiu
              From fse001 e001
             Where e001.d511pais = P_PAIS
               And e001.d511tdoc = P_PETDOC
               And e001.d511ndoc = P_PENDOC;       
       Exception when others then
          lc_codciiu := 0;       
       End; 
    End If;
    
    begin
    select f.actcod2 
      into lc_codciiu
      from fst750 f 
     where f.actcod1 = lc_codciiu;      
    exception when others then
         lc_codciiu := null;
    end;
    
    Return TRIM(TO_CHAR(lc_codciiu));
        
  end fn_ciiu_codigo4;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

 function fn_cr_nombre (P_PAIS   in number,
                          P_PETDOC in number,   
                          P_PENDOC in char
                         ) return varchar2
  is
    lc_nombre varchar2(100);
    lv_petipo varchar2(1);

  Begin
     
    lv_petipo := pq_client_ciiu.fn_petipo(P_PAIS,P_PETDOC,P_PENDOC);
    
    If lv_petipo = 'F' Then
       Begin
         select trim(g.pfape1)||' '||trim(g.pfape2)||' '||trim(g.pfnom1)||' '||trim(g.pfnom2) 
           into lc_nombre
           from fsd002 g
          where g.pfpais = P_PAIS
          and g.pftdoc = P_PETDOC
          and g.pfndoc = P_PENDOC;
              
       Exception when others then
          lc_nombre := null;       
       End;
    End If;                           
    
    If lv_petipo = 'J' Then
       Begin
         select l.pjrazs 
           into lc_nombre
           from fsd003 l
          where l.pjpais = P_PAIS
            and l.pjtdoc = P_PETDOC
            and l.pjndoc = P_PENDOC;
         Exception when others then
            lc_nombre := null;       
       End; 
    End If;
    
    if lc_nombre is null then
       Begin
         select g.penom
           into lc_nombre
           from fsd001 g
          where g.pepais = P_PAIS
          and g.petdoc = P_PETDOC
          and g.pendoc = P_PENDOC;
              
       Exception when others then
          lc_nombre := null;       
       End;
    end if;
    
    
    Return lc_nombre;
        
  end fn_cr_nombre;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure SP_INSERTA_GRUPOS( pa_perano number,
                              pa_permes number                                                 
                           )  IS
  -- *****************************************************************
  -- Nombre                     : SP_INSERTA_GRUPOS
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos
  -- Versión                    : 
  -- Fecha de Creación          : 
  -- Autor de Creación          : DCASTRO
  -- Uso                        : INSERTA PARA GENERACION DE REPORTE
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :                           
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      : 31/10/2020
  -- Autor de la Modificación   :  DCASTRO
  -- Descripción de Modificación: Insercion grupos economicos
  -- Descripción de Modificación: 
  -- *****************************************************************
  -- Fecha de Modificación      : 30/12/2022
  -- Autor de la Modificación   : Maycol Chavez Chuman
  -- Descripción de Modificación: Se agrego un procedimiento para obtener la Magnitud Empresarial
  --                              y actualiza JAQZ461A.
  -- *****************************************************************                    

CURSOR listado is
select /*+all_rows */
distinct l.jaqy051pano anio,
         l.jaqy051pmes mes,
         l.jaqy051corr grupo,
         l.jaqy052corr coor,
         l.jaqy052pais pais,
         l.jaqy052tdoc tip_doc,
         l.jaqy052ndoc num_doc,
         l.jaqy052esre rela
  from jaqy052 l
where l.jaqy051pano = pa_perano  -- Colocar el año de cierre mensual
   and l.jaqy051pmes = pa_permes;   -- Colocar el mes de cierre mensual




ld_fecpro date;
ld_fecrcc date;
ln_saldo number(18,2);
lc_producto varchar2(30);
ln_ciuu2 number;
lc_petipo char(1);
lc_ubigeo char(6);
lc_codigo_sbs char(12);
lc_codigo_sbs_1 char(12);
lc_codigo_sbs_2 char(12);
lc_codigo_sbs_3 char(12);
lc_des_tipodoc varchar2(30);
lc_nombre varchar2(100);
lc_ciuu4 char(4);
lc_cuenta number(9);
lc_operac number(9);
ln_num number(9);

ld_fecdes date;        


BEGIN
  

 ld_fecpro := last_day(to_date(to_char(pa_perano)|| lpad(to_char(pa_permes),2,'0')||'01','yyyymmdd'));
 
 begin
     select to_date(tpnro,'ddmmyyyy')
       into ld_fecrcc 
      from fst098 where tpcod = 7647 and tpcorr =12; 
 end;



  delete from JAQZ461A t where t.jaqz461apano = pa_perano and t.jaqz461apmes = pa_permes; 
  commit;


  ln_num := 0;
  for i in listado loop 
    -- tipo
    begin
     select f.petipo 
       into lc_petipo
       from fsd001 f 
      where f.pepais = i.pais
        and f.petdoc = i.tip_doc
        and f.pendoc = i.num_doc;
   exception when others then
      lc_petipo := null;
    end; 
    --saldo
    BEGIN
      select SUM(s.jaql114sdmn)
       into ln_saldo
      from jaql114 s
     where s.jaql114fech = ld_fecpro --FECHA DE CIERRE DE MES
       and s.jaql114pais = i.pais
       and s.jaql114tdoc = i.tip_doc
       and s.jaql114ndoc = i.num_doc; 
    exception when others then
      ln_Saldo := 0;
    end;   
    --ubigeo
     begin      
       select rpad(trim(to_char(sngc13ugeo)),6, '0') 
          into lc_ubigeo
          from sngc13 s
         where sngc13pais = i.pais
           and s.sngc13tdoc = i.tip_doc
           and s.sngc13ndoc = i.num_doc
           and s.docod = 1
           and s.sngc13est = 'H'
           and s.sngc13corr in (
               select max(s.sngc13corr)
                  from sngc13 s
                 where s.sngc13pais = i.pais
                   and s.sngc13tdoc = i.tip_doc
                   and s.sngc13ndoc = i.num_doc
                   and s.docod = 1
                   and s.sngc13est = 'H');
    exception when others then
       lc_ubigeo := null;
    end;
    
    --producto sbs
      Begin
        select jaql114tcrd
          into lc_producto
          from jaql114 s
         where s.jaql114fech = ld_fecpro --FECHA DE CIERRE DE MES
           and s.jaql114pais = i.pais
           and s.jaql114tdoc = i.tip_doc
           and s.jaql114ndoc = i.num_doc
           and rownum = 1; 
      exception when others then
         lc_producto := null;
      end;       

     --ciuu2        
      ln_ciuu2 :=  pq_grupos_economicos_bt2.fn_ciiu_codigo(i.pais,
                                              i.tip_doc,
                                              i.num_doc);
     -- codsbs                                              
        begin  
         select max(c_codsbs)
           into lc_codigo_sbs
            from cldrcci
           where d_fecpre = ld_fecrcc ---FECHA ULTIMO RCC
             and c_tdocid = 1
             and c_docide = trim(i.num_doc)
             ;--and rownum = 1;
         exception when others then
            lc_codigo_sbs := null;
         end;
         
         begin  
         select max(c_codsbs)
           into lc_codigo_sbs_1
            from cldrcci
           where d_fecpre = ld_fecrcc ---FECHA ULTIMO RCC
             and c_doctri = trim(i.num_doc)
             ;--and rownum = 1;
         exception when others then
            lc_codigo_sbs_1 := null;
         end;
         
------     /*NUEVAS COLUMNAS*/
--1. Añadir una columna con la descripción del tipo de documento 
        begin   
          select f.tdnom 
            into lc_des_tipodoc
            from fst014 f 
           where f.tdocum = i.tip_doc;  
        exception when others then
            lc_des_tipodoc := null;
        end;
    
--2. Añadir una columna con nombres completos/razón social           
          lc_nombre := pq_grupos_economicos_bt2.fn_cr_nombre(p_pais => i.pais,
                                                           p_petdoc => i.tip_doc,
                                                           p_pendoc => i.num_doc);

--3. Añadir una columna con el código CIUU a 4 dígitos 
          lc_ciuu4 := pq_grupos_economicos_bt2.fn_ciiu_codigo4(i.pais,
                                                    i.tip_doc,
                                                    i.num_doc) ;
--4. Añadir una columna con el Código SBS tomando como referencia el ultimo RCC vigente, 
---en el cual deberá considerarse únicamente las cuentas individuales y no las mancomunas,
-- vale decir Codificación 1 ¿ Individual 
        /*begin  
         select max(c_codsbs)
           into lc_codigo_sbs_2
            from cldrcci
           where d_fecpre = ld_fecrcc ---FECHA ULTIMO RCC
             and c_tdocid = 1
             and c_person = 1
             and c_docide = trim(i.num_doc)
             ;
         exception when others then
             begin  
               select max(c_codsbs)
                 into lc_codigo_sbs_2
                  from cldrcci
                 where d_fecpre = ld_fecrcc ---FECHA ULTIMO RCC
                   --and c_tdoctr = 3
                   and c_person = 2
                   and c_doctri = trim(i.num_doc)
                   ;
               exception when others then
                lc_codigo_sbs_2 := null;
             end;   
         end;
         */
         ---ADICIONAL
            begin
              select rcc.c_codsbs
                into lc_codigo_sbs_3
                from cldrcci rcc
               where rcc.d_fecpre = ld_fecrcc
                 and (rcc.c_doctri = trim(i.num_doc) or
                     rcc.c_docide = trim(i.num_doc))
                 and c_person in ('1', '2');
             exception
                when too_many_rows then
                  if i.tip_doc = 21 then
                    begin
                      select max(rcc.c_codsbs)
                        into lc_codigo_sbs_3
                        from cldrcci rcc
                       where rcc.d_fecpre = ld_fecrcc
                         and (rcc.c_doctri = trim(i.num_doc) or
                             rcc.c_docide = trim(i.num_doc))
                         and c_person in ('1', '2')
                         and rcc.c_tdocid = '1';
                    exception
                      when others then
                        lc_codigo_sbs_3 := null;
                    end;
                  
                  else
                    begin
                      select max(rcc.c_codsbs)
                        into lc_codigo_sbs_3
                        from cldrcci rcc
                       where rcc.d_fecpre = ld_fecrcc
                         and (rcc.c_doctri = trim(i.num_doc) or
                             rcc.c_docide = trim(i.num_doc))
                         and c_person in ('1', '2');
                    exception
                      when others then
                        lc_codigo_sbs_3 := null;
                    end;
                  end if;
                  
               when others then
                    lc_codigo_sbs_3 := null;    
              end;

--5. Añadir una columna que contemple la fecha de desembolso del crédito del cliente 
 -- FALTA FECDES , CUENTA OPERACION

     pq_grupos_economicos_bt2.sp_obtiene_cuenta(pa_pepais => i.pais,
                                             pa_petdoc => i.tip_doc,
                                             pa_pendoc => i.num_doc,
                                             pa_fecpro => ld_fecpro,
                                             pd_fecdes => ld_Fecdes,
                                             pn_cuenta => lc_cuenta,
                                             pn_operac => lc_operac);


    ln_num := ln_num + 1;  
          
    insert into JAQZ461A(
    jaqz461apano, jaqz461apmes, jaqz461agru, jaqz461acor, jaqz461apais, jaqz461atdoc, jaqz461andoc, 
    jaqz461arela, jaqz461asdeu, jaqz461aciu1, jaqz461apsbs, jaqz461aciu2, jaqz461asbs2, jaqz461acsbs, 
    jaqz461atipd, jaqz461anomb, jaqz461aciu4, jaqz461acsb3, jaqz461afdes, jaqz461acta, jaqz461aope , 
    jaqz461anum,  jaqz461aux1  )
    values(
    i.anio, i.mes, i.grupo, i.coor, i.pais, i.tip_doc, i.num_doc, i.rela, ln_saldo, lc_ubigeo,
    lc_producto, ln_ciuu2, lc_codigo_sbs, lc_codigo_sbs_1, lc_des_tipodoc, lc_nombre, lc_ciuu4,
    lc_codigo_sbs_3, ld_Fecdes, lc_cuenta, lc_operac , ln_num, lc_codigo_sbs_2  
    );
  
    commit;
    
  end loop;
  
  SP_CR_OBTENER_MAGNITUD_EMPRESARIAL(pa_perano, pa_permes);

end SP_INSERTA_GRUPOS;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_obtiene_cuenta( pa_pepais in number,
                             pa_petdoc in number, 
                             pa_pendoc in char,
                             pa_fecpro in date,
                             pd_fecdes out date,
                             pn_cuenta out number,
                             pn_operac out number
                           )  IS
  -- *****************************************************************
  -- Nombre                     : sp_obtiene_cuenta
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos
  -- Versión                    : 
  -- Fecha de Creación          : 
  -- Autor de Creación          : DCASTRO
  -- Uso                        : OBTIENE CREDITOS
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :                           
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      : 31/10/2020
  -- Autor de la Modificación   :  DCASTRO
  -- Descripción de Modificación: Insercion grupos economicos
  -- Descripción de Modificación: 
  -- *****************************************************************                          


cursor cuentas(pais in number, tipodoc in number, ndoc in char, d_fecpro in date) is
select --lpad(g.AOCTA,9,'0')||lpad(g.AOOPER,9,'0') lc_cuenta , to_char(aofval, 'RRRRMMDD' ) fecdes
       g.AOCTA,g.AOOPER, g.aofval
from fsr008 f , fsd010 g, fst111 h
where f.PEPAIS = pais  
and f.petdoc = tipodoc 
and f.PENDOC = ndoc /*and f.TTCOD = 1 and f.CTTFIR = 'T'*/
and g.PGCOD = 1
and g.AOCTA = f.CTNRO
and g.AOMOD = h.modulo 
and h.dscod = 50
and (g.AOSTAT <>99 or (g.AOSTAT =99 and g.AOFE99 > d_fecpro));


ld_fecdes date;        

BEGIN

      ld_Fecdes := '01/01/1900';
      pn_cuenta := null;
      pn_operac := null;
      
      --obtiene la ultima fecha de desembolso
      for x in cuentas(pa_pepais, pa_petdoc, pa_pendoc, pa_fecpro) loop 
         if ld_fecdes < x.aofval then 
            ld_Fecdes := x.aofval;
            pn_cuenta := x.aocta;
            pn_operac := x.aooper;
         end if;            
      end loop; 
      
      if pn_cuenta is null then
         pd_fecdes := null;
      else
         pd_fecdes := ld_Fecdes;   
      end if;  



end sp_obtiene_cuenta;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
PROCEDURE SP_CR_OBTENER_MAGNITUD_EMPRESARIAL(pANIO IN NUMBER, pMES IN NUMBER)
IS
  -- *****************************************************************
  -- NOMBRE                      : SP_CR_OBTENER_MAGNITUD_EMPRESARIAL
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 30/12/2022
  -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
  -- USO                         : OBTENER LA MAGNITUD EMPRESARIAL Y NIVEL DE VENTAS
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  --------------------------------------------------------------------
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  --
  -- *****************************************************************

   MONTO        NUMBER(17,2);
   MONTO_TOTAL  NUMBER(17,2);
   MAGNITUD     NUMBER(5);
   SEGMENTO     NUMBER(2);
   UIT          NUMBER(17,2);
   EVALUACION   NUMBER(10);
   INSTANCIA    NUMBER(10);
   PAIS         NUMBER(3);
   TDOC         NUMBER(2);
   NDOC         CHAR(12);
   DESCRIPCION  VARCHAR2(30);
   NUMERO       NUMBER(5);
   CHAR_MES     VARCHAR2(2);
   CHAR_FEC     VARCHAR2(10);
   FECHA        DATE;
   FECHA_EVAL   DATE;
   CURSOR LISTA_GRUPOS_ECONOMICOS IS SELECT * FROM JAQZ461A WHERE JAQZ461APANO = pANIO AND JAQZ461APMES = pMES;
BEGIN
   CHAR_MES := LPAD(pMES, 2, '00');
   CHAR_FEC := TO_DATE('01/'||CHAR_MES||'/'||pANIO, 'DD/MM/RRRR');
   FECHA    := LAST_DAY(CHAR_FEC);
   FOR X IN LISTA_GRUPOS_ECONOMICOS LOOP
      PAIS := 0;
      TDOC := 0;
      NDOC := ' ';   
   
      PAIS := X.JAQZ461APAIS;
      TDOC := X.JAQZ461ATDOC;
      NDOC := X.JAQZ461ANDOC;
      CASE
         WHEN TDOC = 21 THEN
            BEGIN
               MAGNITUD := 0;
               SELECT B.CTSEGM, 5, 'Persona Natural con Negocio'
               INTO SEGMENTO, MAGNITUD, DESCRIPCION
               FROM FSR008 A, FSD008 B, FST098 C 
               WHERE A.PEPAIS = PAIS AND A.PETDOC = TDOC AND A.PENDOC = NDOC AND A.CTTFIR = 'T' AND 
                     B.PGCOD = A.PGCOD AND B.CTNRO = A.CTNRO AND C.PGCOD = B.PGCOD AND C.TPCOD = 4809 AND 
                     C.TPCORR > 0 AND C.TPNRO = B.CTSEGM 
               GROUP BY B.CTSEGM;
            EXCEPTION
               WHEN OTHERS THEN
                  MAGNITUD    := 0;
                  DESCRIPCION := 'Persona Natural sin Negocio';
            END;
            BEGIN
               UPDATE JAQZ461A 
               SET JAQZ461AMAG = MAGNITUD, JAQZ461ADSCR = DESCRIPCION
               WHERE JAQZ461APANO = pANIO AND JAQZ461APMES = pMES AND JAQZ461APAIS = X.JAQZ461APAIS AND 
                     JAQZ461ATDOC = X.JAQZ461ATDOC AND JAQZ461ANDOC = X.JAQZ461ANDOC;
               COMMIT;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
         WHEN TDOC = 9 THEN
            BEGIN
               EVALUACION := 0;
               SELECT MAX(A.SNG021EVAL) 
               INTO EVALUACION
               FROM SNG021 A, XWF700 B, FSD010 C 
               WHERE A.SNG021PDOC = PAIS AND A.SNG021TDOC = TDOC AND A.SNG021NDOC = NDOC AND
               A.SNG021TMOD = 13 AND A.SNG021FEC <= FECHA AND A.SNG021SOL = B.XWFPRCINS AND B.XWFCAR3 = '1' AND 
               C.PGCOD = B.XWFEMPRESA AND C.AOMOD = B.XWFMODULO AND C.AOSUC = B.XWFSUCURSAL AND C.AOMDA = B.XWFMONEDA AND 
               C.AOPAP = B.XWFPAPEL AND C.AOCTA = B.XWFCUENTA AND C.AOOPER = B.XWFOPERACION AND 
               C.AOSBOP = B.XWFSUBOPE AND C.AOTOPE = B.XWFTIPOPE;
            EXCEPTION
               WHEN OTHERS THEN
                  EVALUACION := 0;
            END;
            IF EVALUACION IS NOT NULL OR EVALUACION <> 0 THEN
               BEGIN
                  FECHA_EVAL := NULL;
                  SELECT SNG021FEC
                  INTO FECHA_EVAL
                  FROM SNG021
                  WHERE SNG021EVAL = EVALUACION;
               EXCEPTION
                  WHEN OTHERS THEN
                     FECHA_EVAL := NULL;
               END;
               BEGIN
                  NUMERO :=0;
                  SELECT 12
                  INTO NUMERO
                  FROM FST098
                  WHERE PGCOD = 1 AND TPCOD = 70011 AND TRIM(TPDESC) = 'M';
               EXCEPTION
                  WHEN OTHERS THEN
                     NUMERO := 1;
               END;
               BEGIN
                  MONTO := 0;
                  SELECT (SNG023MTO * NUMERO)
                  INTO MONTO
                  FROM SNG023 A, FST098 B
                  WHERE A.SNG021EVAL = EVALUACION AND A.SNG026COD = 73 AND B.PGCOD = 1 AND B.TPCOD = 8004 AND
                        A.SNG026COD = B.TPNRO;
               EXCEPTION
                  WHEN OTHERS THEN
                     MONTO := 0;
               END;
               BEGIN
                  UIT := 0;
                  SELECT CIIMP
                  INTO UIT
                  FROM FSI002 
                  WHERE CICPO = 'UIT' AND CIFECH = '01/01/0001';
               EXCEPTION
                  WHEN OTHERS THEN
                     UIT := 0;
               END;
               IF UIT = 0 THEN
                  MONTO_TOTAL := 0;
               ELSE
                  MONTO_TOTAL := 0;
                  MAGNITUD    := 0;
                  DESCRIPCION := ' ';
                  
                  MONTO_TOTAL := MONTO / UIT;
                  BEGIN
                     SELECT TP1NRO1, 
                        CASE
                           WHEN TP1NRO1 = 1 THEN 'Persona Jurídica Grande'
                           WHEN TP1NRO1 = 2 THEN 'Persona Jurídica Mediana'
                           WHEN TP1NRO1 = 3 THEN 'Persona Jurídica Pequeña'
                        END
                     INTO MAGNITUD, DESCRIPCION
                     FROM FST198 
                     WHERE TP1COD = 1 AND TP1COD1 = 10858 AND TP1CORR1 = 4 AND TP1CORR2 = 0 AND TP1CORR3 > 0 AND
                           MONTO_TOTAL > TP1IMP1 AND MONTO_TOTAL <= TP1IMP2;
                  EXCEPTION
                     WHEN OTHERS THEN
                        MAGNITUD    := 4;
                        DESCRIPCION := 'Persona Jurídica Micro';
                  END;
               END IF;
               BEGIN
                  INSTANCIA := 0;
                  SELECT SNG021SOL
                  INTO INSTANCIA
                  FROM SNG021 
                  WHERE SNG021EVAL = EVALUACION;
               EXCEPTION
                  WHEN OTHERS THEN
                     INSTANCIA := 0;
               END;
               BEGIN
                  UPDATE JAQZ461A
                  SET JAQZ461AMAG = MAGNITUD, JAQZ461ADSCR = DESCRIPCION, JAQZ461AVNT = MONTO, JAQZ461AVNUIT = MONTO_TOTAL, 
                      JAQZ461AUIT = UIT, JAQZ461AINST = INSTANCIA, JAQZ461AEVAL = EVALUACION, JAQZ461AFEVAL = FECHA_EVAL
                  WHERE JAQZ461APANO = pANIO AND JAQZ461APMES = pMES AND JAQZ461APAIS = X.JAQZ461APAIS AND 
                        JAQZ461ATDOC = X.JAQZ461ATDOC AND JAQZ461ANDOC = X.JAQZ461ANDOC;
                  COMMIT;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            ELSE
               MAGNITUD    := 4;
               DESCRIPCION := 'Persona Jurídica Micro';
               BEGIN
                  UPDATE JAQZ461A 
                  SET JAQZ461AMAG = MAGNITUD, JAQZ461ADSCR = DESCRIPCION
                  WHERE JAQZ461APANO = pANIO AND JAQZ461APMES = pMES AND JAQZ461APAIS = X.JAQZ461APAIS AND 
                        JAQZ461ATDOC = X.JAQZ461ATDOC AND JAQZ461ANDOC = X.JAQZ461ANDOC;
                  COMMIT;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            END IF;
         ELSE NULL;
      END CASE;
   END LOOP;
END SP_CR_OBTENER_MAGNITUD_EMPRESARIAL;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

end pq_grupos_economicos_bt2;

/*
   create public synonym pq_cr_adjudicar for pq_cr_adjudicar;
   grant execute on pq_cr_adjudicar to rol_BANTOTAL,rol_BANTOTAL_consulta;

*/


/*


*/
/

