create or replace procedure sp_ah_parsea_texto(P_C_TEXTO  IN VARCHAR2,
                                               P_N_NUMCAR IN NUMBER,                                               
                                               P_C_CODCAR IN VARCHAR2,
                                               P_N_INDREL IN NUMBER,
                                               p_v_valor1 out varchar2,
                                               p_v_valor2 out varchar2,
                                               p_v_valor3 out varchar2,
                                               p_v_valor4 out varchar2
                                              ) is
  ln_tamlin number(10):=0;                                              
  ln_tamtxt number(10):=0;                                              
  ln_concar number(10):=0;    
  lv_valor  varchar2(1) := '';        
  lv_cadena varchar2(400) := '';    
  ln_puntero number(10):=0;    
  ln_cont number(10):=0;      
  ln_cantidad number(10):=0;  
  lv_valor1   varchar2(400):=null;                                      
  lv_valor2   varchar2(400):=null;
  lv_valor3   varchar2(400):=null;
  lv_valor4   varchar2(400):=null;
  
  ln_loncad   number(9):=0;
  ln_espdis   number(9):=0;
  ln_espcad   number(9):=0;
  lv_valorx   varchar2(400):=null;   
  lv_valory   varchar2(400):=null;   
  ln_posblk   number(9):=0;
  ln_valor    number(9):=0;
  ln_dif      number(9):=0;
  lc_patron   varchar2(400):=null;   
  lc_patron1  varchar2(400):=null;   	
  lc_codcar   char(1);
