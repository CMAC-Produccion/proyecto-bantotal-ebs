CREATE OR REPLACE TRIGGER TG_WFWRKITEMS_AI_FMV_01
  after insert on wfwrkitems--SNGC13
  for each row
DECLARE
  pn_hcmod  fst003.modulo%type;
  pn_htran  fsd015.ittran%type;
  pn_pgcod  fst017.pgcod%type;
  pd_fecpro fst017.pgfape%type;
	pd_qz440codre jaqz440.qz440codre%type;
  
  pc_hora char(8);
  lc_numtar varchar2(65);
	mensaje varchar2(500);
	titulo varchar2(100);
	flag_tarea char(1);
	flag_reprog char(1);
	flag_refina char(1);
BEGIN
	If  :new.wftaskcod = 55 and :new.wfitemprvtask=11  and :new.wfitemstsact=1 then
        begin
          select 'S' 
          into flag_tarea
          from xwf700 x
          where x.xwfprcins = :new.wfinsprcid
          and x.xwfmodulo = 111
          and x.xwfcar3 = '1';
          if flag_tarea = 'S' then
             pq_cr_fmv_correos.sp_mail_aprobacion(:new.wfinsprcid);
          end if;
				end;
  End IF;
	
Exception
When others then
    null;
end TG_WFWRKITEMS_AI_FMV_01;
/

