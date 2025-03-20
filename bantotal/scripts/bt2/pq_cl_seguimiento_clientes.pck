create or replace package PQ_CL_SEGUIMIENTO_CLIENTES is
  /* BHERNARD S. BEISAGA ARENAS
    * INGRESO DE DATOS EN ARCHIVO LOG AQPB582 PARA CREDITOS MI VIVVIENDA
    */
    procedure sp_cl_solicitud_cre(vi_instancia in number, vo_nsol out number,vo_tdoc out varchar2,vo_ndoc out char, vo_destcre out varchar2);

    procedure sp_cl_ultevaluacion(vi_instancia in number,
                                  vi_tdoc in number,
                                  vi_ndoc in varchar,
                                  vo_nsol out number,
                                  vo_tdoc out varchar2,
                                  vo_ndoc out char,
                                  vo_destcre out varchar2);

   procedure sp_cl_new_recurrente(vi_ndoc in char, vo_rpta out char);

  procedure sp_cl_soloscore_cliente(vi_instancia in number, vi_usuario in varchar2, vo_score out varchar2);


    procedure sp_cl_score_cliente(vi_ndoc in varchar2, vo_score out char);


  procedure sp_log_scorecliente(vi_instancia in number,
                                             vi_tdoc in number,
                                             vi_ndoc in char,
                                             vi_destcre in varchar2,
                                             vi_score in varchar2,
                                             vi_tabla in varchar2,
                                             vi_usr in varchar2) ;

/* procedure sp_cl_resolutor_politica_cli(vi_instancia in number, vo_resuelve out varchar2);*/

end;
/

create or replace package body PQ_CL_SEGUIMIENTO_CLIENTES is

procedure sp_cl_solicitud_cre(vi_instancia in number, vo_nsol out number,vo_tdoc out varchar2,vo_ndoc out char, vo_destcre out varchar2)
  is

--  vl_ndoc varchar2(12);
  vl_cant number(5);
begin

  BEGIN
            SELECT SNG001INST, SNG001TDOC, SNG001NDOC, upper(trim(substr(WFATTSVAL,instr(WFATTSVAL,';') + 1 ))), 1
            INTO vo_nsol, vo_tdoc, vo_ndoc, vo_destcre, vl_cant
            FROM sng001, wfattsvalues
            where SNG001INST = WFINSPRCID AND WFATTSID = 'TIPO_CREDITO' AND SNG001INST = vi_instancia;
  EXCEPTION
                   WHEN OTHERS THEN
                     NULL;
  END;

  IF vl_cant IS NULL THEN
             --  DBMS_OUTPUT.put_line('Debe insertar Nro isntancia VALIDA' );
               vo_nsol:=0;
--               return;
  END IF;


end sp_cl_solicitud_cre;

------------------------------------------------



procedure sp_cl_ultevaluacion(vi_instancia in number, vi_tdoc in number, vi_ndoc in varchar,
                                                vo_nsol out number,
                                                vo_tdoc out varchar2,
                                                vo_ndoc out char,
                                                vo_destcre out varchar2) is
       
  vl_ndoc char(12);
  err_code    NUMBER;
  err_msg   VARCHAR2(1500);
begin
  vl_ndoc:= vi_ndoc;
  IF (vi_instancia > 0) THEN
          BEGIN
            SELECT SNG021NDOC INTO vl_ndoc FROM SNG021 WHERE SNG021SOL = vi_instancia;
            EXCEPTION
                   WHEN OTHERS THEN
                   null;
          END;
                    -- sacamos la ultima evaluacion registrada
          BEGIN
            SELECT SNG021SOL, SNG021TDOC, SNG021NDOC, CASE WHEN SNG021TMOD = 13 THEN 'MICROEMPRESAS'
                                                                       WHEN SNG021TMOD = 14 THEN 'CONSUMO NO REVOLVENTE' END
                   INTO vo_nsol, vo_tdoc, vo_ndoc, vo_destcre
             FROM  (SELECT *
                   FROM SNG021
           --        WHERE TRIM(SNG021NDOC) = vl_ndoc
                   WHERE SNG021NDOC = vl_ndoc
                   ORDER BY SNG021FEC DESC)
             WHERE ROWNUM = 1;
          EXCEPTION
             WHEN OTHERS THEN
             vo_nsol:=0;
              err_code := SQLCODE;
              err_msg := SUBSTR(SQLERRM, 1, 500);
              --DBMS_OUTPUT.put_line('ERROR: ' || err_code || '-' || err_msg );

          END;
  ELSIF (/*vi_tdoc > 0 AND*/ length(vl_ndoc) > 0) THEN
           BEGIN
            SELECT SNG021SOL, SNG021TDOC, SNG021NDOC, CASE WHEN SNG021TMOD = 13 THEN 'MICROEMPRESAS'
                                                                       WHEN SNG021TMOD = 14 THEN 'CONSUMO NO REVOLVENTE' END
                   INTO vo_nsol, vo_tdoc, vo_ndoc , vo_destcre
             FROM  (SELECT *
                   FROM SNG021
                   WHERE SNG021NDOC = vl_ndoc
                   ORDER BY SNG021FEC DESC)
             WHERE ROWNUM = 1;
             
                       --     DBMS_OUTPUT.put_line('1');
          EXCEPTION
             WHEN OTHERS THEN
             vo_nsol:=0;
              err_code := SQLCODE;
              err_msg := SUBSTR(SQLERRM, 1, 500);
              --DBMS_OUTPUT.put_line('ERROR: ' || err_code || '-' || err_msg );
          END;
  ELSE
               DBMS_OUTPUT.put_line('Debe isnertar Nro isntancia o Nro documento:' );
  END IF;

