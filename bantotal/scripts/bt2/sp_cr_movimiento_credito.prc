create or replace procedure sp_cr_movimiento_credito(pn_pgcod  number,
                                                     pn_ppmod  number,
                                                     pn_ppsuc  number,
                                                     pn_PPMDA  number,
                                                     pn_PPPAP  number,
                                                     pn_PPCTA  number,
                                                     pn_PPOPER number,
                                                     pn_PPSBOP number,
                                                     pn_PPTOPE number) is
  pc_usuario varchar(18);

begin

  pc_usuario := to_char(pn_PPCTA) || to_char(pn_PPOPER);
  pc_usuario := trim(pc_usuario);
  --delete from jaqz207 where trim(JAQZ207USER) = pc_usuario;
  delete from jaqz207 where JAQZ207USER = pc_usuario;

  insert into jaqz207
    select rownum, pc_usuario, x.*
      from (select PGCOD,
                   PPMOD,
                   PPSUC,
                   PPMDA,
                   PPPAP,
                   PPCTA,
                   PPOPER,
                   PPSBOP,
                   PPTOPE,
                   sum(MONTO) MONTO,
                   PP1FECH,
                   D602CD,
                   D602MO,
                   D602SU,
                   D602TR,
                   D602RE,
                   D602FC
              from (select a.PGCOD,
                           a.PPMOD,
                           a.PPSUC,
                           a.PPMDA,
                           a.PPPAP,
                           a.PPCTA,
                           a.PPOPER,
                           a.PPSBOP,
                           a.PPTOPE,
                           a.PP1NUMP,
                           a.PP1CAP + a.PP1INT + a.PP1INTM +
                           decode(b.pp1imp11, null, 0, b.pp1imp11) +
                           decode(b.pp1imp12, null, 0, b.pp1imp12) +
                           decode(b.pp1imp13, null, 0, b.pp1imp13) +
                           decode(b.pp1imp14, null, 0, b.pp1imp14) +
                           decode(b.pp1imp15, null, 0, b.pp1imp15) monto,
                           a.PP1FECH,
                           a.D602CD,
                           a.D602MO,
                           a.D602SU,
                           a.D602TR,
                           a.D602RE,
                           a.D602FC
                      from fsd602 a
                      left join fsd612 b
                        on (a.PGCOD = b.PGCOD and a.PPMOD = b.PPMOD and
                           a.PPSUC = b.PPSUC and a.PPMDA = b.PPMDA and
                           a.PPPAP = b.PPPAP and a.PPCTA = b.PPCTA and
                           a.PPOPER = b.PPOPER and a.PPSBOP = b.PPSBOP and
                           a.PPTOPE = b.PPTOPE and a.PPFPAG = b.PPFPAG and
                           a.PPTIPO = b.PPTIPO and a.PP1NUMP = b.PP1NUMP)
                     where a.PGCOD = pn_pgcod
                       and a.PPMOD = pn_ppmod
                       and a.PPSUC = pn_ppsuc
                       and a.PPMDA = pn_PPMDA
                       and a.PPPAP = pn_PPPAP
                       and a.PPCTA = pn_PPCTA
                       and a.PPOPER = pn_PPOPER
                       and a.PPSBOP = pn_PPSBOP
                       and a.PPTOPE = pn_PPTOPE
                       and a.d602co = 'S'
                     group by a.PGCOD,
                              a.PPMOD,
                              a.PPSUC,
                              a.PPMDA,
                              a.PPPAP,
                              a.PPCTA,
                              a.PPOPER,
                              a.PPSBOP,
                              a.PPTOPE,
                              a.PP1NUMP,
                              a.PP1FECH,
                              a.PP1CAP,
                              a.PP1INT,
                              a.PP1INTM,
                              a.D602CD,
                              a.D602MO,
                              a.D602SU,
                              a.D602TR,
                              a.D602RE,
                              a.D602FC,
                              b.pp1imp11,
                              b.pp1imp12,
                              b.pp1imp13,
                              b.pp1imp14,
                              b.pp1imp15
                     order by a.pp1nump desc)
             group by PGCOD,
                      PPMOD,
                      PPSUC,
                      PPMDA,
                      PPPAP,
                      PPCTA,
                      PPOPER,
                      PPSBOP,
                      PPTOPE,
                      PP1FECH,
                      D602CD,
                      D602MO,
                      D602SU,
                      D602TR,
                      D602RE,
                      D602FC
             order by PP1FECH desc
            
            ) x
     where rownum <= 7
    
     order by PP1FECH desc;
  commit;
end sp_cr_movimiento_credito;
/

