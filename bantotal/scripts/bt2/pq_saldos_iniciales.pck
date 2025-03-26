CREATE OR REPLACE PACKAGE pq_saldos_iniciales IS
  --                                          : lllosa 2012.04.02 3:00pm
  --                                          : lllosa 2012.04.09 4:40pm
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                           
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                                     
  --procedure sp_extra_garantia_cts ;
  procedure sp_saldos_iniciales_BNJ;

END pq_saldos_iniciales;

 
/
CREATE OR REPLACE PACKAGE BODY pq_saldos_iniciales IS


  procedure sp_saldos_iniciales_BNJ IS
  -- ***************************************************************************************
  -- Llena las bandejas BNJ000 y  BNJ005 con datos de inventario de CREDITOS
  -- ***************************************************************************************
    
       
  ln_emp number    :=1;
  ln_cod number    :=105;
  lc_tippro varchar2(1):='P';
  lc_rubint varchar2(50);
  ld_fecini date;
  --ln_coderr varchar2(100);
  lc_msgerr varchar2(300);
  ln_nro log_carga_bandeja.n_nro%type;
  ln_tamano log_carga_bandeja.n_sizegb%type;
  lc_diffec log_carga_bandeja.c_diffec%type;
  --lc_coderr varchar2(50);
  
 
  --
  cursor pasivas is
    select bnjsuc, sum(saldo)saldo, sum(saldo_dpf),  sum(Devengado) Devengado, 
       sum(BnjIm4),  sum(BnjIm5),  sum(BnjIm7), sum(BnjIm8),
      Case when Judicial = 'S' then  '21'||decode(moneda,0,1,2) ||'1120100009'
            when Tipo_Cta = 'A' and (tip_per = 'F' or ( tip_per ='J' and Tipo_juridica = 'SFL'))
             and producto = 'AHO' and nvl(Judicial,'N') ='N' then '21'||decode(moneda,0,1,2) ||'2010100009'
            When Tipo_Cta = 'A' and tip_per ='J' and Tipo_juridica = 'CFL'
             and producto = 'AHO' and nvl(Judicial,'N') ='N' then '21'||decode(moneda,0,'1','2') ||'2010200009'      
           --
            When Tipo_Cta = 'A' and tip_per ='J' and Tipo_juridica is null --= 'CFL'
             and producto = 'AHO' and nvl(Judicial,'N') ='N' then '21'||decode(moneda,0,'1','2') ||'2010200009' 
            --  
            when Tipo_Cta = 'I' and (tip_per = 'F' or ( tip_per ='J' and Tipo_juridica = 'SFL'))
             and producto = 'AHO' and nvl(Judicial,'N') ='N' then '21'||decode(moneda,0,'1','2')||'2020100009'
            When Tipo_Cta = 'I' and tip_per ='J' and Tipo_juridica = 'CFL'
             and producto = 'AHO' and nvl(Judicial,'N') ='N' then '21'||decode(moneda,0,'1','2') ||'2020200009'
            --
             When Tipo_Cta = 'I' and tip_per ='J' and Tipo_juridica is null --= 'CFL' 2122020200001
             and producto = 'AHO' and nvl(Judicial,'N') ='N' then '21'||decode(moneda,0,'1','2') ||'2020200009'
            -- 
            when (tip_per = 'F' or ( tip_per ='J' and Tipo_juridica = 'SFL'))
             and producto = 'DPF' then '21'||decode(moneda,0,'1','2') ||'3030100009'
            When tip_per ='J' and Tipo_juridica = 'CFL'
             and producto = 'DPF' and nvl(Judicial,'N') ='N' then '21'||decode(moneda,0,1,2) ||'3030200009' 
            When producto = 'CTS' and Conbenio = 'N' then '21'||decode(moneda,0,'1','2') ||'3050100009' 
            When producto = 'CTS' and Conbenio = 'S' then '21'||decode(moneda,0,'1','2') ||'3050200009' else
            substr(to_char(bnjim15),1,2)||decode(moneda,0,'1','2') || substr(to_char(bnjim15),4,10) end rubro,moneda,0, 'P'
       
              
