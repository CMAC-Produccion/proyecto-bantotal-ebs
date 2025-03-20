create or replace package pq_cr_marca_agencia is

  Procedure sp_job_data(P_D_FECPRO IN DATE) ;
  procedure sp_valida_agencia(P_C_DIGITO1  IN VARCHAR2,
                              P_C_DIGITO2  IN VARCHAR2,
                              P_N_INI      IN NUMBER,
                              PN_DEPE66APL IN NUMBER,
                              PN_DEPE66ENV IN NUMBER                              
                             );      
  procedure sp_cr_agencia_credito(P_N_CODMOD IN NUMBER,
                                  P_N_OPERAC IN NUMBER,
                                  P_N_CODMON IN NUMBER,
                                  p_n_inserta out number
                                  );
end pq_cr_marca_agencia;
/

create or replace package body pq_cr_marca_agencia is

  -- Private type declarations

  Procedure sp_job_data(P_D_FECPRO IN DATE) is
       cursor c_job(PN_DEPE66APL IN NUMBER,PN_DEPE66ENV IN NUMBER) is
        select substr(depe66ncr, -1, 1) C_DIGITO1,
               substr(depe66ncr, -2, 1) C_DIGITO2
          from depe66 t
         where depe66ban = 'IN'
           and depe66apl = PN_DEPE66APL
           and depe66env = PN_DEPE66ENV
      group by substr(depe66ncr, -1, 1), 
               substr(depe66ncr, -2, 1);
           
  lc_variable   varchar2(4000);
  ln_job        number:= 0;
  ln_ini number:=0;             
  PN_DEPE66APL NUMBER;
  PN_DEPE66ENV NUMBER;
  ln_envio     number;
  ld_fecpro    date;
  ld_fecape date;
  
  begin       
   PN_DEPE66APL := 101;   
      
   begin
     select nvl(max(DEPE65ENV),0)
       into PN_DEPE66ENV
       from depe65 
      where DEPE65APL = PN_DEPE66APL 
        AND DEPE65BAN = 'IN' 
        AND DEPE65FEN = P_D_FECPRO;
        ln_envio := PN_DEPE66ENV;
   exception
   When no_data_found then     
       ln_envio := 0; 
   end;       
   
   if ln_envio = 0 then 
     --obtener proximo día habil
     --ld_fecpro := pq_cr_marca_agencia.fn_ah_diahabil(P_D_FECPRO);
      begin
       select a.pgfape
         into ld_fecape
         from fst017 a
        where a.pgcod = 1;
      end;     
      ld_fecpro := P_D_FECPRO;
      While ld_fecpro <= ld_fecape loop      
        begin
         select nvl(min(DEPE65ENV),0)
           into PN_DEPE66ENV
           from depe65 
          where DEPE65APL = PN_DEPE66APL 
            AND DEPE65BAN = 'IN' 
            AND DEPE65FEN = ld_fecpro + 1;   
            exit;           
        Exception
        When others then
          ld_fecpro := ld_fecpro + 1;       
        end;
      End loop;     
     
   End IF; 
    for job in c_job(PN_DEPE66APL,PN_DEPE66ENV) loop
         ln_ini := ln_ini + 1;  
         lc_variable := ' begin '||'  pq_cr_marca_agencia.sp_valida_agencia('||job.C_DIGITO1||','||job.C_DIGITO2||','||ln_ini||','||PN_DEPE66APL||','||PN_DEPE66ENV||');'|| ' End; ';
         ln_job := ln_job +1;
         --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
         dbms_scheduler.create_job(
         job_name=> 'AGEV'||LPAD(TO_CHAR(ln_job),5,'0'),
         job_type=> 'PLSQL_BLOCK',
         job_action=> lc_variable,
         start_date => sysdate+1/(24*180),
         enabled => true, 
         auto_drop=> TRUE,
         comments => 'MARCA DATA'
         );
         COMMIT;
        -- INSERTA TABLA CONTROL

        INSERT INTO Tab_jobs (c_codage,n_Numer1,c_detjob)
        VALUES('SCOTIABANK',ln_ini,lc_variable);
        COMMIT;        
    commit;
    end loop;
  end sp_job_data;  
      
  procedure sp_valida_agencia(P_C_DIGITO1 IN VARCHAR2,
                              P_C_DIGITO2 IN VARCHAR2,
                              P_N_INI      IN NUMBER,
                              PN_DEPE66APL IN NUMBER,
                              PN_DEPE66ENV IN NUMBER                              
                             ) is  
  cursor c_data is
    select a.depe66Mda         moneda ,
           trim(a.depe66Ncr)   cadena, 
           a.depe66Ncr         original,
           a.depe66cor
      from depe66 a
     where a.depe66ban = 'IN'
       and a.depe66apl = PN_DEPE66APL
       and a.depe66env = PN_DEPE66ENV
       and substr(a.depe66ncr, -1, 1) = P_C_DIGITO1
       and substr(a.depe66ncr, -2, 1) = P_C_DIGITO2
       --and trim(depe66Ncr) = '101001782958'
       ;                               
       
  concatena     varchar2(17);             
  codcta        varchar2(12);
  valor         number:=0;
  patron        varchar2(17);
  modulo        number(3);
  codage        number(3);
  operacion     number(9);
  ln_inserta    number(3);
  cont          number:=0;
  lc_msgerr     varchar2(400) ; 

  begin
    
    -- inicio de job
  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 =  p_n_ini
     and g.c_codage = 'SCOTIABANK';
  commit;    
  
  for i in c_data loop
    codcta := trim(i.cadena);
    if length(codcta) = 12 and substr(codcta,1,3) >= '200' then
       codcta := substr(i.cadena,4,9);
    end if;
    if length(codcta) < 12 then

       If i.Moneda = 0 then
            concatena := '004'|| '1' || '2' ||'*' || '00' ||  codcta;
       Else
            concatena := '004'|| '2' || '2' ||'*' || '00' ||  codcta;
       End If;      
       valor := 1;
       
       patron := replace(concatena,'*','0');
       codage := 0;
       begin
           select lpad(a.bnj096mod,3,'0')||lpad(a.bnj096ope,9,'0'),bnj096suc
             into concatena, codage
            from bnj096 a 
           where a.bnj096sor = patron;
           valor := 0;         
       exception           
       when others then
         valor := 1;        
       end;
       
       if valor = 1 then
         patron := replace(concatena,'*','2');
         begin
             select lpad(a.bnj096mod,3,'0')||lpad(a.bnj096ope,9,'0'),bnj096suc
             into concatena, codage
              from bnj096 a 
             where a.bnj096sor = patron;
             valor := 0;         
         exception           
         when others then
           valor := 1;        
         end;         
       end if;
       
       if valor = 1 then
         patron := replace(concatena,'*','6');
         begin
             select lpad(a.bnj096mod,3,'0')||lpad(a.bnj096ope,9,'0'),bnj096suc
             into concatena, codage
              from bnj096 a 
             where a.bnj096sor = patron;
             valor := 0;         
         exception           
         when others then
           valor := 1;        
         end;         
       end if;
       
       if valor = 1 then
         patron := replace(concatena,'*','4');
         begin
             select lpad(a.bnj096mod,3,'0')||lpad(a.bnj096ope,9,'0'),bnj096suc
             into concatena, codage
              from bnj096 a 
             where a.bnj096sor = patron;
             valor := 0;         
         exception           
         when others then
           valor := 1;        
         end;         
       end if;              
    else
      concatena := i.cadena;
      valor := 0;        
    end if;
    
    if valor = 0 then        
        --validar agencia
        modulo    := to_number(substr(concatena,1,3));
        operacion := to_number(substr(concatena,4,9));
        ln_inserta := 0;
        -- Call the procedure
        if codage = 0 then
                pq_cr_marca_agencia.sp_cr_agencia_credito(p_n_codmod  => modulo,
                                                  p_n_operac  => operacion,
                                                  p_n_codmon  => i.moneda,
                                                  p_n_inserta => ln_inserta
                                                  );
        else
           ln_inserta := codage;
        end if;                                                  
        --if ln_inserta = 'S' then
          --actualiza
            update depe66 
               set MARCA = ln_inserta
             where depe66ban = 'IN'
               and depe66apl = PN_DEPE66APL
               and depe66env = PN_DEPE66ENV
               and depe66cor = i.depe66cor;
               --and depe66Mda = i.moneda
               --and depe66ncr = i.original;
           
           cont := cont  + 1;
           if mod(cont,10) = 0 then
            commit;
            cont := 0;
           end if;
        --end if;   
    end if;           
  end loop;
  commit;

  update tab_jobs g
     set g.d_fecfin = sysdate
   where g.n_numer1 =  p_n_ini
     and g.c_codage = 'SCOTIABANK';
  commit;
  
  exception
  when others then
  lc_msgerr := sqlerrm;
      update tab_jobs g
       set g.c_inderr = 'S',
           g.c_deserr = lc_msgerr
     where g.n_numer1 = p_n_ini
       and g.c_codage = 'SCOTIABANK';
  commit;
  return;    
  end sp_valida_agencia;                             
  procedure sp_cr_agencia_credito(P_N_CODMOD IN NUMBER,
                                  P_N_OPERAC IN NUMBER,
                                  P_N_CODMON IN NUMBER,
                                  p_n_inserta out number
                                  ) is
  begin
   select a.aosuc
     into p_n_inserta
     from fsd010 a
    where a.pgcod    = 1  
      and a.aopap    = 0
      and a.aostat   <> 99  
      and a.aomod    = P_N_CODMOD
      and a.aooper   = P_N_OPERAC
      and a.aomda    = P_N_CODMON
      and rownum = 1
      ;
  exception
  when others then
     p_n_inserta := 0;     
  end sp_cr_agencia_credito;    
                    
end pq_cr_marca_agencia;
/

