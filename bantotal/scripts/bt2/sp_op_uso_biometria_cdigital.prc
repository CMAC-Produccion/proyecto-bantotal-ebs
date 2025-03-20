create or replace procedure SP_OP_USO_BIOMETRIA_CDIGITAL(ppgcod   number,
                                                         pitsuc   number,
                                                         pitmod   number,
                                                         pittran  number,
                                                         pitnrel  number,
                                                         pfeccon  date,
                                                         pcodtipo out char,
                                                         pdestipo out char) is
                                                         
  -- Author  : MARAUJO
  -- Created : 28/04/2020 10:31:43 a. m.
  -- Purpose : Verifica si transacción pasó biometría y contratación digital                                                       

  cursor cdig is
    Select substr(JAQM472TOK, 1, 5) rpta
      from jaqm472
     where JAQM472EMP = ppgcod
       and JAQM472FEC = pfeccon
       and JAQM472SUC = pitsuc
       and JAQM472MOD = pitmod
       and JAQM472TRA = pittran
       and JAQM472REL = pitnrel
     order by JAQM472FEC, JAQM472SUC, JAQM472MOD, JAQM472TRA, JAQM472REL;

begin
  pcodtipo := 'N';

  for i in cdig loop
    pcodtipo := 'C';
    if i.rpta = 'ERROR' then
      pcodtipo := 'N';
      exit;
    end if;
  end loop;

  if pcodtipo = 'N' then
     null;
    /*
    for i in bio loop
      pusobcd := 'C';    
      if i.rpta = 'ERROR' then
        pusobcd := 'N';
        exit;
      end if;      
    end loop;
    */
  end if;

  case
    when pcodtipo = 'N' then
      pdestipo := 'Contratación Normal';
    when pcodtipo = 'C' then
      pdestipo := 'Contratación Digital';
    else
      pdestipo := 'Validación Biométrica';
  end case;

end SP_OP_USO_BIOMETRIA_CDIGITAL;
/

