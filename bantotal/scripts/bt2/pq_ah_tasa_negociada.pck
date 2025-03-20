create or replace package PQ_AH_TASA_NEGOCIADA is

  -- Author  : MARAUJO
  -- Created : 27/12/2018 03:56:21 p. m.
  -- Purpose : 

  procedure sp_procesa(pPgcod   number,
                       pFecpro  date,
                       pFecini  date,
                       pFecfin  date,
                       pusuario varchar2,
                       pitmod   out number,
                       pittran  out number,
                       pitnreli out number,
                       pitnrelf out number);

  procedure sp_saldo_prom(ppgcod  number,
                          pScsuc  number,
                          pSccta  number,
                          pScmda  number,
                          pScpap  number,
                          pScoper number,
                          pScsbop number,
                          pSctope number,
                          pScmod  number,
                          pFecini date,
                          pFecfin date,
                          pscsdo  out number);

  procedure sp_saldo_dia(ppgcod  number,
                         pScsuc  number,
                         pSccta  number,
                         pScmda  number,
                         pScpap  number,
                         pScoper number,
                         pScsbop number,
                         pSctope number,
                         pScmod  number,
                         pRubro  number,
                         pFecini date,
                         ptipo   varchar2,
                         pscsdo  out number);

  procedure sp_send_mail(pPgcod       number,
                         pSccta       number,
                         pScmda       number,
                         pFecini      date,
                         pFecpro      date,
                         pTipo        varchar2,
                         pJaql741sapn number,
                         pJAQL741MAIL varchar2,
                         pJaql741usre varchar2,
                         pIntpag      number,
                         pTipCal      number,
                         pError       Out varchar2);

  procedure sp_dml_curva(pModo   varchar2,
                         pMoneda number,
                         pMtoMin number,
                         pMtomax number,
                         pTasrec number,
                         pTasnue number,
                         pFecreg date,
                         pUsureg varchar2,
                         pFecvig date,
                         pError  out varchar2);
                         
  
end PQ_AH_TASA_NEGOCIADA;
/

create or replace package body PQ_AH_TASA_NEGOCIADA is

  procedure sp_procesa(pPgcod   number,
                       pFecpro  date,
                       pFecini  date,
                       pFecfin  date,
                       pusuario varchar2,
                       pitmod   out number,
                       pittran  out number,
                       pitnreli out number,
                       pitnrelf out number) is
                       
    verror varchar2(100);
    verrorm varchar2(100);    
  
    cursor ctas is
      select *
        from jaql741
       where jaql741esta = 'S'
         and (jaql741fefi = to_date('01/01/0001', 'dd/mm/yyyy') or
             jaql741fefi <= pFecfin)
         and jaql741fein >= pFecini
      ;
  
    vpgcod   number(3);
    vusuario char(10) := pusuario;
    vscsuc   number(3);
    vsccta   number(9);
    vscmda   number(4);
    vscpap   number(3);
    vscoper  number(9);
    vscsbop  number(3);
    vsctope  number(3);
    vscmod   number(3);
    vsalpro  number(18, 2);
    vfeccor  date;
    dd       number(2);
    mm       number(2);
    yyyy     number(4);
    vrubro   number;
    vfecsal  date;
    vtipo    varchar2(1);
    vsaldia  number(18, 2);
    vsalpag  number(18, 2);
    vintdia  number(18, 2);
    vintacu  number(18, 2);
  
    vintpag number(18, 2);
    vintcal number(18, 2);
  
    vUbsuc  number(3);
    vItnrel number(4);
    vPfdid  number(1) := 0;
  
    vconta number(5) := 0;
  
    vpgfape date := pfecpro;
    vsalini number(18, 2);
    vinineg date;
    vcurva  varchar2(20);
  
    vitmod1  number(3);
    vittran1 number(3);
  
    vitmod2  number(3);
    vittran2 number(3);
    vnumdia number(3);
    vtasa number(10,6);
    ln_tasa number(10,6);
  
  begin
  
    --select pgfape into vpgfape from fst017 Where PgCod = pPgcod;
  
    pitnreli := 0;
    pitnrelf := 0;
  
    begin
      select ubsuc
        into vubsuc
        from fst046
       Where PgCod = pPgcod
         and Ubuser = vUsuario;
    exception
      when others then
        verror := 'No se encontraron datos en la fst046: vubsuc';
        dbms_output.put_line(verror);
    end;
  
    begin
      select tp1nro1, tp1nro2
        into vitmod1, vittran1
        from fst198
       Where Tp1cod = ppgcod
         and Tp1cod1 = 10818
         and Tp1corr1 = 6
         and Tp1corr2 = 3
         and Tp1corr3 = 2;
    exception
      when others then
        verror   := 'No se encontraron datos en la fst198: vitmod deven';
        vitmod1  := 0;
        vittran1 := 0;
        dbms_output.put_line(verror);
    end;
  
    begin
      select tp1imp1, tp1imp2
        into vitmod2, vittran2
        from fst198
       Where Tp1cod = ppgcod
         and Tp1cod1 = 10818
         and Tp1corr1 = 6
         and Tp1corr2 = 3
         and Tp1corr3 = 2;
    exception
      when others then
        verror   := 'No se encontraron datos en la fst198: vitmod remu';
        vitmod2  := 0;
        vittran2 := 0;
        dbms_output.put_line(verror);
    end;
  
    for i in ctas loop
      verror  := '';
      vitnrel := 0;
      vintcal := 0;
    
      vpgcod  := i.jaql741pgco;
      vscsuc  := i.jaql741scsu;
      vsccta  := i.jaql741scct;
      vscmda  := i.jaql741scmd;
      vscpap  := i.jaql741scpa;
      vscoper := i.jaql741scop;
      vscsbop := i.jaql741scsb;
      vsctope := i.jaql741scto;
      vscmod  := i.jaql741scmo;
      
      if i.jaql741au04 = 1 then --si tipo de calculo es con saldo promedio
          sp_saldo_prom(vpgcod,
                        vscsuc,
                        vsccta,
                        vscmda,
                        vscpap,
                        vscoper,
                        vscsbop,
                        vsctope,
                        vscmod,
                        i.JAQL741FEIN, --pfecini,
                        i.JAQL741FEFI,
                        vsalpro);
        
