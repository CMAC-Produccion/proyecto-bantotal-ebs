create or replace package PQ_CL_DATOS_PERSONALES is

   -- *****************************************************************
    -- Nombre                     : SP_AH_CONCEL
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 06/11/2019
    -- Autor de Creación          : Yrving Lozada Bustamante
    -- Uso                        : Registro de datos personales
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificación      : 27/05/2024
    -- Autor de la Modificación   : Yrving Lozada
    -- Descripción de Modificación: Se modificó renvio de correo en proceso sp_ah_enviomail
    -- *****************************************************************   
  Procedure sp_cl_genera_formato(P_N_CODPAI IN NUMBER,
                                 P_N_TIPDOC IN NUMBER, 
                                 P_C_NUMDOC IN VARCHAR2,
                                 p_c_indgen out varchar2            
                                );
  Procedure sp_cl_genera_formato1(P_N_CODPAI IN NUMBER,
                                  P_N_TIPDOC IN NUMBER, 
                                  P_C_NUMDOC IN VARCHAR2,
                                  P_C_CUENTA IN VARCHAR2,
                                  p_c_indgen out varchar2            
                                 );                                
  Procedure sp_cl_registra_formato(P_N_CODPAI IN NUMBER,
                                   P_N_TIPDOC IN NUMBER, 
                                   P_C_NUMDOC IN VARCHAR2,
                                   P_C_CODEST IN VARCHAR2,
                                   P_D_FECPRO IN DATE,
                                   P_C_CODUSR IN VARCHAR2,
                                   P_N_CODAGE IN NUMBER,
                                   P_C_CODTIP IN VARCHAR2,
                                   P_C_CODDAT IN VARCHAR2,
                                   P_C_CODFOR IN VARCHAR2,
                                   P_C_NOMARC IN VARCHAR2,
                                   p_c_coderr out varchar2,            
                                   p_c_msgerr out varchar2            
                                  );                                
  Procedure sp_ah_enviomail(P_N_CODPAI IN NUMBER,
                            P_N_TIPDOC IN NUMBER,
                            P_C_NUMDOC IN VARCHAR2,                            
                            P_C_CORREO IN VARCHAR2,           
                            P_N_CELULA IN NUMBER,
                            P_D_FECPRO IN DATE,
                            P_C_HORPRO IN VARCHAR2,           
                            P_C_DESAGE IN VARCHAR2,           
                            p_c_coderr out varchar2,
                            p_c_deserr out varchar2                         
                           );
  Procedure sp_cl_valida_biometria(P_N_JAQM301EMP IN NUMBER, 
                                   P_N_JAQM301MOD IN NUMBER,  
                                   P_N_JAQM301SUC IN NUMBER,  
                                   P_N_JAQM301TRA IN NUMBER,  
                                   P_N_JAQM301REL IN NUMBER,  
                                   P_N_JAQM301ORD IN NUMBER,  
                                   P_N_JAQM301SOR IN NUMBER,  
                                   P_N_JAQM301FEC IN DATE, 
                                   P_N_CTANRO     IN NUMBER,     
                                   p_c_indgen out varchar2            
                                  ); 
  Procedure sp_cl_descarga_datos(P_N_CODPAI IN NUMBER,
                                 P_N_TIPDOC IN NUMBER, 
                                 P_C_NUMDOC IN VARCHAR2,    
                                 P_N_CORREL IN NUMBER, 
                                 p_c_nomarc out varchar2,                                                                   
                                 p_c_coderr out varchar2,
                                 p_c_deserr out varchar2                         
                                ); 
  Procedure sp_cl_carga_datos(P_N_CODPAI IN NUMBER,
                              P_N_TIPDOC IN NUMBER, 
                              P_C_NUMDOC IN VARCHAR2,   
                              P_N_CORREL IN NUMBER,   
                              P_C_NOMARC IN VARCHAR2,
                              p_c_coderr out varchar2,
                              p_c_deserr out varchar2                         
                             );                                                                                        
  Procedure sp_cl_edad_meses(P_D_FECINI IN DATE,
                             P_D_FECFIN IN DATE,
                             p_n_nummes out number
                             );   
  Procedure sp_cl_valida_biometria_AH(P_N_JAQM82EMP IN NUMBER, 
                                      P_N_JAQM82MOD IN NUMBER,  
                                      P_N_JAQM82SUC IN NUMBER,  
                                      P_N_JAQM82MDA IN NUMBER,  
                                      P_N_JAQM82PAP IN NUMBER,  
                                      P_N_JAQM82CTA IN NUMBER,  
                                      P_N_JAQM82OPE IN NUMBER,  
                                      P_N_JAQM82SBO IN NUMBER, 
                                      P_N_JAQM82TOP IN NUMBER,                                                                       
                                      P_N_JAQM82FEC IN DATE,    
                                      p_c_indgen out varchar2            
                                     ) ;                                                       
