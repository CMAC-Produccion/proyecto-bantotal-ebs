create or replace procedure SP_AH_UPDUSUARIO(P_USUARIO IN VARCHAR,
                                             P_CUENTA  IN NUMBER,
                                             P_OPCION  IN VARCHAR) is
 newuser char(10);                 
 usuario char(10);                            
begin
  usuario := trim(p_usuario);
  newuser := replace(p_usuario,substr(p_usuario,1,1),'#');
  if trim(P_opcion) ='Antes' Then
    /*update fst056
       set UBUSER = newuser
     where pgcod  = 1
       and ubuser = usuario
       and ctnro  = p_cuenta;*/
      delete fst056
     where pgcod  = 1
       and ubuser = usuario
       and ctnro  = p_cuenta;         
     commit;  
  end if;

  if trim(p_opcion) ='Despues' Then      
     /*Update fst056
        set UBUSER = USUARIO
      where pgcod  = 1   
        and ctnro  = p_cuenta
        and ubuser = newuser; ---instr(ubuser,'#') = 1;*/
     insert into fst056(pgcod,
                        ubuser,
                        ctnro)
                 values(1,
                        usuario,
                        p_cuenta);
     commit;
  end if;
  
end SP_AH_UPDUSUARIO;
/

