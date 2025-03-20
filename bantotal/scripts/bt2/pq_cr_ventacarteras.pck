create or replace package "PQ_CR_VENTACARTERAS" is
  -- Author  : KVALENCIAC
  -- Created : 30/06/2022
  -- Purpose : Programa de Venta de Cartera
  -- Modificado  : KVALENCIAC
  -- Fecha Modificación : 08/09/2022 KVALENCIAC
  -- Purpose : Se adicio¿no hint y solución de algunas observaciones
  -- Modificado  : KVALENCIAC
  -- Fecha Modificación : 18/07/2023 KVALENCIAC
  -- Purpose : Se adicionó para que no se elimine todo la cabecera
  -- Modificado  : KVALENCIAC
  -- Fecha Modificación : 25/08/2023 KVALENCIAC
  -- Purpose : Se modificó para que se grabe el codigo tipo de rango  de recaudo en el jaqy952
  -- Modificado  : KVALENCIAC
  -- Fecha Modificación : 26/12/2024 KVALENCIAC
  -- Purpose : Se modificó para qeu controle si el crédito se imprimio constancia o CNA 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_bloqueo(vn_ubuser varchar2);
  
  procedure sp_desbloqueo(vn_ubuser varchar2); 
  
  procedure sp_CreaJAQZ509(vn_ubuser varchar2,
                           vn_nropro number); --P2-01_Indicaciones 
  
  procedure sp_ObtienePagos(FECHA_FIN date); --P2-02_Ejecuta_proceso_ObtienePagos  
  
  procedure sp_antesventa(vn_ubuser varchar2, FECHA_FIN date, pn_nropro number); --llama a los procesos P2_01 y P2_02 
      
  procedure sp_saldos_venta( lc_IND char ); --------------> lc_IND: Colocar "A" si se ejecuta antes de la venta o "D" si se ejecuta despues venta                     
  
  procedure sp_estaenventa(pd_fecha in date,
                           pn_cod  in number,
                           pn_mod  in number,
                           pn_suc  in number,
                           pn_mda  in number,
                           pn_pap  in number,
                           pn_cta  in number,
                           pn_ope  in number,
                           pn_sbo  in number,
                           pn_top  in number,
                           pn_flag out number);
                            
  procedure sp_validaciones(pd_fecha in date,
                            pn_cod  in number,
                            pn_mod  in number,
                            pn_suc  in number,
                            pn_mda  in number,
                            pn_pap  in number,
                            pn_cta  in number,
                            pn_ope  in number,
                            pn_sbo  in number,
                            pn_top  in number,
                            pc_user in char,
                            pn_Indicador out number); 
                            
  procedure sp_insertaAQPB749L(pd_fecha in date,
                               pc_user in char,
                               pn_cod  in number,
                               pn_mod  in number,
                               pn_suc  in number,
                               pn_mda  in number,
                               pn_pap  in number,
                               pn_cta  in number,
                               pn_ope  in number,
                               pn_sbo  in number,
                               pn_top  in number,
                               pc_mensaje in varchar); 
                                      
  function fn_TieneSaldo(pn_cod  in number,
                         pn_mod  in number,
                         pn_suc  in number,
                         pn_mda  in number,
                         pn_pap  in number,
                         pn_cta  in number,
                         pn_ope  in number,
                         pn_sbo  in number,
                         pn_top  in number) return number;
                          
  function fn_TieneAcuerdo(pn_cod  in number,
                           pn_mod  in number,
                           pn_suc  in number,
                           pn_mda  in number,
                           pn_pap  in number,
                           pn_cta  in number,
                           pn_ope  in number,
                           pn_sbo  in number,
                           pn_top  in number) return number; 
                           
  function fn_provision(pd_FecUltCierre date,
                        pn_saldo number, 
                        pn_cod  in number,
                        pn_mod  in number,
                        pn_suc  in number,
                        pn_mda  in number,
                        pn_pap  in number,
                        pn_cta  in number,
                        pn_ope  in number,
                        pn_sbo  in number,
                        pn_top  in number) return number; 
                         
  procedure sp_Calificacion(pd_FecUltCierre date,
                           pn_cod  in number,
                           pn_mod  in number,
                           pn_suc  in number,
                           pn_mda  in number,
                           pn_pap  in number,
                           pn_cta  in number,
                           pn_ope  in number,
                           pn_sbo  in number,
                           pn_top  in number,
                           pn_Califiacion out number,
                           pv_calificacion out varchar);  
                       
  function fn_GarantiaR(pn_cod  in number,
                        pn_mod  in number,
                        pn_suc  in number,
                        pn_mda  in number,
                        pn_pap  in number,
                        pn_cta  in number,
                        pn_ope  in number,
                        pn_sbo  in number,
                        pn_top  in number) return number;   
  function fn_Cronograma( pn_cod  in number,
                       pn_mod  in number,
                       pn_suc  in number,
                       pn_mda  in number,
                       pn_pap  in number,
                       pn_cta  in number,
                       pn_ope  in number,
                       pn_sbo  in number,
                       pn_top  in number) return number;                                                                                                                
  function fn_Esexonerado(pn_cod  in number,
                          pn_mod  in number,
                          pn_suc  in number,
                          pn_mda  in number,
                          pn_pap  in number,
                          pn_cta  in number,
                          pn_ope  in number,
                          pn_sbo  in number,
                          pn_top  in number) return number;
                       
  function fn_EstaEnCAstigo( pd_fecha in date,
                             pn_cod  in number,
                             pn_mod  in number,
                             pn_suc  in number,
                             pn_mda  in number,
                             pn_pap  in number,
                             pn_cta  in number,
                             pn_ope  in number,
                             pn_sbo  in number,
                             pn_top  in number) return number; 
                                                 
  procedure sp_verificar_líneas(pd_fecha in date,
                              pn_cod  in number,
                              pn_mod  in number,
                              pn_suc  in number,
                              pn_mda  in number,
                              pn_pap  in number,
                              pn_cta  in number,
                              pn_ope  in number,
                              pn_sbo  in number,
                              pn_top  in number,
                              pn_LineaSaldomenor out number,
                              pn_Ldescuadrada out number,
                              pn_Lbloqueada out number, 
                              pn_Lrubros out number,
                              pn_Lrubnopjm out number,
                              pn_Lrubnojud out number ) ;  
  Procedure Sp_MiVivienda(pn_emp in number,
                         pn_cta in number,
                         pn_ope in number,
                         pn_suc in number,
                         pn_pap in number,
                         pn_sbop in number,
                         pn_mda in number,
                         pn_mod in number,
                         pn_top in number,                         
                         pn_flg out number);
  --inicio kvalenciac 26/10/2024
  Procedure Sp_constancia(pn_emp in number,
                         pn_cta in number,
                         pn_ope in number,
                         pn_suc in number,
                         pn_pap in number,
                         pn_sbop in number,
                         pn_mda in number,
                         pn_mod in number,
                         pn_top in number,                         
                         pn_flg out number,
                         pd_fecha out date);
  --fin kvalenciac 26/12/2024                        
  Procedure sp_Cabecera(pc_uing in varchar2, --usuario
                                pn_codemp in number,
                                pn_grupo  in number, --número de grupo
                                 pn_nroprop in number,
                                pn_dias in number,
                                pn_monto in number,                              
                                dn_nvio   out number);
  Procedure sp_Inserta_Detalle(pn_nvio in number,
                               pn_dias in number,
                              pn_monto in number );
  procedure sp_ActualizaCabecera(pc_uing in varchar2, 
                              pn_pgcod in number,
                              pd_pgfape date,
                              pn_grupo  in number, --número de grupo
                              pn_propuesta  in number,
                              pn_empresa in number,
                              pn_tcbio in number, 
                              pn_modo in number );
  procedure sp_ActualizaGuiaVG(pc_uing in varchar2, 
                              pn_codemp in number,
                              pn_propuesta  in number,
                              pc_estado in varchar2,
                              pc_estadot in varchar2);
  procedure sp_validacionesM(pn_nro number,
                            pd_fecha in date,
                            pn_cod  in number,
                            pn_mod  in number,
                            pn_suc  in number,
                            pn_mda  in number,
                            pn_pap  in number,
                            pn_cta  in number,
                            pn_ope  in number,
                            pn_sbo  in number,
                            pn_top  in number,
                            pc_user in char,
                            pn_Indicador out number);                             
procedure sp_insertaAQPB750L( pn_nro number,
                              pd_fecha in date,
                              pc_user in char,
                              pn_cod  in number,
                              pn_mod  in number,
                              pn_suc  in number,
                              pn_mda  in number,
                              pn_pap  in number,
                              pn_cta  in number,
                              pn_ope  in number,
                              pn_sbo  in number,
                              pn_top  in number,
                              pc_mensaje in varchar);
procedure sp_ReporteC(pc_uing in varchar2,                              
                              pn_nrogru  in number,
                              pn_pgfape  in date);                                                                                                                                                                                                                                                   
end pq_cr_ventacarteras;
 /* GOLDENGATE_DDL_REPLICATION */
/

create or replace package body "PQ_CR_VENTACARTERAS" is
  /* ************************************************************************************************************
  -- Author  : KVALENCIAC
  -- Created : 20/04/2021
  -- Purpose : Proceso Venta Cartera
  -- Author Modifiación : KVALENCIAC
  -- Created : 17/06/2022
  -- Purpose : Proceso Venta Cartera
  -- Author Modifiación : KVALENCIAC
  -- Created : 18/08/2023
  -- Purpose : MOdificación para la obtención de pagos por grupo y no se elimine todo 
    -- Modificado  : KVALENCIAC
  -- Fecha Modificación : 26/12/2024 KVALENCIAC
  -- Purpose : Se modificó para qeu controle si el crédito se imprimio constancia o CNA 
  * *************************************************************************************************************/
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_bloqueo(vn_ubuser varchar2                       
                             ) is
  cursor venta is       
    select b.AQPB749pgc,
           b.AQPB749mod,
           b.AQPB749suc,
           b.AQPB749mda,
           b.AQPB749pap,
           b.AQPB749cta,
           b.AQPB749ope,
           b.AQPB749sbo,
           b.AQPB749top
    from AQPB749 b;
  lc_flag varchar(2);
  contador number;
  ln_R2COD number;
  ln_R2MOD number;
  ln_R2SUC number; 
  ln_R2MDA number;
  ln_R2PAP number;
  ln_R2CTA number;
  ln_R2OPER number;
  ln_R2SBOP number;
  ln_R2TOPE number;  
  ln_scsdo116 number;
  ln_scsdo117 number;
  ln_aostat number;  
  begin 
   -- verifica si hay cancelado  y llena columna de es_cancelado
  update AQPB749 set AQPB749ESCANCELADO ='1' 
  where (AQPB749pgc, AQPB749mod, AQPB749suc,AQPB749mda, AQPB749pap, AQPB749cta,AQPB749ope,AQPB749sbo,AQPB749top) in (select a.AQPB749pgc, a.AQPB749mod, a.AQPB749suc, a.AQPB749mda, a.AQPB749pap, a.AQPB749cta,a.AQPB749ope, a.AQPB749sbo, a.AQPB749top
   from AQPB749 a
   inner join  fsd010 f      
      on f.pgcod     = a.AQPB749pgc
        and f.aomod  = a.AQPB749mod
        and f.aosuc  = a.AQPB749suc
        and f.aomda  = a.AQPB749mda
        and f.aopap  = a.AQPB749pap
        and f.aocta  = a.AQPB749cta
        and f.aooper = a.AQPB749ope
        and f.aosbop = a.AQPB749sbo
        and f.aotope = a.AQPB749top
        and f.aostat = 99);
   commit;
   ----
   ---validaciones    
   update AQPB749 set AQPB749EsFondo=0, 
                      AQPB749TieneSaldo =0,
                      AQPB749EsLineam =0,
                      AQPB749EsJLineam =0,
                      AQPB749EsLineBlq =0;
   commit;
   for f in venta loop           
        contador :=0;
        begin
        select count(*) into contador from fsd011 
        where scrub in (9500095000000,9500092000000,9500093000000,9500094000000)
        and sccta= f.AQPB749cta
        and scoper=f.AQPB749ope;
        exception
                      when no_data_found then
                        contador :=0;
        end;
        if ( contador > 0)  then        
          update AQPB749
          set AQPB749TieneSaldo=1
          where AQPB749cta= f.AQPB749cta
          and AQPB749ope=f.AQPB749ope;
          commit;
          --dbms_output.put_line('Tiene Saldo Pendiente: Cuenta:'||f.aocta||'- Operación:'||f.aooper); 
        end if;     
        --verifica si es de fondo    
        pq_cr_creditos_fondoscovid.sp_verificar_cred_fondo( pn_cod => f.AQPB749pgc,
                                                            pn_mod => f.AQPB749mod,
                                                            pn_suc => f.AQPB749suc,
                                                            pn_mda => f.AQPB749mda,
                                                            pn_pap => f.AQPB749pap,
                                                            pn_cta => f.AQPB749cta,
                                                            pn_ope => f.AQPB749ope,
                                                            pn_sbo => f.AQPB749sbo,
                                                            pn_top => f.AQPB749top,
                                                            pn_flag => lc_flag);
        if ( lc_flag <> 'N' ) then -- si es diferente es de fondo
           update AQPB749
          set AQPB749EsFondo=1
          where AQPB749cta= f.AQPB749cta
          and AQPB749ope=f.AQPB749ope;
          commit;
          --dbms_output.put_line('Es de Fondo: Cuenta:'||f.aocta||'-operacion:'||f.aooper||'-'||lc_flag); 
        end if;
        
        --valida saldo de línea 117 es menot al saldo de linea módulo 116
        if ( f.AQPB749mod = 116 ) then
            ln_scsdo116:=0;
            begin
              select scsdo into ln_scsdo116
              from fsd011
              where PGCOD = f.AQPB749pgc
              and   SCMOD = f.AQPB749mod
              and   SCMDA = f.AQPB749mda 
              and   SCPAP = f.AQPB749pap
              and   SCCTA = f.AQPB749cta 
              and   SCSUC = f.AQPB749suc 
              and   SCOPER= f.AQPB749ope
              and  SCSBOP = f.AQPB749sbo
              and  SCTOPE = f.AQPB749top;
            exception
             when no_data_found then
                        ln_scsdo116 :=0;
            end;
            
          begin 
            select 
                  r.R2COD, 
                  r.R2MOD, 
                  r.R2SUC, 
                  r.R2MDA, 
                  r.R2PAP, 
                  r.R2CTA, 
                  r.R2OPER,
                  r.R2SBOP,
                  r.R2TOPE  
                  into
                  ln_R2COD, 
                  ln_R2MOD, 
                  ln_R2SUC, 
                  ln_R2MDA, 
                  ln_R2PAP, 
                  ln_R2CTA, 
                  ln_R2OPER,
                  ln_R2SBOP,
                  ln_R2TOPE
            from fsr011 r
          where r.R1COD   = f.AQPB749pgc
            and r.R1MOD   = f.AQPB749mod
            and r.R1SUC   = f.AQPB749suc  
            and r.R1MDA   = f.AQPB749mda 
            and r.R1PAP   = f.AQPB749pap  
            and r.R1CTA   = f.AQPB749cta
            and r.R1OPER  = f.AQPB749ope
            and r.R1SBOP  = f.AQPB749sbo
            and r.R1TOPE  = f.AQPB749top
            and r.RELCOD  = 46;
          exception
             when no_data_found then
                        ln_R2CTA :=0;
          end;
          if ( ln_R2CTA > 0 ) then 
            ln_scsdo117:=0;
            begin
              select scsdo,scstat into ln_scsdo117,ln_aostat
              from fsd011
              where PGCOD = ln_R2COD
              and   SCMOD = ln_R2MOD
              and   SCMDA = ln_R2MDA
              and   SCPAP = ln_R2PAP 
              and   SCCTA =  ln_R2CTA
              and   SCSUC = ln_R2SUC 
              and   SCOPER= ln_R2OPER
              and  SCSBOP = ln_R2SBOP
              and  SCTOPE = ln_R2TOPE;
            exception
             when no_data_found then
                        ln_scsdo117 :=0;
                        ln_aostat :=0;
            end;
            if ( ln_scsdo117 < 0 )then
              ln_scsdo117 :=ln_scsdo117*-1;
             end if;
            if ( ln_scsdo116 < 0 )then
              ln_scsdo116 :=ln_scsdo116*-1;
             end if;
            if (ln_aostat = 7 or ln_aostat=9) then
                update AQPB749
                set AQPB749EsLineBlq=1
                where AQPB749cta= f.AQPB749cta
                and AQPB749ope=f.AQPB749ope;
                commit;
            end if ;          
            if ( ln_scsdo117 < ln_scsdo116 ) then-- si saldo de línea es menor al saldo de la línea usada
               update AQPB749
                set AQPB749EsLineam=1
                where AQPB749cta= f.AQPB749cta
                and AQPB749ope=f.AQPB749ope;
                commit;
              end if;
           end if;              
        end if;   
        -- fin de valida saldo de línea si es módulo 116        
        ----valida si su saldo incial de la línea es menor para los tipos operacion 550 y modulo 200
        if ( f.AQPB749mod=200 and f.AQPB749top=550 and f.AQPB749mod=33 ) then
          ln_scsdo116:=0;
            begin
              select scsdo into ln_scsdo116
              from fsd011
              where PGCOD = f.AQPB749pgc
              and   SCMOD = f.AQPB749mod
              and   SCMDA = f.AQPB749mda 
              and   SCPAP = f.AQPB749pap
              and   SCCTA = f.AQPB749cta
              and   SCSUC = f.AQPB749suc
              and   SCOPER= f.AQPB749ope
              and  SCSBOP = f.AQPB749sbo
              and  SCTOPE = f.AQPB749top;
            exception
             when no_data_found then
                        ln_scsdo116 :=0;
            end;
          begin 
            select 
                  r.R1COD, 
                  r.R1MOD, 
                  r.R1SUC, 
                  r.R1MDA, 
                  r.R1PAP, 
                  r.R1CTA, 
                  r.R1OPER,
                  r.R1SBOP,
                  r.R1TOPE  
                  into
                  ln_R2COD, 
                  ln_R2MOD, 
                  ln_R2SUC, 
                  ln_R2MDA, 
                  ln_R2PAP, 
                  ln_R2CTA, 
                  ln_R2OPER,
                  ln_R2SBOP,
                  ln_R2TOPE
            from fsr011 r
          where r.R2COD   = f.AQPB749pgc
            and r.R2MOD   = f.AQPB749mod
            and r.R2SUC   = f.AQPB749suc 
            and r.R2MDA   = f.AQPB749mda 
            and r.R2PAP   = f.AQPB749pap 
            and r.R2CTA   = f.AQPB749cta
            and r.R2OPER  = f.AQPB749ope
            and r.R2SBOP  = f.AQPB749sbo
            and r.R2TOPE  = f.AQPB749top
            and r.RELCOD  = 52;
          exception
             when no_data_found then
                        ln_R2CTA :=0;
          end;         
          if ( ln_R2CTA > 0 ) then 
            ln_scsdo117:=0;
            begin 
                select scsdo,scstat into ln_scsdo117, ln_aostat
                from fsd011  s
                inner join fsr011 d on d.R2COD    = s.pgcod
                                    and d.R2MOD   = s.scmod
                                    and d.R2SUC   = s.scsuc
                                    and d.R2MDA   = s.scmda
                                    and d.R2PAP   = s.scpap
                                    and d.R2CTA   = s.sccta
                                    and d.R2OPER  = s.scoper
                                    and d.R2SBOP  = s.scsbop
                                    and d.R2TOPE  = s.sctope
                where d.R1COD = ln_R2COD
                and d.R1MOD   = ln_R2MOD
                and d.R1SUC   = ln_R2SUC
                and d.R1MDA   = ln_R2MDA
                and d.R1PAP   = ln_R2PAP
                and d.R1CTA   = ln_R2CTA
                and d.R1OPER  = ln_R2OPER
                and d.R1SBOP  = ln_R2SBOP
                and d.R1TOPE  = ln_R2TOPE
                and d.RELCOD  = 46;
             exception
             when no_data_found then
                        ln_scsdo117 :=0;
                        ln_aostat :=0;
            end;
            if ( ln_scsdo117 < 0 )then
              ln_scsdo117 :=ln_scsdo117*-1;
             end if;
            if ( ln_scsdo116 < 0 )then
              ln_scsdo116 :=ln_scsdo116*-1;
             end if;      
            if (ln_aostat = 7 or ln_aostat=9) then
                update AQPB749
                set AQPB749EsLineBlq=1
                where AQPB749cta= f.AQPB749cta
                and AQPB749ope=f.AQPB749ope;
                commit;
            end if ;        
            if ( ln_scsdo117 < ln_scsdo116 ) then-- si saldo de línea es menor al saldo de la línea usada
               update AQPB749
                set AQPB749EsJLineam=1
                where AQPB749cta= f.AQPB749cta
                and AQPB749ope=f.AQPB749ope;
                commit;
            end if;
          end if;
        end if;
  end loop;
  --fin de validaciones
   --inicio bloquea
   for j in venta loop
     update fsd010
        set aostat = 9
      where pgcod  = j.AQPB749pgc
        and aomod  = j.AQPB749mod
        and aosuc  = j.AQPB749suc
        and aomda  = j.AQPB749mda
        and aopap  = j.AQPB749pap
        and aocta  = j.AQPB749cta
        and aooper = j.AQPB749ope
        and aosbop = j.AQPB749sbo
        and aotope = j.AQPB749top
        and aostat <> 99;     
     update fsd011
        set SCstat = 9
      where pgcod  = j.AQPB749pgc
        and scmod  = j.AQPB749mod
        and scsuc  = j.AQPB749suc
        and scmda  = j.AQPB749mda
        and scpap  = j.AQPB749pap
        and sccta  = j.AQPB749cta
        and scoper = j.AQPB749ope
        and scsbop = j.AQPB749sbo
        and sctope = j.AQPB749top
        and scstat <> 99
        and scsdo <>0;
     commit;
   end loop;  
   --fin de bloqueo      
  end sp_bloqueo;
