create or replace package PQ_CR_SALDO_HONRADO is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_SALDO_HONRADO
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2024.01.16 
  -- Autor de Creación          : DCASTRO
  -- Uso                        : RETORNA SALDOS HONRADOS
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_saldos_Tit(pn_pais   in number,
                            pn_tipdoc in number,
                            pc_numdoc in char,
                            pc_codusu in varchar2,
                            pc_origen in varchar2, 
                            pc_nomprg in varchar2,  
                            pn_numins in number,                          
                            pc_flag out char);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_saldos_Cyg(pn_pais   in number,
                                pn_tipdoc in number,
                                pc_numdoc in char,
                                pc_codusu in varchar2,
                                pc_origen in varchar2, 
                                pc_nomprg in varchar2,  
                                pn_numins in varchar2,                                                                
                                pc_flag out char);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_saldos(pn_pais   in number,
                            pn_tipdoc in number,
                            pc_numdoc in varchar2,
                            pc_codusu in varchar2,
                            pc_origen in varchar2,  
                            pc_nomprg in varchar2,
                            pn_numins in number,                                                           
                            pc_flag out char);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_saldosH( pn_instancia   in number,
                            pc_codusu in varchar2,
                            pc_origen in varchar2, 
                            pc_nomprg in varchar2,                           
                            pc_flag out varchar2) ;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                             
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_saldos_TitCRU(pn_pais   in number,
                            pn_tipdoc in number,
                            pc_numdoc in char,
                            pc_codusu in varchar2,
                            pc_origen in varchar2, 
                            pc_nomprg in varchar2,  
                            pn_numins in number,  
                            pc_indtit in char, 
                            pc_flag out char);
                            
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_saldos_CygCRU(pn_pais   in number,
                                pn_tipdoc in number,
                                pc_numdoc in char,
                                pc_codusu in varchar2,
                                pc_origen in varchar2, 
                                pc_nomprg in varchar2,  
                                pn_numins in varchar2, 
                                pc_indtit in char,                                                                                                
                                pc_flag out char);
                                                            
end PQ_CR_SALDO_HONRADO;
/

