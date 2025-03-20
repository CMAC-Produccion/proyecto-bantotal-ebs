create or replace package PQ_OP_TRANSACCIONES is

  -- Author  : MARAUJO
  -- Created : 11/10/2018 09:59:55 a. m.
  -- Purpose : 
  procedure SP_OP_GRABA_ORIGEN(Ppgcod   number,
                               PItsuc   number,
                               Pitmod   number,
                               PIttran  number,
                               Pitnrel  number,
                               Pitord   number,
                               Pitsbor  number,
                               PItfcon  date,
                               Itsuc_O  number,
                               Itmod_O  number,
                               Ittran_O number,
                               Itnrel_O number,
                               Itfcon_O date,
                               Codrpt   out number);

  procedure SP_OP_RETORNA_ORIGEN(Ppgcod   number,
                                 PItsuc   number,
                                 Pitmod   number,
                                 PIttran  number,
                                 Pitnrel  number,
                                 PItfcon  date,
                                 Itsuc_O  out number,
                                 Itmod_O  out number,
                                 Ittran_O out number,
                                 Itnrel_O out number,
                                 Itfcon_O out date,
                                 Codrpt   out number);

end PQ_OP_TRANSACCIONES;
/

create or replace package body PQ_OP_TRANSACCIONES is

  procedure SP_OP_GRABA_ORIGEN(Ppgcod   number,
                               PItsuc   number,
                               Pitmod   number,
                               PIttran  number,
                               Pitnrel  number,
                               Pitord   number,
                               Pitsbor  number,
                               PItfcon  date,
                               Itsuc_O  number,
                               Itmod_O  number,
                               Ittran_O number,
                               Itnrel_O number,
                               Itfcon_O date,
                               Codrpt   out number) is
  
    vconcate varchar2(65);
  
  begin
  
    Codrpt := 0;
  
    vconcate := lpad(to_char(Itsuc_O), 3, '0') ||
                lpad(to_char(Itmod_O), 3, '0') ||
                lpad(to_char(Ittran_O), 3, '0') ||
                lpad(to_char(Itnrel_O), 4, '0') ||
                to_char(Itfcon_O, 'yyyymmdd');
  
    insert into fsx016
      (PGCOD,
       HCMOD,
       HSUCOR,
       HTRAN,
       HNREL,
       HFCON,
       HCORD,
       HCSUBO,
       TXCOD,
       TXOREN,
       TXTORD)
    values
      (Ppgcod,
       Pitmod,
       PItsuc,
       PIttran,
       Pitnrel,
       PItfcon,
       Pitord,
       Pitsbor,
       202,
       1,
       vconcate);
  
    commit;
  exception
    when others then
      Codrpt := 1;
  end SP_OP_GRABA_ORIGEN;
  ---------------------------------------------------------
  procedure SP_OP_RETORNA_ORIGEN(Ppgcod   number,
                                 PItsuc   number,
                                 Pitmod   number,
                                 PIttran  number,
                                 Pitnrel  number,
                                 PItfcon  date,
                                 Itsuc_O  out number,
                                 Itmod_O  out number,
                                 Ittran_O out number,
                                 Itnrel_O out number,
                                 Itfcon_O out date,
                                 Codrpt   out number) is
  
    vconcate varchar2(65);
  begin
  
    Codrpt := 0;
        
    select TXTORD
      into vconcate
      from fsx016
     where PGCOD = Ppgcod
       and HCMOD = Pitmod
       and HSUCOR = PItsuc
       and HTRAN = PIttran
       and HNREL = Pitnrel
       and HFCON = PItfcon
       and TXCOD = 202;
       
       Itsuc_O := substr(vconcate,1,3);
       Itmod_O := substr(vconcate,4,3);
       Ittran_O := substr(vconcate,7,3);
       Itnrel_O := substr(vconcate,10,4);
       Itfcon_O := to_date(substr(vconcate,14,8),'yyyymmdd');
         
  exception
    when others then
      Codrpt := 2;
  end SP_OP_RETORNA_ORIGEN;

end PQ_OP_TRANSACCIONES;
/

