create or replace procedure SP_AH_INSFIRABM(p_cod      in number,
                                            p_coddoc   in number,
                                            p_frente   in number, 
                                            p_nrofir   in number,
                                            p_fecha    in date,
                                            p_hora     in varchar2,
                                            p_usuario  in varchar2,
                                            p_pais     in number,
                                            p_tdoc     in number,
                                            p_ndoc     in varchar2,
                                            p_nombre   in varchar2, 
                                            p_ccargo   in number,                                             
                                            p_nomarch  in varchar2,
                                            p_ruta     in varchar2,
                                            p_posicion IN number,
                                            p_fechapro in date,
                                            p_motivo   in varchar2,
                                            p_flag     out varchar2) is
                                            
   cursor cargos is
     select * 
       from jaqz585 
      where jaqz585cod = p_cod
        and jaqz585codigo = p_coddoc
        and jaqz585frente = p_frente
        order by jaqz585cc1;
                                             
Existe number := 0;                                            
Existe1 number := 0; 
                                      
contador number :=0;
contador1 number :=0;
pais number;
tdoc number;
ndoc varchar2(12);
nombre varchar2(60);
cargo number;
nomarch varchar2(40);
ruta varchar2(40);

begin
 
 --- Graba datos de la Nuevo registro en estado H con fecha a Futuro jaqz58
  Begin
    select 1, jaqz584cod 
      into Existe, contador1
      from jaqz584
     where jaqz584codigo  = p_coddoc               
       and jaqz584est = 'H'
       and jaqz584nivel = p_frente;
  exception               
    when no_data_found then
      Existe := 0;  
  End;
  If Existe = 1 then
       update jaqz584
           set jaqz584fecini = p_fechapro,
               jaqz584usu    = p_usuario
         where jaqz584codigo  = p_coddoc               
           and jaqz584est = 'H'
           and jaqz584nivel = p_frente;
           
      -- Verificacion JAQZ586     
      Begin 
        Select 1
          into Existe1
          from jaqz586
         where jaqz586cod = contador1
           and jaqz586coddoc = p_coddoc
           and jaqz586frente = p_frente
           and jaqz586au1 = p_posicion;
        
        update jaqz586
           set jaqz586fech   = p_fecha,
               jaqz586hora   = p_hora,
               jaqz586usu    = p_usuario,
               jaqz586pais   = p_pais,
               jaqz586tdoc   = p_tdoc,
               jaqz586ndoc   = p_ndoc,
               jaqz586nom    = p_nombre,
               jaqz586ccargo = p_ccargo,
               jaqz586nomarc = p_nomarch,
               jaqz586ruta   = p_ruta
         where jaqz586cod = contador1
           and jaqz586coddoc = p_coddoc
           and jaqz586frente = p_frente
           and jaqz586au1 = p_posicion;
      Exception
        when no_data_found then
           --- Registro del Codigo en la tabla jaqz586           
            Begin 
                insert into jaqz586(jaqz586cod, 
                                    jaqz586coddoc, 
                                    jaqz586frente, 
                                    jaqz586au1, 
                                    jaqz586nrofir, 
                                    jaqz586fech, 
                                    jaqz586hora, 
                                    jaqz586usu, 
                                    jaqz586pais, 
                                    jaqz586tdoc, 
                                    jaqz586ndoc, 
                                    jaqz586nom, 
                                    jaqz586ccargo, 
                                    jaqz586nomarc, 
                                    jaqz586ruta)
                            values( contador1,
                                    p_coddoc,
                                    p_frente,
                                    p_posicion,
                                    p_nrofir,
                                    p_fecha,
                                    p_hora,
                                    p_usuario,
                                    p_pais,
                                    p_tdoc,
                                    p_ndoc,
                                    p_nombre,
                                    p_ccargo,
                                    p_nomarch,
                                    p_ruta);                          
               commit;                            
            Exception 
              when dup_val_on_index then
                null;
            End;          
      End; 
      Begin -- verificacion JAQZ586H
        select jaqz586paish,
               jaqz586tdoch ,
               jaqz586ndoch,
               jaqz586nomh, 
               jaqz586ccargoh,
               jaqz586nomarch,
               jaqz586rutah
          into pais,
               tdoc,
               ndoc,
               nombre,
               cargo,
               nomarch,
               ruta
          from jaqz586h
         where jaqz586cod584  = contador1
           and jaqz586coddoch = p_coddoc
           and jaqz586frenteh = p_frente
           and jaqz586posih  = p_posicion;
           
        update jaqz586h        
           set jaqz586fechh = p_fecha,
               jaqz586horah = p_hora,
               jaqz586usuh = p_usuario,
               jaqz586fecha = p_fechapro,
               jaqz586paish = pais,
               jaqz586tdoch = tdoc,
               jaqz586ndoch = ndoc,
               jaqz586nomh = nombre,
               jaqz586ccargoh = cargo,
               jaqz586nomarch = nomarch,
               jaqz586rutah = ruta,
               jaqz586paisa = p_pais,
               jaqz586tdoca = p_tdoc,
               jaqz586ndoca = p_ndoc,
               jaqz586noma = p_nombre,
               jaqz586ccargoa = p_ccargo,
               jaqz586nomarcha = p_nomarch,
               jaqz586rutaa = p_ruta,
               jaqz586moth  = p_motivo           
         where jaqz586cod584  = contador1
           and jaqz586coddoch = p_coddoc
           and jaqz586frenteh = p_frente
           and jaqz586posih = p_posicion;
        commit;                  
      Exception
        when no_data_found then
        ---- Graba histosrico
        Begin 
          Select NVL(Max(jaqz586codh),0) +  1
            into contador
            from jaqz586h;
          insert into jaqz586h(jaqz586codh, 
                               jaqz586coddoch, 
                               jaqz586frenteh, 
                               jaqz586nrofirh, 
                               jaqz586posih, 
                               jaqz586fechh, 
                               jaqz586horah, 
                               jaqz586usuh,                          
                               jaqz586fecha,                          
                               jaqz586paish, 
                               jaqz586tdoch, 
                               jaqz586ndoch, 
                               jaqz586nomh, 
                               jaqz586ccargoh, 
                               jaqz586nomarch, 
                               jaqz586rutah, 
                               jaqz586paisa, 
                               jaqz586tdoca, 
                               jaqz586ndoca, 
                               jaqz586noma, 
                               jaqz586ccargoa, 
                               jaqz586nomarcha, 
                               jaqz586rutaa, 
                               jaqz586moth,
                               jaqz586cod584)
                         Select contador,
                                p_coddoc,
                                p_frente, 
                                p_nrofir,
                                p_posicion,
                                p_fecha,
                                p_hora,
                                p_usuario,
                                p_fechapro,
                                jaqz586pais, 
                                jaqz586tdoc, 
                                jaqz586ndoc, 
                                jaqz586nom, 
                                jaqz586ccargo, 
                                jaqz586nomarc, 
                                jaqz586ruta, 
                                p_pais,
                                p_tdoc,
                                p_ndoc,
                                p_nombre, 
                                p_ccargo,                                             
                                p_nomarch,
                                p_ruta,          
                                p_motivo,
                                contador1
                           from jaqz586
                          where JAQZ586COD    = p_cod
                            and JAQZ586CODDOC = p_coddoc
                            and jaqz586frente = p_frente
                            and jaqz586au1    = p_posicion;
              commit;
        Exception
          when dup_val_on_index then
            null;
        End;
      End;    
  Else 
      Begin    
        Select NVL(Max(jaqz584cod),0) +  1
          into contador1
          from jaqz584;                   
          insert into jaqz584(jaqz584cod,         
                              jaqz584codigo, 
                              jaqz584fecini, 
                              jaqz584codide , 
                              jaqz584nivel,
                              jaqz584des, 
                              jaqz584cant,
                              jaqz584USU,
                              jaqz584EST,
                              jaqz584au5)
                       select contador1,
                              p_coddoc,
                              p_fechapro,
                              jaqz584codide,
                              p_frente,
                              jaqz584des,
                              p_nrofir,
                              p_usuario,
                              'H',
                              p_fecha  
                         from jaqz584
                        where jaqz584cod = p_cod
                          and jaqz584codigo = p_coddoc  ;   
               -- registra Cargos           
               For reg in cargos loop
                 Begin
                  insert into jaqz585(jaqz585cod, 
                                      jaqz585codigo, 
                                      jaqz585frente, 
                                      jaqz585cc1, 
                                      jaqz585des1)
                               values(contador1,
                                      reg.jaqz585codigo,
                                      reg.jaqz585frente,
                                      reg.jaqz585cc1,
                                      reg.jaqz585des1
                                      );
                 exception
                   when dup_val_on_index then
                     null;
                 end; 
               end loop;                
               COMMIT;
        EXCEPTION
          WHEN dup_val_on_index THEN
            NULL;
        END;             
    --- Registro del Codigo en la tabla jaqz586           
    Begin 
        insert into jaqz586(jaqz586cod, 
                            jaqz586coddoc, 
                            jaqz586frente, 
                            jaqz586au1, 
                            jaqz586nrofir, 
                            jaqz586fech, 
                            jaqz586hora, 
                            jaqz586usu, 
                            jaqz586pais, 
                            jaqz586tdoc, 
                            jaqz586ndoc, 
                            jaqz586nom, 
                            jaqz586ccargo, 
                            jaqz586nomarc, 
                            jaqz586ruta)
                    values( contador1,
                            p_coddoc,
                            p_frente,
                            p_posicion,
                            p_nrofir,
                            p_fecha,
                            p_hora,
                            p_usuario,
                            p_pais,
                            p_tdoc,
                            p_ndoc,
                            p_nombre,
                            p_ccargo,
                            p_nomarch,
                            p_ruta);                          
       commit;                            
    Exception 
      when dup_val_on_index then
        null;
    End;
     ---- Graba histosrico
  Begin 
    Select NVL(Max(jaqz586codh),0) +  1
      into contador
      from jaqz586h;
    insert into jaqz586h(jaqz586codh, 
                         jaqz586coddoch, 
                         jaqz586frenteh, 
                         jaqz586nrofirh, 
                         jaqz586posih, 
                         jaqz586fechh, 
                         jaqz586horah, 
                         jaqz586usuh,                          
                         jaqz586fecha,                          
                         jaqz586paish, 
                         jaqz586tdoch, 
                         jaqz586ndoch, 
                         jaqz586nomh, 
                         jaqz586ccargoh, 
                         jaqz586nomarch, 
                         jaqz586rutah, 
                         jaqz586paisa, 
                         jaqz586tdoca, 
                         jaqz586ndoca, 
                         jaqz586noma, 
                         jaqz586ccargoa, 
                         jaqz586nomarcha, 
                         jaqz586rutaa, 
                         jaqz586moth,
                         jaqz586cod584)
                   Select contador,
                          p_coddoc,
                          p_frente, 
                          p_nrofir,
                          p_posicion,
                          p_fecha,
                          p_hora,
                          p_usuario,
                          p_fechapro,
                          jaqz586pais, 
                          jaqz586tdoc, 
                          jaqz586ndoc, 
                          jaqz586nom, 
                          jaqz586ccargo, 
                          jaqz586nomarc, 
                          jaqz586ruta, 
                          p_pais,
                          p_tdoc,
                          p_ndoc,
                          p_nombre, 
                          p_ccargo,                                             
                          p_nomarch,
                          p_ruta,          
                          p_motivo,
                          contador1
                     from jaqz586
                    where JAQZ586COD    = p_cod
                      and JAQZ586CODDOC = p_coddoc
                      and jaqz586frente = p_frente
                      and jaqz586au1    = p_posicion;
        commit;
        Exception
          when dup_val_on_index then
            null;
        End;
   end if;
   
    p_flag := 'S';
end SP_AH_INSFIRABM;
/

