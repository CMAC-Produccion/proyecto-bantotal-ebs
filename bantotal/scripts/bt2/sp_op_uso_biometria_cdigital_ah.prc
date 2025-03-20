create or replace procedure SP_OP_USO_BIOMETRIA_CDIGITAL_AH(P_N_Pgcod in number,
                                                            P_N_Scsuc in number, 
                                                            P_N_Scmod in number, 
                                                            P_N_Scmda in number, 
                                                            P_N_Scpap in number, 
                                                            P_N_Sccta in number, 
                                                            P_N_Scoper in number, 
                                                            P_N_Scsbop in number, 
                                                            P_N_Sctope in number,                                                        
                                                            pfeccon  in date,
                                                            pcodtipo out char,
                                                            pdestipo out char) is
                                                         
  -- Author  : YLOZADA
  -- Created : 25/05/2022 10:31:43 a. m.
  -- Purpose : Verifica si transacción pasó biometría y contratación digital                                                       

  cursor cdig is
    Select substr(trim(JAQM83TOK), 1, 5) rpta
      from jaqm83
     where jaqm83emr = P_N_Pgcod 
       and jaqm83mod = P_N_Scmod   
       and jaqm83suc = P_N_Scsuc
       and jaqm83mda = P_N_Scmda 
       and jaqm83pap = P_N_Scpap 
       and jaqm83cta = P_N_Sccta 
       and jaqm83ope = P_N_Scoper
       and jaqm83sbo = P_N_Scsbop
       and jaqm83top = P_N_Sctope
       and jaqm83fch = pfeccon;
begin
  pcodtipo := 'N';

  for i in cdig loop
    pcodtipo := 'C';
    if i.rpta = 'ERROR' then
      pcodtipo := 'N';
      exit;
    end if;
  end loop;

  case
    when pcodtipo = 'N' then
      pdestipo := 'Contratación Normal';
    when pcodtipo = 'C' then
      pdestipo := 'Contratación Digital';
    else
      pdestipo := 'Validación Biométrica';
  end case;

end SP_OP_USO_BIOMETRIA_CDIGITAL_AH;
/

