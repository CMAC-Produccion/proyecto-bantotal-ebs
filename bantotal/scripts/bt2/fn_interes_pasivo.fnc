create or replace function FN_INTERES_PASIVO(vpgcod  number,
                                             vdvmod  number,
                                             vdvmda  number,
                                             vdvpap  number,
                                             vdvcta  number,
                                             vdvsuc  number,
                                             vdvoper number,
                                             vdvsbop number,
                                             vdvtope number) return number is
  interes number;
begin

  if vdvmod = 21 then
    if vdvtope <> 2 then
      select nvl(decode(dvtint, 0, dvimpax1, dvtint), 0)
        into interes
        from fsd313
       where pgcod = vpgcod
         and dvmod = vdvmod
         and dvmda = vdvmda
         and dvpap = vdvpap
         and dvcta = vdvcta
         and dvsuc = vdvsuc
         and dvoper = vdvoper
         and dvsbop = vdvsbop
         and dvtope = vdvtope;
    else
    
      select scsdo
        into interes
        from fsd011
       where pgcod = vpgcod
         and scmod = 429
         and scmda = vdvmda
         and scpap = vdvpap
         and sccta = vdvcta
         and scsuc = vdvsuc
         and scoper = vdvoper
         and scsbop = vdvsbop
         and sctope = 0;
    end if;
  else
    select scsdo
      into interes
      from fsd011
     where pgcod = vpgcod
       and scmod = 426
       and scmda = vdvmda
       and scpap = vdvpap
       and sccta = vdvcta
       and scsuc = vdvsuc
       and scoper = vdvoper
       and scsbop = vdvsbop
       and sctope = 0;
  end if;

  return(interes);
exception
  when no_data_found then
    return(0);
end FN_INTERES_PASIVO;
/