create or replace package body PQ_CR_SALDO_HONRADO is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_SALDO_HONRADO
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2024.01.16 
  -- Autor de Creación          : DCASTRO
  -- Uso                        : RETORNA SALDOS HONRADOS
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_saldos_Tit(pn_pais   in number,
                            pn_tipdoc in number,
                            pc_numdoc in char,
                            pc_codusu in varchar2,
                            pc_origen in varchar2, 
                            pc_nomprg in varchar2,  
                            pn_numins in number,                          
                            pc_flag out char) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_saldos_Tit
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : saldos honrados titular
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
    ld_fecrcc   date;

    ld_fecsis   date;

    ln_TipoDni  number(2);
    ln_TipoRuc  number(2);
    ln_TipoCex  number(2);
    lc_C_TDOCID char(1);

    lc_docide   varchar(12);
    lc_codsbs   varchar(12);
  
    ln_TipCedIdent number;
    ln_contador number := 0;
    lc_entidad varchar2(50);
    lc_nomprg  varchar2(10);
    valor      number;    
    
    cursor saldos(vc_codsbs in char, vd_fecrcc in date) is
      select /*+ ALL_ROWS*/  C_CODEMP, C_DESEFI, 
         max(SALCAP0) SALCAP0,
         max(SALCAP1) SALCAP1,
         max(SALCAP2) SALCAP2,
         max(SALCAP3) SALCAP3,
         max(SALCAP4) SALCAP4,
         max(SALCAP5) SALCAP5            
         from (
         select /*+ ALL_ROWS*/ DISTINCT A.D_FECPRE , A.C_CODEMP,T.C_DESEFI ,          
          CASE WHEN A.D_FECPRE =  add_months(vd_fecrcc, -5) THEN SUM(A.N_SALCAP) END SALCAP0, 
          CASE WHEN A.D_FECPRE =  add_months(vd_fecrcc, -4) THEN SUM(A.N_SALCAP) END SALCAP1, 
          CASE WHEN A.D_FECPRE =  add_months(vd_fecrcc, -3) THEN SUM(A.N_SALCAP) END SALCAP2, 
          CASE WHEN A.D_FECPRE =  add_months(vd_fecrcc, -2) THEN SUM(A.N_SALCAP) END SALCAP3, 
          CASE WHEN A.D_FECPRE =  add_months(vd_fecrcc, -1) THEN SUM(A.N_SALCAP) END SALCAP4, 
          CASE WHEN A.D_FECPRE =  add_months(vd_fecrcc, -0) THEN SUM(A.N_SALCAP) END SALCAP5,                       
          SUM(A.N_SALCAP) SALCAP         
           -- into ln_saldo1
            from CLDRCCS a, ahtbanc t
           Where C_CODSBS = vc_codsbs
             and D_FECPRE BETWEEN add_months(vd_fecrcc, -5) AND add_months(vd_fecrcc, 0)
             and (
                  C_CUENTA like ('14_1%')
               or C_CUENTA like ('14_4%') 
               or C_CUENTA like ('14_5%')
               or C_CUENTA like ('14_6%')
               or C_CUENTA like ('81_3%')             
             )
             and ( t.C_DESEFI like '%REACTIVA%' or t.C_DESEFI like '%CRECER%' or t.C_DESEFI like '%FONDOS%')
             AND T.C_CODEFI = A.C_CODEMP
             GROUP BY A.D_FECPRE ,A.C_CODEMP,T.C_DESEFI
             ORDER BY 1 )
             GROUP BY  C_CODEMP, C_DESEFI ;
          

  begin
  
    ln_TipoDni     := 21;
    ln_TipoRuc     := 9;
    ln_TipoCex     := 2;
    ln_TipCedIdent := 10;-- MPOSTIGOC 29.06.2021

  
    begin
      select  f.pgfape
        into ld_fecsis
      from fst017 f where f.pgcod = 1;
     exception when others then
        ld_fecsis := null;   
    end;
  
    begin
      select to_date(Tpnro, 'dd.mm.yyyy')
        into ld_fecrcc
        from Fst098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    exception when others then
        ld_fecrcc := null;   
    end;
    --ld_fecrcc := '31/12/2022';
  
    if pn_tipdoc = ln_TipoDni or pn_tipdoc <> ln_TipoRuc then
      If pn_tipdoc = ln_TipoDni then
        lc_C_TDOCID := '1';
      End If;
      If pn_tipdoc = ln_tipocex or pn_tipdoc = ln_TipCedIdent then
        lc_C_TDOCID := '2';
      End If;
      If pn_tipdoc <> ln_tipodni And pn_tipdoc <> ln_tiporuc and lc_C_TDOCID is null then
        --lc_C_TDOCID := to_char(pn_tipdoc);
        ---2023.08.21 dcastro se modifico
        if pn_tipdoc > 10 then
             begin
               select f.tp1nro2
                 into lc_C_TDOCID
                 from fst198 f
                where f.tp1cod = 1
                  and Tp1cod1 = 11111
                  and tp1corr1 = 1
                  and tp1corr2 = 5
                  and tp1nro1 = pn_tipdoc; -- guia de equivalencia de tipo de doc con la rcc
             exception
               when others then
                 lc_C_TDOCID := null;
             end;
        else
             lc_C_TDOCID := to_char(pn_tipdoc);
        end if;
        --2023.08.21 dcastro se modifico
        
      End If;
    
      lc_docide := trim(pc_numdoc);
    
      If pn_tipdoc = ln_tiporuc then
      
        begin
          select a.C_CODSBS
            into lc_codsbs
            from CLDRCCI a
           Where C_DOCTRI = lc_docide
             and D_FECPRE = ld_fecrcc
             and rownum = 1;
        exception
          when no_data_found then
            lc_codsbs := null;
        end;
      Else
      
        begin
          select a.C_CODSBS
            into lc_codsbs
            from CLDRCCI a
           Where C_TDOCID = lc_C_TDOCID
             and C_DOCIDE = lc_docide
             and D_FECPRE = ld_fecrcc
             and rownum = 1;
        exception
          when no_data_found then
            lc_codsbs := null;
        end;
      
      End If;
  
  
        
      if lc_codsbs is not null then
        --eliminando
        begin
          delete from aqpb281 a where a.aqpb281usur = rpad(pc_codusu, 10, ' ') and a.aqpb281ins  = pn_numins and a.aqpb281ori1 = pc_origen;
          commit;
        exception when others then
            null;
        end;
        --   
      
        for i in saldos(lc_codsbs, ld_fecrcc) loop
 
           valor := to_number(i.C_CODEMP);
           begin
              select Tp1desc
                into lc_entidad
                from fst198
               where Tp1cod = 1
                 and Tp1cod1 = 10849
                 and Tp1corr1 = 10
                 and Tp1nro1 = valor;
            Exception
              When no_data_found then
                 lc_entidad := 'No descripción';
            End;
        
        
        
        lc_nomprg := nvl(pc_nomprg, 'HONRADO');
        
          begin
            insert into aqpb281 
            (AQPB281USUR, AQPB281CODSBS, AQPB281FPROC, AQPB281FCR, AQPB281HCR, AQPB281CODEMP, AQPB281DESEMP, AQPB281CRETIP, AQPB281TIDESC, AQPB281CTAC, AQPB281DESC, AQPB281SALDO0, AQPB281SALDO1, AQPB281SALDO2, AQPB281SALDO3, AQPB281SALDO4, AQPB281SALDO5, AQPB281SALDO6, AQPB281PRCBA, AQPB281PRDIS1, AQPB281PRDIS2, AQPB281PRDIS3, AQPB281PRDIS4, AQPB281PRDIS5, AQPB281PRDIS6, AQPB281PAGU6, AQPB281ORI1, AQPB281ORI2, AQPB281ORI3, AQPB281INS, AQPB281AUX1)
            values 
            (pc_codusu, lc_codsbs, ld_fecrcc, ld_fecsis, to_char(sysdate, 'HH24:MM:SS'), i.C_CODEMP, i.C_DESEFI, null, null, null, null, nvl(i.SALCAP0,0),nvl(i.SALCAP1,0), nvl(i.SALCAP2,0), nvl(i.SALCAP3,0), nvl(i.SALCAP4,0), nvl(i.SALCAP5,0), null, null, null, null, null, null, null, null, null, pc_origen, pc_nomprg, null, pn_numins, lc_entidad);
            commit;
           
          exception when others then
             null;         
          end;
  
          
          if  nvl(i.SALCAP5,0) > 0 then
             ln_contador := ln_contador + 1;
          end if; 
        end loop;
   
        if ln_contador > 0 then
           pc_flag := 'S';
        else
           pc_flag := 'N';  
        end if;
  
      end if;
    
    end if;
  
    if pc_flag is null then
        pc_flag := 'N'; 
    end if;
    
  end sp_cr_saldos_Tit;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_saldos_Cyg(pn_pais   in number,
                                pn_tipdoc in number,
                                pc_numdoc in char,
                                pc_codusu in varchar2,
                                pc_origen in varchar2, 
                                pc_nomprg in varchar2,  
                                pn_numins in varchar2,                                                                
                                pc_flag out char) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_saldos_Cyg
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : saldos honrados conyuge
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************

 
    lc_docide varchar(12);
    ln_pais   number(3);
    ln_tipdoc number(2);
    lc_numdoc varchar(12);

 
  begin
  
    lc_docide := rpad(pc_numdoc, 12, ' ');
  
    begin
      select b.rppais, b.rptdoc, b.rpndoc
        into ln_pais, ln_tipdoc, lc_numdoc
        from fsr002 b
       where b.pepais = pn_pais
         and b.petdoc = pn_tipdoc
         and b.pendoc = lc_docide
         and b.rpccyg = 66;
    
    exception
      when others then
        begin
         select b.pepais, b.petdoc, b.pendoc
          into ln_pais, ln_tipdoc, lc_numdoc
          from fsr002 b
         where b.rppais = pn_pais
           and b.rptdoc = pn_tipdoc
           and b.rpndoc = lc_docide
           and b.rpccyg = 66;  
        exception when others then 
            lc_numdoc := null;
        end;    
    end;
  
    if lc_numdoc is not null then
    
    begin
      PQ_CR_SALDO_HONRADO.sp_cr_saldos_Tit(pn_pais => ln_pais,
                                           pn_tipdoc => ln_tipdoc,
                                           pc_numdoc => lc_numdoc,
                                           pc_codusu => pc_codusu,
                                           pc_origen => pc_origen,
                                           pc_nomprg => pc_nomprg,
                                           pn_numins => pn_numins, 
                                           pc_flag => pc_flag);
  
  
  
    end;
   
    end if;
    
    if pc_flag is null then
        pc_flag := 'N'; 
    end if;
  
  end sp_cr_saldos_Cyg;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_saldos( pn_pais   in number,
                          pn_tipdoc in number,
                          pc_numdoc in varchar2,
                          pc_codusu in varchar2,
                          pc_origen in varchar2, 
                          pc_nomprg in varchar2, 
                          pn_numins in number,                          
                          pc_flag out char) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_saldos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : TOTAL ENTIDADES RCC CONYUGE Y TITULAR
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************

    ln_pais   number(3);
    ln_tipdoc number(2);
    lc_numdoc varchar(12);
    lc_flagT  char(1);
    lc_flagC  char(1);
    lc_flag  char(1);    
  
  begin
  
    ln_pais   := pn_pais;
    ln_tipdoc := pn_tipdoc;
    lc_numdoc := pc_numdoc;
  

  
    begin
      PQ_CR_SALDO_HONRADO.sp_cr_saldos_TitCRU(pn_pais => ln_pais,
                                           pn_tipdoc => ln_tipdoc,
                                           pc_numdoc => lc_numdoc,
                                           pc_codusu => pc_codusu,
                                           pc_origen => pc_origen,
                                           pc_nomprg => pc_nomprg,
                                           pn_numins => pn_numins,    
                                           pc_indtit => 'T',                                                                                  
                                           pc_flag => lc_flagT);
    end;
 

  
    begin
      PQ_CR_SALDO_HONRADO.sp_cr_saldos_CygCRU(pn_pais => ln_pais,
                                           pn_tipdoc => ln_tipdoc,
                                           pc_numdoc => lc_numdoc,
                                           pc_codusu => pc_codusu,
                                           pc_origen => pc_origen,
                                           pc_nomprg => pc_nomprg,                                           
                                           pn_numins => pn_numins,
                                           pc_indtit => 'C',                                           
                                           pc_flag => lc_flagC);
    end;
    



    --tiene saldo honrado los 6 ultimos meses titular o conyuge  
    if lc_flagT = 'S' or lc_flagC = 'S' then
      lc_flag := 'S';
    else
      lc_flag := 'N'; 
    end if;
    pc_flag := lc_flag;
  
  end sp_cr_saldos;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_saldosH( pn_instancia   in number,
                            pc_codusu in varchar2,
                            pc_origen in varchar2, 
                            pc_nomprg in varchar2,                           
                            pc_flag out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_saldosH
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : TOTAL ENTIDADES RCC CONYUGE Y TITULAR
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************

     ln_pais   number(3);
    ln_tipdoc number(2);
    lc_numdoc varchar(12);
    lc_flagT  char(1);
    lc_flagC  char(1);
    lc_flag  char(1);    
  
  begin
    
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tipdoc, lc_numdoc
        from sng001 s
      where s.sng001inst =  pn_instancia; 
    exception when others then
       ln_pais := null;
       ln_tipdoc := null;
       lc_numdoc := null;
    end;


  
    begin
      PQ_CR_SALDO_HONRADO.sp_cr_saldos_Tit(pn_pais => ln_pais,
                                           pn_tipdoc => ln_tipdoc,
                                           pc_numdoc => lc_numdoc,
                                           pc_codusu => pc_codusu,
                                           pc_origen => pc_origen,
                                           pc_nomprg => pc_nomprg,
                                           pn_numins => pn_instancia,
                                           pc_flag => lc_flagT);
    end;
  
  
    begin
      PQ_CR_SALDO_HONRADO.sp_cr_saldos_Cyg(pn_pais => ln_pais,
                                           pn_tipdoc => ln_tipdoc,
                                           pc_numdoc => lc_numdoc,
                                           pc_codusu => pc_codusu,
                                           pc_origen => pc_origen,
                                           pc_nomprg => pc_nomprg,
                                           pn_numins => pn_instancia,                                           
                                           pc_flag => lc_flagC);
    end;
    
   --tiene saldo honrado los 6 ultimos meses titular o conyuge  
    if lc_flagT = 'S' or lc_flagC = 'S' then
      lc_flag := 'S';
    else
      lc_flag := 'N'; 
    end if;
    pc_flag := lc_flag;
  
  end sp_cr_saldosH;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_saldos_TitCRU(pn_pais   in number,
                            pn_tipdoc in number,
                            pc_numdoc in char,
                            pc_codusu in varchar2,
                            pc_origen in varchar2, 
                            pc_nomprg in varchar2,  
                            pn_numins in number,  
                            pc_indtit in char, 
                            pc_flag out char) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_saldos_TitCRU
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : saldos honrados titular
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
    ld_fecrcc   date;

    ld_fecsis   date;

    ln_TipoDni  number(2);
    ln_TipoRuc  number(2);
    ln_TipoCex  number(2);
    lc_C_TDOCID char(1);

    lc_docide   varchar(12);
    lc_codsbs   varchar(12);
    lc_titsbs   varchar(12);    

  
    ln_TipCedIdent number;
    ln_contador number := 0;
    lc_entidad varchar2(50);
    lc_nomprg  varchar2(10);
    
    ln_SALCAP0 number;
    ln_SALCAP1 number;
    ln_SALCAP2 number;
    ln_SALCAP3 number;
    ln_SALCAP4 number;
    ln_SALCAP5 number;   
    valor      number;                 
    
    cursor saldos(vc_codsbs in char, vd_fecrcc in date) is
      select /*+ ALL_ROWS*/  C_CODEMP, C_DESEFI, 
         max(SALCAP0) SALCAP0,
         max(SALCAP1) SALCAP1,
         max(SALCAP2) SALCAP2,
         max(SALCAP3) SALCAP3,
         max(SALCAP4) SALCAP4,
         max(SALCAP5) SALCAP5            
         from (
         select /*+ ALL_ROWS*/ DISTINCT A.D_FECPRE , A.C_CODEMP,T.C_DESEFI ,          
          CASE WHEN A.D_FECPRE =  add_months(vd_fecrcc, -5) THEN SUM(A.N_SALCAP) END SALCAP0, 
          CASE WHEN A.D_FECPRE =  add_months(vd_fecrcc, -4) THEN SUM(A.N_SALCAP) END SALCAP1, 
          CASE WHEN A.D_FECPRE =  add_months(vd_fecrcc, -3) THEN SUM(A.N_SALCAP) END SALCAP2, 
          CASE WHEN A.D_FECPRE =  add_months(vd_fecrcc, -2) THEN SUM(A.N_SALCAP) END SALCAP3, 
          CASE WHEN A.D_FECPRE =  add_months(vd_fecrcc, -1) THEN SUM(A.N_SALCAP) END SALCAP4, 
          CASE WHEN A.D_FECPRE =  add_months(vd_fecrcc, -0) THEN SUM(A.N_SALCAP) END SALCAP5,                       
          SUM(A.N_SALCAP) SALCAP         
           -- into ln_saldo1
            from CLDRCCS a, ahtbanc t
           Where C_CODSBS = vc_codsbs
             and D_FECPRE BETWEEN add_months(vd_fecrcc, -5) AND add_months(vd_fecrcc, 0)
             and (
                  C_CUENTA like ('14_1%')
               or C_CUENTA like ('14_4%') 
               or C_CUENTA like ('14_5%')
               or C_CUENTA like ('14_6%')
               or C_CUENTA like ('81_3%')             
             )
             and ( t.C_DESEFI like '%REACTIVA%' or t.C_DESEFI like '%CRECER%' or t.C_DESEFI like '%FONDOS%')
             AND T.C_CODEFI = A.C_CODEMP
             GROUP BY A.D_FECPRE ,A.C_CODEMP,T.C_DESEFI
             ORDER BY 1 )
             GROUP BY  C_CODEMP, C_DESEFI ;
          
     
  begin
  
    ln_TipoDni     := 21;
    ln_TipoRuc     := 9;
    ln_TipoCex     := 2;
    ln_TipCedIdent := 10;-- MPOSTIGOC 29.06.2021
    lc_titsbs      := null;
  
    begin
      select  f.pgfape
        into ld_fecsis
      from fst017 f where f.pgcod = 1;
    exception when others then
        ld_fecsis := null;    
    end;
  
    begin
      select to_date(Tpnro, 'dd.mm.yyyy')
        into ld_fecrcc
        from Fst098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    exception when others then
        ld_fecrcc := null;   
    end;
    --ld_fecrcc := '31/12/2022';
  
    if pn_tipdoc = ln_TipoDni or pn_tipdoc <> ln_TipoRuc then
      If pn_tipdoc = ln_TipoDni then
        lc_C_TDOCID := '1';
      End If;
      If pn_tipdoc = ln_tipocex or pn_tipdoc = ln_TipCedIdent then
        lc_C_TDOCID := '2';
      End If;
      If pn_tipdoc <> ln_tipodni And pn_tipdoc <> ln_tiporuc and lc_C_TDOCID is null then
        --lc_C_TDOCID := to_char(pn_tipdoc);
        ---2023.08.21 dcastro se modifico
        if pn_tipdoc > 10 then
             begin
               select f.tp1nro2
                 into lc_C_TDOCID
                 from fst198 f
                where f.tp1cod = 1
                  and Tp1cod1 = 11111
                  and tp1corr1 = 1
                  and tp1corr2 = 5
                  and tp1nro1 = pn_tipdoc; -- guia de equivalencia de tipo de doc con la rcc
             exception
               when others then
                 lc_C_TDOCID := null;
             end;
        else
             lc_C_TDOCID := to_char(pn_tipdoc);
        end if;
        --2023.08.21 dcastro se modifico
        
      End If;
    
      lc_docide := trim(pc_numdoc);
    
      If pn_tipdoc = ln_tiporuc then
      
        begin
          select a.C_CODSBS
            into lc_codsbs
            from CLDRCCI a
           Where C_DOCTRI = lc_docide
             and D_FECPRE BETWEEN add_months(ld_fecrcc, -5) AND add_months(ld_fecrcc, 0)
             and rownum = 1;
        exception
          when no_data_found then
            lc_codsbs := null;
        end;
      Else
      
        begin
          select a.C_CODSBS
            into lc_codsbs
            from CLDRCCI a
           Where C_TDOCID = lc_C_TDOCID
             and C_DOCIDE = lc_docide
             and D_FECPRE BETWEEN add_months(ld_fecrcc, -5) AND add_months(ld_fecrcc, 0)
             and rownum = 1;
        exception
          when no_data_found then
            lc_codsbs := null;
        end;
      
      End If;
  
  
        
      if lc_codsbs is not null then
        --eliminando
        if pc_indtit = 'T' then --si es titular copia el codigo sbs del titular
          begin
            delete from aqpb281 a where a.aqpb281usur = rpad(pc_codusu, 10, ' ') and a.aqpb281ori1 = pc_origen and a.aqpb281ori2 = pc_nomprg;
            commit;
          exception when others then
              null;
          end;
        end if;
          
        --   
        ln_SALCAP0 := 0;
        ln_SALCAP1 := 0;
        ln_SALCAP2 := 0;
        ln_SALCAP3 := 0;
        ln_SALCAP4 := 0;
        ln_SALCAP5 := 0;
        
        if pc_indtit = 'T' then --si es titular copia el codigo sbs del titular
          lc_titsbs := lc_codsbs;
        end if;
        
        for i in saldos(lc_codsbs, ld_fecrcc) loop
         
          valor := to_number(i.C_CODEMP);
           begin
              select Tp1desc
                into lc_entidad
                from fst198
               where Tp1cod = 1
                 and Tp1cod1 = 10849
                 and Tp1corr1 = 10
                 and Tp1nro1 = valor;
            Exception
              When no_data_found then
                 lc_entidad := 'No descripción';
            End;
          
          
          lc_nomprg := nvl(pc_nomprg, 'HONRADO');
          
            ---inserta datos titular
            begin
              insert into aqpb281 
              (AQPB281USUR, AQPB281CODSBS, AQPB281FPROC, AQPB281FCR, AQPB281HCR, AQPB281CODEMP, AQPB281DESEMP, AQPB281CRETIP, AQPB281TIDESC, AQPB281CTAC, AQPB281DESC, AQPB281SALDO0, AQPB281SALDO1, AQPB281SALDO2, AQPB281SALDO3, AQPB281SALDO4, AQPB281SALDO5, AQPB281SALDO6, AQPB281PRCBA, AQPB281PRDIS1, AQPB281PRDIS2, AQPB281PRDIS3, AQPB281PRDIS4, AQPB281PRDIS5, AQPB281PRDIS6, AQPB281PAGU6, AQPB281ORI1, AQPB281ORI2, AQPB281ORI3, AQPB281INS, AQPB281AUX1, AQPB281AUX2, AQPB281AUX3)
              values 
              (pc_codusu, lc_codsbs, ld_fecrcc, ld_fecsis, to_char(sysdate, 'HH24:MM:SS'), i.C_CODEMP, i.C_DESEFI, null, null, null, null, nvl(i.SALCAP0,0),nvl(i.SALCAP1,0), nvl(i.SALCAP2,0), nvl(i.SALCAP3,0), nvl(i.SALCAP4,0), nvl(i.SALCAP5,0), null, null, null, null, null, null, null, null, null, pc_origen, pc_nomprg, null, pn_numins, lc_entidad, lc_titsbs,'D');
              commit;
            exception when others then
               null;         
            end;
   
            ln_SALCAP0 := ln_SALCAP0 + nvl(i.SALCAP0,0);
            ln_SALCAP1 := ln_SALCAP1 + nvl(i.SALCAP1,0);
            ln_SALCAP2 := ln_SALCAP2 + nvl(i.SALCAP2,0);
            ln_SALCAP3 := ln_SALCAP3 + nvl(i.SALCAP3,0);
            ln_SALCAP4 := ln_SALCAP4 + nvl(i.SALCAP4,0);
            ln_SALCAP5 := ln_SALCAP5 + nvl(i.SALCAP5,0);
            
            if  nvl(i.SALCAP5,0) > 0 then
               ln_contador := ln_contador + 1;
            end if; 
            
          end loop;
           ---inserta TOTAL si saldo diferente 0
           if  ( ln_SALCAP0 + ln_SALCAP1+ln_SALCAP2+ln_SALCAP3+ln_SALCAP4+ln_SALCAP5 ) >0 then         
              begin
                insert into aqpb281 
                (AQPB281USUR, AQPB281CODSBS, AQPB281FPROC, AQPB281FCR, AQPB281HCR, AQPB281CODEMP, AQPB281DESEMP, AQPB281CRETIP, AQPB281TIDESC, AQPB281CTAC, AQPB281DESC, AQPB281SALDO0, AQPB281SALDO1, AQPB281SALDO2, AQPB281SALDO3, AQPB281SALDO4, AQPB281SALDO5, AQPB281SALDO6, AQPB281PRCBA, AQPB281PRDIS1, AQPB281PRDIS2, AQPB281PRDIS3, AQPB281PRDIS4, AQPB281PRDIS5, AQPB281PRDIS6, AQPB281PAGU6, AQPB281ORI1, AQPB281ORI2, AQPB281ORI3, AQPB281INS, AQPB281AUX1, AQPB281AUX2, AQPB281AUX3)
                values 
                (pc_codusu, lc_codsbs, ld_fecrcc, ld_fecsis, to_char(sysdate, 'HH24:MM:SS'), '00000', 'TOTAL', null, null, null, null, ln_SALCAP0, ln_SALCAP1, ln_SALCAP2, ln_SALCAP3, ln_SALCAP4, ln_SALCAP5, null, null, null, null, null, null, null, null, null, pc_origen, pc_nomprg, null, pn_numins, 'TOTAL', lc_titsbs,'T');
                commit;
              exception when others then
                 null;         
              end;
              
           end if;    
    
          if ln_contador > 0 then
             pc_flag := 'S';
          else
             pc_flag := 'N';  
          end if;
    
        end if;
    
    end if;
  
    if pc_flag is null then
        pc_flag := 'N'; 
    end if;
    
  end sp_cr_saldos_TitCRU;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_saldos_CygCRU(pn_pais   in number,
                                pn_tipdoc in number,
                                pc_numdoc in char,
                                pc_codusu in varchar2,
                                pc_origen in varchar2, 
                                pc_nomprg in varchar2,  
                                pn_numins in varchar2, 
                                pc_indtit in char,                                                                                                
                                pc_flag out char) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_saldos_CygCRU
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : saldos honrados conyuge
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************


    lc_docide varchar(12);
    ln_pais   number(3);
    ln_tipdoc number(2);
    lc_numdoc varchar(12);
  

    lc_flag   char(1);
  
  begin
  
    lc_docide := rpad(pc_numdoc, 12, ' ');
  
    begin
      select b.rppais, b.rptdoc, b.rpndoc
        into ln_pais, ln_tipdoc, lc_numdoc
        from fsr002 b
       where b.pepais = pn_pais
         and b.petdoc = pn_tipdoc
         and b.pendoc = lc_docide
         and b.rpccyg = 66;
    
    exception
      when others then
        begin
         select b.pepais, b.petdoc, b.pendoc
          into ln_pais, ln_tipdoc, lc_numdoc
          from fsr002 b
         where b.rppais = pn_pais
           and b.rptdoc = pn_tipdoc
           and b.rpndoc = lc_docide
           and b.rpccyg = 66;  
        exception when others then 
            lc_numdoc := null;
        end;    
    end;
  
    if lc_numdoc is not null then
    
      begin
        PQ_CR_SALDO_HONRADO.sp_cr_saldos_TitCRU(pn_pais => ln_pais,
                                             pn_tipdoc => ln_tipdoc,
                                             pc_numdoc => lc_numdoc,
                                             pc_codusu => pc_codusu,
                                             pc_origen => pc_origen,
                                             pc_nomprg => pc_nomprg,
                                             pn_numins => pn_numins, 
                                             pc_indtit => 'C',                                           
                                             pc_flag => pc_flag);
    
      end;
    
    else
      pc_flag := 'N'; 
    end if;
    
    if pc_flag is null then
        pc_flag := 'N'; 
    end if;
  
  end sp_cr_saldos_CygCRU;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

end PQ_CR_SALDO_HONRADO;
/

