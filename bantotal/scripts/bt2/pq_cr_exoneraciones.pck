create or replace package PQ_CR_EXONERACIONES is

  -- Author  : MCANDIA
  -- Created : 16/07/2018 11:49:00 A.M
  -- Purpose : EXONERACIONES DE PAGO

  -- Public type declarations
  Procedure SP_CR_VER_USUARIO(usuario     in character,
                              Flag_existe out character);

  Procedure SP_CR_EXO_ITEM(ln_tp1nro1 in number,
                           ln_tp1nro2 in number,
                           ln_tp1nro3 in number,
                           ln_tp1imp1 in number,
                           ln_tp1imp2 in number,
                           ln_tp1imp3 in number,
                           usuario    in character);

end PQ_CR_EXONERACIONES;
/

create or replace package body PQ_CR_EXONERACIONES is

  procedure SP_CR_VER_USUARIO(Usuario character, Flag_existe out character) is
  
    ln_cont      number(10) := 0;
    ln_nivel     number(10);
    ln_tempnivel number(10);
    ln_nivelfin  number(10);
    ln_tp1nro1   number(9);
    ln_tp1nro2   number(9);
    ln_tp1nro3   number(9);
    ln_tp1imp1   number(17, 2);
    ln_tp1imp2   number(17, 2);
    ln_tp1imp3   number(17, 2);
    lc_flag      char(1) := 'N';
  
    cursor Perfiles is
      select prfu00.prfgcod
        from prfu00, fst198
       where prfu00.ubuser = Usuario
         and fst198.tp1cod = 1
         and fst198.tp1cod1 = 10999
         and fst198.tp1corr1 = 40
         and fst198.tp1desc = prfu00.prfgcod;
  
  begin
    
    IF (USUARIO != '' OR USUARIO IS NOT NULL) AND USUARIO != ' ' THEN --EFUENTES 2021-10-07 SE AGREGO
      --EXECUTE IMMEDIATE 'truncate table jaqz889';--EFUENTES 2021-10-07 SE COMENTO
      DELETE FROM JAQZ889 J WHERE J.JAQZ889USER = USUARIO; --EFUENTES 2021-10-07 SE AGREGO
      COMMIT;                                              --TAMBIEN SE BORRO LA PK DE TABLA
    
      for a in Perfiles loop
        ln_cont := ln_cont + 1;
      end loop;
      --dbms_output.put_line(ln_cont);
    
      begin
        lc_flag := 'N';
      
        for i in Perfiles loop
        
          select fst198.tp1corr3, 'S'
            into ln_nivel, lc_flag
            from fst198
           where fst198.tp1cod = 1
             and fst198.tp1cod1 = 10999
             and fst198.tp1corr1 = 40
             and fst198.tp1desc = i.prfgcod;
        
          if ln_cont > 1 then
            if ln_nivel < ln_tempnivel then
              ln_nivelfin := ln_nivel;
            else
              ln_nivelfin := ln_tempnivel;
            end if;
          else
            if ln_cont = 1 then
              ln_nivelfin := ln_nivel;
            end if;
          end if;
          ln_tempnivel := ln_nivel;
        end loop;
      
        if lc_flag = 'S' then
        
          select fst198.tp1nro1,
                 fst198.tp1nro2,
                 fst198.tp1nro3,
                 fst198.tp1imp1,
                 fst198.tp1imp2,
                 fst198.tp1imp3
            into ln_tp1nro1,
                 ln_tp1nro2,
                 ln_tp1nro3,
                 ln_tp1imp1,
                 ln_tp1imp2,
                 ln_tp1imp3
            from fst198
           where fst198.tp1cod = 1
             and fst198.tp1cod1 = 10999
             and fst198.tp1corr1 = 40
             and fst198.tp1corr3 = ln_nivelfin;
        
          PQ_CR_EXONERACIONES.SP_CR_EXO_ITEM(ln_tp1nro1,
                                             ln_tp1nro2,
                                             ln_tp1nro3,
                                             ln_tp1imp1,
                                             ln_tp1imp2,
                                             ln_tp1imp3,
                                             Usuario);
        else
        
          insert into jaqz889
            (JAQZ889CORR, JAQZ889USER, JAQZ889CODD, JAQZ889ITEM)
          values
            (1, Usuario, 1, 'ICV + (Mora o Penalidad)');
        
        end if;
      
        Flag_existe := lc_flag;
   
      exception
        when no_data_found then
          null;
      end;
    END IF;
  
  end SP_CR_VER_USUARIO;

  Procedure SP_CR_EXO_ITEM(ln_tp1nro1 in number,
                           ln_tp1nro2 in number,
                           ln_tp1nro3 in number,
                           ln_tp1imp1 in number,
                           ln_tp1imp2 in number,
                           ln_tp1imp3 in number,
                           usuario    in character) is
  
    ln_corr number(10) := 0;
  
    cursor Item is
      select fst198.tp1desc, fst198.tp1corr3
        from fst198
       where fst198.tp1cod = 1
         and fst198.tp1cod1 = 10999
         and fst198.tp1corr1 = 30
         and fst198.tp1corr3 in (ln_tp1nro1,
                                 ln_tp1nro2,
                                 ln_tp1nro3,
                                 ln_tp1imp1,
                                 ln_tp1imp2,
                                 ln_tp1imp3);
  
  begin
  
    for p in Item loop
      ln_corr := ln_corr + 1;
    
      insert into jaqz889
        (JAQZ889CORR, JAQZ889USER, JAQZ889CODD, JAQZ889ITEM)
      values
        (ln_corr, usuario, p.tp1corr3, p.tp1desc);
    end loop;
    commit;
     insert into jaqz889
        (JAQZ889CORR, JAQZ889USER, JAQZ889CODD, JAQZ889ITEM)
      values
        (0, usuario, 0, 'Seleccionar');
    
  exception
    when no_data_found then
      null;
  end;
end PQ_CR_EXONERACIONES;
/

