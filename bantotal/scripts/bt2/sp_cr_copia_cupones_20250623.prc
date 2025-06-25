create or replace procedure sp_cr_copia_cupones (P_D_FECHA date) is
  -- *****************************************************************
  -- Nombre                     : sp_cr_copia_cupones
  -- Versión                    : 1.0
  -- Fecha de Creación          : 
  -- Uso                        : sp_cr_copia_cupones
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2025.06.24
  -- Autor de la Modificación   : EHIDALGO
  -- Descripción de Modificación: Se comento dblink cupones@web
  -- *****************************************************************
  cursor cur_cupones is
    select jaql406cup n_nrocup,
           jaql406cre c_nrocre,
           d.tdnom    c_tipdoc,
           b.pendoc   c_nrodoc,
           c.penom    c_nomcon,
           jaql406fop d_fecope,
           jaql406tip c_tipope
      from JAQL406 a, fsr008 b, fsd001 c, fst014 d
     where b.ctnro = a.jaql406cta
       and b.cttfir = 'T'
       and c.pepais = b.pepais
       and c.petdoc = b.petdoc
       and c.pendoc = b.pendoc
       and d.tdocum = b.petdoc
       and a.jaql406cal = 1
       and a.jaql406fop = P_D_FECHA;

begin
  for i in cur_cupones loop
/*
    insert into cupones@web
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
       i.c_tipope);
*/ null;--comentado 2025.06.23
  end loop;
  commit;
END;
/
