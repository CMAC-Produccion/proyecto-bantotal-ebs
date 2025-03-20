CREATE OR REPLACE TRIGGER TG_SNG131_INS_JAQY166
  before insert on SNG131  
  for each row
  
DECLARE
  
   l_r1cod fsr011.r1cod%type := null;
   l_r1suc fsr011.r1suc%type := null;
   l_r1mda fsr011.r1mda%type := null;
   l_r1pap fsr011.r1pap%type := null;
   l_r1cta fsr011.r1cta%type := null;
   l_r1oper fsr011.r1oper%type := null;
   l_r1sbop fsr011.r1sbop%type := null;
   l_r1tope fsr011.r1tope%type := null;
   l_r1mod fsr011.r1mod%type := null;
   l_scsdo fsd011.scsdo%type := null;
   l_scsdo_mn fsd011.scsdo%type := null;
   l_cotcbi fsh005.cotcbi%type := null;
  
BEGIN

	select cotcbi
	  into l_cotcbi
	  from (select * from fsh005 where moneda = 101 order by cofdes desc)
	 where rownum = 1;    
    
   IF :new.SNG131MOD = 117 THEN  
      begin
         select s.pgcod, s.scsuc, s.scmda, s.scpap, s.sccta, s.scoper, s.scsbop, s.sctope, s.scmod, sum(s.scsdo) scsdo,
                decode(s.scmda, 101, sum(s.scsdo)*l_cotcbi, sum(s.scsdo)) scsdo_mn 
           into l_r1cod, l_r1suc, l_r1mda, l_r1pap, l_r1cta, l_r1oper, l_r1sbop, l_r1tope, l_r1mod, l_scsdo, l_scsdo_mn
           from fsr011 r
          inner join fsd011 s on s.pgcod = r.r1cod
                            and s.scsuc = r.r1suc
                            and s.scmda = r.r1mda
                            and s.scpap = r.r1pap
                            and s.sccta = r.r1cta
                            and s.scoper = r.r1oper
                            and s.scsbop = r.r1sbop
                            and s.sctope = r.r1tope
                            and s.scmod = r.r1mod 
          where r.r2cod = :new.SNG131PGC
            and r.r2mod = :new.SNG131MOD
            and r.r2suc = :new.SNG131SUC
            and r.r2mda = :new.SNG131MDA
            and r.r2pap = :new.SNG131PAP
            and r.r2cta = :new.SNG131CTA
            and r.r2oper = :new.SNG131OPE
            and r.r2sbop = :new.SNG131SBO
            and r.r2tope = :new.SNG131TOP
            and r.relcod = 46
            and s.scstat = 0
            and s.scrub in (select rubro
                              from fsd014
                             where pcnivc = s.scmod
                               and pcimpu = 'S'
                               and pmtit <> 9)
          group by s.pgcod, s.scsuc, s.scmda, s.scpap, s.sccta, s.scoper, s.scsbop, s.sctope, s.scmod ;  

      exception
         when others then      
              l_r1cod := null;  
              l_r1suc := null; 
              l_r1mda := null;
              l_r1pap := null;
              l_r1cta := null;
              l_r1oper := null;
              l_r1sbop := null;
              l_r1tope := null;
              l_r1mod := null;
              l_scsdo := null;
              l_scsdo_mn := null;
      end;
      
   ELSE
   
      begin
         select sum(s.scsdo) scsdo, decode(s.scmda, 101, sum(s.scsdo)*l_cotcbi, sum(s.scsdo)) scsdo_mn 
           into l_scsdo, l_scsdo_mn 
           from fsd011 s           
          where s.pgcod = :new.SNG131PGC
            and s.scmod = :new.SNG131MOD
            and s.scsuc = :new.SNG131SUC
            and s.scmda = :new.SNG131MDA
            and s.scpap = :new.SNG131PAP
            and s.sccta = :new.SNG131CTA
            and s.scoper = :new.SNG131OPE
            and s.scsbop = :new.SNG131SBO
            and s.sctope = :new.SNG131TOP
            and s.scrub in (select rubro
                              from fsd014
                             where pcnivc = s.scmod
                               and pcimpu = 'S'
                               and pmtit <> 9)
          group by s.pgcod, s.scsuc, s.scmda, s.scpap, s.sccta, s.scoper, s.scsbop, s.sctope, s.scmod;  

      exception
         when others then      
              l_scsdo := null;
              l_scsdo_mn := null;
      end;
      
   END IF;
   
   insert into JAQY167
      (SNG130COR,
       SNG131PGC,
       SNG131MOD,
       SNG131SUC,
       SNG131MDA,
       SNG131PAP,
       SNG131CTA,
       SNG131OPE,
       SNG131SBO,
       SNG131TOP,
       JAQY167COR,
       JAQY167COD,
       JAQY167MOD,
       JAQY167SUC,
       JAQY167MDA,
       JAQY167PAP,
       JAQY167CTA,
       JAQY167OPE,
       JAQY167SBO,
       JAQY167TOP,
       JAQY167SDO,
       JAQY167SDOMN)
   values
      (:new.SNG130COR,
       :new.SNG131PGC,
       :new.SNG131MOD,
       :new.SNG131SUC,
       :new.SNG131MDA,
       :new.SNG131PAP,
       :new.SNG131CTA,
       :new.SNG131OPE,
       :new.SNG131SBO,
       :new.SNG131TOP,
       1,
       l_r1cod,
       l_r1mod,
       l_r1suc,
       l_r1mda,
       l_r1pap,
       l_r1cta,
       l_r1oper,
       l_r1sbop,
       l_r1tope,	 
       l_scsdo,
       l_scsdo_mn); 
   
END TG_SNG131_INS_JAQY166;
/

