CREATE OR REPLACE Function fn_monto_cuota (PN_PGCOD in Number,
                                           PN_MOD   in Number,
                                           PN_SUC   in Number,
                                           PN_MDA   in Number,
                                           PN_PAP   in Number,
                                           PN_CTA   in Number,
                                           PN_OPE   in Number,
                                           PN_SBO   in Number,
                                           PN_TOP   in Number,
                                           PD_FEC   in Date
                                          )
 Return Number
 Is
   ln_mtocuo number(12,2);
   ln_mtoseg number(12,2);
   ln_suc    number(3);
   ld_fecpag date;
 Begin
      Begin
        Select ppfpag,mtocuo
          Into ld_fecpag,ln_mtocuo
          From (
                select p.ppfpag,nvl(p.ppcap,0) + nvl(p.ppint,0) mtocuo
                  from fsd601 p
                 where p.pgcod = PN_PGCOD
                   and p.ppmod = PN_MOD
                   and p.ppsuc = PN_SUC
                   and p.ppmda = PN_MDA
                   and p.pppap = PN_PAP
                   and p.ppcta = PN_CTA
                   and p.ppoper= PN_OPE
                   and p.ppsbop= PN_SBO
                   and p.pptope= PN_TOP
                   and p.d601co= 'S'
                   and (p.ppcap + p.ppint ) > 0
                   and not exists (Select 1 From fsd602 c
                                     Where c.pgcod = p.pgcod
                                       and c.ppmod = p.ppmod
                                       and c.ppsuc = p.ppsuc
                                       and c.ppmda = p.ppmda
                                       and c.pppap = p.pppap
                                       and c.ppcta = p.ppcta
                                       and c.ppoper= p.ppoper
                                       and c.ppsbop= p.ppsbop
                                       and c.pptope= p.pptope
                                       and c.ppfpag= p.ppfpag
                                       and c.pptipo= p.pptipo
                                       and c.pp1stat= 'T'
                                       and c.d602co = 'S'
                                       and c.d602fc <= PD_FEC)
                 Order by p.ppfpag
                )
        Where Rownum=1;
        ln_suc := PN_SUC;
      Exception
      When No_Data_Found Then
           Begin
              Select ppfpag,mtocuo
                Into ld_fecpag,ln_mtocuo
                From (
                      select p.ppfpag,nvl(p.ppcap,0) + nvl(p.ppint,0) mtocuo
                        from fsd601 p
                       where p.pgcod = PN_PGCOD
                         and p.ppmod = PN_MOD
                         and p.ppmda = PN_MDA
                         and p.pppap = PN_PAP
                         and p.ppcta = PN_CTA
                         and p.ppoper= PN_OPE
                         and p.ppsbop= PN_SBO
                         and p.pptope= PN_TOP
                         and p.d601co= 'S'
                         and (p.ppcap + p.ppint ) > 0
                         and not exists (Select 1 From fsd602 c
                                           Where c.pgcod = p.pgcod
                                             and c.ppmod = p.ppmod
                                             and c.ppsuc = p.ppsuc
                                             and c.ppmda = p.ppmda
                                             and c.pppap = p.pppap
                                             and c.ppcta = p.ppcta
                                             and c.ppoper= p.ppoper
                                             and c.ppsbop= p.ppsbop
                                             and c.pptope= p.pptope
                                             and c.ppfpag= p.ppfpag
                                             and c.pptipo= p.pptipo
                                             and c.pp1stat= 'T'
                                             and c.d602co = 'S'
                                             and c.d602fc <= PD_FEC)
                       Order by p.ppfpag
                      );
           Exception When Others Then
                ln_mtocuo := 0;
           End;
      When Others Then
         ln_mtocuo := 0;
      End;

      Begin
        select sum(nvl(s.ppimp10,0)+nvl(s.ppimp11,0)+nvl(s.ppimp12,0))
          into ln_mtoseg
          from fsd611 s
         where s.pgcod = PN_PGCOD
           and s.ppmod = PN_MOD
           and s.ppsuc = ln_suc
           and s.ppmda = PN_MDA
           and s.pppap = PN_PAP
           and s.ppcta = PN_CTA
           and s.ppoper= PN_OPE
           and s.ppsbop= PN_SBO
           and s.pptope= PN_TOP
           and s.ppfpag= ld_fecpag;
      Exception When Others Then
         ln_mtoseg := 0;
      End;

      Return (nvl(ln_mtocuo,0) + nvl(ln_mtoseg,0));

 End fn_monto_cuota;
/

