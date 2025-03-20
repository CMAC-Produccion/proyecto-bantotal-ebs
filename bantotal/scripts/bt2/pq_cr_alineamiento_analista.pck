create or replace package PQ_CR_ALINEAMIENTO_ANALISTA is

  -- Author  : MPOSTIGOC
  -- Created : 8/08/2022 22:46:27
  -- Purpose : 

  procedure sp_cr_Inicio(ln_Instancia in number,
                         ln_diascanc  out number,
                         ld_fchcanc   out date,
                         lc_asesor    out varchar2,
                         ln_Instcanc  out number,
                         ln_SucCanc   out number,
                         ln_SucAse    out number);
  ---------------------------------------------------------
  procedure sp_cr_VerificaDPFCTS(ln_pgcod     in number,
                                 ln_modulo    in number,
                                 ln_sucursal  in number,
                                 ln_moneda    in number,
                                 ln_papel     in number,
                                 ln_cuenta    in number,
                                 ln_operac    in number,
                                 ln_suboper   in number,
                                 ln_tipoper   in number,
                                 lc_VerifExcp out Varchar2);
  --------------------------------------------------------------          
  procedure sp_Cr_LogAQPA391(ln_391inst   in number,
                             ld_391fec    in date,
                             ln_391ican   in number,
                             lc_391acan   in varchar2,
                             ld_391fcan   in date,
                             ln_391dcan   in number,
                             ln_391sucan  in number,
                             ln_391casec  in number,
                             lc_391dpfca  in varchar2,
                             lc_391INHASE in varchar2,
                             lc_391asesor in varchar2,
                             ln_391sucase in number);

end PQ_CR_ALINEAMIENTO_ANALISTA;
/

