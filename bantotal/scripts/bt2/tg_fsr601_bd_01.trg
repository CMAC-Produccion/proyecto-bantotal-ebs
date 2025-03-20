CREATE OR REPLACE TRIGGER TG_FSR601_BD_01
  before delete on FSR601
  for each row

DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION;
  ln_numreg number(5):=0;
BEGIN
    begin
      select count(PP3COD)
        into ln_numreg
        from FSR601
       where PP3COD  = :old.pp3cod
         and PP3MOD  = :old.pp3mod
         and PP3SUC  = :old.pp3suc         
         and PP3MDA  = :old.pp3mda
         and PP3PAP  = :old.pp3pap
         and PP3CTA  = :old.pp3cta
         and PP3OPER = :old.pp3oper
         and PP3SBOP = :old.pp3sbop
         and PP3TOPE = :old.pp3tope;
    exception
    When others then
        ln_numreg :=-1;
    end;
    
    if ln_numreg = 1 then
      begin
        update JAQZ164
           set jaqz164est = 'N'
         where jaqz164cpg = :Old.pp3cod
           and jaqz164cmo = :Old.pp3mod
           and jaqz164csu = :Old.pp3suc
           and jaqz164cmd = :Old.pp3mda
           and jaqz164cpa = :Old.pp3pap
           and jaqz164cct = :Old.pp3cta
           and jaqz164cop = :Old.pp3oper
           and jaqz164csb = :Old.pp3sbop
           and jaqz164cto = :Old.pp3tope
           and jaqz164est = 'S';
      exception
      When others then
          null;
      end;
    end if;
    commit;
Exception
When others then
     null;
    commit;
END TG_FSR601_BD_01;
/

