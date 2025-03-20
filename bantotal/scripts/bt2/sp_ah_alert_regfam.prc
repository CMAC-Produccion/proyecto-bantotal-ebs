create or replace procedure SP_AH_ALERT_REGFAM is ---(Name in out type, Name in out type, ...) is

   cursor DNIEmp (usuario in varchar2)  is
     select distinct(jaqy667dnit) dninro , JAQY667NOMT nombre  from jaqy667
      Where JAQY667USER = usuario;
      
   cursor familia (nrodni in varchar2,usuario in varchar2) is
     select * from jaqy667
      Where JAQY667USER = usuario
      and  JAQY667DNIT = nrodni;
      
   CURSOR TODOSFAM IS
    SELECT SUM(T1.CONTADOR) TOTAL , 
           T1.DNI 
      FROM 
     (select COUNT(*) CONTADOR,
             t_iden.pfndoc DNI
        from fsd002 t_iden,
             fsr002 t_relf,
             fst020 t_desp,
             fsd002 t_idfa,
             
             fst014 t_tido,
             fsr003 t_rcaj,
             fst020 t_trel,
             
             fst014 t_tdfa,
             fsr003 t_rcfa,
             fst020 t_rcde
       where t_relf.pepais = t_iden.pfpais
         and t_relf.petdoc = t_iden.pftdoc
         and t_relf.pendoc = t_iden.pfndoc
         and t_desp.vicod = t_relf.rpccyg
         
         and t_idfa.pfpais = t_relf.rppais
         and t_idfa.pftdoc = t_relf.rptdoc
         and t_idfa.pfndoc = t_relf.rpndoc

         and t_tido.tdocum(+) = t_iden.pftdoc         
         and t_rcaj.pjndoc(+) = '20100209641 '
         and t_rcaj.pfndo1(+) = t_iden.pftdoc
         and t_trel.vicod(+) = t_rcaj.vicod
        
         and t_tdfa.tdocum(+) = t_idfa.pftdoc
          
         and t_rcfa.pjndoc(+) = '20100209641 '
         and t_rcfa.pfndo1(+) = t_idfa.pfndoc
         and t_rcde.vicod(+) = t_rcfa.vicod
         and t_iden.pfndoc  IN ('29242520','41097320','40760733','41471421','41892854','40060751','45316645','45353953','40014541',
         '47216030','29542050','29557429','47852329','47413165','30962703','40332079','45072614','29542050','46140580')
        GROUP BY t_iden.pfndoc
        --  and t_iden.pfndoc = '47216030'-- '29589266'
    union all

    select COUNT(*) CONTADOR, 
           t_iden.pfndoc  DNI               
      from fsd002 t_iden,
           fsr002 t_relf,
           fst020 t_desp,
           fsd002 t_idfa,
           
           fst014 t_tido,
           fsr003 t_rcaj,
           fst020 t_trel,
           
           fst014 t_tdfa,
           fsr003 t_rcfa,
           fst020 t_rcde
     where t_relf.rppais = t_iden.pfpais
       and t_relf.rptdoc = t_iden.pftdoc
       and t_relf.rpndoc = t_iden.pfndoc
       and t_desp.vicod = t_relf.rpccyg
          
       and t_idfa.pfpais = t_relf.pepais
       and t_idfa.pftdoc = t_relf.petdoc
       and t_idfa.pfndoc = t_relf.pendoc

       and t_tido.tdocum(+) = t_iden.pftdoc
          
       and t_rcaj.pjndoc(+) = '20100209641 '
       and t_rcaj.pfndo1(+) = t_iden.pftdoc
       and t_trel.vicod(+) = t_rcaj.vicod

       and t_tdfa.tdocum(+) = t_idfa.pftdoc
          
       and t_rcfa.pjndoc(+) = '20100209641 '
       and t_rcfa.pfndo1(+) = t_idfa.pfndoc
       and t_rcde.vicod(+) = t_rcfa.vicod
      and t_iden.pfndoc IN ('29242520','41097320','40760733','41471421','41892854','40060751','45316645','45353953','40014541',
         '47216030','29542050','29557429','47852329','47413165','30962703','40332079','45072614','29542050','46140580')
      GROUP BY t_iden.pfndoc) T1,  --'29589266'),
          FSD002 T2
    WHERE T1.DNI = T2.PFNDOC
      AND T2.PFEBCO = 'S'      
    GROUP BY T1.DNI;   

   CURSOR DESPLIEGUE(NRODOC IN VARCHAR2) IS
   SELECT *  FROM 
         (select trim(t_iden.pfnom1)NomTrabajador,
                 t_iden.pfndoc DNI,
                 t_iden.pffnac Fec_Nac,
                 t_iden.pfebco SN,
                 t_trel.vinom Rel_Caja,

                 t_relf.rpccyg Cod_rela,
                 t_desp.vinom Relacion,
                 trim(t_idfa.pfape1)||' '||trim(t_idfa.pfape2)||' '||trim(t_idfa.pfnom1)||' '||trim(t_idfa.pfnom2) Nom_Fam,
                 t_tdfa.tdnom Tip_Doc_Fam,
                 t_idfa.pfndoc DNI_Fam,
                 t_idfa.pffnac Fec_Nac_Fam,
                 t_rcde.vinom Vinc_Fam_con_Caja,
                 1 Tipo_Reg
            from fsd002 t_iden,
                 fsr002 t_relf,
                 fst020 t_desp,
                 fsd002 t_idfa,
                 
                 fst014 t_tido,
                 fsr003 t_rcaj,
                 fst020 t_trel,
                 
                 fst014 t_tdfa,
                 fsr003 t_rcfa,
                 fst020 t_rcde
           where t_relf.pepais = t_iden.pfpais
             and t_relf.petdoc = t_iden.pftdoc
             and t_relf.pendoc = t_iden.pfndoc
             and t_desp.vicod = t_relf.rpccyg
             
             and t_idfa.pfpais = t_relf.rppais
             and t_idfa.pftdoc = t_relf.rptdoc
             and t_idfa.pfndoc = t_relf.rpndoc

             and t_tido.tdocum(+) = t_iden.pftdoc
              
             and t_rcaj.pjndoc(+) = '20100209641 '
             and t_rcaj.pfndo1(+) = t_iden.pftdoc
             and t_trel.vicod(+) = t_rcaj.vicod
              
             and t_tdfa.tdocum(+) = t_idfa.pftdoc
              
             and t_rcfa.pjndoc(+) = '20100209641 '
             and t_rcfa.pfndo1(+) = t_idfa.pfndoc
             and t_rcde.vicod(+) = t_rcfa.vicod
              
             and t_iden.pfndoc =  NRODOC ---'47216030'--'47216030'-- '29589266' 02446903    
        union all
          select trim(t_iden.pfnom1) NomTrabajador,
                 t_iden.pfndoc DNI,             
                 t_iden.pffnac Fec_Nac,       
                 t_iden.pfebco SN,
                 t_trel.vinom Rel_Caja,       
                 
                 t_relf.rpccyg Cod_rela,
                 t_desp.vinom Relacion,
                 trim(t_idfa.pfape1)||' '||trim(t_idfa.pfape2)||' '||trim(t_idfa.pfnom1)||' '||trim(t_idfa.pfnom2) Nom_Fam,
                 t_tdfa.tdnom Tip_Doc_Fam,       
                 t_idfa.pfndoc DNI_Fam,
                 t_idfa.pffnac Fec_Nac_Fam,
                 t_rcde.vinom Vinc_Fam_con_Caja,
                 
                 2 Tipo_reg               
            from fsd002 t_iden,
                 fsr002 t_relf,
                 fst020 t_desp,
                 fsd002 t_idfa,
                   
                 fst014 t_tido,
                 fsr003 t_rcaj,
                 fst020 t_trel,
                   
                 fst014 t_tdfa,
                 fsr003 t_rcfa,
                 fst020 t_rcde

            where t_relf.rppais = t_iden.pfpais
                  and t_relf.rptdoc = t_iden.pftdoc
                  and t_relf.rpndoc = t_iden.pfndoc
                  and t_desp.vicod = t_relf.rpccyg
                    
                  and t_idfa.pfpais = t_relf.pepais
                  and t_idfa.pftdoc = t_relf.petdoc
                  and t_idfa.pfndoc = t_relf.pendoc

                  and t_tido.tdocum(+) = t_iden.pftdoc
                    
                  and t_rcaj.pjndoc(+) = '20100209641 '
                  and t_rcaj.pfndo1(+) = t_iden.pftdoc
                  and t_trel.vicod(+) = t_rcaj.vicod

                  and t_tdfa.tdocum(+) = t_idfa.pftdoc
                    
                  and t_rcfa.pjndoc(+) = '20100209641 '
                  and t_rcfa.pfndo1(+) = t_idfa.pfndoc
                  and t_rcde.vicod(+) = t_rcfa.vicod
                    
                  and t_iden.pfndoc = NRODOC) T2; --'47216030'--'29589266' '40760733'
  
    VCONT_ABUELOS NUMBER;--63
    VCONT_CONYUGE NUMBER;--66
    VCONT_HIJOS   NUMBER;--69
    VCONT_CUNADOS NUMBER;--67
    VCONT_PADRES  NUMBER;--71
    VCONT_SUEGROS NUMBER;--75
    VCONT_BISABUELO   NUMBER;--64
    VCONT_BISNIETO    NUMBER;--65  
    VCONT_HERMANO     NUMBER;-- 68 HERMANO(A)                                        
    VCONT_NIETO       NUMBER;--70   NIETO(A)                      
    VCONT_PRIMOHNO    NUMBER; --73 PRIMO HERMANO(A)              
    VCONT_PRIMO       NUMBER;---72 PRIMO(A)                      
    VCONT_SOBRINO     NUMBER;--74   SOBRINO(A)                    
    VCONT_TATARABUELO NUMBER;--76   TATARABUELO(A)                
    VCONT_TATANIETO   NUMBER;--77	 TATARANIETO(A)                
    VCONT_TIOABUELO   NUMBER;---78 TIO ABUELO(A)                 
    VCONT_TIO         NUMBER;---79 TIO(A)                        
    VCONT_NUERAYERNO  NUMBER;-- 89 NUERA/YERNO                   


    OBSERVACION   varchar2(200);
    V_FECHAHOY    DATE;
    V_YEARHOY     NUMBER;
    V_YEARNAC     NUMBER;
    V_EDADT       NUMBER;
    V_EDADF       NUMBER;
      
   ubuser varchar2(10):= 'smarquez';   
   correo varchar2(30); 
   cont_abu number ;
   cont_pad number ;
   cont_coy number ;
   cont_hij number ;
   cont_sug number ;
   cont_conv number ;
   cont_proex number ;
   
   a_abu number ;
   a_pad number ;
   a_coy number ;
   a_hij number ;
   a_sug number ;
   a_conv number ;
   a_proex number ;
   texto varchar2(1000);
   nombre varchar2(25);
   lv_mensaje VARCHAR2(1000);
   ll_mensaje clob;
   lv_motivo varchar2(100) := 'Registro de familiares Incompleto';
   l_crlf char(2) := Chr(13)||Chr(10);---chr(10)||chr(13);
 --  linefeed varchar(2) := chr(13)||chr(10);
   
