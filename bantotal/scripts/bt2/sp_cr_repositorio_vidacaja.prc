create or replace procedure Sp_CR_Repositorio_VidaCaja(p_ins in number,
                                                       p_c_nomarc out varchar2,
                                                       p_c_coderr out varchar2,
                                                       p_c_deserr out varchar2 ) is

 -- **********************************************************************************************************
 -- Nombre                     : PROCESO QUE CREA EL PDF DE VIDA CAJA EN EL REPOSITORIO DE EXTRACTOS DIGITALES
 -- Sistema                    : BANTOTAL
 -- Módulo                     : Créditos - Activas
 -- Versión                    : 1.0
 -- Fecha de Creación          : 2023.11.13
 -- Autor de Creación          : SILVIA MARQUEZ
 -- Uso                        : Desembolso digital
 -- Estado                     : Activo
 -- Acceso                     : Público
 -- Parámetros de Entrada      :
 -- **********************************************************************************************************
              
  cursor c_archivos is
     select dbms_lob.getlength(b.jaqm84arc) len_jaqm84arc,  
            b.jaqm84arc  jaqm84arc,
            a.jaqm89nom  jaqm89nom,
            a.jaqm89cta cuenta1,
            a.jaqm89ope oper1
       from jaqm89 a, jaqm84 b 
      where a.jaqm89ins = p_ins    
        and b.jaqm84cod = a.jaqm89cor;
          
         
         
  vblob BLOB;
  vstart NUMBER := 1;
  bytelen NUMBER := 32000;
  len NUMBER;
  my_vr RAW(32000);
  x NUMBER;
  l_output utl_file.file_type;   
  lv_nomarc      varchar2(30);  
  lv_nomrep      varchar2(30);   
  ln_cont        number(9):=0;        
  cuenta         number(9):= 0;
  oper           number(9):= 0;            
  begin                    
    p_c_coderr := '000';
    p_c_deserr := '';   
    vstart  := 1;
    bytelen := 32000;
    ln_cont := 0;
    for i in c_archivos loop
      ln_cont   := ln_cont + 1;
      len       := i.len_jaqm84arc;
      vblob     := i.jaqm84arc;
      lv_nomarc := i.jaqm89nom;
      cuenta    := i.cuenta1;
      oper      := i.oper1;
      exit;           
    End loop;
    if ln_cont = 0 then
      lv_nomarc  := null;
      p_c_nomarc := lv_nomarc;
      p_c_coderr := '006';
      p_c_deserr := 'No existe archivo a descargar';        
      return;    
    else    
        p_c_nomarc := lv_nomarc;                     
       --obtenemos repositorio
        begin
          select trim(a.tp1desc)
            into lv_nomrep 
            from fst198 a
           Where a.Tp1cod   = 1
             and a.Tp1cod1  = 10825
             and a.Tp1corr1 = 84
             and a.Tp1corr2 = 11
             and a.tp1corr3 = 4 ; --repositorio  ---estracto/digitales
        exception
        when others then
          lv_nomrep := '';
        end;            
    End if;  
  
    -- define output directory
    begin
       lv_nomarc := 'PVC'||lpad(cuenta,9,'0')||'000'||lpad(oper,9,'0')||'.pdf';
       l_output := utl_file.fopen(lv_nomrep, lv_nomarc,'wb', 32760);
    exception
    when others then
       p_c_coderr := '0XX';
       p_c_deserr := 'NO EXISTE EL ARCHIVO';        
       return;
    end;

 
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
       p_c_coderr := sqlcode;
       p_c_deserr := sqlerrm;    
    
end Sp_CR_Repositorio_VidaCaja;
/

