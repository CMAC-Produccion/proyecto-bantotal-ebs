create or replace package PQ_CR_CREDITOS_CAP_HS is

  -- Author  : HSUAREZ
  -- Created : 25/02/2021 12:15:07
  -- Purpose : Paquete para la carga de creditos reprogramados con perdon de capital aprobados por GA, GREG y JZON

  -- MOdificacion: Hsuarez
  -- Fecha Modificacion: 27/09/2023 12:52
  -- Contenido: Se agrego una validacion para considerar los de BI sin consultar a CRM.
  -- CONTENIDO: SE AGREGO VALOR ABSOLUTO AL RANGO DE APROBACION.
  -- FECHA MODIFICACION: 15/03/2024
  -- MODIFICACION : HSUAREZ
  -- CONTENIDO: SE MODIFICO LOS PROCEDIMIENTOS

  procedure sp_cargar_lista_crd(ve_fecha  in date,
                                ve_ubuser in varchar,
                                vo_msgs   out varchar);
  PROCEDURE sp_gestionar_credito(ve_cod  in number,
                                 ve_est  in varchar,
                                 ve_cmt in varchar,
                                 ve_user in varchar,
                                 ve_msj  out varchar);
  PROCEDURE sp_gestionar_acceso(ve_ubuser in varchar,ve_sucur in number,vo_cargo in number,vo_msgs out varchar);
  PROCEDURE sp_nivel_acceso(ve_acceso in number,ve_ubuser in varchar,ve_sucur in number,ve_flag_a out varchar);
  procedure sp_actualizar_saldo(codigo in number,saldo in number);
  PROCEDURE sp_tipo_cambio_fijo(P_FECHA in date,ln_tipcam out fsh005.cotcbi%type);
  procedure sp_obtener_jefe_cargo(ve_cargo in varchar,ve_usuario in varchar,vo_jefe out varchar);
  PROCEDURE SP_ARBOL_FONDOS(
                           -- ve_instancia number,
                          ve_pgcod number,
                          ve_scmod number,
                          ve_scsuc  number,
                          ve_scmda  number,
                          ve_scpap  number,
                          ve_sccta  number,
                          ve_scoper number,
                          ve_scsbop number,
                          ve_sctope number,
                          ve_cargo  number,
                          ve_cargo2 number,
                          ve_rpta out varchar
  );
  PROCEDURE SP_GESTIONAR_ACCESO3(
                               ve_instancia in number,
                               ve_codigo in number,                             
                               ve_ubuser_pri in varchar,
                               ve_ubuser_sup in varchar,
                               ve_sucur in number,
                               ve_cargo_pri in number,
                               ve_cargo_sup in number,
                               vo_rpta out varchar
                              );
  
PROCEDURE SP_GESTIONAR_ACCESO_IND3(
                               ve_instancia in number,
                               ve_codigo in number,
                               ve_ubuser_pri in varchar,
                               ve_sucur in number,
                               ve_cargo_pri in number,
                               vo_rpta out varchar
                              );  
  PROCEDURE SP_GESTIONAR_ACCESO2(
                               --ve_instancia in number,
                               --ve_codigo in number,                             
                               ve_ubuser_pri in varchar,
                               ve_ubuser_sup in varchar,
                               ve_sucur in number,
                               ve_cargo_pri in number,
                               ve_cargo_sup in number,
                               vo_rpta out varchar
                              );
  
PROCEDURE SP_GESTIONAR_ACCESO_IND(
                               --ve_instancia in number,
                               --ve_codigo in number,
                               ve_ubuser_pri in varchar,
                               ve_sucur in number,
                               ve_cargo_pri in number,
                               vo_rpta out varchar
                              );                                                          
  PROCEDURE SP_CR_FONDOS_VTASA(
                              ve_instancia number,
                              vo_rpta out varchar
                              );
end PQ_CR_CREDITOS_CAP_HS;
/

create or replace package body PQ_CR_CREDITOS_CAP_HS is


procedure sp_cargar_lista_crd(ve_fecha in date,ve_ubuser in varchar,vo_msgs out varchar) is
  
