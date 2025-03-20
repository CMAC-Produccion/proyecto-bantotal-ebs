CREATE OR REPLACE TRIGGER TG_SNGC17_AI01
  after insert on SNGC17
  for each row
  
DECLARE
  lc_coderr  varchar2(400);
  lc_deserr  varchar2(400);   
  lc_dotelfp   char(20);
BEGIN

  -- Call the procedure
  if :NEW.SNGC17PAIS > 0 and :NEW.SNGC16TTEL = 6 then
       begin                   
         select a.dotelfp
           into lc_dotelfp
           from fsr005 a 
          where a.pepais = :NEW.SNGC17PAIS 
            and a.petdoc = :NEW.SNGC17TDOC
            and a.pendoc = :NEW.SNGC17NDOC
            and a.docod  = :NEW.SNGC17DCOD
            and a.doordp = :NEW.SNGC17CORR;
       exception
       when others then 
         lc_dotelfp := null;
       end;
       if lc_dotelfp is not null then
          begin
            -- Call the procedure
            sp_cl_afilia_ichannel(p_n_codpai => :NEW.SNGC17PAIS,
                                  p_n_tipdoc => :NEW.SNGC17TDOC,
                                  p_c_numdoc => :NEW.SNGC17NDOC,
                                  p_c_numcel => lc_dotelfp,
                                  p_c_email  => NULL,
                                  p_c_coderr => lc_coderr,
                                  p_c_deserr => lc_deserr
                                 );
          end;          
       End If;
  end if;                                                                                                  
Exception
When others then
    null;
END TG_SNGC17_AI01;
/

