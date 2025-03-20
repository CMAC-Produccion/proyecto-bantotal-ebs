CREATE OR REPLACE PROCEDURE SP_DEPO_CV(VPGCOD  number,
                                       VSCSUC  number,
                                       VSCMOD  number,
                                       VSCMDA  number,
                                       VSCPAP  number,
                                       VSCCTA  number,
                                       VSCOPER number,
                                       VSCSBOP number,
                                       VSCTOPE number,
                                       VFECINI date,
                                       VFECFIN date,
                                       SUCORI  out number,
                                       FCON    out date,
                                       PTRMOD  out number,
                                       PTRNRO  out number,
                                       NREL    out number,
                                       IMPMOV  out number) IS

BEGIN

  begin
    select hsucor, hfvc, hcmod, htran, hnrel, Hcimp1
      into SUCORI, FCON, PTRMOD, PTRNRO, NREL, IMPMOV
      from (select e.hsucor, g.hfvc, e.hcmod, e.htran, e.hnrel, e.Hcimp1
              from fsh016 e, fsh015 g, fst198 h
             where e.pgcod = g.pgcod
               and e.hsucor = g.hsucor
               and e.hcmod = g.hcmod
               and e.htran = g.htran
               and e.hnrel = g.hnrel
               and e.hfvco = g.hfvc
               and g.hccorr <> 99
               and h.tp1cod = e.Pgcod
               and h.Tp1cod1 = 10820
               and h.Tp1corr1 = 4
               and e.Pgcod = VPGCOD
               and e.Hsucur = VSCSUC
               and e.Hmodul = VSCMOD
               and e.Hmda = VSCMDA
               and e.Hpap = VSCPAP
               and e.Hcta = VSCCTA
               and e.Hoper = VSCOPER
               and e.Hsubop = VSCSBOP
               and e.Htoper = VSCTOPE
               and e.Hcmod = h.tp1nro1
               and e.Htran = h.tp1nro2
               and e.Hfvco between VFECINI and VFECFIN
            --and Hcodmo = 2
             order by hfvc, hhora, Hcimp1 desc) V
     where rownum = 1;
  exception
    when no_data_found then
      begin
        select itsuc, itfvc, itmod, ittran, itnrel, itimp1
          into SUCORI, FCON, PTRMOD, PTRNRO, NREL, IMPMOV
          from (select d.itsuc,
                       c.itfvc,
                       d.itmod,
                       d.ittran,
                       d.itnrel,
                       d.itimp1
                  from fsd016 d, fsd015 c, fst198 h
                 where c.pgcod = d.pgcod
                   and d.itsuc = c.itsuc
                   and d.itmod = c.itmod
                   and d.ittran = c.ittran
                   and d.itnrel = c.itnrel
                   and c.pgcod = 1
                   and c.itcont = 'S'
                   and d.itanu = 'N'
                   and c.itcorr <> 99
                   and h.tp1cod = d.Pgcod
                   and h.Tp1cod1 = 10820
                   and h.Tp1corr1 = 4
                   and h.tp1cod = VPgcod
                   and d.Itsucd = VScsuc
                      --and d.Rubro = &Rubro
                   and d.modulo = Vscmod
                   and d.Moneda = VScmda
                   and d.Papel = VScpap
                   and d.Ctnro = VSccta
                   and d.Itoper = VScoper
                   and d.Itsubo = VScsbop
                   and d.Ittope = VSctope
                   and c.itmod = h.tp1nro1
                   and c.ittran = h.tp1nro2
                   and c.itfvc between VFECINI and VFECFIN
                 order by itfvc, ithora)
         where rownum = 1;
      exception
        when no_data_found then
          begin
            select 0, JAQL453FEC, 0, 0, 1, JAQL453TOT
              into SUCORI, FCON, PTRMOD, PTRNRO, NREL, IMPMOV
              from jaql453
             where JAQL453COD = vpgcod
               and JAQL453MOD = vscmod
               and JAQL453TOP = vSctope
               and JAQL453MDA = vScmda
               and JAQL453PAP = vScpap
               and JAQL453CTA = vSccta
               and JAQL453OPE = vScoper
               and JAQL453SBO = vScsbop 
               and JAQL453FEC between VFECINI and VFECFIN;
          exception
            when others then
              NREL   := 0;
              IMPMOV := 0;
          end;
      end;
  end;
end SP_DEPO_CV;
/

