create or replace package pq_ah_compensa_ctas is

  -- Author  : YLOZADA
  -- Created : 19/03/2015 04:45:55 p.m.
  -- Purpose : 
  
  -- Public type declarations
  -- Public function and procedure declarations
  Procedure sp_ah_genera_cobros(P_D_FECHA  IN DATE,
                                P_N_MORA   IN NUMBER,
                                P_N_SALDO  IN NUMBER,
                                P_N_CODPRO IN NUMBER
                                );

  Function fn_facultad_cta(vpgcod  number,
                           vscsuc  number,
                           vscmda  number,
                           vscpap  number,
                           vsccta  number,
                           vscoper number,
                           vscsbop number,
                           vscmod  number
                         ) return number;
  Function fn_cr_prorrateo_cre(P_D_JAQL484FEP IN DATE,
                               P_N_JAQL484PRC IN NUMBER,
                               P_N_JAQL484PGC IN NUMBER,
                               P_N_JAQL484SUC IN NUMBER,
                               P_N_JAQL484CTC IN NUMBER,
                               P_N_JAQL484MOD IN NUMBER,
                               P_N_JAQL484MDA IN NUMBER,
                               P_N_JAQL484PAP IN NUMBER,
                               P_N_JAQL484OPE IN NUMBER,
                               P_N_JAQL484SUB IN NUMBER,
                               P_N_JAQL484TIP IN NUMBER       
                               )return number;           
  Procedure sp_ah_ctacob(P_D_FECHA  IN DATE,
                         P_N_CUENTA IN NUMBER,
                         P_N_IDCRED IN NUMBER,
                         P_N_MONEDA IN NUMBER,
                         P_N_ORDPRI IN NUMBER,
                         P_N_SALDO  IN NUMBER                                                 
                         );        
  Procedure sp_registra_cobro(P_D_JAQL484FEP IN DATE,
                              P_N_JAQL484PRC IN NUMBER,
                              P_N_JAQL484COR IN NUMBER,
                              P_N_JAQL484PGC IN NUMBER,
                              P_N_JAQL484SUC IN NUMBER,
                              P_N_JAQL484CTC IN NUMBER,
                              P_N_JAQL484MOD IN NUMBER,
                              P_N_JAQL484MDA IN NUMBER,
                              P_N_JAQL484PAP IN NUMBER,
                              P_N_JAQL484OPE IN NUMBER,
                              P_N_JAQL484SUB IN NUMBER,
                              P_N_JAQL484TIP IN NUMBER,
                              --
                              P_N_JAQL484PGA IN NUMBER,
                              P_N_JAQL484SUA IN NUMBER,
                              P_N_JAQL484CTA IN NUMBER,
                              P_N_JAQL484MOA IN NUMBER, 
                              P_N_JAQL484MAA IN NUMBER,
                              P_N_JAQL484PAA IN NUMBER,  
                              P_N_JAQL484OPA IN NUMBER,  
                              P_N_JAQL484SBA IN NUMBER,  
                              P_N_JAQL484TIA IN NUMBER,  
                              --  
                              P_N_JAQL484DEC IN NUMBER,  
                              P_N_JAQL484MTR IN NUMBER,  
                              P_N_JAQL484TCC IN NUMBER,  
                              P_C_JAQL484EST IN VARCHAR2,  
                              P_C_JAQL484MOT IN VARCHAR2,
                              P_N_JAQL484AX4 IN NUMBER,  
                              P_N_JAQL484AX1 IN NUMBER,
                              P_N_JAQL484AX2 IN NUMBER,
                              P_N_JAQL484AX9 IN VARCHAR2,                                                          
                              P_N_JAQL484A10 IN NUMBER,
                              P_N_JAQL484A11 IN NUMBER,
                              P_N_JAQL484A12 IN NUMBER,
                              P_N_JAQL484AX5 IN NUMBER,
                              P_N_JAQL484AX6 IN NUMBER                                                                 
                             );  
  Procedure sp_cr_montos(P_N_INDMON IN VARCHAR2,
                         P_N_CTAORI IN NUMBER,
                         P_N_CTADES IN NUMBER,
                         P_N_MONRET IN NUMBER,
                         P_N_MONMAH IN NUMBER,
                         P_N_MONCUE IN NUMBER,
                         P_N_MONCRE IN NUMBER,  
                         P_N_TIPCAM IN NUMBER,                                  
                         P_N_MONDEV OUT NUMBER,              
                         P_N_ITFMAH IN OUT NUMBER,--itf en la moneda del ahorro
                         P_N_ITFMCR IN OUT NUMBER, --itf en la moneda del credito
                         P_N_ITFREA OUT NUMBER
                        );                 
  Function  fn_cr_verexonera(P_N_PGCOD  IN NUMBER,
                             P_N_SCMOD  IN NUMBER,
                             P_N_SCSUC  IN NUMBER,
                             P_N_SCMDA  IN NUMBER,
                             P_N_SCPAP  IN NUMBER,
                             P_N_SCCTA  IN NUMBER,
                             P_N_SCOPER IN NUMBER,
                             P_N_SCSBOP IN NUMBER,
                             P_N_SCTOPE IN NUMBER
                            ) return varchar2;                                                                                               
  Function  fn_calcula_itf(P_N_MONTO  IN NUMBER) return number;                            
  Procedure  sp_actualiza_pro(P_N_CODPRO IN NUMBER);
  Procedure sp_selecciona_cuentas(P_D_FECHA  IN DATE,
                                  P_N_INDCRE IN NUMBER,
                                  P_N_CODPRO IN NUMBER         
                                  );  
  Procedure sp_ah_ctacob_cya(P_D_FECHA  IN DATE,
                             P_N_CUENTA IN NUMBER,
                             P_N_IDCRED IN NUMBER,
                             P_N_MONEDA IN NUMBER,
                             P_N_ORDPRI IN NUMBER,
                             P_N_SALDO  IN NUMBER                                                 
                             );  
  Function  fn_ah_salafp(P_N_PGCOD IN NUMBER,
                         P_N_SCMOD IN NUMBER,
                         P_N_SCSUC IN NUMBER,
                         P_N_SCMDA IN NUMBER,
                         P_N_SCPAP IN NUMBER,
                         P_N_SCCTA IN NUMBER,
                         P_N_SCOPER IN NUMBER,
                         P_N_SCSBOP IN NUMBER,
                         P_N_SCTOPE IN NUMBER
                        ) return number;
  Procedure sp_ah_salafp(P_N_PGCOD IN NUMBER,
                         P_N_SCMOD IN NUMBER,
                         P_N_SCSUC IN NUMBER,
                         P_N_SCMDA IN NUMBER,
                         P_N_SCPAP IN NUMBER,
                         P_N_SCCTA IN NUMBER,
                         P_N_SCOPER IN NUMBER,
                         P_N_SCSBOP IN NUMBER,
                         P_N_SCTOPE IN NUMBER,
                         p_n_salafp out number
                        );                                                                                                                           
end pq_ah_compensa_ctas;
/

