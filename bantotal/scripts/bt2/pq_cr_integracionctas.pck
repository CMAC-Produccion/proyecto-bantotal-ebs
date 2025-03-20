create or replace package PQ_CR_INTEGRACIONCTAS is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_HIPOTECARIO_VEHICULAR
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 31/05/2019
  -- Autor de Creación          : Cinthya Liz Hernandez Ortega
  -- Uso                        : Busqueda de Cuentas Relacionadas
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- *****************************************************************
  Procedure sp_cr_consultaCuentas(pn_cod    in number,
                                  pn_cuenta in number,
                                  pd_fecha  in date,
                                  pn_insta  in number,
                                  pn_eva    in number,
                                  pn_ejec   in number);
  Procedure sp_cr_contarIntentos(pn_pgcod   in number,
                                 pn_process in number,
                                 pv_usuario in varchar2,
                                 pd_feclim  in date,
                                 pd_fecape  in date,
                                 pn_insta   in number,
                                 pn_eva     in number,
                                 pn_ejec    in number,
                                 pn_pais    in number,
                                 pn_tdoc    in number,
                                 pv_ndoc    in varchar2,
                                 pn_Tcbio   in number,
                                 pn_caneje  out number);
end PQ_CR_INTEGRACIONCTAS;
/

create or replace package body PQ_CR_INTEGRACIONCTAS is

  Procedure sp_cr_consultaCuentas(pn_cod    in number,
                                  pn_cuenta in number,
                                  pd_fecha  in date,
                                  pn_insta  in number,
                                  pn_eva    in number,
                                  pn_ejec   in number) is
    cursor cr_integrantes(ln_cod number, ln_cuenta number) is
      select aa.pepais, aa.petdoc, aa.pendoc
        from fsr008 aa
       where aa.pgcod = ln_cod
         and aa.ctnro = ln_cuenta
      union
      select bb.rppais, bb.rptdoc, bb.rpndoc
        from fsr008 aa, fsr002 bb
       where aa.pgcod = ln_cod
         and aa.ctnro = ln_cuenta
         and aa.pepais = bb.pepais
         and aa.petdoc = bb.petdoc
         and aa.pendoc = bb.pendoc
         and bb.rpccyg = 66
      union
      select bb.pepais, bb.petdoc, bb.pendoc
        from fsr008 aa, fsr002 bb
       where aa.pgcod = ln_cod
         and aa.ctnro = ln_cuenta
         and bb.rppais = aa.pepais
         and bb.rptdoc = aa.petdoc
         and bb.rpndoc = aa.pendoc
         and bb.rpccyg = 66;
    cursor cr_integrantesInt(ln_cod number, ln_cuenta number) is
      select aa.pepais, aa.petdoc, aa.pendoc
        from fsr008 aa
       where aa.pgcod = ln_cod
         and aa.ctnro = ln_cuenta
      union
      select bb.rppais, bb.rptdoc, bb.rpndoc
        from fsr008 aa, fsr002 bb
       where aa.pgcod = ln_cod
         and aa.ctnro = ln_cuenta
         and aa.pepais = bb.pepais
         and aa.petdoc = bb.petdoc
         and aa.pendoc = bb.pendoc
         and bb.rpccyg = 66
      union
      select bb.pepais, bb.petdoc, bb.pendoc
        from fsr008 aa, fsr002 bb
       where aa.pgcod = ln_cod
         and aa.ctnro = ln_cuenta
         and bb.rppais = aa.pepais
         and bb.rptdoc = aa.petdoc
         and bb.rpndoc = aa.pendoc
         and bb.rpccyg = 66;
    cursor cr_cuentas(ln_pais number, ln_tdoc number, ln_ndoc char) is
      select *
        from fsr008
       where pepais = ln_pais
         and petdoc = ln_tdoc
         and pendoc = ln_ndoc;
    cursor cr_priCtas is
      select AQPA023CPGCOD, AQPA023CCUENT
        from AQPA023C
       where AQPA023CFECH = pd_fecha
         and AQPA023CEVA = pn_eva
         and AQPA023CEJEC = pn_ejec;
  
    ln_existe number;
    ln_flag   number;
  begin
    delete from AQPA023C
     where AQPA023CFECH = pd_fecha
       and AQPA023CEVA = pn_eva
       and AQPA023CEJEC = pn_ejec;
    commit;
    for i in cr_integrantes(pn_cod, pn_cuenta) loop
      for j in cr_cuentas(i.pepais, i.petdoc, i.pendoc) loop
        if pn_cuenta <> j.ctnro then
          ln_flag := 1;
          for k in cr_integrantesInt(j.pgcod, j.ctnro) loop
            select count(*)
              into ln_existe
              from (select aa.pepais, aa.petdoc, aa.pendoc
                      from fsr008 aa
                     where aa.pgcod = pn_cod
                       and aa.ctnro = pn_cuenta
                    union
                    select bb.rppais, bb.rptdoc, bb.rpndoc
                      from fsr008 aa, fsr002 bb
                     where aa.pgcod = pn_cod
                       and aa.ctnro = pn_cuenta
                       and aa.pepais = bb.pepais
                       and aa.petdoc = bb.petdoc
                       and aa.pendoc = bb.pendoc
                       and bb.rpccyg = 66
                    union
                    select bb.pepais, bb.petdoc, bb.pendoc
                      from fsr008 aa, fsr002 bb
                     where aa.pgcod = pn_cod
                       and aa.ctnro = pn_cuenta
                       and bb.rppais = aa.pepais
                       and bb.rptdoc = aa.petdoc
                       and bb.rpndoc = aa.pendoc
                       and bb.rpccyg = 66) dd
             where dd.pepais = k.pepais
               and dd.petdoc = k.petdoc
               and dd.pendoc = k.pendoc;
          
            if ln_existe = 0 then
              ln_flag := 0;
            end If;
          end loop;
          if ln_flag = 1 then
            begin
              insert into AQPA023C
                (AQPA023CFECH,
                 AQPA023CEVA,
                 AQPA023CEJEC,
                 AQPA023CINSTA,
                 AQPA023CPGCOD,
                 AQPA023CCUENT)
              values
                (pd_fecha, pn_eva, pn_ejec, pn_insta, j.pgcod, j.ctnro);
              commit;
            exception
              when others then
                null; --no insertamos repetidos
            end;
          end if;
        else
          --la cuenta de la instancia siempre se inserta.
          begin
            insert into AQPA023C
              (AQPA023CFECH,
               AQPA023CEVA,
               AQPA023CEJEC,
               AQPA023CINSTA,
               AQPA023CPGCOD,
               AQPA023CCUENT)
            values
              (pd_fecha, pn_eva, pn_ejec, pn_insta, j.pgcod, j.ctnro);
            commit;
          exception
            when others then
              null; --no insertamos repetidos
          end;
        end if;
      end loop;
    end loop;
  
    for l in cr_priCtas loop
      ln_flag := 1;
      for m in cr_integrantes(pn_cod, pn_cuenta) loop
      
        select count(*)
          into ln_existe
          from (select aa.pepais, aa.petdoc, aa.pendoc
                  from fsr008 aa
                 where aa.pgcod = l.aqpa023cpgcod
                   and aa.ctnro = l.aqpa023ccuent
                union
                select bb.rppais, bb.rptdoc, bb.rpndoc
                  from fsr008 aa, fsr002 bb
                 where aa.pgcod = l.aqpa023cpgcod
                   and aa.ctnro = l.aqpa023ccuent
                   and aa.pepais = bb.pepais
                   and aa.petdoc = bb.petdoc
                   and aa.pendoc = bb.pendoc
                   and bb.rpccyg = 66
                union
                select bb.pepais, bb.petdoc, bb.pendoc
                  from fsr008 aa, fsr002 bb
                 where aa.pgcod = l.aqpa023cpgcod
                   and aa.ctnro = l.aqpa023ccuent
                   and bb.rppais = aa.pepais
                   and bb.rptdoc = aa.petdoc
                   and bb.rpndoc = aa.pendoc
                   and bb.rpccyg = 66) dd
         where dd.pepais = m.pepais
           and dd.petdoc = m.petdoc
           and dd.pendoc = m.pendoc;
      
        if ln_existe = 0 then
          ln_flag := 0;
        end If;
      end loop;
      if ln_flag = 0 then
        delete from AQPA023C
         where aqpa023cfech = pd_fecha
           and AQPA023CEVA = pn_eva
           and AQPA023CEJEC = pn_ejec
           and aqpa023cpgcod = l.aqpa023cpgcod
           and aqpa023ccuent = l.aqpa023ccuent;
        commit;
      end if;
    end loop;
  
    delete aqpa023i
     where aqpa023ifech = pd_fecha
       and aqpa023ieva = pn_eva
       and aqpa023iejec = pn_ejec;
    commit;
  
    insert into aqpa023i
      (aqpa023ifech,
       aqpa023ieva,
       aqpa023iejec,
       aqpa023icorre,
       aqpa023iinst,
       aqpa023iinst2)
      select pd_fecha, pn_eva, pn_ejec, rownum, sng001inst, pn_insta
        from sng001
       where (sng001emp, sng001cta) in
             (select aqpa023cpgcod, aqpa023ccuent
                from aqpa023c
               where AQPA023CFECH = pd_fecha
                 and AQPA023CEVA = pn_eva
                 and AQPA023CEJEC = pn_ejec);
    commit;
  end sp_cr_consultaCuentas;

  Procedure sp_cr_contarIntentos(pn_pgcod   in number,
                                 pn_process in number,
                                 pv_usuario in varchar2,
                                 pd_feclim  in date,
                                 pd_fecape  in date,
                                 pn_insta   in number,
                                 pn_eva     in number,
                                 pn_ejec    in number,
                                 pn_pais    in number,
                                 pn_tdoc    in number,
                                 pv_ndoc    in varchar2,
                                 pn_Tcbio   in number,
                                 pn_caneje  out number) is
  
    cursor ejecuciones(cn_tmod number, cc_usuario character) is
      select PAE51EVA, PAE70NRO, SNG001CTA, SNG001EMP, PAE70Ins
        from FPAE70 pp, sng021 ff, SNG001 ss
       where PAE70Pgcod = pn_pgcod
         and PAE70Pro = pn_process
         and PAE70Usr = cc_usuario
         and PAE70Time >= pd_feclim
         and PAE51Eva = pn_eva
         and PAE70Ins in (select AQPA023Iinst
                            from AQPA023I
                           where AQPA023ifech = pd_fecape
                             and AQPA023IEVA = pn_eva
                             and AQPA023IEJEC = pn_ejec)
         and ff.sng021sol = PAE70Ins
         and ff.sng021pdoc = PAE70Pdoc
         and ff.sng021tdoc = PAE70Tdoc
         and ff.sng021ndoc = PAE70Ndoc
         and ff.sng021tmod = cn_tmod
         and ss.sng001inst = pp.pae70ins
       order by PAE70NRO;
  
    cursor valores(cn_eva number, cn_nro number) is
      select pae71ite, PAE71val
        from FPAE71
       where PAE51Eva = cn_eva
         and PAE70Nro = cn_nro
         and PAE71Ite In (188, 197, 230);
  
    cursor valoresini(cn_eval number) is
      select SNG026cod, SNG023Mto
        from sng023
       where sng021eval = cn_eval
         and SNG026cod IN (27, 40, 70, 527, 540, 570);
  
    ln_totpat    number(18, 2);
    ln_resnet    number(18, 2);
    ln_excmen    number(18, 2);
    ln_totpatmin number(18, 2);
    ln_resnetmin number(18, 2);
    ln_excmenmin number(18, 2);
    ln_totpatant number(18, 2);
    ln_resnetant number(18, 2);
    ln_excmenant number(18, 2);
    ln_flag      number(5);
    ln_flagPat   number(5);
    ln_flagRes   number(5);
    ln_flagExc   number(5);
    ln_tmod      number(5);
    ln_evalult   number(10);
    ln_caneje    number(5);
    lc_usuario   character(10);
    lc_ndoc      character(12);
    ln_contador  number(5);
    ln_flagExis  number(5);
  begin
  
    ln_totpatmin := 0;
    ln_resnetmin := 0;
    ln_excmenmin := 0;
    ln_totpatant := 0;
    ln_resnetant := 0;
    ln_excmenant := 0;
    ln_flag      := 0;
    ln_caneje    := 0;
    ln_contador  := 0;
    lc_usuario   := pv_usuario;
    lc_ndoc      := pv_ndoc;
  
    --Obtenemos tipo modelo
    begin
      select SNG021TMOD, SNG021EVAL
        into ln_tmod, ln_evalult
        from sng021
       where sng021sol = pn_insta
         and sng021eval = (select max(sng021eval)
                             from sng021
                            where sng021sol = pn_insta
                              and sng021pdoc = pn_pais
                              and sng021tdoc = pn_tdoc
                              and sng021ndoc = lc_ndoc)
         and sng021pdoc = pn_pais
         and sng021tdoc = pn_tdoc
         and sng021ndoc = lc_ndoc;
    exception
      when others then
        null; 
    end;
    --recorremos ejecuciones
    for i in ejecuciones(ln_tmod, lc_usuario) loop
    
      ln_totpat   := 0;
      ln_resnet   := 0;
      ln_excmen   := 0;
      ln_flagExis := 0;
      --obtenemos valores por ejecución
      If pn_eva = i.pae51eva and pn_ejec = i.pae70nro then
        --si es ejecución actual
        for d in valoresini(ln_evalult) loop
          if d.SNG026cod = 27 then
            ln_excmen := ln_excmen + d.sng023mto;
          end if;
          if d.SNG026cod = 40 then
            ln_resnet := ln_resnet + d.sng023mto;
          end if;
          if d.SNG026cod = 70 then
            ln_totpat := ln_totpat + d.sng023mto;
          end if;
          if d.SNG026cod = 527 then
            ln_excmen := ln_excmen + (d.sng023mto * pn_Tcbio);
          end if;
          if d.SNG026cod = 540 then
            ln_resnet := ln_resnet + (d.sng023mto * pn_Tcbio);
          end if;
          if d.SNG026cod = 570 then
            ln_totpat := ln_totpat + (d.sng023mto * pn_Tcbio);
          end if;
        end loop;
        ln_flagExis := 1;
      Else
        ln_flagPat := 0;
        ln_flagRes := 0;
        ln_flagExc := 0;
      
        for j in valores(i.pae51eva, i.pae70nro) loop
          if j.pae71ite = 188 then
            ln_totpat  := to_number(replace(trim(j.pae71val), '.', '.'),
                                    '999999999999999999.99');
            ln_flagPat := 1;
          end if;
          if j.pae71ite = 197 then
            ln_resnet  := to_number(replace(trim(j.pae71val), '.', '.'),
                                    '999999999999999999.99');
            ln_flagRes := 1;
          end if;
          if j.pae71ite = 230 then
            ln_excmen  := to_number(replace(trim(j.pae71val), '.', '.'),
                                    '999999999999999999.99');
            ln_flagExc := 1;
          end if;
          ln_flagExis := 1;
        end loop;
      
      End If;
      if ln_flagExis = 1 then
        --comparamos con el mínimo
        If ln_flag = 0 then
          if ln_flagPat = 1 or ln_flagRes = 1 or ln_flagExc = 1 then
            if ln_totpat = 0 and ln_resnet = 0 and ln_excmen = 0 then
              null;
            else
              ln_totpatmin := ln_totpat;
              ln_resnetmin := ln_resnet;
              ln_excmenmin := ln_excmen;
              ln_flag      := 1;
            end if;
          end if;
        Else
        
          If ln_tmod = 13 then
            If ln_totpat <> ln_totpatant then
              If (ln_totpat > ln_totpatmin) then
                ln_caneje := ln_caneje + 1;
              End If;
            end if;
          
            if ln_resnet <> ln_resnetant then
              If (ln_resnet > ln_resnetmin) then
                ln_caneje := ln_caneje + 1;
              End If;
            end if;
          
            If ln_totpat < ln_totpatmin then
              ln_totpatmin := ln_totpat;
            End If;
          
            If ln_resnet < ln_resnetmin then
              ln_resnetmin := ln_resnet;
            End If;
          
          End If;
        
          If ln_tmod = 14 then
            if ln_excmen <> ln_excmenant then
              If (ln_excmen > ln_excmenmin) then
                ln_caneje := ln_caneje + 1;
              End If;
            end if;
          
            If ln_excmen < ln_excmenmin then
              ln_excmenmin := ln_excmen;
            End If;
          
          End If;
        
        End If;
      
        ln_contador := ln_contador + 1;
      
        insert into AQPA023L
          (aqpa023lfech,
           aqpa023leva,
           aqpa023lejec,
           aqpa023lcorre,
           aqpa023linst,
           aqpa023linst2,
           aqpa023lejec2,
           aqpa023lcta,
           aqpa023lresn,
           aqpa023lpatr,
           aqpa023lexcm,
           aqpa023lcont,
           aqpa023lflag)
        values
          (pd_fecape,
           pn_eva,
           pn_ejec,
           ln_contador,
           pn_insta,
           i.PAE70Ins,
           i.pae70nro,
           i.SNG001CTA,
           ln_resnet,
           ln_totpat,
           ln_excmen,
           ln_caneje,
           '');
        commit;
        ln_totpatant := ln_totpat;
        ln_resnetant := ln_resnet;
        ln_excmenant := ln_excmen;
      end if;
    end loop;
    pn_caneje := ln_caneje;
  
  end sp_cr_contarIntentos;

end PQ_CR_INTEGRACIONCTAS;
/

