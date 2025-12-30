create or replace package PQ_CR_FACTORAJUSTE is

  -- *****************************************************************
  -- Nombre                     : PQ_CR_FACTORAJUSTE
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Creditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2024.02.23
  -- Autor de Creación          : YYAMPI
  -- Uso                        : Rutina de calculo de factor de ajuste
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : 
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 04/12/2024 YYAMPI se agrego el sp_cr_factor_ajuste    
  --                              28/01/2025 YYAMPI se modifico el procedimiento sp_cr_factor_ajuste   
  --                              26/08/2025 YYAMPI se modifico el procedimiento sp_cr_factor_ajuste        
  --                              02/10/2025 YYAMPI se modifico el procedimiento sp_cr_factor_ajuste 
  --                              11/12/2025 YYAMPI se modifico el procedimiento sp_cr_factor_ajuste (segmetacion pyme)        
  -- *****************************************************************
  -------------------------------------------------------------------------  

  PROCEDURE SP_CR_FACTOR_AJUSTE(pd_fecpro    in date,
                                pn_pgpais    in number,
                                pn_tipdoc    in number,
                                pc_numdoc    in char,
                                pn_modulo    in number,
                                pn_tipope    in number,
                                pn_instancia in number,
                                pn_monto     in number,
                                pn_result    out number);

  -------------------------------------------------------------------------  

  PROCEDURE SP_CR_FACTOR_SCORE(pd_fecpro in date,
                               pn_pgpais in number,
                               pn_tipdoc in number,
                               pc_numdoc in char,
                               pn_modulo in number,
                               pn_tipope in number,
                               pn_result out number);

-------------------------------------------------------------------------                              

