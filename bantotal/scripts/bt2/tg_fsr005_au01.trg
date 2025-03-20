CREATE OR REPLACE TRIGGER TG_FSR005_AU01
  after update on FSR005
  for each row
  
DECLARE
  lc_coderr varchar2(400);
  lc_deserr varchar2(400);    
  lc_flag   CHAR(1);
BEGIN
    begin         
      select 'S'
        into lc_flag
        from sngc17 a
       where a.sngc17pais = :NEW.PEPAIS
         and a.sngc17ndoc = :NEW.PENDOC
         and a.sngc17tdoc = :NEW.PETDOC
         and a.sngc17dcod = :new.docod
         and a.sngc17corr = :new.doordp
         and a.sngc16ttel = 6;
    exception
    when others then     
      lc_flag := 'N';
    end;
  
    if lc_flag = 'S' then
      begin
        -- Call the procedure
        sp_cl_afilia_ichannel(p_n_codpai => :NEW.PEPAIS,
                              p_n_tipdoc => :NEW.PETDOC,
                              p_c_numdoc => :NEW.PENDOC,
                              p_c_numcel => :NEW.DOTELFP,
                              p_c_email  => NULL,
                              p_c_coderr => lc_coderr,
                              p_c_deserr => lc_deserr
                             );
      end; 
    End if;
                                                            
Exception
When others then
    null;
END TG_FSR005_AU01;
/