from (       
       
select case when BnjCod = 321 then 'I' 
            when BnjCod in (301,322) then 'A'
            else null end Tipo_Cta,
       a.petipo tip_per,  
       case when a.petipo = 'J' and d.PJSEGMENTO =  2 then 'CFL'
            when a.petipo = 'J' and d.PJSEGMENTO =  1 then 'SFL'
            else null end Tipo_juridica,  
       case when BnjCod in (500,505) then 'DPF'
            when BnjCod in (301,322) and  BnjTOpe = 2 then 'CTS'
            else 'AHO' end producto,
       case when BnjCod in (301,322) and  BnjTOpe = 2 then nvl(c.pfebco,'N') end Conbenio,
       case when BnjCod in (301,322,320) and  BnjTOpe = 5 then 'S'
            when BnjCod in (301,322) and  BnjTOpe <> 5 then 'N' else null end Judicial,
       BnjMda moneda,  BnjSdo saldo, BnjImp saldo_dpf,  BnjIm3 Devengado, 
       BnjIm4,  BnjIm5,  BnjIm7, BnjIm8,
       BnjIm13, BnjCta, x.bnjtope,x.bnjim10, x.bnjim15, x.bnjsuc
  from bnj002 x, fsd001 a, fsr008 b, fsd002 c, fsd003 d
 where a.pepais = b.pepais 
   and a.petdoc = b.petdoc 
   and a.pendoc = b.pendoc 
   and b.ctnro = BnjCta 
   and b.cttfir ='T' 
   and a.pepais = c.pfpais (+)
   and a.petdoc = c.pftdoc (+) 
   and a.pendoc = c.pfndoc (+)
   and a.pepais = d.pjpais (+)
   and a.petdoc = d.pjtdoc (+) 
   and a.pendoc = d.pjndoc (+) )

group by moneda,
      Case when Judicial = 'S' then  '21'||decode(moneda,0,1,2) ||'1120100009'
            when Tipo_Cta = 'A' and (tip_per = 'F' or ( tip_per ='J' and Tipo_juridica = 'SFL'))
             and producto = 'AHO' and nvl(Judicial,'N') ='N' then '21'||decode(moneda,0,1,2) ||'2010100009'
            When Tipo_Cta = 'A' and tip_per ='J' and Tipo_juridica = 'CFL'
             and producto = 'AHO' and nvl(Judicial,'N') ='N' then '21'||decode(moneda,0,'1','2') ||'2010200009'      
           --
            When Tipo_Cta = 'A' and tip_per ='J' and Tipo_juridica is null --= 'CFL'
             and producto = 'AHO' and nvl(Judicial,'N') ='N' then '21'||decode(moneda,0,'1','2') ||'2010200009' 
            --  
            when Tipo_Cta = 'I' and (tip_per = 'F' or ( tip_per ='J' and Tipo_juridica = 'SFL'))
             and producto = 'AHO' and nvl(Judicial,'N') ='N' then '21'||decode(moneda,0,'1','2')||'2020100009'
            When Tipo_Cta = 'I' and tip_per ='J' and Tipo_juridica = 'CFL'
             and producto = 'AHO' and nvl(Judicial,'N') ='N' then '21'||decode(moneda,0,'1','2') ||'2020200009'
            --
             When Tipo_Cta = 'I' and tip_per ='J' and Tipo_juridica is null --= 'CFL' 2122020200001
             and producto = 'AHO' and nvl(Judicial,'N') ='N' then '21'||decode(moneda,0,'1','2') ||'2020200009'
            -- 
            when (tip_per = 'F' or ( tip_per ='J' and Tipo_juridica = 'SFL'))
             and producto = 'DPF' then '21'||decode(moneda,0,'1','2') ||'3030100009'
            When tip_per ='J' and Tipo_juridica = 'CFL'
             and producto = 'DPF' and nvl(Judicial,'N') ='N' then '21'||decode(moneda,0,1,2) ||'3030200009' 
            When producto = 'CTS' and Conbenio = 'N' then '21'||decode(moneda,0,'1','2') ||'3050100009' 
            When producto = 'CTS' and Conbenio = 'S' then '21'||decode(moneda,0,'1','2') ||'3050200009' else
            substr(to_char(bnjim15),1,2)||decode(moneda,0,'1','2') || substr(to_char(bnjim15),4,10) end,
                   bnjsuc; 
       
  BEGIN
    /* Datos de control */
    ld_fecini := sysdate;
    insert into LOG_CARGA_BANDEJA
      (n_nro,c_codbdj,c_cptbdj,d_fecini)
    values
      (seq_nro_ejecucion.NEXTVAL,
       'BNJ000',
       'Saldos Iniciales Consolidados.Activas',
       ld_fecini);
    commit;
    select seq_nro_ejecucion.nextval into ln_nro from dual;
    ---
        
    -- EXECUTE IMMEDIATE ('TRUNCATE TABLE tab_err_saldos');
 EXECUTE IMMEDIATE ('TRUNCATE TABLE bandejas.bnj000');