begin
   if trim(P_C_CODCAR) is null then
     lc_codcar := ' ';
   Else
     lc_codcar := P_C_CODCAR;
   End If; 
               
   ln_tamlin := P_N_NUMCAR;
   ln_tamtxt := length(P_C_TEXTO);
   While ln_concar <= ln_tamtxt loop          
      ln_concar  := ln_concar + ln_tamlin;          
      ln_puntero := ln_puntero + 1;  
      
      if substr(P_C_TEXTO,ln_concar,1) = lc_codcar /*' '*/ then
         --pinta cadena
         ln_cantidad := ln_tamlin; 
         lv_cadena := substr(P_C_TEXTO,ln_puntero,ln_tamlin);
      else
           lv_valor :='*';
           while lv_valor <> lc_codcar /*' '*/ and ln_concar >= ln_puntero loop
                 ln_concar := ln_concar - 1;
                 lv_valor := substr(P_C_TEXTO,ln_concar,1);                 
           end loop;
           if ln_concar <= ln_puntero then
             Exit;
           end if;
           --pinta
        ln_cantidad := ln_concar - ln_puntero + 1;   
        lv_cadena := substr(P_C_TEXTO,ln_puntero,ln_cantidad);
      end if;
      ln_cont := ln_cont + 1;
      if ln_cont = 1 then
         lv_valor1 := lv_cadena;
      End If;   
      if ln_cont = 2 then
         lv_valor2 := lv_cadena;
      End If;
      if ln_cont = 3 then
         lv_valor3 := lv_cadena;
      End If;       
      if ln_cont = 4 then
         lv_valor4 := lv_cadena;
      End If;       
      /*           
      insert into crdtcap(n_monto1,c_descri1) values(ln_cont,lv_cadena); --100
      */	
      ln_puntero := ln_puntero + ln_cantidad - 1;    
   End loop;
   
   If P_N_INDREL = 1 then
       --rellenamos con espacios en blanco 
       ln_loncad := length(trim(lv_valor1));
       ln_espdis := P_N_NUMCAR - ln_loncad;
       ln_espcad := REGEXP_COUNT(trim(lv_valor1),lc_codcar/*' '*/);
       lv_valorx := lv_valor1;
       lv_valory := null;
       lc_patron := null;
       lc_patron1:= null;
       ln_posblk := 0;
       ln_dif    := 0;
       ln_valor  := 0;
       
       if ln_loncad > 0 then
         if  ln_espdis <= ln_espcad then
              lc_patron := '  ';
              ln_posblk := instr(lv_valorx,' ',1,ln_espdis);      
              lv_valory := SUBSTR(lv_valorx,1,ln_posblk);
              lv_valory := replace(lv_valory,' ',lc_patron);
              lv_valory := lv_valory || SUBSTR(lv_valorx,ln_posblk+1,length(lv_valorx)-ln_posblk);    
         Else          
              if ln_espcad > 0 and length(trim(lv_valor2))> 0 then 
                ln_valor := trunc(ln_espdis/ln_espcad);
                ln_dif   := ln_espdis-(ln_valor*ln_espcad);
                ln_valor := ln_valor +1; 
                
                for i in 1.. ln_valor loop
                  lc_patron := lc_patron || ' ';
                End loop;
                   
                lv_valorx  := replace(lv_valorx,' ',lc_patron);
                if ln_dif > 0 then 
                  ln_posblk  := instr(lv_valorx,lc_patron,1,ln_dif);      
                  lv_valory  := SUBSTR(lv_valorx,1,ln_posblk+ln_valor-1);
                  lc_patron1 := lc_patron || ' ';    
                  lv_valory  := replace(lv_valory,lc_patron,lc_patron1);
                  lv_valory  := lv_valory || SUBSTR(lv_valorx,ln_posblk+ln_valor,length(lv_valorx)-ln_posblk+ln_valor-1);  
                Else
                  lv_valory  := lv_valorx;
                End If;
              Else  
                lv_valory  := lv_valorx;
              End if; 
              --lv_valory := lv_valor1;
         End If;   
         lv_valor1 := lv_valory; 
       End if;
       
       ln_loncad := length(trim(lv_valor2));
       ln_espdis := P_N_NUMCAR - ln_loncad;
       ln_espcad := REGEXP_COUNT(trim(lv_valor2),' ');
       lv_valorx := lv_valor2;
       lv_valory := null;
       lc_patron := null;
       lc_patron1:= null;
       ln_posblk := 0;
       ln_dif    := 0;
       ln_valor  := 0;
         
       if ln_loncad > 0 then   
         if  ln_espdis <= ln_espcad then
              lc_patron := '  ';
              ln_posblk := instr(lv_valorx,' ',1,ln_espdis);      
              lv_valory := SUBSTR(lv_valorx,1,ln_posblk);
              lv_valory := replace(lv_valory,' ',lc_patron);
              lv_valory := lv_valory || SUBSTR(lv_valorx,ln_posblk+1,length(lv_valorx)-ln_posblk);    
         Else
              if ln_espcad > 0 and length(trim(lv_valor3))> 0 then 
                ln_valor := trunc(ln_espdis/ln_espcad);
                ln_dif   := ln_espdis-(ln_valor*ln_espcad);
                ln_valor := ln_valor +1;
                
                for i in 1.. ln_valor loop
                  lc_patron := lc_patron || ' ';
                End loop;
                   
                lv_valorx  := replace(lv_valorx,' ',lc_patron);
                if ln_dif > 0 then 
                  ln_posblk  := instr(lv_valorx,lc_patron,1,ln_dif);      
                  lv_valory  := SUBSTR(lv_valorx,1,ln_posblk+ln_valor-1);
                  lc_patron1 := lc_patron || ' ';    
                  lv_valory  := replace(lv_valory,lc_patron,lc_patron1);
                  lv_valory  := lv_valory || SUBSTR(lv_valorx,ln_posblk+ln_valor,length(lv_valorx)-ln_posblk+ln_valor-1);  
                Else
                  lv_valory  := lv_valorx;
                End If;  
              Else  
                lv_valory  := lv_valorx;            
              End If;
              --lv_valory := lv_valor2;          
         End If;   
         lv_valor2 := lv_valory; 
       End if;
       
       ln_loncad := length(trim(lv_valor3));
       ln_espdis := P_N_NUMCAR - ln_loncad;
       ln_espcad := REGEXP_COUNT(trim(lv_valor3),' ');
       lv_valorx := lv_valor3;
       lv_valory := null;
       lc_patron := null;
       lc_patron1:= null;
       ln_posblk := 0;
       ln_dif    := 0;
       ln_valor  := 0;  
       
       if ln_loncad > 0 then
         if  ln_espdis <= ln_espcad then
              lc_patron := '  ';
              ln_posblk := instr(lv_valorx,' ',1,ln_espdis);      
              lv_valory := SUBSTR(lv_valorx,1,ln_posblk);
              lv_valory := replace(lv_valory,' ',lc_patron);
              lv_valory := lv_valory || SUBSTR(lv_valorx,ln_posblk+1,length(lv_valorx)-ln_posblk);    
         Else
              if ln_espcad > 0 and length(trim(lv_valor4))> 0 then 
                ln_valor := trunc(ln_espdis/ln_espcad);
                ln_dif   := ln_espdis-(ln_valor*ln_espcad);
                ln_valor := ln_valor +1;
                
                for i in 1.. ln_valor loop
                  lc_patron := lc_patron || ' ';
                End loop;
                   
                lv_valorx  := replace(lv_valorx,' ',lc_patron);
                if ln_dif > 0 then 
                  ln_posblk  := instr(lv_valorx,lc_patron,1,ln_dif);      
                  lv_valory  := SUBSTR(lv_valorx,1,ln_posblk+ln_valor-1);
                  lc_patron1 := lc_patron || ' ';    
                  lv_valory  := replace(lv_valory,lc_patron,lc_patron1);
                  lv_valory  := lv_valory || SUBSTR(lv_valorx,ln_posblk+ln_valor,length(lv_valorx)-ln_posblk+ln_valor-1);  
                Else
                  lv_valory  := lv_valorx;
                End If;  
              Else  
                lv_valory  := lv_valorx;            
              End If;
              --lv_valory := lv_valor3;
         End If;   
         lv_valor3 := lv_valory; 
       end if;
          
       ln_loncad := length(trim(lv_valor4));
       ln_espdis := P_N_NUMCAR - ln_loncad;
       ln_espcad := REGEXP_COUNT(trim(lv_valor4),' ');
       lv_valorx := lv_valor4;
       lv_valory := null;
       lc_patron := null;
       --lc_patron1:= null;
       ln_posblk := 0;
       --ln_dif    := 0;
       --ln_valor  := 0;
         
       if ln_loncad > 0 then   
         if  ln_espdis <= ln_espcad then
              lc_patron := '  ';
              ln_posblk := instr(lv_valorx,' ',1,ln_espdis);      
              lv_valory := SUBSTR(lv_valorx,1,ln_posblk);
              lv_valory := replace(lv_valory,' ',lc_patron);
              lv_valory := lv_valory || SUBSTR(lv_valorx,ln_posblk+1,length(lv_valorx)-ln_posblk);    
         Else
            /*  if ln_espcad > 0 then 
                ln_valor := trunc(ln_espdis/ln_espcad);
                ln_dif   := ln_espdis-(ln_valor*ln_espcad);
                ln_valor := ln_valor +1;
                
                for i in 1.. ln_valor loop
                  lc_patron := lc_patron || ' ';
                End loop;
                   
                lv_valorx  := replace(lv_valorx,' ',lc_patron);
                if ln_dif > 0 then 
                  ln_posblk  := instr(lv_valorx,lc_patron,1,ln_dif);      
                  lv_valory  := SUBSTR(lv_valorx,1,ln_posblk+ln_valor-1);
                  lc_patron1 := lc_patron || ' ';    
                  lv_valory  := replace(lv_valory,lc_patron,lc_patron1);
                  lv_valory  := lv_valory || SUBSTR(lv_valorx,ln_posblk+ln_valor,length(lv_valorx)-ln_posblk+ln_valor-1);  
                Else
                  lv_valory  := lv_valorx;
                End If;
              Else  
                lv_valory  := lv_valorx;            
              End if;  */
              lv_valory := lv_valor4;              
         End If;   
         lv_valor4 := lv_valory; 
       End if;      
   End If;   
   IF substr(lv_valor1,length(lv_valor1),1) = P_C_CODCAR THEN        
      p_v_valor1 := substr(lv_valor1,1,length(lv_valor1)-1);
   Else
      p_v_valor1 := lv_valor1;
   End If;
   IF substr(lv_valor2,length(lv_valor2),1) = P_C_CODCAR THEN        
      p_v_valor2 := substr(lv_valor2,1,length(lv_valor2)-1);
   Else
      p_v_valor2 := lv_valor2;
   End If;   
   IF substr(lv_valor3,length(lv_valor3),1) = P_C_CODCAR THEN        
      p_v_valor3 := substr(lv_valor3,1,length(lv_valor3)-1);
   Else
      p_v_valor3 := lv_valor3;
   End If;         
   IF substr(lv_valor4,length(lv_valor4),1) = P_C_CODCAR THEN        
      p_v_valor4 := substr(lv_valor4,1,length(lv_valor4)-1);
   Else
      p_v_valor4 := lv_valor4;
   End If;

   --commit;
end sp_ah_parsea_texto;
/

