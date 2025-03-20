CREATE OR REPLACE TRIGGER TG_FSX001_AI01
  after insert on FSX001
  for each row
  
DECLARE
  lc_coderr varchar2(400);
  lc_deserr varchar2(400);    
  lc_mail   varchar2(100);
  ln_pos    number(5);
  lc_domin  varchar2(20):='@CAJAAREQUIPA.PE';
BEGIN

  
    if :NEW.TXCOD = 0 then
      ln_pos  := instr(trim(:NEW.PEXTXT),'\');
      lc_mail := substr(trim(:NEW.PEXTXT),1,ln_pos-1);
      ln_pos  := instr(upper(lc_mail),lc_domin);      
      if ln_pos > 0 then
        begin
          -- Call the procedure
          sp_cl_afilia_ichannel(p_n_codpai => :NEW.PEPAIS,
                                p_n_tipdoc => :NEW.PETDOC,
                                p_c_numdoc => :NEW.PENDOC,
                                p_c_numcel => NULL,
                                p_c_email  => lc_mail,
                                p_c_coderr => lc_coderr,
                                p_c_deserr => lc_deserr
                               );
        end; 
      end if;
    End if;
                                                            
Exception
When others then
    null;
END TG_FSX001_AI01;
/

