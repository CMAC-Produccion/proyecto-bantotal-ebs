create or replace package PQ_REPS_OPERACIONES_CANALES is
  -- ------------------------------------------------------------------------------------------------
  -- Nombre                : PQ_REPORTES_OPERACIONES_CANALES
  -- Sistema               : BANTOTAL
  -- Módulo                : Reportes de Operaciones y Canales
  -- Versión               : 1.0
  -- Fecha de Creación     : 04/08/2014
  -- Autor de Creación     : Jeankharlo Edgard Pinto Espejo
  -- Uso                   : Almaces de Consultas para reportes de la Gerencia de Operaciones y Canales de Atención
  -- Estado                : Activo
  -- Acceso                : Público
  --
  -- Fecha de Modificación : 12/08/2014
  -- Autor de Creación     : Jeankharlo Edgard Pinto Espejo
  -- Descripción Modific.  : Se agrego nuevo reporte - Transacciones Autorizadas Unibanca
  --
  -- Fecha de Modificación : 05/05/2021
  -- Autor de Creación     : Jeankharlo Edgard Pinto Espejo
  -- Descripción Modific.  : Se modificó en nombre de la tabla NDCATM por ATMTBL por upgrade del fts4 al fts6
  -- ------------------------------------------------------------------------------------------------------------------------------------------------------

  procedure sp_oc_mensajes_por_atm(p_n_codmsj in number,
                                   p_c_codter in varchar2,
                                   p_c_codtrx in varchar2,
                                   p_d_fecini in date,
                                   p_d_fecfin in date,
                                   p_n_tipmsj in number,
                                   p_c_codusu in varchar2,
                                   p_c_coderr out varchar2,
                                   p_c_msgerr out varchar2);
                                   
  procedure sp_oc_transacciones_autor_uba(p_c_tiprol in varchar2,
                                          p_c_tiprep in varchar2,
                                          p_c_codtrx in varchar2,
                                          p_d_fecini in date,
                                          p_d_fecfin in date,
                                          p_c_codusu in varchar2,
                                          p_c_coderr out varchar2,
                                          p_c_msgerr out varchar2);                                   

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

end PQ_REPS_OPERACIONES_CANALES;
/

