create or replace procedure SP_AH_INSDOCABMFIR(P_nivel     in number,
                                               P_fechaIni  in date,                                               
                                               P_coddoc    in number,
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
                                               P_cargo7    IN varchar2,
                                               p_res       out varchar2) is
--nomdoc varchar2(40);
existe varchar2(1);                                              
fecha date;
secuencia number:=0;
begin  
  select pgfape into fecha from fst017 where pgcod = 1;
  Begin
    Select 'S'
      into Existe
      from jaqz584 a
      where a.jaqz584nivel = p_nivel
        AND a.jaqz584codigo = p_coddoc 
        and a.jaqz584est in ('S','H')
        and rownum = 1;
/*        and b.jaqz585codigo = a.jaqz584codigo
        and b.jaqz585frente = P_frente;*/ 
  exception
    when no_data_found then
      Existe := 'N';
  end;
  if Existe = 'N' then
    Begin   
        select nvl(max(jaqz584cod),0) +1
          into secuencia
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
                     values(secuencia, ---SEQ_JAQZ584.NEXTVAL,
                            P_coddoc,
                            P_fechaIni,
                            P_codIde,
                            p_nivel,
                            upper(P_documento),
                            P_cantidad,
                            P_usuario,
                            'H',
                            Fecha
                            );
             COMMIT;
      EXCEPTION
        WHEN dup_val_on_index THEN
          NULL;
      END;    
      if P_cargo1 is not null and P_cargo1 <> ' ' then
         Begin                       
          insert into jaqz585(jaqz585cod, 
                              jaqz585codigo, 
                              jaqz585frente,  
                              jaqz585cc1,
                              jaqz585des1                            )
                       values(secuencia,---SEQ_JAQZ584.currval,
                              P_coddoc,
                              P_nivel,                            
                              1,
                              upper(P_cargo1));
            COMMIT;
         EXCEPTION
           WHEN dup_val_on_index THEN
             NULL;
         END;                          
      end if;
      if P_cargo2 is not null and P_cargo2 <> ' ' then
         Begin                       
          insert into jaqz585(jaqz585cod, 
                              jaqz585codigo, 
                              jaqz585frente,  
                              jaqz585cc1,
                              jaqz585des1                            )
                       values(secuencia,----SEQ_JAQZ584.currval,
                              P_coddoc,
                              P_nivel,                            
                              2,
                              upper(P_cargo2));
            COMMIT;
         EXCEPTION
           WHEN dup_val_on_index THEN
             NULL;
         END;                          
      end if;
      if P_cargo3 is not null and P_cargo3 <> ' ' then
         Begin                       
          insert into jaqz585(jaqz585cod, 
                              jaqz585codigo, 
                              jaqz585frente,  
                              jaqz585cc1,
                              jaqz585des1                            )
                       values(secuencia,---SEQ_JAQZ584.currval,
                              P_coddoc,
                              P_nivel,                            
                              3,
                              upper(P_cargo3));
            COMMIT;
         EXCEPTION
           WHEN dup_val_on_index THEN
             NULL;
         END;                          
      end if;
      if P_cargo4 is not null and P_cargo4 <> ' ' then
         Begin                       
          insert into jaqz585(jaqz585cod, 
                              jaqz585codigo, 
                              jaqz585frente,  
                              jaqz585cc1,
                              jaqz585des1                            )
                       values(secuencia,---SEQ_JAQZ584.currval,
                              P_coddoc,
                              P_nivel,                            
                              4,
                              upper(P_cargo4));
            COMMIT;
         EXCEPTION
           WHEN dup_val_on_index THEN
             NULL;
         END;                          
      end if;                      
      if P_cargo5 is not null and P_cargo5 <> ' ' then
         Begin                       
          insert into jaqz585(jaqz585cod, 
                              jaqz585codigo, 
                              jaqz585frente,  
                              jaqz585cc1,
                              jaqz585des1                            )
                       values(secuencia,--SEQ_JAQZ584.currval,
                              P_coddoc,
                              P_nivel,                            
                              5,
                              upper(P_cargo5));
            COMMIT;
         EXCEPTION
           WHEN dup_val_on_index THEN
             NULL;
         END;                          
      end if;
      if P_cargo6 is not null and P_cargo6 <> ' ' then
         Begin                       
          insert into jaqz585(jaqz585cod, 
                              jaqz585codigo, 
                              jaqz585frente,  
                              jaqz585cc1,
                              jaqz585des1                            )
                       values(secuencia,---SEQ_JAQZ584.currval,
                              P_coddoc,
                              P_nivel,                            
                              6,
                              upper(P_cargo6));
            COMMIT;
         EXCEPTION
           WHEN dup_val_on_index THEN
             NULL;
         END;                          
      end if;
      if P_cargo7 is not null and P_cargo7 <> ' ' then
         Begin                       
          insert into jaqz585(jaqz585cod, 
                              jaqz585codigo, 
                              jaqz585frente,  
                              jaqz585cc1,
                              jaqz585des1                            )
                       values(secuencia,--SEQ_JAQZ584.currval,
                              P_coddoc,
                              P_nivel,                            
                              7,
                              upper(P_cargo7));
            COMMIT;
         EXCEPTION
           WHEN dup_val_on_index THEN
             NULL;
         END;                          
      end if;
      UPDATE fst198
        SET tp1nro1 = P_coddoc        
      Where Tp1cod   = 1
        AND Tp1cod1  = 10884
        AND Tp1corr1 = 40
	      AND Tp1corr2 = 0
        and Tp1corr3 = p_nivel;
      commit;  
   end if;
   if Existe = 'S' then
     p_res := 'N';
   else 
     p_res := 'S';
   end if;  
   
end SP_AH_INSDOCABMFIR;
/

