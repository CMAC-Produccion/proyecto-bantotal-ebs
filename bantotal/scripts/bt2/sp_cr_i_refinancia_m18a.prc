create or replace procedure SP_CR_I_REFINANCIA_M18A(PN_BCCTA in number,
                                  PN_BCOPER in number,
                                  PN_MONTO in number,
                                  PC_MENSAJE in varchar2
                                  ) is
   -- *****************************************************************
    -- Nombre                     : SP_CR_I_REFINANCIA_M18A
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.01.28
    -- Autor de Creación          : YYAMPI/DCASTRO
    -- Uso                        : INSERTA DATA REFINANCIADOS BI - MEMO 18
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2024.02.20
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: se modifico procedimiento
    -- *****************************************************************

 ln_existeBI char(1) := 'N';
 ln_existe char(1) := 'N';
 lc_coderr number;

 BEGIN

    --valida existe en BI
    BEGIN
        select 'S'
          into ln_existeBI
          from USRBNDJ.AQPD153D A
         where aqpd153feccar = trunc(sysdate)
           and aqpd153cta = PN_BCCTA --cuenta
           and aqpd153ope = PN_BCOPER; --operacion

      exception
        when others then
          ln_existeBI := 'N';
          dbms_output.put_line('Credito '||PN_BCCTA||'-'||PN_BCOPER ||' , no se encuentra registrado en base BI, coordinar con BI ' );
    END;

    if  ln_existeBI = 'S' then

          --valida existe refinanciado
          BEGIN
            select 'S'
              into ln_existe
              from FSD010 F, USRBNDJ.AQPD153D A
             where f.pgcod = A.aqpd153emp
               and f.aomod = A.aqpd153mod
               and f.aosuc = aqpd153suc
               and f.aomda = aqpd153mda
               and f.aopap = aqpd153pap
               and f.aocta = aqpd153cta
               and f.aooper = aqpd153ope
               and f.aosbop = aqpd153sbop
               and f.aotope = aqpd153tope
               and aqpd153feccar = trunc(sysdate)
               and aqpd153cta = PN_BCCTA --cuenta
               and aqpd153ope = PN_BCOPER --operacion
               and f.aostat in (0, 61);
          exception
            when others then
              ln_existe := 'N';
              dbms_output.put_line('Credito '||PN_BCCTA||'-'||PN_BCOPER ||' , no se encuentra en estado Normal/Refinanciado ' );
          END;

          if ln_existe = 'S' then

             IF PN_MONTO = 0 THEN

                begin
                   insert into aqpd153
                    (aqpd153pais, aqpd153tipdoc, aqpd153numdoc, aqpd153emp, aqpd153mod, aqpd153suc, aqpd153mda, aqpd153pap,
                    aqpd153cta, aqpd153ope, aqpd153sbop, aqpd153tope, aqpd153inst, aqpd153mto, aqpd153sitneg, aqpd153mtocap,
                    aqpd153grurep, aqpd153feccar, aqpd153horcar, aqpd153estcar, aqpd153tipben, aqpd153memo, AQPD153AUXV1, AQPD153AUXN1
                    )
                  select aqpd153pais, aqpd153tipdoc, aqpd153numdoc, aqpd153emp, aqpd153mod, aqpd153suc, aqpd153mda, aqpd153pap,
                    aqpd153cta, aqpd153ope, aqpd153sbop, aqpd153tope, aqpd153inst, aqpd153mto, aqpd153sitneg, aqpd153mtocap,
                    aqpd153grurep, aqpd153feccar, to_char(sysdate, 'HH24:MM:SS'), aqpd153estcar, UPPER(aqpd153tipben), aqpd153memo,
                     SUBSTR(PC_MENSAJE, 1, 130) , 0
                   from USRBNDJ.AQPD153D
                  where aqpd153feccar = trunc(sysdate)
                    and aqpd153cta = PN_BCCTA--cuenta
                    and aqpd153ope = PN_BCOPER;--operacion
                    COMMIT;
                    dbms_output.put_line('Credito '||PN_BCCTA||'-'||PN_BCOPER ||' insertado exitosamente' );
                exception when others then
                    dbms_output.put_line('Error en credito (Mto Cap=0) '||PN_BCCTA||'-'||PN_BCOPER ||' '||sqlerrm||'-'|| sqlcode );
                  end;



             ELSE ---MONTO MAYOR 0

               BEGIN
                  MERGE INTO AQPD153 A
                  USING (select aqpd153pais, aqpd153tipdoc, aqpd153numdoc, aqpd153emp, aqpd153mod, aqpd153suc, aqpd153mda, aqpd153pap,
                                aqpd153cta, aqpd153ope, aqpd153sbop, aqpd153tope, aqpd153inst, aqpd153mto, aqpd153sitneg, aqpd153mtocap,
                                aqpd153grurep, aqpd153feccar, to_char(sysdate, 'HH24:MM:SS')aqpd153horcar, aqpd153estcar, UPPER(aqpd153tipben) aqpd153tipben, aqpd153memo,
                                AQPD153AUXN1,
                                NULL AQPD151AUXN2,
                                AQPD153AUXV1,---
                                NULL AQPD153AUXV2,
                                NULL AQPD153AUXD1,
                                NULL AQPD153AUXD2 --28
                           from USRBNDJ.AQPD153D
                          where aqpd153feccar = trunc(sysdate)
                            and aqpd153cta = PN_BCCTA --cuenta
                            and aqpd153ope = PN_BCOPER --operacion

                         ) B
                  ON (a.aqpd153cta = B.aqpd153cta and a.aqpd153ope = B.aqpd153ope)

                  WHEN MATCHED THEN
                    UPDATE
                       SET A.aqpd153mtocap = PN_MONTO,
                           A.AQPD153AUXN1  = B.AQPD153AUXN1,--MTO_CAPITALIZACION,
                           A.AQPD153AUXV1  = B.AQPD153AUXV1,
                           A.AQPD153HORCAR = B.aqpd153horcar
                  WHEN NOT MATCHED THEN
                    INSERT
                      (A.aqpd153pais, --1
                       A.aqpd153tipdoc,
                       A.aqpd153numdoc,
                       A.aqpd153emp,
                       A.aqpd153mod,
                       A.aqpd153suc,
                       A.aqpd153mda,
                       A.aqpd153pap,
                       A.aqpd153cta,
                       A.aqpd153ope,
                       A.aqpd153sbop,
                       A.aqpd153tope,
                       A.aqpd153inst,
                       A.aqpd153mto,
                       A.aqpd153sitneg,
                       A.aqpd153mtocap,
                       A.aqpd153grurep,
                       A.aqpd153feccar,
                       A.aqpd153horcar,
                       A.aqpd153estcar,
                       A.aqpd153tipben,
                       A.aqpd153memo,
                       A.AQPD153AUXN1,
                       A.AQPD151AUXN2,
                       A.AQPD153AUXV1,
                       A.AQPD153AUXV2,
                       A.AQPD153AUXD1,
                       A.AQPD153AUXD2) --28


                    VALUES
                    ( B.aqpd153pais, B.aqpd153tipdoc, B.aqpd153tipdoc, B.aqpd153emp, B.aqpd153mod, B.aqpd153suc, B.aqpd153mda, B.aqpd153pap,
                      B.aqpd153cta, B.aqpd153ope, B.aqpd153sbop, B.aqpd153tope, B.aqpd153inst, B.aqpd153mto, B.aqpd153sitneg, DECODE(PN_MONTO,0,B.aqpd153mtocap, PN_MONTO), B.aqpd153grurep,
                      B.aqpd153feccar, B.aqpd153horcar, B.aqpd153estcar, B.aqpd153tipben, B.aqpd153memo, B.AQPD153AUXN1, B.AQPD151AUXN2, DECODE(PC_MENSAJE,'',B.AQPD153AUXV1, substr(PC_MENSAJE,1,130) ), B.AQPD153AUXV2, B.AQPD153AUXD1, B.AQPD153AUXD2);
                    COMMIT;
                      dbms_output.put_line('Credito '||PN_BCCTA||'-'||PN_BCOPER ||' PROCESADO EXITOSAMENTE' );
               EXCEPTION WHEN OTHERS THEN
                     dbms_output.put_line('Error en credito (Mto Cap>0) '||PN_BCCTA||'-'||PN_BCOPER ||' '||sqlerrm||'-'|| sqlcode );

               END;
          END IF;
    END IF;
  END IF;


insert into AQPB876 values (user,sysdate,'SP_CR_I_REFINANCIA_M18A', PN_BCCTA ||'-'||PN_BCOPER ||'-'||PN_MONTO ||'-'|| PC_MENSAJE);
commit;

end SP_CR_I_REFINANCIA_M18A;
/

