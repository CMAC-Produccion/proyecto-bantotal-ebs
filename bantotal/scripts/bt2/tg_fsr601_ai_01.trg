CREATE OR REPLACE TRIGGER TG_FSR601_AI_01
  after insert on FSR601
  for each row

DECLARE
  lc_usuario CHAR(10);  
  ld_fecpro  date;   
  ln_codage  number(3);          
BEGIN 
  lc_usuario := SUBSTR(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER'),1,10);       
     
    begin
      select a.pgfape
        into ld_fecpro
        from fst017 a
       where a.pgcod = :New.pp3cod;
    exception
      When others then
        ld_fecpro := trunc(sysdate);
    end;
    
    begin
      select b.ubsuc
        into ln_codage
        from fst046 b
       where b.pgcod  = :New.pp3cod
         and b.ubuser = lc_usuario;
    exception
      When others then
        ln_codage := 0;
    end;
        
    begin
      insert into JAQZ164(jaqz164cpg,
                          jaqz164cmo,
                          jaqz164csu,
                          jaqz164cmd,
                          jaqz164cpa,
                          jaqz164cct,
                          jaqz164cop,
                          jaqz164csb,
                          jaqz164cto,
                          jaqz164dpg,
                          jaqz164dmo,
                          jaqz164dsu,
                          jaqz164dmd,
                          jaqz164dpa,
                          jaqz164dct,
                          jaqz164dop,
                          jaqz164dsb,
                          jaqz164dto,
                          jaqz164fec,
                          jaqz164hra,
                          jaqz164usu,
                          jaqz164age,
                          jaqz164est
                          ) 
                    values(:New.pp3cod,  
                           :New.pp3mod,  
                           :New.pp3suc,  
                           :New.pp3mda,  
                           :New.pp3pap,  
                           :New.pp3cta,                             
                           :New.pp3oper, 
                           :New.pp3sbop, 
                           :New.pp3tope, 
                           :New.pp4cod, 
                           :New.pp4mod,  
                           :New.pp4suc,  
                           :New.pp4mda,  
                           :New.pp4pap,  
                           :New.pp4cta,                             
                           :New.pp4oper, 
                           :New.pp4sbop, 
                           :New.pp4tope,
                           ld_fecpro,
                           to_char(sysdate,'HH24:mi:ss'),
                           lc_usuario,
                           ln_codage,
                           'S'                                                                                                                                   
                          );
    exception
    When others then 
        null;
    end;               
Exception
When others then
     null;
END TG_FSR601_AI_01;
/

