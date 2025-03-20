create or replace package PQ_MIVIVIENDA is

  -- Author  : MCANDIA
  -- Created : 27/08/2019 12:48:07 p.m.
  -- Purpose : 

  procedure sp_cr_Prelacion(ln_Bono    in number,
                            ln_Premio  in number,
                            ln_BonoSos in number,
                            ln_BonoTEC in number,
                            ln_CodPre  out number);

end PQ_MIVIVIENDA;
/

create or replace package body PQ_MIVIVIENDA is

  procedure sp_cr_Prelacion(ln_Bono    in number,
                            ln_Premio  in number,
                            ln_BonoSos in number,
                            ln_BonoTEC in number,
                            ln_CodPre  out number) is
  
  begin
  
    begin
      if ln_Bono <> 0.00 then
        if ln_BonoSos <> 0.00 then
          ln_CodPre := 5;
        end if;
      end if;
    
      if ln_Premio <> 0.00 then
        if ln_BonoSos <> 0.00 then
          ln_CodPre := 6;
        end if;
      end if;           
      
      if ln_BonoSos <> 0.00 then
        if ln_BonoTEC <> 0.00 then
          ln_CodPre := 7;
        end if;
      end if;
     if ln_Bono <> 0.00  and ln_Premio=0 and ln_BonoSos= 0 and  ln_BonoTEC=0 then
        ln_CodPre := 1;
     end if;
     if ln_Premio <> 0.00 and ln_Bono=0  and ln_BonoSos= 0 and  ln_BonoTEC=0 then
        ln_CodPre := 2;
     end if;
     if ln_BonoSos <> 0.00 and ln_Bono=0  and ln_Premio= 0 and  ln_BonoTEC=0 then
        ln_CodPre := 3;
     end if;
     if ln_BonoTEC <> 0.00 and  ln_Bono=0 and ln_Premio=0 and ln_BonoSos= 0 then
        ln_CodPre := 4;
     end if;
      
    end;
  
  end sp_cr_Prelacion;
end PQ_MIVIVIENDA;
/

