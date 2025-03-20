create or replace package PQ_AH_CONVENIO_MARCO is
   -- *****************************************************************
    -- Nombre                     : PAQUETES PARA CONVENIO MARCO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2018.04.26
    -- Autor de Creación          : JUAN APAZA
    -- Uso                        : Crea convenio Marco
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :
    --
    --
    --
    -- *****************************************************************
Procedure SP_AH_RECUPERA_PDF(P_N_AQPA210PJPAIS IN number,
                             P_N_AQPA210PJTDOC IN number,
                             P_C_AQPA210PJNDOC IN varchar2,
                             P_C_NOMREP IN VARCHAR2,
                             P_C_MENSAJE OUT VARCHAR2,
                             P_N_CODERROR OUT number);
procedure SP_AH_INSERT_AQPA210(P_N_AQPA210PJPAIS IN number,
                             P_N_AQPA210PJTDOC IN number,
                             P_C_AQPA210PJNDOC IN VARCHAR2,
                             P_N_AQPA210CTNRO IN number,
                             P_C_AQPA210SUCURS IN number,
                             P_C_AQPA210USU IN varchar2,
                             P_C_NOMARC IN varchar2,
                             P_C_AQPA210HOR IN varchar2,
                             P_D_AQPA210FEC IN DATE,
                             P_C_AQPA210AX8 IN VARCHAR2,
                             P_C_MENSAJE OUT VARCHAR2,
                             P_N_CODERROR OUT number);
procedure SP_AH_ELIMINA_CARACTER(P_C_PJRAZS IN varchar2,
                             P_C_PJRAZSOUT OUT VARCHAR2);
end PQ_AH_CONVENIO_MARCO;
/

create or replace package body PQ_AH_CONVENIO_MARCO is
Procedure SP_AH_RECUPERA_PDF(P_N_AQPA210PJPAIS IN number,
                             P_N_AQPA210PJTDOC IN number,
                             P_C_AQPA210PJNDOC IN VARCHAR2,
                             P_C_NOMREP IN VARCHAR2,
                             P_C_MENSAJE OUT VARCHAR2,
                             P_N_CODERROR OUT number)
    -- *****************************************************************
    -- Nombre                     : SP_AH_RECUPERA_PDF
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros
    -- Versión                    : 1.0
    -- Fecha de Creación          :
    -- Autor de Creación          : JUAN APAZA
    -- Uso                        :
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
  is
  vblob BLOB;
  vstart NUMBER := 1;
  bytelen NUMBER := 32000;
  len NUMBER;
  my_vr RAW(32000);
  x NUMBER;
  l_output utl_file.file_type;
  lv_nomarc      varchar2(30);
  lv_tiparc      varchar2(1);
  lv_nomprg      varchar2(10);

  begin
    P_N_CODERROR := 0;
    P_C_MENSAJE := '';
    vstart  := 1;
    bytelen := 32000;
        
    --MAPEO DE NOMBRE UNICOS PARA LOS ARCHIVOS - YLOZADA 17/08/2021
        lv_tiparc := 'D';
        lv_nomprg := 'HAQPA211';
        lv_nomarc := '';
        sp_ah_gen_cor_arch(p_c_tiparc => lv_tiparc,
                           p_c_nomprg => lv_nomprg,
                           p_c_nomarc => lv_nomarc
                           );    
                           
      begin
        UPDATE aqpa210 a
           set a.aqpa210ax7 = lv_nomarc
         WHERE A.AQPA210PJPAIS = P_N_AQPA210PJPAIS
           AND A.AQPA210PJTDOC = P_N_AQPA210PJTDOC
           AND A.AQPA210PJNDOC = rpad(P_C_AQPA210PJNDOC, 12);
         commit;
      Exception
      When Others then
        P_N_CODERROR := 1;
        P_C_MENSAJE :='No se pudo actualizar nombre de archivo a descargar';
        return;
      End;
                               
    --FIN MAPEO NOMBRES - YLOZADA 17/08/2021    

    -- get length of blob
    begin
      Select dbms_lob.getlength(a.aqpa210pdf),
             a.aqpa210pdf,
             trim(a.aqpa210ax7)
        into len,
             vblob,
             lv_nomarc
       from aqpa210 a
       WHERE A.AQPA210PJPAIS=P_N_AQPA210PJPAIS
       AND A.AQPA210PJTDOC=P_N_AQPA210PJTDOC
       AND A.AQPA210PJNDOC=rpad(P_C_AQPA210PJNDOC,12);
    Exception
    When Others then
      P_N_CODERROR := 1;
      P_C_MENSAJE :='No se encontro registro';
      return;
    End;
    -- define output directory
    l_output := utl_file.fopen(P_C_NOMREP, lv_nomarc,'wb', 32760);


    -- save blob length
    x := len;

    -- if small enough for a single write
    If len < 32760 then
      utl_file.put_raw(l_output,vblob);
      utl_file.fflush(l_output);
    Else -- write in pieces
        vstart := 1;
        While vstart < len and bytelen > 0
        Loop
           dbms_lob.read(vblob,bytelen,vstart,my_vr);

           utl_file.put_raw(l_output,my_vr);
           utl_file.fflush(l_output);

           -- set the start position for the next cut
           vstart := vstart + bytelen;

           -- set the end position if less than 32000 bytes
           x := x - bytelen;
           If x < 32000 Then
              bytelen := x;
           End If;
        End Loop;
        utl_file.fclose(l_output);
    End If;