create or replace package body pq_ah_compensa_ctas is

  Procedure sp_ah_genera_cobros(P_D_FECHA  IN DATE,
                                P_N_MORA   IN NUMBER,
                                P_N_SALDO  IN NUMBER,
                                P_N_CODPRO IN NUMBER
                                ) IS
  cursor c_cta_avales(P_N_SUC in number,P_N_MOD in number,P_N_MDA in number,P_N_CTA in number,P_N_OPE in number,P_N_SBO in number,P_N_TOP in number)is
   select distinct 
          b.sng003cta        
     from xwf700    a,
          sng003    b
    where a.XWFPRCINS    = b.sng001inst
      and a.XWFEMPRESA   = 1 
      and a.XWFSUCURSAL  = P_N_SUC
      and a.XWFMODULO    = P_N_MOD
      and a.XWFMONEDA    = P_N_MDA
      and a.XWFPAPEL     = 0
      and a.XWFCUENTA    = P_N_CTA
      and a.XWFOPERACION = P_N_OPE
      and a.XWFSUBOPE    = P_N_SBO
      and a.XWFTIPOPE    = P_N_TOP
      and a.XWFCAR3 = '1';           
  
  cursor c_creditos is
      select /*+parallel(cre,3) parallel(j64,3) parallel(fr8,3)*/
                      distinct 
                      fr8.pepais,
                      fr8.petdoc, 
                      fr8.pendoc,
                      cre.sccta,
                      cre.scsuc,
                      cre.scmod,
                      cre.scmda,
                      cre.scoper,
                      cre.scsbop,
                      cre.sctope,
                      pq_cr_creditos.fn_solo_capital_atrasado(cre.pgcod,
                                                              cre.scmod,
                                                              cre.scsuc,
                                                              cre.scmda,
                                                              cre.scpap,
                                                              cre.sccta,
                                                              cre.scoper,
                                                              cre.scsbop,
                                                              cre.sctope,
                                                              P_D_FECHA
                                                            ) capital_atrasado,
                      pq_cr_creditos.fn_cuota_atrasada(cre.pgcod,
                                                       cre.scmod,
                                                       cre.scsuc,
                                                       cre.scmda,
                                                       cre.scpap,
                                                       cre.sccta,
                                                       cre.scoper,
                                                       cre.scsbop,
                                                       cre.sctope,
                                                       P_D_FECHA
                                                      ) n_numcuo,
                      fn_analista_credito(cre.scmod,
                                          cre.scsuc,
                                          cre.scmda,
                                          cre.scpap,
                                          cre.sccta,
                                          cre.scoper,
                                          cre.scsbop,
                                          cre.sctope
                                          ) c_codana,                                                              
                     /* (pq_cr_creditos.fn_monto_atrasado(cre.pgcod,
                                                                 cre.scmod,
                                                                 cre.scsuc,
                                                                 cre.scmda,
                                                                 cre.scpap,
                                                                 cre.sccta,
                                                                 cre.scoper,
                                                                 cre.scsbop,
                                                                 cre.sctope,
                                                                 P_D_FECHA
                                                                 )*/ 
                      j64.jaql964mtd /*(j64.jaql964gas + j64.jaql964mor + jaql964int + jaql964cuo)*/ Total_deuda,
                      j64.jaql964dia dia_atraso
        from fsd011 cre, 
             jaql964 j64, 
             fsr008  fr8
       where cre.pgcod = 1
         and cre.scrub in (select rubro
                             from fsd014
                            where pcimpu = 'S'
                              and pcnivc in
                                  (select modulo
                                     from fst111
                                    where dscod = 50
                                      and modulo not in (33, 120, 141, 144, 200))
                           /* and pcrub = 145*/
                           ) -- descomentar para obtener solo cartera vencida
           and j64.jaql964suc = cre.scsuc
           and j64.jaql964cta = cre.sccta
           and j64.jaql964mod = cre.scmod
           and j64.jaql964mda = cre.scmda
           and j64.jaql964ope = cre.scoper
         and j64.jaql964sob = cre.scsbop
         and j64.jaql964top = cre.sctope
         and fr8.pgcod = cre.pgcod
         and fr8.ctnro = cre.sccta
         and fr8.ttcod = 1
         and cre.sctope <> 550
         and cre.scstat <> 99 
         and j64.jaql964dia >= P_N_MORA
         and not exists(select 1 from jaqy666 s66 where s66.jaqy666pgc = cre.pgcod
                                                    and s66.jaqy666suc = cre.scsuc
                                                    and s66.jaqy666mda = cre.scmda
                                                    and s66.jaqy666pap = cre.scpap
                                                    and s66.jaqy666cta = cre.sccta
                                                    and s66.jaqy666ope = cre.scoper
                                                    and s66.jaqy666sop = cre.scsbop
                                                    and s66.jaqy666top = cre.sctope
                                                    and s66.jaqy666mod = cre.scmod 
                                                    and s66.jaqy666est = 'S'
                                                    and P_D_FECHA between s66.jaqy666fini and s66.jaqy666ffin                                                   
                       )
         --and cre.sccta = 422
         --and cre.scoper= 1764706
    order by fr8.pepais,fr8.petdoc, fr8.pendoc,capital_atrasado desc;
    cursor c_conyugues(P_N_CUENTA IN NUMBER) is
      select distinct 
             c.ctnro cuenta
        from fsr002 a,
             fsr008 b,
             fsr008 c
       where a.pepais = b.pepais
         and a.petdoc = b.petdoc
         and a.pendoc = b.pendoc
         and b.pepais = c.pepais
         and b.petdoc = c.petdoc
         and b.pendoc = c.pendoc
         and c.ttcod  = 1   
         and b.ctnro  = P_N_CUENTA
         and a.rpccyg = 66;
    
    cursor c_cuentas(p_n_indcre in number) is
    select w.N_MONTO2,
           w.N_MONTO3,
           w.N_MONTO4,
           w.N_MONTO5,
           w.N_MONTO6,
           w.N_MONTO7,
           w.N_MONTO8,
           w.N_MONTO9,
           w.N_MONTO10,
           w.N_MONTO11,
           w.N_MONTO12,
           w.N_MONTO13 
      from (
             select  y.N_MONTO2,
                     y.N_MONTO3,
                     y.N_MONTO4,
                     y.N_MONTO5,
                     y.N_MONTO6,
                     y.N_MONTO7,
                     y.N_MONTO8,
                     y.N_MONTO9,
                     y.N_MONTO10,
                     sum(y.N_MONTO11) N_MONTO11,
                     sum(y.N_MONTO12) N_MONTO12,
                     sum(y.N_MONTO13) N_MONTO13            
                from crdtcap y
               where y.D_FECHA   = P_D_FECHA 
                 and y.N_MONTO1  = p_n_indcre
                 and y.N_MONTO14 in (2,3) 
            group by y.N_MONTO2,
                     y.N_MONTO3,
                     y.N_MONTO4,
                     y.N_MONTO5,
                     y.N_MONTO6,
                     y.N_MONTO7,
                     y.N_MONTO8,
                     y.N_MONTO9,
                     y.N_MONTO10
           ) w
      where w.N_MONTO11 > 0  
   order by w.N_MONTO13 asc, w.N_MONTO12 desc;
      
