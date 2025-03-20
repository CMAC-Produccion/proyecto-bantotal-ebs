create or replace procedure SP_OP_GRABA_DEBUG(p_jaqz687prg varchar2,
                                              p_jaqz687var varchar2,
                                              p_jaqz687fec date,
                                              p_jaqz687hor varchar2,
                                              p_jaqz687usr varchar2) is
  -- Author  : MARAUJO
  -- Created : 16/08/2019 04:16:52 p. m.
  -- Purpose : Registrar debug a programas

  vOPGVAL char(1);

begin

  begin
    select OPGVAL
      into vOPGVAL
      from fst200
     where pgcod = 1
       and opgcod between 11501 and 11900
       and trim(OPGTXT) = p_jaqz687prg;
  exception
    when others then
      vOPGVAL := 'N';
  end;

  if vOPGVAL = 'S' then
  
    insert into jaqz687
      (JAQZ687PRG, JAQZ687VAR, JAQZ687FEC, JAQZ687HOR, JAQZ687USR)
    values
      (p_JAQZ687PRG,
       p_JAQZ687VAR,
       p_JAQZ687FEC,
       p_JAQZ687HOR,
       p_JAQZ687USR);
  
    commit;
  end if;

end SP_OP_GRABA_DEBUG;
/

