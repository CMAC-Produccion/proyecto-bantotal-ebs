create or replace procedure SP_AH_MODDOCABMFIR(p_cod       in number,
                                               p_codigo    in number,
                                               p_estado    in varchar2,
                                               P_nivel     in number,
                                               P_fechaIni  in date,                                               
                                               P_codIde    in Varchar2,
                                               P_documento in varchar2,
                                               P_cantidad  in number,
                                               P_usuario   in varchar2,
                                               P_cargo1    IN varchar2,
                                               P_cargo2    IN varchar2,
                                               P_cargo3    IN varchar2,
                                               P_cargo4    IN varchar2,
                                               P_cargo5    IN varchar2,
                                               P_cargo6    IN varchar2,
                                               P_cargo7    IN varchar2) is



fecha date;
begin
   select pgfape into fecha from fst017 where pgcod = 1;

   update jaqz584 
      set jaqz584des = upper(P_documento),
          jaqz584cant = P_cantidad,
          jaqz584fecini = P_fechaIni,
          jaqz584codide = P_codIde,           
          jaqz584au5 = fecha,
          jaqz584au6 = P_usuario
    where jaqz584cod = p_cod    
      and jaqz584codigo = p_codigo
      and jaqz584nivel = p_nivel
      and jaqz584est = p_estado;
    commit;
   -- cargos
   update jaqz585 
      set jaqz585des1 = upper(p_cargo1) 
    where jaqz585cod = p_cod
      and jaqz585codigo = p_codigo
      and jaqz585frente = P_nivel
      and jaqz585cc1 = 1;

   update jaqz585 
      set jaqz585des1 = upper(p_cargo2)
    where jaqz585cod = p_cod
      and jaqz585codigo = p_codigo
      and jaqz585frente = P_nivel
      and jaqz585cc1 = 2;

   update jaqz585 
      set jaqz585des1 = upper(p_cargo3)
    where jaqz585cod = p_cod
      and jaqz585codigo = p_codigo
      and jaqz585frente = P_nivel
      and jaqz585cc1 = 3;
      
   update jaqz585 
      set jaqz585des1 = upper(p_cargo4)
    where jaqz585cod = p_cod
      and jaqz585codigo = p_codigo
      and jaqz585frente = P_nivel
      and jaqz585cc1 = 4;
            
   update jaqz585 
      set jaqz585des1 = upper(p_cargo5)
    where jaqz585cod = p_cod
      and jaqz585codigo = p_codigo
      and jaqz585frente = P_nivel
      and jaqz585cc1 = 5;
      
   update jaqz585 
      set jaqz585des1 = upper(p_cargo6)
    where jaqz585cod = p_cod
      and jaqz585codigo = p_codigo
      and jaqz585frente = P_nivel
      and jaqz585cc1 = 6;
      
   update jaqz585 
      set jaqz585des1 = upper(p_cargo7)
    where jaqz585cod = p_cod
      and jaqz585codigo = p_codigo
      and jaqz585frente = P_nivel
      and jaqz585cc1 = 7;
   commit;
end SP_AH_MODDOCABMFIR;
/

