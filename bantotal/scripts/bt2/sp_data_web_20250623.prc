create or replace procedure sp_data_web(pd_fecha in date) is
   -- *****************************************************************
  -- Nombre                     : sp_data_web
  -- Versión                    : 1.0
  -- Fecha de Creación          : 
  -- Uso                        : sp_data_web
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2025.06.24
  -- Autor de la Modificación   : EHIDALGO
  -- Descripción de Modificación: Se comento dblink navidad@web
  -- *****************************************************************

 cursor cur_cupones is
    select jaqL406cup n_nrocup,
           jaqL406cre c_nrocre,
           d.tdnom    c_tipdoc,
           b.pendoc   c_nrodoc,
           c.penom    c_nomcon,
           jaqL406fop d_fecope,
           jaqL406tip c_tipope
      from JAQL406 a, fsr008 b, fsd001 c, fst014 d
     where b.ctnro  = a.jaql406cta
       and b.cttfir = 'T'
       and c.pepais = b.pepais
       and c.petdoc = b.petdoc
       and c.pendoc = b.pendoc
       and d.tdocum = b.petdoc
       --and a.jaql406cal = 1
       and a.jaql406excup = 'C'
       and a.jaql406tip in ('A','C','D','P','CD','M')
       --and a.jaql406fop = trunc(sysdate);
       and a.jaql406fop = pd_fecha;

 cursor cur_cupones_t is
        select /*+all_rows parallel(a,8) parallel(b,8) parallel(c,8) parallel(d,8)*/
         JAQL406cup n_nrocup,
               JAQL406cre c_nrocre,
               d.tdnom    c_tipdoc,
               b.z0e478thd c_nrodoc,
               c.penom    c_nomcon,
               JAQL406fop d_fecope,
               JAQL406tip c_tipope
          from JAQL406 a, z0e478 b, fsd001 c, fst014 d
         where
           c.pepais = b.z0e478thp
           and c.petdoc = b.z0e478tht
           and c.pendoc = b.z0e478thd
           and d.tdocum = b.z0e478tht
	   and a.jaql406cre = b.z0e478nro
           --and c.pendoc=''
           and a.jaql406excup = 'C' --agregado para no considerar extornados 2018.
           and a.jaql406tip = 'T'           
           and a.jaql406fop = pd_fecha;

BEGIN
                             
  for i in cur_cupones loop
                              
    /*insert into navidad@web
      ("N_NROCUP",
       "C_NROCRE",
       "C_TIPDOC",
       "C_NRODOC",
       "C_NOMCON",
       "D_FECOPE",
       "C_TIPOPE")
    values
      (i.n_nrocup,
       i.c_nrocre,
       i.c_tipdoc,
       i.c_nrodoc,
       i.c_nomcon,
       i.d_fecope,
       i.c_tipope);*/
    null;--comentado 2025.06.23
                              
  end loop;
  commit;

  for j in cur_cupones_t loop
    /* insert into navidad@web
      ("N_NROCUP",
       "C_NROCRE",
       "C_TIPDOC",
       "C_NRODOC",
       "C_NOMCON",
       "D_FECOPE",
       "C_TIPOPE")
    values
      (j.n_nrocup,
       j.c_nrocre,
       j.c_tipdoc,
       j.c_nrodoc,
       j.c_nomcon,
       j.d_fecope,
       j.c_tipope);*/
    null;--comentado 2025.06.23
	end loop;    
  commit;

end sp_data_web;
/