/*     select y.N_MONTO2,
             y.N_MONTO3,
             y.N_MONTO4,
             y.N_MONTO5,
             y.N_MONTO6,
             y.N_MONTO7,
             y.N_MONTO8,
             y.N_MONTO9,
             y.N_MONTO10,
             y.N_MONTO11,
             y.N_MONTO12,
             min(y.N_MONTO13) N_MONTO13            
        from crdtcap y
       where y.d_fecha  = P_D_FECHA 
         and y.n_monto1 = p_n_indcre
         and not exists (select 1 
                           from crdtcap x 
                          where x.d_fecha = P_D_FECHA
                            and x.n_monto1 <> p_n_indcre
                            and x.N_MONTO2  = y.N_MONTO2 
                            and x.N_MONTO3  = y.N_MONTO3 
                            and x.N_MONTO4  = y.N_MONTO4 
                            and x.N_MONTO5  = y.N_MONTO5 
                            and x.N_MONTO6  = y.N_MONTO6 
                            and x.N_MONTO7  = y.N_MONTO7 
                            and x.N_MONTO8  = y.N_MONTO8 
                            and x.N_MONTO9  = y.N_MONTO9 
                            and x.N_MONTO10 = y.N_MONTO10
                        )
    group by y.N_MONTO2,
             y.N_MONTO3,
             y.N_MONTO4,
             y.N_MONTO5,
             y.N_MONTO6,
             y.N_MONTO7,
             y.N_MONTO8,
             y.N_MONTO9,
             y.N_MONTO10,
             y.N_MONTO11,
             y.N_MONTO12          
   order by  min(y.N_MONTO13) asc, y.N_MONTO12 desc;*/
    
  ln_monpro number(17,2):=0; --monto parcial calculado a pagar del credito
  ln_saldeu number(17,2):=0; --saldo deudor del credito a la fecha de proceso
  ln_salpar number(17,2):=0;
  ln_monret number(17,2):=0; --monto a debitar en la moneda de la cuenta
  ln_monrec number(17,2):=0; --monto a debitar en la moneda del credito
  ln_idcre  number(10):=0;
  ln_tipcam number(14,8):=0;
  --lc_error number;
  ln_cont   number(10):=0;
  ln_mondeb number(17,2):=0; --monto a debitar del ahorro menos itf
  ln_monabo number(17,2):=0; --monto a abonar al credito menos itf
  lc_indexo varchar2(1);     --indicador de exoneracion de cuenta
  ln_itf_a  number(10,2):=0; -- itf ahorro
  ln_itf_c  number(10,2):=0; -- itf credito
  ln_itf_aa number(10,2):=0; -- itf ahorro
  ln_itf_cc number(10,2):=0; -- itf credito
  ln_itfacu number(10,2):=0; -- itf del ahorro acumulado
  ln_montmp number(17,2):=0; --monto temporal;
  
  begin
  begin execute immediate('truncate table crdtcap');end;
  
    For i in c_creditos loop
    
        ln_saldeu := i.Total_deuda; --total deuda en la moneda del credito
        ln_idcre := ln_idcre + 1;
        -- 1.- preguntar si credito existe en tabla de armado de cobros JAQL484
        ln_monpro := pq_ah_compensa_ctas.fn_cr_prorrateo_cre(p_d_jaql484fep => P_D_FECHA,
                                                             p_n_jaql484prc => P_N_CODPRO,                  
                                                             p_n_jaql484pgc => 1,
                                                             p_n_jaql484suc => i.scsuc,
                                                             p_n_jaql484ctc => i.sccta,
                                                             p_n_jaql484mod => i.scmod,
                                                             p_n_jaql484mda => i.scmda,
                                                             p_n_jaql484pap => 0,
                                                             p_n_jaql484ope => i.scoper,
                                                             p_n_jaql484sub => i.scsbop,
                                                             p_n_jaql484tip => i.sctope
                                                             );        
        
           --sI EXISTE OBTENEMOS EL MONTO DE LO CALCULADO HASTA ESE MOMENTO FUNCION(CREDITO ENTRADA, MONTO SALIDA)
             --SALDO DEUDOR = SALDO DEUDOR - MONTO
             ln_saldeu := ln_saldeu - ln_monpro;
             -- CALCULAR resto de deuda 
                -- Buscar saldo de cuentas de los titulares del credito (busca x cta cliente i.sccta)
              pq_ah_compensa_ctas.sp_ah_ctacob(p_d_fecha  => P_D_FECHA,
                                               p_n_cuenta => i.sccta,
                                               p_n_idcred => ln_idcre,
                                               p_n_moneda => i.scmda,
                                               p_n_ordpri => 1,
                                               p_n_saldo  => P_N_SALDO
                                               );                
                -- Buscar saldo de cuentas de los conyugues del credito
               For j in c_conyugues(i.sccta) loop --retorna las cuentas clientes de los conyugues de la cuenta origen
                  pq_ah_compensa_ctas.sp_ah_ctacob_cya(p_d_fecha => P_D_FECHA,
                                                       p_n_cuenta => j.cuenta,
                                                       p_n_idcred => ln_idcre,
                                                       p_n_moneda => i.scmda,
                                                       p_n_ordpri => 2,
                                                       p_n_saldo  => P_N_SALDO
                                                       );                               
               End loop;
             -- Buscar avales del credito cursor c_cta_avales
               For j in c_cta_avales(i.scsuc,i.scmod,i.scmda,i.sccta,i.scoper,i.scsbop,i.sctope) loop
                 -- Buscar saldo de cuentas de los avales del credito
                 pq_ah_compensa_ctas.sp_ah_ctacob(p_d_fecha  => P_D_FECHA,
                                                  p_n_cuenta => j.sng003cta,
                                                  p_n_idcred => ln_idcre,
                                                  p_n_moneda => i.scmda,
                                                  p_n_ordpri => 3,
                                                  p_n_saldo  => P_N_SALDO
                                                  );
                     For k in c_conyugues(j.sng003cta) loop --retorna las cuentas clientes de los conyugues de la cuenta origen
                     -- Buscar saldo de cuentas de los coyugues de los avales del credito
                        pq_ah_compensa_ctas.sp_ah_ctacob_cya(p_d_fecha  => P_D_FECHA,
                                                             p_n_cuenta => k.cuenta,
                                                             p_n_idcred => ln_idcre,
                                                             p_n_moneda => i.scmda,
                                                             p_n_ordpri => 4,
                                                             p_n_saldo  => P_N_SALDO
                                                             );                               
                     End loop;                                                  
               End Loop;
        -- seleccionamos las cuentas y los saldos que quedan.        
        begin
          -- Call the procedure
          pq_ah_compensa_ctas.sp_selecciona_cuentas(p_d_fecha  => P_D_FECHA,
                                                    p_n_indcre => ln_idcre,
                                                    p_n_codpro => P_N_CODPRO
                                                    );
        end;             
        --fin
        
        -- ejecuta proceso de llenado  de la JAQL484               
        For x in c_cuentas(ln_idcre) loop
          ln_salpar := x.n_monto12; --saldo de la cuenta en la moneda del credito
          If ln_saldeu > 0 Then
              If ln_salpar >= ln_saldeu Then
                 If x.n_monto5 = i.scmda Then --si moneda de la cuenta es igual a moneda del credito
                    ln_monret := ln_saldeu; 
                 Else
                    If x.n_monto5 = 0 Then
                       -- invertimos el tipo de cambio para simular lo que hara el cobrador batch
                       ln_tipcam := fn_tipo_cambio(fecha  => P_D_FECHA,
                                                   monori => x.n_monto5,--101,
                                                   mondes => 101,       --x.n_monto5,
                                                   tipo   => 500
                                                  );
                       ln_monret :=  trunc(ln_saldeu *ln_tipcam,2); --round                   
                    Else
                       ln_tipcam := fn_tipo_cambio(fecha  => P_D_FECHA,
                                                   monori => x.n_monto5,       --x.n_monto5,
                                                   mondes => 0,--101,
                                                   tipo   => 500
                                                  );
                       ln_monret :=  trunc(ln_saldeu / ln_tipcam,2);--round                   
                    
                    End If;
                 End If;   
                 ln_monrec := ln_saldeu;
              Else
                 If x.n_monto5 = i.scmda Then --si moneda de la cuenta es igual a moneda del credito
                    ln_monret := ln_salpar;                 
                 Else                             
                    If x.n_monto5 = 0 Then
                      -- invertimos el tipo de cambio para simular lo que hara el cobrador batch
                       ln_tipcam := fn_tipo_cambio(fecha  => P_D_FECHA,
                                                   monori => x.n_monto5, --101,
                                                   mondes => 101,        --x.n_monto5,
                                                   tipo   => 500
                                                  );
                       --ln_monret :=  trunc(ln_salpar * ln_tipcam,2);--round                    
                    Else
                       ln_tipcam := fn_tipo_cambio(fecha  => P_D_FECHA,
                                                   monori => x.n_monto5,        --x.n_monto5,
                                                   mondes => 0,                 --101,
                                                   tipo   => 500
                                                  );
                       --ln_monret :=  trunc(ln_salpar / ln_tipcam,2);--round                                       
                    End If;
                    ln_monret := x.n_monto11;
                 End If;
                  ln_monrec := ln_salpar;
              End If;
          Else
              Exit;    
          End If;
                                                                                               
          