begin
  
---------------------------------------
 -- dbms_lob.createtemporary(ll_mensaje, TRUE);
  
  DELETE JAQY667 
  WHERE JAQY667USER = ubuser;
  COMMIT;

  SELECT PGFAPE 
    INTO V_FECHAHOY
    FROM FST017
   WHERE PGCOD = 1;
  
  SELECT EXTRACT(YEAR FROM( SELECT V_FECHAHOY FROM DUAL)) 
    INTO V_YEARHOY
    FROM DUAL;

   FOR TOD IN TODOSFAM LOOP
     
         VCONT_ABUELOS := 0;  --63
         VCONT_CONYUGE := 0;--66
         VCONT_HIJOS   := 0;--69
         VCONT_CUNADOS := 0;--67
         VCONT_PADRES  := 0;--71
         VCONT_SUEGROS := 0;--75
         VCONT_NIETO       := 0;--70	 NIETO(A)                      
         VCONT_BISABUELO   := 0;--64
         VCONT_BISNIETO    := 0;--65	
         VCONT_HERMANO     := 0;-- 68 HERMANO(A)                                        
         VCONT_PRIMOHNO    := 0; --73 PRIMO HERMANO(A)              
         VCONT_PRIMO       := 0;---72 PRIMO(A)                      
         VCONT_SOBRINO     := 0;--74	 SOBRINO(A)                    
         VCONT_TATARABUELO := 0;--76	 TATARABUELO(A)                
         VCONT_TATANIETO   := 0;--77	 TATARANIETO(A)                
         VCONT_TIOABUELO   := 0;---78 TIO ABUELO(A)                 
         VCONT_TIO         := 0;---79 TIO(A)                        
         VCONT_NUERAYERNO  := 0;-- 89 NUERA/YERNO                   
         OBSERVACION   := null;
         
         FOR DES IN DESPLIEGUE(TOD.DNI) LOOP
           BEGIN
            OBSERVACION   := null;
             --- conteo de  parientes
             IF DES.COD_RELA = 63 THEN
                VCONT_ABUELOS := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_ABUELOS := 0;
             END IF;
             
             IF DES.COD_RELA = 66 THEN
                VCONT_CONYUGE := 1;---VCONT_CONYUGE + 1;
             ELSE
                VCONT_CONYUGE := 0;               
             END IF;
             
             IF DES.COD_RELA = 69 THEN
                VCONT_HIJOS := 1;  ---VCONT_HIJOS + 1;
                IF DES.FEC_NAC > DES.FEC_NAC_FAM THEN
                  OBSERVACION := 'Ingreso Incorrecto deberia ser PADRE/MADRE';
                END IF;  
             ELSE
                VCONT_HIJOS := 0;             
             END IF;
             
             IF DES.COD_RELA = 67 THEN
                VCONT_CUNADOS := 1; ---VCONT_CUNADOS + 1;
             ELSE
                VCONT_CUNADOS := 0;
             END IF;
             
             IF DES.COD_RELA = 71 THEN
                VCONT_PADRES :=  1;---VCONT_PADRES + 1;
                IF DES.FEC_NAC < DES.FEC_NAC_FAM THEN
                  OBSERVACION := 'Ingreso Incorrecto deberia ser HIJO/HIJA';
                END IF;   
             ELSE
                 VCONT_PADRES := 0;  
             END IF;
             
             IF DES.COD_RELA = 75 THEN
                VCONT_SUEGROS := 1; ---VCONT_SUEGROS + 1;
             ELSE
                VCONT_SUEGROS := 0;
             END IF;
                      
             IF DES.COD_RELA = 70 THEN
                 VCONT_NIETO := 1;
                 IF DES.FEC_NAC > DES.FEC_NAC_FAM THEN
                      OBSERVACION := 'Ingreso Incorrecto deberia ser ABUELO/ABUELA';
                 END IF;
             ELSE 
               VCONT_NIETO := 0;
             END IF;  
             ------
                          --- conteo de  parientes
             IF DES.COD_RELA = 64 THEN
                VCONT_BISABUELO := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_BISABUELO := 0;
             END IF;
             
             IF DES.COD_RELA = 65 THEN
                VCONT_BISNIETO := 1;---VCONT_CONYUGE + 1;
             ELSE
                VCONT_BISNIETO := 0;               
             END IF;
                          
             IF DES.COD_RELA = 68 THEN
                VCONT_HERMANO := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_HERMANO := 0;
             END IF;
             
             IF DES.COD_RELA = 73 THEN
                VCONT_PRIMOHNO := 1;---VCONT_CONYUGE + 1;
             ELSE
                VCONT_PRIMOHNO := 0;               
             END IF;
                          
             IF DES.COD_RELA = 72 THEN
                VCONT_PRIMO := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_PRIMO := 0;
             END IF;
             
             IF DES.COD_RELA = 74 THEN
                VCONT_SOBRINO := 1;---VCONT_CONYUGE + 1;
             ELSE
                VCONT_SOBRINO := 0;               
             END IF;
                          
             IF DES.COD_RELA = 76 THEN
                VCONT_TATARABUELO := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_TATARABUELO := 0;
             END IF;
             
             IF DES.COD_RELA = 77 THEN
                VCONT_TATANIETO := 1;---VCONT_CONYUGE + 1;
             ELSE
                VCONT_TATANIETO := 0;               
             END IF;
             
             IF DES.COD_RELA = 78 THEN
                VCONT_TIOABUELO := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_TIOABUELO := 0;
             END IF;
             
             IF DES.COD_RELA = 79 THEN
                VCONT_TIO := 1;---VCONT_CONYUGE + 1;
             ELSE
                VCONT_TIO := 0;               
             END IF;
                          
             IF DES.COD_RELA = 89 THEN
                VCONT_NUERAYERNO := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_NUERAYERNO := 0;
             END IF;
             IF DES.COD_RELA = 89 THEN
                VCONT_NUERAYERNO := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_NUERAYERNO := 0;
             END IF;
            
  
             --eDADES 
             SELECT EXTRACT(YEAR FROM( SELECT DES.FEC_NAC FROM DUAL)) 
               INTO V_YEARNAC
               FROM DUAL;
             V_EDADT :=  V_YEARHOY - V_YEARNAC;
             SELECT EXTRACT(YEAR FROM( SELECT DES.FEC_NAC_FAM FROM DUAL)) 
               INTO V_YEARNAC
               FROM DUAL;
             V_EDADF :=  V_YEARHOY - V_YEARNAC;  
             
             INSERT INTO JAQY667(jaqy667dnit,
                                 jaqy667dnif,
                                 jaqy667nomt,
                                 jaqy667fnac,
                                 jaqy667estt,
                                 jaqy667crel,
                                 jaqy667dcod,
                                 jaqy667tdoc,
                                 jaqy667nomf,
                                 jaqy667fnaf,
                                 jaqy667nabu,
                                 jaqy667npad,
                                 jaqy667ncoy,
                                 jaqy667nhij,
                                 jaqy667nsue, 
                                 jaqy667ncun,
                                 jaqy667user,
                                 jaqy667aux4,
                                 JAQY667EDAT,
                                 Jaqy667edaf,
                                 jaqy667nny,
                                 jaqy667ntia,
                                 jaqy667ntio,
                                 jaqy667ntni,
                                 jaqy667ntab,
                                 jaqy667nsob,
                                 jaqy667nphr,
                                 jaqy667nnie,
                                 jaqy667nher,
                                 jaqy667nbni,
                                 jaqy667nbab,
                                 jaqy667nPRI
                                  )
                          VALUES (DES.DNI,
                                  DES.DNI_FAM,
                                  DES.NOMTRABAJADOR,
                                  DES.FEC_NAC,
                                  DES.SN,
                                  DES.COD_RELA,
                                  DES.RELACION,
                                  DES.TIP_DOC_FAM,
                                  DES.NOM_FAM,
                                  DES.FEC_NAC_FAM,
                                  VCONT_ABUELOS,
                                  VCONT_PADRES,
                                  VCONT_CONYUGE,
                                  VCONT_HIJOS,
                                  VCONT_SUEGROS,
                                  VCONT_CUNADOS,
                                  ubuser,
                                  OBSERVACION,
                                  V_EDADT,
                                  V_EDADF,
                                  VCONT_NUERAYERNO,  
                                  VCONT_TIOABUELO,   
                                  VCONT_TIO,
                                  VCONT_TATANIETO,
                                  VCONT_TATARABUELO,
                                  VCONT_SOBRINO,
                                  VCONT_PRIMOHNO,
                                  VCONT_NIETO,
                                  VCONT_HERMANO,
                                  VCONT_BISNIETO,
                                  VCONT_BISABUELO,
                                  VCONT_PRIMO                                                         
                                 );
           EXCEPTION
             WHEN DUP_VAL_ON_INDEX THEN
               NULL;
           END;        
         
         END LOOP;
     END LOOP;  
     COMMIT;  
  

