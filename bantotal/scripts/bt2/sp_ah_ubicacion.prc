create or replace procedure Sp_ah_ubicacion(P_N_PGCOD  IN NUMBER,
                                            P_N_ITSUC  IN NUMBER,
                                            P_N_ITMOD  IN NUMBER,
                                            P_N_ITTRAN IN NUMBER,
                                            P_N_ITNREL IN NUMBER,
                                            P_D_FECMOV IN DATE,
                                            P_D_FECPRO IN DATE,
                                            p_c_desubg out varchar2         
                                           ) is
  ln_jaql9nuele number(12):=0;   
  lc_jaql4cocom char(20):='';        
  ln_itsubo     number(3):=0;                                
begin
  if P_N_ITSUC = 902  then --AGENTES CORREPONSALES CAJA
     If P_N_ITMOD = 490 then
         begin
           Select a.jaql9nuele
             into ln_jaql9nuele 
             from jaql006 a 
            where a.JAQL6CTCOD = P_N_PGCOD 
              and a.JAQL6CTMOD = P_N_ITMOD  
              and a.JAQL6CTSUC = P_N_ITSUC
              and a.JAQL6CTTRA = P_N_ITTRAN 
              and a.JAQL6CTREL = P_N_ITNREL 
              and a.JAQL6CTFCO = P_D_FECMOV;
         exception
         When others then 
           p_c_desubg := null;
           return;
         end; 
         
         if ln_jaql9nuele > 0 then
           begin
             Select a.jaql4cocom
               into lc_jaql4cocom
               from jaql009 a 
              where a.jaql3cored = 2
                and a.jaql9nuele = ln_jaql9nuele;
           exception
           When others then 
             p_c_desubg := null;
             return;
           end;        
         End If;
         if trim(lc_jaql4cocom) is not null then
           begin
             Select trim(a.jaql4nocom)
               into p_c_desubg
               from jaql004 a 
              where a.jaql4cocom = lc_jaql4cocom;
           exception
           When others then 
             p_c_desubg := null;
             return;
           end;        
         End If;     
     End If; 
     if P_N_ITSUC = 902 And P_N_ITMOD = 493 And p_c_desubg is null then --KASNET 
        p_c_desubg := '';
     End If;  
     if P_N_ITSUC = 902 And P_N_ITMOD = 488 And p_c_desubg is null then --NIUBIZ 
        p_c_desubg := '';
     End If;  
     if P_N_ITSUC = 902 And P_N_ITMOD = 490 And p_c_desubg is null then --IZIPAY 
        p_c_desubg := '';
     End If;         
  End If;
  
  if P_N_ITSUC = 903 then --ATMS PROPIOS y TERCEROS
     if P_D_FECMOV = P_D_FECPRO then
       begin
         Select a.itsubo
           into ln_itsubo
           from FSD016 a 
          where a.pgcod  = P_N_PGCOD
            and a.itsuc  = P_N_ITSUC
            and a.itmod  = P_N_ITMOD
            and a.ittran = P_N_ITTRAN
            and a.itnrel = P_N_ITNREL
            and a.modulo = 23;           
       exception
       When others then 
         ln_itsubo := 0;
         p_c_desubg := null;
       end;      
     else
       begin
         Select a.hsubop
           into ln_itsubo
           from FSH016 a 
          where a.pgcod  = P_N_PGCOD
            and a.hsucor = P_N_ITSUC
            and a.hcmod  = P_N_ITMOD
            and a.htran  = P_N_ITTRAN
            and a.hnrel  = P_N_ITNREL
            and a.hfcon  = P_D_FECMOV
            and a.hmodul = 23;  
       exception
       When others then 
         ln_itsubo := 0;
         p_c_desubg := null;
       end;        
     end if;      
     If ln_itsubo > 0 then
       begin
         Select a.z0e475dsc
           into p_c_desubg
           from Z0E475 a 
          where a.z0e475cod  = RPAD(ln_itsubo,16,' ');
       exception
       When others then 
         p_c_desubg := null;
         return;
       end;           
     End if;      
  End if;
  -- Si no hay descripcción buscamos el canal mapeado en la guia por mod/trx
  if p_c_desubg is null then
    begin
     Select trim(a.tp1desc)
       into p_c_desubg
       from fst198 a
      where a.Tp1cod   = 1
        and a.Tp1cod1  = 10825
        and a.Tp1corr1 = 122
        and a.tp1nro1  = P_N_ITMOD
        and a.tp1nro2  = P_N_ITTRAN;
    Exception
    When others then
      p_c_desubg := null;
    end;
  End If;
Exception
when others then  
  p_c_desubg := null;
end Sp_ah_ubicacion;
/

