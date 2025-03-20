create or replace procedure Sp_Cr_ctrlDoc_Ref(pn_ins in number,
                                              pc_flg out char) is

  -- *****************************************************************
  -- Nombre                     : PAQUETES PARA OBTENER INFORMACION DE LOS PRENDARIOS
  -- Sistema                    : BANTOTAL
  -- M�dulo                     : Cr�ditos - Activas
  -- Versi�n                    : 1.0
  -- Fecha de Creaci�n          : 2015.11.12
  -- Autor de Creaci�n          : HENRY SUAREZ
  -- Uso                        : Realiza c�lculos
  -- Estado                     : Activo
  -- Acceso                     : P�blico
  -- Par�metros de Entrada      : Nro de instancia
  -- Fecha de Modificaci�n      : 04.12.2023
  -- Autor de la Modificaci�n   : Maria Postigo
  -- Descripci�n de Modificaci�n: Se agrego una excepcion para cuando haya mas de 1 registro

  -- *****************************************************************
  ----------------------------------------------------------                                              

  cursor instancia is
    select *
      from XWF063 a
     where a.xwfinsprcid = pn_ins
       and a.xwfdocstid = 1
       and a.xwfdocstur is not null
       and a.xwfdocstur <> ' '
       and XWFDOCSTVN = 1;

  lc_flgE   char(1);
  lc_usr    char(30);
  lc_existe char(1);
begin
  for i in instancia loop
    lc_usr    := null;
    lc_existe := 'N';
    lc_flgE   := 'N';
  
    begin
      select a.xwfdocstur, 'S'
        into lc_usr, lc_existe
        from XWF063 a
       where a.xwfinsprcid = i.xwfinsprcid
         and a.xwfdocid = i.xwfdocid
         and a.xwfdocstid = 2
         and XWFDOCSTVN = 1;
    exception
      when no_data_found then
        lc_usr    := null;
        lc_existe := 'N';
      when too_many_rows then
        begin
          select a.xwfdocstur, 'S'
            into lc_usr, lc_existe
            from XWF063 a
           where a.xwfinsprcid = i.xwfinsprcid
             and a.xwfdocid = i.xwfdocid
             and a.xwfdocstid = 2
             and XWFDOCSTVN = 1
             and rownum = 1;
        exception
          when others then
            null;
        end;
    end;
  
    if lc_usr is null or lc_usr = ' ' then
      lc_flgE := 'S';
    else
      lc_flgE := 'N';
    end if;
  
    if lc_flgE = 'S' then
      exit;
    end if;
  
  end loop;

  if lc_flgE = 'S' then
    pc_flg := 'S';
  else
    pc_flg := 'N';
  end if;

end Sp_Cr_ctrlDoc_Ref;
/

