create or replace procedure sp_cr_obt_condonados(pd_fecini date,pd_fecfin date) is
  cursor fsh015_1 is
    select *
      from fsh015 x
     where x.pgcod = 1
       and x.hcmod = 300
       and x.htran in (200, 210, 402, 407)
       and x.hfcon >= pd_fecini
       and x.hfcon <= pd_fecfin
       and x.hccorr <> '99';

  cursor fsh016_1(p_pgcod number, p_mod number, p_sucor number, p_tran number, p_rel number, p_fcon date) is
    select sum(hcimp1) imp,
           aa.HMODUL,
           aa.HTOPER,
           aa.HSUCUR,
           aa.HMDA,
           aa.HPAP,
           aa.HCTA,
           aa.HOPER,
           aa.HSUBOP
      from fsh015 x
     inner join fsh016 aa on x.pgcod = aa.pgcod
                         and x.hcmod = aa.hcmod
                         and x.hsucor = aa.hsucor
                         and x.htran = aa.htran
                         and x.hnrel = aa.hnrel
                         and x.hfcon = aa.hfcon
     where aa.pgcod = p_pgcod
       and aa.hcmod = p_mod
       and aa.hsucor = p_sucor
       and aa.htran = p_tran
       and aa.hnrel = p_rel
       and aa.hfcon = p_fcon
       and aa.hcord in (select tp1nro1
                          from fst198
                         where tp1cod = 1
                           and tp1cod1 = 11105
                           and tp1corr1 = 10
                           and tp1corr2 = 1
                           and tp1nro2 = 1
                           and tp1imp1 = p_mod
                           and tp1imp2 = p_tran)
     group by aa.HMODUL,
              aa.HTOPER,
              aa.HSUCUR,
              aa.HMDA,
              aa.HPAP,
              aa.HCTA,
              aa.HOPER,
              aa.HSUBOP;

  cursor fsh016_2(p_pgcod number, p_mod number, p_sucor number, p_tran number, p_rel number, p_fcon date) is
    select hcimp1,
           hcord,
           (select tp1nro3
              from fst198 g
             where tp1cod = 1
               and tp1cod1 = 11105
               and tp1corr1 = 10
               and tp1corr2 = 1
               and tp1nro2 = 2
               and tp1imp1 = p_mod
               and tp1imp2 = p_tran
               and tp1nro1 = aa.hcord) campo
      from fsh015 x
     inner join fsh016 aa on x.pgcod = aa.pgcod
                         and x.hcmod = aa.hcmod
                         and x.hsucor = aa.hsucor
                         and x.htran = aa.htran
                         and x.hnrel = aa.hnrel
                         and x.hfcon = aa.hfcon
     where aa.pgcod = p_pgcod
       and aa.hcmod = p_mod
       and aa.hsucor = p_sucor
       and aa.htran = p_tran
       and aa.hnrel = p_rel
       and aa.hfcon = p_fcon
       and aa.hcord in (select tp1nro1
                          from fst198
                         where tp1cod = 1
                           and tp1cod1 = 11105
                           and tp1corr1 = 10
                           and tp1corr2 = 1
                           and tp1nro2 = 2
                           and tp1imp1 = p_mod
                           and tp1imp2 = p_tran);

  cursor fsh016_3(p_pgcod number, p_mod number, p_sucor number, p_tran number, p_rel number, p_fcon date) is
    select *
      from fsh016 aa
     where aa.pgcod = p_pgcod
       and aa.hcmod = p_mod
       and aa.hsucor = p_sucor
       and aa.htran = p_tran
       and aa.hnrel = p_rel
       and aa.hfcon = p_fcon
       and aa.hcord in (select tp1nro1
                          from fst198
                         where tp1cod = 1
                           and tp1cod1 = 11105
                           and tp1corr1 = 10
                           and tp1corr2 = 1
                           and tp1nro2 in (1, 2)
                           and tp1imp1 = p_mod
                           and tp1imp2 = p_tran)
       and rownum = 1;

  ln_montoCap  number(17, 2);
  ln_montoSum  number(17, 2);
  ln_Tpgcod    number(4);
  ln_Thcmod    number(4);
  ln_Thsucor   number(4);
  ln_Thtran    number(4);
  ln_Thnrel    number(4);
  ln_thhora    character(8);
  ln_thusua    character(10);
  ln_Thfcon    date;
  ln_ThfconAnt date;
  lC_Thfcon    char(10);
  lC_ThfconAnt char(10);
  ln_CPGCOD    number(4);
  ln_CHMODUL   number(4);
  ln_CHSUCUR   number(4);
  ln_CHMDA     number(4);
  ln_CHPAP     number(4);
  ln_CHCTA     number(9);
  ln_CHOPER    number(9);
  ln_CHSUBOP   number(4);
  ln_CHTOPER   number(4);
  lc_rubro     number(16);
  lc_rubroAux  number(16);
  ln_i         number(5);
  ln_count     number(5);
  ln_seguros   number(17, 2);
  ln_otroRub   number(17, 2);
  ln_penali    number(17, 2);
  ln_intmor    number(17, 2);
  ln_icv       number(17, 2);
  ln_intcom    number(17, 2);
  ln_estado    NUMBER(3);
  lc_tipcre    VARCHAR2(2);
  ln_diasAtr   number(7);
  ld_fecven    date;
  lc_err       varchar(100);

