CREATE OR REPLACE PACKAGE pq_venta is
  -- *****************************************************************
  -- Nombre                       : pq_venta
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
    -- Fecha de Modificación      :18/08/2023
    -- Autor de la Modificación   :Kvalenciac
    -- Descripción de Modificación:Se está modificando para que graba el grupo en los registro
     
   -- Fecha de Modificación        : 31/08/2023
  -- Autor de Modificación        : Karen Valencia
  -- Descripción de Modificación  :  NO jale los pagos no contabilizados del día
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


   procedure SP_CR_PAGOS(P_INI in number,
                        P_FIN in number,
                        P_FECHAINI IN DATE,
                        P_FECHAFIN IN DATE );

   procedure SP_CR_PAGOS_D(P_INI in number,
                           P_FIN in number);
                        
end pq_venta;
/

CREATE OR REPLACE PACKAGE BODY pq_venta is

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure SP_CR_PAGOS(P_INI in number,
                        P_FIN in number,
                        P_FECHAINI IN DATE,
                        P_FECHAFIN IN DATE ) is
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
    -- Fecha de Modificación      :18/08/2023
    -- Autor de la Modificación   :Kvalenciac
    -- Descripción de Modificación:Se está modificando para que graba el grupo en los registro
     
   -- Fecha de Modificación        : 31/08/2023
  -- Autor de Modificación        : Karen Valencia
  -- Descripción de Modificación  :  NO jale los pagos no contabilizados del día
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Crédito.   
    
  
  
  cursor  ve is
  
select
/*+ ALL_ROWS */
DISTINCT 
 h.pgcod,
 h.hcta,
 h.hoper,
-- h.hmodul,
-- H.HRUBRO RUBRO,
 H.HMDA MONEDA,
 h.hcmod MODULO,
 H.HSUCOR SUCUR,
 H.HTRAN TRANS,
 H.HNREL,
 H.HFCON FECHA_PAGO, 
 /*CASE
   WHEN N.TP1NRO1 = 6 THEN
    H.HCIMP6
   WHEN N.TP1NRO1 = 3 THEN
    H.HCIMP3
   WHEN N.TP1NRO1 = 1 THEN
    H.HCIMP1
 END PAGO,*/
 (select j.trnom
    from fst034 j
   where j.pgcod = H.pgcod
     and j.trmod = H.hcmod
     and j.trnro = H.htran) tran,
   
      --H.HCORD ,
      --H.HCIMP1,
      --H.HCIMP2,
      --H.HCIMP3,
      --H.HCIMP4,
      --H.HCIMP5,
      --H.HCIMP6,
    --  P.HCCORR
   v.jaqz509nrog   --kvalenciac 18/08/2023

  from fsh015 p, fsh016 h, JAQZ509 v, JAQZ511 n
 where p.pgcod = h.pgcod
   and p.hcmod = h.hcmod
   and p.hsucor = h.hsucor
   and p.htran = h.htran
   and p.hnrel = h.hnrel
   and p.hfcon = h.hfcon
   and v.cuenta = h.hcta
   and v.operacion = h.hoper
   and h.pgcod = 1
   and n.tp1cod = h.pgcod
   and n.tp1corr1 = h.hcmod
   and n.tp1corr2 = h.htran
  -- and n.tp1corr3 = h.hcord
   and p.hccorr = 0
   AND v.nro >= P_INI
   and v.nro <= P_FIN