end PQ_CL_DATOS_PERSONALES;
/

create or replace package body PQ_CL_DATOS_PERSONALES is

  -- Private type declarations
  
  Procedure sp_cl_genera_formato(P_N_CODPAI IN NUMBER,
                                 P_N_TIPDOC IN NUMBER, 
                                 P_C_NUMDOC IN VARCHAR2,
                                 p_c_indgen out varchar2            
                                ) IS
  lv_estado char(1);  
  --lc_numdoc char(25);   
  --lc_tokem  char(250) := 'ERROR';                                
  begin
    Select a.aqpa106est
      into lv_estado
      from aqpa106 a
     where a.aqpa106pai = P_N_CODPAI
       and a.aqpa106tpo = P_N_TIPDOC
       and a.aqpa106num = rpad(P_C_NUMDOC,12,' ');
       
     Case
       WHEN lv_estado = 'A' THEN
         p_c_indgen := 'N';
                   
         /*
         --verificar si existe el archivo por contratación digital en la tabla jaqm472
         --si existe retornar N
         --si no existe retornar S         
         lc_numdoc := rpad(P_C_NUMDOC,25,' ');
         begin
           Select 'N'            
             into p_c_indgen
             from jaqm472 a 
            where a.jaqm472pai = P_N_CODPAI 
              and a.jaqm472tdo = P_N_TIPDOC 
              and a.jaqm472ndo = lc_numdoc
              and a.jaqm472tid = 5
              and a.jaqm472tok = lc_tokem
              and rownum <2;              
         exception
         when others then 
           begin
             Select 'S'            
               into p_c_indgen
               from jaqm472 a 
              where a.jaqm472pai = P_N_CODPAI 
                and a.jaqm472tdo = P_N_TIPDOC 
                and a.jaqm472ndo = lc_numdoc
                and a.jaqm472tid = 5
                and a.jaqm472tok <> lc_tokem
                and rownum <2;              
           exception
           when others then 
              p_c_indgen := 'N';     
           End;                         
         end;
         */
       WHEN lv_estado = 'R' THEN
         p_c_indgen := 'S';
       WHEN lv_estado = 'N' THEN
         p_c_indgen := 'N';
       ELSE
         p_c_indgen := 'S';
     End Case;       
  exception
  when others then
    p_c_indgen := 'S';
  end sp_cl_genera_formato;      
  Procedure sp_cl_genera_formato1(P_N_CODPAI IN NUMBER,
                                  P_N_TIPDOC IN NUMBER, 
                                  P_C_NUMDOC IN VARCHAR2,
                                  P_C_CUENTA IN VARCHAR2,
                                  p_c_indgen out varchar2            
                                ) IS
  lv_estado char(1);  
  --lc_numdoc char(25);   
  --lc_tokem  char(250) := 'ERROR';                                
  begin
    Select a.aqpa106est
      into lv_estado
      from aqpa106 a
     where a.aqpa106pai = P_N_CODPAI
       and a.aqpa106tpo = P_N_TIPDOC
       and a.aqpa106num = rpad(P_C_NUMDOC,12,' ');
       
     Case
       WHEN lv_estado = 'A' THEN                                     
         --verificar si dio la aprobación para ese producto
         --si existe retornar S
         --si no existe retornar N         
         begin
            Select a.aqpa106aest
              into lv_estado
              from aqpa106a a
             where a.aqpa106apai = P_N_CODPAI
               and a.aqpa106atpo = P_N_TIPDOC
               and a.aqpa106anum = rpad(P_C_NUMDOC,12,' ')
               and a.aqpa106adat = rpad(P_C_CUENTA,100,' ')
               and a.aqpa106aest  = 'A';          
           p_c_indgen := 'S';
         exception
         when others then 
           p_c_indgen := 'N';              
         end;
       WHEN lv_estado = 'R' THEN
         p_c_indgen := 'N';
       WHEN lv_estado = 'N' THEN
         p_c_indgen := 'N';
       ELSE
         p_c_indgen := 'N';
     End Case;       
  exception
  when others then
    p_c_indgen := 'N';
  end sp_cl_genera_formato1;   
  Procedure sp_cl_registra_formato(P_N_CODPAI IN NUMBER,
                                   P_N_TIPDOC IN NUMBER, 
                                   P_C_NUMDOC IN VARCHAR2,
                                   P_C_CODEST IN VARCHAR2,
                                   P_D_FECPRO IN DATE,
                                   P_C_CODUSR IN VARCHAR2,
                                   P_N_CODAGE IN NUMBER,
                                   P_C_CODTIP IN VARCHAR2,
                                   P_C_CODDAT IN VARCHAR2,
                                   P_C_CODFOR IN VARCHAR2,
                                   P_C_NOMARC IN VARCHAR2,
                                   p_c_coderr out varchar2,            
                                   p_c_msgerr out varchar2            
                                  ) IS  
  l_bfile    BFILE;
  l_blob     BLOB;
  lv_nomrep  varchar2(30);        
  lc_dato    char(100);    
  ln_correl  number(9);     
  lc_estado  varchar2(1);                 
  begin
    p_c_coderr := '000';
    --REGISTRAMOS EN EL MAESTRO
    begin
      insert into aqpa106(aqpa106pai,
                          aqpa106tpo,
                          aqpa106num,
                          aqpa106est,
                          aqpa106fue
                          )
                    values(P_N_CODPAI,
                           P_N_TIPDOC,
                           P_C_NUMDOC,
                           P_C_CODEST,
                           P_D_FECPRO
                           );
      p_c_coderr := '000';
      p_c_msgerr := '';                           
    exception    
    when dup_val_on_index then  
      if P_C_CODEST = 'S' then      
        begin
          Select x.aqpa106est
            into lc_estado
            from aqpa106 x
           where x.aqpa106pai = P_N_CODPAI
             and x.aqpa106tpo = P_N_TIPDOC
             and x.aqpa106num = rpad(P_C_NUMDOC, 12, ' '); --YLOZADA 21/02/2020              
        exception
        when others then
           lc_estado := null;        
        end;
        If lc_estado <> 'P' and lc_estado is not null then
          update aqpa106 a 
             set a.aqpa106est = P_C_CODEST, 
                 a.aqpa106fue = case
                                when a.aqpa106est <> P_C_CODEST then
                                  P_D_FECPRO
                                Else
                                  a.aqpa106fue
                               End   
           where a.aqpa106pai = P_N_CODPAI
             and a.aqpa106tpo = P_N_TIPDOC
             and a.aqpa106num = rpad(P_C_NUMDOC,12,' ');            
        End If;
     Else           
        update aqpa106 a 
           set a.aqpa106est = P_C_CODEST, 
               a.aqpa106fue = case
                              when a.aqpa106est <> P_C_CODEST then
                                P_D_FECPRO
                              Else
                                a.aqpa106fue
                             End   
         where a.aqpa106pai = P_N_CODPAI
           and a.aqpa106tpo = P_N_TIPDOC
           and a.aqpa106num = rpad(P_C_NUMDOC,12,' ');
     End if;           
    when others then
      p_c_coderr := sqlcode;
      p_c_msgerr := 'aqpa106-'||trim(sqlerrm);                  
    end;  
    --REGISTRAMOS EN EL DETALLE
    --OBTENEMOS EL ULTIMO PENDIENTE PARA ASOCIARLE EL ARCHIVO O RECHAZO
    if trim(P_C_CODDAT) is null and P_C_CODEST = 'A' then
      begin
          Select a.aqpa106adat
            into lc_dato
            from aqpa106a a
           where a.aqpa106apai = P_N_CODPAI
             and a.aqpa106atpo = P_N_TIPDOC
             and a.aqpa106anum = rpad(P_C_NUMDOC, 12, ' ')
             and a.aqpa106acor = (
                                  Select max(x.aqpa106acor)
                                    from aqpa106a x
                                   where x.aqpa106apai = P_N_CODPAI
                                     and x.aqpa106atpo = P_N_TIPDOC
                                     and x.aqpa106anum = rpad(P_C_NUMDOC, 12, ' ')
                                     and x.aqpa106aest = 'P'
                                  );       
      exception
      when others then
        lc_dato := null;    
        p_c_coderr := sqlcode;
        p_c_msgerr := 'No existe registro pendiente de asociar';               
        return;
      end;
    End If;
    if P_C_CODEST = 'A' and trim(P_C_NOMARC) is not null then
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
      begin
        insert into aqpa106a(aqpa106apai,
                             aqpa106atpo,
                             aqpa106anum,
                             aqpa106acor,
                             aqpa106atip,
                             aqpa106aest,
                             aqpa106afec,
                             aqpa106ahor,
                             aqpa106ausr,
                             aqpa106aage,
                             aqpa106adat,
                             aqpa106afor,
                             aqpa106anom,
                             aqpa106aarc
                            )
                      values(P_N_CODPAI,
                             P_N_TIPDOC,
                             P_C_NUMDOC,
                             SQ_AH_ID_DETDAT.NEXTVAL,
                             P_C_CODTIP,
                             P_C_CODEST, 
                             P_D_FECPRO, 
                             to_char(sysdate,'HH24:mi:ss'),
                             P_C_CODUSR, 
                             P_N_CODAGE,                             
                             decode(trim(P_C_CODDAT),null,lc_dato,P_C_CODDAT),
                             P_C_CODFOR,
                             P_C_NOMARC,
                             EMPTY_BLOB()
                             )
                            RETURN aqpa106aarc INTO l_blob;                          
                          
        l_bfile := BFILENAME(lv_nomrep, P_C_NOMARC);
        DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
        DBMS_LOB.loadfromfile(l_blob,l_bfile,DBMS_LOB.getlength(l_bfile));
        DBMS_LOB.fileclose(l_bfile);
        COMMIT;                                                
        p_c_coderr := '000';
        p_c_msgerr := '';
                             
      exception    
      when others then
        p_c_coderr := sqlcode;
        p_c_msgerr := 'aqpa106a-'||trim(sqlerrm);         
      end;      
    Else 
      if P_C_CODEST = 'S' then 
          --verificamos si ya existe el estado para el producto
          begin
            Select x.aqpa106acor
              into ln_correl
              from aqpa106a x 
             where x.aqpa106apai = P_N_CODPAI 
               and x.aqpa106atpo = P_N_TIPDOC
               and x.aqpa106anum = rpad(P_C_NUMDOC,12,' ')
               and x.aqpa106adat = rpad(P_C_CODDAT,100,' ')
               and x.aqpa106aest IN ('S','P');--= 'S'; --YLOZADA 21/02/2020              
          exception
          when others then
              --ln_correl := 0; 
              /* Se adicionó para controlar contratacion digital que pueda fallar*/
              begin
                Select x.aqpa106acor
                  into ln_correl
                  from aqpa106a x 
                 where x.aqpa106apai = P_N_CODPAI 
                   and x.aqpa106atpo = P_N_TIPDOC
                   and x.aqpa106anum = rpad(P_C_NUMDOC,12,' ')
                   and x.aqpa106adat = rpad(P_C_CODDAT,100,' ')
                   and x.aqpa106aest = 'A';               
              exception
              when others then
                   ln_correl := 0;
              end;  
              if ln_correl > 0 then
                update aqpa106a x 
                   set x.aqpa106aest = P_C_CODEST,
                       x.aqpa106afec = P_D_FECPRO,
                       x.aqpa106ahor = to_char(sysdate,'HH24:mi:ss'),
                       x.aqpa106ausr = P_C_CODUSR,
                       x.aqpa106aage = P_N_CODAGE
                 where x.aqpa106apai = P_N_CODPAI 
                   and x.aqpa106atpo = P_N_TIPDOC
                   and x.aqpa106anum = rpad(P_C_NUMDOC, 12, ' ')
                   and x.aqpa106acor = ln_correl;                 
              End if;   
              /*fin contratacion digital*/       
          end;
          if ln_correl = 0 then
              begin
                insert into aqpa106a(aqpa106apai,
                                     aqpa106atpo,
                                     aqpa106anum,
                                     aqpa106acor,
                                     aqpa106atip,
                                     aqpa106aest,
                                     aqpa106afec,
                                     aqpa106ahor,
                                     aqpa106ausr,
                                     aqpa106aage,
                                     aqpa106adat,
                                     aqpa106afor,
                                     aqpa106anom
                                    )
                              values(P_N_CODPAI,
                                     P_N_TIPDOC,
                                     P_C_NUMDOC,
                                     SQ_AH_ID_DETDAT.NEXTVAL,
                                     P_C_CODTIP,
                                     P_C_CODEST, 
                                     P_D_FECPRO, 
                                     to_char(sysdate,'HH24:mi:ss'),
                                     P_C_CODUSR, 
                                     P_N_CODAGE,                             
                                     decode(trim(P_C_CODDAT),null,lc_dato,P_C_CODDAT),
                                     P_C_CODFOR,
                                     P_C_NOMARC                     
                                     );
              exception    
              when others then
                p_c_coderr := sqlcode;
                p_c_msgerr := 'aqpa106a-'||trim(sqlerrm);         
              end;  
          End If;  
      End If;
      if P_C_CODEST = 'P' then     
          begin
            Select x.aqpa106acor
              into ln_correl
              from aqpa106a x 
             where x.aqpa106apai = P_N_CODPAI 
               and x.aqpa106atpo = P_N_TIPDOC
               and x.aqpa106anum = rpad(P_C_NUMDOC, 12, ' ')
               and x.aqpa106adat = rpad(P_C_CODDAT, 100, ' ')
               and x.aqpa106aest = 'S';               
          exception
          when no_data_found then
            ln_correl := -1;
            p_c_coderr := '00s';
            p_c_msgerr := 'No existe registro pendiente de asociar para el valor ingresado';               
            return;                     
          when others then
            ln_correl := 0;
            p_c_coderr := '00s';
            p_c_msgerr := 'Existe mas de un registro pendiente de asociar para el valor ingresado';               
            return;                     
          end;
          if ln_correl > 0 then --si existe actualizamos el estado
            update aqpa106a x 
               set x.aqpa106aest = P_C_CODEST,
                   x.aqpa106afec = P_D_FECPRO,
                   x.aqpa106ahor = to_char(sysdate,'HH24:mi:ss'),
                   x.aqpa106ausr = P_C_CODUSR,
                   x.aqpa106aage = P_N_CODAGE
             where x.aqpa106apai = P_N_CODPAI 
               and x.aqpa106atpo = P_N_TIPDOC
               and x.aqpa106anum = rpad(P_C_NUMDOC, 12, ' ')
               and x.aqpa106acor = ln_correl;  
          End if;
      Else
          IF P_C_CODEST NOT IN ('S','P') THEN
            begin
              insert into aqpa106a(aqpa106apai,
                                   aqpa106atpo,
                                   aqpa106anum,
                                   aqpa106acor,
                                   aqpa106atip,
                                   aqpa106aest,
                                   aqpa106afec,
                                   aqpa106ahor,
                                   aqpa106ausr,
                                   aqpa106aage,
                                   aqpa106adat,
                                   aqpa106afor,
                                   aqpa106anom
                                  )
                            values(P_N_CODPAI,
                                   P_N_TIPDOC,
                                   P_C_NUMDOC,
                                   SQ_AH_ID_DETDAT.NEXTVAL,
                                   P_C_CODTIP,
                                   P_C_CODEST, 
                                   P_D_FECPRO, 
                                   to_char(sysdate,'HH24:mi:ss'),
                                   P_C_CODUSR, 
                                   P_N_CODAGE,                             
                                   decode(trim(P_C_CODDAT),null,lc_dato,P_C_CODDAT),
                                   P_C_CODFOR,
                                   P_C_NOMARC                     
                                   );
            exception    
            when others then
              p_c_coderr := sqlcode;
              p_c_msgerr := 'aqpa106a-'||trim(sqlerrm);         
            end;
          END IF;          
      End if;        
    End if;
    commit;    
  exception
  when others then  
    p_c_coderr := sqlcode;
    p_c_msgerr := sqlerrm; 
  end ;                                  
  Procedure sp_ah_enviomail(P_N_CODPAI IN NUMBER,
                            P_N_TIPDOC IN NUMBER,
                            P_C_NUMDOC IN VARCHAR2,                            
                            P_C_CORREO IN VARCHAR2,           
                            P_N_CELULA IN NUMBER,
                            P_D_FECPRO IN DATE,
                            P_C_HORPRO IN VARCHAR2,           
                            P_C_DESAGE IN VARCHAR2,           
                            p_c_coderr out varchar2,
                            p_c_deserr out varchar2                         
                           ) is
    
  cursor c_datos is              
    select a.* 
      from fst198 a
     Where a.Tp1cod   = 1
       and a.Tp1cod1  = 10825
       and a.Tp1corr1 = 91
       and a.Tp1corr2 = 3; 
       
                  
    ll_mensaje    CLOB;
    lv_mensaje    VARCHAR2(32767);     
    lv_remitente  VARCHAR2(90);  
    lv_asunto     VARCHAR2(90);  
    lv_destinos   VARCHAR2(4000):='';          
    lv_contacto   VARCHAR2(120);       
    lv_correo     VARCHAR2(49);
    lv_celular    VARCHAR2(20);
  begin
    p_c_coderr := '000';       
    if trim(P_C_CORREO) is null then
       lv_correo := 'No Registra';
    Else
       lv_correo := trim(P_C_CORREO);  
    End If;
    
    if P_N_CELULA = 0 then
       lv_celular := 'No Registra';
    Else
       lv_celular := to_char(P_N_CELULA);
    End If;    
    --Obtenemos datos para el envio
    For i in c_datos loop
      Case
         When i.tp1nro1 = 1 then
           lv_remitente  := lv_remitente || trim(i.tp1desc);
         When i.tp1nro1 = 2 then
           lv_asunto     := lv_asunto || trim(i.tp1desc);
         Else
           null;
      End Case;                                      
    End Loop;
    
    begin
      Select trim(a.pfnom1)||' '||trim(a.pfnom2)||' '||trim(a.pfape1)||' '||trim(a.pfape2)
        into lv_contacto 
        from fsd002 a 
       where a.pfpais = P_N_CODPAI  
         and a.pftdoc = P_N_TIPDOC
         and a.pfndoc = rpad(P_C_NUMDOC,12,' ');
    Exception
    when others then  
      lv_contacto := null;
    end;
    lv_destinos := trim(P_C_CORREO);
    dbms_lob.createtemporary(ll_mensaje, TRUE);     

                lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Hola '||trim(lv_contacto)|| '</p>' ||
                              '<p "font-family: Arial, sans-serif; font-size: 14px;"> Gracias por actualizar tu informaci&oacute;n en Caja Arequipa</p>';            

              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);

              lv_mensaje := '
                            <table width="830" height="54" border="0">
                              <tbody>
                                <tr>
                                <td width="15" height="23">Correo electr&oacute;nico:</td>      
                                </tr>                                                  
                                <tr>
                                  <td width="15" height="23"><strong>'||lv_correo||'</strong></td>
                                </tr>
                                <tr>
                                <td width="15" height="23">Celular:</td>      
                                </tr>                                                  
                                <tr>
                                  <td width="15" height="23"><strong>'||lv_celular||'</strong></td>
                                </tr>    
                                                                
                                <tr>
                                  <td width="15" height="23">Fecha:'||to_char(P_D_FECPRO,'dd/mm/rrrr')||'</td>
                                </tr> 
                                <tr>
                                  <td width="15" height="23">Hora:'||P_C_HORPRO||'</td>
                                </tr> 
                                <tr>
                                  <td width="15" height="23">Agencia:'||P_C_DESAGE||'</td>
                                </tr>                                                               
                              </tbody>
                            </table>';               
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                                  
                                   
              lv_mensaje := 
              '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Cordialmente<br/>Caja Arequipa</strong></p>';                                          
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);         
                          
              begin
              -- Call the procedure
              pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                               p_destinatarioscc   => '',
                                               p_destinatariosbcc  => '',
                                               p_mensaje           => ll_mensaje,
                                               p_remitente         => lv_remitente,
                                               p_asunto            => lv_asunto,
                                               p_tipomensaje       => 'HTML',
                                               p_directorio        => '',
                                               p_archivosadjuntos  => '',
                                               p_c_coderr          => p_c_coderr,
                                               p_c_deserr          => p_c_deserr
                                               );
              exception                             
              when others then  
                PQ_CR_ENVIAR_CORREOS.sp_ah_reprocesa_mail(P_N_CODPRO => 4,--MAIL POR ACTUALIZACIÓN DE INFORMACIÓN
                                                          P_C_ASUNTO => lv_asunto,
                                                          P_C_DESPAR => lv_destinos,
                                                          P_C_DESCOC => '',
                                                          P_C_DESCCO => '',
                                                          P_C_MENSAJ => ll_mensaje,
                                                          P_C_REMITE => lv_remitente,
                                                          P_C_DIRECT => 'HTML',
                                                          P_C_ADJUNT => '',
                                                          P_N_AUX001 => null,
                                                          P_N_AUX002 => null,
                                                          P_N_AUX003 => null,
                                                          P_N_AUX004 => null,
                                                          P_D_AUX005 => null,
                                                          P_D_AUX006 => null,
                                                          P_C_AUX007 => null,
                                                          P_C_AUX008 => null,
                                                          P_C_AUX009 => null,
                                                          p_c_coderr => p_c_coderr,
                                                          p_c_msgerr => p_c_deserr
                                                          );                
              end;
              dbms_lob.freetemporary(ll_mensaje);                               
  Exception    
  when others then  
       p_c_coderr := sqlcode;
       p_c_deserr := sqlerrm;                                 
  end sp_ah_enviomail;                            
  Procedure sp_cl_valida_biometria(P_N_JAQM301EMP IN NUMBER, 
                                   P_N_JAQM301MOD IN NUMBER,  
                                   P_N_JAQM301SUC IN NUMBER,  
                                   P_N_JAQM301TRA IN NUMBER,  
                                   P_N_JAQM301REL IN NUMBER,  
                                   P_N_JAQM301ORD IN NUMBER,  
                                   P_N_JAQM301SOR IN NUMBER,  
                                   P_N_JAQM301FEC IN DATE, 
                                   P_N_CTANRO     IN NUMBER,     
                                   p_c_indgen out varchar2            
                                  ) IS
  cursor c_titulares is                                  
    Select a.* 
      from fsr008 a 
     where a.pgcod = P_N_JAQM301EMP 
       and a.ctnro = P_N_CTANRO
       and a.ttcod = 1;
       
  ln_pais     number(3);
  ln_tipdoc   number(2);        
  lc_numdoc   char(12);                        
  begin
    p_c_indgen := 'N';
    for i in c_titulares loop
      ln_pais     := i.pepais; 
      ln_tipdoc   := i.petdoc;
      lc_numdoc   := i.pendoc;
      begin
        Select 'S' 
          into p_c_indgen
          from JAQM301 a
         where a.jaqm301emp = P_N_JAQM301EMP 
           and a.jaqm301mod = P_N_JAQM301MOD
           and a.jaqm301suc = P_N_JAQM301SUC
           and a.jaqm301tra = P_N_JAQM301TRA
           and a.jaqm301rel = P_N_JAQM301REL
           and a.jaqm301ord = P_N_JAQM301ORD
           and a.jaqm301sor = P_N_JAQM301SOR
           and a.jaqm301pai = ln_pais
           and a.jaqm301tdo = ln_tipdoc
           and a.jaqm301ndo = lc_numdoc
           and a.jaqm301fec = P_N_JAQM301FEC
           and a.jaqm301hit = 'S'
           and rownum <2;
       exception
       when others then  
         p_c_indgen := 'N';
         exit;
       end;
     End loop;            
  exception
  when others then
    p_c_indgen := 'N';
  end sp_cl_valida_biometria;        
  Procedure sp_cl_descarga_datos(P_N_CODPAI IN NUMBER,
                                 P_N_TIPDOC IN NUMBER, 
                                 P_C_NUMDOC IN VARCHAR2,   
                                 P_N_CORREL IN NUMBER,   
                                 p_c_nomarc out varchar2,
                                 p_c_coderr out varchar2,
                                 p_c_deserr out varchar2                         
                                ) is                
  cursor c_archivos is
      Select dbms_lob.getlength(a.aqpa106aarc) len_aqpa106aarc, 
             a.aqpa106aarc aqpa106aarc,
             trim(a.aqpa106anom) aqpa106anom
        from aqpa106a a
       where a.aqpa106apai = P_N_CODPAI
         and a.aqpa106atpo = P_N_TIPDOC
         and a.aqpa106anum = rpad(P_C_NUMDOC,12,' ')
         and a.aqpa106aest = 'A'
         and a.aqpa106acor = P_N_CORREL;
         
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
  begin                    
    p_c_coderr := '000';
    p_c_deserr := '';   
    vstart  := 1;
    bytelen := 32000;
    ln_cont := 0;
    for i in c_archivos loop
      ln_cont   := ln_cont + 1;
      len       := i.len_aqpa106aarc;
      vblob     := i.aqpa106aarc;
      lv_nomarc := i.aqpa106anom;
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
  end sp_cl_descarga_datos;   
  Procedure sp_cl_carga_datos(P_N_CODPAI IN NUMBER,
                              P_N_TIPDOC IN NUMBER, 
                              P_C_NUMDOC IN VARCHAR2,   
                              P_N_CORREL IN NUMBER,   
                              P_C_NOMARC IN VARCHAR2,
                              p_c_coderr out varchar2,
                              p_c_deserr out varchar2                         
                             ) is 
  lv_aqpa106atip char(1);
  lv_aqpa106aest char(1);
  ld_aqpa106afec date;
  lv_aqpa106ahor char(8);
  lv_aqpa106ausr char(10);
  ln_aqpa106aage number(3);
  lv_aqpa106adat char(100);  
  lv_aqpa106afor char(30);  
  l_bfile    BFILE;
  l_blob     BLOB;
  lv_nomrep  varchar2(30);        
    
  begin                    
    p_c_coderr := '000';
    p_c_deserr := '';  
    
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
    begin
       Select a.aqpa106atip,
              a.aqpa106aest,
              a.aqpa106afec,
              a.aqpa106ahor,
              a.aqpa106ausr,
              a.aqpa106aage,
              a.aqpa106adat,
              a.aqpa106afor
         into lv_aqpa106atip,
              lv_aqpa106aest,
              ld_aqpa106afec,
              lv_aqpa106ahor,
              lv_aqpa106ausr,
              ln_aqpa106aage,
              lv_aqpa106adat,
              lv_aqpa106afor
         from aqpa106a a
        where a.aqpa106apai = P_N_CODPAI
          and a.aqpa106atpo = P_N_TIPDOC
          and a.aqpa106anum = rpad(P_C_NUMDOC, 12, ' ')
          and a.aqpa106aest = 'A'
          and a.aqpa106acor = P_N_CORREL;
    exception
    when others then      
       p_c_coderr := '001';
       p_c_deserr := sqlerrm;          
    end;
    if trim(lv_aqpa106afor) is null then
      begin
        Select trim(a.tp1desc)
          into lv_aqpa106afor
          from fst198 a 
         where a.tp1cod   = 1 
           and a.tp1cod1  = 10824 
           and a.tp1corr1 = 3;
      exception
      when others then
        lv_aqpa106afor := null;
      end;
    End If;  
    
    DELETE FROM aqpa106a a
     where a.aqpa106apai = P_N_CODPAI
       and a.aqpa106atpo = P_N_TIPDOC
       and a.aqpa106anum = rpad(P_C_NUMDOC, 12, ' ')
       and a.aqpa106aest = 'A'
       and a.aqpa106acor = P_N_CORREL;
       commit;
       
    begin
        insert into aqpa106a(aqpa106apai,
                             aqpa106atpo,
                             aqpa106anum,
                             aqpa106acor,
                             aqpa106atip,
                             aqpa106aest,
                             aqpa106afec,
                             aqpa106ahor,
                             aqpa106ausr,
                             aqpa106aage,
                             aqpa106adat,
                             aqpa106afor,
                             aqpa106anom,
                             aqpa106aarc
                            )
                      values(P_N_CODPAI,
                             P_N_TIPDOC,
                             P_C_NUMDOC,
                             P_N_CORREL,
                             lv_aqpa106atip,
                             lv_aqpa106aest,
                             ld_aqpa106afec,
                             lv_aqpa106ahor,
                             lv_aqpa106ausr,
                             ln_aqpa106aage,
                             lv_aqpa106adat,
                             lv_aqpa106afor,
                             'DAT'||TRIM(P_C_NUMDOC)||'.pdf',
                             EMPTY_BLOB()
                             )
                            RETURN aqpa106aarc INTO l_blob;                          
                          
        l_bfile := BFILENAME(lv_nomrep, P_C_NOMARC);
        DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
        DBMS_LOB.loadfromfile(l_blob,l_bfile,DBMS_LOB.getlength(l_bfile));
        DBMS_LOB.fileclose(l_bfile);
        COMMIT;                                                
        p_c_coderr := '000';
        p_c_deserr := '';
                             
      exception    
      when others then
        p_c_coderr := sqlcode;
        p_c_deserr := 'aqpa106a-'||trim(sqlerrm);         
      end;     
   
  Exception
  when others then  
       p_c_coderr := sqlcode;
       p_c_deserr := sqlerrm;    
  end sp_cl_carga_datos;  
  Procedure sp_cl_edad_meses(P_D_FECINI IN DATE,
                             P_D_FECFIN IN DATE,
                             p_n_nummes out number
                             ) is
  begin
    if to_char(P_D_FECINI,'dd/mm/rrrr') = '01/01/0001' then
      p_n_nummes := 0;
    else  
      p_n_nummes := trunc(months_between(P_D_FECFIN,P_D_FECINI),2);
      if p_n_nummes is null then
        p_n_nummes := 0;
      End If;
    End If;
  exception
  when others then  
    p_n_nummes := 0;
  end sp_cl_edad_meses;   
  Procedure sp_cl_valida_biometria_AH(P_N_JAQM82EMP IN NUMBER, 
                                      P_N_JAQM82MOD IN NUMBER,  
                                      P_N_JAQM82SUC IN NUMBER,  
                                      P_N_JAQM82MDA IN NUMBER,  
                                      P_N_JAQM82PAP IN NUMBER,  
                                      P_N_JAQM82CTA IN NUMBER,  
                                      P_N_JAQM82OPE IN NUMBER,  
                                      P_N_JAQM82SBO IN NUMBER, 
                                      P_N_JAQM82TOP IN NUMBER,                                                                       
                                      P_N_JAQM82FEC IN DATE,    
                                      p_c_indgen out varchar2            
                                     ) IS
  cursor c_titulares is                                  
    Select a.* 
      from fsr008 a 
     where a.pgcod = P_N_JAQM82EMP 
       and a.ctnro = P_N_JAQM82CTA
       and a.ttcod = Case
                     When P_N_JAQM82TOP <> 8 Then
                       1
                     else
                       2
                     end;
                            
  ln_pais     number(3);
  ln_tipdoc   number(2);        
  lc_numdoc   char(12);                        
  begin
    p_c_indgen := 'N';
    for i in c_titulares loop
      ln_pais     := i.pepais; 
      ln_tipdoc   := i.petdoc;
      lc_numdoc   := i.pendoc;
      begin
        Select 'S' 
          into p_c_indgen
          from JAQM82 a
         where a.JAQM82EMP = P_N_JAQM82EMP 
           and a.JAQM82MOD = P_N_JAQM82MOD 
           and a.JAQM82SUC = P_N_JAQM82SUC 
           and a.JAQM82MDA = P_N_JAQM82MDA 
           and a.JAQM82PAP = P_N_JAQM82PAP 
           and a.JAQM82CTA = P_N_JAQM82CTA 
           and a.JAQM82OPE = P_N_JAQM82OPE 
           and a.JAQM82SBO = P_N_JAQM82SBO 
           and a.JAQM82TOP = P_N_JAQM82TOP
           and a.JAQM82FEC = P_N_JAQM82FEC     
           and a.jaqm82pai = ln_pais
           and a.jaqm82tdo = ln_tipdoc
           and a.jaqm82ndo = lc_numdoc
           and a.jaqm82hit = 'S'
           and rownum <2;
       exception
       when others then  
         p_c_indgen := 'N';
         exit;
       end;
     End loop;            
  exception
  when others then
    p_c_indgen := 'N';
  end sp_cl_valida_biometria_AH;                                     
end PQ_CL_DATOS_PERSONALES;
/