/*          If ln_salpar >= ln_saldeu then
             ln_monabo := ln_saldeu;
          else
             ln_monabo := ln_salpar;
          end if;   */      
                                                                
          If x.n_monto5 = i.scmda then
             ln_monabo := ln_monret /*ln_mondeb*/;                     
          Else
            /* If x.n_monto5 = 0 Then 
                ln_monabo := trunc(ln_mondeb/ln_tipcam,2);--round
             Else
                ln_monabo := trunc(ln_mondeb*ln_tipcam,2);--round
             End If;*/
             ln_monabo := ln_monrec;
          End If;
          
       --verificamos si cta esta exonerada de itf
          lc_indexo := pq_ah_compensa_ctas.fn_cr_verexonera(p_n_pgcod  => x.n_monto2,
                                                            p_n_scmod  => x.n_monto4,
                                                            p_n_scsuc  => x.n_monto3,
                                                            p_n_scmda  => x.n_monto5,
                                                            p_n_scpap  => x.n_monto6,
                                                            p_n_sccta  => x.n_monto7,
                                                            p_n_scoper => x.n_monto8,
                                                            p_n_scsbop => x.n_monto9,
                                                            p_n_sctope => x.n_monto10
                                                           );
                                                                    
          if  lc_indexo = 'N'  then                                               
              --obtenemos montos descontando el itf
              pq_ah_compensa_ctas.sp_cr_montos(p_n_indmon => 'D',
                                               p_n_ctaori => x.n_monto7,
                                               p_n_ctades => i.sccta,
                                               p_n_monret => ln_monabo,   -- en la moneda del credito
                                               p_n_monmah => x.n_monto11, -- saldo en la moneda del ahorro 
                                               p_n_moncue => x.n_monto5,  -- moneda del ahorro
                                               p_n_moncre => i.scmda,     -- moneda del crédito                                               
                                               p_n_tipcam => ln_tipcam,
                                               p_n_mondev => ln_montmp,
                                               p_n_itfmah => ln_itf_aa,
                                               p_n_itfmcr => ln_itf_cc,
                                               p_n_itfrea => ln_itf_a                                                    
                                               ); 
          ln_itfacu := ln_itfacu + ln_itf_aa;                                               
                                                                      
          Else
            --ln_mondeb := ln_monabo;
            ln_itf_a := 0;
          End If;             
          --ln_itf_a := ln_itf;          
          pq_ah_compensa_ctas.sp_cr_montos(p_n_indmon => 'C',
                                           p_n_ctaori => x.n_monto7,
                                           p_n_ctades => i.sccta,
                                           p_n_monret => ln_monabo,
                                           p_n_monmah => x.n_monto11, --saldo en la moneda del ahorro                                            
                                           p_n_moncue => x.n_monto5,  -- moneda del ahorro
                                           p_n_moncre => i.scmda,     -- moneda del crédito                                                                                
                                           p_n_tipcam => ln_tipcam,
                                           p_n_mondev => ln_monabo,
                                           p_n_itfmah => ln_itf_aa,
                                           p_n_itfmcr => ln_itf_cc,
                                           p_n_itfrea => ln_itf_c                                                                                     
                                           ); 
           ln_itfacu := ln_itfacu + ln_itf_aa;                                                   
                                           
           --ln_itf_c := ln_itf;                                           
          If x.n_monto5 = i.scmda then
             ln_mondeb := ln_monabo /*ln_mondeb*/;                     
          Else
             If x.n_monto5 = 0 Then 
                ln_mondeb := trunc(ln_monabo*ln_tipcam,2);--round
             Else
                ln_mondeb := trunc(ln_monabo/ln_tipcam,2);--round
             End If;            
          End If;           
                                              
          -- Registramos pago a  realizar en tabla jaql484
          If ln_monabo > 0 and ln_mondeb > 0  Then 
              ln_cont := ln_cont + 1;
              pq_ah_compensa_ctas.sp_registra_cobro(p_d_jaql484fep => P_D_FECHA,
                                                    p_n_jaql484prc => P_N_CODPRO,               
                                                    p_n_jaql484cor => ln_cont,
                                                    p_n_jaql484pgc => 1,
                                                    p_n_jaql484suc => i.scsuc,
                                                    p_n_jaql484ctc => i.sccta,
                                                    p_n_jaql484mod => i.scmod,
                                                    p_n_jaql484mda => i.scmda,
                                                    p_n_jaql484pap => 0,
                                                    p_n_jaql484ope => i.scoper,
                                                    p_n_jaql484sub => i.scsbop,
                                                    p_n_jaql484tip => i.sctope,
                                                    p_n_jaql484pga => x.n_monto2,
                                                    p_n_jaql484sua => x.n_monto3,
                                                    p_n_jaql484cta => x.n_monto7,
                                                    p_n_jaql484moa => x.n_monto4,
                                                    p_n_jaql484maa => x.n_monto5,
                                                    p_n_jaql484paa => x.n_monto6,
                                                    p_n_jaql484opa => x.n_monto8,
                                                    p_n_jaql484sba => x.n_monto9,
                                                    p_n_jaql484tia => x.n_monto10,
                                                    p_n_jaql484dec => ln_saldeu,--i.Total_deuda,
                                                    p_n_jaql484mtr => ln_mondeb,--ln_monret,
                                                    p_n_jaql484tcc => ln_tipcam,
                                                    p_c_jaql484est => 'I',
                                                    p_c_jaql484mot => '',
                                                    p_n_jaql484ax4 => ln_monabo,
                                                    p_n_jaql484ax1 => x.n_monto13,
                                                    p_n_jaql484ax2 => i.n_numcuo,
                                                    p_n_jaql484ax9 => i.c_codana,
                                                    p_n_jaql484a10 => ln_itf_a,
                                                    p_n_jaql484a11 => ln_itf_c,
                                                    p_n_jaql484a12 => i.dia_atraso,
                                                    p_n_jaql484ax5 => i.capital_atrasado,
                                                    p_n_jaql484ax6 => ln_itfacu
                                                   );                                                                                                                                                        
              -- Restamos saldo deudor - ln_monret
              ln_saldeu := ln_saldeu - ln_monabo;--ln_monrec;
          End If;        
          ln_tipcam := 0;
          ln_mondeb := 0;
          ln_monabo := 0;    
          ln_itfacu := 0;        
        End Loop;    
        --limpiar tabla de cuentas
         begin execute immediate('truncate table crdtcap');end;                     
        --
    End Loop;
    commit;    
    
  --Exception
  --When others then
    --lc_error := ln_idcre;
    --null;
  End sp_ah_genera_cobros;  
  
       
  
  Function fn_facultad_cta(vpgcod  number,
                           vscsuc  number,
                           vscmda  number,
                           vscpap  number,
                           vsccta  number,
                           vscoper number,
                           vscsbop number,
                           vscmod  number
                         ) return number is
  facultad number(3);
  begin
    select Case R2sbop
             when 1 then
              1
             when 511 then
              511
             else
              2
           end
      into facultad
      from fsr011
     Where Relcod = 5
       and R1cod = vpgcod
       and R1mod = vscmod
       and R1suc = vscsuc
       and R1mda = vscmda
       and R1pap = vscpap
       and R1cta = vsccta
       and R1oper = vscoper
       and R1sbop = vscsbop
       and rownum = 1;

       return(facultad);
  Exception
  When no_data_found then
    begin
      select Case ctfaccor
               when 1 then
                1
               when 511 then
                511
               else
                2
             end
        into facultad
        from fse130
       where pgcod = vpgcod
         and ctnro = vsccta
         and rownum = 1;
    Exception
    When no_data_found then
        facultad := 0;
    end;
    return(facultad);
  end fn_facultad_cta;      

  Function fn_cr_prorrateo_cre(P_D_JAQL484FEP IN DATE,
                               P_N_JAQL484PRC IN NUMBER,
                               P_N_JAQL484PGC IN NUMBER,
                               P_N_JAQL484SUC IN NUMBER,
                               P_N_JAQL484CTC IN NUMBER,
                               P_N_JAQL484MOD IN NUMBER,
                               P_N_JAQL484MDA IN NUMBER,
                               P_N_JAQL484PAP IN NUMBER,
                               P_N_JAQL484OPE IN NUMBER,
                               P_N_JAQL484SUB IN NUMBER,
                               P_N_JAQL484TIP IN NUMBER       
                               )return number is  
  ln_monpro number(17,2):=0;                               
  begin  
    select sum(JAQL484AX4) into ln_monpro-- monto pagado en la moneda del credito
     from JAQL484 
    where JAQL484FEP = P_D_JAQL484FEP
      and JAQL484PRC = P_N_JAQL484PRC 
      and JAQL484PGC = P_N_JAQL484PGC
      and JAQL484SUC = P_N_JAQL484SUC
      and JAQL484CTC = P_N_JAQL484CTC
      and JAQL484MOD = P_N_JAQL484MOD
      and JAQL484MDA = P_N_JAQL484MDA
      and JAQL484PAP = P_N_JAQL484PAP
      and JAQL484OPE = P_N_JAQL484OPE
      and JAQL484SUB = P_N_JAQL484SUB
      and JAQL484TIP = P_N_JAQL484TIP
      and JAQL484EST = 'I';      
    return nvl(ln_monpro,0);
  Exception                    
  When others then
       ln_monpro := 0;
       return ln_monpro;
  end fn_cr_prorrateo_cre;     
  
  Procedure sp_ah_ctacob(P_D_FECHA  IN DATE,
                         P_N_CUENTA IN NUMBER,
                         P_N_IDCRED IN NUMBER,
                         P_N_MONEDA IN NUMBER,
                         P_N_ORDPRI IN NUMBER,
                         P_N_SALDO  IN NUMBER
                        ) is
  cursor c_cuentas is
    select  q.pgcod,q.scsuc, q.scmod, q.scmda, q.scpap,q.sccta, q.scoper,q.scsbop,q.sctope,
            Case
              when z.scsdo - fn_ah_salafp(q.pgcod,q.scmod,q.scsuc,q.scmda,q.scpap,q.sccta,q.scoper,q.scsbop,q.sctope) < 0 then
                0
               Else
                z.scsdo - fn_ah_salafp(q.pgcod,q.scmod,q.scsuc,q.scmda,q.scpap,q.sccta,q.scoper,q.scsbop,q.sctope)
            End scsdo,
            Case
              When P_N_MONEDA = 0 then
               Case
                   when q.scmda = 0 then
                        z.scsdo
                   Else
                        trunc(z.scsdo * fn_tipo_cambio(fecha  => P_D_FECHA,
                                                 monori => q.scmda,--0,
                                                 mondes => 0,--q.scmda,
                                                 tipo   => 500
                                                 ) 
                                                 , 2)--round  
                   End
                   
              Else   Case
                       When q.scmda = 0 then
                            trunc(z.scsdo / fn_tipo_cambio(fecha  => P_D_FECHA,
                                                           monori => q.scmda,--101,
                                                           mondes => 101,--q.scmda,
                                                           tipo   => 500
                                                           )
                                                           , 2)--round
                       Else
                            z.scsdo
                       End                        
            End sal_mon_cre     
      from 
           (select w.pgcod, w.scmda, w.scsuc, w.sccta, w.scsbop, sum(w.scsdo) scsdo
              from 
                   (select a.pgcod, a.scmda, a.scsuc, a.sccta, a.scsbop, a.scsdo
                      from fsd011 a,
                           (select distinct b.pgcod, b.ctnro
                              from fsr008 b,
                                   fsr008 c
                             Where c.ctnro = P_N_CUENTA
                               and c.pgcod = b.pgcod
                               and c.pepais = b.pepais
                               and c.petdoc = b.petdoc
                               and c.pendoc = b.pendoc
                               and b.ttcod = c.ttcod
                               and c.ttcod = 1                               
                            ) d,
                            fst198 g
                     where a.pgcod    = d.pgcod
                       and a.sccta    = d.ctnro
                       --and a.scmod = 21
                       --and a.sctope  in (1, 3)                       
                       and a.scmod    = g.Tp1nro1
                       and a.sctope   = g.Tp1nro2
                       and g.Tp1cod   = 1
                       and g.Tp1cod1  = 10825
                       and g.tp1corr1 = 63
                       and g.tp1corr2 = 1                       
                       and a.scstat not in (99, /*81,*/ 6, 7)
                       and a.scsdo > 0
                    union
                    select e.pgcod, e.scmda,e.scsuc, e.sccta, e.scsbop, e.scsdo
                      from fsd011 e,
                           (select distinct x.pgcod, x.ctnro
                              from fsr008 x, 
                                   fsr008 y
                             Where y.ctnro  = P_N_CUENTA
                               and y.pgcod  = x.pgcod
                               and y.pepais = x.pepais
                               and y.petdoc = x.petdoc
                               and y.pendoc = x.pendoc
                               and x.ttcod = y.ttcod
                               and y.ttcod = 1
                            ) f
                     where e.pgcod = f.pgcod
                       and e.sccta = f.ctnro
                       and e.scmod = 136
                       and e.scsdo < 0
                  ) w
            where pq_ah_compensa_ctas.fn_facultad_cta(w.pgcod,w.scsuc,w.scmda,0,w.sccta,0,w.scsbop,21) <> 511      
           group by w.pgcod, w.scmda, w.scsuc, w.sccta, w.scsbop
             ) z,
            fsd011 q,
            fst198 m
       where q.pgcod = z.pgcod
         and q.scsuc = z.scsuc
         and q.scmda = z.scmda         
         and q.sccta = z.sccta
         and q.scsbop = z.scsbop
         and q.scoper = 0         
         and q.scpap = 0
         --and q.scmod = 21
         --and q.sctope  in (1, 3)
         and q.scmod    = m.Tp1nro1 
         and q.sctope   = m.Tp1nro2
         and m.Tp1cod   = 1
         and m.Tp1cod1  = 10825
         and m.tp1corr1 = 63
         and m.tp1corr2 = 1                                
         and q.scstat not in (99, /*81,*/ 6, 7)         
        ;
  begin
    For i in c_cuentas loop
      If i.scsdo >= P_N_SALDO then
        insert into crdtcap(D_FECHA ,
                            N_MONTO1,
                            N_MONTO2,
                            N_MONTO3,
                            N_MONTO4,
                            N_MONTO5,
                            N_MONTO6,
                            N_MONTO7,
                            N_MONTO8,
                            N_MONTO9,
                            N_MONTO10,
                            N_MONTO11,
                            N_MONTO12,
                            N_MONTO13,
                            N_MONTO14
                            )
                     values(P_D_FECHA,
                            P_N_IDCRED,
                            i.pgcod,
                            i.scsuc, 
                            i.scmod, 
                            i.scmda, 
                            i.scpap,
                            i.sccta, 
                            i.scoper,
                            i.scsbop,
                            i.sctope,
                            i.scsdo,
                            i.sal_mon_cre,
                            P_N_ORDPRI,
                            1   
                            );
      End If;                          
    End Loop;      
