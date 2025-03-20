CREATE OR REPLACE PROCEDURE SP_AH_CUENTAS_BT (JAQNCOD in number,
                                              JAQNFGE in date,
                                              TIPO_PERSONA in varchar2,
                                              JA_MODULO in varchar2,
                                              JA_MONEDA in varchar2,
                                              JA_FECHA_APERTURA in date,
                                              JA_FECHA_CIERRE in date,
                                              JA_ESTADO in varchar2,
                                              MOD_OPERA in varchar2,
                                              JA_CDESDE in number,
                                              JA_CHASTA in number
                                           ) AS 
                                    
JA_PAISOUT number(3):= null;
JA_TIPOOUT number(2):= null;
JA_NUMERODOUT varchar2(12):= null;
JA_NOMBREOUT varchar2(70):= null;
JA_CELULAR1OUT varchar2(20):= null;
JA_CELULAR2OUT varchar2(20):= null;
JA_CELULAR3OUT varchar2(20):= null;
JA_MAILOUT varchar2(65):= null;
JA_MAILOUT1 varchar2(65):= null;
JA_MAILOUT2 varchar2(65):= null;
JA_DIRECCIONOUT varchar2(140):= null;

/*jaql450*/
aJAQL450COI varchar2(255):= null;

       
/*FSD011*/
apgcod  number(3):= null;--Cod
accta  number(9):= null;--Cuenta
ascstat number(9):= null;--Estado
ascmod number(5):= null;--Modulo
asctope number(3):= null;--Tipo de Operacion
ascmda number(4):= null;--Moneda
ascsuc number(5):=null;--Sucursal
ascpap number(6):=null;--Papel
ascoper number(9):=null;--Operacion
ascsbop number(9):=null;--Sub Operacion
ascsdo number(18,2):=null;--Sub Operacion


/*FSR008*/
appais number(3):= null;
apetdoc number(4):= null;
apendoc varchar2(25):= null;

/*FSR008*/
nppais number(3):= null;
npetdoc number(4):= null;
npendoc varchar2(25):= null;

/*FSD002*/
nape1 varchar2(30):= null;
nape2 varchar2(30):= null;
nnom1 varchar2(25):= null;
nnom2 varchar2(25):= null;
nnomc varchar2(110):= null;

/*FSD003*/
gPjrazs varchar2(70):= null;


/*FSD001*/
aPenom varchar2(70):= null;


/*COUNT*/
countn number(6):= null;
counte number(6):= null;

/*FSR008*/
ddotelfp varchar2(20):= null;
ddotelfp1 varchar2(20):= null;
ddotelfp2 varchar2(20):= null;
ddocod number(2):= null;
ddoorp number(2):= null;

/*FSX001.*/
email varchar2(65):= null;


/*SNGC13*/
sDocod number(2):= null;
ssngc13Dir varchar2(140):= null;
ssngc13RDes date:= null;
SNGC13ppais number(3):= null;
SNGC13petdoc number(4):= null;
SNGC13pendoc varchar2(25):= null;

prueba varchar2(200):= null;

/*TELEFONO*/
largo    number;
largocel   number;      
emp   number;
nueve number(2):= null;

cant number(3):= null;   
val varchar2(200):= null;
modval varchar2(200):= null;
mod21 varchar2(200):= null;
mod22 varchar2(200):= null;

tope number(3):= null;

BEGIN
      
      CASE 
              WHEN JA_MODULO= 'CA' OR  JA_MODULO= 'DP' then 
                      IF JA_MODULO='CA' THEN
                        cant:=REGEXP_COUNT(MOD_OPERA,'21');
                        modval:=REPLACE(MOD_OPERA,'21-', '');
                        --DBMS_OUTPUT.PUT_LINE ('MODULO '||JA_MODULO ||'- '||modval||'- ' ||cant);
                      END IF;
                      
                      IF JA_MODULO='DP' THEN
                        cant:=REGEXP_COUNT(MOD_OPERA,'22');
                        modval:=REPLACE(MOD_OPERA,'22-', '');
                        --DBMS_OUTPUT.PUT_LINE ('MODULO '||JA_MODULO ||'- '||modval||'- ' ||cant);
                      END IF;
                      
                      
                      
            
                      IF JA_MONEDA ='S' or JA_MONEDA ='D' THEN     
                              FOR i IN 1..cant LOOP
                                  tope:=REGEXP_SUBSTR(modval, '[^;]+', 1,i );
                                  --DBMS_OUTPUT.PUT_LINE ('TOPE  '||tope);
                                  FOR ad IN (
                                           SELECT a.PGCOD, a.SCCTA,a.SCSTAT,a.SCMOD,a.SCTOPE,a.SCMDA,a.SCSUC,a.SCPAP,a.SCOPER,a.SCSBOP,a.SCSDO 
                                            into apgcod,
                                                 accta,
                                                 ascstat,
                                                 ascmod,
                                                 asctope,
                                                 ascmda,
                                                 ascsuc,
                                                 ascpap,
                                                 ascoper,
                                                 ascsbop,
                                                 ascsdo
                                            from fsd011 a
                                            where a.SCMOD =(CASE WHEN JA_MODULO='CA' THEN 21
                                                                 WHEN JA_MODULO='DP' THEN 22
                                                                 END)
                                            and a.SCMDA  in (CASE WHEN JA_MONEDA='S' THEN 0
                                                                  WHEN JA_MONEDA='D' THEN 101
                                                                  END) 
                                            and a.SCFVAL >= JA_FECHA_APERTURA
                                            and a.SCFVAL <= JA_FECHA_CIERRE
                                            and a.SCCTA  >=  JA_CDESDE
                                            and a.SCCTA  <=  JA_CHASTA
                                            and a.SCTOPE = tope
                                            --and ROWNUM <= 50
                                  )
                                  LOOP
                                      --DBMS_OUTPUT.PUT_LINE ('CUENTA: '|| ad.SCCTA ||'-'||ad.SCSDO);
                                      CASE 
                                          WHEN JA_ESTADO='A' then
                                          --DBMS_OUTPUT.PUT_LINE ('ESTADO: A ');
                                                                      
                                              IF ad.SCSTAT <>99 and ad.SCSTAT<>81 THEN
                                                    FOR pd IN (
                                                        SELECT b.PEPAIS,b.PETDOC, b.PENDOC 
                                                        into  appais,
                                                              apetdoc,
                                                              apendoc
                                                        from fsr008 b
                                                        where b.PGCOD=ad.PGCOD
                                                        and b.CTNRO=ad.SCCTA
                                                        and b.TTCOD='1')
                                                    LOOP
                                                    
                                                    INSERT INTO JAQN452 (
                                                                JAQN452COD,
                                                                JAQN452PAI,
                                                                JAQN452TDO,
                                                                JAQN452NDO,
                                                                JAQN452EMP,--EMPRESA
                                                                JAQN452MOD,--MODULO
                                                                JAQN452SUC,--SUCURSAL
                                                                JAQN452MDA,--MONEDA
                                                                JAQN452PAP,--PAPEL
                                                                JAQN452CTA,--CUENTA
                                                                JAQN452OPE,--OPERACION
                                                                JAQN452SBO,--SUB TIPO DE OPERACION
                                                                JAQN452TOP)--TIPO DE OPERACION
                                                    VALUES (  JAQNCOD,
                                                                pd.PEPAIS,
                                                                pd.PETDOC,
                                                                pd.PENDOC,
                                                                ad.PGCOD,--EMPRESA
                                                                ad.SCMOD,--MODULO
                                                                ad.SCSUC,--SUCURSAL
                                                                ad.SCMDA,--MONEDA
                                                                ad.SCPAP,--PAPEL
                                                                ad.SCCTA,--CUENTA
                                                                ad.SCOPER,--OPERACION
                                                                ad.SCSBOP,--SUB TIPO DE OPERACION
                                                                ad.SCTOPE--TIPO DE OPERACION
                                                                );
                                                    commit;
                                                    
                                                        CASE  
                                                            WHEN TIPO_PERSONA = 'N' then
                                                            --DBMS_OUTPUT.PUT_LINE ('N: ');
                                                                FOR pn IN (
                                                                SELECT  c.PFPAIS,c.PFTDOC, c.PFNDOC,c.PFAPE1,c.PFAPE2,c.PFNOM1,c.PFNOM2
                                                                into  nppais,
                                                                      npetdoc,
                                                                      npendoc,
                                                                      nape1,
                                                                      nape2,
                                                                      nnom1,
                                                                      nnom2
                                                                from fsd002 c
                                                                where c.PFPAIS=pd.PEPAIS
                                                                and c.PFTDOC=pd.PETDOC
                                                                and c.PFNDOC=pd.PENDOC
                                                                and c.PFNDOC NOT IN (
                                                                            (SELECT JAQN451NDO
                                                                             FROM JAQN451
                                                                             WHERE JAQN451COD=JAQNCOD
                                                                             AND JAQN451FGE=JAQNFGE
                                                                              )
                                                                 )
                                                                )
                                                              LOOP
                                                                  JA_PAISOUT := pd.PEPAIS;
                                                                  JA_TIPOOUT := pd.PETDOC;
                                                                  JA_NUMERODOUT := pd.PENDOC;
                                                                  JA_NOMBREOUT := TRIM(pn.PFAPE1)||' '||TRIM(pn.PFAPE2)||' '||TRIM(pn.PFNOM1)||' '||TRIM(pn.PFNOM2);
                                                                  countn:=0;
                                                                  counte:=0;
                                                                  
                                                                      FOR pc IN (
                                                                            SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                            into  ddotelfp,
                                                                                  ddocod,
                                                                                  ddoorp,
                                                                                  nueve
                                                                            from fsr005 d
                                                                            where d.PEPAIS=pd.PEPAIS
                                                                            and d.PETDOC=pd.PETDOC
                                                                            and d.PENDOC=pd.PENDOC
                                                                            ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                      )LOOP
                                                                                largo := length(pc.DOTELFP);
                                                                                largocel := 9;
                                                                                emp:=SUBSTR(pc.DOTELFP,1,1);
                                                                                
                                                                                if largo = largocel and emp=9 and pc.CANT<>9 and countn<3 then
                                                                                  if countn=0 then
                                                                                    JA_CELULAR1OUT :=pc.DOTELFP;
                                                                                  end if;
                                                                                  if countn=1 and JA_CELULAR1OUT <> pc.DOTELFP then
                                                                                    JA_CELULAR2OUT :=pc.DOTELFP;
                                                                                  end if;
                                                                                  if countn=2 and JA_CELULAR1OUT <> pc.DOTELFP and JA_CELULAR2OUT <> pc.DOTELFP then
                                                                                    JA_CELULAR3OUT :=pc.DOTELFP;
                                                                                  end if;
                                                                                  countn := countn + 1;
                                                                                end if;
                                                                                
                                                                       END LOOP;
                                                                       
                                                                       FOR pe IN (
                                                                            SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                            into  email
                                                                            from FSX001 e
                                                                            where e.PEPAIS=pd.PEPAIS
                                                                            and e.PETDOC=pd.PETDOC
                                                                            and e.PENDOC=pd.PENDOC
                                                                            and e.TXCOD=0
                                                                            and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                            and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                            (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                              FROM JAQN454)
                                                                            )
                                                                            ORDER BY PEXREN DESC
                                                                        )LOOP
                                                                               --DBMS_OUTPUT.PUT_LINE ('EMAIL BAA: A '||regexp_substr(pe.PEXTXT,'[^\]*'));
                                                                          --if regexp_substr(pe.PEXTXT,'[^\]*')<>null OR regexp_substr(pe.PEXTXT,'[^\]*')<>'' then    
                                                                            if counte<3 then
                                                                                  if counte=0 then
                                                                                      JA_MAILOUT :=regexp_substr(pe.PEXTXT,'[^\]*');                     
                                                                                  end if;
                                                                                  if counte=1 then
                                                                                      JA_MAILOUT1 :=regexp_substr(pe.PEXTXT,'[^\]*');  
                                                                                  end if;
                                                                                  if counte=2 then
                                                                                      JA_MAILOUT2 :=regexp_substr(pe.PEXTXT,'[^\]*');
                                                                                  end if;
                                                                                  counte := counte + 1;                      
                                                                            end if;       
                                                                        --end if;            
                                                                        END LOOP;
                                                                       
                                                                       FOR ps IN (
                                                                                SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                into  
                                                                                SNGC13ppais,
                                                                                SNGC13petdoc,
                                                                                SNGC13pendoc,
                                                                                sDocod,
                                                                                      ssngc13Dir,
                                                                                      ssngc13RDes
                                                                                from SNGC13 f
                                                                                where f.sngc13Pais=pd.PEPAIS
                                                                                and f.sngc13Tdoc=pd.PETDOC
                                                                                and f.sngc13Ndoc=pd.PENDOC
                                                                                and f.SNGC13EST='H'
                                                                                order by sngc13RDes asc 
                                                                        )LOOP
                                                                              JA_DIRECCIONOUT := ps.sngc13Dir;
                                                                        END LOOP;
                                                                        
                                                                      --DBMS_OUTPUT.PUT_LINE ('NATURAL:'||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'||JA_MAILOUT1||'-'||JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                      INSERT INTO JAQN451 (
                                                                                      JAQN451COD,
                                                                                      JAQN451FGE,
                                                                                      JAQN451PAI,
                                                                                      JAQN451TDO,
                                                                                      JAQN451NDO,
                                                                                      JAQN451APE,
                                                                                      JAQN451CE1,
                                                                                      JAQN451CE2,
                                                                                      JAQN451CE3,
                                                                                      JAQN451CO1,
                                                                                      JAQN451CO2,
                                                                                      JAQN451CO3,
                                                                                      JAQN451DIR)
                                                                            VALUES (
                                                                                      JAQNCOD,
                                                                                      JAQNFGE,
                                                                                      JA_PAISOUT,
                                                                                      JA_TIPOOUT,
                                                                                      JA_NUMERODOUT,
                                                                                      JA_NOMBREOUT,
                                                                                      JA_CELULAR1OUT,
                                                                                      JA_CELULAR2OUT,
                                                                                      JA_CELULAR3OUT,
                                                                                      JA_MAILOUT,
                                                                                      JA_MAILOUT1,
                                                                                      JA_MAILOUT2,
                                                                                      JA_DIRECCIONOUT);
                                                                            commit;
                                                                            
                                                                            JA_MAILOUT :=null;   
                                                                            JA_MAILOUT1 :=null;   
                                                                            JA_MAILOUT2 :=null;  
                                                                            JA_CELULAR1OUT :=null;
                                                                            JA_CELULAR2OUT :=null;
                                                                            JA_CELULAR3OUT :=null;
                                                                          --DBMS_OUTPUT.PUT_LINE ('ESTADO A: '||ad.SCSTAT ||'-'||ad.PGCOD||'-' ||ad.SCCTA||'-' ||ad.SCMOD||'-' ||ad.SCTOPE||'-' ||pd.PEPAIS||'-' ||pd.PETDOC||'-' ||pd.PENDOC);
                                                   
                                                              END LOOP;--FSD001
                                                            
                                                  WHEN TIPO_PERSONA = 'J' then
                                                                FOR pg IN (
                                                                    SELECT  g.PJRAZS
                                                                    into gPjrazs
                                                                    from fsd003 g
                                                                    where g.Pjpais=pd.PEPAIS
                                                                    and g.Pjtdoc=pd.PETDOC
                                                                    and g.Pjndoc=pd.PENDOC
                                                                    and g.Pjndoc NOT IN (
                                                                            (SELECT JAQN451NDO
                                                                             FROM JAQN451
                                                                             WHERE JAQN451COD=JAQNCOD
                                                                             AND JAQN451FGE=JAQNFGE
                                                                              )
                                                                 )
                                                                )LOOP
                                                                      JA_PAISOUT := pd.PEPAIS;
                                                                      JA_TIPOOUT := pd.PETDOC;
                                                                      JA_NUMERODOUT := pd.PENDOC;
                                                                      JA_NOMBREOUT := pg.PJRAZS;
                                                                      countn:=0;
                                                                      counte:=0;
                                                                      FOR ph IN (
                                                                              SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                              into  ddotelfp,
                                                                                    ddocod,
                                                                                    ddoorp,
                                                                                    nueve
                                                                              from fsr005 d
                                                                              where d.PEPAIS=pd.PEPAIS
                                                                              and d.PETDOC=pd.PETDOC
                                                                              and d.PENDOC=pd.PENDOC
                                                                              ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                    )LOOP
                                                                              largo := length(ph.DOTELFP);
                                                                              largocel := 9;
                                                                              emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                              if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                  if countn=0 then
                                                                                    JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP then
                                                                                    JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                    JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  countn := countn + 1;
                                                                              end if;
                                                                     END LOOP;--FSR005
                                                                     
                                                                     FOR pi IN (
                                                                      SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                      into  email
                                                                      from FSX001 e
                                                                      where e.PEPAIS=pd.PEPAIS
                                                                      and e.PETDOC=pd.PETDOC
                                                                      and e.PENDOC=pd.PENDOC
                                                                      and e.TXCOD=0
                                                                      and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                      and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                            (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                             FROM JAQN454)
                                                                            )
                                                                      ORDER BY PEXREN DESC
                                                                      )LOOP
                                                                              if counte<3 then
                                                                                  if counte=0 then
                                                                                    JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=1 then
                                                                                    JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=2 then
                                                                                    JA_MAILOUT2 :=regexp_substr(regexp_substr(pi.PEXTXT,'[^\]*'),'[^\]*');   
                                                                                  end if;
                                                                                  counte := counte + 1;
                                                                              end if; 
                                                                      END LOOP;--FSX001
                                                                      
                                                                      
                                                                      
                                                                      FOR pj IN (
                                                                              SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                              into  
                                                                              SNGC13ppais,
                                                                              SNGC13petdoc,
                                                                              SNGC13pendoc,
                                                                              sDocod,
                                                                                    ssngc13Dir,
                                                                                    ssngc13RDes
                                                                              from SNGC13 f
                                                                              where f.sngc13Pais=pd.PEPAIS
                                                                              and f.sngc13Tdoc=pd.PETDOC
                                                                              and f.sngc13Ndoc=pd.PENDOC
                                                                              and f.SNGC13EST='H'
                                                                              order by sngc13RDes asc 
                                                                      )LOOP
                                                                                JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                      END LOOP;--SNGC13
                                                                      --DBMS_OUTPUT.PUT_LINE ('JURIDICA: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                      INSERT INTO JAQN451 (
                                                                                      JAQN451COD,
                                                                                      JAQN451FGE,
                                                                                      JAQN451PAI,
                                                                                      JAQN451TDO,
                                                                                      JAQN451NDO,
                                                                                      JAQN451APE,
                                                                                      JAQN451CE1,
                                                                                      JAQN451CE2,
                                                                                      JAQN451CE3,
                                                                                      JAQN451CO1,
                                                                                      JAQN451CO2,
                                                                                      JAQN451CO3,
                                                                                      JAQN451DIR)
                                                                            VALUES (
                                                                                      JAQNCOD,
                                                                                      JAQNFGE,
                                                                                      JA_PAISOUT,
                                                                                      JA_TIPOOUT,
                                                                                      JA_NUMERODOUT,
                                                                                      JA_NOMBREOUT,
                                                                                      JA_CELULAR1OUT,
                                                                                      JA_CELULAR2OUT,
                                                                                      JA_CELULAR3OUT,
                                                                                      JA_MAILOUT,
                                                                                      JA_MAILOUT1,
                                                                                      JA_MAILOUT2,
                                                                                      JA_DIRECCIONOUT);
                                                                            commit;
                                                                          
                                                                            JA_MAILOUT :=null;   
                                                                            JA_MAILOUT1 :=null;   
                                                                            JA_MAILOUT2 :=null;  
                                                                            JA_CELULAR1OUT :=null;
                                                                            JA_CELULAR2OUT :=null;
                                                                            JA_CELULAR3OUT :=null;
                                                                END LOOP;--FSD002
                                                                
                                                                
                                                                
                                                                
                                                  WHEN TIPO_PERSONA = 'A' then
                                                                FOR pg IN (
                                                                    SELECT  k.PENOM
                                                                    into aPenom
                                                                    from fsd001 k
                                                                    where k.Pepais=pd.PEPAIS
                                                                    and k.Petdoc=pd.PETDOC
                                                                    and k.Pendoc=pd.PENDOC
                                                                    and k.Pendoc NOT IN (
                                                                            (SELECT JAQN451NDO
                                                                             FROM JAQN451
                                                                             WHERE JAQN451COD=JAQNCOD
                                                                             AND JAQN451FGE=JAQNFGE
                                                                              )
                                                                      )
                                                                    
                                                                )LOOP
                                                                      JA_PAISOUT := pd.PEPAIS;
                                                                      JA_TIPOOUT := pd.PETDOC;
                                                                      JA_NUMERODOUT := pd.PENDOC;
                                                                      JA_NOMBREOUT := pg.PENOM;
                                                                      countn:=0;
                                                                      counte:=0;
                                                                      FOR ph IN (
                                                                              SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                              into  ddotelfp,
                                                                                    ddocod,
                                                                                    ddoorp,
                                                                                    nueve
                                                                              from fsr005 d
                                                                              where d.PEPAIS=pd.PEPAIS
                                                                              and d.PETDOC=pd.PETDOC
                                                                              and d.PENDOC=pd.PENDOC
                                                                              ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                    )LOOP
                                                                              largo := length(ph.DOTELFP);
                                                                              largocel := 9;
                                                                              emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                              if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                  if countn=0 then
                                                                                    JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=1  and JA_CELULAR1OUT <> ph.DOTELFP then
                                                                                    JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=2  and JA_CELULAR1OUT <> ph.DOTELFP and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                    JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  countn := countn + 1;
                                                                              end if;
                                                                     END LOOP;--FSR005
                                                                     
                                                                     FOR pi IN (
                                                                      SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                      into  email
                                                                      from FSX001 e
                                                                      where e.PEPAIS=pd.PEPAIS
                                                                      and e.PETDOC=pd.PETDOC
                                                                      and e.PENDOC=pd.PENDOC
                                                                      and e.TXCOD=0
                                                                      and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                      and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                           (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                             FROM JAQN454)
                                                                            )
                                                                      ORDER BY PEXREN DESC
                                                                      )LOOP
                                                                              if counte<3 then
                                                                                  if counte=0 then
                                                                                    JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=1 then
                                                                                    JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=2 then
                                                                                    JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  counte := counte + 1;
                                                                              end if; 
                                                                      END LOOP;--FSX001
                                                                      
                                                                      
                                                                      
                                                                      FOR pj IN (
                                                                              SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                              into  
                                                                              SNGC13ppais,
                                                                              SNGC13petdoc,
                                                                              SNGC13pendoc,
                                                                              sDocod,
                                                                                    ssngc13Dir,
                                                                                    ssngc13RDes
                                                                              from SNGC13 f
                                                                              where f.sngc13Pais=pd.PEPAIS
                                                                              and f.sngc13Tdoc=pd.PETDOC
                                                                              and f.sngc13Ndoc=pd.PENDOC
                                                                              and f.SNGC13EST='H'
                                                                              order by sngc13RDes asc 
                                                                      )LOOP
                                                                                JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                      END LOOP;--SNGC13
                                                                      --DBMS_OUTPUT.PUT_LINE ('AMBAS: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                      INSERT INTO JAQN451 (
                                                                                      JAQN451COD,
                                                                                      JAQN451FGE,
                                                                                      JAQN451PAI,
                                                                                      JAQN451TDO,
                                                                                      JAQN451NDO,
                                                                                      JAQN451APE,
                                                                                      JAQN451CE1,
                                                                                      JAQN451CE2,
                                                                                      JAQN451CE3,
                                                                                      JAQN451CO1,
                                                                                      JAQN451CO2,
                                                                                      JAQN451CO3,
                                                                                      JAQN451DIR)
                                                                            VALUES (
                                                                                      JAQNCOD,
                                                                                      JAQNFGE,
                                                                                      JA_PAISOUT,
                                                                                      JA_TIPOOUT,
                                                                                      JA_NUMERODOUT,
                                                                                      JA_NOMBREOUT,
                                                                                      JA_CELULAR1OUT,
                                                                                      JA_CELULAR2OUT,
                                                                                      JA_CELULAR3OUT,
                                                                                      JA_MAILOUT,
                                                                                      JA_MAILOUT1,
                                                                                      JA_MAILOUT2,
                                                                                      JA_DIRECCIONOUT);
                                                                            commit;
                                                                            
                                                                            
                                                                            
                                                                            JA_MAILOUT :=null;   
                                                                            JA_MAILOUT1 :=null;   
                                                                            JA_MAILOUT2 :=null;  
                                                                            JA_CELULAR1OUT :=null;
                                                                            JA_CELULAR2OUT :=null;
                                                                            JA_CELULAR3OUT :=null;
                                                                END LOOP;--FSD002
                                                            
                                                            END CASE;
                                                    END LOOP;
          
                                              END IF;
                                              
                                              
                                          WHEN JA_ESTADO='I' then
                                              IF ad.SCSTAT =81 THEN
                                                --DBMS_OUTPUT.PUT_LINE ('ESTADO I: '||ad.SCSTAT ||'-'||ad.PGCOD||'-' ||ad.SCCTA||'-' ||ad.SCMOD||'-' ||ad.SCTOPE);
                                                       
                                                              FOR pd IN (
                                                                  SELECT b.PEPAIS,b.PETDOC, b.PENDOC 
                                                                  into  appais,
                                                                        apetdoc,
                                                                        apendoc
                                                                  from fsr008 b
                                                                  where b.PGCOD=ad.PGCOD
                                                                  and b.CTNRO=ad.SCCTA
                                                                  and b.TTCOD='1')
                                                              LOOP
                                                              
                                                              INSERT INTO JAQN452 (
                                                                JAQN452COD,
                                                                JAQN452PAI,
                                                                JAQN452TDO,
                                                                JAQN452NDO,
                                                                JAQN452EMP,--EMPRESA
                                                                JAQN452MOD,--MODULO
                                                                JAQN452SUC,--SUCURSAL
                                                                JAQN452MDA,--MONEDA
                                                                JAQN452PAP,--PAPEL
                                                                JAQN452CTA,--CUENTA
                                                                JAQN452OPE,--OPERACION
                                                                JAQN452SBO,--SUB TIPO DE OPERACION
                                                                JAQN452TOP)--TIPO DE OPERACION
                                                                VALUES (  JAQNCOD,
                                                                            pd.PEPAIS,
                                                                            pd.PETDOC,
                                                                            pd.PENDOC,
                                                                            ad.PGCOD,--EMPRESA
                                                                            ad.SCMOD,--MODULO
                                                                            ad.SCSUC,--SUCURSAL
                                                                            ad.SCMDA,--MONEDA
                                                                            ad.SCPAP,--PAPEL
                                                                            ad.SCCTA,--CUENTA
                                                                            ad.SCOPER,--OPERACION
                                                                            ad.SCSBOP,--SUB TIPO DE OPERACION
                                                                            ad.SCTOPE
                                                                            );
                                                                commit;
     
                                                                  CASE  
                                                                      WHEN TIPO_PERSONA = 'N' then
                                                                      
                                                                          FOR pn IN (
                                                                          SELECT c.PFPAIS,c.PFTDOC, c.PFNDOC,c.PFAPE1,c.PFAPE2,c.PFNOM1,c.PFNOM2
                                                                          into  nppais,
                                                                                npetdoc,
                                                                                npendoc,
                                                                                nape1,
                                                                                nape2,
                                                                                nnom1,
                                                                                nnom2
                                                                          from fsd002 c
                                                                          where c.PFPAIS=pd.PEPAIS
                                                                          and c.PFTDOC=pd.PETDOC
                                                                          and c.PFNDOC=pd.PENDOC
                                                                          and c.PFNDOC NOT IN (
                                                                            (SELECT JAQN451NDO
                                                                             FROM JAQN451
                                                                             WHERE JAQN451COD=JAQNCOD
                                                                             AND JAQN451FGE=JAQNFGE
                                                                              )
                                                                            )
                                                                          )
                                                                        LOOP
                                                                            JA_PAISOUT := pd.PEPAIS;
                                                                            JA_TIPOOUT := pd.PETDOC;
                                                                            JA_NUMERODOUT := pd.PENDOC;
                                                                            JA_NOMBREOUT := TRIM(pn.PFAPE1)||' '||TRIM(pn.PFAPE2)||' '||TRIM(pn.PFNOM1)||' '||TRIM(pn.PFNOM2);
                                                                            countn:=0;
                                                                            counte:=0;
                                                                            
                                                                                FOR pc IN (
                                                                                      SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                                      into  ddotelfp,
                                                                                            ddocod,
                                                                                            ddoorp,
                                                                                            nueve
                                                                                      from fsr005 d
                                                                                      where d.PEPAIS=pd.PEPAIS
                                                                                      and d.PETDOC=pd.PETDOC
                                                                                      and d.PENDOC=pd.PENDOC
                                                                                      ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                                )LOOP
                                                                                          largo := length(pc.DOTELFP);
                                                                                          largocel := 9;
                                                                                          emp:=SUBSTR(pc.DOTELFP,1,1);
                                                                                          if largo = largocel and emp=9 and pc.CANT<>9 and countn<3 then
                                                                                            if countn=0 then
                                                                                              JA_CELULAR1OUT :=pc.DOTELFP;
                                                                                            end if;
                                                                                            if countn=1 and JA_CELULAR1OUT <> pc.DOTELFP then
                                                                                              JA_CELULAR2OUT :=pc.DOTELFP;
                                                                                            end if;
                                                                                            if countn=2 and JA_CELULAR1OUT <> pc.DOTELFP and JA_CELULAR2OUT <> pc.DOTELFP  then
                                                                                              JA_CELULAR3OUT :=pc.DOTELFP;
                                                                                            end if;
                                                                                            countn := countn + 1;
                                                                                          end if;         
                                                                                 END LOOP;
                                                                                 
                                                                                 FOR pe IN (
                                                                                      SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                                      into  email
                                                                                      from FSX001 e
                                                                                      where e.PEPAIS=pd.PEPAIS
                                                                                      and e.PETDOC=pd.PETDOC
                                                                                      and e.PENDOC=pd.PENDOC
                                                                                      and e.TXCOD=0
                                                                                      and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                                      and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                                    (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                       FROM JAQN454)
                                                                                      )
                                                                                      ORDER BY PEXREN DESC
                                                                                  )LOOP
                                                                                        if counte<3 then
                                                                                            if counte=0 then
                                                                                              JA_MAILOUT :=regexp_substr(pe.PEXTXT,'[^\]*');   
                                                                                            end if;
                                                                                            if counte=1 then
                                                                                              JA_MAILOUT1 :=regexp_substr(pe.PEXTXT,'[^\]*');   
                                                                                            end if;
                                                                                            if counte=2 then
                                                                                              JA_MAILOUT2 :=regexp_substr(pe.PEXTXT,'[^\]*');   
                                                                                            end if;
                                                                                            counte := counte + 1;
                                                                                        end if; 
                    
                                                                                  END LOOP;
                                                                                 
                                                                                 FOR ps IN (
                                                                                          SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                          into  
                                                                                          SNGC13ppais,
                                                                                          SNGC13petdoc,
                                                                                          SNGC13pendoc,
                                                                                          sDocod,
                                                                                                ssngc13Dir,
                                                                                                ssngc13RDes
                                                                                          from SNGC13 f
                                                                                          where f.sngc13Pais=pd.PEPAIS
                                                                                          and f.sngc13Tdoc=pd.PETDOC
                                                                                          and f.sngc13Ndoc=pd.PENDOC
                                                                                          and f.SNGC13EST='H'
                                                                                          order by sngc13RDes asc 
                                                                                  )LOOP
                                                                                        JA_DIRECCIONOUT := ps.sngc13Dir;
                                                                                  END LOOP;
                                                                                  
                                                                                  --DBMS_OUTPUT.PUT_LINE ('CUENTA: '|| ad.SCCTA );
                                                                                  --DBMS_OUTPUT.PUT_LINE ('NATURAL:'||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'||JA_MAILOUT1||'-'||JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                                  INSERT INTO JAQN451 (
                                                                                                JAQN451COD,
                                                                                                JAQN451FGE,
                                                                                                JAQN451PAI,
                                                                                                JAQN451TDO,
                                                                                                JAQN451NDO,
                                                                                                JAQN451APE,
                                                                                                JAQN451CE1,
                                                                                                JAQN451CE2,
                                                                                                JAQN451CE3,
                                                                                                JAQN451CO1,
                                                                                                JAQN451CO2,
                                                                                                JAQN451CO3,
                                                                                                JAQN451DIR)
                                                                                      VALUES (
                                                                                                JAQNCOD,
                                                                                                JAQNFGE,
                                                                                                JA_PAISOUT,
                                                                                                JA_TIPOOUT,
                                                                                                JA_NUMERODOUT,
                                                                                                JA_NOMBREOUT,
                                                                                                JA_CELULAR1OUT,
                                                                                                JA_CELULAR2OUT,
                                                                                                JA_CELULAR3OUT,
                                                                                                JA_MAILOUT,
                                                                                                JA_MAILOUT1,
                                                                                                JA_MAILOUT2,
                                                                                                JA_DIRECCIONOUT);
                                                                                      commit;
                                                                                      
                                                                                      
                                                                                      JA_MAILOUT :=null;   
                                                                                      JA_MAILOUT1 :=null;   
                                                                                      JA_MAILOUT2 :=null;  
                                                                                      JA_CELULAR1OUT :=null;
                                                                                      JA_CELULAR2OUT :=null;
                                                                                      JA_CELULAR3OUT :=null;
                                                                                    --DBMS_OUTPUT.PUT_LINE ('ESTADO A: '||ad.SCSTAT ||'-'||ad.PGCOD||'-' ||ad.SCCTA||'-' ||ad.SCMOD||'-' ||ad.SCTOPE||'-' ||pd.PEPAIS||'-' ||pd.PETDOC||'-' ||pd.PENDOC);
                                                             
                                                                        END LOOP;--FSD001
                                                                      
                                                            WHEN TIPO_PERSONA = 'J' then
                                                                          FOR pg IN (
                                                                              SELECT g.PJRAZS
                                                                              into gPjrazs
                                                                              from fsd003 g
                                                                              where g.Pjpais=pd.PEPAIS
                                                                              and g.Pjtdoc=pd.PETDOC
                                                                              and g.Pjndoc=pd.PENDOC
                                                                              and g.Pjndoc NOT IN (
                                                                              (SELECT JAQN451NDO
                                                                               FROM JAQN451
                                                                               WHERE JAQN451COD=JAQNCOD
                                                                               AND JAQN451FGE=JAQNFGE
                                                                                )
                                                                              )
                                                                          )LOOP
                                                                                JA_PAISOUT := pd.PEPAIS;
                                                                                JA_TIPOOUT := pd.PETDOC;
                                                                                JA_NUMERODOUT := pd.PENDOC;
                                                                                JA_NOMBREOUT := pg.PJRAZS;
                                                                                countn:=0;
                                                                                counte:=0;
                                                                                FOR ph IN (
                                                                                        SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                                        into  ddotelfp,
                                                                                              ddocod,
                                                                                              ddoorp,
                                                                                              nueve
                                                                                        from fsr005 d
                                                                                        where d.PEPAIS=pd.PEPAIS
                                                                                        and d.PETDOC=pd.PETDOC
                                                                                        and d.PENDOC=pd.PENDOC
                                                                                        ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                              )LOOP
                                                                                        largo := length(ph.DOTELFP);
                                                                                        largocel := 9;
                                                                                        emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                                        if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                            if countn=0 then
                                                                                              JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                            end if;
                                                                                            if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP then
                                                                                              JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                            end if;
                                                                                            if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                              JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                            end if;
                                                                                            countn := countn + 1;
                                                                                        end if;
                                                                               END LOOP;--FSR005
                                                                               
                                                                               FOR pi IN (
                                                                                SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                                into  email
                                                                                from FSX001 e
                                                                                where e.PEPAIS=pd.PEPAIS
                                                                                and e.PETDOC=pd.PETDOC
                                                                                and e.PENDOC=pd.PENDOC
                                                                                and e.TXCOD=0
                                                                                and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                                and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                                    (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                       FROM JAQN454)
                                                                                      )
                                                                                ORDER BY PEXREN DESC
                                                                                )LOOP
                                                                                        if counte<3 then
                                                                                            if counte=0 then
                                                                                              JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                            end if;
                                                                                            if counte=1 then
                                                                                              JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                            end if;
                                                                                            if counte=2 then
                                                                                              JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                            end if;
                                                                                            counte := counte + 1;
                                                                                        end if; 
                                                                                END LOOP;--FSX001
                                                                                
                                                                                
                                                                                
                                                                                FOR pj IN (
                                                                                        SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                        into  
                                                                                        SNGC13ppais,
                                                                                        SNGC13petdoc,
                                                                                        SNGC13pendoc,
                                                                                        sDocod,
                                                                                              ssngc13Dir,
                                                                                              ssngc13RDes
                                                                                        from SNGC13 f
                                                                                        where f.sngc13Pais=pd.PEPAIS
                                                                                        and f.sngc13Tdoc=pd.PETDOC
                                                                                        and f.sngc13Ndoc=pd.PENDOC
                                                                                        and f.SNGC13EST='H'
                                                                                        order by sngc13RDes asc 
                                                                                )LOOP
                                                                                          JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                                END LOOP;--SNGC13
                                                                                --DBMS_OUTPUT.PUT_LINE ('JURIDICA: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                                INSERT INTO JAQN451 (
                                                                                                JAQN451COD,
                                                                                                JAQN451FGE,
                                                                                                JAQN451PAI,
                                                                                                JAQN451TDO,
                                                                                                JAQN451NDO,
                                                                                                JAQN451APE,
                                                                                                JAQN451CE1,
                                                                                                JAQN451CE2,
                                                                                                JAQN451CE3,
                                                                                                JAQN451CO1,
                                                                                                JAQN451CO2,
                                                                                                JAQN451CO3,
                                                                                                JAQN451DIR)
                                                                                      VALUES (
                                                                                                JAQNCOD,
                                                                                                JAQNFGE,
                                                                                                JA_PAISOUT,
                                                                                                JA_TIPOOUT,
                                                                                                JA_NUMERODOUT,
                                                                                                JA_NOMBREOUT,
                                                                                                JA_CELULAR1OUT,
                                                                                                JA_CELULAR2OUT,
                                                                                                JA_CELULAR3OUT,
                                                                                                JA_MAILOUT,
                                                                                                JA_MAILOUT1,
                                                                                                JA_MAILOUT2,
                                                                                                JA_DIRECCIONOUT);
                                                                                      commit;
                                                                                      
                                                                                     
                                                                                      JA_MAILOUT :=null;   
                                                                                      JA_MAILOUT1 :=null;   
                                                                                      JA_MAILOUT2 :=null;  
                                                                                      JA_CELULAR1OUT :=null;
                                                                                      JA_CELULAR2OUT :=null;
                                                                                      JA_CELULAR3OUT :=null;
                                                                          END LOOP;--FSD002
                                                                          
                                                                          
                                                                          
                                                                          
                                                            WHEN TIPO_PERSONA = 'A' then
                                                                          FOR pg IN (
                                                                              SELECT k.PENOM
                                                                              into aPenom
                                                                              from fsd001 k
                                                                              where k.Pepais=pd.PEPAIS
                                                                              and k.Petdoc=pd.PETDOC
                                                                              and k.Pendoc=pd.PENDOC
                                                                              and k.Pendoc NOT IN (
                                                                              (SELECT JAQN451NDO
                                                                               FROM JAQN451
                                                                               WHERE JAQN451COD=JAQNCOD
                                                                               AND JAQN451FGE=JAQNFGE
                                                                                )
                                                                              )
                                                                          )LOOP
                                                                                JA_PAISOUT := pd.PEPAIS;
                                                                                JA_TIPOOUT := pd.PETDOC;
                                                                                JA_NUMERODOUT := pd.PENDOC;
                                                                                JA_NOMBREOUT := pg.PENOM;
                                                                                countn:=0;
                                                                                counte:=0;
                                                                                FOR ph IN (
                                                                                        SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                                        into  ddotelfp,
                                                                                              ddocod,
                                                                                              ddoorp,
                                                                                              nueve
                                                                                        from fsr005 d
                                                                                        where d.PEPAIS=pd.PEPAIS
                                                                                        and d.PETDOC=pd.PETDOC
                                                                                        and d.PENDOC=pd.PENDOC
                                                                                        ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                              )LOOP
                                                                                        largo := length(ph.DOTELFP);
                                                                                        largocel := 9;
                                                                                        emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                                        if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                            if countn=0 then
                                                                                              JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                            end if;
                                                                                            if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP then
                                                                                              JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                            end if;
                                                                                            if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                              JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                            end if;
                                                                                            countn := countn + 1;
                                                                                        end if;
                                                                               END LOOP;--FSR005
                                                                               
                                                                               FOR pi IN (
                                                                                SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                                into  email
                                                                                from FSX001 e
                                                                                where e.PEPAIS=pd.PEPAIS
                                                                                and e.PETDOC=pd.PETDOC
                                                                                and e.PENDOC=pd.PENDOC
                                                                                and e.TXCOD=0
                                                                                and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                                and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                                    (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                       FROM JAQN454)
                                                                                    )
                                                                                ORDER BY PEXREN DESC
                                                                                )LOOP
                                                                                        if counte<3 then
                                                                                            if counte=0 then
                                                                                              JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                            end if;
                                                                                            if counte=1 then
                                                                                              JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                            end if;
                                                                                            if counte=2 then
                                                                                              JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                            end if;
                                                                                            counte := counte + 1;
                                                                                        end if; 
                                                                                END LOOP;--FSX001
                                                                                
                                                                                
                                                                                
                                                                                FOR pj IN (
                                                                                        SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                        into  
                                                                                        SNGC13ppais,
                                                                                        SNGC13petdoc,
                                                                                        SNGC13pendoc,
                                                                                        sDocod,
                                                                                              ssngc13Dir,
                                                                                              ssngc13RDes
                                                                                        from SNGC13 f
                                                                                        where f.sngc13Pais=pd.PEPAIS
                                                                                        and f.sngc13Tdoc=pd.PETDOC
                                                                                        and f.sngc13Ndoc=pd.PENDOC
                                                                                        and f.SNGC13EST='H'
                                                                                        order by sngc13RDes asc 
                                                                                )LOOP
                                                                                          JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                                END LOOP;--SNGC13
                                                                                --DBMS_OUTPUT.PUT_LINE ('AMBAS: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                                INSERT INTO JAQN451 (
                                                                                                JAQN451COD,
                                                                                                JAQN451FGE,
                                                                                                JAQN451PAI,
                                                                                                JAQN451TDO,
                                                                                                JAQN451NDO,
                                                                                                JAQN451APE,
                                                                                                JAQN451CE1,
                                                                                                JAQN451CE2,
                                                                                                JAQN451CE3,
                                                                                                JAQN451CO1,
                                                                                                JAQN451CO2,
                                                                                                JAQN451CO3,
                                                                                                JAQN451DIR)
                                                                                      VALUES (
                                                                                                JAQNCOD,
                                                                                                JAQNFGE,
                                                                                                JA_PAISOUT,
                                                                                                JA_TIPOOUT,
                                                                                                JA_NUMERODOUT,
                                                                                                JA_NOMBREOUT,
                                                                                                JA_CELULAR1OUT,
                                                                                                JA_CELULAR2OUT,
                                                                                                JA_CELULAR3OUT,
                                                                                                JA_MAILOUT,
                                                                                                JA_MAILOUT1,
                                                                                                JA_MAILOUT2,
                                                                                                JA_DIRECCIONOUT);
                                                                                      commit;
                                                                                      
                                                                                      
                                                                                      
                                                                                      
                                                                                      JA_MAILOUT :=null;   
                                                                                      JA_MAILOUT1 :=null;   
                                                                                      JA_MAILOUT2 :=null;  
                                                                                      JA_CELULAR1OUT :=null;
                                                                                      JA_CELULAR2OUT :=null;
                                                                                      JA_CELULAR3OUT :=null;
                                                                          END LOOP;--FSD002
                                                                    
                                                                      END CASE;
                                                              END LOOP;
                                                    
                                              END IF; --ESTADO I
                                              
                                          WHEN JA_ESTADO='T' then
                                            
                                                    FOR pd IN (
                                                        SELECT b.PEPAIS,b.PETDOC, b.PENDOC 
                                                        into  appais,
                                                              apetdoc,
                                                              apendoc
                                                        from fsr008 b
                                                        where b.PGCOD=ad.PGCOD
                                                        and b.CTNRO=ad.SCCTA
                                                        and b.TTCOD='1')
                                                    LOOP
                                                    INSERT INTO JAQN452 (
                                                                JAQN452COD,
                                                                JAQN452PAI,
                                                                JAQN452TDO,
                                                                JAQN452NDO,
                                                                JAQN452EMP,--EMPRESA
                                                                JAQN452MOD,--MODULO
                                                                JAQN452SUC,--SUCURSAL
                                                                JAQN452MDA,--MONEDA
                                                                JAQN452PAP,--PAPEL
                                                                JAQN452CTA,--CUENTA
                                                                JAQN452OPE,--OPERACION
                                                                JAQN452SBO,--SUB TIPO DE OPERACION
                                                                JAQN452TOP)--TIPO DE OPERACION
                                                    VALUES (  JAQNCOD,
                                                                pd.PEPAIS,
                                                                pd.PETDOC,
                                                                pd.PENDOC,
                                                                ad.PGCOD,--EMPRESA
                                                                ad.SCMOD,--MODULO
                                                                ad.SCSUC,--SUCURSAL
                                                                ad.SCMDA,--MONEDA
                                                                ad.SCPAP,--PAPEL
                                                                ad.SCCTA,--CUENTA
                                                                ad.SCOPER,--OPERACION
                                                                ad.SCSBOP,--SUB TIPO DE OPERACION
                                                                ad.SCTOPE
                                                                );
                                                    commit;
                                                    
                                                        CASE  
                                                            WHEN TIPO_PERSONA = 'N' then
                                                            --DBMS_OUTPUT.PUT_LINE ('N: ');
                                                                FOR pn IN (
                                                                SELECT  c.PFPAIS,c.PFTDOC, c.PFNDOC,c.PFAPE1,c.PFAPE2,c.PFNOM1,c.PFNOM2
                                                                into  nppais,
                                                                      npetdoc,
                                                                      npendoc,
                                                                      nape1,
                                                                      nape2,
                                                                      nnom1,
                                                                      nnom2
                                                                from fsd002 c
                                                                where c.PFPAIS=pd.PEPAIS
                                                                and c.PFTDOC=pd.PETDOC
                                                                and c.PFNDOC=pd.PENDOC
                                                                and c.PFNDOC NOT IN (
                                                                            (SELECT JAQN451NDO
                                                                             FROM JAQN451
                                                                             WHERE JAQN451COD=JAQNCOD
                                                                             AND JAQN451FGE=JAQNFGE
                                                                              )
                                                                 )
                                                                )
                                                              LOOP
                                                                  JA_PAISOUT := pd.PEPAIS;
                                                                  JA_TIPOOUT := pd.PETDOC;
                                                                  JA_NUMERODOUT := pd.PENDOC;
                                                                  JA_NOMBREOUT := TRIM(pn.PFAPE1)||' '||TRIM(pn.PFAPE2)||' '||TRIM(pn.PFNOM1)||' '||TRIM(pn.PFNOM2);
                                                                  countn:=0;
                                                                  counte:=0;
                                                                  
                                                                      FOR pc IN (
                                                                            SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                            into  ddotelfp,
                                                                                  ddocod,
                                                                                  ddoorp,
                                                                                  nueve
                                                                            from fsr005 d
                                                                            where d.PEPAIS=pd.PEPAIS
                                                                            and d.PETDOC=pd.PETDOC
                                                                            and d.PENDOC=pd.PENDOC
                                                                            ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                      )LOOP
                                                                                largo := length(pc.DOTELFP);
                                                                                largocel := 9;
                                                                                emp:=SUBSTR(pc.DOTELFP,1,1);
                                                                                if largo = largocel and emp=9 and pc.CANT<>9 and countn<3 then
                                                                                  if countn=0 then
                                                                                    JA_CELULAR1OUT :=pc.DOTELFP;
                                                                                  end if;
                                                                                  if countn=1 and JA_CELULAR1OUT <> pc.DOTELFP then
                                                                                    JA_CELULAR2OUT :=pc.DOTELFP;
                                                                                  end if;
                                                                                  if countn=2 and JA_CELULAR1OUT <> pc.DOTELFP and JA_CELULAR2OUT <> pc.DOTELFP then
                                                                                    JA_CELULAR3OUT :=pc.DOTELFP;
                                                                                  end if;
                                                                                  countn := countn + 1;
                                                                                end if;         
                                                                       END LOOP;
                                                                       
                                                                       FOR pe IN (
                                                                            SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                            into  email
                                                                            from FSX001 e
                                                                            where e.PEPAIS=pd.PEPAIS
                                                                            and e.PETDOC=pd.PETDOC
                                                                            and e.PENDOC=pd.PENDOC
                                                                            and e.TXCOD=0
                                                                            and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                            and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                            (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                       FROM JAQN454)
                                                                            )
                                                                            ORDER BY PEXREN DESC
                                                                        )LOOP
                                                                               --DBMS_OUTPUT.PUT_LINE ('EMAIL BAA: A '||regexp_substr(pe.PEXTXT,'[^\]*'));
                                                                          --if regexp_substr(pe.PEXTXT,'[^\]*')<>null OR regexp_substr(pe.PEXTXT,'[^\]*')<>'' then    
                                                                            if counte<3 then
                                                                                  if counte=0 then
                                                                                      JA_MAILOUT :=regexp_substr(pe.PEXTXT,'[^\]*');                    
                                                                                  end if;
                                                                                  if counte=1 then
                                                                                      JA_MAILOUT1 :=regexp_substr(pe.PEXTXT,'[^\]*');  
                                                                                  end if;
                                                                                  if counte=2 then
                                                                                      JA_MAILOUT2 :=regexp_substr(pe.PEXTXT,'[^\]*');
                                                                                  end if;
                                                                                  counte := counte + 1;                      
                                                                            end if;       
                                                                        --end if;            
                                                                        END LOOP;
                                                                       
                                                                       FOR ps IN (
                                                                                SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                into  
                                                                                SNGC13ppais,
                                                                                SNGC13petdoc,
                                                                                SNGC13pendoc,
                                                                                sDocod,
                                                                                      ssngc13Dir,
                                                                                      ssngc13RDes
                                                                                from SNGC13 f
                                                                                where f.sngc13Pais=pd.PEPAIS
                                                                                and f.sngc13Tdoc=pd.PETDOC
                                                                                and f.sngc13Ndoc=pd.PENDOC
                                                                                and f.SNGC13EST='H'
                                                                                order by sngc13RDes asc 
                                                                        )LOOP
                                                                              JA_DIRECCIONOUT := ps.sngc13Dir;
                                                                        END LOOP;
                                                                        
                                                                      --DBMS_OUTPUT.PUT_LINE ('NATURAL:'||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'||JA_MAILOUT1||'-'||JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                      INSERT INTO JAQN451 (
                                                                                      JAQN451COD,
                                                                                      JAQN451FGE,
                                                                                      JAQN451PAI,
                                                                                      JAQN451TDO,
                                                                                      JAQN451NDO,
                                                                                      JAQN451APE,
                                                                                      JAQN451CE1,
                                                                                      JAQN451CE2,
                                                                                      JAQN451CE3,
                                                                                      JAQN451CO1,
                                                                                      JAQN451CO2,
                                                                                      JAQN451CO3,
                                                                                      JAQN451DIR)
                                                                            VALUES (
                                                                                      JAQNCOD,
                                                                                      JAQNFGE,
                                                                                      JA_PAISOUT,
                                                                                      JA_TIPOOUT,
                                                                                      JA_NUMERODOUT,
                                                                                      JA_NOMBREOUT,
                                                                                      JA_CELULAR1OUT,
                                                                                      JA_CELULAR2OUT,
                                                                                      JA_CELULAR3OUT,
                                                                                      JA_MAILOUT,
                                                                                      JA_MAILOUT1,
                                                                                      JA_MAILOUT2,
                                                                                      JA_DIRECCIONOUT);
                                                                            commit;
                                                                            
                                                                            
                                                                          
                                                                            JA_MAILOUT :=null;   
                                                                            JA_MAILOUT1 :=null;   
                                                                            JA_MAILOUT2 :=null;  
                                                                            JA_CELULAR1OUT :=null;
                                                                            JA_CELULAR2OUT :=null;
                                                                            JA_CELULAR3OUT :=null;
                                                                          --DBMS_OUTPUT.PUT_LINE ('ESTADO A: '||ad.SCSTAT ||'-'||ad.PGCOD||'-' ||ad.SCCTA||'-' ||ad.SCMOD||'-' ||ad.SCTOPE||'-' ||pd.PEPAIS||'-' ||pd.PETDOC||'-' ||pd.PENDOC);
                                                   
                                                              END LOOP;--FSD001
                                                            
                                                  WHEN TIPO_PERSONA = 'J' then
                                                                FOR pg IN (
                                                                    SELECT  g.PJRAZS
                                                                    into gPjrazs
                                                                    from fsd003 g
                                                                    where g.Pjpais=pd.PEPAIS
                                                                    and g.Pjtdoc=pd.PETDOC
                                                                    and g.Pjndoc=pd.PENDOC
                                                                    and g.Pjndoc NOT IN (
                                                                            (SELECT JAQN451NDO
                                                                             FROM JAQN451
                                                                             WHERE JAQN451COD=JAQNCOD
                                                                             AND JAQN451FGE=JAQNFGE
                                                                              )
                                                                 )
                                                                )LOOP
                                                                      JA_PAISOUT := pd.PEPAIS;
                                                                      JA_TIPOOUT := pd.PETDOC;
                                                                      JA_NUMERODOUT := pd.PENDOC;
                                                                      JA_NOMBREOUT := pg.PJRAZS;
                                                                      countn:=0;
                                                                      counte:=0;
                                                                      FOR ph IN (
                                                                              SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                              into  ddotelfp,
                                                                                    ddocod,
                                                                                    ddoorp,
                                                                                    nueve
                                                                              from fsr005 d
                                                                              where d.PEPAIS=pd.PEPAIS
                                                                              and d.PETDOC=pd.PETDOC
                                                                              and d.PENDOC=pd.PENDOC
                                                                              ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                    )LOOP
                                                                              largo := length(ph.DOTELFP);
                                                                              largocel := 9;
                                                                              emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                              if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                  if countn=0 then
                                                                                    JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP then
                                                                                    JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP and JA_CELULAR2OUT <> ph.DOTELFP  then
                                                                                    JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  countn := countn + 1;
                                                                              end if;
                                                                     END LOOP;--FSR005
                                                                     
                                                                     FOR pi IN (
                                                                      SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                      into  email
                                                                      from FSX001 e
                                                                      where e.PEPAIS=pd.PEPAIS
                                                                      and e.PETDOC=pd.PETDOC
                                                                      and e.PENDOC=pd.PENDOC
                                                                      and e.TXCOD=0
                                                                      and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                      and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                            (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                       FROM JAQN454)
                                                                            )
                                                                      ORDER BY PEXREN DESC
                                                                      )LOOP
                                                                              if counte<3 then
                                                                                  if counte=0 then
                                                                                    JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=1 then
                                                                                    JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=2 then
                                                                                    JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  counte := counte + 1;
                                                                              end if; 
                                                                      END LOOP;--FSX001
                                                                      
                                                                      
                                                                      
                                                                      FOR pj IN (
                                                                              SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                              into  
                                                                              SNGC13ppais,
                                                                              SNGC13petdoc,
                                                                              SNGC13pendoc,
                                                                              sDocod,
                                                                                    ssngc13Dir,
                                                                                    ssngc13RDes
                                                                              from SNGC13 f
                                                                              where f.sngc13Pais=pd.PEPAIS
                                                                              and f.sngc13Tdoc=pd.PETDOC
                                                                              and f.sngc13Ndoc=pd.PENDOC
                                                                              and f.SNGC13EST='H'
                                                                              order by sngc13RDes asc 
                                                                      )LOOP
                                                                                JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                      END LOOP;--SNGC13
                                                                      --DBMS_OUTPUT.PUT_LINE ('JURIDICA: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                      INSERT INTO JAQN451 (
                                                                                      JAQN451COD,
                                                                                      JAQN451FGE,
                                                                                      JAQN451PAI,
                                                                                      JAQN451TDO,
                                                                                      JAQN451NDO,
                                                                                      JAQN451APE,
                                                                                      JAQN451CE1,
                                                                                      JAQN451CE2,
                                                                                      JAQN451CE3,
                                                                                      JAQN451CO1,
                                                                                      JAQN451CO2,
                                                                                      JAQN451CO3,
                                                                                      JAQN451DIR)
                                                                            VALUES (
                                                                                      JAQNCOD,
                                                                                      JAQNFGE,
                                                                                      JA_PAISOUT,
                                                                                      JA_TIPOOUT,
                                                                                      JA_NUMERODOUT,
                                                                                      JA_NOMBREOUT,
                                                                                      JA_CELULAR1OUT,
                                                                                      JA_CELULAR2OUT,
                                                                                      JA_CELULAR3OUT,
                                                                                      JA_MAILOUT,
                                                                                      JA_MAILOUT1,
                                                                                      JA_MAILOUT2,
                                                                                      JA_DIRECCIONOUT);
                                                                            commit;
                                                                            
                                                                           
                                                                          
                                                                            JA_MAILOUT :=null;   
                                                                            JA_MAILOUT1 :=null;   
                                                                            JA_MAILOUT2 :=null;  
                                                                            JA_CELULAR1OUT :=null;
                                                                            JA_CELULAR2OUT :=null;
                                                                            JA_CELULAR3OUT :=null;
                                                                END LOOP;--FSD002
                                                                
                                                                
                                                                
                                                                
                                                  WHEN TIPO_PERSONA = 'A' then
                                                                FOR pg IN (
                                                                    SELECT  k.PENOM
                                                                    into aPenom
                                                                    from fsd001 k
                                                                    where k.Pepais=pd.PEPAIS
                                                                    and k.Petdoc=pd.PETDOC
                                                                    and k.Pendoc=pd.PENDOC
                                                                    and k.Pendoc NOT IN (
                                                                            (SELECT JAQN451NDO
                                                                             FROM JAQN451
                                                                             WHERE JAQN451COD=JAQNCOD
                                                                             AND JAQN451FGE=JAQNFGE
                                                                              )
                                                                      )
                                                                    
                                                                )LOOP
                                                                      JA_PAISOUT := pd.PEPAIS;
                                                                      JA_TIPOOUT := pd.PETDOC;
                                                                      JA_NUMERODOUT := pd.PENDOC;
                                                                      JA_NOMBREOUT := pg.PENOM;
                                                                      countn:=0;
                                                                      counte:=0;
                                                                      FOR ph IN (
                                                                              SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                              into  ddotelfp,
                                                                                    ddocod,
                                                                                    ddoorp,
                                                                                    nueve
                                                                              from fsr005 d
                                                                              where d.PEPAIS=pd.PEPAIS
                                                                              and d.PETDOC=pd.PETDOC
                                                                              and d.PENDOC=pd.PENDOC
                                                                              ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                    )LOOP
                                                                              largo := length(ph.DOTELFP);
                                                                              largocel := 9;
                                                                              emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                              if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                  if countn=0 then
                                                                                    JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP  then
                                                                                    JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP and JA_CELULAR1OUT <> ph.DOTELFP  then
                                                                                    JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  countn := countn + 1;
                                                                              end if;
                                                                     END LOOP;--FSR005
                                                                     
                                                                     FOR pi IN (
                                                                      SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                      into  email
                                                                      from FSX001 e
                                                                      where e.PEPAIS=pd.PEPAIS
                                                                      and e.PETDOC=pd.PETDOC
                                                                      and e.PENDOC=pd.PENDOC
                                                                      and e.TXCOD=0
                                                                      and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                      and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                            (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                       FROM JAQN454)
                                                                            )
                                                                      ORDER BY PEXREN DESC
                                                                      )LOOP
                                                                              if counte<3 then
                                                                                  if counte=0 then
                                                                                    JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=1 then
                                                                                    JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=2 then
                                                                                    JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  counte := counte + 1;
                                                                              end if; 
                                                                      END LOOP;--FSX001
                                                                      
                                                                      
                                                                      
                                                                      FOR pj IN (
                                                                              SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                              into  
                                                                              SNGC13ppais,
                                                                              SNGC13petdoc,
                                                                              SNGC13pendoc,
                                                                              sDocod,
                                                                                    ssngc13Dir,
                                                                                    ssngc13RDes
                                                                              from SNGC13 f
                                                                              where f.sngc13Pais=pd.PEPAIS
                                                                              and f.sngc13Tdoc=pd.PETDOC
                                                                              and f.sngc13Ndoc=pd.PENDOC
                                                                              and f.SNGC13EST='H'
                                                                              order by sngc13RDes asc 
                                                                      )LOOP
                                                                                JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                      END LOOP;--SNGC13
                                                                      --DBMS_OUTPUT.PUT_LINE ('AMBAS: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                      INSERT INTO JAQN451 (
                                                                                      JAQN451COD,
                                                                                      JAQN451FGE,
                                                                                      JAQN451PAI,
                                                                                      JAQN451TDO,
                                                                                      JAQN451NDO,
                                                                                      JAQN451APE,
                                                                                      JAQN451CE1,
                                                                                      JAQN451CE2,
                                                                                      JAQN451CE3,
                                                                                      JAQN451CO1,
                                                                                      JAQN451CO2,
                                                                                      JAQN451CO3,
                                                                                      JAQN451DIR)
                                                                            VALUES (
                                                                                      JAQNCOD,
                                                                                      JAQNFGE,
                                                                                      JA_PAISOUT,
                                                                                      JA_TIPOOUT,
                                                                                      JA_NUMERODOUT,
                                                                                      JA_NOMBREOUT,
                                                                                      JA_CELULAR1OUT,
                                                                                      JA_CELULAR2OUT,
                                                                                      JA_CELULAR3OUT,
                                                                                      JA_MAILOUT,
                                                                                      JA_MAILOUT1,
                                                                                      JA_MAILOUT2,
                                                                                      JA_DIRECCIONOUT);
                                                                            commit;
                                                                            
                                                                          
                                                                            JA_MAILOUT :=null;   
                                                                            JA_MAILOUT1 :=null;   
                                                                            JA_MAILOUT2 :=null;  
                                                                            JA_CELULAR1OUT :=null;
                                                                            JA_CELULAR2OUT :=null;
                                                                            JA_CELULAR3OUT :=null;
                                                                END LOOP;--FSD002
                                                                
                                                            END CASE;
                                                    END LOOP;
                                            ---SIN ESTADO
                                        
                                          END CASE;
                                  
                                  END LOOP;
                              END LOOP;
                        END IF;--MONEDA
                      
                      
                      
                      IF JA_MONEDA ='A' THEN     
                      --DBMS_OUTPUT.PUT_LINE ('MONEDAAAAAAAAA AA:');
                                      FOR i IN 1..cant LOOP
                                        tope:=REGEXP_SUBSTR(modval, '[^;]+', 1,i );
                                        --DBMS_OUTPUT.PUT_LINE ('AMBAS MONEDAS  '||tope);
                                        FOR ad IN (
                                              SELECT a.PGCOD, a.SCCTA,a.SCSTAT,a.SCMOD,a.SCTOPE,a.SCMDA,a.SCSUC,a.SCPAP,a.SCOPER,a.SCSBOP,a.SCSDO 
                                                  into apgcod,
                                                       accta,
                                                       ascstat,
                                                       ascmod,
                                                       asctope,
                                                       ascmda,
                                                       ascsuc,
                                                       ascpap,
                                                       ascoper,
                                                       ascsbop,
                                                       ascsdo
                                                  from fsd011 a
                                                  where a.SCMOD =(CASE WHEN JA_MODULO='CA' THEN 21
                                                                       WHEN JA_MODULO='DP' THEN 22
                                                                       END)
                                                  and a.SCMDA  in (0,101) 
                                                  and a.SCFVAL >= JA_FECHA_APERTURA
                                                  and a.SCFVAL <= JA_FECHA_CIERRE
                                                  and a.SCCTA  >=  JA_CDESDE
                                                  and a.SCCTA  <=  JA_CHASTA
                                                  and a.SCTOPE = tope
                                                  --and ROWNUM <= 500
                                        )
                                        LOOP
                                            --DBMS_OUTPUT.PUT_LINE ('CUENTA: '|| ad.SCCTA ||'-'||ad.SCMDA);
                                            CASE 
                                                WHEN JA_ESTADO='A' then
                                                    IF ad.SCSTAT <>99 and ad.SCSTAT<>81 THEN
                                                          FOR pd IN (
                                                              SELECT b.PEPAIS,b.PETDOC, b.PENDOC 
                                                              into  appais,
                                                                    apetdoc,
                                                                    apendoc
                                                              from fsr008 b
                                                              where b.PGCOD=ad.PGCOD
                                                              and b.CTNRO=ad.SCCTA
                                                              and b.TTCOD='1')
                                                          LOOP
                                                          
                                                            INSERT INTO JAQN452 (
                                                                JAQN452COD,
                                                                JAQN452PAI,
                                                                JAQN452TDO,
                                                                JAQN452NDO,
                                                                JAQN452EMP,--EMPRESA
                                                                JAQN452MOD,--MODULO
                                                                JAQN452SUC,--SUCURSAL
                                                                JAQN452MDA,--MONEDA
                                                                JAQN452PAP,--PAPEL
                                                                JAQN452CTA,--CUENTA
                                                                JAQN452OPE,--OPERACION
                                                                JAQN452SBO,--SUB TIPO DE OPERACION
                                                                JAQN452TOP)--TIPO DE OPERACION
                                                        VALUES (  JAQNCOD,
                                                                    pd.PEPAIS,
                                                                    pd.PETDOC,
                                                                    pd.PENDOC,
                                                                    ad.PGCOD,--EMPRESA
                                                                    ad.SCMOD,--MODULO
                                                                    ad.SCSUC,--SUCURSAL
                                                                    ad.SCMDA,--MONEDA
                                                                    ad.SCPAP,--PAPEL
                                                                    ad.SCCTA,--CUENTA
                                                                    ad.SCOPER,--OPERACION
                                                                    ad.SCSBOP,--SUB TIPO DE OPERACION
                                                                    ad.SCTOPE
                                                                    );
                                                        commit;
                                                          
                                                              CASE  
                                                                  WHEN TIPO_PERSONA = 'N' then
                                                                  
                                                                      FOR pn IN (
                                                                      SELECT c.PFPAIS,c.PFTDOC, c.PFNDOC,c.PFAPE1,c.PFAPE2,c.PFNOM1,c.PFNOM2
                                                                      into  nppais,
                                                                            npetdoc,
                                                                            npendoc,
                                                                            nape1,
                                                                            nape2,
                                                                            nnom1,
                                                                            nnom2
                                                                      from fsd002 c
                                                                      where c.PFPAIS=pd.PEPAIS
                                                                      and c.PFTDOC=pd.PETDOC
                                                                      and c.PFNDOC=pd.PENDOC
                                                                      and c.PFNDOC NOT IN (
                                                                              (SELECT JAQN451NDO
                                                                               FROM JAQN451
                                                                               WHERE JAQN451COD=JAQNCOD
                                                                               AND JAQN451FGE=JAQNFGE
                                                                                )
                                                                              )
                                                                      )
                                                                    LOOP
                                                                        JA_PAISOUT := pd.PEPAIS;
                                                                        JA_TIPOOUT := pd.PETDOC;
                                                                        JA_NUMERODOUT := pd.PENDOC;
                                                                        JA_NOMBREOUT := TRIM(pn.PFAPE1)||' '||TRIM(pn.PFAPE2)||' '||TRIM(pn.PFNOM1)||' '||TRIM(pn.PFNOM2);
                                                                        countn:=0;
                                                                        counte:=0;
                                                                        
                                                                            FOR pc IN (
                                                                                  SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                                  into  ddotelfp,
                                                                                        ddocod,
                                                                                        ddoorp,
                                                                                        nueve
                                                                                  from fsr005 d
                                                                                  where d.PEPAIS=pd.PEPAIS
                                                                                  and d.PETDOC=pd.PETDOC
                                                                                  and d.PENDOC=pd.PENDOC
                                                                                  ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                            )LOOP
                                                                                      largo := length(pc.DOTELFP);
                                                                                      largocel := 9;
                                                                                      emp:=SUBSTR(pc.DOTELFP,1,1);
                                                                                      if largo = largocel and emp=9 and pc.CANT<>9 and countn<3 then
                                                                                        if countn=0 then
                                                                                          JA_CELULAR1OUT :=pc.DOTELFP;
                                                                                        end if;
                                                                                        if countn=1 and JA_CELULAR1OUT <> pc.DOTELFP then
                                                                                          JA_CELULAR2OUT :=pc.DOTELFP;
                                                                                        end if;
                                                                                        if countn=2 and JA_CELULAR1OUT <> pc.DOTELFP and JA_CELULAR2OUT <> pc.DOTELFP then
                                                                                          JA_CELULAR3OUT :=pc.DOTELFP;
                                                                                        end if;
                                                                                        countn := countn + 1;
                                                                                      end if;         
                                                                             END LOOP;
                                                                             
                                                                             FOR pe IN (
                                                                                  SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                                  into  email
                                                                                  from FSX001 e
                                                                                  where e.PEPAIS=pd.PEPAIS
                                                                                  and e.PETDOC=pd.PETDOC
                                                                                  and e.PENDOC=pd.PENDOC
                                                                                  and e.TXCOD=0
                                                                                  and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                                  and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                                    (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                       FROM JAQN454)
                                                                                    )
                                                                                  ORDER BY PEXREN DESC
                                                                              )LOOP
                                                                                    if counte<3 then
                                                                                        if counte=0 then
                                                                                          JA_MAILOUT :=regexp_substr(pe.PEXTXT,'[^\]*');   
                                                                                        end if;
                                                                                        if counte=1 then
                                                                                          JA_MAILOUT1 :=regexp_substr(pe.PEXTXT,'[^\]*');   
                                                                                        end if;
                                                                                        if counte=2 then
                                                                                          JA_MAILOUT2 :=regexp_substr(pe.PEXTXT,'[^\]*');   
                                                                                        end if;
                                                                                        counte := counte + 1;
                                                                                    end if; 
                
                                                                              END LOOP;
                                                                             
                                                                             FOR ps IN (
                                                                                      SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                      into  
                                                                                      SNGC13ppais,
                                                                                      SNGC13petdoc,
                                                                                      SNGC13pendoc,
                                                                                      sDocod,
                                                                                            ssngc13Dir,
                                                                                            ssngc13RDes
                                                                                      from SNGC13 f
                                                                                      where f.sngc13Pais=pd.PEPAIS
                                                                                      and f.sngc13Tdoc=pd.PETDOC
                                                                                      and f.sngc13Ndoc=pd.PENDOC
                                                                                      and f.SNGC13EST='H'
                                                                                      order by sngc13RDes asc 
                                                                              )LOOP
                                                                                    JA_DIRECCIONOUT := ps.sngc13Dir;
                                                                              END LOOP;
                                                                              
                                                                              --DBMS_OUTPUT.PUT_LINE ('CUENTA: '|| ad.SCCTA );
                                                                              --DBMS_OUTPUT.PUT_LINE ('NATURAL:'||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'||JA_MAILOUT1||'-'||JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                              INSERT INTO JAQN451 (
                                                                                            JAQN451COD,
                                                                                            JAQN451FGE,
                                                                                            JAQN451PAI,
                                                                                            JAQN451TDO,
                                                                                            JAQN451NDO,
                                                                                            JAQN451APE,
                                                                                            JAQN451CE1,
                                                                                            JAQN451CE2,
                                                                                            JAQN451CE3,
                                                                                            JAQN451CO1,
                                                                                            JAQN451CO2,
                                                                                            JAQN451CO3,
                                                                                            JAQN451DIR)
                                                                                  VALUES (
                                                                                            JAQNCOD,
                                                                                            JAQNFGE,
                                                                                            JA_PAISOUT,
                                                                                            JA_TIPOOUT,
                                                                                            JA_NUMERODOUT,
                                                                                            JA_NOMBREOUT,
                                                                                            JA_CELULAR1OUT,
                                                                                            JA_CELULAR2OUT,
                                                                                            JA_CELULAR3OUT,
                                                                                            JA_MAILOUT,
                                                                                            JA_MAILOUT1,
                                                                                            JA_MAILOUT2,
                                                                                            JA_DIRECCIONOUT);
                                                                                  commit;
                                                                                  
                                                                                 
                                                                          
                                                                                  JA_MAILOUT :=null;   
                                                                                  JA_MAILOUT1 :=null;   
                                                                                  JA_MAILOUT2 :=null;  
                                                                                  JA_CELULAR1OUT :=null;
                                                                                  JA_CELULAR2OUT :=null;
                                                                                  JA_CELULAR3OUT :=null;
                                                                                --DBMS_OUTPUT.PUT_LINE ('ESTADO A: '||ad.SCSTAT ||'-'||ad.PGCOD||'-' ||ad.SCCTA||'-' ||ad.SCMOD||'-' ||ad.SCTOPE||'-' ||pd.PEPAIS||'-' ||pd.PETDOC||'-' ||pd.PENDOC);
                                                         
                                                                    END LOOP;--FSD001
                                                                  
                                                        WHEN TIPO_PERSONA = 'J' then
                                                                      FOR pg IN (
                                                                          SELECT g.PJRAZS
                                                                          into gPjrazs
                                                                          from fsd003 g
                                                                          where g.Pjpais=pd.PEPAIS
                                                                          and g.Pjtdoc=pd.PETDOC
                                                                          and g.Pjndoc=pd.PENDOC
                                                                          and g.Pjndoc NOT IN (
                                                                              (SELECT JAQN451NDO
                                                                               FROM JAQN451
                                                                               WHERE JAQN451COD=JAQNCOD
                                                                               AND JAQN451FGE=JAQNFGE
                                                                                )
                                                                              )
                                                                      )LOOP
                                                                            JA_PAISOUT := pd.PEPAIS;
                                                                            JA_TIPOOUT := pd.PETDOC;
                                                                            JA_NUMERODOUT := pd.PENDOC;
                                                                            JA_NOMBREOUT := pg.PJRAZS;
                                                                            countn:=0;
                                                                            counte:=0;
                                                                            FOR ph IN (
                                                                                    SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                                    into  ddotelfp,
                                                                                          ddocod,
                                                                                          ddoorp,
                                                                                          nueve
                                                                                    from fsr005 d
                                                                                    where d.PEPAIS=pd.PEPAIS
                                                                                    and d.PETDOC=pd.PETDOC
                                                                                    and d.PENDOC=pd.PENDOC
                                                                                    ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                          )LOOP
                                                                                    largo := length(ph.DOTELFP);
                                                                                    largocel := 9;
                                                                                    emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                                    if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                        if countn=0 then
                                                                                          JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                        end if;
                                                                                        if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP then
                                                                                          JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                        end if;
                                                                                        if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP and JA_CELULAR1OUT <> ph.DOTELFP then
                                                                                          JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                        end if;
                                                                                        countn := countn + 1;
                                                                                    end if;
                                                                           END LOOP;--FSR005
                                                                           
                                                                           FOR pi IN (
                                                                            SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                            into  email
                                                                            from FSX001 e
                                                                            where e.PEPAIS=pd.PEPAIS
                                                                            and e.PETDOC=pd.PETDOC
                                                                            and e.PENDOC=pd.PENDOC
                                                                            and e.TXCOD=0
                                                                            and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                            and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                                    (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                       FROM JAQN454)
                                                                                    )
                                                                            ORDER BY PEXREN DESC
                                                                            )LOOP
                                                                                    if counte<3 then
                                                                                        if counte=0 then
                                                                                          JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                        end if;
                                                                                        if counte=1 then
                                                                                          JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                        end if;
                                                                                        if counte=2 then
                                                                                          JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                        end if;
                                                                                        counte := counte + 1;
                                                                                    end if; 
                                                                            END LOOP;--FSX001
                                                                            
                                                                            
                                                                            
                                                                            FOR pj IN (
                                                                                    SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                    into  
                                                                                    SNGC13ppais,
                                                                                    SNGC13petdoc,
                                                                                    SNGC13pendoc,
                                                                                    sDocod,
                                                                                          ssngc13Dir,
                                                                                          ssngc13RDes
                                                                                    from SNGC13 f
                                                                                    where f.sngc13Pais=pd.PEPAIS
                                                                                    and f.sngc13Tdoc=pd.PETDOC
                                                                                    and f.sngc13Ndoc=pd.PENDOC
                                                                                    and f.SNGC13EST='H'
                                                                                    order by sngc13RDes asc 
                                                                            )LOOP
                                                                                      JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                            END LOOP;--SNGC13
                                                                            --DBMS_OUTPUT.PUT_LINE ('JURIDICA: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                            INSERT INTO JAQN451 (
                                                                                            JAQN451COD,
                                                                                            JAQN451FGE,
                                                                                            JAQN451PAI,
                                                                                            JAQN451TDO,
                                                                                            JAQN451NDO,
                                                                                            JAQN451APE,
                                                                                            JAQN451CE1,
                                                                                            JAQN451CE2,
                                                                                            JAQN451CE3,
                                                                                            JAQN451CO1,
                                                                                            JAQN451CO2,
                                                                                            JAQN451CO3,
                                                                                            JAQN451DIR)
                                                                                  VALUES (
                                                                                            JAQNCOD,
                                                                                            JAQNFGE,
                                                                                            JA_PAISOUT,
                                                                                            JA_TIPOOUT,
                                                                                            JA_NUMERODOUT,
                                                                                            JA_NOMBREOUT,
                                                                                            JA_CELULAR1OUT,
                                                                                            JA_CELULAR2OUT,
                                                                                            JA_CELULAR3OUT,
                                                                                            JA_MAILOUT,
                                                                                            JA_MAILOUT1,
                                                                                            JA_MAILOUT2,
                                                                                            JA_DIRECCIONOUT);
                                                                                  commit;
                                                                                  
                                                                                  JA_MAILOUT :=null;   
                                                                                  JA_MAILOUT1 :=null;   
                                                                                  JA_MAILOUT2 :=null;  
                                                                                  JA_CELULAR1OUT :=null;
                                                                                  JA_CELULAR2OUT :=null;
                                                                                  JA_CELULAR3OUT :=null;
                                                                      END LOOP;--FSD002
                                                                      
                                                                      
                                                                      
                                                                      
                                                        WHEN TIPO_PERSONA = 'A' then
                                                                      FOR pg IN (
                                                                          SELECT k.PENOM
                                                                          into aPenom
                                                                          from fsd001 k
                                                                          where k.Pepais=pd.PEPAIS
                                                                          and k.Petdoc=pd.PETDOC
                                                                          and k.Pendoc=pd.PENDOC
                                                                          and k.Pendoc NOT IN (
                                                                              (SELECT JAQN451NDO
                                                                               FROM JAQN451
                                                                               WHERE JAQN451COD=JAQNCOD
                                                                               AND JAQN451FGE=JAQNFGE
                                                                                )
                                                                              )
                                                                      )LOOP
                                                                            JA_PAISOUT := pd.PEPAIS;
                                                                            JA_TIPOOUT := pd.PETDOC;
                                                                            JA_NUMERODOUT := pd.PENDOC;
                                                                            JA_NOMBREOUT := pg.PENOM;
                                                                            countn:=0;
                                                                            counte:=0;
                                                                            FOR ph IN (
                                                                                    SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                                    into  ddotelfp,
                                                                                          ddocod,
                                                                                          ddoorp,
                                                                                          nueve
                                                                                    from fsr005 d
                                                                                    where d.PEPAIS=pd.PEPAIS
                                                                                    and d.PETDOC=pd.PETDOC
                                                                                    and d.PENDOC=pd.PENDOC
                                                                                    ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                          )LOOP
                                                                                    largo := length(ph.DOTELFP);
                                                                                    largocel := 9;
                                                                                    emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                                    if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                        if countn=0 then
                                                                                          JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                        end if;
                                                                                        if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP then
                                                                                          JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                        end if;
                                                                                        if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                          JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                        end if;
                                                                                        countn := countn + 1;
                                                                                    end if;
                                                                           END LOOP;--FSR005
                                                                           
                                                                           FOR pi IN (
                                                                            SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                            into  email
                                                                            from FSX001 e
                                                                            where e.PEPAIS=pd.PEPAIS
                                                                            and e.PETDOC=pd.PETDOC
                                                                            and e.PENDOC=pd.PENDOC
                                                                            and e.TXCOD=0
                                                                            and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                            and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                                    (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                       FROM JAQN454)
                                                                                    )
                                                                            ORDER BY PEXREN DESC
                                                                            )LOOP
                                                                                    if counte<3 then
                                                                                        if counte=0 then
                                                                                          JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                        end if;
                                                                                        if counte=1 then
                                                                                          JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                        end if;
                                                                                        if counte=2 then
                                                                                          JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                        end if;
                                                                                        counte := counte + 1;
                                                                                    end if; 
                                                                            END LOOP;--FSX001
                                                                            
                                                                            
                                                                            
                                                                            FOR pj IN (
                                                                                    SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                    into  
                                                                                    SNGC13ppais,
                                                                                    SNGC13petdoc,
                                                                                    SNGC13pendoc,
                                                                                    sDocod,
                                                                                          ssngc13Dir,
                                                                                          ssngc13RDes
                                                                                    from SNGC13 f
                                                                                    where f.sngc13Pais=pd.PEPAIS
                                                                                    and f.sngc13Tdoc=pd.PETDOC
                                                                                    and f.sngc13Ndoc=pd.PENDOC
                                                                                    and f.SNGC13EST='H'
                                                                                    order by sngc13RDes asc 
                                                                            )LOOP
                                                                                      JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                            END LOOP;--SNGC13
                                                                            --DBMS_OUTPUT.PUT_LINE ('AMBAS: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                            INSERT INTO JAQN451 (
                                                                                            JAQN451COD,
                                                                                            JAQN451FGE,
                                                                                            JAQN451PAI,
                                                                                            JAQN451TDO,
                                                                                            JAQN451NDO,
                                                                                            JAQN451APE,
                                                                                            JAQN451CE1,
                                                                                            JAQN451CE2,
                                                                                            JAQN451CE3,
                                                                                            JAQN451CO1,
                                                                                            JAQN451CO2,
                                                                                            JAQN451CO3,
                                                                                            JAQN451DIR)
                                                                                  VALUES (
                                                                                            JAQNCOD,
                                                                                            JAQNFGE,
                                                                                            JA_PAISOUT,
                                                                                            JA_TIPOOUT,
                                                                                            JA_NUMERODOUT,
                                                                                            JA_NOMBREOUT,
                                                                                            JA_CELULAR1OUT,
                                                                                            JA_CELULAR2OUT,
                                                                                            JA_CELULAR3OUT,
                                                                                            JA_MAILOUT,
                                                                                            JA_MAILOUT1,
                                                                                            JA_MAILOUT2,
                                                                                            JA_DIRECCIONOUT);
                                                                                  commit;
                                                                                 
                                                                                  JA_MAILOUT :=null;   
                                                                                  JA_MAILOUT1 :=null;   
                                                                                  JA_MAILOUT2 :=null;  
                                                                                  JA_CELULAR1OUT :=null;
                                                                                  JA_CELULAR2OUT :=null;
                                                                                  JA_CELULAR3OUT :=null;
                                                                      END LOOP;--FSD002
                                                                  
                                                                  END CASE;
                                                          END LOOP;
                
                                                    END IF;
                                                    
                                                    
                                                WHEN JA_ESTADO='I' then
                                                    IF ad.SCSTAT =81 THEN
                                                      --DBMS_OUTPUT.PUT_LINE ('ESTADO I: '||ad.SCSTAT ||'-'||ad.PGCOD||'-' ||ad.SCCTA||'-' ||ad.SCMOD||'-' ||ad.SCTOPE);
                                                             
                                                                    FOR pd IN (
                                                                        SELECT b.PEPAIS,b.PETDOC, b.PENDOC 
                                                                        into  appais,
                                                                              apetdoc,
                                                                              apendoc
                                                                        from fsr008 b
                                                                        where b.PGCOD=ad.PGCOD
                                                                        and b.CTNRO=ad.SCCTA
                                                                        and b.TTCOD='1')
                                                                    LOOP
                                                                    
                                                                      INSERT INTO JAQN452 (
                                                                                  JAQN452COD,
                                                                                  JAQN452PAI,
                                                                                  JAQN452TDO,
                                                                                  JAQN452NDO,
                                                                                  JAQN452EMP,--EMPRESA
                                                                                  JAQN452MOD,--MODULO
                                                                                  JAQN452SUC,--SUCURSAL
                                                                                  JAQN452MDA,--MONEDA
                                                                                  JAQN452PAP,--PAPEL
                                                                                  JAQN452CTA,--CUENTA
                                                                                  JAQN452OPE,--OPERACION
                                                                                  JAQN452SBO,--SUB TIPO DE OPERACION
                                                                                  JAQN452TOP)--TIPO DE OPERACION
                                                                      VALUES (  JAQNCOD,
                                                                                  pd.PEPAIS,
                                                                                  pd.PETDOC,
                                                                                  pd.PENDOC,
                                                                                  ad.PGCOD,--EMPRESA
                                                                                  ad.SCMOD,--MODULO
                                                                                  ad.SCSUC,--SUCURSAL
                                                                                  ad.SCMDA,--MONEDA
                                                                                  ad.SCPAP,--PAPEL
                                                                                  ad.SCCTA,--CUENTA
                                                                                  ad.SCOPER,--OPERACION
                                                                                  ad.SCSBOP,--SUB TIPO DE OPERACION
                                                                                  ad.SCTOPE
                                                                                  );
                                                                      commit;
                                                                    
                                                                    
                                                                    
                                                                        CASE  
                                                                            WHEN TIPO_PERSONA = 'N' then
                                                                            
                                                                                FOR pn IN (
                                                                                SELECT c.PFPAIS,c.PFTDOC, c.PFNDOC,c.PFAPE1,c.PFAPE2,c.PFNOM1,c.PFNOM2
                                                                                into  nppais,
                                                                                      npetdoc,
                                                                                      npendoc,
                                                                                      nape1,
                                                                                      nape2,
                                                                                      nnom1,
                                                                                      nnom2
                                                                                from fsd002 c
                                                                                where c.PFPAIS=pd.PEPAIS
                                                                                and c.PFTDOC=pd.PETDOC
                                                                                and c.PFNDOC=pd.PENDOC
                                                                                 and c.PFNDOC NOT IN (
                                                                                  (SELECT JAQN451NDO
                                                                                   FROM JAQN451
                                                                                   WHERE JAQN451COD=JAQNCOD
                                                                                   AND JAQN451FGE=JAQNFGE
                                                                                    )
                                                                                  )
                                                                                )
                                                                              LOOP
                                                                                  JA_PAISOUT := pd.PEPAIS;
                                                                                  JA_TIPOOUT := pd.PETDOC;
                                                                                  JA_NUMERODOUT := pd.PENDOC;
                                                                                  JA_NOMBREOUT := TRIM(pn.PFAPE1)||' '||TRIM(pn.PFAPE2)||' '||TRIM(pn.PFNOM1)||' '||TRIM(pn.PFNOM2);
                                                                                  countn:=0;
                                                                                  counte:=0;
                                                                                  
                                                                                      FOR pc IN (
                                                                                            SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                                            into  ddotelfp,
                                                                                                  ddocod,
                                                                                                  ddoorp,
                                                                                                  nueve
                                                                                            from fsr005 d
                                                                                            where d.PEPAIS=pd.PEPAIS
                                                                                            and d.PETDOC=pd.PETDOC
                                                                                            and d.PENDOC=pd.PENDOC
                                                                                            ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                                      )LOOP
                                                                                                largo := length(pc.DOTELFP);
                                                                                                largocel := 9;
                                                                                                emp:=SUBSTR(pc.DOTELFP,1,1);
                                                                                                if largo = largocel and emp=9 and pc.CANT<>9 and countn<3 then
                                                                                                  if countn=0 then
                                                                                                    JA_CELULAR1OUT :=pc.DOTELFP;
                                                                                                  end if;
                                                                                                  if countn=1 and JA_CELULAR1OUT <> pc.DOTELFP then
                                                                                                    JA_CELULAR2OUT :=pc.DOTELFP;
                                                                                                  end if;
                                                                                                  if countn=2 and JA_CELULAR1OUT <> pc.DOTELFP and JA_CELULAR2OUT <> pc.DOTELFP then
                                                                                                    JA_CELULAR3OUT :=pc.DOTELFP;
                                                                                                  end if;
                                                                                                  countn := countn + 1;
                                                                                                end if;         
                                                                                       END LOOP;
                                                                                       
                                                                                       FOR pe IN (
                                                                                            SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                                            into  email
                                                                                            from FSX001 e
                                                                                            where e.PEPAIS=pd.PEPAIS
                                                                                            and e.PETDOC=pd.PETDOC
                                                                                            and e.PENDOC=pd.PENDOC
                                                                                            and e.TXCOD=0
                                                                                            and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                                            and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                                            (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                               FROM JAQN454)
                                                                                            )
                                                                                            ORDER BY PEXREN DESC
                                                                                        )LOOP
                                                                                              if counte<3 then
                                                                                                  if counte=0 then
                                                                                                    JA_MAILOUT :=regexp_substr(pe.PEXTXT,'[^\]*');   
                                                                                                  end if;
                                                                                                  if counte=1 then
                                                                                                    JA_MAILOUT1 :=regexp_substr(pe.PEXTXT,'[^\]*');   
                                                                                                  end if;
                                                                                                  if counte=2 then
                                                                                                    JA_MAILOUT2 :=regexp_substr(pe.PEXTXT,'[^\]*');   
                                                                                                  end if;
                                                                                                  counte := counte + 1;
                                                                                              end if; 
                          
                                                                                        END LOOP;
                                                                                       
                                                                                       FOR ps IN (
                                                                                                SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                                into  
                                                                                                SNGC13ppais,
                                                                                                SNGC13petdoc,
                                                                                                SNGC13pendoc,
                                                                                                sDocod,
                                                                                                      ssngc13Dir,
                                                                                                      ssngc13RDes
                                                                                                from SNGC13 f
                                                                                                where f.sngc13Pais=pd.PEPAIS
                                                                                                and f.sngc13Tdoc=pd.PETDOC
                                                                                                and f.sngc13Ndoc=pd.PENDOC
                                                                                                and f.SNGC13EST='H'
                                                                                                order by sngc13RDes asc 
                                                                                        )LOOP
                                                                                              JA_DIRECCIONOUT := ps.sngc13Dir;
                                                                                        END LOOP;
                                                                                        
                                                                                        --DBMS_OUTPUT.PUT_LINE ('CUENTA: '|| ad.SCCTA );
                                                                                        --DBMS_OUTPUT.PUT_LINE ('NATURAL:'||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'||JA_MAILOUT1||'-'||JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                                        INSERT INTO JAQN451 (
                                                                                                      JAQN451COD,
                                                                                                      JAQN451FGE,
                                                                                                      JAQN451PAI,
                                                                                                      JAQN451TDO,
                                                                                                      JAQN451NDO,
                                                                                                      JAQN451APE,
                                                                                                      JAQN451CE1,
                                                                                                      JAQN451CE2,
                                                                                                      JAQN451CE3,
                                                                                                      JAQN451CO1,
                                                                                                      JAQN451CO2,
                                                                                                      JAQN451CO3,
                                                                                                      JAQN451DIR)
                                                                                            VALUES (
                                                                                                      JAQNCOD,
                                                                                                      JAQNFGE,
                                                                                                      JA_PAISOUT,
                                                                                                      JA_TIPOOUT,
                                                                                                      JA_NUMERODOUT,
                                                                                                      JA_NOMBREOUT,
                                                                                                      JA_CELULAR1OUT,
                                                                                                      JA_CELULAR2OUT,
                                                                                                      JA_CELULAR3OUT,
                                                                                                      JA_MAILOUT,
                                                                                                      JA_MAILOUT1,
                                                                                                      JA_MAILOUT2,
                                                                                                      JA_DIRECCIONOUT);
                                                                                            commit;
                                                                                            
                                                                                            
                                                                                            JA_MAILOUT :=null;   
                                                                                            JA_MAILOUT1 :=null;   
                                                                                            JA_MAILOUT2 :=null;  
                                                                                            JA_CELULAR1OUT :=null;
                                                                                            JA_CELULAR2OUT :=null;
                                                                                            JA_CELULAR3OUT :=null;
                                                                                          --DBMS_OUTPUT.PUT_LINE ('ESTADO A: '||ad.SCSTAT ||'-'||ad.PGCOD||'-' ||ad.SCCTA||'-' ||ad.SCMOD||'-' ||ad.SCTOPE||'-' ||pd.PEPAIS||'-' ||pd.PETDOC||'-' ||pd.PENDOC);
                                                                   
                                                                              END LOOP;--FSD001
                                                                            
                                                                  WHEN TIPO_PERSONA = 'J' then
                                                                                FOR pg IN (
                                                                                    SELECT g.PJRAZS
                                                                                    into gPjrazs
                                                                                    from fsd003 g
                                                                                    where g.Pjpais=pd.PEPAIS
                                                                                    and g.Pjtdoc=pd.PETDOC
                                                                                    and g.Pjndoc=pd.PENDOC
                                                                                    and g.Pjndoc NOT IN (
                                                                                    (SELECT JAQN451NDO
                                                                                     FROM JAQN451
                                                                                     WHERE JAQN451COD=JAQNCOD
                                                                                     AND JAQN451FGE=JAQNFGE
                                                                                      )
                                                                                    )
                                                                                )LOOP
                                                                                      JA_PAISOUT := pd.PEPAIS;
                                                                                      JA_TIPOOUT := pd.PETDOC;
                                                                                      JA_NUMERODOUT := pd.PENDOC;
                                                                                      JA_NOMBREOUT := pg.PJRAZS;
                                                                                      countn:=0;
                                                                                      counte:=0;
                                                                                      FOR ph IN (
                                                                                              SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                                              into  ddotelfp,
                                                                                                    ddocod,
                                                                                                    ddoorp,
                                                                                                    nueve
                                                                                              from fsr005 d
                                                                                              where d.PEPAIS=pd.PEPAIS
                                                                                              and d.PETDOC=pd.PETDOC
                                                                                              and d.PENDOC=pd.PENDOC
                                                                                              ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                                    )LOOP
                                                                                              largo := length(ph.DOTELFP);
                                                                                              largocel := 9;
                                                                                              emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                                              if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                                  if countn=0 then
                                                                                                    JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                                  end if;
                                                                                                  if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP  then
                                                                                                    JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                                  end if;
                                                                                                  if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                                    JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                                  end if;
                                                                                                  countn := countn + 1;
                                                                                              end if;
                                                                                     END LOOP;--FSR005
                                                                                     
                                                                                     FOR pi IN (
                                                                                      SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                                      into  email
                                                                                      from FSX001 e
                                                                                      where e.PEPAIS=pd.PEPAIS
                                                                                      and e.PETDOC=pd.PETDOC
                                                                                      and e.PENDOC=pd.PENDOC
                                                                                      and e.TXCOD=0
                                                                                      and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                                      and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                                        (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                               FROM JAQN454)
                                                                                            )
                                                                                      ORDER BY PEXREN DESC
                                                                                      )LOOP
                                                                                              if counte<3 then
                                                                                                  if counte=0 then
                                                                                                    JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                                  end if;
                                                                                                  if counte=1 then
                                                                                                    JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                                  end if;
                                                                                                  if counte=2 then
                                                                                                    JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                                  end if;
                                                                                                  counte := counte + 1;
                                                                                              end if; 
                                                                                      END LOOP;--FSX001
                                                                                      
                                                                                      
                                                                                      
                                                                                      FOR pj IN (
                                                                                              SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                              into  
                                                                                              SNGC13ppais,
                                                                                              SNGC13petdoc,
                                                                                              SNGC13pendoc,
                                                                                              sDocod,
                                                                                                    ssngc13Dir,
                                                                                                    ssngc13RDes
                                                                                              from SNGC13 f
                                                                                              where f.sngc13Pais=pd.PEPAIS
                                                                                              and f.sngc13Tdoc=pd.PETDOC
                                                                                              and f.sngc13Ndoc=pd.PENDOC
                                                                                              and f.SNGC13EST='H'
                                                                                              order by sngc13RDes asc 
                                                                                      )LOOP
                                                                                                JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                                      END LOOP;--SNGC13
                                                                                      --DBMS_OUTPUT.PUT_LINE ('JURIDICA: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                                      INSERT INTO JAQN451 (
                                                                                                      JAQN451COD,
                                                                                                      JAQN451FGE,
                                                                                                      JAQN451PAI,
                                                                                                      JAQN451TDO,
                                                                                                      JAQN451NDO,
                                                                                                      JAQN451APE,
                                                                                                      JAQN451CE1,
                                                                                                      JAQN451CE2,
                                                                                                      JAQN451CE3,
                                                                                                      JAQN451CO1,
                                                                                                      JAQN451CO2,
                                                                                                      JAQN451CO3,
                                                                                                      JAQN451DIR)
                                                                                            VALUES (
                                                                                                      JAQNCOD,
                                                                                                      JAQNFGE,
                                                                                                      JA_PAISOUT,
                                                                                                      JA_TIPOOUT,
                                                                                                      JA_NUMERODOUT,
                                                                                                      JA_NOMBREOUT,
                                                                                                      JA_CELULAR1OUT,
                                                                                                      JA_CELULAR2OUT,
                                                                                                      JA_CELULAR3OUT,
                                                                                                      JA_MAILOUT,
                                                                                                      JA_MAILOUT1,
                                                                                                      JA_MAILOUT2,
                                                                                                      JA_DIRECCIONOUT);
                                                                                            commit;
                                                                                            
                                                                                            
                                                                                            JA_MAILOUT :=null;   
                                                                                            JA_MAILOUT1 :=null;   
                                                                                            JA_MAILOUT2 :=null;  
                                                                                            JA_CELULAR1OUT :=null;
                                                                                            JA_CELULAR2OUT :=null;
                                                                                            JA_CELULAR3OUT :=null;
                                                                                END LOOP;--FSD002
                                                                                
                                                                                
                                                                                
                                                                                
                                                                  WHEN TIPO_PERSONA = 'A' then
                                                                                FOR pg IN (
                                                                                    SELECT k.PENOM
                                                                                    into aPenom
                                                                                    from fsd001 k
                                                                                    where k.Pepais=pd.PEPAIS
                                                                                    and k.Petdoc=pd.PETDOC
                                                                                    and k.Pendoc=pd.PENDOC
                                                                                    and k.Pendoc NOT IN (
                                                                                    (SELECT JAQN451NDO
                                                                                     FROM JAQN451
                                                                                     WHERE JAQN451COD=JAQNCOD
                                                                                     AND JAQN451FGE=JAQNFGE
                                                                                      )
                                                                                    )
                                                                                )LOOP
                                                                                      JA_PAISOUT := pd.PEPAIS;
                                                                                      JA_TIPOOUT := pd.PETDOC;
                                                                                      JA_NUMERODOUT := pd.PENDOC;
                                                                                      JA_NOMBREOUT := pg.PENOM;
                                                                                      countn:=0;
                                                                                      counte:=0;
                                                                                      FOR ph IN (
                                                                                              SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                                              into  ddotelfp,
                                                                                                    ddocod,
                                                                                                    ddoorp,
                                                                                                    nueve
                                                                                              from fsr005 d
                                                                                              where d.PEPAIS=pd.PEPAIS
                                                                                              and d.PETDOC=pd.PETDOC
                                                                                              and d.PENDOC=pd.PENDOC
                                                                                              ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                                    )LOOP
                                                                                              largo := length(ph.DOTELFP);
                                                                                              largocel := 9;
                                                                                              emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                                              if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                                  if countn=0 then
                                                                                                    JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                                  end if;
                                                                                                  if countn=1  and JA_CELULAR1OUT <> ph.DOTELFP  then
                                                                                                    JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                                  end if;
                                                                                                  if countn=2  and JA_CELULAR1OUT <> ph.DOTELFP   and JA_CELULAR2OUT <> ph.DOTELFP  then
                                                                                                    JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                                  end if;
                                                                                                  countn := countn + 1;
                                                                                              end if;
                                                                                     END LOOP;--FSR005
                                                                                     
                                                                                     FOR pi IN (
                                                                                      SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                                      into  email
                                                                                      from FSX001 e
                                                                                      where e.PEPAIS=pd.PEPAIS
                                                                                      and e.PETDOC=pd.PETDOC
                                                                                      and e.PENDOC=pd.PENDOC
                                                                                      and e.TXCOD=0
                                                                                      and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                                      and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                                      (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                               FROM JAQN454)
                                                                                            )
                                                                                      ORDER BY PEXREN DESC
                                                                                      )LOOP
                                                                                              if counte<3 then
                                                                                                  if counte=0 then
                                                                                                    JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                                  end if;
                                                                                                  if counte=1 then
                                                                                                    JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                                  end if;
                                                                                                  if counte=2 then
                                                                                                    JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                                  end if;
                                                                                                  counte := counte + 1;
                                                                                              end if; 
                                                                                      END LOOP;--FSX001
                                                                                      
                                                                                      
                                                                                      
                                                                                      FOR pj IN (
                                                                                              SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                              into  
                                                                                              SNGC13ppais,
                                                                                              SNGC13petdoc,
                                                                                              SNGC13pendoc,
                                                                                              sDocod,
                                                                                                    ssngc13Dir,
                                                                                                    ssngc13RDes
                                                                                              from SNGC13 f
                                                                                              where f.sngc13Pais=pd.PEPAIS
                                                                                              and f.sngc13Tdoc=pd.PETDOC
                                                                                              and f.sngc13Ndoc=pd.PENDOC
                                                                                              and f.SNGC13EST='H'
                                                                                              order by sngc13RDes asc 
                                                                                      )LOOP
                                                                                                JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                                      END LOOP;--SNGC13
                                                                                      --DBMS_OUTPUT.PUT_LINE ('AMBAS: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                                      INSERT INTO JAQN451 (
                                                                                                      JAQN451COD,
                                                                                                      JAQN451FGE,
                                                                                                      JAQN451PAI,
                                                                                                      JAQN451TDO,
                                                                                                      JAQN451NDO,
                                                                                                      JAQN451APE,
                                                                                                      JAQN451CE1,
                                                                                                      JAQN451CE2,
                                                                                                      JAQN451CE3,
                                                                                                      JAQN451CO1,
                                                                                                      JAQN451CO2,
                                                                                                      JAQN451CO3,
                                                                                                      JAQN451DIR)
                                                                                            VALUES (
                                                                                                      JAQNCOD,
                                                                                                      JAQNFGE,
                                                                                                      JA_PAISOUT,
                                                                                                      JA_TIPOOUT,
                                                                                                      JA_NUMERODOUT,
                                                                                                      JA_NOMBREOUT,
                                                                                                      JA_CELULAR1OUT,
                                                                                                      JA_CELULAR2OUT,
                                                                                                      JA_CELULAR3OUT,
                                                                                                      JA_MAILOUT,
                                                                                                      JA_MAILOUT1,
                                                                                                      JA_MAILOUT2,
                                                                                                      JA_DIRECCIONOUT);
                                                                                            commit;
                                                                                            
                                                                                            JA_MAILOUT :=null;   
                                                                                            JA_MAILOUT1 :=null;   
                                                                                            JA_MAILOUT2 :=null;  
                                                                                            JA_CELULAR1OUT :=null;
                                                                                            JA_CELULAR2OUT :=null;
                                                                                            JA_CELULAR3OUT :=null;
                                                                                END LOOP;--FSD002
                                                                                
                                                                                
                                                                                
                                                                            
                                                                            
                                                                            
                                                                            
                                                                            END CASE;
                                                                    END LOOP;
                                                          
                                                    END IF; --ESTADO I
                                                    
                                                WHEN JA_ESTADO='T' then
                                                   
                                                    FOR pd IN (
                                                        SELECT b.PEPAIS,b.PETDOC, b.PENDOC 
                                                        into  appais,
                                                              apetdoc,
                                                              apendoc
                                                        from fsr008 b
                                                        where b.PGCOD=ad.PGCOD
                                                        and b.CTNRO=ad.SCCTA
                                                        and b.TTCOD='1')
                                                    LOOP
                                                      INSERT INTO JAQN452 (
                                                                JAQN452COD,
                                                                JAQN452PAI,
                                                                JAQN452TDO,
                                                                JAQN452NDO,
                                                                JAQN452EMP,--EMPRESA
                                                                JAQN452MOD,--MODULO
                                                                JAQN452SUC,--SUCURSAL
                                                                JAQN452MDA,--MONEDA
                                                                JAQN452PAP,--PAPEL
                                                                JAQN452CTA,--CUENTA
                                                                JAQN452OPE,--OPERACION
                                                                JAQN452SBO,--SUB TIPO DE OPERACION
                                                                JAQN452TOP)--TIPO DE OPERACION
                                                      VALUES (  JAQNCOD,
                                                                  pd.PEPAIS,
                                                                  pd.PETDOC,
                                                                  pd.PENDOC,
                                                                  ad.PGCOD,--EMPRESA
                                                                  ad.SCMOD,--MODULO
                                                                  ad.SCSUC,--SUCURSAL
                                                                  ad.SCMDA,--MONEDA
                                                                  ad.SCPAP,--PAPEL
                                                                  ad.SCCTA,--CUENTA
                                                                  ad.SCOPER,--OPERACION
                                                                  ad.SCSBOP,--SUB TIPO DE OPERACION
                                                                  ad.SCTOPE
                                                                  );
                                                      commit;
                                                    
                                                    
                                                    
                                                        CASE  
                                                            WHEN TIPO_PERSONA = 'N' then
                                                            --DBMS_OUTPUT.PUT_LINE ('N: ');
                                                                FOR pn IN (
                                                                SELECT  c.PFPAIS,c.PFTDOC, c.PFNDOC,c.PFAPE1,c.PFAPE2,c.PFNOM1,c.PFNOM2
                                                                into  nppais,
                                                                      npetdoc,
                                                                      npendoc,
                                                                      nape1,
                                                                      nape2,
                                                                      nnom1,
                                                                      nnom2
                                                                from fsd002 c
                                                                where c.PFPAIS=pd.PEPAIS
                                                                and c.PFTDOC=pd.PETDOC
                                                                and c.PFNDOC=pd.PENDOC
                                                                and c.PFNDOC NOT IN (
                                                                            (SELECT JAQN451NDO
                                                                             FROM JAQN451
                                                                             WHERE JAQN451COD=JAQNCOD
                                                                             AND JAQN451FGE=JAQNFGE
                                                                              )
                                                                 )
                                                                )
                                                              LOOP
                                                                  JA_PAISOUT := pd.PEPAIS;
                                                                  JA_TIPOOUT := pd.PETDOC;
                                                                  JA_NUMERODOUT := pd.PENDOC;
                                                                  JA_NOMBREOUT := TRIM(pn.PFAPE1)||' '||TRIM(pn.PFAPE2)||' '||TRIM(pn.PFNOM1)||' '||TRIM(pn.PFNOM2);
                                                                  countn:=0;
                                                                  counte:=0;
                                                                  
                                                                      FOR pc IN (
                                                                            SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                            into  ddotelfp,
                                                                                  ddocod,
                                                                                  ddoorp,
                                                                                  nueve
                                                                            from fsr005 d
                                                                            where d.PEPAIS=pd.PEPAIS
                                                                            and d.PETDOC=pd.PETDOC
                                                                            and d.PENDOC=pd.PENDOC
                                                                            ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                      )LOOP
                                                                                largo := length(pc.DOTELFP);
                                                                                largocel := 9;
                                                                                emp:=SUBSTR(pc.DOTELFP,1,1);
                                                                                if largo = largocel and emp=9 and pc.CANT<>9 and countn<3 then
                                                                                  if countn=0 then
                                                                                    JA_CELULAR1OUT :=pc.DOTELFP;
                                                                                  end if;
                                                                                  if countn=1 and JA_CELULAR1OUT <> pc.DOTELFP  then
                                                                                    JA_CELULAR2OUT :=pc.DOTELFP;
                                                                                  end if;
                                                                                  if countn=2 and JA_CELULAR1OUT <> pc.DOTELFP  and JA_CELULAR2OUT <> pc.DOTELFP   then
                                                                                    JA_CELULAR3OUT :=pc.DOTELFP;
                                                                                  end if;
                                                                                  countn := countn + 1;
                                                                                end if;         
                                                                       END LOOP;
                                                                       
                                                                       FOR pe IN (
                                                                            SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                            into  email
                                                                            from FSX001 e
                                                                            where e.PEPAIS=pd.PEPAIS
                                                                            and e.PETDOC=pd.PETDOC
                                                                            and e.PENDOC=pd.PENDOC
                                                                            and e.TXCOD=0
                                                                            and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                            and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                            (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                 FROM JAQN454)
                                                                            )
                                                                            ORDER BY PEXREN DESC
                                                                        )LOOP
                                                                               --DBMS_OUTPUT.PUT_LINE ('EMAIL BAA: A '||regexp_substr(pe.PEXTXT,'[^\]*'));
                                                                          --if regexp_substr(pe.PEXTXT,'[^\]*')<>null OR regexp_substr(pe.PEXTXT,'[^\]*')<>'' then    
                                                                            if counte<3 then
                                                                                  if counte=0 then
                                                                                      JA_MAILOUT :=regexp_substr(pe.PEXTXT,'[^\]*');                    
                                                                                  end if;
                                                                                  if counte=1 then
                                                                                      JA_MAILOUT1 :=regexp_substr(pe.PEXTXT,'[^\]*');  
                                                                                  end if;
                                                                                  if counte=2 then
                                                                                      JA_MAILOUT2 :=regexp_substr(pe.PEXTXT,'[^\]*');
                                                                                  end if;
                                                                                  counte := counte + 1;                      
                                                                            end if;       
                                                                        --end if;            
                                                                        END LOOP;
                                                                       
                                                                       FOR ps IN (
                                                                                SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                into  
                                                                                SNGC13ppais,
                                                                                SNGC13petdoc,
                                                                                SNGC13pendoc,
                                                                                sDocod,
                                                                                      ssngc13Dir,
                                                                                      ssngc13RDes
                                                                                from SNGC13 f
                                                                                where f.sngc13Pais=pd.PEPAIS
                                                                                and f.sngc13Tdoc=pd.PETDOC
                                                                                and f.sngc13Ndoc=pd.PENDOC
                                                                                and f.SNGC13EST='H'
                                                                                order by sngc13RDes asc 
                                                                        )LOOP
                                                                              JA_DIRECCIONOUT := ps.sngc13Dir;
                                                                        END LOOP;
                                                                        
                                                                      --DBMS_OUTPUT.PUT_LINE ('NATURAL:'||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'||JA_MAILOUT1||'-'||JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                      INSERT INTO JAQN451 (
                                                                                      JAQN451COD,
                                                                                      JAQN451FGE,
                                                                                      JAQN451PAI,
                                                                                      JAQN451TDO,
                                                                                      JAQN451NDO,
                                                                                      JAQN451APE,
                                                                                      JAQN451CE1,
                                                                                      JAQN451CE2,
                                                                                      JAQN451CE3,
                                                                                      JAQN451CO1,
                                                                                      JAQN451CO2,
                                                                                      JAQN451CO3,
                                                                                      JAQN451DIR)
                                                                            VALUES (
                                                                                      JAQNCOD,
                                                                                      JAQNFGE,
                                                                                      JA_PAISOUT,
                                                                                      JA_TIPOOUT,
                                                                                      JA_NUMERODOUT,
                                                                                      JA_NOMBREOUT,
                                                                                      JA_CELULAR1OUT,
                                                                                      JA_CELULAR2OUT,
                                                                                      JA_CELULAR3OUT,
                                                                                      JA_MAILOUT,
                                                                                      JA_MAILOUT1,
                                                                                      JA_MAILOUT2,
                                                                                      JA_DIRECCIONOUT);
                                                                            commit;
                                                                           
                                                                            JA_MAILOUT :=null;   
                                                                            JA_MAILOUT1 :=null;   
                                                                            JA_MAILOUT2 :=null;  
                                                                            JA_CELULAR1OUT :=null;
                                                                            JA_CELULAR2OUT :=null;
                                                                            JA_CELULAR3OUT :=null;
                                                                          --DBMS_OUTPUT.PUT_LINE ('ESTADO A: '||ad.SCSTAT ||'-'||ad.PGCOD||'-' ||ad.SCCTA||'-' ||ad.SCMOD||'-' ||ad.SCTOPE||'-' ||pd.PEPAIS||'-' ||pd.PETDOC||'-' ||pd.PENDOC);
                                                   
                                                              END LOOP;--FSD001
                                                            
                                                  WHEN TIPO_PERSONA = 'J' then
                                                                FOR pg IN (
                                                                    SELECT  g.PJRAZS
                                                                    into gPjrazs
                                                                    from fsd003 g
                                                                    where g.Pjpais=pd.PEPAIS
                                                                    and g.Pjtdoc=pd.PETDOC
                                                                    and g.Pjndoc=pd.PENDOC
                                                                    and g.Pjndoc NOT IN (
                                                                            (SELECT JAQN451NDO
                                                                             FROM JAQN451
                                                                             WHERE JAQN451COD=JAQNCOD
                                                                             AND JAQN451FGE=JAQNFGE
                                                                              )
                                                                 )
                                                                )LOOP
                                                                      JA_PAISOUT := pd.PEPAIS;
                                                                      JA_TIPOOUT := pd.PETDOC;
                                                                      JA_NUMERODOUT := pd.PENDOC;
                                                                      JA_NOMBREOUT := pg.PJRAZS;
                                                                      countn:=0;
                                                                      counte:=0;
                                                                      FOR ph IN (
                                                                              SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                              into  ddotelfp,
                                                                                    ddocod,
                                                                                    ddoorp,
                                                                                    nueve
                                                                              from fsr005 d
                                                                              where d.PEPAIS=pd.PEPAIS
                                                                              and d.PETDOC=pd.PETDOC
                                                                              and d.PENDOC=pd.PENDOC
                                                                              ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                    )LOOP
                                                                              largo := length(ph.DOTELFP);
                                                                              largocel := 9;
                                                                              emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                              if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                  if countn=0 then
                                                                                    JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP   then
                                                                                    JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP  and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                    JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  countn := countn + 1;
                                                                              end if;
                                                                     END LOOP;--FSR005
                                                                     
                                                                     FOR pi IN (
                                                                      SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                      into  email
                                                                      from FSX001 e
                                                                      where e.PEPAIS=pd.PEPAIS
                                                                      and e.PETDOC=pd.PETDOC
                                                                      and e.PENDOC=pd.PENDOC
                                                                      and e.TXCOD=0
                                                                      and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                      and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                            (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                 FROM JAQN454)
                                                                            )
                                                                      ORDER BY PEXREN DESC
                                                                      )LOOP
                                                                              if counte<3 then
                                                                                  if counte=0 then
                                                                                    JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=1 then
                                                                                    JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=2 then
                                                                                    JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  counte := counte + 1;
                                                                              end if; 
                                                                      END LOOP;--FSX001
                                                                      
                                                                      
                                                                      
                                                                      FOR pj IN (
                                                                              SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                              into  
                                                                              SNGC13ppais,
                                                                              SNGC13petdoc,
                                                                              SNGC13pendoc,
                                                                              sDocod,
                                                                                    ssngc13Dir,
                                                                                    ssngc13RDes
                                                                              from SNGC13 f
                                                                              where f.sngc13Pais=pd.PEPAIS
                                                                              and f.sngc13Tdoc=pd.PETDOC
                                                                              and f.sngc13Ndoc=pd.PENDOC
                                                                              and f.SNGC13EST='H'
                                                                              order by sngc13RDes asc 
                                                                      )LOOP
                                                                                JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                      END LOOP;--SNGC13
                                                                      --DBMS_OUTPUT.PUT_LINE ('JURIDICA: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                      INSERT INTO JAQN451 (
                                                                                      JAQN451COD,
                                                                                      JAQN451FGE,
                                                                                      JAQN451PAI,
                                                                                      JAQN451TDO,
                                                                                      JAQN451NDO,
                                                                                      JAQN451APE,
                                                                                      JAQN451CE1,
                                                                                      JAQN451CE2,
                                                                                      JAQN451CE3,
                                                                                      JAQN451CO1,
                                                                                      JAQN451CO2,
                                                                                      JAQN451CO3,
                                                                                      JAQN451DIR)
                                                                            VALUES (
                                                                                      JAQNCOD,
                                                                                      JAQNFGE,
                                                                                      JA_PAISOUT,
                                                                                      JA_TIPOOUT,
                                                                                      JA_NUMERODOUT,
                                                                                      JA_NOMBREOUT,
                                                                                      JA_CELULAR1OUT,
                                                                                      JA_CELULAR2OUT,
                                                                                      JA_CELULAR3OUT,
                                                                                      JA_MAILOUT,
                                                                                      JA_MAILOUT1,
                                                                                      JA_MAILOUT2,
                                                                                      JA_DIRECCIONOUT);
                                                                            commit;
                                                                           
                                                                            JA_MAILOUT :=null;   
                                                                            JA_MAILOUT1 :=null;   
                                                                            JA_MAILOUT2 :=null;  
                                                                            JA_CELULAR1OUT :=null;
                                                                            JA_CELULAR2OUT :=null;
                                                                            JA_CELULAR3OUT :=null;
                                                                END LOOP;--FSD002
                                                                
                                                                
                                                                
                                                                
                                                  WHEN TIPO_PERSONA = 'A' then
                                                                FOR pg IN (
                                                                    SELECT  k.PENOM
                                                                    into aPenom
                                                                    from fsd001 k
                                                                    where k.Pepais=pd.PEPAIS
                                                                    and k.Petdoc=pd.PETDOC
                                                                    and k.Pendoc=pd.PENDOC
                                                                    and k.Pendoc NOT IN (
                                                                            (SELECT JAQN451NDO
                                                                             FROM JAQN451
                                                                             WHERE JAQN451COD=JAQNCOD
                                                                             AND JAQN451FGE=JAQNFGE
                                                                              )
                                                                      )
                                                                    
                                                                )LOOP
                                                                      JA_PAISOUT := pd.PEPAIS;
                                                                      JA_TIPOOUT := pd.PETDOC;
                                                                      JA_NUMERODOUT := pd.PENDOC;
                                                                      JA_NOMBREOUT := pg.PENOM;
                                                                      countn:=0;
                                                                      counte:=0;
                                                                      FOR ph IN (
                                                                              SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                              into  ddotelfp,
                                                                                    ddocod,
                                                                                    ddoorp,
                                                                                    nueve
                                                                              from fsr005 d
                                                                              where d.PEPAIS=pd.PEPAIS
                                                                              and d.PETDOC=pd.PETDOC
                                                                              and d.PENDOC=pd.PENDOC
                                                                              ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                    )LOOP
                                                                              largo := length(ph.DOTELFP);
                                                                              largocel := 9;
                                                                              emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                              if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                  if countn=0 then
                                                                                    JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP  then
                                                                                    JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP  and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                    JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  countn := countn + 1;
                                                                              end if;
                                                                     END LOOP;--FSR005
                                                                     
                                                                     FOR pi IN (
                                                                      SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                      into  email
                                                                      from FSX001 e
                                                                      where e.PEPAIS=pd.PEPAIS
                                                                      and e.PETDOC=pd.PETDOC
                                                                      and e.PENDOC=pd.PENDOC
                                                                      and e.TXCOD=0
                                                                      and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                      and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                            (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                 FROM JAQN454)
                                                                            )
                                                                      ORDER BY PEXREN DESC
                                                                      )LOOP
                                                                              if counte<3 then
                                                                                  if counte=0 then
                                                                                    JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=1 then
                                                                                    JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=2 then
                                                                                    JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  counte := counte + 1;
                                                                              end if; 
                                                                      END LOOP;--FSX001
                                                                      
                                                                      
                                                                      
                                                                      FOR pj IN (
                                                                              SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                              into  
                                                                              SNGC13ppais,
                                                                              SNGC13petdoc,
                                                                              SNGC13pendoc,
                                                                              sDocod,
                                                                                    ssngc13Dir,
                                                                                    ssngc13RDes
                                                                              from SNGC13 f
                                                                              where f.sngc13Pais=pd.PEPAIS
                                                                              and f.sngc13Tdoc=pd.PETDOC
                                                                              and f.sngc13Ndoc=pd.PENDOC
                                                                              and f.SNGC13EST='H'
                                                                              order by sngc13RDes asc 
                                                                      )LOOP
                                                                                JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                      END LOOP;--SNGC13
                                                                      --DBMS_OUTPUT.PUT_LINE ('AMBAS: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                      INSERT INTO JAQN451 (
                                                                                      JAQN451COD,
                                                                                      JAQN451FGE,
                                                                                      JAQN451PAI,
                                                                                      JAQN451TDO,
                                                                                      JAQN451NDO,
                                                                                      JAQN451APE,
                                                                                      JAQN451CE1,
                                                                                      JAQN451CE2,
                                                                                      JAQN451CE3,
                                                                                      JAQN451CO1,
                                                                                      JAQN451CO2,
                                                                                      JAQN451CO3,
                                                                                      JAQN451DIR)
                                                                            VALUES (
                                                                                      JAQNCOD,
                                                                                      JAQNFGE,
                                                                                      JA_PAISOUT,
                                                                                      JA_TIPOOUT,
                                                                                      JA_NUMERODOUT,
                                                                                      JA_NOMBREOUT,
                                                                                      JA_CELULAR1OUT,
                                                                                      JA_CELULAR2OUT,
                                                                                      JA_CELULAR3OUT,
                                                                                      JA_MAILOUT,
                                                                                      JA_MAILOUT1,
                                                                                      JA_MAILOUT2,
                                                                                      JA_DIRECCIONOUT);
                                                                            commit;
                                                                            
                                                                            JA_MAILOUT :=null;   
                                                                            JA_MAILOUT1 :=null;   
                                                                            JA_MAILOUT2 :=null;  
                                                                            JA_CELULAR1OUT :=null;
                                                                            JA_CELULAR2OUT :=null;
                                                                            JA_CELULAR3OUT :=null;
                                                                END LOOP;--FSD002
                                                            
                                                            END CASE;
                                                    END LOOP;
                                                ---SIN ESTADO
                                                END CASE;
                                        END LOOP;
                                    END LOOP;
                      END IF;--MONEDA        
                      
                      
                    
    
              WHEN JA_MODULO= 'AA' then 
                    
                    cant:=REGEXP_COUNT(MOD_OPERA,'21');
                    cant:=cant+REGEXP_COUNT(MOD_OPERA,'22');
                    mod21:=REPLACE(MOD_OPERA,'21-', '');
                    --mod21:=REPLACE(mod21,';', ',');
                    mod21:=REPLACE(mod21,'22-','9');
                    --DBMS_OUTPUT.PUT_LINE ('AA'||mod21||'-'||cant);
                    
                    
                    IF JA_MONEDA ='S' or JA_MONEDA ='D' THEN     
                              FOR i IN 1..cant LOOP
                                   tope:=REGEXP_SUBSTR(mod21, '[^;]+', 1,i );
                                  --DBMS_OUTPUT.PUT_LINE ('TOPE  '||tope);
                                  FOR ad IN (
                                          SELECT a.PGCOD, a.SCCTA,a.SCSTAT,a.SCMOD,a.SCTOPE,a.SCMDA,a.SCSUC,a.SCPAP,a.SCOPER,a.SCSBOP,a.SCSDO 
                                            into apgcod,
                                                 accta,
                                                 ascstat,
                                                 ascmod,
                                                 asctope,
                                                 ascmda,
                                                 ascsuc,
                                                 ascpap,
                                                 ascoper,
                                                 ascsbop,
                                                 ascsdo
                                            from fsd011 a
                                            where a.SCMOD =21
                                            and a.SCMDA  in (CASE WHEN JA_MONEDA='S' THEN 0
                                                                  WHEN JA_MONEDA='D' THEN 101
                                                                  END) 
                                            and a.SCFVAL >= JA_FECHA_APERTURA
                                            and a.SCFVAL <= JA_FECHA_CIERRE
                                            and a.SCCTA  >=  JA_CDESDE
                                            and a.SCCTA  <=  JA_CHASTA
                                            and a.SCTOPE = tope
                                            --and ROWNUM <= 50
                                  )
                                  LOOP
                                      --DBMS_OUTPUT.PUT_LINE ('CUENTA: '|| ad.SCCTA ||'-'||ad.SCMDA);
                                      CASE 
                                          WHEN JA_ESTADO='A' then
                                          --DBMS_OUTPUT.PUT_LINE ('ESTADO: A ');
                                                                      
                                              IF ad.SCSTAT <>99 and ad.SCSTAT<>81 THEN
                                                    FOR pd IN (
                                                        SELECT b.PEPAIS,b.PETDOC, b.PENDOC 
                                                        into  appais,
                                                              apetdoc,
                                                              apendoc
                                                        from fsr008 b
                                                        where b.PGCOD=ad.PGCOD
                                                        and b.CTNRO=ad.SCCTA
                                                        and b.TTCOD='1')
                                                    LOOP
                                                    
                                                      INSERT INTO JAQN452 (
                                                                JAQN452COD,
                                                                JAQN452PAI,
                                                                JAQN452TDO,
                                                                JAQN452NDO,
                                                                JAQN452EMP,--EMPRESA
                                                                JAQN452MOD,--MODULO
                                                                JAQN452SUC,--SUCURSAL
                                                                JAQN452MDA,--MONEDA
                                                                JAQN452PAP,--PAPEL
                                                                JAQN452CTA,--CUENTA
                                                                JAQN452OPE,--OPERACION
                                                                JAQN452SBO,--SUB TIPO DE OPERACION
                                                                JAQN452TOP)--TIPO DE OPERACION
                                                    VALUES (  JAQNCOD,
                                                                pd.PEPAIS,
                                                                pd.PETDOC,
                                                                pd.PENDOC,
                                                                ad.PGCOD,--EMPRESA
                                                                ad.SCMOD,--MODULO
                                                                ad.SCSUC,--SUCURSAL
                                                                ad.SCMDA,--MONEDA
                                                                ad.SCPAP,--PAPEL
                                                                ad.SCCTA,--CUENTA
                                                                ad.SCOPER,--OPERACION
                                                                ad.SCSBOP,--SUB TIPO DE OPERACION
                                                                ad.SCTOPE
                                                                );
                                                    commit;
                                                    
                                                    
                                                        CASE  
                                                            WHEN TIPO_PERSONA = 'N' then
                                                            --DBMS_OUTPUT.PUT_LINE ('N: ');
                                                                FOR pn IN (
                                                                SELECT  c.PFPAIS,c.PFTDOC, c.PFNDOC,c.PFAPE1,c.PFAPE2,c.PFNOM1,c.PFNOM2
                                                                into  nppais,
                                                                      npetdoc,
                                                                      npendoc,
                                                                      nape1,
                                                                      nape2,
                                                                      nnom1,
                                                                      nnom2
                                                                from fsd002 c
                                                                where c.PFPAIS=pd.PEPAIS
                                                                and c.PFTDOC=pd.PETDOC
                                                                and c.PFNDOC=pd.PENDOC
                                                                and c.PFNDOC NOT IN (
                                                                            (SELECT JAQN451NDO
                                                                             FROM JAQN451
                                                                             WHERE JAQN451COD=JAQNCOD
                                                                             AND JAQN451FGE=JAQNFGE
                                                                              )
                                                                 )
                                                                )
                                                              LOOP
                                                                  JA_PAISOUT := pd.PEPAIS;
                                                                  JA_TIPOOUT := pd.PETDOC;
                                                                  JA_NUMERODOUT := pd.PENDOC;
                                                                  JA_NOMBREOUT := TRIM(pn.PFAPE1)||' '||TRIM(pn.PFAPE2)||' '||TRIM(pn.PFNOM1)||' '||TRIM(pn.PFNOM2);
                                                                  countn:=0;
                                                                  counte:=0;
                                                                  
                                                                      FOR pc IN (
                                                                            SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                            into  ddotelfp,
                                                                                  ddocod,
                                                                                  ddoorp,
                                                                                  nueve
                                                                            from fsr005 d
                                                                            where d.PEPAIS=pd.PEPAIS
                                                                            and d.PETDOC=pd.PETDOC
                                                                            and d.PENDOC=pd.PENDOC
                                                                            ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                      )LOOP
                                                                                largo := length(pc.DOTELFP);
                                                                                largocel := 9;
                                                                                emp:=SUBSTR(pc.DOTELFP,1,1);
                                                                                if largo = largocel and emp=9 and pc.CANT<>9 and countn<3 then
                                                                                  if countn=0 then
                                                                                    JA_CELULAR1OUT :=pc.DOTELFP;
                                                                                  end if;
                                                                                  if countn=1 and JA_CELULAR1OUT <> pc.DOTELFP  then
                                                                                    JA_CELULAR2OUT :=pc.DOTELFP;
                                                                                  end if;
                                                                                  if countn=2 and JA_CELULAR1OUT <> pc.DOTELFP  and JA_CELULAR2OUT <> pc.DOTELFP then
                                                                                    JA_CELULAR3OUT :=pc.DOTELFP;
                                                                                  end if;
                                                                                  countn := countn + 1;
                                                                                end if;         
                                                                       END LOOP;
                                                                       
                                                                       FOR pe IN (
                                                                            SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                            into  email
                                                                            from FSX001 e
                                                                            where e.PEPAIS=pd.PEPAIS
                                                                            and e.PETDOC=pd.PETDOC
                                                                            and e.PENDOC=pd.PENDOC
                                                                            and e.TXCOD=0
                                                                            and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                            and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                            (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                             FROM JAQN454)
                                                                            )
                                                                            ORDER BY PEXREN DESC
                                                                        )LOOP
                                                                               --DBMS_OUTPUT.PUT_LINE ('EMAIL BAA: A '||regexp_substr(pe.PEXTXT,'[^\]*'));
                                                                          --if regexp_substr(pe.PEXTXT,'[^\]*')<>null OR regexp_substr(pe.PEXTXT,'[^\]*')<>'' then    
                                                                            if counte<3 then
                                                                                  if counte=0 then
                                                                                      JA_MAILOUT :=regexp_substr(pe.PEXTXT,'[^\]*');                    
                                                                                  end if;
                                                                                  if counte=1 then
                                                                                      JA_MAILOUT1 :=regexp_substr(pe.PEXTXT,'[^\]*');  
                                                                                  end if;
                                                                                  if counte=2 then
                                                                                      JA_MAILOUT2 :=regexp_substr(pe.PEXTXT,'[^\]*');
                                                                                  end if;
                                                                                  counte := counte + 1;                      
                                                                            end if;       
                                                                        --end if;            
                                                                        END LOOP;
                                                                       
                                                                       FOR ps IN (
                                                                                SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                into  
                                                                                SNGC13ppais,
                                                                                SNGC13petdoc,
                                                                                SNGC13pendoc,
                                                                                sDocod,
                                                                                      ssngc13Dir,
                                                                                      ssngc13RDes
                                                                                from SNGC13 f
                                                                                where f.sngc13Pais=pd.PEPAIS
                                                                                and f.sngc13Tdoc=pd.PETDOC
                                                                                and f.sngc13Ndoc=pd.PENDOC
                                                                                and f.SNGC13EST='H'
                                                                                order by sngc13RDes asc 
                                                                        )LOOP
                                                                              JA_DIRECCIONOUT := ps.sngc13Dir;
                                                                        END LOOP;
                                                                        
                                                                      --DBMS_OUTPUT.PUT_LINE ('NATURAL:'||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'||JA_MAILOUT1||'-'||JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                      INSERT INTO JAQN451 (
                                                                                      JAQN451COD,
                                                                                      JAQN451FGE,
                                                                                      JAQN451PAI,
                                                                                      JAQN451TDO,
                                                                                      JAQN451NDO,
                                                                                      JAQN451APE,
                                                                                      JAQN451CE1,
                                                                                      JAQN451CE2,
                                                                                      JAQN451CE3,
                                                                                      JAQN451CO1,
                                                                                      JAQN451CO2,
                                                                                      JAQN451CO3,
                                                                                      JAQN451DIR)
                                                                            VALUES (
                                                                                      JAQNCOD,
                                                                                      JAQNFGE,
                                                                                      JA_PAISOUT,
                                                                                      JA_TIPOOUT,
                                                                                      JA_NUMERODOUT,
                                                                                      JA_NOMBREOUT,
                                                                                      JA_CELULAR1OUT,
                                                                                      JA_CELULAR2OUT,
                                                                                      JA_CELULAR3OUT,
                                                                                      JA_MAILOUT,
                                                                                      JA_MAILOUT1,
                                                                                      JA_MAILOUT2,
                                                                                      JA_DIRECCIONOUT);
                                                                            commit;
                                                                           
                                                                            JA_MAILOUT :=null;   
                                                                            JA_MAILOUT1 :=null;   
                                                                            JA_MAILOUT2 :=null;  
                                                                            JA_CELULAR1OUT :=null;
                                                                            JA_CELULAR2OUT :=null;
                                                                            JA_CELULAR3OUT :=null;
                                                                          --DBMS_OUTPUT.PUT_LINE ('ESTADO A: '||ad.SCSTAT ||'-'||ad.PGCOD||'-' ||ad.SCCTA||'-' ||ad.SCMOD||'-' ||ad.SCTOPE||'-' ||pd.PEPAIS||'-' ||pd.PETDOC||'-' ||pd.PENDOC);
                                                   
                                                              END LOOP;--FSD001
                                                            
                                                  WHEN TIPO_PERSONA = 'J' then
                                                                FOR pg IN (
                                                                    SELECT  g.PJRAZS
                                                                    into gPjrazs
                                                                    from fsd003 g
                                                                    where g.Pjpais=pd.PEPAIS
                                                                    and g.Pjtdoc=pd.PETDOC
                                                                    and g.Pjndoc=pd.PENDOC
                                                                    and g.Pjndoc NOT IN (
                                                                            (SELECT JAQN451NDO
                                                                             FROM JAQN451
                                                                             WHERE JAQN451COD=JAQNCOD
                                                                             AND JAQN451FGE=JAQNFGE
                                                                              )
                                                                 )
                                                                )LOOP
                                                                      JA_PAISOUT := pd.PEPAIS;
                                                                      JA_TIPOOUT := pd.PETDOC;
                                                                      JA_NUMERODOUT := pd.PENDOC;
                                                                      JA_NOMBREOUT := pg.PJRAZS;
                                                                      countn:=0;
                                                                      counte:=0;
                                                                      FOR ph IN (
                                                                              SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                              into  ddotelfp,
                                                                                    ddocod,
                                                                                    ddoorp,
                                                                                    nueve
                                                                              from fsr005 d
                                                                              where d.PEPAIS=pd.PEPAIS
                                                                              and d.PETDOC=pd.PETDOC
                                                                              and d.PENDOC=pd.PENDOC
                                                                              ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                    )LOOP
                                                                              largo := length(ph.DOTELFP);
                                                                              largocel := 9;
                                                                              emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                              if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                  if countn=0 then
                                                                                    JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP  then
                                                                                    JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP  and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                    JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  countn := countn + 1;
                                                                              end if;
                                                                     END LOOP;--FSR005
                                                                     
                                                                     FOR pi IN (
                                                                      SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                      into  email
                                                                      from FSX001 e
                                                                      where e.PEPAIS=pd.PEPAIS
                                                                      and e.PETDOC=pd.PETDOC
                                                                      and e.PENDOC=pd.PENDOC
                                                                      and e.TXCOD=0
                                                                      and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                      and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                            (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                             FROM JAQN454)
                                                                            )
                                                                      ORDER BY PEXREN DESC
                                                                      )LOOP
                                                                              if counte<3 then
                                                                                  if counte=0 then
                                                                                    JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=1 then
                                                                                    JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=2 then
                                                                                    JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  counte := counte + 1;
                                                                              end if; 
                                                                      END LOOP;--FSX001
                                                                      
                                                                      
                                                                      
                                                                      FOR pj IN (
                                                                              SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                              into  
                                                                              SNGC13ppais,
                                                                              SNGC13petdoc,
                                                                              SNGC13pendoc,
                                                                              sDocod,
                                                                                    ssngc13Dir,
                                                                                    ssngc13RDes
                                                                              from SNGC13 f
                                                                              where f.sngc13Pais=pd.PEPAIS
                                                                              and f.sngc13Tdoc=pd.PETDOC
                                                                              and f.sngc13Ndoc=pd.PENDOC
                                                                              and f.SNGC13EST='H'
                                                                              order by sngc13RDes asc 
                                                                      )LOOP
                                                                                JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                      END LOOP;--SNGC13
                                                                      --DBMS_OUTPUT.PUT_LINE ('JURIDICA: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                      INSERT INTO JAQN451 (
                                                                                      JAQN451COD,
                                                                                      JAQN451FGE,
                                                                                      JAQN451PAI,
                                                                                      JAQN451TDO,
                                                                                      JAQN451NDO,
                                                                                      JAQN451APE,
                                                                                      JAQN451CE1,
                                                                                      JAQN451CE2,
                                                                                      JAQN451CE3,
                                                                                      JAQN451CO1,
                                                                                      JAQN451CO2,
                                                                                      JAQN451CO3,
                                                                                      JAQN451DIR)
                                                                            VALUES (
                                                                                      JAQNCOD,
                                                                                      JAQNFGE,
                                                                                      JA_PAISOUT,
                                                                                      JA_TIPOOUT,
                                                                                      JA_NUMERODOUT,
                                                                                      JA_NOMBREOUT,
                                                                                      JA_CELULAR1OUT,
                                                                                      JA_CELULAR2OUT,
                                                                                      JA_CELULAR3OUT,
                                                                                      JA_MAILOUT,
                                                                                      JA_MAILOUT1,
                                                                                      JA_MAILOUT2,
                                                                                      JA_DIRECCIONOUT);
                                                                            commit;
                                                                            
                                                                          
                                                                            JA_MAILOUT :=null;   
                                                                            JA_MAILOUT1 :=null;   
                                                                            JA_MAILOUT2 :=null;  
                                                                            JA_CELULAR1OUT :=null;
                                                                            JA_CELULAR2OUT :=null;
                                                                            JA_CELULAR3OUT :=null;
                                                                END LOOP;--FSD002
                                                                
                                                                
                                                                
                                                                
                                                  WHEN TIPO_PERSONA = 'A' then
                                                                FOR pg IN (
                                                                    SELECT  k.PENOM
                                                                    into aPenom
                                                                    from fsd001 k
                                                                    where k.Pepais=pd.PEPAIS
                                                                    and k.Petdoc=pd.PETDOC
                                                                    and k.Pendoc=pd.PENDOC
                                                                    and k.Pendoc NOT IN (
                                                                            (SELECT JAQN451NDO
                                                                             FROM JAQN451
                                                                             WHERE JAQN451COD=JAQNCOD
                                                                             AND JAQN451FGE=JAQNFGE
                                                                              )
                                                                      )
                                                                    
                                                                )LOOP
                                                                      JA_PAISOUT := pd.PEPAIS;
                                                                      JA_TIPOOUT := pd.PETDOC;
                                                                      JA_NUMERODOUT := pd.PENDOC;
                                                                      JA_NOMBREOUT := pg.PENOM;
                                                                      countn:=0;
                                                                      counte:=0;
                                                                      FOR ph IN (
                                                                              SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                              into  ddotelfp,
                                                                                    ddocod,
                                                                                    ddoorp,
                                                                                    nueve
                                                                              from fsr005 d
                                                                              where d.PEPAIS=pd.PEPAIS
                                                                              and d.PETDOC=pd.PETDOC
                                                                              and d.PENDOC=pd.PENDOC
                                                                              ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                    )LOOP
                                                                              largo := length(ph.DOTELFP);
                                                                              largocel := 9;
                                                                              emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                              if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                  if countn=0 then
                                                                                    JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP  then
                                                                                    JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP  and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                    JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  countn := countn + 1;
                                                                              end if;
                                                                     END LOOP;--FSR005
                                                                     
                                                                     FOR pi IN (
                                                                      SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                      into  email
                                                                      from FSX001 e
                                                                      where e.PEPAIS=pd.PEPAIS
                                                                      and e.PETDOC=pd.PETDOC
                                                                      and e.PENDOC=pd.PENDOC
                                                                      and e.TXCOD=0
                                                                      and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                      and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                           (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                             FROM JAQN454)
                                                                            )
                                                                      ORDER BY PEXREN DESC
                                                                      )LOOP
                                                                              if counte<3 then
                                                                                  if counte=0 then
                                                                                    JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=1 then
                                                                                    JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=2 then
                                                                                    JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  counte := counte + 1;
                                                                              end if; 
                                                                      END LOOP;--FSX001
                                                                      
                                                                      
                                                                      
                                                                      FOR pj IN (
                                                                              SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                              into  
                                                                              SNGC13ppais,
                                                                              SNGC13petdoc,
                                                                              SNGC13pendoc,
                                                                              sDocod,
                                                                                    ssngc13Dir,
                                                                                    ssngc13RDes
                                                                              from SNGC13 f
                                                                              where f.sngc13Pais=pd.PEPAIS
                                                                              and f.sngc13Tdoc=pd.PETDOC
                                                                              and f.sngc13Ndoc=pd.PENDOC
                                                                              and f.SNGC13EST='H'
                                                                              order by sngc13RDes asc 
                                                                      )LOOP
                                                                                JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                      END LOOP;--SNGC13
                                                                      --DBMS_OUTPUT.PUT_LINE ('AMBAS: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                      INSERT INTO JAQN451 (
                                                                                      JAQN451COD,
                                                                                      JAQN451FGE,
                                                                                      JAQN451PAI,
                                                                                      JAQN451TDO,
                                                                                      JAQN451NDO,
                                                                                      JAQN451APE,
                                                                                      JAQN451CE1,
                                                                                      JAQN451CE2,
                                                                                      JAQN451CE3,
                                                                                      JAQN451CO1,
                                                                                      JAQN451CO2,
                                                                                      JAQN451CO3,
                                                                                      JAQN451DIR)
                                                                            VALUES (
                                                                                      JAQNCOD,
                                                                                      JAQNFGE,
                                                                                      JA_PAISOUT,
                                                                                      JA_TIPOOUT,
                                                                                      JA_NUMERODOUT,
                                                                                      JA_NOMBREOUT,
                                                                                      JA_CELULAR1OUT,
                                                                                      JA_CELULAR2OUT,
                                                                                      JA_CELULAR3OUT,
                                                                                      JA_MAILOUT,
                                                                                      JA_MAILOUT1,
                                                                                      JA_MAILOUT2,
                                                                                      JA_DIRECCIONOUT);
                                                                            commit;
                                                                            
                                                                            JA_MAILOUT :=null;   
                                                                            JA_MAILOUT1 :=null;   
                                                                            JA_MAILOUT2 :=null;  
                                                                            JA_CELULAR1OUT :=null;
                                                                            JA_CELULAR2OUT :=null;
                                                                            JA_CELULAR3OUT :=null;
                                                                END LOOP;--FSD002
                                                            
                                                            END CASE;
                                                    END LOOP;
          
                                              END IF;
                                              
                                              
                                          WHEN JA_ESTADO='I' then
                                              IF ad.SCSTAT =81 THEN
                                                --DBMS_OUTPUT.PUT_LINE ('ESTADO I: '||ad.SCSTAT ||'-'||ad.PGCOD||'-' ||ad.SCCTA||'-' ||ad.SCMOD||'-' ||ad.SCTOPE);
                                                       
                                                              FOR pd IN (
                                                                  SELECT b.PEPAIS,b.PETDOC, b.PENDOC 
                                                                  into  appais,
                                                                        apetdoc,
                                                                        apendoc
                                                                  from fsr008 b
                                                                  where b.PGCOD=ad.PGCOD
                                                                  and b.CTNRO=ad.SCCTA
                                                                  and b.TTCOD='1')
                                                              LOOP
                                                              
                                                              INSERT INTO JAQN452 (
                                                                JAQN452COD,
                                                                JAQN452PAI,
                                                                JAQN452TDO,
                                                                JAQN452NDO,
                                                                JAQN452EMP,--EMPRESA
                                                                JAQN452MOD,--MODULO
                                                                JAQN452SUC,--SUCURSAL
                                                                JAQN452MDA,--MONEDA
                                                                JAQN452PAP,--PAPEL
                                                                JAQN452CTA,--CUENTA
                                                                JAQN452OPE,--OPERACION
                                                                JAQN452SBO,--SUB TIPO DE OPERACION
                                                                JAQN452TOP)--TIPO DE OPERACION
                                                            VALUES (  JAQNCOD,
                                                                        pd.PEPAIS,
                                                                        pd.PETDOC,
                                                                        pd.PENDOC,
                                                                        ad.PGCOD,--EMPRESA
                                                                        ad.SCMOD,--MODULO
                                                                        ad.SCSUC,--SUCURSAL
                                                                        ad.SCMDA,--MONEDA
                                                                        ad.SCPAP,--PAPEL
                                                                        ad.SCCTA,--CUENTA
                                                                        ad.SCOPER,--OPERACION
                                                                        ad.SCSBOP,--SUB TIPO DE OPERACION
                                                                        ad.SCTOPE
                                                                        );
                                                            commit;
                                                              
                                                              
                                                                  CASE  
                                                                      WHEN TIPO_PERSONA = 'N' then
                                                                      
                                                                          FOR pn IN (
                                                                          SELECT c.PFPAIS,c.PFTDOC, c.PFNDOC,c.PFAPE1,c.PFAPE2,c.PFNOM1,c.PFNOM2
                                                                          into  nppais,
                                                                                npetdoc,
                                                                                npendoc,
                                                                                nape1,
                                                                                nape2,
                                                                                nnom1,
                                                                                nnom2
                                                                          from fsd002 c
                                                                          where c.PFPAIS=pd.PEPAIS
                                                                          and c.PFTDOC=pd.PETDOC
                                                                          and c.PFNDOC=pd.PENDOC
                                                                          and c.PFNDOC NOT IN (
                                                                            (SELECT JAQN451NDO
                                                                             FROM JAQN451
                                                                             WHERE JAQN451COD=JAQNCOD
                                                                             AND JAQN451FGE=JAQNFGE
                                                                              )
                                                                            )
                                                                          )
                                                                        LOOP
                                                                            JA_PAISOUT := pd.PEPAIS;
                                                                            JA_TIPOOUT := pd.PETDOC;
                                                                            JA_NUMERODOUT := pd.PENDOC;
                                                                            JA_NOMBREOUT := TRIM(pn.PFAPE1)||' '||TRIM(pn.PFAPE2)||' '||TRIM(pn.PFNOM1)||' '||TRIM(pn.PFNOM2);
                                                                            countn:=0;
                                                                            counte:=0;
                                                                            
                                                                                FOR pc IN (
                                                                                      SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                                      into  ddotelfp,
                                                                                            ddocod,
                                                                                            ddoorp,
                                                                                            nueve
                                                                                      from fsr005 d
                                                                                      where d.PEPAIS=pd.PEPAIS
                                                                                      and d.PETDOC=pd.PETDOC
                                                                                      and d.PENDOC=pd.PENDOC
                                                                                      ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                                )LOOP
                                                                                          largo := length(pc.DOTELFP);
                                                                                          largocel := 9;
                                                                                          emp:=SUBSTR(pc.DOTELFP,1,1);
                                                                                          if largo = largocel and emp=9 and pc.CANT<>9 and countn<3 then
                                                                                            if countn=0 then
                                                                                              JA_CELULAR1OUT :=pc.DOTELFP;
                                                                                            end if;
                                                                                            if countn=1 and JA_CELULAR1OUT <> pc.DOTELFP  then
                                                                                              JA_CELULAR2OUT :=pc.DOTELFP;
                                                                                            end if;
                                                                                            if countn=2 and JA_CELULAR1OUT <> pc.DOTELFP  and JA_CELULAR2OUT <> pc.DOTELFP then
                                                                                              JA_CELULAR3OUT :=pc.DOTELFP;
                                                                                            end if;
                                                                                            countn := countn + 1;
                                                                                          end if;         
                                                                                 END LOOP;
                                                                                 
                                                                                 FOR pe IN (
                                                                                      SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                                      into  email
                                                                                      from FSX001 e
                                                                                      where e.PEPAIS=pd.PEPAIS
                                                                                      and e.PETDOC=pd.PETDOC
                                                                                      and e.PENDOC=pd.PENDOC
                                                                                      and e.TXCOD=0
                                                                                      and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                                      and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                                      (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                         FROM JAQN454)
                                                                                        )
                                                                                      ORDER BY PEXREN DESC
                                                                                  )LOOP
                                                                                        if counte<3 then
                                                                                            if counte=0 then
                                                                                              JA_MAILOUT :=regexp_substr(pe.PEXTXT,'[^\]*');   
                                                                                            end if;
                                                                                            if counte=1 then
                                                                                              JA_MAILOUT1 :=regexp_substr(pe.PEXTXT,'[^\]*');   
                                                                                            end if;
                                                                                            if counte=2 then
                                                                                              JA_MAILOUT2 :=regexp_substr(pe.PEXTXT,'[^\]*');   
                                                                                            end if;
                                                                                            counte := counte + 1;
                                                                                        end if; 
                    
                                                                                  END LOOP;
                                                                                 
                                                                                 FOR ps IN (
                                                                                          SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                          into  
                                                                                          SNGC13ppais,
                                                                                          SNGC13petdoc,
                                                                                          SNGC13pendoc,
                                                                                          sDocod,
                                                                                                ssngc13Dir,
                                                                                                ssngc13RDes
                                                                                          from SNGC13 f
                                                                                          where f.sngc13Pais=pd.PEPAIS
                                                                                          and f.sngc13Tdoc=pd.PETDOC
                                                                                          and f.sngc13Ndoc=pd.PENDOC
                                                                                          and f.SNGC13EST='H'
                                                                                          order by sngc13RDes asc 
                                                                                  )LOOP
                                                                                        JA_DIRECCIONOUT := ps.sngc13Dir;
                                                                                  END LOOP;
                                                                                  
                                                                                  --DBMS_OUTPUT.PUT_LINE ('CUENTA: '|| ad.SCCTA );
                                                                                  --DBMS_OUTPUT.PUT_LINE ('NATURAL:'||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'||JA_MAILOUT1||'-'||JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                                  INSERT INTO JAQN451 (
                                                                                                JAQN451COD,
                                                                                                JAQN451FGE,
                                                                                                JAQN451PAI,
                                                                                                JAQN451TDO,
                                                                                                JAQN451NDO,
                                                                                                JAQN451APE,
                                                                                                JAQN451CE1,
                                                                                                JAQN451CE2,
                                                                                                JAQN451CE3,
                                                                                                JAQN451CO1,
                                                                                                JAQN451CO2,
                                                                                                JAQN451CO3,
                                                                                                JAQN451DIR)
                                                                                      VALUES (
                                                                                                JAQNCOD,
                                                                                                JAQNFGE,
                                                                                                JA_PAISOUT,
                                                                                                JA_TIPOOUT,
                                                                                                JA_NUMERODOUT,
                                                                                                JA_NOMBREOUT,
                                                                                                JA_CELULAR1OUT,
                                                                                                JA_CELULAR2OUT,
                                                                                                JA_CELULAR3OUT,
                                                                                                JA_MAILOUT,
                                                                                                JA_MAILOUT1,
                                                                                                JA_MAILOUT2,
                                                                                                JA_DIRECCIONOUT);
                                                                                      commit;
                                                                                                                                                                            JA_MAILOUT :=null;   
                                                                                      JA_MAILOUT1 :=null;   
                                                                                      JA_MAILOUT2 :=null;  
                                                                                      JA_CELULAR1OUT :=null;
                                                                                      JA_CELULAR2OUT :=null;
                                                                                      JA_CELULAR3OUT :=null;
                                                                                    --DBMS_OUTPUT.PUT_LINE ('ESTADO A: '||ad.SCSTAT ||'-'||ad.PGCOD||'-' ||ad.SCCTA||'-' ||ad.SCMOD||'-' ||ad.SCTOPE||'-' ||pd.PEPAIS||'-' ||pd.PETDOC||'-' ||pd.PENDOC);
                                                             
                                                                        END LOOP;--FSD001
                                                                      
                                                            WHEN TIPO_PERSONA = 'J' then
                                                                          FOR pg IN (
                                                                              SELECT g.PJRAZS
                                                                              into gPjrazs
                                                                              from fsd003 g
                                                                              where g.Pjpais=pd.PEPAIS
                                                                              and g.Pjtdoc=pd.PETDOC
                                                                              and g.Pjndoc=pd.PENDOC
                                                                              and g.Pjndoc NOT IN (
                                                                              (SELECT JAQN451NDO
                                                                               FROM JAQN451
                                                                               WHERE JAQN451COD=JAQNCOD
                                                                               AND JAQN451FGE=JAQNFGE
                                                                                )
                                                                              )
                                                                          )LOOP
                                                                                JA_PAISOUT := pd.PEPAIS;
                                                                                JA_TIPOOUT := pd.PETDOC;
                                                                                JA_NUMERODOUT := pd.PENDOC;
                                                                                JA_NOMBREOUT := pg.PJRAZS;
                                                                                countn:=0;
                                                                                counte:=0;
                                                                                FOR ph IN (
                                                                                        SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                                        into  ddotelfp,
                                                                                              ddocod,
                                                                                              ddoorp,
                                                                                              nueve
                                                                                        from fsr005 d
                                                                                        where d.PEPAIS=pd.PEPAIS
                                                                                        and d.PETDOC=pd.PETDOC
                                                                                        and d.PENDOC=pd.PENDOC
                                                                                        ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                              )LOOP
                                                                                        largo := length(ph.DOTELFP);
                                                                                        largocel := 9;
                                                                                        emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                                        if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                            if countn=0 then
                                                                                              JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                            end if;
                                                                                            if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP then
                                                                                              JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                            end if;
                                                                                            if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP  and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                              JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                            end if;
                                                                                            countn := countn + 1;
                                                                                        end if;
                                                                               END LOOP;--FSR005
                                                                               
                                                                               FOR pi IN (
                                                                                SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                                into  email
                                                                                from FSX001 e
                                                                                where e.PEPAIS=pd.PEPAIS
                                                                                and e.PETDOC=pd.PETDOC
                                                                                and e.PENDOC=pd.PENDOC
                                                                                and e.TXCOD=0
                                                                                and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                                and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                                    (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                       FROM JAQN454)
                                                                                      )
                                                                                ORDER BY PEXREN DESC
                                                                                )LOOP
                                                                                        if counte<3 then
                                                                                            if counte=0 then
                                                                                              JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                            end if;
                                                                                            if counte=1 then
                                                                                              JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                            end if;
                                                                                            if counte=2 then
                                                                                              JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                            end if;
                                                                                            counte := counte + 1;
                                                                                        end if; 
                                                                                END LOOP;--FSX001
                                                                                
                                                                                
                                                                                
                                                                                FOR pj IN (
                                                                                        SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                        into  
                                                                                        SNGC13ppais,
                                                                                        SNGC13petdoc,
                                                                                        SNGC13pendoc,
                                                                                        sDocod,
                                                                                              ssngc13Dir,
                                                                                              ssngc13RDes
                                                                                        from SNGC13 f
                                                                                        where f.sngc13Pais=pd.PEPAIS
                                                                                        and f.sngc13Tdoc=pd.PETDOC
                                                                                        and f.sngc13Ndoc=pd.PENDOC
                                                                                        and f.SNGC13EST='H'
                                                                                        order by sngc13RDes asc 
                                                                                )LOOP
                                                                                          JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                                END LOOP;--SNGC13
                                                                                --DBMS_OUTPUT.PUT_LINE ('JURIDICA: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                                INSERT INTO JAQN451 (
                                                                                                JAQN451COD,
                                                                                                JAQN451FGE,
                                                                                                JAQN451PAI,
                                                                                                JAQN451TDO,
                                                                                                JAQN451NDO,
                                                                                                JAQN451APE,
                                                                                                JAQN451CE1,
                                                                                                JAQN451CE2,
                                                                                                JAQN451CE3,
                                                                                                JAQN451CO1,
                                                                                                JAQN451CO2,
                                                                                                JAQN451CO3,
                                                                                                JAQN451DIR)
                                                                                      VALUES (
                                                                                                JAQNCOD,
                                                                                                JAQNFGE,
                                                                                                JA_PAISOUT,
                                                                                                JA_TIPOOUT,
                                                                                                JA_NUMERODOUT,
                                                                                                JA_NOMBREOUT,
                                                                                                JA_CELULAR1OUT,
                                                                                                JA_CELULAR2OUT,
                                                                                                JA_CELULAR3OUT,
                                                                                                JA_MAILOUT,
                                                                                                JA_MAILOUT1,
                                                                                                JA_MAILOUT2,
                                                                                                JA_DIRECCIONOUT);
                                                                                      commit;
                                                                                      
                                                                                     
                                                                                      JA_MAILOUT :=null;   
                                                                                      JA_MAILOUT1 :=null;   
                                                                                      JA_MAILOUT2 :=null;  
                                                                                      JA_CELULAR1OUT :=null;
                                                                                      JA_CELULAR2OUT :=null;
                                                                                      JA_CELULAR3OUT :=null;
                                                                          END LOOP;--FSD002
                                                                          
                                                                          
                                                                          
                                                                          
                                                            WHEN TIPO_PERSONA = 'A' then
                                                                          FOR pg IN (
                                                                              SELECT k.PENOM
                                                                              into aPenom
                                                                              from fsd001 k
                                                                              where k.Pepais=pd.PEPAIS
                                                                              and k.Petdoc=pd.PETDOC
                                                                              and k.Pendoc=pd.PENDOC
                                                                              and k.Pendoc NOT IN (
                                                                              (SELECT JAQN451NDO
                                                                               FROM JAQN451
                                                                               WHERE JAQN451COD=JAQNCOD
                                                                               AND JAQN451FGE=JAQNFGE
                                                                                )
                                                                              )
                                                                          )LOOP
                                                                                JA_PAISOUT := pd.PEPAIS;
                                                                                JA_TIPOOUT := pd.PETDOC;
                                                                                JA_NUMERODOUT := pd.PENDOC;
                                                                                JA_NOMBREOUT := pg.PENOM;
                                                                                countn:=0;
                                                                                counte:=0;
                                                                                FOR ph IN (
                                                                                        SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                                        into  ddotelfp,
                                                                                              ddocod,
                                                                                              ddoorp,
                                                                                              nueve
                                                                                        from fsr005 d
                                                                                        where d.PEPAIS=pd.PEPAIS
                                                                                        and d.PETDOC=pd.PETDOC
                                                                                        and d.PENDOC=pd.PENDOC
                                                                                        ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                              )LOOP
                                                                                        largo := length(ph.DOTELFP);
                                                                                        largocel := 9;
                                                                                        emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                                        if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                            if countn=0 then
                                                                                              JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                            end if;
                                                                                            if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP  then
                                                                                              JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                            end if;
                                                                                            if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP  and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                              JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                            end if;
                                                                                            countn := countn + 1;
                                                                                        end if;
                                                                               END LOOP;--FSR005
                                                                               
                                                                               FOR pi IN (
                                                                                SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                                into  email
                                                                                from FSX001 e
                                                                                where e.PEPAIS=pd.PEPAIS
                                                                                and e.PETDOC=pd.PETDOC
                                                                                and e.PENDOC=pd.PENDOC
                                                                                and e.TXCOD=0
                                                                                and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                                and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                                    (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                       FROM JAQN454)
                                                                                    )
                                                                                ORDER BY PEXREN DESC
                                                                                )LOOP
                                                                                        if counte<3 then
                                                                                            if counte=0 then
                                                                                              JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                            end if;
                                                                                            if counte=1 then
                                                                                              JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                            end if;
                                                                                            if counte=2 then
                                                                                              JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                            end if;
                                                                                            counte := counte + 1;
                                                                                        end if; 
                                                                                END LOOP;--FSX001
                                                                                
                                                                                
                                                                                
                                                                                FOR pj IN (
                                                                                        SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                        into  
                                                                                        SNGC13ppais,
                                                                                        SNGC13petdoc,
                                                                                        SNGC13pendoc,
                                                                                        sDocod,
                                                                                              ssngc13Dir,
                                                                                              ssngc13RDes
                                                                                        from SNGC13 f
                                                                                        where f.sngc13Pais=pd.PEPAIS
                                                                                        and f.sngc13Tdoc=pd.PETDOC
                                                                                        and f.sngc13Ndoc=pd.PENDOC
                                                                                        and f.SNGC13EST='H'
                                                                                        order by sngc13RDes asc 
                                                                                )LOOP
                                                                                          JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                                END LOOP;--SNGC13
                                                                                --DBMS_OUTPUT.PUT_LINE ('AMBAS: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                                INSERT INTO JAQN451 (
                                                                                                JAQN451COD,
                                                                                                JAQN451FGE,
                                                                                                JAQN451PAI,
                                                                                                JAQN451TDO,
                                                                                                JAQN451NDO,
                                                                                                JAQN451APE,
                                                                                                JAQN451CE1,
                                                                                                JAQN451CE2,
                                                                                                JAQN451CE3,
                                                                                                JAQN451CO1,
                                                                                                JAQN451CO2,
                                                                                                JAQN451CO3,
                                                                                                JAQN451DIR)
                                                                                      VALUES (
                                                                                                JAQNCOD,
                                                                                                JAQNFGE,
                                                                                                JA_PAISOUT,
                                                                                                JA_TIPOOUT,
                                                                                                JA_NUMERODOUT,
                                                                                                JA_NOMBREOUT,
                                                                                                JA_CELULAR1OUT,
                                                                                                JA_CELULAR2OUT,
                                                                                                JA_CELULAR3OUT,
                                                                                                JA_MAILOUT,
                                                                                                JA_MAILOUT1,
                                                                                                JA_MAILOUT2,
                                                                                                JA_DIRECCIONOUT);
                                                                                      commit;
                                                                                      
                                                                                      JA_MAILOUT :=null;   
                                                                                      JA_MAILOUT1 :=null;   
                                                                                      JA_MAILOUT2 :=null;  
                                                                                      JA_CELULAR1OUT :=null;
                                                                                      JA_CELULAR2OUT :=null;
                                                                                      JA_CELULAR3OUT :=null;
                                                                          END LOOP;--FSD002
                                                                      
                                                                      END CASE;
                                                              END LOOP;
                                                    
                                              END IF; --ESTADO I
                                              
                                          WHEN JA_ESTADO='T' then
                                            
                                                    FOR pd IN (
                                                        SELECT b.PEPAIS,b.PETDOC, b.PENDOC 
                                                        into  appais,
                                                              apetdoc,
                                                              apendoc
                                                        from fsr008 b
                                                        where b.PGCOD=ad.PGCOD
                                                        and b.CTNRO=ad.SCCTA
                                                        and b.TTCOD='1')
                                                    LOOP
                                                      INSERT INTO JAQN452 (
                                                                JAQN452COD,
                                                                JAQN452PAI,
                                                                JAQN452TDO,
                                                                JAQN452NDO,
                                                                JAQN452EMP,--EMPRESA
                                                                JAQN452MOD,--MODULO
                                                                JAQN452SUC,--SUCURSAL
                                                                JAQN452MDA,--MONEDA
                                                                JAQN452PAP,--PAPEL
                                                                JAQN452CTA,--CUENTA
                                                                JAQN452OPE,--OPERACION
                                                                JAQN452SBO,--SUB TIPO DE OPERACION
                                                                JAQN452TOP)--TIPO DE OPERACION
                                                        VALUES (  JAQNCOD,
                                                                    pd.PEPAIS,
                                                                    pd.PETDOC,
                                                                    pd.PENDOC,
                                                                    ad.PGCOD,--EMPRESA
                                                                    ad.SCMOD,--MODULO
                                                                    ad.SCSUC,--SUCURSAL
                                                                    ad.SCMDA,--MONEDA
                                                                    ad.SCPAP,--PAPEL
                                                                    ad.SCCTA,--CUENTA
                                                                    ad.SCOPER,--OPERACION
                                                                    ad.SCSBOP,--SUB TIPO DE OPERACION
                                                                    ad.SCTOPE
                                                                    );
                                                        commit;
                                                    
                                                    
                                                        CASE  
                                                            WHEN TIPO_PERSONA = 'N' then
                                                            --DBMS_OUTPUT.PUT_LINE ('N: ');
                                                                FOR pn IN (
                                                                SELECT  c.PFPAIS,c.PFTDOC, c.PFNDOC,c.PFAPE1,c.PFAPE2,c.PFNOM1,c.PFNOM2
                                                                into  nppais,
                                                                      npetdoc,
                                                                      npendoc,
                                                                      nape1,
                                                                      nape2,
                                                                      nnom1,
                                                                      nnom2
                                                                from fsd002 c
                                                                where c.PFPAIS=pd.PEPAIS
                                                                and c.PFTDOC=pd.PETDOC
                                                                and c.PFNDOC=pd.PENDOC
                                                                and c.PFNDOC NOT IN (
                                                                            (SELECT JAQN451NDO
                                                                             FROM JAQN451
                                                                             WHERE JAQN451COD=JAQNCOD
                                                                             AND JAQN451FGE=JAQNFGE
                                                                              )
                                                                 )
                                                                )
                                                              LOOP
                                                                  JA_PAISOUT := pd.PEPAIS;
                                                                  JA_TIPOOUT := pd.PETDOC;
                                                                  JA_NUMERODOUT := pd.PENDOC;
                                                                  JA_NOMBREOUT := TRIM(pn.PFAPE1)||' '||TRIM(pn.PFAPE2)||' '||TRIM(pn.PFNOM1)||' '||TRIM(pn.PFNOM2);
                                                                  countn:=0;
                                                                  counte:=0;
                                                                  
                                                                      FOR pc IN (
                                                                            SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                            into  ddotelfp,
                                                                                  ddocod,
                                                                                  ddoorp,
                                                                                  nueve
                                                                            from fsr005 d
                                                                            where d.PEPAIS=pd.PEPAIS
                                                                            and d.PETDOC=pd.PETDOC
                                                                            and d.PENDOC=pd.PENDOC
                                                                            ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                      )LOOP
                                                                                largo := length(pc.DOTELFP);
                                                                                largocel := 9;
                                                                                emp:=SUBSTR(pc.DOTELFP,1,1);
                                                                                if largo = largocel and emp=9 and pc.CANT<>9 and countn<3 then
                                                                                  if countn=0 then
                                                                                    JA_CELULAR1OUT :=pc.DOTELFP;
                                                                                  end if;
                                                                                  if countn=1 and JA_CELULAR1OUT <> pc.DOTELFP then
                                                                                    JA_CELULAR2OUT :=pc.DOTELFP;
                                                                                  end if;
                                                                                  if countn=2 and JA_CELULAR1OUT <> pc.DOTELFP  and JA_CELULAR2OUT <> pc.DOTELFP then
                                                                                    JA_CELULAR3OUT :=pc.DOTELFP;
                                                                                  end if;
                                                                                  countn := countn + 1;
                                                                                end if;         
                                                                       END LOOP;
                                                                       
                                                                       FOR pe IN (
                                                                            SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                            into  email
                                                                            from FSX001 e
                                                                            where e.PEPAIS=pd.PEPAIS
                                                                            and e.PETDOC=pd.PETDOC
                                                                            and e.PENDOC=pd.PENDOC
                                                                            and e.TXCOD=0
                                                                            and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                            and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                            (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                       FROM JAQN454)
                                                                            )
                                                                            ORDER BY PEXREN DESC
                                                                        )LOOP
                                                                               --DBMS_OUTPUT.PUT_LINE ('EMAIL BAA: A '||regexp_substr(pe.PEXTXT,'[^\]*'));
                                                                          --if regexp_substr(pe.PEXTXT,'[^\]*')<>null OR regexp_substr(pe.PEXTXT,'[^\]*')<>'' then    
                                                                            if counte<3 then
                                                                                  if counte=0 then
                                                                                      JA_MAILOUT :=regexp_substr(pe.PEXTXT,'[^\]*');                    
                                                                                  end if;
                                                                                  if counte=1 then
                                                                                      JA_MAILOUT1 :=regexp_substr(pe.PEXTXT,'[^\]*');  
                                                                                  end if;
                                                                                  if counte=2 then
                                                                                      JA_MAILOUT2 :=regexp_substr(pe.PEXTXT,'[^\]*');
                                                                                  end if;
                                                                                  counte := counte + 1;                      
                                                                            end if;       
                                                                        --end if;            
                                                                        END LOOP;
                                                                       
                                                                       FOR ps IN (
                                                                                SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                into  
                                                                                SNGC13ppais,
                                                                                SNGC13petdoc,
                                                                                SNGC13pendoc,
                                                                                sDocod,
                                                                                      ssngc13Dir,
                                                                                      ssngc13RDes
                                                                                from SNGC13 f
                                                                                where f.sngc13Pais=pd.PEPAIS
                                                                                and f.sngc13Tdoc=pd.PETDOC
                                                                                and f.sngc13Ndoc=pd.PENDOC
                                                                                and f.SNGC13EST='H'
                                                                                order by sngc13RDes asc 
                                                                        )LOOP
                                                                              JA_DIRECCIONOUT := ps.sngc13Dir;
                                                                        END LOOP;
                                                                        
                                                                      --DBMS_OUTPUT.PUT_LINE ('NATURAL:'||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'||JA_MAILOUT1||'-'||JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                      INSERT INTO JAQN451 (
                                                                                      JAQN451COD,
                                                                                      JAQN451FGE,
                                                                                      JAQN451PAI,
                                                                                      JAQN451TDO,
                                                                                      JAQN451NDO,
                                                                                      JAQN451APE,
                                                                                      JAQN451CE1,
                                                                                      JAQN451CE2,
                                                                                      JAQN451CE3,
                                                                                      JAQN451CO1,
                                                                                      JAQN451CO2,
                                                                                      JAQN451CO3,
                                                                                      JAQN451DIR)
                                                                            VALUES (
                                                                                      JAQNCOD,
                                                                                      JAQNFGE,
                                                                                      JA_PAISOUT,
                                                                                      JA_TIPOOUT,
                                                                                      JA_NUMERODOUT,
                                                                                      JA_NOMBREOUT,
                                                                                      JA_CELULAR1OUT,
                                                                                      JA_CELULAR2OUT,
                                                                                      JA_CELULAR3OUT,
                                                                                      JA_MAILOUT,
                                                                                      JA_MAILOUT1,
                                                                                      JA_MAILOUT2,
                                                                                      JA_DIRECCIONOUT);
                                                                            commit;
                                                                            
                                                                           
                                                                            JA_MAILOUT :=null;   
                                                                            JA_MAILOUT1 :=null;   
                                                                            JA_MAILOUT2 :=null;  
                                                                            JA_CELULAR1OUT :=null;
                                                                            JA_CELULAR2OUT :=null;
                                                                            JA_CELULAR3OUT :=null;
                                                                          --DBMS_OUTPUT.PUT_LINE ('ESTADO A: '||ad.SCSTAT ||'-'||ad.PGCOD||'-' ||ad.SCCTA||'-' ||ad.SCMOD||'-' ||ad.SCTOPE||'-' ||pd.PEPAIS||'-' ||pd.PETDOC||'-' ||pd.PENDOC);
                                                   
                                                              END LOOP;--FSD001
                                                            
                                                  WHEN TIPO_PERSONA = 'J' then
                                                                FOR pg IN (
                                                                    SELECT  g.PJRAZS
                                                                    into gPjrazs
                                                                    from fsd003 g
                                                                    where g.Pjpais=pd.PEPAIS
                                                                    and g.Pjtdoc=pd.PETDOC
                                                                    and g.Pjndoc=pd.PENDOC
                                                                    and g.Pjndoc NOT IN (
                                                                            (SELECT JAQN451NDO
                                                                             FROM JAQN451
                                                                             WHERE JAQN451COD=JAQNCOD
                                                                             AND JAQN451FGE=JAQNFGE
                                                                              )
                                                                 )
                                                                )LOOP
                                                                      JA_PAISOUT := pd.PEPAIS;
                                                                      JA_TIPOOUT := pd.PETDOC;
                                                                      JA_NUMERODOUT := pd.PENDOC;
                                                                      JA_NOMBREOUT := pg.PJRAZS;
                                                                      countn:=0;
                                                                      counte:=0;
                                                                      FOR ph IN (
                                                                              SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                              into  ddotelfp,
                                                                                    ddocod,
                                                                                    ddoorp,
                                                                                    nueve
                                                                              from fsr005 d
                                                                              where d.PEPAIS=pd.PEPAIS
                                                                              and d.PETDOC=pd.PETDOC
                                                                              and d.PENDOC=pd.PENDOC
                                                                              ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                    )LOOP
                                                                              largo := length(ph.DOTELFP);
                                                                              largocel := 9;
                                                                              emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                              if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                  if countn=0 then
                                                                                    JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP   then
                                                                                    JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP  and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                    JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  countn := countn + 1;
                                                                              end if;
                                                                     END LOOP;--FSR005
                                                                     
                                                                     FOR pi IN (
                                                                      SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                      into  email
                                                                      from FSX001 e
                                                                      where e.PEPAIS=pd.PEPAIS
                                                                      and e.PETDOC=pd.PETDOC
                                                                      and e.PENDOC=pd.PENDOC
                                                                      and e.TXCOD=0
                                                                      and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                      and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                            (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                       FROM JAQN454)
                                                                            )
                                                                      ORDER BY PEXREN DESC
                                                                      )LOOP
                                                                              if counte<3 then
                                                                                  if counte=0 then
                                                                                    JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=1 then
                                                                                    JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=2 then
                                                                                    JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  counte := counte + 1;
                                                                              end if; 
                                                                      END LOOP;--FSX001
                                                                      
                                                                      
                                                                      
                                                                      FOR pj IN (
                                                                              SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                              into  
                                                                              SNGC13ppais,
                                                                              SNGC13petdoc,
                                                                              SNGC13pendoc,
                                                                              sDocod,
                                                                                    ssngc13Dir,
                                                                                    ssngc13RDes
                                                                              from SNGC13 f
                                                                              where f.sngc13Pais=pd.PEPAIS
                                                                              and f.sngc13Tdoc=pd.PETDOC
                                                                              and f.sngc13Ndoc=pd.PENDOC
                                                                              and f.SNGC13EST='H'
                                                                              order by sngc13RDes asc 
                                                                      )LOOP
                                                                                JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                      END LOOP;--SNGC13
                                                                      --DBMS_OUTPUT.PUT_LINE ('JURIDICA: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                      INSERT INTO JAQN451 (
                                                                                      JAQN451COD,
                                                                                      JAQN451FGE,
                                                                                      JAQN451PAI,
                                                                                      JAQN451TDO,
                                                                                      JAQN451NDO,
                                                                                      JAQN451APE,
                                                                                      JAQN451CE1,
                                                                                      JAQN451CE2,
                                                                                      JAQN451CE3,
                                                                                      JAQN451CO1,
                                                                                      JAQN451CO2,
                                                                                      JAQN451CO3,
                                                                                      JAQN451DIR)
                                                                            VALUES (
                                                                                      JAQNCOD,
                                                                                      JAQNFGE,
                                                                                      JA_PAISOUT,
                                                                                      JA_TIPOOUT,
                                                                                      JA_NUMERODOUT,
                                                                                      JA_NOMBREOUT,
                                                                                      JA_CELULAR1OUT,
                                                                                      JA_CELULAR2OUT,
                                                                                      JA_CELULAR3OUT,
                                                                                      JA_MAILOUT,
                                                                                      JA_MAILOUT1,
                                                                                      JA_MAILOUT2,
                                                                                      JA_DIRECCIONOUT);
                                                                            commit;
                                                                            
                                                                            
                                                                            JA_MAILOUT :=null;   
                                                                            JA_MAILOUT1 :=null;   
                                                                            JA_MAILOUT2 :=null;  
                                                                            JA_CELULAR1OUT :=null;
                                                                            JA_CELULAR2OUT :=null;
                                                                            JA_CELULAR3OUT :=null;
                                                                END LOOP;--FSD002
                                                                
                                                                
                                                                
                                                                
                                                  WHEN TIPO_PERSONA = 'A' then
                                                                FOR pg IN (
                                                                    SELECT  k.PENOM
                                                                    into aPenom
                                                                    from fsd001 k
                                                                    where k.Pepais=pd.PEPAIS
                                                                    and k.Petdoc=pd.PETDOC
                                                                    and k.Pendoc=pd.PENDOC
                                                                    and k.Pendoc NOT IN (
                                                                            (SELECT JAQN451NDO
                                                                             FROM JAQN451
                                                                             WHERE JAQN451COD=JAQNCOD
                                                                             AND JAQN451FGE=JAQNFGE
                                                                              )
                                                                      )
                                                                    
                                                                )LOOP
                                                                      JA_PAISOUT := pd.PEPAIS;
                                                                      JA_TIPOOUT := pd.PETDOC;
                                                                      JA_NUMERODOUT := pd.PENDOC;
                                                                      JA_NOMBREOUT := pg.PENOM;
                                                                      countn:=0;
                                                                      counte:=0;
                                                                      FOR ph IN (
                                                                              SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                              into  ddotelfp,
                                                                                    ddocod,
                                                                                    ddoorp,
                                                                                    nueve
                                                                              from fsr005 d
                                                                              where d.PEPAIS=pd.PEPAIS
                                                                              and d.PETDOC=pd.PETDOC
                                                                              and d.PENDOC=pd.PENDOC
                                                                              ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                    )LOOP
                                                                              largo := length(ph.DOTELFP);
                                                                              largocel := 9;
                                                                              emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                              if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                  if countn=0 then
                                                                                    JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP  then
                                                                                    JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP  and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                    JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  countn := countn + 1;
                                                                              end if;
                                                                     END LOOP;--FSR005
                                                                     
                                                                     FOR pi IN (
                                                                      SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                      into  email
                                                                      from FSX001 e
                                                                      where e.PEPAIS=pd.PEPAIS
                                                                      and e.PETDOC=pd.PETDOC
                                                                      and e.PENDOC=pd.PENDOC
                                                                      and e.TXCOD=0
                                                                      and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                      and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                            (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                       FROM JAQN454)
                                                                            )
                                                                      ORDER BY PEXREN DESC
                                                                      )LOOP
                                                                              if counte<3 then
                                                                                  if counte=0 then
                                                                                    JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=1 then
                                                                                    JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=2 then
                                                                                    JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  counte := counte + 1;
                                                                              end if; 
                                                                      END LOOP;--FSX001
                                                                      
                                                                      
                                                                      
                                                                      FOR pj IN (
                                                                              SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                              into  
                                                                              SNGC13ppais,
                                                                              SNGC13petdoc,
                                                                              SNGC13pendoc,
                                                                              sDocod,
                                                                                    ssngc13Dir,
                                                                                    ssngc13RDes
                                                                              from SNGC13 f
                                                                              where f.sngc13Pais=pd.PEPAIS
                                                                              and f.sngc13Tdoc=pd.PETDOC
                                                                              and f.sngc13Ndoc=pd.PENDOC
                                                                              and f.SNGC13EST='H'
                                                                              order by sngc13RDes asc 
                                                                      )LOOP
                                                                                JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                      END LOOP;--SNGC13
                                                                      --DBMS_OUTPUT.PUT_LINE ('AMBAS: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                      INSERT INTO JAQN451 (
                                                                                      JAQN451COD,
                                                                                      JAQN451FGE,
                                                                                      JAQN451PAI,
                                                                                      JAQN451TDO,
                                                                                      JAQN451NDO,
                                                                                      JAQN451APE,
                                                                                      JAQN451CE1,
                                                                                      JAQN451CE2,
                                                                                      JAQN451CE3,
                                                                                      JAQN451CO1,
                                                                                      JAQN451CO2,
                                                                                      JAQN451CO3,
                                                                                      JAQN451DIR)
                                                                            VALUES (
                                                                                      JAQNCOD,
                                                                                      JAQNFGE,
                                                                                      JA_PAISOUT,
                                                                                      JA_TIPOOUT,
                                                                                      JA_NUMERODOUT,
                                                                                      JA_NOMBREOUT,
                                                                                      JA_CELULAR1OUT,
                                                                                      JA_CELULAR2OUT,
                                                                                      JA_CELULAR3OUT,
                                                                                      JA_MAILOUT,
                                                                                      JA_MAILOUT1,
                                                                                      JA_MAILOUT2,
                                                                                      JA_DIRECCIONOUT);
                                                                            commit;
                                                                            
                                                                            JA_MAILOUT :=null;   
                                                                            JA_MAILOUT1 :=null;   
                                                                            JA_MAILOUT2 :=null;  
                                                                            JA_CELULAR1OUT :=null;
                                                                            JA_CELULAR2OUT :=null;
                                                                            JA_CELULAR3OUT :=null;
                                                                END LOOP;--FSD002
                                                            
                                                            END CASE;
                                                    END LOOP;
                                            ---SIN ESTADO
                                        
                                          END CASE;
                                  
                                  END LOOP;
                              END LOOP;
                        END IF;--MONEDA
                      
                      
                      
                      IF JA_MONEDA ='A' THEN     
                      --DBMS_OUTPUT.PUT_LINE ('MONEDAAAAAAAAA AA:');
                                      FOR i IN 1..cant LOOP
                                        tope:=REGEXP_SUBSTR(modval, '[^;]+', 1,i );
                                        --DBMS_OUTPUT.PUT_LINE ('AMBAS MONEDAS  '||tope);
                                        FOR ad IN (
                                                  SELECT a.PGCOD, a.SCCTA,a.SCSTAT,a.SCMOD,a.SCTOPE,a.SCMDA,a.SCSUC,a.SCPAP,a.SCOPER,a.SCSBOP,a.SCSDO 
                                                  into apgcod,
                                                       accta,
                                                       ascstat,
                                                       ascmod,
                                                       asctope,
                                                       ascmda,
                                                       ascsuc,
                                                       ascpap,
                                                       ascoper,
                                                       ascsbop,
                                                       ascsdo
                                                  from fsd011 a
                                                  where a.SCMOD =21
                                                  and a.SCMDA  in (0,101) 
                                                  and a.SCFVAL >= JA_FECHA_APERTURA
                                                  and a.SCFVAL <= JA_FECHA_CIERRE
                                                  and a.SCCTA  >=  JA_CDESDE
                                                  and a.SCCTA  <=  JA_CHASTA
                                                  and a.SCTOPE = tope
                                                  --and ROWNUM <= 500
                                        )
                                        LOOP
                                            --DBMS_OUTPUT.PUT_LINE ('CUENTA: '|| ad.SCCTA ||'-'||ad.SCMDA);
                                            CASE 
                                                WHEN JA_ESTADO='A' then
                                                    IF ad.SCSTAT <>99 and ad.SCSTAT<>81 THEN
                                                          FOR pd IN (
                                                              SELECT b.PEPAIS,b.PETDOC, b.PENDOC 
                                                              into  appais,
                                                                    apetdoc,
                                                                    apendoc
                                                              from fsr008 b
                                                              where b.PGCOD=ad.PGCOD
                                                              and b.CTNRO=ad.SCCTA
                                                              and b.TTCOD='1')
                                                          LOOP
                                                            INSERT INTO JAQN452 (
                                                                JAQN452COD,
                                                                JAQN452PAI,
                                                                JAQN452TDO,
                                                                JAQN452NDO,
                                                                JAQN452EMP,--EMPRESA
                                                                JAQN452MOD,--MODULO
                                                                JAQN452SUC,--SUCURSAL
                                                                JAQN452MDA,--MONEDA
                                                                JAQN452PAP,--PAPEL
                                                                JAQN452CTA,--CUENTA
                                                                JAQN452OPE,--OPERACION
                                                                JAQN452SBO,--SUB TIPO DE OPERACION
                                                                JAQN452TOP)--TIPO DE OPERACION
                                                          VALUES (  JAQNCOD,
                                                                      pd.PEPAIS,
                                                                      pd.PETDOC,
                                                                      pd.PENDOC,
                                                                      ad.PGCOD,--EMPRESA
                                                                      ad.SCMOD,--MODULO
                                                                      ad.SCSUC,--SUCURSAL
                                                                      ad.SCMDA,--MONEDA
                                                                      ad.SCPAP,--PAPEL
                                                                      ad.SCCTA,--CUENTA
                                                                      ad.SCOPER,--OPERACION
                                                                      ad.SCSBOP,--SUB TIPO DE OPERACION
                                                                      ad.SCTOPE
                                                                      );
                                                          commit;
                                                          
                                                              CASE  
                                                                  WHEN TIPO_PERSONA = 'N' then
                                                                  
                                                                      FOR pn IN (
                                                                      SELECT c.PFPAIS,c.PFTDOC, c.PFNDOC,c.PFAPE1,c.PFAPE2,c.PFNOM1,c.PFNOM2
                                                                      into  nppais,
                                                                            npetdoc,
                                                                            npendoc,
                                                                            nape1,
                                                                            nape2,
                                                                            nnom1,
                                                                            nnom2
                                                                      from fsd002 c
                                                                      where c.PFPAIS=pd.PEPAIS
                                                                      and c.PFTDOC=pd.PETDOC
                                                                      and c.PFNDOC=pd.PENDOC
                                                                      and c.PFNDOC NOT IN (
                                                                              (SELECT JAQN451NDO
                                                                               FROM JAQN451
                                                                               WHERE JAQN451COD=JAQNCOD
                                                                               AND JAQN451FGE=JAQNFGE
                                                                                )
                                                                              )
                                                                      )
                                                                    LOOP
                                                                        JA_PAISOUT := pd.PEPAIS;
                                                                        JA_TIPOOUT := pd.PETDOC;
                                                                        JA_NUMERODOUT := pd.PENDOC;
                                                                        JA_NOMBREOUT := TRIM(pn.PFAPE1)||' '||TRIM(pn.PFAPE2)||' '||TRIM(pn.PFNOM1)||' '||TRIM(pn.PFNOM2);
                                                                        countn:=0;
                                                                        counte:=0;
                                                                        
                                                                            FOR pc IN (
                                                                                  SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                                  into  ddotelfp,
                                                                                        ddocod,
                                                                                        ddoorp,
                                                                                        nueve
                                                                                  from fsr005 d
                                                                                  where d.PEPAIS=pd.PEPAIS
                                                                                  and d.PETDOC=pd.PETDOC
                                                                                  and d.PENDOC=pd.PENDOC
                                                                                  ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                            )LOOP
                                                                                      largo := length(pc.DOTELFP);
                                                                                      largocel := 9;
                                                                                      emp:=SUBSTR(pc.DOTELFP,1,1);
                                                                                      if largo = largocel and emp=9 and pc.CANT<>9 and countn<3 then
                                                                                        if countn=0 then
                                                                                          JA_CELULAR1OUT :=pc.DOTELFP;
                                                                                        end if;
                                                                                        if countn=1 and JA_CELULAR1OUT <> pc.DOTELFP   then
                                                                                          JA_CELULAR2OUT :=pc.DOTELFP;
                                                                                        end if;
                                                                                        if countn=2 and JA_CELULAR1OUT <> pc.DOTELFP  and JA_CELULAR2OUT <> pc.DOTELFP then
                                                                                          JA_CELULAR3OUT :=pc.DOTELFP;
                                                                                        end if;
                                                                                        countn := countn + 1;
                                                                                      end if;         
                                                                             END LOOP;
                                                                             
                                                                             FOR pe IN (
                                                                                  SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                                  into  email
                                                                                  from FSX001 e
                                                                                  where e.PEPAIS=pd.PEPAIS
                                                                                  and e.PETDOC=pd.PETDOC
                                                                                  and e.PENDOC=pd.PENDOC
                                                                                  and e.TXCOD=0
                                                                                  and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                                  and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                                    (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                       FROM JAQN454)
                                                                                    )
                                                                                  ORDER BY PEXREN DESC
                                                                              )LOOP
                                                                                    if counte<3 then
                                                                                        if counte=0 then
                                                                                          JA_MAILOUT :=regexp_substr(pe.PEXTXT,'[^\]*');   
                                                                                        end if;
                                                                                        if counte=1 then
                                                                                          JA_MAILOUT1 :=regexp_substr(pe.PEXTXT,'[^\]*');   
                                                                                        end if;
                                                                                        if counte=2 then
                                                                                          JA_MAILOUT2 :=regexp_substr(pe.PEXTXT,'[^\]*');   
                                                                                        end if;
                                                                                        counte := counte + 1;
                                                                                    end if; 
                
                                                                              END LOOP;
                                                                             
                                                                             FOR ps IN (
                                                                                      SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                      into  
                                                                                      SNGC13ppais,
                                                                                      SNGC13petdoc,
                                                                                      SNGC13pendoc,
                                                                                      sDocod,
                                                                                            ssngc13Dir,
                                                                                            ssngc13RDes
                                                                                      from SNGC13 f
                                                                                      where f.sngc13Pais=pd.PEPAIS
                                                                                      and f.sngc13Tdoc=pd.PETDOC
                                                                                      and f.sngc13Ndoc=pd.PENDOC
                                                                                      and f.SNGC13EST='H'
                                                                                      order by sngc13RDes asc 
                                                                              )LOOP
                                                                                    JA_DIRECCIONOUT := ps.sngc13Dir;
                                                                              END LOOP;
                                                                              
                                                                              --DBMS_OUTPUT.PUT_LINE ('CUENTA: '|| ad.SCCTA );
                                                                              --DBMS_OUTPUT.PUT_LINE ('NATURAL:'||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'||JA_MAILOUT1||'-'||JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                              INSERT INTO JAQN451 (
                                                                                            JAQN451COD,
                                                                                            JAQN451FGE,
                                                                                            JAQN451PAI,
                                                                                            JAQN451TDO,
                                                                                            JAQN451NDO,
                                                                                            JAQN451APE,
                                                                                            JAQN451CE1,
                                                                                            JAQN451CE2,
                                                                                            JAQN451CE3,
                                                                                            JAQN451CO1,
                                                                                            JAQN451CO2,
                                                                                            JAQN451CO3,
                                                                                            JAQN451DIR)
                                                                                  VALUES (
                                                                                            JAQNCOD,
                                                                                            JAQNFGE,
                                                                                            JA_PAISOUT,
                                                                                            JA_TIPOOUT,
                                                                                            JA_NUMERODOUT,
                                                                                            JA_NOMBREOUT,
                                                                                            JA_CELULAR1OUT,
                                                                                            JA_CELULAR2OUT,
                                                                                            JA_CELULAR3OUT,
                                                                                            JA_MAILOUT,
                                                                                            JA_MAILOUT1,
                                                                                            JA_MAILOUT2,
                                                                                            JA_DIRECCIONOUT);
                                                                                  commit;
                                                                                  
                                                                                  JA_MAILOUT :=null;   
                                                                                  JA_MAILOUT1 :=null;   
                                                                                  JA_MAILOUT2 :=null;  
                                                                                  JA_CELULAR1OUT :=null;
                                                                                  JA_CELULAR2OUT :=null;
                                                                                  JA_CELULAR3OUT :=null;
                                                                                --DBMS_OUTPUT.PUT_LINE ('ESTADO A: '||ad.SCSTAT ||'-'||ad.PGCOD||'-' ||ad.SCCTA||'-' ||ad.SCMOD||'-' ||ad.SCTOPE||'-' ||pd.PEPAIS||'-' ||pd.PETDOC||'-' ||pd.PENDOC);
                                                         
                                                                    END LOOP;--FSD001
                                                                  
                                                        WHEN TIPO_PERSONA = 'J' then
                                                                      FOR pg IN (
                                                                          SELECT g.PJRAZS
                                                                          into gPjrazs
                                                                          from fsd003 g
                                                                          where g.Pjpais=pd.PEPAIS
                                                                          and g.Pjtdoc=pd.PETDOC
                                                                          and g.Pjndoc=pd.PENDOC
                                                                          and g.Pjndoc NOT IN (
                                                                              (SELECT JAQN451NDO
                                                                               FROM JAQN451
                                                                               WHERE JAQN451COD=JAQNCOD
                                                                               AND JAQN451FGE=JAQNFGE
                                                                                )
                                                                              )
                                                                      )LOOP
                                                                            JA_PAISOUT := pd.PEPAIS;
                                                                            JA_TIPOOUT := pd.PETDOC;
                                                                            JA_NUMERODOUT := pd.PENDOC;
                                                                            JA_NOMBREOUT := pg.PJRAZS;
                                                                            countn:=0;
                                                                            counte:=0;
                                                                            FOR ph IN (
                                                                                    SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                                    into  ddotelfp,
                                                                                          ddocod,
                                                                                          ddoorp,
                                                                                          nueve
                                                                                    from fsr005 d
                                                                                    where d.PEPAIS=pd.PEPAIS
                                                                                    and d.PETDOC=pd.PETDOC
                                                                                    and d.PENDOC=pd.PENDOC
                                                                                    ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                          )LOOP
                                                                                    largo := length(ph.DOTELFP);
                                                                                    largocel := 9;
                                                                                    emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                                    if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                        if countn=0 then
                                                                                          JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                        end if;
                                                                                        if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP then
                                                                                          JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                        end if;
                                                                                        if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP  and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                          JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                        end if;
                                                                                        countn := countn + 1;
                                                                                    end if;
                                                                           END LOOP;--FSR005
                                                                           
                                                                           FOR pi IN (
                                                                            SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                            into  email
                                                                            from FSX001 e
                                                                            where e.PEPAIS=pd.PEPAIS
                                                                            and e.PETDOC=pd.PETDOC
                                                                            and e.PENDOC=pd.PENDOC
                                                                            and e.TXCOD=0
                                                                            and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                            and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                                    (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                       FROM JAQN454)
                                                                                    )
                                                                            ORDER BY PEXREN DESC
                                                                            )LOOP
                                                                                    if counte<3 then
                                                                                        if counte=0 then
                                                                                          JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                        end if;
                                                                                        if counte=1 then
                                                                                          JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                        end if;
                                                                                        if counte=2 then
                                                                                          JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                        end if;
                                                                                        counte := counte + 1;
                                                                                    end if; 
                                                                            END LOOP;--FSX001
                                                                            
                                                                            
                                                                            
                                                                            FOR pj IN (
                                                                                    SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                    into  
                                                                                    SNGC13ppais,
                                                                                    SNGC13petdoc,
                                                                                    SNGC13pendoc,
                                                                                    sDocod,
                                                                                          ssngc13Dir,
                                                                                          ssngc13RDes
                                                                                    from SNGC13 f
                                                                                    where f.sngc13Pais=pd.PEPAIS
                                                                                    and f.sngc13Tdoc=pd.PETDOC
                                                                                    and f.sngc13Ndoc=pd.PENDOC
                                                                                    and f.SNGC13EST='H'
                                                                                    order by sngc13RDes asc 
                                                                            )LOOP
                                                                                      JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                            END LOOP;--SNGC13
                                                                            --DBMS_OUTPUT.PUT_LINE ('JURIDICA: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                            INSERT INTO JAQN451 (
                                                                                            JAQN451COD,
                                                                                            JAQN451FGE,
                                                                                            JAQN451PAI,
                                                                                            JAQN451TDO,
                                                                                            JAQN451NDO,
                                                                                            JAQN451APE,
                                                                                            JAQN451CE1,
                                                                                            JAQN451CE2,
                                                                                            JAQN451CE3,
                                                                                            JAQN451CO1,
                                                                                            JAQN451CO2,
                                                                                            JAQN451CO3,
                                                                                            JAQN451DIR)
                                                                                  VALUES (
                                                                                            JAQNCOD,
                                                                                            JAQNFGE,
                                                                                            JA_PAISOUT,
                                                                                            JA_TIPOOUT,
                                                                                            JA_NUMERODOUT,
                                                                                            JA_NOMBREOUT,
                                                                                            JA_CELULAR1OUT,
                                                                                            JA_CELULAR2OUT,
                                                                                            JA_CELULAR3OUT,
                                                                                            JA_MAILOUT,
                                                                                            JA_MAILOUT1,
                                                                                            JA_MAILOUT2,
                                                                                            JA_DIRECCIONOUT);
                                                                                  commit;
                                                                                  
                                                                          
                                                                                  JA_MAILOUT :=null;   
                                                                                  JA_MAILOUT1 :=null;   
                                                                                  JA_MAILOUT2 :=null;  
                                                                                  JA_CELULAR1OUT :=null;
                                                                                  JA_CELULAR2OUT :=null;
                                                                                  JA_CELULAR3OUT :=null;
                                                                      END LOOP;--FSD002
                                                                      
                                                                      
                                                                      
                                                                      
                                                        WHEN TIPO_PERSONA = 'A' then
                                                                      FOR pg IN (
                                                                          SELECT k.PENOM
                                                                          into aPenom
                                                                          from fsd001 k
                                                                          where k.Pepais=pd.PEPAIS
                                                                          and k.Petdoc=pd.PETDOC
                                                                          and k.Pendoc=pd.PENDOC
                                                                          and k.Pendoc NOT IN (
                                                                              (SELECT JAQN451NDO
                                                                               FROM JAQN451
                                                                               WHERE JAQN451COD=JAQNCOD
                                                                               AND JAQN451FGE=JAQNFGE
                                                                                )
                                                                              )
                                                                      )LOOP
                                                                            JA_PAISOUT := pd.PEPAIS;
                                                                            JA_TIPOOUT := pd.PETDOC;
                                                                            JA_NUMERODOUT := pd.PENDOC;
                                                                            JA_NOMBREOUT := pg.PENOM;
                                                                            countn:=0;
                                                                            counte:=0;
                                                                            FOR ph IN (
                                                                                    SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                                    into  ddotelfp,
                                                                                          ddocod,
                                                                                          ddoorp,
                                                                                          nueve
                                                                                    from fsr005 d
                                                                                    where d.PEPAIS=pd.PEPAIS
                                                                                    and d.PETDOC=pd.PETDOC
                                                                                    and d.PENDOC=pd.PENDOC
                                                                                    ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                          )LOOP
                                                                                    largo := length(ph.DOTELFP);
                                                                                    largocel := 9;
                                                                                    emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                                    if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                        if countn=0 then
                                                                                          JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                        end if;
                                                                                        if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP  then
                                                                                          JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                        end if;
                                                                                        if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP  and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                          JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                        end if;
                                                                                        countn := countn + 1;
                                                                                    end if;
                                                                           END LOOP;--FSR005
                                                                           
                                                                           FOR pi IN (
                                                                            SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                            into  email
                                                                            from FSX001 e
                                                                            where e.PEPAIS=pd.PEPAIS
                                                                            and e.PETDOC=pd.PETDOC
                                                                            and e.PENDOC=pd.PENDOC
                                                                            and e.TXCOD=0
                                                                            and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                            and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                                    (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                       FROM JAQN454)
                                                                                    )
                                                                            ORDER BY PEXREN DESC
                                                                            )LOOP
                                                                                    if counte<3 then
                                                                                        if counte=0 then
                                                                                          JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                        end if;
                                                                                        if counte=1 then
                                                                                          JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                        end if;
                                                                                        if counte=2 then
                                                                                          JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                        end if;
                                                                                        counte := counte + 1;
                                                                                    end if; 
                                                                            END LOOP;--FSX001
                                                                            
                                                                            
                                                                            
                                                                            FOR pj IN (
                                                                                    SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                    into  
                                                                                    SNGC13ppais,
                                                                                    SNGC13petdoc,
                                                                                    SNGC13pendoc,
                                                                                    sDocod,
                                                                                          ssngc13Dir,
                                                                                          ssngc13RDes
                                                                                    from SNGC13 f
                                                                                    where f.sngc13Pais=pd.PEPAIS
                                                                                    and f.sngc13Tdoc=pd.PETDOC
                                                                                    and f.sngc13Ndoc=pd.PENDOC
                                                                                    and f.SNGC13EST='H'
                                                                                    order by sngc13RDes asc 
                                                                            )LOOP
                                                                                      JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                            END LOOP;--SNGC13
                                                                            --DBMS_OUTPUT.PUT_LINE ('AMBAS: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                            INSERT INTO JAQN451 (
                                                                                            JAQN451COD,
                                                                                            JAQN451FGE,
                                                                                            JAQN451PAI,
                                                                                            JAQN451TDO,
                                                                                            JAQN451NDO,
                                                                                            JAQN451APE,
                                                                                            JAQN451CE1,
                                                                                            JAQN451CE2,
                                                                                            JAQN451CE3,
                                                                                            JAQN451CO1,
                                                                                            JAQN451CO2,
                                                                                            JAQN451CO3,
                                                                                            JAQN451DIR)
                                                                                  VALUES (
                                                                                            JAQNCOD,
                                                                                            JAQNFGE,
                                                                                            JA_PAISOUT,
                                                                                            JA_TIPOOUT,
                                                                                            JA_NUMERODOUT,
                                                                                            JA_NOMBREOUT,
                                                                                            JA_CELULAR1OUT,
                                                                                            JA_CELULAR2OUT,
                                                                                            JA_CELULAR3OUT,
                                                                                            JA_MAILOUT,
                                                                                            JA_MAILOUT1,
                                                                                            JA_MAILOUT2,
                                                                                            JA_DIRECCIONOUT);
                                                                                  commit;
                                                                                 
                                                                                  JA_MAILOUT :=null;   
                                                                                  JA_MAILOUT1 :=null;   
                                                                                  JA_MAILOUT2 :=null;  
                                                                                  JA_CELULAR1OUT :=null;
                                                                                  JA_CELULAR2OUT :=null;
                                                                                  JA_CELULAR3OUT :=null;
                                                                      END LOOP;--FSD002
                                                                  
                                                                  END CASE;
                                                          END LOOP;
                
                                                    END IF;
                                                    
                                                    
                                                WHEN JA_ESTADO='I' then
                                                    IF ad.SCSTAT =81 THEN
                                                      --DBMS_OUTPUT.PUT_LINE ('ESTADO I: '||ad.SCSTAT ||'-'||ad.PGCOD||'-' ||ad.SCCTA||'-' ||ad.SCMOD||'-' ||ad.SCTOPE);
                                                             
                                                                    FOR pd IN (
                                                                        SELECT b.PEPAIS,b.PETDOC, b.PENDOC 
                                                                        into  appais,
                                                                              apetdoc,
                                                                              apendoc
                                                                        from fsr008 b
                                                                        where b.PGCOD=ad.PGCOD
                                                                        and b.CTNRO=ad.SCCTA
                                                                        and b.TTCOD='1')
                                                                    LOOP
                                                                    INSERT INTO JAQN452 (
                                                                                JAQN452COD,
                                                                                JAQN452PAI,
                                                                                JAQN452TDO,
                                                                                JAQN452NDO,
                                                                                JAQN452EMP,--EMPRESA
                                                                                JAQN452MOD,--MODULO
                                                                                JAQN452SUC,--SUCURSAL
                                                                                JAQN452MDA,--MONEDA
                                                                                JAQN452PAP,--PAPEL
                                                                                JAQN452CTA,--CUENTA
                                                                                JAQN452OPE,--OPERACION
                                                                                JAQN452SBO,--SUB TIPO DE OPERACION
                                                                                JAQN452TOP)--TIPO DE OPERACION
                                                                    VALUES (  JAQNCOD,
                                                                                pd.PEPAIS,
                                                                                pd.PETDOC,
                                                                                pd.PENDOC,
                                                                                ad.PGCOD,--EMPRESA
                                                                                ad.SCMOD,--MODULO
                                                                                ad.SCSUC,--SUCURSAL
                                                                                ad.SCMDA,--MONEDA
                                                                                ad.SCPAP,--PAPEL
                                                                                ad.SCCTA,--CUENTA
                                                                                ad.SCOPER,--OPERACION
                                                                                ad.SCSBOP,--SUB TIPO DE OPERACION
                                                                                ad.SCTOPE
                                                                                );
                                                                    commit;
                                                                    
                                                                        CASE  
                                                                            WHEN TIPO_PERSONA = 'N' then
                                                                            
                                                                                FOR pn IN (
                                                                                SELECT c.PFPAIS,c.PFTDOC, c.PFNDOC,c.PFAPE1,c.PFAPE2,c.PFNOM1,c.PFNOM2
                                                                                into  nppais,
                                                                                      npetdoc,
                                                                                      npendoc,
                                                                                      nape1,
                                                                                      nape2,
                                                                                      nnom1,
                                                                                      nnom2
                                                                                from fsd002 c
                                                                                where c.PFPAIS=pd.PEPAIS
                                                                                and c.PFTDOC=pd.PETDOC
                                                                                and c.PFNDOC=pd.PENDOC
                                                                                 and c.PFNDOC NOT IN (
                                                                                  (SELECT JAQN451NDO
                                                                                   FROM JAQN451
                                                                                   WHERE JAQN451COD=JAQNCOD
                                                                                   AND JAQN451FGE=JAQNFGE
                                                                                    )
                                                                                  )
                                                                                )
                                                                              LOOP
                                                                                  JA_PAISOUT := pd.PEPAIS;
                                                                                  JA_TIPOOUT := pd.PETDOC;
                                                                                  JA_NUMERODOUT := pd.PENDOC;
                                                                                  JA_NOMBREOUT := TRIM(pn.PFAPE1)||' '||TRIM(pn.PFAPE2)||' '||TRIM(pn.PFNOM1)||' '||TRIM(pn.PFNOM2);
                                                                                  countn:=0;
                                                                                  counte:=0;
                                                                                  
                                                                                      FOR pc IN (
                                                                                            SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                                            into  ddotelfp,
                                                                                                  ddocod,
                                                                                                  ddoorp,
                                                                                                  nueve
                                                                                            from fsr005 d
                                                                                            where d.PEPAIS=pd.PEPAIS
                                                                                            and d.PETDOC=pd.PETDOC
                                                                                            and d.PENDOC=pd.PENDOC
                                                                                            ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                                      )LOOP
                                                                                                largo := length(pc.DOTELFP);
                                                                                                largocel := 9;
                                                                                                emp:=SUBSTR(pc.DOTELFP,1,1);
                                                                                                if largo = largocel and emp=9 and pc.CANT<>9 and countn<3 then
                                                                                                  if countn=0 then
                                                                                                    JA_CELULAR1OUT :=pc.DOTELFP;
                                                                                                  end if;
                                                                                                  if countn=1 and JA_CELULAR1OUT <> pc.DOTELFP  then
                                                                                                    JA_CELULAR2OUT :=pc.DOTELFP;
                                                                                                  end if;
                                                                                                  if countn=2 and JA_CELULAR1OUT <> pc.DOTELFP  and JA_CELULAR2OUT <> pc.DOTELFP then
                                                                                                    JA_CELULAR3OUT :=pc.DOTELFP;
                                                                                                  end if;
                                                                                                  countn := countn + 1;
                                                                                                end if;         
                                                                                       END LOOP;
                                                                                       
                                                                                       FOR pe IN (
                                                                                            SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                                            into  email
                                                                                            from FSX001 e
                                                                                            where e.PEPAIS=pd.PEPAIS
                                                                                            and e.PETDOC=pd.PETDOC
                                                                                            and e.PENDOC=pd.PENDOC
                                                                                            and e.TXCOD=0
                                                                                            and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                                            and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                                            (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                               FROM JAQN454)
                                                                                            )
                                                                                            ORDER BY PEXREN DESC
                                                                                        )LOOP
                                                                                              if counte<3 then
                                                                                                  if counte=0 then
                                                                                                    JA_MAILOUT :=regexp_substr(pe.PEXTXT,'[^\]*');   
                                                                                                  end if;
                                                                                                  if counte=1 then
                                                                                                    JA_MAILOUT1 :=regexp_substr(pe.PEXTXT,'[^\]*');   
                                                                                                  end if;
                                                                                                  if counte=2 then
                                                                                                    JA_MAILOUT2 :=regexp_substr(pe.PEXTXT,'[^\]*');   
                                                                                                  end if;
                                                                                                  counte := counte + 1;
                                                                                              end if; 
                          
                                                                                        END LOOP;
                                                                                       
                                                                                       FOR ps IN (
                                                                                                SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                                into  
                                                                                                SNGC13ppais,
                                                                                                SNGC13petdoc,
                                                                                                SNGC13pendoc,
                                                                                                sDocod,
                                                                                                      ssngc13Dir,
                                                                                                      ssngc13RDes
                                                                                                from SNGC13 f
                                                                                                where f.sngc13Pais=pd.PEPAIS
                                                                                                and f.sngc13Tdoc=pd.PETDOC
                                                                                                and f.sngc13Ndoc=pd.PENDOC
                                                                                                and f.SNGC13EST='H'
                                                                                                order by sngc13RDes asc 
                                                                                        )LOOP
                                                                                              JA_DIRECCIONOUT := ps.sngc13Dir;
                                                                                        END LOOP;
                                                                                        
                                                                                        --DBMS_OUTPUT.PUT_LINE ('CUENTA: '|| ad.SCCTA );
                                                                                        --DBMS_OUTPUT.PUT_LINE ('NATURAL:'||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'||JA_MAILOUT1||'-'||JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                                        INSERT INTO JAQN451 (
                                                                                                      JAQN451COD,
                                                                                                      JAQN451FGE,
                                                                                                      JAQN451PAI,
                                                                                                      JAQN451TDO,
                                                                                                      JAQN451NDO,
                                                                                                      JAQN451APE,
                                                                                                      JAQN451CE1,
                                                                                                      JAQN451CE2,
                                                                                                      JAQN451CE3,
                                                                                                      JAQN451CO1,
                                                                                                      JAQN451CO2,
                                                                                                      JAQN451CO3,
                                                                                                      JAQN451DIR)
                                                                                            VALUES (
                                                                                                      JAQNCOD,
                                                                                                      JAQNFGE,
                                                                                                      JA_PAISOUT,
                                                                                                      JA_TIPOOUT,
                                                                                                      JA_NUMERODOUT,
                                                                                                      JA_NOMBREOUT,
                                                                                                      JA_CELULAR1OUT,
                                                                                                      JA_CELULAR2OUT,
                                                                                                      JA_CELULAR3OUT,
                                                                                                      JA_MAILOUT,
                                                                                                      JA_MAILOUT1,
                                                                                                      JA_MAILOUT2,
                                                                                                      JA_DIRECCIONOUT);
                                                                                            commit;
                                                                                            
                                                                                            JA_MAILOUT :=null;   
                                                                                            JA_MAILOUT1 :=null;   
                                                                                            JA_MAILOUT2 :=null;  
                                                                                            JA_CELULAR1OUT :=null;
                                                                                            JA_CELULAR2OUT :=null;
                                                                                            JA_CELULAR3OUT :=null;
                                                                                          --DBMS_OUTPUT.PUT_LINE ('ESTADO A: '||ad.SCSTAT ||'-'||ad.PGCOD||'-' ||ad.SCCTA||'-' ||ad.SCMOD||'-' ||ad.SCTOPE||'-' ||pd.PEPAIS||'-' ||pd.PETDOC||'-' ||pd.PENDOC);
                                                                   
                                                                              END LOOP;--FSD001
                                                                            
                                                                  WHEN TIPO_PERSONA = 'J' then
                                                                                FOR pg IN (
                                                                                    SELECT g.PJRAZS
                                                                                    into gPjrazs
                                                                                    from fsd003 g
                                                                                    where g.Pjpais=pd.PEPAIS
                                                                                    and g.Pjtdoc=pd.PETDOC
                                                                                    and g.Pjndoc=pd.PENDOC
                                                                                    and g.Pjndoc NOT IN (
                                                                                    (SELECT JAQN451NDO
                                                                                     FROM JAQN451
                                                                                     WHERE JAQN451COD=JAQNCOD
                                                                                     AND JAQN451FGE=JAQNFGE
                                                                                      )
                                                                                    )
                                                                                )LOOP
                                                                                      JA_PAISOUT := pd.PEPAIS;
                                                                                      JA_TIPOOUT := pd.PETDOC;
                                                                                      JA_NUMERODOUT := pd.PENDOC;
                                                                                      JA_NOMBREOUT := pg.PJRAZS;
                                                                                      countn:=0;
                                                                                      counte:=0;
                                                                                      FOR ph IN (
                                                                                              SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                                              into  ddotelfp,
                                                                                                    ddocod,
                                                                                                    ddoorp,
                                                                                                    nueve
                                                                                              from fsr005 d
                                                                                              where d.PEPAIS=pd.PEPAIS
                                                                                              and d.PETDOC=pd.PETDOC
                                                                                              and d.PENDOC=pd.PENDOC
                                                                                              ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                                    )LOOP
                                                                                              largo := length(ph.DOTELFP);
                                                                                              largocel := 9;
                                                                                              emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                                              if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                                  if countn=0 then
                                                                                                    JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                                  end if;
                                                                                                  if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP   then
                                                                                                    JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                                  end if;
                                                                                                  if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP  and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                                    JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                                  end if;
                                                                                                  countn := countn + 1;
                                                                                              end if;
                                                                                     END LOOP;--FSR005
                                                                                     
                                                                                     FOR pi IN (
                                                                                      SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                                      into  email
                                                                                      from FSX001 e
                                                                                      where e.PEPAIS=pd.PEPAIS
                                                                                      and e.PETDOC=pd.PETDOC
                                                                                      and e.PENDOC=pd.PENDOC
                                                                                      and e.TXCOD=0
                                                                                      and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                                      and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                                        (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                               FROM JAQN454)
                                                                                            )
                                                                                      ORDER BY PEXREN DESC
                                                                                      )LOOP
                                                                                              if counte<3 then
                                                                                                  if counte=0 then
                                                                                                    JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                                  end if;
                                                                                                  if counte=1 then
                                                                                                    JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                                  end if;
                                                                                                  if counte=2 then
                                                                                                    JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                                  end if;
                                                                                                  counte := counte + 1;
                                                                                              end if; 
                                                                                      END LOOP;--FSX001
                                                                                      
                                                                                      
                                                                                      
                                                                                      FOR pj IN (
                                                                                              SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                              into  
                                                                                              SNGC13ppais,
                                                                                              SNGC13petdoc,
                                                                                              SNGC13pendoc,
                                                                                              sDocod,
                                                                                                    ssngc13Dir,
                                                                                                    ssngc13RDes
                                                                                              from SNGC13 f
                                                                                              where f.sngc13Pais=pd.PEPAIS
                                                                                              and f.sngc13Tdoc=pd.PETDOC
                                                                                              and f.sngc13Ndoc=pd.PENDOC
                                                                                              and f.SNGC13EST='H'
                                                                                              order by sngc13RDes asc 
                                                                                      )LOOP
                                                                                                JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                                      END LOOP;--SNGC13
                                                                                      --DBMS_OUTPUT.PUT_LINE ('JURIDICA: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                                      INSERT INTO JAQN451 (
                                                                                                      JAQN451COD,
                                                                                                      JAQN451FGE,
                                                                                                      JAQN451PAI,
                                                                                                      JAQN451TDO,
                                                                                                      JAQN451NDO,
                                                                                                      JAQN451APE,
                                                                                                      JAQN451CE1,
                                                                                                      JAQN451CE2,
                                                                                                      JAQN451CE3,
                                                                                                      JAQN451CO1,
                                                                                                      JAQN451CO2,
                                                                                                      JAQN451CO3,
                                                                                                      JAQN451DIR)
                                                                                            VALUES (
                                                                                                      JAQNCOD,
                                                                                                      JAQNFGE,
                                                                                                      JA_PAISOUT,
                                                                                                      JA_TIPOOUT,
                                                                                                      JA_NUMERODOUT,
                                                                                                      JA_NOMBREOUT,
                                                                                                      JA_CELULAR1OUT,
                                                                                                      JA_CELULAR2OUT,
                                                                                                      JA_CELULAR3OUT,
                                                                                                      JA_MAILOUT,
                                                                                                      JA_MAILOUT1,
                                                                                                      JA_MAILOUT2,
                                                                                                      JA_DIRECCIONOUT);
                                                                                            commit;
                                                                                            
                                                                                            
                                                                                            JA_MAILOUT :=null;   
                                                                                            JA_MAILOUT1 :=null;   
                                                                                            JA_MAILOUT2 :=null;  
                                                                                            JA_CELULAR1OUT :=null;
                                                                                            JA_CELULAR2OUT :=null;
                                                                                            JA_CELULAR3OUT :=null;
                                                                                END LOOP;--FSD002
                                                                                
                                                                                
                                                                                
                                                                                
                                                                  WHEN TIPO_PERSONA = 'A' then
                                                                                FOR pg IN (
                                                                                    SELECT k.PENOM
                                                                                    into aPenom
                                                                                    from fsd001 k
                                                                                    where k.Pepais=pd.PEPAIS
                                                                                    and k.Petdoc=pd.PETDOC
                                                                                    and k.Pendoc=pd.PENDOC
                                                                                    and k.Pendoc NOT IN (
                                                                                    (SELECT JAQN451NDO
                                                                                     FROM JAQN451
                                                                                     WHERE JAQN451COD=JAQNCOD
                                                                                     AND JAQN451FGE=JAQNFGE
                                                                                      )
                                                                                    )
                                                                                )LOOP
                                                                                      JA_PAISOUT := pd.PEPAIS;
                                                                                      JA_TIPOOUT := pd.PETDOC;
                                                                                      JA_NUMERODOUT := pd.PENDOC;
                                                                                      JA_NOMBREOUT := pg.PENOM;
                                                                                      countn:=0;
                                                                                      counte:=0;
                                                                                      FOR ph IN (
                                                                                              SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                                              into  ddotelfp,
                                                                                                    ddocod,
                                                                                                    ddoorp,
                                                                                                    nueve
                                                                                              from fsr005 d
                                                                                              where d.PEPAIS=pd.PEPAIS
                                                                                              and d.PETDOC=pd.PETDOC
                                                                                              and d.PENDOC=pd.PENDOC
                                                                                              ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                                    )LOOP
                                                                                              largo := length(ph.DOTELFP);
                                                                                              largocel := 9;
                                                                                              emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                                              if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                                  if countn=0 then
                                                                                                    JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                                  end if;
                                                                                                  if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP  then
                                                                                                    JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                                  end if;
                                                                                                  if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP  and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                                    JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                                  end if;
                                                                                                  countn := countn + 1;
                                                                                              end if;
                                                                                     END LOOP;--FSR005
                                                                                     
                                                                                     FOR pi IN (
                                                                                      SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                                      into  email
                                                                                      from FSX001 e
                                                                                      where e.PEPAIS=pd.PEPAIS
                                                                                      and e.PETDOC=pd.PETDOC
                                                                                      and e.PENDOC=pd.PENDOC
                                                                                      and e.TXCOD=0
                                                                                      and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                                      and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                                      (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                               FROM JAQN454)
                                                                                            )
                                                                                      ORDER BY PEXREN DESC
                                                                                      )LOOP
                                                                                              if counte<3 then
                                                                                                  if counte=0 then
                                                                                                    JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                                  end if;
                                                                                                  if counte=1 then
                                                                                                    JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                                  end if;
                                                                                                  if counte=2 then
                                                                                                    JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                                  end if;
                                                                                                  counte := counte + 1;
                                                                                              end if; 
                                                                                      END LOOP;--FSX001
                                                                                      
                                                                                      
                                                                                      
                                                                                      FOR pj IN (
                                                                                              SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                              into  
                                                                                              SNGC13ppais,
                                                                                              SNGC13petdoc,
                                                                                              SNGC13pendoc,
                                                                                              sDocod,
                                                                                                    ssngc13Dir,
                                                                                                    ssngc13RDes
                                                                                              from SNGC13 f
                                                                                              where f.sngc13Pais=pd.PEPAIS
                                                                                              and f.sngc13Tdoc=pd.PETDOC
                                                                                              and f.sngc13Ndoc=pd.PENDOC
                                                                                              and f.SNGC13EST='H'
                                                                                              order by sngc13RDes asc 
                                                                                      )LOOP
                                                                                                JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                                      END LOOP;--SNGC13
                                                                                      --DBMS_OUTPUT.PUT_LINE ('AMBAS: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                                      INSERT INTO JAQN451 (
                                                                                                      JAQN451COD,
                                                                                                      JAQN451FGE,
                                                                                                      JAQN451PAI,
                                                                                                      JAQN451TDO,
                                                                                                      JAQN451NDO,
                                                                                                      JAQN451APE,
                                                                                                      JAQN451CE1,
                                                                                                      JAQN451CE2,
                                                                                                      JAQN451CE3,
                                                                                                      JAQN451CO1,
                                                                                                      JAQN451CO2,
                                                                                                      JAQN451CO3,
                                                                                                      JAQN451DIR)
                                                                                            VALUES (
                                                                                                      JAQNCOD,
                                                                                                      JAQNFGE,
                                                                                                      JA_PAISOUT,
                                                                                                      JA_TIPOOUT,
                                                                                                      JA_NUMERODOUT,
                                                                                                      JA_NOMBREOUT,
                                                                                                      JA_CELULAR1OUT,
                                                                                                      JA_CELULAR2OUT,
                                                                                                      JA_CELULAR3OUT,
                                                                                                      JA_MAILOUT,
                                                                                                      JA_MAILOUT1,
                                                                                                      JA_MAILOUT2,
                                                                                                      JA_DIRECCIONOUT);
                                                                                            commit;
                                                                                           
                                                                                            JA_MAILOUT :=null;   
                                                                                            JA_MAILOUT1 :=null;   
                                                                                            JA_MAILOUT2 :=null;  
                                                                                            JA_CELULAR1OUT :=null;
                                                                                            JA_CELULAR2OUT :=null;
                                                                                            JA_CELULAR3OUT :=null;
                                                                                END LOOP;--FSD002
                                                                                
                                                                            END CASE;
                                                                    END LOOP;
                                                          
                                                    END IF; --ESTADO I
                                                    
                                                WHEN JA_ESTADO='T' then
                                                   
                                                    FOR pd IN (
                                                        SELECT b.PEPAIS,b.PETDOC, b.PENDOC 
                                                        into  appais,
                                                              apetdoc,
                                                              apendoc
                                                        from fsr008 b
                                                        where b.PGCOD=ad.PGCOD
                                                        and b.CTNRO=ad.SCCTA
                                                        and b.TTCOD='1')
                                                    LOOP
                                                    
                                                      INSERT INTO JAQN452 (
                                                                JAQN452COD,
                                                                JAQN452PAI,
                                                                JAQN452TDO,
                                                                JAQN452NDO,
                                                                JAQN452EMP,--EMPRESA
                                                                JAQN452MOD,--MODULO
                                                                JAQN452SUC,--SUCURSAL
                                                                JAQN452MDA,--MONEDA
                                                                JAQN452PAP,--PAPEL
                                                                JAQN452CTA,--CUENTA
                                                                JAQN452OPE,--OPERACION
                                                                JAQN452SBO,--SUB TIPO DE OPERACION
                                                                JAQN452TOP)--TIPO DE OPERACION
                                                        VALUES (  JAQNCOD,
                                                                    pd.PEPAIS,
                                                                    pd.PETDOC,
                                                                    pd.PENDOC,
                                                                    ad.PGCOD,--EMPRESA
                                                                    ad.SCMOD,--MODULO
                                                                    ad.SCSUC,--SUCURSAL
                                                                    ad.SCMDA,--MONEDA
                                                                    ad.SCPAP,--PAPEL
                                                                    ad.SCCTA,--CUENTA
                                                                    ad.SCOPER,--OPERACION
                                                                    ad.SCSBOP,--SUB TIPO DE OPERACION
                                                                    ad.SCTOPE
                                                                    );
                                                        commit;
                                                    
                                                        CASE  
                                                            WHEN TIPO_PERSONA = 'N' then
                                                            --DBMS_OUTPUT.PUT_LINE ('N: ');
                                                                FOR pn IN (
                                                                SELECT  c.PFPAIS,c.PFTDOC, c.PFNDOC,c.PFAPE1,c.PFAPE2,c.PFNOM1,c.PFNOM2
                                                                into  nppais,
                                                                      npetdoc,
                                                                      npendoc,
                                                                      nape1,
                                                                      nape2,
                                                                      nnom1,
                                                                      nnom2
                                                                from fsd002 c
                                                                where c.PFPAIS=pd.PEPAIS
                                                                and c.PFTDOC=pd.PETDOC
                                                                and c.PFNDOC=pd.PENDOC
                                                                and c.PFNDOC NOT IN (
                                                                            (SELECT JAQN451NDO
                                                                             FROM JAQN451
                                                                             WHERE JAQN451COD=JAQNCOD
                                                                             AND JAQN451FGE=JAQNFGE
                                                                              )
                                                                 )
                                                                )
                                                              LOOP
                                                                  JA_PAISOUT := pd.PEPAIS;
                                                                  JA_TIPOOUT := pd.PETDOC;
                                                                  JA_NUMERODOUT := pd.PENDOC;
                                                                  JA_NOMBREOUT := TRIM(pn.PFAPE1)||' '||TRIM(pn.PFAPE2)||' '||TRIM(pn.PFNOM1)||' '||TRIM(pn.PFNOM2);
                                                                  countn:=0;
                                                                  counte:=0;
                                                                  
                                                                      FOR pc IN (
                                                                            SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                            into  ddotelfp,
                                                                                  ddocod,
                                                                                  ddoorp,
                                                                                  nueve
                                                                            from fsr005 d
                                                                            where d.PEPAIS=pd.PEPAIS
                                                                            and d.PETDOC=pd.PETDOC
                                                                            and d.PENDOC=pd.PENDOC
                                                                            ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                      )LOOP
                                                                                largo := length(pc.DOTELFP);
                                                                                largocel := 9;
                                                                                emp:=SUBSTR(pc.DOTELFP,1,1);
                                                                                if largo = largocel and emp=9 and pc.CANT<>9 and countn<3 then
                                                                                  if countn=0 then
                                                                                    JA_CELULAR1OUT :=pc.DOTELFP;
                                                                                  end if;
                                                                                  if countn=1 and JA_CELULAR1OUT <> pc.DOTELFP then
                                                                                    JA_CELULAR2OUT :=pc.DOTELFP;
                                                                                  end if;
                                                                                  if countn=2 and JA_CELULAR1OUT <> pc.DOTELFP  and JA_CELULAR2OUT <> pc.DOTELFP then
                                                                                    JA_CELULAR3OUT :=pc.DOTELFP;
                                                                                  end if;
                                                                                  countn := countn + 1;
                                                                                end if;         
                                                                       END LOOP;
                                                                       
                                                                       FOR pe IN (
                                                                            SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                            into  email
                                                                            from FSX001 e
                                                                            where e.PEPAIS=pd.PEPAIS
                                                                            and e.PETDOC=pd.PETDOC
                                                                            and e.PENDOC=pd.PENDOC
                                                                            and e.TXCOD=0
                                                                            and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                            and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                            (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                 FROM JAQN454)
                                                                            )
                                                                            ORDER BY PEXREN DESC
                                                                        )LOOP
                                                                               --DBMS_OUTPUT.PUT_LINE ('EMAIL BAA: A '||regexp_substr(pe.PEXTXT,'[^\]*'));
                                                                          --if regexp_substr(pe.PEXTXT,'[^\]*')<>null OR regexp_substr(pe.PEXTXT,'[^\]*')<>'' then    
                                                                            if counte<3 then
                                                                                  if counte=0 then
                                                                                      JA_MAILOUT :=regexp_substr(pe.PEXTXT,'[^\]*');                    
                                                                                  end if;
                                                                                  if counte=1 then
                                                                                      JA_MAILOUT1 :=regexp_substr(pe.PEXTXT,'[^\]*');  
                                                                                  end if;
                                                                                  if counte=2 then
                                                                                      JA_MAILOUT2 :=regexp_substr(pe.PEXTXT,'[^\]*');
                                                                                  end if;
                                                                                  counte := counte + 1;                      
                                                                            end if;       
                                                                        --end if;            
                                                                        END LOOP;
                                                                       
                                                                       FOR ps IN (
                                                                                SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                into  
                                                                                SNGC13ppais,
                                                                                SNGC13petdoc,
                                                                                SNGC13pendoc,
                                                                                sDocod,
                                                                                      ssngc13Dir,
                                                                                      ssngc13RDes
                                                                                from SNGC13 f
                                                                                where f.sngc13Pais=pd.PEPAIS
                                                                                and f.sngc13Tdoc=pd.PETDOC
                                                                                and f.sngc13Ndoc=pd.PENDOC
                                                                                and f.SNGC13EST='H'
                                                                                order by sngc13RDes asc 
                                                                        )LOOP
                                                                              JA_DIRECCIONOUT := ps.sngc13Dir;
                                                                        END LOOP;
                                                                        
                                                                      --DBMS_OUTPUT.PUT_LINE ('NATURAL:'||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'||JA_MAILOUT1||'-'||JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                      INSERT INTO JAQN451 (
                                                                                      JAQN451COD,
                                                                                      JAQN451FGE,
                                                                                      JAQN451PAI,
                                                                                      JAQN451TDO,
                                                                                      JAQN451NDO,
                                                                                      JAQN451APE,
                                                                                      JAQN451CE1,
                                                                                      JAQN451CE2,
                                                                                      JAQN451CE3,
                                                                                      JAQN451CO1,
                                                                                      JAQN451CO2,
                                                                                      JAQN451CO3,
                                                                                      JAQN451DIR)
                                                                            VALUES (
                                                                                      JAQNCOD,
                                                                                      JAQNFGE,
                                                                                      JA_PAISOUT,
                                                                                      JA_TIPOOUT,
                                                                                      JA_NUMERODOUT,
                                                                                      JA_NOMBREOUT,
                                                                                      JA_CELULAR1OUT,
                                                                                      JA_CELULAR2OUT,
                                                                                      JA_CELULAR3OUT,
                                                                                      JA_MAILOUT,
                                                                                      JA_MAILOUT1,
                                                                                      JA_MAILOUT2,
                                                                                      JA_DIRECCIONOUT);
                                                                            commit;
                                                                            
                                                                            JA_MAILOUT :=null;   
                                                                            JA_MAILOUT1 :=null;   
                                                                            JA_MAILOUT2 :=null;  
                                                                            JA_CELULAR1OUT :=null;
                                                                            JA_CELULAR2OUT :=null;
                                                                            JA_CELULAR3OUT :=null;
                                                                          --DBMS_OUTPUT.PUT_LINE ('ESTADO A: '||ad.SCSTAT ||'-'||ad.PGCOD||'-' ||ad.SCCTA||'-' ||ad.SCMOD||'-' ||ad.SCTOPE||'-' ||pd.PEPAIS||'-' ||pd.PETDOC||'-' ||pd.PENDOC);
                                                   
                                                              END LOOP;--FSD001
                                                            
                                                  WHEN TIPO_PERSONA = 'J' then
                                                                FOR pg IN (
                                                                    SELECT  g.PJRAZS
                                                                    into gPjrazs
                                                                    from fsd003 g
                                                                    where g.Pjpais=pd.PEPAIS
                                                                    and g.Pjtdoc=pd.PETDOC
                                                                    and g.Pjndoc=pd.PENDOC
                                                                    and g.Pjndoc NOT IN (
                                                                            (SELECT JAQN451NDO
                                                                             FROM JAQN451
                                                                             WHERE JAQN451COD=JAQNCOD
                                                                             AND JAQN451FGE=JAQNFGE
                                                                              )
                                                                 )
                                                                )LOOP
                                                                      JA_PAISOUT := pd.PEPAIS;
                                                                      JA_TIPOOUT := pd.PETDOC;
                                                                      JA_NUMERODOUT := pd.PENDOC;
                                                                      JA_NOMBREOUT := pg.PJRAZS;
                                                                      countn:=0;
                                                                      counte:=0;
                                                                      FOR ph IN (
                                                                              SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                              into  ddotelfp,
                                                                                    ddocod,
                                                                                    ddoorp,
                                                                                    nueve
                                                                              from fsr005 d
                                                                              where d.PEPAIS=pd.PEPAIS
                                                                              and d.PETDOC=pd.PETDOC
                                                                              and d.PENDOC=pd.PENDOC
                                                                              ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                    )LOOP
                                                                              largo := length(ph.DOTELFP);
                                                                              largocel := 9;
                                                                              emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                              if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                  if countn=0 then
                                                                                    JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP then
                                                                                    JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP  and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                    JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  countn := countn + 1;
                                                                              end if;
                                                                     END LOOP;--FSR005
                                                                     
                                                                     FOR pi IN (
                                                                      SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                      into  email
                                                                      from FSX001 e
                                                                      where e.PEPAIS=pd.PEPAIS
                                                                      and e.PETDOC=pd.PETDOC
                                                                      and e.PENDOC=pd.PENDOC
                                                                      and e.TXCOD=0
                                                                      and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                      and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                            (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                 FROM JAQN454)
                                                                            )
                                                                      ORDER BY PEXREN DESC
                                                                      )LOOP
                                                                              if counte<3 then
                                                                                  if counte=0 then
                                                                                    JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=1 then
                                                                                    JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=2 then
                                                                                    JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  counte := counte + 1;
                                                                              end if; 
                                                                      END LOOP;--FSX001
                                                                      
                                                                      
                                                                      
                                                                      FOR pj IN (
                                                                              SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                              into  
                                                                              SNGC13ppais,
                                                                              SNGC13petdoc,
                                                                              SNGC13pendoc,
                                                                              sDocod,
                                                                                    ssngc13Dir,
                                                                                    ssngc13RDes
                                                                              from SNGC13 f
                                                                              where f.sngc13Pais=pd.PEPAIS
                                                                              and f.sngc13Tdoc=pd.PETDOC
                                                                              and f.sngc13Ndoc=pd.PENDOC
                                                                              and f.SNGC13EST='H'
                                                                              order by sngc13RDes asc 
                                                                      )LOOP
                                                                                JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                      END LOOP;--SNGC13
                                                                      --DBMS_OUTPUT.PUT_LINE ('JURIDICA: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                      INSERT INTO JAQN451 (
                                                                                      JAQN451COD,
                                                                                      JAQN451FGE,
                                                                                      JAQN451PAI,
                                                                                      JAQN451TDO,
                                                                                      JAQN451NDO,
                                                                                      JAQN451APE,
                                                                                      JAQN451CE1,
                                                                                      JAQN451CE2,
                                                                                      JAQN451CE3,
                                                                                      JAQN451CO1,
                                                                                      JAQN451CO2,
                                                                                      JAQN451CO3,
                                                                                      JAQN451DIR)
                                                                            VALUES (
                                                                                      JAQNCOD,
                                                                                      JAQNFGE,
                                                                                      JA_PAISOUT,
                                                                                      JA_TIPOOUT,
                                                                                      JA_NUMERODOUT,
                                                                                      JA_NOMBREOUT,
                                                                                      JA_CELULAR1OUT,
                                                                                      JA_CELULAR2OUT,
                                                                                      JA_CELULAR3OUT,
                                                                                      JA_MAILOUT,
                                                                                      JA_MAILOUT1,
                                                                                      JA_MAILOUT2,
                                                                                      JA_DIRECCIONOUT);
                                                                            commit;
                                                                            
                                                                            JA_MAILOUT :=null;   
                                                                            JA_MAILOUT1 :=null;   
                                                                            JA_MAILOUT2 :=null;  
                                                                            JA_CELULAR1OUT :=null;
                                                                            JA_CELULAR2OUT :=null;
                                                                            JA_CELULAR3OUT :=null;
                                                                END LOOP;--FSD002
                                                                
                                                                
                                                                
                                                                
                                                  WHEN TIPO_PERSONA = 'A' then
                                                                FOR pg IN (
                                                                    SELECT  k.PENOM
                                                                    into aPenom
                                                                    from fsd001 k
                                                                    where k.Pepais=pd.PEPAIS
                                                                    and k.Petdoc=pd.PETDOC
                                                                    and k.Pendoc=pd.PENDOC
                                                                    and k.Pendoc NOT IN (
                                                                            (SELECT JAQN451NDO
                                                                             FROM JAQN451
                                                                             WHERE JAQN451COD=JAQNCOD
                                                                             AND JAQN451FGE=JAQNFGE
                                                                              )
                                                                      )
                                                                    
                                                                )LOOP
                                                                      JA_PAISOUT := pd.PEPAIS;
                                                                      JA_TIPOOUT := pd.PETDOC;
                                                                      JA_NUMERODOUT := pd.PENDOC;
                                                                      JA_NOMBREOUT := pg.PENOM;
                                                                      countn:=0;
                                                                      counte:=0;
                                                                      FOR ph IN (
                                                                              SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                              into  ddotelfp,
                                                                                    ddocod,
                                                                                    ddoorp,
                                                                                    nueve
                                                                              from fsr005 d
                                                                              where d.PEPAIS=pd.PEPAIS
                                                                              and d.PETDOC=pd.PETDOC
                                                                              and d.PENDOC=pd.PENDOC
                                                                              ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                    )LOOP
                                                                              largo := length(ph.DOTELFP);
                                                                              largocel := 9;
                                                                              emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                              if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                  if countn=0 then
                                                                                    JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP  then
                                                                                    JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP  and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                    JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  countn := countn + 1;
                                                                              end if;
                                                                     END LOOP;--FSR005
                                                                     
                                                                     FOR pi IN (
                                                                      SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                      into  email
                                                                      from FSX001 e
                                                                      where e.PEPAIS=pd.PEPAIS
                                                                      and e.PETDOC=pd.PETDOC
                                                                      and e.PENDOC=pd.PENDOC
                                                                      and e.TXCOD=0
                                                                      and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                      and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                            (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                 FROM JAQN454)
                                                                            )
                                                                      ORDER BY PEXREN DESC
                                                                      )LOOP
                                                                              if counte<3 then
                                                                                  if counte=0 then
                                                                                    JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=1 then
                                                                                    JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=2 then
                                                                                    JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  counte := counte + 1;
                                                                              end if; 
                                                                      END LOOP;--FSX001
                                                                      
                                                                      
                                                                      
                                                                      FOR pj IN (
                                                                              SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                              into  
                                                                              SNGC13ppais,
                                                                              SNGC13petdoc,
                                                                              SNGC13pendoc,
                                                                              sDocod,
                                                                                    ssngc13Dir,
                                                                                    ssngc13RDes
                                                                              from SNGC13 f
                                                                              where f.sngc13Pais=pd.PEPAIS
                                                                              and f.sngc13Tdoc=pd.PETDOC
                                                                              and f.sngc13Ndoc=pd.PENDOC
                                                                              and f.SNGC13EST='H'
                                                                              order by sngc13RDes asc 
                                                                      )LOOP
                                                                                JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                      END LOOP;--SNGC13
                                                                      --DBMS_OUTPUT.PUT_LINE ('AMBAS: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                      INSERT INTO JAQN451 (
                                                                                      JAQN451COD,
                                                                                      JAQN451FGE,
                                                                                      JAQN451PAI,
                                                                                      JAQN451TDO,
                                                                                      JAQN451NDO,
                                                                                      JAQN451APE,
                                                                                      JAQN451CE1,
                                                                                      JAQN451CE2,
                                                                                      JAQN451CE3,
                                                                                      JAQN451CO1,
                                                                                      JAQN451CO2,
                                                                                      JAQN451CO3,
                                                                                      JAQN451DIR)
                                                                            VALUES (
                                                                                      JAQNCOD,
                                                                                      JAQNFGE,
                                                                                      JA_PAISOUT,
                                                                                      JA_TIPOOUT,
                                                                                      JA_NUMERODOUT,
                                                                                      JA_NOMBREOUT,
                                                                                      JA_CELULAR1OUT,
                                                                                      JA_CELULAR2OUT,
                                                                                      JA_CELULAR3OUT,
                                                                                      JA_MAILOUT,
                                                                                      JA_MAILOUT1,
                                                                                      JA_MAILOUT2,
                                                                                      JA_DIRECCIONOUT);
                                                                            commit;
                                                                            
                                                                            JA_MAILOUT :=null;   
                                                                            JA_MAILOUT1 :=null;   
                                                                            JA_MAILOUT2 :=null;  
                                                                            JA_CELULAR1OUT :=null;
                                                                            JA_CELULAR2OUT :=null;
                                                                            JA_CELULAR3OUT :=null;
                                                                END LOOP;--FSD002
                                                            
                                                            END CASE;
                                                    END LOOP;
                                                ---SIN ESTADO
                                                END CASE;
                                        END LOOP;
                                    END LOOP;
                      END IF;--MONEDA 
                      
                      
       
                      cant:=REGEXP_COUNT(MOD_OPERA,'21');
                      cant:=cant+REGEXP_COUNT(MOD_OPERA,'22');
                      
                      mod22:=REPLACE(MOD_OPERA,'22-', '');
                      --mod22:=REPLACE(mod22,';', ',');
                      mod22:=REPLACE(mod22,'21-','9');
                      --DBMS_OUTPUT.PUT_LINE ('BB'||mod22);
                      
                      IF JA_MONEDA ='S' or JA_MONEDA ='D' THEN     
                              FOR i IN 1..cant LOOP
                                   tope:=REGEXP_SUBSTR(mod22, '[^;]+', 1,i );
                                  --DBMS_OUTPUT.PUT_LINE ('TOPE  '||tope);
                                  FOR ad IN (
                                           SELECT a.PGCOD, a.SCCTA,a.SCSTAT,a.SCMOD,a.SCTOPE,a.SCMDA,a.SCSUC,a.SCPAP,a.SCOPER,a.SCSBOP,a.SCSDO 
                                            into apgcod,
                                                 accta,
                                                 ascstat,
                                                 ascmod,
                                                 asctope,
                                                 ascmda,
                                                 ascsuc,
                                                 ascpap,
                                                 ascoper,
                                                 ascsbop,
                                                 ascsdo
                                            from fsd011 a
                                            where a.SCMOD =22
                                            and a.SCMDA  in (CASE WHEN JA_MONEDA='S' THEN 0
                                                                  WHEN JA_MONEDA='D' THEN 101
                                                                  END) 
                                            and a.SCFVAL >= JA_FECHA_APERTURA
                                            and a.SCFVAL <= JA_FECHA_CIERRE
                                            and a.SCCTA  >=  JA_CDESDE
                                            and a.SCCTA  <=  JA_CHASTA
                                            and a.SCTOPE = tope
                                            --and ROWNUM <= 50
                                  )
                                  LOOP
                                      --DBMS_OUTPUT.PUT_LINE ('CUENTA: '|| ad.SCCTA ||'-'||ad.SCMDA);
                                      CASE 
                                          WHEN JA_ESTADO='A' then
                                          --DBMS_OUTPUT.PUT_LINE ('ESTADO: A ');
                                                                      
                                              IF ad.SCSTAT <>99 and ad.SCSTAT<>81 THEN
                                                    FOR pd IN (
                                                        SELECT b.PEPAIS,b.PETDOC, b.PENDOC 
                                                        into  appais,
                                                              apetdoc,
                                                              apendoc
                                                        from fsr008 b
                                                        where b.PGCOD=ad.PGCOD
                                                        and b.CTNRO=ad.SCCTA
                                                        and b.TTCOD='1')
                                                    LOOP
                                                    
                                                      INSERT INTO JAQN452 (
                                                                JAQN452COD,
                                                                JAQN452PAI,
                                                                JAQN452TDO,
                                                                JAQN452NDO,
                                                                JAQN452EMP,--EMPRESA
                                                                JAQN452MOD,--MODULO
                                                                JAQN452SUC,--SUCURSAL
                                                                JAQN452MDA,--MONEDA
                                                                JAQN452PAP,--PAPEL
                                                                JAQN452CTA,--CUENTA
                                                                JAQN452OPE,--OPERACION
                                                                JAQN452SBO,--SUB TIPO DE OPERACION
                                                                JAQN452TOP)--TIPO DE OPERACION
                                                    VALUES (  JAQNCOD,
                                                                pd.PEPAIS,
                                                                pd.PETDOC,
                                                                pd.PENDOC,
                                                                ad.PGCOD,--EMPRESA
                                                                ad.SCMOD,--MODULO
                                                                ad.SCSUC,--SUCURSAL
                                                                ad.SCMDA,--MONEDA
                                                                ad.SCPAP,--PAPEL
                                                                ad.SCCTA,--CUENTA
                                                                ad.SCOPER,--OPERACION
                                                                ad.SCSBOP,--SUB TIPO DE OPERACION
                                                                ad.SCTOPE
                                                                );
                                                    commit;
                                                    
                                                    
                                                        CASE  
                                                            WHEN TIPO_PERSONA = 'N' then
                                                            --DBMS_OUTPUT.PUT_LINE ('N: ');
                                                                FOR pn IN (
                                                                SELECT  c.PFPAIS,c.PFTDOC, c.PFNDOC,c.PFAPE1,c.PFAPE2,c.PFNOM1,c.PFNOM2
                                                                into  nppais,
                                                                      npetdoc,
                                                                      npendoc,
                                                                      nape1,
                                                                      nape2,
                                                                      nnom1,
                                                                      nnom2
                                                                from fsd002 c
                                                                where c.PFPAIS=pd.PEPAIS
                                                                and c.PFTDOC=pd.PETDOC
                                                                and c.PFNDOC=pd.PENDOC
                                                                and c.PFNDOC NOT IN (
                                                                            (SELECT JAQN451NDO
                                                                             FROM JAQN451
                                                                             WHERE JAQN451COD=JAQNCOD
                                                                             AND JAQN451FGE=JAQNFGE
                                                                              )
                                                                 )
                                                                )
                                                              LOOP
                                                                  JA_PAISOUT := pd.PEPAIS;
                                                                  JA_TIPOOUT := pd.PETDOC;
                                                                  JA_NUMERODOUT := pd.PENDOC;
                                                                  JA_NOMBREOUT := TRIM(pn.PFAPE1)||' '||TRIM(pn.PFAPE2)||' '||TRIM(pn.PFNOM1)||' '||TRIM(pn.PFNOM2);
                                                                  countn:=0;
                                                                  counte:=0;
                                                                  
                                                                      FOR pc IN (
                                                                            SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                            into  ddotelfp,
                                                                                  ddocod,
                                                                                  ddoorp,
                                                                                  nueve
                                                                            from fsr005 d
                                                                            where d.PEPAIS=pd.PEPAIS
                                                                            and d.PETDOC=pd.PETDOC
                                                                            and d.PENDOC=pd.PENDOC
                                                                            ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                      )LOOP
                                                                                largo := length(pc.DOTELFP);
                                                                                largocel := 9;
                                                                                emp:=SUBSTR(pc.DOTELFP,1,1);
                                                                                if largo = largocel and emp=9 and pc.CANT<>9 and countn<3 then
                                                                                  if countn=0 then
                                                                                    JA_CELULAR1OUT :=pc.DOTELFP;
                                                                                  end if;
                                                                                  if countn=1 and JA_CELULAR1OUT <> pc.DOTELFP  then
                                                                                    JA_CELULAR2OUT :=pc.DOTELFP;
                                                                                  end if;
                                                                                  if countn=2 and JA_CELULAR1OUT <> pc.DOTELFP  and JA_CELULAR2OUT <> pc.DOTELFP then
                                                                                    JA_CELULAR3OUT :=pc.DOTELFP;
                                                                                  end if;
                                                                                  countn := countn + 1;
                                                                                end if;         
                                                                       END LOOP;
                                                                       
                                                                       FOR pe IN (
                                                                            SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                            into  email
                                                                            from FSX001 e
                                                                            where e.PEPAIS=pd.PEPAIS
                                                                            and e.PETDOC=pd.PETDOC
                                                                            and e.PENDOC=pd.PENDOC
                                                                            and e.TXCOD=0
                                                                            and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                            and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                            (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                             FROM JAQN454)
                                                                            )
                                                                            ORDER BY PEXREN DESC
                                                                        )LOOP
                                                                               --DBMS_OUTPUT.PUT_LINE ('EMAIL BAA: A '||regexp_substr(pe.PEXTXT,'[^\]*'));
                                                                          --if regexp_substr(pe.PEXTXT,'[^\]*')<>null OR regexp_substr(pe.PEXTXT,'[^\]*')<>'' then    
                                                                            if counte<3 then
                                                                                  if counte=0 then
                                                                                      JA_MAILOUT :=regexp_substr(pe.PEXTXT,'[^\]*');                    
                                                                                  end if;
                                                                                  if counte=1 then
                                                                                      JA_MAILOUT1 :=regexp_substr(pe.PEXTXT,'[^\]*');  
                                                                                  end if;
                                                                                  if counte=2 then
                                                                                      JA_MAILOUT2 :=regexp_substr(pe.PEXTXT,'[^\]*');
                                                                                  end if;
                                                                                  counte := counte + 1;                      
                                                                            end if;       
                                                                        --end if;            
                                                                        END LOOP;
                                                                       
                                                                       FOR ps IN (
                                                                                SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                into  
                                                                                SNGC13ppais,
                                                                                SNGC13petdoc,
                                                                                SNGC13pendoc,
                                                                                sDocod,
                                                                                      ssngc13Dir,
                                                                                      ssngc13RDes
                                                                                from SNGC13 f
                                                                                where f.sngc13Pais=pd.PEPAIS
                                                                                and f.sngc13Tdoc=pd.PETDOC
                                                                                and f.sngc13Ndoc=pd.PENDOC
                                                                                and f.SNGC13EST='H'
                                                                                order by sngc13RDes asc 
                                                                        )LOOP
                                                                              JA_DIRECCIONOUT := ps.sngc13Dir;
                                                                        END LOOP;
                                                                        
                                                                      --DBMS_OUTPUT.PUT_LINE ('NATURAL:'||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'||JA_MAILOUT1||'-'||JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                      INSERT INTO JAQN451 (
                                                                                      JAQN451COD,
                                                                                      JAQN451FGE,
                                                                                      JAQN451PAI,
                                                                                      JAQN451TDO,
                                                                                      JAQN451NDO,
                                                                                      JAQN451APE,
                                                                                      JAQN451CE1,
                                                                                      JAQN451CE2,
                                                                                      JAQN451CE3,
                                                                                      JAQN451CO1,
                                                                                      JAQN451CO2,
                                                                                      JAQN451CO3,
                                                                                      JAQN451DIR)
                                                                            VALUES (
                                                                                      JAQNCOD,
                                                                                      JAQNFGE,
                                                                                      JA_PAISOUT,
                                                                                      JA_TIPOOUT,
                                                                                      JA_NUMERODOUT,
                                                                                      JA_NOMBREOUT,
                                                                                      JA_CELULAR1OUT,
                                                                                      JA_CELULAR2OUT,
                                                                                      JA_CELULAR3OUT,
                                                                                      JA_MAILOUT,
                                                                                      JA_MAILOUT1,
                                                                                      JA_MAILOUT2,
                                                                                      JA_DIRECCIONOUT);
                                                                            commit;
                                                                          
                                                                            JA_MAILOUT :=null;   
                                                                            JA_MAILOUT1 :=null;   
                                                                            JA_MAILOUT2 :=null;  
                                                                            JA_CELULAR1OUT :=null;
                                                                            JA_CELULAR2OUT :=null;
                                                                            JA_CELULAR3OUT :=null;
                                                                          --DBMS_OUTPUT.PUT_LINE ('ESTADO A: '||ad.SCSTAT ||'-'||ad.PGCOD||'-' ||ad.SCCTA||'-' ||ad.SCMOD||'-' ||ad.SCTOPE||'-' ||pd.PEPAIS||'-' ||pd.PETDOC||'-' ||pd.PENDOC);
                                                   
                                                              END LOOP;--FSD001
                                                            
                                                  WHEN TIPO_PERSONA = 'J' then
                                                                FOR pg IN (
                                                                    SELECT  g.PJRAZS
                                                                    into gPjrazs
                                                                    from fsd003 g
                                                                    where g.Pjpais=pd.PEPAIS
                                                                    and g.Pjtdoc=pd.PETDOC
                                                                    and g.Pjndoc=pd.PENDOC
                                                                    and g.Pjndoc NOT IN (
                                                                            (SELECT JAQN451NDO
                                                                             FROM JAQN451
                                                                             WHERE JAQN451COD=JAQNCOD
                                                                             AND JAQN451FGE=JAQNFGE
                                                                              )
                                                                 )
                                                                )LOOP
                                                                      JA_PAISOUT := pd.PEPAIS;
                                                                      JA_TIPOOUT := pd.PETDOC;
                                                                      JA_NUMERODOUT := pd.PENDOC;
                                                                      JA_NOMBREOUT := pg.PJRAZS;
                                                                      countn:=0;
                                                                      counte:=0;
                                                                      FOR ph IN (
                                                                              SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                              into  ddotelfp,
                                                                                    ddocod,
                                                                                    ddoorp,
                                                                                    nueve
                                                                              from fsr005 d
                                                                              where d.PEPAIS=pd.PEPAIS
                                                                              and d.PETDOC=pd.PETDOC
                                                                              and d.PENDOC=pd.PENDOC
                                                                              ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                    )LOOP
                                                                              largo := length(ph.DOTELFP);
                                                                              largocel := 9;
                                                                              emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                              if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                  if countn=0 then
                                                                                    JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP then
                                                                                    JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP  and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                    JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  countn := countn + 1;
                                                                              end if;
                                                                     END LOOP;--FSR005
                                                                     
                                                                     FOR pi IN (
                                                                      SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                      into  email
                                                                      from FSX001 e
                                                                      where e.PEPAIS=pd.PEPAIS
                                                                      and e.PETDOC=pd.PETDOC
                                                                      and e.PENDOC=pd.PENDOC
                                                                      and e.TXCOD=0
                                                                      and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                      and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                            (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                             FROM JAQN454)
                                                                            )
                                                                      ORDER BY PEXREN DESC
                                                                      )LOOP
                                                                              if counte<3 then
                                                                                  if counte=0 then
                                                                                    JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=1 then
                                                                                    JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=2 then
                                                                                    JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  counte := counte + 1;
                                                                              end if; 
                                                                      END LOOP;--FSX001
                                                                      
                                                                      
                                                                      
                                                                      FOR pj IN (
                                                                              SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                              into  
                                                                              SNGC13ppais,
                                                                              SNGC13petdoc,
                                                                              SNGC13pendoc,
                                                                              sDocod,
                                                                                    ssngc13Dir,
                                                                                    ssngc13RDes
                                                                              from SNGC13 f
                                                                              where f.sngc13Pais=pd.PEPAIS
                                                                              and f.sngc13Tdoc=pd.PETDOC
                                                                              and f.sngc13Ndoc=pd.PENDOC
                                                                              and f.SNGC13EST='H'
                                                                              order by sngc13RDes asc 
                                                                      )LOOP
                                                                                JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                      END LOOP;--SNGC13
                                                                      --DBMS_OUTPUT.PUT_LINE ('JURIDICA: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                      INSERT INTO JAQN451 (
                                                                                      JAQN451COD,
                                                                                      JAQN451FGE,
                                                                                      JAQN451PAI,
                                                                                      JAQN451TDO,
                                                                                      JAQN451NDO,
                                                                                      JAQN451APE,
                                                                                      JAQN451CE1,
                                                                                      JAQN451CE2,
                                                                                      JAQN451CE3,
                                                                                      JAQN451CO1,
                                                                                      JAQN451CO2,
                                                                                      JAQN451CO3,
                                                                                      JAQN451DIR)
                                                                            VALUES (
                                                                                      JAQNCOD,
                                                                                      JAQNFGE,
                                                                                      JA_PAISOUT,
                                                                                      JA_TIPOOUT,
                                                                                      JA_NUMERODOUT,
                                                                                      JA_NOMBREOUT,
                                                                                      JA_CELULAR1OUT,
                                                                                      JA_CELULAR2OUT,
                                                                                      JA_CELULAR3OUT,
                                                                                      JA_MAILOUT,
                                                                                      JA_MAILOUT1,
                                                                                      JA_MAILOUT2,
                                                                                      JA_DIRECCIONOUT);
                                                                            commit;
                                                                            
                                                                            JA_MAILOUT :=null;   
                                                                            JA_MAILOUT1 :=null;   
                                                                            JA_MAILOUT2 :=null;  
                                                                            JA_CELULAR1OUT :=null;
                                                                            JA_CELULAR2OUT :=null;
                                                                            JA_CELULAR3OUT :=null;
                                                                END LOOP;--FSD002
                                                                
                                                                
                                                  WHEN TIPO_PERSONA = 'A' then
                                                                FOR pg IN (
                                                                    SELECT  k.PENOM
                                                                    into aPenom
                                                                    from fsd001 k
                                                                    where k.Pepais=pd.PEPAIS
                                                                    and k.Petdoc=pd.PETDOC
                                                                    and k.Pendoc=pd.PENDOC
                                                                    and k.Pendoc NOT IN (
                                                                            (SELECT JAQN451NDO
                                                                             FROM JAQN451
                                                                             WHERE JAQN451COD=JAQNCOD
                                                                             AND JAQN451FGE=JAQNFGE
                                                                              )
                                                                      )
                                                                    
                                                                )LOOP
                                                                      JA_PAISOUT := pd.PEPAIS;
                                                                      JA_TIPOOUT := pd.PETDOC;
                                                                      JA_NUMERODOUT := pd.PENDOC;
                                                                      JA_NOMBREOUT := pg.PENOM;
                                                                      countn:=0;
                                                                      counte:=0;
                                                                      FOR ph IN (
                                                                              SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                              into  ddotelfp,
                                                                                    ddocod,
                                                                                    ddoorp,
                                                                                    nueve
                                                                              from fsr005 d
                                                                              where d.PEPAIS=pd.PEPAIS
                                                                              and d.PETDOC=pd.PETDOC
                                                                              and d.PENDOC=pd.PENDOC
                                                                              ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                    )LOOP
                                                                              largo := length(ph.DOTELFP);
                                                                              largocel := 9;
                                                                              emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                              if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                  if countn=0 then
                                                                                    JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP  then
                                                                                    JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP  and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                    JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  countn := countn + 1;
                                                                              end if;
                                                                     END LOOP;--FSR005
                                                                     
                                                                     FOR pi IN (
                                                                      SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                      into  email
                                                                      from FSX001 e
                                                                      where e.PEPAIS=pd.PEPAIS
                                                                      and e.PETDOC=pd.PETDOC
                                                                      and e.PENDOC=pd.PENDOC
                                                                      and e.TXCOD=0
                                                                      and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                      and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                           (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                             FROM JAQN454)
                                                                            )
                                                                      ORDER BY PEXREN DESC
                                                                      )LOOP
                                                                              if counte<3 then
                                                                                  if counte=0 then
                                                                                    JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=1 then
                                                                                    JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=2 then
                                                                                    JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  counte := counte + 1;
                                                                              end if; 
                                                                      END LOOP;--FSX001
                                                                      
                                                                      
                                                                      
                                                                      FOR pj IN (
                                                                              SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                              into  
                                                                              SNGC13ppais,
                                                                              SNGC13petdoc,
                                                                              SNGC13pendoc,
                                                                              sDocod,
                                                                                    ssngc13Dir,
                                                                                    ssngc13RDes
                                                                              from SNGC13 f
                                                                              where f.sngc13Pais=pd.PEPAIS
                                                                              and f.sngc13Tdoc=pd.PETDOC
                                                                              and f.sngc13Ndoc=pd.PENDOC
                                                                              and f.SNGC13EST='H'
                                                                              order by sngc13RDes asc 
                                                                      )LOOP
                                                                                JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                      END LOOP;--SNGC13
                                                                      --DBMS_OUTPUT.PUT_LINE ('AMBAS: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                      INSERT INTO JAQN451 (
                                                                                      JAQN451COD,
                                                                                      JAQN451FGE,
                                                                                      JAQN451PAI,
                                                                                      JAQN451TDO,
                                                                                      JAQN451NDO,
                                                                                      JAQN451APE,
                                                                                      JAQN451CE1,
                                                                                      JAQN451CE2,
                                                                                      JAQN451CE3,
                                                                                      JAQN451CO1,
                                                                                      JAQN451CO2,
                                                                                      JAQN451CO3,
                                                                                      JAQN451DIR)
                                                                            VALUES (
                                                                                      JAQNCOD,
                                                                                      JAQNFGE,
                                                                                      JA_PAISOUT,
                                                                                      JA_TIPOOUT,
                                                                                      JA_NUMERODOUT,
                                                                                      JA_NOMBREOUT,
                                                                                      JA_CELULAR1OUT,
                                                                                      JA_CELULAR2OUT,
                                                                                      JA_CELULAR3OUT,
                                                                                      JA_MAILOUT,
                                                                                      JA_MAILOUT1,
                                                                                      JA_MAILOUT2,
                                                                                      JA_DIRECCIONOUT);
                                                                            commit;
                                                                            
                                                                            
                                                                            JA_MAILOUT :=null;   
                                                                            JA_MAILOUT1 :=null;   
                                                                            JA_MAILOUT2 :=null;  
                                                                            JA_CELULAR1OUT :=null;
                                                                            JA_CELULAR2OUT :=null;
                                                                            JA_CELULAR3OUT :=null;
                                                                END LOOP;--FSD002
                                                            
                                                            END CASE;
                                                    END LOOP;
          
                                              END IF;
                                              
                                              
                                          WHEN JA_ESTADO='I' then
                                              IF ad.SCSTAT =81 THEN
                                                --DBMS_OUTPUT.PUT_LINE ('ESTADO I: '||ad.SCSTAT ||'-'||ad.PGCOD||'-' ||ad.SCCTA||'-' ||ad.SCMOD||'-' ||ad.SCTOPE);
                                                       
                                                              FOR pd IN (
                                                                  SELECT b.PEPAIS,b.PETDOC, b.PENDOC 
                                                                  into  appais,
                                                                        apetdoc,
                                                                        apendoc
                                                                  from fsr008 b
                                                                  where b.PGCOD=ad.PGCOD
                                                                  and b.CTNRO=ad.SCCTA
                                                                  and b.TTCOD='1')
                                                              LOOP
                                                                INSERT INTO JAQN452 (
                                                                JAQN452COD,
                                                                JAQN452PAI,
                                                                JAQN452TDO,
                                                                JAQN452NDO,
                                                                JAQN452EMP,--EMPRESA
                                                                JAQN452MOD,--MODULO
                                                                JAQN452SUC,--SUCURSAL
                                                                JAQN452MDA,--MONEDA
                                                                JAQN452PAP,--PAPEL
                                                                JAQN452CTA,--CUENTA
                                                                JAQN452OPE,--OPERACION
                                                                JAQN452SBO,--SUB TIPO DE OPERACION
                                                                JAQN452TOP)--TIPO DE OPERACION
                                                              VALUES (  JAQNCOD,
                                                                          pd.PEPAIS,
                                                                          pd.PETDOC,
                                                                          pd.PENDOC,
                                                                          ad.PGCOD,--EMPRESA
                                                                          ad.SCMOD,--MODULO
                                                                          ad.SCSUC,--SUCURSAL
                                                                          ad.SCMDA,--MONEDA
                                                                          ad.SCPAP,--PAPEL
                                                                          ad.SCCTA,--CUENTA
                                                                          ad.SCOPER,--OPERACION
                                                                          ad.SCSBOP,--SUB TIPO DE OPERACION
                                                                          ad.SCTOPE
                                                                          );
                                                              commit;
                                                              
                                                                  CASE  
                                                                      WHEN TIPO_PERSONA = 'N' then
                                                                      
                                                                          FOR pn IN (
                                                                          SELECT c.PFPAIS,c.PFTDOC, c.PFNDOC,c.PFAPE1,c.PFAPE2,c.PFNOM1,c.PFNOM2
                                                                          into  nppais,
                                                                                npetdoc,
                                                                                npendoc,
                                                                                nape1,
                                                                                nape2,
                                                                                nnom1,
                                                                                nnom2
                                                                          from fsd002 c
                                                                          where c.PFPAIS=pd.PEPAIS
                                                                          and c.PFTDOC=pd.PETDOC
                                                                          and c.PFNDOC=pd.PENDOC
                                                                          and c.PFNDOC NOT IN (
                                                                            (SELECT JAQN451NDO
                                                                             FROM JAQN451
                                                                             WHERE JAQN451COD=JAQNCOD
                                                                             AND JAQN451FGE=JAQNFGE
                                                                              )
                                                                            )
                                                                          )
                                                                        LOOP
                                                                            JA_PAISOUT := pd.PEPAIS;
                                                                            JA_TIPOOUT := pd.PETDOC;
                                                                            JA_NUMERODOUT := pd.PENDOC;
                                                                            JA_NOMBREOUT := TRIM(pn.PFAPE1)||' '||TRIM(pn.PFAPE2)||' '||TRIM(pn.PFNOM1)||' '||TRIM(pn.PFNOM2);
                                                                            countn:=0;
                                                                            counte:=0;
                                                                            
                                                                                FOR pc IN (
                                                                                      SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                                      into  ddotelfp,
                                                                                            ddocod,
                                                                                            ddoorp,
                                                                                            nueve
                                                                                      from fsr005 d
                                                                                      where d.PEPAIS=pd.PEPAIS
                                                                                      and d.PETDOC=pd.PETDOC
                                                                                      and d.PENDOC=pd.PENDOC
                                                                                      ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                                )LOOP
                                                                                          largo := length(pc.DOTELFP);
                                                                                          largocel := 9;
                                                                                          emp:=SUBSTR(pc.DOTELFP,1,1);
                                                                                          if largo = largocel and emp=9 and pc.CANT<>9 and countn<3 then
                                                                                            if countn=0 then
                                                                                              JA_CELULAR1OUT :=pc.DOTELFP;
                                                                                            end if;
                                                                                            if countn=1 and JA_CELULAR1OUT <> pc.DOTELFP then
                                                                                              JA_CELULAR2OUT :=pc.DOTELFP;
                                                                                            end if;
                                                                                            if countn=2 and JA_CELULAR1OUT <> pc.DOTELFP  and JA_CELULAR2OUT <> pc.DOTELFP then
                                                                                              JA_CELULAR3OUT :=pc.DOTELFP;
                                                                                            end if;
                                                                                            countn := countn + 1;
                                                                                          end if;         
                                                                                 END LOOP;
                                                                                 
                                                                                 FOR pe IN (
                                                                                      SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                                      into  email
                                                                                      from FSX001 e
                                                                                      where e.PEPAIS=pd.PEPAIS
                                                                                      and e.PETDOC=pd.PETDOC
                                                                                      and e.PENDOC=pd.PENDOC
                                                                                      and e.TXCOD=0
                                                                                      and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                                      and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                                      (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                          FROM JAQN454)
                                                                                      )
                                                                                      ORDER BY PEXREN DESC
                                                                                  )LOOP
                                                                                        if counte<3 then
                                                                                            if counte=0 then
                                                                                              JA_MAILOUT :=regexp_substr(pe.PEXTXT,'[^\]*');   
                                                                                            end if;
                                                                                            if counte=1 then
                                                                                              JA_MAILOUT1 :=regexp_substr(pe.PEXTXT,'[^\]*');   
                                                                                            end if;
                                                                                            if counte=2 then
                                                                                              JA_MAILOUT2 :=regexp_substr(pe.PEXTXT,'[^\]*');   
                                                                                            end if;
                                                                                            counte := counte + 1;
                                                                                        end if; 
                    
                                                                                  END LOOP;
                                                                                 
                                                                                 FOR ps IN (
                                                                                          SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                          into  
                                                                                          SNGC13ppais,
                                                                                          SNGC13petdoc,
                                                                                          SNGC13pendoc,
                                                                                          sDocod,
                                                                                                ssngc13Dir,
                                                                                                ssngc13RDes
                                                                                          from SNGC13 f
                                                                                          where f.sngc13Pais=pd.PEPAIS
                                                                                          and f.sngc13Tdoc=pd.PETDOC
                                                                                          and f.sngc13Ndoc=pd.PENDOC
                                                                                          and f.SNGC13EST='H'
                                                                                          order by sngc13RDes asc 
                                                                                  )LOOP
                                                                                        JA_DIRECCIONOUT := ps.sngc13Dir;
                                                                                  END LOOP;
                                                                                  
                                                                                  --DBMS_OUTPUT.PUT_LINE ('CUENTA: '|| ad.SCCTA );
                                                                                  --DBMS_OUTPUT.PUT_LINE ('NATURAL:'||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'||JA_MAILOUT1||'-'||JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                                  INSERT INTO JAQN451 (
                                                                                                JAQN451COD,
                                                                                                JAQN451FGE,
                                                                                                JAQN451PAI,
                                                                                                JAQN451TDO,
                                                                                                JAQN451NDO,
                                                                                                JAQN451APE,
                                                                                                JAQN451CE1,
                                                                                                JAQN451CE2,
                                                                                                JAQN451CE3,
                                                                                                JAQN451CO1,
                                                                                                JAQN451CO2,
                                                                                                JAQN451CO3,
                                                                                                JAQN451DIR)
                                                                                      VALUES (
                                                                                                JAQNCOD,
                                                                                                JAQNFGE,
                                                                                                JA_PAISOUT,
                                                                                                JA_TIPOOUT,
                                                                                                JA_NUMERODOUT,
                                                                                                JA_NOMBREOUT,
                                                                                                JA_CELULAR1OUT,
                                                                                                JA_CELULAR2OUT,
                                                                                                JA_CELULAR3OUT,
                                                                                                JA_MAILOUT,
                                                                                                JA_MAILOUT1,
                                                                                                JA_MAILOUT2,
                                                                                                JA_DIRECCIONOUT);
                                                                                      commit;
                                                                                      
                                                                                      
                                                                                      JA_MAILOUT :=null;   
                                                                                      JA_MAILOUT1 :=null;   
                                                                                      JA_MAILOUT2 :=null;  
                                                                                      JA_CELULAR1OUT :=null;
                                                                                      JA_CELULAR2OUT :=null;
                                                                                      JA_CELULAR3OUT :=null;
                                                                                    --DBMS_OUTPUT.PUT_LINE ('ESTADO A: '||ad.SCSTAT ||'-'||ad.PGCOD||'-' ||ad.SCCTA||'-' ||ad.SCMOD||'-' ||ad.SCTOPE||'-' ||pd.PEPAIS||'-' ||pd.PETDOC||'-' ||pd.PENDOC);
                                                             
                                                                        END LOOP;--FSD001
                                                                      
                                                            WHEN TIPO_PERSONA = 'J' then
                                                                          FOR pg IN (
                                                                              SELECT g.PJRAZS
                                                                              into gPjrazs
                                                                              from fsd003 g
                                                                              where g.Pjpais=pd.PEPAIS
                                                                              and g.Pjtdoc=pd.PETDOC
                                                                              and g.Pjndoc=pd.PENDOC
                                                                              and g.Pjndoc NOT IN (
                                                                              (SELECT JAQN451NDO
                                                                               FROM JAQN451
                                                                               WHERE JAQN451COD=JAQNCOD
                                                                               AND JAQN451FGE=JAQNFGE
                                                                                )
                                                                              )
                                                                          )LOOP
                                                                                JA_PAISOUT := pd.PEPAIS;
                                                                                JA_TIPOOUT := pd.PETDOC;
                                                                                JA_NUMERODOUT := pd.PENDOC;
                                                                                JA_NOMBREOUT := pg.PJRAZS;
                                                                                countn:=0;
                                                                                counte:=0;
                                                                                FOR ph IN (
                                                                                        SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                                        into  ddotelfp,
                                                                                              ddocod,
                                                                                              ddoorp,
                                                                                              nueve
                                                                                        from fsr005 d
                                                                                        where d.PEPAIS=pd.PEPAIS
                                                                                        and d.PETDOC=pd.PETDOC
                                                                                        and d.PENDOC=pd.PENDOC
                                                                                        ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                              )LOOP
                                                                                        largo := length(ph.DOTELFP);
                                                                                        largocel := 9;
                                                                                        emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                                        if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                            if countn=0 then
                                                                                              JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                            end if;
                                                                                            if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP then
                                                                                              JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                            end if;
                                                                                            if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP  and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                              JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                            end if;
                                                                                            countn := countn + 1;
                                                                                        end if;
                                                                               END LOOP;--FSR005
                                                                               
                                                                               FOR pi IN (
                                                                                SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                                into  email
                                                                                from FSX001 e
                                                                                where e.PEPAIS=pd.PEPAIS
                                                                                and e.PETDOC=pd.PETDOC
                                                                                and e.PENDOC=pd.PENDOC
                                                                                and e.TXCOD=0
                                                                                and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                                and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                                    (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                       FROM JAQN454)
                                                                                      )
                                                                                ORDER BY PEXREN DESC
                                                                                )LOOP
                                                                                        if counte<3 then
                                                                                            if counte=0 then
                                                                                              JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                            end if;
                                                                                            if counte=1 then
                                                                                              JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                            end if;
                                                                                            if counte=2 then
                                                                                              JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                            end if;
                                                                                            counte := counte + 1;
                                                                                        end if; 
                                                                                END LOOP;--FSX001
                                                                                
                                                                                
                                                                                
                                                                                FOR pj IN (
                                                                                        SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                        into  
                                                                                        SNGC13ppais,
                                                                                        SNGC13petdoc,
                                                                                        SNGC13pendoc,
                                                                                        sDocod,
                                                                                              ssngc13Dir,
                                                                                              ssngc13RDes
                                                                                        from SNGC13 f
                                                                                        where f.sngc13Pais=pd.PEPAIS
                                                                                        and f.sngc13Tdoc=pd.PETDOC
                                                                                        and f.sngc13Ndoc=pd.PENDOC
                                                                                        and f.SNGC13EST='H'
                                                                                        order by sngc13RDes asc 
                                                                                )LOOP
                                                                                          JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                                END LOOP;--SNGC13
                                                                                --DBMS_OUTPUT.PUT_LINE ('JURIDICA: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                                INSERT INTO JAQN451 (
                                                                                                JAQN451COD,
                                                                                                JAQN451FGE,
                                                                                                JAQN451PAI,
                                                                                                JAQN451TDO,
                                                                                                JAQN451NDO,
                                                                                                JAQN451APE,
                                                                                                JAQN451CE1,
                                                                                                JAQN451CE2,
                                                                                                JAQN451CE3,
                                                                                                JAQN451CO1,
                                                                                                JAQN451CO2,
                                                                                                JAQN451CO3,
                                                                                                JAQN451DIR)
                                                                                      VALUES (
                                                                                                JAQNCOD,
                                                                                                JAQNFGE,
                                                                                                JA_PAISOUT,
                                                                                                JA_TIPOOUT,
                                                                                                JA_NUMERODOUT,
                                                                                                JA_NOMBREOUT,
                                                                                                JA_CELULAR1OUT,
                                                                                                JA_CELULAR2OUT,
                                                                                                JA_CELULAR3OUT,
                                                                                                JA_MAILOUT,
                                                                                                JA_MAILOUT1,
                                                                                                JA_MAILOUT2,
                                                                                                JA_DIRECCIONOUT);
                                                                                      commit;
                                                                                      
                                                                                      
                                                                                      JA_MAILOUT :=null;   
                                                                                      JA_MAILOUT1 :=null;   
                                                                                      JA_MAILOUT2 :=null;  
                                                                                      JA_CELULAR1OUT :=null;
                                                                                      JA_CELULAR2OUT :=null;
                                                                                      JA_CELULAR3OUT :=null;
                                                                          END LOOP;--FSD002
                                                                          
                                                                          
                                                                          
                                                                          
                                                            WHEN TIPO_PERSONA = 'A' then
                                                                          FOR pg IN (
                                                                              SELECT k.PENOM
                                                                              into aPenom
                                                                              from fsd001 k
                                                                              where k.Pepais=pd.PEPAIS
                                                                              and k.Petdoc=pd.PETDOC
                                                                              and k.Pendoc=pd.PENDOC
                                                                              and k.Pendoc NOT IN (
                                                                              (SELECT JAQN451NDO
                                                                               FROM JAQN451
                                                                               WHERE JAQN451COD=JAQNCOD
                                                                               AND JAQN451FGE=JAQNFGE
                                                                                )
                                                                              )
                                                                          )LOOP
                                                                                JA_PAISOUT := pd.PEPAIS;
                                                                                JA_TIPOOUT := pd.PETDOC;
                                                                                JA_NUMERODOUT := pd.PENDOC;
                                                                                JA_NOMBREOUT := pg.PENOM;
                                                                                countn:=0;
                                                                                counte:=0;
                                                                                FOR ph IN (
                                                                                        SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                                        into  ddotelfp,
                                                                                              ddocod,
                                                                                              ddoorp,
                                                                                              nueve
                                                                                        from fsr005 d
                                                                                        where d.PEPAIS=pd.PEPAIS
                                                                                        and d.PETDOC=pd.PETDOC
                                                                                        and d.PENDOC=pd.PENDOC
                                                                                        ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                              )LOOP
                                                                                        largo := length(ph.DOTELFP);
                                                                                        largocel := 9;
                                                                                        emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                                        if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                            if countn=0 then
                                                                                              JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                            end if;
                                                                                            if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP then
                                                                                              JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                            end if;
                                                                                            if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP  and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                              JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                            end if;
                                                                                            countn := countn + 1;
                                                                                        end if;
                                                                               END LOOP;--FSR005
                                                                               
                                                                               FOR pi IN (
                                                                                SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                                into  email
                                                                                from FSX001 e
                                                                                where e.PEPAIS=pd.PEPAIS
                                                                                and e.PETDOC=pd.PETDOC
                                                                                and e.PENDOC=pd.PENDOC
                                                                                and e.TXCOD=0
                                                                                and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                                and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                                    (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                       FROM JAQN454)
                                                                                    )
                                                                                ORDER BY PEXREN DESC
                                                                                )LOOP
                                                                                        if counte<3 then
                                                                                            if counte=0 then
                                                                                              JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                            end if;
                                                                                            if counte=1 then
                                                                                              JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                            end if;
                                                                                            if counte=2 then
                                                                                              JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                            end if;
                                                                                            counte := counte + 1;
                                                                                        end if; 
                                                                                END LOOP;--FSX001
                                                                                
                                                                                
                                                                                
                                                                                FOR pj IN (
                                                                                        SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                        into  
                                                                                        SNGC13ppais,
                                                                                        SNGC13petdoc,
                                                                                        SNGC13pendoc,
                                                                                        sDocod,
                                                                                              ssngc13Dir,
                                                                                              ssngc13RDes
                                                                                        from SNGC13 f
                                                                                        where f.sngc13Pais=pd.PEPAIS
                                                                                        and f.sngc13Tdoc=pd.PETDOC
                                                                                        and f.sngc13Ndoc=pd.PENDOC
                                                                                        and f.SNGC13EST='H'
                                                                                        order by sngc13RDes asc 
                                                                                )LOOP
                                                                                          JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                                END LOOP;--SNGC13
                                                                                --DBMS_OUTPUT.PUT_LINE ('AMBAS: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                                INSERT INTO JAQN451 (
                                                                                                JAQN451COD,
                                                                                                JAQN451FGE,
                                                                                                JAQN451PAI,
                                                                                                JAQN451TDO,
                                                                                                JAQN451NDO,
                                                                                                JAQN451APE,
                                                                                                JAQN451CE1,
                                                                                                JAQN451CE2,
                                                                                                JAQN451CE3,
                                                                                                JAQN451CO1,
                                                                                                JAQN451CO2,
                                                                                                JAQN451CO3,
                                                                                                JAQN451DIR)
                                                                                      VALUES (
                                                                                                JAQNCOD,
                                                                                                JAQNFGE,
                                                                                                JA_PAISOUT,
                                                                                                JA_TIPOOUT,
                                                                                                JA_NUMERODOUT,
                                                                                                JA_NOMBREOUT,
                                                                                                JA_CELULAR1OUT,
                                                                                                JA_CELULAR2OUT,
                                                                                                JA_CELULAR3OUT,
                                                                                                JA_MAILOUT,
                                                                                                JA_MAILOUT1,
                                                                                                JA_MAILOUT2,
                                                                                                JA_DIRECCIONOUT);
                                                                                      commit;
                                                                                                                                                                            
                                                                                      JA_MAILOUT :=null;   
                                                                                      JA_MAILOUT1 :=null;   
                                                                                      JA_MAILOUT2 :=null;  
                                                                                      JA_CELULAR1OUT :=null;
                                                                                      JA_CELULAR2OUT :=null;
                                                                                      JA_CELULAR3OUT :=null;
                                                                          END LOOP;--FSD002
                                                                      
                                                                      END CASE;
                                                              END LOOP;
                                                    
                                              END IF; --ESTADO I
                                              
                                          WHEN JA_ESTADO='T' then
                                            
                                                    FOR pd IN (
                                                        SELECT b.PEPAIS,b.PETDOC, b.PENDOC 
                                                        into  appais,
                                                              apetdoc,
                                                              apendoc
                                                        from fsr008 b
                                                        where b.PGCOD=ad.PGCOD
                                                        and b.CTNRO=ad.SCCTA
                                                        and b.TTCOD='1')
                                                    LOOP
                                                    
                                                      INSERT INTO JAQN452 (
                                                                JAQN452COD,
                                                                JAQN452PAI,
                                                                JAQN452TDO,
                                                                JAQN452NDO,
                                                                JAQN452EMP,--EMPRESA
                                                                JAQN452MOD,--MODULO
                                                                JAQN452SUC,--SUCURSAL
                                                                JAQN452MDA,--MONEDA
                                                                JAQN452PAP,--PAPEL
                                                                JAQN452CTA,--CUENTA
                                                                JAQN452OPE,--OPERACION
                                                                JAQN452SBO,--SUB TIPO DE OPERACION
                                                                JAQN452TOP)--TIPO DE OPERACION
                                                    VALUES (  JAQNCOD,
                                                                pd.PEPAIS,
                                                                pd.PETDOC,
                                                                pd.PENDOC,
                                                                ad.PGCOD,--EMPRESA
                                                                ad.SCMOD,--MODULO
                                                                ad.SCSUC,--SUCURSAL
                                                                ad.SCMDA,--MONEDA
                                                                ad.SCPAP,--PAPEL
                                                                ad.SCCTA,--CUENTA
                                                                ad.SCOPER,--OPERACION
                                                                ad.SCSBOP,--SUB TIPO DE OPERACION
                                                                ad.SCTOPE
                                                                );
                                                    commit;
                                                    
                                                        CASE  
                                                            WHEN TIPO_PERSONA = 'N' then
                                                            --DBMS_OUTPUT.PUT_LINE ('N: ');
                                                                FOR pn IN (
                                                                SELECT  c.PFPAIS,c.PFTDOC, c.PFNDOC,c.PFAPE1,c.PFAPE2,c.PFNOM1,c.PFNOM2
                                                                into  nppais,
                                                                      npetdoc,
                                                                      npendoc,
                                                                      nape1,
                                                                      nape2,
                                                                      nnom1,
                                                                      nnom2
                                                                from fsd002 c
                                                                where c.PFPAIS=pd.PEPAIS
                                                                and c.PFTDOC=pd.PETDOC
                                                                and c.PFNDOC=pd.PENDOC
                                                                and c.PFNDOC NOT IN (
                                                                            (SELECT JAQN451NDO
                                                                             FROM JAQN451
                                                                             WHERE JAQN451COD=JAQNCOD
                                                                             AND JAQN451FGE=JAQNFGE
                                                                              )
                                                                 )
                                                                )
                                                              LOOP
                                                                  JA_PAISOUT := pd.PEPAIS;
                                                                  JA_TIPOOUT := pd.PETDOC;
                                                                  JA_NUMERODOUT := pd.PENDOC;
                                                                  JA_NOMBREOUT := TRIM(pn.PFAPE1)||' '||TRIM(pn.PFAPE2)||' '||TRIM(pn.PFNOM1)||' '||TRIM(pn.PFNOM2);
                                                                  countn:=0;
                                                                  counte:=0;
                                                                  
                                                                      FOR pc IN (
                                                                            SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                            into  ddotelfp,
                                                                                  ddocod,
                                                                                  ddoorp,
                                                                                  nueve
                                                                            from fsr005 d
                                                                            where d.PEPAIS=pd.PEPAIS
                                                                            and d.PETDOC=pd.PETDOC
                                                                            and d.PENDOC=pd.PENDOC
                                                                            ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                      )LOOP
                                                                                largo := length(pc.DOTELFP);
                                                                                largocel := 9;
                                                                                emp:=SUBSTR(pc.DOTELFP,1,1);
                                                                                if largo = largocel and emp=9 and pc.CANT<>9 and countn<3 then
                                                                                  if countn=0 then
                                                                                    JA_CELULAR1OUT :=pc.DOTELFP;
                                                                                  end if;
                                                                                  if countn=1 and JA_CELULAR1OUT <> pc.DOTELFP  then
                                                                                    JA_CELULAR2OUT :=pc.DOTELFP;
                                                                                  end if;
                                                                                  if countn=2 and JA_CELULAR1OUT <> pc.DOTELFP  and JA_CELULAR2OUT <> pc.DOTELFP then
                                                                                    JA_CELULAR3OUT :=pc.DOTELFP;
                                                                                  end if;
                                                                                  countn := countn + 1;
                                                                                end if;         
                                                                       END LOOP;
                                                                       
                                                                       FOR pe IN (
                                                                            SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                            into  email
                                                                            from FSX001 e
                                                                            where e.PEPAIS=pd.PEPAIS
                                                                            and e.PETDOC=pd.PETDOC
                                                                            and e.PENDOC=pd.PENDOC
                                                                            and e.TXCOD=0
                                                                            and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                            and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                            (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                       FROM JAQN454)
                                                                            )
                                                                            ORDER BY PEXREN DESC
                                                                        )LOOP
                                                                               --DBMS_OUTPUT.PUT_LINE ('EMAIL BAA: A '||regexp_substr(pe.PEXTXT,'[^\]*'));
                                                                          --if regexp_substr(pe.PEXTXT,'[^\]*')<>null OR regexp_substr(pe.PEXTXT,'[^\]*')<>'' then    
                                                                            if counte<3 then
                                                                                  if counte=0 then
                                                                                      JA_MAILOUT :=regexp_substr(pe.PEXTXT,'[^\]*');                    
                                                                                  end if;
                                                                                  if counte=1 then
                                                                                      JA_MAILOUT1 :=regexp_substr(pe.PEXTXT,'[^\]*');  
                                                                                  end if;
                                                                                  if counte=2 then
                                                                                      JA_MAILOUT2 :=regexp_substr(pe.PEXTXT,'[^\]*');
                                                                                  end if;
                                                                                  counte := counte + 1;                      
                                                                            end if;       
                                                                        --end if;            
                                                                        END LOOP;
                                                                       
                                                                       FOR ps IN (
                                                                                SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                into  
                                                                                SNGC13ppais,
                                                                                SNGC13petdoc,
                                                                                SNGC13pendoc,
                                                                                sDocod,
                                                                                      ssngc13Dir,
                                                                                      ssngc13RDes
                                                                                from SNGC13 f
                                                                                where f.sngc13Pais=pd.PEPAIS
                                                                                and f.sngc13Tdoc=pd.PETDOC
                                                                                and f.sngc13Ndoc=pd.PENDOC
                                                                                and f.SNGC13EST='H'
                                                                                order by sngc13RDes asc 
                                                                        )LOOP
                                                                              JA_DIRECCIONOUT := ps.sngc13Dir;
                                                                        END LOOP;
                                                                        
                                                                      --DBMS_OUTPUT.PUT_LINE ('NATURAL:'||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'||JA_MAILOUT1||'-'||JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                      INSERT INTO JAQN451 (
                                                                                      JAQN451COD,
                                                                                      JAQN451FGE,
                                                                                      JAQN451PAI,
                                                                                      JAQN451TDO,
                                                                                      JAQN451NDO,
                                                                                      JAQN451APE,
                                                                                      JAQN451CE1,
                                                                                      JAQN451CE2,
                                                                                      JAQN451CE3,
                                                                                      JAQN451CO1,
                                                                                      JAQN451CO2,
                                                                                      JAQN451CO3,
                                                                                      JAQN451DIR)
                                                                            VALUES (
                                                                                      JAQNCOD,
                                                                                      JAQNFGE,
                                                                                      JA_PAISOUT,
                                                                                      JA_TIPOOUT,
                                                                                      JA_NUMERODOUT,
                                                                                      JA_NOMBREOUT,
                                                                                      JA_CELULAR1OUT,
                                                                                      JA_CELULAR2OUT,
                                                                                      JA_CELULAR3OUT,
                                                                                      JA_MAILOUT,
                                                                                      JA_MAILOUT1,
                                                                                      JA_MAILOUT2,
                                                                                      JA_DIRECCIONOUT);
                                                                            commit;
                                                                           
                                                                            JA_MAILOUT :=null;   
                                                                            JA_MAILOUT1 :=null;   
                                                                            JA_MAILOUT2 :=null;  
                                                                            JA_CELULAR1OUT :=null;
                                                                            JA_CELULAR2OUT :=null;
                                                                            JA_CELULAR3OUT :=null;
                                                                          --DBMS_OUTPUT.PUT_LINE ('ESTADO A: '||ad.SCSTAT ||'-'||ad.PGCOD||'-' ||ad.SCCTA||'-' ||ad.SCMOD||'-' ||ad.SCTOPE||'-' ||pd.PEPAIS||'-' ||pd.PETDOC||'-' ||pd.PENDOC);
                                                   
                                                              END LOOP;--FSD001
                                                            
                                                  WHEN TIPO_PERSONA = 'J' then
                                                                FOR pg IN (
                                                                    SELECT  g.PJRAZS
                                                                    into gPjrazs
                                                                    from fsd003 g
                                                                    where g.Pjpais=pd.PEPAIS
                                                                    and g.Pjtdoc=pd.PETDOC
                                                                    and g.Pjndoc=pd.PENDOC
                                                                    and g.Pjndoc NOT IN (
                                                                            (SELECT JAQN451NDO
                                                                             FROM JAQN451
                                                                             WHERE JAQN451COD=JAQNCOD
                                                                             AND JAQN451FGE=JAQNFGE
                                                                              )
                                                                 )
                                                                )LOOP
                                                                      JA_PAISOUT := pd.PEPAIS;
                                                                      JA_TIPOOUT := pd.PETDOC;
                                                                      JA_NUMERODOUT := pd.PENDOC;
                                                                      JA_NOMBREOUT := pg.PJRAZS;
                                                                      countn:=0;
                                                                      counte:=0;
                                                                      FOR ph IN (
                                                                              SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                              into  ddotelfp,
                                                                                    ddocod,
                                                                                    ddoorp,
                                                                                    nueve
                                                                              from fsr005 d
                                                                              where d.PEPAIS=pd.PEPAIS
                                                                              and d.PETDOC=pd.PETDOC
                                                                              and d.PENDOC=pd.PENDOC
                                                                              ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                    )LOOP
                                                                              largo := length(ph.DOTELFP);
                                                                              largocel := 9;
                                                                              emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                              if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                  if countn=0 then
                                                                                    JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP  then
                                                                                    JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP  and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                    JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  countn := countn + 1;
                                                                              end if;
                                                                     END LOOP;--FSR005
                                                                     
                                                                     FOR pi IN (
                                                                      SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                      into  email
                                                                      from FSX001 e
                                                                      where e.PEPAIS=pd.PEPAIS
                                                                      and e.PETDOC=pd.PETDOC
                                                                      and e.PENDOC=pd.PENDOC
                                                                      and e.TXCOD=0
                                                                      and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                      and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                            (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                       FROM JAQN454)
                                                                            )
                                                                      ORDER BY PEXREN DESC
                                                                      )LOOP
                                                                              if counte<3 then
                                                                                  if counte=0 then
                                                                                    JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=1 then
                                                                                    JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=2 then
                                                                                    JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  counte := counte + 1;
                                                                              end if; 
                                                                      END LOOP;--FSX001
                                                                      
                                                                      
                                                                      
                                                                      FOR pj IN (
                                                                              SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                              into  
                                                                              SNGC13ppais,
                                                                              SNGC13petdoc,
                                                                              SNGC13pendoc,
                                                                              sDocod,
                                                                                    ssngc13Dir,
                                                                                    ssngc13RDes
                                                                              from SNGC13 f
                                                                              where f.sngc13Pais=pd.PEPAIS
                                                                              and f.sngc13Tdoc=pd.PETDOC
                                                                              and f.sngc13Ndoc=pd.PENDOC
                                                                              and f.SNGC13EST='H'
                                                                              order by sngc13RDes asc 
                                                                      )LOOP
                                                                                JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                      END LOOP;--SNGC13
                                                                      --DBMS_OUTPUT.PUT_LINE ('JURIDICA: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                      INSERT INTO JAQN451 (
                                                                                      JAQN451COD,
                                                                                      JAQN451FGE,
                                                                                      JAQN451PAI,
                                                                                      JAQN451TDO,
                                                                                      JAQN451NDO,
                                                                                      JAQN451APE,
                                                                                      JAQN451CE1,
                                                                                      JAQN451CE2,
                                                                                      JAQN451CE3,
                                                                                      JAQN451CO1,
                                                                                      JAQN451CO2,
                                                                                      JAQN451CO3,
                                                                                      JAQN451DIR)
                                                                            VALUES (
                                                                                      JAQNCOD,
                                                                                      JAQNFGE,
                                                                                      JA_PAISOUT,
                                                                                      JA_TIPOOUT,
                                                                                      JA_NUMERODOUT,
                                                                                      JA_NOMBREOUT,
                                                                                      JA_CELULAR1OUT,
                                                                                      JA_CELULAR2OUT,
                                                                                      JA_CELULAR3OUT,
                                                                                      JA_MAILOUT,
                                                                                      JA_MAILOUT1,
                                                                                      JA_MAILOUT2,
                                                                                      JA_DIRECCIONOUT);
                                                                            commit;
                                                                            
                                                                           
                                                                            JA_MAILOUT :=null;   
                                                                            JA_MAILOUT1 :=null;   
                                                                            JA_MAILOUT2 :=null;  
                                                                            JA_CELULAR1OUT :=null;
                                                                            JA_CELULAR2OUT :=null;
                                                                            JA_CELULAR3OUT :=null;
                                                                END LOOP;--FSD002
                                                                
                                                                
                                                                
                                                                
                                                  WHEN TIPO_PERSONA = 'A' then
                                                                FOR pg IN (
                                                                    SELECT  k.PENOM
                                                                    into aPenom
                                                                    from fsd001 k
                                                                    where k.Pepais=pd.PEPAIS
                                                                    and k.Petdoc=pd.PETDOC
                                                                    and k.Pendoc=pd.PENDOC
                                                                    and k.Pendoc NOT IN (
                                                                            (SELECT JAQN451NDO
                                                                             FROM JAQN451
                                                                             WHERE JAQN451COD=JAQNCOD
                                                                             AND JAQN451FGE=JAQNFGE
                                                                              )
                                                                      )
                                                                    
                                                                )LOOP
                                                                      JA_PAISOUT := pd.PEPAIS;
                                                                      JA_TIPOOUT := pd.PETDOC;
                                                                      JA_NUMERODOUT := pd.PENDOC;
                                                                      JA_NOMBREOUT := pg.PENOM;
                                                                      countn:=0;
                                                                      counte:=0;
                                                                      FOR ph IN (
                                                                              SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                              into  ddotelfp,
                                                                                    ddocod,
                                                                                    ddoorp,
                                                                                    nueve
                                                                              from fsr005 d
                                                                              where d.PEPAIS=pd.PEPAIS
                                                                              and d.PETDOC=pd.PETDOC
                                                                              and d.PENDOC=pd.PENDOC
                                                                              ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                    )LOOP
                                                                              largo := length(ph.DOTELFP);
                                                                              largocel := 9;
                                                                              emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                              if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                  if countn=0 then
                                                                                    JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP  then
                                                                                    JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP  and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                    JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  countn := countn + 1;
                                                                              end if;
                                                                     END LOOP;--FSR005
                                                                     
                                                                     FOR pi IN (
                                                                      SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                      into  email
                                                                      from FSX001 e
                                                                      where e.PEPAIS=pd.PEPAIS
                                                                      and e.PETDOC=pd.PETDOC
                                                                      and e.PENDOC=pd.PENDOC
                                                                      and e.TXCOD=0
                                                                      and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                      and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                            (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                       FROM JAQN454)
                                                                            )
                                                                      ORDER BY PEXREN DESC
                                                                      )LOOP
                                                                              if counte<3 then
                                                                                  if counte=0 then
                                                                                    JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=1 then
                                                                                    JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=2 then
                                                                                    JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  counte := counte + 1;
                                                                              end if; 
                                                                      END LOOP;--FSX001
                                                                      
                                                                      
                                                                      
                                                                      FOR pj IN (
                                                                              SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                              into  
                                                                              SNGC13ppais,
                                                                              SNGC13petdoc,
                                                                              SNGC13pendoc,
                                                                              sDocod,
                                                                                    ssngc13Dir,
                                                                                    ssngc13RDes
                                                                              from SNGC13 f
                                                                              where f.sngc13Pais=pd.PEPAIS
                                                                              and f.sngc13Tdoc=pd.PETDOC
                                                                              and f.sngc13Ndoc=pd.PENDOC
                                                                              and f.SNGC13EST='H'
                                                                              order by sngc13RDes asc 
                                                                      )LOOP
                                                                                JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                      END LOOP;--SNGC13
                                                                      --DBMS_OUTPUT.PUT_LINE ('AMBAS: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                      INSERT INTO JAQN451 (
                                                                                      JAQN451COD,
                                                                                      JAQN451FGE,
                                                                                      JAQN451PAI,
                                                                                      JAQN451TDO,
                                                                                      JAQN451NDO,
                                                                                      JAQN451APE,
                                                                                      JAQN451CE1,
                                                                                      JAQN451CE2,
                                                                                      JAQN451CE3,
                                                                                      JAQN451CO1,
                                                                                      JAQN451CO2,
                                                                                      JAQN451CO3,
                                                                                      JAQN451DIR)
                                                                            VALUES (
                                                                                      JAQNCOD,
                                                                                      JAQNFGE,
                                                                                      JA_PAISOUT,
                                                                                      JA_TIPOOUT,
                                                                                      JA_NUMERODOUT,
                                                                                      JA_NOMBREOUT,
                                                                                      JA_CELULAR1OUT,
                                                                                      JA_CELULAR2OUT,
                                                                                      JA_CELULAR3OUT,
                                                                                      JA_MAILOUT,
                                                                                      JA_MAILOUT1,
                                                                                      JA_MAILOUT2,
                                                                                      JA_DIRECCIONOUT);
                                                                            commit;
                                                                          
                                                                            JA_MAILOUT :=null;   
                                                                            JA_MAILOUT1 :=null;   
                                                                            JA_MAILOUT2 :=null;  
                                                                            JA_CELULAR1OUT :=null;
                                                                            JA_CELULAR2OUT :=null;
                                                                            JA_CELULAR3OUT :=null;
                                                                END LOOP;--FSD002
                                                            
                                                            END CASE;
                                                    END LOOP;
                                            ---SIN ESTADO
                                          END CASE;
                                  
                                  END LOOP;
                              END LOOP;
                        END IF;--MONEDA
                      
                      
                      
                      IF JA_MONEDA ='A' THEN     
                      --DBMS_OUTPUT.PUT_LINE ('MONEDAAAAAAAAA AA:');
                                      FOR i IN 1..cant LOOP
                                        tope:=REGEXP_SUBSTR(modval, '[^;]+', 1,i );
                                        --DBMS_OUTPUT.PUT_LINE ('AMBAS MONEDAS  '||tope);
                                        FOR ad IN (
                                              SELECT a.PGCOD, a.SCCTA,a.SCSTAT,a.SCMOD,a.SCTOPE,a.SCMDA,a.SCSUC,a.SCPAP,a.SCOPER,a.SCSBOP,a.SCSDO 
                                                  into apgcod,
                                                       accta,
                                                       ascstat,
                                                       ascmod,
                                                       asctope,
                                                       ascmda,
                                                       ascsuc,
                                                       ascpap,
                                                       ascoper,
                                                       ascsbop,
                                                       ascsdo
                                                  from fsd011 a
                                                  where a.SCMOD =22
                                                  and a.SCMDA  in (0,101) 
                                                  and a.SCFVAL >= JA_FECHA_APERTURA
                                                  and a.SCFVAL <= JA_FECHA_CIERRE
                                                  and a.SCCTA  >=  JA_CDESDE
                                                  and a.SCCTA  <=  JA_CHASTA
                                                  and a.SCTOPE = tope
                                                  --and ROWNUM <= 500
                                        )
                                        LOOP
                                            --DBMS_OUTPUT.PUT_LINE ('CUENTA: '|| ad.SCCTA ||'-'||ad.SCMDA);
                                            CASE 
                                                WHEN JA_ESTADO='A' then
                                                    IF ad.SCSTAT <>99 and ad.SCSTAT<>81 THEN
                                                          FOR pd IN (
                                                              SELECT b.PEPAIS,b.PETDOC, b.PENDOC 
                                                              into  appais,
                                                                    apetdoc,
                                                                    apendoc
                                                              from fsr008 b
                                                              where b.PGCOD=ad.PGCOD
                                                              and b.CTNRO=ad.SCCTA
                                                              and b.TTCOD='1')
                                                          LOOP
                                                          
                                                          INSERT INTO JAQN452 (
                                                                JAQN452COD,
                                                                JAQN452PAI,
                                                                JAQN452TDO,
                                                                JAQN452NDO,
                                                                JAQN452EMP,--EMPRESA
                                                                JAQN452MOD,--MODULO
                                                                JAQN452SUC,--SUCURSAL
                                                                JAQN452MDA,--MONEDA
                                                                JAQN452PAP,--PAPEL
                                                                JAQN452CTA,--CUENTA
                                                                JAQN452OPE,--OPERACION
                                                                JAQN452SBO,--SUB TIPO DE OPERACION
                                                                JAQN452TOP)--TIPO DE OPERACION
                                                        VALUES (  JAQNCOD,
                                                                    pd.PEPAIS,
                                                                    pd.PETDOC,
                                                                    pd.PENDOC,
                                                                    ad.PGCOD,--EMPRESA
                                                                    ad.SCMOD,--MODULO
                                                                    ad.SCSUC,--SUCURSAL
                                                                    ad.SCMDA,--MONEDA
                                                                    ad.SCPAP,--PAPEL
                                                                    ad.SCCTA,--CUENTA
                                                                    ad.SCOPER,--OPERACION
                                                                    ad.SCSBOP,--SUB TIPO DE OPERACION
                                                                    ad.SCTOPE
                                                                    );
                                                        commit;
                                                    
                                                              CASE  
                                                                  WHEN TIPO_PERSONA = 'N' then
                                                                  
                                                                      FOR pn IN (
                                                                      SELECT c.PFPAIS,c.PFTDOC, c.PFNDOC,c.PFAPE1,c.PFAPE2,c.PFNOM1,c.PFNOM2
                                                                      into  nppais,
                                                                            npetdoc,
                                                                            npendoc,
                                                                            nape1,
                                                                            nape2,
                                                                            nnom1,
                                                                            nnom2
                                                                      from fsd002 c
                                                                      where c.PFPAIS=pd.PEPAIS
                                                                      and c.PFTDOC=pd.PETDOC
                                                                      and c.PFNDOC=pd.PENDOC
                                                                      and c.PFNDOC NOT IN (
                                                                              (SELECT JAQN451NDO
                                                                               FROM JAQN451
                                                                               WHERE JAQN451COD=JAQNCOD
                                                                               AND JAQN451FGE=JAQNFGE
                                                                                )
                                                                              )
                                                                      )
                                                                    LOOP
                                                                        JA_PAISOUT := pd.PEPAIS;
                                                                        JA_TIPOOUT := pd.PETDOC;
                                                                        JA_NUMERODOUT := pd.PENDOC;
                                                                        JA_NOMBREOUT := TRIM(pn.PFAPE1)||' '||TRIM(pn.PFAPE2)||' '||TRIM(pn.PFNOM1)||' '||TRIM(pn.PFNOM2);
                                                                        countn:=0;
                                                                        counte:=0;
                                                                        
                                                                            FOR pc IN (
                                                                                  SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                                  into  ddotelfp,
                                                                                        ddocod,
                                                                                        ddoorp,
                                                                                        nueve
                                                                                  from fsr005 d
                                                                                  where d.PEPAIS=pd.PEPAIS
                                                                                  and d.PETDOC=pd.PETDOC
                                                                                  and d.PENDOC=pd.PENDOC
                                                                                  ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                            )LOOP
                                                                                      largo := length(pc.DOTELFP);
                                                                                      largocel := 9;
                                                                                      emp:=SUBSTR(pc.DOTELFP,1,1);
                                                                                      if largo = largocel and emp=9 and pc.CANT<>9 and countn<3 then
                                                                                        if countn=0 then
                                                                                          JA_CELULAR1OUT :=pc.DOTELFP;
                                                                                        end if;
                                                                                        if countn=1 and JA_CELULAR1OUT <> pc.DOTELFP  then
                                                                                          JA_CELULAR2OUT :=pc.DOTELFP;
                                                                                        end if;
                                                                                        if countn=2 and JA_CELULAR1OUT <> pc.DOTELFP  and JA_CELULAR2OUT <> pc.DOTELFP then
                                                                                          JA_CELULAR3OUT :=pc.DOTELFP;
                                                                                        end if;
                                                                                        countn := countn + 1;
                                                                                      end if;         
                                                                             END LOOP;
                                                                             
                                                                             FOR pe IN (
                                                                                  SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                                  into  email
                                                                                  from FSX001 e
                                                                                  where e.PEPAIS=pd.PEPAIS
                                                                                  and e.PETDOC=pd.PETDOC
                                                                                  and e.PENDOC=pd.PENDOC
                                                                                  and e.TXCOD=0
                                                                                  and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                                  and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                                    (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                       FROM JAQN454)
                                                                                    )
                                                                                  ORDER BY PEXREN DESC
                                                                              )LOOP
                                                                                    if counte<3 then
                                                                                        if counte=0 then
                                                                                          JA_MAILOUT :=regexp_substr(pe.PEXTXT,'[^\]*');   
                                                                                        end if;
                                                                                        if counte=1 then
                                                                                          JA_MAILOUT1 :=regexp_substr(pe.PEXTXT,'[^\]*');   
                                                                                        end if;
                                                                                        if counte=2 then
                                                                                          JA_MAILOUT2 :=regexp_substr(pe.PEXTXT,'[^\]*');   
                                                                                        end if;
                                                                                        counte := counte + 1;
                                                                                    end if; 
                
                                                                              END LOOP;
                                                                             
                                                                             FOR ps IN (
                                                                                      SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                      into  
                                                                                      SNGC13ppais,
                                                                                      SNGC13petdoc,
                                                                                      SNGC13pendoc,
                                                                                      sDocod,
                                                                                            ssngc13Dir,
                                                                                            ssngc13RDes
                                                                                      from SNGC13 f
                                                                                      where f.sngc13Pais=pd.PEPAIS
                                                                                      and f.sngc13Tdoc=pd.PETDOC
                                                                                      and f.sngc13Ndoc=pd.PENDOC
                                                                                      and f.SNGC13EST='H'
                                                                                      order by sngc13RDes asc 
                                                                              )LOOP
                                                                                    JA_DIRECCIONOUT := ps.sngc13Dir;
                                                                              END LOOP;
                                                                              
                                                                              --DBMS_OUTPUT.PUT_LINE ('CUENTA: '|| ad.SCCTA );
                                                                              --DBMS_OUTPUT.PUT_LINE ('NATURAL:'||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'||JA_MAILOUT1||'-'||JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                              INSERT INTO JAQN451 (
                                                                                            JAQN451COD,
                                                                                            JAQN451FGE,
                                                                                            JAQN451PAI,
                                                                                            JAQN451TDO,
                                                                                            JAQN451NDO,
                                                                                            JAQN451APE,
                                                                                            JAQN451CE1,
                                                                                            JAQN451CE2,
                                                                                            JAQN451CE3,
                                                                                            JAQN451CO1,
                                                                                            JAQN451CO2,
                                                                                            JAQN451CO3,
                                                                                            JAQN451DIR)
                                                                                  VALUES (
                                                                                            JAQNCOD,
                                                                                            JAQNFGE,
                                                                                            JA_PAISOUT,
                                                                                            JA_TIPOOUT,
                                                                                            JA_NUMERODOUT,
                                                                                            JA_NOMBREOUT,
                                                                                            JA_CELULAR1OUT,
                                                                                            JA_CELULAR2OUT,
                                                                                            JA_CELULAR3OUT,
                                                                                            JA_MAILOUT,
                                                                                            JA_MAILOUT1,
                                                                                            JA_MAILOUT2,
                                                                                            JA_DIRECCIONOUT);
                                                                                  commit;
                                                                                  
                                                                                  JA_MAILOUT :=null;   
                                                                                  JA_MAILOUT1 :=null;   
                                                                                  JA_MAILOUT2 :=null;  
                                                                                  JA_CELULAR1OUT :=null;
                                                                                  JA_CELULAR2OUT :=null;
                                                                                  JA_CELULAR3OUT :=null;
                                                                                --DBMS_OUTPUT.PUT_LINE ('ESTADO A: '||ad.SCSTAT ||'-'||ad.PGCOD||'-' ||ad.SCCTA||'-' ||ad.SCMOD||'-' ||ad.SCTOPE||'-' ||pd.PEPAIS||'-' ||pd.PETDOC||'-' ||pd.PENDOC);
                                                         
                                                                    END LOOP;--FSD001
                                                                  
                                                        WHEN TIPO_PERSONA = 'J' then
                                                                      FOR pg IN (
                                                                          SELECT g.PJRAZS
                                                                          into gPjrazs
                                                                          from fsd003 g
                                                                          where g.Pjpais=pd.PEPAIS
                                                                          and g.Pjtdoc=pd.PETDOC
                                                                          and g.Pjndoc=pd.PENDOC
                                                                          and g.Pjndoc NOT IN (
                                                                              (SELECT JAQN451NDO
                                                                               FROM JAQN451
                                                                               WHERE JAQN451COD=JAQNCOD
                                                                               AND JAQN451FGE=JAQNFGE
                                                                                )
                                                                              )
                                                                      )LOOP
                                                                            JA_PAISOUT := pd.PEPAIS;
                                                                            JA_TIPOOUT := pd.PETDOC;
                                                                            JA_NUMERODOUT := pd.PENDOC;
                                                                            JA_NOMBREOUT := pg.PJRAZS;
                                                                            countn:=0;
                                                                            counte:=0;
                                                                            FOR ph IN (
                                                                                    SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                                    into  ddotelfp,
                                                                                          ddocod,
                                                                                          ddoorp,
                                                                                          nueve
                                                                                    from fsr005 d
                                                                                    where d.PEPAIS=pd.PEPAIS
                                                                                    and d.PETDOC=pd.PETDOC
                                                                                    and d.PENDOC=pd.PENDOC
                                                                                    ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                          )LOOP
                                                                                    largo := length(ph.DOTELFP);
                                                                                    largocel := 9;
                                                                                    emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                                    if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                        if countn=0 then
                                                                                          JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                        end if;
                                                                                        if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP  then
                                                                                          JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                        end if;
                                                                                        if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP  and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                          JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                        end if;
                                                                                        countn := countn + 1;
                                                                                    end if;
                                                                           END LOOP;--FSR005
                                                                           
                                                                           FOR pi IN (
                                                                            SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                            into  email
                                                                            from FSX001 e
                                                                            where e.PEPAIS=pd.PEPAIS
                                                                            and e.PETDOC=pd.PETDOC
                                                                            and e.PENDOC=pd.PENDOC
                                                                            and e.TXCOD=0
                                                                            and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                            and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                                    (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                       FROM JAQN454)
                                                                                    )
                                                                            ORDER BY PEXREN DESC
                                                                            )LOOP
                                                                                    if counte<3 then
                                                                                        if counte=0 then
                                                                                          JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                        end if;
                                                                                        if counte=1 then
                                                                                          JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                        end if;
                                                                                        if counte=2 then
                                                                                          JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                        end if;
                                                                                        counte := counte + 1;
                                                                                    end if; 
                                                                            END LOOP;--FSX001
                                                                            
                                                                            
                                                                            
                                                                            FOR pj IN (
                                                                                    SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                    into  
                                                                                    SNGC13ppais,
                                                                                    SNGC13petdoc,
                                                                                    SNGC13pendoc,
                                                                                    sDocod,
                                                                                          ssngc13Dir,
                                                                                          ssngc13RDes
                                                                                    from SNGC13 f
                                                                                    where f.sngc13Pais=pd.PEPAIS
                                                                                    and f.sngc13Tdoc=pd.PETDOC
                                                                                    and f.sngc13Ndoc=pd.PENDOC
                                                                                    and f.SNGC13EST='H'
                                                                                    order by sngc13RDes asc 
                                                                            )LOOP
                                                                                      JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                            END LOOP;--SNGC13
                                                                            --DBMS_OUTPUT.PUT_LINE ('JURIDICA: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                            INSERT INTO JAQN451 (
                                                                                            JAQN451COD,
                                                                                            JAQN451FGE,
                                                                                            JAQN451PAI,
                                                                                            JAQN451TDO,
                                                                                            JAQN451NDO,
                                                                                            JAQN451APE,
                                                                                            JAQN451CE1,
                                                                                            JAQN451CE2,
                                                                                            JAQN451CE3,
                                                                                            JAQN451CO1,
                                                                                            JAQN451CO2,
                                                                                            JAQN451CO3,
                                                                                            JAQN451DIR)
                                                                                  VALUES (
                                                                                            JAQNCOD,
                                                                                            JAQNFGE,
                                                                                            JA_PAISOUT,
                                                                                            JA_TIPOOUT,
                                                                                            JA_NUMERODOUT,
                                                                                            JA_NOMBREOUT,
                                                                                            JA_CELULAR1OUT,
                                                                                            JA_CELULAR2OUT,
                                                                                            JA_CELULAR3OUT,
                                                                                            JA_MAILOUT,
                                                                                            JA_MAILOUT1,
                                                                                            JA_MAILOUT2,
                                                                                            JA_DIRECCIONOUT);
                                                                                  commit;
                                                                                  
                                                                                  JA_MAILOUT :=null;   
                                                                                  JA_MAILOUT1 :=null;   
                                                                                  JA_MAILOUT2 :=null;  
                                                                                  JA_CELULAR1OUT :=null;
                                                                                  JA_CELULAR2OUT :=null;
                                                                                  JA_CELULAR3OUT :=null;
                                                                      END LOOP;--FSD002
                                                                      
                                                                      
                                                        WHEN TIPO_PERSONA = 'A' then
                                                                      FOR pg IN (
                                                                          SELECT k.PENOM
                                                                          into aPenom
                                                                          from fsd001 k
                                                                          where k.Pepais=pd.PEPAIS
                                                                          and k.Petdoc=pd.PETDOC
                                                                          and k.Pendoc=pd.PENDOC
                                                                          and k.Pendoc NOT IN (
                                                                              (SELECT JAQN451NDO
                                                                               FROM JAQN451
                                                                               WHERE JAQN451COD=JAQNCOD
                                                                               AND JAQN451FGE=JAQNFGE
                                                                                )
                                                                              )
                                                                      )LOOP
                                                                            JA_PAISOUT := pd.PEPAIS;
                                                                            JA_TIPOOUT := pd.PETDOC;
                                                                            JA_NUMERODOUT := pd.PENDOC;
                                                                            JA_NOMBREOUT := pg.PENOM;
                                                                            countn:=0;
                                                                            counte:=0;
                                                                            FOR ph IN (
                                                                                    SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                                    into  ddotelfp,
                                                                                          ddocod,
                                                                                          ddoorp,
                                                                                          nueve
                                                                                    from fsr005 d
                                                                                    where d.PEPAIS=pd.PEPAIS
                                                                                    and d.PETDOC=pd.PETDOC
                                                                                    and d.PENDOC=pd.PENDOC
                                                                                    ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                          )LOOP
                                                                                    largo := length(ph.DOTELFP);
                                                                                    largocel := 9;
                                                                                    emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                                    if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                        if countn=0 then
                                                                                          JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                        end if;
                                                                                        if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP  then
                                                                                          JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                        end if;
                                                                                        if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP  and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                          JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                        end if;
                                                                                        countn := countn + 1;
                                                                                    end if;
                                                                           END LOOP;--FSR005
                                                                           
                                                                           FOR pi IN (
                                                                            SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                            into  email
                                                                            from FSX001 e
                                                                            where e.PEPAIS=pd.PEPAIS
                                                                            and e.PETDOC=pd.PETDOC
                                                                            and e.PENDOC=pd.PENDOC
                                                                            and e.TXCOD=0
                                                                            and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                            and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                                    (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                       FROM JAQN454)
                                                                                    )
                                                                            ORDER BY PEXREN DESC
                                                                            )LOOP
                                                                                    if counte<3 then
                                                                                        if counte=0 then
                                                                                          JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                        end if;
                                                                                        if counte=1 then
                                                                                          JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                        end if;
                                                                                        if counte=2 then
                                                                                          JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                        end if;
                                                                                        counte := counte + 1;
                                                                                    end if; 
                                                                            END LOOP;--FSX001
                                                                            
                                                                            
                                                                            
                                                                            FOR pj IN (
                                                                                    SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                    into  
                                                                                    SNGC13ppais,
                                                                                    SNGC13petdoc,
                                                                                    SNGC13pendoc,
                                                                                    sDocod,
                                                                                          ssngc13Dir,
                                                                                          ssngc13RDes
                                                                                    from SNGC13 f
                                                                                    where f.sngc13Pais=pd.PEPAIS
                                                                                    and f.sngc13Tdoc=pd.PETDOC
                                                                                    and f.sngc13Ndoc=pd.PENDOC
                                                                                    and f.SNGC13EST='H'
                                                                                    order by sngc13RDes asc 
                                                                            )LOOP
                                                                                      JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                            END LOOP;--SNGC13
                                                                            --DBMS_OUTPUT.PUT_LINE ('AMBAS: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                            INSERT INTO JAQN451 (
                                                                                            JAQN451COD,
                                                                                            JAQN451FGE,
                                                                                            JAQN451PAI,
                                                                                            JAQN451TDO,
                                                                                            JAQN451NDO,
                                                                                            JAQN451APE,
                                                                                            JAQN451CE1,
                                                                                            JAQN451CE2,
                                                                                            JAQN451CE3,
                                                                                            JAQN451CO1,
                                                                                            JAQN451CO2,
                                                                                            JAQN451CO3,
                                                                                            JAQN451DIR)
                                                                                  VALUES (
                                                                                            JAQNCOD,
                                                                                            JAQNFGE,
                                                                                            JA_PAISOUT,
                                                                                            JA_TIPOOUT,
                                                                                            JA_NUMERODOUT,
                                                                                            JA_NOMBREOUT,
                                                                                            JA_CELULAR1OUT,
                                                                                            JA_CELULAR2OUT,
                                                                                            JA_CELULAR3OUT,
                                                                                            JA_MAILOUT,
                                                                                            JA_MAILOUT1,
                                                                                            JA_MAILOUT2,
                                                                                            JA_DIRECCIONOUT);
                                                                                  commit;
                                                                                  
                                                                                  JA_MAILOUT :=null;   
                                                                                  JA_MAILOUT1 :=null;   
                                                                                  JA_MAILOUT2 :=null;  
                                                                                  JA_CELULAR1OUT :=null;
                                                                                  JA_CELULAR2OUT :=null;
                                                                                  JA_CELULAR3OUT :=null;
                                                                      END LOOP;--FSD002
                                                                  
                                                                  END CASE;
                                                          END LOOP;
                
                                                    END IF;
                                                    
                                                    
                                                WHEN JA_ESTADO='I' then
                                                    IF ad.SCSTAT =81 THEN
                                                      --DBMS_OUTPUT.PUT_LINE ('ESTADO I: '||ad.SCSTAT ||'-'||ad.PGCOD||'-' ||ad.SCCTA||'-' ||ad.SCMOD||'-' ||ad.SCTOPE);
                                                             
                                                                    FOR pd IN (
                                                                        SELECT b.PEPAIS,b.PETDOC, b.PENDOC 
                                                                        into  appais,
                                                                              apetdoc,
                                                                              apendoc
                                                                        from fsr008 b
                                                                        where b.PGCOD=ad.PGCOD
                                                                        and b.CTNRO=ad.SCCTA
                                                                        and b.TTCOD='1')
                                                                    LOOP
                                                                      
                                                                      INSERT INTO JAQN452 (
                                                                                  JAQN452COD,
                                                                                  JAQN452PAI,
                                                                                  JAQN452TDO,
                                                                                  JAQN452NDO,
                                                                                  JAQN452EMP,--EMPRESA
                                                                                  JAQN452MOD,--MODULO
                                                                                  JAQN452SUC,--SUCURSAL
                                                                                  JAQN452MDA,--MONEDA
                                                                                  JAQN452PAP,--PAPEL
                                                                                  JAQN452CTA,--CUENTA
                                                                                  JAQN452OPE,--OPERACION
                                                                                  JAQN452SBO,--SUB TIPO DE OPERACION
                                                                                  JAQN452TOP)--TIPO DE OPERACION
                                                                      VALUES (  JAQNCOD,
                                                                                  pd.PEPAIS,
                                                                                  pd.PETDOC,
                                                                                  pd.PENDOC,
                                                                                  ad.PGCOD,--EMPRESA
                                                                                  ad.SCMOD,--MODULO
                                                                                  ad.SCSUC,--SUCURSAL
                                                                                  ad.SCMDA,--MONEDA
                                                                                  ad.SCPAP,--PAPEL
                                                                                  ad.SCCTA,--CUENTA
                                                                                  ad.SCOPER,--OPERACION
                                                                                  ad.SCSBOP,--SUB TIPO DE OPERACION
                                                                                  ad.SCTOPE
                                                                                  );
                                                                      commit;
                                                                    
                                                                        CASE  
                                                                            WHEN TIPO_PERSONA = 'N' then
                                                                            
                                                                                FOR pn IN (
                                                                                SELECT c.PFPAIS,c.PFTDOC, c.PFNDOC,c.PFAPE1,c.PFAPE2,c.PFNOM1,c.PFNOM2
                                                                                into  nppais,
                                                                                      npetdoc,
                                                                                      npendoc,
                                                                                      nape1,
                                                                                      nape2,
                                                                                      nnom1,
                                                                                      nnom2
                                                                                from fsd002 c
                                                                                where c.PFPAIS=pd.PEPAIS
                                                                                and c.PFTDOC=pd.PETDOC
                                                                                and c.PFNDOC=pd.PENDOC
                                                                                 and c.PFNDOC NOT IN (
                                                                                  (SELECT JAQN451NDO
                                                                                   FROM JAQN451
                                                                                   WHERE JAQN451COD=JAQNCOD
                                                                                   AND JAQN451FGE=JAQNFGE
                                                                                    )
                                                                                  )
                                                                                )
                                                                              LOOP
                                                                                  JA_PAISOUT := pd.PEPAIS;
                                                                                  JA_TIPOOUT := pd.PETDOC;
                                                                                  JA_NUMERODOUT := pd.PENDOC;
                                                                                  JA_NOMBREOUT := TRIM(pn.PFAPE1)||' '||TRIM(pn.PFAPE2)||' '||TRIM(pn.PFNOM1)||' '||TRIM(pn.PFNOM2);
                                                                                  countn:=0;
                                                                                  counte:=0;
                                                                                  
                                                                                      FOR pc IN (
                                                                                            SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                                            into  ddotelfp,
                                                                                                  ddocod,
                                                                                                  ddoorp,
                                                                                                  nueve
                                                                                            from fsr005 d
                                                                                            where d.PEPAIS=pd.PEPAIS
                                                                                            and d.PETDOC=pd.PETDOC
                                                                                            and d.PENDOC=pd.PENDOC
                                                                                            ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                                      )LOOP
                                                                                                largo := length(pc.DOTELFP);
                                                                                                largocel := 9;
                                                                                                emp:=SUBSTR(pc.DOTELFP,1,1);
                                                                                                if largo = largocel and emp=9 and pc.CANT<>9 and countn<3 then
                                                                                                  if countn=0 then
                                                                                                    JA_CELULAR1OUT :=pc.DOTELFP;
                                                                                                  end if;
                                                                                                  if countn=1 and JA_CELULAR1OUT <> pc.DOTELFP  then
                                                                                                    JA_CELULAR2OUT :=pc.DOTELFP;
                                                                                                  end if;
                                                                                                  if countn=2 and JA_CELULAR1OUT <> pc.DOTELFP  and JA_CELULAR2OUT <> pc.DOTELFP then
                                                                                                    JA_CELULAR3OUT :=pc.DOTELFP;
                                                                                                  end if;
                                                                                                  countn := countn + 1;
                                                                                                end if;         
                                                                                       END LOOP;
                                                                                       
                                                                                       FOR pe IN (
                                                                                            SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                                            into  email
                                                                                            from FSX001 e
                                                                                            where e.PEPAIS=pd.PEPAIS
                                                                                            and e.PETDOC=pd.PETDOC
                                                                                            and e.PENDOC=pd.PENDOC
                                                                                            and e.TXCOD=0
                                                                                            and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                                            and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                                            (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                               FROM JAQN454)
                                                                                            )
                                                                                            ORDER BY PEXREN DESC
                                                                                        )LOOP
                                                                                              if counte<3 then
                                                                                                  if counte=0 then
                                                                                                    JA_MAILOUT :=regexp_substr(pe.PEXTXT,'[^\]*');   
                                                                                                  end if;
                                                                                                  if counte=1 then
                                                                                                    JA_MAILOUT1 :=regexp_substr(pe.PEXTXT,'[^\]*');   
                                                                                                  end if;
                                                                                                  if counte=2 then
                                                                                                    JA_MAILOUT2 :=regexp_substr(pe.PEXTXT,'[^\]*');   
                                                                                                  end if;
                                                                                                  counte := counte + 1;
                                                                                              end if; 
                          
                                                                                        END LOOP;
                                                                                       
                                                                                       FOR ps IN (
                                                                                                SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                                into  
                                                                                                SNGC13ppais,
                                                                                                SNGC13petdoc,
                                                                                                SNGC13pendoc,
                                                                                                sDocod,
                                                                                                      ssngc13Dir,
                                                                                                      ssngc13RDes
                                                                                                from SNGC13 f
                                                                                                where f.sngc13Pais=pd.PEPAIS
                                                                                                and f.sngc13Tdoc=pd.PETDOC
                                                                                                and f.sngc13Ndoc=pd.PENDOC
                                                                                                and f.SNGC13EST='H'
                                                                                                order by sngc13RDes asc 
                                                                                        )LOOP
                                                                                              JA_DIRECCIONOUT := ps.sngc13Dir;
                                                                                        END LOOP;
                                                                                        
                                                                                        --DBMS_OUTPUT.PUT_LINE ('CUENTA: '|| ad.SCCTA );
                                                                                        --DBMS_OUTPUT.PUT_LINE ('NATURAL:'||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'||JA_MAILOUT1||'-'||JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                                        INSERT INTO JAQN451 (
                                                                                                      JAQN451COD,
                                                                                                      JAQN451FGE,
                                                                                                      JAQN451PAI,
                                                                                                      JAQN451TDO,
                                                                                                      JAQN451NDO,
                                                                                                      JAQN451APE,
                                                                                                      JAQN451CE1,
                                                                                                      JAQN451CE2,
                                                                                                      JAQN451CE3,
                                                                                                      JAQN451CO1,
                                                                                                      JAQN451CO2,
                                                                                                      JAQN451CO3,
                                                                                                      JAQN451DIR)
                                                                                            VALUES (
                                                                                                      JAQNCOD,
                                                                                                      JAQNFGE,
                                                                                                      JA_PAISOUT,
                                                                                                      JA_TIPOOUT,
                                                                                                      JA_NUMERODOUT,
                                                                                                      JA_NOMBREOUT,
                                                                                                      JA_CELULAR1OUT,
                                                                                                      JA_CELULAR2OUT,
                                                                                                      JA_CELULAR3OUT,
                                                                                                      JA_MAILOUT,
                                                                                                      JA_MAILOUT1,
                                                                                                      JA_MAILOUT2,
                                                                                                      JA_DIRECCIONOUT);
                                                                                            commit;
                                                                                            
                                                                                            JA_MAILOUT :=null;   
                                                                                            JA_MAILOUT1 :=null;   
                                                                                            JA_MAILOUT2 :=null;  
                                                                                            JA_CELULAR1OUT :=null;
                                                                                            JA_CELULAR2OUT :=null;
                                                                                            JA_CELULAR3OUT :=null;
                                                                                          --DBMS_OUTPUT.PUT_LINE ('ESTADO A: '||ad.SCSTAT ||'-'||ad.PGCOD||'-' ||ad.SCCTA||'-' ||ad.SCMOD||'-' ||ad.SCTOPE||'-' ||pd.PEPAIS||'-' ||pd.PETDOC||'-' ||pd.PENDOC);
                                                                   
                                                                              END LOOP;--FSD001
                                                                            
                                                                  WHEN TIPO_PERSONA = 'J' then
                                                                                FOR pg IN (
                                                                                    SELECT g.PJRAZS
                                                                                    into gPjrazs
                                                                                    from fsd003 g
                                                                                    where g.Pjpais=pd.PEPAIS
                                                                                    and g.Pjtdoc=pd.PETDOC
                                                                                    and g.Pjndoc=pd.PENDOC
                                                                                    and g.Pjndoc NOT IN (
                                                                                    (SELECT JAQN451NDO
                                                                                     FROM JAQN451
                                                                                     WHERE JAQN451COD=JAQNCOD
                                                                                     AND JAQN451FGE=JAQNFGE
                                                                                      )
                                                                                    )
                                                                                )LOOP
                                                                                      JA_PAISOUT := pd.PEPAIS;
                                                                                      JA_TIPOOUT := pd.PETDOC;
                                                                                      JA_NUMERODOUT := pd.PENDOC;
                                                                                      JA_NOMBREOUT := pg.PJRAZS;
                                                                                      countn:=0;
                                                                                      counte:=0;
                                                                                      FOR ph IN (
                                                                                              SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                                              into  ddotelfp,
                                                                                                    ddocod,
                                                                                                    ddoorp,
                                                                                                    nueve
                                                                                              from fsr005 d
                                                                                              where d.PEPAIS=pd.PEPAIS
                                                                                              and d.PETDOC=pd.PETDOC
                                                                                              and d.PENDOC=pd.PENDOC
                                                                                              ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                                    )LOOP
                                                                                              largo := length(ph.DOTELFP);
                                                                                              largocel := 9;
                                                                                              emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                                              if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                                  if countn=0 then
                                                                                                    JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                                  end if;
                                                                                                  if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP then
                                                                                                    JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                                  end if;
                                                                                                  if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP  and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                                    JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                                  end if;
                                                                                                  countn := countn + 1;
                                                                                              end if;
                                                                                     END LOOP;--FSR005
                                                                                     
                                                                                     FOR pi IN (
                                                                                      SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                                      into  email
                                                                                      from FSX001 e
                                                                                      where e.PEPAIS=pd.PEPAIS
                                                                                      and e.PETDOC=pd.PETDOC
                                                                                      and e.PENDOC=pd.PENDOC
                                                                                      and e.TXCOD=0
                                                                                      and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                                      and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                                        (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                               FROM JAQN454)
                                                                                            )
                                                                                      ORDER BY PEXREN DESC
                                                                                      )LOOP
                                                                                              if counte<3 then
                                                                                                  if counte=0 then
                                                                                                    JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                                  end if;
                                                                                                  if counte=1 then
                                                                                                    JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                                  end if;
                                                                                                  if counte=2 then
                                                                                                    JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                                  end if;
                                                                                                  counte := counte + 1;
                                                                                              end if; 
                                                                                      END LOOP;--FSX001
                                                                                      
                                                                                      
                                                                                      
                                                                                      FOR pj IN (
                                                                                              SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                              into  
                                                                                              SNGC13ppais,
                                                                                              SNGC13petdoc,
                                                                                              SNGC13pendoc,
                                                                                              sDocod,
                                                                                                    ssngc13Dir,
                                                                                                    ssngc13RDes
                                                                                              from SNGC13 f
                                                                                              where f.sngc13Pais=pd.PEPAIS
                                                                                              and f.sngc13Tdoc=pd.PETDOC
                                                                                              and f.sngc13Ndoc=pd.PENDOC
                                                                                              and f.SNGC13EST='H'
                                                                                              order by sngc13RDes asc 
                                                                                      )LOOP
                                                                                                JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                                      END LOOP;--SNGC13
                                                                                      --DBMS_OUTPUT.PUT_LINE ('JURIDICA: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                                      INSERT INTO JAQN451 (
                                                                                                      JAQN451COD,
                                                                                                      JAQN451FGE,
                                                                                                      JAQN451PAI,
                                                                                                      JAQN451TDO,
                                                                                                      JAQN451NDO,
                                                                                                      JAQN451APE,
                                                                                                      JAQN451CE1,
                                                                                                      JAQN451CE2,
                                                                                                      JAQN451CE3,
                                                                                                      JAQN451CO1,
                                                                                                      JAQN451CO2,
                                                                                                      JAQN451CO3,
                                                                                                      JAQN451DIR)
                                                                                            VALUES (
                                                                                                      JAQNCOD,
                                                                                                      JAQNFGE,
                                                                                                      JA_PAISOUT,
                                                                                                      JA_TIPOOUT,
                                                                                                      JA_NUMERODOUT,
                                                                                                      JA_NOMBREOUT,
                                                                                                      JA_CELULAR1OUT,
                                                                                                      JA_CELULAR2OUT,
                                                                                                      JA_CELULAR3OUT,
                                                                                                      JA_MAILOUT,
                                                                                                      JA_MAILOUT1,
                                                                                                      JA_MAILOUT2,
                                                                                                      JA_DIRECCIONOUT);
                                                                                            commit;
                                                                                            
                                                                                            JA_MAILOUT :=null;   
                                                                                            JA_MAILOUT1 :=null;   
                                                                                            JA_MAILOUT2 :=null;  
                                                                                            JA_CELULAR1OUT :=null;
                                                                                            JA_CELULAR2OUT :=null;
                                                                                            JA_CELULAR3OUT :=null;
                                                                                END LOOP;--FSD002
                                                                                
                                                                                
                                                                                
                                                                                
                                                                  WHEN TIPO_PERSONA = 'A' then
                                                                                FOR pg IN (
                                                                                    SELECT k.PENOM
                                                                                    into aPenom
                                                                                    from fsd001 k
                                                                                    where k.Pepais=pd.PEPAIS
                                                                                    and k.Petdoc=pd.PETDOC
                                                                                    and k.Pendoc=pd.PENDOC
                                                                                    and k.Pendoc NOT IN (
                                                                                    (SELECT JAQN451NDO
                                                                                     FROM JAQN451
                                                                                     WHERE JAQN451COD=JAQNCOD
                                                                                     AND JAQN451FGE=JAQNFGE
                                                                                      )
                                                                                    )
                                                                                )LOOP
                                                                                      JA_PAISOUT := pd.PEPAIS;
                                                                                      JA_TIPOOUT := pd.PETDOC;
                                                                                      JA_NUMERODOUT := pd.PENDOC;
                                                                                      JA_NOMBREOUT := pg.PENOM;
                                                                                      countn:=0;
                                                                                      counte:=0;
                                                                                      FOR ph IN (
                                                                                              SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                                              into  ddotelfp,
                                                                                                    ddocod,
                                                                                                    ddoorp,
                                                                                                    nueve
                                                                                              from fsr005 d
                                                                                              where d.PEPAIS=pd.PEPAIS
                                                                                              and d.PETDOC=pd.PETDOC
                                                                                              and d.PENDOC=pd.PENDOC
                                                                                              ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                                    )LOOP
                                                                                              largo := length(ph.DOTELFP);
                                                                                              largocel := 9;
                                                                                              emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                                              if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                                  if countn=0 then
                                                                                                    JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                                  end if;
                                                                                                  if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP  then
                                                                                                    JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                                  end if;
                                                                                                  if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP  and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                                    JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                                  end if;
                                                                                                  countn := countn + 1;
                                                                                              end if;
                                                                                     END LOOP;--FSR005
                                                                                     
                                                                                     FOR pi IN (
                                                                                      SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                                      into  email
                                                                                      from FSX001 e
                                                                                      where e.PEPAIS=pd.PEPAIS
                                                                                      and e.PETDOC=pd.PETDOC
                                                                                      and e.PENDOC=pd.PENDOC
                                                                                      and e.TXCOD=0
                                                                                      and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                                      and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                                      (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                               FROM JAQN454)
                                                                                            )
                                                                                      ORDER BY PEXREN DESC
                                                                                      )LOOP
                                                                                              if counte<3 then
                                                                                                  if counte=0 then
                                                                                                    JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                                  end if;
                                                                                                  if counte=1 then
                                                                                                    JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                                  end if;
                                                                                                  if counte=2 then
                                                                                                    JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                                  end if;
                                                                                                  counte := counte + 1;
                                                                                              end if; 
                                                                                      END LOOP;--FSX001
                                                                                      
                                                                                      
                                                                                      
                                                                                      FOR pj IN (
                                                                                              SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                              into  
                                                                                              SNGC13ppais,
                                                                                              SNGC13petdoc,
                                                                                              SNGC13pendoc,
                                                                                              sDocod,
                                                                                                    ssngc13Dir,
                                                                                                    ssngc13RDes
                                                                                              from SNGC13 f
                                                                                              where f.sngc13Pais=pd.PEPAIS
                                                                                              and f.sngc13Tdoc=pd.PETDOC
                                                                                              and f.sngc13Ndoc=pd.PENDOC
                                                                                              and f.SNGC13EST='H'
                                                                                              order by sngc13RDes asc 
                                                                                      )LOOP
                                                                                                JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                                      END LOOP;--SNGC13
                                                                                      --DBMS_OUTPUT.PUT_LINE ('AMBAS: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                                      INSERT INTO JAQN451 (
                                                                                                      JAQN451COD,
                                                                                                      JAQN451FGE,
                                                                                                      JAQN451PAI,
                                                                                                      JAQN451TDO,
                                                                                                      JAQN451NDO,
                                                                                                      JAQN451APE,
                                                                                                      JAQN451CE1,
                                                                                                      JAQN451CE2,
                                                                                                      JAQN451CE3,
                                                                                                      JAQN451CO1,
                                                                                                      JAQN451CO2,
                                                                                                      JAQN451CO3,
                                                                                                      JAQN451DIR)
                                                                                            VALUES (
                                                                                                      JAQNCOD,
                                                                                                      JAQNFGE,
                                                                                                      JA_PAISOUT,
                                                                                                      JA_TIPOOUT,
                                                                                                      JA_NUMERODOUT,
                                                                                                      JA_NOMBREOUT,
                                                                                                      JA_CELULAR1OUT,
                                                                                                      JA_CELULAR2OUT,
                                                                                                      JA_CELULAR3OUT,
                                                                                                      JA_MAILOUT,
                                                                                                      JA_MAILOUT1,
                                                                                                      JA_MAILOUT2,
                                                                                                      JA_DIRECCIONOUT);
                                                                                            commit;
                                                                                           
                                                                                            JA_MAILOUT :=null;   
                                                                                            JA_MAILOUT1 :=null;   
                                                                                            JA_MAILOUT2 :=null;  
                                                                                            JA_CELULAR1OUT :=null;
                                                                                            JA_CELULAR2OUT :=null;
                                                                                            JA_CELULAR3OUT :=null;
                                                                                END LOOP;--FSD002
                                                                                
                                                                            END CASE;
                                                                    END LOOP;
                                                          
                                                    END IF; --ESTADO I
                                                    
                                                WHEN JA_ESTADO='T' then
                                                   
                                                    FOR pd IN (
                                                        SELECT b.PEPAIS,b.PETDOC, b.PENDOC 
                                                        into  appais,
                                                              apetdoc,
                                                              apendoc
                                                        from fsr008 b
                                                        where b.PGCOD=ad.PGCOD
                                                        and b.CTNRO=ad.SCCTA
                                                        and b.TTCOD='1')
                                                    LOOP
                                                      INSERT INTO JAQN452 (
                                                                JAQN452COD,
                                                                JAQN452PAI,
                                                                JAQN452TDO,
                                                                JAQN452NDO,
                                                                JAQN452EMP,--EMPRESA
                                                                JAQN452MOD,--MODULO
                                                                JAQN452SUC,--SUCURSAL
                                                                JAQN452MDA,--MONEDA
                                                                JAQN452PAP,--PAPEL
                                                                JAQN452CTA,--CUENTA
                                                                JAQN452OPE,--OPERACION
                                                                JAQN452SBO,--SUB TIPO DE OPERACION
                                                                JAQN452TOP)--TIPO DE OPERACION
                                                    VALUES (  JAQNCOD,
                                                                pd.PEPAIS,
                                                                pd.PETDOC,
                                                                pd.PENDOC,
                                                                ad.PGCOD,--EMPRESA
                                                                ad.SCMOD,--MODULO
                                                                ad.SCSUC,--SUCURSAL
                                                                ad.SCMDA,--MONEDA
                                                                ad.SCPAP,--PAPEL
                                                                ad.SCCTA,--CUENTA
                                                                ad.SCOPER,--OPERACION
                                                                ad.SCSBOP,--SUB TIPO DE OPERACION
                                                                ad.SCTOPE
                                                                );
                                                    commit;
                                                    
                                                        CASE  
                                                            WHEN TIPO_PERSONA = 'N' then
                                                            --DBMS_OUTPUT.PUT_LINE ('N: ');
                                                                FOR pn IN (
                                                                SELECT  c.PFPAIS,c.PFTDOC, c.PFNDOC,c.PFAPE1,c.PFAPE2,c.PFNOM1,c.PFNOM2
                                                                into  nppais,
                                                                      npetdoc,
                                                                      npendoc,
                                                                      nape1,
                                                                      nape2,
                                                                      nnom1,
                                                                      nnom2
                                                                from fsd002 c
                                                                where c.PFPAIS=pd.PEPAIS
                                                                and c.PFTDOC=pd.PETDOC
                                                                and c.PFNDOC=pd.PENDOC
                                                                and c.PFNDOC NOT IN (
                                                                            (SELECT JAQN451NDO
                                                                             FROM JAQN451
                                                                             WHERE JAQN451COD=JAQNCOD
                                                                             AND JAQN451FGE=JAQNFGE
                                                                              )
                                                                 )
                                                                )
                                                              LOOP
                                                                  JA_PAISOUT := pd.PEPAIS;
                                                                  JA_TIPOOUT := pd.PETDOC;
                                                                  JA_NUMERODOUT := pd.PENDOC;
                                                                  JA_NOMBREOUT := TRIM(pn.PFAPE1)||' '||TRIM(pn.PFAPE2)||' '||TRIM(pn.PFNOM1)||' '||TRIM(pn.PFNOM2);
                                                                  countn:=0;
                                                                  counte:=0;
                                                                  
                                                                      FOR pc IN (
                                                                            SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                            into  ddotelfp,
                                                                                  ddocod,
                                                                                  ddoorp,
                                                                                  nueve
                                                                            from fsr005 d
                                                                            where d.PEPAIS=pd.PEPAIS
                                                                            and d.PETDOC=pd.PETDOC
                                                                            and d.PENDOC=pd.PENDOC
                                                                            ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                      )LOOP
                                                                                largo := length(pc.DOTELFP);
                                                                                largocel := 9;
                                                                                emp:=SUBSTR(pc.DOTELFP,1,1);
                                                                                if largo = largocel and emp=9 and pc.CANT<>9 and countn<3 then
                                                                                  if countn=0 then
                                                                                    JA_CELULAR1OUT :=pc.DOTELFP;
                                                                                  end if;
                                                                                  if countn=1 and JA_CELULAR1OUT <> pc.DOTELFP  then
                                                                                    JA_CELULAR2OUT :=pc.DOTELFP;
                                                                                  end if;
                                                                                  if countn=2 and JA_CELULAR1OUT <> pc.DOTELFP  and JA_CELULAR2OUT <> pc.DOTELFP then
                                                                                    JA_CELULAR3OUT :=pc.DOTELFP;
                                                                                  end if;
                                                                                  countn := countn + 1;
                                                                                end if;         
                                                                       END LOOP;
                                                                       
                                                                       FOR pe IN (
                                                                            SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                            into  email
                                                                            from FSX001 e
                                                                            where e.PEPAIS=pd.PEPAIS
                                                                            and e.PETDOC=pd.PETDOC
                                                                            and e.PENDOC=pd.PENDOC
                                                                            and e.TXCOD=0
                                                                            and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                            and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                            (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                 FROM JAQN454)
                                                                            )
                                                                            ORDER BY PEXREN DESC
                                                                        )LOOP
                                                                               --DBMS_OUTPUT.PUT_LINE ('EMAIL BAA: A '||regexp_substr(pe.PEXTXT,'[^\]*'));
                                                                          --if regexp_substr(pe.PEXTXT,'[^\]*')<>null OR regexp_substr(pe.PEXTXT,'[^\]*')<>'' then    
                                                                            if counte<3 then
                                                                                  if counte=0 then
                                                                                      JA_MAILOUT :=regexp_substr(pe.PEXTXT,'[^\]*');                    
                                                                                  end if;
                                                                                  if counte=1 then
                                                                                      JA_MAILOUT1 :=regexp_substr(pe.PEXTXT,'[^\]*');  
                                                                                  end if;
                                                                                  if counte=2 then
                                                                                      JA_MAILOUT2 :=regexp_substr(pe.PEXTXT,'[^\]*');
                                                                                  end if;
                                                                                  counte := counte + 1;                      
                                                                            end if;       
                                                                        --end if;            
                                                                        END LOOP;
                                                                       
                                                                       FOR ps IN (
                                                                                SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                                into  
                                                                                SNGC13ppais,
                                                                                SNGC13petdoc,
                                                                                SNGC13pendoc,
                                                                                sDocod,
                                                                                      ssngc13Dir,
                                                                                      ssngc13RDes
                                                                                from SNGC13 f
                                                                                where f.sngc13Pais=pd.PEPAIS
                                                                                and f.sngc13Tdoc=pd.PETDOC
                                                                                and f.sngc13Ndoc=pd.PENDOC
                                                                                and f.SNGC13EST='H'
                                                                                order by sngc13RDes asc 
                                                                        )LOOP
                                                                              JA_DIRECCIONOUT := ps.sngc13Dir;
                                                                        END LOOP;
                                                                        
                                                                      --DBMS_OUTPUT.PUT_LINE ('NATURAL:'||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'||JA_MAILOUT1||'-'||JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                      INSERT INTO JAQN451 (
                                                                                      JAQN451COD,
                                                                                      JAQN451FGE,
                                                                                      JAQN451PAI,
                                                                                      JAQN451TDO,
                                                                                      JAQN451NDO,
                                                                                      JAQN451APE,
                                                                                      JAQN451CE1,
                                                                                      JAQN451CE2,
                                                                                      JAQN451CE3,
                                                                                      JAQN451CO1,
                                                                                      JAQN451CO2,
                                                                                      JAQN451CO3,
                                                                                      JAQN451DIR)
                                                                            VALUES (
                                                                                      JAQNCOD,
                                                                                      JAQNFGE,
                                                                                      JA_PAISOUT,
                                                                                      JA_TIPOOUT,
                                                                                      JA_NUMERODOUT,
                                                                                      JA_NOMBREOUT,
                                                                                      JA_CELULAR1OUT,
                                                                                      JA_CELULAR2OUT,
                                                                                      JA_CELULAR3OUT,
                                                                                      JA_MAILOUT,
                                                                                      JA_MAILOUT1,
                                                                                      JA_MAILOUT2,
                                                                                      JA_DIRECCIONOUT);
                                                                            commit;
                                                                            
                                                                            JA_MAILOUT :=null;   
                                                                            JA_MAILOUT1 :=null;   
                                                                            JA_MAILOUT2 :=null;  
                                                                            JA_CELULAR1OUT :=null;
                                                                            JA_CELULAR2OUT :=null;
                                                                            JA_CELULAR3OUT :=null;
                                                                          --DBMS_OUTPUT.PUT_LINE ('ESTADO A: '||ad.SCSTAT ||'-'||ad.PGCOD||'-' ||ad.SCCTA||'-' ||ad.SCMOD||'-' ||ad.SCTOPE||'-' ||pd.PEPAIS||'-' ||pd.PETDOC||'-' ||pd.PENDOC);
                                                   
                                                              END LOOP;--FSD001
                                                            
                                                  WHEN TIPO_PERSONA = 'J' then
                                                                FOR pg IN (
                                                                    SELECT  g.PJRAZS
                                                                    into gPjrazs
                                                                    from fsd003 g
                                                                    where g.Pjpais=pd.PEPAIS
                                                                    and g.Pjtdoc=pd.PETDOC
                                                                    and g.Pjndoc=pd.PENDOC
                                                                    and g.Pjndoc NOT IN (
                                                                            (SELECT JAQN451NDO
                                                                             FROM JAQN451
                                                                             WHERE JAQN451COD=JAQNCOD
                                                                             AND JAQN451FGE=JAQNFGE
                                                                              )
                                                                 )
                                                                )LOOP
                                                                      JA_PAISOUT := pd.PEPAIS;
                                                                      JA_TIPOOUT := pd.PETDOC;
                                                                      JA_NUMERODOUT := pd.PENDOC;
                                                                      JA_NOMBREOUT := pg.PJRAZS;
                                                                      countn:=0;
                                                                      counte:=0;
                                                                      FOR ph IN (
                                                                              SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                              into  ddotelfp,
                                                                                    ddocod,
                                                                                    ddoorp,
                                                                                    nueve
                                                                              from fsr005 d
                                                                              where d.PEPAIS=pd.PEPAIS
                                                                              and d.PETDOC=pd.PETDOC
                                                                              and d.PENDOC=pd.PENDOC
                                                                              ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                    )LOOP
                                                                              largo := length(ph.DOTELFP);
                                                                              largocel := 9;
                                                                              emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                              if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                  if countn=0 then
                                                                                    JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP then
                                                                                    JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP  and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                    JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  countn := countn + 1;
                                                                              end if;
                                                                     END LOOP;--FSR005
                                                                     
                                                                     FOR pi IN (
                                                                      SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                      into  email
                                                                      from FSX001 e
                                                                      where e.PEPAIS=pd.PEPAIS
                                                                      and e.PETDOC=pd.PETDOC
                                                                      and e.PENDOC=pd.PENDOC
                                                                      and e.TXCOD=0
                                                                      and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                      and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                            (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                 FROM JAQN454)
                                                                            )
                                                                      ORDER BY PEXREN DESC
                                                                      )LOOP
                                                                              if counte<3 then
                                                                                  if counte=0 then
                                                                                    JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=1 then
                                                                                    JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=2 then
                                                                                    JA_MAILOUT2 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  counte := counte + 1;
                                                                              end if; 
                                                                      END LOOP;--FSX001
                                                                      
                                                                      
                                                                      
                                                                      FOR pj IN (
                                                                              SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                              into  
                                                                              SNGC13ppais,
                                                                              SNGC13petdoc,
                                                                              SNGC13pendoc,
                                                                              sDocod,
                                                                                    ssngc13Dir,
                                                                                    ssngc13RDes
                                                                              from SNGC13 f
                                                                              where f.sngc13Pais=pd.PEPAIS
                                                                              and f.sngc13Tdoc=pd.PETDOC
                                                                              and f.sngc13Ndoc=pd.PENDOC
                                                                              and f.SNGC13EST='H'
                                                                              order by sngc13RDes asc 
                                                                      )LOOP
                                                                                JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                      END LOOP;--SNGC13
                                                                      --DBMS_OUTPUT.PUT_LINE ('JURIDICA: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                      INSERT INTO JAQN451 (
                                                                                      JAQN451COD,
                                                                                      JAQN451FGE,
                                                                                      JAQN451PAI,
                                                                                      JAQN451TDO,
                                                                                      JAQN451NDO,
                                                                                      JAQN451APE,
                                                                                      JAQN451CE1,
                                                                                      JAQN451CE2,
                                                                                      JAQN451CE3,
                                                                                      JAQN451CO1,
                                                                                      JAQN451CO2,
                                                                                      JAQN451CO3,
                                                                                      JAQN451DIR)
                                                                            VALUES (
                                                                                      JAQNCOD,
                                                                                      JAQNFGE,
                                                                                      JA_PAISOUT,
                                                                                      JA_TIPOOUT,
                                                                                      JA_NUMERODOUT,
                                                                                      JA_NOMBREOUT,
                                                                                      JA_CELULAR1OUT,
                                                                                      JA_CELULAR2OUT,
                                                                                      JA_CELULAR3OUT,
                                                                                      JA_MAILOUT,
                                                                                      JA_MAILOUT1,
                                                                                      JA_MAILOUT2,
                                                                                      JA_DIRECCIONOUT);
                                                                            commit;
                                                                            
                                                                            
                                                                            JA_MAILOUT :=null;   
                                                                            JA_MAILOUT1 :=null;   
                                                                            JA_MAILOUT2 :=null;  
                                                                            JA_CELULAR1OUT :=null;
                                                                            JA_CELULAR2OUT :=null;
                                                                            JA_CELULAR3OUT :=null;
                                                                END LOOP;--FSD002
                                                                
                                                                
                                                  WHEN TIPO_PERSONA = 'A' then
                                                                FOR pg IN (
                                                                    SELECT  k.PENOM
                                                                    into aPenom
                                                                    from fsd001 k
                                                                    where k.Pepais=pd.PEPAIS
                                                                    and k.Petdoc=pd.PETDOC
                                                                    and k.Pendoc=pd.PENDOC
                                                                    and k.Pendoc NOT IN (
                                                                            (SELECT JAQN451NDO
                                                                             FROM JAQN451
                                                                             WHERE JAQN451COD=JAQNCOD
                                                                             AND JAQN451FGE=JAQNFGE
                                                                              )
                                                                      )
                                                                    
                                                                )LOOP
                                                                      JA_PAISOUT := pd.PEPAIS;
                                                                      JA_TIPOOUT := pd.PETDOC;
                                                                      JA_NUMERODOUT := pd.PENDOC;
                                                                      JA_NOMBREOUT := pg.PENOM;
                                                                      countn:=0;
                                                                      counte:=0;
                                                                      FOR ph IN (
                                                                              SELECT DISTINCT(TRIM(d.DOTELFP)) AS DOTELFP,d.DOCOD, d.DOORDP,length(d.DOTELFP) - length(replace(d.DOTELFP,'9')) AS CANT
                                                                              into  ddotelfp,
                                                                                    ddocod,
                                                                                    ddoorp,
                                                                                    nueve
                                                                              from fsr005 d
                                                                              where d.PEPAIS=pd.PEPAIS
                                                                              and d.PETDOC=pd.PETDOC
                                                                              and d.PENDOC=pd.PENDOC
                                                                              ORDER BY decode(d.DOCOD, 2,1,1,2,2,3,3,4,4,5,5,6) ASC
                                                                    )LOOP
                                                                              largo := length(ph.DOTELFP);
                                                                              largocel := 9;
                                                                              emp:=SUBSTR(ph.DOTELFP,1,1);
                                                                              if largo = largocel and emp=9 and ph.CANT<>9 then
                                                                                  if countn=0 then
                                                                                    JA_CELULAR1OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=1 and JA_CELULAR1OUT <> ph.DOTELFP  then
                                                                                    JA_CELULAR2OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  if countn=2 and JA_CELULAR1OUT <> ph.DOTELFP  and JA_CELULAR2OUT <> ph.DOTELFP then
                                                                                    JA_CELULAR3OUT :=ph.DOTELFP;
                                                                                  end if;
                                                                                  countn := countn + 1;
                                                                              end if;
                                                                     END LOOP;--FSR005
                                                                     
                                                                     FOR pi IN (
                                                                      SELECT TRIM(e.PEXTXT) AS PEXTXT
                                                                      into  email
                                                                      from FSX001 e
                                                                      where e.PEPAIS=pd.PEPAIS
                                                                      and e.PETDOC=pd.PETDOC
                                                                      and e.PENDOC=pd.PENDOC
                                                                      and e.TXCOD=0
                                                                      and REGEXP_LIKE (regexp_substr(PEXTXT,'[^\]*'),'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
                                                                      and regexp_substr(PEXTXT,'[^\]*') NOT IN (
                                                                            (SELECT TRIM(JAQN454MAI) AS JAQN454MAI 
                                                                                 FROM JAQN454)
                                                                            )
                                                                      ORDER BY PEXREN DESC
                                                                      )LOOP
                                                                              if counte<3 then
                                                                                  if counte=0 then
                                                                                    JA_MAILOUT :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=1 then
                                                                                    JA_MAILOUT1 :=regexp_substr(pi.PEXTXT,'[^\]*');   
                                                                                  end if;
                                                                                  if counte=2 then
                                                                                    JA_MAILOUT2 :=pi.PEXTXT;   
                                                                                  end if;
                                                                                  counte := counte + 1;
                                                                              end if; 
                                                                      END LOOP;--FSX001
                                                                      
                                                                      
                                                                      
                                                                      FOR pj IN (
                                                                              SELECT f.sngc13Pais,f.sngc13Tdoc,f.sngc13Ndoc,f.Docod,f.sngc13Dir,f.sngc13RDes
                                                                              into  
                                                                              SNGC13ppais,
                                                                              SNGC13petdoc,
                                                                              SNGC13pendoc,
                                                                              sDocod,
                                                                                    ssngc13Dir,
                                                                                    ssngc13RDes
                                                                              from SNGC13 f
                                                                              where f.sngc13Pais=pd.PEPAIS
                                                                              and f.sngc13Tdoc=pd.PETDOC
                                                                              and f.sngc13Ndoc=pd.PENDOC
                                                                              and f.SNGC13EST='H'
                                                                              order by sngc13RDes asc 
                                                                      )LOOP
                                                                                JA_DIRECCIONOUT := pj.sngc13Dir;
                                                                      END LOOP;--SNGC13
                                                                      --DBMS_OUTPUT.PUT_LINE ('AMBAS: '||JA_PAISOUT||'-'||JA_TIPOOUT||'-'||JA_NUMERODOUT||'-'|| JA_NOMBREOUT||'-'||JA_CELULAR1OUT||'-'||JA_CELULAR2OUT||'-'|| JA_CELULAR3OUT||'-'|| JA_MAILOUT||'-'|| JA_MAILOUT1||'-'|| JA_MAILOUT2||'-'|| JA_DIRECCIONOUT);
                                                                      INSERT INTO JAQN451 (
                                                                                      JAQN451COD,
                                                                                      JAQN451FGE,
                                                                                      JAQN451PAI,
                                                                                      JAQN451TDO,
                                                                                      JAQN451NDO,
                                                                                      JAQN451APE,
                                                                                      JAQN451CE1,
                                                                                      JAQN451CE2,
                                                                                      JAQN451CE3,
                                                                                      JAQN451CO1,
                                                                                      JAQN451CO2,
                                                                                      JAQN451CO3,
                                                                                      JAQN451DIR)
                                                                            VALUES (
                                                                                      JAQNCOD,
                                                                                      JAQNFGE,
                                                                                      JA_PAISOUT,
                                                                                      JA_TIPOOUT,
                                                                                      JA_NUMERODOUT,
                                                                                      JA_NOMBREOUT,
                                                                                      JA_CELULAR1OUT,
                                                                                      JA_CELULAR2OUT,
                                                                                      JA_CELULAR3OUT,
                                                                                      JA_MAILOUT,
                                                                                      JA_MAILOUT1,
                                                                                      JA_MAILOUT2,
                                                                                      JA_DIRECCIONOUT);
                                                                            commit;
                                                                            
                                                                            JA_MAILOUT :=null;   
                                                                            JA_MAILOUT1 :=null;   
                                                                            JA_MAILOUT2 :=null;  
                                                                            JA_CELULAR1OUT :=null;
                                                                            JA_CELULAR2OUT :=null;
                                                                            JA_CELULAR3OUT :=null;
                                                                END LOOP;--FSD002
                                                                
                                                            END CASE;
                                                    END LOOP;
                                                ---SIN ESTADO
                                                END CASE;
                                        END LOOP;
                                    END LOOP;
                      END IF;--MONEDA                        
      END CASE;

  NULL;
END SP_AH_CUENTAS_BT;
/