end sp_cl_ultevaluacion;

-----------------------------------------------------------------

 procedure sp_cl_new_recurrente(vi_ndoc in char, vo_rpta out char) is

      vl_new number:=0;
      vl_sol NUMBER(10);
      vl_tdoc number(5);
      vl_ndoc char(12);
      vl_destcre varchar2(30);
    begin

        PQ_CL_SEGUIMIENTO_CLIENTES.sp_cl_ultevaluacion(0 ,
                                                       0 ,
                                                       vi_ndoc ,
                                                       vo_nsol      => vl_sol,
                                                       vo_tdoc      => vl_tdoc,
                                                       vo_ndoc      => vl_ndoc,
                                                       vo_destcre   => vl_destcre);

           SELECT COUNT(*) into vl_new
           FROM FSD010 a, FSR008 b
           WHERE AOCTA = CTNRO AND
           a.pgcod = b.pgcod AND
           aomod in (select h.modulo from fst111 h where h.dscod = 50) AND
           CTTFIR = 'T'  AND
           TTCOD = 1 AND
           PENDOC = vi_ndoc;

         -- DBMS_OUTPUT.put_line('Tiene creditos:' || vl_new);

          if vl_new > 0 AND LENGTH(vl_destcre) > 0 then
                     -- DBMS_OUTPUT.put_line('Es recuerrente');
            vo_rpta := 'R';
          elsif vl_new = 0 AND LENGTH(vl_destcre) > 0 THEN
                    --  DBMS_OUTPUT.put_line('Es nuevo');
            vo_rpta := 'N';
          else
            vo_rpta := 'V';
                      --DBMS_OUTPUT.put_line('Cliente vacio o nulo');
          end if;
          DBMS_OUTPUT.put_line(vo_rpta);
 end sp_cl_new_recurrente;


 --------------------
  procedure sp_cl_soloscore_cliente(vi_instancia in number, vi_usuario in varchar2, vo_score out varchar2) is

   vl_sol number(10);
   vl_tdoc number(5);
   vl_ndoc char(12);
   vl_vcharndoc varchar2(12);
   --vl_score char(1);
   vl_scoremicro char(1);
   vl_scorecons char(1);
   vl_cant number;
   vl_dtipocre varchar2(30);
   vl_tabla varchar2(10);
 BEGIN

        PQ_CL_SEGUIMIENTO_CLIENTES.sp_cl_solicitud_cre(vi_instancia ,
                                                          vo_nsol      => vl_sol ,
                                                          vo_tdoc      => vl_tdoc,
                                                          vo_ndoc      => vl_ndoc,
                                                          vo_destcre   => vl_dtipocre);

     IF vl_sol = 0 THEN
       RETURN;
     END IF;



        SELECT MAX(substr(JAQL640RIESG,8,1)), COUNT(*) , 'JAQL640'
        into vo_score , vl_cant, vl_tabla
        FROM (SELECT  *
               FROM jaql640
               WHERE JAQL640TICRE LIKE vl_dtipocre ||'%' AND
                     JAQL640PTDOC = vl_tdoc AND
                     JAQL640PNDOC = vl_ndoc
               ORDER BY JAQL640FEPRE DESC)
        WHERE ROWNUM = 1;

        IF (vl_cant = 0) then --si no esta en la tabla de recurrente lo busca en nuevos
          vl_vcharndoc:=trim(vl_ndoc);
                       IF vl_tdoc IN (21,2,5) THEN
                             /* SELECT substr(JAQL639RIMY,8,1),substr(JAQL639RICNS,8,1),'JAQL639'
                              into vl_scoremicro, vl_scorecons , vl_tabla
                              FROM jaql639
                              WHERE TRIM(JAQL639NUIDE) = TRIM(vl_ndoc);*/
                            BEGIN
                             SELECT substr(JAQL639RIMY,8,1),substr(JAQL639RICNS,8,1),'JAQL639'
                             into vl_scoremicro, vl_scorecons , vl_tabla
                             FROM (SELECT *
                                        FROM jaql639
                                        WHERE JAQL639NUIDE = vl_vcharndoc
                                        ORDER BY JAQL639FEPRE DESC)
                             WHERE ROWNUM = 1;
                             EXCEPTION
                                WHEN OTHERS THEN
                                 NULL;
                             END;

                       ELSE
                             /* SELECT substr(JAQL639RIMY,8,1),substr(JAQL639RICNS,8,1),'JAQL639'
                              into vl_scoremicro, vl_scorecons , vl_tabla
                              FROM jaql639
                              WHERE JAQL639NURUC = vl_ndoc;*/
                             BEGIN
                               SELECT substr(JAQL639RIMY,8,1),substr(JAQL639RICNS,8,1),'JAQL639'
                               into vl_scoremicro, vl_scorecons , vl_tabla
                               FROM (SELECT *
                                          FROM jaql639
                                          WHERE JAQL639NURUC = vl_vcharndoc
                                          ORDER BY JAQL639FEPRE DESC)
                               WHERE ROWNUM = 1;
                              EXCEPTION
                                WHEN OTHERS THEN
                                 NULL;
                              END;
                       END IF;
                      IF vl_dtipocre = 'MICROEMPRESAS' then --micro
                             vo_score:= vl_scoremicro;
                       END IF;
                      IF vl_dtipocre = 'CONSUMO NO REVOLVENTE' then --consumo
                             vo_score:= vl_scorecons;
                      END IF;
        END IF;
       -- DBMS_OUTPUT.put_line('sU SCORE ES:' || vo_score ||' dE LA TABLA:'||vl_tabla);


         PQ_CL_SEGUIMIENTO_CLIENTES.sp_log_scorecliente( vl_sol,
                                                         vl_tdoc,
                                                         vl_ndoc,
                                                         vl_dtipocre,
                                                         vo_score,
                                                         vl_tabla,
                                                         vi_usuario);

 end sp_cl_soloscore_cliente;

 --------------------------

 procedure sp_cl_score_cliente(vi_ndoc in varchar2, vo_score out char) is
   vl_rpta char(1);
   vl_score char(1);
   vl_scoremicro char(1);
   vl_scorecons char(1);
   vl_cant number;
