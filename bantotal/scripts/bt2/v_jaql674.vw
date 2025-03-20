create or replace force view v_jaql674 as
select
a.jaql674fetra, a.jaql674hotra, a.jaql674seint,
decode(a.jaql674nutar,b.Z0E478NRO,substr(a.jaql674nutar,0,6)||'******'||substr(a.jaql674nutar,13,4),a.jaql674nutar) jaql674nutar,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.jaql674comen, a.jaql674seiso, a.jaql674cotra, a.jaql674fehot, a.jaql674feneg, a.jaql674honeg, a.jaql674inadq, a.jaql674inemi, a.jaql674cored,
a.jaql674nuele, a.jaql674cisoc, a.jaql674cisot, a.jaql674comot, a.jaql674comtb, a.jaql674imptr, a.jaql674cod01, a.jaql674mod01, a.jaql674suc01,
a.jaql674mda01, a.jaql674pap01, a.jaql674cta01, a.jaql674ope01, a.jaql674sbo01, a.jaql674top01, a.jaql674imp01, a.jaql674sal01, a.jaql674ord01,
a.jaql674sub01, a.jaql674cod02, a.jaql674mod02, a.jaql674suc02, a.jaql674mda02, a.jaql674pap02, a.jaql674cta02, a.jaql674ope02, a.jaql674sbo02,
a.jaql674top02, a.jaql674imp02, a.jaql674sal02, a.jaql674ord02, a.jaql674sub02, a.jaql674ctcod, a.jaql674ctmod, a.jaql674ctsuc, a.jaql674cttra,
a.jaql674ctrel, a.jaql674ctfco, a.jaql674ctcrr, a.jaql674ctres, a.jaql674secan, a.jaql674seope, a.jaql674sevar, a.jaql674sefec, a.jaql674sehor,
a.jaql674secre, a.jaql674secrs, a.jaql674morec, a.jaql674comoc, a.jaql674comcb, a.jaql674gineg, a.jaql674adic1, a.jaql674adic2, a.jaql674adic3,
a.jaql674feimp, a.jaql674coaut, a.jaql674estad, a.jaql674ctcor, a.jaql674ctmor, a.jaql674ctsur, a.jaql674cttrr, a.jaql674ctrer, a.jaql674ctfcr,
a.jaql674coapl, a.jaql674aux1, a.jaql674aux2, a.jaql674aux3, a.jaql674aux4, a.jaql674aux5, a.jaql674aux6, a.jaql674aux7, a.jaql674aux8, a.jaql674aux9,
a.jaql674aux10, a.jaql674aux11, a.jaql674aux12, a.jaql674aux13, a.jaql674aux14, a.jaql674aux15, a.jaql674aux16, a.jaql674aux17, a.jaql674aux18
from jaql674 a left outer join Z0E478 b
  on a.jaql674nutar=b.Z0E478NRO;

