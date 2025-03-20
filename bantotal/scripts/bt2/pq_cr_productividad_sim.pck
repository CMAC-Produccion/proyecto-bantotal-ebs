create or replace package PQ_CR_PRODUCTIVIDAD_SIM is
 
    -- *****************************************************************
    -- Nombre                     : SIMULADOR DE PRODUCTIVIDAD DE ANALISTAS DE CREDITO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2019.06.03
    -- Autor de Creación          : DCASTRO 
    -- Uso                        : SIMULAR LA PRODUCTIVIDAD DE ANALISTAS DE CREDITOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   :  
    -- Descripción de Modificación: 
    -- *****************************************************************
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_simulador(pd_fecpro in date,
                       pc_codase in varchar2,
                       pn_codage in number,
                       pn_codcat in number,
                       pc_tipase in char,
                       pn_mtosdo in number,
                       pn_numcli in number,
                       pn_salmor in number,
                       pn_saloto in number,
                       pn_salrec in number,
                       pn_clioto in number,
                       pn_clirec in number,
                       pn_salcas in number,
                       pn_saljud in number,
                       pn_salven in number,
                       pn_cliven in number,
                       pn_bascon in number,
                       pn_salcon in number,
                       pn_basret in number,
                       pn_numret in number,
                       pn_destot in number,
                       pn_depyme in number) ;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_carga_datos(pc_codase in varchar2 , pd_fecpro in date);    
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_simula(pd_fecpro in date,
                         pc_codase in varchar2,---char ,
                         pn_codage in number,
                         pn_codcat in number,
                         pc_tipase in varchar2,--char,
                         pn_mtosdo in number,
                         pn_numcli in number, 
                         pn_salmor in number, 
                         pn_saloto in number, 
                         pn_salrec in number,                          
                         pn_clioto in number, 
                         pn_clirec in number,                                                   
                         pn_salcas in number,                                                   
                         pn_saljud in number,  
                         pn_salven in number,                                                   
                         pn_cliven in number, 
                         pn_bascon in number,                                                                         
                         pn_salcon in number,                                                   
                         pn_basret in number,                                                                         
                         pn_numret in number, 
                         pn_destot in number,                                                  
                         pn_depyme in number
                        );
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Function fn_cr_continuidad_mora(pc_analista IN varchar2,pd_fecpro in date ) return number;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Procedure sp_cr_bonoTrimestral( pd_fecpro in date, pc_analista in varchar2, pc_codage in number);
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Function fn_cr_cartera_recibida( pc_analista IN char, pd_fecpro IN date) return char;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_variacion_mora  ( pc_analista IN char, pd_fecpro IN date, pc_tipase in char, pn_pormor IN number , pn_pormoa out number, pn_varmor out number  );
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Function fn_cr_nuevamora_anterior(pc_analista IN varchar2,pd_fecpro in date,pd_fechoy in date) return number;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
end PQ_CR_PRODUCTIVIDAD_SIM;
/

create or replace package body PQ_CR_PRODUCTIVIDAD_SIM is
    -- *****************************************************************
    -- Nombre                     : PQ_CR_PRODUCTIVIDAD_SIM
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2019.06.03
    -- Autor de Creación          : DCASTRO
    -- Uso                        : SIMULAR PRODUCTIVIDAD DE ANALISTAS DE CREDITOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --                              
    --                              
    -- *****************************************************************
    
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_simulador(pd_fecpro in date,
                       pc_codase in varchar2,
                       pn_codage in number,
                       pn_codcat in number,
                       pc_tipase in char,
                       pn_mtosdo in number,
                       pn_numcli in number,
                       pn_salmor in number,
                       pn_saloto in number,
                       pn_salrec in number,
                       pn_clioto in number,
                       pn_clirec in number,
                       pn_salcas in number,
                       pn_saljud in number,
                       pn_salven in number,
                       pn_cliven in number,
                       pn_bascon in number,
                       pn_salcon in number,
                       pn_basret in number,
                       pn_numret in number,
                       pn_destot in number,
                       pn_depyme in number) is
  -- *****************************************************************
  -- Nombre                     : sp_cr_simulador
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2019.06.03
  -- Autor de Creación          : 
  -- Uso                        : SIMULA PRODUCTIVIDAD 
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- *****************************************************************

begin

  --inserta de tabla JAQL600 a tabla JAQL600X - carga datos  
  begin
    pq_cr_productividad_sim.sp_cr_carga_datos(pc_codase => pc_codase,
                                              pd_fecpro => pd_fecpro);
  end;
 
  --calcula productividad
  begin
    pq_cr_productividad_sim.sp_cr_simula(pd_fecpro => pd_fecpro,
                                         pc_codase => pc_codase,
                                         pn_codage => pn_codage,
                                         pn_codcat => pn_codcat,
                                         pc_tipase => pc_tipase,
                                         pn_mtosdo => pn_mtosdo,
                                         pn_numcli => pn_numcli,
                                         pn_salmor => pn_salmor,
                                         pn_saloto => pn_saloto,
                                         pn_salrec => pn_salrec,
                                         pn_clioto => pn_clioto,
                                         pn_clirec => pn_clirec,
                                         pn_salcas => pn_salcas,
                                         pn_saljud => pn_saljud,
                                         pn_salven => pn_salven,
                                         pn_cliven => pn_cliven,
                                         pn_bascon => pn_bascon,
                                         pn_salcon => pn_salcon,
                                         pn_basret => pn_basret,
                                         pn_numret => pn_numret,
                                         pn_destot => pn_destot,
                                         pn_depyme => pn_depyme);
  end;