/*  Exception 
  When Others Then
       null;   */         
  End sp_ah_ctacob;         
  Procedure sp_registra_cobro(P_D_JAQL484FEP IN DATE,
                              P_N_JAQL484PRC IN NUMBER,
                              P_N_JAQL484COR IN NUMBER,
                              P_N_JAQL484PGC IN NUMBER,
                              P_N_JAQL484SUC IN NUMBER,
                              P_N_JAQL484CTC IN NUMBER,
                              P_N_JAQL484MOD IN NUMBER,
                              P_N_JAQL484MDA IN NUMBER,
                              P_N_JAQL484PAP IN NUMBER,
                              P_N_JAQL484OPE IN NUMBER,
                              P_N_JAQL484SUB IN NUMBER,
                              P_N_JAQL484TIP IN NUMBER,
                              --
                              P_N_JAQL484PGA IN NUMBER,
                              P_N_JAQL484SUA IN NUMBER,
                              P_N_JAQL484CTA IN NUMBER,
                              P_N_JAQL484MOA IN NUMBER, 
                              P_N_JAQL484MAA IN NUMBER,
                              P_N_JAQL484PAA IN NUMBER,  
                              P_N_JAQL484OPA IN NUMBER,  
                              P_N_JAQL484SBA IN NUMBER,  
                              P_N_JAQL484TIA IN NUMBER,  
                              --  
                              P_N_JAQL484DEC IN NUMBER,  
                              P_N_JAQL484MTR IN NUMBER,  
                              P_N_JAQL484TCC IN NUMBER,  
                              P_C_JAQL484EST IN VARCHAR2,  
                              P_C_JAQL484MOT IN VARCHAR2,
                              P_N_JAQL484AX4 IN NUMBER,  
                              P_N_JAQL484AX1 IN NUMBER,
                              P_N_JAQL484AX2 IN NUMBER,
                              P_N_JAQL484AX9 IN VARCHAR2,      
                              P_N_JAQL484A10 IN NUMBER,
                              P_N_JAQL484A11 IN NUMBER,
                              P_N_JAQL484A12 IN NUMBER,
                              P_N_JAQL484AX5 IN NUMBER,                                                                                                              
                              P_N_JAQL484AX6 IN NUMBER         
                             ) is
                             
  --lc_error varchar2(400);                             
  Begin                             
    insert into jaql484(JAQL484FEP,
                        JAQL484PRC,
                        JAQL484COR,
                        JAQL484PGC,
                        JAQL484SUC,
                        JAQL484CTC,
                        JAQL484MOD,
                        JAQL484MDA,
                        JAQL484PAP,
                        JAQL484OPE,
                        JAQL484SUB,
                        JAQL484TIP,
                        
                        JAQL484PGA,
                        JAQL484SUA,
                        JAQL484CTA,
                        JAQL484MOA,
                        JAQL484MAA,
                        JAQL484PAA,
                        JAQL484OPA,
                        JAQL484SBA,
                        JAQL484TIA,
                        
                        JAQL484DEC,
                        JAQL484MTR,
                        JAQL484TCC,
                        JAQL484EST,
                        JAQL484MOT,
                        JAQL484AX4,
                        JAQL484AX1,
                        JAQL484AX2,
                        JAQL484AX9,
                        JAQL484A10,
                        JAQL484A11,
                        JAQL484A12,
                        JAQL484AX5,
                        JAQL484AX6                                                 
                       )
                 values(P_D_JAQL484FEP,
                        P_N_JAQL484PRC,
                        P_N_JAQL484COR,
                        P_N_JAQL484PGC,
                        P_N_JAQL484SUC,
                        P_N_JAQL484CTC,
                        P_N_JAQL484MOD,
                        P_N_JAQL484MDA,
                        P_N_JAQL484PAP,
                        P_N_JAQL484OPE,
                        P_N_JAQL484SUB,
                        P_N_JAQL484TIP,
                        --
                        P_N_JAQL484PGA,
                        P_N_JAQL484SUA,
                        P_N_JAQL484CTA,
                        P_N_JAQL484MOA,
                        P_N_JAQL484MAA,
                        P_N_JAQL484PAA,
                        P_N_JAQL484OPA,
                        P_N_JAQL484SBA,
                        P_N_JAQL484TIA,
                        --  
                        P_N_JAQL484DEC,
                        P_N_JAQL484MTR,
                        P_N_JAQL484TCC,
                        P_C_JAQL484EST,
                        P_C_JAQL484MOT,
                        P_N_JAQL484AX4,
                        P_N_JAQL484AX1,
                        P_N_JAQL484AX2,
                        P_N_JAQL484AX9,
                        P_N_JAQL484A10,
                        P_N_JAQL484A11,
                        P_N_JAQL484A12,
                        P_N_JAQL484AX5,
                        P_N_JAQL484AX6                                                
                       );
