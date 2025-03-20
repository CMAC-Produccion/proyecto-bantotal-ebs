create or replace procedure sp_op_reprecenvema(ps_codusu varchar2,
                                               pd_fecpro date,
                                               pd_fecini date,
                                               pd_fecfin date,
                                               ps_coderr out varchar2) is
begin
  delete jaql847 where jaql847cusu = ps_codusu; -- and jaql847fpro = pd_fecpro;
  commit;
  begin
     INSERT into JAQL847(jaql847cusu,jaql847fpro,jaql847crec,jaql847frec,jaql847hrec,jaql847tdoc,
                         jaql847ndoc,jaql847tper,jaql847ncel,jaql847emai,jaql847apat,jaql847amat,
                         jaql847nomb,jaql847ncom,jaql847menv,jaql847fema,jaql847hema,jaql847fdat)
               select ps_codusu,pd_fecpro,c_codrec,d_fecrec,c_hora,c_tipdoc,
                      c_numdoc,c_tipper,c_numcel,c_email,c_apepat,c_apemat,
                      c_nombre,c_nomcon,c_envmail,C_FECMAIL,C_HORMAIL,c_Fladat
                 from reclamos@reclamos 
                where c_codure = 'HB01'
                  and to_date(d_fecrec,'dd/mm/yy') >= to_date(pd_fecini,'dd/mm/yy')
                  and to_date(d_fecrec,'dd/mm/yy') <= to_date(pd_fecfin,'dd/mm/yy')
                  and c_codmor is not null 
                  and c_codopr is not null
             order by d_fecrec;
     commit;        
     ps_coderr := '0000';
  exception when others then
     ps_coderr := '9999';
  end;
end sp_op_reprecenvema;
/

