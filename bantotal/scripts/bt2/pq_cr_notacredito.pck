create or replace package Pq_cr_NotaCredito is

  Procedure sp_cr_proceso(pd_fecini in date,
                          pd_fecfin in date,
                          pd_fecpro in date);
  Procedure sp_cr_proceso_1911(pd_fecpro in date);

end Pq_cr_NotaCredito;
/

create or replace package body Pq_cr_NotaCredito is

  Procedure sp_cr_proceso(pd_fecini in date,
                          pd_fecfin in date,
                          pd_fecpro in date) is
  
    cursor fsx015 is
      select distinct a.aqpa465pgcod pgcod,
                      a.aqpa465mod hcmod,
                      a.aqpa465sucor hsucor,
                      a.aqpa465tran htran,
                      a.aqpa465rel hnrel,
                      a.aqpa465con hfcon,
                      'E' Indicador,
                      a.aqpa465serie,
                      a.aqpa465corr
        from aqpa465 a
       where a.aqpa465est = 'A'
         and a.aqpa465con <> '19/11/2018'
         and a.aqpa465con between pd_fecini and pd_fecfin
      --and a.aqpa465corr = 2
      
      ;
  
    cursor base(pn_pgcod        in number,
                pn_hcmod3       in number,
                pn_hsucor3      in number,
                pn_htran3       in number,
                pn_hnrel3       in number,
                pn_hfcon3       in date,
                lc_serieI       in char,
                lc_correlativoI in number) is
    
      select aqpa463txtrub,
             aqpa463pgcod,
             aqpa463hcmod,
             aqpa463hsucor,
             aqpa463htran,
             aqpa463hnrel,
             aqpa463hfcon,
             aqpa463hcpcod,
             aqpa463hvnro,
             trim(aqpa463hvchr) aqpa463hvchr,
             aqpa463hvnro aqpa463emp,
             aqpa463mod,
             aqpa463suc,
             aqpa463mda,
             aqpa463pap,
             aqpa463cta,
             aqpa463ope,
             aqpa463sbo,
             aqpa463top,
             aqpa463hip,
             trim(aqpa463txtord) aqpa463txtord,
             aqpa463txoren
        from aqpa463 a
       where a.aqpa463pgcod = pn_pgcod
         and a.aqpa463hcmod = pn_hcmod3
         and a.aqpa463hsucor = pn_hsucor3
         and a.aqpa463htran = pn_htran3
         and a.aqpa463hnrel = pn_hnrel3
         and a.aqpa463hfcon = pn_hfcon3
         and a.aqpa463serie = lc_serieI
         and a.aqpa463corre = lc_correlativoI;
  
    cursor registros(cc_serie in char, cn_corre in number) is
    
      select *
        from aqpa460 a
       where a.aqpa460seri = cc_serie
         and a.aqpa460num = cn_corre
      --and trim(a.aqpa460desc) not in
      --    ('Nro de Cuenta 2',
      --     'Nro de Cuenta 3',
      --     'Nro de Cuenta 4',
      --     'Interes Compensatorio')
      ;
  
    cursor registros_1(cc_serie in char, cn_corre in number) is
    
      select *
        from aqpa460_2018 a
       where a.aqpa460seri = cc_serie
         and a.aqpa460num = cn_corre
      --and trim(a.aqpa460desc) not in
      --    ('Nro de Cuenta 2',
      --     'Nro de Cuenta 3',
      --     'Nro de Cuenta 4',
      --     'Interes Compensatorio')
      ;
  
    pn_hcmod  number;
    pn_hsucor number;
    pn_htran  number;
    pn_hnrel  number;
    pd_hfcon  date;
  
    pn_hcmod3      number;
    pn_hsucor3     number;
    pn_htran3      number;
    pn_hnrel3      number;
    pn_hfcon3      date;
    lc_serie       char(4);
    lc_correlativo char(8);
  
    pn_pgcod number;
  
    lc_flg466 char(1) := 'N'; --controla que no exista en la aqpa466
  
    ln_rubro  number;
    lc_tipper char(1);
  
    lv_tipodocu     char(1);
    lc_comision     char(1);
    ln_guiaCP       number;
    lv_codtipo      char(2);
    lc_coderr       varchar2(1000);
    lc_msgerr       varchar2(1000);
    ln_cont         number;
    lc_serieI       char(4);
    lc_correlativoI char(8);
  
    lv_tipocre varchar2(2);
  
    ln_item   number(5);
    ln_mtotot number(12, 2);
  
    result        char(100);
    lc_flgAcep    char(1);
    ln_mtoItem    number(12, 2);
    ln_mtoPEI     number(12, 2);
    ln_mtoACT     number(12, 2);
    ln_diferencia number(12, 2);
    ln_contIC     number(10);
    ln_contK      number(10);
    ln_contIC_1   number(10);
    ln_contK_1    number(10);
    ln_cont460    number(10);
    lc_existeIC   char(1) := 'N';
    lc_IC         char(1) := 'N';
  
  begin
  
    for p in fsx015 loop
      --Verifica que no exista en cabecera AQPA466
      Begin
        select 'S'
          into lc_flg466
          from aqpa466 a
         where a.aqpa466pgcod = p.pgcod
           and a.aqpa466mod = p.hcmod
           and a.aqpa466sucor = p.hsucor
           and a.aqpa466tran = p.htran
           and a.aqpa466rel = p.hnrel
           and a.aqpa466con = p.hfcon
           and rownum = 1;
      exception
        when others then
          lc_flg466 := 'N';
      end;
    
      --Verifica si el extorno fue aceptado
      Begin
        select 'R'
          into lc_flgAcep
          from aqpa466 a
         where a.aqpa466pgcod = p.pgcod
           and a.aqpa466mod = p.hcmod
           and a.aqpa466sucor = p.hsucor
           and a.aqpa466tran = p.htran
           and a.aqpa466rel = p.hnrel
           and a.aqpa466con = p.hfcon
           and a.aqpa466est <> 'A'
           and rownum = 1;
      exception
        when others then
          lc_flgAcep := 'N';
      end;
    
      pn_pgcod  := p.pgcod;
      pn_hcmod  := p.hcmod;
      pn_hsucor := p.hsucor;
      pn_htran  := p.htran;
      pn_hnrel  := p.hnrel;
      pd_hfcon  := p.hfcon;
    
      begin
        select count(*)
          into ln_cont460
          from aqpa460_2018 a
         where a.aqpa460seri = p.aqpa465serie
           and a.aqpa460num = p.aqpa465corr;
      exception
        when others then
          ln_cont460 := 0;
      end;
    
      begin
        select 'S'
          into lc_existeIC
          from aqpa460_2018 a
         where a.aqpa460seri = p.aqpa465serie
           and a.aqpa460num = p.aqpa465corr
           and a.aqpa460desc = 'Interes Compensatorio';
      exception
        when others then
          lc_existeIC := 'N';
      end;
    
      if ln_cont460 = 1 and lc_existeIC = 'S' then
        lc_IC := 'S';
      else
        lc_IC := 'N';
      end if;
    
      if lc_IC = 'N' then
        --revisar si solo hay dos IC
      
        if lc_flg466 = 'N' then
        
          pn_pgcod   := p.pgcod;
          pn_hcmod3  := p.hcmod;
          pn_hsucor3 := p.hsucor;
          pn_htran3  := p.htran;
          pn_hnrel3  := p.hnrel;
          pn_hfcon3  := p.hfcon;
        
          ---buscar transaccion en aqpa460 / aqpa463/ aqpa465
          lc_serieI       := p.aqpa465serie;
          lc_correlativoI := p.aqpa465corr;
        
          lv_tipodocu := substr(lc_serieI, 1, 1);
          lv_tipocre  := substr(lc_serieI, 2, 1);
        
          if lv_tipodocu is not null then
          
            --determinar tipo de cliente
            if lv_tipodocu = 'F' then
              lc_tipper := 'J';
              ln_guiaCP := 1;
            else
              lc_tipper := 'N';
              ln_guiaCP := 3;
            end if;
          
            begin
              select '0' || to_char(a.tp1nro1)
                into lv_codtipo
                from fst198 a
               where a.tp1cod = 1
                 and a.tp1cod1 = 11120
                 and a.tp1corr1 = 1
                 and a.tp1corr2 = 7
                 and a.tp1corr3 = ln_guiaCP; --2018.10.10 se modifico codigo de guia para tipo comprobante
            exception
              when others then
                null;
            end;
          
            ---determinar si es hipotecario
            if lv_tipocre = 'H' then
              ln_rubro := 4;
            else
              ln_rubro := 1;
            end if;
          
            --determinar si es comision
            begin
              select 'S'
                into lc_comision
                from fst198 h
               where h.tp1cod = 1
                 and h.tp1cod1 = 11120
                 and h.tp1corr1 = 3
                 and h.tp1corr2 = 1
                 and h.tp1nro1 = pn_hcmod3
                 and h.tp1nro2 = pn_htran3
                 and rownum = 1;
            exception
              when others then
                lc_comision := 'N';
            end;
          
            if lc_comision = 'S' then
              ln_rubro := 1;
            end if;
          
            begin
              pq_cr_facturacion.sp_cr_factura(pn_rubro       => ln_rubro,
                                              pc_tipcli      => lc_tipper,
                                              pc_tipo        => 'NC',
                                              pc_serie       => lc_serie,
                                              pc_correlativo => lc_correlativo);
            exception
              when others then
              
                lc_coderr := sqlcode;
                lc_msgerr := trim(sqlerrm);
              
                insert into aqpa460E
                  (aqpa460eserie,
                   aqpa460ecorr,
                   aqpa460epgcod,
                   aqpa460emod,
                   aqpa460esucorend,
                   aqpa460etran,
                   aqpa460erel,
                   aqpa460econ,
                   aqpa460etip,
                   Aqpa460eacoe,
                   Aqpa460eamsge)
                values
                  (null,
                   null,
                   pn_pgcod,
                   pn_hcmod,
                   pn_hsucor,
                   pn_htran,
                   pn_hnrel,
                   pd_hfcon,
                   'S',
                   lc_coderr,
                   lc_msgerr);
                commit;
              
            end;
          
            --insertamos en AQPA460            
            ln_item       := 0;
            ln_contIC     := 0;
            ln_contK      := 0;
            ln_mtotot     := 0;
            ln_mtoPEI     := 0;
            ln_mtoACT     := 0;
            ln_diferencia := 0;
            ln_mtoItem    := 0;
            ln_contIC_1   := 0;
            ln_contK_1    := 0;
          
            --calculo de diferencia de IC 
            begin
              select aa.aqpa460total
                into ln_mtoPEI
                from aqpa460_pei aa
               where aa.aqpa460seri = lc_serieI
                 and aa.aqpa460num = lc_correlativoI
                 and trim(aa.aqpa460desc) = 'Interes Compensatorio';
            exception
              when others then
                ln_mtoPEI := 0;
            end;
          
            begin
              select aa.aqpa460total
                into ln_mtoACT
                from aqpa460_2018 aa
               where aa.aqpa460seri = lc_serieI
                 and aa.aqpa460num = lc_correlativoI
                 and trim(aa.aqpa460desc) = 'Interes Compensatorio';
            exception
              when too_many_rows then
                begin
                  select aa.aqpa460total
                    into ln_mtoACT
                    from aqpa460_2018 aa
                   where aa.aqpa460seri = lc_serieI
                     and aa.aqpa460num = lc_correlativoI
                     and trim(aa.aqpa460desc) = 'Interes Compensatorio'
                     and rownum = 1;
                exception
                  when others then
                    ln_mtoACT := 0;
                end;
              
              when others then
                ln_mtoACT := 0;
            end;
            ln_diferencia := nvl(ln_mtoACT, 0) - nvl(ln_mtoPEI, 0);
            If ln_diferencia < 0 then
              ln_diferencia := ln_diferencia * -1;
            end if;
          
            for j in registros_1(lc_serieI, lc_correlativoI) loop
            
              if trim(j.aqpa460desc) = 'Interes Compensatorio' then
                ln_contIC_1 := ln_contIC_1 + 1;
              end if;
            
              if trim(j.aqpa460desc) = 'Capital' then
                ln_contK_1 := ln_contK_1 + 1;
              end if;
            
              if (ln_contIC_1 > 1 and
                 trim(j.aqpa460desc) = 'Interes Compensatorio') or
                 (trim(j.aqpa460desc) <> 'Interes Compensatorio') then
              
                ln_mtotot := ln_mtotot + j.aqpa460total;
              
              end if;
            
            end loop;
          
            ln_mtotot := ln_mtotot + ln_diferencia;
          
            begin
            
              result := pq_cr_factura_electronica.dintex(ln_mtotot);
            end;
          
            for a in registros(lc_serieI, lc_correlativoI) loop
            
              if trim(a.aqpa460desc) = 'Interes Compensatorio' then
                ln_contIC := ln_contIC + 1;
              end if;
            
              if trim(a.aqpa460desc) = 'Capital' then
                ln_contK := ln_contK + 1;
              end if;
            
              if (ln_contIC > 1 and
                 trim(a.aqpa460desc) = 'Interes Compensatorio') or
                 (trim(a.aqpa460desc) <> 'Interes Compensatorio') then
              
                ln_item := ln_item + 1;
              
                if trim(a.aqpa460desc) = 'Capital' and ln_contK = 1 then
                  ln_mtoItem := a.aqpa460total + ln_diferencia;
                else
                  ln_mtoItem := a.aqpa460total;
                end if;
              
                insert into AQPA460
                  (aqpa460tdoc,
                   aqpa460rucc,
                   aqpa460rsoc,
                   aqpa460cdis,
                   aqpa460ncom,
                   aqpa460calle,
                   aqpa460urba,
                   aqpa460depa,
                   aqpa460prov,
                   aqpa460dist,
                   aqpa460telf,
                   aqpa460web,
                   aqpa460cpais,
                   aqpa460cesun,
                   aqpa460seri,
                   aqpa460num,
                   aqpa460femi,
                   aqpa460tcomf,
                   aqpa460mone,
                   aqpa460corrr,
                   aqpa460mglo,
                   aqpa460coma,
                   aqpa460tpla,
                   aqpa460tope,
                   aqpa460tplco,
                   aqpa460clog,
                   aqpa460tdocr,
                   aqpa460nruc,
                   aqpa460rasoc,
                   aqpa460impt,
                   aqpa460hemi,
                   aqpa460simc,
                   aqpa460svitm,
                   aqpa460spvi,
                   aqpa460txml,
                   aqpa460sdref,
                   aqpa460ndref,
                   aqpa460cmem,
                   aqpa460sust,
                   aqpa460serie,
                   aqpa460nro,
                   aqpa460tcomp,
                   aqpa460fdref,
                   aqpa460cdist,
                   aqpa460call,
                   aqpa460urb,
                   aqpa460dep,
                   aqpa460prv,
                   aqpa460dst,
                   aqpa460cpai,
                   aqpa460item,
                   aqpa460pnetu,
                   aqpa460cantf,
                   aqpa460total,
                   aqpa460dete,
                   aqpa460ctpr,
                   aqpa460vvun,
                   aqpa460vvuig,
                   aqpa460desc,
                   aqpa460mfun,
                   aqpa460prvit,
                   aqpa460medem,
                   aqpa460csuna,
                   aqpa460cpgs1,
                   aqpa460ititm,
                   aqpa460imptb,
                   aqpa460impex,
                   aqpa460afigv,
                   aqpa460sisc,
                   aqpa460codtb,
                   aqpa460dstrb,
                   aqpa460codun,
                   aqpa460mbim,
                   aqpa460taimp,
                   aqpa460cdley,
                   aqpa460teley,
                   aqpa460text1,
                   aqpa460text2,
                   aqpa460trecv,
                   aqpa460templ,
                   aqpa460subje,
                   aqpa460vpcva,
                   aqpa460nexp,
                   aqpa460cind,
                   aqpa460npart,
                   aqpa460ncont,
                   aqpa460fotrc,
                   aqpa460cdisn,
                   aqpa460direh,
                   aqpa460urbh,
                   aqpa460prvh,
                   aqpa460dsth,
                   aqpa460depth,
                   aqpa460mtotal,
                   aqpa460baimp,
                   aqpa460mtimp,
                   aqpa460pcima,
                   aqpa460bsimp,
                   aqpa460vaimp,
                   aqpa460mtinf,
                   aqpa460mtgrt,
                   aqpa460bsimps,
                   aqpa460mtoti,
                   aqpa460pgc,
                   aqpa460mod,
                   aqpa460suc,
                   aqpa460trx,
                   aqpa460rel,
                   aqpa460ore,
                   aqpa460pgce,
                   aqpa460mode,
                   aqpa460suce,
                   aqpa460trxe,
                   aqpa460rele,
                   aqpa460fcone,
                   aqpa460glos,
                   aqpa460tipag,
                   aqpa460text3,
                   aqpa460text4,
                   aqpa460conce)
                values
                  (a.aqpa460tdoc,
                   a.aqpa460rucc,
                   a.aqpa460rsoc,
                   a.aqpa460cdis,
                   a.aqpa460ncom,
                   a.aqpa460calle,
                   a.aqpa460urba,
                   a.aqpa460depa,
                   a.aqpa460prov,
                   a.aqpa460dist,
                   a.aqpa460telf,
                   a.aqpa460web,
                   a.aqpa460cpais,
                   a.aqpa460cesun,
                   lc_serie,
                   lc_correlativo,
                   pd_fecpro, --a.aqpa460femi,
                   '07',
                   a.aqpa460mone,
                   a.aqpa460corrr,
                   a.aqpa460mglo,
                   a.aqpa460coma,
                   a.aqpa460tpla,
                   a.aqpa460tope,
                   a.aqpa460tplco,
                   a.aqpa460clog,
                   a.aqpa460tdocr,
                   a.aqpa460nruc,
                   a.aqpa460rasoc,
                   ln_mtotot,
                   a.aqpa460hemi,
                   a.aqpa460simc,
                   ln_mtotot, --a.aqpa460svitm,
                   ln_mtotot, --a.aqpa460spvi,
                   a.aqpa460txml,
                   a.aqpa460seri,
                   a.aqpa460num,
                   '01',
                   'Regularizacion de SUNAT',
                   a.aqpa460seri,
                   a.aqpa460num,
                   lv_codtipo,
                   pd_hfcon,
                   a.aqpa460cdist,
                   a.aqpa460call,
                   a.aqpa460urb,
                   a.aqpa460dep,
                   a.aqpa460prv,
                   a.aqpa460dst,
                   a.aqpa460cpai,
                   ln_item,
                   a.aqpa460pnetu,
                   a.aqpa460cantf,
                   ln_mtoItem, -- a.aqpa460total,
                   a.aqpa460dete,
                   a.aqpa460ctpr,
                   ln_mtoItem, --a.aqpa460vvun,
                   ln_mtoItem, --a.aqpa460vvuig,
                   a.aqpa460desc,
                   a.aqpa460mfun,
                   ln_mtoItem, --a.aqpa460prvit,
                   a.aqpa460medem,
                   a.aqpa460csuna,
                   a.aqpa460cpgs1,
                   a.aqpa460ititm,
                   a.aqpa460imptb,
                   a.aqpa460impex,
                   a.aqpa460afigv,
                   a.aqpa460sisc,
                   a.aqpa460codtb,
                   a.aqpa460dstrb,
                   a.aqpa460codun,
                   ln_mtoItem, --a.aqpa460mbim,
                   a.aqpa460taimp,
                   a.aqpa460cdley,
                   result,
                   a.aqpa460text1,
                   a.aqpa460text2,
                   a.aqpa460trecv,
                   a.aqpa460templ,
                   a.aqpa460subje,
                   a.aqpa460vpcva,
                   a.aqpa460nexp,
                   a.aqpa460cind,
                   a.aqpa460npart,
                   a.aqpa460ncont,
                   a.aqpa460fotrc,
                   a.aqpa460cdisn,
                   a.aqpa460direh,
                   a.aqpa460urbh,
                   a.aqpa460prvh,
                   a.aqpa460dsth,
                   a.aqpa460depth,
                   a.aqpa460mtotal,
                   a.aqpa460baimp,
                   a.aqpa460mtimp,
                   a.aqpa460pcima,
                   a.aqpa460bsimp,
                   a.aqpa460vaimp,
                   ln_mtotot,
                   a.aqpa460mtgrt,
                   a.aqpa460bsimps,
                   a.aqpa460mtoti,
                   a.aqpa460pgc,
                   a.aqpa460mod,
                   a.aqpa460suc,
                   a.aqpa460trx,
                   a.aqpa460rel,
                   a.aqpa460ore,
                   pn_pgcod,
                   pn_hcmod,
                   pn_hsucor,
                   pn_htran,
                   pn_hnrel,
                   pd_hfcon,
                   a.aqpa460glos,
                   a.aqpa460tipag,
                   a.aqpa460text3,
                   a.aqpa460text4,
                   a.aqpa460conce);
                commit;
              end if;
            end loop;
          
            --insertamos en AQPA464
            ln_cont := 1;
            for i in base(pn_pgcod,
                          pn_hcmod3,
                          pn_hsucor3,
                          pn_htran3,
                          pn_hnrel3,
                          pn_hfcon3,
                          lc_serieI,
                          lc_correlativoI) loop
            
              begin
                insert into aqpa464
                  (aqpa464txtrub,
                   aqpa464pgcod,
                   aqpa464hcmod,
                   aqpa464hsucor,
                   aqpa464htran,
                   aqpa464hnrel,
                   aqpa464hfcon,
                   aqpa464doid,
                   aqpa464cpcod,
                   aqpa464vnro,
                   aqpa464vchr,
                   aqpa464vfch,
                   aqpa464vimp /*, aqpa464vtas*/,
                   aqpa464serie,
                   aqpa464nro,
                   aqpa464emp,
                   aqpa464mod,
                   aqpa464suc,
                   aqpa464mda,
                   aqpa464pap,
                   aqpa464cta,
                   aqpa464ope,
                   aqpa464sbo,
                   aqpa464top,
                   aqpa464hip,
                   aqpa464txtord,
                   aqpa464txoren,
                   aqpa464pgcode,
                   aqpa464hcmode,
                   aqpa464hsucore,
                   aqpa464htrane,
                   aqpa464hnrele,
                   aqpa464hfcone)
                
                values
                  (i.aqpa463txtrub,
                   i.aqpa463pgcod,
                   i.aqpa463hcmod,
                   i.aqpa463hsucor,
                   i.aqpa463htran,
                   i.aqpa463hnrel,
                   i.aqpa463hfcon,
                   ln_cont,
                   i.aqpa463hcpcod,
                   i.aqpa463hvnro,
                   i.aqpa463hvchr,
                   pd_hfcon,
                   ln_cont,
                   lc_serie,
                   lc_correlativo,
                   i.aqpa463emp,
                   i.aqpa463mod,
                   i.aqpa463suc,
                   i.aqpa463mda,
                   i.aqpa463pap,
                   i.aqpa463cta,
                   i.aqpa463ope,
                   i.aqpa463sbo,
                   i.aqpa463top,
                   i.aqpa463hip,
                   i.aqpa463txtord,
                   i.aqpa463txoren,
                   pn_pgcod,
                   pn_hcmod,
                   pn_hsucor,
                   pn_htran,
                   pn_hnrel,
                   pd_hfcon);
              
                commit;
              exception
                when others then
                  lc_coderr := sqlcode;
                  lc_msgerr := sqlerrm;
                
              end;
              ln_cont := ln_cont + 1;
            
            end loop;
            --insertamos en AQPA466
            begin
            
              insert into aqpa466
                (aqpa466serie,
                 aqpa466corr,
                 aqpa466pgcod,
                 aqpa466mod,
                 aqpa466sucor,
                 aqpa466tran,
                 aqpa466rel,
                 aqpa466con)
                select lc_serie,
                       lc_correlativo,
                       aqpa465pgcod,
                       aqpa465mod,
                       aqpa465sucor,
                       aqpa465tran,
                       aqpa465rel,
                       aqpa465con
                  from aqpa465 a
                 where a.aqpa465pgcod = pn_pgcod
                   and a.aqpa465mod = pn_hcmod3
                   and a.aqpa465sucor = pn_hsucor3
                   and a.aqpa465tran = pn_htran3
                   and a.aqpa465rel = pn_hnrel3
                   and a.aqpa465con = pn_hfcon3
                   and a.aqpa465serie = lc_serieI
                   and a.aqpa465corr = lc_correlativoI;
              commit;
            exception
              when others then
                lc_coderr := sqlcode;
                lc_msgerr := sqlerrm;
            end;
          
          end if; ---fin de tipodocu 
        
        end if;
      
        -----Extorno rechazado
      
        if lc_flg466 = 'R' then
          pn_pgcod   := p.pgcod;
          pn_hcmod3  := p.hcmod;
          pn_hsucor3 := p.hsucor;
          pn_htran3  := p.htran;
          pn_hnrel3  := p.hnrel;
          pn_hfcon3  := p.hfcon;
        
          ---buscar transaccion en aqpa460 / aqpa463/ aqpa465
          lc_serieI       := p.aqpa465serie;
          lc_correlativoI := p.aqpa465corr;
        
          lv_tipodocu := substr(lc_serieI, 1, 1);
          lv_tipocre  := substr(lc_serieI, 2, 1);
        
          if lv_tipodocu is not null then
          
            --determinar tipo de cliente
            if lv_tipodocu = 'F' then
              lc_tipper := 'J';
              ln_guiaCP := 1;
            else
              lc_tipper := 'N';
              ln_guiaCP := 3;
            end if;
          
            begin
              select '0' || to_char(a.tp1nro1)
                into lv_codtipo
                from fst198 a
               where a.tp1cod = 1
                 and a.tp1cod1 = 11120
                 and a.tp1corr1 = 1
                 and a.tp1corr2 = 7
                 and a.tp1corr3 = ln_guiaCP; --2018.10.10 se modifico codigo de guia para tipo comprobante
            exception
              when others then
                null;
            end;
          
            ---determinar si es hipotecario
            if lv_tipocre = 'H' then
              ln_rubro := 4;
            else
              ln_rubro := 1;
            end if;
          
            --determinar si es comision
            begin
              select 'S'
                into lc_comision
                from fst198 h
               where h.tp1cod = 1
                 and h.tp1cod1 = 11120
                 and h.tp1corr1 = 3
                 and h.tp1corr2 = 1
                 and h.tp1nro1 = pn_hcmod3
                 and h.tp1nro2 = pn_htran3
                 and rownum = 1;
            exception
              when others then
                lc_comision := 'N';
            end;
          
            if lc_comision = 'S' then
              ln_rubro := 1;
            end if;
          
            begin
              pq_cr_facturacion.sp_cr_factura(pn_rubro       => ln_rubro,
                                              pc_tipcli      => lc_tipper,
                                              pc_tipo        => 'NC',
                                              pc_serie       => lc_serie,
                                              pc_correlativo => lc_correlativo);
            exception
              when others then
              
                lc_coderr := sqlcode;
                lc_msgerr := trim(sqlerrm);
              
                insert into aqpa460E
                  (aqpa460eserie,
                   aqpa460ecorr,
                   aqpa460epgcod,
                   aqpa460emod,
                   aqpa460esucorend,
                   aqpa460etran,
                   aqpa460erel,
                   aqpa460econ,
                   aqpa460etip,
                   Aqpa460eacoe,
                   Aqpa460eamsge)
                values
                  (null,
                   null,
                   pn_pgcod,
                   pn_hcmod,
                   pn_hsucor,
                   pn_htran,
                   pn_hnrel,
                   pd_hfcon,
                   'S',
                   lc_coderr,
                   lc_msgerr);
                commit;
              
            end;
          
            --insertamos en AQPA460            
            begin
              insert into AQPA460
                (aqpa460tdoc,
                 aqpa460rucc,
                 aqpa460rsoc,
                 aqpa460cdis,
                 aqpa460ncom,
                 aqpa460calle,
                 aqpa460urba,
                 aqpa460depa,
                 aqpa460prov,
                 aqpa460dist,
                 aqpa460telf,
                 aqpa460web,
                 aqpa460cpais,
                 aqpa460cesun,
                 aqpa460seri,
                 aqpa460num,
                 aqpa460femi,
                 aqpa460tcomf,
                 aqpa460mone,
                 aqpa460corrr,
                 aqpa460mglo,
                 aqpa460coma,
                 aqpa460tpla,
                 aqpa460tope,
                 aqpa460tplco,
                 aqpa460clog,
                 aqpa460tdocr,
                 aqpa460nruc,
                 aqpa460rasoc,
                 aqpa460impt,
                 aqpa460hemi,
                 aqpa460simc,
                 aqpa460svitm,
                 aqpa460spvi,
                 aqpa460txml,
                 aqpa460sdref,
                 aqpa460ndref,
                 aqpa460cmem,
                 aqpa460sust,
                 aqpa460serie,
                 aqpa460nro,
                 aqpa460tcomp,
                 aqpa460fdref,
                 aqpa460cdist,
                 aqpa460call,
                 aqpa460urb,
                 aqpa460dep,
                 aqpa460prv,
                 aqpa460dst,
                 aqpa460cpai,
                 aqpa460item,
                 aqpa460pnetu,
                 aqpa460cantf,
                 aqpa460total,
                 aqpa460dete,
                 aqpa460ctpr,
                 aqpa460vvun,
                 aqpa460vvuig,
                 aqpa460desc,
                 aqpa460mfun,
                 aqpa460prvit,
                 aqpa460medem,
                 aqpa460csuna,
                 aqpa460cpgs1,
                 aqpa460ititm,
                 aqpa460imptb,
                 aqpa460impex,
                 aqpa460afigv,
                 aqpa460sisc,
                 aqpa460codtb,
                 aqpa460dstrb,
                 aqpa460codun,
                 aqpa460mbim,
                 aqpa460taimp,
                 aqpa460cdley,
                 aqpa460teley,
                 aqpa460text1,
                 aqpa460text2,
                 aqpa460trecv,
                 aqpa460templ,
                 aqpa460subje,
                 aqpa460vpcva,
                 aqpa460nexp,
                 aqpa460cind,
                 aqpa460npart,
                 aqpa460ncont,
                 aqpa460fotrc,
                 aqpa460cdisn,
                 aqpa460direh,
                 aqpa460urbh,
                 aqpa460prvh,
                 aqpa460dsth,
                 aqpa460depth,
                 aqpa460mtotal,
                 aqpa460baimp,
                 aqpa460mtimp,
                 aqpa460pcima,
                 aqpa460bsimp,
                 aqpa460vaimp,
                 aqpa460mtinf,
                 aqpa460mtgrt,
                 aqpa460bsimps,
                 aqpa460mtoti,
                 aqpa460pgc,
                 aqpa460mod,
                 aqpa460suc,
                 aqpa460trx,
                 aqpa460rel,
                 aqpa460ore,
                 aqpa460pgce,
                 aqpa460mode,
                 aqpa460suce,
                 aqpa460trxe,
                 aqpa460rele,
                 aqpa460fcone,
                 aqpa460glos,
                 aqpa460tipag,
                 aqpa460text3,
                 aqpa460text4,
                 aqpa460conce)
                select aqpa460tdoc,
                       aqpa460rucc,
                       aqpa460rsoc,
                       aqpa460cdis,
                       aqpa460ncom,
                       aqpa460calle,
                       aqpa460urba,
                       aqpa460depa,
                       aqpa460prov,
                       aqpa460dist,
                       aqpa460telf,
                       aqpa460web,
                       aqpa460cpais,
                       aqpa460cesun,
                       lc_serie,
                       lc_correlativo,
                       pd_fecpro, --aqpa460femi,
                       '07',
                       aqpa460mone,
                       aqpa460corrr,
                       aqpa460mglo,
                       aqpa460coma,
                       aqpa460tpla,
                       aqpa460tope,
                       aqpa460tplco,
                       aqpa460clog,
                       aqpa460tdocr,
                       aqpa460nruc,
                       aqpa460rasoc,
                       aqpa460impt,
                       aqpa460hemi,
                       aqpa460simc,
                       aqpa460svitm,
                       aqpa460spvi,
                       aqpa460txml,
                       aqpa460seri,
                       aqpa460num,
                       '01',
                       'Regularizacion de SUNAT',
                       aqpa460seri,
                       aqpa460num,
                       lv_codtipo,
                       pd_hfcon,
                       aqpa460cdist,
                       aqpa460call,
                       aqpa460urb,
                       aqpa460dep,
                       aqpa460prv,
                       aqpa460dst,
                       aqpa460cpai,
                       aqpa460item,
                       aqpa460pnetu,
                       aqpa460cantf,
                       aqpa460total,
                       aqpa460dete,
                       aqpa460ctpr,
                       aqpa460vvun,
                       aqpa460vvuig,
                       aqpa460desc,
                       aqpa460mfun,
                       aqpa460prvit,
                       aqpa460medem,
                       aqpa460csuna,
                       aqpa460cpgs1,
                       aqpa460ititm,
                       aqpa460imptb,
                       aqpa460impex,
                       aqpa460afigv,
                       aqpa460sisc,
                       aqpa460codtb,
                       aqpa460dstrb,
                       aqpa460codun,
                       aqpa460mbim,
                       aqpa460taimp,
                       aqpa460cdley,
                       aqpa460teley,
                       aqpa460text1,
                       aqpa460text2,
                       aqpa460trecv,
                       aqpa460templ,
                       aqpa460subje,
                       aqpa460vpcva,
                       aqpa460nexp,
                       aqpa460cind,
                       aqpa460npart,
                       aqpa460ncont,
                       aqpa460fotrc,
                       aqpa460cdisn,
                       aqpa460direh,
                       aqpa460urbh,
                       aqpa460prvh,
                       aqpa460dsth,
                       aqpa460depth,
                       aqpa460mtotal,
                       aqpa460baimp,
                       aqpa460mtimp,
                       aqpa460pcima,
                       aqpa460bsimp,
                       aqpa460vaimp,
                       aqpa460mtinf,
                       aqpa460mtgrt,
                       aqpa460bsimps,
                       aqpa460mtoti,
                       aqpa460pgc,
                       aqpa460mod,
                       aqpa460suc,
                       aqpa460trx,
                       aqpa460rel,
                       aqpa460ore,
                       pn_pgcod,
                       pn_hcmod,
                       pn_hsucor,
                       pn_htran,
                       pn_hnrel,
                       pd_hfcon,
                       aqpa460glos,
                       aqpa460tipag,
                       aqpa460text3,
                       aqpa460text4,
                       aqpa460conce
                  from AQPA460 a
                 where a.aqpa460seri = lc_serieI
                   and a.aqpa460num = lc_correlativoI;
            
              commit;
            exception
              when others then
                lc_coderr := sqlcode;
                lc_msgerr := sqlerrm;
              
            end;
          
            --insertamos en AQPA464
            ln_cont := 1;
            for i in base(pn_pgcod,
                          pn_hcmod3,
                          pn_hsucor3,
                          pn_htran3,
                          pn_hnrel3,
                          pn_hfcon3,
                          lc_serieI,
                          lc_correlativoI) loop
            
              begin
                insert into aqpa464
                  (aqpa464txtrub,
                   aqpa464pgcod,
                   aqpa464hcmod,
                   aqpa464hsucor,
                   aqpa464htran,
                   aqpa464hnrel,
                   aqpa464hfcon,
                   aqpa464doid,
                   aqpa464cpcod,
                   aqpa464vnro,
                   aqpa464vchr,
                   aqpa464vfch,
                   aqpa464vimp /*, aqpa464vtas*/,
                   aqpa464serie,
                   aqpa464nro,
                   aqpa464emp,
                   aqpa464mod,
                   aqpa464suc,
                   aqpa464mda,
                   aqpa464pap,
                   aqpa464cta,
                   aqpa464ope,
                   aqpa464sbo,
                   aqpa464top,
                   aqpa464hip,
                   aqpa464txtord,
                   aqpa464txoren,
                   aqpa464pgcode,
                   aqpa464hcmode,
                   aqpa464hsucore,
                   aqpa464htrane,
                   aqpa464hnrele,
                   aqpa464hfcone)
                
                values
                  (i.aqpa463txtrub,
                   i.aqpa463pgcod,
                   i.aqpa463hcmod,
                   i.aqpa463hsucor,
                   i.aqpa463htran,
                   i.aqpa463hnrel,
                   i.aqpa463hfcon,
                   ln_cont,
                   i.aqpa463hcpcod,
                   i.aqpa463hvnro,
                   i.aqpa463hvchr,
                   pd_hfcon,
                   ln_cont,
                   lc_serie,
                   lc_correlativo,
                   i.aqpa463emp,
                   i.aqpa463mod,
                   i.aqpa463suc,
                   i.aqpa463mda,
                   i.aqpa463pap,
                   i.aqpa463cta,
                   i.aqpa463ope,
                   i.aqpa463sbo,
                   i.aqpa463top,
                   i.aqpa463hip,
                   i.aqpa463txtord,
                   i.aqpa463txoren,
                   pn_pgcod,
                   pn_hcmod,
                   pn_hsucor,
                   pn_htran,
                   pn_hnrel,
                   pd_hfcon);
              
                commit;
              exception
                when others then
                  lc_coderr := sqlcode;
                  lc_msgerr := sqlerrm;
                
              end;
              ln_cont := ln_cont + 1;
            
            end loop;
            --insertamos en AQPA466
            begin
            
              insert into aqpa466
                (aqpa466serie,
                 aqpa466corr,
                 aqpa466pgcod,
                 aqpa466mod,
                 aqpa466sucor,
                 aqpa466tran,
                 aqpa466rel,
                 aqpa466con)
                select lc_serie,
                       lc_correlativo,
                       aqpa465pgcod,
                       aqpa465mod,
                       aqpa465sucor,
                       aqpa465tran,
                       aqpa465rel,
                       aqpa465con
                  from aqpa465 a
                 where a.aqpa465pgcod = pn_pgcod
                   and a.aqpa465mod = pn_hcmod3
                   and a.aqpa465sucor = pn_hsucor3
                   and a.aqpa465tran = pn_htran3
                   and a.aqpa465rel = pn_hnrel3
                   and a.aqpa465con = pn_hfcon3
                   and a.aqpa465serie = lc_serieI
                   and a.aqpa465corr = lc_correlativoI;
              commit;
            exception
              when others then
                lc_coderr := sqlcode;
                lc_msgerr := sqlerrm;
            end;
          
          end if; ---fin de tipodocu 
        
        end if;
      end if;
    end loop;
  end sp_cr_proceso;

  Procedure sp_cr_proceso_1911(pd_fecpro in date) is
  
    cursor fsx015 is
      select distinct a.aqpa465pgcod pgcod,
                      a.aqpa465mod hcmod,
                      a.aqpa465sucor hsucor,
                      a.aqpa465tran htran,
                      a.aqpa465rel hnrel,
                      a.aqpa465con hfcon,
                      'E' Indicador,
                      a.aqpa465serie,
                      a.aqpa465corr
        from aqpa465 a
       where a.aqpa465est = 'A'
         and a.aqpa465con = '19/11/2018'
      --and a.aqpa465corr = 2
      
      ;
  
    cursor base(pn_pgcod        in number,
                pn_hcmod3       in number,
                pn_hsucor3      in number,
                pn_htran3       in number,
                pn_hnrel3       in number,
                pn_hfcon3       in date,
                lc_serieI       in char,
                lc_correlativoI in number) is
    
      select aqpa463txtrub,
             aqpa463pgcod,
             aqpa463hcmod,
             aqpa463hsucor,
             aqpa463htran,
             aqpa463hnrel,
             aqpa463hfcon,
             aqpa463hcpcod,
             aqpa463hvnro,
             trim(aqpa463hvchr) aqpa463hvchr,
             aqpa463hvnro aqpa463emp,
             aqpa463mod,
             aqpa463suc,
             aqpa463mda,
             aqpa463pap,
             aqpa463cta,
             aqpa463ope,
             aqpa463sbo,
             aqpa463top,
             aqpa463hip,
             trim(aqpa463txtord) aqpa463txtord,
             aqpa463txoren
        from aqpa463 a
       where a.aqpa463pgcod = pn_pgcod
         and a.aqpa463hcmod = pn_hcmod3
         and a.aqpa463hsucor = pn_hsucor3
         and a.aqpa463htran = pn_htran3
         and a.aqpa463hnrel = pn_hnrel3
         and a.aqpa463hfcon = pn_hfcon3
         and a.aqpa463serie = lc_serieI
         and a.aqpa463corre = lc_correlativoI;
  
    cursor registros(cc_serie in char, cn_corre in number) is
    
      select *
        from aqpa460_2018 a
       where a.aqpa460seri = cc_serie
         and a.aqpa460num = cn_corre
      --and trim(a.aqpa460desc) not in
      --    ('Nro de Cuenta 2',
      --     'Nro de Cuenta 3',
      --     'Nro de Cuenta 4',
      --     'Interes Compensatorio')
      ;
  
    cursor registros_1(cc_serie in char, cn_corre in number) is
    
      select *
        from aqpa460 a
       where a.aqpa460seri = cc_serie
         and a.aqpa460num = cn_corre
      --and trim(a.aqpa460desc) not in
      --    ('Nro de Cuenta 2',
      --     'Nro de Cuenta 3',
      --     'Nro de Cuenta 4',
      --     'Interes Compensatorio')
      ;
  
    pn_hcmod  number;
    pn_hsucor number;
    pn_htran  number;
    pn_hnrel  number;
    pd_hfcon  date;
  
    pn_hcmod3      number;
    pn_hsucor3     number;
    pn_htran3      number;
    pn_hnrel3      number;
    pn_hfcon3      date;
    lc_serie       char(4);
    lc_correlativo char(8);
  
    pn_pgcod number;
  
    lc_flg466 char(1) := 'N'; --controla que no exista en la aqpa466
  
    ln_rubro  number;
    lc_tipper char(1);
  
    lv_tipodocu     char(1);
    lc_comision     char(1);
    ln_guiaCP       number;
    lv_codtipo      char(2);
    lc_coderr       varchar2(1000);
    lc_msgerr       varchar2(1000);
    ln_cont         number;
    lc_serieI       char(4);
    lc_correlativoI char(8);
  
    lv_tipocre varchar2(2);
  
    ln_item   number(5);
    ln_mtotot number(12, 2);
  
    result        char(100);
    lc_flgAcep    char(1);
    ln_mtoItem    number(12, 2);
    ln_mtoPEI     number(12, 2);
    ln_mtoACT     number(12, 2);
    ln_diferencia number(12, 2);
    ln_contIC     number(10);
    ln_contK      number(10);
    ln_contIC_1   number(10);
    ln_contK_1    number(10);
  
    lc_flgHipo char(1) := 'N';
  
  begin
  
    for p in fsx015 loop
      lc_flgHipo := 'N';
      --Verifica que no exista en cabecera AQPA466
      Begin
        select 'S'
          into lc_flg466
          from aqpa466 a
         where a.aqpa466pgcod = p.pgcod
           and a.aqpa466mod = p.hcmod
           and a.aqpa466sucor = p.hsucor
           and a.aqpa466tran = p.htran
           and a.aqpa466rel = p.hnrel
           and a.aqpa466con = p.hfcon
           and rownum = 1;
      exception
        when others then
          lc_flg466 := 'N';
      end;
    
      --Verifica si el extorno fue aceptado
      Begin
        select 'R'
          into lc_flgAcep
          from aqpa466 a
         where a.aqpa466pgcod = p.pgcod
           and a.aqpa466mod = p.hcmod
           and a.aqpa466sucor = p.hsucor
           and a.aqpa466tran = p.htran
           and a.aqpa466rel = p.hnrel
           and a.aqpa466con = p.hfcon
           and a.aqpa466est <> 'A'
           and rownum = 1;
      exception
        when others then
          lc_flgAcep := 'N';
      end;
    
      --Verifica si es hipotecario
      begin
        select 'S'
          into lc_flgHipo
          from fsh016 g
         where g.pgcod = pn_pgcod
           and g.hcmod = pn_hcmod3
           and g.hsucor = pn_hsucor3
           and g.htran = pn_htran3
           and g.hnrel = pn_hnrel3
           and g.hfcon = pn_hfcon3
           and substr(g.hrubro, 5, 2) = '04'
           and rownum = 1;
      exception
        when others then
          lc_flgHipo := 'N';
      end;
    
      pn_pgcod  := p.pgcod;
      pn_hcmod  := p.hcmod;
      pn_hsucor := p.hsucor;
      pn_htran  := p.htran;
      pn_hnrel  := p.hnrel;
      pd_hfcon  := p.hfcon;
    
      if lc_flg466 = 'N' and lc_flgHipo = 'S' then
      
        pn_pgcod   := p.pgcod;
        pn_hcmod3  := p.hcmod;
        pn_hsucor3 := p.hsucor;
        pn_htran3  := p.htran;
        pn_hnrel3  := p.hnrel;
        pn_hfcon3  := p.hfcon;
      
        ---buscar transaccion en aqpa460 / aqpa463/ aqpa465
        lc_serieI       := p.aqpa465serie;
        lc_correlativoI := p.aqpa465corr;
      
        lv_tipodocu := substr(lc_serieI, 1, 1);
        lv_tipocre  := substr(lc_serieI, 2, 1);
      
        if lv_tipodocu is not null then
        
          --determinar tipo de cliente
          if lv_tipodocu = 'F' then
            lc_tipper := 'J';
            ln_guiaCP := 1;
          else
            lc_tipper := 'N';
            ln_guiaCP := 3;
          end if;
        
          begin
            select '0' || to_char(a.tp1nro1)
              into lv_codtipo
              from fst198 a
             where a.tp1cod = 1
               and a.tp1cod1 = 11120
               and a.tp1corr1 = 1
               and a.tp1corr2 = 7
               and a.tp1corr3 = ln_guiaCP; --2018.10.10 se modifico codigo de guia para tipo comprobante
          exception
            when others then
              null;
          end;
        
          ---determinar si es hipotecario
          if lv_tipocre = 'H' then
            ln_rubro := 4;
          else
            ln_rubro := 1;
          end if;
        
          --determinar si es comision
          begin
            select 'S'
              into lc_comision
              from fst198 h
             where h.tp1cod = 1
               and h.tp1cod1 = 11120
               and h.tp1corr1 = 3
               and h.tp1corr2 = 1
               and h.tp1nro1 = pn_hcmod3
               and h.tp1nro2 = pn_htran3
               and rownum = 1;
          exception
            when others then
              lc_comision := 'N';
          end;
        
          if lc_comision = 'S' then
            ln_rubro := 1;
          end if;
        
          begin
            pq_cr_facturacion.sp_cr_factura(pn_rubro       => ln_rubro,
                                            pc_tipcli      => lc_tipper,
                                            pc_tipo        => 'NC',
                                            pc_serie       => lc_serie,
                                            pc_correlativo => lc_correlativo);
          exception
            when others then
            
              lc_coderr := sqlcode;
              lc_msgerr := trim(sqlerrm);
            
              insert into aqpa460E
                (aqpa460eserie,
                 aqpa460ecorr,
                 aqpa460epgcod,
                 aqpa460emod,
                 aqpa460esucorend,
                 aqpa460etran,
                 aqpa460erel,
                 aqpa460econ,
                 aqpa460etip,
                 Aqpa460eacoe,
                 Aqpa460eamsge)
              values
                (null,
                 null,
                 pn_pgcod,
                 pn_hcmod,
                 pn_hsucor,
                 pn_htran,
                 pn_hnrel,
                 pd_hfcon,
                 'S',
                 lc_coderr,
                 lc_msgerr);
              commit;
            
          end;
        
          --insertamos en AQPA460            
          ln_item       := 0;
          ln_contIC     := 0;
          ln_contK      := 0;
          ln_mtotot     := 0;
          ln_mtoPEI     := 0;
          ln_mtoACT     := 0;
          ln_diferencia := 0;
          ln_mtoItem    := 0;
          ln_contIC_1   := 0;
          ln_contK_1    := 0;
        
          --calculo de diferencia de IC 
          begin
            select aa.aqpa460total
              into ln_mtoPEI
              from aqpa460_pei aa
             where aa.aqpa460seri = lc_serieI
               and aa.aqpa460num = lc_correlativoI
               and trim(aa.aqpa460desc) = 'Interes Compensatorio';
          exception
            when others then
              ln_mtoPEI := 0;
          end;
        
          begin
            select aa.aqpa460total
              into ln_mtoACT
              from aqpa460_2018 aa
             where aa.aqpa460seri = lc_serieI
               and aa.aqpa460num = lc_correlativoI
               and trim(aa.aqpa460desc) = 'Interes Compensatorio';
          exception
            when too_many_rows then
              begin
                select aa.aqpa460total
                  into ln_mtoACT
                  from aqpa460_2018 aa
                 where aa.aqpa460seri = lc_serieI
                   and aa.aqpa460num = lc_correlativoI
                   and trim(aa.aqpa460desc) = 'Interes Compensatorio'
                   and rownum = 1;
              exception
                when others then
                  ln_mtoACT := 0;
              end;
            
            when others then
              ln_mtoACT := 0;
          end;
          ln_diferencia := nvl(ln_mtoACT, 0) - nvl(ln_mtoPEI, 0);
          If ln_diferencia < 0 then
            ln_diferencia := ln_diferencia * -1;
          end if;
        
          for j in registros_1(lc_serieI, lc_correlativoI) loop
          
            if trim(j.aqpa460desc) = 'Interes Compensatorio' then
              ln_contIC_1 := ln_contIC_1 + 1;
            end if;
          
            if trim(j.aqpa460desc) = 'Capital' then
              ln_contK_1 := ln_contK_1 + 1;
            end if;
          
            if (ln_contIC_1 > 1 and
               trim(j.aqpa460desc) = 'Interes Compensatorio') or
               (trim(j.aqpa460desc) <> 'Interes Compensatorio') then
            
              ln_mtotot := ln_mtotot + j.aqpa460total;
            
            end if;
          
          end loop;
        
          ln_mtotot := ln_mtotot + ln_diferencia;
        
          begin
          
            result := pq_cr_factura_electronica.dintex(ln_mtotot);
          end;
        
          for a in registros(lc_serieI, lc_correlativoI) loop
          
            if trim(a.aqpa460desc) = 'Interes Compensatorio' then
              ln_contIC := ln_contIC + 1;
            end if;
          
            if trim(a.aqpa460desc) = 'Capital' then
              ln_contK := ln_contK + 1;
            end if;
          
            if (ln_contIC > 1 and
               trim(a.aqpa460desc) = 'Interes Compensatorio') or
               (trim(a.aqpa460desc) <> 'Interes Compensatorio') then
            
              ln_item := ln_item + 1;
            
              if trim(a.aqpa460desc) = 'Capital' and ln_contK = 1 then
                ln_mtoItem := a.aqpa460total + ln_diferencia;
              else
                ln_mtoItem := a.aqpa460total;
              end if;
            
              insert into AQPA460
                (aqpa460tdoc,
                 aqpa460rucc,
                 aqpa460rsoc,
                 aqpa460cdis,
                 aqpa460ncom,
                 aqpa460calle,
                 aqpa460urba,
                 aqpa460depa,
                 aqpa460prov,
                 aqpa460dist,
                 aqpa460telf,
                 aqpa460web,
                 aqpa460cpais,
                 aqpa460cesun,
                 aqpa460seri,
                 aqpa460num,
                 aqpa460femi,
                 aqpa460tcomf,
                 aqpa460mone,
                 aqpa460corrr,
                 aqpa460mglo,
                 aqpa460coma,
                 aqpa460tpla,
                 aqpa460tope,
                 aqpa460tplco,
                 aqpa460clog,
                 aqpa460tdocr,
                 aqpa460nruc,
                 aqpa460rasoc,
                 aqpa460impt,
                 aqpa460hemi,
                 aqpa460simc,
                 aqpa460svitm,
                 aqpa460spvi,
                 aqpa460txml,
                 aqpa460sdref,
                 aqpa460ndref,
                 aqpa460cmem,
                 aqpa460sust,
                 aqpa460serie,
                 aqpa460nro,
                 aqpa460tcomp,
                 aqpa460fdref,
                 aqpa460cdist,
                 aqpa460call,
                 aqpa460urb,
                 aqpa460dep,
                 aqpa460prv,
                 aqpa460dst,
                 aqpa460cpai,
                 aqpa460item,
                 aqpa460pnetu,
                 aqpa460cantf,
                 aqpa460total,
                 aqpa460dete,
                 aqpa460ctpr,
                 aqpa460vvun,
                 aqpa460vvuig,
                 aqpa460desc,
                 aqpa460mfun,
                 aqpa460prvit,
                 aqpa460medem,
                 aqpa460csuna,
                 aqpa460cpgs1,
                 aqpa460ititm,
                 aqpa460imptb,
                 aqpa460impex,
                 aqpa460afigv,
                 aqpa460sisc,
                 aqpa460codtb,
                 aqpa460dstrb,
                 aqpa460codun,
                 aqpa460mbim,
                 aqpa460taimp,
                 aqpa460cdley,
                 aqpa460teley,
                 aqpa460text1,
                 aqpa460text2,
                 aqpa460trecv,
                 aqpa460templ,
                 aqpa460subje,
                 aqpa460vpcva,
                 aqpa460nexp,
                 aqpa460cind,
                 aqpa460npart,
                 aqpa460ncont,
                 aqpa460fotrc,
                 aqpa460cdisn,
                 aqpa460direh,
                 aqpa460urbh,
                 aqpa460prvh,
                 aqpa460dsth,
                 aqpa460depth,
                 aqpa460mtotal,
                 aqpa460baimp,
                 aqpa460mtimp,
                 aqpa460pcima,
                 aqpa460bsimp,
                 aqpa460vaimp,
                 aqpa460mtinf,
                 aqpa460mtgrt,
                 aqpa460bsimps,
                 aqpa460mtoti,
                 aqpa460pgc,
                 aqpa460mod,
                 aqpa460suc,
                 aqpa460trx,
                 aqpa460rel,
                 aqpa460ore,
                 aqpa460pgce,
                 aqpa460mode,
                 aqpa460suce,
                 aqpa460trxe,
                 aqpa460rele,
                 aqpa460fcone,
                 aqpa460glos,
                 aqpa460tipag,
                 aqpa460text3,
                 aqpa460text4,
                 aqpa460conce)
              values
                (a.aqpa460tdoc,
                 a.aqpa460rucc,
                 a.aqpa460rsoc,
                 a.aqpa460cdis,
                 a.aqpa460ncom,
                 a.aqpa460calle,
                 a.aqpa460urba,
                 a.aqpa460depa,
                 a.aqpa460prov,
                 a.aqpa460dist,
                 a.aqpa460telf,
                 a.aqpa460web,
                 a.aqpa460cpais,
                 a.aqpa460cesun,
                 lc_serie,
                 lc_correlativo,
                 pd_fecpro, --a.aqpa460femi,
                 '07',
                 a.aqpa460mone,
                 a.aqpa460corrr,
                 a.aqpa460mglo,
                 a.aqpa460coma,
                 a.aqpa460tpla,
                 a.aqpa460tope,
                 a.aqpa460tplco,
                 a.aqpa460clog,
                 a.aqpa460tdocr,
                 a.aqpa460nruc,
                 a.aqpa460rasoc,
                 ln_mtotot,
                 a.aqpa460hemi,
                 a.aqpa460simc,
                 ln_mtotot, --a.aqpa460svitm,
                 ln_mtotot, --a.aqpa460spvi,
                 a.aqpa460txml,
                 a.aqpa460seri,
                 a.aqpa460num,
                 '01',
                 'Regularizacion de SUNAT',
                 a.aqpa460seri,
                 a.aqpa460num,
                 lv_codtipo,
                 pd_hfcon,
                 a.aqpa460cdist,
                 a.aqpa460call,
                 a.aqpa460urb,
                 a.aqpa460dep,
                 a.aqpa460prv,
                 a.aqpa460dst,
                 a.aqpa460cpai,
                 ln_item,
                 a.aqpa460pnetu,
                 a.aqpa460cantf,
                 ln_mtoItem, -- a.aqpa460total,
                 a.aqpa460dete,
                 a.aqpa460ctpr,
                 ln_mtoItem, --a.aqpa460vvun,
                 ln_mtoItem, --a.aqpa460vvuig,
                 a.aqpa460desc,
                 a.aqpa460mfun,
                 ln_mtoItem, --a.aqpa460prvit,
                 a.aqpa460medem,
                 a.aqpa460csuna,
                 a.aqpa460cpgs1,
                 a.aqpa460ititm,
                 a.aqpa460imptb,
                 a.aqpa460impex,
                 a.aqpa460afigv,
                 a.aqpa460sisc,
                 a.aqpa460codtb,
                 a.aqpa460dstrb,
                 a.aqpa460codun,
                 ln_mtoItem, --a.aqpa460mbim,
                 a.aqpa460taimp,
                 a.aqpa460cdley,
                 result,
                 a.aqpa460text1,
                 a.aqpa460text2,
                 a.aqpa460trecv,
                 a.aqpa460templ,
                 a.aqpa460subje,
                 a.aqpa460vpcva,
                 a.aqpa460nexp,
                 a.aqpa460cind,
                 a.aqpa460npart,
                 a.aqpa460ncont,
                 a.aqpa460fotrc,
                 a.aqpa460cdisn,
                 a.aqpa460direh,
                 a.aqpa460urbh,
                 a.aqpa460prvh,
                 a.aqpa460dsth,
                 a.aqpa460depth,
                 a.aqpa460mtotal,
                 a.aqpa460baimp,
                 a.aqpa460mtimp,
                 a.aqpa460pcima,
                 a.aqpa460bsimp,
                 a.aqpa460vaimp,
                 ln_mtotot,
                 a.aqpa460mtgrt,
                 a.aqpa460bsimps,
                 a.aqpa460mtoti,
                 a.aqpa460pgc,
                 a.aqpa460mod,
                 a.aqpa460suc,
                 a.aqpa460trx,
                 a.aqpa460rel,
                 a.aqpa460ore,
                 pn_pgcod,
                 pn_hcmod,
                 pn_hsucor,
                 pn_htran,
                 pn_hnrel,
                 pd_hfcon,
                 a.aqpa460glos,
                 a.aqpa460tipag,
                 a.aqpa460text3,
                 a.aqpa460text4,
                 a.aqpa460conce);
              commit;
            end if;
          end loop;
        
          --insertamos en AQPA464
          ln_cont := 1;
          for i in base(pn_pgcod,
                        pn_hcmod3,
                        pn_hsucor3,
                        pn_htran3,
                        pn_hnrel3,
                        pn_hfcon3,
                        lc_serieI,
                        lc_correlativoI) loop
          
            begin
              insert into aqpa464
                (aqpa464txtrub,
                 aqpa464pgcod,
                 aqpa464hcmod,
                 aqpa464hsucor,
                 aqpa464htran,
                 aqpa464hnrel,
                 aqpa464hfcon,
                 aqpa464doid,
                 aqpa464cpcod,
                 aqpa464vnro,
                 aqpa464vchr,
                 aqpa464vfch,
                 aqpa464vimp /*, aqpa464vtas*/,
                 aqpa464serie,
                 aqpa464nro,
                 aqpa464emp,
                 aqpa464mod,
                 aqpa464suc,
                 aqpa464mda,
                 aqpa464pap,
                 aqpa464cta,
                 aqpa464ope,
                 aqpa464sbo,
                 aqpa464top,
                 aqpa464hip,
                 aqpa464txtord,
                 aqpa464txoren,
                 aqpa464pgcode,
                 aqpa464hcmode,
                 aqpa464hsucore,
                 aqpa464htrane,
                 aqpa464hnrele,
                 aqpa464hfcone)
              
              values
                (i.aqpa463txtrub,
                 i.aqpa463pgcod,
                 i.aqpa463hcmod,
                 i.aqpa463hsucor,
                 i.aqpa463htran,
                 i.aqpa463hnrel,
                 i.aqpa463hfcon,
                 ln_cont,
                 i.aqpa463hcpcod,
                 i.aqpa463hvnro,
                 i.aqpa463hvchr,
                 pd_hfcon,
                 ln_cont,
                 lc_serie,
                 lc_correlativo,
                 i.aqpa463emp,
                 i.aqpa463mod,
                 i.aqpa463suc,
                 i.aqpa463mda,
                 i.aqpa463pap,
                 i.aqpa463cta,
                 i.aqpa463ope,
                 i.aqpa463sbo,
                 i.aqpa463top,
                 i.aqpa463hip,
                 i.aqpa463txtord,
                 i.aqpa463txoren,
                 pn_pgcod,
                 pn_hcmod,
                 pn_hsucor,
                 pn_htran,
                 pn_hnrel,
                 pd_hfcon);
            
              commit;
            exception
              when others then
                lc_coderr := sqlcode;
                lc_msgerr := sqlerrm;
              
            end;
            ln_cont := ln_cont + 1;
          
          end loop;
          --insertamos en AQPA466
          begin
          
            insert into aqpa466
              (aqpa466serie,
               aqpa466corr,
               aqpa466pgcod,
               aqpa466mod,
               aqpa466sucor,
               aqpa466tran,
               aqpa466rel,
               aqpa466con)
              select lc_serie,
                     lc_correlativo,
                     aqpa465pgcod,
                     aqpa465mod,
                     aqpa465sucor,
                     aqpa465tran,
                     aqpa465rel,
                     aqpa465con
                from aqpa465 a
               where a.aqpa465pgcod = pn_pgcod
                 and a.aqpa465mod = pn_hcmod3
                 and a.aqpa465sucor = pn_hsucor3
                 and a.aqpa465tran = pn_htran3
                 and a.aqpa465rel = pn_hnrel3
                 and a.aqpa465con = pn_hfcon3
                 and a.aqpa465serie = lc_serieI
                 and a.aqpa465corr = lc_correlativoI;
            commit;
          exception
            when others then
              lc_coderr := sqlcode;
              lc_msgerr := sqlerrm;
          end;
        
        end if; ---fin de tipodocu 
      
      end if;
    
      -----Extorno rechazado
    
      if lc_flg466 = 'R' or lc_flgHipo = 'N' then
        pn_pgcod   := p.pgcod;
        pn_hcmod3  := p.hcmod;
        pn_hsucor3 := p.hsucor;
        pn_htran3  := p.htran;
        pn_hnrel3  := p.hnrel;
        pn_hfcon3  := p.hfcon;
      
        ---buscar transaccion en aqpa460 / aqpa463/ aqpa465
        lc_serieI       := p.aqpa465serie;
        lc_correlativoI := p.aqpa465corr;
      
        lv_tipodocu := substr(lc_serieI, 1, 1);
        lv_tipocre  := substr(lc_serieI, 2, 1);
      
        if lv_tipodocu is not null then
        
          --determinar tipo de cliente
          if lv_tipodocu = 'F' then
            lc_tipper := 'J';
            ln_guiaCP := 1;
          else
            lc_tipper := 'N';
            ln_guiaCP := 3;
          end if;
        
          begin
            select '0' || to_char(a.tp1nro1)
              into lv_codtipo
              from fst198 a
             where a.tp1cod = 1
               and a.tp1cod1 = 11120
               and a.tp1corr1 = 1
               and a.tp1corr2 = 7
               and a.tp1corr3 = ln_guiaCP; --2018.10.10 se modifico codigo de guia para tipo comprobante
          exception
            when others then
              null;
          end;
        
          ---determinar si es hipotecario
          if lv_tipocre = 'H' then
            ln_rubro := 4;
          else
            ln_rubro := 1;
          end if;
        
          --determinar si es comision
          begin
            select 'S'
              into lc_comision
              from fst198 h
             where h.tp1cod = 1
               and h.tp1cod1 = 11120
               and h.tp1corr1 = 3
               and h.tp1corr2 = 1
               and h.tp1nro1 = pn_hcmod3
               and h.tp1nro2 = pn_htran3
               and rownum = 1;
          exception
            when others then
              lc_comision := 'N';
          end;
        
          if lc_comision = 'S' then
            ln_rubro := 1;
          end if;
        
          begin
            pq_cr_facturacion.sp_cr_factura(pn_rubro       => ln_rubro,
                                            pc_tipcli      => lc_tipper,
                                            pc_tipo        => 'NC',
                                            pc_serie       => lc_serie,
                                            pc_correlativo => lc_correlativo);
          exception
            when others then
            
              lc_coderr := sqlcode;
              lc_msgerr := trim(sqlerrm);
            
              insert into aqpa460E
                (aqpa460eserie,
                 aqpa460ecorr,
                 aqpa460epgcod,
                 aqpa460emod,
                 aqpa460esucorend,
                 aqpa460etran,
                 aqpa460erel,
                 aqpa460econ,
                 aqpa460etip,
                 Aqpa460eacoe,
                 Aqpa460eamsge)
              values
                (null,
                 null,
                 pn_pgcod,
                 pn_hcmod,
                 pn_hsucor,
                 pn_htran,
                 pn_hnrel,
                 pd_hfcon,
                 'S',
                 lc_coderr,
                 lc_msgerr);
              commit;
            
          end;
        
          --insertamos en AQPA460            
          begin
            insert into AQPA460
              (aqpa460tdoc,
               aqpa460rucc,
               aqpa460rsoc,
               aqpa460cdis,
               aqpa460ncom,
               aqpa460calle,
               aqpa460urba,
               aqpa460depa,
               aqpa460prov,
               aqpa460dist,
               aqpa460telf,
               aqpa460web,
               aqpa460cpais,
               aqpa460cesun,
               aqpa460seri,
               aqpa460num,
               aqpa460femi,
               aqpa460tcomf,
               aqpa460mone,
               aqpa460corrr,
               aqpa460mglo,
               aqpa460coma,
               aqpa460tpla,
               aqpa460tope,
               aqpa460tplco,
               aqpa460clog,
               aqpa460tdocr,
               aqpa460nruc,
               aqpa460rasoc,
               aqpa460impt,
               aqpa460hemi,
               aqpa460simc,
               aqpa460svitm,
               aqpa460spvi,
               aqpa460txml,
               aqpa460sdref,
               aqpa460ndref,
               aqpa460cmem,
               aqpa460sust,
               aqpa460serie,
               aqpa460nro,
               aqpa460tcomp,
               aqpa460fdref,
               aqpa460cdist,
               aqpa460call,
               aqpa460urb,
               aqpa460dep,
               aqpa460prv,
               aqpa460dst,
               aqpa460cpai,
               aqpa460item,
               aqpa460pnetu,
               aqpa460cantf,
               aqpa460total,
               aqpa460dete,
               aqpa460ctpr,
               aqpa460vvun,
               aqpa460vvuig,
               aqpa460desc,
               aqpa460mfun,
               aqpa460prvit,
               aqpa460medem,
               aqpa460csuna,
               aqpa460cpgs1,
               aqpa460ititm,
               aqpa460imptb,
               aqpa460impex,
               aqpa460afigv,
               aqpa460sisc,
               aqpa460codtb,
               aqpa460dstrb,
               aqpa460codun,
               aqpa460mbim,
               aqpa460taimp,
               aqpa460cdley,
               aqpa460teley,
               aqpa460text1,
               aqpa460text2,
               aqpa460trecv,
               aqpa460templ,
               aqpa460subje,
               aqpa460vpcva,
               aqpa460nexp,
               aqpa460cind,
               aqpa460npart,
               aqpa460ncont,
               aqpa460fotrc,
               aqpa460cdisn,
               aqpa460direh,
               aqpa460urbh,
               aqpa460prvh,
               aqpa460dsth,
               aqpa460depth,
               aqpa460mtotal,
               aqpa460baimp,
               aqpa460mtimp,
               aqpa460pcima,
               aqpa460bsimp,
               aqpa460vaimp,
               aqpa460mtinf,
               aqpa460mtgrt,
               aqpa460bsimps,
               aqpa460mtoti,
               aqpa460pgc,
               aqpa460mod,
               aqpa460suc,
               aqpa460trx,
               aqpa460rel,
               aqpa460ore,
               aqpa460pgce,
               aqpa460mode,
               aqpa460suce,
               aqpa460trxe,
               aqpa460rele,
               aqpa460fcone,
               aqpa460glos,
               aqpa460tipag,
               aqpa460text3,
               aqpa460text4,
               aqpa460conce)
              select aqpa460tdoc,
                     aqpa460rucc,
                     aqpa460rsoc,
                     aqpa460cdis,
                     aqpa460ncom,
                     aqpa460calle,
                     aqpa460urba,
                     aqpa460depa,
                     aqpa460prov,
                     aqpa460dist,
                     aqpa460telf,
                     aqpa460web,
                     aqpa460cpais,
                     aqpa460cesun,
                     lc_serie,
                     lc_correlativo,
                     pd_Fecpro, --aqpa460femi,
                     '07',
                     aqpa460mone,
                     aqpa460corrr,
                     aqpa460mglo,
                     aqpa460coma,
                     aqpa460tpla,
                     aqpa460tope,
                     aqpa460tplco,
                     aqpa460clog,
                     aqpa460tdocr,
                     aqpa460nruc,
                     aqpa460rasoc,
                     aqpa460impt,
                     aqpa460hemi,
                     aqpa460simc,
                     aqpa460svitm,
                     aqpa460spvi,
                     aqpa460txml,
                     aqpa460seri,
                     aqpa460num,
                     '01',
                     'Regularizacion de SUNAT',
                     aqpa460seri,
                     aqpa460num,
                     lv_codtipo,
                     pd_hfcon,
                     aqpa460cdist,
                     aqpa460call,
                     aqpa460urb,
                     aqpa460dep,
                     aqpa460prv,
                     aqpa460dst,
                     aqpa460cpai,
                     aqpa460item,
                     aqpa460pnetu,
                     aqpa460cantf,
                     aqpa460total,
                     aqpa460dete,
                     aqpa460ctpr,
                     aqpa460vvun,
                     aqpa460vvuig,
                     aqpa460desc,
                     aqpa460mfun,
                     aqpa460prvit,
                     aqpa460medem,
                     aqpa460csuna,
                     aqpa460cpgs1,
                     aqpa460ititm,
                     aqpa460imptb,
                     aqpa460impex,
                     aqpa460afigv,
                     aqpa460sisc,
                     aqpa460codtb,
                     aqpa460dstrb,
                     aqpa460codun,
                     aqpa460mbim,
                     aqpa460taimp,
                     aqpa460cdley,
                     aqpa460teley,
                     aqpa460text1,
                     aqpa460text2,
                     aqpa460trecv,
                     aqpa460templ,
                     aqpa460subje,
                     aqpa460vpcva,
                     aqpa460nexp,
                     aqpa460cind,
                     aqpa460npart,
                     aqpa460ncont,
                     aqpa460fotrc,
                     aqpa460cdisn,
                     aqpa460direh,
                     aqpa460urbh,
                     aqpa460prvh,
                     aqpa460dsth,
                     aqpa460depth,
                     aqpa460mtotal,
                     aqpa460baimp,
                     aqpa460mtimp,
                     aqpa460pcima,
                     aqpa460bsimp,
                     aqpa460vaimp,
                     aqpa460mtinf,
                     aqpa460mtgrt,
                     aqpa460bsimps,
                     aqpa460mtoti,
                     aqpa460pgc,
                     aqpa460mod,
                     aqpa460suc,
                     aqpa460trx,
                     aqpa460rel,
                     aqpa460ore,
                     pn_pgcod,
                     pn_hcmod,
                     pn_hsucor,
                     pn_htran,
                     pn_hnrel,
                     pd_hfcon,
                     aqpa460glos,
                     aqpa460tipag,
                     aqpa460text3,
                     aqpa460text4,
                     aqpa460conce
                from AQPA460 a
               where a.aqpa460seri = lc_serieI
                 and a.aqpa460num = lc_correlativoI;
          
            commit;
          exception
            when others then
              lc_coderr := sqlcode;
              lc_msgerr := sqlerrm;
            
          end;
        
          --insertamos en AQPA464
          ln_cont := 1;
          for i in base(pn_pgcod,
                        pn_hcmod3,
                        pn_hsucor3,
                        pn_htran3,
                        pn_hnrel3,
                        pn_hfcon3,
                        lc_serieI,
                        lc_correlativoI) loop
          
            begin
              insert into aqpa464
                (aqpa464txtrub,
                 aqpa464pgcod,
                 aqpa464hcmod,
                 aqpa464hsucor,
                 aqpa464htran,
                 aqpa464hnrel,
                 aqpa464hfcon,
                 aqpa464doid,
                 aqpa464cpcod,
                 aqpa464vnro,
                 aqpa464vchr,
                 aqpa464vfch,
                 aqpa464vimp /*, aqpa464vtas*/,
                 aqpa464serie,
                 aqpa464nro,
                 aqpa464emp,
                 aqpa464mod,
                 aqpa464suc,
                 aqpa464mda,
                 aqpa464pap,
                 aqpa464cta,
                 aqpa464ope,
                 aqpa464sbo,
                 aqpa464top,
                 aqpa464hip,
                 aqpa464txtord,
                 aqpa464txoren,
                 aqpa464pgcode,
                 aqpa464hcmode,
                 aqpa464hsucore,
                 aqpa464htrane,
                 aqpa464hnrele,
                 aqpa464hfcone)
              
              values
                (i.aqpa463txtrub,
                 i.aqpa463pgcod,
                 i.aqpa463hcmod,
                 i.aqpa463hsucor,
                 i.aqpa463htran,
                 i.aqpa463hnrel,
                 i.aqpa463hfcon,
                 ln_cont,
                 i.aqpa463hcpcod,
                 i.aqpa463hvnro,
                 i.aqpa463hvchr,
                 pd_hfcon,
                 ln_cont,
                 lc_serie,
                 lc_correlativo,
                 i.aqpa463emp,
                 i.aqpa463mod,
                 i.aqpa463suc,
                 i.aqpa463mda,
                 i.aqpa463pap,
                 i.aqpa463cta,
                 i.aqpa463ope,
                 i.aqpa463sbo,
                 i.aqpa463top,
                 i.aqpa463hip,
                 i.aqpa463txtord,
                 i.aqpa463txoren,
                 pn_pgcod,
                 pn_hcmod,
                 pn_hsucor,
                 pn_htran,
                 pn_hnrel,
                 pd_hfcon);
            
              commit;
            exception
              when others then
                lc_coderr := sqlcode;
                lc_msgerr := sqlerrm;
              
            end;
            ln_cont := ln_cont + 1;
          
          end loop;
          --insertamos en AQPA466
          begin
          
            insert into aqpa466
              (aqpa466serie,
               aqpa466corr,
               aqpa466pgcod,
               aqpa466mod,
               aqpa466sucor,
               aqpa466tran,
               aqpa466rel,
               aqpa466con)
              select lc_serie,
                     lc_correlativo,
                     aqpa465pgcod,
                     aqpa465mod,
                     aqpa465sucor,
                     aqpa465tran,
                     aqpa465rel,
                     aqpa465con
                from aqpa465 a
               where a.aqpa465pgcod = pn_pgcod
                 and a.aqpa465mod = pn_hcmod3
                 and a.aqpa465sucor = pn_hsucor3
                 and a.aqpa465tran = pn_htran3
                 and a.aqpa465rel = pn_hnrel3
                 and a.aqpa465con = pn_hfcon3
                 and a.aqpa465serie = lc_serieI
                 and a.aqpa465corr = lc_correlativoI;
            commit;
          exception
            when others then
              lc_coderr := sqlcode;
              lc_msgerr := sqlerrm;
          end;
        
        end if; ---fin de tipodocu 
      
      end if;
    
    end loop;
  end sp_cr_proceso_1911;
end Pq_cr_NotaCredito;
/