/*  Exception
  When others then
    --lc_error := sqlerrm;                       
    null;*/
  End sp_registra_cobro;                                                                 
  Procedure sp_cr_montos(P_N_INDMON IN VARCHAR2,
                         P_N_CTAORI IN NUMBER,
                         P_N_CTADES IN NUMBER,
                         P_N_MONRET IN NUMBER,
                         P_N_MONMAH IN NUMBER,
                         P_N_MONCUE IN NUMBER,
                         P_N_MONCRE IN NUMBER,     
                         P_N_TIPCAM IN NUMBER,                       
                         P_N_MONDEV OUT NUMBER,
                         P_N_ITFMAH IN OUT NUMBER,--itf en la moneda del ahorro
                         P_N_ITFMCR IN OUT NUMBER, --itf en la moneda del credito
                         P_N_ITFREA OUT NUMBER
                         ) IS            
  ln_itf    number(10,2):=0;                          
  ln_itf_c  number(10,2):=0;  
  ln_monval number(17,2);
  begin
    
  ln_itf := pq_ah_compensa_ctas.fn_calcula_itf(P_N_MONRET);  
  
/*  IF P_N_MONCUE = P_N_MONCRE THEN
     ln_itf_c   := ln_itf;     
  ELSE
     IF P_N_MONCUE = 0 THEN
         ln_itf_c:= trunc(ln_itf*P_N_TIPCAM,2);--round
     ELSE
         ln_itf_c:= trunc(ln_itf/P_N_TIPCAM,2);--round
     END IF;      
  END IF;*/
    IF P_N_MONCUE = P_N_MONCRE THEN
       ln_itf_c   := ln_itf;   
       ln_monval  := P_N_MONRET;  
    ELSE  
      IF P_N_MONCUE = 0 THEN
          ln_monval := trunc(P_N_MONRET*P_N_TIPCAM,2);--round
      ELSE
          ln_monval := trunc(P_N_MONRET/P_N_TIPCAM,2);--round
      END IF;  
      ln_itf_c := pq_ah_compensa_ctas.fn_calcula_itf(ln_monval);      
    END IF;      
    If P_N_INDMON = 'D' Then                     
        If ln_itf_c > 0 then                            
            If ln_monval + ln_itf_c <= P_N_MONMAH then     
               P_N_MONDEV := P_N_MONRET; 
               P_N_ITFMAH := ln_itf_c; --ITF EN LA MONEDA DEL AHORROS 
               P_N_ITFMCR := ln_itf;   --ITF EN LA MONEDA DEL CREDITO                                               
            Else
               P_N_MONDEV := P_N_MONRET - ln_itf;    
               P_N_ITFMAH := ln_itf_c; --ITF EN LA MONEDA DEL AHORROS 
               P_N_ITFMCR := ln_itf;   --ITF EN LA MONEDA DEL CREDITO                 
            End If;            
        Else
          P_N_MONDEV := P_N_MONRET;  
          P_N_ITFMAH := ln_itf_c; --ITF EN LA MONEDA DEL AHORROS 
          P_N_ITFMCR := ln_itf;   --ITF EN LA MONEDA DEL CREDITO                      
        End If;  
    P_N_ITFREA := P_N_ITFMAH;          
    Else     
        If ln_itf > 0 then
            If P_N_CTAORI = P_N_CTADES then      
              
               ln_itf_c := 0;   
               ln_itf   := 0;     
               
               If ln_monval + P_N_ITFMAH  <= P_N_MONMAH then
                    P_N_MONDEV := P_N_MONRET;
                    P_N_ITFMAH := ln_itf_c; --ITF EN LA MONEDA DEL AHORROS 
                    P_N_ITFMCR := ln_itf;   --ITF EN LA MONEDA DEL CREDITO                      
               Else
                    P_N_MONDEV := P_N_MONRET - P_N_ITFMAH;   
                    P_N_ITFMAH := ln_itf_c; --ITF EN LA MONEDA DEL AHORROS 
                    P_N_ITFMCR := ln_itf;   --ITF EN LA MONEDA DEL CREDITO                      
               End If;                 
