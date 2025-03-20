create or replace procedure SP_REGISTRO_SEG_FSD602 is

  /* ************************************************************************************************************
      -- Nombre                     : SP_REGISTRO_SEG_FSD602
      -- Sistema                    : BANTOTAL
      -- M�dulo                     : DPF
      -- Descripci�n                : Crea FSD602 para los pagos de seguros
      -- Versi�n                    : 1.0
      -- Fecha de Creaci�n          : 
      -- Autor de Creaci�n          : Mersal� Araujo
      -- Versi�n                    : 2.0
      -- Fecha de Modificaci�n      : 07/06/2019
      -- Autor de la Modificaci�n   : Mersal� Araujo
      -- Descripci�n de Modificaci�n: Se hace llamado a pq_ah_calc_dpf
      --
      
      -- Fecha de Modificaci�n      : 08/04/22
      -- Autor de la Modificaci�n   : Mersal� Araujo
      -- Descripci�n de Modificaci�n: se quita todo el rec�lculo, se deja insert simple
  * *************************************************************************************************************/

  ld_pgfape date;

  cursor seg is
    select a.*
      from fsd016 a, fsd015 b
     where b.pgcod = 1
       and b.itsuc in (11, 904)
       and b.itmod = 98
       and b.ittran in (291, 293)
       and a.modulo = 426
       and a.itafgt = 'C'
       and a.itanu = 'N'
       and a.pgcod = b.pgcod
       and a.itsuc = b.itsuc
       and a.itmod = b.itmod
       and a.ittran = b.ittran
       and a.itnrel = b.itnrel
       and b.itcorr = 0
       and b.itcont = 'S'
       and b.itfcon = ld_pgfape;

  ln_correl number;
  vpgcod    number(3);
  vppmod    number(3);
  vppsuc    number(3);
  vppmda    number(4);
  vpppap    number(4);
  vppcta    number(9);
  vppoper   number(9);
  vppsbop   number(3);
  vpptope   number(3);
  vppfpag   date;

begin
  vpgcod := 1;

  select pgfape into ld_pgfape from fst017 where pgcod = 1;

  for i in seg loop
  
    select aomod,
           aosuc,
           aomda,
           aopap,
           aocta,
           aooper,
           aosbop,
           aotope,
           aofvto
      into vppmod,
           vppsuc,
           vppmda,
           vpppap,
           vppcta,
           vppoper,
           vppsbop,
           vpptope,
           vppfpag
      from fsd010
     where pgcod = vpgcod
       and aomod = 22
          --and aosuc = i.itsucd
       and aocta = i.ctnro
       and aooper = i.itoper
       and aosbop = i.itsubo
       and aomda = i.moneda;
       
    begin
      select nvl(max(pp1nump), 0)
        into ln_correl
        from fsd602
       where pgcod = vpgcod
         and ppmod = vppmod
         and ppsuc = vppsuc
         and ppmda = vppmda
         and pppap = vpppap
         and ppcta = vppcta
         and ppoper = vppoper
         and ppsbop = vppsbop
         and pptope = vpptope
         and ppfpag = vppfpag
         and Pptipo = 'M';
    exception
      when no_data_found then
        ln_correl := 0;
    end;
  
    ln_correl := ln_correl + 1;
  
    insert into fsd602
    values
      (vpgcod,
       vppmod,
       vppsuc,
       vppmda,
       vpppap,
       vppcta,
       vppoper,
       vppsbop,
       vpptope,
       vppfpag,
       'M',
       ln_correl,
       ld_pgfape,
       0, -- &Pp1icap
       i.itimp1,
       0,
       0,
       0,
       0,
       0, -- Pp1iint
       0, --Pp1iintm
       0, --Pp1salcap
       0,
       0,
       1,
       'P',
       0,
       0,
       0,
       i.pgcod,
       i.Itmod,
       i.Itsuc,
       i.Ittran,
       i.Itnrel,
       ld_pgfape,
       i.Itord,
       i.Itsbor,
       'S');
  
    commit;
  end loop;

end SP_REGISTRO_SEG_FSD602;
/