create or replace package body PQ_REPS_OPERACIONES_CANALES is

  -- ------------------------------------------------------------------------------------------------
  -- Nombre                : PQ_REPORTES_OPERACIONES_CANALES
  -- Sistema               : BANTOTAL
  -- Módulo                : Reportes de Operaciones y Canales
  -- Versión               : 1.0
  -- Fecha de Creación     : 04/08/2014
  -- Autor de Creación     : Jeankharlo Edgard Pinto Espejo
  -- Uso                   : Almaces de Consultas para reportes de la Gerencia de Operaciones y Canales de Atención
  -- Estado                : Activo
  -- Acceso                : Público
  --
  -- Fecha de Modificación : 12/08/2014
  -- Autor de Creación     : Jeankharlo Edgard Pinto Espejo
  -- Descripción Modific.  : Se agrego nuevo reporte - Transacciones Autorizadas Unibanca
  --
  -- Fecha de Modificación : 
  -- Autor de Creación     : 
  -- Descripción Modific.  : 
  -- ------------------------------------------------------------------------------------------------------------------------------------------------------

  procedure sp_oc_mensajes_por_atm(P_N_CODMSJ in number,
                                   P_C_CODTER in varchar2,
                                   P_C_CODTRX in varchar2,
                                   P_D_FECINI in date,
                                   P_D_FECFIN in date,
                                   P_N_TIPMSJ in number,
                                   P_C_CODUSU in varchar2,
                                   p_c_coderr out varchar2,
                                   p_c_msgerr out varchar2) is
    --//                               
    cursor c1(P_N_CODMSJ in number,
              P_C_CODTER in varchar2,
              P_C_CODTRX in varchar2,
              P_D_FECINI in date,
              P_D_FECFIN in date) is
      select /*+ choose parallel(a,2) */
             a.jaql540comsj n_codmsj,
             a.jaql540coter c_codter,
             a.jaql540cotrx c_codtrx,
             a.jaql540nutar c_numtar,
             a.jaql540hoini c_horini,
             a.jaql540feini d_fecini,
             a.jaql540fefin d_fecfin,
             a.jaql540hoini c_horpro,                         
             (select /*+ choose parallel(b,2) choose parallel(c,2)*/
                     lPad(Trim(to_char(c.ctnro)), 9, '0') || '-' ||
                     lPad(Trim(to_char(c.modulo)), 3, '0') || '-' ||
                     lpad(Trim(to_char(c.moneda)), 3, '0') || '-' ||
                     lpad(Trim(to_char(c.itsubo)), 2, '0') || '-' ||
                     lpad(Trim(to_char(c.itoper)), 3, '0')
                from fsd015 b, fsd016 c
               where b.pgcod = c.pgcod
                 and b.itsuc = c.itsuc
                 and b.itmod = c.itmod
                 and b.ittran = c.ittran
                 and b.itnrel = c.itnrel
                 and b.itfcon = c.itfval
                 and c.itord = 10
                 and b.itfcon = a.jaql540feini
                 and b.itsuc = 903
                 and b.itmod = a.jaql540modul
                 and b.ittran = a.jaql540trans
                 and b.itnrel = a.jaql540relac) c_numcta,
             (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.itimp1
                from fsd015 b, fsd016 c
               where b.pgcod = c.pgcod
                 and b.itsuc = c.itsuc
                 and b.itmod = c.itmod
                 and b.ittran = c.ittran
                 and b.itnrel = c.itnrel
                 and b.itfcon = c.itfval
                 and c.itord = 10
                 and b.itfcon = a.jaql540feini
                 and b.itsuc = 903
                 and b.itmod = a.jaql540modul
                 and b.ittran = a.jaql540trans
                 and b.itnrel = a.jaql540relac) n_mtoope,
             (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.ittcbi
                from fsd015 b, fsd016 c
               where b.pgcod = c.pgcod
                 and b.itsuc = c.itsuc
                 and b.itmod = c.itmod
                 and b.ittran = c.ittran
                 and b.itnrel = c.itnrel
                 and b.itfcon = c.itfval
                 and c.itord = 10
                 and b.itfcon = a.jaql540feini
                 and b.itsuc = 903
                 and b.itmod = a.jaql540modul
                 and b.ittran = a.jaql540trans
                 and b.itnrel = a.jaql540relac) n_mtoitf,    
             (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.moneda
                from fsd015 b, fsd016 c
               where b.pgcod = c.pgcod
                 and b.itsuc = c.itsuc
                 and b.itmod = c.itmod
                 and b.ittran = c.ittran
                 and b.itnrel = c.itnrel
                 and b.itfcon = c.itfval
                 and c.itord = 10
                 and b.itfcon = a.jaql540feini
                 and b.itsuc = 903
                 and b.itmod = a.jaql540modul
                 and b.ittran = a.jaql540trans
                 and b.itnrel = a.jaql540relac) n_moneda,    
             a.jaql540cores c_codres
        from jaql540 a
       where a.jaql540feini >= P_D_FECINI
         and a.jaql540feini <= P_D_FECFIN
         and a.jaql540comsj in (select tp1nro1
                                  from fst198
                                 where tp1cod1 = 10801
                                   and tp1corr1 = 13
                                   and tp1corr2 = 999
                                   and tp1corr3 = P_N_CODMSJ
                                   and tp1nro1 > 0
                                union
                                select tp1nro2
                                  from fst198
                                 where tp1cod1 = 10801
                                   and tp1corr1 = 13
                                   and tp1corr2 = 999
                                   and tp1corr3 = P_N_CODMSJ
                                   and tp1nro2 > 0)
         and a.jaql540coter like lpad(P_C_CODTER, '5', '0')
         and to_number(a.jaql540coter) > 0
         and substr(a.jaql540cotrx, 1, 2) like
             lpad(trim(P_C_CODTRX), 2, '0')
         and a.jaql540cores >= '00'
       order by a.jaql540coter, a.jaql540comsj, a.jaql540cotra asc;
              
    --//
    cursor c2(P_N_CODMSJ in number,
              P_C_CODTER in varchar2,
              P_C_CODTRX in varchar2,
              P_D_FECINI in date,
              P_D_FECFIN in date) is
      select /*+ choose parallel(a,2) */
             a.jaql540comsj n_codmsj,
             a.jaql540coter c_codter,
             a.jaql540cotrx c_codtrx,
             a.jaql540nutar c_numtar,
             a.jaql540hoini c_horini,
             a.jaql540feini d_fecini,
             a.jaql540fefin d_fecfin,
             a.jaql540hoini c_horpro,
             (select /*+ choose parallel(b,2) choose parallel(c,2)*/
                     lPad(Trim(to_char(c.ctnro)), 9, '0') || '-' ||
                     lPad(Trim(to_char(c.modulo)), 3, '0') || '-' ||
                     lpad(Trim(to_char(c.moneda)), 3, '0') || '-' ||
                     lpad(Trim(to_char(c.itsubo)), 2, '0') || '-' ||
                     lpad(Trim(to_char(c.itoper)), 3, '0')
                from fsd015 b, fsd016 c
               where b.pgcod = c.pgcod
                 and b.itsuc = c.itsuc
                 and b.itmod = c.itmod
                 and b.ittran = c.ittran
                 and b.itnrel = c.itnrel
                 and b.itfcon = c.itfval
                 and c.itord = 10
                 and b.itfcon = a.jaql540feini
                 and b.itsuc = 903
                 and b.itmod = a.jaql540modul
                 and b.ittran = a.jaql540trans
                 and b.itnrel = a.jaql540relac) c_numcta,
             (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.itimp1 
                from fsd015 b, fsd016 c
               where b.pgcod = c.pgcod
                 and b.itsuc = c.itsuc
                 and b.itmod = c.itmod
                 and b.ittran = c.ittran
                 and b.itnrel = c.itnrel
                 and b.itfcon = c.itfval
                 and c.itord = 10
                 and b.itfcon = a.jaql540feini
                 and b.itsuc = 903
                 and b.itmod = a.jaql540modul
                 and b.ittran = a.jaql540trans
                 and b.itnrel = a.jaql540relac) n_mtoope,
             (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.ittcbi
                from fsd015 b, fsd016 c
               where b.pgcod = c.pgcod
                 and b.itsuc = c.itsuc
                 and b.itmod = c.itmod
                 and b.ittran = c.ittran
                 and b.itnrel = c.itnrel
                 and b.itfcon = c.itfval
                 and c.itord = 10
                 and b.itfcon = a.jaql540feini
                 and b.itsuc = 903
                 and b.itmod = a.jaql540modul
                 and b.ittran = a.jaql540trans
                 and b.itnrel = a.jaql540relac) n_mtoitf,    
             (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.moneda
                from fsd015 b, fsd016 c
               where b.pgcod = c.pgcod
                 and b.itsuc = c.itsuc
                 and b.itmod = c.itmod
                 and b.ittran = c.ittran
                 and b.itnrel = c.itnrel
                 and b.itfcon = c.itfval
                 and c.itord = 10
                 and b.itfcon = a.jaql540feini
                 and b.itsuc = 903
                 and b.itmod = a.jaql540modul
                 and b.ittran = a.jaql540trans
                 and b.itnrel = a.jaql540relac) n_moneda,
             a.jaql540cores c_codres
        from jaql540 a
       where a.jaql540feini >= P_D_FECINI
         and a.jaql540feini <= P_D_FECFIN
         and a.jaql540comsj in (select tp1nro1
                                  from fst198
                                 where tp1cod1 = 10801
                                   and tp1corr1 = 13
                                   and tp1corr2 = 999
                                   and tp1corr3 = P_N_CODMSJ
                                   and tp1nro1 > 0
                                union
                                select tp1nro2
                                  from fst198
                                 where tp1cod1 = 10801
                                   and tp1corr1 = 13
                                   and tp1corr2 = 999
                                   and tp1corr3 = P_N_CODMSJ
                                   and tp1nro2 > 0)
         and a.jaql540coter like lpad(P_C_CODTER, '5', '0')
         and to_number(a.jaql540coter) > 0
         and substr(a.jaql540cotrx, 1, 2) like
             lpad(trim(P_C_CODTRX), 2, '0')
         and a.jaql540cores = '00'
       order by a.jaql540coter, a.jaql540comsj, a.jaql540cotra asc;
           
    --//
    cursor c3(P_N_CODMSJ in number,
              P_C_CODTER in varchar2,
              P_C_CODTRX in varchar2,
              P_D_FECINI in date,
              P_D_FECFIN in date) is
      select /*+ choose parallel(a,2) */
             a.jaql540comsj n_codmsj,
             a.jaql540coter c_codter,
             a.jaql540cotrx c_codtrx,
             a.jaql540nutar c_numtar,
             a.jaql540hoini c_horini,
             a.jaql540feini d_fecini,
             a.jaql540fefin d_fecfin,
             a.jaql540hoini c_horpro,
             (select /*+ choose parallel(b,2) choose parallel(c,2)*/
                     lPad(Trim(to_char(c.ctnro)), 9, '0') || '-' ||
                     lPad(Trim(to_char(c.modulo)), 3, '0') || '-' ||
                     lpad(Trim(to_char(c.moneda)), 3, '0') || '-' ||
                     lpad(Trim(to_char(c.itsubo)), 2, '0') || '-' ||
                     lpad(Trim(to_char(c.itoper)), 3, '0')
                from fsd015 b, fsd016 c
               where b.pgcod = c.pgcod
                 and b.itsuc = c.itsuc
                 and b.itmod = c.itmod
                 and b.ittran = c.ittran
                 and b.itnrel = c.itnrel
                 and b.itfcon = c.itfval
                 and c.itord = 10
                 and b.itfcon = a.jaql540feini
                 and b.itsuc = 903
                 and b.itmod = a.jaql540modul
                 and b.ittran = a.jaql540trans
                 and b.itnrel = a.jaql540relac) c_numcta,
             (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.itimp1
                from fsd015 b, fsd016 c
               where b.pgcod = c.pgcod
                 and b.itsuc = c.itsuc
                 and b.itmod = c.itmod
                 and b.ittran = c.ittran
                 and b.itnrel = c.itnrel
                 and b.itfcon = c.itfval
                 and c.itord = 10
                 and b.itfcon = a.jaql540feini
                 and b.itsuc = 903
                 and b.itmod = a.jaql540modul
                 and b.ittran = a.jaql540trans
                 and b.itnrel = a.jaql540relac) n_mtoope,
             (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.ittcbi
                from fsd015 b, fsd016 c
               where b.pgcod = c.pgcod
                 and b.itsuc = c.itsuc
                 and b.itmod = c.itmod
                 and b.ittran = c.ittran
                 and b.itnrel = c.itnrel
                 and b.itfcon = c.itfval
                 and c.itord = 10
                 and b.itfcon = a.jaql540feini
                 and b.itsuc = 903
                 and b.itmod = a.jaql540modul
                 and b.ittran = a.jaql540trans
                 and b.itnrel = a.jaql540relac) n_mtoitf,    
             (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.moneda
                from fsd015 b, fsd016 c
               where b.pgcod = c.pgcod
                 and b.itsuc = c.itsuc
                 and b.itmod = c.itmod
                 and b.ittran = c.ittran
                 and b.itnrel = c.itnrel
                 and b.itfcon = c.itfval
                 and c.itord = 10
                 and b.itfcon = a.jaql540feini
                 and b.itsuc = 903
                 and b.itmod = a.jaql540modul
                 and b.ittran = a.jaql540trans
                 and b.itnrel = a.jaql540relac) n_moneda,
             a.jaql540cores c_codres
        from jaql540 a
       where a.jaql540feini >= P_D_FECINI
         and a.jaql540feini <= P_D_FECFIN
         and a.jaql540comsj in (select tp1nro1
                                  from fst198
                                 where tp1cod1 = 10801
                                   and tp1corr1 = 13
                                   and tp1corr2 = 999
                                   and tp1corr3 = P_N_CODMSJ
                                   and tp1nro1 > 0
                                union
                                select tp1nro2
                                  from fst198
                                 where tp1cod1 = 10801
                                   and tp1corr1 = 13
                                   and tp1corr2 = 999
                                   and tp1corr3 = P_N_CODMSJ
                                   and tp1nro2 > 0)
         and a.jaql540coter like lpad(P_C_CODTER, '5', '0')
         and to_number(a.jaql540coter) > 0
         and substr(a.jaql540cotrx, 1, 2) like
             lpad(trim(P_C_CODTRX), 2, '0')
         and a.jaql540cores <> '00'
       order by a.jaql540coter, a.jaql540comsj, a.jaql540cotra asc;
    
    --//
    cursor c4(P_N_CODMSJ in number,
              P_C_CODTER in varchar2,
              P_C_CODTRX in varchar2,
              P_D_FECINI in date,
              P_D_FECFIN in date) is
       select /*+ choose parallel(a,2) */
           a.jaql540comsj n_codmsj,
           a.jaql540coter c_codter,
           a.jaql540cotrx c_codtrx,
           a.jaql540nutar c_numtar,
           a.jaql540hoini c_horini,
           a.jaql540feini d_fecini,
           a.jaql540fefin d_fecfin,
           a.jaql540hoini c_horpro,
           (select /*+ choose parallel(b,2) choose parallel(c,2)*/
                   lPad(Trim(to_char(c.hcta)), 9, '0') || '-' ||
                   lPad(Trim(to_char(c.hmodul)), 3, '0') || '-' ||
                   lpad(Trim(to_char(c.hmda)), 3, '0') || '-' ||
                   lpad(Trim(to_char(c.hsubop)), 2, '0') || '-' ||
                   lpad(Trim(to_char(c.htoper)), 3, '0')
              from fsh015 b, fsh016 c
             where b.pgcod = c.pgcod
               and b.hsucor = c.hsucor
               and b.hcmod = c.hcmod
               and b.htran = c.htran
               and b.hnrel = c.hnrel
               and b.hfcon = c.hfval
               and c.hcord = 10
               and b.hfcon = a.jaql540feini
               and b.hsucor = 903
               and b.hcmod = a.jaql540modul
               and b.htran = a.jaql540trans
               and b.hnrel = a.jaql540relac) c_numcta,
           (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.hcimp1 
              from fsh015 b, fsh016 c
             where b.pgcod= c.pgcod
               and b.hsucor = c.hsucor
               and b.hcmod= c.hcmod
               and b.htran = c.htran
               and b.hnrel = c.hnrel
               and b.hfcon = c.hfval
               and c.hcord = 10
               and b.hfcon = a.jaql540feini
               and b.hsucor = 903
               and b.hcmod= a.jaql540modul
               and b.htran = a.jaql540trans
               and b.hnrel = a.jaql540relac) n_mtoope,
           (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.hctcbi --ITF
              from fsh015 b, fsh016 c
             where b.pgcod= c.pgcod
               and b.hsucor = c.hsucor
               and b.hcmod= c.hcmod
               and b.htran = c.htran
               and b.hnrel = c.hnrel
               and b.hfcon = c.hfval
               and c.hcord = 10
               and b.hfcon = a.jaql540feini
               and b.hsucor = 903
               and b.hcmod = a.jaql540modul
               and b.htran = a.jaql540trans
               and b.hnrel = a.jaql540relac) n_mtoitf,    
          (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.hmda
                from fsh015 b, fsh016 c
             where b.pgcod= c.pgcod
               and b.hsucor = c.hsucor
               and b.hcmod= c.hcmod
               and b.htran = c.htran
               and b.hnrel = c.hnrel
               and b.hfcon = c.hfval
               and c.hcord = 10
               and b.hfcon = a.jaql540feini
               and b.hsucor = 903
               and b.hcmod = a.jaql540modul
               and b.htran = a.jaql540trans
               and b.hnrel = a.jaql540relac) n_moneda,
           a.jaql540cores c_codres
      from jaql540 a
     where a.jaql540feini >= P_D_FECINI
       and a.jaql540fefin <= P_D_FECFIN
       and a.jaql540comsj in (select tp1nro1
                                      from fst198
                                     where tp1cod1 = 10801
                                       and tp1corr1 = 13
                                       and tp1corr2 = 999
                                       and tp1corr3 = P_N_CODMSJ
                                       and tp1nro1 > 0
                                    union
                                    select tp1nro2
                                      from fst198
                                     where tp1cod1 = 10801
                                       and tp1corr1 = 13
                                       and tp1corr2 = 999
                                       and tp1corr3 = P_N_CODMSJ
                                       and tp1nro2 > 0)       
       and a.jaql540coter like lpad(P_C_CODTER, '5', '0')||'%'
       and to_number(a.jaql540coter) > 0       
       and substr(a.jaql540cotrx, 1, 2) like lpad(trim(P_C_CODTRX), 2, '0')
       and a.jaql540cores >= '00'
  order by a.jaql540coter, a.jaql540comsj, a.jaql540cotra asc;
         
    --//
    cursor c5(P_N_CODMSJ in number,
              P_C_CODTER in varchar2,
              P_C_CODTRX in varchar2,
              P_D_FECINI in date,
              P_D_FECFIN in date) is
       select /*+ choose parallel(a,2) */
              a.jaql540comsj n_codmsj,
           a.jaql540coter c_codter,
           a.jaql540cotrx c_codtrx,
           a.jaql540nutar c_numtar,
           a.jaql540hoini c_horini,
           a.jaql540feini d_fecini,
           a.jaql540fefin d_fecfin,
           a.jaql540hoini c_horpro,
           (select /*+ choose parallel(b,2) choose parallel(c,2)*/ 
                   lPad(Trim(to_char(c.hcta)), 9, '0') || '-' ||
                   lPad(Trim(to_char(c.hmodul)), 3, '0') || '-' ||
                   lpad(Trim(to_char(c.hmda)), 3, '0') || '-' ||
                   lpad(Trim(to_char(c.hsubop)), 2, '0') || '-' ||
                   lpad(Trim(to_char(c.htoper)), 3, '0')
              from fsh015 b, fsh016 c
             where b.pgcod = c.pgcod
               and b.hsucor = c.hsucor
               and b.hcmod = c.hcmod
               and b.htran = c.htran
               and b.hnrel = c.hnrel
               and b.hfcon = c.hfval
               and c.hcord = 10
               and b.hfcon = a.jaql540feini
               and b.hsucor = 903
               and b.hcmod = a.jaql540modul
               and b.htran = a.jaql540trans
               and b.hnrel = a.jaql540relac) c_numcta,
           (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.hcimp1
              from fsh015 b, fsh016 c
             where b.pgcod= c.pgcod
               and b.hsucor = c.hsucor
               and b.hcmod= c.hcmod
               and b.htran = c.htran
               and b.hnrel = c.hnrel
               and b.hfcon = c.hfval
               and c.hcord = 10
               and b.hfcon = a.jaql540feini
               and b.hsucor = 903
               and b.hcmod= a.jaql540modul
               and b.htran = a.jaql540trans
               and b.hnrel = a.jaql540relac) n_mtoope,
           (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.hctcbi --ITF
              from fsh015 b, fsh016 c
             where b.pgcod= c.pgcod
               and b.hsucor = c.hsucor
               and b.hcmod= c.hcmod
               and b.htran = c.htran
               and b.hnrel = c.hnrel
               and b.hfcon = c.hfval
               and c.hcord = 10
               and b.hfcon = a.jaql540feini
               and b.hsucor = 903
               and b.hcmod = a.jaql540modul
               and b.htran = a.jaql540trans
               and b.hnrel = a.jaql540relac) n_mtoitf,    
          (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.hmda
                from fsh015 b, fsh016 c
             where b.pgcod= c.pgcod
               and b.hsucor = c.hsucor
               and b.hcmod= c.hcmod
               and b.htran = c.htran
               and b.hnrel = c.hnrel
               and b.hfcon = c.hfval
               and c.hcord = 10
               and b.hfcon = a.jaql540feini
               and b.hsucor = 903
               and b.hcmod = a.jaql540modul
               and b.htran = a.jaql540trans
               and b.hnrel = a.jaql540relac) n_moneda,
           a.jaql540cores c_codres
      from jaql540 a
     where a.jaql540feini >= P_D_FECINI
       and a.jaql540fefin <= P_D_FECFIN
       and a.jaql540comsj in (select tp1nro1
                                      from fst198
                                     where tp1cod1 = 10801
                                       and tp1corr1 = 13
                                       and tp1corr2 = 999
                                       and tp1corr3 = P_N_CODMSJ
                                       and tp1nro1 > 0
                                    union
                                    select tp1nro2
                                      from fst198
                                     where tp1cod1 = 10801
                                       and tp1corr1 = 13
                                       and tp1corr2 = 999
                                       and tp1corr3 = P_N_CODMSJ
                                       and tp1nro2 > 0)
       and a.jaql540coter like lpad(P_C_CODTER, '5', '0')||'%'
       and to_number(a.jaql540coter) > 0
             and substr(a.jaql540cotrx, 1, 2) like
                 lpad(trim(P_C_CODTRX), 2, '0')
             and a.jaql540cores = '00'
           order by a.jaql540coter, a.jaql540comsj, a.jaql540cotra asc;        
                  
    --//
    cursor c6(P_N_CODMSJ in number,
              P_C_CODTER in varchar2,
              P_C_CODTRX in varchar2,
              P_D_FECINI in date,
              P_D_FECFIN in date) is
       select /*+ choose parallel(a,2) */
           a.jaql540comsj n_codmsj,
           a.jaql540coter c_codter,
           a.jaql540cotrx c_codtrx,
           a.jaql540nutar c_numtar,
           a.jaql540hoini c_horini,
           a.jaql540feini d_fecini,
           a.jaql540fefin d_fecfin,
           a.jaql540hoini c_horpro,
           (select /*+ choose parallel(b,2) choose parallel(c,2)*/ 
                   lPad(Trim(to_char(c.hcta)), 9, '0') || '-' ||
                   lPad(Trim(to_char(c.hmodul)), 3, '0') || '-' ||
                   lpad(Trim(to_char(c.hmda)), 3, '0') || '-' ||
                   lpad(Trim(to_char(c.hsubop)), 2, '0') || '-' ||
                   lpad(Trim(to_char(c.htoper)), 3, '0')
              from fsh015 b, fsh016 c
             where b.pgcod = c.pgcod
               and b.hsucor = c.hsucor               
               and b.hcmod = c.hcmod
               and b.htran = c.htran
               and b.hnrel = c.hnrel
               and b.hfcon = c.hfval
               and c.hcord = 10
               and b.hfcon = a.jaql540feini
               and b.hsucor = 903
               and b.hcmod = a.jaql540modul
               and b.htran = a.jaql540trans
               and b.hnrel = a.jaql540relac) c_numcta,
           (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.hcimp1 
              from fsh015 b, fsh016 c
             where b.pgcod= c.pgcod
               and b.hsucor = c.hsucor
               and b.hcmod= c.hcmod
               and b.htran = c.htran
               and b.hnrel = c.hnrel
               and b.hfcon = c.hfval
               and c.hcord = 10
               and b.hfcon = a.jaql540feini
               and b.hsucor = 903
               and b.hcmod= a.jaql540modul
               and b.htran = a.jaql540trans
               and b.hnrel = a.jaql540relac) n_mtoope,
                (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.hctcbi --ITF
              from fsh015 b, fsh016 c
             where b.pgcod= c.pgcod
               and b.hsucor = c.hsucor
               and b.hcmod= c.hcmod
               and b.htran = c.htran
               and b.hnrel = c.hnrel
               and b.hfcon = c.hfval
               and c.hcord = 10
               and b.hfcon = a.jaql540feini
               and b.hsucor = 903
               and b.hcmod = a.jaql540modul
               and b.htran = a.jaql540trans
               and b.hnrel = a.jaql540relac) n_mtoitf,    
          (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.hmda
                from fsh015 b, fsh016 c
             where b.pgcod= c.pgcod
               and b.hsucor = c.hsucor
               and b.hcmod= c.hcmod
               and b.htran = c.htran
               and b.hnrel = c.hnrel
               and b.hfcon = c.hfval
               and c.hcord = 10
               and b.hfcon = a.jaql540feini
               and b.hsucor = 903
               and b.hcmod = a.jaql540modul
               and b.htran = a.jaql540trans
               and b.hnrel = a.jaql540relac) n_moneda,
           a.jaql540cores c_codres
      from jaql540 a
     where a.jaql540feini >= P_D_FECINI
       and a.jaql540fefin <= P_D_FECFIN
       and a.jaql540comsj in (select tp1nro1
                                      from fst198
                                     where tp1cod1 = 10801
                                       and tp1corr1 = 13
                                       and tp1corr2 = 999
                                       and tp1corr3 = P_N_CODMSJ
                                       and tp1nro1 > 0
                                    union
                                    select tp1nro2
                                      from fst198
                                     where tp1cod1 = 10801
                                       and tp1corr1 = 13
                                       and tp1corr2 = 999
                                       and tp1corr3 = P_N_CODMSJ
                                       and tp1nro2 > 0)
       and a.jaql540coter like lpad(P_C_CODTER, '5', '0')||'%'
       and to_number(a.jaql540coter) > 0
             and substr(a.jaql540cotrx, 1, 2) like
                 lpad(trim(P_C_CODTRX), 2, '0')
             and a.jaql540cores <> '00'
           order by a.jaql540coter, a.jaql540comsj, a.jaql540cotra asc;                
 
     cursor c7(P_C_CODTER in varchar2,
                P_D_FECINI in date,
                P_D_FECFIN in date) is
     select /*+ choose parallel(a,2) parallel(d,2) */
     a.jaql540comsj n_codmsj,
     a.jaql540coter c_codter,
     a.jaql540cotrx c_codtrx,
     a.jaql540nutar c_numtar,
     a.jaql540hoini c_horini,
     a.jaql540feini d_fecini,
     a.jaql540fefin d_fecfin,
     a.jaql540hoini c_horpro,
     (select /*+ choose parallel(b,2) choose parallel(c,2)*/
                   lPad(Trim(to_char(c.hcta)), 9, '0') || '-' ||
                   lPad(Trim(to_char(c.hmodul)), 3, '0') || '-' ||
                   lpad(Trim(to_char(c.hmda)), 3, '0') || '-' ||
                   lpad(Trim(to_char(c.hsubop)), 2, '0') || '-' ||
                   lpad(Trim(to_char(c.htoper)), 3, '0')
              from fsh015 b, fsh016 c
             where b.pgcod = c.pgcod
               and b.hsucor = c.hsucor
               and b.hcmod = c.hcmod
               and b.htran = c.htran
               and b.hnrel = c.hnrel
               and b.hfcon = c.hfcon
               and c.hcord = 10
               and b.hfcon = a.jaql540feini
               and b.hsucor = 903
               and b.hcmod = a.jaql540modul
               and b.htran = a.jaql540trans
               and b.hnrel = a.jaql540relac) c_numcta,
           (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.hcimp1 
              from fsh015 b, fsh016 c
             where b.pgcod= c.pgcod
               and b.hsucor = c.hsucor
               and b.hcmod= c.hcmod
               and b.htran = c.htran
               and b.hnrel = c.hnrel
               and b.hfcon = c.hfcon
               and c.hcord = 10
               and b.hfcon = a.jaql540feini
               and b.hsucor = 903
               and b.hcmod= a.jaql540modul
               and b.htran = a.jaql540trans
               and b.hnrel = a.jaql540relac) n_mtoope,
           (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.hctcbi --ITF
              from fsh015 b, fsh016 c
             where b.pgcod= c.pgcod
               and b.hsucor = c.hsucor
               and b.hcmod= c.hcmod
               and b.htran = c.htran
               and b.hnrel = c.hnrel
               and b.hfcon = c.hfcon
               and c.hcord = 10
               and b.hfcon = a.jaql540feini
               and b.hsucor = 903
               and b.hcmod = a.jaql540modul
               and b.htran = a.jaql540trans
               and b.hnrel = a.jaql540relac) n_mtoitf,    
          (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.hmda
                from fsh015 b, fsh016 c
             where b.pgcod= c.pgcod
               and b.hsucor = c.hsucor
               and b.hcmod= c.hcmod
               and b.htran = c.htran
               and b.hnrel = c.hnrel
               and b.hfcon = c.hfcon
               and c.hcord = 10
               and b.hfcon = a.jaql540feini
               and b.hsucor = 903
               and b.hcmod = a.jaql540modul
               and b.htran = a.jaql540trans
               and b.hnrel = a.jaql540relac) n_moneda,
           a.jaql540cores c_codres
      from jaql540 a, jaql539 d
     where a.jaql540cotra = d.jaql539cotra
       and a.jaql540feini >= P_D_FECINI
       and a.jaql540fefin <= P_D_FECFIN
       and substr(a.jaql540nutar, 1,6) <> '426153'
       and substr(a.jaql540nutar, 1,6) <> '851004'
       and (d.jaql539nucam = 32 and d.jaql539valtr = '06890600')
       and a.jaql540coter like lpad(P_C_CODTER, '5', '0')||'%'
       and to_number(a.jaql540coter) > 0       
       and a.jaql540cores >= '00'
      and a.jaql540comsj = 500
   order by a.jaql540coter, a.jaql540comsj, a.jaql540cotra asc;
   
   cursor c8(P_C_CODTER in varchar2,
                P_D_FECINI in date,
                P_D_FECFIN in date) is
     select /*+ choose parallel(a,2) parallel(d,2) */
     a.jaql540comsj n_codmsj,
     a.jaql540coter c_codter,
     a.jaql540cotrx c_codtrx,
     a.jaql540nutar c_numtar,
     a.jaql540hoini c_horini,
     a.jaql540feini d_fecini,
     a.jaql540fefin d_fecfin,
     a.jaql540hoini c_horpro,
     (select /*+ choose parallel(b,2) choose parallel(c,2)*/
                   lPad(Trim(to_char(c.hcta)), 9, '0') || '-' ||
                   lPad(Trim(to_char(c.hmodul)), 3, '0') || '-' ||
                   lpad(Trim(to_char(c.hmda)), 3, '0') || '-' ||
                   lpad(Trim(to_char(c.hsubop)), 2, '0') || '-' ||
                   lpad(Trim(to_char(c.htoper)), 3, '0')
              from fsh015 b, fsh016 c
             where b.pgcod = c.pgcod
               and b.hsucor = c.hsucor
               and b.hcmod = c.hcmod
               and b.htran = c.htran
               and b.hnrel = c.hnrel
               and b.hfcon = c.hfcon
               and c.hcord = 10
               and b.hfcon = a.jaql540feini
               and b.hsucor = 903
               and b.hcmod = a.jaql540modul
               and b.htran = a.jaql540trans
               and b.hnrel = a.jaql540relac) c_numcta,
           (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.hcimp1 
              from fsh015 b, fsh016 c
             where b.pgcod= c.pgcod
               and b.hsucor = c.hsucor
               and b.hcmod= c.hcmod
               and b.htran = c.htran
               and b.hnrel = c.hnrel
               and b.hfcon = c.hfcon
               and c.hcord = 10
               and b.hfcon = a.jaql540feini
               and b.hsucor = 903
               and b.hcmod= a.jaql540modul
               and b.htran = a.jaql540trans
               and b.hnrel = a.jaql540relac) n_mtoope,
           (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.hctcbi --ITF
              from fsh015 b, fsh016 c
             where b.pgcod= c.pgcod
               and b.hsucor = c.hsucor
               and b.hcmod= c.hcmod
               and b.htran = c.htran
               and b.hnrel = c.hnrel
               and b.hfcon = c.hfcon
               and c.hcord = 10
               and b.hfcon = a.jaql540feini
               and b.hsucor = 903
               and b.hcmod = a.jaql540modul
               and b.htran = a.jaql540trans
               and b.hnrel = a.jaql540relac) n_mtoitf,    
          (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.hmda
                from fsh015 b, fsh016 c
             where b.pgcod= c.pgcod
               and b.hsucor = c.hsucor
               and b.hcmod= c.hcmod
               and b.htran = c.htran
               and b.hnrel = c.hnrel
               and b.hfcon = c.hfcon
               and c.hcord = 10
               and b.hfcon = a.jaql540feini
               and b.hsucor = 903
               and b.hcmod = a.jaql540modul
               and b.htran = a.jaql540trans
               and b.hnrel = a.jaql540relac) n_moneda,
           a.jaql540cores c_codres
      from jaql540 a, jaql539 d
     where a.jaql540cotra = d.jaql539cotra
       and a.jaql540feini >= P_D_FECINI
       and a.jaql540fefin <= P_D_FECFIN
       and substr(a.jaql540nutar, 1,6) <> '426153'
       and substr(a.jaql540nutar, 1,6) <> '851004'
       and (d.jaql539nucam = 32 and d.jaql539valtr = '06890600')
       and a.jaql540coter like lpad(P_C_CODTER, '5', '0')||'%'
       and to_number(a.jaql540coter) > 0       
       and a.jaql540cores = '00'
      and a.jaql540comsj = 500
   order by a.jaql540coter, a.jaql540comsj, a.jaql540cotra asc;
   
   cursor c9(P_C_CODTER in varchar2,
                P_D_FECINI in date,
                P_D_FECFIN in date) is
     select /*+ choose parallel(a,2) parallel(d,2) */
     a.jaql540comsj n_codmsj,
     a.jaql540coter c_codter,
     a.jaql540cotrx c_codtrx,
     a.jaql540nutar c_numtar,
     a.jaql540hoini c_horini,
     a.jaql540feini d_fecini,
     a.jaql540fefin d_fecfin,
     a.jaql540hoini c_horpro,
     (select /*+ choose parallel(b,2) choose parallel(c,2)*/
                   lPad(Trim(to_char(c.hcta)), 9, '0') || '-' ||
                   lPad(Trim(to_char(c.hmodul)), 3, '0') || '-' ||
                   lpad(Trim(to_char(c.hmda)), 3, '0') || '-' ||
                   lpad(Trim(to_char(c.hsubop)), 2, '0') || '-' ||
                   lpad(Trim(to_char(c.htoper)), 3, '0')
              from fsh015 b, fsh016 c
             where b.pgcod = c.pgcod
               and b.hsucor = c.hsucor
               and b.hcmod = c.hcmod
               and b.htran = c.htran
               and b.hnrel = c.hnrel
               and b.hfcon = c.hfcon
               and c.hcord = 10
               and b.hfcon = a.jaql540feini
               and b.hsucor = 903
               and b.hcmod = a.jaql540modul
               and b.htran = a.jaql540trans
               and b.hnrel = a.jaql540relac) c_numcta,
           (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.hcimp1 
              from fsh015 b, fsh016 c
             where b.pgcod= c.pgcod
               and b.hsucor = c.hsucor
               and b.hcmod= c.hcmod
               and b.htran = c.htran
               and b.hnrel = c.hnrel
               and b.hfcon = c.hfcon
               and c.hcord = 10
               and b.hfcon = a.jaql540feini
               and b.hsucor = 903
               and b.hcmod= a.jaql540modul
               and b.htran = a.jaql540trans
               and b.hnrel = a.jaql540relac) n_mtoope,
           (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.hctcbi --ITF
              from fsh015 b, fsh016 c
             where b.pgcod= c.pgcod
               and b.hsucor = c.hsucor
               and b.hcmod= c.hcmod
               and b.htran = c.htran
               and b.hnrel = c.hnrel
               and b.hfcon = c.hfcon
               and c.hcord = 10
               and b.hfcon = a.jaql540feini
               and b.hsucor = 903
               and b.hcmod = a.jaql540modul
               and b.htran = a.jaql540trans
               and b.hnrel = a.jaql540relac) n_mtoitf,    
          (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.hmda
                from fsh015 b, fsh016 c
             where b.pgcod= c.pgcod
               and b.hsucor = c.hsucor
               and b.hcmod= c.hcmod
               and b.htran = c.htran
               and b.hnrel = c.hnrel
               and b.hfcon = c.hfcon
               and c.hcord = 10
               and b.hfcon = a.jaql540feini
               and b.hsucor = 903
               and b.hcmod = a.jaql540modul
               and b.htran = a.jaql540trans
               and b.hnrel = a.jaql540relac) n_moneda,
           a.jaql540cores c_codres
      from jaql540 a, jaql539 d
     where a.jaql540cotra = d.jaql539cotra
       and a.jaql540feini >= P_D_FECINI
       and a.jaql540fefin <= P_D_FECFIN
       and substr(a.jaql540nutar, 1,6) <> '426153'
       and substr(a.jaql540nutar, 1,6) <> '851004'
       and (d.jaql539nucam = 32 and d.jaql539valtr = '06890600')
       and a.jaql540coter like lpad(P_C_CODTER, '5', '0')||'%'
       and to_number(a.jaql540coter) > 0       
       and a.jaql540cores <> '00'
      and a.jaql540comsj = 500
   order by a.jaql540coter, a.jaql540comsj, a.jaql540cotra asc;
   
    cursor c10(P_C_CODTER in varchar2,
                P_D_FECINI in date,
                P_D_FECFIN in date) is
     select /*+ choose parallel(a,2) parallel(d,2) */
     a.jaql540comsj n_codmsj,
     a.jaql540coter c_codter,
     a.jaql540cotrx c_codtrx,
     a.jaql540nutar c_numtar,
     a.jaql540hoini c_horini,
     a.jaql540feini d_fecini,
     a.jaql540fefin d_fecfin,
     a.jaql540hoini c_horpro,
     (select /*+ choose parallel(b,2) choose parallel(c,2)*/
                     lPad(Trim(to_char(c.ctnro)), 9, '0') || '-' ||
                     lPad(Trim(to_char(c.modulo)), 3, '0') || '-' ||
                     lpad(Trim(to_char(c.moneda)), 3, '0') || '-' ||
                     lpad(Trim(to_char(c.itsubo)), 2, '0') || '-' ||
                     lpad(Trim(to_char(c.itoper)), 3, '0')
                from fsd015 b, fsd016 c
               where b.pgcod = c.pgcod
                 and b.itsuc = c.itsuc
                 and b.itmod = c.itmod
                 and b.ittran = c.ittran
                 and b.itnrel = c.itnrel
                 --and b.itfcon = c.itfval
                 and c.itord = 10
                 and b.itfcon = a.jaql540feini
                 and b.itsuc = 903
                 and b.itmod = a.jaql540modul
                 and b.ittran = a.jaql540trans
                 and b.itnrel = a.jaql540relac) c_numcta,
             (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.itimp1
                from fsd015 b, fsd016 c
               where b.pgcod = c.pgcod
                 and b.itsuc = c.itsuc
                 and b.itmod = c.itmod
                 and b.ittran = c.ittran
                 and b.itnrel = c.itnrel
                 --and b.itfcon = c.itfval
                 and c.itord = 10
                 and b.itfcon = a.jaql540feini
                 and b.itsuc = 903
                 and b.itmod = a.jaql540modul
                 and b.ittran = a.jaql540trans
                 and b.itnrel = a.jaql540relac) n_mtoope,
             (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.ittcbi
                from fsd015 b, fsd016 c
               where b.pgcod = c.pgcod
                 and b.itsuc = c.itsuc
                 and b.itmod = c.itmod
                 and b.ittran = c.ittran
                 and b.itnrel = c.itnrel
                 --and b.itfcon = c.itfval
                 and c.itord = 10
                 and b.itfcon = a.jaql540feini
                 and b.itsuc = 903
                 and b.itmod = a.jaql540modul
                 and b.ittran = a.jaql540trans
                 and b.itnrel = a.jaql540relac) n_mtoitf,    
             (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.moneda
                from fsd015 b, fsd016 c
               where b.pgcod = c.pgcod
                 and b.itsuc = c.itsuc
                 and b.itmod = c.itmod
                 and b.ittran = c.ittran
                 and b.itnrel = c.itnrel
                 --and b.itfcon = c.itfval
                 and c.itord = 10
                 and b.itfcon = a.jaql540feini
                 and b.itsuc = 903
                 and b.itmod = a.jaql540modul
                 and b.ittran = a.jaql540trans
                 and b.itnrel = a.jaql540relac) n_moneda,
           a.jaql540cores c_codres
      from jaql540 a, jaql539 d
     where a.jaql540cotra = d.jaql539cotra
       and a.jaql540feini >= P_D_FECINI
       and a.jaql540fefin <= P_D_FECFIN
       and substr(a.jaql540nutar, 1,6) <> '426153'
       and substr(a.jaql540nutar, 1,6) <> '851004'
       and (d.jaql539nucam = 32 and d.jaql539valtr = '06890600')
       and a.jaql540coter like lpad(P_C_CODTER, '5', '0')||'%'
       and to_number(a.jaql540coter) > 0       
       and a.jaql540cores >= '00'
      and a.jaql540comsj = 500
   order by a.jaql540coter, a.jaql540comsj, a.jaql540cotra asc;
   
   cursor c11(P_C_CODTER in varchar2,
                P_D_FECINI in date,
                P_D_FECFIN in date) is
     select /*+ choose parallel(a,2) parallel(d,2) */
     a.jaql540comsj n_codmsj,
     a.jaql540coter c_codter,
     a.jaql540cotrx c_codtrx,
     a.jaql540nutar c_numtar,
     a.jaql540hoini c_horini,
     a.jaql540feini d_fecini,
     a.jaql540fefin d_fecfin,
     a.jaql540hoini c_horpro,
     (select /*+ choose parallel(b,2) choose parallel(c,2)*/
                     lPad(Trim(to_char(c.ctnro)), 9, '0') || '-' ||
                     lPad(Trim(to_char(c.modulo)), 3, '0') || '-' ||
                     lpad(Trim(to_char(c.moneda)), 3, '0') || '-' ||
                     lpad(Trim(to_char(c.itsubo)), 2, '0') || '-' ||
                     lpad(Trim(to_char(c.itoper)), 3, '0')
                from fsd015 b, fsd016 c
               where b.pgcod = c.pgcod
                 and b.itsuc = c.itsuc
                 and b.itmod = c.itmod
                 and b.ittran = c.ittran
                 and b.itnrel = c.itnrel
                 --and b.itfcon = c.itfval
                 and c.itord = 10
                 and b.itfcon = a.jaql540feini
                 and b.itsuc = 903
                 and b.itmod = a.jaql540modul
                 and b.ittran = a.jaql540trans
                 and b.itnrel = a.jaql540relac) c_numcta,
             (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.itimp1
                from fsd015 b, fsd016 c
               where b.pgcod = c.pgcod
                 and b.itsuc = c.itsuc
                 and b.itmod = c.itmod
                 and b.ittran = c.ittran
                 and b.itnrel = c.itnrel
                 --and b.itfcon = c.itfval
                 and c.itord = 10
                 and b.itfcon = a.jaql540feini
                 and b.itsuc = 903
                 and b.itmod = a.jaql540modul
                 and b.ittran = a.jaql540trans
                 and b.itnrel = a.jaql540relac) n_mtoope,
             (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.ittcbi
                from fsd015 b, fsd016 c
               where b.pgcod = c.pgcod
                 and b.itsuc = c.itsuc
                 and b.itmod = c.itmod
                 and b.ittran = c.ittran
                 and b.itnrel = c.itnrel
                 --and b.itfcon = c.itfval
                 and c.itord = 10
                 and b.itfcon = a.jaql540feini
                 and b.itsuc = 903
                 and b.itmod = a.jaql540modul
                 and b.ittran = a.jaql540trans
                 and b.itnrel = a.jaql540relac) n_mtoitf,    
             (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.moneda
                from fsd015 b, fsd016 c
               where b.pgcod = c.pgcod
                 and b.itsuc = c.itsuc
                 and b.itmod = c.itmod
                 and b.ittran = c.ittran
                 and b.itnrel = c.itnrel
                 --and b.itfcon = c.itfval
                 and c.itord = 10
                 and b.itfcon = a.jaql540feini
                 and b.itsuc = 903
                 and b.itmod = a.jaql540modul
                 and b.ittran = a.jaql540trans
                 and b.itnrel = a.jaql540relac) n_moneda,
           a.jaql540cores c_codres
      from jaql540 a, jaql539 d
     where a.jaql540cotra = d.jaql539cotra
       and a.jaql540feini >= P_D_FECINI
       and a.jaql540fefin <= P_D_FECFIN
       and substr(a.jaql540nutar, 1,6) <> '426153'
       and substr(a.jaql540nutar, 1,6) <> '851004'
       and (d.jaql539nucam = 32 and d.jaql539valtr = '06890600')
       and a.jaql540coter like lpad(P_C_CODTER, '5', '0')||'%'
       and to_number(a.jaql540coter) > 0       
       and a.jaql540cores = '00'
      and a.jaql540comsj = 500
   order by a.jaql540coter, a.jaql540comsj, a.jaql540cotra asc;
   
   cursor c12(P_C_CODTER in varchar2,
                P_D_FECINI in date,
                P_D_FECFIN in date) is
     select /*+ choose parallel(a,2) parallel(d,2) */
     a.jaql540comsj n_codmsj,
     a.jaql540coter c_codter,
     a.jaql540cotrx c_codtrx,
     a.jaql540nutar c_numtar,
     a.jaql540hoini c_horini,
     a.jaql540feini d_fecini,
     a.jaql540fefin d_fecfin,
     a.jaql540hoini c_horpro,
     (select /*+ choose parallel(b,2) choose parallel(c,2)*/
                     lPad(Trim(to_char(c.ctnro)), 9, '0') || '-' ||
                     lPad(Trim(to_char(c.modulo)), 3, '0') || '-' ||
                     lpad(Trim(to_char(c.moneda)), 3, '0') || '-' ||
                     lpad(Trim(to_char(c.itsubo)), 2, '0') || '-' ||
                     lpad(Trim(to_char(c.itoper)), 3, '0')
                from fsd015 b, fsd016 c
               where b.pgcod = c.pgcod
                 and b.itsuc = c.itsuc
                 and b.itmod = c.itmod
                 and b.ittran = c.ittran
                 and b.itnrel = c.itnrel
                 --and b.itfcon = c.itfval
                 and c.itord = 10
                 and b.itfcon = a.jaql540feini
                 and b.itsuc = 903
                 and b.itmod = a.jaql540modul
                 and b.ittran = a.jaql540trans
                 and b.itnrel = a.jaql540relac) c_numcta,
             (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.itimp1
                from fsd015 b, fsd016 c
               where b.pgcod = c.pgcod
                 and b.itsuc = c.itsuc
                 and b.itmod = c.itmod
                 and b.ittran = c.ittran
                 and b.itnrel = c.itnrel
                 --and b.itfcon = c.itfval
                 and c.itord = 10
                 and b.itfcon = a.jaql540feini
                 and b.itsuc = 903
                 and b.itmod = a.jaql540modul
                 and b.ittran = a.jaql540trans
                 and b.itnrel = a.jaql540relac) n_mtoope,
             (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.ittcbi
                from fsd015 b, fsd016 c
               where b.pgcod = c.pgcod
                 and b.itsuc = c.itsuc
                 and b.itmod = c.itmod
                 and b.ittran = c.ittran
                 and b.itnrel = c.itnrel
                 --and b.itfcon = c.itfval
                 and c.itord = 10
                 and b.itfcon = a.jaql540feini
                 and b.itsuc = 903
                 and b.itmod = a.jaql540modul
                 and b.ittran = a.jaql540trans
                 and b.itnrel = a.jaql540relac) n_mtoitf,    
             (select /*+ choose parallel(b,2) choose parallel(c,2)*/ c.moneda
                from fsd015 b, fsd016 c
               where b.pgcod = c.pgcod
                 and b.itsuc = c.itsuc
                 and b.itmod = c.itmod
                 and b.ittran = c.ittran
                 and b.itnrel = c.itnrel
                 --and b.itfcon = c.itfval
                 and c.itord = 10
                 and b.itfcon = a.jaql540feini
                 and b.itsuc = 903
                 and b.itmod = a.jaql540modul
                 and b.ittran = a.jaql540trans
                 and b.itnrel = a.jaql540relac) n_moneda,
           a.jaql540cores c_codres
      from jaql540 a, jaql539 d
     where a.jaql540cotra = d.jaql539cotra
       and a.jaql540feini >= P_D_FECINI
       and a.jaql540fefin <= P_D_FECFIN
       and substr(a.jaql540nutar, 1,6) <> '426153'
       and substr(a.jaql540nutar, 1,6) <> '851004'
       and (d.jaql539nucam = 32 and d.jaql539valtr = '06890600')
       and a.jaql540coter like lpad(P_C_CODTER, '5', '0')||'%'
       and to_number(a.jaql540coter) > 0       
       and a.jaql540cores <> '00'
      and a.jaql540comsj = 500
   order by a.jaql540coter, a.jaql540comsj, a.jaql540cotra asc;
 
    ln_contad number := 1;
    ld_fecsys date;
    lc_codtrx varchar2(3) := null;
    lc_codter varchar2(3) := null;
  begin  
    -- Inicializar Valores
    p_c_coderr := '00000';
    p_c_msgerr := '';
    
    if P_C_CODTRX = '000' then 
       lc_codtrx  := '%';
    else
       lc_codtrx  := P_C_CODTRX;
    end if;
    
    if P_C_CODTER = '0' then 
       lc_codter := '%';
    else
       lc_codter := P_C_CODTER;
    end if;
    
    -- Carga de Variables
    begin
      select a1.pgfape into ld_fecsys from fst017 a1 where a1.pgcod = 1;
    exception
      when others then
        ld_fecsys := trunc(sysdate);
    end;
  
  /*insert into log_error_bandeja (n_nro,c_codbdj,c_deserr,d_fecerr)
      values (1,p_c_codter,p_c_codtrx,P_D_FECINI);
      commit; 
      insert into log_error_bandeja (n_nro,c_codbdj,c_deserr,d_fecerr)
      values (1,to_char(p_n_tipmsj),to_char(p_n_codmsj),P_D_FECFIN);
      commit; */
  
    -- Proceso
    execute immediate 'truncate table JAQL544';
  
    -- Recorrido del cursor para insertar en la tabla para leer    
    If P_N_TIPMSJ = 0  and P_D_FECINI = ld_fecsys then 
      for i in c1(P_N_CODMSJ, lc_codter, lc_codtrx, P_D_FECINI, P_D_FECFIN) loop
      
        insert into jaql544
          (jaql544seria,
           jaql544comsj,
           jaql544coter,
           jaql544cotrx,
           jaql544nutar,
           jaql544nucta,
           jaql544feini,
           jaql544fefin,
           jaql544hopro,
           jaql544mtoop,
           jaql544cores,
           jaql544opera, 
           jaql544de001, 
           jaql544en001
           )
        values
          (ln_contad,
           i.n_codmsj,
           i.c_codter,
           i.c_codtrx,
           i.c_numtar,
           i.c_numcta,
           i.d_fecini,
           i.d_fecfin,
           i.c_horpro,
           i.n_mtoope,
           i.c_codres,
           P_C_CODUSU,
           i.n_mtoitf,
           i.n_moneda);
      
        ln_contad := ln_contad + 1;        
      end loop;
      commit;
      if P_N_CODMSJ = 200 and lc_codtrx = '01' then
         for i in c10(lc_codter,P_D_FECINI,P_D_FECFIN) loop
      
            insert into jaql544
            (jaql544seria,
             jaql544comsj,
             jaql544coter,
             jaql544cotrx,
             jaql544nutar,
             jaql544nucta,
             jaql544feini,
             jaql544fefin,
             jaql544hopro,
             jaql544mtoop,
             jaql544cores,
             jaql544opera, 
             jaql544de001, 
             jaql544en001
            )
            values
            (ln_contad,
             i.n_codmsj,
             i.c_codter,
             i.c_codtrx,
             i.c_numtar,
             i.c_numcta,
             i.d_fecini,
             i.d_fecfin,
             i.c_horpro,
             i.n_mtoope,
             i.c_codres,
             P_C_CODUSU,
             i.n_mtoitf,
             i.n_moneda);
     
          ln_contad := ln_contad + 1;        
         end loop;
         commit;
      end if;   
    end if;
    
    If P_N_TIPMSJ = 1 and P_D_FECINI = ld_fecsys then 
      for i in c2(P_N_CODMSJ, lc_codter, lc_codtrx, P_D_FECINI, P_D_FECFIN) loop
      
        insert into jaql544
          (jaql544seria,
           jaql544comsj,
           jaql544coter,
           jaql544cotrx,
           jaql544nutar,
           jaql544nucta,
           jaql544feini,
           jaql544fefin,
           jaql544hopro,
           jaql544mtoop,
           jaql544cores,
           jaql544opera, 
           jaql544de001, 
           jaql544en001
           )
        values
          (ln_contad,
           i.n_codmsj,
           i.c_codter,
           i.c_codtrx,
           i.c_numtar,
           i.c_numcta,
           i.d_fecini,
           i.d_fecfin,
           i.c_horpro,
           i.n_mtoope,
           i.c_codres,
           P_C_CODUSU,
           i.n_mtoitf,
           i.n_moneda);
      
        ln_contad := ln_contad + 1;        
      end loop;
      commit;
      if P_N_CODMSJ = 200 and lc_codtrx = '01' then
         for i in c11(lc_codter,P_D_FECINI,P_D_FECFIN) loop
      
            insert into jaql544
            (jaql544seria,
             jaql544comsj,
             jaql544coter,
             jaql544cotrx,
             jaql544nutar,
             jaql544nucta,
             jaql544feini,
             jaql544fefin,
             jaql544hopro,
             jaql544mtoop,
             jaql544cores,
             jaql544opera, 
             jaql544de001, 
             jaql544en001
            )
            values
            (ln_contad,
             i.n_codmsj,
             i.c_codter,
             i.c_codtrx,
             i.c_numtar,
             i.c_numcta,
             i.d_fecini,
             i.d_fecfin,
             i.c_horpro,
             i.n_mtoope,
             i.c_codres,
             P_C_CODUSU,
             i.n_mtoitf,
             i.n_moneda);
     
          ln_contad := ln_contad + 1;        
         end loop;
         commit;
      end if;
    end if;
    
    If P_N_TIPMSJ = 2  and P_D_FECINI = ld_fecsys then 
      for i in c3(P_N_CODMSJ, lc_codter, lc_codtrx, P_D_FECINI, P_D_FECFIN) loop
      insert into jaql544
          (jaql544seria,
           jaql544comsj,
           jaql544coter,
           jaql544cotrx,
           jaql544nutar,
           jaql544nucta,
           jaql544feini,
           jaql544fefin,
           jaql544hopro,
           jaql544mtoop,
           jaql544cores,
           jaql544opera, 
           jaql544de001, 
           jaql544en001
           )
        values
          (ln_contad,
           i.n_codmsj,
           i.c_codter,
           i.c_codtrx,
           i.c_numtar,
           i.c_numcta,
           i.d_fecini,
           i.d_fecfin,
           i.c_horpro,
           i.n_mtoope,
           i.c_codres,
           P_C_CODUSU,
           i.n_mtoitf,
           i.n_moneda);
      
        ln_contad := ln_contad + 1;        
      end loop;
      commit;
      if P_N_CODMSJ = 200 and lc_codtrx = '01' then
         for i in c12(lc_codter,P_D_FECINI,P_D_FECFIN) loop
      
            insert into jaql544
            (jaql544seria,
             jaql544comsj,
             jaql544coter,
             jaql544cotrx,
             jaql544nutar,
             jaql544nucta,
             jaql544feini,
             jaql544fefin,
             jaql544hopro,
             jaql544mtoop,
             jaql544cores,
             jaql544opera, 
             jaql544de001, 
             jaql544en001
            )
            values
            (ln_contad,
             i.n_codmsj,
             i.c_codter,
             i.c_codtrx,
             i.c_numtar,
             i.c_numcta,
             i.d_fecini,
             i.d_fecfin,
             i.c_horpro,
             i.n_mtoope,
             i.c_codres,
             P_C_CODUSU,
             i.n_mtoitf,
             i.n_moneda);
     
          ln_contad := ln_contad + 1;        
         end loop;
         commit;
      end if;
    end if;
    
    -- Historicos
    If P_N_TIPMSJ = 0 and P_D_FECINI <> ld_fecsys then 
      for i in c4(P_N_CODMSJ, lc_codter, lc_codtrx, P_D_FECINI, P_D_FECFIN) loop
      
        insert into jaql544
          (jaql544seria,
           jaql544comsj,
           jaql544coter,
           jaql544cotrx,
           jaql544nutar,
           jaql544nucta,
           jaql544feini,
           jaql544fefin,
           jaql544hopro,
           jaql544mtoop,
           jaql544cores,
           jaql544opera, 
           jaql544de001, 
           jaql544en001
           )
        values
          (ln_contad,
           i.n_codmsj,
           i.c_codter,
           i.c_codtrx,
           i.c_numtar,
           i.c_numcta,
           i.d_fecini,
           i.d_fecfin,
           i.c_horpro,
           i.n_mtoope,
           i.c_codres,
           P_C_CODUSU,
           i.n_mtoitf,
           i.n_moneda);
      
        ln_contad := ln_contad + 1;        
      end loop;
      commit;
      if P_N_CODMSJ = 200 and lc_codtrx = '01' then
         for i in c7(lc_codter,P_D_FECINI,P_D_FECFIN) loop
      
            insert into jaql544
            (jaql544seria,
             jaql544comsj,
             jaql544coter,
             jaql544cotrx,
             jaql544nutar,
             jaql544nucta,
             jaql544feini,
             jaql544fefin,
             jaql544hopro,
             jaql544mtoop,
             jaql544cores,
             jaql544opera, 
             jaql544de001, 
             jaql544en001
            )
            values
            (ln_contad,
             i.n_codmsj,
             i.c_codter,
             i.c_codtrx,
             i.c_numtar,
             i.c_numcta,
             i.d_fecini,
             i.d_fecfin,
             i.c_horpro,
             i.n_mtoope,
             i.c_codres,
             P_C_CODUSU,
             i.n_mtoitf,
             i.n_moneda);
     
          ln_contad := ln_contad + 1;        
         end loop;
         commit;
      end if;
    end if;
    
    If P_N_TIPMSJ = 1 and P_D_FECINI <> ld_fecsys then 
      for i in c5(P_N_CODMSJ, lc_codter, lc_codtrx, P_D_FECINI, P_D_FECFIN) loop
      
        insert into jaql544
          (jaql544seria,
           jaql544comsj,
           jaql544coter,
           jaql544cotrx,
           jaql544nutar,
           jaql544nucta,
           jaql544feini,
           jaql544fefin,
           jaql544hopro,
           jaql544mtoop,
           jaql544cores,
           jaql544opera, 
           jaql544de001, 
           jaql544en001
           )
        values
          (ln_contad,
           i.n_codmsj,
           i.c_codter,
           i.c_codtrx,
           i.c_numtar,
           i.c_numcta,
           i.d_fecini,
           i.d_fecfin,
           i.c_horpro,
           i.n_mtoope,
           i.c_codres,
           P_C_CODUSU,
           i.n_mtoitf,
           i.n_moneda);
      
        ln_contad := ln_contad + 1;        
      end loop;
      commit;
      if P_N_CODMSJ = 200 and lc_codtrx = '01' then
         for i in c8(lc_codter,P_D_FECINI,P_D_FECFIN) loop
      
            insert into jaql544
            (jaql544seria,
             jaql544comsj,
             jaql544coter,
             jaql544cotrx,
             jaql544nutar,
             jaql544nucta,
             jaql544feini,
             jaql544fefin,
             jaql544hopro,
             jaql544mtoop,
             jaql544cores,
             jaql544opera, 
             jaql544de001, 
             jaql544en001
            )
            values
            (ln_contad,
             i.n_codmsj,
             i.c_codter,
             i.c_codtrx,
             i.c_numtar,
             i.c_numcta,
             i.d_fecini,
             i.d_fecfin,
             i.c_horpro,
             i.n_mtoope,
             i.c_codres,
             P_C_CODUSU,
             i.n_mtoitf,
             i.n_moneda);
     
          ln_contad := ln_contad + 1;        
         end loop;
         commit;
      end if;
    end if;
    
    If P_N_TIPMSJ = 2 and P_D_FECINI <> ld_fecsys then 
      for i in c6(P_N_CODMSJ, lc_codter, lc_codtrx, P_D_FECINI, P_D_FECFIN) loop
      
        insert into jaql544
          (jaql544seria,
           jaql544comsj,
           jaql544coter,
           jaql544cotrx,
           jaql544nutar,
           jaql544nucta,
           jaql544feini,
           jaql544fefin,
           jaql544hopro,
           jaql544mtoop,
           jaql544cores,
           jaql544opera, 
           jaql544de001, 
           jaql544en001
           )
        values
          (ln_contad,
           i.n_codmsj,
           i.c_codter,
           i.c_codtrx,
           i.c_numtar,
           i.c_numcta,
           i.d_fecini,
           i.d_fecfin,
           i.c_horpro,
           i.n_mtoope,
           i.c_codres,
           P_C_CODUSU,
           i.n_mtoitf,
           i.n_moneda);
      
        ln_contad := ln_contad + 1;        
      end loop;
      commit;
      if P_N_CODMSJ = 200 and lc_codtrx = '01' then
         for i in c9(lc_codter,P_D_FECINI,P_D_FECFIN) loop
      
            insert into jaql544
            (jaql544seria,
             jaql544comsj,
             jaql544coter,
             jaql544cotrx,
             jaql544nutar,
             jaql544nucta,
             jaql544feini,
             jaql544fefin,
             jaql544hopro,
             jaql544mtoop,
             jaql544cores,
             jaql544opera, 
             jaql544de001, 
             jaql544en001
            )
            values
            (ln_contad,
             i.n_codmsj,
             i.c_codter,
             i.c_codtrx,
             i.c_numtar,
             i.c_numcta,
             i.d_fecini,
             i.d_fecfin,
             i.c_horpro,
             i.n_mtoope,
             i.c_codres,
             P_C_CODUSU,
             i.n_mtoitf,
             i.n_moneda);
     
          ln_contad := ln_contad + 1;        
         end loop;
         commit;
      end if;
    end if;
    
  
  exception
    when others then
      p_c_coderr := sqlcode;
      p_c_msgerr := sqlerrm;
    
  end sp_oc_mensajes_por_atm;
  
  procedure sp_oc_transacciones_autor_uba(p_c_tiprol in varchar2,
                                          p_c_tiprep in varchar2,
                                          p_c_codtrx in varchar2,
                                          p_d_fecini in date,
                                          p_d_fecfin in date,
                                          p_c_codusu in varchar2,
                                          p_c_coderr out varchar2,
                                          p_c_msgerr out varchar2) is
  
  --// Cursor para los reportes con fecha del dia                   
  cursor c1(P_C_CODTRX in varchar2,
            P_D_FECINI in date,
            P_D_FECFIN in date) is
    select /*+ choose parallel(a,2) parallel(d,2) */
     a.jaql540cotra n_codtra,
     a.jaql540nutra c_numtra,
     a.jaql540cotrx c_codtra,
     a.jaql540feini d_fecini,
     a.jaql540fefin d_fecfin,
     a.jaql540hoini c_horini,
     a.jaql540hofin c_horfin,
     (select /*+ choose parallel(e,2) */
       e.jaql539valtr
        from jaql539 e
       where jaql539nucam = 49
         and jaql539cotra = a.jaql540cotra) c_codmon,
     (select /*+ choose parallel(e,2) */
       --to_char(to_number(nvl(e.jaql539valtr, 0)) / 100.00, '999,999,999.99')
       to_number(nvl(e.jaql539valtr, 0)) / 100.00
        from jaql539 e
       where jaql539nucam = 4
         and jaql539cotra = a.jaql540cotra) n_mtoope,
     (select /*+ choose parallel(e,2) */
       e.jaql539valtr
        from jaql539 e
       where jaql539nucam = 43
         and jaql539cotra = a.jaql540cotra) c_ubicac,
     a.jaql540nutar c_numtar,
     d.jaql539valtr c_nuinst,
     a.jaql540comsj n_codmsj,
     a.jaql540cores c_codres,
     a.jaql540coter n_codter,
     a.jaql540modul n_modulo,
     a.jaql540trans n_transa,
     a.jaql540relac n_relaci,
     a.jaql540paist c_paitrx,
     a.jaql540fetra d_fectra,
     (select /*+ choose parallel(b,2) choose parallel(c,2)*/
       lPad(Trim(to_char(c.ctnro)), 9, '0') || '-' ||
       lPad(Trim(to_char(c.modulo)), 3, '0') || '-' ||
       lpad(Trim(to_char(c.moneda)), 3, '0') || '-' ||
       lpad(Trim(to_char(c.itsubo)), 2, '0') || '-' ||
       lpad(Trim(to_char(c.ittope)), 3, '0')
        from fsd015 b, fsd016 c
       where b.pgcod = c.pgcod
         and b.itsuc = c.itsuc
         and b.itmod = c.itmod
         and b.ittran = c.ittran
         and b.itnrel = c.itnrel
         and b.itfcon = c.itfval
         and c.itord = 10
         and b.itfcon = a.jaql540feini
         and b.itsuc = 903
         and b.itmod = a.jaql540modul
         and b.ittran = a.jaql540trans
         and b.itnrel = a.jaql540relac) c_numcta
      from jaql540 a, jaql539 d
     where a.jaql540cotra = d.jaql539cotra
       and a.jaql540feini >= P_D_FECINI
       and a.jaql540fefin <= P_D_FECFIN
       and d.jaql539nucam = 32
       and d.jaql539valtr = '06890605'
       --and a.jaql540coter like lpad(P_C_CODTER, '5', '0')
       --and to_number(a.jaql540coter) > 0
       and substr(a.jaql540cotrx, 1, 2) like lpad(trim(P_C_CODTRX), 2, '0')
     order by 1;
  ------------------------------------------------------------------------------------------------------    
  
  --// Cursor para los reportes con fecha histórica
  cursor c2(P_C_CODTRX in varchar2,
            P_D_FECINI in date,
            P_D_FECFIN in date) is
    select /*+ choose parallel(a,4,1) parallel(d,4,1) */
     a.jaql540cotra n_codtra,
     a.jaql540nutra c_numtra,
     a.jaql540cotrx c_codtra,
     a.jaql540feini d_fecini,
     a.jaql540fefin d_fecfin,
     a.jaql540hoini c_horini,
     a.jaql540hofin c_horfin,
     (select /*+ choose parallel(e,4,1) */
       e.jaql539valtr
        from jaql539 e
       where jaql539nucam = 49
         and jaql539cotra = a.jaql540cotra) c_codmon,
     (select /*+ choose parallel(e,4,1) */
       --to_char(to_number(nvl(e.jaql539valtr, 0)) / 100.00, '999,999,999.99')
       to_number(nvl(e.jaql539valtr, 0)) / 100.00
        from jaql539 e
       where jaql539nucam = 4
         and jaql539cotra = a.jaql540cotra) n_mtoope,
     (select /*+ choose parallel(e,4,1) */
       e.jaql539valtr
        from jaql539 e
       where jaql539nucam = 43
         and jaql539cotra = a.jaql540cotra) c_ubicac,
     a.jaql540nutar c_numtar,
     d.jaql539valtr c_nuinst,
     a.jaql540comsj n_codmsj,
     a.jaql540cores c_codres,
     a.jaql540coter n_codter,
     a.jaql540modul n_modulo,
     a.jaql540trans n_transa,
     a.jaql540relac n_relaci,
     a.jaql540paist c_paitrx,
     a.jaql540fetra d_fectra,
     (select /*+ choose parallel(b,4,1) choose parallel(c,4,1)*/
       lPad(Trim(to_char(c.hcta)), 9, '0') || '-' ||
       lPad(Trim(to_char(c.hmodul)), 3, '0') || '-' ||
       lpad(Trim(to_char(c.hmda)), 3, '0') || '-' ||
       lpad(Trim(to_char(c.hsubop)), 2, '0') || '-' ||
       lpad(Trim(to_char(c.htoper)), 3, '0')
        from fsh015 b, fsh016 c
       where b.pgcod = c.pgcod
         and b.hsucor = c.hsucor
         and b.hcmod = c.hcmod
         and b.htran = c.htran
         and b.hnrel = c.hnrel
         and b.hfcon = c.hfval
         and c.hcord = 10
         and b.hfcon = a.jaql540feini
         and b.hsucor = 903
         and b.hcmod = a.jaql540modul
         and b.htran = a.jaql540trans
         and b.hnrel = a.jaql540relac) c_numcta
      from jaql540 a, jaql539 d
     where a.jaql540cotra = d.jaql539cotra
       and a.jaql540feini >= P_D_FECINI
       and a.jaql540fefin <= P_D_FECFIN
       and d.jaql539nucam = 32
       and d.jaql539valtr = '06890605'
       --and a.jaql540coter like lpad(P_C_CODTER, '5', '0')
       --and to_number(a.jaql540coter) > 0
       and substr(a.jaql540cotrx, 1, 2) like lpad(trim(P_C_CODTRX), 2, '0')
     order by 1;
     
  --// Cursor para los reportes con rango de fechas de historica a diaria
  cursor c3(P_C_CODTRX in varchar2,
            P_D_FECINI in date,
            P_D_FECFIN in date) is
    select /*+ choose parallel(a,4,1) parallel(d,4,1) */     
     distinct a.jaql540cotra n_codtra,
     a.jaql540nutra c_numtra,
     a.jaql540cotrx c_codtra,
     a.jaql540feini d_fecini,
     a.jaql540fefin d_fecfin,
     a.jaql540hoini c_horini,
     a.jaql540hofin c_horfin,
     (select /*+ choose parallel(e,4,1) */
       e.jaql539valtr
        from jaql539 e
       where jaql539nucam = 49
         and jaql539cotra = a.jaql540cotra) c_codmon,
     (select /*+ choose parallel(e,4,1) */
       --to_char(to_number(nvl(e.jaql539valtr, 0)) / 100.00, '999,999,999.99')
       to_number(nvl(e.jaql539valtr, 0)) / 100.00
        from jaql539 e
       where jaql539nucam = 4
         and jaql539cotra = a.jaql540cotra) n_mtoope,
     (select /*+ choose parallel(e,4,1) */
       e.jaql539valtr
        from jaql539 e
       where jaql539nucam = 43
         and jaql539cotra = a.jaql540cotra) c_ubicac,
     a.jaql540nutar c_numtar,
     d.jaql539valtr c_nuinst,
     a.jaql540comsj n_codmsj,
     a.jaql540cores c_codres,
     a.jaql540coter n_codter,
     a.jaql540modul n_modulo,
     a.jaql540trans n_transa,
     a.jaql540relac n_relaci,
     a.jaql540paist c_paitrx,
     a.jaql540fetra d_fectra,
     (select /*+ choose parallel(b,2) choose parallel(c,2)*/
       lPad(Trim(to_char(c.ctnro)), 9, '0') || '-' ||
       lPad(Trim(to_char(c.modulo)), 3, '0') || '-' ||
       lpad(Trim(to_char(c.moneda)), 3, '0') || '-' ||
       lpad(Trim(to_char(c.itsubo)), 2, '0') || '-' ||
       lpad(Trim(to_char(c.ittope)), 3, '0')
        from fsd015 b, fsd016 c
       where b.pgcod = c.pgcod
         and b.itsuc = c.itsuc
         and b.itmod = c.itmod
         and b.ittran = c.ittran
         and b.itnrel = c.itnrel
         and b.itfcon = c.itfval
         and c.itord = 10
         and b.itfcon = a.jaql540feini
         and b.itsuc = 903
         and b.itmod = a.jaql540modul
         and b.ittran = a.jaql540trans
         and b.itnrel = a.jaql540relac) c_numcta
      from jaql540 a, jaql539 d
     where a.jaql540cotra = d.jaql539cotra
       and a.jaql540feini >= P_D_FECINI
       and a.jaql540fefin <= P_D_FECFIN
       and d.jaql539nucam = 32
       and d.jaql539valtr = '06890605'
       --and a.jaql540coter like lpad(P_C_CODTER, '5', '0')
       --and to_number(a.jaql540coter) > 0
       and substr(a.jaql540cotrx, 1, 2) like lpad(trim(P_C_CODTRX), 2, '0')
    union
    select /*+ choose parallel(a,4,1) parallel(d,4,1) */
     distinct a.jaql540cotra n_codtra,
     a.jaql540nutra c_numtra,
     a.jaql540cotrx c_codtra,
     a.jaql540feini d_fecini,
     a.jaql540fefin d_fecfin,
     a.jaql540hoini c_horini,
     a.jaql540hofin c_horfin,
     (select /*+ choose parallel(e,4,1) */
       e.jaql539valtr
        from jaql539 e
       where jaql539nucam = 49
         and jaql539cotra = a.jaql540cotra) c_codmon,
     (select /*+ choose parallel(e,4,1) */
       --to_char(to_number(nvl(e.jaql539valtr, 0)) / 100.00, '999,999,999.99')
       to_number(nvl(e.jaql539valtr, 0)) / 100.00
        from jaql539 e
       where jaql539nucam = 4
         and jaql539cotra = a.jaql540cotra) n_mtoope,
     (select /*+ choose parallel(e,4,1) */
       e.jaql539valtr
        from jaql539 e
       where jaql539nucam = 43
         and jaql539cotra = a.jaql540cotra) c_ubicac,
     a.jaql540nutar c_numtar,
     d.jaql539valtr c_nuinst,
     a.jaql540comsj n_codmsj,
     a.jaql540cores c_codres,
     a.jaql540coter n_codter,
     a.jaql540modul n_modulo,
     a.jaql540trans n_transa,
     a.jaql540relac n_relaci,
     a.jaql540paist c_paitrx,
     a.jaql540fetra d_fectra,
     (select /*+ choose parallel(b,4,1) choose parallel(c,4,1)*/
       lPad(Trim(to_char(c.hcta)), 9, '0') || '-' ||
       lPad(Trim(to_char(c.hmodul)), 3, '0') || '-' ||
       lpad(Trim(to_char(c.hmda)), 3, '0') || '-' ||
       lpad(Trim(to_char(c.hsubop)), 2, '0') || '-' ||
       lpad(Trim(to_char(c.htoper)), 3, '0')
        from fsh015 b, fsh016 c
       where b.pgcod = c.pgcod
         and b.hsucor = c.hsucor
         and b.hcmod = c.hcmod
         and b.htran = c.htran
         and b.hnrel = c.hnrel
         and b.hfcon = c.hfval
         and c.hcord = 10
         and b.hfcon = a.jaql540feini
         and b.hsucor = 903
         and b.hcmod = a.jaql540modul
         and b.htran = a.jaql540trans
         and b.hnrel = a.jaql540relac) c_numcta
      from jaql540 a, jaql539 d
     where a.jaql540cotra = d.jaql539cotra
       and a.jaql540feini >= P_D_FECINI
       and a.jaql540fefin <= P_D_FECFIN
       and d.jaql539nucam = 32
       and d.jaql539valtr = '06890605'
       --and a.jaql540coter like lpad(P_C_CODTER, '5', '0')
       --and to_number(a.jaql540coter) > 0
       and substr(a.jaql540cotrx, 1, 2) like lpad(trim(P_C_CODTRX), 2, '0')
     order by 1;
     
  --// Cursor para los movimientos de Adquiriete
  cursor c4(P_D_FECINI in date,
            P_D_FECFIN in date) is
   select /*+ choose parallel(a,2) parallel(d,2) */
     a.jaql540cotra n_codtra,
     a.jaql540nutra c_numtra,
     a.jaql540cotrx c_codtra,
     a.jaql540feini d_fecini,
     a.jaql540fefin d_fecfin,
     a.jaql540hoini c_horini,
     a.jaql540hofin c_horfin,
     (select /*+ choose parallel(e,2) */
       e.jaql539valtr
        from jaql539 e
       where jaql539nucam = 49
         and jaql539cotra = a.jaql540cotra) c_codmon,
     (select /*+ choose parallel(e,2) */
       --to_char(to_number(nvl(e.jaql539valtr, 0)) / 100.00, '999,999,999.99')
       to_number(nvl(e.jaql539valtr, 0)) / 100.00
        from jaql539 e
       where jaql539nucam = 4
         and jaql539cotra = a.jaql540cotra) n_mtoope,
     (select /*+ choose parallel(e,2) */ e.jaql539valtr        
        from jaql539 e       
       where jaql539nucam = 43         
         and jaql539cotra = a.jaql540cotra) c_ubicac,
     a.jaql540nutar c_numtar,
     d.jaql539valtr c_nuinst,
     a.jaql540comsj n_codmsj,
     a.jaql540cores c_codres,
     a.jaql540coter n_codter,
     a.jaql540modul n_modulo,
     a.jaql540trans n_transa,
     a.jaql540relac n_relaci,
     a.jaql540paist c_paitrx,
     a.jaql540fetra d_fectra,
     (select /*+ choose parallel(b,2) choose parallel(c,2)*/
       lPad(Trim(to_char(c.hcta)), 9, '0') || '-' ||
       lPad(Trim(to_char(c.hmodul)), 3, '0') || '-' ||
       lpad(Trim(to_char(c.hmda)), 3, '0') || '-' ||
       lpad(Trim(to_char(c.hsubop)), 2, '0') || '-' ||
       lpad(Trim(to_char(c.htoper)), 3, '0')
       from fsh015 b, fsh016 c
       where b.pgcod = c.pgcod
         and b.hsucor = c.hsucor
         and b.hcmod = c.hcmod
         and b.htran = c.htran
         and b.hnrel = c.hnrel
         and b.hfcon = c.hfval
         and c.hcord = 10
         and b.hfcon = a.jaql540feini
         and b.hsucor = 903
         and b.hcmod = a.jaql540modul
         and b.htran = a.jaql540trans
         and b.hnrel = a.jaql540relac) c_numcta
      from jaql540 a, jaql539 d
     where a.jaql540cotra = d.jaql539cotra
       and a.jaql540feini >= P_D_FECINI
       and a.jaql540fefin <= P_D_FECFIN
       and substr(a.jaql540nutar, 1,6) <> '426153'
       and substr(a.jaql540nutar, 1,6) <> '851004'
       and (d.jaql539nucam = 32 and d.jaql539valtr = '06890600')
  order by 1;
  
  --// Cursor para los movimientos de Adquiriete
  cursor c5(P_D_FECINI in date,
            P_D_FECFIN in date) is
   select /*+ choose parallel(a,2) parallel(d,2) */
     a.jaql540cotra n_codtra,
     a.jaql540nutra c_numtra,
     a.jaql540cotrx c_codtra,
     a.jaql540feini d_fecini,
     a.jaql540fefin d_fecfin,
     a.jaql540hoini c_horini,
     a.jaql540hofin c_horfin,
     (select /*+ choose parallel(e,2) */
       e.jaql539valtr
        from jaql539 e
       where jaql539nucam = 49
         and jaql539cotra = a.jaql540cotra) c_codmon,
     (select /*+ choose parallel(e,2) */
       --to_char(to_number(nvl(e.jaql539valtr, 0)) / 100.00, '999,999,999.99')
       to_number(nvl(e.jaql539valtr, 0)) / 100.00
        from jaql539 e
       where jaql539nucam = 4
         and jaql539cotra = a.jaql540cotra) n_mtoope,
     (select /*+ choose parallel(e,2) */ e.jaql539valtr        
        from jaql539 e       
       where jaql539nucam = 43         
         and jaql539cotra = a.jaql540cotra) c_ubicac,
     a.jaql540nutar c_numtar,
     d.jaql539valtr c_nuinst,
     a.jaql540comsj n_codmsj,
     a.jaql540cores c_codres,
     a.jaql540coter n_codter,
     a.jaql540modul n_modulo,
     a.jaql540trans n_transa,
     a.jaql540relac n_relaci,
     a.jaql540paist c_paitrx,
     a.jaql540fetra d_fectra,
     (select /*+ choose parallel(b,2) choose parallel(c,2)*/
       lPad(Trim(to_char(c.hcta)), 9, '0') || '-' ||
       lPad(Trim(to_char(c.hmodul)), 3, '0') || '-' ||
       lpad(Trim(to_char(c.hmda)), 3, '0') || '-' ||
       lpad(Trim(to_char(c.hsubop)), 2, '0') || '-' ||
       lpad(Trim(to_char(c.htoper)), 3, '0')
       from fsh015 b, fsh016 c
       where b.pgcod = c.pgcod
         and b.hsucor = c.hsucor
         and b.hcmod = c.hcmod
         and b.htran = c.htran
         and b.hnrel = c.hnrel
         and b.hfcon = c.hfval
         and c.hcord = 10
         and b.hfcon = a.jaql540feini
         and b.hsucor = 903
         and b.hcmod = a.jaql540modul
         and b.htran = a.jaql540trans
         and b.hnrel = a.jaql540relac) c_numcta
      from jaql540 a, jaql539 d
     where a.jaql540cotra = d.jaql539cotra
       and a.jaql540feini >= P_D_FECINI
       and a.jaql540fefin <= P_D_FECFIN
       and substr(a.jaql540nutar, 1,6) <> '426153'
       and substr(a.jaql540nutar, 1,6) <> '851004'
       and (d.jaql539nucam = 32 and d.jaql539valtr = '06890600')
  order by 1;
  
  --// Cursor para los movimientos de Adquiriete
  cursor c6(P_D_FECINI in date,
            P_D_FECFIN in date) is
   select /*+ choose parallel(a,2) parallel(d,2) */
     a.jaql540cotra n_codtra,
     a.jaql540nutra c_numtra,
     a.jaql540cotrx c_codtra,
     a.jaql540feini d_fecini,
     a.jaql540fefin d_fecfin,
     a.jaql540hoini c_horini,
     a.jaql540hofin c_horfin,
     (select /*+ choose parallel(e,2) */
       e.jaql539valtr
        from jaql539 e
       where jaql539nucam = 49
         and jaql539cotra = a.jaql540cotra) c_codmon,
     (select /*+ choose parallel(e,2) */
       --to_char(to_number(nvl(e.jaql539valtr, 0)) / 100.00, '999,999,999.99')
       to_number(nvl(e.jaql539valtr, 0)) / 100.00
        from jaql539 e
       where jaql539nucam = 4
         and jaql539cotra = a.jaql540cotra) n_mtoope,
     (select /*+ choose parallel(e,2) */ e.jaql539valtr        
        from jaql539 e       
       where jaql539nucam = 43         
         and jaql539cotra = a.jaql540cotra) c_ubicac,
     a.jaql540nutar c_numtar,
     d.jaql539valtr c_nuinst,
     a.jaql540comsj n_codmsj,
     a.jaql540cores c_codres,
     a.jaql540coter n_codter,
     a.jaql540modul n_modulo,
     a.jaql540trans n_transa,
     a.jaql540relac n_relaci,
     a.jaql540paist c_paitrx,
     a.jaql540fetra d_fectra,
     (select /*+ choose parallel(b,2) choose parallel(c,2)*/
       lPad(Trim(to_char(c.hcta)), 9, '0') || '-' ||
       lPad(Trim(to_char(c.hmodul)), 3, '0') || '-' ||
       lpad(Trim(to_char(c.hmda)), 3, '0') || '-' ||
       lpad(Trim(to_char(c.hsubop)), 2, '0') || '-' ||
       lpad(Trim(to_char(c.htoper)), 3, '0')
       from fsh015 b, fsh016 c
       where b.pgcod = c.pgcod
         and b.hsucor = c.hsucor
         and b.hcmod = c.hcmod
         and b.htran = c.htran
         and b.hnrel = c.hnrel
         and b.hfcon = c.hfval
         and c.hcord = 10
         and b.hfcon = a.jaql540feini
         and b.hsucor = 903
         and b.hcmod = a.jaql540modul
         and b.htran = a.jaql540trans
         and b.hnrel = a.jaql540relac) c_numcta
      from jaql540 a, jaql539 d
     where a.jaql540cotra = d.jaql539cotra
       and a.jaql540feini >= P_D_FECINI
       and a.jaql540fefin <= P_D_FECFIN
       and substr(a.jaql540nutar, 1,6) <> '426153'
       and substr(a.jaql540nutar, 1,6) <> '851004'
       and (d.jaql539nucam = 32 and d.jaql539valtr = '06890600')
  order by 1;
  
  ln_contad number := 1;
  ld_fecsys date;
  lc_codtrx varchar2(3) := null;
  lc_desele varchar2(100) := null;
  lc_locati varchar2(40) := null;
  lc_codtra varchar2(6) := null;
  lc_numtra varchar2(12) := null;
  --//
