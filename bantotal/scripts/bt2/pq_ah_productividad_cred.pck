create or replace package PQ_AH_PRODUCTIVIDAD_CRED is

  -- Author  : MARAUJO
  -- Created : 15/05/2014 10:31:06 a.m.
  -- Purpose : Calculo de la productividad de EA/PA que captaron creds

  procedure Inicio(pd_fecini date,
                   pd_fecfin date,
                   pd_fecpro date,
                   Tcbio     number);

  procedure Proceso_CRE(pd_fecini date,
                        pd_fecfin date,
                        pd_fecpro date,
                        Tcbio     number,
                        pn_ctaini number,
                        pn_ctafin number);

  procedure Relacion_Linea(vPgcod  number,
                           vScmod  in out number,
                           vScsuc  in out number,
                           vScmda  in out number,
                           vScpap  in out number,
                           vSccta  in out number,
                           vScoper in out number,
                           vScsbop in out number,
                           vSctope in out number,
                           vscfval out date,
                           importe out number);

  procedure Tipo_Cli(pd_fecpro date,
                     pd_fecini date,
                     vpgcod    number,
                     vpepais   number,
                     vpetdoc   number,
                     vpendoc   char,
                     vtipocli  out char);

  procedure Garantia(vPgcod  number,
                     vScmod  number,
                     vScsuc  number,
                     vScmda  number,
                     vScpap  number,
                     vSccta  number,
                     vScoper number,
                     vScsbop number,
                     vSctope number,
                     vRelcod number,
                     vAfecto out char);

  procedure Arma_Totales(vUbuser   char,
                         vprfgcod  char,
                         vUbsuc    number,
                         pd_fecpro date,
                         pd_fecini date,
                         pd_fecfin date);

  procedure Paga_Captacion(pd_fecpro date, pd_fecini date, pd_fecfin date);

end PQ_AH_PRODUCTIVIDAD_CRED;
/