procedure sp_desbloqueo( vn_ubuser varchar2   ) is
  cursor venta is       
    select b.AQPB749pgc,
           b.AQPB749mod,
           b.AQPB749suc,
           b.AQPB749mda,
           b.AQPB749pap,
           b.AQPB749cta,
           b.AQPB749ope,
           b.AQPB749sbo,
           b.AQPB749top,
           b.aqpb749sta
    from AQPB749 b;
  begin 
  for j in venta loop
     update fsd010
        set aostat = j.aqpb749sta 
      where pgcod  = j.AQPB749pgc
        and aomod  = j.AQPB749mod
        and aosuc  = j.AQPB749suc
        and aomda  = j.AQPB749mda
        and aopap  = j.AQPB749pap
        and aocta  = j.AQPB749cta
        and aooper = j.AQPB749ope
        and aosbop = j.AQPB749sbo
        and aotope = j.AQPB749top;
     update fsd011
        set SCstat = j.aqpb749sta 
      where pgcod  = j.AQPB749pgc
        and scmod  = j.AQPB749mod
        and scsuc  = j.AQPB749suc
        and scmda  = j.AQPB749mda
        and scpap  = j.AQPB749pap
        and sccta  = j.AQPB749cta
        and scoper = j.AQPB749ope
        and scsbop = j.AQPB749sbo
        and sctope = j.AQPB749top;   
     commit;
  end loop;   
  end sp_desbloqueo;
procedure sp_CreaJAQZ509( vn_ubuser varchar2 , vn_nropro number   ) is
  /*cursor presta is       
    select b.AQPB749pgc,
           b.AQPB749mod,
           b.AQPB749suc,
           b.AQPB749mda,
           b.AQPB749pap,
           b.AQPB749cta,
           b.AQPB749ope,
           b.AQPB749sbo,
           b.AQPB749top,
           b.aqpb749sta
    from AQPB749 b;*/
    cursor presta is
    select b.jaqy953emp,
           b.jaqy953mod,
           b.jaqy953suc,
           b.jaqy953mda,
           b.jaqy953pap,
           b.jaqy953cta,
           b.jaqy953ope,
           b.jaqy953sbo,
           b.jaqy953top,
           b.jaqy953sta
    from jaqy953 b
    inner join jaqy952 j on j.jaqy952nro=b.jaqy952nro
    where j.jaqy952gru=vn_nropro;       
  /*  select b.jaqy953emp,
           b.jaqy953mod,
           b.jaqy953suc,
           b.jaqy953mda,
           b.jaqy953pap,
           b.jaqy953cta,
           b.jaqy953ope,
           b.jaqy953sbo,
           b.jaqy953top,
           b.jaqy953sta
    from jaqy953 b
    where jaqy952nro=vn_nropro;*/
    x number := 1;  
  begin 
  --Paso 1: Preparar tablas
  --create table operador.jaqz509_20190520 as   --select * from operador.jaqz509_20181126
  --select * from jaqz509;  --tabla que debe llenarse con la informacion de recuperaciones (excel).
  delete jaqz509 where jaqz509nrog in (select jaqy952gru from jaqy952 where jaqy952est='V' );  --kvalenciac 18/08/2023
  delete from jaqz509 where jaqz509nrog=vn_nropro; --kvalenciac 18/08/2023   delete from jaqz509;
  commit;
  --Table que se llena en el proceso
  --create table operador.jaqz510_20190520 as
  --select * from jaqz510;  --tabla con pagos se llenara despues de ejecutar el proceso
  delete jaqz510 where jaqz510nrog in (select jaqy952gru from jaqy952 where jaqy952est='V' );  --kvalenciac 18/08/2023
  delete from jaqz510 where jaqz510nrog=vn_nropro;--kvalenciac 18/08/2023 delete from jaqz510;
  commit;
  --Paso 2: Ingresar del excel los datos, Lote es el Nnum. de carga: carga 1 C1, carga 2 C2 para un mismo día
  --select * from jaqz509 for update;  
  begin 
    for j in presta loop
       insert into jaqz509 (lote,cuenta,operacion,modulo,nro,jaqz509nrog) values
       ('C1',j.jaqy953cta,j.jaqy953ope,j.jaqy953mod,x,vn_nropro ) ; --se agregó vn_nropro kvalenciac 18/08/2023   ---j.AQPB749cta,j.AQPB749ope,j.AQPB749mod, x ) ;
       commit;
       x:= x+1;
    end loop;  
  end;     

  --select * from jaqz511;  --GUIA DE PROCESO parametrizada con las transacciones que se consideran.   
  end sp_CreaJAQZ509;
  
  procedure sp_ObtienePagos( FECHA_FIN date) is
    --Modificar FECHA_FIN 
    ln_numjob     number(9) := 0;
    lc_nomusr     varchar2(50);

    lc_prcsobend varchar2(500);
    ln_count number(10);
    ln_limit number(18);

    ln_indpro NUMBER(18);
    LNINI NUMBER ;
    LNFIN NUMBER ;
    lc_fecpro char(10);
    CADENA varchar2(2000);
    ln_job number := 0;
    NROCRE NUMBER  := 1000 ; --5000  kdvc 
    FECHA_INICIO DATE := to_date('02/01/2002',  'DD/MM/RRRR');--No modificar    
   -- FECHA_FIN DATE := '21/12/2020';   -------FECHA_FIN Fecha que indican (dia o mes), dia anterior a ejecución
    lc_fecini char(10);
    lc_fecfin char(10);
    lc_variable varchar2(2000);
    lc_hostname varchar2(64);
    ld_fecha_fin  date;
  begin 
         execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';--ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE;
         execute immediate 'ALTER SESSION SET commit_wait=''NOWAIT''';
         execute immediate 'ALTER SESSION SET commit_logging=''BATCH''';

       SELECT max(t.NRO)  INTO ln_limit  FROM JAQZ509 t;  --56412
       
     begin
        select host_name
          into lc_hostname
          from v$instance;
      end;

     
       LNINI := 1; 
       LNFIN := 1;
       lc_fecini := to_char(FECHA_INICIO,'RRRR.MM.DD'); 
       lc_fecfin := to_char(FECHA_FIN,'RRRR.MM.DD'); 

                     
       FOR i IN 1 .. CEIL(ln_limit/NROCRE) LOOP
          
          LNINI  := LNFIN; 
          LNFIN  := LNFIN + NROCRE;
          ln_job := ln_job +1;
          lc_variable := 'begin          
                     pq_venta.SP_CR_PAGOS('||LNINI||','||LNFIN||',TO_DATE('''||lc_fecini||''',''RRRR.MM.DD'')'||',TO_DATE('''||lc_fecfin||''',''RRRR.MM.DD'') );'||' End;';
         
           
               
                --if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
                  IF SYS.FN_BD_ISRAC='TRUE' THEN --kvalenciac 18/08/2023
                           DBMS_JOB.SUBMIT(job => ln_job, 
                                        what => lc_variable,
                                        next_date => sysdate,
                                        interval => null,
                                        no_parse => false,
                                        instance => 2,
                                        force => false
                                        );
                      else
                           DBMS_JOB.SUBMIT(job => ln_job, 
                                        what => lc_variable,
                                        next_date => sysdate,
                                        interval => null,
                                        no_parse => false,
                                        force => false
                                        );
                          
                      end if;                                               
         commit;
        END LOOP; 
        
        begin
            select TRIM(TP1DESC)
            INTO lc_nomusr
              from fst198
             where tp1cod = 1
               and tp1cod1 = 10847
               and tp1corr1 = 999 ; ---2019.07.22 guia de proceso para hostname
        exception when others then
           lc_nomusr:='';
          end;
        
          begin
                
            SELECT count(*)
              INTO ln_numjob
              FROM dba_jobs x
             WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
               AND upper(x.what) LIKE '%PQ_VENTA.SP_CR_PAGOS%';
          exception when others then
             ln_numjob := 0;
          end;

           While ln_numjob > 0 loop
              begin
                SELECT count(*)
                  INTO ln_numjob
                  FROM dba_jobs x
                 WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
                   AND upper(x.what) LIKE '%PQ_VENTA.SP_CR_PAGOS%';
              exception when others then
                 ln_numjob := 0;
              end;
          End loop;
        ----------------diario-------------------
        ---------apachecoh 2022.07.21------------
        LNINI := 1; 
        LNFIN := 1;
        FOR i IN 1 .. CEIL(ln_limit/NROCRE) LOOP          
            LNINI  := LNFIN; 
            LNFIN  := LNFIN + NROCRE;
            ln_job := ln_job +1;
            lc_variable := 'begin          
                       pq_venta.SP_CR_PAGOS_D('||LNINI||','||LNFIN||');'||' End;';                                   
--                  if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
                  IF SYS.FN_BD_ISRAC='TRUE' THEN --kvalenciac 18/08/2023
                       DBMS_JOB.SUBMIT(job => ln_job, 
                                    what => lc_variable,
                                    next_date => sysdate+1/(24*60),--sysdate,  kvalenciac 18/08/2023
                                    interval => null,
                                    no_parse => false,
                                    instance => 2,
                                    force => false
                                    );
                  else
                       DBMS_JOB.SUBMIT(job => ln_job, 
                                    what => lc_variable,
                                    next_date => sysdate+1/(24*60), --sysdate,  kvalenciac 18/08/2023
                                    interval => null,
                                    no_parse => false,
                                    force => false
                                    );                          
                  end if;                                               
           commit;
        END LOOP; 
        BEGIN
            select TRIM(TP1DESC)
            INTO lc_nomusr
              from fst198
             where tp1cod = 1
               and tp1cod1 = 10847
               and tp1corr1 = 999 ; ---2019.07.22 guia de proceso para hostname
         EXCEPTION 
             when others then
             lc_nomusr := '';
        END;
        BEGIN                
            SELECT count(*)
              INTO ln_numjob
              FROM dba_jobs x
             WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
               AND upper(x.what) LIKE '%PQ_VENTA.SP_CR_PAGOS_D%'; --diarios
        EXCEPTION 
             when others then
             ln_numjob := 0;
        END;
        WHILE ln_numjob > 0 LOOP
              BEGIN
                SELECT count(*)
                  INTO ln_numjob
                  FROM dba_jobs x
                 WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
                   AND upper(x.what) LIKE '%PQ_VENTA.SP_CR_PAGOS_D%'; --diarios
              EXCEPTION 
                   when others then
                   ln_numjob := 0;
              END;
       END LOOP;
  end sp_ObtienePagos; 
  
  procedure sp_antesventa( vn_ubuser varchar2, FECHA_FIN date , pn_nropro number ) is
  begin
    --ejecuta P2_01 
     begin
       -- Call the procedure
      pq_cr_ventacarteras.sp_creajaqz509(vn_ubuser => vn_ubuser,
                                         vn_nropro => pn_nropro);
     end;
     --ejecuta P2_02
      begin
        -- Call the procedure
        pq_cr_ventacarteras.sp_obtienepagos(fecha_fin => FECHA_FIN);
       end;
  end sp_antesventa;
   
procedure sp_saldos_venta( lc_IND char ) is  
    --select sysdate, TO_CHAR(sysdate,'HH24') from dual;   
ln_hora number;
ln_cant number := 0;
lc_flag char(1);
ln_numjob     number(9) := 0;
lc_nomusr     varchar2(50);
lc_pac_nombre varchar2(100);
--lc_IND  char(1):= 'D'; --------------> Colocar "A" si se ejecuta antes de la venta V o "D" si se ejecuta despues venta

BEGIN
  
  select  TO_CHAR(sysdate,'HH24') into ln_hora from dual;  
  
  lc_flag := '';
  if ln_hora < 7 then
     update fst198 f  set TP1DESC = '06'  --ACTUALIZAR HORA DE LA VENTA
     where f.tp1cod=1 and f.tp1cod1=10872  and f.tp1corr1=14  and f.tp1corr2=1;--1reg
     
      update fst198 f  set TP1DESC = '06' --ACTUALIZAR HORA DE LA VENTA
      where f.tp1cod=1  and f.tp1cod1=10872 and f.tp1corr1=14 and f.tp1corr2=3; --1reg
      lc_flag := 'D'; --dia
      commit;
  else
    
      if ln_hora > 21 then
    
          update fst198 f  set TP1DESC = '23' --ACTUALIZAR HORA DE LA VENTA
          where f.tp1cod=1 and f.tp1cod1=10872 and f.tp1corr1=14 and f.tp1corr2=4 ; --1reg  --hora final para los 7 ultimos dias del mes ( hora 22) (posion en guia es (10872,14,4))
          
          update fst198 f  set TP1DESC = '23' --ACTUALIZAR HORA DE LA VENTA
          where f.tp1cod=1 and f.tp1cod1=10872 and f.tp1corr1=14 and f.tp1corr2=2 ; --1reg  --hora final para las fechas menores a 7 dias del fin del mes( hora 20) (posion en guia es (10872,14,2))
         lc_flag := 'N'; --noche
         commit;
      end if;
  
  end if;    

    ---generar backups
  --B -- PASOS PARA OBTENER SALDOS  ANTES VENTA
  ---->>>>>>>>>>>>>>>>>
      --3--Genera saldos en linea antes de VENTA verificar que no existan jobs ejecutandose
      begin
         select count(*) into ln_cant from JAQL983 where jaql983ffi is null; ---Debe ser igual a 0
      exception when others then
          ln_cant := 0;            
      end;
      
      if ln_cant > 0 then
         delete from JAQL983 where jaql983ffi is null;
         commit;
      end if;

      --3.1- Ejecutar proceso Saldos linea (tiempo estimado de ejecución 5 min máx.)
      begin
        pq_cr_saldos_linea.sp_cr_job_carga(pd_fecpro => trunc(sysdate) );
      end;

      --3.2---validar que culminen los jobs
      --select count(*) from DBA_JOBS where upper(what) like '%PQ_CR_SALDOS_LINEA.SP_CR_CARGA_DATOS_BC%';  --debe ser igual a 0


        begin
            select TRIM(TP1DESC)
            INTO lc_nomusr
              from fst198
             where tp1cod = 1
               and tp1cod1 = 10847
               and tp1corr1 = 999 ; ---2019.07.22 guia de proceso para hostname
         EXCEPTION 
             when others then
             lc_nomusr := '';
          end;
        
          begin
                
            SELECT count(*)
              INTO ln_numjob
              FROM dba_jobs x
             WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
               AND upper(x.what) LIKE '%PQ_CR_SALDOS_LINEA.SP_CR_CARGA_DATOS_BC%';
          exception when others then
             ln_numjob := 0;
          end;

           While ln_numjob > 0 loop
              begin
                SELECT count(*)
                  INTO ln_numjob
                  FROM dba_jobs x
                 WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
                   AND upper(x.what) LIKE '%PQ_CR_SALDOS_LINEA.SP_CR_CARGA_DATOS_BC%';
              exception when others then
                 ln_numjob := 0;
              end;
    End loop;

      --3.4  CONSOLIDADO 
      insert into JAQL982V (jaql982vfec, jaql982vind, jaql982vscap, jaql982vscan, jaql982vscar, jaql982vscav, jaql982vscvp, 
                           jaql982vscvn, jaql982vscvr, jaql982vscaj, jaql982vscac, jaql982vscpv, jaql982vscp1)
      select trunc(sysdate), lc_ind,  sum(j.jaql982scap) CAPITAL, sum(j.jaql982scan), sum(j.jaql982scar), sum(j.jaql982scav) VENCIDO,
      sum(j.jaql982scvp) , sum(j.jaql982scvn), sum(j.jaql982scvr), sum(j.jaql982scaj) JUDICIAL, sum(j.jaql982scac) CASTIGADO,
      sum(j.jaql982scpv), sum(j.jaql982scp1)
       from jaql982 j;   --Cambiar la FECHA DDMMYYYY
      commit; 

     if  lc_flag = 'D' then
         update fst198 f  set TP1DESC = '07' where f.tp1cod=1 and f.tp1cod1=10872  and f.tp1corr1=14  and f.tp1corr2=1;--1reg --hora inicial para las fechas menores a 7 dias del fin del mes( hora 07) (posion en guia es (10872,14,1))         
         update fst198 f  set TP1DESC = '07' where f.tp1cod=1  and f.tp1cod1=10872 and f.tp1corr1=14 and f.tp1corr2=3; --1reg  --hora inicial para los 7 ultimos dias del mes ( hora 07) (posion en guia es (10872,14,3))   
         commit;
     else
        
          if lc_flag = 'N' then
              update fst198 f  set TP1DESC = '20' where f.tp1cod=1 and f.tp1cod1=10872 and f.tp1corr1=14 and f.tp1corr2=2 ; --1reg  --hora final para las fechas menores a 7 dias del fin del mes( hora 20) (posion en guia es (10872,14,2))
              update fst198 f  set TP1DESC = '22' where f.tp1cod=1 and f.tp1cod1=10872 and f.tp1corr1=14 and f.tp1corr2=4 ; --1reg  --hora final para los 7 ultimos dias del mes ( hora 22) (posion en guia es (10872,14,4))
              commit;
          end if;
      
      end if;    
