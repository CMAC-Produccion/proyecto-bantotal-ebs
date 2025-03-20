create or replace package pq_pc_requerimientos is

  -- Author  : DRODRIGUEE
  -- Created : 21/08/2020
                                                               
  Procedure sp_pc_registra_formato(pv_codreq in varchar2,
                                   pv_nomarc in varchar2,
                                   pv_desarc in varchar2,
                                   pv_codusu in varchar2,
                                   pc_rescod out varchar2,
                                   pc_resmsj out varchar2
                                  );
                                                                  
  Procedure sp_cl_descarga_datos(pc_codreq in varchar2,
                                 pn_nroarc in varchar2,
                                 pc_nomarc out varchar2,
                                 pc_coderr out varchar2,
                                 pc_deserr out varchar2                         
                                ); 

end pq_pc_requerimientos;
/

create or replace package body pq_pc_requerimientos is
 
  Procedure sp_pc_registra_formato(pv_codreq in varchar2,
                                   pv_nomarc in varchar2,
                                   pv_desarc in varchar2,
                                   pv_codusu in varchar2,
                                   pc_rescod out varchar2,
                                   pc_resmsj out varchar2
                                  )
  is  
  l_bfile    BFILE;
  l_blob     BLOB;
  lv_nomrep  varchar2(30);        
  --lc_dato    char(100);    
  --ln_correl  number(9);     
  --lc_estado  varchar2(1);                 
  begin

    begin
      select trim(a.tp1desc)
        into lv_nomrep 
        from fst198 a
       Where a.Tp1cod = 1
         and a.Tp1cod1 = 10825
         and a.Tp1corr1 = 61
         and a.Tp1corr2 = 6
         and a.tp1corr3 = 3; --repositorio  
    exception
    when others then
      lv_nomrep := '';
    end;
      
      insert into jaqz147
      (jaqz147cod,
       jaqz147nro,
       jaqz147des,
       jaqz147usu,
       jaqz147nom,
       jaqz147arc
      )
      values
      (pv_codreq,
       (select count(*)+1 from jaqz147 d where d.jaqz147cod = pv_codreq),
       pv_desarc,
       pv_codusu,
       pv_nomarc,
       EMPTY_BLOB()
      )
      return jaqz147arc into l_blob;                          
                          
      l_bfile := BFILENAME(lv_nomrep, pv_nomarc);
      DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
      DBMS_LOB.loadfromfile(l_blob,l_bfile,DBMS_LOB.getlength(l_bfile));
      DBMS_LOB.fileclose(l_bfile);
        
      pc_rescod := '000';
      pc_resmsj := '';
      
      commit;
        
  exception    
  when others then
    pc_rescod := sqlcode;
    pc_resmsj := 'Error en registro: '||trim(sqlerrm);       
    rollback;
  end;      
  
  Procedure sp_cl_descarga_datos(pc_codreq in varchar2,
                                 pn_nroarc in varchar2,
                                 pc_nomarc out varchar2,
                                 pc_coderr out varchar2,
                                 pc_deserr out varchar2                         
                                ) is                
  cursor c_archivos is
      select
      dbms_lob.getlength(a.jaqz147arc) len_jaqz147arc, 
      a.jaqz147arc jaqz147arc,
      trim(a.jaqz147nom) jaqz147nom
      from jaqz147 a
      where a.jaqz147cod = pc_codreq
      and a.jaqz147nro = pn_nroarc;
         
  vblob BLOB;
  vstart number := 1;
  bytelen number := 32000;
  len number;
  my_vr RAW(32000);
  x number;
  l_output utl_file.file_type;   
  lv_nomarc varchar2(30);  
  lv_tiparc varchar2(1);
  lv_nomprg varchar2(10);  
  lv_nomrep varchar2(30);   
  ln_cont number(9):=0;
                      
  begin                    
    pc_coderr := '000';
    pc_deserr := '';   
    vstart  := 1;
    bytelen := 32000;
    ln_cont := 0;
                   
    --MAPEO DE NOMBRE UNICOS PARA LOS ARCHIVOS - YLOZADA 17/08/2021
        lv_tiparc := 'D';
        lv_nomprg := 'HJAQY290_R';
        lv_nomarc := '';
        sp_ah_gen_cor_arch(p_c_tiparc => lv_tiparc,
                           p_c_nomprg => lv_nomprg,
                           p_c_nomarc => lv_nomarc
                           );    
                           
      begin
      update jaqz147 a
         set a.jaqz147nom = lv_nomarc
       where a.jaqz147cod = pc_codreq
         and a.jaqz147nro = pn_nroarc;
      commit;
      Exception
      When Others then
        pc_coderr := '0X1';
        pc_deserr := 'No se pudo actualizar nombre de archivo a descargar';
        return;
      End;
                               
    --FIN MAPEO NOMBRES - YLOZADA 17/08/2021       
    for i in c_archivos loop
      ln_cont   := ln_cont + 1;
      len       := i.len_jaqz147arc;
      vblob     := i.jaqz147arc;
      lv_nomarc := i.jaqz147nom;
      exit;           
    End loop;
    if ln_cont = 0 then
      lv_nomarc  := null;
      pc_nomarc := lv_nomarc;
      pc_coderr := '006';
      pc_deserr := 'No existe archivo a descargar';        
      return;    
    else    
        pc_nomarc := lv_nomarc;                     
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
          lv_nomrep := '';
        end;            
    End if;  
  
    -- define output directory
    begin
       l_output := utl_file.fopen(lv_nomrep, lv_nomarc,'wb', 32760);
    exception
    when others then
       pc_coderr := '0XX';
       pc_deserr := 'NO EXISTE EL ARCHIVO';        
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
    pc_coderr := sqlcode;
    pc_deserr := sqlerrm;    
  end sp_cl_descarga_datos; 
 
end pq_pc_requerimientos;
/

