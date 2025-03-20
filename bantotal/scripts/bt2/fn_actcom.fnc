create or replace function fn_ActCom(pd_fecini in date, pd_fecfin in date) return number is
ln_respro number;
Begin
   Begin
   ln_respro := 0;
   INSERT INTO jaql802 (JAQL802COENT,JAQL802COSUC,JAQL802COMOD,JAQL802COTRA,JAQL802NUREL,
                        JAQL802NUORD,JAQL802FEOPE,JAQL802HOTRA,JAQL802COCUE,JAQL802COOPE,
                        JAQL802NOREG,JAQL802NOCAN,JAQL802DECAN,JAQL802CORUB,JAQL802DECOM,
                        JAQL802DEMON,JAQL802MOCOM,JAQL802TICOM,JAQL802SUORD)
   Select /*+all_rows parallel(a,4) parallel(b,4) parallel(m,4) parallel(c,4) parallel(d,4)*/ 
          b.pgcod,b.hsucor,b.hcmod,b.htran,b.hnrel,
          b.hcord,a.hfcon,a.hhora,b.hcta,a.husing,
          x.regnom,case when c.sucurs <= 899 then 'Agencia' else c.scnom end,c.scnom,b.hrubro,m.pcnomr,
          d.mosign,b.hcimp1,substr(j.trnom,1,30),b.hcsubo
     from fsh015 a,fsh016 b,fsd014 m,fst001 c,fst005 d,
          (select d.oficod, e.regnom
             from fst811 d, fst810 e
            where d.regcod < 100
              and d.ofisuc = 'S'
              and e.pgcod = d.pgcod
              and e.regcod = d.regcod) x,
          fst034 j
    where a.hfcon BETWEEN pd_fecini and pd_fecfin
      and a.pgcod = 1
      and a.pgcod = b.pgcod
      and a.hsucor = b.hsucor
      and a.hcmod = b.hcmod
      and a.htran = b.htran
      and a.hnrel = b.hnrel
      and a.hfcon = b.hfcon
      and m.rubro = b.hrubro
      and c.pgcod = a.pgcod
      and c.sucurs = a.hsucor
      and x.oficod(+) = b.hsucor
      and a.hccorr <> 99
      and b.hrubro like '52%'
      and b.hcimp1 > 0
      and b.hmda = d.moneda
      and b.pgcod = j.pgcod
      and b.hcmod = j.trmod
      and b.htran = j.trnro;
    commit;
    exception
    when others then
       ln_respro := 1;
    end;
   If ln_respro = 0 then
      Begin
      Update jaql802 a Set (a.JAQL802TIDOC,a.JAQL802NUDOC,a.JAQL802NOTIT,a.JAQL802SECOM) =
             (Select b.tdnom,c.pendoc,d.penom,FN_TIPCLI(c.pendoc,c.petdoc)
                From fst014 b,fsr008 c,fsd001 d
               Where a.JAQL802COCUE > 0
                 and a.JAQL802FEOPE BETWEEN pd_fecini and pd_fecfin
                 and a.JAQL802COCUE = c.ctnro
                 and c.ttcod = 1
                 and c.cttfir = 'T'
                 and c.pepais = d.pepais
                 and c.petdoc = d.petdoc
                 and c.pendoc = d.pendoc
                 and c.petdoc = b.tdocum);
      commit;
      exception
      when others then
         ln_respro := 2;
      end;
   end if;
   return ln_respro;
end;
/

