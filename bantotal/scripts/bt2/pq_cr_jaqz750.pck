create or replace package pq_cr_JAQZ750 is

  -- Author  : CCERPA
  -- Created : 16/02/2018 09:50:23 a.m.
  -- Purpose :

Procedure SP_CR_reporte_insertdata ( ln_pais   in number,
                                     ln_tdoc   in number,
                                     lv_ndoc   in varchar,
                                     ln_docod  in  number,
                                     ln_corr   in number,
                                     ln_medid  in number,
                                     ln_comtr  in number,
                                     lc_user   in varchar,
                                     ld_fech   in date,
                                     ln_est    in number,
                                     ln_tipmed in number );
 
 Procedure SP_CR_reporte_deletedata ( ln_cod    in number,
                                     ln_pais   in number,
                                     ln_tdoc   in number,
                                     lv_ndoc   in char,
                                     ln_docod  in  number,
                                     ln_corr   in number,
                                     ld_date in date );      
                                                                    
Procedure SP_CR_reporte_Buscar ( ln_pais   in number,
                                 ln_tdoc   in number,
                                 lv_ndoc   in varchar,
                                 ln_tipo   in number,
                                 lv_user   in varchar );
 Procedure SP_CR_reporte_update ( ln_pais   in number,
                                 ln_tdoc   in number,
                                 lv_ndoc   in varchar,
                                 ln_docod   in number,
                                 ln_tipomed  in number ); 
Procedure SP_CR_reporte_enflujo ( ln_pais   in number,
                                 ln_tdoc   in number,
                                 lv_ndoc   in varchar,
                                 ln_contador   OUT number )  ; 
 Procedure SP_CR_reporte_insertdatacaso2(ln_pais  in number,
                                     ln_tdoc  in number,
                                     lv_ndoc  in varchar,
                                     ln_docod in number,
                                     ln_corr  in number,
                                     ln_medid in number,
                                     ln_comtr in number,
                                     lc_user  in varchar,
                                     ld_fech  in date,
                                     ln_est   in number,
                                     ln_tipmed   in number) ;                                                              
                                
end pq_cr_JAQZ750;
/