cursor lista_crm is
SELECT L.DNICLIENTE,                   
       F.EMPRESA,
       F.MODULO,
       F.MONEDA,
       F.PAPEL,
       SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1) CUENTA, --CUENTA
       SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) OPERACION,      --OPERACION
       F.SUCURSAL,
       F.SUBOPERACION,
       F.TIPOOPERACION,       
       CASE WHEN F.MONTOCAPITALIZACION > 0 THEN F.MONTOCAPITALIZACION ELSE F.DESCUENTOSOLICITADO END MONTOCAPITALIZACION,
       F.NUEVATASA,
       F.PORCENTAJEREDUCCION,
       L.FECHAENBANTOTAL,
       F.MENSAJEAUTONOMIA,
       F.FACILIDAD
  FROM LEY31050 L
 INNER JOIN LEY31050_CREDITOSFACILIDAD F
    ON L.IDLEY31050 = F.IDLEY31050
 WHERE L.ESTADOSOLICITUD = 'BT'
   AND L.TIPOFACILIDAD = 'CAJA'
   AND TRUNC(FECHAENBANTOTAL) < (ve_fecha + 1);
  
 vi_pepais fsr008.pepais%type;
 vi_petdoc  fsr008.petdoc%type;
 vi_pendoc fsr008.pendoc%type;
 vi_instancia xwf700.xwfprcins%type;
 vi_flag char(1);
 vi_cargo number(10);
 vi_estado char(1);
 vo_msgsS VARCHAR(255);
 
 vo_aprobador_sup varchar(10);
 vo_aprobador     varchar(10);
 VI_TASA_ACTUAL NUMBER(10,6);            
  begin
        FOR x in lista_crm LOOP
            
            --CARGANDO LOS DATOS CLIENTE
            BEGIN              
              SELECT f.pepais,f.petdoc,f.pendoc
              INTO vi_pepais,vi_petdoc,vi_pendoc
              FROM fsr008 f where f.pgcod=1 and f.ctnro=x.CUENTA and F.CTTFIR='T' and F.TTCOD=1;
            EXCEPTION 
              WHEN OTHERS THEN
                NULL;   
              END;
            --CAGANRDO LA INSTANCIA Y SALDO CAPITAL.
            vi_instancia := 0;
            BEGIN                       
                SELECT s.XWFPRCINS
                INTO   vi_instancia
                FROM XWF700 s
                WHERE s.XWFEMPRESA =  x.EMPRESA
                  AND s.XWFMODULO  =  x.MODULO
                  AND S.XWFMONEDA  =  x.MONEDA
                  AND S.XWFPAPEL   =  x.PAPEL
                  AND S.XWFCUENTA  =  x.CUENTA 
                  AND S.XWFOPERACION = x.OPERACION
                  AND S.XWFSUCURSAL = x.SUCURSAL
                  AND S.XWFSUBOPE   = x.SUBOPERACION
                  AND S.XWFTIPOPE   = x.TIPOOPERACION
                  AND S.XWFCAR3     = '1'
                  AND S.XWFPRCINS   = (SELECT MAX(D.XWFPRCINS) FROM XWF700 D
                                       WHERE D.XWFEMPRESA =  x.EMPRESA
                                         AND D.XWFMODULO  =  x.MODULO
                                         AND D.XWFMONEDA  =  x.MONEDA
                                         AND D.XWFPAPEL   =  x.PAPEL
                                         AND D.XWFCUENTA  =  x.CUENTA
                                         AND D.XWFOPERACION = x.OPERACION
                                         AND D.XWFSUCURSAL = x.SUCURSAL
                                         AND D.XWFSUBOPE   = x.SUBOPERACION
                                         AND D.XWFTIPOPE   = x.TIPOOPERACION
                                         AND D.XWFCAR3     = '1'       
                                      )
                  AND ROWNUM = 1;
            EXCEPTION
              WHEN OTHERS THEN
                NULL;
              END;
           --Equivalencia de cargos de CRM a Bantotal.
           vi_estado := 'P';
           BEGIN
             IF UPPER(x.MENSAJEAUTONOMIA) LIKE '%CONTROL%' THEN--'Se necesita aprobación de Control de créditos' THEN
                vi_cargo:=215;
             END IF;
             IF UPPER(x.MENSAJEAUTONOMIA) LIKE '%ANALISTA%' THEN--'dentro de la autonomía del analista' THEN
                vi_cargo:=200;
                vi_estado := 'A';
             END IF;
             IF UPPER(x.MENSAJEAUTONOMIA) LIKE '%GERENTE DE AGENCIA%' THEN --'Se necesita aprobación de Gerente de agencia' THEN
                vi_cargo:=202;
             END IF;
             IF UPPER(x.MENSAJEAUTONOMIA) LIKE '%GERENTE REGIONAL%' THEN --'Se necesita aprobación de Gerente regional' THEN
                vi_cargo:=220;
             END IF;
             IF UPPER(x.MENSAJEAUTONOMIA) LIKE '%GERENCIA DE CR%' THEN--'Se necesita aprobación de Gerencia de Créditos' THEN
                vi_cargo:=230;
             END IF;
             IF UPPER(x.MENSAJEAUTONOMIA) LIKE '%SE NECESITA APROBACION DE GERENTE CENTRAL DE NEGOCIOS%' THEN--'Se necesita aprobación de Gerencia de Créditos' THEN
                vi_cargo:=240;
             END IF;
             END;             
           --VALIDAMOS SI EL REGISTRO EXISTE EN CAOS YA EXISTIERA NO SE INSERTA
           vi_flag := 'N';
           
           BEGIN
              SELECT 'S'
              INTO  vi_flag FROM AQPB561 A 
              WHERE A.AQPB561EMP = x.EMPRESA
                AND A.AQPB561MOD = x.MODULO
                AND A.AQPB561MDA = x.MONEDA
                AND A.AQPB561PAP = x.PAPEL
                AND A.AQPB561CTA = x.CUENTA
                AND A.AQPB561OPER= x.OPERACION
                AND A.AQPB561SUC = x.SUCURSAL
                AND A.AQPB561SBOP= x.SUBOPERACION
                AND A.AQPB561TOP = x.TIPOOPERACION
                AND A.AQPB561FCRM= x.FECHAENBANTOTAL;
           EXCEPTION WHEN OTHERS THEN
                     vi_flag:= 'N';     
           END;
           
           --OBTENER USUARIO APROBADOR
           pq_cr_reprog_sin_cap.SP_CRD_OBTENER_APROBADOR(vi_cargo,x.SUCURSAL,vo_aprobador,vo_aprobador_sup);
           
            --INVERTAMOS REGISRO
           IF vi_flag = 'N' then 
              BEGIN 
                BEGIN
                  pq_cr_reprog_caja.sp_cr_tasa(
                                                x.EMPRESA,
                                                x.MODULO,
                                                x.SUCURSAL,
                                                x.MONEDA,
                                                x.PAPEL,
                                                x.CUENTA,
                                                x.OPERACION,                                                
                                                x.SUBOPERACION,
                                                x.TIPOOPERACION,
                                                VI_TASA_ACTUAL
                                              );
                EXCEPTION
                  WHEN OTHERS THEN
                    VI_TASA_ACTUAL:=0;
                END;  
              
               
                INSERT INTO
                AQPB561 A ( A.AQPB561PAIS,A.AQPB561PTDC,A.AQPB561DNI,
                            A.AQPB561EMP,A.AQPB561MOD,A.AQPB561MDA,A.AQPB561PAP,A.AQPB561CTA,A.AQPB561OPER,A.AQPB561SUC,A.AQPB561SBOP,A.AQPB561TOP,
                            A.AQPB561INST,A.AQPB561CAPT,A.AQPB561REDU,A.AQPB561TREDU,A.AQPB561PREDU,A.AQPB561EHAB,A.AQPB561FECR,A.AQPB561FCRM,A.AQPB561USRR,A.AQPB561PCARG,A.AQPB561EST,A.AQPB561FAC,A.AQPB561USRPA,A.AQPB561TASAACT) VALUES (
                            vi_pepais,vi_petdoc,x.DNICLIENTE,
                            x.EMPRESA,x.MODULO,x.MONEDA,x.PAPEL,x.CUENTA,x.OPERACION,x.SUCURSAL,x.SUBOPERACION,x.TIPOOPERACION,
                            vi_instancia,x.MONTOCAPITALIZACION,x.NUEVATASA,x.NUEVATASA,x.PORCENTAJEREDUCCION,'H',SYSDATE,x.FECHAENBANTOTAL,ve_ubuser,vi_cargo,vi_estado,x.FACILIDAD,vo_aprobador,VI_TASA_ACTUAL);
                begin
                     UPDATE
                           AQPB561 A  SET A.AQPB561EHAB = 'I'
                           WHERE A.AQPB561EMP  = x.EMPRESA
                             AND A.AQPB561MOD  = x.MODULO
                             AND A.AQPB561MDA  = x.MONEDA
                             AND A.AQPB561PAP  = x.PAPEL
                             AND A.AQPB561CTA  = x.CUENTA
                             AND A.AQPB561OPER = x.OPERACION
                             AND A.AQPB561SUC  = x.SUCURSAL
                             AND A.AQPB561SBOP = x.SUBOPERACION
                             AND A.AQPB561TOP  = x.TIPOOPERACION
                             AND A.AQPB561INST = vi_instancia
                             AND A.AQPB561FCRM < x.FECHAENBANTOTAL
                             AND A.AQPB561EHAB='H'
                             AND A.AQPB561EST IN ('A','P');
                   EXCEPTION 
                      WHEN OTHERS THEN
                           NULL;       
                  end;            
              EXCEPTION WHEN OTHERS THEN
                 vo_msgsS := SQLERRM;                            
              END;
           ELSE
             BEGIN
            UPDATE
                AQPB561 A  SET A.AQPB561CAPT = x.MONTOCAPITALIZACION,
                               A.AQPB561REDU = x.NUEVATASA,
                               A.AQPB561PCARG= vi_cargo
                           WHERE     
                               A.AQPB561EMP =x.EMPRESA
                             AND    A.AQPB561MOD =x.MODULO
                            AND     A.AQPB561MDA =x.MONEDA
                            AND     A.AQPB561PAP =x.PAPEL
                             AND    A.AQPB561CTA =x.CUENTA
                             AND    A.AQPB561OPER=x.OPERACION
                             AND    A.AQPB561SUC =x.SUCURSAL
                              AND   A.AQPB561SBOP=x.SUBOPERACION
                              AND   A.AQPB561TOP =x.TIPOOPERACION
                              AND   A.AQPB561INST=vi_instancia
                              AND   A.AQPB561FCRM=x.FECHAENBANTOTAL
                              AND   A.AQPB561EHAB='H'
                             AND    A.AQPB561EST ='P';
                             EXCEPTION 
                               WHEN OTHERS THEN
                                 NULL;
                             END;
           END IF;           
        END LOOP;
        COMMIT;
    end;  


