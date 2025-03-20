create or replace force view v_aqpb119 as
select
aqpb119fetra,aqpb119hotra, aqpb119seint,
decode(a.aqpb119nutar,b.Z0E478NRO,substr(a.aqpb119nutar,0,6)||'******'||substr(a.aqpb119nutar,13,4),a.aqpb119nutar) aqpb119nutar,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
aqpb119comen, aqpb119descme, aqpb119seiso, aqpb119cotra, aqpb119desctr, aqpb119fehot,
aqpb119feneg, aqpb119honeg, aqpb119inadq, aqpb119inemi, aqpb119cored, aqpb119nuele, aqpb119cisoc, aqpb119cisot, aqpb119comot, aqpb119comtb,
aqpb119imptr, aqpb119cod01, aqpb119mod01, aqpb119suc01, aqpb119mda01, aqpb119pap01, aqpb119cta01, aqpb119ope01, aqpb119sbo01, aqpb119top01,
aqpb119imp01, aqpb119sal01, aqpb119ord01, aqpb119sub01, aqpb119cod02, aqpb119mod02, aqpb119suc02, aqpb119mda02, aqpb119pap02, aqpb119cta02,
aqpb119ope02, aqpb119sbo02, aqpb119top02, aqpb119imp02, aqpb119sal02, aqpb119ord02, aqpb119sub02, aqpb119ctcod, aqpb119ctmod, aqpb119ctsuc,
aqpb119cttra, aqpb119ctrel, aqpb119ctfco, aqpb119ctcrr, aqpb119ctres, aqpb119secan, aqpb119seope, aqpb119sevar, aqpb119sefec, aqpb119sehor,
aqpb119secre, aqpb119secrs, aqpb119morec, aqpb119comoc, aqpb119comcb, aqpb119gineg, aqpb119adic1, aqpb119adic2, aqpb119adic3, aqpb119feimp,
aqpb119coaut, aqpb119estad, aqpb119ctcor, aqpb119ctmor, aqpb119ctsur, aqpb119cttrr, aqpb119ctrer, aqpb119ctfcr, aqpb119coapl, aqpb119aux1,
aqpb119aux2, aqpb119aux3, aqpb119aux4, aqpb119aux5, aqpb119aux6, aqpb119aux7, aqpb119aux8, aqpb119aux9, aqpb119aux10, aqpb119aux11, aqpb119aux12,
aqpb119aux13, aqpb119aux14, aqpb119aux15, aqpb119aux16, aqpb119aux17, aqpb119aux18
 from AQPB119 a left outer join Z0E478 b
  on a.aqpb119nutar=b.Z0E478NRO;