create or replace package body pq_cr_JAQZ750 is
  -- *****************************************************************
  -- Nombre                     : sp_resultadonetolinea
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          :
  -- Autor de Creación          : CRISTHIAN CERPA
  -- Uso                        : EVALUA EL OTORGAMIENTO DEUN CREDITO HIPOTECARIO cAJA.
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  --
  -- Retorno                    :
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  --
  -- *****************************************************************

  Procedure SP_CR_reporte_insertdata(ln_pais  in number,
                                     ln_tdoc  in number,
                                     lv_ndoc  in varchar,
                                     ln_docod in number,
                                     ln_corr  in number,
                                     ln_medid in number,
                                     ln_comtr in number,
                                     lc_user  in varchar,
                                     ld_fech  in date,
                                     ln_est   in number,
                                     ln_tipmed   in number) is
    lc_pendoc char(12);
 ln_exitente  number;
  valor_secuenc number;
  lc_hora char(8) ;
  BEGIN

    lc_pendoc := RPAD(lv_ndoc, 12, ' ');
    BEGIN
      begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
        exception
            when others then
            lc_hora:='00:00:00';
      end ;
      select count(*) into ln_exitente from jaqz750 where jaqz750.jaqz750fcn=(select fst017.pgfape from fst017 where fst017.pgcod=1);
    
      BEGIN --EFUENTES 20220419 - SE MODIFIO LA FORMA DE OBTENER LA SECUENCIA
        select NVL(MAX(JAQZ750COD),0) + 1 
          into valor_secuenc
          from jaqz750
         where JAQZ750PAI = ln_pais
           AND JAQZ750TDO = ln_tdoc
           AND JAQZ750NDO = lc_pendoc
           AND JAQZ750DOCOD = ln_docod
           AND JAQZ750CORR = ln_corr
           AND JAQZ750FCN = ld_fech;
      EXCEPTION
        WHEN OTHERS THEN
          valor_secuenc := 1;
      END;
      
      BEGIN
        INSERT INTO JAQZ750
          (JAQZ750COD,
           JAQZ750PAI,
           JAQZ750TDO,
           JAQZ750NDO,
           JAQZ750DOCOD,
           JAQZ750CORR,
           JAQZ750MEDID,
           JAQZ750CONTR,
           JAQZ750USUR,
           JAQZ750FCN,
           JAQZ750EST,
           JAQZ750TMED,
           jAQZ750IND,
           jAQZ750HOR)
        VALUES
          (valor_secuenc,
           ln_pais,
           ln_tdoc,
           lc_pendoc,
           ln_docod,
           ln_corr,
           ln_medid,
           ln_comtr,
           lc_user,
           ld_fech,
           ln_est,
           ln_tipmed,
           'N',
           lc_hora);
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    End;
  end SP_CR_reporte_insertdata;
  
  /*Procedure SP_CR_reporte_insertdata(ln_pais  in number, -- EFUENTES COMENTADO
                                     ln_tdoc  in number,
                                     lv_ndoc  in varchar,
                                     ln_docod in number,
                                     ln_corr  in number,
                                     ln_medid in number,
                                     ln_comtr in number,
                                     lc_user  in varchar,
                                     ld_fech  in date,
                                     ln_est   in number,
                                     ln_tipmed   in number) is
    lc_pendoc char(12);
 ln_exitente  number;
  valor_secuenc number;
  lc_hora char(8) ;
  BEGIN

    lc_pendoc := RPAD(lv_ndoc, 12, ' ');
    BEGIN
      begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
        exception
            when others then
            lc_hora:='00:00:00';
      end ;
      select count(*) into ln_exitente from jaqz750 where jaqz750.jaqz750fcn=(select fst017.pgfape from fst017 where fst017.pgcod=1);
    
      if ln_exitente=0 then
        BEGIN --EFUENTES 20220419 - SE MODIFIO LA FORMA DE OBTENER LA SECUENCIA
          select MAX(JAQZ750COD) + 1 
            into valor_secuenc
            from jaqz750
           where JAQZ750PAI = ln_pais
             AND JAQZ750TDO = ln_tdoc
             AND JAQZ750NDO = lc_pendoc
             AND JAQZ750DOCOD = ln_docod
             AND JAQZ750CORR = ln_corr
             AND JAQZ750FCN = ld_fech;
        EXCEPTION
          WHEN OTHERS THEN
            valor_secuenc := 1;
        END;
      else
        valor_secuenc:=1;
      end if;
      \*
      if ln_exitente=0 then
       -- select nvl(max (jaqz750.jaqz750cod),0) into valor_secuenc from jaqz750 where jaqz750.jaqz750fcn=(select fst017.pgfape-1 from fst017 where fst017.pgcod=1);
            if valor_secuenc=0  then
             valor_secuenc:=1;
           end if;
            EXECUTE IMMEDIATE  concat(concat('ALTER SEQUENCE SQ_CR_JAQZ750 INCREMENT BY ', valor_secuenc),' MINVALUE 1');
      else
        if  ln_exitente=1 then
               EXECUTE IMMEDIATE 'ALTER SEQUENCE SQ_CR_JAQZ750 INCREMENT BY 1 MINVALUE 1';
        end if ;
      end if;
      *\
      BEGIN
        INSERT INTO JAQZ750
          (JAQZ750COD,
           JAQZ750PAI,
           JAQZ750TDO,
           JAQZ750NDO,
           JAQZ750DOCOD,
           JAQZ750CORR,
           JAQZ750MEDID,
           JAQZ750CONTR,
           JAQZ750USUR,
           JAQZ750FCN,
           JAQZ750EST,
           JAQZ750TMED,
           jAQZ750IND,
           jAQZ750HOR)
        VALUES
          (valor_secuenc,
           ln_pais,
           ln_tdoc,
           lc_pendoc,
           ln_docod,
           ln_corr,
           ln_medid,
           ln_comtr,
           lc_user,
           ld_fech,
           ln_est,
           ln_tipmed,
           'N',
           lc_hora);
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    End;
    --EXECUTE IMMEDIATE 'ALTER SEQUENCE SQ_CR_JAQZ750 INCREMENT BY 1 MINVALUE 1';
  end SP_CR_reporte_insertdata;*/
-------------------------------------------------------------------------------------

 Procedure SP_CR_reporte_deletedata (ln_cod    in number,
                                     ln_pais   in number,
                                     ln_tdoc   in number,
                                     lv_ndoc   in char,
                                     ln_docod  in  number,
                                     ln_corr   in number,
                                     ld_date in date ) is
   -- lc_pendoc char(12);

  BEGIN
    --  lc_pendoc := RPAD(lv_ndoc, 12, ' ');
    BEGIN
      update jaqz750
         set jaqz750.jaqz750est   = 0
       where jaqz750.jaqz750cod   = ln_cod
         and jaqz750.jaqz750pai   = ln_pais
         and jaqz750.jaqz750tdo   = ln_tdoc
         and jaqz750.jaqz750ndo   = lv_ndoc
         and jaqz750.jaqz750docod = ln_docod
         and jaqz750.jaqz750corr  = ln_corr
         and jaqz750.jaqz750fcn   = ld_date;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  end SP_CR_reporte_deletedata;