begin
  ln_count := 0;
  --delete from aqpa018;--chernandez 28/11/2018
  --commit;--chernandez 28/11/2018
  --recorrer las transacciones 200
  for i in fsh015_1 loop
    -- obtenemos la clave de la transaccion
    ln_Tpgcod  := i.PGCOD;
    ln_Thcmod  := i.HCMOD;
    ln_Thsucor := i.HSUCOR;
    ln_Thtran  := i.HTRAN;
    ln_Thnrel  := i.HNREL;
    ln_Thfcon  := i.HFCON;
    ln_thhora  := i.hhora;
    ln_thusua  := i.husing;
    lC_Thfcon  := lpad(extract(day from ln_Thfcon), 2, '0') || '/' ||
                  lpad(extract(month from ln_Thfcon), 2, '0') || '/' ||
                  extract(year from ln_Thfcon);
  
    --inicializamos variables
    ln_montoCap  := 0;
    ln_montoSum  := 0;
    ln_i         := 0;
    ln_ThfconAnt := last_day(add_months(ln_Thfcon, -1));
    lc_ThfconAnt := lpad(extract(day from ln_ThfconAnt), 2, '0') || '/' ||
                    lpad(extract(month from ln_ThfconAnt), 2, '0') || '/' ||
                    extract(year from ln_ThfconAnt);
    lc_rubro     := null;
    lc_rubroAux  := null;
    ln_CPGCOD    := null;
    ln_CHMODUL   := null;
    ln_CHSUCUR   := null;
    ln_CHMDA     := null;
    ln_CHPAP     := null;
    ln_CHCTA     := null;
    ln_CHOPER    := null;
    ln_CHSUBOP   := null;
    ln_CHTOPER   := null;
    ln_seguros   := 0;
    ln_otroRub   := 0;
    ln_penali    := 0;
    ln_intmor    := 0;
    ln_icv       := 0;
    ln_intcom    := 0;
    ln_estado    := null;
    lc_tipcre    := null;
    ln_diasAtr   := null;
    ld_fecven    := null;
    lc_err       := '';
  
    --obtenemos saldo capital y clave de crédito si existiese
    for j in fsh016_1(ln_Tpgcod,
                      ln_Thcmod,
                      ln_Thsucor,
                      ln_Thtran,
                      ln_Thnrel,
                      ln_Thfcon) loop
    
      ln_montoCap := ln_montoCap + j.imp;
    
      ln_CPGCOD  := i.pgcod;
      ln_CHMODUL := j.hmodul;
      ln_CHSUCUR := j.hsucur;
      ln_CHMDA   := j.hmda;
      ln_CHPAP   := j.hpap;
      ln_CHCTA   := j.hcta;
      ln_CHOPER  := j.hoper;
      ln_CHSUBOP := j.hsubop;
      ln_CHTOPER := j.htoper;
      ln_i       := 1;
    
    end loop;
  
    --obtenemos sumatoria de saldo de interes, mora etc
    for k in fsh016_2(ln_Tpgcod,
                      ln_Thcmod,
                      ln_Thsucor,
                      ln_Thtran,
                      ln_Thnrel,
                      ln_Thfcon) loop
      ln_montoSum := ln_montoSum + k.hcimp1;
      if k.campo = 1 then
        ln_seguros := k.hcimp1;
      end if;
      if k.campo = 2 then
        ln_otroRub := k.hcimp1;
      end if;
      if k.campo = 3 then
        ln_penali := k.hcimp1;
      end if;
      if k.campo = 4 then
        ln_intmor := k.hcimp1;
      end if;
      if k.campo = 5 then
        ln_icv := k.hcimp1;
      end if;
      if k.campo = 6 then
        ln_intcom := k.hcimp1;
      end if;
    
    end loop;
  
    If ln_i = 0 then
      --obtenemos parte de clave de crédito de detalle de transacción ord segun transaccion
      for l in fsh016_3(ln_Tpgcod,
                        ln_Thcmod,
                        ln_Thsucor,
                        ln_Thtran,
                        ln_Thnrel,
                        ln_Thfcon) loop
        ln_CPGCOD  := ln_Tpgcod;
        ln_CHSUCUR := l.hsucur;
        ln_CHMDA   := l.hmda;
        ln_CHPAP   := l.hpap;
        ln_CHCTA   := l.hcta;
        ln_CHOPER  := l.hoper;
      end loop;
      --obtenemos clave de crédito de fsh012
      /*for m in FSH012_1(ln_CPGCOD,
                        ln_CHSUCUR,
                        ln_CHMDA,
                        ln_CHPAP,
                        ln_CHCTA,
                        ln_CHOPER,
                        ln_ThfconAnt) loop
        lc_rubroAux := m.bcrubr;
      
      end loop;*/
    
    end if;
  
    begin
      if ln_Thtran = 200 then
      
        select hrubro, hmodul, hsubop, htoper
          into lc_rubro, ln_CHMODUL, ln_CHSUBOP, ln_CHTOPER
          from fsh015 x
         inner join fsh016 aa on x.pgcod = aa.pgcod
                             and x.hcmod = aa.hcmod
                             and x.hsucor = aa.hsucor
                             and x.htran = aa.htran
                             and x.hnrel = aa.hnrel
                             and x.hfcon = aa.hfcon
         where aa.pgcod = ln_CPGCOD
           and aa.hcmod = 300
           and aa.htran = 390
           and aa.hfcon >= to_date('01/' || EXTRACT(MONTH FROM ln_Thfcon) || '/' ||
                                   EXTRACT(YEAR FROM ln_Thfcon),
                                   'dd/mm/yyyy')
           and aa.hfcon <= last_day(ln_Thfcon)
           and hccorr <> 99
           and aa.hcord = 30
              --and hmodul = ln_CHMODUL
           and hsucur = ln_CHSUCUR
           and hmda = ln_CHMDA
           and hpap = ln_CHPAP
           and hcta = ln_CHCTA
           and hoper = ln_CHOPER
              --and hsubop = ln_CHSUBOP
              --and htoper = ln_CHTOPER
           and rownum = 1;
      
      end if;
    
      if ln_Thtran = 210 then
        select hrubro, hmodul, hsubop, htoper
          into lc_rubro, ln_CHMODUL, ln_CHSUBOP, ln_CHTOPER
          from fsh016 aa
         where aa.pgcod = ln_Tpgcod
           and aa.hcmod = ln_Thcmod
           and aa.hsucor = ln_Thsucor
           and aa.htran = ln_Thtran
           and aa.hnrel = ln_Thnrel
           and aa.hfcon = ln_Thfcon
           and aa.hcord = 10;
      end if;
    
      if ln_Thtran = 402 then
        select /*+index(d FSH01204)*/
         d.bcrubr, d.bcmod, d.BCSBOP, d.BCTOP, d.bcprod, d.bcgpo
          into lc_rubro,
               ln_CHMODUL,
               ln_CHSUBOP,
               ln_CHTOPER,
               ln_estado,
               lc_tipcre
          from fsh012 d
         where d.bcemp = ln_CPGCOD
           and d.bcsuc = ln_CHSUCUR
           and d.bcmda = ln_CHMDA
           and d.bcpap = ln_CHPAP
           and d.bccta = ln_CHCTA
           and d.bcoper = ln_CHOPER
           and d.bcfech = to_date(lc_ThfconAnt, 'dd/mm/yyyy')
           and d.bcmod IN (SELECT MODULO FROM FST111 WHERE DSCOD = 50);
      End if;
    
      if ln_Thtran = 407 then
        select hrubro, hmodul, hsubop, htoper
          into lc_rubro, ln_CHMODUL, ln_CHSUBOP, ln_CHTOPER
          from fsh016 aa
         where aa.pgcod = ln_Tpgcod
           and aa.hcmod = ln_Thcmod
           and aa.hsucor = ln_Thsucor
           and aa.htran = ln_Thtran
           and aa.hnrel = ln_Thnrel
           and aa.hfcon = ln_Thfcon
           and aa.hcord = 5;
      end if;
    
    EXCEPTION
    
      when others then
        if lc_rubro is null then
        
          begin
            select /*+index(d FSH01204)*/
             d.bcrubr, d.bcmod, d.BCSBOP, d.BCTOP, d.bcprod, d.bcgpo
              into lc_rubro,
                   ln_CHMODUL,
                   ln_CHSUBOP,
                   ln_CHTOPER,
                   ln_estado,
                   lc_tipcre
              from fsh012 d
             where d.bcemp = ln_CPGCOD
               and d.bcsuc = ln_CHSUCUR
               and d.bcmda = ln_CHMDA
               and d.bcpap = ln_CHPAP
               and d.bccta = ln_CHCTA
               and d.bcoper = ln_CHOPER
               and d.bcfech = to_date(lc_ThfconAnt, 'dd/mm/yyyy')
               and d.bcmod IN (SELECT MODULO FROM FST111 WHERE DSCOD = 50);
          EXCEPTION
            when others then
              lc_rubro := null;
          end;
        end if;
    end;
  
    lc_tipcre := substr(lc_rubro, 5, 2);
    Case
      when ln_Thtran = 200 then
        ln_estado := 23;
      when ln_Thtran = 210 then
        ln_estado := 23;
      when ln_Thtran = 402 then
        ln_estado := 64;
      when ln_Thtran = 407 then
        ln_estado := 90;
      Else
        ln_estado := ln_estado;
    end case;
  
    Begin
      select aofvto
        into ld_fecven
        from fsd010
       where pgcod = ln_CPGCOD
         and aomod = ln_CHMODUL
         and aosuc = ln_CHSUCUR
         and aomda = ln_CHMDA
         and aopap = ln_CHPAP
         and aocta = ln_CHCTA
         and aooper = ln_CHOPER
         and aosbop = ln_CHSUBOP
         and aotope = ln_CHTOPER;
      ln_diasAtr := ln_Thfcon - ld_fecven;
    EXCEPTION
      when others then
        ln_diasAtr := null;
    end;
  
    ln_count := ln_count + 1;
    Begin
      insert into aqpa018
        (aqpa018IPGCOD,
         aqpa018ITMOD,
         aqpa018ITSUC,
         aqpa018ITTRAN,
         aqpa018ITNREL,
         aqpa018ITFCON,
         aqpa018HPGCOD,
         aqpa018hmodul,
         aqpa018htoper,
         aqpa018hsucur,
         aqpa018hmda,
         aqpa018hpap,
         aqpa018hcta,
         aqpa018hoper,
         aqpa018hsubop,
         aqpa018hrubroc,
         aqpa018mcapitc,
         aqpa018msumac,
         aqpa018mseguc,
         aqpa018motroc,
         aqpa018mpenac,
         aqpa018minmoc,
         aqpa018micvc,
         aqpa018mincoc,
         
         aqpa018statc, --estado del crédito al momento de la condonación
         aqpa018tipcre, --tipo de credito
         aqpa018ithora, --hora transacción
         aqpa018itucnf, --usuario transacción
         aqpa018usuact, ----usuario de actualización del registro
         aqpa018fecact,
         AQPA018EST,
         AQPA018DIAATR)
      values
        (ln_Tpgcod,
         ln_Thcmod,
         ln_Thsucor,
         ln_Thtran,
         ln_Thnrel,
         ln_Thfcon,
         ln_CPGCOD,
         ln_CHMODUL,
         ln_CHTOPER,
         ln_CHSUCUR,
         ln_CHMDA,
         ln_CHPAP,
         ln_CHCTA,
         ln_CHOPER,
         ln_CHSUBOP,
         lc_rubro,
         ln_montoCap,
         ln_montoSum,
         ln_seguros,
         ln_otroRub,
         ln_penali,
         ln_intmor,
         ln_icv,
         ln_intcom,
         
         ln_estado,
         lc_tipcre,
         ln_thhora,
         ln_thusua,
         SUBSTR(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'), 1, 10),
         sysdate,
         'C',
         ln_diasAtr);
      commit;
    EXCEPTION
      when others then
        lc_err := to_char(ln_Tpgcod) || '-' || to_char(ln_Thcmod) || '-' ||
                  to_char(ln_Thsucor) || '-' || to_char(ln_Thtran) || '-' ||
                  to_char(ln_Thnrel) || '-' || to_char(ln_Thfcon) || '-' ||
                  to_char(ln_thhora) || '-' || to_char(ln_thusua);
        dbms_output.put_line(lc_err);
        dbms_output.put_line(sqlerrm);
        dbms_output.put_line('--------------------------------------');
    end;
  end loop;
end sp_cr_obt_condonados;
/