/*               ln_itf   := 0; 
               ln_itf_c := 0;
               P_N_MONDEV := P_N_MONRET;       
               P_N_ITFMAH := ln_itf_c; --ITF EN LA MONEDA DEL AHORROS 
               P_N_ITFMCR := ln_itf;   --ITF EN LA MONEDA DEL CREDITO  */                        
            Else
               IF P_N_MONCUE = P_N_MONCRE THEN   
                  ln_itf_c := ln_itf;        
               ELSE
                 IF P_N_MONCUE = 0 THEN
                     ln_itf_c := trunc(ln_itf*P_N_TIPCAM,2);--round
                 ELSE
                     ln_itf_c := trunc(ln_itf/P_N_TIPCAM,2);--round
                 END IF;      
               END IF;  
                       
               If ln_monval + P_N_ITFMAH + ln_itf_c <= P_N_MONMAH then      
                  P_N_MONDEV := P_N_MONRET;    
                  P_N_ITFMAH := ln_itf_c; --ITF EN LA MONEDA DEL AHORROS 
                  P_N_ITFMCR := ln_itf;   --ITF EN LA MONEDA DEL CREDITO                    
               Else
                 If ln_monval + P_N_ITFMAH  <= P_N_MONMAH then
                    P_N_MONDEV := P_N_MONRET - ln_itf;   
                    P_N_ITFMAH := ln_itf_c; --ITF EN LA MONEDA DEL AHORROS 
                    P_N_ITFMCR := ln_itf;   --ITF EN LA MONEDA DEL CREDITO                      
                 Else
                    P_N_MONDEV := P_N_MONRET - ln_itf - P_N_ITFMCR;   
                    P_N_ITFMAH := ln_itf_c; --ITF EN LA MONEDA DEL AHORROS 
                    P_N_ITFMCR := ln_itf;   --ITF EN LA MONEDA DEL CREDITO                      
                 End If;
               End if;                
            End if;  
        Else
          P_N_MONDEV := P_N_MONRET;  
          P_N_ITFMAH := ln_itf_c; --ITF EN LA MONEDA DEL AHORROS 
          P_N_ITFMCR := ln_itf;   --ITF EN LA MONEDA DEL CREDITO                              
        End If;  
    P_N_ITFREA := P_N_ITFMCR;      
    End if;     
   
  end sp_cr_montos;     
  Function  fn_cr_verexonera(P_N_PGCOD  IN NUMBER,
                             P_N_SCMOD  IN NUMBER,
                             P_N_SCSUC  IN NUMBER,
                             P_N_SCMDA  IN NUMBER,
                             P_N_SCPAP  IN NUMBER,
                             P_N_SCCTA  IN NUMBER,
                             P_N_SCOPER IN NUMBER,
                             P_N_SCSBOP IN NUMBER,
                             P_N_SCTOPE IN NUMBER
                            ) return varchar2 is
  lc_indexo varchar2(1):= 'N';
  begin
     SELECT 'S' into lc_indexo
       FROM TI0010
      WHERE TIPGCOD   = P_N_PGCOD
        AND TISCSUC   = P_N_SCSUC
        AND TISCMOD   = P_N_SCMOD
        AND TISCMDA   = P_N_SCMDA
        AND TISCPAP   = P_N_SCPAP
        AND TISCCTA   = P_N_SCCTA
        AND TISCOPER  = P_N_SCOPER
        AND TISCSBOP  = P_N_SCSBOP
        AND TISCTOPE  = P_N_SCTOPE
        AND TIIMPUCOD = 9;  
    return lc_indexo;    
  exception
  when too_many_rows then
       lc_indexo := 'S';
       return lc_indexo;    
  when others then      
       lc_indexo := 'N';
       return lc_indexo;    
  end fn_cr_verexonera;  
  
  Function  fn_calcula_itf(P_N_MONTO  IN NUMBER) return number is
  ln_poritf number(14,8):= 0;     
  ln_fijo1  number(1)   := 5;      
  ln_fijo2  number(5,2) := 0.05;
  ln_valor1 number(10,2):= 0;
  ln_valor2 number(10,2):= 0;
  ln_itf    number(10,2):= 0;
  begin
     begin
       select coefic into ln_poritf
         from fst144
        where coecod = 7
          and coefdes =
              (select max(coefdes) from fst144 where coecod = 7);       
     end;
  ln_valor1 := trunc(P_N_MONTO*ln_poritf,2);     
  ln_valor2 := trunc(P_N_MONTO*ln_poritf,1);
  
  If (ln_valor1 - ln_valor2)*100 >= ln_fijo1 then
     ln_itf := ln_valor1 + (ln_fijo2 - (ln_valor1 - ln_valor2));                
  Else
     ln_itf := ln_valor1 - (ln_valor1 - ln_valor2);
  end If;
  
  return ln_itf;   
  end fn_calcula_itf;     
  Procedure sp_actualiza_pro(P_N_CODPRO IN NUMBER) is
  Begin
    update fst198
       set Tp1nro1 = P_N_CODPRO + 1
     where tp1cod   = 1
       and tp1cod1  = 10825
       and tp1corr1 = 5
       and tp1corr2 = 1;
    commit;
  End sp_actualiza_pro;   
  Procedure sp_selecciona_cuentas(P_D_FECHA  IN DATE,
                                  P_N_INDCRE IN NUMBER,
                                  P_N_CODPRO IN NUMBER         
                                  ) is
                                   
  Begin
    --insertamos las cuentas encontradas sin repeticion y con su prioridad
    begin 
        insert into crdtcap(D_FECHA,N_MONTO1,N_MONTO2,N_MONTO3,N_MONTO4,N_MONTO5,N_MONTO6,N_MONTO7,N_MONTO8,N_MONTO9,N_MONTO10,N_MONTO11,N_MONTO12,N_MONTO13,N_MONTO14)
              select y.D_FECHA,
                     y.N_MONTO1,
                     y.N_MONTO2,
                     y.N_MONTO3,
                     y.N_MONTO4,
                     y.N_MONTO5,
                     y.N_MONTO6,
                     y.N_MONTO7,
                     y.N_MONTO8,
                     y.N_MONTO9,
                     y.N_MONTO10,
                     y.N_MONTO11,
                     y.N_MONTO12,
                     min(y.N_MONTO13) N_MONTO13,
                     2                N_MONTO14            
                from crdtcap y
               where y.d_fecha   = P_D_FECHA 
                 and y.n_monto1  = P_N_INDCRE
                 and y.N_MONTO14 = 1
            group by y.D_FECHA,
                     y.N_MONTO1,
                     y.N_MONTO2,
                     y.N_MONTO3,
                     y.N_MONTO4,
                     y.N_MONTO5,
                     y.N_MONTO6,
                     y.N_MONTO7,
                     y.N_MONTO8,
                     y.N_MONTO9,
                     y.N_MONTO10,
                     y.N_MONTO11,
                     y.N_MONTO12;          
    Exception
    when others then
         null;                
    end;
    --insertamos cuentas que se utilizaron con saldo utilizado (no se deben de repetir)
     
    begin
      insert into crdtcap(D_FECHA,N_MONTO1,N_MONTO2,N_MONTO3,N_MONTO4,N_MONTO5,N_MONTO6,N_MONTO7,N_MONTO8,N_MONTO9,N_MONTO10,N_MONTO11,N_MONTO12,N_MONTO13,N_MONTO14)
        select a.jaql484fep,
               P_N_INDCRE,
               a.JAQL484PGA,
               a.JAQL484SUA,
               a.JAQL484MOA,
               a.JAQL484MAA,
               a.JAQL484PAA,               
               a.JAQL484CTA,
               a.JAQL484OPA,
               a.JAQL484SBA,
               a.JAQL484TIA,
               sum(-1*(a.jaql484mtr + a.jaql484ax6)) N_MONTO11,    --saldo utilizado en la moneda del ahorro
               sum(-1*(a.jaql484ax4)) N_MONTO12,                   --saldo utilizado en la moneda del credito                
               0 N_MONTO13,
               3 N_MONTO14  
         from jaql484 a
        where a.jaql484fep = P_D_FECHA
          and a.jaql484prc = P_N_CODPRO
     group by a.jaql484fep,
              P_N_INDCRE,
              a.JAQL484PGA,
              a.JAQL484SUA,
              a.JAQL484CTA,
              a.JAQL484MOA,
              a.JAQL484MAA,
              a.JAQL484PAA,
              a.JAQL484OPA,
              a.JAQL484SBA,
              a.JAQL484TIA;    
    exception
    When others then    
         null;
    end;
  End sp_selecciona_cuentas;                                                      
  Procedure sp_ah_ctacob_cya(P_D_FECHA  IN DATE,
                               P_N_CUENTA IN NUMBER,
                               P_N_IDCRED IN NUMBER,
                               P_N_MONEDA IN NUMBER,
                               P_N_ORDPRI IN NUMBER,
                               P_N_SALDO  IN NUMBER
                              ) is
  cursor c_cuentas is
    select  q.pgcod,q.scsuc, q.scmod, q.scmda, q.scpap,q.sccta, q.scoper,q.scsbop,q.sctope,
            Case
              when z.scsdo - fn_ah_salafp(q.pgcod,q.scmod,q.scsuc,q.scmda,q.scpap,q.sccta,q.scoper,q.scsbop,q.sctope) < 0 then
                0
               Else
                z.scsdo - fn_ah_salafp(q.pgcod,q.scmod,q.scsuc,q.scmda,q.scpap,q.sccta,q.scoper,q.scsbop,q.sctope)
            End scsdo,    
            Case
              When P_N_MONEDA = 0 then
               Case
                   when q.scmda = 0 then
                        z.scsdo
                   Else
                        trunc(z.scsdo * fn_tipo_cambio(fecha  => P_D_FECHA,
                                                 monori => q.scmda,--0,
                                                 mondes => 0,--q.scmda,
                                                 tipo   => 500
                                                 ) 
                                                 , 2)--round  
                   End
                   
              Else   Case
                       When q.scmda = 0 then
                            trunc(z.scsdo / fn_tipo_cambio(fecha  => P_D_FECHA,
                                                           monori => q.scmda,--101,
                                                           mondes => 101,--q.scmda,
                                                           tipo   => 500
                                                           )
                                                           , 2)--round
                       Else
                            z.scsdo
                       End                        
            End sal_mon_cre     
      from 
           (select w.pgcod, w.scmda, w.scsuc, w.sccta, w.scsbop, sum(w.scsdo) scsdo
              from 
                   (select a.pgcod, a.scmda, a.scsuc, a.sccta, a.scsbop, a.scsdo
                      from fsd011 a,
                           fst198 g
                     where a.pgcod = 1
                       and a.sccta = P_N_CUENTA
                       --and a.scmod = 21
                       --and a.sctope  in (1, 3)
                       and a.scmod    = g.Tp1nro1
                       and a.sctope   = g.Tp1nro2
                       and g.Tp1cod   = 1
                       and g.Tp1cod1  = 10825
                       and g.tp1corr1 = 63
                       and g.tp1corr2 = 1                        
                       and a.scstat not in (99, /*81,*/ 6, 7)
                       and a.scsdo > 0
                    union
                    select e.pgcod, e.scmda,e.scsuc, e.sccta, e.scsbop, e.scsdo
                      from fsd011 e
                     where e.pgcod = 1
                       and e.sccta = P_N_CUENTA
                       and e.scmod = 136
                       and e.scsdo < 0
                  ) w
            where pq_ah_compensa_ctas.fn_facultad_cta(w.pgcod,w.scsuc,w.scmda,0,w.sccta,0,w.scsbop,21) <> 511      
           group by w.pgcod, w.scmda, w.scsuc, w.sccta, w.scsbop
             ) z,
            fsd011 q,
            fst198 m
       where q.pgcod = z.pgcod
         and q.scsuc = z.scsuc
         and q.scmda = z.scmda         
         and q.sccta = z.sccta
         and q.scsbop = z.scsbop
         and q.scoper = 0         
         and q.scpap = 0
         --and q.scmod = 21
         --and q.sctope  in (1, 3)
         and q.scmod    = m.Tp1nro1
         and q.sctope   = m.Tp1nro2
         and m.Tp1cod   = 1
         and m.Tp1cod1  = 10825
         and m.tp1corr1 = 63
         and m.tp1corr2 = 1          
         and q.scstat not in (99, /*81,*/ 6, 7)         
        ;
  begin
       
    For i in c_cuentas loop
      If i.scsdo >= P_N_SALDO then
        insert into crdtcap(D_FECHA ,
                            N_MONTO1,
                            N_MONTO2,
                            N_MONTO3,
                            N_MONTO4,
                            N_MONTO5,
                            N_MONTO6,
                            N_MONTO7,
                            N_MONTO8,
                            N_MONTO9,
                            N_MONTO10,
                            N_MONTO11,
                            N_MONTO12,
                            N_MONTO13,
                            N_MONTO14
                            )
                     values(P_D_FECHA,
                            P_N_IDCRED,
                            i.pgcod,
                            i.scsuc, 
                            i.scmod, 
                            i.scmda, 
                            i.scpap,
                            i.sccta, 
                            i.scoper,
                            i.scsbop,
                            i.sctope,
                            i.scsdo,
                            i.sal_mon_cre,
                            P_N_ORDPRI,
                            1   
                            );
      End If;                          
    End Loop;      