--and v.nro >= 56413
AND P.HFCON>=P_FECHAINI AND P.HFCON<=P_FECHAFIN---TO_DATE('16-12-2016','DD-MM-YYYY')
--and v.lote = 'J1'
;
  
  CURSOR VE1(P_CTA IN NUMBER , P_OPE IN NUMBER, P_COD IN NUMBER, P_MOD IN NUMBER, 
  P_SUC IN NUMBER , P_TRA IN NUMBER , P_REL IN NUMBER , P_FEC IN DATE ) IS 
  
    select P_CTA, P_OPE,h.hmodul, h.pgcod , h.hcmod, h.hsucor, h.htran, h.hnrel, h.hfcon, h.hrubro, h.hcord,
   CASE
   WHEN k.TP1NRO1 = 6 THEN H.HCIMP6
   WHEN k.TP1NRO1 = 3 THEN H.HCIMP3
   WHEN k.TP1NRO1 = 1 THEN H.HCIMP1
    END PAGO 
       
   from fsh016 h, JAQZ511 k 
   where h.pgcod = P_COD  
   and h.hcmod = P_MOD
   and h.hsucor = P_SUC
   and h.htran = P_TRA
   and h.hnrel = P_REL
   and h.hfcon = P_FEC
   AND h.pgcod = k.tp1cod
   and h.hcord = k.tp1corr3
   and h.hcmod = k.tp1corr1 
   and h.htran = k.tp1corr2;
  
  
       
  begin
  
  
  for q in ve  loop
      FOR w in ve1(q.HCTA,q.HOPER,q.PGCOD,q.MODULO, Q.SUCUR, Q.TRANS ,Q.HNREL, Q.FECHA_PAGO )  LOOP
        insert into JAQZ510
          (PGCOD,           HCTA,           HOPER,           HMODUL,
           RUBRO,           MONEDA,           MOD,           TRANS,           HNREL,
           FECHA_PAGO,           PAGO,           TRAN,             ORDINAL ,           /*   IMP1,
              IMP2,              IMP3,              IMP4,              IMP5,              IMP6,*/
              /*COOR               ,*/ sucu  ,jaqz510nrog          )
        values
          (q.PGCOD,           w.P_CTA,           w.P_OPE,           w.hmodul,
           w.hrubro,           q.MONEDA,           q.MODULO,           q.TRANS,
           q.HNREL,           q.FECHA_PAGO,           W.PAGO,
           q.TRAN,             w.hcord ,             /* Q.HCIMP1,              Q.HCIMP2,
              Q.HCIMP3,              Q.HCIMP4,              Q.HCIMP5,              Q.HCIMP6,*/
             /* Q.HCCORR ,*/ Q.SUCUR , q.jaqz509nrog);
          commit;  
         end loop;
  END LOOP;  
  
    
      

  
  
  
  exception when others then 
    --rollback;  
    DBMS_OUTPUT.put_line('ERROR PAGOS ');
  end ;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure SP_CR_PAGOS_D(P_INI in number,
                          P_FIN in number) is
    -- *****************************************************************
    -- Sistema                    : SORFY
    -- Módulo                     : Créditos
    -- Versión                    : 
    -- Fecha de Creación          : 2022.07.21
    -- Autor de Creación          : apachecoh
    -- Uso                        : formacion de grupos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_PERANO ( año del proceso )
    --                              P_PERMES ( mes del proceso )                            
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :18/08/2023
    -- Autor de la Modificación   :Kvalenciac
    -- Descripción de Modificación:Se está modificando para que graba el grupo en los registro
     
   -- Fecha de Modificación        : 31/08/2023
  -- Autor de Modificación        : Karen Valencia
  -- Descripción de Modificación  :  NO jale los pagos no contabilizados del día
    -- *****************************************************************
    -- Variable para el nombre del Titular Principal del Crédito.   
   
  cursor ve is  
      SELECT
      /*+ ALL_ROWS */
      DISTINCT 
       h.pgcod,
       h.ctnro,
       h.itoper,
      -- h.hmodul,
      -- H.HRUBRO RUBRO,
       h.moneda MONEDA,
       h.itmod MODULO,
       h.itsuc SUCUR,
       h.ittran TRANS,
       h.itnrel,
       h.itfval FECHA_PAGO, 
       /*CASE
         WHEN N.TP1NRO1 = 6 THEN
          H.HCIMP6
         WHEN N.TP1NRO1 = 3 THEN
          H.HCIMP3
         WHEN N.TP1NRO1 = 1 THEN
          H.HCIMP1
       END PAGO,*/
       (select j.trnom
          from fst034 j
         where j.pgcod = H.pgcod
           and j.trmod = H.itmod
           and j.trnro = H.ittran) tran ,
             v.jaqz509nrog  --kvalenciac 18/08/2023
            --H.HCORD ,
            --H.HCIMP1,
            --H.HCIMP2,
            --H.HCIMP3,
            --H.HCIMP4,
            --H.HCIMP5,
            --H.HCIMP6,
          --  P.HCCORR       
      from fsd015 p, fsd016 h, JAQZ509 v, JAQZ511 n
     where p.pgcod = h.pgcod
       and p.itmod = h.itmod
       and p.itsuc = h.itsuc
       and p.ittran = h.ittran
       and p.itnrel = h.itnrel
       and p.itfcon = h.itfval
       and v.cuenta = h.ctnro
       and v.operacion = h.itoper
       and h.pgcod = 1
       and n.tp1cod = h.pgcod
       and n.tp1corr1 = h.itmod
       and n.tp1corr2 = h.ittran
      -- and n.tp1corr3 = h.hcord
       and p.itcorr = 0
       and p.itcont = 'S' -- adicionado kvalenciac  31/08/2023
       and v.nro >= P_INI
       and v.nro <= P_FIN
    --and v.nro >= 56413
    and p.itfcon = (SELECT pgfape FROM FST017 WHERE pgcod = 1)---TO_DATE('16-12-2016','DD-MM-YYYY')
    --and v.lote = 'J1'
    ;
  
  CURSOR VE1(P_CTA IN NUMBER , P_OPE IN NUMBER, P_COD IN NUMBER, P_MOD IN NUMBER, 
             P_SUC IN NUMBER , P_TRA IN NUMBER , P_REL IN NUMBER , P_FEC IN DATE ) IS 
  
   select P_CTA, P_OPE, h.modulo, h.pgcod , h.itmod, h.itsuc, h.ittran, h.itnrel, h.itfval, h.rubro, h.itord,
     CASE
       WHEN k.TP1NRO1 = 6 THEN H.ITIMP6
       WHEN k.TP1NRO1 = 3 THEN H.ITIMP3
       WHEN k.TP1NRO1 = 1 THEN H.ITIMP1
     END PAGO 
       
   from fsd016 h, JAQZ511 k 
   where h.pgcod = P_COD  
   and h.itmod = P_MOD
   and h.itsuc = P_SUC
   and h.ittran = P_TRA
   and h.itnrel = P_REL
   and h.itfval = P_FEC
   and h.pgcod = k.tp1cod
   and h.itord = k.tp1corr3
   and h.itmod = k.tp1corr1 
   and h.ittran = k.tp1corr2;
           
  begin    
    FOR q IN ve LOOP
        FOR w in ve1(Q.ctnro, Q.itoper, Q.PGCOD, Q.MODULO, Q.SUCUR, Q.TRANS ,Q.itnrel, Q.FECHA_PAGO) LOOP
          insert into JAQZ510
            (PGCOD,           HCTA,           HOPER,           HMODUL,
             RUBRO,           MONEDA,           MOD,           TRANS,           HNREL,
             FECHA_PAGO,           PAGO,           TRAN,             ORDINAL ,           /*   IMP1,
                IMP2,              IMP3,              IMP4,              IMP5,              IMP6,*/
                /*COOR               ,*/ sucu  ,jaqz510nrog          )
          values
            (q.PGCOD,           w.P_CTA,           w.P_OPE,           w.modulo,
             w.rubro,           q.MONEDA,           q.MODULO,           q.TRANS,
             q.itnrel,           q.FECHA_PAGO,           W.PAGO,
             q.TRAN,             w.itord ,             /* Q.HCIMP1,              Q.HCIMP2,
                Q.HCIMP3,              Q.HCIMP4,              Q.HCIMP5,              Q.HCIMP6,*/
               /* Q.HCCORR ,*/ Q.SUCUR, q.jaqz509nrog );
            commit;  
         END LOOP;
    END LOOP;  
  exception when others then 
      --rollback;  
      DBMS_OUTPUT.put_line('ERROR PAGOS');
  end ;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

end pq_venta;

/*
   create public synonym pq_cr_adjudicar for pq_cr_adjudicar;
   grant execute on pq_cr_adjudicar to rol_sorfy,rol_sorfy_consulta;

*/
/