PROCEDURE sp_gestionar_credito(ve_cod  in number,
                                 ve_est  in varchar,
                                 ve_cmt in varchar,
                                 ve_user in varchar,
                                 ve_msj  out varchar) is
  
  
  aux_est varchar(1);
  vi_cta number(9);
  vi_ope number(9);
  vi_subope number(4);
  vi_tope number(4);
  vi_fecha TIMESTAMP;
  COD_CRM NUMBER;
  begin
  
    if ve_est = 'A' or ve_est='R' then
    begin
      UPDATE AQPB561 A
         SET A.AQPB561EST  = ve_est,
             A.AQPB561USRM = ve_user,
             A.AQPB561FECM = SYSDATE,
             A.AQPB561FECC = SYSDATE,
             A.AQPB561COM = VE_CMT
       WHERE AQPB561COD = ve_cod;
      ve_msj := 'Se han aplicado los cambios';
    EXCEPTION
      WHEN OTHERS THEN
        ve_msj := 'No se han podido aplicar los cambios, consulte al administrador';
    end; 
     if ve_est = 'R' then
       begin
       select l.aqpb561cta,
              l.aqpb561oper,
              l.aqpb561sbop,
              l.aqpb561top,
              l.aqpb561fcrm
       into vi_cta,
            vi_ope,
            vi_subope,
            vi_tope,
            vi_fecha
       from aqpb561 l where aqpb561cod= ve_cod;
       
       select L.idley31050
       INTO COD_CRM
       FROM LEY31050 L
       INNER JOIN LEY31050_CREDITOSFACILIDAD F
          ON L.IDLEY31050 = F.IDLEY31050
         AND L.ESTADOSOLICITUD = 'BT'
         AND L.TIPOFACILIDAD = 'CAJA'
       where SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) = vi_cta
         AND SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION, '-') + 1,99)  = vi_ope
         AND L.FECHAENBANTOTAL = vi_fecha;
       --/* descomentar para pase 14.08.2021
       UPDATE LEY31050 SET ESTADOSOLICITUD= 'CU'
       where IDLEY31050 = COD_CRM;   
       --*/
       exception
         when others then
           null;
       end;
       
     end if;  
    end if;    
    commit;
  end;