end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_carga_datos(pc_codase in varchar2 , pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_carga_datos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2019.06.03
    -- Autor de Creación          : 
    -- Uso                        : CARGA DATOS PRODUCTIVIDAD JAQL600
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************


cursor creditos(lc_analista char) is
select * from jaql600 a
    where a.jaql600fpro = pd_fecpro
      and a.jaql600usu = lc_analista;

 
lc_analista char(10);

begin

    lc_analista := rpad(pc_codase, 10, ' ');

     delete from  JAQL600x j where j.JAQL600fprox =pd_fecpro  and j.JAQL600usux = lc_analista; 
     commit;
     
     for i in creditos(lc_analista) loop
    
            insert into JAQL600X (JAQL600fprox, JAQL600usux, JAQL600agex, JAQL600mantx, JAQL600codcatx, JAQL600tasex, JAQL600sdox, JAQL600nclx, 
                                  JAQL600sdmx, JAQL600pmrax, JAQL600sotox, JAQL600srecx, JAQL600cotox, JAQL600crecx, JAQL600srlx, JAQL600nrlx, JAQL600santx, JAQL600cantx, 
                                  JAQL600sdcax, JAQL600sdjux, JAQL600crsax, JAQL600crclx, JAQL600idesx, JAQL600pdesx, JAQL600mtsax, JAQL600mtclx, JAQL600mtrex, JAQL600mtmrx, 
                                  JAQL600psalx, JAQL600pclix, JAQL600pretx, JAQL600pmorx, JAQL600pvarx, JAQL600pjcax, JAQL600pjcasx, JAQL600cmrax, JAQL600cltotx, JAQL600sdtotx, 
                                  JAQL600bsalx, JAQL600bclix, JAQL600bmrax, JAQL600btrix, JAQL600totpax, JAQL600ccamx, JAQL600vcamx, JAQL600tcamx, JAQL600mconx, JAQL600aux1x, 
                                  JAQL600aux2x, JAQL600aux3x, JAQL600aux4x, JAQL600aux5x, JAQL600aux6x, JAQL600estx, JAQL600neox, JAQL600pcamx, JAQL600pordx, JAQL600mtodx, 
                                  JAQL600vmorx, JAQL600csalx, JAQL600esalx, JAQL600cclix, JAQL600eclix, JAQL600cretx, JAQL600eretx, JAQL600posax, JAQL600poclx, JAQL600exsax, 
                                  JAQL600exclx, JAQL600exrex, JAQL600porex, JAQL600barex, JAQL600morex, JAQL600pmoax, JAQL600cavex, JAQL600clvex, JAQL600comix, JAQL600incox, 
                                  JAQL600nmesx, JAQL600smortx, JAQL600pmortx )
                                  
                          values ( i.jaql600fpro, i.jaql600usu, i.jaql600age, i.jaql600mant, i.jaql600codcat, i.jaql600tase, i.jaql600sdo, i.jaql600ncl, 
                                   i.jaql600sdm, i.jaql600pmra, i.jaql600soto, i.jaql600srec, i.jaql600coto, i.jaql600crec, i.jaql600srl, i.jaql600nrl, i.jaql600sant, i.jaql600cant, 
                                   i.jaql600sdca, i.jaql600sdju, i.jaql600crsa, i.jaql600crcl, i.jaql600ides, i.jaql600pdes, i.jaql600mtsa, i.jaql600mtcl, i.jaql600mtre, i.jaql600mtmr, 
                                   i.jaql600psal, i.jaql600pcli, i.jaql600pret, i.jaql600pmor, i.jaql600pvar, i.jaql600pjca, i.jaql600pjcas, i.jaql600cmra, i.jaql600cltot, i.jaql600sdtot, 
                                   i.jaql600bsal, i.jaql600bcli, i.jaql600bmra, i.jaql600btri, i.jaql600totpa, i.jaql600ccam, i.jaql600vcam, i.jaql600tcam, i.jaql600aux1, i.jaql600aux1, 
                                   i.jaql600aux2, i.jaql600aux3, i.jaql600aux4, i.jaql600aux5, i.jaql600aux6, i.jaql600est, i.jaql600neo, i.jaql600pcam, i.jaql600pord, i.jaql600mtod, 
                                   i.jaql600vmor, i.jaql600csal, i.jaql600esal, i.jaql600ccli, i.jaql600ecli, i.jaql600cret, i.jaql600eret, i.jaql600posa, i.jaql600pocl, i.jaql600exsa, 
                                   i.jaql600excl, i.jaql600exre, i.jaql600pore, i.jaql600bare, i.jaql600more, i.jaql600pmoa, i.jaql600cave, i.jaql600clve, i.jaql600comi, i.jaql600inco, 
                                   i.jaql600nmes, i.jaql600smort, i.jaql600pmort
                                  );
    
           commit; 
     
   
      end loop;     
 
 end sp_cr_carga_datos;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --      
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_simula(pd_fecpro in date,
                       pc_codase in varchar2,
                       pn_codage in number,
                       pn_codcat in number,
                       pc_tipase in varchar2,
                       pn_mtosdo in number,
                       pn_numcli in number,
                       pn_salmor in number,
                       pn_saloto in number,
                       pn_salrec in number,
                       pn_clioto in number,
                       pn_clirec in number,
                       pn_salcas in number,
                       pn_saljud in number,
                       pn_salven in number,
                       pn_cliven in number,
                       pn_bascon in number,
                       pn_salcon in number,
                       pn_basret in number,
                       pn_numret in number,
                       pn_destot in number,
                       pn_depyme in number) is
  -- *****************************************************************
  -- Nombre                     : sp_cr_simula
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2019.06.03
  -- Autor de Creación          : 
  -- Uso                        : SIMULA PRODUCTIVIDAD 
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- *****************************************************************

  cursor creditos (lc_analista char)
  is
    select *
      from JAQL600X a
     where a.JAQL600fprox = pd_fecpro
       and a.JAQL600usux = lc_analista;

  lc_tipo_NEO        char(1);
  ln_saltot          number(17, 2);
  ln_clitot          number;
  ln_cresal          number(17, 2);
  ln_crecli          number;
  ln_pormor          number;
  ln_excsal          number;
  ln_exccli          number;
  ln_INDMORA         number;
  ln_saldodes        number;
  ln_porcentaje      number;
  ln_saldodesT       number;
  ln_numret          number; 
  ln_excret          number;
  ln_pordes          number;
  ln_porpagT         number;
  ln_porpagP         number;
  ln_porpago         number;
  ln_metsal          number;
  ln_metcli          number;
  ln_metret          number;
  ln_pagsal_tot      number;
  ln_pagcli_tot      number;
  ln_mtosal          number;
  ln_mtocli          number;
  ln_mtoret          number;
  ln_pagsal          number;
  ln_porcumsal       number;
  ln_salexcedente    number;
  ln_pagsal_adi      number;
  ln_pagcli          number;
  ln_porcumcli       number;
  ln_cliexcedente    number;
  ln_pagcli_adi      number;
  ln_totalpagovariable          number;
  ln_baseret         number;
  ln_retenidos       number;
  ln_porretencion    number;
  ln_pagret          number;
  ln_retexcedente    number;
  ln_pagret_adi      number;
  ln_pagret_tot      number;
  ln_subpagovariable number;
  ln_mora            number;
  ln_pagmora         number;
  ln_cascontinuidad  number;
  lc_cartera_rec     char(1);
  ln_nummes          number;
  lc_excluir_cont    char(1);
  ln_incmor          number;
  ln_pjcas           number;
  ln_TOTAL           number;
  ln_pagocontencion  number;
  ln_codcam          number;
  ln_basecon         number;
  ln_contenidos      number;
  ln_porcontencion   number;
  ln_pormoa          number;
  ln_varmor          number;
  lc_analista        char(10);

  
begin


  lc_analista := rpad(pc_codase, 10, ' ');


  for i in creditos(lc_analista) loop
     
    --ln_salmor  ingresa el saldo mora        
  
    ln_saltot := pn_mtosdo + pn_saloto - pn_salrec + pn_saljud /*+ pn_salcas*/ +
                 pn_salven;
    ln_clitot := pn_numcli + pn_clioto - pn_clirec + pn_cliven;
  
    ln_cresal := ln_saltot - i.JAQL600santx;
    ln_crecli := ln_clitot - i.JAQL600cantx;
  
    --RETORNA TIPO
    lc_tipo_NEO := trim(pq_cr_productividad_2016.fn_cr_tipo_agencia_metas(pn_codage,
                                                                          pd_fecpro));
  
    --RETORNA METAS      
    begin
      pq_cr_productividad_2016.sp_cr_metas(pn_codcat => pn_codcat,
                                           pc_tipase => pc_tipase,
                                           pn_cresal => ln_metsal,
                                           pn_crecli => ln_metcli,
                                           pn_mincom => ln_metret);
    end;
  
  
    ---MORA
    --ln_Por_Mora := pq_cr_productividad_2016.fn_pa_nueva_mora(i.jaql600usu,pd_fecpro,i.jaql600age, i.jaql600sdm,i.jaql600sdju, i.jaql600sdo);
    if (pn_mtosdo + pn_salcas + pn_saljud + pn_salven) > 0 then
      ln_pormor := round((pn_salmor + pn_saljud + pn_salcas + pn_salven) /
                         (pn_mtosdo + pn_saljud) * 100,
                         2);
    else
      ln_pormor := 0;
    end if;
  
    if pc_tipase = 'P' then
      --aplica para PYMES
       --porcentaje de desembolsos permitido
      begin
        select tp1nro1, tp1nro2, tp1nro3
          into ln_pordes, ln_porpagT, ln_porpagP
          from fst198
         where tp1cod = 1
           and tp1cod1 = 10847
           and tp1corr1 = 12;
      exception when others then
           ln_pordes := 0;   
      end;  
      
      
      ln_porcentaje := round(pn_depyme  * 100 / pn_destot, 2);
      
       if ln_porcentaje >= ln_pordes then
           ln_porpago := ln_porpagT;
       else
           ln_porpago := ln_porpagP;
       end if;
      
      --INDICADORES DESEMBOLSOS
    
      --excedente cartera PYMES
      begin
        select (tp1nro1 / tp1nro2)
          into ln_excsal
          from fst198 f
         where tp1cod = 1
           and tp1cod1 = 10847
           and tp1corr1 = 13
           and tp1corr2 = 1;
      end;
    
      --excedente clientes PYMES
      begin
        select (tp1nro1 / tp1nro2)
          into ln_exccli
          from fst198 f
         where tp1cod = 1
           and tp1cod1 = 10847
           and tp1corr1 = 13
           and tp1corr2 = 2;
      end;
    
      ln_INDMORA := 1;
    
    else
      --para CONSUMO
      ln_saldodes   := 0;
      ln_porpago    := 0;
      ln_porcentaje := 100; --se pagara el 100% de la meta
      ln_saldodesT  := 0;
    
      ln_INDMORA := 0.5;

       
      --excedente cartera CONSUMO
      begin
        select (tp1nro1 / tp1nro2)
          into ln_excsal
          from fst198 f
         where tp1cod = 1
           and tp1cod1 = 10847
           and tp1corr1 = 13
           and tp1corr2 = 3;
      end;
    
      --excedente clientes CONSUMO
      begin
        select (tp1nro1 / tp1nro2)
          into ln_exccli
          from fst198 f
         where tp1cod = 1
           and tp1cod1 = 10847
           and tp1corr1 = 13
           and tp1corr2 = 4;
      end;
    
    end if;
  
    --retencion
    begin
      select tp1nro1, tp1nro2
        into ln_numret, ln_excret
        from fst198 f
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 14
         and tp1corr2 = 1;
    end;
  
     if ln_metsal = 0 or ln_metcli = 0 then
        ln_pagsal_tot := 0;
        ln_pagcli_tot := 0;
     else
       
          begin
            pq_cr_productividad_2016.sp_cr_pago_metas(pn_codcat => pn_codcat,
                                                      pc_tipase => pc_tipase,
                                                      pn_mtosal => ln_mtosal,
                                                      pn_mtocli => ln_mtocli,
                                                      pn_mtoret => ln_mtoret);
          end;
           
           --valida crecimiento cartera
           if ln_cresal >= ln_metsal then
              ln_pagsal := ln_mtosal ;
      
              --crecimiento supera el 100%
              ln_porcumsal := round(( ln_cresal *100 )/ ln_metsal ,2);
              if ln_porcumsal > 100 then
                  --aplicar porcentaje al excedente
                  ln_salexcedente := ln_cresal - ln_metsal;
                  ln_pagsal_adi := round(ln_salexcedente * ln_excsal/100,2);
               else
                 ln_pagsal_adi := 0;
                 ln_salexcedente := 0;    
               end if;
              
                --pago total saldo 
           
                if pc_tipase = 'P' then    
                --se aplica porcentaje desembolso al monto total ganado
                    ln_pagsal_tot :=  round((ln_pagsal + ln_pagsal_adi) * ln_porpago/100,2); 
                else --si es consumo no se aplica %desembolso
                   ln_pagsal_tot :=  round((ln_pagsal + ln_pagsal_adi),2); 
                end if;    

           else
             ln_pagsal_tot := 0;   
             ln_pagsal := 0;
             ln_pagsal_adi := 0;
             ln_porcumsal := 0;
             ln_salexcedente := 0;
             
           end if; 
      
           --valida crecimiento clientes
           if ln_crecli >= ln_metcli then
              ln_pagcli := ln_mtocli;
      
              --crecimiento supera el 100%
              ln_porcumcli := round(( ln_crecli * 100)/ ln_metcli,2);
              if ln_porcumcli > 100 then
              
                  --aplicar porcentaje al excedente
                  ln_cliexcedente := ln_crecli - ln_metcli;
                  ln_pagcli_adi := round(ln_cliexcedente * ln_exccli,2);
              else
                  ln_pagcli_adi := 0;
                  ln_cliexcedente := 0;
                     
              end if;
              
              --pago total clientes
              ln_pagcli_tot := ln_pagcli + ln_pagcli_adi;
              
               
           else
             ln_pagcli_tot := 0;   
             ln_pagcli := 0;
             ln_pagcli_adi := 0;
             ln_porcumcli := 0;
             ln_cliexcedente := 0;

             ln_totalpagovariable :=0;

           end if; 
         
         
           --SI TIENE CRECIMIENTO EN CLIENTE NO ES NECESARIO QUE SUPERE LA META se paga en retencion
             ln_retexcedente :=0;
             ln_pagret :=0;  
             ln_pagret_adi :=0;
             ln_pagret_tot :=0;
             ln_retenidos := 0;
             ln_porretencion := 0;
             ln_baseret := 0;    

             
           if ln_crecli > 0 then
           
                --SI TIENE CRECIMIENTO PUEDE COMISIONAR POR RETENCION
                if   pn_basret > 0 then
                  ln_baseret := pn_basret;
                  ln_retenidos := pn_numret; 
                  ln_porretencion :=  round(pn_numret * 100 / pn_basret, 2);              

                else
                      ln_porretencion := 0;    
                      ln_baseret := 0;
                      ln_retenidos := 0;
                end if;
                
                if ln_baseret > ln_numret then

                    if ln_porretencion >= ln_metret then
                       ln_pagret := ln_mtoret;
                       
                        --aplicar porcentaje al excedente
                        ln_retexcedente := ln_porretencion - ln_metret ;
                        if ln_retexcedente > 0 then
                            ln_pagret_adi := round(ln_retexcedente * ln_excret,2);
                        else
                             ln_pagret_adi := 0;
                        end if;
                       
                    else
                       ln_pagret := 0;
                       ln_pagret_adi := 0;
                       ln_retexcedente := 0;
                    end if;
                
                else
                     ln_pagret := 0;
                     ln_pagret_adi := 0;
                     ln_retenidos := nvl(ln_retenidos,0);
                     ln_porretencion := nvl(ln_porretencion,0);
                     ln_baseret := nvl(ln_baseret,0);
                end if;
               
               ln_pagret_tot := ln_pagret + ln_pagret_adi;
               ---
           else
             ln_retexcedente :=0;
             ln_pagret :=0;  
             ln_pagret_adi :=0;
             ln_pagret_tot :=0;
             ln_retenidos := 0;
             ln_porretencion := 0;
             ln_baseret := 0;    
             ln_excret := 0;    
      
           end if;

           
           ln_subpagovariable := ln_pagsal_tot + ln_pagcli_tot + ln_pagret_tot;
       
     end if;    
      ------- hasta aqui
      
          --calcular pago variable 
           ---obtiene MORA

           begin
            pq_cr_productividad_SIM.sp_cr_variacion_mora(pc_analista => lc_analista,
                                                          pd_fecpro => pd_fecpro,
                                                          pc_tipase => pc_tipase,
                                                          pn_pormor => ln_pormor,
                                                          pn_pormoa => ln_pormoa, --
                                                          pn_varmor => ln_varmor);--
          end;
       
          
           ---
           begin
              ln_mora := pq_cr_productividad_2016.fn_cr_metamora(pc_tipase => pc_tipase,
                                                                 pn_pormor => ln_pormoa, 
                                                                 pn_varmor => ln_varmor);
                                                                 --se envia la mora del mes anterior
           end;
           

           
           --aplica %mora a 
           if ln_mora = 100 then
              ln_pagmora := 0;
           else
              ln_pagmora := round(ln_subpagovariable * ( ln_mora - 100 )/100,2);
           end if;
           

           if pn_salrec > 0 then --si tuvo cartera recibida en el mes excluir de descuento por MORA
              if ln_pagmora < 0 then
                 ln_pagmora := 0;   
              end if;        
           end if;    


           ln_totalpagovariable := ln_subpagovariable + ln_pagmora;
           
          
           begin
             update JAQL600X j
                 set
                  JAQL600PMOAX = ln_pormoa,
                  jaql600pmrax = ln_pormor
              where j.JAQL600fproX = pd_fecpro
                and j.JAQL600usuX = lc_analista;
           exception when others then
                     null;     
           end;      
           commit;

           ln_cascontinuidad :=0;
           
           lc_cartera_rec := pq_cr_productividad_sim.fn_cr_cartera_recibida(lc_analista,pd_fecpro);
           
           ln_nummes := pq_cr_productividad_2016.fn_cr_contmes_anterior(lc_analista,pd_fecpro,pn_codage);

           lc_excluir_cont := 'N';  

           
            ln_incmor := 0;
            ln_pjcas := 0;
            ln_cascontinuidad :=0;
           
             
                -- 2017.10.04 aplica continuidad si no tuvo traslados o fue cambiado y cumple 3 meses 
                if lc_excluir_cont = 'N' then
                
                    
                     --valida continuidad se multiplica por negativo 
                     ln_incmor  :=  pq_cr_productividad_SIM.fn_cr_continuidad_mora(lc_analista,pd_fecpro);
                     
                     
                    if ln_incmor > ln_INDMORA then  -- si incrementa supera 1% en los 3 meses no se paga por incentivo variable (Cartera, Clientes y Retencion)
                     
                       
                         if ln_nummes < 3 or  lc_cartera_rec = 'S' then
                            lc_excluir_cont := 'S';
                         else
                            lc_excluir_cont := 'N';   
                         end if;

                         if lc_excluir_cont = 'N'   then
                        
                         
                              ln_pjcas := -100;
                              ln_cascontinuidad := (ln_totalpagovariable * ln_pjcas/100 );
                              ln_totalpagovariable := ln_totalpagovariable + ln_cascontinuidad;
                         
                         end if;   
                         
                     else
                        ln_pjcas := 0;
                        ln_cascontinuidad :=0;
                     end if;
                 
                end if; 
                 
            --
           
           --OBTIENE CONTENCION
           ln_TOTAL :=0;
           ln_pagocontencion:= 0;
           ln_codcam := 1; --contencion
           
           if pc_tipase = 'P' then
                 ln_basecon :=  pn_bascon;
                 ln_contenidos := pn_salcon;
                 ln_porcontencion  :=  round( ln_contenidos *100/ ln_basecon ,2);
                 
                 begin
                     ln_pagocontencion := pq_cr_productividad_2016.fn_cr_contencion(pn_basecon => pn_bascon,
                                                               pn_porcon => ln_porcontencion);
                 end;
           else
           --SI es CONVENIO no APLICA CONTENCION 2017.07.13
                 ln_basecon := 0;
                 ln_porcontencion := 0;  
                 ln_pagocontencion := 0; 
                 ln_codcam := 0; 
                 ln_contenidos := 0;
           end if;       
           
    
           ---APLICAR PORCENTAJE DE CASTIGO A 
           --TOTAL DE PAGO POR CARTERA, CLIENTES Y RETENCION
           ln_TOTAL := ln_totalpagovariable + ln_pagocontencion;
            
            update JAQL600x j
               set
                JAQL600PSALX = ln_pagsal_tot,
                JAQL600PCLIX = ln_pagcli_tot,
                JAQL600CSALX = ln_pagsal,
                JAQL600ESALX = ln_pagsal_adi,
                JAQL600CCLIX = ln_pagcli,
                JAQL600ECLIX = ln_pagcli_adi,
                JAQL600VMORX = ln_varmor,
                JAQL600PMORX = ln_pagmora,
                JAQL600POSAX = ln_porcumsal,
                JAQL600POCLX = ln_porcumcli,
                JAQL600EXSAX = ln_salexcedente,
                JAQL600EXCLX = ln_cliexcedente,
                JAQL600EXREX = ln_retexcedente,
                JAQL600PRETX = ln_pagret_tot,
                JAQL600CRETX = ln_pagret,
                JAQL600ERETX = ln_pagret_adi,
                JAQL600CCAMX = ln_codcam,
                --JAQL600VCAMX = ln_basecon,                
                JAQL600TCAMX = ln_pagocontencion,
                JAQL600PCAMX = ln_porcontencion,
                JAQL600AUX1X = ln_contenidos,
                JAQL600MTMRX = ln_mora,
                JAQL600PJCAX = ln_incmor, 
                JAQL600PJCASX = ln_pjcas,
                JAQL600PVARX = ln_totalpagovariable,
                --JAQL600BAREX = ln_baseret,
                --JAQL600MOREX = ln_retenidos,
                JAQL600POREX = ln_porretencion, 
                JAQL600PMOAX = ln_pormoa,
                JAQL600CMRAX = ln_cascontinuidad,
                JAQL600INCOX = lc_excluir_cont,
                JAQL600NMESX = ln_nummes,
                JAQL600PORDX = ln_porcentaje,
                JAQL600TOTPAx = ln_TOTAL, -- + CONTENCION
                jaql600agex = pn_codage,
                jaql600codcatx = pn_codcat,
                jaql600tasex = pc_tipase,
                jaql600sdox = pn_mtosdo,
                jaql600nclx = pn_numcli,
                jaql600sdmx = pn_salmor,
               -- jaql600pmrax = ln_pormor,
                jaql600sotox = pn_saloto,
                jaql600srecx = pn_salrec,
                jaql600cotox = pn_clioto,
                jaql600crecx = pn_clirec,
                jaql600sdcax = pn_salcas,
                jaql600sdjux = pn_saljud,
                jaql600cavex = pn_salven,
                jaql600clvex = pn_cliven,
                jaql600vcamx = pn_bascon,
                jaql600mconx = pn_salcon,
                jaql600barex = pn_basret,
                jaql600morex = pn_numret,
                jaql600mtodx = pn_destot,
                jaql600idesx = pn_depyme,
                
                JAQL600CRSAX = ln_cresal,
                JAQL600CRCLX = ln_crecli,
                
                jaql600cltotx = ln_clitot,
                jaql600sdtotx = ln_saltot, 
                jaql600neox  = lc_tipo_NEO,
     
                jaql600mtsax = ln_metsal,
                jaql600mtclx = ln_metcli,
                jaql600mtrex = ln_metret
                
            where j.JAQL600fprox = pd_fecpro
              and j.JAQL600usux = lc_analista;
        
              COMMIT;
              
  end loop;

exception when others then
    null;      
end sp_cr_simula;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --      


 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Function fn_cr_continuidad_mora(pc_analista IN varchar2,pd_fecpro in date ) return number is
    -- *****************************************************************
    -- Nombre                     : fn_cr_continuidad_mora
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvias
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : Evalua 3 meses consecutivos la mora y si el ratio se ha incrementado
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************


  lc_analista char(10); 
  ln_varmor number:= 0;
  ln_morini number:= 0;
  ln_mora   number:= 0;
  ln_moraFin number :=0;
  ln_moraIni number :=0;
  ld_fecfin date;
  
  begin
  
  --obtener mora de los 3 ultimos meses
  lc_analista := rpad(pc_analista, 10, ' ');--2016.02.08 obtiene codigo de analista

  
  for  x in 0..2 loop
      ln_morini := ln_mora;
      
      if x = 0 then
            ld_fecfin :=  pd_fecpro;
            
             begin
                  select j.JAQL600PMOAX ,j.JAQL600pmraX
                    into  ln_moraIni ,ln_moraFin
                    from JAQL600X j
                   where j.JAQL600fproX = ld_fecfin
                     and j.JAQL600usuX = lc_analista
                     and j.JAQL600codcatX <> 0; --2017.10.04
             exception when no_Data_found then
                 ln_moraFin := 0;
                 ln_moraIni := 0; 
                 ln_varmor := 0; 
                 exit;   --sino cumple 3 meses seguidosno hay continuidad        
             end;
            
      else
            ld_fecfin :=  last_day(add_months(trunc(pd_fecpro), -x));
            
             begin
                  select j.JAQL600PMOA ,j.jaql600pmra
                    into  ln_moraIni ,ln_moraFin
                    from jaql600 j
                   where j.jaql600fpro = ld_fecfin
                     and j.jaql600usu = lc_analista
                     and j.jaql600codcat <> 0; --2017.10.04
             exception when no_Data_found then
                 ln_moraFin := 0;
                 ln_moraIni := 0; 
                 ln_varmor := 0; 
                 exit;   --sino cumple 3 meses seguidosno hay continuidad        
             end;
            
      end if;
  
      
       
       ln_mora := ln_moraFin - ln_moraIni;
       --if x > 0 then
              ln_varmor := ln_varmor + ln_mora;
       --end if;
    
   end loop;
   
          
  return nvl(ln_varmor,0);  
   
end fn_cr_continuidad_mora;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 procedure sp_cr_bonoTrimestral( pd_fecpro in date, pc_analista in varchar2, pc_codage in number)  is
     -- *****************************************************************
    -- Nombre                     : sp_cr_bonoTrimestral
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.10.25
    -- Autor de Creación          : 
    -- Uso                        : OBTIENE BONO TRIMESTRAL POR CUMPLIMIENTO POR CARTERA, CLIENTES, RETENCION Y MORA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************

    cursor analistas(lc_analista char ) is
           select *
            from jaql600 j
           where j.jaql600fpro = pd_fecpro
             and j.jaql600usu like '%'||lc_analista||'%';
             --and j.jaql600usu in ('JDIAZC','RFLORES','OCRUZP' );



  ln_mto_cartera number :=0;
  ln_mto_clientes number :=0;
  ln_monto_mora number:=0;
  ln_pago number;
  ln_pagmor number :=0;
  ln_incmora number;

  ln_prom_sal number :=0;
  ln_prom_cli number :=0;
  lc_indicar char(1):='N';
  ln_sal number:= 0;
  ln_cli number:= 0;  
  ln_nummes number;
  ld_fecfin date;
  ln_mtosal  number;
  ln_mtocli  number;
  ln_minsal  number;
  ln_mincli  number;  
  ln_prominsal number :=0;
  ln_promincli number :=0;
  
  
  
lc_analista varchar2(10):= null;

begin

 if pc_analista is null then
    lc_analista := '%';
 else
    lc_analista := pc_analista;    
 end if;
 ln_nummes := to_number(to_char(pd_fecpro,'mm'));
 
 IF ln_nummes in (3,6,9,12
   , 1,2 --se agrego para pruebas 2019.06.06
   
   ) then -- pd_fecpro SI MES ES 3,6 ,9,12 PAGAR BONOT TRIMESTRAL.
 

    for i in analistas(lc_analista) loop
    
       if i.jaql600mtsa<>0 then
    
          lc_indicar :='N';
      
           ln_sal := 0;
           ln_cli := 0;
           
           for  x in 0..2 loop
             
              ld_fecfin :=  last_day(add_months(trunc(pd_fecpro), -x));
          
               --MODIFICAR VALIDANDO CRECIIENTOS
               if x = 0 then
                  
                  begin --2019.06.06
                        select JAQL600CRSAX,JAQL600CRCLX,JAQL600MTSAX,JAQL600MTCLX
                          into ln_mtosal,ln_mtocli,ln_minsal,ln_mincli
                          from JAQL600X j
                         where j.JAQL600fprox = ld_fecfin
                           and j.JAQL600usux = i.jaql600usu
                           and j.JAQL600codcatx <>0; 
                   exception 
                     when no_Data_found then
                       ln_mtosal := 0;
                       ln_mtocli := 0;
                       ln_minsal := 0;
                       ln_mincli := 0;
                     when others then
                       ln_mtosal := 0;
                       ln_mtocli := 0;
                       ln_minsal := 0;
                       ln_mincli := 0;               
                   end;
                   
               else
                   begin
                        select JAQL600CRSA,JAQL600CRCL,JAQL600MTSA,JAQL600MTCL
                          into ln_mtosal,ln_mtocli,ln_minsal,ln_mincli
                          from jaql600 j
                         where j.jaql600fpro = ld_fecfin
                           and j.jaql600usu = i.jaql600usu
                           and j.jaql600codcat <>0; --2017.10.04
                   exception 
                     when no_Data_found then
                       ln_mtosal := 0;
                       ln_mtocli := 0;
                       ln_minsal := 0;
                       ln_mincli := 0;
                     when others then
                       ln_mtosal := 0;
                       ln_mtocli := 0;
                       ln_minsal := 0;
                       ln_mincli := 0;               
                   end;
               
               end if;
               
               if (ln_mtosal - ln_minsal) >= 0 AND ln_mtosal > 0 then
                      ln_prom_sal := ln_prom_sal + ln_mtosal;
                      ln_prominsal := ln_prominsal + ln_minsal;
                      ln_sal := ln_sal + 1;
               end if;
               if (ln_mtocli - ln_mincli ) >= 0 AND  ln_mtocli > 0 then
                      ln_prom_cli := ln_prom_cli + ln_mtocli;
                      ln_promincli := ln_promincli + ln_mincli;
                      ln_cli := ln_cli + 1;                
               end if;
               
            
           end loop;
         
           if ln_sal = 3 then --cumplio 3 meses en cartera
            --comisiona
            --ln_prom_sal := round(ln_prom_sal/3,2);
            if ln_prominsal <> 0 then
               ln_prom_sal := round(ln_prom_sal/ln_prominsal,2)*100;
            else
               ln_prom_sal := 0;
            end if;   
               
              --bono cartera 
              begin
                SELECT JAQZ453MTO
                  into ln_mto_cartera
                  FROM JAQZ453 
                 WHERE ln_prom_sal >= JAQZ453MIN 
                   AND ln_prom_sal < JAQZ453MAX
                   AND JAQZ453CAT = i.jaql600codcat
                   AND JAQZ453TIP = 'S';
              exception when no_Data_found then
                 ln_mto_cartera := 0;            
              end;
            
           end if;
           
           if ln_cli = 3 then --cumplio 3 meses en clientes 
             --ln_prom_cli := round(ln_prom_cli/3,2);
             if ln_promincli <> 0 then
                   ln_prom_cli := round(ln_prom_cli/ln_promincli,2)*100;
             else
                   ln_prom_cli := 0;
             end if;
                   
              --bono clientes 
              begin
                SELECT JAQZ453MTO
                  into ln_mto_clientes
                  FROM JAQZ453 
                 WHERE ln_prom_cli >= JAQZ453MIN 
                   AND ln_prom_cli < JAQZ453MAX
                   AND JAQZ453CAT = i.jaql600codcat
                   AND JAQZ453TIP = 'C';
              exception when no_Data_found then
                 ln_mto_clientes := 0;            
              end;
           
            end if; 
            
            --ln_incmora := i.JAQL600PJCA;
            --valida continuidad se multiplica por negativo 
            ln_incmora  := /*(-1)**/ pq_cr_productividad_SIM.fn_cr_continuidad_mora(pc_analista/*i.jaql600usu*/,pd_fecpro);
              
            if  ln_incmora < 1 then --- puede comisionar
               case 
                   when ln_incmora > 0 and ln_incmora <= 0.9 then
                        ln_pagmor :=  50;
                   when ln_incmora = 0 then
                        ln_pagmor :=  100;   
                   when ln_incmora <=  -0.01  and ln_incmora >= -1 then
                        ln_pagmor :=  115;
                   when ln_incmora <= -1.01 then
                        ln_pagmor :=  130;              
                   else
                        ln_pagmor :=  0;              
               end case;
               ln_pago := (ln_mto_cartera + ln_mto_clientes)*ln_pagmor/100;
             else
               ln_pago := 0;
             end if;
              
              
             --ln_pago := ln_mto_cartera + ln_mto_clientes + ln_monto_mora;
             
              update JAQL600X j
                 set
                  JAQL600BSALX = ln_mto_cartera,
                  JAQL600BCLIX = ln_mto_clientes,
                  JAQL600BMRAX = ln_pagmor/100,
                  JAQL600BTRIX = ln_pago,
                  JAQL600TOTPAX = trim(JAQL600PVARX) + trim(JAQL600TCAMX) + ln_pago
              where j.JAQL600fproX = pd_fecpro
                and j.JAQL600usuX = i.jaql600usu;
              
      
            ln_pago := 0;
            ln_mto_cartera := 0;
            ln_mto_clientes := 0;
            ln_pagmor := 0;
            ln_incmora := 0;
            ln_monto_mora := 0;
            ln_prom_sal := 0;
            ln_prom_cli := 0;
            ln_prominsal :=0;
            ln_promincli :=0;            
            
        end if;  
        
     end loop;
  
     commit;
 
 END IF;
    
 end sp_cr_bonoTrimestral;
 
 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_cartera_recibida( pc_analista IN char, pd_fecpro IN date) return char is
    -- *****************************************************************
    -- Nombre                     : fn_cr_cartera_recibida
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : Verificar 2 meses hacia atras, debe excluir continuidad.
    -- Estado                     : 
    -- Acceso                     : 
    -- Parámetros de Entrada      : 
    --                              
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************


lc_analista char(10);


lc_indicador char(1):= 'N';
ld_fecant date;

begin

     lc_analista := rpad(pc_analista, 10, ' ');

     begin
          select 'S'
           into lc_indicador 
           from JAQL600X j
          where j.JAQL600fprox = pd_fecpro
            and j.JAQL600usux = lc_analista
            and j.JAQL600srecx > 0;
    exception when no_data_found then
        lc_indicador := 'N';
    end;


    ld_fecant := pd_fecpro;
    
    if lc_indicador = 'N' then  --si no hubo traslado cartera recibida, verificar si mes anterior si hubo traslado

       for x in 1..2 loop 
       
          ld_fecant := add_months(last_day(ld_fecant),-1);
           
           
          begin
                select 'S'
                 into lc_indicador 
                 from jaql600 j
                where j.jaql600fpro = ld_fecant
                  and j.jaql600usu = lc_analista
                  and j.jaql600srec > 0;
          exception when no_data_found then
              lc_indicador := 'N';
          end;
          
          if lc_indicador = 'S' then
             exit;
          end if;
          
      end loop;  
    
    end if;
    
    return lc_indicador; --si retorna S no aplicar continuidad

 end fn_cr_cartera_recibida;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_variacion_mora  ( pc_analista IN char, pd_fecpro IN date, pc_tipase in char, pn_pormor IN number , pn_pormoa out number, pn_varmor out number  ) is
    -- *****************************************************************
    -- Nombre                     : fn_cr_mora_mesanterior
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.06.20
    -- Autor de Creación          : 
    -- Uso                        : Retorna Mora del Mes anterior o Menor Mora entre Rango de Meses
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_Usuario: codigo de asesor,
    --                              P_IN_Fecha: fecha proceso
    -- Parámetros de Salida       : Porcentaje de Mora
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    ln_pormoa jaql600.jaql600pmra%type;     
    ld_fecfin date;
    ln_varmor number;
    lc_analista char(10);
    
  begin

     lc_analista := rpad(pc_analista, 10, ' ');

    
    select last_day(add_months(trunc(pd_fecpro), -1))
      into ld_fecfin
      from dual;

     
     --obtiene mora del mes anterior
     ---calcular nuevamente mora con castigos del ultimo mes, sin corporativos, con RL - CARTERA BRUTA
        
        
        ln_pormoa := pq_cr_productividad_SIM.fn_cr_nuevamora_anterior(pc_analista => lc_analista,
                                                                       pd_fecpro => ld_fecfin,
                                                                       pd_fechoy => pd_fecpro);

    if nvl(ln_pormoa,0) = 0 then --si no tiene mora el mes anterior variacion es la mora actual
       ln_varmor := nvl(pn_pormor,0);
    else
      --Determinar variacion de mora
        if pc_tipase = 'C' then
            
            ln_varmor :=  nvl(pn_pormor,0)- nvl(ln_pormoa,0);
        else
            if  ln_pormoa/*pn_pormor*/ > 5 then --Se evalua en base a la mora Inicial o del mes anterior
                ln_varmor := round( ((nvl(pn_pormor,0) / nvl(ln_pormoa,0) ) - 1)*100,2);
            else
                ln_varmor :=  nvl(pn_pormor,0)- nvl(ln_pormoa,0);
            end if;
            
        end if;    
    end if;  
    pn_varmor := ln_varmor;
    pn_pormoa := ln_pormoa;
          
  end sp_cr_variacion_mora;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Function fn_cr_nuevamora_anterior(pc_analista IN varchar2,pd_fecpro in date,pd_fechoy in date) return number is
    -- *****************************************************************
    -- Nombre                     : fn_cr_nuevamora_anterior
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2019.06.10
    -- Autor de Creación          : 
    -- Uso                        : Devuelve el tipo de analista
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : tipo Analista: Convenio Pyme
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

  ln_pormor number := 0; 
  ln_saljud number := 0;
  ln_nummes number := 0;
  ln_cont number := 0;
  ln_saldo number := 0; 
  ln_salmor number:= 0;      
  ln_dias number:=365;
  ln_salrec number := 0;
  ln_nuevamora number:= 0;
  ln_monto number:=0;
  ln_cliant number:=0;
  ln_codage number:=0;
  lc_analista char(10);
  ln_saltoT number := 0; 
  ln_salmorT number := 0; 
  ln_ageact number := 0; 
  ld_fecact date;
  
  begin
  
    --obtener mora de los 3 ultimos meses
   lc_analista := rpad(pc_analista, 10, ' ');--2016.02.08 obtiene codigo de analista

    

    Begin
      select jaql600age
        into ln_codage
        from jaql600
       where jaql600usu = lc_analista--pc_analista
         and jaql600fpro = pd_fecpro;
    exception
      when others then
        ln_codage := 0;
   end;

     
      
         --Obtener saldo de traslado al cierre de mes anterior ln_saltot, ln_salmorT
         begin
           pq_cr_productividad_2016.sp_cr_saldostraslados(lc_analista, pd_fecpro,ln_saltoT, ln_salmorT);
         end;
                                                           
    
         ld_fecact := pd_fechoy; --add_months( pd_fecpro, 1); 2018.01.12
      
        --agencia actual
        begin
             select jaql600agex 
              into ln_ageact
             from jaql600x 
             where jaql600fprox = ld_fecact
               and jaql600usux = lc_analista;
        exception when no_Data_found then       
            ln_ageact := 0;
        end;
        ---   
        if ln_ageact =  ln_codage then    
            
            ln_saljud := pq_cr_productividad_2016.fn_cr_sal_judicial(lc_analista,pd_fecpro,ln_codage);    
            --no considerar castigos del mes 2016.11.24
            ln_salmor := pq_cr_productividad_2016.fn_pa_saldo_mora(lc_analista,pd_fecpro,ln_codage );
                      
            begin
        
              pq_cr_productividad_2016.sp_cr_nuevosaldo_anterior(pc_analista => lc_analista,
                                                                 pd_fecpro => pd_fecpro,
                                                                 pc_codage => ln_codage,
                                                                 pn_salant => ln_saldo,
                                                                 pn_cliant => ln_cliant);
            end;
        else
            ln_saldo := 0;
            ln_cliant := 0;
            ln_saljud := 0;
            ln_salmor := 0;
        end if;
                
         ---calcular mora 
        if (ln_saldo + ln_saljud + ln_salmorT + ln_saltoT) > 0 then
              ln_pormor := round( (ln_salmor  + ln_saljud  + ln_salmorT) / (ln_saldo  + ln_saltoT ) * 100,2);
                --no suma ln_saljud porque en ln_saldo ya esta incluido el saldo judicial
        else
              ln_pormor := 0;
        end if; 
      
  return nvl(ln_pormor,0);  
   
end fn_cr_nuevamora_anterior;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 ----------------------------------
end PQ_CR_PRODUCTIVIDAD_SIM;
/

