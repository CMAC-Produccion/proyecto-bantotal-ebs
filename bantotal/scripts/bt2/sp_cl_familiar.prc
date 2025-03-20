create or replace procedure sp_cl_familiar(P_N_CODPAI IN NUMBER,
                                           P_N_TIPDOC IN NUMBER,
                                           P_C_NUMDOC IN VARCHAR2,           
                                           p_c_indpar out VARCHAR2
                                          ) is
 cursor c_izquierda is                                          
 Select a.* 
   from fsr002 a
  Where a.Pepais = P_N_CODPAI
    and a.Petdoc = P_N_TIPDOC
    and a.Pendoc = rpad(P_C_NUMDOC,12,' ');
 
 cursor c_derecha is
 Select a.* 
   from fsr002 a
  Where a.Rppais = P_N_CODPAI
    and a.Rptdoc = P_N_TIPDOC
    and a.Rpndoc = rpad(P_C_NUMDOC,12,' ');
    
  lc_EstFamiliaR    char(2);
  lc_EstFamilia     char(2);
  ln_Rppais         number(3);
	ln_Rptdoc         number(2);
	lc_Rpndoc         char(12);
  lc_Pfebco         char(1);
  
begin
  lc_EstFamilia := 'NO';
  For i in c_izquierda loop
		ln_Rppais := i.Rppais;
		ln_Rptdoc := i.Rptdoc;
		lc_Rpndoc := i.Rpndoc;
    begin
      Select b.Pfebco 
        into lc_Pfebco 
        from Fsd002 b 
       Where b.Pfpais = ln_Rppais 
         and b.Pftdoc = ln_Rptdoc
         and b.Pfndoc = lc_Rpndoc
         and b.Pfebco = 'S';
    exception
    when others then  
       lc_Pfebco := 'N';
    end;
    
    If lc_Pfebco = 'S' then
       lc_EstFamilia := 'SI';--Relacion Parentesco izquierda
    End If;            
  end loop;
  
  lc_EstFamiliaR := 'NO';
  For i in c_derecha loop
		ln_Rppais := i.Pepais;
		ln_Rptdoc := i.Petdoc;
		lc_Rpndoc := i.Pendoc;
    begin
      Select b.Pfebco 
        into lc_Pfebco 
        from Fsd002 b 
       Where b.Pfpais = ln_Rppais 
         and b.Pftdoc = ln_Rptdoc
         and b.Pfndoc = lc_Rpndoc
         and b.Pfebco = 'S';
    exception
    when others then  
       lc_Pfebco := 'N';
    end;
    
    If lc_Pfebco = 'S' then
       lc_EstFamiliaR := 'SI';--Relacion Parentesco izquierda
    End If;            
  end loop;
    
	If lc_EstFamilia = 'SI' OR lc_EstFamiliaR = 'SI' then
		p_c_indpar := 'S';
  Else
    p_c_indpar := 'N';
	End If;
    
exception
when others then  
  p_c_indpar := 'N';
end sp_cl_familiar;
/