PROCEDURE sp_gestionar_acceso(ve_ubuser in varchar,ve_sucur in number,vo_cargo in number,vo_msgs out varchar)
  is 
  CURSOR lista_roles is
  select p.* from 
        prfu00 p where p.ubuser=rpad(ve_ubuser,10,' ');
  --VARIABLES TEMPORAL:
  vi_gage char(1);
  vi_jzon char(1);
  vi_greg char(1); 
  vi_nacceso number(1); 
  vi_flag_a char(1);
  vi_ubuser varchar(10); 
  vi_fecha date;
  vi_cargo number(10);  
  BEGIN
      --BUSCO ROL DEL USUARIO
      vi_gage:='N';
      vi_jzon:='N';
      vi_greg:='N';
      vi_ubuser := ve_ubuser;
      vi_cargo := vo_cargo;
      BEGIN
        SELECT PGFAPE
        INTO vi_fecha
        FROM FST017 WHERE PGCOD=1;
        END;
      begin
           SELECT SNG057USR,SNG055car
             INTO vi_ubuser,vi_cargo
             FROM SNG057
             WHERE SNG057SUP=rpad(ve_ubuser,10,' ')
               AND SNG057INI<=vi_fecha
               AND SNG057FIN>=vi_fecha
               AND ROWNUM=1;
      exception when others then
        null;         
        end;
      BEGIN
            --for x in lista_roles loop
                if vi_cargo = 202 then --TRIM(x.prfgcod)='GAGE01' then
                  vi_gage:= 'S';
                  --vo_cargo:=x.prfgcod;
                  vi_nacceso:= 1;
                end if;
                if vi_cargo = 220 then--if TRIM(x.prfgcod)='JZON01' then
                  vi_jzon:= 'S';
                  --vo_cargo:=x.prfgcod;
                  vi_nacceso:= 3;
                end if;
                if vi_cargo = 230 then--if TRIM(x.prfgcod)='JZON01' then
                  vi_jzon:= 'S';
                  --vo_cargo:=x.prfgcod;
                  vi_nacceso:= 3;
                  vo_msgs:='S';
                  return;
                end if;
                if vi_cargo = 240 then--if TRIM(x.prfgcod)='JZON01' then
                  vi_jzon:= 'S';
                  --vo_cargo:=x.prfgcod;
                  vi_nacceso:= 3;
                  vo_msgs:='S';
                  return;
                end if;
                /*
                if vo_cargo = 202 then--if TRIM(x.prfgcod)='GREG01' then
                  vi_greg:= 'S';
                  --vo_cargo:=x.prfgcod;
                  vi_nacceso:= 3;
                end if;
                */
            --end loop;
        END;      
      --VALIDO SI LA SUCURSAL ESTA DENTRO DEL ROL ASIGNADO
      BEGIN
           PQ_CR_CREDITOS_CAP_HS.SP_NIVEL_ACCESO(vi_nacceso,vi_ubuser,ve_sucur,vi_flag_a);
        END;
      vo_msgs:= vi_flag_a;     
    end;
    
procedure sp_nivel_acceso(ve_acceso in number,ve_ubuser in varchar,ve_sucur in number,ve_flag_a out varchar)
   is 
   vi_suc_orig number(3);
   vi_reg number(3);
   vi_zon number(3);
   err_msg VARCHAR2(255);
   flag_aut char(1);
   vi_sucura number(4);
   vi_regcod number(4);
   begin
      BEGIN
        --validar si el usuario es autonomo, para considerar las sucursales de su 
        --zona y/o región.
        flag_aut := 'N';
        BEGIN
           select sng057aut 
           into flag_aut
           from sng057 s 
           where s.sng057usr = rpad(ve_ubuser,10,' '); --VALIDAR USUARIO SI ES INDEPENDIENTE.
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        --OBTENER LA SURCURSAL ORIGEN DEL USUARIO
        if flag_aut = 'S' then
        BEGIN
          select f.ubsuc 
          into vi_sucura
          from fst046  f
          where ubuser= rpad(ve_ubuser,10,' ');
        vi_suc_orig:= vi_sucura;  
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        --  OBTENER LA ZONA DEL USUAIRO
        BEGIN
          select REGCOD
          into vi_regcod 
          from fst811 f 
          where f.oficod = vi_sucura and f.pgcod=1 and f.ofisuc='S' and f.regcod < 100;
        exception  when others then
          null;  
          END;
        end if;          
         --VALIDAR SI LA SUCURSAL ES DE SU DOMINIO.
        BEGIN
            select f.oficod
            into vi_suc_orig
            from fst811 f 
            where f.regcod = vi_regcod  and f.pgcod=1 and f.ofisuc='S' and f.oficod=ve_sucur; --VALIDAR SUCURSAL ES DE LA REGIÓN
        EXCEPTION 
          WHEN OTHERS THEN
            NULL;
        END;
        ve_flag_a := 'N';
        IF vi_suc_orig = ve_sucur THEN
           ve_flag_a := 'S';
        END IF;
      --VALIDAMOS LA SUCURSAL DEL USUARIO ESTO USANDO GUIA
      /*
      BEGIN
          SELECT F4.UBSUC,f.tp1nro1 CODIGO_REGION,t81.regcod CODIGO_ZONA
          into VI_SUC_ORIG,vi_REG,VI_ZON
          FROM FST046 F4, fst810 t81 , fst811 t80, fst198 f
        where t80.pgcod = t81.pgcod
          and t80.regcod = t81.regcod
          and t81.regcod = f.tp1nro2
          and  tp1cod = 1 and tp1cod1= 10872 and tp1corr1= 11
          and  t81.regcod < 100
          and  t80.regcod < 100  
          and t80.oficod = f4.ubsuc
          and trim(f4.UBUSER)=trim(ve_ubuser)
          and rownum = 1;
      EXCEPTION 
        WHEN OTHERS THEN
          err_msg:= sqlerrm;
          dbms_output.put_line(err_msg);    
        END;
        */
      --DE ACUERDO AL NIVEL DE ACCESO ESTABLECEMOS LAS SUCURSALES
      --aceso nivel 1      
      IF VE_ACCESO = 1 THEN
         ve_flag_a := 'N';
         BEGIN
           SELECT ubsuc
           INTO  vi_suc_orig
           FROM FST046 WHERE UBUSER=rpad(ve_ubuser,10, '');
         EXCEPTION WHEN OTHERS THEN
           NULL;  
         END;
         IF vi_suc_orig = ve_sucur THEN
            ve_flag_a := 'S';
         END IF;
      END IF;
      /*
      IF VE_ACCESO = 2 THEN
         BEGIN
           select  t80.oficod
             into  vi_suc_orig
            from fst810 t81 , fst811 t80, fst198 f
            where t80.pgcod = t81.pgcod
            and t80.regcod = t81.regcod
            and t81.regcod = f.tp1nro2
            and tp1cod = 1 and tp1cod1= 10872 and tp1corr1= 11
            and t81.regcod < 100
            and t80.regcod < 100 
            and t80.oficod = ve_sucur
            and t81.regcod = vi_zon
            and rownum = 1;
          EXCEPTION WHEN OTHERS THEN
            null;  
           END;
           IF vi_suc_orig = ve_sucur THEN
            ve_flag_a := 'S';
           END IF;
      END IF;  
      
      IF VE_ACCESO = 3 THEN
         BEGIN
           select  t80.oficod
             into  vi_suc_orig
            from fst810 t81 , fst811 t80, fst198 f
            where t80.pgcod = t81.pgcod
            and t80.regcod = t81.regcod
            and t81.regcod = f.tp1nro2
            and tp1cod = 1 and tp1cod1= 10872 and tp1corr1= 11
            and t81.regcod < 100
            and t80.regcod < 100 
            and t80.oficod = ve_sucur
            and f.tp1nro1 = vi_reg
            and rownum = 1;
         EXCEPTION WHEN OTHERS THEN
            null;  
         END;
           IF vi_suc_orig = ve_sucur THEN
            ve_flag_a := 'S';
           END IF;
      END IF;
      */
     END; 