Exception
when others then
      P_N_CODERROR := 2;
      P_C_MENSAJE := 'No se recupero archivo';
end SP_AH_RECUPERA_PDF;

procedure SP_AH_INSERT_AQPA210(
                                             P_N_AQPA210PJPAIS IN number,
                                             P_N_AQPA210PJTDOC IN number,
                                             P_C_AQPA210PJNDOC IN varchar2,
                                             P_N_AQPA210CTNRO IN number,
                                             P_C_AQPA210SUCURS IN number,
                                             P_C_AQPA210USU IN varchar2,
                                             P_C_NOMARC IN varchar2,
                                             P_C_AQPA210HOR IN varchar2,
                                             P_D_AQPA210FEC IN DATE,
                                             P_C_AQPA210AX8 IN VARCHAR2,
                                             P_C_MENSAJE OUT VARCHAR2,
                                             P_N_CODERROR OUT number)
    -- *****************************************************************
    -- Nombre                     : SP_AH_INSERT_AQPA210
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros
    -- Versión                    : 1.0
    -- Fecha de Creación          :
    -- Autor de Creación          : JUAN APAZA
    -- Uso                        :
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
as
l_bfile BFILE;
l_blob BLOB;
lv_nomrep VARCHAR2(30);

BEGIN
--obtenemos repositorio
    begin
      select trim(a.tp1desc)
        into lv_nomrep
        from fst198 a
       Where a.Tp1cod   = 1
         and a.Tp1cod1  = 10825
         and a.Tp1corr1 = 61
         and a.Tp1corr2 = 6
         and a.tp1corr3 = 3; --repositorio
    exception
    when others then
      P_C_MENSAJE := 'No se encontro Repositorio';
      P_N_CODERROR:=1;
    end;

      insert into AQPA210(AQPA210PJPAIS,
                          AQPA210PJTDOC,
                          AQPA210PJNDOC,
                          AQPA210CTNRO,
                          AQPA210SUCURS,
                          AQPA210USU,
                          AQPA210PDF,
                          AQPA210AX7,
                          AQPA210HOR,
                          AQPA210FEC,
                          AQPA210AX8
                          )
                   values(P_N_AQPA210PJPAIS,
                          P_N_AQPA210PJTDOC,
                          P_C_AQPA210PJNDOC,
                          P_N_AQPA210CTNRO,
                          P_C_AQPA210SUCURS,
                          P_C_AQPA210USU,
                          EMPTY_BLOB(),
                          P_C_NOMARC,
                          P_C_AQPA210HOR,
                          P_D_AQPA210FEC,
                          P_C_AQPA210AX8
                          )

        RETURN AQPA210PDF INTO l_blob;
        l_bfile := BFILENAME(lv_nomrep, P_C_NOMARC);
        DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
        DBMS_LOB.loadfromfile(l_blob,l_bfile,DBMS_LOB.getlength(l_bfile));
        DBMS_LOB.fileclose(l_bfile);
        COMMIT;
end SP_AH_INSERT_AQPA210;

procedure SP_AH_ELIMINA_CARACTER(
                                             P_C_PJRAZS IN varchar2,
                                             P_C_PJRAZSOUT OUT VARCHAR2)

    -- *****************************************************************
    -- Nombre                     : SP_AH_ELIMINA_CARACTER
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros
    -- Versión                    : 1.0
    -- Fecha de Creación          :
    -- Autor de Creación          : JUAN APAZA
    -- Uso                        :
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
as
l_pjrazs varchar2(70);
BEGIN
l_pjrazs:= REGEXP_REPLACE(P_C_PJRAZS, '[^A-Za-z0-9ÁÉÍÓÚáéíóú ]', '');
P_C_PJRAZSOUT:=l_pjrazs;
end SP_AH_ELIMINA_CARACTER;
end PQ_AH_CONVENIO_MARCO;
/