/*  Exception 
  When Others Then
       null;   */         
  End sp_ah_ctacob_cya;  
  Function  fn_ah_salafp(P_N_PGCOD IN NUMBER,
                         P_N_SCMOD IN NUMBER,
                         P_N_SCSUC IN NUMBER,
                         P_N_SCMDA IN NUMBER,
                         P_N_SCPAP IN NUMBER,
                         P_N_SCCTA IN NUMBER,
                         P_N_SCOPER IN NUMBER,
                         P_N_SCSBOP IN NUMBER,
                         P_N_SCTOPE IN NUMBER
                        ) return number is
  ln_saldo  number(17,2) :=0;
  ln_totdep number(17,2) :=0;
  ln_totret number(17,2) :=0;
  ld_fecdep date;
  ln_numseq number(9);
  ld_fecpro date;
  ld_fecbon date;
  ld_fecafp date;
  ln_monto  number(17,2):=0;
  begin
    begin
      Select a.pgfape into ld_fecpro from fst017 a where a.pgcod = 1;
    end;
    begin
      Select nvl(max(b.aqpa118seq),0) 
        into ln_numseq
        from aqpa118a a, 
             aqpa118  b
       where a.aqpa118aseq = b.aqpa118seq
         and a.aqpa118apgc = P_N_PGCOD 
         and a.aqpa118amod = P_N_SCMOD 
         and a.aqpa118asuc = P_N_SCSUC 
         and a.aqpa118amda = P_N_SCMDA 
         and a.aqpa118apap = P_N_SCPAP 
         and a.aqpa118acta = P_N_SCCTA 
         and a.aqpa118aope = P_N_SCOPER
         and a.aqpa118asbo = P_N_SCSBOP
         and a.aqpa118atop = P_N_SCTOPE
         and b.aqpa118est = 'P'
         and a.aqpa118atde > 0
         and a.aqpa118arpt <> '2';
    exception
    when others then
      ln_numseq := 0;
    end;
    --verificamos tablas de importaciones
 begin
   Select max(case
              when b.jaql72ax02 = 1 then
                   a.jaql71fepr + 365
              when b.jaql72ax02 = 2 then
                   a.jaql71fepr + 150
              Else
                   ld_fecpro
              end
              ), 
          nvl(sum(b.jaql72impo), 0)
     into ld_fecbon, 
          ln_monto
     from jaql071 a, jaql072 b, aqpa124 c
    where a.jaql71nuim = b.jaql72nuim
      and b.jaql72nuim = c.aqpa124imp
      and b.jaql72ax02 > 0
      and b.jaql72impo > 0
      and a.jaql71esta = 'P'
      and b.jaql72pgco = P_N_PGCOD
      and b.jaql72scsu = P_N_SCSUC
      and b.jaql72scmo = P_N_SCMOD
      and b.jaql72scmd = P_N_SCMDA
      and b.jaql72scpa = P_N_SCPAP
      and b.jaql72scct = P_N_SCCTA
      and b.jaql72scop = P_N_SCOPER
      and b.jaql72scsb = P_N_SCSBOP
      and b.jaql72scto = P_N_SCTOPE
      and ld_fecpro < case
                      when b.jaql72ax02 = 1 then
                           a.jaql71fepr + 365
                      when b.jaql72ax02 = 2 then
                           a.jaql71fepr + 150
                      Else
                           ld_fecpro
                      end;
         ln_totdep := ln_totdep + ln_monto;
    exception
    when others then
      ld_fecbon := to_date('01/01/0001','dd/mm/rrrr');
      ln_monto := 0;
    end;
        
    if ln_numseq > 0 or ln_totdep > 0 then
      begin
        Select a.aqpa118aacu,
               a.aqpa118afde + 365       
          into ln_monto,
               ld_fecafp
          from aqpa118a a
         where a.aqpa118aseq = ln_numseq
           and a.aqpa118apgc = P_N_PGCOD 
           and a.aqpa118amod = P_N_SCMOD 
           and a.aqpa118asuc = P_N_SCSUC 
           and a.aqpa118amda = P_N_SCMDA 
           and a.aqpa118apap = P_N_SCPAP 
           and a.aqpa118acta = P_N_SCCTA 
           and a.aqpa118aope = P_N_SCOPER
           and a.aqpa118asbo = P_N_SCSBOP
           and a.aqpa118atop = P_N_SCTOPE
           and (a.aqpa118afde + 365) >= ld_fecpro;    
           ln_totdep := ln_totdep + ln_monto;
      exception
      when others then
        ld_fecafp := to_date('01/01/0001','dd/mm/rrrr');
      end;
            
      if ld_fecbon >= ld_fecafp then
         ld_fecdep := ld_fecbon;
      Else
         ld_fecdep := ld_fecafp;       
      End If;
      
      if ld_fecdep >= ld_fecpro then    
        --obtenemos la cantidad de retiros
        begin
          Select nvl(sum(a.aqpa121tot),0)    
            into ln_totret
            from aqpa121 a 
           where a.aqpa121fec <= ld_fecdep 
             and a.aqpa121pgc = P_N_PGCOD 
             and a.aqpa121mod = P_N_SCMOD 
             and a.aqpa121suc = P_N_SCSUC 
             and a.aqpa121mda = P_N_SCMDA 
             and a.aqpa121pap = P_N_SCPAP 
             and a.aqpa121cta = P_N_SCCTA 
             and a.aqpa121ope = P_N_SCOPER
             and a.aqpa121sub = P_N_SCSBOP
             and a.aqpa121top = P_N_SCTOPE;
        exception
        when others then
          ln_totret := 0;
        end;  
        ln_saldo := ln_totdep -  ln_totret;
        if ln_saldo <0 then
           ln_saldo := 0;
        End If;
      Else
         ln_saldo := 0;
      End If;    
    End if;  
  return ln_saldo;   
  end fn_ah_salafp;  
  Procedure sp_ah_salafp(P_N_PGCOD IN NUMBER,
                         P_N_SCMOD IN NUMBER,
                         P_N_SCSUC IN NUMBER,
                         P_N_SCMDA IN NUMBER,
                         P_N_SCPAP IN NUMBER,
                         P_N_SCCTA IN NUMBER,
                         P_N_SCOPER IN NUMBER,
                         P_N_SCSBOP IN NUMBER,
                         P_N_SCTOPE IN NUMBER,
                         p_n_salafp out number
                        ) is
  begin
    p_n_salafp := fn_ah_salafp(P_N_PGCOD, 
                               P_N_SCMOD, 
                               P_N_SCSUC, 
                               P_N_SCMDA, 
                               P_N_SCPAP, 
                               P_N_SCCTA, 
                               P_N_SCOPER,
                               P_N_SCSBOP,
                               P_N_SCTOPE
                               );
  end sp_ah_salafp;                        
end pq_ah_compensa_ctas;
/