-------------------------------------------------------------------------------------
Procedure SP_CR_reporte_Buscar ( ln_pais   in number,
                                 ln_tdoc   in number,
                                 lv_ndoc   in varchar,
                                 ln_tipo   in number,
                                 lv_user   in varchar ) is
    lc_pendoc char(12);
    lc_user   char(10);
    fechsys   date;
  BEGIN

    lc_pendoc := RPAD(lv_ndoc, 12, ' ');
    lc_user:=RPAD(lv_user, 10, ' ');
    BEGIN

      delete aqpa253 where aqpa253.aqpa253usur=lc_user;
      commit;
      select fst017.pgfape into fechsys from fst017 where fst017.pgcod=1;
        if ln_tipo=1 then
          insert into aqpa253 (aqpa253pai,aqpa253tdo,aqpa253ndo,aqpa253contr,aqpa253tmed,aqpa253docod,aqpa253usur,aqpa253fcn)
              select t1.JAQZ750PAI,t1.jaqz750tdo,t1.jaqz750ndo, t1.JAQZ750CONTR,t1.jaqz750tmed,s.docod,lc_user,fechsys 
              from jaqz750 t1 
                     inner join sngc13 s on t1.jaqz750pai=s.sngc13pais and t1.jaqz750tdo=s.sngc13tdoc and
                t1.jaqz750ndo=s.sngc13ndoc and t1.jaqz750docod=s.docod and t1.jaqz750corr=s.sngc13corr
                     inner join jaqz750 t2 on t1.JAQZ750CONTR = t2.JAQZ750CONTR
                  AND t1.jaqz750tmed =t2.jaqz750tmed
                     inner join sngc13 s2 on t2.jaqz750pai=s2.sngc13pais and t2.jaqz750tdo=s2.sngc13tdoc and
                t2.jaqz750ndo=s2.sngc13ndoc and t2.jaqz750docod=s2.docod and t2.jaqz750corr=s2.sngc13corr
                where t2.jaqz750pai = ln_pais---valor1
                 and t2.jaqz750tdo = ln_tdoc---valor2
                 and t2.jaqz750ndo = lc_pendoc---valor3
                 and s2.sngc13est = 'H'
                 and t2.jaqz750est = 1
                 and t2.jaqz750tmed<>5   
                 and s.sngc13est = 'H'
                 and s.sngc13prov= s2.sngc13prov             
                 group by t1.JAQZ750PAI,t1.jaqz750tdo,t1.jaqz750ndo, t1.JAQZ750CONTR,t1.jaqz750tmed,s.docod ;
                  commit;
        else
           if ln_tipo=2 then
                       insert into aqpa253 (aqpa253pai,aqpa253tdo,aqpa253ndo,aqpa253contr,aqpa253tmed,aqpa253docod,aqpa253usur,aqpa253fcn)
               select t1.JAQZ750PAI,t1.jaqz750tdo,t1.jaqz750ndo, t1.JAQZ750CONTR,t1.jaqz750tmed,s.docod,lc_user,fechsys 
              from jaqz750 t1 
                     inner join sngc13 s on t1.jaqz750pai=s.sngc13pais and t1.jaqz750tdo=s.sngc13tdoc and
                t1.jaqz750ndo=s.sngc13ndoc and t1.jaqz750docod=s.docod and t1.jaqz750corr=s.sngc13corr
                     inner join jaqz750 t2 on t1.JAQZ750CONTR = t2.JAQZ750CONTR
                  AND t1.jaqz750tmed =t2.jaqz750tmed
                     inner join sngc13 s2 on t2.jaqz750pai=s2.sngc13pais and t2.jaqz750tdo=s2.sngc13tdoc and
                t2.jaqz750ndo=s2.sngc13ndoc and t2.jaqz750docod=s2.docod and t2.jaqz750corr=s2.sngc13corr
                where t2.jaqz750pai = ln_pais---valor1
                 and t2.jaqz750tdo = ln_tdoc---valor2
                 and t2.jaqz750ndo = lc_pendoc---valor3
                 and s2.sngc13est = 'H'
                 and t2.jaqz750est = 1
                 and t2.jaqz750tmed<>5   
                 and s.sngc13est = 'H'
                 and s.sngc13dpto= s2.sngc13dpto             
                 group by t1.JAQZ750PAI,t1.jaqz750tdo,t1.jaqz750ndo, t1.JAQZ750CONTR,t1.jaqz750tmed,s.docod ;
                   commit;
            end if;
        end if;
    End;
  end SP_CR_reporte_Buscar;