END;

procedure sp_tipo_cambio_fijo(P_FECHA in date,ln_tipcam out fsh005.cotcbi%type) 
is
  --ln_tipcam fsh005.cotcbi%type;
Begin
     Select cotcbi
       Into ln_tipcam
       From (
               select u.cotcbi
                 From fsh005 u
                Where moneda=101
                  And cofdes <= P_FECHA
             Order by cofdes desc
            )
      Where rownum = 1;     
Exception when others then
          ln_tipcam:=0;
end sp_tipo_cambio_fijo;

procedure sp_actualizar_saldo(codigo in number,saldo in number) is
  /*
  cursor lista_aqpb556 is
      select t.*
        from aqpb556 t
       where t.aqpb556cod = codigo
         and t.aqpb556ehab = 'H'
         and t.aqpb556est = 'P'
         and rownum = 1;
  */        
  TRPGCOVIT char(1);
  VI_TPRG NUMBER(3);
  begin     
      TRPGCOVIT:='';
      VI_TPRG:=0;
      begin --ACTUALIZAR TIPO DE REPROGRAMACION, 
        --for x in lista_aqpb556 loop
           SELECT TRIM(J.JAQA400AC1),NVL(T.aqpb556TPRG,0) INTO TRPGCOVIT,VI_TPRG FROM JAQA400 J, AQPB556 T 
               WHERE J.JAQA400EMP = t.aqpb556emp
                 AND J.JAQA400MOD = t.aqpb556mod
                 AND J.JAQA400SUC = t.aqpb556suc
                 AND J.JAQA400MDA = t.aqpb556mda
                 AND J.JAQA400PAP = t.aqpb556pap
                 AND J.JAQA400CTA = t.aqpb556cta
                 AND J.JAQA400OPE = t.aqpb556opeR
                 AND J.JAQA400SBO = t.aqpb556sbop
                 AND J.JAQA400TOP = t.aqpb556top
                 AND t.aqpb556cod = codigo
                 AND t.aqpb556ehab= 'H'
                 AND t.aqpb556est = 'P'
                 AND J.JAQA400FEC = (select MAX(JAQA400FEC)
                                       FROM JAQA400 D
                                      WHERE D.JAQA400EMP = t.aqpb556emp
                                        AND D.JAQA400MOD = t.aqpb556mod
                                        AND D.JAQA400SUC = t.aqpb556suc
                                        AND D.JAQA400MDA = t.aqpb556mda
                                        AND D.JAQA400PAP = t.aqpb556pap
                                        AND D.JAQA400CTA = t.aqpb556cta
                                        AND D.JAQA400OPE = t.aqpb556opeR
                                        AND D.JAQA400SBO = t.aqpb556sbop
                                        AND D.JAQA400TOP = t.aqpb556top
                                        /*AND D.JAQA400EST = 'A'*/)
                AND ROWNUM = 1;
        --end loop;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;  
        end;
      begin
        UPDATE AQPB556 T SET T.AQPB556SCONS=saldo, AQPB556FECM=SYSDATE
        WHERE AQPB556COD=codigo  and aqpb556ehab = 'H'
        and aqpb556est = 'P';
        COMMIT;
        IF TRPGCOVIT in ('C','U') AND VI_TPRG < 2  then
          UPDATE AQPB556 T SET T.AQPB556TPRG=1, AQPB556TCOV = TRPGCOVIT
          WHERE AQPB556COD=codigo  and aqpb556ehab = 'H'
          and aqpb556est = 'P'
          and (aqpb556tcov is null or trim(aqpb556tcov) = ''); 
          COMMIT;         
        END IF;
      exception 
        when others then
          null;  
      end;
end;

procedure sp_obtener_jefe_cargo(ve_cargo in varchar,ve_usuario in varchar,vo_jefe out varchar) is
   vi_CARGO NUMBER(3);
   vi_usuario varchar(30);
   vi_jefe varchar(30);
   i number(4);
  begin
         
              vo_jefe:='';                          
              vi_CARGO:=0;
              i:=0;
              vi_usuario:=ve_usuario;
              WHILE vi_CARGO < ve_cargo OR i<5
              LOOP
                 BEGIN
                   SELECT sng057jef
                   INTO  vi_jefe FROM SNG057 S WHERE S.SNG055EMP=1 AND S.SNG057USR=rpad(vi_usuario,'10',' ') AND S.SNG057AUT='S';
                 EXCEPTION WHEN OTHERS THEN
                   NULL;          
                 END;
                 BEGIN
                   SELECT sng055car INTO  vi_cargo from sng057 S where S.SNG055EMP=1 AND S.sng057usr= rpad(vi_jefe,10,' ') AND S.SNG057AUT='S';
                 EXCEPTION WHEN OTHERS THEN
                   NULL;
                 END;
                 vi_usuario:= vi_jefe;
                 --Dbms_Output.put_line('Analizando el primer cargo del jefe:'||to_char(vi_cargo)||'Jefe :'||vi_jefe);
                 if vi_cargo = ve_cargo then
                   vo_jefe:=vi_jefe;
                   exit;
                 end if;
                 i:= i + 1;
                 if i=20 then
                   exit; 
                 end if;              
              END LOOP;
    end;
PROCEDURE SP_GESTIONAR_ACCESO3(
                               ve_instancia in number,
                               ve_codigo in number,                             
                               ve_ubuser_pri in varchar,
                               ve_ubuser_sup in varchar,
                               ve_sucur in number,
                               ve_cargo_pri in number,
                               ve_cargo_sup in number,
                               vo_rpta out varchar
                              )
  IS
  flag_aut_pri varchar(1);
  flag_aut_sup varchar(1);
  VI_REGION varchar(1);
  vi_sucur_pri number;
  vi_sucur_sup number;
  vi_regcod number;
  vi_suc_orig number;