/*          dbms_output.put_line(vsccta || '-' || vsalpro || '-' ||
                               i.jaql741sapn);*/
        
          begin
            select trim(to_char(JAQL743tare, '990.90')) || '-' ||
                   trim(to_char(JAQL743tanu, '990.90'))
              into vcurva
              from jaql743
             Where i.jaql741fein between jaql743fini and jaql743ffin
               and i.jaql741fefi between jaql743fini and jaql743ffin
               and jaql743mone = vscmda
               and jaql743mtmi <= i.jaql741sapn
               and jaql743mtma >= i.jaql741sapn;
          exception
            when too_many_rows then
              verror := 'Se encontró mas de un rango en la jaql743: vcurva';
              dbms_output.put_line(verror);
              vcurva := '-';
            when others then
              verror := 'No se encontraron datos en la jaql743: vcurva';
              dbms_output.put_line(verror);
              vcurva := '-';
          end;
        
          vfecsal := i.jaql741fein;
          vintacu := 0;
          vsalini := 0;
          vintpag := 0;
        
          if i.jaql741sapn <= vsalpro then
          
            begin
              select tp1nro1, tp1nro2, tp1nro3
                into dd, mm, yyyy
                from fst198
               Where Tp1cod = ppgcod
                 and Tp1cod1 = 10818
                 and Tp1corr1 = 6
                 and Tp1corr2 = 3
                 and Tp1corr3 = 1;
            exception
              when others then
                verror := 'No se encontraron datos en la fst198: vfeccor';
                dbms_output.put_line(verror);
            end;
          
            vfeccor := to_date(lpad(to_char(dd), 2, '0') ||
                               lpad(to_char(mm), 2, '0') || to_char(yyyy),
                               'ddmmyyyy');
          
            begin
              select scrub
                into vrubro
                from fsd011
               where pgcod = i.jaql741pgco
                 and scsuc = i.jaql741scsu
                 and sccta = i.jaql741scct
                 and scmda = i.jaql741scmd
                 and scpap = i.jaql741scpa
                 and scoper = i.jaql741scop
                 and scsbop = i.jaql741scsb
                 and sctope = i.jaql741scto
                 and scmod = i.jaql741scmo;
            exception
              when others then
                verror := 'No se encontraron datos en la FSD011:vrubro';
                vrubro := 0;
                dbms_output.put_line(verror);
            end;
          
            vnumdia := 0;
            
            while vfecsal <= pFecfin loop
              if vrubro <> 0 then
                if vfecsal = last_day(vfecsal) then
                  vtipo := 'A';
                else
                  vtipo := 'A'; -- D
                end if;
              
                sp_saldo_dia(vpgcod,
                             vscsuc,
                             vsccta,
                             vscmda,
                             vscpap,
                             vscoper,
                             vscsbop,
                             vsctope,
                             vscmod,
                             vrubro,
                             vfecsal,
                             vtipo,
                             vsaldia);
              
                If to_char(vfecsal, 'dd') = '01' then
                  vsalini := vsaldia;
                End If;
              
                if vsaldia >= 0 then
                
                  If i.jaql741fein < vfeccor then
                    -- si negociación se hizo antes de corte
                    -- tomo el saldo diario sin validar
                    vsalpag := vsaldia;
                  Else
                    -- sino tomo saldo menor
                    If vsaldia < i.jaql741sapn then
                      -- tomo el saldo mayor
                      vsalpag := vsaldia;
                    Else
                      vsalpag := i.jaql741sapn;
                    End If;
                  End If;
                
                  if vsalpag <> vsaldia then
                    dbms_output.put_line(vsccta || '-' || vfecsal || '-' ||
                                         vsalpag || '-' || vsaldia);
                  end if;
                
                  vintdia := (vsalpag *
                             (power(1 + (i.jaql741tean / 100), (1 / 360)) - 1) * 1);
                  vintacu := vintacu + vintdia;
                
                end if;
              end if;
              vfecsal := vfecsal + 1;
              vnumdia := vnumdia + 1;
            end loop;
            
            /*
            begin
              select hcimp1
                into vintpag
                from fsh016
               where pgcod = ppgcod
                 and hcmod = vitmod1
                 and htran = vittran1
                 and hfcon = last_day(pfecfin)
                 and hmodul = vscmod
                 and htoper = vsctope
                 and hsucur = vscsuc
                 and hmda = vscmda
                 and hpap = vscpap
                 and hcta = vsccta
                 and hoper = vscoper
                 and hsubop = vscsbop;
            exception
              when others then
                verror  := 'No se encontraron datos en la fsh016: vintpag';
                vintpag := 0;
                dbms_output.put_line(verror);
            end;
            */
            
            pq_segmentacion_clientes_pas.sp_tasa(vpgcod => ppgcod,
                                                 vscsuc => vscsuc,
                                                 vsccta => vsccta,
                                                 vscmda => vscmda,
                                                 vscpap => vscpap,
                                                 vscoper => vscoper,
                                                 vscsbop => vscsbop,
                                                 vsctope => vsctope,
                                                 vscmod => vscmod,
                                                 tasa => vtasa);
            
            vintpag := (i.jaql741sapn * (power(1 + ( vtasa / 100), (1 / 360)) - 1) * vnumdia);        
          
            vintcal := vintacu - vintpag;
          
            if vintcal > 0 and verror is null then
            
              vconta := vconta + 1;
            
              begin
                select nrtrel --numerador
                  into vitnrel
                  from fsn003
                 where pgcod = ppgcod
                   and nrsuc = vUbsuc
                   and trmod = vitmod2
                   and trnro = vittran2
                   for update;
              exception
                when others then
                  verror := 'No se actualizaron datos en la fsn003: vitnrel';
                  dbms_output.put_line(verror);
              end;
            
              vitnrel := vitnrel + 1;
            
              begin
                update fsn003
                   set nrtrel = vitnrel
                 where pgcod = ppgcod
                   and nrsuc = vUbsuc
                   and trmod = vitmod2
                   and trnro = vittran2;
              
                if SQL%NOTFOUND THEN
                  verror := 'No se actualizaron datos en la fsn003: vitnrel';
                  dbms_output.put_line(verror);
                end if;
              end;
            
              commit;
            
              if vconta = 1 then
                pitnreli := vitnrel;
              end if;
            
              insert into fsd603
                (PgCod,
                 Itsuc,
                 Itmod,
                 Ittran,
                 Itnrel,
                 PfdId,
                 PfdCt01,
                 PfdOp01,
                 PfdSo01,
                 PfdTo01,
                 PfdMo01,
                 PfdPa01,
                 PfdSu01,
                 PfdIm01,
                 PfdOrd1,
                 PfdSbo1)
              values
                (vpgcod,
                 vubsuc,
                 vitmod2,
                 vittran2,
                 vitnrel,
                 vpfdid,
                 vsccta,
                 vscoper,
                 vscsbop,
                 vsctope,
                 vscmda,
                 vscpap,
                 vscsuc,
                 vintcal,
                 5,
                 1);
            
              dbms_output.put_line(vsccta || '-' || vitnrel || '-' || vintcal);
            end if;
          
          else
            -- manda correo
            sp_send_mail(pPgcod,
                         vSccta,
                         vScmda,
                         pFecini,
                         pFecpro,
                         'N',
                         i.Jaql741sapn,
                         i.JAQL741MAIL,
                         i.Jaql741usre,
                         0,
                         i.jaql741au04,
                         verrorm);
          end if;
  
      Else --Si tipo de calculo es con saldo diario
        
          begin
            select scrub
              into vrubro
              from fsd011
             where pgcod  = i.jaql741pgco
               and scsuc  = i.jaql741scsu
               and sccta  = i.jaql741scct
               and scmda  = i.jaql741scmd
               and scpap  = i.jaql741scpa
               and scoper = i.jaql741scop
               and scsbop = i.jaql741scsb
               and sctope = i.jaql741scto
               and scmod  = i.jaql741scmo;
          exception
          when others then
              verror := 'No se encontraron datos en la FSD011:vrubro';
              vrubro := 0;
          end;

          sp_saldo_dia(vpgcod,
                       vscsuc,
                       vsccta,
                       vscmda,
                       vscpap,
                       vscoper,
                       vscsbop,
                       vsctope,
                       vscmod,
                       vrubro,
                       pFecfin,
                       'A',
                       vsalpro);            
                                 
          begin
            select trim(to_char(JAQL743tare, '990.90')) || '-' ||
                   trim(to_char(JAQL743tanu, '990.90'))
              into vcurva
              from jaql743
             Where i.jaql741fein between jaql743fini and jaql743ffin
               and i.jaql741fefi between jaql743fini and jaql743ffin 
               and jaql743mone = vscmda
               and jaql743mtmi <= i.jaql741sapn
               and jaql743mtma >= i.jaql741sapn;
          exception
            when too_many_rows then
              verror := 'Se encontró mas de un rango en la jaql743: vcurva';
              dbms_output.put_line(verror);
              vcurva := '-';
            when others then
              verror := 'No se encontraron datos en la jaql743: vcurva';
              dbms_output.put_line(verror);
              vcurva := '-';
          end;
        
          --vfecsal := i.jaql741fein;
          vfecsal := pFecini;
          vintacu := 0;
          vsalini := 0;
          vintpag := 0;
        
          if i.jaql741sapn <= vsalpro then
          
            begin
              select tp1nro1, tp1nro2, tp1nro3
                into dd, mm, yyyy
                from fst198
               Where Tp1cod = ppgcod
                 and Tp1cod1 = 10818
                 and Tp1corr1 = 6
                 and Tp1corr2 = 3
                 and Tp1corr3 = 1;
            exception
              when others then
                verror := 'No se encontraron datos en la fst198: vfeccor';
                dbms_output.put_line(verror);
            end;
          
            vfeccor := to_date(lpad(to_char(dd), 2, '0') ||
                               lpad(to_char(mm), 2, '0') || to_char(yyyy),
                               'ddmmyyyy');
          