--   vl_ntipocre number(4);
      vl_dtipocre varchar2(30);
      vl_sol NUMBER(10);
      vl_tdoc number(5);
      vl_ndoc char(12);
      vl_vcharndoc varchar(12);
      habilitar number(5);
      vl_flagvar number(2);
     -- vic_ndoc char(12);

 BEGIN   
       -- vic_ndoc:=  vi_ndoc;              
        SELECT TP1NRO1 INTO habilitar FROM fst198 where tp1cod1 = 10899 and tp1corr1 = 6000 AND TP1CORR2 = 10;          
          
           PQ_CL_SEGUIMIENTO_CLIENTES.sp_cl_ultevaluacion(0 ,
                                                          0 ,
                                                          vi_ndoc ,
                                                          vo_nsol      => vl_sol,
                                                          vo_tdoc      => vl_tdoc,
                                                          vo_ndoc      => vl_ndoc,
                                                          vo_destcre   => vl_dtipocre);

           PQ_CL_SEGUIMIENTO_CLIENTES.sp_cl_new_recurrente(vi_ndoc ,
                                                           vo_rpta     => vl_rpta);
                                                         
           --DBMS_OUTPUT.put_line('tipo documento: ' ||vl_tdoc );
           --DBMS_OUTPUT.put_line('Destcre: ' ||vl_dtipocre );
                                 
        IF (habilitar = 2) THEN -- SI HABILITADO ES (2), ESTA HABILITADO EL CONTROL          
          BEGIN 																																				  																	   																								   											

        if vl_rpta = 'R' then
               --SCORE DE SEGUIMIENTO PARA RECURRENTES ()
               SELECT MAX(substr(JAQL640RIESG,8,1)), COUNT(*)
               into vl_score , vl_cant
               FROM (SELECT  *
                    FROM jaql640
                    WHERE JAQL640TICRE LIKE vl_dtipocre ||'%' AND
                     JAQL640PTDOC = vl_tdoc AND
                     JAQL640PNDOC = vl_ndoc
                     ORDER BY JAQL640FEPRE DESC)
               WHERE ROWNUM = 1;
               BEGIN                
                     SELECT count(*) into vl_flagvar FROM fst198 
                            where tp1cod1 = 11161 and tp1corr1 = 5 
                              and tp1corr2 = 4 and tp1corr3 > 0 
                              and tp1desc = rpad(vl_score, 30, ' ');    
               END;
               --if vl_score in ('A','B','C','D','E','F') and vl_cant > 0 then --apachecoh 2022.09.27 se puso en guia
               if vl_flagvar > 0 and vl_cant > 0 then 
                         DBMS_OUTPUT.put_line('Recurrente encontrado tabla recurrentes JAQL640');
                         vo_score := 'S';
               elsif (vl_cant = 0) then --si no esta en la tabla de recurrente lo busca en nuevos
                      vl_vcharndoc := TRIM(vl_ndoc);
                      vl_cant := 1;
                      IF vl_tdoc IN (21,2,5) THEN
                             BEGIN
                               SELECT substr(JAQL639RIMY,8,1),substr(JAQL639RICNS,8,1)
                               into vl_scoremicro, vl_scorecons
                               FROM (SELECT *
                                          FROM jaql639
                                          WHERE JAQL639NUIDE = vl_vcharndoc
                                          ORDER BY JAQL639FEPRE DESC)
                               WHERE ROWNUM = 1;
                               EXCEPTION
                                WHEN OTHERS THEN
                                    vl_cant := 0; --APACHECOH 2022.10.25 EN CASO DE NO ENCONTRAR
                              END;
                       ELSE
                              BEGIN
                                 SELECT substr(JAQL639RIMY,8,1),substr(JAQL639RICNS,8,1)
                                 into vl_scoremicro, vl_scorecons
                                 FROM (SELECT *
                                            FROM jaql639
                                            WHERE JAQL639NURUC = vl_vcharndoc
                                            ORDER BY JAQL639FEPRE DESC)
                                 WHERE ROWNUM = 1;
                                 EXCEPTION
                                     WHEN OTHERS THEN
                                     vl_cant := 0; --APACHECOH 2022.10.25 EN CASO DE NO ENCONTRAR
                              END;
                       END IF;
                       IF vl_dtipocre = 'MICROEMPRESAS' then --micro
                             vl_score:= vl_scoremicro;                             
                             DBMS_OUTPUT.put_line('Recurrente encontrado tabla nuevo jaql639');
                       END IF;
                       IF vl_dtipocre = 'CONSUMO NO REVOLVENTE' then --consumo
                             vl_score:= vl_scorecons;
                             DBMS_OUTPUT.put_line('Recurrente encontrado tabla nuevo jaql639');
                       END IF;
                       BEGIN                
                             SELECT count(*) into vl_flagvar FROM fst198 
                                    where tp1cod1 = 11161 and tp1corr1 = 5 
                                      and tp1corr2 = 4 and tp1corr3 > 0 
                                      and tp1desc = rpad(vl_score, 30, ' ');               
                       END;
                       IF vl_flagvar > 0 and vl_cant > 0 then 
                       --IF vl_score in ('A','B','C','D','E','F') then --apachecoh 2022.09.27 se puso en guia
                          vo_score := 'S';
                         -- DBMS_OUTPUT.put_line('5');
                       ELSIF vl_cant > 0 then                         
                          vo_score := 'N';
                         -- DBMS_OUTPUT.put_line('6');
                       ELSE
                          vo_score := 'S';
                       END IF;
               else
                       vo_score := 'N';
                       --DBMS_OUTPUT.put_line('7');
               end IF;
        end if;


        IF vl_rpta = 'N' THEN
             vl_vcharndoc := TRIM(vl_ndoc);
                      IF vl_tdoc IN (21,2,5) THEN
                               BEGIN
                               SELECT substr(JAQL639RIMY,8,1),substr(JAQL639RICNS,8,1)
                               into vl_scoremicro, vl_scorecons
                               FROM (SELECT *
                                          FROM jaql639
                                          WHERE JAQL639NUIDE = vl_vcharndoc
                                          ORDER BY JAQL639FEPRE DESC)
                               WHERE ROWNUM = 1;
                               EXCEPTION
                                WHEN OTHERS THEN
                                 NULL;
                              END;
                       ELSE
                              BEGIN
                                 SELECT substr(JAQL639RIMY,8,1),substr(JAQL639RICNS,8,1)
                                 into vl_scoremicro, vl_scorecons
                                 FROM (SELECT *
                                            FROM jaql639
                                            WHERE JAQL639NURUC = vl_vcharndoc
                                            ORDER BY JAQL639FEPRE DESC)
                                 WHERE ROWNUM = 1;
                                 EXCEPTION
                                     WHEN OTHERS THEN
                                     NULL;
                              END;

                       END IF;
                      IF vl_dtipocre = 'MICROEMPRESAS' then --micro
                             vl_score:= vl_scoremicro;
                       END IF;
                      IF vl_dtipocre = 'CONSUMO NO REVOLVENTE' then --consumo
                             vl_score:= vl_scorecons;
                      END IF;
                      DBMS_OUTPUT.put_line('Cliente nuevo encontrado tabla nuevos jaql639');BEGIN                
                       SELECT count(*) into vl_flagvar FROM fst198 
                              where tp1cod1 = 11161 and tp1corr1 = 5 
                                and tp1corr2 = 4 and tp1corr3 > 0 
                                and tp1desc = rpad(vl_score, 30, ' ');               
                       END;
                       IF vl_flagvar > 0 then
                       --IF vl_score in ('A','B','C','D','E','F') then
                          vo_score := 'S';
                          --DBMS_OUTPUT.put_line('10');
                       ELSE
                          vo_score := 'N';
                         -- DBMS_OUTPUT.put_line('11');
                       END IF;
        END IF;
        IF vl_rpta = 'V' THEN --SI ES VACIO
            vo_score := 'S';--cambiado a S en caso inexistente
        END IF;
      -- DBMS_OUTPUT.put_line(vo_score);
             END;
          ELSE  
            BEGIN 
             vo_score := 'S';         
             DBMS_OUTPUT.put_line('Control deshabilitado');
             END;
          END IF;				 
								  							 																				 
 end sp_cl_score_cliente;


  procedure sp_log_scorecliente(vi_instancia in number,
                                             vi_tdoc in number,
                                             vi_ndoc in char,
                                             vi_destcre in varchar2,
                                             vi_score in varchar2,
                                             vi_tabla in varchar2,
                                             vi_usr in varchar2) is
    err_code NUMBER;
    err_msg  VARCHAR2(1000);
 BEGIN
   BEGIN
               INSERT INTO AQPB766 (AQPB766NSOL ,
                                    AQPB766TDOC ,
                                    AQPB766NDOC ,
                                    AQPB766TCRE ,
                                    AQPB766SCOR ,
                                    AQPB766TABL ,
                                    AQPB766USRP ,
                                    AQPB766FPRC ,
                                    AQPB766HORA )
                             VALUES (vi_instancia,
                                     vi_tdoc,
                                     vi_ndoc,
                                     vi_destcre,
                                     vi_score,
                                     vi_tabla,
                                     vi_usr,
                                     trunc(sysdate),
                                     to_char(sysdate, 'HH24:MI:SS')
                                     );
           --   DBMS_OUTPUT.put_line('Filas insertadas: ' || SQL%ROWCOUNT);
                      commit;
     EXCEPTION
       WHEN OTHERS THEN
                err_code := SQLCODE;
                err_msg := SUBSTR(SQLERRM, 1, 500);
               -- DBMS_OUTPUT.put_line(err_msg);
   END;
 end sp_log_scorecliente;

 /*procedure sp_cl_resolutor_politica_cli(vi_instancia in number, vo_resuelve out varchar2) is

   vl_score varchar2(1);
 BEGIN
   BEGIN
    PQ_CL_SEGUIMIENTO_CLIENTES.sp_cl_soloscore_cliente(vi_instancia ,
                                                       vo_score     => vl_score) ;
    IF vl_score in ('A','B','C','D','E','F') then
                          vo_resuelve := 'S';              -- son alertas
                       ELSE
                          vo_resuelve := 'N';

    END IF;
                                         --     DBMS_OUTPUT.put_line('RESUELVE:' || vo_resuelve);
   END;
 END sp_cl_resolutor_politica_cli;*/



end;
/

