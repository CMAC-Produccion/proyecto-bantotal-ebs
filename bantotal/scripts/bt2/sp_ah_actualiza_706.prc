create or replace procedure sp_ah_actualiza_706(vjaql706pgco number,
                                                vjaql706scsu number,
                                                vjaql706scmo number,
                                                vjaql706scmd number,
                                                vjaql706scpa number,
                                                vjaql706scct number,
                                                vjaql706scop number,
                                                vjaql706scsb number,
                                                vjaql706scto number,
                                                vJAQL706TRCO number,
                                                Error        varchar2) is
  pragma autonomous_transaction;
begin
  update jaql706
     set JAQL706AU02 = Error
   Where JAQL706PGCO = vjaql706pgco
     and JAQL706SCSU = vjaql706scsu
     and JAQL706SCMO = vjaql706scmo
     and JAQL706SCMD = vjaql706scmd
     and JAQL706SCPA = vjaql706scpa
     and JAQL706SCCT = vjaql706scct
     and JAQL706SCOP = vjaql706scop
     and JAQL706SCSB = vjaql706scsb
     and JAQL706SCTO = vjaql706scto
     and JAQL706TRCO = vJAQL706TRCO;
  commit;
end sp_ah_actualiza_706;
/