--  PQ_AH_RRHHREP.SP_AH_REALIZAR_REPORTE (3,ubuser);  
  
  for reg in DNIEmp(ubuser) loop
   
     cont_abu := 0;
     cont_pad := 0;
     cont_coy := 0;
     cont_hij := 0;
     cont_sug := 0;
     cont_conv := 0;
     cont_proex := 0;
     a_abu := 0;
     a_pad:= 0;
     a_coy := 0;
     a_hij := 0;
     a_sug := 0;
     a_conv := 0;
     a_proex := 0;
          
--     select pfnom1 into nombre from fsd002 where pfpais = 604 and pftdoc = 21 and pfndoc = reg.dninro;
     Texto := 'Estimado(a)'||' ' ||reg.nombre||l_crlf;
     Texto := Texto|| l_crlf;
     Texto := Texto ||'Tiene pendiente el registro de familiares,'||l_crlf;    
     Texto := Texto ||l_crlf;
     For x in familia(reg.dninro,ubuser) loop
          
         cont_abu := cont_abu + x.JAQY667NABU;
         cont_pad := cont_pad + x.JAQY667NPAD;
         cont_coy := cont_coy + x.JAQY667NCOY;
         cont_hij := cont_hij + x.JAQY667NHIJ;
         cont_sug := cont_sug + x.JAQY667NSUE;
         cont_conv := cont_conv + to_number(Trim(x.JAQY667AUX1));
         cont_proex := cont_proex + to_number(Trim(x.JAQY667AUX2));
         
      End loop;
      
         if cont_abu < 4 then
           cont_abu := 4 -cont_abu;
           a_abu := 1;
           Texto := trim(Texto)||'debe registrar'||' '||cont_abu||' '||'abuelo(s)';
           Texto := Texto || l_crlf;  
        
         end if;
         if cont_pad < 2 then
           cont_pad := 2 -cont_pad;
           a_pad := 1;
           Texto := trim(Texto)||'debe registrar'||' '||cont_pad||' '||'padre(s)';
           Texto := Texto || l_crlf;  
         end if;
         if cont_hij > 0 then
           if cont_coy = 0 then            
              if cont_conv = 0 then
                if cont_proex = 0 then
                  Texto := trim(Texto)||' o debe registrar a su conyuge o conviviente o al progenitor de su(s) hijo(s)';
                  Texto := Texto || l_crlf;  
                end if ;
              end if;  
           end if;              
         end if;     
         if cont_coy = 1 then 
           if cont_sug < 2 then
             cont_sug := 2 - cont_sug;
             Texto := trim(Texto)||', '||'debe registrar'||' '||cont_sug||' '||'suegro(s)';
             Texto := Texto || l_crlf;  
           end if;
         end if;
      
        Texto := Texto || l_crlf;  
        Texto := Texto ||'Saludos Cordiales';
        Texto := Texto || l_crlf;  
        
       ---  Texto := Texto ||'Saludos Cordiales'||chr(13);
      --   Texto := TExto || chr(13)||chr(13);
         
         Begin
         select trim(substr(pextxt,1,(instr(pextxt, '\')-1)))
           into correo   
           from fsx001
          Where Txcod = 0
            and Pexren = 1
            and Pepais = 604
            and Petdoc = 21
            and Pendoc = reg.dninro
            and (pextxt like '%@cajaarequipa.pe%' or
                pextxt like '%@CAJAAREQUIPA.PE%');
        exception
          when no_data_found then
            Begin
              select trim(jaql708mail )
                into correo
                from jaql708 
               where jaql708doi =reg.dninro;
            exception
              when others then
                correo := null;
            end;           
        end; 
       lv_mensaje := trim(texto); 
       if correo is not null then
--         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);   
--         SP_SY_ENVIAMAIL_DESAJK(PC_DE => 'smarquez@cajaarequipa.pe', 
	        sys.SP_SY_ENVIAMAIL(PC_DE => 'smarquez@cajaarequipa.pe', 
                                PC_AQUIEN => correo, 
                                PC_MOTIVO => lv_motivo, 
                                PC_MENSAJE => lv_mensaje);
       end if;                         
     /*  sys.sp_sy_enviamail_html_silvia(pc_aquien  => correo,--lv_maiasi,--VARCHAR2
                                pc_de      => correo,--lv_maiori, --VARCHAR2
                                pc_motivo  => lv_motivo, --VARCHAR2
                                pc_mensaje => ll_mensaje --CLOB
                               );   */
 
   end loop; 

  
end SP_AH_ALERT_REGFAM;
/