-- EXECUTE IMMEDIATE ('TRUNCATE TABLE bandejas.bnj005');

  for i in pasivas loop
      -- insertsa saldo
      lc_rubint := null;
      insert into bnj000 (bnjsdcode,bnjsdcodb,bnjsdsuc,
                      bnjsdrub,bnjsdmda,bnjsdpap,
                      BnjSdImp,BnjSdEst)
      values(ln_emp,ln_cod,i.bnjsuc,
             i.rubro,i.moneda,0,
             i.saldo,lc_tippro);
      
      -- inserta devengado
      if i.devengado <> 0 then 
         lc_rubint := substr(i.rubro,1,3)||'803'||substr(i.rubro,7,5)||'99';
         if lc_rubint is not null then         
            begin    
              insert into bnj000 (bnjsdcode,bnjsdcodb,bnjsdsuc,
                                  bnjsdrub,bnjsdmda,bnjsdpap,
                                  BnjSdImp,BnjSdEst)
              values(ln_emp,ln_cod,i.bnjsuc,
               lc_rubint,i.moneda,0,
               i.devengado,lc_tippro); 
            exception
              when dup_val_on_index then
                 update bnj000
                    set BnjSdImp  = BnjSdImp + i.devengado
                  where bnjsdcode = ln_emp
                    and bnjsdcodb = ln_cod
                    and bnjsdsuc  = i.bnjsuc
                    and bnjsdrub  = lc_rubint
                    and bnjsdmda  = i.moneda
                    and bnjsdpap  = 0;
             commit; 
           end;                              
          end if;
       end if;                         
       commit;
  end loop;

  -- Saldos Intagibles
   
  -- Contra Cuenta
  begin
  insert into bnj000 (bnjsdcode,bnjsdcodb,bnjsdsuc,
                                bnjsdrub,bnjsdmda,bnjsdpap,
                                BnjSdImp,BnjSdEst)

  select ln_emp,ln_cod,904,
         '19'||decode(BnjMda,0,'1','2') ||'8070000098', BnjMda, 0,
         sum(BnjSdo)+ sum(BnjIm3),lc_tippro
    from bnj002
   group by  '19'||decode(BnjMda,0,'1','2') ||'8070000098', BnjMda;
  commit; 
  exception 
    when others then 
       null;
  end;     
  
  ----------------------------------------------
  ----------------------------------------------
  
    update LOG_CARGA_BANDEJA
       set d_fecfin = sysdate,n_sizegb = ln_tamano,c_diffec = lc_diffec
     where n_nro = ln_nro;
    commit;
   EXCEPTION
       when others then
            NULL;
         --p_c_coderr := sqlcode;
         lc_msgerr := sqlerrm;
  END;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  

     
END pq_saldos_iniciales;
/