BEGIN
  vo_rpta:='N';
        IF ve_cargo_pri=220 or ve_cargo_sup=220 THEN
           VI_REGION := 'S';
        END IF;  
        --OBTENER EL CARGO. DEL USUARIO PRINCIPAL
        BEGIN
             SELECT sng057aut
               INTO flag_aut_pri
               FROM SNG057 s 
              WHERE s.SNG057USR= RPAD(ve_ubuser_pri,10,' ')
                AND s.sng057aut='S';
        exception
          when others then
            null;        
          END;
        --OBTENER LA SURCURSAL ORIGEN DEL USUARIO PRINCIPAL
        if flag_aut_pri = 'S' then
        BEGIN
          select f.ubsuc 
          into vi_sucur_pri
          from fst046 f
          where ubuser=RPAD(ve_ubuser_pri,10,' ');
        vi_suc_orig:= vi_sucur_pri;  
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        --OBTENER LA ZONA DEL USUARIO PRINCIPAL
        BEGIN
          select REGCOD
          into vi_regcod 
          from fst811 f 
          where f.oficod = vi_sucur_pri and f.pgcod=1 and f.ofisuc='S' and f.regcod < 100;
        exception  when others then
          null;  
          END;
        end if;          
        --VALIDAR SI LA SUCURSAL ES DE SU DOMINIO.
        IF VI_REGION = 'S' THEN
            BEGIN
                select f.oficod
                into vi_suc_orig
                from fst811 f 
                where f.regcod = vi_regcod  and f.pgcod=1 and f.ofisuc='S' and f.oficod=ve_sucur; --VALIDAR SUCURSAL ES DE LA REGIÓN
            EXCEPTION 
              WHEN OTHERS THEN
                NULL;
            END;
        END IF;
        if vi_suc_orig = ve_sucur then
               vo_rpta:='S';
               RETURN;
        end if;  
        --DATOS DEL QUE SUPLANTA
        --OBTENER EL CARGO. DEL USUARIO SUPLENTE
        BEGIN
             SELECT sng057aut
               INTO flag_aut_sup
               FROM SNG057 s 
              WHERE s.SNG057USR= RPAD(ve_ubuser_sup,10,' ')
                AND s.sng057aut='S';
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
          END;
        --OBTENER LA SURCURSAL ORIGEN DEL USUARIO PRINCIPAL
        if flag_aut_sup = 'S' then
        BEGIN
          select f.ubsuc 
          into vi_sucur_sup
          from fst046 f
          where ubuser=RPAD(ve_ubuser_sup,10,' ');
        vi_suc_orig:= vi_sucur_sup;  
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        --OBTENER LA ZONA DEL USUARIO PRINCIPAL
        vi_regcod:=0;
        BEGIN
          select REGCOD
          into vi_regcod 
          from fst811 f 
          where f.oficod = vi_sucur_sup and f.pgcod=1 and f.ofisuc='S' and f.regcod < 100;
        exception  when others then
          null;  
          END;
        end if;          
        --VALIDAR SI LA SUCURSAL ES DE SU DOMINIO.
        IF VI_REGION = 'S' THEN
            BEGIN
                select f.oficod
                into vi_suc_orig
                from fst811 f 
                where f.regcod = vi_regcod  and f.pgcod=1 and f.ofisuc='S' and f.oficod=ve_sucur; --VALIDAR SUCURSAL ES DE LA REGIÓN
            EXCEPTION 
              WHEN OTHERS THEN
                NULL;
            END;
        END IF;
        
        if vi_suc_orig = ve_sucur then
               vo_rpta:='S';
               RETURN;
        end if;
        
END;  
PROCEDURE SP_GESTIONAR_ACCESO2(
                               --ve_instancia in number,
                               --ve_codigo in number,                             
                               ve_ubuser_pri in varchar,
                               ve_ubuser_sup in varchar,
                               ve_sucur in number,
                               ve_cargo_pri in number,
                               ve_cargo_sup in number,
                               vo_rpta out varchar
                              )
  IS
  flag_aut_pri varchar(1);
  flag_aut_sup varchar(1);
  VI_REGION varchar(1);
  vi_sucur_pri number;
  vi_sucur_sup number;
  vi_regcod number;
  vi_suc_orig number;
BEGIN
  vo_rpta:='N';
        IF ve_cargo_pri=220 or ve_cargo_sup=220 THEN
           VI_REGION := 'S';
        END IF;  
        --OBTENER EL CARGO. DEL USUARIO PRINCIPAL
        BEGIN
             SELECT sng057aut
               INTO flag_aut_pri
               FROM SNG057 s 
              WHERE s.SNG057USR= RPAD(ve_ubuser_pri,10,' ')
                AND s.sng057aut='S';
          END;
        --OBTENER LA SURCURSAL ORIGEN DEL USUARIO PRINCIPAL
        if flag_aut_pri = 'S' then
        BEGIN
          select f.ubsuc 
          into vi_sucur_pri
          from fst046 f
          where ubuser=RPAD(ve_ubuser_pri,10,' ');
        vi_suc_orig:= vi_sucur_pri;  
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        --OBTENER LA ZONA DEL USUARIO PRINCIPAL
        BEGIN
          select REGCOD
          into vi_regcod 
          from fst811 f 
          where f.oficod = vi_sucur_pri and f.pgcod=1 and f.ofisuc='S' and f.regcod < 100;
        exception  when others then
          null;  
          END;
        end if;          
        --VALIDAR SI LA SUCURSAL ES DE SU DOMINIO.
        IF VI_REGION = 'S' THEN
            BEGIN
                select f.oficod
                into vi_suc_orig
                from fst811 f 
                where f.regcod = vi_regcod  and f.pgcod=1 and f.ofisuc='S' and f.oficod=ve_sucur; --VALIDAR SUCURSAL ES DE LA REGIÓN
            EXCEPTION 
              WHEN OTHERS THEN
                NULL;
            END;
        END IF;
        if vi_suc_orig = ve_sucur then
               vo_rpta:='S';
               RETURN;
        end if;  
        --DATOS DEL QUE SUPLANTA
        --OBTENER EL CARGO. DEL USUARIO SUPLENTE
        BEGIN
             SELECT sng057aut
               INTO flag_aut_sup
               FROM SNG057 s 
              WHERE s.SNG057USR= RPAD(ve_ubuser_sup,10,' ')
                AND s.sng057aut='S';
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
          END;
        --OBTENER LA SURCURSAL ORIGEN DEL USUARIO PRINCIPAL
        if flag_aut_sup = 'S' then
        BEGIN
          select f.ubsuc 
          into vi_sucur_sup
          from fst046 f
          where ubuser=RPAD(ve_ubuser_sup,10,' ');
        vi_suc_orig:= vi_sucur_sup;  
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        --OBTENER LA ZONA DEL USUARIO PRINCIPAL
        vi_regcod:=0;
        BEGIN
          select REGCOD
          into vi_regcod 
          from fst811 f 
          where f.oficod = vi_sucur_sup and f.pgcod=1 and f.ofisuc='S' and f.regcod < 100;
        exception  when others then
          null;  
          END;
        end if;          
        --VALIDAR SI LA SUCURSAL ES DE SU DOMINIO.
        IF VI_REGION = 'S' THEN
            BEGIN
                select f.oficod
                into vi_suc_orig
                from fst811 f 
                where f.regcod = vi_regcod  and f.pgcod=1 and f.ofisuc='S' and f.oficod=ve_sucur; --VALIDAR SUCURSAL ES DE LA REGIÓN
            EXCEPTION 
              WHEN OTHERS THEN
                NULL;
            END;
        END IF;
        
        if vi_suc_orig = ve_sucur then
               vo_rpta:='S';
               RETURN;
        end if;
        
