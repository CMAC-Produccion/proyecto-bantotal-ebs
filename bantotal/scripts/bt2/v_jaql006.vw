create or replace force view v_jaql006 as
select
a.jaql6fetra,a.jaql6hotra,a.jaql6seint,
decode(a.jaql6nutar,b.Z0E478NRO,substr(a.jaql6nutar,0,6)||'******'||substr(a.jaql6nutar,13,4),a.jaql6nutar) jaql6nutar,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.jaql6comen,a.jaql6seiso,a.jaql6cotra,a.jaql6fehot,a.jaql6feneg,a.jaql6honeg,a.jaql6inadq,a.jaql6inemi,a.jaql3cored,a.jaql9nuele,
a.jaql6cisoc,a.jaql6cisot,a.jaql6comot,a.jaql6comtb,a.jaql6imptr,a.jaql6cod01,a.jaql6mod01,a.jaql6suc01,a.jaql6mda01,a.jaql6pap01,
a.jaql6cta01,a.jaql6ope01,a.jaql6sbo01,a.jaql6top01,a.jaql6imp01,a.jaql6sal01,a.jaql6ord01,a.jaql6sub01,a.jaql6cod02,a.jaql6mod02,
a.jaql6suc02,a.jaql6mda02,a.jaql6pap02,a.jaql6cta02,a.jaql6ope02,a.jaql6sbo02,a.jaql6top02,a.jaql6imp02,a.jaql6sal02,a.jaql6ord02,
a.jaql6sub02,a.jaql6ctcod,a.jaql6ctmod,a.jaql6ctsuc,a.jaql6cttra,a.jaql6ctrel,a.jaql6ctfco,a.jaql6ctcrr,a.jaql6ctres,a.jaql6secan,
a.jaql6seope,a.jaql6sevar,a.jaql6sefec,a.jaql6sehor,a.jaql6secre,a.jaql6secrs,a.jaql6morec,a.jaql6comoc,a.jaql6comcb,a.jaql6gineg,
a.jaql6adic1,a.jaql6adic2,a.jaql6adic3,a.jaql6feimp,a.jaql6coaut,a.jaql6estad,a.jaql6ctcor,a.jaql6ctmor,a.jaql6ctsur,a.jaql6cttrr,
a.jaql6ctrer,a.jaql6ctfcr,a.jaql6coapl,a.jaql6aux1,a.jaql6aux2,a.jaql6aux3,a.jaql6aux4,a.jaql6aux5,a.jaql6aux6,a.jaql6aux7,a.jaql6aux8,
a.jaql6aux9,a.jaql6aux10,a.jaql6aux11,a.jaql6aux12,a.jaql6aux13,a.jaql6aux14,a.jaql6aux15,a.jaql6aux16,a.jaql6aux17,a.jaql6aux18
from JAQL006 a left outer join Z0E478 b
  on a.jaql6nutar=b.Z0E478NRO;