end sp_saldos_venta;
procedure sp_estaenventa(pd_fecha in date,
                        pn_cod  in number,
                        pn_mod  in number,
                        pn_suc  in number,
                        pn_mda  in number,
                        pn_pap  in number,
                        pn_cta  in number,
                        pn_ope  in number,
                        pn_sbo  in number,
                        pn_top  in number,
                        pn_flag out number) is
contador number;
begin
   contador:= 0;
   begin 
     select count(*) 
           into contador
     from JAQY952 j
     inner join JAQY953 y on j.jaqy952nro=y.jaqy952nro
     where ( j.jaqy952est<>'V' and j.jaqy952est<>'A' )
     and y.JAQY953EMP = pn_cod
     and y.JAQY953CTA = pn_cta 
     and y.JAQY953OPE = pn_ope 
     and y.JAQY953PAP = pn_pap 
     and y.JAQY953MDA = pn_mda
     and y.JAQY953MOD = pn_mod
     and y.JAQY953TOP = pn_top
     and y.JAQY953SBO = pn_sbo
     and y.JAQY953SUC = pn_suc;
   exception
     when no_data_found then
       BEGIN
         select count(*) 
           into contador
         from jaqy953 y
         inner join jaqy952 j on j.jaqy952nro=y.jaqy952nro         
         where   y.JAQY953EMP = pn_cod
             and y.JAQY953CTA = pn_cta 
             and y.JAQY953OPE = pn_ope 
             and y.JAQY953PAP = pn_pap 
             and y.JAQY953MDA = pn_mda
             and y.JAQY953MOD = pn_mod
             and y.JAQY953TOP = pn_top
             and y.JAQY953SBO = pn_sbo
             and y.JAQY953SUC = pn_suc
             and j.jaqy952est='V'
             and (y.jaqy953itc=' ' or j.jaqy952fev=pd_fecha);
       exception
       when no_data_found then
         contador :=0;
       end;
   end;
   if ( contador > 0 ) then
     pn_flag :=1;
   end if;
end sp_estaenventa;
procedure sp_validaciones(pd_fecha in date,
                        pn_cod  in number,
                        pn_mod  in number,
                        pn_suc  in number,
                        pn_mda  in number,
                        pn_pap  in number,
                        pn_cta  in number,
                        pn_ope  in number,
                        pn_sbo  in number,
                        pn_top  in number,
                        pc_user in char,
                        pn_Indicador out number) is
ln_contador number;
ln_esfondo varchar(2);
ln_estado number;
ln_escancelado number;
ln_TieneSaldo number;
ln_TieneAcuerdo number;
ld_FecUltCierre date;
ln_sevende number;
ln_sevender number;
ln_saldo number;
ln_Provision number;
ln_Calificacion number;
ln_garantíaR number;
ln_rubro number;
ln_rubro2 number;
ln_rubro3 number;
lc_flag varchar(2);
ln_AQPB749SALC number;
ln_EsexoneradoUC number;
ln_AQPB749CRECAS number;
ln_AQPB749ESLINEAM number;
ln_AQPB749ESJLINEAM number;
ln_AQPB749ESLINEBLQ number;
ln_aqpb749rubl number;
ln_aqpb749rublpjm number;
ln_aqpb749rubljud number;
ln_estadoc number;
lc_estado varchar(20);
lc_mensaje varchar (250);
lv_Calificacion varchar (15);
ln_esmivivienda number;
ln_cronograma number;
ln_existe number;
ln_tieneconstancia number;--kvalenciac 26/12/2024
ln_fechaimpresion date;--kvalenciac 26/12/2024