END;
PROCEDURE SP_GESTIONAR_ACCESO_IND3(
                               ve_instancia in number,
                               ve_codigo in number,
                               ve_ubuser_pri in varchar,
                               ve_sucur in number,
                               ve_cargo_pri in number,
                               vo_rpta out varchar
                              )
  IS
  flag_aut_pri varchar(1);
  flag_aut_sup varchar(1);
  VI_REGION varchar(1);
  vi_sucur_pri number;
  vi_sucur_sup number;
  vi_regcod number;
  vi_suc_orig number;
BEGIN
  vo_rpta:='N';
        IF ve_cargo_pri=220 THEN
           VI_REGION := 'S';
        END IF;  
        --OBTENER EL CARGO. DEL USUARIO PRINCIPAL
        BEGIN
             SELECT sng057aut
               INTO flag_aut_pri
               FROM SNG057 s 
              WHERE s.SNG057USR= RPAD(ve_ubuser_pri,10,' ')
                AND s.sng057aut='S';
        EXCEPTION
          WHEN OTHERS THEN
            NULL;    
          END;
        --OBTENER LA SURCURSAL ORIGEN DEL USUARIO PRINCIPAL
        if flag_aut_pri = 'S' then
        BEGIN
          select f.ubsuc 
          into vi_sucur_pri
          from fst046 f
          where ubuser=RPAD(ve_ubuser_pri,10,' ');
        vi_suc_orig:= vi_sucur_pri;  
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        --OBTENER LA ZONA DEL USUARIO PRINCIPAL
        BEGIN
          select REGCOD
          into vi_regcod 
          from fst811 f 
          where f.oficod = vi_sucur_pri and f.pgcod=1 and f.ofisuc='S' and f.regcod < 100;
        exception  when others then
          null;  
          END;
        end if;          
        --VALIDAR SI LA SUCURSAL ES DE SU DOMINIO.
        IF VI_REGION = 'S' THEN
            BEGIN
                select f.oficod
                into vi_suc_orig
                from fst811 f 
                where f.regcod = vi_regcod  and f.pgcod=1 and f.ofisuc='S' and f.oficod=ve_sucur; --VALIDAR SUCURSAL ES DE LA REGIÓN
            EXCEPTION 
              WHEN OTHERS THEN
                NULL;
            END;
        END IF;
        if vi_suc_orig = ve_sucur then
               vo_rpta:='S';
               RETURN;
        end if;  
        IF ve_cargo_pri = 230 OR ve_cargo_pri = 240 THEN
           vo_rpta:='S';
        END IF;
END;  
PROCEDURE SP_GESTIONAR_ACCESO_IND(
                               --ve_instancia in number,
                               --ve_codigo in number,
                               ve_ubuser_pri in varchar,
                               ve_sucur in number,
                               ve_cargo_pri in number,
                               vo_rpta out varchar
                              )
  IS
  flag_aut_pri varchar(1);
  flag_aut_sup varchar(1);
  VI_REGION varchar(1);
  vi_sucur_pri number;
  vi_sucur_sup number;
  vi_regcod number;
  vi_suc_orig number;
BEGIN
  vo_rpta:='N';
        IF ve_cargo_pri=220 THEN
           VI_REGION := 'S';
        END IF;  
        --OBTENER EL CARGO. DEL USUARIO PRINCIPAL
        BEGIN
             SELECT sng057aut
               INTO flag_aut_pri
               FROM SNG057 s 
              WHERE s.SNG057USR= RPAD(ve_ubuser_pri,10,' ')
                AND s.sng057aut='S';
        EXCEPTION
          WHEN OTHERS THEN
            NULL;    
          END;
        --OBTENER LA SURCURSAL ORIGEN DEL USUARIO PRINCIPAL
        if flag_aut_pri = 'S' then
        BEGIN
          select f.ubsuc 
          into vi_sucur_pri
          from fst046 f
          where ubuser=RPAD(ve_ubuser_pri,10,' ');
        vi_suc_orig:= vi_sucur_pri;  
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        --OBTENER LA ZONA DEL USUARIO PRINCIPAL
        BEGIN
          select REGCOD
          into vi_regcod 
          from fst811 f 
          where f.oficod = vi_sucur_pri and f.pgcod=1 and f.ofisuc='S' and f.regcod < 100;
        exception  when others then
          null;  
          END;
        end if;          
        --VALIDAR SI LA SUCURSAL ES DE SU DOMINIO.
        IF VI_REGION = 'S' THEN
            BEGIN
                select f.oficod
                into vi_suc_orig
                from fst811 f 
                where f.regcod = vi_regcod  and f.pgcod=1 and f.ofisuc='S' and f.oficod=ve_sucur; --VALIDAR SUCURSAL ES DE LA REGIÓN
            EXCEPTION 
              WHEN OTHERS THEN
                NULL;
            END;
        END IF;
        if vi_suc_orig = ve_sucur then
               vo_rpta:='S';
               RETURN;
        end if;  