end PQ_CR_FACTORAJUSTE;
/
create or replace package body PQ_CR_FACTORAJUSTE is

  ----------------------------------------------------------------------------------------------------------
  PROCEDURE SP_CR_FACTOR_AJUSTE(pd_fecpro    in date,
                                pn_pgpais    in number,
                                pn_tipdoc    in number,
                                pc_numdoc    in char,
                                pn_modulo    in number,
                                pn_tipope    in number,
                                pn_instancia in number,
                                pn_monto     in number,
                                pn_result    out number) is
  
    -- *****************************************************************
    -- Nombre                     : SP_CR_FACTOR_AJUSTE
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.12.04
    -- Autor de Creación          : YYAMPI
    -- Uso                        : RETORNA VALOR FACTOR DE AJUSTE 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pd_fecpro ( FECHA DE PROCESO )
    --                            : pn_pgpais ( PAIS CLIENTE )
    --                            : pn_tipdoc ( TIPO DE DOCUMENTO  )
    --                            : pc_numdoc ( NUMERO DE DOCUMENTO )
    --                            : pn_modulo ( MODULO )
    --                            : pn_tipope ( TIPO DE OPERACION )
    --                            : pn_instancia ( INSTANCIA )
    --                            : pn_monto ( MONTO )
    --
    -- Parámetros de Salida       : pn_result ( FACTOR RESULTADO)
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 2025.01.28 yyampi se agrego letras para la campaña de convenios
    --                              2025.08.26 yyampi se agrego un ajuste del factor de seguro de desgravamen  
    --                              2025.10.02 yyampi se agrego un ajuste del factor de consumo  
    --                              2025.12.11 yyampi se agrego un ajuste de segmentacion pyme en linea
    -- *****************************************************************
    lc_score      varchar2(15);
    ln_probal     number;
    lc_SegmRiesgo varchar2(15);
    ln_PDCal      number;
    lc_tabla      varchar2(15);
    ld_fchscore   date;
    lc_scoreabr   varchar2(15) := 'AJUSTE';
    lc_NewScore   varchar2(30);
    ln_inaneg     number(10) := 0; -- indicador antiguedad de negocio
    ln_resultm    number(10) := 0; --valor antiguedad de negocio meses 
    lv_indfacneg  varchar2(30) := ''; --indicador letra de factor de ajuste de antiguedad de negocio
    lv_indfacneg2 varchar2(5) := '';
    ln_montoaju   number(17, 6) := 0; --valor de monto  
    ln_nroconv    number(10) := 0; -- 2025.01.28 yyampi 
    ln_inconv     number(10) := 0; --indicador de convenio 
    ln_facconv    varchar(10) := 0; --factor de de convenio letra 
    ln_inddesg    number(10) :=0;  --indicador de seguro desgravamen --22/08/2025
    ln_facdesg    varchar(30) := '';  --factor de seguro desgravamen  --22/08/2025
    ln_montdesg   number(17, 2) := 0; --valor de monto desgravamen  --22/08/2025
    ln_resultdesg number(10,6) :=0; --porcentaje desgravamen --22/08/2025
    ln_result number(10,6) :=0;  --porcentaje final 22/08/2025
    ln_indcons    number(10) :=0;  --indicador de consumo --2/10/2025
    lv_faccons    varchar(30) := '';  --factor de consumo  --2/10/2025
    ln_montcons   number(17, 2) := 0; --valor de monto consumo  --2/10/2025
    ln_resultcons number(10,6) :=0; --porcentaje consumo --2/10/2025
    ln_geog number(3):=0;  --geografia --11/12/2025
    ln_calif number(5) := 0; --segmentacion en linea --11/12/2025
    ln_resultgeog number(17,6) :=0;  --porcentaje geografico --11/12/2025
    ln_resultzona number(17,6) :=0;  --porcentage de solo zona --11/12/2025 
    ln_indzonageo number :=0;   --porcentage de solo zona --11/12/2025    
  begin
  
    /* 1. Verifica si el credito es de tipo convenio*/
    begin
      PQ_CR_CONVENIOESSALUD.sp_cr_nroconvenio(ln_instancia => pn_instancia,
                                              ln_nroconv   => ln_nroconv);
      if nvl(ln_nroconv, 0) > 0 then
        ln_inconv := 1; --es de tipo convenio
      end if;
    
    exception
      when others then
        ln_nroconv := null;
        ln_inconv  := 0;
    end;
  
    if ln_inconv = 1 then
      --convenio 
    
      /* Se busca el codigo de factor referente al convenio en la guia */
      begin
        select trim(t.tp1desc)
          into ln_facconv
          from fst198 t
         where t.tp1cod = 1
           and t.tp1cod1 = 11162
           and t.tp1corr1 = 902
           and t.tp1corr2 = ln_nroconv;
      exception
        when others then
          ln_facconv := '';
      end;
    
      --obteniendo el porcentaje
      begin
        select a.aqpb282por
          into ln_result --pn_result
          from AQPB282 a
         where a.aqpb282mod = pn_modulo
           and a.aqpb282top = pn_tipope
           and a.aqpb282sco = ln_facconv
           and a.aqpb282tip = 'S'
           and a.aqpb282est = 'S';
      exception
        when others then
          ln_result := 0.000;
      end;
    
    else
      /* 2. Se verifica el caso por el modulo y tipo de operacion, en caso que exista se toma los casos de antiguedad de negocio */
      begin
        select count(1)
          into ln_inaneg
          from fst198 t
         where t.tp1cod = 1
           and t.tp1cod1 = 11162
           and t.tp1corr1 = 901
           and t.tp1corr2 = pn_modulo
           and t.tp1corr3 = pn_tipope;
      exception
        when others then
          ln_inaneg := 0;
      end;
      -------------------------------------------------------  
    
      /*caso normal */
      if ln_inaneg = 0 then
        --obteniendo score de riesgos
        begin
          PQ_CR_SCORE_RCC.sp_cr_scoreDNI_II(ln_inst       => 0, -- VE - Nro de Instancia, si no hay, enviar 0
                                            ln_tdoc       => pn_tipdoc, -- VE - tipo de documento
                                            lc_ndoc       => trim(pc_numdoc),--pc_numdoc, -- VE - nro de documento
                                            lc_prgm       => 'TARIFARIO', -- VE - Nombre del Programa para identificarlo en la tabla log AQPB166
                                            lc_user       => 'TASA', -- VE - Usuario
                                            lc_score      => lc_score, -- VS - Score Riesgo F
                                            ln_probal     => ln_probal, -- VS - Probabilidad
                                            lc_SegmRiesgo => lc_SegmRiesgo, -- VS - Segmentacion Riesgo
                                            ln_PDCal      => ln_PDCal, -- VS - PD
                                            lc_tabla      => lc_tabla, -- VS - Tabla Score JAQL640 o JAQL639
                                            ld_fchscore   => ld_fchscore, -- VS - Fecha del Score
                                            lc_scoreabr   => lc_scoreabr, -- VS - Score Abreviado F
                                            lc_NewScore   => lc_NewScore); -- VS - Nuevo Score MEMO16 POTENCIAL
        end;
      
        lc_scoreabr := nvl(lc_scoreabr, 0);
      
        --obteniendo el porcentaje
        begin
          select a.aqpb282por
            into ln_result
            from AQPB282 a
           where a.aqpb282mod = pn_modulo
             and a.aqpb282top = pn_tipope
             and a.aqpb282sco = lc_scoreabr
             and a.aqpb282tip = 'S'
             and a.aqpb282est = 'S';
        exception
          when others then
            ln_result := 0.000;
        end;
      
        /*casos de antiguedad de negocio */
      else
        /*llamar al calculo de antiguedad de negocio en meses */
        begin
          -- Call the procedure
          pq_cr_evapoliticas.sp_ANTIGNEGOCIO(ln_pepais => pn_pgpais,
                                             ln_petdoc => pn_tipdoc,
                                             lc_ndoc   => pc_numdoc,
                                             ln_result => ln_resultm);
        end;
      
        begin
          /*obtener la letra de factor ajuste antiguedad negocio */
          select t.tp1desc
            into lv_indfacneg
            from fst198 t
           where t.tp1cod = 1
             and t.tp1cod1 = 11162
             and t.tp1corr1 = 900
             and t.tp1corr2 = 1
             and t.tp1corr3 > 0
             and ln_resultm between t.tp1nro1 and t.tp1nro2;
        exception
          when others then
            ln_resultm   := 0;
            lv_indfacneg := 0;
        end;
      
        --obteniendo el monto 
        begin
        
          lv_indfacneg2 := trim(lv_indfacneg);
        
          select min(a.aqpb282mto)
            into ln_montoaju
            from AQPB282 a
           where a.aqpb282mod = pn_modulo
             and a.aqpb282top = pn_tipope
             and a.aqpb282sco = lv_indfacneg2
             and a.aqpb282tip = 'S'
             and a.aqpb282est = 'S'
             and a.aqpb282mto is not null
             and a.aqpb282mto >= pn_monto;
        
        exception
          when others then
            --DBMS_OUTPUT.put_line(SQLERRM);
            ln_montoaju := 0;
        end;
      
        --obteniendo el porcentaje
        begin
        
          lv_indfacneg2 := trim(lv_indfacneg);
          select a.aqpb282por
            into ln_result
            from AQPB282 a
           where a.aqpb282mod = pn_modulo
             and a.aqpb282top = pn_tipope
             and a.aqpb282sco = lv_indfacneg2
             and a.aqpb282mto = ln_montoaju
             and a.aqpb282tip = 'S'
             and a.aqpb282est = 'S';
        exception
          when others then
            ln_result := 0.000;
        end;
      
      end if; --antiguedad negocio
    
    end if; --convenio
    
    
    /*cambio yyampi 22/08/2025:  adicionalmente se debe considerar el calculo de seguro desgravamen*/
    
    /*tiene seguro desgravamen registrado no checkeado */
    begin 
         select count(*) INTO ln_inddesg 
          from JAQM8F t
         where t.jaqm8fins = pn_instancia
           and t.jaqm8ftip = 'DESGRAVAMEN'
           and t.jaqm8fval = 'N';
           
    exception when others then 
          ln_inddesg := 0;   
    end;
    
    if ln_inddesg > 0 then --si no tiene seg desgravamen registrado no chekeado
      
        begin 
          select min(a.aqpb282mto)
              into ln_montdesg
              from AQPB282 a
             where a.aqpb282mod = pn_modulo
               and a.aqpb282top = pn_tipope
               and a.aqpb282sco = 'NDSG'
               and a.aqpb282tip = 'S'
               and a.aqpb282est = 'S'
               and a.aqpb282mto is not null
               and a.aqpb282mto >= pn_monto;
               
          exception when others then 
            ln_montdesg :=0;
           end;
        
        /*calculo de factor de desgravamen*/
           
          begin
          
           /*obtiene porcentaje de desgravamen*/
            select a.aqpb282por
              into ln_resultdesg
              from AQPB282 a
             where a.aqpb282mod = pn_modulo
               and a.aqpb282top = pn_tipope
               and a.aqpb282sco = 'NDSG'
               and a.aqpb282mto = ln_montdesg
               and a.aqpb282tip = 'S'
               and a.aqpb282est = 'S';
          exception
            when others then
              ln_resultdesg := 0.000;
          end;    
           
    
    end if;   
    
    /*cambio yyampi 2/10/2025:  adicionalmente se debe considerar el calculo de factor consumo/
    /*verfica si tiene ajuste de consumo */
    begin 
         select t.JAQM8FAN1 INTO ln_indcons
          from JAQM8F t
         where t.jaqm8fins = pn_instancia
           and t.jaqm8ftip = 'TASACONSUMO '
           and t.jaqm8fval = 'S';
           
    exception when others then 
          ln_indcons := 0;   
    end;
    
    
      
    if ln_indcons > 0 then -- indicador de consumo 
      
        /*Se consulta la letra factor consumo */
        begin 
                 
            select trim(t.tp1desc)
              into lv_faccons ----------------------------
              from fst198 t
             where t.tp1cod = 1
               and t.tp1cod1 = 11162
               and t.tp1corr1 = 903 
               and t.tp1corr2 = ln_indcons ; 
        
          exception when others then 
            lv_faccons := '';
        end ;
      
        begin 
          select min(a.aqpb282mto)
              into ln_montcons
              from AQPB282 a
             where a.aqpb282mod = pn_modulo
               and a.aqpb282top = pn_tipope
               and a.aqpb282sco = lv_faccons --'NDSG'
               and a.aqpb282tip = 'S'
               and a.aqpb282est = 'S'
               and a.aqpb282mto is not null
               and a.aqpb282mto >= pn_monto;
               
          exception when others then 
            dbms_output.put_line(sqlcode||' '||sqlerrm); 
            ln_montcons :=0;
           end;
        
        /*calculo de factor de consumo*/
           
          begin
          
           /*obtiene porcentaje de consunmo*/
            select a.aqpb282por
              into ln_resultcons
              from AQPB282 a
             where a.aqpb282mod = pn_modulo
               and a.aqpb282top = pn_tipope
               and a.aqpb282sco = lv_faccons --'NDSG'
               and a.aqpb282mto = ln_montcons
               and a.aqpb282tip = 'S'
               and a.aqpb282est = 'S';
          exception
            when others then
              ln_resultcons := 0.000;
          end;    
           
    
    end if;  
    
    
    /*Se agrego el ajuste de pyme con la segmentacion en linea*/  --yyampi 11/12/2025
    
     
    /*se verifica si tiene solo zona (inclusivos, etc.)*/
    begin 
      
         select t.aqpb282por into ln_resultzona --ln_geog
           from sng001 a, fst811 b, fst198 c , AQPB282 t 
          where a.sng001inst = 13473044 --pn_instancia
            and a.sng001age = b.oficod
            and c.tp1cod = 1
            and c.tp1cod1 = 11162
            and c.tp1corr1 = 904
            and c.tp1corr2 = b.regcod
            and b.pgcod = 1
            and trim(t.aqpb282sco) = trim(c.tp1desc)  
            and t.aqpb282mod = pn_modulo
            and t.aqpb282top = pn_tipope
            and t.aqpb282est = 'S'
            and t.aqpb282est = 'S'            
            and rownum = 1 ; 
    
          ln_indzonageo := 1;
    
    exception when others then       
         ln_indzonageo := 0;
    end;
    
    
    if ln_indzonageo = 1 then    -- zona y geografico       
            ln_resultgeog := ln_resultzona;    
    else 
       
        /*Se obtiene el codigo geografico*/        
        begin
          
             select b.regcod into ln_geog
               from sng001 a, fst811 b, fst198 c
              where a.sng001inst = pn_instancia
                and a.sng001age = b.oficod
                and c.tp1cod = 1
                and c.tp1cod1 = 11162
                and c.tp1corr1 = 904
                and c.tp1corr2 = b.regcod
                and b.pgcod = 1
                and rownum = 1 ;            
            
        exception when others then      
           ln_geog := 0;        
        end; 
        
        
        /*Se obtiene la segementacion en linea pyme*/
        
        begin
         pq_cr_ejec_segm_mens_nuev22_Y.sp_ejecutar_segm_mensual(nrodesdinicproceso => 1, --1                                 
                                                             auxfecproceso      => pd_fecpro, --'15/04/2025',
                                                             pn_limite          => 0, --por defecto                             
                                                             pc_ubuser          => 'TARIFA',
                                                             njobs              => 200,
                                                             P_PAIS_Y           => pn_pgpais,
                                                             P_TDOC_Y           => pn_tipdoc,
                                                             P_NDOC_Y           => pc_numdoc,
                                                             P_INSTANCIA        => pn_instancia);
         end;
        
        /*Se toma la segmentacion en linea*/
        begin 
          SELECT t.aqpd784calf into ln_calif
            FROM AQPD784 t
           where t.aqpd784paic = pn_pgpais
             and t.aqpd784tdoc = pn_tipdoc
             and t.aqpd784tndoc = pc_numdoc
             and t.aqpd784fecp = pd_fecpro ;
            
         exception when others then 
            ln_calif :=0 ;
         end;
        
        /*Se consulta en la tabla parametrica de parametros geograficos */
        begin 
          select t.aqpe151porc into ln_resultgeog
            from AQPE151 t
           where t.aqpe151geog = ln_geog
             and t.aqpe151csegm = ln_calif
             and t.aqpe151est = 'S'
             and t.aqpe151tipo = 'PYME'
             and t.aqpe151mod = pn_modulo;
          
        exception when others then
            ln_resultgeog :=0;
        end;
    end if; --termina zona y geografico 
    
    /*se adiciona el porcentaje(score o convenio o antigüedad) + porcentaje desgravamen  + porcentaje consumo  + porcentage geografico*/
    pn_result := nvl(ln_result,0) + nvl(ln_resultdesg,0) + nvl(ln_resultcons,0) + nvl(ln_resultgeog,0);
    
    /*Se guarda log*/
    begin 
       /* delete from AQPE152 T
         WHERE T.AQPE152FECH = pd_fecpro
           AND T.AQPE152PAIS = pn_pgpais
           AND T.AQPE152TIPD = pn_tipdoc
           AND T.AQPE152NUMD = pc_numdoc
           AND T.AQPE152MODU = pn_modulo
           AND T.AQPE152TIPO = pn_tipope
           AND T.AQPE152INST = pn_instancia
           AND T.AQPE152MTO = pn_monto;*/
                    
           
           insert into AQPE152
              (AQPE152FECH,
               AQPE152HORA,
               AQPE152PAIS,
               AQPE152TIPD,
               AQPE152NUMD,
               AQPE152MODU,
               AQPE152TIPO,
               AQPE152INST,
               AQPE152MTO,
               AQPE152RESP1,
               AQPE152RESP2,
               AQPE152RESP3,
               AQPE152RESP4,               
               AQPE152TXT1,
               AQPE152TXT2,
               AQPE152TXT3,
               AQPE152TXT4
               )
            values
              (pd_fecpro,
               TO_CHAR(SYSDATE, 'HH24:MI:SS'),
               pn_pgpais,
               pn_tipdoc,
               pc_numdoc,
               pn_modulo,
               pn_tipope,
               pn_instancia,
               pn_monto,
               ln_result,
               ln_resultdesg,
               ln_resultcons,
               ln_resultgeog,               
               lc_scoreabr, --score
               'NDSG',  --DESGRAVAMEN
               lv_faccons, -- CONSUMO
               ln_geog||'/'||ln_calif  -- GEOGRAFICO
               );
          
         commit; 
      exception when others then
        null; 
    end;
        
    
  exception
    when others then
      pn_result := 0.000;
    
  end SP_CR_FACTOR_AJUSTE;

  ----------------------------------------------------------------------------------------- 

  PROCEDURE SP_CR_FACTOR_SCORE(pd_fecpro in date,
                               pn_pgpais in number,
                               pn_tipdoc in number,
                               pc_numdoc in char,
                               pn_modulo in number,
                               pn_tipope in number,
                               pn_result out number) is
  
    -- *****************************************************************
    -- Nombre                     : SP_CR_FACTOR_SCORE
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.02.23
    -- Autor de Creación          : YYAMPI
    -- Uso                        : RETORNA VALOR FACTOR DE AJUSTE SCORE
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pd_fecpro ( FECHA DE PROCESO )
    --                            : pn_pgpais ( PAIS CLIENTE )
    --                            : pn_tipdoc ( TIPO DE DOCUMENTO  )
    --                            : pc_numdoc ( NUMERO DE DOCUMENTO )
    --                            : pn_modulo ( MODULO )
    --                            : pn_tipope ( TIPO DE OPERACION )
    --
    -- Parámetros de Salida       : pn_result ( FACTOR RESULTADO)
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************
    lc_score      varchar2(15);
    ln_probal     number;
    lc_SegmRiesgo varchar2(15);
    ln_PDCal      number;
    lc_tabla      varchar2(15);
    ld_fchscore   date;
    lc_scoreabr   varchar2(15);
    lc_NewScore   varchar2(30);
  
  begin
  
    --obteniendo score de riesgos
    begin
      PQ_CR_SCORE_RCC.sp_cr_scoreDNI_II(ln_inst       => 0, -- VE - Nro de Instancia, si no hay, enviar 0
                                        ln_tdoc       => pn_tipdoc, -- VE - tipo de documento
                                        lc_ndoc       => pc_numdoc, -- VE - nro de documento
                                        lc_prgm       => 'TARIFARIO', -- VE - Nombre del Programa para identificarlo en la tabla log AQPB166
                                        lc_user       => 'TASA', -- VE - Usuario
                                        lc_score      => lc_score, -- VS - Score Riesgo F
                                        ln_probal     => ln_probal, -- VS - Probabilidad
                                        lc_SegmRiesgo => lc_SegmRiesgo, -- VS - Segmentacion Riesgo
                                        ln_PDCal      => ln_PDCal, -- VS - PD
                                        lc_tabla      => lc_tabla, -- VS - Tabla Score JAQL640 o JAQL639
                                        ld_fchscore   => ld_fchscore, -- VS - Fecha del Score
                                        lc_scoreabr   => lc_scoreabr, -- VS - Score Abreviado F
                                        lc_NewScore   => lc_NewScore); -- VS - Nuevo Score MEMO16 POTENCIAL
    end;
  
    lc_scoreabr := nvl(lc_scoreabr, 0);
  
    --obteniendo el porcentaje
    begin
      select a.aqpb282por
        into pn_result
        from AQPB282 a
       where a.aqpb282mod = pn_modulo
         and a.aqpb282top = pn_tipope
         and a.aqpb282sco = lc_scoreabr
         and a.aqpb282tip = 'S'
         and a.aqpb282est = 'S';
    exception
      when others then
        pn_result := 0.000;
    end;
  
  exception
    when others then
      pn_result := 0.000;
    
  end SP_CR_FACTOR_SCORE;

----------------------------------------------------------------------------------------- 
end PQ_CR_FACTORAJUSTE;
/