create or replace package body PQ_CR_ALINEAMIENTO_ANALISTA is

  procedure sp_cr_Inicio(ln_Instancia in number,
                         ln_diascanc  out number,
                         ld_fchcanc   out date,
                         lc_asesor    out varchar2,
                         ln_Instcanc  out number,
                         ln_SucCanc   out number,
                         ln_SucAse    out number) is
  
    cursor lista_CredCanc is
    
      select *
        from fsd010 f
       where f.pgcod = 1
         and f.aomod in
             (select g.modulo
                from fst111 g
               where g.dscod = 50
                 and g.modulo not in (select f.tp1nro3
                                        from fst198 f
                                       where f.tp1cod = 1
                                         and f.tp1cod1 = 10899
                                         and f.tp1corr1 = 110
                                         and f.tp1corr2 = 1
                                         and f.tp1corr3 > 1))
         and f.aopap = 0
         and f.aomda in (0, 101)
         and f.aocta in (select r.ctnro
                           from sng001 s, fsr008 r
                          where s.sng001pais = r.pepais
                            and s.sng001tdoc = r.petdoc
                            and s.sng001ndoc = r.pendoc
                            and r.cttfir = 'T'
                            and s.sng001inst = ln_Instancia)
         and f.aostat = 99
       order by f.aofe99 desc;
  
    cursor creditos(ln_pgcod number,
                    ln_suc   number,
                    ln_mod   number,
                    ln_mda   number,
                    ln_pap   number,
                    ln_cta   number,
                    ln_ope   number,
                    ln_sub   number,
                    ln_tope  number) is
    
      select x.xwfprcins
        from xwf700 x
       where x.xwfempresa = ln_pgcod
         and x.xwfsucursal = ln_suc
         and x.xwfmodulo = ln_mod
         and x.xwfmoneda = ln_mda
         and x.xwfpapel = ln_pap
         and x.xwfcuenta = ln_cta
         and x.xwfoperacion = ln_ope
         and x.xwfsubope = ln_sub
         and x.xwftipope = ln_tope
         and x.xwfcar3 <> '1'
       order by x.xwfprcins desc;
  
    lc_VerifExcp varchar2(5) := 'S';
    --lc_VerifHipo varchar2(5) := 'S';
    ld_fechaSist    date;
    ln_EstaInhab    number;
    ln_SucAsesor    number;
    ln_SucCred      number;
    ln_cargo        number;
    lc_asesorcanc   varchar2(10);
    ln_SucCredCanc  number;
    ln_Inhabilitado varchar2(10);
    ln_cont         number;
    ln_contOri      number;
    lc_sigue        varchar2(5) := 'S';
    ln_estaAct      number;
  
  begin
  
    begin
      select f.pgfape into ld_fechaSist from fst017 f where f.pgcod = 1;
    end;
  
    begin
      delete aqpa391 a where a.aqpa391inst = ln_Instancia;
      commit;
    end;
  
    for I in lista_CredCanc loop
      for c in creditos(i.pgcod,
                        i.aosuc,
                        i.aomod,
                        i.aomda,
                        i.aopap,
                        i.aocta,
                        i.aooper,
                        i.aosbop,
                        i.aotope) loop
      
        begin
          select count(*)
            into ln_cont
            from xwf070 x
           where x.xwfprcin = c.xwfprcins
             and x.xwfcont = 'S';
        end;
      
        if ln_cont > 0 then
        
          begin
            select count(*)
              into ln_contOri
              from sng001 s
             where s.sng001inst = c.xwfprcins
               and s.sng001ori in (3, 4, 12, 13, 14, 15, 16);
          end;
        
          if ln_contOri > 0 then
          
            select count(*)
              into ln_estaAct
              from fsd010 f, xwf700 x
             where f.pgcod = x.xwfempresa
               and f.aomod = x.xwfmodulo
               and f.aosuc = x.xwfsucursal
               and f.aomda = x.xwfmoneda
               and f.aopap = x.xwfpapel
               and f.aocta = x.xwfcuenta
               and f.aooper = x.xwfoperacion
               and f.aosbop = x.xwfsubope
               and f.aotope = x.xwftipope
               and x.xwfprcins = c.xwfprcins
               and f.aostat <> 99;
          
            if ln_estaAct > 0 then
            
              lc_sigue := 'N';
              exit;
            else
              lc_sigue := 'S';
            end if;
          else
            lc_sigue := 'S';
          end if;
        
        end if;
      end loop;
    
      if lc_sigue = 'S' then
      
        -- Verifica Garantia DPF/CTS
      
        PQ_CR_ALINEAMIENTO_ANALISTA.sp_cr_VerificaDPFCTS(ln_pgcod     => I.PGCOD,
                                                         ln_modulo    => I.AOMOD,
                                                         ln_sucursal  => I.AOSUC,
                                                         ln_moneda    => I.AOMDA,
                                                         ln_papel     => I.AOPAP,
                                                         ln_cuenta    => I.AOCTA,
                                                         ln_operac    => I.AOOPER,
                                                         ln_suboper   => I.AOSBOP,
                                                         ln_tipoper   => I.AOTOPE,
                                                         lc_VerifExcp => lc_VerifExcp);
      
        if lc_VerifExcp = 'S' then
        
          ln_diascanc := ld_fechaSist - i.aofe99;
          ld_fchcanc  := i.aofe99;
          ln_Instcanc := fn_instancia_credito(v_Scmod  => i.aomod,
                                              v_Scsuc  => i.aosuc,
                                              v_Scmda  => i.aomda,
                                              v_Scpap  => i.aopap,
                                              v_Sccta  => i.aocta,
                                              v_Scoper => i.aooper,
                                              v_Scsbop => i.aosbop,
                                              v_Sctope => i.aotope);
          begin
            select SNG001ASE
              into lc_asesorcanc
              from sng001
             where SNG001INST = ln_Instcanc;
          exception
            when others then
              null;
          end;
          begin
            select s.sng055car
              into ln_cargo
              from sng057 s
             where s.sng057usr = lc_asesorcanc;
          exception
            when others then
              null;
          end;
        
          begin
            begin
              select count(*)
                into ln_EstaInhab
                from sngu02 s
               where s.sngu02usr = lc_asesorcanc
                 and s.sngu02inh = 'S'; -- sngu02inh = 'S' si esta inhabilitado
            end;
          
            if ln_EstaInhab > 0 then
              ln_Inhabilitado := 'SI';
            else
              ln_Inhabilitado := 'NO';
            end if;
          
          end;
        
          begin
            select SNG001ASE
              into lc_asesor
              from sng001
             where SNG001INST = ln_Instancia;
          exception
            when others then
              null;
          end;
        
          begin
            select x.xwfsucursal
              into ln_SucCredCanc
              from xwf700 x
             where x.xwfprcins = ln_Instcanc
               and x.xwfcar3 = '1';
          exception
            when others then
              null;
          end;
        
          -------------------
          -- Sucursal del analista
          begin
            select SNG001ASE
              into lc_asesor
              from sng001
             where SNG001INST = ln_Instancia;
          exception
            when others then
              null;
          end;
        
          begin
          
            select f.ubsuc
              into ln_SucAsesor
              from fst046 f
             where f.pgcod = 1
               and f.ubuser = lc_asesor;
          exception
            when others then
              null;
          end;
          ------------------------------------
        
          ln_SucCanc := ln_SucCredCanc;
          ln_SucAse  := ln_SucAsesor;
        
          pq_Cr_alineamiento_analista.sp_Cr_LogAQPA391(ln_391inst   => ln_Instancia,
                                                       ld_391fec    => ld_fechaSist,
                                                       ln_391ican   => ln_Instcanc,
                                                       lc_391acan   => lc_asesorcanc,
                                                       ld_391fcan   => ld_fchcanc,
                                                       ln_391dcan   => ln_diascanc,
                                                       ln_391sucan  => ln_SucCredCanc,
                                                       ln_391casec  => ln_cargo,
                                                       lc_391dpfca  => lc_VerifExcp,
                                                       lc_391INHASE => ln_Inhabilitado,
                                                       lc_391asesor => lc_asesor,
                                                       ln_391sucase => ln_SucAsesor);
        
          exit;
        
        else
          /*  
           -  Si el analista del crédito cancelado  se encuentra:  
                o Inhabilitado por cese u otro.     
          */
          ln_diascanc := ld_fechaSist - i.aofe99;
          ld_fchcanc  := i.aofe99;
          ln_Instcanc := fn_instancia_credito(v_Scmod  => i.aomod,
                                              v_Scsuc  => i.aosuc,
                                              v_Scmda  => i.aomda,
                                              v_Scpap  => i.aopap,
                                              v_Sccta  => i.aocta,
                                              v_Scoper => i.aooper,
                                              v_Scsbop => i.aosbop,
                                              v_Sctope => i.aotope);
          begin
            select SNG001ASE
              into lc_asesorcanc
              from sng001
             where SNG001INST = ln_Instcanc;
          exception
            when others then
              null;
          end;
          begin
            select s.sng055car
              into ln_cargo
              from sng057 s
             where s.sng057usr = lc_asesorcanc;
          exception
            when others then
              null;
          end;
        
          begin
            select count(*)
              into ln_EstaInhab
              from sngu02 s
             where s.sngu02usr = lc_asesorcanc
               and s.sngu02inh = 'S'; -- sngu02inh = 'S' si esta inhabilitado
          end;
        
          if ln_EstaInhab > 0 then
            ln_Inhabilitado := 'SI';
          else
            ln_Inhabilitado := 'NO';
          end if;
        
          begin
            select x.xwfsucursal
              into ln_SucCredCanc
              from xwf700 x
             where x.xwfprcins = ln_Instcanc
               and x.xwfcar3 = '1';
          exception
            when others then
              null;
          end;
        
          -------------------
          -- Sucursal del analista
          begin
            select SNG001ASE
              into lc_asesor
              from sng001
             where SNG001INST = ln_Instancia;
          exception
            when others then
              null;
          end;
        
          begin
          
            select f.ubsuc
              into ln_SucAsesor
              from fst046 f
             where f.pgcod = 1
               and f.ubuser = lc_asesor;
          exception
            when others then
              null;
          end;
          ------------------------------------
          if ln_EstaInhab > 0 then
            ln_diascanc := ld_fechaSist - i.aofe99;
            ld_fchcanc  := i.aofe99;
            ln_Instcanc := fn_instancia_credito(v_Scmod  => i.aomod,
                                                v_Scsuc  => i.aosuc,
                                                v_Scmda  => i.aomda,
                                                v_Scpap  => i.aopap,
                                                v_Sccta  => i.aocta,
                                                v_Scoper => i.aooper,
                                                v_Scsbop => i.aosbop,
                                                v_Sctope => i.aotope);
            begin
              select SNG001ASE
                into lc_asesor
                from sng001
               where SNG001INST = ln_Instancia;
            exception
              when others then
                null;
            end;
          
            ln_SucCanc := ln_SucCredCanc;
            ln_SucAse  := ln_SucAsesor;
          
            pq_Cr_alineamiento_analista.sp_Cr_LogAQPA391(ln_391inst   => ln_Instancia,
                                                         ld_391fec    => ld_fechaSist,
                                                         ln_391ican   => ln_Instcanc,
                                                         lc_391acan   => lc_asesorcanc,
                                                         ld_391fcan   => ld_fchcanc,
                                                         ln_391dcan   => ln_diascanc,
                                                         ln_391sucan  => ln_SucCredCanc,
                                                         ln_391casec  => ln_cargo,
                                                         lc_391dpfca  => lc_VerifExcp,
                                                         lc_391INHASE => ln_Inhabilitado,
                                                         lc_391asesor => lc_asesor,
                                                         ln_391sucase => ln_SucAsesor);
          
            exit;
          
            /* o  El cargo actual es diferencia de analista (200) o analista senior (201) y
                  o No se encuentra en la misma sucursal donde se realiza la solicitud
            Devolverá las siglas del analista de la solicitud.*/
          else
          
            ln_Instcanc := fn_instancia_credito(v_Scmod  => i.aomod,
                                                v_Scsuc  => i.aosuc,
                                                v_Scmda  => i.aomda,
                                                v_Scpap  => i.aopap,
                                                v_Sccta  => i.aocta,
                                                v_Scoper => i.aooper,
                                                v_Scsbop => i.aosbop,
                                                v_Sctope => i.aotope);
          
            begin
              select x.xwfsucursal
                into ln_SucCred
                from xwf700 x
               where x.xwfprcins = ln_Instcanc
                 and x.xwfcar3 = '1';
            exception
              when others then
                null;
            end;
          
            begin
              select SNG001ASE
                into lc_asesorCanc
                from sng001
               where SNG001INST = ln_Instcanc;
            exception
              when others then
                null;
            end;
          
            begin
              select s.sng055car
                into ln_cargo
                from sng057 s
               where s.sng057usr = lc_asesorCanc;
            exception
              when others then
                null;
              
            end;
          
            -----------------------------
            -- Sucursal del analista
            begin
              select SNG001ASE
                into lc_asesor
                from sng001
               where SNG001INST = ln_Instancia;
            exception
              when others then
                null;
            end;
          
            begin
              select f.ubsuc
                into ln_SucAsesor
                from fst046 f
               where f.pgcod = 1
                 and f.ubuser = lc_asesor;
            exception
              when others then
                null;
            end;
            ------------------------------------
          
            if (ln_SucCred <> ln_SucAsesor) and
               (ln_cargo not in (200, 201)) then
              ln_diascanc := ld_fechaSist - i.aofe99;
              ld_fchcanc  := i.aofe99;
              ln_Instcanc := fn_instancia_credito(v_Scmod  => i.aomod,
                                                  v_Scsuc  => i.aosuc,
                                                  v_Scmda  => i.aomda,
                                                  v_Scpap  => i.aopap,
                                                  v_Sccta  => i.aocta,
                                                  v_Scoper => i.aooper,
                                                  v_Scsbop => i.aosbop,
                                                  v_Sctope => i.aotope);
            
              begin
                select SNG001ASE
                  into lc_asesorcanc
                  from sng001
                 where SNG001INST = ln_Instcanc;
              exception
                when others then
                  null;
              end;
              begin
                select SNG001ASE
                  into lc_asesor
                  from sng001
                 where SNG001INST = ln_Instancia;
              exception
                when others then
                  null;
              end;
            
              ln_SucCanc := ln_SucCredCanc;
              ln_SucAse  := ln_SucAsesor;
            
              pq_Cr_alineamiento_analista.sp_Cr_LogAQPA391(ln_391inst   => ln_Instancia,
                                                           ld_391fec    => ld_fechaSist,
                                                           ln_391ican   => ln_Instcanc,
                                                           lc_391acan   => lc_asesorcanc,
                                                           ld_391fcan   => ld_fchcanc,
                                                           ln_391dcan   => ln_diascanc,
                                                           ln_391sucan  => ln_SucCred,
                                                           ln_391casec  => ln_cargo,
                                                           lc_391dpfca  => lc_VerifExcp,
                                                           lc_391INHASE => ln_Inhabilitado,
                                                           lc_391asesor => lc_asesor,
                                                           ln_391sucase => ln_SucAsesor);
            
              exit;
            
            else
            
              ln_diascanc := ld_fechaSist - i.aofe99;
              ld_fchcanc  := i.aofe99;
              ln_Instcanc := fn_instancia_credito(v_Scmod  => i.aomod,
                                                  v_Scsuc  => i.aosuc,
                                                  v_Scmda  => i.aomda,
                                                  v_Scpap  => i.aopap,
                                                  v_Sccta  => i.aocta,
                                                  v_Scoper => i.aooper,
                                                  v_Scsbop => i.aosbop,
                                                  v_Sctope => i.aotope);
            
              begin
                select SNG001ASE
                  into lc_asesorcanc
                  from sng001
                 where SNG001INST = ln_Instcanc;
              exception
                when others then
                  null;
              end;
              begin
                select SNG001ASE
                  into lc_asesor
                  from sng001
                 where SNG001INST = ln_Instcanc;
              exception
                when others then
                  null;
              end;
            
              ln_SucCanc := ln_SucCredCanc;
              ln_SucAse  := ln_SucAsesor;
            
              pq_Cr_alineamiento_analista.sp_Cr_LogAQPA391(ln_391inst   => ln_Instancia,
                                                           ld_391fec    => ld_fechaSist,
                                                           ln_391ican   => ln_Instcanc,
                                                           lc_391acan   => lc_asesorcanc,
                                                           ld_391fcan   => ld_fchcanc,
                                                           ln_391dcan   => ln_diascanc,
                                                           ln_391sucan  => ln_SucCred,
                                                           ln_391casec  => ln_cargo,
                                                           lc_391dpfca  => lc_VerifExcp,
                                                           lc_391INHASE => ln_Inhabilitado,
                                                           lc_391asesor => lc_asesor,
                                                           ln_391sucase => ln_SucAsesor);
            
              exit;
            end if;
          end if;
        end if;
      
        exit;
      else
        begin
          select s.sng001ase
            into lc_asesor
            from sng001 s
           where s.sng001inst = ln_instancia;
        exception
          when others then
            null;
        end;
      
        begin
          select f.ubsuc
            into ln_SucAse
            from fst046 f
           where f.pgcod = 1
             and f.ubuser = lc_asesor;
        exception
          when others then
            null;
        end;
      
        ln_diascanc := 0;
        ld_fchcanc  := null;
        ln_Instcanc := 0;
        ln_SucCanc  := 0;
        exit;
      
      end if;
    end loop;
  
  end sp_cr_Inicio;
  -------------------------------------------------

  procedure sp_cr_VerificaDPFCTS(ln_pgcod     in number,
                                 ln_modulo    in number,
                                 ln_sucursal  in number,
                                 ln_moneda    in number,
                                 ln_papel     in number,
                                 ln_cuenta    in number,
                                 ln_operac    in number,
                                 ln_suboper   in number,
                                 ln_tipoper   in number,
                                 lc_VerifExcp out Varchar2) is
  
    FlgIncl      varchar2(2);
    ln_modul117  number;
    ln_cta117    number;
    ln_oper117   number;
    ln_sboper117 number;
    ln_sucur117  number;
    ln_mda117    number;
    ln_tipoer117 number;
  
  begin
  
    begin
    
      if ln_modulo = 116 then
      
        begin
        
          select f.r2mod,
                 f.r2cta,
                 f.r2oper,
                 f.r2sbop,
                 f.r2suc,
                 f.r2mda,
                 f.r2tope
            into ln_modul117,
                 ln_cta117,
                 ln_oper117,
                 ln_sboper117,
                 ln_sucur117,
                 ln_mda117,
                 ln_tipoer117
            from fsr011 f
           where f.r1cod = ln_pgcod
             and f.r1mod = ln_modulo
             and f.r1suc = ln_sucursal
             and f.r1mda = ln_moneda
             and f.r1pap = ln_papel
             and f.r1cta = ln_cuenta
             and f.r1oper = ln_operac
             and f.r1sbop = ln_suboper
             and f.r1tope = ln_tipoper
             and f.relcod = 46;
        
        end;
      
        begin
          Select 'N'
            into FlgIncl
            from fsr011 a, fsr011 b
           where a.relcod = 50
             and a.r1cod = ln_pgcod
             and a.r1mod = ln_modul117
             and a.r1suc = ln_sucur117
             and a.r1mda = ln_mda117
             and a.r1pap = 0
             and a.r1cta = ln_cta117
             and a.r1oper = ln_oper117
             and a.r1sbop = ln_sboper117
             and a.r1tope = ln_tipoer117
             and b.r2cta = a.r2cta
             and b.r2oper = a.r2oper
             and b.r2sbop = a.r2sbop
             and b.relcod in (2, 25)
             and a.r011co = 'S'
             and b.r011co = 'S'
             and rownum = 1;
        exception
          when no_data_found then
            -- ln_rcta := 0;
            FlgIncl := 'S';
          
        end;
      
      else
        if ln_modulo <> 116 then
        
          begin
            --créditos con garantía de plazo fijo o cts
          
            Select 'N'
              into FlgIncl
              from fsr011 a, fsr011 b
             where a.relcod = 50
               and a.r1cod = ln_pgcod
               and a.r1mod = ln_modulo
               and a.r1suc = ln_sucursal
               and a.r1mda = ln_moneda
               and a.r1pap = ln_papel
               and a.r1cta = ln_cuenta
               and a.r1oper = ln_operac
               and a.r1sbop = ln_suboper
               and a.r1tope = ln_tipoper
               and b.r2cta = a.r2cta
               and b.r2oper = a.r2oper
               and b.r2sbop = a.r2sbop
               and b.relcod in (2, 25)
               and a.r011co = 'S'
               and b.r011co = 'S'
               and rownum = 1;
          exception
            when no_data_found then
              -- ln_rcta := 0;
              FlgIncl := 'S';
          end;
        End If;
      
      end if;
    
    end;
  
    if FlgIncl = 'N' then
      lc_VerifExcp := 'S';
    
    else
      lc_VerifExcp := 'N';
    end if;
  
  end sp_cr_VerificaDPFCTS;

  --------------------------------------------------
  procedure sp_Cr_LogAQPA391(ln_391inst   in number,
                             ld_391fec    in date,
                             ln_391ican   in number,
                             lc_391acan   in varchar2,
                             ld_391fcan   in date,
                             ln_391dcan   in number,
                             ln_391sucan  in number,
                             ln_391casec  in number,
                             lc_391dpfca  in varchar2,
                             lc_391INHASE in varchar2,
                             lc_391asesor in varchar2,
                             ln_391sucase in number) is
  
    lc_hora char(8);
  
  begin
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    begin
      insert into aqpa391
        (aqpa391inst,
         aqpa391fec,
         aqpa391hora,
         aqpa391ican,
         aqpa391acan,
         aqpa391fcan,
         aqpa391dcan,
         aqpa391sucan,
         aqpa391casec,
         aqpa391dpfca,
         AQPA391INHASE,
         aqpa391asesor,
         aqpa391sucase)
      values
        (ln_391inst,
         ld_391fec,
         lc_hora,
         ln_391ican,
         lc_391acan,
         ld_391fcan,
         ln_391dcan,
         ln_391sucan,
         ln_391casec,
         lc_391dpfca,
         lc_391INHASE,
         lc_391asesor,
         ln_391sucase);
    exception
      when others then
        null;
    end;
  
    commit;
  
  end sp_Cr_LogAQPA391;
end PQ_CR_ALINEAMIENTO_ANALISTA;
/