-------------------------------------------------------------------------------------
 Procedure SP_CR_reporte_update ( ln_pais   in number,
                                 ln_tdoc   in number,
                                 lv_ndoc   in varchar,
                                 ln_docod   in number,
                                 ln_tipomed  in number ) is
    lc_pendoc char(12);
  BEGIN
    lc_pendoc := RPAD(lv_ndoc, 12, ' ');
    BEGIN
      update jaqz750
         set jaqz750.jaqz750est   = 0
       where jaqz750.jaqz750pai   = ln_pais
         and jaqz750.jaqz750tdo   = ln_tdoc
         and jaqz750.jaqz750ndo   = lc_pendoc
         and jaqz750.jaqz750docod = ln_docod
         and jaqz750.jaqz750tmed  = ln_tipomed;
      COMMIT; 
    EXCEPTION
      WHEN OTHERS THEN
        null;
    END;
  end SP_CR_reporte_update;
-------------------------------------------------------------------------------------
 Procedure SP_CR_reporte_enflujo ( ln_pais   in number,
                                 ln_tdoc   in number,
                                 lv_ndoc   in varchar,
                                 ln_contador   OUT number ) is
    lc_pendoc char(12);

  BEGIN

    lc_pendoc := RPAD(lv_ndoc, 12, ' ');
    
    BEGIN    
      select count(*)
        INTO ln_contador
        from (select w.wfinsprcid ln_Instancia
                from wfwrkitems w
               where w.wfinsprcid in
                     (select distinct (s.sng001inst)
                        from sng001 s
                       where s.sng001cta in
                             (select f.ctnro
                                from fsr008 f
                               where f.pepais = ln_pais
                                 and f.petdoc = ln_tdoc
                                 and f.pendoc = lc_pendoc))
                 and w.wfitemstsact = 1
                 and w.wftaskcod in (55, 11)
              union
              select w.wfinsprcid ln_Instancia
                from wfwrkitems w
               where w.wfinsprcid in
                     (select distinct (q.sng001inst)
                        from sng003 q -- tabla de avales
                       where q.sng003cta in
                             (select f.ctnro
                                from fsr008 f
                               where f.pepais = ln_pais
                                 and f.petdoc = ln_tdoc
                                 and f.pendoc = lc_pendoc))
                 and w.wfitemstsact = 1
                 and w.wftaskcod in (55, 11)) r;
    EXCEPTION
      WHEN OTHERS THEN
        ln_contador := 0;
    END;
  end SP_CR_reporte_enflujo;


-------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
 Procedure SP_CR_reporte_insertdatacaso2(ln_pais  in number,
                                     ln_tdoc  in number,
                                     lv_ndoc  in varchar,
                                     ln_docod in number,
                                     ln_corr  in number,
                                     ln_medid in number,
                                     ln_comtr in number,
                                     lc_user  in varchar,
                                     ld_fech  in date,
                                     ln_est   in number,
                                     ln_tipmed   in number) is
    lc_pendoc char(12);
    lc_hora char(8);
 ln_exitente  number;
  valor_secuenc number;
  BEGIN
      begin
    select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
  exception
          when others then
          lc_hora:='00:00:00';
    end ;
  select count(*) into ln_exitente from jaqz750 where jaqz750.jaqz750fcn=(select fst017.pgfape from fst017 where fst017.pgcod=1);

    if ln_exitente=0 then
     -- select nvl(max (jaqz750.jaqz750cod),0) into valor_secuenc from jaqz750 where jaqz750.jaqz750fcn=(select fst017.pgfape-1 from fst017 where fst017.pgcod=1);

         SELECT (SQ_CR_JAQZ750.nextval-1)*-1 into valor_secuenc FROM dual;
          EXECUTE IMMEDIATE  concat(concat('ALTER SEQUENCE SQ_CR_JAQZ750 INCREMENT BY ', valor_secuenc),' MINVALUE 1');
    else
      if  ln_exitente=1 then
             EXECUTE IMMEDIATE 'ALTER SEQUENCE SQ_CR_JAQZ750 INCREMENT BY 1 MINVALUE 1';
      end if ;
    end if;
    lc_pendoc := RPAD(lv_ndoc, 12, ' ');
    BEGIN
      INSERT INTO JAQZ750
        (JAQZ750PAI,
         JAQZ750TDO,
         JAQZ750NDO,
         JAQZ750DOCOD,
         JAQZ750CORR,
         JAQZ750MEDID,
         JAQZ750CONTR,
         JAQZ750USUR,
         JAQZ750FCN,
         JAQZ750EST,
         JAQZ750TMED,
         jAQZ750IND,
         jAQZ750HOR
         )
      VALUES
        (ln_pais,
         ln_tdoc,
         lc_pendoc,
         ln_docod,
         ln_corr,
         ln_medid,
         ln_comtr,
         lc_user,
         ld_fech,
         ln_est,
         ln_tipmed,
         'S',
        lc_hora
         );
        COMMIT;
    End;
  end SP_CR_reporte_insertdatacaso2;
  ----------------------------------------------------------------------------------


  --------------------------------------------

end pq_cr_JAQZ750;
/

