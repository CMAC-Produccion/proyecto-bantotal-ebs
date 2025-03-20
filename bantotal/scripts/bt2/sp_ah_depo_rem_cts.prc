CREATE OR REPLACE PROCEDURE SP_AH_DEPO_REM_CTS(VPGCOD  number,
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
                                               VTIPO   number,
                                               SUCORI  out number,
                                               FCON    out date,
                                               PTRMOD  out number,
                                               PTRNRO  out number,
                                               NREL    out number,
                                               IMPMOV  out number) IS
                                               
   -- *****************************************************************
    -- Nombre                     : SP_AH_DEPO_REM_CTS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : CTS
    -- Versión                    : 
    -- Fecha de Creación          : 
    -- Autor de Creación          : Mersalí Araujo
    -- Uso                        : Devuelve último depósito en un rango d fechas
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :
    -- Retorno                    : 
    -- Fecha de Modificación      : 2024.11.27
    -- Autor de la Modificación   : Mersalí Araujo
    -- Descripción de Modificación: Se agregó filtro de fecha al buscar cheques

    -- *****************************************************************
-----------------------------------------------------------------------
                                               
  masivo    number;
  ctsrem    char(1);
  asiento   char(1);
  vscoper_c number;
  vscsbop_c number;
  vscmda_c  number;
  vScsuc_c  number;

  cursor movi is
    select e.hsucor SUCORI,
           g.hfvc FCON,
           e.hcmod PTRMOD,
           e.htran PTRNRO,
           e.hnrel NREL,
           e.Hcimp1 IMPMOV,
           h.tp1imp2 masivo,
           'H' asiento
      from fsh016 e, fsh015 g, fst198 h
     where e.pgcod = g.pgcod
       and e.hsucor = g.hsucor
       and e.hcmod = g.hcmod
       and e.htran = g.htran
       and e.hnrel = g.hnrel
       and e.hfvco = g.hfvc
       and g.hccorr <> 99
       and e.hcafgt = 'C'
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
       and h.tp1imp1 in (vtipo, 3)
    union
    select d.itsuc,
           c.itfvc,
           d.itmod,
           d.ittran,
           d.itnrel,
           d.itimp1,
           h.tp1imp2,
           'D'
      from fsd016 d, fsd015 c, fst198 h
     where c.pgcod = d.pgcod
       and d.itsuc = c.itsuc
       and d.itmod = c.itmod
       and d.ittran = c.ittran
       and d.itnrel = c.itnrel
       and c.pgcod = VPGCOD
       and c.itcont = 'S'
       and d.itanu = 'N'
       and c.itcorr <> 99       
       and d.itafgt = 'C'
       and h.tp1cod = d.Pgcod
       and h.Tp1cod1 = 10820
       and h.Tp1corr1 = 4
       and h.tp1cod = VPgcod
       and d.Itsucd = VScsuc
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
       and h.tp1imp1 in (vtipo, 3)
    union
    select 0, JAQL453FEC, 0, 0, 1, JAQL453TOT, 0, 'x'
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

BEGIN

  for i in movi loop
  
    vscoper_c := 0;
    vscsbop_c := 0;
    vscmda_c  := 0;
    vScsuc_c  := 0;
  
    if i.NREL <> 0 and vtipo = 2 and i.masivo = 1 and
       i.FCON >= to_date('01/08/2017', 'dd/mm/yyyy') then
      -- si es remuneración y es masivo y fecha desde que se activó abonos mixtos
      if i.PTRMOD = 99 and i.PTRNRO = 280 then
        -- si es abono masivo distinto a cheque verifica que sea por cts o remu
        begin
          select 'S'
            into ctsrem
            from jaql071 m
           where m.jaql71itcd = vpgcod
             and jaql71itsu = i.SUCORI
             and jaql71itmo = i.PTRMOD
             and jaql71ittr = i.PTRNRO
             and jaql71itre = i.NREL
             and m.jaql71itfc = i.FCON
             and JAQL71TIAB in ('C', 'R')
             and jaql71esta = 'P';
        
          NREL   := i.nrel;
          IMPMOV := i.IMPMOV;
          SUCORI := i.SUCORI;
          FCON   := i.FCON;
          PTRMOD := i.PTRMOD;
          PTRNRO := i.PTRNRO;
          
          exit;
        
        exception
          when no_data_found then
            NREL   := 0;
            IMPMOV := 0;
        end;
      else
        if i.PTRMOD = 99 and i.PTRNRO = 925 then
          -- si es cheque manual revisa si es por remu en tabla local
          if i.asiento = 'D' then
            begin
              select Itoper, Itsubo, Moneda, Itsucd
                into vscoper_c, vscsbop_c, vscmda_c, vScsuc_c
                from fsd016
               Where PgCod = vpgcod
                 and Itsuc = i.SUCORI
                 and Itmod = i.PTRMOD
                 and Ittran = i.PTRNRO
                 and Itnrel = i.NREL
                 and Modulo = 19                 
                 and ctnro = VSccta;
            exception
              when no_data_found then
                NREL   := 0;
                IMPMOV := 0;
            end;
          else
            begin
              select hoper, hsubop, hmda, hsucur
                into vscoper_c, vscsbop_c, vscmda_c, vScsuc_c
                from fsh016
               Where PgCod = vpgcod
                 and hsucor = i.SUCORI
                 and hcmod = i.PTRMOD
                 and htran = i.PTRNRO
                 and hnrel = i.NREL
                 and hModul = 19
                 and hcta = VSccta
                 and hfcon = i.FCON;
            exception
              when no_data_found then
                NREL   := 0;
                IMPMOV := 0;
            end;
          end if;
        
          If vscoper_c <> 0 then
            begin
              select 'S'
                into ctsrem
                from jaqz161 a1, fse111 a2
               where a1.jaqz161tip = 'R'
                 and a1.JAQZ161EMP = a2.chcod
                 and a1.JAQZ161SUD = a2.E111su
                 and a1.JAQZ161MOT = a2.E111mo
                 and a1.JAQZ161TRX = a2.E111tr
                 and a1.JAQZ161REL = a2.E111re
                 and a1.JAQZ161FEC = a2.E111fc
                 and a2.Chcod = 1
                 and a2.Chsuc = vScsuc_c
                 and a2.Chmod = 19
                 and a2.Chmda = vScmda_c
                 and a2.Chpap = vScpap
                 and a2.Chcta = vSccta
                 and a2.Choper = vscoper_c
                 and a2.Chsbop = vscsbop_c
                 and a2.Chtope = 0
                 and a2.E111co = 'S';
            
              NREL   := i.nrel;
              IMPMOV := i.IMPMOV;
              SUCORI := i.SUCORI;
              FCON   := i.FCON;
              PTRMOD := i.PTRMOD;
              PTRNRO := i.PTRNRO;
              exit;
            exception
              when no_data_found then
                NREL   := 0;
                IMPMOV := 0;
            end;
          end if;
        
        else
          if i.PTRMOD = 99 and i.PTRNRO = 290 then
            -- si es cheque masivo ya no valoriza remus, ahora es la 99/295
            NREL   := 0;
            IMPMOV := 0;
          end if;
        end if;
      end if;
    else
      NREL   := i.nrel;
      IMPMOV := i.IMPMOV;
      SUCORI := i.SUCORI;
      FCON   := i.FCON;
      PTRMOD := i.PTRMOD;
      PTRNRO := i.PTRNRO;
      exit;
    end if;
  end loop;
end SP_AH_DEPO_REM_CTS;
/