END;  
PROCEDURE SP_ARBOL_FONDOS(
                          
                          ve_pgcod number,
                          ve_scmod number,
                          ve_scsuc  number,
                          ve_scmda  number,
                          ve_scpap  number,
                          ve_sccta  number,
                          ve_scoper number,
                          ve_scsbop number,
                          ve_sctope number,
                          ve_cargo  number,
                          ve_cargo2 number,
                          ve_rpta out varchar
  )IS
  vi_perfil number;
  vi_cargo number;
BEGIN
     ---PROCESO PARA OBTENER EL PERFIL DE LA REPROGRAMACION FONDOS
     BEGIN
          SELECT F.PERFIL
            into VI_PERFIL
            FROM FONDOS G, FONDOS_CREDITOSFACILIDAD F
            WHERE F.IDFONDO = G.IDFONDO
            AND G.ESTADOSOLICITUD = 'BT'
             AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) =
                 ve_sccta
             AND SUBSTR(F.CUENTAOPERACION,
                        INSTR(F.CUENTAOPERACION, '-') + 1,
                        99) = ve_scoper
             AND F.EMPRESA = ve_pgcod
             AND F.SUCURSAL = ve_scsuc
             AND F.MODULO = ve_scmod
             AND F.MONEDA = ve_scmda
             AND F.PAPEL = ve_scpap
             AND F.SUBOPERACION = ve_scsbop
             AND F.TIPOOPERACION = ve_sctope;
     EXCEPTION 
             WHEN OTHERS THEN 
               NULL;        
     END;
     --Evaluar en Guia de Proceso Especial, de acuerdo al Perfil encontrado quien debe ser el aprobador.
     ve_rpta := 'N';
     BEGIN
        SELECT tp1nro1
          INTO vi_cargo
          FROM FST198 F
         WHERE TP1COD1 = 10899
           AND TP1CORR1 = 400000
           AND TP1CORR2 = 5
           AND TP1CORR2 > 0
           AND tp1imp1  = VI_PERFIL
           AND tp1nro1  in (ve_cargo,ve_cargo2);  
     EXCEPTION
       WHEN OTHERS THEN
          ve_rpta:= 'N';         
     END;  
     IF vi_cargo>0 then
       VE_RPTA:='S';
     END IF;  
END;      

PROCEDURE SP_CR_FONDOS_VTASA(
                              ve_instancia number,
                              vo_rpta out varchar
                            )
                            is
   vi_emp xwf700.xwfempresa%type;
   vi_suc xwf700.xwfsucursal%type;
   vi_mod xwf700.xwfmodulo%type;
   vi_mda xwf700.xwfmoneda%type;
   vi_pap xwf700.xwfpapel%type;
   vi_cta xwf700.xwfcuenta%type;
   vi_ope xwf700.xwfoperacion%type;
   vi_sbop xwf700.xwfsubope%type;
   vi_tope xwf700.xwftipope%type;                          
   vi_nuevaTasa number(10,6);
   ve_TpFndo varchar(10);
   VI_TASA number(10,6);
   VI_TEM number(10,6);
  BEGIN
    --OBTENER CLAVEL DEL CREDITO
    BEGIN
         SELECT X.XWFEMPRESA,
                X.XWFSUCURSAL,
                X.XWFMODULO,
                X.XWFMONEDA,
                X.XWFPAPEL,
                X.XWFCUENTA,
                X.XWFOPERACION,
                X.XWFSUBOPE,
                X.XWFTIPOPE 
         INTO vi_EMP,
              vi_suc,
              vi_mod,
              vi_mda,
              vi_pap,
              vi_cta,
              vi_ope,
              vi_sbop,
              vi_tope
         FROM XWF700 X WHERE XWFPRCINS=ve_instancia AND XWFCAR3=1;
       EXCEPTION 
         WHEN OTHERS THEN
           NULL;  
    END;  
    --OBTENER EL TIPO DE PROGRAMA
    BEGIN
       SELECT F.TIPOPROGRAMA,F.NUEVATASA
         INTO ve_TpFndo,vi_nuevaTasa
         FROM FONDOS G, FONDOS_CREDITOSFACILIDAD F
        WHERE F.IDFONDO = G.IDFONDO
         AND G.ESTADOSOLICITUD = 'BT'
         AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) = vi_cta
         AND SUBSTR(F.CUENTAOPERACION, INSTR(F.CUENTAOPERACION, '-') + 1,99) = vi_ope
         AND F.EMPRESA      = vi_emp
         AND F.SUCURSAL     = vi_suc
         AND F.MODULO       = vi_mod
         AND F.MONEDA       = vi_mda
         AND F.PAPEL        = vi_pap
         AND F.SUBOPERACION = vi_sbop
         AND F.TIPOOPERACION= vi_tope;
    END;
    
    --TASA ORIGINAL FSD010
    BEGIN
      SELECT F.AOTASA
        INTO VI_TASA
      FROM FSD010 F
      WHERE F.PGCOD  =  vi_EMP
        AND F.AOMOD  =  vi_suc
        AND F.AOSUC  =  vi_mod
        AND F.AOMDA  =  vi_mda
        AND F.AOPAP  =  vi_pap
        AND F.AOCTA  =  vi_cta
        AND F.AOOPER =  vi_ope
        AND F.AOSBOP =  vi_sbop
        AND F.AOTOPE =  vi_tope;
    EXCEPTION
      WHEN OTHERS THEN
        vi_tasa:=0;    
    END;
    vo_rpta:= 'N';
     IF ve_TpFndo = 'REACTIVA' THEN       
        VI_TEM:= VI_TASA + 0.25;
        IF  VI_TEM >= vi_nuevaTasa and VI_TEM > VI_TASA THEN
            vo_rpta:= 'S';
        END IF;  
     END IF;
     IF ve_TpFndo = 'FAE1' or ve_TpFndo = 'FAE2' THEN
        VI_TEM:= VI_TASA + 0.15;
        IF  VI_TEM >= vi_nuevaTasa and VI_TEM > VI_TASA THEN
            vo_rpta:= 'S';
        END IF;  
     END IF;
END;
end PQ_CR_CREDITOS_CAP_HS;
/