create or replace package body PQ_AH_PRODUCTIVIDAD_CRED is

  ----------------------------------------------------------------------

  procedure Inicio(pd_fecini date,
                   pd_fecfin date,
                   pd_fecpro date,
                   Tcbio     number) is
    cursor cta is
      select pbd1 pn_ctaini, pbh1 pn_ctafin
        from fsr101
       where pbnsec = 611
      --and pbthread = 1
      ;
  
    /*    cursor cta is
    select ctnro pn_ctaini, ctnro pn_ctafin
      from fsd008
     where ctnro in (1187273);*/
  
    cursor ejecutivo is
      select b.ubuser, b.prfgcod
        from FST198 a, prfu00 b
       Where Trim(a.Tp1desc) = trim(b.prfgcod)
         and Tp1cod = 1
         and Tp1cod1 = 10819
         and Tp1corr1 = 3;
  
    vUbsuc fst046.ubsuc%type;
  
  begin
  
    Delete from jaql702 Where jaql702FEPR = pd_fecpro;
    Delete from jaql703 Where jaql703FEPR = pd_fecpro;
  
    commit;
  
    for i in cta loop
      Proceso_CRE(pd_fecini,
                  pd_fecfin,
                  pd_fecpro,
                  Tcbio,
                  i.pn_ctaini,
                  i.pn_ctafin);
    end loop;
    commit;
  
    for j in ejecutivo loop
      vUbsuc := Productividad_Pasiva.Sucursal_Eje(1, j.ubuser);
      Arma_Totales(j.ubuser,
                   j.prfgcod,
                   vUbsuc,
                   pd_fecpro,
                   pd_fecini,
                   pd_fecfin);
    end loop;
    commit;
  
    Paga_Captacion(pd_fecpro, pd_fecini, pd_fecfin);
    commit;
  
  end;

  ----------------------------------------------------------------------

  procedure Proceso_CRE(pd_fecini date,
                        pd_fecfin date,
                        pd_fecpro date,
                        Tcbio     number,
                        pn_ctaini number,
                        pn_ctafin number) is
  
    cursor cred is
    
      select /*+CHOOSE */
       y.sng001usc,
       p.prfgcod,
       x.xwffcon,
       t.tonom,
       u.pepais,
       u.petdoc,
       u.pendoc,
       u.penom,
       decode(u.petipo, 'F', 1, 2) petipo,
       h.hrubro,
       decode(q.tp1desc, null, 'N', 'P') TIPOCRE,
       nvl(q.tp1desc, 'NO PYME') TIPODESC,
       y.sng001ori,
       r.*
        from XWF070 x,
             sng001 y,
             FST198 z,
             prfu00 p,
             xwf700 r,
             fst004 t,
             fsd001 u,
             fsh016 h,
             fst198 q
       where x.xwfprcin = y.sng001inst
         and Trim(z.Tp1desc) = trim(p.prfgcod)
         and y.SNG001USC = p.ubuser
         and r.xwfprcins = y.sng001inst
         and t.modulo = r.xwfmodulo
         and t.totope = r.xwftipope
         and u.pepais = y.sng001pais
         and u.petdoc = y.sng001tdoc
         and u.pendoc = y.sng001ndoc
         and h.pgcod = 1
         and h.hcmod = x.xwftmod
         and h.hsucor = x.xwftsuc
         and h.htran = x.xwfttran
         and h.hnrel = x.xwfnrel
         and h.hfcon = x.xwffcon
         and h.hmodul = r.xwfmodulo
         and h.hoper = r.xwfoperacion
         and r.xwfempresa = 1
         and r.xwfcuenta between pn_ctaini and pn_ctafin
         and q.tp1nro1(+) = substr(h.hrubro, 5, 2)
         and q.Tp1cod(+) = 1
         and q.tp1cod1(+) = 10823
         and q.tp1corr1(+) = 2
         and q.tp1corr2(+) = 2
         and z.Tp1cod = 1
         and z.Tp1cod1 = 10819
         and z.Tp1corr1 = 3
         and xwffcon between pd_fecini and pd_fecfin
         and xwfcont = 'S'
         and h.hcta = r.xwfcuenta
         and h.hsubop = r.xwfsubope
      --and y.sng015cod = 1
      ;
  
    vscmod_o  fsd011.scmod%type;
    vscoper_o fsd011.scoper%type;
    vscsbop_o fsd011.scsbop%type;
  
    vscmod  fsd011.scmod%type;
    vscsuc  fsd011.scsuc%type;
    vscmda  fsd011.scmda%type;
    vscpap  fsd011.scpap%type;
    vsccta  fsd011.sccta%type;
    vscoper fsd011.scoper%type;
    vscsbop fsd011.scsbop%type;
    vsctope fsd011.sctope%type;
    vscfcon fsd011.scfcon%type;
    vscfval fsd011.scfval%type;
    importe number;
  
    desem char(1);
  
    importe_mn number;
  
    tipocre char(1);
  
    tipocli char(1);
  
    vUbsuc  fst046.ubsuc%type;
    vpetipo number(1);
    gardpf  char(1);
    topedpf char(1);
  
    vTP1IMP1 number;
    vTP1IMP2 number;
  
    Ampliado char(1);
  
  begin
  
    for i in cred loop
    
      vscmod  := i.xwfmodulo;
      vscsuc  := i.xwfsucursal;
      vscmda  := i.xwfmoneda;
      vscpap  := i.xwfpapel;
      vsccta  := i.xwfcuenta;
      vscoper := i.xwfoperacion;
      vscsbop := i.xwfsubope;
      vsctope := i.xwftipope;
      vscfcon := i.xwffcon;
      importe := i.xwfmonto1;
    
      begin
        select 'S'
          into desem
          from fsd010
         where PGCOD = i.xwfempresa
           and AOMOD = vscmod
           and AOSUC = vscsuc
           and AOMDA = vscmda
           and AOPAP = vscpap
           and AOCTA = vsccta
           and AOOPER = vscoper
           and AOSBOP = vscsbop
           and AOTOPE = vsctope
           and AOFVAL between pd_fecini and pd_fecfin
           and AOSTAT <> 99;
      exception
        when no_data_found then
          desem := 'N';
      end;
    
      if desem = 'S' then
      
        vscmod_o  := vscmod;
        vscoper_o := vscoper;
        vscsbop_o := vscsbop;
        tipocre   := i.tipocre;
      
        If vscmod = 117 then
          vscoper_o := vscoper;
          vscsbop_o := vscsbop;
          Relacion_Linea(i.xwfempresa,
                         vscmod,
                         vscsuc,
                         vscmda,
                         vscpap,
                         vsccta,
                         vscoper,
                         vscsbop,
                         vsctope,
                         vscfval,
                         importe);
        
          begin
            select decode(q.tp1desc, null, 'N', 'P') TIPOCRE
              into tipocre
              from fsh016 h, fst198 q
             where q.tp1nro1(+) = substr(h.hrubro, 5, 2)
               and q.Tp1cod(+) = 1
               and q.tp1cod1(+) = 10823
               and q.tp1corr1(+) = 2
               and q.tp1corr2(+) = 2
               and PGCOD = i.xwfempresa
               and HMODUL = vscmod
               and HSUCUR = vscsuc
               and HMDA = vscmda
               and HPAP = vscpap
               and HCTA = vsccta
               and HOPER = vscoper
               and HSUBOP = vscsbop
               and HTOPER = vsctope
               and HFVAL = vscfval
               and not (h.hcmod = 98 and htran = 405); --no incluye reclasificación sbs
          exception
            when no_data_found then
              tipocre := 'X';
            when others then
              tipocre := 'X';
          end;
        End If;
      
        if vscmod <> 0 then
        
          if vscmda <> 0 then
            importe_mn := Tcbio * importe;
          else
            importe_mn := importe;
          end if;
        
          Tipo_Cli(pd_fecpro,
                   pd_fecini,
                   i.xwfempresa,
                   i.pepais,
                   i.petdoc,
                   i.pendoc,
                   tipocli);
        
          Garantia(i.xwfempresa,
                   vscmod_o,
                   vscsuc,
                   vscmda,
                   vscpap,
                   vsccta,
                   vscoper_o,
                   vscsbop_o,
                   vsctope,
                   2,
                   gardpf);
        
          -- cred está dentro de los topes por cred que el EA/PA puede captar??         
          begin
            select TP1IMP1, TP1IMP2
              into vTP1IMP1, vTP1IMP2
              from fst198
             where Tp1cod = i.xwfempresa
               and tp1cod1 = 10819
               and tp1corr1 = 12
               and Trim(Tp1desc) = trim(i.prfgcod);
          
            if gardpf = 'S' then
              if importe_mn <= vTP1IMP1 then
                topedpf := 'S';
              else
                topedpf := 'N';
              end if;
            else
              if importe_mn <= vTP1IMP2 then
                topedpf := 'S';
              else
                topedpf := 'N';
              end if;
            end if;
          
          exception
            when no_data_found then
              begin
                select TP1IMP1, TP1IMP2
                  into vTP1IMP1, vTP1IMP2
                  from fst198
                 where Tp1cod = i.xwfempresa
                   and tp1cod1 = 10819
                   and tp1corr1 = 12
                   and Trim(Tp1desc) is null;
              
                if gardpf = 'S' then
                  if importe_mn <= vTP1IMP1 then
                    topedpf := 'S';
                  else
                    topedpf := 'N';
                  end if;
                else
                  if importe_mn <= vTP1IMP2 then
                    topedpf := 'S';
                  else
                    topedpf := 'N';
                  end if;
                end if;
              
              exception
                when no_data_found then
                  topedpf := 'N';
              end;
          end;
        
          /*        begin
            select decode(petipo, 'F', 1, 2)
              into vpetipo
              from FSD001
             Where Pepais = i.pepais
               and Petdoc = i.petdoc
               and Pendoc = i.pendoc;
          exception
            when others then
              vpetipo := null;
          end;*/
        
          vpetipo := i.petipo;
        
          vUbsuc := Productividad_Pasiva.Sucursal_Eje(i.xwfempresa,
                                                      i.sng001usc);
        
          if i.sng001ori in (4, 12) then
            Ampliado := 'S';
          else
            Ampliado := 'N';
          end if;
        
          begin
            insert into jaql702
              (jaql702fepr,
               jaql702fein,
               jaql702fefi,
               jaql702user,
               jaql702pgco,
               jaql702scmo,
               jaql702scsu,
               jaql702scmd,
               jaql702scpa,
               jaql702scct,
               jaql702scop,
               jaql702scsb,
               jaql702scto,
               jaql702feca,
               jaql702mtor,
               jaql702mtmn,
               jaql702tica,
               jaql702ticr,
               jaql702ticl,
               jaql702tipe,
               jaql702pais,
               jaql702tdoc,
               jaql702ndoc,
               jaql702perf,
               jaql702sucu,
               jaql702au07,
               jaql702au01,
               jaql702au02,
               jaql702au03)
            values
              (pd_fecpro,
               pd_fecini,
               pd_fecfin,
               i.sng001usc,
               i.xwfempresa,
               vscmod,
               vscsuc,
               vscmda,
               vscpap,
               vsccta,
               vscoper,
               vscsbop,
               vsctope,
               vscfcon,
               importe,
               importe_mn,
               Tcbio,
               tipocre,
               tipocli,
               vpetipo,
               i.pepais,
               i.petdoc,
               i.pendoc,
               i.prfgcod,
               vUbsuc,
               i.xwfprcins,
               gardpf,
               topedpf,
               Ampliado);
          exception
            when dup_val_on_index then
              null;
          end;
        end if;
      end if;
    end loop;
  end;

  ----------------------------------------------------------------------
  procedure Relacion_Linea(vPgcod  number,
                           vScmod  in out number,
                           vScsuc  in out number,
                           vScmda  in out number,
                           vScpap  in out number,
                           vSccta  in out number,
                           vScoper in out number,
                           vScsbop in out number,
                           vSctope in out number,
                           vscfval out date,
                           importe out number) is
  
    rscmod  fsd011.scmod%type;
    rscsuc  fsd011.scsuc%type;
    rscmda  fsd011.scmda%type;
    rscpap  fsd011.scpap%type;
    rsccta  fsd011.sccta%type;
    rscoper fsd011.scoper%type;
    rscsbop fsd011.scsbop%type;
    rsctope fsd011.sctope%type;
  
  begin
    rscmod  := vScmod;
    rscsuc  := vScsuc;
    rscmda  := vScmda;
    rscpap  := vScpap;
    rsccta  := vSccta;
    rscoper := vScoper;
    rscsbop := vScsbop;
    rsctope := vSctope;
  
    begin
      select r1mod, r1suc, r1mda, r1pap, r1cta, r1oper, r1sbop, r1tope
        into vScmod,
             vScsuc,
             vScmda,
             vScpap,
             vSccta,
             vScoper,
             vScsbop,
             vSctope
        from (select r1mod,
                     r1suc,
                     r1mda,
                     r1pap,
                     r1cta,
                     r1oper,
                     r1sbop,
                     r1tope
                from fsr011
               where relcod = 46
                 and R2COD = vPgcod
                 and r2mod = rscmod
                 and r2suc = rscsuc
                 and r2mda = rscmda
                 and r2pap = rscpap
                 and r2cta = rsccta
                 and r2oper = rscoper
                 and r2sbop = rscsbop
                 and r2tope = rsctope
                 and r011co = 'S'
               order by r011fc)
       where rownum = 1;
    
      select aoimp, aofval
        into importe, vscfval
        from fsd010
       where PGCOD = vpgcod
         and AOMOD = vscmod
         and AOSUC = vscsuc
         and AOMDA = vscmda
         and AOPAP = vscpap
         and AOCTA = vsccta
         and AOOPER = vscoper
         and AOSBOP = vscsbop
         and AOTOPE = vsctope;
    
    exception
      when no_data_found then
        vScmod := 0;
    end;
  end;

  ----------------------------------------------------------------------
  procedure Tipo_Cli(pd_fecpro date,
                     pd_fecini date,
                     vpgcod    number,
                     vpepais   number,
                     vpetdoc   number,
                     vpendoc   char,
                     vtipocli  out char) is
  
    dias_inac  number;
    fecha_inac date;
  
    cursor modu is
      select modulo from fst111 where dscod = 50;
  
    cursor ctas is
      select distinct ctnro
        from fsr008
       where (pepais, petdoc, pendoc) in
             (select pepais, petdoc, pendoc
                from fsr008
               where pgcod = vpgcod
                 and ctnro in (select ctnro
                                 from fsr008
                                where PEPAIS = vpepais
                                  and PETDOC = vpetdoc
                                  and PENDOC = vpendoc
                                  and ttcod = 1));
  
  begin
  
    begin
      select TP1NRO1
        into dias_inac
        from fst198
       where Tp1cod = 1
         and tp1cod1 = 10819
         and tp1corr1 = 14;
    exception
      when no_data_found then
        dias_inac := 0;
    end;
  
    fecha_inac := pd_fecini - dias_inac;
  
    vtipocli := 'X';
  
    for a in modu loop
      for i in ctas loop
        begin
          select 'R'
            into vtipocli
            from fsd010
           where pgcod = vpgcod
             and aomod = a.modulo
             and aocta = i.ctnro
             and aofval <= pd_fecini
             and aostat <> 99
             and rownum = '1'
           order by aofval;
          exit;
        exception
          when no_data_found then
            begin
              select case
                       when aofe99 < fecha_inac and vtipocli in ('X', 'N') then
                        'I'
                       else
                        'R'
                     end
                into vtipocli
                from (select aofval, aofe99, aostat
                        from fsd010
                       where pgcod = vpgcod
                         and aomod = a.modulo
                         and aocta = i.ctnro
                         and aostat = 99
                         and aofval <= pd_fecini
                       order by aofe99 desc)
               where rownum = 1;
            exception
              when no_data_found then
                If vtipocli in ('X', 'N') then
                  vtipocli := 'N';
                end if;
            end;
        end;
      end loop;
    end loop;
  end;

  ----------------------------------------------------------------------
  procedure Garantia(vPgcod  number,
                     vScmod  number,
                     vScsuc  number,
                     vScmda  number,
                     vScpap  number,
                     vSccta  number,
                     vScoper number,
                     vScsbop number,
                     vSctope number,
                     vRelcod number,
                     vAfecto out char) is
  begin
    select 'S'
      into vAfecto
      from fsr011 a, fsr011 b
     where a.relcod = 50
       and a.r1cod = vPgcod
       and a.r1mod = vScmod
       and a.r1suc = vScsuc
       and a.r1mda = vScmda
       and a.r1pap = vScpap
       and a.r1cta = vSccta
       and a.r1oper = vScoper
       and a.r1sbop = vScsbop
       and a.r1tope = vSctope
       and b.r2cta = a.r2cta
       and b.r2oper = a.r2oper
       and b.r2sbop = a.r2sbop
       and b.relcod = vRelcod
       and rownum = 1;
  exception
    when no_data_found then
      vAfecto := 'N';
  end;

  ----------------------------------------------------------------------     

  procedure Arma_Totales(vUbuser   char,
                         vprfgcod  char,
                         vUbsuc    number,
                         pd_fecpro date,
                         pd_fecini date,
                         pd_fecfin date) is
  
    cursor total is
      select *
        from jaql702
       Where JAQL702FEPR = pd_fecpro
         and JAQL702USER = vUbuser
         and JAQL702AU02 = 'S';
  
    vjaql703mtpy number;
    vjaql703mtot number;
    vjaql703nucn number;
    vjaql703nucr number;
  
  begin
    for i in total loop
      begin
        if i.JAQL702AU03 = 'N' then
          --si no es ampliado se considera el monto
          if i.jaql702ticr = 'P' then
            vjaql703mtpy := i.jaql702mtmn;
            vjaql703mtot := 0;
          else
            vjaql703mtpy := 0;
            vjaql703mtot := i.jaql702mtmn;
          end if;
        else
          vjaql703mtpy := 0;
          vjaql703mtot := 0;
        end if;
      
        if i.jaql702ticl in ('N', 'I') then
          vjaql703nucn := 1;
          vjaql703nucr := 0;
        else
          vjaql703nucn := 0;
          vjaql703nucr := 1;
        end if;
      
        insert into jaql703
          (jaql703fepr,
           jaql703fein,
           jaql703fefi,
           jaql703user,
           jaql703perf,
           jaql703sucu,
           jaql703mtpy,
           jaql703mtot,
           jaql703nucn,
           jaql703nucr)
        values
          (pd_fecpro,
           pd_fecini,
           pd_fecfin,
           vUbuser,
           vprfgcod,
           vUbsuc,
           vjaql703mtpy,
           vjaql703mtot,
           vjaql703nucn,
           vjaql703nucr);
      exception
        when dup_val_on_index then
          update jaql703
             set jaql703mtpy = jaql703mtpy + nvl(vjaql703mtpy, 0),
                 jaql703mtot = jaql703mtot + nvl(vjaql703mtot, 0),
                 jaql703nucn = jaql703nucn + nvl(vjaql703nucn, 0),
                 jaql703nucr = jaql703nucr + nvl(vjaql703nucr, 0)
           where jaql703fepr = pd_fecpro
             and jaql703fein = pd_fecini
             and jaql703fefi = pd_fecfin
             and jaql703user = vUbuser;
      end;
    end loop;
  end;

  ----------------------------------------------------------------------     

  procedure Paga_Captacion(pd_fecpro date, pd_fecini date, pd_fecfin date) is
    cursor final is
      select *
        from jaql703
       where jaql703fepr = pd_fecpro
         and jaql703fein = pd_fecini
         and jaql703fefi = pd_fecfin;
  
    meta_C number;
    comi_N number;
    comi_R number;
    meta_M number;
    comi_P number;
    comi_O number;
  
    cumple char(1);
  
    vJAQL703COMT number;
    vJAQL703COCL number;
    vJAQL703TOCO number;
  
    Tope number;
  
  begin
    for i in final loop
    
      begin
        -- clientes
        select TP1IMP1, TP1IMP2, TP1IMP3
          into meta_C, comi_N, comi_R
          from fst198
         where Tp1cod = 1
           and tp1cod1 = 10819
           and tp1corr1 = 11
           and tp1corr2 = 1
           and Trim(Tp1desc) = trim(i.jaql703perf);
      exception
        when no_data_found then
          meta_C := 0;
          comi_N := 0;
          comi_R := 0;
      end;
    
      --monto
      begin
        select TP1IMP1, TP1IMP2, TP1IMP3
          into meta_M, comi_P, comi_O
          from fst198
         where Tp1cod = 1
           and tp1cod1 = 10819
           and tp1corr1 = 11
           and tp1corr2 = 2
           and Trim(Tp1desc) = trim(i.jaql703perf);
      exception
        when no_data_found then
          meta_M := 0;
          comi_P := 0;
          comi_O := 0;
      end;
    
      if meta_C <= i.jaql703nucn + i.jaql703nucr then
        vJAQL703COCL := (i.jaql703nucn * comi_N) + (i.jaql703nucr * comi_R);
        cumple       := 'S';
      else
        vJAQL703COCL := 0;
        cumple       := 'N';
      end if;
    
      if meta_M <= i.jaql703mtpy + i.jaql703mtot and cumple = 'S' then
        vJAQL703COMT := (i.jaql703mtpy * (comi_P / 100)) +
                        (i.jaql703mtot * (comi_O / 100));
      else
        vJAQL703COMT := 0;
      end if;
    
      vJAQL703TOCO := vJAQL703COMT + vJAQL703COCL;
    
      begin
        select TP1IMP1
          into Tope
          from fst198
         where Tp1cod = 1
           and tp1cod1 = 10819
           and tp1corr1 = 13
           and tp1corr2 = i.jaql703sucu
           and Trim(Tp1desc) = trim(i.jaql703perf);
      exception
        when no_data_found then
          begin
            select TP1IMP1
              into Tope
              from fst198
             where Tp1cod = 1
               and tp1cod1 = 10819
               and tp1corr1 = 13
               and tp1corr2 = 999
               and Trim(Tp1desc) = trim(i.jaql703perf);
          exception
            when no_data_found then
              begin
                select TP1IMP1
                  into Tope
                  from fst198
                 where Tp1cod = 1
                   and tp1cod1 = 10819
                   and tp1corr1 = 13
                   and tp1corr2 = i.jaql703sucu
                   and Trim(Tp1desc) is null;
              exception
                when no_data_found then
                  begin
                    select TP1IMP1
                      into Tope
                      from fst198
                     where Tp1cod = 1
                       and tp1cod1 = 10819
                       and tp1corr1 = 13
                       and tp1corr2 = 999
                       and Trim(Tp1desc) is null;
                  exception
                    when no_data_found then
                      Tope := 0;
                  end;
              end;
          end;
      end;
    
      If vJAQL703TOCO > tope then
        vJAQL703TOCO := tope;
      end if;
    
      update jaql703
         set JAQL703COMT = vJAQL703COMT,
             JAQL703COCL = vJAQL703COCL,
             JAQL703TOCO = vJAQL703TOCO,
             JAQL703AU04 = meta_C,
             JAQL703AU05 = comi_N,
             JAQL703AU06 = comi_R,
             JAQL703AU07 = meta_m,
             JAQL703AU08 = comi_p,
             JAQL703AU09 = comi_o
       where jaql703fepr = pd_fecpro
         and jaql703fein = pd_fecini
         and jaql703fefi = pd_fecfin
         and jaql703user = i.jaql703user;
    end loop;
  
  end;
  ----------------------------------------------------------------------    

end PQ_AH_PRODUCTIVIDAD_CRED;
/