begin
  -- Inicializar Valores
  p_c_coderr := '00000';
  p_c_msgerr := '';
 
  if P_C_CODTRX = '000' then
    lc_codtrx := '%';
  else
    lc_codtrx := P_C_CODTRX;
  end if;
  
  -- Carga de Variables
  begin
    select a1.pgfape into ld_fecsys from fst017 a1 where a1.pgcod = 1;
  exception
    when others then
      ld_fecsys := trunc(sysdate);
  end;

  -- Proceso
  execute immediate 'truncate table JAQL545';
  
  insert into log_error_bandeja (n_Nro,c_codbdj,c_deserr,d_fecerr)
  values (9,'ATM','REPO',P_D_FecIni);
  insert into log_error_bandeja (n_Nro,c_codbdj,c_deserr,d_fecerr)
  values (9,'ATM','REPO',P_D_FecFin);
  commit;

  if P_C_TIPROL = '0' and P_D_FECINI = ld_fecsys and P_D_FECFIN = ld_fecsys then
    for i in c1(lc_codtrx, P_D_FECINI, P_D_FECFIN) loop
      
      begin
        select c_desele
          into lc_desele
          from sytaatm
         where c_codatr = '04'
           and c_codele = i.c_codres;
      exception
        when others then
          lc_desele := null;
      end;
    
      insert into jaql545
        (jaql545seria,
         jaql545cotra,
         jaql545nutra,
         jaql545cotrx,
         jaql545feini,
         jaql545fefin,
         jaql545hoini,
         jaql545hofin,
         jaql545comon,
         jaql545mtoop,
         jaql545ubica,
         jaql545nutar,
         jaql545nuins,
         jaql545comsj,
         jaql545cores,
         jaql545coter,
         jaql545modul,
         jaql545trans,
         jaql545relac,
         jaql545paist,
         jaql545fetra,
         jaql545nucta,
         jaql545cousu,
         jaql545v0001)
      values
        (ln_contad,
         i.n_codtra,
         i.c_numtra,
         i.c_codtra,
         i.d_fecini,
         i.d_fecfin,
         i.c_horini,
         i.c_horfin,
         i.c_codmon,
         i.n_mtoope,
         i.c_ubicac,
         i.c_numtar,
         i.c_nuinst,
         i.n_codmsj,
         i.c_codres,
         i.n_codter,
         i.n_modulo,
         i.n_transa,
         i.n_relaci,
         i.c_paitrx,
         i.d_fectra,
         i.c_numcta,
         P_C_CODUSU,
         lc_desele);
    
      ln_contad := ln_contad + 1;
      
    end loop;
    commit;
  end if;

  if P_C_TIPROL = '0' and  P_D_FECINI <> ld_fecsys and P_D_FECFIN <> ld_fecsys then
    for i in c2( lc_codtrx, P_D_FECINI, P_D_FECFIN) loop
    
      begin
        select c_desele
          into lc_desele
          from sytaatm
         where c_codatr = '04'
           and c_codele = i.c_codres;
      exception
        when others then
          lc_desele := null;
      end;
    
      insert into jaql545
        (jaql545seria,
         jaql545cotra,
         jaql545nutra,
         jaql545cotrx,
         jaql545feini,
         jaql545fefin,
         jaql545hoini,
         jaql545hofin,
         jaql545comon,
         jaql545mtoop,
         jaql545ubica,
         jaql545nutar,
         jaql545nuins,
         jaql545comsj,
         jaql545cores,
         jaql545coter,
         jaql545modul,
         jaql545trans,
         jaql545relac,
         jaql545paist,
         jaql545fetra,
         jaql545nucta,
         jaql545cousu,
         jaql545v0001)
      values
        (ln_contad,
         i.n_codtra,
         i.c_numtra,
         i.c_codtra,
         i.d_fecini,
         i.d_fecfin,
         i.c_horini,
         i.c_horfin,
         i.c_codmon,
         i.n_mtoope,
         i.c_ubicac,
         i.c_numtar,
         i.c_nuinst,
         i.n_codmsj,
         i.c_codres,
         i.n_codter,
         i.n_modulo,
         i.n_transa,
         i.n_relaci,
         i.c_paitrx,
         i.d_fectra,
         i.c_numcta,
         P_C_CODUSU,
         lc_desele);
    
      ln_contad := ln_contad + 1;
    end loop;
    commit;
  end if;
  
  if P_C_TIPROL = '0' and P_D_FECINI <> ld_fecsys and P_D_FECFIN = ld_fecsys then
    for i in c3( lc_codtrx, P_D_FECINI, P_D_FECFIN) loop
    
      begin
        select c_desele
          into lc_desele
          from sytaatm
         where c_codatr = '04'
           and c_codele = i.c_codres;
      exception
        when others then
          lc_desele := null;
      end;
    
      insert into jaql545
        (jaql545seria,
         jaql545cotra,
         jaql545nutra,
         jaql545cotrx,
         jaql545feini,
         jaql545fefin,
         jaql545hoini,
         jaql545hofin,
         jaql545comon,
         jaql545mtoop,
         jaql545ubica,
         jaql545nutar,
         jaql545nuins,
         jaql545comsj,
         jaql545cores,
         jaql545coter,
         jaql545modul,
         jaql545trans,
         jaql545relac,
         jaql545paist,
         jaql545fetra,
         jaql545nucta,
         jaql545cousu,
         jaql545v0001)
      values
        (ln_contad,
         i.n_codtra,
         i.c_numtra,
         i.c_codtra,
         i.d_fecini,
         i.d_fecfin,
         i.c_horini,
         i.c_horfin,
         i.c_codmon,
         i.n_mtoope,
         i.c_ubicac,
         i.c_numtar,
         i.c_nuinst,
         i.n_codmsj,
         i.c_codres,
         i.n_codter,
         i.n_modulo,
         i.n_transa,
         i.n_relaci,
         i.c_paitrx,
         i.d_fectra,
         i.c_numcta,
         P_C_CODUSU,
         lc_desele);
    
      ln_contad := ln_contad + 1;
    end loop;
    commit;
  end if;
  
  --// Adquiriente
  if P_C_TIPROL = '1' and P_D_FECINI = ld_fecsys and P_D_FECFIN = ld_fecsys then
    for i in c4(P_D_FECINI, P_D_FECFIN) loop
    
      begin
        select c_desele
          into lc_desele
          from sytaatm
         where c_codatr = '04'
           and c_codele = i.c_codres;
      exception
        when others then
          lc_desele := null;
      end;
      
      begin        
      select location 
          into lc_locati
          from ATMTBL@cajero --DBLSW
         where unit = to_number(i.n_codter);
      exception
        when others then
          lc_desele := null;
      end;
      
     begin
       select lpad(to_char(trace),12 ,'0'), lpad(to_char(prcode),6 ,'0')
         into lc_numtra, lc_codtra
         from itxn@cajero --DBLSW
        where capdate = i.d_fecini
          and pan = i.c_numtar
          and txnamt = (i.n_mtoope*100)
          and respcode = to_number(i.c_codres);
     exception   
       when others then     
         lc_numtra := null;
         lc_codtra := null;
     end;
    
      insert into jaql545
        (jaql545seria,
         jaql545cotra,
         jaql545nutra,
         jaql545cotrx,
         jaql545feini,
         jaql545fefin,
         jaql545hoini,
         jaql545hofin,
         jaql545comon,
         jaql545mtoop,
         jaql545ubica,
         jaql545nutar,
         jaql545nuins,
         jaql545comsj,
         jaql545cores,
         jaql545coter,
         jaql545modul,
         jaql545trans,
         jaql545relac,
         jaql545paist,
         jaql545fetra,
         jaql545nucta,
         jaql545cousu,
         jaql545v0001)
      values
        (ln_contad,
         i.n_codtra,
         lc_numtra,
         lc_codtra,
         i.d_fecini,
         i.d_fecfin,
         i.c_horini,
         i.c_horfin,
         i.c_codmon,
         i.n_mtoope,
         lc_locati,
         i.c_numtar,
         i.c_nuinst,
         i.n_codmsj,
         i.c_codres,
         i.n_codter,
         i.n_modulo,
         i.n_transa,
         i.n_relaci,
         i.c_paitrx,
         i.d_fectra,
         i.c_numcta,
         P_C_CODUSU,
         lc_desele);
    
      ln_contad := ln_contad + 1;
    end loop;
    commit;
  end if;
  
  
  --// Adquiriente
  if P_C_TIPROL = '1' and P_D_FECINI <> ld_fecsys and P_D_FECFIN <> ld_fecsys then
    for i in c6(P_D_FECINI, P_D_FECFIN) loop
    
      begin
        select c_desele
          into lc_desele
          from sytaatm
         where c_codatr = '04'
           and c_codele = i.c_codres;

      exception
        when others then
          lc_desele := null;

      end;

      
      begin        
      select location 
          into lc_locati
          from ATMTBL@cajero --DBLSW
         where unit = to_number(i.n_codter);

      exception
        when others then
          lc_desele := null;

      end;

      
     begin
       select lpad(to_char(trace),12 ,'0'), lpad(to_char(prcode),6 ,'0')
         into lc_numtra, lc_codtra
         from itxn@cajero --DBLSW
        where capdate = i.d_fecini
          and pan = i.c_numtar
          and txnamt = (i.n_mtoope*100)
          and respcode = to_number(i.c_codres);

     exception   
       when others then     
         lc_numtra := null;
         lc_codtra := null;

     end;

    
      insert into jaql545
        (jaql545seria,
         jaql545cotra,
         jaql545nutra,
         jaql545cotrx,
         jaql545feini,
         jaql545fefin,
         jaql545hoini,
         jaql545hofin,
         jaql545comon,
         jaql545mtoop,
         jaql545ubica,
         jaql545nutar,
         jaql545nuins,
         jaql545comsj,
         jaql545cores,
         jaql545coter,
         jaql545modul,
         jaql545trans,
         jaql545relac,
         jaql545paist,
         jaql545fetra,
         jaql545nucta,
         jaql545cousu,
         jaql545v0001)
      values
        (ln_contad,
         i.n_codtra,
         lc_numtra,
         lc_codtra,
         i.d_fecini,
         i.d_fecfin,
         i.c_horini,
         i.c_horfin,
         i.c_codmon,
         i.n_mtoope,
         lc_locati,
         i.c_numtar,
         i.c_nuinst,
         i.n_codmsj,
         i.c_codres,
         i.n_codter,
         i.n_modulo,
         i.n_transa,
         i.n_relaci,
         i.c_paitrx,
         i.d_fectra,
         i.c_numcta,
         P_C_CODUSU,
         lc_desele);

    
      ln_contad := ln_contad + 1;
    end loop;

    commit;
  end if;
  
  --// Adquiriente
  if P_C_TIPROL = '1' and P_D_FECINI <> ld_fecsys and P_D_FECFIN = ld_fecsys then
    for i in c5(P_D_FECINI, P_D_FECFIN) loop
    
      begin
        select c_desele
          into lc_desele
          from sytaatm
         where c_codatr = '04'
           and c_codele = i.c_codres;
      exception
        when others then
          lc_desele := null;
      end;
      
      begin        
      select location 
          into lc_locati
          from ATMTBL@cajero --DBLSW
         where unit = to_number(i.n_codter);
      exception
        when others then
          lc_desele := null;

      end;
      
     begin
       select lpad(to_char(trace),12 ,'0'), lpad(to_char(prcode),6 ,'0')
         into lc_numtra, lc_codtra
         from itxn@cajero --DBLSW
        where capdate = i.d_fecini
          and pan = i.c_numtar
          and txnamt = (i.n_mtoope*100)
          and respcode = to_number(i.c_codres);
     exception   
       when others then     
         lc_numtra := null;
         lc_codtra := null;

     end;
      insert into jaql545
        (jaql545seria,
         jaql545cotra,
         jaql545nutra,
         jaql545cotrx,
         jaql545feini,
         jaql545fefin,
         jaql545hoini,
         jaql545hofin,
         jaql545comon,
         jaql545mtoop,
         jaql545ubica,
         jaql545nutar,
         jaql545nuins,
         jaql545comsj,
         jaql545cores,
         jaql545coter,
         jaql545modul,
         jaql545trans,
         jaql545relac,
         jaql545paist,
         jaql545fetra,
         jaql545nucta,
         jaql545cousu,
         jaql545v0001)
      values
        (ln_contad,
         i.n_codtra,
         lc_numtra,
         lc_codtra,
         i.d_fecini,
         i.d_fecfin,
         i.c_horini,
         i.c_horfin,
         i.c_codmon,
         i.n_mtoope,
         lc_locati,
         i.c_numtar,
         i.c_nuinst,
         i.n_codmsj,
         i.c_codres,
         i.n_codter,
         i.n_modulo,
         i.n_transa,
         i.n_relaci,
         i.c_paitrx,
         i.d_fectra,
         i.c_numcta,
         P_C_CODUSU,
         lc_desele);


    
      ln_contad := ln_contad + 1;
    end loop;
    commit;
  end if;

exception
  when others then
    p_c_coderr := sqlcode;
    p_c_msgerr := sqlerrm;
    
end sp_oc_transacciones_autor_uba;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
END PQ_REPS_OPERACIONES_CANALES;
/