/*            begin
              select scrub
                into vrubro
                from fsd011
               where pgcod = i.jaql741pgco
                 and scsuc = i.jaql741scsu
                 and sccta = i.jaql741scct
                 and scmda = i.jaql741scmd
                 and scpap = i.jaql741scpa
                 and scoper = i.jaql741scop
                 and scsbop = i.jaql741scsb
                 and sctope = i.jaql741scto
                 and scmod = i.jaql741scmo;
            exception
              when others then
                verror := 'No se encontraron datos en la FSD011:vrubro';
                vrubro := 0;
                dbms_output.put_line(verror);
            end;*/
          
            vnumdia := 0;
            
            while vfecsal <= pFecfin loop
              if vrubro <> 0 then
                if vfecsal = last_day(vfecsal) then
                  vtipo := 'A';
                else
                  vtipo := 'A'; -- D
                end if;
              
                sp_saldo_dia(vpgcod,
                             vscsuc,
                             vsccta,
                             vscmda,
                             vscpap,
                             vscoper,
                             vscsbop,
                             vsctope,
                             vscmod,
                             vrubro,
                             vfecsal,
                             vtipo,
                             vsaldia);
              
                If to_char(vfecsal, 'dd') = '01' then
                  vsalini := vsaldia;
                End If;
              
                if vsaldia >= 0 then
                
                  If i.jaql741fein < vfeccor then
                    -- si negociación se hizo antes de corte
                    -- tomo el saldo diario sin validar
                    vsalpag := vsaldia;
                  Else
                    If vsaldia >= i.jaql741sapn And vfecsal >= i.jaql741fein then
                       vsalpag := vsaldia;
                       ln_tasa := i.jaql741tean;
                    Else
                       --vsalpag := i.jaql741sapn;
                       vsalpag := vsaldia;
                       pq_ah_productividad.tasa(vpgcod  => ppgcod,
                                                vscsuc  => vscsuc,
                                                vsccta  => vsccta,
                                                vscmda  => vscmda,
                                                vscpap  => vscpap,
                                                vscoper => vscoper,
                                                vscsbop => vscsbop,
                                                vsctope => vsctope,
                                                vscmod  => vscmod,
                                                vsfval  => vfecsal,
                                                vmonto  => vsalpag,
                                                vplazo  => 0,
                                                tasa    => ln_tasa);     
                    End If;
                  End If;
                
