create or replace package PQ_CR_SEMILLA is

  -- *****************************************************************
  -- Nombre                     : CONTROLES PARA LINEA DE CREDITO SEMILLA
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     : CREDITOS
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2017.03.07
  -- Autor de Creaci¿n          : MSOLARI 
  -- Uso                        : Desarrollo e implementación de controles 
  --                              para el producto Línea de Crédito Semilla 
  --                              para Asociación de Comerciantes.
  -- Estado                     : Activo
  -- Acceso                     : Publico
  -- Fecha de Modificaci¿n      : -
  -- Autor de la Modificaci¿n   : -
  -- Descripci¿n de Modificaci¿n: -
  -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_Mto_Activo(pn_inst in number, pn_mto out number);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_Val_Analista(pn_inst in number, pv_vald out varchar2);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_Verif_Listado(pn_inst  in number,
                                pv_verif out varchar2,
                                pn_mnto  out number);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_Cant_Cred(pn_inst in number, pv_cant out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

end PQ_CR_SEMILLA;
/

create or replace package body PQ_CR_SEMILLA is

  -- *****************************************************************
  -- Nombre                     : CONTROLES PARA LINEA DE CREDITO SEMILLA
  -- Sistema                    : BANTOTAL
  -- Modulo                     : CREDITOS
  -- Version                    : 1.0
  -- Fecha de Creacion          : 2017.03.07
  -- Autor de Creacion          : MSOLARI 
  -- Uso                        : Desarrollo e implementación de controles 
  --                              para el producto Línea de Crédito Semilla 
  --                              para Asociación de Comerciantes.
  -- Estado                     : Activo
  -- Acceso                     : Publico
  -- Fecha de Modificacion      : -
  -- Autor de la Modificacion   : -
  -- Descripcion de Modificacion: -
  -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_Mto_Activo(pn_inst in number, pn_mto out number) is
  
    ln_evalc number(10);
    ln_mda   number(4);
    ln_tcbi  number(14, 8);
    ln_mto   number(17, 2);
    ln_Fmto  number(17, 2);
  
  Begin
    Begin
      select s.sng021eval
        into ln_evalc
        from sng021 s
       where s.sng021sol = pn_inst;
    exception
      --when no_data_found then null;--mod@abr 20180810
      --mod@abr 20180810            
      when too_many_rows then
        Begin
          select max(s.sng021eval)
            into ln_evalc
            from sng021 s
           where s.sng021sol = pn_inst;
        exception
          when others then
            null;
        End;
      when others then
        null;
        --mod@abr 20180810
    End;
  
    Begin
      select g.sng120mda, g.sng120tcbi
        into ln_mda, ln_tcbi
        from sng120 g
       where g.sng120ins = pn_inst
         and g.sng120tsk = 'EVALUACION';
    exception
      when no_data_found then
        null;
    End;
  
    If ln_mda = 101 then
      Begin
        select n.sng023mto
          into ln_mto
          from sng023 n
         where n.sng021eval = ln_evalc
           and n.sng026cod = 547;
      exception
        when no_data_found then
          null;
      End;
    
      ln_Fmto := ln_mto * ln_tcbi;
    End If;
  
    If ln_mda = 0 then
      Begin
        select n.sng023mto
          into ln_mto
          from sng023 n
         where n.sng021eval = ln_evalc
           and n.sng026cod = 47;
      exception
        when no_data_found then
          null;
      End;
      ln_Fmto := ln_mto;
    End If;
  
    pn_mto := ln_Fmto;
  
  End sp_cr_Mto_Activo;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_Val_Analista(pn_inst in number, pv_vald out varchar2) is
  
    lc_ase   char(10);
    lc_doc01 char(12);
  
  Begin
    Begin
      select g.sng001ase, g.sng001ndoc
        into lc_ase, lc_doc01
        from sng001 g
       where g.sng001inst = pn_inst;
    exception
      when no_data_found then
        null;
    End;
  
    Begin
      select 'S'
        into pv_vald
        from jaqy787 j
       where j.jaqy787anals = lc_ase
         and j.jaqy787ndoc = lc_doc01;
    exception
      when no_data_found then
        pv_vald := 'N';
    End;
  
  End sp_cr_Val_Analista;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_Verif_Listado(pn_inst  in number,
                                pv_verif out varchar2,
                                pn_mnto  out number) is
  
    ln_ndoc char(12);
  
  Begin
    Begin
      select g.sng001ndoc
        into ln_ndoc
        from sng001 g
       where g.sng001inst = pn_inst;
    exception
      when no_data_found then
        null;
    End;
  
    Begin
      select 'S', j.jaqy787mto
        into pv_verif, pn_mnto
        from jaqy787 j
       where j.jaqy787ndoc = ln_ndoc;
    exception
      when no_data_found then
        pv_verif := 'N';
    End;
  
  End sp_cr_Verif_Listado;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_Cant_Cred(pn_inst in number, pv_cant out varchar2) is
  
    ln_cod number := 0;
  
    --mod@abr 20190605
    cursor creditos(cd_fecSis in date) is
      select *
        from fsd010 ff
       where ff.pgcod = ln_cod
         and ff.aocta in (SELECT NVL(B1.CTNRO, B1.CTNRO)
                            from SNG001 A, FSR008 B1
                           WHERE A.SNG001PAIS = B1.PEPAIS
                             AND A.SNG001TDOC = B1.PETDOC
                             AND A.SNG001NDOC = B1.PENDOC
                             AND A.SNG001INST = pn_inst)
         and ff.aomod in (SELECT MODULO FROm FST111 WHERE DSCOD = 50)
         and ff.aomod not in (select tpimp
                                from fst098
                               where tpcod = 7665
                                 and pgcod = 7)
         and ff.aostat <> 99
         and ff.aofvto >= cd_fecSis;
  
    ld_fecSis     date;
    lc_flgVincLin char(1);
    ln_cont       number(5) := 0;
    ln_emp        number(3); --mod@abr 20191105
    ln_mod        number(3); --mod@abr 20191105
    ln_suc        number(3); --mod@abr 20191105
    ln_mda        number(4); --mod@abr 20191105
    ln_pap        number(4); --mod@abr 20191105
    ln_cta        number(9); --mod@abr 20191105
    ln_ope        number(9); --mod@abr 20191105
    ln_sbo        number(3); --mod@abr 20191105
    ln_top        number(3); --mod@abr 20191105
  
    --mod@abr 20190605   
  
  Begin
    ln_cod := 1;
  
    --mod@abr 20190605 
    begin
      select a.pgfape into ld_fecSis from fst017 a where a.pgcod = 1;
    exception
      when others then
        null;
    end;
    --mod@abr 20190605 
  
    for i in creditos(ld_fecSis) loop
      lc_flgVincLin := 'N';
    
      --mod@abr 20191105
      if i.aomod = 116 then
        begin
          select a.r2cod,
                 a.r2mod,
                 a.r2suc,
                 a.r2mda,
                 a.r2pap,
                 a.r2cta,
                 a.r2oper,
                 a.r2sbop,
                 a.r2tope
            into ln_emp,
                 ln_mod,
                 ln_suc,
                 ln_mda,
                 ln_pap,
                 ln_cta,
                 ln_ope,
                 ln_sbo,
                 ln_top
            from fsr011 a
           where a.r1cod = i.pgcod
             and a.r1mod = i.aomod
             and a.r1suc = i.aosuc
             and a.r1mda = i.aomda
             and a.r1pap = i.aopap
             and a.r1cta = i.aocta
             and a.r1oper = i.aooper
             and a.r1sbop = i.aosbop
             and a.r1tope = i.aotope
             and a.relcod = 46;
        
        exception
          when others then
            null;
        end;
      else
        ln_emp := i.pgcod;
        ln_mod := i.aomod;
        ln_suc := i.aosuc;
        ln_mda := i.aomda;
        ln_pap := i.aopap;
        ln_cta := i.aocta;
        ln_ope := i.aooper;
        ln_sbo := i.aosbop;
        ln_top := i.aotope;
      
      end if;
      --mod@abr 20191105
    
      pq_cr_resolutor_cappago.sp_cr_VerVincLinea(ln_mod10  => ln_mod, --i.aomod, --mod@abr 20191105
                                                 ln_suc10  => ln_suc, --i.aosuc, --mod@abr 20191105
                                                 ln_mda10  => ln_mda, --i.aomda, --mod@abr 20191105
                                                 ln_pap10  => ln_pap, --i.aopap, --mod@abr 20191105
                                                 ln_cta10  => ln_cta, --i.aocta, --mod@abr 20191105
                                                 ln_oper10 => ln_ope, --i.aooper,--mod@abr 20191105
                                                 ln_sbop10 => ln_sbo, --i.aosbop,--mod@abr 20191105
                                                 ln_tope10 => ln_top, --i.aotope,--mod@abr 20191105
                                                 lc_FlgLn  => lc_flgVincLin);
    
      if lc_flgVincLin = 'N' then
        ln_cont := ln_cont + 1;
      end if;
    
    end loop;
  
    if ln_cont > 0 then
      pv_cant := 'S';
    else
      pv_cant := 'N';
    end if;
  
    /*Begin
      select 'S'
        into pv_cant
        from fsd010 ff
       where ff.pgcod = ln_cod
         and ff.aocta in (SELECT NVL(B1.CTNRO, B1.CTNRO)
                            from SNG001 A, FSR008 B1
                           WHERE A.SNG001PAIS = B1.PEPAIS
                             AND A.SNG001TDOC = B1.PETDOC
                             AND A.SNG001NDOC = B1.PENDOC
                             AND A.SNG001INST = pn_inst)
         and ff.aomod in (SELECT MODULO FROm FST111 WHERE DSCOD = 50)
         and ff.aomod not in (select tpimp
                                from fst098
                               where tpcod = 7665
                                 and pgcod = 7)
         and ff.aostat <> 99
         
         and rownum = 1;
    exception
      when no_data_found then
        pv_cant := 'N';
    end;*/ --MOD@ABR20190605
  
  End sp_cr_Cant_Cred;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

End PQ_CR_SEMILLA;
/