begin 
   select last_day(add_months(pd_fecha,-1)) into ld_FecUltCierre from dual;
  
   ln_escancelado:=0; 
   ln_estado:=0;
   ln_EsexoneradoUC:=0;
   begin 
     select aostat
           into ln_estado
     from  fsd010 f      
      where f.pgcod  = pn_cod 
        and f.aomod  = pn_mod 
        and f.aosuc  = pn_suc 
        and f.aomda  = pn_mda 
        and f.aopap  = pn_pap 
        and f.aocta  = pn_cta 
        and f.aooper = pn_ope 
        and f.aosbop = pn_sbo 
        and f.aotope = pn_top;
   exception
     when no_data_found then
       ln_estado:=0; 
   end;
   if ( ln_estado=99 )then
     ln_escancelado:=1;
   end if;
   ln_sevende:=0;---valida el estado solo estados -	Créditos estados diferentes a estado 21,22,34,23,64,90  (no se venden).
   begin 
     select count(*) into ln_sevende from Fst198
      Where Tp1cod=1
      and Tp1cod1=10897
      and Tp1corr1=12
      and Tp1corr2=1
      and Tp1corr3>0 
      and TP1nro1= ln_estado;
   exception
     when no_data_found then
       ln_sevende:=0;
   end;
   -----
   ln_existe:=0;
   begin 
     select count(*)
       into ln_existe
       from  fsd011 d  
        where d.pgcod  = pn_cod 
          and d.scmod  = pn_mod         
          and d.SCMDA  = pn_mda 
          and d.SCPAP  = pn_pap 
          and d.SCCTA  = pn_cta 
          and d.SCSUC  = pn_suc 
          and d.SCOPER = pn_ope  
          and d.SCSBOP = pn_sbo
          and d.SCTOPE = pn_top;
       exception
         when no_data_found then
           ln_existe:=0;
      end; 
   -----
   ln_saldo:=0; 
   --if ( ln_sevende > 0 ) then
     begin 
     select scsdo, scrub, scstat
       into ln_saldo,ln_rubro, ln_estadoc
       from  fsd011 d  
        where d.pgcod  = pn_cod 
          and d.scmod  = pn_mod         
          and d.SCMDA  = pn_mda 
          and d.SCPAP  = pn_pap 
          and d.SCCTA  = pn_cta 
          and d.SCSUC  = pn_suc 
          and d.SCOPER = pn_ope  
          and d.SCSBOP = pn_sbo
          and d.SCTOPE = pn_top;
       exception
         when no_data_found then
           ln_saldo:=0;
      end;   
     if ( ln_saldo<0) then
         ln_saldo:= ln_saldo*-1;
     end if;     
   --end if;
   if ( ln_saldo = 0 )then
     ln_AQPB749SALC :=1; --si tiene saldo capital cero
   end if;
   select to_number(substr(to_char(ln_rubro),0,4)) into ln_rubro2 from dual;
   select to_number(substr(to_char(ln_rubro),0,6)) into ln_rubro3 from dual;
   begin 
     select Tp1cod into ln_sevender from Fst198
      Where Tp1cod=1
      and Tp1cod1=10897
      and Tp1corr1=12
      and Tp1corr2=2
      and Tp1corr3>0 
      and TP1IMP1= ln_rubro2;
   exception
     when no_data_found then
       begin 
          select count(*) into ln_sevender from Fst198
          Where Tp1cod=1
          and Tp1cod1=10897
          and Tp1corr1=12
          and Tp1corr2=2
          and Tp1corr3>0 
          and TP1IMP1= ln_rubro3;
        exception
        when no_data_found then
          ln_sevender:=0;
        end;
   end;
   if ( ln_sevender=0 or ln_sevender is null ) then
     ln_sevender:=1;--  AQPB749RUBNP si es 1 es rubro no permitido para la venta
   else
     ln_sevender:=0;--si es 0 es rubro permitido para la venta
   end if;
   begin 
     select cenomr into lc_estado from Fst026
      Where cecod=ln_estado;
   exception
     when no_data_found then
       lc_estado:='';
   end;
   -----verifica si es de fondo  
   ln_esfondo :=0;  
   pq_cr_creditos_fondoscovid.sp_verificar_cred_fondo( pn_cod => pn_cod,
                                                            pn_mod => pn_mod,
                                                            pn_suc => pn_suc,
                                                            pn_mda => pn_mda,
                                                            pn_pap => pn_pap,
                                                            pn_cta => pn_cta,
                                                            pn_ope => pn_ope,
                                                            pn_sbo => pn_sbo,
                                                            pn_top => pn_top,
                                                            pn_flag => lc_flag);   
   if ( lc_flag <> 'N' ) then -- si es diferente es de fondo
          ln_esfondo :=1;
   end if;
   --verifica si tiene saldo pendiente  
   ln_TieneSaldo:=0;                                                             
   ln_TieneSaldo := pq_cr_ventacarteras.fn_TieneSaldo(pn_cod,
                                              pn_mod,
                                              pn_suc,
                                              pn_mda,
                                              pn_pap,
                                              pn_cta,
                                              pn_ope,
                                              pn_sbo,
                                              pn_top);
   --verifica si tiene acuerdo de pago
   ln_TieneAcuerdo := pq_cr_ventacarteras.fn_TieneAcuerdo(pn_cod,
                                              pn_mod,
                                              pn_suc,
                                              pn_mda,
                                              pn_pap,
                                              pn_cta,
                                              pn_ope,
                                              pn_sbo,
                                              pn_top);
    --verifica si tiene provisión
    ln_Provision := pq_cr_ventacarteras.fn_provision(ld_FecUltCierre,
                                              ln_saldo,
                                              pn_cod,
                                              pn_mod,
                                              pn_suc,
                                              pn_mda,
                                              pn_pap,
                                              pn_cta,
                                              pn_ope,
                                              pn_sbo,
                                              pn_top);
    --verifica calificación
         
    pq_cr_ventacarteras.sp_Calificacion(     pd_FecUltCierre=> ld_FecUltCierre,
                                              pn_cod => pn_cod,
                                              pn_mod => pn_mod,
                                              pn_suc => pn_suc,
                                              pn_mda => pn_mda,
                                              pn_pap => pn_pap,
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_sbo => pn_sbo,
                                              pn_top => pn_top,
                                              pn_Califiacion  => ln_Calificacion,
                                              pv_calificacion => lv_Calificacion
                                              );   
    ---verifico si tiene garantías reales
    ln_garantíaR := pq_cr_ventacarteras.fn_GarantiaR(pn_cod,
                                              pn_mod,
                                              pn_suc,
                                              pn_mda,
                                              pn_pap,
                                              pn_cta,
                                              pn_ope,
                                              pn_sbo,
                                              pn_top);      
    ---verifico si tiene -	Créditos con cronograma diferente de la fsd011 AQPB479CROND
    ln_cronograma := pq_cr_ventacarteras.fn_Cronograma(pn_cod,
                                              pn_mod,
                                              pn_suc,
                                              pn_mda,
                                              pn_pap,
                                              pn_cta,
                                              pn_ope,
                                              pn_sbo,
                                              pn_top);                                   
    --verifica si es crédito exonerado
    ln_EsexoneradoUC := pq_cr_ventacarteras.fn_Esexonerado(pn_cod,
                                              pn_mod,
                                              pn_suc,
                                              pn_mda,
                                              pn_pap,
                                              pn_cta,
                                              pn_ope,
                                              pn_sbo,
                                              pn_top);
    ---verifica si el crédito está en proceso de castigo
    ln_AQPB749CRECAS := pq_cr_ventacarteras.fn_EstaEnCAstigo(pd_fecha,
                                              pn_cod,
                                              pn_mod,
                                              pn_suc,
                                              pn_mda,
                                              pn_pap,
                                              pn_cta,
                                              pn_ope,
                                              pn_sbo,
                                              pn_top);
   ---verifica datos de líneas    
   pq_cr_ventacarteras.sp_verificar_líneas(pd_fecha => pd_fecha,
                                          pn_cod => pn_cod,
                                          pn_mod => pn_mod,
                                          pn_suc => pn_suc,
                                          pn_mda => pn_mda ,
                                          pn_pap => pn_pap,
                                          pn_cta => pn_cta,
                                          pn_ope => pn_ope,
                                          pn_sbo => pn_sbo,
                                          pn_top => pn_top,                                          
                                          pn_LineaSaldomenor=> ln_AQPB749ESLINEAM,
                                          pn_Ldescuadrada   => ln_AQPB749ESJLINEAM,
                                          pn_Lbloqueada     => ln_AQPB749ESLINEBLQ,
                                          pn_Lrubros        => ln_aqpb749rubl,
                                          pn_Lrubnopjm      => ln_aqpb749rublpjm,
                                          pn_Lrubnojud      => ln_aqpb749rubljud
                                          );      
    --verifica si es de mi vivienda
    ln_esmivivienda:=0;     
    pq_cr_ventacarteras.sp_mivivienda(  
                                              pn_emp => pn_cod,  
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_suc => pn_suc,
                                              pn_pap => pn_pap,
                                              pn_sbop=> pn_sbo,
                                              pn_mda => pn_mda,
                                              pn_mod => pn_mod,
                                              pn_top => pn_top,
                                              pn_flg => ln_esmivivienda
                                              );      
    --tiene constancia o cna impreso  inicio kvalenciac 26/12/2024
    ln_tieneconstancia:=0;
    ln_fechaimpresion:=null;
    pq_cr_ventacarteras.sp_constancia(  
                                              pn_emp => pn_cod,  
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_suc => pn_suc,
                                              pn_pap => pn_pap,
                                              pn_sbop=> pn_sbo,
                                              pn_mda => pn_mda,
                                              pn_mod => pn_mod,
                                              pn_top => pn_top,
                                              pn_flg => ln_tieneconstancia,
                                              pd_fecha => ln_fechaimpresion
                                              );
    ---fin kvalenciac 26/12/2024                                                              
    ---Actualiza tabla temporal de carga de propuesta
    update aqpb749
    set  aqpb749STA         = ln_estado,
         aqpb749EST         = lc_estado,
         AQPB749ESCANCELADO = ln_escancelado,
         AQPB749ESFONDO     = ln_esfondo,
         AQPB749TIENESALDO  = ln_TieneSaldo,
         AQPB749ESLINEAM    = ln_AQPB749ESLINEAM,
         AQPB749ESJLINEAM   = ln_AQPB749ESJLINEAM,
         AQPB749ESLINEBLQ   = ln_AQPB749ESLINEBLQ,
         AQPB749TIENEACU    = ln_TieneAcuerdo,
         AQPB749prov        = ln_Provision,
         AQPB749calif       = ln_Calificacion,
         AQPB749gareal     = ln_garantíaR,
         AQPB749rubnp       = ln_sevender,
         AQPB749salc        = ln_AQPB749SALC,
         AQPB749crond       = ln_cronograma, --null,--se validara en el boton proceso
         AQPB749creexo      = ln_EsexoneradoUC,
         AQPB749crecas      = ln_AQPB749CRECAS,
         aqpb749rubl        = ln_aqpb749rubl,
         aqpb749rublpjm     = ln_aqpb749rublpjm,
         aqpb749rubljud     = ln_aqpb749rubljud,
         AQPB749calift      = lv_Calificacion,
         aqpb749esvnda      = ln_esmivivienda,
         aqpb749cons        = ln_tieneconstancia, --kvalenciac 27/12/2024
         aqpb749feccons     = ln_fechaimpresion  --kvalenciac 27/12/2024
       where
         AQPB749PGC    =pn_cod
         and AQPB749MOD=pn_mod
         and AQPB749SUC=pn_suc 
         and AQPB749MDA=pn_mda
         and AQPB749PAP=pn_pap
         and AQPB749CTA=pn_cta
         and AQPB749OPE=pn_ope
         and AQPB749SBO=pn_sbo
         and AQPB749TOP=pn_top;
       commit;
       ln_contador := 0;
       -----------------------------------------------------------------Actualizo tabla de mensaje de errores
       
       if ( ln_existe = 0 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Clave de crédito no encontrada en bantotal.';
         pq_cr_ventacarteras.sp_insertaAQPB749L(pd_fecha => pd_fecha,
                                             pc_user => pc_user,
                                              pn_cod => pn_cod,
                                              pn_mod => pn_mod,
                                              pn_suc => pn_suc,
                                              pn_mda => pn_mda,
                                              pn_pap => pn_pap,
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_sbo => pn_sbo,
                                              pn_top => pn_top,
                                              pc_mensaje => lc_mensaje);
       end if;
       
       if ( ln_sevende = 0 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Crédito en estado no valido para la venta';
         pq_cr_ventacarteras.sp_insertaAQPB749L(pd_fecha => pd_fecha,
                                             pc_user => pc_user,
                                              pn_cod => pn_cod,
                                              pn_mod => pn_mod,
                                              pn_suc => pn_suc,
                                              pn_mda => pn_mda,
                                              pn_pap => pn_pap,
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_sbo => pn_sbo,
                                              pn_top => pn_top,
                                              pc_mensaje => lc_mensaje);
       end if;
       if (ln_escancelado=1 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Crédito esta cancelado.';
         pq_cr_ventacarteras.sp_insertaAQPB749L(pd_fecha => pd_fecha,
                                             pc_user => pc_user,
                                              pn_cod => pn_cod,
                                              pn_mod => pn_mod,
                                              pn_suc => pn_suc,
                                              pn_mda => pn_mda,
                                              pn_pap => pn_pap,
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_sbo => pn_sbo,
                                              pn_top => pn_top,
                                              pc_mensaje => lc_mensaje);
       end if; 
       if (ln_esfondo=1 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Crédito pertenece a fondos del gobierno.';
         pq_cr_ventacarteras.sp_insertaAQPB749L(pd_fecha => pd_fecha,
                                             pc_user => pc_user,
                                              pn_cod => pn_cod,
                                              pn_mod => pn_mod,
                                              pn_suc => pn_suc,
                                              pn_mda => pn_mda,
                                              pn_pap => pn_pap,
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_sbo => pn_sbo,
                                              pn_top => pn_top,
                                              pc_mensaje => lc_mensaje);
       end if; 
       if (ln_TieneSaldo=1 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Crédito tiene saldos pendientes.';
         pq_cr_ventacarteras.sp_insertaAQPB749L(pd_fecha => pd_fecha,
                                             pc_user => pc_user,
                                              pn_cod => pn_cod,
                                              pn_mod => pn_mod,
                                              pn_suc => pn_suc,
                                              pn_mda => pn_mda,
                                              pn_pap => pn_pap,
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_sbo => pn_sbo,
                                              pn_top => pn_top,
                                              pc_mensaje => lc_mensaje);
       end if;
       if (ln_TieneAcuerdo=1 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Crédito con acuerdos pendientes.';
         pq_cr_ventacarteras.sp_insertaAQPB749L(pd_fecha => pd_fecha,
                                             pc_user => pc_user,
                                              pn_cod => pn_cod,
                                              pn_mod => pn_mod,
                                              pn_suc => pn_suc,
                                              pn_mda => pn_mda,
                                              pn_pap => pn_pap,
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_sbo => pn_sbo,
                                              pn_top => pn_top,
                                              pc_mensaje => lc_mensaje);
       end if;
       
       if ((ln_Provision<>0 and pn_mod=33 ) or (ln_Provision<100 and pn_mod<>33))then
         ln_contador := ln_contador +1;
         lc_mensaje:='Crédito con provisión diferente de 100%.';
         pq_cr_ventacarteras.sp_insertaAQPB749L(pd_fecha => pd_fecha,
                                             pc_user => pc_user,
                                              pn_cod => pn_cod,
                                              pn_mod => pn_mod,
                                              pn_suc => pn_suc,
                                              pn_mda => pn_mda,
                                              pn_pap => pn_pap,
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_sbo => pn_sbo,
                                              pn_top => pn_top,
                                              pc_mensaje => lc_mensaje);
       end if;
       if (ln_Calificacion=1 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Crédito con calificación diferente de Perdida al último cierre mensual.';
         pq_cr_ventacarteras.sp_insertaAQPB749L(pd_fecha => pd_fecha,
                                             pc_user => pc_user,
                                              pn_cod => pn_cod,
                                              pn_mod => pn_mod,
                                              pn_suc => pn_suc,
                                              pn_mda => pn_mda,
                                              pn_pap => pn_pap,
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_sbo => pn_sbo,
                                              pn_top => pn_top,
                                              pc_mensaje => lc_mensaje);
       end if;
        if (ln_garantíaR=1 )then
          ln_contador := ln_contador +1;
         lc_mensaje:='Crédito con garantía real.';
         pq_cr_ventacarteras.sp_insertaAQPB749L(pd_fecha => pd_fecha,
                                             pc_user => pc_user,
                                              pn_cod => pn_cod,
                                              pn_mod => pn_mod,
                                              pn_suc => pn_suc,
                                              pn_mda => pn_mda,
                                              pn_pap => pn_pap,
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_sbo => pn_sbo,
                                              pn_top => pn_top,
                                              pc_mensaje => lc_mensaje);
       end if; 
       if (ln_sevender>0 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Crédito no se encuentra en rubros permitidos para la venta.';
         pq_cr_ventacarteras.sp_insertaAQPB749L(pd_fecha => pd_fecha,
                                             pc_user => pc_user,
                                              pn_cod => pn_cod,
                                              pn_mod => pn_mod,
                                              pn_suc => pn_suc,
                                              pn_mda => pn_mda,
                                              pn_pap => pn_pap,
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_sbo => pn_sbo,
                                              pn_top => pn_top,
                                              pc_mensaje => lc_mensaje);
       end if; 
       if (ln_AQPB749SALC=1 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Crédito con saldo de capital cero.';
         pq_cr_ventacarteras.sp_insertaAQPB749L(pd_fecha => pd_fecha,
                                             pc_user => pc_user,
                                              pn_cod => pn_cod,
                                              pn_mod => pn_mod,
                                              pn_suc => pn_suc,
                                              pn_mda => pn_mda,
                                              pn_pap => pn_pap,
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_sbo => pn_sbo,
                                              pn_top => pn_top,
                                              pc_mensaje => lc_mensaje);
       end if;
       if ( ln_cronograma = 1 ) then 
          ln_contador := ln_contador +1;
         lc_mensaje:='Revisar con producción cronograma de crédito';
         pq_cr_ventacarteras.sp_insertaAQPB749L(pd_fecha => pd_fecha,
                                             pc_user => pc_user,
                                              pn_cod => pn_cod,
                                              pn_mod => pn_mod,
                                              pn_suc => pn_suc,
                                              pn_mda => pn_mda,
                                              pn_pap => pn_pap,
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_sbo => pn_sbo,
                                              pn_top => pn_top,
                                              pc_mensaje => lc_mensaje);
       end if; 
       if (ln_EsexoneradoUC=1 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Crédito se encuentra en tabla de Ref exoneración última cuota / Crédito se encuentra en tabla de Rep exoneración última cuota';
         pq_cr_ventacarteras.sp_insertaAQPB749L(pd_fecha => pd_fecha,
                                             pc_user => pc_user,
                                              pn_cod => pn_cod,
                                              pn_mod => pn_mod,
                                              pn_suc => pn_suc,
                                              pn_mda => pn_mda,
                                              pn_pap => pn_pap,
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_sbo => pn_sbo,
                                              pn_top => pn_top,
                                              pc_mensaje => lc_mensaje);
       end if; 
       if (ln_AQPB749CRECAS=1 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Crédito está en propuesta/proceso de castigo.';
         pq_cr_ventacarteras.sp_insertaAQPB749L(pd_fecha => pd_fecha,
                                             pc_user => pc_user,
                                              pn_cod => pn_cod,
                                              pn_mod => pn_mod,
                                              pn_suc => pn_suc,
                                              pn_mda => pn_mda,
                                              pn_pap => pn_pap,
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_sbo => pn_sbo,
                                              pn_top => pn_top,
                                              pc_mensaje => lc_mensaje);
       end if; 
       if (ln_AQPB749ESLINEBLQ=1 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Línea Bloqueada.';
         pq_cr_ventacarteras.sp_insertaAQPB749L(pd_fecha => pd_fecha,
                                             pc_user => pc_user,
                                              pn_cod => pn_cod,
                                              pn_mod => pn_mod,
                                              pn_suc => pn_suc,
                                              pn_mda => pn_mda,
                                              pn_pap => pn_pap,
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_sbo => pn_sbo,
                                              pn_top => pn_top,
                                              pc_mensaje => lc_mensaje);
       end if; 
       if (ln_aqpb749rubl=1 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Inconsistencia en rubros de líneas.';
         pq_cr_ventacarteras.sp_insertaAQPB749L(pd_fecha => pd_fecha,
                                             pc_user => pc_user,
                                              pn_cod => pn_cod,
                                              pn_mod => pn_mod,
                                              pn_suc => pn_suc,
                                              pn_mda => pn_mda,
                                              pn_pap => pn_pap,
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_sbo => pn_sbo,
                                              pn_top => pn_top,
                                              pc_mensaje => lc_mensaje);
       end if;
       if (ln_AQPB749ESLINEAM=1 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Inconsistencia entre saldo del cupo y saldo de utilización.';
         pq_cr_ventacarteras.sp_insertaAQPB749L(pd_fecha => pd_fecha,
                                             pc_user => pc_user,
                                              pn_cod => pn_cod,
                                              pn_mod => pn_mod,
                                              pn_suc => pn_suc,
                                              pn_mda => pn_mda,
                                              pn_pap => pn_pap,
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_sbo => pn_sbo,
                                              pn_top => pn_top,
                                              pc_mensaje => lc_mensaje);
       end if;
       if (ln_AQPB749ESJLINEAM=1 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Inconsistencia en saldos versus cupo.';
         pq_cr_ventacarteras.sp_insertaAQPB749L(pd_fecha => pd_fecha,
                                             pc_user => pc_user,
                                              pn_cod => pn_cod,
                                              pn_mod => pn_mod,
                                              pn_suc => pn_suc,
                                              pn_mda => pn_mda,
                                              pn_pap => pn_pap,
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_sbo => pn_sbo,
                                              pn_top => pn_top,
                                              pc_mensaje => lc_mensaje);
       end if;
        if (ln_aqpb749rublpjm=1 )then
          ln_contador := ln_contador +1;
         lc_mensaje:='Crédito estado 23 no está la línea en el rubro 7.';
         pq_cr_ventacarteras.sp_insertaAQPB749L(pd_fecha => pd_fecha,
                                             pc_user => pc_user,
                                              pn_cod => pn_cod,
                                              pn_mod => pn_mod,
                                              pn_suc => pn_suc,
                                              pn_mda => pn_mda,
                                              pn_pap => pn_pap,
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_sbo => pn_sbo,
                                              pn_top => pn_top,
                                              pc_mensaje => lc_mensaje);
       end if;
       if (ln_aqpb749rubljud =1 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Crédito estado Judicial no está la línea en el rubro 9.';
         pq_cr_ventacarteras.sp_insertaAQPB749L(pd_fecha => pd_fecha,
                                             pc_user => pc_user,
                                              pn_cod => pn_cod,
                                              pn_mod => pn_mod,
                                              pn_suc => pn_suc,
                                              pn_mda => pn_mda,
                                              pn_pap => pn_pap,
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_sbo => pn_sbo,
                                              pn_top => pn_top,
                                              pc_mensaje => lc_mensaje);
       end if;
       if (ln_esmivivienda =1 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Es crédito mi Vivienda';
         pq_cr_ventacarteras.sp_insertaAQPB749L(pd_fecha => pd_fecha,
                                             pc_user => pc_user,
                                              pn_cod => pn_cod,
                                              pn_mod => pn_mod,
                                              pn_suc => pn_suc,
                                              pn_mda => pn_mda,
                                              pn_pap => pn_pap,
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_sbo => pn_sbo,
                                              pn_top => pn_top,
                                              pc_mensaje => lc_mensaje);
       end if; 
       --inicio kvalenciac 26/12/2024
       if (ln_tieneconstancia=1 ) then
         ln_contador := ln_contador +1;
         lc_mensaje:='Tiene constancia impresa o CNA impresa';
         pq_cr_ventacarteras.sp_insertaAQPB749L(pd_fecha => pd_fecha,
                                             pc_user => pc_user,
                                              pn_cod => pn_cod,
                                              pn_mod => pn_mod,
                                              pn_suc => pn_suc,
                                              pn_mda => pn_mda,
                                              pn_pap => pn_pap,
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_sbo => pn_sbo,
                                              pn_top => pn_top,
                                              pc_mensaje => lc_mensaje);
       end if;      
       --fin kvalenciac 26/12/2024
       pn_Indicador :=ln_contador;
       
end sp_validaciones;  
procedure sp_insertaAQPB749L(pd_fecha in date,
                              pc_user in char,
                              pn_cod  in number,
                              pn_mod  in number,
                              pn_suc  in number,
                              pn_mda  in number,
                              pn_pap  in number,
                              pn_cta  in number,
                              pn_ope  in number,
                              pn_sbo  in number,
                              pn_top  in number,
                              pc_mensaje in varchar) is
begin
  ---Actualiza TABLA TEMPORAL de mensajes de error
       insert into aqpb749L
                  (AQPB749LPGC,
                   AQPB749LMOD,
                   AQPB749LSUC,
                   AQPB749LMDA,
                   AQPB749LPAP,
                   AQPB749LCTA,
                   AQPB749LOPE,
                   AQPB749LSBO,
                   AQPB749LTOP,
                   AQPB749LMSG,
                   AQPB749LFECACT,
                   AQPB749LUSUACT )
               values
                   (pn_cod,
                    pn_mod,
                    pn_suc,
                    pn_mda,
                    pn_pap,
                    pn_cta,
                    pn_ope,
                    pn_sbo,
                    pn_top,
                    pc_mensaje,
                    pd_fecha,
                    pc_user
                  );
         commit;
end sp_insertaAQPB749L;                              
                              
function fn_TieneSaldo(pn_cod  in number,
                       pn_mod  in number,
                       pn_suc  in number,
                       pn_mda  in number,
                       pn_pap  in number,
                       pn_cta  in number,
                       pn_ope  in number,
                       pn_sbo  in number,
                       pn_top  in number) return number is
   ln_Tienesaldo number;
   ln_monto number;
  begin
       ln_Tienesaldo:=0;
        begin
        select sum(scsdo) into ln_monto from fsd011 
        where scrub in (9500095000000,9500092000000,9500093000000,9500094000000)
        and sccta= pn_cta
        and scoper=pn_ope;
        exception
          when no_data_found then
              ln_monto :=0;
        end;
        if (ln_monto < 0 ) then
          ln_monto:= ln_monto*-1;
        end if;
        if (ln_monto > 0) then
          ln_Tienesaldo:=1;
        end if;
    return ln_Tienesaldo;
  end fn_TieneSaldo; 
function fn_TieneAcuerdo(pn_cod  in number,
                         pn_mod  in number,
                         pn_suc  in number,
                         pn_mda  in number,
                         pn_pap  in number,
                         pn_cta  in number,
                         pn_ope  in number,
                         pn_sbo  in number,
                         pn_top  in number) return number is
   ln_TieneAcuerdo number;
   ln_cantidad number;
  begin
       ln_TieneAcuerdo:=0;
       ln_cantidad :=0;
        begin
        select count(*) into ln_cantidad 
        from aqpa806 
        where AQPA806PGC = pn_cod
          and AQPA806MOD = pn_mod
          and AQPA806SUC = pn_suc
          and AQPA806MDA = pn_mda
          and AQPA806PAP = pn_pap
          and AQPA806CTA = pn_cta  
          and AQPA806OPE = pn_ope
          and AQPA806SBO = pn_sbo
          and AQPA806TPO = pn_top
          and ( AQPA806EST = 'S' Or AQPA806EST = 'P' );            
        exception
          when no_data_found then
            ln_cantidad :=0;
        end;              
        if (ln_cantidad > 0) then
          ln_TieneAcuerdo:=1;
        end if;
    return ln_TieneAcuerdo;
  end fn_TieneAcuerdo;    
function fn_provision(  pd_FecUltCierre date,
                        pn_saldo number, 
                         pn_cod  in number,
                         pn_mod  in number,
                         pn_suc  in number,
                         pn_mda  in number,
                         pn_pap  in number,
                         pn_cta  in number,
                         pn_ope  in number,
                         pn_sbo  in number,
                         pn_top  in number) return number is
   ln_provision number;
   ln_ProvConstituida number;
   ln_PProvision number;   
  begin
       ln_provision:=0;
        begin
        select /*+index(FSH012 FSH01204)*/ sum(bcsdmo) into ln_provision ---BCEMP, BCFECH, BCRUBR, BCCTA
             from fsh012 
             where BCEMP=1 
             and bcfech = pd_FecUltCierre 
             and BCRUBR in ( select rubro
                          from fsd014
                         where pcnivc in (404))
             and bccta  = pn_cta
             and bcoper = pn_ope
             and bcmda  = pn_mda;
            -- and bcmod  = 404; 
        exception
          when no_data_found then
            ln_provision :=0;
        end;
        begin
        ln_ProvConstituida :=0;
        select /*+index(FSH012 FSH01204)*/ sum(bcsdmo) into ln_ProvConstituida 
             from fsh012 
             where BCEMP=1 
             and bcfech = pd_FecUltCierre 
             and BCRUBR in ( select rubro
                          from fsd014
                         where pcnivc in (419))
             and bccta  = pn_cta
             and bcoper = pn_ope
             and bcmda  = pn_mda; 
             --and bcmod  = 419; 
        exception
          when no_data_found then
            ln_ProvConstituida :=0;
        end;
        if ( ln_provision is null ) then
           ln_provision :=0;
        end if;
        if ( ln_ProvConstituida is null ) then
           ln_ProvConstituida :=0;
        end if;
        if ((pn_saldo-ln_ProvConstituida)>0) then 
         ln_PProvision := round(( ln_provision / (pn_saldo-ln_ProvConstituida) ) * 100 ,2);                      
        else
          ln_PProvision :=0;
        end if;
    return ln_PProvision;
end fn_provision;
procedure sp_Calificacion( pd_FecUltCierre date,
                         pn_cod  in number,
                         pn_mod  in number,
                         pn_suc  in number,
                         pn_mda  in number,
                         pn_pap  in number,
                         pn_cta  in number,
                         pn_ope  in number,
                         pn_sbo  in number,
                         pn_top  in number,
                         pn_Califiacion out number,
                         pv_calificacion out varchar
                         ) is
   ln_Califiacion number;
   ln_ncal number;
   lv_bccate varchar(15);
  begin
    ln_Califiacion:=0;
    begin
        select /*+index(FSH012 FSH01204)*/ bccate into lv_bccate
             from fsh012 
             where BCEMP = pn_cod 
             and bcfech  = pd_FecUltCierre 
              and BCRUBR in ( select rubro
                          from fsd014
                         where pcnivc in (select MODULO
                                            from fst111
                                           Where Dscod = 50
                                             and Modulo <> 29
                                             and Modulo <> 120
                                             and Modulo <> 144))
             and bccta  = pn_cta
             and bcoper = pn_ope
             and bcmda  = pn_mda 
           --  and bccate like '4%'
             and rownum=1;
        exception
          when no_data_found then
            lv_bccate :='';
        end; 
        ln_Califiacion:=0;
        if ( lv_bccate is not null ) then
          ln_ncal:= to_number(substr(lv_bccate,0,1));
          --select to_number(substr(lv_bccate,0,1)) into ln_ncal from dual;
          if ( ln_ncal <> 4 ) then            
             ln_Califiacion:=1; -- Su califaición es diferente de pérdida 
          end if;
        end if;
        pn_Califiacion  :=ln_Califiacion;
        pv_calificacion :=lv_bccate;
end sp_Calificacion;  
function fn_GarantiaR( pn_cod  in number,
                       pn_mod  in number,
                       pn_suc  in number,
                       pn_mda  in number,
                       pn_pap  in number,
                       pn_cta  in number,
                       pn_ope  in number,
                       pn_sbo  in number,
                       pn_top  in number) return number is
   ln_TieneGarantiaR number;
   ln_contador number;
   ln_instancia number;
   ln_instanciaL number;
   ln_eslinea number;
   pn_codl number;
   pn_sucl number;
   pn_modl number;
   pn_mdal number;
   pn_papl number;
   pn_ctal number;
   pn_opel number;
   pn_sbol number;
   pn_topl number;
  begin
    ln_TieneGarantiaR:=0;
    --busco instancia del crédito
    begin
      select max(XWFPRCINS) into ln_instancia
      from xwf700 
      where XWFEMPRESA  = pn_cod
        and XWFSUCURSAL = pn_suc 
        and XWFMODULO   = pn_mod
        and XWFMONEDA   = pn_mda
        and XWFPAPEL    = pn_pap
        and XWFCUENTA   = pn_cta
        and XWFOPERACION= pn_ope
        and XWFSUBOPE   = pn_sbo
        and XWFTIPOPE   = pn_top
        and xwFcar3 = '1';
    exception 
      when no_data_found then
          ln_instancia:=0;
    end;
    begin
      select count(*) into  ln_contador
      from fsr011
      where R1COD = pn_cod
        and R1MOD = pn_mod
        and R1SUC = pn_suc
        and R1MDA = pn_mda
        and R1PAP = pn_pap
        and R1CTA = pn_cta
        and R1OPER= pn_ope
        and R1SBOP= pn_sbo
        and R1TOPE= pn_top
        and RELCOD = 50
        and (R2MOD, R2TOPE) in (select tp1nro1,tp1nro2 from Fst198
                                Where Tp1cod=1
                                and Tp1cod1=10897
                                and Tp1corr1=500
                                and Tp1corr2=1); ---tpnro1=módulo y tp1nro2=tipo de operación
     exception
       when no_data_found then
          ln_contador :=0;
     end;
     if (ln_contador=0) then
         begin
          select count(*) into ln_contador
          from sng122
          where sng122inst=ln_instancia
          and (sng122mod,sng122tope) in (select tp1nro1,tp1nro2 from Fst198
                                Where Tp1cod=1
                                and Tp1cod1=10897
                                and Tp1corr1=500
                                and Tp1corr2=1)
          order by sng122inst;
          exception
             when no_data_found then
               ln_contador:=0;
          end;
     end if;
     -- kvalenciac 20/09/2022
     if (ln_contador=0) then --si es línea
       begin
       select 1,
              d.R2COD, 
              d.R2MOD,
              d.R2SUC, 
              d.R2MDA, 
              d.R2PAP, 
              d.R2CTA, 
              d.R2OPER,
              d.R2SBOP,
              d.R2TOPE
              into 
              ln_eslinea,
              pn_codl,
              pn_modl,
              pn_sucl,
              pn_mdal,
              pn_papl,
              pn_ctal,
              pn_opel,
              pn_sbol,
              pn_topl                            
        from fsr011 d                                    
        where d.R1COD  = pn_cod
          and d.R1MOD  = pn_mod
          and d.R1SUC  = pn_suc 
          and d.R1MDA  = pn_mda
          and d.R1PAP  = pn_pap
          and d.R1CTA  = pn_cta
          and d.R1OPER = pn_ope
          and d.R1SBOP = pn_sbo
          and d.R1TOPE = pn_top
          and d.RELCOD  = 46
          and rownum=1;
        exception
                 when no_data_found then
                   ln_eslinea :=0;
        end;  
        if (ln_eslinea=1) then
          begin 
          select max(XWFPRCINS) into ln_instanciaL
          from xwf700 
          where XWFEMPRESA  = pn_codl
            and XWFSUCURSAL = pn_sucl
            and XWFMODULO   = pn_modl
            and XWFMONEDA   = pn_mdal
            and XWFPAPEL    = pn_papl
            and XWFCUENTA   = pn_ctal
            and XWFOPERACION= pn_opel
            and XWFSUBOPE   = pn_sbol
            and XWFTIPOPE   = pn_topl
            and xwFcar3 = '1';
          exception
                 when no_data_found then
                   ln_instanciaL :=0;
          end;
           begin
              select count(*) into ln_contador
              from sng122
              where sng122inst=ln_instanciaL
              and (sng122mod,sng122tope) in (select tp1nro1,tp1nro2 from Fst198
                                    Where Tp1cod=1
                                    and Tp1cod1=10897
                                    and Tp1corr1=500
                                    and Tp1corr2=1)
              order by sng122inst;
              exception
                 when no_data_found then
                   ln_contador:=0;
              end;           
               if (ln_contador=0) then
                  begin
                    select count(*) into  ln_contador
                    from fsr011
                    where R1COD = pn_codl
                      and R1MOD = pn_modl
                      and R1SUC = pn_sucl
                      and R1MDA = pn_mdal
                      and R1PAP = pn_papl
                      and R1CTA = pn_ctal
                      and R1OPER= pn_opel
                      and R1SBOP= pn_sbol
                      and R1TOPE= pn_topl
                      and RELCOD = 50
                      and (R2MOD, R2TOPE) in (select tp1nro1,tp1nro2 from Fst198
                                              Where Tp1cod=1
                                              and Tp1cod1=10897
                                              and Tp1corr1=500
                                              and Tp1corr2=1); ---tpnro1=módulo y tp1nro2=tipo de operación
                   exception
                     when no_data_found then
                        ln_contador :=0;
                   end;
               end if;
            end if;
     end if;
     --kvalenciac 20/09/2022
      if (ln_contador >0) then
        ln_TieneGarantiaR:=1;
      end if;
      return ln_TieneGarantiaR;
end fn_GarantiaR; 
function fn_Cronograma( pn_cod  in number,
                       pn_mod  in number,
                       pn_suc  in number,
                       pn_mda  in number,
                       pn_pap  in number,
                       pn_cta  in number,
                       pn_ope  in number,
                       pn_sbo  in number,
                       pn_top  in number) return number is
   ln_contador number;
   ln_saldo number;
   ln_cuota number;
  begin
    if  ( pn_mod <> 200 and pn_mod <> 33 and pn_top<>550 ) then
    
      begin
              select abs(scsdo) into ln_saldo
              from fsd011
              where PGCOD = pn_cod
              and   SCMOD = pn_mod
              and   SCMDA = pn_mda  
              and   SCPAP = pn_pap
              and   SCCTA = pn_cta
              and   SCSUC = pn_suc 
              and   SCOPER= pn_ope
              and  SCSBOP = pn_sbo
              and  SCTOPE = pn_top;  --PGCOD, SCMOD, SCMDA, SCPAP, SCCTA, SCSUC, SCOPER, SCSBOP, SCTOPE
            exception
             when no_data_found then
                        ln_saldo :=0;
            end;
---    Call('sp_valor_cuota_impaga',&Pgcod,&Modulo,&Itsucd,&Moneda,&Papel,&ctnro,&Itoper,&Itsubo,&Ittope,&cuota)
    sp_valor_cuota_impaga(                pn_emp => pn_cod,
                                          pn_mod => pn_mod,
                                          pn_suc => pn_suc,
                                          pn_mda => pn_mda,
                                          pn_pap => pn_pap,
                                          pn_cta => pn_cta,
                                          pn_oper => pn_ope,
                                          pn_sbop => pn_sbo,
                                          pn_top => pn_top, 
                                          ln_cuota => ln_cuota );                                          
      
      if (ln_saldo <> ln_cuota ) then
        ln_contador:=1;
      else 
         ln_contador:=0;
      end if;
   else
      ln_contador:=0;
   end if;
      return ln_contador;
end fn_Cronograma; 

function fn_Esexonerado( pn_cod  in number,
                         pn_mod  in number,
                         pn_suc  in number,
                         pn_mda  in number,
                         pn_pap  in number,
                         pn_cta  in number,
                         pn_ope  in number,
                         pn_sbo  in number,
                         pn_top  in number) return number is
   ln_Esexonerado number;
   ln_existe number;
    maxf_fsd601 date;
    maxf_fsd602 date;
  begin
       ln_Esexonerado:=0;       
       begin 
         select 1 into ln_existe 
         from aqpb411
         where AQPB411COD= pn_cod 
           and AQPB411MOD= pn_mod 
           and AQPB411SUC= pn_suc 
           and AQPB411MDA= pn_mda 
           and AQPB411PAP= pn_pap 
           and AQPB411CTA= pn_cta 
           and AQPB411OPE= pn_ope 
           and AQPB411SBO= pn_sbo 
           and AQPB411TPO= pn_top 
           and AQPB411EST='P'
           and rownum=1;
        exception
          when no_data_found then
            begin
             select 1 into ln_existe 
             from aqpb408
             where aqpb408COD= pn_cod 
               and aqpb408MOD= pn_mod 
               and aqpb408SUC= pn_suc 
               and aqpb408MDA= pn_mda 
               and aqpb408PAP= pn_pap 
               and aqpb408CTA= pn_cta 
               and aqpb408OPE= pn_ope 
               and aqpb408SBO= pn_sbo 
               and aqpb408TPO= pn_top 
               and aqpb408EST='C'
               and rownum=1;
             exception
                 when no_data_found then
                      ln_existe:=0;
             end;
        end;  
        if ( ln_existe >0 )then --verifico si solo debe una cuota  
            begin
            select  max(ppfpag) into maxf_fsd601 
            from fsd601  s
            where s.pgcod = pn_cod 
              and s.ppmod = pn_mod 
              and s.ppsuc = pn_suc  
              and s.ppmda = pn_mda  
              and s.pppap = pn_pap  
              and s.ppcta = pn_cta  
              and s.ppoper= pn_ope 
              and s.ppsbop= pn_sbo 
              and s.pptope= pn_top     
              and ppfpag not in (select max(ppfpag) from fsd601  f
                                      where f.pgcod = pn_cod 
                                        and f.ppmod = pn_mod 
                                        and f.ppsuc = pn_suc 
                                        and f.ppmda = pn_mda 
                                        and f.pppap = pn_pap 
                                        and f.ppcta = pn_cta 
                                        and f.ppoper= pn_ope 
                                        and f.ppsbop= pn_sbo 
                                        and f.pptope= pn_top);
            exception 
                when others then
                  maxf_fsd601:=null;
            end;
            begin
            select max(ppfpag) into maxf_fsd602 
            from fsd602  s
            where s.pgcod = pn_cod 
              and s.ppmod = pn_mod 
              and s.ppsuc = pn_suc  
              and s.ppmda = pn_mda  
              and s.pppap = pn_pap  
              and s.ppcta = pn_cta  
              and s.ppoper= pn_ope 
              and s.ppsbop= pn_sbo 
              and s.pptope= pn_top     
              and  Pp1stat = 'T' and D602co = 'S' and Pp1cap+Pp1int<>0;
             exception 
                when others then
                  maxf_fsd602:=null;
            end;
    end if;
    if (maxf_fsd601=maxf_fsd602) then
      ln_Esexonerado:=1;
    end if;                    
    return ln_Esexonerado;
  end fn_Esexonerado;
function fn_EstaEnCAstigo( pd_fecha in date,
                           pn_cod  in number,
                           pn_mod  in number,
                           pn_suc  in number,
                           pn_mda  in number,
                           pn_pap  in number,
                           pn_cta  in number,
                           pn_ope  in number,
                           pn_sbo  in number,
                           pn_top  in number) return number is
   ln_estaencastigo number;
   ln_contador number;
  begin
    ln_estaencastigo:=0;
    --busco instancia del crédito
    begin      
    select count(*) into ln_contador 
    from JAQL174 j
    inner join JAQL175 l on j.jaql174nro=l.jaql174nro
    Where JAQL174EST = 1
    and l.JAQL175EMP = pn_cod
    and l.JAQL175SUC = pn_suc 
    and l.JAQL175CTA = pn_cta
    and l.JAQL175PAP = pn_pap 
    and l.JAQL175OPE = pn_ope
    and l.JAQL175SBO = pn_sbo 
    and l.JAQL175MDA = pn_mda 
    and l.JAQL175MOD = pn_mod 
    and l.JAQL175TOP = pn_top;
    exception 
       when others then
         begin
           select count(*) into ln_contador 
            from JAQL174 j
            inner join JAQL175 l on j.jaql174nro=l.jaql174nro
            Where l.JAQL175EMP = pn_cod
            and l.JAQL175SUC = pn_suc 
            and l.JAQL175CTA = pn_cta
            and l.JAQL175PAP = pn_pap 
            and l.JAQL175OPE = pn_ope
            and l.JAQL175SBO = pn_sbo 
            and l.JAQL175MDA = pn_mda 
            and l.JAQL175MOD = pn_mod 
            and l.JAQL175TOP = pn_top
            and j.JAQL174EST = 2
            and ( l.JAQL175FCA = pd_fecha or l.JAQL175ITC = ' ' );
         exception
           when others then
             ln_contador:=0;
         end;

    end;
    if (ln_contador >0) then
        ln_estaencastigo:=1;
    end if;
    return ln_estaencastigo;
end fn_EstaEnCAstigo;
procedure sp_verificar_líneas(pd_fecha in date,
                              pn_cod  in number,
                              pn_mod  in number,
                              pn_suc  in number,
                              pn_mda  in number,
                              pn_pap  in number,
                              pn_cta  in number,
                              pn_ope  in number,
                              pn_sbo  in number,
                              pn_top  in number,
                              pn_LineaSaldomenor out number,
                              pn_Ldescuadrada out number,
                              pn_Lbloqueada out number, 
                              pn_Lrubros out number,
                              pn_Lrubnopjm out number,
                              pn_Lrubnojud out number ) is
  ln_contador number; 
  lc_lprub varchar(5); 
  ln_lprub number;  
  ln_R2COD number;
  ln_R2MOD number;
  ln_R2SUC number;
  ln_R2MDA number;
  ln_R2PAP number;
  ln_R2CTA number;
  ln_R2OPER number;
  ln_R2SBOP number;
  ln_R2TOPE number;
  ln_scsdo116 number;
  ln_scsdo117 number;
  ln_aostat number;  
  ln_saldolc number; 
  ln_estado number; 
  ln_LCOD number;
  ln_LMOD number;
  ln_LSUC number;
  ln_LMDA number;
  ln_LPAP number;
  ln_LCTA number;
  ln_LOPER number;
  ln_LSBOP number;
  ln_LTOPE number; 
  ln_existemasde1 number; 
  ln_contador442 number;
  ln_contador443 number;       
  begin
     --valida saldo de línea 117 es menor al saldo de linea módulo 116       
     if ( pn_mod=200 or pn_top=550 or pn_mod=33 ) then          
          begin 
            select 
                  r.R1COD, 
                  r.R1MOD, 
                  r.R1SUC, 
                  r.R1MDA, 
                  r.R1PAP, 
                  r.R1CTA, 
                  r.R1OPER,
                  r.R1SBOP,
                  r.R1TOPE  
                  into
                  ln_R2COD, 
                  ln_R2MOD, 
                  ln_R2SUC, 
                  ln_R2MDA, 
                  ln_R2PAP, 
                  ln_R2CTA, 
                  ln_R2OPER,
                  ln_R2SBOP,
                  ln_R2TOPE
            from fsr011 r
          where r.R2COD   = pn_cod
            and r.R2MOD   = pn_mod
            and r.R2SUC   = pn_suc  
            and r.R2MDA   = pn_mda  
            and r.R2PAP   = pn_pap  
            and r.R2CTA   = pn_cta
            and r.R2OPER  = pn_ope
            and r.R2SBOP  = pn_sbo
            and r.R2TOPE  = pn_top
            and r.RELCOD  = 52; --  R2COD, R2MOD, R2SUC, R2MDA, R2PAP, R2CTA, R2OPER, R2SBOP, R2TOPE, RELCOD;--relación 52 para sacar el crédito original  cuando pasa a judicial o castigado
          exception
             when no_data_found then
                        ln_R2CTA :=0;
                        ln_R2MOD :=0;
          end;
     else
         if ( pn_mod = 116 ) then
           ln_R2COD := pn_cod;
           ln_R2MOD := pn_mod;
           ln_R2SUC := pn_suc;
           ln_R2MDA := pn_mda;
           ln_R2PAP := pn_pap;
           ln_R2CTA := pn_cta;
           ln_R2OPER:= pn_ope;
           ln_R2SBOP:= pn_sbo;
           ln_R2TOPE:= pn_top;
         end if;
     end if;
     if ( ln_R2MOD=116) then
            ln_scsdo116:=0;
            begin
              select abs(scsdo),scstat into ln_scsdo116,ln_estado
              from fsd011
              where PGCOD = pn_cod
              and   SCMOD = pn_mod
              and   SCMDA = pn_mda  
              and   SCPAP = pn_pap
              and   SCCTA = pn_cta
              and   SCSUC = pn_suc 
              and   SCOPER= pn_ope
              and  SCSBOP = pn_sbo
              and  SCTOPE = pn_top;  --PGCOD, SCMOD, SCMDA, SCPAP, SCCTA, SCSUC, SCOPER, SCSBOP, SCTOPE
            exception
             when no_data_found then
                        ln_scsdo116 :=0;
            end;                  
            ln_scsdo117:=0;
            ln_existemasde1 :=0;
            begin  -- este para ver si tiene doble cabecera
               select count(*) into ln_existemasde1                
                from fsd011  s
                inner join fsr011 d on d.R2COD    = s.pgcod
                                    and d.R2MOD   = s.scmod
                                    and d.R2SUC   = s.scsuc
                                    and d.R2MDA   = s.scmda
                                    and d.R2PAP   = s.scpap
                                    and d.R2CTA   = s.sccta
                                    and d.R2OPER  = s.scoper
                                    and d.R2SBOP  = s.scsbop
                                    and d.R2TOPE  = s.sctope
                                    and d.RELCOD  = 46 --- esta relación es para sacar la línea 117  según el estado en el qeu se enuentre siempre debe buscarlo 
                where d.R1COD = ln_R2COD
                and d.R1MOD   = ln_R2MOD
                and d.R1SUC   = ln_R2SUC
                and d.R1MDA   = ln_R2MDA
                and d.R1PAP   = ln_R2PAP
                and d.R1CTA   = ln_R2CTA
                and d.R1OPER  = ln_R2OPER
                and d.R1SBOP  = ln_R2SBOP
                and d.R1TOPE  = ln_R2TOPE;
             exception
             when no_data_found then
                        ln_existemasde1 :=0;    
            end;
            ---solo para obtener el saldo de la cabacera de la línea módulo 117
             begin
               select sum(abs(scsdo))
                into ln_scsdo117             
                from fsd011  s
                inner join fsr011 d on d.R2COD    = s.pgcod
                                    and d.R2MOD   = s.scmod
                                    and d.R2SUC   = s.scsuc
                                    and d.R2MDA   = s.scmda
                                    and d.R2PAP   = s.scpap
                                    and d.R2CTA   = s.sccta
                                    and d.R2OPER  = s.scoper
                                    and d.R2SBOP  = s.scsbop
                                    and d.R2TOPE  = s.sctope
                                    and d.RELCOD  = 46 --- esta relación es para sacar la línea 117  según el estado en el qeu se enuentre siempre debe buscarlo 
                where d.R1COD = ln_R2COD
                and d.R1MOD   = ln_R2MOD
                and d.R1SUC   = ln_R2SUC
                and d.R1MDA   = ln_R2MDA
                and d.R1PAP   = ln_R2PAP
                and d.R1CTA   = ln_R2CTA
                and d.R1OPER  = ln_R2OPER
                and d.R1SBOP  = ln_R2SBOP
                and d.R1TOPE  = ln_R2TOPE;
              exception
             when no_data_found then
                        ln_scsdo117 :=0;
            end;  
            ---------------------------------------------
            begin
               select scstat,s.scrub,
                      s.pgcod,
                      s.scmod,
                      s.scsuc,
                      s.scmda,
                      s.scpap,
                      s.sccta,
                      s.scoper,
                      s.scsbop,
                      s.sctope
                into ln_aostat,ln_lprub,
                      ln_LCOD,
                      ln_LMOD ,
                      ln_LSUC, 
                      ln_LMDA,
                      ln_LPAP,
                      ln_LCTA,
                      ln_LOPER,
                      ln_LSBOP,
                      ln_LTOPE                
                from fsd011  s
                inner join fsr011 d on d.R2COD    = s.pgcod
                                    and d.R2MOD   = s.scmod
                                    and d.R2SUC   = s.scsuc
                                    and d.R2MDA   = s.scmda
                                    and d.R2PAP   = s.scpap
                                    and d.R2CTA   = s.sccta
                                    and d.R2OPER  = s.scoper
                                    and d.R2SBOP  = s.scsbop
                                    and d.R2TOPE  = s.sctope
                                    and d.RELCOD  = 46 --- esta relación es para sacar la línea 117  según el estado en el qeu se enuentre siempre debe buscarlo 
                where d.R1COD = ln_R2COD
                and d.R1MOD   = ln_R2MOD
                and d.R1SUC   = ln_R2SUC
                and d.R1MDA   = ln_R2MDA
                and d.R1PAP   = ln_R2PAP
                and d.R1CTA   = ln_R2CTA
                and d.R1OPER  = ln_R2OPER
                and d.R1SBOP  = ln_R2SBOP
                and d.R1TOPE  = ln_R2TOPE
                and rownum=1;
             exception
             when no_data_found then
                        ln_scsdo117 :=0;
                        ln_aostat :=0;
                        lc_lprub :='';
            end;
            --lc_lprub := concat(concat(concat(substr(to_char(ln_lprub),0,1),'_'),substr(to_char(ln_lprub),3,2)),'%');
            lc_lprub := concat(substr(to_char(ln_lprub),0,1),'%');
            begin
                select count(*), sum(abs(scsdo)) into ln_contador, ln_saldolc
                  from fsd011
                  where PGCOD = ln_LCOD
                  and   SCMOD in ( 442,443) 
                  and   SCMDA = ln_LMDA
                  and   SCPAP = ln_LPAP
                  and   SCCTA = ln_LCTA
                  and   SCSUC = ln_LSUC
                  and   SCOPER= ln_LOPER
                  and   SCSBOP = ln_LSBOP
                --and   SCTOPE = ln_LTOPE
                  and   scrub like lc_lprub;
             exception
             when no_data_found then
                        ln_contador :=0; 
                        ln_saldolc :=0;
             end;
            
            begin
                select count(*) into ln_contador442
                  from fsd011
                  where PGCOD = ln_LCOD
                  and   SCMOD in ( 442 ) 
                  and   SCMDA = ln_LMDA
                  and   SCPAP = ln_LPAP
                  and   SCCTA = ln_LCTA
                  and   SCSUC = ln_LSUC
                  and   SCOPER= ln_LOPER
                  and  SCSBOP = ln_LSBOP
                 -- and  SCTOPE = ln_LTOPE
                  and scrub not like lc_lprub;
             exception
             when no_data_found then
                        ln_contador442 :=0;
             end;
             begin
                select count(*) into ln_contador443
                  from fsd011
                  where PGCOD = ln_LCOD
                  and   SCMOD in ( 443 ) 
                  and   SCMDA = ln_LMDA
                  and   SCPAP = ln_LPAP
                  and   SCCTA = ln_LCTA
                  and   SCSUC = ln_LSUC
                  and   SCOPER= ln_LOPER
                  and  SCSBOP = ln_LSBOP
                 -- and  SCTOPE = ln_LTOPE
                  and scrub not like lc_lprub;
             exception
             when no_data_found then
                        ln_contador442 :=0;
             end;
             
            if (ln_aostat = 7 or ln_aostat=9) then --si está la línea bloqueada
               pn_Lbloqueada :=1;
            end if ;          
            if ( ln_scsdo117 < ln_scsdo116 ) then-- si saldo de línea es menor al saldo de la línea usada
               pn_LineaSaldomenor:=1;
           end if; 
           if ( ln_contador <> 2 or ln_existemasde1>1 or ln_contador442>0 or ln_contador443>0 ) then --si los contigentes no tienen el mismo rubro que el de la 117
              pn_Lrubros:=1;
           end if;   
           if ( ln_scsdo117 <> ln_saldolc ) then --si son líneas descuadrada
              pn_Ldescuadrada:=1;
           end if;
           if ( ln_estado=21 or ln_estado=23 ) then--si estado del crédito es 21->PJM  23->PJA
             if ( lc_lprub = '7%' and ln_contador=2 ) then--valido que tanto la lina 117 y sus contingentes esten en 72_5%  '7_15%'
               pn_Lrubnopjm:=0;
             else
               pn_Lrubnopjm:=1;
             end if;
           end if;
           if ( ln_estado=64 ) then--si estado de credito es judicial y castigado
             if ( lc_lprub = '9%' and ln_contador=2 ) then --valido que tanto la lina 117 y sus contingentes esten en 92_0%'
               pn_Lrubnojud:=0;
             else
               pn_Lrubnojud:=1;
             end if;
           end if;

        end if;   
   
end sp_verificar_líneas; 
--mod@kdvc  2019.09.06  
 Procedure Sp_MiVivienda(pn_emp in number,
                         pn_cta in number,
                         pn_ope in number,
                         pn_suc in number,
                         pn_pap in number,
                         pn_sbop in number,
                         pn_mda in number,
                         pn_mod in number,
                         pn_top in number,                         
                         pn_flg out number)is
 ln_mod number(3);
 Begin
       pn_flg := 0;
       begin
              select r1mod
                into ln_mod 
              from fsr011 
              where 
                  R2COD = pn_emp
              and R2MOD = pn_mod
              and R2SUC = pn_suc
              and R2MDA  = pn_mda              
              and R2PAP  = pn_pap             
              and R2CTA  = pn_cta
              and R2OPER = pn_ope
              and R2SBOP = pn_sbop
              and R2TOPE = pn_top
              and relcod = 52
              and r011co = 'S'; 
       exception
          when others then null;
       end;       
       if ln_mod = 111 or pn_mod=111 then
            pn_flg := 1;
          else
             pn_flg := 0;
       end if;
       
 end Sp_MiVivienda;
 --fin mod@kdvc  2019.09.06 
 --inicio kvalencia 26/12/2024
  Procedure Sp_constancia( pn_emp in number,
                           pn_cta in number,
                           pn_ope in number,
                           pn_suc in number,
                           pn_pap in number,
                           pn_sbop in number,
                           pn_mda in number,
                           pn_mod in number,
                           pn_top in number,                         
                           pn_flg out number,
                           pd_fecha out date)is
 ln_flg number(2);
 ld_fecha date;
 Begin
       pn_flg := 0;
       ln_flg:=0;
       begin
              select 1,aqpb608fec
                into ln_flg, ld_fecha 
              from aqpb608 
              where  AQPB608PGCODC = pn_emp
              and AQPB608MONC  = pn_mda              
              and AQPB608PAPC  = pn_pap             
              and aqpb608ctac  = pn_cta
              and aqpb608opec  = pn_ope
              and ( aqpb608fimp='S' or AQPB608FIMPCNA = 'S')
              and rownum=1
              order by aqpb608fec desc; 
       exception
          when others then null;
       end;       
       if ( ln_flg = 0 ) then
         begin
          select 1,JAQL845FEPRO 
          into ln_flg, ld_fecha
          from jaql845 
          where JAQL845CTA = pn_cta
             and JAQL845OPE = pn_ope
             and jaql845flcema= 1 
             and rownum=1
             order by JAQL845FEPRO desc;
          exception
            when others then null;
          end;
       end if;
       if ( ln_flg = 0 ) then
         begin
          select 1,JAQL845WFEPRO 
          into ln_flg, ld_fecha
          from jaql845w 
          where  JAQL845WCTA = pn_cta
             and JAQL845WOPE = pn_ope
               and rownum=1
             order by JAQL845WFEPRO desc;
          exception
            when others then null;
          end;
       end if;
       if ( ln_flg > 0 ) then
         pn_flg  := 1;
         pd_fecha:= ld_fecha;
       else
         pn_flg  := 0;
         pd_fecha:= null;
       end if;
 end Sp_constancia;
 --fin kvalencia 26/12/2024
procedure sp_Cabecera(pc_uing in varchar2, 
                              pn_codemp in number,
                              pn_grupo  in number, --número de grupo
                              pn_nroprop in number,
                              pn_dias in number,
                              pn_monto in number,                              
                              dn_nvio   out number) is
  
    ln_nvio    number;
    ld_fecha   date;
    lc_hora    char(8);
    lc_usuario char(10);
    lc_nomb  char(70); 
    ln_grupo number;
  Begin  
   /* if (pn_grupo = 0 ) then
      select max(jaqy952gru) into ln_grupo from jaqy952;
      ln_grupo :=ln_grupo+1;
    else
      ln_grupo :=pn_grupo;
    end if;*/
    Begin
      select max(jaqy952nro) into ln_nvio from jaqy952; --from jaqy952_VC1;
    End;
  
    If ln_nvio is null then
      ln_nvio := 1;
    Else
      ln_nvio := ln_nvio + 1;
    End If;   
    select to_date(sysdate, 'dd/mm/rrrr') into ld_fecha from dual;
    select to_char(sysdate, 'hh24:mi:ss') into lc_hora from dual;
  
    lc_usuario := Upper(pc_uing);
     
    --insert into JAQY952_VC1 (JAQY952NRO, JAQY952FEC, JAQY952EST, JAQY952ESD, JAQY952AUT, JAQY952ESO, JAQY952CNT, JAQY952USR, JAQY952HOR, JAQY952ATR, JAQY952SDO, JAQY952CAD, JAQY952NAD, JAQY952FEV, JAQY952MOD, JAQY952TOP, JAQY952GRU)
    insert into JAQY952
      (JAQY952NRO,
       JAQY952FEC,
       JAQY952EST,
       JAQY952ESD,
       JAQY952AUT,
       JAQY952ESO,
       JAQY952CNT,
       JAQY952USR,
       JAQY952HOR,
       JAQY952ATR,
       JAQY952SDO,
       --JAQY952CAD,
       --JAQY952NAD,
       JAQY952FEV,
       JAQY952MOD,
       JAQY952TOP,
       JAQY952GRU)
    values
      (ln_nvio,
       ld_fecha,
       'P',
       'PROPUESTA ',
       '',
       1,
       null,
       lc_usuario,
       lc_hora,
       pn_dias ,
       pn_monto,
       --pn_codemp, --esto se llenará con la ejecución de la vinculación de garantía
       --lc_nomb,
       null,
       null,
       null,
        0);-- ln_grupo);
    Commit;
    begin
      pq_cr_ventacarteras.sp_Inserta_Detalle(ln_nvio, pn_dias, pn_monto);    
    end;    
  end sp_Cabecera;
Procedure sp_Inserta_Detalle(pn_nvio in number, pn_dias in number,
                              pn_monto in number ) is
    cursor cur_venta is
      Select pn_nvio JAQY952NRO,
             a.aqpb749pgc JAQY953EMP,
             a.aqpb749suc JAQY953SUC,
             a.aqpb749cta JAQY953CTA,
             a.aqpb749pap JAQY953PAP,
             a.aqpb749ope JAQY953OPE,
             a.aqpb749sbo JAQY953SBO,
             a.aqpb749mda JAQY953MDA,
             a.aqpb749mod JAQY953MOD,
             a.aqpb749top JAQY953TOP,
             e.scstat     JAQY953STA,
             l.jaql964dia JAQY953ATR,
             abs(e.scsdo)      JAQY953SMN,
             d.pepais     JAQY953PAIS,
             d.pendoc     JAQY953NDOC,
             d.petdoc     JAQY953TDOC,
             'S'          JAQY953VIG,
             e.scrub      JAQY953RUB
        FROM AQPB749 a        
       inner join fsd011 e on e.pgcod  = a.aqpb749pgc
                          and e.scmod  = a.aqpb749mod
                          and e.scmda  = a.aqpb749mda
                          and e.scpap  = a.aqpb749pap
                          and e.sccta  = a.aqpb749cta
                          and e.scsuc  = a.aqpb749suc
                          and e.scoper = a.aqpb749ope
                          and e.scsbop = a.aqpb749sbo
                          and e.sctope = a.aqpb749top
        inner join  fsr008 d on  d.ctnro = a.aqpb749cta
                                 and d.cttfir = 'T'
                                 and d.ttcod = 1                   
        inner join jaql964 l on l.JAQL964PGCOD  = a.aqpb749pgc --  JAQL964PGCOD, JAQL964SUC, JAQL964CTA, JAQL964PAP, JAQL964OPE, JAQL964SOB, JAQL964MDA, JAQL964MOD, JAQL964TOP
                          and l.JAQL964SUC  = a.aqpb749suc
                          and l.JAQL964CTA  = a.aqpb749cta
                          and l.JAQL964PAP  = a.aqpb749pap
                          and l.JAQL964OPE = a.aqpb749ope;                        
         
    ln_cta    NUMBER(9);
    ln_mod    NUMBER(4);
    ln_mda    NUMBER(3);
    ln_oper   NUMBER(9);
    i         number := 1;
    ln_nro    number;
    ln_emp    number;
    ln_pap    number;
    lc_vig    char(1);
    lc_ob2    varchar2(50);
    lc_cod2   number := 2;
  BEGIN
    ln_nro := pn_nvio; 
    delete JAQY953_AUX;
    commit;   
    For i in cur_venta loop
        ln_emp := 1;
        ln_pap := 0;
        lc_vig := 'S';
         if ( i.JAQY953SMN <= pn_monto and i.JAQY953ATR >= pn_dias ) then
               begin       
                  insert into JAQY953
                    ("JAQY952NRO",
                     "JAQY953EMP",
                     "JAQY953SUC",
                     "JAQY953CTA",
                     "JAQY953PAP",
                     "JAQY953OPE",
                     "JAQY953SBO",
                     "JAQY953MDA",
                     "JAQY953MOD",
                     "JAQY953TOP",
                     "JAQY953STA",
                     "JAQY953ATR",
                    -- "JAQY953CAP",
                    -- "JAQY953INT",
                    -- "JAQY953MOR",
                    -- "JAQY953OTR",
                     "JAQY953SMN",
                     "JAQY953PAIS",
                     "JAQY953NDOC",
                     "JAQY953TDOC",
                     "JAQY953VIG",
                     "JAQY953RUB",
                     "JAQY953TPRO")
                  values
                    (ln_nro,
                     ln_emp,
                     i.JAQY953SUC,
                     i.JAQY953CTA,
                     ln_pap,
                     i.JAQY953OPE,
                     i.JAQY953SBO,
                     i.JAQY953MDA,
                     i.JAQY953MOD,
                     i.JAQY953TOP,
                     i.JAQY953STA,
                     i.JAQY953ATR,                     
                   --  i.JAQY953CAP,
                   --  i.JAQY953INT,
                   --  i.JAQY953MOR,
                   --  i.JAQY953OTR,
                     i.JAQY953SMN,
                     i.JAQY953PAIS,
                     i.JAQY953NDOC,
                     i.JAQY953TDOC,
                     lc_vig,
                     i.jaqy953rub,
                     'A');
                exception
                  when others then                    
                      lc_ob2 := 'NO está en la FSD011 o en la JAQL064';
                      insert into JAQY953_AUX --->>>Tabla auxiliar
                        ("JAQY953AUX_NVIO",
                         "JAQY953AUX_CTA",
                         "JAQY953AUX_OPE",
                         "JAQY953AUX_MDA",
                         "JAQY953AUX_MOD",
                      --   "JAQY953AUX_CAP",
                      --   "JAQY953AUX_INT",
                      --   "JAQY953AUX_MOR",
                         "JAQY953AUX_SMN",
                         "JAQY953AUX_DSC",
                         "JAQY953AUX_COD")
                      values
                        (ln_nro,
                         i.JAQY953CTA,
                         i.JAQY953OPE,
                         i.JAQY953MDA,
                         i.JAQY953MOD,
                        -- i.JAQY953CAP,
                       --  i.JAQY953INT,
                        -- i.JAQY953MOR,
                         i.JAQY953SMN,
                         lc_ob2,
                         lc_cod2);
                 end;   
        commit;
      else
          lc_cod2 := i.JAQY953ATR;
          lc_ob2 := 'No cumple con el saldo y dias de atraso.';
                      insert into JAQY953_AUX --->>>Tabla auxiliar
                        ("JAQY953AUX_NVIO",
                         "JAQY953AUX_CTA",
                         "JAQY953AUX_OPE",
                         "JAQY953AUX_MDA",
                        -- "JAQY953AUX_MOD",
                      --   "JAQY953AUX_CAP",
                      --   "JAQY953AUX_INT",
                         "JAQY953AUX_MOR",
                         "JAQY953AUX_SMN",
                         "JAQY953AUX_DSC")
--                         "JAQY953AUX_COD"
                      values
                        (ln_nro,
                         i.JAQY953CTA,
                         i.JAQY953OPE,
                         i.JAQY953MDA,
                         --i.JAQY953MOD,
                        -- i.JAQY953CAP,
                       --  i.JAQY953INT,
                         lc_cod2, -- se graba deias de atraso
                         i.JAQY953SMN,
                         lc_ob2);
                        -- lc_cod2
      end if;
    End loop;   
    ---actuliza guía con el número de propuesta creada para que proceda a la actualización de saldos
    update fst198 t  set TP1NRO1 =ln_nro 
          where t.tp1cod=ln_emp and t.tp1cod1 = 10897 and t.tp1corr1 = 1 and t.tp1corr2 = 2 and t.tp1corr3 = 2;
    commit;  
  end sp_Inserta_Detalle; 
procedure sp_ActualizaCabecera(pc_uing in varchar2, 
                              pn_pgcod in number,
                              pd_pgfape date,
                              pn_grupo  in number, --número de grupo
                              pn_propuesta  in number,
                              pn_empresa in number, 
                              pn_tcbio in number,
                              pn_modo in number) is
  
   
    lc_nomb  char(70); 
    ln_contador number;
    lc_usuario char(10);
    ln_grupo number;
    ln_propuesta number;
    ld_pgfape date;
    ln_tiprec number(4);
  Begin    
    lc_usuario := Upper(pc_uing);  
    select pgfape into ld_pgfape from fst017 where pgcod=1;  
    if ( pn_modo = 1 ) then
      ln_propuesta := pn_propuesta;
      --inicio adicionado 17/07/2023 kvalenciac
      if (pn_propuesta=0) then
        begin      
        select max(jaqy952nro) into ln_propuesta from jaqy952 ;
        exception 
          when others then
            ln_propuesta:=0;
        end;
      end if;
      --fin adicionado 17/07/2023 kvalenciac
      begin 
        select count(*) into ln_contador from jaqy953 where jaqy952nro=ln_propuesta;
      exception
           when no_data_found then
             ln_contador:=0;
      end;     
      update jaqy952 set JAQY952CNT=ln_contador where jaqy952nro= ln_propuesta;
      Commit;
      update jaqy953 
      set JAQY953TCA=pn_tcbio,
          JAQY953FPR=ld_pgfape,
          JAQY953USR =pc_uing,
          JAQY953HOR =TO_CHAR (SYSDATE, 'HH:MI:SS')
       where JAQY953TPRO = 'A'
       and jaqy952nro= ln_propuesta;---adicionado 17/07/2023 kvalenciac  ---     and ( JAQY953TCA=0 or JAQY953TCA is null);
      commit;
    end if;
    if ( pn_modo = 2 ) then  -- actualizo empresa
      begin
      select jaqy470k.jaqy470knomadq
        into lc_nomb
        from jaqy470k
       where jaqy470k.jaqy470kcodadq = pn_empresa;
      exception
        when others then
          null;
      end;
      update jaqy952 
      set JAQY952CAD=pn_empresa,  
          JAQY952NAD=lc_nomb
      where jaqy952nro= pn_propuesta;
      commit;
      ---actualizo el grupo de la propuesta
      ln_grupo:=0; --08/09/2022 KVALENCIAC
      begin 
         select jaqy952gru into ln_grupo
         from jaqy952 
         where (jaqy952est<>'V' and jaqy952est<>'A')  
         and jaqy952cad=pn_empresa
         and rownum = 1;  --busco las porpuesta vigentes para obtener el número de grupo ya creado si no adiciono una nuevo
      end;
      if ( ln_grupo = 0 or ln_grupo is null ) then  --08/09/2022 KVALENCIAC
        select max(jaqy952gru)+1 into ln_grupo from jaqy952; --08/09/2022 KVALENCIAC
      end if;             
       ---actualizo también el código de rango de recaudo  --inicio 25/08/2023 kvalenciac
       begin 
         select jaqy470ftiprec into ln_tiprec from jaqy470f where jaqy470fcodtra= ln_grupo;         
       exception
        when others then
          ln_tiprec:=0;
       end;
       --fin 25/08/2023 kvalenciac

      --lo actualizo en la tabla
        update jaqy952 
        set JAQY952GRU = ln_grupo,
         jaqy952tiprec = ln_tiprec -- se adicionó kvalenciac 25/08/2023
        where jaqy952nro= pn_propuesta;
        commit;  
    end if;
    
end sp_ActualizaCabecera;
  
procedure sp_ActualizaGuiaVG(pc_uing in varchar2, 
                              pn_codemp in number,
                              pn_propuesta  in number,
                              pc_estado in varchar2,
                              pc_estadot in varchar2) is   
  Begin 
    ---actuliza guía con el número de propuesta creada para que proceda a la vinculación de garantías
    update jaqy952 t  set jaqy952est = pc_estado , jaqy952esd=pc_estadot
          where jaqy952nro=pn_propuesta;
    commit;     
end sp_ActualizaGuiaVG;
procedure sp_validacionesM( pn_nro number,
                        pd_fecha in date,
                        pn_cod  in number,
                        pn_mod  in number,
                        pn_suc  in number,
                        pn_mda  in number,
                        pn_pap  in number,
                        pn_cta  in number,
                        pn_ope  in number,
                        pn_sbo  in number,
                        pn_top  in number,
                        pc_user in char,
                        pn_Indicador out number) is
ln_contador number;
ln_esfondo varchar(2);
ln_estado number;
ln_escancelado number;
ln_TieneSaldo number;
ln_TieneAcuerdo number;
ld_FecUltCierre date;
ln_sevende number;
ln_sevender number;
ln_saldo number;
ln_Provision number;
ln_Calificacion number;
ln_garantíaR number;
ln_rubro number;
ln_rubro2 number;
lc_flag varchar(2);
ln_AQPB750SALC number;
ln_EsexoneradoUC number;
ln_AQPB750CRECAS number;
ln_AQPB750ESLINEAM number;
ln_AQPB750ESJLINEAM number;
ln_AQPB750ESLINEBLQ number;
ln_aqpB750rubl number;
ln_aqpB750rublpjm number;
ln_aqpB750rubljud number;
ln_estadoc number;
lc_estado varchar(20);
lc_mensaje varchar (250);
lv_Calificacion varchar (15);
ln_esmivivienda number;
ln_cronograma number;
ln_tieneconstancia number;--kvalenciac 26/12/2024
ln_fechaimpresion date;--kvalenciac 26/12/2024
begin 
   select last_day(add_months(pd_fecha,-1)) into ld_FecUltCierre from dual;
 
   ln_escancelado:=0; 
   ln_estado:=0;
   ln_EsexoneradoUC:=0;
   begin 
     select aostat
           into ln_estado
     from  fsd010 f      
      where f.pgcod  = pn_cod 
        and f.aomod  = pn_mod 
        and f.aosuc  = pn_suc 
        and f.aomda  = pn_mda 
        and f.aopap  = pn_pap 
        and f.aocta  = pn_cta 
        and f.aooper = pn_ope 
        and f.aosbop = pn_sbo 
        and f.aotope = pn_top;
   exception
     when no_data_found then
       ln_estado:=0; 
   end;
   if ( ln_estado=99 )then
     ln_escancelado:=1;
   end if;
   ln_sevende:=0;---valida el estado solo estados -	Créditos estados diferentes a estado 21,22,34,23,64,90  (no se venden).
   begin 
     select count(*) into ln_sevende from Fst198
      Where Tp1cod=1
      and Tp1cod1=10897
      and Tp1corr1=12
      and Tp1corr2=1
      and Tp1corr3>0 
      and TP1nro1= ln_estado;
   exception
     when no_data_found then
       ln_sevende:=0;
   end;
   ln_saldo:=0; 
   --if ( ln_sevende > 0 ) then
     begin 
     select scsdo, scrub, scstat
       into ln_saldo,ln_rubro, ln_estadoc
       from  fsd011 d  
        where d.pgcod  = pn_cod 
          and d.scmod  = pn_mod         
          and d.SCMDA  = pn_mda 
          and d.SCPAP  = pn_pap 
          and d.SCCTA  = pn_cta 
          and d.SCSUC  = pn_suc 
          and d.SCOPER = pn_ope  
          and d.SCSBOP = pn_sbo
          and d.SCTOPE = pn_top;
       exception
         when no_data_found then
           ln_saldo:=0;
      end;   
     if ( ln_saldo<0) then
         ln_saldo:= ln_saldo*-1;
     end if;     
   --end if;
   if ( ln_saldo = 0 )then
     ln_AQPB750SALC :=1; --si tiene saldo capital cero
   end if;
   /*select to_number(substr(to_char(ln_rubro),0,4)) into ln_rubro2 from dual;
   begin 
     select count(*) into ln_sevender from Fst198
      Where Tp1cod=1
      and Tp1cod1=10897
      and Tp1corr1=12
      and Tp1corr2=2
      and Tp1corr3>0 
      and TP1IMP1= ln_rubro2;
   exception
     when no_data_found then
       ln_sevender:=0;
   end;
   if (ln_sevender=0) then
     ln_sevender:=1;--  AQPB750RUBNP si es 1 es rubro no permitido para la venta
   else
     ln_sevender:=0;--si es 0 es rubro permitido para la venta
   end if;*/
   begin 
     select cenomr into lc_estado from Fst026
      Where cecod=ln_estado;
   exception
     when no_data_found then
       lc_estado:='';
   end;
    
   -----verifica si es de fondo  
   ln_esfondo :=0;  
   pq_cr_creditos_fondoscovid.sp_verificar_cred_fondo( pn_cod => pn_cod,
                                                            pn_mod => pn_mod,
                                                            pn_suc => pn_suc,
                                                            pn_mda => pn_mda,
                                                            pn_pap => pn_pap,
                                                            pn_cta => pn_cta,
                                                            pn_ope => pn_ope,
                                                            pn_sbo => pn_sbo,
                                                            pn_top => pn_top,
                                                            pn_flag => lc_flag);   
   if ( lc_flag <> 'N' ) then -- si es diferente es de fondo
          ln_esfondo :=1;
   end if;
   --verifica si tiene saldo pendiente  
   ln_TieneSaldo:=0;                                                             
   ln_TieneSaldo := pq_cr_ventacarteras.fn_TieneSaldo(pn_cod,
                                              pn_mod,
                                              pn_suc,
                                              pn_mda,
                                              pn_pap,
                                              pn_cta,
                                              pn_ope,
                                              pn_sbo,
                                              pn_top);
   --verifica si tiene acuerdo de pago
   ln_TieneAcuerdo := pq_cr_ventacarteras.fn_TieneAcuerdo(pn_cod,
                                              pn_mod,
                                              pn_suc,
                                              pn_mda,
                                              pn_pap,
                                              pn_cta,
                                              pn_ope,
                                              pn_sbo,
                                              pn_top);
    --verifica si tiene provisión
    ln_Provision := pq_cr_ventacarteras.fn_provision(ld_FecUltCierre,
                                              ln_saldo,
                                              pn_cod,
                                              pn_mod,
                                              pn_suc,
                                              pn_mda,
                                              pn_pap,
                                              pn_cta,
                                              pn_ope,
                                              pn_sbo,
                                              pn_top);
    --verifica calificación
         
    pq_cr_ventacarteras.sp_Calificacion(     pd_FecUltCierre=> ld_FecUltCierre,
                                              pn_cod => pn_cod,
                                              pn_mod => pn_mod,
                                              pn_suc => pn_suc,
                                              pn_mda => pn_mda,
                                              pn_pap => pn_pap,
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_sbo => pn_sbo,
                                              pn_top => pn_top,
                                              pn_Califiacion  => ln_Calificacion,
                                              pv_calificacion => lv_Calificacion
                                              ); 

    ln_garantíaR := null;  
  /*  ---verifico si tiene garantías reales
    ln_garantíaR := pq_cr_ventacarteras.fn_GarantiaR(pn_cod,
                                              pn_mod,
                                              pn_suc,
                                              pn_mda,
                                              pn_pap,
                                              pn_cta,
                                              pn_ope,
                                              pn_sbo,
                                              pn_top);      */                               
    ---verifico si tiene -	Créditos con cronograma diferente de la fsd011 AQPB479CROND
    ln_cronograma := pq_cr_ventacarteras.fn_Cronograma(pn_cod,
                                              pn_mod,
                                              pn_suc,
                                              pn_mda,
                                              pn_pap,
                                              pn_cta,
                                              pn_ope,
                                              pn_sbo,
                                              pn_top); 
    --verifico si es crédito exonerado                                          
    ln_EsexoneradoUC := pq_cr_ventacarteras.fn_Esexonerado(pn_cod,
                                              pn_mod,
                                              pn_suc,
                                              pn_mda,
                                              pn_pap,
                                              pn_cta,
                                              pn_ope,
                                              pn_sbo,
                                              pn_top);
    ---verifica si el crédito está en proceso de castigo
    ln_AQPB750CRECAS := pq_cr_ventacarteras.fn_EstaEnCAstigo(pd_fecha,
                                              pn_cod,
                                              pn_mod,
                                              pn_suc,
                                              pn_mda,
                                              pn_pap,
                                              pn_cta,
                                              pn_ope,
                                              pn_sbo,
                                              pn_top);
   ---verifica datos de líneas    
   pq_cr_ventacarteras.sp_verificar_líneas(pd_fecha => pd_fecha,
                                          pn_cod => pn_cod,
                                          pn_mod => pn_mod,
                                          pn_suc => pn_suc,
                                          pn_mda => pn_mda ,
                                          pn_pap => pn_pap,
                                          pn_cta => pn_cta,
                                          pn_ope => pn_ope,
                                          pn_sbo => pn_sbo,
                                          pn_top => pn_top,                                          
                                          pn_LineaSaldomenor=> ln_AQPB750ESLINEAM,
                                          pn_Ldescuadrada   => ln_AQPB750ESJLINEAM,
                                          pn_Lbloqueada     => ln_AQPB750ESLINEBLQ,
                                          pn_Lrubros        => ln_aqpB750rubl,
                                          pn_Lrubnopjm      => ln_aqpB750rublpjm,
                                          pn_Lrubnojud      => ln_aqpB750rubljud
                                          );      
    --verifica si es de mi vivienda
    ln_esmivivienda:=0;     
    pq_cr_ventacarteras.sp_mivivienda(  
                                              pn_emp => pn_cod,  
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_suc => pn_suc,
                                              pn_pap => pn_pap,
                                              pn_sbop=> pn_sbo,
                                              pn_mda => pn_mda,
                                              pn_mod => pn_mod,
                                              pn_top => pn_top,
                                              pn_flg => ln_esmivivienda
                                              ); 
  --tiene constancia o cna impreso  inicio kvalenciac 26/12/2024
    ln_tieneconstancia:=0;
    ln_fechaimpresion:=null;
    pq_cr_ventacarteras.sp_constancia(  
                                              pn_emp => pn_cod,  
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_suc => pn_suc,
                                              pn_pap => pn_pap,
                                              pn_sbop=> pn_sbo,
                                              pn_mda => pn_mda,
                                              pn_mod => pn_mod,
                                              pn_top => pn_top,
                                              pn_flg => ln_tieneconstancia,
                                              pd_fecha => ln_fechaimpresion
                                              );
    ---fin kvalenciac 26/12/2024                                                                                                                      
       ln_contador := 0;
       -----------------------------------------------------------------Actualizo tabla de mensaje de errores
       ---elimino los errore grabados de este crédito para grabar los nuevos que tenga
       --si existe lo elimino 
         delete aqpb750L where AQPB750LPGC = pn_cod
                           and AQPB750LMOD = pn_mod
                           and AQPB750LSUC = pn_suc
                           and AQPB750LMDA = pn_mda
                           and AQPB750LPAP = pn_pap
                           and AQPB750LCTA = pn_cta
                           and AQPB750LOPE = pn_ope
                           and AQPB750LSBO = pn_sbo
                           and AQPB750LTOP = pn_top;
         commit;
        ---------------
       if ( ln_sevende = 0 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Crédito en estado no valido para la venta';
         pq_cr_ventacarteras.sp_insertaAQPB750L( pn_nro => pn_nro,
                                              pd_fecha => pd_fecha,
                                              pc_user => pc_user,
                                              pn_cod => pn_cod,
                                              pn_mod => pn_mod,
                                              pn_suc => pn_suc,
                                              pn_mda => pn_mda,
                                              pn_pap => pn_pap,
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_sbo => pn_sbo,
                                              pn_top => pn_top,
                                              pc_mensaje => lc_mensaje);
       end if;
       if (ln_escancelado=1 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Crédito esta cancelado.';
         pq_cr_ventacarteras.sp_insertaAQPB750L(pn_nro => pn_nro,
                                                pd_fecha => pd_fecha,
                                                pc_user => pc_user,
                                              pn_cod => pn_cod,
                                              pn_mod => pn_mod,
                                              pn_suc => pn_suc,
                                              pn_mda => pn_mda,
                                              pn_pap => pn_pap,
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_sbo => pn_sbo,
                                              pn_top => pn_top,
                                              pc_mensaje => lc_mensaje);
       end if; 
       if (ln_esfondo=1 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Crédito pertenece a fondos del gobierno.';
         pq_cr_ventacarteras.sp_insertaAQPB750L(pn_nro => pn_nro,
                                                pd_fecha => pd_fecha,
                                             pc_user => pc_user,
                                              pn_cod => pn_cod,
                                              pn_mod => pn_mod,
                                              pn_suc => pn_suc,
                                              pn_mda => pn_mda,
                                              pn_pap => pn_pap,
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_sbo => pn_sbo,
                                              pn_top => pn_top,
                                              pc_mensaje => lc_mensaje);
       end if; 
       if (ln_TieneSaldo=1 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Crédito tiene saldos pendientes.';
         pq_cr_ventacarteras.sp_insertaAQPB750L(pn_nro => pn_nro,
                                                pd_fecha => pd_fecha,
                                                pc_user => pc_user,
                                                pn_cod => pn_cod,
                                                pn_mod => pn_mod,
                                                pn_suc => pn_suc,
                                                pn_mda => pn_mda,
                                                pn_pap => pn_pap,
                                                pn_cta => pn_cta,
                                                pn_ope => pn_ope,
                                                pn_sbo => pn_sbo,
                                                pn_top => pn_top,
                                                pc_mensaje => lc_mensaje);
       end if;
       if (ln_TieneAcuerdo=1 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Crédito con acuerdos pendientes.';
         pq_cr_ventacarteras.sp_insertaAQPB750L(pn_nro => pn_nro,
                                                pd_fecha => pd_fecha,
                                                pc_user => pc_user,
                                                pn_cod => pn_cod,
                                                pn_mod => pn_mod,
                                                pn_suc => pn_suc,
                                                pn_mda => pn_mda,
                                                pn_pap => pn_pap,
                                                pn_cta => pn_cta,
                                                pn_ope => pn_ope,
                                                pn_sbo => pn_sbo,
                                                pn_top => pn_top,
                                                pc_mensaje => lc_mensaje);
       end if;
       
       if ((ln_Provision<>0 and pn_mod=33 ) or (ln_Provision<100 and pn_mod<>33))then
         ln_contador := ln_contador +1;
         lc_mensaje:='Crédito con provisión diferente de 100%.';
         pq_cr_ventacarteras.sp_insertaAQPB750L(pn_nro => pn_nro,
                                                pd_fecha => pd_fecha,
                                                pc_user => pc_user,
                                                pn_cod => pn_cod,
                                                pn_mod => pn_mod,
                                                pn_suc => pn_suc,
                                                pn_mda => pn_mda,
                                                pn_pap => pn_pap,
                                                pn_cta => pn_cta,
                                                pn_ope => pn_ope,
                                                pn_sbo => pn_sbo,
                                                pn_top => pn_top,
                                                pc_mensaje => lc_mensaje);
       end if;
       if (ln_Calificacion=1 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Crédito con calificación diferente de Perdida al último cierre mensual.';
         pq_cr_ventacarteras.sp_insertaAQPB750L(pn_nro => pn_nro,
                                                pd_fecha => pd_fecha,
                                                pc_user => pc_user,
                                                pn_cod => pn_cod,
                                                pn_mod => pn_mod,
                                                pn_suc => pn_suc,
                                                pn_mda => pn_mda,
                                                pn_pap => pn_pap,
                                                pn_cta => pn_cta,
                                                pn_ope => pn_ope,
                                                pn_sbo => pn_sbo,
                                                pn_top => pn_top,
                                                pc_mensaje => lc_mensaje);
       end if;
       
    /*    if (ln_garantíaR=1 )then
          ln_contador := ln_contador +1;
         lc_mensaje:='Crédito con garantía real.';
         pq_cr_ventacarteras.sp_insertaAQPB750L(pn_nro => pn_nro,
                                                pd_fecha => pd_fecha,
                                               pc_user => pc_user,
                                                pn_cod => pn_cod,
                                                pn_mod => pn_mod,
                                                pn_suc => pn_suc,
                                                pn_mda => pn_mda,
                                                pn_pap => pn_pap,
                                                pn_cta => pn_cta,
                                                pn_ope => pn_ope,
                                                pn_sbo => pn_sbo,
                                                pn_top => pn_top,
                                                pc_mensaje => lc_mensaje);
       end if; */
       /*if (ln_sevender>0 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Crédito no se encuentra en rubros permitidos para la venta.';
         pq_cr_ventacarteras.sp_insertaAQPB750L(pn_nro => pn_nro,
                                                pd_fecha => pd_fecha,
                                                pc_user => pc_user,
                                                pn_cod => pn_cod,
                                                pn_mod => pn_mod,
                                                pn_suc => pn_suc,
                                                pn_mda => pn_mda,
                                                pn_pap => pn_pap,
                                                pn_cta => pn_cta,
                                                pn_ope => pn_ope,
                                                pn_sbo => pn_sbo,
                                                pn_top => pn_top,
                                                pc_mensaje => lc_mensaje);
       end if;  */
       if (ln_AQPB750SALC=1 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Crédito con saldo de capital cero.';
         pq_cr_ventacarteras.sp_insertaAQPB750L(pn_nro => pn_nro,
                                                pd_fecha => pd_fecha,
                                                pc_user => pc_user,
                                                pn_cod => pn_cod,
                                                pn_mod => pn_mod,
                                                pn_suc => pn_suc,
                                                pn_mda => pn_mda,
                                                pn_pap => pn_pap,
                                                pn_cta => pn_cta,
                                                pn_ope => pn_ope,
                                                pn_sbo => pn_sbo,
                                                pn_top => pn_top,
                                                pc_mensaje => lc_mensaje);
       end if; 
       if ( ln_cronograma = 1 ) then 
          ln_contador := ln_contador +1;
         lc_mensaje:='Revisar con producción cronograma de crédito';
         pq_cr_ventacarteras.sp_insertaAQPB750L(pn_nro => pn_nro,
                                                pd_fecha => pd_fecha,
                                             pc_user => pc_user,
                                              pn_cod => pn_cod,
                                              pn_mod => pn_mod,
                                              pn_suc => pn_suc,
                                              pn_mda => pn_mda,
                                              pn_pap => pn_pap,
                                              pn_cta => pn_cta,
                                              pn_ope => pn_ope,
                                              pn_sbo => pn_sbo,
                                              pn_top => pn_top,
                                              pc_mensaje => lc_mensaje);
       end if; 
       if (ln_EsexoneradoUC=1 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Crédito se encuentra en tabla de Ref exoneración última cuota / Crédito se encuentra en tabla de Rep exoneración última cuota';
         pq_cr_ventacarteras.sp_insertaAQPB750L(pn_nro => pn_nro,
                                                pd_fecha => pd_fecha,
                                                pc_user => pc_user,
                                                pn_cod => pn_cod,
                                                pn_mod => pn_mod,
                                                pn_suc => pn_suc,
                                                pn_mda => pn_mda,
                                                pn_pap => pn_pap,
                                                pn_cta => pn_cta,
                                                pn_ope => pn_ope,
                                                pn_sbo => pn_sbo,
                                                pn_top => pn_top,
                                                pc_mensaje => lc_mensaje);
       end if; 
       if (ln_AQPB750CRECAS=1 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Crédito está en propuesta/proceso de castigo.';
         pq_cr_ventacarteras.sp_insertaAQPB750L(pn_nro => pn_nro,
                                                pd_fecha => pd_fecha,
                                                pc_user => pc_user,
                                                pn_cod => pn_cod,
                                                pn_mod => pn_mod,
                                                pn_suc => pn_suc,
                                                pn_mda => pn_mda,
                                                pn_pap => pn_pap,
                                                pn_cta => pn_cta,
                                                pn_ope => pn_ope,
                                                pn_sbo => pn_sbo,
                                                pn_top => pn_top,
                                                pc_mensaje => lc_mensaje);
       end if; 
       if (ln_AQPB750ESLINEBLQ=1 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Línea Bloqueada.';
         pq_cr_ventacarteras.sp_insertaAQPB750L(pn_nro => pn_nro,
                                               pd_fecha => pd_fecha,
                                                pc_user => pc_user,
                                                pn_cod => pn_cod,
                                                pn_mod => pn_mod,
                                                pn_suc => pn_suc,
                                                pn_mda => pn_mda,
                                                pn_pap => pn_pap,
                                                pn_cta => pn_cta,
                                                pn_ope => pn_ope,
                                                pn_sbo => pn_sbo,
                                                pn_top => pn_top,
                                                pc_mensaje => lc_mensaje);
       end if; 
       if (ln_aqpB750rubl=1 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Inconsistencia en rubros de líneas.';
         pq_cr_ventacarteras.sp_insertaAQPB750L(pn_nro => pn_nro,
                                                pd_fecha => pd_fecha,
                                                pc_user => pc_user,
                                                pn_cod => pn_cod,
                                                pn_mod => pn_mod,
                                                pn_suc => pn_suc,
                                                pn_mda => pn_mda,
                                                pn_pap => pn_pap,
                                                pn_cta => pn_cta,
                                                pn_ope => pn_ope,
                                                pn_sbo => pn_sbo,
                                                pn_top => pn_top,
                                                pc_mensaje => lc_mensaje);
       end if;
       if (ln_AQPB750ESLINEAM=1 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Inconsistencia entre saldo del cupo y saldo de utilización.';
         pq_cr_ventacarteras.sp_insertaAQPB750L(pn_nro => pn_nro,
                                                pd_fecha => pd_fecha,
                                                pc_user => pc_user,
                                                pn_cod => pn_cod,
                                                pn_mod => pn_mod,
                                                pn_suc => pn_suc,
                                                pn_mda => pn_mda,
                                                pn_pap => pn_pap,
                                                pn_cta => pn_cta,
                                                pn_ope => pn_ope,
                                                pn_sbo => pn_sbo,
                                                pn_top => pn_top,
                                                pc_mensaje => lc_mensaje);
       end if;
       if (ln_AQPB750ESJLINEAM=1 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Inconsistencia en saldos versus cupo.';
         pq_cr_ventacarteras.sp_insertaAQPB750L(pn_nro => pn_nro,
                                                pd_fecha => pd_fecha,
                                                pc_user => pc_user,
                                                pn_cod => pn_cod,
                                                pn_mod => pn_mod,
                                                pn_suc => pn_suc,
                                                pn_mda => pn_mda,
                                                pn_pap => pn_pap,
                                                pn_cta => pn_cta,
                                                pn_ope => pn_ope,
                                                pn_sbo => pn_sbo,
                                                pn_top => pn_top,
                                                pc_mensaje => lc_mensaje);
       end if;
        if (ln_aqpB750rublpjm=1 )then
          ln_contador := ln_contador +1;
         lc_mensaje:='Crédito estado 23 no está la línea en el rubro 7.';
         pq_cr_ventacarteras.sp_insertaAQPB750L(pn_nro => pn_nro,
                                                pd_fecha => pd_fecha,
                                                pc_user => pc_user,
                                                pn_cod => pn_cod,
                                                pn_mod => pn_mod,
                                                pn_suc => pn_suc,
                                                pn_mda => pn_mda,
                                                pn_pap => pn_pap,
                                                pn_cta => pn_cta,
                                                pn_ope => pn_ope,
                                                pn_sbo => pn_sbo,
                                                pn_top => pn_top,
                                                pc_mensaje => lc_mensaje);
       end if;
       if (ln_aqpB750rubljud =1 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Crédito estado Judicial no está la línea en el rubro 9.';
         pq_cr_ventacarteras.sp_insertaAQPB750L(pn_nro => pn_nro,
                                                pd_fecha => pd_fecha,
                                                pc_user => pc_user,
                                                pn_cod => pn_cod,
                                                pn_mod => pn_mod,
                                                pn_suc => pn_suc,
                                                pn_mda => pn_mda,
                                                pn_pap => pn_pap,
                                                pn_cta => pn_cta,
                                                pn_ope => pn_ope,
                                                pn_sbo => pn_sbo,
                                                pn_top => pn_top,
                                                pc_mensaje => lc_mensaje);
       end if;
       if (ln_esmivivienda =1 )then
         ln_contador := ln_contador +1;
         lc_mensaje:='Es crédito mi Vivienda';
         pq_cr_ventacarteras.sp_insertaAQPB750L(pn_nro => pn_nro,
                                                pd_fecha => pd_fecha,
                                                pc_user => pc_user,
                                                pn_cod => pn_cod,
                                                pn_mod => pn_mod,
                                                pn_suc => pn_suc,
                                                pn_mda => pn_mda,
                                                pn_pap => pn_pap,
                                                pn_cta => pn_cta,
                                                pn_ope => pn_ope,
                                                pn_sbo => pn_sbo,
                                                pn_top => pn_top,
                                                pc_mensaje => lc_mensaje);
       end if;
       --inicio kvalenciac 26/12/2024
       if (ln_tieneconstancia=1 ) then
         ln_contador := ln_contador +1;
         lc_mensaje:='Tiene constancia impresa o CNA impresa';
         pq_cr_ventacarteras.sp_insertaAQPB750L(pn_nro => pn_nro,
                                                pd_fecha => pd_fecha,
                                                pc_user => pc_user,
                                                pn_cod => pn_cod,
                                                pn_mod => pn_mod,
                                                pn_suc => pn_suc,
                                                pn_mda => pn_mda,
                                                pn_pap => pn_pap,
                                                pn_cta => pn_cta,
                                                pn_ope => pn_ope,
                                                pn_sbo => pn_sbo,
                                                pn_top => pn_top,
                                                pc_mensaje => lc_mensaje);
       end if;      
       --fin kvalenciac 26/12/2024
       pn_Indicador:= ln_contador;
       if ( pn_Indicador =0 )then  --si no tiene errores inserta si no no prosigue
         --si existe lo elimino 
         delete aqpb750 where  AQPb750PGC = pn_cod
                           and AQPB750MOD = pn_mod
                           and AQPB750SUC = pn_suc
                           and AQPB750MDA = pn_mda
                           and AQPB750PAP = pn_pap
                           and AQPB750CTA = pn_cta
                           and AQPB750OPE = pn_ope
                           and AQPB750SBO = pn_sbo
                           and AQPB750TOP = pn_top;
         commit;
         
       ---Actualiza tabla temporal de carga de propuesta
                     insert into aqpB750  ( AQPB750NRO,
                                            AQPB750PGC,
                                            AQPB750MOD,
                                            AQPB750SUC,
                                            AQPB750MDA,
                                            AQPB750PAP,
                                            AQPB750CTA,
                                            AQPB750OPE,
                                            AQPB750SBO,
                                            AQPB750TOP ,           
                                           aqpB750STA,        
                                           aqpB750EST,        
                                           AQPB750ESCANCELADO,
                                           AQPB750ESFONDO,    
                                           AQPB750TIENESALDO, 
                                           AQPB750ESLINEAM,   
                                           AQPB750ESJLINEAM,  
                                           AQPB750ESLINEBLQ , 
                                           AQPB750TIENEACU,   
                                           AQPB750prov,       
                                           AQPB750calif,      
                                           AQPB750gareal,     
                                           AQPB750rubnp,      
                                           AQPB750salc,       
                                           AQPB750crond,      
                                           AQPB750creexo,     
                                           AQPB750crecas,     
                                           aqpB750rubl,       
                                           aqpB750rublpjm,    
                                           aqpB750rubljud,    
                                           AQPB750calift,     
                                           aqpB750esvnda,
                                           AQPB750cons,       
                                           AQPB750feccons    
                                            )     
                                values 
                                 ( 
                                   pn_nro,
                                   pn_cod,               
                                   pn_mod,
                                   pn_suc,
                                   pn_mda,
                                   pn_pap,
                                   pn_cta,
                                   pn_ope,
                                   pn_sbo,
                                   pn_top,
                                   ln_estado,
                                   lc_estado,
                                   ln_escancelado,
                                   ln_esfondo,
                                   ln_TieneSaldo,
                                   ln_AQPB750ESLINEAM,
                                   ln_AQPB750ESJLINEAM,
                                   ln_AQPB750ESLINEBLQ,
                                   ln_TieneAcuerdo,
                                   ln_Provision,
                                   ln_Calificacion,
                                   ln_garantíaR,
                                   ln_sevender,
                                   ln_AQPB750SALC,
                                   ln_cronograma,--se validara en el boton proceso
                                   ln_EsexoneradoUC,
                                   ln_AQPB750CRECAS,
                                   ln_aqpB750rubl,
                                   ln_aqpB750rublpjm,
                                   ln_aqpB750rubljud,
                                   lv_Calificacion,
                                   ln_esmivivienda,
                                   ln_tieneconstancia, --kvalenciac 27/12/2024
                                   ln_fechaimpresion  --kvalenciac 27/12/2024
                                    );
                                 commit;
      end if;
end sp_validacionesM;  
procedure sp_insertaAQPB750L( pn_nro number,
                              pd_fecha in date,
                              pc_user in char,
                              pn_cod  in number,
                              pn_mod  in number,
                              pn_suc  in number,
                              pn_mda  in number,
                              pn_pap  in number,
                              pn_cta  in number,
                              pn_ope  in number,
                              pn_sbo  in number,
                              pn_top  in number,
                              pc_mensaje in varchar) is
begin
  ---Actualiza TABLA TEMPORAL de mensajes de error
       insert into aqpb750L
                  (AQPB750LNRO,
                   AQPB750LPGC,
                   AQPB750LMOD,
                   AQPB750LSUC,
                   AQPB750LMDA,
                   AQPB750LPAP,
                   AQPB750LCTA,
                   AQPB750LOPE,
                   AQPB750LSBO,
                   AQPB750LTOP,
                   AQPB750LMSG,
                   AQPB750LFECACT,
                   AQPB750LUSUACT )
               values
                   (pn_nro,
                    pn_cod,
                    pn_mod,
                    pn_suc,
                    pn_mda,
                    pn_pap,
                    pn_cta,
                    pn_ope,
                    pn_sbo,
                    pn_top,
                    pc_mensaje,
                    pd_fecha,
                    pc_user
                  );
         commit;
end sp_insertaAQPB750L;
procedure sp_ReporteC(pc_uing in varchar2,                              
                              pn_nrogru  in number,
                              pn_pgfape  in date) is 
  
begin
  
    delete aqpc419;
    commit;
     insert into aqpc419 
  select (select scnom from fst001 where sucurs = t.jaqz064suc) agencia,
       fn_analista_credito(t.jaqz064mod,
                                    t.jaqz064suc,
                                    t.jaqz064mda,
                                    t.jaqz064pap,
                                    t.jaqz064cta,
                                    t.jaqz064ope,
                                    t.jaqz064sbo,
                                    t.jaqz064top) analista,
       t.jaqz064tit titular,
       t.jaqz064cta cuenta,
       t.jaqz064ope operacion,
       case when t.jaqz064tic is not null then t.jaqz064tic
            else (select case when substr(p.bcrubr,4,1) = '1' then 'NORMAL'
                    when substr(p.bcrubr,4,1) = '4' then 'REFINANCIADO'
                    when substr(p.bcrubr,4,1) = '5' then 'VENCIDO'
                    when substr(p.bcrubr,4,1) = '6' then 'JUDICIAL'
                    ELSE NULL
               end
          from fsh012 p
         where p.bcemp  = t.jaqz064pgc
           and p.bcsuc  = t.jaqz064suc
           and p.bcmda  = t.jaqz064mda
           and p.bcpap  = t.jaqz064pap
           and p.bccta  = t.jaqz064cta
           and p.bcoper = t.jaqz064ope
           and p.bcsbop = t.jaqz064sbo
           and p.bctop  = t.jaqz064top
           and p.bcfech = pn_pgfape ) --'29/04/2022')  --> fecha del dia anterior a la venta
       end tipo_contable,
       t.jaqz064tsb tip_sbs,
       (select mosign from fst005 a where moneda = t.jaqz064mda) moneda,
       JAQZ064CAP saldo_capital,
       t.Jaqz064ful fec_ult_pag,
       t.Jaqz064dia dias_atraso,
       t.Jaqz064cuo cuo_pag,
       Jaqz064dil dir_legal,
       Jaqz064rel ref_legal,
       jaqz064dsl dis_legal,
       Jaqz064tel tel_tit,
       Jaqz064dig dir_ges,
       Jaqz064reg ref_ges,
       Jaqz064dsg dis_ges,
       Jaqz064teg tel_ges,
       Jaqz064act actividad,
       Jaqz064din dir_neg,
       Jaqz064dsn dis_neg,
       Jaqz064nav nro_avales,
       Jaqz064noa nom_aval,
       Jaqz064dra dir_aval,
       Jaqz064rea ref_aval,
       Jaqz064dsa dis_aval,
       (select tdnom from fst014 where tdocum = t.jaqz064tdo) tip_doc_tit,
       t.jaqz064ndo nro_doc_tit,
       (select tdnom from fst014 where tdocum = t.jaqz064tda) tip_doc_aval,
       t.jaqz064nda nro_doc_aval,
       Jaqz064tea tel_aval,
       Jaqz064sbs cod_sbs,
       JAQZ064FED fec_des,
       Jaqz064aoi mto_des,
       JAQZ064INT int_moratorio, --int_comp,
       JAQZ064MOR int_comp, --int_moratorio,
       --JAQZ064GAS gastos,
       --(JAQZ064CAP + JAQZ064INT + JAQZ064MOR + JAQZ064GAS) tot_deuda,
       u.jaqy953icvv icv,
       u.jaqy953segv seguros,
       u.jaqy953penv penalidad,
       u.jaqy953orov otros_rubros,
       (nvl(JAQZ064CAP,0)+nvl(JAQZ064INT,0)+nvl(JAQZ064MOR,0)+nvl(jaqy953icvv,0)+nvl(jaqy953segv,0)+
       nvl(jaqy953penv,0)+nvl(jaqy953orov,0)) tot_deuda,
       Jaqz064cal cal_sbs,
       Jaqz064pro provision,
       case
         when Jaqz064fij = to_date('01.01.0001', 'ddd.mm.yyyy') then
          null
         else
          Jaqz064fij
       end fec_ing_jud,
       case
         when Jaqz064fic = to_date('01.01.0001', 'ddd.mm.yyyy') then
          null
         else
          Jaqz064fic
       end fec_ing_cas,
       Jaqz064ref refinanciado,
       t.jaqz064tg1 tip_gar1,
       t.jaqz064mg1 mto_gar1,
       t.jaqz064tg2 tip_gar2,
       t.jaqz064mg2 mto_gar2,
       t.jaqz064tg3 tip_gar3,
       t.jaqz064mg3 mto_gar3,
       t.jaqz064tg4 tip_gar4,
       t.jaqz064mg4 mto_gar4,
       t.jaqz064tg5 tip_gar5,
       t.jaqz064mg5 mto_gar5,
       t.jaqz064tg6 tip_gar6,
       t.jaqz064mg6 mto_gar6,
       t.jaqz064ubi ubigeo,
       t.jaqz064dep departamento,
       t.jaqz064prv provincia,
       t.jaqz064dit distrito
  from jaqz064 t,jaqy953 u, jaqy952 j
 WHERE T.JAQZ064GRU = pn_nrogru --21   --> Numero de grupo de venta
   and t.jaqz064pgc = u.jaqy953emp
   and t.jaqz064suc = u.jaqy953suc
   and t.jaqz064mod = u.jaqy953mod
   and t.jaqz064mda = u.jaqy953mda
   and t.jaqz064pap = u.jaqy953pap
   and t.jaqz064cta = u.jaqy953cta
   and t.jaqz064ope = u.jaqy953ope
   and t.jaqz064sbo = u.jaqy953sbo
   and t.jaqz064top = u.jaqy953top
   and j.jaqy952gru = t.JAQZ064GRU
   and j.jaqy952nro = u.jaqy952nro;   --and u.jaqy952nro in (41,42)  
   commit;                        
end sp_ReporteC;
end pq_cr_ventacarteras;
 /* GOLDENGATE_DDL_REPLICATION */
/