/*                  if vsalpag <> vsaldia then
                    dbms_output.put_line(vsccta || '-' || vfecsal || '-' ||
                                         vsalpag || '-' || vsaldia);
                  end if;*/
                
                  vintdia := (vsalpag *
                             (power(1 + (ln_tasa / 100), (1 / 360)) - 1) * 1);
                  vintacu := vintacu + vintdia;
                
                end if;
              end if;
              vfecsal := vfecsal + 1;
              vnumdia := vnumdia + 1;
            end loop;
            
            /*
            begin
              select hcimp1
                into vintpag
                from fsh016
               where pgcod = ppgcod
                 and hcmod = vitmod1
                 and htran = vittran1
                 and hfcon = last_day(pfecfin)
                 and hmodul = vscmod
                 and htoper = vsctope
                 and hsucur = vscsuc
                 and hmda = vscmda
                 and hpap = vscpap
                 and hcta = vsccta
                 and hoper = vscoper
                 and hsubop = vscsbop;
            exception
              when others then
                verror  := 'No se encontraron datos en la fsh016: vintpag';
                vintpag := 0;
                dbms_output.put_line(verror);
            end;
            */
            
/*            pq_segmentacion_clientes_pas.sp_tasa(vpgcod => ppgcod,
                                                 vscsuc => vscsuc,
                                                 vsccta => vsccta,
                                                 vscmda => vscmda,
                                                 vscpap => vscpap,
                                                 vscoper => vscoper,
                                                 vscsbop => vscsbop,
                                                 vsctope => vsctope,
                                                 vscmod => vscmod,
                                                 tasa => vtasa);
            
            vintpag := (i.jaql741sapn * (power(1 + ( vtasa / 100), (1 / 360)) - 1) * vnumdia);   */     
            --
            --OBTENEMOS EL MONTO DEVENGADO Y ABONADO DE FIN DE MES
            --
            begin              
              Select a.HCIMP1               
                into vintpag
                from fsh016 a
               where a.PGCOD  = ppgcod
                 and a.HCMOD  = vitmod1 
                 and a.HTRAN  = vittran1
                 --and a.HSUCOR = 11
                 and a.HFCON  = pFecfin
                 and a.HMODUL = vscmod
                 and a.HTOPER = vsctope
                 and a.HSUCUR = vscsuc
                 and a.HMDA   = vscmda
                 and a.HPAP   = vscpap
                 and a.HCTA   = vsccta
                 and a.HOPER  = vscoper
                 and a.HSUBOP = vscsbop;            
            exception
            when others then
              vintpag := 0;  
            end;

            vintcal := vintacu - vintpag;
          
            if vintcal > 0 and verror is null then
            
              vconta := vconta + 1;
            
              begin
                select nrtrel --numerador
                  into vitnrel
                  from fsn003
                 where pgcod = ppgcod
                   and nrsuc = vUbsuc
                   and trmod = vitmod2
                   and trnro = vittran2
                   for update;
              exception
                when others then
                  verror := 'No se actualizaron datos en la fsn003: vitnrel';
                  dbms_output.put_line(verror);
              end;
            
              vitnrel := vitnrel + 1;
            
              begin
                update fsn003
                   set nrtrel = vitnrel
                 where pgcod = ppgcod
                   and nrsuc = vUbsuc
                   and trmod = vitmod2
                   and trnro = vittran2;
              
                if SQL%NOTFOUND THEN
                  verror := 'No se actualizaron datos en la fsn003: vitnrel';
                  dbms_output.put_line(verror);
                end if;
              end;
            
              commit;
            
              if vconta = 1 then
                pitnreli := vitnrel;
              end if;
            
              insert into fsd603
                (PgCod,
                 Itsuc,
                 Itmod,
                 Ittran,
                 Itnrel,
                 PfdId,
                 PfdCt01,
                 PfdOp01,
                 PfdSo01,
                 PfdTo01,
                 PfdMo01,
                 PfdPa01,
                 PfdSu01,
                 PfdIm01,
                 PfdOrd1,
                 PfdSbo1)
              values
                (vpgcod,
                 vubsuc,
                 vitmod2,
                 vittran2,
                 vitnrel,
                 vpfdid,
                 vsccta,
                 vscoper,
                 vscsbop,
                 vsctope,
                 vscmda,
                 vscpap,
                 vscsuc,
                 vintcal,
                 5,
                 1);
            
              dbms_output.put_line(vsccta || '-' || vitnrel || '-' || vintcal);
            end if;
          
          else
            -- manda correo
            sp_send_mail(pPgcod,
                         vSccta,
                         vScmda,
                         pFecini,
                         pFecpro,
                         'N',
                         i.Jaql741sapn,
                         i.JAQL741MAIL,
                         i.Jaql741usre,
                         0,
                         i.jaql741au04,
                         verrorm);
          end if;        
      End if;
          
      update jaql741
         set jaql741inre = vintcal,
             jaql741feup = pfecfin,
             jaql741detp = vitnrel || '-' || verror,
             jaql741au03 = vsalpro
       where jaql741pgco = i.jaql741pgco
         and jaql741scsu = i.jaql741scsu
         and jaql741scmo = i.jaql741scmo
         and jaql741scmd = i.jaql741scmd
         and jaql741scpa = i.jaql741scpa
         and jaql741scct = i.jaql741scct
         and jaql741scop = i.jaql741scop
         and jaql741scsb = i.jaql741scsb
         and jaql741scto = i.jaql741scto
         and jaql741fein = i.jaql741fein;
    
      if i.jaql741fein > pfecini then
        vinineg := i.jaql741fein;
      else
        vinineg := pfecini;
      end if;
    
      insert into jaql742
        (jaql742fepr,
         jaql742fein,
         jaql742fefi,
         jaql742pgco,
         jaql742scsu,
         jaql742scmo,
         jaql742scmd,
         jaql742scpa,
         jaql742scct,
         jaql742scop,
         jaql742scsb,
         jaql742scto,
         jaql742hora,
         jaql742sapn,
         jaql742sain,
         jaql742sapr,
         jaql742tean,
         jaql742inpa,
         jaql742inca,
         jaql742fneg,
         jaql742itsu,
         jaql742itmo,
         jaql742ittr,
         jaql742itre,
         jaql742itfc,
         jaql742au01,
         jaql742au02)
      values
        (pFecpro,
         i.jaql741fein,--pFecini,
         i.jaql741fefi,--pFecfin,
         ppgcod,
         i.jaql741scsu,
         i.jaql741scmo,
         i.jaql741scmd,
         i.jaql741scpa,
         i.jaql741scct,
         i.jaql741scop,
         i.jaql741scsb,
         i.jaql741scto,
         to_char(sysdate, 'hh24:mi:ss'),
         i.jaql741sapn,
         vsalini,
         vsalpro,
         i.jaql741tean,
         vintpag,
         vintacu,
         vinineg,
         vubsuc,
         vitmod2,
         vittran2,
         vitnrel,
         vpgfape,
         vcurva,
         verror||'-'||verrorm);
    
      commit;
    
      If vitnrel <> 0 then
        pitnrelf := vitnrel;
        pitmod   := vitmod2;
        pittran  := vittran2;
      End If;
    
    end loop;
  
  end;
  ---------------------------------------------------------
  procedure sp_saldo_prom(ppgcod  number,
                          pScsuc  number,
                          pSccta  number,
                          pScmda  number,
                          pScpap  number,
                          pScoper number,
                          pScsbop number,
                          pSctope number,
                          pScmod  number,
                          pFecini date,
                          pFecfin date,
                          pscsdo  out number) is
  
    vsaltot number(18, 2);
    vnumdia number(2);
  
  begin
  
    select sum(sbsdo), count(*)
      into vsaltot, vnumdia
      from fsh021
     Where sbcod = pPgcod
       and sbmod = pScmod
       and sbSuc = pScsuc
       and sbMda = pScmda
       and sbPap = pScpap
       and sbCta = pSccta
       and sbOper = pScoper
       and sbSbOp = pScsbop
       and sbTOpe = pSctope
       and sbFech between pFecini and pFecfin;
  
    pscsdo := vsaltot / vnumdia;
  exception
    when others then
      pscsdo := 0;
  end;

  ---------------------------------------------------------
  procedure sp_saldo_dia(ppgcod  number,
                         pScsuc  number,
                         pSccta  number,
                         pScmda  number,
                         pScpap  number,
                         pScoper number,
                         pScsbop number,
                         pSctope number,
                         pScmod  number,
                         pRubro  number,
                         pFecini date,
                         ptipo   varchar2,
                         pscsdo  out number) is
    vrubrox number;
    verror  varchar2(100);
  begin
    if ptipo = 'D' then
      begin
        select h.bcsdmo
          into pscsdo
          from fsh012 h
         where bcemp = ppgcod
           and h.bcsuc = pscsuc
           and h.bcmda = pscmda
           and bccta = psccta
           and h.bcsbop = pscsbop
           and bcrubr = prubro
           and h.bctop = psctope
           and h.bcpap = pscpap
           and h.BCOPER = pscoper
           and bcfech = pFecini
           and rownum = 1;
      exception
        when no_data_found then
          begin
            if substr(prubro, 6, 1) = '1' then
              vrubrox := substr(prubro, 1, 5) || 2 || substr(prubro, 7, 13);
            else
              vrubrox := substr(prubro, 1, 5) || 1 || substr(prubro, 7, 13);
            end if;
          
            select h.bcsdmo
              into pscsdo
              from fsh012 h
             where bcemp = ppgcod
               and h.bcsuc = pscsuc
               and h.bcmda = pscmda
               and bccta = psccta
               and h.bcsbop = pscsbop
               and bcrubr = vrubrox
               and h.bctop = psctope
               and h.bcpap = pscpap
               and h.BCOPER = pscoper
               and bcfech = pFecini
               and rownum = 1;
          exception
            when no_data_found then
              begin
                select h.bcsdmo
                  into pscsdo
                  from fsh012 h
                 where bcemp = ppgcod
                   and h.bcsuc = pscsuc
                   and h.bcmda = pscmda
                   and bccta = psccta
                   and h.bcsbop = pscsbop
                   and bcmod = pscmod
                   and h.bctop = psctope
                   and h.bcpap = pscpap
                   and h.BCOPER = pscoper
                   and bcfech = pFecini
                   and rownum = 1;
              exception
                when no_data_found then
                  pscsdo := 0;
                  verror := 'No se encontraron datos en la fsh012: pscsdo';
                  dbms_output.put_line(verror);
              end;
          end;
      end;
    else
      begin
        select sbsdo
          into pscsdo
          from fsh021
         Where sbcod = pPgcod
           and sbmod = pScmod
           and sbSuc = pScsuc
           and sbMda = pScmda
           and sbPap = pScpap
           and sbCta = pSccta
           and sbOper = pScoper
           and sbSbOp = pScsbop
           and sbTOpe = pSctope
           and sbFech = pFecini;
      exception
        when no_data_found then
          pscsdo := 0;
          verror := 'No se encontraron datos en la fsh012: pscsdo';
          dbms_output.put_line(verror);
      end;
    end if;
  end;

  ---------------------------------------------------------
  procedure sp_send_mail(pPgcod       number,
                         pSccta       number,
                         pScmda       number,
                         pFecini      date,
                         pFecpro      date,
                         pTipo        varchar2,
                         pJaql741sapn number,
                         pJAQL741MAIL varchar2,
                         pJaql741usre varchar2,
                         pIntpag      number,
                         pTipCal      number,
                         pError       Out varchar2) is
  
    cursor correos is
      select SubStr(Pextxt, 1, (Instr(Pextxt, '\') - 1)) correo,
             Trim(b.Pendoc) || '-' || Trim(to_char(b.Pexren)) codmail
        from fsr008 a, fsx001 b
       Where a.PgCod = pPgCod
         and a.Ctnro = pSccta
         and a.Pepais = b.Pepais
         and a.Petdoc = b.Petdoc
         and a.Pendoc = b.Pendoc
         and Txcod = 0;
  
    cursor correos_cc is
      select trim(tp1desc) correo_cc
        from fst198
       Where Tp1cod = ppgcod
         and Tp1cod1 = 10818
         and Tp1corr1 = 6
         and Tp1corr2 = 5;
  
    ll_mensaje    CLOB;
    lv_mensaje    VARCHAR2(32767);
    lv_remitente  VARCHAR2(50);
    lv_asunto     VARCHAR2(90);
    lv_directorio VARCHAR2(30);
    lv_archivos   VARCHAR2(32767);
    lv_destinos   VARCHAR2(32767) := '';
    lv_destinoscc VARCHAR2(32767) := '';
  
    vmes   varchar2(10) := upper(to_char(to_date(to_char(pfecini, 'mm'),
                                                 'mm'),
                                         'Month',
                                         'NLS_DATE_LANGUAGE = SPANISH'));
    vsigno varchar2(4);
  
    vCont    number(2);
    vlenmail number(2);
    vPosini  number(2);
    vSize    number(2);
    vPextxt  varchar2(30);
    vfin     number(2);
  
    vpgfape date := pFecpro;
  
  begin
  
    --return; -- quitar
  
    --select pgfape into vpgfape from fst017 Where PgCod = pPgcod;
  
    begin
      select mosign into vsigno from fst005 where moneda = pscmda;
    
    exception
      when others then
        perror := 'No se encontraron datos en la fst005: vsigno';
        dbms_output.put_line(perror);
    end;
  
    dbms_lob.createtemporary(ll_mensaje, TRUE);
    if pTipCal = 1 then
        If pTipo = 'S' then
          lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimados señores: </p>' ||
                        '<p "font-family: Arial, sans-serif; font-size: 14px;"> Previo cordial saludo, le comunicamos que con fecha <strong>' ||
                        to_char(vpgfape, 'dd.mm.yyyy') ||
                        '</strong> hemos abonado, en su Cuenta de ahorros con Tasa Especial pactada, la suma de <strong>' ||
                        vsigno || trim(to_char(pIntpag, '999,999,990.90')) ||
                        ' ,</strong>  que corresponden a intereses adicionales al haber cumplido el Saldo Promedio Mínimo Mensual pactado de <strong>' ||
                        vsigno || trim(to_char(pjaql741sapn, '999,999,990.90')) ||
                        ' ,</strong>  correspondiente al mes de <strong>' ||
                        trim(vmes) || '</strong>. </p>';
        else
        
          lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimados señores: </p>' ||
                        '<p "font-family: Arial, sans-serif; font-size: 14px;"> Previo cordial saludo, le comunicamos que hemos realizado el cálculo del Saldo Promedio Mínimo Mensual pactado para el mes de <strong>' ||
                        trim(vmes) ||
                        '</strong> , en su Cuenta de ahorros, la misma que no ha cumplido con el importe pactado de <strong>' ||
                        vsigno || trim(to_char(pjaql741sapn, '999,999,990.90')) ||
                        ' ,</strong> por lo que no se han generado intereses adicionales en el mes de <strong>' ||
                        trim(vmes) || '</strong>. </p>';
        End If;
    Else
        If pTipo = 'S' then
          lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimados señores: </p>' ||
                        '<p "font-family: Arial, sans-serif; font-size: 14px;"> Previo cordial saludo, le comunicamos que con fecha <strong>' ||
                        to_char(vpgfape, 'dd.mm.yyyy') ||
                        '</strong> hemos abonado, en su Cuenta de ahorros con Tasa Especial pactada, la suma de <strong>' ||
                        vsigno || trim(to_char(pIntpag, '999,999,990.90')) ||
                        ' ,</strong>  que corresponden a intereses adicionales al haber cumplido el Saldo Mínimo diario pactado de <strong>' ||
                        vsigno || trim(to_char(pjaql741sapn, '999,999,990.90')) ||
                        ' ,</strong>  correspondiente al mes de <strong>' ||
                        trim(vmes) || '</strong>. </p>';
        else
        
          lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimados señores: </p>' ||
                        '<p "font-family: Arial, sans-serif; font-size: 14px;"> Previo cordial saludo, le comunicamos que hemos realizado el cálculo del Saldo Mínimo diario pactado para el mes de <strong>' ||
                        trim(vmes) ||
                        '</strong> , en su Cuenta de ahorros, la misma que no ha cumplido con el importe pactado de <strong>' ||
                        vsigno || trim(to_char(pjaql741sapn, '999,999,990.90')) ||
                        ' ,</strong> por lo que no se han generado intereses adicionales en el mes de <strong>' ||
                        trim(vmes) || '</strong>. </p>';
        End If;      
    End If;
  
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
  
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
  
    lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Agradeciendo su atención; reiteramos nuestro deseo de continuar brindándoles nuestros servicios con calidad y proporcionarle una buena alternativa para rentabilizar su dinero.</p>';
  
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
  
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
  
    lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos cordiales,<br/>Caja Arequipa</strong></p>';
  
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
  
    begin
    
      lv_asunto := 'Abono de intereses por tasa especial';
    
      begin
        select lower(trim(tp1desc))||'@cajaarequipa.pe'
          into lv_remitente
          from fst198
         Where Tp1cod = ppgcod
           and Tp1cod1 = 10818
           and Tp1corr1 = 6
           and Tp1corr2 = 3
           and Tp1corr3 = 3
           and Tp1nro1 = 1;
      exception
        when others then
          lv_remitente := trim(pjaql741usre) || '@cajaarequipa.pe';
      end;
    
      lv_destinos := '';
    
      for j in correos loop
        vfin     := 1;
        vCont    := 0;
        vlenmail := Length(Trim(pJAQL741MAIL));
      
        If vlenmail > 0 then
          While vfin <= vlenmail loop
            vCont   := vCont + 1;
            vPosini := InStr(pJAQL741MAIL, '\', vfin) - 1;
            vSize   := vPosini - vfin + 1;
            vPextxt := SubStr(pJAQL741MAIL, vfin, vSize);
            vfin    := vPosini + 2;
            if vPextxt = j.codmail then
              lv_destinos := lv_destinos || j.correo || ';';
            end if;
          End Loop;
        End If;
      end loop;
    
      lv_destinoscc := '';
    
      for j in correos_cc loop
        lv_destinoscc := lv_destinoscc || j.correo_cc || ';';
      end loop;
    
      -- Call the procedure
      vlenmail    := length(lv_destinos);
      lv_destinos := substr(lv_destinos, 1, vlenmail - 1);
    
      vlenmail      := length(lv_destinoscc);
      lv_destinoscc := substr(lv_destinoscc, 1, vlenmail - 1);
    
      pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                       p_destinatarioscc   => lv_destinoscc,
                                       p_destinatariosbcc  => '',
                                       p_mensaje           => ll_mensaje,
                                       p_remitente         => lv_remitente,
                                       p_asunto            => lv_asunto,
                                       p_tipomensaje       => 'HTML',
                                       p_directorio        => lv_directorio,
                                       p_archivosadjuntos  => lv_archivos,
                                       p_c_coderr          => perror,
                                       p_c_deserr          => perror);
    exception
      when others then
        perror := sqlerrm;
        dbms_output.put_line(perror);
    end;
    dbms_lob.freetemporary(ll_mensaje);
  
  end;

  ---------------------------------------------------------
  procedure sp_dml_curva(pModo   varchar2,
                         pMoneda number,
                         pMtoMin number,
                         pMtomax number,
                         pTasrec number,
                         pTasnue number,
                         pFecreg date,
                         pUsureg varchar2,
                         pFecvig date,
                         pError  out varchar2) is
  
  begin
  
    pError := 'Operación exitosa';
  
    Case
      When pModo = 'DEL' then
        delete from jaql743
         where jaql743fini = pFecvig
           and jaql743mone = pMoneda
           and jaql743mtmi = pMtoMin
           and jaql743mtma = pMtomax;
      
        if sql%notfound then
          pError := 'Rango no encontrado';
        end if;
      
      When pModo = 'UPD' then
      
        update jaql743
           set jaql743tare = pTasrec, 
               jaql743tanu = pTasnue, 
               jaql743au01 = pUsureg, 
               jaql743au05 = pFecreg
         where jaql743fini = pFecvig
           and jaql743mone = pMoneda
           and jaql743mtmi = pMtoMin
           and jaql743mtma = pMtomax;
      
        if sql%notfound then
          pError := 'Rango no encontrado';
        end if;
      
      When pModo = 'INS' then
        begin
          insert into jaql743
            (jaql743fini,
             jaql743mone,
             jaql743mtmi,
             jaql743mtma,
             jaql743tare,
             jaql743tanu,
             jaql743fere,
             jaql743usre,
             jaql743ffin
             )
          values
            (pFecvig,pMoneda, pMtoMin, pMtomax, pTasrec, pTasnue, pFecreg, pUsureg,last_day(pFecvig));
        exception
          when dup_val_on_index then
            pError := 'Rango ya existe';
          when others then
            pError := sqlerrm;
        end;
      Else
        pError := 'Opción incorrecta';
    End Case;
    commit;
  end;
  
end PQ_AH_TASA_NEGOCIADA;
/

