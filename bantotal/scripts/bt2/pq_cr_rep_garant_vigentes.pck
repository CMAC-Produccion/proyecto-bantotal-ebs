create or replace package pq_cr_rep_garant_vigentes is

  -- Author  : IGS_RCASTRO
  -- Created : 15/09/2023 18:08:32
  -- Purpose : 
  

procedure sp_delete_por_usuario(p_usuario varchar2);

end pq_cr_rep_garant_vigentes;
/

create or replace package body pq_cr_rep_garant_vigentes is


procedure sp_delete_por_usuario(p_usuario varchar2) is
ubuser1 character(12);  
                                                
Begin
  ubuser1 := p_usuario;
  delete from JAQZ555 where jaqz555usr = UBUSER1;
  commit;
END;

end pq_cr_rep_garant_vigentes;
/

